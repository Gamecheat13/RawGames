// This function should take care of grain and glow settings for each map, plus anything else that artists 
// need to be able to tweak without bothering level designers.
//#include maps\_utility; 
#include common_scripts\utility; 
#include maps\mp\_utility; 

main()
{
/#
	if( GetDvar( "scr_art_tweak" ) == "" || GetDvar( "scr_art_tweak" ) == "0" )
	{
		SetDvar( "scr_art_tweak", 0 ); 
	}

	if( GetDvar( "scr_dof_enable" ) == "" )
	{
		SetDvar( "scr_dof_enable", "1" ); 
	}
		
	if( GetDvar( "scr_cinematic_autofocus" ) == "" )
	{
		SetDvar( "scr_cinematic_autofocus", "1" ); 
	}

	if( GetDvar( "scr_art_visionfile" ) == "" )
	{
		SetDvar( "scr_art_visionfile", level.script ); 
	}

	if( GetDvar( "debug_reflection" ) == "" )
	{
		SetDvar( "debug_reflection", "0" ); 
	}

	PrecacheModel( "test_sphere_silver" );
	level thread debug_reflection();
#/

	if( !IsDefined( level.dofDefault ) )
	{
		level.dofDefault["nearStart"] = 0; 
		level.dofDefault["nearEnd"] = 1; 
		level.dofDefault["farStart"] = 8000; 
		level.dofDefault["farEnd"] = 10000; 
		level.dofDefault["nearBlur"] = 6; 
		level.dofDefault["farBlur"] = 0; 
	}

	level.curDoF = ( level.dofDefault["farStart"] - level.dofDefault["nearEnd"] ) / 2; 
	
/#
	thread tweakart(); 
#/
	
	if( !IsDefined( level.script ) )
	{
		level.script = tolower( GetDvar( "mapname" ) ); 
	}
	
	
}

artfxprintln( file, string )
{
	// printing to file is optional now
	if( file == -1 )
	{
		return; 
	}
	fprintln( file, string ); 
}


// Nate - hack Fixmed and replace with proper script command call once it's fixed.
// assumes " " as the deliiter. I'm not getting fancy.  
// I would really like to go work on jeepride so here's a 
// quick function that works for now untill engineering fixes strtok.

strtok_loc( string, par1 )
{
	stringlist = []; 
	indexstring = ""; 
	for( i = 0 ; i < string.size ; i ++ )
	{
		if( string[i] == " " )
		{
			stringlist[stringlist.size] = indexstring; 
			indexstring = ""; 
		}
		else
		{
			indexstring = indexstring+string[i]; 
		}
	}
	if( indexstring.size )
	{
		stringlist[stringlist.size] = indexstring; 
	}
	return stringlist; 
}


setfogsliders()
{
	//fixme.  replace strtok_loc with strtok if it ever works properly.
	fogall = strtok_loc( GetDvar( "g_fogColorReadOnly" ), " " ) ;
	red = fogall[ 0 ];
	green = fogall[ 1 ];
	blue = fogall[ 2 ];
	halfplane = GetDvar( "g_fogHalfDistReadOnly" );
	nearplane = GetDvar( "g_fogStartDistReadOnly" );
		
	if ( !isdefined( red )
		 || !isdefined( green )
		 || !isdefined( blue )
		 || !isdefined( halfplane )
		 )
	{
		red = 1;
		green = 1;
		blue = 1;
		halfplane = 10000001;
		nearplane = 10000000;
	}
	SetDvar("scr_fog_exp_halfplane",halfplane);
	SetDvar("scr_fog_nearplane",nearplane);
	SetDvar("scr_fog_color",red+" "+green+" "+blue);
}

