// This function should take care of grain and glow settings for each map, plus anything else that artists 
// need to be able to tweak without bothering level designers.
#include maps\_utility;
#include common_scripts\utility;
#include common_scripts\_artCommon;

main()
{

	/#
	if ( GetDvar( "scr_art_tweak" ) == "" || GetDvar( "scr_art_tweak" ) == "0" )
		SetDvar( "scr_art_tweak", 0 );
	#/

	if ( GetDvar( "scr_cmd_plr_sun" ) == "" )
		SetDevDvar( "scr_cmd_plr_sun", "0" );

	if ( GetDvar( "scr_dof_enable" ) == "" )
		SetSavedDvar( "scr_dof_enable", "1" );

	if ( GetDvar( "scr_cinematic_autofocus" ) == "" )
		SetDvar( "scr_cinematic_autofocus", "1" );

	setdvarifuninitialized( "scr_glowTweakEnable", 1 );
	setdvarifuninitialized( "scr_glowTweakRadius0", 7);
	setdvarifuninitialized( "scr_glowTweakBloomCutoff", 0.99 );
	setdvarifuninitialized( "scr_glowTweakBloomDesaturation", 0.65 );
	setdvarifuninitialized( "scr_glowTweakBloomIntensity0", 0.36 );
	setdvarifuninitialized( "scr_filmTweakEnable", 1 );
	setdvarifuninitialized( "scr_filmTweakContrast", 1.45 );
	setdvarifuninitialized( "scr_filmTweakBrightness", 0.15 );
	setdvarifuninitialized( "scr_filmTweakDesaturation", 0.4);
	setdvarifuninitialized( "scr_filmTweakDesaturationDark", 0.4);
	setdvarifuninitialized( "scr_filmTweakInvert", 0 );
	setdvarifuninitialized( "scr_filmTweakLightTint", "1.14 1.07 0.877" );
	setdvarifuninitialized( "scr_filmTweakMediumTint", "1.16 .74 .69");
	setdvarifuninitialized( "scr_filmTweakDarkTint", "0.7 0.76 0.86" );
	setdvarifuninitialized( "scr_primaryLightUseTweaks", 1);
	setdvarifuninitialized( "scr_primaryLightTweakDiffuseStrength",1 );
	setdvarifuninitialized( "scr_primaryLightTweakSpecularStrength", 1 );
		
	level._clearalltextafterhudelem = false;

	level.dofDefault[ "nearStart" ] = 1;
	level.dofDefault[ "nearEnd" ] = 1;
	level.dofDefault[ "farStart" ] = 500;
	level.dofDefault[ "farEnd" ] = 500;
	level.dofDefault[ "nearBlur" ] = 4.5;
	level.dofDefault[ "farBlur" ] = .05;

	PrecacheMenu( "dev_vision_noloc" );
	PrecacheMenu( "dev_vision_exec" );

	useDof = GetDvarInt( "scr_dof_enable" );
	
	level.special_weapon_dof_funcs = [];
	level.buttons = [];
	
	if( !isdefined( level.vision_set_vision ) )
	{
		level.vision_set_vision = [];
	}
	
	if ( !isdefined( level.vision_set_transition_ent ) )
	{
		level.vision_set_transition_ent = SpawnStruct();
		level.vision_set_transition_ent.vision_set = "";
		level.vision_set_transition_ent.time = 0;
	}
		
	if( !isdefined( level.vision_set_fog ) )
	{
		level.vision_set_fog = [];
		create_default_vision_set_fog( level.script );
		common_scripts\_artCommon::setfogsliders();
	}
	
	foreach( key,value in level.vision_set_fog)
	{
		create_vision_set_vision( key );
	}	
		
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[ i ];

		player.curDoF = ( level.dofDefault[ "farStart" ] - level.dofDefault[ "nearEnd" ] ) / 2;

		if ( useDof )
			player thread adsDoF();
	}
	
	

	thread tweakart();

	if ( !isdefined( level.script ) )
		level.script = ToLower( GetDvar( "mapname" ) );
}

tweakart()
{
	/#
	if ( !isdefined( level.tweakfile ) )
		level.tweakfile = false;

	// not in DEVGUI
	SetDvar( "scr_fog_fraction", "1.0" );
	SetDvar( "scr_art_dump", "0" );

	// update the devgui variables to current settings
	SetDvar( "scr_dof_nearStart", level.dofDefault[ "nearStart" ] );
	SetDvar( "scr_dof_nearEnd", level.dofDefault[ "nearEnd" ] );
	SetDvar( "scr_dof_farStart", level.dofDefault[ "farStart" ] );
	SetDvar( "scr_dof_farEnd", level.dofDefault[ "farEnd" ] );
	SetDvar( "scr_dof_nearBlur", level.dofDefault[ "nearBlur" ] );
	SetDvar( "scr_dof_farBlur", level.dofDefault[ "farBlur" ] );

	// not in DEVGUI
	level.fogfraction = 1.0;

	file = undefined;

	// set dofvars from < levelname > _art.gsc
	dofvarupdate();

	printed = false;
	
	last_vision_set = "";

	for ( ;; )
	{
		while ( GetDvarInt( "scr_art_tweak" ) == 0 )
		{
			//	AssertEx( GetDvar( "scr_art_dump" ) == "0", "Must Enable Art Tweaks to export _art file." );
			wait .05;
			
//			if ( ! GetDvarInt( "scr_art_tweak" ) == 0 )
//				common_scripts\_artCommon::setfogsliders();// sets the sliders to whatever the current fog value is
		}

		// work around so art tweak doesn't break the vision set when it has been set on a player
		if ( isdefined(level.player) )
		{
			if ( isdefined(level.player.vision_set_transition_ent) )
				level.vision_set_transition_ent = level.player.vision_set_transition_ent;	// use the player's vision_set when it is set
			if ( isdefined(level.player.vision_set_transition_ent) )
				level.fog_transition_ent = level.player.fog_transition_ent;	// use the player's fog transition when it is set
		}

		if ( !printed )
		{
			printed = true;
			level.player openpopupmenu( "dev_vision_noloc" );
			wait .05;
			level.player  closepopupmenu( "dev_vision_noloc" );
			IPrintLnBold( "ART TWEAK ENABLED" );
			
			// create new vision sets for those triggers that aren't yet hooked up
			construct_vision_ents();
			hud_init();
			playerInit();
		}

		//translate the slider values to script variables
		common_scripts\_artCommon::translateFogSlidersToScript();

		dofvarupdate();

		// catch all those cases where a slider can be pushed to a place of conflict
		fovslidercheck();
		
		fogslidercheck();

		dump = dumpsettings();// dumps and returns true if the dump dvar is set

		//common_scripts\_artCommon::updateFogFromScript();
		updateFogEntFromScript();
		updateVisionSet();
		
		if ( getdvarint( "scr_select_art_next" ) || button_down( "dpad_up", "kp_uparrow" ) )
			setgroup_down();
		else if ( getdvarint( "scr_select_art_prev" ) || button_down( "dpad_down", "kp_downarrow" ) )
			setgroup_up();
		else if( level.vision_set_transition_ent.vision_set != last_vision_set )
		{
			last_vision_set = level.vision_set_transition_ent.vision_set;
			setcurrentgroup( last_vision_set );
		}

		level.player setDefaultDepthOfField();

		if ( dump )
		{
			PrintLn( "Art settings dumped success!" );
			addstring = "maps\\createart\\" + level.script + "_art::main();";
			AssertEx( level.tweakfile, "Remove all art setting in " + level.script + ".gsc ,add This before _load: \n" + addstring + "\nAND: add This to your "+level.script+".csv: \ninclude,"+level.script+"_art");
			SetDvar( "scr_art_dump", "0" );
 		}
		wait .05;
	}
	#/
}

