#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\bb_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\loadout_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_chemicalgel;
#using scripts\shared\weapons\_empgrenade;
#using scripts\shared\weapons\_flashgrenades;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_proximity_grenade;
#using scripts\shared\weapons\_sticky_grenade;
#using scripts\shared\weapons\_riotshield;
#using scripts\shared\weapons\_tabun;
#using scripts\shared\weapons\_trophy_system;
#using scripts\shared\weapons\_weapon_utils;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "material", "hud_scavenger_pickup" );

#precache( "fx", "fx/explosions/fx_exp_grenade_flshbng.efx" );

#namespace weapons;
	
function init_shared()
{
	level.weaponNone = GetWeapon( "none" );
	level.weaponNull = GetWeapon( "weapon_null" );
	level.weaponBaseMelee = GetWeapon( "knife" );
	level.weaponBaseMeleeHeld = GetWeapon( "knife_held" );
	level.weaponBallisticKnife = GetWeapon( "knife_ballistic" );
	level.weaponRiotshield = GetWeapon( "riotshield" );
	level.weaponFlashGrenade = GetWeapon( "flash_grenade" );
	level.weaponSatchelCharge = GetWeapon( "satchel_charge" );
	
	level._effect["flashNineBang"] = "_t6/misc/fx_equip_tac_insert_exp";

	callback::on_start_gametype( &init );
}

function init()
{
	// assigns weapons with stat numbers from 0-99
	// attachments are now shown here, they are per weapon settings instead
	

	//TODO - add to statstable so its a regular weapon?
	
	level.missileEntities = [];
	level.hackerToolTargets = [];

	level.missileDudDeleteDelay = GetDvarInt( "scr_missileDudDeleteDelay", 3 ); //Seconds

	if ( !isdefined(level.roundStartExplosiveDelay) )
		level.roundStartExplosiveDelay = 0;

	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
}

function on_player_connect()
{
	self.usedWeapons = false;
	self.lastFireTime = 0;
	self.hits = 0;
	self scavenger_hud_create();
}

function on_player_spawned()
{
	self.concussionEndTime = 0;
	self.scavenged = false;
	self.hasDoneCombat = false;
	self.shieldDamageBlocked = 0;
	self thread watch_usage();
	self thread watch_grenade_usage();
	self thread watch_missile_usage();
	self thread watch_weapon_change();

	self thread track();

	self.droppedDeathWeapon = undefined;
	self.tookWeaponFrom = [];
	self.pickedUpWeaponKills = [];
	
	self thread update_stowed_weapon();
}

function watch_weapon_change()
{
	self endon("death");
	self endon("disconnect");
	
	self.lastDroppableWeapon = self GetCurrentWeapon();

	self.lastWeaponChange = 0;
	while(1)
	{
		previous_weapon = self GetCurrentWeapon();
		self waittill( "weapon_change", newWeapon );
		
		if ( may_drop( newWeapon ) )
		{
			self.lastDroppableWeapon = newWeapon;
			self.lastWeaponChange = getTime();
		}

		if ( DoesWeaponReplaceSpawnWeapon( self.spawnWeapon, newWeapon ) )
		{
			self.spawnWeapon = newWeapon;
			self.pers["spawnWeapon"] = newWeapon;
		}
	}
}


function update_last_held_weapon_timings( newTime )
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

function update_timings( newTime )
{
	if ( self util::is_bot() )
	{
		return;
	}

	update_last_held_weapon_timings( newTime );
	
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
			killstreakType = level.menuReferenceForKillStreak[ self.killstreak[i] ];

			if ( isdefined( killstreakType ) )
			{
				killstreakWeapon = killstreaks::get_killstreak_weapon( killstreakType );
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

function track()
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
				update_last_held_weapon_timings( newTime );
				self loadout::initWeaponAttachments( newWeapon );
				
				currentWeapon = newWeapon;
				currentTime = newTime;
			}
		}
		else
		{
			if( event != "disconnect" && isdefined( self ) )
			{
				self bb::commit_weapon_data( spawnid, currentWeapon, currentTime );
				update_timings( newTime );
			}
			
			return;
		}
	}
}

