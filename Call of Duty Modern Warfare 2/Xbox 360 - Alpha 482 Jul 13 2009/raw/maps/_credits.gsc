#include common_scripts\utility;
#include maps\_utility;

initCredits()
{
	level.linesize = 1.35;
	level.headingsize = 1.75;
	level.linelist = [];

	set_console_status();
	initIWCredits();
	initActivisionCredits();
}

initIWCredits()
{
	if ( getdvar( "mapname" ) == "ac130" )
	{
		addLeftImage( "logo_infinityward", 256, 128, 4.375 );// 3.5
		addSpace();
		addSpace();
		// Project Lead
		addLeftTitle( &"CREDIT_PROJECT_LEAD" );
		addSpaceSmall();
		// JASON WEST
		addLeftName( &"CREDIT_JASON_WEST_CAPS" );
		addSpace();
		addSpace();
		// Engineering Leads
		addLeftTitle( &"CREDIT_ENGINEERING_LEADS" );
		addSpaceSmall();
		// RICHARD BAKER
		addLeftName( &"CREDIT_RICHARD_BAKER_CAPS" );
		// ROBERT FIELD
		addLeftName( &"CREDIT_ROBERT_FIELD_CAPS" );
		// FRANCESCO GIGLIOTTI
		addLeftName( &"CREDIT_FRANCESCO_GIGLIOTTI_CAPS" );
		// EARL HAMMON, JR
		addLeftName( &"CREDIT_EARL_HAMMON_JR_CAPS" );
		addSpace();
		// Engineering
		addLeftTitle( &"CREDIT_ENGINEERING" );
		addSpaceSmall();
		// CHAD BARB
		addLeftName( &"CREDIT_CHAD_BARB_CAPS" );
		// ALESSANDRO BARTOLUCCI
		addLeftName( &"CREDIT_ALESSANDRO_BARTOLUCCI_CAPS" );
		// JON DAVIS
		addLeftName( &"CREDIT_JON_DAVIS_CAPS" );
		// JOEL GOMPERT
		addLeftName( &"CREDIT_JOEL_GOMPERT_CAPS" );
		// JOHN HAGGERTY
		addLeftName( &"CREDIT_JOHN_HAGGERTY_CAPS" );
		// JON SHIRING
		addLeftName( &"CREDIT_JON_SHIRING_CAPS" );
		// JIESANG SONG
		addLeftName( &"CREDIT_JIESANG_SONG_CAPS" );
		// RAYME C VINSON
		addLeftName( &"CREDIT_RAYME_VINSON_CAPS" );
		// ANDREW WANG
		addLeftName( &"CREDIT_ANDREW_WANG_CAPS" );
		addSpace();
		addSpace();
		// Design Leads
		addLeftTitle( &"CREDIT_DESIGN_LEADS" );
		addSpaceSmall();
		// TODD ALDERMAN
		addLeftName( &"CREDIT_TODD_ALDERMAN_CAPS" );
		// STEVE FUKUDA
		addLeftName( &"CREDIT_STEVE_FUKUDA_CAPS" );
		// MACKEY MCCANDLISH
		addLeftName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
		// ZIED RIEKE
		addLeftName( &"CREDIT_ZIED_RIEKE_CAPS" );
		addSpace();
		// Design and Scripting
		addLeftTitle( &"CREDIT_DESIGN_AND_SCRIPTING" );
		addSpaceSmall();
		// ROGER ABRAHAMSSON
		addLeftName( &"CREDIT_ROGER_ABRAHAMSSON_CAPS" );
		// MOHAMMAD ALAVI
		addLeftName( &"CREDIT_MOHAMMAD_ALAVI_CAPS" );
		// KEITH BELL
		addLeftName( &"CREDIT_KEITH_BELL_CAPS" );
		// PRESTON GLENN
		addLeftName( &"CREDIT_PRESTON_GLENN_CAPS" );
		// CHAD GRENIER
		addLeftName( &"CREDIT_CHAD_GRENIER_CAPS" );
		// JAKE KEATING
		addLeftName( &"CREDIT_JAKE_KEATING_CAPS" );
		// JULIAN LUO
		addLeftName( &"CREDIT_JULIAN_LUO_CAPS" );
		// STEVE MASSEY
		addLeftName( &"CREDIT_STEVE_MASSEY_CAPS" );
		// BRENT MCLEOD
		addLeftName( &"CREDIT_BRENT_MCLEOD_CAPS" );
		// JON PORTER
		addLeftName( &"CREDIT_JON_PORTER_CAPS" );
		// ALEXANDER ROYCEWICZ
		addLeftName( &"CREDIT_ALEXANDER_ROYCEWICZ_CAPS" );
		// NATHAN SILVERS
		addLeftName( &"CREDIT_NATHAN_SILVERS_CAPS" );
		// GEOFFREY SMITH
		addLeftName( &"CREDIT_GEOFFREY_SMITH_CAPS" );
		addSpace();
		addSpace();
		// Art Director
		addLeftTitle( &"CREDIT_ART_DIRECTOR" );
		addSpaceSmall();
		// RICHARD KRIEGLER
		addLeftName( &"CREDIT_RICHARD_KRIEGLER_CAPS" );
		addSpace();
		// Technical Art Director
		addLeftTitle( &"CREDIT_TECHNICAL_ART_DIRECTOR" );
		addSpaceSmall();
		// MICHAEL BOON
		addLeftName( &"CREDIT_MICHAEL_BOON_CAPS" );
		addSpace();
		// Art Leads
		addLeftTitle( &"CREDIT_ART_LEADS" );
		addSpaceSmall();
		// CHRIS CHERUBINI
		addLeftName( &"CREDIT_CHRIS_CHERUBINI_CAPS" );
		// JOEL EMSLIE
		addLeftName( &"CREDIT_JOEL_EMSLIE_CAPS" );
		// ROBERT GAINES
		addLeftName( &"CREDIT_ROBERT_GAINES_CAPS" );
		addSpace();
		// Art
		addLeftTitle( &"CREDIT_ART" );
		addSpaceSmall();
		// BRAD ALLEN
		addLeftName( &"CREDIT_BRAD_ALLEN_CAPS" );
		// PETER CHEN
		addLeftName( &"CREDIT_PETER_CHEN_CAPS" );
		// JEFF HEATH
		addLeftName( &"CREDIT_JEFF_HEATH_CAPS" );
		// RYAN LASTIMOSA
		addLeftName( &"CREDIT_RYAN_LASTIMOSA_CAPS" );
		// OSCAR LOPEZ
		addLeftName( &"CREDIT_OSCAR_LOPEZ_CAPS" );
		// HERBERT LOWIS
		addLeftName( &"CREDIT_HERBERT_LOWIS_CAPS" );
		// TAEHOON OH
		addLeftName( &"CREDIT_TAEHOON_OH_CAPS" );
		// SAMI ONUR
		addLeftName( &"CREDIT_SAMI_ONUR_CAPS" );
		// VELINDA PELAYO
		addLeftName( &"CREDIT_VELINDA_PELAYO_CAPS" );
		// RICHARD SMITH
		addLeftName( &"CREDIT_RICHARD_SMITH_CAPS" );
		// THEERAPOL SRISUPHAN
		addLeftName( &"CREDIT_THEERAPOL_SRISUPHAN_CAPS" );
		// TODD SUE
		addLeftName( &"CREDIT_TODD_SUE_CAPS" );
		// SOMPOOM TANGCHUPONG
		addLeftName( &"CREDIT_SOMPOOM_TANGCHUPONG_CAPS" );
		addSpace();
		addSpace();
		// Animation Leads
		addLeftTitle( &"CREDIT_ANIMATION_LEADS" );
		addSpaceSmall();
		// MARK GRIGSBY
		addLeftName( &"CREDIT_MARK_GRIGSBY_CAPS" );
		// PAUL MESSERLY
		addLeftName( &"CREDIT_PAUL_MESSERLY_CAPS" );
		addSpace();
		// Animation
		addLeftTitle( &"CREDIT_ANIMATION" );
		addSpaceSmall();
		// CHANCE GLASCO
		addLeftName( &"CREDIT_CHANCE_GLASCO_CAPS" );
		// EMILY RULE
		addLeftName( &"CREDIT_EMILY_RULE_CAPS" );
		// ZACH VOLKER
		addLeftName( &"CREDIT_ZACH_VOLKER_CAPS" );
		// LEI YANG
		addLeftName( &"CREDIT_LEI_YANG_CAPS" );
		addSpace();
		addSpace();
		// Technical Animation Lead
		addLeftTitle( &"CREDIT_TECHNICAL_ANIMATION_LEAD" );
		addSpaceSmall();
		// ERIC PIERCE
		addLeftName( &"CREDIT_ERIC_PIERCE_CAPS" );
		addSpace();
		// Technical Animation
		addLeftTitle( &"CREDIT_TECHNICAL_ANIMATION" );
		addSpaceSmall();
		// NEEL KAR
		addLeftName( &"CREDIT_NEEL_KAR_CAPS" );
		// CHENG LOR
		addLeftName( &"CREDIT_CHENG_LOR_CAPS" );
		addSpace();
		addSpace();
		// Audio Lead
		addLeftTitle( &"CREDIT_AUDIO_LEAD" );
		addSpaceSmall();
		// MARK GANUS
		addLeftName( &"CREDIT_MARK_GANUS_CAPS" );
		addSpace();
		// Audio
		addLeftTitle( &"CREDIT_AUDIO" );
		addSpaceSmall();
		// CHRISSY ARYA
		addLeftName( &"CREDIT_CHRISSY_ARYA_CAPS" );
		// STEPHEN MILLER
		addLeftName( &"CREDIT_STEPHEN_MILLER_CAPS" );
		// LINDA ROSEMEIER
		addLeftName( &"CREDIT_LINDA_ROSEMEIER_CAPS" );
		addSpace();
		addSpace();
		// Written by
		addLeftTitle( &"CREDIT_WRITTEN_BY" );
		addSpaceSmall();
		// JESSE STERN
		addLeftName( &"CREDIT_JESSE_STERN_CAPS" );
		addSpace();
		// Additional Writing
		addLeftTitle( &"CREDIT_ADDITIONAL_WRITING" );
		addSpaceSmall();
		// STEVE FUKUDA
		addLeftName( &"CREDIT_STEVE_FUKUDA_CAPS" );
		addSpace();
		// Story by
		addLeftTitle( &"CREDIT_STORY_BY" );
		addSpaceSmall();
		// TODD ALDERMAN
		addLeftName( &"CREDIT_TODD_ALDERMAN_CAPS" );
		// STEVE FUKUDA
		addLeftName( &"CREDIT_STEVE_FUKUDA_CAPS" );
		// MACKEY MCCANDLISH
		addLeftName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
		// ZIED RIEKE
		addLeftName( &"CREDIT_ZIED_RIEKE_CAPS" );
		// JESSE STERN
		addLeftName( &"CREDIT_JESSE_STERN_CAPS" );
		// JASON WEST
		addLeftName( &"CREDIT_JASON_WEST_CAPS" );
		addSpace();
		addSpace();
		// Studio Heads
		addLeftTitle( &"CREDIT_STUDIO_HEADS" );
		addSpaceSmall();
		// GRANT COLLIER
		addLeftName( &"CREDIT_GRANT_COLLIER_CAPS" );
		// JASON WEST
		addLeftName( &"CREDIT_JASON_WEST_CAPS" );
		// VINCE ZAMPELLA
		addLeftName( &"CREDIT_VINCE_ZAMPELLA_CAPS" );
		addSpace();
		// Producer
		addLeftTitle( &"CREDIT_PRODUCER" );
		addSpaceSmall();
		// MARK RUBIN
		addLeftName( &"CREDIT_MARK_RUBIN_CAPS" );
		addSpace();
		// Associate Producer
		addLeftTitle( &"CREDIT_ASSOCIATE_PRODUCER" );
		addSpaceSmall();
		// PETE BLUMEL
		addLeftName( &"CREDIT_PETE_BLUMEL_CAPS" );
		addSpace();
		// Office Manager
		addLeftTitle( &"CREDIT_OFFICE_MANAGER" );
		addSpaceSmall();
		// JANICE TURNER
		addLeftName( &"CREDIT_JANICE_TURNER_CAPS" );
		addSpace();
		// Human Resources Generalist
		addLeftTitle( &"CREDIT_HUMAN_RESOURCES_GENERALIST" );
		addSpaceSmall();
		// KRISTIN COTTERELL
		addLeftName( &"CREDIT_KRISTIN_COTTERELL_CAPS" );
		addSpace();
		// Executive Assistant
		addLeftTitle( &"CREDIT_EXECUTIVE_ASSISTANT" );
		addSpaceSmall();
		// NICOLE SCATES
		addLeftName( &"CREDIT_NICOLE_SCATES_CAPS" );
		addSpace();
		// Administrative Assistant
		addLeftTitle( &"CREDIT_ADMINISTRATIVE_ASSISTANT" );
		addSpaceSmall();
		// CARLY GILLIS
		addLeftName( &"CREDIT_CARLY_GILLIS_CAPS" );
		addSpace();
		// Community Relations Manager
		addLeftTitle( &"CREDIT_COMMUNITY_RELATIONS_MANAGER" );
		addSpaceSmall();
		// ROBERT BOWLING
		addLeftName( &"CREDIT_ROBERT_BOWLING_CAPS" );
		addSpace();
		addSpace();
		// Information Technology Lead
		addLeftTitle( &"CREDIT_INFORMATION_TECHNOLOGY_LEAD" );
		addSpaceSmall();
		// BRYAN KUHN
		addLeftName( &"CREDIT_BRYAN_KUHN_CAPS" );
		addSpace();
		// Information Technology
		addLeftTitle( &"CREDIT_INFORMATION_TECHNOLOGY" );
		addSpaceSmall();
		// DREW MCCOY
		addLeftName( &"CREDIT_DREW_MCCOY_CAPS" );
		// ALEXANDER SHARRIGAN
		addLeftName( &"CREDIT_ALEXANDER_SHARRIGAN_CAPS" );
		addSpace();
		addSpace();
		// Quality Assurance Leads
		addLeftTitle( &"CREDIT_QUALITY_ASSURANCE_LEADS" );
		addSpaceSmall();
		// JEMUEL GARNETT
		addLeftName( &"CREDIT_JEMUEL_GARNETT_CAPS" );
		// ED HARMER
		addLeftName( &"CREDIT_ED_HARMER_CAPS" );
		// JUSTIN HARRIS
		addLeftName( &"CREDIT_JUSTIN_HARRIS_CAPS" );
		addSpace();
		// Quality Assurance
		addLeftTitle( &"CREDIT_QUALITY_ASSURANCE" );
		addSpaceSmall();
		// BRYAN ANKER
		addLeftName( &"CREDIT_BRYAN_ANKER_CAPS" );
		// ADRIENNE ARRASMITH
		addLeftName( &"CREDIT_ADRIENNE_ARRASMITH_CAPS" );
		// ESTEVAN BECERRA
		addLeftName( &"CREDIT_ESTEVAN_BECERRA_CAPS" );
		// REILLY CAMPBELL
		addLeftName( &"CREDIT_REILLY_CAMPBELL_CAPS" );
		// DIMITRI DEL CASTILLO
		addLeftName( &"CREDIT_DIMITRI_DEL_CASTILLO_CAPS" );
		// SHAMENE CHILDRESS
		addLeftName( &"CREDIT_SHAMENE_CHILDRESS_CAPS" );
		// WILLIAM CHO
		addLeftName( &"CREDIT_WILLIAM_CHO_CAPS" );
		// RICHARD GARCIA
		addLeftName( &"CREDIT_RICHARD_GARCIA_CAPS" );
		// DANIEL GERMANN
		addLeftName( &"CREDIT_DANIEL_GERMANN_CAPS" );
		// EVAN HATCH
		addLeftName( &"CREDIT_EVAN_HATCH_CAPS" );
		// TAN LA
		addLeftName( &"CREDIT_TAN_LA_CAPS" );
		// RENE LARA
		addLeftName( &"CREDIT_RENE_LARA_CAPS" );
		// STEVE LOUIS
		addLeftName( &"CREDIT_STEVE_LOUIS_CAPS" );
		// ALEX MEJIA
		addLeftName( &"CREDIT_ALEX_MEJIA_CAPS" );
		// MATT MILLER
		addLeftName( &"CREDIT_MATT_MILLER_CAPS" );
		// CHRISTIAN MURILLO
		addLeftName( &"CREDIT_CHRISTIAN_MURILLO_CAPS" );
		// GAVIN NIEBEL
		addLeftName( &"CREDIT_GAVIN_NIEBEL_CAPS" );
		// NORMAN OVANDO
		addLeftName( &"CREDIT_NORMAN_OVANDO_CAPS" );
		// JUAN RAMIREZ
		addLeftName( &"CREDIT_JUAN_RAMIREZ_CAPS" );
		// ROBERT RITER
		addLeftName( &"CREDIT_ROBERT_RITER_CAPS" );
		// BRIAN ROYCEWICZ
		addLeftName( &"CREDIT_BRIAN_ROYCEWICZ_CAPS" );
		// TRISTEN SAKURADA
		addLeftName( &"CREDIT_TRISTEN_SAKURADA_CAPS" );
		// KEANE TANOUYE
		addLeftName( &"CREDIT_KEANE_TANOUYE_CAPS" );
		// JASON TOM
		addLeftName( &"CREDIT_JASON_TOM_CAPS" );
		// MAX VO
		addLeftName( &"CREDIT_MAX_VO_CAPS" );
		// BRANDON WILLIS
		addLeftName( &"CREDIT_BRANDON_WILLIS_CAPS" );
		addSpace();
		addSpace();
		// Interns
		addLeftTitle( &"CREDIT_INTERNS" );
		addSpaceSmall();
		// MICHAEL ANDERSON
		addLeftName( &"CREDIT_MICHAEL_ANDERSON_CAPS" );
		// JASON BOESCH
		addLeftName( &"CREDIT_JASON_BOESCH_CAPS" );
		// ARTURO CABALLERO
		addLeftName( &"CREDIT_ARTURO_CABALLERO_CAPS" );
		// DERRIC EADY
		addLeftName( &"CREDIT_DERRIC_EADY_CAPS" );
		// DANIEL EDWARDS
		addLeftName( &"CREDIT_DANIEL_EDWARDS_CAPS" );
		// ALDRIC SAUCIER
		addLeftName( &"CREDIT_ALDRIC_SAUCIER_CAPS" );
		addSpace();
		addSpace();
		// Voice Talent
		addLeftTitle( &"CREDIT_VOICE_TALENT" );
		addSpaceSmall();
		// BILLY MURRAY
		addLeftName( &"CREDIT_BILLY_MURRAY_CAPS" );
		// CRAIG FAIRBRASS
		addLeftName( &"CREDIT_CRAIG_FAIRBRASS_CAPS" );
		// DAVID SOBOLOV
		addLeftName( &"CREDIT_DAVID_SOBOLOV_CAPS" );
		// MARK GRIGSBY
		addLeftName( &"CREDIT_MARK_GRIGSBY_CAPS" );
		// ZACH HANKS
		addLeftName( &"CREDIT_ZACH_HANKS_CAPS" );
		// FRED TOMA
		addLeftName( &"CREDIT_FRED_TOMA_CAPS" );
		// EUGENE LAZAREB
		addLeftName( &"CREDIT_EUGENE_LAZAREB_CAPS" );
		addSpace();
		// Additional Voice Talent
		addLeftTitle( &"CREDIT_ADDITIONAL_VOICE_TALENT" );
		addSpaceSmall();
		// GABRIEL AL-RAJHI
		addLeftName( &"CREDIT_GABRIEL_ALRAJHI_CAPS" );
		// SARKIS ALBERT
		addLeftName( &"CREDIT_SARKIS_ALBERT_CAPS" );
		// DESMOND ASKEW
		addLeftName( &"CREDIT_DESMOND_ASKEW_CAPS" );
		// DAVID NEIL BLACK
		addLeftName( &"CREDIT_DAVID_NEIL_BLACK_CAPS" );
		// MARCUS COLOMA
		addLeftName( &"CREDIT_MARCUS_COLOMA_CAPS" );
		// MICHAEL CUDLITZ
		addLeftName( &"CREDIT_MICHAEL_CUDLITZ_CAPS" );
		// GREG ELLIS
		addLeftName( &"CREDIT_GREG_ELLIS_CAPS" );
		// GIDEON EMERY
		addLeftName( &"CREDIT_GIDEON_EMERY_CAPS" );
		// JOSH GILMAN
		addLeftName( &"CREDIT_JOSH_GILMAN_CAPS" );
		// MICHAEL GOUGH
		addLeftName( &"CREDIT_MICHAEL_GOUGH_CAPS" );
		// ANNA GRAVES
		addLeftName( &"CREDIT_ANNA_GRAVES_CAPS" );
		// SVEN HOLMBERG
		addLeftName( &"CREDIT_SVEN_HOLMBERG_CAPS" );
		// MARK IVANIR
		addLeftName( &"CREDIT_MARK_IVANIR_CAPS" );
		// QUENTIN JONES
		addLeftName( &"CREDIT_QUENTIN_JONES_CAPS" );
		// ARMANDO VALDES-KENNEDY
		addLeftName( &"CREDIT_ARMANDO_VALDESKENNEDY_CAPS" );
		// BORIS KIEVSKY
		addLeftName( &"CREDIT_BORIS_KIEVSKY_CAPS" );
		// RJ KNOLL
		addLeftName( &"CREDIT_RJ_KNOLL_CAPS" );
		// KRISTOF KONRAD
		addLeftName( &"CREDIT_KRISTOF_KONRAD_CAPS" );
		// DAVE MALLOW
		addLeftName( &"CREDIT_DAVE_MALLOW_CAPS" );
		// JORDAN MARDER
		addLeftName( &"CREDIT_JORDAN_MARDER_CAPS" );
		// SAM SAKO
		addLeftName( &"CREDIT_SAM_SAKO_CAPS" );
		// HARRY VAN GORKUM
		addLeftName( &"CREDIT_HARRY_VAN_GORKUM_CAPS" );
		addSpace();
		addSpace();
		// Models
		addLeftTitle( &"CREDIT_MODELS" );
		addSpaceSmall();
		// MUNEER ABDELHADI
		addLeftName( &"CREDIT_MUNEER_ABDELHADI_CAPS" );
		// MOHAMMAD ALAVI
		addLeftName( &"CREDIT_MOHAMMAD_ALAVI_CAPS" );
		// JESUS ANGUIANO
		addLeftName( &"CREDIT_JESUS_ANGUIANO_CAPS" );
		// CHAD BAKKE
		addLeftName( &"CREDIT_CHAD_BAKKE_CAPS" );
		// PETER CHEN
		addLeftName( &"CREDIT_PETER_CHEN_CAPS" );
		// KEVIN COLLINS
		addLeftName( &"CREDIT_KEVIN_COLLINS_CAPS" );
		// HUGH DALY
		addLeftName( &"CREDIT_HUGH_DALY_CAPS" );
		// DERRIC EADY
		addLeftName( &"CREDIT_DERRIC_EADY_CAPS" );
		// SUREN GAZARYAN
		addLeftName( &"CREDIT_SUREN_GAZARYAN_CAPS" );
		// CHAD GRENIER
		addLeftName( &"CREDIT_CHAD_GRENIER_CAPS" );
		// MARK GRIGSBY
		addLeftName( &"CREDIT_MARK_GRIGSBY_CAPS" );
		// JUSTIN HARRIS
		addLeftName( &"CREDIT_JUSTIN_HARRIS_CAPS" );
		// CLIVE HAWKINS
		addLeftName( &"CREDIT_CLIVE_HAWKINS_CAPS" );
		// STEVEN JONES
		addLeftName( &"CREDIT_STEVEN_JONES_CAPS" );
		// DAVID KLEC
		addLeftName( &"CREDIT_DAVID_KLEC_CAPS" );
		// JOSHUA LACROSSE
		addLeftName( &"CREDIT_JOSHUA_LACROSSE_CAPS" );
		// RYAN LASTIMOSA
		addLeftName( &"CREDIT_RYAN_LASTIMOSA_CAPS" );
		// JAMES LITTLEJOHN
		addLeftName( &"CREDIT_JAMES_LITTLEJOHN_CAPS" );
		// MACKEY MCCANDLISH
		addLeftName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
		// TOM MINDER
		addLeftName( &"CREDIT_TOM_MINDER_CAPS" );
		// SAMI ONUR
		addLeftName( &"CREDIT_SAMI_ONUR_CAPS" );
		// VELINDA PELAYO
		addLeftName( &"CREDIT_VELINDA_PELAYO_CAPS" );
		// MARTIN RESOAGLI
		addLeftName( &"CREDIT_MARTIN_RESOAGLI_CAPS" );
		// ZIED RIEKE
		addLeftName( &"CREDIT_ZIED_RIEKE_CAPS" );
		// ALEXANDER ROYCEWICZ
		addLeftName( &"CREDIT_ALEXANDER_ROYCEWICZ_CAPS" );
		// JOSE RUBEN AGUILAR, JR
		addLeftName( &"CREDIT_JOSE_RUBEN_AGUILAR_JR_CAPS" );
		// GEOFFREY SMITH
		addLeftName( &"CREDIT_GEOFFREY_SMITH_CAPS" );
		// TODD SUE
		addLeftName( &"CREDIT_TODD_SUE_CAPS" );
		// EID TOLBA
		addLeftName( &"CREDIT_EID_TOLBA_CAPS" );
		// ZACH VOLKER
		addLeftName( &"CREDIT_ZACH_VOLKER_CAPS" );
		// JASON WEST
		addLeftName( &"CREDIT_JASON_WEST_CAPS" );
		// HENRY YORK
		addLeftName( &"CREDIT_HENRY_YORK_CAPS" );
		addSpace();
		addSpace();
		/*addLeftTitle( &"CREDIT_ORIGINAL_SCORE" );
		addSpace();
		addSubLeftTitle( &"CREDIT_THEME_BY" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_HARRY_GREGSONWILLIAMS_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_PRODUCED_BY" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_HARRY_GREGSONWILLIAMS_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_MUSIC_BY" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_STEPHEN_BARTON_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_SCORE_SUPERVISOR" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_ALLISON_WRIGHT_CLARK_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_AMBIENT_MUSIC_DESIGN" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_MEL_WESSON_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_SCORE_PERFORMED_BY" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_THE_LONDON_SESSION_ORCHESTRA_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_SCORING_ENGINEER" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_JONATHAN_ALLEN_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_SCORING_MIXER" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_MALCOLM_LUKER_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_PROTOOLS_ENGINEERS" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_JAMIE_LUKER_CAPS" );
		addSubLeftName( &"CREDIT_SCRAP_MARSHALL_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_ORCHESTRA_CONTRACTORS" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_ISOBEL_GRIFFITHS_CAPS" );
		addSubLeftName( &"CREDIT_CHARLOTTE_MATTHEWS_CAPS" );
		addSubLeftName( &"CREDIT_TODD_STANTON_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_ORCHESTRATIONS_BY" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_DAVID_BUCKLEY_CAPS" );
		addSubLeftName( &"CREDIT_STEPHEN_BARTON_CAPS" );
		addSubLeftName( &"CREDIT_LADD_MCINTOSH_CAPS" );
		addSubLeftName( &"CREDIT_HALLI_CAUTHERY_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_COPYISTS" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_ANN_MILLER_CAPS" );
		addSubLeftName( &"CREDIT_TED_MILLER_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_STRING_OVERDUBS_BY" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_THE_CZECH_PHILHARMONIC_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_ARTISTIC_DIRECTOR" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_PAVEL_PRANTL_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_GUITARS" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_COSTA_KOTSELAS_CAPS" );
		addSubLeftName( &"CREDIT_PETER_DISTEFANO_CAPS" );
		addSubLeftName( &"CREDIT_JOHN_PARRICELLI_CAPS" );
		addSubLeftName( &"CREDIT_TOBY_CHU_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_ELECTRIC_VIOLIN" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_HUGH_MARSH_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_OUD_BOUZOUKI" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_STUART_HALL_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_HURDY_GURDY" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_NICHOLAS_PERRY" );
		addSpace();
		addSubLeftTitle( &"CREDIT_HORN_SOLOS" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_RICHARD_WATKINS_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_PERCUSSION" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_FRANK_RICOTTI_CAPS" );
		addSubLeftName( &"CREDIT_GARY_KETTEL_CAPS" );
		addSubLeftName( &"CREDIT_PAUL_CLARVIS_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_SCORE_RECORDED_AT_ABBEY" );
		addSpaceSmall();
		addSubLeftTitle( &"CREDIT_MUSIC_MIXED_AT_THE_BLUE" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_MILITARY_TECHNICAL_ADVISORS" );
		addSpaceSmall();
		addLeftName( &"CREDIT_LT_COL_HANK_KEIRSEY_US" );
		addLeftName( &"CREDIT_MAJ_KEVIN_COLLINS_USMC" );
		addLeftName( &"CREDIT_EMILIO_CUESTA_USMC_CAPS" );
		addLeftName( &"CREDIT_SGT_MAJ_JAMES_DEVER_1" );
		addLeftName( &"CREDIT_M_SGT_TOM_MINDER_1_FORCE" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_SOUND_EFFECTS_RECORDING" );
		addSpaceSmall();
		addLeftName( &"CREDIT_JOHN_FASAL_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_VIDEO_EDITING" );
		addSpaceSmall();
		addLeftName( &"CREDIT_PETE_BLUMEL_CAPS" );
		addLeftName( &"CREDIT_DREW_MCCOY_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_ADDITIONAL_DESIGN_AND" );
		addSpaceSmall();
		addLeftName( &"CREDIT_BRIAN_GILMAN_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_ADDITIONAL_ART" );
		addSpaceSmall();
		addLeftName( &"CREDIT_ANDREW_CLARK_CAPS" );
		addLeftName( &"CREDIT_JAVIER_OJEDA_CAPS" );
		addLeftName( &"CREDIT_JIWON_SON_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_TRANSLATIONS" );
		addSpaceSmall();
		addLeftName( &"CREDIT_APPLIED_LANGUAGES" );
		addLeftName( &"CREDIT_WORLD_LINGO" );
		addLeftName( &"CREDIT_UNIQUE_ARTISTS" );
		addSpace();
		addLeftTitle( &"CREDIT_WEAPON_ARMORERS_AND_RANGE" );
		addSpaceSmall();
		addLeftName( &"CREDIT_GIBBONS_LTD" );
		addLeftName( &"CREDIT_LONG_MOUNTAIN_OUTFITTERS" );
		addLeftName( &"CREDIT_BOB_MAUPIN_RANCH" );
		addSpace();
		addSpace();

		if( level.console && !level.xenon ) // PS3 only
		{
			addLeftTitle( &"CREDIT_ADDITIONAL_PROGRAMMING_DEMONWARE" );
			addSpaceSmall();
			addLeftName( &"CREDIT_SEAN_BLANCHFIELD_CAPS" );
			addLeftName( &"CREDIT_MORGAN_BRICKLEY_CAPS" );
			addLeftName( &"CREDIT_DYLAN_COLLINS_CAPS" );
			addLeftName( &"CREDIT_MICHAEL_COLLINS_CAPS" );
			addLeftName( &"CREDIT_MALCOLM_DOWSE_CAPS" );
			addLeftName( &"CREDIT_STEFFEN_HIGELS_CAPS" );
			addLeftName( &"CREDIT_TONY_KELLY_CAPS" );
			addLeftName( &"CREDIT_JOHN_KIRK_CAPS" );
			addLeftName( &"CREDIT_CRAIG_MCINNES_CAPS" );
			addLeftName( &"CREDIT_ALEX_MONTGOMERY_CAPS" );
			addLeftName( &"CREDIT_EOIN_OFEARGHAIL_CAPS" );
			addLeftName( &"CREDIT_RUAIDHRI_POWER_CAPS" );
			addLeftName( &"CREDIT_TILMAN_SCHAFER_CAPS" );
			addLeftName( &"CREDIT_AMY_SMITH_CAPS" );
			addLeftName( &"CREDIT_EMMANUEL_STONE_CAPS" );
			addLeftName( &"CREDIT_ROB_SYNNOTT_CAPS" );
			addLeftName( &"CREDIT_VLAD_TITOV_CAPS" );
			addSpace();
			addSpace();
		}
		
		addLeftTitle( &"CREDIT_ADDITIONAL_ART_PROVIDED_ANT_FARM" );
		addSpace();
		addSubLeftTitle( &"CREDIT_PRODUCER" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_SCOTT_CARSON_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_SENIOR_EDITOR" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_SCOTT_COOKSON_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_ASSOCIATE_PRODUCER" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_SETH_HENDRIX_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_EXECUTIVE_CREATIVE_DIRECTORS" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_LISA_RIZNIKOVE_CAPS" );
		addSubLeftName( &"CREDIT_ROB_TROY_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_VOICE_RECORDING_FACILITIES" );
		addSpace();
		addSubLeftTitle( &"CREDIT_PCB_PRODUCTIONS" );
		addSubLeftTitle( &"CREDIT_SIDEUK" );
		addSpace();
		addSubLeftTitle( &"CREDIT_VOICE_DIRECTIONDIALOG" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_KEITH_AREM_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_ADDITIONAL_DIALOG_ENGINEERING" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_ANT_HALES_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_ADDITIONAL_VOICE_DIRECTION" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_STEVE_FUKUDA_CAPS" );
		addSubLeftName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_MOTION_CAPTURE_PROVIDED" );
		addSpace();
		addSubLeftTitle( &"CREDIT_MOTION_CAPTURE_LEAD" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_KRISTINA_ADELMEYER_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_MOTION_CAPTURE_TECHNICIANS" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_KRISTIN_GALLAGHER_CAPS" );
		addSubLeftName( &"CREDIT_JEFF_SWENTY_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_MOTION_CAPTURE_INTERN" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_JORGE_LOPEZ_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_STUNT_ACTION_DESIGNED" );
		addSpace();
		addSubLeftTitle( &"CREDIT_STUNT_COORDINATOR" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_DANNY_HERNANDEZ_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_STUNTSMOTION_CAPTURE" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_ROBERT_ALONSO_CAPS" );
		addSubLeftName( &"CREDIT_DANNY_HERNANDEZ_CAPS" );
		addSubLeftName( &"CREDIT_ALLEN_JO_CAPS" );
		addSubLeftName( &"CREDIT_DAVID_LEITCH_CAPS" );
		addSubLeftName( &"CREDIT_MIKE_MUKATIS_CAPS" );
		addSubLeftName( &"CREDIT_RYAN_WATSON_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_CINEMATIC_MOVIES_PROVIDED" );
		addSpace();
		addLeftTitle( &"CREDIT_VEHICLES_PROVIDED_BY" );
		addSpace();

		if( !level.console ) // PC only
		{
			addLeftTitle( &"CREDIT_ADDITIONAL_PROGRAMMING_EVEN_BALANCE" );
			addSpace();
		}
		
		addLeftTitle( &"CREDIT_ADDITIONAL_ART_PROVIDED" );
		addSpace();
		addLeftTitle( &"CREDIT_ADDITIONAL_SOUND_DESIGN" );
		addSpace();
		addLeftTitle( &"CREDIT_ADDITIONAL_AUDIO_ENGINEERING_DIGITAL_SYNAPSE" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_PRODUCTION_BABIES" );
		addSpaceSmall();
		addLeftName( &"CREDIT_BABY_COLIN_ALDERMAN" );
		addLeftName( &"CREDIT_BABY_LUKE_SMITH" );
		addLeftName( &"CREDIT_BABY_JOHN_GALT_WEST_JACK" );
		addLeftName( &"CREDIT_BABY_COURTNEY_ZAMPELLA" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_INFINITY_WARD_SPECIAL" );
		addSpaceSmall();
		addLeftName( &"CREDIT_USMC_PUBLIC_AFFAIRS_OFFICE" );
		addLeftName( &"CREDIT_USMC_1ST_TANK_BATTALION" );
		addLeftName( &"CREDIT_MARINE_LIGHT_ATTACK_HELICOPTER" );
		addLeftName( &"CREDIT_USMC_5TH_BATTALION_14TH" );
		addLeftName( &"CREDIT_ARMY_1ST_CAVALRY_DIVISION" );
		addSpace();
		addLeftName( &"CREDIT_DAVE_DOUGLAS_CAPS" );
		addLeftName( &"CREDIT_DAVID_FALICKI_CAPS" );
		addLeftName( &"CREDIT_ROCK_GALLOTTI_CAPS" );
		addLeftName( &"CREDIT_MICHAEL_GIBBONS_CAPS" );
		addLeftName( &"CREDIT_LAWRENCE_GREEN_CAPS" );
		addLeftName( &"CREDIT_ANDREW_HOFFACKER_CAPS" );
		addLeftName( &"CREDIT_JD_KEIRSEY_CAPS" );
		addLeftName( &"CREDIT_ROBERT_MAUPIN_CAPS" );
		addLeftName( &"CREDIT_BRIAN_MAYNARD_CAPS" );
		addLeftName( &"CREDIT_LARRY_ZANOFF_CAPS" );
		addLeftName( &"CREDIT_CALEB_BARNHART_CAPS" );
		addLeftName( &"CREDIT_JOHN_BUDD_CAPS" );
		addLeftName( &"CREDIT_SCOTT_CARPENTER_CAPS" );
		addLeftName( &"CREDIT_JOSHUA_CARRILLO_CAPS" );
		addLeftName( &"CREDIT_DAVID_COFFEY_CAPS" );
		addLeftName( &"CREDIT_CHRISTOPHER_DARE_CAPS" );
		addLeftName( &"CREDIT_NICK_DUNCAN_CAPS" );
		addLeftName( &"CREDIT_JOSE_GO_JR_CAPS" );
		addLeftName( &"CREDIT_JEREMY_HULL_CAPS" );
		addLeftName( &"CREDIT_GORDON_JAMES_CAPS" );
		addLeftName( &"CREDIT_STEVEN_JONES_CAPS" );
		addLeftName( &"CREDIT_MICHAEL_LISCOTTI_CAPS" );
		addLeftName( &"CREDIT_STEPHANIE_MARTINEZ_CAPS" );
		addLeftName( &"CREDIT_C_ANTHONY_MARQUEZ_CAPS" );
		addLeftName( &"CREDIT_CODY_MAUTER_CAPS" );
		addLeftName( &"CREDIT_JOSEPH_MCCREARY_CAPS" );
		addLeftName( &"CREDIT_GREG_MESSINGER_CAPS" );
		addLeftName( &"CREDIT_MICHAEL_RETZLAFF_CAPS" );
		addLeftName( &"CREDIT_ANGEL_SANCHEZ_CAPS" );
		addLeftName( &"CREDIT_KYLE_SMITH_CAPS" );
		addLeftName( &"CREDIT_ALAN_STERN_CAPS" );
		addLeftName( &"CREDIT_ANGEL_TORRES_CAPS" );
		addLeftName( &"CREDIT_OSCAR_VILLAMOR" );
		addLeftName( &"CREDIT_LARRY_ZENG_CAPS" );
		addSpace();
		addSpace();
		addSpace();
		addSpace();*/
	}
	else
	{
		addCenterImage( "logo_infinityward", 256, 128, 4.375 );// 3.5
		addSpace();
		addSpace();
		// Project Lead
		// JASON WEST
		addCenterDual( &"CREDIT_PROJECT_LEAD", &"CREDIT_JASON_WEST_CAPS" );
		addSpace();
		addSpace();
		// Engineering Leads
		// RICHARD BAKER
		addCenterDual( &"CREDIT_ENGINEERING_LEADS", &"CREDIT_RICHARD_BAKER_CAPS" );
		// ROBERT FIELD
		addCenterName( &"CREDIT_ROBERT_FIELD_CAPS" );
		// FRANCESCO GIGLIOTTI
		addCenterName( &"CREDIT_FRANCESCO_GIGLIOTTI_CAPS" );
		// EARL HAMMON, JR
		addCenterName( &"CREDIT_EARL_HAMMON_JR_CAPS" );
		addSpaceSmall();
		// Engineering
		// CHAD BARB
		addCenterDual( &"CREDIT_ENGINEERING", &"CREDIT_CHAD_BARB_CAPS" );
		// ALESSANDRO BARTOLUCCI
		addCenterName( &"CREDIT_ALESSANDRO_BARTOLUCCI_CAPS" );
		// JON DAVIS
		addCenterName( &"CREDIT_JON_DAVIS_CAPS" );
		// JOEL GOMPERT
		addCenterName( &"CREDIT_JOEL_GOMPERT_CAPS" );
		// JOHN HAGGERTY
		addCenterName( &"CREDIT_JOHN_HAGGERTY_CAPS" );
		// JON SHIRING
		addCenterName( &"CREDIT_JON_SHIRING_CAPS" );
		// JIESANG SONG
		addCenterName( &"CREDIT_JIESANG_SONG_CAPS" );
		// RAYME C VINSON
		addCenterName( &"CREDIT_RAYME_VINSON_CAPS" );
		// ANDREW WANG
		addCenterName( &"CREDIT_ANDREW_WANG_CAPS" );
		addSpace();
		addSpace();
		// Design Leads
		// TODD ALDERMAN
		addCenterDual( &"CREDIT_DESIGN_LEADS", &"CREDIT_TODD_ALDERMAN_CAPS" );
		// STEVE FUKUDA
		addCenterName( &"CREDIT_STEVE_FUKUDA_CAPS" );
		// MACKEY MCCANDLISH
		addCenterName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
		// ZIED RIEKE
		addCenterName( &"CREDIT_ZIED_RIEKE_CAPS" );
		addSpaceSmall();
		// Design and Scripting
		// ROGER ABRAHAMSSON
		addCenterDual( &"CREDIT_DESIGN_AND_SCRIPTING", &"CREDIT_ROGER_ABRAHAMSSON_CAPS" );
		// MOHAMMAD ALAVI
		addCenterName( &"CREDIT_MOHAMMAD_ALAVI_CAPS" );
		// KEITH BELL
		addCenterName( &"CREDIT_KEITH_BELL_CAPS" );
		// PRESTON GLENN
		addCenterName( &"CREDIT_PRESTON_GLENN_CAPS" );
		// CHAD GRENIER
		addCenterName( &"CREDIT_CHAD_GRENIER_CAPS" );
		// JAKE KEATING
		addCenterName( &"CREDIT_JAKE_KEATING_CAPS" );
		// JULIAN LUO
		addCenterName( &"CREDIT_JULIAN_LUO_CAPS" );
		// STEVE MASSEY
		addCenterName( &"CREDIT_STEVE_MASSEY_CAPS" );
		// BRENT MCLEOD
		addCenterName( &"CREDIT_BRENT_MCLEOD_CAPS" );
		// JON PORTER
		addCenterName( &"CREDIT_JON_PORTER_CAPS" );
		// ALEXANDER ROYCEWICZ
		addCenterName( &"CREDIT_ALEXANDER_ROYCEWICZ_CAPS" );
		// NATHAN SILVERS
		addCenterName( &"CREDIT_NATHAN_SILVERS_CAPS" );
		// GEOFFREY SMITH
		addCenterName( &"CREDIT_GEOFFREY_SMITH_CAPS" );
		addSpace();
		addSpace();
		// Art Director
		// RICHARD KRIEGLER
		addCenterDual( &"CREDIT_ART_DIRECTOR", &"CREDIT_RICHARD_KRIEGLER_CAPS" );
		addSpaceSmall();
		// Technical Art Director
		// MICHAEL BOON
		addCenterDual( &"CREDIT_TECHNICAL_ART_DIRECTOR", &"CREDIT_MICHAEL_BOON_CAPS" );
		addSpaceSmall();
		// Art Leads
		// CHRIS CHERUBINI
		addCenterDual( &"CREDIT_ART_LEADS", &"CREDIT_CHRIS_CHERUBINI_CAPS" );
		// JOEL EMSLIE
		addCenterName( &"CREDIT_JOEL_EMSLIE_CAPS" );
		// ROBERT GAINES
		addCenterName( &"CREDIT_ROBERT_GAINES_CAPS" );
		addSpaceSmall();
		// Art
		// BRAD ALLEN
		addCenterDual( &"CREDIT_ART", &"CREDIT_BRAD_ALLEN_CAPS" );
		// PETER CHEN
		addCenterName( &"CREDIT_PETER_CHEN_CAPS" );
		// JEFF HEATH
		addCenterName( &"CREDIT_JEFF_HEATH_CAPS" );
		// RYAN LASTIMOSA
		addCenterName( &"CREDIT_RYAN_LASTIMOSA_CAPS" );
		// OSCAR LOPEZ
		addCenterName( &"CREDIT_OSCAR_LOPEZ_CAPS" );
		// HERBERT LOWIS
		addCenterName( &"CREDIT_HERBERT_LOWIS_CAPS" );
		// TAEHOON OH
		addCenterName( &"CREDIT_TAEHOON_OH_CAPS" );
		// SAMI ONUR
		addCenterName( &"CREDIT_SAMI_ONUR_CAPS" );
		// VELINDA PELAYO
		addCenterName( &"CREDIT_VELINDA_PELAYO_CAPS" );
		// RICHARD SMITH
		addCenterName( &"CREDIT_RICHARD_SMITH_CAPS" );
		// THEERAPOL SRISUPHAN
		addCenterName( &"CREDIT_THEERAPOL_SRISUPHAN_CAPS" );
		// TODD SUE
		addCenterName( &"CREDIT_TODD_SUE_CAPS" );
		// SOMPOOM TANGCHUPONG
		addCenterName( &"CREDIT_SOMPOOM_TANGCHUPONG_CAPS" );
		addSpace();
		addSpace();
		// Animation Leads
		// MARK GRIGSBY
		addCenterDual( &"CREDIT_ANIMATION_LEADS", &"CREDIT_MARK_GRIGSBY_CAPS" );
		// PAUL MESSERLY
		addCenterName( &"CREDIT_PAUL_MESSERLY_CAPS" );
		addSpaceSmall();
		// Animation
		// CHANCE GLASCO
		addCenterDual( &"CREDIT_ANIMATION", &"CREDIT_CHANCE_GLASCO_CAPS" );
		// EMILY RULE
		addCenterName( &"CREDIT_EMILY_RULE_CAPS" );
		// ZACH VOLKER
		addCenterName( &"CREDIT_ZACH_VOLKER_CAPS" );
		// LEI YANG
		addCenterName( &"CREDIT_LEI_YANG_CAPS" );
		addSpace();
		addSpace();
		// Technical Animation Lead
		// ERIC PIERCE
		addCenterDual( &"CREDIT_TECHNICAL_ANIMATION_LEAD", &"CREDIT_ERIC_PIERCE_CAPS" );
		addSpaceSmall();
		// Technical Animation
		// NEEL KAR
		addCenterDual( &"CREDIT_TECHNICAL_ANIMATION", &"CREDIT_NEEL_KAR_CAPS" );
		// CHENG LOR
		addCenterName( &"CREDIT_CHENG_LOR_CAPS" );
		addSpace();
		addSpace();
		// Audio Lead
		// MARK GANUS
		addCenterDual( &"CREDIT_AUDIO_LEAD", &"CREDIT_MARK_GANUS_CAPS" );
		addSpaceSmall();
		// Audio
		// CHRISSY ARYA
		addCenterDual( &"CREDIT_AUDIO", &"CREDIT_CHRISSY_ARYA_CAPS" );
		// STEPHEN MILLER
		addCenterName( &"CREDIT_STEPHEN_MILLER_CAPS" );
		// LINDA ROSEMEIER
		addCenterName( &"CREDIT_LINDA_ROSEMEIER_CAPS" );
		addSpace();
		addSpace();
		// Written by
		// JESSE STERN
		addCenterDual( &"CREDIT_WRITTEN_BY", &"CREDIT_JESSE_STERN_CAPS" );
		addSpaceSmall();
		// Additional Writing
		// STEVE FUKUDA
		addCenterDual( &"CREDIT_ADDITIONAL_WRITING", &"CREDIT_STEVE_FUKUDA_CAPS" );
		addSpaceSmall();
		// Story by
		// TODD ALDERMAN
		addCenterDual( &"CREDIT_STORY_BY", &"CREDIT_TODD_ALDERMAN_CAPS" );
		// STEVE FUKUDA
		addCenterName( &"CREDIT_STEVE_FUKUDA_CAPS" );
		// MACKEY MCCANDLISH
		addCenterName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
		// ZIED RIEKE
		addCenterName( &"CREDIT_ZIED_RIEKE_CAPS" );
		// JESSE STERN
		addCenterName( &"CREDIT_JESSE_STERN_CAPS" );
		// JASON WEST
		addCenterName( &"CREDIT_JASON_WEST_CAPS" );
		addSpace();
		addSpace();
		// Studio Heads
		// GRANT COLLIER
		addCenterDual( &"CREDIT_STUDIO_HEADS", &"CREDIT_GRANT_COLLIER_CAPS" );
		// JASON WEST
		addCenterName( &"CREDIT_JASON_WEST_CAPS" );
		// VINCE ZAMPELLA
		addCenterName( &"CREDIT_VINCE_ZAMPELLA_CAPS" );
		addSpaceSmall();
		// Producer
		// MARK RUBIN
		addCenterDual( &"CREDIT_PRODUCER", &"CREDIT_MARK_RUBIN_CAPS" );
		addSpaceSmall();
		// Associate Producer
		// PETE BLUMEL
		addCenterDual( &"CREDIT_ASSOCIATE_PRODUCER", &"CREDIT_PETE_BLUMEL_CAPS" );
		addSpaceSmall();
		// Office Manager
		// JANICE TURNER
		addCenterDual( &"CREDIT_OFFICE_MANAGER", &"CREDIT_JANICE_TURNER_CAPS" );
		addSpaceSmall();
		// Human Resources Generalist
		// KRISTIN COTTERELL
		addCenterDual( &"CREDIT_HUMAN_RESOURCES_GENERALIST", &"CREDIT_KRISTIN_COTTERELL_CAPS" );
		addSpaceSmall();
		// Executive Assistant
		// NICOLE SCATES
		addCenterDual( &"CREDIT_EXECUTIVE_ASSISTANT", &"CREDIT_NICOLE_SCATES_CAPS" );
		addSpaceSmall();
		// Administrative Assistant
		// CARLY GILLIS
		addCenterDual( &"CREDIT_ADMINISTRATIVE_ASSISTANT", &"CREDIT_CARLY_GILLIS_CAPS" );
		addSpaceSmall();
		// Community Relations Manager
		// ROBERT BOWLING
		addCenterDual( &"CREDIT_COMMUNITY_RELATIONS_MANAGER", &"CREDIT_ROBERT_BOWLING_CAPS" );
		addSpace();
		addSpace();
		// Information Technology Lead
		// BRYAN KUHN
		addCenterDual( &"CREDIT_INFORMATION_TECHNOLOGY_LEAD", &"CREDIT_BRYAN_KUHN_CAPS" );
		addSpaceSmall();
		// Information Technology
		// DREW MCCOY
		addCenterDual( &"CREDIT_INFORMATION_TECHNOLOGY", &"CREDIT_DREW_MCCOY_CAPS" );
		// ALEXANDER SHARRIGAN
		addCenterName( &"CREDIT_ALEXANDER_SHARRIGAN_CAPS" );
		addSpace();
		addSpace();
		// Quality Assurance Leads
		// JEMUEL GARNETT
		addCenterDual( &"CREDIT_QUALITY_ASSURANCE_LEADS", &"CREDIT_JEMUEL_GARNETT_CAPS" );
		// ED HARMER
		addCenterName( &"CREDIT_ED_HARMER_CAPS" );
		// JUSTIN HARRIS
		addCenterName( &"CREDIT_JUSTIN_HARRIS_CAPS" );
		addSpaceSmall();
		// Quality Assurance
		// BRYAN ANKER
		addCenterDual( &"CREDIT_QUALITY_ASSURANCE", &"CREDIT_BRYAN_ANKER_CAPS" );
		// ADRIENNE ARRASMITH
		addCenterName( &"CREDIT_ADRIENNE_ARRASMITH_CAPS" );
		// ESTEVAN BECERRA
		addCenterName( &"CREDIT_ESTEVAN_BECERRA_CAPS" );
		// REILLY CAMPBELL
		addCenterName( &"CREDIT_REILLY_CAMPBELL_CAPS" );
		// DIMITRI DEL CASTILLO
		addCenterName( &"CREDIT_DIMITRI_DEL_CASTILLO_CAPS" );
		// SHAMENE CHILDRESS
		addCenterName( &"CREDIT_SHAMENE_CHILDRESS_CAPS" );
		// WILLIAM CHO
		addCenterName( &"CREDIT_WILLIAM_CHO_CAPS" );
		// RICHARD GARCIA
		addCenterName( &"CREDIT_RICHARD_GARCIA_CAPS" );
		// DANIEL GERMANN
		addCenterName( &"CREDIT_DANIEL_GERMANN_CAPS" );
		// EVAN HATCH
		addCenterName( &"CREDIT_EVAN_HATCH_CAPS" );
		// TAN LA
		addCenterName( &"CREDIT_TAN_LA_CAPS" );
		// RENE LARA
		addCenterName( &"CREDIT_RENE_LARA_CAPS" );
		// STEVE LOUIS
		addCenterName( &"CREDIT_STEVE_LOUIS_CAPS" );
		// ALEX MEJIA
		addCenterName( &"CREDIT_ALEX_MEJIA_CAPS" );
		// MATT MILLER
		addCenterName( &"CREDIT_MATT_MILLER_CAPS" );
		// CHRISTIAN MURILLO
		addCenterName( &"CREDIT_CHRISTIAN_MURILLO_CAPS" );
		// GAVIN NIEBEL
		addCenterName( &"CREDIT_GAVIN_NIEBEL_CAPS" );
		// NORMAN OVANDO
		addCenterName( &"CREDIT_NORMAN_OVANDO_CAPS" );
		// JUAN RAMIREZ
		addCenterName( &"CREDIT_JUAN_RAMIREZ_CAPS" );
		// ROBERT RITER
		addCenterName( &"CREDIT_ROBERT_RITER_CAPS" );
		// BRIAN ROYCEWICZ
		addCenterName( &"CREDIT_BRIAN_ROYCEWICZ_CAPS" );
		// TRISTEN SAKURADA
		addCenterName( &"CREDIT_TRISTEN_SAKURADA_CAPS" );
		// KEANE TANOUYE
		addCenterName( &"CREDIT_KEANE_TANOUYE_CAPS" );
		// JASON TOM
		addCenterName( &"CREDIT_JASON_TOM_CAPS" );
		// MAX VO
		addCenterName( &"CREDIT_MAX_VO_CAPS" );
		// BRANDON WILLIS
		addCenterName( &"CREDIT_BRANDON_WILLIS_CAPS" );
		addSpace();
		addSpace();
		// Interns
		// MICHAEL ANDERSON
		addCenterDual( &"CREDIT_INTERNS", &"CREDIT_MICHAEL_ANDERSON_CAPS" );
		// JASON BOESCH
		addCenterName( &"CREDIT_JASON_BOESCH_CAPS" );
		// ARTURO CABALLERO
		addCenterName( &"CREDIT_ARTURO_CABALLERO_CAPS" );
		// DERRIC EADY
		addCenterName( &"CREDIT_DERRIC_EADY_CAPS" );
		// DANIEL EDWARDS
		addCenterName( &"CREDIT_DANIEL_EDWARDS_CAPS" );
		// ALDRIC SAUCIER
		addCenterName( &"CREDIT_ALDRIC_SAUCIER_CAPS" );
		addSpace();
		addSpace();
		// Voice Talent
		// BILLY MURRAY
		addCenterDual( &"CREDIT_VOICE_TALENT", &"CREDIT_BILLY_MURRAY_CAPS" );
		// CRAIG FAIRBRASS
		addCenterName( &"CREDIT_CRAIG_FAIRBRASS_CAPS" );
		// DAVID SOBOLOV
		addCenterName( &"CREDIT_DAVID_SOBOLOV_CAPS" );
		// MARK GRIGSBY
		addCenterName( &"CREDIT_MARK_GRIGSBY_CAPS" );
		// ZACH HANKS
		addCenterName( &"CREDIT_ZACH_HANKS_CAPS" );
		// FRED TOMA
		addCenterName( &"CREDIT_FRED_TOMA_CAPS" );
		// EUGENE LAZAREB
		addCenterName( &"CREDIT_EUGENE_LAZAREB_CAPS" );
		addSpaceSmall();
		// Additional Voice Talent
		// GABRIEL AL-RAJHI
		addCenterDual( &"CREDIT_ADDITIONAL_VOICE_TALENT", &"CREDIT_GABRIEL_ALRAJHI_CAPS" );
		// SARKIS ALBERT
		addCenterName( &"CREDIT_SARKIS_ALBERT_CAPS" );
		// DESMOND ASKEW
		addCenterName( &"CREDIT_DESMOND_ASKEW_CAPS" );
		// DAVID NEIL BLACK
		addCenterName( &"CREDIT_DAVID_NEIL_BLACK_CAPS" );
		// MARCUS COLOMA
		addCenterName( &"CREDIT_MARCUS_COLOMA_CAPS" );
		// MICHAEL CUDLITZ
		addCenterName( &"CREDIT_MICHAEL_CUDLITZ_CAPS" );
		// GREG ELLIS
		addCenterName( &"CREDIT_GREG_ELLIS_CAPS" );
		// GIDEON EMERY
		addCenterName( &"CREDIT_GIDEON_EMERY_CAPS" );
		// JOSH GILMAN
		addCenterName( &"CREDIT_JOSH_GILMAN_CAPS" );
		// MICHAEL GOUGH
		addCenterName( &"CREDIT_MICHAEL_GOUGH_CAPS" );
		// ANNA GRAVES
		addCenterName( &"CREDIT_ANNA_GRAVES_CAPS" );
		// SVEN HOLMBERG
		addCenterName( &"CREDIT_SVEN_HOLMBERG_CAPS" );
		// MARK IVANIR
		addCenterName( &"CREDIT_MARK_IVANIR_CAPS" );
		// QUENTIN JONES
		addCenterName( &"CREDIT_QUENTIN_JONES_CAPS" );
		// ARMANDO VALDES-KENNEDY
		addCenterName( &"CREDIT_ARMANDO_VALDESKENNEDY_CAPS" );
		// BORIS KIEVSKY
		addCenterName( &"CREDIT_BORIS_KIEVSKY_CAPS" );
		// RJ KNOLL
		addCenterName( &"CREDIT_RJ_KNOLL_CAPS" );
		// KRISTOF KONRAD
		addCenterName( &"CREDIT_KRISTOF_KONRAD_CAPS" );
		// DAVE MALLOW
		addCenterName( &"CREDIT_DAVE_MALLOW_CAPS" );
		// JORDAN MARDER
		addCenterName( &"CREDIT_JORDAN_MARDER_CAPS" );
		// SAM SAKO
		addCenterName( &"CREDIT_SAM_SAKO_CAPS" );
		// HARRY VAN GORKUM
		addCenterName( &"CREDIT_HARRY_VAN_GORKUM_CAPS" );
		addSpace();
		addSpace();
		// Models
		// MUNEER ABDELHADI
		addCenterDual( &"CREDIT_MODELS", &"CREDIT_MUNEER_ABDELHADI_CAPS" );
		// MOHAMMAD ALAVI
		addCenterName( &"CREDIT_MOHAMMAD_ALAVI_CAPS" );
		// JESUS ANGUIANO
		addCenterName( &"CREDIT_JESUS_ANGUIANO_CAPS" );
		// CHAD BAKKE
		addCenterName( &"CREDIT_CHAD_BAKKE_CAPS" );
		// PETER CHEN
		addCenterName( &"CREDIT_PETER_CHEN_CAPS" );
		// KEVIN COLLINS
		addCenterName( &"CREDIT_KEVIN_COLLINS_CAPS" );
		// HUGH DALY
		addCenterName( &"CREDIT_HUGH_DALY_CAPS" );
		// DERRIC EADY
		addCenterName( &"CREDIT_DERRIC_EADY_CAPS" );
		// SUREN GAZARYAN
		addCenterName( &"CREDIT_SUREN_GAZARYAN_CAPS" );
		// CHAD GRENIER
		addCenterName( &"CREDIT_CHAD_GRENIER_CAPS" );
		// MARK GRIGSBY
		addCenterName( &"CREDIT_MARK_GRIGSBY_CAPS" );
		// JUSTIN HARRIS
		addCenterName( &"CREDIT_JUSTIN_HARRIS_CAPS" );
		// CLIVE HAWKINS
		addCenterName( &"CREDIT_CLIVE_HAWKINS_CAPS" );
		// STEVEN JONES
		addCenterName( &"CREDIT_STEVEN_JONES_CAPS" );
		// DAVID KLEC
		addCenterName( &"CREDIT_DAVID_KLEC_CAPS" );
		// JOSHUA LACROSSE
		addCenterName( &"CREDIT_JOSHUA_LACROSSE_CAPS" );
		// RYAN LASTIMOSA
		addCenterName( &"CREDIT_RYAN_LASTIMOSA_CAPS" );
		// JAMES LITTLEJOHN
		addCenterName( &"CREDIT_JAMES_LITTLEJOHN_CAPS" );
		// MACKEY MCCANDLISH
		addCenterName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
		// TOM MINDER
		addCenterName( &"CREDIT_TOM_MINDER_CAPS" );
		// SAMI ONUR
		addCenterName( &"CREDIT_SAMI_ONUR_CAPS" );
		// VELINDA PELAYO
		addCenterName( &"CREDIT_VELINDA_PELAYO_CAPS" );
		// MARTIN RESOAGLI
		addCenterName( &"CREDIT_MARTIN_RESOAGLI_CAPS" );
		// ZIED RIEKE
		addCenterName( &"CREDIT_ZIED_RIEKE_CAPS" );
		// ALEXANDER ROYCEWICZ
		addCenterName( &"CREDIT_ALEXANDER_ROYCEWICZ_CAPS" );
		// JOSE RUBEN AGUILAR, JR
		addCenterName( &"CREDIT_JOSE_RUBEN_AGUILAR_JR_CAPS" );
		// GEOFFREY SMITH
		addCenterName( &"CREDIT_GEOFFREY_SMITH_CAPS" );
		// TODD SUE
		addCenterName( &"CREDIT_TODD_SUE_CAPS" );
		// EID TOLBA
		addCenterName( &"CREDIT_EID_TOLBA_CAPS" );
		// ZACH VOLKER
		addCenterName( &"CREDIT_ZACH_VOLKER_CAPS" );
		// JASON WEST
		addCenterName( &"CREDIT_JASON_WEST_CAPS" );
		// HENRY YORK
		addCenterName( &"CREDIT_HENRY_YORK_CAPS" );
		addSpace();
		addSpace();
	}

	// Original Score
	addCenterHeading( &"CREDIT_ORIGINAL_SCORE" );
	addSpaceSmall();
	// Theme by
	// HARRY GREGSON-WILLIAMS
	addCenterDual( &"CREDIT_THEME_BY", &"CREDIT_HARRY_GREGSONWILLIAMS_CAPS" );
	addSpaceSmall();
	// Produced by
	// HARRY GREGSON-WILLIAMS
	addCenterDual( &"CREDIT_PRODUCED_BY", &"CREDIT_HARRY_GREGSONWILLIAMS_CAPS" );
	addSpaceSmall();
	// Music by
	// STEPHEN BARTON
	addCenterDual( &"CREDIT_MUSIC_BY", &"CREDIT_STEPHEN_BARTON_CAPS" );
	addSpaceSmall();
	// Score Supervisor
	// ALLISON WRIGHT CLARK
	addCenterDual( &"CREDIT_SCORE_SUPERVISOR", &"CREDIT_ALLISON_WRIGHT_CLARK_CAPS" );
	addSpaceSmall();
	// Ambient Music Design
	// MEL WESSON
	addCenterDual( &"CREDIT_AMBIENT_MUSIC_DESIGN", &"CREDIT_MEL_WESSON_CAPS" );
	addSpaceSmall();
	// Score Performed by
	// THE LONDON SESSION ORCHESTRA
	addCenterDual( &"CREDIT_SCORE_PERFORMED_BY", &"CREDIT_THE_LONDON_SESSION_ORCHESTRA_CAPS" );
	addSpaceSmall();
	// Scoring Engineer
	// JONATHAN ALLEN
	addCenterDual( &"CREDIT_SCORING_ENGINEER", &"CREDIT_JONATHAN_ALLEN_CAPS" );
	addSpaceSmall();
	// Scoring Mixer
	// MALCOLM LUKER
	addCenterDual( &"CREDIT_SCORING_MIXER", &"CREDIT_MALCOLM_LUKER_CAPS" );
	addSpaceSmall();
	// ProTools Engineers
	// JAMIE LUKER
	addCenterDual( &"CREDIT_PROTOOLS_ENGINEERS", &"CREDIT_JAMIE_LUKER_CAPS" );
	// SCRAP MARSHALL
	addCenterName( &"CREDIT_SCRAP_MARSHALL_CAPS" );
	addSpaceSmall();
	// Orchestra Contractors
	// ISOBEL GRIFFITHS
	addCenterDual( &"CREDIT_ORCHESTRA_CONTRACTORS", &"CREDIT_ISOBEL_GRIFFITHS_CAPS" );
	// CHARLOTTE MATTHEWS
	addCenterName( &"CREDIT_CHARLOTTE_MATTHEWS_CAPS" );
	// TODD STANTON
	addCenterName( &"CREDIT_TODD_STANTON_CAPS" );
	addSpaceSmall();
	// Orchestrations by
	// DAVID BUCKLEY
	addCenterDual( &"CREDIT_ORCHESTRATIONS_BY", &"CREDIT_DAVID_BUCKLEY_CAPS" );
	// STEPHEN BARTON
	addCenterName( &"CREDIT_STEPHEN_BARTON_CAPS" );
	// LADD MCINTOSH
	addCenterName( &"CREDIT_LADD_MCINTOSH_CAPS" );
	// HALLI CAUTHERY
	addCenterName( &"CREDIT_HALLI_CAUTHERY_CAPS" );
	addSpaceSmall();
	// Copyists
	// ANN MILLER
	addCenterDual( &"CREDIT_COPYISTS", &"CREDIT_ANN_MILLER_CAPS" );
	// TED MILLER
	addCenterName( &"CREDIT_TED_MILLER_CAPS" );
	addSpaceSmall();
	// String Overdubs by
	// THE CZECH PHILHARMONIC ORCHESTRA
	addCenterDual( &"CREDIT_STRING_OVERDUBS_BY", &"CREDIT_THE_CZECH_PHILHARMONIC_CAPS" );
	addSpaceSmall();
	// Artistic Director
	// PAVEL PRANTL
	addCenterDual( &"CREDIT_ARTISTIC_DIRECTOR", &"CREDIT_PAVEL_PRANTL_CAPS" );
	addSpaceSmall();
	// Guitars
	// COSTA KOTSELAS
	addCenterDual( &"CREDIT_GUITARS", &"CREDIT_COSTA_KOTSELAS_CAPS" );
	// PETER DISTEFANO
	addCenterName( &"CREDIT_PETER_DISTEFANO_CAPS" );
	// JOHN PARRICELLI
	addCenterName( &"CREDIT_JOHN_PARRICELLI_CAPS" );
	// TOBY CHU
	addCenterName( &"CREDIT_TOBY_CHU_CAPS" );
	addSpaceSmall();
	// Electric Violin
	// HUGH MARSH
	addCenterDual( &"CREDIT_ELECTRIC_VIOLIN", &"CREDIT_HUGH_MARSH_CAPS" );
	addSpaceSmall();
	// Oud, Bouzouki
	// STUART HALL
	addCenterDual( &"CREDIT_OUD_BOUZOUKI", &"CREDIT_STUART_HALL_CAPS" );
	addSpaceSmall();
	// Hurdy Gurdy
	// NICHOLAS PERRY
	addCenterDual( &"CREDIT_HURDY_GURDY", &"CREDIT_NICHOLAS_PERRY" );
	addSpaceSmall();
	// Horn Solos
	// RICHARD WATKINS
	addCenterDual( &"CREDIT_HORN_SOLOS", &"CREDIT_RICHARD_WATKINS_CAPS" );
	addSpaceSmall();
	// Percussion
	// FRANK RICOTTI
	addCenterDual( &"CREDIT_PERCUSSION", &"CREDIT_FRANK_RICOTTI_CAPS" );
	// GARY KETTEL
	addCenterName( &"CREDIT_GARY_KETTEL_CAPS" );
	// PAUL CLARVIS
	addCenterName( &"CREDIT_PAUL_CLARVIS_CAPS" );
	addSpace();
	// Score recorded at Abbey Road Studios
	addCenterHeading( &"CREDIT_SCORE_RECORDED_AT_ABBEY" );
	addSpaceSmall();
	// Music mixed at the Blue Room, Los Angeles, CA
	addCenterHeading( &"CREDIT_MUSIC_MIXED_AT_THE_BLUE" );
	addSpace();
	addSpace();
	// Military Technical Advisors
	// LT COL HANK KEIRSEY US ARMY (RET.)
	addCenterDual( &"CREDIT_MILITARY_TECHNICAL_ADVISORS", &"CREDIT_LT_COL_HANK_KEIRSEY_US" );
	// MAJ KEVIN COLLINS USMC (RET.)
	addCenterName( &"CREDIT_MAJ_KEVIN_COLLINS_USMC" );
	// EMILIO CUESTA USMC
	addCenterName( &"CREDIT_EMILIO_CUESTA_USMC_CAPS" );
	// SGT MAJ JAMES DEVER - 1 FORCE, INC
	addCenterName( &"CREDIT_SGT_MAJ_JAMES_DEVER_1" );
	// M SGT TOM MINDER - 1 FORCE, INC
	addCenterName( &"CREDIT_M_SGT_TOM_MINDER_1_FORCE" );
	addSpace();
	addSpace();
	// Sound Effects Recording
	// JOHN FASAL
	addCenterDual( &"CREDIT_SOUND_EFFECTS_RECORDING", &"CREDIT_JOHN_FASAL_CAPS" );
	addSpaceSmall();
	// Video Editing
	// PETE BLUMEL
	addCenterDual( &"CREDIT_VIDEO_EDITING", &"CREDIT_PETE_BLUMEL_CAPS" );
	// DREW MCCOY
	addCenterName( &"CREDIT_DREW_MCCOY_CAPS" );
	addSpaceSmall();
	// Additional Design and Scripting
	// BRIAN GILMAN
	addCenterDual( &"CREDIT_ADDITIONAL_DESIGN_AND", &"CREDIT_BRIAN_GILMAN_CAPS" );
	addSpaceSmall();
	// Additional Art
	// ANDREW CLARK
	addCenterDual( &"CREDIT_ADDITIONAL_ART", &"CREDIT_ANDREW_CLARK_CAPS" );
	// JAVIER OJEDA
	addCenterName( &"CREDIT_JAVIER_OJEDA_CAPS" );
	// JIWON SON
	addCenterName( &"CREDIT_JIWON_SON_CAPS" );
	addSpace();
	addSpace();
	// Translations
	addCenterHeading( &"CREDIT_TRANSLATIONS" );
	addSpaceSmall();
	// Applied Languages
	addCenterHeading( &"CREDIT_APPLIED_LANGUAGES" );
	// World Lingo
	addCenterHeading( &"CREDIT_WORLD_LINGO" );
	// Unique Artists
	addCenterHeading( &"CREDIT_UNIQUE_ARTISTS" );
	addSpace();
	addSpace();
	// Weapon Armorers and Range
	addCenterHeading( &"CREDIT_WEAPON_ARMORERS_AND_RANGE" );
	addSpaceSmall();
	// Gibbons, Ltd
	addCenterHeading( &"CREDIT_GIBBONS_LTD" );
	// Long Mountain Outfitters
	addCenterHeading( &"CREDIT_LONG_MOUNTAIN_OUTFITTERS" );
	// Bob Maupin Ranch
	addCenterHeading( &"CREDIT_BOB_MAUPIN_RANCH" );
	addSpace();
	addSpace();

	if ( level.console && !level.xenon )// PS3 only
	{

		// Additional Programming by Demonware
		addCenterHeading( &"CREDIT_ADDITIONAL_PROGRAMMING_DEMONWARE" );
		addSpaceSmall();
		// SEAN BLANCHFIELD
		// MORGAN BRICKLEY
		addCenterNameDouble( &"CREDIT_SEAN_BLANCHFIELD_CAPS", &"CREDIT_MORGAN_BRICKLEY_CAPS" );
		// DYLAN COLLINS
		// MICHAEL COLLINS
		addCenterNameDouble( &"CREDIT_DYLAN_COLLINS_CAPS", &"CREDIT_MICHAEL_COLLINS_CAPS" );
		// MALCOLM DOWSE
		// STEFFEN HIGELS
		addCenterNameDouble( &"CREDIT_MALCOLM_DOWSE_CAPS", &"CREDIT_STEFFEN_HIGELS_CAPS" );
		// TONY KELLY
		// JOHN KIRK
		addCenterNameDouble( &"CREDIT_TONY_KELLY_CAPS", &"CREDIT_JOHN_KIRK_CAPS" );
		// CRAIG MCINNES
		// ALEX MONTGOMERY
		addCenterNameDouble( &"CREDIT_CRAIG_MCINNES_CAPS", &"CREDIT_ALEX_MONTGOMERY_CAPS" );
		// EOIN O'FEARGHAIL
		// RUAIDHRI POWER
		addCenterNameDouble( &"CREDIT_EOIN_OFEARGHAIL_CAPS", &"CREDIT_RUAIDHRI_POWER_CAPS" );
		// TILMAN SCHÄFER
		// AMY SMITH
		addCenterNameDouble( &"CREDIT_TILMAN_SCHAFER_CAPS", &"CREDIT_AMY_SMITH_CAPS" );
		// EMMANUEL STONE
		// ROB SYNNOTT
		addCenterNameDouble( &"CREDIT_EMMANUEL_STONE_CAPS", &"CREDIT_ROB_SYNNOTT_CAPS" );
		// VLAD TITOV
		// string not found for 
		addCenterNameDouble( &"CREDIT_VLAD_TITOV_CAPS", &"" );
		addSpace();
		addSpace();
	}

	// Additional Art provided by The Ant Farm
	addCenterHeading( &"CREDIT_ADDITIONAL_ART_PROVIDED_ANT_FARM" );
	addSpaceSmall();
	// Producer
	// SCOTT CARSON
	addCenterDual( &"CREDIT_PRODUCER", &"CREDIT_SCOTT_CARSON_CAPS" );
	addSpaceSmall();
	// Senior Editor
	// SCOTT COOKSON
	addCenterDual( &"CREDIT_SENIOR_EDITOR", &"CREDIT_SCOTT_COOKSON_CAPS" );
	addSpaceSmall();
	// Associate Producer
	// SETH HENDRIX
	addCenterDual( &"CREDIT_ASSOCIATE_PRODUCER", &"CREDIT_SETH_HENDRIX_CAPS" );
	addSpaceSmall();
	// Executive Creative Directors
	// LISA RIZNIKOVE\n 
	addCenterDual( &"CREDIT_EXECUTIVE_CREATIVE_DIRECTORS", &"CREDIT_LISA_RIZNIKOVE_CAPS" );
	// ROB TROY
	addCenterName( &"CREDIT_ROB_TROY_CAPS" );
	addSpace();
	addSpace();
	// Voice Recording Facilities provided by
	addCenterHeading( &"CREDIT_VOICE_RECORDING_FACILITIES" );
	addSpaceSmall();
	// PCB Productions, Encino, CA
	addCenterHeading( &"CREDIT_PCB_PRODUCTIONS" );
	// Side-UK, London, UK
	addCenterHeading( &"CREDIT_SIDEUK" );
	addSpaceSmall();
	// Voice Direction/Dialog Engineering
	// KEITH AREM
	addCenterDual( &"CREDIT_VOICE_DIRECTIONDIALOG", &"CREDIT_KEITH_AREM_CAPS" );
	addSpaceSmall();
	// Additional Dialog Engineering
	// ANT HALES
	addCenterDual( &"CREDIT_ADDITIONAL_DIALOG_ENGINEERING", &"CREDIT_ANT_HALES_CAPS" );
	addSpaceSmall();
	// Additional Voice Direction
	// STEVE FUKUDA
	addCenterDual( &"CREDIT_ADDITIONAL_VOICE_DIRECTION", &"CREDIT_STEVE_FUKUDA_CAPS" );
	// MACKEY MCCANDLISH
	addCenterName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
	addSpace();
	addSpace();
	// Motion Capture provided by Neversoft Entertainment
	addCenterHeading( &"CREDIT_MOTION_CAPTURE_PROVIDED" );
	addSpaceSmall();
	// Motion Capture Lead
	// KRISTINA ADELMEYER
	addCenterDual( &"CREDIT_MOTION_CAPTURE_LEAD", &"CREDIT_KRISTINA_ADELMEYER_CAPS" );
	addSpaceSmall();
	// Motion Capture Technicians
	// KRISTIN GALLAGHER
	addCenterDual( &"CREDIT_MOTION_CAPTURE_TECHNICIANS", &"CREDIT_KRISTIN_GALLAGHER_CAPS" );
	// JEFF SWENTY
	addCenterName( &"CREDIT_JEFF_SWENTY_CAPS" );
	addSpaceSmall();
	// Motion Capture Intern
	// JORGE LOPEZ
	addCenterDual( &"CREDIT_MOTION_CAPTURE_INTERN", &"CREDIT_JORGE_LOPEZ_CAPS" );
	addSpace();
	addSpace();
	// Stunt Action designed by 87eleven Action Film Co.
	addCenterHeading( &"CREDIT_STUNT_ACTION_DESIGNED" );
	addSpaceSmall();
	// Stunt Coordinator
	// DANNY HERNANDEZ
	addCenterDual( &"CREDIT_STUNT_COORDINATOR", &"CREDIT_DANNY_HERNANDEZ_CAPS" );
	addSpaceSmall();
	// Stunts/Motion Capture Actors
	// ROBERT ALONSO
	addCenterDual( &"CREDIT_STUNTSMOTION_CAPTURE", &"CREDIT_ROBERT_ALONSO_CAPS" );
	// DANNY HERNANDEZ
	addCenterName( &"CREDIT_DANNY_HERNANDEZ_CAPS" );
	// ALLEN JO
	addCenterName( &"CREDIT_ALLEN_JO_CAPS" );
	// DAVID LEITCH
	addCenterName( &"CREDIT_DAVID_LEITCH_CAPS" );
	// MIKE MUKATIS
	addCenterName( &"CREDIT_MIKE_MUKATIS_CAPS" );
	// RYAN WATSON
	addCenterName( &"CREDIT_RYAN_WATSON_CAPS" );
	addSpace();
	addSpace();
	// Cinematic Movies provided by SPOV.TV
	addCenterHeading( &"CREDIT_CINEMATIC_MOVIES_PROVIDED" );
	addSpace();
	// Vehicles provided by Army Trucks, Inc
	addCenterHeading( &"CREDIT_VEHICLES_PROVIDED_BY" );
	addSpace();

	if ( !level.console )// PC only
	{
		// Additional Programming by Even Balance
		addCenterHeading( &"CREDIT_ADDITIONAL_PROGRAMMING_EVEN_BALANCE" );
		addSpace();
	}

	// Additional Art provided by Xpec and Shadows in Darkness
	addCenterHeading( &"CREDIT_ADDITIONAL_ART_PROVIDED" );
	addSpace();
	// Additional Sound Design provided by Earbash Audio, Inc
	addCenterHeading( &"CREDIT_ADDITIONAL_SOUND_DESIGN" );
	addSpace();
	// Additional Audio Engineering Provided by Digital Synapse\n
	addCenterHeading( &"CREDIT_ADDITIONAL_AUDIO_ENGINEERING_DIGITAL_SYNAPSE" );
	addSpace();
	addSpace();
	// Production Babies
	addCenterHeading( &"CREDIT_PRODUCTION_BABIES" );
	addSpaceSmall();
	// Baby Colin Alderman and Mother Maryanne
	addCenterHeading( &"CREDIT_BABY_COLIN_ALDERMAN" );
	// Baby Luke Smith and Mother Lisa
	addCenterHeading( &"CREDIT_BABY_LUKE_SMITH" );
	// Baby John Galt West (Jack) and Mother Adriana
	addCenterHeading( &"CREDIT_BABY_JOHN_GALT_WEST_JACK" );
	// Baby Courtney Zampella and Mother Brigitte
	addCenterHeading( &"CREDIT_BABY_COURTNEY_ZAMPELLA" );
	addSpace();
	addSpace();
	// Infinity Ward Special Thanks
	addCenterHeading( &"CREDIT_INFINITY_WARD_SPECIAL" );
	addSpaceSmall();
	// USMC Public Affairs Office
	addCenterHeading( &"CREDIT_USMC_PUBLIC_AFFAIRS_OFFICE" );
	// USMC 1st Tank Battalion
	addCenterHeading( &"CREDIT_USMC_1ST_TANK_BATTALION" );
	// Marine Light Attack Helicopter Squadron 775
	addCenterHeading( &"CREDIT_MARINE_LIGHT_ATTACK_HELICOPTER" );
	// USMC 5th Battalion, 14th Marines
	addCenterHeading( &"CREDIT_USMC_5TH_BATTALION_14TH" );
	// Army 1st Cavalry Division Museum
	addCenterHeading( &"CREDIT_ARMY_1ST_CAVALRY_DIVISION" );
	addSpace();
	// DAVE DOUGLAS
	// DAVID FALICKI
	addCenterNameDouble( &"CREDIT_DAVE_DOUGLAS_CAPS", &"CREDIT_DAVID_FALICKI_CAPS" );
	// ROCK GALLOTTI
	// MICHAEL GIBBONS
	addCenterNameDouble( &"CREDIT_ROCK_GALLOTTI_CAPS", &"CREDIT_MICHAEL_GIBBONS_CAPS" );
	// LAWRENCE GREEN
	// ANDREW HOFFACKER
	addCenterNameDouble( &"CREDIT_LAWRENCE_GREEN_CAPS", &"CREDIT_ANDREW_HOFFACKER_CAPS" );
	// J.D. KEIRSEY
	// ROBERT MAUPIN
	addCenterNameDouble( &"CREDIT_JD_KEIRSEY_CAPS", &"CREDIT_ROBERT_MAUPIN_CAPS" );
	// BRIAN DOC" MAYNARD"
	// LARRY ZANOFF
	addCenterNameDouble( &"CREDIT_BRIAN_MAYNARD_CAPS", &"CREDIT_LARRY_ZANOFF_CAPS" );
	// CALEB BARNHART
	// JOHN BUDD
	addCenterNameDouble( &"CREDIT_CALEB_BARNHART_CAPS", &"CREDIT_JOHN_BUDD_CAPS" );
	// SCOTT CARPENTER
	// JOSHUA CARRILLO
	addCenterNameDouble( &"CREDIT_SCOTT_CARPENTER_CAPS", &"CREDIT_JOSHUA_CARRILLO_CAPS" );
	// DAVID COFFEY
	// CHRISTOPHER DARE
	addCenterNameDouble( &"CREDIT_DAVID_COFFEY_CAPS", &"CREDIT_CHRISTOPHER_DARE_CAPS" );
	// NICK DUNCAN
	// JOSE GO, JR
	addCenterNameDouble( &"CREDIT_NICK_DUNCAN_CAPS", &"CREDIT_JOSE_GO_JR_CAPS" );
	// JEREMY HULL
	// GORDON JAMES
	addCenterNameDouble( &"CREDIT_JEREMY_HULL_CAPS", &"CREDIT_GORDON_JAMES_CAPS" );
	// STEVEN JONES
	// MICHAEL LISCOTTI
	addCenterNameDouble( &"CREDIT_STEVEN_JONES_CAPS", &"CREDIT_MICHAEL_LISCOTTI_CAPS" );
	// STEPHANIE MARTINEZ
	// C ANTHONY MARQUEZ
	addCenterNameDouble( &"CREDIT_STEPHANIE_MARTINEZ_CAPS", &"CREDIT_C_ANTHONY_MARQUEZ_CAPS" );
	// CODY MAUTER
	// JOSEPH MCCREARY
	addCenterNameDouble( &"CREDIT_CODY_MAUTER_CAPS", &"CREDIT_JOSEPH_MCCREARY_CAPS" );
	// GREG MESSINGER
	// MICHAEL RETZLAFF
	addCenterNameDouble( &"CREDIT_GREG_MESSINGER_CAPS", &"CREDIT_MICHAEL_RETZLAFF_CAPS" );
	// ANGEL SANCHEZ
	// KYLE SMITH
	addCenterNameDouble( &"CREDIT_ANGEL_SANCHEZ_CAPS", &"CREDIT_KYLE_SMITH_CAPS" );
	// ALAN STERN
	// ANGEL TORRES
	addCenterNameDouble( &"CREDIT_ALAN_STERN_CAPS", &"CREDIT_ANGEL_TORRES_CAPS" );
	// OSCAR VILLAMOR
	// LARRY ZENG
	addCenterNameDouble( &"CREDIT_OSCAR_VILLAMOR", &"CREDIT_LARRY_ZENG_CAPS" );
	addSpace();
	addSpace();
	addSpace();
	addSpace();
}

