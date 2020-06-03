//
// file: ber2_event2.gsc
// description: event 2 script for berlin2
// scripter: slayback
//

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\ber2;
#include maps\ber2_util;
#include maps\_music;

#using_animtree( "generic_human" );

// -- STARTS --
// for starting from event 2.
event2_start()
{
	warp_players_underworld();
	warp_friendlies( "struct_event2_start_friends", "targetname" );
	warp_players( "struct_event2_start", "targetname" );
	
	wait( 1 );
	
	if( level.coopOptimize )
	{
		numToSpawn = 2;
		spawner = getent_safe( "spawner_street_extraguy", "targetname" );
		for( i = 0; i < numToSpawn; i++ )
		{
			spawner.count++;
				
			extra = undefined;
			while( !IsDefined( extra ) )
			{
				while( !OkToSpawn() )
				{
					wait( 0.05 );
				}
				extra = spawn_guy( spawner );
					
				wait( 0.1 );
			}
				
			extra thread magic_bullet_shield_safe();
			
			// just move out of the way
			extra SetGoalPos( ( 933, 696, -191 ) );
				
			extra friend_add();
				
			wait( 0.1 );
		}
	}
	
	set_objective( 5 );
	
	bluetrig = getent_safe( "friendly_respawn_trigger_auto979", "script_noteworthy" );
	pinktrig = getent_safe( "friendly_respawn_trigger_auto5246", "script_noteworthy" );
	bluetrig notify( "trigger" );
	pinktrig notify( "trigger" );
	
	wait( 0.25 );
	
	level thread maps\ber2_event1::event1_action();  // this takes players into event2 stuff once the post-gate trigger is hit
	level thread maps\ber2_event1::subway_gate_action();
}

// for starting before the metro wave sequence.
event2_start_metrowave()
{
	warp_players_underworld();
	warp_friendlies( "struct_event2_metrowave_friends", "targetname" );
	warp_players( "struct_event2_metrowave", "targetname" );
	set_color_chain( "trig_script_color_allies_b29" );
	
	objectives_skip( 0 );
	
	level thread event2_setup();
	
	flag_set( "subway_gate_closed" );
	
	wait( 2 );
	getent_safe( "trigger_fog_ber2_subway", "script_noteworthy" ) notify( "trigger", get_players()[0] );
}
// -- END STARTS --


event2_setup()
{
	event2_arty_setup();
	
	thread event2_friends_setup();
	thread event2_arty();
	thread event2_reset_squad_colors();
	thread event2_mgs();
	thread event2_exitgate_action();
	thread metrowave_init_lights();
	
	thread event2_action_dialogue();
	
	thread metro_ai_wetness_change();
	
	//Kevins notify for starting the lights
	SetClientSysState("levelNotify","start_lights");
	//Kevin Sending ent name to the client side
	sound_subway_lights = getentarray("light_subway_flicker", "targetname");
	for(i = 0; i < sound_subway_lights.size; i ++)
	{
		sound_subway_lights[i] transmittargetname();
	}
}

metro_ai_wetness_change()
{
	flag_wait( "subway_gate_closed" );
	
	level thread ais_wetness_change( 0.5, 20, false, "allies" );
}

event2_friends_setup()
{
	for( i = 0; i < level.friends.size; i++ )
	{
		guy = level.friends[i];
		guy.maxSightDistSqrd = 574 * 574;
		
		if( guy != level.sarge && guy != level.hero1 )
		{
			guy thread stop_magic_bullet_shield_safe();
		}
	}
}

event2_reset_squad_colors()
{
	trigger_wait( "trig_script_color_allies_b31", "targetname" );
	
	flag_wait( "lights_back_on" );
	
	// put all friendlies back on blue color chain
	for( i = 0; i < level.friends.size; i++ )
	{
		level.friends[i].og_forcecolor = "b";  // in case the lights are off when we try to do this
		level.friends[i] set_force_color( "b" );
	}
}

event2_mgs()
{	
	level thread event2_mg_think( "trig_floodspawner_mgLeft", "spawner_metro_mg_left", "turret_metro_mg_left", "left" );
	level thread event2_mg_think( "trig_floodspawner_mgRight", "spawner_metro_mg_right", "turret_metro_mg_right", "right" );
}

event2_mg_think( trigSN, spawnerTN, turretSN, mgLocation )
{
	trigger_wait( trigSN, "script_noteworthy" );
	
	dismountTrig = undefined;
	killTrig = undefined;
	ender = undefined;
	killAtEnd = true;
	
	if( mgLocation == "left" )
	{
		dismountTrig = getent_safe( "trig_mgLeft_dismount", "targetname" );
		killTrig = getent_safe( "trig_script_color_allies_b32", "targetname" );
		ender = "subway_mg_left_dismount";
		goalPos = ( -2280, 2248, -528 );
	}
	else
	{
		dismountTrig = getent_safe( "trig_mgRight_dismount", "targetname" );
		killTrig = getent_safe( "trig_subway_exitGateArea", "targetname" );
		ender = "subway_mg_right_dismount";
		goalPos = ( -3412, 3646, -584 );
	}
	
	spawner = getent_safe( spawnerTN, "targetname" );
	gunner = spawn_guy( spawner );
	if( !IsDefined( gunner ) )
	{
		ASSERTMSG( "Can't spawn the gunner from spawner with targetname " + spawnerTN );
		return;
	}
	
	gunner.isMGer = true;
	
	turret = getent_safe( turretSN, "script_noteworthy" );
	
	level thread event2_mg_dismount( dismountTrig, ender );
	gunner thread event2_mg_force( turret, ender, goalPos );
	
	turret waittill( "turretstatechange" );
	
	switch( mgLocation )
	{
		case "left":
			guy = event2_mg_get_speaker( "p" );
			guy thread say_dialogue( "metro_mg_notifier", "mg_left" );
			break;
		
		case "right":
			guy = event2_mg_get_speaker( "b" );
			guy thread say_dialogue( "metro_mg_notifier", "mg_right" );
			break;
			
		default:
			ASSERTMSG( "event2_mg_think(): mgLocation of '" + mgLocation + "' is not recognized." );
	}
}

event2_mg_get_speaker( color )
{
	guys = undefined;
	
	// guys don't have color chains when the lights are off
	if( flag( "lights_back_on" ) )
	{
		// get a guy on the correct side of the metro
		guys = get_friends_by_color( color );
	}
	else
	{
		guys[0] = get_randomfriend_notsarge_excluding( level.hero1 );
	}
	
	ASSERTEX( array_validate( guys ), "Can't find anybody to say the MG line." );
	
	return get_random( guys );
}

event2_mg_dismount( trig, ender )
{
	trig waittill( "trigger" );
	level notify( ender );
}

// self = an AI
event2_mg_force( turret, ender, goalPos )
{
	self endon( "death" );
	
	self.goalradius = 24;
	node = getnode_safe( turret.targetname, "target" );
	self SetGoalNode( node );
	self.health = 10000;
	self thread magic_bullet_shield_safe();
	self waittill( "goal" );
	self thread stop_magic_bullet_shield_safe();
	
	level thread guy_stay_on_turret( self, turret, ender );
	level thread turret_reset( self, turret, ender );
	
	self thread scr_set_health( 150, 3 );
	
	level waittill( ender );
	
	if( is_active_ai( self ) )
	{
		self StopUseTurret();
		self.ignoreall = true;
		self SetGoalPos( goalPos );
		self waittill( "goal" );
	}
	
	if( is_active_ai( self ) )
	{
		self.ignoreall = false;
		self thread bloody_death( true, 5 );
	}
}

