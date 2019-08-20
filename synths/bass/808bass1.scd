
(
SynthDef(\bass808, {
	arg out=0, gate=1, amp=1, freq=80, atk=0.01, dec=0.2, sus=0.8, rel=0.3, detune=0.01, pan=0;
	var sig, fq, width=0.5;

	fq = Line.ar(freq*4, freq, 0.04);
	sig = SinOscFB.ar([fq, fq*(1+detune)],LFNoise1.kr(freq/2).range(0.3,0.5),0.5);
	sig = sig + Pulse.ar([fq*(1+detune), fq], SinOsc.kr(freq/4,0,0.4,0.5), LFNoise1.kr(7).range(0,0.05));
	sig = sig + Saw.ar([2*freq*(1+detune), 2*freq], LFNoise1.kr(10).range(0,0.05));

	sig = sig * EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate, doneAction: Done.freeSelf);
	sig = RLPF.ar(sig,freq*6,0.9);

	Out.ar(out, sig);
}).add;

Pbind(
	\instrument, \bass808,
	\amp, 0.1,
	\dur, Pseq([0.5, 0.8, 0.2, 0.5],inf),
	\midinote, Pseq([32, 32, 44, 32, 32, 39, 32, 32],inf),
).play(quant:0.8);

)

{ Pan2.ar(SinOsc.ar(440), 0) }.play


{ var freq = 1000; [LFNoise1.ar(freq), Impulse.ar(freq)] }.plot