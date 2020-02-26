#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\animscripts\zm_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\mp\zombies\_zm_utility.gsh;

#define DIST_RANGE_ATTACK_MIN			( 120 * 120 )
#define DIST_RANGE_ATTACK_MAX			( 600 * 600 )
#define ANGLE_RANGE_ATTACK				0.99	// ~ cos10

#define ANGLE_SPAWN_FACING					0.707	// ~ cos45

#define BOLT_IMPACT_RANGE				( 64 * 64 )
#define BOLT_SHOCK_RANGE_TIME			1
#define BOLT_SHOCK_MELEE_TIME			0.25
#define BOLT_DAMAGE						60

//#define DIST_BUS_ATTACK				( 300 * 300 )
#define DIST_BUS_ATTACK					( 120 * 120 )

#define BUS_TIME_TO_DISABLE				20
#define BUS_DISABLE_TIME				30
#define BUS_SHOCK_TIME					1

#define PHASE_TIME						2000
#define PHASE_STATES					4
#define PHASE_SUBSTATES					3

#define DAMAGE_MELEE_REGEN				1000

//-----------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------
init()
{
	precacheshellshock( "electrocution" );

	init_fx();
	init_phase_anims();

	level.avogadro_spawners = GetEntArray( "avogadro_zombie_spawner", "script_noteworthy" );
	array_thread( level.avogadro_spawners, ::add_spawn_function, maps\mp\zombies\_zm_ai_avogadro::avogadro_prespawn );

	level.zombie_ai_limit_avogadro = 1;

	level thread avogadro_spawning_logic();

	maps\mp\zombies\_zm::register_player_damage_callback( ::avogadro_player_damage_callback );

	/#
	precacheModel( "fx_axis_createfx" );
	level thread avogadro_debug();
	#/
}

init_fx()
{
	level._effect["avogadro_bolt"]				= loadfx( "maps/zombie/fx_zombie_tesla_bolt_secondary" );
}

init_phase_anims()
{
	level.avogadro_phase = [];

	level.avogadro_phase[0] = SpawnStruct();	
	level.avogadro_phase[0].animstate = "zm_teleport_forward";
	level.avogadro_phase[1] = SpawnStruct();	
	level.avogadro_phase[1].animstate = "zm_teleport_left";
	level.avogadro_phase[2] = SpawnStruct();	
	level.avogadro_phase[2].animstate = "zm_teleport_right";
	level.avogadro_phase[3] = SpawnStruct();	
	level.avogadro_phase[3].animstate = "zm_teleport_back";
}

//-----------------------------------------------------------------------
// initial settings and place in position
//-----------------------------------------------------------------------
avogadro_prespawn()
{
	self endon( "death" ); 
	level endon( "intermission" );

	//aitype is "zm_zombie_transit_avogadro"
	self.has_legs = true;
	self.no_gib = 1;

	self.is_avogadro = true;
	
	self.ignore_enemy_count = true;				//does not get taken into account for round progression
	self.ignore_nuke = true;
	self.ignore_lava_damage = true;
	self.ignore_devgui_death = true;
	self.ignore_electric_trap = true;

	self.allowpain = false;

	//start_location = getstruct( "avogadro_start", "targetname" );
	start_location = getent( "core_model", "targetname" );
	if ( isdefined( start_location ) )
	{
		if ( !isdefined( start_location.angles ) )
		{
			start_location.angles = ( 0, 0, 0 );
		}
		self ForceTeleport( start_location.origin, start_location.angles );
	}

	self set_zombie_run_cycle( "walk" );

	self AnimMode( "normal" );
	self OrientMode( "face enemy" );

	self maps\mp\zombies\_zm_spawner::zombie_setup_attack_properties();
	self maps\mp\zombies\_zm_spawner::zombie_complete_emerging_into_playable_area();

	self.zmb_vocals_attack = "zmb_vocals_zombie_attack";

	self.meleeDamage = 5;

	self.actor_damage_func = ::avogadro_damage_func;
	self.non_attacker_func = ::avogadro_non_attacker;

	self.anchor = Spawn( "script_origin", self.origin );
	self.anchor.angles = self.angles;
	self.phase_time = 0;
	
	self.audio_loop_ent = spawn( "script_origin", self.origin );
	self.audio_loop_ent linkto( self, "tag_origin" );

	self.hit_by_melee = 0;
	self.damage_absorbed = 0;
	self.ignoreall = true;

	self.zombie_init_done = true;
	self notify( "zombie_init_done" );

	self.stun_zombie = ::stun_avogadro;
}

