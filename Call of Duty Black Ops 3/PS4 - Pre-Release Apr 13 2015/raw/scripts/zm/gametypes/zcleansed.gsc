#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\shared\ai\zombie_utility;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_weapons;
#using scripts\zm\gametypes\_zm_gametype;

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio_announcer;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_turned;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_cymbal_monkey;

//Powerups
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_empty_clip;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_insta_kill;

/*
	zcleansed - zcleansed Mode, wave based gameplay
	Objective: 	Stay alive for as long as you can
	Map ends:	When all players die
	Respawning:	No wait / Near teammates
*/

#precache( "material","faction_cdc");
#precache( "material","faction_cia");
#precache( "string", "ZOMBIE_POWERUP_MAX_AMMO" );	
#precache( "string", "ZOMBIE_THIS_IS_A_BUG" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_returned_spawn_puff" );
#precache( "fx", "zombie/fx_powerup_on_caution_zmb" );
#precache( "fx", "zombie/fx_powerup_on_solo_zmb" );

function main()
{
	level.using_zombie_powerups = true;
	level._game_mode_powerup_zombie_grab = &zcleansed_zombie_powerup_grab;
	level._zombiemode_powerup_grab = &zcleansed_powerup_grab;
	
	level._powerup_timeout_custom_time = &zcleansed_powerup_custom_time_logic;
	level._powerup_grab_check = &powerup_can_player_grab;

	SetDvar( "aim_target_player_enabled", true );

	zm_gametype::main();	// Generic zombie mode setup - must be called first.
	
	// Mode specific over-rides.

	setscoreboardcolumns( "none", "score", "kills", "downs", "headshots" ); 
	
	level.cymbal_monkey_dual_view = true;
	level.onPrecacheGameType = &onPrecacheGameType;
	level.onStartGameType = &onStartGameType;
	level.custom_end_screen = &custom_end_screen;
	level._game_module_custom_spawn_init_func = &zm_gametype::custom_spawn_init_func;
	level._game_module_state_update_func = &zm_stats::survival_classic_custom_stat_update;
	
	level._effect["human_disappears"] 	= "_t6/maps/zombie/fx_zmb_returned_spawn_puff";
	level._effect["zombie_disappears"] 	= "_t6/maps/zombie/fx_zmb_returned_spawn_puff";
	
	level.human_finish_bonus_points = 250; // 250 points for finishing the round as a human
	level.human_bonus_points = 10; // 10 points per period
	level.zombie_penalty_points = 5; // lose 5 points per period
	level.human_bonus_period = 1; // second
	level.zombie_penalty_period = 10; // second
	level.zombie_player_kill_points = 50; // 
	level.human_player_kill_points = 50; // 
	level.human_player_suicide_penalty = 0; // 
	level.score_rank_bonus = array( 1.5, .75, .5, .25 );

	// everybody plays as either CIA or CDC
	if ( ( isdefined( level.should_use_cia ) && level.should_use_cia ) )
		level.characterIndex = 0;
	else
		level.characterIndex = 1;
	
	// Don't Forfeit Match
	//--------------------
	level.gracePeriodFunc = &waitForHumanSelection;
	level.customAliveCheck = &cleansed_alive_check;
	
	level thread onPlayerConnect();
	
	zm_gametype::post_gametype_main("zcleansed");
	
	init_cleansed_powerup_fx();
}

function onPrecacheGameType()
{
	level.playerSuicideAllowed = true;
	level.canPlayerSuicide = &zm_gametype::canPlayerSuicide;

	precache_trophy();
	
	init_default_zcleansed_powerups();
	
	zm_turned::init();
	
	level thread zm_gametype::init();

	zm_gametype::runGameTypePrecache("zcleansed");

	init_cleansed_powerups();
}

//custom powerups that are used for Returned ( zcleansed )
function init_default_zcleansed_powerups()
{
	zm_powerups::include_zombie_powerup("the_cure");
	zm_powerups::include_zombie_powerup("blue_monkey");
	
	zm_powerups::add_zombie_powerup( "the_cure", "zombie_pickup_perk_bottle", &"ZOMBIE_POWERUP_MAX_AMMO",&zm_powerups::func_should_never_drop, false, false, true );
	zm_powerups::add_zombie_powerup( "blue_monkey", level.cymbal_monkey_model, &"ZOMBIE_POWERUP_MAX_AMMO",&zm_powerups::func_should_never_drop, true, false, false );
}

function init_cleansed_powerup_fx()
{
	// this can be used to override powerup fx
	level._effect["powerup_on_caution"]				= "zombie/fx_powerup_on_caution_zmb";
}


function onStartGameType()
{
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	structs = struct::get_array("player_respawn_point", "targetname");
	foreach(struct in structs)
	{
		level.spawnMins = math::expand_mins( level.spawnMins, struct.origin );
		level.spawnMaxs = math::expand_maxs( level.spawnMaxs, struct.origin );
	}

	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs ); 
	setMapCenter( level.mapCenter );

	zm_gametype::setup_classic_gametype();
	level thread makeFindFleshStructs();

	level flag::init( "start_supersprint" );

	// Disable Fake Deaths
	//--------------------
	level.custom_player_fake_death = &util::empty;
	level.custom_player_fake_death_cleanup = &util::empty;
	level.overridePlayerDamage = &cleansedDamageChecks;
	level.playerlaststand_func = &cleansed_player_laststand;
	level.onEndGame = &cleansedOnEndGame;
	level.onTimeLimit = &cleansedOnTimeLimit;
	level.powerup_player_valid = &cleansed_alive_check;
	
	level.nml_zombie_spawners = level.zombie_spawners;

	level.dodge_score_highlight = true;
	level.dodge_show_revive_icon = true;

	level.custom_max_zombies = 6;
	level.custom_zombie_health = 200;

	level.nml_dogs_enabled = false;

	level.timerCountDown = true;
	level.initial_spawn = true;

	level.NML_REACTION_INTERVAL			= 2000;	  // time interval between reactions
	level.NML_MIN_REACTION_DIST_SQ		= 32*32;	  // minimum distance from the player to be able to react
	level.NML_MAX_REACTION_DIST_SQ		= 2400*2400;// maximum distance from the player to be able to react

	level.min_humans = 1;

	level.no_end_game_check = true;

	level.zombie_health = level.zombie_vars[ "zombie_health_start" ];
	level._get_game_module_players = undefined;
	level.powerup_drop_count = 0;
	//* level.custom_player_fake_death = &playerFakeDeath;
	level.is_zombie_level=true;
	level.player_becomes_zombie		= &onZombifyPlayer;
	level.player_kills_player		= &player_kills_player;
	zombie_utility::set_zombie_var( "zombify_player", true );
	zombie_utility::set_zombie_var( "penalty_died",						1.0); //, 	true,	column );	// Percentage of money lost if you die
	zombie_utility::set_zombie_var( "penalty_downed", 					1.0); //, 	true,	column );	// Percentage of money lost if you go down // ww: told to remove downed point loss
	
	if(isdefined(level._zcleansed_weapon_progression))
	{
		for(i = 0; i < level._zcleansed_weapon_progression.size; i ++)
		{
			addGunToProgression( level._zcleansed_weapon_progression[i] );
		}
	}

	zm_gametype::runGameTypeMain("zcleansed", &zcleansed_logic);
}

/#
function TurnedLog(text)
{
	Println("TURNEDLOG: "+text+"\n");
}
#/		


function cleansed_player_laststand( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
/#
	//TurnedLog("Player "+self.name+" put in last stand by "+attacker.name);
#/		
	self zm_score::player_downed_penalty();
	if ( IsDefined( attacker ) && IsPlayer( attacker ) && attacker != self )
	{
		// Checking for a transit_dr achievement
		if( IsDefined(self.hide_owner) && (self.hide_owner) )
		{
			attacker notify( "invisible_player_killed" );
		}
	}
	
	if ( ( isdefined( self.is_zombie ) && self.is_zombie ) && deathAnimDuration == 0 )
	{
		self StopSounds();
	}	
}

function cleansed_alive_check( player )
{
	if ( player laststand::player_is_in_laststand() ||
		 ( isdefined( player.nuked ) && player.nuked ) ||
		 ( isdefined( player.is_in_process_of_zombify ) && player.is_in_process_of_zombify ) ||
		 ( isdefined( player.is_in_process_of_humanify ) && player.is_in_process_of_humanify ) )
		return false;
	return true;
}


