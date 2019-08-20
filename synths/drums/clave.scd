FreqScope.new(800, 600, 0, server: s);

(
SynthDef(\clave, {
	arg out=0, amp=0.2, freq=587, rel=0.1, pan=0, tone=0;
	var sig, env;

	env = Env([1,0],[rel]).ar(2);
	sig = LFTri.ar(freq);
	sig = BPF.ar(sig,freq);

	sig = sig * env * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

Pbind(
	\instrument, \clave,
	\dur, Pseq([0.4],inf),
	\amp, 0.2,
	\tone, Pseq([0,0.2,0.4,0.6,0.8,1], inf),
).play;

)
