#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;
#include maps\_anim;
#include maps\_music;

// pel2_airfield script

main()
{

	level notify( "obj_building_complete" );

	//Tuey Change Music State (must be both here AND the other script so it works on checkpoint)
	setmusicstate("POST_ADMIN");
	
	maps\_debug::set_event_printname( "Airfield" );

	// DEBUG TEMP
	/#
	level thread debug_tank_health();
	#/
	//
	
	level thread delete_old_turrets();
	
	level thread airfield_initial_chains();
	level thread airfield_initial_spawns();
	level thread past_wing();
	level thread airfield_ambience();
	level thread tank_battle();
	level thread at_cinch_point();
	level thread save_when_near_cinch_point();
	level thread move_wave_2_2();
	level thread spawn_airfield_pickup_weapons();

	// update color reinforcement location
	trig = getent( "trigger_airfield_wave", "script_noteworthy" );
	trig notify( "trigger" );
	
}



///////////////////
//
// space out the spawning of the initial enemies
//
///////////////////////////////

airfield_initial_spawns()
{
	wait( 0.5 );
	simple_spawn( "airfield_truck_guys", ::airfield_truck_guys_strat );
	wait( 0.25 );
	simple_spawn( "airfield_strafe_victims", ::airfield_strafe_victims_strat );
	
	if (!NumRemoteClients())		
	{
		wait( 0.25 );
		simple_spawn( "airfield_strafe_victims_2", ::airfield_strafe_victims_2_strat );
	}
	
}



airfield_initial_chains()
{

	// notify comes from flag on trigger
	level endon( "chain_past_wing" );

	wait( 9 );
	
	set_color_chain( "chain_airfield_1" );	

	flag_set( "airfield_move_vo" );

	// happens when all chi_1a are dead
	flag_wait( "tank_spawn_n_move_2" );
	
	set_color_chain( "chain_airfield_2" );	

	// happens when player moves up far enough
	flag_wait( "move_wave_2_1" );
	flag_wait_either( "chi_1b_wave_almost_dead", "chi_1b_wave_dead" );
	
	set_color_chain( "chain_airfield_2a" );	
	
	wait( 0.05 ); // if flag below is set, then color_chain below will trigger before the set_color_chain() call above finishes. this wait solves that problem
	
	flag_wait( "chi_1b_wave_dead"  );
	
	color_chain = getent( "trig_chain_past_wing", "script_noteworthy" );
	if( isdefined( color_chain ) )
	{
		color_chain notify( "trigger" );
	}
	
	
}



airfield_vo()
{
	
	// flag set on trigger
	flag_wait( "trig_admin_back" );
	
	
	level endon( "pacing_vignette_started" );
	
	battlechatter_off( "allies" );		
	wait( 1.0 );
	
	play_vo( level.polonsky, "vo", "aint_easy" );
	
	wait( 2.4 );
	
	play_vo( level.roebuck, "vo", "it_never_is" );
	
	flag_wait( "airfield_move_vo" );
	
	play_vo( level.roebuck, "vo", "move!" );
	
	wait( 0.5 );
	battlechatter_on( "allies" );
	
	flag_wait( "move_wave_2_1" );
	
	
	battlechatter_off( "allies" );	
	play_vo( level.roebuck, "vo", "stay_with_tanks" );
	
	wait( 1.5 );
	
	play_vo( level.roebuck, "vo", "help_them_move" );
	battlechatter_on( "allies" );	
	
	flag_wait( "at_cinch_point" );
	
	
	battlechatter_off( "allies" );	
	play_vo( level.polonsky, "vo", "jap_aa_guns" );
	
	wait( 2.5 );
	
	play_vo( level.roebuck, "vo", "deal_with_tanks" );
	
	wait( 3 );
	
	play_vo( level.roebuck, "vo", "scavenge_supplies" );
	
	wait( 2 );
	
	play_vo( level.roebuck, "vo", "hit_em_with" );
	
	level thread player_get_bazooka_reminder();
	
	battlechatter_on( "allies" );	
	
	flag_wait( "trig_clear_trenches_vo" );
	
	
	play_vo( level.roebuck, "vo", "clear_out_trenches" );
	
	flag_wait( "trig_entering_aa_bunker" );
	
	
	battlechatter_off( "allies" );	
	play_vo( level.roebuck, "vo", "take_out_aa_guns" );
	
	wait( 3 );
	
	play_vo( level.roebuck, "vo", "taking_airfield_today" );
	battlechatter_on( "allies" );	
	
	flag_wait( "trig_entering_aa_bunker_top" );

	// check if they're alive
	aa_crew = get_ai_group_ai( "last_aa_ai_4" );
	if( aa_crew.size )
	{	
		play_vo( level.roebuck, "vo", "first_gun_crew" );
	}
	
	
	level waittill( "obj_aaguns_complete" );
	
	battlechatter_off( "allies" );	
	play_vo( level.polonsky, "vo", "goodnight" );
//	wait( 1.5 );
//	play_vo( level.roebuck, "vo", "nice_work_marines" );

	battlechatter_on( "allies" );	
		
}



///////////////////
//
// Kill guys that survive the truck crash if player advances far enough
//
///////////////////////////////

past_wing()
{

	// flag set on trigger
	flag_wait( "chain_past_wing" );
	
	truck_survivers = get_ai_group_ai( "truck_flip_ai" );
	
	for( i = 0; i < truck_survivers.size; i++ )
	{
		truck_survivers[i] thread bloody_death( true, 1 );
	}
	
	autosave_by_name( "Pel2 on tarmac" );
	
}



///////////////////
//
// Enemies that get killed by the strafing corsair at the cinch point
//
///////////////////////////////

airfield_strafe_victims_strat()
{

	self endon( "death" );

	level thread airfield_strafe_victims_strat_damage();
	
	self.ignoreme = 1;
	self.ignoreall = 1;
	self.pacifist = 1;
	self.pacifistwait = 0.05;
	
	// so they don't peek out
	self set_force_cover( "hide" );
	
	self allowedstances ( "crouch" );
	
	flag_wait( "plane_strafe" );
	
	self allowedstances ( "crouch", "stand" );

	goal_node = getnode( self.script_noteworthy, "targetname" );
	self setgoalnode( goal_node ); 
	
	flag_wait_or_timeout( "plane_strafe_shoot", 6 );
	
	wait( 0.85 );
	
	self thread bloody_death( true );
	
}



airfield_strafe_victims_2_strat()
{

	self endon( "death" );

	self.ignoreme = 1;
	self.ignoreall = 1;
	self.pacifist = 1;
	self.pacifistwait = 0.05;
	
	// so they don't peek out
	self set_force_cover( "hide" );
	
	self allowedstances ( "crouch" );
	
	flag_wait( "plane_strafe" );
	
	self allowedstances ( "crouch", "stand" );

	self.ignoreme = 0;
	self.ignoreall = 0;
	self.pacifist = 0;

	goal_node = getnode( self.script_noteworthy, "targetname" );
	self setgoalnode( goal_node ); 
	
	//self waittill( "goal" );
	
	//self.health = 30;
	
}



airfield_strafe_victims_strat_damage()
{

	self endon( "death" );

	self waittill( "damage" );
	
	self allowedstances ( "crouch", "stand" );
	
	self.ignoreme = 0;
	self.pacifist = 0;
	self.ignoreall = 0;
	
}



///////////////////
//
// strat for guys that hide near truck before cinch point area
//
///////////////////////////////

airfield_truck_guys_strat()
{

	self endon( "death" );
	
	self.maxSightDistSqrd = 2000 * 2000; 
	self set_force_cover( "hide" );
	self.ignoreme = 1;
	
	flag_wait( "move_wave_2_1" );
	
	self set_force_cover( "none" );
	
	self.ignoreme = 0;
	
}



///////////////////
//
// Ambient battle that takes place on the left airstrip
//
///////////////////////////////

ambient_left_battle()
{

	// flag set on trigger
	flag_wait( "move_wave_2_2" );
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 4 );
	
	wait_network_frame();
	
	trig = getent( "airfield_ally_drones_ambient_1", "script_noteworthy" );
	trig notify( "trigger" );

	wait_network_frame();

	trig = getent( "airfield_axis_drones_ambient_1", "script_noteworthy" );
	trig notify( "trigger" );

	wait( 0.05 );
	
	axis_tank = getent( "airfield_ambient_tank_2", "targetname" );
	ally_tank = getent( "airfield_ambient_tank_1", "targetname" );
	
	ally_tank notify( "stop_vehicle_compasshandle" );
	
	axis_tank keep_tank_alive();
	axis_tank.rollingdeath = 1;
	axis_tank thread tank_smoke_death();
	axis_tank notify( "stop_vehicle_compasshandle" );
	
	axis_tank thread attack_this_tank( "airfield_ambient_tank_1", 4 );
	ally_tank thread attack_this_tank( "airfield_ambient_tank_2" );
	
	axis_tank thread veh_stop_at_node( "node_ambient_axis_tank_stop_1", 6, 6 );
	
	while( ally_tank.health )
	{
		wait( 0.5 );
	}
	
	axis_tank resumespeed( 4 );
	
	wait( RandomIntRange( 3, 5 ) );
	
	axis_tank stop_keep_tank_alive();
	
	// fake kill the axis tank
	level thread maps\_mortar::mortar_loop( "orig_mortar_airfield_ambient_canned" );
	wait( 0.1 );
	level notify( "stop_mortar_airfield_ambient_canned" );

	radiusdamage( axis_tank.origin, 10, axis_tank.health + 1, axis_tank.health + 1 );

}



///////////////////
//
// Ambient arty fx on the ridge
//
///////////////////////////////

ridge_flashes()
{

	origs = getstructarray( "orig_ridge_flash", "targetname" );
	
	last_rand = 0;
	rand = 0;
	
	while( 1 )
	{
		
		// make sure we don't play at the same location twice in a row
		while( rand == last_rand )
		{
			rand = randomint(origs.size);
			wait( 0.05 );
		}
		
		last_rand = rand;
		
		playfx( level._effect["fx_artilleryExp_ridge"], origs[rand].origin );
		
		wait( randomfloatrange( 0.45, 1.75 ) );
		
	}
	
}



///////////////////
//
// Fires/smoke on the downed bomber
//
///////////////////////////////

airfield_plane_fire()
{
	exploder( 501 );
}



///////////////////
//
// AA tracers in the sky
//
///////////////////////////////

aa_ambient_fire()
{

	while(!oktospawn())
	{
		wait(0.05);
	}
	
	maps\_vehicle::spawn_vehicle_from_targetname( "aaGun_1" );
	maps\_vehicle::spawn_vehicle_from_targetname( "aaGun_2" );
	maps\_vehicle::spawn_vehicle_from_targetname( "aaGun_3" );
	maps\_vehicle::spawn_vehicle_from_targetname( "aaGun_4" );
	
	wait( 2 );

	aaGun_1 = getent( "aaGun_1", "targetname" );
	aaGun_2 = getent( "aaGun_2", "targetname" );
	aaGun_3 = getent( "aaGun_3", "targetname" );
	aaGun_4 = getent( "aaGun_4", "targetname" );

	// Client side their firing...

	aaGun_1.client_side_fire = true;
	aaGun_2.client_side_fire = true;
	aaGun_3.client_side_fire = true;
	aaGun_4.client_side_fire = true;

	aaGun_1 transmittargetname();
	aaGun_2 transmittargetname();
	aaGun_3 transmittargetname();
	aaGun_4 transmittargetname();

	// so they can't be destroyed early
	aaGun_1 keep_tank_alive();
	aaGun_2 keep_tank_alive();
	aaGun_3 keep_tank_alive();
	aaGun_4 keep_tank_alive();

	aaGun_1 thread aa_move_target( "aaGun_1_target" );
	wait( randomfloatrange( 1, 2.5 ) );
	aaGun_2 thread aa_move_target( "aaGun_2_target" );
	wait( randomfloatrange( 1, 2.5 ) );
	aaGun_3 thread aa_move_target( "aaGun_3_target" );
	wait( randomfloatrange( 1, 2.5 ) );
	aaGun_4 thread aa_move_target( "aaGun_4_target" );

	clientNotify("start25s");
}



///////////////////
//
// Move the script origins that the Triple25s target so the tracers move back & forth across the sky
//
///////////////////////////////

aa_move_target( orig_name, end_spot )
{

	self endon( "death" );
	self endon( "crew dead" );
	self endon( "change target" );
	self endon( "crew dismount" );

	org = getent( orig_name, "script_noteworthy" );

	targ_1 = org.origin + ( 400, 0, 0 );
	targ_2 = org.origin - ( 400, 0, 0 );

	while( 1 )
	{
		org MoveTo( targ_1, 8 );
		org waittill( "movedone" );
		org MoveTo( targ_2, 8 );
		org waittill( "movedone" );
	}	
	
}



///////////////////
//
// Mortars on the outskirts of the play area
//
///////////////////////////////

airfield_mortars()
{

	if(isdefined(level.clientscripts) && level.clientscripts)
	{
		clientNotify("air_mortars");	// Migrated these mortars over to the client.  DSL
	}
	else
	{
		maps\_mortar::set_mortar_delays( "orig_mortar_airfield_sw", 1, 4 ,0.5, 1.25 );
		maps\_mortar::set_mortar_range( "orig_mortar_airfield_sw", 200, 15000 );
		maps\_mortar::set_mortar_damage( "orig_mortar_airfield_sw", 256, 25, 50 );
		maps\_mortar::set_mortar_quake( "orig_mortar_airfield_sw", 0.32, 3, 1800 );
		maps\_mortar::set_mortar_dust( "orig_mortar_airfield_sw", "bunker_dust", 512 );
		
		
		maps\_mortar::set_mortar_delays( "orig_mortar_airfield_nw", 1, 4, 0.5, 1.25 );
		maps\_mortar::set_mortar_range( "orig_mortar_airfield_nw", 200, 15000 );
		maps\_mortar::set_mortar_damage( "orig_mortar_airfield_nw", 256, 25, 50 );
		maps\_mortar::set_mortar_quake( "orig_mortar_airfield_nw", 0.32, 3, 1800 );
		maps\_mortar::set_mortar_dust( "orig_mortar_airfield_nw", "bunker_dust", 512 );
		
		
		maps\_mortar::set_mortar_delays( "orig_mortar_airfield_ne", 1, 4, 0.5, 1.25 );
		maps\_mortar::set_mortar_range( "orig_mortar_airfield_ne", 200, 15000 );
		maps\_mortar::set_mortar_damage( "orig_mortar_airfield_ne", 256, 25, 50 );
		maps\_mortar::set_mortar_quake( "orig_mortar_airfield_ne", 0.32, 3, 1800 );
		maps\_mortar::set_mortar_dust( "orig_mortar_airfield_ne", "bunker_dust", 512 );
		
		
		maps\_mortar::set_mortar_delays( "orig_mortar_airfield_se", 1, 4, 0.5, 1.25 );
		maps\_mortar::set_mortar_range( "orig_mortar_airfield_se", 200, 15000 );
		maps\_mortar::set_mortar_damage( "orig_mortar_airfield_se", 256, 25, 50 );
		maps\_mortar::set_mortar_quake( "orig_mortar_airfield_se", 0.32, 3, 1800 );
		maps\_mortar::set_mortar_dust( "orig_mortar_airfield_se", "bunker_dust", 512 );			
	
		level thread maps\_mortar::mortar_loop( "orig_mortar_airfield_sw" );
		level thread maps\_mortar::mortar_loop( "orig_mortar_airfield_nw" );
		level thread maps\_mortar::mortar_loop( "orig_mortar_airfield_ne" );
		level thread maps\_mortar::mortar_loop( "orig_mortar_airfield_se" );
	}
	// for canned mortar
	maps\_mortar::set_mortar_delays( "orig_mortar_airfield_canned", 0.25, 0.3, 0.25, 0.3 );
	maps\_mortar::set_mortar_range( "orig_mortar_airfield_canned", 1, 10000 );
	maps\_mortar::set_mortar_damage( "orig_mortar_airfield_canned", 256, 25, 50 );
	maps\_mortar::set_mortar_quake( "orig_mortar_airfield_canned", 0.32, 3, 1800 );
	maps\_mortar::set_mortar_dust( "orig_mortar_airfield_canned", "bunker_dust", 512 );
	
	// for canned ambient mortar
	maps\_mortar::set_mortar_delays( "orig_mortar_airfield_ambient_canned", 0.25, 0.3, 0.25, 0.3 );
	maps\_mortar::set_mortar_range( "orig_mortar_airfield_ambient_canned", 1, 10000 );
	maps\_mortar::set_mortar_damage( "orig_mortar_airfield_ambient_canned", 256, 25, 50 );
	maps\_mortar::set_mortar_quake( "orig_mortar_airfield_ambient_canned", 0.32, 3, 1800 );
	maps\_mortar::set_mortar_dust( "orig_mortar_airfield_ambient_canned", "bunker_dust", 512 );	
	
}



///////////////////
//
// Corsairs in the sky
//
///////////////////////////////

ambient_planes()
{

	level.last_plane_crash = gettime();

	level thread ambient_planes_1();
	wait( RandomIntRange( 4, 6 ) );
	level thread ambient_planes_2();
	wait( RandomIntRange( 4, 6 ) );
	level thread ambient_planes_3();
	
}



ambient_planes_1()
{
	
	if(NumRemoteClients() < 2)
	{
		level thread plane_loop( "airfield_ambient_plane_1_a" );
	}
	
	// CODER_MOD JB - Co-op reduce entity count in network snapshot.
	if (!NumRemoteClients())
	{
		level thread plane_loop( "airfield_ambient_plane_1_b" );
	}
	
}



