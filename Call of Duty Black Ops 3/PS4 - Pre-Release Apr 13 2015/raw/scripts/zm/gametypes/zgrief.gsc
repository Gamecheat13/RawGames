#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\gametypes\_zm_gametype;

#using scripts\zm\_zm_audio_announcer;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_game_module_meat_utility;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#using scripts\zm\_zm_powerup_meat_stink;

/*
	zgrief - zgrief Mode, wave based gameplay
	Objective: 	Stay alive for as long as you can
	Map ends:	When all players die
	Respawning:	No wait / Near teammates
*/

#precache( "material","faction_cdc");
#precache( "material","faction_cia");

#precache( "material","waypoint_revive_cdc_zm");
#precache( "material","waypoint_revive_cia_zm");

#precache( "string", "ZOMBIE_POWERUP_MAX_AMMO" );	

#precache( "fx", "_t6/maps/zombie/fx_zmb_meat_impact" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_race_zombie_spawn_cloud" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_impact_noharm" );

function main()
{
	zm_gametype::main();	// Generic zombie mode setup - must be called first.
	
	// Mode specific over-rides.
	
	level.onPrecacheGameType							=&onPrecacheGameType;
	level.onStartGameType								=&onStartGameType;	
	level.custom_spectate_permissions					=&setSpectatePermissionsGrief;

	level._game_module_custom_spawn_init_func			= &zm_gametype::custom_spawn_init_func;
	level._game_module_stat_update_func					= &zm_stats::grief_custom_stat_update;
	level._game_module_player_damage_callback			= &zm_gametype::game_module_player_damage_callback;

	level.custom_end_screen								=&custom_end_screen;

	level.gamemode_map_postinit["zgrief"]				=&postinit_func;

	level._supress_survived_screen = 1;

	level.game_module_team_name_override_og_x = 155;


	level.prevent_player_damage							=&player_prevent_damage;
	level._game_module_player_damage_grief_callback		=&game_module_player_damage_grief_callback;
	
	level._grief_reset_message =&grief_reset_message;
	level._game_module_player_laststand_callback			=&grief_laststand_weapon_save;
	level.onPlayerSpawned_restore_previous_weapons			=&grief_laststand_weapons_return;
	level.game_module_onPlayerConnect						=&grief_onPlayerConnect; //called when a player spawns
	//level.round_start_custom_func							=&grief_store_player_scores; //gives them the same score they had at the beginning of the round if the round restarts
	//level.gamemode_post_spawn_logic						=&grief_restore_player_score;
	level.game_mode_spawn_player_logic						=&game_mode_spawn_player_logic;
	level.game_mode_custom_onPlayerDisconnect				=&grief_onPlayerDisconnect;
	
	zm_gametype::post_gametype_main("zgrief");
}

function grief_onPlayerConnect() //called on a player when they spawn in
{
	self thread move_team_icons();
//T7TODO	self thread zmeat::create_item_meat_watcher();
	self thread zgrief_player_bled_out_msg();
}

function grief_onPlayerDisconnect(disconnecting_player)
{
	level thread update_players_on_bleedout_or_disconnect(disconnecting_player);

}

function setSpectatePermissionsGrief()
{
	self AllowSpectateTeam( "allies", true );
	self AllowSpectateTeam( "axis", true );
	self AllowSpectateTeam( "freelook", false );
	self AllowSpectateTeam( "none", true );	
}


function custom_end_screen()
{
	players = GetPlayers();

	for( i = 0; i < players.size; i++ )
	{
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
		winner_text = &"ZOMBIE_GRIEF_WIN";
		loser_text = &"ZOMBIE_GRIEF_LOSE";
		
		if(level.round_number < 2)
		{
			winner_text = &"ZOMBIE_GRIEF_WIN_SINGLE";
			loser_text = &"ZOMBIE_GRIEF_LOSE_SINGLE";
		}
		
		if(( isdefined( level.host_ended_game ) && level.host_ended_game ))
		{
			players[i].survived_hud SetText( &"MP_HOST_ENDED_GAME" );
		}
		else if( isdefined(level.gameModuleWinningTeam) && players[i]._encounters_team == level.gameModuleWinningTeam )
		{
			players[i].survived_hud SetText( winner_text, (level.round_number) );
		}
		else
		{
			players[i].survived_hud SetText( loser_text, (level.round_number) );
		}
		
		players[i].survived_hud FadeOverTime( 1 );
		players[i].survived_hud.alpha = 1;
	}
}

