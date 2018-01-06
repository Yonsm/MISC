/*-------------------------------------------------------------------------
  Arduino library to ...

  Written by Jochen Krapf,
  contributions by ... and other members of the open
  source community.

  -------------------------------------------------------------------------
  This file is part of the MechInputs library.

  MechInputs is free software: you can redistribute it and/or modify
  it under the terms of the GNU Lesser General Public License as
  published by the Free Software Foundation, either version 3 of
  the License, or (at your option) any later version.

  MechInputs is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with MechInputs.  If not, see
  <http://www.gnu.org/licenses/>.
  -------------------------------------------------------------------------*/

#ifndef _jkSDS011_H_
#define _jkSDS011_H_

#include "Arduino.h"
#include "SensorSerial.h"
#include "SensorSerialBuffer.h"

class CjkSDS011
{
public:
  CjkSDS011(int16_t pinRX, int16_t pinTX);

  void Process();

  boolean available();

  float GetPM2_5() { return _pm2_5; };
  float GetPM10_() { return _pm10_; };

  void ReadAverage(float &pm25, float &pm10);

private:
  SensorSerial _serial;
  CSensorSerialBuffer _data;
  float _pm2_5;
  float _pm10_;
  float _pm2_5avr;
  float _pm10_avr;
  uint16_t _avr;
  boolean _available;
  boolean _sws;
};

#endif
