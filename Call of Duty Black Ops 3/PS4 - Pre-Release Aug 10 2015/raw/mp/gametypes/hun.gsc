#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_util;
#using scripts\mp\killstreaks\_supplydrop;

/*
	Hunted
	Objective: 	Score points by eliminating other players.  Packages are dropped randomly
							which contain weapons and ammo.
	Map ends:	When one player reaches the score limit, or time limit is reached
	Respawning:	No wait / Away from other players

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_dm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of enemies at the time of spawn.
			Players generally spawn away from enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["axis"] = "nva";
			Because Deathmatch doesn't have teams with regard to gameplay or scoring, this effectively sets the available weapons.

		If using minefields or exploders:
			load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["soldiertypeset"] = "seals";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				soldiertypeset	seals
*/

/*QUAKED mp_dm_spawn (1.0 0.5 0.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies at one of these positions.*/

#precache( "string", "OBJECTIVES_DM" );
#precache( "string", "OBJECTIVES_DM_SCORE" );
#precache( "string", "OBJECTIVES_DM_HINT" );

// smg
#precache( "string", "WEAPON_SMG_STANDARD" );
//assault
#precache( "string", "WEAPON_AR_STANDARD" );
// LMG
#precache( "string", "WEAPON_LMG_LIGHT" );
// shotgun
#precache( "string", "WEAPON_SHOTGUN_PUMP" );
// pistol
#precache( "string", "WEAPON_PISTOL_STANDARD" );

function main()
{
	globallogic::init();

	util::registerTimeLimit( 0, 1440 );
	util::registerScoreLimit( 0, 50000 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerNumLives( 0, 100 );

	globallogic::registerFriendlyFireDelay( level.gameType, 0, 0, 1440 );

	level.scoreRoundWinBased = true;
	level.resetPlayerScoreEveryRound = true;
	level.onStartGameType =&onStartGameType;
	level.giveCustomLoadout =&giveCustomLoadout;

	level.heliTime = GetGametypeSetting( "objectiveSpawnTime" );

	gameobjects::register_allowed_gameobject( "dm" );

	game["dialog"]["gametype"] = "ffa_start";
	game["dialog"]["gametype_hardcore"] = "hcffa_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";

	// Sets the scoreboard columns and determines with data is sent across the network
	globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths", "kdratio", "headshots" ); 
	
}


function onStartGameType()
{
	setClientNameMode("auto_change");

	util::setObjectiveText( "allies", &"OBJECTIVES_DM" );
	util::setObjectiveText( "axis", &"OBJECTIVES_DM" );

	if ( level.splitscreen )
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_DM" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_DM" );
	}
	else
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_DM_SCORE" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_DM_SCORE" );
	}
	util::setObjectiveHintText( "allies", &"OBJECTIVES_DM_HINT" );
	util::setObjectiveHintText( "axis", &"OBJECTIVES_DM_HINT" );

	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	spawnlogic::add_spawn_points( "allies", "mp_dm_spawn" );
	spawnlogic::add_spawn_points( "axis", "mp_dm_spawn" );
	spawning::updateAllSpawnPoints();
	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	// use the new spawn logic from the start
	level.useStartSpawns = false;
	
	level.displayRoundEndText = false;
	
	level thread onScoreCloseMusic();

	if ( !util::isOneRound() )
	{
		level.displayRoundEndText = true;
	}
	
	level.heliOwner = spawn( "script_origin", (0,0,0) );
	initDropLocations();
	registerCrates();
	thread crateDropper();
}


function onEndGame( winningPlayer )
{
	if ( isdefined( winningPlayer ) && isPlayer( winningPlayer ) )
		[[level._setPlayerScore]]( winningPlayer, winningPlayer [[level._getPlayerScore]]() + 1 );
}

// *******************************************************************
//                   Custom Loadout
// *******************************************************************
function giveCustomLoadout()
{
	self takeAllWeapons();
	self ClearPerks();
	
	weapon = GetWeapon( "pistol_standard" );

	self.primaryWeapon = weapon;
	self.lethalGrenade = GetWeapon( "hatchet" );
	self.tacticalGrenade = undefined;
	
	self GiveWeapon( weapon );
	self GiveWeapon( level.weaponBaseMelee );
	self GiveWeapon( level.weaponBaseMeleeHeld );
	self GiveWeapon( self.lethalGrenade );
	self SetWeaponAmmoStock( weapon, 0 );
	self SetWeaponAmmoClip( weapon, 5 );
	self switchToWeapon( weapon );
	
	self setSpawnWeapon( weapon );
	
	return weapon;
}

