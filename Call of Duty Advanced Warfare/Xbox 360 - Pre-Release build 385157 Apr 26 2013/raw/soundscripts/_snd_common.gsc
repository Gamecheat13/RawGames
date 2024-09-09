#include soundscripts\_snd;
#include soundscripts\_snd_playsound;
#include soundscripts\_audio;
#include common_scripts\utility;
#include soundscripts\_audio_mix_manager;

//////////////////////////////////////////////////////////////////////////////
// _snd_common.gsc
// 
// This scriptfile is intended for common scripting for blacksmith (S1).
// This file is for sound designers to add message handlers or for minor
// prototype scripting systems, etc. Core systems go in their own files and
// need to be approved by the audio engineer and audio director.
//////////////////////////////////////////////////////////////////////////////
 
snd_common_init()
{
	register_common_snd_messages();
	create_common_envelop_arrays();
}

create_common_envelop_arrays()
{
	level._snd.envs[ "explo_shake_over_distance" ] =
	[	
		[0.000,	1.00],
		[0.250,	0.65],
		[0.350,	0.50],
		[0.750,	0.20],
		[1.000,	0.10]
	]; 

	level._snd.envs[ "veh_crash_intensity_to_pitch" ] =
	[	
		[0.0,	0.7],
		[0.1,	0.7],
		[0.5,	0.8],
		[0.9,	1.0],
		[1.0,	1.1]
	]; 

	level._snd.envs[ "veh_crash_vel_to_lfe_vol" ] =
	[	
		[0.0,	0.00],
		[200,	0.05],
		[500,	0.25],
		[850,	0.35],
		[1000,	0.60]
	]; 
}

init_ambient_explosion_arrays()
{
	level._snd.ambientExp[ "exp_generic_explo_shot" ] =
	[	
		["exp_generic_explo_shot_01",	0.13],
		["exp_generic_explo_shot_02",	0.13],
		["exp_generic_explo_shot_03",	0.12],
		["exp_generic_explo_shot_04",	0.17],
		["exp_generic_explo_shot_05",	0.16],
		["exp_generic_explo_shot_06",	0.14],
		["exp_generic_explo_shot_07",	0.11],
		["exp_generic_explo_shot_08",	0.21],
		["exp_generic_explo_shot_09",	0.16],
		["exp_generic_explo_shot_10",	0.22],
		["exp_generic_explo_shot_11",	0.13],
		["exp_generic_explo_shot_12",	0.15],
		["exp_generic_explo_shot_13",	0.08],
		["exp_generic_explo_shot_14",	0.11],
		["exp_generic_explo_shot_15",	0.16],
		["exp_generic_explo_shot_16",	0.10]	
	]; 
}

init_impact_system_arrays()
{
	//Define supported material types
	
	level._snd.veh_collision.surfaces =
	[	
		"vehicle", //surface designated as "none" in game.  VFX Supported
		"bark", //VFX Supported
		"brick", //VFX Supported
		"asphalt", //VFX Supported
		"concrete", //VFX Supported
		"dirt", //VFX Supported
//		"foliage",
		"glass",
//		"gravel",
//		"ice",
		"metal",
//		"plaster",
		"rock",
//		"snow",
//		"wood",
//		"ceramic",
//		"plastic",
		"paintedmetal",
		"riotshield"
	];
}

init_boost_land_arrays()
{
	//Define supported material types
	
	level._snd.boost_jump.surfaces =
	[	
		"vehicle", //surface designated as "ice" in game.
		"asphalt", 
		"concrete",
		"metal"
//		"bark",
//		"brick",
//		"dirt",
//		"foliage",
//		"glass",
//		"gravel",
//		"ice",
//		"plaster",
//		"rock",
//		"snow",
//		"wood",
//		"ceramic",
//		"plastic",
//		"paintedmetal",
//		"riotshield"
	];
}
//////////////////////////////////////////////////////////////////////////////
// COMMON MESSAGE HANDLERS
//////////////////////////////////////////////////////////////////////////////

register_common_snd_messages()
{
	//M160 Directed Energy Weapon Proto.
	snd_register_message( "wpn_deam160_init",					::wpn_deam160_init );	
	snd_register_message( "wpn_deam160_charge",					::wpn_deam160_charge );		
	snd_register_message( "wpn_deam160_charge_dots_increase",	::wpn_deam160_charge_dots_increase );
	snd_register_message( "wpn_deam160_full_charge",			::wpn_deam160_full_charge );		
	snd_register_message( "wpn_deam160_shot",					::wpn_deam160_shot );	
	
	// Variable Grenade Script Proto.
	snd_register_message( "variable_grenade_type_switch",		::variable_grenade_type_switch);		
	snd_register_message( "paint_grenade_detonate",				::paint_grenade_detonate);		
	snd_register_message( "emp_grenade_detonate",				::emp_grenade_detonate );

	// Sonar Vision Proto.
	snd_register_message( "aud_sonar_vision_on", 				::aud_sonar_vision_on);
	snd_register_message( "aud_sonar_vision_off", 				::aud_sonar_vision_off);
	
	//Generic Ambient Explosions Script Proto.
	snd_register_message( "explo_ambientExp_dirt",				::explo_ambientExp_dirt );
	snd_register_message( "explo_ambientExp_fireball",			::explo_ambientExp_fireball );

	//Vehicle Impact System Script Proto.
	snd_register_message( "play_vehicle_collision",				::snd_play_vehicle_collision );

	//Boost Jump System Script Proto.
	snd_register_message( "boost_jump_enable",					::boost_jump_enable );
	snd_register_message( "boost_jump_disable",					::boost_jump_disable );	
	snd_register_message( "boost_jump_disable_npc",				::boost_jump_disable_npc );	
	snd_register_message( "boost_jump_player",					::boost_jump_player );
	snd_register_message( "boost_land_player",					::boost_land_player );	
	snd_register_message( "boost_jump_npc",						::boost_jump_npc );
	snd_register_message( "boost_land_npc",						::boost_land_npc );
	
	// PDRONE DEATH
	snd_register_message( "pdrone_death_explode",				::pdrone_death_explode );	
	snd_register_message( "pdrone_emp_death",					::pdrone_emp_death );		
}

/////////////////////////
//DEAM 160 ENERGY WEAPON
////////////////////////

wpn_deam160_init()
{
	level.wpn_deam160_aud_charges = 0;	
}

