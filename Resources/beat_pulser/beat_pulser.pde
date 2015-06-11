// Basic beat detector that listens to the microphone sends pulses down an LED strip 
// based on the volume and frequency of the sounds it hears.

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import javax.sound.sampled.*;

import java.awt.Frame;
import java.awt.BorderLayout;

import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.core.*;
import controlP5.*;

// Slowly fade from red to blue

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

import processing.core.*;
import java.util.*;

DeviceRegistry registry;
TestObserver testObserver;
BeatListener bl;Minim minim;
AudioPlayer song;
BeatDetect beat;
FFT fft;

int c = 70;
boolean ascending = true;

void setup() {
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  minim = new Minim(this);
  
  song = minim.loadFile("/Users/dcook/Music/FLACs/In The Ghetto Tonight.mp3", 1024);
  song.play();
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(50);
  bl = new BeatListener(beat, song);
  fft = new FFT(song.bufferSize(), song.sampleRate()); 
  
//  colorMode(HSB, 100);
  frameRate(3it0);
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
    
    if(beat.isKick()) {
      println("kick");
      for (int p = 0; p < strip.getLength(); p++) {
        strip.setPixel(color(#ff0000), p); //red
      }
    } 
    if(beat.isSnare()) {
      println("snare");
      for (int p = 0; p < strip.getLength(); p++) {
        strip.setPixel(color(#002bff), p); //blue
      }
    } 
    if(beat.isHat()) {
       println("hat");
       for (int p = 0; p < strip.getLength(); p++) {
        strip.setPixel(color(#ffffff), p); //white
      }
    }
  }
}