ambient_planes_2()
{
	
	if(NumRemoteClients() < 2)
	{
		level thread plane_loop( "airfield_ambient_plane_2_a" );
	}
	
	// CODER_MOD JB - Co-op reduce entity count in network snapshot.
	if (!NumRemoteClients())
	{
		level thread plane_loop( "airfield_ambient_plane_2_b" );
	}
	
}



ambient_planes_3()
{
	
	if(NumRemoteClients() < 2)
	{
		level thread plane_loop( "airfield_ambient_plane_3_a" );
	}
	
	// CODER_MOD JB - Co-op reduce entity count in network snapshot.
	if (!NumRemoteClients())
	{
		level thread plane_loop( "airfield_ambient_plane_3_b" );	
	}
	
}



napalm_planes()
{

	plane = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "napalm_plane_1" );
	plane_2 = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "napalm_plane_2" );

	plane maps\_vehicle::godon();
	plane_2 maps\_vehicle::godon();

	plane playsound( "nap_plane_a" );
	plane_2 playsound( "nap_plane_a" );

	plane thread napalm_plane_1_release();
	plane_2 thread napalm_plane_2_release();
	
}



napalm_plane_1_release()
{
	
	// wait for the planer to hit the node
	node = getvehiclenode( "plane_1_napalm","script_noteworthy" );
	node waittill ( "trigger" );
	
	// spawn in a ent to play the effect from
	org = spawn( "script_model", self.origin );
	org setmodel( "aircraft_bomb" );

	// destination for the bomb
	dest = getstruct( "orig_plane_1_napalm","targetname" );

	// hack wait for playfx to work on spawned in, be sure to drive my car into the coders office
	// if they dont fix this soon
	wait (0.05);
	
	level notify( "napalm_release_1" );
	
	// have the bomb to travel from the plane to the ground
	org moveto( dest.origin, 0.4 );
	wait( 0.4 );
	
	sound_origin = spawn( "script_origin", ( 2004, 9577, -11.6 ) );
	sound_origin playsound( "napalm_impact_1" );
	
	// delete the bomb
	org delete();
	
	exploder( 502 );	
	
	orig = getent( "node_end_vigenette", "targetname" );
	PlayRumbleOnPosition( "explosion_generic", orig.origin ); 
	
}



napalm_plane_2_release()
{

	// wait for the planer to hit the node
	node = getvehiclenode( "plane_2_napalm","script_noteworthy" );
	node waittill ( "trigger" );
	
	// spawn in a ent to play the effect from
	org = spawn( "script_model", self.origin );
	org setmodel( "aircraft_bomb" );

	// destination for the bomb
	dest = getstruct( "orig_plane_2_napalm","targetname" );

	// hack wait for playfx to work on spawned in, be sure to drive my car into the coders office
	// if they dont fix this soon
	wait (0.05);
	
	// have the bomb to travel from the plane to the ground
	org moveto( dest.origin, 0.4 );
	wait( 0.4 );
	// delete the bomb
	org delete();

	exploder( 503 );
	
	orig = getent( "node_end_vigenette", "targetname" );
	PlayRumbleOnPosition( "explosion_generic", orig.origin ); 	
	
}



napalm_plane_3_release()
{

	// wait for the planer to hit the node
	node = getvehiclenode( "plane_3_napalm","script_noteworthy" );
	node waittill ( "trigger" );
	
	// spawn in a ent to play the effect from
	org = spawn( "script_model", self.origin );
	org setmodel( "aircraft_bomb" );

	// placed struct in the map
	dest = getstruct( "orig_plane_3_napalm","targetname" );

	// hack wait for playfx to work on spawned in, be sure to drive my car into the coders office
	// if they dont fix this soon
	wait (0.05);
	
	// have the bomb to travel from the plane to the ground
	org moveto( dest.origin, 0.4 );
	wait( 0.4 );
	
	sound_origin = spawn( "script_origin", ( 2004, 9577, -11.6 ) );
	sound_origin playsound( "napalm_impact_1" );

	exploder( 504 );
	
	// delete the bomb
	org delete();		
	
}



napalm_plane_4_release()
{

	// wait for the planer to hit the node
	node = getvehiclenode( "plane_4_napalm","script_noteworthy" );
	node waittill ( "trigger" );
	
	// spawn in a ent to play the effect from
	org = spawn( "script_model", self.origin );
	org setmodel( "aircraft_bomb" );

	// placed struct in the map
	dest = getstruct( "orig_plane_4_napalm","targetname" );

	// hack wait for playfx to work on spawned in, be sure to drive my car into the coders office
	// if they dont fix this soon
	wait (0.05);
	
	// have the bomb to travel from the plane to the ground
	org moveto( dest.origin, 0.4 );
	wait( 0.4 );
	
	exploder( 505 );

	// delete the bomb
	org delete();	
	
}



plane_loop( plane_name )
{

	while( !flag( "pacing_vignette_started" ) )
	{

		// randomly have some crash
		if( !flag( "trig_tower_plane" ) && !RandomInt( 6 ) && time_for_plane_crash() )
		{
			
			level.last_plane_crash = gettime();
			
			while(!oktospawn())
			{
				wait(0.1);		// make sure we dont spawn right now, if the network is having a hard time.
			}
			
			plane = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( plane_name + "_dest" );
			
			death_node = getvehiclenode( plane.targetname + "_d", "script_noteworthy" );
			death_node waittill( "trigger" );
			
			radiusdamage( plane.origin, 10, plane.health + 1, plane.health + 1 );
			
			// choose where to play the fire/smoke fx
			switch( RandomInt( 3 ) )
			{
				case 0:
				
					plane_tag = "tag_wingtipR";
					break;
				
				case 1:
				
					plane_tag = "tag_wingtipL";
					break;	
				
				default:
				
					plane_tag = "tag_tailbottom";								
			}
			
			playfxontag( level._effect["fighter_wing_hit"], plane, plane_tag );
			
		}
		else
		{
			while(!oktospawn())
			{
				wait(0.1);		// make sure we dont spawn right now, if the network is having a hard time.
			}
			
			plane = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( plane_name );
			plane playsound( "ambient_corsair" );
		}
		
		
		plane waittill( "reached_end_node" );
		
		wait( RandomFloatRange( 2.0, 4.0 ) );
		
	}
	
}



///////////////////
//
// Space out the plane crashes in the sky so they don't happen too often
//
///////////////////////////////

time_for_plane_crash()
{
	
	if( ( gettime() - level.last_plane_crash ) > 12000 )
	{
		return true;
	}
	else
	{
		return false;
	}
	
}



///////////////////
//
// Tank battle master thread
//
///////////////////////////////

tank_battle()
{

	level thread tank_wave_1();
	level thread shermans_wave_3();	
	level thread tank_wave_3();
	level thread move_wave_2_1();

	level thread airfield_last_trench();
	level thread plane_pole();

	// Wii optimizations
	if( !level.wii)
	{
		level thread bazooka_special();
	}
	
}



///////////////////
//
// some behavior for tanks when move_wave_2_1 flag has been set
//
///////////////////////////////

move_wave_2_1()
{

	// is set when player gets near the first set of crates for cover (to the left of overturned truck)
	flag_wait( "move_wave_2_1" );

	quick_text( "move_wave_2_1", 3, true );

	chi_tanks = get_alive_noteworthy_tanks( "chi_wave_1b" );
	array_thread( chi_tanks, maps\_vehicle::mgon );

	chi_tanks = get_alive_noteworthy_tanks( "chi_wave_1c" );
	array_thread( chi_tanks, maps\_vehicle::mgon );
	
}



///////////////////
//
// last infantry battle on airfield ground
//
///////////////////////////////

airfield_last_trench()
{
	
	// flag set on trigger
	flag_wait( "trig_airfield_last_trench" );

	quick_text( "last trench", 3, true );

	autosave_by_name( "Pel2 last trench" );

	level thread plane_tower_aa_direct_fire();
	level thread last_trench_chain();
	level thread plane_tower();
	level thread trig_spawn_aa_early_mid_guys();
	level thread trig_spawn_aa_mid_guys();
	
	flag_set( "airfield_last_trench" );

	simple_floodspawn( "last_trench_spawners" );
	wait_network_frame(); // CLIENTSIDE to help snapshot size
	simple_floodspawn( "last_trench_spawners_2" );
	level thread last_trench_banzai();

	last_aa_defense();

}




trig_spawn_aa_early_mid_guys()
{
	trigger_wait( "trig_aa_spawn_early_mid_guys", "targetname" );
	simple_spawn( "aa_early_mid_guys_1" );
	wait_network_frame();
	simple_spawn( "aa_early_mid_guys_2" );
}



///////////////////
//
// piggbybacking this here to save a trigger ent
//
///////////////////////////////

trig_spawn_aa_mid_guys()
{
	trigger_wait( "trig_spawn_aa_mid_guys", "targetname" );
	simple_floodspawn( "aa_mid_guys" );
}



///////////////////
//
// if player hangs around in the last trench for too long, send some banzai guys at him
//
///////////////////////////////

last_trench_banzai()
{

	level endon( "trig_last_aa_guys" );

	for( i  = 0; i < 2; i++ )
	{
		
		wait( RandomIntRange( 14, 18 ) + ( i * RandomIntRange( 3, 6 ) ) );
		
		vol = getent( "vol_last_trench", "targetname" );
		
		// wait till player is near last trench
		while( 1 )
		{
			if( any_player_IsTouching( vol ) )
			{
				break;	
			}
		
			wait( 0.5 );
		}
		
		guys = get_ai_group_ai( "last_trench_ai" );
		
		quick_text( "last_trench_banzai()" );
		
		if( guys.size > 2 )
		{
			for( j  = 0; j < 3; j++ )
			{
				guys[j].banzai_no_wait = 1;
				guys[j] thread maps\_banzai::banzai(); 
			}
		}
		else if( guys.size > 1 )
		{
			for( j  = 0; j < 2; j++ )
			{
				guys[j].banzai_no_wait = 1;
				guys[j] thread maps\_banzai::banzai(); 
			}
		}
	
	}
	
}



///////////////////
//
// move up chain if all enemies are killed
//
///////////////////////////////

last_trench_chain()
{
	
	// notify sent from script_notify on trigger
	level endon( "trig_past_last_trench" );

	waittill_aigroupcount( "last_trench_ai", 2 );
	
	autosave_by_name( "Pel2 last trench done" );
	
	set_color_chain( "trig_past_last_trench" );

	old_trig = getent( "trig_past_last_trench_pre", "targetname" );
	if( isdefined( old_trig ) )
	{
		old_trig delete();	
	}
	
	
}



///////////////////
//
// japanese defense around the 4 aa guns
//
///////////////////////////////

last_aa_defense()
{

	level thread last_aa_guns();
	
	// flag set on trigger
	flag_wait( "trig_last_aa_defense" );
	
	level waittill( "obj_aaguns_complete" );	
	
	autosave_by_name( "Pel2 aaguns cleared" );
	
	objective_string( 5, &"PEL2_SECURE_AABUNKER" );
	objective_position( 5, ( 2319.8, 8145.9, 126 ) );
	objective_ring( 5 );
	
	waittill_aigroupcleared( "last_bunker_ai" );
	waittill_aigroupcleared( "last_aa_ai_1" );
	waittill_aigroupcleared( "last_aa_ai_2" );
	waittill_aigroupcleared( "last_aa_ai_3" );
	waittill_aigroupcleared( "last_aa_ai_4" );
	
	level notify( "obj_airfield_complete" );	
	
	wait_network_frame();
	
	level thread last_counterattack();

}



///////////////////
//
// Pacing after the player clears the AA guns, before the counterattack
//
///////////////////////////////

pacing_vignette()
{

	flag_set( "pacing_vignette_started" );

	pacing_vignette_in_place();

	goal_node = getent( "node_end_vigenette", "targetname" );
	
	animguys = [];	
	animguys[0] = level.roebuck;
	animguys[1] = level.polonsky;
	animguys[2] = level.extra_hero;

	level.roebuck.animname = "end_vignette_roebuck";
	level.roebuck.end_node_goto = "node_end_roebuck";
	
	level.polonsky.animname = "end_vignette_polonsky";
	level.polonsky.end_node_goto = "node_end_polonsky";
	
	level.extra_hero.animname = "end_vignette_radio";
	level.extra_hero.end_node_goto = "node_end_extra_hero";
	
	anim_reach( animguys, "end_vignette", undefined, undefined, goal_node );	
	
	level thread pacing_vignette_vo();
	battlechatter_off( "allies" );
	
	level thread anim_single( animguys, "end_vignette", undefined, undefined, goal_node );

	delay = GetAnimLength( level.scr_anim["end_vignette_radio"]["end_vignette"] );
	
	wait( delay - 2.5 );
	
	flag_set( "last_counterattack_start" );
	
	battlechatter_on( "allies" );
	
	post_pacing_positions( animguys );
	
}



pacing_vignette_in_place()
{

	goal_node = getnode( "node_end_pacing_roebuck", "targetname" );
	level.roebuck thread pacing_vignette_in_place_think( goal_node, "end_pacing_roebuck" );
	goal_node = getnode( "node_end_pacing_polonsky", "targetname" );
	level.polonsky thread pacing_vignette_in_place_think( goal_node, "end_pacing_polonsky" );
	goal_node = getnode( "node_end_pacing_extra", "targetname" );
	level.extra_hero thread pacing_vignette_in_place_think( goal_node, "end_pacing_extra" );
	
	flag_wait_all( "end_pacing_roebuck", "end_pacing_polonsky", "end_pacing_extra" );
	
}



pacing_vignette_in_place_think( goal_node, flag_name )
{
	
	self.goalradius = 20;
	self setgoalnode( goal_node );
	self disable_ai_color();

	self waittill( "goal" );
	wait( 1 );
	
	flag_set( flag_name );
	
}



///////////////////
//
// this is all done with notetracks now. i'm going to leave in the wait time cuz tuey is using a notify
//
///////////////////////////////

pacing_vignette_vo()
{

	wait( 3.8 );
	wait( 7 );
	
	//for tuey
	level notify ("aw_shit");

	wait( 3.5 );
	wait( 2.8 );
	wait( 2.25 );

	battlechatter_on( "allies" );
	
}



last_counterattack_vo()
{
	
	wait( randomfloatrange( 3.0, 4.5 ) );
	
	play_vo( level.polonsky, "vo", "more_reinforcements" );
	
	
	flag_wait( "counterattack_trucks" );
	
	wait( randomfloatrange( 3.0, 4.5 ) );
	
	play_vo( level.roebuck, "vo", "infantry_on_their_trucks" );
	
	
	temp_vo_origin = spawn( "script_origin", ( 2004, 9577, -11.6 ) );
	temp_vo_origin playsound( "end_banzai" );
	
	
	flag_wait( "so_many_reinforcements" );	
	
	wait( randomfloatrange( 2.0, 3.25 ) );
	
	play_vo( level.polonsky, "vo", "where_the_hell_did" );


	flag_wait( "first_tank_on_the_scene" );

	wait( randomfloatrange( 3.1, 3.75 ) );
	
	play_vo( level.polonsky, "vo", "bringing_up_tanks" );	
	
	wait( randomfloatrange( 2.0, 3.2 ) );
	
	if( player_not_on_triple25() )
	{
		play_vo( level.roebuck, "vo", "get_on_triple25" );	
	}
	
	flag_wait( "whole_damn_convoy" );
	
	wait( randomfloatrange( 2.5, 3.5 ) );
	
	play_vo( level.polonsky, "vo", "whole_damn_convoy" );
	
	
	flag_wait( "tower_being_populated" );
	
	wait( randomfloatrange( 3.25, 4.2 ) );
	
	play_vo( level.roebuck, "vo", "positions_on_that_tower" );
	
	wait( randomfloatrange( 2.85, 3.4 ) );
	
	flag_wait( "last_tank_on_the_scene" );
	
	play_vo( level.roebuck, "vo", "keep_fire_on_them" );
	
//	wait( randomfloatrange( 3.9, 5.2 ) );
	
//	play_vo( level.roebuck, "vo", "stay_strong_we_are_holding" );
	
	
}



player_not_on_triple25()
{
	
	left_aa_gun = getent( "aaGun_2", "targetname" );
	right_aa_gun = getent( "aaGun_3", "targetname" );	
	
	
	// make sure the aa gun exists before checking its owner
	if( isdefined( right_aa_gun ) && right_aa_gun.health )
	{
		right_aa_owner = right_aa_gun GetVehicleOwner();
		
		// if the player is the owner, fire directly at the aa gun itself
		if( isdefined( right_aa_owner ) && isplayer( right_aa_owner ) )
		{	
			return false;
		}
		
	}
	
	// make sure the aa gun exists before checking its owner
	if( isdefined( left_aa_gun ) && left_aa_gun.health )
	{
		left_aa_owner = left_aa_gun GetVehicleOwner();
		
		// if the player is the owner, fire directly at the aa gun itself
		if( isdefined( left_aa_owner ) && isplayer( left_aa_owner ) )
		{	
			return false;
		}
		
	}	
	
	return true;
	
}



post_pacing_positions( anim_guys )
{

	for( i  = 0; i < anim_guys.size; i++ )
	{
		goal_node = getnode( anim_guys[i].end_node_goto, "targetname" );
		anim_guys[i].goalradius = 30;
		anim_guys[i] setgoalnode( goal_node );
	}
	
}



///////////////////
//
// final japanese counterattack on the aa bunker
//
///////////////////////////////

