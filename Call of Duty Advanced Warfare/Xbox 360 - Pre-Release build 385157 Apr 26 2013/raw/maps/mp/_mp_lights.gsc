
init()
{
	if (!isdefined(level.sunenable))
		level.sunenable = GetDvarInt( "sm_sunenable", 1 );
	if (!isdefined(level.sunshadowscale))
		level.sunshadowscale = GetDvarFloat( "sm_sunshadowscale", 1.0 );
	if (!isdefined(level.spotlimit))
		level.spotlimit = GetDvarInt( "sm_spotlimit", 4 );
	if (!isdefined(level.sunsamplesizenear))
		level.sunsamplesizenear = GetDvarFloat( "sm_sunsamplesizenear", .25 );
	if (!isdefined(level.qualityspotshadow))
		level.qualityspotshadow = GetDvarFloat( "sm_qualityspotshadow", 1.0 );
	thread monitorPlayerSpawns();

	if ( !IsDefined( level._light ) )
	{
		level._light = spawnstruct();
		light_setup_common_flickerLight_presets();
		light_message_init();
	}
	
	triggers = getentarray( "trigger_multiple_light_sunshadow", "classname" );

	for ( i = 0;i < triggers.size;i ++ )
	{
		level thread sun_shadow_trigger( triggers[ i ] );
	}

}

set_smdvars( sunenable, sunshadowscale, spotlimit, sunsamplesizenear, qualityspotshadow )
{
	if (isdefined(sunenable))
		level.sunenable = sunenable;
	if (isdefined(sunshadowscale))
		level.sunshadowscale = sunshadowscale;
	if (isdefined(spotlimit))
		level.spotlimit = spotlimit;
	if (isdefined(sunsamplesizenear))
		level.sunsamplesizenear = sunsamplesizenear;
	if (isdefined(qualityspotshadow))
		level.qualityspotshadow = qualityspotshadow;
}

monitorPlayerSpawns()
{
	if (isdefined(level.players))
	{
		foreach ( player in level.players)
		{
			player initPlayer();
		}
	}
	while (true)
	{
		level waittill( "connected", player);
		player initPlayer();
		player thread monitorDeath();
	}
}

initPlayer()
{
	self.sunenable = level.sunenable;
	self.sunshadowscale = level.sunshadowscale;
	self.spotlimit = level.spotlimit;
	self.sunsamplesizenear = level.sunsamplesizenear;
	self.qualityspotshadow = level.qualityspotshadow;
	self SetClientDvars( 
	        				"sm_sunenable", self.sunenable,
							"sm_sunshadowscale", self.sunshadowscale,
							"sm_spotlimit", self.spotlimit,
							"sm_qualityspotshadow", self.qualityspotshadow,
							"sm_sunSampleSizeNear", self.sunsamplesizenear );
}

monitorDeath()
{
	self waittill("spawned");
	self initPlayer();
}

sun_shadow_trigger( trigger )
{
	duration = 1;
	if ( IsDefined( trigger.script_duration ) )
		duration = trigger.script_duration;

	while ( true )
	{
		trigger waittill( "trigger", player );
		// not threading so it waits until it's done before resetting
		// so it doesn't keep triggering when player stays in place
		// -Carlos
		trigger set_sun_shadow_params( duration, player );
	}
}

set_sun_shadow_params( duration, player )
{
	//Set the following dvars, may add blending later
		//sm_sunenable = 1
		//sm_sunshadowscale = 1
		//sm_spotlimit = 4
		//sm_sunsamplesizenear = .25
	sunenable = player.sunenable;
	sunshadowscale = player.sunshadowscale;
	spotlimit = player.spotlimit;
	sunsamplesizenear = player.sunsamplesizenear;
	qualityspotshadow = player.qualityspotshadow;
	if ( IsDefined( self.script_sunenable ) ) sunenable = self.script_sunenable;
	if ( IsDefined( self.script_sunshadowscale ) ) sunshadowscale = self.script_sunshadowscale;
	if ( IsDefined( self.script_spotlimit ) ) spotlimit = self.script_spotlimit;
	if ( IsDefined( self.script_sunsamplesizenear ) ) sunsamplesizenear = self.script_sunsamplesizenear;
	sunsamplesizenear = min( max( 0.016, sunsamplesizenear ), 32 );
	if ( IsDefined( self.script_qualityspotshadow ) ) qualityspotshadow = self.script_qualityspotshadow;

	player SetClientDvars( 
	        				"sm_sunenable", sunenable,
							"sm_sunshadowscale", sunshadowscale,
							"sm_spotlimit", spotlimit,
							"sm_qualityspotshadow", qualityspotshadow );
	player.sunenable = sunenable;
	player.sunshadowscale = sunshadowscale;
	player.spotlimit = spotlimit;
	old_sunsamplesizenear = player.sunsamplesizenear;
	player.sunsamplesizenear = sunsamplesizenear;
	player.qualityspotshadow = qualityspotshadow;
	
	self thread lerp_sunsamplesizenear_overtime( sunsamplesizenear, old_sunsamplesizenear, duration, player );
}

