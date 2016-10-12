#ifndef NOTES_H
#define NOTES_H

#define sampleRate	7*1000000
#define tone(x) (sampleRate/x)

#define C5 		tone(523)
#define B4		tone(494)
#define Bb4		tone(466)
#define A4		tone(440)
#define Ab4		tone(415)
#define G4		tone(392)
#define Gb4		tone(370)
#define F4		tone(349)
#define E4		tone(330)
#define Eb4		tone(311)
#define D4		tone(294)
#define Db4		tone(277)
#define C4		tone(262)
#define R		tone(0)

static int notesFreqs[8]={C5,B4,A4,G4,F4,D4,C4,E4};



//struct melody1 {
//        int note[3];// = {C5,B4,A4};
//	int note_length[3];// = {0.1,0.2,2};
//	int songlength;// = 3;
//}

#endif
