#include common_scripts\utility; 
#include maps\_utility; 

init_credits()
{
	level.hudelem_count = 0;
	level.clienthudelem_count = 0;

	flag_init( "credits_ended" );

	level.linesize = 1.35;
//	level.headingsize = 1.75; 
	level.credit_list = [];
	level.scroll_speed = 35; // 26.7
	level.scroll_dist = 380;
	level.default_line_delay = 0.6;
	level.spacesmall_delay = 0.25;

	PrecacheShader( "black" );
	credits_background();
	
	set_console_status(); 
	
	if( !level.console )
	{
		maps\credits_list_pc::init_treyarch_credits_pc();
		maps\credits_list_pc::init_activision_credits_pc();
	}
	else
	{
		if(level.xenon)
		{
			init_treyarch_credits(); 
			init_activision_credits();
		}
		else if( level.ps3 )
		{
		
			maps\credits_list_ps3::init_treyarch_credits_ps3(); 
			maps\credits_list_ps3::init_activision_credits_ps3();
		}
		else if( level.wii )
		{
			maps\credits_list_wii::init_treyarch_credits_wii();
			maps\credits_list_wii::init_activision_credits_wii();
		}
	}
/#
//	level thread hudelem_count();
#/
}

hudelem_count()
{
	max = 0; 
	clientmax = 0;
	totalmax = 0;
	curr_total = 0;
	while( 1 )
	{
		if( level.hudelem_count > max )
		{
			max = level.hudelem_count;
		}

		if( level.clienthudelem_count > clientmax )
		{
			clientmax = level.clienthudelem_count;
		}		

		curr_total = level.clienthudelem_count + level.hudelem_count;
		if( curr_total > totalmax )
		{
			totalmax = curr_total;
		}		
		
		println( "HudElems: " + level.hudelem_count + "  [Max: " + max + "]" + " | ClientHudElems: " + level.clienthudelem_count + "  [Max: " + clientmax + "] | Total: " + curr_total + "  [Max: " + totalmax + "]" );
		wait( 0.05 );
	}
}

credits_background()
{
	level.hudelem_count++;

	level.bg_hud = NewHudElem();
	level.bg_hud.x = 0;
	level.bg_hud.y = 0;
	level.bg_hud SetShader( "black", 640, 480 );
	level.bg_hud.alignX = "left";
	level.bg_hud.alignY = "top";
	level.bg_hud.horzAlign = "fullscreen";
	level.bg_hud.vertAlign = "fullscreen";
	level.bg_hud.alpha = 1;
	level.bg_hud.sort = 1;
}