initActivisionCredits()
{
	addCenterImage( "logo_activision", 256, 128, 3.875 );// 3.1
	addSpace();
	addSpace();
	// Production
	addCenterHeading( &"CREDIT_PRODUCTION" );
	addSpaceSmall();
	// Producer
	// SAM NOURIANI
	addCenterDual( &"CREDIT_PRODUCER", &"CREDIT_SAM_NOURIANI_CAPS" );
	addSpaceSmall();
	// Associate Producers
	// NEVEN DRAVINSKI
	addCenterDual( &"CREDIT_ASSOCIATE_PRODUCERS", &"CREDIT_NEVEN_DRAVINSKI_CAPS" );
	// DEREK RACCA
	addCenterName( &"CREDIT_DEREK_RACCA_CAPS" );
	addSpaceSmall();
	// Production Coordinators
	// RHETT CHASSEREAU
	addCenterDual( &"CREDIT_PRODUCTION_COORDINATORS", &"CREDIT_RHETT_CHASSEREAU_CAPS" );
	// VINCENT FENNEL
	addCenterName( &"CREDIT_VINCENT_FENNEL_CAPS" );
	// ANDREW HOFFACKER
	addCenterName( &"CREDIT_ANDREW_HOFFACKER_CAPS" );
	addSpaceSmall();
	// Production Tester
	// WINYAN JAMES
	addCenterDual( &"CREDIT_PRODUCTION_TESTER", &"CREDIT_WINYAN_JAMES_CAPS" );
	addSpaceSmall();
	// Production Intern
	// JACOB THOMPSON
	addCenterDual( &"CREDIT_PRODUCTION_INTERN", &"CREDIT_JACOB_THOMPSON_CAPS" );
	addSpaceSmall();
	// Executive Producer
	// MARCUS IREMONGER
	addCenterDual( &"CREDIT_EXECUTIVE_PRODUCER", &"CREDIT_MARCUS_IREMONGER_CAPS" );
	addSpaceSmall();
	// Vice President, Production
	// STEVE ACKRICH
	addCenterDual( &"CREDIT_VICE_PRESIDENT_PRODUCTION", &"CREDIT_STEVE_ACKRICH_CAPS" );
	// THAINE LYMAN
	addCenterName( &"CREDIT_THAINE_LYMAN_CAPS" );
	addSpaceSmall();
	// Head of Production
	// LAIRD MALAMED
	addCenterDual( &"CREDIT_HEAD_OF_PRODUCTION", &"CREDIT_LAIRD_MALAMED_CAPS" );
	addSpace();
	addSpace();
	// Global Brand Management
	addCenterHeading( &"CREDIT_GLOBAL_BRAND_MANAGEMENT" );
	addSpaceSmall();
	// Senior Brand Manager
	// TABITHA HAYES
	addCenterDual( &"CREDIT_SENIOR_BRAND_MANAGER", &"CREDIT_TABITHA_HAYES_CAPS" );
	addSpaceSmall();
	// Associate Brand Manager
	// JON DELODDER
	addCenterDual( &"CREDIT_ASSOCIATE_BRAND_MANAGER", &"CREDIT_JON_DELODDER_CAPS" );
	addSpaceSmall();
	// Marketing Associate
	// MIKE RUDIN
	addCenterDual( &"CREDIT_MARKETING_ASSOCIATE", &"CREDIT_MIKE_RUDIN_CAPS" );
	addSpaceSmall();
	// Director, Global Brand Management
	// TOM SILK
	addCenterDual( &"CREDIT_DIRECTOR_GLOBAL_BRAND_MANAGEMENT", &"CREDIT_TOM_SILK_CAPS" );
	addSpace();
	addSpace();
	// Public Relations
	addCenterHeading( &"CREDIT_PUBLIC_RELATIONS" );
	addSpaceSmall();
	// Senior PR Manager
	// MIKE MANTARRO
	addCenterDual( &"CREDIT_SENIOR_PR_MANAGER", &"CREDIT_MIKE_MANTARRO_CAPS" );
	addSpaceSmall();
	// Senior Publicist
	// KATHY BRICAUD
	addCenterDual( &"CREDIT_SENIOR_PUBLICIST", &"CREDIT_KATHY_BRICAUD_CAPS" );
	addSpaceSmall();
	// Junior Publicist
	// ROBERT TAYLOR
	addCenterDual( &"CREDIT_JUNIOR_PUBLICIST", &"CREDIT_ROBERT_TAYLOR_CAPS" );
	addSpaceSmall();
	// Senior PR Director
	// MICHELLE SCHRODER
	addCenterDual( &"CREDIT_SENIOR_PR_DIRECTOR", &"CREDIT_MICHELLE_SCHRODER_CAPS" );
	addSpaceSmall();
	// European PR Director
	// TIM PONTING
	addCenterDual( &"CREDIT_EUROPEAN_PR_DIRECTOR", &"CREDIT_TIM_PONTING_CAPS" );
	addSpaceSmall();
	// Step 3
	// WIEBKE HESS
	addCenterDual( &"CREDIT_STEP_3", &"CREDIT_WIEBKE_HESS_CAPS" );
	// JON LENAWAY
	addCenterName( &"CREDIT_JON_LENAWAY_CAPS" );
	// NEIL WOOD
	addCenterName( &"CREDIT_NEIL_WOOD_CAPS" );
	addSpace();
	addSpace();
	// Central Localizations
	addCenterHeading( &"CREDIT_CENTRAL_LOCALIZATIONS" );
	addSpaceSmall();
	// Director of Production Services, Europe
	// BARRY KEHOE
	addCenterDual( &"CREDIT_DIRECTOR_OF_PRODUCTION", &"CREDIT_BARRY_KEHOE_CAPS" );
	addSpaceSmall();
	// Senior Localization Project Manager
	// FIONA EBBS
	addCenterDual( &"CREDIT_SENIOR_LOCALIZATION_PROJECT", &"CREDIT_FIONA_EBBS_CAPS" );
	addSpaceSmall();
	// Localization Consultant
	// STEPHANIE O'MALLEY DEMING
	addCenterDual( &"CREDIT_LOCALIZATION_CONSULTANT", &"CREDIT_STEPHANIE_OMALLEY_DEMING_CAPS" );
	addSpaceSmall();
	// Localization Coordinator
	// CHRIS OSBERG
	addCenterDual( &"CREDIT_LOCALIZATION_COORDINATOR", &"CREDIT_CHRIS_OSBERG_CAPS" );
	addSpaceSmall();
	// Localization Engineer
	// PHIL COUNIHAN
	addCenterDual( &"CREDIT_LOCALIZATION_ENGINEER", &"CREDIT_PHIL_COUNIHAN_CAPS" );
	addSpaceSmall();
	// Brand Manager, Europe
	// STEFAN SEIDEL
	addCenterDual( &"CREDIT_BRAND_MANAGER_EUROPE", &"CREDIT_STEFAN_SEIDEL_CAPS" );
	addSpace();
	// Localization Tools & Support Provided by Xloc Inc.
	addCenterHeading( &"CREDIT_LOCALIZATION_TOOLS" );
	addSpace();
	addSpace();
	// Marketing Communications
	addCenterHeading( &"CREDIT_MARKETING_COMMUNICATIONS" );
	addSpaceSmall();
	// Vice President of Marketing Communications
	// DENISE WALSH
	addCenterDual( &"CREDIT_VICE_PRESIDENT_OF_MARKETING", &"CREDIT_DENISE_WALSH_CAPS" );
	addSpaceSmall();
	// Director of Marketing Communications
	// SUSAN HALLOCK
	addCenterDual( &"CREDIT_DIRECTOR_OF_MARKETING", &"CREDIT_SUSAN_HALLOCK_CAPS" );
	addSpaceSmall();
	// Marketing Communications Manager
	// KAREN STARR
	addCenterDual( &"CREDIT_MARKETING_COMMUNICATIONS_MANAGER", &"CREDIT_KAREN_STARR_CAPS" );
	addSpaceSmall();
	// Marketing Communications Coordinator
	// KRISTINA JOLLY
	addCenterDual( &"CREDIT_MARKETING_COMMUNICATIONS_COORDINATOR", &"CREDIT_KRISTINA_JOLLY_CAPS" );
	addSpace();
	addSpace();
	// Business and Legal Affairs
	addCenterHeading( &"CREDIT_BUSINESS_AND_LEGAL_AFFAIRS" );
	addSpaceSmall();
	// Director, Government and Legislative Affairs
	// PHIL TERZIAN
	addCenterDual( &"CREDIT_DIRECTOR_GOVERNMENT_AND", &"CREDIT_PHIL_TERZIAN_CAPS" );
	addSpaceSmall();
	// Transactional Attorney
	// TRAVIS STANSBURY
	addCenterDual( &"CREDIT_TRANSACTIONAL_ATTORNEY", &"CREDIT_TRAVIS_STANSBURY_CAPS" );
	addSpaceSmall();
	// Senior Paralegal
	// KAP KANG
	addCenterDual( &"CREDIT_SENIOR_PARALEGAL", &"CREDIT_KAP_KANG_CAPS" );
	addSpace();
	addSpace();
	// Operations and Studio Planning
	addCenterHeading( &"CREDIT_OPERATIONS_AND_STUDIO" );
	addSpaceSmall();
	// Senior Director of Production Services
	// SUZAN RUDE
	addCenterDual( &"CREDIT_SENIOR_DIRECTOR_OF_PRODUCTION", &"CREDIT_SUZAN_RUDE_CAPS" );
	addSpace();
	addSpace();
	// Central Technology
	addCenterHeading( &"CREDIT_CENTRAL_TECHNOLOGY" );
	addSpaceSmall();
	// Senior Manger, Central Technology
	// ED CLUNE
	addCenterDual( &"CREDIT_SENIOR_MANGER_CENTRAL", &"CREDIT_ED_CLUNE_CAPS" );
	addSpaceSmall();
	// Junior Software Engineer
	// RYAN FORD
	addCenterDual( &"CREDIT_JUNIOR_SOFTWARE_ENGINEER", &"CREDIT_RYAN_FORD_CAPS" );
	addSpaceSmall();
	// Technical Director
	// PAT GRIFFITH
	addCenterDual( &"CREDIT_TECHNICAL_DIRECTOR", &"CREDIT_PAT_GRIFFITH_CAPS" );
	addSpaceSmall();
	// Senior Director, Technology
	// JOHN BOJORQUEZ
	addCenterDual( &"CREDIT_SENIOR_DIRECTOR_TECHNOLOGY", &"CREDIT_JOHN_BOJORQUEZ_CAPS" );
	addSpace();
	addSpace();
	// Central Audio
	addCenterHeading( &"CREDIT_CENTRAL_AUDIO" );
	addSpaceSmall();
	// Director, Central Audio
	// ADAM LEVENSON
	addCenterDual( &"CREDIT_DIRECTOR_CENTRAL_AUDIO", &"CREDIT_ADAM_LEVENSON_CAPS" );
	addSpace();
	addSpace();
	// Music Department
	addCenterHeading( &"CREDIT_MUSIC_DEPARTMENT" );
	addSpaceSmall();
	// Worldwide Executive of Music
	// TIM RILEY
	addCenterDual( &"CREDIT_WORLDWIDE_EXECUTIVE", &"CREDIT_TIM_RILEY_CAPS" );
	addSpaceSmall();
	// Music Supervisors
	// SCOTT MCDANIEL
	addCenterDual( &"CREDIT_MUSIC_SUPERVISORS", &"CREDIT_SCOTT_MCDANIEL_CAPS" );
	// BRANDON YOUNG
	addCenterName( &"CREDIT_BRANDON_YOUNG" );
	addSpaceSmall();
	// Music Department Coordinator
	// JONATHAN BODELL
	addCenterDual( &"CREDIT_MUSIC_DEPARTMENT_COORDINATOR", &"CREDIT_JONATHAN_BODELL_CAPS" );
	addSpace();
	addSpace();
	// Music
	addCenterHeading( &"CREDIT_MUSIC" );
	addSpace();
	// Church""
	addCenterHeading( &"CREDIT_CHURCH" );
	// Written by Sean Price, Jahman Bush, M. Elissen, T. Flaaten
	addCenterHeading( &"CREDIT_WRITTEN_BY_SEAN_PRICE" );
	// Performed by Sean Price
	addCenterHeading( &"CREDIT_PERFORMED_BY_SEAN_PRICE" );
	// Courtesy of Duck Down Music
	addCenterHeading( &"CREDIT_COURTESY_OF_DUCK_DOWN" );
	addSpace();
	// National Anthem of the USSR""
	addCenterHeading( &"CREDIT_NATIONAL_ANTHEM_OF_THE" );
	// Written by Anatolij N. Alexandrov
	addCenterHeading( &"CREDIT_WRITTEN_BY_ANATOLIJ_N" );
	// Performed by the Red Army Choir
	addCenterHeading( &"CREDIT_PERFORMED_BY_THE_RED" );
	// Published by G. Schirmer administered by Music Sales
	addCenterHeading( &"CREDIT_PUBLISHED_BY_G_SCHIRMER" );
	// Courtesy of Silva Screen Music America by arrangement with SBMC, Inc.
	addCenterHeading( &"CREDIT_COURTESY_OF_SILVA_SCREEN" );
	addSpace();
	// Rescued!""
	addCenterHeading( &"CREDIT_RESCUED" );
	// Written by Abraham Lass
	addCenterHeading( &"CREDIT_WRITTEN_BY_ABRAHAM_LASS" );
	// Published by TRF Music Inc. / Alpha Music Inc.
	addCenterHeading( &"CREDIT_PUBLISHED_BY_TRF_MUSIC" );
	// Used by Permission
	addCenterHeading( &"CREDIT_USED_BY_PERMISSION" );
	addSpace();
	// Deep and Hard""
	addCenterHeading( &"CREDIT_DEEP_AND_HARD" );
	// Written by Mark Grigsby
	addCenterHeading( &"CREDIT_WRITTEN_BY_MARK_GRIGSBY" );
	// Performed by Mark Grigsby
	addCenterHeading( &"CREDIT_PERFORMED_BY_MARK_GRIGSBY" );
	// Mixed by Stephen Miller
	addCenterHeading( &"CREDIT_MIXED_BY_STEPHEN_MILLER" );
	addSpace();
	addSpace();
	// Finance
	addCenterHeading( &"CREDIT_FINANCE" );
	addSpaceSmall();
	// Manager Controller
	// JASON DALBOTTEN
	addCenterDual( &"CREDIT_MANAGER_CONTROLLER", &"CREDIT_JASON_DALBOTTEN_CAPS" );
	addSpaceSmall();
	// Finance Manager
	// HARJINDER SINGH\n
	addCenterDual( &"CREDIT_FINANCE_MANAGER", &"CREDIT_HARJINDER_SINGH_CAPS" );
	addSpaceSmall();
	// Finance Analyst
	// ADRIAN GOMEZ
	addCenterDual( &"CREDIT_FINANCE_ANALYST", &"CREDIT_ADRIAN_GOMEZ_CAPS" );
	addSpace();
	addSpace();
	// Activision Special Thanks
	addCenterHeading( &"CREDIT_ACTIVISION_SPECIAL_THANKS" );
	addSpaceSmall();
	// MIKE GRIFFITH
	// ROBIN KAMINSKY
	addCenterNameDouble( &"CREDIT_MIKE_GRIFFITH_CAPS", &"CREDIT_ROBIN_KAMINSKY_CAPS" );
	// BRIAN WARD
	// DAVE STOHL
	addCenterNameDouble( &"CREDIT_BRIAN_WARD_CAPS", &"CREDIT_DAVE_STOHL_CAPS" );
	// STEVE PEARCE
	// WILL KASSOY
	addCenterNameDouble( &"CREDIT_STEVE_PEARCE_CAPS", &"CREDIT_WILL_KASSOY_CAPS" );
	// DUSTY WELCH
	// LAIRD MALAMED
	addCenterNameDouble( &"CREDIT_DUSTY_WELCH_CAPS", &"CREDIT_LAIRD_MALAMED_CAPS" );
	// NOAH HELLER
	// GEOFF CARROLL
	addCenterNameDouble( &"CREDIT_NOAH_HELLER_CAPS", &"CREDIT_GEOFF_CARROLL_CAPS" );
	// SASHA GROSS
	// JEN FOX
	addCenterNameDouble( &"CREDIT_SASHA_GROSS_CAPS", &"CREDIT_JEN_FOX_CAPS" );
	// MARCHELE HARDIN
	// JB SPISSO
	addCenterNameDouble( &"CREDIT_MARCHELE_HARDIN_CAPS", &"CREDIT_JB_SPISSO_CAPS" );
	// RIC ROMERO
	// string not found for 
	addCenterNameDouble( &"CREDIT_RIC_ROMERO_CAPS", &"" );
	addSpace();
	addSpace();
	// Quality Assurance
	addCenterHeading( &"CREDIT_QUALITY_ASSURANCE" );
	addSpaceSmall();
	// Lead, QA Functionality
	// MARIO HERNANDEZ
	addCenterDual( &"CREDIT_LEAD_QA_FUNCTIONALITY", &"CREDIT_MARIO_HERNANDEZ_CAPS" );
	// ERIK MELEN
	addCenterName( &"CREDIT_ERIK_MELEN_CAPS" );
	addSpaceSmall();
	// Senior Lead, QA Functionality
	// EVAN BUTTON
	addCenterDual( &"CREDIT_SENIOR_LEAD_QA_FUNCTIONALITY", &"CREDIT_EVAN_BUTTON_CAPS" );
	addSpaceSmall();
	// Manager, QA Functionality
	// GLENN VISTANTE
	addCenterDual( &"CREDIT_MANAGER_QA_FUNCTIONALITY", &"CREDIT_GLENN_VISTANTE_CAPS" );
	addSpaceSmall();
	// Floor Leads, QA Functionality
	// VICTOR DURLING
	addCenterDual( &"CREDIT_FLOOR_LEADS_QA_FUNCTIONALITY", &"CREDIT_VICTOR_DURLING_CAPS" );
	// CHAD SCHMIDT
	addCenterName( &"CREDIT_CHAD_SCHMIDT_CAPS" );
	// PETER VON OY
	addCenterName( &"CREDIT_PETER_VON_OY_CAPS" );
	addSpaceSmall();
	// QA Database Administrators
	// RICH PEARSON
	addCenterDual( &"CREDIT_QA_DATABASE_ADMINISTRATORS", &"CREDIT_RICH_PEARSON_CAPS" );
	// CHRIS SHANLEY
	addCenterName( &"CREDIT_CHRIS_SHANLEY_CAPS" );
	addSpace();
	addSpace();
	// QA Test Team
	addCenterHeading( &"CREDIT_QA_TEST_TEAM" );
	addSpaceSmall();
	// DANIEL ALFARO
	// STEVE ARAUJO
	// MIKE AZAMI
	addCenterTriple( &"CREDIT_DANIEL_ALFARO_CAPS", &"CREDIT_STEVE_ARAUJO_CAPS", &"CREDIT_MIKE_AZAMI_CAPS" );
	// STEFFEN BOEHME
	// JORDAN BONDHUS
	// BRYAN CHAMCHOUM
	addCenterTriple( &"CREDIT_STEFFEN_BOEHME_CAPS", &"CREDIT_JORDAN_BONDHUS_CAPS", &"CREDIT_BRYAN_CHAMCHOUM_CAPS" );
	// DILLON CHANCE
	// RYAN CHANN
	// ERIC CHEVEZ
	addCenterTriple( &"CREDIT_DILLON_CHANCE_CAPS", &"CREDIT_RYAN_CHANN_CAPS", &"CREDIT_ERIC_CHEVEZ_CAPS" );
	// CHRISTOPHER CODDING
	// RYAN DEAL
	// JON EARNEST
	addCenterTriple( &"CREDIT_CHRISTOPHER_CODDING_CAPS", &"CREDIT_RYAN_DEAL_CAPS", &"CREDIT_JON_EARNEST_CAPS" );
	// ISAAC FISCHER
	// DEVIN GEE
	// GIOVANNI FUNES
	addCenterTriple( &"CREDIT_ISAAC_FISCHER_CAPS", &"CREDIT_DEVIN_GEE_CAPS", &"CREDIT_GIOVANNI_FUNES_CAPS" );
	// MIKE GENADRY
	// MARC GOGOSHIAN
	// ERIC GOLDIN
	addCenterTriple( &"CREDIT_MIKE_GENADRY_CAPS", &"CREDIT_MARC_GOGOSHIAN_CAPS", &"CREDIT_ERIC_GOLDIN_CAPS" );
	// SHON GRAY
	// JONATHON HAMNER
	// SHAWN HESTLEY
	addCenterTriple( &"CREDIT_SHON_GRAY_CAPS", &"CREDIT_JONATHON_HAMNER_CAPS", &"CREDIT_SHAWN_HESTLEY_CAPS" );
	// DEMETRIUS HOSTON
	// CARSON KEENE
	// NATE KINNEY
	addCenterTriple( &"CREDIT_DEMETRIUS_HOSTON_CAPS", &"CREDIT_CARSON_KEENE_CAPS", &"CREDIT_NATE_KINNEY_CAPS" );
	// DEVIN MCGOWAN
	// MICHAEL LOYD
	// JULIO MEDINA
	addCenterTriple( &"CREDIT_DEVIN_MCGOWAN_CAPS", &"CREDIT_MICHAEL_LOYD_CAPS", &"CREDIT_JULIO_MEDINA_CAPS" );
	// JULIAN NAYDICHEV
	// KENNETH OLIPHANT
	// RODOLFO ORTEGA
	addCenterTriple( &"CREDIT_JULIAN_NAYDICHEV_CAPS", &"CREDIT_KENNETH_OLIPHANT_CAPS", &"CREDIT_RODOLFO_ORTEGA_CAPS" );
	// DAVID PARKER
	// ADRIAN PEREZ
	// BRIAN PUSCHELL
	addCenterTriple( &"CREDIT_DAVID_PARKER_CAPS", &"CREDIT_ADRIAN_PEREZ_CAPS", &"CREDIT_BRIAN_PUSCHELL_CAPS" );
	// CRYSTAL PUSCHELL
	// JASON RALYA
	// JUSTIN REID
	addCenterTriple( &"CREDIT_CRYSTAL_PUSCHELL_CAPS", &"CREDIT_JASON_RALYA_CAPS", &"CREDIT_JUSTIN_REID_CAPS" );
	// MATTHEW RICHARDSON
	// JOHN RIGGS
	// JESSE RIOS
	addCenterTriple( &"CREDIT_MATTHEW_RICHARDSON_CAPS", &"CREDIT_JOHN_RIGGS_CAPS", &"CREDIT_JESSE_RIOS_CAPS" );
	// ERNIE RITTACCO
	// HEATHER RIVERA
	// MARVIN RIVERA
	addCenterTriple( &"CREDIT_ERNIE_RITTACCO_CAPS", &"CREDIT_HEATHER_RIVERA_CAPS", &"CREDIT_MARVIN_RIVERA_CAPS" );
	// HOWARD RODELO
	// PEDRO RODRIGUEZ
	// DAN ROHAN
	addCenterTriple( &"CREDIT_HOWARD_RODELO_CAPS", &"CREDIT_PEDRO_RODRIGUEZ_CAPS", &"CREDIT_DAN_ROHAN_CAPS" );
	// JEFF ROPER
	// JONATHAN SANCHEZ
	// MICHAEL SANCHEZ
	addCenterTriple( &"CREDIT_JEFF_ROPER_CAPS", &"CREDIT_JONATHAN_SANCHEZ_CAPS", &"CREDIT_MICHAEL_SANCHEZ_CAPS" );
	// JUSTIN SCHUBER
	// ANTHONY SEALES
	// SPENCER SHERMAN
	addCenterTriple( &"CREDIT_JUSTIN_SCHUBER_CAPS", &"CREDIT_ANTHONY_SEALES_CAPS", &"CREDIT_SPENCER_SHERMAN_CAPS" );
	// CHRISTOPHER SIAPERAS
	// JEREMY SMITH
	// MICHAEL STEFFAN
	addCenterTriple( &"CREDIT_CHRISTOPHER_SIAPERAS_CAPS", &"CREDIT_JEREMY_SMITH_CAPS", &"CREDIT_MICHAEL_STEFFAN_CAPS" );
	// JASON STRAUMAN
	// BYRON TAYLOR
	// JASON VEGA
	addCenterTriple( &"CREDIT_JASON_STRAUMAN_CAPS", &"CREDIT_BYRON_TAYLOR_CAPS", &"CREDIT_JASON_VEGA_CAPS" );
	// JOHN VINSON
	// BYRON WEDDERBURN
	// BRIAN WILLIAMS
	addCenterTriple( &"CREDIT_JOHN_VINSON_CAPS", &"CREDIT_BYRON_WEDDERBURN_CAPS", &"CREDIT_BRIAN_WILLIAMS_CAPS" );
	// CHRIS WOLF
	// ROSS YANCEY
	// ROBERT YI
	addCenterTriple( &"CREDIT_CHRIS_WOLF_CAPS", &"CREDIT_ROSS_YANCEY_CAPS", &"CREDIT_ROBERT_YI_CAPS" );
	// MOISES ZET
	// GREG ZHENG
	addCenterTriple( &"CREDIT_MOISES_ZET_CAPS", "", &"CREDIT_GREG_ZHENG_CAPS" );
	addSpace();
	addSpace();
	// Night Shift Lead, QA Functionality
	// BARO JUNG
	addCenterDual( &"CREDIT_NIGHT_SHIFT_LEAD_QA_FUNCTIONALITY", &"CREDIT_BARO_JUNG_CAPS" );
	addSpaceSmall();
	// Night Shift Project Lead
	// TOM CHUA
	addCenterDual( &"CREDIT_NIGHT_SHIFT_PROJECT_LEAD", &"CREDIT_TOM_CHUA_CAPS" );
	addSpaceSmall();
	// Night Shift Senior Lead, QA Functionality 
	// PAUL COLBERT
	addCenterDual( &"CREDIT_NIGHT_SHIFT_SENIOR_LEAD", &"CREDIT_PAUL_COLBERT_CAPS" );
	addSpaceSmall();
	// Night Shift Manager, QA Functionality
	// ADAM HARTSFIELD
	addCenterDual( &"CREDIT_NIGHT_SHIFT_MANAGER_QA", &"CREDIT_ADAM_HARTSFIELD_CAPS" );
	addSpaceSmall();
	// Night Shift Floor Leads, QA Functionality
	// JULIUS HIPOLITO
	addCenterDual( &"CREDIT_NIGHT_SHIFT_FLOOR_LEADS", &"CREDIT_JULIUS_HIPOLITO_CAPS" );
	// ELIAS JIMENEZ
	addCenterName( &"CREDIT_ELIAS_JIMENEZ_CAPS" );
	// JAY MENCONI
	addCenterName( &"CREDIT_JAY_MENCONI_CAPS" );
	addSpace();
	addSpace();
	// Night Shift QA Test Team
	addCenterHeading( &"CREDIT_NIGHT_SHIFT_QA_TEST_TEAM" );
	addSpaceSmall();
	// KEVIN ARREAGA
	// TIFFANY BEH-JOHN ASGHARY
	addCenterNameDouble( &"CREDIT_KEVIN_ARREAGA_CAPS", &"CREDIT_TIFFANY_BEHJOHN_ASGHARY" );
	// BENJAMIN BARBER
	// GERALD BECKER
	addCenterNameDouble( &"CREDIT_BENJAMIN_BARBER_CAPS", &"CREDIT_GERALD_BECKER_CAPS" );
	// NIYA GREEN
	// RANDALL HERMAN
	addCenterNameDouble( &"CREDIT_NIYA_GREEN_CAPS", &"CREDIT_RANDALL_HERMAN_CAPS" );
	// ANDREW JONES
	// JEFF MITCHELL
	addCenterNameDouble( &"CREDIT_ANDREW_JONES_CAPS", &"CREDIT_JEFF_MITCHELL_CAPS" );
	// JIMMIE POTTS
	// ARON SCHOOLING
	addCenterNameDouble( &"CREDIT_JIMMIE_POTTS_CAPS", &"CREDIT_ARON_SCHOOLING_CAPS" );
	// AARON SMITH
	// DENNIS SOH
	addCenterNameDouble( &"CREDIT_AARON_SMITH_CAPS", &"CREDIT_DENNIS_SOH_CAPS" );
	// JORGE VALLADARES
	// JIMMY YANG
	addCenterNameDouble( &"CREDIT_JORGE_VALLADARES_CAPS", &"CREDIT_JIMMY_YANG_CAPS" );
	addSpace();
	addSpace();
	// TRG Senior Manager
	// CHRISTOPHER WILSON
	addCenterDual( &"CREDIT_TRG_SENIOR_MANAGER", &"CREDIT_CHRISTOPHER_WILSON_CAPS" );
	addSpaceSmall();
	// TRG Submissions Lead
	// DAN NICHOLS
	addCenterDual( &"CREDIT_TRG_SUBMISSIONS_LEAD", &"CREDIT_DAN_NICHOLS_CAPS" );
	addSpaceSmall();
	// TRG Platform Lead
	// MARC VILLANUEVA
	addCenterDual( &"CREDIT_TRG_PLATFORM_LEAD", &"CREDIT_MARC_VILLANUEVA_CAPS" );
	addSpaceSmall();
	// TRG Project Lead
	// JOAQUIN MEZA
	addCenterDual( &"CREDIT_TRG_PROJECT_LEAD", &"CREDIT_JOAQUIN_MEZA_CAPS" );
	addSpaceSmall();
	// CRG Project Lead
	// JEF SEDIVY
	addCenterDual( &"CREDIT_CRG_PROJECT_LEAD", &"CREDIT_JEF_SEDIVY_CAPS" );
	addSpaceSmall();
	// TRG Floor Leads
	// JARED BACA
	addCenterDual( &"CREDIT_TRG_FLOOR_LEADS", &"CREDIT_JARED_BACA_CAPS" );
	// TEAK HOLLEY
	addCenterName( &"CREDIT_TEAK_HOLLEY_CAPS" );
	// DAVID WILKINSON
	addCenterName( &"CREDIT_DAVID_WILKINSON_CAPS" );
	addSpace();
	addSpace();
	// TRG Testers
	addCenterHeading( &"CREDIT_TRG_TESTERS" );
	addSpaceSmall();
	// WILLIAM CAMACHO
	// PISOTH CHHAM
	addCenterNameDouble( &"CREDIT_WILLIAM_CAMACHO_CAPS", &"CREDIT_PISOTH_CHHAM_CAPS" );
	// JASON GARZA
	// CHRISTIAN HAILE
	addCenterNameDouble( &"CREDIT_JASON_GARZA_CAPS", &"CREDIT_CHRISTIAN_HAILE_CAPS" );
	// ALEX HIRSCH
	// MARTIN QUINN
	addCenterNameDouble( &"CREDIT_ALEX_HIRSCH_CAPS", &"CREDIT_MARTIN_QUINN_CAPS" );
	// RHONDA RAMIREZ
	// JAMES ROSE
	addCenterNameDouble( &"CREDIT_RHONDA_RAMIREZ_CAPS", &"CREDIT_JAMES_ROSE_CAPS" );
	// MARK RUZICKA
	// JACOB ZWIRN
	addCenterNameDouble( &"CREDIT_MARK_RUZICKA_CAPS", &"CREDIT_JACOB_ZWIRN_CAPS" );
	addSpace();
	addSpace();
	// TRG Platform Lead
	// KYLE CAREY
	addCenterDual( &"CREDIT_TRG_PLATFORM_LEAD", &"CREDIT_KYLE_CAREY_CAPS" );
	addSpaceSmall();
	// TRG Project Lead
	// JASON HARRIS
	addCenterDual( &"CREDIT_TRG_PROJECT_LEAD", &"CREDIT_JASON_HARRIS_CAPS" );
	addSpaceSmall();
	// TRG Floor Leads
	// KEITH KODAMA
	addCenterDual( &"CREDIT_TRG_FLOOR_LEADS", &"CREDIT_KEITH_KODAMA_CAPS" );
	// JON SHELTMIRE
	addCenterName( &"CREDIT_JON_SHELTMIRE_CAPS" );
	// TOMO SHIKAMI
	addCenterName( &"CREDIT_TOMO_SHIKAMI_CAPS" );
	addSpace();
	addSpace();
	// TRG Testers
	addCenterHeading( &"CREDIT_TRG_TESTERS" );
	addSpaceSmall();
	// BENJAMIN ABEL
	// MELVIN ALLEN
	addCenterNameDouble( &"CREDIT_BENJAMIN_ABEL_CAPS", &"CREDIT_MELVIN_ALLEN_CAPS" );
	// ADAM AZAMI
	// BRIAN BAKER
	addCenterNameDouble( &"CREDIT_ADAM_AZAMI_CAPS", &"CREDIT_BRIAN_BAKER_CAPS" );
	// BRYAN BERRI
	// SCOTT BORAKOVE
	addCenterNameDouble( &"CREDIT_BRYAN_BERRI_CAPS", &"CREDIT_SCOTT_BORAKOVE_CAPS" );
	// COLIN KAWAKAMI
	// RYAN MCCULLOUGH
	addCenterNameDouble( &"CREDIT_COLIN_KAWAKAMI_CAPS", &"CREDIT_RYAN_MCCULLOUGH_CAPS" );
	// JOHN MCCURRY
	// KIRT SANCHEZ
	addCenterNameDouble( &"CREDIT_JOHN_MCCURRY_CAPS", &"CREDIT_KIRT_SANCHEZ_CAPS" );
	// EDGAR SUNGA
	// string not found for 
	addCenterNameDouble( &"CREDIT_EDGAR_SUNGA_CAPS", &"" );
	addSpace();
	addSpace();
	// Lead, Multiplayer Lab
	// GARRETT OSHIRO
	addCenterDual( &"CREDIT_LEAD_MULTIPLAYER_LAB", &"CREDIT_GARRETT_OSHIRO_CAPS" );
	addSpaceSmall();
	// Floor Leads, Multiplayer Lab
	// DOV CARSON
	addCenterDual( &"CREDIT_FLOOR_LEADS_MULTIPLAYER", &"CREDIT_DOV_CARSON_CAPS" );
	// LEONARD RODRIGUEZ
	addCenterName( &"CREDIT_LEONARD_RODRIGUEZ_CAPS" );
	// MICHAEL THOMSEN
	addCenterName( &"CREDIT_MICHAEL_THOMSEN_CAPS" );
	addSpace();
	addSpace();
	// Multiplayer Lab Testers
	addCenterHeading( &"CREDIT_MULTIPLAYER_LAB_TESTERS" );
	addSpaceSmall();
	// MIKE ASHTON
	// JAN ERICKSON
	addCenterNameDouble( &"CREDIT_MIKE_ASHTON_CAPS", &"CREDIT_JAN_ERICKSON_CAPS" );
	// MATTHEW FAWBUSH
	// FRANCO FERNANDO
	addCenterNameDouble( &"CREDIT_MATTHEW_FAWBUSH_CAPS", &"CREDIT_FRANCO_FERNANDO_CAPS" );
	// ARMOND GOODIN
	// MARIO IBARRA
	addCenterNameDouble( &"CREDIT_ARMOND_GOODIN_CAPS", &"CREDIT_MARIO_IBARRA_CAPS" );
	// JESSIE JONES
	// JAEMIN KANG
	addCenterNameDouble( &"CREDIT_JESSIE_JONES_CAPS", &"CREDIT_JAEMIN_KANG_CAPS" );
	// BRIAN LAY
	// LUKE LOUDERBACK
	addCenterNameDouble( &"CREDIT_BRIAN_LAY_CAPS", &"CREDIT_LUKE_LOUDERBACK_CAPS" );
	// KAGAN MAEVERS
	// MATT RYAN
	addCenterNameDouble( &"CREDIT_KAGAN_MAEVERS_CAPS", &"CREDIT_MATT_RYAN_CAPS" );
	// JONATHAN SADKA
	// string not found for 
	addCenterNameDouble( &"CREDIT_JONATHAN_SADKA_CAPS", &"" );
	addSpace();
	addSpace();
	// Assisted Network Lab
	// SEAN OLSON
	addCenterDual( &"CREDIT_ASSISTED_NETWORK_LAB", &"CREDIT_SEAN_OLSON_CAPS" );
	addSpaceSmall();
	// Lead, Network Lab
	// FRANCIS JIMENEZ
	addCenterDual( &"CREDIT_LEAD_NETWORK_LAB", &"CREDIT_FRANCIS_JIMENEZ_CAPS" );
	addSpaceSmall();
	// Senior Lead, Network Lab
	// CHRIS KEIM
	addCenterDual( &"CREDIT_SENIOR_LEAD_NETWORK_LAB", &"CREDIT_CHRIS_KEIM_CAPS" );
	addSpaceSmall();
	// Compatibility Testers
	// KEITH WEBER
	addCenterDual( &"CREDIT_COMPATIBILITY_TESTERS", &"CREDIT_KEITH_WEBER_CAPS" );
	// WILLIAM WHALEY
	addCenterName( &"CREDIT_WILLIAM_WHALEY_CAPS" );
	// BRANDON GILBRECH
	addCenterName( &"CREDIT_BRANDON_GILBRECH_CAPS" );
	// MIKE SALWET
	addCenterName( &"CREDIT_MIKE_SALWET_CAPS" );
	// DAMON COLLAZO
	addCenterName( &"CREDIT_DAMON_COLLAZO_CAPS" );
	addSpaceSmall();
	// Compatibility Specialist
	// JON AN
	addCenterDual( &"CREDIT_COMPATIBILITY_SPECIALIST", &"CREDIT_JON_AN_CAPS" );
	addSpaceSmall();
	// Senior Compatibility Lead
	// NEAL BARIZO
	addCenterDual( &"CREDIT_SENIOR_COMPATIBILITY", &"CREDIT_NEAL_BARIZO_CAPS" );
	addSpaceSmall();
	// Lead, Compatibility
	// CHRIS NEAL
	addCenterDual( &"CREDIT_LEAD_COMPATIBILITY", &"CREDIT_CHRIS_NEAL_CAPS" );
	addSpaceSmall();
	// Manager, QA Localizations
	// DAVID HICKEY
	addCenterDual( &"CREDIT_MANAGER_QA_LOCALIZATIONS", &"CREDIT_DAVID_HICKEY_CAPS" );
	addSpaceSmall();
	// QA Localization Lead
	// CONOR HARLOW
	addCenterDual( &"CREDIT_QA_LOCALIZATION_LEAD", &"CREDIT_CONOR_HARLOW_CAPS" );
	addSpace();
	addSpace();
	// QA Localization Testers
	addCenterHeading( &"CREDIT_QA_LOCALIZATION_TESTERS" );
	addSpaceSmall();
	// ANDREA APRILE
	// SANDRO ARAFA
	addCenterNameDouble( &"CREDIT_ANDREA_APRILE_CAPS", &"CREDIT_SANDRO_ARAFA_CAPS" );
	// HUGO BELLET
	// DANIELE CELEGHIN
	addCenterNameDouble( &"CREDIT_HUGO_BELLET_CAPS", &"CREDIT_DANIELE_CELEGHIN_CAPS" );
	// CARLOS MARTIN CHIRINO
	// ADRIAN ECHEGOYEN
	addCenterNameDouble( &"CREDIT_CARLOS_MARTIN_CHIRINO_CAPS", &"CREDIT_ADRIAN_ECHEGOYEN_CAPS" );
	// JORGE FERNANDEZ
	// DANIEL GARCIA
	addCenterNameDouble( &"CREDIT_JORGE_FERNANDEZ_CAPS", &"CREDIT_DANIEL_GARCIA_CAPS" );
	// CHRISTOPHE GEVERT
	// FRANZ HEINRICH
	addCenterNameDouble( &"CREDIT_CHRISTOPHE_GEVERT_CAPS", &"CREDIT_FRANZ_HEINRICH_CAPS" );
	// CHRISTIAN HELD
	// JACK O'HARA
	addCenterNameDouble( &"CREDIT_CHRISTIAN_HELD_CAPS", &"CREDIT_JACK_OHARA_CAPS" );
	// CLÉMENT PRIM
	// DENNIS STIFFEL
	addCenterNameDouble( &"CREDIT_CLEMENT_PRIM_CAPS", &"CREDIT_DENNIS_STIFFEL_CAPS" );
	// IGNAZIO IVAN VIRGILIO
	// string not found for 
	addCenterNameDouble( &"CREDIT_IGNAZIO_IVAN_VIRGILIO_CAPS", &"" );
	addSpace();
	addSpace();
	// Burn Room Coordinator
	// JOULE MIDDLETON
	addCenterDual( &"CREDIT_BURN_ROOM_COORDINATOR", &"CREDIT_JOULE_MIDDLETON_CAPS" );
	addSpaceSmall();
	// Burn Room Staff
	// DANNY FENG
	addCenterDual( &"CREDIT_BURN_ROOM_STAFF", &"CREDIT_DANNY_FENG_CAPS" );
	// KAI HSU
	addCenterName( &"CREDIT_KAI_HSU_CAPS" );
	// SEAN KIM
	addCenterName( &"CREDIT_SEAN_KIM_CAPS" );
	addSpaceSmall();
	// Manager CS/QA Technology
	// INDRA YEE
	addCenterDual( &"CREDIT_MANAGER_CSQA_TECHNOLOGY", &"CREDIT_INDRA_YEE_CAPS" );
	addSpaceSmall();
	// Senior Lead, QA MIS
	// DAVE GARCIA-GOMEZ
	addCenterDual( &"CREDIT_SENIOR_LEAD_QA_MIS", &"CREDIT_DAVE_GARCIAGOMEZ_CAPS" );
	addSpaceSmall();
	// QA MIS Technicians
	// TEDDY HWANG
	addCenterDual( &"CREDIT_QA_MIS_TECHNICIANS", &"CREDIT_TEDDY_HWANG_CAPS" );
	// BRIAN MARTIN
	addCenterName( &"CREDIT_BRIAN_MARTIN_CAPS" );
	// JEREMY TORRES
	addCenterName( &"CREDIT_JEREMY_TORRES_CAPS" );
	// LAWRENCE WEI
	addCenterName( &"CREDIT_LAWRENCE_WEI_CAPS" );
	addSpaceSmall();
	// Equipment Coordinators, QA MIS
	// KARLENE BROWN
	addCenterDual( &"CREDIT_EQUIPMENT_COORDINATORS", &"CREDIT_KARLENE_BROWN_CAPS" );
	// LONG LE
	addCenterName( &"CREDIT_LONG_LE_CAPS" );
	addSpaceSmall();
	// Project Lead, Database Group
	// JEREMY RICHARD
	addCenterDual( &"CREDIT_PROJECT_LEAD_DATABASE", &"CREDIT_JEREMY_RICHARD_CAPS" );
	addSpaceSmall();
	// Floor Lead, Database Group
	// KELLY HUFFINE
	addCenterDual( &"CREDIT_FLOOR_LEAD_DATABASE_GROUP", &"CREDIT_KELLY_HUFFINE_CAPS" );
	addSpaceSmall();
	// Database Group Administrators
	// JACOB PORTER
	addCenterDual( &"CREDIT_DATABASE_GROUP_ADMINISTRATORS", &"CREDIT_JACOB_PORTER_CAPS" );
	// TIMOTHY TOLEDO
	addCenterName( &"CREDIT_TIMOTHY_TOLEDO_CAPS" );
	// GEOFF OLSEN
	addCenterName( &"CREDIT_GEOFF_OLSEN_CAPS" );
	// CHRISTOPHER SHANLEY
	addCenterName( &"CREDIT_CHRISTOPHER_SHANLEY_CAPS" );
	addSpaceSmall();
	// Staffing Supervisor
	// JENNIFER VITIELLO
	addCenterDual( &"CREDIT_STAFFING_SUPERVISOR", &"CREDIT_JENNIFER_VITIELLO_CAPS" );
	addSpaceSmall();
	// QA Operations Coordinator
	// JEREMY SHORTELL
	addCenterDual( &"CREDIT_QA_OPERATIONS_COORDINATOR", &"CREDIT_JEREMY_SHORTELL_CAPS" );
	addSpaceSmall();
	// Manager, Resource Administration
	// NADINE THEUZILLOT
	addCenterDual( &"CREDIT_MANAGER_RESOURCE_ADMINISTRATION", &"CREDIT_NADINE_THEUZILLOT_CAPS" );
	addSpaceSmall();
	// Administrative Assistant
	// NIKKI GUILLOTE
	addCenterDual( &"CREDIT_ADMINISTRATIVE_ASSISTANT", &"CREDIT_NIKKI_GUILLOTE_CAPS" );
	addSpaceSmall();
	// Staffing Assistant
	// LORI LORENZO
	addCenterDual( &"CREDIT_STAFFING_ASSISTANT", &"CREDIT_LORI_LORENZO_CAPS" );
	addSpaceSmall();
	// Volt On-site Program Manager
	// RACHEL OVERTON
	addCenterDual( &"CREDIT_VOLT_ONSITE_PROGRAM_MANAGER", &"CREDIT_RACHEL_OVERTON_CAPS" );
	addSpaceSmall();
	// Volt On-site Program Coordinator
	// AILEEN GALEAS
	addCenterDual( &"CREDIT_VOLT_ONSITE_PROGRAM_COORDINATOR", &"CREDIT_AILEEN_GALEAS_CAPS" );
	addSpaceSmall();
	// Customer Support Managers
	// GARY BOLDUC
	addCenterDual( &"CREDIT_CUSTOMER_SUPPORT_MANAGERS", &"CREDIT_GARY_BOLDUC_CAPS" );
	// MICHAEL HILL
	addCenterName( &"CREDIT_MICHAEL_HILL_CAPS" );
	addSpaceSmall();
	// Director, QA Functionality
	// MARILENA RIXFORD
	addCenterDual( &"CREDIT_DIRECTOR_QA_FUNCTIONALITY", &"CREDIT_MARILENA_RIXFORD_CAPS" );
	addSpaceSmall();
	// Director, Technical Requirements Group
	// JAMES GALLOWAY
	addCenterDual( &"CREDIT_DIRECTOR_TECHNICAL_REQUIREMENTS", &"CREDIT_JAMES_GALLOWAY_CAPS" );
	addSpaceSmall();
	// Vice President, Quality Assurance
	// RICH ROBINSON
	addCenterDual( &"CREDIT_VICE_PRESIDENT_QUALITY", &"CREDIT_RICH_ROBINSON_CAPS" );
	addSpace();
	addSpace();
	// Activision QA Special Thanks
	addCenterHeading( &"CREDIT_ACTIVISION_QA_SPECIAL" );
	addSpaceSmall();
	// MATT MCCLURE
	// JOHN ROSSER
	addCenterNameDouble( &"CREDIT_MATT_MCCLURE_CAPS", &"CREDIT_JOHN_ROSSER_CAPS" );
	// ANTHONY KOROTKO
	// BRAD SAAVEDRA
	addCenterNameDouble( &"CREDIT_ANTHONY_KOROTKO_CAPS", &"CREDIT_BRAD_SAAVEDRA_CAPS" );
	// JASON POTTER
	// HENRY VILLANUEVA
	addCenterNameDouble( &"CREDIT_JASON_POTTER_CAPS", &"CREDIT_HENRY_VILLANUEVA_CAPS" );
	// PAUL WILLIAMS
	// THOM DENICK
	addCenterNameDouble( &"CREDIT_PAUL_WILLIAMS_CAPS", &"CREDIT_THOM_DENICK_CAPS" );
	// FRANK SO
	// WILLIE BOLTON
	addCenterNameDouble( &"CREDIT_FRANK_SO_CAPS", &"CREDIT_WILLIE_BOLTON_CAPS" );
	// ALEX COLEMAN
	// JEREMY SHORTELL
	addCenterNameDouble( &"CREDIT_ALEX_COLEMAN_CAPS", &"CREDIT_JEREMY_SHORTELL_CAPS" );
	addSpace();
	addSpace();
	// Manual Design
	// Ignited Minds, LLC
	addCenterDual( &"CREDIT_MANUAL_DESIGN", &"CREDIT_IGNITED_MINDS_LLC" );
	addSpaceSmall();
	// Packaging Design
	// Petrol
	addCenterDual( &"CREDIT_PACKAGING_DESIGN", &"CREDIT_PETROL" );
	addSpace();
	addSpace();
	// Uses Bink Video. Copyright © 1997-2007 by RAD Game Tools, Inc.
	addCenterHeading( &"CREDIT_USES_BINK_VIDEO_COPYRIGHT" );
	addSpace();

	if ( level.console && !level.xenon )
		// This product uses FMOD Ex Sound System" by Firelight Technologies. "
		addCenterHeading( &"CREDIT_THIS_PRODUCT_USES_FMOD" );// PS3 only
	else
		// Uses Miles Sound System. Copyright © 1991-2007 by RAD Game Tools, Inc.
		addCenterHeading( &"CREDIT_USES_MILES_SOUND_SYSTEM" );// PC and 360 only

	addSpace();
	addSpace();
	// Fonts licensed from
	addCenterHeading( &"CREDIT_FONTS_LICENSED_FROM" );
	addSpaceSmall();
	// T26 Digital Type Foundry
	addCenterHeading( &"CREDIT_T26_DIGITAL_TYPE_FOUNDRY" );
	// International Typeface Corporation
	addCenterHeading( &"CREDIT_INTERNATIONAL_TYPEFACE" );
	// Monotype Imaging
	addCenterHeading( &"CREDIT_MONOTYPE_IMAGING" );
	addSpace();
	addSpace();
	addSpace();
	addSpace();
	addSpace();
	addSpace();
	// The characters and events depicted in this game are fictitious.
	addCenterHeading( &"CREDIT_THE_CHARACTERS_AND_EVENTS1" );
	// Any similarity to actual persons, living or dead, is purely coincidental.
	addCenterHeading( &"CREDIT_THE_CHARACTERS_AND_EVENTS2" );
}

