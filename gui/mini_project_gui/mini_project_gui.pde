//CODE for GUI, done in Processing 

/* 
    Written:       29.04.2026 
    Revision:      1.0 
    Hardware:      MSP430 
    Description: Mini(not mini) Project 

    History: 

    Configuration: 
    USB to mini USB cable connection between to MSP430 board 
    and PC 
*/ 

import processing.serial.*; // library to use serial ports 
Serial port;  

// declaring variables for all important readings 
int[] sw_stat = new int[8]; 
float Vpot = 3.02; 
int sampleValue = 1024;  
int display_swnum = 10; 

void setup(){ 
  print(Serial.list()); 
  port = new Serial(this, Serial.list()[2], 9600); // slelcting port to work with 
  port.bufferUntil('\n'); // parsing incoming data until enter 

  //setting window design for GUI
  size(700, 400); 
  background(255); 
  strokeWeight(4);
} 

void serialEvent(Serial port){ // serial event dor parsing data 
  String input = port.readStringUntil('\n'); 

  if (input != null) { 
    // The data is split into an array of Strings with spaces and put in int and float arrays 
    int[] vals = int(split(input, " ")); 
    float[] valsf = float(split(input, " "));  

    // assigning appropriate values from array to readings variables 
    for(int i = 0; i<8; i++){ 
      sw_stat[i] = vals[i]; 
      print(str(sw_stat[i]) + " "); 
    } 

    display_swnum = vals[8]; 
    sampleValue = vals[9]; 
    Vpot = valsf[10]; 
    print(str(display_swnum) + " "); 
    print(str(sampleValue) + " "); 
    println(str(Vpot)); 
  } 
} 

void draw(){ 
  // drawing GUI 
  background(255); 

  line(350, 0, 350, 400); 
  line(0, 100, 350, 100); 
  line(0, 250, 350, 250); 
  line(175, 250, 175, 400); 

  textSize(16); 
  fill(0); 
  text("St. number:", 10, 20); 
  textSize(50); 
  fill(0); 
  text("12345678", 60, 70); 

  switch_status(); // function to show switches status  

  POT_Brigghtness(); // function to show POT voltage readings and correspondive 7-seg brightness 

  seven_seg(); // function to display witch number is shown on 7-seg display 
} 

void seven_seg(){    
  int brightness = sampleValue/4;// sample value is 0-1024 and rgb values for colours are in range 0-255 
  textSize(32); 
  fill(0); 
  text("7-segment Display ", 400, 40); 

  if(display_swnum >=  0 && display_swnum <=  9){ // if numbers are from 0-9 show them 
    textSize(300); 
    fill(brightness, 0, 0); 
    text(display_swnum, 450, 300); 
  } 

  else{ // else show BLANK on screen 
    textSize(80); 
    fill(0); 
    text("BLANK", 420, 250); 
  } 

} 

void POT_Brigghtness(){ 
  int brightness = sampleValue/4; 
  textSize(16); 
  fill(0); 
  text("POT Voltage", 10, 270); 
  textSize(50); 
  fill(0); 
  text(Vpot+" V", 25, 350); 
  textSize(16); 
  fill(0); 
  text("7-seg brightness", 185, 270); 
  fill(brightness, 0, 0); // filling the circle with coresponding colour to brightness of seven seg diplay 
  ellipse(262, 330, 60, 60); 
} 

void switch_status(){ 
  textSize(16); 
  fill(0); 
  text("Switch Status:", 10, 120); 
  for (int i = 0; i < 8; i++) { // loop for drawing each off 8 indicators 
    int x = 35 + i * 40; // x position of each circle indicator 
    fill(0); 
    textSize(14); 
    text(i + 1, x, 160); // number of each indicator 

    if (sw_stat[i] == 1) { // if switch status is 1 
      fill(0, 255, 0); // fill circle indicator with green colour 
    } else { 
      fill(255); // fill white 
    } 

    ellipse(x, 190, 24, 24); // draw circle for each indicator 
  } 

}