wpn_deam160_shot( args )
{
	shot_size = args;
	level.wpn_deam160_aud_charges = 0; //Reset charge counter when player shoots.
	
	switch( shot_size )
	{
		case "large":
			aud_play_2d_sound("wpn_deam160_shot_max");
			level notify("aud_deam160_charge_break");
		break;
		
		case "medium":
			aud_play_2d_sound("wpn_deam160_shot_med");
			level notify("aud_deam160_charge_break");
		break;
		
		case "small":
			aud_play_2d_sound("wpn_deam160_shot_sml");
			level notify("aud_deam160_charge_break");
		break;
	}
}

wpn_deam160_charge( args )
{
	//Play Oneshot Charge SFX.
	charge_sfx = aud_play_linked_sound("wpn_deam160_charge_hi", level.player, "oneshot");
	thread wpn_deam160_play_charge_loop_sfx();
	level.player thread wpn_deam160_watch_weapon_change();
	level.player thread wpn_deam160_is_chargeable();
	
	level waittill("aud_deam160_charge_break");
	
	//Stop Charge SFX
	if(isDefined(charge_sfx))
	{
		charge_sfx ScaleVolume(0, 0.05);		
	}

}

wpn_deam160_watch_weapon_change()
{
	level endon( "aud_deam160_charge_break" );
	while(1)
	{
		if ( self IsThrowingGrenade() || self IsReloading() || self IsMeleeing() || self IsMantling() )
		{
			level notify( "aud_deam160_charge_break" );
			break;
		}	
		
		wait(0.05);
	}
}

wpn_deam160_is_chargeable()
{
	level endon( "aud_deam160_charge_break" );
	
	while(1)
	{
		weapon_is_chargeable = WeaponIsChargeable( self GetCurrentWeapon() );
	
		if( !weapon_is_chargeable )
		{
			level notify( "aud_deam160_charge_break" );
			break;
		}	
		wait(0.05);
	}
}

wpn_deam160_play_charge_loop_sfx()
{
	level endon("aud_deam160_charge_break");
	
	charge_loop_sfx = aud_play_linked_sound("wpn_deam160_charge_hi_lp", level.player, "loop", "aud_deam160_charge_break");	
	charge_loop_sfx scalevolume(0, 0.05);
	wait(2);
	if(IsDefined(charge_loop_sfx))
	{
		charge_loop_sfx scalevolume(1, 0.4);		
	}
}

wpn_deam160_charge_dots_increase( args )
{	
	level.wpn_deam160_aud_charges++;
	//iprintlnbold(level.wpn_deam160_aud_charges);	
}


wpn_deam160_full_charge()
{
	full_charge_beeps = aud_play_linked_sound("wpn_deam160_full_charge_beep_lp", level.player, "loop", "aud_deam160_charge_break");
	level waittill("aud_deam160_charge_break");
}

/////////////////////////
//VARIABLE GRENADES
////////////////////////

variable_grenade_type_switch( args )
{
	level.aud_var_nade_type = args;
	aud_play_2d_sound( "var_grenade_change_type" );	
}

paint_grenade_detonate()
{
	nade = self;
	level.player playsound( "paint_grenade_scan" );	
}

emp_grenade_detonate()
{
	nade = self;
	level.player playsound( "emp_grenade_exp" );
}

/////////////////////////
//SONAR VISION
////////////////////////

aud_sonar_vision_on()
{
	MM_add_submix( "sonar_vision", 0.05 );
	aud_play_2d_sound( "sonar_vision_on" );
}

aud_sonar_vision_off()
{
	aud_play_2d_sound( "sonar_vision_off" );
	MM_clear_submix( "sonar_vision", 1.0 );
}

/////////////////////////
//PDRONE DEATH
////////////////////////
pdrone_death_explode()
{
	 aud_play_linked_sound( "pdrone_exp", self );
}

pdrone_emp_death()
{
	aud_play_linked_sound( "pdrone_emp_death", self );	
}

/////////////////////////
//BOOST JUMP
////////////////////////

boost_jump_enable()
{
	curr_time = GetTime();
	if ( curr_time > 1000 ) //Prevent the sound from playing at the very start of a level during the level setup business.
		aud_play_2d_sound( "tac_pc_boost_power_up" );
}

boost_jump_disable()
{
	aud_play_2d_sound( "tac_pc_boost_power_down" );		
}

boost_jump_disable_npc( guy )
{
	jumper = guy;
	aud_play_linked_sound( "tac_npc_boost_power_dwn", jumper );
	IPrintLnBold( "booster_off" );
}

boost_jump_player()
{
	if ( !IsDefined( level._snd.boost_jump ) )
	{
		level._snd.boost_jump = spawnstruct();
		level._snd.boost_jump.is_jumping = false;
		thread init_boost_land_arrays();
	}

	jumper = self;
	if ( jumper == level.player )
	{
		jump_sound = aud_play_2d_sound( "tac_pc_boost_jump_exo" );
		level._snd.boost_jump.is_jumping = true;
		level._snd.boost_jump.jump_sound = jump_sound;
	}
}

boost_land_player( hang_time )
{
	if ( !IsDefined( level._snd.boost_jump ) )
	{
		level._snd.boost_jump = spawnstruct();
		level._snd.boost_jump.is_jumping = false;
		thread init_boost_land_arrays();
	}
	
	jumper = self;
	if ( jumper == level.player ) 
	{
		if ( level._snd.boost_jump.is_jumping == true )
		{
			//Play exo land sound on every landing regardless of surface type.
			land_sound = aud_play_2d_sound( "tac_pc_boost_land_exo" );
	
			/// Kill boost jump sounds after land.
			level._snd.boost_jump.is_jumping = false;
			
			if ( IsDefined( level._snd.boost_jump.jump_sound ) )
			{
				aud_fade_out_and_delete( level._snd.boost_jump.jump_sound, 0.2 );	
			}
		}
		////////////////////////////////////////////////////////////////
		/// Play a surface specific landing sound on supported surfaces.
		///////////////////////////////////////////////////////////////
		max_hang_time = 40;
		min_hang_time = 10;

		if ( hang_time < min_hang_time )
			return;
		
		//Get surface type of landing location via ray trace.
		surface = PlayerPhysicsTraceInfo(jumper.origin + (0, 0, 16), jumper.origin + (0, 0, -16), jumper)["surfacetype"];
	
		/// Handle special case material types.
		// Contact with vehicles will return “clip_nosight_ice”.
		if ( surface == "ice" )
		{
			surface = "vehicle";	
		}
	
		//IPrintLnBold( hang_time + " || " + surface );
	
		//Validate that surface is supported.
		surface_exists = sndx_boost_land_is_valid_surface( surface );
	
		//Play surface specific landing sound if surface is supported.
		if ( surface_exists )
		{
			//Determine impact volume of surface sound based on fall height.
			impact_volume = sndx_boost_land_get_impact_vol( hang_time, max_hang_time, min_hang_time );		
	
			surface_alias_name = ( "tac_boost_land_surface_" + surface );
			surface_sound = aud_play_2d_sound( surface_alias_name );		
	
			surface_sound ScaleVolume( impact_volume, 0.1 );					
			//surface_sound ScalePitch( impact_pitch, 0.1 );
		}
	}
}

