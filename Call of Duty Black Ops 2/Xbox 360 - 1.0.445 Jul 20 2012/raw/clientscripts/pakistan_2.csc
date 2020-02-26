// Test clientside script for pakistan_2

#include clientscripts\_utility;
#include clientscripts\_filter;
#include clientscripts\_argus;
#include clientscripts\_bigdog;
#include clientscripts\_glasses;

#define INCENDIARY_WATER 5

main()
{	
	// _load!
	clientscripts\_load::main();

	clientscripts\pakistan_2_fx::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\pakistan_2_amb::main();

	clientscripts\_swimming::main();  // enable swimming feature
	
	level.is_bink_playing = false;
	level.is_argus_enabled = false;
	level.onArgusNotify = ::onArgusNotify;
	level thread argus_toggle_think();
	level thread underground_fog_bank();
	init_filter_sonar_attachment( level.localPlayers[0] );
	set_filter_sonar_attachment_params( level.localPlayers[0], 0, 5, 2 );
	
	//TODO: C. Ayers: Change this client flag call to use a .gsh definition
	//register_clientflag_callback( "actor", 3, clientscripts\pakistan_2_amb::menendezStartRecording );
	register_clientflag_callback( "scriptmover", INCENDIARY_WATER, ::incendiary_water );
	
	level thread millibar_scanner_on();
	level thread millibar_scanner_off();
	
	// This needs to be called after all systems have been registered.
	waitforclient(0);

	println("*** Client : pakistan_2 running...");
	
	set_player_viewmodel( "c_usa_cia_masonjr_armlaunch_viewhands" );  // set custom viewarms for swimming section
	swimming_fog();
}

incendiary_water( localClientNum, set, newEnt )
{
	self mapshaderconstant( localClientNum, 0, "scriptVector0" );
//	
	x = 0;
	y = 1;
//	
	for( i = 75; i > 20; i-- )
	{
		y = i / 100;
	
		self setshaderconstant( localClientNum, 0, x, y, 0, 0 );
		wait(0.01);
	}

//	wait(4.0);
	
	for( i = 40; i < 100; i += 2 )
	{
		y = i / 100;
		
		self setshaderconstant( localClientNum, 0, x, y, 0, 0 );
		wait(0.01);
	}
	
	y=1;
	self setshaderconstant( localClientNum, 0, x, y, 0, 0 );
	
	
	self mapshaderconstant( localClientNum, 1, "scriptVector1" );
	self setshaderconstant( localClientNum, 1, 10, 0, 0, 0 );
}

#define ARGUS_UI_WIDTH			200
#define BOOTLOG_SPEED			0.0225

feedFacialRec(elem,tag)
{
	level endon( tag );
	i=0;
	while(1)
	{
		if (randomint(100)>50)
			elem.label=tablelookup("sp/argus_boot.csv",0,i,1)+"\n";
		wait(BOOTLOG_SPEED);
		i++;
		if (i>=371)
			i=0;
	}
}

facialRecTransition(startElem,endElem,transitionNotify)
{
	self waittill( transitionNotify );
	
	thread set_elem_alpha(startElem,0);
	thread set_elem_alpha(endElem,1);
}

set_elem_alpha(elem,alpha)
{
	SetColorElem(elem,1,1,1,alpha,0);
}

facialRecognitionUI(localClientNum,text,tag)
{
	root=NewMaterialElem(localClientNum,undefined,0,0,ARGUS_UI_WIDTH,100,"white");
	SetColorElem(root,1,1,1,0.1,0);
	elem1=NewMaterialElem(localClientNum,root,5,5,90,90,"cinematic");
	elem2=NewTextElem(localClientNum,root,100,5,95,90,text,"small",0.5);
	elem2.presentation="scrolling";
	elem2.font_style="shadowed";
	elem2.rate=3;
	elem2.columns=40;
	elem2.rows=12;

	thread feedFacialRec(elem2,tag);

	root.is_attached=1;

	return root;
}

facialRecognitionUI_Menendez(localClientNum,text,tag)
{
	root=NewMaterialElem(localClientNum,undefined,0,0,ARGUS_UI_WIDTH,100,"white");
	SetColorElem(root,1,1,1,0.1,0);
	elem1=NewMaterialElem(localClientNum,root,5,5,90,90,"cinematic");
	elem2=NewTextElem(localClientNum,root,100,5,95,90,text,"small",0.5);
	elem2.presentation="scrolling";
	elem2.font_style="shadowed";
	elem2.rate=3;
	elem2.columns=40;
	elem2.rows=12;
	elem3=NewMaterialElem(localClientNum,root,5,5,90,90,"photo_menendez");
	SetColorElem(elem3,1,1,1,0,0);

	thread feedFacialRec(elem2,tag);
	level thread facialRecTransition(elem1,elem3,"facialRec_Menendez_transition_start");

	root.is_attached=1;

	return root;
}

facialRecognitionUI_Defalco(localClientNum,text,tag)
{
	root=NewMaterialElem(localClientNum,undefined,0,0,ARGUS_UI_WIDTH,100,"white");
	SetColorElem(root,1,1,1,0.1,0);
	elem1=NewMaterialElem(localClientNum,root,5,5,90,90,"cinematic");
	elem2=NewTextElem(localClientNum,root,100,5,95,90,text,"small",0.5);
	elem2.presentation="scrolling";
	elem2.font_style="shadowed";
	elem2.rate=3;
	elem2.columns=40;
	elem2.rows=12;
	elem3=NewMaterialElem(localClientNum,root,5,5,90,90,"photo_defalco");
	SetColorElem(elem3,1,1,1,0,0);

	thread feedFacialRec(elem2,tag);
	level thread facialRecTransition(elem1,elem3,"facialRec_Defalco_transition_start");

	root.is_attached=1;

	return root;
}