function cleansedDamageChecks( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex )
{
	// if there are simultaneous hits and the first is fatal the second doesn't make it through.
	if ( self laststand::player_is_in_laststand() ||
		 ( isdefined( self.is_in_process_of_zombify ) && self.is_in_process_of_zombify ) ||
		 ( isdefined( self.is_in_process_of_humanify ) && self.is_in_process_of_humanify ) )
		return 0;

	if ( ( isdefined( self.nuked ) && self.nuked ) && eAttacker != self.nuker && eAttacker != self )
		return 0;
	
	if ( IsDefined( eAttacker ) && IsPlayer( eAttacker ) && eAttacker != self )
	{
		if ( eAttacker.team == self.team )
			return 0;
		if ( ( isdefined( eAttacker.is_zombie ) && eAttacker.is_zombie ) == ( isdefined( self.is_zombie ) && self.is_zombie ) )
			return 0;
		if ( !cleansed_alive_check(eAttacker) )
			return 0;
		if ( ( isdefined( self.nuked ) && self.nuked ) && IsDefined(self.nuker) && eAttacker != self.nuker )
			return 0;
		if ( ( isdefined( self.is_zombie ) && self.is_zombie ) && weapon == level.weaponZMCymbalMonkey && sMeansOfDeath != "MOD_IMPACT" )
		{
			level notify("killed_by_decoy",eAttacker,self);
			iDamage = self.health + 666;
		}
		else
		{
			self.last_player_attacker = eAttacker;
		}

/#
	//TurnedLog("Player "+self.name+" damaged by "+eAttacker.name);
#/		

		if ( !eAttacker.is_zombie && eAttacker zm_powerups::is_insta_kill_active() ) 
		{
			iDamage = self.health + 666;
		}
	}
	
	
	if ( isdefined(eAttacker) && ( isdefined( eAttacker.is_zombie ) && eAttacker.is_zombie ) )
	{
		self playsoundtoplayer( "evt_player_swiped", self );
	}
	
	return self zm::player_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
}

function custom_end_screen()
{
	players = GetPlayers();

	winner = players[0];
	foreach ( player in players )
	{
		if( IsDefined( winner ) && player.score > winner.score )
		{
			winner = player;
		}
	}
	
	if( IsDefined( level.last_human_standing ) )
	{
		for( i = 0; i < players.size; i++ )
		{
			players[i].bonus_msg_hud = NewClientHudElem( players[i] );
			players[i].bonus_msg_hud.alignX = "center";
			players[i].bonus_msg_hud.alignY = "middle";
			players[i].bonus_msg_hud.horzAlign = "center";
			players[i].bonus_msg_hud.vertAlign = "middle";
			players[i].bonus_msg_hud.y -= 130;
			if ( players[i] isSplitScreen() )
			{
				//players[i].bonus_msg_hud.fontScale = 1.5;
				players[i].bonus_msg_hud.y += 70;
			}

			players[i].bonus_msg_hud.foreground = true;
			players[i].bonus_msg_hud.fontScale = 5;
			players[i].bonus_msg_hud.alpha = 0;
			players[i].bonus_msg_hud.color = ( 1.0, 1.0, 1.0 );
			players[i].bonus_msg_hud.hidewheninmenu = true;
			players[i].bonus_msg_hud.font = "default";
			players[i].bonus_msg_hud SetText( &"ZOMBIE_CLEANSED_SURVIVING_HUMAN_BONUS", level.last_human_standing.name );

			players[i].bonus_msg_hud ChangeFontScaleOverTime( 0.25 );
			players[i].bonus_msg_hud FadeOverTime( 0.25 );
			players[i].bonus_msg_hud.alpha = 1;
			players[i].bonus_msg_hud.fontScale = 2;
		}

		wait( 3.25 );
	}

	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		if( isDefined( players[i].bonus_msg_hud ) )
		{
			players[i].bonus_msg_hud ChangeFontScaleOverTime( 0.5 );
			players[i].bonus_msg_hud FadeOverTime( 0.5 );
			players[i].bonus_msg_hud.alpha = 0;
			players[i].bonus_msg_hud.fontScale = 5;
		}
	}

	wait( 0.5 );

	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		//Destroy the bonus msg hud
		if( IsDefined( players[i].bonus_msg_hud ) )
			players[i].bonus_msg_hud Destroy();

		players[i].game_over_hud = NewClientHudElem( players[i] );
		players[i].game_over_hud.alignX = "center";
		players[i].game_over_hud.alignY = "middle";
		players[i].game_over_hud.horzAlign = "center";
		players[i].game_over_hud.vertAlign = "middle";
		players[i].game_over_hud.y -= 130;
		players[i].game_over_hud.foreground = true;
		players[i].game_over_hud.fontScale = 3;
		players[i].game_over_hud.alpha = 0;
		players[i].game_over_hud.color = ( 1.0, 1.0, 1.0 );
		players[i].game_over_hud.hidewheninmenu = true;
		players[i].game_over_hud SetText( &"ZOMBIE_GAME_OVER" );

		players[i].game_over_hud FadeOverTime( 1 );
		players[i].game_over_hud.alpha = 1;
		if ( players[i] isSplitScreen() )
		{
			players[i].game_over_hud.fontScale = 2;
			players[i].game_over_hud.y += 40;
		}

		players[i].survived_hud = NewClientHudElem( players[i] );
		players[i].survived_hud.alignX = "center";
		players[i].survived_hud.alignY = "middle";
		players[i].survived_hud.horzAlign = "center";
		players[i].survived_hud.vertAlign = "middle";
		players[i].survived_hud.y -= 100;
		players[i].survived_hud.foreground = true;
		players[i].survived_hud.fontScale = 2;
		players[i].survived_hud.alpha = 0;
		players[i].survived_hud.color = ( 1.0, 1.0, 1.0 );
		players[i].survived_hud.hidewheninmenu = true;
		if ( players[i] isSplitScreen() )
		{
			players[i].survived_hud.fontScale = 1.5;
			players[i].survived_hud.y += 40;
		}
		winner_text = &"ZOMBIE_CLEANSED_WIN";
		loser_text = &"ZOMBIE_CLEANSED_LOSE";
		
		if(( isdefined( level.host_ended_game ) && level.host_ended_game ))
		{
			players[i].survived_hud SetText( &"MP_HOST_ENDED_GAME" );
		}
		else if( players[i] == winner )
		{
			players[i].survived_hud SetText( winner_text );
		}
		else
		{
			players[i].survived_hud SetText( loser_text );
		}
		
		players[i].survived_hud FadeOverTime( 1 );
		players[i].survived_hud.alpha = 1;
	}
}

function allow_player_movement( allowed )
{
	level.player_movement_suppressed = !allowed;
	
	foreach(player in GetPlayers())
	{
		if (!( isdefined( player.in_zombify_call ) && player.in_zombify_call ))
			player util::freeze_player_controls(level.player_movement_suppressed);
	}
}

function watch_game_start()
{
	level.start_audio_allowed = 1;
	level waittill("cleansed_game_started");
	level.start_audio_allowed = 0;
}
	
function listen_to_the_doctor_pregame()
{
	thread watch_game_start();
	
	level zm_audio_announcer::leaderDialog( "dr_start_single_0", undefined, undefined, true, 4 ); // Wunderbar news, people! We have something brand new for you to try today!  
	wait 4;
	if ( level.start_audio_allowed )
	{
		level zm_audio_announcer::leaderDialog( "dr_start_2", undefined, undefined, true, 8 );        // There is a cure, my friends... But not enough for everybody!                  
		wait 8;
	}
	if ( level.start_audio_allowed )
	{
		level zm_audio_announcer::leaderDialog( "dr_start_3", undefined, undefined, true, 8 );        // Someone�s got to find it, so the fun starts now!...                          
		wait 4;
	}
	if ( level.start_audio_allowed )
	{
		level waittill("cleansed_game_started");
	}
}

function listen_to_the_doctor_started()
{
	level zm_audio_announcer::leaderDialog( "dr_cure_found_line", undefined, undefined, true, 8 );
	wait 8;
}

function listen_to_the_doctor_monkeys()
{
	level endon( "end_game" );
	while (1)
	{
		level waittill("killed_by_decoy",killer,killee);
		if ( !IsPlayer( killee ) )
			continue;
		if (( isdefined( level.playing_turned_kill_vo ) && level.playing_turned_kill_vo ))
			continue;
		if (! ( isdefined( killer.heard_dr_monkey_killer ) && killer.heard_dr_monkey_killer ) )
		{
			level.playing_turned_kill_vo = 1;
			killer.heard_dr_monkey_killer=1;
			killer thread zm_audio_announcer::leaderDialogOnPlayer( "dr_monkey_killer", undefined, undefined, false );
		}
		if (! ( isdefined( killee.heard_dr_monkey_killee ) && killee.heard_dr_monkey_killee ) )
		{
			level.playing_turned_kill_vo = 1;
			killee.heard_dr_monkey_killee=1;
			wait 0.25;
			killee thread zm_audio_announcer::leaderDialogOnPlayer( "dr_monkey_killee", undefined, undefined, false );
		}
		if (( isdefined( level.playing_turned_kill_vo ) && level.playing_turned_kill_vo ))
		{
			wait 8;
			level.playing_turned_kill_vo = 0;
		}
	}
}

