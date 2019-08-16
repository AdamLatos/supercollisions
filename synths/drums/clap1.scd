// adapted from a post by Neil Cosgrove (other three are original)
(
SynthDef(\clap1, {
    arg out=0, amp=0.5, pan=0, dur=1, width=0;
    var env1, env2, snd, noise1, noise2, sndMono, sndStereo;

    // noise 1 - 4 short repeats
    env1 = EnvGen.ar(
        Env.new(
            [0, 1, 0, 0.9, 0, 0.7, 0, 0.5, 0],
            [0.001, 0.009, 0, 0.008, 0, 0.01, 0, 0.03],
            [0, -3, 0, -3, 0, -3, 0, -4]
        )
    );

    noise1 = WhiteNoise.ar(env1!2);
    noise1 = HPF.ar(noise1, 600);
    noise1 = LPF.ar(noise1, XLine.kr(7200, 4000, 0.03));
    noise1 = BPF.ar(noise1, 1620, 3);

    // noise 2 - 1 longer single
    env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.18], [0, -4]), doneAction:2);

    noise2 = WhiteNoise.ar(env2!2);
    noise2 = HPF.ar(noise2, 1000);
    noise2 = LPF.ar(noise2, 7600);
    noise2 = BPF.ar(noise2, 1230, 0.7, 0.7);

	sndMono = (noise1[0] + noise2[1])!2;
	sndStereo = noise1+noise2;
	snd = ((width*sndStereo) + ((1-width)*sndMono)) * 2;
    snd = snd.softclip;

	Out.ar(out, Balance2.ar(snd[0],snd[1],pan,amp));
}).add;

Pbind(
	\instrument, \clap1,
	\dur, Prand([Pseq([0.012,0.005,0.483+0.3],1),Pseq([0.01,0.027,0.463+0.3])],inf),
	\pan, Prand([Pseq([-0.4,0.1,-0.2]), Pseq([0,0.5,-0.1])],inf),
	\width, Pn(Pseries(0,0.05,15)++Pseries(15*0.05,-0.05,15)),
).play(quant:0.8);

)