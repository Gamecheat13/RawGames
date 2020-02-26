// Client side audio functionality

#include clientscripts\mp\_utility;
#include clientscripts\mp\_ambientpackage;


audio_init( localClientNum )
{
	waitforclient( 0 ); // wait until the first snapshot has arrived
	
	if( localClientNum == 0 )
	{
		snd_snapshot_init();

		startSoundRandoms( localClientNum );
		startSoundLoops();
		startLineEmitters();

		thread bump_trigger_start(localClientNum);
		thread init_audio_triggers(localClientNum);
		thread snd_mp_end_round();
		thread snd_final_killcam();
		
	}
}

snd_snapshot_init()
{
	level._sndActiveSnapshot = "default";
	level._sndNextSnapshot = "default";
	
	setgroupsnapshot( level._sndActiveSnapshot );

	thread snd_snapshot_think();
}


snd_set_snapshot(state)
{
	level._sndNextSnapshot = state;

	println( "snd snapshot debug: set state '"+state+"'" );
	
	level notify( "new_bus" );
}


snd_snapshot_think()
{
	for(;;)
	{
		if( level._sndActiveSnapshot == level._sndNextSnapshot ) //state didn't change during transition
		{
			level waittill( "new_bus" );
		}
		
		if( level._sndActiveSnapshot == level._sndNextSnapshot ) //got same one twice, ignore
		{
			continue;
		}
		
		assert( IsDefined( level._sndNextSnapshot ) );
		assert( IsDefined( level._sndActiveSnapshot ) );

		setgroupsnapshot( level._sndNextSnapshot );

		level._sndActiveSnapshot = level._sndNextSnapshot;
	}
}

snd_mp_end_round()
{
	level waittill( "snd_end_rnd" );
	
	println( "setting round end snapshot" );
	
	snd_set_snapshot("mpl_round_end" );
}

soundRandom_Thread( localClientNum, randSound )
{
	if( !IsDefined( randSound.script_wait_min ) )
	{
		randSound.script_wait_min = 1;
	}
	if( !IsDefined( randSound.script_wait_max ) )
	{
		randSound.script_wait_max = 3;
	}
	
	/#
	if( GetDvarint( "debug_audio" ) > 0 )
	{
			//println( "*** Client : SR ( " + randSound.script_wait_min + " - " + randSound.script_wait_max + ")" );
	}
	#/
	
	while( 1 )
	{
		wait( RandomFloatRange( randSound.script_wait_min, randSound.script_wait_max ) );
		
		if( !IsDefined( randSound.script_sound ) )
		{
			//println( "ambient sound at "+randSound.origin+" has undefined script_sound" );
		}
		else
		{
			playsound( localClientNum, randSound.script_sound, randSound.origin );
		}

		/#
		if( GetDvarint( "debug_audio" ) > 0 )
		{
			print3d( randSound.origin, randSound.script_sound, (0.0, 0.8, 0.0), 1, 3, 45 );
		}
		#/
	}
}


startSoundRandoms( localClientNum )
{
	randoms = GetStructArray( "random", "script_label" );
	
	if( IsDefined( randoms ) && randoms.size > 0 )
	{
		//println( "*** Client : Initialising random sounds - " + randoms.size + " emitters." );
		for( i = 0; i < randoms.size; i++ )
		{
			thread soundRandom_Thread( localClientNum, randoms[i] );
		}
	}
	else
	{
		//println( "*** Client : No random sounds." );
	}
}

//self is looper struct
soundLoopThink()
{
	if( !IsDefined( self.script_sound ) )
	{
		return;
	} 
	
	if( !IsDefined( self.origin ) )
	{
		return;
	}

	//println("starting loop loop");
	
	notifyName = "";
	assert( IsDefined( notifyName ) );
	
	if( IsDefined( self.script_string ) )
	{
		notifyName = self.script_string;
	}
	assert( IsDefined( notifyName ) );
	
	started = true;
	
	if( IsDefined( self.script_int ) )
	{
		started = self.script_int != 0;
	}
	
	if( started )
	{
		soundloopemitter( self.script_sound, self.origin );
	}
	
	if( notifyName != "" )
	{
		//println( "starting loop notify" );

		for(;;)
		{
			level waittill( notifyName );
			//iprintlnbold("got looper notify "+notifyName);
			if( started )
			{
				soundstoploopemitter( self.script_sound, self.origin );
			}
			else
			{
				soundloopemitter( self.script_sound, self.origin );
			}
			started = !started;
		}
	}
	else
	{
		//println( "looper doesn't take notifies" );
	}
}

