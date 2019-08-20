FreqScope.new(800, 600, 0, server: s);

(
SynthDef(\clave, {
	arg out=0, amp=0.2, freq=587, rel=0.02, pan=0, tone=0;
	var sig, env;

	env = Env([1,0],[rel]).ar(2);
	sig = LFTri.ar(freq,0,0.3) + Impulse.ar(1,0,0.8);
	sig = BPF.ar(sig,freq/2);

	sig = sig * env * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

Pbind(
	\instrument, \clave,
	\dur, Pseq([0.4],inf),
	\amp, 1,
	\freq, 2500,
).play;

)
