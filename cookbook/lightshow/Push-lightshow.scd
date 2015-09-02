(
m = MKtl(\push, "ableton*");
m.listenTo(1).sendTo(1); // use User port

q = ();
q.dt = 0.055003051944088;
m.elementAt(\ribbon).action = {|el|
	q.dt = el.value.linexp(0, 1, 0.005, 0.1);
};

q.taskPlaying = true;
Tdef(\player).quant = 0;
m.elementAt(\play).action = {|el|
	(el.value > 0).if{
		q.taskPlaying = q.taskPlaying.not;
		el.value = q.taskPlaying.asInteger;
		q.taskPlaying.if({
			Tdef(\player).resume;
		},{
			Tdef(\player).pause;
		})
	}

};

m.elementAt(\record).action = {|el|
	(el.value > 0).if{
		Tdef(\player).stop.play.pause;
		q.taskPlaying = false;
		m.elementAt(\play).deviceValue = 0;
		q.allElements.do(_.deviceValue_(0));
	}
};
m.elementAt(\record).deviceValue = 128;

q.allElements = 8.collect{|i|
	m.elementAt(\pad, \on, i)
}.flat;

Tdef(\player, {
	inf.do{|j|
		q.color = [\red, \amber, \yellow, \lime, \green, \spring, \turquoise, \cyan, \sky, \ocean, \blue, \orchid, \magenta, \pink, \brightOrange].choose;
		q.intensity = [\dim, \full][j%2];
		q.allElements.scramble.do{|el|
			el.deviceValue_(MPushHelper.padLightCode(intensity: q.intensity, color: q.color));
			q.dt.wait;
		}
	}
});
Tdef(\player).play.pause
)


