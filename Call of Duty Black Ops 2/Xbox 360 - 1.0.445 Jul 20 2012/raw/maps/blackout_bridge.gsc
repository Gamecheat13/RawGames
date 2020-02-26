/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 1/16/2012
 * Time: 11:43 AM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

// global includes
#include common_scripts\utility;
#include maps\_drones;
#include maps\_dialog;
#include maps\_utility;
#include maps\_objectives;
#include maps\_scene;
#include maps\_cic_turret;
#include maps\_vehicle;

// local includes
#include maps\createart\blackout_art;
#include maps\blackout_util;

#define CATWALK_GLASS_EXPLODER	10201
	
////////////////////////////////
//   SKIPTO INITIALIZATION    //
////////////////////////////////

skipto_mason_salazar_exit()
{
	skipto_setup();
	skipto_teleport_players("player_skipto_mason_salazar_exit");
	
	level thread maps\blackout_interrogation::moment_stairfall();

	// spawn salazar.
	level.salazar = init_hero_startstruct( "salazar", "skipto_salazar_exit_salazar" );
	
	run_scene_first_frame( "salazar_exit", true );
	delay_thread( 3.0, maps\blackout_interrogation::scene_salazar_exit );
}

skipto_mason_bridge()
{
	skipto_setup();
	skipto_teleport_players("player_skipto_mason_bridge");
	
	hackable_turret_enable( "bridge_turret" );
	
	level thread bridge_turret_reveal();
}

skipto_mason_catwalk()
{
	skipto_setup();
	skipto_teleport_players("player_skipto_mason_catwalk");
	level thread spawn_deck_spec_ops_battle();
	
	// spawn your buddies.
	simple_spawn( "color_spawn_skipto_catwalk", ::change_movemode, "cqb_run" );
	trigger_use( "catwalk_color_trigger" );
	
	level thread run_scene_and_delete( "catwalk_rpg_wait" );	
	level thread open_catwalk_door( true );
	level thread scene_harrier_flyover();
}

spawn_functions()
{
	//ziptie_pmc_01
	spawner = GetEnt( "ziptie_pmc_01", "targetname" );
	spawner add_spawn_function( ::add_ziptie_damage_override );
	
	spawner = GetEnt( "ziptie_pmc_02", "targetname" );
	spawner add_spawn_function( ::add_ziptie_damage_override );
	
	spawner = GetEnt( "ziptie_pmc_03", "targetname" );
	spawner add_spawn_function( ::add_ziptie_damage_override );
}

add_ziptie_damage_override()
{
	self.overrideactordamage = ::ziptie_damage_override;
}

ziptie_damage_override( eInflictor, e_attacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if( ( self.health - iDamage ) <= 0 )
	{
		self ragdoll_death();
		return 0;
	}
	
	return iDamage;
}

////////////////////////////////
//      'MAIN' FUNCTIONS      //
////////////////////////////////

run_mason_salazar_exit()
{
	level thread deck_drone_spawning();
	
	run_scene_first_frame( "familiar_face", true );
	
	// Now going to the bridge to restore control.
	set_objective( level.OBJ_FOLLOW_SALAZAR, undefined, "done" );
	level thread breadcrumb_and_flag( "bridge_breadcrumb", level.OBJ_RESTORE_CONTROL, "at_bridge_entry" );
	
	level thread scene_pre_bridge();
	level thread deck_vtol_explosions();
	
	trigger_wait( "bridge_breadcrumb" );
	
	level thread bridge_turret_reveal();
	
	sea_cowbell();
	activate_bridge_launchers();
	
	spawn_manager_enable( "sm_friendly_bridge_entry" );
	
	trigger_wait_facing( "bridge_entry_trigger", 60 );
	
	spawn_manager_disable( "sm_friendly_bridge_entry" );
}

run_mason_bridge()
{
	level thread scene_cic_bodies();
	
	hackable_turret_enable( "bridge_turret" );
	level thread turret_physics_pulse();
	
	// slow down the deck battle so we can spawn guys inside.
	spawn_manager_enable( "sm_friendly_bridge" );
	
	scene_familiar_face();
	
	end_sea_cowbell();
	end_bridge_launchers();
	
	level thread breadcrumb_and_flag( "bridge_front_trigger", level.OBJ_RESTORE_CONTROL, "at_bridge", false );
	
	level thread scene_cic_hackers();
	
	level thread bridge_fodder_guys();
	
	bridge_turret = GetEnt( "bridge_turret", "targetname" );
	bridge_turret thread bridge_turret_spawns();
	
	flag_wait( "at_bridge" );
	
	// disable the other color triggers on the bridge.
	trigger_off( "disable_at_bridge", "script_noteworthy" );
	
	hack_trigger = GetEnt( "bridge_hack_trigger", "targetname" );
	set_objective( level.OBJ_RESTORE_CONTROL, hack_trigger, "use", undefined, false );
	hack_trigger waittill( "trigger" );
	level thread run_scene_and_delete( "bridge_hacker" );
	
	level thread run_scene_and_delete( "catwalk_rpg_wait" );
	
	wait 0.1;
	
	hack_trigger Delete();
	
	level thread open_catwalk_door( true );
	
	// Make the turret stop firing on friendlies.
	bridge_turret = GetEnt( "bridge_turret", "targetname" );
	if ( isdefined( bridge_turret ) )
	{
		bridge_turret.vteam = "allies";
	}
	
	foot_clan = get_ai_group_ai( "bridge_foot_clan" );
	foreach( ai in foot_clan )
	{
		ai.dieQuietly = true;
		ai die();
	}
	
	level thread scene_harrier_flyover();
	
	scene_wait( "bridge_hacker" );
	
	autosave_by_name( "bridge_complete" );
	
	// send them to the catwalk.
	level thread breadcrumb_and_flag( "catwalk_breadcrumb", level.OBJ_RESTORE_CONTROL, "at_catwalk", false );
	
	level thread dialog_server_offline();
	
	// spawn the guys down below.
	level thread spawn_deck_spec_ops_battle();
	
	// make them start running downstairs.
	trigger_use( "after_hack_advance_trigger", "targetname" );
	
	flag_wait( "at_catwalk" );
	
	spawn_manager_disable( "sm_friendly_bridge" );
}


