#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_scene;
#include maps\_skipto;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

skipto_setup()
{
	load_gumps();
	
	skipto = level.skipto_point;
	
	if (skipto == "intro")
		return;
		
	if (skipto == "speech")
		return;
	
	flag_set( "player_turn" );
	flag_set( "player_turns_back" );
	flag_set( "menendez_exited" );

	if (skipto == "market")
		return;
	
	level thread maps\yemen_market::vo_market();
	
	if (skipto == "terrorist_hunt")
		return;

	if (skipto == "metal_storms")
		return;
	
	end_market_vo();

	if (skipto == "morals")
		return;
	
	flag_set( "morals_start" );

	if (skipto == "drone_control")
		return;
		
	if (skipto == "hijacked")
		return;

	if (skipto == "capture")
		return;
}

// Load the right gump for the skipto for CreatFx
load_gumps()
{
	screen_fade_out( 0 );

	if ( is_after_skipto( "morals" ) )
	{
		load_gump( "yemen_gump_outskirts" );
	}
	else if ( is_after_skipto( "terrorist_hunt" ) )
	{
		load_gump( "yemen_gump_morals" );
	}
	else if ( is_after_skipto( "speech" ) )
	{
		load_gump( "yemen_gump_market_streets" );
	}
	else
	{
		load_gump( "yemen_gump_speech" );
	}
	
	screen_fade_in( 0 );
}

give_scene_models_guns( str_scene )
{
	a_models = get_model_or_models_from_scene( str_scene );
	
	foreach ( m_guy in a_models )
	{
		m_guy attach( "t6_wpn_ar_an94_world", "tag_weapon_right" );
		
//		m_guy thread show_my_gun();
	}
}

/#
show_my_gun()
{
	while( true )
	{
		wait 1;
		level thread draw_debug_line( self GetTagOrigin( "tag_flash" ), self GetTagOrigin( "tag_eye" ), 1 );
		Print3d( self GetTagOrigin( "tag_flash" ), self.animname, (1, 0, 0), 1, .1, 60 );
	}
}
#/
	
/* ------------------------------------------------------------------------------------------
	Terrorist/Yemeni Team Functions
-------------------------------------------------------------------------------------------*/
teamswitch_threatbias_setup()
{
	CreateThreatBiasGroup( "player" );
	CreateThreatBiasGroup( "yemeni" );
	CreateThreatBiasGroup( "yemeni_friendly" );
	CreateThreatBiasGroup( "terrorist" );
	CreateThreatBiasGroup( "terrorist_team3" );

	// Yemeni should shoot the player
	SetThreatBias( "player", "yemeni", 2500 );
	SetThreatBias( "player", "yemeni_friendly", 2500 );
	
	// Yemeni and Terrorists should shoot at each other
	SetThreatBias( "terrorist", "yemeni", 1500 );
	SetThreatBias( "terrorist", "yemeni_friendly", 1500 );
	SetThreatBias( "terrorist_team3", "yemeni", 1500 );
	SetThreatBias( "terrorist_team3", "yemeni_friendly", 1500 );
	SetThreatBias( "yemeni", "terrorist", 1500 );
	SetThreatBias( "yemeni_friendly", "terrorist", 1500 );
	
	// Terrorist_team3 should shoot at the player and Yemeni, but not at Terrorists.
	SetThreatBias( "terrorist_team3", "terrorist", -15000 );
	SetThreatBias( "terrorist", "terrorist_team3", -15000 );
	SetThreatBias( "player", "terrorist_team3", 15000 );
	SetThreatBias( "yemeni", "terrorist_team3", 1000 );
	SetThreatBias( "yemeni_friendly", "terrorist_team3", 1000 );
	
	level thread yemeni_teamswitch_radio_callout();
	
	SetSavedDvar( "g_friendlyfireDist", 0 );
}

/#
terrorist_debug_spawnfunc()
{
	self endon( "death" );
	
	while ( true )
	{
		Print3d( self.origin, "T", ( 1, 0, 0 ), 1, 1, 1 );
		WAIT_FRAME;
	}
}
#/

// Sets the yemeni soldier (normally a friendly) to axis, other logic on the way
yemeni_teamswitch_spawnfunc()
{
	self.team = "axis";
	self.is_yemeni = true;
	self SetThreatBiasGroup( "yemeni" );
	self thread yemeni_bft_highlight();
	self EnableAimAssist();
	self thread yemeni_watch_player_damage();
}