button_down( btn, btn2 )
{
	pressed = level.player ButtonPressed( btn );

	if ( !pressed )
	{
		pressed = level.player ButtonPressed( btn2 );
	}

	if ( !IsDefined( level.buttons[ btn ] ) )
	{
		level.buttons[ btn ] = 0;
	}

	// To Prevent Spam
	if ( GetTime() < level.buttons[ btn ] )
	{
		return false;
	}

	level.buttons[ btn ] = GetTime() + 400;
	return pressed;
}

create_vision_set_vision( vision )
{
	if ( !isdefined( level.vision_set_vision ) )
		level.vision_set_vision = [];
	ent = SpawnStruct();
	ent.name = vision;

	level.vision_set_vision[ vision ] = ent;
	return ent;
}


updateFogEntFromScript()
{
	/#
	if ( GetDvarInt( "scr_cmd_plr_sun" ) )
	{
		SetDevDvar( "scr_sunFogDir", AnglesToForward( level.player GetPlayerAngles() ) );
		SetDevDvar( "scr_cmd_plr_sun", 0 );
	}

	#/
	
	if( !isdefined( level.vision_set_fog ) )
	{
	}
	
	ent = level.vision_set_fog[ level.vision_set_transition_ent.vision_set ];
	
	if( isdefined( ent.name ) )
	{
		
		ent.startDist = level.fognearplane;
		ent.halfwayDist = level.fogexphalfplane;
		ent.red = level.fogcolor[ 0 ];
		ent.green = level.fogcolor[ 1 ];
		ent.blue = level.fogcolor[ 2 ];
		ent.maxOpacity = level.fogmaxopacity;

		ent.sunFogEnabled = false;
		if ( level.sunFogEnabled )
		{
			ent.sunFogEnabled = true;
			ent.sunRed =  level.sunFogColor[ 0 ];
			ent.sunGreen =  level.sunFogColor[ 1 ];
			ent.sunBlue =  level.sunFogColor[ 2 ];
			ent.sunDir = level.sunFogDir;
			ent.sunBeginFadeAngle = level.sunFogBeginFadeAngle;
			ent.sunEndFadeAngle =  level.sunFogEndFadeAngle;
			ent.normalFogScale =  level.sunFogScale;
		}
		if ( GetDvarInt( "scr_fog_disable" ) )
		{
			ent.startDist = 100000000000;
			ent.halfwayDist = 100000000001;
			ent.red = 0;
			ent.green = 0;
			ent.blue = 0;
			ent.maxOpacity = 0;
		}
		
		set_fog_to_ent_values( ent,0 );

	}
			
	
//	if ( ! GetDvarInt( "scr_fog_disable" ) )
//	{
//		if ( level.sunFogEnabled )
//			SetExpFog( level.fognearplane, level.fogexphalfplane, level.fogcolor[ 0 ], level.fogcolor[ 1 ], level.fogcolor[ 2 ], level.fogmaxopacity, 0, level.sunFogColor[ 0 ], level.sunFogColor[ 1 ], level.sunFogColor[ 2 ], level.sunFogDir, level.sunFogBeginFadeAngle, level.sunFogEndFadeAngle, level.sunFogScale );
//		else
//			SetExpFog( level.fognearplane, level.fogexphalfplane, level.fogcolor[ 0 ], level.fogcolor[ 1 ], level.fogcolor[ 2 ], level.fogmaxopacity, 0 );
//	}
//	else
//	{
//		SetExpFog( 100000000000, 100000000001, 0, 0, 0, 0, 0 );// couldn't find discreet fog disabling other than to never set it in the first place
//	}
}


updateVisionSet()
{
	if( !isdefined( level.vision_set_vision ) )
		return;
		
	if( !isdefined(  level.vision_set_transition_ent ) )
		return;
		
	if ( ! isdefined( level.vision_set_transition_ent.vision_set ) )
		return;
		
	if ( !isdefined( level.vision_set_vision[ level.vision_set_transition_ent.vision_set ] ))
		return;
			
	ent = level.vision_set_vision[ level.vision_set_transition_ent.vision_set ];
	
	if( !isdefined( ent.selected ) )
		return;
	
	ent.r_glow = GetDvar( "r_glowTweakEnable" );
	ent.r_glowRadius0             = GetDvar( "r_glowTweakRadius0" );
	ent.r_glowBloomCutoff         = GetDvar( "r_glowTweakBloomCutoff" );
	ent.r_glowBloomDesaturation   = GetDvar( "r_glowTweakBloomDesaturation" );
	ent.r_glowBloomIntensity0     = GetDvar( "r_glowTweakBloomIntensity0" );
	ent.r_filmEnable              = GetDvar( "r_filmTweakEnable" );
	ent.r_filmContrast            = GetDvar( "r_filmTweakContrast" );
	ent.r_filmBrightness          = GetDvar( "r_filmTweakBrightness" );
	ent.r_filmDesaturation        = GetDvar( "r_filmTweakDesaturation" );
	ent.r_filmDesaturationDark    = GetDvar( "r_filmTweakDesaturationDark" );
	ent.r_filmInvert              = GetDvar( "r_filmTweakInvert" );
	ent.r_filmLightTint           = GetDvar( "r_filmTweakLightTint" );
	ent.r_filmMediumTint          = GetDvar( "r_filmTweakMediumTint" );
	ent.r_filmDarkTint            = GetDvar( "r_filmTweakDarkTint" );
	ent.r_primaryLightUseTweaks              = GetDvar( "r_primaryLightUseTweaks" );
	ent.r_primaryLightTweakDiffuseStrength   = GetDvar( "r_primaryLightTweakDiffuseStrength" );
	ent.r_primaryLightTweakSpecularStrength  = GetDvar( "r_primaryLightTweakSpecularStrength" );
	
}