run_mason_catwalk()
{
	level thread sniper_plane_takeoff();
	
	sea_cowbell();
	
	level thread breadcrumb_and_flag( "security_breadcrumb", level.OBJ_RESTORE_CONTROL, "at_defend_objective", false );
	
	trigger_wait( "catwalk_enter_trigger" );
	
	hackable_turret_disable( "bridge_turret" );
	
	level thread scene_catwalk();
	level thread catwalk_random_shooting();
	level thread catwalk_random_rockets();
	level thread catwalk_kill_friendlies();
	
	// ready the next battle so you can hear it before you get there.
	level thread maps\blackout_security::lower_level_entry_battle();
	
	trigger_wait( "catwalk_exit_trigger" );
}

////////////////////////////////
//     LOCAL FUNCTIONS        //
////////////////////////////////

dialog_radio_defenses()
{
	if ( level.is_harper_alive )
	{
		level.player say_dialog( "sect_harper_0" );
		level.player say_dialog( "sect_it_s_worse_than_we_t_0" );
		level.player say_dialog( "harp_you_got_a_plan_0" );
		level.player say_dialog( "sect_i_m_headed_the_bridg_0" );
	} else {
		level.player say_dialog( "sect_briggs_0" );
		level.player say_dialog( "sect_it_s_worse_than_we_t_0" );
		level.player say_dialog( "brig_we_have_to_regain_co_0" );
		level.player say_dialog( "sect_i_m_headed_the_bridg_0" );
	}
}

dialog_radio_turrets()
{
	// TODO: get dialog that fits if the player doesn't have the perk.
	
	level.player say_dialog( "sect_dammit_2" );
	if ( level.is_harper_alive )
	{
		level.player say_dialog( "sect_harper_the_auto_tur_0" );
	} else {
		level.player say_dialog( "sect_briggs_the_auto_tur_0" );
	}
	
	if (level.player HasPerk( "specialty_trespasser" ))
	{
		level.player say_dialog( "brig_you_should_be_able_t_0" );
		level.player say_dialog( "harp_or_do_it_the_old_f_0" );
		level.player say_dialog( "sect_got_it_0" );
	}
}

dialog_server_offline()
{
	level.player say_dialog( "sect_briggs_it_s_sectio_0" );
	level.player say_dialog( "brig_there_s_another_term_0" );
	level.player say_dialog( "sect_on_my_way_1" );
}

sniper_plane_takeoff()
{
	plane = spawn_vehicle_from_targetname( "sniping_plane"  );
	path = GetVehicleNode( plane.target, "targetname" );
	
	plane thread fa38_init_fx( false );
	
	plane endon( "death" );
	
	plane veh_magic_bullet_shield( true );
	
	trigger_wait( "catwalk_enter_trigger" );
	
	wait 4.0;
	
	// find the last node.
	last_node = path;
	while ( isdefined( last_node.target ) )
	{
		next_node = GetVehicleNode( last_node.target, "targetname" );
		if ( isdefined( next_node ) )
		{
			last_node = next_node;
		} else {
			break;
		}
	}
	
	plane go_path( path );
	
	level.player waittill_player_not_looking_at( plane.origin, 0.5, false );
	
	// delete it.
	plane Delete();
}

pyro_run_ai()
{
	self endon( "death" );
	goal_node = GetNode( self.target, "targetname" );
	
	self change_movemode( "sprint" );
	self.ignoreall = true;
	self.fixednode = true;
	self SetGoalNode( goal_node );
	
	while ( Distance2DSquared(goal_node.origin, self.origin) > (32 * 32) )
	{
		wait 0.5;
	}
	
	self Delete();
}

deck_vtol_explosions()
{
	dumb_struct = GetStruct( "pyro_vtol_01_align", "targetname" );
	foreach ( scene in level.pyro_scenes )
	{		
		run_scene_first_frame( scene );
	}
	
	trigger_wait( "deck_reveal_trigger" );
	
	delay_thread( 1.5, ::dialog_radio_defenses );
	
	// spawn the pyros.
	pyros = simple_spawn( "deck_vtol_pyro", ::pyro_run_ai );
	
	// fire off the xplodr?
	exploder( 10100 );
	
	foreach( scene in level.pyro_scenes )
	{
		level thread run_scene_and_delete( scene );
		wait 1.0;
	}
	
	level.pyro_scenes = undefined;
}

// kill everyone defending the catwalk once you leave the catwalk.
//
catwalk_kill_friendlies()
{
	trigger_wait( "catwalk_exit_trigger" );
	
	targets = get_catwalk_ally_victims( true );
	array_func( targets, ::bloody_death );
}

kill_remaining_enemies()
{
	enemies = get_ai_group_ai( "deck_reveal_enemies" );
	foreach ( enemy in enemies )
	{
		if ( !IsAlive( enemy ) )
		{
			continue;
		}
		
		ally = get_closest_ai( enemy.origin, "allies" );
		if ( IsDefined( ally ) )
		{
			ally.perfectaim = true;
			ally shoot_at_target( enemy, "J_head", 0.0, 1.0 );
		}
		
		// If they're still alive, just make them die.
		if ( IsAlive( enemy ) )
		{
			enemy bloody_death();
		}
	}
}