//self is line struct
soundLineThink()
{
	//println("starting line line");
	
	if(!IsDefined( self.target) )
	{
		return;
	}
	
	target = getstruct( self.target, "targetname" );
	
	if( !IsDefined( target) )
	{
		return;
	}
	
	notifyName = "";
	
	if( IsDefined( self.script_string ) )
	{
		notifyName = self.script_string;
	}
	
	started = true;
	
	if( IsDefined( self.script_int ) )
	{
		started = self.script_int != 0;
	}
	
	if( started )
	{
		soundLineEmitter( self.script_sound, self.origin, target.origin );
	}
	
	if( notifyName != "" )
	{
		//println(" starting line notify" );

		for(;;)
		{
			level waittill( notifyName );
			//iprintlnbold("got line notify "+notifyName);
			if( started )
			{
				soundStopLineEmitter( self.script_sound, self.origin, target.origin );
			}
			else
			{
				soundLineEmitter( self.script_sound, self.origin, target.origin );
			}
			started = !started;
		}
	}
	else
	{
		//println( "line doesn't take notifies" );
	}
}


startSoundLoops()
{
	loopers = GetStructArray( "looper", "script_label" );
	
	if( IsDefined( loopers ) && loopers.size > 0 )
	{
		delay = 0;
/#
		if( GetDvarint( "debug_audio" ) > 0 )
		{
			println( "*** Client : Initialising looper sounds - " + loopers.size + " emitters." );
		}	
#/			
		for( i = 0; i < loopers.size; i++ )
		{
			loopers[i] thread soundLoopThink();
			delay += 1;

			if( delay % 20 == 0 ) //don't send more than 20 a frame
			{
				wait( 0.01 );
			}
		}		
	}
	else
	{
/#
		if( GetDvarint( "debug_audio" ) > 0 )
		{
			println( "*** Client : No looper sounds." );
		}	
#/			
	}
}


startLineEmitters()
{
	lineEmitters = GetStructArray( "line_emitter", "script_label" );
	
	if( IsDefined( lineEmitters ) && lineEmitters.size > 0 )
	{
		delay = 0;
/#
		if( GetDvarint( "debug_audio" ) > 0 )
		{
			println( "*** Client : Initialising line emitter sounds - " + lineEmitters.size + " emitters." );
		}	
#/			
		for( i = 0; i < lineEmitters.size; i++ )
		{
			lineEmitters[i] thread soundLineThink();
			delay += 1;

			if( delay % 20 == 0 ) //don't send more than 20 a frame
			{
				wait( 0.01 );
			}
		}
	}
	else
	{
/#
		if( GetDvarint( "debug_audio" ) > 0 )
		{
			println( "*** Client : No line emitter sounds." );
		}	
#/			
	}
}


// TRIGGERS
init_audio_triggers(localClientNum)
{
	waitforclient( localClientNum ); // wait until the first snapshot has arrived
	
	stepTrigs = GetEntArray( localClientNum, "audio_step_trigger","targetname" );
	materialTrigs = GetEntArray( localClientNum, "audio_material_trigger","targetname" );
/#
	if( GetDvarint( "debug_audio" ) > 0 )
	{
		println( "Client : " + stepTrigs.size + " audio_step_triggers." );
		println( "Client : " + materialTrigs.size + " audio_material_triggers." );
	}	

#/			
	array_thread( stepTrigs, ::audio_step_trigger, localClientNum );
	array_thread( materialTrigs, ::audio_material_trigger, localClientNum );
}

