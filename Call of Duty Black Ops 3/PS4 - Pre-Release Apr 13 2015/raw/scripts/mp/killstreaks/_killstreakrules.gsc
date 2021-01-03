#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
   	                                                         	                                                                                                                                               	                                                      	                                                                              	                                                          	                                    	                                     	                                                     	                                                                                      	                                                             	                                                                                                    	                                             	                                     	                                                     
   	  
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           

#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_loadout;

#using scripts\mp\_util;
#using scripts\mp\killstreaks\_ai_tank;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_combat_robot;
#using scripts\mp\killstreaks\_counteruav;
#using scripts\mp\killstreaks\_dart;
#using scripts\mp\killstreaks\_dogs;
#using scripts\mp\killstreaks\_drone_strike;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_flak_drone;
#using scripts\mp\killstreaks\_helicopter;
#using scripts\mp\killstreaks\_helicopter_guard;
#using scripts\mp\killstreaks\_helicopter_gunner;
#using scripts\mp\killstreaks\_killstreak_weapons;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_microwave_turret;
#using scripts\mp\killstreaks\_missile_drone;
#using scripts\mp\killstreaks\_missile_swarm;
#using scripts\mp\killstreaks\_planemortar;
#using scripts\mp\killstreaks\_qrdrone;
#using scripts\mp\killstreaks\_raps;
#using scripts\mp\killstreaks\_rcbomb;
#using scripts\mp\killstreaks\_remote_weapons;
#using scripts\mp\killstreaks\_remotemissile;
#using scripts\mp\killstreaks\_remotemortar;
#using scripts\mp\killstreaks\_satellite;
#using scripts\mp\killstreaks\_sentinel;
#using scripts\mp\killstreaks\_straferun;
#using scripts\mp\killstreaks\_supplydrop;
#using scripts\mp\killstreaks\_turret;
#using scripts\mp\killstreaks\_uav;

#using scripts\mp\_teamops;







	

	
#precache( "string", "MP_KILLSTREAK_N" );	

#namespace killstreaks;

function autoexec __init__sytem__() {     system::register("killstreaks",&__init__,undefined,undefined);    }
	
function __init__()
{
	level.killstreaks = [];
	level.killstreakWeapons = [];
	
	callback::on_start_gametype( &init );
	killstreaks::init_damage_per_weapon_table( "gamedata/tables/mp/killstreakDamagePerWeapon.csv" );
}	
	
function init()
{
	if ( GetDvarString( "scr_allow_killstreak_building") == "" )
	{
		SetDvar( "scr_allow_killstreak_building", "0" );
	}	
	
	level.menuReferenceForKillStreak = [];
	level.numKillstreakReservedObjectives = 0;
	level.killstreakCounter = 0;

	if( !isdefined(level.roundStartKillstreakDelay) )
	{
		level.roundStartKillstreakDelay = 0;
	}
	
	level.killstreak_timers = [];
	
	foreach( team in level.teams )
	{
		level.killstreak_timers[team] = [];
	}

	level.isKillstreakWeapon =&killstreaks::is_killstreak_weapon;

	remote_weapons::init();
	
	ai_tank::init();
	airsupport::init();
	combat_robot::init();
	counteruav::init();
	dart::init();
	dogs::initKillstreak();
	drone_strike::init();
	emp::init();
	flak_drone::init();
	helicopter::init();
	helicopter_guard::init();
	helicopter_gunner::init();
	killstreak_weapons::init();
	killstreakrules::init();
	microwave_turret::init();
	missile_drone::init();
	missile_swarm::init();
	planemortar::init();
	qrdrone::init();
	raps_mp::init();
	rcbomb::init();
	remotemissile::init();
	remotemortar::init();
	satellite::init();
	sentinel::init();
	straferun::init();
	turret::init();
	uav::init();
	
	supplydrop::init();

	callback::on_spawned( &on_player_spawned );
	callback::on_joined_team( &on_joined_team );

/#
	level thread killstreak_debug_think();
#/
	if( GetDvarint( "teamOpsEnabled" ) == 1 )
	{
		level teamops::main();
	}
}

function register( killstreakType, 			// killstreak name	
				   killstreakWeaponName, 	// weapon name associated with deploying this killstreak
				   killstreakMenuName,		// killstreak name from the cac loadout (could be merged with the type name)
				   killstreakUsageKey,		// variable that shows the usage for the killstreak ( could be merged with type name )
				   killstreakUseFunction,	// function that gets called when the killstreak gets activated	
				   killstreakDelayStreak,	// weather or not to delay the killstreak at round start
				   weaponHoldAllowed = false,		// if this killstreak weapon can be held by the player, as opposed to activate and remove (i.e. UAV)
				   killstreakStatsName = undefined,		// Stats name for killstreak weapons (optional)
				   registerDvars = true
				   )
{
	assert( isdefined(killstreakType), "Can not register a killstreak without a valid type name.");
	assert( !isdefined(level.killstreaks[killstreakType]), "Killstreak " + killstreakType + " already registered");
	assert( isdefined(killstreakUseFunction), "No use function defined for killstreak " + killstreakType);
		
	level.killstreaks[killstreakType] = SpawnStruct();
	
	statsTableName = util::getStatsTableName();

	// number of kills required to achieve killstreak
	level.killstreaks[killstreakType].killstreakLevel = int( tablelookup( statsTableName, 4, killstreakMenuName, 5 ) );
	level.killstreaks[killstreakType].momentumCost = int( tablelookup( statsTableName, 4, killstreakMenuName, 16 ) );
	level.killstreaks[killstreakType].iconMaterial = tablelookup( statsTableName, 4, killstreakMenuName, 6 );
	level.killstreaks[killstreakType].quantity = int( tablelookup( statsTableName, 4, killstreakMenuName, 5 ) );
	level.killstreaks[killstreakType].usageKey = killstreakUsageKey;
	level.killstreaks[killstreakType].useFunction = killstreakUseFunction;
	level.killstreaks[killstreakType].menuName = killstreakMenuName; 
	level.killstreaks[killstreakType].delayStreak = killstreakDelayStreak; 
	level.killstreaks[killstreakType].allowAssists = false;
	level.killstreaks[killstreakType].overrideEntityCameraInDemo = false;
	level.killstreaks[killstreakType].teamKillPenaltyScale = 1.0;
/#
	level.killstreaks[killstreakType].uiName = ( tablelookup( statsTableName, 4, killstreakMenuName, 3 ) );
	if ( level.killstreaks[killstreakType].uiName == "" )
	{
		level.killstreaks[killstreakType].uiName = killstreakMenuName;
	}
#/
	if ( isdefined( killstreakWeaponName ) )
	{
		killstreakWeapon = GetWeapon( killstreakWeaponName );

		assert( !isdefined(level.killstreakWeapons[killstreakWeapon]), "Can not have a weapon associated with multiple killstreaks.");
		level.killstreaks[killstreakType].weapon = killstreakWeapon;
		level.killstreakWeapons[killstreakWeapon] = killstreakType;
	}

	if( isdefined( killstreakStatsName ) )
	{
		level.killstreaks[killstreakType].killstreakStatsName = killstreakStatsName;
	}

	level.killstreaks[killstreakType].weaponHoldAllowed = weaponHoldAllowed;

	level.menuReferenceForKillStreak[killstreakMenuName] = killstreakType;
	
	if ( registerDvars )
	{
		register_dev_dvars( killstreakType );
	}
}

function is_registered(killstreakType)
{
	return isdefined(level.killstreaks[killstreakType]);
}

function register_strings( killstreakType, receivedText, notUsableText, inboundText, inboundNearPlayerText ) 
{
	assert( isdefined(killstreakType), "Can not register a killstreak without a valid type name.");
	assert( isdefined(level.killstreaks[killstreakType]), "Killstreak needs to be registered before calling register_strings.");
	
	level.killstreaks[killstreakType].receivedText = 	receivedText;
	level.killstreaks[killstreakType].notAvailableText = notUsableText;
	level.killstreaks[killstreakType].inboundText = inboundText;
	level.killstreaks[killstreakType].inboundNearPlayerText = inboundNearPlayerText;
}

function register_dialog( 
							killstreakType,
							informDialog,
							taacomDialogIndex,
							pilotDialogIndex,
							startSoundIndex, 		// Commander
							enemyStartSoundIndex,	// Commander 	
							requestSoundIndex		// Player
						)
{
	assert( isdefined(killstreakType), "Can not register a killstreak without a valid type name.");
	assert( isdefined(level.killstreaks[killstreakType]), "Killstreak needs to be registered before calling register_dialog.");

	level.killstreaks[killstreakType].informDialog = informDialog;
	
	level.killstreaks[killstreakType].taacomDialogIndex = taacomDialogIndex;
	level.killstreaks[killstreakType].pilotDialogIndex = pilotDialogIndex;
	
	level.killstreaks[killstreakType].startSoundIndex = startSoundIndex;
	level.killstreaks[killstreakType].enemyStartSoundIndex = enemyStartSoundIndex;
	
	level.killstreaks[killstreakType].requestSoundIndex = requestSoundIndex;
}