function may_drop( weapon )
{
	if ( level.disableWeaponDrop == 1 )
		return false;
		
	if ( weapon == level.weaponNone )
		return false;
		
	if ( killstreaks::is_killstreak_weapon( weapon ) )
		return false;
	
	if ( !weapon.isPrimary )
		return false;
	
	return true;
}

function drop_for_death( attacker, sWeapon, sMeansOfDeath )
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
	
	if ( !should_drop_limited_weapon( weapon, self ) )
	{
		return;
	}

	if( weapon.isCarriedKillstreak )
		return;

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

	drop_limited_weapon( weapon, self, item );
	
	self.droppedDeathWeapon = true;

	item ItemWeaponSetAmmo( clipAmmo, stockAmmo );

	item.owner = self;
	item.ownersattacker = attacker;
	item.sWeapon = sWeapon;
	item.sMeansOfDeath = sMeansOfDeath;
	
	item thread watch_pickup();
	
	item thread delete_pickup_after_aWhile();
}

function delete_pickup_after_aWhile()
{
	self endon("death");
	
	wait 60;

	if ( !isdefined( self ) )
		return;

	self delete();
}

function watch_pickup()
{
	self endon("death");
	
	weapon = self.item;
	
	self waittill( "trigger", player, droppedItem );

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
			droppedItem[i] thread watch_pickup();
		}
	}
	
	// take owner information from self and put it onto player
	if ( isdefined( self.ownersattacker ) && self.ownersattacker == player )
	{
		player.tookWeaponFrom[ weapon ] = SpawnStruct();
		
		player.tookWeaponFrom[ weapon ].previousOwner = self.owner;
		player.tookWeaponFrom[ weapon ].sWeapon = self.sWeapon;
		player.tookWeaponFrom[ weapon ].sMeansOfDeath = self.sMeansOfDeath;
	
		player.pickedUpWeaponKills[ weapon ] = 0;
	}
	else
	{
		player.tookWeaponFrom[ weapon ] = undefined;
		player.pickedUpWeaponKills[ weapon ] = undefined;
	}
}

function watch_usage()
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
			case "pistol spread":
			case "mg":
			case "smg":
			case "spread":
				self track_fire( curWeapon );
				level.globalShotsFired++;
				break;
			case "rocketlauncher":
			case "grenade":
				self AddWeaponStat( curWeapon, "shots", 1 );
				break;
			default:
				break;
		}

		if( curWeapon.isCarriedKillstreak )
		{
			if ( IsDefined( self.pers["held_killstreak_ammo_count"][curWeapon] ) )
			{
				self.pers["held_killstreak_ammo_count"][curWeapon]--;
			}
			
			self.usedKillstreakWeapon[ curWeapon.name ] = true;
		}
	}
}



function track_fire( curWeapon )
{
	pixbeginevent("trackWeaponFire");
	
	self TrackWeaponFireNative( curWeapon, 1, self.hits, 1 );
	
	//self AddWeaponStat( curWeapon, "shots", TRACK_WEAPON_SHOT_FIRED );
	//self AddWeaponStat( curWeapon, "hits", self.hits );
	
	//self AddPlayerStat( "total_shots", TRACK_WEAPON_SHOT_FIRED );		
	//self AddPlayerStat( "hits", self.hits );
	//self AddPlayerStat( "misses", int( max( 0, TRACK_WEAPON_SHOT_FIRED - self.hits ) ) );
	
	self bb::add_to_stat( "shots", 1 );
	self bb::add_to_stat( "hits", self.hits );
 	
	if ( ( isdefined( level.mpCustomMatch ) && level.mpCustomMatch ) )
	{
		self.pers["shotsfired"] += 1;
		self.shotsfired = self.pers["shotsfired"];
	
		self.pers["shotshit"] = self.hits;
		self.shotshit = self.pers["shotshit"];
		
		self.pers["shotsmissed"] = self.shotsfired - self.hits;
		self.shotsmissed = self.pers["shotsmissed"];
	}

	pixendevent();
}

