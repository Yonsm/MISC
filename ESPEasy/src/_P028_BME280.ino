//#######################################################################################################
//#################### Plugin 028 BME280 I2C Temp/Hum/Barometric Pressure Sensor  #######################
//#######################################################################################################

//#include <math.h>

#define PLUGIN_028
#define PLUGIN_ID_028        28
#define PLUGIN_NAME_028       "Environment - BMx280"
#define PLUGIN_VALUENAME1_028 "Temperature"
#define PLUGIN_VALUENAME2_028 "Humidity"
#define PLUGIN_VALUENAME3_028 "Pressure"

#define PLUGIN_028_BME280_DEVICE "BME280"
#define PLUGIN_028_BMP280_DEVICE "BMP280"

// Minimal interval in msec.
#define BMx280_MEASUREMENT_INTERVAL_MSEC 50000

#define BMx280_REGISTER_DIG_T1           0x88
#define BMx280_REGISTER_DIG_T2           0x8A
#define BMx280_REGISTER_DIG_T3           0x8C

#define BMx280_REGISTER_DIG_P1           0x8E
#define BMx280_REGISTER_DIG_P2           0x90
#define BMx280_REGISTER_DIG_P3           0x92
#define BMx280_REGISTER_DIG_P4           0x94
#define BMx280_REGISTER_DIG_P5           0x96
#define BMx280_REGISTER_DIG_P6           0x98
#define BMx280_REGISTER_DIG_P7           0x9A
#define BMx280_REGISTER_DIG_P8           0x9C
#define BMx280_REGISTER_DIG_P9           0x9E

#define BMx280_REGISTER_DIG_H1           0xA1
#define BMx280_REGISTER_DIG_H2           0xE1
#define BMx280_REGISTER_DIG_H3           0xE3
#define BMx280_REGISTER_DIG_H4           0xE4
#define BMx280_REGISTER_DIG_H5           0xE5
#define BMx280_REGISTER_DIG_H6           0xE7

#define BMx280_REGISTER_CHIPID           0xD0
#define BMx280_REGISTER_VERSION          0xD1
#define BMx280_REGISTER_SOFTRESET        0xE0

#define BMx280_REGISTER_CAL26            0xE1  // R calibration stored in 0xE1-0xF0

#define BMx280_REGISTER_CONTROLHUMID     0xF2
#define BMx280_REGISTER_STATUS           0xF3
#define BMx280_REGISTER_CONTROL          0xF4
#define BMx280_REGISTER_CONFIG           0xF5
#define BMx280_REGISTER_PRESSUREDATA     0xF7
#define BMx280_REGISTER_TEMPDATA         0xFA
#define BMx280_REGISTER_HUMIDDATA        0xFD

#define BME280_CONTROL_SETTING_HUMIDITY  0x02 // Oversampling: 2x H

typedef struct
{
  uint16_t dig_T1;
  int16_t  dig_T2;
  int16_t  dig_T3;

  uint16_t dig_P1;
  int16_t  dig_P2;
  int16_t  dig_P3;
  int16_t  dig_P4;
  int16_t  dig_P5;
  int16_t  dig_P6;
  int16_t  dig_P7;
  int16_t  dig_P8;
  int16_t  dig_P9;

  uint8_t  dig_H1;
  int16_t  dig_H2;
  uint8_t  dig_H3;
  int16_t  dig_H4;
  int16_t  dig_H5;
  int8_t   dig_H6;
} bme280_calib_data;

bme280_calib_data _bme280_calib[2];
boolean Plugin_028_init[2] = {false, false};
int Plugin_28_i2c_addresses[2] = { 0x76, 0x77 };

uint8_t _i2caddr;
int32_t t_fine;

static float last_hum_val[2] = {0.0, 0.0};
static float last_press_val[2] = {0.0, 0.0};
static float last_temp_val[2] = {0.0, 0.0};
static float last_dew_temp_val[2] = {0.0, 0.0};
static unsigned long last_measurement[2] = {0, 0};

enum BMx_ChipId {
  Unknown_DEVICE = 0,
  BMP280_DEVICE_SAMPLE1 = 0x56,
  BMP280_DEVICE_SAMPLE2 = 0x57,
  BMP280_DEVICE = 0x58,
  BME280_DEVICE = 0x60
};

