#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;


/*
	ZCON - Zombe containment Mode, wave based defensive gameplay
	Objective: 	Stay alive for as long as you can and prevent X number of zombies from escaping
	Map ends:	When all players die or X number of zombies escape
	Respawning:	No wait / Near teammates

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_tdm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of teammates and enemies
			at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["axis"] = "nva";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.

		If using minefields or exploders:
			maps\mp\_load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["american_soldiertype"] = "normandy";
			game["german_soldiertype"] = "normandy";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				american_soldiertype	normandy
				british_soldiertype		normandy, africa
				russian_soldiertype		coats, padded
				german_soldiertype		normandy, africa, winterlight, winterdark
*/

/*QUAKED mp_tdm_spawn (0.0 0.0 1.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_tdm_spawn_axis_start (0.5 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_tdm_spawn_allies_start (0.0 0.5 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/


// coop_player_spawn_placement()
// {
// 	structs = getstructarray( "initial_spawn_points", "targetname" ); 
// 
// 	temp_ent = Spawn( "script_model", (0,0,0) );
// 	for( i = 0; i < structs.size; i++ )
// 	{
// 		temp_ent.origin = structs[i].origin;
// 		temp_ent placeSpawnpoint();
// 		structs[i].origin = temp_ent.origin;
// 	}
// 	temp_ent Delete();
// 
// 	flag_wait( "start_zombie_round_logic" ); 
// 
// 	//chrisp - adding support for overriding the default spawning method
// 
// 	players = GET_PLAYERS(); 
// 
// 	for( i = 0; i < players.size; i++ )
// 	{
// 		players[i] setorigin( structs[i].origin ); 
// 		players[i] setplayerangles( structs[i].angles ); 
// 		players[i].spectator_respawn = structs[i];
// 	}
// }

/*------------------------------------
registers the supported game modules on this map
------------------------------------*/
register_game_module()
{
	level.GAME_MODULE_CONTAINMENT_INDEX = 1;	
	maps\mp\zombies\_zm_game_module::register_game_module(level.GAME_MODULE_CONTAINMENT_INDEX,"containment", maps\mp\zombies\_zm_containment::containment_pre_init,maps\mp\zombies\_zm_containment::containment_post_init);

}


containment_pre_init()
{
	if( level.scr_zm_game_module != level.GAME_MODULE_CONTAINMENT_INDEX ) // containment mode
	{ 
		return;
	}
	
	level.mutators["mutator_noBoards"] = 1;
}

containment_post_init()
{
	if( level.scr_zm_game_module != level.GAME_MODULE_CONTAINMENT_INDEX ) // containment mode
	{ 
		return;
	}
	
	level thread main();
}

//CONTAINMENT MODULE FOR ZOMBIEMODE

main()
{
	
	// ZCON - zombie containment
	if(GetDvar("max_zombie_escapees") == "")
	{
		SetDvar("max_zombie_escapees","25");
	}
	
	if(GetDvar("req_player_by_point") == "")
	{
		SetDvar("req_player_by_point","0");
	}
	
	if(GetDvar("player_move_point") == "")
	{
		SetDvar("player_move_point","0");
	}
	
	//player spawning logic
	level.zm_gamemodule_spawn_func = ::containment_OnPlayerSpawn;
	
	
	//zombie spawning logic
	level._zombie_custom_spawn_logic = ::zombie_goto_escape_point;
	
	//precachemodel("c_zom_moon_frozen_girl");
	level.round_prestart_func =::containment_prestart;
	
	precachemodel("TAG_ORIGIN");
	level.zombie_containment = true;
	level.max_escaped_zombies = GetDvarint("max_zombie_escapees");	// max number of zombies that can escape before the game is over
	level.require_players_by_point = GetDvarint("req_player_by_point"); //require the player to be near the defense point in order to reverse the meter
	level.player_causes_point_to_move = GetDvarint("player_move_point"); // if the player stands near the point then it moves
	
	//escape point fx
	level._effect["escape"] = loadfx ("maps/zombie/fx_zombie_exit_glow");//loadfx("misc/fx_ui_flagbase_orange");
	level._effect["escape_tail"] = loadfx("maps/zombie/zombie_fx_exit_marker");
	
	level thread init_containment();

	level.zombies_killed = 0;
	level.zombies_to_reduce_meter = 3;
}



/*------------------------------------
initialize everything
------------------------------------*/
init_containment()
{
	level.current_game_module = level.GAME_MODULE_CONTAINMENT_INDEX;	
	level.zone_occupied_func = ::escape_spot_in_zone;
	
 //wait a few seconds for everything to get initialized
	wait(4);
		
	//waits for the level to end
	level thread monitor_end_game();	
	level thread create_zombie_escape_spot();		
	level thread escape_spot_round_logic();
	level thread escape_spot_player_logic();
	level thread create_escape_progress_bar();
	level thread escape_spot_monitor();	

}

