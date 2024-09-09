// This function should take care of grain and glow settings for each map, plus anything else that artists 
// need to be able to tweak without bothering level designers.
#include common_scripts\utility;
#include common_scripts\_artCommon;

main()
{
	/#
	if ( !isdefined( level.script ) )
		level.script = ToLower( GetDvar( "mapname" ) );
	
	setDevDvarIfUninitialized( "scr_art_tweak", 0 );
	setDevDvarIfUninitialized( "scr_dof_enable", "1" );
	setDevDvarIfUninitialized( "scr_cmd_plr_sun", "0" );
	setDevDvarIfUninitialized( "scr_cinematic_autofocus", "1" );
	setDevDvarIfUninitialized( "scr_art_visionfile", level.script );

	if ( !isDefined( level.dofDefault ) )
	{
		level.dofDefault[ "nearStart" ] = 0;
		level.dofDefault[ "nearEnd" ] = 1;
		level.dofDefault[ "farStart" ] = 8000;
		level.dofDefault[ "farEnd" ] = 10000;
		level.dofDefault[ "nearBlur" ] = 6;
		level.dofDefault[ "farBlur" ] = 0;
	}

	level.curDoF = ( level.dofDefault[ "farStart" ] - level.dofDefault[ "nearEnd" ] ) / 2;
	level._clearalltextafterhudelem = false;
	level.buttons = [];

	if( !isdefined( level.vision_set_vision ) )
	{
		level.vision_set_vision = [];
	}
	
	if ( !isdefined( level.vision_set_transition_ent ) )
	{
		level.vision_set_transition_ent = SpawnStruct();
		level.vision_set_transition_ent.vision_set = level.script;
		level.vision_set_transition_ent.time = 0;
	}
	
	if( !isdefined( level.vision_set_fog ) )
	{
		level.vision_set_fog = [];
		if (isdefined(level._art_fog_setup))
			[[level._art_fog_setup]]();
		construct_vision_set( "" );	// so we always have an entry for the default case
		construct_vision_set( level.script );
		set_fog( level.script );
		common_scripts\_artCommon::setfogsliders();
	}
	
	thread tweakart();

	#/
}

tweakart()
{
	/#
	if ( !isdefined( level.tweakfile ) )
		level.tweakfile = false;

	// not in DEVGUI
	SetDevDvar( "scr_fog_fraction", "1.0" );
	SetDevDvar( "scr_art_dump", "0" );

	// update the devgui variables to current settings
	SetDevDvar( "scr_dof_nearStart", level.dofDefault[ "nearStart" ] );
	SetDevDvar( "scr_dof_nearEnd", level.dofDefault[ "nearEnd" ] );
	SetDevDvar( "scr_dof_farStart", level.dofDefault[ "farStart" ] );
	SetDevDvar( "scr_dof_farEnd", level.dofDefault[ "farEnd" ] );
	SetDevDvar( "scr_dof_nearBlur", level.dofDefault[ "nearBlur" ] );
	SetDevDvar( "scr_dof_farBlur", level.dofDefault[ "farBlur" ] );

	// not in DEVGUI
	level.fogfraction = 1.0;

	file = undefined;
	filename = undefined;
	last_vision_set = "";

	inited = false;
	
	for ( ;; )
	{
		while ( GetDvarInt( "scr_art_tweak", 0 ) == 0 )
		{
			AssertEx( GetDvarInt( "scr_art_dump", 0 ) == 0, "Must Enable Art Tweaks to export _art file." );
			wait .05;
			if ( ! GetDvarInt( "scr_art_tweak", 0 ) == 0 )
				common_scripts\_artCommon::setfogsliders();// sets the sliders to whatever the current fog value is
		}

		if ( GetDvarInt( "scr_art_tweak_message" ) )
		{
			SetDevDvar( "scr_art_tweak_message", "0" );
			IPrintLnBold( "ART TWEAK ENABLED" );
		}
		if ( !inited )
		{
			inited = true;
			// create new vision sets for those triggers that aren't yet hooked up
			construct_vision_ents();
			hud_init();
			playerInit();
			level.players[0] VisionSetNakedForPlayer( level.script, 0 );	// to disable clientside visionsets, so the script based fog is active
		}

		//translate the slider values to script variables
		common_scripts\_artCommon::translateFogSlidersToScript();

//		dofvarupdate();

		// catch all those cases where a slider can be pushed to a place of conflict
		fovslidercheck();
		
		fogslidercheck();	// copied from sp _art.gsc


		dump = dumpsettings();// dumps and returns true if the dump dvar is set

		updateFogEntFromScript();


		if ( getdvarint( "scr_select_art_next" ) || button_down( "dpad_up", "kp_uparrow" ) )
			setgroup_down();
		else if ( getdvarint( "scr_select_art_prev" ) || button_down( "dpad_down", "kp_downarrow" ) )
			setgroup_up();
		else if( level.vision_set_transition_ent.vision_set != last_vision_set )
		{
			last_vision_set = level.vision_set_transition_ent.vision_set;
			setcurrentgroup( last_vision_set );
		}
		
//		level.player setDefaultDepthOfField();
		if ( dump )
		{
			IPrintLnBold( "Art settings dumped success!" );
			SetdevDvar( "scr_art_dump", "0" );
 		}
		wait .1;
	}
	#/
}

