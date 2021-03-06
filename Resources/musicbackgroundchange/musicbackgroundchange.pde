// http://code.compartmental.net/minim/index.html
// the point of this is to try to get a circle to oscillate
// based on hat, kick, snare. # of circles should be determined by
// dectectSize(). 

import ddf.minim.*;
import ddf.minim.analysis.*;
import java.util.Random;

Minim minim;
AudioPlayer song;
BeatDetect beat;
FFT fft;
Random rand;
BeatListener bl;

float hRadius, kRadius, sRadius;
int r;

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
	size(1024,1024,P3D);

	minim = new Minim(this);

	song = minim.loadFile("noexcuses.mp3", 1024);
	song.play();
	beat = new BeatDetect(song.bufferSize(), song.sampleRate());
	beat.setSensitivity(50);
	bl = new BeatListener(beat, song);
	fft = new FFT(song.bufferSize(), song.sampleRate()); 

	ellipseMode(RADIUS);
	hRadius = 20;
	kRadius = 20;
	sRadius = 20;

	rand = new Random();
}

void draw() {
	background(0);
	fft.forward(song.mix);
	float a = map(kRadius, 20, 80, 60, 255);
	float whichRadius;

	if(beat.isKick()) kRadius = 80;
	if(beat.isSnare()) sRadius = 80;
	if(beat.isHat()) hRadius = 80;

// need to limit the number of circles... also, i think rows are identical...
// how can we split these up and mix it up? 
	for(int i=1; i<=4; i++) {
		for (int j = 1; j<=4; j++) {
			if(i%3==0) {
				whichRadius = kRadius;
			} else if (i%3 == 1) {
				whichRadius = sRadius;
			} else {
				whichRadius = hRadius;
			}
			println(5-i);
			println(5-j);
			ellipse(width/(5-i), height/(5-j), whichRadius, whichRadius);
		}
	}

	//if (beat.isOnset() ) r = rand.nextInt(fft.specSize());
	//fill(r*20%255, r%124, r-30, a); //a = alpha = opacity
	

	kRadius *= 0.95;
	sRadius *= 0.95;
	hRadius *= 0.95;
	if (kRadius < 20) kRadius = 20;
	if (sRadius < 20) sRadius = 20;
	if (hRadius < 20) hRadius = 20;
}