function listen_to_the_doctor_human_deaths()
{
	level endon( "end_game" );	
	while (1)
	{
		level waittill("killed_by_zombie",killer,killee);
		{wait(.05);};
		if (( isdefined( level.playing_turned_kill_vo ) && level.playing_turned_kill_vo ))
			continue;
		if (!isdefined(killee.vo_human_killed_chance))
			killee.vo_human_killed_chance=24;
		
		if (RandomInt(100) < killee.vo_human_killed_chance)
		{
			level.playing_turned_kill_vo = 1;
			killee thread zm_audio_announcer::leaderDialogOnPlayer( "dr_human_killed", undefined, undefined, false );
			killee.vo_human_killed_chance = int (killee.vo_human_killed_chance * 0.5);
		}
		if (( isdefined( level.playing_turned_kill_vo ) && level.playing_turned_kill_vo ))
		{
			wait 4;
			level.playing_turned_kill_vo = 0;
		}
	}
}

function listen_to_the_doctor_zombie_deaths()
{
	level endon( "end_game" );
	while (1)
	{
		level waittill("killed_by_human",killer,killee);
		{wait(.05);};
		if (( isdefined( level.playing_turned_kill_vo ) && level.playing_turned_kill_vo ))
			continue;
		if (!isdefined(killer.vo_human_killer_chance))
			killer.vo_human_killer_chance=24;
		//if (RandomInt(100) < 25)
		//{
		//	level.playing_turned_kill_vo = 1;
		//	killee thread zm_audio_announcer::leaderDialogOnPlayer( "dr_plr_survive_line", undefined, undefined, false );
		//}
		if (RandomInt(100) < killer.vo_human_killer_chance)
		{
			killer.vo_human_killer_chance = int (killer.vo_human_killer_chance * 0.5);
			level.playing_turned_kill_vo = 1;
			killer thread zm_audio_announcer::leaderDialogOnPlayer( "dr_human_killer", undefined, undefined, false );
		}
		if (( isdefined( level.playing_turned_kill_vo ) && level.playing_turned_kill_vo ))
		{
			wait 4;
			level.playing_turned_kill_vo = 0;
		}
	}
}

function listen_to_the_doctor_endgame()
{
	wait 5;
	while ( globallogic_utils::getTimeRemaining() > 12 * 1000 )
		wait 1;
	r = randomint(3);
	if (r==0)
		level zm_audio_announcer::leaderDialog( "dr_countdown0", undefined, undefined, true, 4 ); 
	else if (r==1)
		level zm_audio_announcer::leaderDialog( "dr_countdown1", undefined, undefined, true, 4 ); 
	else
		level zm_audio_announcer::leaderDialog( "dr_countdown2", undefined, undefined, true, 4 ); 

	while ( globallogic_utils::getTimeRemaining() > 500 )
		wait 1;
	//level waittill ( "end_game" );
	//wait 0.5;
	level zm_audio_announcer::leaderDialog( "dr_ending", undefined, undefined, true, 4 ); // Wunderbar news, people! We have something brand new for you to try today!  

	
}

function anysplitscreen()
{
	foreach( player in GetPlayers())
	{
		if ( player isSplitScreen() )
			return true;
	}
	return false;
}

function listen_to_the_doctor()
{
	listen_to_the_doctor_pregame();
	
	if ( !anysplitscreen() )
	{
		listen_to_the_doctor_started();
		thread listen_to_the_doctor_human_deaths();
		thread listen_to_the_doctor_zombie_deaths();
		thread listen_to_the_doctor_monkeys();
	}
	thread listen_to_the_doctor_endgame();
}

function watch_survival_time()
{
	level endon( "end_game" );
	level notify("new_human_suviving");
	level endon("new_human_suviving");
	self endon("zombify");
	
	wait 10;
	
	if (!isdefined(self.vo_human_survival_chance))
		self.vo_human_survival_chance=24;
	
	while(1)
	{
		if (!( isdefined( level.playing_turned_kill_vo ) && level.playing_turned_kill_vo ))
		{
			if (RandomInt(100) < self.vo_human_survival_chance)
			{
				self.vo_human_survival_chance = int (self.vo_human_survival_chance * 0.25);
				level.playing_turned_kill_vo = 1;
				self thread zm_audio_announcer::leaderDialogOnPlayer( "dr_survival", undefined, undefined, false );
				wait 4;
				level.playing_turned_kill_vo = 0;
			}
		}
		wait 5;
	}
}


function zcleansed_logic()
{
	SetDvar( "player_lastStandBleedoutTime", "0.05" );

	SetMatchTalkFlag( "DeadChatWithDead", 1 );
	SetMatchTalkFlag( "DeadChatWithTeam", 1 );
	SetMatchTalkFlag( "DeadHearTeamLiving", 1 );
	SetMatchTalkFlag( "DeadHearAllLiving", 1 );
	SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );
	
	level.zombie_include_powerups[ "carpenter" ] = false;

	// Disable Chalk
	//--------------
	level.noRoundNumber = true;
	level._supress_survived_screen = 1;
	
	// Disable Doors
	//--------------
	doors = GetEntArray( "zombie_door", "targetname" );
	foreach ( door in doors )
	{
		door SetInvisibleToAll();
	}

	// Disable Windows
	//----------------
	level thread zm_blockers::open_all_zbarriers();

	level thread delay_box_hide();
	
	//level flag::wait_till("start_encounters_match_logic");	
	level flag::wait_till("initial_blackscreen_passed");

	level.gameStartTime = GetTime();
	level.gameLengthTime = undefined;
	
	level.custom_spawnPlayer = &respawn_cleansed_player;
	
	allow_player_movement(false);
	setup_players();
	level flag::wait_till("initial_blackscreen_passed");

	level thread listen_to_the_doctor();
	level thread playTurnedMusic();

	level notify( "start_fullscreen_fade_out" );
	
	wait ( 1.5 );
	
	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread create_match_start_message(&"ZOMBIE_FIND_THE_CURE", 3.0);
	}

	allow_player_movement(true);
	spawn_initial_cure_powerup();
	waitForHumanSelection();
	level notify("cleansed_game_started");
	level thread leaderWatch();

	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread create_match_start_message( &"ZOMBIE_MOST_TIME_AS_HUMAN_TO_WIN", 3.0 );
	}

	wait ( 1.2 );

	level flag::clear( "pregame" );

	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread destroyStartMsgHud();
	}
	
	util::registertimelimit( 0, 1440 );
	level.discardTime = GetTime() - level.startTime;
	
	level thread watch_for_end_game();
	wait_for_round_end();
	
	allow_player_movement(false);
	util::wait_network_frame();
	award_round_end_bonus();

	level notify( "end_game" );
	
}

function wait_for_round_end()
{
	level endon( "early_game_end" );
	level endon( "normal_game_end" );
	while ( globallogic_utils::getTimeRemaining() > 0 )
		wait 1;
}


function end_game_early()
{
	/#
		IPrintLnBold( "SOLO GAME - RELEASE ONLY" );
		return;
	#/
	
	// only one player left
	level.forcedEnd = true;
	level notify( "early_game_end" );
	level notify( "end_game" );
	
}

function watch_for_end_game()
{
	level waittill ( "end_game" );
	util::registertimelimit( 0, 0 );
	setGameEndTime( 0 );
}

function cleansedOnTimeLimit()
{
	level notify( "normal_game_end" );
}

function cleansedOnEndGame( winningTeam )
{
}

function create_match_start_message(text, duration)
{
	level endon( "end_game" );
	self endon( "disconnect" );
	self notify( "kill_match_start_message" );
	self endon( "kill_match_start_message" );
	
	if(!isdefined(self.match_start_msg_hud))
	{
		self.match_start_msg_hud = NewClientHudElem( self );
		self.match_start_msg_hud.alignX = "center";
		self.match_start_msg_hud.alignY = "middle";
		self.match_start_msg_hud.horzAlign = "center";
		self.match_start_msg_hud.vertAlign = "middle";
		self.match_start_msg_hud.y -= 130;
		self.match_start_msg_hud.fontScale = 5;
		self.match_start_msg_hud.foreground = true;
		if( self isSplitscreen() )
		{
			self.match_start_msg_hud.y += 70;
		}
	
		self.match_start_msg_hud.color = ( 1.0, 1.0, 1.0 );
		self.match_start_msg_hud.hidewheninmenu = true;
		self.match_start_msg_hud.font = "default";
	}
	
	self.match_start_msg_hud SetText( text );

	self.match_start_msg_hud ChangeFontScaleOverTime( 0.25 );
	self.match_start_msg_hud FadeOverTime( 0.25 );
	self.match_start_msg_hud.alpha = 1;
	self.match_start_msg_hud.fontScale = 2;
	if( self isSplitscreen() )
	{
		self.match_start_msg_hud.fontScale = 1.5;
	}

	wait( duration );

	if( !isDefined( self.match_start_msg_hud ) )
		return;
	
	self.match_start_msg_hud ChangeFontScaleOverTime( 0.5 );
	self.match_start_msg_hud FadeOverTime( 0.5 );
	self.match_start_msg_hud.alpha = 0;
}

function destroyStartMsgHud()
{
	level endon( "end_game" );
	self endon( "disconnect" );

	if( !IsDefined( self.match_start_msg_hud ) )
		return;

	self.match_start_msg_hud Destroy();
	self.match_start_msg_hud = undefined;
}

