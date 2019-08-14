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

h = Pn(Pn(Rest(16),1)++Pn(Prand([
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
	)], 12)
++ Pn(
	Pbind(
		\instrument, \hihat,
		\delta, Pseq([0.5, 0.25, 0.25, 0.5, 0.25, 0.25]/2, 2),
		\amp, 0.32,
		\pan, Pseq([0.3, -0.3, -0.3, 0.3, 0.3, 0.3], 1)
	) ++
	Pbind(
		\instrument, \hihat,
		\delta, Pseq([0.5, 0.25, 0.25, 0.5, 0.5]/4, 4),
		\amp, 0.32,
		\pan, Pseq([0.1, -0.1, -0.1, 0.3, 0.1, -0.1], 1)
),2),inf)).play(quant: 1);




SynthDef(\kik, { |out, preamp = 1, amp = 1|
    var    freq = EnvGen.kr(Env([420, 66], [0.08], -3)),
        sig = SinOsc.ar(freq, 0.5pi, preamp) * amp
            * EnvGen.kr(Env([0, 1, 0.8, 0], [0.01, 0.1, 0.2]), doneAction: Done.freeSelf);
    Out.ar(out, sig ! 2);
}).add;

k = Pbind(\instrument, \kik,
	\delta, Pn(Pn(1,128) ++ Pn(Pseq([0.1,0.4,0.5,1,1,0.5,0.5]),4),inf),
	\preamp, Pn(Pn(1.5,128) ++ Pn(Pseq([1,1.5,1.5,1.8,1,1.6,1.5]),4),inf),
	\amp, 0.32).play(quant: 1);



SynthDef(\snare, {
	|out, amp = 1, gate=1, multi=1|
	var sig, env = Env.adsr(0.0, 0.05, 0, 0.5);

	sig = WhiteNoise.ar(amp) * EnvGen.kr(env, gate, doneAction: Done.freeSelf);
	sig = sig + AllpassC.ar(sig, 0.25, 0.125*multi, 0.5);
	sig = LPF.ar(sig, Line.kr(900,1200,0.2));
	Out.ar(out, sig*2 ! 2);
}).add;

n = Pn( Pn(Rest(8),1) ++ Pn (
	Pbind(\instrument, \snare,
	\delta, 1,
	\preamp, 4.5,
	\amp, 0.32,
	\multi, Pseq([1,1,1,1,1,1,1,1,1/2,1/2,1/2,1/2,1/4,1/4,1/8,1/8],7),
	\dur, Pseq([Rest(1), 2], inf)) ++
	Pbind(\instrument, \snare,
	\delta, 0.5,
	\preamp, 4.5,
	\amp, 0.32,
	\multi, Pseq([1,1/8,1,1/2,1,1,1,1,1/2,1/2,1/2,1/2,1/4,1/4,1/8,1/8],2),
		\dur, Pseq([Rest(1), 2], inf)),inf)).play(quant: 2);



SynthDef(\chords, {
	|out, freq = 440, attack = 0.2, delay = 2, sustain = 0, release = 1, gate = 1, amp = 1|
	var a, b, c, n = 12;
	a = Mix.fill(n, { Saw.ar(freq*2/15*n, 0.3 / n) });
	b = Mix.fill(n, { SinOsc.ar(freq*2/10*n, 0,  0.5 / n) });
	a = LPF.ar(a, LFTri.kr(125/60*3,pi,740,740));
	b = LPF.ar(b, LFTri.kr(3,0,740,740));
	c = Mix.new([Pan2.ar(a,-0.3),Pan2.ar(b,0.3)]);

	Out.ar(out, c * EnvGen.kr(Env.adsr(attack, delay, sustain, release), gate, amp, doneAction: Done.freeSelf););
}).add;



c = Pbind(\instrument, \chords,
	\delta, Pn(Rest(1),32) ++ Pn(4,inf),
	\amp, 0.5,
	\sustain, 1,
	\release, Pseq([1.5, 2, 2, 1.5,   1.5, 2, 2, 0,   1.5, 2, 2, 1.5,   1.5, 2, 3.5, 1], inf),
	\attack, Pseq([0.1, 0.3, 0.2, 0.1], inf),
	\midinote, Pseq([36, 48, 36, 44,   36, 48, 36, 44,   36, 38, 40, 44,  36, 38, 40, Rest(1)], inf) + Prand([[0, 3], [0, 4]],inf)
    ).play(quant: 2);



SynthDef(\stabs, {
	|out, sustain=0.4, attack=0.05, delay=0.2, release=0, freq=440, gate=1|
	var sig;
	sig = Pulse.ar(freq,0.5,0.05);
	sig = sig + Pulse.ar(freq*3/2,0.5,0.05);
	sig = sig + Pulse.ar(freq*7/3,0.2,0.05);
	sig = sig ! 2;
	Out.ar(out, 0.5*sig * EnvGen.kr(Env.adsr(attack, delay, sustain, release), gate, doneAction: Done.freeSelf););
}).add;

f = Pbind(\instrument, \stabs,
	\delta, Pseq([Rest(11.5),0.2,0.3],inf),
	\sustain, 0.3,
	\delay, 0.2,
	\attack, 0.05,
	\midinote, 66
    ).play(quant: 4);


g = Pbind(\instrument, \chords,
	\delta, Pseq([Rest(3),0.1,0.1,0.1,0.1,0.1,Prand([24,14,20])],inf),
	\amp, 0.1,
	\sustain, 1,
	\attack, 2,
	\midinote, Prand([Pseq([36, 40, 44, 48, 52, 56])+24, Pseq([36, 40, 44, 48, 52, 56])+36],inf),
    ).play(quant: 2);