turret_reset( gunner, turret, ender )
{
	thread turret_reset_on_ender( gunner, turret, ender );
	level endon( ender );
	
	gunner waittill( "death" );
	turret SetMode( "manual_ai" );
}

turret_reset_on_ender( gunner, turret, ender )
{
	gunner endon( "death" );
	
	level waittill( ender );
	wait( 0.1 );
	turret SetMode( "manual_ai" );
}

scr_set_health( health, delay )
{
	wait( delay );
	self.health = health;
}

// --- metro exit gate stuff, including flash flood wave event ---
event2_exitgate_action()
{
	// wait for players to approach the area before starting to think
	trigger_wait( "trig_subway_exitGate_start", "targetname" );
	
	// regroup friends at the gate
	set_objective( 7 );
	
	level notify( "subway_arty_kill" );
	flag_set( "lights_back_on" );
	wait( 0.1 );
	set_color_chain( "trig_script_color_allies_b42" );
	
	trig = GetEnt( "trig_subway_exitGateArea", "targetname" );
	trig waittill( "trigger" );
	
	// spawn the final tunnel defenders
	spawners = GetEntArray( "spawner_subway_exitDefenders", "targetname" );
	ASSERTEX( IsDefined( spawners ) && spawners.size > 0, "Can't find any spawners for the subway exit defenders!" );
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[i].count = 100;
	}
	maps\_spawner::flood_spawner_scripted( spawners );
	level notify( "subway_exitgate_startDefenders" );
	
	// wait for the opener AI to get in the area
	opener = level.sarge;
	
	while( !opener IsTouching( trig ) )
	{
		wait( 0.5 );
	}
	
	// make sure all the players are in the area
	waittill_all_players_touching( trig );
	
	// for faster iterations on the wave art
	quickWave = GetDvarInt( "quickwave" );
	
	if( IsDefined( quickWave ) && quickWave > 0 )
	{
		quickWave = 1;
	}
	else
	{
		quickWave = 0;
	}	
	
	// start the flash flood wave event
	thread metrowave( opener, quickWave );
	
	level waittill( "subway_exitgate_startRunners" );
	
	spawners = GetEntArray( "spawner_subway_exitRunners", "targetname" );
	ASSERTEX( IsDefined( spawners ) && spawners.size > 0, "Can't find any spawners for the subway exit runners!" );
	maps\_spawner::flood_spawner_scripted( spawners );
	
	wave_trigger_wait( "struct_metrowave_nearEnemyLine" );	
	maps\_spawner::kill_spawnerNum( 201 );
}

metrowave_runner_spawnfunc()
{
	self.health = 1;
	level thread metrowave_runner_killpoints( self );
}

metrowave_runner_killpoints( runner )
{
	runner waittill( "death" );
	
	if( IsDefined( runner.attacker ) && IsPlayer( runner.attacker ) )
	{
		arcademode_assignpoints( "arcademode_score_generic1000", runner.attacker );
	}
}

metrowave( opener, quickWave )
{
	flag_set( "wave_sequence_started" );
	
	autosave_by_name( "ber2_metrowave_start" );
	
	gate = getent_safe( "sbmodel_subway_exitDoor", "targetname", "subway exit gate" );
	animSpot = getnode_safe( "node_subway_exitDoorSpot", "targetname", "metro exit door opening guy's spot" );
	
	// opener goes to gate
	opener.og_animname = opener.animname;
	opener.animname = "subway_exitgate_opener";
	opener.ignoreme = true;
	opener.ignoreall = true;
	opener PushPlayer( true );
	animSpot anim_reach_solo( opener, "doorstuck1" );
	
	//TUEY Sets music state to Subway
	setmusicstate("SUBWAY_END");	
	
	set_color_chain( "trig_script_color_allies_b22" );
	
	set_objective( 8 );
	
	level thread metrowave_friends_reactions( quickWave );
	level thread metrowave_force_camera();  // forces camera and does timescaling
	
	door = getent_safe( "sbmodel_subway_exitDoor", "targetname" );
	
	wave = getent_safe( "smodel_metrowave", "targetname" );
	waveCollisionTrig = getent_safe( "trig_metrowave_collision", "targetname" );
	waveCollisionTrig_aggressive = getent_safe( "trig_metrowave_collision_aggressive", "targetname" );
	
	// this area basically controls the timing of the whole wave buildup
	if( !quickWave )
	{
		level thread metrowave_rats();
		
		// "Keep firing!... I need to get the gate open!"
		level.sarge playsound_generic_facial( "Ber2_IGD_094A_REZN" );
		
		animSpot metrowave_door_anim( "doorstuck1", opener, door );
		animSpot anim_single_solo( opener, "twitch4" );
		
		// start wave buildup
		level notify( "start_wave_buildup" );
		
		metrowave_quake( "firststrike" );
		// Kevin:  Notify to play arty hit on metro that starts flood.
		level notify( "wave_arty" );
		
		animSpot metrowave_door_anim( "doorstuck2", opener, door );
		animSpot anim_single_solo( opener, "twitch2" );
		//animSpot metrowave_door_anim( "doorstuck3", opener, door );
		animSpot anim_single_solo( opener, "twitch3" );
		//animSpot metrowave_door_anim( "doorstuck1", opener, door );
		//animSpot anim_single_solo( opener, "twitch4" );
		
		// start rats
		// Kevin:  Notify to play rats
		level notify( "start_rats" );
		
		level thread metrowave_rumble( wave );
		
		animSpot metrowave_door_anim( "doorstuck3", opener, door );
		//animSpot anim_single_solo( opener, "twitch4" );
		//animSpot metrowave_door_anim( "doorstuck2", opener, door );
		
		// "almost got it..."
		animSpot anim_single_solo( opener, "almost" );
	}
	
	thread battlechatter_off( "allies" );
	//thread battlechatter_off( "axis" );
	
	level notify( "subway_exitgate_startRunners" );
	
	level thread metrowave_move( wave, waveCollisionTrig, waveCollisionTrig_aggressive );
	level thread metrowave_impact_ais( waveCollisionTrig_aggressive );
	level thread metrowave_turnoff_lights( waveCollisionTrig );
	level thread metrowave_blackout( waveCollisionTrig );
	
	//metrowave_quake( "player_approach" );
	level thread metrowave_approach_quake( wave );
	
	wave_trigger_wait( "struct_metrowave_nearplayer" );
	flag_set( "wave_near_players" );
	
	// make sure he didn't get deleted
	if( is_active_ai( opener ) )
	{
		// "got it!"
		animSpot anim_single_solo( opener, "success" );
		level.sarge Delete();
	}
	
	objective_state( 8, "done" );
}

metrowave_approach_quake( wave )
{
	// start the rumble loops
	array_thread( get_players(), ::metrowave_approach_rumble, wave );
		
	scale = 0.3;
	bigscale = 0.45;
	duration = 0.5;
	radius = 5000;
	
	// quake based on wave location
	while( !flag( "metrowave_blackout" ) )
	{
		quakeScale = scale;
		
		if( flag( "wave_near_players" ) )
		{
			scale = bigscale;
		}
		
		Earthquake( scale, duration, wave.origin, radius );
		wait( duration * 0.5 );
	}
}

metrowave_approach_rumble( wave )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self PlayRumbleLoopOnEntity( "tank_rumble" );
	
	while( !flag( "metrowave_blackout" ) )
	{
		wait( 0.05 );
	}
	
	self StopRumble( "tank_rumble" );
}