catwalk_random_rockets()
{
	self endon( "spec_ops_completed" );
	self endon( "spec_ops_failed" );
	self endon( "random_rockets_stop" );
	
	done_trigger = GetEnt( "catwalk_exit_trigger", "targetname" );
	done_trigger endon( "trigger" );
	
	structs = GetStructArray( "catwalk_magic_bullet_target", "targetname" );
	Assert( structs.size > 0 );
	
	sources = GetStructArray( "catwalk_magic_bullet_source", "targetname" );
	
	wait_time = 5.0;
	
	while ( true )
	{
		wait wait_time;
		
		// we want it to be close, but not too close.
		closest_5 = get_array_of_closest( level.player.origin, structs, undefined, 5 );
		s_furthest = get_furthest( level.player.origin, closest_5 );
		s_start = get_furthest_offscreen( sources );
		
		e_rpg = MagicBullet( "rpg_magic_bullet_sp", s_start.origin, s_furthest.origin );
		e_rpg waittill( "death" );
		
		wait_time = wait_time + RandomFloatRange( 5.0, 10.0 );
	}
}

get_catwalk_ally_victims( force_all )
{
	color_friendlies = get_all_force_color_friendlies();
	other_friendlies = [];
	
	// Don't kill these guys until their line gets delivered, or until the player has abandoned them.
	//
	if ( is_true( force_all ) || flag( "spec_ops_line_delivered" ) )
	{
		other_friendlies = get_ai_group_ai( "catwalk_snipers" );
	}
	
	all_friendlies = ArrayCombine( color_friendlies, other_friendlies, true, false );
	return all_friendlies;
}

catwalk_random_shooting()
{
	self endon( "spec_ops_completed" );
	self endon( "spec_ops_failed" );
	
	done_trigger = GetEnt( "catwalk_exit_trigger", "targetname" );
	done_trigger endon( "trigger" );
	
	structs = GetStructArray( "catwalk_magic_bullet_target", "targetname" );
	Assert( structs.size > 0 );
	
	sources = GetStructArray( "catwalk_magic_bullet_source", "targetname" );
	
	const bullet_wait_min = 0.05;
	const bullet_wait_max = 0.3;
	
	while ( true )
	{
		nearest = get_array_of_closest( level.player.origin, structs, undefined, 2 );
		Assert( nearest.size >= 2 );
		enemies = get_ai_group_ai( "deck_reveal_enemies" );
		num_enemies = enemies.size;
		
		f_scale = num_enemies / 10.0;
		if ( f_scale > 1.0 )
		{
			f_scale = 1.0;
		}
		
		// Determine how long to wait between each bullet.
		// Wait less time for fewer guys.
		wait_min = LerpFloat( bullet_wait_min, bullet_wait_max, 1.0 - f_scale );
		wait_max = wait_min * 1.25;
		
		for ( i = 0; i < 10; i++ )
		{
			ai_target = undefined;
			hit_pos = undefined;

			// not all bullets hit our buddies...
			if ( rand_chance( 0.1 ) )
			{
				friendlies = get_catwalk_ally_victims();
				if ( friendlies.size > 0 )
				{
					ai_target = random( friendlies );
				}
			}
			
			// Shoot at the heads of your color friendlies.
			if ( IsAlive( ai_target ) )
			{
				hit_pos = ai_target GetTagOrigin( "J_head" );
			} else {
				rand_pct = RandomFloat( 1.0 );
				hit_pos = LerpVector( nearest[0].origin, nearest[1].origin, rand_pct );
				hit_pos = hit_pos + ( 0, 0, RandomFloatRange( -12, 12 ) );		// give it some vertical variance
			}
			
			s_source = get_furthest_offscreen( sources );
			MagicBullet( "hk416_sp", s_source.origin, hit_pos );
			
			// bullets per wait = 2.
			if ( i % 2 == 0 )
			{
				wait RandomFloatRange( wait_min, wait_max );
			}
		}
	}
}

// run spawns for the bridge turret.
//
// run on: the turret
//
bridge_turret_spawns()
{	
	self endon( "death" );	
	self waittill( "turret_hacked" );
	
	// kill the triggers that would've otherwise spawned guys while you were on foot.
	disable_trigs = GetEntArray( "disable_on_turret", "script_noteworthy" );
	for ( i = disable_trigs.size -1; i >= 0; i-- )
	{
		disable_trigs[i] Delete();
	}
	
	// start the spawn manager.
	spawn_manager_enable( "bridge_turret_sm" );
}

catwalk_spawn_snipers()
{
	// make the snipers invulnerable, so you can see them when
	// you come back around.
	sp_snipers = GetEntArray( "catwalk_sniper_spawn", "targetname" );
	level.catwalk_snipers = simple_spawn( sp_snipers, ::magic_bullet_shield );
	
	simple_spawn( "catwalk_rocket_fodder", ::magic_bullet_shield );
}

turret_reveal_guy_setup()
{
	turret = GetEnt( "reveal_turret", "targetname" );
	
	my_target = GetNode( self.target, "targetname" );
	self.fixednode = true;
	self.ignoreall = true;
	self SetGoalNode( my_target );
		
	// heif helf
	self DoDamage( Int( self.health * 0.5 ), self.origin );
	self change_movemode( "sprint" );
	
	goal_dist_sq = 256.0 * 256.0;
	while ( Distance2DSquared( self.origin, my_target.origin ) > goal_dist_sq && IsAlive( self ) )
	{
		wait_network_frame();
	}
	
	// the player can save him if he kills the turret.
	if ( IsAlive( self ) && IsAlive( turret ) )
    {
		self bloody_death();
	} else {
		self change_movemode( "cqb_run" );
	}
}

