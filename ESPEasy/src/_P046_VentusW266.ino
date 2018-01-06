//#######################################################################################################
//#################################### Plugin 046: Ventus W266 [Testing] ################################
//#######################################################################################################

// Purpose: Sniff the data received by the Ventus W266 display unit and send it to Domoticz
// Status : "Initial release"

// This plugin can be used on a esp8266 connected to the recievermodule inside a Ventus W266 or
// Renkforce W205GU display unit. The plugin then reads the data send from the remote sensorunit and
// can send the data to Domoticz or an other controller. The plugin does not read the data of the
// sensors in the display unit such as indoor temperature and airpressure.

// The displaynit has a RFM31 reciever but the pinout of this receiver is identical to the pinout
// of a RFM01 reciever. We need to connect 4 wires to read the SPI exchange between the host and the
// reciever. Because we need to read both MOSI and MISO signals the hardware SPI is unusable and we
// use bitbanging to achive the same result.

// Connect pins 5-8 from the "RFM31BJ-S1" to the pins you defined in de webgui.
// Pinout of the RFM31: 5-MOSI, 6-SCLK, 7-nSEL (active low CS), 8-MISO, 14-GND.
// In my original setup these were connected to 4, 12, 14 and 5.
// Try to avoid GPIO 15 as nSEL line because if the line is high during a reboot, and it is mostly high,
// the boot will fail!

// The Ventus W266 remote has the following sensor outputs:
// Humidity, Temperature, Wind direction, Wind avarage, Wind gust, Rainfall, UV and Lightning. That is
// more than te maximum of 4 values per device for espeasy. The plugins functionality is therefore
// devided per sensorgroup. To read all the sensor data you need to run 6 instances of the plugin.

// The plugin can (and should) be used more then one time, however only one plugin instance can be
// the main plugin. The plugin function can be selected by a dropdown and only the main plugin has
// the ability to set the I/O lines.

// The plugin uses two buffers, ine for the ISR routines and one for the other plugin instances.

// This plugin was originally released into th eplayground as Plugin 186, it is assimilated into the core as 046.
// Why plugin nr 186? Well 266 is not possible, 206 (id on the back of the unit) is nit within the
// playground range and the W186 is an additinal external thermometer for the Ventus W266.
// The Ventus W266 is also known as the Renkforce W205GU.

// TaskDevicePluginConfig[x][0] = Instance function
// TaskDevicePluginConfig[x][1] = MOSI (eg. GPOI pin 4)
// TaskDevicePluginConfig[x][2] = SCLK (eg. GPIO pin 12)
// TaskDevicePluginConfig[x][3] = nSEL (eg. GPIO pin 14)
// TaskDevicePluginConfig[x][4] = MISO (eg. GPIO pin 5)
// If you use GPIO 4&5, please disable the I2C/SPI option in the hardware tab.

// The buffers contain the following data:
// hhIDhh 1A tlth ?b tlth wb alahglgh rlrh?? uv ld?? lllhcrc
// 7F9827 1A B100 00 B100 06 00000000 1E0000 00 3F8A 2A0017
//  0 1 2  3  4 5  6  7 8  9  0 1 2 3  4 5 6  7  8 9  0 1 2
// hh=header > This is actualy not part of the real payload but a wanted artifact of the sniffing method.
// hh=humidity (bcd) > Humidity is bcd encoded
// tlth=temperature-low/temphigh (*10) > Temperature is stored as a 16bit integer holding the temperature in Celcius * 10 but low byte first.
// b=battery (1=low) > This byte is 00 but 01 when the battery of the transmitter runs low
// wb=bearing (cw0-15) > The windbearing in 16 clockwise steps (0 = north, 4 = east, 8 = south and C = west)
// alah=windaverage-low/high (m/s/2) > A 16 bit int holding the wind avarage in m/s * 2, low byte first
// rlrh=rainfall-low/high (1/4mm) > A 16 bit int holding the wind gust in m/s * 2, low byte first
// uv=uvindex (*10) > The UV value * 10
// ld=lightningstorm-distance (km, 3F is max) > The distance to the stormfront in km
// lllh=strikecount-low/high (#) > A 16 bit integer holding the number of detected lightning strikes, low byte first
// crc > poly 0x31, init 0xff, revin&revout, xorout 0x00. Like Maxim 1-wire but with a 0xff initvalue. Crc is calculated over bytes 1-22