wave_trigger_wait( spotTN )
{
	level endon( "wave_finished" );
	
	waveCollisionTrig = getent_safe( "trig_metrowave_collision", "targetname" );
	spot = getstruct_safe( spotTN, "targetname" );
	
	// can't test istouching against structs
	org = Spawn( "script_origin", spot.origin );
	
	while( !waveCollisionTrig IsTouching( org ) )
	{
		wait( 0.05 );
	}
	
	org Delete();
}

// self = the animSpot
metrowave_door_anim( animeName, opener, door )
{
	door thread metro_exitdoor_anim( animeName );
	self anim_single_solo( opener, animeName );
}

metrowave_friends_reactions( quickWave )
{
	animname = "subway_exitgate_reaction";
	
	if( !quickWave )
	{
		// wave buildup
		level waittill( "start_wave_buildup" );
		wait( 2 );
		level.hero1 say_dialogue( animname, "doyouhearthat" );
		
		// rats close by
		level waittill( "rats_near_player" );
		level.hero1 say_dialogue( animname, "rats" );
	}
	
	// wave start
	level waittill( "subway_exitgate_startRunners" );
	level.hero1 say_dialogue( animname, "hurryup" );
	
	// wave near enemies
	wave_trigger_wait( "struct_metrowave_nearEnemyLine" );
	level.hero1 say_dialogue( animname, "omg" );
}

// handles earthquake types for wave event
metrowave_quake( quakeType )
{
	quakeScaleMin = undefined;
	quakeScaleMax = undefined;
	quakeDuration = undefined;
	
	// figure out quake type
	switch( quakeType )
	{
		case "firststrike":
			quakeScaleMin = 0.4;
			quakeScaleMax = 0.5;
			quakeDuration = 5;
			break;
			
		case "low_rumble":
			quakeScaleMin = 0.15;
			quakeScaleMax = 0.16;
			quakeDuration = 10;
			break;
			
		case "player_approach":
			quakeScaleMin = 0.35;
			quakeScaleMax = 0.45;
			quakeDuration = 5;
			break;
			
		default:
			ASSERTMSG( "metrowave_quake(): quakeType '" + quakeType + "' not recognized." );
	}
	
	fxMaxDist = 450;
	quakeRadius = 128;
	
	darkTimeMin = undefined;
	darkTimeMax = undefined;
	
	thread event2_arty_shake( level.metro_arty_emitters, level.metro_flicker_lights, darkTimeMin, darkTimeMax, fxMaxDist, quakeScaleMin, quakeScaleMax, quakeDuration, quakeRadius );
}

metrowave_rats()
{
	level endon( "wave_near_players" );
	
	level waittill( "start_rats" );
	
	ratStarts = GetStructArray( "metrowave_rat_start", "targetname" );
	ASSERTEX( IsDefined( ratStarts ) && ratStarts.size > 0, "metrowave_rats(): can't find any rat start spots." );
	
	level.ratsMax = 40;
	level.ratMoveSpeed = 175;
	ratWaitToSpawn_min = 0.2;
	ratWaitToSpawn_max = 0.3;
	
	if( level.coopOptimize )
	{
		level.ratsMax = 20;
		level.ratMoveSpeed = 165;
		ratWaitToSpawn_min = 0.4;
		ratWaitToSpawn_max = 0.65;
	}
	
	level.rats = [];
	
	thread metrowave_rats_notify();
	
	while( 1 )
	{
		// are we maxed out on rats?
		if( level.rats.size > level.ratsMax )
		{
			// delete the oldest rat as we spawn a new one
			level thread delete_oldest_rat();
		}
			
		get_random( ratStarts ) thread metrowave_rat_init();
		wait( RandomFloatRange( ratWaitToSpawn_min, ratWaitToSpawn_max ) );
	}
}

metrowave_rats_notify()
{
	wait( 3 );
	level notify( "rats_near_player" );
}

metrowave_rat_init()
{
	rat = Spawn( "script_model", self.origin );
	rat SetModel( "sewer_rat" );
	rat.angles = self.angles;
	rat.pathstart = self;
	
	level.rats[level.rats.size] = rat;
	
	rat thread metrowave_rat_runpath();
}

// self = the rat
metrowave_rat_runpath()
{
	self endon( "rat_delete" );
	
	// play anims while running path
	self thread metrowave_rat_anims();
	
	// run path
	pathpoint = self.pathstart;
	while( IsDefined( pathpoint ) )
	{
		if( IsDefined( pathpoint.target ) )
		{
			targets = GetStructArray( pathpoint.target, "targetname" );
			nextpoint = get_random( targets );
			
			// drop points a bit so they're beneath the water
			//zOffset = -0.175;
			zOffset = -5;
			pathpointOrigin = pathpoint.origin + ( 0, 0, zOffset );
			nextpointOrigin = nextpoint.origin + ( 0, 0, zOffset );
			
			// get time to get from one point to the next in order to keep constant speed
			// time = distance/speed
			ratMoveTime = Distance2D( nextpointOrigin, pathpointOrigin ) / level.ratMoveSpeed;
			//ratRotateTime = ratMoveTime / 6;
			ratRotateTime = 0.5;
			
			// rotate, if necessary
			newAngles = VectorToAngles( nextpointOrigin - pathpointOrigin );
			if( self.angles != newAngles )
			{
				self thread rotate_over_time( newAngles, ratRotateTime );
			}
			
			self MoveTo( nextpointOrigin, ratMoveTime );
			//rat waittill( "movedone" );
			wait( ratMoveTime - 0.05 );
			
			pathpoint = nextpoint;
		}
		else
		{
			break;
		}
	}
	
	self thread rat_delete();
}

delete_oldest_rat()
{
	if( IsDefined( level.rats[0] ) )
	{
		level.rats[0] thread rat_delete();
	}
}

rat_delete()
{
	self notify( "rat_delete" );
	self notify( "rat_stop_anims" );
	
	if( IsDefined( self.deleting ) )
	{
		return;
	}
	else
	{
		self.deleting = true;
	}
	
	level.rats = array_remove( level.rats, self );
	
	// sink!
	sinktime = 1;
	self MoveTo( self.origin + ( 0, 0, -32 ), sinktime );
	wait( sinktime );
	
	self Delete();
}

metrowave_rumble( wave )
{
	scale = 0.25;
	duration = 5;
	source = getstruct_safe( "struct_metrowave_nearplayer", "targetname" ).origin;
	radius = 64;
	
	// Kevin notify for LFE rumble
	level notify( "rumble" );
	
	// scale, duration, source, radius
	array_thread4( get_players(), ::scr_earthquake, scale, duration, source, radius );
	array_thread( get_players(), ::generic_rumble_loop, duration, "light" );
		
	wait( duration );
	
	scale = 0.65;
	duration = 5;
	
	array_thread4( get_players(), ::scr_earthquake, scale, duration, source, radius );
	array_thread( get_players(), ::generic_rumble_loop, duration );
}

