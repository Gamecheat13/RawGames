// Client side audio functionality

#include clientscripts\_utility;
#include clientscripts\_ambientpackage;

audio_init( localClientNum )
{
	if( localClientNum == 0 )
	{
		snd_snapshot_init();
		thread snd_snapshot_level_fadein();
		setglobalfutz("default", 0.0);


		startSoundRandoms( localClientNum );
		startSoundLoops();
		startLineEmitters();

		thread bump_trigger_start();
		thread init_audio_step_triggers();
		thread start_player_health_system();
		thread swimmingAudioAmbientSetup();
		thread waittoenableSwimming();
		thread waittodisableSwimming();
		thread oldManWoods();
		thread clientVoiceSetup();
		//thread berzerk_thread();
		thread globalWaterSoundCleanup();
		
		init_after_save_restore();
	}
}

clientVoiceSetup()
{
	//set up voice per clients using ST6 for now TODO add logic to get teams set up on client
	player = GetLocalPlayers()[0];
	
	player.teamClientPrefix = "vox_st";//taken from mp

	thread sndVoNotify( "playerbreathinsound", "sinper_hold" );
	thread sndVoNotify( "playerbreathoutsound", "sinper_exhale" );	
	thread sndVoNotify( "playerbreathgaspsound", "sinper_gasp" );
	
}

sndVoNotify( notifyString, dialog )
{
	player = GetLocalPlayers()[0];
	
	for(;;)
	{	
		player waittill ( notifyString );
		
		soundAlias = player.teamClientPrefix + RandomIntRange(0,3) + "_" + dialog;

		player playsound (0, soundAlias);
		
		//iprintlnbold (soundAlias);
	}
}

init_after_save_restore()
{
	level waittill( "save_restore" );
	level thread audio_init( 0 );
}

snd_snapshot_init()
{
	level._sndActiveSnapshot = "default";

	if(!isdefined(level._sndNextSnapshot))
	{
		level._sndNextSnapshot = "default";
	}

	setgroupsnapshot( level._sndActiveSnapshot );

	thread snd_snapshot_think();
	thread snd_snapshot_save();


}

snd_snapshot_save()
{
	level waittill( "save_restore" );
	setgroupsnapshot( level._sndActiveSnapshot );
}

snd_set_snapshot( state )
{
	level._sndNextSnapshot = state;

	/#println( "snd snapshot debug: set state '"+state+"'" );#/

	level notify( "new_bus" );
}