function delay_box_hide()
{
	wait(2.0);
	// Hide Start Magic Chest
	//-----------------------
	start_chest = struct::get( "start_chest", "script_noteworthy" );
	if (isdefined(start_chest))
		start_chest zm_magicbox::hide_chest();
}

function onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );

		player thread onPlayerLastStand();
		player thread onPlayerDisconnect();
		player thread setup_player();
		player thread rewardsThink();

	}
}

function onPlayerLastStand()
{
	self endon( "disconnect" );

	while ( true )
	{
		self waittill( "player_downed" );
		
		self TakeAllWeapons();
	}
}



function onPlayerDisconnect()
{
	level endon( "end_game" );

	self waittill( "disconnect" );

	if (GetPlayers().size <= 1)
		end_game_early();
	else if ( !( isdefined( level.inGracePeriod ) && level.inGracePeriod ) )
	{
		thread checkZombieHumanRatio();
		wait 2;
		players = GetPlayers();
		foreach(player in players)
		{
			player.nuked = undefined;
		}
	}
}

function zombie_ramp_up()
{
	self notify("zombie_ramp_up");
	self endon("zombie_ramp_up");
	self endon("death_or_disconnect");
	self endon("humanify");

/*	
	ramp_up_round_time = 6;
	
	self.returned_round = 1;
	
	while (self.is_zombie)
	{
		self.maxhealth = zm::ai_zombie_health( self.returned_round );
		wait ramp_up_round_time;
		self.returned_round++;
	}
*/
	if (isdefined(level.cleansed_zombie_round))
		self.maxhealth = zm::ai_zombie_health( level.cleansed_zombie_round );
	else
		self.maxhealth = zm::ai_zombie_health( 2 );
	self.health = self.maxhealth;

}

//#define TROPHY_MODEL "p_zom_moon_space_helmet"
//#define TROPHY_BONE "J_Spine4"
	
function precache_trophy()
{
}

function create_trophy()
{
}
	
function give_trophy()
{
	if (!self.has_trophy)
	{
		self clientfield::set("player_eyes_special", 1);
		self clientfield::set("player_has_eyes", 0);
		util::wait_network_frame();
		if ( cleansed_alive_check( self ) )
			self clientfield::set("player_has_eyes", self.is_zombie);
		self.has_trophy=true;
	}
}

function remove_trophy()
{
	if (self.has_trophy)
	{
		self clientfield::set("player_eyes_special", 0);
		self clientfield::set("player_has_eyes", 0);
		util::wait_network_frame();
		if ( cleansed_alive_check( self ) )
			self clientfield::set("player_has_eyes", self.is_zombie);
		self.has_trophy=false;
	}
}

function enthrone( player )
{
	player endon("dethrone");
	player endon("disconnect");

	while(1)
	{
		if ( cleansed_alive_check( player ) && player.is_zombie )
		{
			if (!player.has_trophy)
			{
				player give_trophy();
			}
		}
		else
		{
			if (player.has_trophy)
			{
				player remove_trophy();
			}
		}
		wait 0.10;
	}
}

function dethrone( player )
{
	player notify("dethrone");
	player remove_trophy();
}

function cleansed_set_leader( leader )
{
	if(isdefined(leader) && isdefined(level.cleansed_leader))
	{
		if(level.cleansed_leader != leader)
		{
			dethrone( level.cleansed_leader );
			
			level.cleansed_leader = leader;
			
			level thread enthrone( level.cleansed_leader);
		}
		
		return;
	}
	
	if(isdefined(leader) && !isdefined(level.cleansed_leader))
	{
			level.cleansed_leader = leader;
			
			level thread enthrone( level.cleansed_leader);
			
			return;
	}

	if(!isdefined(leader) && isdefined(level.cleansed_leader))
	{
		if (isdefined(level.cleansed_leader))
		{
			dethrone( level.cleansed_leader );
		}

		level.cleansed_leader=leader;
		
		return;
	}
}

function leaderWatch()
{
	level endon( "early_game_end" );
	level endon( "normal_game_end" );

	create_trophy();
	
	cleansed_set_leader( undefined );

	while( 1 )
	{
		hiscore = -1;
		leader = undefined;
		
		players = GetPlayers();
		foreach( player in players )
		{
			if ( player.score > hiscore )
				hiscore = player.score;
		}
	
		foreach( player in players )
		{
			if ( player.score >= hiscore )
			{
				// more than one leader?
				if (isdefined(leader))
				{
					leader = undefined;
					break;
				}
				leader = player; 
			}
		}
		cleansed_set_leader( leader );

		wait 0.25;
	}
	
}

function cover_transition()
{
	self thread hud::fade_to_black_for_x_sec( 0, 0.15, 0.05, 0.10 );
	wait 0.1;
}

function disappear_in_flash(washuman)
{
	playsoundatposition( "zmb_bolt", self.origin );
	if (washuman)
		PlayFX( level._effect[ "human_disappears" ], self.origin );
	else
		PlayFX( level._effect[ "zombie_disappears" ], self.origin );
	
	// pop out now
	//wait 0.2;
	
	self ghost();
}

function HumanifyPlayer( for_killing )
{
/#
	//TurnedLog("Player "+self.name+" becoming human for killing "+for_killing.name);
#/		
	self util::freeze_player_controls(1);
	self thread cover_transition();
	self disappear_in_flash(true);
	self.team = self.prevteam;
	self.pers["team"] = self.prevteam;
	self.sessionteam = self.prevteam;
	self TurnedHuman();
	// give the newly zombified player time to spawn in first
	for_killing util::waittill_any_timeout(0.75, "respawned");
	util::wait_network_frame();
	
	checkZombieHumanRatio( self );
	self.last_player_attacker = undefined;
	
	self util::freeze_player_controls(level.player_movement_suppressed);
	self thread watch_survival_time();
/#
	//TurnedLog("Player "+self.name+" completed becoming human for killing "+for_killing.name);
#/		
}

function onZombifyPlayer()
{
/#
	//TurnedLog("Player "+self.name+" started becoming zombie");
#/		
	// avoid reentrant use of this call
	if (( isdefined( self.in_zombify_call ) && self.in_zombify_call ))
		return;
	
	self.in_zombify_call=1;
	
	while (( isdefined( level.in_zombify_call ) && level.in_zombify_call ))
		wait 0.10;

	level.in_zombify_call=1;

	self util::freeze_player_controls(1);

	if ( IsDefined( self.last_player_attacker ) && IsPlayer( self.last_player_attacker ) && ( isdefined( self.last_player_attacker.is_zombie ) && self.last_player_attacker.is_zombie ) )
	{
	}
	// Already A Zombie, Just Respawning
	//----------------------------------
	if ( ( isdefined( self.is_zombie ) && self.is_zombie ) )
	{
/#
	//TurnedLog("Player "+self.name+" staying a zombie");
#/		
		self check_for_drops( false );
	}
	// Turn Zombie Who Killed Us To Human, If Applicable
	//--------------------------------------------------
	else if ( IsDefined( self.last_player_attacker ) && IsPlayer( self.last_player_attacker ) && ( isdefined( self.last_player_attacker.is_zombie ) && self.last_player_attacker.is_zombie ) )
	{
/#
	//TurnedLog("Player "+self.name+" becoming zombie for being killed by "+self.last_player_attacker.name);
#/		
		self check_for_drops( true );
		self.team = level.zombie_team;
		self.pers["team"] = level.zombie_team;
		self.sessionteam = level.zombie_team;
		self.last_player_attacker thread HumanifyPlayer(self);
		self.player_was_turned_by = self.last_player_attacker; // in case we want to detect revenge
	}
	// Get Earliest Zombie Player To Turn Human If Killed By AI Zombie
	//----------------------------------------------------------------
	else
	{
/#
	//TurnedLog("Player "+self.name+" becoming zombie for suicide");
#/		
		self check_for_drops( true );
		self player_suicide();
		checkZombieHumanRatio( undefined, self );
	}

	self clientfield::set("player_has_eyes", 0);
	if ( ( isdefined( self.is_zombie ) && self.is_zombie ) )
	{
		// wait for zombie death animation  to complete
		// or not - for now we want it fast
		//wait 1;
	}

	self notify( "zombified" );

	self disappear_in_flash(false);
	
	self cover_transition();
	self notify( "clear_red_flashing_overlay" );
	
	self.zombification_time = GetTime() / 1000;

	self.last_player_attacker = undefined;

	self zm_laststand::laststand_enable_player_weapons();

	self.ignoreme = true;

	if ( IsDefined( self.revivetrigger ) )
	{
		self.revivetrigger Delete();
	}

	self.revivetrigger = undefined;

	//	self setMoveSpeedScale( 0.3 );

	self reviveplayer();

	//level thread zm_audio_announcer::leaderDialog( "dr_kill_plr_line", undefined, undefined, true );
	self zm_turned::turn_to_zombie();
	self util::freeze_player_controls(level.player_movement_suppressed);
	
	self thread zombie_ramp_up();

	level.in_zombify_call=0;
	self.in_zombify_call=0;
/#
	//TurnedLog("Player "+self.name+" completed becoming zombie");
#/		
}