last_counterattack()
{

	quick_text( "pacing/vignette before napalm" );
	
	level thread pacing_vignette();
	level thread pacing_alert_guys();
	level thread end_redshirts_behavior();
	
	flag_wait( "last_counterattack_start" );

	quick_text( "counterattack!", 2, true );

	autosave_by_name( "Pel2 last counterattack" );

	level thread last_counterattack_vo();
	level thread spawn_aa_volume_trigs();

	wait( 1 );

	simple_floodspawn( "very_end_spawners", ::very_end_kill_counter );
	wait_network_frame(); // CLIENTSIDE to help snapshot size
	simple_floodspawn( "very_end_spawners_2", ::very_end_kill_counter );
	
	//////////
	wait( 5 ); // wait at least this long before checking kill count
	wait_until_this_many_end_guys_killed_or_timeout( 2, 10 );
	//////////
	
	maps\_spawner::kill_spawnernum( 512 );
	
	
	simple_floodspawn( "very_end_spawners_3", ::very_end_kill_counter );
	
	wait( RandomFloatRange( 2.0, 3.75 ) );
	
	flag_set( "counterattack_trucks" );
	
	truck = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "very_end_truck_1" );
	truck thread last_truck_strat( "node_truck_end_1_die" );
	wait_network_frame();
	truck = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "very_end_truck_2" );
	truck thread last_truck_strat( "node_truck_end_2_die" );

	level thread napalm_planes_bomb_ridge();

	//////////
	wait( 1.5 ); // wait at least this long before checking kill count
	wait_until_this_many_end_guys_killed_or_timeout( 3, 8 );
	//////////
	
	flag_set( "first_tank_on_the_scene" );

  	last_tank = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "chi_wave_4b" );
  	last_tank thread last_tank_strat( "tank_4b_godoff" );	
//	level thread tell_player_to_use_triple25();
	
	
	flag_set( "so_many_reinforcements" );
	
	simple_floodspawn( "very_end_spawners_4", ::very_end_kill_counter );	


	//////////
	wait( 5 ); // wait at least this long before checking kill count
	wait_until_this_many_end_guys_killed( 7 );
	//////////


	simple_floodspawn( "very_end_spawners_5", ::very_end_spawners_5_strat );


	//////////
	wait( 3.5 ); // wait at least this long before checking kill count
	wait_until_this_many_end_guys_killed( 9 );
	//////////


	autosave_by_name( "Pel2 last counterattack halfway" );


	flag_set( "whole_damn_convoy" );

	last_truck = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "very_end_truck_3" );
	last_truck thread last_truck_strat( "node_truck_end_3_die" );

	wait( RandomFloatRange( 2.5, 4 ) );
	
  	last_tank = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "chi_wave_4c" );
  	last_tank thread last_tank_strat( "tank_4c_godoff" );

	
	//////////
	wait( 3.5 ); // wait at least this long before checking kill count
	wait_until_this_many_end_guys_killed( 12 );
	//////////


	flag_set( "tower_being_populated" );

	level.ladder_wait_timer = 10000;

	simple_floodspawn( "outro_mg_guy", ::outro_mg_guy_strat );
	mg = getent( "end_watchtower_mg", "targetname" );
	mg setturretignoregoals( true );


	//////////
	wait_until_this_many_end_guys_killed( 14 );
	//////////


	flag_set( "last_tank_on_the_scene" );

	
	level.ladder_wait_timer = 9000;
	
	// spawn tank
  	last_tank = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "chi_wave_4" );
  	last_tank thread last_tank_strat( "tank_4_godoff" );		
  	
  	
	wait_until_this_many_end_guys_killed( 18 );
	
	
	end_of_level();
	
}



///////////////////
//
// wait until the player has killed at least the number of specified enemies
//
///////////////////////////////

wait_until_this_many_end_guys_killed( num_killed )
{
	
	while( (level.last_defend_axis_killed < num_killed) && ( get_ai_group_count( "very_end_ai" ) > 0 ) && (level.last_defend_tanks_killed < 3) )
	{
		wait( 0.5 );
	}		
	
}



wait_until_this_many_end_guys_killed_or_timeout( num_killed, wait_time )
{
	
	elapsed_time = 0;
	wait_interval = 0.5;
	
	while( (level.last_defend_axis_killed < num_killed) && ( get_ai_group_count( "very_end_ai" ) > 0 ) && (level.last_defend_tanks_killed < 3) && (elapsed_time < wait_time) )
	{
		wait( wait_interval );
		elapsed_time += wait_interval;
	}	
	
}




spawn_aa_volume_trigs()
{

	wait_network_frame();
	
	level.aa_player_trig_right = spawn( "trigger_radius", (2758.5, 8553.5, 191.5), 0, 140, 100 );
	level.aa_player_trig_right.targetname = "aa_player_trig_right";
	
	wait_network_frame();
	
	level.aa_player_trig_left = spawn( "trigger_radius", (1862.5, 8357.5, 191.5), 0, 140, 100 );
	level.aa_player_trig_left.targetname = "aa_player_trig_left";
	
}


//
//tell_player_to_use_triple25()
//{
//
//	endon here
//
//	left_aa_gun = getent( "aaGun_2", "targetname" );
//	right_aa_gun = getent( "aaGun_3", "targetname" );
//
//	left_aa_owner = left_aa_gun GetVehicleOwner();	
//
//	wait( RandomIntRange( 7, 10 ) );
//		
//}




//last_tanks_skipto_debug()
//{
//
//	// spawn tanks
//  	last_tank = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "chi_wave_4b" );
//  	last_tank thread last_tank_strat( "tank_4b_godoff" );
//  	
//  	last_tank = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "chi_wave_4c" );
//  	last_tank thread last_tank_strat( "tank_4c_godoff" );
//	
//}



end_redshirts_behavior()
{
	
	allies = getaiarray( "allies" );
	
	for( i  = 0; i < allies.size; i++ )
	{
		if( isdefined( allies[i].script_forcecolor ) && allies[i].script_forceColor == "y" )
		{
			allies[i] set_force_color( "g" );
		}
	}
	
	flag_wait( "last_counterattack_start" );
	
	set_color_chain( "chain_end_redshirts" );
	
}



outro_mg_guy_strat()
{

	self endon( "death" );
	
	self setthreatbiasgroup( "outro_mg_guy_threat" );
	
	setthreatbias( "players", "outro_mg_guy_threat", -1400 );
	
}



napalm_planes_bomb_ridge()
{

	wait( RandomIntRange( 9, 13 ) );

	plane_3 = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "napalm_plane_3" );
	plane_4 = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "napalm_plane_4" );

	plane_3 playsound( "nap_plane_b" );
	plane_4 playsound( "nap_plane_b" );

	plane_3 thread napalm_plane_3_release();
	plane_4 thread napalm_plane_4_release();
	
}



///////////////////
//
// ambient japanese guys that run behind ridge
//
///////////////////////////////

pacing_alert_guys()
{
	
	wait( 10 );
	
	simple_spawn_single( "very_end_alert_spawners", ::very_end_alert_strat );
	wait( RandomFloatRange( 0.5, 0.8 ) );
	simple_spawn_single( "very_end_alert_spawners" );
	
	wait( 4.5 );
	
	simple_spawn_single( "very_end_alert_spawners" );
	wait( RandomFloatRange( 0.5, 0.8 ) );
	simple_spawn_single( "very_end_alert_spawners" );
	wait( RandomFloatRange( 0.8, 1.2 ) );
	simple_spawn_single( "very_end_alert_spawners" );
	
	wait( 5.25 );
	
	simple_spawn_single( "very_end_alert_spawners" );
	wait( RandomFloatRange( 0.5, 0.8 ) );
	simple_spawn_single( "very_end_alert_spawners" );
	
}



very_end_alert_strat()
{

	self endon( "death" );
	
	self.ignoreme = true;
	self.ignoreall = true;
	self.ignoresuppression = true;
	self.grenadeawareness = 0;
	
	self waittill( "goal" );
	
	self delete();
	
}



very_end_spawners_5_strat()
{

	self endon( "death" );
	
	self thread very_end_kill_counter();
	
	// wait a while before even attempting to climb the ladder
	wait( RandomIntRange( 10, 17 ) );
	
	self thread ladder_climb_strat();
	
}



ladder_climb_strat()
{

	self endon( "death" );
	level endon( "napalm_incoming" );

	node_1_pre = getnode( "node_ladder_goal_right_pre", "targetname" );
	node_2_pre = getnode( "node_ladder_goal_left_pre", "targetname" );
	
	node_1 = getnode( "node_ladder_goal_right", "targetname" );
	node_2 = getnode( "node_ladder_goal_left", "targetname" );
	
	if( randomint( 2 ) )
	{

		while( !time_for_left_ladder_climb() )
		{
			wait( 0.5 );
		}	
		
		self.pel2_going_towards_ladder = true;

	
		level.last_left_ladder_climb = gettime();

		self.goalradius = 20;

		self setgoalnode( node_1_pre );
		self waittill( "goal" );
	
		self setgoalnode( node_1 );
		
	}
	else
	{

		while( !time_for_right_ladder_climb() )
		{
			wait( 0.5 );
		}	

		self.pel2_going_towards_ladder = true;

		level.last_right_ladder_climb = gettime();

		self.goalradius = 20;

		self setgoalnode( node_2_pre );
		self waittill( "goal" );
		
		self setgoalnode( node_2 );
		
	}
	
	self thread ladder_ignore_strat();
	
}



///////////////////
//
// Space out the ladder climbs so they don't happen too often
//
///////////////////////////////

time_for_left_ladder_climb()
{
	
	if( !isdefined( level.last_left_ladder_climb ) || ( gettime() - level.last_left_ladder_climb ) > level.ladder_wait_timer )
	{
		return true;
	}
	else
	{
		return false;
	}
	
}



time_for_right_ladder_climb()
{
	
	if( !isdefined( level.last_right_ladder_climb ) || ( gettime() - level.last_right_ladder_climb ) > level.ladder_wait_timer )
	{
		return true;
	}
	else
	{
		return false;
	}
	
}



ladder_ignore_strat()
{

	self endon( "death" );
	
	self.ignoreme = true;
	self.ignoreall = true;
	
	self waittill( "goal" );

	self.ignoreall = false;
	self.ignoreme = false;
	
	self.banzai_no_wait = 1;	
	self thread maps\_banzai::banzai_force();		
	
}



///////////////////
//
// count up the end enemies that the player has killed
//
///////////////////////////////

very_end_kill_counter()
{

	self waittill( "death", attacker );
	
	if( isplayer( attacker ) )
	{
		level.last_defend_axis_killed++;	
		extra_text( "last defend killed: " + level.last_defend_axis_killed );
	}		

}



///////////////////
//
// shinhotos that roll up and shoot at the aa bunker
//
///////////////////////////////

last_tank_strat( god_node )
{
	
	self endon( "death" );
	
	self thread last_tank_shoot_strat_2();
	self thread keep_tank_alive();
	level thread last_tank_deaths( self );

	vnode = getvehiclenode( god_node, "script_noteworthy" );
	vnode waittill( "trigger" );
	
	self stop_keep_tank_alive();
	self.health = 3000;	
	
	// blow up tank when napalm drops
	level waittill( "napalm_release_1" );
	
	wait( 1 );
	
	radiusdamage( self.origin, 10, self.health + 1, self.health + 1 );
	
}



last_tank_shoot_strat_2()
{

	self endon( "death" );
	
	self waittill( "reached_end_node" );
	
	self notify( "stop_current_shoot_strat" );
	
	self thread chis_fire_at_players_and_bunker();
	
}



///////////////////
//
// tanks count towards the axis death counter
//
///////////////////////////////

last_tank_deaths( tank )
{
	tank waittill( "death" );
	level.last_defend_axis_killed++;
	level.last_defend_tanks_killed++;
	
	extra_text( "last defend killed: " + level.last_defend_axis_killed );
}



last_truck_strat( death_node_name )
{

	self.rollingdeath = 1;
	//self.unload_group = "passengers";
	self.unload_group = "all";

	self thread keep_tank_alive();
	self thread deathroll_off_notify();

	vnode = getvehiclenode( death_node_name, "script_noteworthy" );
	vnode waittill( "trigger" );
	
	self stop_keep_tank_alive();
	self.health = 1800;
	
}



///////////////////
//
// Napalm and any outro stuff before level fades to black
//
///////////////////////////////

end_of_level()
{
	
	quick_text( "napalm!", 2, true );
	
	flag_set( "napalm_incoming" );
	
	level notify ("here_it_comes");
	
	maps\_spawner::kill_spawnernum( 510 );
	maps\_spawner::kill_spawnernum( 513 );
	
	level thread napalm_planes();
	level thread napalm_destruction();
	level thread napalm_reaction();
		
	wait( 14 );
	level notify( "obj_counterattack_complete" );
	wait( 5 );
	
	// Put players on god mode
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] EnableInvulnerability();
	}

	fadeover_time = 4;

	// To Be Continued...
	level.bg = NewHudElem(); 
	level.bg.x = 0; 
	level.bg.y = 0; 
	level.bg.horzAlign = "fullscreen"; 
	level.bg.vertAlign = "fullscreen"; 
	level.bg.foreground = false;
	level.bg.sort = 50;
	level.bg SetShader( "black", 640, 480 ); 
	level.bg.alpha = 0;
	level.bg FadeOverTime( fadeover_time );
	level.bg.alpha = 1; 

	wait( fadeover_time );	
	
	wait( 6 );
	
	nextmission();	
	
}



cleanupFadeoutHud()
{
	level.bg destroy();
}



///////////////////
//
// aftermath of napalm drop
//
///////////////////////////////

napalm_destruction()
{

	level waittill( "napalm_release_1" );
	
	// make them do flame deaths
	guys = get_ai_group_ai( "very_end_ai" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		// don't set flame death on ladder guys
		if( !isdefined( guys[i].pel2_going_towards_ladder ) )
		{
			guys[i].a.special = "none";
			guys[i].a.forceflamedeath = 1;
		}
	}

	trucks = get_alive_noteworthy_tanks( "very_end_truck_group" );

	for( i  = 0; i < trucks.size; i++ )
	{
		if( trucks[i].health )
		{
			radiusdamage( trucks[i].origin, 10, trucks[i].health + 1, trucks[i].health + 1 );
		}	
	}
	
	kill_aigroup( "very_end_ai" );
	
}



///////////////////
//
// Heroes react to napalm drop
//
///////////////////////////////

napalm_reaction()
{

	quick_text( "napalm reaction starts!" );

	wait( 8 );

	level thread battlechatter_off();

	level.polonsky.animname = "end_vignette";
	level.roebuck.animname = "end_vignette";
	level.extra_hero.animname = "end_vignette";
	
	level thread napalm_reaction_polonsky();
	level thread napalm_reaction_roebuck();
	level thread napalm_reaction_extra_hero();
	
}



napalm_reaction_polonsky()
{
	
	wait( RandomFloatRange( 0.5, 1.25 ) );
	
	level.polonsky setcandamage( false );
	
	goal = getnode( "node_end_reaction_polonsky", "targetname" );
	
	level.polonsky.goalradius = 16;
	level.polonsky setgoalnode( goal );
	level.polonsky waittill( "goal" );
	
	wait( 0.5 );
	
	anim_single_solo( level.polonsky, "end_vignette_polonsky_reaction", undefined, level.polonsky );
	
}



napalm_reaction_roebuck()
{
	
	wait( RandomFloatRange( 1.0, 1.5 ) );
	
	level.roebuck setcandamage( false );
	
	goal = getnode( "node_end_reaction_roebuck", "targetname" );
	
	level.roebuck.goalradius = 16;
	level.roebuck setgoalnode( goal );
	level.roebuck waittill( "goal" );	
	
	wait( 0.5 );
	
	anim_single_solo( level.roebuck, "end_vignette_roebuck_reaction", undefined, level.roebuck );
	
}



napalm_reaction_extra_hero()
{

	wait( RandomFloatRange( 0.45, 1.4 ) );

	level.extra_hero setcandamage( false );

	goal = getnode( "node_end_reaction_extra_hero", "targetname" );

	level.extra_hero.goalradius = 16;
	level.extra_hero setgoalnode( goal );
	level.extra_hero waittill( "goal" );	

	wait( 0.5 );

	anim_single_solo( level.extra_hero, "end_vignette_radio_reaction", undefined, level.extra_hero );
	
}



///////////////////
//
// Put crew on last aa guns
//
///////////////////////////////

last_aa_guns()
{

	// flag set on trigger
	flag_wait( "trig_last_aa_guys" );

	level notify( "obj_airfield_tanks_complete" );

	aaGun_1 = getent( "aaGun_1", "targetname" );
	aaGun_2 = getent( "aaGun_2", "targetname" );
	aaGun_3 = getent( "aaGun_3", "targetname" );
	aaGun_4 = getent( "aaGun_4", "targetname" );

	aaGun_1 stop_keep_tank_alive();
	aaGun_2 stop_keep_tank_alive();
	aaGun_3 stop_keep_tank_alive();
	aaGun_4 stop_keep_tank_alive();

	aaGun_1_crew = getentarray( "aaGun_1_spawners", "targetname" );
	aaGun_2_crew = getentarray( "aaGun_2_spawners", "targetname" );
	aaGun_3_crew = getentarray( "aaGun_3_spawners", "targetname" );
	aaGun_4_crew = getentarray( "aaGun_4_spawners", "targetname" );
	
	aaGun_1 thread aa_manually_add_crew( aaGun_1_crew );
	aaGun_2 thread aa_manually_add_crew( aaGun_2_crew );
	aaGun_3 thread aa_manually_add_crew( aaGun_3_crew );
	aaGun_4 thread aa_manually_add_crew( aaGun_4_crew );	
	
	level.aa_guns_cleared = 0;
	
	level thread aa_guns_cleared( aaGun_1, "last_aa_ai_1", "blocker_aaGun_1", 0 );
	level thread aa_guns_cleared( aaGun_2, "last_aa_ai_2", "blocker_aaGun_2", 1 );
	level thread aa_guns_cleared( aaGun_3, "last_aa_ai_3", "blocker_aaGun_3", 2 );
	level thread aa_guns_cleared( aaGun_4, "last_aa_ai_4", "blocker_aaGun_4", 3 );
	
	level thread make_aa_crew_ignored( aaGun_1, "last_aa_ai_1" );
	level thread make_aa_crew_ignored( aaGun_2, "last_aa_ai_2" );
	level thread make_aa_crew_ignored( aaGun_3, "last_aa_ai_3" );
	level thread make_aa_crew_ignored( aaGun_4, "last_aa_ai_4" );
	
	aaGun_1 thread make_aa_gun_team_change();
	aaGun_2 thread make_aa_gun_team_change();
	aaGun_3 thread make_aa_gun_team_change();
	aaGun_4 thread make_aa_gun_team_change();

	level thread make_aa_crew_last_longer();
	
}



