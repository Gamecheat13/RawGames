#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_game_module_meat_utility; 

/*
	Dead Pool
	Objective: 	Get to the end before your teammates
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
registers the race game module
------------------------------------*/
register_game_module()
{
	level.GAME_MODULE_MEAT_INDEX = 4;	
	maps\mp\zombies\_zm_game_module::register_game_module(level.GAME_MODULE_MEAT_INDEX,"meat",::meat_pre_init_func,::meat_post_init_func,undefined,::meat_zombie_post_spawn_init,::meat_hub_start_func);
}



onspawnplayer(predictedSpawn)
{

}


meat_hub_start_func(name)
{
	init_meat_variables();
	
	//turn off all the weapon buys
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" );
	for(i=0;i<weapon_spawns.size;i++)
	{
		weapon_spawns[i] trigger_off();
	}	
	
	match = get_registered_meat_match(name);
	set_current_meat_match(name);
	
	level thread [[match.match_start_func]]();	
	level thread [[match.match_end_func]]();
	
	level thread monitor_meat_on_side();
	level thread item_meat_watch_for_throw();
	level thread hold_meat_monitor();
	flag_wait("start_encounters_match_logic");
	level thread wait_for_team_death(1);
	level thread wait_for_team_death(2);
	
	level.team_A_downed = 0;
	level.team_B_downed = 0;
}


init_meat_variables()
{
	level._zombie_path_timer_override = ::zombie_path_timer_override;
	level.zombie_health = level.zombie_vars["zombie_health_start"];
	level._zombie_spawning = false;
	level._poi_override = ::meat_poi_override_func;
	level._meat_on_team = undefined;
	level._meat_zombie_spawn_timer = 2;
	level._meat_zombie_spawn_health = 1;
	level._minigun_time_override = 15;
	level._get_game_module_players = ::get_game_module_players;
	//level.zombie_custom_think_logic = ::meat_custom_think_logic; 
	level.powerup_drop_count = 0;	
  level.meat_spawners = level.zombie_spawners;
  if(!is_true(level._meat_callback_initialized))
  {
		maps\mp\zombies\_zm::register_player_damage_callback( maps\mp\zombies\_zm_game_module::damage_callback_no_pvp_damage );
  	level._meat_callback_initialized = true;
  }
	SetMatchTalkFlag( "DeadChatWithDead", 1 );
	SetMatchTalkFlag( "DeadChatWithTeam", 1 );
	SetMatchTalkFlag( "DeadHearTeamLiving", 1 );
	SetMatchTalkFlag( "DeadHearAllLiving", 1 );
	SetMatchTalkFlag( "EveryoneHearsEveryone", 1 ); 

	SetTeamHasMeat( "allies", false);
	SetTeamHasMeat( "team3", false);  

  level thread zmbMusicSetupMeat();
  level.zombie_spawn_fx = level._effect["spawn_cloud"];
}

setup_meat_world_objects()
{
	objects = getentarray(level.scr_zm_map_start_location,"script_noteworthy"); 
	
	for(i=0;i<objects.size;i++)
	{
		if(!objects[i] is_meat_object() )
		{
			continue;
		}
		
		if ( IsDefined( objects[ i ].script_gameobjectname ) )
		{
			continue;
		}
		
		if(isDefined(objects[i].script_vector))
		{
			objects[i] moveto(objects[i].origin + objects[i].script_vector,.05);
			objects[i]  waittill("movedone");
		}
		if(isDefined(objects[i].spawnflags) && objects[i].spawnflags == 1 && !is_true(level._dont_reconnect_paths))
		{
			objects[i] disconnectpaths();
		}	
	}
	
	level	clientnotify("meat_" + level.scr_zm_map_start_location);

}



reset_meat_world_objects()
{
	objects = getentarray(level.scr_zm_map_start_location,"script_noteworthy"); 
	
	for(i=0;i<objects.size;i++)
	{
		if(!objects[i] is_meat_object() )
		{
			continue;
		}
		
		if ( IsDefined( objects[ i ].script_gameobjectname ) )
		{
			continue;
		}
		
		if(isDefined(objects[i].spawnflags) && objects[i].spawnflags == 1 && !is_true(level._dont_reconnect_paths))
		{
			objects[i] connectpaths();
		}	
		
		if(isDefined(objects[i].script_vector))
		{
			objects[i] moveto(objects[i].origin - objects[i].script_vector,.05);
			objects[i]  waittill("movedone");
		}
	}
}


hide_non_meat_objects()
{
	
	//turn off door buys
	door_trigs = getentarray("zombie_door","targetname");
	for(i=0;i<door_trigs.size;i++)
	{
		if(isDefined(door_trigs[i]))
		{
			door_trigs[i] delete();//trigger_off();
		}
	}
	
	objects = getentarray(); 
	for(i=0;i<objects.size;i++)
	{
		if(objects[i] is_meat_object() )
		{
			continue;
		}		
		
		if(objects[i] IsZBarrier())
		{
			continue;
		}
	
		if(isDefined(objects[i].spawnflags) && objects[i].spawnflags == 1)
		{
			objects[i] connectpaths();
		}
		objects[i] notsolid();
		objects[i] hide();
	}

}

is_meat_object()
{

	if(!isDefined(self.script_parameters) )
	{
		return true;
	}
	tokens = strtok(self.script_parameters," ");
	
	for(i=0;i<tokens.size;i++)
	{
		if(tokens[i] == "meat_remove")
		{
			return false;
		}
	}
	return true;
}

clear_meat_variables()
{
	
	//turn weapon buys back on
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" );
	for(i=0;i<weapon_spawns.size;i++)
	{
		weapon_spawns[i] trigger_on();
	}	
	level._poi_override = undefined;
	level.custom_spawnPlayer  = undefined;
	level.customMaySpawnLogic = undefined;
	level._race_team_1_progress = undefined;
	level._race_team_2_progress = undefined;
	level._race_zombie_spawners_team_1 = undefined;
	level._race_zombie_spawners_team_2 = undefined;
	level._race_zombie_spawning = false;
	level._zombie_spawning = false;	
	level.round_prestart_func = undefined;
	level.powerup_drop_count = 0;
	level._game_module_point_adjustment = undefined;	
	level._meat_zombie_spawners = undefined;
	level._zombie_path_timer_override = undefined;
	
	SetMatchTalkFlag( "DeadChatWithDead", 0 );
	SetMatchTalkFlag( "DeadChatWithTeam", 0 );
	SetMatchTalkFlag( "DeadHearTeamLiving", 0 );
	SetMatchTalkFlag( "DeadHearAllLiving", 0 );
	SetMatchTalkFlag( "EveryoneHearsEveryone", 0 );
}


meat_pre_init_func()
{
	if ( level.scr_zm_game_module == level.GAME_MODULE_MEAT_INDEX )
	{		
		level thread init_item_meat();	
		OnPlayerConnect_Callback(::meat_on_player_connect);

		level.can_revive_game_module = ::can_revive;
	}
	
	level._effect["meat_marker"] = loadfx("maps/zombie/fx_zmb_meat_marker");
	level._effect["butterflies"] = loadfx("maps/zombie/fx_zmb_impact_noharm");
	level._effect["meat_glow"] = loadfx("maps/zombie/fx_zmb_meat_glow");
	level._effect["meat_glow3p"] = loadfx("maps/zombie/fx_zmb_meat_glow_3p");
	level._effect["spawn_cloud"] = loadfx("maps/zombie/fx_zmb_race_zombie_spawn_cloud");
	level._effect["fw_burst"] = loadfx("maps/zombie/fx_zmb_race_fireworks_burst_center");
	level._effect["fw_impact"] = loadfx("maps/zombie/fx_zmb_race_fireworks_drop_impact");
	level._effect["fw_drop"] = loadfx("maps/zombie/fx_zmb_race_fireworks_drop_trail");
	level._effect["fw_trail"] = loadfx("maps/zombie/fx_zmb_race_fireworks_trail");
	level._effect["fw_trail_cheap"] = loadfx("maps/zombie/fx_zmb_race_fireworks_trail_intro");
	level._effect["fw_pre_burst"] = loadfx("maps/zombie/fx_zmb_race_fireworks_burst_small");
	level._effect["meat_bounce"] = loadfx("maps/zombie/fx_zmb_meat_collision_glow");
}


