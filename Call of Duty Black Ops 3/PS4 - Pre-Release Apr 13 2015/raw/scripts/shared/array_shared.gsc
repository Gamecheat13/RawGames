#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace audio;

function autoexec __init__sytem__() {     system::register("audio",&__init__,undefined,undefined);    }

// Client side audio functionality
	//TODO T7 function name pass
	
function __init__()
{
	callback::on_localclient_connect( &player_init );
	callback::on_spawned( &player_spawn );
	level thread register_clientfields();
	level thread sndKillcam();
	level thread SetPfxContext();
	
	//Setting Default Contexts
	if( SessionModeIsCampaignGame() )
	{
		setsoundcontext ("water", "over");
		//setsoundcontext ("drivableveh","3rdperson");		
	}
	
	setsoundcontext ("health", "full");
	setsoundcontext ("foley", "normal");
	setsoundcontext( "plr_impact", "" );
	setsoundcontext ("boot", "dry");
}

function register_clientfields()
{
	clientfield::register( "world", "sndPrematch", 1, 1, "int", &audio::sndPrematch, true, !true );
	clientfield::register( "world", "sndFoleyContext", 1, 1, "int", &audio::sndFoleyContext, !true, !true );
	clientfield::register( "scriptmover", "sndRattle", 1, 1, "int", &audio::sndRattle_Server, true, !true );
	clientfield::register( "toplayer", "sndMelee", 1, 1, "int", &audio::weapon_butt_sounds, true, true );
	clientfield::register( "vehicle", "sndSwitchVehicleContext", 1, 3, "int", &audio::sndSwitchVehicleContext, !true, !true );
}

function player_spawn( localClientNum )
{
/#
	if( GetDvarint( "debug_entityshutdown" ) == 1 )
	{
		if ( !isdefined( level.countPlayerSpawned ) )
		{
			level.countPlayerSpawned = 0;
		}
		iprintlnbold( "D7 spawn: " + level.countPlayerSpawned + " " + self.name  );
		Println( "D7 spawn: " + level.countPlayerSpawned );
		self thread debug_entity_shutdown_waittill( localClientNum, level.countPlayerSpawned );
		self thread debug_entity_shutdown_loop( localClientNum, level.countPlayerSpawned );
		level.countPlayerSpawned++;
	}
#/
	
	if ( self isLocalPlayer() == false )
	{
		return;
	}		
	
	if ( IsSplitScreenHost( localClientNum ) )
	{
		self thread snd_underwater( localClientNum );
		self thread clientVoiceSetup();
	}

	self setsoundentcontext ("boot", "dry");
	
	if( SessionModeIsCampaignGame() )
	{
		snd_set_snapshot( "default" );
	}
}

function player_init( localClientNum )
{
	snd_snapshot_init();
	startSoundRandoms( localClientNum );
	startSoundLoops();
	startLineEmitters();
	startRattles();

	level thread bump_trigger_start(localClientNum);
	level thread init_audio_triggers(localClientNum);
	level thread sndRattle_Grenade_Client();
//	level thread set_sound_context_defaults();
}

/#

function debug_entity_shutdown_waittill( localClientNum, count ) 
{
	self waittill("entityshutdown");
	iprintlnbold( "D7 entityshutdown: " + count );
	Println( "D7 entityshutdown: " + count );
}

function debug_entity_shutdown_loop( localClientNum, count )
{
	self endon( "entityshutdown" );
	for(;;)
	{
		iprintlnbold( "D7 running: " + count + " " + self.name );
		Println( "D7 running: " + count + " " + self.name );
		DebugStar( self.origin, 50, (0.9, 0.7,0.6 ) );
			
		wait( 1 );
	}
}

#/



function sndDoubleJump_Watcher()
{
	self endon("entityshutdown");
	while(1)
	{
		self waittill( "doublejump_start" );

		trace = tracepoint( self.origin, self.origin - ( 0, 0, 100000 ) );
		trace_surface_type = trace["surfacetype"];
		trace_origin = trace["position"];

		if( !isdefined( trace ) || !isdefined( trace_origin ) )
			continue; 

		if( !isdefined( trace_surface_type ) )
			trace_surface_type = "default";
		
		playsound( 0, "veh_jetpack_surface_" + trace_surface_type, trace_origin );
	}	
}

