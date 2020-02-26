#include animscripts\utility;
#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_scene;
#include maps\_skipto;
#include maps\_turret;
#include maps\_vehicle;
#include maps\_loadout;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

// internal references
#include maps\createart\blackout_art;

//
//

#define POWER_SURGE_EXPLODER	1000

rand_chance( pct_chance )
{
	roll = RandomFloatRange(0.0, 1.0);
	return roll < pct_chance;
}

// sets flags for the skipto's and exits out at appropriate skipto point.  All previous skipto setups in this functions will be called before the current skipto setup is called
skipto_setup()
{
	skipto = level.skipto_point;
	
	SetSavedDvar( "r_skyTransition", 1 ); // skybox starts flipped
	
	// off until it's time for menendez to use it.
	trigger_off( "computer_server_use", "targetname" );

//global_skiptos

	set_player_mason( true );
	exploder( POWER_SURGE_EXPLODER );
	
	if (skipto == "mason_start" )
		return;
	
	if (skipto == "mason_interrogation_room")
	{
		return;													
	}
	
	vision_set_interrogation();
	level thread maps\blackout_amb::force_start_alarm_sounds();
	load_needed_gump();
	
	if (skipto == "mason_wakeup")
	{
		return;													
	}
	
	stop_exploder( POWER_SURGE_EXPLODER );
	
	if (level.player HasPerk( "specialty_intruder" ))
	{
		level.player GiveWeapon( "tazer_knuckles_sp" );
	}
	
	if (skipto == "mason_hallway" )
	{
		return;
	}
	
	vision_set_hallway();

	if (skipto == "mason_salazar_exit")
	{
		return;													
	}
	
	sea_cowbell();
	flag_set( "at_bridge_entry" );

	if (skipto == "mason_bridge")
	{
		return;													
	}
	
	vision_set_bridge();
	activate_bridge_launchers();
	flag_set( "at_catwalk" );

	if (skipto == "mason_catwalk")
		return;													
	
	end_sea_cowbell();
	end_bridge_launchers();

	if (skipto == "mason_lower_level")
		return;													

	flag_set( "at_defend_objective" );
	
	if (skipto == "mason_defend")
		return;													

	if (skipto == "mason_cctv")
		return;													

	set_player_menendez();
	
	if ( skipto == "menendez_start" )
		return;
	
	if (skipto == "menendez_meat_shield" )
		return;
	
	if (skipto == "menendez_betrayal" )
		return;
	
	// Farid kills defalco.
	if ( level.is_farid_alive )
	{
		level.is_defalco_alive = false;
	}
	
	if (skipto == "menendez_combat")
		return;													
	
	flag_set( "menendez_plane_start" );
	
	if (skipto == "menendez_hangar")
		return;													

	SetSavedDvar( "r_skyTransition", 0 ); // unflip the skybox
	
	if (skipto == "menendez_plane")
		return;													

	if (skipto == "menendez_deck")
		return;													
	
	set_player_mason();

	if (skipto == "mason_vent")
		return;													
	
	vision_set_vent();
	trigger_on( "computer_server_use", "targetname" );

	if (skipto == "mason_server_room")
		return;
	
	vision_set_mason_serverroom();
	
	if (skipto == "mason_hangar")
		return;
	
	if (skipto == "mason_salazar_caught")
		return;
	
	if (skipto == "mason_elevator")
		return;
	
	if (skipto == "mason_deck")
		return;
	
	if (skipto == "mason_plane_crash")
		return;
	
	if (skipto == "mason_deck_final")
		return;
	
	if (skipto == "mason_anderson")
		return;
}

blend_exposure_over_time( n_exposure_final, n_time )
{
	n_frames = Int( n_time * 20 );
	
	n_exposure_current = GetDvarFloat( "r_exposureValue" );
	n_exposure_change_total = n_exposure_final - n_exposure_current;
	n_exposure_change_per_frame = n_exposure_change_total / n_frames;
	
	SetDvar( "r_exposureTweak", 1 );
	for ( i = 0; i < n_frames; i++ )
	{
		SetDvar( "r_exposureValue", n_exposure_current + ( n_exposure_change_per_frame * i ) );
		wait 0.05;
	}
	
	SetDvar( "r_exposureValue", n_exposure_final );
}

run_distant_explosions()
{	
	while ( true )
	{
		flag_wait( "distant_explosions_on" );
		
		// offset the first one.
		wait RandomFloatRange( 3.0, 7.0 );
		
		size = RandomFloatRange( 0.2, 0.4 );
		duration = RandomFloatRange( 0.5, 1.5 );
		
		level.player playsound ("exp_carrier_impact");
		PlayRumbleOnPosition( "grenade_rumble", level.player.origin + ( 256, 0, 0 ) );
		Earthquake( size, duration, level.player.origin, 100 );
		
		wait RandomFloatRange( 10.0, 20.0 );
	}
}

// disables the turret's trigger when the turret dies.
//
remove_dead_turret_trigger( trigger )
{
	self waittill_any( "death", self.targetname + "_perk_done" );
	set_objective( level.OBJ_HACK_PERK, self, "done", undefined, false );
	trigger Delete();
}

hackable_turret_enable( str_turret_name )
{
	level notify( str_turret_name + "_perk_ready" );
	
	turret = GetEnt( str_turret_name, "targetname" );
	if ( isdefined( turret ) )
	{
		// put the panel in position.
		if ( isdefined( turret.str_hack_box_anim ) )
		{
			run_scene_first_frame( turret.str_hack_box_anim );
		}
	}
	wait_network_frame();
}

hackable_turret_disable( str_turret_name )
{
	level notify( str_turret_name + "_perk_done" );
	wait_network_frame();
}

set_turret_callback( callback_func )
{
	self.m_turret_callback = callback_func;
}

// Does a little damage to the player if he's using the turret.
//
run_turret_damage()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "turret_entered" );
		
		while ( flag( "player_using_turret" ) )
		{
			self waittill( "damage",  damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
			if ( flag( "player_using_turret" ) )
			{
				if ( isdefined( attacker ) )
				{
					level.player DoDamage( 10, attacker.origin );
				}
			}
		}
	}
}

pull_player_off_turret_when_destroyed( turret, original_origin, original_angles, original_weapon )
{
	// if the player voluntarily exited, don't sweat it.
	turret endon( "turret_exited" );
	
	// wait for the turret to die.
	turret waittill_any( "death" );
	
	flag_clear( "player_using_turret" );
	
	if ( isdefined( turret.m_turret_callback ) )
	{
		turret [[turret.m_turret_callback]]( false );
	}
	level.player SetClientDvar( "cg_objectiveIndicatorPerkFarFadeDist", 1024 );
	level.player.health = level.player.maxhealth;
	
	// put the player back where he was and restore his weapon state.
	level.player SetOrigin( original_origin );
	level.player SetPlayerAngles( original_angles );
	level.player SwitchToWeapon( original_weapon );
}