function playerFakeDeath( vDir )
{
	if ( !( isdefined( self.is_zombie ) && self.is_zombie ) )
	{
		self endon( "disconnect" );
		level endon( "game_module_ended" );

		level notify ("fake_death");
		self notify ("fake_death");

		self EnableInvulnerability();
		self TakeAllWeapons();
		self util::freeze_player_controls( true );

		self.ignoreme = true;

		origin = self.origin;
		xyspeed = ( 0, 0, 0 );
		angles = self getplayerangles();
		angles = ( angles[0], angles[1], angles[2] + RandomFloatRange( -5, 5 ) );

		if (isDefined(vDir) && Length(vDir) > 0)
		{
			XYSpeedMag = 40 + randomint(12) + randomint(12);
			xyspeed = XYSpeedMag * vectornormalize(( vDir[ 0 ], vDir[ 1 ], 0 ) );
		}

		linker = spawn( "script_origin", ( 0, 0, 0 ) );
		linker.origin = origin;
		linker.angles = angles;
		self._fall_down_anchor = linker;
		self playerlinkto( linker );
		self playsoundtoplayer( "zmb_player_death_fall", self );

		origin = PlayerPhysicsTrace( origin, origin + xyspeed );
		origin = origin + (0,0,-52);

		lerptime = 0.5;

		linker moveto( origin, lerptime, lerptime );
		linker rotateto( angles, lerptime, lerptime );
		self util::freeze_player_controls( true );
		linker waittill( "movedone" );


		self GiveWeapon( level.weaponZMDeathThroe );
		self SwitchToWeapon( level.weaponZMDeathThroe );

		bounce = randomint(4) + 8;
		origin = origin + (0,0,bounce) - ( xyspeed * 0.1 );
		lerptime = bounce / 50.0;

		linker moveto( origin, lerptime, 0, lerptime );
		linker waittill( "movedone" );

		origin = origin + (0,0,-bounce) + ( xyspeed * 0.1 );
		lerptime = lerptime / 2.0;

		linker moveto( origin, lerptime, lerptime );
		linker waittill( "movedone" );

		linker moveto( origin, 5, 0 );
		wait 5;
		linker delete();

		self.ignoreme = false;

		self TakeWeapon( level.weaponZMDeathThroe );
		self DisableInvulnerability();
		self util::freeze_player_controls( false );
	}
}

function onSpawnZombie()
{
	//	self.maxhealth = _zm_race_utility::get_race_zombie_health( self._starting_round_number );
	//	self.health = _zm_race_utility::get_race_zombie_health( self._starting_round_number );
	//	self _zm_race_utility::set_race_zombie_run_cycle( self._starting_round_number );
}


function makeFindFleshStructs()
{
	structs = struct::get_array( "spawn_location", "script_noteworthy" );

	foreach ( struct in structs )
	{
		struct.script_string = "find_flesh";
	}
}

function setup_players()
{
	/#
	if ( GetDvarInt( "scr_zombie_cleansed_spawns_debug" ) != 0 )
	{
		foreach( spawnPoint in level._turned_zombie_respawnpoints )
		{
			text = "";
			color = ( 0, 1, 0 );

			if ( !IsDefined( spawnPoint.angles ) )
			{
				text = "No Angles Defined";
				color = ( 1, 0, 0 );
				spawnPoint.angles = ( 0, 0, 0 );
			}

		//	_dev::showOneSpawnPoint( spawnPoint, color, "zombie_cleansed_spawns_debug_flush", undefined, text );
		}
	}
	#/
}

function setup_player()
{
	while ( !level flag::exists( "initial_players_connected" ) )
		{wait(.05);};
	hotjoined = level flag::get( "initial_players_connected" );
	level flag::wait_till("initial_players_connected");
	{wait(.05);};
	self Ghost();
	self util::freeze_player_controls(1);
	self.ignoreme = false;
	self.score = 0;
	
	
	self.characterIndex = level.characterIndex;
	self TakeAllWeapons();
	self GiveWeapon( level.weaponBaseMelee );
	self zm_utility::give_start_weapon( true );

	self.prevteam = self.team;
	self.no_revive_trigger = true;

	self.human_score = 0;

//		self.entity_num = self GetEntityNumber(); 
	
	self thread player_score_update();

	self.is_zombie = false;
	self.has_trophy = false;

	// Store Original Team
	//--------------------
	self.home_team = self.team;
	
	if ( self.home_team == "axis" )
	{
		self.home_team = "team3"; // level.zombie_team == "team3", less confusing than sticking with "axis"
	}

	self thread wait_turn_to_zombie(hotjoined);
}


function wait_turn_to_zombie(hot)
{
	if (hot)
	{
		self thread hud::fade_to_black_for_x_sec( 0, 1.25, 0.05, 0.25 );
		wait 1;
	}
	self.is_zombie = false;
	self zm_turned::turn_to_zombie();
	
	//self util::freeze_player_controls(level.player_movement_suppressed);
	self util::freeze_player_controls(true);
}

function addGunToProgression( weapon )
{
	if ( !IsDefined( level.gunProgression ) )
	{
		level.gunProgression = [];
	}

	level.gunProgression[ level.gunProgression.size ] = weapon;
}

function check_spawn_cymbal_monkey( origin, weapon )
{
	chance = -0.05; // no random chance
	
	if ( !self HasWeapon( level.weaponZMCymbalMonkey ) || self GetWeaponAmmoClip( level.weaponZMCymbalMonkey ) < 1 )
	{
		if ( weapon == level.weaponZMCymbalMonkey || RandomFloat(1) < chance )
		{
			self notify ("awarded_cymbal_monkey");
			level.spawned_cymbal_monkey = spawn_cymbalmonkey( origin );
			level.spawned_cymbal_monkey thread delete_spawned_monkey_on_turned(self); 
			return true;
		}
	}
	return false;
}

//self = spawned cymbal monkey
function delete_spawned_monkey_on_turned(player)
{
	wait(1); //time for the player to turn human;
	while( isDefined( self ) && !( isdefined( player.is_zombie ) && player.is_zombie ) )
	{
		util::wait_network_frame();
	}
	if(isDefined(self))
	{
		self zm_powerups::powerup_delete();
		self notify("powerup_timedout");
	}
	
}

function rewardsThink()
{
	self endon( "_zombie_game_over" );
	self endon( "disconnect" );

	while ( isdefined(self) )
	{
		self waittill( "killed_a_zombie_player", eInflictor, target, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration  );
		if ( !( isdefined( self.is_zombie ) && self.is_zombie ) )
		{
			//level thread zm_audio_announcer::leaderDialog( "dr_monkey_line", undefined, undefined, true );
			if ( self check_spawn_cymbal_monkey( target.origin, weapon ) )
				target.suppress_drops = true;
		}
	}

}

function shotgunLoadout()
{
	self endon( "_zombie_game_over" );
	self endon( "disconnect" );
	self endon( "bled_out" );
	self endon( "zombify" );

	level.cymbal_monkey_clone_weapon = GetWeapon( "rottweil72" );
	
	// Give ShotGun
	//-------------
	if ( !self HasWeapon( level.cymbal_monkey_clone_weapon ) )
	{
		self GiveWeapon( level.cymbal_monkey_clone_weapon );
		self SwitchToWeapon( level.cymbal_monkey_clone_weapon );
	}
	
	// Give Start Weapons
	//-------------------
	if ( !( isdefined( self.is_zombie ) && self.is_zombie ) && !self HasWeapon( level.start_weapon ) )
	{
		if ( !self HasWeapon( level.weaponBaseMelee ) )
		{
			self GiveWeapon( level.weaponBaseMelee );
		}
		
		self zm_utility::give_start_weapon( false );
	}
	
	if ( self HasWeapon( level.cymbal_monkey_clone_weapon ) )
	{
		self SetWeaponAmmoClip( level.cymbal_monkey_clone_weapon, 2 );
		self SetWeaponAmmoStock( level.cymbal_monkey_clone_weapon, 0 );
	}
	
	if ( self HasWeapon( level.start_weapon ) )
	{
		self GiveMaxAmmo( level.start_weapon );
	}
	
	// Replenish Grenades
	//-------------------
	if ( self HasWeapon( self zm_utility::get_player_lethal_grenade() ) )
	{
		self GetWeaponAmmoClip( self zm_utility::get_player_lethal_grenade() );
	}
	else
	{
		self GiveWeapon( self zm_utility::get_player_lethal_grenade() );
	}

	self SetWeaponAmmoClip( self zm_utility::get_player_lethal_grenade(), 2 );
	
	if(!( isdefined( self.random_human ) && self.random_human )) //don't give them a monkeybomb if they were chosen randomly to be a human, they must earn it
	{
//		self _zm_weap_cymbal_monkey::player_give_cymbal_monkey();
//		self SetWeaponAmmoClip( level.weaponZMCymbalMonkey, 1 );
	}
}

