m = MKtl(\gp, 'hid_0_run_n_drive');


m.trace(true)
m.trace(false)

s.boot;


(
Ndef(\fSine).addSpec(\freq, [200, 800, \exp]);
Ndef(\fSine).addSpec(\amp, [0, 1]);
Ndef(\fSine).addSpec(\modAmp, [0, 1]);
Ndef(\fSine).addSpec(\modIndex, [1, 10, \lin, 1]);
Ndef(\fSine).addSpec(\spread, [0, 0.7]);
Ndef(\fSine).addSpec(\lag, [0.1, 10, \exp]);
Ndef(\fSine, {
	var lag = \lag.kr(1);
	var freq = \freq.kr(0, lag);
	var modFreq = freq * \modIndex.kr(0, lag);
	var modAmp = \modAmp.kr(0, lag);
	var src;

	freq = freq + [0, \spread.kr(0)];

	src = SinOsc.ar(
		freq +
		(SinOsc.ar(modFreq, mul: modAmp) * 1000)

	) * \amp.kr(0, lag);


	MyRotate2.ar(src, SinOsc.ar(0.0124));

}).play;

Ndef(\fSine2).addSpec(\freq, [200, 800, \exp]);
Ndef(\fSine2).addSpec(\amp, [0, 1]);
Ndef(\fSine2).addSpec(\modAmp, [0, 1]);
Ndef(\fSine2).addSpec(\modIndex, [1, 10, \lin, 1]);
Ndef(\fSine2).addSpec(\spread, [0, 0.7]);
Ndef(\fSine2).addSpec(\lag, [0.1, 10, \exp]);
Ndef(\fSine2, {
	var lag = \lag.kr(1);
	var freq = \freq.kr(0, lag);
	var modFreq = freq * \modIndex.kr(0, lag);
	var modAmp = \modAmp.kr(0, lag);
	var src;

	freq = freq + [0, \spread.kr(0)];

	src = SinOsc.ar(
		freq +
		(SinOsc.ar(modFreq, mul: modAmp) * 1000)

	) * \amp.kr(0, lag);


	MyRotate2.ar(src, SinOsc.ar(0.0124));

}).play;
)
NdefMixer(s)
s.latency = nil;

q = ();

q.activated = [m.elementAt(\bt, 1), m.elementAt(\bt, 2)]; // activate sound

q.sounds = [Ndef(\fSine), Ndef(\fSine2)];



(
m.elementAt(\throt, \l).action_{|el|

	[q.sounds, q.activated.collect(_.value)].flop.do{|a|
		(a[1] > 0).if{
			a[0].setUni(\amp, el.value)
		}
	};

};
m.elementAt(\joy, \l, \y).action_{|el|
	[q.sounds, q.activated.collect(_.value)].flop.do{|a|
		(a[1] > 0).if{
			a[0].setUni(\freq, el.value.linlin(0, 1, 1, 0))
		}
	};
};
m.elementAt(\joy, \l, \x).action_{|el|
	[q.sounds, q.activated.collect(_.value)].flop.do{|a|
		(a[1] > 0).if{
			a[0].setUni(\modIndex, el.value)
		}
	};
};
m.elementAt(\throt, \r).action_{|el|
	[q.sounds, q.activated.collect(_.value)].flop.do{|a|
		(a[1] > 0).if{
			a[0].setUni(\modAmp, el.value)
		}
	};
};
m.elementAt(\joy, \r, \x).action_{|el|
	[q.sounds, q.activated.collect(_.value)].flop.do{|a|
		(a[1] > 0).if{
			a[0].setUni(\spread, el.value)
		}
	};
};
)