yemeni_bft_highlight()
{
	m_fx_origin = spawn_model( "tag_origin", self GetTagOrigin( "J_SpineLower" ), (0, 0, 0) );
	m_fx_origin LinkTo( self, "J_SpineLower" );
	PlayFXOnTag( GetFX( "friendly_marker" ), m_fx_origin, "tag_origin" );
	
//	self SetClientFlag( 14 );
	self waittill( "death" );
//	self ClearClientFlag( 14 );
	m_fx_origin Delete();
}
	
yemeni_watch_player_damage()
{
	while ( IsAlive( self ) )
	{
		self waittill( "damage", damage, e_attacker );

		if ( IsPlayer( e_attacker ) )
		{
			if ( damage >= self.health )
			{
				level notify( "player_killed_yemeni" );
			}
			
			level notify( "_player_attacked_yemeni_" );
			level thread yemeni_player_damage_flag();
		}
	}
}

yemeni_player_damage_flag()
{
	flag_set( "player_attacked_yemeni" );
	level endon( "_player_attacked_yemeni_" );
	wait 3;
	flag_clear( "player_attacked_yemeni" );
}

//terrorist_bft_highlight()
//{
//	self SetClientFlag( 15 );
//	self waittill( "death" );
//	self ClearClientFlag( 15 );
//}
	
// Sets terrorist soldier to friendly, detects if the player shoots him or anyone near him
terrorist_teamswitch_spawnfunc()
{
	self notify( "__terrorist_teamswitch_spawnfunc__" );
	self endon( "__terrorist_teamswitch_spawnfunc__" );
	
	//self endon( "death" );
//	self endon( "detected_farid" );
	
	self.team = "allies";
	self SetThreatBiasGroup( "terrorist" );
//	self thread terrorist_bft_highlight();
	self EnableAimAssist();
	
	self thread terrorist_teamswitch_check_targets();
	
	while ( IsAlive( self ) && self.team == "allies" )
	{
		self waittill( "damage", damage, e_attacker );
		
		if ( IsPlayer( e_attacker ) )
		{
			if ( damage >= self.health )
			{
				level thread terrorist_player_death_flag();
			}
			
			level thread terrorist_player_damage_flag();
			
			self thread terrorist_teamswitch_radius_check();
			self thread yemeni_teamswitch_player_detected();
			//self thread terrorist_teamswitch_player_detected();
		}
	}
}

detect_player_attacker()
{
	level endon( "kill_market_vo" );
	
	while ( true )
	{
		self waittill( "damage", damage, e_attacker );
		if ( IS_TRUE( e_attacker.is_yemeni ) )
		{
			level thread yemeni_fire_at_player_flag();
		}
		else if ( IS_VEHICLE( e_attacker ) )
		{
			level thread robot_fire_at_player_flag();
		}
		else if ( IS_EQUAL( e_attacker.team, "team3" ) )
		{
			level thread terrorist_fire_at_player_flag();
			//level thread player_cover_blown_flag();
		}
	}
}

yemeni_fire_at_player_flag()
{
	level notify( "_yemeni_attacked_player_" );
	flag_set( "yemeni_attacked_player" );
	level endon( "_yemeni_attacked_player" );
	wait 3;
	flag_clear( "yemeni_attacked_player" );
}

robot_fire_at_player_flag()
{
	level notify( "_robot_attacked_player_" );
	flag_set( "robot_attacked_player" );
	level endon( "_robot_attacked_player_" );
	wait 3;
	flag_clear( "robot_attacked_player" );
}

terrorist_fire_at_player_flag()
{
	level notify( "_terrorist_attacked_player_" );
	flag_set( "terrorist_attacked_player" );
	level endon( "_terrorist_attacked_player_" );
	wait 3;
	flag_clear( "terrorist_attacked_player" );
}

//player_cover_blown_flag()
//{
//	level notify( "_player_cover_blown_" );
//	flag_set( "player_cover_blown" );
////	level endon( "_player_cover_blown_" );
////	wait 15;
////	flag_clear( "player_cover_blown" );
//}

terrorist_player_damage_flag()
{
	level notify( "_player_attacked_terrorists_" );
	wait 2;	// delay this so we can see if anyone got alerted and set that flag for dialog logic
	
	flag_set( "player_attacked_terrorists" );
	level endon( "_player_attacked_terrorists_" );
	wait 3;
	flag_clear( "player_attacked_terrorists" );
}

terrorist_player_death_flag()
{
	level notify( "_player_killed_terrorists_" );
	wait 2;	// delay this so we can see if anyone got alerted and set that flag for dialog logic
	
	flag_set( "player_killed_terrorists" );
	level endon( "_player_killed_terrorists_" );
	wait 3;
	flag_clear( "player_killed_terrorists" );
}

