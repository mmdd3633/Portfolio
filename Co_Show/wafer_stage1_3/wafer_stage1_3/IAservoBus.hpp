#pragma once
//#include "ArduinoCANBus.hpp"
#include <stdint.h>

namespace robowell
{
	enum class AServoCANError : int8_t
	{
		NoError = 0,
		AbortCode = 1,
		Timeout = 2,
	};

	class IAservoBus
	{
		public:
		virtual AServoCANError WriteObject(int16_t node_id, const int32_t& value, int32_t index, int32_t subIndex,uint32_t& abortcode) = 0;
		virtual AServoCANError ReadObject(int16_t node_id, int32_t& value, int32_t index, int32_t subIndex, uint32_t& abortcode) = 0;
	};
} // namespace robowell