{LPF.ar(WhiteNoise.ar(0.1!2),XLine.kr(12000,200,10))}.scope
FreqScope.new


(

{

var source, line, filter; 	//local variables to hold objects as we build the patch up


source=LFNoise0.ar(400);

line=Line.kr(10000,1000,10);

filter=Resonz.ar(source,line,0.1); //the filtered output is the input source filtered by Resonz with a line control for the resonant frequency


filter!2 // last thing is returned from function in curly brackets, i.e. this is the final sound we hear

}.scope;

)

{SinOsc.ar([400,660],0,0.1)}.scope
{Pan2.ar(Mix(SinOsc.ar([400,660],0,0.1)),MouseX.kr(-1,1))}.scope //a two channel signal put through Mix turns into mono


(

{

	var n = 10;


	var wave = Mix.fill(10,{|i|
		var mult= ((-1)**i)*(0.5/((i+1)));
    	SinOsc.ar(440*(i+1))*mult
    });


	Pan2.ar(wave/n,0.0); //stereo, panned centre


}.scope;

)

500*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1] //This is a spectral recipe for a minor third bell, at a base frequency of 500- run this line of code to see how the frequencies are calculated from the multipliers

{Mix(SinOsc.ar(500*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1))}.scope //bell spectra, all partials the same volume

{Mix(SinOsc.ar(500*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1*[0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1]))}.scope //bell spectra, different volumes for partials

{SinOsc.ar(mul:2.0)}.scope		//loud! defaults are 440 Hz, amplitude multiplier 2.0

{SinOsc.ar(mul:0.1, add:MouseY.kr(0.9,-0.9))}.scope		//demo of offsetting

{SinOsc.ar(mul:MouseX.kr(0.1,1.0), add:MouseY.kr(0.9,-0.9))}.scope


(

{

	//cutoff values need to be sensible frequencies in Hz; here sine output turned from -1 to 1 into 2000+-1700

	var cutoff = 	SinOsc.ar(1,mul:MouseX.kr(0.0,1700.0), add:2000.0);

	//var cutoff = SinOsc.ar(1)*1700.0 + 2000.0;  //same thing

	LPF.ar(WhiteNoise.ar,freq:cutoff);

}.scope

)

{SinOsc.ar(SinOsc.ar(3,mul:40,add:440),0,0.1)}.scope



(

{

var carrier, modulator, carrfreq, modfreq;


carrfreq= MouseX.kr(440,5000,'exponential');

modfreq= MouseY.kr(1,5000,'exponential');


carrier= SinOsc.ar(carrfreq,0,0.5);

modulator= SinOsc.ar(modfreq,0,0.5);


carrier*modulator;

}.scope

)



(

{

var carrier, modulator, carrfreq, modfreq;


carrfreq= MouseX.kr(440,5000,'exponential');

modfreq= MouseY.kr(1,5000,'exponential');


carrier= SinOsc.ar(carrfreq,0,0.5);

modulator= SinOsc.ar(modfreq,0,0.25, 0.25);


carrier*modulator;

}.scope

)




(

var w, carrfreqslider, modfreqslider, moddepthslider, synth;


w=Window("frequency modulation", Rect(100, 400, 400, 300));

w.view.decorator = FlowLayout(w.view.bounds);


synth= {arg carrfreq=440, modfreq=1, moddepth=0.01;

SinOsc.ar(carrfreq + (moddepth*SinOsc.ar(modfreq)),0,0.25)

}.scope;


carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez|  synth.set(\carrfreq, ez.value)});

w.view.decorator.nextLine;


modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez|  synth.set(\modfreq, ez.value)});

w.view.decorator.nextLine;

moddepthslider= EZSlider(w, 300@50, "moddepth", ControlSpec(0.01, 5000, 'exponential', 0.01, 0.01), {|ez|  synth.set(\moddepth, ez.value)});


w.front;

)

(

var w, carrfreqslider, modfreqslider, modindexslider, synth;


w=Window("frequency modulation via modulation index", Rect(100, 400, 400, 300));

w.view.decorator = FlowLayout(w.view.bounds);


synth= {arg carrfreq=440, modfreq=1, modindex=0;

SinOsc.ar(carrfreq + (modindex*modfreq*SinOsc.ar(modfreq)),0,0.25)

}.scope;


carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez|  synth.set(\carrfreq, ez.value)});

w.view.decorator.nextLine;


modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez|  synth.set(\modfreq, ez.value)});

w.view.decorator.nextLine;