audio_step_trigger( localClientNum )
{
	self.localClientNum = localClientNum;
	for(;;)
	{
		self waittill( "trigger", trigPlayer );

		// set up the trigs
		self trigger_thread( trigPlayer, ::trig_enter_audio_step_trigger, ::trig_leave_audio_step_trigger );
	} 
}



audio_material_trigger( trig )
{
	for(;;)
	{
		self waittill( "trigger", trigPlayer );

		// set up the trigs
		self trigger_thread( trigPlayer, ::trig_enter_audio_material_trigger, ::trig_leave_audio_material_trigger );
	}
}

trig_enter_audio_material_trigger( player )
{	
	if( !IsDefined( player.inMaterialOverrideTrigger ) )
	{
		player.inMaterialOverrideTrigger = 0;
	}
	if( Isdefined( self.script_label ) )
	{
		player.inMaterialOverrideTrigger++;
		player.audioMaterialOverride = self.script_label;
	}
}

trig_leave_audio_material_trigger( player )
{
	if( Isdefined( self.script_label ) )
	{
		player.inMaterialOverrideTrigger--;
/#
		assert( player.inMaterialOverrideTrigger >= 0 );
#/
		if ( player.inMaterialOverrideTrigger <= 0 )
		{
			player.audioMaterialOverride = undefined;	
			player.inMaterialOverrideTrigger = 0;
		}
	}
}


trig_enter_audio_step_trigger( trigPlayer )
{
	localClientNum = self.localClientNum;
	if( trigPlayer HasPerk( localClientNum, "specialty_quieter" ))
	{
		return;
	}	
	if( !IsDefined( trigPlayer.movementtype ) )
	{
		trigPlayer.movementtype = "none";
	}
	if( !IsDefined( trigPlayer.inStepTrigger ) )
	{
		trigPlayer.inStepTrigger = 0;
	}
	
	// trigPlayer is the player
	// self is the trigger.
	// set the step script_label for use in _footstep
	if( Isdefined( self.script_label) )
	{
		trigPlayer.step_sound = self.script_label;
		trigPlayer.inStepTrigger = trigPlayer.inStepTrigger + 1; 
	}
	if( Isdefined( self.script_sound ) && ( trigPlayer.movementtype == "sprint" ) )
	{
		volume = get_vol_from_speed (trigPlayer);
		trigPlayer playsound( localClientNum, self.script_sound, self.origin, volume );
	}
}

trig_leave_audio_step_trigger(trigPlayer)
{
	localClientNum = self.localClientNum;
	if ( trigPlayer HasPerk( localClientNum, "specialty_quieter" ))
	{
		return;
	}	
	
	if( Isdefined( self.script_noteworthy ) && ( trigPlayer.movementtype == "sprint" ) )
	{
		volume = get_vol_from_speed (trigPlayer);
		trigPlayer playsound( localClientNum, self.script_noteworthy, self.origin, volume );
	}
	if ( Isdefined( self.script_label) )
	{
		trigPlayer.inStepTrigger = trigPlayer.inStepTrigger - 1; 
	}
	if (trigPlayer.inStepTrigger < 0 )
	{
		println("AUDIO WARNING InStepTrigger less than 0. Should never be. setting to 0" );	
		trigPlayer.inStepTrigger = 0;
	
	}	
	if (trigPlayer.inStepTrigger == 0)
	{
		trigPlayer.step_sound = "none";
	}
}

bump_trigger_start( localClientNum )
{
	//wait (.1);
	bump_trigs = GetEntArray( localClientNum, "audio_bump_trigger", "targetname" );
	
	for( i = 0; i < bump_trigs.size; i++)
	{
		bump_trigs[i] thread thread_bump_trigger(localClientNum);	
	}
}

thread_bump_trigger(localClientNum)
{
	//iprintlnbold ("Found a trigger!");
	self thread bump_trigger_listener();
	if( !IsDefined( self.script_activated ) ) //Sets a flag to turn the trigger on or off
	{
		self.script_activated = 1;
	}
	self.localClientNum = localClientNum;
	for(;;)
	{
		self waittill ( "trigger", trigPlayer );
		
		self trigger_thread( trigPlayer, ::trig_enter_bump, ::trig_leave_bump );
	}	
}

