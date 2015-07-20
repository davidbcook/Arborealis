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

Minim minim;
AudioInput drumbeat;
int drumDecibels = 50; // Adjust for sensitivity
int rainFreq = 800; // Adjust for frequency of rain

class BeatListener implements AudioListener {
  private BeatDetect beat;
  private AudioPlayer source;
  
  BeatListener(BeatDetect beat, AudioPlayer source) {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps) {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR) {
    beat.detect(source.mix);
  }
}

void setup() {
  colorMode(RGB);

  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  
  minim = new Minim(this);
  minim.debugOn();
  
  drumbeat = minim.getLineIn(Minim.STEREO, 1024); //song input here
  
}

void draw() {
 
 if(testObserver.hasStrips) {
   //pixelpusher code is wrapped in here
   registry.startPushing();
   List<Strip> strips = registry.getStrips();
   registry.setAntiLog(true);
   
   /*expected behavior of lightning is that all pixels flash
   * at once. Rain should go three pixels at a time. 2nd pixel
   * should be brightest, while the other two are dimmer.
   */
   if(drumbeat.getGain() > drumDecibels) { 
     for (int p = 0; p < strip.getLength(); p++) {

       strip.setPixel(color(#ffffff), p); //lightning

     }    
   } else {
     registry.setExtraDelay(rainFreq);
     for (int p = 0; p < strip.getLength(); p++) {
       
       //rain
       if(p=0) { //indexOutofRange logic
       	strip.setPixel(color(#1AC2FF), p);
       	strip.setPixel(color(#0078A3), p+1);
       } else if (p=strip.getLength()-1) {
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
