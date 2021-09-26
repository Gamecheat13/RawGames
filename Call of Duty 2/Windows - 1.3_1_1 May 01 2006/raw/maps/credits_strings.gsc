#include maps\_utility;
#include maps\_anim;
#include animscripts\utility;
cam_controls (vec, letter)
{
	setcvar (letter+"up","");
	setcvar (letter+"down","");
	while (1)
	{
		if (getcvar (letter+"up") != "")
			level.cam_vec[vec] += 5;	
		if (getcvar (letter+"down") != "")
			level.cam_vec[vec] -= 5;	
		setcvar (letter+"up","");
		setcvar (letter+"down","");
		wait (0.1);
	}
}

height ( trigger )
{
	wait (0.05);
	trigger waittill ("trigger");
	level.destinationHeight = trigger.script_delay;
	if (isdefined (trigger.script_noteworthy))
	{
//		maps\_utility::error ("note " + trigger.script_noteworthy);
		if (trigger.script_noteworthy == "make mortars")
			getent ("mortar team","targetname") notify ("start");
	}
}

heightDestination()
{
	level.destinationHeight	= 0;
	level.currentHeight	= 0;
	dif = 0.98;
	while (1)
	{
		level.currentHeight = level.currentHeight * dif + level.destinationHeight * (1.0 - dif);
		wait (0.05);
	}
}

rotateroler ()
{
	self rotateto ((level.cam_vec[0],level.cam_vec[1],level.cam_vec[2]), 0.05);
	return;
		
	while (1)
	{
		println ("cam ",level.cam_vec[0], " ",level.cam_vec[1]," ",level.cam_vec[2]);
		self rotateto ((level.cam_vec[0],level.cam_vec[1],level.cam_vec[2]), 0.05);
//		level.player.angles = (level.cam_vec[0],level.cam_vec[1],level.cam_vec[2]);

		wait (0.2);
	}
}

follower (ender)
{
	timer = 0.15;
//	ender.origin;
	level.player.angles = (0,0,0);
	level.player playerlinktoabsolute (level.camorg, "", (1,1,1));
	level.player dontInterpolate();
	level.player freezeControls(true);

	level.destinationHeight	= 0;
	level.currentHeight	= 0;
	offset = 54;
	level.leftoffset = 0;
	if (getcvar ("start") != "start")
		return;
		
	
	
	while (1)
	{
		self moveto ((ender.origin[0] - 40 + level.leftoffset, ender.origin[1] - 400, offset + level.currentHeight), timer);
		wait (timer);
	}
}

addCredits (src, text, override)
{
	
	newStr = spawnstruct();
	newStr.string = text;
	newStr.placement = src.size;
	newStr.location = 0;
	newStr.sort = 20;
	newStr.blank = false;
	if (isdefined(override))
		newStr.fontScale = override;
	else
		newStr.fontScale = level.smallFont;
	
	newStr.alignX = "right";
	newStr.horzAlign = "right";
	
	src[src.size] = newStr;
	return src;
	
}

addCreditsBold (src, text)
{
	newStr = spawnstruct();
	newStr.string = text;
	newStr.placement = src.size;
	newStr.location = 0;
	newStr.sort = 20;
	newStr.blank = false;
	newStr.fontScale = level.bigFont;
	newStr.alignX = "right";
	newStr.horzAlign = "right";
	src[src.size] = newStr;
	return src;
}

addBlank (src )
{
	newStr = level.blankElement;
	src[src.size] = newStr;
	return src;
}