// magic bullet the snot out of them.  how dare they escape my wrath without a fight!?
//
bridge_turret_kill_rushing_player()
{
	self endon( "death" );
	
	flag_wait( "player_charging_bridge_turret" );
	
	// after they get 1024 away, give up.
	const give_up_dist_sq = 1024 * 1024;
	damage_points = Int( level.player.health * 0.4 );
	while (Distance2DSquared( self.origin, level.player.origin ) < give_up_dist_sq)
	{
		MagicBullet( "cic_turret", self.origin, level.player getPlayerCameraPos(), self, level.player );
		level.player DoDamage( damage_points, self.origin, self );
		wait 0.1;
	}
}

bridge_turret_watch_charge()
{
	self endon( "death" );
	
	// after they get 1024 away, give up.
	const give_up_dist_sq = 1024 * 1024;
	
	// If the player is charging the living turret, shoot the snot out of them.
	flag_wait( "player_charging_bridge_turret" );
	
	self cic_turret_start_scripted();
	
	while ( true )
	{
		if ( self.health <= 0 )
		{
			return;
		}
		
		if ( Distance2DSquared( self.origin, level.player.origin ) < give_up_dist_sq )
		{
			self SetTargetEntity( level.player );
			self cic_turret_fire_for_time( 2.0 );
			wait 2.5;
		} else {
			// they got away, return to basic ai.
			self cic_turret_start_ai();
			return;
		}
	}
}

bridge_turret_reveal_shoot()
{
	self endon( "switch_to_ai" );
	self endon( "death" );
	
	targetnodes = array( GetNode( "turret_reveal_node_01", "targetname" ), GetNode( "turret_reveal_node_01", "targetname" ) );
	self SetTargetOrigin( targetnodes[0].origin );
	
	// make it shoot, make a lot of noise and whatnot.
	node_num = 0;
	while ( true )
	{
		if ( flag ( "player_charging_bridge_turret" ) )
		{
			// player rushed.  shoot em up.
			self SetTargetEntity( level.player );
			self cic_turret_fire_for_time( 2.0 );
			wait 2.5;
		}
		// before the scene has played.
		else if ( !flag( "familiar_face_player_started" ) )
		{
			self SetTargetOrigin( targetnodes[node_num % targetnodes.size].origin );
			self cic_turret_fire_for_time( 1.0 );
			wait 3.0;
		}
		
		// while the scene is playing, fire only a little.
		else if ( !flag( "familiar_face_player_done" ) )
		{
			self SetTargetOrigin( targetnodes[node_num % targetnodes.size].origin );
			self cic_turret_fire_for_time( 0.3 );
			flag_wait_or_timeout( "familiar_face_player_done", 4.0 );
		}
		
		// after the scene is done, fire a lot.
		else
		{
			self cic_turret_fire_for_time( 1.0 );
			self SetTargetOrigin( targetnodes[node_num % targetnodes.size].origin );
			wait 0.3;
		}
		
		node_num++;
	}
}

bridge_turret_reveal()
{
	turret = GetEnt( "reveal_turret", "targetname" );
	turret cic_turret_start_scripted();
	turret veh_magic_bullet_shield( true );
	turret thread bridge_turret_kill_rushing_player();
	
	move_fwd_trigger = GetEnt( "turret_allies_move_forward", "targetname" );
	
	turret thread bridge_turret_reveal_shoot();
	
	scene_wait( "familiar_face_player" );
	
	thing1 = simple_spawn_single( "turret_intro_guy_1", ::turret_reveal_guy_setup );
	thing2 = simple_spawn_single( "turret_intro_guy_2", ::turret_reveal_guy_setup );
	
	delay_thread( 3.0, ::dialog_radio_turrets );
	
	wait 3.0;
	
	turret veh_magic_bullet_shield( false );
	
	// how long before this thing turns on the player.
	wait 3.0;		// give it a moment, since your allies can really mess this thing up good.
	
	turret notify( "switch_to_ai" );
	
	turret thread bridge_turret_watch_charge();
	if ( IsAlive( turret ) )
	{
		turret cic_turret_start_ai();
		
		// wait for the turret to be dead.
		while ( IsAlive( turret ) )
		{
			wait 0.5;
		}
	}
	
	// move your allies beyond the turret.
	if ( IsDefined( move_fwd_trigger ) )
	{
		move_fwd_trigger trigger_use();
	}
	autosave_by_name( "killed_first_turret" );
	level notify( "killed_first_turret" );
}

//custom notetrack function for the "fire" notetrack on turret
pre_bridge_turret_fire( m_turret )
{
	
	v_start = m_turret GetTagOrigin( "tag_flash" );
	v_angles = m_turret GetTagAngles( "tag_flash" );
	
	
	a_charge_ais = get_ais_from_scene("turret_intro");
	
	foreach( ai in a_charge_ais )
	{
		if(ai.animname == "turret_intro_guy_2")
		{
			e_charge_ai = ai;
			continue;				
		}
	}
	v_end = e_charge_ai GetTagOrigin("J_Head");
	
	PlayFXOnTag(level._effect["fx_turret_flash"], m_turret, "tag_flash" );
	MagicBullet( "cic_turret", v_start, v_end, level.player );
}

//custom notetrack function for the "explode" notetrack on turret
pre_bridge_turret_explode( m_turret )
{
	PlayFX( getfx( "turret_death" ), m_turret.origin );
	m_turret playsound ("veh_cic_turret_dmg_hit");
}

// Born to die.
bridge_fodder_logic()
{
	self endon( "death" );
	
	// send him straight toward his goal.
	goal = GetNode( self.target, "targetname" );
	self.fixednode = true;
	self.ignoreall = true;
	self SetGoalNode( goal );
	self magic_bullet_shield();
	wait 2.0;
	self stop_magic_bullet_shield();
	
	// If he makes it there alive, kill him anyway.
	while ( Distance2DSquared( self.origin, goal.origin ) > (128.0 * 128.0) )
	{
		wait_network_frame();
	}
	self bloody_death();
}

