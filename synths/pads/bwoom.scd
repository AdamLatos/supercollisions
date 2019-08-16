(
SynthDef.new(\bwoom, {
	arg freq=40, nharm=12, detune=0.2, pan=0, amp=1, out=0, cutoff=20000, gate=1, att=0.2, dec=0.1, rel=3, slideTime=0.1;
	var sig, env;
	freq = Lag.kr(freq, slideTime);
	env = EnvGen.kr(Env.adsr(att,dec,0.5,rel), gate, doneAction: 2);
	sig = Blip.ar(
		freq *
		LFNoise1.kr(0.2!16).bipolar(detune.neg,detune).midiratio,
			nharm
	);
	sig = sig * LFNoise1.kr(0.5).exprange(0.8,1);
	sig = LPF.ar(sig,cutoff.lag(0.5));
	sig = Splay.ar(sig);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;

Pdef(\progression1,
	PmonoArtic(
		\bwoom,
		\amp, 0.4,
		\freq, Pseq([100,60,40],inf),
		//\freq, Pn(Pseq([100,60,40,160,40],2) ++ Pseq([90,60,30,120,60],2)),
		\detune, 0.2,
		\nharm, Pseq([12,10,16,11,13],inf),
		\dur, Pseq([0.6,0.6,2.0],inf),
		//\dur, Pseq([0.6,0.6,0.6,0.05,1.35],inf),
		\legato, 1,
		//\legato, Pseq([1,1,1,1,0.2,1,0.2,1,0,0.2],inf),
		\slideTime, Pseq([0.2,0.2,0.2,0.2,0.2,0.2,0.5,0.2,0.2],inf),
));

Pdef(\progression2,
	PmonoArtic(
		\bwoom,
		\amp, 0.4,
		\freq, Pn(Pseq([100,60,40,160,40],2) ++ Pseq([90,60,30,120,60],2)),
		\detune, 0.2,
		\nharm, Pseq([12,10,16,11,13],inf),
		\dur, Pseq([0.6,0.6,0.6,0.05,1.35],inf),
		\legato, Pseq([1,1,1,1,0.2,1,0.2,1,0,0.2],inf),
		\slideTime, Pseq([0.2,0.2,0.2,0.2,0.2,0.2,0.5,0.2,0.2],inf),
));

Pdef(\boops,
	Pbind(
		\instrument, \bwoom,
		\amp, 0.1,
		\dur, 0.2,
		\freq, 200,
		\nharm, Pxrand([3,4,5,6,7],inf),
		\detune, Pseq([0.1,0.3,0.5],inf),
		\rel, 0.1,
));

Pdef(\bigbass1,
	Pbind(
		\instrument, \bwoom,
		\amp, 0.7,
		\dur, 3.2,
		\freq, Pseq([40,40,40,40],inf),
		\nharm, Pseries(40,-2,15) ++ Pn(10),
		\detune, 0.5,
		\rel, 3,
));

Pdef(\bigbass2,
	Pbind(
		\instrument, \bwoom,
		\amp, 0.7,
		\dur, 3.2,
		\freq, Pseq([40,40,30,30],inf),
		\nharm, 10,
		\detune, 0.3,
		\rel, 3,
));
)

Pdef(\progression1).play(quant:6.4);
Pdef(\progression2).play(quant:6.4);
Pdef(\boops).play(quant:3.2);
Pdef(\bigbass1).play(quant:6.4);
Pdef(\bigbass2).play(quant:6.4);

Pdef(\progression1).stop;
Pdef(\progression2).stop;
Pdef(\boops).stop;
Pdef(\bigbass1).stop;
Pdef(\bigbass2).stop;