function gunProgressionThink()
{
	self endon( "_zombie_game_over" );
	self endon( "disconnect" );
	self endon( "bled_out" );
	self endon( "zombify" );

	counter = 0;

	if (isdefined(level.gunProgression) && !IsDefined(level.cymbal_monkey_clone_weapon) )
		level.cymbal_monkey_clone_weapon = level.gunProgression[0];

	last = level.start_weapon;

	// Replenish Grenades
	//-------------------
	if ( !self HasWeapon( self zm_utility::get_player_lethal_grenade() ) )
	{
		self GiveWeapon( self zm_utility::get_player_lethal_grenade() );
	}
	self SetWeaponAmmoClip( self zm_utility::get_player_lethal_grenade(), 2 );

	if(!( isdefined( self.random_human ) && self.random_human )) //don't give them a monkeybomb if they were chosen randomly to be a human, they must earn it
	{
		//self _zm_weap_cymbal_monkey::player_give_cymbal_monkey();
		//self SetWeaponAmmoClip( level.weaponZMCymbalMonkey, 1 );
	}

	self DisableWeaponCycling();
	while ( !( isdefined( self.is_zombie ) && self.is_zombie ) )
	{
		if ( !IsDefined( level.gunProgression[ counter ] ) )
		{
			break;
		}

		self DisableWeaponCycling();
		self GiveWeapon( level.gunProgression[ counter ] );
		self SwitchToWeapon( level.gunProgression[ counter ] );
		self util::waittill_any_timeout(0.5, "weapon_change_complete" );
		if ( isdefined(last) && self HasWeapon( last ) )
		{
			self TakeWeapon( last );
		}
		last = level.gunProgression[ counter ];

		while ( true )
		{
			self waittill( "killed_a_zombie_player", eInflictor, target, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration  );

			if ( level.gunProgression[ counter ] == weapon )
			{
				break;
			}
		}

		counter++;
	}

	self GiveWeapon( level.start_weapon );
	self SwitchToWeapon( level.start_weapon );
	self waittill( "weapon_change_complete" );
	if ( isdefined(last) && self HasWeapon( last ) )
	{
		self TakeWeapon( last );
	}

	while ( true )
	{
		self waittill( "killed_a_zombie_player", eInflictor, target, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration  );
		
		if ( level.start_weapon == weapon )
		{
			self notify("gun_game_achievement");
			break;
		}
	}
}

function waitForHumanSelection()
{
	level waittill( "initial_human_selected" );
//	level thread zm_audio_announcer::leaderDialog( "dr_cure_found_line", undefined, undefined, true );
}

function checkZombieHumanRatio( playerToMove, playerToIgnore )
{
	// In ZTURNED Players Will Sit In Spectate Until Their Whole Team Is Dead
	//-----------------------------------------------------------------------
	zombieCount = 0;
	humanCount = 0;
	zombieExist = false;
	humanExist = false;
	earliestZombie = undefined;
	earliestZombieTime = 99999999;
	
	if (GetPlayers().size <= 1)
		end_game_early();
	
	while (( isdefined( level.checking_human_zombie_ratio ) && level.checking_human_zombie_ratio ))
		{wait(.05);};

	level.checking_human_zombie_ratio=1;
	if ( IsDefined( playerToMove ) )
	{
		someoneBecomingHuman = false;

		players = GetPlayers();
		foreach ( player in players )
		{
			if ( ( isdefined( player.is_in_process_of_humanify ) && player.is_in_process_of_humanify ) )
			{
				someoneBecomingHuman = true;
			}
		}

		// TODO -- If We Want A Player To Switch Sides Intentionally, Then They Should Swap With Whoever Is A Human Already
		if ( !( isdefined( someoneBecomingHuman ) && someoneBecomingHuman ) )
		{
			playerToMove zm_turned::turn_to_human();
		}

		level.checking_human_zombie_ratio=0;
		return;
	}

	players = GetPlayers();
	foreach ( player in players )
	{
		if ( IsDefined( playerToIgnore ) && playerToIgnore == player )
		{
			continue;
		}

		if ( !( isdefined( player.is_zombie ) && player.is_zombie ) && !( isdefined( player.is_in_process_of_zombify ) && player.is_in_process_of_zombify ) )
		{
			humanCount++;
			humanExist = true;
		}
		else
		{
			zombieCount++;
			zombieExist = true;

			if ( IsDefined( player.zombification_time ) && player.zombification_time < earliestZombieTime )
			{
				earliestZombie = player;
				earliestZombieTime = player.zombification_time;
			}
		}
	}

	if ( /* !zombieExist || */ humanCount > 1 )
	{
		players = GetPlayers( "allies" );

		if ( IsDefined( players ) && players.size > 0 )
		{
			player = array::random( players );
			player thread cover_transition();
			player disappear_in_flash(true);
/#
	//TurnedLog("Player "+player.name+" forced to zombie to limit humans to 1");
#/		
				player zm_turned::turn_to_zombie();
			zombieCount++;
		}
	}

	if ( !humanExist )
	{
		players = GetPlayers( level.zombie_team );

		if ( IsDefined( players ) && players.size > 0 )
		{
			player = array::random( players ); 
			player thread cover_transition();
			player disappear_in_flash(false);
			player.random_human = true;
/#
	//TurnedLog("Player "+player.name+" forced to human to maintain humans at 1");
#/		
			player zm_turned::turn_to_human();
			player.random_human = false;
			zombieCount--;
		}
	}

	level.checking_human_zombie_ratio=0;
}


function get_player_rank()
{
	level.player_score_sort=[];
	
	players = GetPlayers();
	foreach(player in players)
	{
		index = 0;
		while ( index < level.player_score_sort.size && player.score < level.player_score_sort[index].score )
			index++;
		ArrayInsert( level.player_score_sort, player, index );
	}
	
	index = 0;
	while ( index < level.player_score_sort.size )
	{
		if ( self == level.player_score_sort[index] )
			return index;
		index++;
	}
	/# assertMsg( "This should not happen" ); #/
	return 0;
}

function player_add_score( bonus )
{
	mult = 1;
	if (( isdefined( self.is_zombie ) && self.is_zombie ))
		mult = level.zombie_vars[level.zombie_team]["zombie_point_scalar"];
	else
		mult = level.zombie_vars["allies"]["zombie_point_scalar"];
	self zm_score::add_to_player_score( bonus * mult );
}

function player_sub_score( penalty )
{
	penalty = int(min(self.score,penalty));
	self zm_score::add_to_player_score( -penalty );
}


function player_suicide()
{
	self player_sub_score( level.human_player_suicide_penalty );
	/#
	if (GetPlayers().size < 2)
	{
		self.intermission = false;
		thread spawn_initial_cure_powerup();
	}
	#/
}