fovslidercheck()
{
	/#
	// catch all those cases where a slider can be pushed to a place of conflict
	if ( level.dofDefault[ "nearStart" ] >= level.dofDefault[ "nearEnd" ] )
	{
		level.dofDefault[ "nearStart" ] = level.dofDefault[ "nearEnd" ] - 1;
		SetDevDvar( "scr_dof_nearStart", level.dofDefault[ "nearStart" ] );
	}
	if ( level.dofDefault[ "nearEnd" ] <= level.dofDefault[ "nearStart" ] )
	{
		level.dofDefault[ "nearEnd" ] = level.dofDefault[ "nearStart" ] + 1;
		SetDevDvar( "scr_dof_nearEnd", level.dofDefault[ "nearEnd" ] );
	}
	if ( level.dofDefault[ "farStart" ] >= level.dofDefault[ "farEnd" ] )
	{
		level.dofDefault[ "farStart" ] = level.dofDefault[ "farEnd" ] - 1;
		SetDevDvar( "scr_dof_farStart", level.dofDefault[ "farStart" ] );
	}
	if ( level.dofDefault[ "farEnd" ] <= level.dofDefault[ "farStart" ] )
	{
		level.dofDefault[ "farEnd" ] = level.dofDefault[ "farStart" ] + 1;
		SetDevDvar( "scr_dof_farEnd", level.dofDefault[ "farEnd" ] );
	}
	if ( level.dofDefault[ "farBlur" ] >= level.dofDefault[ "nearBlur" ] )
	{
		level.dofDefault[ "farBlur" ] = level.dofDefault[ "nearBlur" ] - .1;
		SetDevDvar( "scr_dof_farBlur", level.dofDefault[ "farBlur" ] );
	}
	if ( level.dofDefault[ "farStart" ] <= level.dofDefault[ "nearEnd" ] )
	{
		level.dofDefault[ "farStart" ] = level.dofDefault[ "nearEnd" ] + 1;
		SetDevDvar( "scr_dof_farStart", level.dofDefault[ "farStart" ] );
	}
	#/
}

