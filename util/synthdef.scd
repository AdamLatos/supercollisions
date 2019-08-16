
(
SynthDef(\named, {
	arg out, amp=1, freq=440, atk=0.1, dec=0.2, sus=1, rel=0.3, detune=0.01, width=0.5, gate=1, pan=0;
	var sig;

    sig = VarSaw.ar([freq, freq * detune], 0, width);

	sig = sig * EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate, amp, doneAction: Done.freeSelf);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

Pbind(
	\instrument, \named,
	\dur, Pseq([0.5, 1],inf),
	\degree, Pseq([1, 4, 5, 4],inf) + Prand([[0,3,5]],inf),
	\pan, Pseq([0.3, -0.3, -0.3, 0.3, 0.3, 0.3], inf),
).play;

)

{ Pan2.ar(SinOsc.ar(440), 0) }.play