sndx_boost_land_is_valid_surface( value )
{
	assert( IsDefined( level._snd.boost_jump.surfaces ) );
	surface_exists = false;
	for ( index = 0; index < level._snd.boost_jump.surfaces.size; index++ )
	{
		if (value == level._snd.boost_jump.surfaces[ index ] )
		{
			surface_exists = true;
			break;
		}
	}
	
	return surface_exists;
}

sndx_boost_land_get_impact_vol( input, max_hang_time, min_hang_time )
{
	input = clamp( input, min_hang_time, max_hang_time );	

	impact_volume = ( input /  max_hang_time );
	
	return impact_volume;
}

boost_jump_npc()
{
	jumper = self;
	//jumper thread aud_print_3d_on_ent( "Boost Jump", 2, "blue", undefined, 0.5 );
	aud_play_linked_sound( "tac_boost_jump_exo", jumper );
}

boost_land_npc()
{
	jumper = self;
	//jumper thread aud_print_3d_on_ent( "Boost Land", 2, "red", undefined, 0.5 );
	aud_play_linked_sound( "tac_boost_land_exo", jumper );
}

////////////////////////////
//GENERIC AMBIENT EXPLOSIONS
///////////////////////////

explo_ambientExp_dirt( pos, exploder_num )
{
	explo_params = SpawnStruct();
	explo_params.pos 							= pos;
	explo_params.exploder_num_ 					= exploder_num;
	explo_params.incoming_alias_ 				= "exp_generic_incoming";
	explo_params.speed_of_sound_	 			= true;
	explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
	explo_params.duck_dist_threshold_ 			= 1000;
	explo_params.explo_delay_chance_ 			= 60;
	explo_params.shake_dist_threshold_ 			= 2000;
	explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
	explo_params.ground_zero_alias_ 			= "exp_grnd_zero_stone"; 
	explo_params.ground_zero_dist_threshold_ 	= 500; 
 
	snd_ambient_explosion( explo_params );
}

explo_ambientExp_fireball( args )
{
	explo_params = SpawnStruct();
	explo_params.pos 							= args;
	explo_params.speed_of_sound_	 			= true;
	explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
	explo_params.duck_dist_threshold_ 			= 1000;
	explo_params.explo_delay_chance_ 			= 60;
	explo_params.shake_dist_threshold_ 			= 2000;
	explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
	explo_params.ground_zero_alias_ 			= "exp_grnd_zero_stone"; 
	explo_params.ground_zero_dist_threshold_ 	= 500; 
 
	snd_ambient_explosion( explo_params );
}


//////////////////////////////////////////////////////////////////////////////
// SMALL COMMON SYSTEMS UTILS
//////////////////////////////////////////////////////////////////////////////

/*
///ScriptDocBegin
"Name: snd_air_vehicle_smart_flyby(alias_name, distance_threshold, print_distance_, dist3d_, deathspin_alias_name_)"
"Summary: Plays a flyby alias when the air vehicle is within a specified distance to the player."
"Module: Audio"
"CallOn: The vehicle entity you wish to play the flyby sound on."
"MandatoryArg: <alias_name> : Alias name for the flyby sound."
"MandatoryArg: <distance_threshold> : The distance between the vehicle and the player at which you want the flyby alias to be played."
"OptionalArg: <print_distance_> : Set to true in order to turn on debug text showing distance-delta between vehicle entity and player.
"OptionalArg: <dist3d_> : Set to true if distance calculation should include vehicle altitude.  Default is false (dist2d).
"OptionalArg: <deathspin_alias_name_> : Alias name for deathspin sound.
"SPMP: singleplayer"
///ScriptDocEnd
*/
snd_air_vehicle_smart_flyby(alias_name, distance_threshold, print_distance_, dist3d_, deathspin_alias_name_)
{
	assert(IsDefined(self));
	assert(IsDefined(alias_name));
	assert(IsDefined(distance_threshold));
	
	debug_print = false;
	if (IsDefined(print_distance_))
	{
		debug_print = print_distance_;
	}

	distance3D = false;
	if (IsDefined(dist3d_))
	{
		distance3D = dist3d_;
	}

	while(isdefined(self))
	{
		if (distance3D)
		{
			dist = Distance( self.origin, level.player.origin ); //Test to see if vehicle is within range of player
		}
		else
		{
			dist = Distance2D( self.origin, level.player.origin ); //Test to see if vehicle is within range of player				
		}

		if (debug_print)
		{
			iprintln("Distance: " + dist);
		}
						
		if ( dist < distance_threshold )  //If vehicle is within range of player, play the flyby sound
		{
			flyby_ent = spawn("script_origin", self.origin);
			flyby_ent linkto( self );
			flyby_ent playsound(alias_name, "sounddone");
			flyby_ent thread sndx_air_vehicle_smart_flyby_deathspin(self, deathspin_alias_name_);
			flyby_ent thread sndx_air_vehicle_smart_flyby_sounddone();
			flyby_ent waittill("flyby_ent", whathappened);

			if (whathappened == "deathspin")  //If vehicle is shot down then stop the flyby sound 
			{
				flyby_ent scalevolume(0.0, 0.3);
				wait(0.4);
				flyby_ent stopsounds();
				flyby_ent delete();
				return;
			}
			else if (whathappened == "sounddone") //Cleanup if flyby sound completes without vehicle being shot down
			{
				wait(0.1);
				flyby_ent delete();
				return;
			}
		}
		else
		{
			wait(0.05);
		}
	}
}

sndx_air_vehicle_smart_flyby_deathspin(entity, deathspin_alias_name_) //waittill_deathspin
{
	self endon("flyby_ent");
	entity waittill("deathspin");
	self notify("flyby_ent", "deathspin");

	if (IsDefined(deathspin_alias_name_))
	{
		flyby_explo = spawn("script_origin", self.origin);
		flyby_explo linkto( self );
		flyby_explo playsound(deathspin_alias_name_, "sounddone");
		flyby_explo waittill("sounddone");
		flyby_explo Delete();
	}
}

sndx_air_vehicle_smart_flyby_sounddone() //waittill_sounddone
{
	self endon("flyby_ent");
	self waittill("sounddone");
	self notify("flyby_ent", "sounddone");
}


