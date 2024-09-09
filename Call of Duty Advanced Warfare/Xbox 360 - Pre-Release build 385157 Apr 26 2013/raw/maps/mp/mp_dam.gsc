#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	maps\mp\mp_dam_precache::main();
	maps\createart\mp_dam_art::main();
	maps\mp\mp_dam_fx::main();
	
	maps\mp\_load::main();
	
	AmbientPlay( "mp_dam_amb" );
	
    maps\mp\_compass::setupMiniMap( "compass_map_mp_dam" );	
	
	setdvar( "r_lightGridEnableTweaks", 1 );
	setdvar( "r_lightGridIntensity", 1.33 );
	
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	
	//Creating a function pointer for the map-based killstreak's init function. This function pointer will be called in _killstreaks.gsc.
	level.mp_dam_init_pointer = maps\mp\killstreaks\mp_dam::init;
	
	
	
	//mp_dam Dynamic Event
	
	//Crane0
	level.crane0 = SpawnStruct();
	
	level.crane0.pipe_start_radius_dvar = "mp_dam_pipe0_start_radius";
	level.crane0.pipe_end_radius_dvar = "mp_dam_pipe0_end_radius";
	level.crane0.pipe_start_height_dvar = "mp_dam_pipe0_start_height";
	level.crane0.pipe_end_height_dvar = "mp_dam_pipe0_end_height";
	level.crane0.start_angle_dvar = "mp_dam_crane0_start_angle";
	level.crane0.end_angle_dvar = "mp_dam_crane0_end_angle";
	level.crane0.time_dvar = "mp_dam_crane0_time";
	
	SetDvarIfUninitialized( level.crane0.pipe_start_radius_dvar, 1825 );
	SetDvarIfUninitialized( level.crane0.pipe_end_radius_dvar, 1250 );
	SetDvarIfUninitialized( level.crane0.pipe_start_height_dvar, 520 );
	SetDvarIfUninitialized( level.crane0.pipe_end_height_dvar, 470 );
	SetDvarIfUninitialized( level.crane0.start_angle_dvar, 42 );
	SetDvarIfUninitialized( level.crane0.end_angle_dvar, 60 );
	SetDvarIfUninitialized( level.crane0.time_dvar, 15 );
	
	level.crane0.radiusOscillator = spawn( "script_origin", ( 0, 0, 0 ) );
	level.crane0.heightOscillator = spawn( "script_origin", ( 0, 0, 0 ) );
	
	level.crane0.cab = GetEnt( "crane0cab", "targetname" );
	Assert( IsDefined( level.crane0.cab ) );
	level.crane0.cab.angles = ( 0, GetDvarInt( "mp_dam_crane0_start_angle", 130 ), 0 );
	
	level.crane0.platform = GetEnt( "crane0platform", "targetname" );
	Assert( IsDefined( level.crane0.platform ) );
	level.crane0.platform.angles = ( 0, GetDvarInt( "mp_dam_crane0_start_angle", 130 ), 0 );
	
	level.crane0.pipe = GetEnt( "crane0pipe", "targetname" );
	Assert( IsDefined( level.crane0.pipe ) );
	level.crane0.pipe.angles = ( 0, GetDvarInt( "mp_dam_crane0_start_angle", 130 ), 0 );
	
	level.crane0.pulley = GetEnt( "crane0pulley", "targetname" );
	Assert( IsDefined( level.crane0.pulley ) );
	level.crane0.pulley.angles = ( 0, GetDvarInt( "mp_dam_crane0_start_angle", 130 ), 0 );
	//Setting the initial position of the pulley. The z-coordinate is the most important.
	level.crane0.pulley.origin = ( -684.4, -1053.5, 1625.3 );
	
	level.crane0.hook = GetEnt( "crane0hook", "targetname" );
	Assert( IsDefined( level.crane0.hook ) );
	level.crane0.hook.angles = ( 0, GetDvarInt( "mp_dam_crane0_start_angle", 130 ), 0 );
	
	level.crane0.rope = GetEnt( "crane0rope", "targetname" );
	Assert( IsDefined( level.crane0.rope ) );
	
	
	//Crane1
	level.crane1 = SpawnStruct();
	
	level.crane1.pipe_start_radius_dvar = "mp_dam_pipe1_start_radius";
	level.crane1.pipe_end_radius_dvar = "mp_dam_pipe1_end_radius";
	level.crane1.pipe_start_height_dvar = "mp_dam_pipe1_start_height";
	level.crane1.pipe_end_height_dvar = "mp_dam_pipe1_end_height";
	level.crane1.start_angle_dvar = "mp_dam_crane1_start_angle";
	level.crane1.end_angle_dvar = "mp_dam_crane1_end_angle";
	level.crane1.time_dvar = "mp_dam_crane1_time";
	
	SetDvarIfUninitialized( level.crane1.pipe_start_radius_dvar, 490 );
	SetDvarIfUninitialized( level.crane1.pipe_end_radius_dvar, 600 );
	SetDvarIfUninitialized( level.crane1.pipe_start_height_dvar, 500 );
	SetDvarIfUninitialized( level.crane1.pipe_end_height_dvar, 400 );
	SetDvarIfUninitialized( level.crane1.start_angle_dvar, 235 );
	SetDvarIfUninitialized( level.crane1.end_angle_dvar, 250 );
	SetDvarIfUninitialized( level.crane1.time_dvar, 10 );
	
	level.crane1.radiusOscillator = spawn( "script_origin", ( 0, 0, 0 ) );
	level.crane1.heightOscillator = spawn( "script_origin", ( 0, 0, 0 ) );
	
	level.crane1.cab = GetEnt( "crane1cab", "targetname" );
	Assert( IsDefined( level.crane1.cab ) );
	level.crane1.cab.angles = ( 0, GetDvarInt( "mp_dam_crane1_start_angle", 130 ), 0 );
	
	level.crane1.platform = GetEnt( "crane1platform", "targetname" );
	Assert( IsDefined( level.crane1.platform ) );
	level.crane1.platform.angles = ( 0, GetDvarInt( "mp_dam_crane1_start_angle", 130 ), 0 );
	
	level.crane1.pipe = GetEnt( "crane1pipe", "targetname" );
	Assert( IsDefined( level.crane1.pipe ) );
	level.crane1.pipe.angles = ( 0, GetDvarInt( "mp_dam_crane1_start_angle", 130 ), 0 );
	
	level.crane1.pulley = GetEnt( "crane1pulley", "targetname" );
	Assert( IsDefined( level.crane1.pulley ) );
	level.crane1.pulley.angles = ( 0, GetDvarInt( "mp_dam_crane1_start_angle", 130 ), 0 );
	//Setting the initial position of the pulley. The z-coordinate is the most important.
	level.crane1.pulley.origin = ( 568.4, 20.2, 1669.3 );
	
	level.crane1.hook = GetEnt( "crane1hook", "targetname" );
	Assert( IsDefined( level.crane1.hook ) );
	level.crane1.hook.angles = ( 0, GetDvarInt( "mp_dam_crane1_start_angle", 130 ), 0 );
	
	level.crane1.rope = GetEnt( "crane1rope", "targetname" );
	Assert( IsDefined( level.crane1.rope ) );
	//////////////////////////
	
	
	
	//Preparing assets for the Dam power surge.
	level.mp_dam_fx[ "dam_surge_sparks" ] = LoadFX( "vfx/sparks/vehicle_damaged_sparks_l" );
	level.mp_dam_fx[ "dam_surge_arcs" ] = LoadFX( "fx/misc/electrical_arc" );
	level.mp_dam_fx[ "dam_surge_smoke" ] = LoadFX( "fx/smoke/smoke_grenade" );
	
	
	
	//Dvars
	SetDvarIfUninitialized( "mp_dam_surge_interval", 50 );
	SetDvarIfUninitialized( "mp_dam_surge_duration", 30 );
	SetDvarIfUninitialized( "mp_dam_surge_delay", 7 );
	
	
	
	//Get script_origins for attaching spark vfx.
	level.spark_origin_tags = [];		//An array that will hold our tag origins for attaching spark vfx.
	spark_origins = GetEntArray( "surge_sparks", "targetname" );
	if ( spark_origins.size > 0 )
	{
		foreach( spark_origin in spark_origins )
		{
			level.spark_origin_tags[ level.spark_origin_tags.size ] = spawn_tag_origin();
			level.spark_origin_tags[ level.spark_origin_tags.size - 1 ].origin = spark_origin.origin;
			level.spark_origin_tags[ level.spark_origin_tags.size - 1 ].angles = spark_origin.angles;
			//We have to show the tag to see FX played on it.
			level.spark_origin_tags[ level.spark_origin_tags.size - 1 ] Show();
		}
	}
	
	//Get the script_origins for attaching smoke vfx.
	level.smoke_origin_tags = [];
	smoke_origins = GetEntArray( "surge_smoke", "targetname" );
	if ( smoke_origins.size > 0 )
	{
		foreach( smoke_origin in smoke_origins )
		{
			level.smoke_origin_tags[ level.smoke_origin_tags.size ] = spawn_tag_origin();
			level.smoke_origin_tags[ level.smoke_origin_tags.size - 1 ].origin = smoke_origin.origin;
			level.smoke_origin_tags[ level.smoke_origin_tags.size - 1 ].angles = smoke_origin.angles;
			//We have to show the tag to see FX played on it.
			level.smoke_origin_tags[ level.smoke_origin_tags.size - 1 ] Show();
		}
	}
	
	//Get the script_origins for attaching spark and electricity vfx.
	level.elec_sparks_origin_tags = [];
	spark_sfx_origins = GetEntArray( "elec_spark_sfx_origin", "targetname" );
	if ( spark_sfx_origins.size > 0 )
	{
		foreach( spark_sfx_origin in spark_sfx_origins )
		{
			level.elec_sparks_origin_tags[ level.elec_sparks_origin_tags.size ] = spawn_tag_origin();
			level.elec_sparks_origin_tags[ level.elec_sparks_origin_tags.size - 1 ].origin = spark_sfx_origin.origin;
			level.elec_sparks_origin_tags[ level.elec_sparks_origin_tags.size - 1 ].angles = spark_sfx_origin.angles;
		}
	}
	
	//Get the script_origins for playing PA System VO.
	level.surge_vo_origin_tags = [];
	pa_system_origins = GetEntArray( "surge_vo_speaker", "targetname" );
	if ( pa_system_origins.size > 0 )
	{
		foreach( pa_system_origin in pa_system_origins )
		{
			level.surge_vo_origin_tags[ level.surge_vo_origin_tags.size ] = spawn_tag_origin();
			level.surge_vo_origin_tags[ level.surge_vo_origin_tags.size - 1 ].origin = pa_system_origin.origin;
			level.surge_vo_origin_tags[ level.surge_vo_origin_tags.size - 1 ].angles = pa_system_origin.angles;
			//We have to show the tag to see FX played on it.
			level.surge_vo_origin_tags[ level.surge_vo_origin_tags.size - 1 ] Show();
		}
	}
	
	
	
	//Get the trigger volumes that we will use to stun the player.
	level.dam_surge_triggers = [];
	level.dam_surge_triggers = GetEntArray( "surge_triggers", "targetname" );
	
	
	
	//SFX
	level.surge_fan_noise = "orbital_laser";		//TODO: Request SFX from Audio
	level.surge_sparks_noise = "mp_dam_surge_sparks";		//TODO: Request SFX from Audio
	level.pa_warning0 = "mp_dam_warning0";		//TODO: Request SFX from Audio
	level.pa_warning1 = "mp_dam_warning1";		//TODO: Request SFX from Audio
	
	
	
	level.power_surge_active = false;
	
	thread rotateGenerators();
	thread handlePowerSurge();
	thread handlePowerSurgeDamage();
	level.crane0 thread rotateCrane();
	level.crane0 thread moveCranePipe();
	level.crane1 thread rotateCrane();
	level.crane1 thread moveCranePipe();
}