text ()
{
	level.blankElement = newHudElem();
	level.blankElement.blank = true;
	if (level.xenon)
	{
		level.bigFont = 1.75;
		level.smallFont = 1.38;
	}
	else
	{
		level.bigFont = 1.25;
		level.smallFont = 1.00;
	}
	
	src = [];
	src = addCreditsBold (src, &"CREDIT_INFINITY_WARD");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_PROJECT_LEAD");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_JASON_WEST");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_EXECUTIVE_PRODUCER");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_VINCE_ZAMPELLA");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_SENIOR_DESIGN_LEAD");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_ZIED_RIEKE");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ART_LEAD");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_MICHAEL_BOON");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ART_DIRECTOR");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_RICHARD_KRIEGLER");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_AUDIO_LEAD");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_MARC_GANUS");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_DESIGN_LEADS");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_TODD_ALDERMAN");
	src = addCredits (src, &"CREDIT_STEVE_FUKUDA");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ENGINEERING_LEADS");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_ROBERT_FIELD");
	src = addCredits (src, &"CREDIT_FRANCESCO_GIGLIOTTI");
	src = addCredits (src, &"CREDIT_EARL_HAMMON_JR");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ENGINEERING");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_RICHARD_BAKER");
	src = addCredits (src, &"CREDIT_CHAD_BARB");
	src = addCredits (src, &"CREDIT_BEN_BASTIAN");
	src = addCredits (src, &"CREDIT_HYUN_JIN_CHO");
	src = addCredits (src, &"CREDIT_ROBERT_FIELD");
	src = addCredits (src, &"CREDIT_FRANCESCO_GIGLIOTTI");
	src = addCredits (src, &"CREDIT_JOEL_GOMPERT");
	src = addCredits (src, &"CREDIT_EARL_HAMMON_JR");
	src = addCredits (src, &"CREDIT_BRIAN_LANGEVIN");
	src = addCredits (src, &"CREDIT_SARAH_MICHAEL");
	src = addCredits (src, &"CREDIT_BRYAN_PEARSON");
	src = addCredits (src, &"CREDIT_JON_SHIRING");
	src = addCredits (src, &"CREDIT_JASON_WEST");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ADDITIONAL_ENGINEERING");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_PRESTON_GLENN");
	src = addCredits (src, &"CREDIT_CHAD_GRENIER");
	src = addCredits (src, &"CREDIT_BRYAN_KUHN");
	src = addCredits (src, &"CREDIT_MACKEY_MCCANDLISH");
	src = addCredits (src, &"CREDIT_BRENT_MCLEOD");
	src = addCredits (src, &"CREDIT_JIESANG_SONG");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_LEVEL_DESIGN");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_ROGER_ABRAHAMSSON");
	src = addCredits (src, &"CREDIT_MOHAMMAD_BADMOFO_ALAVI");
	src = addCredits (src, &"CREDIT_TODD_ALDERMAN");
	src = addCredits (src, &"CREDIT_KEITH_NED_BELL");
	src = addCredits (src, &"CREDIT_STEVE_FUKUDA");
	src = addCredits (src, &"CREDIT_BRIAN_GILMAN");
	src = addCredits (src, &"CREDIT_PRESTON_GLENN");
	src = addCredits (src, &"CREDIT_CHAD_GRENIER");
	src = addCredits (src, &"CREDIT_RODNEY_HOULE");
	src = addCredits (src, &"CREDIT_MACKEY_MCCANDLISH");
	src = addCredits (src, &"CREDIT_BRENT_MCLEOD");
	src = addCredits (src, &"CREDIT_JON_PORTER");
	src = addCredits (src, &"CREDIT_ZIED_RIEKE");
	src = addCredits (src, &"CREDIT_NATHAN_SILVERS");
	src = addCredits (src, &"CREDIT_GEOFF_SMITH");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ANIMATION");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_URSULA_ESCHER");
	src = addCredits (src, &"CREDIT_CHANCE_GLASCO");
	src = addCredits (src, &"CREDIT_MARK_GRIGSBY");
	src = addCredits (src, &"CREDIT_PAUL_MESSERLY");
	src = addCredits (src, &"CREDIT_ZACH_VOLKER");
	src = addCredits (src, &"CREDIT_HARRY_WALTON");
	src = addCredits (src, &"CREDIT_LEI_YANG");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_TECHNICAL_ANIMATION");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_RICHARD_CHEEK");
	src = addCredits (src, &"CREDIT_ERIC_PIERCE");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ENVIRONMENTAL_ART_LEAD");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_CHRIS_CHERUBINI");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ART");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_BRAD_ALLEN");
	src = addCredits (src, &"CREDIT_PETER_CHEN");
	src = addCredits (src, &"CREDIT_JAMES_CHUNG");
	src = addCredits (src, &"CREDIT_JOEL_EMSLIE");
	src = addCredits (src, &"CREDIT_CHRIS_HASSELL");
	src = addCredits (src, &"CREDIT_JEFF_HEATH");
	src = addCredits (src, &"CREDIT_OSCAR_LOPEZ");
	src = addCredits (src, &"CREDIT_TAEHOON_OH");
	src = addCredits (src, &"CREDIT_SAMI_ONUR");
	src = addCredits (src, &"CREDIT_VELINDA_PELAYO");
	src = addCredits (src, &"CREDIT_RICHARD_SMITH");
	src = addCredits (src, &"CREDIT_JIWON_SON");
	src = addCredits (src, &"CREDIT_THEERAPOL_SRISUPHAN");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_VISUAL_EFFECTS");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_ROBERT_A_GAINES");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_CONCEPT_ART");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_BRAD_ALLEN");
	src = addCredits (src, &"CREDIT_PAUL_MESSERLY");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ADDITIONAL_ART_ANIMATION");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_MICHAEL_ANDERSON");
	src = addCredits (src, &"CREDIT_JASON_BOESCH");
	src = addCredits (src, &"CREDIT_STEVEN_GIESLER");
	src = addCredits (src, &"CREDIT_JOSH_LOKAN");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_PRODUCTION");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_ERIC_JOHNSEN");
	src = addCredits (src, &"CREDIT_PATRICK_LISTER");
	src = addCredits (src, &"CREDIT_ERIC_RILEY");
	src = addCredits (src, &"CREDIT_DAN_SMITH");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_MANAGEMENT");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_GRANT_COLLIER_CEO");
	src = addCredits (src, &"CREDIT_VINCE_ZAMPELLA_CCO");
	src = addCredits (src, &"CREDIT_JASON_WEST_CTO");
	src = addCredits (src, &"CREDIT_BRYAN_KUHN_SYSTEM_ADMINISTRATOR");
	src = addCredits (src, &"CREDIT_JANICE_TURNER_OFFICE_MANAGER");
	src = addCredits (src, &"CREDIT_MICHAEL_NICHOLS_SENIOR_RECRUITER");
	src = addCredits (src, &"CREDIT_LACEY_BRONSON_EXECUTIVE_ASSISTANT");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_MUSIC");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_GRAEME_REVELL_ORIGINAL_SCORE");
	src = addCredits (src, &"CREDIT_MARK_CURRY_MIXING");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_SOUND_DESIGN");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_MARC_GANUS");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_SOUND_DESIGN");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_EARBASH_AUDIO_INC");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_SCRIPT");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_MICHAEL_SCHIFFER_SCRIPTWRITING");
	src = addCredits (src, &"CREDIT_STEVE_FUKUDA_ADDITIONAL_SCRIPTWRITING");
	src = addCredits (src, &"CREDIT_ZIED_RIEKE_ADDITIONAL_SCRIPTWRITING");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_TESTERS");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_WINYAN_JAMES");
	src = addCredits (src, &"CREDIT_ALEXANDER_SHARRIGAN");
	src = addCredits (src, &"CREDIT_KEVIN_PAI");
	src = addCredits (src, &"CREDIT_CLIVE_HAWKINS");
	src = addCredits (src, &"CREDIT_ED_HARMER");
	src = addCredits (src, &"CREDIT_VAUGHN_VARTANIAN");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_VOICE");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_KEITH_AREM_VOICE_DIRECTION_DIALOG_ENGINEERING");
	src = addCredits (src, &"CREDIT_STEVE_FUKUDA_ADDITIONAL_VOICE_DIRECTION");
	src = addCredits (src, &"CREDIT_LINDA_ROSEMEIER_VOICE_EDITING_INTEGRATION");
	src = addCredits (src, &"CREDIT_MAURICIO_BALVANERA_ADDITIONAL_VOICE_EDITING");
	src = addCredits (src, &"CREDIT_PCB_PRODUCTIONS_RECORDING_FACILITIES");
	src = addCredits (src, &"CREDIT_DIGITAL_SYNAPSE_CASTING_AND_SIGNATORY_SERVICES");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_VOICE_TALENT");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_MICHAEL_CUDLITZ");
	src = addCredits (src, &"CREDIT_RICK_GOMEZ");
	src = addCredits (src, &"CREDIT_FRANK_JOHN_HUGHES");
	src = addCredits (src, &"CREDIT_JAMES_MADIO");
	src = addCredits (src, &"CREDIT_ROSS_MCCALL");
	src = addCredits (src, &"CREDIT_RENE_MORENO");
	src = addCredits (src, &"CREDIT_RICHARD_SPEIGHT_JR");
	src = addCredits (src, &"CREDIT_JOSH_GOMEZ");
	src = addCredits (src, &"CREDIT_JACK_ANGEL");
	src = addCredits (src, &"CREDIT_DAVID_COOLEY");
	src = addCredits (src, &"CREDIT_JD_CULLUM");
	src = addCredits (src, &"CREDIT_HARRY_VAN_GORKUM");
	src = addCredits (src, &"CREDIT_MICHAEL_GOUGH");
	src = addCredits (src, &"CREDIT_MARK_IVANIR");
	src = addCredits (src, &"CREDIT_MATT_LINQUIST");
	src = addCredits (src, &"CREDIT_JOHN_MARIANO");
	src = addCredits (src, &"CREDIT_NOLAND_NORTH");
	src = addCredits (src, &"CREDIT_CHUCK_ONEIL");
	src = addCredits (src, &"CREDIT_PHIL_PROCTOR");
	src = addCredits (src, &"CREDIT_CIARAN_REILLY");
	src = addCredits (src, &"CREDIT_JOHN_RUBINOW");
	src = addCredits (src, &"CREDIT_HANS_SCHOEBER");
	src = addCredits (src, &"CREDIT_THOMAS_SCHUMANN");
	src = addCredits (src, &"CREDIT_JULIAN_STONE");
	src = addCredits (src, &"CREDIT_JAMES_PATRICK_STUART");
	src = addCredits (src, &"CREDIT_COURTNAY_TAYLOR");
	src = addCredits (src, &"CREDIT_KAI_WULLF");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_MODELS");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_DAVID_ADKISSON");
	src = addCredits (src, &"CREDIT_MOHAMMAD_BADMOFO_ALAVI");
	src = addCredits (src, &"CREDIT_MICHAEL_BOON");
	src = addCredits (src, &"CREDIT_GRANT_COLLIER");
	src = addCredits (src, &"CREDIT_DIANA_DENCKER");
	src = addCredits (src, &"CREDIT_JOHN_DUGAN");
	src = addCredits (src, &"CREDIT_JAROM_ELLSWORTH");
	src = addCredits (src, &"CREDIT_JOEL_EMSLIE");
	src = addCredits (src, &"CREDIT_FRANCESCO_GIGLIOTTI");
	src = addCredits (src, &"CREDIT_CHANCE_GLASCO");
	src = addCredits (src, &"CREDIT_PRESTON_GLENN");
	src = addCredits (src, &"CREDIT_ERIC_JOHNSEN");
	src = addCredits (src, &"CREDIT_FRANK_KLESIC");
	src = addCredits (src, &"CREDIT_PAUL_MESSERLY");
	src = addCredits (src, &"CREDIT_DAVID_MUTCHLER");
	src = addCredits (src, &"CREDIT_SPIRO_PAPASTATHOPOULOS");
	src = addCredits (src, &"CREDIT_ERIC_PIERCE");
	src = addCredits (src, &"CREDIT_JON_PORTER");
	src = addCredits (src, &"CREDIT_ABE_SCHEVERMANN");
	src = addCredits (src, &"CREDIT_JOHN_SCHWABL");
	src = addCredits (src, &"CREDIT_ALEXANDER_SHARRIGAN");
	src = addCredits (src, &"CREDIT_DAN_SMITH");
	src = addCredits (src, &"CREDIT_RICHARD_SMITH");
	src = addCredits (src, &"CREDIT_HARRY_WALTON");
	src = addCredits (src, &"CREDIT_CHRIS_WOLFE");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_HISTORICAL_MILITARY_ADVISORS");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_EMILIO_CUESTA");
	src = addCredits (src, &"CREDIT_JOHN_HILLEN");
	src = addCredits (src, &"CREDIT_HANK_KEIRSEY");
	src = addCredits (src, &"CREDIT_MIKE_PHILIPS");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_PRODUCTION_BABIES");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_BABY_ELLA_CHUNG_AND_MOTHER_JULIE");
	src = addCredits (src, &"CREDIT_BABY_TRIPLETS");
	src = addCredits (src, &"CREDIT_BABY_DAKOTA_VOLKER_AND_MOTHER_STACI");
	src = addCredits (src, &"CREDIT_BABY_ALEXANDRA_WEST_AND_MOTHER_ADRIANA");
	src = addCredits (src, &"CREDIT_BABY_KYLE_ZAMPELLA_AND_MOTHER_BRIGITTE");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_FOCUS_GROUP_TEST");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_DEREK_CANADAY");
	src = addCredits (src, &"CREDIT_GREG_NELSON");
	src = addCredits (src, &"CREDIT_DAVID_PERLICH");
	src = addCredits (src, &"CREDIT_MILTON_VALENCIA");
	src = addCredits (src, &"CREDIT_RAINE_WOLT");
	src = addCredits (src, &"CREDIT_CAMERON_WOODPARK");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_SPECIAL_THANKS");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_MELISSA_BURKART");
	src = addCredits (src, &"CREDIT_LOUIS_FELIX");
	src = addCredits (src, &"CREDIT_RYAN_MICHAEL");
	src = addCredits (src, &"CREDIT_KEN_TURNER");
	src = addCredits (src, &"CREDIT_AMERICAN_SOCIETY_OF_MILITARY_HISTORY");
	src = addCredits (src, &"CREDIT_LONG_MOUNTAIN_OUTFITTERS");
	src = addCredits (src, &"CREDIT_RUSTY_SPITZER");
	src = addCredits (src, &"CREDIT_CENTRAL_CASTING");
	src = addCredits (src, &"CREDIT_THE_ANT_FARM");
	src = addCredits (src, &"CREDIT_LEN_LOMELL");
	src = addCredits (src, &"CREDIT_IW_NATION");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_VERY_SPECIAL_THANKS");
