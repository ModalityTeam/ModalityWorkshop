/***
JITLib is a library within SuperCollider that allows creating proxies (placeholders) for sounds (Ndef), tasks and patterns/streams.
These proxies can be changed in many ways while playing,
and do most of the bookkeeping themselves; this allows
a fluid fluid style of experimenting with ideas.

"JITLib".openHelpFile
[Ndef, Tdef, Pdef].choose.openHelpFile;


The examples here show how to connect an MKtl directly
to a sound proxy, an Ndef, the typical questions that arise,
and how to switch the same interface between two proxies.

Next files will show how to connect to JITLib GUIs,
and why this can be useful with large multi-process setups.

***/

q = q ? ();

// first, make an Ndef with 9 params
(
Ndef(\test, { |freq=250, intv=19, timescale=1, curve=0, loopnode=0, formfact=2, widfact=0.5, spread=1, amp=0.1|
		var env = EnvGen.kr(
			Env(
				{ 1.0.rand2 }!11,
				{1.0.rand}!10 * timescale,
				curve,
				releaseNode: 9,
				loopNode: loopnode)
		);
		var pitch = (env * [1, 0.33, -1] * intv).midiratio * freq;
		Splay.ar(
			Formant.ar(pitch, pitch.scramble * formfact, pitch.scramble * widfact), spread) * amp;
});
	// add specs for all the parameter ranges - required!
	Spec.add(\intv, [0, 36, \lin]);
	Spec.add(\timescale, [0.001, 10, \exp]);
	Spec.add(\curve, [-10, 10]);
	Spec.add(\loopnode, [0, 7, \lin, 1]);
	Spec.add(\formfact, [0.1, 10, \exp]);
	Spec.add(\widfact, [0.1, 10, \exp]);
	Spec.add(\spread, \unipolar);
);

q.nk = MKtl(\nnkn20);

// map group of mktl elements to array of proxy params:
// uses direct set method,
// and global specs for proxy params.
q.mapElemGroupToProxyParams = { |q, group, proxy, keys|
	keys = keys ?? { proxy.controlKeys };
	group.do { |el, i|
		var parKey = keys[i];
		if (parKey.notNil) {
			el.action = {
				proxy.set(parKey,
					parKey.asSpec.map(el.value)
				)
			};
		}
	}
};

// use first 7 knobs for first seven params:
q.mapElemGroupToProxyParams(
	q.nk.at(\kn).keep(7),
	Ndef(\test)
);
	// use last knob for volume control:
q.nk.at(\kn).last.action = { |el|
	Ndef(\test).vol_(\amp.asSpec.map(el.value));
};

// add play and stop buttons
q.nk.at(\play).action = { |el| Ndef(\test).play; };
q.nk.at(\stop).action = { |el| Ndef(\test).stop; };

// ... and test that all these work as intended!



// VARIANT 1 - SOFT TAKEOVER - with softSet and softVol_:
// The direct set and vol_ methods above may cause a big jump
// of the param value or volume to where the fader happens to be;
// the softSet class and softVol method avoid this by only
// doing the setting when the value is close enough,
// or when the value is close to the last value of the
// control element.

	// use last knob for volume control:
q.nk.at(\kn).last.action = { |el|
	Ndef(\test).softVol_(\amp.asSpec.map(el.value));
};

q.mapElemGroupToProxyParams = { |q, group, proxy, keys|
	keys = keys ?? { proxy.controlKeys };
	group.do { |el, i|
		var parKey = keys[i];
		if (parKey.notNil) {
			el.action = {
				proxy.softSet(parKey,
					parKey.asSpec.map(el.value),
					within: 0.025,
					lastVal: el.prevValue
				)
			};
		}
	}
};

// and again, use first 7 knobs for first seven params,
// now with softSet:
q.mapElemGroupToProxyParams(
	q.nk.at(\kn).keep(7),
	Ndef(\test);
);

// ADD Modality / flexibility:
// make a single function that does all this in one step,
// so you can easily switch between proxies:

q.setNkProxy = { |q, proxy|
	if (proxy.notNil) {
		q.nkProxy = proxy;

		// use first 7 knobs for first seven params:
		q.mapElemGroupToProxyParams(
			q.nk.at(\kn).keep(7),
			q.nkProxy
		);
		// use last knob for volume control:
		q.nk.at(\kn).last.action = { |el|
			q.nkProxy.vol_(\amp.asSpec.map(el.value));
		};

		// add play and stop buttons
		q.nk.at(\play).action = { |el| q.nkProxy.play; };
		q.nk.at(\stop).action = { |el| q.nkProxy.stop; };
	};
};

q.setNkProxy(Ndef(\test)); // as before

// different proxy - does nothing
q.setNkProxy(Ndef(\test2));

// make the new proxy:
Spec.add(\slope, [0.1, 1, \exp]);
Spec.add(\formfreq, [50, 5000, \exp]);
Spec.add(\reso, [1, 10, \exp]);

Ndef(\test2, { |freq = 2000, slope = 0.8,
	formfreq = 5000, reso = 10, amp = 0.5|

	var freqscale = (slope ** (0..5));
	var snd = { LFDNoise0.ar(freq * freqscale).product } ! 2;
	RLPF.ar(snd, formfreq, 1/reso) * amp;
}).play;

// and set it again now - all controls should be connected.
q.setNkProxy(Ndef(\test2));

// back to first proxy:
q.setNkProxy(Ndef(\test));

// now assign rew and fwd buttons to choose
// between \test and \test2
q.nk.at(\rew).action = { |el| q.setNkProxy(Ndef(\test)); };
q.nk.at(\fwd).action = { |el| q.setNkProxy(Ndef(\test2)); };


n = NdefGui(Ndef(\test), 7);
g = NanoKtl.new;			// make a new NanoKtl
g.mapToNdefGui(n, 1);		// and map its scene 1 to the editor n

// shift by hand which params are mapped
g.paramShift(0);	// show which params are mapped
g.paramShift(1);	// shift by one; when hitting the end, jumps back.

// test using a second proxy, NanoKtl scene 2:
~test2 = ~test.source;
o = NodeProxyEditor(~test2);
g.mapToPxEdit(o, 2); // scene 2!