//-----------------------------------------------------------------------
// spawn when the power turns on
//-----------------------------------------------------------------------
avogadro_spawning_logic()
{
	level endon( "intermission" );
	if( level.intermission )
	{
		return;
	}

/#
	if ( GetDvarInt( "zombie_cheat" ) == 2 || GetDvarInt( "zombie_cheat" ) >= 4 ) 
	{
		return;
	}
#/

	spawner = getent( "avogadro_zombie_spawner", "script_noteworthy" );
	if ( !isdefined( spawner ) )
	{
		AssertMsg( "No avogadro spawner in the map." );
		return;
	}

	flag_wait( "power_on" );

	ai = spawn_zombie( spawner, "avogadro" );
	if ( !isdefined( ai ) )
	{
		AssertMsg( "Avogadro: failed spawn" );
		return;
	}

	ai waittill( "zombie_init_done" );

	ai.state = "wait_for_player";
	ai thread avogadro_think();

	/*
	/#
		ai thread avogadro_debug_axis();
	#/
	*/
}

//-------------------------------------------------------------------
// main update loop
//-------------------------------------------------------------------
avogadro_think()
{
	while ( 1 )
	{
		if ( is_true( self.in_pain ) )
		{
			wait_network_frame();
			continue;
		}

		switch( self.state )
		{
		case "wait_for_player":
			player_look();
			break;

		case "idle":
			chase_player();
			break;

		case "chasing":
			chase_update();
			break;

		case "chasing_bus":
			chase_bus_update();
			break;

		case "cloud":
			cloud_update();
			break;
		}

		wait_network_frame();
	}
}

player_look()
{
	players = GET_PLAYERS();
	foreach( player in players )
	{
		vec_enemy = self.origin - player.origin;
		vec_facing = AnglesToForward( player.angles );
		norm_facing = VectorNormalize( vec_facing );
		norm_enemy = VectorNormalize( vec_enemy );
		dot = VectorDot( norm_facing, norm_enemy );

		if ( dot > ANGLE_SPAWN_FACING )
		{
			/#
				avogadro_print( "player spotted" );
			#/

			self avogadro_exit();
		}
	}
}

//-------------------------------------------------------------------
// basic follow player
//-------------------------------------------------------------------
chase_player()
{
	self.state = "chasing";

	self set_zombie_run_cycle( "run" );

	self thread maps\mp\zombies\_zm_ai_basic::find_flesh();
}

//-------------------------------------------------------------------
// get close and attack the player
//-------------------------------------------------------------------
chase_update()
{
	if ( self check_bus_attack() )
	{
		self chase_bus();
	}
	else if ( self check_phase() )
	{
		self do_phase();
	}
	else if ( self check_range_attack() )
	{
		self range_attack();
	}
}

//-------------------------------------------------------------------
// check for player(s) on the bus
//-------------------------------------------------------------------
check_bus_attack()
{
	if ( isdefined( level.the_bus ) && level.the_bus.numPlayersOn > 0 )
	{
		return true;
	}

	return false;
}

//-------------------------------------------------------------------
// move towards the closest entry point
//-------------------------------------------------------------------
chase_bus()
{
	self notify( "stop_find_flesh" );
	self notify( "zombie_acquire_enemy" );

	self.chase_bus_entry = undefined;

	// get the closest entry point to run to
	entries = getentarray( "bus_entry_point", "targetname" );
	dist_curr = 0;
	foreach( entry in entries )
	{
		if ( !isdefined( self.chase_bus_entry ) )
		{
			self.chase_bus_entry = entry;
			dist_curr = Distance2DSquared( self.origin, self.chase_bus_entry.origin );
		}
		else
		{
			dist_next = Distance2DSquared( self.origin, entry.origin );
			if ( dist_next < dist_curr )
			{
				dist_curr = dist_next;
				self.chase_bus_entry = entry;
			}
		}
	}

	self set_zombie_run_cycle( "sprint" );

	self.state = "chasing_bus";
}