fovslidercheck()
{
	// catch all those cases where a slider can be pushed to a place of conflict
	if ( level.dofDefault[ "nearStart" ] >= level.dofDefault[ "nearEnd" ] )
	{
		level.dofDefault[ "nearStart" ] = level.dofDefault[ "nearEnd" ] - 1;
		SetDvar( "scr_dof_nearStart", level.dofDefault[ "nearStart" ] );
	}
	if ( level.dofDefault[ "nearEnd" ] <= level.dofDefault[ "nearStart" ] )
	{
		level.dofDefault[ "nearEnd" ] = level.dofDefault[ "nearStart" ] + 1;
		SetDvar( "scr_dof_nearEnd", level.dofDefault[ "nearEnd" ] );
	}
	if ( level.dofDefault[ "farStart" ] >= level.dofDefault[ "farEnd" ] )
	{
		level.dofDefault[ "farStart" ] = level.dofDefault[ "farEnd" ] - 1;
		SetDvar( "scr_dof_farStart", level.dofDefault[ "farStart" ] );
	}
	if ( level.dofDefault[ "farEnd" ] <= level.dofDefault[ "farStart" ] )
	{
		level.dofDefault[ "farEnd" ] = level.dofDefault[ "farStart" ] + 1;
		SetDvar( "scr_dof_farEnd", level.dofDefault[ "farEnd" ] );
	}
	if ( level.dofDefault[ "farBlur" ] >= level.dofDefault[ "nearBlur" ] )
	{
		level.dofDefault[ "farBlur" ] = level.dofDefault[ "nearBlur" ] - .1;
		SetDvar( "scr_dof_farBlur", level.dofDefault[ "farBlur" ] );
	}
	if ( level.dofDefault[ "farStart" ] <= level.dofDefault[ "nearEnd" ] )
	{
		level.dofDefault[ "farStart" ] = level.dofDefault[ "nearEnd" ] + 1;
		SetDvar( "scr_dof_farStart", level.dofDefault[ "farStart" ] );
	}
}


fogslidercheck()
{
	// catch all those cases where a slider can be pushed to a place of conflict
	if ( level.sunFogBeginFadeAngle >= level.sunFogEndFadeAngle )
	{
		level.sunFogBeginFadeAngle  = level.sunFogEndFadeAngle  - 1;
		SetDvar( "scr_sunFogBeginFadeAngle", level.sunFogBeginFadeAngle );
	}
	if ( level.sunFogEndFadeAngle <= level.sunFogBeginFadeAngle )
	{
		level.sunFogEndFadeAngle = level.sunFogBeginFadeAngle + 1;
		SetDvar( "scr_sunFogEndFadeAngle", level.sunFogEndFadeAngle );
	}

}


construct_vision_ents()
{
	if( !isdefined( level.vision_set_fog ))
	 	level.vision_set_fog = [];
	trigger_multiple_visionsets = GetEntArray( "trigger_multiple_visionset" , "classname" );
	
	foreach( trigger in trigger_multiple_visionsets )
	{
		if( IsDefined( trigger.script_visionset ) )
		{
			construct_vision_set( trigger.script_visionset );
		}

		if ( IsDefined( trigger.script_visionset_start ) )
		{
			construct_vision_set( trigger.script_visionset_start );
		}

		if ( IsDefined( trigger.script_visionset_end ) )
		{
			construct_vision_set( trigger.script_visionset_end );
		}
	}
}

construct_vision_set( vision_set )
{
	if ( IsDefined( level.vision_set_fog[ vision_set ] ) )
	{
		return;
	}

	create_default_vision_set_fog( vision_set );
	create_vision_set_vision( vision_set );

	IPrintLnBold( "new vision: " + vision_set );
}


create_default_vision_set_fog( name)
{
	ent = create_vision_set_fog(name);
	ent.startDist = 3764.17;
	ent.halfwayDist = 19391;
	ent.red = 0.661137;
	ent.green = 0.554261;
	ent.blue = 0.454014;
	ent.maxOpacity = 0.7;
	ent.transitionTime = 0;
	
}


