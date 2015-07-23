import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import com.heroicrobot.dropbit.registry.*; 
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel; 
import com.heroicrobot.dropbit.devices.pixelpusher.Strip; 
import java.util.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class lightning extends PApplet {

/*
* This file makes the pixels imitate rain. When it receives a sound 
* input, it flashes white like lightning. 
*/









TestObserver testObserver;
DeviceRegistry registry;

Minim minim;
AudioInput drumbeat;
float drumSensitivity = 5; // Adjust for sensitivity
int rainFreq = 0; // Adjust for frequency of rain

public void setup() {
  colorMode(RGB);

  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  
  minim = new Minim(this);
  minim.debugOn();
  
  drumbeat = minim.getLineIn(); 
  
}

public void draw() {
 
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
       strip.setPixel(color(0xffffffff), p); //lightning
     }    
     
     // if you want to play with a traveling 
     // for (int p = 0; p < strip.getLength(); p++) {
     // 	int idletime = millis() + 2;
     // 	while (idletime>millis()) {
     // 		strip.setPixel(#ffffff, p);
     // 	}
     // }  
   } 
   }
 } 

public void stop() {
  //always close Minim audio classes when you are done with them
  drumbeat.close();
  minim.stop();
  super.stop(); 
}
class TestObserver implements Observer {
  public boolean hasStrips = false;
  public void update(Observable registry, Object updatedDevice) {
    println("Registry changed!");
    if (updatedDevice !=null) {
      println("Device change: " + updatedDevice);
    }
    this.hasStrips=true;
  }
};
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "lightning" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
