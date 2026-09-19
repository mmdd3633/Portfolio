module imu_i2c_mode_pins (
    output wire GYRO_CS_AG,
    output wire GYRO_CS_M,
    output wire GYRO_SDO_AG,
    output wire GYRO_SDO_M,
    output wire GYRO_DEN_AG
);
    assign GYRO_CS_AG  = 1'b1;
    assign GYRO_CS_M   = 1'b1;
    assign GYRO_SDO_AG = 1'b0;
    assign GYRO_SDO_M  = 1'b0;
    assign GYRO_DEN_AG = 1'b0;
endmodule