terrorist_teamswitch_radius_check()
{
	const n_detect_radius = 256 * 256;
	
	a_terrorists = get_ai_array( "terrorist", "script_noteworthy" );
	
	foreach( ai_terrorist in a_terrorists )
	{
		// is this AI close to the one shot?
		if ( Distance2DSquared( self.origin, ai_terrorist.origin ) < n_detect_radius )
		{
			ai_terrorist thread terrorist_teamswitch_player_detected();
		}
		// is this AI close to the player?
//		else if ( Distance2DSquared( level.player.origin, ai_terrorist.origin ) < n_detect_radius )
//		{
//			ai_terrorist terrorist_teamswitch_player_detected();
//		}
		// can this AI see the one shot?
		
		else
		{
			v_terrorist_to_self = VectorNormalize( self.origin - ai_terrorist.origin );
			v_terrorist_forward = VectorNormalize( AnglesToForward( ai_terrorist.angles ) );
			
			if ( VectorDot( v_terrorist_to_self, v_terrorist_forward ) > .25 && ai_terrorist CanSee( self ) )
			{
				ai_terrorist thread terrorist_teamswitch_player_detected();
			}
		}
	}
}

terrorist_teamswitch_player_detected()
{
	wait 1;
	
	if ( IsAlive( self ) )
	{
		ARRAY_ADD( level.alerted_terrorists, self );
		
		flag_set( "player_cover_blown" );	// flag set only when terrorist fire at player ( for vo ), easier for player to understand 
		//level notify( "player_cover_blown" );
		
		self notify( "detected_farid" );
		self.team = "team3";
		self SetThreatBiasGroup( "terrorist_team3" );
		self waittill( "death" );
		
		if ( IsDefined( self ) )
		{
			ArrayRemoveValue( level.alerted_terrorists, self );
		}
		else
		{
			REMOVE_UNDEFINED( level.alerted_terrorists );
		}
		
		if ( level.alerted_terrorists.size == 0 )
		{
			level endon( "player_cover_blown" );
			wait 15;
			flag_clear( "player_cover_blown" );
		}
	}
}

// check target.  If target is on team3, switch to the team with him
terrorist_teamswitch_check_targets()
{
	self endon ( "death" );
	self endon ( "detected_farid" );
	
	// TODO: Make this function
	while ( true )
	{
		self waittill( "enemy" );
		
		if ( IsDefined( self.enemy ) && IsDefined( self.enemy.team ) && self.enemy.team == "team3" )
		{
			self thread terrorist_teamswitch_player_detected();
		}
	}
}

yemeni_teamswitch_player_detected()
{
	a_yemeni = get_ai_array( "yemeni", "script_noteworthy" );
	
	foreach( ai_yemeni in a_yemeni )
	{
		if ( ai_yemeni CanSee( level.player ) )
		{
			ai_yemeni SetThreatBiasGroup( "yemeni_friendly" );
			level notify( "yemeni_detected_farid" );
			// Print3d( ai_yemeni GetTagOrigin( "tag_eye" ), "!", (0, 1, 0), 1, 2, 30 );
		}
	}
}

yemeni_teamswitch_radio_callout()
{
	a_yemeni_callouts[0] = "Yemeni: Watch your fire, we have a friendly";
	a_yemeni_callouts[1] = "Yemeni: Our agent has been sighted, be careful";
	a_yemeni_callouts[2] = "Yemeni: Check your fire, he's on our side";
	
	while ( true )
	{
		level waittill( "yemeni_detected_farid" );
		wait .5;
		n_callout_index = RandomInt( a_yemeni_callouts.size );
//		IPrintLn( a_yemeni_callouts[ n_callout_index ] );
		
		wait 5;	// delay how often we get the callouts
	}
}

/* ------------------------------------------------------------------------------------------
	Vehicle Spawn Utility Functions
-------------------------------------------------------------------------------------------*/

/* ------------------------------------------------------------------------------------------
	VTOL Rappeler Functions
-------------------------------------------------------------------------------------------*/

// To set up a VTOL with rappelers, follow these steps:
//  - Set up your Vehicle path and VTOL like any other vehicle.
//  - On the path node you want the VTOL to stop at, give it the script_noteworthy of "vtol_rappel_spot"
//  - Give that path node a unique script_string
//  - create a struct at the position you want each rappeler to start at
//     - the targetname of [script_string]_start, where [script_string] is the script_string you gave the vehicle node
// 	   - give have the struct target a second struct, which is where the rappel action stops
//     - Have that second struct target a cover node, where the AI will run to after it rappels
//  - Create an AI spawner with the targetname [script_string]_rappelers (and give it an appropriate count)
// DONE!

