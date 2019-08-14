s.boot;

(
SynthDef(\chords, {
	|out,freq=440,sustain=2,amp=0.2, cutoff = 800, rq = 1|
		var sig = Saw.ar(freq) * Line.kr(amp,0,sustain,doneAction: Done.freeSelf);
		sig = RLPF.ar(sig,cutoff,rq);
	Out.ar(out, sig ! 2);
}).add;


~dur = PatternProxy(Pwrand(#[1, 0.5], #[0.8, 0.2], inf));

~cutoff = PatternProxy(800);
~rq = PatternProxy(1);
)

(

var    pattern = Pbind(
	\instrument, \chords,
    \degree, Pseries(7, Pwhite(1, 3, inf) * Prand(#[-1, 1], inf), inf).fold(0, 14)
            + Prand(#[[0, -2, -4], [0, -3, -5], [0, -2, -5], [0, -1, -4]], inf),
    \dur, ~dur,
	\cutoff, ~cutoff,
	\rq, ~rq,
    ), player, window;

window = Window.new("Pattern trigger", Rect(5, 100, 500, 500))
        // onClose is fairly important
        // without it, closing the window could leave the pattern playing
    .onClose_({ player.stop });

Button.new(window, Rect(5, 5, 140, 90))
    .states_([["Pattern GO"], ["Pattern STOP"]])
    .font_(Font.new("Helvetica", 18))
    .action_({ |button|
        if(button.value == 1 and: { player.isNil or: { player.isPlaying.not } }) {
            player = pattern.play;
        } {
            player.stop;
            button.value = 0;
        };
    });
EZSlider.new(window,Rect(145,5,300,30),"Speed",\unipolar)
    .action_({ |slider|
	~dur.source = Pwrand(#[1, 0.5] / ((5*slider.value)+1), #[0.8, 0.2], inf);
});
EZSlider.new(window,Rect(145,35,300,30),"Cutoff",\unipolar)
    .action_({ |slider|
	~cutoff.source = (slider.value*1950);
});
EZSlider.new(window,Rect(145,65,300,30),"Rq",\unipolar)
    .action_({ |slider|
	~rq.source = slider.value;
});
window.front;
)