init_treyarch_credits()
{
	add_image( "logo_cod2", 512, 128, 5 );
	add_space(); 
	add_space();
	add_space();
	add_heading( &"CREDITS_DEDICATION" );
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	
	add_heading( &"CREDITS_PRODUCTION", 2.0);
	add_space();
	add_heading( &"CREDITS_EXECUTIVE_PRODUCER");
	add_heading( &"CREDITS_DAVE_ANTHONY");
	add_space();
	add_heading( &"CREDITS_SENIOR_PRODUCER");
	add_heading( &"CREDITS_PAT_DWYER");
	add_space();
	add_heading( &"CREDITS_PRODUCER");
	add_heading( &"CREDITS_DANIEL_BUNTING");
	add_space();
	add_heading( &"CREDITS_PRODUCERS");
	add_heading( &"CREDITS_MARWAN_ABDERRAZZAQ");
	add_heading( &"CREDITS_JOHN_DEHART");
	add_space();
	add_heading( &"CREDITS_ASSOCIATE_PRODUCERS");
	add_heading( &"CREDITS_SHANE_SASAKI");
	add_heading( &"CREDITS_JOHN_SHUBERT");
	add_heading( &"CREDITS_GUY_SILLIMAN");
	add_heading( &"CREDITS_BRENT_TODA");
	add_space();
	add_heading( &"CREDITS_PRODUCTION_COORDINATORS");
	add_heading( &"CREDITS_MILES_LESLIE");
	add_heading( &"CREDITS_TYLER_SPARKS");
	add_space();
	add_heading( &"CREDITS_BUILD_MANAGER");
	add_heading( &"CREDITS_MARK_SORIANO");
	add_space();
	add_heading( &"CREDITS_ADDITIONAL_PRODUCTION_SUPPORT");
	add_heading( &"CREDITS_RYAN_GAINES");
	add_heading( &"CREDITS_WILL_KATZ");
	add_heading( &"CREDITS_JAMES_MCCAWLEY");
	add_heading( &"CREDITS_GEOFFREY_NG");
	add_heading( &"CREDITS_NORMAN_OVANDO");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_ENGINEERING", 2.0);
	add_space();
	add_heading( &"CREDITS_PROJECT_TECHNICAL_DIRECTOR");
	add_heading( &"CREDITS_DAVID_KING");
	add_space();
	add_heading( &"CREDITS_SENIOR_DIRECTOR_OF_TECHNOLOGY_ONLINE");
	add_heading( &"CREDITS_JOHN_BOJORQUEZ");
	add_space();
	add_heading( &"CREDITS_TECHNICAL_DIRECTORS_COOP");
	add_heading( &"CREDITS_PAT_GRIFFITH");
	add_heading( &"CREDITS_GAVIN_JAMES");
	add_space();
	add_heading( &"CREDITS_PROJECT_LEAD_ENGINEER");
	add_heading( &"CREDITS_TREVOR_WALKER");
	add_space();
	add_heading( &"CREDITS_LEAD_ENGINEER_ONLINE");
	add_heading( &"CREDITS_ALEX_CONSERVA");
	add_space();
	add_heading( &"CREDITS_SENIOR_ENGINEERS");
	add_heading( &"CREDITS_MARTIN_DONLON");
	add_heading( &"CREDITS_LEI_HU");
	add_heading( &"CREDITS_JOHAN_KOHLER");
	add_heading( &"CREDITS_DAN_LAUFER");
	add_heading( &"CREDITS_RICHARD_MITTON");
	add_heading( &"CREDITS_JAMES_SNIDER");
	add_heading( &"CREDITS_JIVKO_VELEV");
	add_space();
	add_heading( &"CREDITS_ENGINEERS");
	add_heading( &"CREDITS_SUMEET_JAKATDAR");
	add_heading( &"CREDITS_THOMAS_KEEGAN");
	add_heading( &"CREDITS_AUSTIN_KRAUSS");
	add_heading( &"CREDITS_BRYCE_MERCADO");
	add_heading( &"CREDITS_BHARATHWAJ_NANDAKUMAR");
	add_heading( &"CREDITS_DIARMAID_ROCHE");
	add_heading( &"CREDITS_CALEB_SCHNEIDER");
	add_heading( &"CREDITS_LUCAS_SEIBERT");
	add_heading( &"CREDITS_LEO_ZIDE");
	add_space();
	add_heading( &"CREDITS_JUNIOR_ENGINEER");
	add_heading( &"CREDITS_PENNY_CHOCK");
	add_space();
	add_heading( &"CREDITS_ENGINEERING_INTERNS");
	add_heading( &"CREDITS_MARIA_BAROT");
	add_heading( &"CREDITS_JOHANN_LY");
	add_heading( &"CREDITS_JAY_MATTIS");
	add_heading( &"CREDITS_CLAIRE_MITCHELL");
	add_space();
	add_heading( &"CREDITS_ADDITIONAL_ENGINEERING");
	add_heading( &"CREDITS_JED_ADAMS");
	add_heading( &"CREDITS_MIKE_ANTHONY");
	add_heading( &"CREDITS_CHRIS_BANNOCK");
	add_heading( &"CREDITS_SCOTT_BEAN");
	add_heading( &"CREDITS_BRIAN_BLUMENKOPF");
	add_heading( &"CREDITS_WADE_BRAINERD");
	add_heading( &"CREDITS_YANBING_CHEN");
	add_heading( &"CREDITS_CLEVE_CHENG");
	add_heading( &"CREDITS_ADAM_DEMERS");
	add_heading( &"CREDITS_PAUL_EDELSTEIN");
	add_heading( &"CREDITS_JON_EDWARDS");
	add_heading( &"CREDITS_RUSTY_GYGAX");
	add_heading( &"CREDITS_JASON_KEENEY");
	add_heading( &"CREDITS_MATT_KIMBERLING");
	add_heading( &"CREDITS_DEAN_KUSLER");
	add_heading( &"CREDITS_PETER_LIVINGSTONE");
	add_heading( &"CREDITS_JON_MENZIES");
	add_heading( &"CREDITS_JUAN_MORELLI");
	add_heading( &"CREDITS_MARK_MURAKAMI");
	add_heading( &"CREDITS_JOE_NUGENT");
	add_heading( &"CREDITS_EWAN_OUGHTON");
	add_heading( &"CREDITS_JAMIE_PARENT");
	add_heading( &"CREDITS_VALERA_PELOVA");
	add_heading( &"CREDITS_JOE_SCHEINBERG");
	add_heading( &"CREDITS_DIMITER_MALKIA_STANEV");
	add_heading( &"CREDITS_KRASSIMIR_TOUEVSKY");
	add_heading( &"CREDITS_MIKE_UHLIK");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_AUDIO", 2.0);
	add_space();
	add_heading( &"CREDITS_AUDIO_DIRECTOR");
	add_heading( &"CREDITS_BRIAN_TUEY");
	add_space();
	add_heading( &"CREDITS_SENIOR_SOUND_DESIGNER");
	add_heading( &"CREDITS_GARY_SPINRAD");
	add_space();
	add_heading( &"CREDITS_SOUND_DESIGNERS");
	add_heading( &"CREDITS_KEVIN_SHERWOOD");
	add_heading( &"CREDITS_COLLIN_AYERS");
	add_heading( &"CREDITS_JAMES_MCCAWLEY");
	add_space();
	add_heading( &"CREDITS_ADDITIONAL_SOUND_DESIGN");
	add_heading( &"CREDITS_SCOTT_ECKERT");
	add_space();
	add_heading( &"CREDITS_AUDIO_ENGINEER");
	add_heading( &"CREDITS_STEPHEN_MCCAUL");
	add_space();
	add_heading( &"CREDITS_AUDIO_PRODUCTION_TESTER");
	add_heading( &"CREDITS_JESSE_BOOTH");
	add_space();
	add_heading( &"CREDITS_ADDITIONAL_AUDIO_SUPPORT");
	add_heading( &"CREDITS_JULIA_BIANCO");
	
	add_space();
	
	add_space();
	add_heading( &"CREDITS_DESIGN", 2.0);
	add_space();
	add_heading( &"CREDITS_CREATIVE_DIRECTOR");
	add_heading( &"CREDITS_CORKY_LEHMKUHL");
	add_space();
	add_heading( &"CREDITS_STORY_AND_SCRIPT");
	add_heading( &"CREDITS_CRAIG_HOUSTON");
	add_space();
	add_heading( &"CREDITS_DESIGN_DIRECTOR_MULTIPLAYER");
	add_heading( &"CREDITS_DAVID_VONDERHAAR");
	add_space();
	add_heading( &"CREDITS_LEAD_GAME_DESIGNERS");
	add_heading( &"CREDITS_JEREMY_LUYTIES");
	add_heading( &"CREDITS_JESSE_SNYDER");
	add_space();
	add_heading( &"CREDITS_LEAD_LEVEL_SCRIPTER");
	add_heading( &"CREDITS_MIKE_DENNY");
	add_space();
	add_heading( &"CREDITS_SENIOR_LEVEL_SCRIPTERS");
	add_heading( &"CREDITS_GAVIN_LOCKE");
	add_heading( &"CREDITS_SEAN_SLAYBACK");
	add_space();
	add_heading( &"CREDITS_LEVEL_SCRIPTERS");
	add_heading( &"CREDITS_ANTHONY_FLAMER");
	add_heading( &"CREDITS_DOMINICK_GUZZO");
	add_heading( &"CREDITS_SUMEET_JAKATDAR");
	add_heading( &"CREDITS_BRYAN_JOYAL");
	add_heading( &"CREDITS_ALEX_LIU");
	add_heading( &"CREDITS_CHRIS_PIERRO");
	add_heading( &"CREDITS_LUCAS_SEIBERT");
	add_space();
	add_heading( &"CREDITS_JUNIOR_LEVEL_SCRIPTERS");
	add_heading( &"CREDITS_POKEE_CHAN");
	add_heading( &"CREDITS_DAMOUN_SHABESTARI");
	add_space();
	add_heading( &"CREDITS_LEAD_LEVEL_BUILDERS");
	add_heading( &"CREDITS_CHRISTOPHER_DIONNE");
	add_heading( &"CREDITS_ADAM_GASCOINE");
	add_space();
	add_heading( &"CREDITS_SENIOR_LEVEL_BUILDERS");
	add_heading( &"CREDITS_PAUL_SANDLER");
	add_heading( &"CREDITS_JEFF_ZARING");
	add_space();
	add_heading( &"CREDITS_LEVEL_BUILDERS");
	add_heading( &"CREDITS_JARED_DICKINSON");
	add_heading( &"CREDITS_ADAM_REYNOLDS");
	add_heading( &"CREDITS_JASON_SCHOONOVER");
	add_heading( &"CREDITS_BRANDON_SOUDERS");
	add_heading( &"CREDITS_PHILIP_TASKER");
	add_space();
	add_heading( &"CREDITS_JUNIOR_LEVEL_BUILDERS");
	add_heading( &"CREDITS_ADAM_HOGGATT");
	add_heading( &"CREDITS_IAN_KOWALSKI");
	add_space();
	add_heading( &"CREDITS_DESIGN_ASSISTANT");
	add_heading( &"CREDITS_KORNELIA_TAKACS");
	add_space();
	add_heading( &"CREDITS_WRITING_CONSULTANT");
	add_heading( &"CREDITS_PAUL_GOLDING");
	add_space();
	add_heading( &"CREDITS_MILITARY_ADVISOR");
	add_heading( &"CREDITS_HANK_KEIRSEY");
	add_space();
	add_heading( &"CREDITS_ADDITONAL_CREATIVE_DIRECTION");
	add_heading( &"CREDITS_RICHARD_FARRELLY");
	add_space();
	add_heading( &"CREDITS_ADDITIONAL_DESIGN");
	add_heading( &"CREDITS_ANTHONY_DOE");
	add_heading( &"CREDITS_BRIAN_DOUGLAS");
	add_heading( &"CREDITS_DOUG_GUANLAO");
	add_heading( &"CREDITS_JASON_MCCORD");
	add_heading( &"CREDITS_JOEY_TERREBONNE");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_ART", 2.0);
	add_space();
	add_heading( &"CREDITS_ART_DIRECTOR");
	add_heading( &"CREDITS_COLIN_WHITNEY");
	add_space();
	add_heading( &"CREDITS_LEAD_ARTIST");
	add_heading( &"CREDITS_BRIAN_ANDERSON");
	add_space();
	add_heading( &"CREDITS_LIGHTING_DIRECTOR");
	add_heading( &"CREDITS_RICHARD_FARRELLY");
	add_space();
	add_heading( &"CREDITS_LIGHTING");
	add_heading( &"CREDITS_GABRIEL_BETACOURT");
	add_space();
	add_heading( &"CREDITS_LEAD_TECHNICAL_ARTIST");
	add_heading( &"CREDITS_BRAD_GRACE");
	add_space();
	add_heading( &"CREDITS_SENIOR_TECHNICAL_ARTIST");
	add_heading( &"CREDITS_STEV_KALINOWSKI");
	add_space();
	add_heading( &"CREDITS_LEAD_EFFECTS_ARTIST");
	add_heading( &"CREDITS_BARRY_WHITNEY");
	add_space();
	add_heading( &"CREDITS_EFFECTS_ARTISTS");
	add_heading( &"CREDITS_QUYNH_NGUYEN");
	add_heading( &"CREDITS_DALE_MULCHAY");
	add_space();
	add_heading( &"CREDITS_LEAD_ENVIRONMENT_ARTIST");
	add_heading( &"CREDITS_MELISSA_BUFFALOE");
	add_space();
	add_heading( &"CREDITS_ENVIRONMENT_ARTISTS");
	add_heading( &"CREDITS_MIKE_CURRAN");
	add_heading( &"CREDITS_OMAR_GONZALEZ");
	add_heading( &"CREDITS_WILSON_IP");
	add_heading( &"CREDITS_MASAAKI_KAWAKUBO");
	add_heading( &"CREDITS_GARRETT_NGUYEN");
	add_heading( &"CREDITS_MY_WU");
	add_space();
	add_heading( &"CREDITS_LEAD_CHARACTER_ARTIST");
	add_heading( &"CREDITS_CAMERON_PETTY");
	add_space();
	add_heading( &"CREDITS_CHARACTER_ARTISTS");
	add_heading( &"CREDITS_MURAD_AINYUDDIN");
	add_heading( &"CREDITS_LOUDVIK_AKOPYAN");
	add_heading( &"CREDITS_ERIK_DRAGESET");
	add_heading( &"CREDITS_ANH_NGUYEN");
	add_space();
	add_heading( &"CREDITS_LEAD_VEHICLE_WEAPON_ARTIST");
	add_heading( &"CREDITS_DAN_BICKELL");
	add_space();
	add_heading( &"CREDITS_VEHICLE_WEAPON_ARTISTS");
	add_heading( &"CREDITS_KENT_DRAEGER");
	add_heading( &"CREDITS_KAORI_KATO");
	add_heading( &"CREDITS_JOHN_MCGINLEY");
	add_heading( &"CREDITS_DAN_PADILLA");
	add_heading( &"CREDITS_MAX_PORTER");
	add_space();
	add_heading( &"CREDITS_MULTIPLAYER_ARTIST");
	add_heading( &"CREDITS_CRAIG_MARSCHKE");
	add_space();
	add_heading( &"CREDITS_CONCEPT_ARTIST");
	add_heading( &"CREDITS_PETER_LAM");
	add_space();
	add_heading( &"CREDITS_UI_ARTIST");
	add_heading( &"CREDITS_GIL_DORAN");
	add_space();
	add_heading( &"CREDITS_ADDITIONAL_ARTWORK");
	add_heading( &"CREDITS_ISABELLE_DECENCIERE");
	add_heading( &"CREDITS_CRAIG_SCHILLER");
	add_heading( &"CREDITS_BRAD_SHORTT");
	add_heading( &"CREDITS_TOM_SZAKOLCZAY");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_ANIMATION", 2.0);
	add_space();
	add_heading( &"CREDITS_ANIMATION_DIRECTOR");
	add_heading( &"CREDITS_DOM_DROZDZ");
	add_space();
	add_heading( &"CREDITS_LEAD_ANIMATOR");
	add_heading( &"CREDITS_JIMMY_ZIELINSKI");
	add_space();
	add_heading( &"CREDITS_ANIMATORS");
	add_heading( &"CREDITS_PHILLIP_LOZANO");
	add_heading( &"CREDITS_STEVEN_RIVERA");
	add_heading( &"CREDITS_MARVIN_ROJAS");
	add_heading( &"CREDITS_ERIC_SMITH");
	add_heading( &"CREDITS_JON_STOLL");
	add_space();
	
	add_heading( &"CREDITS_ADDITIONAL_ANIMATION");
	add_heading( &"CREDITS_LUIS_YOSH_BOLIVAR");
	add_heading( &"CREDITS_KYLE_GAULIN");
	add_heading( &"CREDITS_KEVIN_KRAEER");
	add_heading( &"CREDITS_ALEX_MOON");
	add_heading( &"CREDITS_LONG_NGUYEN");
	add_heading( &"CREDITS_JOHN_VELAZQUEZ");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_TREYARCH_STAFF", 2.0);
	add_space();
	add_heading( &"CREDITS_STUDIO_HEAD");
	add_heading( &"CREDITS_MARK_LAMIA");
	add_space();
	add_heading( &"CREDITS_VICE_PRESIDENT");
	add_heading( &"CREDITS_DAVE_ANTHONY");
	add_space();
	add_heading( &"CREDITS_CHIEF_TECHNOLOGY_OFFICER");
	add_heading( &"CREDITS_MARK_GORDON");
	add_space();
	add_heading( &"CREDITS_STUDIO_CREATIVE_DIRECTOR");
	add_heading( &"CREDITS_CORKY_LEHMKUHL");
	add_space();
	add_heading( &"CREDITS_STUDIO_AUDIO_DIRECTOR");
	add_heading( &"CREDITS_JERRY_BERLONGIERI");
	add_space();
	add_heading( &"CREDITS_COMMUNITY_MANAGER");
	add_heading( &"CREDITS_JOSH_OLIN");
	add_space();
	add_heading( &"CREDITS_DIRECTOR_OF_OPERATIONS");
	add_heading( &"CREDITS_ROSE_VILLASENOR");
	add_space();
	add_heading( &"CREDITS_SENIOR_IT_MANAGER");
	add_heading( &"CREDITS_ROBERT_SANCHEZ");
	add_space();
	add_heading( &"CREDITS_IT_TECHNICIANS");
	add_heading( &"CREDITS_NICK_WESTFIELD");
	add_heading( &"CREDITS_KRISTOFER_MAGPANTAY");
	add_space();
	add_heading( &"CREDITS_HUMAN_RESOURCES");
	add_heading( &"CREDITS_JU_SHIM");
	add_heading( &"CREDITS_MONICA_TEMPERLY");
	add_space();
	add_heading( &"CREDITS_OFFICE_MANAGER");
	add_heading( &"CREDITS_AMY_HURDELBRINK");
	add_space();
	add_heading( &"CREDITS_SENIOR_RECRUITER");
	add_heading( &"CREDITS_ROBIN_THOMPKINS");
	add_space();
	add_heading( &"CREDITS_ASSOCIATE_RECRUITER");
	add_heading( &"CREDITS_FELIX_MONTANEZ");
	add_space();
	add_heading( &"CREDITS_OFFICE_COORDINATOR");
	add_heading( &"CREDITS_JEREMY_MCADAMS");
	add_space();
	add_heading( &"CREDITS_RECEPTIONIST");
	add_heading( &"CREDITS_RON_FAZIO");
	add_space();
	add_heading( &"CREDITS_DIRECTOR_TOOLS_LIBRARIES");
	add_heading( &"CREDITS_CESAR_STASTNY");
	add_space();
	add_heading( &"CREDITS_ASSOCIATE_PRODUCER_TOOLS_LIBRARIES");
	add_heading( &"CREDITS_ADAM_SASLOW");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_PRODUCTION_TESTING", 2.0);
	add_space();
	add_heading( &"CREDITS_PRODUCTION_TEST_MANAGER");
	add_heading( &"CREDITS_IGOR_KRINITSKIY");
	add_space();
	add_heading( &"CREDITS_TRG_LEAD");
	add_heading( &"CREDITS_MARK_JIHANIAN");
	add_space();
	add_heading( &"CREDITS_PROJECT_TEST_LEAD");
	add_heading( &"CREDITS_JASON_GUYAN");
	add_space();
	add_heading( &"CREDITS_PRODUCTION_FLOOR_LEADS");
	add_heading( &"CREDITS_REILLY_CAMPBELL");
	add_heading( &"CREDITS_FRANCISCO_CARPIO");
	add_heading( &"CREDITS_DANIEL_GERMANN");
	add_heading( &"CREDITS_BRIAN_HUGHES");
	add_heading( &"CREDITS_CHRIS_HO");
	add_heading( &"CREDITS_MATT_MULLEN");
	add_heading( &"CREDITS_TRISTEN_SAKURADA");
	add_heading( &"CREDITS_MOISES_ZET");
	add_space();
	
	add_heading( &"CREDITS_PRODUCTION_TESTERS");
	add_heading( &"CREDITS_DANIEL_ALFARO_PLUS");
	add_heading( &"CREDITS_JAMES_BACA_PLUS");
	add_heading( &"CREDITS_JAMES_CALDERON_PLUS");
	add_heading( &"CREDITS_RYAN_CHIN_PLUS");
	add_heading( &"CREDITS_AMANDA_CONNELL_PLUS");
	add_heading( &"CREDITS_MARCUS_DIXON_PLUS");
	add_heading( &"CREDITS_MARIO_GARCIA_PLUS");
	add_heading( &"CREDITS_DANIEL_GOULD_PLUS");
	add_heading( &"CREDITS_LEIF_JOHANSEN_PLUS");
	add_heading( &"CREDITS_NATHAN_KINNEY_PLUS");
	add_heading( &"CREDITS_TERAN_LAWSON_PLUS");
	add_heading( &"CREDITS_WILLIAM_LOWTHER_PLUS");
	add_heading( &"CREDITS_OMAR_MARRUFO_PLUS");
	add_heading( &"CREDITS_ALEX_MEJIA_PLUS");
	add_heading( &"CREDITS_EVAN_NEWTON_PLUS");
	add_heading( &"CREDITS_SEAN_PEOTTER_PLUS");
	add_heading( &"CREDITS_NICHOLAS_RIOS_PLUS");
	add_heading( &"CREDITS_STEPHANIE_RUSSELL_PLUS");
	add_heading( &"CREDITS_FABIAN_VELASQUEZ_PLUS");
	add_heading( &"CREDITS_GEORGE_WALKER_PLUS");
	add_heading( &"CREDITS_MICHAEL_WICKSON_PLUS");
	add_heading( &"CREDITS_BRANDON_WILLIS_PLUS");
	add_heading( &"CREDITS_JOSEPH_YBARRA");
		
	add_space();
	add_space();
	
	add_heading( &"CREDITS_CINEMATICS", 2.0);
	add_space();
	add_heading( &"CREDITS_SGT_REZNOV");
	add_heading( &"CREDITS_GARY_OLDMAN");
	add_space();
	add_heading( &"CREDITS_SGT_ROEBUCK");
	add_heading( &"CREDITS_KIEFER_SUTHERLAND");
	add_space();
	add_heading( &"CREDITS_PVT_CHERNOV");
	add_heading( &"CREDITS_CRAIG_HOUSTON");
	add_space();
	add_heading( &"CREDITS_SGT_SULLIVAN");
	add_heading( &"CREDITS_CHRIS_FRIES");
	add_space();
	add_heading( &"CREDITS_PVT_POLONSKY");
	add_heading( &"CREDITS_AARON_STANFORD");
	add_space();
	add_heading( &"CREDITS_THE_COMMISSAR");
	add_heading( &"CREDITS_DIMITRI_DIATCHENKO");
	add_space();
	add_heading( &"CREDITS_AMERICAN_VOICE_OVER");
	add_heading( &"CREDITS_KEITH_FERGUSON");
	add_heading( &"CREDITS_MEL_FAIR");
	add_heading( &"CREDITS_CRAIG_HOUSTON");
	add_heading( &"CREDITS_JACOB_CIPES");
	add_heading( &"CREDITS_MATT_LOWE");
	add_space();
	add_heading( &"CREDITS_RUSSIAN_VOICE_OVER");
	add_heading( &"CREDITS_DAVE_BOAT");
	add_heading( &"CREDITS_BORIS_KIEVSKY");
	add_heading( &"CREDITS_NICK_GUEST");
	add_space();
	add_heading( &"CREDITS_GERMAN_VOICE_OVER");
	add_heading( &"CREDITS_MATT_LINDQUIST");
	add_heading( &"CREDITS_TORSTEN_VOGES");
	add_heading( &"CREDITS_WILLIAM_SALYERS");
	add_space();
	add_heading( &"CREDITS_JAPANESE_VOICE_OVER");
	add_heading( &"CREDITS_HIRO_ABE");
	add_heading( &"CREDITS_AKIRA_KENADA");
	add_heading( &"CREDITS_EIJI_INOUE");
	add_space();
	add_heading( &"CREDITS_JAPANESE_OFFICER");
	add_heading( &"CREDITS_TOSHIYA_AGATA");
	add_space();
	add_heading( &"CREDITS_JAPANESE_ANNOUNCER");
	add_heading( &"CREDITS_PAUL_NAKAUCHI");
	add_space();
	add_heading( &"CREDITS_CASTING_AND_VOICE_DIRECTION");
	add_heading( &"CREDITS_MARGARET_TANG");
	add_heading( &"CREDITS_WOMB_MUSIC");
	add_space();
	add_heading( &"CREDITS_VOICE_OVER_EDITORIAL_AND_POST");
	add_heading( &"CREDITS_RIK_SCHAFFER");
	add_heading( &"CREDITS_WOMB_MUSIC");
	add_space();
	add_heading( &"CREDITS_RECORDING_ENGINEER");
	add_heading( &"CREDITS_DEVON_BOWMAN");
	add_heading( &"CREDITS_SALAMI_STUDIOS");
	add_space();
	add_heading( &"CREDITS_RECORDING_STUDIOS");
	add_heading( &"CREDITS_SALAMI_STUDIOS");
	add_heading( &"CREDITS_MARGARITA_MIX_HOLLYWOOD");
	add_space();
	add_heading( &"CREDITS_MUSIC_PREPARATIONS");
	add_heading( &"CREDITS_BTW_PRODUCTIONS");
	add_heading( &"CREDITS_BOOKER_WHITE");
	add_space();
	add_heading( &"CREDITS_ORCHESTRATION_");
	add_heading( &"CREDITS_EMILIE_A_BERNSTIEN");
	add_space();
	add_heading( &"CREDITS_SCORE_PRERECORD_PREPARATION");
	add_heading( &"CREDITS_KTA_PRODUCTIONS");
	add_heading( &"CREDITS_KEVIN_GLOBERMAN");
	add_space();
	add_heading( &"CREDITS_TADLOW_MUSIC");
	add_heading( &"CREDITS_PRAGUE_PHILHARMONIC");
	add_heading( &"CREDITS_CONDUCTED_BY_MIRIAM_NEMCOVA");
	add_heading( &"CREDITS_RECORDED_AT_BARRANDOV_SMECKY");
	add_space();
	add_heading( &"CREDITS_RECORDING_ENGINEER");
	add_heading( &"CREDITS_JAN_HOLZNER");
	add_space();
	add_heading( &"CREDITS_ORCHESTRAL_CONTRACTOR");
	add_heading( &"CREDITS_JAMES_FITZPATRICK_TADLOW_MUSIC");
	add_space();
	add_heading( &"CREDITS_ORIGINAL_MUSIC_COMPOSER_");
	add_heading( &"CREDITS_SEAN_MURRAY_MUSIC");
	add_heading( &"CREDITS_SEAN_MURRAY");
	add_space();
	add_heading( &"CREDITS_GUITAR_ARRANGEMENTS");
	add_heading( &"CREDITS_KEVIN_SHERWOOD");
	add_space();
	add_heading( &"CREDITS_WORLD_AT_WAR_REMIX");
	add_heading( &"CREDITS_STEPHEN_MCCAUL");
	add_space();
	add_heading( &"CREDITS_BATTLE_CHATTER_WRITERS");
	add_heading( &"CREDITS_CHRIS_VALENZIANO");
	add_heading( &"CREDITS_PATRICK_J_DOODY");
	add_space();
	add_heading( &"CREDITS_JAPANESE_TRANSLATOR");
	add_heading( &"CREDITS_YURIKA_DENNIS");
	add_space();
	add_heading( &"CREDITS_GERMAN_TRANSLATOR");
	add_heading( &"CREDITS_MATT_MALOTKI");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_ACTIVISION_CAPTURE_STUDIO", 2.0);
	add_space();
	add_heading( &"CREDITS_MOTION_CAPTURE_DIRECTOR");
	add_heading( &"CREDITS_MATT_KARNES");
	add_space();
	add_heading( &"CREDITS_PRODUCER");
	add_heading( &"CREDITS_NICK_FALZON");
	add_space();
	add_heading( &"CREDITS_MOTION_CAPTURE_SUPERVISOR");
	add_heading( &"CREDITS_MICHAEL_JANTZ");
	add_space();
	add_heading( &"CREDITS_MOTION_CAPTURE_LEAD");
	add_heading( &"CREDITS_BEN_WATSON");
	add_space();
	add_heading( &"CREDITS_PRODUCTION_COORDINATOR");
	add_heading( &"CREDITS_EVAN_BUTTON");
	add_space();
	add_heading( &"CREDITS_DATA_CAPTURE_SUPERVISOR");
	add_heading( &"CREDITS_NOEL_VEGA");
	add_space();
	
	add_heading( &"CREDITS_DATA_CAPTURE_PERSONNEL");
	add_heading( &"CREDITS_CHRIS_TORRES");
	add_heading( &"CREDITS_COLIN_FOLLENWEIDER");
	add_heading( &"CREDITS_CHRIS_YONG");
	add_heading( &"CREDITS_JEREMY_DUNN");
	add_heading( &"CREDITS_ESTEBAN_CUETO");
	add_heading( &"CREDITS_KOFI_YIADOM");
	add_space();
	add_heading( &"CREDITS_SET_CONSTRUCTION");
	add_heading( &"CREDITS_SID_NICHOLSON");
	add_space();
	add_heading( &"CREDITS_REFERENCE_VIDEO");
	add_heading( &"CREDITS_STEPHANIE_PARIS");
	add_heading( &"CREDITS_LIZ_TOM");
	add_space();
	add_heading( &"CREDITS_SCAN_TECHNICIANS");
	add_heading( &"CREDITS_CHRIS_ELLIS");
	add_heading( &"CREDITS_NICK_OTTO");
	add_heading( &"CREDITS_DAVID_BULLAT_II");
	add_heading( &"CREDITS_ERIC_HEFLEY");
	add_space();
	add_heading( &"CREDITS_MARKER_CLEANUP");
	add_heading( &"CREDITS_ANIMATION_VERTIGO");
	add_space();
	add_heading( &"CREDITS_CRAFT_SERVICES");
	add_heading( &"CREDITS_SANDRA_FALZON");
	add_heading( &"CREDITS_CITY_KITCHEN");
	add_heading( &"CREDITS_THE_SLICE");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_ADDITIONAL_DEVELOPMENT",2.0);
	add_space();
	add_heading( &"CREDITS_CERTAIN_AFFINITY");
	add_heading( &"CREDITS_MAX_HOBERMAN");
	add_heading( &"CREDITS_DAVID_ANCIRA");
	add_heading( &"CREDITS_COLM_NELSON");
	add_heading( &"CREDITS_BERNIE_LACARTE");
	add_heading( &"CREDITS_JEAN_EDUARD_FAGES");
	add_heading( &"CREDITS_DAVID_VARGO");
	add_heading( &"CREDITS_JASON_EUBANK");
	add_heading( &"CREDITS_TIA_HOOD");
	add_heading( &"CREDITS_MIKE_AMERSON");
	add_space();
	add_heading( &"CREDITS_CERTAIN_AFFINITY_SPECIAL_THANKS");
	add_heading( &"CREDITS_ARKANE_STUDIOS");
	add_heading( &"CREDITS_RAPHAEL_COLANTONIO");
	add_heading( &"CREDITS_LEAH_SMITH");
	add_space();
	add_heading( &"CREDITS_SPOV_LTD");
	add_heading( &"CREDITS_ALLEN_LEITCH");
	add_heading( &"CREDITS_GEMMA_THOMPSON");
	add_heading( &"CREDITS_MILES_CHRISTENSEN");
	add_heading( &"CREDITS_YUGEN_BLAKE");
	add_heading( &"CREDITS_PAUL_HUNT");
	add_heading( &"CREDITS_DAVID_HICKS");
	add_heading( &"CREDITS_JULIO_DEAN_");
	add_heading( &"CREDITS_MATT_HOTCHKISS");
	add_space();
	add_heading( &"CREDITS_SPOV_SPECIAL_THANKS");
	add_heading( &"CREDITS_PETER_ROBINSON");
	add_heading( &"CREDITS_ROTEM_NAHLIELI");
	add_space();
	add_heading( &"CREDITS_ADDITIONAL_DEV_BY_PI_STUDIOS");
	add_heading( &"CREDITS_JEREMY_STATZ");
	add_heading( &"CREDITS_CHRISTIAN_EASTERLY");
	add_heading( &"CREDITS_KENN_HOEKSTRA");
	add_heading( &"CREDITS_JOHN_FAULKENBURY");
	add_heading( &"CREDITS_ROBERT_ERWIN");
	
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	
}