dumpsettings()
{
	/#
	if ( GetDvar( "scr_art_dump" ) == "0" )
		return false;
		


	////////////////// 

	file = 1;

	fileprint_launcher_start_file();

	fileprint_launcher( "// _createart generated.  modify at your own risk. Changing values should be fine." );
	fileprint_launcher( "main()" );
	fileprint_launcher( "{" );

	fileprint_launcher( "" );
	fileprint_launcher( "\tlevel.tweakfile = true;" );
	fileprint_launcher( "\tlevel.player = GetEntArray( \"player\", \"classname\" )[0]; " );
	//artfxprintlnFog();
	fileprint_launcher( "\tmaps\\createart\\" + get_template_level() + "_fog::main();" );

	fileprint_launcher( "" );
	fileprint_launcher( "}" );

	if ( ! artEndFogFileExport() )
		return false;
	////////////////////////////// 

	file = 1;

	// hook up the CSV FILE	
	fileprint_launcher_start_file();
    fileprint_launcher( "// _createart generated.  modify at your own risk. " );
    fileprint_launcher( "rawfile,maps/createart/"+ get_template_level() + "_art.gsc"  );
    fileprint_launcher( "rawfile,maps/createart/"+ get_template_level() + "_fog.gsc"  );
    fileprint_launcher( "rawfile,vision/"+ get_template_level() + ".vision" ) ;
    print_fog_ents_csv();
	fileprint_launcher_end_file( "\\share\\zone_source\\"+ get_template_level() + "_art.csv", true );
	
	fileprint_launcher_start_file();
    fileprint_launcher( "// _createart generated.  modify at your own risk. " );
    
    fileprint_launcher( "main()" );
    fileprint_launcher( "{" );
    print_fog_ents();
    
    //default vision name is the one on top for now..
    default_vision_name = "";
    foreach( key,value in level.vision_set_fog )
    {
    	default_vision_name = key;
    	break;
	}
    fileprint_launcher( "\tmaps\\_utility::vision_set_fog_changes( \""+default_vision_name+"\", 0 );");
    
    fileprint_launcher( "}" );
	fileprint_launcher_end_file( "\\share\\raw\\maps\\createart\\" + get_template_level() + "_fog.gsc", true );

	// only print the currently selected vision file
	print_current_vision();

	PrintLn( "CREATE ART DUMP SUCCESS!" );

	return true;
	#/
}

print_current_vision()
{

	ent = level.vision_set_vision[ level.vision_set_transition_ent.vision_set ];
	if( !isdefined( ent.name ) )
		return;
	fileprint_launcher_start_file();
	fileprint_launcher( "r_glow                    \"" + GetDvar( "r_glowTweakEnable" ) + "\"" );
	fileprint_launcher( "r_glowRadius0             \"" + GetDvar( "r_glowTweakRadius0" ) + "\"" );
	fileprint_launcher( "r_glowBloomCutoff         \"" + GetDvar( "r_glowTweakBloomCutoff" ) + "\"" );
	fileprint_launcher( "r_glowBloomDesaturation   \"" + GetDvar( "r_glowTweakBloomDesaturation" ) + "\"" );
	fileprint_launcher( "r_glowBloomIntensity0     \"" + GetDvar( "r_glowTweakBloomIntensity0" ) + "\"" );
	fileprint_launcher( " " );
	fileprint_launcher( "r_filmEnable              \"" + GetDvar( "r_filmTweakEnable" ) + "\"" );
	fileprint_launcher( "r_filmContrast            \"" + GetDvar( "r_filmTweakContrast" ) + "\"" );
	fileprint_launcher( "r_filmBrightness          \"" + GetDvar( "r_filmTweakBrightness" ) + "\"" );
	fileprint_launcher( "r_filmDesaturation        \"" + GetDvar( "r_filmTweakDesaturation" ) + "\"" );
	fileprint_launcher( "r_filmDesaturationDark    \"" + GetDvar( "r_filmTweakDesaturationDark" ) + "\"" );
	fileprint_launcher( "r_filmInvert              \"" + GetDvar( "r_filmTweakInvert" ) + "\"" );
	fileprint_launcher( "r_filmLightTint           \"" + GetDvar( "r_filmTweakLightTint" ) + "\"" );
	fileprint_launcher( "r_filmMediumTint          \"" + GetDvar( "r_filmTweakMediumTint" ) + "\"" );
	fileprint_launcher( "r_filmDarkTint            \"" + GetDvar( "r_filmTweakDarkTint" ) + "\"" );
	fileprint_launcher( " " );
	fileprint_launcher( "r_primaryLightUseTweaks              \"" + GetDvar( "r_primaryLightUseTweaks" ) + "\"" );
	fileprint_launcher( "r_primaryLightTweakDiffuseStrength   \"" + GetDvar( "r_primaryLightTweakDiffuseStrength" ) + "\"" );
	fileprint_launcher( "r_primaryLightTweakSpecularStrength  \"" + GetDvar( "r_primaryLightTweakSpecularStrength" ) + "\"" );
    fileprint_launcher_end_file( "\\share\\raw\\vision\\"+ent.name+ ".vision", true );
}

print_fog_ents()
{
	foreach( ent in level.vision_set_fog )
	{
		if( !isdefined( ent.name ) )
			continue;
		fileprint_launcher( "\tent = maps\\_utility::create_vision_set_fog( \""+ent.name+"\" );");

		if( isdefined( ent.startDist ) )
			fileprint_launcher( "\tent.startDist = "+ent.startDist + ";" );
		if( isdefined( ent.halfwayDist ) )
			fileprint_launcher( "\tent.halfwayDist = "+ent.halfwayDist + ";" );
		if( isdefined( ent.red ) )
			fileprint_launcher( "\tent.red = "+ent.red + ";" );
		if( isdefined( ent.green ) )
			fileprint_launcher( "\tent.green = "+ent.green + ";" );
		if( isdefined( ent.blue ) )
			fileprint_launcher( "\tent.blue = "+ent.blue + ";" );
		if( isdefined( ent.maxOpacity ) )
			fileprint_launcher( "\tent.maxOpacity = "+ent.maxOpacity + ";" );
		if( isdefined( ent.transitionTime ) )
			fileprint_launcher( "\tent.transitionTime = "+ent.transitionTime + ";" );
		if( isdefined( ent.sunFogEnabled ) )
			fileprint_launcher( "\tent.sunFogEnabled = "+ent.sunFogEnabled + ";" );
		if( isdefined( ent.sunRed ) )
			fileprint_launcher( "\tent.sunRed = "+ent.sunRed + ";" );
		if( isdefined( ent.sunGreen ) )
			fileprint_launcher( "\tent.sunGreen = "+ent.sunGreen + ";" );
		if( isdefined( ent.sunBlue ) )
			fileprint_launcher( "\tent.sunBlue = "+ent.sunBlue + ";" );
		if( isdefined( ent.sunDir ) )
			fileprint_launcher( "\tent.sunDir = "+ent.sunDir + ";" );
		if( isdefined( ent.sunBeginFadeAngle ) )
			fileprint_launcher( "\tent.sunBeginFadeAngle = "+ent.sunBeginFadeAngle + ";" );
		if( isdefined( ent.sunEndFadeAngle ) )
			fileprint_launcher( "\tent.sunEndFadeAngle = "+ent.sunEndFadeAngle + ";" );
		if( isdefined( ent.normalFogScale ) )
			fileprint_launcher( "\tent.normalFogScale = "+ent.normalFogScale + ";" );
			
		fileprint_launcher ( " " );
	}
		
}
print_fog_ents_csv()
{
	foreach( ent in level.vision_set_fog )
	{
		if( !isdefined( ent.name ) )
			continue;
		fileprint_launcher( "rawfile,vision/"+ent.name+".vision");
	}
		
}