init_item_meat()
{
	level.item_meat_name = "item_meat_zm";
	PrecacheItem( level.item_meat_name );
	level.start_item_meat_name = "item_meat_zm";

}

is_meat( weapon )
{
	return weapon == level.item_meat_name; 
}



meat_on_player_connect()
{
	self thread create_item_meat_watcher();
	self thread wait_for_player_downed();		
}

wait_for_player_downed()
{
	self endon("disconnect");
	while(isDefined(self))
	{
		self waittill_any("player_downed","fake_death","death");
		wait(.1); 	//give the meat a chance to be created in the world if the player threw it during the same frame that he went down
		if(isDefined(self._meat_team))
		{
			level thread check_should_save_player(self._meat_team);
			
			players = get_players_on_meat_team(self._meat_team);
			if( players.size >= 2 )
			{
				//TODO: C. Ayers - Verify this works in an 8-player setting before activating for everyone
				//self thread updateDownedCounters();
			}
		}
	}
}

updateDownedCounters()
{
	if( self._encounters_team == "A" )
	{
		level.team_A_downed++;
		self thread waitForRevive( "A" );
		level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "meat_revive_" + level.team_A_downed, "A" );
	}
	else
	{
		level.team_B_downed++;
		self thread waitForRevive( "B" );
		level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "meat_revive_" + level.team_B_downed, "B" );
	}
}
waitForRevive( team )
{
	self endon( "death" );
	
	self waittill( "player_revived" );
	
	if( team == "A" )
		level.team_A_downed--;
	else
		level.team_B_downed--;
}

create_item_meat_watcher()
{
	wait( 0.05 );//let the watcher system finish building first

	watcher = self maps\mp\gametypes\_weaponobjects::createUseWeaponObjectWatcher( "item_meat", level.item_meat_name, self.team );
	watcher.pickup = ::item_meat_on_pickup;
	watcher.onSpawn = ::item_meat_spawned; 
	watcher.onSpawnRetrieveTriggers = ::play_item_meat_on_spawn_retrieve_trigger;
	watcher.headIcon = false;
	
}


item_meat_spawned( unused0, unused1 )
{
	maps\mp\gametypes\_weaponobjects::voidOnSpawn( unused0, unused1 );
	self.meat_is_moving=false; 
	self.meat_is_flying=false; 
}

item_meat_watch_stationary()
{
	self endon( "death" );	
	self endon( "picked_up" );
	self.meat_is_moving=true; 
	self waittill("stationary");
	if(!is_true(self._fake_meat))
	{
		level._meat_moving = false;
		level._meat_splitter_activated = false;
	}

	self.meat_is_moving=false;
	if(isDefined(level._meat_on_team))
	{
		teamplayers = get_players_on_meat_team( level._meat_on_team );
		for(i=0;i<teamplayers.size;i++)
		{
			if( isdefined( teamplayers[i] ) && isdefined( teamplayers[i]._encounters_team ) )
			{
				level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "meat_land", teamplayers[i]._encounters_team );
				break;
			}
		}
	}
}

item_meat_watch_bounce()
{
	self endon( "death" );	
	self endon( "picked_up" );
	self.meat_is_flying=true; 
	self waittill("grenade_bounce",pos,normal,ent);
	if(isDefined(level.spawned_collmap))
	{
		if(isDefined(ent) && ent == level.spawned_collmap)
		{
			playfx(level._effect["meat_bounce"],pos,normal);
		}
	}
	if ( isdefined(ent) && isplayer( ent ) )
	{
		self.owner hit_player_with_meat( ent );
	}
	
	self.meat_is_flying=false; 

	self thread watch_for_roll();
	//play the "stationairy" effect when the meat bounces the first time
	playfxontag( level._effect["meat_marker"], self, "tag_origin"  );
}

watch_for_roll()
{
	self endon( "stationary" );	
	self endon( "death" );	
	self endon( "picked_up" );	
	self.meat_is_rolling = false;
	while(1)
	{
		old_z = self.origin[2];
		wait(1);
		if(abs(old_z - self.origin[2]) < 10 )
		{
			self.meat_is_rolling = true;
		}
	}
	
}

stop_rolling()
{
	self.origin = self.origin;
	self.angles = self.angles;
}


hit_player_with_meat( hit_player )
{
/#
	println( "MEAT: Player " + self.name + " hit " + hit_player.name + " with the meat\n");
#/
}


item_meat_pickup()
{
	self.meat_is_moving=false; 
	self.meat_is_flying=false; 
	level._meat_moving = false;
	level._meat_splitter_activated = false;
	self notify("picked_up");
}


player_wait_take_meat( meat_name )
{
	self endon( "meat_grabbed" ); // not necessary to do this if they pick it back up

	if (isdefined(self.pre_meat_weapon) && self hasweapon(self.pre_meat_weapon))
	{
		self SwitchToWeapon(self.pre_meat_weapon);
	}
	else
	{
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
		else
		{
			assert(0,"Player has no weapon");
			self maps\mp\zombies\_zm_weapons::give_fallback_weapon();
		}
	}

	self waittill( "weapon_change_complete" );
	self TakeWeapon( meat_name );
	self.pre_meat_weapon = undefined;
}

item_meat_on_spawn_retrieve_trigger( watcher, player, weaponname )
{
	self endon( "death" );	
	
	if ( isdefined( player ) )
	{
		self SetOwner( player );
		self SetTeam( player.pers["team"] );
		self.owner = player;
		self.oldAngles = self.angles;

		if ( player HasWeapon( weaponname ) && !player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			player thread player_wait_take_meat( weaponname );
			player decrement_is_drinking();
		}
		if(!is_true(self._fake_meat) )
		{
			if(!is_true(self._respawned_meat))
			{
				level notify("meat_thrown",player);
				level._last_person_to_throw_meat = player;
				level._last_person_to_throw_meat_time = GetTime();
			}
		}
	}
	if(!is_true(self._fake_meat) )
	{
		level._meat_moving = true;
		level.item_meat = self;
	}
	self playloopsound( "zmb_meat_looper", 2 );

	self thread item_meat_watch_stationary();
	self thread item_meat_watch_bounce();
		
	self.item_meat_pick_up_trigger = Spawn( "trigger_radius_use", self.origin, 0, 36, 72 );
	self.item_meat_pick_up_trigger SetCursorHint( "HINT_NOICON" );
	self.item_meat_pick_up_trigger SetHintString( &"ZOMBIE_MEAT_PICKUP" );
	self.item_meat_pick_up_trigger EnableLinkTo();
	self.item_meat_pick_up_trigger LinkTo( self );
	self.item_meat_pick_up_trigger TriggerIgnoreTeam();
	
	level.item_meat_pick_up_trigger = self.item_meat_pick_up_trigger;

	self thread item_meat_watch_trigger( self.item_meat_pick_up_trigger, watcher.pickUp, watcher.pickUpSoundPlayer, watcher.pickUpSound );

	self thread item_meat_watch_shutdown();	

	self thread kick_meat_monitor();
	self thread last_stand_meat_nudge();
	self._respawned_meat = undefined; //set this so that it doesn't break throwing this meat after it's been picked up
}

