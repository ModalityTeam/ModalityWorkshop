/////////////////
// access a keyboard and play a basic multitimbral sound
// uses NPVoicer from the JITLibExtensions quark

"JITLibExtensions".include

// boot server
s.boot;
s.latency = nil; // make sure there is no artificial latency

m = MKtl('pmdd10');


(
(
SynthDef(\a, {|out = 0, midiNote = 50, bendFac = 0.5, res = 0, ffac = 1, gate = 1|
	var freq = (midiNote + (12 * bendFac)).midicps;
	var src = Saw.ar(freq) *
		EnvGen.kr(Env.adsr(0.1, releaseTime: 0.1), gate, doneAction: 2);

	var ffreq = freq * ffac;

	src = MoogLadder.ar(src, ffreq, res);

	Out.ar(out,
		src!2;
	)
}).add;
);
// set up the sound
g = NPVoicer(Ndef(\piano)); // make an NPVoicer with an Ndef in it
g.play;                     // play it
NdefMixer(s);               // sound control
g.prime(\a);            // prepare it with the default synthdef
)


(
m.elementAt(\key, \on).action_{|el|
	"on: %\n".postf(el.index);
	g.put(el.index, [\midiNote, el.index]);
};

m.elementAt(\key, \off).action_{|el|
	"off: %\n".postf(el.index);
	g.release(el.index)
};

m.elementAt(\bend).action_{|el|
	Ndef(\piano).set(\bendFac, el.value)
};

m.elementAt(\kn, 0).action_{|el|
	Ndef(\piano).set(\res, el.value.linlin(0, 1, 0, 1).postln)
};

m.elementAt(\kn, 1).action_{|el|
	Ndef(\piano).set(\ffac, el.value.linexp(0, 1, 0.125, 8).postln)
};

)