/*
///ScriptDocBegin
"Name: snd_ambient_explosion(pos, shake_distance_threshold_, explo_debris_alias_)"
"Summary: Plays a random explosion shot/tail combination and delays the tail alias by a unique ammount specific to the shot.  Also plays a screen-shake where the shake intensity is mapped to the distance between the player and the explosion.  Plays an optional debris alias."
"Module: Audio"
"CallOn: Nothing."
"MandatoryArg: <pos> : Origin of the explosion."
"OptionalArg: <speed_of_sound_> : Set to true to add appropriate delay to explosion sounds to account for speed of sound."
"OptionalArg: <explo_shot_array_> : An array consisting of shot aliases and tail delay times.  Example:  ["exp_generic_explo_shot_01",	0.13].  Undefined defaults to level._snd.ambientExp[ "exp_generic_explo_shot" ]."
"OptionalArg: <duck_alias_> : Alias that has a master priority set to duck all all other aliases for the durration of the duck alias.  This is intended to be a short sample.  Undefined deactives the duck."
"OptionalArg: <duck_dist_threshold_> : The max distance between the explosion and the player where the duck_alias_ will play.  Undefined defaults to 1000."
"OptionalArg: <explo_delay_chance_> : Percentage that will dictate the probability of using the tail_delay_time, defined in the explo_shot_array_.  100 will ensure the tail_delay_time is always used.   Undefined defaults to 50."
"OptionalArg: <explo_tail_alias_> : Alias of explo_tail layer.  Undefined defaults to exp_generic_explo_tail."
"OptionalArg: <shake_dist_threshold_> : The max distance between the explosion and the player where a screen-shake will still occur.  Undefined deactivates shake."
"OptionalArg: <shake_envelope_> : Envelope for mapping distance to shake scale.  Undefined defaults to level._snd.envs[ "explo_shake_over_distance" ]."
"OptionalArg: <shake_durration_> : Durration of screen shake.  Undefined defaults to 0.5 seconds."
"OptionalArg: <explo_debris_alias_> : Alias name for debris. Undefined deactivates debris sound."
"OptionalArg: <ground_zero_alias_> : Alias name for sound that plays only at ground zero. Undefined deactivates ground_zero sound."
"OptionalArg: <ground_zero_dist_threshold_> : The max distance between the explosion and the player where te ground_zero_alias_ will play. Undefined defaults to 500."
"SPMP: singleplayer"
///ScriptDocEnd
*/

snd_ambient_explosion( arg_struct )
{
	valid_arg_struct = sndx_ambient_explosion_args_validation( arg_struct );
	thread sndx_ambient_explosion_internal( valid_arg_struct );
}

sndx_ambient_explosion_args_validation( arg_struct )
{
	/////////////////////////////////////////////////////////
	// Validation for snd_ambient_explosion system arguments.
	// Set default arguments for optional arguments that need to be defined.  
	////////////////////////////////////////////////////////
	assert( IsDefined( arg_struct.pos ) );

	if ( !IsDefined( level._snd.ambientExp ) )
		init_ambient_explosion_arrays();
	
	if ( !IsDefined( arg_struct.explo_shot_array_ ) )
		arg_struct.explo_shot_array_ = level._snd.ambientExp[ "exp_generic_explo_shot" ]; //If shot array is not specified then use default.
	
	if ( IsDefined( arg_struct.duck_alias_ ) ) 
	{
		if ( IsDefined( arg_struct.duck_dist_threshold_ )  )
			arg_struct.duck_dist_threshold_ = max( arg_struct.duck_dist_threshold_, 0 ); //Ensures the distance threshold is not a negative number.
		else
			arg_struct.duck_dist_threshold_ = 1000; //If duck distance threshold is not specified then use default.		
	}
	
	if ( IsDefined( arg_struct.explo_delay_chance_ ) )
		arg_struct.explo_delay_chance_ = max( arg_struct.explo_delay_chance_, 0 ); //Ensures the delay chance is not a negative number.
	else
		arg_struct.explo_delay_chance_ = 50; //If delay chance is not specified then use default.
	
	if ( !IsDefined( arg_struct.explo_tail_alias_ ) )
		arg_struct.explo_tail_alias_ = "exp_generic_explo_tail";  //If explo tail alias is not specified then use default.
	
	if ( IsDefined( arg_struct.shake_dist_threshold_ ) )
		arg_struct.shake_dist_threshold_ = max( arg_struct.shake_dist_threshold_, 0 ); //Ensures the distance threshold is not a negative number.

	if ( !IsDefined( arg_struct.shake_envelope_ ) )
		arg_struct.shake_envelope_ = level._snd.envs[ "explo_shake_over_distance" ];  //If shake envelope is not specified then use default.
	
	if ( IsDefined( arg_struct.shake_durration_ ) )
		arg_struct.shake_durration_ = max( arg_struct.shake_durration_, 0 ); //Ensures the shake durration is not a negative number.
	else
		arg_struct.shake_durration_ = 0.5; //If shake durration is not specified then use default.
	
	if ( IsDefined( arg_struct.ground_zero_alias_ ) ) 
	{
		if ( IsDefined( arg_struct.ground_zero_dist_threshold_ )  )
			arg_struct.ground_zero_dist_threshold_ = max( arg_struct.ground_zero_dist_threshold_, 0 ); //Ensures the distance threshold is not a negative number.
		else
			arg_struct.ground_zero_dist_threshold_ = 500; //If ground zero distance threshold is not specified then use default.		
	}

	return arg_struct;
}