make_aa_gun_team_change()
{

	self endon( "death" );
	
	level waittill( "obj_airfield_complete" );
	
	self setvehicleteam( "none" );
	
//	self.script_team = "allies";
//	self maps\_vehicle::vehicle_setteam();
	
}



///////////////////
//
// if all other axis ai are killed, make aa crews able to be targeted
//
///////////////////////////////

make_aa_crew_ignored( aaGun, ai_group )
{
	
	aaGun waittill( "pel2 triple25 crew ready" );
	
	wait( 0.05 ); // guys are spawned in, but need a frame to let aagroup_soldierthink() in _spawner track the aagroup
	
	crew = get_ai_group_ai( ai_group );
	array_thread( crew, ::make_aa_crew_ignored_think );
	array_thread( crew, ::aa_crew_half_shield );
	
}



make_aa_crew_ignored_think()
{

	self endon( "death" );
	
	self.ignoreme = true;
	
	waittill_aigroupcleared( "last_bunker_ai" );
	
	self notify( "stop_grass_half_shields" );
	self.ignoreme = false;
	self.health = self.pel2_real_health ;
	
}



last_aa_guns_objective()
{
	
	// add multiple objective stars, one for each aa gun
	aaGuns = [];
	aaGuns[0] = getent( "aaGun_1", "targetname" );
	aaGuns[1] = getent( "aaGun_2", "targetname" );
	aaGuns[2] = getent( "aaGun_3", "targetname" );
	aaGuns[3] = getent( "aaGun_4", "targetname" );
	
	for( i = 0; i < aaGuns.size; i++ )
	{
		Objective_additionalPosition( 5, i, aaGuns[i].origin );
	}		
	
}



///////////////////
//
// Clear the target of any triple25 that shouldn't have a target
//
///////////////////////////////

aa_stop_moving_turret()
{
	self waittill_any( "death", "crew dead", "change target", "crew dismount" );
	self ClearTurretTarget(); 
}



///////////////////
//
// Don't want crew spawning with guns, so spawn them manually when that event kicks off (semi-hacks)
//
///////////////////////////////

aa_manually_add_crew( aa_crew )
{

	triple25_dismount_trig = undefined;

	triple25_targets = getentarray( self.target, "targetname" );
	triple25_triggers = [];

	for( j = 0; j < triple25_targets.size; j++ )
	{
		triple25_target = triple25_targets[ j ];

		if( isdefined( triple25_target.script_noteworthy ) && triple25_target.script_noteworthy == "dismount" )
		{
			triple25_dismount_trig = triple25_target;
		}
	}

	// spawn the crew, link them up	
	for (i = 0; i < aa_crew.size; i++)
	{
		// spawn the guy in
		self.triple25_gunner[self.triple25_gunner.size] = aa_crew[i] maps\_triple25::spawn_gunner();
		self.triple25_gunner[i] linkto( self, "tag_driver"+(i+1), (0,0,0), (0,0,0) );		
		self.triple25_gunner[i].position = i;
		//call animation	
		self.triple25_gunner[i] thread maps\_triple25::monitor_gunner( self, triple25_dismount_trig );
		self.triple25_gunner[i] thread  maps\_triple25::triple25gunner_animation_think( self );
		
		self.crewsize++;
	}
	
	self notify( "pel2 triple25 crew ready" );
	
	//either dismount of AI or death of AI will unlink everyone
	if( isdefined( triple25_dismount_trig ) )
	{
		for (i = 0; i < self.crewsize; i++)
		{
			thread maps\_triple25::dismount_think( triple25_dismount_trig, self.triple25_gunner[i], self );
			thread maps\_triple25::death_think( self.triple25_gunner[i], self );
		}
	}
	
}




aa_guns_cleared( aa_gun, ai_group_name, blocker_name, obj_index )
{

	// they don't need a friendlyfire shield. otherwise the player wont' be able to hop on a triple25 and kill the other triple25s
	aa_gun notify( "stop_friendlyfire_shield" );
 	
 	aa_gun.health = 4000;
 	
 	aa_gun thread aa_stop_moving_turret();
	level thread aa_gun_available_to_use( aa_gun );
	level thread aa_gun_destroyed( aa_gun );

	flag_wait_either( aa_gun.targetname + "_cleared", aa_gun.targetname + "_destroyed" );
	
	aa_crew_active( ai_group_name );	
	
	// remove its objective star from the map
	Objective_additionalPosition( 5, obj_index, (0,0,0) );
	
	level.aa_guns_cleared++;
	aa_guns_obj_update();
	
	if( aa_gun.health )
	{
		aa_gun makevehicleusable();
	}
	
	// remove monster clip
	blocker = getent( blocker_name, "targetname" );
	blocker connectpaths();	
	blocker delete();
	
}



///////////////////
//
// if the crew has dismounted, make them able to be targeted
//
///////////////////////////////

aa_crew_active( aigroup_name )
{
	
	crew = get_ai_group_ai( aigroup_name );
	for( i  = 0; i < crew.size; i++ )
	{
		crew[i].ignoreme = false;
		crew[i] notify( "stop_grass_half_shields" );
		crew[i].health = crew[i].pel2_real_health;
		
	}
	
}



///////////////////
//
// Protect the aa guys from all damage except from the player (at least while there are non-ai defenders still around)
//
///////////////////////////////

aa_crew_half_shield()
{

	self endon( "stop_grass_half_shields" );
	self endon( "death" );
	
	self.pel2_real_health = self.health;
	self.health = 10000;
	
	attacker = undefined; 
	
	while( self.health > 0 )
	{
		
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
		
		type = tolower( type );
		
		// if it's not the player, and also a bullet weapon (non-player friendlies should still be able to kill them with their grenades)
		if( !isplayer(attacker) && issubstr( type, "bullet" ) )
		{
			//iprintln( "attacked by non-player!" );
			self.health = 10000;  // give back health for these things	
		}
		else
		{
			self.health = self.pel2_real_health;
			self dodamage( amount, (0,0,0) );
			self.pel2_real_health = self.health;
			// put ff shield back on
			self.health = 10000;
		}
	}	
	
}



//aa_crew_playerseek( ai_group_name )
//{
//
//	ai = get_ai_group_ai( "ai_group_name" );
//	
//}



///////////////////
//
// sets a flag if the aa gun crew has dismounted or has been killed
//
///////////////////////////////

aa_gun_available_to_use( aa_gun )
{
	
	aa_gun endon( "death" );
	
	aa_gun waittill_either( "crew dead", "crew dismount" );
	
//	aa_gun setvehicleteam( "none" );
	
	flag_set( aa_gun.targetname + "_cleared" );
	
}



///////////////////
//
// sets a flag if the AA gun has been destroyed
//
///////////////////////////////

aa_gun_destroyed( aa_gun )
{
	
	aa_gun waittill( "death" );
	flag_set( aa_gun.targetname + "_destroyed" );
	
	// only do a radius damage (to kill aa operators) if no player is nearby. 
	player_nearby = false;
	
	players = get_players();
	for( i  = 0; i < players.size; i++ )
	{
		if( distanceSquared( players[i].origin, aa_gun.origin ) < (150*150) )
		{
			player_nearby = true;
		}
	}
	
	if( !player_nearby )
	{
		radiusdamage( aa_gun.origin, 150, 100, 200 );
	}
	
}



///////////////////
//
// Update the objectives when the AA gun crews are cleared
//
///////////////////////////////

aa_guns_obj_update()
{

	switch( level.aa_guns_cleared )
	{
	
		case 1:
			
			objective_string( 5, &"PEL2_DESTROY_AA_GUNS_3" );
			
			// TODO make sure that none of this VO would overlap each other, such as if two crews were taken out simutaneously
			play_vo( level.polonsky, "vo", "taken_out" );
			wait( 2 );
			play_vo( level.roebuck, "vo", "three_more" );
			break;
		
		case 2:
			
			objective_string( 5, &"PEL2_DESTROY_AA_GUNS_2" );
			
			play_vo( level.polonsky, "vo", "second_crew_down" );
			wait( 2 );
			play_vo( level.roebuck, "vo", "stay_strong" );
			wait( 1.5 );
			play_vo( level.roebuck, "vo", "two_more" );
			break;			

		case 3:
			objective_string( 5, &"PEL2_DESTROY_AA_GUNS_1" );
			
			play_vo( level.roebuck, "vo", "get_the_last_one" );
			break;
			
		case 4:
			objective_string( 5, &"PEL2_DESTROY_AA_GUNS" );
			play_vo( level.polonsky, "vo", "outta_commission" );
			level notify( "obj_aaguns_complete" );
			break;			
		
	}

}



///////////////////
//
// These are the guys on the aa gun that shoots down the tower corsair. we want them to last a bit longer so the tower crash vignette
// will play out.
//
///////////////////////////////

make_aa_crew_last_longer()
{

	wait( 1 );
	
	crew = get_ai_group_ai( "last_aa_ai_1" );
	
	for( i  = 0; i < crew.size; i++ )
	{
		crew[i] thread make_aa_crew_last_longer_strat();
	}
	
	
}



make_aa_crew_last_longer_strat()
{
	
	self endon( "death" );
	
	self.ignoreme = 1;
	
	flag_wait_or_timeout( "trig_tower_plane", 12 );
	
	self.ignoreme = 0;	
	
}




///////////////////
//
// Have all the shermans point their turrets forward and stop any attackgroup behavior
//
///////////////////////////////

shermans_point_turrets_forward( tank_name )
{

	tanks = get_alive_noteworthy_tanks( tank_name );
	
	for( i  = 0; i < tanks.size; i++ )
	{
		//tanks[i] thread debugorigin();
		tanks[i] notify( "killed all targets" );
		tanks[i] thread tank_reset_turret( 3 );
	}
	
}



///////////////////
//
// Sets a flag once all wave 1a chi tanks are dead
//
///////////////////////////////

chi_1a_dead()
{

	while( 1 )
	{
	
		tanks = get_alive_noteworthy_tanks( "chi_wave_1a" );
		
		// if all are dead
		if( !tanks.size )
		{
			break;
		}
		
		wait( 1 );
		
	}
	
	flag_set( "chi_1a_wave_dead" );
	
	level thread shermans_point_turrets_forward( "sherman_wave_1" );

	level thread tank_wave_2();
	
}



///////////////////
//
// Sets a flag once all wave 1b chi tanks are dead
//
///////////////////////////////

chi_1b_dead()
{

	while( 1 )
	{
	
		tanks = get_alive_noteworthy_tanks( "chi_wave_1b" );
		
		// if all are dead
		if( !tanks.size )
		{
			break;
		}
		else if( tanks.size == 1 )
		{
			flag_set( "chi_1b_wave_almost_dead" );	
		}
		
		wait( 0.5 );
		
	}
	
	flag_set( "chi_1b_wave_dead" );
	
}



///////////////////
//
// Sets a flag once all wave 1b chi tanks are dead
//
///////////////////////////////

chi_1c_dead()
{

	while( 1 )
	{
	
		tanks = get_alive_noteworthy_tanks( "chi_wave_1c" );
		
		// if all are dead
		if( !tanks.size )
		{
			break;
		}
		
		wait( 1 );
		
	}
	
	flag_set( "chi_1c_wave_dead" );
	
}



///////////////////
//
// Sets a flag once all wave 2 chi tanks are dead
//
///////////////////////////////

chi_2_wave_dead()
{

	while( 1 )
	{
	
		tanks = get_alive_noteworthy_tanks( "chi_wave_2" );
		
		// if all are dead
		if( !tanks.size )
		{
			break;
		}
		
		wait( 1 );
		
	}
	
	flag_set( "chi_2_wave_dead" );
	
	level thread shermans_point_turrets_forward( "sherman_wave_2" );
	
}



///////////////////
//
// Sets a flag once all wave 3 chi tanks are dead
//
///////////////////////////////

chi_3_wave_dead()
{

	flag_wait( "chi_3c_spawned" );

	one_tank_dead_vo = 0;
	two_tanks_dead_vo = 0;

	while( 1 )
	{
	
		tanks = get_alive_noteworthy_tanks( "chi_wave_3" );
		
		switch( tanks.size )
		{
			
			case 2:
			
				if( !one_tank_dead_vo )
				{
					
					objective_string( 4, &"PEL2_BAZOOKA_2" );
					
					//VO "1 TANK DEAD!"
					play_vo( level.roebuck, "vo", "one_tank_down" );
					wait( 1.5 );
					play_vo( level.polonsky, "vo", "yeah!!!" );
					
					one_tank_dead_vo = 1;
				}
				
				break;
			
			case 1:
				
				if( !two_tanks_dead_vo )
				{			
					
					objective_string( 4, &"PEL2_BAZOOKA_1" );
						
					//VO "2 TANKS DEAD!"
					play_vo( level.roebuck, "vo", "keep_doing" );
					//play_vo( level.roebuck, "vo", "stay_on_it" );				
					
					two_tanks_dead_vo = 1;
				}
				
				break;	
			
			default:
			
		}
					
		// if all are dead
		if( !tanks.size )
		{
			break;
		}
		
		wait( 1 );
		
	}
	
	flag_set( "chi_3_wave_dead" );
	
	level notify( "obj_airfield_tanks_complete" );	
	
	objective_state ( 4, "done" );
	objective_string( 4, &"PEL2_BAZOOKA" );
	
	// save if player hasn't moved up too far to next checkpoint
	if( !flag( "trig_last_aa_defense" ) )
	{
		 //VO "ALL TANKS DEAD!"
		play_vo( level.roebuck, "vo", "damn_good_work" );
		autosave_by_name( "Pel2 tanks destroyed" );
	}

	// if haven't moved up really far, turn middle chain back on (flag is set on trigger)
	if( !flag( "chain_airfield_end_c" ) )
	{
		set_color_chain( "chain_airfield_end_b" );
	}
	
}



///////////////////
//
// Sets a flag once all wave 1 sherman tanks are dead
//
///////////////////////////////

shermans_1_dead()
{

	while( 1 )
	{
	
		tanks = get_alive_noteworthy_tanks( "sherman_wave_1" );
		
		// if all are dead
		if( !tanks.size )
		{
			break;
		}
		
		wait( 1 );
		
	}
	
	quick_text( "shermans_1_dead", 3, true );
	flag_set( "shermans_1_dead" );
	
}



///////////////////
//
// Sets a flag once all wave 2 sherman tanks are dead
//
///////////////////////////////

shermans_2_dead()
{

	while( 1 )
	{
	
		tanks = get_alive_noteworthy_tanks( "sherman_wave_2" );
		
		// if all are dead
		if( !tanks.size )
		{
			break;
		}
		
		wait( 1 );
		
	}
	
	quick_text( "shermans_2_dead", 3, true );
	flag_set( "shermans_2_dead" );
	
}



///////////////////
//
// Sets a flag once all wave 3 sherman tanks are dead
//
///////////////////////////////

shermans_3_dead()
{

	while( 1 )
	{
	
		tanks = get_alive_noteworthy_tanks( "sherman_wave_3" );
		
		// if all are dead
		if( !tanks.size )
		{
			break;
		}
		
		wait( 1 );
		
	}
	
	quick_text( "shermans_3_dead", 3, true );
	flag_set( "shermans_3_dead" );
	
}



///////////////////
//
// Sets a flag once all wave 3b sherman tanks are dead
//
///////////////////////////////

shermans_3b_dead()
{

	while( 1 )
	{
	
		tanks = get_alive_noteworthy_tanks( "sherman_wave_3b" );
		
		// if all are dead
		if( !tanks.size )
		{
			break;
		}
		
		wait( 1 );
		
	}
	
	quick_text( "shermans_3b_dead", 3, true );
	flag_set( "shermans_3b_dead" );
	
}



///////////////////
//
// sets a tank's fire_delay_min and max, which are used by attackgroup behavior in _vehicle
//
///////////////////////////////

set_attack_delay( min, max )
{

	if( !IsDefined( min ) )
	{
		min = 5;			
	}
	if( !IsDefined( max ) )
	{
		max = 6;			
	}
	

	self.fire_delay_min = min;
	self.fire_delay_max = max;
	
}



///////////////////
//
// The center area with the 2nd triple25 gun
//
///////////////////////////////

at_cinch_point()
{

	// flag set on trigger
	flag_wait( "at_cinch_point" );
	
	level notify( "obj_assault_airfield_complete" );
	
	quick_text( "at_cinch_point", 3, true );
	
	level thread bazooka_respawn();
	level thread plane_strafe();
	level thread color_chains_near_tanks();
	level thread tighten_up_color_chains();
	level thread spawn_pre_last_trench_guys();
	level thread save_when_near_aa_bunker();

	// Wii optimizations and coop optimizations
	if( !level.wii && !NumRemoteClients())
	{
		while(!oktospawn())				// Try to smooth out the big spikes around here.
		{
			wait_network_frame();
		}		
		
		simple_spawn( "airfield_rush_mid_spawners", ::airfield_rush_mid_strat );
		level thread rush_guys_die();
	}

}



