//#######################################################################################################
//#################################### Plugin 002: Analog ###############################################
//#######################################################################################################

#define PLUGIN_002
#define PLUGIN_ID_002         2
#define PLUGIN_NAME_002       "Analog input"
#define PLUGIN_VALUENAME1_002 "Analog"

uint32_t Plugin_002_OversamplingValue = 0;
uint16_t Plugin_002_OversamplingCount = 0;


boolean Plugin_002(byte function, struct EventStruct *event, String& string)
{
  boolean success = false;

  switch (function)
  {
    case PLUGIN_DEVICE_ADD:
      {
        Device[++deviceCount].Number = PLUGIN_ID_002;
        Device[deviceCount].Type = DEVICE_TYPE_ANALOG;
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
        string = F(PLUGIN_NAME_002);
        break;
      }

    case PLUGIN_GET_DEVICEVALUENAMES:
      {
        strcpy_P(ExtraTaskSettings.TaskDeviceValueNames[0], PSTR(PLUGIN_VALUENAME1_002));
        break;
      }

    case PLUGIN_WEBFORM_LOAD:
      {
        addFormCheckBox(string, F("Oversampling"), F("plugin_002_oversampling"), Settings.TaskDevicePluginConfig[event->TaskIndex][0]);

        addFormSubHeader(string, F("Two Point Calibration"));

        addFormCheckBox(string, F("Calibration Enabled"), F("plugin_002_cal"), Settings.TaskDevicePluginConfig[event->TaskIndex][3]);

        addFormNumericBox(string, F("Point 1"), F("plugin_002_adc1"), Settings.TaskDevicePluginConfigLong[event->TaskIndex][0], 0, 1023);
        string += F(" &#8793; ");
        addTextBox(string, F("plugin_002_out1"), String(Settings.TaskDevicePluginConfigFloat[event->TaskIndex][0], 3), 10);

        addFormNumericBox(string, F("Point 2"), F("plugin_002_adc2"), Settings.TaskDevicePluginConfigLong[event->TaskIndex][1], 0, 1023);
        string += F(" &#8793; ");
        addTextBox(string, F("plugin_002_out2"), String(Settings.TaskDevicePluginConfigFloat[event->TaskIndex][1], 3), 10);

        success = true;
        break;
      }

    case PLUGIN_WEBFORM_SAVE:
      {
        Settings.TaskDevicePluginConfig[event->TaskIndex][0] = isFormItemChecked(F("plugin_002_oversampling"));

        Settings.TaskDevicePluginConfig[event->TaskIndex][3] = isFormItemChecked(F("plugin_002_cal"));

        Settings.TaskDevicePluginConfigLong[event->TaskIndex][0] = getFormItemInt(F("plugin_002_adc1"));
        Settings.TaskDevicePluginConfigFloat[event->TaskIndex][0] = getFormItemFloat(F("plugin_002_out1"));

        Settings.TaskDevicePluginConfigLong[event->TaskIndex][1] = getFormItemInt(F("plugin_002_adc2"));
        Settings.TaskDevicePluginConfigFloat[event->TaskIndex][1] = getFormItemFloat(F("plugin_002_out2"));

        success = true;
        break;
      }

    case PLUGIN_TEN_PER_SECOND:
      {
        if (Settings.TaskDevicePluginConfig[event->TaskIndex][0])   //Oversampling?
        {
          Plugin_002_OversamplingValue += analogRead(A0);
          Plugin_002_OversamplingCount ++;
        }
        success = true;
        break;
      }

    case PLUGIN_READ:
      {
        String log = F("ADC  : Analog value: ");

        if (Plugin_002_OversamplingCount > 0)
        {
          UserVar[event->BaseVarIndex] = (float)Plugin_002_OversamplingValue / Plugin_002_OversamplingCount;
          Plugin_002_OversamplingValue = 0;
          Plugin_002_OversamplingCount = 0;

          log += String(UserVar[event->BaseVarIndex], 3);
        }
        else
        {
          int16_t value = analogRead(A0);
          UserVar[event->BaseVarIndex] = (float)value;

          log += value;
        }

        if (Settings.TaskDevicePluginConfig[event->TaskIndex][3])   //Calibration?
        {
          int adc1 = Settings.TaskDevicePluginConfigLong[event->TaskIndex][0];
          int adc2 = Settings.TaskDevicePluginConfigLong[event->TaskIndex][1];
          float out1 = Settings.TaskDevicePluginConfigFloat[event->TaskIndex][0];
          float out2 = Settings.TaskDevicePluginConfigFloat[event->TaskIndex][1];
          if (adc1 != adc2)
          {
            float normalized = (float)(UserVar[event->BaseVarIndex] - adc1) / (float)(adc2 - adc1);
            UserVar[event->BaseVarIndex] = normalized * (out2 - out1) + out1;

            log += F(" = ");
            log += String(UserVar[event->BaseVarIndex], 3);
          }
        }

        addLog(LOG_LEVEL_INFO,log);
        success = true;
        break;
      }
  }
  return success;
}