function clientVoiceSetup()
{
	self endon("entityshutdown");
	if ( isdefined(level.clientVoiceSetup) )
	{
		[[level.clientVoiceSetup]]();
		return;
	}

	//set up voice per clients using ST6 for now TODO add logic to get teams set up on client
	self.teamClientPrefix = "vox_gen";

	self thread sndVoNotify( "playerbreathinsound", "sinper_hold" );
	self thread sndVoNotify( "playerbreathoutsound", "sinper_exhale" );	
	self thread sndVoNotify( "playerbreathgaspsound", "sinper_gasp" );
	
}

function sndVoNotify( notifyString, dialog )
{
	self endon("entityshutdown");
	for(;;)
	{	
		self waittill ( notifyString );
		
		soundAlias = self.teamClientPrefix + "_" + dialog;

		self playsound (0, soundAlias);
	}
}

function snd_snapshot_init()
{
	level._sndActiveSnapshot = "default";
	level._sndNextSnapshot = "default";
	
	if( SessionModeIsCampaignGame() )
	{
		level._sndActiveSnapshot = "cmn_level_start";
		level._sndNextSnapshot = "cmn_level_start";
	}
	
	setgroupsnapshot( level._sndActiveSnapshot );

	thread snd_snapshot_think();
}

function snd_set_snapshot(state)
{
	level._sndNextSnapshot = state;

/#	println( "snd duck debug: set state '"+state+"'" );	#/
	
	level notify( "new_bus" );
}

function snd_snapshot_think()
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
		
		assert( isdefined( level._sndNextSnapshot ) );
		assert( isdefined( level._sndActiveSnapshot ) );

		setgroupsnapshot( level._sndNextSnapshot );

		level._sndActiveSnapshot = level._sndNextSnapshot;
	}
}