///////////////////
//
// objective stars that follow the 3 objective tanks
//
///////////////////////////////

objective_stars_on_tanks()
{

	level endon( "obj_airfield_tanks_complete" );

//	while ( 1 )
//	{
		
		tanks = get_alive_noteworthy_tanks( "chi_wave_3" );

		while(!oktospawn())
		{
			wait(0.1);			// Try to keep the network bandwidth sane.
		}
		
		for( i  = 0; i < tanks.size; i++ )
		{
//			Objective_additionalPosition( 4, tanks[i].pel2_objective_index, tanks[i].origin );
			Objective_additionalPosition( 4, tanks[i].pel2_objective_index, tanks[i]);
		}
		
//		wait( 0.35 );
//		
//	}	
	
}



///////////////////
//
// piggybacking this onto a friendly_respawn trig to save an ent
//
///////////////////////////////

spawn_pre_last_trench_guys()
{

	trigger_wait( "trig_pre_last_trench_guys", "script_noteworthy" );
	simple_floodspawn( "pre_last_trench_guys" );
}



///////////////////
//
// guys that rush out near the cinch point, but get blown up by a stray mortar
//
///////////////////////////////

airfield_rush_mid_strat()
{

	self endon( "death" );
	
	self setcandamage( false );
	self.ignoreme = true;
	self.ignoresuppression = true;
	
	self waittill( "goal" );
	
	self setcandamage( true );
	self.ignoreme = false;
	self.ignoresuppression = true;
	
	flag_set( "airfield_rush_inplace" );
	
	self.animname = "stand";
	
	// choose his death anim because the mortar explosion is about to play
	if( self.target == "auto5218" )
	{
		if( RandomInt( 2 ) )
		{
			self.deathanim = level.scr_anim["stand"]["explosion_forward"];
		}
		else
		{
			self.deathanim = level.scr_anim["stand"]["explosion_right"];
		}
	}
	else
	{
		if( RandomInt( 2 ) )
		{
			self.deathanim = level.scr_anim["stand"]["explosion_forward"];
		}
		else
		{
			self.deathanim = level.scr_anim["stand"]["explosion_left"];
		}
	}
	
}



///////////////////
//
// stray mortar that kills rush guys
//
///////////////////////////////
rush_guys_die()
{

	flag_wait( "airfield_rush_inplace" );

	wait( RandomFloatRange( 1.2, 2.5 ) );

	level thread maps\_mortar::mortar_loop( "orig_mortar_airfield_canned" );
	
	kill_aigroup( "airfield_rush_ai" );
	
	wait( 0.1 );
	level notify( "stop_mortar_airfield_canned" );
	
}



///////////////////
//
// manipulate color chain triggers for chain advancing during tank killing
//
///////////////////////////////

color_chains_near_tanks()
{
	
	trig = getent( "chain_airfield_end_a", "targetname" );
	trig trigger_off();

}



///////////////////
//
// infinite respawn bazooka for player to use at the cinch point
//
///////////////////////////////

bazooka_respawn()
{

	respawn_schrek = getent( "airfield_bazooka", "targetname" );	
	respawn_origin = respawn_schrek.origin;
	respawn_angles = respawn_schrek.angles;

	while(!oktospawn())
	{
		wait(0.1);			// Try to keep the network bandwidth sane.
	}


	// glowy model
	glowy_model = spawn( "script_model", respawn_origin );
	glowy_model.angles = respawn_angles;
	glowy_model SetModel( "weapon_usa_bazooka_at_obj" );

	level thread player_has_bazooka();

	while( 1 )
	{
	
		if( !isdefined( respawn_schrek ) )
		{
			// remove glowy model once the bazooka is picked up
			if( isdefined( glowy_model ) )
			{
				glowy_model delete();	
			}
			
			while(!oktospawn())
			{
				wait(0.1);			// Try to keep the network bandwidth sane.
			}
			
			respawn_schrek = spawn( "weapon_bazooka", respawn_origin, 1 );
			respawn_schrek.angles = respawn_angles;	
			
			wait( 2 );
			
		}	
	
		wait( 1 );
		
	}

}



player_has_bazooka()
{

	// wait till a guy gets the flamethrower
	while( !flag( "player_got_bazooka" ) )
	{
		
		players = get_players();
		for( i  = 0; i < players.size; i++ )
		{
			if( players[i] HasWeapon( "bazooka" ) )
			{
				flag_set( "player_got_bazooka" );
				
				objective_string( 4, &"PEL2_BAZOOKA_3" );
				Objective_additionalPosition( 4, 3, (0,0,0) );
				
				level thread objective_stars_on_tanks();
				
				break;
			}
			
		}
		
		wait( 0.15 );
		
	}
	
}



///////////////////
//
// remind player to pick up the bazooka if he doesn't have it
//
///////////////////////////////

player_get_bazooka_reminder()
{

	level endon( "obj_airfield_tanks_complete" );

	wait( RandomIntRange( 10, 12 ) );

	// give VO support on what to do
	while( !flag( "player_got_bazooka" ) )
	{
		
		allies = getaiarray( "allies" );
		redshirt = get_closest_exclude( get_players()[0].origin, allies, level.heroes );
		
		random_int = randomint( 100 );
		// choose which VO variation to play
		if( random_int > 75 )
		{
			play_vo( redshirt, "vo", "find_a_bazooka" );
		}
		else if( random_int > 50 )
		{
			play_vo( redshirt, "vo", "bazooka_from_the_trenches" );
		}
		else if( random_int > 25 )
		{
			play_vo( redshirt, "vo", "bazooka_those_tanks" );
			
		}
		else
		{
			play_vo( redshirt, "vo", "cmon_bazooka_tanks" );
		}
		
//		objective_ring( 4 );
		wait( RandomIntRange( 10, 15 ) );
		
	}	
	
}



///////////////////
//
// Handles anything associated with tank wave 1
//
///////////////////////////////

tank_wave_1()
{
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 1 );
	
	wait_network_frame();
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 700 );

	wait_network_frame();

	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 604 );	
	
	wait_network_frame();
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 603 );
	
	wait_network_frame();

	// turn off annoying mgs on these tanks
	chi_tanks = get_alive_noteworthy_tanks( "chi_wave_1a" );
	array_thread( chi_tanks, maps\_vehicle::mgoff );
	chi_tanks = get_alive_noteworthy_tanks( "chi_wave_1b" );
	array_thread( chi_tanks, maps\_vehicle::mgoff );
	chi_tanks = get_alive_noteworthy_tanks( "chi_wave_1c" );
	array_thread( chi_tanks, maps\_vehicle::mgoff );

	level thread chi_1a_dead();	
	level thread chi_1b_dead();
	level thread chi_1c_dead();
	level thread truck_crash();
	level thread shermans_1_dead();
	level thread tank_wave_1_strats();
	
}



///////////////////
//
// Handles anything associated with tank wave 2. this happens when all chi_1a_wave are dead
//
///////////////////////////////

tank_wave_2()
{
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 2 );
	
	wait_network_frame();
	
	flag_set( "tank_spawn_n_move_2" );
	quick_text( "tank_spawn_n_move_2", 3, true );

	sherman_2a = getent( "sherman_wave_2a", "targetname" );
	sherman_2a thread sherman_2a_strat();
	sherman_2b = getent( "sherman_wave_2b", "targetname" );
	sherman_2b thread sherman_2b_strat();

	level thread shermans_2_dead();

	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 606 );
	
	wait_network_frame();
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 605 );
	
	wait( 0.05 );
	
	chi_3c = getent( "chi_wave_3c", "targetname" );
	chi_3c thread chi_3c_strat();

	// possibly redo how chi3 is spawned separately from rest of wave 3
	flag_set( "chi_3c_spawned" );

	sherman_wave_3a = getent( "sherman_wave_3a", "targetname" );
	sherman_wave_3a thread sherman_3a_strat();
	
	sherman_wave_3b = getent( "sherman_wave_3b", "targetname" );
	sherman_wave_3b thread sherman_3b_strat();			
		
	level thread shermans_3_dead();
	level thread shermans_3b_dead();


}



///////////////////
//
// Handles anything associated with tank wave 3
//
///////////////////////////////

tank_wave_3()
{

	flag_wait( "move_wave_2_3" );

	quick_text( "move_wave_2_3", 3, true );

	level thread bazooka_respawner();

	wait_network_frame();

	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 3 );
	
	wait( 0.05 );
	
	chi_3a = getent( "chi_wave_3a", "targetname" );
	chi_3a thread chi_3a_strat();
	
	chi_3b = getent( "chi_wave_3b", "targetname" );
	chi_3b thread chi_3b_strat();
	
	level thread chi_3_wave_dead();
	level thread chi_3_kill_shermans_2();
	
}



chi_3_kill_shermans_2()
{

	// wait till sherman wave 1 is dead
	flag_wait( "shermans_1_dead" );
	
	chi_wave_3 = get_alive_noteworthy_tanks( "chi_wave_3" );
	for( i  = 0; i < chi_wave_3.size; i++ )
	{
		chi_wave_3[i] thread attack_this_group( 2 );
	}
	
}



///////////////////
//
// Lets wave 1 tanks know when to stop
//
///////////////////////////////

tank_wave_1_strats()
{

	sherman_1a = getent( "sherman_wave_1a", "targetname" );
	sherman_1b = getent( "sherman_wave_1b", "targetname" );

	sherman_1a thread sherman_1a_strat();
	sherman_1b thread sherman_1b_strat();
	
	chi_wave_1a = getent( "chi_wave_1a", "targetname" );
	chi_wave_1c = getent( "chi_wave_1c", "targetname" );
	chi_wave_1d = getent( "chi_wave_1d", "targetname" );
	chi_wave_1e = getent( "chi_wave_1e", "targetname" );
	chi_wave_1f = getent( "chi_wave_1f", "targetname" );
	chi_wave_1g = getent( "chi_wave_1g", "targetname" );

	chi_wave_1a thread chi_1a_strat();
	chi_wave_1c thread chi_1c_strat();	
	chi_wave_1d thread chi_1d_strat();	
	chi_wave_1e thread chi_1e_strat();	
	chi_wave_1f thread chi_1f_strat();	
	chi_wave_1g thread chi_1g_strat();	
	
}



///////////////////
//
// Behavior for tanks
//
///////////////////////////////

sherman_1a_strat()
{
	
	self thread keep_tank_alive();
	self set_attack_delay( 4, 6 );
	self thread tank_smoke_death();
	self.rollingdeath = 1;
	
	self thread sherman_1a_shoot_strat();
	
	self endon( "death" );
	
	self veh_stop_at_node( "sherman_1a_backup", 6, 6 );
	
	flag_wait( "chi_1a_wave_dead" );

	self resumespeed( 5, 3, 3 );

	//vnode = getvehiclenode( "sherman_1a_stop_shield", "script_noteworthy" );
	//vnode waittill( "trigger" );

	flag_set( "sherman_1a_vulnerable" );	

	// turn off its shield
	self stop_keep_tank_alive();
	self.health = 500;
	
}



sherman_1a_shoot_strat()
{

	self endon( "death" );
	
	//orig = getstruct( "orig_truck_near_hit", "targetname" );
	self setturrettargetvec( (2668, 1655.5, 9.3) );
	
	wait( 4.5 );
	
	flag_set( "truck_hit_by_shell" );
	
	self ClearTurretTarget(); 	
		
	self attack_this_tank( "chi_wave_1a", 2, 2.75, 3.5 );
	
	wait( 3 );
	
	self attack_this_tank( "chi_wave_1c", 2, 2.5, 3.0 );

}
	


///////////////////
//
// Behavior for tanks
//
///////////////////////////////

sherman_1b_strat()
{
	
	self set_attack_delay( 4, 6 );
	self thread keep_tank_alive();
	self thread tank_smoke_death();
	self.rollingdeath = 1;
	
	self endon( "death" );

	self thread sherman_1b_shoot_strat();
	
	vnode = getvehiclenode( "shermans_1_b_stop_shield", "script_noteworthy" );
	vnode waittill( "trigger" );

	// turn off its shield
	self stop_keep_tank_alive();
	self.health = 500;

}



sherman_1b_shoot_strat()
{

	self endon( "death" );

	truck = getent( "airfield_type94", "targetname" );
	self setturrettargetent( truck );
	
	self waittill( "turret_on_target" ); 		
	wait( 3.5 );
	self ClearTurretTarget(); 
	
	self fireweapon();

	self tank_reset_turret();
	
}



move_wave_2_2()
{

	flag_wait_either( "move_wave_2_2", "node_sherman_2a_wait_2" );
	quick_text( "move_wave_2_2", 3, true );
	
	guys = get_ai_group_ai( "airfield_truck_ai" );
	
	// assume tanks kill them
	for( i = 0; i < guys.size; i++ )
	{
		guys[i] thread bloody_death( true, 3 );
	}
	
	// wait a little longer for this guy; he's further back
	wait( 3 );
	
	guys = get_ai_group_ai( "airfield_truck_ai_2" );
	
	// assume tanks kill them
	for( i = 0; i < guys.size; i++ )
	{
		guys[i] thread bloody_death( true, 1 );
	}	
	
}



sherman_2a_strat()
{
	
	self thread keep_tank_alive();
	self thread tank_smoke_death();
	self.rollingdeath = 1;	
	self thread sherman_2a_shoot_strat();
	
	self veh_stop_at_node( "node_sherman_2a_wait_1", 6, 6 );
	
	flag_wait( "chi_1b_wave_dead" );
	
	self thread tank_reset_turret();	
	self resumespeed( 5, 3, 3 );

	self veh_stop_at_node( "node_sherman_2a_wait_2", 6, 6 );
	
	flag_set( "node_sherman_2a_wait_2" );
	
	self thread shermans_fire_towards_bunkers();
	
	flag_wait( "move_wave_2_2" );
	
	self notify( "stop_sherman_bunker_shooting" );
	wait( 0.05 );
	
	self resumespeed( 2, 1, 1 );	
	
	self veh_stop_at_node( "node_sherman_2a_wait_3", 6, 6 );	
	
	self thread shermans_fire_towards_bunkers();
	
	flag_wait( "move_wave_2_3" );
	
	level notify( "stop_sherman_bunker_shooting" );
	wait( 0.05 );
	
	self resumespeed( 2, 1, 1 );	
	
	self set_attack_delay();
	self thread attack_this_group( 604 );	
	
	self stop_keep_tank_alive();	
	self.health = 500;
	
}





sherman_2a_shoot_strat()
{

	wait( 3 );
	
	self thread attack_this_tank( "chi_wave_1e", 2 );
	
	flag_wait( "chi_1b_wave_almost_dead" );	
	
	self thread attack_this_tank( "chi_wave_1d", 2 );
	
}




sherman_2b_strat()
{
	
	self thread keep_tank_alive();
	self thread tank_smoke_death();
	self.rollingdeath = 1;		
	self thread sherman_2b_shoot_strat();
	
	self veh_stop_at_node( "node_sherman_2b_wait_1", 6, 6 );
	
	flag_wait( "chi_1b_wave_dead" );
	
	self thread tank_reset_turret();
	self resumespeed( 5, 3, 3 );
	
	self veh_stop_at_node( "node_sherman_2b_wait_2", 6, 6 );
	
	self thread shermans_fire_towards_bunkers();
	
	flag_wait( "move_wave_2_2" );
	
	self notify( "stop_sherman_bunker_shooting" );
	wait( 0.05 );
	
	self resumespeed( 2, 1, 1 );	
	
	self veh_stop_at_node( "node_sherman_2b_wait_3", 6, 6 );
	
	self thread shermans_fire_towards_bunkers();
	
	flag_wait( "move_wave_2_3" );
	
	level notify( "stop_sherman_bunker_shooting" );
	
	self resumespeed( 2, 1, 1 );
	
	self set_attack_delay();
	self thread attack_this_group( 604 );		
	
	vnode = getvehiclenode( "node_sherman_2b_stop_shield", "script_noteworthy" );
	vnode waittill( "trigger" );
	
	self stop_keep_tank_alive();	
	self.health = 500;

}



sherman_2b_shoot_strat()
{

	wait( 3 );
	
	self thread attack_this_tank( "chi_wave_1e", 2 );
	
	flag_wait( "chi_1b_wave_almost_dead" );	
	
	self thread attack_this_tank( "chi_wave_1d", 2 );
	
}



sherman_3a_strat()
{
	
	self thread keep_tank_alive();
	self set_attack_delay();
	self thread tank_smoke_death();
	self.rollingdeath = 1;			

	self veh_stop_at_node( "node_sherman_3a_wait_1", 6, 6 );
	
	flag_wait( "chi_1b_wave_dead" );
	
	wait( RandomFloatRange( 0.3, 0.6 ) );
	
	self resumespeed( 5, 2, 2 );

	self veh_stop_at_node( "node_sherman_3a_wait_2", 6, 6 );
	
	flag_wait( "move_wave_2_2" );
	
	self resumespeed( 5, 2, 2 );
	self veh_stop_at_node( "node_sherman_3a_wait_3", 6, 6 );
	
	flag_wait( "move_wave_2_3" );
	
	self resumespeed( 5, 3, 3 );
	
	self thread attack_this_tank( "chi_wave_1g", 2 );
	
	flag_wait( "chi_1c_wave_dead" );

	self resumespeed( 5, 3, 3 );

	self stop_keep_tank_alive();	
	self.health = 500;

	self endon( "death" );
	
	self thread shermans_fire_towards_bunkers();

}