snd_snapshot_think()
{
	level endon( "save_restore" );

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

snd_snapshot_level_fadein()
{
	//level endon( "save_restore" );

	for(;;)
	{	    
		//PrintLn( "fade_tst: setting value to 1.0" );
		SetLevelFadeSnapshot( "cod_fadein", 1.0 ); 

		waitforclient( 0 );

		wait( 0.5 );

		snapshot_value = 1.0;
		while( snapshot_value > 0.0 )
		{
			snapshot_value -= 0.05;
			SetLevelFadeSnapshot( "cod_fadein", snapshot_value );
			//PrintLn( "fade_tst: value " + snapshot_value );
			wait( 0.02 );
		}

		//PrintLn( "fade_tst final: value " + snapshot_value + " setting to 0.0" );
		SetLevelFadeSnapshot( "cod_fadein", 0.0 );

		player = getlocalplayer(0);
		player waittill("respawn");
	}
}

soundRandom_Thread( localClientNum, randSound )
{
	level endon( "save_restore" );

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
			println( "*** Client : SR ( " + randSound.script_wait_min + " - " + randSound.script_wait_max + ")" );
		}
#/

		if(!IsDefined(randSound.script_scripted) && IsDefined(randSound.script_sound))
		{
			CreateSoundRandom(randSound.origin, randSound.script_sound, randSound.script_wait_min, randSound.script_wait_max);
			return;
		}
		
		// Only sound randoms with script_scripted placed on them will get this far.
		
		while( 1 )
		{
			wait( RandomFloatRange( randSound.script_wait_min, randSound.script_wait_max ) );

			if( !IsDefined( randSound.script_sound ) )
			{
				/#println( "ambient sound at "+randSound.origin+" has undefined script_sound" );#/
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
		/#println( "*** Client : Initialising random sounds - " + randoms.size + " emitters." );#/
		
		nScriptThreadedRandoms = 0;
		
		for( i = 0; i < randoms.size; i ++)
		{
			if(IsDefined(randoms[i].script_scripted))
			{
				nScriptThreadedRandoms ++;
			}
		}

		AllocateSoundRandoms(randoms.size - nScriptThreadedRandoms);
		
		for( i = 0; i < randoms.size; i++ )
		{
			thread soundRandom_Thread( localClientNum, randoms[i] );
		}
	}
	//else
	//{
	//	println( "*** Client : No random sounds." );
	//}
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

	level endon( "save_restore" );

	//println("starting loop loop");

	notifyName = "";
	assert( IsDefined( notifyName ) );

	if( IsDefined( self.script_string ) )
	{
		notifyName = self.script_string;
	}
	assert( IsDefined( notifyName ) );

	started = true;

	if( IsDefined( self.script_int) )
	{
		started = self.script_int != 0;
	}

	if( started )
	{
		soundloopemitter( self.script_sound, self.origin );
	}

	if( notifyName != "" )
	{
		/#println( "starting loop notify" );#/

		for(;;)
		{
			level waittill( notifyName );
			//iprintlnbold("got looper notify "+notifyName);
			if(started)
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
	level endon("save_restore");
	//println("starting line line");

	if( !IsDefined( self.target) )
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

	if( IsDefined( self.script_int) )
	{
		started = self.script_int != 0;
	}

	if( started )
	{
		soundLineEmitter( self.script_sound, self.origin, target.origin );
	}

	if( notifyName != "" )
	{
		/#println( "starting line notify" );#/

		for(;;)
		{
			level waittill( notifyName );
			//println("got line notify "+notifyName);
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
		//println( "*** Client : Initialising looper sounds - " + loopers.size + " emitters." );
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
	//else
	//{
	//	println( "*** Client : No looper sounds." );
	//}
}


startLineEmitters()
{
	lineEmitters = GetStructArray( "line_emitter", "script_label" );

	if( IsDefined( lineEmitters ) && lineEmitters.size > 0 )
	{
		delay = 0;
		//println( "*** Client : Initialising line emitter sounds - " + lineEmitters.size + " emitters." );
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
	//else
	//{
	//	println( "*** Client : No line emitter sounds." );
	//}
}


// TRIGGERS
init_audio_step_triggers()
{
	waitforclient( 0 ); // wait until the first snapshot has arrived

	trigs = GetEntArray( 0, "audio_step_trigger","targetname" );

	/#println( "Client : " + trigs.size + " audio_step_triggers." );#/
	array_thread( trigs, ::audio_step_trigger );
}

audio_step_trigger( trig )
{
	level endon("save_restore");
	for(;;)
	{
		self waittill( "trigger", trigPlayer );

		// set up the trigs
		self thread trigger_thread( trigPlayer, ::trig_enter_audio_step_trigger, ::trig_leave_audio_step_trigger );
	}
}

trig_enter_audio_step_trigger( trigPlayer )
{
	//iprintlnbold("enter");

	// trigPlayer is the player
	// self is the trigger.
	//iprintlnbold("Ent :" + trigPlayer getentitynumber() + " enters."+ self getentitynumber());

	// set the step script_label for use in _footstep
	if( Isdefined( self.script_label) )
	{
		trigPlayer.step_sound = self.script_label;
		trigPlayer SetStepTriggerSound( self.script_label );
	}
	if( Isdefined( self.script_sound ) && ( trigPlayer GetMovementType() == "sprint" ) )
	{
		// get real speed later
		const volume = 9;
		self playsound( 0, self.script_sound, self.origin, volume );
	}
}

trig_leave_audio_step_trigger(trigPlayer)
{
	if( Isdefined( self.script_noteworthy ) && ( trigPlayer GetMovementType() == "sprint" ) )
	{
		// get real speed later
		const volume = 9;
		self playsound( 0, self.script_noteworthy, self.origin, volume );
	}
	//iprintlnbold("exit");
	trigPlayer.step_sound = "null";
	trigPlayer ClearStepTriggerSound();
}

bump_trigger_start()
{
	//wait (.1);
	bump_trigs = GetEntArray( 0, "audio_bump_trigger", "targetname" );

	for( i = 0; i < bump_trigs.size; i++)
	{
		bump_trigs[i] thread thread_bump_trigger();	
	}
}

thread_bump_trigger()
{
	//iprintlnbold ("Found a trigger!");
	self thread bump_trigger_listener();
	if( !IsDefined( self.script_activated ) ) //Sets a flag to turn the trigger on or off
	{
		self.script_activated = 1;
	}

	for(;;)
	{
		self waittill ( "trigger", trigPlayer );

		self thread trigger_thread( trigPlayer, ::trig_enter_bump, ::trig_leave_bump );
	}	
}

trig_enter_bump( ent )
{
	// iPrintLnBold( "enter bump: " );
	volume = get_vol_from_speed( ent );

	if( IsDefined( self.script_sound ) && self.script_activated )
	{
		// script_noteworthy is the alias that will play if your speed is lower than the script_wait float
		if( IsDefined( self.script_noteworthy ) && ( self.script_wait > volume ) )
		{
			test_id = self playsound( 0, self.script_noteworthy,self.origin, volume );
		}

		if( !IsDefined( self.script_wait ) || ( self.script_wait <= volume ) )
		{
			test_id = self playsound( 0, self.script_sound, self.origin, volume );
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

// HEALTH (SNAPSHOT)
start_player_health_system()
{
	//PrintLn( "health_tst audio_init" );
	level endon( "save_restore" );
	wait( 1 );

	level setup_room_and_context();
	level.health_ambient_room_change = false;
	max_health = GetLocalClientMaxHealth( 0 ); 
	last_health = 0;

	health_snapshot = "cmn_dying_plr";
	
	level.tst_health = 0.0;
	level.tst_last_health = 0.0;
	level.tst_snap_value = 0;
	//JMself thread print_health();
	
		
	if( isdefined( level.playerHealthSystemOverride ) )
	{
		level thread [[level.playerHealthSystemOverride]](0);
		return;
	}

	
	SetHealthSnapshot( health_snapshot, 1);
	
	for( ;; )
	{
		wait ( 0.02 );
		
		health = GetLocalClientHealth( 0 );		
		
		if( health > 40 )
		{
			if( level.health_ambient_room_change )
			{
				setsoundcontext( "health", "full");
				playsound( 0, "chr_health_out", (0,0,0) );
				deactivateambientroom( 0, "health", 100 );
				level.health_ambient_room_change = false;
				level notify("pain_out");
			}
			
			health_scale = 0;
		}
		else
		{
			if( !level.health_ambient_room_change )
			{
				setsoundcontext( "health", "half");
				playsound( 0, "chr_health_in", (0,0,0) );
				activateambientroom( 0, "health", 100 );
				//snd_set_snapshot("cmn_pain_plr");
				//thread pain_pulse();
				level.health_ambient_room_change = true;
				
			}
			
			health_scale = 0 + ( health * ( 1 / 100 ) );
		}
		
		
		SetHealthSnapshot( health_snapshot, health_scale );
		//iprintlnbold (health);
		
		/#
		level.tst_health = health;
		level.tst_last_health = last_health;
		level.tst_snap_value = health_scale;
	
		last_health = health;
		#/
	}
	
}

setup_room_and_context()
{
	declareAmbientRoom( "health" );
	declareAmbientPackage( "health" );
		setAmbientRoomTone ("health","chr_health_loop", .25, 1.5);
		setAmbientRoomReverb ("health","shock_flashbang", 1, 1);
		setAmbientRoomContext( "health", "ringoff_plr", "indoor" );
		
	if( getlocalclienthealth( 0 ) > 40 )
	{
		setsoundcontext( "health", "full");
	}
	else
	{
		setsoundcontext( "health", "half");
	}
}


pain_pulse()
{
	level endon ("pain_out");
	
	while(1)
	{
		playsound(0, "chr_pain_pulse", (0,0,0) );
		wait(.3);
	}
}

/#
print_health()
{
	while( 1 )
	{
		wait( 0.5 );
		iPrintLnbold( "health_tst player last_health: " + level.tst_last_health + " player health: " + level.tst_health );
		iPrintLnbold( "health_tst value: " + level.tst_snap_value );
	}
}
#/

//this will do some mathmagic to scale to the min/max speed to min max volume
scale_speed(x1 ,x2 ,y1 ,y2 ,z )
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
	const min_speed = 21;
	const max_speed = 285;
	const max_vol = 1;
	min_vol = .1;

	speed = player getspeed();

	// hack for ai until getspeed returns correct speed	
	if(speed == 0 )
	{
		// iprintlnbold( "AI override" );
		speed = 175;
	}	

	//Ayers - Added in specifically to override low footstep volume during tunnel sequence in Creek
	//Can be used to keep volume up artificially during any sequence
	if( IsDefined( level.footstep_vol_override ) )  
	{
		min_vol = .5;
	}

	// make sure we are not getting negative vaules. may be unneeded
	abs_speed = abs( int( speed ) );
	volume = scale_speed( min_speed, max_speed, min_vol, max_vol, abs_speed );
	//iprintlnbold( "Volume: " + volume + " Speed: " + abs_speed );

	return volume;
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


playloopat( aliasname, origin )
{
	soundloopemitter ( aliasname, origin );
}
stoploopat (aliasname, origin )
{
	soundstoploopemitter (aliasname, origin );
}
/*
============= 
"Name: snd_add_exploder_alais( num, alias )
This function is used to play audio on exploders.
num(Int): Exploder num you want to add Alias tof
alias(String): Audio Alias
============= 
*/
snd_add_exploder_alias( num, alias )
{
	for ( i = 0; i < level.createFXent.size; i++ )
	{
		if (IsDefined(level.createFXent[i].v["exploder"]))
		{
			if( level.createFXent[i].v["exploder"] == num )
			{
				level.createFXent[i].v["soundalias"] = alias;
			}
		}
	}
}
/* 
============= 
"Name: snd_play_auto_fx( fxid, alias, offsetx, offsety, offsetz, onground, area, threshold, alias_override)"
This function is used to play audio on createfx ents.
Fxid(String): ID of the FX you want to play alias off
alias(String): Audio Alias
offsetx to offsetz(Int) : Offset from the origin of the fx where audio needs to be played.
onground(Bool) : do a trace ground to ensure audio play above ground.
Area(Int), Threshold(Int), alias_override(String) : used to determine if multiple fx of the same id is in the radius(area) of the fx origin, if the number of FX id in the same area exceeds
the THRESHOLD number ALIAS_OVERRIDE will be played at center of fx instead.
============= 
*/ 
snd_play_auto_fx( fxid, alias, offsetx, offsety, offsetz, onground, area, threshold, alias_override )
{




	if ( IsDefined( area ) )
	{
		assert( IsDefined( threshold ), "must pass in a threshold when area is defined");
		Assert( IsDefined( alias_override ), "must pass in alias_override when area is defined");

	}




	a_fx_id = [];      //  this one stores all of the fx ID we are looking for from the createfx array.
	a_fx_result_origin = [];    //this array stores the final fx origin which we will be playing audio off.


	//put all the FX id we are looking for into a_fx_id.
	for ( i = 0; i < level.createFXent.size; i++ )
	{
		if( level.createFXent[i].v["fxid"] == fxid )
		{
			if ( isdefined (area) )
			{
				level.createFXent[i].soundEntArea = area;

			}

			a_fx_id[ a_fx_id.size ] = level.createFXent[i];
		}
	}


	//if is not defined, skip the distance check.
	if( IsDefined( area ) )
	{
		for(i = 0; i < a_fx_id.size; i++ )
		{
			for(j =  i + 1; j < a_fx_id.size; j++)
			{

				//check for distances
				distance_square = DistanceSquared( a_fx_id[i].v["origin"], a_fx_id[j].v["origin"] ); 

			


				//if distance is shorter than the radius, we give them ID to identify origin as close together.
				if(  distance_square < area * area )
				{

					/#
						if( GetDvarInt( "debug_audio" ) > 0 )
						{
							//Debug Script, draw a line if 2 fx are within the area, and print the distance between them
							n_dist = Distance( a_fx_id[i].v["origin"], a_fx_id[j].v["origin"] ); 
							Line( a_fx_id[i].v["origin"],a_fx_id[j].v["origin"], (1, 1, 1), 1, false, 100000000);
							Print3d( ( ( a_fx_id[i].v["origin"][0] + a_fx_id[j].v["origin"][0] ) / 2, ( a_fx_id[i].v["origin"][1] + a_fx_id[j].v["origin"][1]) / 2, 10) , n_dist, (1, 1, 1), 1, 1, 1000000000);
						}
#/



						// give an adjacent id to index that is been tested.
						// set them to the same one if they are close to each other.
						if( IsDefined( a_fx_id[j].adjacent) && !IsDefined( a_fx_id[i].adjacent ) )
						{

							a_fx_id[i].adjacent = a_fx_id[j].adjacent;

						}
						else if( !IsDefined( a_fx_id[i].adjacent ) )
						{
							a_fx_id[i].adjacent = i;
							a_fx_id[j].adjacent = i;
						}
						else
						{
							a_fx_id[j].adjacent = a_fx_id[i].adjacent;
						}


				}
			}

			/#

				//print out fx_id's adjacent group tag on top of the origin,
				//if the origin doesn't belong to a group, then single is printed instead.

				if( GetDvarint( "debug_audio" ) > 0 )
				{

					if( IsDefined( a_fx_id[i].adjacent ) )
					{
						print3d(a_fx_id[i].v["origin"], a_fx_id[i].adjacent, (1, 1, 1), 1, 1, 100000000 );
					}
					else
					{
						print3d( a_fx_id[i].v["origin"], "single", (1, 1, 1), 1, 1, 100000000 );
					}
				}
			#/

		}


	
		size = a_fx_id.size;

		for( i = 0; i < size; i ++ )
		{


			//set up an temp_array to group all of the same adjacent fx origin in to one array.
			a_temp_array = [];


			//if index isn't defined, it's already either in result or temp array, so just skip.
			if( !IsDefined( a_fx_id[i] ))
			{
				continue;
			}


			//check to see if array index is part of adjacent group.
			//if so, add it to temp array, and set it to undefined in a_fx_id.
			//if it's not part of adjacent group, put in the final result array, and remove it from a_fx_id, then continue back to for loop on top
			if( !IsDefined( a_fx_id[i].adjacent ))
			{
				n_new_array_index = a_fx_result_origin.size;
				a_fx_result_origin[n_new_array_index] = a_fx_id[i];
				a_fx_result_origin[n_new_array_index].origin = a_fx_id[i].v["origin"];
				a_fx_id[i] = undefined;
				continue;
			}
			else
			{
				a_temp_array[a_temp_array.size] = a_fx_id[i];
				a_fx_id[i] = undefined;
			}



			//Array I is part of adjacent group, now we loop through the array again, to look for similar adjacent groups.
			//if an same adjacent group index is found, put in it the temp array and remove it from the fx_array_id.
			for(j = i + 1; j < size; j++ )
			{

				if( !IsDefined( a_fx_id[j] ))
					continue;

				if( IsDefined( a_fx_id[j].adjacent ) )
				{	
					if( a_fx_id[j].adjacent == a_temp_array[a_temp_array.size - 1].adjacent )
					{
						a_temp_array[a_temp_array.size] = a_fx_id[j];
						a_fx_id[j] = undefined;
					}
				}

			}

			//check to see if size of adjacent fx array exceeds the threshold that was passed in.
			//if is greater than we going to create a new origin that is at center of the all fx origins and put it in to the final result array.
			//if not, we put all the fx origin back into the final result array without doing with it.
			if( a_temp_array.size > threshold )
			{
				x = 0;
				y = 0;
				z = 0;

				for(k = 0; k < a_temp_array.size; k ++ )
				{
					x += a_temp_array[k].v["origin"][0];
					y += a_temp_array[k].v["origin"][1];
					z += a_temp_array[k].v["origin"][2];
				}

				x = x / a_temp_array.size;
				y = y / a_temp_array.size;
				z = z / a_temp_array.size;

				n_new_array_index = a_fx_result_origin.size;
				a_fx_result_origin[n_new_array_index] = SpawnStruct();
				a_fx_result_origin[n_new_array_index].origin = (x, y, z);	
				a_fx_result_origin[n_new_array_index].alias_override = true;


			}
			else
			{
				for( k = 0; k < a_temp_array.size; k++ )
				{
					n_new_array_index = a_fx_result_origin.size;
					a_fx_result_origin[n_new_array_index] = SpawnStruct();
					a_fx_result_origin[n_new_array_index].origin = a_temp_array[k].v["origin"];
				}
			}

		}

	}
	else
	{
		for( i = 0 ; i < a_fx_id.size; i++ )
		{

			n_new_array_index = a_fx_result_origin.size;

			a_fx_result_origin[n_new_array_index] = a_fx_id[i];
			a_fx_result_origin[n_new_array_index].origin = a_fx_id[i].v["origin"];
		}



	}


	//add offset to the fx origin and play audio base on where alias_override is on or off.
	for( i = 0; i < a_fx_result_origin.size; i++ )
	{
		v_origin = a_fx_result_origin[i].origin;

		if ( IsDefined (offsetx) && offsetx != 0 )
		{
			//add offset to origin
			v_origin = v_origin + (offsetx,0,0);
		}
		if ( IsDefined (offsety) && offsety != 0 )
		{
			//add offset to origin
			v_origin = v_origin + (0,offsety,0);
		}
		if ( IsDefined (offsetz) && offsetz != 0 )
		{
			//add offset to origin
			v_origin = v_origin + (0,0,offsetz);
		}
		if ( IsDefined ( onground ) && onground )
		{
			//check to ground move origin to ground + offest to ensure is above ground
			trace = undefined; 
			d = undefined; 

			v_FxOrigin = v_origin; 
			trace = BulletTrace( v_FxOrigin, v_FxOrigin -( 0, 0, 100000 ), false, undefined ); 

			d = Distance( v_FxOrigin, trace["position"] ); 

			v_origin =  trace["position"];

		}	


		if( !IsDefined ( a_fx_result_origin[i].alias_override ) )
		{
			SoundLoopEmitter( alias, v_origin );
		}
		else
		{
			SoundLoopEmitter( alias_override, v_origin );

		}
	}


}


snd_delete_auto_fx( fxid )
{
	for( i = 0; i < level.createFXent.size; i++ )
	{
		if( level.createFXent[i].v["fxid"] == fxid && IsDefined( level.createFXent[i].soundEnt ) )
		{
			deletefakeent(0, level.createFXent[i].soundEnt);
			level.createFXent[i].soundEnt = undefined;
		}
	}
}
/#
snd_print_fx_id( fxid, type, ent )
{
	printLn( "^5 ******* fxid; " + fxid + "^5 type; " + type );
}

debug_line_emitter()
{
	while( 1 )
	{
			if( GetDvarint( "debug_audio" ) > 0 )
			{
				line( self.start, self.end, (0, 1, 0) );

				print3d( self.start, "START", (0.0, 0.8, 0.0), 1, 3, 1 );
				print3d( self.end, "END", (0.0, 0.8, 0.0), 1, 3, 1 );
				print3d( self.origin, self.script_sound, (0.0, 0.8, 0.0), 1, 3, 1 );
			}
			wait( 0.01 );
	}
}
#/
	
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

//berzerk_thread()
//{
//	ent = spawnfakeent( 0) ;
//	for(;;)
//	{
//		level waittill( "berzerk_audio_on" );
//		playloopsound( 0, ent, "uin_berzerker_loop", 1 );
//		level waittill( "berzerk_audio_off" );
//		stoploopsound( 0, ent, 1 );
//	}
//}

soundwait( id )
{
	while( soundplaying( id ) )
	{
		wait( 0.1 );
	}
}

/* 
============= 
SWIMMING: Moved to common, as we need wading/swimming sounds sometimes when _swimming.csc is not active
============= 
*/ 
waittoenableSwimming()
{
	while(1)
	{
		level waittill( "aS_on" );
		level thread enableSwimmingAudio();
	}
}
waittodisableSwimming()
{
	while(1)
	{
		level waittill( "aS_off" );
		level thread disableSwimmingAudio();
	}
}
enableSwimmingAudio()
{
	level thread enableSwimmingAudioOnPlayer();
}
//SELF == Player or AI
enableSwimmingAudioOnPlayer()
{
	player = getlocalplayers()[0];
	player thread swimmingAudioDepthCheck();
	//player thread swimmingAudioLoopPlr();
	player thread swimmingAudioDiveSurface();
}
disableSwimmingAudio()
{
	level notify( "disableSwimmingAudio" );
	deactivateAmbientRoom( 0, "underwater", 50 );
}
swimmingAudioDepthCheck()
{
	self notify( "aS_redundancy_depth" );
	self endon( "aS_redundancy_depth" );
	self endon( "death" );
	level endon( "disableSwimmingAudio" );
	
	self._audioSwim_dryland = true;
	self._audioSwim_underwater = false;
	
	while( isdefined( self ) )
	{
		depth = swimmingAudioGetDepth_Eye();
		foot = swimmingAudioGetDepth_Foot() + 12;
		
		if( foot < 0 )
		{
			if( self._audioSwim_dryland == true )
			{
				self._audioSwim_dryland = false;
				self notify( "aS_wetland" );
			}
		}
		else if( self._audioSwim_dryland == false )
		{
			self._audioSwim_dryland = true;
			self notify( "aS_dryland" );
		}
		
		if( depth < 0 )
		{
			if( self._audioSwim_underwater == false )
			{
				self._audioSwim_underwater = true;
				self notify( "aS_underwater" );
			}
		}
		else if( self._audioSwim_underwater == true )
		{
			self._audioSwim_underwater = false;
			self notify( "aS_surface" );
		}
		
		wait(.25);
	}
}
swimmingAudioGetDepth_Eye()
{
	if( !IsDefined( self ) )
	{
		return;
	}

	eye_height = self get_eye()[2];
	water_height = GetWaterHeight( self.origin );
	return (eye_height - water_height);
}
swimmingAudioGetDepth_Foot()
{
	if( !IsDefined( self ) )
	{
		return;
	}

	foot_height = self.origin[2];
	water_height = GetWaterHeight( self.origin );
	return (foot_height - water_height);
}
/*
swimmingAudioLoopPlr()
{
	self endon( "death" );
	self endon( "entityshutdown" );
	level endon( "disableSwimmingAudio" );
	
	self notify( "aS_redundancy_loop" );
	self endon( "aS_redundancy_loop" );
	
	while(1)
	{
		while( self._audioSwim_dryland )
		{
			wait( 0.25 );
		}
		
		ents = self swimmingAudioLoopSpawnEnts();
		
		while( !self._audioSwim_dryland && IsDefined( ents ) && ents.size > 1 )
		{
			if( !IsDefined( self ) )
			{
				return;
			}
			
			if( !isdefined( ents ) )
			{
				break;
			}
			
			while( self._audioSwim_underwater && isdefined( ents[0] ) && isdefined( ents[1] ) )
			{
				ents[0] StopLoopSound( 1 );
				ents[1] StopLoopSound( 1 );
				wait(.25);
			}
			
			if( self GetSpeed() > 50 && isdefined( ents[0] ) && isdefined( ents[1] ) )
			{
				ents[1] StopLoopSound( 1 );
				ents[0] PlayLoopSound( "chr_swimming_swim_loop_plr", 1 );
			}
			else if( isdefined( ents[0] ) && isdefined( ents[1] ) )
			{
				ents[0] StopLoopSound( 1 );
				ents[1] PlayLoopSound( "chr_swimming_float_loop_plr", 1 );
			}	
			wait(.25);
		}
		wait(.25);
	}
}
swimmingAudioLoopSpawnEnts()
{
	ents = [];
	ents[0] = Spawn( 0, (0,0,0), "script_origin" );
	ents[1] = Spawn( 0, (0,0,0), "script_origin" );
	
	if( self IsPLayer() == false )
	{
		ents[0] LinkTo( self, "tag_origin" );
		ents[1] LinkTo( self, "tag_origin" );
	}
	
	self thread swimmingAudio_DeleteEntsSelf( ents );
	self thread swimmingAudio_DeleteEntsLevel( ents );
	return ents;
}
swimmingAudio_DeleteEntsSelf( array )
{
	level endon( "save_restore" );
	level endon( "disableSwimmingAudio" );
	
	self waittill_any( "aS_dryland", "death" );
	
	array[0] stoploopsound( 1 );
	array[1] stoploopsound( 1 );
	wait(1);
	
	for(i=0;i<array.size;i++)
	{
		array[i] delete();
	}
	
	array = undefined;
}
swimmingAudio_DeleteEntsLevel( array )
{
	self endon( "aS_dryland" );
	self endon( "death" );
	
	level waittill_any( "save_restore", "disableSwimmingAudio" );
	
	if( !isdefined( array ) )
		return;
	
	for(i=0;i<array.size;i++)
	{
		array[i] delete();
	}

	array = undefined;
}
*/
swimmingAudioDiveSurface()
{
	self endon( "death" );
	level endon( "disableSwimmingAudio" );
	
	self notify( "aS_redundancy_dive" );
	self endon( "aS_redundancy_dive" );
	
	while (true)
	{
		self waittill( "aS_underwater" );
		
		activateAmbientRoom( 0, "underwater", 50 );
		snd_set_snapshot( "spl_cmn_underwater" );
		self PlaySound( 0, "chr_swimming_dive_start_plr" ); //Diving Sound
		self PlaySound( 0, "chr_ear_fill" );
		    	
		self waittill( "aS_surface" );
		
		deactivateAmbientRoom( 0, "underwater", 50 );
		snd_set_snapshot( "default" );
		//self PlaySound( 0, self._swimming.surface_vox ); //Surfacing Vox
		self PlaySound( 0, "chr_swimming_surface_plr" ); //Surfacing Splashes
		self PlaySound( 0, "chr_ear_drain" );
	}
}
swimmingAudioAmbientSetup()
{
	declareAmbientRoom( "underwater" );
 	setAmbientRoomTone( "underwater", "chr_swimming_underwater_amb", .25, .1 );
 	setAmbientRoomReverb ("underwater","gen_underwater", 1, 1, 1 );
}

/* 
============= 
OLD MAN WOODS: Moved to common, handles turning on snapshots and changing ambience across multiple levels
============= 
*/ 
oldManWoods()
{
	level thread oldManWoodsAmbientPackage();
	level thread oldManWoodsSnapshot_ON();
	level thread oldManWoodsSnapshot_OFF();
}
oldManWoodsAmbientPackage()
{
	declareAmbientRoom( "omw_room" );
	setAmbientRoomTone ("omw_room","amb_omw_hospital__bg", 2, 2);
	setAmbientRoomReverb ("omw_room","cmn_omw", 1, 1);
	setAmbientRoomContext( "omw_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "omw_room" );
}
oldManWoodsSnapshot_ON()
{
	while(1)
	{
		level waittill( "omw_on" );
		snd_set_snapshot( "spl_oldmanwoods" );
		activateambientpackage( 0, "omw_room", 100 );
		activateambientroom( 0, "omw_room", 100 );
	}
}
oldManWoodsSnapshot_OFF( string, snapshot )
{
	while(1)
	{
		level waittill( "omw_off" );
		snd_set_snapshot( "default" );
		deactivateambientpackage( 0, "omw_room", 100 );
		deactivateambientroom( 0, "omw_room", 100 );
	}
}

rpgWhizbyWatcher( rpg )
{
	self endon( "entityshutdown" );
	self endon( "death" );
	level endon("save_restore");
		
	//player = GetLocalPlayers()[0];
	
	wait (.2);
	
	self thread projectileWhizbyDistanceCheck ( self, "wpn_rpg_whizby", 300);

}
projectileWhizbyDistanceCheck( projectile, alais, distance)
{
	self endon( "entityshutdown" );
	self endon( "death" );
	level endon("save_restore");
	
	players = level.localPlayers;

	while(IsDefined(projectile))
	{
		projectileDistance = DistanceSquared( projectile.origin, players[0].origin);
		
		//iprintlnbold (projectileDistance);
		
		if( projectileDistance <= distance * distance )
		{
			projectile playsound (0, alais);
			return;
		//	iprintlnbold ("BY!!!!!");
		}
		wait (.2);	
	}
}

//Plays a fire loop on a 4-wheeled vehicle when they die
play_death_fire_loop()
{
	level endon( "save_restore" );
	
	self waittill( "death" );
	playloopat( "veh_onfire_fire_loop", self.origin );
	
	self thread stop_death_fire_loop( self.origin );
}
stop_death_fire_loop( origin )
{
	level endon("save_restore");
	self waittill( "entity_shutdown" );
	stoploopat( "veh_onfire_fire_loop", origin );
}
waterSoundCleanup ( waterSoundEnt )
{
	level endon("save_restore");
	self waittill_any ("death", "entityshutdown", "exit_vehicle");
	waterSoundEnt stoploopsound();
	waterSoundEnt delete ();
	ArrayRemoveValue(level.waterSoundEnt,waterSoundEnt);
}

globalWaterSoundCleanup()
{
	if (!IsDefined(level.waterSoundEnt))
	{
		level.waterSoundEnt=[];
	}
	
	while (1)
	{
		level waittill("save_restore");
		for (i=0;i<level.waterSoundEnt.size;i++)
		{
			level.waterSoundEnt[i] stoploopsound();
			level.waterSoundEnt[i] delete();
			level.waterSoundEnt[i]=undefined;
		}
	}
}

play_water_loop( loop, splash, maxspeed )
{
	self endon( "death" );
	self endon( "entityshutdown" );	
	self endon( "exit_vehicle" );	
	level endon("save_restore");

// for blair debug of setsoundvolume when starting loopsound outside of loop
//	return;
	
	newSoundEnt = spawn( 0, self.origin, "script_origin" );
	newSoundEnt linkto( self, "tag_origin", (0,100,100)  ); //veh_fire_scout_tech_drone veh_soct_water_loop
	level.waterSoundEnt[level.waterSoundEnt.size]=newSoundEnt;
	
	volume = 0.0;

	id = newSoundEnt PlayLoopSound( loop );

	setSoundVolume( id , volume );	
	
	self thread waterSoundCleanup (newSoundEnt);
	
	while ( 1 )
	{
		if ( !IsDefined( self ) )
		{
			return;
		}

		wait .1;
		
		//id = waterSoundEnt PlayLoopSound( loop );
		
		setsoundvolumerate( id, 0.75 );

		self.cur_speed = abs(self getspeed() / 17.6);
		
		volume = scale_speed( 0, maxspeed, 0.0, 1.0, self.cur_speed );
		
		if ( self IsVehicleInWater() )
		{
			if (IsDefined (self.shouldPlaySplash))
			{
				self playsound (0, splash, self.origin, volume);
				self.shouldPlaySplash = undefined;					
			}
			//self.cur_speed = self getspeed() / 17.6;
			//volume = scale_speed( 0, 50, 0.0, 1.0, self.cur_speed );
			setSoundVolume ( id, volume );	
		}
		else
		{
			setSoundVolume ( id, 0 );
			self.shouldPlaySplash = true;			
	
		}

		//print3d( self.origin + (0,0,-100) + (AnglesToForward (self.angles) * 2000 ), "SPEED- " + self.cur_speed,  (0.0, 0.8, 0.0), 1, 3, 1 );
		//print3d( self.origin + (AnglesToForward (self.angles) * 2000 ), "Volume- " + volume,  (0.0, 0.8, 0.0), 1, 3, 1 );

	}
}