// additional weapons associated with this killstreak
function register_alt_weapon( killstreakType, weaponName )
{
	assert( isdefined(killstreakType), "Can not register a killstreak without a valid type name.");
	assert( isdefined(level.killstreaks[killstreakType]), "Killstreak needs to be registered before calling register_alt_weapon.");

	weapon = GetWeapon( weaponName );
	if ( level.killstreaks[killstreakType].weapon == weapon )
	{
		return;
	}

	if ( !isdefined( level.killstreaks[killstreakType].altWeapons ) )
	{
		level.killstreaks[killstreakType].altWeapons = [];
	}

	if( !isdefined( level.killstreakWeapons[weapon] ) )
	{
		level.killstreakWeapons[weapon] = killstreakType;
	}
	level.killstreaks[killstreakType].altWeapons[level.killstreaks[killstreakType].altWeapons.size] = weapon;
}

// remote override weapons associated with this killstreak
function register_remote_override_weapon( killstreakType, weaponName )
{
	assert( isdefined(killstreakType), "Can not register a killstreak without a valid type name.");
	assert( isdefined(level.killstreaks[killstreakType]), "Killstreak needs to be registered before calling register_remote_override_weapon.");

	weapon = GetWeapon( weaponName );
	if ( level.killstreaks[killstreakType].weapon == weapon )
	{
		return;
	}
		
	if ( !isdefined( level.killstreaks[killstreakType].remoteOverrideWeapons ) )
	{
		level.killstreaks[killstreakType].remoteOverrideWeapons = [];
	}

	if( !isdefined( level.killstreakWeapons[weapon] ) )
	{
		level.killstreakWeapons[weapon] = killstreakType;
	}
	level.killstreaks[killstreakType].remoteOverrideWeapons[level.killstreaks[killstreakType].remoteOverrideWeapons.size] = weapon;
}

function is_remote_override_weapon( killstreakType, weapon )
{
	if ( isdefined( level.killstreaks[killstreakType].remoteOverrideWeapons ) )
	{
		for ( i=0; i<level.killstreaks[killstreakType].remoteOverrideWeapons.size; i++)
		{
			if ( level.killstreaks[killstreakType].remoteOverrideWeapons[i] == weapon)
			{
				return true;	
			}
		}
	}
	return false;
}

function register_dev_dvars( killstreakType )
{
/#
	assert( isdefined(killstreakType), "Can not register a killstreak without a valid type name.");
	assert( isdefined(level.killstreaks[killstreakType]), "Killstreak needs to be registered before calling register_dev_dvar.");

	level.killstreaks[killstreakType].devDvar = "scr_" + killstreakType + "_give";
	level.killstreaks[killstreakType].devEnemyDvar = "scr_" + killstreakType + "_giveenemy";
	level.killstreaks[killstreakType].devTimeoutDvar = "scr_" + killstreakType + "_notimeout";

	// must create this one because the toggle command will not create it
	SetDvar( level.killstreaks[killstreakType].devTimeoutDvar, 0 );
	
	register_devgui( killstreakType );
#/
}

function register_dev_debug_dvar( killstreakType )
{
/#
	assert( isdefined(killstreakType), "Can not register a killstreak without a valid type name.");
	assert( isdefined(level.killstreaks[killstreakType]), "Killstreak needs to be registered before calling register_dev_dvar.");

	level.killstreaks[killstreakType].devDebugDvar = "scr_" + killstreakType + "_debug";

	devgui_scorestreak_command_debugdvar( killstreakType, level.killstreaks[killstreakType].devDebugDvar );
#/
}

/#

function register_devgui( killstreakType )
{
	give_type_all = "Give";
	give_type_enemy = "Give Enemy";

	if ( isdefined(level.killstreaks[killstreakType].devDvar) )
	{
		devgui_scorestreak_command_givedvar( killstreakType, give_type_all, level.killstreaks[killstreakType].devDvar );
	}
	if ( isdefined(level.killstreaks[killstreakType].devEnemyDvar) )
	{
		devgui_scorestreak_command_givedvar( killstreakType, give_type_enemy, level.killstreaks[killstreakType].devEnemyDvar );
	}
	if ( isdefined(level.killstreaks[killstreakType].devTimeoutDvar) )
	{
		devgui_scorestreak_command_timeoutdvar( killstreakType, level.killstreaks[killstreakType].devTimeoutDvar );
	}
}

function devgui_scorestreak_command_givedvar( killstreakType, give_type, dvar )
{
	devgui_scorestreak_command( killstreakType, give_type, "set "+dvar+" 1" );
}

function devgui_scorestreak_command_timeoutdvar( killstreakType, dvar )
{
	devgui_scorestreak_dvar_toggle( killstreakType, "Time Out", dvar );
}

function devgui_scorestreak_command_debugdvar( killstreakType, dvar )
{
	devgui_scorestreak_dvar_toggle( killstreakType, "Debug", dvar );
}
#/

function devgui_scorestreak_dvar_toggle( killstreakType, title, dvar )
{
	// must create this one because the toggle command will not create it
	SetDvar( dvar, 0 );
	
	devgui_scorestreak_command( killstreakType, "Toggle " + title, "toggle "+dvar+" 1 0" );
}

function devgui_scorestreak_command( killstreakType, title, command )
{
/#
	assert( isdefined(killstreakType), "Can not register a killstreak without a valid type name.");
	assert( isdefined(level.killstreaks[killstreakType]), "Killstreak needs to be registered before calling register_dev_dvar.");
	
	root = "devgui_cmd \"MP/Scorestreaks/";
	user_name = MakeLocalizedString(level.killstreaks[killstreakType].uiName);
	AddDebugCommand( root + user_name + " (" + killstreakType + ")/"+ title + "\" \"" + command + "\" \n");
#/
}

function should_draw_debug( killstreak )
{
/#
	assert( isdefined(killstreak), "Can not register a killstreak without a valid type name.");

	if ( isdefined( level.killstreaks[killstreak] ) && isdefined( level.killstreaks[killstreak].devDebugDvar ) )
			return GetDvarInt( level.killstreaks[killstreak].devDebugDvar );
#/

	return false;	
}


function register_tos_dvar(dvar)
{
	level.teamops_dvar = dvar;
}

function allow_assists( killstreakType, allow )
{
	level.killstreaks[killstreakType].allowAssists = allow;	
}

function set_team_kill_penalty_scale( killstreakType, scale )
{
	level.killstreaks[killstreakType].teamKillPenaltyScale = scale;	
}

function override_entity_camera_in_demo( killstreakType, value )
{
	level.killstreaks[killstreakType].overrideEntityCameraInDemo = value;
}