function onScoreCloseMusic()
{
    while( !level.gameEnded )
    {
        scoreLimit = level.scoreLimit;
	    scoreThreshold = scoreLimit * .9;
        
        for(i=0;i<level.players.size;i++)
        {
            scoreCheck = [[level._getPlayerScore]]( level.players[i] );
            
            if( scoreCheck >= scoreThreshold )
            {
                thread globallogic_audio::set_music_on_team( "timeOut" );
                return;
            }
        }
        
        wait(.5);
    }
}

function inside_bounds( node_origin, bounds )
{
	mins = level.mapCenter - bounds;
	maxs = level.mapCenter + bounds;
	
	if ( node_origin[0] > maxs[0] )
		return false;
	if ( node_origin[0] < mins[0] )
		return false;
	if ( node_origin[1] > maxs[1] )
		return false;
	if ( node_origin[1] < mins[1] )
		return false;
		
	return true;
}

function initDropLocations()
{
	scalar = 0.8;
	
	bound = ( level.spawnMaxs - level.mapCenter ) * scalar ;
	
//	all_nodes = getallnodes();
	
//	center = (0,0,0);
	
//	foreach( node in all_nodes )
//	{
//		center = center + node.origin;
//	}
//	
//	center = center / all_nodes.size;
	
///#
//	mins = level.mapCenter - bound;
//	maxs = level.mapCenter + bound;
//
//	time = 10000;
//	box( level.mapCenter, -1 * bound, bound, 0, (1,1,0), 1, 1, time );
////	sphere( center, 20, (1,1,0), 1, true, 10, time );
//	sphere( level.mapCenter, 20, (1,1,1), 1, true, 10, time );
//	sphere( mins, 20, (0,1,0), 1, true, 10, time );
//	sphere( maxs, 20, (1,0,0), 1, true, 10, time );
//	sphere( level.spawnMins, 20, (0,1,0), 1, true, 10, time );
//	sphere( level.spawnMaxs, 20, (1,0,0), 1, true, 10, time );
//#/

	// get path nodes using the radius function to help trim out the nodes around the bounds
//	possible_nodes = GetNodesInRadius( level.mapCenter, Length( bound ), 0 ,level.spawnMaxs[2], "Path" );
	possible_nodes = getallnodes();
	nodes = [];
	
	count = 0;
	
	foreach( node in possible_nodes )
	{
		if ( inside_bounds( node.origin, bound ) )
		{
			nodes[nodes.size] = node;

//			debugstar(  node.origin, time, ( 1, 0, 1 ) );
			count++;
		}
	}
	
	level.dropNodes = nodes;
}

