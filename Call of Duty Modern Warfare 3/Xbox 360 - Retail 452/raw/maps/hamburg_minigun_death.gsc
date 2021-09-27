#include maps\_utility;
#include maps\_utility_code;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\hamburg_code;
#include maps\hamburg_hovercraft_code;
#include animscripts\hummer_turret\common;
#include maps\hamburg_tank_ai;

main()
{
	thread fx_volume_pause_noteworthy( "beach_area", true );
	veh_node_minigun_sniper_death = GetVehicleNode( "veh_node_minigun_sniper_death", "script_noteworthy" );
	veh_node_minigun_sniper_death waittill_triggered_current();

	tank = level.player_tank;
	minigun = tank.mgturret[ 1 ];
	minigun notify ( "stop_mg42_target_drones" );
	minigun SetMode( "sentry" );

	tank vehicle_stop_named( "minigunner_stop", 5, 5 );
	
 //	flag_wait( "player_ready_for_minigun_death" );	
	
	tank stop_turret_attack_think_hamburg();

	
	struct_minigun_death_target = getstruct( "struct_minigun_death_target", "targetname" );
	
	target_entity = struct_minigun_death_target spawn_tag_origin();
	
	tank thread turret_attacks_target( target_entity );
	minigun thread minigun_attacks_target( target_entity );
	
	minigunner = minigun GetTurretOwner();
	minigunner.ignoreme = true; // make him just be a bad ass who's killing everyone for a bit.
	
	minigun_volume_ai_checker = GetEnt( "minigun_volume_ai_checker", "targetname" );
	minigun_volume_ai_checker thread encourage_enemy_ai_death_in_volume();
	minigun_volume_ai_checker waittill_volume_dead_or_dying();

	special_place_in_my_heart = GetEnt( "special_place_in_my_heart", "script_noteworthy" );
	special_place_in_my_heart notify ( "trigger" ); // color trigger on the chain, enter losing my mind..
	
	tank SetTurretTargetVec( tank tag_project( "tag_body", 100000 ) + ( 0, 0, 55 ) );
	target_entity Delete();
	
	do_regroup_objective();
	
	level notify ( "stop_encourage_enemy_ai_death_in_volume" );
	remove_global_spawn_function( "axis", ::die_quietly );

	//Sandman: What's the hold up?!
	level.sandman dialogue_queue( "hamburg_snd_holdup" );
	
	minigunner thread minigunner_dies_ontheway( target_entity );
	tank vehicle_resume_named( "minigunner_stop" );
	
	flag_wait( "snipey_mc_sniperton_sniped" );
	
	wait 0.5;
	//Sandman: SNIPER!!
	level.sandman dialogue_queue( "hamburg_snd_sniper" );
	radio_dialog_add_and_go( "hamburg_rhg_cartershit" );
	wait 0.1;
	//Rhino 1: Where are the targets?
	radio_dialogue( "tank_rh1_wherearetargets" );
	wait 0.2;
	//Sandman: Top floor of the building in front of you!  Hit it now!
	level.sandman dialogue_queue( "hamburg_snd_hititnow" );

	snipey_mc_sniperton = getstruct( "snipey_mc_sniperton", "targetname" );
	tank SetTurretTargetVec( snipey_mc_sniperton.origin );
	wait 1;
	tank waittill ( "turret_on_target" );
	wait 1;
	tank FireWeapon();
	exploder( "tank_blows_up_sniper" );
	wait 1;
}

minigunner_dies_ontheway( target_entity )
{
	origin = target_entity.origin;
	if ( IsDefined( level.player_tank.mgturret[ 1 ] ) )
	{
		custom_anim_wait_or_timeout( 4850 ); // roughly the length of the reload animation.  
		//I haven't captured replay on this so I'm not sure what's causing him to never finish the custom animation.
		level.player_tank.mgturret[ 1 ] SetMode( "manual" );
		level.player_tank.mgturret[ 1 ] notify ( "stop_sentry_target_drones" );
		level.player_tank.mgturret[ 1 ] StopFiring();
		
	}
	radio_dialog_add_and_go( "tank_ctr_parkinggarage" );
	thread radio_dialog_add_and_go( "tank_ctr_takeitslow" );
	wait 2.6; 
	self glorious_minigunner_death( origin );
}


custom_anim_wait_or_timeout( timeout )
{
	endtime = GetTime() + timeout;
	self endon( "death" );
	if ( !IsDefined( self.isCustomAnimating ) )
		return;

	while ( self.isCustomAnimating && GetTime() < endtime )
		wait( 0.05 );
}

glorious_minigunner_death( origin )
{
	org = self gettagorigin( "TAG_EYE" );
	angles = self gettagangles( "TAG_EYE" );
	PlayFX( getfx( "brains" ), org, ( anglestoforward( angles )* -2 ) );
	thread play_sound_in_space( "hamburg_minigun_sniped" , origin );
	self stop_magic_bullet_shield();
	self Kill();
	
	if ( IsDefined( level.player_tank.mgturret[ 1 ] ) )
	{
		level.player_tank.mgturret[ 1 ] SetMode( "manual" );
		level.player_tank.mgturret[ 1 ] notify ( "stop_sentry_target_drones" );
	}
	
	flag_set( "snipey_mc_sniperton_sniped" );
}


minigun_attacks_target( target_entity )
{
	target_entity endon ( "death" );
	while ( true )
	{
		animscripts\hummer_turret\common::set_manual_target( target_entity, 3, 5  );
	}
}

encourage_enemy_ai_death_in_volume()
{
	level endon ( "stop_encourage_enemy_ai_death_in_volume" );
	add_global_spawn_function( "axis", ::die_quietly, true );
	while( true )
	{
		ai_touching = get_ai_touching_volume( "axis" );
		foreach( guy in ai_touching )
		{
			guy AllowedStances( "stand" );
			guy.attackeraccuracy = 20000;
			guy delaythread( randomfloatrange(6,12), ::die_quietly );
		}
		if( ai_touching.size ) 
			waittill_dead( ai_touching );
		wait 0.05;
	}
}

die_quietly( do_random_delay )
{
	if( isdefined( do_random_delay  ) )
	{
		self endon ( "death" );
		wait RandomFloatRange( 4, 6 );
	}
	self.diequietly = true;
	self kill();
}

do_regroup_objective()
{
	minigunner_regroup = getstruct_delete( "minigunner_regroup", "targetname" );
	
	
	Objective_Position( obj( "scout_for_tanks" ), ( 0, 0, 0 ) );
	
	mounttrigger = GetEnt( "mount_tank_trigger", "targetname" );
	//Regroup.
	Objective_Add( obj( "minigunner_regroup" ), "current", &"HAMBURG_REGROUP", mounttrigger GetCentroid() );
	trigger = Spawn( "trigger_radius", mounttrigger.origin + ( 0, 0, -200 ), 0, 400, 400 );
	
	trigger thread nag_regroup();
	trigger waittill ("trigger" );
	Objective_Position( obj( "scout_for_tanks" ),  mounttrigger GetCentroid() );
	objective_complete( obj( "minigunner_regroup" ) );
}

nag_regroup()
{
	self endon ( "trigger" );
	while( true )
	{
		wait RandomFloatRange( 3, 6 );	
		level.sandman radio_dialogue( "hamburg_snd_regroup" );
	}
}