play_item_meat_on_spawn_retrieve_trigger( watcher, player )
{
	self item_meat_on_spawn_retrieve_trigger( watcher, player, level.item_meat_name );
}

start_item_meat_on_spawn_retrieve_trigger( watcher, player )
{
	self item_meat_on_spawn_retrieve_trigger( watcher, player, level.start_item_meat_name );
}



can_revive( revivee )
{
	if ( self HasWeapon( level.item_meat_name ) )
	{
		return false;
	}

	// if they haven't already started reviving, don't let them start when they are touching the meat trigger
	if ( !self maps\mp\zombies\_zm_laststand::is_reviving_any() && IsDefined( level.item_meat_pick_up_trigger ) && self IsTouching( level.item_meat_pick_up_trigger ) )
	{
		return false;
	}

	return true;
}


weapon_origin()
{
	origin = self GetTagOrigin("tag_weapon");
	if (!isdefined(origin))
		origin = self GetTagOrigin("tag_weapon_right");
	if (!isdefined(origin))
		origin = self get_eye();
	if (!isdefined(origin))
		origin = self.origin;
	return origin;
}

can_spike_meat() 
{
	if ( IsDefined( level._last_person_to_throw_meat ) && self == level._last_person_to_throw_meat )
	{
		return false;
	}

	meat = level.item_meat;
	meat_spike_dist_sq = 48 * 48;
	meat_spike_dot = 0.1;
	if (isdefined(meat))
	{
		view_pos = self GetWeaponMuzzlePoint();
		if ( distancesquared( view_pos, meat.origin ) < meat_spike_dist_sq )
		{
// dot product test disabled for the time being based on design feedback
//			forward_view_angles = self GetWeaponForwardDir();
//			normal = VectorNormalize( meat.origin - view_pos );
//			dot = VectorDot( forward_view_angles, normal );
//			if ( dot > 0 )
//			{
				return true;
//			}
		}
	}
	return false;
}

can_touch_meat()
{
// disabled until we have a check that lets playerss get meat from the other side of the fence
	return true; 
/*
	meat = level.item_meat;
	if (isdefined(meat))
	{
		trace = bullettrace( self weapon_origin(), meat.origin, 0, meat );
		return trace[ "position" ]==meat.origin;
	}
	return false;
*/
}

trying_to_use()
{
	self.use_ever_released |= !self UseButtonPressed();  
	return (self.use_ever_released && self UseButtonPressed());
}

trying_to_spike( item )
{
	//self.melee_ever_released |= !self MeleeButtonPressed();  
	return ( item.meat_is_flying /* && self.melee_ever_released */ && self MeleeButtonPressed() );
}

item_quick_trigger( trigger )
{
	self endon( "death" );
	meat_trigger_time = 150; // GetTime() is in milliseconds

	players = GET_PLAYERS();
	for ( i = 0; i < players.size; i++ )
	{
		player = players[ i ];
		player.use_ever_released = !player UseButtonPressed();  
		//player.melee_ever_released = !player MeleeButtonPressed();  
	}
	while ( IsDefined(trigger) )
	{
		players = GET_PLAYERS();
		random_start_point = randomint(players.size);
		for ( i = 0; i < players.size; i++ )
		{
			player = players[ (i+random_start_point) % players.size ];
			
			if ( player maps\mp\zombies\_zm_laststand::is_reviving_any() )
			{
				continue;
			}

			meleeing = player IsMeleeing();
			if( IsDefined(trigger) && 
			    player IsTouching(trigger) && 
				!player maps\mp\zombies\_zm_laststand::player_is_in_laststand() &&
				( player trying_to_use() || (self.meat_is_flying && meleeing) ) && 
				player can_touch_meat() 				)
			{
				if( self.meat_is_flying && meleeing )
				{
					if ( player can_spike_meat() )
					{
						player.trying_to_trigger_meat = false;
						trigger notify( "usetrigger", player );
					}
				}
				else if ( !is_true(player.trying_to_trigger_meat) )
				{
					player.trying_to_trigger_meat=true;
					player.trying_to_trigger_meat_time = GetTime();
				}
				else
				{
					if ( GetTime() - player.trying_to_trigger_meat_time >= meat_trigger_time )
					{
						player.trying_to_trigger_meat = false;
						trigger notify( "usetrigger", player );
					}
				}
			}
			else
			{
				player.trying_to_trigger_meat = false;
			}
		}
		wait 0.05;
	}
}

item_meat_watch_trigger( trigger, callback, playerSoundOnUse, npcSoundOnUse ) // self == weapon (for example: the claymore)
{
	self endon( "death" );

	self thread item_quick_trigger( trigger );

	while ( true )
	{
		trigger waittill( "usetrigger", player );
	
		if ( !isAlive( player ) )
			continue;

		if ( !is_player_valid( player ) )
		{
			continue;
		}	

		if ( player has_powerup_weapon() )
		{
			continue;
		}

		if ( player maps\mp\zombies\_zm_laststand::is_reviving_any() )
		{
			continue;
		}
		volley = self.meat_is_flying && player MeleeButtonPressed(); 
		player.volley_meat = volley;	

		if(is_true(self._fake_meat))
		{
			player playlocalsound("zmb_laugh_child");
			wait_network_frame();
			if(!isDefined(self))
			{
				return;
			}
			self delete();
			return;
		}	

		curr_weap = player GetCurrentWeapon();
		if ( !is_meat( curr_weap ) )
		{
			player.pre_meat_weapon = curr_weap;
		}

		if (self.meat_is_moving)
		{
			if ( volley )
				self item_meat_volley( player );
			else
				self item_meat_caught(player,self.meat_is_flying);
		}
		
		self item_meat_pickup();


		if ( isdefined( playerSoundOnUse ) )
			player playLocalSound( playerSoundOnUse );
		if ( isdefined( npcSoundOnUse ) )
			player playSound( npcSoundOnUse );
		
		if ( volley )
		{
			player thread spike_the_meat(self);
		}
		else
		{
			self thread [[callback]]( player );
			if(!isDefined(player._meat_hint_shown))
			{
				player thread show_meat_throw_hint();
				player._meat_hint_shown = true;
			}
		}


	}
}

item_meat_volley( player ) //self == meat
{
/#
	println("MEAT: Spiked the meat\n");
#/
}

item_meat_caught( player, in_air ) //self == meat
{
	if (in_air)
	{
/#
		println("MEAT: Caught the meat on the fly\n");
#/
	}
	else
	{
/#
		println("MEAT: Caught the meat while moving\n");
#/
	}
}


item_meat_on_pickup( player )
{
	assert( !player maps\mp\zombies\_zm_laststand::player_is_in_laststand(), "Player in last stand triggered meat pickup" );

	player maps\mp\gametypes\_weaponobjects::deleteWeaponObjectHelper( self );
	self destroy_ent();

	//SetDvar( "grenadeRollingEnabled", 1 );		
	level.item_meat = undefined;
	level._last_person_to_throw_meat = undefined;
	assign_meat_to_team( player );
	level notify( "meat_grabbed" );
	player notify( "meat_grabbed" );
	
	level thread zmbVoxMeatOnTeamSpecific( player._encounters_team );
	
	if ( !player HasWeapon( level.item_meat_name ) )
	{
		player GiveWeapon( level.item_meat_name );
	}

	player increment_is_drinking();
	player SwitchToWeapon( level.item_meat_name );
	player SetWeaponAmmoClip( level.item_meat_name, 1 );
}


