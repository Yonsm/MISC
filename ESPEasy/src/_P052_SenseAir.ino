//#######################################################################################################
//############################# Plugin 052: Senseair CO2 Sensors ########################################
//#######################################################################################################
/*
  Plugin originally written by: Daniel Tedenljung info__AT__tedenljungconsulting.com
  Rewritten by: Mikael Trieb mikael__AT__triebconsulting.se

  This plugin reads available values of Senseair Co2 Sensors.
  Datasheet can be found here:
  S8: http://www.senseair.com/products/oem-modules/senseair-s8/
  K30: http://www.senseair.com/products/oem-modules/k30/
  K70/tSENSE: http://www.senseair.com/products/wall-mount/tsense/

  Circuit wiring
    GPIO Setting 1 -> RX
    GPIO Setting 2 -> TX
    Use 1kOhm in serie on datapins!
*/

#define PLUGIN_052
#define PLUGIN_ID_052         52
#define PLUGIN_NAME_052       "Gases - CO2 Senseair"
#define PLUGIN_VALUENAME1_052 "CO2"

boolean Plugin_052_init = false;

#include <SoftwareSerial.h>
SoftwareSerial *Plugin_052_SoftSerial;

boolean Plugin_052(byte function, struct EventStruct *event, String& string)
{
  boolean success = false;

  switch (function)
  {

    case PLUGIN_DEVICE_ADD:
      {
        Device[++deviceCount].Number = PLUGIN_ID_052;
        Device[deviceCount].Type = DEVICE_TYPE_DUAL;
        Device[deviceCount].VType = SENSOR_TYPE_SINGLE;
        Device[deviceCount].Ports = 0;
        Device[deviceCount].PullUpOption = false;
        Device[deviceCount].InverseLogicOption = false;
        Device[deviceCount].FormulaOption = true;
        Device[deviceCount].ValueCount = 1;
        Device[deviceCount].SendDataOption = true;
        Device[deviceCount].TimerOption = true;
        Device[deviceCount].GlobalSyncOption = true;
        break;
      }

    case PLUGIN_GET_DEVICENAME:
      {
        string = F(PLUGIN_NAME_052);
        break;
      }

    case PLUGIN_GET_DEVICEVALUENAMES:
      {
        strcpy_P(ExtraTaskSettings.TaskDeviceValueNames[0], PSTR(PLUGIN_VALUENAME1_052));
        break;
      }

      case PLUGIN_WRITE:
          {
            String tmpString = string;

      			String cmd = parseString(tmpString, 1);
      			String param1 = parseString(tmpString, 2);


            if (cmd.equalsIgnoreCase(F("senseair_setrelay")))
            {
              if (param1.toInt() == 0 || param1.toInt() == 1 || param1.toInt() == -1) {
                Plugin_052_setRelayStatus(param1.toInt());
                addLog(LOG_LEVEL_INFO, String(F("Senseair command: relay=")) + param1);
              }
              success = true;
            }

            break;
          }

    case PLUGIN_WEBFORM_LOAD:
      {
          byte choice = Settings.TaskDevicePluginConfig[event->TaskIndex][0];
          String options[6] = { F("Error Status"), F("Carbon Dioxide"), F("Temperature"), F("Humidity"), F("Relay Status"), F("Temperature Adjustment") };
          addFormSelector(string, F("Sensor"), F("plugin_052"), 6, options, NULL, choice);

          success = true;
          break;
      }

    case PLUGIN_WEBFORM_SAVE:
      {
          String plugin1 = WebServer.arg(F("plugin_052"));
          Settings.TaskDevicePluginConfig[event->TaskIndex][0] = plugin1.toInt();
          success = true;
          break;
      }

    case PLUGIN_INIT:
      {
        Plugin_052_init = true;
        Plugin_052_SoftSerial = new SoftwareSerial(Settings.TaskDevicePin1[event->TaskIndex],
                                                   Settings.TaskDevicePin2[event->TaskIndex]);
        success = true;
        break;
      }

    case PLUGIN_READ:
      {

        if (Plugin_052_init)
        {

          String log = F("Senseair: ");
          switch(Settings.TaskDevicePluginConfig[event->TaskIndex][0])
          {
              case 0:
              {
                  int errorWord = Plugin_052_readErrorStatus();
                  for (size_t i = 0; i < 9; i++) {
                    if (bitRead(errorWord,i)) {
                      UserVar[event->BaseVarIndex] = i;
                      log += F("error code = ");
                      log += i;
                      break;
                    }
                  }

                  UserVar[event->BaseVarIndex] = -1;
                  log += F("error code = ");
                  log += -1;
                  break;
              }
              case 1:
              {
                  static unsigned int _lastCo2 = 0;
                  unsigned int readCo2 = Plugin_052_readCo2();
                  if (readCo2 >= 5000 || readCo2 < 100)
                  {
                    UserVar[event->BaseVarIndex] = _lastCo2;
                  }
                  else
                  {
                      UserVar[event->BaseVarIndex] = (readCo2 > _lastCo2 + 2000) ? _lastCo2 : readCo2;
                      _lastCo2 = readCo2;
                  }
                  log += F("co2 = ");
                  log += readCo2;
                  break;
              }
              case 2:
              {
                  float temperature = Plugin_052_readTemperature();
                  UserVar[event->BaseVarIndex] = (float)temperature;
                  log += F("temperature = ");
                  log += (float)temperature;
                  break;
              }
              case 3:
              {
                  float relativeHumidity = Plugin_052_readRelativeHumidity();
                  UserVar[event->BaseVarIndex] = (float)relativeHumidity;
                  log += F("humidity = ");
                  log += (float)relativeHumidity;
                  break;
              }
              case 4:
              {
                  int relayStatus = Plugin_052_readRelayStatus();
                  UserVar[event->BaseVarIndex] = relayStatus;
                  log += F("relay status = ");
                  log += relayStatus;
                  break;
              }
              case 5:
              {
                  int temperatureAdjustment = Plugin_052_readTemperatureAdjustment();
                  UserVar[event->BaseVarIndex] = temperatureAdjustment;
                  log += F("temperature adjustment = ");
                  log += temperatureAdjustment;
                  break;
              }
          }
          addLog(LOG_LEVEL_INFO, log);

          success = true;
          break;
        }
        break;
      }
  }
  return success;
}