function soundRandom_Thread( localClientNum, randSound )
{
	if( !isdefined( randSound.script_wait_min ) )
	{
		randSound.script_wait_min = 1;
	}
	if( !isdefined( randSound.script_wait_max ) )
	{
		randSound.script_wait_max = 3;
	}
	
	notify_name = undefined;
	if( isdefined( randSound.script_string ) )
	{
		notify_name = randSound.script_string;
	}

	
	if(!isdefined(notify_name) && isdefined(randSound.script_sound))
	{
		CreateSoundRandom(randSound.origin, randSound.script_sound, randSound.script_wait_min, randSound.script_wait_max);
		return;
	}
	
	// Only sound randoms with script_scripted placed on them will get this far.

	randSound.playing = true;
	level thread soundRandom_NotifyWait(notify_name, randSound);
	
	while( 1 )
	{
		wait( RandomFloatRange( randSound.script_wait_min, randSound.script_wait_max ) );
		
		if( isdefined( randSound.script_sound ) && ( isdefined( randSound.playing ) && randSound.playing ) )
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
function soundRandom_NotifyWait(notify_name,randSound)
{
	while(1)
	{
		level waittill( notify_name );
		if( ( isdefined( randSound.playing ) && randSound.playing ) )
			randSound.playing = false;
		else
			randSound.playing = true;
	}
}

function startSoundRandoms( localClientNum )
{
	randoms = struct::get_array( "random", "script_label" );
	
	if( isdefined( randoms ) && randoms.size > 0 )
	{
		
		nScriptThreadedRandoms = 0;
		
		for( i = 0; i < randoms.size; i ++)
		{
			if(isdefined(randoms[i].script_scripted))
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
}

//self is looper struct
function soundLoopThink()
{
	if( !isdefined( self.script_sound ) )
	{
		return;
	} 
	
	if( !isdefined( self.origin ) )
	{
		return;
	}

	
	notifyName = "";
	assert( isdefined( notifyName ) );
	
	if( isdefined( self.script_string ) )
	{
		notifyName = self.script_string;
	}
	assert( isdefined( notifyName ) );
	
	started = true;
	
	if( isdefined( self.script_int ) )
	{
		started = self.script_int != 0;
	}
	
	if( started )
	{
		soundloopemitter( self.script_sound, self.origin );
	}
	
	if( notifyName != "" )
	{
		for(;;)
		{
			level waittill( notifyName );

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
}

//self is line struct
function soundLineThink()
{
	if(!isdefined( self.target) )
	{
		return;
	}
	
	target = struct::get( self.target, "targetname" );
	
	if( !isdefined( target) )
	{
		return;
	}
	
	notifyName = "";
	
	if( isdefined( self.script_string ) )
	{
		notifyName = self.script_string;
	}
	
	started = true;
	
	if( isdefined( self.script_int ) )
	{
		started = self.script_int != 0;
	}
	
	if( started )
	{
		soundLineEmitter( self.script_sound, self.origin, target.origin );
	}
	
	if( notifyName != "" )
	{
		for(;;)
		{
			level waittill( notifyName );

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
}

function startSoundLoops()
{
	loopers = struct::get_array( "looper", "script_label" );
	
	if( isdefined( loopers ) && loopers.size > 0 )
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

function startLineEmitters()
{
	lineEmitters = struct::get_array( "line_emitter", "script_label" );
	
	if( isdefined( lineEmitters ) && lineEmitters.size > 0 )
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

function startRattles()
{
	rattles = struct::get_array( "sound_rattle", "script_label" );


	
	if( isdefined( rattles ))
	{
		/#
		println( "found "+rattles.size+" rattles" );
		#/

		delay = 0;

		for( i = 0; i < rattles.size; i++ )
		{
			soundrattlesetup(rattles[i].script_sound, rattles[i].origin);

			delay += 1;

			if( delay % 20 == 0 ) //don't send more than 20 a frame
			{
				wait( 0.01 );
			}
		}
	}
	
}

// TRIGGERS
function init_audio_triggers(localClientNum)
{
	util::waitforclient( localClientNum ); // wait until the first snapshot has arrived
	
	stepTrigs = GetEntArray( localClientNum, "audio_step_trigger","targetname" );
	materialTrigs = GetEntArray( localClientNum, "audio_material_trigger","targetname" );
/#
	if( GetDvarint( "debug_audio" ) > 0 )
	{
		println( "Client : " + stepTrigs.size + " audio_step_triggers." );
		println( "Client : " + materialTrigs.size + " audio_material_triggers." );
	}	

#/			
	array::thread_all( stepTrigs,&audio_step_trigger, localClientNum );
	array::thread_all( materialTrigs,&audio_material_trigger, localClientNum );
}

function audio_step_trigger( localClientNum )
{
	self._localClientNum = localClientNum;
	for(;;)
	{
		self waittill( "trigger", trigPlayer );

		// set up the trigs
		self thread trigger::function_thread( trigPlayer,&trig_enter_audio_step_trigger,&trig_leave_audio_step_trigger );
	} 
}

function audio_material_trigger( trig )
{
	for(;;)
	{
		self waittill( "trigger", trigPlayer );

		// set up the trigs
		self thread trigger::function_thread( trigPlayer,&trig_enter_audio_material_trigger,&trig_leave_audio_material_trigger );
	}
}

function trig_enter_audio_material_trigger( player )
{	
	if( !isdefined( player.inMaterialOverrideTrigger ) )
	{
		player.inMaterialOverrideTrigger = 0;
	}
	if( isdefined( self.script_label ) )
	{
		player.inMaterialOverrideTrigger++;
		player.audioMaterialOverride = self.script_label;
		
		player SetMaterialOverride(self.script_label);
	}
}

function trig_leave_audio_material_trigger( player )
{
	if( isdefined( self.script_label ) )
	{
		player.inMaterialOverrideTrigger--;
/#
		assert( player.inMaterialOverrideTrigger >= 0 );
#/
		if ( player.inMaterialOverrideTrigger <= 0 )
		{
			player.audioMaterialOverride = undefined;	
			player.inMaterialOverrideTrigger = 0;
			
			player ClearMaterialOverride();

		}
	}
}

function trig_enter_audio_step_trigger( trigPlayer )
{
	localClientNum = self._localClientNum;
	
	if( !isdefined( trigPlayer.inStepTrigger ) )
	{
		trigPlayer.inStepTrigger = 0;
	}
	
	suffix = "_npc";
	if( trigPlayer IsLocalPlayer() )
	{
		suffix = "_plr";
	}
	
	// trigPlayer is the player touching trigger. self is the trigger.
	if( isdefined( self.script_label) )
	{
		trigPlayer.step_sound = self.script_label;
		trigPlayer.inStepTrigger = trigPlayer.inStepTrigger + 1; 
		trigPlayer SetStepTriggerSound(self.script_label + suffix);
	}
	if( isdefined( self.script_sound ) && ( trigPlayer GetMovementType() == "sprint" ) )
	{
		volume = get_vol_from_speed (trigPlayer);

		trigPlayer playsound( localClientNum, self.script_sound + suffix, self.origin, volume );
	}
}

function trig_leave_audio_step_trigger(trigPlayer)
{
	localClientNum = self._localClientNum;
	
	suffix = "_npc";
	if( trigPlayer IsLocalPlayer() )
	{
		suffix = "_plr";
	}
	
	if( isdefined( self.script_noteworthy ) && ( trigPlayer GetMovementType() == "sprint" ) )
	{
		volume = get_vol_from_speed (trigPlayer);
		trigPlayer playsound( localClientNum, self.script_noteworthy + suffix, self.origin, volume );
	}
	if ( isdefined( self.script_label) )
	{
		trigPlayer.inStepTrigger = trigPlayer.inStepTrigger - 1; 
	}
	if (trigPlayer.inStepTrigger < 0 )
	{
	/#	println("AUDIO WARNING InStepTrigger less than 0. Should never be. setting to 0" );		#/
		trigPlayer.inStepTrigger = 0;
	
	}	
	if (trigPlayer.inStepTrigger == 0)
	{
		trigPlayer.step_sound = "none";
		trigPlayer ClearStepTriggerSound();
	}
}

function bump_trigger_start( localClientNum )
{
	bump_trigs = GetEntArray( localClientNum, "audio_bump_trigger", "targetname" );
	
	for( i = 0; i < bump_trigs.size; i++)
	{
		bump_trigs[i] thread thread_bump_trigger(localClientNum);	
	}
}

function thread_bump_trigger(localClientNum)
{
	self thread bump_trigger_listener();
	if( !isdefined( self.script_activated ) ) //Sets a flag to turn the trigger on or off
	{
		self.script_activated = 1;
	}
	self._localClientNum = localClientNum;
	for(;;)
	{
		self waittill ( "trigger", trigPlayer );
		
		self thread trigger::function_thread( trigPlayer,&trig_enter_bump,&trig_leave_bump );
	}	
}

function trig_enter_bump( ent )
{
	localClientNum = self._localClientNum;
	volume = get_vol_from_speed( ent );

	if( !SessionModeIsZombiesGame() )
	{
		if ( ent HasPerk( localClientNum, "specialty_quieter" ))
		{
			volume = volume / 2;
		}	
	}
	if( isdefined( self.script_sound ) && (self.script_activated))
	{
		// script_noteworthy is the alias that will play if your speed is lower than the script_wait float
		if( isdefined( self.script_noteworthy ) && ( self.script_wait > volume ) )
		{
			test_id = ent playsound( localClientNum, self.script_noteworthy,self.origin, volume );
		}
		if( isdefined( self.script_parameters ))	
		{	
			test_id = ent playsound( localClientNum, self.script_parameters, self.origin, volume );	
		}
		if( !isdefined( self.script_wait ) || ( self.script_wait <= volume ) )
		{
			test_id = ent playsound( localClientNum, self.script_sound, self.origin, volume );
		}
	}
	if	( isdefined( self.script_location ) && (self.script_activated))
	{
			ent thread mantle_wait(self.script_location, localClientNum);		
	}
}

Function mantle_wait( alias, localClientNum )
{

	self endon ("death");
	self endon ("left_mantle");
	
	self waittill ("traversesound");
	self playsound ( localClientNum, alias, self.origin, 1 );
	
}
function trig_leave_bump( ent )
{
	wait (1);
	ent notify ( "left_mantle");
}

function bump_trigger_listener() //This will deactivate the trigger on a level notify if its stored on the trigger
{
	//Store End-On conditions in script_label so you can turn off the bump trigger if a condition is met
	if( isdefined( self.script_label ) )
	{
		level waittill( self.script_label );
		self.script_activated = 0;
	}
}

//this will do some mathmagic to scale to the min/max speed to min max volume
function scale_speed( x1, x2, y1, y2, z )
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

function get_vol_from_speed( player )
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
		speed = 175;
	}	

	// make sure we are not getting negative vaules. may be unneeded
	abs_speed = absolute_value( int( speed ) );
	volume = scale_speed( min_speed, max_speed, min_vol, max_vol, abs_speed );

	return volume;
}

function absolute_value( fowd )
{
	if( fowd < 0 )
		return (fowd*-1);
	else
		return fowd;
}

// self is the script origin mover
function closest_point_on_line_to_point( Point, LineStart, LineEnd )
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
/* 
============= 
"Name: snd_play_auto_fx( fxid, alias, offsetx, offsety, offsetz, onground, area, threshold, alias_override)"
This function is used to play audio on createfx ents.
function Fxid(String): ID of the FX you want to play alias off
function alias(String): Audio Alias
function offsetx to offsetz(Int) : Offset from the origin of the fx where audio needs to be played.
function onground(Bool) : do a trace ground to ensure audio play above ground.
function Area(Int), Threshold(Int), alias_override(String) : used to determine if multiple fx of the same id is in the radius(area) of the fx origin, if the number of FX id in the same area exceeds
the THRESHOLD number ALIAS_OVERRIDE will be played at center of fx instead.
============= 
*/ 
function snd_play_auto_fx( fxid, alias, offsetx, offsety, offsetz, onground, area, threshold, alias_override )
{
	SoundPlayAutoFX( fxid, alias, offsetx, offsety, offsetz, onground, area, threshold, alias_override );
}

function snd_print_fx_id( fxid, type, ent )
{
/#
	if( GetDvarint( "debug_audio" ) > 0 )
	{
		printLn( "^5 ******* fxid; " + fxid + "^5 type; " + type );
	}	
#/			
}

function debug_line_emitter()
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

function move_sound_along_line()
{
	closest_dist = undefined;
	
	/#
	self thread debug_line_emitter();
	#/
	
	while( 1 )
	{
		self closest_point_on_line_to_point( getlocalclientpos( 0 ), self.start, self.end );

		if( isdefined( self.fake_ent ) )
		{
			setfakeentorg( self._localClientNum, self.fake_ent, self.origin );
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

function line_sound_player()
{
	if( isdefined( self.script_looping ) )
	{
		self.fake_ent = spawnfakeent( self._localClientNum );
		setfakeentorg( self._localClientNum, self.fake_ent, self.origin );
		playloopsound( self._localClientNum, self.fake_ent, self.script_sound ); 
	}
	else
	{
		playsound( self._localClientNum, self.script_sound, self.origin );
	}
}

function playloopat( aliasname, origin )
{
	soundloopemitter ( aliasname, origin );
}

function stoploopat (aliasname, origin )
{
	soundstoploopemitter (aliasname, origin );
}

function soundwait( id )
{
	while( soundplaying( id ) )
	{
		wait( 0.1 );
	}
}

function snd_underwater( localClientNum )
{	
	level endon( "demo_jump" );
	self endon( "entityshutdown" );
	level endon("killcam_begin" + localClientNum );
	level endon("killcam_end" + localClientNum );
	self endon("sndEndUWWatcher");
	
	if ( !isdefined( level.audioSharedSwimming ) )
	{
		level.audioSharedSwimming = false;
	}
	
	if ( !isdefined( level.audioSharedUnderwater ) )
	{
		level.audioSharedUnderwater = false;
	}
	
	if ( level.audioSharedSwimming != IsSwimming( localClientNum ) )
	{
		 level.audioSharedSwimming = IsSwimming( localClientNum );
		 if ( level.audioSharedSwimming )
		 {
		 	swimBegin();
		 }
		 else
		 {
		 	swimCancel(localClientNum);
		 }
		 
	}
	
	if ( level.audioSharedUnderwater != IsUnderwater( localClientNum ) )
	{
		level.audioSharedUnderwater = IsUnderwater( localClientNum );
		if ( level.audioSharedUnderwater )
		{
			self underwaterBegin();
		}
		else
		{
			self underwaterEnd();
		}
	}
	
	
	while(1)
	{
		underwaterNotify = self util::waittill_any_return( "underwater_begin", "underwater_end", "swimming_begin", "swimming_end", "death" );

		if ( underwaterNotify == "death" )
		{
			self underwaterEnd();
			self swimEnd(localClientNum);
		}
		if ( underwaterNotify == "underwater_begin" )
		{
			self underwaterBegin();
		}
		else if (  underwaterNotify == "underwater_end" )
		{
			self underwaterEnd();
		}
		else if (  underwaterNotify == "swimming_begin" )
		{
			self swimBegin();
		}
		else if (  underwaterNotify == "swimming_end" && self isplayer() && IsAlive (self))
		{
			self swimEnd(localClientNum);
		}
	}
}

function underwaterBegin()
{
	level.audioSharedUnderwater = true;
	if( !( isdefined( self.lowHealth ) && self.lowHealth ) && !( isdefined( self.meleed ) && self.meleed ) )
	{
		if( SessionModeIsCampaignGame() )
		{
			mapname = GetDvarString( "mapname" );			
			if( mapname == "cp_mi_sing_sgen" )
			{
				forceambientroom( "cp_sgen_underwater" );	//special case room with unique reverb						
			}
			else
			{
				forceambientroom( "underwater" );	//generic underwater
			}				
		}
	}	
	if( SessionModeIsCampaignGame() )
	{
		setsoundcontext ("water", "under");	
	}
}

function underwaterEnd()
{
	level.audioSharedUnderwater = false;
	
	if( SessionModeIsCampaignGame() )
	{
		setsoundcontext ("water", "over");	
		if( !( isdefined( self.lowHealth ) && self.lowHealth ) && !( isdefined( self.meleed ) && self.meleed ) )
		{
			forceambientroom( "" );
		}
	}
}

function SetPfxContext()//need to move to ram 2
{

	level waittill( "pfx_igc_on" );
	setsoundcontext ("igc", "on");
	level waittill( "pfx_igc_off" );
	setsoundcontext ("igc", "");
	
	break;
}

function swimBegin()
{
	self.audioSharedSwimming = true;
}

function swimEnd( localClientNum )
{
	self.audioSharedSwimming = false;
	self thread wetbootstart();	
}

function swimCancel( localClientNum)
{
	self.audioSharedSwimming = false;
	self thread wetbootstart();	
}

function soundplayuidecodeloop(decodeString, playTimeMs)
{
	if ( !isdefined( level.playingUIDecodeLoop ) || !level.playingUIDecodeLoop )
	{
		level.playingUIDecodeLoop = true;
		fake_ent = spawn( 0, (0,0,0), "script_origin" );
	
		if ( isdefined(fake_ent) )
		{
			fake_ent playloopsound( "uin_notify_data_loop");
			wait(playTimeMs/1000);
			fake_ent stoploopsound();
		}
		
		level.playingUIDecodeLoop = undefined;
	}
}

function setCurrentAmbientState(ambientRoom, ambientPackage, roomColliderCent, packageColliderCent, defaultRoom)
{
	// sound designers, add any script based logic you want here. This gets called when ambient rooms change 
	// for any local player	
}

function sndHealthSystem(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( newVal )
	{
		switch( newVal )
		{
			case 1: //Low Health
				self.lowHealth = true;
				playsound( localClientNum, "chr_health_lowhealth_enter", (0,0,0) );
				forceambientroom( "sndHealth_LowHealth" );
				break;
			case 2: //Last Stand
				PlaySound( localClientNum, "chr_health_laststand_enter", (0,0,0) );
				forceambientroom( "sndHealth_LastStand" );
				break;
		}
	}
	else
	{
		self.lowHealth = false;
	
		if( SessionModeIsCampaignGame() && ( isdefined( level.audioSharedUnderwater ) && level.audioSharedUnderwater )  )
		{
			mapname = GetDvarString( "mapname" );			
			if( mapname == "cp_mi_sing_sgen" )
			{
				forceambientroom( "cp_sgen_underwater" );	//special case room with unique reverb						
			}
			else
			{
				forceambientroom( "underwater" );	//generic underwater
			}	
		}
		else
		{
			forceambientroom( "" );
		}
				
		if( oldVal == 1 )
			playsound( localClientNum, "chr_health_lowhealth_exit", (0,0,0) );
		else
			playsound( localClientNum, "chr_health_laststand_exit", (0,0,0) );
		break;
	}
}

function wetbootstop()
{
	self endon( "wetbootstart" );
	if (isdefined(self))
	{
		self setsoundentcontext ("boot", "dry");
	}
	
}

function wetbootstart()
{
	self endon( "entityshutdown" );
	self endon( "death" );
	self endon( "wetbootstop" );
	
	if (isdefined(self))
	{
		self setsoundentcontext ("boot", "wet");
		
		wait (6);
		self setsoundentcontext ("boot", "dry");
	}
}

function doRattle(origin, min, max)
{
	if( isdefined( min ) && min > 0 )
	{
		if( isdefined( max ) && max <= 0 )
		{
			max = undefined;
		}
		
		soundrattle(origin,min,max);
	}
}
function sndRattle_Server(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( newVal )
	{
		if( self.model == "wpn_t7_bouncing_betty_world" )
		{
			betty = getweapon( "bouncingbetty" );
			level thread doRattle(self.origin, betty.soundRattleRangeMin, betty.soundRattleRangeMax);
		}
	}
}
function sndRattle_Grenade_Client()
{
	while(1)
	{
		level waittill( "explode", localClientNum, position, mod, weapon, owner_cent );
		level thread doRattle(position, weapon.soundRattleRangeMin, weapon.soundRattleRangeMax);
	}
}

function weapon_butt_sounds(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{

	if(newVal)
	{		
		self.meleed = true;
		level.mysnd = playsound(localClientNum, "chr_melee_tinitus", (0,0,0));
		forceambientroom("sndHealth_Melee");
	}
	else
	{
		self.meleed = false;
		forceambientroom( "" );
		
		if( isdefined( level.mySnd ) )
			stopsound(level.mySnd);
	}
	
}
function set_sound_context_defaults()
{
	wait(2);
	if( SessionModeIsCampaignGame() )
	{
		setsoundcontext ("water", "over");	
	}
	setsoundcontext ("health", "full");
	setsoundcontext ("foley", "normal");
	
}

// 1 = PreMatch
function sndPrematch(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( newVal )
	{
		audio::snd_set_snapshot( "mpl_prematch" );
	}
	else
	{
		audio::snd_set_snapshot( "default" );
		wait(1.05);
	}
}
function sndFoleyContext(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( newVal )
		setsoundcontext ("foley", "igc");
	else
		setsoundcontext ("foley", "normal");
}

function sndKillcam()
{
	level thread sndFinalKillcam_Slowdown();
	level thread sndFinalKillcam_Deactivate();
}
function sndDeath_Activate()
{
	while(1)
	{
		level waittill( "sndDED" );

		audio::snd_set_snapshot( "mpl_death" );
	}
}
function sndDeath_Deactivate()
{
	while(1)
	{
		level waittill( "sndDEDe" );

		audio::snd_set_snapshot( "default" );
	}
}
function sndFinalKillcam_Activate()
{
	while(1)
	{
		level waittill( "sndFKs" );
		playsound( 0, "mpl_final_killcam_enter", (0,0,0) );
		audio::snd_set_snapshot( "mpl_final_killcam" );
	}
}
function sndFinalKillcam_Slowdown()
{
	while(1)
	{
		level waittill( "sndFKsl" );
		playsound( 0, "mpl_final_killcam_enter", (0,0,0) );
		playsound( 0, "mpl_final_killcam_slowdown", (0,0,0) );
		audio::snd_set_snapshot( "mpl_final_killcam_slowdown" );
	}
}
function sndFinalKillcam_Deactivate()
{
	while(1)
	{
		level waittill( "sndFKe" );
		audio::snd_set_snapshot( "default" );
	}
}

function sndSwitchVehicleContext(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( self IsLocalClientDriver( localClientNum ) )
	{
		//self setsoundentcontext("drivableveh", "1stperson");
		setsoundcontext( "plr_impact", "veh" );
	}
	else
	{
		//self setsoundentcontext("drivableveh", "3rdperson");
		setsoundcontext( "plr_impact", "" );
	}
}