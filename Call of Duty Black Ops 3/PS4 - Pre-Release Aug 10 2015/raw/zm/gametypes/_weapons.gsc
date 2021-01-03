#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\bb_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_shellshock;
#using scripts\zm\gametypes\_weapon_utils;
#using scripts\zm\gametypes\_weaponobjects;

#using scripts\zm\_bb;
#using scripts\zm\_challenges;
#using scripts\zm\_sticky_grenade;
#using scripts\zm\_util;
#using scripts\zm\_zm_pers_upgrades_functions;

#namespace weapons;

#precache( "material", "hud_scavenger_pickup" );

function init()
{
	// assigns weapons with stat numbers from 0-99
	// attachments are now shown here, they are per weapon settings instead
	

	//TODO - add to statstable so its a regular weapon?
	
	level.missileEntities = [];
	level.hackerToolTargets = [];

//	thread _flashgrenades::main();
//	thread _empgrenade::init();
//	thread entityheadicons::init();

	if ( !isdefined(level.grenadeLauncherDudTime) )
		level.grenadeLauncherDudTime = 0;

	if ( !isdefined(level.thrownGrenadeDudTime) )
		level.thrownGrenadeDudTime = 0;
		
	level thread onPlayerConnect();
	
//	_smokegrenade::init();
//	_heatseekingmissile::init();
//	_acousticsensor::init();
//	_sensor_grenade::init();
	//_tacticalinsertion::init();
//	_scrambler::init();
//	_explosive_bolt::init();
	if (  level._uses_sticky_grenades )
	{
		_sticky_grenade::init();
	}
//	_proximity_grenade::init();
//	_bouncingbetty::init();
//	_trophy_system::init();
//	_ballistic_knife::init();
//	_satchel_charge::init();
//	_riotshield::init();
//	_hacker_tool::init();
}

function onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player.usedWeapons = false;
		player.lastFireTime = 0;
		player.hits = 0;
		player scavenger_hud_create();

		player thread onPlayerSpawned();
	}
}

function onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		self.concussionEndTime = 0;
		self.hasDoneCombat = false;
		self.shieldDamageBlocked = 0;
		self thread watchWeaponUsage();
		self thread watchGrenadeUsage();
		self thread watchMissileUsage();
		self thread watchWeaponChange();
		self thread watchRiotShieldUse();

		self thread trackWeapon();

		self.droppedDeathWeapon = undefined;
		self.tookWeaponFrom = [];
		self.pickedUpWeaponKills = [];
		
		self thread updateStowedWeapon();
	}
}