// Events:
//   None

// Commands:
//   None

// Current state / limitations:
//    1.0 Initial release. All values are always visible although sometimes only one is really used with domoticz.
//        Needs work on a sliding window for the lightning detection.
//        When porting be beware of the fact that the esp8266 uses 4 bytes as an int when reading the temperature.
//
// This plugin is based on the work of the Plugin 199: RF KaKu receiver/sender and Plugin 026: Analog.
// CRC calculation is based on the works by Paul Stoffregen from the 1-Wire arduino library. Special
// thanks to Greg Cook and the team behind reveng.sourceforge.net.

//edwin: Disabled for now: hardware is not generic enough and  uses lots of ram and iram, 
#ifdef PLUGIN_BUILD_DISABLED
// #ifdef PLUGIN_BUILD_TESTING

#define PLUGIN_046_DEBUG            true                        // Shows recieved frames and crc in log@INFO

#define PLUGIN_046                                              // Mandatory framework constants
#define PLUGIN_ID_046               46
#define PLUGIN_NAME_046             "Ventus W266 [TESTING]"
#define PLUGIN_VALUENAME1_046       ""
#define PLUGIN_VALUENAME2_046       ""
#define PLUGIN_VALUENAME3_046       ""

#define Plugin_046_MagicByte        0x7F                        // When we read this byte on MOSI, switch to MISO
#define Plugin_046_RAW_BUFFER_SIZE  24                          // Payload is 23 bytes, added space for header
#define Plugin_046_Payload          23

int8_t Plugin_046_MOSIpin = -1;                                 // GPIO pins
int8_t Plugin_046_SCLKpin = -1;
int8_t Plugin_046_nSELpin = -1;
int8_t Plugin_046_MISOpin = -1;
                                                                // Vars used in data collection:
byte Plugin_046_ISR_Buffer[Plugin_046_RAW_BUFFER_SIZE];         // Buffer used in ISR routine
//Test data: volatile byte Plugin_046_databuffer[] = {0x7F, 0x98, 0x33, 0x1A, 0xB0, 0x00, 0x00, 0xB0, 0x00, 0x0E, 0x00, 0x00, 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0x3F, 0x8A, 0x25, 0x00, 0x49, 0x00}; // Buffer used by other instances
byte Plugin_046_databuffer[Plugin_046_RAW_BUFFER_SIZE];         // Buffer used by other instances
boolean Plugin_046_RecieveActive = false;                       // Active session in progress
boolean Plugin_046_MasterSlave = false;                         // Which pin o read? false=MOSI, true=MISO
boolean Plugin_046_newData = false;                             // "Valid" data ready, please process
byte Plugin_046_bitpointer;                                     // Pointer for recieved bit
byte Plugin_046_bytepointer;                                    // Pointe for ISR recieve buffer
byte Plugin_046_recievedData;                                   // Byte to store recieved bits

                                                                // Vars used for interpreting the data:
volatile unsigned long Plugin_046_lastrainctr;                  // Keep track of wdcounter (1/2 min tick)
volatile int Plugin_046_lastraincount;                          // Last rain count
volatile float Plugin_046_rainmmph = 0;
volatile unsigned long Plugin_046_laststrikectr;                // Keep track of wdcounter (1/2 min tick)
volatile unsigned int Plugin_046_laststrikecount;               // Last number of strikes
volatile int Plugin_046_strikesph = 0;

void Plugin_046_ISR_nSEL() ICACHE_RAM_ATTR;                     // Interrupt routines
void Plugin_046_ISR_SCLK() ICACHE_RAM_ATTR;