void Plugin_052_buildFrame(byte slaveAddress,
              byte  functionCode,
              short startAddress,
              short numberOfRegisters,
              byte frame[8])
{
  frame[0] = slaveAddress;
  frame[1] = functionCode;
  frame[2] = (byte)(startAddress >> 8);
  frame[3] = (byte)(startAddress);
  frame[4] = (byte)(numberOfRegisters >> 8);
  frame[5] = (byte)(numberOfRegisters);
  // CRC-calculation
  byte checkSum[2] = {0};
  Plugin_052_ModRTU_CRC(frame, 6, checkSum);
  frame[6] = checkSum[0];
  frame[7] = checkSum[1];
}

int Plugin_052_sendCommand(byte command[])
{
  byte recv_buf[7] = {0xff};
  byte data_buf[2] = {0xff};
  long value       = -1;

  Plugin_052_SoftSerial->write(command, 8); //Send the byte array
  delay(50);

  // Read answer from sensor
  int ByteCounter = 0;
  while(Plugin_052_SoftSerial->available()) {
    recv_buf[ByteCounter] = Plugin_052_SoftSerial->read();
    ByteCounter++;
  }

  data_buf[0] = recv_buf[3];
  data_buf[1] = recv_buf[4];
  value = (data_buf[0] << 8) | (data_buf[1]);

  return value;
}

int Plugin_052_readErrorStatus(void)
{
  int errorBits = 0;
  int error_Status = -1;
  byte frame[8] = {0};
  Plugin_052_buildFrame(0xFE, 0x04, 0x00, 1, frame);
  errorBits = Plugin_052_sendCommand(frame);
  for (size_t i = 0; i < 15; i++) {
    if (getBitOfInt(errorBits, i) == 1) {
      error_Status = i;
    }
  }
  return error_Status;
}

int Plugin_052_readCo2(void)
{
  int co2 = 0;
  byte frame[8] = {0};
  Plugin_052_buildFrame(0xFE, 0x04, 0x03, 1, frame);
  co2 = Plugin_052_sendCommand(frame);
  return co2;
}

float Plugin_052_readTemperature(void)
{
  int temperatureX100 = 0;
  float temperature = 0.0;
  byte frame[8] = {0};
  Plugin_052_buildFrame(0xFE, 0x04, 0x04, 1, frame);
  temperatureX100 = Plugin_052_sendCommand(frame);
  temperature = (float)temperatureX100/100;
  return temperature;
}

float Plugin_052_readRelativeHumidity(void)
{
  int rhX100 = 0;
  float rh = 0.0;
  byte frame[8] = {0};
  Plugin_052_buildFrame(0xFE, 0x04, 0x05, 1, frame);
  rhX100 = Plugin_052_sendCommand(frame);
  rh = (float)rhX100/100;
  return rh;
}

int Plugin_052_readRelayStatus(void)
{
  int status = 0;
  bool result;
  byte frame[8] = {0};

  Plugin_052_buildFrame(0xFE, 0x04, 0x1C, 1, frame);
  status = Plugin_052_sendCommand(frame);
  result = status >> 8 & 0x1;

  return result;
}

int Plugin_052_readTemperatureAdjustment(void)
{
  int value = 0;
  byte frame[8] = {0};

  Plugin_052_buildFrame(0xFE, 0x04, 0x0A, 1, frame);
  value = Plugin_052_sendCommand(frame);

  return value;
}

void Plugin_052_setRelayStatus(int status) {
  // int response;
  byte frame[8] = {0};
  if (status == 0) {
    Plugin_052_buildFrame(0xFE, 0x06, 0x18, 0x0000, frame);
  } else if (status == 1){
    Plugin_052_buildFrame(0xFE, 0x06, 0x18, 0x3FFF, frame);
  } else {
    Plugin_052_buildFrame(0xFE, 0x06, 0x18, 0x7FFF, frame);
  }
  Plugin_052_sendCommand(frame);
}

// Compute the MODBUS RTU CRC
unsigned int Plugin_052_ModRTU_CRC(byte buf[], int len, byte checkSum[2])
{
  unsigned int crc = 0xFFFF;

  for (int pos = 0; pos < len; pos++) {
    crc ^= (unsigned int)buf[pos];          // XOR byte into least sig. byte of crc

    for (int i = 8; i != 0; i--) {    // Loop over each bit
      if ((crc & 0x0001) != 0) {      // If the LSB is set
        crc >>= 1;                    // Shift right and XOR 0xA001
        crc ^= 0xA001;
      }
      else                            // Else LSB is not set
        crc >>= 1;                    // Just shift right
    }
  }
  // Note, this number has low and high bytes swapped, so use it accordingly (or swap bytes)
  checkSum[1] = (byte)((crc >> 8) & 0xFF);
  checkSum[0] = (byte)(crc & 0xFF);
  return crc;
}

int getBitOfInt(int reg, int pos)
{
  // Create a mask
  int mask = 0x01 << pos;

  // Mask the status register
  int masked_register = mask & reg;

  // Shift the result of masked register back to position 0
  int result = masked_register >> pos;

  return result;
}