function player_kills_player( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	
	score_multiplier = 1;
	/*
	// score multiplier by rank
	rank = self get_player_rank();
	if (rank >= 0 && rank < level.score_rank_bonus.size )
		score_multiplier = level.score_rank_bonus[rank];
	*/
	
	// Add score for human player when killing zombie player
	if ( !( isdefined( eAttacker.is_zombie ) && eAttacker.is_zombie ) && IsDefined( level.zombie_player_kill_points ) )
	{
		level notify("killed_by_human",eAttacker,self);
		eAttacker player_add_score( int( score_multiplier * level.zombie_player_kill_points ) );
		
		// player_kills stats tracking
		eAttacker zm_stats::add_global_stat( "PLAYER_KILLS", 1 );

		// increment grenade stat for grenade kills
		if (sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" )
		{
			eAttacker zm_stats::increment_client_stat( "grenade_kills" );
			eAttacker zm_stats::increment_player_stat( "grenade_kills" );
		}
	}
	if ( ( isdefined( eAttacker.is_zombie ) && eAttacker.is_zombie ) && IsDefined( level.human_player_kill_points ) )
	{
		level notify("killed_by_zombie",eAttacker,self);
		eAttacker player_add_score( int( score_multiplier * level.human_player_kill_points ) );
		
		// player_returns stats tracking
		eAttacker zm_stats::add_global_stat( "PLAYER_RETURNS", 1 );
	}
}


function award_round_end_bonus()
{
	level notify( "stop_player_scores" );

	wait 0.25;
	level thread zm_audio_announcer::leaderDialog( "dr_time_line", undefined, undefined, true );
	
	// wait for any pending human,zombie changes to complete
	while ( laststand::player_any_player_in_laststand() ||
			( isdefined( level.in_zombify_call ) && level.in_zombify_call ) )
		wait 0.25;

	hiscore = -1;
	
	foreach( player in GetPlayers() )
	{
		if (!( isdefined( player.is_zombie ) && player.is_zombie ))
		{
			player player_add_score( level.human_finish_bonus_points );
			level.last_human_standing = player;
		}
		if ( player.score > hiscore )
			hiscore = player.score;
	}

	foreach( player in GetPlayers() )
	{
		// winners 
		if ( player.score >= hiscore )
		{
			player.team = player.prevteam;
			player.pers["team"] = player.prevteam;
			player.sessionteam = player.prevteam;

			// stats 
			// setting the wins stat
			player zm_stats::increment_client_stat( "wins" );
			player zm_stats::add_client_stat( "losses", -1 );

			player AddDStat( "skill_rating", 1.0 );
			player SetDStat( "skill_variance", 1.0 );
			
			if ( GameModeIsMode( 0 ) )
			{
				// For leaderboards' combined rank
				player zm_stats::add_location_gametype_stat( level.scr_zm_map_start_location, level.scr_zm_ui_gametype, "wins", 1 );
				player zm_stats::add_location_gametype_stat( level.scr_zm_map_start_location, level.scr_zm_ui_gametype, "losses", -1 );
			}
		}
		else
		{
			player.team = level.zombie_team;
			player.pers["team"] = level.zombie_team;
			player.sessionteam = level.zombie_team;

			// Don't need to increment the losses since the losses is added when the match starts
			player SetDStat( "skill_rating", 0.0 );
			player SetDStat( "skill_variance", 1.0 );

		}
	}
	
}



function player_score_update()
{
	self endon( "_zombie_game_over" );
	self endon( "disconnect" );
	level endon( "stop_player_scores" );
	
	waittime = 0.05;

	while ( true )
	{
		self util::waittill_any_timeout( waittime, "zombify", "humanify" );
		
		if(!( isdefined( self._can_score ) && self._can_score ))
		{
			continue;
		}
		
		if(( isdefined( level.hostMigrationTimer ) && level.hostMigrationTimer ))
		{
			continue;
		}
		
		if ( !( isdefined( level.inGracePeriod ) && level.inGracePeriod ) )
		{
			if ( !cleansed_alive_check(self) )
			{
				waittime = 0.05;
				// player is turning into a zombie or a human or not "alive" for some other reason
			}
			else if ( ( isdefined( self.is_zombie ) && self.is_zombie ) )
			{
				waittime = 	level.zombie_penalty_period;
				self player_sub_score( level.zombie_penalty_points );
			}
			else
			{
				waittime = 	level.human_bonus_period;
				self player_add_score( level.human_bonus_points );
			}
		}
	}
}

function respawn_cleansed_player()
{
	spawnpoint = self zm_turned::getSpawnPoint();
	
	self.sessionstate = "playing";
	self AllowSpectateTeam( "freelook", false );
	self Spawn( spawnpoint.origin, spawnpoint.angles );	

	self notify ("stop_flame_damage");
	self reviveplayer();
	self.nuked = false;
	self.nuker = undefined;
	self.suppress_drops = false;
	self.is_burning = false;
	self.is_zombie = false;
	self.ignoreme = false;
	self util::freeze_player_controls(level.player_movement_suppressed);
	self notify("respawned");
}

//
// POWERUPS
//

//function pointesr for custom zombie and regular powerups
function zcleansed_zombie_powerup_grab(powerup,zombie_player)
{
	if ( !cleansed_alive_check(zombie_player) )
		return false;
	
	switch(powerup.powerup_name)
	{
		case "the_cure":
			
			level notify( "initial_human_selected" );
			
			zombie_player util::freeze_player_controls(true);
			zombie_player disappear_in_flash(false);
			zombie_player zm_turned::turn_to_human();
			
			players = GetPlayers();
			foreach(player in players)
			{
				if (player.is_zombie)
					player thread zombie_ramp_up();
			}
			break;
			
		default:
			if ( isdefined( level.cleansed_powerups[powerup.powerup_name] ) )
			{
				if ( isdefined( level.cleansed_powerups[powerup.powerup_name].callback ) )
				{
					powerup thread [[level.cleansed_powerups[powerup.powerup_name].callback]](zombie_player);
				}
			}
	}
}


function zcleansed_powerup_grab(powerup,player)
{
	if ( !cleansed_alive_check(player) )
		return false;
	
	switch(powerup.powerup_name)
	{
		case "blue_monkey":
			player _zm_weap_cymbal_monkey::player_give_cymbal_monkey();
			player SetWeaponAmmoClip( level.weaponZMCymbalMonkey, 1 );
			player notify( "powerup_blue_monkey" );
		break;
		
		default:
			if ( isdefined( level.cleansed_powerups[powerup.powerup_name] ) )
			{
				if ( isdefined( level.cleansed_powerups[powerup.powerup_name].callback ) )
				{
					powerup thread [[level.cleansed_powerups[powerup.powerup_name].callback]](player);
				}
			}
	}
}

// some powerups need to override the hardcoded timer logic in the powerups script
function zcleansed_powerup_custom_time_logic(powerup)
{
	if (powerup.powerup_name == "the_cure" )
	{
		return 0; //the cure never blinks out
	}
	return 15; //the default wait time for powerups before they start blinking out
}

//spawns the initial cure powerup when the game starts
function spawn_initial_cure_powerup()
{
	struct = array::random( level._turned_powerup_spawnpoints );	
	zm_powerups::specific_powerup_drop( "the_cure", struct.origin);	
}

function spawn_cymbalmonkey( origin )
{
	monkey = zm_powerups::specific_powerup_drop( "blue_monkey", origin);
	return monkey;
}

function check_for_drops( wasHuman )
{
	if (!isdefined(level.cleansed_kills_for_drops))
		level.cleansed_kills_for_drops=0;
		
	if (( isdefined( self.nuked ) && self.nuked ) || ( isdefined( self.suppress_drops ) && self.suppress_drops ) )
		return;
	
	level.cleansed_kills_for_drops++;
	
	chance = (level.cleansed_kills_for_drops - 2) / level.cleansed_kills_for_drops;
	
	if (chance > 0)
	{
		r = RandomFloatRange( 0, 1 );
		if (r < chance)
		{
			self thread drop_powerup(wasHuman);
			level.cleansed_kills_for_drops=0;
		}
	}
}














function add_cleansed_powerup( name, powerupmodel, text, team, zombie_death_frequency, human_death_frequency, callback )
{
	if (!isdefined(level.cleansed_powerups))
	{
		level.cleansed_powerups=[];
	}
	
	if (!isdefined(level.zombie_powerups[name]))
	{
		zm_powerups::include_zombie_powerup(name);
		zm_powerups::add_zombie_powerup( name, powerupmodel, text, &zm_powerups::func_should_never_drop, false, team == 2, team == 1 );
		if ( !isdefined(level.statless_powerups) )
			level.statless_powerups=[];
		
		level.statless_powerups[name]=1;
	}
	
	powerup = SpawnStruct();
	powerup.name = name; 
	powerup.model = powerupmodel; 
	powerup.team = team; 
	powerup.callback = callback; 
	powerup.zfrequency = zombie_death_frequency; 
	powerup.hfrequency = human_death_frequency; 
	
	level.cleansed_powerups[name]=powerup;
}
	
	
function init_cleansed_powerups()
{
	level._effect["powerup_on_solo"]				= "zombie/fx_powerup_on_solo_zmb";
	
	// HUMAN POWERUPS
	//                    NAME             MODEL                           PICKUP TEXT                 PICKUP TEAM          ZOMBIE DEATH FREQ  HUMAN DEATH FREQ   CALLBACK
	add_cleansed_powerup( "green_nuke",    "zombie_bomb",                  &"ZOMBIE_THIS_IS_A_BUG",    0,  .4, 0,   &turned_powerup_green_nuke );
	add_cleansed_powerup( "green_double",  "zombie_x2_icon",               &"ZOMBIE_THIS_IS_A_BUG",    0,  1,  0,   &turned_powerup_green_double );
	add_cleansed_powerup( "green_insta",   "zombie_skull",                 &"ZOMBIE_THIS_IS_A_BUG",    0,  .1,     0,   &turned_powerup_green_insta );
	add_cleansed_powerup( "green_ammo",    "zombie_ammocan",               &"ZOMBIE_POWERUP_MAX_AMMO", 0,  1,  0,   &turned_powerup_green_ammo );
	add_cleansed_powerup( "green_monkey",  level.cymbal_monkey_model,	   &"ZOMBIE_THIS_IS_A_BUG",    0,  .4, 0,   &turned_powerup_green_monkey );
	
	// ZOMBIE POWERUPS
	//                    NAME             MODEL                           PICKUP TEXT                 PICKUP TEAM          ZOMBIE DEATH FREQ  HUMAN DEATH FREQ   CALLBACK
	add_cleansed_powerup( "red_nuke",      "zombie_bomb",                  &"ZOMBIE_THIS_IS_A_BUG",    1, 0,   .4, &turned_powerup_red_nuke );
	add_cleansed_powerup( "red_ammo",      "zombie_ammocan",               &"ZOMBIE_THIS_IS_A_BUG",    1, 0,   1,  &turned_powerup_red_ammo );
	add_cleansed_powerup( "red_double",    "zombie_x2_icon",               &"ZOMBIE_THIS_IS_A_BUG",    1, 0,   1,  &turned_powerup_red_double );

	// COMMON POWERUPS
	//                    NAME             MODEL                           PICKUP TEXT                 PICKUP TEAM          ZOMBIE DEATH FREQ  HUMAN DEATH FREQ   CALLBACK
	add_cleansed_powerup( "yellow_double", "zombie_x2_icon",               &"ZOMBIE_THIS_IS_A_BUG",    2,   .1,     .1,     &turned_powerup_yellow_double );
	add_cleansed_powerup( "yellow_nuke",   "zombie_bomb",                  &"ZOMBIE_THIS_IS_A_BUG",    2,   .01,    .01,    &turned_powerup_yellow_nuke );

	// keep track of last two green powerups and last one red powerup and don't drop them 
	level.cleansed_powerup_history_depth = [];
	level.cleansed_powerup_history_depth[0]=2;
	level.cleansed_powerup_history_depth[1]=1;
	level.cleansed_powerup_history = [];
	level.cleansed_powerup_history[0]=[];
	level.cleansed_powerup_history[1]=[];
	level.cleansed_powerup_history_last = [];
	level.cleansed_powerup_history_last[0] = 0;
	level.cleansed_powerup_history_last[1] = 0;
	for (i=0; i<level.cleansed_powerup_history_depth[0]; i++)
	{
		level.cleansed_powerup_history[0][i] = "none";
		level.cleansed_powerup_history[1][i] = "none";
	}
}


function pick_a_powerup(wasHuman)
{
	total = 0;
	foreach( powerup in level.cleansed_powerups )
	{
		powerup.recent = false;
		for (i=0; i<level.cleansed_powerup_history_depth[wasHuman]; i++)
			if ( level.cleansed_powerup_history[wasHuman][i] == powerup.name )
				powerup.recent = true;
		if (powerup.recent)
			continue;
		if (wasHuman)
			total += powerup.hfrequency;
		else
			total += powerup.zfrequency;
	}
	
	if (total == 0)
		return undefined;
	
	r = randomfloat( total );
	
	foreach( powerup in level.cleansed_powerups )
	{
		if (powerup.recent)
			continue;
		if (wasHuman)
			r -= powerup.hfrequency;
		else
			r -= powerup.zfrequency;
		if (r<=0) 
		{
			level.cleansed_powerup_history[wasHuman][level.cleansed_powerup_history_last[wasHuman]]=powerup.name;
			level.cleansed_powerup_history_last[wasHuman]++;
			if ( level.cleansed_powerup_history_last[wasHuman] >= level.cleansed_powerup_history_depth[wasHuman] )
				level.cleansed_powerup_history_last[wasHuman] = 0;
			return powerup;
	}
	}
	
	return undefined;
}

function drop_powerup(wasHuman)
{
	powerup = pick_a_powerup(wasHuman);

	if (isdefined(powerup))
	{
		origin = self.origin;
		wait 0.25;
		zm_powerups::specific_powerup_drop( powerup.name, origin);	
	}
	
}

function powerup_can_player_grab( player )
{
	// dead, dying and transforming players can't pick up powerups
	if ( !cleansed_alive_check(player) )
		return false;
	
	// team checks
	if ( isdefined( level.cleansed_powerups[self.powerup_name] ) )
	{
		if ( level.cleansed_powerups[self.powerup_name].team == 0 && ( isdefined( player.is_zombie ) && player.is_zombie ) )
		{
			return false;
		}
		if ( level.cleansed_powerups[self.powerup_name].team == 1 && !( isdefined( player.is_zombie ) && player.is_zombie ) )
		{
			return false;
		}
	}
	else
	{
		if ( self.zombie_grabbable && !( isdefined( player.is_zombie ) && player.is_zombie ) )
		{
			return false;
		}
		if ( !self.zombie_grabbable && ( isdefined( player.is_zombie ) && player.is_zombie ) )
		{
			return false;
		}
	}
	
	return true;
}

function player_nuke_fx()
{
	self endon ("death");
	self endon ( "respawned" );
	self endon ("stop_flame_damage");
	
	if( IsDefined( level._effect ) && IsDefined( level._effect["character_fire_death_torso"] ) )
	{
		if ( !self.isdog )
		{
			PlayFxOnTag( level._effect["character_fire_death_torso"], self, "J_SpineLower" );
		}
	}
	if( IsDefined( level._effect ) && IsDefined( level._effect["character_fire_death_sm"] ) )
	{
		wait 1;

		tagArray = [];
		tagArray[0] = "J_Elbow_LE";
		tagArray[1] = "J_Elbow_RI";
		tagArray[2] = "J_Knee_RI";
		tagArray[3] = "J_Knee_LE";
		tagArray = array::randomize( tagArray );

		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[0] );

		wait 1;

		tagArray[0] = "J_Wrist_RI";
		tagArray[1] = "J_Wrist_LE";
		if( !IsDefined( self.a ) || !IsDefined( self.a.gib_ref ) || self.a.gib_ref != "no_legs" )
		{
			tagArray[2] = "J_Ankle_RI";
			tagArray[3] = "J_Ankle_LE";
		}
		tagArray = array::randomize( tagArray );

		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[0] );
		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[1] );
	}
}

