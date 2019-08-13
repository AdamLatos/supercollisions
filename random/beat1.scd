(
s.quit;
s.options.memSize = 1024*100;  // e.g., could be different for you
s.boot;

TempoClock.default.tempo = 125/60;
)

(
SynthDef.new(\hihat,
{
	|out, amp = 1, pan = 0, gate = 1|
	var sig, env = Env.adsr(0.005, 0.02, 0, 0);

	sig = PinkNoise.ar(amp) * EnvGen.kr(env, gate, doneAction: Done.freeSelf);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

h = Prand([
	Pbind(
		\instrument, \hihat,
		\delta, Pseq([0.5, 0.25, 0.25, 0.5, 0.25, 0.5], 1),
		\amp, 0.32,
		\pan, Pseq([0.3, -0.3, -0.3, 0.3, 0.3, 0.3], 1)
	),
	Pbind(
		\instrument, \hihat,
		\delta, Pseq([0.5, 0.25, 0.25, 0.5, 0.25, 0.5], 1),
		\amp, 0.32,
		\pan, Pseq([0.1, -0.1, -0.1, 0.3, 0.1, -0.1], 1)
	),
	Pbind(
		\instrument, \hihat,
		\delta, Pseq([0.25, 0.25, 0.25, 0.25], 1),
		\amp, 0.32,
		\pan, 0
	),
		Pbind(
		\instrument, \hihat,
		\delta, Pseq([0.25, 0.25, 0.25, 0.25], 1),
		\amp, 0.32,
		\pan, Pseq([0.5, -0.5, 0.5, -0.5],1)
	)
], inf).play(quant: 1);




SynthDef(\kik, { |out, preamp = 1, amp = 1|
    var    freq = EnvGen.kr(Env([420, 66], [0.08], -3)),
        sig = SinOsc.ar(freq, 0.5pi, preamp) * amp
            * EnvGen.kr(Env([0, 1, 0.8, 0], [0.01, 0.1, 0.2]), doneAction: Done.freeSelf);
    Out.ar(out, sig ! 2);
}).add;

k = Pbind(\instrument, \kik, \delta, 1, \preamp, 1.5, \amp, 0.32).play(quant: 1);



SynthDef(\snare, {
	|out, amp = 1, gate=1|
	var sig, env = Env.adsr(0.0, 0.05, 0, 0.5);

	sig = WhiteNoise.ar(amp) * EnvGen.kr(env, gate, doneAction: Done.freeSelf);
	sig = sig + AllpassC.ar(sig, 0.25, 0.125, 0.5);
	sig = LPF.ar(sig, Line.kr(900,1200,0.2));
	Out.ar(out, sig*1.5 ! 2);
}).add;

n = Pbind(\instrument, \snare, \delta, 1, \preamp, 4.5, \amp, 0.32, \dur, Pseq([Rest(1), 2], inf)).play(quant: 2);



SynthDef(\chords, {
	|out, freq = 440, attack = 0.2, delay = 2, sustain = 0, release = 1, gate = 1|
	var a, b, c, n = 12;
	a = Mix.fill(n, { Saw.ar(freq*2/15*n, 0.3 / n) });
	b = Mix.fill(n, { SinOsc.ar(freq*2/10*n, 0,  0.5 / n) });
	a = LPF.ar(a, LFTri.kr(125/60*3,pi,740,740));
	b = LPF.ar(b, LFTri.kr(3,0,740,740));
	c = Mix.new([Pan2.ar(a,-0.3),Pan2.ar(b,0.3)]);

	Out.ar(out, c * EnvGen.kr(Env.adsr(attack, delay, sustain, release), gate, doneAction: Done.freeSelf););
}).add;

c = Pbind(\instrument, \chords,
	\delta, 4,
	\sustain, 1,
	\release, Pseq([1.5, 2, 2, 1.5,   1.5, 2, 2, 0,   1.5, 2, 2, 1.5,   1.5, 2, 3.5, 1], inf),
	\attack, Pseq([0.1, 0.3, 0.2, 0.1], inf),
	\midinote, Pseq([36, 48, 36, 44,   36, 48, 36, 44,   36, 38, 40, 44,  36, 38, 40, Rest(1)], inf)
    ).play(quant: 2);



SynthDef(\stabs, {
	|out, sustain=0.4, attack=0.05, delay=0.2, release=0, freq=440, gate=1|
	var sig;
	sig = Pulse.ar(freq,0.5,0.1);
	sig = sig + Pulse.ar(freq*3/2,0.5,0.1);
	sig = sig + Pulse.ar(freq*7/3,0.2,0.1);
	sig = sig ! 2;
	Out.ar(out, 0.5*sig * EnvGen.kr(Env.adsr(attack, delay, sustain, release), gate, doneAction: Done.freeSelf););
}).add;

f = Pbind(\instrument, \stabs,
	\delta, Pseq([Rest(3.5),0.2,0.3],inf),
	\sustain, 0,
	\delay, 0.2,
	\attack, 0.05,
	\midinote, 36
    ).play(quant: 4);
)



//k.stop;
//h.stop;
//n.stop;
//c.stop;
//f.stop;