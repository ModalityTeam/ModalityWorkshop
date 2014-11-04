// to create a modal control, we will use MFunc from the adclib.

// our simple use case:
// we have two gamepad joystick axes that we use for continuous control of different synths.
// the buttons on the shoulders of the gamepad select which synths the controls go to.
// two other buttons start and stop the synths


// prepare the sound sources:
s.boot;

(
Ndef( \sound1, { var freq = \freq.kr(200) * LFNoise0.kr(ExpRand(3, 8), 0.02, 1);
	var snd = RLPF.ar(Pulse.ar(freq, 0.2), \rfreq.kr(2500), 0.3);
	var env = EnvGen.kr(Env.adsr, \gate.kr(1), doneAction: 2);
	snd * env;
});
	// which param should slider set?
Ndef( \sound1 ).addHalo(\xParam, \freq);
Ndef( \sound1 ).addHalo(\yParam, \rfreq);
	// range of that param
Ndef( \sound1 ).addSpec(\freq, [60, 600, \exp]);
Ndef( \sound1 ).addSpec(\rfreq, [1500, 6000, \exp]);

Ndef( \sound2, {
	var dens = \dens.kr(30);
	var snd = Ringz.ar(Dust2.ar(dens, 0.8), [ \freq1.kr(400), \freq2.kr(500)], 0.03).sum;
	var env = EnvGen.kr(Env.adsr, \gate.kr(1), doneAction: 2);
	snd * env;
});
Ndef( \sound2 ).addHalo(\xParam, \dens);
Ndef( \sound2 ).addHalo(\yParam, \freq1);
Ndef( \sound2 ).addHalo(\xParam1, \freq2);
Ndef( \sound2 ).addSpec(\dens, [3, 3000, \exp]);
Ndef( \sound2 ).addSpec(\freq1, [300, 2500, \exp]);
Ndef( \sound2 ).addSpec(\freq2, [1500, 3500, \exp]);
);

// the MKtl:
k = MKtl( 'rnnd0' );

// setting the continuous controls:
(
k.elementAt( \joy, \l, \x ).action = MFunc.new;
k.elementAt( \joy, \l, \x ).action.add( \debug, { |mktel| "joy,x,l, ".post; mktel.value.postln; } );
k.elementAt( \joy, \l, \x ).action.add( \xSound1, { |mktel|
	var ctlName = Ndef( \sound1 ).getHalo(\xParam);
	Ndef( \sound1 ).setUni( ctlName, mktel.value );
});
k.elementAt( \joy, \l, \x ).action.add( \xSound2, { |mktel|
	var ctlName = Ndef( \sound2 ).getHalo(\xParam);
	Ndef( \sound2 ).setUni( ctlName, mktel.value );
});
);

(
k.elementAt( \joy, \l, \y ).action = MFunc.new;
k.elementAt( \joy, \l, \y ).action.add( \debug, { |mktel| "joy,y,l, ".post; mktel.value.postln; } );
k.elementAt( \joy, \l, \y ).action.add( \ySound1, { |mktel|
	var ctlName = Ndef( \sound1 ).getHalo(\yParam);
	Ndef( \sound1 ).setUni( ctlName, mktel.value );
});
k.elementAt( \joy, \l, \y ).action.add( \ySound2, { |mktel|
	var ctlName = Ndef( \sound2 ).getHalo(\yParam);
	Ndef( \sound2 ).setUni( ctlName, mktel.value );
});

);

// starting and stopping the ndefs:
(
k.elementAt( \bt, 7 ).action = MFunc.new;
k.elementAt( \bt, 7 ).action.add( \debug, { |mktel| "b7 ".post; mktel.value.postln; } );
k.elementAt( \bt, 7 ).action.add( \togglePlay, { |mktel|
	if ( mktel.value == 1 ){ // only when pressed
		if ( Ndef( \sound1 ).monitor.isPlaying ){
			Ndef( \sound1 ).stop;
			// disable controls
			k.elementAt( \joy, \l, \x ).action.disable( \xSound1 );
			k.elementAt( \joy, \l, \y ).action.disable( \ySound1 );
		}{ Ndef( \sound1 ).play }
	};
} );

k.elementAt( \bt, 8 ).action = MFunc.new;
k.elementAt( \bt, 8 ).action.add( \debug, { |mktel| "b8 ".post; mktel.value.postln; } );
k.elementAt( \bt, 8 ).action.add( \togglePlay, { |mktel|
	if ( mktel.value == 1 ){ // only when pressed
		if ( Ndef( \sound2 ).monitor.isPlaying ){
			Ndef( \sound2 ).stop;
			// disable controls
			k.elementAt( \joy, \l, \x ).action.disable( \xSound2 );
			k.elementAt( \joy, \l, \y ).action.disable( \ySound2 );
		}{ Ndef( \sound2 ).play }
	};
} );
);