boolean Plugin_046(byte function, struct EventStruct *event, String& string)
{
  boolean success = false;

  switch (function)
  {
    case PLUGIN_DEVICE_ADD:
      {
        Device[++deviceCount].Number = PLUGIN_ID_046;
        Device[deviceCount].Type = DEVICE_TYPE_DUMMY;           // Nothing else really fit the bill ...
        Device[deviceCount].VType = SENSOR_TYPE_DUAL;           // New type, see ESPEasy.ino
        Device[deviceCount].Ports = 0;
        Device[deviceCount].PullUpOption = false;
        Device[deviceCount].InverseLogicOption = false;
        Device[deviceCount].FormulaOption = true;
        Device[deviceCount].SendDataOption = true;
        Device[deviceCount].ValueCount = 3;
        break;
      }

    case PLUGIN_WEBFORM_LOAD:
      {
        byte choice = Settings.TaskDevicePluginConfig[event->TaskIndex][0];
        byte nrchoices = 9;
        String options[nrchoices];
        options[0] = F("Main + Temp/Hygro");
        options[1] = F("Wind");
        options[2] = F("Rain");
        options[3] = F("UV");
        options[4] = F("Lightning strikes");
        options[5] = F("Lightning distance");

        options[6] = F("Unknown 1, byte 6");
        options[7] = F("Unknown 2, byte 16");
        options[8] = F("Unknown 3, byte 19");

        addFormSelector(string, F("Plugin function"), F("plugin_046"), nrchoices, options, NULL, choice);

        if (choice==0) {
          string += F("<TR><TD>1st GPIO (5-MOSI):<TD>");
          addPinSelect(false, string, "taskdevicepin1", Settings.TaskDevicePluginConfig[event->TaskIndex][1]);
          string += F("<TR><TD>2nd GPIO (6-SCLK):<TD>");
          addPinSelect(false, string, "taskdevicepin2", Settings.TaskDevicePluginConfig[event->TaskIndex][2]);
          string += F("<TR><TD>3rd GPIO (7-nSEL):<TD>");
          addPinSelect(false, string, "taskdevicepin3", Settings.TaskDevicePluginConfig[event->TaskIndex][3]);
          string += F("<TR><TD>4th GPIO (8-MISO):<TD>");
          addPinSelect(false, string, "taskdeviceport", Settings.TaskDevicePluginConfig[event->TaskIndex][4]);
        }

        switch (choice)
        {
          case (0):
          {
            string += F("<TR><TD><B>Be sure you only have 1 main plugin!</B></TD>");
            string += F("<TR><TD>Value 1: Temperature, 1 decimal<BR>Value 2: Humidity, 0 decimals");
            string += F("<BR>Value 3: not used</TD>");
            break;
          }
          case (1):
          {
            string += F("<TR><TD>Value 1: Direction, 0 decimals<BR>");
            string += F("Value 2: Average, 1 decimal<Br>Value 3: Gust, 1 decimal</TD>");
            break;
          }
          case (2):
          {
            string += F("<TR><TD>Value 1: Rain in mm per hour<BR>Value 2: Total rain in mm");
            string += F("<BR>Value 3: not used</TD>");
            break;
          }
          case (3):
          {
            string += F("<TR><TD>Value 1: UV, 1 decimal");
            string += F("<BR>Values 2, 3</TD>");
            break;
          }
          case (4):
          {
            string += F("<TR><TD>Value 1: Strikes this hour, 0 decimals");
            string += F("<BR>Values 2, 3: not used</TD>");
            break;
          }
          case (5):
          {
            string += F("<TR><TD>Value 1: Distance in km, 0 decimals");
            string += F("<BR>Values 2, 3: not used</TD>");
            break;
          }
          case (6):
          {
            string += F("<TR><TD>Value 1: Batterybyte, 0 decimals");
            string += F("<BR>Values 2, 3: not used</TD>");
            break;
          }
          case (7):
          {
            string += F("<TR><TD>Value 1: Last rainbyte, 0 decimals");
            string += F("<BR>Values 2, 3: not used</TD>");
            break;
          }
          case (8):
          {
            string += F("<TR><TD>Value 1: Last lightningbyte, 0 decimals");
            string += F("<BR>Values 2, 3: not used</TD>");
            break;
          }
        }

        success = true;
        break;
      }

    case PLUGIN_WEBFORM_SAVE:
      {
        Settings.TaskDevicePluginConfig[event->TaskIndex][0] = getFormItemInt(F("plugin_046"));
        if (Settings.TaskDevicePluginConfig[event->TaskIndex][0] == 0) {
          Settings.TaskDevicePluginConfig[event->TaskIndex][1] = getFormItemInt(F("taskdevicepin1"));
          Settings.TaskDevicePluginConfig[event->TaskIndex][2] = getFormItemInt(F("taskdevicepin2"));
          Settings.TaskDevicePluginConfig[event->TaskIndex][3] = getFormItemInt(F("taskdevicepin3"));
          Settings.TaskDevicePluginConfig[event->TaskIndex][4] = getFormItemInt(F("taskdeviceport"));
        }
        success = true;
        break;
      }

    case PLUGIN_GET_DEVICENAME:
      {
        string = F(PLUGIN_NAME_046);
        break;
      }

    case PLUGIN_GET_DEVICEVALUENAMES:
      {
        strcpy_P(ExtraTaskSettings.TaskDeviceValueNames[0], PSTR(PLUGIN_VALUENAME1_046));
        strcpy_P(ExtraTaskSettings.TaskDeviceValueNames[1], PSTR(PLUGIN_VALUENAME2_046));
        strcpy_P(ExtraTaskSettings.TaskDeviceValueNames[2], PSTR(PLUGIN_VALUENAME3_046));
        break;
      }

    case PLUGIN_INIT:
      {
        byte choice = Settings.TaskDevicePluginConfig[event->TaskIndex][0];
        switch (choice)
        {
          case (0):
          {
            Plugin_046_MOSIpin = Settings.TaskDevicePluginConfig[event->TaskIndex][1];
            Plugin_046_SCLKpin = Settings.TaskDevicePluginConfig[event->TaskIndex][2];
            Plugin_046_nSELpin = Settings.TaskDevicePluginConfig[event->TaskIndex][3];
            Plugin_046_MISOpin = Settings.TaskDevicePluginConfig[event->TaskIndex][4];
            int8_t total = Plugin_046_MOSIpin + Plugin_046_SCLKpin + Plugin_046_nSELpin + Plugin_046_MISOpin;
            if (total > 6) {                                    // All pins configured?
              pinMode(Plugin_046_MOSIpin, INPUT);
              pinMode(Plugin_046_SCLKpin, INPUT);
              pinMode(Plugin_046_nSELpin, INPUT);
              pinMode(Plugin_046_MISOpin, INPUT);
              Plugin_046_databuffer[0] = 0;                    // buffer is "empty"
              Plugin_046_lastrainctr = 0;
              Plugin_046_lastraincount = -1;
              Plugin_046_laststrikectr = 0;
              Plugin_046_laststrikecount = -1;
              attachInterrupt(Plugin_046_SCLKpin, Plugin_046_ISR_SCLK, RISING);
              attachInterrupt(Plugin_046_nSELpin, Plugin_046_ISR_nSEL, CHANGE);
            }
            break;
          }
        }
        break;
      }

    case PLUGIN_TEN_PER_SECOND:
      {
        if (Settings.TaskDevicePluginConfig[event->TaskIndex][0] == 0) {
          if (Plugin_046_newData) {
            uint8_t crc = 0xff;                                             // init = 0xff
            char data; // CRC = MAXIM with modified init: poly 0x31, init 0xff, refin 1; refout 1, xorout 0x00
            // Copy recieved data to buffer and check CRC
            Plugin_046_databuffer[0] = Plugin_046_ISR_Buffer[0];
            for (int i = 1; i < Plugin_046_bytepointer; i++) {
              data = Plugin_046_ISR_Buffer[i];
              Plugin_046_databuffer[i] = data;
              for (int j = 0; j < 8; j++)                                       // crc routine from Jim Studt
              {                                                             // Onewire library
                uint8_t mix = (crc ^ data) & 0x01;
                crc >>= 1;
                if (mix) crc ^= 0x8C;
                  data >>= 1;
              }
            }
            Plugin_046_MasterSlave = false;
            Plugin_046_newData = false;
            if (PLUGIN_046_DEBUG) {
              String log = F("Ventus W266 Rcvd(");
              log += getTimeString(':');
              log += F(") ");
              for (int i = 0; i < Plugin_046_Payload; i++) {
                if ((i==2)||(i==3)||(i==4)||(i==9)||(i==10)||(i==14)||(i==17)||(i==18)||(i==20)) {
                  log += F(":");
                }
                char myHex = (Plugin_046_databuffer[i] >> 4) + 0x30;
                if (myHex > 0x39) { myHex += 7; }
                log += myHex;
                myHex = (Plugin_046_databuffer[i] & 0x0f) + 0x30;
                if (myHex > 0x39) { myHex += 7; }
                log += myHex;
              }
              log += F(" > ");
              char myHex = (crc >> 4) + 0x30;
              if (myHex > 0x39) { myHex += 7; }
              log += myHex;
              myHex = (crc & 0x0f) + 0x30;
              if (myHex > 0x39) { myHex += 7; }
              log += myHex;
              addLog(LOG_LEVEL_INFO, log);
            }
            if (crc != 00)
            {
              Plugin_046_databuffer[0] = 0;                   // Not MagicByte, so not valid.
            }
          }
        }
        success = true;
        break;
      }

    case PLUGIN_READ:
      {
        if (Plugin_046_databuffer[0] == Plugin_046_MagicByte) // buffer[0] should be the MagicByte if valid
        {
          UserVar[event->BaseVarIndex + 1] = 0;
          byte choice = Settings.TaskDevicePluginConfig[event->TaskIndex][0];   // Which instance?
          switch (choice)
          {
            case (0):
            {
              int myTemp = int((Plugin_046_databuffer[5] * 256) + Plugin_046_databuffer[4]);
              if (myTemp > 0x8000) { myTemp |= 0xffff0000; }                    // int @ esp8266 = 32 bits!
              float temperature = float(myTemp) / 10.0; // Temperature
              byte myHum = (Plugin_046_databuffer[2] >> 4) * 10 + (Plugin_046_databuffer[2] & 0x0f);
              float humidity = float(myHum);
              UserVar[event->BaseVarIndex] = temperature;
              UserVar[event->BaseVarIndex + 1] = humidity;
              event->sensorType = SENSOR_TYPE_TEMP_HUM;
              break;
            }
            case (1):
            {
              float average = float((Plugin_046_databuffer[11] << 8) + Plugin_046_databuffer[10]) / 10;   // Wind speed average in m/s
              float gust = float((Plugin_046_databuffer[13] << 8) + Plugin_046_databuffer[12]) / 10;      // Wind speed gust in m/s
              float bearing = float(Plugin_046_databuffer[9] & 0x0f) * 22.5;                              // Wind bearing (0-359)
              UserVar[event->BaseVarIndex] = bearing;                                                     // degrees
              UserVar[event->BaseVarIndex + 1] = average;
              UserVar[event->BaseVarIndex + 2] = gust;
              event->sensorType = SENSOR_TYPE_WIND;
              break;
            }
            case (2):
            {
              float raincnt = float(((Plugin_046_databuffer[15]) * 256 + Plugin_046_databuffer[14]) / 4);
              int rainnow = int(raincnt);
              if (wdcounter < Plugin_046_lastrainctr) { Plugin_046_lastrainctr = wdcounter; }
              if (Plugin_046_lastrainctr > (wdcounter + 10))                      // 5 min interval
              {
                Plugin_046_lastrainctr = wdcounter;
                if (rainnow > Plugin_046_lastraincount)
                {                                                                 // per 5 min * 12 = per hour
                  Plugin_046_rainmmph = float(rainnow - Plugin_046_lastraincount) * 12;
                  Plugin_046_lastraincount = rainnow;
                } else {
                  Plugin_046_rainmmph = 0;
                }
              }
              UserVar[event->BaseVarIndex] = Plugin_046_rainmmph;
              UserVar[event->BaseVarIndex + 1] = raincnt;
              break;
            }
            case (3):
            {
              float uvindex = float((Plugin_046_databuffer[17]) / 10);
              UserVar[event->BaseVarIndex] = uvindex;
              break;
            }
            case (4):
            {
              // int strikes = 0;
              int strikesnow = int((Plugin_046_databuffer[21]) * 256 + Plugin_046_databuffer[20]);
              if (wdcounter < Plugin_046_laststrikectr) { Plugin_046_laststrikectr = wdcounter; }
              if (Plugin_046_laststrikectr > (wdcounter + 10))                   // 5 min interval
              {
                Plugin_046_laststrikectr = wdcounter;
                if (strikesnow > Plugin_046_laststrikecount)
                {
                  Plugin_046_strikesph = strikesnow - Plugin_046_laststrikecount;
                  Plugin_046_laststrikecount = strikesnow;
                } else {
                  Plugin_046_strikesph = 0;
                }
              }
              UserVar[event->BaseVarIndex] = float(Plugin_046_strikesph);
              break;
            }
            case (5):
            {
              float distance = float(-1);
              if (Plugin_046_databuffer[18] != 0x3F )
              {
                distance = float(Plugin_046_databuffer[18]);
              }
              UserVar[event->BaseVarIndex] = distance;
              break;
            }
            case (6):
            {
              UserVar[event->BaseVarIndex] = float(Plugin_046_databuffer[6]);
              break;
            }
            case (7):
            {
              UserVar[event->BaseVarIndex] = float(Plugin_046_databuffer[16]);
              break;
            }
            case (8):
            {
              UserVar[event->BaseVarIndex] = float(Plugin_046_databuffer[19]);
              break;
            }
          }   // switch
          success = true;
        } else {
          success = false;  // No data received yet or incorrect CRC so do not publish any data
        }
        break;
      }       // case READ
    }         // switch
    return success;
}

