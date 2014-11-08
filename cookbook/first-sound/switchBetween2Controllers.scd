s.boot;

/* Same example as firstSound, with one difference:
It can use both a nanoKontrol2 and a nanoKontrol2,
and shows how to write code in a way that switching
to a different controller becomes simple.

*/

// For a more detailed version of this file, see
"Tutorials/ModalityTutorial".openHelpFile

// a dictionary to put global variables in
q = ();

// open the nanoKontrol2
k = MKtl('nnkn20');
// can do everything from gui if desired
k.gui;


// open the nanoKontrol2 if you have one
n = MKtl('nnkn0');
// can do everything from gui if desired
n.gui;
/*
// in case you forgot to plug it in,
// you can still do it now:
MKtl.find(\midi);
n.openDevice;
*/

// create a Synth to control
(
SynthDef(\blippy, {
    var sound = Blip.ar(
        \freq.kr(440).lag(0.1),
        \numHarmonics.kr(100),
        \amp.kr(1.0).lag(0.1)
    ) * 0.5;

    sound = RLPF.ar(sound, 5000);
    Out.ar(0, Pan2.ar(sound, \pan.kr(0).lag(0.1) ) )
}).add
)


//start it
x = Synth(\blippy, [\freq, 440, \numHarmonics, 100, \amp, 0.5, \pan, 0]);


//clear all actions first
k.reset; n.reset;


// if you use a nano2, do these:
q.sliders = k.elementAt(\sl);
q.knobs = k.elementAt(\kn);


// the old nanoKontrol has 4 hardware scenes,
// so select the sliders and knobs from scene 1:
q.sliders = n.elementAt(\sl, 0);
q.knobs = n.elementAt(\kn, 0);


// now this part is independent of the controller:
(
//knob 1 -> amplitude
q.knobs[0].action_({ |el| x.set(\amp, el.value) });

//knob 2 -> pan
q.knobs[1].action_({ |el| x.set(\pan, el.value.linlin(0.0, 1.0, -1.0, 1.0) ) });
// or use a spec \pan for it
q.knobs[1].action_({ |el| x.set(\pan, \pan.asSpec.map(el.value)) });


//slider 1 -> frequency
q.sliders[0].action_({ |el| x.set(\freq, el.value.linlin(0.0, 1.0, 100, 400) ) });

//slider 2 -> number of harmonics
q.sliders[1].action_({ |el| x.set(\numHarmonics, el.value.linexp(0.0, 1.0, 5, 200) ) });
)