init_activision_credits()
{
	add_heading( &"CREDITS_ACTIVISION", 2.0);
	
	add_space();
	add_heading( &"CREDITS_SENIOR_PRODUCER");
	add_heading( &"CREDITS_NOAH_HELLER");
	add_space();
	add_heading( &"CREDITS_ASSOCIATE_PRODUCERS");
	add_heading( &"CREDITS_RHETT_CHASSEREAU");
	add_heading( &"CREDITS_TAYLOR_LIVINGSTON");
	add_heading( &"CREDITS_DEREK_RACCA");
	add_heading( &"CREDITS_JOEL_TAUBEL");
	add_space();
	add_heading( &"CREDITS_PRODUCTION_COORDINATOR");
	add_heading( &"CREDITS_JACOB_THOMPSON");
	add_space();
	add_heading( &"CREDITS_PRODUCTION_TESTER");
	add_heading( &"CREDITS_ADRIENNE_ARRASMITH");
	add_space();
	add_heading( &"CREDITS_PRODUCTION_INTERN");
	add_heading( &"CREDITS_NICK_TRUTANIC");
	add_space();
	add_heading( &"CREDITS_EXECUTIVE_PRODUCER");
	add_heading( &"CREDITS_DANIEL_SUAREZ");
	add_space();
	add_heading( &"CREDITS_VICE_PRESIDENT_PRODUCTION");
	add_heading( &"CREDITS_THAINE_LYMAN");
	add_space();
	add_heading( &"CREDITS_SVP_TECHNOLOGY_CTO");
	add_heading( &"CREDITS_STEVE_PEARCE");
	add_space();
	add_heading( &"CREDITS_SVP_PRODUCTION_DEVELOPMENT_WW_STUDIOS");
	add_heading( &"CREDITS_DAVE_STOHL");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_GLOBAL_BRAND_MANAGEMENT",2.0);
	add_space();
	add_heading( &"CREDITS_GLOBAL_BRAND_MANAGER");
	add_heading( &"CREDITS_JEREMIAH_COHN");
	add_space();
	add_heading( &"CREDITS_ASSOCIATE_BRAND_MANAGERS");
	add_heading( &"CREDITS_JON_DELODDER");
	add_heading( &"CREDITS_MIKE_SCHAEFER");
	add_space();
	add_heading( &"CREDITS_GBM_SPECIAL_THANKS");
	add_heading( &"CREDITS_TABITHA_HAYES");
	add_heading( &"CREDITS_JEN_FOX");
	add_heading( &"CREDITS_TOM_SILK");
	add_space();
	add_heading( &"CREDITS_SR_DIRECTOR_OF_MARKETING");
	add_heading( &"CREDITS_JEFF_KALTREIDER");
	add_space();
	add_heading( &"CREDITS_VP_OWNED_PROPERTIES");
	add_heading( &"CREDITS_DAVID_POKRESS");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_PUBLIC_RELATIONS", 2.0);
	add_space();
	add_heading( &"CREDITS_PR_MANAGER");
	add_heading( &"CREDITS_JOHN_RAFACZ");
	add_space();
	add_heading( &"CREDITS_JUNIOR_PUBLICIST");
	add_heading( &"CREDITS_ROBERT_TAYLOR");
	add_space();
	add_heading( &"CREDITS_NEIL_WOOD");
	add_heading( &"CREDITS_JON_LENAWAY");
	add_heading( &"CREDITS_WIEBKE_HESSE");
	add_heading( &"CREDITS_OLIVER_GUBBA");
	add_space();
	add_heading( &"CREDITS_PR_DIRECTOR_OWNED_PROPERTIES");
	add_heading( &"CREDITS_MIKE_MANTARRO");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_PRODUCTION_SERVICES_EUROPE");
	add_space();
	add_heading( &"CREDITS_SENIOR_LOCALIZATION_PROJECT_MANAGER");
	add_heading( &"CREDITS_FIONA_EBBS");
	add_space();
	add_heading( &"CREDITS_LOCALIZATION_COORDINATORS");
	add_heading( &"CREDITS_DOUG_AVERY");
	add_heading( &"CREDITS_DAVID_HILL");
	add_space();
	add_heading( &"CREDITS_LOCALIZATION_QA_MANAGER");
	add_heading( &"CREDITS_DAVID_HICKEY");
	add_space();
	add_heading( &"CREDITS_LOCALIZATION_QA_LEAD");
	add_heading( &"CREDITS_JACK_OHARA");
	add_space();
	add_heading( &"CREDITS_LOCALIZATION_QA_FLOOR_LEADS");
	add_heading( &"CREDITS_DANIELE_CELEGHIN");
	add_space();
	
	add_heading( &"CREDITS_LOCALIZATION_QA_TESTERS");
	add_heading( &"CREDITS_KIERAN_COSGRAVE");
	add_heading( &"CREDITS_JAN_VESTER");
	add_heading( &"CREDITS_JEREMY_LEVI");
	add_heading( &"CREDITS_BRIAN_HERLIHY");
	add_heading( &"CREDITS_FABRIZIO_AMPOLA");
	add_heading( &"CREDITS_SERGIO_GONZALEZ_MONROY");
	add_heading( &"CREDITS_STEPHEN_LOWRY");
	add_space();
	add_heading( &"CREDITS_BURN_LAB_TECHNICIANS");
	add_heading( &"CREDITS_DEREK_BRANGAN");
	add_heading( &"CREDITS_MARK_SMITH");
	add_space();
	add_heading( &"CREDITS_LOCALIZATION_TOOLS_SUPPORT");
	add_heading( &"CREDITS_PROVIDED_BY_STEPHANIE_DEMING");
	add_space();
	add_heading( &"CREDITS_DIRECTOR_OF_PROD_SERVICES_EUROPE");
	add_heading( &"CREDITS_BARRY_KEHOE");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_CENTRAL_TECHNOLOGY", 2.0);
	add_space();
	add_heading( &"CREDITS_SENIOR_DIRECTOR_OF_TECHNOLOGY");
	add_heading( &"CREDITS_MATT_WILKINSON");
	add_space();
	
	add_heading( &"CREDITS_DEMONWARE");
	add_heading( &"CREDITS_NADIA_ALRAMLI");
	add_heading( &"CREDITS_LUKE_BURDEN");
	add_heading( &"CREDITS_TIM_CZERNIAK");
	add_heading( &"CREDITS_EOGHAN_GAFFNEY");
	add_heading( &"CREDITS_JOHN_KIRK");
	add_heading( &"CREDITS_BYRON_PILE");
	add_heading( &"CREDITS_AMY_SMITH");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_CENTRAL_DESIGN", 2.0);
	add_space();
	add_heading( &"CREDITS_SENIOR_DIRECTOR_OF_GAME_DESIGN");
	add_heading( &"CREDITS_CARL_SCHNURR");
	add_space();
	add_heading( &"CREDITS_CENTRAL_DESIGN_LEAD_COMBAT_DESIGNER");
	add_heading( &"CREDITS_DEREK_DANIELS");
	add_space();
	add_heading( &"CREDITS_MANAGER_CENTRAL_USER_TESTING");
	add_heading( &"CREDITS_RAY_KOWALEWSKI");
	add_space();
	add_heading( &"CREDITS_CENTRAL_DESIGN");
	add_heading( &"CREDITS_TOM_WELLS");
	add_heading( &"CREDITS_JEFFREY_CHEN");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_TALENT_AUDIO_MANAGEMENT_GROUP", 2.0);
	add_space();
	add_heading( &"CREDITS_DIRECTOR_OF_CENTRAL_AUDIO");
	add_heading( &"CREDITS_ADAM_LEVENSON");
	add_space();
	add_heading( &"CREDITS_AUDIO_COORDINATOR");
	add_heading( &"CREDITS_NOAH_SARID");
	add_space();
	add_heading( &"CREDITS_TALENT_MANAGER");
	add_heading( &"CREDITS_MARCHELE_HARDIN");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_MARKETING_COMMUNICATIONS", 2.0);
	add_space();
	add_heading( &"CREDITS_SENIOR_DIRECTOR_MARKETING_COMMUNICATIONS");
	add_heading( &"CREDITS_ALEX_FIANCE");
	add_space();
	add_heading( &"CREDITS_MARKETING_COMMUNICATIONS_MANAGER");
	add_heading( &"CREDITS_KAREN_STARR");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_BUSINESS_DEVELOPMENT", 2.0);
	add_space();
	add_heading( &"CREDITS_DAVE_ANDERSON");
	add_heading( &"CREDITS_RALPH_PERILLON");
	add_heading( &"CREDITS_LETAM_BIRA");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_ART_SERVICES", 2.0);
	add_space();
	add_heading( &"CREDITS_ART_SERVICES_MANAGER");
	add_heading( &"CREDITS_TODD_PRUYN");
	add_space();
	add_heading( &"CREDITS_ART_SERVICES");
	add_heading( &"CREDITS_MICHAEL_HUNAU");
	add_heading( &"CREDITS_RYAN_VOLKER");
	add_heading( &"CREDITS_CHRIS_REINHART");
	
	add_space();
	add_space();
		
	add_heading( &"CREDITS_SPECIAL_THANKS", 2.0);
	add_space();
	add_heading( &"CREDITS_MIKE_GRIFFITH");
	add_heading( &"CREDITS_ROBIN_KAMINSKY");
	add_heading( &"CREDITS_STEVE_ACKRICH");
	add_heading( &"CREDITS_LAIRD_M_MALAMED");
	add_heading( &"CREDITS_BRIAN_WARD");
	add_heading( &"CREDITS_MARIA_STIPP");
	add_heading( &"CREDITS_WILL_KASSOY");
	add_heading( &"CREDITS_RAJ_SAIN");
	add_heading( &"CREDITS_MARYANNE_LATAIF");
	add_heading( &"CREDITS_SUZAN_RUDE");
	add_heading( &"CREDITS_JASON_DALBOTTEN");
	add_heading( &"CREDITS_HARJINDER_SINGH");
	add_heading( &"CREDITS_ERIC_GLINOGA");
	add_heading( &"CREDITS_MICA_ROSS");
	add_heading( &"CREDITS_STEVE_YOUNG");
	add_heading( &"CREDITS_BLAKE_HENNON");
	add_heading( &"CREDITS_ALEX_MAHLKE");
	add_heading( &"CREDITS_SHANNON_WAHL");
	add_heading( &"CREDITS_CLARENCE_BELL");
	add_heading( &"CREDITS_GEORGE_ROSE");
	add_heading( &"CREDITS_GREG_DEUTSCH");
	add_heading( &"CREDITS_MARY_TUCK");
	add_heading( &"CREDITS_MARCUS_IREMONGER");
	add_heading( &"CREDITS_MICHELLE_SCHRODER");
	add_heading( &"CREDITS_STEVE_HOLMES");
	add_heading( &"CREDITS_RODRIGO_MORA");
	add_heading( &"CREDITS_JASON_POSADA");
	add_heading( &"CREDITS_VICTOR_LOPEZ");
	add_heading( &"CREDITS_ADAM_FOSHKO");
	add_heading( &"CREDITS_TODD_MUELLER");
	add_heading( &"CREDITS_BRANDON_YOUNG");
	add_heading( &"CREDITS_TIM_RILEY");
	add_heading( &"CREDITS_ANDREA_HAMMON");
	add_heading( &"CREDITS_ADRIAN_GOMEZ");
	add_heading( &"CREDITS_KARA_CORETTE");
	add_heading( &"CREDITS_CHRIS_COSBY");
	add_heading( &"CREDITS_JENNIFER_SULLIVAN");
	add_heading( &"CREDITS_DEREK_BROWN");
	add_heading( &"CREDITS_PHIL_TERZIAN");
	add_heading( &"CREDITS_TRAVIS_STANBURY");
	add_heading( &"CREDITS_JANE_ELMS");
	add_heading( &"CREDITS_KAP_KANG");
	add_heading( &"CREDITS_DANIELLE_KIM");
	add_heading( &"CREDITS_ERIC_PIERCE");
	add_heading( &"CREDITS_TED_SPIEGEL");
	add_heading( &"CREDITS_DUSTY_WELCH");
	add_heading( &"CREDITS_WEST_POINT_MUSEUM_LES_JENSEN");
	add_heading( &"CREDITS_MARINE_LIBRARY_ALISA_WHITLEY");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_QUALITY_ASSURANCE", 2.0);
	add_space();
	add_heading( &"CREDITS_VP_QUALITY_ASSURANCE_CUSTOMER_SERVICE");
	add_heading( &"CREDITS_RICH_ROBINSON");
	add_space();
	add_heading( &"CREDITS_DIRECTOR_QUALITY_ASSURANCE");
	add_heading( &"CREDITS_MARILENA_RIXFORD");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_QUALITY_ASSURANCE_FUNCTIONALITY", 2.0);
	add_space();
	add_heading( &"CREDITS_QA_PROJECT_LEAD_DAY_SHIFT");
	add_heading( &"CREDITS_ERIK_MELEN");
	add_heading( &"CREDITS_CASEY_COLEMAN");
	add_space();
	add_heading( &"CREDITS_QA_PROJECT_LEAD_NIGHT_SHIFT");
	add_heading( &"CREDITS_TOM_CHUA");
	add_space();
	add_heading( &"CREDITS_QA_FLOOR_LEAD_DAY_SHIFT");
	add_heading( &"CREDITS_JEFF_ROPER");
	add_heading( &"CREDITS_DILLON_CHANCE");
	add_heading( &"CREDITS_JAY_MENCONI");
	add_space();
	add_heading( &"CREDITS_QA_FLOOR_LEAD_NIGHT_SHIFT");
	add_heading( &"CREDITS_JAMES_DAVIS");
	add_heading( &"CREDITS_OSCAR_RODRIGUEZ");
	add_heading( &"CREDITS_JULIUS_HIPOLITO");
	add_space();
	add_heading( &"CREDITS_QA_DATABASE_MANAGER");
	add_heading( &"CREDITS_MIKE_GENADRY");
	add_space();
	
	add_heading( &"CREDITS_QA_TESTERS_DAY_SHIFT");
	add_heading( &"CREDITS_JAMES_FRYKMAN");
	add_heading( &"CREDITS_CREED_WEATHERMAN");
	add_heading( &"CREDITS_BEN_MULLER");
	add_heading( &"CREDITS_ANDY_WORSHILL");
	add_heading( &"CREDITS_JACOB_ZAGHA");
	add_heading( &"CREDITS_SCOTT_J_MCPHERSON");
	add_heading( &"CREDITS_STEVEN_WRUBLEVSKI");
	add_heading( &"CREDITS_DOMINIQUE_NEAL");
	add_heading( &"CREDITS_LEVETT_WASHINGTON");
	add_heading( &"CREDITS_RONALD_DEMPSEY");
	add_heading( &"CREDITS_STEPHEN_HODDE");
	add_heading( &"CREDITS_MIKE_ANDEN");
	add_heading( &"CREDITS_JULIO_DELEON");
	add_heading( &"CREDITS_IAN_DOUGLAS");
	add_heading( &"CREDITS_THOMAS_VU");
	add_heading( &"CREDITS_STEVEN_JOHNSON");
	add_heading( &"CREDITS_CALEB_TURNER");
	add_heading( &"CREDITS_STEVEN_RODRIGUEZ");
	add_heading( &"CREDITS_ADAM_SMITH");
	add_heading( &"CREDITS_CARLOS_MONROY");
	add_space();
	add_heading( &"CREDITS_QA_TESTERS_NIGHT_SHIFT");
	add_heading( &"CREDITS_ALYSSA_DELHOTAL");
	add_heading( &"CREDITS_JIMMY_YANG");
	add_heading( &"CREDITS_EMILY_FULLER");
	add_heading( &"CREDITS_ERWIN_ALCANTARA");
	add_heading( &"CREDITS_ANTHONY_RUIZ");
	add_heading( &"CREDITS_BRYAN_CHICE");
	add_heading( &"CREDITS_EDWIN_PAYEN");
	add_heading( &"CREDITS_LA_VONCE_ERVIN");
	add_heading( &"CREDITS_JOSUE_MEDINA");
	add_heading( &"CREDITS_HAI_CHIEM");
	add_heading( &"CREDITS_JULES_LEWIS");
	add_heading( &"CREDITS_MARIO_MARTINEZ");
	add_heading( &"CREDITS_BLAKE_BOLTON");
	add_heading( &"CREDITS_MICHAEL_ORDONEZ");
	add_heading( &"CREDITS_JAVIER_PANAMENO");
	add_heading( &"CREDITS_THOMAS_RIBADENEIRA");
	add_heading( &"CREDITS_ANTHONY_BELLISARIO");
	add_space();
	add_heading( &"CREDITS_QA_SENIOR_PROJECT_LEAD_DAY_SHIFT");
	add_heading( &"CREDITS_HENRY_VILLANUEVA");
	add_space();
	add_heading( &"CREDITS_QA_SENIOR_PROJECT_LEAD_NIGHT_SHIFT");
	add_heading( &"CREDITS_PAUL_COLBERT");
	add_space();
	add_heading( &"CREDITS_QA_MANAGER_DAY_SHIFT");
	add_heading( &"CREDITS_GLENN_VISTANTE");
	add_space();
	add_heading( &"CREDITS_QA_MANAGER_NIGHT_SHIFT");
	add_heading( &"CREDITS_ADAM_HARTSFIELD");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_TECHNICAL_REQUIREMENTS_GROUP", 2.0);
	add_space();
	add_heading( &"CREDITS_TRG_SENIOR_MANAGER");
	add_heading( &"CREDITS_CHRISTOPHER_WILSON");
	add_space();
	add_heading( &"CREDITS_TRG_SUBMISSIONS_LEAD");
	add_heading( &"CREDITS_DANIEL_L_NICHOLS");
	add_heading( &"CREDITS_CHRISTOPHER_NORMAN");
	add_space();
	add_heading( &"CREDITS_TRG_SENIOR_PLATFORM_LEADS");
	add_heading( &"CREDITS_MARC_VILLANUEVA");
	add_heading( &"CREDITS_TEAK_HOLLEY");
	add_space();
	add_heading( &"CREDITS_TRG_PLATFORM_LEADS");
	add_heading( &"CREDITS_BENJAMIN_ABEL");
	add_heading( &"CREDITS_JARED_BACA");
	add_heading( &"CREDITS_JAMES_ROSE");
	add_space();
	add_heading( &"CREDITS_TRG_TESTERS");
	add_heading( &"CREDITS_ALEX_HIRSCH");
	add_heading( &"CREDITS_CHRISTIAN_HAILE");
	add_heading( &"CREDITS_DANIEL_FEHSKENS");
	add_heading( &"CREDITS_JACOB_ZWIRN");
	add_heading( &"CREDITS_JASON_GARZA");
	add_heading( &"CREDITS_JONATHAN_BUTCHER");
	add_heading( &"CREDITS_MARK_RUZICKA");
	add_heading( &"CREDITS_PISOTH_CHHAM");
	add_heading( &"CREDITS_RHONDA_RAMIREZ");
	add_heading( &"CREDITS_STEFAN_BEEMAN");
	add_heading( &"CREDITS_TIMOTHY_GAGLIARDO");
	add_heading( &"CREDITS_CHRISTOPHER_ABEEL");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_QA_CODE_RELEASE_GROUP", 2.0);
	add_space();
	add_heading( &"CREDITS_QA_CRG_PROJECT_LEAD");
	add_heading( &"CREDITS_MATT_RYAN");
	add_space();
	add_heading( &"CREDITS_QA_CRG_TESTERS");
	add_heading( &"CREDITS_JONATHAN_MACK");
	add_heading( &"CREDITS_MATT_JENSEN");
	add_heading( &"CREDITS_SEAN_MILLER");
	
	
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_QA_NETWORK_LAB", 2.0);
	add_space();
	add_heading( &"CREDITS_MANAGER_QA_OPERATIONS");
	add_heading( &"CREDITS_CHRIS_KEIM");
	add_space();
	add_heading( &"CREDITS_QA_NETWORK_LAB_SENIOR_PROJECT_LEAD");
	add_heading( &"CREDITS_FRANCIS_JIMENEZ");
	add_space();
	add_heading( &"CREDITS_QA_NETWORK_LAB_TESTERS");
	add_heading( &"CREDITS_JESSIE_JONES");
	add_heading( &"CREDITS_LEONARD_RODRIGUEZ");
		
	add_space();
	add_space();
	
	add_heading( &"CREDITS_QA_MULTIPLAYER_LAB", 2.0);
	add_space();
	add_heading( &"CREDITS_QA_MPL_PROJECT_LEAD");
	add_heading( &"CREDITS_GARRETT_OSHIRO");
	add_space();
	add_heading( &"CREDITS_QA_MPL_FLOOR_LEADS");
	add_heading( &"CREDITS_BOBBY_JONES");
	add_heading( &"CREDITS_JULIO_MEDINA");
	add_heading( &"CREDITS_EMMANUEL_SALVA_CRUZ");
	add_space();
	add_heading( &"CREDITS_QA_MPL_TESTERS");
	add_heading( &"CREDITS_SKYE_CHANDLER");
	add_heading( &"CREDITS_SHAMENE_CHILDRESS");
	add_heading( &"CREDITS_MATTHEW_FAWBUSH");
	add_heading( &"CREDITS_JOHN_GETTY");
	add_heading( &"CREDITS_ELLIOT_GOMEZ");
	add_heading( &"CREDITS_GABRIEL_HIDALGO");
	add_heading( &"CREDITS_JAEMIN_KANG");
	add_heading( &"CREDITS_DANIEL_KIM");
	add_heading( &"CREDITS_HYUN_ANDY_KIM");
	add_heading( &"CREDITS_BRIAN_LAY");
	add_heading( &"CREDITS_IAN_LYNCH");
	add_heading( &"CREDITS_JONATHAN_MACK");
	add_heading( &"CREDITS_RYAN_RIGG");
	add_heading( &"CREDITS_JONATHAN_YANIV_SADKA");
	add_heading( &"CREDITS_KURTIS_SHERMAN");
	
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_QA_COMPATIBILITY_LAB", 2.0);
	add_space();
	add_heading( &"CREDITS_QA_CL_SENIOR_PROJECT_LEAD");
	add_heading( &"CREDITS_NEIL_BARIZO");
	add_space();
	add_heading( &"CREDITS_QA_CL_LAB_PROJECT_LEAD");
	add_heading( &"CREDITS_CHRIS_NEAL");
	add_space();
	add_heading( &"CREDITS_QA_CL_LAB_SPECIALIST");
	add_heading( &"CREDITS_ALBERT_LEE");
	add_space();
	add_heading( &"CREDITS_QA_CL_LAB_TESTERS");
	add_heading( &"CREDITS_JON_AN");
	add_heading( &"CREDITS_DOV_CARSON");
	add_heading( &"CREDITS_WILLIAM_WHALEY");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_QA_AUDIO_VISUAL_LAB", 2.0);
	add_space();
	add_heading( &"CREDITS_QA_AVL_PROJECT_LEAD");
	add_heading( &"CREDITS_VICTOR_DURLING");
	add_space();
	add_heading( &"CREDITS_QA_AVL_TESTER");
	add_heading( &"CREDITS_CLIFF_HOOPER");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_QA_BURNROOM", 2.0);
	add_space();
	add_heading( &"CREDITS_BURN_ROOM_SUPERVISOR");
	add_heading( &"CREDITS_JOULE_MIDDLETON");
	add_space();
	add_heading( &"CREDITS_BURN_ROOM_TECHNICIANS");
	add_heading( &"CREDITS_DANNY_FENG");
	add_heading( &"CREDITS_KAI_HSU");
	add_heading( &"CREDITS_SEAN_KIM");
	add_heading( &"CREDITS_RODRIGO_MAGANA");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_QA_MIS", 2.0);
	add_space();
	add_heading( &"CREDITS_SENIOR_MANAGER_QA_TECHNOLOGIES");
	add_heading( &"CREDITS_INDRA_YEE");
	add_space();
	add_heading( &"CREDITS_QA_MIS_MANAGER");
	add_heading( &"CREDITS_DAVE_GARCIA_GOMEZ");
	add_space();
	add_heading( &"CREDITS_QA_MIS_TECHNICIANS");
	add_heading( &"CREDITS_TEDDY_HWANG");
	add_heading( &"CREDITS_BRIAN_MARTIN");
	add_heading( &"CREDITS_JEREMY_TORRES");
	add_heading( &"CREDITS_LAWRENCE_WEI");
	add_space();
	add_heading( &"CREDITS_QA_MIS_WEB_DEVELOPER");
	add_heading( &"CREDITS_SEAN_OLSON");
	add_space();
	add_heading( &"CREDITS_QA_MIS_EQUIPMENT_COORDINATORS");
	add_heading( &"CREDITS_LONG_LE");
	add_heading( &"CREDITS_COLEMAN_THAXTON");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_QA_DBA_GROUP", 2.0);
	add_space();
	add_heading( &"CREDITS_SENIOR_LEAD_DATABASE_ADMINISTRATOR");
	add_heading( &"CREDITS_JEREMY_RICHARDS");
	add_space();
	add_heading( &"CREDITS_LEAD_DATABASE_ADMINISTRATOR");
	add_heading( &"CREDITS_KELLY_HUFFINE");
	add_space();
	add_heading( &"CREDITS_DBA_SENIOR_TESTERS");
	add_heading( &"CREDITS_CHRISTOPHER_SHANLEY");
	add_heading( &"CREDITS_TIMOTHY_TOLEDO");
	add_heading( &"CREDITS_WAYNE_WILLIAMS");
	add_space();
	add_heading( &"CREDITS_DBA_TESTERS");
	add_heading( &"CREDITS_JON_LUCE");
	add_heading( &"CREDITS_DENNIS_SOH");
	add_heading( &"CREDITS_NICK_CHAVEZ");
	add_space();
	add_heading( &"CREDITS_CUSTOMER_SUPPORT_MANAGERS");
	add_heading( &"CREDITS_GARY_BOLDUC");
	add_heading( &"CREDITS_MICHAEL_HILL");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_QA_SPECIAL_THANKS", 2.0);
	add_space();
	add_heading( &"CREDITS_MIKE_CLARKE");
	add_heading( &"CREDITS_NADINE_THEUZILLOT");
	add_heading( &"CREDITS_DENISE_LUCE");
	add_heading( &"CREDITS_RACHEL_OVERTON");
	add_heading( &"CREDITS_AILEEN_GALEAS");
	add_heading( &"CREDITS_JEREMY_SHORTELL");
	add_heading( &"CREDITS_DYLAN_RIXFORD");
	add_heading( &"CREDITS_MARC_WILLIAMS");
	add_heading( &"CREDITS_RICHARD_PEARSON");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_MANUAL_DESIGN", 2.0);
	add_space();
	add_heading( &"CREDITS_IGNITED_MINDS_LLC");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_PACKAGING_DESIGN_BY", 2.0);
	add_space();
	add_heading( &"CREDITS_PETROL");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_USES_BINK_VIDEO_COPYRIGHT");
	add_space();
	add_heading( &"CREDITS_USES_MILES_SOUND_SYSTEM");
	//add_space();
	//add_heading( &"CREDITS_THIS_PRODUCT_USES_FMOD");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_FONTS_LICENSED_FROM", 2.0);
	add_space();
	add_heading( &"CREDITS_T26_INC");
	add_heading( &"CREDITS_MONOTYPE");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_THE_CHARACTERS_AND_EVENTS");
	add_heading( &"CREDITS_ANY_SIMILARITY");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_MIXED_AND_MASTERED", 2.0);
	add_space();
	add_heading( &"CREDITS_TREYARCH_AUDIO_COD_TEAM");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_SPECIAL_THANKS_TO_LEN_HAYES");
	add_heading( &"CREDITS_AND_THE_FOLLOWING");
	add_space();
	add_heading( &"CREDITS_CLINTON_ACKERMAN");
	add_heading( &"CREDITS_ALLAN_R_BISHOP");
	add_heading( &"CREDITS_DON_BISHOP");
	add_heading( &"CREDITS_RUSSELL_DIEFENBACH");
	add_heading( &"CREDITS_JOHN_PAUL_DRESTE");
	add_heading( &"CREDITS_LEOPOLDO_GRIEGO");
	add_heading( &"CREDITS_TOM_HARGRAVES");
	add_heading( &"CREDITS_BILL_JENKINS");
	add_space();
	add_heading( &"CREDITS_WE_ARE_INSPIRED");
	
	add_space();
	add_space();
	
	add_heading( &"CREDITS_SEMPER_FI", 2.0);
	
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	add_space();
	
}

