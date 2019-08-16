MIDIClient.init;
MIDIIn.connectAll;
s.boot;

(
~notes = Array.newClear(128);
~bend = 8192;
~detune = 1;

MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn, chan, src;
	[vel, nn, chan, src].postln;
	~notes[nn] = Synth.new(
		\tone,
		[
			\freq, nn.midicps,
			\amp, vel.linexp(1,127,0.1,0.5),
			\gate, 1,
			\bend, ~bend.linlin(0,16383,-2,2),
			\detune, ~detune;
		]
	);
});

MIDIdef.noteOff(\noteOffTest, {
	arg vel, nn, chan;
	~notes[nn].set(\gate, 0);
	~notes[nn] = nil;
});

MIDIdef.bend(\bendTest, {
	arg val, chan, src;
	[val, chan, src].postln;
	~bend = val;
	~notes.do{arg synth; synth.set(\bend, val.linlin(0,16383,-2,2))};
}):

MIDIdef.cc(\cc, {
	arg val, func, cc;
	[val, func, cc].postln;
	if ( func == 1,
		{
			~detune = 1 + (val / 1000);
			~notes.do{arg synth; synth.set(\detune, ~detune)};
		}
	)
});

SynthDef.new(\tone, {
	arg freq, amp, gate=0, bend=0, detune=1.001;
	var sig, env;
	sig = LFTri.ar([freq * bend.midiratio, freq * bend.midiratio * detune]);
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = sig * env * amp;//vel.linexp(1,127,0.01,0.3);
	Out.ar(0,sig);
}).add;


)