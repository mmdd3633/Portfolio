#include "ArduinoCANBus.hpp"
#include <HardwareSerial.h>
#include "Arduino.h"


#define debug_mode 0

#define dbg_println(...)                 \
    do                                   \
    {                                    \
        if (debug_mode)                  \
            Serial.println(__VA_ARGS__); \
    } while (0)
#define dbg_print(...)                 \
    do                                 \
    {                                  \
        if (debug_mode)                \
            Serial.print(__VA_ARGS__); \
    } while (0)

namespace robowell
{
// ArduinoCANBus::AservoSerialBus()
// {
// }

// bool ArduinoCANBus::begin(SoftwareSerial&  sw_serial, unsigned long baud)
// {
//     // serial.begin(baud);
//     // hardwareSerial = &serial;
//     // canSerial = &serial;
//     //return 
//     _can.begin(sw_serial, baud);
//     return 1;
// }

// bool ArduinoCANBus::begin(uint8_t csPin, CAN_SPEED speed, CAN_CLOCK clk)
// {
//   return _can.begin(csPin, speed, clk);
// }
void ArduinoCANBus::begin(HardwareSerial &serial, unsigned long baud, int rxPin, int txPin) 
{
 // begin(HardwareSerial &serial, unsigned long baud, int rxPin, int txPin) 
   _can.begin(serial, baud, rxPin, txPin);
    
}
AServoCANError ArduinoCANBus::WriteObject(int16_t node_id, const int32_t& value,
                                int32_t index, int32_t subIndex,
                                uint32_t& abortcode)
{
    uint8_t can_txbuff[8] = {
        0,
    };
    uint16_t can_id = 0x600 + node_id;
    can_txbuff[0] = 0x22; // 2F - 1byte, 2B - 2byte, 23 - 4byte, 22 - Not defined
    can_txbuff[1] = (uint8_t)(index >> 0);
    can_txbuff[2] = (uint8_t)(index >> 8);
    can_txbuff[3] = (uint8_t)(subIndex);
    can_txbuff[4] = (uint8_t)(value >> 0);
    can_txbuff[5] = (uint8_t)(value >> 8);
    can_txbuff[6] = (uint8_t)(value >> 16);
    can_txbuff[7] = (uint8_t)(value >> 24);

    unsigned char can_rxbuff[8] = { 0 };
    unsigned long can_rxid = 0x580 + node_id;
    for (int i = 0; i < _retry_count; i++)
    {
        _can.send(can_id, 0, 0, 8, can_txbuff);
        unsigned long time = millis();
        while (millis() - time < _timeout_ms)
        {
            if (_can.recv(&can_rxid, can_rxbuff))
            {
                if (((_can.can_id & 0xF80) == 0x580) && (_can.can_len >= 4))
                {
                    uint8_t ccs = can_rxbuff[0];
                    uint16_t index_ = *(uint16_t*)&can_rxbuff[1];
                    uint8_t subIndex_ = can_rxbuff[3];

                    if (index == index_ && subIndex == subIndex_)
                    {
                        if (ccs == 0x60)
                        {
                            return AServoCANError::NoError;
                        }
                        // Abort SDO Protocol (in case of error)
                        else if (ccs == 0xC0)
                        {
                            // unsigned long abortCode = *(long *)&can_rxbuff[4];
                            dbg_println("set: Abort SDO Protocol.");
                            dbg_println(can_rxbuff[4]);
                            return AServoCANError::AbortCode;
                        }
                    }
                }
            }
            delay(1);
        }
        dbg_print("Timeout.. ");
        dbg_print(i + 1);
        dbg_print(" retry");
        dbg_print(" IndexCode");
        dbg_println(index);
    }
    // delay(5);
    return AServoCANError::Timeout;
}

AServoCANError ArduinoCANBus::ReadObject(int16_t node_id, int32_t& value, int32_t index,
                               int32_t subIndex, uint32_t& abortcode)
{
    uint8_t can_txbuff[8] = {
        0,
    };
    uint16_t buff_id = 0;
    uint8_t buff_len = 0;
    uint16_t can_id = 0x600 + node_id;

    can_txbuff[0] = 0x40; // 2F - 1byte, 2B - 2byte, 23 - 4byte, 22 - Not defined
    can_txbuff[1] = (uint8_t)(index >> 0);
    can_txbuff[2] = (uint8_t)(index >> 8);
    can_txbuff[3] = (uint8_t)(subIndex);
    can_txbuff[4] = (uint8_t)(value >> 0);
    can_txbuff[5] = (uint8_t)(value >> 8);
    can_txbuff[6] = (uint8_t)(value >> 16);
    can_txbuff[7] = (uint8_t)(value >> 24);

    unsigned char can_rxbuff[8] = {
        0,
    };
    unsigned long can_rxid = 0x580 + node_id;
    for (int i = 0; i < _retry_count; i++)
    {
       _can.send(can_id, 0, 0, 8, can_txbuff);
        unsigned long time = millis();
        while (millis() - time < _timeout_ms)
        {
            if (_can.recv(&can_rxid, can_rxbuff))
            {
               if (((_can.can_id & 0xF80) == 0x580) && (_can.can_len >= 4))
               {
                    uint8_t ccs = can_rxbuff[0];
                    uint16_t index_ = *(uint16_t*)&can_rxbuff[1];
                    uint8_t subIndex_ = can_rxbuff[3];

                    if (index == index_ && subIndex == subIndex_)
                    {
                        if (ccs == 0x4F) // Receiving data 1byte
                        {
                            value = *(int8_t*)&can_rxbuff[4];
                            return AServoCANError::NoError;
                        }
                        else if (ccs == 0x4B) // Receiving data 2byte
                        {
                            value = *(int16_t*)&can_rxbuff[4];
                            return AServoCANError::NoError;
                        }
                        else if (ccs == 0x43) // Receiving data 4byte
                        {
                            value = *(int32_t*)&can_rxbuff[4];
                            return AServoCANError::NoError;
                        }

                        else if (ccs == 0xC0) // Abort SDO Protocol (in case of error)
                        {
                            // unsigned long abortCode = *(long *)&can_rxbuff[4];
                            dbg_println("get: Abort SDO Protocol.");
                            dbg_println(can_rxbuff[4]);
                            return AServoCANError::AbortCode;
                        }
                   }
                }
            }
            delay(1);
        }
        dbg_print(node_id);
        dbg_print("축 ");
        dbg_print("Timeout.. ");
        dbg_print(i + 1);
        dbg_print(" retry");
        dbg_print(" IndexCode");
        dbg_println(index);
    }
    // delay(5);
    return AServoCANError::Timeout;
}

int8_t ArduinoCANBus::MakeCheckSum(int8_t* pData, int32_t len)
{
    int8_t crc = 0;

    for (int i = 0; i < len; i++)
    {
        crc += *(pData + i);
    }
    return crc;
}
} // namespace robowell