function postinit_func()
{
	level.min_humans = 1;
	level.zombie_ai_limit = 24;
	
	//Set start round for grief
//	level.round_number = 5;
//	level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];
	
	level.prevent_player_damage		=&player_prevent_damage;
	//level._zombiemode_custom_box_move_logic =&custom_box_move_logic;
		
//	level.zombie_vars[ "spectators_respawn" ] = 0;
	//level.spectateType = 2;
			
	level.lock_player_on_team_score = true;
		
	level.meat_bounce_override =&meat_bounce_override;
		
//	level.magic_box_grab_by_anyone = true;
//	zm_pap_util::set_grabbable_by_anyone();

	level._zombie_spawning = false;
	level._get_game_module_players = undefined;
	level.powerup_drop_count = 0;
	level.is_zombie_level=true;

	level._effect["meat_impact"] = "_t6/maps/zombie/fx_zmb_meat_impact";
	level._effect[ "spawn_cloud" ] = "_t6/maps/zombie/fx_zmb_race_zombie_spawn_cloud";
	
	//Remove All PowersUps Except Meat Stink
//	level.zombie_powerup_array = [];
//	level.zombie_include_powerups = [];
		
//	level flag::set("door_can_close");
	
	SetMatchTalkFlag( "DeadChatWithDead", 1 );
	SetMatchTalkFlag( "DeadChatWithTeam", 1 );
	SetMatchTalkFlag( "DeadHearTeamLiving", 1 );
	SetMatchTalkFlag( "DeadHearAllLiving", 1 );
	SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );	
}

function minigun_no_drop()
{
	//Any stinks active in map? check to see if any player shave ignoreme set or we already have an attractor in the map
	players = GetPlayers();
	for ( i=0; i<players.size; i++ )
	{
		if( players[i].ignoreme== true )
		{
			return true;
		}
	}

	if( ( isdefined( level.meat_on_ground ) && level.meat_on_ground ) )
		return true;

	//Ok we can drop a meat
	return false;
}
	
	
function grief_game_end_check_func()
{	
	return false;
}


function player_prevent_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if ( isdefined( eAttacker ) && IsPlayer( eAttacker ) && self != eAttacker && !eAttacker HasPerk( "specialty_playeriszombie" ) && !( isdefined( self.is_zombie ) && self.is_zombie ) )
	{
		return true;
	}

	return false;
}

function game_module_player_damage_grief_callback( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	penalty = 10;
	
	if ( isdefined( eAttacker ) && IsPlayer( eAttacker ) && eAttacker != self && eAttacker.team != self.team && sMeansOfDeath == "MOD_MELEE" )
	{
		self ApplyKnockBack( iDamage, vDir );	//If a player from the other team attack you then apply knockback

		/*if ( self.score >= penalty )
		{
			self zm_score::minus_to_player_score( penalty );
		}
		else if ( self.score > 0 )
		{
			self zm_score::minus_to_player_score( self.score );
		}*/
	}
}

function onPrecacheGameType()
{
	level.playerSuicideAllowed = true;
	level.canPlayerSuicide =&zm_gametype::canPlayerSuicide;
	level._effect["butterflies"] = "_t6/maps/zombie/fx_zmb_impact_noharm";

	level thread  zm_game_module_meat_utility::init_item_meat();
	level thread zm_gametype::init();

	zm_gametype::runGameTypePrecache("zgrief");
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

	level.no_end_game_check = true;
	level._game_module_game_end_check =&grief_game_end_check_func; 
	level.round_end_custom_logic =&grief_round_end_custom_logic;

	//setup all the classic mode stuff 
	zm_gametype::setup_classic_gametype();
	zm_gametype::runGameTypeMain("zgrief",&zgrief_main );
}

function zgrief_main()
{	
	players = GetPlayers();
	foreach(player in players)
	{
		player.is_hotjoin = false;
	}
	
	wait(1);
	PlaySoundAtPosition("vox_zmba_grief_intro_0",(0,0,0));	
}

