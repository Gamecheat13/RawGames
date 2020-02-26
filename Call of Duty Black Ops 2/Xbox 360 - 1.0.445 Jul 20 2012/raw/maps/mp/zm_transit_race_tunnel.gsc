#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_race_utility;

race_start()
{
	init_tunnel_race();

	
	maps\mp\zombies\_zm_game_module_race::hide_non_race_objects();
	
	if(!isDefined(level.spawned_collmap))
	{
		level.spawned_collmap = Spawn( "script_model", (-9872, 1344, 0), 1 );
		level.spawned_collmap SetModel( "zm_collision_transit_tunnel_race" );
		level.spawned_collmap DisconnectPaths();

		neon = Spawn( "script_model", (-9872, 1344, 0));
		neon SetModel( "zm_tunnel_encounters_neon" );		
	}
	
	maps\mp\zombies\_zm_game_module::kill_all_zombies();

	flag_wait("start_encounters_match_logic");
	iprintlnbold("RACE TO THE FINISH BEFORE YOUR OPPONENTS");
	
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(1,1,"end_race",undefined,2,2,.4,undefined,undefined,undefined,false,false);
	level thread give_players_grenades();
	
	level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("insta_kill" , getstruct("race_tunnel_instakill_drop","targetname").origin);
}

init_tunnel_race()
{
	level._override_race_death_callback = ::tunnel_race_death_callback_void;
	level._combine_team_zombies = true;	
	level.custom_intermission  = ::tunnel_race_intermission;
	maps\mp\zombies\_zm_game_module::set_current_game_module(level.GAME_MODULE_RACE_INDEX);	
	level._race_door_prefix = "race_tunnel_";
	level._race_location = "tunnel";
	flag_clear("zombie_drop_powerups");
	setup_race_player_areas();
	level._game_module_point_adjustment = undefined;
	level._all_zombies_supersprinters = true;
	level._powerup_timeout_override = undefined;
}

give_players_grenades()
{
	players = GET_PLAYERS();
	foreach(player in players)
	{
		lethal_grenade = player get_player_lethal_grenade();
		player GiveWeapon( lethal_grenade );	
		player SetWeaponAmmoClip( lethal_grenade, 4 );
	}
}

race_end()
{
	level._race_finish_trig = getent("tunnel_race_finish","targetname");	
	winning_team = maps\mp\zombies\_zm_race_utility::wait_for_all_players_finished(level._race_finish_trig);
	level notify("end_race",winning_team);
}

setup_race_player_areas() //TODO - basically the same thing as 'zones'  - so we might as well use the zone system eventually
{
	
	level._race_team_1_spawn_points = getstructarray("race_transit_tunnel_team1_spawn","targetname");
	level._race_team_2_spawn_points = getstructarray("race_transit_tunnel_team2_spawn","targetname");
	
	init_race_player_area("race_tunnel_area_1",1,"race_tunnel_area_1_zombie_spawn",1);
	init_race_player_area("race_tunnel_area_1",1,"race_tunnel_area_1_zombie_spawn",2);
	
}

tunnel_race_death_callback_void(zombie) //needed because zombies aren't split up into teams 
{

}

tunnel_race_intermission()
{
	self maps\mp\zombies\_zm_game_module::game_module_custom_intermission("tunnel_race_intermission_cam");
}