add_title( title, textscale )
{
	if( !IsDefined( textscale ) )
	{
		textscale = level.linesize; 
	}
	
	temp = SpawnStruct(); 
	temp.type = "title";
	temp.textscale = textscale; 
	temp.list = init_strings( array( title ) );

	add_to_credit_list( temp ); 
}

add_heading( heading, textscale )
{
	if( !IsDefined( textscale ) )
	{
		textscale = level.linesize; 
	}
	
	temp = SpawnStruct(); 
	temp.type = "heading"; 
	temp.list = init_strings( array( heading ) );
	temp.textscale = textscale; 

	add_to_credit_list( temp ); 
}

add_credit( credit1, credit2, credit3, textscale )
{
	if( !IsDefined( textscale ) )
	{
		textscale = level.linesize; 
	}

	temp = SpawnStruct(); 
	temp.type = "credit";
	temp.textscale = textscale;
	temp.list = init_strings( array( credit1, credit2, credit3 ) );

	add_to_credit_list( temp ); 
}

init_strings( strings )
{
	for( i = 0; i < strings.size; i++ )
	{
		PrecacheString( strings[i] );
	}

	return strings;
}

array(a,b,c,d,e,f,g,h,i,j,k,l,m,n)
{
	array = [];
	if ( isdefined( a ) ) array[ 0] = a; else return array;
	if ( isdefined( b ) ) array[ 1] = b; else return array;
	if ( isdefined( c ) ) array[ 2] = c; else return array;
	if ( isdefined( d ) ) array[ 3] = d; else return array;
	if ( isdefined( e ) ) array[ 4] = e; else return array;
	if ( isdefined( f ) ) array[ 5] = f; else return array;
	if ( isdefined( g ) ) array[ 6] = g; else return array;
	if ( isdefined( h ) ) array[ 7] = h; else return array;
	if ( isdefined( i ) ) array[ 8] = i; else return array;
	if ( isdefined( j ) ) array[ 9] = j; else return array;
	if ( isdefined( k ) ) array[10] = k; else return array;
	if ( isdefined( l ) ) array[11] = l; else return array;
	if ( isdefined( m ) ) array[12] = m; else return array;
	if ( isdefined( n ) ) array[13] = n;
	return array;
}

