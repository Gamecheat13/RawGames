#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\cp\_spawn_manager;

#using scripts\shared\vehicles\_quadtank;

function main()
{
	//SetDvar("aitest_dvar", 0);
	
	if(!level flag::exists("inside_aquifer"))
		level flag::init("inside_aquifer");
	
	level flag::init("aquifer_zone02_combat_start");
	level flag::init("aquifer_zone03_combat_start");
	
	level flag::init("exterior_hack_trig_1_finished");
	level flag::init("exterior_hack_trig_2_finished");
	level flag::init("hack_zone02_1_finished");
	level flag::init("hack_zone02_2_finished");
	level flag::init("hack_zone03_1_finished");
	level flag::init("hack_zone03_2_finished");
	
	level flag::init("exterior_hack_trig_1_started");
	level flag::init("exterior_hack_trig_2_started");
	level flag::init("hack_zone02_1_started");
	level flag::init("hack_zone02_2_started");
	level flag::init("hack_zone03_1_started");
	level flag::init("hack_zone03_2_started");
	
	thread initialize_zone_battle();
}

function initialize_zone_battle()
{	
	//handle the spawning of enemies in zones
	thread handler_ai_spawns();
	
	//handle the spawning of the hack specific spawn managers
	thread handler_hack_spawns();
	
	//cleaning up of previous zone ai spawns
	thread handle_cleaning_up_of_enemies();
	
	thread handler_egyptian_defend_scenario( "water_room_checkpoint" , "hack_terminals3_completed" );
}
//handles all of the zone specific spawn manager logic
function handler_ai_spawns()
{
							//trigger to start spawning     //spawn manager          //flag to stop spawning 	//flag to enable the next trigger for zone spawning
 	thread zone_ai_spawns( "start_spawning_zone01_enemies", "spawn_manager_zone01", "hack_terminals_completed",  "aquifer_zone03_combat_start" );
	thread zone_ai_spawns( "start_spawning_zone02_enemies", "spawn_manager_zone02", "hack_terminals3_completed",  undefined );
	thread zone_ai_spawns( "start_spawning_zone03_enemies", "spawn_manager_zone03", "hack_terminals2_completed", "aquifer_zone02_combat_start" );
}

function zone_ai_spawns( trig, sm, flag_til_kill, flag_enable )  
{
	//first zone spawn setup
	tr = GetEnt( trig, "targetname");
	tr waittill("trigger");
	spawn_manager::enable( sm );
	
	//once the first hacking objs are completed, kill the spawn manager
	level flag::wait_till( flag_til_kill );
	
	spawn_manager::disable( sm );
	
	//set_flag_true on trigger for starting spawns.
	if(isDefined( flag_enable ))
		level flag::set( flag_enable );
}

//handles all of the spawn manager logic for the hacking stations
function handler_hack_spawns()
{
	//zone 01
	thread handler_attack_hack( "destroy_defenses_completed", "exterior_hack_trig_1_started", "exterior_hack_trig_1", "spawn_manager_hack_zone01_1", "exterior_hack_trig_1_finished" );
	thread handler_attack_hack( "destroy_defenses_completed", "exterior_hack_trig_2_started", "exterior_hack_trig_2", "spawn_manager_hack_zone01_2", "exterior_hack_trig_2_finished" );
	
	//zone 02
	thread handler_attack_hack( "destroy_defenses3_completed", "hack_zone02_1_started", "hack_zone02_1", "spawn_manager_hack_zone02_1", "hack_zone02_1_finished" );
	thread handler_attack_hack( "destroy_defenses3_completed", "hack_zone02_2_started", "hack_zone02_2", "spawn_manager_hack_zone02_2", "hack_zone02_2_finished" );
	
	//zone 03
	thread handler_attack_hack( "water_room", "hack_zone03_1_started", "hack_zone03_1", "spawn_manager_hack_zone03_1","hack_zone03_1_finished" );	                      
//	thread handler_attack_hack( "destroy_defenses2_completed", "hack_zone03_2_started", "hack_zone03_2", "spawn_manager_hack_zone03_2","hack_zone03_2_finished" );	 
}

function handler_egyptian_defend_scenario( wait_flag, completed_flag )
{
	sm = "spawn_manager_egyptian_defend1";
	
	level flag::wait_till( wait_flag );
	
	wait 5;
	
	spawn_manager::enable( sm );
	
	level flag::wait_till( completed_flag );
	spawn_manager::disable( sm );
	
	wait 5;
	
	//VO: Thanks for the assist!
	//clean up hack, remove guys after the objective is complete
	guys = spawn_manager::get_ai( sm );
	
	//parse through and delete them.
	foreach( guy in guys )
	{
		if( isDefined( guy ) )
		{
			guy delete(); //TODO: a more elegant way to remove guys that arent currently in any players FOV
		}
	}	
}

//setup the logic for the hacks, passing in notable parms
function handler_attack_hack( flag, flag_hack_started, hack_trig, spawnman, completed_flag )
{
	level flag::wait_till( flag );
	
	//enable the trigger for hacking
	hacking_trig = GetEnt( hack_trig,"targetname");
	hacking_trig triggerenable( true );
	
	level flag::wait_till( flag_hack_started );
	
//	//enable the trigger for specific spawners
//	approach_trig = GetEnt( area_trig, "targetname");
//	approach_trig triggerenable( true );
//	approach_trig waittill("trigger");
	//enable the spawn manager, kickoff combat...
	spawn_manager::enable( spawnman );
	
	level flag::wait_till( completed_flag );
	
	spawn_manager::disable( spawnman );
}

function handle_cleaning_up_of_enemies()
{
	//the zone is effectively done...
	level flag::wait_till( "hack_terminals_completed" );	
	thread clean_up_zone_spawns(1); //pass in the zone number...
	
	//the zone is effectively done...
	level flag::wait_till( "hack_terminals2_completed" );	
	thread clean_up_zone_spawns(2);
	
	//the zone is effectively done...
	level flag::wait_till( "hack_terminals3_completed" );	
	thread clean_up_zone_spawns(3);
}


function clean_up_zone_spawns( zonenum )
{
	//get all the alive dudes from specific spawn managers, using the zone parm
	guys1 = spawn_manager::get_ai( "spawn_manager_zone0" + zonenum ); 
	guys2 = spawn_manager::get_ai( "spawn_manager_hack_zone0" + zonenum + "_1");
	guys3 = spawn_manager::get_ai( "spawn_manager_hack_zone0" + zonenum + "_2");
	
	//get everything together
	arrcomb = arraycombine( guys1,   guys2, false, false );
	arrcomb = arraycombine( arrcomb, guys3, false, false );
	
	//parse through and delete them.
	foreach( guy in arrcomb )
	{
		if( isDefined( guy ) )
		{
			guy delete(); //TODO: a more elegant way to remove guys that arent currently in any players FOV
		}
	}
}

//brute force remove all axis enemies if needed.
function clean_up_all_ext_spawn_managers()
{
	all_axis = GetAITeamArray( "axis" );
	
	foreach( guy in all_axis )
	{
		if( isDefined( guy) )
		{
			guy delete();
		}
	}
	
}