BMx_ChipId _sensorID[2] = {Unknown_DEVICE, Unknown_DEVICE};

byte Plugin_028_get_config_settings() {
  const uint8_t idx = Plugin_028_device_index(_i2caddr);
  switch (_sensorID[idx]) {
    case BMP280_DEVICE_SAMPLE1:
    case BMP280_DEVICE_SAMPLE2:
    case BMP280_DEVICE:  return 0x28; // Tstandby 62.5ms, filter 4, 3-wire SPI Disable
    case BME280_DEVICE:  return 0x28; // Tstandby 62.5ms, filter 4, 3-wire SPI Disable
    default: return 0;
  }
}

byte Plugin_028_get_control_settings() {
  const uint8_t idx = Plugin_028_device_index(_i2caddr);
  switch (_sensorID[idx]) {
    case BMP280_DEVICE_SAMPLE1:
    case BMP280_DEVICE_SAMPLE2:
    case BMP280_DEVICE:  return 0x93; // Oversampling: 8x P, 8x T, normal mode
    case BME280_DEVICE:  return 0x93; // Oversampling: 8x P, 8x T, normal mode
    default: return 0;
  }
}

String Plugin_028_getFullDeviceName() {
  const uint8_t idx = Plugin_028_device_index(_i2caddr);
  String devicename = Plugin_028_getDeviceName();
  if (_sensorID[idx] == BMP280_DEVICE_SAMPLE1 ||
      _sensorID[idx] == BMP280_DEVICE_SAMPLE2)
  {
    devicename += F(" sample");
  }
  return devicename;
}

String Plugin_028_getDeviceName() {
  const uint8_t idx = Plugin_028_device_index(_i2caddr);
  switch (_sensorID[idx]) {
    case BMP280_DEVICE_SAMPLE1:
    case BMP280_DEVICE_SAMPLE2:
    case BMP280_DEVICE:  return PLUGIN_028_BMP280_DEVICE;
    case BME280_DEVICE:  return PLUGIN_028_BME280_DEVICE;
    default: return F("Unknown");
  }

}

boolean Plugin_028_hasHumidity() {
  const uint8_t idx = Plugin_028_device_index(_i2caddr);
  switch (_sensorID[idx]) {
    case BMP280_DEVICE_SAMPLE1:
    case BMP280_DEVICE_SAMPLE2:
    case BMP280_DEVICE:  return false;
    case BME280_DEVICE:  return true;
    default: return false;
  }

}

uint8_t Plugin_028_read8(byte reg, bool * is_ok = NULL); // Declaration

uint8_t Plugin_028_i2c_addr(struct EventStruct *event) {
  _i2caddr = (uint8_t)Settings.TaskDevicePluginConfig[event->TaskIndex][0];
  if (_i2caddr != Plugin_28_i2c_addresses[0] && _i2caddr != Plugin_28_i2c_addresses[1]) {
    // Set to default address
    _i2caddr = Plugin_28_i2c_addresses[0];
  }
  return _i2caddr;
}

uint8_t Plugin_028_device_index(const uint8_t i2cAddress) {
  return i2cAddress & 0x1; //Addresses are 0x76 and 0x77 so we may use it this way
}