function move_team_icons()
{
	self endon("disconnect");
	
	level flag::wait_till("initial_blackscreen_passed");

	wait(0.5);	
}

function kill_start_chest()
{
	level flag::wait_till("initial_blackscreen_passed");

	wait(2);
	
	//hide the starting chest
	start_chest = struct::get("start_chest","script_noteworthy");
	start_chest zm_magicbox::hide_chest();	
}

function meat_bounce_override( pos, normal, ent )
{
	if ( isdefined( ent ) && IsPlayer( ent ) )
	{
		//Directly hit a player!
		if( !ent laststand::player_is_in_laststand() )
		{
			level thread zm_powerup_meat_stink::meat_stink_player( ent );
			
			//stat tracking 
			if(isdefined(self.owner))
			{
				demo::bookmark( "zm_player_meat_stink", gettime(), self.owner, ent, 0, self );
				self.owner zm_stats::increment_client_stat( "contaminations_given" );
			}
		}
	}
	else
	{
		//Do a check and see if any players are close to this bounce!
		players = GetPlayers();
		closest_player = undefined;
		closest_player_dist = 100.0 * 100.0;	//distance for splash from meat
		for ( player_index = 0; player_index < players.size; player_index++ )
		{
			player_to_check = players[player_index];
			
			if( self.owner == player_to_check )
				continue;

			if( player_to_check laststand::player_is_in_laststand() )
				continue;
			
			distSq =  distancesquared( pos, player_to_check.origin );
			
			if( distSq < closest_player_dist )
			{
				closest_player = player_to_check;
				closest_player_dist = distSq;
			}
		}
		
		if( isdefined( closest_player ) )
		{
			level thread zm_powerup_meat_stink::meat_stink_player( closest_player );
			
			//stat tracking 
			if(isdefined(self.owner))
			{
				demo::bookmark( "zm_player_meat_stink", gettime(), self.owner, closest_player, 0, self );
				self.owner zm_stats::increment_client_stat( "contaminations_given" );
			}
		}
		else
		{
			valid_poi = zm_utility::check_point_in_enabled_zone( pos );
			
			if ( valid_poi )
			{
				self Hide();
				level thread zm_powerup_meat_stink::meat_stink_on_ground( self.origin );
			}
		}
		PlayFX( level._effect[ "meat_impact" ], self.origin );		
	}
	
	self Delete();
}

function door_close_zombie_think()
{
	self endon( "death" );
	
	while ( IsAlive( self ) )
	{
		if ( isdefined( self.enemy ) && IsPlayer( self.enemy ) )
		{
			// They're In Same Zone Check First
			//---------------------------------
			inSameZone = false;
			keys = GetArrayKeys( level.zones );
			for ( i = 0; i < keys.size; i ++ )
			{
				if ( self zm_zonemgr::entity_in_zone( keys[ i ] ) && self.enemy zm_zonemgr::entity_in_zone( keys[ i ] ) )
				{
					inSameZone = true;
				}
			}
			
			if ( inSameZone )
			{
				wait ( 3 );
				
				continue;
			}
			
			// See If Can See and Path To Node
			//--------------------------------
			nearestZombieNode = GetNearestNode( self.origin );
			nearestPlayerNode = GetNearestNode( self.enemy.origin );

			if ( isdefined( nearestZombieNode ) && isdefined( nearestPlayerNode ) )
			{
				if ( !NodesVisible( nearestZombieNode, nearestPlayerNode ) /*&& !NodesCanPath( nearestZombieNode, nearestPlayerNode )*/ )
				{
					self silentlyRemoveZombie();
				}
			}
		}
		
		wait ( 1 );
	}
}

function silentlyRemoveZombie()
{
	level.zombie_total++;
					
	PlayFX( level._effect[ "spawn_cloud" ], self.origin );
	
	self.skip_death_notetracks = true;
	self.nodeathragdoll = true;
	self DoDamage( self.maxhealth * 2, self.origin, self, self, "none", "MOD_SUICIDE" );
	self zm_utility::self_delete();
}


