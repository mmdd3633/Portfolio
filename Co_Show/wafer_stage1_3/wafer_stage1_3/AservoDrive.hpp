#pragma once
#include "IAservoBus.hpp"

#define CIA_402_CONTROL_WORD			0x6040
#define CIA_402_SWITCH_ON 				0x0001
#define CIA_402_ENABLE_VOLTAGE 		0x0002
#define CIA_402_QUICK_STOP 				0x0004
#define CIA_402_ENABLE_OPERATION 	0x0008
#define CIA_402_FAULT_RESET 			0x0080
#define CIA_402_HALT_BIT 					0x0100
#define CIA_402_HOMING_START 			0x0010 //	Homing Mode
#define CIA_402_NEW_SETPOINT 			0x0010 //	Profile Position Mode
#define CIA_402_RELATIVE_BIT 			0x0040

#define CIA_402_STATUS_WORD 			0x6041
#define CIA_402_STATUS_OPERATION_ENABLED	0x0027
#define CIA_402_TARGET_REACHED 		0x0400
#define CIA_402_STATUS_SET_POINT_ACK 			0x1000

#define CIA_402_TARGET_POSITION 					0x607A
#define CIA_402_TARGET_VELOCITY 					0x60FF
#define CIA_402_PROFILE_VELOCITY 					0x6081
#define CIA_402_MODES_OF_OPERATION 				0x6060
#define CIA_402_MODES_OF_OPERATION_DISPLAY	0x6061
#define CIA_402_ACTUAL_VELOCITY 					0x606C
#define CIA_402_ACTUAL_POSITION 					0x6064

#define CIA_402_PROFILE_ACCELERATION			0x6083             //	Unsigned 32Bit, RW	RPM/s	(1 ~ 100000000)
#define CIA_402_PROFILE_DECELERATION			0x6084            //	Unsigned 32Bit, RW	RPS/s	(1 ~ 100000000)
#define CIA_402_S_CURVE_PROFILE_JERK			0x60A4         //	Unsigned 32Bit,	RW	RPM/s^2	(1 ~ 4294967295), 2023-05-16

#define CIA_402_HOMING_COMPLETED     			0x609C //   Unsigned 8bit,   RO         (0 : Homing이 필요함, 1 : Homing 정상
		   //   완료)

#define HOMING_STATUS_COMPLETE 						0x08
#define CIA_402_STATUS_HOMING_ERROR 			0x2000	  //	Homing Error
#define CIA_402_STATUS_HOMING_ATTAINED 		0x1000 //	Homing Mode

namespace robowell
{
enum class AServoMode : uint8_t
{
	Unknown = 0,
	Velocity = 1,
	Position = 2,
	Homing = 3,
};

class AservoDrive
{
  public:
	AservoDrive(IAservoBus& bus, uint8_t id);
	bool ServoOn();
	bool ServoOff();
	bool ResetFault();
	bool Stop();

	AServoMode GetMode();
	bool SetMode(AServoMode mode);

	bool Speed(int32_t velocity);
  	bool SetAcceleration(int32_t acc, int32_t dec, int32_t jerk);

	bool MoveAbs(int32_t position);
	bool MoveAbs(int32_t position, int32_t velocity);

	bool MoveRel(int32_t position);
	bool MoveRel(int32_t position, int32_t velocity);
	
	bool MoveHomming();
	bool IsHommingReached();
	
	bool GetActualVelocity(int32_t& actualVelocity);
	bool GetActualPosition(int32_t& actualPosition);
	bool IsTargetReached();
	bool GetStatusword(int32_t& value);

  private:
	bool WriteObject(int32_t index, int32_t subIndex, int32_t value);
	bool ReadObject(int32_t index, int32_t subIndex, int32_t& value);

	bool SetControlword(const int32_t value);

	bool AndControlWord(int32_t mask);
	bool OrControlWord(int32_t mask);
	bool XorControlWord(int32_t mask);

	IAservoBus& _bus;
	const uint8_t _id;

	uint32_t _statusword;
	uint32_t _controlword;
	uint32_t _lastAbortcode;
};
} // namespace robowell