item_meat_watch_shutdown() // self == weapon (for example: the claymore)
{
	self waittill( "death" );

	if ( IsDefined( self.item_meat_pick_up_trigger ) )
	{
		self.item_meat_pick_up_trigger delete();
		level.item_meat_pick_up_trigger = undefined;
	}
}


item_meat_clear()
{
	if ( isdefined( level.item_meat ) )
	{
		level.item_meat delete();
		level.item_meat = undefined;
	}
	if(isDefined(level._fake_meats))
	{
		foreach(meat in level._fake_meats)
		{
			if(isDefined(meat))
			{
				meat delete();
			}
		}
		level._fake_meats = undefined;
	}
	
}
/*------------------------------------
clears and resets the meat ( used as a failsafe if the meat gets stuck )
------------------------------------*/
item_meat_reset(origin)
{
	item_meat_clear();
	if(isDefined(origin))  
	{
		item_meat_spawn(origin);
	}
}

meat_post_init_func()
{
	if( level.scr_zm_game_module != level.GAME_MODULE_MEAT_INDEX ) // dp mode
	{ 
		return;
	}	

	game_mode_objects = getstructarray("game_mode_object","targetname");
	meat_objects = getstructarray("meat_object","targetname");
	
	all_structs = ArrayCombine(game_mode_objects,meat_objects, true, false);
	
	for(i=0;i<all_structs.size;i++)
	{
		if(isDefined(all_structs[i].script_parameters))
		{
				
			precachemodel(all_structs[i].script_parameters);
		}
	}
	precacheshellshock("tabun_gas_mp");
	PreCacheItem( "minigun_zm" );
	precacheshader("faction_cdc");
	precacheshader("faction_cia");
	precachemodel("p6_zm_sign_meat_01_step1");
	precachemodel("p6_zm_sign_meat_01_step2");
	precachemodel("p6_zm_sign_meat_01_step3");
	precachemodel("p6_zm_sign_meat_01_step4");	
}


// set up a normal individual zombie based on the round number
meat_zombie_post_spawn_init()
{
	self.maxhealth = maps\mp\zombies\_zm_race_utility::get_race_zombie_health(self._starting_round_number);
	self.health = maps\mp\zombies\_zm_race_utility::get_race_zombie_health(self._starting_round_number); 	
	self maps\mp\zombies\_zm_race_utility::set_race_zombie_run_cycle(self._starting_round_number); 
	
}


register_meat_match(start_func,end_func,name,meat_spawn_func,location)
{
	
	if(!isDefined(level._registered_meat_matches))
	{
		level._registered_meat_matches = [];
	}
	
	match = spawnstruct();
	match.match_name = name;
	match.match_start_func = start_func;
	match.match_end_func = end_func;
	match.match_meat_spawn_func = meat_spawn_func;
	match.match_location = location;
	match.mode_name = "zmeat";
	level._registered_meat_matches[level._registered_meat_matches.size] = match;
	
}

get_registered_meat_match(name,location)
{
	for(i=0;i<level._registered_meat_matches.size;i++)
	{
		if(isDefined(name))
		{
			if(level._registered_meat_matches[i].match_name == name)
			{
				return level._registered_meat_matches[i];
			}
		}
		
		if(isDefined(location))
		{
			if(level._registered_meat_matches[i].match_location == location)
			{
				return level._registered_meat_matches[i];
			}
		}
	}
}

set_current_meat_match(name)
{
	level._current_meat_match = name;
}

get_current_meat_match()
{
	return level._current_meat_match;
}


assign_meat_to_team(player,team_num)
{
	meat_team = undefined;
	players = GET_PLAYERS();
	
	if(isDefined(player))
	{
		for(i=0;i<players.size;i++)
		{
			if(!isDefined(players[i]))
			{
				continue;
			}	
			if(players[i] != player || is_true( player._meat_hint_shown))
			{
				players[i] iprintlnbold(player.name + " grabbed the meat!");
			}
		}
		meat_team  = player._meat_team;		
	}
	else if(isDefined(team_num))
	{
		for(i=0;i<players.size;i++)
		{
			if(players[i]._meat_team == team_num)
			{
				players[i] iprintlnbold("Your team has the meat!");
			}
			else
			{
				players[i] iprintlnbold("The other team has the meat!");
			}
		}			
		meat_team  = team_num;
	}
	
	level._meat_on_team = meat_team;

	// for ingame 3d scoreboard
	teamplayers = get_players_on_meat_team(meat_team);
	if (teamplayers[0]._encounters_team == "B" )
	{
		SetTeamHasMeat( "allies", true);
		SetTeamHasMeat( "team3", false);
	}
	else if (teamplayers[0]._encounters_team == "A" ) // team3/CIA
	{
		SetTeamHasMeat( "allies", false);
		SetTeamHasMeat( "team3", true);
	}

	for(i=0;i<players.size;i++)
	{
		if(!isDefined(players[i]))
		{
			continue;
		}	
		if(isDefined(player) && players[i] == player)
		{
			if(is_true(players[i]._has_meat))
			{
				continue;
			}
			players[i]._has_meat = true;
			players[i] thread create_meat_player_hud();
			players[i] thread slow_down_player_with_meat();			
			players[i] thread reset_meat_when_player_downed();
			players[i] thread reset_meat_when_player_disconnected();
			continue;			
		}

		players[i] thread create_meat_team_hud(meat_team);
		
	}

}

zmbVoxMeatOnTeamSpecific( team )
{	
	if( !isdefined( level.zmbVoxTeamLastHadMeat ) )
		level.zmbVoxTeamLastHadMeat = team;
	
	if( level.zmbVoxTeamLastHadMeat == team )
		return;
	
	level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "meat_grab", team );
	level.zmbVoxTeamLastHadMeat = team;
	
	otherteam = maps\mp\zombies\_zm_audio_announcer::getOtherTeam( team );
	level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "meat_grab_" + otherteam, otherteam );
}

create_meat_team_hud(meat_team,destroy_only)
{
	if(isDefined(self._has_meat_hud))
	{
		self._has_meat_hud destroy();
		if(isDefined(destroy_only))
		{
			return;
		}
	}
	
	if(!isDefined(meat_team))
	{
		return;
	}
	
	elem = NewClientHudElem(self);
	elem.hidewheninmenu = true;
	elem.horzAlign = "LEFT";
	elem.vertAlign = "BOTTOM";
	elem.alignX = "left";
	elem.alignY = "middle";
	elem.x = 10;
	elem.y = -10;
	elem.foreground = true;
	elem.font = "default";
	elem.fontScale = 1.4;
	elem.color = ( 0.9, 0.9, 0.0  );        
	elem.alpha = 1.0;
	
	if(isDefined(self._meat_team) && self._meat_team == meat_team)
	{
		elem.label = (&"ZOMBIE_TEAM_HAS_MEAT");
	}
	else
	{
		elem.label = (&"ZOMBIE_OTHER_TEAM_HAS_MEAT");
	}
	self._has_meat_hud = elem;
}

create_meat_player_hud()
{
	if(isDefined(self._has_meat_hud))
	{
		self._has_meat_hud destroy();
	}
	elem = NewClientHudElem(self);
	elem.hidewheninmenu = true;
	elem.horzAlign = "LEFT";
	elem.vertAlign = "BOTTOM";
	elem.alignX = "left";
	elem.alignY = "middle";
	elem.x = 10;
	elem.y = -10;
	elem.foreground = true;
	elem.font = "default";
	elem.fontScale = 1.4;
	elem.color = ( 0.9, 0.9, 0.0  );        
	elem.alpha = 1.0;

	elem.label = (&"ZOMBIE_PLAYER_HAS_MEAT");

	self._has_meat_hud = elem;
}

