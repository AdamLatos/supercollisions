//3. define piece-specific functions
s.meter
(
~path = PathName(PathName(thisProcess.nowExecutingPath).parentPath).parentPath++"samples/";

~makeBuffers = {
	b = Dictionary.new;
	PathName(~path).entries.do{
		arg subfolder;
		b.add(
			subfolder.folderName.asSymbol ->
			Array.fill(
				subfolder.entries.size,
				{
					arg i;
					Buffer.read(s, subfolder.entries[i].fullPath);
				}
			)
		);
	};
};

ServerBoot.add(~makeBuffers);

s.waitForBoot({

	s.sync;

	SynthDef(\bpfbuf, {
		arg atk=0, sus=0, rel=3, c1=1, c2=0,
		buf=0, rate=1, spos=0, freq=440, rq=1, bpfmix=0,
		pan=0, amp=1, out=0;
		var sig, env;
		env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
		sig = PlayBuf.ar(2, buf, rate*BufRateScale.ir(buf),startPos:spos);
		sig = XFade2.ar(sig, BPF.ar(sig, freq, rq, 1/rq.sqrt), bpfmix*2-1);
		sig = sig * env;
		sig = Balance2.ar(sig[0], sig[1], pan, amp);
		Out.ar(out, sig);
	}).add;

	s.sync;
	"done".postln;
});
)

(
x = Pbind(
	\instrument, \bpfbuf,
	\buf, Pxrand(b[\guitar].collect(_.bufnum),inf),
	\dur, 0.4,
	\rate, 1.1,
	\sus, 0.3,
	\pan, 0,
	\amp, 0.3
).play(quant:0.8);
)
x.stop;
(

Pbind(
	\instrument, \bpfbuf,
	\buf, b[\harp][3].bufnum,
	\dur, 3.2,
	\rate, 1.1,
	\sus, 0.3,
	\pan, 1,
).play(quant:3.2);
)