function zgrief_player_bled_out_msg()
{
	level endon("end_game");
	self endon("disconnect");

	while(1)
	{
		self waittill("bled_out");
		level thread update_players_on_bleedout_or_disconnect(self);
	}
}
function show_grief_hud_msg(msg,msg_parm,offset,cleanup_end_game)
{
	self endon("disconnect");

	while(isdefined( level.hostMigrationTimer ) )
	{
		{wait(.05);};
	}
	
	zgrief_hudmsg = NewClientHudElem( self );
	zgrief_hudmsg.alignX = "center";
	zgrief_hudmsg.alignY = "middle";
	zgrief_hudmsg.horzAlign = "center";
	zgrief_hudmsg.vertAlign = "middle";
	zgrief_hudmsg.y -= 130;
	if ( self isSplitScreen() )
	{
		zgrief_hudmsg.y += 70;
	}
	if(isdefined(offset))
	{
		zgrief_hudmsg .y = zgrief_hudmsg .y + offset;
	}
	zgrief_hudmsg.foreground = true;
	zgrief_hudmsg.fontScale = 5;
	zgrief_hudmsg.alpha = 0;
	zgrief_hudmsg.color = ( 1.0, 1.0, 1.0 );
	zgrief_hudmsg.hidewheninmenu = true;
	zgrief_hudmsg.font = "default";
	
	if ( ( isdefined( cleanup_end_game ) && cleanup_end_game ) )
	{
		level endon( "end_game" );
		zgrief_hudmsg thread show_grief_hud_msg_cleanup();
	}
	
	if(isdefined(msg_parm))
	{
		zgrief_hudmsg  SetText( msg,msg_parm );
	}
	else
	{
		zgrief_hudmsg  SetText( msg );
	}
	
	zgrief_hudmsg ChangeFontScaleOverTime(.25);
	zgrief_hudmsg FadeOverTime( .25 );
	zgrief_hudmsg.alpha = 1;
	zgrief_hudmsg.fontScale = 2;
	wait(3.25);
	zgrief_hudmsg ChangeFontScaleOverTime(1);
	zgrief_hudmsg FadeOverTime( 1 );
	zgrief_hudmsg.alpha = 0;
	zgrief_hudmsg.fontScale = 5;
	wait(1);
	zgrief_hudmsg notify( "death" );
	if ( isdefined( zgrief_hudmsg ) )
	{
		zgrief_hudmsg destroy();
	}	
}

function show_grief_hud_msg_cleanup()
{
	self endon( "death" );
	
	level waittill( "end_game" );
	
	if ( isdefined( self ) )
	{
		self Destroy();
	}
}

function grief_reset_message()
{
	msg = &"ZOMBIE_GRIEF_RESET";
	players = GetPlayers();
	
	if(isdefined(level.hostMigrationTimer))
	{
		while(isdefined(level.hostMigrationTimer))
		{
			{wait(.05);};
		}
		
		wait 4;
	}

	foreach(player in players)
	{
		player thread show_grief_hud_msg(msg);
	}
	level thread zm_audio_announcer::leaderDialog( "grief_restarted");
}

