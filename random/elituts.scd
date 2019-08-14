(
z = {
	var freq, amp, sig, noiseHz, multiplier, phase;
	noiseHz = SinOsc.kr(1,0,5,6);
	freq = LFNoise0.kr(noiseHz).exprange(200,4000);
	amp = LFNoise1.kr(12).exprange(0.02,0.3);
	multiplier = {1.rrand(2)};
	phase = SinOsc.kr(LFSaw.kr(0.3,0,420,210),1,0.1)*2pi;
	sig = SinOsc.ar([freq*multiplier, freq*1.002], phase, amp);
	sig = BPF.ar(sig,freq/2,SinOsc.kr(1).range(0.05,0.5));
}.play;
)