sndx_ambient_explosion_internal( arg_struct )
{

	explo_pos 					= arg_struct.pos;
	exploder_num_				= arg_struct.exploder_num_;
	incoming_alias_				= arg_struct.incoming_alias_;
	speed_of_sound_				= arg_struct.speed_of_sound_;
	explo_shot_array_			= arg_struct.explo_shot_array_;
	duck_alias_					= arg_struct.duck_alias_;
	duck_dist_threshold_		= arg_struct.duck_dist_threshold_;
	explo_delay_chance_			= arg_struct.explo_delay_chance_;
	explo_tail_alias_			= arg_struct.explo_tail_alias_;
	shake_dist_threshold_		= arg_struct.shake_dist_threshold_;
	shake_envelope_				= arg_struct.shake_envelope_;
	shake_durration_			= arg_struct.shake_durration_;
	explo_debris_alias_			= arg_struct.explo_debris_alias_;
	ground_zero_alias_			= arg_struct.ground_zero_alias_;
	ground_zero_dist_threshold_	= arg_struct.ground_zero_dist_threshold_;

	
	player_dist = distance( level.player.origin, explo_pos ); // Get player's distance from explosion.
	//IPrintLnBold( player_dist );

	if ( IsDefined( speed_of_sound_ ) && ( speed_of_sound_ == true ) )
	{
		// The speed of sound at sea level = roughly 1,000 feet per second (1,125 to be exact). 
		//It takes sound roughly 1 milisecond to travel 1 foot.
		//It takes sound roughly 1/12 of a milisecond to travel 1 inch. 
		// 1 game unit = roughly 1 inch.
		// The ammount of time it takes sound to travel X ammount of game untis per second is:  seconds = (game_units * 1/12 * 0.001).
		// constant = (1/12) * (1/1000) = 0.00008333333
		sos_delay = player_dist * 0.00008333333;
		wait( sos_delay );
	}
	
	// Play Incoming SFX & Exploder VFX.
	if ( IsDefined( exploder_num_ ) )
	{
		// SYNCHRONOUSLY play incoming sound.
		if ( IsDefined( incoming_alias_ ) )
			play_sound_in_space( incoming_alias_, explo_pos );
		
		// Play Exploder FX.
		exploder( exploder_num_ );
	}	
	
	//Explosion shot and tail sequences have been designed with very specific delay times between shot and tail.  
	//Shot and tail combinations can be random but the delay time is unique to each shot alias.
	//Shot aliases with their specific and unique delay times are defined in the explo_shot_array.	
	assert( IsDefined( explo_shot_array_ ) );	

	rand_explo_num = randomInt( explo_shot_array_.size );

	cur_explo_array = explo_shot_array_[ rand_explo_num ];
	assert( cur_explo_array.size == 2 );

	cur_explo_alias = cur_explo_array[ 0 ];
	assert( IsString( cur_explo_alias ) );
	
	thread play_sound_in_space( cur_explo_alias, explo_pos );

	//Play an lfe alias, that ducks all sounds, if the distance between the player and explosion is less than the duck_dist_threshold_.
	if ( IsDefined( duck_alias_ ) )
	{
		if( player_dist < duck_dist_threshold_ )
		{
			thread play_sound_in_space( duck_alias_, explo_pos );
		}	
	}
	
	//Wait the delay-time between the shot and the tail that is unique to each shot alias.
	cur_explo_delay = cur_explo_array[ 1 ];

	if ( IsDefined( cur_explo_delay ) )
	{
		if ( aud_percent_chance( explo_delay_chance_ ) )  //Only do the delayed, multi-stage, explosion a percentage of the time.  Otherwise play the tail and the shot at the same time.  
			wait( cur_explo_delay );
	}
	
	thread play_sound_in_space( explo_tail_alias_, explo_pos );
	
	//Do screen shake on explosion if the distance between the player and explosion is less than the shake_dist_threshold_.  
	//Vari the intensity of the explosion based on the player's distance from the explosion.
	if ( IsDefined( shake_dist_threshold_ ) )
	{
		if( player_dist < shake_dist_threshold_ )
		{
			dist_normalized = ( player_dist / shake_dist_threshold_ );
			assert( IsDefined( shake_envelope_ ) );
			shake_scale = aud_map2( dist_normalized, shake_envelope_ );
			//IPrintLnBold( "Shake Scale: " + shake_scale  );
			earthquake( shake_scale, shake_durration_, level.player.origin, shake_dist_threshold_ );
		}
	}
	
	//Play a debris alias if one was specified.
	if ( IsDefined( explo_debris_alias_ ) )
	{
		thread play_sound_in_space( explo_debris_alias_, explo_pos );
	}
	
	//Play a ground_zero alias if one was specified.
	if ( IsDefined( ground_zero_alias_ ) && ( player_dist < ground_zero_dist_threshold_ ) )
	{
		thread play_sound_in_space( ground_zero_alias_, explo_pos );
	}
}

/*
///ScriptDocBegin
"Name: snd_impact( material, size, position )"
"Summary: Builds an impact alias based on material and size and plays it at the specified position." 
"Module: Audio"
"CallOn: Nothing."
"MandatoryArg: <material> : The material type of the thing that is impacting a hard surface."
"MandatoryArg: <size> : The size of the impact; sml, med, lrg or lfe."
"MandatoryArg: <position> : Origin of the impact (vector)."
"OptionalArg: <ent_to_link_to_> : Entity to link sound to, relative to original impact position. Undefined plays sound at original impact position and does not update pos."
"SPMP: singleplayer"
///ScriptDocEnd
*/

snd_impact( material, size, position, ent_to_linkto_ )
{
	assert( IsDefined( material ) );
	assert( IsDefined( size ) );
	assert( IsDefined( position ) );

	impact_alias_name = ( material + "_impact_" + size );

	if (IsDefined ( ent_to_linkto_ ) )
	{
		impact_sound = aud_play_linked_sound( impact_alias_name, ent_to_linkto_, undefined, undefined, undefined, undefined, position );
	}
	else
	{
		impact_sound = aud_play_sound_at( impact_alias_name, position );		
	}
 	
 	return impact_sound;
}


///////////////////////////////
///	VEHICLE COLLISION SYSTEM																		
//////////////////////////////

//  CONSTANTS
kVCS_Debug						= false;
kVCS_PV_MinVelocityThreshold	= 25;
kVCS_PV_MaxVelocity				= 1000;
kVCS_PV_NumVelocityRanges		= 3;
kVCS_PV_MaxSmlVelocity			= 100;
kVCS_PV_MaxMedVelocity			= 600;
kVCS_PV_MaxLrgVelocity			= 1000;

kVCS_NPC_MinVelocityThreshold	= 25;
kVCS_NPC_MaxVelocity			= 800;
kVCS_NPC_NumVelocityRanges		= 3;
kVCS_NPC_MaxSmlVelocity			= 100;
kVCS_NPC_MaxMedVelocity			= 400;
kVCS_NPC_MaxLrgVelocity			= 800;

kVCS_MinLFEVolumeThreshold		= 0.0;
kVCS_FallVelMultiplier			= 2;
kVCS_MinTimeThreshold			= 250; // In miliseconds
kVCS_ScrapeSeperationTime		= 0.5; // This must be higher than kVCS_MinTimeThreshold. 
kVCS_ScrapeFadeOutTime			= 0.5;
kVCS_ScrapeUpdateRate			= 0.05;
kVCS_TireSkidProbability		= 35;  // % Chance
kVCS_MaxDistanceThreshold		= 6000;
kVCS_MedVolMin					= 0.1;
kVCS_LrgVolMin					= 0.3;
kVCS_NonPlayerImpVolReduction	= 0.0;