lerp_sunsamplesizenear_overtime( value, old_value, time, player )
{
	level notify( "changing_sunsamplesizenear"+player.name );
	level endon( "changing_sunsamplesizenear"+player.name );
	
	if ( value == old_value )
		return;
	
	diff = value - old_value;
	dt = 0.1;
	
	times = time/dt;
	
	if ( times > 0 )
	{
		d = diff / times;
		
		v = old_value;
		for ( i=0; i<times; i++ )
		{
			v = v + d;
			player SetClientDvar( "sm_sunSampleSizeNear", v );
			player.sunsamplesizenear = v;
			wait( dt );
		}
	}
	player SetClientDvar( "sm_sunSampleSizeNear", value );
	player.sunsamplesizenear = value;
}

///////////////////////////////////////////////////////
// FLICKERING LIGHT Code
///////////////////////////////////////////////////////

light_setup_common_flickerLight_presets()
{		
	//name										color0								color1										minDelay		maxDelay	intensity
	create_flickerLight_preset("fire", 			( 0.972549, 0.624510, 0.345098 ),	 ( .2, 0.1462746, 0.0878432 ), 				.005, 			.2,			8 );
	create_flickerLight_preset("lightbulb", 	( 0.972549, 0.624510, 0.345098 ),	 ( .2, 0.1462746, 0.0878432 ), 				.005, 			.2,			6 );
	create_flickerLight_preset("fluorescent", 	( 0.972549, 0.624510, 0.345098 ),	 ( .2, 0.1462746, 0.0878432 ), 				.005, 			.2,			7 );
}	