boolean Plugin_028(byte function, struct EventStruct *event, String& string)
{
  boolean success = false;

  switch (function)
  {
    case PLUGIN_DEVICE_ADD:
      {
        Device[++deviceCount].Number = PLUGIN_ID_028;
        Device[deviceCount].Type = DEVICE_TYPE_I2C;
        Device[deviceCount].VType = SENSOR_TYPE_TEMP_HUM_BARO;
        Device[deviceCount].Ports = 0;
        Device[deviceCount].PullUpOption = false;
        Device[deviceCount].InverseLogicOption = false;
        Device[deviceCount].FormulaOption = true;
        Device[deviceCount].ValueCount = 3;
        Device[deviceCount].SendDataOption = true;
        Device[deviceCount].TimerOption = true;
        Device[deviceCount].GlobalSyncOption = true;
        break;
      }

    case PLUGIN_GET_DEVICENAME:
      {
        string = F(PLUGIN_NAME_028);
        break;
      }

    case PLUGIN_GET_DEVICEVALUENAMES:
      {
        strcpy_P(ExtraTaskSettings.TaskDeviceValueNames[0], PSTR(PLUGIN_VALUENAME1_028));
        strcpy_P(ExtraTaskSettings.TaskDeviceValueNames[1], PSTR(PLUGIN_VALUENAME2_028));
        strcpy_P(ExtraTaskSettings.TaskDeviceValueNames[2], PSTR(PLUGIN_VALUENAME3_028));
        break;
      }

    case PLUGIN_WEBFORM_LOAD:
      {
        const uint8_t i2cAddress = Plugin_028_i2c_addr(event);
        addFormSelectorI2C(string, F("plugin_028_bme280_i2c"), 2, Plugin_28_i2c_addresses, i2cAddress);
        const uint8_t idx = Plugin_028_device_index(i2cAddress);
        if (_sensorID[idx] != Unknown_DEVICE) {
          String detectedString = F("Detected: ");
          detectedString += Plugin_028_getFullDeviceName();
          addUnit(string, detectedString);
        }
        addFormNote(string, F("SDO Low=0x76, High=0x77"));

        addFormNumericBox(string, F("Altitude"), F("plugin_028_bme280_elev"), Settings.TaskDevicePluginConfig[event->TaskIndex][1]);
        addUnit(string, F("m"));

        addFormNumericBox(string, F("Temperature offset"), F("plugin_028_bme280_tempoffset"), Settings.TaskDevicePluginConfig[event->TaskIndex][2]);
        addUnit(string, F("x 0.1C"));
        String offsetNote = F("Offset in units of 0.1 degree Celcius");
        if (Plugin_028_hasHumidity()) {
          offsetNote += F(" (also correct humidity)");
        }
        addFormNote(string, offsetNote);

        success = true;
        break;
      }

    case PLUGIN_WEBFORM_SAVE:
      {
        const uint8_t i2cAddress = getFormItemInt(F("plugin_028_bme280_i2c"));
        Plugin_028_check(i2cAddress); // Check id device is present
        Settings.TaskDevicePluginConfig[event->TaskIndex][0] = i2cAddress;
        Settings.TaskDevicePluginConfig[event->TaskIndex][1] = getFormItemInt(F("plugin_028_bme280_elev"));
        Settings.TaskDevicePluginConfig[event->TaskIndex][2] = getFormItemInt(F("plugin_028_bme280_tempoffset"));
        success = true;
        break;
      }

    case PLUGIN_READ:
      {
        const uint8_t i2cAddress = Plugin_028_i2c_addr(event);
        const uint8_t idx = Plugin_028_device_index(i2cAddress);
        const float tempOffset = Settings.TaskDevicePluginConfig[event->TaskIndex][2] / 10.0;
        if (!Plugin_028_update_measurements(i2cAddress, tempOffset)) {
          success = false;
          break;
        }
        UserVar[event->BaseVarIndex] = last_temp_val[idx];
        UserVar[event->BaseVarIndex + 1] = last_hum_val[idx];
        const int elev = Settings.TaskDevicePluginConfig[event->TaskIndex][1];
        if (elev) {
           UserVar[event->BaseVarIndex + 2] = Plugin_028_pressureElevation(last_press_val[idx], elev);
        } else {
           UserVar[event->BaseVarIndex + 2] = last_press_val[idx];
        }
        String log;
        log.reserve(40); // Prevent re-allocation
        log = Plugin_028_getDeviceName();
        log += F(" : Address: 0x");
        log += String(_i2caddr,HEX);
        addLog(LOG_LEVEL_INFO, log);
        log = Plugin_028_getDeviceName();
        log += F(" : Temperature: ");
        log += UserVar[event->BaseVarIndex];
        addLog(LOG_LEVEL_INFO, log);
        if (Plugin_028_hasHumidity()) {
          log = Plugin_028_getDeviceName();
          log += F(" : Humidity: ");
          log += UserVar[event->BaseVarIndex + 1];
          addLog(LOG_LEVEL_INFO, log);
        }
        log = Plugin_028_getDeviceName();
        log += F(" : Barometric Pressure: ");
        log += UserVar[event->BaseVarIndex + 2];
        addLog(LOG_LEVEL_INFO, log);
        success = true;
        break;
      }

  }
  return success;
}