metrowave_move( wave, waveCollisionTrig, waveCollisionTrig_aggressive )
{
	pathStart = getstruct_safe( wave.target, "targetname" );
	
	// build path
	wavePath = [];
	
	// set up the pathpoints
	pathpoint = pathStart;
	arraycount = 0;
	
	while( IsDefined( pathpoint ) )
	{
		wavePath[arraycount] = pathpoint;
		arraycount++;
		
		if( IsDefined( pathpoint.target ) )
		{
			pathpoint = GetStruct( pathpoint.target, "targetname" );
		}
		else
		{
			break;
		}
	}
	
	ASSERTEX( IsDefined( wavePath ) && wavePath.size > 0, "Couldn't find pathpoints for metrowave!" );
	
	// attach the wave collision triggers to the wave
	waveCollisionTrig EnableLinkTo();
	waveCollisionTrig LinkTo( wave );
	
	waveCollisionTrig_aggressive EnableLinkTo();
	waveCollisionTrig_aggressive LinkTo( wave );
	
	// attach particles to the wave
	PlayFxOnTag( level._effect["metrowave_base"], wave, "tag_origin" );
	
	// move wave
	waveSpeed = 625;
	
	// this works because the first origin is placed directly beneath the wave model
	// if not, you'll have to move the wave to the struct's X/Y and rotate it to the struct's angles
	// it also assumes the wave travels along the same Z at all times
	for( i = 0; i < wavePath.size; i++ )
	{
		org = wavePath[i];
		nextOrg = undefined;
		newAngles = undefined;
		
		// look ahead to next org
		if( IsDefined( org.target ) )
		{
			nextOrg = GetStruct( org.target, "targetname" );
			
			// get time to get from one point to the next in order to keep constant speed
			// time = distance/speed
			waveMoveTime = Distance2D( nextOrg.origin, org.origin ) / waveSpeed;
			waveRotateTime = waveMoveTime / 4;
			
			// rotate, if necessary
			newAngles = VectorToAngles( nextOrg.origin - org.origin );
			
			if( wave.angles != newAngles )
			{
				wave thread rotate_over_time( newAngles, waveRotateTime, ( 0, 90, 0 ) );
			}
			
			wave MoveTo( nextOrg.origin, waveMoveTime );
			wave waittill( "movedone" );
		}
	}
}

rotate_over_time( newAngles, rotateTime, anglesOffset )
{
	angles = newAngles;
	
	if( IsDefined( anglesOffset ) )
	{
		angles += anglesOffset;
	}
	
	self RotateTo( angles, rotateTime );
}

metrowave_impact_ais( waveCollisionTrig )
{
	level endon( "wave_finished" );
	
	while( 1 )
	{
		enemies = get_ai_group_ai( "ai_metrowave_enemies" );
		friends = get_friends( );
		
		guys = array_combine( enemies, friends );
		
		if( IsDefined( guys ) && guys.size > 0 )
		{
			for( i = 0; i < guys.size; i++ )
			{
				guy = guys[i];
			
				if( is_active_ai( guy ) && waveCollisionTrig IsTouching( guy ) )
				{
					if( !IsDefined( guy.waveImpact ) )
					{
						guy thread metrowave_impact_ai();
					}
				}
			}
		}
		
		wait( 0.05 );
	}
}

// self = the guy getting hit by the wave
metrowave_impact_ai()
{
	self.waveImpact = true;
	
	wait( RandomFloatRange( 0.12, 0.2 ) * GetTimeScale() );
	
	// key friendlies have bullet shield turned on
	if(  IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
	{
		self thread stop_magic_bullet_shield();
	}
	
	animSpot = SpawnStruct();
	animSpot.origin = self.origin;
	animSpot.angles = ( 0, 325, 0 );
	
	self.animname = "metrowave_casualty";
	animRefs[0] = "wipeout1";
	animRefs[1] = "wipeout2";
	animRefs[2] = "wipeout3";
	animRefs[3] = "wipeout4";
	animRefs[4] = "wipeout5";
	animRefs[5] = "wipeout6";
	animRefs[6] = "wipeout7";
	animRefs[7] = "wipeout8";
	
	if( IsDefined( self ) && IsAlive( self ) )
	{
		animSpot anim_single_solo( self, get_random( animRefs ) );
	}
	
	self DoDamage( self.health + 5, ( 0, 0, 0 ) );
}

metrowave_force_camera()
{
	lookTarget = getstruct_safe( "struct_metrowave_nearEnemyLine", "targetname" );
	
	wave_trigger_wait( "struct_metrowave_nearEnemyLine" );
	
	// "Dimitri! LOOK OUT!!!"
	level.hero1 thread playsound_generic_facial( "Ber2_IGD_415A_CHER" );
	
	wait( 0.25 );
	
	reqDot = 0.77;
	viewLerpTime = 0.3;
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] EnableInvulnerability( true );
		
		// see if they're looking in that direction
		normal = VectorNormalize( lookTarget.origin - players[i].origin );
		player_angles = players[i] GetPlayerAngles();
		player_forward = AnglesToForward( player_angles );
	
		dot = VectorDot( player_forward, normal );
		
		if( dot < reqDot )
		{
			// angles from the player eye origin to the optimal look target
			anglesToLookOrigin = VectorToAngles( lookTarget.origin - players[i] GetEye() );
			
			players[i] SetStance( "stand" );
		
			//players[i] thread lerp_player_view_to_position( players[i].origin, lookAngles, viewLerpTime, 1, 20, 20, 10, 10 );
			players[i] thread lerp_player_view_to_position( players[i].origin, anglesToLookOrigin, viewLerpTime, 1, 0, 0, 0, 0 );
		}
	}
	
	wait( viewLerpTime * 0.5 );
	
	timescaleSlow = 0.2;
	//Kevin adding notify to set slow mo sounds
	level notify( "slow_shatter" );
	timescale_over_time( timescaleSlow, 0.8 );
	wait( 1.35 * timescaleSlow );  // to wait for x seconds of real time, we wait for (x * timescaleSlow) seconds of game time
	timescale_over_time( 1, 0.9 );
}

metrowave_init_lights()
{
	startIntensity = 2.5;
	
	lightGroups = [];
	lightGroups[0] = getstruct_safe( "floodlight_1", "targetname" );
	lightGroups[1] = getstruct_safe( "floodlight_2", "targetname" );
	lightGroups[2] = getstruct_safe( "floodlight_3", "targetname" );
	lightGroups[3] = getstruct_safe( "floodlight_4", "targetname" );
	lightGroups[4] = getstruct_safe( "floodlight_5", "targetname" );
	
	for( i = 0; i < lightGroups.size; i++ )
	{
		// a script_struct
		lightGroup = lightGroups[i];
		
		lightGroup.light = getent_safe( lightGroup.target, "targetname" );
		lightGroup.light SetLightIntensity( 5.5 );
		
		// set up cone particle w/ d-light
		lightGroup.particleLight = Spawn( "script_model", lightGroup.origin );
		lightGroup.particleLight.angles = lightGroup.angles;
		lightGroup.particleLight SetModel( "tag_origin" );
		PlayFxOnTag( level._effect["metro_light_filler_high"], lightGroup.particleLight, "tag_origin" );
	}
	
	level.metrowaveLightGroups = lightGroups;
}

metrowave_turnoff_lights( waveCollisionTrig )
{
	array_thread( level.metrowaveLightGroups, ::metrowave_turnoff_lightgroup, waveCollisionTrig );
}

metrowave_turnoff_lightgroup( waveCollisionTrig )
{
	level endon( "wave_finished" );
	
	lightGroup = self;
	
	org = Spawn( "script_origin", lightGroup.light.origin );
	org.angles = ( 0, 325, 0 );
	
	while( !waveCollisionTrig IsTouching( org ) )
	{
		wait( 0.05 );
	}
	
	//Kevin playing light hits by wave
	org playsound("bulb_break");
	PlayFX( level._effect["light_explode"], org.origin, org.angles );
	

	lightGroup.light light_setintensity( 0, 0.05 );
	
	if( IsDefined( lightGroup.particleLight ) )
	{
		lightGroup.particleLight Delete();
	}
	
	wait( 2 );
	org Delete();
}