/*
=============
///ScriptDocBegin
"Name: create_flickerLight_preset( <name> , <color0> , <color1> , <minDelay> , <maxDelay> , <intensity> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <name>: "
"MandatoryArg: <color0>: "
"MandatoryArg: <color1>: "
"MandatoryArg: <minDelay>: "
"MandatoryArg: <maxDelay>: "
"MandatoryArg: <intensity>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

create_flickerLight_preset(name, color0, color1, minDelay, maxDelay, intensity)
{
	if (!IsDefined(level._light.flicker_presets))
	{
		level._light.flicker_presets = [];
	}
	
	new_preset = spawnstruct();
	new_preset.color0 = color0;
	new_preset.color1 = color1;
	new_preset.minDelay = minDelay;
	new_preset.maxDelay = maxDelay;
	new_preset.intensity = intensity;
	
	level._light.flicker_presets[name] = new_preset;
	
//	dyn_flickerLight(name, color0, color1, minDelay, maxDelay);
}

get_flickerLight_preset(name)
{
	if (IsDefined(level._light.flicker_presets) && IsDefined(level._light.flicker_presets[name]))
	{
		return level._light.flicker_presets[name];
	}
	return undefined;
}


/*
=============
///ScriptDocBegin
"Name: play_flickerLight_preset( <name> , <targetName>, <intensity_> )"
"Summary: Plays a flickering light preset (defined with create_flickerLight_preset)"
"Module: Lighting"
"CallOn: Nothing"
"MandatoryArg: <name>: the name of the preset"
"MandatoryArg: <targetName>: the targetname of the entity type"
"OptionalArg: <intensity_>: optionally override the intensity parameter of the preset"
"Example: ent play_flickerLight_preset("fire", "fire_flicker", 4); or play_flickerLight_preset("fire", "fire_flicker");"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
play_flickerLight_preset(name, targetName, intensity_)
{
	assert(IsString(name));
	assert(IsString(targetName));
	
	ent = GetEnt( targetName, "targetname" );
	if( !IsDefined( ent ) )
	{
		println("Error Light Scripts: play_flickerLight_preset with name, \"" + name + "\", was called on a non-existant targetName, \"" + targetName + "\".");
		return;
	}
	
	preset = get_flickerLight_preset(name);
	if (!IsDefined(preset))
	{
		PrintLn("Error Light Scripts: flickerLight preset " + name + " is not defined. Please define before calling it with play_flickerLight_preset.");
		return;
	}
	
	if (IsDefined(intensity_))
	{
		if (intensity_ < 0)
		{
			PrintLn("Warning: flickerLight preset " + name + " is playing with an intensity override less than zero. Truncating.");
			intensity_ = 0;
		}
			
		preset.intensity = intensity_;
	}
	
	ent SetLightIntensity( preset.intensity );

	ent.isLightFlickering = true;
	ent.isLightFlickerPaused = false;
	
	ent thread dyn_flickerLight( preset.color0, preset.color1, preset.minDelay, preset.MaxDelay );
	
	return ent;	
}


/*
=============
///ScriptDocBegin
"Name: stop_flickerLight( <name> , <targetName> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <name>: "
"MandatoryArg: <targetName>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
stop_flickerLight(name, targetName, intensity_)
{
	ent = GetEnt( targetName, "targetname" );

	if(!IsDefined(ent))
	{
		println("Error Light Scripts: stop_flickerLight, \"" + name + "\", was called on a non-existant targetName, \"" + targetName + "\".");
		return;
	}
		
	if (!IsDefined(ent.isLightFlickering))
	{
		println("Error Light Scripts: stop_flickerLight was called on a flickering light but flickering light isn't flickering.");
		return;		
	}	
	if (IsDefined(intensity_))
	{
		if (intensity_ < 0)
		{
			PrintLn("Warning: flickerLight preset " + name + " is playing with an intensity override less than zero. Truncating.");
			intensity_ = 0;
		}
	}
	
	ent SetLightIntensity( intensity_ );
	
	ent notify("kill_flicker");
	ent.isLightFlickering = undefined;
}


/*
=============
///ScriptDocBegin
"Name: pause_flickerLight( <name> , <targetName> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <name>: "
"MandatoryArg: <targetName>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

pause_flickerLight(name, targetName)
{
	ent = GetEnt( targetName, "targetname" );

	if(!IsDefined(ent))
	{
		println("Error Light Scripts: pause_flickerLight, \"" + name + "\", was called on a non-existant targetName, \"" + targetName + "\".");
		return;
	}
	
	if (!IsDefined(ent.isLightFlickering))
	{
		println("Error Light Scripts: pause_flickerLight was called on a flickering light but flickering light isn't flickering.");
		return;		
	}
	
	ent.isLightFlickerPaused = true;
}

/*
=============
///ScriptDocBegin
"Name: unpause_flickerLight( <name> , <targetName> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <name>: "
"MandatoryArg: <targetName>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

unpause_flickerLight(name, targetName)
{
	ent = GetEnt( targetName, "targetname" );

	if(!IsDefined(ent))
	{
		println("Error Light Scripts: unpause_flickerLight, \"" + name + "\", was called on a non-existant targetName, \"" + targetName + "\".");
		return;
	}
	
	if (!IsDefined(ent.isLightFlickering))
	{
		println("Error Light Scripts: pause_flickerLight was called on a flickering light but flickering light isn't flickering.");
		return;		
	}

	ent.isLightFlickerPaused = false;
}

///the code below is mostly old and might need updating...

dyn_flickerLight( color0, color1, minDelay, maxDelay )
{
	assert(IsDefined(self.isLightFlickering));
	assert(IsDefined(self.isLightFlickerPaused));
	
	self endon("kill_flicker");
	toColor = color0;
	delay = 0.0;

	for ( ;; )
	{
		if (self.isLightFlickerPaused)
		{
			wait 0.05;
		}
		else
		{
			fromColor = toColor;
			toColor = color0 + ( color1 - color0 ) * randomfloat( 1.0 );
	
			if ( minDelay != maxDelay )
				delay += randomfloatrange( minDelay, maxDelay );
			else
				delay += minDelay;
			
			if(delay==0) delay+=.0000001;//Prevent divide by zero
			colorDeltaPerTime = ( fromColor - toColor ) * ( 1 / delay );
			while ( (delay > 0) && !self.isLightFlickerPaused )
			{
				self setLightColor( toColor + colorDeltaPerTime * delay );
				wait 0.05;
				delay -= 0.05;
			}
		}
	}
}
///////////////////////////////////////////////////////
// FLICKERING MODEL
///////////////////////////////////////////////////////
/*
=============
///ScriptDocBegin
"Name: model_flicker_preset( <script_noteworthy> , <number_of_flickers> , <fxid1> , <fxid2> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <script_noteworthy>: "
"MandatoryArg: <number_of_flickers>: "
"MandatoryArg: <fxid1>: "
"MandatoryArg: <fxid2>: "
"Example: 		thread model_flicker_preset("light_flicker_test", 7, 1667, 1668);"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
model_flicker_preset(script_noteworthy, number_of_flickers, fxid1, fxid2 )
{
	assert(IsString(script_noteworthy));
	
	ent = GetEntArray( script_noteworthy, "script_noteworthy" );
	if( !IsDefined( ent ) )
	{
		println("please define a targetname");
		return;
	}
	
	self endon( "death" );
    flicker_count = 0;
    time_between_flicker = RandomFloatRange( .1, .25 );
    
    if( IsDefined( fxid1 ) )
		{
		   	exploder(fxid1);
		}    
    
    while (flicker_count < number_of_flickers)
    {
    	if( IsDefined( fxid2 ) )
		{
		   	exploder(fxid2);
		}
 	  	foreach (light in ent)
			{
 	 			light Show();
			}		
		wait time_between_flicker;
		if( IsDefined( fxid2 ) )
		{
		   	stop_exploder(fxid2);
		}
		foreach (light in ent)
			{
 	 			light Hide();
			}
		flicker_count++;
		wait time_between_flicker;
    }
}
///////////////////////////////////////////////////////
// Light Message Script Code
///////////////////////////////////////////////////////

light_message_init()
{
	assert(IsDefined(level._light));
	level._light.messages = [];
}

light_debug_dvar_init()
{
	/#
	SetDvarIfUninitialized( "light_debug_messages", 0 );
	#/
}

light_register_message( message, callback )
{
	assertEx( IsDefined( level._light ), "Need to call light_message_init() before calling this function." );
	level._light.messages[message] = callback;
}

light_message( message, arg1, arg2, arg3 )
{
	AssertEx( IsDefined( level._light ), "Need to call light_message_init() before calling this function." );
	
	if ( IsDefined( level._light.messages[message] ) )
	{
		if ( IsDefined( arg3 ) )
			thread [[ level._light.messages[message] ]]( arg1, arg2, arg3 );
		else if ( IsDefined( arg2 ) )
			thread [[ level._light.messages[message] ]]( arg1, arg2 );
		else if ( IsDefined( arg1 ) )
			thread [[ level._light.messages[message] ]]( arg1 );
		else
			thread [[ level._light.messages[message] ]]();
	}
}


/*
=============
///ScriptDocBegin
"Name: stop_exploder( <num> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <param1>: "
"OptionalArg: <param2>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
stop_exploder( num )
{
	num += "";

	if (isdefined(level.createFXexploders))
	{	// do optimized flavor if available
		exploders = level.createFXexploders[num];
		if (isdefined(exploders))
		{
			foreach (ent in exploders)
			{
				if ( !isdefined( ent.looper ) )
					continue;
		
				ent.looper Delete();
			}
		}
	}
	else
	{
		for ( i = 0; i < level.createFXent.size; i++ )
		{
			ent = level.createFXent[ i ];
			if ( !isdefined( ent ) )
				continue;
	
			if ( ent.v[ "type" ] != "exploder" )
				continue;
	
			// make the exploder actually removed the array instead?
			if ( !isdefined( ent.v[ "exploder" ] ) )
				continue;
	
			if ( ent.v[ "exploder" ] + "" != num )
				continue;
	
			if ( !isdefined( ent.looper ) )
				continue;
	
			ent.looper Delete();
		}
	}
}

/*
=============
///ScriptDocBegin
"Name: exploder( <num> )"
"Summary: Sets off the desired exploder"
"Module: Utility"
"MandatoryArg: <num>: The exploder number"
"Example: exploder( 5 );"
"SPMP: both"
///ScriptDocEnd
=============
*/
exploder( num )
{
	[[ level.exploderFunction ]]( num );
}