/*
///ScriptDocBegin
"Name: snd_play_vehicle_collision( vehicle, pos, impulse, relativeVel, surface, hit_entity_ )"
"Summary: Plays an appropriate size vehicle impact sound and scales it's volume based on vehicle's velocity and momentum.  Also plays an LFE sound for larger impacts.
"Module: Audio"
"CallOn: Nothing."
"MandatoryArg: <vehicle> : Entity of the vehicle doing the hitting."
"MandatoryArg: <pos> : Origin LARGEST impact that frame (vector)."
"MandatoryArg: <impulse> : Impulse of the LARGEST impact that frame (vector)."
"MandatoryArg: <relativeVel> : Relative velocity of the vehicle and hit_entity at LARGEST impact that frame (vector)."
"MandatoryArg: <surface> : The surface that "vehicle" hits. Currently only works with contacts with the world. Contact with other vehicles will return “none”."
"OptionalArg: <hit_entity> : Entity of the vehicle being hit.  This can be undefined if the object hit is world geo and not another vehicle."
"SPMP: singleplayer"
///ScriptDocEnd
*/
snd_play_vehicle_collision( arg_array )
{
	valid_arg_array = sndx_vehicle_collision_args_validation( arg_array );
	thread sndx_play_vehicle_collision_internal(valid_arg_array);
}

sndx_vehicle_collision_args_validation( arg_array )
{
	/////////////////////////////////////////////////////////////
	// Validation for snd_play_vehicle_collision system arguments.
	////////////////////////////////////////////////////////////
	assert( isArray( arg_array ) );

	assert( IsDefined( arg_array[ "vehicle" ] ) );
	assert( IsDefined( arg_array[ "pos" ] ) );
	assert( IsDefined( arg_array[ "impulse" ] ) );
	assert( IsDefined( arg_array[ "relativeVel" ] ) );
	assert( IsDefined( arg_array[ "surface" ] ) );
	
	//Vehicle (entity):  Entity of the vehicle doing the hitting.  
	//Hit Entity (entity):  Entity of the vehicle being hit.  This can be undefined if the object hit is world geo and not another vehicle.
	//Position (vector): point of the LARGEST impact that frame. For vehicle on vehicle collision, it’s not accurate with the model as the collision is done using boxes.  Probably doesn’t matter as much for sound.  More info about it in BS-6112.
	//Impulse (vector): impulse of the LARGEST impact that frame.  Impulse in this case is the normal of the contact point scaled by the magnitude of the impact.  Basically will give you the direction and strength of the impact.
	//Relative Velocity (vector):
	//Surface type (string): the surface that you hit, currently only works with contacts with the world, contact with other vehicles will return “none”.
	
	if ( !IsDefined( level._snd.veh_collision ) )
	{
		level._snd.veh_collision = spawnstruct();

		/#
		level._snd.veh_collision.input_type = true; //DEBUG defaults to using velocity for calculations -- DELETE ME
		level._snd.veh_collision.output_type = true; //DEBUG defaults to only printing impact stats for player vehicle. -- DELETE ME
		if (kVCS_Debug)
		{
			thread snd_dpad_functions( ::sndx_vehicle_collision_dpad_up, ::sndx_vehicle_collision_dpad_down, ::sndx_vehicle_collision_dpad_left, ::sndx_vehicle_collision_dpad_right ); //DEBUG -- DELETE ME
		}
		#/

		init_impact_system_arrays();
	}
	
	if ( !IsDefined( level._snd.veh_collision.prev_impactTime ) )
	{
		level._snd.veh_collision.prev_impactTime = 0;
	}	

	if ( !IsDefined( level._snd.veh_collision.is_scraping ) )
	{
		level._snd.veh_collision.is_scraping = false;
	}

	////////////////////////////////////////
	/// Handle special case material types.
	////////////////////////////////////////
	// The surface that you hit. Currently only works with contacts with the world. Contact with other vehicles will return “none”.
	if ( arg_array[ "surface" ] == "none" )
	{
		arg_array[ "surface" ] = "vehicle";	
	}
		
	////////////////////////////////////////////////
	/// Ensure the impact is on a supported surface.
	///////////////////////////////////////////////
	if ( !sndx_vehicle_collision_is_valid_surface( arg_array[ "surface" ] ) )
	{
		/#
		aud_print_error("Trying to play collision for a surface type that is not supported: " + arg_array[ "surface" ]);
		#/
		arg_array[ "surface" ] = "invalid";
	}
	
	return arg_array;
}