add_space( small )
{
	temp = SpawnStruct(); 
	temp.type = "space";

	add_to_credit_list( temp ); 
}

add_space_small()
{
	temp = SpawnStruct(); 
	temp.type = "spacesmall"; 

	add_to_credit_list( temp ); 
}

add_image( image, width, height, delay )
{
	PrecacheShader( image ); 
	
	temp = SpawnStruct(); 
	temp.type = "image"; 
	temp.image = image; 
	temp.width = width; 
	temp.height = height; 
	
	if( IsDefined( delay ) )
	{
		temp.delay = delay; 
	}

	add_to_credit_list( temp ); 
}

add_to_credit_list( credit )
{
	level.credit_list[level.credit_list.size] = credit;
}

create_hudelems( amount, x_offset, x_align )
{
	huds = [];

	y_start = 430;

	for( i = 0; i < amount; i++ )
	{
		if( level.hudelem_count < 30 )
		{
			level.hudelem_count++;
			hud = NewHudElem();
		}
		else
		{
			level.clienthudelem_count++;
			host = get_host();
			hud = NewClientHudElem( host );
			hud.is_clienthud = true;
		}
		hud.alpha = 0;

		if( amount == 3 )
		{
			if( i == 0 )
			{
				hud.alignX = "center";
				hud.horzAlign = "center";
				hud.x = -160;
				hud.y = y_start;
			}
			else if( i == 1 )
			{
				hud.alignX = "center";
				hud.horzAlign = "center";
				hud.x = 0;
				hud.y = y_start;
			}
			else if( i == 2 )
			{
				hud.alignX = "center";
				hud.horzAlign = "center";
				hud.x = 160;
				hud.y = y_start;
			}
		}
		else if( amount == 2 )
		{
			if( i == 0 )
			{
				hud.alignX = "right";
				hud.horzAlign = "center";
				hud.x = x_offset * -1;
				hud.y = y_start;
			}
			else
			{
				hud.alignX = "left";
				hud.horzAlign = "center";
				hud.x = x_offset;
				hud.y = y_start;
			}
		}
		else // amount == 1
		{
			hud.alignX = x_align;
			hud.horzAlign = "center";			
			hud.x = x_offset;
			hud.y = y_start;
		}

		hud.sort = 2;

		huds[huds.size] = hud;
	}
	
	return huds;
}

