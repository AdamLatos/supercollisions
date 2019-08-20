
(
SynthDef(\named, {
	arg out=0, amp=0.2, freq=440, atk=0.1, rel=0.5, pan=0;
	var sig, env;

	env = Env.perc(atk, rel).ar(2);
    sig = SinOsc.ar(freq);

	sig = sig * env * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

Pbind(
	\instrument, \named,
	\dur, Pseq([0.5, 1],inf),
	\amp, 0.2,
).play;

)