sndx_play_vehicle_collision_internal( arg_array )
{
	vehicle_ent 		= arg_array[ "vehicle" ];
	hit_ent				= arg_array[ "hit_entity" ];
	pos					= arg_array[ "pos" ];
	impulse				= arg_array[ "impulse" ];
	relativeVel			= arg_array[ "relativeVel" ];
	material			= arg_array[ "surface" ];
	
	//impulseXY = ( impulse[0], impulse[1], 0 );
	//momentum = Length( impulseXY ); // The momentum of the impact (strength of it).
	//angle = VectorNormalize( impulse ); // The direction of the contact point.

	relativeVelXY = ( relativeVel[0], relativeVel[1], 0 );
	vel = Length( relativeVelXY );
	fall_vel = ( abs( relativeVel[2] ) * kVCS_FallVelMultiplier );

	dist = distance( pos, level.player.origin ); // The distance between the player and the vehicle's point of impact.
	cur_impactTime = GetTime();
	dif_impactTime = ( cur_impactTime - level._snd.veh_collision.prev_impactTime );

	//////////////////////////////////////////////////////
	/// Check if player vehicle is involved in collision
	/// //////////////////////////////////////////////////
	player_vehicle = undefined;
	ent_to_linkto = undefined;
	player_vehicle_crash = false;
	if (IsDefined ( level.player.drivingVehicle ) )
	{
		player_vehicle = level.player.drivingVehicle;	
		if ( ( ( isdefined( hit_ent ) ) && ( hit_ent == player_vehicle ) ) || ( vehicle_ent == player_vehicle ) )
		{
			ent_to_linkto = player_vehicle;
			player_vehicle_crash = true;				
			if( level._snd.veh_collision.is_scraping )
			{
				thread sndx_vehicle_collision_scrape_timer();
			}
			/#
			// Debug Print: Impact velocity, momentum and distance from player
			player_vehicle sndx_vehicle_collision_print_stats( hit_ent, vehicle_ent, vel, fall_vel, dist );
			#/
		}
	}

	//////////////////////////////////////////////////////////////////////////
	/// Filter out insignificant impacts and impacts that happen too far away.
	//////////////////////////////////////////////////////////////////////////
	if( ( dist < kVCS_MaxDistanceThreshold ) && ( vel > kVCS_PV_MinVelocityThreshold ) )
	{

		//////////////////////////////////////////////
		/// Clip parameters into manageable ranges.
		/////////////////////////////////////////////
		vel = clamp( vel, 0, kVCS_PV_MaxVelocity );
		fall_vel = clamp( fall_vel, 0, kVCS_PV_MaxVelocity );

		/////////////////////////////////////////////////////////////////////////////////////////////////////////
		/// Determine whether the x,y relative velocity or the z relative verlocity would cause the larger impact. 
		/// /////////////////////////////////////////////////////////////////////////////////////////////////////
		vel_input = vel;
		if ( fall_vel > vel )
		{
			vel_input = fall_vel;			
		}
		
		//////////////////////////////////////////////////////////////////////////////
		/// Determine impact size and initial impact volume based on relative velocity
		/// //////////////////////////////////////////////////////////////////////////
		if ( player_vehicle_crash )
		{
		/// Determine impact size and initial impact volume for impacts involving player vehicle.
			impact_size = sndx_vehicle_collision_get_impact_size( vel_input, kVCS_PV_MaxSmlVelocity, kVCS_PV_MaxMedVelocity );
			impact_volume = sndx_vehicle_collision_get_impact_vol( vel_input, kVCS_PV_MaxSmlVelocity, kVCS_PV_MaxMedVelocity, kVCS_PV_MaxLrgVelocity );
			impact_type = "PV-IMPACT"; //DEBUG
		}
		else
		{
		/// Determine impact size and initial impact volume for non player-vehicle impacts.
			impact_size = sndx_vehicle_collision_get_impact_size( vel_input, kVCS_NPC_MaxSmlVelocity, kVCS_NPC_MaxMedVelocity );
			impact_volume = sndx_vehicle_collision_get_impact_vol( vel_input, kVCS_NPC_MaxSmlVelocity, kVCS_NPC_MaxMedVelocity, kVCS_NPC_MaxLrgVelocity );
			impact_type = "NPC-IMPACT"; //DEBUG

			///////////////////////////////////////////////////////////////////////
			/// Only play small impacts if player vehicle is involved in collision.
			///////////////////////////////////////////////////////////////////////
			if ( impact_size == "sml" )
				return;
			
			///////////////////////////////////////////////////////////////////////
			/// Lower the impact_volume if player vehicle is not involved in collision.
			///////////////////////////////////////////////////////////////////////
			clamp( impact_volume, kVCS_NonPlayerImpVolReduction, 1.0 );
			impact_volume = ( impact_volume - kVCS_NonPlayerImpVolReduction );
		}
		
		//////////////////////////////////////////////////////////
		/// Limit number of impacts from playing at the same time.
		//////////////////////////////////////////////////////////
		if ( dif_impactTime < kVCS_MinTimeThreshold )
		{
			/// Limit number of small, player_vehicle impact events.
			if ( impact_size == "sml" )
				return;

			/// Limit number of impact events for all other vehicles.
			if ( !player_vehicle_crash )
				return;
		}

		level._snd.veh_collision.prev_impactTime = cur_impactTime;

		////////////////////////////////////////////////////////////////////////////////////
		/// Play scrape sound if impacts by the player vehicle are repetitively triggered at 
		/// a max specified time interval (meaning the vehicle is likely sliding).
		////////////////////////////////////////////////////////////////////////////////////
		if  ( player_vehicle_crash )
		{
			if ( dif_impactTime <= kVCS_MinTimeThreshold )
			{
				level._snd.veh_collision.scrape_pos = pos;
				if ( !level._snd.veh_collision.is_scraping )
				{
					thread sndx_vehicle_collision_scrape( player_vehicle );
				}
				else
				{
					return;
				}
			}
			else
			{
				if ( level._snd.veh_collision.is_scraping )
				{
					sndx_vehicle_collision_stop_scrapes();
				}				
			}
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////
		/// Occasionally play a tire skid sound on med or lrg impacts where the player vehicle is not the hitter.
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		if ( IsDefined( player_vehicle) && ( vehicle_ent != player_vehicle ) )
		{
			if ( RandomInt( 100 ) < kVCS_TireSkidProbability )
			{
				aud_play_sound_at( "vehicle_tire_skid", pos );
			}
		}


		//////////////////////////////////////////////////////
		/// Modulate pitch based on the intensity of the impact
		/// //////////////////////////////////////////////////			
		impact_pitch = aud_map2( impact_volume, level._snd.envs[ "veh_crash_intensity_to_pitch" ] );


		//////////////////////////////////////////////////////
		/// Play impact sound
		/// //////////////////////////////////////////////////
		/#
		sndx_vehicle_collision_print_impact( impact_type, impact_size, impact_volume );
		#/
		impact_sound = snd_impact( "vehicle", impact_size, pos, ent_to_linkto );
		impact_sound ScaleVolume( impact_volume, 0.1 );
		impact_sound ScalePitch( impact_pitch, 0.1 );

		//////////////////////////////////////////////////////////////////////
		/// Play LFE Sound but only if player vehicle is involved in collision. 
		/// /////////////////////////////////////////////////////////////////
		if ( ( player_vehicle_crash ) && ( impact_size != "sml" ) )
		{
			////////////////////////////////////////////////////////
			/// Scale lfe volume based on the velocity of the impact
			/// ////////////////////////////////////////////////////
			lfe_volume = aud_map2( vel_input, level._snd.envs[ "veh_crash_vel_to_lfe_vol" ] );

			if ( lfe_volume > kVCS_MinLFEVolumeThreshold )
			{
 				lfe_sound = snd_impact( "vehicle", "lfe", pos );
 				lfe_sound ScaleVolume( lfe_volume, 0.1 );
			}			
		}
	}
}

sndx_vehicle_collision_is_valid_surface( value )
{
	assert( IsDefined( level._snd.veh_collision.surfaces ) );
	surface_exists = false;
	for ( index = 0; index < level._snd.veh_collision.surfaces.size; index++ )
	{
		if (value == level._snd.veh_collision.surfaces[ index ] )
		{
			surface_exists = true;
			break;
		}
	}
	
	return surface_exists;
}

sndx_vehicle_collision_get_impact_size( input, MaxSml, MaxMed )
{
	if ( input <= MaxSml)
	{
		impact_size = "sml";
	}
	else if ( input <= MaxMed )
	{
		impact_size = "med";
	}
	else
	{
		impact_size = "lrg";
	}
	
	return impact_size;
}

sndx_vehicle_collision_get_impact_vol( input, MaxSml, MaxMed, MaxLrg )
{
	if ( input <= MaxSml)
	{
		impact_volume = ( input /  MaxSml );
	}
	else if ( input <= kVCS_PV_MaxMedVelocity )
	{
		impact_volume = ( kVCS_MedVolMin + ( input / MaxMed ) );
	}
	else
	{
		impact_volume = ( kVCS_LrgVolMin + ( input / MaxLrg ) );
	}
	
	return impact_volume;
}

sndx_vehicle_collision_scrape( player_vehicle )
{	
	level._snd.veh_collision.is_scraping = true;
	level endon( "aud_stop_vehicle_scraping" );
	while( level._snd.veh_collision.is_scraping )
	{
		if (IsDefined ( player_vehicle ) )
		{
			//Determine the scrape position.
			init_pos = player_vehicle.origin;
			if ( IsDefined( level._snd.veh_collision.scrape_pos ) )
		    {
		    	init_pos = level._snd.veh_collision.scrape_pos;
		    }

			//Play the scrape sound.
			scrape_sound = aud_play_linked_sound( "vehicle_scrape", player_vehicle, undefined, undefined, undefined, undefined, init_pos );

			//Add handle of scrape sound to an array so that it can be stopped if the scraping stops
			if ( !IsDefined( level._snd.veh_collision.scrape_sounds ) )
			{
				level._snd.veh_collision.scrape_sounds = [];
			}
		
			level._snd.veh_collision.scrape_sounds[ level._snd.veh_collision.scrape_sounds.size ] = scrape_sound;
		}
	
		wait(kVCS_ScrapeSeperationTime);		
	}
}

sndx_vehicle_collision_scrape_timer()
{
	level notify( "aud_vehicle_collision_scrape_timer_reset" );
	level endon( "aud_vehicle_collision_scrape_timer_reset" );
	
	wait( kVCS_ScrapeUpdateRate );
	waittillframeend;
	sndx_vehicle_collision_stop_scrapes();
}

sndx_vehicle_collision_stop_scrapes()
{
	level notify( "aud_stop_vehicle_scraping" );
	level._snd.veh_collision.is_scraping = false;
	if ( IsDefined( level._snd.veh_collision.scrape_sounds ) )
	{
		for ( index = 0; index < level._snd.veh_collision.scrape_sounds.size; index++ )
		{
			if ( IsDefined( level._snd.veh_collision.scrape_sounds[ index ] ) )
			{
				sndEntity = level._snd.veh_collision.scrape_sounds[ index ];				
		    	thread aud_fade_out_and_delete(sndEntity, kVCS_ScrapeFadeOutTime);
			}
		}

		level._snd.veh_collision.scrape_sounds = undefined;
	}
}

sndx_vehicle_collision_print_stats( hit_ent, vehicle_ent, velocity_, fall_vel_, distance_  )
{
	if (kVCS_Debug)
	{
		if ( !IsDefined( velocity_ ) )
		    velocity_ = "-";			    	
		
		if ( !IsDefined( fall_vel_ ) )
			fall_vel_ = "-";
	
		if ( !IsDefined( distance_ ) )
			distance_ = "-";
	
		if ( level._snd.veh_collision.output_type )
		{
			if ( isDefined( self ) )
			{
				IPrintLn( "V: " + velocity_ + "|| FV: " + fall_vel_ + "|| D: " + distance_ );
			}			
		}
		else
		{
			IPrintLn( "V: " + velocity_ + "|| FV: " + fall_vel_ + "|| D: " + distance_ );
		}		
	}
}

sndx_vehicle_collision_print_impact( impact_type_, impact_size_, impact_volume_ )
{
	if (kVCS_Debug)
	{
		if ( !IsDefined( impact_type_ ) )
		    impact_type_ = "-";			    	
		
		if ( !IsDefined( impact_size_ ) )
			impact_size_ = "-";
	
		if ( !IsDefined( impact_volume_ ) )
			impact_volume_ = "-";
		
		IPrintLnBold( impact_type_ + ": " + impact_size_ + " || " + impact_volume_ );		
	}
}

sndx_vehicle_collision_dpad_up()
{
	MM_add_submix( "impact_system_solo" );
}

sndx_vehicle_collision_dpad_down()
{
	MM_clear_submix( "impact_system_solo" );
}

sndx_vehicle_collision_dpad_left()
{
	if( IsDefined ( level._snd.veh_collision.input_type ) )
	{
		level._snd.veh_collision.output_type = true;
	}
}

sndx_vehicle_collision_dpad_right()
{
	if( IsDefined ( level._snd.veh_collision.input_type ) )
	{
		level._snd.veh_collision.output_type = false;
	}
}

/*
///ScriptDocBegin
"Name: snd_dpad_functions( dpad_up, dpad_down, dpad_left, dpad_right )"
"Summary: Assign function pointers to DPAD directional presses"
"Module: Audio"
"CallOn: Nothing."
"OptionalArg: < dpad_up > :		Assign and function pointer to be called upon pressing "UP" on the DPAD.
"OptionalArg: < dpad_down > : 	Assign and function pointer to be called upon pressing "DOWN" on the DPAD.
"OptionalArg: < dpad_left > : 	Assign and function pointer to be called upon pressing "LEFT" on the DPAD.
"OptionalArg: < dpad_right > : 	Assign and function pointer to be called upon pressing "RIGHT" on the DPAD.
"SPMP: singleplayer"
"Example: snd_dpad_functions( ::spawn_helicopter, ::toggle_debug_hud )."
///ScriptDocEnd
*/

snd_dpad_functions( dpad_up, dpad_down, dpad_left, dpad_right )
{	
	level.player NotifyOnPlayerCommand( "dpad_action_01", "+actionslot 1" ); //Up on Dpad.
	level.player NotifyOnPlayerCommand( "dpad_action_02", "+actionslot 2" ); //Down on Dpad.
	level.player NotifyOnPlayerCommand( "dpad_action_03", "+actionslot 3" ); //Left on Dpad.
	level.player NotifyOnPlayerCommand( "dpad_action_04", "+actionslot 4" ); //Right on Dpad.
	
	thread sndx_dpad_function_watch( "dpad_action_01", dpad_up ); //Action Slot 1
	thread sndx_dpad_function_watch( "dpad_action_02", dpad_down ); //Action Slot 2
	thread sndx_dpad_function_watch( "dpad_action_03", dpad_left ); //Action Slot 3
	thread sndx_dpad_function_watch( "dpad_action_04", dpad_right ); //Action Slot 4
}

sndx_dpad_function_watch( dpad_action, dpad_direction )
{	
	if(IsDefined( dpad_action ))
	{
		while(1)
		{
			level.player waittill( dpad_action );	
			
			if(IsDefined(dpad_direction))
			{
				thread [[ dpad_direction ]]();
			}
	
			wait(0.05);		
		}
	}

}

