#include "AservoDrive.hpp"
#include <Arduino.h>



namespace robowell
{
AservoDrive::AservoDrive(IAservoBus& bus, uint8_t id) : _bus(bus), _id(id) {}

// bool AservoDrive::WriteObject(int32_t index, int32_t subIndex, int32_t value)
// {
// 	if (_bus.WriteObject(_id, value, index, subIndex, _lastAbortcode) == AServoCANError::NoError)
// 	{
// 		return true;
// 	}
// 	return false;
// }

// bool AservoDrive::ReadObject(int32_t index, int32_t subIndex, int32_t& value)
// {
// 	if (_bus.ReadObject(_id, value, index, subIndex, _lastAbortcode) == AServoCANError::NoError)
// 	{
// 		return true;
// 	}
// 	return false;
// }
bool AservoDrive::WriteObject(int32_t index, int32_t subIndex, int32_t value)
{
    return (_bus.WriteObject(_id, value, index, subIndex, _lastAbortcode) == AServoCANError::NoError);
}

bool AservoDrive::ReadObject(int32_t index, int32_t subIndex, int32_t& value)
{
    return (_bus.ReadObject(_id, value, index, subIndex, _lastAbortcode) == AServoCANError::NoError);
}
bool AservoDrive::GetStatusword(int32_t& value)
{
	uint32_t abortcode = 0;
	if (ReadObject(CIA_402_STATUS_WORD, 0, value))
	{
		_statusword = value;
		return true;
	}
	return false;
}

bool AservoDrive::SetControlword(const int32_t value)
{
	uint32_t abortcode = 0;
	if (WriteObject(CIA_402_CONTROL_WORD, 0, value))
	{
		_controlword = value;
		return true;
	}
	return false;
}

bool AservoDrive::AndControlWord(int32_t mask)
{
	int32_t value = _controlword & mask;
	return SetControlword(value);
}

bool AservoDrive::OrControlWord(int32_t mask)
{
	int32_t value = _controlword | mask;
	return SetControlword(value);
}

bool AservoDrive::XorControlWord(int32_t mask)
{
	int32_t value = _controlword ^ mask;
	return SetControlword(value);
}

bool AservoDrive::ServoOn()
{
	if (!SetControlword(CIA_402_ENABLE_VOLTAGE | CIA_402_QUICK_STOP))
		return false;
	if (!OrControlWord(CIA_402_SWITCH_ON))
		return false;
	if (!OrControlWord(CIA_402_ENABLE_OPERATION))
		return false;
	return true;
}

bool AservoDrive::ServoOff()
{
	return SetControlword(0);
}

bool AservoDrive::ResetFault()
{
	return OrControlWord(CIA_402_FAULT_RESET);
}

bool AservoDrive::Stop()
{
	return OrControlWord(CIA_402_HALT_BIT);
}

bool AservoDrive::SetMode(AServoMode mode)
{
	int32_t value = 0;
	switch (mode)
	{
	case AServoMode::Velocity:
		value = 3;
		break;

	case AServoMode::Position:
		value = 1;
		break;

	case AServoMode::Homing:
		value = 6;
		break;

	default:
		return false;
	}

	if (!WriteObject(CIA_402_MODES_OF_OPERATION, 0, value))
		return false;
	return true;
}

AServoMode AservoDrive::GetMode()
{
	int32_t value = 0;
	if (!ReadObject(CIA_402_MODES_OF_OPERATION_DISPLAY, 0, value))
		return AServoMode::Unknown;
	if (value == 3)
		return AServoMode::Velocity;
	else if (value == 1)
		return AServoMode::Position;
	else if (value == 6)
		return AServoMode::Homing;
	else
		return AServoMode::Unknown;
}

bool AservoDrive::MoveAbs(int32_t position)
{
	if (!WriteObject(CIA_402_TARGET_POSITION, 0, position))
		return false;
	if (!AndControlWord(~(CIA_402_FAULT_RESET | CIA_402_NEW_SETPOINT | CIA_402_HALT_BIT | CIA_402_RELATIVE_BIT)))
		return false;
	if (!OrControlWord(CIA_402_NEW_SETPOINT))
		return false;
	if (!AndControlWord(~CIA_402_NEW_SETPOINT))
		return false;
	return true;
}

bool AservoDrive::MoveAbs(int32_t position, int32_t velocity)
{
	if (!WriteObject(CIA_402_PROFILE_VELOCITY, 0, velocity))
		return false;
	return MoveAbs(position);
}

bool AservoDrive::MoveRel(int32_t position)
{
	if (!WriteObject(CIA_402_TARGET_POSITION, 0, position))
		return false;
	if (!AndControlWord(~(CIA_402_FAULT_RESET | CIA_402_NEW_SETPOINT | CIA_402_HALT_BIT | CIA_402_RELATIVE_BIT)))
		return false;
	if (!OrControlWord(CIA_402_NEW_SETPOINT | CIA_402_RELATIVE_BIT))
		return false;
	if (!AndControlWord(~CIA_402_NEW_SETPOINT))
		return false;
	return true;
}

bool AservoDrive::MoveRel(int32_t position, int32_t velocity)
{
	if (!WriteObject(CIA_402_PROFILE_VELOCITY, 0, velocity))
		return false;
	return MoveRel(position);
}

bool AservoDrive::GetActualVelocity(int32_t& actualVelocity)
{
	if (!ReadObject(CIA_402_ACTUAL_VELOCITY, 0, actualVelocity))
		return false;
	return true;
}

bool AservoDrive::GetActualPosition(int32_t& actualPosition)
{
	if (!ReadObject(CIA_402_ACTUAL_POSITION, 0, actualPosition))
		return false;
	return true;
}

bool AservoDrive::Speed(int32_t velocity)
{
	if (!WriteObject(CIA_402_TARGET_VELOCITY, 0, velocity))
		return false;
	return true;
}

bool AservoDrive::MoveHomming()
{
	if (!AndControlWord(~(CIA_402_FAULT_RESET | CIA_402_HOMING_START | CIA_402_HALT_BIT | CIA_402_RELATIVE_BIT)))
		return false;
	if (!OrControlWord(CIA_402_HOMING_START))
		return false;
	if (!AndControlWord(~CIA_402_HOMING_START))
		return false;
	return true;
}


bool AservoDrive::IsTargetReached()
{
	int32_t value = 0;
	if (!GetStatusword(value))
		return false;
	if((value & CIA_402_STATUS_SET_POINT_ACK) == CIA_402_STATUS_SET_POINT_ACK)
	{
		AndControlWord(~CIA_402_NEW_SETPOINT);
		return false;
	}
	return ((value & CIA_402_TARGET_REACHED) == CIA_402_TARGET_REACHED &&
					(value & CIA_402_STATUS_SET_POINT_ACK) != CIA_402_STATUS_SET_POINT_ACK);
}

bool AservoDrive::IsHommingReached()
{
	int32_t value = 0;
	if (!GetStatusword(value))
		return false;
	return ((value & CIA_402_STATUS_HOMING_ATTAINED) == CIA_402_STATUS_HOMING_ATTAINED &&
				  (value & CIA_402_STATUS_HOMING_ERROR) != CIA_402_STATUS_HOMING_ERROR);
}


bool AservoDrive::SetAcceleration(int32_t acc, int32_t dec, int32_t jerk)
{
  if (!WriteObject(CIA_402_PROFILE_ACCELERATION, 0, acc)) return false;
  if (!WriteObject(CIA_402_PROFILE_DECELERATION, 0, dec)) return false;
  if (!WriteObject(CIA_402_S_CURVE_PROFILE_JERK, 0, jerk)) return false;
  return true;
}
  
} // namespace robowell