void Plugin_046_ISR_nSEL()                                      // Interrupt on nSEL change
  {
    if (digitalRead(Plugin_046_nSELpin)) {
      Plugin_046_RecieveActive = false;                         // nSEL high? Recieve done.
      if (Plugin_046_MasterSlave) {                             // If MISO not active, no data recieved
        if (Plugin_046_bytepointer == Plugin_046_Payload) {     // If not 23 then bad datapacket
          Plugin_046_newData = true;                            // We have new data!
        }
      }
    } else {                                                    // nSEL low? Start recieve
      if (!Plugin_046_newData) {                                // Only accept new data if the old is processed
        Plugin_046_bitpointer = 7;                              // reset pointer (MSB first)
        Plugin_046_bytepointer = 0;                             // reset pointers & flags
        Plugin_046_MasterSlave = false;
        Plugin_046_RecieveActive = true;                        // We are now recieving data
      }
    }
  }

void Plugin_046_ISR_SCLK()                                      // Interrupt on SCLK rising
  {
    if (Plugin_046_RecieveActive) {                             // Are we recieving or glitch?
      if (Plugin_046_MasterSlave) {                             // Read MISO or MOSI?
        bitWrite(Plugin_046_recievedData, Plugin_046_bitpointer, digitalRead(Plugin_046_MISOpin));
      } else {
        bitWrite(Plugin_046_recievedData, Plugin_046_bitpointer, digitalRead(Plugin_046_MOSIpin));
      }
      if (Plugin_046_bitpointer == 0) {                         // 8 bits done?
        Plugin_046_bitpointer = 7;
        if (Plugin_046_recievedData==Plugin_046_MagicByte) {    // Switch data pins?
          Plugin_046_MasterSlave = true;
        }
        Plugin_046_ISR_Buffer[Plugin_046_bytepointer] = Plugin_046_recievedData;
        Plugin_046_bytepointer++;                               // TReady for the next byte ...
        if (Plugin_046_bytepointer > Plugin_046_RAW_BUFFER_SIZE) {
          Plugin_046_RecieveActive = false;                     // We don't want a bufferoverflow, so abort
          Plugin_046_MasterSlave = false;
        }
      } else {
        Plugin_046_bitpointer--;                                // Not yet done with all bits ...
      }
    }
  }
#endif