//-------------------------------------------------------------------
// player(s) on the bus, go after it
//-------------------------------------------------------------------
chase_bus_update()
{
	// no one on the bus...look for players
	if ( isdefined( level.the_bus ) && level.the_bus.numPlayersOn == 0 )
	{
		self chase_player();
		return;
	}

	self SetGoalPos( self.chase_bus_entry.origin );

	dist_sq = DistanceSquared( self.origin, self.chase_bus_entry.origin );
	if ( dist_sq < DIST_BUS_ATTACK )
	{
		self bus_attack();
	}
}

//-------------------------------------------------------------------
// tries to attack 4 different points on the bus to disable it
//-------------------------------------------------------------------
bus_attack()
{
	bus_attack_struct = [];

	bus_attack_struct[0] = SpawnStruct();
	bus_attack_struct[0].window_tag = "window_left_rear_jnt";	 
	bus_attack_struct[0].substate = "bus_attack_back";
	bus_attack_struct[1] = SpawnStruct();
	bus_attack_struct[1].window_tag = "window_right_front_jnt";
	bus_attack_struct[1].substate = "bus_attack_front";
	bus_attack_struct[2] = SpawnStruct();
	bus_attack_struct[2].window_tag = "window_left_2_jnt";		 
	bus_attack_struct[2].substate = "bus_attack_left";
	bus_attack_struct[3] = SpawnStruct();
	bus_attack_struct[3].window_tag = "window_right_3_jnt";		 
	bus_attack_struct[3].substate = "bus_attack_right";

	bus_attack_struct = array_randomize( bus_attack_struct );

	self.state = "attacking_bus";
	self.bus_attack_time = 0;
	self.bus_disabled = false;
	self.ignoreall = true;

	self bus_disable( bus_attack_struct[0] );
	if ( !self.bus_disabled )
	{
		self bus_disable( bus_attack_struct[1] );
	}
	if ( !self.bus_disabled )
	{
		self bus_disable( bus_attack_struct[2] );
	}
	if ( !self.bus_disabled )
	{
		self bus_disable( bus_attack_struct[3] );
	}

	self unlink();

	if ( !self.bus_disabled )
	{
		self avogadro_exit( "bus" );
	}
	else
	{
		level.the_bus maps\mp\zm_transit_bus::bus_disabled_by_emp( BUS_DISABLE_TIME );

		self.state = "idle";
		self.ignoreall = false;
	}
}

//-------------------------------------------------------------------
// play bus attack and shock players
//-------------------------------------------------------------------
bus_disable( bus_attack_struct )
{
	self endon( "melee_pain" );

	origin = level.the_bus GetTagOrigin( bus_attack_struct.window_tag );
	angles = level.the_bus GetTagAngles( bus_attack_struct.window_tag );

	self avogadro_teleport( origin, angles, 0.5 );
	self linkto( level.the_bus, bus_attack_struct.window_tag );

	self AnimScripted( self.origin, self.angles, "zm_bus_attack", bus_attack_struct.substate );

	success = false;
	self.mod_melee = 0;
	self.bus_shock_time = 0;
	while ( 1 )
	{
		wait( 0.1 );
		self.bus_attack_time += 0.1;
		if ( self.bus_attack_time >= BUS_TIME_TO_DISABLE )
		{
			self.bus_disabled = true;
			break;
		}

		self.bus_shock_time += 0.1;
		if ( self.bus_shock_time >= 2 )
		{
			self.bus_shock_time = 0;
			players = GET_PLAYERS();
			foreach( player in players )
			{
				if ( is_true( player.isOnBus ) )
				{
					player SetElectrified( BUS_SHOCK_TIME );
				}
			}
		}
	}
}

//-------------------------------------------------------------------
// fly away
//-------------------------------------------------------------------
avogadro_exit( from )
{
	self.state = "exiting";

	self notify( "stop_find_flesh" );
	self notify( "zombie_acquire_enemy" );
	
	self playsound( "zmb_avogadro_death" );
	self.audio_loop_ent stoploopsound( .5 );
	
	if ( isdefined( from ) && from == "bus" )
	{
		self AnimScripted( self.origin, self.angles, "zm_bus_win" );
		maps\mp\animscripts\zm_shared::DoNoteTracks( "bus_win_anim" );
	}
	else
	{
		self AnimScripted( self.origin, self.angles, "zm_exit" );
		maps\mp\animscripts\zm_shared::DoNoteTracks( "exit_anim" );
	}

	self Hide();
	self.hit_by_melee = 0;

	self.anchor.origin = self.origin;
	self.anchor.angles = self.angles;
	self linkto( self.anchor );

	self.return_round = level.round_number + RandomIntRange( 2, 5 );

	self.state = "cloud";
}