turret_set_team( team )
{
	self.vteam = team;
}

// waits for the player to have the intruder perk, then waits for
// him to activate the assocaited turret via its trigger, then sets
// him up to use the turret.
//
run_hackable_turret( trig )
{
	self endon( "death" );
	
	// wait for the player variable to be initialized.
	level flag_wait( "level.player" );
	
	trig trigger_off();
	
	level waittill( self.targetname + "_perk_ready" );
	
	level.player waittill_player_has_lock_breaker_perk();
	
	trig trigger_on();
	
	set_objective( level.OBJ_HACK_PERK, trig, "interact", undefined, false );
	
	self thread run_turret_damage();
	
	while ( true )
	{
		trig waittill ( "trigger" );
		
		if ( isdefined( self.m_turret_callback ) )
		{
			self [[self.m_turret_callback]]( true );
		}
		
		// A little hacky, but gets the job done.  Don't let the indicator show up
		// when the player's on the turret.  Make sure to re-set it when the player
		// is back off the turret.
		//
		level.player SetClientDvar( "cg_objectiveIndicatorPerkFarFadeDist", 64 );
		
		// grab the player's position at the time of hacking
		player_pos = level.player.origin;
		player_angles = level.player.angles;
		
		prev_weapon = level.player GetCurrentWeapon();
		
		// play the "hacking" animation.
		if ( isdefined( self.str_hack_player_anim ) )
		{
			level thread run_scene( self.str_hack_player_anim );
			level thread run_scene( self.str_hack_box_anim );
			
			wait_network_frame();
			
			player_body = get_model_or_models_from_scene( self.str_hack_player_anim, "player_body" );
			player_body Attach( "c_usa_cia_masonjr_viewbody_vson", "J_WristTwist_LE" );
			
			torch_prop = get_model_or_models_from_scene( self.str_hack_player_anim, self.targetname + "_torch" );
			
			torch_prop play_fx( "laser_cutter_sparking", undefined, undefined, "stop_fx", true, "tag_fx" );
			torch_prop play_fx( "fx_laser_cutter_on", undefined, undefined, "stop_fx", true, "tag_fx" );
			
			scene_wait( self.str_hack_player_anim );
			
			level.player FreezeControls( true );
			wait 0.2;
			level.player FreezeControls( false );
			
			// no more hack animation after the first one for each turret.
			self.str_hack_player_anim = undefined;
		}
		
		flag_set( "player_using_turret" );
		self notify( "turret_entered" );
		
		self MakeVehicleUsable();
		self UseBy( level.player );
		self delay_thread( 4.0, ::turret_set_team, "allies" );
		self notify( "turret_hacked" );
		flag_set("intruder_perk_used");
		level thread pull_player_off_turret_when_destroyed( self, player_pos, player_angles, prev_weapon );
		
		while ( level.player.usingvehicle || level.player.usingturret )
		{
			wait_network_frame();
		}
		
		flag_clear( "player_using_turret" );
		
		if ( isdefined( self.m_turret_callback ) )
		{
			self [[self.m_turret_callback]]( false );
		}
		level.player SetClientDvar( "cg_objectiveIndicatorPerkFarFadeDist", 1024 );
		level.player.health = level.player.maxhealth;
		
		self MakeVehicleUnusable();
		
		// move the player back where he was.
		level.player SetOrigin( player_pos );
		level.player SetPlayerAngles( player_angles );
		level.player SwitchToWeapon( prev_weapon );
		self delay_thread( 4.0, ::turret_set_team, "axis" );
		self notify( "turret_exited" );
		
		wait 0.5;
	}
}

become_vulnerable_callback( ai )
{
	ai stop_magic_bullet_shield();
}

become_invulnerable_callback( ai )
{
	ai magic_bullet_shield();
}

turret_kill_challenge( str_notify )
{
	self endon( "death" );

	while ( true )
	{
		self waittill( "damage",  damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		if ( IsPlayer( attacker ) )
		{
			explosive_damage = (type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_EXPLOSIVE" || type == "MOD_EXPLOSIVE_SPLASH" || type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH");
			if ( explosive_damage )
			{
				// completely destroy this thing and stop processing it.
				self DoDamage( self.health * 2, self.origin, level.player, level.player, "none", "MOD_EXPLOSIVE" );
				level notify ( str_notify );
				return;
			} else {
				// no longer eligible.
				return;
			}
		}
	}
}

// Initializes the chalDoDamagelenge wherein the goal is to kill each turret with a single, explosive shot.
//
init_turret_kill_challenge( str_notify )
{
	vehicles = GetEntArray( "script_vehicle", "classname" );
	foreach ( veh in vehicles )
	{
		if ( veh.vehicletype == "turret_cic" )
		{
			veh thread turret_kill_challenge( str_notify );
		}
	}
}

override_cic_turret_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if ( IsPlayer( eAttacker ) )
	{
		iDamage = iDamage * 2;
	}
	
	return iDamage;
}

init_turret_damage_override()
{
	vehicles = GetEntArray( "script_vehicle", "classname" );
	foreach ( veh in vehicles )
	{
		if ( veh.vehicletype == "turret_cic" )
		{
			veh.overrideVehicleDamage = ::override_cic_turret_damage;
		}
	}
}

// initializes usable turrets in Blackout.
//
// the turrets should be named "turret_trigger" and should
// have a target corresponding to the turret they activate.
//
init_hackable_turrets()
{
	trigs = GetEntArray( "turret_trigger", "targetname" );
	
	for ( i = 0; i < trigs.size; i++ )
	{
		turret = GetEnt( trigs[i].target, "targetname" );
		
		// The script-noteworthy on the trigger is the name of the box prop in-world.
		if ( isdefined( trigs[i].script_noteworthy ) )
		{
			hack_box = GetEnt( trigs[i].script_noteworthy, "targetname" );
			
			turret.str_hack_box_anim = hack_box.targetname;
			turret.str_hack_player_anim = hack_box.targetname + "_player";
			
			add_scene( turret.str_hack_box_anim, hack_box.targetname );
			add_prop_anim( turret.targetname + "_panel", %animated_props::o_specialty_blackout_intruder_panel, "p6_intruder_perk_box_panel", true );
			
			add_scene( turret.str_hack_player_anim, hack_box.targetname );
			add_player_anim( "player_body", %player::int_specialty_blackout_intruder, true );
			add_prop_anim( turret.targetname + "_torch", %animated_props::o_specialty_blackout_intruder_cutter, "t6_wpn_laser_cutter_prop", true );
		}
		
		Assert( IsDefined( turret ) );
		turret thread run_hackable_turret( trigs[i] );
		turret thread remove_dead_turret_trigger( trigs[i] );
	}
	
	defend_turret = GetEnt( "defend_turret", "targetname" );
	defend_turret set_turret_callback( maps\blackout_defend::defend_turret_callback );
}