modindexslider= EZSlider(w, 300@50, "modindex", ControlSpec(0.0, 10, 'linear', 0.01, 0.0), {|ez|  synth.set(\modindex, ez.value)});


w.front;

)











(

{

var carrfreq, modfreq, harmonicity, modindex;


//fc is frequency of carrier

//fm is frequency of modulator


carrfreq= 440; //MouseY.kr(330,550);

harmonicity= MouseX.kr(0,10).round(1);

modindex= MouseY.kr(0.0,10.0); //which is really modulation amplitude/modulation frequency, acts as brightness control as energy distribution changed over components


modfreq= carrfreq*harmonicity; //since harmonicity is an integer,


SinOsc.ar(carrfreq+(SinOsc.ar(modfreq)*modfreq*modindex), 0.0,0.1);


}.play

)










(

var w, carrfreqslider, modfreqslider, modindexslider, synth;

var conversion= 2pi/(s.sampleRate); //needed to avoid phase being adjusted too wildly


w=Window("phase modulation via modulation index", Rect(100, 400, 400, 300));

w.view.decorator = FlowLayout(w.view.bounds);


synth= {arg carrfreq=440, modfreq=1, modindex=0;

SinOsc.ar(carrfreq, ( (modfreq*modindex)*conversion*SinOsc.ar(modfreq)),0.25)

}.scope;


carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez|  synth.set(\carrfreq, ez.value)});

w.view.decorator.nextLine;


modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez|  synth.set(\modfreq, ez.value)});

w.view.decorator.nextLine;


//bigger range since adjusting phase directly and not frequency

modindexslider= EZSlider(w, 300@50, "modindex", ControlSpec(0.0, 100, 'linear', 0.01, 0.0), {|ez|  synth.set(\modindex, ez.value)});


w.front;

)


{SinOscFB.ar(300,SinOscFB.kr(4,SinOsc.kr(3,0,1,1),1.5,0.5),0.2!2);}.scope;






(

{

var modfreq, modindex, conversion;


modfreq= MouseX.kr(1,1000, 'exponential');

modindex=MouseY.kr(0.0,100.0);

conversion= 2pi/(s.sampleRate);


//Phasor is a UGen which will loop around a given interval, in this case 0 to 2pi, taking us around the waveform of the sinusoid; note that all the action is in the phase input

SinOsc.ar(0, Phasor.ar(0,440*conversion,0,2pi)+( (modfreq*modindex)*conversion*SinOsc.ar(modfreq)), 0.25)


//simpler alternative

//SinOsc.ar(440, ( (modf*ind)*conversion*SinOsc.ar(modf)), 0.25)

}.scope

)

{Mix(Saw.ar([440,443,437],0.1))}.scope //chorusing

(

{

Mix(

	Resonz.ar(			//The Resonz filter has arguments input, freq, rq=bandwidth/centre frequency

		Saw.ar([440,443,437] + SinOsc.ar(100,0,100)), //frequency modulated sawtooth wave with chorusing

		XLine.kr(10000,10,10), //vary filter bandwidth over time

		Line.kr(1,0.05, 10), //vary filter rq over time

		mul: LFSaw.kr(Line.kr(3,17,3),0,0.5,0.5)*Line.kr(1,0,10)  //AM

	)

)

}.scope

)


//run me first to load the soundfiles

(

b=Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav");

//b.Buffer.read(s,"sounds/a11wlk01.wav"); //SC3.4 or earlier

)



//now me!

(


{

var modfreq, modindex, modulator;


modfreq= MouseX.kr(1,4400, 'exponential');

modindex=MouseY.kr(0.0,10.0,'linear');


modulator= SinOsc.kr(modfreq,0,modfreq*modindex, 440);


PlayBuf.ar(1,b, BufRateScale.kr(b)* (modulator/440), 1, 0, 1)


}.scope;

)



//richer bell patch

(

var numpartials, spectrum, amplitudes, modfreqs1, modfreqs2, decaytimes;


spectrum = [0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1];


amplitudes= [0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1];


numpartials = spectrum.size;


modfreqs1 = Array.rand(numpartials, 1, 5.0); //vibrato rates from 1 to 5 Hz


modfreqs2 = Array.rand(numpartials, 0.1, 3.0); //tremolo rates from 0.1 to 3 Hz


decaytimes = Array.fill(numpartials,{|i|  rrand(2.5,2.5+(5*(1.0-(i/numpartials))))}); //decay from 2.5 to 7.5 seconds, lower partials longer decay


{

Mix.fill(spectrum.size, {arg i;

	var amp, freq;



	freq= (spectrum[i]+(SinOsc.kr(modfreqs1[i],0,0.005)))*500;

	amp= 0.1* Line.kr(1,0,decaytimes[i])*(SinOsc.ar(modfreqs2[i],0,0.1,0.9)* amplitudes[i]);



	Pan2.ar(SinOsc.ar(freq, 0, amp),1.0.rand2)});

}.scope


)