//	src = addBlank (src);
	src = addCredits (src, &"CREDIT_SERVICETHANKS", 1.0);
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_ACTIVISION");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_PRODUCTION");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_PRODUCER");
	src = addCredits (src, &"CREDIT_ATVI_KEN_MURPHY");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_ASSOCIATE_PRODUCERS");	
	src = addCredits (src, &"CREDIT_ATVI_ERIC_LEE");
	src = addCredits (src, &"CREDIT_ATVI_IAN_STEVENS");
	src = addCredits (src, &"CREDIT_ATVI_STEVE_HOLMES");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_PRODUCTION_COORDINATORS");
	src = addCredits (src, &"CREDIT_ATVI_PATRICK_BOWMAN");
	src = addCredits (src, &"CREDIT_ATVI_NATHANIEL_MCCLURE");
	src = addCredits (src, &"CREDIT_ATVI_PETER_MURAVEZ");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_PRODUCTION_TESTERS");
	src = addCredits (src, &"CREDIT_ATVI_JOSHUA_FEINMAN");
	src = addCredits (src, &"CREDIT_ATVI_RHETT_CHASSEREAU");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_VICE_PRESIDENT_NORTH_AMERICAN_STUDIOS");
	src = addCredits (src, &"CREDIT_ATVI_MARK_LAMIA");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_EXECUTIVE_PRODUCER");
	src = addCredits (src, &"CREDIT_ATVI_THAINE_LYMAN");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_HEAD_OF_WORLDWIDE_STUDIOS");
	src = addCredits (src, &"CREDIT_ATVI_CHUCK_HUEBNER");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_GLOBAL_BRAND_MANAGEMENT");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_BRAND_MANAGER");
	src = addCredits (src, &"CREDIT_ATVI_RICHARD_BREST");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_ASSOCIATE_BRAND_MANAGER");
	src = addCredits (src, &"CREDIT_ATVI_TIM_HENRY");
	src = addCredits (src, &"CREDIT_ATVI_RYAN_WENER");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_DIRECTOR_GLOBAL_BRAND_MANAGEMENT");
	src = addCredits (src, &"CREDIT_ATVI_KIM_SALZER");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_VICE_PRESIDENT_GLOBAL_BRAND_MANAGEMENT");
	src = addCredits (src, &"CREDIT_ATVI_DUSTY_WELCH");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_HEAD_OF_GLOBAL_BRAND_MANAGEMENT");
	src = addCredits (src, &"CREDIT_ATVI_ROBIN_KAMINSKY");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_SENIOR_PUBLICIST");
	src = addCredits (src, &"CREDIT_ATVI_MIKE_MANTARRO");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_PUBLICIST");
	src = addCredits (src, &"CREDIT_ATVI_MACLEAN_MARSHALL");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_PUBLIC_RELATIONS");
	src = addCredits (src, &"CREDIT_ATVI_NEIL_WOOD_AND_JON_LENAWAY");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_JUNIOR_PUBLICIST");
	src = addCredits (src, &"CREDIT_ATVI_MEGAN_KORNS");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_DIRECTOR_CORP_COMMUNICATIONS");
	src = addCredits (src, &"CREDIT_ATVI_MICHELLE_SCHRODER");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_SENIOR_VICE_PRESIDENT_NORTH_AMERICAN_SALES");
	src = addCredits (src, &"CREDIT_ATVI_MARIA_STIPP");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_DIRECTOR_TRADE_MARKETING");
	src = addCredits (src, &"CREDIT_ATVI_STEVE_YOUNG");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_TRADE_MARKETING_MANAGER");
	src = addCredits (src, &"CREDIT_ATVI_CELESTE_MURILLO");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_CENTRAL_TECHNOLOGY");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_SENIOR_MANAGER");
	src = addCredits (src, &"CREDIT_ATVI_EDWARD_CLUNE");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_INSTALLER_PROGRAMMER");
	src = addCredits (src, &"CREDIT_ATVI_MIKE_RESTIFO");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_CENTRAL_LOCALIZATIONS");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_VICE_PRESIDENT_STUDIO_PLANNING_AND_OPERATIONS");
	src = addCredits (src, &"CREDIT_ATVI_BRIAN_WARD");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_SENIOR_LOCALIZATION_MANAGER");
	src = addCredits (src, &"CREDIT_ATVI_TAMSIN_LUCAS");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_CENTRAL_LOCALIZATIONS_US");
	src = addCredits (src, &"CREDIT_ATVI_STEPHANIE_OMALLEY_DEMING");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_LOCALIZATION_PROJECT_MANAGER");
	src = addCredits (src, &"CREDIT_ATVI_DOUG_AVERY");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_LOCALIZATION_TOOLS");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_INFORMATION_TECHNOLOGY");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_VICE_PRESIDENT_IT");
	src = addCredits (src, &"CREDIT_ATVI_NEIL_ARMSTRONG");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_IT_TECHNICIAN");
	src = addCredits (src, &"CREDIT_ATVI_RICARDO_ROMERO");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_QUALITY_ASSURANCECUSTOMER_SUPPORT");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_PROJECT_LEAD");
	src = addCredits (src, &"CREDIT_ATVI_ERIK_MELEN");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_SENIOR_PROJECT_LEAD");
	src = addCredits (src, &"CREDIT_ATVI_GLENN_VISTANTE");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_QA_SENIOR_MANAGER");
	src = addCredits (src, &"CREDIT_ATVI_MARILENA_RIXFORD");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_FLOOR_LEAD");
	src = addCredits (src, &"CREDIT_ATVI_SEAN_BERRETT");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_SP_COORDINATOR");
	src = addCredits (src, &"CREDIT_ATVI_EDWARD_HIGHFIELD");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_MP_COORDINATOR");
	src = addCredits (src, &"CREDIT_ATVI_DEAN_LAMANA");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_DATABASE_MANAGER");
	src = addCredits (src, &"CREDIT_ATVI_GIANCARLO_CONTRERAS");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_TESTERS");
	src = addCredits (src, &"CREDIT_ATVI_JOHN_AGUADO");
	src = addCredits (src, &"CREDIT_ATVI_BRENDAN_BENCHARIT");
	src = addCredits (src, &"CREDIT_ATVI_JONATHAN_BUTCHER");
	src = addCredits (src, &"CREDIT_ATVI_ERIC_CACIOPPO");
	src = addCredits (src, &"CREDIT_ATVI_DOV_CARSON");
	src = addCredits (src, &"CREDIT_ATVI_CHRIS_CHENG");
	src = addCredits (src, &"CREDIT_ATVI_CLAUDE_CONKRITE");
	src = addCredits (src, &"CREDIT_ATVI_TRAVIS_CUMMINGS");
	src = addCredits (src, &"CREDIT_ATVI_ANTHONY_FLAMER");
	src = addCredits (src, &"CREDIT_ATVI_VICTOR_GONZALEZ");
	src = addCredits (src, &"CREDIT_ATVI_MICHAEL_HARRIS");
	src = addCredits (src, &"CREDIT_ATVI_MICHAEL_HUTCHINSON");
	src = addCredits (src, &"CREDIT_ATVI_KENNETH_KERR");
	src = addCredits (src, &"CREDIT_ATVI_ADAM_LUSKIN");
	src = addCredits (src, &"CREDIT_ATVI_ALBERT_MOORE_JR");
	src = addCredits (src, &"CREDIT_ATVI_AARON_MOSNY");
	src = addCredits (src, &"CREDIT_ATVI_SEAN_OLSON");
	src = addCredits (src, &"CREDIT_ATVI_DAVID_ROJAS");
	src = addCredits (src, &"CREDIT_ATVI_RICARDO_REYES");
	src = addCredits (src, &"CREDIT_ATVI_JASON_YU");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_EXTERNAL_TEST_COORDINATOR");
	src = addCredits (src, &"CREDIT_ATVI_CHAD_SIEDHOFF");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_NETWORK_SENIOR_LEAD");
	src = addCredits (src, &"CREDIT_ATVI_CHRIS_KEIM");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_NETWORK_LEAD");
	src = addCredits (src, &"CREDIT_ATVI_FRANCIS_JIMENEZ");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_NETWORK_TESTERS");
	src = addCredits (src, &"CREDIT_ATVI_KIRK_MCNESBY");
	src = addCredits (src, &"CREDIT_ATVI_JESSIE_JONES");
	src = addCredits (src, &"CREDIT_ATVI_NICHOLAS_BORUNDA");
	src = addCredits (src, &"CREDIT_ATVI_CHRIS_FREIRE");
	src = addCredits (src, &"CREDIT_ATVI_WARREN_PATTEN");
	src = addCredits (src, &"CREDIT_ATVI_ERIC_T_SEARS");
	src = addCredits (src, &"CREDIT_ATVI_MATTHEW_FEWTRELL");
	src = addCredits (src, &"CREDIT_ATVI_KEN_PRUSH");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_COMPATIBILITY_SENIOR_LEAD");
	src = addCredits (src, &"CREDIT_ATVI_NEIL_BARIZO");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_SENIOR_COMPATIBILITY_TECHNICIAN");
	src = addCredits (src, &"CREDIT_ATVI_CHRIS_NEAL");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_COMPATIBILITY_TESTERS");
	src = addCredits (src, &"CREDIT_ATVI_SEAN_OLSON");
	src = addCredits (src, &"CREDIT_ATVI_JOHN_DESHAZER");
	src = addCredits (src, &"CREDIT_ATVI_JASON_SA");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_SENIOR_MANAGER_CODE_RELEASE_GROUP");
	src = addCredits (src, &"CREDIT_ATVI_TIM_VANLAW");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_LEAD_CODE_RELEASE_GROUP");
	src = addCredits (src, &"CREDIT_ATVI_JEF_SEDIVY");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_CRG_FLOOR_LEAD");
	src = addCredits (src, &"CREDIT_ATVI_KIMBERLY_PARK");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_CRG_TESTERS");
	src = addCredits (src, &"CREDIT_ATVI_ERIC_STANZIONE");
	src = addCredits (src, &"CREDIT_ATVI_DAN_SAFFRON");
	src = addCredits (src, &"CREDIT_ATVI_RANDY_COFFMAN");
	src = addCredits (src, &"CREDIT_ATVI_RAY_AVILA");
	src = addCredits (src, &"CREDIT_ATVI_NAOMI_PALERMO");
	src = addCredits (src, &"CREDIT_ATVI_NEIL_KHURANA");
	src = addCredits (src, &"CREDIT_ATVI_CALVIN_CAMERON");
	src = addCredits (src, &"CREDIT_ATVI_RAM_PITCHUMANI");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_LOCALIZATIONS_PROJECT_LEAD");
	src = addCredits (src, &"CREDIT_ATVI_SCOTT_KIEFER");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_NIGHT_CREW_SENIOR_LEAD");
	src = addCredits (src, &"CREDIT_ATVI_JEFFRY_MOXLEY");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_NIGHT_CREW_MANAGER");
	src = addCredits (src, &"CREDIT_ATVI_ADAM_HARTSFIELD");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_FLOOR_LEAD");
	src = addCredits (src, &"CREDIT_ATVI_KAI_HSU");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_LOCALIZATIONS_TESTERS");
	src = addCredits (src, &"CREDIT_ATVI_ALEX_J_HAN");
	src = addCredits (src, &"CREDIT_ATVI_BERSON_LIN");
	src = addCredits (src, &"CREDIT_ATVI_BRIAN_JENKINS");
	src = addCredits (src, &"CREDIT_ATVI_JONATHON_MANIMTIM");
	src = addCredits (src, &"CREDIT_ATVI_WILLIAM_KEMPENICH");
	src = addCredits (src, &"CREDIT_ATVI_JUSTIN_REID");
	src = addCredits (src, &"CREDIT_ATVI_JOEL_MCWILLIAMS");
	src = addCredits (src, &"CREDIT_ATVI_BRYAN_PAPA");
	src = addCredits (src, &"CREDIT_ATVI_RONALD_RUHL");
	src = addCredits (src, &"CREDIT_ATVI_DON_FOLEY");
	src = addCredits (src, &"CREDIT_ATVI_DIEGO_RAYA");
	src = addCredits (src, &"CREDIT_ATVI_JEFF_MITCHELL");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_CUSTOMER_SUPPORT_LEAD_PHONE_SUPPORT");
	src = addCredits (src, &"CREDIT_ATVI_GARY_BOLDUC");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_CUSTOMER_SUPPORT_LEAD_EMAIL_SUPPORT");
	src = addCredits (src, &"CREDIT_ATVI_MICHAEL_HILL");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_ACTIVISION_SPECIAL_THANKS");
	src = addCredits (src, &"CREDIT_ATVI_MIKE_GRIFFITH");
	src = addCredits (src, &"CREDIT_ATVI_RON_DOORNICK");
	src = addCredits (src, &"CREDIT_ATVI_KATHY_VRABECK");
	src = addCredits (src, &"CREDIT_ATVI_CHUCK_HUEBNER");
	src = addCredits (src, &"CREDIT_ATVI_ROBIN_KAMINSKY");
	src = addCredits (src, &"CREDIT_ATVI_SAM_NOURIANI");
	src = addCredits (src, &"CREDIT_ATVI_BRIAN_PASS");
	src = addCredits (src, &"CREDIT_ATVI_JONATHAN_MOSES");
	src = addCredits (src, &"CREDIT_ATVI_GLENN_IGE");
	src = addCredits (src, &"CREDIT_ATVI_DOUG_PEARSON");
	src = addCredits (src, &"CREDIT_ATVI_DANNY_TAYLOR");
	src = addCredits (src, &"CREDIT_ATVI_EAIN_BANKINS");
	src = addCredits (src, &"CREDIT_ATVI_LETTY_CADENA");
	src = addCredits (src, &"CREDIT_ATVI_BRYAN_JURY");
	src = addCredits (src, &"CREDIT_ATVI_PETER_MURAVEZ");
	src = addCredits (src, &"CREDIT_ATVI_JEREMY_MONROE");
	src = addCredits (src, &"CREDIT_ATVI_KEKOA_LEECREEL");
	src = addCredits (src, &"CREDIT_ATVI_TAYLOR_LIVINGSTON");
	src = addBlank (src);
	src = addCreditsBold (src, &"CREDIT_ATVI_ACTIVISION_VERY_SPECIAL_THANKS");
	src = addCredits (src, &"CREDIT_ATVI_LEN_BUD_LOMELL");
	src = addBlank (src);
	src = addCredits (src, &"CREDIT_ATVI_CHAPTER_BRIEFING_HISTORICAL_IMAGES", 1.0);
	src = addBlank (src);
	src = addCredits (src, &"CREDIT_ATVI_ADDRESS_AT_THE_US_RANGER_MONUMENT", 1.0);
	src = addBlank (src);
	src = addCredits (src, &"CREDIT_ATVI_ORDER_OF_THE_DAY_SPEECH", 1.0);
	src = addBlank (src);
	src = addCredits (src, &"CREDIT_ATVI_INTRODUCTION_CINEMATIC", 1.0);
	src = addCredits (src, &"CREDIT_ATVI_THE_ANT_FARM", 1.0);

	
	
	black = [];