tweakart()
{
	 /#
	if( !IsDefined( level.tweakfile ) )
	{
		level.tweakfile = false; 
	}
	

	// Default values
	
	if(GetDvar( "scr_fog_baseheight") == "")
	{
		SetDvar( "scr_fog_exp_halfplane", "500" ); 
		SetDvar( "scr_fog_exp_halfheight", "500" ); 
		SetDvar( "scr_fog_nearplane", "0" ); 
		SetDvar( "scr_fog_baseheight", "0" ); 
	}

	// not in DEVGUI
	SetDvar( "scr_fog_fraction", "1.0" ); 
	SetDvar( "scr_art_dump", "0" ); 
	SetDvar("scr_art_sun_fog_dir_set", "0");

	// update the devgui variables to current settings
	SetDvar( "scr_dof_nearStart", level.dofDefault["nearStart"] ); 
	SetDvar( "scr_dof_nearEnd", level.dofDefault["nearEnd"] ); 
	SetDvar( "scr_dof_farStart", level.dofDefault["farStart"] ); 
	SetDvar( "scr_dof_farEnd", level.dofDefault["farEnd"] ); 
	SetDvar( "scr_dof_nearBlur", level.dofDefault["nearBlur"] ); 
	SetDvar( "scr_dof_farBlur", level.dofDefault["farBlur"] ); 	


	file = undefined; 
	filename = undefined; 
	
	// set dofvars from < levelname > _art.gsc
	
	
	tweak_toggle = 1;	
	for( ;; )
	{
		while(GetDvarint( "scr_art_tweak" ) == 0 )
		{
			tweak_toggle = 1;
			wait .05; 
		}
		
		if(tweak_toggle)
		{
			tweak_toggle = 0;
			fogsettings = getfogsettings();

			SetDvar( "scr_fog_nearplane", fogsettings[0] ); 
			SetDvar( "scr_fog_exp_halfplane", fogsettings[1] ); 
			SetDvar( "scr_fog_exp_halfheight", fogsettings[3] ); 
			SetDvar( "scr_fog_baseheight", fogsettings[2] ); 

			SetDvar("scr_fog_color", fogsettings[4]+" "+fogsettings[5]+" "+fogsettings[6]);
			SetDvar("scr_fog_color_scale", fogsettings[7]);
			SetDvar("scr_sun_fog_color", fogsettings[8]+" "+fogsettings[9]+" "+fogsettings[10]);
			
			level.fogsundir = [];
			level.fogsundir[0] = fogsettings[11];
			level.fogsundir[1] = fogsettings[12];
			level.fogsundir[2] = fogsettings[13];

			SetDvar("scr_sun_fog_start_angle",fogsettings[14] );
			SetDvar("scr_sun_fog_end_angle",fogsettings[15] );

			SetDvar("scr_fog_max_opacity", fogsettings[16]);
		
		
		}
		
		//translate the slider values to script variables

		level.fogexphalfplane = GetDvarfloat( "scr_fog_exp_halfplane");
		level.fogexphalfheight = GetDvarfloat( "scr_fog_exp_halfheight");
		level.fognearplane = GetDvarfloat( "scr_fog_nearplane");
		level.fogbaseheight = GetDvarfloat( "scr_fog_baseheight");

		level.fogcolorred = GetDvarcolorred("scr_fog_color");
		level.fogcolorgreen = GetDvarcolorgreen("scr_fog_color");
		level.fogcolorblue = GetDvarcolorblue("scr_fog_color");
		level.fogcolorscale = GetDvarfloat( "scr_fog_color_scale");

		level.sunfogcolorred = GetDvarcolorred("scr_sun_fog_color");
		level.sunfogcolorgreen = GetDvarcolorgreen("scr_sun_fog_color");
		level.sunfogcolorblue = GetDvarcolorblue("scr_sun_fog_color");
		
		level.sunstartangle = GetDvarfloat( "scr_sun_fog_start_angle");
		level.sunendangle = GetDvarfloat( "scr_sun_fog_end_angle");
		level.fogmaxopacity = GetDvarfloat( "scr_fog_max_opacity");

		if(	GetDvarint( "scr_art_sun_fog_dir_set") ) 
		{
			SetDvar( "scr_art_sun_fog_dir_set", "0" );
			
			println("Setting sun fog direction to facing of player");
			
			players = GET_PLAYERS();

			dir = VectorNormalize( AnglesToForward( players[0] GetPlayerAngles() ) );

			level.fogsundir = [];
			level.fogsundir[0] = dir[0];
			level.fogsundir[1] = dir[1];
			level.fogsundir[2] = dir[2];
		}
		
		
		// catch all those cases where a slider can be pushed to a place of conflict
		fovslidercheck(); 

		dumpsettings(); // dumps and returns true if the dump dvar is set
		
		// updates fog to the variables

		if ( ! GetDvarint( "scr_fog_disable" ) )
		{
			if(!IsDefined(level.fogsundir)) {
				level.fogsundir = [];
				level.fogsundir[0] = 1;
				level.fogsundir[1] = 0;
				level.fogsundir[2] = 0;
			}

			setVolFog( level.fognearplane, level.fogexphalfplane, level.fogexphalfheight, level.fogbaseheight, level.fogcolorred, level.fogcolorgreen, level.fogcolorblue, 
				level.fogcolorscale, level.sunfogcolorred, level.sunfogcolorgreen, level.sunfogcolorblue, level.fogsundir[0], level.fogsundir[1], level.fogsundir[2], level.sunstartangle, level.sunendangle, 0, level.fogmaxopacity ); 
		}
		else
		{
			setExpFog( 100000000, 100000001, 0, 0, 0, 0 ); // couldn't find discreet fog disabling other than to never set it in the first place
		}

		wait .1; 
	}
	#/ 
}         