Env([1,0],[1.0]).plot


{Saw.ar(EnvGen.ar(Env([10000,20],[0.5])),EnvGen.ar(Env([0.1,0],[2.0])))}.scope




//FM sound

({

SinOsc.ar(

	SinOsc.ar(10,0,10,440),

	0.0,

	EnvGen.kr(Env([0.5,0.0],[1.0]), doneAction:2)   //doneAction:2 appears again, the deallocation operation

	)

}.scope

)


{Saw.ar(EnvGen.kr(Env([500,100],[1.0]),doneAction:2),0.1)}.scope



{EnvGen.ar(Env([0,0.1,0],[0.1,0.9]),doneAction:2)*SinOsc.ar(330)}.play

a = {EnvGen.ar(Env.asr(0.1,0.1,1.0),doneAction:2)*SinOsc.ar(330)}.play //sound continues

e = Env([0.0,1.0,-1.0,0.0],[0.01,0.01,2.0],0,2,0); //releaseNode at 2, loopNode at 0


e.plot


a= {arg gate=1; EnvGen.ar(e,gate,timeScale:MouseX.kr(0.1,2.0),doneAction:2)}.play



(

SynthDef(\event,{ arg freq=440, amp=0.5, pan=0.0;

	var env;



	env = EnvGen.ar(  Env([0,1,1,0],[0.01, 0.1, 0.2]),  doneAction:2);



	Out.ar(0,  Pan2.ar(Blip.ar(freq) * env * amp, pan))

}).add;

)

Synth(\event)	//accepts defaults. Event shouldn't hang around once envelope finished due to doneAction:2


(

{



	Synth(\event);



	1.0.wait;	//wait for 1 time unit of default tempo, will probably work out to 1 second



	Synth(\event);



}.fork; 	//.fork is a computer science term for setting a new process (sequence) in action

)

(

{



	4.do {

		Synth(\event);

		0.1.wait;

	};



}.fork;

)

4.do {arg repeatnumber; repeatnumber.postln; "iteration complete".postln;}; //run; what do you see in your post window?


(

{



	8.do {

		//rrand(low, hi) gets a uniform random number in that range

		Synth(\event,[\freq, rrand(440,880)]);

		0.2.wait;

	};



}.fork;

)


//now 8 events, unevenly spaced

(

{



	8.do {

		Synth(\event,[\freq, rrand(440,880)]);

		rrand(0.2,0.6).wait;

	};



}.fork;

)


(

{



	8.do {

		Synth(\event,[\freq, rrand(110,220)]);

		rrand(0.2,0.6).wait;

	};



	4.do {

		Synth(\event);

		0.25.wait;

	};



}.fork;

)



(

var tempoclock = TempoClock(1);  //1 beat per second

{



	//inf.do does something forever. Make very sure that there is a .wait of some duration inside the loop!

	inf.do {

		Synth(\event,[\freq, rrand(440,880)]);

		0.05.wait;

	};



}.fork(tempoclock);

)



{Impulse.ar(MouseX.kr(1,100))}.play

{Dust.ar(MouseX.kr(1,100))}.play

(

{

	[

	LFNoise0.ar(100),	//step

	LFNoise1.ar(100),	//linear interpolation

	LFNoise2.ar(100)	//quadratic interpolation

	]

}.plot(0.1)

)


{ Stepper.ar(Impulse.ar(100), 0,1,10,1) }.plot(0.3,minval:0,maxval:10);


{ SinOsc.ar(Stepper.ar(Impulse.ar(10), 0,1,10,1)*100,0,0.1) }.play


{ Saw.ar(Select.kr(Stepper.kr(Impulse.kr(4,0.1),0,0,7,1),[72,63,67,72,55,62,63,60].midicps),0.1) }.play



{SinOsc.ar(300+(200*Latch.ar(SinOsc.ar(13.3), Impulse.ar(10))))*0.2}.play