//	if (getcvar ("start") == "start")
//	if (0)
	{
		height = 60;
		height = 100;
		black[0] = newHudElem();
		black[1] = newHudElem();
		for (i=0;i<black.size;i++)
		{
			black[i].x = -120;
			black[i].y = 0;
//			black[i].alignX = "center";
//			black[i].alignY = "middle";
			black[i].foreground = 1;
			black[i] setShader("black", 880, height);
			black[i].alpha = 1;
		}
		
		black[0].y = 480-height;

		black[2] = newHudElem();
		black[2].x = -120;
		black[2].y = 0;
		black[2].foreground = 1;
		black[2] setShader("black", 880, 480);
		black[2].alpha = 1;
//		black[2] fadeOverTime (2);
		if (level.check)
			thread fadeout (black[2]);
		level.screenOverlay	= black[2];
	}
//	black[0].sort = 2000;
//	black[1].sort = 2000;
	
	for (i=0;i<black.size;i++)
		black[i].sort = 5;
	
	wait (0.05);
	
	timer = 0;
	index = 0;
	
	creditAddTime = 900;
	if (level.xenon) // more space on xenon
		creditAddTime = 1000;
		
	while (1)
	{
		if (gettime() < timer)
		{
			wait (0.05);
			continue;
		}

		if (index+2 >= src.size)
			flag_set("ready to end");
		
		level thread launchCredit (src[index]);
//		timer = gettime() + 1000;
		timer = gettime() + creditAddTime;
		index++;
		if (index >= src.size)
			break;
	}
	
}

