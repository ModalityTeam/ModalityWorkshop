/////////////////
// access a keyboard and play a basic multitimbral sound
// uses NPVoicer from the JITLibExtensions quark
/*
"JITLibExtensions".include;
*/

// boot server
s.boot;
s.latency = nil; // make sure there is no artificial latency


m = MKtl('op1', "teenage-engineering-op-1");

// basic gui to see all elements and names
m.gui;
// when the desc has layout info, use this:
// MKtlGUI(mktl: m);
(
(
SynthDef(\a, {|out = 0, amp = 0.25, midiNote = 50, bendFac = 0.5, res = 0, ffac = 1, gate = 1|
	var freq = (midiNote + (12 * bendFac)).midicps;
	var env = EnvGen.kr(Env.adsr(0.1, releaseTime: 0.1), gate, doneAction: 2);
	var src = Saw.ar(freq) * env;
	var ffreq = freq * ffac;

	var rq = 0.1 ** res.clip(0, 1);
	src = RLPF.ar(src, ffreq, rq);
	// original used this filter:
	// src = MoogLadder.ar(src, ffreq, res);


	Out.ar(out,
		src * amp !2;
	)
}).add;
);
// set up the sound
g = NPVoicer(Ndef(\piano)); // make an NPVoicer with an Ndef in it
g.play;                     // play it
NdefMixer(s);               // sound control
g.prime(\a);            // prepare it with the synthdef a
)

// test NPVoicer
g.put(55, [\midiNote, 55]);
g.put(64, [\midiNote, 64]);
g.release(55);
g.release(64);


(
// keys do noteOn
m.elementAt(\key, \on).action_{|el|
	"on: %\n".postf(el.index);
	g.put(el.index, [\midiNote, el.index, \amp, el.value.squared]);
};

// and noteOff
m.elementAt(\key, \off).action_{|el|
	"off: %\n".postf(el.index);
	g.release(el.index)
};

m.elementAt(\bend).action_{|el|
	Ndef(\piano).set(\bendFac, el.value)
};
// first knob changes resonance
m.elementAt(\kn, \turn, 0).action_{|el|
	Ndef(\piano).set(\res, el.value.linlin(0, 1, 0, 1).postln)
};

m.elementAt(\kn, 1).action_{|el|
	Ndef(\piano).set(\ffac, el.value.linexp(0, 1, 0.125, 8).postln)
};
)

// now hit one of its keys, or simulate:

m.elementAt(\key, \on, 64).valueAction_(0.25);
m.elementAt(\bend).valueAction_(0.75);
m.elementAt(\bend).valueAction_(0.5);

m.elementAt(\kn, \turn, 0).valueAction_(0.5);

m.elementAt(\kn, \turn, 1).valueAction_(0.7);
m.elementAt(\key, \off, 64).valueAction_(0);

m.elementAt(\key, \on, 67).valueAction_(0.25);
m.elementAt(\key, \off, 67).valueAction_(0.25);

s.queryAllNodes


Tdef(\noodle, {
	inf.do {
		var dt = 0.25;
		var note = [0, 2, 5, 10].choose + 60;
		var elemOn = m.elementAt(\key, \on, note);
		var elemOff = m.elementAt(\key, \off, note);
		elemOn.valueAction_(0.5).postln;
		defer ({ elemOn.valueAction_(0) }, dt);
		dt.wait;
	};
}).play;

