#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\gametypes\_zm_gametype;

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio_announcer;
#using scripts\zm\_zm_utility;

#namespace zm_game_module;

/*------------------------------------
Handles registration of any game modules
------------------------------------*/
function register_game_module(index,module_name,pre_init_func,post_init_func,pre_init_zombie_spawn_func,post_init_zombie_spawn_func,hub_start_func)
{
	if(!isdefined(level._game_modules))
	{
		level._game_modules = [];
		level._num_registered_game_modules = 0;
	}	
	
	for(i=0;i<level._num_registered_game_modules;i++)
	{
		if(!isdefined(level._game_modules[i]))
		{
			continue;
		}
		if(isdefined(level._game_modules[i].index) && level._game_modules[i].index == index)
		{
			assert(level._game_modules[i].index != index,"A Game module is already registered for index (" + index + ")" );
		}
	}
	
	level._game_modules[level._num_registered_game_modules] = spawnstruct();
	level._game_modules[level._num_registered_game_modules].index = index;
	level._game_modules[level._num_registered_game_modules].module_name = module_name;
	level._game_modules[level._num_registered_game_modules].pre_init_func = pre_init_func;
	level._game_modules[level._num_registered_game_modules].post_init_func = post_init_func;
	level._game_modules[level._num_registered_game_modules].pre_init_zombie_spawn_func = pre_init_zombie_spawn_func;
	level._game_modules[level._num_registered_game_modules].post_init_zombie_spawn_func = post_init_zombie_spawn_func;
	level._game_modules[level._num_registered_game_modules].hub_start_func = hub_start_func;
	level._num_registered_game_modules++;	
}

function set_current_game_module(game_module_index)
{
	if(!isdefined(game_module_index))
	{
		level.current_game_module = level.GAME_MODULE_CLASSIC_INDEX;
		level.scr_zm_game_module = level.GAME_MODULE_CLASSIC_INDEX;
		return;
	}
	game_module = get_game_module(game_module_index);
	
	if(!isdefined(game_module))
	{
		assert(isdefined(game_module),"unknown game module (" + game_module_index + ")" );
		return;
	}	
	
	level.current_game_module = game_module_index;	
}

function get_current_game_module()
{
	return get_game_module(level.current_game_module);
}

function get_game_module(game_module_index)
{
	
	if(!isdefined(game_module_index))
	{
		return undefined;
	}
		
	for(i=0;i<level._game_modules.size;i++)
	{
		if(level._game_modules[i].index == game_module_index)
		{
			return level._game_modules[i];
		}
	}	
	return undefined;
}

/*------------------------------------
function function that should run at the beginning of "zombie_spawn_init() " in _zm_spawner
------------------------------------*/
function game_module_pre_zombie_spawn_init()
{
	current_module = get_current_game_module();
	if(!isdefined(current_module) || !isdefined(current_module.pre_init_zombie_spawn_func))
	{
		return;
	}
	
	self [[current_module.pre_init_zombie_spawn_func]]();
}

/*------------------------------------
function function that should run at the end of "zombie_spawn_init() " in _zm_spawner
------------------------------------*/
function game_module_post_zombie_spawn_init()
{
	current_module = get_current_game_module();
	if(!isdefined(current_module) || !isdefined(current_module.post_init_zombie_spawn_func))
	{
		return;
	}
		
	self [[current_module.post_init_zombie_spawn_func]]();
}

function kill_all_zombies()
{
	ai = zombie_utility::get_round_enemy_array();

	foreach ( zombie in ai )
	{
		if ( isdefined( zombie ) )
		{
			zombie DoDamage( zombie.maxhealth * 2, zombie.origin, zombie, zombie, "none", "MOD_SUICIDE" );
			{wait(.05);};
		}
	}
}

function freeze_players(freeze)
{			
	players = GetPlayers();
	for(i=0;i<players.size;i++)
	{
		players[i] util::freeze_player_controls( freeze );
	}
}  	

function respawn_spectators_and_freeze_players()
{
	players = GetPlayers();
	foreach(player in players)
	{
		if(player.sessionstate == "spectator")
		{
			if(isdefined(player.spectate_hud))
			{
				player.spectate_hud destroy();
			}	
			player [[level.spawnPlayer]]();
		}
		player util::freeze_player_controls( true );
	}
}

function damage_callback_no_pvp_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, eapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if(isdefined(eAttacker) && isplayer( eAttacker) && eAttacker == self) //player can damage self
	{
		return iDamage;
	}
	if(isdefined(eAttacker) && !isPlayer(eAttacker))
	{
		return iDamage;
	}
	if(!isdefined(eAttacker))
	{
		return iDamage;
	}
	return 0;
}


function respawn_players()
{
	players = GetPlayers();
	foreach(player in players)
	{		
		player [[level.spawnPlayer]]();
		player util::freeze_player_controls( true );
	}
}