function watch_grenade_usage()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self.throwingGrenade = false;
	self.gotPullbackNotify = false;
		
	self thread begin_other_grenade_tracking();
	
	self thread watch_for_throwbacks();
	self thread watch_for_grenade_duds();
	self thread watch_for_grenade_launcher_duds();

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

		self thread begin_grenade_tracking();
	}
}

function watch_missile_usage()
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
		missile thread watch_missile_death();
	}
}

function watch_missile_death() // self == missile
{
	self waittill( "death" );
	ArrayRemoveValue( level.missileEntities, self ); 
}

function drop_all_to_ground( origin, radius )
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

function drop_grenades_to_ground( origin, radius )
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

function watch_grenade_cancel()
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
	
	self notify( "grenade_throw_cancelled" );
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
	
	if ( isdefined( self ) )
	{
		self SetOffhandVisible( false );
	}	
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


function begin_grenade_tracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "grenade_throw_cancelled" );
	
	startTime = getTime();
	
	self thread watch_grenade_cancel();
	
	self waittill ( "grenade_fire", grenade, weapon, cookTime );

	/#assert( isdefined( grenade ));#/
	level.missileEntities[ level.missileEntities.size ] = grenade;
	grenade.weapon = weapon;
	grenade thread watch_missile_death();

	if ( grenade util::isHacked() )
	{
		return;
	}
	
	bbPrint( "mpequipmentuses", "gametime %d spawnid %d weaponname %s", gettime(), getplayerspawnid( self ), weapon.name );

	cookedTime = getTime() - startTime;
	
	if ( cookedTime > 1000 )
	{
		grenade.isCooked = true;
	}
	
	switch ( weapon.rootWeapon.name )
	{
	case "frag_grenade":
		level.globalFragGrenadesFired++;
		// fall through on purpose
	case "sticky_grenade":
		self AddWeaponStat( weapon, "used", 1 );
		grenade SetTeam( self.pers["team"] );
		grenade SetOwner( self );
		// fall through on purpose
	case "explosive_bolt":
		grenade.originalOwner = self;
		break;
	case "satchel_charge":
		level.globalSatchelChargeFired++;
		break;
	}

	self.throwingGrenade = false;
	
	if ( weapon.cookOffHoldTime > 0 )
	{				
		grenade thread track_cooked_detonation( self, weapon, cookTime );
	}	
	else if ( weapon.multiDetonation > 0 )
	{
		grenade thread track_multi_detonation( self, weapon, cookTime );
	}
}

function begin_other_grenade_tracking()
{
	self notify( "grenadeTrackingStart" );
	
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
		case "tabun_gas":
			grenade thread tabun::watchTabunGrenadeDetonation( self );
			break;
		case "sticky_grenade":
			grenade thread check_stuck_to_player( true, true, weapon );
			grenade thread riotshield::check_stuck_to_shield();
			break;
		case "satchel_charge":
		case "c4":
			grenade thread check_stuck_to_player( true, false, weapon );
			break;
		case "hatchet":
			grenade.lastWeaponBeforeToss = self util::getLastWeapon();
			grenade thread check_hatchet_bounce();
			grenade thread check_stuck_to_player( false, false, weapon );
			self AddWeaponStat( weapon, "used", 1 );
			break;
		default:
			break;
		}
	}
}

function check_stuck_to_player( deleteOnTeamChange, awardScoreEvent, weapon )
{
	self endon( "death" );

	self waittill( "stuck_to_player", player );
	if ( isdefined ( player ) )
	{
		if ( deleteOnTeamChange )
			self thread stuck_to_player_team_change( player );

		if ( awardScoreEvent && isdefined ( self.originalOwner ) )
		{
			if ( self.originalOwner util::IsEnemyPlayer( player ) )
			{
				scoreevents::processScoreEvent( "stick_explosive_kill", self.originalOwner, player, weapon );
			}
		}

		self.stuckToPlayer = player;
	}
}