function watchWeaponChange()
{
	self endon("death");
	self endon("disconnect");
	
	self.lastDroppableWeapon = self GetCurrentWeapon();

	while(1)
	{
		previous_weapon = self GetCurrentWeapon();
		self waittill( "weapon_change", newWeapon );
		
		if ( mayDropWeapon( newWeapon ) )
		{
			self.lastDroppableWeapon = newWeapon;
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchRiotShieldUse() // self == player
{
	/*self endon( "death" );
	self endon( "disconnect" );

	// watcher for attaching the model to correct player bones
	self thread _riotshield::trackRiotShield();

	for ( ;; )
	{
		self waittill( "raise_riotshield" );
		self thread _riotshield::startRiotshieldDeploy();
	}*/
}

function updateLastHeldWeaponTimings( newTime )
{
	if ( isdefined( self.currentWeapon ) && isdefined( self.currentWeaponStartTime ) )
	{
		totalTime = int ( ( newTime - self.currentWeaponStartTime ) / 1000 );
		if ( totalTime > 0 )
		{
			self AddWeaponStat( self.currentWeapon, "timeUsed", totalTime );
			self.currentWeaponStartTime = newTime;
		}
	}
}

function updateWeaponTimings( newTime )
{
	if ( self util::is_bot() )
	{
		return;
	}

	updateLastHeldWeaponTimings( newTime );
	
	if ( !isdefined( self.staticWeaponsStartTime ) )
	{
		return;
	}
	
	totalTime = int ( ( newTime - self.staticWeaponsStartTime ) / 1000 );
	
	if ( totalTime < 0 )
	{
		return;
	}
	
	self.staticWeaponsStartTime = newTime;
	
		
	// Record grenades and equipment 
	if( isdefined( self.weapon_array_grenade ) )
	{
		for( i=0; i<self.weapon_array_grenade.size; i++ )
		{
			self AddWeaponStat( self.weapon_array_grenade[i], "timeUsed", totalTime );
		}
	}
	if( isdefined( self.weapon_array_inventory ) )
	{
		for( i=0; i<self.weapon_array_inventory.size; i++ )
		{
			self AddWeaponStat( self.weapon_array_inventory[i], "timeUsed", totalTime );
		}
	}

	// Record killstreaks
	if( isdefined( self.killstreak ) )
	{
		for( i=0; i<self.killstreak.size; i++ )
		{
			killstreakWeapon = level.menuReferenceForKillStreak[ self.killstreak[i] ];
			if ( isdefined( killstreakWeapon ) )
			{
				self AddWeaponStat( killstreakWeapon, "timeUsed", totalTime );
			}
		}
	}

	// Record all of the equipped perks
	if ( level.rankedmatch && level.perksEnabled  )
	{
		perksIndexArray = [];

		specialtys = self.specialty;
		
		if ( !isdefined( specialtys ) )
		{
			return;
		}

		if ( !isdefined( self.curClass ) )
		{
			return;
		}
		
		if ( isdefined( self.class_num ) )
		{
			for ( numSpecialties = 0; numSpecialties < level.maxSpecialties; numSpecialties++ )
			{
				perk = self GetLoadoutItem( self.class_num, "specialty" + ( numSpecialties + 1 ) );
				if ( perk != 0 )
				{
					perksIndexArray[ perk ] = true;
				}
			}
			
			perkIndexArrayKeys = getarraykeys( perksIndexArray );
			for ( i = 0; i < perkIndexArrayKeys.size; i ++ )
			{
				if ( perksIndexArray[ perkIndexArrayKeys[i] ] == true )
				{
					self AddDStat( "itemStats", perkIndexArrayKeys[i], "stats", "timeUsed", "statValue", totalTime );
				}
			}
		}
	}
}

function trackWeapon()
{
	currentWeapon = self getCurrentWeapon();
	currentTime = getTime();
	spawnid = getplayerspawnid( self );

	while(1)
	{
		event = self util::waittill_any_return( "weapon_change", "death", "disconnect" );
		newTime = getTime();

		if( event == "weapon_change" )
		{
			self bb::commit_weapon_data( spawnid, currentWeapon, currentTime );

			newWeapon = self getCurrentWeapon();
			if( newWeapon != level.weaponNone && newWeapon != currentWeapon )
			{
				updateLastHeldWeaponTimings( newTime );
				//self _class::initWeaponAttachments( newWeapon );
				
				currentWeapon = newWeapon;
				currentTime = newTime;
			}
		}
		else
		{
			if( event != "disconnect" )
			{
				self bb::commit_weapon_data( spawnid, currentWeapon, currentTime );
				updateWeaponTimings( newTime );
			}
			
			return;
		}
	}
}

function mayDropWeapon( weapon )
{
	if ( level.disableWeaponDrop == 1 )
		return false;
		
	if ( weapon == level.weaponNone )
		return false;

	if ( !weapon.isPrimary )
		return false;
	
	return true;
}

function dropWeaponForDeath( attacker )
{
	if ( level.disableWeaponDrop == 1 )
		return;
	
	weapon = self.lastDroppableWeapon;
	
	if ( isdefined( self.droppedDeathWeapon ) )
		return;
	
	if ( !isdefined( weapon ) )
	{
		/#
		if ( GetDvarString( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: not defined" );
		#/
		return;
	}

	if ( weapon == level.weaponNone )
	{
		/#
		if ( GetDvarString( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: weapon == none" );
		#/
		return;
	}
	
	if ( !self hasWeapon( weapon ) )
	{
		/#
		if ( GetDvarString( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: don't have it anymore (" + weapon.name + ")" );
		#/
		return;
	}

	if ( !(self AnyAmmoForWeaponModes( weapon )) )
	{
		/#
		if ( GetDvarString( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: no ammo for weapon modes" );
		#/
		return;
	}
	
	if ( !shouldDropLimitedWeapon( weapon, self ) )
	{
		return;
	}

	clipAmmo = self GetWeaponAmmoClip( weapon );
	stockAmmo = self GetWeaponAmmoStock( weapon );
	clip_and_stock_ammo = clipAmmo + stockAmmo;

	//Check if the weapon has ammo
	if( !clip_and_stock_ammo )
	{
		/#
		if ( GetDvarString( "scr_dropdebug") == "1" )
			println( "didn't drop weapon: no ammo" );
		#/
		return;
	}

	stockMax = weapon.maxAmmo;
	if ( stockAmmo > stockMax )
		stockAmmo = stockMax;

	item = self dropItem( weapon );
	
	if ( !isdefined( item ) )
	{
		/# iprintlnbold( "dropItem: was not able to drop weapon " + weapon.name ); #/
		return;
	}
	
	/#
	if ( GetDvarString( "scr_dropdebug") == "1" )
		println( "dropped weapon: " + weapon.name );
	#/

	dropLimitedWeapon( weapon, self, item );
	
	self.droppedDeathWeapon = true;

	item ItemWeaponSetAmmo( clipAmmo, stockAmmo );

	item.owner = self;
	item.ownersattacker = attacker;
	
	item thread watchPickup();
	
	item thread deletePickupAfterAWhile();
}

function deletePickupAfterAWhile()
{
	self endon("death");
	
	wait 60;

	if ( !isdefined( self ) )
		return;

	self delete();
}

function watchPickup()
{
	self endon("death");
	
	weapon = self.item;
	
	while(1)
	{
		self waittill( "trigger", player, droppedItem );
		
		if ( isdefined( droppedItem ) )
			break;
		// otherwise, player merely acquired ammo and didn't pick this up
	}
	
	/#
	if ( GetDvarString( "scr_dropdebug") == "1" )
		println( "picked up weapon: " + weapon.name + ", " + isdefined( self.ownersattacker ) );
	#/

	assert( isdefined( player.tookWeaponFrom ) );
	assert( isdefined( player.pickedUpWeaponKills ) );
	
	if ( isdefined( droppedItem ) )
	{
		for ( i = 0; i < droppedItem.size; i++ )
		{
			if ( !IsDefined( droppedItem[i] ) )
			{
				continue;
			}

			// make sure the owner information on the dropped item is preserved
			droppedWeapon = droppedItem[i].item;
			if ( isdefined( player.tookWeaponFrom[ droppedWeapon ] ) )
			{
				droppedItem[i].owner = player.tookWeaponFrom[ droppedWeapon ];
				droppedItem[i].ownersattacker = player;
				player.tookWeaponFrom[ droppedWeapon ] = undefined;
			}
			droppedItem[i] thread watchPickup();
		}
	}
	
	// take owner information from self and put it onto player
	if ( isdefined( self.ownersattacker ) && self.ownersattacker == player )
	{
		player.tookWeaponFrom[ weapon ] = self.owner;
		player.pickedUpWeaponKills[ weapon ] = 0;
	}
	else
	{
		player.tookWeaponFrom[ weapon ] = undefined;
		player.pickedUpWeaponKills[ weapon ] = undefined;
	}
}

function watchWeaponUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );
	
	// need to know if we used a killstreak weapon
	self.usedKillstreakWeapon = [];
	self.usedKillstreakWeapon["minigun"] = false;
	self.usedKillstreakWeapon["m32"] = false;
	self.usedKillstreakWeapon["m202_flash"] = false;
	self.usedKillstreakWeapon["m220_tow"] = false;
	self.usedKillstreakWeapon["mp40_blinged"] = false;
	self.killstreakType = [];
	self.killstreakType["minigun"] = "minigun";
	self.killstreakType["m32"] = "m32";
	self.killstreakType["m202_flash"] = "m202_flash";
	self.killstreakType["m220_tow"] = "m220_tow";
	self.killstreakType["mp40_blinged"] = "mp40_blinged_drop";
	
	for ( ;; )
	{	
		self waittill ( "weapon_fired", curWeapon );
		self.lastFireTime = GetTime();

		self.hasDoneCombat = true;
		
		switch ( curWeapon.weapClass )
		{
			case "rifle":
			case "pistol":
			case "mg":
			case "smg":
			case "spread":
				self trackWeaponFire( curWeapon );
				level.globalShotsFired++;
				break;
			case "rocketlauncher":
			case "grenade":
				self AddWeaponStat( curWeapon, "shots", 1 );
				break;
			default:
				break;
		}

		/*if(  _killstreak_weapons::isHeldKillstreakWeapon( curWeapon ) )
		{
			self.pers["held_killstreak_ammo_count"][curWeapon]--;
			self.usedKillstreakWeapon[ curWeapon.name ] = true;

		}*/
	}
}


function trackWeaponFire( curWeapon )
{
	shotsFired = 1;

	if ( isdefined( self.lastStandParams ) && self.lastStandParams.lastStandStartTime == getTime() )
	{
		self.hits = 0;
		return;
	}
	
	pixbeginevent("trackWeaponFire");

	// Player "sniper" persistent ability tracking
	if( ( isdefined( level.pers_upgrade_sniper ) && level.pers_upgrade_sniper ) )
	{
		zm_pers_upgrades_functions::pers_sniper_player_fires( curWeapon, self.hits );
	}

	self AddWeaponStat( curWeapon, "shots", shotsFired );
	self AddWeaponStat( curWeapon, "hits", self.hits );
	

	// recording zombie bullets
	if ( isdefined( level.add_client_stat ) )
	{ 
		self [[level.add_client_stat]]( "total_shots", shotsFired );
		self [[level.add_client_stat]]( "hits", self.hits );
	}
	else
	{
		self AddPlayerStat( "total_shots", shotsFired );		
		self AddPlayerStat( "hits", self.hits );
		self AddPlayerStat( "misses", int( max( 0, shotsFired - self.hits ) ) );
	}

	self IncrementPlayerStat( "total_shots", shotsFired );		
	self IncrementPlayerStat( "hits", self.hits );
	self IncrementPlayerStat( "misses", int( max( 0, shotsFired - self.hits ) ) );

	self bb::add_to_stat( "shots", shotsFired );
	self bb::add_to_stat( "hits", self.hits );

	//println("hit:" + self.hits + "total_shots:" + shotsFired);

	self.hits = 0;
	pixendevent();
}

function watchGrenadeUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self.throwingGrenade = false;
	self.gotPullbackNotify = false;
		
	self thread beginOtherGrenadeTracking();
	
	self thread watchForThrowbacks();
	self thread watchForGrenadeDuds();
	self thread watchForGrenadeLauncherDuds();

	for ( ;; )
	{
		self waittill ( "grenade_pullback", weapon );
		
		self AddWeaponStat( weapon, "shots", 1 );

		self.hasDoneCombat = true;

		self.throwingGrenade = true;
		self.gotPullbackNotify = true;
		
		if ( weapon.drawOffhandModelInHand )
		{
			self SetOffhandVisible( true );
			self thread watch_offhand_end();
		}

		self thread beginGrenadeTracking();
	}
}

function watchMissileUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	for ( ;; )
	{	
		self waittill ( "missile_fire", missile, weapon );

		self.hasDoneCombat = true;

		/#assert( isdefined( missile ));#/
		level.missileEntities[ level.missileEntities.size ] = missile;
		missile.weapon = weapon;
		missile thread watchMissileDeath();
	}
}

function watchMissileDeath() // self == missile
{
	self waittill( "death" );
	ArrayRemoveValue( level.missileEntities, self ); 
}

function dropWeaponsToGround( origin, radius )
{
	weapons = GetDroppedWeapons();
	for ( i = 0 ; i < weapons.size ; i++ )
	{
		if ( DistanceSquared( origin, weapons[i].origin ) < radius * radius )
		{
			trace = bullettrace( weapons[i].origin, weapons[i].origin + (0,0,-2000), false, weapons[i] );
			weapons[i].origin = trace["position"];
		}
	}
}

function dropGrenadesToGround( origin, radius )
{
	grenades = getentarray( "grenade", "classname" );
	for( i = 0 ; i < grenades.size ; i++ )
	{
		if( DistanceSquared( origin, grenades[i].origin )< radius * radius )
		{
			grenades[i] launch( (5,5,5) );
		}
	}
}

function watchGrenadeCancel()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "grenade_fire" );
	
	waittillframeend;
	weapon = level.weaponNone;
	
	while( self IsThrowingGrenade() && weapon == level.weaponNone ) 
	{
		self waittill( "weapon_change", weapon );
	}
	
	self.throwingGrenade = false;
	self.gotPullbackNotify = false;
}


function watch_offhand_end() // self == player
{
	self notify( "watchOffhandEnd" );
	self endon( "watchOffhandEnd" );

	while ( self is_using_offhand_equipment() )
	{
		msg = self util::waittill_any_return( "death", "disconnect", "grenade_fire", "weapon_change" );

		if (( msg == "death" ) || ( msg == "disconnect" ))
		{
			break;
		}
	}
	
	self SetOffhandVisible( false );
}

function is_using_offhand_equipment() // self == player
{
	if ( self IsUsingOffhand() )
	{
		weapon = self GetCurrentOffhand();
		if ( weapon.isEquipment )
		{
			return true;
		}
	}

	return false;
}


function beginGrenadeTracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	startTime = getTime();
	
	self thread watchGrenadeCancel();
	
	self waittill ( "grenade_fire", grenade, weapon );

	/#assert( isdefined( grenade ));#/
	level.missileEntities[ level.missileEntities.size ] = grenade;
	grenade.weapon = weapon;
	grenade thread watchMissileDeath();

	if ( grenade util::isHacked() )
	{
		return;
	}
	
	// Removed a blackbox print for "mpequipmentuses" from here

	if ( (getTime() - startTime > 1000) )
		grenade.isCooked = true;
	
	switch( weapon.name )
	{
	case "frag_grenade":
	case "sticky_grenade":
		self AddWeaponStat( weapon, "used", 1 );
		// fall through on purpose
	case "explosive_bolt":
		grenade.originalOwner = self;
		break;
	}
	self.throwingGrenade = false;
}

function beginOtherGrenadeTracking()
{
/*	self notify( "grenadeTrackingStart" );
	
	self endon( "grenadeTrackingStart" );
	self endon( "disconnect" );
	for (;;)
	{
		self waittill ( "grenade_fire", grenade, weapon );

		if ( grenade util::isHacked() )
		{
			continue;
		}
		
		switch( weapon.name )
		{
		case "flash_grenade":
			break;
		case "concussion_grenade":
			break;
	//	case "willy_pete":
			grenade thread _smokegrenade::watchSmokeGrenadeDetonation( self );
			break;
		case "tabun_gas":
			grenade thread _tabun::watchTabunGrenadeDetonation( self );
			break;
		case "sticky_grenade":
			grenade thread checkStuckToPlayer( true, true, weapon );
			break;
		case "satchel_charge":
		case "c4":
			grenade thread checkStuckToPlayer( true, false, weapon );
			break;
	//	case "proximity_grenade":
	//		grenade thread _proximity_grenade::watchProximityGrenadeHitPlayer( self );
	//		break;
	//	case "tactical_insertion":
	//		grenade thread _tacticalinsertion::watch( self );
	//		break;
	//	case "scrambler":
	//		break;
	//	case "explosive_bolt":
	//		grenade thread _explosive_bolt::watch_bolt_detonation( self );
	//		grenade thread checkStuckToPlayer( true, false, weapon );
	//		break;
	//	case "hatchet":
	//		grenade.lastWeaponBeforeToss = self util::getLastWeapon();
	//		grenade thread checkHatchetBounce();
	//		grenade thread checkStuckToPlayer( false, false, weapon );
	//		self AddWeaponStat( weapon, "used", 1 );
	//		break;
		}
	}*/
}

function checkStuckToPlayer( deleteOnTeamChange, awardScoreEvent, weapon )
{
	self endon( "death" );

	self waittill( "stuck_to_player", player );
	if ( isdefined ( player ) )
	{
		if ( deleteOnTeamChange )
			self thread stuckToPlayerTeamChange( player );

		if ( awardScoreEvent && isdefined ( self.originalOwner ) )
		{
			if ( self.originalOwner util::IsEnemyPlayer( player ) )
			{
			}
		}

		self.stuckToPlayer = player;
	}
}

function checkHatchetBounce()
{
	self endon( "stuck_to_player" );
	self endon( "death");
	self waittill( "grenade_bounce" );
	self.bounced = true;
}

function stuckToPlayerTeamChange( player )
{
	self endon("death");
	player endon("disconnect");
	originalTeam = player.pers["team"];

	while(1)
	{
		player waittill("joined_team");
		
		if ( player.pers["team"] != originalTeam )
		{
			self detonate();
			return;
		}
	}
}

function watchForThrowbacks()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	for ( ;; )
	{
		self waittill ( "grenade_fire", grenade, weapon );
		if ( self.gotPullbackNotify )
		{
			self.gotPullbackNotify = false;
			continue;
		}
		if ( !isSubStr( weapon.name, "frag_" ) )
			continue;
		
		// no grenade_pullback notify! we must have picked it up off the ground.
		grenade.threwBack = true;
		
		grenade.originalOwner = self;
	}
}

function registerGrenadeLauncherDudDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_grenadeLauncherDudTime");
	if ( GetDvarString( dvarString ) == "" )
		SetDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		SetDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		SetDvar( dvarString, minValue );
		
	level.grenadeLauncherDudTimeDvar = dvarString;	
	level.grenadeLauncherDudTimeMin = minValue;
	level.grenadeLauncherDudTimeMax = maxValue;
	level.grenadeLauncherDudTime = getDvarInt( level.grenadeLauncherDudTimeDvar );
}

function registerThrownGrenadeDudDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_thrownGrenadeDudTime");
	if ( GetDvarString( dvarString ) == "" )
		SetDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		SetDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		SetDvar( dvarString, minValue );
		
	level.thrownGrenadeDudTimeDvar = dvarString;	
	level.thrownGrenadeDudTimeMin = minValue;
	level.thrownGrenadeDudTimeMax = maxValue;
	level.thrownGrenadeDudTime = getDvarInt( level.thrownGrenadeDudTimeDvar );
}

function registerKillstreakDelay( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_killstreakDelayTime");
	if ( GetDvarString( dvarString ) == "" )
		SetDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		SetDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		SetDvar( dvarString, minValue );

	level.killstreakRoundDelay = getDvarInt( dvarString );
}

function turnGrenadeIntoADud( weapon, isThrownGrenade, player )
{
	if ( level.roundStartExplosiveDelay >= (globallogic_utils::getTimePassed() / 1000) )
	{
		if ( weapon.disallowatmatchstart || WeaponHasAttachment( weapon, "gl" ) )
		{
			timeLeft = Int( level.roundStartExplosiveDelay - (globallogic_utils::getTimePassed() / 1000) );

			if ( !timeLeft )
				timeLeft = 1;
			
			// these prints need to be changed to the correct location and they should include the weapon name
			if ( isThrownGrenade )
				player iPrintLnBold( &"MP_GRENADE_UNAVAILABLE_FOR_N", " " + timeLeft + " ", &"EXE_SECONDS" );
			else			
				player iPrintLnBold( &"MP_LAUNCHER_UNAVAILABLE_FOR_N", " " + timeLeft + " ", &"EXE_SECONDS" );


			self makeGrenadeDud();
		}
	}
}

function watchForGrenadeDuds()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );
	
	while(1)
	{
		self waittill( "grenade_fire", grenade, weapon );
		grenade turnGrenadeIntoADud( weapon, true, self );
	}
}