//-------------------------------------------------------------------
// check if it's time to return
//-------------------------------------------------------------------
cloud_update()
{
	return_from_cloud = false;

	if ( is_true( self.wait_for_power ) )
	{
		// power needs to be off or turn off first
		while ( flag( "power_on" ) )
		{
			wait_network_frame();
		}

		flag_wait( "power_on" );
		/#
			avogadro_print( "return from power" );
		#/
		return_from_cloud = true;
	}
	else if ( level.round_number >= self.return_round )
	{
		/#
			avogadro_print( "return from round" );
		#/
		return_from_cloud = true;
	}

	if ( is_true( return_from_cloud ) )
	{
		new_origin = maps\mp\zombies\_zm::check_for_valid_spawn_near_team();
		if ( isdefined( new_origin ) )
		{
			self Show();
			playsoundatposition( "zmb_avogadro_spawn_3d", new_origin );
			self.audio_loop_ent playloopsound( "zmb_avogadro_loop", .5 );
			self unlink();
			self AnimScripted( groundpos( new_origin ), self.anchor.angles, "zm_arrival" );
			maps\mp\animscripts\zm_shared::DoNoteTracks( "arrival_anim" );

			self.ignoreall = false;
			self.state = "idle";
		}
	}
}

//-------------------------------------------------------------------
// disappear and move to new location
//-------------------------------------------------------------------
avogadro_teleport( dest_pos, dest_angles, lerp_time )
{
	self hide();
	self playsound( "zmb_avogadro_warp_out" );
	self.anchor.origin = self.origin;
	self.anchor.angles = self.angles;
	self linkto( self.anchor );

	self.anchor MoveTo( dest_pos, lerp_time );
	self.anchor waittill( "movedone" );
	self.anchor.origin = dest_pos;
	self.anchor.angles = dest_angles;

	self unlink();

	wait_network_frame();

	self ForceTeleport( dest_pos, dest_angles );

	self show();
	self playsound( "zmb_avogadro_warp_in" );
}

//-------------------------------------------------------------------
// check distance and facing
//-------------------------------------------------------------------
check_range_attack()
{
	enemy = self.favoriteenemy;
	if ( isdefined( enemy ) )
	{
		vec_enemy = enemy.origin - self.origin;
		dist_sq = LengthSquared( vec_enemy );

		// within 10 - 50 ft
		if ( dist_sq > DIST_RANGE_ATTACK_MIN && dist_sq < DIST_RANGE_ATTACK_MAX )
		{
			vec_facing = AnglesToForward( self.angles );
			norm_facing = VectorNormalize( vec_facing );
			norm_enemy = VectorNormalize( vec_enemy );
			dot = VectorDot( norm_facing, norm_enemy );

			// within 20 degrees
			if ( dot > ANGLE_RANGE_ATTACK )
			{
				// no obstructions
				enemy_eye_pos = enemy GetEye();
				eye_pos = self GetEye();
				passed = BulletTracePassed( eye_pos, enemy_eye_pos, false, undefined );

				if ( passed )
				{
					return true;
				}
			}
		}
	}

	return false;
}

//-----------------------------------------------------------------------
// play anims for the range attack
//-----------------------------------------------------------------------
range_attack()
{
	self endon( "melee_pain" );

	enemy = self.favoriteenemy;
	if ( isdefined( enemy ) )
	{
		self thread shoot_bolt_wait( "ranged_attack", enemy );

		self AnimScripted( self.origin, self.angles, "zm_ranged_attack_in" );
		maps\mp\animscripts\zm_shared::DoNoteTracks( "ranged_attack" );

		self AnimScripted( self.origin, self.angles, "zm_ranged_attack_loop" );
		maps\mp\animscripts\zm_shared::DoNoteTracks( "ranged_attack" );

		self AnimScripted( self.origin, self.angles, "zm_ranged_attack_out" );
		maps\mp\animscripts\zm_shared::DoNoteTracks( "ranged_attack" );
	}
}