play_credits()
{
	previous_time = 0;
	for( i = 0; i < level.credit_list.size; i++ )
	{
		delay = level.default_line_delay;
		type = level.credit_list[i].type;

		count = 0;
		x_offset = 0;
		x_align = "center";
		is_image = false;

		switch( type )
		{
			case "image":
				count = 1;
				is_image = true;
				break;
	
			case "title":
			case "heading":
				count = level.credit_list[i].list.size;
				break;

			case "credit":
				count = level.credit_list[i].list.size;
				x_align = "left";
				x_offset = 8;
				break;

			case "spacesmall":
				delay = level.spacesmall_delay;
				break;
		}

		huds = [];

		if( count > 0 )
		{
			huds = create_hudelems( count, x_offset, x_align );
		}

		for( q = 0; q < huds.size; q++ )
		{
			switch( type )
			{
				case "image":
					image 	= level.credit_list[i].image; 
					width 	= level.credit_list[i].width; 
					height 	= level.credit_list[i].height; 
	
					huds[q].alpha = 1;
					huds[q] SetShader( image, width, height ); 
	
					if( IsDefined( level.credit_list[i].delay ) )
					{
						delay = level.credit_list[i].delay; 
					}
					else
					{
						delay = ( ( 0.037 * height ) ); 
					}
					break;
	
				case "title":
				case "heading":
				case "credit":
					if( IsDefined( level.credit_list[i].textscale ) )
					{
						huds[q].fontScale = level.credit_list[i].textscale;
					}
	
					huds[q].glowColor = ( 0.3, 0.6, 0.3 ); 
					huds[q].glowAlpha = 1;
					huds[q] SetText( level.credit_list[i].list[q] );
					break;					
				
				default:
					assert( type == "space" );
			}

			huds[q] thread delayed_hud_destroy( level.scroll_dist / level.scroll_speed, is_image ); 
			huds[q] MoveOverTime( level.scroll_dist / level.scroll_speed ); 
			huds[q].y = huds[q].y - level.scroll_dist;
		}

		wait( delay ); 
	}
	
	flag_set( "credits_ended" );
}

delayed_hud_destroy( duration, is_image )
{
	if( !is_image )
	{
		self FadeOverTime( duration * 0.1 );
		self.alpha = 1;
	}

	wait( duration * 0.9 );

//	if( !is_image )
//	{
		self FadeOverTime( duration * 0.1 );
		self.alpha = 0;
//	}

	wait( duration * 0.1 );

	if( IsDefined( self.is_clienthud ) && self.is_clienthud )
	{
		level.clienthudelem_count--;
	}
	else
	{
		level.hudelem_count--;
	}

	self Destroy(); 
}