function watchForGrenadeLauncherDuds()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );
	
	while(1)
	{
		self waittill( "grenade_launcher_fire", grenade, weapon );
		grenade turnGrenadeIntoADud( weapon, false, self );

		/#assert( isDefined( grenade ));#/
		level.missileEntities[ level.missileEntities.size ] = grenade;
		grenade.weapon = weapon;
		grenade thread watchMissileDeath();
	}
}


// these functions are used with scripted weapons (like satchels, shoeboxs, artillery)
// returns an array of objects representing damageable entities (including players) within a given sphere.
// each object has the property damageCenter, which represents its center (the location from which it can be damaged).
// each object also has the property entity, which contains the entity that it represents.
// to damage it, call damageEnt() on it.
function getDamageableEnts(pos, radius, doLOS, startRadius)
{
	ents = [];
	
	if (!isdefined(doLOS))
		doLOS = false;
		
	if ( !isdefined( startRadius ) )
		startRadius = 0;
	
	// players
	players = level.players;
	for (i = 0; i < players.size; i++)
	{
		if (!isalive(players[i]) || players[i].sessionstate != "playing")
			continue;
		
		playerpos = players[i].origin + (0,0,32);
		distsq = distancesquared(pos, playerpos);
		if (distsq < radius*radius && (!doLOS || weaponDamageTracePassed(pos, playerpos, startRadius, undefined)))
		{
			newent = spawnstruct();
			newent.isPlayer = true;
			newent.isADestructable = false;
			newent.isADestructible = false;
			newent.isActor = false;
			newent.entity = players[i];
			newent.damageCenter = playerpos;
			ents[ents.size] = newent;
		}
	}
	
	// grenades
	grenades = getentarray("grenade", "classname");
	for (i = 0; i < grenades.size; i++)
	{
		entpos = grenades[i].origin;
		distsq = distancesquared(pos, entpos);
		if (distsq < radius*radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, grenades[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.isADestructible = false;
			newent.isActor = false;
			newent.entity = grenades[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}
	
	// THIS IS NOT THE SAME AS THE destruct-A-bles BELOW
	destructibles = getentarray("destructible", "targetname");		
	for (i = 0; i < destructibles.size; i++)
	{
		entpos = destructibles[i].origin;
		distsq = distancesquared(pos, entpos);
		if (distsq < radius*radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, destructibles[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.isADestructible = true;
			newent.isActor = false;
			newent.entity = destructibles[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}

	// THIS IS NOT THE SAME AS THE destruct-I-bles ABOVE
	destructables = getentarray("destructable", "targetname");
	for (i = 0; i < destructables.size; i++)
	{
		entpos = destructables[i].origin;
		distsq = distancesquared(pos, entpos);
		if (distsq < radius*radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, destructables[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = true;
			newent.isADestructible = false;
			newent.isActor = false;
			newent.entity = destructables[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}

	/*dogs = _dogs::dog_manager_get_dogs();
	
	foreach( dog in dogs )
	{
		if ( !IsAlive( dog ) )
		{
			continue;
		}

		entpos = dog.origin;
		distsq = distancesquared(pos, entpos);
		if (distsq < radius*radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, dog)))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.isADestructible = false;
			newent.isActor = true;
			newent.entity = dog;
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}*/
	
	return ents;
}

// eInflictor = the entity that causes the damage (e.g. a shoebox)
// eAttacker = the player that is attacking
// iDamage = the amount of damage to do
// sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
// weapon = the weapon used
// damagepos = the position damage is coming from
// damagedir = the direction damage is moving in
function damageEnt(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, damagepos, damagedir)
{
	if (self.isPlayer)
	{
		self.damageOrigin = damagepos;
		self.entity thread [[level.callbackPlayerDamage]](
			eInflictor, // eInflictor The entity that causes the damage.(e.g. a turret)
			eAttacker, // eAttacker The entity that is attacking.
			iDamage, // iDamage Integer specifying the amount of damage done
			0, // iDFlags Integer specifying flags that are to be applied to the damage
			sMeansOfDeath, // sMeansOfDeath Integer specifying the method of death
			weapon, // weapon The weapon used to inflict the damage
			damagepos, // vPoint The point the damage is from?
			damagedir, // vDir The direction of the damage
			"none", // sHitLoc The location of the hit
			damagepos, // vDamageOrigin
			0, // psOffsetTime The time offset for the damage
			0, // boneIndex
			(1,0,0) // vSurfaceNormal
		);
	}
	else if (self.isactor)
	{
		self.damageOrigin = damagepos;
		self.entity thread [[level.callbackActorDamage]](
			eInflictor, // eInflictor The entity that causes the damage.(e.g. a turret)
			eAttacker, // eAttacker The entity that is attacking.
			iDamage, // iDamage Integer specifying the amount of damage done
			0, // iDFlags Integer specifying flags that are to be applied to the damage
			sMeansOfDeath, // sMeansOfDeath Integer specifying the method of death
			weapon, // weapon The weapon used to inflict the damage
			damagepos, // vPoint The point the damage is from?
			damagedir, // vDir The direction of the damage
			"none", // sHitLoc The location of the hit
			damagepos, // vDamageOrigin
			0, // psOffsetTime The time offset for the damage
			0, // boneIndex
			0, // surfaceType
			(1,0,0) // vSurfaceNormal
		);
	}
	else if (self.isADestructible)
	{
		self.damageOrigin = damagepos;
		self.entity DoDamage(
			iDamage, // iDamage Integer specifying the amount of damage done
			damagepos, // vPoint The point the damage is from?
			eAttacker, // eAttacker The entity that is attacking.
			eInflictor, // eInflictor The entity that causes the damage.(e.g. a turret)
			0, 
			sMeansOfDeath, // sMeansOfDeath Integer specifying the method of death
			0, // iDFlags Integer specifying flags that are to be applied to the damage
			weapon // weapon The weapon used to inflict the damage
		);
	}
	else
	{
		self.entity util::damage_notify_wrapper( iDamage, eAttacker, (0,0,0), (0,0,0), "mod_explosive", "", "" );		
	}
}

function debugline(a, b, color)
{
	/#
	for (i = 0; i < 30*20; i++)
	{
		line(a,b, color);
		wait .05;
	}
	#/
}


function onWeaponDamage( eAttacker, eInflictor, weapon, meansOfDeath, damage )
{
	self endon ( "death" );
	self endon ( "disconnect" );

	switch ( weapon.name )
	{
		case "concussion_grenade":
			// should match weapon settings in gdt
			radius = 512;
			if (self == eAttacker) // TFLAME 8/1/12 - reduce effects on attacker 
				radius *= 0.5;
			
			scale = 1 - (distance( self.origin, eInflictor.origin ) / radius);
			
			if ( scale < 0 )
				scale = 0;
			
			time = 2 + (4 * scale);
			
			{wait(.05);};

			if ( self HasPerk ( "specialty_stunprotection" ) )
			{
				// do a little bit, not a complete negation
				time *= 0.1;
			}
			
			self thread playConcussionSound( time );
			
			if ( self util::mayApplyScreenEffect() ) 
				self shellShock( "concussion_grenade_mp", time, false ); 
			
			self.concussionEndTime = getTime() + (time * 1000); 
			break;

		//case "proximity_grenade":
		//	self proximityGrenadeHitPlayer( eAttacker, eInflictor );
	//		break;
		
		default:
			// shellshock will only be done if meansofdeath is an appropriate type and if there is enough damage.
			if ( isdefined( level.shellshockOnPlayerDamage ) )
			{
				 [[level.shellshockOnPlayerDamage]]( meansOfDeath, damage, weapon );
			}
			break;
	}
}

function playConcussionSound( duration )
{	
	self endon( "death" );
	self endon( "disconnect" );

	concussionSound = spawn ("script_origin",(0,0,1));
	concussionSound.origin = self.origin;
	concussionSound linkTo( self );
	concussionSound thread deleteEntOnOwnerDeath( self );
	concussionSound playsound( "" );
	concussionSound playLoopSound ( "" );
	if ( duration > 0.5 )
		wait( duration - 0.5 );
	concussionSound playsound( "" );
	concussionSound StopLoopSound( .5);
	wait(0.5);

	concussionSound notify ( "delete" );
	concussionSound delete();
}

function deleteEntOnOwnerDeath( owner )
{
	self endon( "delete" );
	owner waittill( "death" );
	self delete();	
}

// weapon stowing logic ===================================================================

// thread loop life = player's life
function updateStowedWeapon()
{
	self endon( "spawned" );
	self endon( "killed_player" );
	self endon( "disconnect" );
	
	//detach_all_weapons();
	
	self.tag_stowed_back = undefined;
	self.tag_stowed_hip = undefined;
	
	team = self.pers["team"];
	curclass = self.pers["class"];
	
	while ( true )
	{
		self waittill( "weapon_change", newWeapon );
		
		// weapon array reset, might have swapped weapons off the ground
		self.weapon_array_primary =[];
		self.weapon_array_sidearm = [];
		self.weapon_array_grenade = [];
		self.weapon_array_inventory =[];
	
		// populate player's weapon stock arrays
		weaponsList = self GetWeaponsList();
		for( idx = 0; idx < weaponsList.size; idx++ )
		{
			// we don't want these in the primary list
			switch( weaponsList[idx] )
			{
			case "minigun":		// death machine
			case "m32":			// grenade launcher
			case "m202_flash":	// grim reaper
			case "m220_tow":		// tv guided missile
			case "mp40_blinged":	// cod5 mp40
			case "zipline":
				continue;

			default:
				break;
			}

			if ( weapons::is_primary_weapon( weaponsList[idx] ) )
				self.weapon_array_primary[self.weapon_array_primary.size] = weaponsList[idx];
			else if ( weapons::is_side_arm( weaponsList[idx] ) )
				self.weapon_array_sidearm[self.weapon_array_sidearm.size] = weaponsList[idx];
			else if ( weapons::is_grenade( weaponsList[idx] ) )
				self.weapon_array_grenade[self.weapon_array_grenade.size] = weaponsList[idx];
			else if ( weapons::is_inventory( weaponsList[idx] ) )
				self.weapon_array_inventory[self.weapon_array_inventory.size] = weaponsList[idx];
			else if ( weaponsList[idx].isPrimary )
				self.weapon_array_primary[self.weapon_array_primary.size] = weaponsList[idx];
		}

		weapons::detach_all_weapons();
		weapons::stow_on_back();
		weapons::stow_on_hip();
	}
}

function loadout_get_class_num()
{
	assert( IsPlayer( self ) );
	assert( isdefined( self.curClass ) );

	if ( isdefined( level.classToClassNum[ self.curClass ] ) )
	{
		return level.classToClassNum[ self.curClass ];
	}

	class_num = int( self.curClass[self.curClass.size-1] )-1;

	//hacky patch to the system since when it was written it was never thought of that there could be 10 custom slots
	if( -1 == class_num )
		class_num = 9;

	return class_num;
}

function loadout_get_offhand_weapon( stat )
{
	if ( isdefined( level.giveCustomLoadout ) )
	{
		return level.weaponNone;
	}

	class_num = self loadout_get_class_num();

	index = 0;//self _class::getLoadoutItemFromDDLStats( class_num, stat );

	if ( isdefined( level.tbl_weaponIDs[index] ) && isdefined( level.tbl_weaponIDs[index]["reference"] ) )
	{
		return GetWeapon( level.tbl_weaponIDs[index]["reference"] );
	}

	return level.weaponNone;
}

function loadout_get_offhand_count( stat )
{
	if ( isdefined( level.giveCustomLoadout ) )
	{
		return 0;
	}

	class_num = self loadout_get_class_num();
	count = 0;//self _class::getLoadoutItemFromDDLStats( class_num, stat );

	return count;
}

function scavenger_think()
{
	self endon( "death" );
	self waittill( "scavenger", player );

	primary_weapons = player GetWeaponsListPrimaries();
	offhand_weapons_and_alts = array::exclude( player GetWeaponsList( true ), primary_weapons );

	ArrayRemoveValue( offhand_weapons_and_alts, level.weaponBaseMelee );

	player playsound( "wpn_ammo_pickup" );
	player playlocalsound( "wpn_ammo_pickup" );
	//player _properks::scavenged();


	player.scavenger_icon.alpha = 1;
	player.scavenger_icon fadeOverTime( 2.5 );
	player.scavenger_icon.alpha = 0;
	scavenger_lethal_proc = 1; // extra bags to pick up before lethal refill
	scavenger_tactical_proc = 1; // extra bags to pick up before tactical refill
	
	if (!isdefined(player.scavenger_lethal_proc))
	{
		player.scavenger_lethal_proc = 0;
		player.scavenger_tactical_proc = 0;
	}

	loadout_primary			= player loadout_get_offhand_weapon( "primarygrenade" );
	loadout_primary_count	= player loadout_get_offhand_count( "primarygrenadecount" );
	loadout_secondary		= player loadout_get_offhand_weapon( "specialgrenade" );
	loadout_secondary_count = player loadout_get_offhand_count( "specialgrenadeCount" );

	for ( i = 0; i < offhand_weapons_and_alts.size; i++ )
	{
		weapon = offhand_weapons_and_alts[i];

		if ( !weapon.isScavengable )
		{
			continue;
		}
		
		switch ( weapon.name )
		{
		case "frag_grenade":
		case "claymore":
		case "sticky_grenade":
		case "satchel_charge":
		case "hatchet":
		case "bouncingbetty":
			if ( isdefined( player.grenadeTypePrimaryCount ) && player.grenadeTypePrimaryCount < 1 ) 
				break; 
			
			if (player GetWeaponAmmoStock( weapon ) != loadout_primary_count)
			{
				if (player.scavenger_lethal_proc < scavenger_lethal_proc )
				{
					player.scavenger_lethal_proc++;
					break;
				}	
				player.scavenger_lethal_proc = 0;
				player.scavenger_tactical_proc = 0; // dont ever refill both grenades at the same time
			}
			// fall through
		case "proximity_grenade":
		case "flash_grenade":
		case "concussion_grenade":
		case "tabun_gas":
		case "nightingale":
		case "emp_grenade":
		case "willy_pete":
		case "trophy_system":
		case "sensor_grenade":
		case "pda_hack":
			if ( isdefined( player.grenadeTypeSecondaryCount ) && player.grenadeTypeSecondaryCount < 1 )
				break;
			
			if (weapon == loadout_secondary && player GetWeaponAmmoStock( weapon ) != loadout_secondary_count)
			{
				if (player.scavenger_tactical_proc < scavenger_tactical_proc )
				{
					player.scavenger_tactical_proc++;
					break;
				}
				player.scavenger_tactical_proc = 0;
				player.scavenger_lethal_proc = 0;  // dont ever refill both grenades at the same time
			}
			
			maxAmmo = weapon.maxAmmo;

			// just give 1 for each scavenger pick up
			stock = player GetWeaponAmmoStock( weapon );

			if ( isdefined( level.customLoadoutScavenge ) )
			{
				maxAmmo = self [[level.customLoadoutScavenge]]( weapon );
			}
			else if ( weapon == loadout_primary )
			{
				maxAmmo = loadout_primary_count;
			}
			else if ( weapon == loadout_secondary )
			{
				maxAmmo = loadout_secondary_count;
			}

			if ( stock < maxAmmo )
			{
				ammo = stock + 1;
				if ( ammo > maxAmmo )
				{
					ammo = maxAmmo;
				}
				player SetWeaponAmmoStock( weapon, ammo );

				player thread challenges::scavengedGrenade();
			}
			break;

		default:
			if ( weapon.isLauncherWeapon )
			{
				stock = player GetWeaponAmmoStock( weapon );
				start = player GetFractionStartAmmo( weapon );
				clip = weapon.clipSize;
				clip *= GetDvarFloat( "scavenger_clip_multiplier", 2 );
				clip = Int( clip );
				maxAmmo = weapon.maxAmmo;

				if ( stock < maxAmmo - clip )
				{
					ammo = stock + clip;
					player SetWeaponAmmoStock( weapon, ammo );
				}
				else
				{
					player SetWeaponAmmoStock( weapon, maxAmmo );
				}
			}
			break;
		}
	}

	for ( i = 0; i < primary_weapons.size; i++ )
	{
		weapon = primary_weapons[i];

		if ( !weapon.isScavengable )
		{
			continue;
		}

		stock = player GetWeaponAmmoStock( weapon );
		start = player GetFractionStartAmmo( weapon );
		clip = weapon.clipSize;
		clip *= GetDvarFloat( "scavenger_clip_multiplier", 2 );
		clip = Int( clip );
		maxAmmo = weapon.maxAmmo;

		if ( stock < maxAmmo - clip )
		{
			ammo = stock + clip;
			player SetWeaponAmmoStock( weapon, ammo );
		}
		else
		{
			player SetWeaponAmmoStock( weapon, maxAmmo );
		}
	}
}

function scavenger_hud_create()
{
	if( level.wagerMatch )
		return;

	self.scavenger_icon = NewClientHudElem( self );
	self.scavenger_icon.horzAlign = "center";
	self.scavenger_icon.vertAlign = "middle";
	self.scavenger_icon.x = -16;
	self.scavenger_icon.y = 16;
	self.scavenger_icon.alpha = 0;

	width = 32;
	height = 16;

	if ( self IsSplitscreen() )
	{
		width = Int( width * 0.5 );
		height = Int( height * 0.5 );
		self.scavenger_icon.x = -8;
	}

	self.scavenger_icon setShader( "hud_scavenger_pickup", width, height );
}

function dropScavengerForDeath( attacker )
{
	if( SessionModeIsZombiesGame() )
		return;
		
	if( level.wagerMatch )
		return;

	if( !isdefined( attacker ) )
 		return;

 	if( attacker == self )
 		return;

	if ( level.gameType == "hack" )
	{
		item = self dropScavengerItem( GetWeapon( "scavenger_item_hack" ) ); 
	}
	else
	{
		item = self dropScavengerItem( GetWeapon( "scavenger_item" ) );
	}
		
	item thread scavenger_think();
}


// if we need to store multiple drop limited weapons, we'll need to store an array on the player entity
function addLimitedWeapon( weapon, owner, num_drops )
{
	limited_info = SpawnStruct();
	limited_info.weapon = weapon;
	limited_info.drops = num_drops;

	owner.limited_info = limited_info;
}

function shouldDropLimitedWeapon( weapon, owner )
{
	limited_info = owner.limited_info;
		
	if ( !isdefined( limited_info ) )
	{
		return true;
	}

	if ( limited_info.weapon != weapon )
	{
		return true;
	}

	if ( limited_info.drops <= 0 )
	{
		return false;
	}

	return true;
}


function dropLimitedWeapon( weapon, owner, item )
{
	limited_info = owner.limited_info;

	if ( !isdefined( limited_info ) )
	{
		return;
	}

	if ( limited_info.weapon != weapon )
	{
		return;
	}

	limited_info.drops = limited_info.drops - 1;
	owner.limited_info = undefined;

	item thread limitedPickup( limited_info );
}


function limitedPickup( limited_info )
{
	self endon( "death" );
	self waittill( "trigger", player, item );

	if ( !isdefined( item ) )
	{
		return;
	}

	player.limited_info = limited_info;
}