rotateGenerators()
{
	fans = getentarray( "generator_fan", "targetname" );
	
	foreach( fan in fans )
	{
		fan thread rotateFan();
	}
}

rotateFan()
{
	if ( !IsDefined( level.genrotatetime ) )
	{
		level.genrotatetime = 1;
	}
	
	while( 1 )
	{
		self rotateto( ( self.angles[0], self.angles[1] + 180, self.angles[2] ), level.genrotatetime );
		wait level.genrotatetime;
	}
}


/*
=============
///ScriptDocBegin
"Name: rotateCrane()"
"Summary: rotates a crane in mp_dam"
"Module: Entity"
"CallOn: level"
"Example: level.crane1 thread rotateCrane();
"SPMP: MP"
///ScriptDocEnd
=============
*/
rotateCrane()
{
	level endon( "game_ended" );
	
	while ( 1 )
	{
		//Swings back...
		self.cab RotateTo( ( 0, GetDvarInt( self.end_angle_dvar, 180 ) , 0 ), GetDvarInt( self.time_dvar, 10 ), 1, 1 );
		
		self.platform RotateTo( ( 0, GetDvarInt( self.end_angle_dvar, 180 ), 0 ), GetDvarInt( self.time_dvar, 10 ), 1, 1 );
		
		self.pipe RotateTo( ( 0, GetDvarInt( self.end_angle_dvar, 180 ), 0 ), GetDvarInt( self.time_dvar, 10 ), 1, 1 );
		
		self.pulley RotateTo( ( 0, GetDvarInt( self.end_angle_dvar, 180 ), 0 ), GetDvarInt( self.time_dvar, 10 ), 1, 1 );
		
		self.hook RotateTo( ( 0, GetDvarInt( self.end_angle_dvar, 180 ), 0 ), GetDvarInt( self.time_dvar, 10 ), 1, 1 );
		
		self.heightOscillator MoveTo( (0, 0, GetDvarInt( self.pipe_end_height_dvar, 0 ) ), GetDvarInt( self.time_dvar, 10 ), 1, 1 );
		
		self.radiusOscillator MoveTo( (0, 0, GetDvarInt( self.pipe_end_radius_dvar, 0 ) ), GetDvarInt( self.time_dvar, 10 ), 1, 1 );
		
		wait( GetDvarInt( self.time_dvar, 10 ) + 5 );
		
		//Swings forth...
		self.cab RotateTo( ( 0, GetDvarInt( self.start_angle_dvar, 130 ), 0 ), GetDvarInt( self.time_dvar, 10 ), 1, 1 );
		
		self.platform RotateTo( ( 0, GetDvarInt( self.start_angle_dvar, 130 ), 0 ), GetDvarInt( self.time_dvar, 10 ), 1, 1 );
		
		self.pipe RotateTo( ( 0, GetDvarInt( self.start_angle_dvar, 130 ), 0 ), GetDvarInt( self.time_dvar, 10 ), 1, 1 );
		
		self.pulley RotateTo( ( 0, GetDvarInt( self.start_angle_dvar, 130 ), 0 ), GetDvarInt( self.time_dvar, 10 ), 1, 1 );
		
		self.hook RotateTo( ( 0, GetDvarInt( self.start_angle_dvar, 130 ), 0 ), GetDvarInt( self.time_dvar, 10 ), 1, 1 );
		
		self.heightOscillator MoveTo( (0, 0, GetDvarInt( self.pipe_start_height_dvar, 0 ) ), GetDvarInt( self.time_dvar, 10 ), 1, 1 );
		
		self.radiusOscillator MoveTo( (0, 0, GetDvarInt( self.pipe_start_radius_dvar, 0 ) ), GetDvarInt( self.time_dvar, 10 ), 1, 1 );
		
		wait( GetDvarInt( self.time_dvar, 10 ) + 5 );
	}
}