cloudlight( sunlight_bright, sunlight_dark, diffuse_high, diffuse_low )
{
	level.sunlight_bright = sunlight_bright;
	level.sunlight_dark = sunlight_dark;
	level.diffuse_high = diffuse_high;
	level.diffuse_low = diffuse_low;

	SetDvar( "r_lighttweaksunlight", level.sunlight_dark );
	SetDvar( "r_lighttweakdiffusefraction", level.diffuse_low );
	direction = "up";

	for ( ;; )
	{
		sunlight = GetDvarFloat( "r_lighttweaksunlight" );
		jitter = scale( 1 + RandomInt( 21 ) );

		flip = RandomInt( 2 );
		if ( flip )
			jitter = jitter * -1;

		if ( direction == "up" )
			next_target = sunlight + scale( 30 ) + jitter;
		else
			next_target = sunlight - scale( 30 ) + jitter;

		// IPrintLn( "jitter = ", jitter );
		if ( next_target >= level.sunlight_bright )
		{
			next_target = level.sunlight_bright;
			direction = "down";
		}

		if ( next_target <= level.sunlight_dark )
		{
			next_target = level.sunlight_dark;
			direction = "up";
		}

		if ( next_target > sunlight )
			brighten( next_target, ( 3 + RandomInt( 3 ) ), .05 );
		else
			darken( next_target, ( 3 + RandomInt( 3 ) ), .05 );
	}
}

brighten( target_sunlight, time, freq )
{
	// IPrintLn( "Brightening sunlight to ", target_sunlight );
	sunlight = GetDvarFloat( "r_lighttweaksunlight" );
	// diffuse = GetDvarFloat( "r_lighttweakdiffusefraction" );
	// IPrintLn( "sunlight = ", sunlight );
	// IPrintLn( "diffuse = ", diffuse );

	totalchange = target_sunlight - sunlight;
	changeamount = totalchange / ( time / freq );
	// IPrintLn( "totalchange = ", totalchange );
	// IPrintLn( "changeamount = ", changeamount );

	while ( time > 0 )
	{
		time = time - freq;

		sunlight = sunlight + changeamount;
		SetDvar( "r_lighttweaksunlight", sunlight );
		// IPrintLn( "^6sunlight = ", sunlight );

		frac = ( sunlight - level.sunlight_dark ) / ( level.sunlight_bright - level.sunlight_dark );
		diffuse = level.diffuse_high + ( level.diffuse_low - level.diffuse_high ) * frac;
		SetDvar( "r_lighttweakdiffusefraction", diffuse );
		// IPrintLn( "^6diffuse = ", diffuse );

		wait freq;
	}
}

darken( target_sunlight, time, freq )
{
	// IPrintLn( "Darkening sunlight to ", target_sunlight );
	sunlight = GetDvarFloat( "r_lighttweaksunlight" );
	// diffuse = GetDvarFloat( "r_lighttweakdiffusefraction" );
	// IPrintLn( "sunlight = ", sunlight );
	// IPrintLn( "diffuse = ", diffuse );

	totalchange = sunlight - target_sunlight;
	changeamount = totalchange / ( time / freq );
	// IPrintLn( "totalchange = ", totalchange );
	// IPrintLn( "changeamount = ", changeamount );

	while ( time > 0 )
	{
		time = time - freq;

		sunlight = sunlight - changeamount;
		SetDvar( "r_lighttweaksunlight", sunlight );
		// IPrintLn( "^6sunlight = ", sunlight );

		frac = ( sunlight - level.sunlight_dark ) / ( level.sunlight_bright - level.sunlight_dark );
		diffuse = level.diffuse_high + ( level.diffuse_low - level.diffuse_high ) * frac;
		SetDvar( "r_lighttweakdiffusefraction", diffuse );
		// IPrintLn( "^6diffuse = ", diffuse );

		wait freq;
	}
}

scale( percent )
{
		frac = percent / 100;
		return( level.sunlight_dark + frac * ( level.sunlight_bright - level.sunlight_dark ) ) - level.sunlight_dark;
}


adsDoF()
{
	Assert( IsPlayer( self ) );

	self.dof = level.dofDefault;
	art_tweak = false;

	for ( ;; )
	{
		wait( 0.05 );

		if ( level.level_specific_dof )
		{
			continue;
		}
		if ( GetDvarInt( "scr_cinematic" ) )
		{
			updateCinematicDoF();
			continue;
		}

		/# art_tweak = GetDvarInt( "scr_art_tweak" ); #/

		if ( GetDvarInt( "scr_dof_enable" ) && !art_tweak )
		{
			updateDoF();
			continue;
		}

		self setDefaultDepthOfField();
	}
}


