
(
SynthDef(\hihat1,
	{
		arg out=0, atk=0.01, rel=0.1, amp=0.5, pan=0, res=0.5, hpf=6000, lpf=8000;
		var sig, env;

		env = Env.perc(atk,rel).kr(2);
		sig = WhiteNoise.ar;
		sig = RHPF.ar(sig,hpf,res);
		sig = LPF.ar(sig,lpf);

		sig = sig * env * amp;
		sig = Pan2.ar(sig, pan);
		Out.ar(out, sig);
}).add;

Pdef(\hats,
	Pbind(
		\instrument, \hihat1,
		\amp, 0.5 * Pseq([0.5, Pn(0.2,9), 0.5, Pn(0.2,10)],inf),
		\dur, Pseq([
			Pseq([0.2,0.2,0.2,0.2,0.1,0.1,0.1,0.1,0.2,0.2],1),
			Pseq([0.2,0.2,0.2,0.2,0.05,0.05,0.05,0.05,0.2,0.2,0.2],1)],inf),
		\hpf, 6000,
		\lpf, 8000,
		\atk, Pn(Pseries(0.01,0.002,12)),
		\rel, Pwhite(0.05,0.15,inf),
		\res, 1,
));

Pdef(\halfhats,
	Pbind(
		\instrument, \hihat1,
		\amp, 0.5 * Pn(Pseq([0.5,0.4],8)++Pseq([0.3,0.2],8)) * 0.6,
		\dur, 0.1,
		\hpf, Pexprand(1000,20000),
		\lpf, Pexprand(2000,21000),
		\atk, Pn(Pn(0.001,16) ++ Pn(0.05,8) ++ Pn(0.01,8)),
		\rel, Pn(Pn(0.05,16) ++ Pn(0.2,8) ++ Pn(0.01,8)),
		\res, Pexprand(0.15,1),
));

Pdef(\weirdhats,
	Pbind(
		\instrument, \hihat1,
		\amp, Pseq([0.3,0.2],inf) * 0.6,
		\dur, 0.1,
		\hpf, Pexprand(1000,20000),
		\lpf, Pexprand(2000,21000),
		\atk, Pn(Pn(0.05,8) ++ Pn(0.01,8)),
		\rel, Pn(Pn(0.2,8) ++ Pn(0.01,8)),
		\res, Pexprand(0.15,1),
));
)

Pdef(\hats).play(quant:0.8);
Pdef(\halfhats).play(quant:0.8);
Pdef(\weirdhats).play(quant:0.8);

Pdef(\hats).stop;
Pdef(\halfhats).stop;
Pdef(\weirdhats).stop;