function zombie_goto_round( target_round )
{
	level notify( "restart_round" );
		
	if ( target_round < 1 )
	{
		target_round = 1;
	}

	level.zombie_total = 0;
	zombie_utility::ai_calculate_health( target_round );
	// kill all active zombies
	zombies = zombie_utility::get_round_enemy_array();
	if ( isdefined( zombies ) )
	{
		for (i = 0; i < zombies.size; i++)
		{
			zombies[i] dodamage(zombies[i].health + 666, zombies[i].origin);
		}
	}
	respawn_players();
	wait(1);
}


function wait_for_team_death_and_round_end()
{	
	level endon( "game_module_ended" );
	level endon("end_game");
	
	checking_for_round_end = false;
	level.isresetting_grief = false;
	
	while( 1 )
	{
		CDC_Alive = 0;
		CIA_Alive = 0;
		
		players = GetPlayers();
		
		foreach ( player in players )
		{
			if(!isdefined(player._encounters_team))
			{
				continue;
			}
			if ( player._encounters_team == "A" )
			{				
				if ( zm_utility::is_player_valid(player) )				//|| ( IS_TRUE( level.force_solo_quick_revive ) && isdefined( player.lives ) && player.lives > 0 ) )
				{
					CIA_Alive++;
				}
			}
			else
			{
				if ( zm_utility::is_player_valid(player) )			//if ( isdefined( player ) || ( IS_TRUE( level.force_solo_quick_revive ) && isdefined( player.lives ) && player.lives > 0 ) )
				{
					CDC_Alive++;
				}
			}
		}
	
		if( (CIA_Alive) == 0 && (CDC_ALIVE) == 0 && !level.isresetting_grief && !( isdefined( level.host_ended_game ) && level.host_ended_game ) )
		{	
			wait(.5); // to allow for the is_drinking system to do it's thing
			
			//Everyone is  DEAD - reset round and make sure everyone is respawned
			
			//temp hud message
			if(isdefined(level._grief_reset_message))
			{
				level thread [[level._grief_reset_message]]();
			}
			
			level.isresetting_grief = true;
			
			level notify("end_round_think");


			level.zombie_vars[ "spectators_respawn" ] = 1;
			level notify( "keep_griefing" );	//If everyone is dead then keep going
			checking_for_round_end = false;
			zombie_goto_round( level.round_number );
			level thread reset_grief();
			
			level thread zm::round_think(true);

			/*foreach ( player in players )
			{
				player DisableInvulnerability();
			}*/


			/*players = GetPlayers();
			foreach ( player in players )
			{
				player EnableInvulnerability();
			}
			
			level notify( "keep_griefing" );	//If everyone is dead then keep going
			checking_for_round_end = false;
			level thread zombie_goto_round( level.round_number );
			level waittill( "between_round_over" );
			
			players = GetPlayers();
			foreach ( player in players )
			{
				player DisableInvulnerability();
			}*/
		}
		else
		{
			if( !checking_for_round_end )
			{
				if ( CIA_Alive == 0 )
				{
					level thread check_for_round_end( "B" );
					checking_for_round_end = true;
				}
				else if ( CDC_ALIVE == 0 )
				{
					level thread check_for_round_end( "A" );
					checking_for_round_end = true;
				}
			}
		}
		
		if(CIA_ALIVE > 0 && CDC_ALIVE > 0)
		{
			level notify("stop_round_end_check");
			checking_for_round_end = false;
		}
		
		{wait(.05);};
	}
}

function reset_grief()
{
	//wait for players to all get respawned
	wait(1);
	level.isresetting_grief = false;
}

function check_for_round_end( winner )
{
	level endon( "keep_griefing" );
	level endon( "stop_round_end_check");
	
	//IF we reach the round end then end the game, else keep going
	level waittill( "end_of_round" );
	level.gameModuleWinningTeam = winner;
	level.zombie_vars[ "spectators_respawn" ] = 0;	
	
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] freezecontrols(true);
		if(players[i]._encounters_team == winner)
		{
			players[i] thread zm_audio_announcer::leaderDialogOnPlayer( "grief_won" );
		}
		else
		{
			players[i] thread zm_audio_announcer::leaderDialogOnPlayer( "grief_lost" );
		}
	}
	
	
	level notify( "game_module_ended", winner );
	
	
	//level.no_end_game_check = false;
	level._game_module_game_end_check = undefined;

	zm_gametype::track_encounters_win_stats( level.gameModuleWinningTeam );
	
	
	//Game ENDS - we have a winner
	level notify("end_game");

	/*
	level thread zm_audio::zmbVoxCrowdOnTeam( "win", winner, "lose" );
	level thread zm_audio_announcer::announceMatchWinner( winner );
		
	level zm_gametype::create_final_score();

	zm_gametype::track_encounters_win_stats( winner );
	
	zm::intermission();
	
	level.can_revive_game_module = undefined;

	//do final score here
	level notify("end_game");
	*/
}



