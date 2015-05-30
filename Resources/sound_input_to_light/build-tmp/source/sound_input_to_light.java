import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sound_input_to_light extends PApplet {



Minim minim;
AudioInput in;

int white;

public void setup() {
	size(512, 200, P2D);
	white = color(255);
	colorMode(HSB, 100);
	minim = new Minim(this);
	minim.debugOn();

	// get a line in from Minim, default bit depth is 16
	// we can replace this with the mic source on the drums
	in = minim.getLineIn(Minim.STEREO, 512);
	background(0);
}

public void draw() {
	background(0);

	//draw the wave forms
	for (int i=0; i<in.bufferSize() - 1; i++) {
		fill((1+in.mix.get(i))*50,(1+in.left.get(i))*100,(1+in.right.get(i))*100);
		ellipse(width/2, height/2, 100, 100);

		//stroke((1+in.left.get(i))*50,100,100);
		//line(i, 50+in.left.get(i)*50, i+1, 50+in.left.get(i+1)*50);
		//stroke(white);
		//line(i, 150+in.right.get(i)*50, i+1, 150+in.right.get(i+1)*50);
	}
}

public void stop() {
	// always close Minim audio classes when you are done with them
	in.close();
	minim.stop();
	super.stop(); 
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sound_input_to_light" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