fovslidercheck()
{
	// catch all those cases where a slider can be pushed to a place of conflict
	if( level.dofDefault["nearStart"] >= level.dofDefault["nearEnd"] )
	{
		level.dofDefault["nearStart"] = level.dofDefault["nearEnd"] - 1; 
		SetDvar( "scr_dof_nearStart", level.dofDefault["nearStart"] ); 
	}
	if( level.dofDefault["nearEnd"] <= level.dofDefault["nearStart"] )
	{
		level.dofDefault["nearEnd"] = level.dofDefault["nearStart"] + 1; 
		SetDvar( "scr_dof_nearEnd", level.dofDefault["nearEnd"] ); 
	}
	if( level.dofDefault["farStart"] >= level.dofDefault["farEnd"] )
	{
		level.dofDefault["farStart"] = level.dofDefault["farEnd"] - 1; 
		SetDvar( "scr_dof_farStart", level.dofDefault["farStart"] ); 
	}
	if( level.dofDefault["farEnd"] <= level.dofDefault["farStart"] )
	{
		level.dofDefault["farEnd"] = level.dofDefault["farStart"] + 1; 
		SetDvar( "scr_dof_farEnd", level.dofDefault["farEnd"] ); 
	}
	if( level.dofDefault["farBlur"] >= level.dofDefault["nearBlur"] )
	{
		level.dofDefault["farBlur"] = level.dofDefault["nearBlur"] - .1; 
		SetDvar( "scr_dof_farBlur", level.dofDefault["farBlur"] ); 
	}
	if( level.dofDefault["farStart"] <= level.dofDefault["nearEnd"] )
	{
		level.dofDefault["farStart"] = level.dofDefault["nearEnd"] + 1; 
		SetDvar( "scr_dof_farStart", level.dofDefault["farStart"] ); 
	}
} 

dumpsettings()
{
	 /#
	if ( GetDvar( "scr_art_dump" ) != "0" )
	{
		PrintLn("\tstart_dist = " + level.fognearplane + ";");
		PrintLn("\thalf_dist = " + level.fogexphalfplane + ";");
		PrintLn("\thalf_height = " + level.fogexphalfheight + ";");
		PrintLn("\tbase_height = " + level.fogbaseheight + ";");
		PrintLn("\tfog_r = " + level.fogcolorred + ";");
		PrintLn("\tfog_g = " + level.fogcolorgreen + ";");
		PrintLn("\tfog_b = " + level.fogcolorblue + ";");
		PrintLn("\tfog_scale = " + level.fogcolorscale + ";");
		PrintLn("\tsun_col_r = " + level.sunfogcolorred + ";");
		PrintLn("\tsun_col_g = " + level.sunfogcolorgreen + ";");
		PrintLn("\tsun_col_b = " + level.sunfogcolorblue + ";");
		PrintLn("\tsun_dir_x = " + level.fogsundir[0] + ";");
		PrintLn("\tsun_dir_y = " + level.fogsundir[1] + ";");
		PrintLn("\tsun_dir_z = " + level.fogsundir[2] + ";");
		PrintLn("\tsun_start_ang = " + level.sunstartangle + ";");
		PrintLn("\tsun_stop_ang = " + level.sunendangle + ";");
		PrintLn("\ttime = 0;");
		PrintLn("\tmax_fog_opacity = " + level.fogmaxopacity +";");
		PrintLn("");
		PrintLn("\tsetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,");
		PrintLn("\t\tsun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, ");
		PrintLn("\t\tsun_stop_ang, time, max_fog_opacity);");
				
		SetDvar( "scr_art_dump", "0" );
	}
	#/ 
}