// just enable controls when button pressed:
(
k.elementAt( \bt, 5 ).action = MFunc.new;
k.elementAt( \bt, 5 ).action.add( \debug, { |mktel| "b5 ".post; mktel.value.postln; } );
k.elementAt( \bt, 5 ).action.add( \togglePlay, { |mktel|
	if ( Ndef( \sound1 ).monitor.isPlaying ){
		if ( mktel.value == 1 ){ // only when pressed
			k.elementAt( \joy, \l, \x ).action.enable( \xSound1 );
			k.elementAt( \joy, \l, \y ).action.enable( \ySound1 );
		}{
			// disable controls
			k.elementAt( \joy, \l, \x ).action.disable( \xSound1 );
			k.elementAt( \joy, \l, \y ).action.disable( \ySound1 );
		};
	};
} );
);

(
k.elementAt( \bt, 6 ).action = MFunc.new;
k.elementAt( \bt, 6 ).action.add( \debug, { |mktel| "b6 ".post; mktel.value.postln; } );
k.elementAt( \bt, 6 ).action.add( \togglePlay, { |mktel|
	if ( Ndef( \sound2 ).monitor.isPlaying ){
		if ( mktel.value == 1 ){ // only when pressed
			k.elementAt( \joy, \l, \x ).action.enable( \xSound2 );
			k.elementAt( \joy, \l, \y ).action.enable( \ySound2 );
		}{
			// disable controls
			k.elementAt( \joy, \l, \x ).action.disable( \xSound2 );
			k.elementAt( \joy, \l, \y ).action.disable( \ySound2 );
		};
	};
} );
);

(
// after testing, disable the debug action:
k.elementAt( \bt, 5 ).action.disable( \debug );
k.elementAt( \bt, 6 ).action.disable( \debug );
k.elementAt( \bt, 7 ).action.disable( \debug );
k.elementAt( \bt, 8 ).action.disable( \debug );
k.elementAt( \joy, \l, \x ).action.disable( \debug );
k.elementAt( \joy, \l, \y ).action.disable( \debug );
);

//toggle slider functionatlity
(
k.elementAt( \bt, 7 ).action = MFunc.new;
k.elementAt( \bt, 7 ).action.add( \debug, { |mktel| "b1,0 ".post;
mktel.value.postln; } );
k.elementAt( \bt, 7 ).action.add( \togglePlay, { |mktel|
	if ( mktel.value == 1 ){
		Ndef( \sound1 ).play
	}{
		Ndef( \sound1 ).stop;
	}
} );

k.elementAt( \bt, 8 ).action = MFunc.new;
k.elementAt( \bt, 8 ).action.add( \debug, { |mktel| "b1,1 ".post;
mktel.value.postln; } );
k.elementAt( \bt, 8 ).action.add( \togglePlay, { |mktel|
	if ( mktel.value == 1 ){
		Ndef( \sound2 ).play
	}{
		Ndef( \sound2 ).stop;
	}
} );

k.elementAt( \bt, 9 ).action = MFunc.new;
k.elementAt( \bt, 9 ).action.add( \debug, { |mktel| "b1,2 ".post;
mktel.value.postln; } );
k.elementAt( \bt, 9 ).action.add( \toggleSliders, { |mktel|
	if ( mktel.value == 1 ){
		k.elementAt( \joy, \l, \x ).action.enable( \xSound1 );
		k.elementAt( \joy, \l, \y ).action.enable( \ySound1 );
		k.elementAt( \joy, \l, \x ).action.disable( \xSound2 );
		k.elementAt( \joy, \l, \y ).action.disable( \ySound2 );
	}{
		k.elementAt( \joy, \l, \x ).action.disable( \xSound1 );
		k.elementAt( \joy, \l, \y ).action.disable( \ySound1 );
		k.elementAt( \joy, \l, \x ).action.enable( \xSound2 );
		k.elementAt( \joy, \l, \y ).action.enable( \ySound2 );
	};
} );

k.elementAt( \joy, \l, \x ).action.enable( \xSound1 );
k.elementAt( \joy, \l, \y ).action.enable( \ySound1 );
k.elementAt( \joy, \l, \x ).action.disable( \xSound2 );
k.elementAt( \joy, \l, \y ).action.disable( \ySound2 );

);



// feel free to extend with more controls!