containment_prestart()
{
	
	SetDvar("zombie_unlock_all",1);
	
	//turn on the power first
	flag_set( "power_on" );
	
	players = GET_PLAYERS();
	
	//get all the door triggers and trigger them
	// DOORS ----------------------------------------------------------------------------- //
	zombie_doors = GetEntArray( "zombie_door", "targetname" ); 

	for( i = 0; i < zombie_doors.size; i++ )
	{
		zombie_doors[i] notify("trigger",players[0]);
		wait(.05);
	}

	// AIRLOCK DOORS ----------------------------------------------------------------------------- //
	zombie_airlock_doors = GetEntArray( "zombie_airlock_buy", "targetname" ); 

	for( i = 0; i < zombie_airlock_doors.size; i++ )
	{
		zombie_airlock_doors[i] notify("trigger",players[0]);
		wait(.05);
	}

	// DEBRIS ---------------------------------------------------------------------------- //
	zombie_debris = GetEntArray( "zombie_debris", "targetname" ); 

	for( i = 0; i < zombie_debris.size; i++ )
	{
		zombie_debris[i] notify("trigger",players[0]); 
		wait(.05);
	}

	wait( 1 );			
	SetDvar( "zombie_unlock_all", 0 );
	
	level thread set_round();
	
}

set_round()
{
	wait(10);

	target_round = 7 ;	
	level.devcheater = 1;
	level.zombie_total = 0;
	maps\mp\zombies\_zm::ai_calculate_health( target_round );
	level.round_number = target_round - 1;

	level notify( "kill_round" );

	//iprintln( "Jumping to round: " + target_round );
	wait( 1 );
	
	// kill all active zombies
	zombies = GetAiSpeciesArray( "axis", "all" );

	if ( IsDefined( zombies ) )
	{
		for (i = 0; i < zombies.size; i++)
		{
			if ( is_true( zombies[i].ignore_devgui_death ) )
			{
				continue;
			}
			zombies[i] dodamage(zombies[i].health + 666, zombies[i].origin);
		}
	}
	
}

/*------------------------------------
uses the spot (instead of players) to trigger active zones 
------------------------------------*/
escape_spot_in_zone( zone_name )
{
	in_zone = false;
	scr_org = spawn( "script_origin", level._current_cont_spot.origin +(0, 0, 40) );

	in_zone = scr_org maps\mp\zombies\_zm_zonemgr::entity_in_zone( zone_name );

	scr_org delete();

	return in_zone;
}

/*------------------------------------
creates the exit that the zombes path to
------------------------------------*/
create_zombie_escape_spot()
{

	//escape spot array
	level._cont_spots = getstructarray("zcon_escape_spot","targetname");	
	level._current_cont_spot = getstruct("zcon_start","script_noteworthy");
	
	//wait(5);
	
	//set up the effect & trigger
	level.escape_spot_fx = spawn("script_model",level._current_cont_spot.origin );		
	level.escape_spot_fx setmodel("TAG_ORIGIN");
	wait(.1);
	
	trace = bullettrace(level.escape_spot_fx.origin + (0,0,50),level.escape_spot_fx.origin + (0,0,-60),0,undefined);
	level.escape_spot_fx rotateTo( vectortoangles( trace["normal"] ), 0.1 );	
		
	playfxontag(level._effect["escape"],level.escape_spot_fx,"TAG_ORIGIN");
	playfxontag(level._effect["escape_tail"],level.escape_spot_fx,"TAG_ORIGIN");	
	
	if(isDefined(level._effect[ "black_hole_bomb_portal_exit" ]))
	{
		playfxontag(level._effect[ "black_hole_bomb_portal_exit" ],level.obj_spot,"tag_origin");
	}
	
	level.escape_spot = spawn("trigger_radius", level.escape_spot_fx.origin , 9, 48, 48*2);
	
	//this runs on the trigger and waits for zombies
	level.escape_spot thread wait_for_zombie_to_esacpe();
	
	
	//create the point of interest for the zombies
	level.escape_spot_fx create_zombie_point_of_interest( undefined, 30, 0, false );
	level.escape_spot_fx thread create_zombie_point_of_interest_attractor_positions( 4, 45 );
	level.current_poi = level.escape_spot_fx;
	
		
	//Objective_Add(1, "current", "Prevent zombies from escaping", level.obj_spot);
	//Objective_Set3D(1, true, (1, 1, 1), "Defend");
	
	
}
rotate_sam()
{
	z = 0;
	while(1)
	{
		self.angles = self.angles + (0,1,0);
		wait(.05);
	}
}

