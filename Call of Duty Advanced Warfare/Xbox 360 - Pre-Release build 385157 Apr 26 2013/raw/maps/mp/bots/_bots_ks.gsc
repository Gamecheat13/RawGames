#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_gamelogic;

#include maps\mp\bots\_bots;
#include maps\mp\bots\_bots_util;

/#
KILLSTREAK_STRING_TABLE = "mp/killstreakTable.csv";
#/
	
//========================================================
//				bot_killstreak_setup
//========================================================

bot_killstreak_setup()
{
 	if ( !IsDefined( level.killstreak_botfunc ) )
	{
//		bot_register_killstreak_func( "counter_uav",  						::bot_killstreak_simple_use );
		bot_register_killstreak_func( "emp",  								::bot_killstreak_simple_use );
		bot_register_killstreak_func( "helicopter",  						::bot_killstreak_simple_use );
//		bot_register_killstreak_func( "littlebird_flock",  					::bot_killstreak_simple_use );
		bot_register_killstreak_func( "littlebird_support",  				::bot_killstreak_simple_use );
//		bot_register_killstreak_func( "directional_uav",					::bot_killstreak_simple_use );
//		bot_register_killstreak_func( "uav",  								::bot_killstreak_simple_use );
//		bot_register_killstreak_func( "uav_support",  						::bot_killstreak_simple_use );
//		bot_register_killstreak_func( "ball_drone_radar", 					::bot_killstreak_simple_use );
//		bot_register_killstreak_func( "ball_drone_backup", 					::bot_killstreak_simple_use );
//		bot_register_killstreak_func( "ball_drone_3dping", 					::bot_killstreak_simple_use );

		bot_register_killstreak_func( "airdrop_assault",  					::bot_killstreak_airdrop );
		bot_register_killstreak_func( "airdrop_juggernaut",  				::bot_killstreak_airdrop );
		bot_register_killstreak_func( "airdrop_juggernaut_recon",  			::bot_killstreak_airdrop );
		bot_register_killstreak_func( "airdrop_remote_tank",  				::bot_killstreak_airdrop );
		bot_register_killstreak_func( "airdrop_sentry_minigun",  			::bot_killstreak_airdrop );
//		bot_register_killstreak_func( "airdrop_trap",  						::bot_killstreak_airdrop );
		bot_register_killstreak_func( "deployable_vest",  					::bot_killstreak_airdrop );
		bot_register_killstreak_func( "escort_airdrop",  					::bot_killstreak_airdrop );
		bot_register_killstreak_func( "helicopter_flares",  				::bot_killstreak_airdrop );

		bot_register_killstreak_func( "precision_airstrike",  				::bot_killstreak_choose_loc_enemies );
		bot_register_killstreak_func( "stealth_airstrike",  				::bot_killstreak_choose_loc_enemies );

		/* Not yet supported
		bot_register_killstreak_func( "ac130",  							::bot_killstreak_simple_use );
		bot_register_killstreak_func( "nuke",  								::bot_killstreak_simple_use );
		bot_register_killstreak_func( "osprey_gunner",  					::bot_killstreak_simple_use );
		bot_register_killstreak_func( "predator_missile",  					::bot_killstreak_simple_use );
		bot_register_killstreak_func( "remote_mg_turret",  					::bot_killstreak_simple_use );
		bot_register_killstreak_func( "remote_mortar",  					::bot_killstreak_simple_use );
		bot_register_killstreak_func( "remote_tank",  						::bot_killstreak_simple_use );
		bot_register_killstreak_func( "remote_uav",  						::bot_killstreak_simple_use );
		bot_register_killstreak_func( "ims",  								::bot_killstreak_simple_use );
		*/

		bot_register_killstreak_func( "sam_turret",  						maps\mp\bots\_bots_sentry::bot_killstreak_sentry );
		bot_register_killstreak_func( "sentry",  							maps\mp\bots\_bots_sentry::bot_killstreak_sentry );
		
		/#		
		bot_validate_killstreak_funcs();
		#/
	}
}


