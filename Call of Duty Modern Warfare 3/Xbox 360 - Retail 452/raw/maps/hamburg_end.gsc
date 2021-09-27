#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\hamburg_code;


// Start general functions
pre_load()
{
	PreCacheShellShock( "default" );


	
	flag_init( "rampfoot_finished" );
	flag_init( "streetfoot_finished" );
	flag_init( "nestfoot_finished" );
	flag_init("rooftop_heli_proceed");

	
	flag_init( "flag_garage_wave_killed" );
	flag_init( "flag_garage_wave2_killed" );	
	flag_init( "flag_garage_flee" );
	level.slowmo_viewhands = "viewhands_player_delta";
	
	maps\hamburg_end_streets::streets_pre_load();
	maps\hamburg_end_nest::nest_pre_load();
	
	flag_init( "flag_street1_done" );
	flag_init( "flag_street2_done" );
	flag_init( "flag_street3_done" );
	maps\hamburg_end_anim::main();
	level.friendly_startup_thread = ::assign_friendlies;
	
	setup_vehicle_light_types();
	
	thread post_load();
	
	/*
	if(!IsDefined(level.players))
	{
		level.players = [];
		level.players[0] = level.player;
	}

	
	maps\_javelin::init();
	*/
}

post_load()
{	
	level waittill ( "load_finished" );

	//breach init	
	maps\_breach::main(); 
	maps\_breach_explosive_left::main();
	maps\_slowmo_breach::slowmo_breach_init();
	level.breachignoreEnemy_count = true;

	//Barret init	
//	thread maps\_barrett::barrett_init();
	
	
	

}
assign_friendlies()
{
	//IPrintLnBold("respawning  class: "+ self.classname );
	self endon("death"); // they can die waiting for a slot to open up.
	if( self.classname == "actor_ally_tank_crew_driver" )
	{
		self.script_noteworthy = "greenend1";
	}
	else if( self.classname == "actor_ally_tank_crew_loader" )
	{
		self.script_noteworthy = "greenend2";
	}
	
	if ( !IsDefined( self.script_noteworthy ) )
	{
		return;
	}

	switch(self.script_noteworthy)
	{
			
		case "greenend1":
			while(1)
			{
				if(! (IsDefined(level.green1) && IsAlive(level.green1)))
				{
					level.green1 = self;
					level notify( "greenend1_spawned" );
					//self setup_green1()
					return;
				}
				wait 0.1;
			}
		case "greenend2":
			while( 1 )
			{
				if(! (IsDefined(level.green2) && IsAlive(level.green2)))
				{
					level.green2 = self;
					level notify( "greenend2_spawned" );
					//self setup_green2()
					return;
				}
				wait 0.1;
			}
			break;
		default:
		case "blueend1":
		case "blueend2":
			while(1)
			{
				
				if(! (IsDefined(level.blue1) && IsAlive(level.blue1)))
				{
					level.blue1 = self;
					level notify( "blueend1_spawned" );
					return;
				}
				else if(! (IsDefined(level.blue2) && IsAlive(level.blue2)))
				{
					level.blue2 = self;
					level notify( "blueend2_spawned" );
					return;
				}
				wait 0.1;
			}
			break;
	}
}
//		green2spawner = getent("greenend2","targetname");
//		green2spawner add_spawn_function(::setup_green2);
//		temp2 = spawn_ally( "greenend2", override_spawn_name );