addLeftTitle( title, textscale )
{
	precacheString( title );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "lefttitle";
	temp.title = title;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addLeftName( name, textscale )
{
	precacheString( name );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "leftname";
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addSubLeftTitle( title, textscale )
{
	addLeftName( title, textscale );
}

addSubLeftName( name, textscale )
{
	precacheString( name );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "subleftname";
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addRightTitle( title, textscale )
{
	precacheString( title );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "righttitle";
	temp.title = title;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addRightName( name, textscale )
{
	precacheString( name );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "rightname";
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterHeading( heading, textscale )
{
	precacheString( heading );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "centerheading";
	temp.heading = heading;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterName( name, textscale )
{
	precacheString( name );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "centername";
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterNameDouble( name1, name2, textscale )
{
	precacheString( name1 );
	precacheString( name2 );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "centernamedouble";
	temp.name1 = name1;
	temp.name2 = name2;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterDual( title, name, textscale )
{
	precacheString( title );
	precacheString( name );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "centerdual";
	temp.title = title;
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterTriple( name1, name2, name3, textscale )
{
	precacheString( name1 );
	precacheString( name2 );
	precacheString( name3 );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "centertriple";
	temp.name1 = name1;
	temp.name2 = name2;
	temp.name3 = name3;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addSpace()
{
	temp = spawnstruct();
	temp.type = "space";

	level.linelist[ level.linelist.size ] = temp;
}

addSpaceSmall()
{
	temp = spawnstruct();
	temp.type = "spacesmall";

	level.linelist[ level.linelist.size ] = temp;
}

addCenterImage( image, width, height, delay )
{
	precacheShader( image );

	temp = spawnstruct();
	temp.type = "centerimage";
	temp.image = image;
	temp.width = width;
	temp.height = height;

	if ( isdefined( delay ) )
		temp.delay = delay;

	level.linelist[ level.linelist.size ] = temp;
}

addLeftImage( image, width, height, delay )
{
	precacheShader( image );

	temp = spawnstruct();
	temp.type = "leftimage";
	temp.image = image;
	temp.width = width;
	temp.height = height;

	if ( isdefined( delay ) )
		temp.delay = delay;

	level.linelist[ level.linelist.size ] = temp;
}

playCredits()
{
	for ( i = 0; i < level.linelist.size; i++ )
	{
		delay = 0.5;// 0.4
		type = level.linelist[ i ].type;

		if ( type == "centerimage" )
		{
			image = level.linelist[ i ].image;
			width = level.linelist[ i ].width;
			height = level.linelist[ i ].height;

			temp = newHudElem();
			temp SetShader( image, width, height );
			temp.alignX = "center";
			temp.horzAlign = "center";
			temp.x = 0;
			temp.y = 480;
			temp.sort = 2;

			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;

			if ( isdefined( level.linelist[ i ].delay ) )
				delay = level.linelist[ i ].delay;
			else
				delay = ( ( 0.037 * height ) );
				//delay = ( ( 0.0296 * height ) );
		}
		else if ( type == "leftimage" )
		{
			image = level.linelist[ i ].image;
			width = level.linelist[ i ].width;
			height = level.linelist[ i ].height;

			temp = newHudElem();
			temp SetShader( image, width, height );
			temp.alignX = "center";
			temp.horzAlign = "left";
			temp.x = 128;
			temp.y = 480;
			temp.sort = 2;

			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;

			delay = ( ( 0.037 * height ) );
			//delay = ( ( 0.0296 * height ) );
		}
		else if ( type == "lefttitle" )
		{
			title = level.linelist[ i ].title;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( title );
			temp.alignX = "left";
			temp.horzAlign = "left";
			temp.x = 28;
			temp.y = 480;

			if ( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
		}
		else if ( type == "leftname" )
		{
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( name );
			temp.alignX = "left";
			temp.horzAlign = "left";
			temp.x = 60;
			temp.y = 480;

			if ( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
		}
		else if ( type == "subleftname" )
		{
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( name );
			temp.alignX = "left";
			temp.horzAlign = "left";
			temp.x = 92;
			temp.y = 480;

			if ( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
		}
		else if ( type == "righttitle" )
		{
			title = level.linelist[ i ].title;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( title );
			temp.alignX = "left";
			temp.horzAlign = "right";
			temp.x = -132;
			temp.y = 480;

			if ( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
		}
		else if ( type == "rightname" )
		{
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( name );
			temp.alignX = "left";
			temp.horzAlign = "right";
			temp.x = -100;
			temp.y = 480;

			if ( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
		}
		else if ( type == "centerheading" )
		{
			heading = level.linelist[ i ].heading;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( heading );
			temp.alignX = "center";
			temp.horzAlign = "center";
			temp.x = 0;
			temp.y = 480;

			if ( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
		}
		else if ( type == "centerdual" )
		{
			title = level.linelist[ i ].title;
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;

			temp1 = newHudElem();
			temp1 setText( title );
			temp1.alignX = "right";
			temp1.horzAlign = "center";
			temp1.x = -8;
			temp1.y = 480;

			if ( !level.console )
				temp1.font = "default";
			else
				temp1.font = "small";

			temp1.fontScale = textscale;
			temp1.sort = 2;
			temp1.glowColor = ( 0.3, 0.6, 0.3 );
			temp1.glowAlpha = 1;

			temp2 = newHudElem();
			temp2 setText( name );
			temp2.alignX = "left";
			temp2.horzAlign = "center";
			temp2.x = 8;
			temp2.y = 480;

			if ( !level.console )
				temp2.font = "default";
			else
				temp2.font = "small";

			temp2.fontScale = textscale;
			temp2.sort = 2;
			temp2.glowColor = ( 0.3, 0.6, 0.3 );
			temp2.glowAlpha = 1;

			temp1 thread delayDestroy( 22.5 );
			temp1 moveOverTime( 22.5 );
			temp1.y = -120;

			temp2 thread delayDestroy( 22.5 );
			temp2 moveOverTime( 22.5 );
			temp2.y = -120;
		}
		else if ( type == "centertriple" )
		{
			name1 = level.linelist[ i ].name1;
			name2 = level.linelist[ i ].name2;
			name3 = level.linelist[ i ].name3;
			textscale = level.linelist[ i ].textscale;

			temp1 = newHudElem();
			temp1 setText( name1 );
			temp1.alignX = "center";
			temp1.horzAlign = "center";
			temp1.x = -160;
			temp1.y = 480;

			if ( !level.console )
				temp1.font = "default";
			else
				temp1.font = "small";

			temp1.fontScale = textscale;
			temp1.sort = 2;
			temp1.glowColor = ( 0.3, 0.6, 0.3 );
			temp1.glowAlpha = 1;

			temp2 = newHudElem();
			temp2 setText( name2 );
			temp2.alignX = "center";
			temp2.horzAlign = "center";
			temp2.x = 0;
			temp2.y = 480;

			if ( !level.console )
				temp2.font = "default";
			else
				temp2.font = "small";

			temp2.fontScale = textscale;
			temp2.sort = 2;
			temp2.glowColor = ( 0.3, 0.6, 0.3 );
			temp2.glowAlpha = 1;

			temp3 = newHudElem();
			temp3 setText( name3 );
			temp3.alignX = "center";
			temp3.horzAlign = "center";
			temp3.x = 160;
			temp3.y = 480;

			if ( !level.console )
				temp3.font = "default";
			else
				temp3.font = "small";

			temp3.fontScale = textscale;
			temp3.sort = 2;
			temp3.glowColor = ( 0.3, 0.6, 0.3 );
			temp3.glowAlpha = 1;

			temp1 thread delayDestroy( 22.5 );
			temp1 moveOverTime( 22.5 );
			temp1.y = -120;

			temp2 thread delayDestroy( 22.5 );
			temp2 moveOverTime( 22.5 );
			temp2.y = -120;

			temp3 thread delayDestroy( 22.5 );
			temp3 moveOverTime( 22.5 );
			temp3.y = -120;
		}
		else if ( type == "centername" )
		{
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( name );
			temp.alignX = "left";
			temp.horzAlign = "center";
			temp.x = 8;
			temp.y = 480;

			if ( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
		}
		else if ( type == "centernamedouble" )
		{
			name1 = level.linelist[ i ].name1;
			name2 = level.linelist[ i ].name2;
			textscale = level.linelist[ i ].textscale;

			temp1 = newHudElem();
			temp1 setText( name1 );
			temp1.alignX = "center";
			temp1.horzAlign = "center";
			temp1.x = -80;
			temp1.y = 480;

			if ( !level.console )
				temp1.font = "default";
			else
				temp1.font = "small";

			temp1.fontScale = textscale;
			temp1.sort = 2;
			temp1.glowColor = ( 0.3, 0.6, 0.3 );
			temp1.glowAlpha = 1;

			temp2 = newHudElem();
			temp2 setText( name2 );
			temp2.alignX = "center";
			temp2.horzAlign = "center";
			temp2.x = 80;
			temp2.y = 480;

			if ( !level.console )
				temp2.font = "default";
			else
				temp2.font = "small";

			temp2.fontScale = textscale;
			temp2.sort = 2;
			temp2.glowColor = ( 0.3, 0.6, 0.3 );
			temp2.glowAlpha = 1;

			temp1 thread delayDestroy( 22.5 );
			temp1 moveOverTime( 22.5 );
			temp1.y = -120;

			temp2 thread delayDestroy( 22.5 );
			temp2 moveOverTime( 22.5 );
			temp2.y = -120;
		}
		else if ( type == "spacesmall" )
			delay = 0.1875;// 0.15
		else
			assert( type == "space" );

		//wait 0.65;
		wait delay;
	}

}

delayDestroy( duration )
{
	wait duration;
	self destroy();
}