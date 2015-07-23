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
float drumSensitivity = 0.9; // Adjust for sensitivity
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
   if(drumbeat.mix.level() * 100 > drumSensitivity) { 
     
     for (int p = 0; p < strip.getLength(); p++) {
       strip.setPixel(color(#ffffff), p); //lightning
     }    
   } 
   else {
     registry.setExtraDelay(rainFreq);
     for (int p = 0; p < strip.getLength(); p++) {
       
       //rain
       if(p==0) { //indexOutofRange logic
       	strip.setPixel(color(#1AC2FF), p);
       	strip.setPixel(color(#0078A3), p+1);
       } else if (p==strip.getLength()-1) {
       	strip.setPixel(color(#0078A3), p-1);
       	strip.setPixel(color(#1AC2FF), p);
       } else {
       	strip.setPixel(color(#0078A3), p-1);
       	strip.setPixel(color(#1AC2FF), p);
       	strip.setPixel(color(#0078A3), p+1);
       }


     }
   }
 } 
}

void stop() {
  //always close Minim audio classes when you are done with them
  drumbeat.close();
  minim.stop();
  super.stop(); 
}
