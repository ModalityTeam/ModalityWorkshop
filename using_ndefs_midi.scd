// Ndef is a named placeholder for a sound process
Ndef(\x ).play;

// put a sound there
Ndef(\x, { GrayNoise.ar } ).play;
// replace it with a more specific version
Ndef(\x, { GrayNoise.ar([0.2, 0.2]) } ).play;
// or a different sound
Ndef(\x, { Dust.ar([30, 30], 0.5 ) } ).play;

// add a control input, as in all synth funcions
Ndef(\x, { |amp = 0.1| GrayNoise.ar([amp, amp]) } ).play;

// make a simple gui for it, NdefGui
Ndef(\x).gui;

// set amp directly
Ndef(\x).set(\amp, 0.2);
// set amp from unipolar value, by mapping thu \amp spec
Ndef(\x).setUni(\amp, 0.2);


// use a gui as pseudo-physical controller
m = MView(0.25);
// mview sets amp directly
m.action.add ( \setx, { |mv| Ndef(\x).set(\amp, mv.value) });

// mv sets amp thru \amp spec
m.action.add ( \setx, { |mv| Ndef(\x).setUni(\amp, mv.value) });

// change Ndef(\x) to have a freq input (has a default spec)
Ndef(\x, { |amp = 0.1, freq = 220| RLPF.ar(GrayNoise.ar([amp, amp]), freq, 0.2) } ).play;

// change mview's action to set x freq by default spec
m.action.add ( \setx, { |mv| Ndef(\x).setUni(\freq, mv.value) });

// tell the Ndef which spec to use for mapping
Ndef(\x).addSpec (\freq, [200, 20000 ]);
// and change it again to adjust
Ndef(\x).addSpec (\freq, [200, 20000,\exp ]);

// e.g. invert the range ...
Ndef(\x).addSpec (\freq, [20000, 200,\exp ]);

//With Modality:

// the MKtl:
k = MKtl( 'cncn2000' );

//control a parameter
k.elements[\sl][0].action = { |el| Ndef(\x).setUni(\freq, el.value) };

//start / stop
(
~toggleState = false;
k.elements[\play].action = { |el|
	if(el.value==1){
		~toggleState = ~toggleState.not;
	};
	if( ~toggleState.postln ) {
		Ndef(\x).play
	} {
		Ndef(\x).stop
	}
};
)
