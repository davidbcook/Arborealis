import ddf.minim.*;

Minim minim;
AudioInput in;

color white;

void setup() {
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

void draw() {
	background(0);

	//this controls the circle and the color. We'll have
	//to change this to react to lights one we're hooked up. 
	for (int i=0; i<in.bufferSize() - 1; i++) {
		fill((1+in.mix.get(i))*50,(1+in.left.get(i))*100,(1+in.right.get(i))*100);
		ellipse(width/2, height/2, 100, 100);

	}
}

void stop() {
	// always close Minim audio classes when you are done with them
	in.close();
	minim.stop();
	super.stop(); 
}