////////////////////////////////
//                            //
//      SCENE FUNCTIONS       //
//                            //
////////////////////////////////

sailor_kill_decide( sailor )
{
	attacker = GetEnt( "bridge_tackle_pmc_02_ai", "targetname" );
	sailor SetCanDamage( true );
	
	// If the sailor gets saved, the scene ends there.
	if ( !IsAlive( attacker ) )
	{
		flag_set( "tackle_sailor_saved" );
		end_scene( "bridge_tackle" );
		
		sailor set_force_color( "o" );
	}
}

fa38_fire_weapon( fire_time )
{
	fire_time_base = 0.1;
	total_fire_time = 0.0;
	
	while ( total_fire_time < fire_time )
	{
		self FireGunnerWeapon( 0 );
		wait fire_time_base * 0.5;
		self FireGunnerWeapon( 1 );
		wait fire_time_base * 0.5;
		total_fire_time += fire_time_base;
	}
}

scene_harrier_flyover()
{	
	run_scene_first_frame( "bridge_flyover" );
	
	fa38 = get_model_or_models_from_scene( "bridge_flyover", "bridge_harrier" );
	fa38 thread fa38_init_fx( true );
	
	trigger_wait( "harrier_flyover_trigger" );
	
	level thread run_scene_and_delete( "bridge_flyover" );
	
	wait 1.0;
	
	fa38 thread fa38_fire_weapon( 4.0 );
	
	wait 1.0;
	physics_push_fa38 = getstruct( "physics_push_fa38", "targetname" );
	PhysicsJolt( physics_push_fa38.origin, 1028, 900, ( 1, 1, 1 ) * 0.1 );
	RadiusDamage( physics_push_fa38.origin, 16, 50, 50 );
	exploder( CATWALK_GLASS_EXPLODER );
}

scene_bridge_tackle()
{	
	level thread run_scene_and_delete( "bridge_tackle" );
	wait_network_frame();
	
	// first guy that dies, let the animation kill him.
	first_blood = GetEnt( "bridge_tackle_pmc_01_ai", "targetname" );
	first_blood SetCanDamage( false );
	
	sailor_ai = GetEnt( "bridge_tackle_sailor_ai", "targetname" );
	sailor_ai SetCanDamage( false );

	scene_wait( "bridge_tackle" );
}

scene_pre_bridge()
{
	run_scene_first_frame( "crash_heli" );
	
	trigger_wait( "bridge_tackle_trigger" );
	level thread scene_bridge_tackle();	
	run_scene_and_delete( "crash_heli" );
}

hacker_wait_trigger_or_damage( str_trigger_name )
{
	if ( IsDefined( str_trigger_name) )
	{
		trig = GetEnt( str_trigger_name, "targetname" );
		trig endon( "trigger" );
	}
	self endon( "damage" );
	self endon( "death" );
	
	level.player waittill_player_looking_at( self.origin + (0, 0, 96), 0.7 );
	wait RandomFloatRange( 0.0, 2.0 );
}

hacker_wait_and_react( str_react_scene, str_trigger_name )
{
	self endon( "death" );
	self hacker_wait_trigger_or_damage( str_trigger_name );
	run_scene( str_react_scene );
}

// bad guys hack until you look at them, then they fight.
//
scene_cic_hackers()
{
	level thread run_scene_and_delete( "cic_hacker_01_loop" );
	level thread run_scene_and_delete( "cic_hacker_02_loop" );
	level thread run_scene_and_delete( "cic_hacker_03_loop" );
	
	wait_network_frame();
	
	set1 = get_ais_from_scene( "cic_hacker_01_loop" );
	set2 = get_ais_from_scene( "cic_hacker_02_loop" );
	set3 = get_ais_from_scene( "cic_hacker_03_loop" );
	
	set1[0] thread hacker_wait_and_react( "cic_hacker_01_react" );
	set2[0] thread hacker_wait_and_react( "cic_hacker_02_react" );
	set3[0] thread hacker_wait_and_react( "cic_hacker_03_react", "bridge_front_trigger" );
}

scene_cic_bodies()
{
	level thread run_scene_and_delete( "cic_body_01" );
	level thread run_scene_and_delete( "cic_body_02" );
	level thread run_scene_and_delete( "cic_body_03" );
	
	trigger_wait( "catwalk_exit_trigger" );
	end_scene( "cic_body_01" );
	end_scene( "cic_body_02" );
	end_scene( "cic_body_03" );
}

bridge_fodder_guys()
{
	// Wait till you either kill that first turret, or enter the room.
	level waittill_trigger_or_notify( "bridge_enter_trigger", "killed_first_turret" );
	
	// These guys spawn in, run to their goal and eat dirt.
	simple_spawn( "bridge_fodder", ::bridge_fodder_logic );
}

typer_watch_approach()
{
	self endon( "death" );
	self endon( "damage" );
	react_trigger = GetEnt( "typer_react_trigger", "targetname" );
	react_trigger endon( "trigger" );
	level.player waittill_player_looking_at( self.origin + (0, 0, 96), 0.7 );
	wait RandomFloatRange( 0.0, 2.0 );
}

familiar_face_ai_exit( ai_list, node_list )
{
	// You can't see them out the window anymore, so just delete them.
	for ( i = 0; i < ai_list.size; i++ )
	{
		ai_list[i] Delete();
	}
}

