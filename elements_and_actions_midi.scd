/// Now that we have a device up and defined, what can we do with it?
MKtl.find;
k = MKtl( 'cncn2000' ); // an iControls

// or if it is a nanoKontrol 2:
k = MKtl( 'nnkn20' );


// print a nice list of elements
k.printElementNames;

// all the elements are hierarchical:
k.elements[\bt]
k.elements[\kn]
k.elements[\sl]

// the sliders
k.elements[\sl];
k.elements[\sl][0];

// the buttons:
k.elements[\bt]    // all ordered buttons, left to right
k.elements[\bt][0] // that is rows
k.elements[\bt][0][0] // and then columns

// or use another syntax:
k.elementAt( \bt, 0, 0 );

// in the printed element names, these show up with "_" in between: joy_l_x
k.printElementNames;

// getting the current value:
k.elements[\bt][0][0].value;

k.elements[\sl][0].value;

// value is automatically mapped between 0 and 1

//Add an action to the element:
k.elements[\sl][0].action_({ |mktlElement| mktlElement.value.postln })

//to remove the action
k.elements[\sl][0].reset

// example with sound:
s.boot;

(
SynthDef(\blippy, {
    var out = Blip.ar(\freq.kr(440).lag(0.1), \numHarmonics.kr(100), \amp.kr(1.0).lag(0.1) ) * 0.5;
    Out.ar(0, Pan2.ar(out, \pan.kr(0).lag(0.1) ) )
}).add
);

//start it
x = Synth(\blippy, [\freq, 440, \numHarmonics, 100, \amp, 0.5, \pan, 0]);

(
//clear all actions first
k.reset;

//slider 0 -> amplitude
k.elements[\sl][0].action_({ |mktlElement| x !? _.set(\amp, mktlElement.value) });

//knob 0 -> pan
k.elements[\kn][0].action_({ |mktlElement| x !? _.set(\pan, mktlElement.value.linlin(0.0, 1.0, -1.0, 1.0) ) });

//slider 1
k.elements[\sl][1].action_({ |mktlElement| x !? _.set(\freq, mktlElement.value.linlin(0.0, 1.0, 200, 2000) ) });

//knob 1 -> number of harmonics
k.elements[\kn][1].action_({ |mktlElement| x !? _.set(\numHarmonics, mktlElement.value.linexp(0.0, 1.0, 1, 200) ) });
)

(
// play button -> start and stop synth
k.elements[\play].action_({  |mktlElement|
    if(mktlElement.value.booleanValue) {
        x !? _.free;
        x = Synth(\blippy, [\freq, 440, \numHarmonics, 100, \amp, 0.5, \pan, 0])
    } {
        x !? _.free;
        x = nil;
    }
});
);

// clear all functions
k.reset;
// stop the synth:
x.free;


// assigning multiple actions can be done with .addAction;
(
k.elements[\sl][0].addAction({ |mktlElement| ("1 :"++mktlElement.value).postln });
k.elements[\sl][0].addAction({ |mktlElement| ("2 :"++mktlElement.value).postln });
)
//clear all
k.elements[\sl][0].reset;

/// to remove them you need to have a reference to the function
(
f = { |mktlElement| ("1 :"++mktlElement.value).postln };
g = { |mktlElement| ("2 :"++mktlElement.value).postln };
k.elements[\sl][0].addAction(f);
k.elements[\sl][0].addAction(g);
)

//remove first action
k.elements[\sl][0].removeAction(f);
// just 2 is left

//clear all
k.elements[\sl][0].reset


/// =========== output to elements (if you have any on your midi device) =============

// check which inputs are there:
k.inputElements;

// check which outputs are there:
k.outputElements;

// my device has none...

// sending data to the output elements
// value range between 0 and 1, will be mapped according to the spec given in the description file
/*
k.elements[\rumble][\l].value = 0.75;
k.elements[\rumble][\l].value = 0;
k.elements[\rumble][\r].value = 0.5;
k.elements[\rumble][\r].value = 0;
*/