updateCinematicDoF()
{
	Assert( IsPlayer( self ) );

	adsFrac = self PlayerAds();

	if ( adsFrac == 1 && GetDvarInt( "scr_cinematic_autofocus" ) )
	{
		traceDir = VectorNormalize( AnglesToForward( self GetPlayerAngles() ) );
		trace = BulletTrace( self GetEye(), self GetEye() + ( traceDir * 100000 ), true, self );

		enemies = GetAIArray();
		nearEnd = 10000;
		farStart = -1;
		start_origin = self GetEye();
		start_angles = self GetPlayerAngles();
		bestDot = 0;
		bestFocalPoint = undefined;
		for ( index = 0; index < enemies.size; index++ )
		{
			end_origin = enemies[ index ].origin;
			normal = VectorNormalize( end_origin - start_origin );
			forward = AnglesToForward( start_angles );
			dot = VectorDot( forward, normal );

			if ( dot > bestDot )
			{
				bestDot = dot;
				bestFocalPoint = enemies[ index ].origin;
			}
		}

		if ( bestDot < 0.923 )
		{
			scrDoF = Distance( start_origin, trace[ "position" ] );
// 			scrDoF = GetDvarInt( "scr_cinematic_doffocus" ) * 39;
		}
		else
		{
			scrDoF = Distance( start_origin, bestFocalPoint );
		}

		changeDoFValue( "nearStart", 1, 200 );
		changeDoFValue( "nearEnd", scrDoF, 200 );
		changeDoFValue( "farStart", scrDoF + 196, 200 );
		changeDoFValue( "farEnd", ( scrDoF + 196 ) * 2, 200 );
		changeDoFValue( "nearBlur", 6, 0.1 );
		changeDoFValue( "farBlur", 3.6, 0.1 );
	}
	else
	{
		scrDoF = GetDvarInt( "scr_cinematic_doffocus" ) * 39;

		if ( self.curDoF != scrDoF )
		{
			changeDoFValue( "nearStart", 1, 100 );
			changeDoFValue( "nearEnd", scrDoF, 100 );
			changeDoFValue( "farStart", scrDoF + 196, 100 );
			changeDoFValue( "farEnd", ( scrDoF + 196 ) * 2, 100 );
			changeDoFValue( "nearBlur", 6, 0.1 );
			changeDoFValue( "farBlur", 3.6, 0.1 );
		}
	}

	self.curDoF = ( self.dof[ "farStart" ] - self.dof[ "nearEnd" ] ) / 2;

	self SetDepthOfField(
							self.dof[ "nearStart" ],
							self.dof[ "nearEnd" ],
							self.dof[ "farStart" ],
							self.dof[ "farEnd" ],
							self.dof[ "nearBlur" ],
							self.dof[ "farBlur" ]
							 );
}


updateDoF()
{
	Assert( IsPlayer( self ) );
	adsFrac = self PlayerAds();

	if ( adsFrac == 0.0 )
	{
		self setDefaultDepthOfField();
		return;
	}

	playerEye = self GetEye();
	playerAngles = self GetPlayerAngles();
	playerForward = VectorNormalize( AnglesToForward( playerAngles ) );

	trace = BulletTrace( playerEye, playerEye + ( playerForward* 8192 ), true, self, true );
	enemies = GetAIArray( "axis" );

	weapon = self getcurrentweapon();
	if ( isdefined( level.special_weapon_dof_funcs[ weapon ] ) )
	{
		[[ level.special_weapon_dof_funcs[ weapon ] ]]( trace, enemies, playerEye, playerForward, adsFrac );
		return;
	}

	nearEnd = 10000;
	farStart = -1;

	for ( index = 0; index < enemies.size; index++ )
	{
		enemyDir = VectorNormalize( enemies[ index ].origin - playerEye );

		dot = VectorDot( playerForward, enemyDir );
		if ( dot < 0.923 )// 45 degrees
			continue;

		distFrom = Distance( playerEye, enemies[ index ].origin );

		if ( distFrom - 30 < nearEnd )
			nearEnd = distFrom - 30;

		if ( distFrom + 30 > farStart )
			farStart = distFrom + 30;
	}
	
	if ( nearEnd > farStart )
	{
		nearEnd = 256;
		farStart = 2500;
	}
	else
	{
		if ( nearEnd < 50 )
			nearEnd = 50;
		else 
		if ( nearEnd > 512 )
			nearEnd = 512;

		if ( farStart > 2500 )
			farStart = 2500;
		else 
		if ( farStart < 1000 )
			farStart = 1000;
	}

	traceDist = Distance( playerEye, trace[ "position" ] );

	if ( nearEnd > traceDist )
		nearEnd = traceDist - 30;

	if ( nearEnd < 1 )
		nearEnd = 1;

	if ( farStart < traceDist )
		farSTart = traceDist;
		
	self setDoFTarget( adsFrac, 1, nearEnd, farStart, farStart * 4, 6, 1.8 );
}

javelin_dof( trace, enemies, playerEye, playerForward, adsFrac )
{
	if ( adsFrac < 0.88 )
	{
		self setDefaultDepthOfField();
		return;
	}

	nearEnd = 10000;
	farStart = -1;
	nearEnd = 2400;
	nearStart = 2400;

	for ( index = 0; index < enemies.size; index++ )
	{
		enemyDir = VectorNormalize( enemies[ index ].origin - playerEye );

		dot = VectorDot( playerForward, enemyDir );
		if ( dot < 0.923 )// 45 degrees
			continue;

		distFrom = Distance( playerEye, enemies[ index ].origin );
		if ( distFrom < 2500 )
			distFrom = 2500;

		if ( distFrom - 30 < nearEnd )
			nearEnd = distFrom - 30;

		if ( distFrom + 30 > farStart )
			farStart = distFrom + 30;
	}
	
	
	if ( nearEnd > farStart )
	{
		nearEnd = 2400;
		farStart = 3000;
	}
	else
	{
		if ( nearEnd < 50 )
			nearEnd = 50;

		if ( farStart > 2500 )
			farStart = 2500;
		else 
		if ( farStart < 1000 )
			farStart = 1000;
	}

	traceDist = Distance( playerEye, trace[ "position" ] );
	if ( traceDist < 2500 )
		traceDist = 2500;

	if ( nearEnd > traceDist )
		nearEnd = traceDist - 30;

	if ( nearEnd < 1 )
		nearEnd = 1;

	if ( farStart < traceDist )
		farSTart = traceDist;
		
	if ( nearStart >= nearEnd )
		nearStart = nearEnd - 1;

	self setDoFTarget( adsFrac, nearStart, nearEnd, farStart, farStart * 4, 4, 1.8 );
}

setDoFTarget( adsFrac, nearStart, nearEnd, farStart, farEnd, nearBlur, farBlur )
{
	Assert( IsPlayer( self ) );

	
	if ( adsFrac == 1 )
	{
		changeDoFValue( "nearStart", nearStart, 50 );
		changeDoFValue( "nearEnd", nearEnd, 50 );
		changeDoFValue( "farStart", farStart, 400 );
		changeDoFValue( "farEnd", farEnd, 400 );
		changeDoFValue( "nearBlur", nearBlur, 0.1 );
		changeDoFValue( "farBlur", farBlur, 0.1 );
	}
	else
	{
		lerpDoFValue( "nearStart", nearStart, adsFrac );
		lerpDoFValue( "nearEnd", nearEnd, adsFrac );
		lerpDoFValue( "farStart", farStart, adsFrac );
		lerpDoFValue( "farEnd", farEnd, adsFrac );
		lerpDoFValue( "nearBlur", nearBlur, adsFrac );
		lerpDoFValue( "farBlur", farBlur, adsFrac );
	}

	self SetDepthOfField(
							self.dof[ "nearStart" ],
							self.dof[ "nearEnd" ],
							self.dof[ "farStart" ],
							self.dof[ "farEnd" ],
							self.dof[ "nearBlur" ],
							self.dof[ "farBlur" ]
							 );
}

