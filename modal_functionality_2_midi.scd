// to create a modal control, we will use MFunc from the adclib.

// our simple use case:
// we have two sliders that we use for continuous control of different synths.
// the upper buttons of the icontrols select which synths the controls go to.
// two lower buttons start and stop the synths


// prepare the sound sources:
s.boot;

(
Ndef( \sound1, { var freq = \freq.kr(200) * LFNoise0.kr(ExpRand(3, 8), 0.02, 1);
	var snd = RLPF.ar(Pulse.ar(freq, 0.2), \rfreq.kr(2500), 0.3);
	var env = EnvGen.kr(Env.adsr, \gate.kr(1), doneAction: 2);
	snd * env;
});
	// which param should slider set?
Ndef( \sound1 ).addHalo(\sl1Param, \freq);
Ndef( \sound1 ).addHalo(\sl2Param, \rfreq);
	// range of that param
Ndef( \sound1 ).addSpec(\freq, [60, 600, \exp]);
Ndef( \sound1 ).addSpec(\rfreq, [1500, 6000, \exp]);

Ndef( \sound2, {
	var dens = \dens.kr(30);
	var snd = Ringz.ar(Dust2.ar(dens, 0.8), [ \freq1.kr(400), \freq2.kr(500)], 0.03).sum;
	var env = EnvGen.kr(Env.adsr, \gate.kr(1), doneAction: 2);
	snd * env;
});
Ndef( \sound2 ).addHalo(\sl1Param, \dens);
Ndef( \sound2 ).addHalo(\sl2Param, \freq1);
Ndef( \sound2 ).addSpec(\dens, [3, 3000, \exp]);
Ndef( \sound2 ).addSpec(\freq1, [300, 2500, \exp]);
Ndef( \sound2 ).addSpec(\freq2, [1500, 3500, \exp]);
);

// the MKtl:
k = MKtl( 'cncn2000' );

// setting the continuous controls:
(
k.elementAt( \sl, 0 ).action = MFunc.new;
k.elementAt( \sl, 0 ).action.add( \debug, { |mktel| "sl0 ".post; mktel.value.postln; } );
k.elementAt( \sl, 0 ).action.add( \sl1Sound1, { |mktel|
	var specName = Ndef( \sound1 ).getHalo(\sl1Param);
	var spec = Ndef( \sound1 ).getSpec( specName );
	Ndef( \sound1 ).set( specName, spec.map( mktel.value ) )
});
k.elementAt( \sl, 0 ).action.add( \sl1Sound2, { |mktel|
	var specName = Ndef( \sound2 ).getHalo(\sl1Param);
	var spec = Ndef( \sound2 ).getSpec( specName );
	Ndef( \sound2 ).set( specName, spec.map( mktel.value ) )
});
);

(
k.elementAt( \sl, 1 ).action = MFunc.new;
k.elementAt( \sl, 1 ).action.add( \debug, { |mktel| "sl1 ".post; mktel.value.postln; } );
k.elementAt( \sl, 1 ).action.add( \sl2Sound1, { |mktel|
	var specName = Ndef( \sound1 ).getHalo(\sl2Param);
	var spec = Ndef( \sound1 ).getSpec( specName );
	Ndef( \sound1 ).set( specName, spec.map( mktel.value ) )
});
k.elementAt( \sl, 1 ).action.add( \sl2Sound2, { |mktel|
	var specName = Ndef( \sound2 ).getHalo(\sl2Param);
	var spec = Ndef( \sound2 ).getSpec( specName );
	Ndef( \sound2 ).set( specName, spec.map( mktel.value ) )
});

);

// starting and stopping the ndefs:
(
k.elementAt( \but, 1, 0 ).action = MFunc.new;
k.elementAt( \but, 1, 0 ).action.add( \debug, { |mktel| "b1,0 ".post; mktel.value.postln; } );
k.elementAt( \but, 1, 0 ).action.add( \togglePlay, { |mktel|
	if ( mktel.value == 1 ){ // only when pressed
		if ( Ndef( \sound1 ).monitor.isPlaying ){
			Ndef( \sound1 ).stop;
			// disable controls
			k.elementAt( \sl, 0 ).action.disable( \sl1Sound1 );
			k.elementAt( \sl, 1 ).action.disable( \sl2Sound1 );
		}{ Ndef( \sound1 ).play }
	};
} );

k.elementAt( \but, 1, 1 ).action = MFunc.new;
k.elementAt( \but, 1, 1 ).action.add( \debug, { |mktel| "b1,1 ".post; mktel.value.postln; } );
k.elementAt( \but, 1, 1 ).action.add( \togglePlay, { |mktel|
	if ( mktel.value == 1 ){ // only when pressed
		if ( Ndef( \sound2 ).monitor.isPlaying ){
			Ndef( \sound2 ).stop;
			// disable controls
			k.elementAt( \sl, 0 ).action.disable( \sl1Sound2 );
			k.elementAt( \sl, 1 ).action.disable( \sl2Sound2 );
		}{ Ndef( \sound2 ).play }
	};
} );
);