function is_available( killstreak )
{
	if ( isdefined( level.menuReferenceForKillStreak[killstreak] ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

function get_by_menu_name( killstreak )
{
	return level.menuReferenceForKillStreak[killstreak];
}

function get_menu_name( killstreakType )
{
	Assert( isdefined(level.killstreaks[killstreakType] ) );
	return level.killstreaks[killstreakType].menuName;
}

function get_level( index, killstreak )
{
	killstreakLevel = level.killstreaks[ get_by_menu_name( killstreak ) ].killstreakLevel;
	if( GetDvarInt( "custom_killstreak_mode" ) == 2 )
	{
		if ( isdefined( self.killstreak[ index ] ) && ( killstreak == self.killstreak[ index ] ) )
		{
			killsRequired = GetDvarInt( "custom_killstreak_" + index + 1 + "_kills" );
			if ( killsRequired )
			{
				killstreakLevel = GetDvarInt( "custom_killstreak_" + index + 1 + "_kills" );
			}
		}
	}
	return killstreakLevel;
}

function give_if_streak_count_matches( index, killstreak, streakCount )
{
	pixbeginevent( "giveKillstreakIfStreakCountMatches" );
	
	/#
	if(!isdefined( killstreak ) )
	{
		println( "Killstreak Undefined.\n" );
	}
	if( isdefined( killstreak ) )
	{
		println( "Killstreak listed as."+killstreak+"\n" );
	}
	if( !is_available(killstreak) )
	{
		println( "Killstreak Not Available.\n" );
	}
	#/

	if( self.pers["killstreaksEarnedThisKillstreak"] > index && util::isRoundBased() )
	{
		hasAlreadyEarnedKillstreak = true;
	}
	else
	{
		hasAlreadyEarnedKillstreak = false;
	}

	if ( isdefined( killstreak ) && is_available(killstreak) && !hasAlreadyEarnedKillstreak )
	{
		killstreakLevel = get_level( index, killstreak );

		if ( self HasPerk( "specialty_killstreak" ) )
		{
			reduction = GetDvarint( "perk_killstreakReduction" );
			killstreakLevel -= reduction;

			// a fix for custom game types being able to adjust the killstreak reduction perk
			if( killstreakLevel <= 0 )
			{
				killstreakLevel = 1;
			}
		}
		
		if ( killstreakLevel == streakCount )
		{
			self give( get_by_menu_name( killstreak ), streakCount );
			self.pers["killstreaksEarnedThisKillstreak"] = index + 1;
			pixendevent();
			return true;
		}
	}

	pixendevent();
	return false;
}

//Self is the player. This function looks at the player current killstreak and decides if he should be award a killstreak reward.
//It also manages the prompt that appears when the player  gets killstreaks at intervals of 5 kills once they reach 10 kills. -Leif
function give_for_streak()
{
	if ( !util::isKillStreaksEnabled() )
	{
		return;
	}

	//Equals total kills within one life
	if( !isdefined(self.pers["totalKillstreakCount"]) )
	{
		self.pers["totalKillstreakCount"] = 0;
	}
	
	// send the running tally to see what kill streak we should get
	given = false;
	
	for ( i = 0; i < self.killstreak.size; i++ )
	{
		given |= give_if_streak_count_matches( i, self.killstreak[i], self.pers["cur_kill_streak"] );
	}
}

function is_an_a_killstreak()
{
	onKillstreak = false;
	if( !isdefined( self.pers["kill_streak_before_death"] ) )
	{
		self.pers["kill_streak_before_death"] = 0;
	}
	
	streakPlusOne = self.pers["kill_streak_before_death"] + 1;
	
	if ( self.pers["kill_streak_before_death"] >= 5 ) 
	{
		onKillstreak = true;
	}


	return onKillstreak;
}

function give( killstreakType, streak, suppressNotification, noXP, toBottom )
{
	pixbeginevent( "giveKillstreak" );
	self endon("disconnect");
	level endon( "game_ended" );
	
	had_to_delay = false;
	
	killstreakGiven = false;
	if( isdefined( noXP ) )
	{
		if ( self give_internal( killstreakType, undefined, noXP, toBottom ) )
		{
			killstreakGiven = true;
			self add_to_queue( level.killstreaks[killstreakType].menuname, streak, killstreakType, noXP );
		}
	}
	else if ( self give_internal( killstreakType, noXP ) )
	{
		killstreakGiven = true;
		self add_to_queue( level.killstreaks[killstreakType].menuname, streak, killstreakType, noXP );
	}
	pixendevent(); //  "giveKillstreak"
}

function take( killstreak )
{
	self endon( "disconnect" );
	
	killstreak_weapon = get_killstreak_weapon( killstreak );
	remove_used_killstreak( killstreak );
	
	if ( self GetInventoryWeapon() == killstreak_weapon )
	{
		self SetInventoryWeapon( level.weaponNone );
	}

	waittillframeend;
	
	currentWeapon = self GetCurrentWeapon();
	if( currentWeapon != killstreak_weapon || killstreak_weapon.isCarriedKillstreak )
	{ 
		return;
	}
	
	killstreaks::switch_to_last_non_killstreak_weapon();
	activate_next();
}

function remove_oldest()
{
	if( isdefined( self.pers["killstreaks"][0] ) )
	{
		currentWeapon = self getCurrentWeapon();

		if( currentWeapon == get_killstreak_weapon( self.pers["killstreaks"][0] ) )
		{
			primaries = self GetWeaponsListPrimaries();

			if( primaries.size > 0 )
			{
				self SwitchToWeapon( primaries[0] );
			}
		}

		self notify("oldest_killstreak_removed", self.pers["killstreaks"][0], self.pers["killstreak_unique_id"][0] ); 
		self remove_used_killstreak( self.pers["killstreaks"][0], self.pers["killstreak_unique_id"][0] );
	}
}

function give_internal( killstreakType, do_not_update_death_count, noXP, toBottom )
{
	if ( level.gameEnded )
	{
		return false;
	}
		
	if ( !util::isKillStreaksEnabled() )
	{
		return false;
	}
		
	if ( !isdefined( level.killstreaks[killstreakType] ) )
	{
		return false;
	}

	if ( !isdefined( self.pers["killstreaks"] ) )
	{
		self.pers["killstreaks"] = [];
	}
	if( !isdefined( self.pers["killstreak_has_been_used"] ) )
	{
		self.pers["killstreak_has_been_used"] = [];
	}
	if( !isdefined( self.pers["killstreak_unique_id"] ) )
	{
		self.pers["killstreak_unique_id"] = [];
	}
	
	if( isdefined( toBottom ) && toBottom )
	{
		size = self.pers["killstreaks"].size;
		
		if( self.pers["killstreaks"].size >= level.maxInventoryScoreStreaks )
		{
			self remove_oldest();
		}		
		
		for( i = size; i > 0; i-- )
		{
			self.pers["killstreaks"][i] = self.pers["killstreaks"][i - 1];
			self.pers["killstreak_has_been_used"][i] = self.pers["killstreak_has_been_used"][i - 1];
			self.pers["killstreak_unique_id"][i] = self.pers["killstreak_unique_id"][i - 1];
			self.pers["killstreak_ammo_count"][i] = self.pers["killstreak_ammo_count"][i - 1];
		}
		self.pers["killstreaks"][0] = killstreakType;
		self.pers["killstreak_unique_id"][0] = level.killstreakCounter;
		level.killstreakCounter++;
		
		if( isdefined(noXP) )
		{
			self.pers["killstreak_has_been_used"][0] = noXP;
		}
		else
		{
			self.pers["killstreak_has_been_used"][0] = false;
		}
		
		
		if( size == 0 )
		{
			weapon = get_killstreak_weapon( killstreakType );
			ammoCount = give_weapon( weapon, true );
		}
	
		self.pers["killstreak_ammo_count"][0] = 0;
	}
	else
	{
		self.pers["killstreaks"][self.pers["killstreaks"].size] = killstreakType;
		self.pers["killstreak_unique_id"][self.pers["killstreak_unique_id"].size] = level.killstreakCounter;
		level.killstreakCounter++;
	
		if( self.pers["killstreaks"].size > level.maxInventoryScoreStreaks )
		{
			self remove_oldest();
		}
		
		if( isdefined(noXP) )
		{
			self.pers["killstreak_has_been_used"][self.pers["killstreak_has_been_used"].size] = noXP;
		}
		else
		{
			self.pers["killstreak_has_been_used"][self.pers["killstreak_has_been_used"].size] = false;
		}
		
		weapon = get_killstreak_weapon( killstreakType );
		
		ammoCount = give_weapon( weapon, true );
	
		self.pers["killstreak_ammo_count"][self.pers["killstreak_ammo_count"].size] = ammoCount;
	}

	return true;
}

function add_to_queue( menuName, streakCount, hardpointType, noNotify )
{
	killstreakTableNumber = level.killStreakIndices[ menuName ];

	if ( !isdefined( killstreakTableNumber ) )
	{
		return;
	}
	
	if( isdefined( noNotify ) && noNotify )
	{
		return;
	}

	informDialog = get_killstreak_inform_dialog( hardpointType );
	
	if( GetDvarInt( "teamOpsEnabled" ) == 0 )
	{	
		self play_killstreak_ready_dialog( hardpointType, 2.4 );
		self LUINotifyEvent( &"killstreak_received", 2, killstreakTableNumber, istring( informDialog ) );
		self LUINotifyEventToSpectators( &"killstreak_received", 2, killstreakTableNumber, istring( informDialog ) );
	}
	
	self play_killstreak_ready_sfx ( hardpointType );
	
}


function has_equipped( )
{
	currentWeapon = self getCurrentWeapon();

	keys = getarraykeys( level.killstreaks );
	for ( i = 0; i < keys.size; i++ )
	{
		if ( level.killstreaks[keys[i]].weapon == currentWeapon )
		{
			return true;
		}
	}

	return false;
}

function _get_from_weapon( weapon ) 
{
	keys = getarraykeys( level.killstreaks );
	for ( i = 0; i < keys.size; i++ )
	{
		if ( level.killstreaks[keys[i]].weapon == weapon )
		{
			return keys[i];
		}
		if ( isdefined ( level.killstreaks[keys[i]].altweapons ) )
		{
			foreach( altweapon in level.killstreaks[keys[i]].altweapons )
			{
				if ( altweapon == weapon ) 
				{
					return keys[i];
				}
			}
			
			if( isdefined( level.killstreaks[keys[i]].remoteoverrideweapons ) )
			{
				foreach( remoteOverrideWeapon in level.killstreaks[keys[i]].remoteoverrideweapons )
				{
					if( remoteOverrideWeapon == weapon )
					{
						return keys[i];
					}
				}	
			}
		}
	}
	return undefined;
}


function get_from_weapon( weapon ) 
{
	if( weapon == level.weaponNone )
	{
		return undefined;
	}
	
	res = _get_from_weapon( weapon );
	if( !isdefined( res ) )
		return _get_from_weapon( weapon.rootweapon );
	else
		return res;
}

// dont need the isinventory it will be inventory they all are
function give_weapon( weapon, isinventory, useStoredAmmo )
{	
	currentWeapon = self GetCurrentWeapon();
	
	if ( currentWeapon != level.weaponNone && !( isdefined( level.usingMomentum ) && level.usingMomentum ) )
	{
		weaponsList = self GetWeaponsList();
		for( idx = 0; idx < weaponsList.size; idx++ )
		{
		 	carriedWeapon = weaponsList[idx];
		 	
		 	if ( currentWeapon == carriedWeapon )
		 	{
		 		continue;
		 	}

			// special case weapons that are killstreak weapons but shouldn't be taken from the player
			switch ( carriedWeapon.name )
			{
			case "minigun":
			case "m32":
				continue;
			}
		 		
			if ( killstreaks::is_killstreak_weapon( carriedWeapon ) )
		 	{
		 		self TakeWeapon( carriedWeapon );
		 	}
		}
	}
	
	// take the weapon in-case we already have it.  
	// otherwise giveweapon will not give the weapon or ammo
	if( currentWeapon != weapon && ( self hasWeapon(weapon) == false ) )
	{
		self TakeWeapon( weapon );
		self GiveWeapon( weapon );
	}
	
	if ( ( isdefined( level.usingMomentum ) && level.usingMomentum ) )
	{
		self SetInventoryWeapon( weapon );

		if( weapon.isCarriedKillstreak )
		{
			if( !isdefined( self.pers["held_killstreak_ammo_count"][weapon] ) )
			{
				self.pers["held_killstreak_ammo_count"][weapon] = 0;
			}

			if( !isdefined( self.pers["held_killstreak_clip_count"][weapon] ) )
			{
				self.pers["held_killstreak_clip_count"][weapon] = weapon.clipSize;
			}

			if( !isdefined( self.pers["killstreak_quantity"][weapon] ) )
			{
				self.pers["killstreak_quantity"][weapon] = 0;
			}

			if( currentWeapon == weapon && !killstreaks::isHeldInventoryKillstreakWeapon( weapon ) )
			{
				return weapon.maxAmmo;
			}
			else if( ( isdefined( useStoredAmmo ) && useStoredAmmo ) && self.pers["killstreak_ammo_count"][self.pers["killstreak_ammo_count"].size - 1] > 0 )
			{
				switch( weapon.name )
				{
				case "inventory_minigun":
					if( ( isdefined( self.minigunActive ) && self.minigunActive ) )
					{
						return self.pers["held_killstreak_ammo_count"][weapon];
					}
					break;
				case "inventory_m32":
					if( ( isdefined( self.m32Active ) && self.m32Active ) )
					{
						return self.pers["held_killstreak_ammo_count"][weapon];
					}
					break;
				default:
					break;
				}
				self.pers["held_killstreak_ammo_count"][weapon] = self.pers["killstreak_ammo_count"][self.pers["killstreak_ammo_count"].size - 1];
				self loadout::setWeaponAmmoOverall( weapon, self.pers["killstreak_ammo_count"][self.pers["killstreak_ammo_count"].size - 1] );
			}
			else
			{
				self.pers["held_killstreak_ammo_count"][weapon] = weapon.maxAmmo;
				self.pers["held_killstreak_clip_count"][weapon] = weapon.clipSize;
				self loadout::setWeaponAmmoOverall( weapon, self.pers["held_killstreak_ammo_count"][weapon] );
			}
			return self.pers["held_killstreak_ammo_count"][weapon];
		}
		else
		{
			switch ( weapon.name )
			{
			case "inventory_ai_tank_drop":
			case "inventory_supplydrop":
			case "inventory_minigun_drop":
			case "inventory_m32_drop":
			case "inventory_missile_drone":
			case "combat_robot_marker":
			case "combat_robot_drop":
			case "dart":
				delta = 1;
				break;
			default:
				delta = 0;
				break;
			}
		
			return change_killstreak_quantity( weapon, delta );	
		}
	}
	else
	{
		self setActionSlot( 4, "weapon", weapon );
		return 1;
	}
}

function activate_next( do_not_update_death_count )
{
	if ( level.gameEnded )
	{
		return false;
	}

	if ( ( isdefined( level.usingMomentum ) && level.usingMomentum ) )
	{
		self SetInventoryWeapon( level.weaponNone );
	}
	else
	{
		self setActionSlot( 4, "" );
	}

 	if ( !isdefined( self.pers["killstreaks"] ) || self.pers["killstreaks"].size == 0 )
 	{
 		return false;
 	}
 	
	killstreakType = self.pers["killstreaks"][self.pers["killstreaks"].size - 1];

	if ( !isdefined( level.killstreaks[killstreakType] ) )
	{
		return false;
	}
	
	weapon = level.killstreaks[killstreakType].weapon;
	{wait(.05);};
	
	ammoCount = give_weapon( weapon, false, true );

	//Set the ammo now so we don't get a flash on the HUD when we use this weapon later
	if( weapon.isCarriedKillstreak )
	{
		self setWeaponAmmoClip( weapon, self.pers["held_killstreak_clip_count"][weapon] );
		self setWeaponAmmoStock( weapon, ammoCount - self.pers["held_killstreak_clip_count"][weapon] );
	}

	if ( !isdefined( do_not_update_death_count ) || do_not_update_death_count != false )
	{
		self.pers["killstreakItemDeathCount"+killstreakType] = self.deathCount;
	}	
	
	return true;
}

function give_owned()
{
	if ( isdefined( self.pers["killstreaks"] ) && self.pers["killstreaks"].size > 0 )
	{
		self activate_next( false );
	}
}

function change_killstreak_quantity( killstreakWeapon, delta )
{
	quantity = self.pers["killstreak_quantity"][killstreakWeapon];
	if ( !isdefined( quantity ) )
	{
		quantity = 0;
	}
	
	previousQuantity = quantity;
	
	if ( delta < 0 )
	{
		assert( quantity > 0 );
	}
	quantity += delta;

	if ( quantity > level.scoreStreaksMaxStacking )
	{
		quantity = level.scoreStreaksMaxStacking;
	}
	
	// take the weapon in-case we already have it.  
	// otherwise giveweapon will not give the weapon or ammo
	if(self hasWeapon( killstreakWeapon ) == false )
	{
		self TakeWeapon( killstreakWeapon );
		self GiveWeapon( killstreakWeapon );
		self SetEverHadWeaponAll( true );
	}

	self.pers["killstreak_quantity"][killstreakWeapon] = quantity;
	self SetWeaponAmmoClip( killstreakWeapon, quantity );
	
	return quantity;
}

function has_killstreak_in_class( killstreakMenuName )
{
	foreach ( equippedKillstreak in self.killstreak )
	{
		if ( equippedKillstreak == killstreakMenuName )
		{
			return true;
		}
	}
	return false;
}

function remove_when_done( killstreak, hasKillstreakBeenUsed, isFromInventory )
{
	self endon( "disconnect" );
	
	self waittill( "killstreak_done", successful, killstreakType );
	if ( successful )
	{	
		/#print( "killstreak: " + get_menu_name( killstreak ) );#/
		
		// good place to hook into killstreak usage
		killstreak_weapon = get_killstreak_weapon( killstreak );
		recordStreakIndex = undefined;
		if( isdefined( level.killstreaks[killstreak].menuname ) )
		{
			recordStreakIndex = level.killstreakindices[level.killstreaks[killstreak].menuname];
			if ( isdefined(recordStreakIndex) )
			{
				self RecordKillStreakEvent( recordStreakIndex );
			}
		}
		
		if ( ( isdefined( level.usingScoreStreaks ) && level.usingScoreStreaks ) )
		{
			if ( ( isdefined( isFromInventory ) && isFromInventory ) )
			{
				remove_used_killstreak( killstreak );
				if ( self GetInventoryWeapon() == killstreak_weapon )
				{
					self SetInventoryWeapon( level.weaponNone );
				}
			}
			else
			{
				self change_killstreak_quantity( killstreak_weapon, -1 );
			}
		}
		else if ( ( isdefined( level.usingMomentum ) && level.usingMomentum ) )
		{
			if ( ( isdefined( isFromInventory ) && isFromInventory ) && ( self GetInventoryWeapon() == killstreak_weapon ) )
			{
				remove_used_killstreak( killstreak );
				self SetInventoryWeapon( level.weaponNone );
			}
			else
			{
				globallogic_score::_setPlayerMomentum( self, self.momentum - level.killstreaks[killstreakType].momentumCost );
			}
		}
		else
		{
			remove_used_killstreak( killstreak );
		}

		if ( !( isdefined( level.usingMomentum ) && level.usingMomentum ) )
		{
			self setActionSlot( 4, "" );
		}
	
		success = true;
	}

	waittillframeend;
	
	currentWeapon = self GetCurrentWeapon();
	killstreak_weapon = get_killstreak_weapon( killstreakType );
	if( currentWeapon == killstreak_weapon && killstreak_weapon.isCarriedKillstreak )
	{ 
		return;
	}
	
	if ( successful && ( !self has_killstreak_in_class( get_menu_name( killstreak ) ) || ( ( isdefined( isFromInventory ) && isFromInventory ) && isFromInventory ) )  )
	{
		killstreaks::switch_to_last_non_killstreak_weapon();
	}
	else
	{
		// the killstreak could have failed because we switched to another killstreak weapon
		killstreakForCurrentWeapon = get_from_weapon( currentWeapon );
		
		if ( currentWeapon.isGameplayWeapon )
		{
			if ( ( isdefined( self.isPlanting ) && self.isPlanting ) || ( isdefined( self.isDefusing ) && self.isDefusing ) )
			{
				return;
			}
		}
		
		if ( successful || !isdefined( killstreakForCurrentWeapon ) || killstreakForCurrentWeapon == killstreak )
		{
			killstreaks::switch_to_last_non_killstreak_weapon();
		}
	}

	if ( !( isdefined( level.usingMomentum ) && level.usingMomentum ) || ( isdefined( isFromInventory ) && isFromInventory ) )
	{
		if ( successful )
		{
			activate_next();
		}
	}
}

function useKillstreak( killstreak, isFromInventory )
{
	hasKillstreakBeenUsed = get_if_top_killstreak_has_been_used();
	
	if ( isdefined( self.selectingLocation ) )
	{
		return;
	}

	self thread remove_when_done( killstreak, hasKillstreakBeenUsed, isFromInventory );
	self thread trigger_killstreak( killstreak, isFromInventory );
}

function remove_used_killstreak( killstreak, killstreakId )
{
	if( !isdefined( self.pers["killstreaks"] ) )
		return;

	// the killstreak stack is a lifo stack
	// find the top most killstreak in the list 
	// remove it 
	killstreakIndex = undefined;
	
	for ( i = self.pers["killstreaks"].size - 1; i >= 0; i-- )
	{
		if ( self.pers["killstreaks"][i] == killstreak )
		{
			if( isdefined( killstreakId ) && self.pers["killstreak_unique_id"][i] != killstreakId )
			{
				continue;
			}
	  		
			killstreakIndex = i;
			break;
		}
	}

	if ( !isdefined(killstreakIndex) )
	{
		return false;
	}

	if( !self has_killstreak_in_class( get_menu_name( killstreak ) ) )
	{
		self thread take_weapon_after_use( get_killstreak_weapon( killstreak ) );
	}
	
	arraySize = self.pers["killstreaks"].size;
	for ( i = killstreakIndex; i < arraySize - 1; i++ )
	{
		self.pers["killstreaks"][i] = self.pers["killstreaks"][i + 1];
		self.pers["killstreak_has_been_used"][i] = self.pers["killstreak_has_been_used"][i + 1];
		self.pers["killstreak_unique_id"][i] = self.pers["killstreak_unique_id"][i + 1];
		self.pers["killstreak_ammo_count"][i] = self.pers["killstreak_ammo_count"][i + 1];
	}
	
	self.pers["killstreaks"][arraySize-1] = undefined;
	self.pers["killstreak_has_been_used"][arraySize-1] = undefined;
	self.pers["killstreak_unique_id"][arraySize-1] = undefined;
	self.pers["killstreak_ammo_count"][arraySize-1] = undefined;
	
	return true;
}

function take_weapon_after_use( killstreakWeapon )
{
	self endon("disconnect");
	self endon("death");
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	self waittill( "weapon_change" );
	
	inventoryWeapon = self GetInventoryWeapon();
 	if ( inventoryWeapon != killstreakWeapon ) 
	{
		self TakeWeapon( killstreakWeapon );
	}
}

function get_top_killstreak()
{
	if ( self.pers["killstreaks"].size == 0 )
	{
		return undefined;
	}
		
	return self.pers["killstreaks"][self.pers["killstreaks"].size-1];
}

function get_if_top_killstreak_has_been_used()
{
	if ( !( isdefined( level.usingMomentum ) && level.usingMomentum ) )
	{
		if ( self.pers["killstreak_has_been_used"].size == 0 )
		{
			return undefined;
		}
		
		return self.pers["killstreak_has_been_used"][self.pers["killstreak_has_been_used"].size-1];
	}
}

function get_top_killstreak_unique_id()
{
	if ( self.pers["killstreak_unique_id"].size == 0 )
	{
		return undefined;
	}
		
	return self.pers["killstreak_unique_id"][self.pers["killstreak_unique_id"].size-1];
}

function get_killstreak_index_by_id( killstreakId )
{
	for( index = self.pers["killstreak_unique_id"].size - 1; index >= 0; index-- )
	{
		if( self.pers["killstreak_unique_id"][index] == killstreakId )
		{
			return index;
		}
	}

	return undefined;
}


function get_killstreak_momentum_cost( killstreak )
{
	if ( !( isdefined( level.usingMomentum ) && level.usingMomentum ) )
	{
		return 0;
	}

	if ( !isdefined( killstreak ) )
	{
		return 0;
	}

	Assert( isdefined(level.killstreaks[killstreak]) );
	
	return level.killstreaks[killstreak].momentumCost;
}

function get_killstreak_for_weapon( weapon )
{
	if( isdefined( level.killstreakWeapons[weapon] ) )
		return level.killstreakWeapons[weapon];
	else
		return level.killstreakWeapons[weapon.rootweapon];
}

function is_killstreak_weapon_assist_allowed( weapon )
{
	killstreak = get_killstreak_for_weapon( weapon );

	if ( !isdefined( killstreak ) )
	{
		return false;
	}
		
	if ( level.killstreaks[killstreak].allowAssists )
	{
		return true;
	}
		
	return false;
}

function get_killstreak_team_kill_penalty_scale( weapon )
{
	killstreak = get_killstreak_for_weapon( weapon );

	if ( !isdefined( killstreak ) )
	{
		return 1.0;
	}
		
	return level.killstreaks[killstreak].teamKillPenaltyScale;
}

function should_override_entity_camera_in_demo( player, weapon )
{
	killstreak = get_killstreak_for_weapon( weapon );

	if ( !isdefined( killstreak ) )
	{
		return false;
	}
		
	if ( level.killstreaks[killstreak].overrideEntityCameraInDemo )
	{
		return true;
	}
	
	if ( isdefined( player.remoteWeapon ) && ( isdefined( player.remoteWeapon.controlled ) && player.remoteWeapon.controlled ) )
	{
		return true;
	}
			
	return false;
}

function track_weapon_usage()
{
	self endon( "death" );
	self endon( "disconnect" );

	self.lastNonKillstreakWeapon = self GetCurrentWeapon();
	lastValidPimary = self GetCurrentWeapon();
	if ( self.lastNonKillstreakWeapon == level.weaponNone )
	{
		weapons = self GetWeaponsListPrimaries();
		if ( weapons.size > 0 )
		{
			self.lastNonKillstreakWeapon = weapons[0];
		}
		else
		{
			self.lastNonKillstreakWeapon = level.weaponBaseMelee;
		}
	}
	Assert( self.lastNonKillstreakWeapon != level.weaponNone );
	
	for ( ;; )
	{
		currentWeapon = self GetCurrentWeapon();
		self waittill( "weapon_change", weapon );
		
		if ( weapons::is_primary_weapon( weapon ) )
		{
			lastValidPimary = weapon;
		}

		if ( weapon == self.lastNonKillstreakWeapon || weapon == level.weaponNone || weapon == level.weaponBaseMelee )
		{
			continue;
		}

		if ( weapon.isGameplayWeapon )
		{
			continue;
		}

		name = get_killstreak_for_weapon( weapon );

		if ( isdefined( name ) && !weapon.isCarriedKillstreak )
		{
			killstreak = level.killstreaks[ name ];
			continue;
		}

		if ( currentWeapon.isEquipment )
		{
			if ( self.lastNonKillstreakWeapon.isCarriedKillstreak )
			{
				self.lastNonKillstreakWeapon = lastValidPimary;
			}
			continue;
		}

		self.lastNonKillstreakWeapon = weapon;
	}
}

function killstreak_waiter()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self thread track_weapon_usage();
	
	self give_owned();
	
	for ( ;; )
	{
		self waittill( "weapon_change", weapon );
		
		if( !killstreaks::is_killstreak_weapon( weapon ) )
		{
			continue;
		}
		
		killstreak = get_killstreak_for_weapon( weapon );
				
		if ( !( isdefined( level.usingMomentum ) && level.usingMomentum ) )
		{
			killstreak = get_top_killstreak();
			if( weapon != get_killstreak_weapon(killstreak) )
				continue;
		}
		
		if( is_remote_override_weapon( killstreak, weapon ) )
		{
			continue;
		}
		
		inventoryButtonPressed = ( self InventoryButtonPressed() ) || ( isdefined( self.pers["isBot"] ) );

		waittillframeend;

		if( ( isdefined( self.usingKillstreakHeldWeapon ) && self.usingKillstreakHeldWeapon ) && weapon.isCarriedKillstreak )
		{
			continue;
		}
		
		isFromInventory = undefined;
		
		if ( ( isdefined( level.usingScoreStreaks ) && level.usingScoreStreaks ) )
		{		
			if ( ( weapon == self GetInventoryWeapon() ) )
			{
				isFromInventory = true;
			}
			else if (( self GetAmmoCount( weapon ) <= 0 ) && (weapon.name != "killstreak_ai_tank"))
			{
				self killstreaks::switch_to_last_non_killstreak_weapon();
				continue;
			}
		}
		else if ( ( isdefined( level.usingMomentum ) && level.usingMomentum ) )
		{
			if ( ( weapon == self GetInventoryWeapon() ) && inventoryButtonPressed )
			{
				isFromInventory = true;
			}
			else if ( self.momentum < level.killstreaks[killstreak].momentumCost )
			{
				self killstreaks::switch_to_last_non_killstreak_weapon();
				continue;
			}
		}
		
		thread useKillstreak( killstreak, isFromInventory );
	}
}

function should_delay_killstreak( killstreakType )
{
	if( !isdefined(level.startTime) )
	{
		return false;
	}

	if( level.roundStartKillstreakDelay < ( ( ( gettime() - level.startTime ) - level.discardTime ) / 1000 ) )
	{
		return false;
	}

	if( !is_delayable_killstreak(killstreakType) )
	{
		return false;
	}

	killstreakWeapon = get_killstreak_weapon( killstreakType );
	if( killstreakWeapon.isCarriedKillstreak )
	{
		return false;
	}

	if ( util::isFirstRound() || util::isOneRound() )
	{
		return false;
	}

	return true;
}

//check if this is a killstreak we want to delay at the start of a round
function is_delayable_killstreak( killstreakType )
{
	if( isdefined( level.killstreaks[killstreakType] ) && ( isdefined( level.killstreaks[killstreakType].delayStreak ) && level.killstreaks[killstreakType].delayStreak ) )
	{
		return true;
	}

	return false;
}

function get_xp_amount_for_killstreak( killstreakType )
{
	// looks like only the rcxd does this
	// all killstreaks need this?
	xpAmount = 0;
	switch( level.killstreaks[killstreakType].killstreakLevel )
	{
	case 1:
	case 2:
	case 3:
	case 4:
		xpAmount = 100;
		break;
	case 5:
		xpAmount = 150;
		break;
	case 6:
	case 7:
		xpAmount = 200;
		break;
	case 8:
		xpAmount = 250;
		break;
	case 9:
		xpAmount = 300;
		break;
	case 10:
	case 11:
		xpAmount = 350;
		break;
	case 12:
	case 13:
	case 14:
	case 15:
		xpAmount = 500;
		break;
	}

	return xpAmount;
}


function trigger_killstreak( killstreakType, isFromInventory )
{
	assert( isdefined(level.killstreaks[killstreakType].useFunction), "No use function defined for killstreak " + killstreakType);
	
	self.usingKillstreakFromInventory = isFromInventory;

	if ( level.inFinalKillcam )
	{
		return false;
	}
	
	if( should_delay_killstreak( killstreakType ) )
	{
		timeLeft = Int( level.roundStartKillstreakDelay - (globallogic_utils::getTimePassed() / 1000) );
		
		if( !timeLeft )
		{
			timeLeft = 1;
		}

		self iPrintLnBold( &"MP_UNAVAILABLE_FOR_N", " " + timeLeft + " ", &"EXE_SECONDS" );
	}
	else if ( [[level.killstreaks[killstreakType].useFunction]](killstreakType) )
	{
		//Killstreak of 3-4:+100, 5: +150, 6-7 +200, 8: +250, 9: +300, 11: +350, Above: +500

		if ( isdefined( self ) )
		{
			//bbPrint( "mpkillstreakuses", "gametime %d spawnid %d name %s", getTime(), getplayerspawnid( self ), killstreakType );

			if ( !isdefined( self.pers[level.killstreaks[killstreakType].usageKey] ) )
			{
				self.pers[level.killstreaks[killstreakType].usageKey] = 0;
			}
			
			self.pers[level.killstreaks[killstreakType].usageKey]++;
			self notify( "killstreak_used", killstreakType );
			self notify( "killstreak_done", true, killstreakType );
		}
		
		self.usingKillstreakFromInventory = undefined;
		
		return true;
	}
	
	self.usingKillstreakFromInventory = undefined;
	
	if ( isdefined( self ) )
	{
		self notify( "killstreak_done", false, killstreakType );
	}
	return false;
}

function add_to_killstreak_count( weapon )
{
	if ( !isdefined( self.pers["totalKillstreakCount"] ) )
	{
		self.pers["totalKillstreakCount"] = 0;
	}
		
// The check is now done further up the stack to see if this should be counted
		self.pers["totalKillstreakCount"]++;
}

function get_first_valid_killstreak_alt_weapon( killstreakType )
{
	assert( isdefined(level.killstreaks[killstreakType]), "Killstreak not registered.");

	if( isdefined( level.killstreaks[killstreakType].altWeapons ) )
	{
		for( i = 0; i < level.killstreaks[killstreakType].altWeapons.size; i++ )
		{
			if( isdefined( level.killstreaks[killstreakType].altWeapons[i] ) )
			{
				return level.killstreaks[killstreakType].altWeapons[i];
			}
		}
	}
	
	return level.weaponNone;
}

function should_give_killstreak( weapon ) 
{
	if( GetDvarInt( "teamOpsEnabled" ) == 1 )
		return false;
	
	killstreakBuilding = GetDvarint( "scr_allow_killstreak_building" );
	
	if ( killstreakBuilding == 0 )
	{
		if ( killstreaks::is_weapon_associated_with_killstreak(weapon) )
		{
			return false;
		}
	}
	
	return true;
}

function point_is_in_danger_area( point, targetpos, radius )
{
	return distance2d( point, targetpos ) <= radius * 1.25;
}

function print_killstreak_start_text( killstreakType, owner, team, targetpos, dangerRadius )
{
	if ( !isdefined( level.killstreaks[killstreakType] ) )
	{
		return;
	}
	
	if ( level.teambased )
	{
		players = level.players;
		if ( !level.hardcoreMode && isdefined(level.killstreaks[killstreakType].inboundNearPlayerText))
		{
			for(i = 0; i < players.size; i++)
			{
				if(isalive(players[i]) && (isdefined(players[i].pers["team"])) && (players[i].pers["team"] == team)) 
				{
					if ( point_is_in_danger_area( players[i].origin, targetpos, dangerRadius ) )
					{
						players[i] iprintlnbold(level.killstreaks[killstreakType].inboundNearPlayerText);
					}
				}
			}
		}
		
		if ( isdefined(level.killstreaks[killstreakType]) )
		{
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				playerteam = player.pers["team"];
				if ( isdefined( playerteam ) )
				{
					if ( playerteam == team )
					{
						player iprintln( level.killstreaks[killstreakType].inboundText, owner );
					}
				}
			}
		}
	}
	else
	{
		if ( !level.hardcoreMode && isdefined(level.killstreaks[killstreakType].inboundNearPlayerText) )
		{
			if ( point_is_in_danger_area( owner.origin, targetpos, dangerRadius ) )
			{
				owner iprintlnbold(level.killstreaks[killstreakType].inboundNearPlayerText);
			}
		}
	}
}


function play_killstreak_start_dialog( killstreakType, team, playNonTeamBasedEnemySounds )
{
	if ( !isdefined( level.killstreaks[killstreakType] ) )
	{
		return;
	}
	
	dialogIndex = level.killstreaks[killstreakType].requestSoundIndex;
	
	if ( isdefined( dialogIndex ) && isdefined( level.heroPlayDialog ) )
    {		
		[[level.heroPlayDialog]]( dialogIndex );
    }

	// Only play UAV Notifications every few seconds
	if ( killstreakType == "uav" )
	{
		time = getTime();
		if( time < level.uavTimers[team] )
		{
			return;
		}
		
		level.uavTimers[team] = time + 4000;
	}
	
	excludeSelf = [];
	excludeSelf[0] = self;
	
	if ( level.teambased )
	{
		// Don't play the friendly incoming audio over your own request
		globallogic_audio::leader_dialog( level.killstreaks[killstreakType].startSoundIndex, team, undefined, excludeSelf );
		
		globallogic_audio::leader_dialog_for_other_teams( level.killstreaks[killstreakType].enemyStartSoundIndex, team );
	}
	else
	{
		globallogic_audio::leader_dialog( level.killstreaks[killstreakType].enemyStartSoundIndex, undefined, undefined, excludeSelf );
	}
}

function play_killstreak_ready_sfx (killstreaktype)
{
	if ( !isdefined( level.gameEnded ) || !level.gameEnded )
	{
		ready_sfx_alias = "mpl_killstreak_" + killstreaktype;
		
		if ( isdefined (ready_sfx_alias))
		{
			self playsoundtoplayer (ready_sfx_alias, self );
		}
	}
}	

function play_killstreak_ready_dialog( killstreakType, taacomWaitTime )
{
	if ( !isdefined( level.gameEnded ) || !level.gameEnded )
	{
		if ( isdefined( taacomWaitTime ) )
		{
			self thread wait_play_taacom_dialog( taacomWaitTime, killstreakType, 10 );
		}
		else
		{
			self play_taacom_dialog( killstreakType, 10 );
		}
		
		// TODO: Only play this when a scorestreak is earned, not taken from a crate
		if ( isdefined( self._gadget_combat_efficiency ) && self._gadget_combat_efficiency && !self._gadget_combat_efficiency_success && isdefined( level.playHeroabilitySuccess ) )
	    {
			self [[ level.playHeroabilitySuccess ]]( 3 );
			self._gadget_combat_efficiency_success = true;
	    }
	}
}

function wait_play_taacom_dialog( taacomWaitTime, killstreakType, soundIndex, waitForPlayer )
{
	self endon( "death" );
	level endon( "game_ended" );
	
	wait ( taacomWaitTime );
	
	play_taacom_dialog( killstreakType, soundIndex, waitForPlayer );
}

function play_taacom_dialog( killstreakType, soundIndex, waitForPlayer )
{
	self globallogic_audio::scorestreak_dialog_on_player( soundIndex, level.killstreaks[killstreakType].taacomDialogIndex, waitForPlayer );
}

function play_taacom_dialog_response( killstreakType, soundIndex, waitForPlayer )
{
	responseIndex = soundIndex + self.killstreakPilots[killstreakType];
	
	self globallogic_audio::scorestreak_dialog_on_player( responseIndex, level.killstreaks[killstreakType].taacomDialogIndex, waitForPlayer );
}

function play_pilot_dialog( killstreakType, soundIndex, waitForPlayer )
{
	pilotIndex = level.killstreaks[killstreakType].pilotDialogIndex + self.killstreakPilots[killstreakType];
	self globallogic_audio::scorestreak_dialog_on_player( soundIndex, pilotIndex, waitForPlayer );
}

function pick_pilot( killstreakType, numPilots )
{
	if ( !isdefined( self.killstreakPilots ) )
	{
		self.killstreakPilots = [];
	}
	self.killstreakPilots[killstreakType] = RandomInt( numPilots );

}

function get_killstreak_inform_dialog( killstreakType )
{
	// please add inform dialog to killstreak
	assert( isdefined ( level.killstreaks[killstreakType].informDialog ) );
	
	if ( isdefined( level.killstreaks[killstreakType].informDialog ) )
	{
		return level.killstreaks[killstreakType].informDialog;
	}
	return "";
}

function play_killstreak_end_dialog( killstreakType, team )
{
	return;
	if ( !isdefined( level.killstreaks[killstreakType] ) )
	{
		return;
	}
	
	if ( level.teambased )
	{
		globallogic_audio::leader_dialog( killstreakType + "_end", team );
		globallogic_audio::leader_dialog_for_other_teams( killstreakType + "_enemy_end", team );
	}
	else
	{
		self globallogic_audio::leader_dialog_on_player( killstreakType + "_end" );
	}
}

function get_killstreak_usage_by_killstreak(killstreakType)
{
	assert( isdefined(level.killstreaks[killstreakType]), "Killstreak needs to be registered before calling get_killstreak_usage.");
	
	return get_killstreak_usage( level.killstreaks[killstreakType].usageKey );
}

function get_killstreak_usage(usageKey)
{
	if ( !isdefined( self.pers[usageKey] ) )
	{
		return 0;
	}
	
	return self.pers[usageKey];
}

function on_player_spawned()
{
	self endon("disconnect");

	pixbeginevent("_killstreaks.gsc/onPlayerSpawned");
	
	give_owned();
	
	if ( !isdefined( self.pers["killstreaks"] ) )
	{
		self.pers["killstreaks"] = [];
	}
	if ( !isdefined( self.pers["killstreak_has_been_used"] ) )
	{
		self.pers["killstreak_has_been_used"] = [];
	}
	if ( !isdefined( self.pers["killstreak_unique_id"] ) )
	{
		self.pers["killstreak_unique_id"] = [];
	}
	if( !isdefined( self.pers["killstreak_ammo_count"] ) )
	{
		self.pers["killstreak_ammo_count"] = [];
	}

	size = self.pers["killstreaks"].size;

	if ( size > 0 )
	{
		play_killstreak_ready_dialog( self.pers["killstreaks"][size - 1] );
	}
		
	pixendevent();
}

function on_joined_team()
{
	self endon("disconnect");
	
	self SetInventoryWeapon( level.weaponNone );
	self.pers["cur_kill_streak"] = 0;
	self.pers["cur_total_kill_streak"] = 0;		
	self setplayercurrentstreak( 0 );
	self.pers["totalKillstreakCount"] = 0;
	self.pers["killstreaks"] = [];
	self.pers["killstreak_has_been_used"] = [];
	self.pers["killstreak_unique_id"] = [];
	self.pers["killstreak_ammo_count"] = [];
	
	if ( ( isdefined( level.usingScoreStreaks ) && level.usingScoreStreaks ) )
	{
		self.pers["killstreak_quantity"] = [];
		self.pers["held_killstreak_ammo_count"] = [];
		self.pers["held_killstreak_clip_count"] = [];
	}
}

function create_killstreak_timer_for_team( killstreakType, xPosition, team )
{
	assert( isdefined( level.killstreak_timers[team] ) );
	
	killstreakTimer = spawnstruct();
	killstreakTimer.team = team;
	
	killstreakTimer.icon = hud::createServerIcon( level.killstreaks[killstreakType].iconMaterial, 36, 36, team );
	killstreakTimer.icon.horzAlign = "user_left";
	killstreakTimer.icon.vertAlign = "user_top";
	killstreakTimer.icon.x = xPosition+15;
	killstreakTimer.icon.y = 100;
	killstreakTimer.icon.alpha = 0;
	killstreakTimer.killstreakType = killstreakType;
	
	level.killstreak_timers[team][level.killstreak_timers[team].size] = killstreakTimer;
}

function create_killstreak_timer( killstreakType )
{
	switch( killstreakType )
	{
		case "radar":
			xPosition = 0;
			break;
			
		case "counteruav":
			xPosition = 20;
			break;
			
		case "missile_swarm":
			xPosition = 2*20;
			break;
			
		case "emp":
			xPosition = 3*20;
			break;
			
		case "radardirection":
			xPosition = 4*20;
			break;
			
		default:
			xPosition = 0;
			break;
	}

	foreach( team in level.teams )
	{
		create_killstreak_timer_for_team( killstreakType, xPosition, team );
	}	


}

function destroy_killstreak_timers()
{
	level notify( "endKillstreakTimers" );
	if ( isdefined( level.killstreak_timers ) )
	{
		foreach( team in level.teams )
		{
			foreach( killstreakTimer in level.killstreak_timers[team] )
			{
				killstreakTimer.icon hud::destroyElem();
			}
		}
		level.killstreak_timers = undefined;
	}
}

function get_timer_for_killstreak( team, killstreakType, duration )
{
	endTime = gettime() + duration * 1000;
	numKillstreakTimers = level.killstreak_timers[team].size;
	killstreakSlot = undefined;
	targetIndex = 0;
	for ( i = 0 ; i < numKillstreakTimers ; i++ )
	{
		killstreakTimer = level.killstreak_timers[team][i];
		if ( isdefined( killstreakTimer.killstreakType ) && ( killstreakTimer.killstreakType == killstreakType ) )
		{
			killstreakSlot = i;
			break;
		}
		else if ( !isdefined( killstreakTimer.killstreakType ) && !isdefined( killstreakSlot ) )
		{
			killstreakSlot = i;
		}
	}
	
	if ( isdefined( killstreakSlot ) )
	{
		killstreakTimer = level.killstreak_timers[team][killstreakSlot];
		killstreakTimer.endTime = endTime;
		killstreakTimer.icon.alpha = 1;
		return killstreakTimer;
	}
}

function free_killstreak_timer( killstreakTimer )
{
	killstreakTimer.icon.alpha = 0.2;
	killstreakTimer.endTime = undefined;
}

function killstreak_timer( killstreakType, team, duration )
{
	level endon( "endKillstreakTimers" );
	
	if ( level.gameended )
	{
		return;
	}
	
	killstreakTimer = get_timer_for_killstreak( team, killstreakType, duration );
	if ( !isdefined( killstreakTimer ) )
	{
		return;
	}
	
	eventName = team+"_"+killstreakType;
	level notify( eventName );
	level endon( eventName );
	
	blinkingDuration = 5;
	
	if ( duration > 0 )
	{		
		wait ( duration - blinkingDuration );
		
		while ( blinkingDuration > 0 )
		{
			killstreakTimer.icon fadeOverTime( .5 );
			killstreakTimer.icon.alpha = 1;
			wait ( .5 );
			killstreakTimer.icon fadeOverTime( .5 );
			killstreakTimer.icon.alpha = 0;
			wait ( .5 );
			blinkingDuration -= 1;
		}
	}
	
	free_killstreak_timer( killstreakTimer );
}

function set_killstreak_timer( killstreakType, team, duration )
{
	thread killstreak_timer( killstreakType, team, duration );
}

function init_ride_killstreak( streak )
{
	self disableUsability();
	result = self init_ride_killstreak_internal( streak );

	if ( isdefined( self ) )
	{
		self enableUsability();
	}
		
	return result;
}

function watch_for_remove_remote_weapon()
{
	self endon( "endWatchForRemoveRemoteWeapon" );
	for ( ;; )
	{
		self waittill( "remove_remote_weapon" );
		self killstreaks::switch_to_last_non_killstreak_weapon();
		self enableUsability();
	}
}

function init_ride_killstreak_internal( streak )
{	
	if ( isdefined( streak ) && ( ( streak == "qrdrone" ) || ( streak == "dart" ) || ( streak == "killstreak_remote_turret" ) || ( streak == "killstreak_ai_tank" ) || (streak == "qrdrone") || (streak == "sentinel") ) )
	{
		laptopWait = "timeout";
	}
	else
	{
		laptopWait = self util::waittill_any_timeout( 0.6, "disconnect", "death", "weapon_switch_started" );
	}
		
	hostmigration::waitTillHostMigrationDone();

	if ( laptopWait == "weapon_switch_started" )
	{
		return ( "fail" );
	}

	if ( !isAlive( self ) )
	{
		return "fail";
	}

	if ( laptopWait == "disconnect" || laptopWait == "death" )
	{
		if ( laptopWait == "disconnect" )
		{
			return ( "disconnect" );
		}

		if ( self.team == "spectator" )
		{
			return "fail";
		}

		return ( "success" );		
	}
	
	if ( self IsEMPJammed() )
	{
		return ( "fail" );
	}
	
	if ( self is_interacting_with_object() )
	{
		return "fail";
	}
	
	self thread hud::fade_to_black_for_x_sec( 0, 0.2, 0.4, 0.25 );
	self thread watch_for_remove_remote_weapon();
	blackOutWait = self util::waittill_any_timeout( 0.60, "disconnect", "death" );
	self notify( "endWatchForRemoveRemoteWeapon" );

	hostmigration::waitTillHostMigrationDone();

	if ( blackOutWait != "disconnect" ) 
	{
		self thread clear_ride_intro( 1.0 );
		
		if ( self.team == "spectator" )
		{
			return "fail";
		}
	}

	if ( self isOnLadder() )
	{
		return "fail";	
	}

	if ( !isAlive( self ) )
	{
		return "fail";
	}

	if ( self IsEMPJammed() )
	{
		return "fail";
	}
	
	if ( self is_interacting_with_object() )
	{
		return "fail";
	}
	
	if ( blackOutWait == "disconnect" )
	{
		return ( "disconnect" );
	}
	else
	{
		return ( "success" );		
	}
}

function clear_ride_intro( delay )
{
	self endon( "disconnect" );

	if ( isdefined( delay ) )
		wait( delay );

	//self util::freeze_player_controls( false );
	
	self thread hud::fade_to_black_for_x_sec( 0, 0, 0, 0 );
}

/#

function killstreak_debug_think()
{
	SetDvar( "debug_killstreak", "" );

	for( ;; )
	{
		cmd = GetDvarString( "debug_killstreak" );

		switch( cmd )
		{
		case "data_dump":	
			killstreak_data_dump();
			break;
		}

		if ( cmd != "" )
		{
			SetDvar( "debug_killstreak", "" );
		}

		wait( 0.5 );
	}
}

function killstreak_data_dump()
{
	iprintln( "Killstreak Data Sent to Console" );
	println( "##### Killstreak Data #####");
	println( "killstreak,killstreaklevel,weapon,altweapon1,altweapon2,altweapon3,altweapon4,type1,type2,type3,type4" );
	
	keys = GetArrayKeys( level.killstreaks );
		
	for( i = 0; i < keys.size; i++ )
	{
		data = level.killstreaks[ keys[i] ];
		type_data = level.killstreaktype[ keys[i] ];
		
		print( keys[i] + "," );
		print( data.killstreaklevel + "," );
		print( data.weapon.name + "," );

		alt = 0;

		if ( isdefined( data.altweapons ) )
		{
			assert( data.altweapons.size <= 4 );

			for ( alt = 0; alt < data.altweapons.size; alt++ )
			{
				print( data.altweapons[alt].name + "," );
			}
		}

		for ( ; alt < 4; alt++ )
		{
			print( "," );
		}

		type = 0;

		if ( isdefined( type_data ) )
		{
			assert( type_data.size < 4 );
			type_keys = GetArrayKeys( type_data );

			for ( ; type < type_keys.size; type++ )
			{
				if ( type_data[ type_keys[type] ] == 1 )
				{
					print( type_keys[type] + "," );
				}
			}
		}

		for ( ; type < 4; type++ )
		{
			print( "," );
		}

		println( "" );
	}

	println( "##### End Killstreak Data #####");
}

#/


function is_interacting_with_object()
{
	if ( self isCarryingTurret() )
	{
		return true;
	}
	if ( ( isdefined( self.isPlanting ) && self.isPlanting ) )
	{
		return true;
	}
	if ( ( isdefined( self.isDefusing ) && self.isDefusing ) )
	{
		return true;
	}

	return false;
}


function clear_using_remote()
{
	if ( !isdefined( self ) )
	{
		return;
	}

	if ( isdefined( self.carryIcon) )
	{
		self.carryIcon.alpha = 1;
	}

	self.usingRemote = undefined;
	self enableOffhandWeapons();
	self enableWeaponCycling();
	
	curWeapon = self getCurrentWeapon();
	
	if ( isalive( self ) )
	{
		self killstreaks::switch_to_last_non_killstreak_weapon();
	}
	
	self util::freeze_player_controls( false );
	
	self notify( "stopped_using_remote" );
}

function MonitorDamage( killstreak_ref, 
               			max_health, destroyed_callback, 
               			low_health, low_health_callback, 
               			emp_damage, emp_callback, 
               			allow_bullet_damage )
{
	self endon( "death" );
	self endon( "delete" );
	
	self.health = 9999999;
	self.damageTaken = 0;
	
	self.maxhealth = max_health;
	self.lowhealth = low_health;
	
	tableHealth = killstreaks::get_max_health( killstreak_ref );
	
	if ( isdefined( tableHealth ) )
	{
		self.maxhealth = tableHealth;
	}
	
	tableHealth = killstreaks::get_low_health( killstreak_ref );
	
	if ( isdefined( tableHealth ) )
	{
		self.lowhealth = tableHealth;
	}	
	
	assert( !IsSentient(self), "MonitorDamage should not be called on a sentient. For sentients, use overrideVehicleDamage instead.");

	while( true )
	{
		// this damage is done to self.health which isnt used to determine the helicopter's health, damageTaken is.
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon, flags, inflictor, chargeLevel );		

		if( ( isdefined( self.invulnerable ) && self.invulnerable ) )
		{
			continue;
		}
		
		if( !isdefined( attacker ) || !isplayer( attacker ) )
		{
			continue;
		}
		
		friendlyfire = weaponobjects::friendlyFireCheck( self.owner, attacker );
		if( !friendlyfire )
		{
			continue;			
		}
			
		if(	isdefined( self.owner ) && attacker == self.owner )
		{
			continue;
		}
		
		isValidAttacker = true;
		if( level.teambased )
		{
			isValidAttacker = ( isdefined( attacker.team ) && attacker.team != self.team );
		}

		if( !isValidAttacker )
		{
			continue;
		}
		
		if( weapon.isEmp && type == "MOD_GRENADE_SPLASH" )
		{
			if( isdefined( emp_callback ) )
			{
				self [[ emp_callback ]]( attacker );
			}
			
			damage = damage + emp_damage;
		}
		
		if ( ( isdefined( self.selfDestruct ) && self.selfDestruct ) )
		{
			weapon_damage = self.maxhealth + 1;
		}
		else
		{
			weapon_damage = killstreaks::get_weapon_damage( killstreak_ref, self.maxhealth, attacker, weapon, type, damage, flags, chargeLevel );

			if ( !isdefined( weapon_damage ) )
			{			
				weapon_damage = get_old_damage( attacker, weapon, type, damage, allow_bullet_damage );
			}
		}		
		
		if ( weapon_damage > 0 )
		{
			if( damagefeedback::doDamageFeedback( weapon, attacker ) )
			{
				attacker thread damagefeedback::update( type );
			}
			
			self challenges::trackAssists( attacker, weapon_damage, false );
		}		
		
		self.damageTaken += weapon_damage;
		
		self.attacker = attacker;
				
		if( self.damageTaken > self.maxhealth )
		{
			weaponStatName = "destroyed";
			switch( weapon.name )
			{
				case "auto_tow":
				case "tow_turret":
				case "tow_turret_drop":
					weaponStatName = "kills";
					break;
			}
			
			attacker AddWeaponStat( weapon, weaponStatName, 1 );
			level.globalKillstreaksDestroyed++;
			attacker AddWeaponStat( GetWeapon( killstreak_ref ), "destroyed", 1 );
			
			if( isdefined( destroyed_callback ) )
			{
				self [[ destroyed_callback ]]( attacker, weapon );
			}
			
			return;
		}
		
		if( self.damageTaken >= self.lowhealth )
		{
			if( isdefined( low_health_callback ) && ( !isdefined( self.currentState ) || self.currentState != "damaged" ) )
			{
				self [[ low_health_callback ]]( attacker, weapon );
			}
			
			self.currentstate = "damaged";
		}
	}
}

