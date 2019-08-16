
(
SynthDef(\snare1,
	{
		arg out=0, amp=1, pan=0, freq=140, res=1, rattle=0.2,
		lpf=10000, body=0, tension=1,
		att=0.001, rel=0.2;
		var sig=DC.ar;


		sig = sig + RHPF.ar(
			WhiteNoise.ar,freq+(rattle*SinOsc.kr(30,0,freq)),res);
		sig = sig * Env([0,1,0,0.8,0,0.9,0,0.7,0],
			[0.001,0.002,0.003,0.004,0.005,0.006,0.007,rel/2],
			[0,0,0,0,0,0,0,-3]).kr;
		sig = sig + (Env.perc(att,rel,1,0).kr * BPF.ar(
			WhiteNoise.ar,freq+(rattle*SinOsc.kr(30,0,freq)),res));
		sig = sig + (Env.perc(att,rel/1.5).kr*(rattle/10 * Formant.ar(20,1000,200)));
		sig = sig + (body * SinOsc.ar(Env([freq*tension,freq,freq],[0.005*tension,0.1],[0,0]).kr));
		sig = LPF.ar(sig,lpf);

		sig = sig * Env.perc(att,rel).kr(2);

		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
}).add;
)

Synth(\snare1)

(
Pbind(
	\instrument, \snare2,
	\dur, Pn(4/5),
	\freq, Pseq([160
	],inf),
	\amp, 0.5,
	\lpf, 7000,
	\att, 0.005,
	\rel, Pseq([0.2,0.2,0.2,0.4,0.2,0.15,0.2,0.3],inf),
	\rattle, 0.5,
	\tension, 5,
	\body, 0.3,
).play(quant:1);
)

(
Pbind(
	\instrument, \snare2,
	\dur, Pn(Pn(1/16,8)++Pn(1/8,1)++Pn(1/12,3)++Pn(1/16,2)),
	\freq, 200,
	\res, Pwhite(0.4,1),
	\amp, Pn(Pn(0.5,1)++Pexprand(0.1,0.2,8)++Pn(0.5,1)++Pn(0.1,4)),
	\lpf, Pn(Pseries(20000,(-2000),8)++Pn(\,1)++Pseries(2000,(-300),6)
		++Pseries(2000,300,6)++Pseries(10000,(-100),8)),
	\rattle, Pwhite(0,1),
	\body, 0.1,
).play(quant:1);
)

8+2+4