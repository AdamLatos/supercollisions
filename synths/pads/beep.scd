(
SynthDef.new(\beep, {
	arg freq=800, pan=0, amp=0.2, out=0, att=0.01, rel=0.03,
	detune=1.0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[att,rel,0.05]), doneAction: 2);
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;

Pdef(\beepleft,
	Pbind(
		\instrument, \beep,
		\amp, Pn(Pseries(0.01,0.005,8)++Pseries(0.05,-0.006,8)),
		\dur, Pn(Pn(0.1,15)++Pn(0.1+Prand([0.4,1.8]),1)),
		\freq, 800,
		\pan, Pn(Pseries(-0.8,0.1,16)),
));


Pdef(\beepright,
	Pbind(
		\instrument, \beep,
		\amp, Pn(Pseries(0.01,0.005,8)++Pseries(0.05,-0.006,8)),
		\dur, Pn(Pn(0.1,15)++Pn(0.1+Prand([0.7,1.4]),1)),
		\freq, 840,
		\pan, Pn(Pseries(0.8,-0.1,16)),
));

Pdef(\beepcent,
	Pbind(
		\instrument, \beep,
		\amp, Pn(Pseries(0.01,0.005,8)++Pseries(0.05,-0.006,8)),
		\dur, Pn(Pn(0.1,15)++Pn(0.1+2.0,1))*2,
		\freq, 720,
		\att, 0.05,
		\rel, 0.05,
		\pan, Pxrand([1,-1],inf) * Pn(Pseries(0.8,-0.1,8)),
));
)

Pdef(\beepleft).play(quant:0.4);
Pdef(\beepright).play(quant:0.75);
Pdef(\beepcent).play(quant:0.15);

Pdef(\beepleft).stop;
Pdef(\beepright).stop;
Pdef(\beepcent).stop;