{SinOsc.ar(400*(1+EnvGen.ar(Env([0,1,0,0.5,-0.4],0.1!4,curve:\step),Impulse.kr(2.5))))}.play



(

{

var sound,env, trig;


trig= Impulse.ar(3); //trigger source


sound= Mix(LFPulse.ar(110*[1,5/2],0.0,0.5,0.2));


env= EnvGen.ar(Env.perc(0.02,0.2),trig); //with retriggering controlled by impulse


Pan2.ar(sound*env,0.0)

}.play
)


(

SynthDef(\mytriggersynth,{arg trig=0;

var env;


//must have additional starting level in envelope, else no nodes to go back to

env= EnvGen.ar(Env([2,2,1],[0.0,0.5],'exponential'),trig);


Out.ar(0,Pan2.ar(Resonz.ar(Saw.ar(env*440),1000,0.1),0.0))

},[\tr]).add

)


a= Synth(\mytriggersynth);


a.set(\trig, 1)	//if this wasn't an explicit trigger input, this wouldn't reset the envelope


(

{

var sound,env, trig;


//> is itself a UGen when used in this context; it is outputting the result of comparing the LFNoise0 with the value 0 every sample!

trig= LFNoise0.ar(13)>0; //trigger source (might also use Dust, for example)


//TRand chooses a random number in its range when triggered

sound= Mix(LFPulse.ar(110*[1,5/2,TRand.ar(3.9,4.1,trig)],0.0,0.5,0.2));


env= EnvGen.ar(Env.perc(0.02,0.1),trig); //with retriggering controlled by impulse


Pan2.ar(sound*env,0.0)

}.play

)


{ SyncSaw.ar(MouseX.kr(1,400), MouseY.kr(400,800), 0.1) }.play;


{Saw.ar((Stepper.ar(Impulse.ar(10),0,1,10,1)*200).lag(MouseX.kr(0.0,0.2)))}.play


{Ringz.ar(Saw.ar(LFNoise0.kr(5).lag(0.1).exprange(100,2000),0.2), 1000, 0.01)}.play


(

{

	Decay2.ar(Impulse.ar(100),0.005,0.01)

}.plot(0.1)

)









(

//two quickly created sounds; they click because of the line generators being quite crude

SynthDef(\sound1,{arg freq=440,amp=0.1;

var sound;


sound= LPF.ar(Saw.ar(freq),2000)*Line.kr(1,0,0.1, doneAction:2)*amp;

Out.ar(0,Pan2.ar(sound,0.0))

}).add;


SynthDef(\sound2,{arg freq=440,amp=0.1;

var sound;


sound= HPF.ar(LFPar.ar(freq),1000)*Line.kr(0,1,0.5, doneAction:2)*amp;

Out.ar(0,Pan2.ar(sound,0.0))

}).add;

)


//test SynthDefs

Synth(\sound1)


Synth(\sound2)


//nested scheduling; each bar has a different length, and uses one of two sounds

(

var barlengths= [4.0,3.5,5.0];

 var t= TempoClock(2.5);

{



	inf.do{|i|



		var barnow= barlengths.wrapAt(i);



		"new bar".postln;



		{

		var whichsound;



		whichsound= [\sound1,\sound2].choose;



			((barnow/0.25)-2).floor.do{|j|



				Synth(whichsound,[\freq, 300+(100*j),\amp,0.3]);



				0.25.wait;



			};



		}.fork(t);



		barnow.wait;

	}



}.fork(t)



)








































(
{
	SynthDef(\bleep,{ arg out=0, note=60, amp=0.5, pan=0.0;
		var freq, env;
		freq = note.midicps;
		env = EnvGen.ar(
		Env([0,1,1,0],[0.01, 0.1, 0.2]),
		levelScale:amp,
		doneAction:2
		);
		Out.ar(out,
		Pan2.ar(Blip.ar(freq) * env, pan)
		)
	}).add;
	SynthDef(\bleep2,{ arg out=0, note=60, amp=0.5, pan=0.0;

		var freq, env;

		freq = note.midicps;

		env = EnvGen.ar(

		Env([0,1,1,0],[0.1, 0.1, 0.02]),

		levelScale:amp,

		doneAction:2

		);

		Out.ar(out,

		Pan2.ar(Blip.ar(freq, Line.kr(10,1,1)) * env, pan)

		)

	}).add;



	SynthDef(\mlpitch,{

		var soundin, amp, freq, hasFreq;



		soundin= SoundIn.ar;



		amp= Amplitude.kr(soundin);

		#freq, hasFreq= Pitch.kr(soundin);



		Out.ar(0,amp*SinOsc.ar(freq))

	}).add;



	s.sync;  //won't proceed until server confirms it has the SynthDefs ready



	//make buffers;

	//s.sync;



	//three sections





	//1.



	10.do{|i|



		Synth([\bleep, \bleep2].choose);



		0.15.wait;

	};



	1.0.wait;

	//2.



	a= Synth(\mlpitch);



	1.0.wait;



	a.free;



	1.0.wait;

	//3. two sequences of actions happen simultaneously (note no gap between the two)



	{

		100.do{|i|



			Synth([\bleep, \bleep2].choose,[\note, ([60,62,64,66,67,69,71]-12).choose]);



			rrand(0.05,0.15).wait;

		};



	}.fork;



	//though process has just been forked off, straight to do further things in this thread too!



	100.do{|i|



		Synth([\bleep, \bleep2].choose,[\note, [60,62,64,66,67,69,71].choose]);



		0.1.wait;

	};





}.fork;

)