trig_enter_bump( ent )
{
	localClientNum = self.localClientNum;
	if ( ent HasPerk( localClientNum, "specialty_quieter" ))
	{
		return;
	}	
	// iPrintLnBold( "enter bump: " );
	volume = get_vol_from_speed( ent );

	if( IsDefined( self.script_sound ) && (self.script_activated))
	{
		// script_noteworthy is the alias that will play if your speed is lower than the script_wait float
		if( IsDefined( self.script_noteworthy ) && ( self.script_wait > volume ) )
		{
			test_id = ent playsound( localClientNum, self.script_noteworthy,self.origin, volume );
		}
		if( IsDefined( self.script_parameters ))	
		{	
		//    IPrintLnBold ( self.script_parameters );
			test_id = ent playsound( localClientNum, self.script_parameters, self.origin, volume );	
		}

		if( !IsDefined( self.script_wait ) || ( self.script_wait <= volume ) )
		{
			test_id = ent playsound( localClientNum, self.script_sound, self.origin, volume );
		}
		
	}
}
trig_leave_bump( ent )
{
	//iPrintLnBold( "leave bump: " );
}

bump_trigger_listener() //This will deactivate the trigger on a level notify if its stored on the trigger
{
	//Store End-On conditions in script_label so you can turn off the bump trigger if a condition is met
	if( IsDefined( self.script_label ) )
	{
		level waittill( self.script_label );
		self.script_activated = 0;
	}
}

//this will do some mathmagic to scale to the min/max speed to min max volume
scale_speed( x1, x2, y1, y2, z )
{
	if ( z < x1)
		z = x1;
	if ( z > x2)
		z = x2;

	dx = x2 - x1;
	n = ( z - x1) / dx;
	dy = y2 - y1;
	w = (n*dy + y1);

	return w;
}

get_vol_from_speed( player )
{
	// values to map to a linear scale
	min_speed = 21;
	max_speed = 285;
	max_vol = 1;
	min_vol = .1;

	speed = player getspeed();
	
	// hack for ai until getspeed returns correct speed	
	if( speed == 0 )
	{
		// iprintlnbold( "AI override" );
		speed = 175;
	}	

	// make sure we are not getting negative vaules. may be unneeded
	abs_speed = absolute_value( int( speed ) );
	volume = scale_speed( min_speed, max_speed, min_vol, max_vol, abs_speed );
	//iprintlnbold( "Volume: " + volume + " Speed: " + abs_speed );

	return volume;
}

absolute_value( fowd )
{
	if( fowd < 0 )
		return (fowd*-1);
	else
		return fowd;
}

// self is the script origin mover
// the crazy math Alex C wrote on COD3, convered to GSC for COD5
closest_point_on_line_to_point( Point, LineStart, LineEnd )
{
	self endon ("end line sound");
	
	LineMagSqrd = lengthsquared(LineEnd - LineStart);
 
	t =	( ( ( Point[0] - LineStart[0] ) * ( LineEnd[0] - LineStart[0] ) ) +
		( ( Point[1] - LineStart[1] ) * ( LineEnd[1] - LineStart[1] ) ) +
		( ( Point[2] - LineStart[2] ) * ( LineEnd[2] - LineStart[2] ) ) ) /
		( LineMagSqrd );
 
	if( t < 0.0  )
	{
		self.origin = LineStart;
	}
	else if( t > 1.0 )
	{
		self.origin = LineEnd;
	}
	else
	{
		start_x = LineStart[0] + t * ( LineEnd[0] - LineStart[0] );
		start_y = LineStart[1] + t * ( LineEnd[1] - LineStart[1] );
		start_z = LineStart[2] + t * ( LineEnd[2] - LineStart[2] );

		self.origin = ( start_x, start_y, start_z );
	}
}


