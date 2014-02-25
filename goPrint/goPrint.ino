
/*
 Example 38.1 - Sparkfun Thermal Printer Test (COM-10438)
 http://tronixstuff.com/tutorials > chapter 38
 Based on code by Nathan Seidle of Spark Fun Electronics 2011
 */
#include <SoftwareSerial.h>
SoftwareSerial Thermal(2, 3);
int heatTime = 100;
int heatInterval = 255;
char printDensity = 15; 
char printBreakTime = 15;

byte petting = 0;
byte pressure = 0;
int range = 0;
boolean finish = false;

void setup() {
  Serial.begin(9600); // for debug info to serial monitor
  Thermal.begin(19200); // to write to our new printer
  initPrinter();

}

void initPrinter(){
  //Modify the print speed and heat
  Thermal.write(27);
  Thermal.write(55);
  Thermal.write(7); //Default 64 dots = 8*('7'+1)
  Thermal.write(heatTime); //Default 80 or 800us
  Thermal.write(heatInterval); //Default 2 or 20us
  //Modify the print density and timeout
  Thermal.write(18);
  Thermal.write(35);
  int printSetting = (printDensity<<4) | printBreakTime;
  Thermal.write(printSetting); //Combination of printDensity and printBreakTime

}
void loop(){

    if((petting > 0) && (petting <= 5)&&(range != 0)){

      Thermal.println("You Are Calm.");
      range = 0;

    }
    else if(( petting > 5) && (petting <= 12)&&(range != 1)){
      Thermal.println("You Are Getting Anxious!");
      range = 1;
    }
    else if((petting > 12)&&(range != 2)){
      Thermal.println("You Are A Psychopath!");
      range = 2;
    }
    
    
  if(Serial.available() > 0){

    petting = Serial.read();
    //  pressure = Serial.parseInt();


    //  Thermal.println("############");
    //  Thermal.println("");
    //  Thermal.print("How Quick You Pet: ");
    //  Thermal.println(petting);
    //  Thermal.println("");
    //  delay(300);

//    Thermal.print("Petting is ");
//    Thermal.print(petting);
//    Thermal.print(" and range is ");
//    Thermal.println(range);
  }
}