player_has_sniper_weapon()
{
	a_current_weapons = level.player GetWeaponsList();
	
	foreach ( weapon in a_current_weapons )
	{
		if ( WeaponIsSniperWeapon( weapon ) || ( IsSubStr( weapon, "metalstorm" ) ) )
		{
			return true;
		}
	}
	
	return false;
}

// breadcrumb to an objective then set a flag when done.
//
breadcrumb_and_flag( breadcrumb, objective, flag_name, show_message = true )
{
	level endon( "clear_old_breadcrumb" );
	first_trig = GetEnt( breadcrumb, "targetname" );
	set_objective( objective, first_trig, "breadcrumb", undefined, show_message );
	if ( IsDefined(first_trig.target) )
	{
		objective_breadcrumb( objective, breadcrumb );
	} else {
		first_trig waittill( "trigger" );
	}
	
	flag_set( flag_name );
}

/* ------------------------------------------------------------------------------------------
	HERO SKIPTO: Starts a Hero in a skipto at the specified scriptstruct

	Hero Characters are:-
		"han", "harper", "salazar", "redshirt1", "redshirt2"

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
	
	return( ai_hero );
}

precache_player_models()
{
	level.player_viewmodel_menendez = "c_usa_masonjr_karma_viewhands";
	level.player_hands_menendez = "c_usa_masonjr_karma_viewhands";
	level.player_body_menendez = "c_usa_woods_panama_viewbody";
	
	PrecacheModel( level.player_viewmodel_menendez );
	PrecacheModel( level.player_body_menendez );
	
	level.player_viewmodel_mason = "c_usa_cia_masonjr_armlaunch_viewhands";
	level.player_interactive_model_hands_mason = "c_usa_cia_masonjr_armlaunch_viewhands";
	level.player_interactive_model_body_mason = "c_usa_cia_masonjr_armlaunch_viewbody";
	
	PrecacheModel( level.player_viewmodel_mason );
	PrecacheModel( level.player_interactive_model_body_mason );
}

get_furthest_offscreen( array )
{
	// impossibly bad.  1 is the worst it can be.
	best_choice_dot = 2.0;
	best_choice = undefined;
	
	fvec = AnglesToForward( level.player.angles );
	foreach ( obj in array )
	{
		to_obj = VectorNormalize( obj.origin - level.player.origin );
		dot = VectorDot( to_obj, fvec );
		if ( dot < best_choice_dot )
		{
			best_choice = obj;
			best_choice_dot = dot;
		}
	}
	
	return best_choice;
}

enable_node( do_enable )
{
	SetEnableNode( self, do_enable );
}

set_player_menendez()
{
	level.player AllowSprint( false );
	level.player AllowJump( false );
	setsaveddvar( "g_speed", 90 );
	level.player_is_menendez = true;
	level.player EnableInvulnerability();
	
	SetDvar( "scr_damagefeedback", 0 );
	
	mason_trigs = GetEntArray( "mason_only_trigger", "script_noteworthy" );
	menendez_trigs = GetEntArray( "menendez_only_trigger", "script_noteworthy" );
	
	array_func( mason_trigs, ::trigger_off );
	array_func( menendez_trigs, ::trigger_on );
	
	mason_nodes = GetNodeArray( "mason_only_node", "script_noteworthy" );
	menendez_nodes = GetNodeArray( "menendez_only_node", "script_noteworthy" );
	
	array_func( mason_nodes, ::enable_node, false );
	array_func( menendez_nodes, ::enable_node, true );
	
	if ( level.player_viewmodel != level.player_viewmodel_menendez )
	{	
		level.player_interactive_hands = level.player_hands_menendez;
		level.player_interactive_model = level.player_body_menendez;
		level.player_viewmodel = level.player_viewmodel_menendez;
		
		level.player SetViewModel( level.player_viewmodel );
	}
	
	level.player hide_hud();
	
	maps\_friendlyfire::turnOff();
	
//	SetSavedDvar( "player_standingViewHeight", level.m_menendez_height );
}

set_player_mason( initial_setup = false )
{
	level.player AllowSprint( true );
	level.player AllowJump( true );
	level.player_is_menendez = false;
	level.player DisableInvulnerability();
	
	if ( initial_setup )
	{
		level.m_original_player_speed = GetDvarFloatDefault( "g_speed", 190 );
	} else {
		setsaveddvar( "g_speed", level.m_original_player_speed );
	}
	SetDvar( "scr_damagefeedback", 1 );
	
	mason_trigs = GetEntArray( "mason_only_trigger", "script_noteworthy" );
	menendez_trigs = GetEntArray( "menendez_only_trigger", "script_noteworthy" );
	
	array_func( mason_trigs, ::trigger_on );
	array_func( menendez_trigs, ::trigger_off );
	
	mason_nodes = GetNodeArray( "mason_only_node", "script_noteworthy" );
	menendez_nodes = GetNodeArray( "menendez_only_node", "script_noteworthy" );
	
	array_func( mason_nodes, ::enable_node, true );
	array_func( menendez_nodes, ::enable_node, false );
	
	if ( level.player_viewmodel != level.player_viewmodel_mason )
	{	
		level.player_interactive_hands = level.player_interactive_model_hands_mason;
		level.player_interactive_model = level.player_interactive_model_body_mason;
		level.player_viewmodel = level.player_viewmodel_mason; 
		
		level.player SetViewModel( level.player_viewmodel );
	}
	
	if ( !initial_setup )
	{
		level.player show_hud();
	}
	
	maps\_friendlyfire::turnBackOn();
	
	SetTimeScale( 1.0 );
	
//	SetSavedDvar( "player_standingViewHeight", level.m_mason_height );
}

play_pip( str_bik_name )
{
	maps\_glasses::play_bink_on_hud( str_bik_name, false, true );
}

m32_do_autokill()
{
	self endon( "death" );
	wait 1.0;
	self die();
//	enemy DoDamage( 50000, self.origin, self, undefined, "MOD_PROJECTILE" );
}

run_m32_autokill()
{
	while ( !(self HasWeapon( "m32_gas_sp" ) ) )
	{
		wait 1.0;
	}
	
	can_see_dot = cos( 20 );
	const max_dist_sq = 1024 * 1024;
	
	while ( self HasWeapon( "m32_gas_sp" ) )
	{
		self waittill( "weapon_fired" );
		
		enemies = GetAIArray( "axis" );
		valid_enemies = [];
		
		foreach ( enemy in enemies )
		{
			// distance check.
			if ( Distance2DSquared( self.origin, enemy.origin ) > max_dist_sq )
			{
				continue;
			}
			
			// facing check.
			to_enemy = enemy.origin - self.origin;
			to_enemy = VectorNormalize( to_enemy );
			my_fwd = AnglesToForward( self.angles );
			aim_dot = VectorDot( my_fwd, to_enemy );
			
			if ( aim_dot > can_see_dot )
			{
				// trace check.
				if ( enemy.targetname == "crowbar_attacker_ai" )
				{
					enemy ent_flag_set( "launch_me" );
				} else {
					success = BulletTracePassed( level.player GetEye(), enemy.origin +( 0, 0, 48 ), false, enemy ); 
					if ( success )
					{
						valid_enemies[valid_enemies.size] = enemy;
					}
				}
			}
		}
		
		// directly hit no more than 1 enemy at a time.
		enemy = get_closest_living( self.origin, valid_enemies, 2048 );
		if ( isdefined( enemy ) )
		{
			enemy thread m32_do_autokill();
		}
	}
}

handle_m32_gas_death()
{
	if ( is_true(self.magic_bullet_shield) )
	{
		return;
	}
	
	if( self.damageWeapon == "m32_gas_sp" && self.damagemod != "MOD_PROJECTILE_SPLASH" )
	{
		initial_force = self.damagedir + ( 0, 0, 0.2 ); 
		initial_force *= 100;
		self StartRagdoll( self.damagemod == "MOD_CRUSH" ); 
		self LaunchRagdoll( initial_force, self.damageLocation ); 	
		return true;
	}
	else if(self.damageWeapon == "m32_gas_sp")
	{
		self.a.forcegasdeath = true;
	}
	
	return false; // false, as the death is not really handled, we just tweaked what we need
}

// allies don't take damage from the m32.
//
handle_m32_allies()
{
	// Allies ignore the m32.
	if ( self.damageWeapon == "m32_gas_sp" )
    {
		return true;
    }
	
	return false;
}

waittill_player_away( distance, distance_2d = true )
{
	dist_sq = distance * distance;
	my_dist_sq = dist_sq - 10;
	
	do {
		if ( distance_2d )
		{
			my_dist_sq = Distance2DSquared( self.origin, level.player.origin );
		} else {
			my_dist_sq = DistanceSquared( self.origin, level.player.origin );
		}
		
		wait_network_frame();
	} while ( my_dist_sq < dist_sq );
}

// Call on an object you want to see if it's near the player
//
// distance: how far to consider "Nearby"
// override_notify: a notify that will cause this to return anyway.
// distance_2d: true to check flat distance, false to check 3d distance.
//
// returns: the distance from the player you are.
waittill_player_nearby( distance, override_notify, distance_2d = true, do_trace = false )
{
	if ( isdefined( override_notify ) )
	{
		self endon( override_notify );
	}
	
	dist_sq = distance * distance;
	my_dist_sq = dist_sq + 10;
	
	do {
		if ( distance_2d )
		{
			my_dist_sq = Distance2DSquared( self.origin, level.player.origin );
		} else {
			my_dist_sq = DistanceSquared( self.origin, level.player.origin );
		}
		
		can_see = true;
		if ( do_trace )
		{
			can_see = level.player is_player_looking_at( self.origin, 0.5, true, true );
		}
		
		wait_network_frame();
	} while ( my_dist_sq > dist_sq || !can_see );
	
	return Sqrt( my_dist_sq );
}

kill_behind_player( forward_struct )
{
	self endon( "death" );
	
	room_dir_struct = GetStruct( forward_struct, "targetname" );
	forward = AnglesToForward( room_dir_struct.angles );
	
	// As long as the dot product is negative, the player hasn't passed me.
	do
	{
		wait_network_frame();
		me_to_player = level.player.origin - self.origin;
	}
	while ( VectorDot( me_to_player, forward ) < 0 );
	
	MagicBullet( "scar_sp", level.salazar.origin + (0, 0, 60), self GetTagOrigin( "J_head" ) );	
	self bloody_death();
}

give_redshirt_gas_mask()
{
	b_has_gas_mask = IsDefined( self.gas_mask_model );
	
	if ( !b_has_gas_mask )
	{
		if ( self.model == "c_mul_neomax_la_medium" )
		{
			str_gas_mask_model = "c_mul_neomarx_la_medium_gasmask";
		}
		else 
		{
			str_gas_mask_model = "c_mul_neomarx_la_light_gasmask";
		}
		
		self Attach( str_gas_mask_model, "J_Head" );
		self.gas_mask_model = str_gas_mask_model;
	}
}

run_menendez_enemy()
{
	self endon( "death" );
	
	// good guys against menendez all die by gas.
	self.deathFunction = ::handle_m32_gas_death;
	
	// stormtrooper mode.
	self.script_accuracy = 0.0;
	
	const engage_player_dist = 300;
	const aim_time_min = 0.5;
	const aim_time_max = 1.0;
	
	if ( IsSubStr( self.targetname, "control_room" ) )
    {
	    trigger_wait( "sacrifice_start_trigger" );
	    self thread kill_behind_player( "messiah_dir_struct" );
    } else {
		return;
		// trigger_wait( "hangar_enter_trigger" );
    }
	
	dist = self waittill_player_nearby( engage_player_dist, "kill_this_chump" , true, true);
	
	// if they're meleeing, let them finish.
	while ( isdefined( self.melee ) )
	{
		wait_network_frame();
	}
	
	// aim at the player for a moment.
	aim_time = RandomFloatRange( aim_time_min, aim_time_max );
	self thread aim_at_target( level.player, aim_time_max );
	wait aim_time;
	
	// Killllll them.
	if ( level.player is_player_looking_at( self.origin, 0.5, true, true ) )
	{
		attacker = level.salazar;
		if ( rand_chance( 0.5 ) )
		{
			attacker = level.defalco;
	}
	
		MagicBullet( "scar_sp", attacker.origin + (0, 0, 60), self GetTagOrigin( "J_head" ), attacker );	
	}
	
	self bloody_death();
}

assign_scripted_team( scripted_team )
{
	Assert( IsDefined( scripted_team ) );
	Assert( scripted_team == "axis" || scripted_team == "allies" ||  scripted_team == "team3" );
	self.team = scripted_team;
	
	if ( level.player_is_menendez )
	{
		if ( scripted_team == "axis" )
		{
			if ( !IsDefined( self.script_animname ) )
			{
				self thread run_menendez_enemy();
			}
		} else {
			self.deathFunction = ::handle_m32_allies;
			self give_redshirt_gas_mask();
		}
	}
}

/@
Sets up and returns an extra cam.

position_struct_name: name of the struct where the camera should start
link_to_obj_name (optional): name of the object we should attach to
aspect_ratio (optional, default: 16/9): aspect ratio of cam.
@/
extra_cam_init( position_struct_name, link_to_obj_name, aspect_ratio )
{
	cam = get_extracam();
	cam_pos = GetStruct( position_struct_name, "targetname" );
	
	cam.origin = cam_pos.origin;
	cam.angles = cam_pos.angles;
	
	if ( IsDefined( link_to_obj_name ) )
	{
		link_obj = GetEnt( link_to_obj_name, "targetname" );
		cam LinkTo( link_obj );
	}
	
	turn_on_extra_cam();
	
	if ( !IsDefined( aspect_ratio ) )
	{
		// FIXME: shouldn't this ratio be provided by video settings?
		aspect_ratio = 16/9;
	}
	
	// set custom aspect ratio for extra cam
	SetSavedDvar( "r_extracam_custom_aspectratio", aspect_ratio );
	
	return cam;
}

extra_cam_move( position_struct_name )
{
	cam = get_extracam();
	cam_pos = GetStruct( position_struct_name, "targetname" );
	
	cam.origin = cam_pos.origin;
	cam.angles = cam_pos.angles;
}

// spawns defalco or his stand-in.  Both will be recognized as "defalco" by the scene system.
//
spawn_defalco_or_standin( str_start_node )
{
	if ( !IsDefined( str_start_node ) )
	{
		str_start_node = "skipto_menendez_start_defalco";
	}
	
	if ( level.is_defalco_alive )
	{
		level.defalco = init_hero_startstruct( "defalco", str_start_node );
		level.defalco.name = "Defalco";
	} else {
		level.defalco = simple_spawn_single( "defalco_standin" );
		level.defalco magic_bullet_shield();
		
		s_spawn = GetStruct( str_start_node, "targetname" );
		level.defalco Teleport( s_spawn.origin, s_spawn.angles );
	}
	
	// Go team orange!
	level.defalco set_force_color( "o" );
	level.defalco set_ignoreall( true );
	
	return level.defalco;
}

// look for AI with a team assigned and set up their spawn function.
//
init_spawner_teams()
{
	team_names = [];
	team_names[0] = "allies";
	team_names[1] = "axis";
	team_names[2] = "team3";
	
	for ( j = 0; j < team_names.size; j++ )
	{
		spawners = GetEntArray( team_names[j], "script_noteworthy" );
		for ( i = 0; i < spawners.size; i++ )
		{
			spawners[i] add_spawn_function( ::assign_scripted_team, team_names[j] );
		}
	}
}

trigger_wait_facing( str_trigger_name, max_facing_angle_degrees )
{
	max_dot = Cos( max_facing_angle_degrees );
	t_trigger = GetEnt( str_trigger_name, "targetname" );
	
	do{
		t_trigger waittill( "trigger" );
		player_fvec = AnglesToForward( level.player.angles );
		trigger_fvec = AnglesToForward( t_trigger.angles );
	} while ( VectorDot( player_fvec, trigger_fvec ) < max_dot );
}

weapon_kill_reporter()
{
	self waittill( "death", attacker, type, weapon );
	
	if ( isdefined( attacker ) && isdefined( weapon ) )
	{
		if ( IsPlayer( attacker ) )
		{
			// passes back victim, damage type, and weapon.
			level notify( "player_performed_kill", self, type, weapon );
		}
	}
}

// Assign weapon-reporting "kill" functions on all enemies.
//
init_kill_functions()
{
	all_spawners = GetSpawnerArray();
	foreach ( spawner in all_spawners )
	{
		spawner add_spawn_function( ::weapon_kill_reporter );
	}
}

min_val( a, b )
{
	if ( a < b)
	{
		return a;
	}
	else
	{
		return b;
	}
}

welding_fx( str_wait_scene )
{
	fxOrg = Spawn( "script_model", ( 0,0,0 ));
	fxOrg SetModel( "tag_origin" );

	fxOrg.origin = self GetTagOrigin( "tag_fx");
	fxOrg.angles = self GetTagAngles( "tag_fx" );

	fxOrg LinkTo( self, "tag_fx" );
	
	self play_fx( "laser_cutter_sparking", undefined, undefined, "stop_fx", true, "tag_fx" );
	self play_fx( "fx_laser_cutter_on", undefined, undefined, "stop_fx", true, "tag_fx" );
	
	fxOrg playsound( "evt_vent_cutter_start" );
	fxOrg playloopsound( "evt_vent_cutter_loop", 1 );
	
	// TODO:temp wait:temp wait, need some notetrack
	if ( IsDefined( str_wait_scene ) )
	{
		scene_wait( str_wait_scene );
	}
	wait 3;
	fxOrg stoploopsound( 1 );
	fxOrg playsound( "evt_vent_cutter_end" );
	wait 1;	

	self notify( "stop_fx" );
}

set_karma_killed()
{
	level.is_karma_alive = false;
	level.player set_story_stat( "KARMA_DEAD_IN_COMMAND_CENTER", true );
}

set_farid_killed()
{
	level.is_farid_alive = false;
	level.player set_story_stat( "FARID_DEAD_IN_COMMAND_CENTER", true );
}

set_briggs_killed()
{
	level.is_briggs_alive = false;
	level.player set_story_stat( "BRIGGS_DEAD", true );
}

set_defalco_killed()
{
	level.is_defalco_alive = false;
	level.player set_story_stat( "DEFALCO_DEAD_IN_COMMAND_CENTER", true );
}

set_post_branching_scene_stats()
{
	// farid, if present, protects karma from super-kill death.
	if ( level.is_karma_alive && !level.is_farid_alive )
	{
		set_karma_killed();
	}
	
	// if not already dead, farid always dies.
	if ( !level.is_farid_alive )
	{
		set_farid_killed();
	} else if ( level.is_defalco_alive ) {
		// farid always kills defalco, if farid is alive.
		set_defalco_killed();
	}
}

get_branching_scene_label()
{
	scene_name = "";
	if ( level.is_defalco_alive )
	{
		scene_name = scene_name + "alive_";
	} else {
		scene_name = scene_name + "dead_";
	}
	
	if ( level.is_farid_alive )
	{
		if ( level.is_karma_alive )
		{
			scene_name = scene_name + "a";
		} else {
			scene_name = scene_name + "b";
		}
	} else {
		if ( level.is_karma_alive )
		{
			scene_name = scene_name + "c";
		} else {
			// no scene to show, bro.
			scene_name = undefined;
		}
	}
	
	return scene_name;
}

branching_scene_debug()
{
	if ( !level.branching_scene_debug )
	{
		return;
	}
	variant_string = "Living Actors:";
	if ( level.is_defalco_alive )
	{
		variant_string = variant_string + " Defalco";
	}
	
	if ( level.is_karma_alive )
	{
		variant_string = variant_string + " Karma";
	}
	
	if ( level.is_farid_alive )
	{
		variant_string = variant_string + " Farid";
	}
	
	IPrintLnBold( variant_string );
}

// shows a timer on-screen so i can time things out correctly.
// for debug purposes only.
//
run_debug_timer()
{	
	time_s = 0.0;
	while ( true )
	{
		if ( !flag( "debug_timer_active" ) )
		{
			time_s = 0.0;
		}
		flag_wait( "debug_timer_active" );
		IPrintLn( "" + time_s );
		wait 0.2;
		time_s = time_s + 0.2;
	}
}

retrieve_story_stats( )
{
	dead_stat = level.player get_story_stat( "DEFALCO_DEAD_IN_KARMA" );
	level.is_defalco_alive = (dead_stat == 0);
	
	dead_stat = level.player get_story_stat( "KARMA_DEAD_IN_KARMA" );
	level.is_karma_alive = (dead_stat == 0);
	
	dead_stat = level.player get_story_stat( "FARID_DEAD_IN_YEMEN" );
	level.is_farid_alive = (dead_stat == 0);
	
	level.is_harper_alive = dead_stat;
}

/@
Summary: Waits for a trigger, or if failsafe_time_s seconds pass, returns early.
Module: Trigger
MandatoryArg: failsafe_time_s: time in seconds that should pass before returning by failsafe.
OptionalArg: Name of the trigger.
OptionalArg: Key by which you're looking up the trigger. e.g. "targetname".
Example: trigger_wait_time_failsafe( 10.0, "advance_trigger", "targetname" ); t_mytrig trigger_wait_time_failsafe( 5.0 );
@/
trigger_wait_timeout( failsafe_time_s, str_trigger_name, str_key )
{	
	t_trig = undefined;
	if ( IsDefined( str_trigger_name ) )
	{
		if ( !IsDefined( str_key ) )
		{
			str_key = "targetname";
		}
		t_trig = GetEnt( str_trigger_name, str_key );
	} else {
		t_trig = self;
	}
	
	t_trig endon( "trigger" );
	wait failsafe_time_s;
}

waittill_trigger_or_notify( str_trigger, str_notify )
{
	self endon( str_notify );
	trigger_wait( str_trigger );
}

// Waits till the trigger is hit, the timout is hit, or the notify is hit.
//
waittill_trigger_timeout_or_notify( trigger_name, timeout_time, notify_name )
{
	self endon( notify_name );
	trigger = GetEnt( trigger_name, "targetname" );
	
	if ( IsDefined( trigger ) )
	{
		trigger endon( "trigger" );
	}
	
	if ( IsDefined( timeout_time ) )
	{
		wait timeout_time;
	} else if ( IsDefined( trigger ) ) {
		trigger waittill( "trigger" );
	} else {
		self waittill( notify_name );
	}
}

sea_cowbell()
{
	level.fire_at_drones = false;
	
	if ( flag( "sea_cowbell_running" ) )
	{
		return;
	}
	
	launcher_list = GetEntArray( "launcher", "targetname" );
	level.boats_already_spawned = true;
	const n_launchers = 10;
	const n_max_launchers = 5;

	array_thread( launcher_list, ::_aircraft_launcher_logic );
}

end_sea_cowbell()
{
	flag_clear( "sea_cowbell_running" );
	level notify( "stop_sea_cowbell" );
	level notify( "stop_ambient_shooting_at_boats" );
}

// populate boat models in a given box
_populate_boat_models( n_x_min, n_x_max, n_y_min, n_y_max )
{
	const z = -1024;
	const n_space = 4096;
	const n_different_boats = 3;
	
	total_spawned_boats_this_function_call = 0;
	
	a_boat_models = array( "veh_iw_sea_slava_cruiser_des", "veh_iw_arleigh_burke_des", "veh_iw_sea_rus_burya_corvette" );
	
	// goes through the given dimension and decides if it should put a random boat model at every 2048 units in the box
	for ( x = n_x_min; x <= n_x_max; x += n_space )
	{
		for ( y = n_y_min; y <= n_y_max; y += n_space )
		{
			if( total_spawned_boats_this_function_call >= 14 )
			{
				break;
			}
			
			n_placement_chance = RandomInt( 5 );
			
			if ( n_placement_chance == 0 )
			{
				m_boat_model = random( a_boat_models );
				v_position = ( x, y, z );
				
				if( m_boat_model == "veh_iw_sea_slava_cruiser_des" )
				{
					v_position += ( 0, 0, 250);
				}
				else if( m_boat_model == "veh_iw_arleigh_burke_des" )
				{
					v_position += ( 0, 0, 1000);
				}
				
				m_boat = spawn_model( m_boat_model, v_position, ( 0, RandomInt( 360 ), 0 ) );
				m_boat.targetname = "boat_model";
				m_boat.script_noteworthy = "sky_cowbell_targets";
				
				total_spawned_boats_this_function_call++;
			}
		}
	}
}

// self == the start node of a spline
_vehicle_on_spline()
{
	level endon( "stop_sea_cowbell" );
	
	a_boat_vehicles = array( "ambient_barge", "ambient_gunboat_medium", "ambient_gunboat_medium", "ambient_gunboat_small", "ambient_gunboat_small", "ambient_gunboat_small" );
	
	// puts a boat on the spline
	while ( true )
	{
		str_boat_vehicle = random( a_boat_vehicles );
		
		vh_spawner = get_vehicle_spawner( str_boat_vehicle );
		
		// wait until other threads is not using this spawner
		while ( isdefined( vh_spawner.vehicle_spawned_thisframe ) )
		{
			wait 0.05;
		}

		vh_spawner.vehicle_spawned_thisframe = true;		
		
		vh_boat = spawn_vehicle_from_targetname( str_boat_vehicle );
		vh_boat thread _boat_death();
		vh_boat thread _notify_death_when_sea_cowbell_stops();
		
		if ( str_boat_vehicle == "ambient_barge" )
		{
			vh_boat SetSpeed( 16 );
		}
		else if ( str_boat_vehicle == "ambient_gunboat_medium" )
		{
			vh_boat SetSpeed( 31 );
		}
		else if ( str_boat_vehicle == "ambient_gunboat_small" )
		{
			vh_boat SetSpeed( 61 );
		}
		
		wait 0.05;
		
		vh_spawner.vehicle_spawned_thisframe = undefined;
		
		vh_boat thread go_path( self );
		vh_boat waittill( "death" );
	}
}

_notify_death_when_sea_cowbell_stops()
{
	self endon("death");
	level waittill( "stop_sea_cowbell" );
	self notify("death");
}

// sellf == boat vehicle
_boat_death()
{
	self waittill( "death" );
	
	if ( IsDefined( self ) )
	{
		VEHICLE_DELETE( self );
	}
}

// self == an aircraft launcher that is on the command center
_aircraft_launcher_logic()
{
	level endon( "stop_ambient_shooting_at_boats" );

	self veh_magic_bullet_shield();
	
	const n_dot = 0.4;
	//a_boat_models = GetEntArray( "boat_model", "targetname" );
	
	v_launcher_forward = AnglesToForward( self.angles );
	
	while ( true )
	{		
		if( level.fire_at_drones )
		{
			a_drone_vehicles = GetEntArray( "drone_turret_targets", "script_noteworthy" );
			
			// finds a real boat vehicle to shoot
			if ( a_drone_vehicles.size > 0 )
			{
				n_dot_to_drones = 0;
				
				while( n_dot_to_drones <= n_dot )
				{
					e_drone = random( a_drone_vehicles );
					if( IsDefined( e_drone ) && IsAlive( e_drone ) )
					{
						if( e_drone.origin[2] < -1028 )
						{	
							continue;
						}
						n_dot_to_drones = VectorDot( v_launcher_forward, VectorNormalize( e_drone.origin - self.origin ) );
						
						if( n_dot_to_drones > n_dot )
						{
							self set_turret_target( e_drone, ( 0, 0, 64 ), 0 );
							self fire_turret( 0 );
							
							if( Distance( level.player.origin, self.origin ) < 768 )
							{
								level.player PlayRumbleOnEntity( "damage_heavy" );
							}
							
							Earthquake( 0.3, 1, self.origin, 768 );
							wait 0.1;
							
							
							break;
						}
					}
					wait 0.05;
				}
				
					wait 3;
					
					continue;
//				}
			}
		}
		
		a_boat_vehicles = getstructarray( "sea_cowbell_target", "targetname" );
		
		// finds a real boat vehicle to shoot
		if ( a_boat_vehicles.size > 0 )
		{
			e_boat = random( a_boat_vehicles );
			n_dot_to_boat = VectorDot( v_launcher_forward, VectorNormalize( e_boat.origin - self.origin ) );
		
			if ( n_dot_to_boat > n_dot )
			{
				target_origin = Spawn( "script_origin" , e_boat.origin );
				
				self set_turret_target( target_origin, ( 0, 0, 64 ), 0 );
				self fire_turret( 0 );
				
				if( Distance( level.player.origin, self.origin ) < 768 )
				{
					level.player PlayRumbleOnEntity( "damage_heavy" );
				}
				
				Earthquake( 0.3, 1, self.origin, 768 );
			
				wait 3;
				
				target_origin Delete();
				
				continue;
			}
		}

		wait 0.05;
	}	
}

activate_bridge_launchers()
{
	if ( flag( "bridge_launchers_running" ) )
	{
		return;
	}
	
	flag_set( "bridge_launchers_running" );
	
	const n_bridge_launchers = 2;
	
	for ( i = 0; i < n_bridge_launchers; i++ )
	{
		vh_launcher = GetEnt( "launcher_bridge_" + i, "targetname" );
		vh_launcher thread _bridge_launcher_logic( i );
	}
}

end_bridge_launchers()
{
	flag_clear( "bridge_launchers_running" );
	level notify( "stop_bridge_launchers" );
}



// self == a launcher on the bridge
_bridge_launcher_logic( n_index )
{
	level endon( "stop_bridge_launchers" );
	
	const n_battleship_length = 11264;
	const n_dot = 0.4;
	v_launcher_forward = AnglesToForward( self.angles );
	
	a_battleship_structs = getstructarray( "battleship_end", "targetname" );
	
	if(a_battleship_structs.size == 0)
	{
		/#iprintln("THERE ARE NO BATTLESHIP_END STRUCTS");#/
		return;		
	}
	
	// stagger when the launcher starts firing
	n_start_wait_time = n_index % 3;
	wait n_start_wait_time;
	
	burst_time_min = 0.2;
	burst_time_max = 0.4;
	time_between_bursts_min = 2;
	time_between_bursts_max = 4;
	
	while ( true )
	{
		self set_turret_burst_parameters( burst_time_min, burst_time_max, time_between_bursts_min, time_between_bursts_max, 0 );
		
		s_battleship_end = random( a_battleship_structs );
		n_dot_to_struct = VectorDot( v_launcher_forward, VectorNormalize( s_battleship_end.origin - self.origin ) );
		
		// shoot if the struct is in front of the launcher
		if ( n_dot_to_struct > n_dot )
		{
			// pick a random position on the boat to shoot at
			v_battleship_forward = AnglesToForward( s_battleship_end.angles );
			v_rand_target_pos = s_battleship_end.origin + ( v_battleship_forward * RandomInt( n_battleship_length ) );
			
			self SetTargetOrigin( v_rand_target_pos );
			self waittill( "turret_on_target" );
			
			// fire for a few seconds, then check again.
			fire_time = RandomFloatRange( 6, 8 );
			self fire_turret_for_time( fire_time, 0 );
		}
		
		wait_network_frame();
	}
}

fa38_init_fx( is_hovering )
{
	self thread fa38_hover();
	self thread fa38_fly();
	
	if ( is_true(is_hovering) )
	{
		self notify( "hover" );
	} else {
		self notify( "fly" );
	}
}

fa38_hover()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "hover" );
		
		if ( !IS_TRUE( self.hovering ) )
		{
			play_fx( "f35_exhaust_hover_rear", undefined, undefined, "fly", true, "tag_fx_nozzle_left_rear" );
			play_fx( "f35_exhaust_hover_rear", undefined, undefined, "fly", true, "tag_fx_nozzle_right_rear" );
			play_fx( "f35_exhaust_hover_front", undefined, undefined, "fly", true, "tag_fx_nozzle_left" );
			play_fx( "f35_exhaust_hover_front", undefined, undefined, "fly", true, "tag_fx_nozzle_right" );
			
			self.hovering = true;
		}
	}
}

fa38_fly()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "fly" );
	
		if ( !IS_FALSE( self.hovering ) )
		{
			play_fx( "f35_exhaust_fly", undefined, undefined, "hover", true, "origin_animate_jnt" );
			
			self.hovering = false;
		}
	}
}

// restores mason's objectives list when he returns.
//
mason_restore_objectives()
{
	Objective_ClearAll();
	
	// have to give a position, or it won't add them, which would be no good.
	dummy_pos = GetStruct( "mirror_2_real_room", "targetname" );
	
	set_objective( level.OBJ_INTERROGATE, dummy_pos, "breadcrumb" );
	set_objective( level.OBJ_INTERROGATE, undefined, "done" );
	
	set_objective( level.OBJ_RESTORE_CONTROL, dummy_pos, "breadcrumb" );
	set_objective( level.OBJ_RESTORE_CONTROL, undefined, "done" );
	
	set_objective( level.OBJ_DEFEND_HACKER, dummy_pos, "breadcrumb" );
	set_objective( level.OBJ_DEFEND_HACKER, undefined, "done" );
	
	set_objective( level.OBJ_CCTV, dummy_pos, "breadcrumb" );
	set_objective( level.OBJ_CCTV, undefined, "done" );
	if ( level.num_seals_saved > 0 )
	{
		set_objective( level.OBJ_HELP_SEALS, dummy_pos, "breadcrumb" );
		set_objective( level.OBJ_HELP_SEALS, undefined, "done" );
	}
}

hide_surface()
{
	self Hide();
}

get_furthest( origin, array )
{
	return get_array_of_farthest( origin, array, undefined, 1 )[0];
}

scene_exists( scene_name )
{
	return flag_exists( scene_name + "_started" );
}

scene_is_playing( scene_name )
{
	return flag( scene_name + "_started" ) && !flag( scene_name + "_done" );
}

setup_extra_cams()
{
	level.extra_cam_surfaces = [];
	level.extra_cam_surfaces[ "cctv" ] = GetEnt( "khan_screen", "targetname" );
	level.extra_cam_surfaces[ "server" ] = GetEnt( "server_screen", "targetname" );
	level.extra_cam_surfaces[ "observation" ] = GetEnt( "intro_screen", "targetname" );
	
	array_func( level.extra_cam_surfaces, ::hide_surface );
	
	// set up the directions of the extra cams
	cams = [];
	cams[0] = "pip_glasses_pos";
	cams[1] = "menendez_start_extracam";
	foreach( cam_name in cams )
	{
		cam_pos = GetStruct( cam_name, "targetname" );
		cam_pos_target = GetStruct( cam_pos.target, "targetname" );
		to_target = cam_pos_target.origin - cam_pos.origin;
		cam_pos.angles = VectorToAngles( to_target );
	}
}

fxanim_play_fx_think( str_joint, str_notify, str_fx )
{
	while ( true )
	{
		self waittill( str_notify );
		PlayFXOnTag( level._effect[str_fx], self, str_joint );
	}
}

fxanim_play_fx( str_model_targetname, str_joint, str_notify, str_fx )
{
	e_models = GetEntArray( str_model_targetname, "targetname" );
	foreach ( e_model in e_models )
	{
		e_model thread fxanim_play_fx_think( str_joint, str_notify, str_fx );
	}
}

play_spark_fx( e_wire )
{
	if ( e_wire.model == "fxanim_gp_wirespark_med_mod" )
	{
		str_tag = "med_spark_06_jnt";
	}
	else if ( e_wire.model == "fxanim_gp_wirespark_long_mod" )
	{
		str_tag = "long_spark_06_jnt";
	}
	else 
	{
		AssertMsg( e_wire.model + " is not supported by play_spark_fx() yet" );
	}
	
	PlayFXOnTag( level._effect[ "fx_wire_spark" ], e_wire, str_tag );
}

init_fxanims()
{
	add_notetrack_custom_function( "fxanim_props", "spark_wire", ::play_spark_fx, true );
}

init_flags()
{
	flag_init( "player_using_turret" );
	flag_init( "distant_explosions_on" );
	flag_init( "debug_timer_active" );
}

hide_fa38_elevator_fxanim_model()
{
	models = GetEntArray( "black_elevator_debris", "script_string" );
	
	for( i = 0; i < models.size; i++ )
	{
		models[ i ] Hide();
	}
}

show_fa38_elevator_fxanim_model()
{
	models = GetEntArray( "black_elevator_debris", "script_string" );
	
	for( i = 0; i < models.size; i++ )
	{
		models[ i ] Show();
	}
}

// Switches the player to menendez's weapons.
//
// give_gun_notify: notify for when we should actually give the player the judge.
//
menendez_weapons( give_gun_notify = undefined )
{
	level.player_weapons = level.player GetWeaponsList();
	level.player_mason_current_weapon = level.player GetCurrentWeapon();
	self TakeAllWeapons();
	
	if ( isdefined( give_gun_notify ) )
	{
		level.player waittill( give_gun_notify );
	}

	const my_weapon = "judge_sp";	
	self GiveWeapon( my_weapon );
	self SwitchToWeapon( my_weapon );
	
	self AllowPickupWeapons( false );
	self SetLowReady( true );
}

menendez_cleanup()
{
	// Start the re-wind!
	maps\blackout_menendez_start::server_room_exit_door_close();
	
	// End all the salute animations.
	foreach( salute in level.salutes )
	{
		end_scene( salute.loop );
	}
	
	// Remove the scene names for the salutes.
	level.salutes = undefined;
}

// To be called on the player.
//
refill_weapon_clip( weapon_name )
{
	clip_size = WeaponClipSize( weapon_name );
	self SetWeaponAmmoClip( weapon_name, clip_size );
}

toggle_messiah_mode( mode_on )
{
	if ( mode_on )
	{
		SetDvar( "vc_LUT", 2 );
		vision_set_menendez();
	} else {
		SetDvar( "vc_LUT", 0 );
		vision_set_default();
	}
}

load_needed_gump()
{
	if( level.is_defalco_alive )
	{
		if( level.is_farid_alive && level.is_karma_alive )
		{
			load_gump( "blackout_defalco_alive_a_gump" );
		}
		else if( level.is_farid_alive && !level.is_karma_alive )
		{
			load_gump( "blackout_defalco_alive_b_gump" );
		}
		else if( !level.is_farid_alive && level.is_karma_alive )
		{
			load_gump( "blackout_defalco_alive_c_gump" );
		}
		else
		{
			load_gump( "blackout_defalco_alive_d_gump" );
		}
	}
	else
	{
		if( level.is_farid_alive && level.is_karma_alive )
		{
			load_gump( "blackout_defalco_dead_a_gump" );
		}
		else if( level.is_farid_alive && !level.is_karma_alive )
		{
			load_gump( "blackout_defalco_dead_b_gump" );
		}
		else if( !level.is_farid_alive && level.is_karma_alive )
		{
			load_gump( "blackout_defalco_dead_c_gump" );
		}
		else
		{
			load_gump( "blackout_defalco_dead_d_gump" );
		}
	}
}