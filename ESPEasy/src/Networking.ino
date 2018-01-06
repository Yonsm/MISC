// Generic Networking routines
// Syslog
// UDP system messaging
// SSDP

/*********************************************************************************************\
   Syslog client
  \*********************************************************************************************/
void syslog(const char *message)
{
  if (Settings.Syslog_IP[0] != 0)
  {
    IPAddress broadcastIP(Settings.Syslog_IP[0], Settings.Syslog_IP[1], Settings.Syslog_IP[2], Settings.Syslog_IP[3]);
    portUDP.beginPacket(broadcastIP, 514);
    char str[256];
    str[0] = 0;
    snprintf_P(str, sizeof(str), PSTR("<7>ESP Unit: %u : %s"), Settings.Unit, message);
    portUDP.write(str);
    portUDP.endPacket();
  }
}


/*********************************************************************************************\
   Structs for UDP messaging
  \*********************************************************************************************/
struct infoStruct
{
  byte header = 255;
  byte ID = 3;
  byte sourcelUnit;
  byte destUnit;
  byte sourceTaskIndex;
  byte destTaskIndex;
  byte deviceNumber;
  char taskName[26];
  char ValueNames[VARS_PER_TASK][26];
};

struct dataStruct
{
  byte header = 255;
  byte ID = 5;
  byte sourcelUnit;
  byte destUnit;
  byte sourceTaskIndex;
  byte destTaskIndex;
  float Values[VARS_PER_TASK];
};

//TODO: add sysinfoStruct

/*********************************************************************************************\
   Check UDP messages (ESPEasy propiertary protocol)
  \*********************************************************************************************/