/*------------------------------------
zombs go to the exit point, sometimes attacking players along the way if they can
------------------------------------*/
zombie_goto_escape_point()
{
	self endon("death");
	level endon("end_game");
	level endon ("fake_death");
	
	self thread zombie_wait_for_death();
	
	//35% chance of a guy never attacking the player on the way to the escape point
	if(randomint(100)>65)
	{
		self.ignore_goal = false;
	}
	else
	{
		self.ignore_goal = true;
	}
	
	enemyoverride = [];
	enemyoverride[0] = level.current_poi.origin;
	enemyoverride[1] = level.current_poi;
	
	
	//this runs on the guy until he dies
	while(isDefined(self) && isAlive(self) && !level.intermission)
	{
		
		//self.goalradius = 48;
		//self.maxsightdistsqrd = 64*64;
				
		//grab the closest player and calculate the distances between player/zombie and zombie/exit spot	
		player = get_closest_valid_player( self.origin, undefined );
		
		if(!isDefined(player))
		{
			wait_network_frame();
			continue;
		}
				
		dist_to_player = distancesquared(player.origin,self.origin);
		dist_to_goal = distancesquared(level.escape_spot.origin,self.origin);
		
		//attack the player if his .ignore_player flag is not set, he is less than 256 units away, and he's not close to the goal
		//otherwise, go to the exit goal
		if(dist_to_player < 128*128 && self.ignore_goal)
		{
			self.enemyoverride = undefined;//setgoalentity(player);
		}
		else
		{
			self.enemyoverride = enemyoverride;
			//self setgoalentity(level.escape_spot);
		}	
		wait(.5);			
	}	
}


zombie_wait_for_death()
{
	self waittill("death");
	if(isDefined(self.attacker) && isPlayer(self.attacker))
	{
		if(level.require_players_by_point)
		{
			if ( distancesquared(self.attacker.origin,level.escape_spot.origin) > 256*256)
			{
				return;
			}
		}

		level.zombies_killed++;
		if ( level.zombies_killed >= level.zombies_to_reduce_meter )
		{
			level.zombies_killed = 0;

			if(level.escaped_zombies -1 > 0)
			{
				level.escaped_zombies--;
				//level.escape_count.label = level.escaped_zombies + " of 25 zombies have escaped";
			}			
		}
	}
	players = GET_PLAYERS();
	for(i=0;i<players.size;i++)
	{
		players[i].escape_progress thread maps\mp\gametypes\_hud_util::updateBarScale( level.escaped_zombies/level.max_escaped_zombies);
	}
}

create_escape_progress_bar()
{
////	//flag_wait("all_players_spawned");
	players = GET_PLAYERS();
	for(i=0;i<players.size;i++)
	{
		players[i] maps\mp\zombies\_zm_score::add_to_player_score( 500 );
////		players[i].escape_progress = players[i] maps\mp\gametypes\_hud_util::createPrimaryProgressBar();
////		players[i].escape_progress  maps\mp\gametypes\_hud_util::setPoint( "CENTER", "TOP", -200,40);
	}	
}

/*------------------------------------
this is run on the trigger which 
acts as the escape point for the zombie
------------------------------------*/
wait_for_zombie_to_esacpe()
{
	
	//number of zombies to kill
	
	//create the hud element
	  level.escaped_zombies = 0;	
	//level.escape_count = NewHudElem();
	//level.escape_count.alignX = "left";
	//level.escape_count.fontScale = 1.2;
	//level.escape_count.x = 50;
	//level.escape_count.y = 50;
	//level.escape_count.label = level.escaped_zombies + " of " + level.max_escaped_zombies + " zombies have escaped";
	
	//
	while(1)
	{
		self waittill("trigger",who);
		
		if(isDefined(self.is_moving_to_spot))
		{
			continue;
		}
		
		if(!isPlayer(who))
		{
			org = who.origin;
			who.a.nodeath = true;
			if(isDefined(who.headModel))
			{
				who.headModel delete();
			}
			who delete();
			
			if(isDefined(level._effect[ "black_hole_bomb_zombie_destroy" ]))
			{
				PlayFX( level._effect[ "black_hole_bomb_zombie_destroy" ], org  );
			}
			else
			{
				playfx(level._effect["poltergeist"],org + (0,0,10));
			}
			
			playsoundatposition ("lightning_l",org );
			level.escaped_zombies ++;
			//level.escape_count.label = level.escaped_zombies + " of 25 zombies have escaped";
			
			players = GET_PLAYERS();
	
			for(i=0;i<players.size;i++)		
			{
			
				players[i].escape_progress thread maps\mp\gametypes\_hud_util::updateBarScale( level.escaped_zombies/level.max_escaped_zombies);
			}
			
			
			if(level.escaped_zombies > level.max_escaped_zombies - 1)
			{
				iprintlnbold("Too many zombies have escaped!");
				wait(2);
				level notify("end_game");
				maps\mp\zombies\_zm::end_game();
				return;
			}
		}
		wait .1;
	}
}