// just enable controls when button pressed:
(
k.elementAt( \but, 0, 0 ).action = MFunc.new;
k.elementAt( \but, 0, 0 ).action.add( \debug, { |mktel| "b0,0 ".post; mktel.value.postln; } );
k.elementAt( \but, 0, 0 ).action.add( \togglePlay, { |mktel|
	if ( Ndef( \sound1 ).monitor.isPlaying ){
		if ( mktel.value == 1 ){ // only when pressed
			k.elementAt( \sl, 0 ).action.enable( \sl1Sound1 );
			k.elementAt( \sl, 1 ).action.enable( \sl2Sound1 );
		}{
			// disable controls
			k.elementAt( \sl, 0 ).action.disable( \sl1Sound1 );
			k.elementAt( \sl, 1 ).action.disable( \sl2Sound1 );
		};
	};
} );
);

(
k.elementAt( \but, 0, 1 ).action = MFunc.new;
k.elementAt( \but, 0, 1 ).action.add( \debug, { |mktel| "b0, 1 ".post; mktel.value.postln; } );
k.elementAt( \but, 0, 1 ).action.add( \togglePlay, { |mktel|
	if ( Ndef( \sound2 ).monitor.isPlaying ){
		if ( mktel.value == 1 ){ // only when pressed
			k.elementAt( \sl, 0 ).action.enable( \sl1Sound2 );
			k.elementAt( \sl, 1 ).action.enable( \sl2Sound2 );
		}{
			// disable controls
			k.elementAt( \sl, 0 ).action.disable( \sl1Sound2 );
			k.elementAt( \sl, 1 ).action.disable( \sl2Sound2 );
		};
	};
} );
);

(
// after testing, disable the debug action:
k.elementAt( \but, 0, 0 ).action.disable( \debug );
k.elementAt( \but, 1, 0 ).action.disable( \debug );
k.elementAt( \but, 0, 1 ).action.disable( \debug );
k.elementAt( \but, 1, 1 ).action.disable( \debug );
k.elementAt( \sl, 0 ).action.disable( \debug );
k.elementAt( \sl, 1 ).action.disable( \debug );
);

//toggle slider functionatlity
(
k.elementAt( \but, 1, 0 ).action = MFunc.new;
k.elementAt( \but, 1, 0 ).action.add( \debug, { |mktel| "b1,0 ".post;
mktel.value.postln; } );
k.elementAt( \but, 1, 0 ).action.add( \togglePlay, { |mktel|
	if ( mktel.value == 1 ){
		Ndef( \sound1 ).play
	}{
		Ndef( \sound1 ).stop;
	}
} );

k.elementAt( \but, 1, 1 ).action = MFunc.new;
k.elementAt( \but, 1, 1 ).action.add( \debug, { |mktel| "b1,1 ".post;
mktel.value.postln; } );
k.elementAt( \but, 1, 1 ).action.add( \togglePlay, { |mktel|
	if ( mktel.value == 1 ){
		Ndef( \sound2 ).play
	}{
		Ndef( \sound2 ).stop;
	}
} );

k.elementAt( \but, 1, 2 ).action = MFunc.new;
k.elementAt( \but, 1, 2 ).action.add( \debug, { |mktel| "b1,2 ".post;
mktel.value.postln; } );
k.elementAt( \but, 1, 2 ).action.add( \toggleSliders, { |mktel|
	if ( mktel.value == 1 ){
		k.elementAt( \sl, 0 ).action.enable( \sl1Sound1 );
		k.elementAt( \sl, 1 ).action.enable( \sl2Sound1 );
		k.elementAt( \sl, 0 ).action.disable( \sl1Sound2 );
		k.elementAt( \sl, 1 ).action.disable( \sl2Sound2 );
	}{
		k.elementAt( \sl, 0 ).action.disable( \sl1Sound1 );
		k.elementAt( \sl, 1 ).action.disable( \sl2Sound1 );
		k.elementAt( \sl, 0 ).action.enable( \sl1Sound2 );
		k.elementAt( \sl, 1 ).action.enable( \sl2Sound2 );
	};
} );

k.elementAt( \sl, 0 ).action.enable( \sl1Sound1 );
k.elementAt( \sl, 1 ).action.enable( \sl2Sound1 );
k.elementAt( \sl, 0 ).action.disable( \sl1Sound2 );
k.elementAt( \sl, 1 ).action.disable( \sl2Sound2 );

);




// feel free to extend with more controls!