#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

#using_animtree( "generic_human" );

autoexec _init_wounded_anims()
{
	/*
	 * DEAD MALE
	 */
	
	level.scr_anim[ "dead_male" ][ "floor" ] = array(
														%ch_gen_m_floor_armdown_legspread_onback_deathpose,
														%ch_gen_m_floor_armdown_onback_deathpose,
														%ch_gen_m_floor_armdown_onfront_deathpose,
														%ch_gen_m_floor_armover_onrightside_deathpose,
														%ch_gen_m_floor_armrelaxed_onleftside_deathpose,
														%ch_gen_m_floor_armsopen_onback_deathpose,
														%ch_gen_m_floor_armspread_legaskew_onback_deathpose,
														%ch_gen_m_floor_armspread_legspread_onback_deathpose,
														%ch_gen_m_floor_armspreadwide_legspread_onback_deathpose,
														%ch_gen_m_floor_armstomach_onback_deathpose,
														%ch_gen_m_floor_armstomach_onrightside_deathpose,
														%ch_gen_m_floor_armstretched_onleftside_deathpose,
														%ch_gen_m_floor_armstretched_onrightside_deathpose,
														%ch_gen_m_floor_armup_legaskew_onfront_faceleft_deathpose,
														%ch_gen_m_floor_armup_legaskew_onfront_faceright_deathpose,
														%ch_gen_m_floor_armup_onfront_deathpose
													);
	
	level.scr_anim[ "dead_male" ][ "misc" ] = array(
														%ch_gen_m_ledge_armhanging_facedown_onfront_deathpose,
														%ch_gen_m_ledge_armhanging_faceright_onfront_deathpose,
														%ch_gen_m_ledge_armspread_faceleft_onfront_deathpose,
														%ch_gen_m_ledge_armspread_faceright_onfront_deathpose,
														%ch_gen_m_ramp_armup_onfront_deathpose,
														%ch_gen_m_vehicle_armdown_leanforward_deathpose,
														%ch_gen_m_vehicle_armdown_leanright_deathpose,
														%ch_gen_m_vehicle_armtogether_leanright_deathpose,
														%ch_gen_m_vehicle_armup_leanleft_deathpose,
														%ch_gen_m_vehicle_armup_leanright_deathpose,
														%ch_gen_m_wall_armcraddle_leanleft_deathpose,
														%ch_gen_m_wall_armopen_leanright_deathpose,
														%ch_gen_m_wall_headonly_leanleft_deathpose,
														%ch_gen_m_wall_legin_armcraddle_hunchright_deathpose,
														%ch_gen_m_wall_legspread_armdown_leanleft_deathpose,
														%ch_gen_m_wall_legspread_armdown_leanright_deathpose,
														%ch_gen_m_wall_legspread_armonleg_leanright_deathpose,
														%ch_gen_m_wall_low_armstomach_leanleft_deathpose,
														%ch_gen_m_wall_rightleg_wounded
													);
	
	/*
	 * WOUNDED MALE
	 */
	
	level.scr_anim[ "wounded_male" ][ "floor" ] = array(
														%ch_gen_m_floor_back_wounded,
														%ch_gen_m_floor_chest_wounded,
														%ch_gen_m_floor_dullpain_wounded,
														%ch_gen_m_floor_head_wounded,
														%ch_gen_m_floor_leftleg_wounded,
														%ch_gen_m_floor_shellshock_wounded
													);
	
	level.scr_anim[ "wounded_male" ][ "misc" ] = array(
														%ch_gen_m_wall_rightleg_wounded
													);
	
	/*
	 * DEAD FEMALE
	 */
	
	level.scr_anim[ "dead_female" ][ "floor" ] = array(
														%ch_gen_f_floor_onback_armstomach_legcurled_deathpose,
														%ch_gen_f_floor_onback_armup_legcurled_deathpose,
														%ch_gen_f_floor_onfront_armdown_legstraight_deathpose,
														%ch_gen_f_floor_onfront_armup_legcurled_deathpose,
														%ch_gen_f_floor_onfront_armup_legstraight_deathpose,
														%ch_gen_f_floor_onleftside_armcurled_legcurled_deathpose,
														%ch_gen_f_floor_onleftside_armstretched_legcurled_deathpose,
														%ch_gen_f_floor_onrightside_armstomach_legcurled_deathpose,
														%ch_gen_f_floor_onrightside_armstretched_legcurled_deathpose
													);
	
	level.scr_anim[ "dead_female" ][ "misc" ] = array(
														%ch_gen_f_wall_leanleft_armdown_legcurled_deathpose,
														%ch_gen_f_wall_leanleft_armstomach_legstraight_deathpose,
														%ch_gen_f_wall_leanright_armstomach_legcurled_deathpose,
														%ch_gen_f_wall_leanright_armstomach_legstraight_deathpose
													);
	
	level._wounded_animnames = array( "dead_male", "wounded_male", "dead_female" );
	
	/* create lookup table for all anims to quickly find specific aniamtions */
	
	level._wounded_anims = [];
	foreach ( animation in level.scr_anim[ "dead_male" ][ "floor" ] )
	{
		level._wounded_anims[ string( animation ) ] = animation;
	}
	
	foreach ( animation in level.scr_anim[ "dead_male" ][ "misc" ] )
	{
		level._wounded_anims[ string( animation ) ] = animation;
	}
	
	foreach ( animation in level.scr_anim[ "wounded_male" ][ "floor" ] )
	{
		level._wounded_anims[ string( animation ) ] = animation;
	}
	
	foreach ( animation in level.scr_anim[ "wounded_male" ][ "misc" ] )
	{
		level._wounded_anims[ string( animation ) ] = animation;
	}
	
	foreach ( animation in level.scr_anim[ "dead_female" ][ "floor" ] )
	{
		level._wounded_anims[ string( animation ) ] = animation;
	}
	
	foreach ( animation in level.scr_anim[ "dead_female" ][ "misc" ] )
	{
		level._wounded_anims[ string( animation ) ] = animation;
	}
}

