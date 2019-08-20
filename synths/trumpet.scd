FreqScope.new(800, 600, 0, server: s);

(
SynthDef(\trumpet, {
	arg out=0, amp=0.2, freq=440, atk=0.03, sus=0.2, rel=0.3, pan=0, tone=0;
	var sig, env;

	env = Env([0,1,1,0],[atk,sus,rel]).ar(2);
	sig = Saw.ar([freq, freq*1.001]);
	sig = RLPF.ar(sig,freq*6);

	sig = sig * env * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

Pbind(
	\instrument, \trumpet,
	\amp, Pseq([0.2, Pseq([0.17, 0.14, 0.14],2),0.17],inf),
	\dur, Pseq([8,1/2,1/2,1/2,1/2,1/2,1/2,5],inf),
	\atk, Prand([[0.06,0.05,0.04,0.04]],inf),
	\sus, Pseq([2,0,0,0,0,0,0,1/2],inf) + [1/32,1/64,1/32,0],
	\rel, [0.12,0.1,0.08,0.07],
	\stretch, 0.4,
	\midinote, Pseq([[60],[60],[60],[60],[58],[58],[58],[56]],inf) + Pn(Pn([-12,0,3,7],4)++Pn([-12,0,4,7],4)),
).play;
)