// Only perform the measurements with big interval to prevent the sensor from warming up.
bool Plugin_028_update_measurements(uint8_t i2cAddress, float tempOffset) {
  const uint8_t idx = Plugin_028_device_index(i2cAddress);
  const unsigned long current_time = millis();
  if ((last_measurement[idx] > BMx280_MEASUREMENT_INTERVAL_MSEC) &&
      (current_time < (last_measurement[idx] + BMx280_MEASUREMENT_INTERVAL_MSEC)) &&
      (current_time > last_measurement[idx])) {
    // Timeout has not yet been reached.
    return false;
  }
  Plugin_028_init[idx] &= Plugin_028_check(i2cAddress); // Check id device is present
  if (!Plugin_028_init[idx]) {
    Plugin_028_init[idx] = Plugin_028_begin(i2cAddress);
  }

  if (Plugin_028_init[idx]) {
    last_measurement[idx] = current_time;
    // Set the Sensor in sleep to be make sure that the following configs will be stored
    Plugin_028_write8(BMx280_REGISTER_CONTROL, 0x00);
    if (Plugin_028_hasHumidity()) {
      Plugin_028_write8(BMx280_REGISTER_CONTROLHUMID, BME280_CONTROL_SETTING_HUMIDITY);
    }
    Plugin_028_write8(BMx280_REGISTER_CONFIG, Plugin_028_get_config_settings());
    Plugin_028_write8(BMx280_REGISTER_CONTROL, Plugin_028_get_control_settings());

    // Start measurement
    delay(1000); // Wait one second to make sure the filtered values stabilize.

    last_temp_val[idx] = Plugin_028_readTemperature(i2cAddress);
    last_press_val[idx] = ((float)Plugin_028_readPressure(i2cAddress)) / 100;
    last_hum_val[idx] = ((float)Plugin_028_readHumidity(i2cAddress));

    // Set to sleep mode again to prevent the sensor from heating up.
    Plugin_028_write8(BMx280_REGISTER_CONTROL, 0x00);

    String log;
    log.reserve(120); // Prevent re-allocation
    log = Plugin_028_getDeviceName();
    log += F(":");
    boolean logAdded = false;
    if (Plugin_028_hasHumidity()) {
      // Apply half of the temp offset, to correct the dew point offset.
      // The sensor is warmer than the surrounding air, which has effect on the perceived humidity.
      last_dew_temp_val[idx] = compute_dew_point_temp(last_temp_val[idx] + (tempOffset / 2.0), last_hum_val[idx]);
    } else {
      // No humidity measurement, thus set dew point equal to air temperature.
      last_dew_temp_val[idx] = last_temp_val[idx];
    }
    if (tempOffset > 0.1 || tempOffset < -0.1) {
      // There is some offset to apply.
      log += F(" Apply temp offset ");
      log += tempOffset;
      log += F("C");
      if (Plugin_028_hasHumidity()) {
        log += F(" humidity ");
        log += last_hum_val[idx];
        last_hum_val[idx] = compute_humidity_from_dewpoint(last_temp_val[idx] + tempOffset, last_dew_temp_val[idx]);
        log += F("% => ");
        log += last_hum_val[idx];
        log += F("%");
      }
      log += F(" temperature ");
      log += last_temp_val[idx];
      last_temp_val[idx] = last_temp_val[idx] + tempOffset;
      log += F("C => ");
      log += last_temp_val[idx];
      log += F("C");
      logAdded = true;
    }
    if (Plugin_028_hasHumidity()) {
      log += F(" dew point ");
      log += last_dew_temp_val[idx];
      log += F("C");
      logAdded = true;
    }
    if (logAdded)
      addLog(LOG_LEVEL_INFO, log);
    return true;
  }
  return false;
}