fadeout (elem)
{
	wait (1);
	elem fadeOverTime (2);
	elem.alpha = 0;
}

fadein (elem)
{
	wait (1);
	elem fadeOverTime (2);
	elem.alpha = 1;
}
		
launchCredit (src)
{			
	if (src.blank)
		return;


	if (flag("ready to end"))
		ender = true;
	else
		ender = false;
		
	newStr = newHudElem();
	newStr setText(src.string);
//	newStr.placement = src.placement;
//	newStr.location = src.location;
	newStr.sort = src.sort;
	newStr.fontScale = src.fontScale;
	// Move words back to center after visual credits end
	if ((newStr.fontScale == level.bigFont) && (flag("move_center")))
	{
		if (level.check)
			level.won = true;
		level.check = false;
	}
	newStr.alignX = src.alignX;
	newStr.horzAlign = src.horzAlign;
	
	newStr.x = -7;
	newStr.foreground = 1;
		
	if (!level.check)
	{
		newStr.alignX = "center";
		newStr.horzAlign = "center";
//		newStr.x = 320;
	}
		
	fade = "in";	
	newStr.alpha = 0;
	newStr fadeOverTime (level.globalTimer/6);
	newStr.alpha = 1;
	
	placement = 370;
//	timer = 17;
	timer = level.globalTimer;
	
	newStr.y = 370;
	newStr moveOverTime(timer);
	newStr.y = 100;
	wait (timer - (level.globalTimer/6));
	newStr fadeOverTime (level.globalTimer/6);
	newStr.alpha = 0;
	wait (2);

	newStr destroy();	
	if (!ender)
		return;

	wait (1);
	flag_set ("credits done");
}
	


