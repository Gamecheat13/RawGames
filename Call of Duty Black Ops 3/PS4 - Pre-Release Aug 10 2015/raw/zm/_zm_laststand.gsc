#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\zm\_util;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

                                                                                       	                                

#precache( "string", "ZOMBIE_BUTTON_TO_REVIVE_PLAYER" );
#precache( "string", "ZOMBIE_PLAYER_NEEDS_TO_BE_REVIVED" );
#precache( "string", "ZOMBIE_PLAYER_IS_REVIVING_YOU" );	
#precache( "string", "ZOMBIE_REVIVING" );

#namespace zm_laststand;

	// Delay before a revived player becomes visible to zombies again
	
function autoexec __init__sytem__() {     system::register("zm_laststand",&__init__,undefined,undefined);    }

function __init__()
{
	laststand_global_init();

	level.weaponSuicide = GetWeapon( "death_self" );

	level.primaryProgressBarX = 0;
	level.primaryProgressBarY = 110;
	level.primaryProgressBarHeight = 4;
	level.primaryProgressBarWidth = 120;
	level.primaryProgressBarY_ss = 280;

	if( GetDvarString( "revive_trigger_radius" ) == "" )
	{
		SetDvar( "revive_trigger_radius", "40" ); 
	}

	level.lastStandGetupAllowed = false;
}

function laststand_global_init()
{
	level.CONST_LASTSTAND_GETUP_COUNT_START				= 0;		// The number of laststands in type getup that the player starts with

	level.CONST_LASTSTAND_GETUP_BAR_START				= 0.5;		// Fill amount of the getup bar the first time it is used
	level.CONST_LASTSTAND_GETUP_BAR_REGEN				= 0.0025;	// Percent of the bar filled for auto fill logic
	level.CONST_LASTSTAND_GETUP_BAR_DAMAGE				= 0.1;		// Percent of the bar removed by AI damage
}

function player_last_stand_stats( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	//stat tracking
	if ( IsDefined( attacker ) && IsPlayer( attacker ) && attacker != self )
	{
		if ( "zcleansed" == level.gametype )
		{
			demo::bookmark( "kill", gettime(), attacker, self, 0, eInflictor );
		}
		
		if ( "zcleansed" == level.gametype )
		{
			if ( !( isdefined( attacker.is_zombie ) && attacker.is_zombie ) )
			{
				attacker.kills++;  // only a zombie kill increments the scoreboard, even though player stats are incremented normally
			}
			else 
			{
				attacker.downs++;  // only a human kill increments downs
			}
		} 
		else
		{
			attacker.kills++;
		}
		attacker zm_stats::increment_client_stat( "kills" );			//total kills
		attacker zm_stats::increment_player_stat( "kills" );
		attacker AddWeaponStat( weapon, "kills", 1 );

		if ( zm_utility::is_headshot( weapon, sHitLoc, sMeansOfDeath ))
		{
			attacker.headshots++;
			attacker zm_stats::increment_client_stat( "headshots" );	//headshots
			attacker AddWeaponStat( weapon, "headshots", 1 );
			attacker zm_stats::increment_player_stat( "headshots" );
		}
	}
	
	self increment_downed_stat();
	
	if( level flag::get( "solo_game" ) && !self.lives && GetNumConnectedPlayers() < 2 ) //the "solo_game" flag does not get cleared in hot join...so this would inflate the death stats in hot join
	{
		self zm_stats::increment_client_stat( "deaths" );	
		self zm_stats::increment_player_stat( "deaths" );
		self zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
	}	
}

function increment_downed_stat()
{
	if ( "zcleansed" != level.gametype )
	{
		self.downs++;
	}
	
	self zm_stats::increment_client_stat( "downs" );	
	
	self add_weighted_down();
	self zm_stats::increment_player_stat( "downs" );
	zoneName = self zm_utility::get_current_zone();
	if ( !IsDefined( zoneName ) )
	{
		zoneName = "";
	}
	self RecordPlayerDownZombies( zoneName );
}

function PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self notify("entering_last_stand");

	// check to see if we are in a game module that wants to do something with PvP damage
	if( isDefined( level._game_module_player_laststand_callback ) )
	{
		self [[ level._game_module_player_laststand_callback ]]( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
	}

	if( self laststand::player_is_in_laststand() )
	{
		return;
	}

	if (( isdefined( self.in_zombify_call ) && self.in_zombify_call ))
	{
		return;
	}
			
	self thread player_last_stand_stats( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
	
	if( IsDefined( level.playerlaststand_func ) )
	{
		[[level.playerlaststand_func]]( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
	}

	// vision set
	// moved to zm::player_laststand()
	//VisionSetLastStand( "zombie_last_stand", 1 );
	
	self.health = 1;
	self.laststand = true;
	self set_ignoreme( true );
	callback::callback( #"on_player_laststand" );
	self thread gameobjects::on_player_last_stand();
	//self thread zm_buildables::onPlayerLastStand();
	
	//self thread call_overloaded_func( "maps\_arcademode", "arcademode_player_laststand" );

	// revive trigger
	if ( !( isdefined( self.no_revive_trigger ) && self.no_revive_trigger ) )
	{
		self revive_trigger_spawn();
	}
	else
	{
		self UndoLastStand(); // hide the overhead icon if there's no trigger
	}

	// laststand weapons
	if ( ( isdefined( self.is_zombie ) && self.is_zombie ) )
	{
		self TakeAllWeapons();
		
		if ( IsDefined( attacker ) && IsPlayer( attacker ) && attacker != self )
		{
			attacker notify( "killed_a_zombie_player", eInflictor, self, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
		}
	}
	else
	{
		self laststand_disable_player_weapons();
		self laststand_give_pistol();
	}

	if( ( isdefined( level.playerSuicideAllowed ) && level.playerSuicideAllowed ) && GetPlayers().size > 1 )
	{
		if (!IsDefined(level.canPlayerSuicide) || self [[level.canPlayerSuicide]]() )
		{
			self thread suicide_trigger_spawn();
		}
	}
	
	// Reset Disabled Power Perks Array On Downed State
	//-------------------------------------------------
	if ( IsDefined( self.disabled_perks ) )
	{
		self.disabled_perks = [];
	}

	if( level.lastStandGetupAllowed )
	{
		self thread laststand_getup();
	}
	else
	{
		// bleed out timer
		bleedout_time = GetDvarfloat( "player_lastStandBleedoutTime" );
		
		if( isdefined( self.n_bleedout_time_multiplier ) )
		{
			bleedout_time *= self.n_bleedout_time_multiplier;
		}
		
		self thread laststand_bleedout( bleedout_time );
	}
	
	// don't include downs and bleedouts bookmarks in zcleansed, the kills will cover that
	if ( "zcleansed" != level.gametype )
	{
		demo::bookmark( "player_downed", gettime(), self );
	}

	self notify( "player_downed" );
	self thread refire_player_downed();
	
	//clean up revive trigger if he disconnects while in laststand
	self thread laststand::cleanup_laststand_on_disconnect();	
}

function refire_player_downed()
{
	self endon("player_revived");
	self endon("death");
	self endon("disconnect");
	wait(1.0);
	if(self.num_perks)
	{
		self notify("player_downed");
	}
}

// self = a player
function laststand_disable_player_weapons()
{
	weaponInventory = self GetWeaponsList( true );
	self.lastActiveWeapon = self GetCurrentWeapon();
	if ( self IsThrowingGrenade() && zm_utility::is_offhand_weapon( self.lastActiveWeapon ))
	{
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self.lastActiveWeapon = primaryWeapons[0];
			self SwitchToWeaponImmediate( self.lastActiveWeapon );
		}
		
	}
	self SetLastStandPrevWeap( self.lastActiveWeapon );
	self.laststandpistol = undefined;

	self.hadpistol = false;

	if ( isDefined(self.weapon_taken_by_losing_specialty_additionalprimaryweapon) && self.lastActiveWeapon == self.weapon_taken_by_losing_specialty_additionalprimaryweapon )
	{
		self.lastActiveWeapon = level.weaponNone;
		self.weapon_taken_by_losing_specialty_additionalprimaryweapon = level.weaponNone;
	}

	for( i = 0; i < weaponInventory.size; i++ )
	{
		weapon = weaponInventory[i];
		

		wclass = weapon.weapClass;
		if ( weapon.isBallisticKnife )
		{
			wclass = "knife";
		}
		
		if ( ( wclass == "pistol" || wclass == "pistol spread"  || wclass == "pistolspread" ) && !IsDefined( self.laststandpistol ) ) 
		{
			self.laststandpistol = weapon;
			self.hadpistol = true;

		}
		
		if ( weapon == level.weaponReviveTool || ( weapon === self.weaponReviveTool ) )
		{
			// this player was killed while reviving another player
			self zm_stats::increment_client_stat( "failed_sacrifices" );
			self zm_stats::increment_player_stat( "failed_sacrifices" );
			//iprintlnbold("failed the sacrifice - you died while reviving");			
		}
		else if ( weapon.isPerkBottle )
		{
			self TakeWeapon( weapon );
			self.lastActiveWeapon = level.weaponNone;
			continue;			
		}
		
		if(isDefined(zm_utility::get_gamemode_var( "item_meat_weapon" )))
		{
			if(weapon == zm_utility::get_gamemode_var( "item_meat_weapon" ))
			{
				self TakeWeapon( weapon );
				self.lastActiveWeapon = level.weaponNone;
				continue;
			}
		}
	}
	
	if( ( isdefined( self.hadpistol ) && self.hadpistol ) && IsDefined( level.zombie_last_stand_pistol_memory ) )
	{
		self [ [ level.zombie_last_stand_pistol_memory ] ]();
	}

	if ( !IsDefined( self.laststandpistol ) )
	{
		self.laststandpistol = level.laststandpistol;
	}
	
	self DisableWeaponCycling();

	self notify("weapons_taken_for_last_stand");
}


// self = a player
function laststand_enable_player_weapons()
{
	if ( IsDefined( self.hadpistol ) && !self.hadpistol && IsDefined( self.laststandpistol ) )
	{
		self TakeWeapon( self.laststandpistol );
	}
	
	if( IsDefined( self.hadpistol ) && self.hadpistol == true && IsDefined( level.zombie_last_stand_ammo_return ) )
	{
		[ [ level.zombie_last_stand_ammo_return ] ]();
	}
	
	self EnableWeaponCycling();
	self EnableOffhandWeapons();

	// if we can't figure out what the last active weapon was, try to switch a primary weapon
	//CHRIS_P: - don't try to give the player back the mortar_round weapon ( this is if the player killed himself with a mortar round)
	if( self.lastActiveWeapon != level.weaponNone && self HasWeapon( self.lastActiveWeapon ) && !zm_utility::is_placeable_mine( self.lastActiveWeapon ) && !zm_equipment::is_equipment( self.lastActiveWeapon ) )
	{
		self SwitchToWeapon( self.lastActiveWeapon );
	}
	else
	{
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}
}

function laststand_clean_up_on_disconnect( playerBeingRevived, reviverWeapon, revive_tool )
{
	self endon( "do_revive_ended_normally" );

	reviveTrigger = playerBeingRevived.revivetrigger;

	playerBeingRevived waittill("disconnect");	
	
	if( isdefined( reviveTrigger ) )
	{
		reviveTrigger delete();
	}
	self laststand::cleanup_suicide_hud();
	
	if( isdefined( self.reviveProgressBar ) )
	{
		self.reviveProgressBar hud::destroyElem();
	}
	
	if( isdefined( self.reviveTextHud ) )
	{
		self.reviveTextHud destroy();
	}
	
	self revive_give_back_weapons( reviverWeapon, revive_tool );
}

function laststand_clean_up_reviving_any( playerBeingRevived )
{
	self endon( "do_revive_ended_normally" );

	playerBeingRevived util::waittill_any( "disconnect", "zombified", "stop_revive_trigger" );

	self.is_reviving_any--;
	if ( 0 > self.is_reviving_any )
	{
		self.is_reviving_any = 0;
	}
}

function laststand_give_pistol()
{
	assert( IsDefined( self.laststandpistol ) );
	assert( self.laststandpistol != level.weaponNone );

	if( IsDefined( level.zombie_last_stand  ) )
	{
		[ [ level.zombie_last_stand ] ]();
	}
	else
	{
		self GiveWeapon( self.laststandpistol );
		self GiveMaxAmmo( self.laststandpistol );
		self SwitchToWeapon( self.laststandpistol );
	}
}



function Laststand_Bleedout( delay )
{
	self endon ("player_revived");
	self endon ("player_suicide");
	self endon ("zombified");
	self endon ("disconnect");


	if ( ( isdefined( self.is_zombie ) && self.is_zombie ) || ( isdefined( self.no_revive_trigger ) && self.no_revive_trigger ) )
	{
		self notify("bled_out"); 
		util::wait_network_frame(); //to guarantee the notify gets sent and processed before the rest of this script continues to turn the guy into a spectator
	
		self bleed_out();
	
		return;
	}

	//self PlayLoopSound("heart_beat",delay);	// happens on client now DSL

	// Notify client that we're in last stand.
	
	self clientfield::set( "zmbLastStand", 1 );

	self.bleedout_time = delay;

	while ( self.bleedout_time > Int( delay * 0.5 ) )
	{
		self.bleedout_time -= 1;
		wait( 1 );
	}

	VisionSetLastStand( "zombie_death", delay * 0.5 );
	
	while ( self.bleedout_time > 0 )
	{
		self.bleedout_time -= 1;
		wait( 1 );
	}

	//CODER_MOD: TOMMYK 07/13/2008
	while( IsDefined( self.revivetrigger ) && IsDefined( self.revivetrigger.beingRevived ) && self.revivetrigger.beingRevived == 1 )
	{
		wait( 0.1 );
	}
	
	self notify("bled_out"); 
	util::wait_network_frame(); //to guarantee the notify gets sent and processed before the rest of this script continues to turn the guy into a spectator

	self bleed_out();
	
}


function bleed_out()
{
	self laststand::cleanup_suicide_hud();
	if( isdefined( self.reviveTrigger ) )
		self.reviveTrigger delete();
	self.reviveTrigger=undefined;
	
	self clientfield::set( "zmbLastStand", 0 );
	//self AddPlayerStat( "zombie_deaths", 1 );
	self zm_stats::increment_client_stat( "deaths" );
	self zm_stats::increment_player_stat( "deaths" );
	self zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
	self RecordPlayerDeathZombies();

	self zm_equipment::take();

	// don't include downs and bleedouts bookmarks in zcleansed, the kills will cover that
	if ( "zcleansed" != level.gametype )
	{
		demo::bookmark( "zm_player_bledout", gettime(), self, undefined, 1 );
	}
	level notify("bleed_out", self.characterindex);
	//clear the revive icon
	self UndoLastStand();
	
	if (isdefined(level.is_zombie_level ) && level.is_zombie_level)
	{
		self thread [[level.player_becomes_zombie]]();
	}
	else if (isdefined(level.is_specops_level ) && level.is_specops_level)
	{
		self thread [[level.spawnSpectator]]();
	}
	else
	{
		self set_ignoreme( false );
	}
}

function suicide_trigger_spawn()
{
	radius = GetDvarint( "revive_trigger_radius" );

	self.suicidePrompt = newclientHudElem( self );
	
	self.suicidePrompt.alignX = "center";
	self.suicidePrompt.alignY = "middle";
	self.suicidePrompt.horzAlign = "center";
	self.suicidePrompt.vertAlign = "bottom";
	self.suicidePrompt.y = -170;
	if ( self IsSplitScreen() )
	{
		self.suicidePrompt.y = -132;
	}
	self.suicidePrompt.foreground = true;
	self.suicidePrompt.font = "default";
	self.suicidePrompt.fontScale = 1.5;
	self.suicidePrompt.alpha = 1;
	self.suicidePrompt.color = ( 1.0, 1.0, 1.0 );
	self.suicidePrompt.hidewheninmenu = true;

	self thread suicide_trigger_think();
}

// logic for the revive trigger
function suicide_trigger_think()
{
	self endon ( "disconnect" );
	self endon ( "zombified" );
	self endon ( "stop_revive_trigger" );
	self endon ( "player_revived");
	self endon ( "bled_out");
	self endon ("fake_death");
	level endon("end_game");
	level endon("stop_suicide_trigger");
	
	//in case the game ends while this is running
	self thread laststand::clean_up_suicide_hud_on_end_game();
	
	//in case user is holding UseButton while this is running
	self thread laststand::clean_up_suicide_hud_on_bled_out();
	
	// If player was holding use while going into last stand, wait for them to release it
	while ( self UseButtonPressed() )
	{
		wait ( 1 );
	}
	
	if(!isDefined(self.suicidePrompt))
	{
		return;
	}
	
	while ( 1 )
	{
		wait ( 0.1 );
		
		if(!isDefined(self.suicidePrompt))
		{
			continue;
		}
					
		self.suicidePrompt setText( &"ZOMBIE_BUTTON_TO_SUICIDE" );
		
		if ( !self is_suiciding() )
		{
			continue;
		}

		self.pre_suicide_weapon = self GetCurrentWeapon();
		self GiveWeapon( level.weaponSuicide );
		self SwitchToWeapon( level.weaponSuicide );
		duration = self doCowardsWayAnims();

		suicide_success = suicide_do_suicide( duration );
		self.laststand = undefined;
		self TakeWeapon( level.weaponSuicide );

		if ( suicide_success )
		{
			self notify("player_suicide");

			util::wait_network_frame(); //to guarantee the notify gets sent and processed before the rest of this script continues to turn the guy into a spectator

			//Stat Tracking
			self zm_stats::increment_client_stat( "suicides" );
			
			self bleed_out();

			return;
		}

		self SwitchToWeapon( self.pre_suicide_weapon );
		self.pre_suicide_weapon = undefined;
	}
}

function suicide_do_suicide(duration)
{
	level endon("end_game");
	level endon("stop_suicide_trigger");
	
	suicideTime = duration; //1.5;

	timer = 0;

	suicided = false;
	
	self.suicidePrompt setText( "" );
	
	if( !isdefined(self.suicideProgressBar) )
	{
		self.suicideProgressBar = self hud::createPrimaryProgressBar();
	}

	if( !isdefined(self.suicideTextHud) )
	{
		self.suicideTextHud = newclientHudElem( self );
	}
	
	self.suicideProgressBar hud::updateBar( 0.01, 1 / suicideTime );

	self.suicideTextHud.alignX = "center";
	self.suicideTextHud.alignY = "middle";
	self.suicideTextHud.horzAlign = "center";
	self.suicideTextHud.vertAlign = "bottom";
	self.suicideTextHud.y = -173;
	if ( self IsSplitScreen() )
	{
		self.suicideTextHud.y = -147;
	}
	self.suicideTextHud.foreground = true;
	self.suicideTextHud.font = "default";
	self.suicideTextHud.fontScale = 1.8;
	self.suicideTextHud.alpha = 1;
	self.suicideTextHud.color = ( 1.0, 1.0, 1.0 );
	self.suicideTextHud.hidewheninmenu = true;
	self.suicideTextHud setText( &"ZOMBIE_SUICIDING" );
	
	while( self is_suiciding() )
	{
		{wait(.05);};
		timer += 0.05;

		if( timer >= suicideTime)
		{
			suicided = true;
			break;
		}
	}
	
	if( isdefined( self.suicideProgressBar ) )
	{
		self.suicideProgressBar hud::destroyElem();
	}
	
	if( isdefined( self.suicideTextHud ) )
	{
		self.suicideTextHud destroy();
	}
	
	if ( isDefined(self.suicidePrompt) )
	{
		self.suicidePrompt setText( &"ZOMBIE_BUTTON_TO_SUICIDE" );
	}
	return suicided;
}

function can_suicide()
{
	if ( !isAlive( self ) )
	{
		return false;
	}

	if ( !self laststand::player_is_in_laststand() )
	{
		return false;
	}
		
	if ( !isDefined( self.suicidePrompt ) )
	{
		return false;
	}
	
	if ( ( isdefined( self.is_zombie ) && self.is_zombie ) )
	{
		return false;
	}

	if ( ( isdefined( level.intermission ) && level.intermission ) )
	{
		return false;
	}
		
	return true;
}

function is_suiciding( revivee )
{	
	return ( self UseButtonPressed() && can_suicide() );
}



// spawns the trigger used for the player to get revived
function revive_trigger_spawn()
{
	if ( IsDefined( level.revive_trigger_spawn_override_link ) )
	{
		[[ level.revive_trigger_spawn_override_link ]]( self );
	}
	else
	{
		radius = GetDvarint( "revive_trigger_radius" );
		self.revivetrigger = spawn( "trigger_radius", (0.0,0.0,0.0), 0, radius, radius );
		self.revivetrigger setHintString( "" ); // only show the hint string if the triggerer is facing me
		self.revivetrigger setCursorHint( "HINT_NOICON" );
		self.revivetrigger SetMovingPlatformEnabled( true );
		self.revivetrigger EnableLinkTo();
		self.revivetrigger.origin = self.origin;
		self.revivetrigger LinkTo( self ); 

		self.revivetrigger.beingRevived = 0;
		self.revivetrigger.createtime = gettime();
	}

	self thread revive_trigger_think();
	//self.revivetrigger thread revive_debug();
}


// logic for the revive trigger
function revive_trigger_think()
{
	self endon ( "disconnect" );
	self endon ( "zombified" );
	self endon ( "stop_revive_trigger" );
	level endon("end_game");
	self endon( "death" );
	
	while ( 1 )
	{
		wait ( 0.1 );

		self.revivetrigger setHintString( "" );

		players = GetPlayers();

		for ( i = 0; i < players.size; i++ )
		{
			//PI CHANGES - revive should work in deep water for nazi_zombie_sumpf
			d = 0;
			d = self depthinwater();
				
			if ( players[i] can_revive( self ) || d > 20)
			//END PI CHANGES
			{
				// TODO: This will turn on the trigger hint for every player within
				// the radius once one of them faces the revivee, even if the others
				// are facing away. Either we have to display the hints manually here
				// (making sure to prioritize against any other hints from nearby objects),
				// or we need a new combined radius+lookat trigger type.						
				self.revivetrigger setReviveHintString( &"ZOMBIE_BUTTON_TO_REVIVE_PLAYER", self.team );
				break;			
			}
		}

		for ( i = 0; i < players.size; i++ )
		{
			reviver = players[i];
			
			if ( self == reviver || !reviver is_reviving( self ) )
			{
				continue;
			}
			
			revive_tool = level.weaponReviveTool; 
			if ( IsDefined(reviver.weaponReviveTool) )
			{
				revive_tool = reviver.weaponReviveTool; 
			}
			
			// give the syrette
			weapon = reviver GetCurrentWeapon();
			assert( IsDefined( weapon ) );
			if ( weapon == revive_tool )
			{
				//already reviving somebody
				continue;
			}

			reviver GiveWeapon( revive_tool );
			reviver SwitchToWeapon( revive_tool );
			reviver SetWeaponAmmoStock( revive_tool, 1 );

			//CODER_MOD: TOMMY K
			revive_successful = reviver revive_do_revive( self, weapon, revive_tool );
			
			reviver revive_give_back_weapons( weapon, revive_tool );

			//PI CHANGE: player couldn't jump - allow this again now that they are revived
			if ( IsPlayer( self ) )
			{
				self AllowJump(true);
			}
			//END PI CHANGE
			
			self.laststand = undefined;

			if( revive_successful )
			{
				if( isdefined( level.a_revive_success_perk_func ) )
				{
					foreach( func in level.a_revive_success_perk_func )
					{
						self [[ func ]]();
					}
				}
				
				self thread revive_success( reviver );
				self laststand::cleanup_suicide_hud();
				return;
			}
		}
	}
}

function revive_give_back_weapons( weapon, revive_tool )
{
	// take the syrette
	self TakeWeapon( revive_tool ); 

	// Don't switch to their old primary weapon if they got put into last stand while trying to revive a teammate
	if ( self laststand::player_is_in_laststand() )
	{
		return;
	}

	if ( weapon != level.weaponNone && !zm_utility::is_placeable_mine( weapon ) && !zm_equipment::is_equipment( weapon )&& !weapon.isFlourishWeapon && self HasWeapon( weapon ) )
	{
		self SwitchToWeapon( weapon );
	}
	else 
	{
		// try to switch to first primary weapon
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}
}


function can_revive( revivee, ignore_sight_checks = false, ignore_touch_checks = false )
{
	if ( !isDefined( revivee.revivetrigger ) )
	{
		return false;
	}

	if ( !isAlive( self ) )
	{
		return false;
	}

	if ( self laststand::player_is_in_laststand() )
	{
		return false;
	}

	if( self.team != revivee.team ) 
	{
		return false;
	}

	if ( ( isdefined( self.is_zombie ) && self.is_zombie ) )
	{
		return false;
	}

	if ( self zm_utility::has_powerup_weapon() )
	{
		return false;
	}

	if ( ( isdefined( level.can_revive_use_depthinwater_test ) && level.can_revive_use_depthinwater_test ) && revivee depthinwater() > 10 )
	{
		return true;
	}

	if ( isDefined( level.can_revive ) && ![[ level.can_revive ]]( revivee ) )
	{
		return false;
	}

	if ( isDefined( level.can_revive_game_module ) && ![[ level.can_revive_game_module ]]( revivee ) )
	{
		return false;
	}

	if( !ignore_sight_checks && ( IsDefined( level.revive_trigger_should_ignore_sight_checks ) ) )
	{
		ignore_sight_checks = [[ level.revive_trigger_should_ignore_sight_checks ]]( self );

		if( ignore_sight_checks && isdefined(revivee.revivetrigger.beingRevived) && (revivee.revivetrigger.beingRevived==1) )
		{
			ignore_touch_checks = true;
		}
	}

	if( !ignore_touch_checks )
	{
		if ( !self IsTouching( revivee.revivetrigger ) )
		{
			return false;
		}
	}

	if( !ignore_sight_checks )
	{
		if ( !self laststand::is_facing( revivee ) )
		{
			return false;
		}

		if ( !SightTracePassed( self.origin + ( 0, 0, 50 ), revivee.origin + ( 0, 0, 30 ), false, undefined ) )				
		{
			return false;
		}

		//chrisp - fix issue where guys can sometimes revive thru a wall	
		if ( !bullettracepassed( self.origin + (0, 0, 50), revivee.origin + (0, 0, 30), false, undefined ) )
		{
			return false;
		}	
	}

	//iprintlnbold("REVIVE IS GOOD");
	return true;
}

function is_reviving( revivee )
{	
	return ( self UseButtonPressed() && can_revive( revivee ) );
}

function is_reviving_any()
{	
	return ( isdefined( self.is_reviving_any ) && self.is_reviving_any );
}

function revive_get_revive_time( playerBeingRevived )
{
	// reviveTime used to be set from a Dvar, but this can no longer be tunable:
	// it has to match the length of the third-person revive animations for
	// co-op gameplay to run smoothly.
	reviveTime = 3;

	if ( self HasPerk( "specialty_quickrevive" ) )
	{
		reviveTime = reviveTime / 2;
	}

	if( self zm_pers_upgrades_functions::pers_revive_active() )
	{
		//We have the revive persistent upgrade
		reviveTime = reviveTime * 0.5;
	}

	if ( IsDefined(self.get_revive_time) )
	{
		reviveTime = self [[self.get_revive_time]](playerBeingRevived);
	}
	
	return reviveTime;	
}

// self = reviver
function revive_do_revive( playerBeingRevived, reviverWeapon, revive_tool )
{
	assert( self is_reviving( playerBeingRevived ) );

	reviveTime = self revive_get_revive_time( playerBeingRevived );

	timer = 0;
	revived = false;
	
	//CODER_MOD: TOMMYK 07/13/2008
	playerBeingRevived.revivetrigger.beingRevived = 1;
	playerBeingRevived.revive_hud setText( &"ZOMBIE_PLAYER_IS_REVIVING_YOU", self );
	playerBeingRevived laststand::revive_hud_show_n_fade( 3.0 );
	
	playerBeingRevived.revivetrigger setHintString( "" );
	
	if ( IsPlayer( playerBeingRevived ) )
	{
		playerBeingRevived startrevive( self );
	}

	if( !isdefined(self.reviveProgressBar) )
	{
		self.reviveProgressBar = self hud::createPrimaryProgressBar();
	}

	if( !isdefined(self.reviveTextHud) )
	{
		self.reviveTextHud = newclientHudElem( self );
	}
	
	self thread laststand_clean_up_on_disconnect( playerBeingRevived, reviverWeapon, revive_tool );

	if ( !IsDefined( self.is_reviving_any ) )
	{
		self.is_reviving_any = 0;
	}
	self.is_reviving_any++;
	self thread laststand_clean_up_reviving_any( playerBeingRevived );
	
	self.reviveProgressBar hud::updateBar( 0.01, 1 / reviveTime );

	self.reviveTextHud.alignX = "center";
	self.reviveTextHud.alignY = "middle";
	self.reviveTextHud.horzAlign = "center";
	self.reviveTextHud.vertAlign = "bottom";
	self.reviveTextHud.y = -113;
	if ( self IsSplitScreen() )
	{
		self.reviveTextHud.y = -347;
	}
	self.reviveTextHud.foreground = true;
	self.reviveTextHud.font = "default";
	self.reviveTextHud.fontScale = 1.8;
	self.reviveTextHud.alpha = 1;
	self.reviveTextHud.color = ( 1.0, 1.0, 1.0 );
	self.reviveTextHud.hidewheninmenu = true;
	if( self zm_pers_upgrades_functions::pers_revive_active() )
	{
		self.reviveTextHud.color = ( 0.5, 0.5, 1.0 );
	}
	self.reviveTextHud setText( &"ZOMBIE_REVIVING" );
	
	//stat tracking - failed revive
	self thread check_for_failed_revive(playerBeingRevived);
	
	while( self is_reviving( playerBeingRevived ) )
	{
		{wait(.05);};
		timer += 0.05;

		if ( self laststand::player_is_in_laststand() )
		{
			break;
		}
		
		if( IsDefined( playerBeingRevived.revivetrigger.auto_revive ) && playerBeingRevived.revivetrigger.auto_revive == true )
		{
			break;
		}

		if( timer >= reviveTime)
		{
			revived = true;
			break;
		}
	}
	
	if( isdefined( self.reviveProgressBar ) )
	{
		self.reviveProgressBar hud::destroyElem();
	}
	
	if( isdefined( self.reviveTextHud ) )
	{
		self.reviveTextHud destroy();
	}
	
	if( IsDefined( playerBeingRevived.revivetrigger.auto_revive ) && playerBeingRevived.revivetrigger.auto_revive == true )
	{
		// ww: just fall through this part, no stoprevive
	}
	else if( !revived )
	{
		if ( IsPlayer( playerBeingRevived ) )
		{
			playerBeingRevived stoprevive( self );
		}
	}

	// CODER_MOD: TOMMYK 07/13/2008
	playerBeingRevived.revivetrigger setHintString( &"ZOMBIE_BUTTON_TO_REVIVE_PLAYER" );
	playerBeingRevived.revivetrigger.beingRevived = 0;

	self notify( "do_revive_ended_normally" );
	self.is_reviving_any--;

	// This player stopper reviving (kick of a thread to check to see if the player now bleeds out)
	if( !revived )
	{
		playerBeingRevived thread checkforbleedout( self );
	}
	
	return revived;
}


//*****************************************************************************
// Persistent upgrade, revive upgrade lost check
//*****************************************************************************

// self = player who failed to revive a college
function checkforbleedout( player )
{
	self endon ( "player_revived" );
	self endon ( "player_suicide" );
	self endon ( "disconnect" );
	player endon( "disconnect" );

// MikeA: You now automatically lose the upgrade if you fail a revive
/*
	self waittill( "bled_out" );
*/
	
	// Only in classic mode
	if( zm_utility::is_Classic() )
	{
		if(!isdefined(player.failed_revives))player.failed_revives=0;
		player.failed_revives++;
		player notify( "player_failed_revive" );
	}
}


//*****************************************************************************
//*****************************************************************************

function auto_revive( reviver, dont_enable_weapons )
{
	if( IsDefined( self.revivetrigger ) )
	{
		self.revivetrigger.auto_revive = true;
		if( self.revivetrigger.beingRevived == 1 )
		{
			while( 1 )
			{
				if( self.revivetrigger.beingRevived == 0 )
				{
					break;
				}
				util::wait_network_frame();
	
			}
		}
		self.revivetrigger.auto_trigger = false;
	}

	self reviveplayer();

	// Make sure max health is set back to default
	self zm_perks::perk_set_max_health_if_jugg( "health_reboot", true, false );

	self clientfield::set( "zmbLastStand", 0 );
	
	self notify( "stop_revive_trigger" );
	if(isDefined(self.revivetrigger))
	{
		self.revivetrigger delete();
		self.revivetrigger = undefined;
	}
	self laststand::cleanup_suicide_hud();

	if( !IsDefined(dont_enable_weapons) || (dont_enable_weapons == false) )
	{
		self laststand_enable_player_weapons();
	}

	self AllowJump( true );
	
	self util::delay( 2.0, "death", &set_ignoreme, false );
	self.laststand = undefined;

	//don't do this for Grief
	if(!( isdefined( level.isresetting_grief ) && level.isresetting_grief ))
	{
		// ww: moving the revive tracking, wasn't catching below the auto_revive
		if( isPlayer( reviver ) ) //check for cases where robot companion is the reviver
		{
			reviver.revives++;
			//stat tracking
			reviver zm_stats::increment_client_stat( "revives" );
			reviver zm_stats::increment_player_stat( "revives" );
			self RecordPlayerReviveZombies( reviver );
			demo::bookmark( "zm_player_revived", gettime(), reviver, self );
		}
	}

	self notify ( "player_revived", reviver );
}


function remote_revive( reviver )
{
	if ( !self laststand::player_is_in_laststand() )
	{
		return;
	}	

	self auto_revive( reviver );

}


function revive_success( reviver, b_track_stats = true )
{
	// Maybe it was a whoswho corpse that was revived
	if( !IsPlayer(self) )
	{
		self notify ( "player_revived", reviver );
		return;
	}
	
	if( ( isdefined( b_track_stats ) && b_track_stats ) )
	{
		demo::bookmark( "zm_player_revived", gettime(), reviver, self );
	}
	
	self notify ( "player_revived", reviver );
	self reviveplayer();
	
	// Make sure max health is set back to default
	self zm_perks::perk_set_max_health_if_jugg( "health_reboot", true, false );

	// Give player his perks back if he has the "perk_lose" persistent ability
	if( ( isdefined( self.pers_upgrades_awarded["perk_lose"] ) && self.pers_upgrades_awarded["perk_lose"] ) )
	{
		self thread zm_pers_upgrades_functions::pers_upgrade_perk_lose_restore();
	}

	//CODER_MOD: TOMMYK 06/26/2008 - For coop scoreboards
	
	//don't do this for Grief when the rounds reset
	if( !( isdefined( level.isresetting_grief ) && level.isresetting_grief ) && ( isdefined( b_track_stats ) && b_track_stats ) )
	{
		reviver.revives++;
		//stat tracking
		reviver zm_stats::increment_client_stat( "revives" );
		reviver zm_stats::increment_player_stat( "revives" );
		self RecordPlayerReviveZombies( reviver );		
		reviver.upgrade_fx_origin = self.origin;
	}
	
	//only in classic mode
	if(zm_utility::is_Classic() && ( isdefined( b_track_stats ) && b_track_stats ) )
	{
		zm_pers_upgrades_functions::pers_increment_revive_stat( reviver );
	}
	
	if( ( isdefined( b_track_stats ) && b_track_stats ) )
	{
		reviver thread check_for_sacrifice(); //stat tracking 
	}
	
	// CODER MOD: TOMMY K - 07/30/08
	//reviver thread call_overloaded_func( "maps\_arcademode", "arcademode_player_revive" );
					
	//CODER_MOD: Jay (6/17/2008): callback to revive challenge
	if( isdefined( level.missionCallbacks ) )
	{
		// removing coop challenges for now MGORDON
		//maps\_challenges_coop::doMissionCallback( "playerRevived", reviver ); 
	}	
	
	self clientfield::set( "zmbLastStand", 0 );
	
	self.revivetrigger delete();
	self.revivetrigger = undefined;
	self laststand::cleanup_suicide_hud();

	self laststand_enable_player_weapons();
	
	self util::delay( 2.0, "death", &set_ignoreme, false );
  
}


//  Function so this can be threaded and delayed.
function set_ignoreme( b_ignoreme )
{
	if(!isdefined(self.laststand_ignoreme))self.laststand_ignoreme=false;
	if ( b_ignoreme != self.laststand_ignoreme )
	{
		self.laststand_ignoreme = b_ignoreme;
		if ( b_ignoreme )
			self zm_utility::increment_ignoreme();
		else
			self zm_utility::decrement_ignoreme();
	}
}


function revive_force_revive( reviver )
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( self laststand::player_is_in_laststand() );

	self thread revive_success( reviver );
}

//CODER_MOD: TOMMYK 07/13/2008
function revive_hud_think()
{
	level endon("last_player_died");
	
	while ( 1 )
	{
		wait( 0.1 );

		if ( !laststand::player_any_player_in_laststand() )
		{
			continue;
		}
		
		players = GetPlayers();
		playerToRevive = undefined;
			
		for( i = 0; i < players.size; i++ )
		{
			if( !IsDefined( players[i].revivetrigger ) || !isDefined( players[i].revivetrigger.createtime ) )
			{
				continue;
			}
			
			if( !isDefined(playerToRevive) || playerToRevive.revivetrigger.createtime > players[i].revivetrigger.createtime )
			{
				playerToRevive = players[i];
			}
		}
			
		if( isDefined( playerToRevive ) )
		{
			for( i = 0; i < players.size; i++ )
			{
				if( players[i] laststand::player_is_in_laststand() )
				{
					continue;
				}

				if( GetDvarString( "g_gametype" ) == "vs" )
				{
					if( players[i].team != playerToRevive.team ) 
					{
						continue;
					}
				}
				
				if(zm_utility::is_encounter())
				{
					if( players[i].sessionteam != playerToRevive.sessionteam ) 
					{
						continue;
					}
					if(( isdefined( level.hide_revive_message ) && level.hide_revive_message ))
					{
						continue;
					}
				}
				players[i] thread fadeReviveMessageOver( playerToRevive, 3.0 );
			}
			
			playerToRevive.revivetrigger.createtime = undefined;
			wait( 3.5 );
		}		
	}
}

//CODER_MOD: TOMMYK 07/13/2008
function fadeReviveMessageOver( playerToRevive, time )
{
	laststand::revive_hud_show();
	self.revive_hud setText( &"ZOMBIE_PLAYER_NEEDS_TO_BE_REVIVED", playerToRevive );
	self.revive_hud fadeOverTime( time );
	self.revive_hud.alpha = 0;
}

function player_getup_setup()
{
/#	println( "ZM >> player_getup_setup called" );	#/
	self.laststand_info = SpawnStruct();
	self.laststand_info.type_getup_lives = level.CONST_LASTSTAND_GETUP_COUNT_START;
}

function laststand_getup()
{
	self endon ("player_revived");
	self endon ("disconnect");

/#	println( "ZM >> laststand_getup called" );	#/
	self laststand::update_lives_remaining(false);

	self clientfield::set( "zmbLastStand", 1 );

	self.laststand_info.getup_bar_value = level.CONST_LASTSTAND_GETUP_BAR_START;

	self thread laststand::laststand_getup_hud();
	self thread laststand_getup_damage_watcher();

	while ( self.laststand_info.getup_bar_value < 1 )
	{
		self.laststand_info.getup_bar_value += level.CONST_LASTSTAND_GETUP_BAR_REGEN;
		{wait(.05);};
	}

	self auto_revive( self );

	self clientfield::set( "zmbLastStand", 0 );
}

function laststand_getup_damage_watcher()
{
	self endon ("player_revived");
	self endon ("disconnect");

	while(1)
	{
		self waittill( "damage" );

		self.laststand_info.getup_bar_value -= level.CONST_LASTSTAND_GETUP_BAR_DAMAGE;

		if( self.laststand_info.getup_bar_value < 0 )
		{
			self.laststand_info.getup_bar_value = 0;
		}
	}
}

// a sacrifice is when a player sucessfully revives another player, but dies afterwards
function check_for_sacrifice()
{
	self util::delay_notify("sacrifice_denied",1); //dying within 1 second of reviving another player is considered to be a 'sacrifice' 
	self endon("sacrifice_denied");
	
	self waittill("player_downed");
	
	//stat tracking
	self zm_stats::increment_client_stat( "sacrifices" );
	self zm_stats::increment_player_stat( "sacrifices" );
	//iprintlnbold("sacrifice made");
}

//when a player is downed, any player that starts/stops reviving him will fail the revive if the player bleeds out
function check_for_failed_revive(playerBeingRevived) 
{	
	self endon("disconnect");

	playerBeingRevived endon("disconnect");	 //end if the player being revived disconnects
	playerBeingRevived endon("player_suicide");
	
	self notify("checking_for_failed_revive"); //to prevent stacking this thread if the same player starts/stops reviving several times while the player is downed
	self endon("checking_for_failed_revive");
	
	playerBeingRevived endon("player_revived"); //end if the player gets revived
		
	playerBeingRevived waittill("bled_out"); // the player being revived bled out 
	
	//stat tracking
	self zm_stats::increment_client_stat( "failed_revives" );
	self zm_stats::increment_player_stat( "failed_revives" );
	//iprintlnbold("failed the revive");
}


function add_weighted_down()
{
	if ( !level.curr_gametype_affects_rank )
	{
		return;
	}

	weighted_down = 1000;
	if(level.round_number > 0) 
	{
		weighted_down =  Int( 1000.0 / ceil( level.round_number / 5.0 ) ); // multiply the value by 1000 to upload the unsigned integer data
	}
	self AddPlayerStat( "weighted_downs", weighted_down ); 
}