spawn_allies(include_blue,override_spawn_name)
{
	temp = spawn_ally( "redend1", override_spawn_name );
	temp = spawn_ally( "greenend1", override_spawn_name ); 
	if( IsDefined(temp) )
	{
		temp setup_green1();
	}
	temp = spawn_ally( "greenend2", override_spawn_name );
	if( IsDefined(temp) )
	{
		temp setup_green2();
	}
	if(include_blue)
	{
		thread spawn_blue_allies(override_spawn_name);
	}
}
spawn_blue_allies(override_spawn_name)
{
	temp = undefined;
	
	while(IsDefined( temp ) == false)
	{		
		temp = spawn_ally( "blueend1", override_spawn_name );
		if( !IsDefined(temp) )
		{
			wait 1;
		}
	}
	if( IsDefined(temp) )
	{
		temp setup_blue1();
	}
	temp = undefined;
	while(IsDefined( temp ) == false)
	{	
		temp = spawn_ally( "blueend2", override_spawn_name );
		
		if( !IsDefined(temp) )
		{
			wait 1;
		}	
	}
	if( IsDefined(temp) )
	{
		temp setup_blue2();	
	}
}

spawn_ally( allyName , overrideSpawnPointName )
{
	spawnname = undefined;
    if ( !IsDefined( overrideSpawnPointName ))
    {
        spawnname = level.start_point + "_" + allyName;
    }
    else
    {
        spawnname = overrideSpawnPointName + "_" + allyName;
    	
    }

    ally = spawn_noteworthy_at_struct_targetname( allyName , spawnname );
	
    return ally;
}
spawn_noteworthy_at_struct_targetname( noteworthyName , structName )
{
    noteworthy_spawner = getent( noteworthyName , "script_noteworthy" );
	noteworthy_start = getstruct( structName , "targetname" );
	if( IsDefined(noteworthy_spawner) && IsDefined(noteworthy_start) )
	{
		noteworthy_spawner.origin = noteworthy_start.origin;
		if(isdefined(noteworthy_start.angles))
		{
			noteworthy_spawner.angles = noteworthy_start.angles;
		}
		spawned = noteworthy_spawner spawn_ai();
	    return spawned;  
	}
	return undefined;
}

array_spawn_allow_fail( spawners, bForceSpawn )
{
	guys = [];
	foreach ( spawner in spawners )
	{
		spawner.count = 1;
		//spawner script_delay();
		guy = spawner spawn_ai( bForceSpawn );
		if ( IsDefined( guy ))
		{
			guys[ guys.size ] = guy;
		}
	}
	return guys;
}

array_spawn_with_delay( spawners, bForceSpawn )
{
	guys = [];
	foreach ( spawner in spawners )
	{
		spawner.count = 1;
		spawner script_delay();
		guy = spawner spawn_ai( bForceSpawn );
		if ( IsDefined( guy ))
		{
			guys[ guys.size ] = guy;
		}
	}
	return guys;
}

array_spawn_targetname_allow_fail( targetname )
{
//	IPrintLnBold("array spawn: "+targetname);
	spawners = GetEntArray( targetname, "targetname" );
	AssertEx( spawners.size, "Tried to spawn spawners with targetname " + targetname + " but there are no spawners" );
	return array_spawn_allow_fail( spawners );
}

array_spawn_targetname_with_delay( targetname )
{
//	IPrintLnBold("array spawn: "+targetname);
	spawners = GetEntArray( targetname, "targetname" );
	AssertEx( spawners.size, "Tried to spawn spawners with targetname " + targetname + " but there are no spawners" );
	return array_spawn_with_delay( spawners );
}


path_ignore_til_pathend()
{
	self endon( "death" );
	
	self ignore_everything();
	self waittill( "goal");
	self clear_ignore_everything();
}

set_flag_on_killcount( enemies , killcount , flag , timeout )
{
	waittill_dead_or_dying( enemies , killcount );
	flag_set( flag );
}

//Custom Spawn Functions

setup_spawn_funcs()
{

	level.custom_spawn_funcs = [];
	
	// [script_noteworthy | respawn_on_death] respawn the spawner when dead or dying
	level.custom_spawn_funcs["respawn_on_death"] = ::spawn_func_respawn_on_death ;
	
	// [script_noteworthy | ignore_till_path_end] ignores all until reaching goal node
	level.custom_spawn_funcs["ignore_till_path_end"] = ::spawn_func_ignore_till_path_end;

	// [script_noteworthy | delete_at_path_end] delete ai when he reaches his goal node
	level.custom_spawn_funcs["delete_at_path_end"] = ::spawn_func_delete_at_path_end;


	

	keys = getarraykeys(level.custom_spawn_funcs);
	foreach ( key in keys )
	{
		array = getentarray(key, "script_noteworthy");
		if(isdefined(array) && array.size)
		{
			array_spawn_function_noteworthy( key, level.custom_spawn_funcs[key] );
		}
	}	

}