metrowave_blackout( waveCollisionTrig )
{
	// wait for the wave to hit a player
	while( 1 )
	{
		players = get_players();
		waveTouch = false;
		
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			if( waveCollisionTrig IsTouching( player ) )
			{
				waveTouch = true;
				break;
			}
		}
		
		if( waveTouch )
		{
			break;
		}
		else
		{
			wait( 0.05 );
		}
	}
	
	level thread metrowave_kill_all_axis();
	
	wait( 0.1 );
	
	// Kevin:  Notify to stop wave looping sound and turn down buses
	level notify("stop_wave_sound");
	SetClientSysState("levelNotify","set_wave_bus");
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] DisableWeapons();
		players[i] SetClientDvar( "compass", "0" );
		players[i] SetClientDvar( "miniscoreboardhide", "1" );
		
		// lock in place
		players[i].lock = Spawn( "script_origin", players[i].origin );
		players[i].lock.angles = players[i].angles;
		players[i] PlayerLinkTo( players[i].lock, "", 1, 25, 25, 25, 25 );
	}
	
	// blackout!
	level.blackout = NewHudElem();
	level.blackout.x = 0;
	level.blackout.y = 0;
	level.blackout.horzAlign = "fullscreen";
	level.blackout.vertAlign = "fullscreen";
	level.blackout.foreground = false;  // arcademode compatible
	level.blackout.sort = 50;  // arcademode compatible
	level.blackout SetShader( "black", 640, 480 );
	
	flag_set( "metrowave_blackout" );
	
	players = get_players();
	
	// move playerone to our perfect spot
	playerone = players[0];
	playerone.lock.origin = ( -3654, 3871, -514 );
	playerone.lock.angles = ( 336, 64, -40 );
	
	// if we have more than one player...
	if( players.size > 1 )
	{
		for( i = 0; i < players.size; i++ )
		{
			// disable bleeding out so we don't restart from checkpoint during black screen
			players[i] thread player_prevent_bleedout();
			
			// hide players & warp to playerone's spot
			players[i] Hide();
	
			if( players[i] != playerone )
			{
				players[i].lock.origin = playerone.lock.origin;
				players[i].lock.angles = playerone.lock.angles;
			}
		}
	}
	
	wait( 2 );
	
	// set up watery looking stuff
	// TODO for now this is just temp
	//Kevin adding underwater screams
	level notify( "water_scream" );
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] VisionSetNaked( "sniper", 0.05 );
	}
	
	tscale = 0.5;
	SetTimescale( tscale );
	
	// DEPRECATED
	//level thread floater( playerone.lock );
	
	// fade in
	level.blackout FadeOverTime( 1 * tscale );
	level.blackout.alpha = 0;
	array_thread( get_players(), ::metrowave_player_bubbles );
	
	wait( 2.5 * tscale );
	
	// fade out
	level.blackout FadeOverTime( 0.8 * tscale );
	level.blackout.alpha = 1;
	
	wait( 2 * tscale );
	
	// fade in
	//Kevin adding underwater screams
	level notify( "water_scream" );
	level.blackout FadeOverTime( 1 * tscale );
	level.blackout.alpha = 0;
	array_thread( get_players(), ::metrowave_player_bubbles );
	
	wait( 2 * tscale );
	
	// fade out
	level.blackout FadeOverTime( 0.8 * tscale );
	level.blackout.alpha = 1;
	
	//Kevin stopping looped sounds
	level notify( "loops_stop" );
	
	wait( 6 * tscale );
	
	// if demo, do custom outro
	if( level.isDemo )
	{
		epd_demo_outro();
	}
	else
	{
		nextmission();
	}
}

metrowave_kill_all_axis()
{
	axis = GetAIArray( "axis" );
	
	if( !array_validate( axis ) )
	{
		return;
	}
	
	for( i = 0; i < axis.size; i++ )
	{
		axis[i].health = 1;
		axis[i] delayThread( RandomFloatRange( 2, 5 ), ::bloody_death, true, 2 );
	}
}

// stops players from bleeding out in coop
player_prevent_bleedout()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	while( 1 )
	{
		self.bleedout_time = 100000;
		wait( 0.5 );
	}
}

/* DEPRECATED
floater( animSpot, isAxis )
{
	animname = "metrowave_floater";
	animRef = "float";
	
	guy = Spawn( "script_model", animSpot.origin );
	guy Hide();
	guy.angles = animSpot.angles;
	
	if( !IsDefined( isAxis ) )
	{
		isAxis = false;
	}
	
	if( isAxis )
	{
		guy maps\ber2_anim::setup_axis_char_model();
	}
	else
	{
		guy maps\ber2_anim::setup_ally_char_model();
	}
	
	guy UseAnimTree( #animtree );
	guy.animname = animname;
	
	animSpot thread anim_single_solo( guy, animRef );
	
	wait( 0.075 );
	guy Show();
	guy waittillmatch( "single anim", "end" );
	guy Delete();
}
*/

// Flamer steez
metrowave_player_bubbles()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	deleteit = 0;
	for (i=0; i < 10; i++)
	{
		offset1 = (randomint(20), randomint(20), -1*randomint(5));
		offset2 = (-1*randomint(20), -1*randomint(20), -1*randomint(5));
		offset = offset1 + offset2;
		spot1 = spawn("script_model", (self geteye())+(offset) );
		spot1 setmodel("tag_origin");
		spot2 = spawn("script_model", (self geteye())+(offset) );
		spot2 setmodel("tag_origin");
		spot1 linkto(self);
		spot2 linkto(self);
		playfxontag(level._effect["limb_bubbles"], spot1, "tag_origin");
		playfxontag(level._effect["torso_bubbles"], spot2, "tag_origin");
		if (deleteit == 0)
		{
			deleteit = 1;
			level thread wait_and_trigoff(spot1, randomfloat(2.3, 3) );
			spot2 thread drag_bubbles();
			
		}
		else if (deleteit == 1)
		{
			level thread wait_and_trigoff(spot1, randomfloat(2.3, 4) );
			level thread wait_and_trigoff(spot2, randomfloat(2.3, 4) );
		}
	}
}

drag_bubbles()
{
	wait 3;
	self unlink();
	self moveto(self.origin+(0,0,-100), 10);
}

wait_and_trigoff(thing, time)
{
	wait time;
	if (isdefined(thing))
	{
		thing unlink();
		thing moveto(thing.origin+(0,0,-10000), 0.01);
		wait 0.1;
		thing delete();
		thing = "undefined";
	}
}