function OnDamagePerWeapon( killstreak_ref, 
                  		attacker, damage, flags, type, weapon,
               			max_health, destroyed_callback, 
               			low_health, low_health_callback, 
               			emp_damage, emp_callback, 
               			allow_bullet_damage, chargeLevel )
{	
	self.maxhealth = max_health;
	self.lowhealth = low_health;
	
	tableHealth = killstreaks::get_max_health( killstreak_ref );
	
	if ( isdefined( tableHealth ) )
	{
		self.maxhealth = tableHealth;
	}
	
	tableHealth = killstreaks::get_low_health( killstreak_ref );
	
	if ( isdefined( tableHealth ) )
	{
		self.lowhealth = tableHealth;
	}	
	
	if( ( isdefined( self.invulnerable ) && self.invulnerable ) )
	{
		return 0;
	}
	
	if( !isdefined( attacker ) || !isplayer( attacker ) )
	{
		return get_old_damage( attacker, weapon, type, damage, allow_bullet_damage );
	}
	
	friendlyfire = weaponobjects::friendlyFireCheck( self.owner, attacker );
	if( !friendlyfire )
	{
		return 0;
	}	
	
	isValidAttacker = true;
	if( level.teambased )
	{
		isValidAttacker = ( isdefined( attacker.team ) && attacker.team != self.team );
	}

	if( !isValidAttacker )
	{
		return 0;
	}	
	
	if( weapon.isEmp && type == "MOD_GRENADE_SPLASH" )
	{
		if( isdefined( emp_callback ) )
		{
			self [[ emp_callback ]]( attacker );
		}
		
		return emp_damage;
	}	

	weapon_damage = killstreaks::get_weapon_damage( killstreak_ref, self.maxhealth, attacker, weapon, type, damage, flags, chargeLevel );

	if ( !isdefined( weapon_damage ) )
	{			
		weapon_damage = get_old_damage( attacker, weapon, type, damage, allow_bullet_damage );
	}
	
	if ( weapon_damage <= 0 )
	{
		return 0;
	}		
	
	return int(weapon_damage);
}

function get_old_damage( attacker, weapon, type, damage, allow_bullet_damage)
{
	switch( type )
	{
		case "MOD_RIFLE_BULLET":
		case "MOD_PISTOL_BULLET":
			{
				if( !allow_bullet_damage )
				{
					damage = 0;
					break;
				}
				
				if ( isdefined( attacker ) )
				{
					hasFMJ = attacker HasPerk( "specialty_armorpiercing" );
				}				
	
				if ( ( isdefined( hasFMJ ) && hasFMJ ) )
				{
					damage = int( damage * level.cac_armorpiercing_data );
				}
			}
			break;
		case "MOD_PROJECTILE":
		case "MOD_EXPLOSIVE":
		case "MOD_PROJECTILE_SPLASH":
			if( isdefined( self.remoteMissileDamage ) && isdefined( weapon ) && weapon.name == "remote_missile_missile")
			{
				 damage = self.remoteMissileDamage;
			}
			else if( isdefined( self.rocketDamage ) )
			{
				damage = self.rocketDamage;
			}
			break;
		default:			
			break;
	}
	
	return damage;
}