temp_vtol_stop_and_rappel()
{
	a_rappel_nodes = GetVehicleNodeArray( "vtol_rappel_spot", "script_noteworthy" );
	array_thread( a_rappel_nodes, ::temp_vtol_rappel_start );
}

temp_vtol_rappel_start()
{
	self waittill( "trigger", veh_vtol );
	
	n_speed = veh_vtol GetSpeed();
	veh_vtol SetSpeed( 0, 50, 50 );
	
	str_rappel_spawner_targetname 	= self.script_string + "_rappelers";
	str_rappel_start_targetname		= self.script_string + "_start";
	
	level thread temp_vtol_rappel_guys( str_rappel_start_targetname, str_rappel_spawner_targetname );
	
	wait 5;
	veh_vtol SetSpeed( n_speed );
	
	veh_vtol waittill( "goal" );
	veh_vtol Delete();
}

temp_vtol_rappel_guys( str_struct_starts, str_rappeler )
{
	a_start_structs = GetStructArray( str_struct_starts, "targetname" );
	sp_rappeler		= GetEnt( str_rappeler, "targetname" );
	
	foreach( s_rappel_start in a_start_structs )
	{
		ai_guy = sp_rappeler spawn_ai( true );
		
		if( IsDefined( ai_guy ) )
		{
			ai_guy thread temp_vtol_rappel_guy( s_rappel_start );
		}
		
		wait .5;
	}
}

temp_vtol_rappel_guy( s_rappel_start )
{
	self endon( "death" );
	
	s_rappel_end = GetStruct( s_rappel_start.target, "targetname" );
	nd_goal = GetNode( s_rappel_end.target, "targetname" );
	
	m_mover = Spawn( "script_origin", self.origin );
	// m_mover SetModel( "tag_origin" );
	self LinkTo( m_mover );
	m_mover.origin = s_rappel_start.origin;
	
	m_mover MoveTo( s_rappel_end.origin, 2, .5, .5 );
	m_mover waittill( "movedone" );
	
	self Unlink();
	self SetGoalNode( nd_goal );
}



/* ------------------------------------------------------------------------------------------
	Vehicle Spawn Utility Functions
-------------------------------------------------------------------------------------------*/

spawn_quadrotors_at_structs( str_struct_name, str_noteworthy, b_copy_noteworthy = false )
{
	a_spots = GetStructArray( str_struct_name, "targetname" );
	a_qrotors = [];
	
	foreach ( s_spot in a_spots )
	{
		vh_qrotor = spawn_vehicle_from_targetname( "yemen_quadrotor_spawner" );
		vh_qrotor.origin = s_spot.origin;
		vh_qrotor.goalpos = s_spot.origin;
		
		if( IsDefined( str_noteworthy ) )
		{
			vh_qrotor.script_noteworthy = str_noteworthy;
		}
		else if ( is_true( b_copy_noteworthy ) )
		{
			vh_qrotor.script_noteworthy = s_spot.script_noteworthy;
		}
		
		ArrayInsert( a_qrotors, vh_qrotor, a_qrotors.size );
	}
	
	return a_qrotors;
}

yemen_quadrotor_indicator()
{
	self thread maps\_quadrotor::quadrotor_think();
	
	m_fx_origin = spawn_model( "tag_origin", self GetTagOrigin( "tag_origin" ) + (0, 0, 16), (0, 0, 0) );
	m_fx_origin LinkTo( self, "tag_origin" );
	PlayFXOnTag( GetFX( "quadrotor_marker" ), m_fx_origin, "tag_origin" );
	
	self waittill( "death" );

	m_fx_origin Delete();
}

yemen_metalstorm_indicator()
{
	self thread maps\_metal_storm::main();
	m_fx_origin = spawn_model( "tag_origin", self GetTagOrigin( "tag_origin" ) + (0, 0, 60), (0, 0, 0) );
	m_fx_origin LinkTo( self, "tag_origin" );
	PlayFXOnTag( GetFX( "metalstorm_marker" ), m_fx_origin, "tag_origin" );
	
	self waittill( "death" );

	m_fx_origin Delete();
}