// handles custom outro stuff for the EPD demo
epd_demo_outro()
{
	SetTimescale( 1 );
	
	if( !IsDefined( level.blackout ) )
	{
		level.blackout = NewHudElem();
		level.blackout.x = 0;
		level.blackout.y = 0;
		level.blackout.horzAlign = "fullscreen";
		level.blackout.vertAlign = "fullscreen";
		level.blackout.foreground = true;
		level.blackout SetShader( "black", 640, 480 );
		level.blackout.alpha = 0;
	}
	
	// if screen's not black already, fade the black in
	if( level.blackout.alpha != 1 )
	{
		level.blackout FadeOverTime( 0.8 ); 
		level.blackout.alpha = 1;
	}
	
	temptext = NewHudElem();
	temptext.x = 0;
	temptext.y = 0;
	temptext.alignX = "center";
	temptext.alignY = "middle";
	temptext.horzAlign = "center";
	temptext.vertAlign = "middle";
	temptext.sort = 1;
	temptext.foreground = true;
	temptext.fontscale = 1.75;
	temptext SetText( &"GAME_TO_BE_CONTINUED" );
	
	fadeTime_text = 1.2;
	
	// fade text in
	temptext.alpha = 0;
	temptext FadeOverTime( fadeTime_text );
	temptext.alpha = 1;
	
	wait( 3 + fadeTime_text );
	
	fadeTime_text = 0.25;
	
	// fade text out
	temptext FadeOverTime( fadeTime_text );
	temptext.alpha = 0;
	
	wait( fadeTime_text );
	
	// change text and fade up
	temptext.fontscale = 1.5;
	temptext SetText( &"GAME_THANKS_FOR_PLAYING" );
	temptext FadeOverTime( fadeTime_text );
	temptext.alpha = 1;
	
	wait( 2 + fadeTime_text );
	
	fadeTime_text = 1.2;
	
	// fade text out
	temptext FadeOverTime( fadeTime_text );
	temptext.alpha = 0;
	
	wait( fadeTime_text );
	
	outroscreen = NewHudElem();
	outroscreen.horzAlign = "center";
	outroscreen.vertAlign = "middle";
	outroscreen.alignX = "center";
	outroscreen.alignY = "middle";
	outroscreen.sort = 1;
	outroscreen.foreground = true;
	outroscreen SetShader( "ber2_epd_coming_soon", 400, 400 );
	outroscreen.alpha = 0;
	
	// fade the outro art in on top of the black
	outroscreen FadeOverTime( 1.2 );
	outroscreen.alpha = 1;
	wait( 1.2 );
	
	// after some time, you can skip it
	wait( 5 );
	
	endTime = GetTime() + ( 15 * 1000 );
	
	host = get_players()[0];
	
	while( GetTime() < endTime )
	{
		if( host UseButtonPressed() )
		{
			break;
		}
		else
		{
			wait( 0.05 );
		}
	}
	
	// fade outro art out
	outroscreen FadeOverTime( 3 );
	outroscreen.alpha = 0;
	wait( 3 );
	
	wait( 0.75 );
	
	//CODE MOD: TKEEGAN 8/15/08
	nextmission();  // back to title screen
}

// --- end subway exit gate stuff ---

// --- metro arty impact stuff ---
event2_arty_setup()
{
	// metro flickery lights get initialized to starting brightness at map start in ber2_fx
	emitters = GetStructArray( "struct_metro_artyfx_emitter", "targetname" );
	ASSERTEX( IsDefined( emitters ) && emitters.size > 0, "Can't find any metro arty fx emitters." );
	level.metro_arty_emitters = emitters;
	
	flag_clear( "lights_back_on" );
}

event2_arty()
{
	level endon( "subway_exitgate_startDefenders" );
	
	//flag_wait( "subway_gate_closed" );
	// start when players get a ways onto the subway platform
	trigger_wait( "trig_floodspawner_mgLeft", "script_noteworthy" );
	
	level.pauseRandomShake = false;
	
	// time between arty strikes (actual time is + darkTimeMax)
	minWait = 25;
	maxWait = 30;
	
	// time that the lights will be off
	darkTimeMin = 8;
	darkTimeMax = 12;
	
	// time over which the lights will flicker back on
	level.flickerTimeMin = 5;
	level.flickerTimeMax = 7;
	
	// quake settings
	quakeScaleMin = .34;
	quakeScaleMax = .39;
	quakeDuration = 3;
	quakeRadius = 500;
	
	// max distance from player to fx emitters
	fxMaxDist = 650;
	
	isFirstShake = true;
	
	while( 1 )
	{
		if( !isFirstShake )
		{
			wait( RandomFloatRange( minWait, maxWait ) );
			thread arty_normalshake_friendly_dialogue();
		}
		// first strike should happen immediately
		else
		{
			thread arty_firstshake_dialogue();
			isFirstShake = false;
		}
		
		if( !level.pauseRandomShake )
		{
			//Kevin:  Notify to play arty hitting metro.
			level notify("metro_arty");
			thread event2_arty_shake( level.metro_arty_emitters, level.metro_flicker_lights, darkTimeMin, darkTimeMax, fxMaxDist, quakeScaleMin, quakeScaleMax, quakeDuration, quakeRadius );
			
			// make sure we're not hitting again until the lights come up
			wait( darkTimeMax );
		}
	}
}

arty_firstshake_dialogue()
{
	level endon( "subway_arty_kill" );
	
	wait( 1 );
	
	// "Shhhh!"
	level.sarge playsound_generic_facial( "Ber2_IGD_081A_REZN" );
	// "Stay where you are."
	level.sarge playsound_generic_facial( "Ber2_IGD_082A_REZN" );
	// "Give your eyes a moment to adjust to the darkness."
	level.sarge playsound_generic_facial( "Ber2_IGD_083A_REZN" );
	
	flag_wait( "lights_back_on" );
	
	// "OPEN FIRE!!!"
	level.sarge playsound_generic_facial( "Ber2_IGD_084A_REZN" );
}

arty_normalshake_friendly_dialogue()
{
	level endon( "subway_arty_kill" );
	
	wait( 1 );
	
	randomTries = 10;
	
	// "Stay on your guard... They may be cowering in the dark."
	darkLines[0] = "Ber2_IGD_030A_REZN";
	// "Shhhhh!"
	darkLines[1] = "Ber2_IGD_008A_REZN";
	// "Stay where you are."
	darkLines[2] = "Ber2_IGD_082A_REZN";
	// "I can barely see."
	darkLines[3] = "Ber2_IGD_052A_CHER";
	// "Don't move."
	darkLines[4] = "Ber2_IGD_401A_REZN";
	// "We cannot fight in darkness."
	darkLines[5] = "Ber2_IGD_402A_CHER";
	// "What do we do now?"
	darkLines[6] = "Ber2_IGD_403A_CHER";
	// "Wait... be ready..."
	darkLines[7] = "Ber2_IGD_404A_REZN";
	// "Find your targets as soon as the lights come on."
	darkLines[8] = "Ber2_IGD_405A_REZN";
	
	// try to get a unique line
	darkLine = get_random_excluding( darkLines, level.lastDarkLine );
	level.lastDarkLine = darkLine;
	
	speaker = get_artyshake_speaker( darkLine );
	speaker playsound_generic_facial( darkLine );
	
	flag_wait( "lights_back_on" );
	
	// "There! On the platform!"
	lightLines[0] = "Ber2_IGD_085A_REZN";
	// "In the traincars!"
	lightLines[1] = "Ber2_IGD_086A_REZN";
	// "Cut them down!"
	lightLines[2] = "Ber2_IGD_024A_REZN";
	// "Fire!"
	lightLines[3] = "Ber2_IGD_025A_REZN";
	// "I see them!" (Reznov)
	lightLines[4] = "Ber2_IGD_023A_REZN";
	// "I see them!" (Chernov)
	lightLines[5] = "Ber2_IGD_406A_CHER";
	// "Now, Comrades! NOW!!!"
	lightLines[6] = "Ber2_IGD_407A_REZN";
	// "Send them to their graves!"
	lightLines[7] = "Ber2_IGD_408A_REZN";
	
	// try to get a unique line
	lightLine = get_random_excluding( lightLines, level.lastLightLine );
	level.lastLightLine = lightLine;
	
	// play the line
	speaker = get_artyshake_speaker( lightLine );
	speaker playsound_generic_facial( lightLine );
}