debug_reflection()
{
/#
	level.debug_reflection = 0;

	while( 1 )
	{
		wait( 0.1 );

		if( ( GetDvar( "debug_reflection" ) == "2" && level.debug_reflection != 2 ) ||( GetDvar( "debug_reflection" ) == "3"  && level.debug_reflection != 3 ) )
		{
			remove_reflection_objects(); 
			if( GetDvar( "debug_reflection" ) == "2" )
			{
				create_reflection_objects(); 
				level.debug_reflection = 2; 
			}
			else
			{
				create_reflection_objects(); 
				create_reflection_object(); 
				level.debug_reflection = 3; 
			}
		}
		else if( GetDvar( "debug_reflection" ) == "1"  && level.debug_reflection != 1 )
		{
			remove_reflection_objects(); 
			create_reflection_object(); 
			level.debug_reflection = 1; 
		}
		else if( GetDvar( "debug_reflection" ) == "0" && level.debug_reflection != 0 )
		{
			remove_reflection_objects(); 
			level.debug_reflection = 0; 
		}
	}
#/
}

remove_reflection_objects()
{
/#
	if( ( level.debug_reflection == 2 || level.debug_reflection == 3 ) && IsDefined( level.debug_reflection_objects ) )
	{
		for( i = 0; i < level.debug_reflection_objects.size; i++ )
		{
			level.debug_reflection_objects[i] Delete(); 
		}
		level.debug_reflection_objects = undefined; 
	}
	
	if( level.debug_reflection == 1 || level.debug_reflection == 3 )
	{
		level.debug_reflectionobject Delete(); 
	}
#/
}

create_reflection_objects()
{
/#
	reflection_locs = GetReflectionLocs(); 
	for( i = 0; i < reflection_locs.size; i++ )
	{
		level.debug_reflection_objects[i] = Spawn( "script_model", reflection_locs[i] ); 
		level.debug_reflection_objects[i] SetModel( "test_sphere_silver" ); 
	}
#/
}

create_reflection_object()
{
/#
	players = GET_PLAYERS(); 
	while( players.size < 1 )
	{
		wait( 0.5 );
		players = GET_PLAYERS();
	}

	player = getHostPlayer();

	level.debug_reflectionobject = Spawn( "script_model", player GetEye() + ( VectorScale( AnglesToForward( player.angles ), 100 ) ) ); 
	level.debug_reflectionobject SetModel( "test_sphere_silver" ); 
	level.debug_reflectionobject.origin = player geteye() + ( VectorScale( anglestoforward( player getplayerangles() ), 100 ) ); 
	player thread debug_reflection_buttons();
#/	
}

debug_reflection_buttons()
{
/#
	self endon( "death" ); 

	offset = 100; 
	lastoffset = offset; 
	offsetinc = 50; 
	while( GetDvar( "debug_reflection" ) == "1" || GetDvar( "debug_reflection" ) == "3" )
	{
		if( self buttonpressed( "BUTTON_X" ) )
		{
			offset+= offsetinc; 
		}

		if( self ButtonPressed( "BUTTON_Y" ) )
		{
			offset-= offsetinc; 
		}

		if( offset > 1000 )
		{
			offset = 1000; 
		}

		if( offset < 64 )
		{
			offset = 64; 
		}

		level.debug_reflectionobject.origin = self GetEye() + ( VectorScale( AnglesToForward( self GetPlayerAngles() ), offset ) ); 
		lastoffset = offset; 
		
		line(	level.debug_reflectionobject.origin, 
			getreflectionorigin( level.debug_reflectionobject.origin ),
			(1,0,0),
			true,
			1 );

		wait( 0.05 ); 
	}
#/
}