//**************************************************************************/
// Check BME280 presence
//**************************************************************************/
bool Plugin_028_check(uint8_t a) {
  _i2caddr = a?a:0x76;
  const uint8_t idx = Plugin_028_device_index(_i2caddr);
  bool wire_status = false;
  const uint8_t chip_id = Plugin_028_read8(BMx280_REGISTER_CHIPID, &wire_status);
  switch (chip_id) {
    case BMP280_DEVICE_SAMPLE1:
    case BMP280_DEVICE_SAMPLE2:
    case BMP280_DEVICE:
    case BME280_DEVICE: {
      if (wire_status) {
        // Store detected chip ID when chip found.
        if (_sensorID[idx] != chip_id) {
          _sensorID[idx] = static_cast<BMx_ChipId>(chip_id);
          String log = F("BMx280 : Detected ");
          log += Plugin_028_getFullDeviceName();
          addLog(LOG_LEVEL_INFO, log);
        }
      } else {
        _sensorID[idx] = Unknown_DEVICE;
      }
      break;
    }
    default:
      _sensorID[idx] = Unknown_DEVICE;
      break;
  }
  if (_sensorID[idx] == Unknown_DEVICE) {
    String log = F("BMx280 : Unable to detect chip ID");
    addLog(LOG_LEVEL_INFO, log);
    return false;
  }
  return wire_status;
}

//**************************************************************************/
// Initialize BME280
//**************************************************************************/
bool Plugin_028_begin(uint8_t a) {
  if (! Plugin_028_check(a))
    return false;
  // Perform soft reset
  Plugin_028_write8(BMx280_REGISTER_SOFTRESET, 0xB6);
  delay(2);  // Startup time is 2 ms (datasheet)
  Plugin_028_readCoefficients(a);
  delay(65); //May be needed here as well to fix first wrong measurement?
  return true;
}

//**************************************************************************/
// Writes an 8 bit value over I2C/SPI
//**************************************************************************/
void Plugin_028_write8(byte reg, byte value)
{
  Wire.beginTransmission((uint8_t)_i2caddr);
  Wire.write((uint8_t)reg);
  Wire.write((uint8_t)value);
  Wire.endTransmission();
}

//**************************************************************************/
// Reads an 8 bit value over I2C
//**************************************************************************/
uint8_t Plugin_028_read8(byte reg, bool * is_ok)
{
  uint8_t value;

  Wire.beginTransmission((uint8_t)_i2caddr);
  Wire.write((uint8_t)reg);
  Wire.endTransmission();
  byte count = Wire.requestFrom((uint8_t)_i2caddr, (byte)1);
  if (is_ok != NULL) { *is_ok = (count == 1); }
  value = Wire.read();
  Wire.endTransmission();
  return value;
}

//**************************************************************************/
// Reads a 16 bit value over I2C
//**************************************************************************/
uint16_t Plugin_028_read16(byte reg)
{
  uint16_t value;

  Wire.beginTransmission((uint8_t)_i2caddr);
  Wire.write((uint8_t)reg);
  Wire.endTransmission();
  Wire.requestFrom((uint8_t)_i2caddr, (byte)2);
  value = (Wire.read() << 8) | Wire.read();
  Wire.endTransmission();

  return value;
}

//**************************************************************************/
// Reads a 24 bit value over I2C
//**************************************************************************/
int32_t Plugin_028_read24(byte reg)
{
  int32_t value;

  Wire.beginTransmission((uint8_t)_i2caddr);
  Wire.write((uint8_t)reg);
  Wire.endTransmission();
  Wire.requestFrom((uint8_t)_i2caddr, (byte)3);
  value = (((int32_t)Wire.read()) << 16) | (Wire.read() << 8) | Wire.read();
  Wire.endTransmission();

  return value;
}

//**************************************************************************/
// Reads a 16 bit value over I2C
//**************************************************************************/
uint16_t Plugin_028_read16_LE(byte reg) {
  uint16_t temp = Plugin_028_read16(reg);
  return (temp >> 8) | (temp << 8);

}

//**************************************************************************/
// Reads a signed 16 bit value over I2C
//**************************************************************************/
int16_t Plugin_028_readS16(byte reg)
{
  return (int16_t)Plugin_028_read16(reg);

}

int16_t Plugin_028_readS16_LE(byte reg)
{
  return (int16_t)Plugin_028_read16_LE(reg);

}