sherman_3b_strat()
{
	
	self thread keep_tank_alive();
	self thread tank_smoke_death();
	self.rollingdeath = 1;			

	self veh_stop_at_node( "node_sherman_3b_wait_1", 6, 6 );
	
	flag_wait( "chi_1b_wave_dead" );
	
	wait( RandomFloatRange( 0.3, 0.6 ) );
	
	self resumespeed( 5, 2, 2 );
	
	self veh_stop_at_node( "node_sherman_3b_wait_2", 6, 6 );

	flag_wait( "move_wave_2_2" );
	
	self resumespeed( 5, 2, 2 );
	self veh_stop_at_node( "node_sherman_3b_wait_3", 6, 6 );
	
	flag_wait( "move_wave_2_3" );
	
	self resumespeed( 5, 3, 3 );

	self thread attack_this_tank( "chi_wave_1f", 2 );

	flag_wait( "chi_1c_wave_dead" );	

	self stop_keep_tank_alive();	
	self.health = 500;
	
	self endon( "death" );
	
	self thread shermans_fire_towards_bunkers();
	
}



chi_1a_strat()
{
	
	self thread keep_tank_alive();
	self set_attack_delay();
	self thread tank_smoke_death();
	self.rollingdeath = 1;
	self notify( "stop_vehicle_compasshandle" );
	
	vnode = getvehiclenode( "chi_wave_1_a_stop_shield", "script_noteworthy" );
	vnode waittill( "trigger" );
	
	self stop_keep_tank_alive();
	self.health = 1000;
	
}



chi_1c_strat()
{

	self thread keep_tank_alive();
	self set_attack_delay();
	self thread tank_smoke_death();
	self.rollingdeath = 1;
	self notify( "stop_vehicle_compasshandle" );

	vnode = getvehiclenode( "chi_wave_1_c_stop_shield", "script_noteworthy" );
	vnode waittill( "trigger" );
	
	self stop_keep_tank_alive();
	self.health = 1000;
	
}


chi_1d_strat()
{

	//self thread keep_tank_alive();
	self thread tank_smoke_death();
	self thread chi_1d_shoot_strat();
	self notify( "stop_friendlyfire_shield" );
	self.health = 1500;
	self.rollingdeath = 1;
	self notify( "stop_vehicle_compasshandle" );

	self veh_stop_at_node( "chi_wave_1d_stop_1", 6, 6 );
	
	flag_wait( "shermans_1_dead" );	

	//self stop_keep_tank_alive();
	//self.health = 1000;
	
	self resumespeed( 5, 3, 3 );
	
}
	

chi_1d_shoot_strat()
{

	self endon( "death" );

	vnode = getvehiclenode( "chi_wave_1d_fire", "script_noteworthy" );
	vnode waittill( "trigger" );
	
	self thread attack_this_tank( "sherman_wave_1a", 2 );
	
}


chi_1e_strat()
{

	self thread tank_smoke_death();
	self thread chi_1e_shoot_strat();
	self notify( "stop_friendlyfire_shield" );
	self.health = 1500;
	self.rollingdeath = 1;
	self notify( "stop_vehicle_compasshandle" );

	self veh_stop_at_node( "chi_wave_1e_stop_1", 12, 12 );
	
	flag_wait( "shermans_1_dead" );	

	self resumespeed( 5, 3, 3 );
	
}



chi_1e_shoot_strat()
{

	self endon( "death" );

	vnode = getvehiclenode( "chi_wave_1e_fire", "script_noteworthy" );
	vnode waittill( "trigger" );
	
	self thread attack_this_tank( "sherman_wave_1a", 2 );
	
}



chi_1f_strat()
{

	self thread keep_tank_alive();
	self thread tank_smoke_death();	
	self.rollingdeath = 1;
	self notify( "stop_vehicle_compasshandle" );
	
	self veh_stop_at_node( "chi_wave_1f_stop_1", 6, 6 );
	
	// 2nd flag set on trigger
	flag_wait_either( "shermans_1_dead", "player_near_retreat_tanks" );	

	self resumespeed( 5, 3, 3 );

	self veh_stop_at_node( "chi_wave_1f_stop_2", 6, 6 );

	flag_wait( "move_wave_2_3" );
	
	self resumespeed( 5, 3, 3 );

	self set_attack_delay();
	self thread attack_this_group( 2 );	

	vnode = getvehiclenode( "chi_wave_1f_stop_shield", "script_noteworthy" );
	vnode waittill( "trigger" );

	self stop_keep_tank_alive();
	self.health = 500;
	
}



chi_1g_strat()
{
	
	self thread keep_tank_alive();
	self thread tank_smoke_death();
	self.rollingdeath = 1;
	self notify( "stop_vehicle_compasshandle" );

	self veh_stop_at_node( "chi_wave_1g_stop_1", 6, 6 );
	
	flag_wait_either( "shermans_1_dead", "player_near_retreat_tanks" );	

	self resumespeed( 5, 3, 3 );

	self veh_stop_at_node( "chi_wave_1g_stop_2", 6, 6 );

	flag_wait( "move_wave_2_3" );

	self resumespeed( 5, 3, 3 );

	self set_attack_delay();
	self thread attack_this_group( 2 );		

	vnode = getvehiclenode( "chi_wave_1g_stop_shield", "script_noteworthy" );
	vnode waittill( "trigger" );

	self stop_keep_tank_alive();
	self.health = 500;
	
}



shermans_fire_towards_bunkers()
{

	self endon( "death" );
	level endon( "stop_sherman_bunker_shooting" );

	targs = [];
	targs[0] = getstruct( "orig_sherman_targ_1", "targetname" );
	targs[1] = getstruct( "orig_sherman_targ_2", "targetname" );
	targs[2] = getstruct( "orig_sherman_targ_3", "targetname" );
	
	wait( 4 );
	
	// fire off into distance
	while( 1 )
	{
		self tank_fire_at_struct( targs[RandomInt(targs.size)] );
		wait( RandomIntRange( 3, 5 ) );
	}

}



chi_3a_strat()
{

	self thread keep_tank_alive();
	self thread tank_smoke_death();
	self thread chi_3a_death();
	self thread chi_wave_3_shoot_strat();

	self.pel2_objective_index = 0;

	self.invulnerable_against_these_ents = [];
	self.invulnerable_against_these_ents[0] = getent( "sherman_wave_2a", "targetname" );
	self.invulnerable_against_these_ents[1] = getent( "sherman_wave_2b", "targetname" );
	self.invulnerable_against_these_ents[2] = getent( "sherman_wave_3a", "targetname" );
	self.invulnerable_against_these_ents[3] = getent( "sherman_wave_3b", "targetname" );

	source_node = getvehiclenode ( "chi_wave_3a_avoid_1", "script_noteworthy" );
	dest_node = getvehiclenode( "chi_wave_3a_avoid_2", "script_noteworthy" );
	self setswitchnode( source_node, dest_node );	
	
	// wait till we're at the beginning of the spline loop
	self setwaitnode( dest_node );
	self waittill( "reached_wait_node" );	
	self stop_keep_tank_alive();
	self.health = 1500;
	self thread pel2_friendly_fire_shield();
	
	self endon( "death" );

	// don't know why, but this wait has to be here or else the next "reached_wait_node" will never be hit. 
	// maybe something to do with setswitchnode() or setwaitnode()?
	wait( 0.05 );	

	// have tank patrol
	while( 1 )
	{
		
		source_node = getvehiclenode ( "chi_wave_3a_avoid_3", "script_noteworthy" );
		dest_node = getvehiclenode( "chi_wave_3a_avoid_4", "script_noteworthy" );
		self setswitchnode( source_node, dest_node );		
		
		//pause_node = getvehiclenode( "chi_wave_3a_pause_1", "script_noteworthy" );
  		self setwaitnode( dest_node );
  		self waittill( "reached_wait_node" );	


		wait( 0.05 );
		
		source_node = getvehiclenode ( "chi_wave_3a_avoid_5", "script_noteworthy" );
		dest_node = getvehiclenode( "chi_wave_3a_avoid_2", "script_noteworthy" );
		self setswitchnode( source_node, dest_node );	
		
		//pause_node = getvehiclenode( "chi_wave_3a_pause_2", "script_noteworthy" );
  		self setwaitnode( dest_node );
  		self waittill( "reached_wait_node" );				
		
		wait( 0.05 );	
		
	}	
	
}


chi_3a_death()
{

	level endon( "chi_3_wave_dead" );

	self waittill( "death" );
	
	flag_set( "chi_3a_death" );
	
	Objective_additionalPosition( 4, self.pel2_objective_index, (0,0,0) );
	
	// if the other tanks are still alive, move up color chain (unless the player hit the far-ahead chain "chain_airfield_end_c" )
	if( !flag( "chi_3_wave_dead" ) && !flag( "chain_airfield_end_c" ) )
	{
		set_color_chain( "chain_airfield_3" );
	}
	
}



chi_3b_death()
{

	level endon( "chi_3_wave_dead" );

	self waittill( "death" );
	
	flag_set( "chi_3b_death" );
	
	Objective_additionalPosition( 4, self.pel2_objective_index, (0,0,0) );
	
	// only trigger this chain if further chains havent been triggered and chi_3a has been killed
	if( !flag( "chi_3_wave_dead" ) && flag( "chi_3a_death" ) && !flag( "chain_airfield_end_c" ) )
	{
		set_color_chain( "chain_airfield_4" );
	}
	
}



chi_wave_3_shoot_strat()
{

	self endon( "death" );

	flag_wait( "shermans_2_dead" );
	
	self set_attack_delay( 4, 5 );
	
	self thread attack_this_group( 605 );
	
	flag_wait( "shermans_3_dead" );
	
	self thread chis_fire_at_players();
	
}



chis_fire_towards_shermans()
{

	self endon( "death" );
	level endon( "stop_chi_wave_3_shooting" );

	targs = [];
	targs[0] = getstruct( "orig_chi_targ_1", "targetname" );
	targs[1] = getstruct( "orig_chi_targ_2", "targetname" );
	targs[2] = getstruct( "orig_chi_targ_3", "targetname" );
	
	// fire off into distance
	while( 1 )
	{

		self tank_fire_at_struct( targs[RandomInt(targs.size)] );
		wait( RandomIntRange( 3, 5 ) );
		
	}
	
}



///////////////////
//
// Objective tanks fire at players
//
///////////////////////////////

// TODO this should check to fire at nearest player, not just a random one

chis_fire_at_players()
{

	self endon( "death" );
	
	while( 1 )
	{

		// get the nearest player
		targetted_player = get_closest_player( self.origin );
		current_dist = distance( targetted_player.origin, self.origin );
		
		// don't attempt to fire if he's too close; just choose a random player instead
		if ( current_dist < 150 )
		{
//			wait( RandomIntRange( 2, 4 ) );
//			continue;
			players = get_players();
			targetted_player = players[RandomInt(players.size)];

		}
		
		// actually target the player
		self setturrettargetent( targetted_player );
		
		self waittill_notify_or_timeout( "turret_on_target", 4 ); 		
		self ClearTurretTarget(); 
		
		
		// if the player is far ahead and hasn't killed any tanks yet, make them quicker at firing
		// (the origin[1] check is in case the player tries to go back for the bazooka; in this case, ease up the fire a bit
		if( flag( "trig_airfield_last_trench" ) && (get_alive_noteworthy_tanks( "chi_wave_3" ).size >= 3) && targetted_player.origin[1] > 4800 )
		{
			wait( 0.35 );
		}
		else if( flag( "trig_airfield_last_trench" ) && (get_alive_noteworthy_tanks( "chi_wave_3" ).size >= 2) && targetted_player.origin[1] > 4800 )
		{
			wait( 0.35 + RandomFloatRange( 0.05, 0.45 ) );
		}		
		else
		{
			wait( 0.35 + RandomFloatRange( 0.05, 0.8 ) ); // some extra time for player to flee
		}
		
		// check that the player the tank is aiming at is still alive
		if( !IsAlive( targetted_player ) || !IsDefined( targetted_player ) )
		{
			continue;	
		}
		
		// don't fire if can't see player (though randomly fire once even if it can't see him still)
		if( !tank_can_see_ent( targetted_player, self  ) && !RandomInt( 3 ) )
		{
			continue;	
		}
		
		self fireweapon();

		wait( RandomIntRange( 3, 5 ) );
		
	}	
	
}



///////////////////
//
// end tanks fire at players and bunker
//
///////////////////////////////

chis_fire_at_players_and_bunker()
{
	
	self endon( "death" );

	targs = getstructarray( "orig_last_tank_targ", "targetname" );
	
	left_aa_gun = getent( "aaGun_2", "targetname" );
	right_aa_gun = getent( "aaGun_3", "targetname" );
	
	left_mg = getent( "left_aa_bunker_mg", "targetname" );
	right_mg = getent( "right_aa_bunker_mg", "targetname" );	
	
	while( 1 )
	{

		// find out if the player is on the aa platform
		player_touching_left_trig = get_player_touching( level.aa_player_trig_left );
		player_touching_right_trig = get_player_touching( level.aa_player_trig_right );
		left_turret_owner = left_mg getturretowner();
		right_turret_owner = right_mg getturretowner();
		
		// fire at him if he's on the left platform
		if( isdefined( player_touching_left_trig ) )
		{

			
			// make sure the aa gun exists before checking its owner
			if( isdefined( left_aa_gun ) && left_aa_gun.health )
			{
				left_aa_owner = left_aa_gun GetVehicleOwner();
				
				// if the player is the owner, fire directly at the aa gun itself
				if( isdefined( left_aa_owner ) )
				{
					
					quick_text( "preparing to fire on left aa gun" );
					
					// if the player leaves the gun, continue the while loop and get a new target
					if( !check_player_on_aa_gun_still( left_aa_owner, left_aa_gun ) )
					{
						continue;	
					}
					
					quick_text( "player on left aa gun being fired at now!" );
					
					self setturrettargetent( left_aa_gun, (0,0,15) );
					self waittill_notify_or_timeout( "turret_on_target", 3 ); 		
					self ClearTurretTarget(); 
					wait( RandomFloatRange( 0.45, 1.2 ) );
					self fireweapon();
					wait( RandomIntRange( 5, 8 ) );
					continue; // continue the while loop
				}
			}

			self tank_fire_at_struct( targs[RandomInt(targs.size)] );
			wait( RandomIntRange( 4, 6 ) );	
			
		}
		// fire at him if he's on the right platform
		else if(isdefined( player_touching_right_trig )  )
		{
		
			
			// make sure the aa gun exists before checking its owner
			if( isdefined( right_aa_gun ) && right_aa_gun.health )
			{
				right_aa_owner = right_aa_gun GetVehicleOwner();
				
				// if the player is the owner, fire directly at the aa gun itself
				if( isdefined( right_aa_owner ) )
				{
					
					quick_text( "preparing to fire on right aa gun" );
					
					// if the player leaves the gun, continue the while loop and get a new target
					if( !check_player_on_aa_gun_still( right_aa_owner, right_aa_gun ) )
					{
						continue;	
					}					
					
					quick_text( "player on right aa gun being fired at now!" );
					
					self setturrettargetent( right_aa_gun, (0,0,15) );
					self waittill_notify_or_timeout( "turret_on_target", 3 ); 		
					self ClearTurretTarget(); 
					wait( RandomFloatRange( 0.45, 1.2 ) );
					self fireweapon();
					wait( RandomIntRange( 5, 8 ) );
					continue; // continue the while loop
				}
			}		
		
			self tank_fire_at_struct( targs[RandomInt(targs.size)] );
			wait( RandomIntRange( 4, 6 ) );	
			
		}
		else if( isdefined( left_turret_owner ) && isplayer( left_turret_owner ) )
		{
			
				quick_text( "firing on left mg!" );
			
				random_offset = RandomIntRange( 29, 35 );
				self setturrettargetent( left_turret_owner, (0,0, random_offset ) );
				
				self waittill_notify_or_timeout( "turret_on_target", 3 ); 		
				self ClearTurretTarget(); 
				wait( 0.25 + RandomFloatRange( 0.25, 1.1 ) ); // some extra time for player to flee
				
				self fireweapon();
		
				level thread earthquake_and_rumble_here( left_mg.origin );
		
				wait( RandomIntRange( 5, 7 ) );				
			
		}
		else if( isdefined( right_turret_owner ) && isplayer( right_turret_owner ) )
		{
			
				quick_text( "firing on right mg!" );
			
				random_offset = RandomIntRange( 29, 35 );
				self setturrettargetent( right_turret_owner, (0,0, random_offset ) );
				
				self waittill_notify_or_timeout( "turret_on_target", 3 ); 		
				self ClearTurretTarget(); 
				wait( 0.25 + RandomFloatRange( 0.25, 1.1 ) ); // some extra time for player to flee
				
				self fireweapon();
				
				level thread earthquake_and_rumble_here( right_mg.origin );
				
				wait( RandomIntRange( 5, 7 ) );				
			
		}		
		// just fire at a player or a struct regardless of where he is
		else
		{
			
			// fire at a random struct
			if( randomintrange( 0, 100 ) > 30 )
			{		
				
				quick_text( self.targetname + ": random tank fire!" );
				
				self tank_fire_at_struct( targs[RandomInt(targs.size)] );
				wait( RandomIntRange( 4, 6 ) );	
				
			}	
			// fire at player no matter where he is
			else
			{
				
				quick_text( self.targetname + " :random player fire" );
				
				players = get_players();
				targetted_player = players[RandomInt(players.size)];
		
				self setturrettargetent( targetted_player, (0,0, RandomIntRange( 15, 26 ) ) );
				
				self waittill_notify_or_timeout( "turret_on_target", 4 ); 		
				self ClearTurretTarget(); 
				wait( 0.35 + RandomFloatRange( 0.25, 1.1 ) ); // some extra time for player to flee
				
				if( !IsAlive( targetted_player ) || !IsDefined( targetted_player ) )
				{
					continue;	
				}
				
				// don't fire if can't see player (though randomly fire once even if it can't see him still)
				if( !tank_can_see_ent( targetted_player, self  ) && !RandomInt( 3 ) )
				{
					continue;	
				}
				
				self fireweapon();
		
				wait( RandomIntRange( 5, 7 ) );			
				
			}
			
		}
		
	}		
	
}



