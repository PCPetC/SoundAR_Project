//////// web cam code ////////
import processing.video.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

Capture cam;

Minim minim;
AudioOutput out;

Oscil   wave;
Midi2Hz midi;

float mapper;

int x, y;

void setup() {
  size(1280, 720);
  frameRate(30);
  background(0);
  printArray(Capture.list());  /// run this to choose a camera
  cam = new Capture(this, 1280, 720);
  cam.start();
  
  // initialize the minim and out objects
  minim = new Minim(this);
  out   = minim.getLineOut();

  // the frequency argument is not actually important here
  // because we will be patching in Midi2Hz
  wave = new Oscil( 300, 0.6f, Waves.TRIANGLE );
  
  // make our midi converter
  midi = new Midi2Hz( 50 );
  
  midi.patch( wave.frequency );
  wave.patch( out );
}


void draw() {
  //if (cam.available()) {
    cam.read();
    cam.loadPixels();

    int theRedPixel = 0;
    float r=0;
    for (int i=0; i<cam.pixels.length; i++) {
      if (red(cam.pixels[i]) > blue(cam.pixels[i])+80 && red(cam.pixels[i]) > green(cam.pixels[i])+80) {
        if (red(cam.pixels[i])>r) {
          r=red(cam.pixels[i]);
          theRedPixel = i;
        }
        //println(theRedPixel);
      }
    }
    x = theRedPixel % cam.width;
    y = theRedPixel / cam.width;
  //}
  image(cam, 0, 0);
  if (x>0) {
    ellipse(x+50, y+50, 100, 100);
    
    float amp = map( x, 0, height, 1, 0 );  
    wave.setAmplitude( amp );
    float freq = map( y, 0, width, 0, 127 );
    midi.setMidiNoteIn( freq );


 
  
  
   
  }
  //keyboard();
  
}


void keyboard(){
  // erase the window to brown
  background( 64, 32, 0 );
  // draw using a beige stroke
  stroke( 255, 238, 192 );
  // draw the waveforms
  for( int i = 0; i < out.bufferSize() - 1; i++ )
  {
    // find the x position of each buffer value
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    // draw a line from one buffer position to the next for both channels
    line( x1, 50 + out.left.get(i)*50, x2, 50 + out.left.get(i+1)*50);
    line( x1, 150 + out.right.get(i)*50, x2, 150 + out.right.get(i+1)*50);
  }   
}

void keyPressed()
{
  if ( key == 'a' ) midi.setMidiNoteIn( 50 );
  if ( key == 's' ) midi.setMidiNoteIn( 52 );
  if ( key == 'd' ) midi.setMidiNoteIn( 54 );
  if ( key == 'f' ) midi.setMidiNoteIn( 55 );
  if ( key == 'g' ) midi.setMidiNoteIn( 57 );
  if ( key == 'h' ) midi.setMidiNoteIn( 59 );
  if ( key == 'j' ) midi.setMidiNoteIn( 61 );
  if ( key == 'k' ) midi.setMidiNoteIn( 62 );
  if ( key == 'l' ) midi.setMidiNoteIn( 64 );
  if ( key == ';' ) midi.setMidiNoteIn( 66 );
  if ( key == '\'') midi.setMidiNoteIn( 67 );
}

void mouseMoved()
{
  // usually when setting the amplitude and frequency of an Oscil
  // you will want to patch something to the amplitude and frequency inputs
  // but this is a quick and easy way to turn the screen into
  // an x-y control for them.
  
  float amp = map( mouseY, 0, height, 1, 0 );
  wave.setAmplitude( amp );
  
  float freq = map( mouseX, 0, width, 110, 880 );
  wave.setFrequency( freq );
}

//////////////////////////////////////////