(

    // strummable guitar

    // use mouse to strum strings

{

	var pitch, mousex, out;

	pitch = [ 52, 57, 62, 67, 71, 76 ];		// e a d g b e

	mousex = MouseX.kr;

	out = Mix.fill(pitch.size, { arg i;

		var trigger, pluck, period, string;

		// place trigger points from 0.25 to 0.75

		trigger = HPZ1.kr(mousex > (0.25 + (i * 0.1))).abs;

		pluck = PinkNoise.ar(Decay.kr(trigger, 0.05));

		period = pitch.at(i).midicps.reciprocal;

		string = CombL.ar(pluck, 0.001, 0.001, 0.1);

		Pan2.ar(string, i * 0.2 - 0.5);

	});

	LPF.ar(out, 12000);

	LeakDC.ar(out);

}.play;

)

































(

//this loads into a buffer the default sound that comes with SuperCollider

//.read brings in the whole sound at once

b = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav"); //store handle to Buffer in global variable b


SynthDef("playbuf",{ arg out=0,bufnum=0, rate=1, trigger=1, startPos=0, loop=1;

	Out.ar(out,

		Pan2.ar(PlayBuf.ar(1,bufnum, BufRateScale.kr(bufnum)*rate, trigger, BufFrames.ir(bufnum)*startPos, loop),0.0)

	)

}).add;

)


Synth(\playbuf, [\out, 0, \bufnum, b.bufnum]);
Synth(\playbuf, [\out, 0, \bufnum, b.bufnum, \rate, 0.5]);











//Example with GUI controlling Synth

(

var w, rateslid, trigslid, startposslid, loopslid, a;


a=Synth(\playbuf, [\out, 0, \bufnum, b.bufnum]);


w=Window("PlayBuf Example",Rect(10,200,300,150));


w.front;


//control positioning of new GUI elements so I don't have to think too hard about it

w.view.decorator= FlowLayout(w.view.bounds);


//James' shortcut slider class

//250@24 means a Point of size 250 by 24

//|ez| is the same as arg ez;  - the EZSlider object is being passed into the callback action function

rateslid= EZSlider(w, 250@24, "Rate", ControlSpec(0.5, 10, 'exponential', 0.1), {|ez| a.set(\rate,ez.value)}, 1);


trigslid= EZSlider(w, 250@24, "Trigger", ControlSpec(0, 1, 'lin', 1), {|ez| a.set(\trigger,ez.value)}, 1);


startposslid= EZSlider(w, 250@24, "StartPos", ControlSpec(0.0, 1.0, 'lin', 0.01), {|ez| a.set(\startPos,ez.value)}, 0);


loopslid= EZSlider(w, 250@24, "Loop", ControlSpec(0, 1, 'lin', 0.1), {|ez| a.set(\loop,ez.value)}, 1);


w.onClose_({a.free;});

)

























(

//this loads into a buffer the default sound that comes with SuperCollider

//.read brings in the whole sound at once

b = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav");


//using Mouse to scrub through- X position is normalised position 0 to 1 phase through the source file

SynthDef("bufrd",{ arg out=0,bufnum=0;

	Out.ar(out,

		Pan2.ar(BufRd.ar(1, bufnum, K2A.ar(BufFrames.ir(b.bufnum)*MouseX.kr(0.0,1.0)).lag(MouseY.kr(0.0,1.0))),0.0)

	)

}).play(s);

)




//simple sine grain synthdef - note the all important doneAction

