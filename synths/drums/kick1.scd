
s.boot;
s.meter;
s.plotTree;


(
SynthDef(\kick1,
	{
		arg out=0, amp=0.5, freq=60, atk=0.004, rel=0.8, c1=2, c2=(-1), pan=0,
		distort=0.2, mult=3, hit=0.5, mix=0;
		var sig, env, sweep1, sweep2, hitsaw;

		sweep1 = Line.kr(freq*mult, freq, sweepspd);
		sweep2 = Env([freq*10,freq,freq/4],[0.01,0.2],[1,-1]).ar;
		env = Env([0,1,0], [atk,rel], [c1,c2]).kr(2);

		sig = SinOsc.ar(sweep1, pi/2) * (1-mix);
		sig = sig + (mix * SinOsc.ar(sweep2, pi/2)); //+ Blip.ar(freq/2,3);

		sig = (sig * (1-distort)) + (sig.distort * distort);
		hitsaw = hit * (Saw.ar * Env.perc(0.0001,rel/3).ar);
		sig = sig + hit;

		sig = sig * env * amp * (1-mult/10);
		sig = Pan2.ar(sig, pan);
		Out.ar(out, sig);
}).add;
)

(
Pbind(
	\instrument, \kick1,
	\dur, Pseq([0.4,Pseq([0.2, 0.2]),Pseq([0.8/3,0.8/3,0.8/3])],inf),
	\distort, Pseq([0,0.25,0.5,0.75,1],inf),
	\freq, Pseq([50,60,70], inf),
	\amp, Pxrand([1,1,1,1,1,1,\],inf).trace,
	\c1, 2,
	\c2, -8,
	\mult, Prand([3,2],inf),
	\atk, 0.004,
	\mix, Pseq([0,0.2,0.4,0.6],inf),
).play(quant: 0.8);
)

(
Pbind(
	\instrument, \kick1,
	\dur, 1/10 + Pseq([-0.01, 0.01, -0.01, 0.01],inf),
	\freq, 60,
	\amp, Pseq([0.8,0.5,0.2,0.1],inf),
	\rel, Pseq([0.1,0.5,0.2,0.1],inf),
	\mix, 0.2,
	\hit, 0,
	\mult, Pseq([1,2,4,1,2,3,1],inf)
).play(quant: 0.8);
//s.record(duration:10);
)