//-----------------------------------------------------------------------
// wait and fire a bolt
//-----------------------------------------------------------------------
shoot_bolt_wait( animname, enemy )
{
	self endon( "melee_pain" );

	self waittillmatch( animname, "fire" );

	self thread shoot_bolt( enemy );
}

shoot_bolt( enemy )
{
	source_pos = self GetTagOrigin( "tag_weapon_right" );
	target_pos = enemy GetEye();

	bolt = Spawn( "script_model", source_pos );
	bolt SetModel( "tag_origin" );

	wait_network_frame();
	
	self playsound( "zmb_avogadro_attack" );
	fx = PlayFxOnTag( level._effect[ "avogadro_bolt" ], bolt, "tag_origin" );

	bolt MoveTo( target_pos, 0.2 );
	bolt waittill( "movedone" );

	bolt check_bolt_impact( enemy );
	bolt delete();
}

//-----------------------------------------------------------------------
// play some fx and slow player if it hits
//-----------------------------------------------------------------------
check_bolt_impact( enemy )
{
	if ( is_player_valid( enemy ) )
	{
		enemy_eye_pos = enemy GetEye();

		dist_sq = DistanceSquared( self.origin, enemy_eye_pos );
		if ( dist_sq < BOLT_IMPACT_RANGE )
		{
			// in case player hid behind something
			passed = BulletTracePassed( self.origin, enemy_eye_pos, false, undefined );
			if ( passed )
			{
				enemy SetElectrified( BOLT_SHOCK_RANGE_TIME );
				enemy shellshock( "electrocution", BOLT_SHOCK_RANGE_TIME );

				enemy DoDamage( BOLT_DAMAGE, enemy.origin );
			}
		}
	}
}

get_random_phase_state()
{
	index = RandomInt( PHASE_STATES );
	state = level.avogadro_phase[ index ].animstate;
	return state;
}

//-------------------------------------------------------------------
// clear to move
//-------------------------------------------------------------------
check_phase()
{
	if ( GetTime() > self.phase_time )
	{
		if ( is_true( self.is_traversing ) )
		{
			self.phase_time = GetTime() + PHASE_TIME;
			return false;
		}

		self.phase_state = get_random_phase_state();
		self.phase_substate = RandomInt( PHASE_SUBSTATES );

		anim_id = self GetAnimFromASD( self.phase_state, self.phase_substate );

		if ( self MayMoveFromPointToPoint( self.origin, getAnimEndPos( anim_id ) ) )
		{
			self.state = "phasing";
			return true;
		}
	}

	return false;
}

//-------------------------------------------------------------------
// setup and play the phase anim
//-------------------------------------------------------------------
do_phase()
{
	self endon( "death" );

	self notify( "stop_find_flesh" );
	self notify( "zombie_acquire_enemy" );
	self.ignoreall = true;

	self AnimCustom( ::play_phase_anim );

	self waittill( "phase_anim_done" );
	self.ignoreall = false;

	self.state = "idle";
}

play_phase_anim()
{
	self endon( "death" );

	self Hide();
	self playsound( "zmb_avogadro_warp_out" );
	self SetAnimStateFromASD( self.phase_state, self.phase_substate );
	self OrientMode( "face enemy" );
	maps\mp\animscripts\zm_shared::DoNoteTracks( "teleport_anim" );
	self Show();
	self OrientMode( "face default" );
	self playsound( "zmb_avogadro_warp_in" );
	self.phase_time = GetTime() + PHASE_TIME;
	self notify( "phase_anim_done" );
}

//-----------------------------------------------------------------------
// melee attack will electrify player
//-----------------------------------------------------------------------
avogadro_player_damage_callback( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if ( isdefined( eInflictor ) && is_true( eInflictor.is_avogadro ) )
	{
		if ( sMeansOfDeath == "MOD_MELEE" )
		{
			self SetElectrified( BOLT_SHOCK_MELEE_TIME );
			self shellshock( "electrocution", BOLT_SHOCK_MELEE_TIME );
		}
	}

	return -1;
}