check_player_on_aa_gun_still( aagun_owner, aa_gun )
{

	wait( randomfloatrange( 3.5, 5.75 ) );

	if( !isdefined( self ) || self.health <= 0 )	
	{
		return false;	
	}

	new_owner = aa_gun GetVehicleOwner();
	
	if( isdefined( new_owner ) )
	{
	
		// the owner now is the same as the owner earlier
		if( isdefined( aagun_owner ) && isalive( aagun_owner ) && new_owner == aagun_owner )
		{
			return true;	
		}
		// different owner
		else
		{
			return false;	
		}
		
	}
	// noone is manning the gun anymore
	else
	{
		return false;	
	}
	
}



earthquake_and_rumble_here( orig )
{

	wait( 0.1 );
	
	earthquake( 0.4, 0.8, orig, 300 );
	PlayRumbleOnPosition( "explosion_generic", orig ); 		
		
}



chi_3b_strat()
{

	self thread keep_tank_alive();	
	self thread tank_smoke_death();
	self thread chi_3b_death();
	self thread chi_wave_3_shoot_strat();

	self.pel2_objective_index = 1;

	self.invulnerable_against_these_ents = [];
	self.invulnerable_against_these_ents[0] = getent( "sherman_wave_2a", "targetname" );
	self.invulnerable_against_these_ents[1] = getent( "sherman_wave_2b", "targetname" );
	self.invulnerable_against_these_ents[2] = getent( "sherman_wave_3a", "targetname" );
	self.invulnerable_against_these_ents[3] = getent( "sherman_wave_3b", "targetname" );

	source_node = getvehiclenode ( "chi_wave_3b_avoid_1", "script_noteworthy" );
	dest_node = getvehiclenode( "chi_wave_3b_avoid_2", "script_noteworthy" );
	self setswitchnode( source_node, dest_node );	
	
	// wait till we're at the beginning of the spline loop
	self setwaitnode( dest_node );
	self waittill( "reached_wait_node" );	
	self stop_keep_tank_alive();
	self.health = 1500;
	self thread pel2_friendly_fire_shield();
	
	self endon( "death" );
	
	// don't know why, but this wait has to be here or else the next "reached_wait_node" will never be hit. 
	// maybe something to do with setswitchnode() or setwaitnode()?
	wait( 0.05 );	
	
	// have tank patrol
	while( 1 )
	{
		
		source_node = getvehiclenode ( "chi_wave_3b_avoid_3", "script_noteworthy" );
		dest_node = getvehiclenode( "chi_wave_3b_avoid_4", "script_noteworthy" );
		self setswitchnode( source_node, dest_node );		
		
		//pause_node = getvehiclenode( "chi_wave_3b_pause_1", "script_noteworthy" );
  		self setwaitnode( dest_node );
  		self waittill( "reached_wait_node" );

		wait( 0.05 );
		
		source_node = getvehiclenode ( "chi_wave_3b_avoid_5", "script_noteworthy" );
		dest_node = getvehiclenode( "chi_wave_3b_avoid_2", "script_noteworthy" );
		self setswitchnode( source_node, dest_node );	
		
		//pause_node = getvehiclenode( "chi_wave_3b_pause_2", "script_noteworthy" );
  		self setwaitnode( dest_node );
  		self waittill( "reached_wait_node" );

		wait( 0.05 );	
		
	}	

}



chi_3c_strat()
{
	
	self thread keep_tank_alive();	
	self thread tank_smoke_death();	
	self thread chi_3c_shoot_strat();
	self thread chi_3c_death();
	
	self.pel2_objective_index = 2;
	
	self.invulnerable_against_these_ents = [];
	self.invulnerable_against_these_ents[0] = getent( "sherman_wave_2a", "targetname" );
	self.invulnerable_against_these_ents[1] = getent( "sherman_wave_2b", "targetname" );
	self.invulnerable_against_these_ents[2] = getent( "sherman_wave_3a", "targetname" );
	self.invulnerable_against_these_ents[3] = getent( "sherman_wave_3b", "targetname" );	
	
	self endon( "death" );
	
	vnode = getvehiclenode( "chi_wave_3c_wait_1", "script_noteworthy" );
	vnode waittill( "trigger" );
	
	self setspeed( 0, 10, 10 );
	
	flag_wait( "move_wave_2_3" );
	
	self stop_keep_tank_alive();
	self.health = 1500;
	self thread pel2_friendly_fire_shield();
	
	self resumespeed( 4, 3, 3 );
	
	// NOTE: the splines that start with avoid_6 and avoid_2 look similar and redundant, but avoid_6 has an
	// extra node in the opposite direction to help with the stopping/looping
	source_node = getvehiclenode ( "chi_wave_3c_avoid_1", "script_noteworthy" );
	dest_node = getvehiclenode( "chi_wave_3c_avoid_2", "script_noteworthy" );
	self setswitchnode( source_node, dest_node );	
	
	self setwaitnode( dest_node );
	self waittill( "reached_wait_node" );		

	wait( 0.05 );

	source_node = getvehiclenode ( "chi_wave_3c_avoid_3", "script_noteworthy" );
	dest_node = getvehiclenode( "chi_wave_3c_avoid_4", "script_noteworthy" );
	self setswitchnode( source_node, dest_node );		
	
	// wait till we're at the beginning of the spline loop
	self setwaitnode( dest_node );
	self waittill( "reached_wait_node" );			

	self setspeed( 0, 6, 6 );
	wait( RandomIntRange( 2, 6 ) );
	self resumespeed( 4, 3, 3 );

	// don't know why, but this wait has to be here or else the next "reached_wait_node" will never be hit. 
	// maybe something to do with setswitchnode() or setwaitnode()?
	wait( 0.05 );	
	
	// have tank move back and forth
	while( 1 )
	{
		
		source_node = getvehiclenode ( "chi_wave_3c_avoid_5", "script_noteworthy" );
		dest_node = getvehiclenode( "chi_wave_3c_avoid_6", "script_noteworthy" );
		self setswitchnode( source_node, dest_node );	
		
		self setwaitnode( dest_node );
		self waittill( "reached_wait_node" );	
		
		self setspeed( 0, 14, 14 );
		wait( RandomIntRange( 2, 6 ) );
		self resumespeed( 4, 3, 3 );
		
		wait( 0.05 );	
		
		source_node = getvehiclenode ( "chi_wave_3c_avoid_7", "script_noteworthy" );
		dest_node = getvehiclenode( "chi_wave_3c_avoid_4", "script_noteworthy" );
		self setswitchnode( source_node, dest_node );		
		
		self setwaitnode( dest_node );
		self waittill( "reached_wait_node" );			
	
		self setspeed( 0, 6, 6 );
		wait( RandomIntRange( 2, 6 ) );
		self resumespeed( 4, 3, 3 );	
		
		wait( 0.05 );		
		
	}	
	
}



chi_3c_death()
{

	level endon( "chi_3_wave_dead" );

	self waittill( "death" );
	
	flag_set( "chi_3c_death" );

	Objective_additionalPosition( 4, self.pel2_objective_index, (0,0,0) );
	
}



chi_3c_shoot_strat()
{

	self endon ( "death" );

	wait( 3 );
	
	targ = getent( "sherman_wave_3b", "targetname" );
	
	while( targ.health > 0 )
	{
	
		self setturrettargetent( targ );
		
		self waittill( "turret_on_target" ); 		
		self ClearTurretTarget(); 
		wait( 0.35 );
		
		self fireweapon();
		wait( RandomFloatRange( 3.0, 3.9 ) );
		
	}
	
	self thread chis_fire_at_players();
	
}



shermans_wave_3()
{
	
	flag_wait_all( "tank_spawn_n_move_2", "move_wave_2_1" );

	wait_network_frame();

	// add another guy to the friendly color chain
	simple_spawn( "friend_airfield_spawner" );

}



tank_smoke_death()
{

	self waittill( "death" );
	
	while( 1 )
	{
	
		if ( ( self getspeedMPH() ) == 0 )
		{
			break;
		}
		
		wait( 0.05 );
		
	}
	
	if( self.vehicletype == "sherman" )
	{
		playFXonTag( level._effect["sherman_camo_smoke"], self, "tag_origin" );	
	}
	else
	{
		playFXonTag( level._effect["type97_smoke"], self, "tag_origin" );	
	}
	
	wait( 0.05 );
	
	// manually notify this cuz i'm not really using crashpaths. kill() in _vehicle wants this notify when the tank is dead & done moving
	self notify( "deathrolloff" );

}



deathroll_off_notify()
{

	self waittill( "death" );
	
	while( 1 )
	{
	
		if ( ( self getspeedMPH() ) == 0 )
		{
			break;
		}
		
		wait( 0.05 );
		
	}
	
	wait( 0.05 );
	
	// manually notify this cuz i'm not really using crashpaths. kill() in _vehicle wants this notify when the tank is dead & done moving
	self notify( "deathrolloff" );	
	
}




///////////////////
//
// Bazooka guys that respawn
//
///////////////////////////////

bazooka_respawner()
{
	bazooka_spawner = getent( "bazooka_spawner", "targetname" );
	bazooka_spawner thread bazooka_spawn_think();
}



///////////////////
//
// Custom spawn stuff for bazooka respawner
//
///////////////////////////////

bazooka_spawn_think()
{

	level endon( "stop_bazooka_spawn" );

	while( self.count )
	{
		
		while( !OkTospawn() )
		{
			wait( 0.05 ); 
		}		
		
		ai = self DoSpawn(); 
			
		if( spawn_failed( ai ) )
		{
			wait( 2 ); 
			continue; 
		}
		else
		{
			ai thread bazooka_strat();
			ai waittill( "death" );
		}
		
	}
	
}



bazooka_strat()
{

	self endon( "death" );
	
	self thread magic_bullet_shield();
	
	self waittill( "goal" );
	
	self stop_magic_bullet_shield();
	
}



///////////////////
//
// invinc bazooka guy not on color chain
//
///////////////////////////////

bazooka_special()
{
	// flag set on trigger
	flag_wait( "trig_bazooka_special" );
	simple_spawn( "bazooka_special_spawner", ::bazooka_special_strat );
}



bazooka_special_strat()
{
	
	self endon( "death" );
	
	self.ignoreme = 1;
	self thread magic_bullet_shield();
	self.goalradius = 36;
	self.targetname = "bazooka_special";
	
	goal = getnode( "node_bazooka_start", "targetname" );
	self setgoalnode( goal );
	
	flag_wait( "at_cinch_point" );
	
	self.ignoresuppression = 1;
	
	goal = getnode( "node_bazooka_rest", "targetname" );
	self setgoalnode( goal );
	
	wait( 3 );
	
	goal = getnode( "node_bazooka_finale", "targetname" );
	self setgoalnode( goal );	
	
	self stop_magic_bullet_shield();
	self.ignoreme = 0;
	
	wait( RandomIntRange( 1, 3 ) );
	
	// POLISH better death, or vignette even?
	self dodamage( self.health + 1, (0,0,0) );
	
}



///////////////////
//
// Master thread for ambient stuff
//
///////////////////////////////

airfield_ambience()
{
		
	// Wii optimizations & coop optimizations
	if( !level.wii && !NumRemoteClients())
	{
		level thread ambient_left_battle();
	}
	
	//	level thread ridge_flashes(); // Clientsided - DSL
		
	level thread ambient_planes();
}



///////////////////
//
// specify a new vehicleattackgroup for a tank
//
///////////////////////////////

attack_this_group( group_num )
{
	
	self notify( "killed all targets" );
	self.script_vehicleattackgroup = group_num;
	self thread maps\_vehicle::attackgroup_think();	
	
}



///////////////////
//
// Have a tank attack another specific tank
// fatal_shot: if this many shots are fired at the specified tank and it's still not dead, kill it with radius damage (only if tank doesn't have god mode on)
//
///////////////////////////////

attack_this_tank( tank_name, fatal_shot, min_delay, max_delay )
{

	self endon( "death" );
	self endon( "stop_attacking_tank" );
	
	// to kill any previously running instances of this thread
	self notify( "stop_attack_this_tank" );
	self endon( "stop_attack_this_tank" );

	if( !isdefined( min_delay ) )
	{
		min_delay = 3.0;
	}
	if( !isdefined( max_delay ) )
	{
		max_delay = 4.0;
	}

	targ = getent( tank_name, "targetname" );

	shots_fired = 0;

	while( targ.health > 0 )
	{
	
		self setturrettargetent( targ, (0,0,50 ) ); // uses the same offset as attackgroup_think in _vehicle
		
		self waittill( "turret_on_target" ); 		
//		self ClearTurretTarget(); 
//		wait( 0.35 );
		
		self fireweapon();
		shots_fired++;
		wait( 0.05 );
		
		if( isdefined( fatal_shot ) )
		{
		
			// failsafe, cuz of projectile/collision bugginess that sometimes happens
			if( shots_fired >= fatal_shot && targ.health  && !(targ maps\_vehicle::is_godmode()) )
			{
				radiusdamage( targ.origin, 10, targ.health + 1, targ.health + 1 );
			}			
			
		}
		
		if( targ.health )
		{
			wait( RandomFloatRange( min_delay, max_delay ) );
		}
		
	}
	
}



///////////////////
//
// Make color squad small for assaulting the AA guns
//
///////////////////////////////

tighten_up_color_chains()
{
	
	// flag set on trigger
	flag_wait( "trig_tighten_up_chains" );

	level notify( "stop_bazooka_spawn" );

	guy = getent( "bazooka_spawner_alive", "targetname" );
	if( isdefined( guy ) )
	{
		guy set_force_color( "y" );
	}

	guys_turned_green = 0;
	guys = getaiarray( "allies" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		
		if( guys[i] == level.roebuck || guys[i] == level.polonsky || guys[i] == level.extra_hero )
		{
			continue;
		}
		
		if( guys_turned_green < 3 )
		{
			guys[i] set_force_color( "g" );
			guys_turned_green++;
		}
		else
		{
			guys[i] set_force_color( "y" );	
		}
		
	}
	
	set_color_heroes( "c" );	

}



///////////////////
//
// Too many frickin' turrets. Delete some mgs from the beginning of the map so we don't hit the max 32 turret limit
//
///////////////////////////////

delete_old_turrets()
{

	get_players_off_turrets();
	
	mg = getent( "flame_bunker_mg_r", "targetname" );
	if( isdefined( mg ) )
	{
		mg delete();
	}
	
	mg = getent( "flame_bunker_mg_l", "targetname" );
	if( isdefined( mg ) )
	{
		mg delete();
	}
	
	mg = getent( "bunker_1_mg_2", "targetname" );
	if( isdefined( mg ) )
	{
		mg delete();
	}
	
	mg = getent( "bunker_1_mg_1", "targetname" );
	if( isdefined( mg ) )
	{
		mg delete();
	}
	
	
	flag_wait( "at_cinch_point" );
	
	// player can't get on these, so don't need to run get_players_off_turrets() again
	
	mg = getent( "admin_mg_r", "targetname" );
	if( isdefined( mg ) )
	{
		mg delete();
	}
	
	mg = getent( "admin_mg_l", "targetname" );
	if( isdefined( mg ) )
	{
		mg delete();
	}
	
}



get_players_off_turrets()
{
	
	turrets = GetEntArray( "misc_turret", "classname" );

	for(i = 0; i < turrets.size; i ++)
	{
		ent = turrets[i] getturretowner();
		
		if( isdefined(ent) && isplayer(ent) )
		{
			turrets[i] useby(ent);
			break;
		}
	}
	
}



///////////////////
//
// truck crash vignette in opening airfield read
//
///////////////////////////////

