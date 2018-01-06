//#######################################################################################################
//########################### Controller Plugin 010: Generic UDP ########################################
//#######################################################################################################

#define CPLUGIN_010
#define CPLUGIN_ID_010         10
#define CPLUGIN_NAME_010       "Generic UDP"

boolean CPlugin_010(byte function, struct EventStruct *event, String& string)
{
  boolean success = false;

  switch (function)
  {
    case CPLUGIN_PROTOCOL_ADD:
      {
        Protocol[++protocolCount].Number = CPLUGIN_ID_010;
        Protocol[protocolCount].usesMQTT = false;
        Protocol[protocolCount].usesTemplate = true;
        Protocol[protocolCount].usesAccount = false;
        Protocol[protocolCount].usesPassword = false;
        Protocol[protocolCount].defaultPort = 514;
        Protocol[protocolCount].usesID = false;
        break;
      }

    case CPLUGIN_GET_DEVICENAME:
      {
        string = F(CPLUGIN_NAME_010);
        break;
      }

    case CPLUGIN_PROTOCOL_TEMPLATE:
      {
        event->String1 = "";
        event->String2 = F("%sysname%_%tskname%_%valname%=%value%");
        break;
      }

    case CPLUGIN_PROTOCOL_SEND:
      {
        byte valueCount = getValueCountFromSensorType(event->sensorType);
        for (byte x = 0; x < valueCount; x++)
        {
          if (event->sensorType == SENSOR_TYPE_LONG)
            C010_Send(event, 0, 0, (unsigned long)UserVar[event->BaseVarIndex] + ((unsigned long)UserVar[event->BaseVarIndex + 1] << 16));
          else
            C010_Send(event, x, UserVar[event->BaseVarIndex + x], 0);
          if (valueCount > 1)
          {
            delayBackground(Settings.MessageDelay);
            // unsigned long timer = millis() + Settings.MessageDelay;
            // while (millis() < timer)
            //   backgroundtasks();
          }
        }
        break;
      }

  }
  return success;
}


//********************************************************************************
// Generic UDP message
//********************************************************************************
void C010_Send(struct EventStruct *event, byte varIndex, float value, unsigned long longValue)
{
  ControllerSettingsStruct ControllerSettings;
  LoadControllerSettings(event->ControllerIndex, (byte*)&ControllerSettings, sizeof(ControllerSettings));

  char log[80];
  // boolean success = false;
  char host[20];
  sprintf_P(host, PSTR("%u.%u.%u.%u"), ControllerSettings.IP[0], ControllerSettings.IP[1], ControllerSettings.IP[2], ControllerSettings.IP[3]);

  sprintf_P(log, PSTR("%s%s using port %u"), "UDP  : sending to ", host, ControllerSettings.Port);
  addLog(LOG_LEVEL_DEBUG, log);

  statusLED(true);

  if (ExtraTaskSettings.TaskDeviceValueNames[0][0] == 0)
    PluginCall(PLUGIN_GET_DEVICEVALUENAMES, event, dummyString);

  String msg = "";
  msg += ControllerSettings.Publish;
  msg.replace(F("%sysname%"), Settings.Name);
  msg.replace(F("%tskname%"), ExtraTaskSettings.TaskDeviceName);
  msg.replace(F("%id%"), String(event->idx));
  msg.replace(F("%valname%"), ExtraTaskSettings.TaskDeviceValueNames[varIndex]);
  if (longValue)
    msg.replace(F("%value%"), String(longValue));
  else
    msg.replace(F("%value%"), toString(value, ExtraTaskSettings.TaskDeviceValueDecimals[varIndex]));

  IPAddress IP(ControllerSettings.IP[0], ControllerSettings.IP[1], ControllerSettings.IP[2], ControllerSettings.IP[3]);
  portUDP.beginPacket(IP, ControllerSettings.Port);
  portUDP.write(msg.c_str());
  portUDP.endPacket();

  msg.toCharArray(log, 80);
  addLog(LOG_LEVEL_DEBUG_MORE, log);

}