fogslidercheck()
{
	/#
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
	#/
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
			ent.startDist = 2000000000;
			ent.halfwayDist = 2000000001;
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

create_vision_set_vision( vision )
{
	if ( !isdefined( level.vision_set_vision ) )
		level.vision_set_vision = [];
	ent = SpawnStruct();
	ent.name = vision;

	level.vision_set_vision[ vision ] = ent;
	return ent;
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

create_vision_set_fog( fogset )
{
	if ( !isdefined( level.vision_set_fog ) )
		level.vision_set_fog = [];
	ent = SpawnStruct();
	ent.name = fogset;

	level.vision_set_fog[ fogset ] = ent;
	return ent;
}

set_fog( fogname, transition_time )
{
	level.vision_set_transition_ent.vision_set = fogname;
	level.vision_set_transition_ent.time = transition_time;
	ent = get_fog(fogname);
	if(  GetDvarInt( "scr_art_tweak") != 0 )
	{
		translateEntTosliders(ent );
		//pending some mechanism to handle transition while your editting, just set to zero for now since it leaves less room for ugly.
		transition_time = 0;
	}
	set_fog_to_ent_values( ent, transition_time );
}

set_fog_to_ent_values( ent, transition_time )
{
	if (!isdefined(transition_time))
		transition_time = 0;
	if ( IsDefined( ent.sunFogEnabled) && ent.sunFogEnabled)
	{
		if ( !isPlayer( self ) )
		{
			SetExpFog(
			ent.startDist,
			ent.halfwayDist,
			ent.red,
			ent.green,
			ent.blue,
			ent.maxOpacity,
			transition_time,
			ent.sunRed,
			ent.sunGreen,
			ent.sunBlue,
			ent.sunDir,
			ent.sunBeginFadeAngle,
			ent.sunEndFadeAngle,
			ent.normalFogScale );
		}
		else
		{
			self PlayerSetExpFog(
			ent.startDist,
			ent.halfwayDist,
			ent.red,
			ent.green,
			ent.blue,
			ent.maxOpacity,
			transition_time,
			ent.sunRed,
			ent.sunGreen,
			ent.sunBlue,
			ent.sunDir,
			ent.sunBeginFadeAngle,
			ent.sunEndFadeAngle,
			ent.normalFogScale );
		}	
	}
	else
	{
		if ( !isPlayer( self ) )
		{
			SetExpFog(
			ent.startDist,
			ent.halfwayDist,
			ent.red,
			ent.green,
			ent.blue,
			ent.maxOpacity,
			transition_time );
		}
		else
		{
			self PlayerSetExpFog(
			ent.startDist,
			ent.halfwayDist,
			ent.red,
			ent.green,
			ent.blue,
			ent.maxOpacity,
			transition_time );
		}	
	}
}

translateEntTosliders(ent)
{
	/#
		SetDevDvar( "scr_fog_exp_halfplane", ent.halfwayDist );
		SetDevDvar( "scr_fog_nearplane", ent.startDist);

		color = ( ent.red, ent.green, ent.blue );
		SetDevDvar( "scr_fog_color", color  );
		SetDevDvar( "scr_fog_max_opacity", ent.maxOpacity );

		if ( IsDefined( ent.sunFogEnabled ) && ent.sunFogEnabled)
		{

			SetDevDvar( "scr_sunFogEnabled", 1 );
			SetDevDvar( "scr_sunFogColor", (ent.sunRed, ent.sunGreen,ent.sunBlue) );
			SetDevDvar( "scr_sunFogDir", ent.sunDir );
			SetDevDvar( "scr_sunFogBeginFadeAngle", ent.sunBeginFadeAngle );
			SetDevDvar( "scr_sunFogEndFadeAngle", ent.sunEndFadeAngle );
			SetDevDvar( "scr_sunFogScale", ent.normalFogScale );
		}
		else
		{
			SetDevDvar( "scr_sunFogEnabled", 0 );
		}

	#/



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
	if (GetDvar("netconststrings_enabled") != "0")
		return;
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
	keys = getarraykeys( level.vision_set_fog );
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
	keys = getarraykeys( level.vision_set_fog );
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
	keys = getarraykeys( level.vision_set_fog );
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
	
	set_fog( keys[ index ], 0 ) ;
}

get_fog( fogset )
{
	if ( !isdefined( level.vision_set_fog ) )
		level.vision_set_fog = [];

	ent = level.vision_set_fog[ fogset ];
	//assertex( IsDefined( ent ), "fog set: " + fogset + "does not exist, use create_fog( " + fogset + " ) in your level_fog.gsc." );
	return ent;
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

dumpsettings()
{
	/#
	if ( GetDvarInt( "scr_art_dump" ) == 0 )
		return false;

	filename = "createart/" + GetDvar( "scr_art_visionfile" ) + "_art.gsc";

	artStartFogFileExport();
	fileprint_launcher( "// _createart generated.  modify at your own risk. Changing values should be fine." );
	fileprint_launcher( "main()" );
	fileprint_launcher( "{" );

	fileprint_launcher( "" );
	fileprint_launcher( "\tlevel.tweakfile = true;" );
	fileprint_launcher( " " );

	fogpath = "maps\\createart\\" + GetDvar( "scr_art_visionfile" ) + "_fog";
	fileprint_launcher( "\tif (IsUsingHDR())" );
	fileprint_launcher( "\t\t" + fogpath + "_hdr::SetupFog( );" );
	fileprint_launcher( "\telse" );
	fileprint_launcher( "\t\t" + fogpath + "::SetupFog( );" );
	
	fileprint_launcher( "\tVisionSetNaked( \"" + level.script + "\", 0 );" );

	fileprint_launcher( "" );
	fileprint_launcher( "}" );
	artEndFogFileExport();		// This actually writes out the _art file
	
	art_print_fog();	// This is what really writes out the _fog file

	visionFilename = "vision/" + GetDvar( "scr_art_visionfile" ) + ".vision";

	artStartVisionFileExport();

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
	fileprint_launcher( " " );
	fileprint_launcher( "r_charLightAmbient                   \"" + GetDvar( "r_charLightAmbient" ) + "\"" );
	fileprint_launcher( "r_viewModelLightAmbient              \"" + GetDvar( "r_viewModelLightAmbient" ) + "\"" );
	fileprint_launcher( " " );
	fileprint_launcher( "r_viewModelPrimaryLightUseTweaks     \"" + GetDvar( "r_viewModelPrimaryLightUseTweaks" ) + "\"" );
	fileprint_launcher( "r_viewModelPrimaryLightTweakDiffuseStrength \"" + GetDvar( "r_viewModelPrimaryLightTweakDiffuseStrength" ) + "\"" );
	fileprint_launcher( "r_viewModelPrimaryLightTweakSpecularStrength \"" + GetDvar( "r_viewModelPrimaryLightTweakSpecularStrength" ) + "\"" );

	if ( ! artEndVisionFileExport() )
		return false;

	IPrintLnBold( "ART DUMPED SUCCESSFULLY" );
	return true;
	#/
}

art_print_fog()
{
	default_name = get_template_level();
	fileprint_launcher_start_file();
    fileprint_launcher( "// _createart generated.  modify at your own risk. " );
    
    fileprint_launcher( "main()" );
    fileprint_launcher( "{" );
    
    print_fog_ents();

    fileprint_launcher( "}" );
    
    
	fileprint_launcher( " " );
    fileprint_launcher( "setupfog()" );
    fileprint_launcher( "{" );
    
	artfxprintlnFog();

    fileprint_launcher( "}" );
    
    if ( IsUsingHDR() )
		fileprint_launcher_end_file( "\\share\\raw\\maps\\createart\\" + default_name + "_fog_hdr.gsc", true );
    else
	fileprint_launcher_end_file( "\\share\\raw\\maps\\createart\\" + default_name + "_fog.gsc", true );
    
}

print_fog_ents()
{
	foreach( ent in level.vision_set_fog )
	{
		if( !isdefined( ent.name ) )
			continue;
		fileprint_launcher( "\tent = maps\\mp\\_art::create_vision_set_fog( \""+ent.name+"\" );");

		if( isdefined( ent.startDist ) )
			fileprint_launcher( "\tent.startDist = "+ent.startDist + ";" );
		else
			fileprint_launcher( "\tent.startDist = "+0 + ";" );
		if( isdefined( ent.halfwayDist ) )
			fileprint_launcher( "\tent.halfwayDist = "+ent.halfwayDist + ";" );
		else
			fileprint_launcher( "\tent.halfwayDist = "+0 + ";" );
		if( isdefined( ent.red ) )
			fileprint_launcher( "\tent.red = "+ent.red + ";" );
		else
			fileprint_launcher( "\tent.red = "+0 + ";" );
		if( isdefined( ent.green ) )
			fileprint_launcher( "\tent.green = "+ent.green + ";" );
		else
			fileprint_launcher( "\tent.green = "+0 + ";" );
		if( isdefined( ent.blue ) )
			fileprint_launcher( "\tent.blue = "+ent.blue + ";" );
		else
			fileprint_launcher( "\tent.blue = "+0 + ";" );
		if( isdefined( ent.maxOpacity ) )
			fileprint_launcher( "\tent.maxOpacity = "+ent.maxOpacity + ";" );
		else
			fileprint_launcher( "\tent.maxOpacity = "+0 + ";" );
		if( isdefined( ent.transitionTime ) )
			fileprint_launcher( "\tent.transitionTime = "+ent.transitionTime + ";" );
		if( isdefined( ent.sunFogEnabled ) && ent.sunFogEnabled )
		{
			fileprint_launcher( "\tent.sunFogEnabled = "+ent.sunFogEnabled + ";" );
		if( isdefined( ent.sunRed ) )
			fileprint_launcher( "\tent.sunRed = "+ent.sunRed + ";" );
			else
				fileprint_launcher( "\tent.sunRed = "+0 + ";" );
		if( isdefined( ent.sunGreen ) )
			fileprint_launcher( "\tent.sunGreen = "+ent.sunGreen + ";" );
			else
				fileprint_launcher( "\tent.sunGreen = "+0 + ";" );
		if( isdefined( ent.sunBlue ) )
			fileprint_launcher( "\tent.sunBlue = "+ent.sunBlue + ";" );
			else
				fileprint_launcher( "\tent.sunBlue = "+0 + ";" );
		if( isdefined( ent.sunDir ) )
			fileprint_launcher( "\tent.sunDir = "+ent.sunDir + ";" );
			else
				fileprint_launcher( "\tent.sunDir = "+(0,0,-1) + ";" );
		if( isdefined( ent.sunBeginFadeAngle ) )
			fileprint_launcher( "\tent.sunBeginFadeAngle = "+ent.sunBeginFadeAngle + ";" );
			else
				fileprint_launcher( "\tent.sunBeginFadeAngle = "+0 + ";" );
		if( isdefined( ent.sunEndFadeAngle ) )
			fileprint_launcher( "\tent.sunEndFadeAngle = "+ent.sunEndFadeAngle + ";" );
			else
				fileprint_launcher( "\tent.sunEndFadeAngle = "+0 + ";" );
		if( isdefined( ent.normalFogScale ) )
			fileprint_launcher( "\tent.normalFogScale = "+ent.normalFogScale + ";" );
			else
				fileprint_launcher( "\tent.normalFogScale = "+0 + ";" );
		}
		else
			fileprint_launcher( "\tent.sunFogEnabled = "+0 + ";" );
			
		fileprint_launcher ( " " );
	}
		
}

create_light_set( name )
{
	if ( !isdefined( level.light_set ) )
		level.light_set = [];
	ent = SpawnStruct();
	ent.name = name;

	level.light_set[ name ] = ent;
	return ent;
}