/*------------------------------------
check to see if we should move the escape spot
------------------------------------*/
escape_spot_round_logic()
{	
	level waittill("between_round_over"); // hack to fix it not moving the first time after it adjusts to round 3
	while(1)
	{
		
		level waittill_either("between_round_over","player_moved_spot");
		
		spots=level._cont_spots;
		ArrayRemoveValue(spots,level._current_cont_spot);
		//pick the new spot
		new_spot = random(spots);
		level._current_cont_spot = new_spot;
		level notify("move_spot",new_spot);
		level.last_exit_moved = level.escaped_zombies;
		
	}
}


//move the escape spot if the player is standing too close to it for too long
escape_spot_player_logic()
{
	if(!is_true( level.player_causes_point_to_move	))
	{
		return;
	}
	
	level endon("end_game");
	
	dist_check = 128*128;
	zombie_dist_check = 200*200;
	should_move = false;
	
	while(1)
	{
		if(isDefined(level.escape_spot.is_moving_to_spot))
		{
			wait(.1);
			continue;
		}
		should_move = false;
		
		//check to see if a player is touching the spot
		players = GET_PLAYERS();
		for(i=0;i<players.size;i++)
		{
			player = players[i];
			if(distancesquared(player.origin,level.escape_spot.origin) < dist_check)
			{
				should_move = true;
			}
		}
		
		wait(2);
		
		//if zombies are nearby we should not move the point
		if(should_move)
		{
			zombies = GetAiSpeciesArray( "axis", "all" );
			
			if ( IsDefined( zombies ) )
			{
				for (i = 0; i < zombies.size; i++)
				{
					if (distancesquared( zombies[i].origin,level.escape_spot.origin ) < zombie_dist_check )
					{
						should_move = false;
					}
				}
			}
		}
		
		//if no zombies then re-check the players to make sure there is still someone nearby		
		if(should_move)
		{
			nearby = 0;
			players = GET_PLAYERS();
			for(i=0;i<players.size;i++)
			{
				player = players[i];
				if(distancesquared(player.origin,level.escape_spot.origin) < dist_check)
				{
					nearby++;
				}
			}
			if(nearby == 0)
			{
				should_move = false;
			}
		}
		
		if(should_move)
		{
			level notify("player_moved_spot");
		}		
		wait(.1);
	}
}




/*------------------------------------
moves the exit spot to a new position 
------------------------------------*/
escape_spot_monitor()
{
	
	while(1)
	{
		level waittill("move_spot",new_spot);
		
		if(isDefined(level.escape_spot.is_moving_to_spot))
		{
			continue;
		}		
		
		//set this flag so we know it's moving and don't accidently keep getting zombies while it's moving
		level.escape_spot.is_moving_to_spot = true;		

	  level.current_poi deactivate_zombie_point_of_interest();
		
		//play a sound 
		level.escape_spot_fx playsound("zmb_laugh_child");
		
		//move the fx spot
		level.escape_spot_fx moveto(new_spot.origin,20);
		//level.obj_spot moveto(new_spot + (0,0,20) ,20);
		
	
		//set the origin of the trigger
		level.escape_spot.origin = new_spot.origin;
		
		//wait for the fx marker to finish moving, then turn the trigger back 'on' 
		//level.obj_spot waittill("movedone");
		level.escape_spot_fx waittill("movedone");
		
		level.escape_spot_fx create_zombie_point_of_interest( undefined, 30, 0, false );
		level.escape_spot_fx thread create_zombie_point_of_interest_attractor_positions( 4, 45 );
		level.current_poi = level.escape_spot_fx;
		
		wait(.5);
		level.escape_spot.is_moving_to_spot = undefined;
		
		
	}
		
}

/*------------------------------------
waits for the level to end and sends a notification
------------------------------------*/
monitor_end_game()
{
	while(!level.intermission )
	{
		wait_network_frame();
	}
	level notify("end_game");
}


containment_OnPlayerSpawn()
{
		if(!isDefined(self.escape_progress))
		{
			self.escape_progress = self maps\mp\gametypes\_hud_util::createPrimaryProgressBar();
			self.escape_progress  maps\mp\gametypes\_hud_util::setPoint( "CENTER", "TOP", -200,40);
		}
}