SynthDef(\bass, {
	arg out, amp=1, freq=440, atk=0.1, dec=0.2, sus=1, rel=0.3, detune=0.01, width=0.5, gate=1, pn=0;
	var sig;

    sig = VarSaw.ar([freq, freq * detune], 0, width);

	sig = sig * EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate, amp, doneAction: Done.freeSelf);
	sig = Pan2.ar(sig, pn);
	Out.ar(out, sig);
}).add;

i = Pn(Pn(Rest(48),1) ++ Pn(
	Pn(Pmono(\default,
		\instrument, \bass,
		\delta, Pseq([1,0.5,0.25,0.25,1,0.5,0.5, Rest(4) ],1),
		\midinote, Pseq([20,24,20,30,12,30,1],1),
		\amp, Pseq([1.5,1.7,1.5,1.8,1.5,1.5,1.5],1),),7) ++
	Pmono(\default,
		\instrument, \bass,
		\delta, 0.5,
		\midinote, Pseq([40,36,30,27,30,25,20,15],1),
		\amp, 1.5,
		\width, Pseq([40,36,30,27,30,25,20,15]*2,1),
	)
)).play(quant: 2);

SynthDef(\melody, {
	arg sustain=1, out, amp=0.2, freq=440, atk=0.1, dec=0.2, sus=1, rel=0.3, detune=0.01, width=0.5, gate=1, pn=0, moogtime=0.1, revmix=0.33, pos=0, sig2pan=0;
	var sig, sig2;

	sig = Mix(Pulse.ar([freq, freq * (1+detune)], LFNoise1.kr(4), 1));
	sig = sig * EnvGen.kr(Env.adsr(atk, dec, sus, rel), 1, amp);
	sig = FreeVerb.ar(sig,revmix);
	sig = MoogFF.ar(sig,XLine.kr(8440,880,moogtime));
	sig = sig * EnvGen.kr(Env.adsr(0.01, 0, 1, sustain), gate, 1, doneAction: Done.freeSelf);
	sig2 = Latch.ar(sig/2, Impulse.ar(SinOsc.kr(5,0,6000,12000)));
	sig2 = Pan2.ar(sig2,sig2pan);
	sig = [sig,sig] + sig2;
	Out.ar(out, sig/6);
}).add;



// Pbind(
// 	\instrument, \melody,
// 	\atk, 0.03,
// 	\dec, 0.02,
// 	\dur, Pn(Rest(1),96) ++ Pn(0.25,256) ++ Pn(Rest(1),32) ++ Pn(0.25,256),
// 	\midinote,
// 	Pn(
// 		Pseq([36, 53, 36, 55, 36, 55, 36, 44, Rest(1), 48, Rest(1), 36, Prand([36, 48, 36, 44],4),
// 			36, 48, 36, 44, 36, 48, 36, 44, Pn(Rest(1),8), //36, 48, 36, 44,
// 			36, Rest(1), 38, 40, Rest(1), 44, Pn(Rest(1),2), 38, 40, 44, Pn(Rest(1),3), Prand([36,38,40,44],2),
// 		36, 38, 40, Rest(1), 38, 36, 38, Rest(1), Prand([Rest(1),38,40],8)]+24,2) ++
// 		Pseq([Prand([Rest(1),[36, 48, 36, 44].choose],8), Rest(1), 48, Rest(1), 36, Prand([36, 48, 36, 44],4),
// 			Prand([Rest(1),[36, 48, 36, 44].choose],8), Pn(Rest(1),8), //36, 48, 36, 44,
// 			36, Rest(1), 38, 40, Rest(1), 44, Pn(Rest(1),2), 38, 40, 44, Pn(Rest(1),3), Prand([36,38,40,44],2),
// 	Prand([Rest(1),[36, 38, 40].choose],8), Prand([Rest(1),38,40],8)]+24,2), inf),
// 	\sustain, Pn(
// 	Pn(1,64)++Pwhite(0.5,1,64),inf),
// 	\moogtime, Pn(
// 	Pn(0.1,64)++Pseries(0.1,0.05,64)++Pseries(0.1+(64*0.01),-0.01,32)++Pxrand([0.1, 0.4, 0.8],32),inf),
// 	\revmix, Pxrand([0,0.33,0.44,0.55,0.66],inf),
// 	\sig2pan, Pxrand([Pn(-0.5,5), Pn(0.5,5)],inf),
// ).play(quant:2);

~prog = [36,48,36,44,36,48,36,44,36,38,40,44,36,38,40,40]+24;
~prog +.x {[0, 7, 11, Rest(1)].choose};

Pbind(
	\instrument, \melody,
	\atk, 0.03,
	\dec, 0.02,
	\amp, Pseries(0,0.005,40) ++ Pn(0.2,inf),
	\dur, Pn(Rest(1),96) ++ Pn(0.25,256) ++ Pn(Rest(1),32) ++ Pn(0.25,256),
	\midinote,
	Pseq([36]+24,16*16) ++
	Pn(Pstutter(16, Pseq(~prog)) + Pwrand([0,7,10,Rest(1)],[0.3, 0.25, 0.3, 0.15],inf),1) ++
	Pseq([36]+24,16*16),
	\sustain, Pn(
		Pn(1,64)++Pwhite(0.1,0.3,64),inf),
	\moogtime, Pn(
		Pn(0.1,64)++Pseries(0.1,0.05,64)++Pseries(0.1+(64*0.01),-0.01,32)++Pxrand([0.1, 0.4, 0.8],32),inf),
	\revmix, Pxrand([0,0.33,0.44,0.55,0.66],inf),
	\sig2pan, Pxrand([Pn(-0.5,5), Pn(0.5,5)],inf),
).play(quant:2);


s.record(duration: 192);

)


//k.stop;
//h.stop;
//n.stop;
//c.stop;
//f.stop;