function check_hatchet_bounce()
{
	self endon( "stuck_to_player" );
	self endon( "death");
	self waittill( "grenade_bounce" );
	self.bounced = true;
}

function stuck_to_player_team_change( player )
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

function watch_for_throwbacks()
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

function wait_and_delete_dud( waitTime )
{
	self endon( "death" );

	wait( waitTime );

	if( isDefined( self ) )
		self delete();
}

function turn_grenade_into_a_dud( weapon, isThrownGrenade, player )
{
	if ( level.roundStartExplosiveDelay >= ([[level.getTimePassed]]() / 1000) )
	{
		if ( weapon.disallowatmatchstart || WeaponHasAttachment( weapon, "gl" ) )
		{
			timeLeft = Int( level.roundStartExplosiveDelay - ([[level.getTimePassed]]() / 1000) );

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

function watch_for_grenade_duds()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );
	
	while ( 1 )
	{
		self waittill( "grenade_fire", grenade, weapon );
		
		grenade turn_grenade_into_a_dud( weapon, true, self );
	}
}

function watch_for_grenade_launcher_duds()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );
	
	while ( 1 )
	{
		self waittill( "grenade_launcher_fire", grenade, weapon );
		grenade turn_grenade_into_a_dud( weapon, false, self );

		/#assert( isDefined( grenade ));#/
		level.missileEntities[ level.missileEntities.size ] = grenade;
		grenade.weapon = weapon;
		grenade thread watch_missile_death();
	}
}


// these functions are used with scripted weapons (like satchels, shoeboxs, artillery)
// returns an array of objects representing damageable entities (including players) within a given sphere.
// each object has the property damageCenter, which represents its center (the location from which it can be damaged).
// each object also has the property entity, which contains the entity that it represents.
// to damage it, call damageEnt() on it.
function get_damageable_ents(pos, radius, doLOS, startRadius)
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
		if (distsq < radius*radius && (!doLOS || damage_trace_passed(pos, playerpos, startRadius, undefined)))
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
		if (distsq < radius*radius && (!doLOS || damage_trace_passed(pos, entpos, startRadius, grenades[i])))
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
		if (distsq < radius*radius && (!doLOS || damage_trace_passed(pos, entpos, startRadius, destructibles[i])))
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
		if (distsq < radius*radius && (!doLOS || damage_trace_passed(pos, entpos, startRadius, destructables[i])))
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

	dogs = [[level.dogManagerOnGetDogs]]();
	
	if ( isdefined( dogs ) )
	{
		foreach( dog in dogs )
		{
			if ( !IsAlive( dog ) )
			{
				continue;
			}

			entpos = dog.origin;
			distsq = distancesquared(pos, entpos);
			if (distsq < radius*radius && (!doLOS || damage_trace_passed(pos, entpos, startRadius, dog)))
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
		}
	}
	
	return ents;
}

function damage_trace_passed(from, to, startRadius, ignore)
{
	trace = damage_trace(from, to, startRadius, ignore);	
	return (trace["fraction"] == 1);
}

function damage_trace(from, to, startRadius, ignore)
{
	midpos = undefined;
	
	diff = to - from;
	if ( lengthsquared( diff ) < startRadius*startRadius )
		midpos = to;
	dir = vectornormalize( diff );
	midpos = from + (dir[0]*startRadius, dir[1]*startRadius, dir[2]*startRadius);

	trace = bullettrace(midpos, to, false, ignore);
	
	if ( GetDvarint( "scr_damage_debug") != 0 )
	{
		if (trace["fraction"] == 1)
		{
			thread debugline(midpos, to, (1,1,1));
		}
		else
		{
			thread debugline(midpos, trace["position"], (1,.9,.8));
			thread debugline(trace["position"], to, (1,.4,.3));
		}
	}
	
	return trace;
}