function registerCrates()
{
	// weapons
	
	// smg

	supplydrop::registerCrateType("hunted", "weapon", "smg_standard", 1, &"WEAPON_SMG_STANDARD", undefined,&giveHuntedWeapon,&huntedCrateLandOverride );
	
	//	assault
	supplydrop::registerCrateType("hunted", "weapon", "ar_standard", 1, &"WEAPON_AR_STANDARD", undefined,&giveHuntedWeapon,&huntedCrateLandOverride );

	// LMG
	supplydrop::registerCrateType("hunted", "weapon", "lmg_light", 1, &"WEAPON_LMG_LIGHT", undefined,&giveHuntedWeapon,&huntedCrateLandOverride );

	// shotgun
	supplydrop::registerCrateType("hunted", "weapon", "shotgun_pump", 1, &"WEAPON_SHOTGUN_PUMP", undefined,&giveHuntedWeapon,&huntedCrateLandOverride );


	// pistol
	supplydrop::registerCrateType("hunted", "weapon", "pistol_standard", 1, &"WEAPON_PISTOL_STANDARD", undefined,&giveHuntedWeapon,&huntedCrateLandOverride );


	// killstreaks
/*
	// NOTE: precache strings in the top of the file
	supplydrop::registerCrateType("hunted", "killstreak", "radar", 4, &"KILLSTREAK_RADAR_CRATE",&giveCrateKillstreak,&huntedCrateLandOverride );
	supplydrop::registerCrateType("hunted", "killstreak", "autoturret", 3, &"KILLSTREAK_AUTO_TURRET_CRATE",&giveCrateKillstreak,&huntedCrateLandOverride );
	supplydrop::registerCrateType("hunted", "killstreak", "remote_missile", 4, &"KILLSTREAK_REMOTE_MISSILE_CRATE",&giveCrateKillstreak,&huntedCrateLandOverride );
	supplydrop::registerCrateType("hunted", "killstreak", "planemortar", 4, &"KILLSTREAK_PLANE_MORTAR_CRATE",&giveCrateKillstreak,&huntedCrateLandOverride );
	supplydrop::registerCrateType("hunted", "killstreak", "rcbomb", 4, &"KILLSTREAK_RCBOMB_CRATE",&giveCrateKillstreak,&huntedCrateLandOverride );
	supplydrop::registerCrateType("hunted", "killstreak", "radardirection", 2, &"KILLSTREAK_SATELLITE_CRATE",,&giveCrateKillstreak,&huntedCrateLandOverride );
	supplydrop::registerCrateType("hunted", "killstreak", "inventory_ai_tank_drop", 1, &"KILLSTREAK_AI_TANK_CRATE",&giveCrateKillstreak,&huntedCrateLandOverride );
*/

	supplydrop::setCategoryTypeWeight( "hunted", "weapon", 4 );
	supplydrop::setCategoryTypeWeight( "hunted", "killstreak", 1 );

	
	supplydrop::advancedFinalizeCrateCategory( "hunted" );
}

function giveHuntedWeapon( weapon )
{
	if ( isdefined( self.primaryWeapon ) )
	{
		self TakeWeapon(self.primaryWeapon);
	}
	
	self.primaryWeapon = weapon;
	self GiveWeapon(weapon);
	self switchToWeapon(weapon);
	self SetWeaponAmmoStock( Weapon, 0 );
}

function giveHuntedLethalGrenade( weapon )
{
	if ( self.lethalGrenade == weapon )
	{
			currStock = self GetAmmoCount( weapon );
			
			self setweaponammostock( weapon, currStock + 1 );
			return;
	}
	
	if ( isdefined( self.lethalGrenade ) )
	{
		self takeweapon(self.lethalGrenade);
	}

	self.lethalGrenade = weapon;
	self GiveWeapon(weapon);
	self setOffhandPrimaryClass( weapon );
}

function giveHuntedTacticalGrenade( weapon )
{
	if ( self.tacticalGrenade == weapon )
	{
			currStock = self GetAmmoCount( weapon );
			
			self setweaponammostock( weapon, currStock + 1 );
			return;
	}
	
	if ( isdefined( self.tacticalGrenade ) )
	{
		self takeweapon(self.tacticalGrenade);
	}

	self.tacticalGrenade = weapon;
	self GiveWeapon(weapon);
	self setOffhandSecondaryClass( weapon );
}

function huntedCrateLandOverride( crate, category, owner, team )
{
	crate.visibleToAll = true;
	crate supplydrop::crateActivate();

	crate thread supplydrop::crateUseThink();
	crate thread supplydrop::crateUseThinkOwner();
		
	supplydrop::default_land_function( crate, category, owner, team );
}

function getCrateDropOrigin()
{
	node = undefined;
	time = 10000;
	
	while ( !isdefined(node) )
	{
		random_index = RandomInt( level.dropNodes.size );
		
		if ( !isdefined(level.dropNodes[random_index]) )
			continue;
			
		node_origin = level.dropNodes[random_index].origin;
		
		if ( !bulletTracePassed( node_origin + (0,0,1000), node_origin, false, undefined ) )
		{
			level.dropNodes[random_index] = undefined;
//			debugstar(  node_origin, time, ( 1, 0, 0 ) );
			continue;
		}
		
		node = level.dropNodes[random_index];
		break;
	}
	
	return node.origin;
}

function crateDropper()
{
	wait_time = level.heliTime;
	time = 10000;
	while (1)
	{
		wait( wait_time );
		origin = getCrateDropOrigin();
//		debugstar(  origin, time, ( 1, 0, 1 ) );
		self thread supplydrop::heliDeliverCrate( origin, "hunted", level.heliOwner, "free", 0, 0 );
	}
}