argusBuildUI( localClientNum, userTag)
{
	switch(userTag)
	{
	case "soldier":
		return facialRecognitionUI(localClientNum,&"PAKISTAN_2_ARGUS_SOLDIER",userTag);
	case "militia_leader":
		return facialRecognitionUI(localClientNum,&"PAKISTAN_2_ARGUS_MILITIA_LEADER",userTag);
	case "menendez":
		return facialRecognitionUI_Menendez(localClientNum,&"PAKISTAN_2_ARGUS_MENENDEZ",userTag);
	case "defalco":
		return facialRecognitionUI_Defalco(localClientNum,&"PAKISTAN_2_ARGUS_DEFALCO",userTag);
	}
}

onArgusNotify( localClientNum, argusID, userTag, message )
{	
	if( !level.is_argus_enabled )
	{
		ArgusSetDistance( argusID, 0 );
		ArgusForceDrawBracket(argusID, 0);
	}
	
	switch( message )
	{
		case "buildui":
			return argusBuildUI(localClientNum,userTag);
		case "create":
			ArgusSetOffset( argusID, (0, 0, 64) );
			ArgusSetDistance( argusID, 4096 );
			ArgusSetBracket(argusID,"square_bound");
			ArgusForceDrawBracket(argusID, 1);
			break;
		case "in":
			switch( userTag )
			{
			case "soldier":
			case "militia_leader":
			case "menendez":
			case "defalco":
				if( !within_fov( level.localPlayers[localClientNum] GetEye(), level.localPlayers[localClientNum] GetPlayerAngles(), ArgusGetOrigin(argusID), Cos( 2.3 ) ) )
				{
					return false;
				}
				break;
			}
			break;
		case "active":
			switch( userTag )
			{
			case "soldier":
			case "militia_leader":
			case "menendez":
			case "defalco":
				if( !within_fov( level.localPlayers[localClientNum] GetEye(), level.localPlayers[localClientNum] GetPlayerAngles(), ArgusGetOrigin(argusID), Cos( 2.3 ) ) )
				{	
					if( level.is_bink_playing )
					{
						ArgusSetBracket(argusID,"square_bound");
						cancel_facial_recognition();
					}
						
					return false;
				}
					
				if( !level.is_bink_playing )
				{
					level thread run_facial_recognition( argusID, userTag );
				}
				break;
			}
			break;
		case "out":
			level notify( userTag );
			switch( userTag )
			{
			case "soldier":
			case "militia_leader":
			case "menendez":
			case "defalco":
				if( level.is_bink_playing )
				{
					cancel_facial_recognition();
				}
				break;
			}
			break;
	}
	
	return true;
}

argus_toggle_think()
{
	while( true )
	{
		level waittill( "enable_argus" );
		
		level.is_argus_enabled = true;

		level waittill( "disable_argus" );
		
		level.is_argus_enabled = false;
	}
}

run_facial_recognition( argusID, userTag )
{
	level endon( "stop_facial_recognition" );
	level.is_bink_playing = true;
	ArgusSetBracket(argusID,"round_timer");
	level.facial_recognition_bink = PlayBink( "faces_scroll", 1 );
	playloopat ( "evt_surv_scan_dude", (0,0,0) );
	wait 2.0;
	
	if( userTag == "menendez" )
	{
		level notify( "facialRec_Menendez_transition_start" );
		wait 3.0;
	}
	else if( userTag == "defalco" )
	{
		level notify( "facialRec_Defalco_transition_start" );
		wait 3.0;
	}
	
	soundstoploopemitter( "evt_surv_scan_dude", (0,0,0) );
	
	ArgusSetDistance( argusID, 0 );
	ArgusForceDrawBracket( argusID, 0 );
	level.is_bink_playing = false;
}

cancel_facial_recognition()
{
	level notify( "stop_facial_recognition" );
	soundstoploopemitter( "evt_surv_scan_dude", (0,0,0) );
	playsound( 0, "evt_surv_scan_deny", (0,0,0) );
	StopBink( level.facial_recognition_bink );
	level.is_bink_playing = false;
}

millibar_scanner_on( localClientNum, ent, ent2 )
{
	while( true )
	{
		level waittill( "millibar_on" );
		
		enable_filter_sonar_attachment( level.localPlayers[0], 0, 0 );
    	level.localPlayers[0] SetSonarAttachmentEnabled( true );
	}
}

millibar_scanner_off( localClientNum, ent, ent2 )
{
	while( true )
	{
		level waittill( "millibar_off" );
		
		disable_filter_sonar_attachment( level.localPlayers[0], 0, 0 );
    	level.localPlayers[0] SetSonarAttachmentEnabled( false );
	}
}

swimming_fog()
{
		start_dist = 0;
		half_dist = 75;
		half_height = 1000;
		base_height = 0;
		fog_r = 0.14;
		fog_g = 0.199;
		fog_b = 0.292;
		fog_scale = .1;
		sun_col_r = 0.14;
		sun_col_g = 0.199;
		sun_col_b = 0.292;
		sun_dir_x = 0;
		sun_dir_y = 0;
		sun_dir_z = 0;
		sun_start_ang = 0;
		sun_stop_ang = 180;
		max_fog_opacity = 1;

	
		SetWaterFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
			sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
			sun_stop_ang, max_fog_opacity);
}

underground_fog_bank()
{
	level waittill("underground_mixer_light");
	SetWorldFogActiveBank(0, 2);
	
	level waittill("underground_fog_off");
	SetWorldFogActiveBank(0, 1);

}