//**************************************************************************/
// Reads the factory-set coefficients
//**************************************************************************/
void Plugin_028_readCoefficients(uint8_t i2cAddress)
{
  const uint8_t idx = Plugin_028_device_index(i2cAddress);

  _bme280_calib[idx].dig_T1 = Plugin_028_read16_LE(BMx280_REGISTER_DIG_T1);
  _bme280_calib[idx].dig_T2 = Plugin_028_readS16_LE(BMx280_REGISTER_DIG_T2);
  _bme280_calib[idx].dig_T3 = Plugin_028_readS16_LE(BMx280_REGISTER_DIG_T3);

  _bme280_calib[idx].dig_P1 = Plugin_028_read16_LE(BMx280_REGISTER_DIG_P1);
  _bme280_calib[idx].dig_P2 = Plugin_028_readS16_LE(BMx280_REGISTER_DIG_P2);
  _bme280_calib[idx].dig_P3 = Plugin_028_readS16_LE(BMx280_REGISTER_DIG_P3);
  _bme280_calib[idx].dig_P4 = Plugin_028_readS16_LE(BMx280_REGISTER_DIG_P4);
  _bme280_calib[idx].dig_P5 = Plugin_028_readS16_LE(BMx280_REGISTER_DIG_P5);
  _bme280_calib[idx].dig_P6 = Plugin_028_readS16_LE(BMx280_REGISTER_DIG_P6);
  _bme280_calib[idx].dig_P7 = Plugin_028_readS16_LE(BMx280_REGISTER_DIG_P7);
  _bme280_calib[idx].dig_P8 = Plugin_028_readS16_LE(BMx280_REGISTER_DIG_P8);
  _bme280_calib[idx].dig_P9 = Plugin_028_readS16_LE(BMx280_REGISTER_DIG_P9);

  if (Plugin_028_hasHumidity()) {
    _bme280_calib[idx].dig_H1 = Plugin_028_read8(BMx280_REGISTER_DIG_H1);
    _bme280_calib[idx].dig_H2 = Plugin_028_readS16_LE(BMx280_REGISTER_DIG_H2);
    _bme280_calib[idx].dig_H3 = Plugin_028_read8(BMx280_REGISTER_DIG_H3);
    _bme280_calib[idx].dig_H4 = (Plugin_028_read8(BMx280_REGISTER_DIG_H4) << 4) | (Plugin_028_read8(BMx280_REGISTER_DIG_H4 + 1) & 0xF);
    _bme280_calib[idx].dig_H5 = (Plugin_028_read8(BMx280_REGISTER_DIG_H5 + 1) << 4) | (Plugin_028_read8(BMx280_REGISTER_DIG_H5) >> 4);
    _bme280_calib[idx].dig_H6 = (int8_t)Plugin_028_read8(BMx280_REGISTER_DIG_H6);
  }
}

//**************************************************************************/
// Read temperature
//**************************************************************************/
float Plugin_028_readTemperature(uint8_t i2cAddress)
{
  const uint8_t idx = Plugin_028_device_index(i2cAddress);
  int32_t var1, var2;

  // wait until measurement has been completed, otherwise we would read
  // the values from the last measurement
  while (Plugin_028_read8(BMx280_REGISTER_STATUS) & 0x08)
    delay(1);

  int32_t adc_T = Plugin_028_read24(BMx280_REGISTER_TEMPDATA);
  adc_T >>= 4;

  var1  = ((((adc_T >> 3) - ((int32_t)_bme280_calib[idx].dig_T1 << 1))) *
           ((int32_t)_bme280_calib[idx].dig_T2)) >> 11;

  var2  = (((((adc_T >> 4) - ((int32_t)_bme280_calib[idx].dig_T1)) *
             ((adc_T >> 4) - ((int32_t)_bme280_calib[idx].dig_T1))) >> 12) *
           ((int32_t)_bme280_calib[idx].dig_T3)) >> 14;

  t_fine = var1 + var2;

  float T  = (t_fine * 5 + 128) >> 8;
  return T / 100;
}