//========================================================
//				bot_register_killstreak_func 
//========================================================
bot_register_killstreak_func( name, func )
{
 	if ( !IsDefined( level.killstreak_botfunc ) )
		level.killstreak_botfunc = [];

	level.killstreak_botfunc[name] = func;
	
	/#
 	if ( !IsDefined( level.killstreak_botfuncname ) )
		level.killstreak_botfuncname = [];
	level.killstreak_botfuncname[level.killstreak_botfuncname.size] = name;
	#/
}


/#
//========================================================
//				bot_validate_killstreak_funcs 
//========================================================
bot_validate_killstreak_funcs( )
{
	errors = [];
	foreach( streakName in level.killstreak_botfuncname )
	{
		if ( !IsDefined( level.killstreakFuncs[streakName] ) || tableLookup( KILLSTREAK_STRING_TABLE, 1, streakName, 0 ) == "" )
		{
			error( "bot_validate_killstreak_funcs() invalid killstreak: " + streakName );		
			errors[errors.size] = streakName;
		}
	}
	if ( errors.size )
	{
		temp = level.killstreakFuncs;
		level.killStreakFuncs = [];
		foreach( streakName in level.killstreak_botfuncname )
		{
			if ( !array_contains( errors, streakName ) )
				level.killStreakFuncs[streakName] = temp[streakName];
		}
	}
}
#/
	
