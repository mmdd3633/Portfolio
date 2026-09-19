#pragma once
#include "Arduino.h"
#include <stdint.h>
#include "IAservoBus.hpp"
//#include "SpiToCAN.hpp"
#include "SerialToCAN.h"





namespace robowell
{
	class ArduinoCANBus : public IAservoBus
	{
		public:
		//ArduinoCANBus();
		
		//bool begin(HardwareSerial& serial, unsigned long baud);
		//bool begin(SoftwareSerial& sw_serial, unsigned long baud);
		//bool begin(uint8_t csPin, CAN_SPEED speed, CAN_CLOCK clk);
		void begin(HardwareSerial &serial, unsigned long baud, int rxPin, int txPin);
		
		AServoCANError WriteObject(int16_t node_id, const int32_t& value, int32_t index, int32_t subIndex, uint32_t& abortcode);
		AServoCANError ReadObject(int16_t node_id, int32_t& value, int32_t index, int32_t subIndex, uint32_t& abortcode);

		private:
		int8_t MakeCheckSum(int8_t* pData, int32_t len);
		uint8_t _retry_count = 3;
		uint8_t _timeout_ms = 10;
		//SPI_CAN  _can;
		Serial_CAN _can;
		//HardwareSerial *hardwareSerial = NULL;
	};
} // namespace robowell