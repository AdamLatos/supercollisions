
(
SynthDef(\jingle, {
	arg out=0, amp=0.2, freq=400, atk=0.1, rel=2, pan=0, tone=0;
	var sig, sig_low, sig_mid, sig_high, env_low, env_mid, env_high;

	env_low = Env.perc(atk, rel).ar(2);
	env_mid = Env.perc(atk/2, rel/2).ar;
	env_high = Env.perc(atk/2, rel/3).ar;
	sig = DC.ar(0);
	sig = sig + Array.fill(6,{arg i; Pulse.ar(freq + i + Pulse.ar(freq + i,0.7,freq,freq),0.5,0.3)});
	sig_low = LPF.ar(sig,freq);
	sig_low = sig_low * env_low;
	sig_low = HPF.ar(sig_low,freq);

	sig_mid = BPF.ar(sig,(freq*8).clip(10,15000));
	sig_mid = sig_mid * env_mid;
	sig_mid = HPF.ar(sig_mid,(freq*8).clip(10,15000));

	sig_high = BPF.ar(sig,(freq*32).clip(10,15000));
	sig_high = sig_high * env_high;
	sig_high = HPF.ar(sig_high,(freq*32).clip(10,15000));

	sig_low = sig_low * (1.1-tone);
	sig_high = sig_high * (0.1+tone);


	sig = Mix.ar([sig_low, sig_mid, sig_high]);
	sig = sig * env_low * amp;
	Out.ar(out, sig!2);
}).add;

Pbind(
	\instrument, \jingle,
	\dur, Pn(Pseq([0.1],24)++Pn(0.8,1)),
	\amp, Pn(Pn(Pseq([0.2])++Pn(0.1,7),3)++Pn(0.2,1)),
	\freq, Pn(Pexprand(950,1050,24)++Pn(1000,1)),
	\tone, Pn(Pseq([0,0.25,0.5,0.75,1,0.6,0.4,0.2],3)++Pn(0.1,1)),
	\rel, Pn(Pn(0.15,24)++Pn(2,1)),
).play();

)