function player_nuke( player)
{
	nuke_time = 2;
	self.isdog = false;
	self.nuked = true;
	self.nuker = player;
	self util::freeze_player_controls( true );
	visionset_mgr::activate( "overlay", "zm_transit_burn", self, nuke_time/2, nuke_time );
	self thread player_nuke_fx();
	wait nuke_time;
	if (isdefined(self))
	{
		if (isdefined(player))
			self DoDamage( self.health + 666, player.origin, player, player, "none", "MOD_EXPLOSIVE", 0, GetWeapon( "nuke" ) );
		else
		{
			self.nuked = undefined;
			self DoDamage( self.health + 666, self.origin, self, self, "none", "MOD_EXPLOSIVE", 0, GetWeapon( "nuke" ) );
		}
	}
}

function turned_powerup_green_nuke( player )
{
	location = self.origin;
	PlayFx( level.zombie_powerups["nuke"].fx, location );
	level thread zm_powerup_nuke::nuke_flash();

	players = GetPlayers();
	foreach( target in players )
	{
		if ( !cleansed_alive_check(target) )
		{
		}
		else if ( ( isdefined( target.is_zombie ) && target.is_zombie ) )
		{
			target thread player_nuke( player );
		}
		else
		{
		}
	}
}

function turned_powerup_green_double( player )
{
	level thread zm_powerup_double_points::double_points_powerup( self, player );
}

function turned_powerup_green_insta( player )
{
	level thread zm_powerup_insta_kill::insta_kill_powerup( self, player );
}

function turned_powerup_green_ammo( player )
{
	level thread zm_powerup_full_ammo::full_ammo_powerup( self, player );
	
	weapon = player GetCurrentWeapon();
	player GiveStartAmmo( weapon );
}

function turned_powerup_green_monkey( player )
{
	player _zm_weap_cymbal_monkey::player_give_cymbal_monkey();
	player SetWeaponAmmoClip( level.weaponZMCymbalMonkey, 1 );
	player notify( "powerup_green_monkey" );
}

function turned_powerup_red_nuke( player )
{
	location = self.origin;
	PlayFx( level.zombie_powerups["nuke"].fx, location );
	level thread zm_powerup_nuke::nuke_flash();

	players = GetPlayers();
	foreach( target in players )
	{
		if ( !cleansed_alive_check(target) )
		{
		}
		else if ( ( isdefined( target.is_zombie ) && target.is_zombie ) )
		{
		}
		else
		{
			target thread player_nuke( player );
		}
	}
}

function turned_powerup_red_ammo( player )
{
	level thread zm_powerup_empty_clip::empty_clip_powerup( self );
}

function turned_powerup_red_double( player )
{
	level thread zm_powerup_double_points::double_points_powerup( self, player );
}

function turned_powerup_yellow_double( player )
{
	level thread zm_powerup_double_points::double_points_powerup( self, player );
}

function turned_powerup_yellow_nuke( player )
{
	location = self.origin;
	PlayFx( level.zombie_powerups["nuke"].fx, location );
	level thread zm_powerup_nuke::nuke_flash();

	players = GetPlayers();
	foreach( target in players )
	{
		if ( !cleansed_alive_check(target) )
		{
		}
		else if ( ( isdefined( target.team != player.team ) && target.team != player.team ) )
		{
			target thread player_nuke( player );
		}
	}
}

function playTurnedMusic()
{
	ent = spawn( "script_origin", (0,0,0) );
	ent thread stopTurnedMusic();
	playsoundatposition( "mus_zmb_gamemode_start", (0,0,0) );
	wait(5);
	ent playloopsound( "mus_zmb_gamemode_loop", 5 );
}
function stopTurnedMusic()
{
	level waittill( "end_game" );
	self stoploopsound( 1.5 );
	//playsound( 0, "mus_zmb_gamemode_end", (0,0,0) );
	wait(1);
	self delete();
}
