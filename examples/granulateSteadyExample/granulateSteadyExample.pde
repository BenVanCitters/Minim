/* granulateSteadyExample
   is an example of using the Granulate Steady UGen inside an instrument.
   The steady granulation is used first to create rhythms, and then is used
   to create tones, effectively like a duty cycle amplitude modulation.
   author: Anderson Mills
   Anderson Mills's work was supported by numediart (www.numediart.org)
*/

// import everything necessary to make sound.
import ddf.minim.*;
import ddf.minim.ugens.*;

// create all of the variables that will need to be accessed in
// more than one methods (setup(), draw(), stop()).
Minim minim;
AudioOutput out;

// setup is run once at the beginning
void setup()
{
  // initialize the drawing window
  size( 512, 200, P2D );

  // initialize the minim and out objects
  minim = new Minim( this );
  out = minim.getLineOut( Minim.MONO, 2048 );
  
  // pause time when adding a bunch of notes at once
  // This guarantees accurate timing between all notes added at once.
  out.pauseNotes();
  
  // I want a pause before the music starts
  out.setNoteOffset( 1.0 );
  
  // set the tempo for the piece
  // Since the parameters of GranulateSteady ore specified in seconds and not "beats"
  // it's easier to keep everything in the same reference frame by setting BPM to 60.
  out.setTempo( 60.0 );
  
  // The base hits for this section
  out.playNote( 0.000, 16.0, new SteadyGrainInstrument( 110f, 0.5, 1.0, 0.05, out) );
  out.playNote( 0.125, 16.0, new SteadyGrainInstrument( 110f, 0.5, 1.0, 0.05, out) );
 
  // The "snare" hits come in
  out.playNote( 4.500, 11.500, new SteadyGrainInstrument( 1320f, 0.3, 1.0, 0.03, out) );
  out.playNote( 4.625, 11.325, new SteadyGrainInstrument( 1320f, 0.3, 1.0, 0.03, out) );
  
  // Start doubling up the bass and snare in the 4th measure
  out.playNote( 7.250, 8.750, new SteadyGrainInstrument( 110f, 0.5, 4.0, 0.0125, out) );
  out.playNote( 7.375, 8.625, new SteadyGrainInstrument( 110f, 0.5, 4.0, 0.0125, out) );
  out.playNote( 7.750, 8.250, new SteadyGrainInstrument( 1320f, 0.3, 4.0, 0.0125, out) );
  out.playNote( 7.875, 8.125, new SteadyGrainInstrument( 1320f, 0.3, 4.0, 0.0125, out) );

  // At the beginning of the 8th measure add in a me-me-me-me  
  out.playNote( 8.00, 8.00, new SteadyGrainInstrument( 4840f, 0.1, 0.125, 0.50, out) );
  // And eventually put in a syncopated we-we-we-we which lasts past the section end
  out.playNote( 12.0625, 8.00, new SteadyGrainInstrument( 7260f, 0.06, 0.125, 0.75, out) );

  // start a new section --------------------------------------------------------------
  out.setNoteOffset( 16.0 );
 
  // Keep the bass hits going
  out.playNote( 0.000, 8.50, new SteadyGrainInstrument( 110f, 0.5, 2.0, 0.03, out) );
  out.playNote( 0.125, 8.50, new SteadyGrainInstrument( 110f, 0.5, 2.0, 0.03, out) );

  // create tones using the GranulateSteady.  This starts to happen when the grains
  // have a period of less than 50 msec.  At that rate, the grains start to be played
  // back at audio rate.
  out.playNote( 0.00, 4.00, new SteadyGrainInstrument( 9680f, 0.1, 0.042, 0.20, out) );
  out.playNote( 0.50, 4.00, new SteadyGrainInstrument( 7260f, 0.1, 0.031, 0.50, out) );
  out.playNote( 1.00, 4.00, new SteadyGrainInstrument( 4840f, 0.1, 0.031, 0.50, out) );
  out.playNote( 2.00, 4.00, new SteadyGrainInstrument( 2420f, 0.1, 0.020, 0.50, out) );
  out.playNote( 2.50, 4.00, new SteadyGrainInstrument( 1815f, 0.1, 0.010, 0.50, out) );
  out.playNote( 3.00, 4.00, new SteadyGrainInstrument( 1210f, 0.1, 0.010, 0.50, out) );
  out.playNote( 4.00, 4.00, new SteadyGrainInstrument( 550f, 0.1, 0.012, 0.50, out) );
  out.playNote( 5.002, 3.00, new SteadyGrainInstrument( 775f, 0.1, 0.012, 0.750, out) );
  out.playNote( 6.008, 2.00, new SteadyGrainInstrument( 775f, 0.2, 0.012, 0.750, out) );
  out.playNote( 7.00, 1.00, new SteadyGrainInstrument( 775f, 0.1, 0.012, 0.750, out) );
 
  // finally, resume time after adding all of these notes at once.
  out.resumeNotes();
}

// draw is run many times
void draw()
{
  // erase the window to grey
  background( 192 );
  // draw using a black stroke
  stroke( 0 );
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

// stop is run when the user presses stop
void stop()
{
  // close the AudioOutput
  out.close();
  // stop the minim object
  minim.stop();
  // stop the processing object
  super.stop();
}