slow_down_player_with_meat()
{
	self endon("disconnect");
	self setclientflag(level._CLIENTFLAG_PLAYER_HOLDING_MEAT);
	self SetMoveSpeedScale(.6);
	self thread zmbVoxStartHoldCounter();
	while(is_true(self._has_meat))
	{
		level._meat_player_tracker_origin = self.origin;
		wait(.2);
	}
	self SetMoveSpeedScale(1);
	self clearclientflag(level._CLIENTFLAG_PLAYER_HOLDING_MEAT);

}
zmbVoxStartHoldCounter()
{
	meat_hold_counter = 0;
	while(is_true(self._has_meat))
	{
		if( meat_hold_counter >= 15 )
		{
			level thread maps\mp\zombies\_zm_audio_announcer::leaderDialogOnPlayer( "meat_hold" );
			break;
		}
		wait(.5);
		meat_hold_counter++;
	}
}

reset_meat_when_player_downed()
{
	self notify("reset_downed");
	self endon("reset_downed");
	level endon("meat_reset");
	level endon("meat_thrown");

	self waittill_any("player_downed","death","fake_death","replace_weapon_powerup");
		
	self._has_meat = false;
	self create_meat_team_hud(self._meat_team);

	self._spawning_meat = true;
	grenade = self MagicGrenadeType( level.item_meat_name, self.origin + (randomintrange(5,10),randomintrange(5,10),15), (randomintrange(5,10), randomintrange(5,10), 0) );
	grenade._respawned_meat = true;
	level._last_person_to_throw_meat = undefined;	
	playsoundatposition("zmb_spawn_powerup", self.origin);
	wait(.1);
	self._spawning_meat = undefined;
	level notify("meat_reset");
}

reset_meat_when_player_disconnected()
{
	level endon("meat_thrown");
	level endon("meat_reset");
	level endon("meat_end");
	
	team = self._meat_team;
	self waittill("disconnect");	
	level thread item_meat_drop(level._meat_player_tracker_origin,team);
}

item_meat_drop(org,team)
{
	players = get_alive_players_on_meat_team(team);
	if(players.size > 0)
	{
		player = players[0];
		player endon("disconnect");
		player._spawning_meat = true;
		grenade = player MagicGrenadeType( level.item_meat_name, org + (randomintrange(5,10),randomintrange(5,10),15), (0, 0, 0) );
		grenade._respawned_meat = true;
		level._last_person_to_throw_meat = undefined;	
		playsoundatposition("zmb_spawn_powerup", grenade.origin);
		wait(.1);
		player._spawning_meat = undefined;
		level notify("meat_reset");
	}
}


spawn_meat_zombie( spawner, target_name,spawn_point,round_number ) 
{ 
	level endon("meat_end");
	
	while(is_true(level._meat_zombie_spawning))
	{
		wait(.05);
	}
	
	level._meat_zombie_spawning = true;	

	level.zombie_spawn_locations = [];
	level.zombie_spawn_locations[level.zombie_spawn_locations.size] = spawn_point;
	
	zombie = maps\mp\zombies\_zm_utility::spawn_zombie( spawner, target_name , spawn_point, round_number);	
	zombie thread maps\mp\zombies\_zm_spawner::zombie_spawn_init();
	zombie thread maps\mp\zombies\_zm::round_spawn_failsafe();

	spawner._spawning = undefined;
	level._meat_zombie_spawning = false;
	
	return zombie;
}

meat_end_match()
{
	level waittill("meat_end",winning_team);
	
	//destroy the gamemodule specific hudelems
	players = GET_PLAYERS();
	for(i=0;i<players.size;i++)
	{
		if (is_true( players[i].has_minigun ) )
		{
			primaryWeapons = players[i] GetWeaponsListPrimaries();
		
			for( x = 0; x < primaryWeapons.size; x++ )
			{
				if( primaryWeapons[x] == "minigun_zm" )
				{
					players[i] TakeWeapon( "minigun_zm" );
				}
			}
	
			// this gives the player back their weapons
			players[i] notify( "minigun_time_over" );
			players[i].zombie_vars[ "zombie_powerup_minigun_on" ] = false;
			players[i]._show_solo_hud = false;
			players[i].has_minigun = false;
			players[i].has_powerup_weapon = false;
		}
		

		if(isDefined(players[i]._has_meat_hud))
		{
			players[i]._has_meat_hud destroy();
		}		
		if ( players[i] HasWeapon( level.item_meat_name ) && !players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			players[i] TakeWeapon( level.item_meat_name );
			players[i] decrement_is_drinking();
		}			
	}

	level notify("game_module_ended",winning_team);

	wait(.1); //gives it time to set the encounters match variables
	level delay_thread(2,	::item_meat_clear);
		
	if( is_true( level.gameEnded ) ) // somebody won so don't delete the ents ( for the scoreboard )
	{
		level clientnotify("end_meat");
		clear_meat_variables();
		reset_meat_world_objects();
	}
}

spawn_meat_zombies()
{
	level endon("meat_end");
	
	force_riser = false;
	force_chaser = false;
	num = 0;
	max_ai_num = 23;
	if(getdvarint("zm_encounters_cheat") > 0)
	{
		max_ai_num = 0;
	}
	if(getdvarint("zombie_cheat") == 2)
	{
		max_ai_num = -1;
	}

	level waittill("meat_grabbed");
	while(1)
	{
		ai = getaiarray("axis");
		if(ai.size > max_ai_num)
		{
			wait .1;
		}
		else
		{
			if(num %2 == 0)
			{
				spawn_points = level._meat_team_1_zombie_spawn_points;
			}
			else
			{
				spawn_points = level._meat_team_2_zombie_spawn_points;
			}
			num++;
			spawn_point = undefined;	
			distcheck = 128*128;
			while(!isDefined(spawn_point))
			{
				tries = 0;
				point = random(spawn_points);
				if(num %2 == 0)
				{
					players = get_players_on_meat_team(1);
				}
				else
				{
					players = get_players_on_meat_team(2);
				}
				clear = true;				
				foreach(player in players)
				{
					if(distancesquared(player.origin,point.origin) < distcheck  )
					{
						clear = false;
					}
				}
				if(clear)
				{
					spawn_point = point;
				}
				tries++;
				if(tries > 10)
				{
					spawn_point = point;
				}
				wait(.05);
			}			
			zombie = spawn_meat_zombie( level.meat_spawners[0], "meat_zombie",spawn_point,level._meat_zombie_spawn_health );
			zombie maps\mp\zombies\_zm_game_module::make_supersprinter();
		}
		wait(level._meat_zombie_spawn_timer);
	}
}

monitor_meat_on_team()
{
	level endon("meat_end");
	while(1)
	{
		players = GET_PLAYERS();
		if(isDefined(level._meat_on_team))
		{			
			for(i=0;i<players.size;i++)
			{
				if(!isDefined(players[i]))
				{
					continue;
				}	
				if(players[i]._meat_team == level._meat_on_team) //zombies only go after players on the meat team
				{
					if(players[i].ignoreme )
					{
						players[i].ignoreme= false;
					}
				}
				else
				{
					if(!players[i].ignoreme)
					{
						players[i].ignoreme = true;
					}
				}
				wait(.05);
			}
		}
		else
		{
			for(i=0;i<players.size;i++)
			{
				if(!isDefined(players[i]))
				{
					continue;
				}	
				if(players[i].ignoreme)
				{
					players[i].ignoreme = false;
				}
				wait(.05);
			}
		}
		wait(.1);
	}	
}