//**************************************************************************/
// Read pressure
//**************************************************************************/
float Plugin_028_readPressure(uint8_t i2cAddress)
{
  const uint8_t idx = Plugin_028_device_index(i2cAddress);
  int64_t var1, var2, p;

  int32_t adc_P = Plugin_028_read24(BMx280_REGISTER_PRESSUREDATA);
  adc_P >>= 4;

  var1 = ((int64_t)t_fine) - 128000;
  var2 = var1 * var1 * (int64_t)_bme280_calib[idx].dig_P6;
  var2 = var2 + ((var1 * (int64_t)_bme280_calib[idx].dig_P5) << 17);
  var2 = var2 + (((int64_t)_bme280_calib[idx].dig_P4) << 35);
  var1 = ((var1 * var1 * (int64_t)_bme280_calib[idx].dig_P3) >> 8) +
         ((var1 * (int64_t)_bme280_calib[idx].dig_P2) << 12);
  var1 = (((((int64_t)1) << 47) + var1)) * ((int64_t)_bme280_calib[idx].dig_P1) >> 33;

  if (var1 == 0) {
    return 0;  // avoid exception caused by division by zero
  }
  p = 1048576 - adc_P;
  p = (((p << 31) - var2) * 3125) / var1;
  var1 = (((int64_t)_bme280_calib[idx].dig_P9) * (p >> 13) * (p >> 13)) >> 25;
  var2 = (((int64_t)_bme280_calib[idx].dig_P8) * p) >> 19;

  p = ((p + var1 + var2) >> 8) + (((int64_t)_bme280_calib[idx].dig_P7) << 4);
  return (float)p / 256;
}

//**************************************************************************/
// Read humidity
//**************************************************************************/
float Plugin_028_readHumidity(uint8_t i2cAddress)
{
  if (!Plugin_028_hasHumidity()) {
    // No support for humidity
    return 0.0;
  }
  // It takes at least 1.587 sec for valit measurements to complete.
  // The datasheet names this the "T63" moment.
  // 1 second = 63% of the time needed to perform a measurement.
  const uint8_t idx = Plugin_028_device_index(i2cAddress);
  unsigned long difTime = millis() - last_measurement[idx];
  if (difTime < 1587) {
    delay(1587 - difTime);
  }
  int32_t adc_H = Plugin_028_read16(BMx280_REGISTER_HUMIDDATA);

  int32_t v_x1_u32r;

  v_x1_u32r = (t_fine - ((int32_t)76800));

  v_x1_u32r = (((((adc_H << 14) - (((int32_t)_bme280_calib[idx].dig_H4) << 20) -
                  (((int32_t)_bme280_calib[idx].dig_H5) * v_x1_u32r)) + ((int32_t)16384)) >> 15) *
               (((((((v_x1_u32r * ((int32_t)_bme280_calib[idx].dig_H6)) >> 10) *
                    (((v_x1_u32r * ((int32_t)_bme280_calib[idx].dig_H3)) >> 11) + ((int32_t)32768))) >> 10) +
                  ((int32_t)2097152)) * ((int32_t)_bme280_calib[idx].dig_H2) + 8192) >> 14));

  v_x1_u32r = (v_x1_u32r - (((((v_x1_u32r >> 15) * (v_x1_u32r >> 15)) >> 7) *
                             ((int32_t)_bme280_calib[idx].dig_H1)) >> 4));

  v_x1_u32r = (v_x1_u32r < 0) ? 0 : v_x1_u32r;
  v_x1_u32r = (v_x1_u32r > 419430400) ? 419430400 : v_x1_u32r;
  float h = (v_x1_u32r >> 12);
  return  h / 1024.0;
}

//**************************************************************************/
// Calculates the altitude (in meters) from the specified atmospheric
//    pressure (in hPa), and sea-level pressure (in hPa).
//    @param  seaLevel      Sea-level pressure in hPa
//    @param  atmospheric   Atmospheric pressure in hPa
//**************************************************************************/
float Plugin_028_readAltitude(float seaLevel)
{
  // Equation taken from BMP180 datasheet (page 16):
  //  http://www.adafruit.com/datasheets/BST-BMP180-DS000-09.pdf

  // Note that using the equation from wikipedia can give bad results
  // at high altitude.  See this thread for more information:
  //  http://forums.adafruit.com/viewtopic.php?f=22&t=58064

  float atmospheric = Plugin_028_readPressure(_i2caddr) / 100.0F;
  return 44330.0 * (1.0 - pow(atmospheric / seaLevel, 0.1903));
}

//**************************************************************************/
// MSL pressure formula
//**************************************************************************/
float Plugin_028_pressureElevation(float atmospheric, int altitude) {
  return atmospheric / pow(1.0 - (altitude/44330.0), 5.255);
}
