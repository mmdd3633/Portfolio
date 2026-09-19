/*  PRIZM Pro Controller example program
 *  Blink the PRIZM Pro Pixel 1 red at a 1 second flash rate
 *  author PWU on 11/07/2024
*/
  
  #include <PRIZM_PRO.h>      // include the PRIZM Pro library

  PRIZM prizm;                // instantiate a PRIZM Pro object "prizm" so we can use its functions

void setup() {

   prizm.PrizmBegin();   // initialize the PRIZM Pro controller

}

void loop() {     // repeat this code in a loop

  prizm.setRedLED(HIGH);    // turn the RED LED on (Red defaults to pixel 1, Green to pixel 2 and Blue to pixel 3)
  delay(1000);              // wait here for 1000ms (1 second)
  prizm.setRedLED(LOW);     // turn the RED LED off 
  delay(1000);              // wait here for 1000ms (1 second)

 
}