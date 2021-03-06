/*
* This file makes the pixels imitate rain. When it receives a sound 
* input, it flashes white like lightning. 
*/

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;

import ddf.minim.*;
import ddf.minim.analysis.*;

TestObserver testObserver;
DeviceRegistry registry;

Minim minim;
AudioInput drumbeat;
float drumSensitivity = 5; // Adjust for sensitivity
int rainFreq = 0; // Adjust for frequency of rain

void setup() {
  colorMode(RGB);

  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  
  minim = new Minim(this);
  minim.debugOn();
  
  drumbeat = minim.getLineIn(); 
  
}

void draw() {
 
 if(testObserver.hasStrips) {
   //pixelpusher code is wrapped in here
   registry.startPushing();
   List<Strip> strips = registry.getStrips();
   registry.setAntiLog(true);
   
   Strip strip = strips.get(0);
   /*expected behavior of lightning is that all pixels flash
   * at once. Rain should go three pixels at a time. 2nd pixel
   * should be brightest, while the other two are dimmer.
   */

   for (int p = 0; p < strip.getLength(); p++) {
   	strip.setPixel(0, p);
   }

   if(drumbeat.mix.level() * 100 > drumSensitivity) { 
     
     for (int p = 0; p < strip.getLength(); p++) {
       strip.setPixel(color(#ffffff), p); //lightning
     }    
     
     // if you want to play with a traveling pixel 
     // for (int p = 0; p < strip.getLength(); p++) {
     // 	int idletime = millis() + 2;
     // 	while (idletime>millis()) {
     // 		strip.setPixel(#ffffff, p);
     // 	}
     // }  
   } 
   }
 } 

void stop() {
  //always close Minim audio classes when you are done with them
  drumbeat.close();
  minim.stop();
  super.stop(); 
}