// eInflictor = the entity that causes the damage (e.g. a shoebox)
// eAttacker = the player that is attacking
// iDamage = the amount of damage to do
// sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
// weapon = the weapon used
// damagepos = the position damage is coming from
// damagedir = the direction damage is moving in
function damage_ent(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, damagepos, damagedir)
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
			damagepos, // sDamageOrigin
			0, // psOffsetTime The time offset for the damage
			0, // boneIndex
			undefined // surfaceNormal
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
			damagepos, // vDamageOrigin the point the damage originates			
			0, // psOffsetTime The time offset for the damage
			0, // boneIndex
			0, // modelIndex
			0, // surfaceType
			(1.0, 0, 0) // surfaceNormal
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


function on_damage( eAttacker, eInflictor, weapon, meansOfDeath, damage )
{
	self endon ( "death" );
	self endon ( "disconnect" );

	if ( isdefined( level._custom_weapon_damage_func ) )
	{
		is_weapon_registered = self [[level._custom_weapon_damage_func]]( eAttacker, eInflictor, weapon, meansOfDeath, damage );
		if( is_weapon_registered )
		{
			return;
		}
	}

	switch ( weapon.rootWeapon.name )
	{
		case "concussion_grenade":			
			radius = weapon.explosionRadius;
			
			if (self == eAttacker) // TFLAME 8/1/12 - reduce effects on attacker 
				radius *= 0.5;
			
			scale = 1 - (distance( self.origin, eInflictor.origin ) / radius);
			
			if ( scale < 0 )
				scale = 0;
			
			time = 2 + (4 * scale);
			
			{wait(.05);};

			if ( self HasPerk ( "specialty_stunprotection" ) )
			{
				time *= 0.1;
			}
			else
			{
				if ( self util::mayApplyScreenEffect() ) 
				{
					self shellShock( "concussion_grenade_mp", time, false ); 
				}
			}
			
			self thread play_concussion_sound( time );
			self.concussionEndTime = getTime() + (time * 1000); 
			self.lastConcussedBy = eAttacker;
			break;

		default:
			// shellshock will only be done if meansofdeath is an appropriate type and if there is enough damage.
			if ( isdefined( level.shellshockOnPlayerDamage ) )
			{
				 [[level.shellshockOnPlayerDamage]]( meansOfDeath, damage, weapon );
			}
			break;
	}
}