monitor_meat_on_side()
{	
	level endon("meat_end");
	
	level waittill("meat_grabbed");
	last_team = level._meat_on_team;
	while(1)
	{
		if(isDefined( level.item_meat)  )
		{
			if(level.item_meat istouching(level._meat_team_1_volume))
			{
				level._meat_on_team = 1;
			}
			else if(level.item_meat istouching(level._meat_team_2_volume))
			{
				level._meat_on_team = 2;
			}
		}
		if(isDefined(level._meat_on_team) && isDefined(last_team) && level._meat_on_team != last_team) //teams changed
		{
			//notify the zombies to stop ignoring the players for now
			level notify("clear_ignore_all");
			//set the trigger prompt for the correct team
					
//			//check to see if a downed player should be revived
//			players = get_players_on_meat_team(last_team);
//			foreach(player in players)
//			{
//				if(!player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
//				{
//					continue;
//				}
//				if(isDefined(level._last_person_to_throw_meat) && level._last_person_to_throw_meat == self)
//				{
//					level thread revive_saved_player(player);
//				}			
//			}
			
			last_team = level._meat_on_team;
			assign_meat_to_team(undefined,level._meat_on_team);
			/#
			if (isDefined(level.item_meat)) //play an effect where the meat is so we know it's changed sides
			{
				playfx(level._effect["spawn_cloud"],level.item_meat.origin);
			}
			#/
		}		
		wait(.05);
	}
}

meat_player_initial_spawn()
{
	//wait(5);	
	players = GET_PLAYERS();
	//players = array_randomize(players);

//	level._meat_team_1_spawn_points = getstructarray(team1_spawnpoints,"targetname");
//	level._meat_team_2_spawn_points = getstructarray(team2_spawnpoints,"targetname");
		
//	team_1_spots_assigned = 0;
//	team_2_spots_assigned = 0;	
	
	for(i=0;i<players.size;i++)
	{

		if(flag("switchedsides"))
		{
			players[i] maps\mp\gametypes\_zm_gametype::onSpawnPlayer();
		}
	
	 if(IsDefined(level.side_selection) && level.side_selection == 1)
	 {
	 		if(players[i].team == "allies")
	 		{
				players[i]._meat_team = 1;
			}
			else
			{
				players[i]._meat_team = 2;
			}		
		}	
		else
		{
	 		if(players[i].team == "allies")
	 		{
				players[i]._meat_team = 2;
			}
			else
			{
				players[i]._meat_team = 1;
			}	
		}	

	 

		
		if(isDefined(level.custom_player_fake_death_cleanup))
		{
			players[i] [[level.custom_player_fake_death_cleanup]]();
		}
		
		players[i] setstance("stand");
		
		if(isDefined(players[i]._meat_team))
		{
			
			if(players[i]._meat_team == 1)
			{
//				players[i] setorigin(level._meat_team_1_spawn_points[team_1_spots_assigned].origin);
//				players[i] setplayerangles (level._meat_team_1_spawn_points[team_1_spots_assigned].angles);
				players[i]._meat_team = 1;
//				players[i].spectator_respawn = level._meat_team_1_spawn_points[team_1_spots_assigned]; 
//				team_1_spots_assigned++;
			}
			else
			{
//				players[i] setorigin(level._meat_team_2_spawn_points[team_2_spots_assigned].origin);
//				players[i] setplayerangles (level._meat_team_2_spawn_points[team_2_spots_assigned].angles);
				players[i]._meat_team = 2;
//				players[i].spectator_respawn = level._meat_team_2_spawn_points[team_2_spots_assigned];
//				team_2_spots_assigned++;
			}
		}
		else
		{
			if(players[i].team == "team3")
			{
//				players[i] setorigin(level._meat_team_1_spawn_points[team_1_spots_assigned].origin);
//				players[i] setplayerangles (level._meat_team_1_spawn_points[team_1_spots_assigned].angles);
				players[i]._meat_team = 1;
//				players[i].spectator_respawn = level._meat_team_1_spawn_points[team_1_spots_assigned];
//				team_1_spots_assigned++;
			}
			else
			{
//				players[i] setorigin(level._meat_team_2_spawn_points[team_2_spots_assigned].origin);
//				players[i] setplayerangles (level._meat_team_2_spawn_points[team_2_spots_assigned].angles);
				players[i]._meat_team = 2;
//				players[i].spectator_respawn = level._meat_team_2_spawn_points[team_2_spots_assigned];
//				team_2_spots_assigned++;
			}
		}
		
		players[i].pers["zteam"] = players[i]._meat_team;
		
		players[i]  maps\mp\gametypes\_globallogic_score::initPersStat( "encounters_team",false );
		players[i]  maps\mp\gametypes\_globallogic_score::initPersStat( "characterindex",false );
		players[i]  maps\mp\gametypes\_globallogic_score::initPersStat( "team_name",false );
		players[i]  maps\mp\gametypes\_globallogic_score::initPersStat( "spectator_respawn",false );
				
		players[i].pers["encounters_team"] = players[i]._encounters_team;
		players[i].pers["characterindex"] = players[i].characterIndex;
		players[i].pers["team_name"] = players[i]._team_name;
		players[i].pers["meat_spectator_respawn"] = players[i].spectator_respawn;
		players[i].score = 1000;
		players[i].pers["score"] = 1000;
		players[i] takeallweapons();
		players[i] giveWeapon( "knife_zm" );
		players[i] give_start_weapon( true );
		if(!isDefined(players[i]._saved_by_throw))
		{
			players[i]._saved_by_throw = 0;
		}
		
		//in case they were holding the meat when the round/match ended
		players[i] SetMoveSpeedScale(1);
		players[i]._has_meat = false;
		players[i] clearclientflag(level._CLIENTFLAG_PLAYER_HOLDING_MEAT);
		
	}

	waittillframeend;
	maps\mp\zombies\_zm_game_module::start_round();
	
	level.switched = false;
	flag_set("switchedsides");

	award_grenades_for_team(1);
	award_grenades_for_team(2);
	
}


item_meat_watch_for_throw()
{
	//flag_wait("start_meat");
	level endon("meat_end");
	for(;;)
	{
		level waittill("meat_thrown",who);
		
		if(is_true(who._spawning_meat))
		{
			continue;
		}
		
		if( randomintrange(1,101) <= 10 )
		{
			//level thread maps\mp\zombies\_zm_audio::do_announcer_playvox( "zmeat", "ball_throw", who._encounters_team );
		}

		who._has_meat = false;
		
		if(isDefined(who._has_meat_hud))
		{
			who._has_meat_hud destroy();
		}
		assign_meat_to_team(undefined,level._meat_on_team);
	}
}


player_has_meat(player)
{
	return player getcurrentweapon() == level.item_meat_name;
}


get_player_with_meat()
{
	players = GET_PLAYERS();
	for(i=0;i<players.size;i++)
	{
		if(is_true(players[i]._has_meat))
		{
			return players[i];
		}
	}
	return undefined;
}

show_meat_throw_hint()
{
	level endon ("meat_thrown");
	self endon("player_downed");
	
	self thread meat_screen_message_delete_on_death();
	wait 1;
	
	self meat_create_hint_message(&"ZOMBIE_THROW_MEAT_HINT");
	self thread meat_screen_message_delete();
}




