s.boot;
(
Pdef(\hihat1,
	Pbind(
		\instrument, \hihat,
		\dur, 1/4,
		\stretch, 60/125*2,
		\amp, Pseq([1] ++ (0.5!3), inf),
	)
);

Pdef(\kick1,
	Pbind(
		\instrument, \kick,
		\dur, 1,
		\stretch, 60/125*2,
	)
);


OSCdef(\toggle1,
	{
		arg msg, time, addr, port;
		x.set(\gate, msg[1]);
	},
	'/1/toggle1'
);

OSCdef(\fader1,
	{
		arg msg, time, addr, port;
		x.set(\freq, msg[1].linexp(0,1,20,400));
	},
	'/1/fader1'
);

OSCdef(\toggle2,
	{
		arg msg, time, addr, port;
		if ( msg[1] == 1,
			{
				Pdef(\hihat1).play(quant: 60/125*4);
			},
			{
				Pdef(\hihat1).stop;
			}
		)
	},
	'/1/toggle2'
);

OSCdef(\fader2,
	{
		arg msg, time, addr, port;
		x.set(\nharm, msg[1].linexp(0,1,1,50));
	},
	'/1/fader2'
);

OSCdef(\toggle3,
	{
		arg msg, time, addr, port;
		if ( msg[1] == 1,
			{
				Pdef(\kick1).play(quant: 60/125*4);
			},
			{
				Pdef(\kick1).stop;
			}
		)
	},
	'/1/toggle3'
);

OSCdef(\fader3,
	{
		arg msg, time, addr, port;
		x.set(\detune, msg[1].linlin(0,1,0,12));
	},
	'/1/fader3'
);

OSCdef(\toggle4,
	{
		arg msg, time, addr, port;
		msg[1].postln;
	},
	'/1/toggle4'
);

OSCdef(\fader4,
	{
		arg msg, time, addr, port;
		Pdef(\hihat1).set(\dec, msg[1].linlin(0,1,0.02,0.5));
	},
	'/1/fader4'
);

OSCdef(\fader5,
	{
		arg msg, time, addr, port;
		x.set(\pan, msg[1].linlin(0,1,-1,1));
	},
	'/1/fader5'
);

SynthDef.new(\bwoom, {
	arg freq=40, nharm=12, detune=0.2, gate=0, pan=0, amp=1, out=0, cutoff=20000;
	var sig, env;
	env = EnvGen.kr(Env.adsr(0.05,0.1,0.5,3),gate);
	sig = Blip.ar(
		freq *
		LFNoise1.kr(0.2!16).bipolar(detune.neg,detune).midiratio,
			nharm
	);
	sig = sig * LFNoise1.kr(0.5).exprange(0.8,1);
	sig = LPF.ar(sig,cutoff.lag(0.5));
	sig = Splay.ar(sig);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;

x = Synth.new(\bwoom);

SynthDef.new(\hihat,
{
	arg out, amp = 1, pan = 0, gate = 1, dec = 0.02;
	var sig, env = Env.adsr(0.005, dec, 0, 0);

	sig = PinkNoise.ar(amp) * EnvGen.kr(env, gate, doneAction: Done.freeSelf);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

SynthDef.new(\kick,
{
	arg out, amp = 1, pan = 0, gate = 1, dec = 0.05;
	var sig, env = Env.adsr([0.0001, 0.0002], 0.5 , 0, 2);

		sig = Pulse.ar([20,40,60,80,100]) * EnvGen.kr(env, gate, doneAction: Done.freeSelf);
	sig = BPF.ar(sig,50,0.1);
	sig = Splay.ar(sig, pan);
	Out.ar(out, sig*10);
}).add;
)

Synth(\kick);

x.free;
x.getMsg(\cutoff)
x.get(\cutoff, {arg val; val.postln;})

s.record;
s.stopRecording;