//-------------------------------------------------------------------
// play the appropriate pain anim
//-------------------------------------------------------------------
avogadro_pain()
{
	self endon( "melee_pain" );

	self.in_pain = true;

	substate = 0;
	if ( self.hit_by_melee == 1 )
	{
		substate = 2;
	}
	else if ( self.hit_by_melee == 2 )
	{
		substate = 1;
	}

	animstate = "zm_pain";
	if ( self.state == "attacking_bus" )
	{
		animstate = "zm_bus_pain";
	}

	if ( self.hit_by_melee < 4 )
	{
		self AnimScripted( self.origin, self.angles, animstate, substate );
		maps\mp\animscripts\zm_shared::DoNoteTracks( "pain_anim" );
	}
	else
	{
		self avogadro_exit();
	}

	self.in_pain = false;
}

//-----------------------------------------------------------------------
// doesn't take damage
//-----------------------------------------------------------------------
avogadro_damage_func( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if ( self.state == "exiting" || self.state == "phasing" )
	{
		return 0;
	}

	if ( sMeansOfDeath == "MOD_MELEE" )
	{
		if ( isplayer( eInflictor ) )
		{
			eInflictor SetElectrified( BOLT_SHOCK_MELEE_TIME );
			eInflictor shellshock( "electrocution", BOLT_SHOCK_MELEE_TIME );
		}

		self notify( "melee_pain" );
		
		if ( sWeapon == "tazer_knuckles_zm" )
		{
			self.hit_by_melee += 2;
		}
		else
		{
			self.hit_by_melee++;
		}
		
		self thread avogadro_pain();
		/#
			avogadro_print( "hit_by_melee: " + self.hit_by_melee );
		#/
	}
	else
	{
		self update_damage_absorbed( iDamage );
	}

	return 0;
}

//-----------------------------------------------------------------------
// non melee damage increases health
//-----------------------------------------------------------------------
update_damage_absorbed( damage )
{
	if ( self.hit_by_melee > 0 )
	{
		self.damage_absorbed += damage;
		if ( self.damage_absorbed >= DAMAGE_MELEE_REGEN )
		{
			self.damage_absorbed = 0;
			self.hit_by_melee--;

			/#
				avogadro_print( "regen - hit_by_melee: " + self.hit_by_melee );
			#/
		}
	}
}

//-----------------------------------------------------------------------
// hit by a turret
//-----------------------------------------------------------------------
avogadro_non_attacker( damage, weapon )
{
	if ( weapon == "zombie_bullet_crouch_zm" )
	{
		self update_damage_absorbed( damage );
	}

	return 0;
}

//-----------------------------------------------------------------------
// hit by emp...immediately go away
//-----------------------------------------------------------------------
stun_avogadro()
{
	if ( self.state == "phasing" )
	{
		return;
	}

	if ( self.hit_by_melee < 4 )
	{
		self notify( "melee_pain" );
		self.hit_by_melee += 4;
		self thread avogadro_pain();
	}

	if ( self maps\mp\zombies\_zm_zonemgr::entity_in_zone( "zone_prr" ) )
	{
		self.wait_for_power = true;
		/#
			avogadro_print( "come back on power" );
		#/
	}
}

//-----------------------------------------------------------------------
// DEBUG funcs
//-----------------------------------------------------------------------
/#
avogadro_debug_axis()
{
	self endon( "death" );

	while ( 1 )
	{
		if ( !isdefined( self.debug_axis ) )
		{
			self.debug_axis = spawn( "script_model", self.origin );
			self.debug_axis SetModel( "fx_axis_createfx" );
			//recordEnt( self.debug_axis );
		}
		else
		{
			self.debug_axis.origin = self.origin;
			self.debug_axis.angles = self.angles;
		}

		wait_network_frame();
	}
}
#/

/#
avogadro_debug()
{
	//level.avogadro_debug = true;
}
#/

/#
avogadro_print( str )
{
	if ( is_true( level.avogadro_debug ) )
	{
		iprintln( "avogadro: " + str );
		if ( isdefined( self.debug_msg ) )
		{
			self.debug_msg[ self.debug_msg.size ] = str;
			if ( self.debug_msg.size > 64 )
			{
				self.debug_msg = [];
			}
		}
		else
		{
			self.debug_msg = [];
			self.debug_msg[ self.debug_msg.size ] = str;
		}
	}
}
#/