void checkUDP()
{
  if (Settings.UDPPort == 0)
    return;

  // UDP events
  int packetSize = portUDP.parsePacket();
  if (packetSize)
  {
    statusLED(true);

    IPAddress remoteIP = portUDP.remoteIP();
    if (portUDP.remotePort() == 123)
    {
      // unexpected NTP reply, drop for now...
      return;
    }
    char packetBuffer[128];
    int len = portUDP.read(packetBuffer, 128);

    if (packetBuffer[0] != 255)
    {
      packetBuffer[len] = 0;
      addLog(LOG_LEVEL_DEBUG, packetBuffer);
      struct EventStruct TempEvent;
      String request = packetBuffer;
      parseCommandString(&TempEvent, request);
      TempEvent.Source = VALUE_SOURCE_SYSTEM;
      if (!PluginCall(PLUGIN_WRITE, &TempEvent, request))
        ExecuteCommand(VALUE_SOURCE_SYSTEM, packetBuffer);
    }
    else
    {
      if (packetBuffer[1] > 1 && packetBuffer[1] < 6)
      {
        String log = (F("UDP  : Sensor msg "));
        for (byte x = 1; x < 6; x++)
        {
          log += " ";
          log += (int)packetBuffer[x];
        }
        addLog(LOG_LEVEL_DEBUG_MORE, log);
      }

      // binary data!
      switch (packetBuffer[1])
      {

        //TODO: use a nice struct for it
        case 1: // sysinfo message
          {
            byte mac[6];
            byte ip[4];
            byte unit = packetBuffer[12];
            for (byte x = 0; x < 6; x++)
              mac[x] = packetBuffer[x + 2];
            for (byte x = 0; x < 4; x++)
              ip[x] = packetBuffer[x + 8];

            if (unit < UNIT_MAX)
            {
              for (byte x = 0; x < 4; x++)
                Nodes[unit].ip[x] = packetBuffer[x + 8];
              Nodes[unit].age = 0; // reset 'age counter'
              if (len >20) // extended packet size
              {
                Nodes[unit].build = packetBuffer[13] + 256*packetBuffer[14];
                if (Nodes[unit].nodeName==0)
                    Nodes[unit].nodeName =  (char *)malloc(26);
                memcpy(Nodes[unit].nodeName,(byte*)packetBuffer+15,25);
                Nodes[unit].nodeName[25]=0;
                Nodes[unit].nodeType = packetBuffer[40];
              }
            }

            char macaddress[20];
            sprintf_P(macaddress, PSTR("%02x:%02x:%02x:%02x:%02x:%02x"), mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
            char ipaddress[16];
            sprintf_P(ipaddress, PSTR("%u.%u.%u.%u"), ip[0], ip[1], ip[2], ip[3]);
            char log[80];
            sprintf_P(log, PSTR("UDP  : %s,%s,%u"), macaddress, ipaddress, unit);
            addLog(LOG_LEVEL_DEBUG_MORE, log);
            break;
          }

        case 2: // sensor info pull request
          {
            SendUDPTaskInfo(packetBuffer[2], packetBuffer[5], packetBuffer[4]);
            break;
          }

        case 3: // sensor info
          {
            if (Settings.GlobalSync)
            {
              struct infoStruct infoReply;
              memcpy((byte*)&infoReply, (byte*)&packetBuffer, sizeof(infoStruct));

              // to prevent flash wear out (bugs in communication?) we can only write to an empty task
              // so it will write only once and has to be cleared manually through webgui
              if (Settings.TaskDeviceNumber[infoReply.destTaskIndex] == 0)
              {
                Settings.TaskDeviceNumber[infoReply.destTaskIndex] = infoReply.deviceNumber;
                Settings.TaskDeviceDataFeed[infoReply.destTaskIndex] = 1;  // remote feed
                for (byte x=0; x < CONTROLLER_MAX; x++)
                  Settings.TaskDeviceSendData[x][infoReply.destTaskIndex] = false;
                strcpy(ExtraTaskSettings.TaskDeviceName, infoReply.taskName);
                for (byte x = 0; x < VARS_PER_TASK; x++)
                  strcpy( ExtraTaskSettings.TaskDeviceValueNames[x], infoReply.ValueNames[x]);
                SaveTaskSettings(infoReply.destTaskIndex);
                SaveSettings();
              }
            }
            break;
          }

        case 4: // sensor data pull request
          {
            SendUDPTaskData(packetBuffer[2], packetBuffer[5], packetBuffer[4]);
            break;
          }

        case 5: // sensor data
          {
            if (Settings.GlobalSync)
            {
              struct dataStruct dataReply;
              memcpy((byte*)&dataReply, (byte*)&packetBuffer, sizeof(dataStruct));

              // only if this task has a remote feed, update values
              if (Settings.TaskDeviceDataFeed[dataReply.destTaskIndex] != 0)
              {
                for (byte x = 0; x < VARS_PER_TASK; x++)
                {
                  UserVar[dataReply.destTaskIndex * VARS_PER_TASK + x] = dataReply.Values[x];
                }
                if (Settings.UseRules)
                  createRuleEvents(dataReply.destTaskIndex);
              }
            }
            break;
          }

        default:
          {
            struct EventStruct TempEvent;
            TempEvent.Data = (byte*)packetBuffer;
            TempEvent.Par1 = remoteIP[3];
            PluginCall(PLUGIN_UDP_IN, &TempEvent, dummyString);
            break;
          }
      }
    }
  }
}


/*********************************************************************************************\
   Send task info using UDP message
  \*********************************************************************************************/
void SendUDPTaskInfo(byte destUnit, byte sourceTaskIndex, byte destTaskIndex)
{
  struct infoStruct infoReply;
  infoReply.sourcelUnit = Settings.Unit;
  infoReply.sourceTaskIndex = sourceTaskIndex;
  infoReply.destTaskIndex = destTaskIndex;
  LoadTaskSettings(infoReply.sourceTaskIndex);
  infoReply.deviceNumber = Settings.TaskDeviceNumber[infoReply.sourceTaskIndex];
  strcpy(infoReply.taskName, ExtraTaskSettings.TaskDeviceName);
  for (byte x = 0; x < VARS_PER_TASK; x++)
    strcpy(infoReply.ValueNames[x], ExtraTaskSettings.TaskDeviceValueNames[x]);

  byte firstUnit = 1;
  byte lastUnit = UNIT_MAX - 1;
  if (destUnit != 0)
  {
    firstUnit = destUnit;
    lastUnit = destUnit;
  }
  for (byte x = firstUnit; x <= lastUnit; x++)
  {
    infoReply.destUnit = x;
    sendUDP(x, (byte*)&infoReply, sizeof(infoStruct));
    delay(10);
  }
  delay(50);
}


/*********************************************************************************************\
   Send task data using UDP message
  \*********************************************************************************************/
void SendUDPTaskData(byte destUnit, byte sourceTaskIndex, byte destTaskIndex)
{
  struct dataStruct dataReply;
  dataReply.sourcelUnit = Settings.Unit;
  dataReply.sourceTaskIndex = sourceTaskIndex;
  dataReply.destTaskIndex = destTaskIndex;
  for (byte x = 0; x < VARS_PER_TASK; x++)
    dataReply.Values[x] = UserVar[dataReply.sourceTaskIndex * VARS_PER_TASK + x];

  byte firstUnit = 1;
  byte lastUnit = UNIT_MAX - 1;
  if (destUnit != 0)
  {
    firstUnit = destUnit;
    lastUnit = destUnit;
  }
  for (byte x = firstUnit; x <= lastUnit; x++)
  {
    dataReply.destUnit = x;
    sendUDP(x, (byte*) &dataReply, sizeof(dataStruct));
    delay(10);
  }
  delay(50);
}


/*********************************************************************************************\
   Send event using UDP message
  \*********************************************************************************************/
void SendUDPCommand(byte destUnit, char* data, byte dataLength)
{
  byte firstUnit = 1;
  byte lastUnit = UNIT_MAX - 1;
  if (destUnit != 0)
  {
    firstUnit = destUnit;
    lastUnit = destUnit;
  }
  for (int x = firstUnit; x <= lastUnit; x++)
  {
    sendUDP(x, (byte*)data, dataLength);
    delay(10);
  }
  delay(50);
}


/*********************************************************************************************\
   Send UDP message (unit 255=broadcast)
  \*********************************************************************************************/
void sendUDP(byte unit, byte* data, byte size)
{
  if (unit != 255)
    if (Nodes[unit].ip[0] == 0)
      return;
  String log = "UDP  : Send UDP message to ";
  log += unit;
  addLog(LOG_LEVEL_DEBUG_MORE, log);

  statusLED(true);

  IPAddress remoteNodeIP;
  if (unit == 255)
    remoteNodeIP = {255,255,255,255};
  else
    remoteNodeIP = Nodes[unit].ip;
  portUDP.beginPacket(remoteNodeIP, Settings.UDPPort);
  portUDP.write(data, size);
  portUDP.endPacket();
}


/*********************************************************************************************\
   Refresh aging for remote units, drop if too old...
  \*********************************************************************************************/
void refreshNodeList()
{
  for (byte counter = 0; counter < UNIT_MAX; counter++)
  {
    if (Nodes[counter].ip[0] != 0)
    {
      Nodes[counter].age++;  // increment age counter
      if (Nodes[counter].age > 10) // if entry to old, clear this node ip from the list.
        for (byte x = 0; x < 4; x++)
          Nodes[counter].ip[x] = 0;
    }
  }
}

/*********************************************************************************************\
   Broadcast system info to other nodes. (to update node lists)
  \*********************************************************************************************/
void sendSysInfoUDP(byte repeats)
{
  char log[80];
  if (Settings.UDPPort == 0)
    return;

  // TODO: make a nice struct of it and clean up
  // 1 byte 'binary token 255'
  // 1 byte id '1'
  // 6 byte mac
  // 4 byte ip
  // 1 byte unit
  // 2 byte build
  // 25 char name
  // 1 byte node type id

  // send my info to the world...
  strcpy_P(log, PSTR("UDP  : Send Sysinfo message"));
  addLog(LOG_LEVEL_DEBUG_MORE, log);
  for (byte counter = 0; counter < repeats; counter++)
  {
    uint8_t mac[] = {0, 0, 0, 0, 0, 0};
    uint8_t* macread = WiFi.macAddress(mac);
    byte data[80];
    data[0] = 255;
    data[1] = 1;
    for (byte x = 0; x < 6; x++)
      data[x + 2] = macread[x];
    IPAddress ip = WiFi.localIP();
    for (byte x = 0; x < 4; x++)
      data[x + 8] = ip[x];
    data[12] = Settings.Unit;
    data[13] = Settings.Build & 0xff;
    data[14] = Settings.Build >> 8;
    memcpy((byte*)data+15,Settings.Name,25);
    data[40] = NODE_TYPE_ID;
    statusLED(true);

    IPAddress broadcastIP(255, 255, 255, 255);
    portUDP.beginPacket(broadcastIP, Settings.UDPPort);
    portUDP.write(data, 80);
    portUDP.endPacket();
    if (counter < (repeats - 1))
      delay(500);
  }

  // store my own info also in the list...
  if (Settings.Unit < UNIT_MAX)
  {
    IPAddress ip = WiFi.localIP();
    for (byte x = 0; x < 4; x++)
      Nodes[Settings.Unit].ip[x] = ip[x];
    Nodes[Settings.Unit].age = 0;
    Nodes[Settings.Unit].build = Settings.Build;
    Nodes[Settings.Unit].nodeType = NODE_TYPE_ID;
  }
}


/********************************************************************************************\
  Respond to HTTP XML requests for SSDP information
  \*********************************************************************************************/
void SSDP_schema(WiFiClient client) {

  IPAddress ip = WiFi.localIP();
  char str[20];
  sprintf_P(str, PSTR("%u.%u.%u.%u"), ip[0], ip[1], ip[2], ip[3]);
  uint32_t chipId = ESP.getChipId();
  char uuid[64];
  sprintf_P(uuid, PSTR("38323636-4558-4dda-9188-cda0e6%02x%02x%02x"),
            (uint16_t) ((chipId >> 16) & 0xff),
            (uint16_t) ((chipId >>  8) & 0xff),
            (uint16_t)   chipId        & 0xff  );

  String ssdp_schema = F(
                         "HTTP/1.1 200 OK\r\n"
                         "Content-Type: text/xml\r\n"
                         "Connection: close\r\n"
                         "Access-Control-Allow-Origin: *\r\n"
                         "\r\n"
                         "<?xml version=\"1.0\"?>"
                         "<root xmlns=\"urn:schemas-upnp-org:device-1-0\">"
                         "<specVersion>"
                         "<major>1</major>"
                         "<minor>0</minor>"
                         "</specVersion>"
                         "<URLBase>http://");
  ssdp_schema += str;
  ssdp_schema += F(":80/</URLBase>"
                   "<device>"
                   "<deviceType>urn:schemas-upnp-org:device:BinaryLight:1</deviceType>"
                   "<friendlyName>");
  ssdp_schema += Settings.Name;
  ssdp_schema += F("</friendlyName>"
                   "<presentationURL>/</presentationURL>"
                   "<serialNumber>");
  ssdp_schema += ESP.getChipId();
  ssdp_schema += F("</serialNumber>"
                   "<modelName>ESP Easy</modelName>"
                   "<modelNumber>");
  ssdp_schema += BUILD_GIT;
  ssdp_schema += F("</modelNumber>"
                   "<modelURL>http://www.letscontrolit.com</modelURL>"
                   "<manufacturer>http://www.letscontrolit.com</manufacturer>"
                   "<manufacturerURL>http://www.letscontrolit.com</manufacturerURL>"
                   "<UDN>uuid:");
  ssdp_schema += uuid;
  ssdp_schema += F("</UDN></device>"
                   "</root>\r\n"
                   "\r\n");

  client.printf(ssdp_schema.c_str());
}


/********************************************************************************************\
  Global SSDP stuff
  \*********************************************************************************************/
typedef enum {
  NONE,
  SEARCH,
  NOTIFY
} ssdp_method_t;

UdpContext* _server;

IPAddress _respondToAddr;
uint16_t  _respondToPort;

bool _pending;
unsigned short _delay;
unsigned long _process_time;
unsigned long _notify_time;

#define SSDP_INTERVAL     1200
#define SSDP_PORT         1900
#define SSDP_METHOD_SIZE  10
#define SSDP_URI_SIZE     2
#define SSDP_BUFFER_SIZE  64
#define SSDP_MULTICAST_TTL 2

static const IPAddress SSDP_MULTICAST_ADDR(239, 255, 255, 250);


/********************************************************************************************\
  Launch SSDP listener and send initial notify
  \*********************************************************************************************/
bool SSDP_begin() {
  _pending = false;

  if (_server) {
    _server->unref();
    _server = 0;
  }

  _server = new UdpContext;
  _server->ref();

  ip_addr_t ifaddr;
  ifaddr.addr = WiFi.localIP();
  ip_addr_t multicast_addr;
  multicast_addr.addr = (uint32_t) SSDP_MULTICAST_ADDR;
  if (igmp_joingroup(&ifaddr, &multicast_addr) != ERR_OK ) {
    return false;
  }

  if (!_server->listen(*IP_ADDR_ANY, SSDP_PORT)) {
    return false;
  }

  _server->setMulticastInterface(ifaddr);
  _server->setMulticastTTL(SSDP_MULTICAST_TTL);
  _server->onRx(&SSDP_update);
  if (!_server->connect(multicast_addr, SSDP_PORT)) {
    return false;
  }

  SSDP_update();

  return true;
}


/********************************************************************************************\
  Send SSDP messages (notify & responses)
  \*********************************************************************************************/
void SSDP_send(byte method) {
  char buffer[1460];
  uint32_t ip = WiFi.localIP();

  uint32_t chipId = ESP.getChipId();

  char uuid[64];
  sprintf_P(uuid, PSTR("38323636-4558-4dda-9188-cda0e6%02x%02x%02x"),
            (uint16_t) ((chipId >> 16) & 0xff),
            (uint16_t) ((chipId >>  8) & 0xff),
            (uint16_t)   chipId        & 0xff  );

  String _ssdp_response_template = F(
                                     "HTTP/1.1 200 OK\r\n"
                                     "EXT:\r\n"
                                     "ST: upnp:rootdevice\r\n");

  String _ssdp_notify_template = F(
                                   "NOTIFY * HTTP/1.1\r\n"
                                   "HOST: 239.255.255.250:1900\r\n"
                                   "NT: upnp:rootdevice\r\n"
                                   "NTS: ssdp:alive\r\n");

  String _ssdp_packet_template = F(
                                   "%s" // _ssdp_response_template / _ssdp_notify_template
                                   "CACHE-CONTROL: max-age=%u\r\n" // SSDP_INTERVAL
                                   "SERVER: Arduino/1.0 UPNP/1.1 ESPEasy/%u\r\n" // _modelNumber
                                   "USN: uuid:%s\r\n" // _uuid
                                   "LOCATION: http://%u.%u.%u.%u:80/ssdp.xml\r\n" // WiFi.localIP(),
                                   "\r\n");

  int len = snprintf(buffer, sizeof(buffer),
                     _ssdp_packet_template.c_str(),
                     (method == 0) ? _ssdp_response_template.c_str() : _ssdp_notify_template.c_str(),
                     SSDP_INTERVAL,
                     Settings.Build,
                     uuid,
                     IP2STR(&ip)
                    );

  _server->append(buffer, len);

  ip_addr_t remoteAddr;
  uint16_t remotePort;
  if (method == 0) {
    remoteAddr.addr = _respondToAddr;
    remotePort = _respondToPort;
  } else {
    remoteAddr.addr = SSDP_MULTICAST_ADDR;
    remotePort = SSDP_PORT;
  }
  _server->send(&remoteAddr, remotePort);
  statusLED(true);
}


/********************************************************************************************\
  SSDP message processing
  \*********************************************************************************************/
void SSDP_update() {

  if (!_pending && _server->next()) {
    ssdp_method_t method = NONE;

    _respondToAddr = _server->getRemoteAddress();
    _respondToPort = _server->getRemotePort();

    typedef enum {METHOD, URI, PROTO, KEY, VALUE, ABORT} states;
    states state = METHOD;

    typedef enum {START, MAN, ST, MX} headers;
    headers header = START;

    uint8_t cursor = 0;
    uint8_t cr = 0;

    char buffer[SSDP_BUFFER_SIZE] = {0};

    while (_server->getSize() > 0) {
      char c = _server->read();

      (c == '\r' || c == '\n') ? cr++ : cr = 0;

      switch (state) {
        case METHOD:
          if (c == ' ') {
            if (strcmp_P(buffer, PSTR("M-SEARCH")) == 0) method = SEARCH;
            else if (strcmp_P(buffer, PSTR("NOTIFY")) == 0) method = NOTIFY;

            if (method == NONE) state = ABORT;
            else state = URI;
            cursor = 0;

          } else if (cursor < SSDP_METHOD_SIZE - 1) {
            buffer[cursor++] = c;
            buffer[cursor] = '\0';
          }
          break;
        case URI:
          if (c == ' ') {
            if (strcmp(buffer, "*")) state = ABORT;
            else state = PROTO;
            cursor = 0;
          } else if (cursor < SSDP_URI_SIZE - 1) {
            buffer[cursor++] = c;
            buffer[cursor] = '\0';
          }
          break;
        case PROTO:
          if (cr == 2) {
            state = KEY;
            cursor = 0;
          }
          break;
        case KEY:
          if (cr == 4) {
            _pending = true;
            _process_time = millis();
          }
          else if (c == ' ') {
            cursor = 0;
            state = VALUE;
          }
          else if (c != '\r' && c != '\n' && c != ':' && cursor < SSDP_BUFFER_SIZE - 1) {
            buffer[cursor++] = c;
            buffer[cursor] = '\0';
          }
          break;
        case VALUE:
          if (cr == 2) {
            switch (header) {
              case START:
                break;
              case MAN:
                break;
              case ST:
                if (strcmp_P(buffer, PSTR("ssdp:all"))) {
                  state = ABORT;
                }
                // if the search type matches our type, we should respond instead of ABORT
                if (strcmp_P(buffer, PSTR("urn:schemas-upnp-org:device:BinaryLight:1")) == 0) {
                  _pending = true;
                  _process_time = millis();
                  state = KEY;
                }
                break;
              case MX:
                _delay = random(0, atoi(buffer)) * 1000L;
                break;
            }

            if (state != ABORT) {
              state = KEY;
              header = START;
              cursor = 0;
            }
          } else if (c != '\r' && c != '\n') {
            if (header == START) {
              if (strncmp(buffer, "MA", 2) == 0) header = MAN;
              else if (strcmp(buffer, "ST") == 0) header = ST;
              else if (strcmp(buffer, "MX") == 0) header = MX;
            }

            if (cursor < SSDP_BUFFER_SIZE - 1) {
              buffer[cursor++] = c;
              buffer[cursor] = '\0';
            }
          }
          break;
        case ABORT:
          _pending = false; _delay = 0;
          break;
      }
    }
  }

  if (_pending && (millis() - _process_time) > _delay) {
    _pending = false; _delay = 0;
    SSDP_send(NONE);
  } else if (_notify_time == 0 || (millis() - _notify_time) > (SSDP_INTERVAL * 1000L)) {
    _notify_time = millis();
    SSDP_send(NOTIFY);
  }

  if (_pending) {
    while (_server->next())
      _server->flush();
  }

}