function grief_laststand_weapon_save(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{

	self.grief_savedweapon_weapons = self GetWeaponsList();
	self.grief_savedweapon_weaponsammo_stock = [];
	self.grief_savedweapon_weaponsammo_clip = [];
	self.grief_savedweapon_currentweapon = self GetCurrentWeapon();
	
	// grenades
	self.grief_savedweapon_grenades = self zm_utility::get_player_lethal_grenade();
	if ( isdefined( self.grief_savedweapon_grenades ) )
	{
		self.grief_savedweapon_grenades_clip = self GetWeaponAmmoClip( self.grief_savedweapon_grenades );
	}
	
	// tacticals
	self.grief_savedweapon_tactical = self zm_utility::get_player_tactical_grenade();
	if ( isdefined( self.grief_savedweapon_tactical ) )
	{
		self.grief_savedweapon_tactical_clip = self GetWeaponAmmoClip( self.grief_savedweapon_tactical );
	}
	
	for (i=0; i < self.grief_savedweapon_weapons.size; i++)
	{
		self.grief_savedweapon_weaponsammo_clip[i] =  self GetWeaponAmmoclip( self.grief_savedweapon_weapons[i] );
		self.grief_savedweapon_weaponsammo_stock[i] =  self GetWeaponAmmoStock( self.grief_savedweapon_weapons[i] );
	}

	// riotshield
	if ( ( isdefined( self.hasRiotShield ) && self.hasRiotShield ) )
	{
		self.grief_hasRiotShield = true;
	}
	
	// placeable_mine
	if ( IsDefined( zm_utility::get_player_placeable_mine() ) )
	{
		self.grief_savedweapon_placeable_mine = zm_utility::get_player_placeable_mine();
		self.grief_savedweapon_placeable_mine_clip = self GetWeaponAmmoClip( zm_utility::get_player_placeable_mine() );
	}	
	
	// equipment
	if ( IsDefined( self.current_equipment ) )
	{
		self.grief_savedweapon_equipment = self.current_equipment;
	}
}

function grief_laststand_weapons_return()
{
	if(!( isdefined( level.isresetting_grief ) && level.isresetting_grief )) //failsafe to ensure we only do this if the round has been reset
	{
		return false;
	}
	
	if(!isdefined(self.grief_savedweapon_weapons))
	{
		return false;
	}
	
	primary_weapons_returned = 0;
	
	foreach ( index, weapon in self.grief_savedweapon_weapons )
	{
		// Skip If Weapon Is Primary Grenade Or Tactical Which Is Restore Below Elsewhere
		if ( ( isdefined( self.grief_savedweapon_grenades ) && weapon == self.grief_savedweapon_grenades ) ||
			( isdefined( self.grief_savedweapon_tactical ) && weapon == self.grief_savedweapon_tactical ) )
		{
			continue;
		}
		
		// Skip If Two Primary Weapons Returned Already, Players Don't Have Perks (Mule Included) When Respawnining In Grief
		if ( weapon.isPrimary )
		{
			if ( primary_weapons_returned >= 2 )
			{
				continue;
			}
			
			primary_weapons_returned++;
		}

		// don't give them the meat stink back, they shouldn't have it and it will keep them from picking it up later
		if ( GetWeapon( "meat_stink" ) == weapon )
		{
			continue;
		}

		self GiveWeapon( weapon, self zm_weapons::get_pack_a_punch_weapon_options( weapon ) );
		if ( IsDefined ( self.grief_savedweapon_weaponsammo_clip[ index ] ) )
		{
			self SetWeaponAmmoClip( weapon, self.grief_savedweapon_weaponsammo_clip[ index ]);
		}
		if ( IsDefined ( self.grief_savedweapon_weaponsammo_stock[ index ] ) )
		{
			self SetWeaponAmmoStock( weapon, self.grief_savedweapon_weaponsammo_stock[ index ]);
		}		
	}	
	
	// grenades
	if ( IsDefined( self.grief_savedweapon_grenades ) )
	{
		self GiveWeapon( self.grief_savedweapon_grenades );
		
		if ( IsDefined( self.grief_savedweapon_grenades_clip ) )
		{
			self SetWeaponAmmoClip( self.grief_savedweapon_grenades, self.grief_savedweapon_grenades_clip );
		}
	}
	
	// tacticals
	if ( IsDefined( self.grief_savedweapon_tactical ) )
	{
		self GiveWeapon( self.grief_savedweapon_tactical );
		
		if ( IsDefined( self.grief_savedweapon_tactical_clip ) )
		{
			self SetWeaponAmmoClip( self.grief_savedweapon_tactical, self.grief_savedweapon_tactical_clip );
		}
	}
	
	// equipment 
	// remove current equipment
	if ( IsDefined( self.current_equipment ) )
	{
		self zm_equipment::take( self.current_equipment );	
	}
	
	// give back equipment, if appropriate
	if ( IsDefined( self.grief_savedweapon_equipment ) )
	{
		self.do_not_display_equipment_pickup_hint = true;
		self zm_equipment::give( self.grief_savedweapon_equipment );
		self.do_not_display_equipment_pickup_hint = undefined;		
	}
	
	//riotshield
	if ( ( isdefined( self.grief_hasRiotShield ) && self.grief_hasRiotShield ) )
	{
		self zm_equipment::give( level.weaponRiotshield );
	
		if ( isdefined( self.player_shield_reset_health ) )
		{
			self [[ self.player_shield_reset_health ]]();
		}
	}	
	
	// placeable_mine
	if ( ( isdefined( self.grief_savedweapon_placeable_mine ) && self.grief_savedweapon_placeable_mine ) )
	{
		self GiveWeapon( self.grief_savedweapon_placeable_mine );
		self zm_utility::set_player_placeable_mine( self.grief_savedweapon_placeable_mine );
		self SetActionSlot( 4, "weapon", self.grief_savedweapon_placeable_mine );
		self SetWeaponAmmoClip( self.grief_savedweapon_placeable_mine, self.grief_savedweapon_placeable_mine_clip );
	}
	
	primaries = self GetWeaponsListPrimaries();
	foreach ( weapon in primaries )
	{
		if ( isdefined( self.grief_savedweapon_currentweapon ) && self.grief_savedweapon_currentweapon == weapon )
		{
			self SwitchToWeapon( weapon );
			return true;
		}
	}
	
	if ( primaries.size > 0 )
	{
		self SwitchToWeapon( primaries[0] );
		return true;
	}	
	
	//if it made it here then something went wrong
	Assert( primaries.size > 0, "GRIEF: There was a problem restoring the weapons" );
	return false;
}

function grief_store_player_scores()
{
	players = GetPlayers();
	foreach(player in players)
	{
		player._pre_round_score = player.score;
	}
}


function grief_restore_player_score()
{
	if(!isdefined(self._pre_round_score))
	{
		self._pre_round_score = self.score;
	}
	
	if(isdefined(self._pre_round_score))
	{	
		self.score = self._pre_round_score;
		self.pers["score"] = self._pre_round_score;
	}
}

function game_mode_spawn_player_logic()
{
	if(level flag::get( "start_zombie_round_logic" ) && !isdefined(self.is_hotjoin))
	{
		self.is_hotjoin = true;
		return true;
	}
	return false;
}

function update_players_on_bleedout_or_disconnect(excluded_player)
{
	other_team = undefined;
		
	players = GetPlayers();
	players_remaining = 0;
	foreach(player in players)
	{
		if(player == excluded_player)
		{
			continue;
		}
		if (player.team == excluded_player.team)
		{
			if(zm_utility::is_player_valid(player))
			{
				players_remaining++;
			}
			
			continue;
		}						
	}
	
	foreach(player in players)
	{
		if(player == excluded_player)
		{
			continue;
		}
		if(player.team != excluded_player.team)
		{
			other_team = player.team;
			if(players_remaining < 1)
			{
				player thread show_grief_hud_msg( &"ZOMBIE_ZGRIEF_ALL_PLAYERS_DOWN",undefined,undefined,true);
				player util::delay(2, undefined, &show_grief_hud_msg,&"ZOMBIE_ZGRIEF_SURVIVE",undefined,30,true);
			}
			else
			{
				player thread show_grief_hud_msg( &"ZOMBIE_ZGRIEF_PLAYER_BLED_OUT",players_remaining);
			}
		}
	}
	if(players_remaining == 1)
	{
		level thread zm_audio_announcer::leaderDialog( "last_player",excluded_player.team );
	}
	if(!isdefined(other_team))
	{
		return;
	}
	if(players_remaining < 1)
	{
		level thread zm_audio_announcer::leaderDialog( "4_player_down",other_team ); 			
	}
	else
	{
		level thread zm_audio_announcer::leaderDialog( players_remaining + "_player_left",other_team );
	}
}

function delay_thread_watch_host_migrate(timer, func, param1, param2, param3, param4, param5, param6)
{
	self thread _delay_thread_watch_host_migrate_proc(func, timer, param1, param2, param3, param4, param5, param6);
}

function _delay_thread_watch_host_migrate_proc(func, timer, param1, param2, param3, param4, param5, param6)
{
	self endon( "death" );
	self endon( "disconnect" );
	
	wait( timer );

	if(isdefined( level.hostMigrationTimer ) )
	{
		while(isdefined(level.hostMigrationTimer))
		{
			{wait(.05);};
		}
		
		wait( timer );
	}
	
	util::single_thread( self, func, param1, param2, param3, param4, param5, param6 );
}

function grief_round_end_custom_logic()
{
	//delay so that players don't respawn and the round ends correctly
	waittillframeend;
	if(isdefined(level.gameModuleWinningTeam )) //we have a winner
	{
		level notify("end_round_think");
	}
	
}