/*
=============
///ScriptDocBegin
"Name: moveCranePipe()"
"Summary: moves the crane pipe to match the rotation of crane cab and platform."
"Module: Entity"
"CallOn: a crane struct that contains a 'pipe' script_brushmodel"
"Example: level.crane1 thread moveCranePipe();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
moveCranePipe()
{
	level endon( "game_ended" );
	
	while ( 1 )
	{
		temp_origin_vec = ( Cos( self.platform.angles[1] + 90 ) * self.radiusoscillator.origin[2] + self.cab.origin[0], Sin( self.platform.angles[1] + 90 ) * self.radiusoscillator.origin[2] + self.cab.origin[1], self.heightOscillator.origin[2] );
//		level.crane1pipe.origin = temp_origin_vec;
		self.pipe MoveTo( temp_origin_vec, 0.05, 0.025, 0.025 );
		
		//Do not move the pulley on the z-axis. The crane does not tilt up and down.
		self.pulley MoveTo( ( temp_origin_vec[0], temp_origin_vec[1], self.pulley.origin[2] ), 0.05, 0.025, 0.025 );
		
		self.hook MoveTo( temp_origin_vec + ( 0, 0, 270 ), 0.05, 0.025, 0.025 );
		
		wait( 0.05 );
	}
}


/*
=============
///ScriptDocBegin
"Name: handlePowerSurge()"
"Summary: starts VFX, sound and other events associated with the mp_dam power surge"
"Module: Entity"
"CallOn: An entity"
"Example: thread handlePowerSurge()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
handlePowerSurge()
{
	while ( true )
	{
		//The gap in time between surges.
		wait( GetDvarInt( "mp_dam_surge_interval", 50 ) );
		
		//Start harmless sparks without damage. This is a warning for players to run!
		//Play spark vfx on spark tag origins.
		foreach( sparktag in level.spark_origin_tags )
		{
			PlayFXOnTag( level.mp_dam_fx[ "dam_surge_sparks" ], sparktag, "tag_origin" );
		}
		foreach( pasystemtag in level.surge_vo_origin_tags )
		{
			pasystemtag thread play_sound_on_tag( level.pa_warning0, "tag_origin" );
		}
		
		
		
		//Wait another 5 seconds before triggering electric arcs and damage.
		wait( GetDvarInt( "mp_dam_surge_delay", 7 ) );
		
		level.power_surge_active = true;
		
		//Double the rotation speed of the generators.
		level.genrotatetime = 0.5;
		
		//Play electric arc vfx on spark tag origins.
		foreach( sparktag in level.spark_origin_tags )
		{
			PlayFXOnTag( level.mp_dam_fx[ "dam_surge_arcs" ], sparktag, "tag_origin" );
		}
		foreach( smoketag in level.smoke_origin_tags )
		{
//			PlayFXOnTag( level.mp_dam_fx[ "dam_surge_smoke" ], smoketag, "tag_origin" );
			
			//Start SFX associated with the faster fan rotation.
//			smoketag thread play_loop_sound_on_entity( level.surge_fan_noise );
		}
		foreach( sparksfxtag in level.elec_sparks_origin_tags )
		{
			sparksfxtag thread play_loop_sound_on_entity( level.surge_sparks_noise );
		}
		foreach( pasystemtag in level.surge_vo_origin_tags )
		{
			pasystemtag thread play_sound_on_tag( level.pa_warning1, "tag_origin" );
		}
		
		
		
		wait( GetDvarInt( "mp_dam_surge_duration", 30 ) );
		
		level.power_surge_active = false;
		
		//Reset generator rotation speed.
		level.genrotatetime = 1;
		
		//Stop spark vfx on spark tag origins.
		foreach( sparktag in level.spark_origin_tags )
		{
			StopFXOnTag( level.mp_dam_fx[ "dam_surge_sparks" ], sparktag, "tag_origin" );
			StopFXOnTag( level.mp_dam_fx[ "dam_surge_arcs" ], sparktag, "tag_origin" );
		}
		foreach( smoketag in level.smoke_origin_tags )
		{
//			StopFXOnTag( level.mp_dam_fx[ "dam_surge_smoke" ], smoketag, "tag_origin" );
			
			//Stop SFX associated with the faster fan rotation.
//			smoketag thread stop_loop_sound_on_entity( level.surge_fan_noise );
		}
		foreach( sparksfxtag in level.elec_sparks_origin_tags )
		{
			sparksfxtag thread stop_loop_sound_on_entity( level.surge_sparks_noise );
		}
		
		wait( 0.05 );
	}
}


/*
=============
///ScriptDocBegin
"Name: handlePowerSurgeDamage()"
"Summary: checks whether the power surge is currently underway. If yes, damages players touching surge triggers."
"Module: Entity"
"CallOn: An entity"
"Example: thread handlePowerSurgeDamage()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
handlePowerSurgeDamage()
{
	while ( true )
	{
		if ( level.power_surge_active == true )
		{
			foreach( player in level.players )
			{
				foreach( trigmult in level.dam_surge_triggers )
				{
					if ( player IsTouching( trigmult ) )
					{
						player PlayRumbleOnEntity( "damage_heavy" );
						player shellshock( "orbital_laser_mp", 1 );		//TODO: add a solar reflector .shock file if we ultimately want to keep that effect.
						player DoDamage( 5, player.origin );
					}
				}
			}
		}
		wait( 0.05 );
	}
}