scene_familiar_face()
{
	enemies = get_ai_group_ai( "pre_bridge_ai" );
	array_func( enemies, ::die );
	
	//player animation is slightly shorter than the other two animations
	level thread run_scene_and_delete( "familiar_face_player" );
	
	vision_set_bridge();
	
	//run animation of women opening door for player
	level thread run_scene_and_delete( "familiar_face" );
	
	wait_network_frame();
	
	allies = [];
	wounded_lady = get_ais_from_scene( "familiar_face" )[0];
	wounded_lady magic_bullet_shield();
	allies[allies.size] = wounded_lady;
	
	scene_wait( "familiar_face" );
	
	// get the guys who came up there with you.
	nodes = GetNodeArray( "familiar_face_nodes", "targetname" );
	for ( i = 0; i < nodes.size; i++ )
	{
		ally = GetNodeOwner( nodes[i] );
		if ( !IsDefined( ally ) )
		{
			continue;
		}
		
		// for some reason, I've gotten the player at times.  Weird.
		if ( IsPlayer( ally ) )
		{
			continue;
		}
		
		allies[allies.size] = ally;
	}
	
	level thread familiar_face_ai_exit( allies, GetNodeArray( "familiar_face_exit_node", "targetname" ) );
}

open_catwalk_door( do_open )
{
	if ( !isdefined( do_open ) )
	{
		do_open = true;
	}
	
	catwalk_door = GetEnt( "catwalk_door_collision", "targetname" );
	
	if ( catwalk_door.is_open == do_open )
	{
		return;
	}
	
	const rotate_angle = -110;
	if ( !do_open )
	{
		// Close the door.
		catwalk_door RotateYaw( -rotate_angle, 0.5, 0, 0 );
		catwalk_door DisconnectPaths();
	} else {
		// Open the door.
		catwalk_door RotateYaw( rotate_angle, 0.5, 0, 0 );
		catwalk_door ConnectPaths();
	}
	
	catwalk_door.is_open = do_open;
}

////////////////////////////////
//                            //
//    EXTERNAL FUNCTIONS      //
//                            //
////////////////////////////////

init_doors()
{	
	catwalk_door = GetEnt( "catwalk_door", "targetname" );
	catwalk_door_collision = GetEnt( catwalk_door.target, "targetname" );
	catwalk_door LinkTo( catwalk_door_collision );
	catwalk_door_collision.is_open = false;
}

init_flags()
{
	flag_init( "at_bridge_entry" );
	flag_init( "at_bridge" );
	flag_init( "at_catwalk" );
	
	flag_init( "spec_ops_started" );
	flag_init( "spec_ops_line_delivered" );
	flag_init( "spec_ops_failed" );
	flag_init( "spec_ops_completed" );
	
	flag_init( "tackle_sailor_saved" );
}

////////////////////////////////
//    'MOMENT' FUNCTIONS      //
////////////////////////////////

scene_catwalk()
{
	// wait for explodey times.
	trigger_wait( "catwalk_explosion_trigger" );
	
	// make the fodder guys vulnerable.
	fodder_guys = get_ai_group_ai( "catwalk_rocket_fodder" );
	array_func( fodder_guys, ::stop_magic_bullet_shield );
	
	s_rpg_start = getstruct( "catwalk_rpg_start", "targetname" );
	s_rpg_end = getstruct( s_rpg_start.target, "targetname" );
	
	e_rpg = MagicBullet( "rpg_magic_bullet_sp", s_rpg_start.origin, s_rpg_end.origin );
	e_rpg waittill( "death" );
	
	level thread run_scene_and_delete( "catwalk_rpg_hit" );
	
	wait_network_frame();
	
	explosion_pos = s_rpg_end.origin;
	explosion_launch( explosion_pos, 256.0, 150, 200, 15, 35 );
	
	// make the thing explode a fraction of a second later, so the ragdolls
	// are active at the same time.
	wait 0.1;
	e_obs_hub = GetEnt("fxanim_obs_hub_rpg_hide", "targetname");
	e_obs_hub Delete();
	level notify( "fxanim_obs_hub_rpg_start" );
	
	// set up the ziptied PMCs and the window throw..
	level thread scene_ziptied_pmcs();
}

scene_ziptied_pmcs()
{
	level thread maps\blackout_anim::play_wounded_anims( "security_dead", "delete_security_wounded" );
	level thread ziptie_pmc_01();
	level thread ziptie_sailor_01();
	level thread ziptie_sailor_02();
	level thread run_scene_and_delete( "ziptied_pmcs_loop" );
	
	level.end_ziptie = false;
	level.pmc_01_loop_playing = false;
	level.sailor_01_loop_playing = false;
	level.sailor_02_loop_playing = false;
	
	wait_network_frame();
	
	trigger_wait( "double_stairs_mid" );
	
	level.end_ziptie = true;
	
	end_scene( "ziptied_pmcs_loop" );
	if( level.pmc_01_loop_playing )
	{
		end_scene( "ziptied_pmc_01_loop" );
	}
	else
	{
		end_scene( "ziptied_pmc_01" );
		ai_for_scene = GetEnt( "ziptie_pmc_01_ai", "targetname" );
		if( IsDefined( ai_for_scene ) && IsAlive( ai_for_scene ) )
		{ 
			ai_for_scene Delete();
		}
		
	}
	
	if( level.sailor_01_loop_playing )
	{
		end_scene( "ziptied_sailor_01_loop" );
	}
	else
	{
		end_scene( "ziptied_sailor_01" );
		ai_for_scene = GetEnt( "ziptie_sailor_01_ai", "targetname" );
		if( IsDefined( ai_for_scene ) && IsAlive( ai_for_scene ) )
		{ 
			ai_for_scene Delete();
		}
	}
	
	if( level.sailor_02_loop_playing )
	{
		end_scene( "ziptied_sailor_02_loop" );
	}
	else
	{
		end_scene( "ziptied_sailor_02" );
		ai_for_scene = GetEnt( "ziptie_sailor_02_ai", "targetname" );
		if( IsDefined( ai_for_scene ) && IsAlive( ai_for_scene ) )
		{ 
			ai_for_scene Delete();
		}
	}
	
	flag_wait( "at_defend_objective" );
	
	level notify( "delete_security_wounded" );
}

