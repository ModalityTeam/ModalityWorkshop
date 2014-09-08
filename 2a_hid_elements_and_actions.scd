/// Now that we have a device up and defined, what can we do with it?
k = MKtl( 'rnnd0' );

// print a nice list of elements
k.printElementNames;

// the buttons - in this case they are just numbered according to their labels:
k.elements[\b1]

// the joysticks are hierarchical - two joysticks with each x and y:
k.elements[\joy];
k.elements[\joy][\l];
k.elements[\joy][\l][\x];

// or use another syntax:
k.elementAt( \joy, \l, \x );

// in the printed element names, these show up with "_" in between: joy_l_x

// getting the current value:
k.elements[\joy][\l][\x].value;


//Add an action to the element:
k.elements[\joy][\l][\x].action_({ |mktlElement| mktlElement.value.postln })

//to remove the action
k.elements[\joy][\l][\x].reset

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

//y-axis -> amplitude (0.5 is rest position, so we rescale to range of [-1,1]
k.elements[\joy][\l][\y].action_({ |mktlElement| x !? _.set(\amp, mktlElement.value - 0.5 * 2) });

//x-axis -> pan
k.elements[\joy][\l][\x].action_({ |mktlElement| x !? _.set(\pan, mktlElement.value.linlin(0.0, 1.0, -1.0, 1.0) ) });

//other joystick y -> frequency
k.elements[\joy][\r][\y].action_({ |mktlElement| x !? _.set(\freq, mktlElement.value.linlin(0.0, 1.0, 200, 2000) ) });

//other joystick x -> number of harmonics
k.elements[\joy][\r][\x].action_({ |mktlElement| x !? _.set(\numHarmonics, mktlElement.value.linexp(0.0, 1.0, 1, 200) ) });

// button 6 (right shoulder) -> start and stop synth
k.elements[\b6].action_({  |mktlElement|
    if(mktlElement.value.booleanValue) {
        x !? _.free;
        x = Synth(\blippy, [\freq, 440, \numHarmonics, 100, \amp, 0.5, \pan, 0])
    } {
        x !? _.free;
        x = nil;
    }
})
)
);

// clear all functions
k.reset;
// stop the synth:
x.free;


// assigning multiple actions can be done with .addAction;
(
k.elements[\joy][\l][\x].addAction({ |mktlElement| ("1 :"++mktlElement.value).postln });
k.elements[\joy][\l][\x].addAction({ |mktlElement| ("2 :"++mktlElement.value).postln });
)
//clear all
k.elements[\joy][\l][\x].reset

/// to remove them you need to have a reference to the function
(
f = { |mktlElement| ("1 :"++mktlElement.value).postln };
g = { |mktlElement| ("2 :"++mktlElement.value).postln };
k.elements[\joy][\l][\x].addAction(f);
k.elements[\joy][\l][\x].addAction(g);
)

//remove first action
k.elements[\joy][\l][\x].removeAction(f);
// just 2 is left

//clear all
k.elements[\joy][\l][\x].reset


/// =========== output to elements =============

// sending data to the output elements (may not work properly on OSX with HID)
// value range between 0 and 1, will be mapped according to the spec given in the description file
k.elements[\rumble][\l].value = 0.75;
k.elements[\rumble][\l].value = 0;
k.elements[\rumble][\r].value = 0.5;
k.elements[\rumble][\r].value = 0;