snd_play_auto_fx( fxid, alias, offsetx, offsety, offsetz, onground, area, threshold, alaisOverride )
{
	for( i = 0; i < level.createFXent.size; i++ )
	{
		if( level.createFXent[i].v["fxid"] == fxid )
		{
			if (isdefined (area))
			{
				level.createFXent[i].soundEntArea = area;
			}	

			origin = level.createFXent[i].v["origin"];

			if (isdefined (offsetx) && offsetx > 0 )
			{
				//add offset to origin
				origin = origin + (offsetx,0,0);
		}
			if (isdefined (offsety) && offsety > 0 )
			{
				//add offset to origin
				origin = origin + (0,offsety,0);
	}
			if (isdefined (offsetz) && offsetz > 0 )
			{
				//add offset to origin
				origin = origin + (0,0,offsetz);
}
			if (isdefined (onground) && onground )
			{
				//check to ground move origin to ground + offest to ensure is above ground
			trace = undefined; 
			d = undefined; 

			FxOrigin = origin; 
			trace = bullettrace( FxOrigin, FxOrigin -( 0, 0, 100000 ), false, undefined ); 

			d = distance( FxOrigin, trace["position"] ); 
			
			origin =  trace["position"];
					
			}														
	   	soundloopemitter( alias, origin );			
		}
	}
}
snd_print_fx_id( fxid, type, ent )
{
/#
	if( GetDvarint( "debug_audio" ) > 0 )
	{
		printLn( "^5 ******* fxid; " + fxid + "^5 type; " + type );
	}	
#/			
}

debug_line_emitter()
{
	while( 1 )
	{
		/# 
		if( GetDvarint( "debug_audio" ) > 0 )
		{
			line( self.start, self.end, (0, 1, 0) );
			
			print3d( self.start, "START", (0.0, 0.8, 0.0), 1, 3, 1 );
			print3d( self.end, "END", (0.0, 0.8, 0.0), 1, 3, 1 );
			print3d( self.origin, self.script_sound, (0.0, 0.8, 0.0), 1, 3, 1 );
		}
		wait( 0.01 );
		#/
	}
}

move_sound_along_line()
{
	closest_dist = undefined;
	
	/#
	self thread debug_line_emitter();
	#/
	
	while( 1 )
	{
		self closest_point_on_line_to_point( getlocalclientpos( 0 ), self.start, self.end );

		if( IsDefined( self.fake_ent ) )
		{
			setfakeentorg( self.localClientNum, self.fake_ent, self.origin );
		}

		//Update the sound based on distance to the point
		closest_dist = DistanceSquared( getlocalclientpos( 0 ), self.origin );	

		if( closest_dist > 1024 * 1024 )
		{
			wait( 2 );
		}
		else if( closest_dist > 512 * 512 )
		{
			wait( 0.2 );
		}
		else
		{
			wait( 0.05 );
		}
	}
}

line_sound_player()
{
	if( IsDefined( self.script_looping ) )
	{
		self.fake_ent = spawnfakeent( self.localClientNum );
		setfakeentorg( self.localClientNum, self.fake_ent, self.origin );
		playloopsound( self.localClientNum, self.fake_ent, self.script_sound ); 
	}
	else
	{
		playsound( self.localClientNum, self.script_sound, self.origin );
	}
}

playloopat( localClientNum, aliasname, origin, fade )
{
	if( !IsDefined( fade ) )
		fade = 0;

	fake_ent = spawnfakeent( localClientNum );
	setfakeentorg( localClientNum, fake_ent, origin );
	playloopsound( localClientNum, fake_ent, aliasname, fade ); 
	return fake_ent;
}

soundwait( id )
{
	while( soundplaying( id ) )
	{
		wait( 0.1 );
	}
}


snd_final_killcam()
{
	while(true)
	{
		level waittill("fkcb");
		playsound(0, "mpl_final_kill_cam_sting");
		activateAmbientRoom(0, "final_kill_cam", 10 );
		level waittill("fkce");
		wait(.01);
		deactivateAmbientRoom(0, "final_kill_cam", 10 );
	}
}

