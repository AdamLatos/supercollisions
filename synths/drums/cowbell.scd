FreqScope.new(800, 600, 0, server: s);

(
SynthDef(\cowbell, {
	arg out=0, amp=0.2, freq=587, atk=0.001, rel=0.3, pan=0, tone=0;
	var sig, env;

	env = Env([0,1,0.1,0],[atk, 0.12, rel]).ar(2);
	sig = LFTri.ar(587) + LFTri.ar(845) + Pulse.ar(845*1.44,0.5,0.2);
	sig = BPF.ar(sig,640+(tone*4000)) + BPF.ar(sig,2640);
	sig = sig + LFTri.ar(588) + sig + LFTri.ar(844);

	sig = sig * env * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

Pbind(
	\instrument, \cowbell,
	\dur, Pseq([1],inf),
	\amp, 0.2,
	\tone, Pseq([1,0.2,0.4,0.6,0.8,1], inf),
).play;

)