meat_create_hint_message( string_message_1, string_message_2, string_message_3, n_offset_y )
{

	if ( !IsDefined( n_offset_y ) )
	{
		n_offset_y = 0;
	}
	
	//handle displaying the first string
	if( !IsDefined(self._screen_message_1) )
	{
		//text element that displays the name of the event
		self._screen_message_1 = NewClientHudElem(self); 
		self._screen_message_1.elemType = "font";
		self._screen_message_1.font = "objective";
		self._screen_message_1.fontscale = 1.8;
		self._screen_message_1.horzAlign = "center";
		self._screen_message_1.vertAlign = "middle";
		self._screen_message_1.alignX = "center"; 
		self._screen_message_1.alignY = "middle";
		self._screen_message_1.y = -60 + n_offset_y;
		self._screen_message_1.sort = 2;
		
		self._screen_message_1.color = ( 1, 1, 1 );
		self._screen_message_1.alpha = 0.70;
		
		self._screen_message_1.hidewheninmenu = true;
	}

	//set the text of the element to the string passed in
	self._screen_message_1 SetText( string_message_1 );

	if( IsDefined(string_message_2) )
	{
		//handle displaying the first string
		if( !IsDefined(self._screen_message_2) )
		{
			//text element that displays the name of the event
			self._screen_message_2 = NewClientHudElem(self); 
			self._screen_message_2.elemType = "font";
			self._screen_message_2.font = "objective";
			self._screen_message_2.fontscale = 1.8;
			self._screen_message_2.horzAlign = "center";
			self._screen_message_2.vertAlign = "middle";
			self._screen_message_2.alignX = "center"; 
			self._screen_message_2.alignY = "middle";
			self._screen_message_2.y = -33 + n_offset_y;
			self._screen_message_2.sort = 2;

			self._screen_message_2.color = ( 1, 1, 1 );
			self._screen_message_2.alpha = 0.70;
			
			self._screen_message_2.hidewheninmenu = true;
		}
	
		//set the text of the element to the string passed in
		level._screen_message_2 SetText( string_message_2 );
	}
	else if( IsDefined(self._screen_message_2) )
	{
		self._screen_message_2 Destroy();
	}
	
	if( IsDefined(string_message_3) )
	{
		//handle displaying the first string
		if( !IsDefined(self._screen_message_3) )
		{
			//text element that displays the name of the event
			self._screen_message_3 = NewClientHudElem(self); 
			self._screen_message_3.elemType = "font";
			self._screen_message_3.font = "objective";
			self._screen_message_3.fontscale = 1.8;
			self._screen_message_3.horzAlign = "center";
			self._screen_message_3.vertAlign = "middle";
			self._screen_message_3.alignX = "center"; 
			self._screen_message_3.alignY = "middle";
			self._screen_message_3.y = -6 + n_offset_y;
			self._screen_message_3.sort = 2;

			self._screen_message_3.color = ( 1, 1, 1 );
			self._screen_message_3.alpha = 0.70;
			
			self._screen_message_3.hidewheninmenu = true;
		}
	
		//set the text of the element to the string passed in
		self._screen_message_3 SetText( string_message_3 );
	}
	else if( IsDefined(self._screen_message_3) )
	{
		self._screen_message_3 Destroy();
	}	
}


meat_screen_message_delete()
{
	self endon("disconnect");
	
	level waittill_notify_or_timeout("meat_thrown",5);
		
	if( IsDefined(self._screen_message_1) )
	{
		self._screen_message_1 Destroy();
	}
	if( IsDefined(self._screen_message_2) )
	{
		self._screen_message_2 Destroy();
	}
	if( IsDefined(self._screen_message_3) )
	{
		self._screen_message_3 Destroy();
	}	
}

meat_screen_message_delete_on_death()
{
	level endon("meat_thrown");
	self endon("disconnect");
	
	self waittill("player_downed");
	
	if( IsDefined(self._screen_message_1) )
	{
		self._screen_message_1 Destroy();
	}
	if( IsDefined(self._screen_message_2) )
	{
		self._screen_message_2 Destroy();
	}
	if( IsDefined(self._screen_message_3) )
	{
		self._screen_message_3 Destroy();
	}	
}


meat_poi_override_func()
{
	if(isDefined(level.item_meat) && is_true(level.item_meat.meat_is_moving)  )
	{
		if( abs(level.item_meat.origin[2] - groundpos( level.item_meat.origin)[2]) < 35 )
		{
			level._zombies_ignoring_all = false;
			level notify("clear_ignore_all");
			return undefined;
		}
		level thread set_ignore_all();
		meat_poi = [];
		meat_poi[0] = groundpos( level.item_meat.origin );
		meat_poi[1] = level.item_meat;
		return meat_poi;
	}
	level._zombies_ignoring_all = false;
	return undefined;
}
set_ignore_all()
{
	level endon("clear_ignore_all");
	if(is_true(level._zombies_ignoring_all))
	{
		return;
	}
	level._zombies_ignoring_all = true;
	
	zombies = getaiarray();
	foreach(zombie in zombies)
	{
		if(isDefined(zombie))
		{
			zombie.ignoreall = true;
		}
	}
	wait .5;
	clear_ignore_all();
	
}

clear_ignore_all()
{
	if(!is_true(level._zombies_ignoring_all))
	{
		return;
	}
	zombies = getaiarray();
	foreach(zombie in zombies)
	{
		if(isDefined(zombie))
		{
			zombie.ignoreall = false;
		}
	}
	level._zombies_ignoring_all = false;
}

zombie_path_timer_override()
{
	return gettime() + randomfloatrange(.35,1) * 1000;
}

zmbMusicSetupMeat()
{
	level.zmb_music_states["game_over"] = undefined;
	level thread maps\mp\zombies\_zm_audio::setupMusicState( "waiting", "ENC_WAITING", false, false, false, undefined );
	level thread maps\mp\zombies\_zm_audio::setupMusicState( "round_start", "ENC_ROUND_START", false, false, false, undefined );
	level thread maps\mp\zombies\_zm_audio::setupMusicState( "round_end", "ENC_ROUND_END", false, false, false, undefined );
	level thread maps\mp\zombies\_zm_audio::setupMusicState( "halftime", "ENC_HALFTIME", false, false, false, undefined );
	level thread maps\mp\zombies\_zm_audio::setupMusicState( "match_over", "ENC_MATCH_OVER", false, false, false, undefined );
}

hold_meat_monitor()
{
	level endon("meat_end");	
	
	level waittill("meat_grabbed");
	
	while(1) 
	{
		player = get_player_with_meat();
		if(!isDefined(player))
		{
			wait(.2);
			continue;
		}
		
		if( !should_try_to_bring_back_teammate(player._meat_team) )
		{
			wait (.2);
			continue;
		}
		
		if(!is_true(player._bringing_back_teammate))
		{
			player thread bring_back_teammate_progress();
		}
		wait(.2);
	}
}

bring_back_teammate_progress()
{
	self endon("disconnect");
	player = self;
	
	player._bringing_back_teammate = true;
	reviveTime = 15;
	progress = 0;
	while( player_has_meat(player) && is_player_valid(player)&& progress >= 0)
	{
		if ( !IsDefined( player.revive_team_progressbar ) )
		{
			player.revive_team_progressbar = player createPrimaryProgressBar();
			player.revive_team_progressbar updateBar( 0.01, 1 / reviveTime );	
			player.revive_team_progressbar.progressText = player createPrimaryProgressBarText();
			player.revive_team_progressbar.progressText setText( &"ZOMBIE_MEAT_RESPAWN_TEAMMATE" );
			player thread destroy_revive_progress_on_downed();
		}
		progress++;
		if(progress > reviveTime * 10 )
		{
			level bring_back_dead_teammate(player._meat_team);
			player destroy_revive_progress();
			wait(1);
			player._bringing_back_teammate = false;
			progress = -1;
		}
		wait(.1);
	}
	player._bringing_back_teammate = false;
	player destroy_revive_progress();		
}