// [script_noteworthy | ignore_till_path_end] ignores all until reaching goal node
spawn_func_ignore_till_path_end()
{
	self.ignoreall = true;
	self clearenemy();
	self waittill( "reached_path_end" );
	self.ignoreall = false;
}

// [script_noteworthy | delete_at_path_end] delete ai when he reaches his goal node
spawn_func_delete_at_path_end()
{
	self endon("death");
	self waittill( "reached_path_end" );
	if( IsDefined( self ) )
	{
		self Delete();
	}
}
// [script_noteworthy | respawn_on_death] respawn the spawner when dead or dying
spawn_func_respawn_on_death()
{
	// Hold on to this "temporary" variable that is set by the spawner when calling the spawn function
	spawner = self.spawner;
	
	// script_parameters is used to define an event to end the respawning on
	if ( IsDefined(spawner) && IsDefined(spawner.script_parameters) )
	{
		level endon(spawner.script_parameters);
	}
	
	self waittill_either( "death", "pain_death" );
	wait 1;
	
	// Keep trying to spawn the guy as long as the spawner still has more reserves
	guy = undefined;
	while ( !IsDefined(guy) && IsDefined(spawner) && IsDefined(spawner.count) && spawner.count > 0 )
	{
		guy = spawner spawn_ai();
		wait 1;
	}
}



ignore_everything()
{
	self.ignoreall = true;
	self.grenadeawareness = 0;
	self.ignoreexplosionevents = true;
	self.ignorerandombulletdamage = true;
	self.ignoresuppression = true;
	self.fixednode = false;
	self.disableBulletWhizbyReaction = true;
	self disable_pain();
	
	self.og_newEnemyReactionDistSq = self.newEnemyReactionDistSq;
	self.newEnemyReactionDistSq = 0;
}

clear_ignore_everything()
{
	self.ignoreall = false;
	self.grenadeawareness = 1;
	self.ignoreexplosionevents = false;
	self.ignorerandombulletdamage = false;
	self.ignoresuppression = false;
	self.fixednode = true;
	self.disableBulletWhizbyReaction = false;
	self enable_pain();
	
	if( IsDefined( self.og_newEnemyReactionDistSq ) )
	{
		self.newEnemyReactionDistSq = self.og_newEnemyReactionDistSq;
	}
}

setup_green1()
{
	self.animname = "generic";
	level.green1 = self;
	self.script_noteworthy = "greenend1";
	setup_foot_ally();
	self set_force_color( "green" );
}
setup_green2()
{
	self.animname = "generic";
	level.green2 = self;
	self.script_noteworthy = "greenend2";
	setup_foot_ally();
	self set_force_color( "green" );
}

setup_blue1()
{
	self.animname = "generic";
	level.blue1 = self;
	setup_foot_ally();
	self set_force_color( "blue" );
	self magic_bullet_shield();
	
}
setup_blue2()
{
	self.animname = "generic";
	level.blue2 = self;
	setup_foot_ally();
	self set_force_color( "blue" );
}


setup_foot_ally()
{
	self thread replace_on_death();
	self.baseAccuracy = 1.0;
	level notify( self.script_noteworthy + "_spawned" );
}

// temp_dialogue() - mock subtitle for a VO line not yet recorded and processed
//   <speaker>: Who is saying it?
//   <text>: What is being said?
//   <duration>: [optional] How long is to be shown? (default 4 seconds)
//   Example: thread temp_dialogue("Price", "There's Nikolai's chopper. They are all over him... hurry!");
temp_dialogue( speaker, text, duration )
{
    level notify("temp_dialogue", speaker, text, duration);
    level endon("temp_dialogue");
    
    if ( !IsDefined( duration ) )
    {
        duration = 4;
    }
    
    IPrintLnBold( speaker + ": " + text );
    wait duration;
}