get_artyshake_speaker( theLine )
{
	speaker = level.sarge;
	
	if( IsSubStr( theLine, "CHER" ) )
	{
		speaker = level.hero1;
	}
	
	return speaker;
}

firstshake_lights_back_on_setflag()
{
	level waittill( "lights_back_on" );
	flag_set( "firstshake_lights_back_on" );
}

// dist = how far away should we look for emitter origins?
event2_arty_shake( emitters, lights, darkTimeMin, darkTimeMax, maxDist, quakeScaleMin, quakeScaleMax, quakeDuration, quakeRadius )
{
	fx_dust = level._effect["metro_arty_dust"];
	fx_chunks = level._effect["metro_arty_dust_chunks"];
	
	event2_arty_fx_reset( emitters );
	
	players = get_players();
	
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		// play the earthquake
		player thread generic_rumble_loop( quakeDuration * 0.9 );
		Earthquake( RandomFloatRange( quakeScaleMin, quakeScaleMax ), quakeDuration, player.origin, quakeRadius );
		
		if( !flag( "wave_sequence_started" ) )
		{
			// flicker lights
			level.arty_flickerlights_on = 0;
			array_thread( lights, maps\ber2_fx::light_arty_flicker, darkTimeMin, darkTimeMax );
			thread darkness_think( lights );
		
			//Kevins notify for light manager and to stop the light loops
			SetClientSysState("levelNotify","arty_light_hit");
			player playsound("subway_debris1");
		}
		
		// play particles, if emitters are nearby
		for( i = 0; i < emitters.size; i++ )
		{
			emitter = emitters[i];
			if( Distance( player.origin, emitter.origin ) <= maxDist )
			{
				if( !IsDefined( emitter.arty_isEmitting ) || !emitter.arty_isEmitting )
				{
					emitter.arty_isEmitting = true;
					
					if( RandomInt( 100 ) < 30 )
					{
						PlayFx( fx_chunks, emitter.origin );
					}
					else
					{
						PlayFx( fx_dust, emitter.origin );
					}
				}
			}
		}
	}
}

event2_arty_fx_reset( emitters )
{
	for( i = 0; i < emitters.size; i++ )
	{
		emitters[i].arty_isEmitting = false;
	}
}

darkness_think( lights )
{
	level notify( "lights_off" );
	flag_clear( "lights_back_on" );
	
	thread darkness_ai_setup();
	thread darkness_stop_wait( lights.size );
}

darkness_ai_setup()
{
	// tally kills made in the dark for achievement
	thread tally_dark_kills();
	thread darkness_battlechatter();
	
	ais = GetAIArray();
	array_thread( ais, ::darkness_ai_think );
	
	spawners = GetSpawnerArray();
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[i] thread darkness_ai_spawnerthread();
	}
}

darkness_battlechatter()
{
	thread battlechatter_off( "allies" );
	thread battlechatter_off( "axis" );
	
	flag_wait( "lights_back_on" );
	wait( 1.5 );  // in case we're saying scripted lines
	
	thread battlechatter_on( "allies" );
	thread battlechatter_on( "axis" );
}

darkness_ai_spawnerthread()
{
	level endon( "lights_back_on" );
	
	while( 1 )
	{
		self waittill( "spawned", spawn );
		if( maps\_utility::spawn_failed( spawn ) )
		{
			continue;
		}
		
		wait( 0.05 );
		
		spawn thread darkness_ai_think();
	}
}

darkness_ai_think()
{
	self endon( "death" );
	
	// MGers don't care about the dark, ever!
	if( IsDefined( self.isMGer ) )
	{
		return;
	}
	
	if( self.team == "axis" )
	{
		self thread dark_playerkill_wait();
	}
	
	//self thread darkness_goal_management();  // DEPRECATED
	
	self.ignoreall = true;
	self.ignoreme = true;
	
	self thread darkness_proxcheck();
	
	if( get_players().size < 2 )
	{
		self thread darkness_randomfire();
	}
	else
	{
		self thread darkness_coop_unignore();
	}
	
	level waittill( "lights_back_on" );
	
	self.ignoreall = false;
	self.ignoreme = false;
}

darkness_coop_unignore()
{
	self endon( "death" );
	wait( RandomFloatRange( 2 ) );
	
	if( is_active_ai( self ) )
	{
		self.ignoreall = false;
		self.ignoreme = false;
	}
}

/*  DEPRECATED - it's more fun to see the AIs run around in the dark
darkness_goal_management()
{
	self endon( "death" );

	targetNode = undefined;

	// enemy
	if( self.team == "axis" )
	{
		if( IsDefined( self.target ) )
		{
			targetNode = getnode_safe( self.target, "targetname" );
			
			if( Distance( targetNode.origin, self.origin ) <= 128 )
			{
				self waittill( "goal" );
			}
		}
		
		if( !flag( "lights_back_on" ) )
		{
			self SetGoalPos( self.origin );
		}
		
		flag_wait( "lights_back_on" );
		
		if( !IsDefined( self.fallback_node ) )
		{
			if( IsDefined( targetNode ) )
			{
				self SetGoalNode( targetNode );
			}
		}
	}
	// friendly
	else
	{
		// don't want to mess up existing bullet shields
		if( !IsDefined( self.magic_bullet_shield ) || !self.magic_bullet_shield )
		{
			self thread magic_bullet_shield_safe();
			self.darkness_allied_bullet_shield = true;
		}
		
		self SetGoalPos( self.origin );
		self AllowedStances( "crouch" );
		
		self.og_forcecolor = self get_force_color();
		self clear_force_color();
		
		flag_wait( "lights_back_on" );
		
		self AllowedStances( "stand", "crouch", "prone" );
		self set_force_color( self.og_forcecolor );
		
		// reset the executioner
		if( IsDefined( self.darkness_allied_bullet_shield ) && self.darkness_allied_bullet_shield )
		{
			self thread stop_magic_bullet_shield_safe();
		}
	}
}
*/

darkness_proxcheck()
{
	level endon( "lights_back_on" );
	self endon( "death" );
	
	alertDist = 500;
	alertDist *= alertDist;  // units
	
	// wait for an enemy to get close
	while( 1 )
	{
		enemies = undefined;
		
		if( self.team == "axis" )
		{
			enemies = GetAIArray( "allies" );
			enemies = array_combine( enemies, get_players() );
		}
		else
		{
			enemies = GetAIArray( "axis" );
		}
		
		enemy = undefined;
		for( i = 0; i < enemies.size; i++ )
		{
			if( DistanceSquared( enemies[i].origin, self.origin ) < alertDist )
			{
				self.ignoreall = false;
				enemy = enemies[i];
				break;
			}
		}
		
		if( IsDefined( enemy ) )
		{
			self notify( "enemy_found_in_the_dark" );
			
			// TODO fix or rip out
			// this doesn't work because the target origin is inside the enemy
			//self.targetOrg = Spawn( "script_model", enemy.origin + ( 0, 0, 48 ) );
			//self.targetOrg LinkTo( enemy );
			//self SetEntityTarget( self.targetOrg );
			
			self thread darkness_reset_target( enemy );
			delayThread( RandomFloatRange( 1.5, 3 ), ::scr_ignoreme, false );
			
			self waittill( "clear_darkness_target" );
			
			/* TODO fix or rip out
			if( IsDefined( self.targetOrg ) )
			{
				self.targetOrg Delete();
			}
			*/
		}
		
		wait( 0.25 );
	}
}

