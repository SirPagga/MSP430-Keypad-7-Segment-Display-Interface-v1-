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

//BCD inputs
#define D0 P2_3
#define D1 P2_5
#define D2 P1_7
#define D3 P2_4
//MUX select
#define S0 P2_0
#define S1 P2_1
#define S2 P2_2

#define TIP121 P1_6 // brightnes reg
#define POT P1_4 // POT input
#define Y P1_3 // MUX for switch input

int PWM_Value = 0;

int st_num[15] = {0, 10, 0, 10, 0, 10, 4, 10, 7, 10, 4, 10, 7, 10, 0}; //array for student num
bool sw_stat[8] = {0}; // array for switch statuses

int display_swnum = 10; // var. that shows which switch is turned on
int checkSwitches(bool arr[8]) { // function that dtermine which switch from array is turned on
    int count = 0;
    int last_pos = 10;

    for (int i = 0; i < 8; i++) {
        if (arr[i] == 1) { // if there is 1 in array
            count++; // increase count
            last_pos = i; // remember the position of last 1 in array
        }
    }
    if (count == 1) {
        return last_pos + 1; // switches are 1-8, while array pos are 0-7
    } else {
        return 10;
    }
}

void setup() {
  //put your setup code here, to run once
  Serial.begin(9600);
  // declaring each pin
  pinMode(D0, OUTPUT);
  pinMode(D1, OUTPUT);
  pinMode(D2, OUTPUT);
  pinMode(D3, OUTPUT);
  pinMode(S0, OUTPUT);
  pinMode(S1, OUTPUT);
  pinMode(S2, OUTPUT);
  pinMode(TIP121, OUTPUT);
  pinMode(POT, INPUT);
  pinMode(Y, INPUT_PULLUP);

  for(int num = 0; num<15; num++){ // displaying student number in sequence using bitread
    digitalWrite(D0, bitRead(st_num[num], 0)); 
    digitalWrite(D1, bitRead(st_num[num], 1)); 
    digitalWrite(D2, bitRead(st_num[num], 2)); 
    digitalWrite(D3, bitRead(st_num[num], 3)); 
    if(num%2==0){
    //Serial.print(st_num[num]); 
    }
    delay(500);  
  } 

}

void loop() {
  //put your main code here, to run repeatedly

  int sampleValue  = analogRead(POT); // sampleValue-Voltage convertion for POT
  float Vpot = sampleValue*0.00322; // Voltage on POT
  PWM_Value = 255-sampleValue/4; // calculating pwm value for LED brightness
  
  analogWrite(TIP121, PWM_Value); // changing PWM value on board 
  
  for(int sel = 0; sel<8; sel++){ // changing select input on MUX to fill switch array
    digitalWrite(S0, bitRead(sel, 0)); 
    digitalWrite(S1, bitRead(sel, 1)); 
    digitalWrite(S2, bitRead(sel, 2));
    delay(10); // 
    sw_stat[sel] = digitalRead(Y); // filling aaray with selected output
  }

  display_swnum = checkSwitches(sw_stat); // ussing fucntion to get position of turned on switch

  //sending swtich number to BCD decoder input to show position of switch on display
  digitalWrite(D0, bitRead(display_swnum, 0)); 
  digitalWrite(D1, bitRead(display_swnum, 1)); 
  digitalWrite(D2, bitRead(display_swnum, 2)); 
  digitalWrite(D3, bitRead(display_swnum, 3)); 
  
   for(int sel = 0; sel<8; sel++){ // sending all essential data to serial commport in string
    Serial.print(String(sw_stat[sel])+" ");
    }
    Serial.print(String(display_swnum)+" ");
    Serial.print(String(sampleValue)+" ");
    Serial.println(String(Vpot));

    delay(100); // delay 0.1s
  }
  