changeDoFValue( valueName, targetValue, maxChange )
{
	Assert( IsPlayer( self ) );

	if ( self.dof[ valueName ] > targetValue )
	{
		changeVal = ( self.dof[ valueName ] - targetValue ) * 0.5;
		if ( changeVal > maxChange )
			changeVal = maxChange;
		else if ( changeVal < 1 )
			changeVal = 1;

		if ( self.dof[ valueName ] - changeVal < targetValue )
			self.dof[ valueName ] = targetValue;
		else
			self.dof[ valueName ] -= changeVal;
	}
	else if ( self.dof[ valueName ] < targetValue )
	{
		changeVal = ( targetValue - self.dof[ valueName ] ) * 0.5;
		if ( changeVal > maxChange )
			changeVal = maxChange;
		else if ( changeVal < 1 )
			changeVal = 1;

		if ( self.dof[ valueName ] + changeVal > targetValue )
			self.dof[ valueName ] = targetValue;
		else
			self.dof[ valueName ] += changeVal;
	}
}

lerpDoFValue( valueName, targetValue, lerpAmount )
{
	Assert( IsPlayer( self ) );

	self.dof[ valueName ] = level.dofDefault[ valueName ] + ( ( targetValue - level.dofDefault[ valueName ] ) * lerpAmount ) ;
}

dofvarupdate()
{
		level.dofDefault[ "nearStart" ] = GetDvarInt( "scr_dof_nearStart" );
		level.dofDefault[ "nearEnd" ] = GetDvarInt( "scr_dof_nearEnd" );
		level.dofDefault[ "farStart" ] = GetDvarInt( "scr_dof_farStart" );
		level.dofDefault[ "farEnd" ] = GetDvarInt( "scr_dof_farEnd" );
		level.dofDefault[ "nearBlur" ] = GetDvarFloat( "scr_dof_nearBlur" );
		level.dofDefault[ "farBlur" ] = GetDvarFloat( "scr_dof_farBlur" );
}

setdefaultdepthoffield()
{
	Assert( IsPlayer( self ) );

	if ( isdefined( self.dofDefault ) )
	{
		self SetDepthOfField(
								self.dofDefault[ "nearStart" ],
								self.dofDefault[ "nearEnd" ],
								self.dofDefault[ "farStart" ],
								self.dofDefault[ "farEnd" ],
								self.dofDefault[ "nearBlur" ],
								self.dofDefault[ "farBlur" ]
								 );
	}
	else
	{
		self SetDepthOfField(
								level.dofDefault[ "nearStart" ],
								level.dofDefault[ "nearEnd" ],
								level.dofDefault[ "farStart" ],
								level.dofDefault[ "farEnd" ],
								level.dofDefault[ "nearBlur" ],
								level.dofDefault[ "farBlur" ]
								 );
	}
}


isDoFDefault()
{
	if ( level.dofDefault[ "nearStart" ] != GetDvarInt( "scr_dof_nearStart" ) )
		return false;

	if ( level.dofDefault[ "nearEnd" ] != GetDvarInt( "scr_dof_nearEnd" ) )
		return false;

	if ( level.dofDefault[ "farStart" ] != GetDvarInt( "scr_dof_farStart" ) )
		return false;

	if ( level.dofDefault[ "farEnd" ] != GetDvarInt( "scr_dof_farEnd" ) )
		return false;

	if ( level.dofDefault[ "nearBlur" ] != GetDvarInt( "scr_dof_nearBlur" ) )
		return false;

	if ( level.dofDefault[ "farBlur" ] != GetDvarInt( "scr_dof_farBlur" ) )
		return false;

	return true;
}




hud_init()
{
	listsize = 7;

	hudelems = [];
	spacer = 15;
	div = int( listsize / 2 );
	org = 240 + div * spacer;
	alphainc = .5 / div;
	alpha = alphainc;

	for ( i = 0;i < listsize;i++ )
	{
		hudelems[ i ] = _newhudelem();
		hudelems[ i ].location = 0;
		hudelems[ i ].alignX = "left";
		hudelems[ i ].alignY = "middle";
		hudelems[ i ].foreground = 1;
		hudelems[ i ].fontScale = 2;
		hudelems[ i ].sort = 20;
		if ( i == div )
			hudelems[ i ].alpha = 1;
		else
			hudelems[ i ].alpha = alpha;

		hudelems[ i ].x = 20;
		hudelems[ i ].y = org;
		hudelems[ i ] _settext( "." );

		if ( i == div )
			alphainc *= -1;

		alpha += alphainc;

		org -= spacer;
	}

	level.spam_group_hudelems = hudelems;

	crossHair = _newhudelem();
	crossHair.location = 0;
	crossHair.alignX = "center";
	crossHair.alignY = "bottom";
	crossHair.foreground = 1;
	crossHair.fontScale = 2;
	crossHair.sort = 20;
	crossHair.alpha = 1;
	crossHair.x = 320;
	crossHair.y = 244;
	crossHair _settext( "." );
	level.crosshair = crossHair;

			 // setup "crosshair"
	crossHair = _newhudelem();
	crossHair.location = 0;
	crossHair.alignX = "center";
	crossHair.alignY = "bottom";
	crossHair.foreground = 1;
	crossHair.fontScale = 2;
	crossHair.sort = 20;
	crossHair.alpha = 0;
	crossHair.x = 320;
	crossHair.y = 244;
	crossHair setvalue( 0 );
	level.crosshair_value = crossHair;

//	controler_hud_add( "helppm", 1, "^5Placed Models: ", undefined, level.spamed_models.size );
//	controler_hud_add( "helpdensity", 2, "^5Spacing: ", undefined, level.spam_density_scale );
//	controler_hud_add( "helpradius", 3, "^5Radius: ", undefined, level.spam_model_radius );
//	controler_hud_add( "helpxy", 6, "^4X / ^3Y: ", undefined, level.spam_model_radius );
//	controler_hud_add( "helpab", 7, "^2A / ^1B^7: ", " - " );
//	controler_hud_add( "helplsrs", 8, "^8L^7 / R Stick: ", " - " );
//	controler_hud_add( "helplbrb", 9, "^8L^7 / R Shoulder: ", " - " );
//	controler_hud_add( "helpdpu", 10, "^8DPad U / ^7D: ", " - " );
//	controler_hud_add( "helpdpl", 11, "^8DPad L / ^7R: ", " - " );
//	controler_hud_add( "helpF", 17, "^8F: ^7( dump ) ^3map_source/" + level.script + "_modeldump.map", "" );

	//hint_buttons_main();

	//flag_set( "user_hud_active" );
}