//****************Ambience***********************//

allied_jets_ambient()
{

	pathnodes = [];
	pathnodes = GetVehicleNodeArray("end_f15_path","targetname");
	
	
	while(1)
	{
		rndindex = RandomIntRange(0, int(pathnodes.size));
		alliedjet = spawn_vehicle_from_targetname( "end_f15_ambient" );
		
		alliedjet Vehicle_Teleport(pathnodes[rndindex].origin, pathnodes[rndindex].angles );
		alliedjet StartPath(pathnodes[rndindex]);
		alliedjet waittill( "reached_end_node" );
		alliedjet Delete();
	}
}






//**************Objectives*******************//
objective_follow_sandman()
{
	flag_wait("allies_follow_sandman_to_breach");
	
	thread objective_hvt_breach();
	
	obj_position = level.red1.origin;
	hvtobj = obj( "Retrieve HVT" );
	
	Objective_OnEntity( hvtobj, level.red1, (0, 0, 70) );
		
	level waittill("slowmo_breach_ending");
	
	objective_complete(hvtobj);
	
	//Objective_Delete( hvtobj );
	
	
	
}




objective_streetsfollow_sandmansniper(  )
{
	// give everyone time to spawn in etc.
	wait 1;

	// Follow obj on Sandman, until....
	obj_position = level.red1.origin;
	hvtsnipe = obj( "followtosnipe" );
	Objective_Add( hvtsnipe, "current", &"HAMBURG_LOC_GOALPOST" );
	Objective_OnEntity( hvtsnipe, level.red1, (0, 0, 70) );
	flag_wait("sandman_at_breach");
	
	objective_complete( hvtsnipe );
	
}

objective_hvt_breach()
{
	flag_wait("sandman_at_breach");

	hvtobj2 = obj("hvt_breach");
	wait .5;
	
	Objective_Add( hvtobj2, "current", &"HAMBURG_SECURE_GOALPOST" );
	
	// put obj marker on breach door
	breach_obj = getstruct( "breach_obj_spot" , "targetname" );
	
	Objective_SetPointerTextOverride( hvtobj2 , &"SCRIPT_WAYPOINT_BREACH" );
	Objective_Position( hvtobj2 , breach_obj.origin );
	
	level waittill("slowmo_breach_ending");
	
	objective_complete(hvtobj2);

	
}


//**************End Objectives*******************//


SafeActivateTrigger( targetname )
{
	trigger = GetEnt( targetname, "targetname" );
	if(IsDefined( trigger ) )
	{
	   	trigger notify( "trigger" );
	   	trigger trigger_off();
	}
}


set_no_explode_vehicles()
{
	vehicles = GetEntArray( "streets_nobadplace", "targetname" );
	foreach( vehicle in vehicles )
	{
		vehicle vehicle_kill_badplace_forever();
	}
}

setup_vehicle_light_types()
{
	lightmodel = get_light_model( "vehicle_suburban" , "script_vehicle_suburban" );
	build_light( lightmodel , "headlight_right", "TAG_LIGHT_RIGHT_FRONT", "misc/car_headlight_suburban_R", 	"headlights" , 0.2 );
	build_light( lightmodel , "headlight_left", "TAG_LIGHT_LEFT_FRONT", "misc/car_headlight_suburban_L", 	"headlights" , 0.2 );
	build_light( lightmodel , "taillight_right", "TAG_LIGHT_RIGHT_TAIL", "misc/car_taillight_suburban_R", 	"headlights" , 0.2 );
	build_light( lightmodel , "taillight_left", "TAG_LIGHT_LEFT_TAIL", "misc/car_taillight_suburban_L", 	"headlights" , 0.2 );
}