#using_animtree( "pel2_truck_crash" );
truck_crash()
{
	
	wait_network_frame(); // CLIENTSIDE to help snapshot size
	
	truck = getent( "airfield_type94", "targetname" );
	truck thread truck_crash_fx();

	truck_crash_guys();

	truck UseAnimTree(#animtree);

	anim_node = getnode( "node_truck_crash", "targetname" );
	
	truck animscripted( "airfield_truck_done", anim_node.origin, anim_node.angles, level.scr_anim["airfield"]["truck_crash"] );
	truck waittill( "airfield_truck_done" );
	
	truck notsolid();
	
}



///////////////////
//
// Japanese guys on the truck that crashes in the opening airfield read
//
///////////////////////////////

#using_animtree( "generic_human" );
truck_crash_guys()
{

	truck = getent( "airfield_type94", "targetname" );

	// drivers
	truck_crash_drivers( truck );

	anim_node = getnode( "node_truck_crash", "targetname" );

	anims = [];
	anims[0] = "truck_eject_1";
	anims[1] = "truck_eject_2";
	anims[2] = "truck_eject_3";
	anims[3] = "truck_eject_4";

	guys_2 = simple_spawn( "crash_truck_guys_2" );
	for( i  = 0; i < guys_2.size; i++ )
	{
		guys_2[i].animname = "airfield";
		guys_2[i].ignoreall = 1;
		guys_2[i].ignoreme = 1;
		guys_2[i] thread truck_crash_guys_invinc();
		level thread truck_crash_guys_anim( guys_2[i], anims[i], anim_node );
	}
	
	script_guy_1 = spawn( "script_model", truck.origin );
	script_guy_1.angles = truck.angles;
	script_guy_1 character\char_jap_pel2_rifle::main();		
	script_guy_1 UseAnimTree( #animtree );
	script_guy_1.animname = "airfield";
	script_guy_1.targetname = "script_model_guy_1";

	level thread anim_single_solo( script_guy_1, anims[2], undefined, anim_node );


	script_guy_2 = spawn( "script_model", truck.origin );
	script_guy_2.angles = truck.angles;
	script_guy_2 character\char_jap_pel2_rifle::main();		
	script_guy_2 UseAnimTree( #animtree );
	script_guy_2.animname = "airfield";
	script_guy_2.targetname = "script_model_guy_2";
	
	level thread anim_single_solo( script_guy_2, anims[3], undefined, anim_node );


}



///////////////////
//
// enemies that are driving the truck that crashes in the airfield opening read
//
///////////////////////////////

truck_crash_drivers( truck )
{

	starting_position = undefined;
	idle_anim = undefined;

	guys = simple_spawn( "crash_truck_guys" );

	for( i  = 0; i < guys.size; i++ )
	{
		
		switch( i )
		{
			case 0:
			
				starting_position = "tag_driver";
				idle_anim = "truck_idle_driver";
				break;
			
			case 1:
			
				starting_position = "tag_passenger";
				idle_anim = "truck_idle_passenger";
				break;	
														
		}
		
		guys[i] thread truck_crash_behavior( idle_anim );
		guys[i] linkto( truck, starting_position, ( 0, 0, 0 ), ( 0, 0, 0 ) );
		
	}	
	
}



truck_crash_guys_anim( guy, anim_name, anim_node )
{
	
	if( anim_name == "truck_eject_2" )
	{
		guy gun_remove();
	}		
	
	anim_single_solo( guy, anim_name, undefined, anim_node ); 
	
	guy notify( "done_crash_anim" );
	
	guy.ignoreall = 0;
	guy.goalradius = 30;
	node_name = "node_" + anim_name;
	goal_node = getnode( node_name, "script_noteworthy" );
	guy setgoalnode( goal_node );


	//TUEY Set music state to AIRFIELD
	setmusicstate("AIRFIELD");
	
}



///////////////////
//
// Don't want guys killable during the ride, but once they're thrown from the truck, they can be killed during the standup anim
//
///////////////////////////////

truck_crash_guys_invinc()
{

	self endon( "death" );
	
	self setcandamage( false );

	// about the amount of time it takes for them to be thrown from the truck (may want a notetrack added later so this can be more accurate)
	wait( 7 );
	
	self.allowdeath = 1;
	self.a.nodeath = true;
	self setcandamage( true );
	self.health = 20;
	
	self thread stop_truck_death();
	
	wait( 3 );
	
	self.ignoreme = 0;
	
}



stop_truck_death()
{
	
	self endon( "done_crash_anim" );
	
	self waittill( "death", attacker, type );

	self startRagdoll();
	
	// if they're killed during their anim with a flamethrower, we'll need to manually burn them, otherwise they'll just die w/o charring
	if( isplayer( attacker ) && type == "MOD_BURNED" )
	{
		self thread animscripts\death::flame_death_fx();
	}
	
}



truck_crash_behavior( idle_anim )
{

	self endon( "death" );

	self setcandamage( false );
	self.animname = "airfield";
	
	level thread anim_loop_solo( self, idle_anim, undefined, "stop_idle_anim" );	

	wait( 5.5 );
	
	self notify( "killanimscript" );
	self setcandamage( true );
	self dodamage( self.health + 1, (0,0,0) );

}



///////////////////
//
// Fx that play on/around the truck that crashes in the airfield opening read
//
///////////////////////////////

truck_crash_fx()
{

	//orig = getstruct( "orig_truck_near_hit", "targetname" );

	flag_wait( "truck_hit_by_shell" );
	playfxontag( level._effect["truck_hit_by_shell"], self, "tag_headlight_left" );	

	wait( 1.25 );
	
	// TEMP, need to play off a unique origin
	playfx (level._effect["truck_slide_dust"], (2668, 1655.5, 9.3) );	
	
}



///////////////////
//
// plane that strafes near cinch point
//
///////////////////////////////

plane_strafe()
{
	
	trigger_wait_or_timeout( "strafe_lookat", 2 );

	// DSL - delay this a network frame or two, if things are crazy busy on the network.

	while(!oktospawn())
	{
		wait(0.1);
	}
	
	flag_set( "plane_strafe" );

	plane = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "strafe_plane" );
	
	plane playsound( "corsair_strafe" );
	
	plane thread keep_tank_alive();
	
	vnode = getvehiclenode( "node_strafe_rumble", "script_noteworthy" );
	vnode waittill( "trigger" );
	
	flag_set( "plane_strafe_shoot" );
	
	plane thread corsair_turret_think();
	
	level thread strafe_squibs( "forest_bullet_hit_1", "forest_bullet_hit_1a" );
	level thread strafe_squibs( "forest_bullet_hit_2", "forest_bullet_hit_2a" );
	
	earthquake( 0.3, 2.0, (2402.5, 4195, 23) , 1300 );
	
}



///////////////////
//
// plane that hits the telephone poles
//
///////////////////////////////

#using_animtree ("pel2_truck_crash");
plane_pole()
{
	
	// original origin of trigger: 2617 8227 58
	
	// flag set on trigger
	flag_wait( "trig_pole_crash" );
	
	wait( randomfloatrange( 0.9, 1.7 ) );
	
	plane = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "pole_plane" );
	
	plane thread keep_tank_alive();
	
	hit_node = getvehiclenode( "pole_plane_hit", "script_noteworthy" );
	hit_node waittill( "trigger" );
	
	PlayFXOnTag( level._effect["fighter_wing_hit"], plane,"tag_engine_left" );	
	
	plane playsound( "pole_corsair_hit" );
	
	vnode = getvehiclenode( "node_tele_hit", "script_noteworthy" );
	vnode waittill( "trigger" );
	
	anim_node = getnode( "node_telepole", "targetname" );
	
	rig_model = getent( "tele_rig_model", "targetname" );
	rig_model UseAnimTree( #animtree );
	rig_model.animname = "airfield";
	
	level thread anim_single_solo( rig_model, "telepole", undefined, anim_node );
	
	vnode = getvehiclenode( "auto5094", "targetname" );
	vnode waittill( "trigger" );	
	
	playfx( level._effect["telepole_plane_crash"], vnode.origin );		
	temp_orig = spawn( "script_origin", vnode.origin );
	temp_orig playsound( "bomber_crash_end", "bomber_crash_end_done" );
	
	temp_orig waittill( "bomber_crash_end_done"  );
	temp_orig delete();
	
			
}



///////////////////
//
// Plane that hits tower as player nears the AA gun area
//
///////////////////////////////

plane_tower()
{
	
	// flag set on trigger
	flag_wait( "trig_tower_plane" );

	wait( 2.5 );
	
	plane = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "tower_plane" );
	
	plane thread keep_tank_alive();
	
	hit_node = getvehiclenode( "tower_plane_hit", "script_noteworthy" );
	hit_node waittill( "trigger" );	
	
	PlayFXOnTag( level._effect["fighter_wing_hit"], plane,"tag_engine_left" );	
	
	plane playsound( "pole_corsair_hit" );
	
	plane waittill( "reached_end_node" );	
	
	playfx( level._effect["large_vehicle_explosion"], plane.origin );		
	
	level thread plane_tower_sound( hit_node );
	
	earthquake( 0.7, 1.75,(2353.1, 8202.6, 154), 2000 );
	
	exploder( 500 );
	
	brush = getent( "sb_model_AA_tower", "targetname" );
	brush delete();
	
	plane delete();
		
}



plane_tower_sound( hit_node )
{

	temp_orig = spawn( "script_origin", hit_node.origin );
	temp_orig playsound( "bomber_crash_end", "bomber_crash_end_done" );

	temp_orig waittill( "bomber_crash_end_done"  );
	temp_orig delete();	
	
}


///////////////////
//
// aa gun that fires and hits the tower plane
//
///////////////////////////////

plane_tower_aa_direct_fire()
{

	original_aaTarget = getent( "aaGun_1_target", "script_noteworthy" );
	original_aaTarget notify("change target");

	new_aaTarget = convert_aiming_struct_to_origin( "orig_tower_plane_new_targ" );
	level thread flame_move_target( new_aaTarget, 3.5 );

	aaGun_1 = getent( "aaGun_1", "targetname" );
	aaGun_1 thread maps\_triple25::triple25_shoot( new_aaTarget );	
	
	aaGun_1 endon( "crew dead" );
	
	flag_wait( "trig_tower_plane" );
	
	wait( 3.5 );
	
	new_aaTarget notify( "stop_fakefire_mover" );
	new_aaTarget notify( "change target" );
	
	new_aaTarget.origin = getstruct( "orig_tower_plane_new_targ_2", "targetname" ).origin;
	aaGun_1 thread maps\_triple25::triple25_shoot( new_aaTarget );	
	
	wait( 2 );
	
	new_aaTarget notify("change target");
	
	new_aaTarget.origin = getstruct( "orig_tower_plane_new_targ_3", "targetname" ).origin;
	aaGun_1 thread maps\_triple25::triple25_shoot( new_aaTarget );		
	
	wait( 2.5 );
	
	new_aaTarget notify("change target");
	
	//shoot the old target again
	aaGun_1 thread maps\_triple25::triple25_shoot( original_aaTarget );	
	
}



debug_strafe_plane()
{

	players = get_players();
	players[0] setOrigin( ( 2490, 3986.5, 33.5 )  );
	
	level.debug_strafe_plane = 1;
	
	plane_strafe();
	
	wait( 1000 );
	
}



debug_pole_plane()
{

	players = get_players();
	players[0] setOrigin( ( 2733, 5974, 53 )  );
	
	plane_pole();
	
	wait( 1000 );
	
}



///////////////////
//
// Strafe plane's turrets firing
//
///////////////////////////////

corsair_turret_think()
{
	
	self endon("death");
	level endon( "done_strafe_squibs" );
	
	if( !IsDefined( self.firing ) )
	{
		self.firing = false;
	}
	
	while( 1 )
	{
		
		for( i  = 0; i < self.mgturret.size; i++ )
		{
			self.mgturret[i] shootturret(); 
		}
		
		wait( 0.2 );	
	}	
		
}



strafe_squibs( origin_name, dest_name )
{
	
	shot_origin = getent( origin_name,"script_noteworthy" );

	ultimate_destination = getstruct( dest_name, "script_noteworthy" );	
	shot_origin thread move_shot_destination( ultimate_destination, 1.3 );
	
	shot_origin endon( "done_squib" );
	
	while( 1 )
	{
		playfx( level._effect["strafe_squib"], shot_origin.origin, anglestoforward(shot_origin.angles ) );		
		wait( 0.1 );
	}
	
}



move_shot_destination( end, duration )
{

	self moveto ( end.origin, duration );
	self waittill ( "movedone" );
	
	self notify( "done_squib" );
	level notify( "done_strafe_squibs" );
	
}



///////////////////
//
// checks if a tank is invulnerable against the passed in attacker. does this by checking self's .invulnerable_against_these_ents array
//
///////////////////////////////

invulnerable_against_this_attacker( attacker )
{

	if( isdefined( self.invulnerable_against_these_ents ) )
	{
	
		for( i  = 0; i < self.invulnerable_against_these_ents.size; i++ )
		{
			if( self.invulnerable_against_these_ents[i] == attacker )
			{
				return true;	
			}
		}
		
	}

	return false;
	
}



///////////////////
//
// Friendly-fire shield for tanks because I don't trust friendlyfire_shield() in _vehicle. I don't think it works properly.
//
///////////////////////////////

pel2_friendly_fire_shield()
{

	self.currenthealth = self.health; 
	self.health = 20000;
	
	attacker = undefined; 

	while( self.health > 0 )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
		if( 
				( !isdefined( attacker ) && self.script_team != "neutral" )
				 || 	maps\_vehicle::is_godmode()
				 || 	maps\_vehicle::attacker_isonmyteam( attacker )
				 || 	maps\_vehicle::attacker_troop_isonmyteam( attacker )
				 || 	maps\_vehicle::isDestructible()
				 || 	maps\_vehicle::bulletshielded( type )
				 ||		invulnerable_against_this_attacker( attacker )
		)
		{
			self.health = 20000;  // give back health for these things	
		}
		else
		{
			self.health = self.currenthealth;
			radiusdamage( self.origin, 10, amount, amount + 1 );
			self.currenthealth = self.health;
			// put ff shield back on
			self.health = 20000;
		}
	}
	
	//tank has beenkilled at this point
	
	// taken from _vehicle.gsc	
	if( arcadeMode() && IsPlayer( attacker )  )
	{
		arcademode_assignpoints( "arcademode_score_tank", attacker );
	}	
	
}



	
///////////////////
//
// piggybacking autosaves onto other triggers, to save entities
//
///////////////////////////////	

save_when_near_cinch_point()
{
	trigger_wait( "chain_cinch", "targetname" );
	autosave_by_name( "Pel2 near cinch point" );		
}
	
	

///////////////////
//
// piggybacking autosaves onto other triggers, to save entities
//
///////////////////////////////	

save_when_near_aa_bunker()
{
	trigger_wait( "chain_entering_aa_bunker", "targetname" );
	autosave_by_name( "Pel2 entering aa bunker" );			
}


///////////////////
//
// spawn these manually when the event starts, to save on entities at load time
//
///////////////////////////////

spawn_airfield_pickup_weapons()
{

	airfield_weapons = [];
	
	// grenades in far right bunker on airfield
	airfield_weapons[0] = spawnstruct();
	airfield_weapons[0].weapon_name = "weapon_type97_frag";
	airfield_weapons[0].origin = (3445.4, 3102.6, -94.5);
	airfield_weapons[0].angles = (0, 293.6, 0);

	airfield_weapons[1] = spawnstruct();
	airfield_weapons[1].weapon_name = "weapon_type97_frag";
	airfield_weapons[1].origin = (3444.2, 3096.6, -94.5);
	airfield_weapons[1].angles = (0, 293.6, 0);

	airfield_weapons[2] = spawnstruct();
	airfield_weapons[2].weapon_name = "weapon_type97_frag";
	airfield_weapons[2].origin = (3439.6, 3103.1, -97);
	airfield_weapons[2].angles = (270, 240.8, 0);


	// grenades in middle bunker on airfield
	airfield_weapons[3] = spawnstruct();
	airfield_weapons[3].weapon_name = "weapon_type97_frag";
	airfield_weapons[3].origin = (2248, 4108.5, -37.8);
	airfield_weapons[3].angles = (0, 0, 0);

	airfield_weapons[4] = spawnstruct();
	airfield_weapons[4].weapon_name = "weapon_type97_frag";
	airfield_weapons[4].origin = (2243, 4112, -38);
	airfield_weapons[4].angles = (0, 0, 0);

	airfield_weapons[5] = spawnstruct();
	airfield_weapons[5].weapon_name = "weapon_type97_frag";
	airfield_weapons[5].origin = (2240.2, 4106.9, -39.8);
	airfield_weapons[5].angles = (270, 307.2, 0);


	// weapons in cinch bunker on airfield
	airfield_weapons[6] = spawnstruct();
	airfield_weapons[6].weapon_name = "weapon_type100_smg";
	airfield_weapons[6].origin = (2670.9, 4149.8, -84.9);
	airfield_weapons[6].angles = (309.165, 112.437, -37.0203);

	airfield_weapons[7] = spawnstruct();
	airfield_weapons[7].weapon_name = "weapon_type100_smg";
	airfield_weapons[7].origin = (2653.5, 4151.5, -85.4);
	airfield_weapons[7].angles = (297.063, 96.3252, -32.5557);

	airfield_weapons[8] = spawnstruct();
	airfield_weapons[8].weapon_name = "weapon_type100_smg";
	airfield_weapons[8].origin = (2252.7, 4054.2, -34.8);
	airfield_weapons[8].angles = (306.6, 0, -23.4);

	airfield_weapons[9] = spawnstruct();
	airfield_weapons[9].weapon_name = "weapon_type100_smg";
	airfield_weapons[9].origin = (2233.8, 4042.7, -54.7);
	airfield_weapons[9].angles = (0, 171.4, 180);

	airfield_weapons[10] = spawnstruct();
	airfield_weapons[10].weapon_name = "weapon_type99_rifle";
	airfield_weapons[10].origin = (2495.4, 4010.9, -80.6);
	airfield_weapons[10].angles = (288.56, 168.301, -80.8935);
	
	airfield_weapons[11] = spawnstruct();
	airfield_weapons[11].weapon_name = "weapon_type99_rifle";
	airfield_weapons[11].origin = (2496.6, 3997.7, -100.2);
	airfield_weapons[11].angles = (358.074, 86.9453, -73.6962);	

	airfield_weapons[12] = spawnstruct();
	airfield_weapons[12].weapon_name = "weapon_type97_frag";
	airfield_weapons[12].origin = (2741.5, 4066, -78.6);
	airfield_weapons[12].angles = (270, 282.2, 0);	

	airfield_weapons[13] = spawnstruct();
	airfield_weapons[13].weapon_name = "weapon_type97_frag";
	airfield_weapons[13].origin = (2742.7, 4057.2, -76.8);
	airfield_weapons[13].angles = (0, 335, 0);	

	airfield_weapons[14] = spawnstruct();
	airfield_weapons[14].weapon_name = "weapon_bazooka";
	airfield_weapons[14].origin = (2496.8, 4095.4, -49.9);
	airfield_weapons[14].angles = (284.106, 167.138, -134.561);	

	spawn_pickup_weapons( airfield_weapons );
	
}