(

SynthDef(\sinegrain, {arg pan, freq, amp; var grain;


grain= SinOsc.ar(freq, 0, amp)*(XLine.kr(1.001,0.001,0.1,doneAction:2)-0.001);


Out.ar(0,Pan2.ar(grain, pan))}).add;

)


Synth(\sinegrain,[\freq,rrand(100,10000),\amp, exprand(0.05,0.1), \pan, 1.0.rand2]);

(

{

100.do{arg i;


	Synth(\sinegrain,[\freq,rrand(100,10000),\amp, exprand(0.05,0.1), \pan, 1.0.rand2]);

	0.01.wait

};

}.fork

)


(

{

200.do{arg i;

var timeprop = (i/199.0)**3;


	Synth(\sinegrain,[\freq,exprand(100,5000-(20*i)),\amp, exprand(0.05,0.1), \pan, 1.0.rand2]);

	rrand((timeprop*0.1).max(0.01),timeprop*0.3).wait

};

}.fork

)

//simple playbuf grain synthdef - note the all important doneAction

(

SynthDef(\sfgrain, {arg bufnum=0, pan=0.0, startPos=0.0, amp=0.1, dur=0.04;

var grain;


grain= PlayBuf.ar(1,bufnum, BufRateScale.kr(bufnum), 1, BufFrames.ir(bufnum)*startPos, 0)*(EnvGen.kr(Env.perc(0.01,dur),doneAction:2)-0.001);


Out.ar(0,Pan2.ar(grain, pan))}).add;

)



b = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav");



//individual grain

Synth(\sfgrain,[\bufnum, b.bufnum, \startPos,rrand(0.0,1.0),\amp, exprand(0.005,0.1), \pan, 1.0.rand2]);



//schedule 200 random soundfile playback grains over time, with random offset positions into the soundfile and lowering the density over time

(

{

200.do{arg i;

var timeprop = (i/199.0)**3;


	Synth(\sfgrain,[\bufnum, b.bufnum, \startPos,rrand(0.0,timeprop),\amp, exprand(0.005,0.1), \pan, 1.0.rand2]);

	rrand((timeprop*0.1).max(0.01),timeprop*0.4).wait

};

}.fork

)











(

var w, slid, lastval;

lastval=0.0;


w=Window("My Window", Rect(100,500,200,200));

//A 200 by 200 window appears at screen co-ordinates (100, 500)


slid=Slider(w,Rect(10,10,150,40)); //a basic slider object


slid.action_({lastval= slid.value;}); //this is the callback- the function is called whenever you move the slider


{

inf.do{arg i;


var prop, timestart, timeend;


prop= (i%300)/300;


timestart= prop*0.8;

timeend= prop*(0.8+(0.1*lastval));


	Synth(\sfgrain,[\bufnum, b.bufnum, \startPos,rrand(timestart,timeend),\amp, exprand(0.005,0.1), \pan, lastval.rand2, \dur, 0.1+(lastval*0.5)]);

	//max in this to avoid ever going near 0.0 wait time, which would crash the computer!

	(((lastval*0.2)+0.01).max(0.01)).wait

};

}.fork;



w.front;

)

































//In this example code, a sound file can be made to loop at any selection in the graphical display



//load soundfile onto Server

b = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav");



//SynthDef (making Synth straight away) which has arguments for the loop points

c= SynthDef(\loopbuffer, {arg start=0, end=10000; Out.ar(0,Pan2.ar(BufRd.ar(1, 0, Phasor.ar(0, BufRateScale.kr(b.bufnum), start, end),0.0)))}).play(s);

//*BufFrames.ir(b.bufnum) //this isn't needed since the GUI gives us positions directly in samples




(		// make a simple SCSoundFileView

w = Window("soundfiles looper", Rect(10, 700, 750, 100));

w.front;

a = SoundFileView(w, Rect(20,20, 700, 60));


f = SoundFile.new;

f.openRead(Platform.resourceDir +/+ "sounds/a11wlk01.wav");


a.soundfile = f;				// set soundfile

a.read(0, f.numFrames);		// read in the entire file.

a.refresh;							// refresh to display the file.


//set a function which is called when the mouse is let go, i.e. just after dragging out a selection in the window

a.mouseUpAction_({arg view;

	var where;



	where= (view.selections[0]); //get the latest selection (assuming no other selections going on)



	where.postln; //post where - start sample and length in samples of selection



	c.set(\start, where[0], \end, where[0]+where[1]); //convert to start and end samples for loop area

});

)