//========================================================
//				bot_think_killstreak 
//========================================================
bot_think_killstreak()
{
	self notify( "bot_think_killstreak" );
	self endon(  "bot_think_killstreak" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	for(;;)
	{		
		if ( IsDefined( level.killstreak_botfunc ) && IsDefined( self.pers["killstreaks"] ) && self bot_allowed_to_use_killstreaks() )
		{
			wait 0.05;
			
			for ( ksi = 0; ksi < self.pers["killstreaks"].size; ksi++ )
			{
				wait 0.05;
				
				killstreak_info = self.pers["killstreaks"][ksi];
				
				if ( killstreak_info.available )
				{				
					killstreak_info.weapon = maps\mp\killstreaks\_killstreaks::getKillstreakWeapon( killstreak_info.streakName );
					
					bot_killstreak_func = level.killstreak_botfunc[ killstreak_info.streakName ];
					
					if ( IsDefined( bot_killstreak_func ) )
				    {
						// Call the function (do NOT thread it)
						// This way its easy to manage one killstreak working at a time
						// and all these functions will end when any of the above endon conditions are met
						self [[bot_killstreak_func]]( killstreak_info );
				    }
					else
					{
						// Bots dont know how to use this killstreak, just get rid of it so we can use something else on the stack
						self maps\mp\killstreaks\_killstreaks::updateKillstreaks( false );
					}
				}
			}
		}
		
		wait( RandomFloatRange( 1.0, 1.5 ) );
	}
}


//========================================================
//				bot_killstreak_simple_use 
//========================================================
bot_killstreak_simple_use( killstreak_info )
{
/*
	wait( RandomIntRange( 3, 5 ) );
	
	if ( !self bot_allowed_to_use_killstreaks() )
	{
		// This may have become false during the wait, like an enemy appeared while we were waiting
		return;
	}
	
	bot_switch_to_killstreak_weapon( killstreak_info );
*/
}


//========================================================
//				bot_killstreak_airdrop 
//========================================================
bot_killstreak_airdrop( killstreak_info )
{
/*
	wait( RandomIntRange( 3, 5 ) );
	
	if ( !self bot_allowed_to_use_killstreaks() )
	{
		// This may have become false during the wait, like an enemy appeared while we were waiting
		return;
	}
	
	ammo = self GetWeaponAmmoClip( killstreak_info.weapon ) + self GetWeaponAmmoStock( killstreak_info.weapon );
	if ( ammo == 0 )
	{
		// Trying to use an airdrop but we don't have any ammo
		self maps\mp\killstreaks\_killstreaks::updateKillstreaks( false );
		return;
	}

	outside_nodes = [];
	nodes_in_cone = self bot_get_nodes_in_cone( 750, 0.6, true );
	foreach ( node in nodes_in_cone )
	{
		if ( NodeExposedToSky( node ) )
			outside_nodes = array_add( outside_nodes, node );
	}
	
	if ( (nodes_in_cone.size > 5) && (outside_nodes.size > nodes_in_cone.size * 0.6) )
	{
		self BotSetFlag( "disable_movement", true );
		outside_nodes_sorted = get_array_of_closest( self.origin, outside_nodes, undefined, undefined, undefined, 150 );
		if ( outside_nodes_sorted.size > 0 )
			node_target = random(outside_nodes_sorted);
		else
			node_target = random(outside_nodes);
		self BotLookAtPoint( node_target.origin, 1.5+0.95, "script_forced" );
		
		bot_switch_to_killstreak_weapon( killstreak_info );
		wait(1.5);
		self BotPressAttackButton();
		wait(0.95);
		self SwitchToWeapon( "none" );	// clears scripted weapon for bots
		self BotSetFlag( "disable_movement", false );
	}
*/
}

// Airspace is too crouded when any of these conditions are met
//	if ( isDefined( level.ac130player ) || level.ac130InUse )
//	if ( level.littleBirds >= 3 && dropType != "airdrop_mega" )
//	if ( airStrikeType == "harrier" && level.planes > 1 )
//  if ( isDefined( level.chopper ) )
//	if ( level.lbStrike >= 1 )

bot_switch_to_killstreak_weapon( killstreak_info )
{
	self bot_notify_streak_used( killstreak_info );
	wait(0.05);	// Wait for the notify to be received and self.killstreakIndexWeapon to be set
	self SwitchToWeapon( killstreak_info.weapon );
}

bot_notify_streak_used( killstreak_info )
{
	if ( IsDefined( killstreak_info.isgimme ) && killstreak_info.isgimme )
	{
		self notify("streakUsed1");
	}
	else
	{
		for ( index = 0; index < 3; index++ )
		{
			if ( IsDefined(self.pers["killstreaks"][index].streakName) )
			{
				if ( self.pers["killstreaks"][index].streakName == killstreak_info.streakname )
					break;
			}
		}
		self notify("streakUsed" + (index+1));
	}
}

//========================================================
//			bot_killstreak_choose_loc_enemies 
//========================================================
bot_killstreak_choose_loc_enemies( killstreak_info )
{
	/*
	wait( RandomIntRange( 3, 5 ) );
	
	if ( !self bot_allowed_to_use_killstreaks() )
	{
		// This may have become false during the wait, like an enemy appeared while we were waiting
		return;
	}
	
	self BotSetFlag( "disable_movement", true );
	bot_switch_to_killstreak_weapon( killstreak_info );
	wait 2;

	zone_count = GetZoneCount();
	zone_nearest_bot = GetZoneNearest( self.origin );
	best_zone = -1;
	best_zone_count = 0;
	possible_fallback_zones = [];
	iterate_backwards = RandomFloat(100) > 50;	// randomly choose to iterate backwards
	for ( z = 0; z < zone_count; z++ )
	{
		if ( iterate_backwards )
			zone = zone_count - 1 - z;
		else
			zone = z;
		
		if ( (zone != zone_nearest_bot) && (BotZoneGetIndoorPercent( zone ) < 0.25) )
		{
			// This zone is not the current bot's zone, and it is mostly an outside zone
			enemies_in_zone = BotZoneGetCount( zone, self.team, "enemy_predict" );
			if ( enemies_in_zone > best_zone_count )
			{
				best_zone = zone;
				best_zone_count = enemies_in_zone;
			}
			
			possible_fallback_zones = array_add( possible_fallback_zones, zone );
		}
	}
	
	if ( best_zone >= 0 )
		zoneCenter = GetZoneOrigin( best_zone );
	else if ( possible_fallback_zones.size > 0 )
		zoneCenter = GetZoneOrigin( random(possible_fallback_zones) );
	else
		zoneCenter = RandomInt( GetZoneCount() );

	randomOffset = (RandomFloatRange(-500, 500), RandomFloatRange(-500, 500), 0);

	self notify( "confirm_location", zoneCenter + randomOffset, RandomIntRange(0, 360) );
	
	wait( 1.0 );
	self BotSetFlag( "disable_movement", false );
	*/
}

//========================================================
//			bot_think_watch_aerial_killstreak 
//========================================================
bot_think_watch_aerial_killstreak()
{
	self notify( "bot_think_watch_aerial_killstreak" );
	self endon(  "bot_think_watch_aerial_killstreak" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );
	
	global_badplace_time_between_placing = 8;
	global_badplace_duration = 10;
	
	if ( !IsDefined(level.last_global_badplace_time) )
	{
		level.last_global_badplace_time = GetTime();
	}
	
	currently_hiding = false;
	while(1)
	{
		needs_to_hide = false;
		
		// Note: Stealth Bomber not checked for because...its stealth
		
		// Enemy called in Attack Helicopter / Chopper Gunner / Pave Low
		if ( IsDefined(level.chopper) && level.chopper.team != self.team )
		{
			needs_to_hide = true;
		}
				
		// Ally is using precision airstrike / harrier
		// Note: You'd think to check level.airstrikeInProgress, but actually when that variable
		//       is set to "undefined" the airstrike still has some time before it finishes
		if ( IsDefined(level.artilleryDangerCenters) )
		{
			foreach ( artilleryDangerCenter in level.artilleryDangerCenters )
			{
				if ( artilleryDangerCenter.team == self.team )
				{
					if ( isStrStart( artilleryDangerCenter.streakname, "precision" ) || isStrStart( artilleryDangerCenter.streakname, "harrier" ) )
					{
						needs_to_hide = true;
					}
				}
			}
		}
		
		// Enemy called in harrier jet
		if ( isDefined(level.harriers) )
		{
			foreach ( harrier in level.harriers )
			{
				if ( IsDefined(harrier) && harrier.team != self.team )
				{
					needs_to_hide = true;
				}
			}
		}
		
		// Enemy is using AC130
		if ( IsDefined(level.ac130InUse) && level.ac130InUse )
		{
			if ( IsDefined(level.ac130player) && level.ac130player.team != self.team )
			{
				needs_to_hide = true;
				if ( GetTime() > level.last_global_badplace_time + global_badplace_time_between_placing * 1000 )
				{
					BadPlace_Global( "", global_badplace_duration, self.team, "only_sky" );
					level.last_global_badplace_time = GetTime();
				}
			}
		}
		
		// Enemy is using Reaper
		if ( IsDefined(level.remote_mortar) && level.remote_mortar.team != self.team )
		{
			needs_to_hide = true;
			if ( GetTime() > level.last_global_badplace_time + global_badplace_time_between_placing * 1000 )
			{
				BadPlace_Global( "", global_badplace_duration, self.team, "only_sky" );
				level.last_global_badplace_time = GetTime();
			}
		}
		
		// Enemy is using predator drone
		if ( IsDefined(level.remoteMissileInProgress) )
		{
			foreach ( rocket in level.rockets )
			{
				if ( rocket.type == "remote" && rocket.team != self.team )
				{
					needs_to_hide = true;
					if ( GetTime() > level.last_global_badplace_time + global_badplace_time_between_placing * 1000 )
					{
						BadPlace_Global( "", global_badplace_duration, self.team, "only_sky" );
						level.last_global_badplace_time = GetTime();
					}
				}
			}
		}
		
		if ( !currently_hiding && needs_to_hide )
		{
			currently_hiding = true;
			self BotSetFlag( "hide_indoors", 1 );
		}
		if ( currently_hiding && !needs_to_hide )
		{
			currently_hiding = false;
			self BotSetFlag( "hide_indoors", 0 );
		}
		
		wait(RandomFloatRange(0.05,4.0));
	}
}