ziptie_pmc_01()
{
	level thread run_scene( "ziptied_pmc_01" );
	
	wait 0.05;
	
	ai_for_scene = GetEnt( "ziptie_pmc_01_ai", "targetname" );
	scene_wait( "ziptied_pmc_01" );
	
	if( IsDefined( ai_for_scene ) && IsAlive( ai_for_scene ) && !level.end_ziptie )
	{
		level.pmc_01_loop_playing = true;
		level thread run_scene_and_delete( "ziptied_pmc_01_loop" );
	}
}

ziptie_sailor_01()
{
	level run_scene( "ziptied_sailor_01" );
	
	if( !level.end_ziptie )
	{
		level.sailor_01_loop_playing = true;
		level thread run_scene_and_delete( "ziptied_sailor_01_loop" );
	}
}

ziptie_sailor_02()
{
	level run_scene( "ziptied_sailor_02" );
	if( !level.end_ziptie )
	{
		level.sailor_02_loop_playing = true;
		level thread run_scene_and_delete( "ziptied_sailor_02_loop" );
	}
}

setup_deck_battle_ally()
{
	// Your buddies don't shoot so well.  They need your help!
	self.attackerAccuracy = 0.1;
}

// spawns warring allies and enemies on the deck.
spawn_deck_spec_ops_battle()
{
	catwalk_spawn_snipers();
	
	// set up the battle
	add_spawn_function_ai_group( "deck_reveal_allies", ::setup_deck_battle_ally );
	
	// spawn the battle
	spawn_manager_enable( "deck_reveal_allies_sm" );
	spawn_manager_enable( "deck_reveal_enemies_sm" );
	
	// wait to start the "Real" part of the battle.
	trigger_wait( "catwalk_enter_trigger" );
	
	//turn off magic bulletshield on the AI along the catwalk
	array_func( level.catwalk_snipers, ::stop_magic_bullet_shield );
	
	
	while(!flag("spec_ops_passed") && !flag( "spec_ops_started")) //THIS FLAG IS SET IN A TRIGGER IN RADIANT
	{
		// If the player has a sniper rifle, make these guys vulnerable so you actually need to protect them.
		if( player_has_sniper_weapon() )
		{			
			s_snipe_obj = get_struct("struct_spec_op_obj", "targetname");
			set_objective( level.OBJ_HELP_SEALS, s_snipe_obj.origin, &"BLACKOUT_OBJ_SNIPE" );
			
			flag_set( "spec_ops_started" );
			
			level thread spec_ops_killed();		
			level thread spec_ops_battle_finish();
			
			flag_set( "spec_ops_line_delivered" );
		}
		
		wait(0.15); //DOESN'T NEED TO PUMP EVERY FRAME
	}
	
	// wait for the player to leave the outside area TODO: Move this trigger further into the ship
	trigger_wait( "catwalk_exit_trigger" );
	
	// cleanup the area if the player did not take care of the enemies
	if( !flag( "spec_ops_completed" ) )
	{
		//only fail objective if the player has it and already has not failed
		if( flag( "spec_ops_started" ) && !flag( "spec_ops_failed" ) )
		{
			set_objective( level.OBJ_HELP_SEALS, undefined, "failed" );
			// stop processing the old breadcrumb, and re-set it.
			level notify( "clear_old_breadcrumb" );
			level thread breadcrumb_and_flag( "security_breadcrumb", level.OBJ_RESTORE_CONTROL, "at_defend_objective", false );
		}
		
		//player moved on without helping
		flag_set( "spec_ops_failed" );
		
		// in case we didn't turn them off in "battle_finish"
		spawn_manager_kill( "deck_reveal_allies_sm" );
		spawn_manager_kill( "deck_reveal_enemies_sm" );
	
		// remove the guys that remain.
		a_ai = ArrayCombine( get_ai_group_ai( "deck_reveal_enemies" ), get_ai_group_ai( "deck_reveal_allies" ),true,false );
		array_thread( a_ai, ::spec_ops_kill_clear_battle );
	} else {
		autosave_by_name( "seals_saved" );
	}
	
	level notify( "seal_challenge_done" );
}

waittill_spawn_manager_spawns_x_more( str_spawn_manager, num_extra_spawns )
{
	// find out how many we've spawned so far.
	spawn_managers = maps\_spawn_manager::get_spawn_manager_array( str_spawn_manager );
	prev_count = spawn_managers[0].spawncount;
	
	// wait till we've spawned a few more before disabling the spawner.
	while ( spawn_managers[0].spawncount < prev_count + num_extra_spawns )
	{
		wait 0.25;
	}
}