//target vehicle node with struct
spawn_vtols_at_structs( str_struct_name, str_nd_name )
{
	a_spots = GetStructArray( str_struct_name, "targetname" );
	
	foreach ( s_spot in a_spots )
	{
		v_vtol = spawn_vehicle_from_targetname( "yemen_drone_control_vtol_spawner" );
		
		if( IsDefined( str_nd_name ) || IsDefined( s_spot.target ) )
		{
			if( IsDefined( s_spot.target ) )
			{
				str_nd_name = s_spot.target;
			}
			
			v_vtol go_path( GetVehicleNode( str_nd_name, "targetname" ) );
		}
		
		else
		{
			v_vtol.origin = s_spot.orign;
			v_vtol.angles = s_spot.angles;
		}
	}
}


/* ------------------------------------------------------------------------------------------
	HERO SKIPTO: Starts a Hero in a skipto at the specified scriptstruct

	Hero Characters are:-
		"sp_salazar"

-------------------------------------------------------------------------------------------*/

init_hero_startstruct( str_hero_name, str_struct_targetname )
{
	ai_hero = init_hero( str_hero_name );
	
	s_start_pos = getstruct( str_struct_targetname, "targetname" );
	assert( IsDefined(s_start_pos), "Bad Hero setup struct: " + str_struct_targetname );
	
	if( IsDefined(s_start_pos.angles) )
	{
		v_angles = s_start_pos.angles;
	}
	else
	{
		v_angles = ( 0, 0, 0 );
	}
	
	ai_hero forceteleport( s_start_pos.origin, v_angles );
	
	ai_hero.radius = 32;
	
	return( ai_hero );
}



/* ------------------------------------------------------------------------------------------
teleport_ai_to_pos( v_teleport_pos, v_teleport_angles )
Teleports Self to the given position, assigns the angles if specified
-------------------------------------------------------------------------------------------*/

teleport_ai_to_pos( v_teleport_pos, v_teleport_angles )
{
	if ( IsDefined( v_teleport_angles ) )
	{
		self ForceTeleport( v_teleport_pos, v_teleport_angles );
	}
	else
	{
		self ForceTeleport( v_teleport_pos );
	}
	
	self SetGoalPos( v_teleport_pos );
}

//-- dead param because we call it from a notetrack custom func
switch_player_to_mason( dead_param )
{
	level.player_viewmodel = "c_usa_cia_masonjr_viewhands";
	level.player_interactive_model = "c_usa_cia_masonjr_viewbody";
	level.player SetViewModel( level.player_viewmodel );
}

cleanup( str_value, str_key = "targetname" )
{
	array = GetEntArray( str_value, str_key );
	
	foreach ( ent in array )
	{
		if ( IS_VEHICLE( ent ) )
		{
			VEHICLE_DELETE( ent );
		}
		else
		{
			ent Delete();
		}
	}
}

turn_off_vehicle_exhaust( veh )
{
	veh veh_toggle_exhaust_fx( false );
}

turn_off_vehicle_tread_fx( veh )
{
	veh veh_toggle_tread_fx( false );
}

rotate_continuously( rev_per_second, end_on_notify )
{
	if ( isdefined( end_on_notify ) )
	{
		level endon( end_on_notify );
	}
	
	while ( true )
	{
		self RotateYaw( 360 * rev_per_second, 1.0, 0.0, 0.0 );
		wait 0.9;
	}
}

spawn_func_player_damage_only()
{
	self.overrideActorDamage = ::take_player_damage_only;
}

take_player_damage_only( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if ( !IsPlayer( eAttacker ) )
	{
		iDamage = 0;
	}
	
	return iDamage;
}

take_player_damage_only_for_time( n_time )
{
	self endon( "death" );
	self.overrideActorDamage = ::take_player_damage_only;
	wait n_time;
	self.overrideActorDamage = undefined;
}

take_player_damage_only_for_scene( str_scene )
{
	self endon( "death" );
	self.overrideActorDamage = ::take_player_damage_only;
	scene_wait( str_scene );
	self.overrideActorDamage = undefined;
}

// used for vehicle path offsets
get_offset_scale( i )
{
	if( i % 2 == 0 )
	{
		return -(i / 2);
	}
	else
	{
		return i - (i/2) + 0.5;
	}
}

notetrack_drone_shoot( drone_model )
{
	if ( isdefined( drone_model ) )
	{
		pos = drone_model GetTagOrigin( "tag_flash" );
		orient = drone_model GetTagAngles( "tag_flash" );
		fwd = AnglesToForward( orient );
		MagicBullet( "an94_sp", pos, pos + ( fwd * 100 ) );
		drone_model play_fx( "drone_weapon_flash", pos, orient, undefined, true, "tag_flash" );
	}
}

end_market_vo()
{
	level notify( "kill_market_vo" );
	dialog_end_convo();
}