darkness_reset_target( enemy )
{
	self endon( "death" );
	self thread darkness_target_reset_because_lights();
	self thread darkness_target_reset_because_targetdead( enemy );
	
	self waittill( "clear_darkness_target" );
	// TODO fix or rip out
	//self ClearEntityTarget();
}

darkness_target_reset_because_lights()
{
	self endon( "clear_darkness_target" );
	self endon( "death" );
	
	level waittill( "lights_back_on" );
	self notify( "clear_darkness_target" );
}

darkness_target_reset_because_targetdead( enemy )
{
	self endon( "clear_darkness_target" );
	self endon( "death" );
	
	enemy waittill( "death" );
	self notify( "clear_darkness_target" );
}

darkness_randomfire()
{
	level endon( "lights_back_on" );
	self endon( "death" );
	self endon( "enemy_found_in_the_dark" );
	
	waitMin = 1;
	waitMax = 4;
	
	while( 1 )
	{
		wait( RandomFloatRange( waitMin, waitMax ) );

		if( self.ignoreall )
		{
			self.ignoreall = false;
		}
		
		if( !self.ignoreall && self darkness_ai_player_nearby() )
		{
			self.ignoreall = true;
		}
	}
}

darkness_ai_player_nearby()
{
	alertDist = 500;
	alertDist *= alertDist;  // units
	
	players = get_players();
	
	foundOne = false;
	for( i = 0; i < players.size; i++ )
	{
		if( DistanceSquared( players[i].origin, self.origin ) < alertDist )
		{
			foundOne = true;
			break;
		}
	}
	
	return foundOne;
}

dark_playerkill_wait()
{
	level endon( "lights_back_on" );
	
	self waittill( "death" );
	
	if( IsDefined( self.attacker ) && IsPlayer( self.attacker ) )
	{
		player = self.attacker;
		
		if( !IsDefined( player.ber2_dark_kills ) )
		{
			player.ber2_dark_kills = 0;
		}
		
		player.ber2_dark_kills++;
	}
}

tally_dark_kills()
{
	level endon( "lights_back_on" );
		
	// wait for players to get the cheeve
	while( 1 )
	{
		players = get_players();
		
		for( i = 0; i < players.size; i++ )
		{
			if( !IsDefined( players[i].ber2_dark_kills ) )
			{
				continue;
			}
			
			if( players[i].ber2_dark_kills > 10 )
			{
				if( !IsDefined( players[i].ber2_dark_kill_got_cheeve ) )
				{
					players[i].ber2_dark_kill_got_cheeve = true;
					players[i] GiveAchievement( "BER2_ACHIEVEMENT_KILL10" );
					
					arcademode_assignpoints( "arcademode_score_generic1000", players[i] );
				}
			}
		}
		
		wait( 0.1 );
	}
}

darkness_stop_wait( numLights )
{
	onFrac = 0.65;
	
	// wait for an acceptable fraction of the lights to come back on
	while( level.arty_flickerlights_on < ( numLights * onFrac ) )
	{
		wait( 0.1 );
	}
	
	// stop tallying dark kills when the lights come back up
	flag_set( "lights_back_on" );
}
// --- end metro arty impact stuff ---

event2_action_dialogue()
{
	trigger_wait( "trig_floodspawner_mgRight", "script_noteworthy" );
	
	// "The place is collapsing."
	level.sarge playsound_generic_facial( "Ber2_IGD_087A_REZN" );
	// "Move."
	level.sarge playsound_generic_facial( "Ber2_IGD_088A_REZN" );
	
	redshirt = get_randomfriend_notsarge_excluding( level.hero1 );
	// "We are going to be crushed - or buried alive!"
	redshirt playsound_generic_facial( "Ber2_IGD_089A_RUR2" );
	// "Move - faster!"
	level.sarge playsound_generic_facial( "Ber2_IGD_090A_REZN" );
	
	wait( 3 );
	
	// "We need to find a way out!"
	level.hero1 playsound_generic_facial( "Ber2_IGD_091A_CHER" );
	// "We will..."
	level.sarge playsound_generic_facial( "Ber2_IGD_092A_REZN" );
	// "There will be an exit at the other end of the platform!"
	level.sarge playsound_generic_facial( "Ber2_IGD_093A_REZN" );
	// "We will regroup there..."
	level.sarge playsound_generic_facial( "Ber2_IGD_202A_REZN" );
}


// --- DIFFERENT ANIMTREE ---
#using_animtree( "ber2_rat" );

metrowave_rat_anims( movetime )
{
	self endon( "rat_stop_anims" );
	
	self UseAnimTree( #animtree );
	
	fx_splash = level._effect["rat_splash"];
	waterHeight = -590;
	
	animHop = level.scr_anim["rat"]["hop_loop"];
	animRun = level.scr_anim["rat"]["run_loop"];
	hopChance = 65;  // percent out of 100
	
	anime = animHop;
	runTime = 2;
	
	while( 1 )
	{
		if( !IsDefined( self ) )
		{
			break;
		}
		
		if( RandomInt( 100 ) < hopChance )
		{
			if( !level.coopOptimize )
			{
				self thread metrowave_rat_anim_splash( fx_splash, waterHeight );
			}
			
			anime = animHop;
			self SetFlaggedAnimKnob( "rat_anim", anime, 1.0, 0.2, 1.0 );
			self waittillmatch( "rat_anim", "end" );
		}
		else
		{
			anime = animRun;
			endTime = GetTime() + ( RandomFloatRange( 0.5, 1.5 ) * 1000 );
			
			while( GetTime() < endTime )
			{
				if( !level.coopOptimize )
				{
					if( RandomInt( 100 ) < 25 )
					{
						PlayFX( fx_splash, ( self.origin[0], self.origin[1], waterHeight ) );
					}
				}
				
				self SetFlaggedAnimKnob( "rat_anim", anime, 1.0, 0.2, 1.0 );
				self waittillmatch( "rat_anim", "end" );
			}
		}
	}
}

metrowave_rat_anim_splash( fx_splash, waterHeight )
{
	wait( 0.1 );
	PlayFX( fx_splash, ( self.origin[0], self.origin[1], waterHeight ) );
	wait( 0.4 );
	PlayFX( fx_splash, ( self.origin[0], self.origin[1], waterHeight ) );
}


#using_animtree( "ber2_metro_exit_door" );

// self = the subway exit door
metro_exitdoor_anim( animeName )
{
	anime = undefined;
	
	switch( animeName )
	{
		case "doorstuck1":
			anime = level.scr_anim["metro_door_sbmodel"]["doorstuck1"];
			break;
			
		case "doorstuck2":
			anime = level.scr_anim["metro_door_sbmodel"]["doorstuck2"];
			break;
			
		case "doorstuck3":
			anime = level.scr_anim["metro_door_sbmodel"]["doorstuck3"];
			break;
			
		case "success":
			anime = level.scr_anim["metro_door_sbmodel"]["success"];
			break;
			
		default:
			ASSERTMSG( "metro_exitdoor_anim(): door animation type '" + animeName + "' not recognized." );
	}
	
	org = Spawn( "script_model", self.origin );
	org SetModel( "tag_origin_animate" );
	
	self LinkTo( org, "origin_animate_jnt" );
	
	org UseAnimTree( #animtree );
	org SetFlaggedAnimKnob( "metrodoor_anim", anime, 1.0, 0.2, 1.0 );
	org waittillmatch( "metrodoor_anim", "end" );
	
	self Unlink();
	wait( 0.1 );
	org Delete();
}