autoexec _init_wounded()
{
	foreach ( trig in get_triggers() )
	{
		if ( IsDefined( trig.target ) )
		{
			a_structs = getstructarray( trig.target );
			a_structs = _process_structs( a_structs );
			
			if ( a_structs.size > 0 )
			{
				trig thread _spawn_wounded_trigger( a_structs );
			}
		}
	}
}

_process_structs( a_structs )
{
	a_wounded_structs = [];
	
	foreach ( struct in a_structs )
	{
		if ( IsDefined( struct.script_animation ) )
		{
			if ( IsDefined( level._wounded_anims[ struct.script_animation ] ) )
			{
				struct.animation = level._wounded_anims[ struct.script_animation ];
			}
			else
			{
				a_toks = StrTok( struct.script_animation, ", " );
				if ( IsInArray( level._wounded_animnames, a_toks[ 0 ] ) )
				{
					struct.animation = getanim_from_animname( a_toks[ 1 ], a_toks[ 0 ] );
					if ( IsArray( struct.animation ) )
					{
						struct.animation = random( struct.animation );
					}
				}
				else
				{
					continue;
				}
			}
			
			if ( IsSubStr( string( struct.animation ), "floor" ) )
			{
				struct.origin = PhysicsTrace( struct.origin + ( 0, 0, 64 ),  struct.origin - ( 0, 0, 500 ) );
				struct.b_trace_done = true;
			}
			
			a_spawners = StrTok( struct.spawner_id, ", " );
			struct.e_spawner = GetEnt( random( a_spawners ), "targetname" );
			struct.spawner_id = undefined;
			
			ARRAY_ADD( a_wounded_structs, struct );
		}
	}
	
	return a_wounded_structs;
}

_spawn_wounded_trigger( a_structs )
{
	self endon( "death" );
	self trigger_wait();

	foreach ( struct in a_structs )
	{
		struct spawn_wounded_at_struct();
	}
}

// self = spawner
spawn_wounded( v_org, v_ang = (0, 0, 0), str_animname, str_scene, str_anim_override, str_targetname, do_phys_trace = true )
{
	e_drone = self spawn_drone( true, str_targetname );
	e_drone.takedamage = true;
	
	if ( IsDefined( str_anim_override ) )
	{
		animation = level._wounded_anims[ str_anim_override ];
	}
	else
	{
		animation = getanim_from_animname( str_scene, str_animname );
		if ( IsArray( animation ) )
		{
			animation = random( animation );
		}
	}
	
	if( do_phys_trace && IsSubStr( string(animation), "floor" ))
	{
		floor_pos = PhysicsTrace( v_org + (0,0,64),  v_org - (0,0,500));
		e_drone.origin = (v_org[0], v_org[1], floor_pos[2]);
	}
	else
	{
		e_drone.origin = v_org;
	}
	e_drone.angles = v_ang;
	
	e_drone SetAnim( animation, 1, 0, 1 );
	
	if ( IsSubStr( string( animation ), "wounded" ) )
	{				
		e_drone thread _wounded_death( animation );
	}
	
	return e_drone;
}

#define STEP .05
#define TIME 3
_wounded_death( animation )
{
	self waittill( "death" );
	
	if ( IsDefined( self ) )
	{
		n_rate = 1;
		n_delta = 0;
		
		while ( n_rate > 0 )
		{
			wait STEP;
			n_delta += STEP;
			
			n_rate = clamp( LerpFloat( 1, 0, n_delta / TIME ), 0, 1 );
			self SetAnim( animation, 1, 0, n_rate );
		}
	}
}

// self = wounded struct
spawn_wounded_at_struct()
{
	e_drone = self.e_spawner spawn_wounded( self.origin, self.angles, self.str_animname, self.str_scene, self.animation, self.str_targetname, !IS_TRUE( self.b_trace_done ) );
	
	// Copy some KVPs from struct
	if ( IsDefined( self.script_noteworthy ) )
	{
		e_drone.script_noteworthy = self.script_noteworthy;
	}
}