function wait_for_team_death()
{	
	// TEMP
	wait ( 15 );
	
	winner = undefined;
	
	while( !isdefined( winner ) )
	{
		CDC_Alive = 0;
		CIA_Alive = 0;
		
		players = GetPlayers();
		
		foreach ( player in players )
		{
			if ( player._encounters_team == "A" )
			{				
				if ( zm_utility::is_player_valid( player ) || ( ( isdefined( level.force_solo_quick_revive ) && level.force_solo_quick_revive ) && isdefined( player.lives ) && player.lives > 0 ) )
				{
					CIA_Alive++;
				}
			}
			else
			{
				if ( zm_utility::is_player_valid( player ) || ( ( isdefined( level.force_solo_quick_revive ) && level.force_solo_quick_revive ) && isdefined( player.lives ) && player.lives > 0 ) )
				{
					CDC_Alive++;
				}
			}
		}
		
		if ( CIA_Alive == 0 )
		{
			winner = "B";
		}
		else if ( CDC_ALIVE == 0 )
		{
			winner = "A";
		}
		
		{wait(.05);};
	}
		
	level notify( "game_module_ended", winner );
}

function make_supersprinter()
{
	self zombie_utility::set_zombie_run_cycle( "super_sprint" );
}


function game_module_custom_intermission(intermission_struct)
{
	self closeInGameMenu();

	level endon( "stop_intermission" );
	self endon("disconnect");
	self endon("death");
	self notify( "_zombie_game_over" ); // ww: notify so hud elements know when to leave

	//Show total gained point for end scoreboard and lobby
	self.score = self.score_total;

	self.sessionstate = "intermission";
	self.spectatorclient = -1; 
	self.killcamentity = -1; 
	self.archivetime = 0; 
	self.psoffsettime = 0; 
	self.friendlydamage = undefined;

	s_point = struct::get(intermission_struct,"targetname");
	
	if(!isdefined(level.intermission_cam_model))
	{
		level.intermission_cam_model = spawn("script_model",s_point.origin);//(1566, 498, 47.5));
		level.intermission_cam_model.angles = s_point.angles;
		level.intermission_cam_model setmodel("tag_origin");
	}
	self.game_over_bg = NewClientHudelem( self );
	self.game_over_bg.horzAlign = "fullscreen";
	self.game_over_bg.vertAlign = "fullscreen";
	self.game_over_bg SetShader( "black", 640, 480 );
	self.game_over_bg.alpha = 1;

	self spawn( level.intermission_cam_model.origin, level.intermission_cam_model.angles );
	self CameraSetPosition( level.intermission_cam_model );
	self CameraSetLookAt();
	self CameraActivate( true );	
	self linkto(level.intermission_cam_model);	
	level.intermission_cam_model moveto(struct::get(s_point.target,"targetname").origin,12);	
	if(isdefined(level.intermission_cam_model.angles))
	{	
		level.intermission_cam_model rotateto(struct::get(s_point.target,"targetname").angles,12);	
	}
	self.game_over_bg FadeOverTime( 2 );
	self.game_over_bg.alpha = 0;
	wait(2);				
	self.game_over_bg thread zm::fade_up_over_time(1);
}

function create_fireworks(launch_spots,min_wait,max_wait,randomize)
{
	level endon("stop_fireworks");
	while(1)
	{
		if(( isdefined( randomize ) && randomize ))
		{
			launch_spots =array::randomize(launch_spots);
		}
		foreach(spot in launch_spots)
		{
			level thread fireworks_launch(spot);
			wait(randomfloatrange(min_wait,max_wait));
		}
		wait(randomfloatrange(min_wait,max_wait));	
	}
}

function fireworks_launch(launch_spot)
{
	firework = spawn("script_model",launch_spot.origin + (randomintrange(-60,60),randomintrange(-60,60),0));
	firework setmodel("tag_origin");
	util::wait_network_frame();	
	PlayFXOnTag( level._effect[ "fw_trail_cheap" ], firework, "tag_origin" );
	firework playloopsound( "zmb_souls_loop", .75 );
	
	dest = launch_spot;	

	while(isdefined(dest) && isdefined(dest.target))
	{
		random_offset = (randomintrange(-60,60),randomintrange(-60,60),0);
		new_dests = struct::get_array(dest.target,"targetname");	
		new_dest = array::random(new_dests);
		dest = new_dest;
		dist = distance(new_dest.origin + random_offset,firework.origin);
		time = dist/700;							
		firework MoveTo(new_dest.origin + random_offset, time);
		firework waittill("movedone");
	}
 	firework playsound( "zmb_souls_end");

	playfx(level._effect["fw_pre_burst"],firework.origin);
	firework delete();
}