should_try_to_bring_back_teammate(team)
{
	players = GET_PLAYERS();
	for(i=0;i<players.size;i++)
	{
		if( (players[i]._meat_team == team) && (players[i].sessionstate == "spectator"))
		{
			return true;
		}
	}
	return false;	
}

bring_back_dead_teammate(team)
{
	players = GET_PLAYERS();
	for(i=0;i<players.size;i++)
	{
		if( (players[i]._meat_team == team) && (players[i].sessionstate == "spectator"))
		{
			player = players[i];
			break;
		}
	}
	player playsound("zmb_laugh_child");
	wait(.25);
	Playfx( level._effect["poltergeist"], player.spectator_respawn.origin );
	playsoundatposition( "zmb_bolt", player.spectator_respawn.origin );
	Earthquake( 0.5, 0.75, player.spectator_respawn.origin, 1000);
	level.custom_spawnPlayer  = ::respawn_meat_player;				
	player.pers["spectator_respawn"] = player.spectator_respawn;
	player [[level.spawnPlayer]]();
	player delay_thread(.5,maps\mp\zombies\_zm_game_module::team_icon_intro);
	level.custom_spawnPlayer  = undefined;
	
}

respawn_meat_player()
{
	spawnpoint = self maps\mp\gametypes\_globallogic_score::getPersStat( "meat_spectator_respawn" );
	
	self spawn( spawnpoint.origin, spawnpoint.angles );	

	self._meat_team = self.pers["zteam"];
	self._encounters_team = self.pers["encounters_team"];
	self.characterIndex = self.pers["characterindex"];
	self._team_name = self.pers["team_name"];
	self.spectator_respawn = self.pers["meat_spectator_respawn"];
	self reviveplayer();
	self.is_burning = false;
	self.is_zombie = false;
	self.ignoreme = false;
}

destroy_revive_progress_on_downed()
{
	level endon("end_game");
	level endon("meat_end");
	
	self waittill_any("fake_death","player_downed","death");
	self destroy_revive_progress();
}

destroy_revive_progress()
{
	if(isDefined( self.revive_team_progressbar))
	{
		self.revive_team_progressbar destroyElem();
		self.revive_team_progressbar.progressText destroyElem();
	}
}

last_stand_meat_nudge()
{
	level endon("meat_grabbed");
	level endon("end_meat");
	self endon("death");

	// wait a few frames so the meat doesn't get rebuilt instantly
	wait( 0.15 );
	
	while(1)
	{
		players = GET_PLAYERS();
		foreach(player in players)
		{
			if( (distancesquared(player.origin,self.origin) < 48*48) && player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
			{
				player thread kick_the_meat(self,true);
			} 
		}
		wait(.05);
	}
	
}

kick_meat_monitor()
{
	level endon("meat_grabbed");
	level endon("end_meat");
	self endon("death");

	kick_meat_timeout = 150; // GetTime() is in milliseconds

	while(1)
	{
		players = GET_PLAYERS();
		curr_time = GetTime();
		foreach(player in players)
		{
			// don't let the most recent kicker kick it again for a couple frames, prevents the kick erroneously occurring multiple times over 1 or two frames and deadening the kick
			if ( IsDefined( level._last_person_to_throw_meat ) && player == level._last_person_to_throw_meat && ((curr_time - level._last_person_to_throw_meat_time) <= kick_meat_timeout) )
			{
				continue;
			}

			if ( (distancesquared( player.origin, self.origin ) < 48 * 48) && player IsSprinting() && !player usebuttonpressed() )
			{
				if(isDefined(player._meat_team) && isDefined(level._meat_on_team) && level._meat_on_team == player._meat_team)
				{
					player thread kick_the_meat(self);
				}
			} 
		}
		wait(.05);
	}
}

kick_the_meat(meat,laststand_nudge)
{
	if(is_true(self._kicking_meat))
	{
		return;
	}
	fake_meat = 0;
	self._kicking_meat = true;
	self._spawning_meat = true;	
	org = meat.origin;
	
	if(!is_true(meat._fake_meat))
	{
		meat delete();
		//level._meat_on_team = undefined;
		level._last_person_to_throw_meat = self;
		level._last_person_to_throw_meat_time = GetTime();
		level._meat_splitter_activated = false;
	}
	else
	{
		fake_meat = true;
		meat delete();
	}
	kickAngles = self.angles;
	kickAngles += (RandomFloatRange(-30, -20), RandomFloatRange(-5, 5), 0); //pitch up the angle
	launchDir = AnglesToForward(kickAngles);
	vel = self GetVelocity();
	speed = Length(vel) * 1.5;
	height_boost = 380;
	
	if(is_true(laststand_nudge))
	{
		if(vel == (0,0,0))
		{
			vel = (30,30,5);
		}
		speed = Length(vel)*2;
		height_boost = 120;
	}
 	launchvel = vectorscale(launchDir,speed);
 	 	
 	grenade = self MagicGrenadeType( level.item_meat_name, org , (launchvel[0],launchvel[1], height_boost));
	if(fake_meat)
	{
		grenade._fake_meat = true;
		grenade thread delete_on_real_meat_pickup();
		level._kicked_meat = grenade;
	}
	wait(.1);
	self._spawning_meat = false;	
	self._kicking_meat = false;
	if(!fake_meat)
	{
		level notify("meat_thrown",self);
		level notify("meat_kicked");
	}
}

spike_the_meat(meat)
{
	if(is_true(self._kicking_meat))
	{
		return;
	}
	fake_meat = 0;
	self._kicking_meat = true;
	self._spawning_meat = true;	
	org = meat.origin;
	vel = meat GetVelocity();
	
	if(!is_true(meat._fake_meat))
	{
		meat delete();
		//level._meat_on_team = undefined;
		level._last_person_to_throw_meat = self;
		level._last_person_to_throw_meat_time = GetTime();
		level._meat_splitter_activated = false;
	}
	else
	{
		fake_meat = true;
		meat delete();
	}
	kickAngles = self.angles;
	kickAngles += (RandomFloatRange(-30, -20), RandomFloatRange(-5, 5), 0); //pitch up the angle
	launchDir = AnglesToForward(kickAngles);
	speed = Length(vel) * 1.5;
 	launchvel = vectorscale(launchDir,speed);
 	 	
 	grenade = self MagicGrenadeType( level.item_meat_name, org , (launchvel[0],launchvel[1], 380));
	if(fake_meat)
	{
		grenade._fake_meat = true;
		grenade thread delete_on_real_meat_pickup();
		level._kicked_meat = grenade;
	}
	wait(.1);
	self._spawning_meat = false;	
	self._kicking_meat = false;
	if(!fake_meat)
	{
		level notify("meat_thrown",self);
		level notify("meat_kicked");
	}
}

delete_on_real_meat_pickup()
{
	if(!is_true(self._fake_meat))
	{
		return;
	}
	self endon("death");
	level waittill_any("meat_grabbed","end_game","meat_kicked");
	if(isDefined(level._kicked_meat) && level._kicked_meat == self)
	{
		level._kicked_meat = undefined;
	}
	if(isDefined(self))
	{
		self delete();
	}
}
