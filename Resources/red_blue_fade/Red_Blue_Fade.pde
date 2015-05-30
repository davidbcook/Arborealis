// Slowly fade from red to blue

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

import processing.core.*;
import java.util.*;

DeviceRegistry registry;

class TestObserver implements Observer {
  public boolean hasStrips = false;
  public void update(Observable registry, Object updatedDevice) {
        println("Registry changed!");
        if (updatedDevice != null) {
          println("Device change: " + updatedDevice);
        }
        this.hasStrips = true;
    }
};

TestObserver testObserver;
int c = 70;
boolean ascending = true;

void setup() {
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  colorMode(HSB, 100);
  frameRate(5);
}

void draw() {
  if (testObserver.hasStrips) {
    registry.startPushing();
    List<Strip> strips = registry.getStrips();
    
    int numStrips = 1;
    
    for (int stripNo = 0; stripNo < numStrips; stripNo++) {
      fill(c+(stripNo*2), 100, 100);
      rect(0, stripNo * (height/numStrips), width, (stripNo+1) * (height/numStrips));
    }
    
    Strip strip = strips.get(0);
    if (ascending) {
      for (int p = 0; p < strip.getLength(); p++) {
        strip.setPixel(color(c,100,100), p);
      }
      c++;
    } else {
      for (int p = 0; p < strip.getLength(); p++) {
        strip.setPixel(color(c,100,100), p);
      }
      c--;
    }
    if (c == 100 || c == 70) {
      ascending = !ascending;
    }
  }
}