function play_concussion_sound( duration )
{	
	self endon( "death" );
	self endon( "disconnect" );

	concussionSound = spawn ("script_origin",(0,0,1));
	concussionSound.origin = self.origin;
	concussionSound linkTo( self );
	concussionSound thread delete_ent_on_owner_death( self );
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

function delete_ent_on_owner_death( owner )
{
	self endon( "delete" );
	owner waittill( "death" );
	self delete();	
}

// weapon stowing logic ===================================================================

// thread loop life = player's life
function update_stowed_weapon()
{
	self endon( "spawned" );
	self endon( "killed_player" );
	self endon( "disconnect" );
	
	//weapons::detach_all_weapons();
	
	self.tag_stowed_back = undefined;
	self.tag_stowed_hip = undefined;
	
	team = self.pers["team"];
	playerclass = self.pers["class"];
	
	while ( true )
	{
		self waittill( "weapon_change", newWeapon );

		if ( self IsMantling() )
		{
			continue;
		}
		
		currentStowed = self GetStowedWeapon();
		hasStowed = false;
		
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
			switch( weaponsList[idx].name )
			{
			case "minigun":		// death machine
			case "m32":			// grenade launcher
				continue;

			default:
				break;
			}
			
			if ( !hasStowed || currentStowed == weaponsList[idx] )
			{
				currentStowed = weaponsList[idx];
				hasStowed = true;
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

		if ( newWeapon != level.weaponNone || !hasStowed )
		{
			weapons::detach_all_weapons();
			weapons::stow_on_back();
			weapons::stow_on_hip();
		}
	}
}

function loadout_get_offhand_weapon( stat )
{
	if ( isdefined( level.giveCustomLoadout ) )
	{
		return level.weaponNone;
	}

	assert( isdefined( self.class_num ) );
	if ( isdefined( self.class_num ) ) 
	{
		index = self loadout::getLoadoutItemFromDDLStats( self.class_num, stat );
	
		if ( isdefined( level.tbl_weaponIDs[index] ) && isdefined( level.tbl_weaponIDs[index]["reference"] ) )
		{
			return GetWeapon( level.tbl_weaponIDs[index]["reference"] );
		}
	}

	return level.weaponNone;
}

function loadout_get_offhand_count( stat )
{
	count = 0;
	if ( isdefined( level.giveCustomLoadout ) )
	{
		return 0;
	}

	assert( isdefined( self.class_num ) );
	if ( isdefined( self.class_num ) )
	{
		count = self loadout::getLoadoutItemFromDDLStats( self.class_num, stat );
	}

	return count;
}

// Self == player
function flash_scavenger_icon()
{
	self.scavenger_icon.alpha = 1;
	self.scavenger_icon fadeOverTime( 1.0 );
	self.scavenger_icon.alpha = 0;
}

function scavenger_think()
{
	self endon( "death" );
	self waittill( "scavenger", player );

	primary_weapons = player GetWeaponsListPrimaries();
	offhand_weapons_and_alts = array::exclude( player GetWeaponsList( true ), primary_weapons );

	ArrayRemoveValue( offhand_weapons_and_alts, level.weaponBaseMelee );
	offhand_weapons_and_alts = array::reverse( offhand_weapons_and_alts ); // Prioritize tacticals over lethals

	player playsound( "wpn_ammo_pickup" );
	player playlocalsound( "wpn_ammo_pickup" );

	player flash_scavenger_icon();
	
	for ( i = 0; i < offhand_weapons_and_alts.size; i++ )
	{
		weapon = offhand_weapons_and_alts[i];

		if ( !weapon.isScavengable || killstreaks::is_killstreak_weapon( weapon ) )
		{
			continue;
		}
		
		maxAmmo = 0;
		
		if ( weapon == player.grenadeTypePrimary && isdefined( player.grenadeTypePrimaryCount ) && player.grenadeTypePrimaryCount > 0 )
		{
			maxAmmo = player.grenadeTypePrimaryCount;
		}
		else if ( weapon == player.grenadeTypeSecondary && isdefined( player.grenadeTypeSecondaryCount ) && player.grenadeTypeSecondaryCount > 0 )
		{
			maxAmmo = player.grenadeTypeSecondaryCount;
		}
		
		if ( isdefined( level.customLoasdoutScavenge ) )
		{
			maxAmmo = self [[level.customLoadoutScavenge]]( weapon );
		}
		
		if ( maxAmmo == 0 )
		{
			continue;
		}
		
		if ( weapon.rootWeapon == level.weaponSatchelCharge )
		{
			if ( player weaponobjects::anyObjectsInWorld( weapon.rootWeapon ) )
			{
				continue;
			}
		}		
			
		stock = player GetWeaponAmmoStock( weapon );

		if ( stock < maxAmmo )
		{
			// just give 1 for each scavenger pick up
			ammo = stock + 1;
			if ( ammo > maxAmmo )
			{
				ammo = maxAmmo;
			}
			player SetWeaponAmmoStock( weapon, ammo );
			player.scavenged = true;
			
			player thread challenges::scavengedGrenade();
		}
		else
		{
			if ( weapon.rootWeapon == GetWeapon( "trophy_system" ) )
			{
				player trophy_system::ammo_scavenger( weapon );
			}
		}
	}

	for ( i = 0; i < primary_weapons.size; i++ )
	{
		weapon = primary_weapons[i];

		if ( !weapon.isScavengable || killstreaks::is_killstreak_weapon( weapon ) )
		{
			continue;
		}

		stock = player GetWeaponAmmoStock( weapon );
		start = player GetFractionStartAmmo( weapon );
		clip = weapon.clipSize;
		clip *= GetDvarFloat( "scavenger_clip_multiplier", 1 );
		clip = Int( clip );
		maxAmmo = weapon.maxAmmo;

		if ( stock < maxAmmo - clip )
		{
			ammo = stock + clip;
			player SetWeaponAmmoStock( weapon, ammo );
			player.scavenged = true;
		}
		else
		{
			player SetWeaponAmmoStock( weapon, maxAmmo );
			player.scavenged = true;
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
	self.scavenger_icon.alpha = 0;

	width = 64;
	height = 64;

	if ( level.splitscreen )
	{
		width = Int( width * 0.5 );
		height = Int( height * 0.5 );
	}
	
	self.scavenger_icon.x = -width/2;
	self.scavenger_icon.y = 16;

	self.scavenger_icon setShader( "hud_scavenger_pickup", width, height );
}

function drop_scavenger_for_death( attacker )
{
	if ( level.wagerMatch )
		return;

	if ( !isdefined( attacker ) )
 		return;

 	if ( attacker == self )
 		return;
 		
	if ( level.gameType == "hack" )
	{
		item = self dropScavengerItem( GetWeapon( "scavenger_item_hack" ) );
	}
	else if ( isplayer( Attacker ) )
	{
		item = self dropScavengerItem( GetWeapon( "scavenger_item" ) );
	}
	else
	{
		return;
	}
	
	item thread scavenger_think();
}


// if we need to store multiple drop limited weapons, we'll need to store an array on the player entity
function add_limited_weapon( weapon, owner, num_drops )
{
	limited_info = SpawnStruct();
	limited_info.weapon = weapon;
	limited_info.drops = num_drops;

	owner.limited_info = limited_info;
}

function should_drop_limited_weapon( weapon, owner )
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


function drop_limited_weapon( weapon, owner, item )
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

	item thread limited_pickup( limited_info );
}


function limited_pickup( limited_info )
{
	self endon( "death" );
	self waittill( "trigger", player, item );

	if ( !isdefined( item ) )
	{
		return;
	}

	player.limited_info = limited_info;
}

// self is the grenade
function track_cooked_detonation( attacker, weapon, cookTime )
{
	self endon( "trophy_destroyed" );
	
	self waittill( "explode", origin, surface );
	
	if ( weapon.rootWeapon == level.weaponFlashGrenade )
	{	
		level thread nineBang_doNineBang( attacker, weapon, origin, cookTime );		
	}
}

function nineBang_doNineBang( attacker, weapon, pos, cookTime )
{
	level endon( "game_ended" );
	
	maxStages = 4;
	maxRadius = 20;
	minDelay = 0.15;
	maxdelay = 0.3;
	
	explosionRadiusSq = weapon.explosionRadius * weapon.explosionRadius;
	explosionRadiusMinSq = weapon.explosionInnerRadius * weapon.explosionInnerRadius;
	
	cookStages = cookTime / weapon.cookOffHoldTime * maxStages + 1;
				
	detonations = 0;
	
	if ( cookStages < 2 )
	{
		return;
	}
	else if ( cookStages < 3 )
	{
		detonations = 3;
	}
	else if ( cookStages < 4 )
	{
		detonations = 6;
	}
	else // max
	{
		detonations = 9;
		//nineBang_DoEmpDamage( attacker, weapon, pos );
	}	
	
	wait( RandomFloatRange( minDelay, maxDelay ) );
	
	// the nine bang will go off detonations-1 times as it already exploded once, and flash everything in the vacinity
	for( i = 1; i < detonations; i++ )
	{
		newPos = level nineBang_getSubExplosionPos( pos, maxRadius );
		
		PlaySoundAtPosition( "wpn_flash_grenade_explode", newPos );
		PlayFX( level._effect["flashNineBang"], newPos );

		closestPlayers = ArraySort( level.players, newPos, true );
		
		// get players within the radius
		foreach( player in closestPlayers )
		{
			if ( !isdefined( player ) || !IsAlive( player ) )
			{
				continue;
			}
			
			if ( player.sessionstate != "playing" )
			{
				continue;
			}
			
			viewOrigin = player GetEye();			
			
			// first make sure they are within distance
			dist = DistanceSquared( pos, viewOrigin );
			
			if( dist > explosionRadiusSq )
			{
				break;
			}
		
			// now make sure they can be hit by it
			if( !BulletTracePassed( pos, viewOrigin, false, player ) )
				continue;
		
			if ( dist <= explosionRadiusMinSq )
				percent_distance = 1.0;
			else
				percent_distance = 1.0 - ( dist - explosionRadiusMinSq ) / ( explosionRadiusSq - explosionRadiusMinSq );
		
			forward = AnglesToForward( player GetPlayerAngles() );
		
			toBlast = pos - viewOrigin;
			toBlast = VectorNormalize( toBlast );
		
			percent_angle = 0.5 * ( 1.0 + VectorDot( forward, toBlast ) );
		
			player notify( "flashbang", percent_distance, percent_angle, attacker );
		}		

		wait( RandomFloatRange( minDelay, maxDelay ) );
	}	
}

function nineBang_getSubExplosionPos( startPos, range )
{
	offset = ( RandomFloatRange( -1.0 * range, range ), RandomFloatRange( -1.0 * range, range ), 0 );
	newPos = startPos + offset;
	
	// make sure we don't spawn through walls
	if ( BulletTracePassed( startPos, newPos, false, undefined ) )
	{
		return newPos;
	}
	
	return startPos;
}

function nineBang_DoEmpDamage( player, weapon, position )
{
	kNineBangEmpRadius = 512;
	radiusSq = kNineBangEmpRadius * kNineBangEmpRadius;
		
	PlaySoundAtPosition( "wpn_emp_explode", position );
	
	level empgrenade::empExplosionDamageEnts( player, weapon, position, kNineBangEmpRadius, false );
	
	foreach ( targetEnt in level.players )
	{
		if ( nineBang_empCanDamage( targetEnt, position, radiusSq, false, 0 ) )
		{
			targetEnt notify( "emp_grenaded", player );
		}			
	}
}

function nineBang_empCanDamage( ent, pos, radiusSq, doLOS, startRadius )
{
	entpos = ent.origin;
	distSq = DistanceSquared( pos, entpos );
	return ( distSq < radiusSq
	        && ( !doLOS || weapons::weaponDamageTracePassed( pos, entpos, startRadius, ent ) ) );
}


function track_multi_detonation( ownerEnt, weapon, cookTime ) // self is the grenade
{
	self endon( "trophy_destroyed" );
	
	self waittill( "explode", origin, surface );
	
	if ( weapon.rootWeapon == GetWeapon( "frag_grenade_grenade" ) )
	{
		for ( i = 0; i < weapon.multiDetonation; i++ )
		{
			// spawn a magic grenade
			if ( !isdefined( ownerEnt ) )
			{
				return;
			}
			
			multiblastWeapon = GetWeapon( "frag_multi_blast" );
			
			// get a velocity
			dir = level multi_detonation_get_cluster_launch_dir( i, weapon.multiDetonation );
			vel = dir * multiblastWeapon.multiDetonationFragmentSpeed;
			fuseTime = multiblastWeapon.fusetime/1000;
			
			grenade = ownerEnt MagicGrenadeType( multiblastWeapon, origin, vel, fuseTime );
			
			util::wait_network_frame();
		}
	}
}

function multi_detonation_get_cluster_launch_dir( index, multiVal )
{	
	pitch = 45;
	yaw = -180 + ( 360 / multiVal ) * index;
		
	angles = ( pitch, yaw, 45 );

	dir = AnglesToForward( angles );

	return dir;
}