controler_hud_add( identifier, inc, initial_text, initial_description_text, initial_value )
{
	startx = 520;
	starty = 120;
	space = 18;
	basealpha = .8;
	denradoffset = 20;
	descriptionscale = 1.4;
	if ( !isdefined( initial_text ) )
		initial_text = "";

	if ( !isdefined( level.hud_controler ) || !isdefined( level.hud_controler[ identifier ] ) )
	{
		level.hud_controler[ identifier ] = _newhudelem();
		description = _newhudelem();
	}
	else
		description = level.hud_controler[ identifier ].description;

	level.hud_controler[ identifier ].location = 0;
	level.hud_controler[ identifier ].alignX = "right";
	level.hud_controler[ identifier ].alignY = "middle";
	level.hud_controler[ identifier ].foreground = 1;
	level.hud_controler[ identifier ].fontscale = 1.5;
	level.hud_controler[ identifier ].sort = 20;
	level.hud_controler[ identifier ].alpha = basealpha;
	level.hud_controler[ identifier ].x = startx + denradoffset;
	level.hud_controler[ identifier ].y = starty + ( inc * space );
	level.hud_controler[ identifier ] _settext( initial_text );
	level.hud_controler[ identifier ].base_button_text = initial_text;

	description.location = 0;
	description.alignX = "left";
	description.alignY = "middle";
	description.foreground = 1;
	description.fontscale = descriptionscale;
	description.sort = 20;
	description.alpha = basealpha;
	description.x = startx + denradoffset;
	description.y = starty + ( inc * space );
	if ( isdefined( initial_value ) )
		description setvalue( initial_value );
	if ( isdefined( initial_description_text ) )
		description _settext( initial_description_text );
	level.hud_controler[ identifier ].description = description;
}


_newhudelem()
{
	if ( !isdefined( level.scripted_elems ) )
	 	level.scripted_elems = [];
	elem = newhudelem();
	level.scripted_elems[ level.scripted_elems.size ] = elem;
	return elem;
}

_settext( text )
{
	self.realtext = text;
	self settext( "_" );
	self thread _clearalltextafterhudelem();
	sizeofelems = 0;
	foreach ( elem in level.scripted_elems )
	{
		if ( isdefined( elem.realtext ) )
		{
			sizeofelems += elem.realtext.size;
			elem settext( elem.realtext );
		}
	}
	println( "Size of elems: " + sizeofelems );
}

_clearalltextafterhudelem()
{
	if ( level._clearalltextafterhudelem )
		return;
	level._clearalltextafterhudelem = true;
	self clearalltextafterhudelem();
	wait .05;
	level._clearalltextafterhudelem = false;

}


setgroup_up()
{
	reset_cmds();
	index = undefined;
	keys = getarraykeys( level.vision_set_vision );
	for ( i = 0;i < keys.size;i++ )
		if ( keys[ i ] == level.vision_set_transition_ent.vision_set )
		{
			index = i + 1;
			break;
		}
	if ( index == keys.size )
		return;

	setcurrentgroup( keys[index] );
}

setgroup_down()
{
	reset_cmds();
	index = undefined;
	keys = getarraykeys( level.vision_set_vision );
	for ( i = 0;i < keys.size;i++ )
		if ( keys[ i ] == level.vision_set_transition_ent.vision_set )
		{
			index = i - 1;
			break;
		}
	if ( index < 0 )
		return;

	setcurrentgroup( keys[index] );
}

reset_cmds()
{
	SetDevDvar( "scr_select_art_next", 0 );
	SetDevDvar( "scr_select_art_prev", 0 );
}

setcurrentgroup( group )
{
	level.spam_model_current_group = group;
	keys = getarraykeys( level.vision_set_vision );
	index = 0;
	div = int( level.spam_group_hudelems.size / 2 );
	for ( i = 0;i < keys.size;i++ )
		if ( keys[ i ] == group )
		{
			index = i;
			break;
		}

	level.spam_group_hudelems[ div ] _settext( keys[ index ] );

	for ( i = 1;i < level.spam_group_hudelems.size - div;i++ )
	{
			if ( index - i < 0 )
			{
				level.spam_group_hudelems[ div + i ] _settext( "." );
				continue;
			}
			level.spam_group_hudelems[ div + i ] _settext( keys[ index - i ] );
	}

	for ( i = 1;i < level.spam_group_hudelems.size - div;i++ )
	{
			if ( index + i > keys.size - 1 )
			{
				//  -- -- 
				level.spam_group_hudelems[ div - i ] _settext( "." );
				continue;
			}
			level.spam_group_hudelems[ div - i ] _settext( keys[ index + i ] );
	}
	
	vision_set_fog_changes( keys[ index ], 0 ) ;

}

init_fog_transition()
{
	if ( !IsDefined( level.fog_transition_ent ) )
	{
		level.fog_transition_ent = SpawnStruct();
		level.fog_transition_ent.fogset = "";
		level.fog_transition_ent.time = 0;
	}
}


playerInit()
{
 	last_vision_set = level.vision_set_transition_ent.vision_set;
 	
	//clear these so the vision set will happen.
 	level.vision_set_transition_ent.vision_set = "";
 	level.vision_set_transition_ent.time = "";

	init_fog_transition();
 	level.fog_transition_ent.fogset = "";
 	level.fog_transition_ent.time = ""; 

 	setcurrentgroup( last_vision_set );
}