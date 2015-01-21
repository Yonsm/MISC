//
//  main.m
//  AATest
//
//  Created by 郭春杨 on 14/12/10.
//  Copyright (c) 2014年 Yonsm.NET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


int main(int argc, char * argv[]) {
	@autoreleasepool {
		return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
}



// ****** 需要重构---->

#define BYTE1(x) x
#define BYTE3(x) x

#define LOWORD(x) x
#define LOBYTE(x) x
#define HIWORD(x) x
#define QWORD(x) x
#define DWORD(x) x
#define HIDWORD(x) x
#define LODWORD(x) x

int dword_40F88;
int *off_3EE10;

//<--- ****** 需要重构

#define __int64 long long
#define __int8 char
#define __int16 short
#define _BYTE unsigned char
#define _DWORD int
#define _QWORD unsigned long long


#include<mach/mach_init.h>
#include<mach/mach_traps.h>

char * sub_2F6F8(int a1)
{
	unsigned int v1; // r1@1

	v1 = -778836537 * (a1 ^ 0xAA244BF7) % 6;
	return *(char **)((char *)&off_3EE10
					  + 4 * (-1440461833 * (a1 ^ 0x85B860CD) % 6 - v1)
					  + 4 * v1
					  + ((((unsigned int)(&off_3EE10 + v1) ^ 0xF2FDF07)
						  + 2 * ((unsigned int)(&off_3EE10 + v1) & 0x72FDF07)
						  + 13639929) & 0xFFFFFFF)
					  - ((((unsigned int)(&off_3EE10 + v1) ^ 0x4889E9C)
						  + 2 * ((unsigned int)(&off_3EE10 + v1) & 0x4889E9C)
						  + 460808548) & 0xFFFFFFF))
	- (((unsigned __int8)(-57 * (-1440461833 * (a1 ^ 0x85B860CD) % 6) - 51) | 2) & 0xE);
}


char *__fastcall sub_2F594(int a1)
{
	unsigned int v1; // r1@1

	v1 = -778836537 * (a1 ^ 0xAA244BF7) % 6;
	return *(char **)((char *)&off_3EE10
					  + 4 * (-1440461833 * (a1 ^ 0x85B860CD) % 6 - v1)
					  + 4 * v1
					  + ((((unsigned int)(&off_3EE10 + v1) ^ 0x8E330)
						  + 2 * ((unsigned int)(&off_3EE10 + v1) & 0xE330)
						  + 1514704) & 0xFFFFF)
					  - ((((unsigned int)(&off_3EE10 + v1) ^ 0x7F135)
						  + 2 * ((unsigned int)(&off_3EE10 + v1) & 0x7F135)
						  + 528075) & 0xFFFFF))
	- (((unsigned __int8)(-57 * (-1440461833 * (a1 ^ 0x85B860CD) % 6) - 51) | 2) & 0xE);
}

char * sub_2F4E0(int a1)
{
	unsigned int v1; // r1@1

	v1 = -778836537 * (a1 ^ 0xAA244BF7) % 6;
	return *(char **)((char *)&off_3EE10
					  + 4 * (-1440461833 * (a1 ^ 0x85B860CD) % 6 - v1)
					  + 4 * v1
					  + ((((unsigned int)(&off_3EE10 + v1) ^ 0x14367)
						  + 2 * ((unsigned int)(&off_3EE10 + v1) & 0x4367)
						  + 48281) & 0x1FFFF)
					  - ((((unsigned int)(&off_3EE10 + v1) ^ 0x11F99)
						  + 2 * ((unsigned int)(&off_3EE10 + v1) & 0x1F99)
						  + 57447) & 0x1FFFF))
	- (((unsigned __int8)(-57 * (-1440461833 * (a1 ^ 0x85B860CD) % 6) - 51) | 2) & 0xE);
}

int  sub_2F64C(int a1)
{
	unsigned int v1; // r1@1
	void **v2; // r2@1

	v1 = -778836537 * (a1 ^ 0xAA244BF7) % 6;
	v2 = &off_3EE10 + v1;
	return (int)(*(char **)((char *)&v2[-1440461833 * (a1 ^ 0x85B860CD) % 6 - v1]
							+ ((((unsigned __int16)v2 ^ 0x1FE1) + 2 * ((unsigned __int16)v2 & 0x1FE1) + 8223) & 0x3FFF)
							- ((((unsigned __int16)v2 ^ 0x3DBA) + 2 * ((unsigned __int16)v2 & 0x1DBA) + 16966) & 0x3FFF))
				 - (((unsigned __int8)(-57 * (-1440461833 * (a1 ^ 0x85B860CD) % 6) - 51) | 2) & 0xE));
}

unsigned long _byteswap_ulong(unsigned long x)
{
	return x;
}

int  sub_2F444(int a1)
{
	unsigned int v1; // r1@1
	void **v2; // r2@1

	v1 = -778836537 * (a1 ^ 0xAA244BF7) % 6;
	v2 = &off_3EE10 + v1;
	return (int)(*(char **)((char *)&v2[-1440461833 * (a1 ^ 0x85B860CD) % 6 - v1]
							+ ((((unsigned __int8)v2 ^ 5) + 2 * ((unsigned __int8)v2 & 5) + 123) & 0x3F)
							- ((((unsigned __int8)v2 ^ 0x33) + 2 * ((unsigned __int8)v2 & 0x13) + 77) & 0x3F))
				 - (((unsigned __int8)(-57 * (-1440461833 * (a1 ^ 0x85B860CD) % 6) - 51) | 2) & 0xE));
}

int qi864985u0(unsigned int a1, unsigned int a2, mach_port_t *a3, int a4, int a5, int a6)
{
	mach_port_t v6; // r4@1
	signed int v7; // r0@1
	signed int v8; // r1@1
	signed int v9; // r2@3
	int v10; // r1@5
	signed int v11; // r2@5
	int v12; // r1@7
	int v13; // r0@9
	int v14; // r1@9
	int v15; // r2@9
	int v16; // r3@9
	signed int v17; // r1@13
	int v18; // r3@20
	int v19; // r0@22
	int *v20; // r2@24
	int v21; // r0@24
	int v22; // r1@24
	int v23; // r3@26
	int v24; // r2@26
	int v25; // r6@26
	char v26; // r2@29
	__int64 v27; // r0@29
	int v28; // r0@32
	int v29; // r0@32
	int *v30; // r2@32
	int v31; // r1@32
	int v32; // r2@34
	int v33; // r5@34
	int *v34; // r6@36
	int *v35; // r2@37
	int *v36; // r5@41
	char v37; // r2@45
	int *v38; // r2@48
	int v39; // r6@48
	int v40; // r3@50
	int v41; // r2@50
	int v42; // r5@50
	int *v43; // r6@50
	int v44; // r0@54
	int *v45; // r2@54
	int v46; // r0@59
	int *v47; // r2@59
	int v48; // r0@64
	int *v49; // r2@64
	int *v50; // r1@69
	mach_port_t v51; // r0@69
	int v52; // r2@71
	int v53; // r1@71
	int v54; // r3@71
	int *v55; // r6@73
	int v56; // r0@75
	int *v57; // r0@75
	int v58; // r1@77
	int v59; // r0@77
	int v60; // r3@77
	int *v61; // r2@79
	int v62; // r6@79
	int v63; // r0@83
	int *v64; // r2@83
	int v65; // r5@85
	int v66; // r0@88
	int *v67; // r2@88
	signed int v68; // r0@94
	int *v69; // r2@97
	__int64 v70; // r0@97
	int v71; // r3@99
	int v72; // r2@99
	int v73; // r5@99
	int *v74; // r6@101
	int v75; // r0@102
	int *v76; // r1@102
	int v77; // r2@104
	int v78; // r1@104
	int v79; // r6@104
	int *v80; // r3@106
	int v81; // r3@107
	int v82; // r0@107
	int *v83; // r1@107
	int v84; // r2@109
	int v85; // r1@109
	int v86; // r0@110
	int v87; // r0@110
	int *v88; // r1@110
	int v89; // r2@112
	int v90; // r6@112
	int *v91; // r3@114
	int *v92; // r1@115
	int v93; // r0@115
	int v94; // r2@117
	int v95; // r6@117
	int *v96; // r3@119
	int *v97; // r2@120
	int *v98; // r1@126
	bool v99; // zf@131
	int *v100; // r1@134
	int v101; // r3@137
	int v102; // r5@137
	int *v103; // r6@139
	bool v104; // zf@139
	int v105; // r0@144
	int *v106; // r1@144
	int *v107; // r1@149
	int v108; // r0@154
	int *v109; // r1@154
	bool v110; // zf@154
	signed int v111; // r0@154
	int v112; // r0@158
	int v113; // r2@160
	int v114; // r6@160
	int *v115; // r3@162
	int v116; // r6@162
	int v117; // r0@165
	int *v118; // r1@165
	int v119; // r2@167
	int v120; // r6@167
	int v121; // r6@169
	signed int v122; // r5@169
	int *v123; // r1@170
	int v124; // r6@172
	signed int v125; // r5@174
	int *v126; // r1@175
	int *v127; // r1@180
	int v128; // r0@185
	signed int v129; // r0@185
	signed int v130; // r1@185
	int v131; // r0@187
	int v132; // r2@188
	int v133; // r1@188
	int *v134; // r3@188
	int v135; // r0@188
	int v136; // r0@189
	int v137; // r1@189
	int *v138; // r1@191
	int v139; // r2@193
	int v140; // r6@193
	int *v141; // r3@195
	int v142; // r6@195
	int v143; // r1@198
	__int64 v144; // r0@198
	int *v145; // r2@198
	int v146; // r3@200
	int v147; // r2@200
	int v148; // r5@200
	int *v149; // r6@202
	signed int v150; // r5@202
	int *v151; // r1@203
	int v152; // r2@208
	int *v153; // r1@208
	int *v154; // r1@213
	int v155; // r2@218
	int *v156; // r1@218
	int *v157; // r1@223
	int v158; // r6@225
	int *v159; // r1@228
	int v160; // r5@234
	int v161; // r1@237
	int *v162; // r2@237
	int v163; // r0@237
	signed int v164; // r3@237
	int v165; // r0@238
	int *v166; // r1@240
	int v167; // r5@245
	int v168; // r0@246
	int *v169; // r1@246
	int v170; // r2@248
	int v171; // r3@248
	int v172; // r5@248
	int *v173; // r6@250
	char v174; // r4@253
	int v175; // r0@253
	int *v176; // r1@253
	bool v177; // zf@253
	signed int v178; // r0@253
	int v179; // r0@257
	int v180; // r2@259
	int v181; // r1@259
	int v182; // r6@259
	int *v183; // r3@261
	int v184; // r6@261
	int v185; // r5@261
	int v186; // r4@262
	int v187; // r0@262
	int v188; // r0@262
	int v189; // r2@262
	int *v190; // r1@263
	int v191; // r4@269
	int v192; // r0@269
	int *v193; // r1@270
	int v194; // r5@275
	int v195; // r0@277
	int *v196; // r2@277
	signed int v197; // r3@277
	int v198; // r4@278
	int v199; // r0@278
	int *v200; // r3@278
	int v201; // r0@278
	mach_port_t v202; // r4@279
	int v203; // r0@279
	int v204; // r0@279
	int *v205; // r1@279
	int v206; // r2@281
	int v207; // r3@281
	int *v208; // r0@283
	signed int v209; // r0@285
	signed int v210; // r1@285
	int *v211; // r2@285
	int v212; // r4@286
	int v213; // r0@286
	int *v214; // r1@286
	int v215; // r6@288
	int v216; // r0@295
	int *v217; // r1@295
	int v218; // r0@295
	int v219; // r2@297
	int v220; // r6@297
	int *v221; // r3@299
	int v222; // r6@299
	int v223; // r4@302
	int v224; // r0@302
	int v225; // r0@302
	int *v226; // r1@302
	int v227; // r2@304
	int v228; // r6@304
	int *v229; // r3@306
	int v230; // r6@306
	int v231; // r4@309
	int v232; // r0@309
	int *v233; // r3@310
	int v234; // r4@312
	int v235; // r0@312
	unsigned int v236; // r4@313
	int v237; // r0@313
	int *v238; // r0@313
	int v239; // r1@315
	int v240; // r0@315
	int v241; // r3@315
	int *v242; // r2@317
	int v243; // r6@317
	int v244; // r4@320
	int v245; // r0@320
	int v246; // r4@321
	int v247; // r0@321
	int v248; // r5@325
	int v249; // r3@326
	int v250; // r0@330
	int v251; // r0@330
	int *v252; // r2@330
	int v253; // r1@330
	int v254; // r2@332
	int *v255; // r6@334
	int *v256; // r2@335
	int v257; // r5@335
	int v258; // r0@335
	int v259; // r1@335
	int v260; // r3@337
	int v261; // r2@337
	char v262; // r2@338
	__int64 v263; // r0@338
	int v264; // r0@341
	int *v265; // r2@341
	int *v266; // r2@346
	int v267; // r6@349
	int *v268; // r5@351
	char v269; // r2@355
	unsigned int v270; // r0@358
	unsigned int v271; // r1@358
	int *v272; // r2@358
	int v273; // r3@360
	int v274; // r2@360
	int v275; // r5@360
	int *v276; // r6@362
	int v277; // r5@362
	int v278; // r1@366
	int v279; // r0@366
	int v280; // r2@366
	int v281; // r3@366
	int *v282; // r6@366
	int *v283; // r5@368
	int v284; // r6@368
	char v285; // r2@372
	int *v286; // r2@375
	int v287; // r6@375
	int v288; // r3@377
	int v289; // r2@377
	int v290; // r5@377
	int *v291; // r6@377
	int *v292; // r1@381
	int v293; // r6@383
	int *v294; // r1@390
	int v295; // r6@392
	int *v296; // r1@396
	int v297; // r0@396
	int v298; // r2@398
	int v299; // r6@398
	int *v300; // r2@401
	int v301; // r5@403
	int v302; // r4@405
	int v303; // r0@406
	int *v304; // r1@406
	int v305; // r2@408
	int v306; // r6@408
	int *v307; // r3@410
	int *v308; // r1@411
	int *v309; // r2@419
	int v310; // r5@421
	int *v311; // r1@429
	int v312; // r0@434
	int *v313; // r1@434
	int *v314; // r3@439
	int v315; // r0@439
	int *v316; // r1@442
	char v317; // r2@447
	int *v318; // r1@450
	int *v319; // r1@455
	char v320; // r2@467
	int v321; // r0@470
	int *v322; // r1@470
	int v323; // r2@472
	int v324; // r3@472
	int *v325; // r6@474
	char v326; // r2@477
	int *v327; // r2@480
	int v328; // r6@480
	int v329; // r5@482
	int *v330; // r1@487
	int *v331; // r1@498
	int v332; // r2@500
	int v333; // r3@500
	int *v334; // r6@502
	int *v335; // r1@503
	int v336; // r0@508
	int v337; // r0@508
	int *v338; // r1@508
	int v339; // r2@510
	int v340; // r1@510
	int v341; // r3@510
	int v342; // r5@510
	int *v343; // r6@512
	int v344; // r0@515
	int *v345; // r0@515
	int v346; // r0@517
	int v347; // r2@517
	int v348; // r1@517
	int *v349; // r3@519
	int v350; // r3@520
	int *v351; // r1@520
	int v352; // r0@520
	int v353; // r2@522
	int v354; // r0@524
	int v355; // r0@524
	int *v356; // r1@524
	int v357; // r2@526
	int v358; // r1@526
	int v359; // r6@526
	int *v360; // r3@528
	int v361; // r6@528
	int v362; // r0@531
	int v363; // r1@531
	int v364; // r0@531
	int *v365; // r1@532
	int v366; // r0@532
	int v367; // r2@534
	int v368; // r1@534
	int v369; // r6@534
	int *v370; // r3@536
	int *v371; // r1@537
	int v372; // r5@540
	int v373; // r0@547
	int v374; // r0@547
	int *v375; // r1@547
	int v376; // r2@549
	int v377; // r6@549
	int v378; // r0@554
	int *v379; // r1@555
	unsigned int v380; // r0@560
	int v381; // r4@560
	int v382; // r6@560
	int v383; // r8@560
	int v384; // r0@560
	int v385; // r0@560
	int *v386; // r2@560
	int v387; // r3@562
	int v388; // r2@562
	int v389; // r6@562
	int *v390; // r5@564
	int v391; // r8@567
	int v392; // ST0C_4@567
	int v393; // r6@567
	int v394; // r5@567
	int v395; // r0@568
	int v396; // r2@568
	int *v397; // r1@569
	int *v398; // r1@574
	int v399; // r0@579
	int v400; // r8@580
	unsigned int v401; // r5@580
	int v402; // r6@580
	int v403; // r0@580
	int v404; // r0@583
	int *v405; // r1@583
	int v406; // r2@585
	int v407; // r6@585
	unsigned int v408; // r0@590
	int *v409; // r1@590
	unsigned int v410; // r0@590
	int v411; // r2@592
	int v412; // r1@595
	int v413; // r1@595
	unsigned int v414; // r0@595
	int *v415; // r2@595
	int v416; // r3@597
	int v417; // r2@597
	int *v418; // r6@597
	int v419; // r5@597
	int v420; // r1@600
	int v421; // r1@600
	int *v422; // r2@600
	unsigned int v423; // r0@600
	int v424; // r3@602
	int v425; // r1@605
	int v426; // r1@605
	unsigned int v427; // r0@605
	int *v428; // r2@605
	int v429; // r3@607
	int v430; // r1@610
	int v431; // r2@610
	int v432; // r1@610
	unsigned int v433; // r0@610
	int v434; // r3@610
	int *v435; // r6@612
	int *v436; // r5@614
	int v437; // r6@614
	int v438; // r3@614
	int *v439; // r1@617
	int v440; // r0@617
	int v441; // r2@619
	int v442; // r6@619
	int *v443; // r1@624
	int v444; // r5@629
	int v445; // r0@632
	int v446; // r0@633
	int v447; // r0@638
	int *v448; // r2@639
	unsigned int v450; // [sp+10h] [bp-24Ch]@1
	unsigned int v451; // [sp+18h] [bp-244h]@1
	int v452; // [sp+1Ch] [bp-240h]@1
	mach_port_t *v453; // [sp+20h] [bp-23Ch]@1
	int v454; // [sp+24h] [bp-238h]@1
	int *v455; // [sp+28h] [bp-234h]@1
	int *v456; // [sp+2Ch] [bp-230h]@1
	int *v457; // [sp+30h] [bp-22Ch]@1
	int v458; // [sp+34h] [bp-228h]@1
	int v459; // [sp+38h] [bp-224h]@64
	unsigned int v460; // [sp+3Ch] [bp-220h]@1
	int v461; // [sp+40h] [bp-21Ch]@29
	unsigned int v462; // [sp+44h] [bp-218h]@309
	int v463; // [sp+48h] [bp-214h]@64
	int v464; // [sp+4Ch] [bp-210h]@1
	int v465; // [sp+50h] [bp-20Ch]@154
	int v466; // [sp+54h] [bp-208h]@45
	int v467; // [sp+58h] [bp-204h]@59
	int v468; // [sp+5Ch] [bp-200h]@54
	int v469; // [sp+60h] [bp-1FCh]@83
	int v470; // [sp+64h] [bp-1F8h]@54
	int v471; // [sp+68h] [bp-1F4h]@144
	int v472; // [sp+6Ch] [bp-1F0h]@32
	int v473; // [sp+70h] [bp-1ECh]@1
	int v474; // [sp+74h] [bp-1E8h]@88
	int v475; // [sp+78h] [bp-1E4h]@523
	int v476; // [sp+7Ch] [bp-1E0h]@24
	unsigned int v477; // [sp+80h] [bp-1DCh]@1
	int v478; // [sp+84h] [bp-1D8h]@110
	int v479; // [sp+88h] [bp-1D4h]@59
	int v480; // [sp+8Ch] [bp-1D0h]@83
	int v481; // [sp+90h] [bp-1CCh]@447
	int v482; // [sp+94h] [bp-1C8h]@545
	int v483; // [sp+98h] [bp-1C4h]@32
	unsigned int v484; // [sp+9Ch] [bp-1C0h]@1
	int v485; // [sp+A0h] [bp-1BCh]@110
	int v486; // [sp+A4h] [bp-1B8h]@143
	int v487; // [sp+A8h] [bp-1B4h]@1
	int v488; // [sp+ACh] [bp-1B0h]@1
	int v489; // [sp+B0h] [bp-1ACh]@189
	int v490; // [sp+B4h] [bp-1A8h]@45
	int v491; // [sp+B8h] [bp-1A4h]@29
	int v492; // [sp+BCh] [bp-1A0h]@295
	int v493; // [sp+C0h] [bp-19Ch]@295
	int v494; // [sp+C4h] [bp-198h]@94
	int v495; // [sp+C8h] [bp-194h]@37
	int v496; // [sp+CCh] [bp-190h]@88
	int v497; // [sp+D0h] [bp-18Ch]@263
	int v498; // [sp+D4h] [bp-188h]@102
	int v499; // [sp+D8h] [bp-184h]@32
	int v500; // [sp+DCh] [bp-180h]@115
	int v501; // [sp+E0h] [bp-17Ch]@270
	int v502; // [sp+E4h] [bp-178h]@126
	int v503; // [sp+E8h] [bp-174h]@54
	int v504; // [sp+ECh] [bp-170h]@149
	int v505; // [sp+F0h] [bp-16Ch]@284
	unsigned int v506; // [sp+F4h] [bp-168h]@284
	int v507; // [sp+F8h] [bp-164h]@286
	int v508; // [sp+FCh] [bp-160h]@59
	int v509; // [sp+100h] [bp-15Ch]@175
	unsigned int v510; // [sp+104h] [bp-158h]@309
	int v511; // [sp+108h] [bp-154h]@309
	int v512; // [sp+10Ch] [bp-150h]@64
	int v513; // [sp+110h] [bp-14Ch]@180
	int v514; // [sp+114h] [bp-148h]@295
	int v515; // [sp+118h] [bp-144h]@286
	int v516; // [sp+11Ch] [bp-140h]@187
	int v517; // [sp+120h] [bp-13Ch]@83
	int v518; // [sp+124h] [bp-138h]@223
	int v519; // [sp+128h] [bp-134h]@88
	int v520; // [sp+12Ch] [bp-130h]@228
	unsigned int v521; // [sp+130h] [bp-12Ch]@75
	unsigned int v522; // [sp+134h] [bp-128h]@110
	int v523; // [sp+138h] [bp-124h]@1
	int v524; // [sp+13Ch] [bp-120h]@253
	int v525; // [sp+140h] [bp-11Ch]@253
	unsigned __int8 v526; // [sp+144h] [bp-118h]@255
	int v527; // [sp+148h] [bp-114h]@94
	int v528; // [sp+14Ch] [bp-110h]@262
	int v529; // [sp+150h] [bp-10Ch]@24
	int v530; // [sp+154h] [bp-108h]@29
	int v531; // [sp+158h] [bp-104h]@29
	unsigned __int8 v532; // [sp+15Ch] [bp-100h]@31
	int v533; // [sp+160h] [bp-FCh]@107
	int v534; // [sp+164h] [bp-F8h]@110
	int v535; // [sp+168h] [bp-F4h]@32
	unsigned __int8 v536; // [sp+16Ch] [bp-F0h]@115
	int v537; // [sp+170h] [bp-ECh]@37
	int v538; // [sp+174h] [bp-E8h]@45
	int v539; // [sp+178h] [bp-E4h]@45
	unsigned __int8 v540; // [sp+17Ch] [bp-E0h]@47
	int v541; // [sp+180h] [bp-DCh]@134
	int v542; // [sp+184h] [bp-D8h]@144
	int v543; // [sp+188h] [bp-D4h]@54
	int v544; // [sp+18Ch] [bp-D0h]@149
	int v545; // [sp+190h] [bp-CCh]@560
	int v546; // [sp+194h] [bp-C8h]@279
	unsigned int v547; // [sp+198h] [bp-C4h]@185
	int v548; // [sp+19Ch] [bp-C0h]@185
	int v549; // [sp+1A0h] [bp-BCh]@154
	int v550; // [sp+1A4h] [bp-B8h]@154
	unsigned __int8 v551; // [sp+1A8h] [bp-B4h]@156
	int v552; // [sp+1ACh] [bp-B0h]@158
	mach_port_t *v553; // [sp+1B0h] [bp-ACh]@170
	int v554; // [sp+1B4h] [bp-A8h]@295
	unsigned int v555; // [sp+1B8h] [bp-A4h]@358
	int v556; // [sp+1BCh] [bp-A0h]@302
	int v557; // [sp+1C0h] [bp-9Ch]@59
	unsigned __int8 v558; // [sp+1C4h] [bp-98h]@175
	int v559; // [sp+1C8h] [bp-94h]@311
	int v560; // [sp+1CCh] [bp-90h]@64
	unsigned __int8 v561; // [sp+1D0h] [bp-8Ch]@180
	int v562; // [sp+1D4h] [bp-88h]@312
	int v563; // [sp+1D8h] [bp-84h]@69
	mach_port_t *v564; // [sp+1DCh] [bp-80h]@69
	int v565; // [sp+1E0h] [bp-7Ch]@198
	int v566; // [sp+1E4h] [bp-78h]@198
	int v567; // [sp+1E8h] [bp-74h]@203
	int v568; // [sp+1ECh] [bp-70h]@208
	int v569; // [sp+1F0h] [bp-6Ch]@208
	unsigned int v570; // [sp+1F4h] [bp-68h]@208
	int v571; // [sp+1F8h] [bp-64h]@213
	int v572; // [sp+1FCh] [bp-60h]@213
	int v573; // [sp+200h] [bp-5Ch]@218
	int v574; // [sp+204h] [bp-58h]@75
	unsigned int v575; // [sp+208h] [bp-54h]@75
	int v576; // [sp+20Ch] [bp-50h]@75
	int v577; // [sp+210h] [bp-4Ch]@83
	unsigned __int8 v578; // [sp+214h] [bp-48h]@223
	int v579; // [sp+218h] [bp-44h]@88
	unsigned __int8 v580; // [sp+21Ch] [bp-40h]@228
	unsigned int v581; // [sp+220h] [bp-3Ch]@240
	mach_port_t v582; // [sp+224h] [bp-38h]@240
	mach_port_t v583; // [sp+228h] [bp-34h]@320
	int v584; // [sp+22Ch] [bp-30h]@246
	mach_port_t v585; // [sp+230h] [bp-2Ch]@246
	mach_port_t v586; // [sp+234h] [bp-28h]@321
	int v587; // [sp+238h] [bp-24h]@185
	int *v588; // [sp+23Ch] [bp-20h]@185
	//int v589; // [sp+240h] [bp-1Ch]@1

	v451 = a2;
	v452 = a4;
	v453 = a3;
	v450 = a1;
	v6 = (mach_port_t)&v454;
	//v589 = __stack_chk_guard;
	v477 = 503603150;
	v7 = 0;
	v458 = (int)&v458;
	v457 = (int *)&v457;
	v473 = 0;
	v487 = 0;
	v488 = 0;
	v460 = 0;
	v464 = 0;
	v484 = 0;
	v523 = 503558149;
	v454 = 2071551820;
	v455 = (int *)&v457;
	v456 = &v458;
	v8 = 0;
	if ( !a4 )
		v8 = 1;
	v99 = a3 == 0;
	v9 = 0;
	if ( v99 )
		v9 = 1;
	v10 = v8 | v9;
	v11 = 0;
	if ( !a5 )
		v11 = 1;
	v12 = v10 | v11;
	LOWORD(v11) = -24396;
	if ( !a6 )
		v7 = 1;
	HIWORD(v11) = -31610;
	v13 = v7 | v12;
	v14 = v454;
	v15 = v11 + v454;
	v16 = v15;
	if ( !v13 )
		v16 = v454 - 1382812347;
	*v456 = v16;
	if ( !v13 )
		v15 = v14 - 1382812407;
	v17 = 978584680;
	v457 = (int *)v15;
	if ( v13 )
		v17 = 688739473;
LABEL_17:
	v454 = v17;
	if ( !v13 )
	{
		while ( 1 )
		{
			do
				def_2E3E0:
				v6 = -978584680;
			while ( (unsigned int)(v454 - 978584680) > 0x3E );
			switch ( v454 )
			{
				case 978584688:
					v250 = v497;
					*(_BYTE *)(v491 + v497) = *(_BYTE *)(v461 + v497);
					v251 = v250 + 1;
					v252 = (int *)&v457;
					v253 = v531;
					v497 = v251;
					if ( v251 == v531 )
						v252 = &v458;
					v249 = v454;
					v254 = *v252;
					v248 = v454 + 1;
					if ( v251 == v531 )
						v248 = v454 - 289845266;
					v255 = v455;
					*v456 = v248;
					LOWORD(v248) = -1136;
					goto LABEL_325;
				case 978584691:
					v256 = (int *)&v457;
					LOWORD(v257) = 20508;
					v258 = 2 * v485;
					v485 = v258;
					v259 = *(_DWORD *)(v533 + 4) + 4;
					if ( v258 > (unsigned int)v259 )
						v256 = &v458;
					v260 = v454;
					v261 = *v256;
					goto LABEL_349;
				case 978584692:
					v262 = 0;
					v263 = *(_QWORD *)v533;
					v535 = *(_QWORD *)v533 >> 32;
					v472 = v263;
					v483 = v534;
					if ( !v535 )
						v262 = 1;
					HIDWORD(v263) = v534;
					v536 = v262;
					goto LABEL_375;
				case 978584699:
					v264 = v501;
					*(_BYTE *)(v490 + v501) = *(_BYTE *)(v466 + v501);
					v251 = v264 + 1;
					v265 = (int *)&v457;
					v253 = v539;
					v501 = v251;
					if ( v251 == v539 )
						v265 = &v458;
					v249 = v454;
					v254 = *v265;
					v248 = v454 + 1;
					if ( v251 == v539 )
						v248 = v454 - 289845266;
					v255 = v455;
					*v456 = v248;
					LOWORD(v248) = -1147;
				LABEL_325:
					HIWORD(v248) = -14933;
					if ( v251 == v253 )
						v249 += v248;
					*v255 = v249;
					v454 = v254;
					goto def_2E3E0;
				case 978584702:
					v266 = (int *)&v457;
					LOWORD(v257) = 20497;
					v258 = 2 * v486;
					v486 = v258;
					v259 = *(_DWORD *)(v541 + 4) + 8;
					if ( v258 > (unsigned int)v259 )
						v266 = &v458;
					v260 = v454;
					v261 = *v266;
				LABEL_349:
					HIWORD(v257) = -4423;
					v267 = v260 - 289845267;
					if ( v258 > (unsigned int)v259 )
						v267 = v260 + v257;
					v6 = (mach_port_t)v456;
					v268 = v455;
					*v456 = v267;
					if ( v258 > (unsigned int)v259 )
						++v260;
					*v268 = v260;
					v454 = v261;
					if ( v258 > (unsigned int)v259 )
						goto def_2D45C;
					goto def_2E3E0;
				case 978584703:
					v269 = 0;
					v263 = *(_QWORD *)v541;
					v543 = *(_QWORD *)v541 >> 32;
					v468 = v263;
					v470 = v542;
					if ( !v543 )
						v269 = 1;
					HIDWORD(v263) = v542;
					LOBYTE(v544) = v269;
					goto LABEL_375;
				case 978584712:
					v554 = v507;
					v270 = v462;
					v555 = v462;
					v271 = *(_DWORD *)(v507 + 4);
					v511 = v552;
					v272 = (int *)&v457;
					v510 = v462;
					if ( v462 > v271 )
						v272 = &v458;
					v273 = v454;
					v274 = *v272;
					v275 = v454 + 6;
					if ( v462 > v271 )
						v275 = v454 + 8;
					v6 = (mach_port_t)v456;
					v276 = v455;
					*v456 = v275;
					v277 = v273 - 289845262;
					if ( v270 > v271 )
						v277 = v273 + 1;
					*v276 = v277;
					v454 = v274;
					if ( v270 <= v271 )
						goto def_2E3E0;
					goto def_2D45C;
				case 978584713:
					v278 = 2 * v492;
					v279 = v454;
					v492 = v278;
					v280 = v454 - 289845267;
					v281 = *(_DWORD *)(v554 + 4) + v555;
					v282 = (int *)&v457;
					if ( v278 > (unsigned int)v281 )
					{
						v280 = v454 + 7;
						v282 = &v458;
					}
					v6 = (mach_port_t)v456;
					v283 = v455;
					v284 = *v282;
					*v456 = v280;
					if ( v278 > (unsigned int)v281 )
						++v279;
					*v283 = v279;
					v454 = v284;
					if ( v278 <= (unsigned int)v281 )
						goto def_2E3E0;
					goto def_2D45C;
				case 978584714:
					v285 = 0;
					v263 = *(_QWORD *)v554;
					v557 = *(_QWORD *)v554 >> 32;
					v479 = v263;
					v467 = v556;
					if ( !v557 )
						v285 = 1;
					HIDWORD(v263) = v556;
					v558 = v285;
				LABEL_375:
					v286 = (int *)&v457;
					LOWORD(v287) = 20463;
					if ( (unsigned int)v263 > HIDWORD(v263) )
						v286 = &v458;
					v288 = v454;
					HIWORD(v287) = -4423;
					v289 = *v286;
					v290 = v454 + v287;
					v291 = v455;
					*v456 = v290;
					v6 = v288 + 2;
					if ( (unsigned int)v263 > HIDWORD(v263) )
						v6 = v288 - 289845266;
					*v291 = v6;
					v454 = v289;
					if ( (unsigned int)v263 <= HIDWORD(v263) )
						goto def_2D45C;
					goto def_2E3E0;
				case 978584681:
					v87 = v525;
					v292 = (int *)&v457;
					if ( !v525 )
						v292 = &v458;
					v89 = v454;
					v85 = *v292;
					v293 = v454 + 2;
					if ( !v525 )
						v293 = v454 - 289845208;
					v91 = v455;
					*v456 = v293;
					v90 = -978584681;
					v125 = -289845266;
					goto LABEL_386;
				case 978584682:
					v294 = (int *)&v457;
					v528 = v525;
					v117 = *(_DWORD *)v525;
					if ( !*(_DWORD *)v525 )
						v294 = &v458;
					v119 = v454;
					v78 = *v294;
					v295 = v454 + 1;
					if ( !v117 )
						v295 = v454 - 289845209;
					v96 = v455;
					*v456 = v295;
					v121 = -289845266;
					v122 = -978584682;
					goto LABEL_395;
				case 978584687:
					v296 = (int *)&v457;
					v498 = v531;
					v297 = v532;
					if ( v532 )
						v296 = &v458;
					v298 = v454;
					v85 = *v296;
					v299 = v454 + 2;
					if ( v532 )
						v299 = v454 - 289845265;
					v91 = v455;
					*v456 = v299;
					LOWORD(v299) = -1135;
					goto LABEL_416;
				case 978584690:
					v300 = (int *)&v457;
					v144 = *(_QWORD *)(v533 + 4);
					HIDWORD(v144) += 4;
					if ( HIDWORD(v144) > (unsigned int)v144 )
						v300 = &v458;
					v146 = v454;
					v147 = *v300;
					v301 = v454 - 289845217;
					if ( HIDWORD(v144) > (unsigned int)v144 )
						v301 = v454 + 1;
					v149 = v455;
					*v456 = v301;
					v150 = -978584690;
					LOWORD(v302) = 20466;
					goto LABEL_424;
				case 978584694:
					v303 = v500 - 1;
					v99 = v500 == 1;
					*(_BYTE *)(v483 + v303) = *(_BYTE *)(v472 + v500 - 1);
					v304 = (int *)&v457;
					v500 = v303;
					if ( v99 )
						v304 = &v458;
					v305 = v454;
					v85 = *v304;
					v306 = v454 - 289845267;
					if ( !v303 )
						v306 = v454 + 1;
					v307 = v455;
					*v456 = v306;
					LOWORD(v306) = -1142;
					goto LABEL_492;
				case 978584698:
					v308 = (int *)&v457;
					v502 = v539;
					v297 = v540;
					if ( v540 )
						v308 = &v458;
					v298 = v454;
					v85 = *v308;
					v299 = v454 + 2;
					if ( v540 )
						v299 = v454 - 289845265;
					v91 = v455;
					*v456 = v299;
					LOWORD(v299) = -1146;
				LABEL_416:
					HIWORD(v299) = -14933;
					v104 = v297 == 0;
					v167 = v298 - 289845266;
					if ( v297 )
						v167 = v298 + v299;
					goto LABEL_418;
				case 978584701:
					v309 = (int *)&v457;
					v144 = *(_QWORD *)(v541 + 4);
					HIDWORD(v144) += 8;
					if ( HIDWORD(v144) > (unsigned int)v144 )
						v309 = &v458;
					v146 = v454;
					v147 = *v309;
					v310 = v454 - 289845262;
					if ( HIDWORD(v144) > (unsigned int)v144 )
						v310 = v454 + 1;
					v149 = v455;
					*v456 = v310;
					v150 = -978584701;
					LOWORD(v302) = 20467;
				LABEL_424:
					HIWORD(v302) = -4423;
					v6 = v302 + v146;
					goto LABEL_425;
				case 978584705:
					v303 = v504 - 1;
					v99 = v504 == 1;
					*(_BYTE *)(v470 + v303) = *(_BYTE *)(v468 + v504 - 1);
					v311 = (int *)&v457;
					v504 = v303;
					if ( v99 )
						v311 = &v458;
					v305 = v454;
					v85 = *v311;
					v306 = v454 - 289845267;
					if ( !v303 )
						v306 = v454 + 1;
					v307 = v455;
					*v456 = v306;
					LOWORD(v306) = -1153;
					goto LABEL_492;
				case 978584708:
					v312 = sub_2F6F8(1247351795);
					v117 = ((int (__fastcall *)(signed int))v312)(16);
					v549 = v117;
					v465 = v117;
					v515 = 503558147;
					v313 = (int *)&v457;
					if ( !v117 )
						v313 = &v458;
					v119 = v454;
					v78 = *v313;
					v121 = v454 - 289845266;
					if ( !v117 )
						v121 = v454 - 289845252;
					v96 = v455;
					*v456 = v121;
					LOWORD(v121) = -1156;
					goto LABEL_460;
				case 978584709:
					*(_DWORD *)(v550 + 4) = 4096;
					v314 = v455;
					v489 = v465;
					v507 = v465;
					v181 = v458;
					v315 = v454 + 8;
					*v456 = v454 - 289845264;
					*v314 = v315;
					goto LABEL_324;
				case 978584710:
					v196 = v455;
					v489 = v465;
					v515 = v552;
					v195 = v454;
					v181 = v458;
					*v456 = v454 - 289845254;
					v197 = -978584710;
					goto LABEL_441;
				case 978584716:
					v303 = v509 - 1;
					v99 = v509 == 1;
					*(_BYTE *)(v467 + v303) = *(_BYTE *)(v479 + v509 - 1);
					v316 = (int *)&v457;
					v509 = v303;
					if ( v99 )
						v316 = &v458;
					v305 = v454;
					v85 = *v316;
					v306 = v454 - 289845267;
					if ( !v303 )
						v306 = v454 + 1;
					v307 = v455;
					*v456 = v306;
					LOWORD(v306) = -1164;
					goto LABEL_492;
				case 978584717:
					HIDWORD(v70) = v481;
					v317 = 0;
					v559 = v511;
					v560 = v510;
					LODWORD(v70) = *(_DWORD *)v489;
					v463 = v481;
					v459 = v70;
					if ( !v510 )
						v317 = 1;
					v561 = v317;
					goto LABEL_480;
				case 978584719:
					v303 = v513 - 1;
					v99 = v513 == 1;
					*(_BYTE *)(v459 + v303) = *(_BYTE *)(v463 + v513 - 1);
					v318 = (int *)&v457;
					v513 = v303;
					if ( v99 )
						v318 = &v458;
					v305 = v454;
					v85 = *v318;
					v306 = v454 - 289845267;
					if ( !v303 )
						v306 = v454 + 3;
					v307 = v455;
					*v456 = v306;
					LOWORD(v306) = -1167;
					goto LABEL_492;
				case 978584720:
					v562 = v514;
					v117 = v489;
					v563 = v489;
					v515 = v514;
					v319 = (int *)&v457;
					if ( !v489 )
						v319 = &v458;
					v119 = v454;
					v78 = *v319;
					v121 = v454 - 289845266;
					if ( !v489 )
						v121 = v454 - 289845264;
					v96 = v455;
					*v456 = v121;
					LOWORD(v121) = -1168;
				LABEL_460:
					HIWORD(v121) = -14933;
					v160 = v119 + 1;
					goto LABEL_461;
				case 978584730:
					HIDWORD(v70) = v488;
					LODWORD(v70) = *v453;
					v577 = v460;
					v320 = 0;
					v480 = v488;
					v469 = v70;
					if ( !v460 )
						v320 = 1;
					v578 = v320;
					goto LABEL_480;
				case 978584732:
					v321 = v518 - 1;
					v99 = v518 == 1;
					*(_BYTE *)(v469 + v321) = *(_BYTE *)(v480 + v518 - 1);
					v322 = (int *)&v457;
					v518 = v321;
					if ( v99 )
						v322 = &v458;
					v323 = v454;
					v85 = *v322;
					v324 = v454 - 289845267;
					if ( !v321 )
						v324 = v454 + 4;
					v325 = v455;
					v104 = v321 == 0;
					*v456 = v324;
					if ( !v321 )
						++v323;
					*v325 = v323;
					goto LABEL_495;
				case 978584733:
					HIDWORD(v70) = v464;
					LODWORD(v70) = *(_DWORD *)a5;
					v579 = v484;
					v326 = 0;
					v496 = v464;
					v474 = v70;
					if ( !v484 )
						v326 = 1;
					v580 = v326;
				LABEL_480:
					v327 = (int *)&v457;
					LOWORD(v328) = 20463;
					if ( HIDWORD(v70) > (unsigned int)v70 )
						v327 = &v458;
					v71 = v454;
					HIWORD(v328) = -4423;
					v72 = *v327;
					v329 = v454 + v328;
					v74 = v455;
					*v456 = v329;
					v73 = -289845266;
					v6 = v71 + 2;
					goto LABEL_483;
				case 978584735:
					v303 = v520 - 1;
					v99 = v520 == 1;
					*(_BYTE *)(v474 + v303) = *(_BYTE *)(v496 + v520 - 1);
					v330 = (int *)&v457;
					v520 = v303;
					if ( v99 )
						v330 = &v458;
					v305 = v454;
					v85 = *v330;
					v306 = v454 - 289845267;
					if ( !v303 )
						v306 = v454 - 289845266;
					v307 = v455;
					*v456 = v306;
					LOWORD(v306) = -1183;
				LABEL_492:
					HIWORD(v306) = -14933;
					v104 = v303 == 0;
					if ( !v303 )
						v305 += v306;
					*v307 = v305;
					goto LABEL_495;
				case 978584737:
					v331 = (int *)&v457;
					v583 = v582;
					v13 = *(_DWORD *)v582;
					if ( !*(_DWORD *)v582 )
						v331 = &v458;
					v332 = v454;
					v17 = *v331;
					v333 = v454 + 1;
					if ( !v13 )
						v333 = v454 - 289845266;
					v334 = v455;
					*v456 = v333;
					LOWORD(v333) = -1185;
					goto LABEL_16;
				case 978584739:
					v335 = (int *)&v457;
					v586 = v585;
					v13 = *(_DWORD *)v585;
					if ( !*(_DWORD *)v585 )
						v335 = &v458;
					v332 = v454;
					v17 = *v335;
					v333 = v454 + 1;
					if ( !v13 )
						v333 = v454 - 289845266;
					v334 = v455;
					*v456 = v333;
					LOWORD(v333) = -1187;
				LABEL_16:
					HIWORD(v333) = -14933;
					*v334 = v332 + v333;
					goto LABEL_17;
				case 978584680:
					*v453 = 0;
					*(_DWORD *)v452 = 0;
					*(_DWORD *)a5 = 0;
					*(_DWORD *)a6 = 0;
					v336 = sub_2F4E0(2066207361);
					v337 = ((int (__fastcall *)(signed int))v336)(16);
					v524 = v337;
					v494 = v337;
					v523 = 503558147;
					v338 = (int *)&v457;
					if ( !v337 )
						v338 = &v458;
					v339 = v454;
					v340 = *v338;
					v341 = v454 - 978584680;
					v342 = v454 - 978584680;
					if ( v337 )
						v342 = v454 + 1;
					v6 = (mach_port_t)v456;
					v343 = v455;
					*v456 = v342;
					if ( v337 )
						v341 = v339 + 4;
					goto LABEL_544;
				case 978584683:
					v6 = v494;
					v344 = sub_2F594(597269601);
					((void (__fastcall *)(mach_port_t))v344)(v6);
					v494 = 0;
					v473 = 0;
					v523 = v527;
					v345 = (int *)&v457;
					if ( v526 )
						v345 = &v458;
					v346 = *v345;
					v347 = v454 - 978584683;
					v348 = v454 - 978584683;
					if ( !v526 )
						v348 = v454 - 289845210;
					v349 = v455;
					*v456 = v348;
					*v349 = v347;
					v454 = v346;
					goto def_2D45C;
				case 978584684:
					LOWORD(v350) = -1132;
					*(_DWORD *)(v525 + 4) = 4096;
					v523 = 503558148;
					v351 = (int *)&v457;
					v529 = v494;
					v473 = v494;
					v352 = v494;
					if ( !v494 )
						v351 = &v458;
					v353 = v454;
					v340 = *v351;
					goto LABEL_540;
				case 978584685:
					v475 = 0;
					v476 = *(_DWORD *)(v529 + 4);
					goto LABEL_546;
				case 978584686:
					v6 = v476;
					v354 = sub_2F594(-1420964539);
					v355 = ((int (__fastcall *)(mach_port_t))v354)(v6);
					v530 = v355;
					v475 = v355;
					v522 = 503558147;
					v356 = (int *)&v457;
					if ( !v355 )
						v356 = &v458;
					v357 = v454;
					v358 = *v356;
					v359 = v454 - 289845266;
					if ( !v355 )
						v359 = v454 - 289845213;
					v360 = v455;
					*v456 = v359;
					v361 = v357 + 1;
					if ( !v355 )
						v361 = v357 + 53;
					goto LABEL_623;
				case 978584689:
					v6 = *(_DWORD *)v529;
					v362 = sub_2F6F8(-2051443885);
					((void (__fastcall *)(mach_port_t))v362)(v6);
					*(_DWORD *)v529 = v475;
					*(_DWORD *)(v529 + 4) = v476;
					LOWORD(v363) = 20512;
					v364 = v454;
					goto LABEL_635;
				case 978584693:
					v365 = (int *)&v457;
					v499 = 0;
					v366 = v536;
					if ( v536 )
						v365 = &v458;
					v367 = v454;
					v368 = *v365;
					v369 = v454 - 289845266;
					if ( v536 )
						v369 = v454 + 2;
					v370 = v455;
					*v456 = v369;
					LOWORD(v369) = -1141;
					goto LABEL_629;
				case 978584695:
					LOWORD(v350) = -1143;
					*(_DWORD *)(*(_DWORD *)v533 + *(_DWORD *)(v533 + 8)) = 1790238927;
					*(_DWORD *)(v533 + 8) += 4;
					v352 = v473;
					v523 = 503558148;
					v371 = (int *)&v457;
					v537 = v473;
					if ( !v473 )
						v371 = &v458;
					v353 = v454;
					v340 = *v371;
				LABEL_540:
					HIWORD(v350) = -14933;
					v341 = v350 + v353;
					v372 = v341;
					if ( v352 )
						v372 = v353 + 1;
					v6 = (mach_port_t)v456;
					v343 = v455;
					*v456 = v372;
					if ( v352 )
						v341 = v353 - 289845262;
				LABEL_544:
					*v343 = v341;
					v454 = v340;
					goto def_2D45C;
				case 978584696:
					v482 = 0;
					v495 = *(_DWORD *)(v537 + 4);
				LABEL_546:
					v163 = v454;
					v161 = v458;
					v162 = v455;
					*v456 = v454 + 1;
					LOWORD(v164) = 20461;
					goto LABEL_581;
				case 978584697:
					v6 = v495;
					v373 = sub_2F6F8(864470285);
					v374 = ((int (__fastcall *)(mach_port_t))v373)(v6);
					v538 = v374;
					v482 = v374;
					v522 = 503558147;
					v375 = (int *)&v457;
					if ( !v374 )
						v375 = &v458;
					v376 = v454;
					v358 = *v375;
					v377 = v454 - 289845266;
					if ( !v374 )
						v377 = v454 - 289845224;
					v360 = v455;
					*v456 = v377;
					v361 = v376 + 1;
					if ( !v374 )
						v361 = v376 + 42;
					goto LABEL_623;
				case 978584700:
					v6 = *(_DWORD *)v537;
					v378 = sub_2F444(1699818209);
					((void (__fastcall *)(mach_port_t))v378)(v6);
					*(_DWORD *)v537 = v482;
					*(_DWORD *)(v537 + 4) = v495;
					LOWORD(v363) = 20501;
					v364 = v454;
					goto LABEL_635;
				case 978584704:
					v379 = (int *)&v457;
					v503 = 0;
					v366 = (unsigned __int8)v544;
					if ( (_BYTE)v544 )
						v379 = &v458;
					v367 = v454;
					v368 = *v379;
					v369 = v454 - 289845266;
					if ( (_BYTE)v544 )
						v369 = v454 + 2;
					v370 = v455;
					*v456 = v369;
					LOWORD(v369) = -1152;
					goto LABEL_629;
				case 978584706:
					v380 = *(_DWORD *)v541 + (*(_DWORD *)(v541 + 8) ^ 0xFFD7F7FF) + (2 * *(_DWORD *)(v541 + 8) & 0xFFAFEFFE);
					*(_BYTE *)(v380 + 2623489) = BYTE3(v451);
					*(_BYTE *)(v380 + 2623490) = v451 >> 16;
					*(_BYTE *)(v380 + 2623491) = BYTE1(v451);
					*(_BYTE *)(v380 + 2623492) = v451;
					*(_BYTE *)(v380 + 2623493) = BYTE3(v450);
					*(_BYTE *)(v380 + 2623494) = v450 >> 16;
					*(_BYTE *)(v380 + 2623495) = BYTE1(v450);
					*(_BYTE *)(v380 + 2623496) = v450;
					*(_DWORD *)(v541 + 8) += 8;
					v545 = v473;
					v481 = 0;
					v462 = 0;
					v489 = 0;
					v381 = dword_40F88;
					v382 = *(_DWORD *)v473;
					v383 = *(_DWORD *)(v473 + 8);
					v384 = sub_2F444(511581350);
					v385 = ((int (__fastcall *)(int, int, int, int *))v384)(v381, v382, v383, &v481);
					v386 = (int *)&v457;
					v505 = v385;
					v506 = 503603150;
					if ( v385 == 268435459 )
						v386 = &v458;
					v387 = v454;
					v388 = *v386;
					v389 = v454 - 978584706;
					v6 = v454 - 978584706;
					if ( v385 == 268435459 )
						v6 = v454 + 1;
					v390 = v455;
					*v456 = v6;
					if ( v385 == 268435459 )
						v389 = v387 + 17;
					*v390 = v389;
					v454 = v388;
					goto def_2D45C;
				case 978584707:
					v391 = *(_DWORD *)(v545 + 8);
					v392 = *(_DWORD *)v545;
					v393 = v546;
					v394 = dword_40F88;
					v6 = sub_2F444(-1169202564);
					v505 = ((int (__fastcall *)(int, int, int, int *))v6)(v394, v392, v391, &v481);
					v162 = v455;
					v506 = (2 * v393 & 0x3C98FFBC) + (v393 ^ 0x9E4C7FDE) + 2142756848;
					v165 = v454 - 978584707;
					v161 = v458;
					*v456 = v454 - 978584707;
					goto LABEL_239;
				case 978584711:
					v6 = *v553;
					v395 = sub_2F594(1311965027);
					((void (__fastcall *)(mach_port_t))v395)(v6);
					v364 = v454;
					v396 = v454 + 11;
					goto LABEL_636;
				case 978584715:
					v397 = (int *)&v457;
					v508 = 0;
					v366 = v558;
					if ( v558 )
						v397 = &v458;
					v367 = v454;
					v368 = *v397;
					v369 = v454 - 289845266;
					if ( v558 )
						v369 = v454 + 2;
					v370 = v455;
					*v456 = v369;
					LOWORD(v369) = -1163;
					goto LABEL_629;
				case 978584718:
					v398 = (int *)&v457;
					v512 = 0;
					v366 = v561;
					if ( v561 )
						v398 = &v458;
					v367 = v454;
					v368 = *v398;
					v369 = v454 - 289845266;
					if ( v561 )
						v369 = v454 + 4;
					v370 = v455;
					*v456 = v369;
					LOWORD(v369) = -1166;
					goto LABEL_629;
				case 978584721:
					v6 = *v564;
					v399 = sub_2F4E0(980655099);
					((void (__fastcall *)(mach_port_t))v399)(v6);
					v163 = v454;
					v161 = v458;
					v162 = v455;
					*v456 = v454 + 1;
					v164 = -978584721;
					goto LABEL_238;
				case 978584722:
					v400 = v515;
					v401 = v462;
					v402 = v481;
					v6 = mach_task_self_;
					v403 = sub_2F444(827022116);
					((void (__fastcall *)(mach_port_t, int, unsigned int))v403)(v6, v402, v401);
					v163 = v454;
					v161 = v458;
					v162 = v455;
					v516 = v400;
					*v456 = v454 + 2;
					LOWORD(v164) = 20477;
				LABEL_581:
					HIWORD(v164) = -4423;
					goto LABEL_238;
				case 978584723:
					v130 = -289845250;
					v487 = 0;
					v522 = 503558133;
					v131 = v454;
					goto LABEL_188;
				case 978584724:
					v404 = v487;
					v522 = 503558148;
					v405 = (int *)&v457;
					v565 = v487;
					if ( !v487 )
						v405 = &v458;
					v406 = v454;
					v358 = *v405;
					v407 = v454 - 289845255;
					if ( !v487 )
						v407 = v454 - 289845251;
					v360 = v455;
					*v456 = v407;
					v361 = v406 + 1;
					if ( !v404 )
						v361 = v406 + 15;
					goto LABEL_623;
				case 978584725:
					v6 = 503603150;
					v408 = _byteswap_ulong(*(_DWORD *)(*(_DWORD *)v565 + v566));
					v477 = (v408 ^ 0x5E7D7FFF) + (2 * v408 & 0xBCFAFFFE) - 1081679921;
					*(_DWORD *)(v565 + 8) += 4;
					v409 = (int *)&v457;
					v410 = v477;
					v521 = v477;
					if ( v477 == 503603150 )
						v409 = &v458;
					v411 = v454;
					v358 = *v409;
					v360 = v455;
					*v456 = v454 - 289845254;
					v361 = v411 + 12;
					if ( v410 == 503603150 )
						v361 = v411 + 1;
					goto LABEL_623;
				case 978584726:
					v412 = *(_DWORD *)(v567 + 8);
					v568 = v412;
					v413 = v412 + 4;
					v414 = *(_DWORD *)(v567 + 4);
					v521 = 503558116;
					v415 = (int *)&v457;
					if ( v413 > v414 )
						v415 = &v458;
					v416 = v454;
					v6 = (mach_port_t)v456;
					v417 = *v415;
					v418 = v455;
					*v456 = v454 - 289845255;
					v419 = v416 + 1;
					if ( v413 > v414 )
						v419 = v416 + 11;
					goto LABEL_609;
				case 978584727:
					v420 = *(_DWORD *)(v569 + 8);
					v571 = v420;
					v421 = v420 + v570;
					v422 = (int *)&v457;
					v423 = *(_DWORD *)(v569 + 4);
					v521 = 503558116;
					if ( v421 > v423 )
						v422 = &v458;
					v424 = v454;
					v6 = (mach_port_t)v456;
					v417 = *v422;
					v418 = v455;
					*v456 = v454 - 289845256;
					v419 = v424 + 1;
					if ( v421 > v423 )
						v419 = v424 + 10;
					goto LABEL_609;
				case 978584728:
					v425 = *(_DWORD *)(v572 + 8);
					v573 = v425;
					v426 = v425 + 4;
					v427 = *(_DWORD *)(v572 + 4);
					v521 = 503558116;
					v428 = (int *)&v457;
					if ( v426 > v427 )
						v428 = &v458;
					v429 = v454;
					v6 = (mach_port_t)v456;
					v417 = *v428;
					v418 = v455;
					*v456 = v454 - 289845257;
					v419 = v429 + 1;
					if ( v426 > v427 )
						v419 = v429 + 9;
				LABEL_609:
					*v418 = v419;
					v454 = v417;
					goto def_2D45C;
				case 978584729:
					v430 = *(_DWORD *)(v574 + 8);
					v576 = v430;
					v431 = v575 + v430;
					v432 = v454;
					v433 = *(_DWORD *)(v574 + 4);
					v521 = 503558116;
					v434 = v454 - 289845260;
					if ( v431 > v433 )
						v434 = v454 - 289845258;
					v435 = (int *)&v457;
					if ( v431 > v433 )
						v435 = &v458;
					v6 = (mach_port_t)v456;
					v436 = v455;
					v437 = *v435;
					*v456 = v434;
					v438 = v432 + 1;
					if ( v431 > v433 )
						v438 = v432 + 8;
					*v436 = v438;
					v454 = v437;
					goto def_2D45C;
				case 978584731:
					v439 = (int *)&v457;
					v517 = 0;
					v440 = v578;
					if ( v578 )
						v439 = &v458;
					v441 = v454;
					v358 = *v439;
					v442 = v454 - 289845266;
					if ( v578 )
						v442 = v454 + 5;
					v360 = v455;
					*v456 = v442;
					v361 = v441 - 289845267;
					if ( v440 )
						v361 = v441 + 2;
				LABEL_623:
					*v360 = v361;
					v454 = v358;
					goto def_2D45C;
				case 978584734:
					v443 = (int *)&v457;
					v519 = 0;
					v366 = v580;
					if ( v580 )
						v443 = &v458;
					v367 = v454;
					v368 = *v443;
					v369 = v454 - 289845266;
					if ( v580 )
						v369 = v454 - 289845265;
					v370 = v455;
					*v456 = v369;
					LOWORD(v369) = -1182;
				LABEL_629:
					HIWORD(v369) = -14933;
					v444 = v367 - 289845267;
					if ( v366 )
						v444 = v367 + v369;
					*v370 = v444;
					v454 = v368;
					goto def_2D45C;
				case 978584736:
					v6 = *v453;
					v445 = sub_2F594(1159713687);
					((void (__fastcall *)(mach_port_t))v445)(v6);
					*v453 = 0;
					v521 = 503558147;
					goto LABEL_634;
				case 978584738:
					v6 = v582;
					v446 = sub_2F6F8(1120497115);
					((void (__fastcall *)(mach_port_t))v446)(v6);
					v522 = v581;
				LABEL_634:
					v364 = v454;
					LOWORD(v363) = 20463;
				LABEL_635:
					HIWORD(v363) = -4423;
					v396 = v364 + v363;
				LABEL_636:
					v133 = v458;
					v134 = v455;
					v135 = v364 + 1;
					*v456 = v396;
					goto LABEL_637;
				case 978584740:
					v6 = v585;
					v447 = sub_2F4E0(289406643);
					((void (__fastcall *)(mach_port_t))v447)(v6);
					v68 = v584;
					goto LABEL_96;
				case 978584741:
					goto LABEL_639;
				case 978584742:
					goto LABEL_640;
				default:
					goto def_2E3E0;
			}
		}
	}
	while ( 1 )
	{
		do
			def_2D45C:
			LOWORD(v19) = v454 - 21589;
		while ( (unsigned int)(v454 - 688739413) > 0x3E );
		switch ( v454 )
		{
			case 688739418:
				v20 = (int *)&v457;
				v21 = 2 * v476;
				v476 = v21;
				v22 = *(_DWORD *)(v529 + 4) + 4;
				if ( v21 > (unsigned int)v22 )
					v20 = &v458;
				v23 = v454;
				v24 = *v20;
				v25 = v454 + 289845268;
				if ( v21 > (unsigned int)v22 )
					v25 = v454 + 53;
				goto LABEL_41;
			case 688739419:
				v26 = 0;
				v27 = *(_QWORD *)v529;
				v531 = *(_QWORD *)v529 >> 32;
				v461 = v27;
				v491 = v530;
				if ( !v531 )
					v26 = 1;
				HIDWORD(v27) = v530;
				v532 = v26;
				goto LABEL_48;
			case 688739426:
				v28 = v499;
				*(_BYTE *)(v483 + v499) = *(_BYTE *)(v472 + v499);
				v29 = v28 + 1;
				v30 = (int *)&v457;
				v31 = v535;
				v499 = v29;
				if ( v29 == v535 )
					v30 = &v458;
				v18 = v454;
				v32 = *v30;
				v33 = v454 + 1;
				if ( v29 == v535 )
					v33 = v454 + 289845269;
				v6 = (mach_port_t)v456;
				v34 = v455;
				*v456 = v33;
				LOWORD(v33) = -21602;
				goto LABEL_93;
			case 688739429:
				v35 = (int *)&v457;
				v21 = 2 * v495;
				v495 = v21;
				v22 = *(_DWORD *)(v537 + 4) + 4;
				if ( v21 > (unsigned int)v22 )
					v35 = &v458;
				v23 = v454;
				v24 = *v35;
				v25 = v454 + 289845268;
				if ( v21 > (unsigned int)v22 )
					v25 = v454 + 42;
			LABEL_41:
				v6 = (mach_port_t)v456;
				v36 = v455;
				*v456 = v25;
				if ( v21 > (unsigned int)v22 )
					++v23;
				*v36 = v23;
				v454 = v24;
				if ( v21 > (unsigned int)v22 )
					goto def_2E3E0;
				goto def_2D45C;
			case 688739430:
				v37 = 0;
				v27 = *(_QWORD *)v537;
				v539 = *(_QWORD *)v537 >> 32;
				v466 = v27;
				v490 = v538;
				if ( !v539 )
					v37 = 1;
				HIDWORD(v27) = v538;
				v540 = v37;
			LABEL_48:
				v38 = (int *)&v457;
				LOWORD(v39) = -20458;
				if ( (unsigned int)v27 > HIDWORD(v27) )
					v38 = &v458;
				v40 = v454;
				HIWORD(v39) = 4422;
				v41 = *v38;
				v42 = v454 + v39;
				v43 = v455;
				*v456 = v42;
				v6 = v40 + 2;
				if ( (unsigned int)v27 > HIDWORD(v27) )
					v6 = v40 + 289845269;
				*v43 = v6;
				v454 = v41;
				if ( (unsigned int)v27 <= HIDWORD(v27) )
					goto def_2E3E0;
				goto def_2D45C;
			case 688739437:
				v44 = v503;
				*(_BYTE *)(v470 + v503) = *(_BYTE *)(v468 + v503);
				v29 = v44 + 1;
				v45 = (int *)&v457;
				v31 = v543;
				v503 = v29;
				if ( v29 == v543 )
					v45 = &v458;
				v18 = v454;
				v32 = *v45;
				v33 = v454 + 1;
				if ( v29 == v543 )
					v33 = v454 + 289845269;
				v6 = (mach_port_t)v456;
				v34 = v455;
				*v456 = v33;
				LOWORD(v33) = -21613;
				goto LABEL_93;
			case 688739448:
				v46 = v508;
				*(_BYTE *)(v467 + v508) = *(_BYTE *)(v479 + v508);
				v29 = v46 + 1;
				v47 = (int *)&v457;
				v31 = v557;
				v508 = v29;
				if ( v29 == v557 )
					v47 = &v458;
				v18 = v454;
				v32 = *v47;
				v33 = v454 + 1;
				if ( v29 == v557 )
					v33 = v454 + 289845269;
				v6 = (mach_port_t)v456;
				v34 = v455;
				*v456 = v33;
				LOWORD(v33) = -21624;
				goto LABEL_93;
			case 688739451:
				v48 = v512;
				*(_BYTE *)(v459 + v512) = *(_BYTE *)(v463 + v512);
				v29 = v48 + 1;
				v49 = (int *)&v457;
				v31 = v560;
				v512 = v29;
				if ( v29 == v560 )
					v49 = &v458;
				v18 = v454;
				v32 = *v49;
				v33 = v454 + 1;
				if ( v29 == v560 )
					v33 = v454 + 289845271;
				v6 = (mach_port_t)v456;
				v34 = v455;
				*v456 = v33;
				LOWORD(v33) = -21627;
				goto LABEL_93;
			case 688739453:
				v50 = (int *)&v457;
				v564 = (mach_port_t *)v563;
				v51 = *(_DWORD *)v563;
				if ( !*(_DWORD *)v563 )
					v50 = &v458;
				v52 = v454;
				v53 = *v50;
				v54 = v454 + 1;
				if ( !v51 )
					v54 = v454 + 289845269;
				v55 = v455;
				*v456 = v54;
				*v55 = v52 - 688739453;
				v454 = v53;
				if ( v51 )
					goto def_2E3E0;
				goto def_2D45C;
			case 688739462:
				v464 = *(_DWORD *)v574 + v576;
				*(_DWORD *)(v574 + 8) += v575;
				v6 = v460;
				v56 = sub_2F4E0(-1200092211);
				*v453 = ((int (__fastcall *)(mach_port_t))v56)(v6);
				v521 = 503558147;
				v57 = (int *)&v457;
				if ( !v453 )
					v57 = &v458;
				v58 = v454;
				v59 = *v57;
				v60 = v454 + 289845269;
				if ( !v453 )
					v60 = v454 + 9;
				v61 = v455;
				*v456 = v60;
				v62 = v58 + 1;
				if ( !v453 )
					v62 = v58 + 289845275;
				*v61 = v62;
				v454 = v59;
				if ( v453 )
					goto def_2E3E0;
				goto def_2D45C;
			case 688739464:
				v63 = v517;
				*(_BYTE *)(v469 + v517) = *(_BYTE *)(v480 + v517);
				v29 = v63 + 1;
				v64 = (int *)&v457;
				v31 = v577;
				v517 = v29;
				if ( v29 == v577 )
					v64 = &v458;
				v18 = v454;
				v32 = *v64;
				v65 = v454 + 1;
				if ( v29 == v577 )
					v65 = v454 + 289845272;
				v6 = (mach_port_t)v456;
				v34 = v455;
				*v456 = v65;
				v33 = 289845269;
				goto LABEL_19;
			case 688739467:
				v66 = v519;
				*(_BYTE *)(v474 + v519) = *(_BYTE *)(v496 + v519);
				v29 = v66 + 1;
				v67 = (int *)&v457;
				v31 = v579;
				v519 = v29;
				if ( v29 == v579 )
					v67 = &v458;
				v18 = v454;
				v32 = *v67;
				v33 = v454 + 1;
				if ( v29 == v579 )
					v33 = v454 + 2;
				v6 = (mach_port_t)v456;
				v34 = v455;
				*v456 = v33;
				LOWORD(v33) = -21643;
			LABEL_93:
				HIWORD(v33) = -10510;
			LABEL_19:
				if ( v29 == v31 )
					v18 += v33;
				*v34 = v18;
				v454 = v32;
				goto def_2D45C;
			case 688739414:
				v473 = v494;
				v68 = v527;
				goto LABEL_96;
			case 688739416:
				v68 = 503558148;
			LABEL_96:
				v523 = v68;
				v454 = v458;
				goto def_2D45C;
			case 688739417:
				v69 = (int *)&v457;
				v70 = *(_QWORD *)(v529 + 4);
				HIDWORD(v70) += 4;
				if ( HIDWORD(v70) > (unsigned int)v70 )
					v69 = &v458;
				v71 = v454;
				v72 = *v69;
				v73 = v454 + 56;
				if ( HIDWORD(v70) > (unsigned int)v70 )
					v73 = v454 + 1;
				v74 = v455;
				*v456 = v73;
				LOWORD(v73) = -21593;
				goto LABEL_125;
			case 688739421:
				v75 = v498 - 1;
				v99 = v498 == 1;
				*(_BYTE *)(v491 + v75) = *(_BYTE *)(v461 + v498 - 1);
				v76 = (int *)&v457;
				v498 = v75;
				if ( v99 )
					v76 = &v458;
				v77 = v454;
				v78 = *v76;
				v79 = v454 + 289845268;
				if ( !v75 )
					v79 = v454 + 1;
				v80 = v455;
				*v456 = v79;
				LOWORD(v79) = -21597;
				goto LABEL_131;
			case 688739422:
				LOWORD(v81) = -21598;
				*(_DWORD *)(*(_DWORD *)v529 + *(_DWORD *)(v529 + 8)) = 0x1000000;
				*(_DWORD *)(v529 + 8) += 4;
				v82 = v473;
				v523 = 503558148;
				v83 = (int *)&v457;
				v533 = v473;
				if ( !v473 )
					v83 = &v458;
				v84 = v454;
				v85 = *v83;
				goto LABEL_137;
			case 688739424:
				v6 = v485;
				v86 = sub_2F6F8(-1331687381);
				v87 = ((int (__fastcall *)(mach_port_t))v86)(v6);
				v534 = v87;
				v478 = v87;
				v522 = 503558147;
				v88 = (int *)&v457;
				if ( !v87 )
					v88 = &v458;
				v89 = v454;
				v85 = *v88;
				v90 = v454 + 289845269;
				if ( !v87 )
					v90 = v454 + 49;
				v91 = v455;
				*v456 = v90;
				LOWORD(v90) = -20413;
				goto LABEL_245;
			case 688739425:
				v92 = (int *)&v457;
				v500 = v535;
				v93 = v536;
				if ( v536 )
					v92 = &v458;
				v94 = v454;
				v78 = *v92;
				v95 = v454 + 2;
				if ( v536 )
					v95 = v454 + 289845270;
				v96 = v455;
				*v456 = v95;
				LOWORD(v95) = -21601;
				goto LABEL_233;
			case 688739428:
				v97 = (int *)&v457;
				v70 = *(_QWORD *)(v537 + 4);
				HIDWORD(v70) += 4;
				if ( HIDWORD(v70) > (unsigned int)v70 )
					v97 = &v458;
				v71 = v454;
				v72 = *v97;
				v73 = v454 + 45;
				if ( HIDWORD(v70) > (unsigned int)v70 )
					v73 = v454 + 1;
				v74 = v455;
				*v456 = v73;
				LOWORD(v73) = -21604;
			LABEL_125:
				HIWORD(v73) = -10510;
				v6 = v71 + 289845273;
			LABEL_483:
				if ( HIDWORD(v70) > (unsigned int)v70 )
					v6 = v71 + v73;
				*v74 = v6;
				v454 = v72;
				if ( HIDWORD(v70) > (unsigned int)v70 )
					goto def_2E3E0;
				goto def_2D45C;
			case 688739432:
				v75 = v502 - 1;
				v99 = v502 == 1;
				*(_BYTE *)(v490 + v75) = *(_BYTE *)(v466 + v502 - 1);
				v98 = (int *)&v457;
				v502 = v75;
				if ( v99 )
					v98 = &v458;
				v77 = v454;
				v78 = *v98;
				v79 = v454 + 289845268;
				if ( !v75 )
					v79 = v454 + 1;
				v80 = v455;
				*v456 = v79;
				LOWORD(v79) = -21608;
			LABEL_131:
				HIWORD(v79) = -10510;
				v99 = v75 == 0;
				if ( !v75 )
					v77 += v79;
				*v80 = v77;
				goto LABEL_464;
			case 688739433:
				LOWORD(v81) = -21609;
				*(_DWORD *)(*(_DWORD *)v537 + *(_DWORD *)(v537 + 8)) = 0x1000000;
				*(_DWORD *)(v537 + 8) += 4;
				v82 = v473;
				v523 = 503558148;
				v100 = (int *)&v457;
				v541 = v473;
				if ( !v473 )
					v100 = &v458;
				v84 = v454;
				v85 = *v100;
			LABEL_137:
				HIWORD(v81) = -10510;
				v101 = v81 + v84;
				v102 = v101;
				if ( v82 )
					v102 = v84 + 1;
				v6 = (mach_port_t)v456;
				v103 = v455;
				v104 = v82 == 0;
				*v456 = v102;
				if ( v82 )
					v101 = v84 + 289845273;
				*v103 = v101;
				goto LABEL_495;
			case 688739435:
				if ( v454 == 688739475 )
				{
					v6 = v486;
					LOWORD(v19) = -4349;
				}
				HIWORD(v19) = -21261;
				v105 = sub_2F594(v19);
				v87 = ((int (__fastcall *)(mach_port_t))v105)(v6);
				v542 = v87;
				v471 = v87;
				v522 = 503558147;
				v106 = (int *)&v457;
				if ( !v87 )
					v106 = &v458;
				v89 = v454;
				v85 = *v106;
				v90 = v454 + 289845269;
				if ( !v87 )
					v90 = v454 + 38;
				v91 = v455;
				*v456 = v90;
				LOWORD(v90) = -20424;
				goto LABEL_245;
			case 688739436:
				v107 = (int *)&v457;
				v504 = v543;
				v93 = (unsigned __int8)v544;
				if ( (_BYTE)v544 )
					v107 = &v458;
				v94 = v454;
				v78 = *v107;
				v95 = v454 + 2;
				if ( (_BYTE)v544 )
					v95 = v454 + 289845270;
				v96 = v455;
				*v456 = v95;
				LOWORD(v95) = -21612;
				goto LABEL_233;
			case 688739441:
				v6 = 0;
				*(_DWORD *)v549 = 0;
				*(_DWORD *)(v465 + 4) = 0;
				*(_DWORD *)(v465 + 8) = 0;
				*(_DWORD *)(v465 + 12) = 0;
				v108 = sub_2F4E0(582909503);
				*(_DWORD *)v465 = ((int (__fastcall *)(signed int))v108)(4096);
				v109 = (int *)&v457;
				v550 = v465;
				v110 = *(_DWORD *)v465 == 0;
				LOWORD(v111) = 24526;
				if ( !*(_DWORD *)v465 )
					v6 = 1;
				HIWORD(v111) = 7684;
				v551 = v6;
				if ( v110 )
					v111 = 503558147;
				v552 = v111;
				v112 = v551;
				if ( v551 )
					v109 = &v458;
				v113 = v454;
				v78 = *v109;
				v114 = v454 + 289845271;
				if ( v551 )
					v114 = v454 + 289845269;
				v115 = v455;
				v99 = v551 == 0;
				*v456 = v114;
				v116 = v113 - 688739441;
				if ( v112 )
					v116 = v113 + 2;
				*v115 = v116;
				goto LABEL_464;
			case 688739442:
				v117 = v550;
				v118 = (int *)&v457;
				if ( !v550 )
					v118 = &v458;
				v119 = v454;
				v78 = *v118;
				v120 = v454 + 2;
				if ( !v550 )
					v120 = v454 + 289845280;
				v96 = v455;
				*v456 = v120;
				v121 = -688739442;
				v122 = 289845269;
			LABEL_395:
				v160 = v122 + v119;
			LABEL_461:
				v99 = v117 == 0;
				if ( !v117 )
					v160 = v119 + v121;
				goto LABEL_463;
			case 688739443:
				v123 = (int *)&v457;
				v553 = (mach_port_t *)v550;
				v87 = *(_DWORD *)v550;
				if ( !*(_DWORD *)v550 )
					v123 = &v458;
				v89 = v454;
				v85 = *v123;
				v124 = v454 + 1;
				if ( !v87 )
					v124 = v454 + 289845279;
				v91 = v455;
				*v456 = v124;
				v90 = 289845269;
				v125 = -688739443;
			LABEL_386:
				v167 = v125 + v89;
				goto LABEL_387;
			case 688739447:
				v126 = (int *)&v457;
				v509 = v557;
				v93 = v558;
				if ( v558 )
					v126 = &v458;
				v94 = v454;
				v78 = *v126;
				v95 = v454 + 2;
				if ( v558 )
					v95 = v454 + 289845270;
				v96 = v455;
				*v456 = v95;
				LOWORD(v95) = -21623;
				goto LABEL_233;
			case 688739450:
				v127 = (int *)&v457;
				v513 = v560;
				v93 = v561;
				if ( v561 )
					v127 = &v458;
				v94 = v454;
				v78 = *v127;
				v95 = v454 + 2;
				if ( v561 )
					v95 = v454 + 289845272;
				v96 = v455;
				*v456 = v95;
				LOWORD(v95) = -21626;
				goto LABEL_233;
			case 688739455:
				v6 = (mach_port_t)&v587;
				v588 = (int *)((char *)&v587 + v548);
				v128 = sub_2F444(1168754333);
				((void (__fastcall *)(int *))v128)(&v587);
				v129 = v547;
				LOWORD(v130) = -20459;
				if ( !v587 )
					v129 = 503558134;
				HIWORD(v130) = 4422;
				v516 = v129;
				v131 = v454;
			LABEL_188:
				v132 = v131 + v130;
				v133 = v458;
				v134 = v455;
				v135 = v131 + 16;
				*v456 = v132;
			LABEL_637:
				*v134 = v135;
				v454 = v133;
				goto def_2D45C;
			case 688739456:
				v136 = v516;
				v6 = 503603150;
				v137 = v489;
				if ( v516 != 503603150 )
					v137 = 0;
				v522 = v516;
				v487 = v137;
				v138 = (int *)&v457;
				if ( v516 == 503603150 )
					v138 = &v458;
				v139 = v454;
				v78 = *v138;
				v140 = v454 + 17;
				if ( v516 == 503603150 )
					v140 = v454 + 15;
				v141 = v455;
				v99 = v516 == 503603150;
				*v456 = v140;
				v142 = v139 + 289845283;
				if ( v136 == 503603150 )
					v142 = v139 + 1;
				*v141 = v142;
				goto LABEL_464;
			case 688739457:
				v143 = *(_DWORD *)(v565 + 8);
				v566 = v143;
				HIDWORD(v144) = v143 + 4;
				LODWORD(v144) = *(_DWORD *)(v565 + 4);
				v521 = 503558116;
				v145 = (int *)&v457;
				if ( HIDWORD(v144) > (unsigned int)v144 )
					v145 = &v458;
				v146 = v454;
				v147 = *v145;
				v148 = v454 + 1;
				if ( HIDWORD(v144) > (unsigned int)v144 )
					v148 = v454 + 14;
				v149 = v455;
				*v456 = v148;
				v150 = 289845280;
				v6 = v146 + 12;
			LABEL_425:
				if ( HIDWORD(v144) > (unsigned int)v144 )
					v6 = v146 + v150;
				*v149 = v6;
				v454 = v147;
				if ( HIDWORD(v144) > (unsigned int)v144 )
					goto def_2D45C;
				goto def_2E3E0;
			case 688739458:
				v87 = v487;
				v522 = 503558148;
				v151 = (int *)&v457;
				v567 = v487;
				if ( !v487 )
					v151 = &v458;
				v89 = v454;
				v85 = *v151;
				v90 = v454 + 11;
				if ( !v487 )
					v90 = v454 + 15;
				v91 = v455;
				*v456 = v90;
				LOWORD(v90) = -20447;
				goto LABEL_245;
			case 688739459:
				v152 = *(_BYTE *)(*(_DWORD *)v567 + v568 + 2);
				v460 = _byteswap_ulong(*(_DWORD *)(*(_DWORD *)v567 + v568));
				*(_DWORD *)(v567 + 8) += 4;
				v522 = 503558148;
				v153 = (int *)&v457;
				v569 = v487;
				v570 = v460;
				v87 = v487;
				if ( !v487 )
					v153 = &v458;
				v89 = v454;
				v85 = *v153;
				v90 = v454 + 10;
				if ( !v487 )
					v90 = v454 + 14;
				v91 = v455;
				*v456 = v90;
				LOWORD(v90) = -20448;
				goto LABEL_245;
			case 688739460:
				v488 = *(_DWORD *)v569 + v571;
				*(_DWORD *)(v569 + 8) += v570;
				v87 = v487;
				v522 = 503558148;
				v154 = (int *)&v457;
				v572 = v487;
				if ( !v487 )
					v154 = &v458;
				v89 = v454;
				v85 = *v154;
				v90 = v454 + 9;
				if ( !v487 )
					v90 = v454 + 13;
				v91 = v455;
				*v456 = v90;
				LOWORD(v90) = -20449;
				goto LABEL_245;
			case 688739461:
				v155 = *(_BYTE *)(*(_DWORD *)v572 + v573 + 2);
				v484 = _byteswap_ulong(*(_DWORD *)(*(_DWORD *)v572 + v573));
				*(_DWORD *)(v572 + 8) += 4;
				v522 = 503558148;
				v156 = (int *)&v457;
				v574 = v487;
				v575 = v484;
				v87 = v487;
				if ( !v487 )
					v156 = &v458;
				v89 = v454;
				v85 = *v156;
				v90 = v454 + 8;
				if ( !v487 )
					v90 = v454 + 12;
				v91 = v455;
				*v456 = v90;
				LOWORD(v90) = -20450;
				goto LABEL_245;
			case 688739463:
				v157 = (int *)&v457;
				v518 = v577;
				v93 = v578;
				if ( v578 )
					v157 = &v458;
				v94 = v454;
				v78 = *v157;
				v158 = v454 + 2;
				if ( v578 )
					v158 = v454 + 289845273;
				v96 = v455;
				*v456 = v158;
				v95 = 289845270;
				goto LABEL_234;
			case 688739466:
				v159 = (int *)&v457;
				v520 = v579;
				v93 = v580;
				if ( v580 )
					v159 = &v458;
				v94 = v454;
				v78 = *v159;
				v95 = v454 + 2;
				if ( v580 )
					v95 = v454 + 3;
				v96 = v455;
				*v456 = v95;
				LOWORD(v95) = -21642;
			LABEL_233:
				HIWORD(v95) = -10510;
			LABEL_234:
				v99 = v93 == 0;
				v160 = v94 + 289845269;
				if ( v93 )
					v160 = v94 + v95;
			LABEL_463:
				*v96 = v160;
			LABEL_464:
				v454 = v78;
				if ( !v99 )
					goto def_2D45C;
				goto def_2E3E0;
			case 688739468:
				*(_DWORD *)a6 = v484;
				v161 = v458;
				v162 = v455;
				v521 = 503603150;
				v163 = v454;
				*v456 = v454 + 3;
				v164 = 289845269;
			LABEL_238:
				v165 = v163 + v164;
			LABEL_239:
				*v162 = v165;
				v454 = v161;
				goto def_2D45C;
			case 688739469:
				v581 = v521;
				v87 = v487;
				v582 = v487;
				v522 = v521;
				v166 = (int *)&v457;
				if ( !v487 )
					v166 = &v458;
				v89 = v454;
				v85 = *v166;
				v90 = v454 + 289845269;
				if ( !v487 )
					v90 = v454 + 4;
				v91 = v455;
				*v456 = v90;
				LOWORD(v90) = -20458;
			LABEL_245:
				HIWORD(v90) = 4422;
				v167 = v89 + 1;
			LABEL_387:
				v104 = v87 == 0;
				if ( !v87 )
					v167 = v89 + v90;
			LABEL_418:
				*v91 = v167;
				goto LABEL_495;
			case 688739471:
				v584 = v522;
				v168 = v473;
				v585 = v473;
				v523 = v522;
				v169 = (int *)&v457;
				if ( !v473 )
					v169 = &v458;
				v170 = v454;
				v85 = *v169;
				v171 = v454 - 688739471;
				v172 = v454 - 688739471;
				if ( v473 )
					v172 = v454 + 289845269;
				v6 = (mach_port_t)v456;
				v173 = v455;
				v104 = v473 == 0;
				*v456 = v172;
				if ( v168 )
					v171 = v170 + 1;
				*v173 = v171;
			LABEL_495:
				v454 = v85;
				if ( !v104 )
					goto def_2E3E0;
				goto def_2D45C;
			case 688739413:
				v174 = 0;
				*(_DWORD *)v524 = 0;
				*(_DWORD *)(v494 + 4) = 0;
				*(_DWORD *)(v494 + 8) = 0;
				*(_DWORD *)(v494 + 12) = 0;
				v175 = sub_2F6F8(-2146483831);
				*(_DWORD *)v494 = ((int (__fastcall *)(signed int))v175)(4096);
				v176 = (int *)&v457;
				v525 = v494;
				v177 = *(_DWORD *)v494 == 0;
				LOWORD(v178) = 24526;
				if ( !*(_DWORD *)v494 )
					v174 = 1;
				HIWORD(v178) = 7684;
				v526 = v174;
				if ( v177 )
					v178 = 503558147;
				v527 = v178;
				v179 = v526;
				if ( v526 )
					v176 = &v458;
				v180 = v454;
				v181 = *v176;
				v182 = v454 + 60;
				if ( v526 )
					v182 = v454 + 1;
				v183 = v455;
				*v456 = v182;
				v184 = 289845269;
				v185 = v180 + 4;
				goto LABEL_292;
			case 688739415:
				v186 = *(_DWORD *)v528;
				v187 = sub_2F594(910096703);
				((void (__fastcall *)(int))v187)(v186);
				v188 = v454;
				v189 = v454 + 58;
				goto LABEL_310;
			case 688739420:
				v190 = (int *)&v457;
				v497 = 0;
				v179 = v532;
				if ( v532 )
					v190 = &v458;
				v180 = v454;
				v181 = *v190;
				v184 = v454 + 289845269;
				if ( v532 )
					v184 = v454 + 2;
				v183 = v455;
				*v456 = v184;
				LOWORD(v184) = -21596;
				goto LABEL_275;
			case 688739423:
				v478 = 0;
				v485 = *(_DWORD *)(v533 + 4);
				goto LABEL_277;
			case 688739427:
				v191 = *(_DWORD *)v533;
				v192 = sub_2F444(185613875);
				((void (__fastcall *)(int))v192)(v191);
				*(_DWORD *)v533 = v478;
				*(_DWORD *)(v533 + 4) = v485;
				v188 = v454;
				v189 = v454 + 46;
				goto LABEL_310;
			case 688739431:
				v193 = (int *)&v457;
				v501 = 0;
				v179 = v540;
				if ( v540 )
					v193 = &v458;
				v180 = v454;
				v181 = *v193;
				v184 = v454 + 289845269;
				if ( v540 )
					v184 = v454 + 2;
				v183 = v455;
				*v456 = v184;
				LOWORD(v184) = -21607;
			LABEL_275:
				HIWORD(v184) = -10510;
				LOWORD(v194) = -20460;
				goto LABEL_291;
			case 688739434:
				v471 = 0;
				v486 = *(_DWORD *)(v541 + 4);
			LABEL_277:
				v195 = v454;
				v181 = v458;
				v196 = v455;
				*v456 = v454 + 1;
				v197 = 289845268;
				goto LABEL_441;
			case 688739438:
				v198 = *(_DWORD *)v541;
				v199 = sub_2F594(-1384040549);
				((void (__fastcall *)(int))v199)(v198);
				*(_DWORD *)v541 = v471;
				*(_DWORD *)(v541 + 4) = v486;
				v200 = v455;
				v181 = v458;
				v201 = v454 + 2;
				*v456 = v454 + 1;
				*v200 = v201;
				goto LABEL_324;
			case 688739439:
				v202 = bootstrap_port;
				v203 = sub_2F4E0(163120798);
				v204 = ((int (__fastcall *)(mach_port_t, _DWORD, int *))v203)(v202, "com.apple.adid", &dword_40F88);
				v205 = (int *)&v457;
				v546 = v204;
				if ( !v204 )
					v205 = &v458;
				v206 = v454;
				v181 = *v205;
				v207 = v454 + 32;
				if ( !v204 )
					v207 = v454 + 1;
				v208 = v455;
				*v456 = v207;
				*v208 = v206 - 688739439;
				goto LABEL_324;
			case 688739440:
				v547 = v506;
				v548 = v505;
				if ( !v505 )
					goto LABEL_285;
				if ( v505 == 268435459 )
				{
				LABEL_640:
					v454 = 978584742;
					v209 = 978584723;
					v458 = 978584723;
					v211 = v455;
					*v456 = 688739471;
					v210 = 0;
				LABEL_641:
					*v211 = v210;
					v454 = v209;
					goto def_2E3E0;
				}
			LABEL_639:
				v458 = 688739455;
				v448 = v455;
				*v456 = 688739456;
				*v448 = 0;
				v454 = 688739455;
				break;
			case 688739474:
			LABEL_285:
				v454 = 688739474;
				v209 = 978584708;
				v458 = 978584708;
				v210 = 688739441;
				v211 = v455;
				*v456 = 978584722;
				goto LABEL_641;
			case 688739444:
				v212 = v465;
				v213 = sub_2F444(1473198091);
				((void (__fastcall *)(int))v213)(v212);
				v214 = (int *)&v457;
				v465 = 0;
				v489 = 0;
				v507 = 0;
				v515 = v552;
				v179 = v551;
				if ( v551 )
					v214 = &v458;
				v180 = v454;
				v181 = *v214;
				v215 = v454 + 1;
				if ( v551 )
					v215 = v454 + 12;
				v183 = v455;
				*v456 = v215;
				v184 = -688739444;
				LOWORD(v194) = -20455;
			LABEL_291:
				HIWORD(v194) = 4422;
				v185 = v194 + v180;
			LABEL_292:
				if ( v179 )
					v185 = v180 + v184;
				*v183 = v185;
				goto LABEL_324;
			case 688739445:
				v493 = 0;
				v216 = *(_DWORD *)(v554 + 4);
				v514 = 503558148;
				v217 = (int *)&v457;
				v492 = v216;
				v218 = v554;
				if ( !v554 )
					v217 = &v458;
				v219 = v454;
				v181 = *v217;
				v220 = v454 + 1;
				if ( !v554 )
					v220 = v454 + 289845277;
				v221 = v455;
				*v456 = v220;
				v222 = v219 + 289845268;
				if ( !v218 )
					v222 = v219 + 8;
				*v221 = v222;
				goto LABEL_324;
			case 688739446:
				v223 = v492;
				v224 = sub_2F594(-169845153);
				v225 = ((int (__fastcall *)(int))v224)(v223);
				v556 = v225;
				v493 = v225;
				v514 = 503558147;
				v226 = (int *)&v457;
				if ( !v225 )
					v226 = &v458;
				v227 = v454;
				v181 = *v226;
				v228 = v454 + 289845269;
				if ( !v225 )
					v228 = v454 + 289845276;
				v229 = v455;
				*v456 = v228;
				v230 = v227 + 1;
				if ( !v225 )
					v230 = v227 + 7;
				*v229 = v230;
				goto LABEL_324;
			case 688739449:
				v231 = *(_DWORD *)v554;
				v232 = sub_2F64C(416896089);
				((void (__fastcall *)(int))v232)(v231);
				*(_DWORD *)v554 = v493;
				*(_DWORD *)(v554 + 4) = v492;
				v510 = v462;
				v511 = 503603150;
				v188 = v454;
				v189 = v454 + 289845269;
			LABEL_310:
				v233 = v455;
				v181 = v458;
				*v456 = v189;
				*v233 = v188 + 1;
				goto LABEL_324;
			case 688739452:
				*(_DWORD *)(v489 + 4) = v462;
				*(_DWORD *)(v489 + 8) = 0;
				v181 = v458;
				v196 = v455;
				v515 = v559;
				v195 = v454;
				*v456 = v454 + 4;
				v197 = -688739452;
				goto LABEL_441;
			case 688739454:
				v234 = v563;
				v235 = sub_2F594(1773373801);
				((void (__fastcall *)(int))v235)(v234);
				v181 = v458;
				v196 = v455;
				v515 = v562;
				v195 = v454;
				*v456 = v454 + 2;
				v197 = -688739454;
				goto LABEL_441;
			case 688739465:
				*(_DWORD *)v452 = v460;
				v236 = v484;
				v237 = sub_2F594(1695730283);
				*(_DWORD *)a5 = ((int (__fastcall *)(unsigned int))v237)(v236);
				v238 = (int *)&v457;
				if ( !a5 )
					v238 = &v458;
				v239 = v454;
				v240 = *v238;
				v241 = v454 + 289845269;
				if ( !a5 )
					v241 = v454 + 4;
				v242 = v455;
				*v456 = v241;
				v243 = v239 + 1;
				if ( !a5 )
					v243 = v239 - 688739465;
				*v242 = v243;
				v454 = v240;
				goto def_2E3E0;
			case 688739470:
				v244 = *(_DWORD *)v583;
				v245 = sub_2F4E0(-129539611);
				((void (__fastcall *)(int))v245)(v244);
				v195 = v454;
				v181 = v458;
				v196 = v455;
				*v456 = v454 + 1;
				v197 = -688739470;
				goto LABEL_441;
			case 688739472:
				v246 = *(_DWORD *)v586;
				v247 = sub_2F444(-1099145975);
				((void (__fastcall *)(int))v247)(v246);
				v195 = v454;
				v181 = v458;
				v196 = v455;
				*v456 = v454 + 1;
				v197 = -688739472;
			LABEL_441:
				*v196 = v195 + v197;
			LABEL_324:
				v454 = v181;
				goto def_2E3E0;
			case 688739475:
				goto def_2E3E0;
			case 688739473:
				//if ( __stack_chk_guard != v589 )
				//	__stack_chk_fail(v523);
				return v523 - 503603150;
			default:
				goto def_2D45C;
		}
	}
}