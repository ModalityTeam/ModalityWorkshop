// learn
// a synth process should be controlled:
//  1. start and stop
//  2. set frequency

s.boot;
s.latency = nil;

m = MKtl('nnkn20'); // the MKtl


q = (); // a place to put stuff

(
// freq action to assign


q[\setFreq] = {|el|
	[el, el.value].postln;
	q.mySynth.notNil.if{
		q.freq = el.value.linexp(0, 1, 200, 2000);
		q.mySynth.set(\freq, q.freq);
	};
};

// synth creation action to assign
q[\synthCtl] = {|el|
	[el, el.value].postln;
	(el.value > 0).if({
		q.mySynth = Synth(\default, [\freq, q.freq]);
	}, {
		q.mySynth.notNil.if{
			q.mySynth.release;
			q.mySynth = nil;
		};
	})
};

// group of elements from which the element is selected from
q.sliders = m.elementAt(\sl);
q.buttons = m.elementAt(\bt);

q.makeLearnAction = {|q, group, action, callback|

	var learnAction = {|el|
		el.addAction(action);
		"Added func to %\n".postf(el);
		callback.value(el);
		group.removeAction(learnAction);
		"learnAction removed from %.\n".postf(el);
	};

	group.addAction(learnAction);
};


q.makeLearnAction(q.sliders, q[ \setFreq], {|el| q. freqCtlElem = el});
q.makeLearnAction(q.buttons, q[\synthCtl], {|el| q.synthCtlElem = el});

q.freq = 100;
)


q. freqCtlElem.removeAction(q[ \setFreq]);
q.synthCtlElem.removeAction(q[\synthCtl]);