precacheCredits ()
{
	precacheString(&"CREDIT_INFINITY_WARD");
	precacheString(&"CREDIT_PRODUCTION");
	precacheString(&"CREDIT_ABE_SCHEVERMANN");
	precacheString(&"CREDIT_ADDITIONAL_ART_ANIMATION");
	precacheString(&"CREDIT_ADDITIONAL_ENGINEERING");
	precacheString(&"CREDIT_ALEXANDER_SHARRIGAN");
	precacheString(&"CREDIT_AMERICAN_SOCIETY_OF_MILITARY_HISTORY");
	precacheString(&"CREDIT_ANIMATION");
	precacheString(&"CREDIT_ART");
	precacheString(&"CREDIT_ART_DIRECTOR");
	precacheString(&"CREDIT_ART_LEAD");
	precacheString(&"CREDIT_AUDIO_LEAD");
	precacheString(&"CREDIT_BABY_ALEXANDRA_WEST_AND_MOTHER_ADRIANA");
	precacheString(&"CREDIT_BABY_DAKOTA_VOLKER_AND_MOTHER_STACI");
	precacheString(&"CREDIT_BABY_ELLA_CHUNG_AND_MOTHER_JULIE");
	precacheString(&"CREDIT_BABY_KYLE_ZAMPELLA_AND_MOTHER_BRIGITTE");
	precacheString(&"CREDIT_BABY_TRIPLETS");
	precacheString(&"CREDIT_BEN_BASTIAN");
	precacheString(&"CREDIT_BRAD_ALLEN");
	precacheString(&"CREDIT_BRENT_MCLEOD");
	precacheString(&"CREDIT_BRIAN_GILMAN");
	precacheString(&"CREDIT_BRIAN_LANGEVIN");
	precacheString(&"CREDIT_BRYAN_KUHN");
	precacheString(&"CREDIT_BRYAN_KUHN_SYSTEM_ADMINISTRATOR");
	precacheString(&"CREDIT_BRYAN_PEARSON");
	precacheString(&"CREDIT_CAMERON_WOODPARK");
	precacheString(&"CREDIT_CENTRAL_CASTING");
	precacheString(&"CREDIT_CHAD_BARB");
	precacheString(&"CREDIT_CHAD_GRENIER");
	precacheString(&"CREDIT_CHANCE_GLASCO");
	precacheString(&"CREDIT_CHRIS_CHERUBINI");
	precacheString(&"CREDIT_CHRIS_HASSELL");
	precacheString(&"CREDIT_CHRIS_WOLFE");
	precacheString(&"CREDIT_CHUCK_ONEIL");
	precacheString(&"CREDIT_CIARAN_REILLY");
	precacheString(&"CREDIT_CLIVE_HAWKINS");
	precacheString(&"CREDIT_CONCEPT_ART");
	precacheString(&"CREDIT_COURTNAY_TAYLOR");
	precacheString(&"CREDIT_DAN_SMITH");
	precacheString(&"CREDIT_DAVID_ADKISSON");
	precacheString(&"CREDIT_DAVID_COOLEY");
	precacheString(&"CREDIT_DAVID_MUTCHLER");
	precacheString(&"CREDIT_DAVID_PERLICH");
	precacheString(&"CREDIT_DEREK_CANADAY");
	precacheString(&"CREDIT_DESIGN_LEADS");
	precacheString(&"CREDIT_DIANA_DENCKER");
	precacheString(&"CREDIT_DIGITAL_SYNAPSE_CASTING_AND_SIGNATORY_SERVICES");
	precacheString(&"CREDIT_EARL_HAMMON_JR");
	precacheString(&"CREDIT_ED_HARMER");
	precacheString(&"CREDIT_EMILIO_CUESTA");
	precacheString(&"CREDIT_ENGINEERING");
	precacheString(&"CREDIT_ENGINEERING_LEADS");
	precacheString(&"CREDIT_ENVIRONMENTAL_ART_LEAD");
	precacheString(&"CREDIT_ERIC_JOHNSEN");
	precacheString(&"CREDIT_ERIC_PIERCE");
	precacheString(&"CREDIT_ERIC_RILEY");
	precacheString(&"CREDIT_EXECUTIVE_PRODUCER");
	precacheString(&"CREDIT_FOCUS_GROUP_TEST");
	precacheString(&"CREDIT_FRANCESCO_GIGLIOTTI");
	precacheString(&"CREDIT_FRANK_JOHN_HUGHES");
	precacheString(&"CREDIT_FRANK_KLESIC");
	precacheString(&"CREDIT_GEOFF_SMITH");
	precacheString(&"CREDIT_GRAEME_REVELL_ORIGINAL_SCORE");
	precacheString(&"CREDIT_GRANT_COLLIER");
	precacheString(&"CREDIT_GRANT_COLLIER_CEO");
	precacheString(&"CREDIT_GREG_NELSON");
	precacheString(&"CREDIT_HANK_KEIRSEY");
	precacheString(&"CREDIT_HANS_SCHOEBER");
	precacheString(&"CREDIT_HARRY_VAN_GORKUM");
	precacheString(&"CREDIT_HARRY_WALTON");
	precacheString(&"CREDIT_HISTORICAL_MILITARY_ADVISORS");
	precacheString(&"CREDIT_HYUN_JIN_CHO");
	precacheString(&"CREDIT_IW_NATION");
	precacheString(&"CREDIT_JACK_ANGEL");
	precacheString(&"CREDIT_JAMES_CHUNG");
	precacheString(&"CREDIT_JAMES_MADIO");
	precacheString(&"CREDIT_JAMES_PATRICK_STUART");
	precacheString(&"CREDIT_JANICE_TURNER_OFFICE_MANAGER");
	precacheString(&"CREDIT_JAROM_ELLSWORTH");
	precacheString(&"CREDIT_JASON_BOESCH");
	precacheString(&"CREDIT_JASON_WEST");
	precacheString(&"CREDIT_JASON_WEST_CTO");
	precacheString(&"CREDIT_JD_CULLUM");
	precacheString(&"CREDIT_JEFF_HEATH");
	precacheString(&"CREDIT_JIESANG_SONG");
	precacheString(&"CREDIT_JIWON_SON");
	precacheString(&"CREDIT_JOEL_EMSLIE");
	precacheString(&"CREDIT_JOEL_GOMPERT");
	precacheString(&"CREDIT_JOHN_DUGAN");
	precacheString(&"CREDIT_JOHN_HILLEN");
	precacheString(&"CREDIT_JOHN_MARIANO");
	precacheString(&"CREDIT_JOHN_RUBINOW");
	precacheString(&"CREDIT_JOHN_SCHWABL");
	precacheString(&"CREDIT_JON_PORTER");
	precacheString(&"CREDIT_JON_SHIRING");
	precacheString(&"CREDIT_JOSH_GOMEZ");
	precacheString(&"CREDIT_JOSH_LOKAN");
	precacheString(&"CREDIT_JULIAN_STONE");
	precacheString(&"CREDIT_KAI_WULLF");
	precacheString(&"CREDIT_KEITH_NED_BELL");
	precacheString(&"CREDIT_KEITH_AREM_VOICE_DIRECTION_DIALOG_ENGINEERING");
	precacheString(&"CREDIT_KEN_TURNER");
	precacheString(&"CREDIT_KEVIN_PAI");
	precacheString(&"CREDIT_LACEY_BRONSON_EXECUTIVE_ASSISTANT");
	precacheString(&"CREDIT_LEI_YANG");
	precacheString(&"CREDIT_LEN_LOMELL");
	precacheString(&"CREDIT_LEVEL_DESIGN");
	precacheString(&"CREDIT_LINDA_ROSEMEIER_VOICE_EDITING_INTEGRATION");
	precacheString(&"CREDIT_LONG_MOUNTAIN_OUTFITTERS");
	precacheString(&"CREDIT_LOUIS_FELIX");
	precacheString(&"CREDIT_MACKEY_MCCANDLISH");
	precacheString(&"CREDIT_MANAGEMENT");
	precacheString(&"CREDIT_MARC_GANUS");
	precacheString(&"CREDIT_MARK_CURRY_MIXING");
	precacheString(&"CREDIT_MARK_GRIGSBY");
	precacheString(&"CREDIT_MARK_IVANIR");
	precacheString(&"CREDIT_MATT_LINQUIST");
	precacheString(&"CREDIT_MAURICIO_BALVANERA_ADDITIONAL_VOICE_EDITING");
	precacheString(&"CREDIT_MELISSA_BURKART");
	precacheString(&"CREDIT_MICHAEL_ANDERSON");
	precacheString(&"CREDIT_MICHAEL_BOON");
	precacheString(&"CREDIT_MICHAEL_CUDLITZ");
	precacheString(&"CREDIT_MICHAEL_GOUGH");
	precacheString(&"CREDIT_MICHAEL_NICHOLS_SENIOR_RECRUITER");
	precacheString(&"CREDIT_MICHAEL_SCHIFFER_SCRIPTWRITING");
	precacheString(&"CREDIT_MIKE_PHILIPS");
	precacheString(&"CREDIT_MILTON_VALENCIA");
	precacheString(&"CREDIT_MODELS");
	precacheString(&"CREDIT_MOHAMMAD_BADMOFO_ALAVI");
	precacheString(&"CREDIT_MUSIC");
	precacheString(&"CREDIT_NATHAN_SILVERS");
	precacheString(&"CREDIT_NOLAND_NORTH");
	precacheString(&"CREDIT_OSCAR_LOPEZ");
	precacheString(&"CREDIT_PATRICK_LISTER");
	precacheString(&"CREDIT_PAUL_MESSERLY");
	precacheString(&"CREDIT_PCB_PRODUCTIONS_RECORDING_FACILITIES");
	precacheString(&"CREDIT_PETER_CHEN");
	precacheString(&"CREDIT_PHIL_PROCTOR");
	precacheString(&"CREDIT_PRESTON_GLENN");
	precacheString(&"CREDIT_PRODUCTION_BABIES");
	precacheString(&"CREDIT_RAINE_WOLT");
	precacheString(&"CREDIT_RENE_MORENO");
	precacheString(&"CREDIT_RICHARD_BAKER");
	precacheString(&"CREDIT_RICHARD_CHEEK");
	precacheString(&"CREDIT_RICHARD_KRIEGLER");
	precacheString(&"CREDIT_RICHARD_SMITH");
	precacheString(&"CREDIT_RICHARD_SPEIGHT_JR");
	precacheString(&"CREDIT_RICK_GOMEZ");
	precacheString(&"CREDIT_ROBERT_A_GAINES");
	precacheString(&"CREDIT_ROBERT_FIELD");
	precacheString(&"CREDIT_RODNEY_HOULE");
	precacheString(&"CREDIT_ROGER_ABRAHAMSSON");
	precacheString(&"CREDIT_ROSS_MCCALL");
	precacheString(&"CREDIT_RUSTY_SPITZER");
	precacheString(&"CREDIT_RYAN_MICHAEL");
	precacheString(&"CREDIT_SAMI_ONUR");
	precacheString(&"CREDIT_SARAH_MICHAEL");
	precacheString(&"CREDIT_SCRIPT");
	precacheString(&"CREDIT_SENIOR_DESIGN_LEAD");
	precacheString(&"CREDIT_PROJECT_LEAD");
	precacheString(&"CREDIT_SERVICETHANKS");
	precacheString(&"CREDIT_SOUND_DESIGN");
	precacheString(&"CREDIT_EARBASH_AUDIO_INC");
	precacheString(&"CREDIT_SPECIAL_THANKS");
	precacheString(&"CREDIT_SPIRO_PAPASTATHOPOULOS");
	precacheString(&"CREDIT_STEVE_FUKUDA");
	precacheString(&"CREDIT_STEVE_FUKUDA_ADDITIONAL_SCRIPTWRITING");
	precacheString(&"CREDIT_STEVE_FUKUDA_ADDITIONAL_VOICE_DIRECTION");
	precacheString(&"CREDIT_STEVEN_GIESLER");
	precacheString(&"CREDIT_TAEHOON_OH");
	precacheString(&"CREDIT_TECHNICAL_ANIMATION");	
	precacheString(&"CREDIT_TESTERS");
	precacheString(&"CREDIT_THE_ANT_FARM");
	precacheString(&"CREDIT_THEERAPOL_SRISUPHAN");
	precacheString(&"CREDIT_THOMAS_SCHUMANN");
	precacheString(&"CREDIT_TODD_ALDERMAN");
	precacheString(&"CREDIT_URSULA_ESCHER");
	precacheString(&"CREDIT_VAUGHN_VARTANIAN");
	precacheString(&"CREDIT_VELINDA_PELAYO");
	precacheString(&"CREDIT_VERY_SPECIAL_THANKS");
	precacheString(&"CREDIT_VINCE_ZAMPELLA");
	precacheString(&"CREDIT_VINCE_ZAMPELLA_CCO");
	precacheString(&"CREDIT_VISUAL_EFFECTS");
	precacheString(&"CREDIT_VOICE");
	precacheString(&"CREDIT_VOICE_TALENT");
	precacheString(&"CREDIT_WINYAN_JAMES");
	precacheString(&"CREDIT_ZACH_VOLKER");
	precacheString(&"CREDIT_ZIED_RIEKE");
	precacheString(&"CREDIT_ZIED_RIEKE_ADDITIONAL_SCRIPTWRITING");
	
	precacheString(&"CREDIT_ATVI_ACTIVISION");
	precacheString(&"CREDIT_ATVI_PRODUCTION");
	precacheString(&"CREDIT_ATVI_KEN_MURPHY");
	precacheString(&"CREDIT_ATVI_ERIC_LEE");
	precacheString(&"CREDIT_ATVI_IAN_STEVENS");
	precacheString(&"CREDIT_ATVI_STEVE_HOLMES");
	precacheString(&"CREDIT_ATVI_PATRICK_BOWMAN");
	precacheString(&"CREDIT_ATVI_NATHANIEL_MCCLURE");
	precacheString(&"CREDIT_ATVI_PETER_MURAVEZ");
	precacheString(&"CREDIT_ATVI_JOSHUA_FEINMAN");
	precacheString(&"CREDIT_ATVI_RHETT_CHASSEREAU");
	precacheString(&"CREDIT_ATVI_MARK_LAMIA");
	precacheString(&"CREDIT_ATVI_THAINE_LYMAN");
	precacheString(&"CREDIT_ATVI_CHUCK_HUEBNER");
	precacheString(&"CREDIT_ATVI_GLOBAL_BRAND_MANAGEMENT");
	precacheString(&"CREDIT_ATVI_RICHARD_BREST");
	precacheString(&"CREDIT_ATVI_TIM_HENRY");
	precacheString(&"CREDIT_ATVI_RYAN_WENER");
	precacheString(&"CREDIT_ATVI_KIM_SALZER");
	precacheString(&"CREDIT_ATVI_DUSTY_WELCH");
	precacheString(&"CREDIT_ATVI_ROBIN_KAMINSKY");
	precacheString(&"CREDIT_ATVI_MIKE_MANTARRO");
	precacheString(&"CREDIT_ATVI_MACLEAN_MARSHALL");
	precacheString(&"CREDIT_ATVI_NEIL_WOOD_AND_JON_LENAWAY");
	precacheString(&"CREDIT_ATVI_MEGAN_KORNS");
	precacheString(&"CREDIT_ATVI_MICHELLE_SCHRODER");
	precacheString(&"CREDIT_ATVI_MARIA_STIPP");
	precacheString(&"CREDIT_ATVI_STEVE_YOUNG");
	precacheString(&"CREDIT_ATVI_CELESTE_MURILLO");
	precacheString(&"CREDIT_ATVI_CENTRAL_TECHNOLOGY");
	precacheString(&"CREDIT_ATVI_EDWARD_CLUNE");
	precacheString(&"CREDIT_ATVI_MIKE_RESTIFO");
	precacheString(&"CREDIT_ATVI_CENTRAL_LOCALIZATIONS");
	precacheString(&"CREDIT_ATVI_BRIAN_WARD");
	precacheString(&"CREDIT_ATVI_TAMSIN_LUCAS");
	precacheString(&"CREDIT_ATVI_STEPHANIE_OMALLEY_DEMING");
	precacheString(&"CREDIT_ATVI_DOUG_AVERY");
	precacheString(&"CREDIT_ATVI_LOCALIZATION_TOOLS_AND_SUPPORT");
	precacheString(&"CREDIT_ATVI_INFORMATION_TECHNOLOGY");
	precacheString(&"CREDIT_ATVI_NEIL_ARMSTRONG");
	precacheString(&"CREDIT_ATVI_RICARDO_ROMERO");
	precacheString(&"CREDIT_ATVI_QUALITY_ASSURANCECUSTOMER_SUPPORT");
	precacheString(&"CREDIT_ATVI_ERIK_MELEN");
	precacheString(&"CREDIT_ATVI_GLENN_VISTANTE");
	precacheString(&"CREDIT_ATVI_MARILENA_RIXFORD");
	precacheString(&"CREDIT_ATVI_SEAN_BERRETT");
	precacheString(&"CREDIT_ATVI_EDWARD_HIGHFIELD");
	precacheString(&"CREDIT_ATVI_DEAN_LAMANA");
	precacheString(&"CREDIT_ATVI_GIANCARLO_CONTRERAS");
	precacheString(&"CREDIT_ATVI_JOHN_AGUADO");
	precacheString(&"CREDIT_ATVI_BRENDAN_BENCHARIT");
	precacheString(&"CREDIT_ATVI_JONATHAN_BUTCHER");
	precacheString(&"CREDIT_ATVI_ERIC_CACIOPPO");
	precacheString(&"CREDIT_ATVI_DOV_CARSON");
	precacheString(&"CREDIT_ATVI_CHRIS_CHENG");
	precacheString(&"CREDIT_ATVI_CLAUDE_CONKRITE");
	precacheString(&"CREDIT_ATVI_TRAVIS_CUMMINGS");
	precacheString(&"CREDIT_ATVI_ANTHONY_FLAMER");
	precacheString(&"CREDIT_ATVI_VICTOR_GONZALEZ");
	precacheString(&"CREDIT_ATVI_MICHAEL_HARRIS");
	precacheString(&"CREDIT_ATVI_MICHAEL_HUTCHINSON");
	precacheString(&"CREDIT_ATVI_KENNETH_KERR");
	precacheString(&"CREDIT_ATVI_ADAM_LUSKIN");
	precacheString(&"CREDIT_ATVI_ALBERT_MOORE_JR");
	precacheString(&"CREDIT_ATVI_AARON_MOSNY");
	precacheString(&"CREDIT_ATVI_SEAN_OLSON");
	precacheString(&"CREDIT_ATVI_DAVID_ROJAS");
	precacheString(&"CREDIT_ATVI_RICARDO_REYES");
	precacheString(&"CREDIT_ATVI_JASON_YU");
	precacheString(&"CREDIT_ATVI_CHAD_SIEDHOFF");
	precacheString(&"CREDIT_ATVI_CHRIS_KEIM");
	precacheString(&"CREDIT_ATVI_FRANCIS_JIMENEZ");
	precacheString(&"CREDIT_ATVI_KIRK_MCNESBY");
	precacheString(&"CREDIT_ATVI_JESSIE_JONES");
	precacheString(&"CREDIT_ATVI_NICHOLAS_BORUNDA");
	precacheString(&"CREDIT_ATVI_CHRIS_FREIRE");
	precacheString(&"CREDIT_ATVI_WARREN_PATTEN");
	precacheString(&"CREDIT_ATVI_ERIC_T_SEARS");
	precacheString(&"CREDIT_ATVI_MATTHEW_FEWTRELL");
	precacheString(&"CREDIT_ATVI_KEN_PRUSH");
	precacheString(&"CREDIT_ATVI_NEIL_BARIZO");
	precacheString(&"CREDIT_ATVI_CHRIS_NEAL");
	precacheString(&"CREDIT_ATVI_SEAN_OLSON");
	precacheString(&"CREDIT_ATVI_JOHN_DESHAZER");
	precacheString(&"CREDIT_ATVI_JASON_SA");
	precacheString(&"CREDIT_ATVI_TIM_VANLAW");
	precacheString(&"CREDIT_ATVI_JEF_SEDIVY");
	precacheString(&"CREDIT_ATVI_KIMBERLY_PARK");
	precacheString(&"CREDIT_ATVI_ERIC_STANZIONE");
	precacheString(&"CREDIT_ATVI_DAN_SAFFRON");
	precacheString(&"CREDIT_ATVI_RANDY_COFFMAN");
	precacheString(&"CREDIT_ATVI_RAY_AVILA");
	precacheString(&"CREDIT_ATVI_NAOMI_PALERMO");
	precacheString(&"CREDIT_ATVI_NEIL_KHURANA");
	precacheString(&"CREDIT_ATVI_CALVIN_CAMERON");
	precacheString(&"CREDIT_ATVI_RAM_PITCHUMANI");
	precacheString(&"CREDIT_ATVI_SCOTT_KIEFER");
	precacheString(&"CREDIT_ATVI_JEFFRY_MOXLEY");
	precacheString(&"CREDIT_ATVI_ADAM_HARTSFIELD");
	precacheString(&"CREDIT_ATVI_ALEX_J_HAN");
	precacheString(&"CREDIT_ATVI_BERSON_LIN");
	precacheString(&"CREDIT_ATVI_BRIAN_JENKINS");
	precacheString(&"CREDIT_ATVI_JONATHON_MANIMTIM");
	precacheString(&"CREDIT_ATVI_WILLIAM_KEMPENICH");
	precacheString(&"CREDIT_ATVI_JUSTIN_REID");
	precacheString(&"CREDIT_ATVI_JOEL_MCWILLIAMS");
	precacheString(&"CREDIT_ATVI_BRYAN_PAPA");
	precacheString(&"CREDIT_ATVI_RONALD_RUHL");
	precacheString(&"CREDIT_ATVI_GARY_BOLDUC");
	precacheString(&"CREDIT_ATVI_MICHAEL_HILL");
	precacheString(&"CREDIT_ATVI_ACTIVISION_SPECIAL_THANKS");
	precacheString(&"CREDIT_ATVI_MIKE_GRIFFITH");
	precacheString(&"CREDIT_ATVI_RON_DOORNICK");
	precacheString(&"CREDIT_ATVI_KATHY_VRABECK");
	precacheString(&"CREDIT_ATVI_CHUCK_HUEBNER");
	precacheString(&"CREDIT_ATVI_ROBIN_KAMINSKY");
	precacheString(&"CREDIT_ATVI_SAM_NOURIANI");
	precacheString(&"CREDIT_ATVI_BRIAN_PASS");
	precacheString(&"CREDIT_ATVI_JONATHAN_MOSES");
	precacheString(&"CREDIT_ATVI_GLENN_IGE");
	precacheString(&"CREDIT_ATVI_DOUG_PEARSON");
	precacheString(&"CREDIT_ATVI_DANNY_TAYLOR");
	precacheString(&"CREDIT_ATVI_EAIN_BANKINS");
	precacheString(&"CREDIT_ATVI_LETTY_CADENA");
	precacheString(&"CREDIT_ATVI_BRYAN_JURY");
	precacheString(&"CREDIT_ATVI_PETER_MURAVEZ");
	precacheString(&"CREDIT_ATVI_JEREMY_MONROE");
	precacheString(&"CREDIT_ATVI_KEKOA_LEECREEL");
	precacheString(&"CREDIT_ATVI_TAYLOR_LIVINGSTON");
	precacheString(&"CREDIT_ATVI_ACTIVISION_VERY_SPECIAL_THANKS");
	precacheString(&"CREDIT_ATVI_LEN_BUD_LOMELL");
	precacheString(&"CREDIT_ATVI_CHAPTER_BRIEFING_HISTORICAL_IMAGES");
	precacheString(&"CREDIT_ATVI_ADDRESS_AT_THE_US_RANGER_MONUMENT");
	precacheString(&"CREDIT_ATVI_ORDER_OF_THE_DAY_SPEECH");
	precacheString(&"CREDIT_ATVI_INTRODUCTION_CINEMATIC");
	precacheString(&"CREDIT_ATVI_THE_ANT_FARM");
	precacheString(&"CREDIT_ATVI_PRODUCER");
	precacheString(&"CREDIT_ATVI_ASSOCIATE_PRODUCERS");
	precacheString(&"CREDIT_ATVI_PRODUCTION_COORDINATORS");
	precacheString(&"CREDIT_ATVI_PRODUCTION_TESTERS");
	precacheString(&"CREDIT_ATVI_VICE_PRESIDENT_NORTH_AMERICAN_STUDIOS");
	precacheString(&"CREDIT_ATVI_EXECUTIVE_PRODUCER");
	precacheString(&"CREDIT_ATVI_HEAD_OF_WORLDWIDE_STUDIOS");
	precacheString(&"CREDIT_ATVI_BRAND_MANAGER");
	precacheString(&"CREDIT_ATVI_ASSOCIATE_BRAND_MANAGER");
	precacheString(&"CREDIT_ATVI_ASSOCIATE_BRAND_MANAGER");
	precacheString(&"CREDIT_ATVI_DIRECTOR_GLOBAL_BRAND_MANAGEMENT");
	precacheString(&"CREDIT_ATVI_VICE_PRESIDENT_GLOBAL_BRAND_MANAGEMENT");
	precacheString(&"CREDIT_ATVI_HEAD_OF_GLOBAL_BRAND_MANAGEMENT");
	precacheString(&"CREDIT_ATVI_SENIOR_PUBLICIST");
	precacheString(&"CREDIT_ATVI_PUBLICIST");
	precacheString(&"CREDIT_ATVI_PUBLIC_RELATIONS");
	precacheString(&"CREDIT_ATVI_JUNIOR_PUBLICIST");
	precacheString(&"CREDIT_ATVI_DIRECTOR_CORP_COMMUNICATIONS");
	precacheString(&"CREDIT_ATVI_SENIOR_VICE_PRESIDENT_NORTH_AMERICAN_SALES");
	precacheString(&"CREDIT_ATVI_DIRECTOR_TRADE_MARKETING");
	precacheString(&"CREDIT_ATVI_TRADE_MARKETING_MANAGER");
	precacheString(&"CREDIT_ATVI_SENIOR_MANAGER");
	precacheString(&"CREDIT_ATVI_INSTALLER_PROGRAMMER");
	precacheString(&"CREDIT_ATVI_VICE_PRESIDENT_STUDIO_PLANNING_AND_OPERATIONS");
	precacheString(&"CREDIT_ATVI_SENIOR_LOCALIZATION_MANAGER");
	precacheString(&"CREDIT_ATVI_CENTRAL_LOCALIZATIONS_US");
	precacheString(&"CREDIT_ATVI_LOCALIZATION_PROJECT_MANAGER");
	precacheString(&"CREDIT_ATVI_LOCALIZATION_TOOLS");
	precacheString(&"CREDIT_ATVI_VICE_PRESIDENT_IT");
	precacheString(&"CREDIT_ATVI_IT_TECHNICIAN");
	precacheString(&"CREDIT_ATVI_PROJECT_LEAD");
	precacheString(&"CREDIT_ATVI_SENIOR_PROJECT_LEAD");
	precacheString(&"CREDIT_ATVI_QA_SENIOR_MANAGER");
	precacheString(&"CREDIT_ATVI_FLOOR_LEAD");
	precacheString(&"CREDIT_ATVI_SP_COORDINATOR");
	precacheString(&"CREDIT_ATVI_MP_COORDINATOR");
	precacheString(&"CREDIT_ATVI_DATABASE_MANAGER");
	precacheString(&"CREDIT_ATVI_TESTERS");
	precacheString(&"CREDIT_ATVI_EXTERNAL_TEST_COORDINATOR");
	precacheString(&"CREDIT_ATVI_NETWORK_SENIOR_LEAD");
	precacheString(&"CREDIT_ATVI_NETWORK_LEAD");
	precacheString(&"CREDIT_ATVI_NETWORK_TESTERS");
	precacheString(&"CREDIT_ATVI_COMPATIBILITY_SENIOR_LEAD");
	precacheString(&"CREDIT_ATVI_SENIOR_COMPATIBILITY_TECHNICIAN");
	precacheString(&"CREDIT_ATVI_COMPATIBILITY_TESTERS");
	precacheString(&"CREDIT_ATVI_SENIOR_MANAGER_CODE_RELEASE_GROUP");
	precacheString(&"CREDIT_ATVI_LEAD_CODE_RELEASE_GROUP");
	precacheString(&"CREDIT_ATVI_CRG_FLOOR_LEAD");
	precacheString(&"CREDIT_ATVI_CRG_TESTERS");
	precacheString(&"CREDIT_ATVI_LOCALIZATIONS_PROJECT_LEAD");
	precacheString(&"CREDIT_ATVI_NIGHT_CREW_SENIOR_LEAD");
	precacheString(&"CREDIT_ATVI_NIGHT_CREW_MANAGER");
	precacheString(&"CREDIT_ATVI_LOCALIZATIONS_TESTERS");
	precacheString(&"CREDIT_ATVI_CUSTOMER_SUPPORT_LEAD_PHONE_SUPPORT");
	precacheString(&"CREDIT_ATVI_CUSTOMER_SUPPORT_LEAD_EMAIL_SUPPORT");
	precacheString(&"CREDIT_ATVI_FLOOR_LEAD");
	precacheString(&"CREDIT_ATVI_KAI_HSU");
	precacheString(&"CREDIT_ATVI_DON_FOLEY");
	precacheString(&"CREDIT_ATVI_DIEGO_RAYA");
	precacheString(&"CREDIT_ATVI_JEFF_MITCHELL");	
	
}