//this is run if the player has a sniper rifle
spec_ops_battle_finish()
{
	const extra_spawns = 6;
	const advance_at_num_guys = 5;
	const end_at_num_guys = 3;
	
	level thread spec_ops_process_advancement();
	
	//notified if the player moves back into the ship or if all the SEALS die
	level endon( "spec_ops_failed" );
	
	// stop spawning new allies, they need to be protected now
	spawn_manager_kill( "deck_reveal_allies_sm" );
	
	waittill_spawn_manager_spawns_x_more( "deck_reveal_enemies_sm", extra_spawns );
	
	// move to the next node set.
	spec_ops_advance();
	
	// wait till we spawn x more guys.
	waittill_spawn_manager_spawns_x_more( "deck_reveal_enemies_sm", extra_spawns );
	
	// stop spawning new enemies
	spawn_manager_kill( "deck_reveal_enemies_sm" );
	
	// stop firing rockets.
	level notify( "random_rockets_stop" );
	
	// advance again.
	spec_ops_advance();
	
	// wait untill all enemies are dead.
	waittill_ai_group_ai_count( "deck_reveal_enemies", end_at_num_guys );
	
	// advance to the exit.
	flag_set( "spec_ops_completed" );
	set_objective( level.OBJ_HELP_SEALS, undefined, "done" );
	level thread spec_ops_exit();
	
	// stop processing the old breadcrumb, and re-set it.
	level notify( "clear_old_breadcrumb" );
	level thread breadcrumb_and_flag( "security_breadcrumb", level.OBJ_RESTORE_CONTROL, "at_defend_objective", false );
}

spec_ops_advance_to_node_set( str_node_set )
{
	//move all living seals down below deck
	allies = get_ai_group_ai( "deck_reveal_allies" );
	nodes = GetNodeArray( str_node_set, "targetname" );
	
	for ( i = 0; i < allies.size && i < nodes.size; i++ )
	{
		allies[i] change_movemode( "cqb_sprint" );
		allies[i].fixednode = true;
		allies[i] SetGoalNode( nodes[i] );
	}
}

spec_ops_process_advancement()
{
	level endon( "spec_ops_completed" );
	
	level waittill( "spec_ops_advance" );
	spec_ops_advance_to_node_set( "spec_ops_advance_01" );
	
	level waittill( "spec_ops_advance" );
	spec_ops_advance_to_node_set( "spec_ops_advance_02" );
}

// Move the spec ops guys to their next node set.
spec_ops_advance()
{
	level notify( "spec_ops_advance" );
}

spec_ops_exit()
{
	kill_remaining_enemies();
	
	//move all living seals down below deck
	allies = get_ai_group_ai( "deck_reveal_allies" );
	foreach( ally in allies )
	{
		ally.fixednode = false;
		ally change_movemode( "run" );
		ally thread spec_ops_ally_exit();
		wait RandomFloatRange( 0.5, 1.5 );
	}
}

//self is a living SEAL team member who advances below deck for later
spec_ops_ally_exit()
{
	self endon( "death" );
	
	self.fixednode = false;
	
	wait RandomFloat( 15.0 );
	
	//move the SEAL to below deck
	self force_goal( getstruct( "deck_reveal_end", "targetname" ).origin, 32, false );
	
	//only increment the saved number once he reaches the delete point
	level.num_seals_saved++;
	
	level notify( "seal_saved" );
	
	self Delete();
}

//monitors when all SEAL members have been killed
spec_ops_killed()
{
	level endon( "spec_ops_completed" );
	level endon( "spec_ops_failed" );
		
	waittill_ai_group_cleared( "deck_reveal_allies" );
		
	set_objective( level.OBJ_HELP_SEALS, undefined, "failed" );
	
	flag_set( "spec_ops_failed" );
}

//self is an AI in this battle
spec_ops_kill_clear_battle()
{
	self endon( "death" );
	
	wait RandomFloat( 20.0 );
	self die();
}

deck_drone_spawning()
{
	sp_pmc_spawner = GetEnt( "pmc_deck_drone_01", "targetname" );
	drones_assign_spawner( "pmc_deck_drones_01", sp_pmc_spawner );
	wait_network_frame();
	
	drones_start( "pmc_deck_drones_01" );
	
	level waittill( "familiar_face_player_started" );
	
	drones_delete( "pmc_deck_drones_01" );
}

holo_table_flicker_out_wait()
{
	trig = GetEnt( "holo_table_flicker_out_trigger", "targetname" );
	trig endon( "trigger" );
	flag_wait( "at_catwalk" );
}

holo_table_flicker_out()
{
	image = GetEnt( "P6_hologram_city_buildings", "targetname" );
	image Hide();
	
	const flicker_out_time = 8.0;
	
	time_elapsed = 0.0;
	image Show();
	flicker_on = true;
	
	holo_table_flicker_out_wait();
	
	// glinty stuff around the holo table.
	exploder( 111 );
	
	while ( time_elapsed < flicker_out_time )
	{
		flick_time = 0.1;
		if ( flicker_on )
		{
			flick_time = RandomFloatRange( 0.1, 0.2 );
			image Hide();
		} else {
			flick_time = RandomFloatRange( 0.1, 1.0 );
			image Show();
		}
		flicker_on = !flicker_on;
		
		wait flick_time;
		time_elapsed += flick_time;
	}
	
	// delete once we're done.
	image Delete();
	
	wait 2.0;
	
	stop_exploder( 111 );
}

// performs a physics pulse when the player enters the turret.
//
turret_physics_pulse()
{
	e_turret = GetEnt( "bridge_turret", "targetname" );
	e_turret endon( "death" );
	level endon( "bridge_turret_perk_done" );
	e_turret waittill( "turret_entered" );
//
//	PhysicsJolt( e_turret.origin + (0, 0, -30), 10000, 10000, ( 1, 1, 1 ) * 100.0 );
	
	//console_chairs = GetEntArray( "fxdest_p6_chair_console_d0", "model" );
	
//	foreach( chair in console_chairs )
//	{
//		force_x = RandomFloatRange( 0.001, 0.005 );
//		force_y = RandomFloatRange( 0.001, 0.005 );
//		force_z = RandomFloatRange( 0.001, 0.005 );
//		
	PhysicsJolt( ( 286, 20, 450 ), 256, 128, ( 1, 1, 0) * 10000 );
//	}
	
	//fxdest_p6_chair_console
}
