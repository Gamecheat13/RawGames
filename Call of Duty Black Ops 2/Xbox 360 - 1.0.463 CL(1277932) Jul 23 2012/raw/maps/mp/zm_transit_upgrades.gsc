#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

#include maps\mp\zm_transit_utility;
#include maps\mp\zombies\_zm_perks;
//#include maps\mp\zm_transit_perks;



/*
BUS UPGRADE		USE $	LOCATION	DESCRIPTION
====================================================================================================
Gas#					res			a fillup on fuel
Tires# 					far			allows bus to move through muddy area			
Plow 					brn			kills zombies it touches, does not slow down in front of bus
Bus Pass				bar			makes the bus free to use
Window1		 			pri			can seal off any window on the perimeter of the bus.  (3 available)
Window2		 			hou			can seal off any window on the perimeter of the bus.  (3 available)
Window3		 			the			can seal off any window on the perimeter of the bus.  (3 available)
Turret 					arm			a machine gun mounted near the front of the bus
Zapper			500		pow			insta kills all zombies with tesla effect, pause zombie spawning for a short period
Barbed Wire1 			gas			takes zombies longer to climb into bus
Barbed Wire2 			far			takes zombies longer to climb into bus	
Turret1					arm			places turret or upgrades turret on front or back of the bus 
Turret2					gas			places turret or upgrades turret on front or back of the bus 
Turret3					hou			a player can use this mounted machine gun until it overheats
Turret4					pow			a player can use this mounted machine gun until it overheats
Turret5					bar			a player can use this mounted machine gun until it overheats
Turret6					twn			a player can use this mounted machine gun until it overheats
Radio					din			Radio will activate auto turrets along the bus path
Ladder					pri			Allows access to the roof

	
Not Yet Implimented:
Capacator							easter egg
Spoiler								just for fun
Running Lights						just for fun
*/
main()
{
	self.upgrades = [];
	self.upgradeUpgrades = [];
	self.key_local_offset	 = (180,  20, 65);
	self.ladder_local_offset = (142, -50, 100);
	
	// CattleCatcher
	//--------------
	self.upgrades[ "Plow" ] = SpawnStruct();
	self.upgrades[ "Plow" ].installed = false;
	
	self initBusTires();
	self busInitWeaponsLocker();
	//self busInitZapperCounter();
}

precache_upgrades()
{
}

createZapperStruct(cost, radius, cooldown, pauseTime)
{
	zapperStruct			= spawnStruct();
	zapperStruct.cost 		= cost;
	zapperStruct.radius 	= radius;
	zapperStruct.cooldown 	= cooldown;
	zapperStruct.pauseTime	= pauseTime;
	return zapperStruct;	
}

busInitBuyableWeapons()
{
	self.buyableWeaponsUpgradeLevel = -1;
	self.buyableWeapons = [];
	
	//Find upgrade trigger;
	self.buyableWeaponsUpgradeTrigger = getEnt("buyable_weapons_upgrade", "targetname");
	self.buyableWeaponsUpgradeTrigger enableLinkTo();
	self.buyableWeaponsUpgradeTrigger linkto(self, "", self worldtolocalcoords(self.buyableWeaponsUpgradeTrigger.origin), self.buyableWeaponsUpgradeTrigger.angles - self.angles);
	self.buyableWeaponsUpgradeTrigger SetHintString( "Hold [{+activate}] To Upgrade Bus Weapon");
	self.buyableWeaponsUpgradeTrigger SetCursorHint( "HINT_NOICON" );
	self.buyableWeaponsUpgradeTrigger setInvisibleToAll();
	self.buyableWeaponsUpgradeTrigger thread triggerUpgradeBuyableWeapons();
	
	//Find upgrade models and use triggers
	i = 0;
	buyableWeapon = getEnt("bus_buyable_weapon" + i, "script_noteworthy");
	while( isDefined(buyableWeapon) )
	{
		s = spawnStruct();
		
		//Setup trigger
		s.trigger = buyableWeapon;
		s.trigger enableLinkTo();
		s.trigger linkto(self, "", self worldtolocalcoords(s.trigger.origin), s.trigger.angles - self.angles);
		//s.trigger UseTriggerRequireLookAt();
		s.trigger setInvisibleToAll();
		s.trigger.show_hint = ::buyable_weapon_visisble;
		s.trigger.upgrade_index = i;
		
		//Setup model
		s.model = getEnt(s.trigger.target, "targetname");
		s.model linkto(self, "", self worldtolocalcoords(s.model.origin), s.model.angles - self.angles);
		s.model Hide();
		
		self.buyableWeapons[i] = s;
		
		i++;
		buyableWeapon = getEnt("bus_buyable_weapon" + i, "script_noteworthy");
	}
	
	self busUpgradeBuyableWeapon();
}

buyable_weapon_visisble(player)
{
	//Don't show if player is holding upgrade
	if(isDefined(player.holdingBuyableWeaponUpgrade) && player.holdingBuyableWeaponUpgrade)
	{
		return false;
	}
	return level.the_bus.buyableWeaponsUpgradeLevel == self.upgrade_index;
}

busUpgradeBuyableWeapon()
{
	if(self.buyableWeaponsUpgradeLevel>=0)
	{
		//self.buyableWeapons[self.buyableWeaponsUpgradeLevel].trigger setInVisibleToAll();
		self.buyableWeapons[self.buyableWeaponsUpgradeLevel].model Hide();	
	}
	
	self.buyableWeaponsUpgradeLevel++;
	
	//self.buyableWeapons[self.buyableWeaponsUpgradeLevel].trigger setVisibleToAll();
	self.buyableWeapons[self.buyableWeaponsUpgradeLevel].model Show();
	
	self busUpdateBuyableWeaponTriggers();
}

busUpdateBuyableWeaponTriggers()
{
	players = get_Players();
	for(i=0; i<players.size; i++)
	{
		canSeeUpgradeTrigger = isDefined(players[i].holdingBuyableWeaponUpgrade) && players[i].holdingBuyableWeaponUpgrade;
		self.buyableWeaponsUpgradeTrigger setInvisibleToPlayer(players[i],!canSeeUpgradeTrigger);
	}
}

busInitWeaponsLocker()
{
	trigger = getEnt("weapon_locker_trigger", "targetname");
	
	if ( !IsDefined( trigger ) )
	{
		return;
	}
	
	//* trigger enableLinkTo();
	//* trigger linkto(self, "", self worldtolocalcoords(trigger.origin), trigger.angles - self.angles);
	trigger SetHintString( "Hold [{+activate}] To Store Current Weapon");
	trigger SetCursorHint( "HINT_NOICON" );
	//trigger UseTriggerRequireLookAt();
	
	wallModel = getEnt(trigger.target, "targetname");
	//* wallModel linkto(self, "", self worldtolocalcoords(wallModel.origin), wallModel.angles - self.angles);
	
	if ( !IsDefined( wallModel ) )
	{
		return;
	}
	
	trigger thread triggerWeaponsLockerWatch(wallModel);
}

busInitZapperCounter()
{
	self.zapper_counter = [];
	nums = GetEntArray("zapper_counter", "targetname");
	for(i=0; i<nums.size; i++)
	{
		number = nums[i];
		switch(nums[i].script_string)
		{
		case "counter_1s":
			self.zapper_counter[0] = number;
			self.zapper_counter_1s = number;
			break;
		case "counter_10s":
			self.zapper_counter[1] = number;
			self.zapper_counter_10s = number;
			break;
		case "counter_100s":
			self.zapper_counter[2] = number;
			self.zapper_counter_100s = number;
			break;
		case "counter_1000s":
			self.zapper_counter[3] = number;
			self.zapper_counter_1000s = number;
			break;
		default:
			break;
		}
		
		number linkto(self, "", self worldtolocalcoords(number.origin), number.angles - self.angles);
		number setInvisibleToAll();	
	}
}
busZapperCounter()
{
	self waittill("zapper_installed");
	
	for(i=0; i<self.zapper_counter.size; i++)
	{
		self.zapper_counter[i] setVisibleToAll();
		self.zapper_counter[i] set_counter( 0 );
	}

	self.zapper_counter 	= 0;
	self.zapper_kill_count 	= 0;
	
	while(1)
	{
		if(self.zapper_counter<self.zapper_kill_count)
		{
			self.zapper_counter++;
			
			ones = self.zapper_counter % 10;
			self.zapper_counter_1s set_counter( ones );
		
			tens = int( self.zapper_counter / 10 ) % 10;
			self.zapper_counter_10s set_counter( tens );

			hundreds = int( self.zapper_counter / 100 ) % 10;
			self.zapper_counter_100s set_counter( hundreds );
			
			thousands = int( self.zapper_counter / 1000 ) % 10;
			self.zapper_counter_1000s set_counter( thousands );
			
			wait 0.1;
		}
		else
		{
			wait 0.5;
		}
	}
}

/*
busInitTurrets()
{
	//self.turrets = [];
	self.turretUpgrades = [];
	
	turret_triggers = getEntArray( "pay_turret", "targetname" );
	for (i=0; i<turret_triggers.size; i++)
	{
		//Turret Name 
		name = turret_triggers[i].script_noteworthy;
		turretStruct = spawnstruct(); 
		turretStruct.installed = false;
		turretStruct.name = name;
		
		//Trigger
		turretStruct.trigger = turret_triggers[i];
		turretStruct.trigger enableLinkTo();
		turretStruct.trigger linkto(self, "", self worldtolocalcoords(turretStruct.trigger.origin), turretStruct.trigger.angles - self.angles);
		turretStruct.trigger SetInvisibleToAll();

		//Turret 
		turretStruct.model = getEnt(turretStruct.trigger.target, "targetname");
		turretStruct.model linkto(self, "", self worldtolocalcoords(turretStruct.model.origin ), turretStruct.model.angles - self.angles);
		turretStruct.model SetInvisibleToAll();
		turretStruct.model SetDefaultDropPitch(0);
		
		//Exit Point
		turretStruct.exit = getEnt(turretStruct.model.target, "targetname");
		turretStruct.exit linkto(self, "", self worldtolocalcoords(turretStruct.exit.origin), turretStruct.exit.angles - self.angles);
		turretStruct.exit SetInvisibleToAll();
		
		//Upgrade Trigger
		turretStruct.upgradeTrigger = getEnt(turretStruct.exit.target, "targetname");
		

		
		//Add trigger to upgrades array
		upgradeIndex = -1;
		for(j=0;j<self.turretUpgrades.size;j++)
		{
			//Add turret to this triggers upgrade list
			if(self.turretUpgrades[j].trigger == turretStruct.upgradeTrigger )
			{
				self.turretUpgrades[j].turrets[name] = turretStruct;
				upgradeIndex = j;
			}
		}
		if ( upgradeIndex < 0 )
		{
			s = spawnStruct();
			
			s.hud = undefined;
			s.upgradeCount = 0;
			s.trigger = turretStruct.upgradeTrigger;
			s.trigger UseTriggerRequireLookAt();
			s.trigger SetCursorHint( "HINT_NOICON" );
			s.turrets = [];
			s.turrets[name] = turretStruct;
			
			//Use Model
			s.useModel = getEnt(turretStruct.upgradeTrigger.target, "targetname");
			s.useModel linkto(self, "", self worldtolocalcoords(s.useModel.origin), s.useModel.angles - self.angles);
			s.useModel SetInvisibleToAll();
			
			s.barricades = getEntArray(s.useModel.target, "targetname");
			for(j=0; j<s.barricades.size; j++)
			{
				s.barricades[j] linkto(self, "", self worldtolocalcoords(s.barricades[j].origin), s.barricades[j].angles - self.angles);
				s.barricades[j] SetInvisibleToAll();
			}
			
			upgradeIndex = self.turretUpgrades.size;
			self.turretUpgrades[upgradeIndex] = s;
		}
		
		turretStruct.model thread turretWatch(self.turretUpgrades[upgradeIndex], name);
	}
	
	//Init upgrade triggers
	for(i=0; i<self.turretUpgrades.size; i++)
	{
		trigger = self.turretUpgrades[i].trigger;
		trigger enableLinkTo();
		trigger linkto(self, "", self worldtolocalcoords(trigger.origin), trigger.angles - self.angles);
		trigger SetInvisibleToAll();
		trigger SetHintString( "Hold [{+activate}] To Place " + GetTurretNameFromUpgradeCount(self.turretUpgrades[i].upgradeCount+1, true));
	}
}

//busEnableTurrets(enable, player)
//{
//	for(i=0; i<self.turretUpgrades.size; i++)
//	{
//		upgrades = self.turretUpgrades[i].upgradeCount;
//		if( upgrades <= 0 )
//		{
//			continue;
//		}
//		
//		useTrigger = self.turretUpgrades[i].turrets[GetTurretNameFromUpgradeCount(upgrades)].trigger;
//		if(enable)
//		{
//			useTrigger setVisibleToPlayer(player);
//		}
//		else
//		{
//			useTrigger setInvisibleToPlayer(player);
//		}
//	}
//}

turretWatch(upgrade, name)
{
	prevOwner = undefined;
	while(1)
	{
		self waittill( "turretownerchange" );
		
		//Player exited turret
		if(Isdefined(prevOwner))
		{
			//Fix Exit Origin
			prevOwner setOrigin(upgrade.turrets[name].exit.origin);
			prevOwner setPlayerAngles(upgrade.turrets[name].exit.angles);
			
			//Turn collision back on
			prevOwner setPlayerCollision(1);
			
			//Hide Trigger
			upgrade.turrets[name].trigger setVisibleToAll();
			
			self notify("stop_turret_count");
			
			prevOwner.onBusTurret = false;
			prevOwner.busTurret = undefined;
			
			bbprint( "zombie_events", "category %s type %s round %d playername %s", "BUS", "turret_exit", level.round_number, prevOwner.name);
			
			// mkornkven: disabling turret god-mode for now
		//	prevOwner DisableInvulnerability();
		}
		
 		prevOwner = self GetTurretOwner();
		
		//Player entered turret
		if(Isdefined(prevOwner))
		{
			// Turn off collision
			prevOwner setPlayerCollision(0);
			// Show Trigger
			upgrade.turrets[name].trigger setInVisibleToAll();
			// Start Count Down
			self thread turret_countdown(45, upgrade, name);
			self thread hide_turret_count(upgrade, name);
			
			prevOwner.onBusTurret = true;
			prevOwner.busTurret = self;
			
			bbprint( "zombie_events", "category %s type %s round %d playername %s", "BUS", "turret_enter", level.round_number, prevOwner.name);
			
			// mkornkven: disabling turret god-mode for now
		//	prevOwner EnableInvulnerability();
		}
	}
	
}

turret_countdown(countdown, upgrade, name)
{	
	self endon("stop_turret_count");
	
	if ( isDefined(upgrade.hud) )
	{
		upgrade.hud Destroy();
	}

	upgrade.hud = newClientHudElem(upgrade.turrets[name].model GetTurretOwner()); //newHudElem();
	upgrade.hud.color = (1, 1, 1);
	upgrade.hud.alpha = .3;
	upgrade.hud.fontScale = 4;
	upgrade.hud.x = -300;//-295;
	upgrade.hud.y = 100;//195;
	upgrade.hud.alignX = "center";
	upgrade.hud.alignY = "bottom";
	upgrade.hud.horzAlign = "center";
	upgrade.hud.vertAlign = "middle";
	upgrade.hud.font = "objective";
	upgrade.hud.glowColor = (0.3, 0.6, 0.3);
	upgrade.hud.glowAlpha = 1;
	upgrade.hud.foreground = 1;
	upgrade.hud.hidewheninmenu = true;
	
	upgrade.hud settimer( countdown );
	wait(countdown - 5);	
	upgrade.hud.color = (1,0,0);
	upgrade.hud.alpha = 1;
	wait(5);
	
	//Kick the player off
	if( isdefined( upgrade.turrets[name].model GetTurretOwner() ) )
	{
		upgrade.turrets[name].model useby(upgrade.turrets[name].model GetTurretOwner());
	}
	
}

hide_turret_count(upgrade, name)
{
	self waittill("stop_turret_count");
	
	if ( isDefined(upgrade.hud) )
	{
		upgrade.hud.alpha = 0;
		upgrade.hud Destroy();
		upgrade.hud = undefined;
	}
}

playerIsOnTurret()
{
	return isDefined(self.onBusTurret) && self.onBusTurret;
}

initAutoTurret()
{
	turret_trigger = getEnt( "auto_turret_trigger", "script_noteworthy" );
	level.bus_auto_turret_trigger = turret_trigger;
	turret_trigger enableLinkTo();
	turret_trigger linkto(level.the_bus, "", level.the_bus worldtolocalcoords(turret_trigger.origin), turret_trigger.angles - level.the_bus.angles);
	turret_trigger SetInvisibleToAll();
	
	auto_turret_parts = getEntArray( "bus_auto_turret", "targetname" );
	for(i=0; i<auto_turret_parts.size; i++)
	{
		auto_turret_parts[i] SetInvisibleToAll();	
		if ( auto_turret_parts[i].model == "zombie_zapper_handle" )
		{
			continue;
		}
		level.bus_auto_turret = auto_turret_parts[i];
		auto_turret_parts[i] linkto(level.the_bus, "", level.the_bus worldtolocalcoords(auto_turret_parts[i].origin), auto_turret_parts[i].angles - level.the_bus.angles);
		
	}
	
}
*/

setPlayerVisibilityForTrigger( player, trigger, makeVisible )
{
	if (!IsDefined(trigger))
	{
		return;
	}

	if (makeVisible)
	{
		trigger setVisibleToPlayer( player );
	}
	else 
	{
		trigger setInvisibleToPlayer( player );
	}
}


busSetPlayerVisibilityForUpgradeTriggers( player, makeVisible )
{
	upgradekeys = GetArrayKeys( self.upgrades );
	for (k=0; k<upgradekeys.size; k++)
	{
		upgrade = self.upgrades[upgradekeys[k]];
		setPlayerVisibilityForTrigger(player, upgrade.trigger, makeVisible);
	}
}
busSetPlayerVisibilityForBlockerTriggers( player, makeVisible )
{
	for (i=0; i<self.openings.size; i++)
	{
		opening = self.openings[i];
		setPlayerVisibilityForTrigger(player, opening.blockerTrigger, makeVisible);
	}
}


//--------------------------------------------------------
// name: 	selectRandomSpawnLocation
// self: 	bus
// return:	use trigger 
// desc:	selects a random spawn location
//--------------------------------------------------------
selectRandomSpawnLocation( name )
{
	// get the array of upgrades in case there are multiple spawn points for an upgrade
	triggerEntSpawnPoints = [];
	triggerEntSpawnPoints = GetEntArray("trigger_"+name, "targetname");
	if ( !IsDefined( triggerEntSpawnPoints ) || triggerEntSpawnPoints.size == 0 )
	{
		return;
	}
	
	// pick a random place to spawn, store the trigger in triggerEnt
	spawnIndex = randomInt(triggerEntSpawnPoints.size);
	triggerEnt = triggerEntSpawnPoints[spawnIndex];
	if (!IsDefined(triggerEnt))
	{
		return;
	}
	
	// remove all of the other spawn points
	for ( i = 0; i < triggerEntSpawnPoints.size; i++ )
	{
		// don't delete the one we chose
		if ( i == spawnIndex )
		{
			continue;
		}
		
		if ( !IsDefined( triggerEntSpawnPoints[i] ) )
		{
			continue;
		}
		unneededTrigger = triggerEntSpawnPoints[i];
		unneededModel = GetEnt(unneededTrigger.target, "targetname");
		
		//get rid of them
		unneededModel Hide();
		unneededTrigger Delete();
	}
	
	// set the display name
	displayName = name;
	if (IsDefined(triggerEnt.script_string))
	{
		displayName = triggerEnt.script_string;
	}
	
	triggerEnt SetCursorHint( "HINT_NOICON" );
	triggerEnt SetHintString( "Hold [{+activate}] To Pickup " + displayName );
	//triggerEnt UseTriggerRequireLookAt();
	
	return triggerEnt;
}

busRunUpgrade( name, destOrigin, destAngles, OnFinishedFunction, OnUsedFunction, OnReadyFunction, OnUpgradeFunction, upgradeCount )
{
	level endon( "intermission" );
	
	if( !isDefined(upgradeCount) )
	{
		upgradeCount = 0;
	}
	
	//Track upgradable upgrades
	upgradeUpgrades = self.upgradeUpgrades[name];
	if( !isDefined(upgradeUpgrades) )
	{
		upgradeUpgrades 			= spawnstruct();
		upgradeUpgrades.maxCount	= upgradeCount;
		upgradeUpgrades.count		= 0;
		upgradeUpgrades.useTrigger	= undefined;
		
		self.upgradeUpgrades[name] = upgradeUpgrades;
	}
	
	if(upgradeCount>0)
	{
		self thread busRunUpgrade( name, destOrigin, destAngles, OnFinishedFunction, OnUsedFunction, OnReadyFunction, OnUpgradeFunction, upgradeCount-1 );
		
		//name = name + string(upgradeCount);
		name = name;

	}
	
	//Find random spawn location
	triggerEnt = self selectRandomSpawnLocation( name );
	
	// put this in for the test map so it doesn't need to have all of the upgrades placed
	if ( !isDefined( triggerEnt ) )
	{
		return;
	}
	
	// set the display name
	displayName = name;
	if (IsDefined(triggerEnt.script_string))
	{
		displayName = triggerEnt.script_string;
	}
	
	// Some Setup Here
	//-----------------
	self.upgrades[name] 			= spawnstruct();
	self.upgrades[name].installed	= false;
	self.upgrades[name].pickedup	= false;
	self.upgrades[name].model		= GetEnt(triggerEnt.target, "targetname");
	self.upgrades[name].display		= displayName;
	self.upgrades[name].trigger		= triggerEnt;
	self.upgrades[name].upgrades	= upgradeUpgrades;
	
	
	/#
	AddDebugCommand( "devgui_cmd \"Zombies:1/Bus:14/Pick Up Upgrade:1/" + name + ":" + self.upgrades.size + "\" \"zombie_devgui pickup " + name + "\"\n" );
	#/

	
	
	// Wait For A Player To Pick This Up
	//-----------------------------------
	while (1)
	{
		self.upgrades[name].trigger 	waittill("trigger", player_pickup);
		if (IsDefined(player_pickup.holdingUpgrade))
		{
			wait(0.2);
			continue;
		}
		break;
	}
	self.upgrades[name].model 	 	Hide();
	self.upgrades[name].pickedup	= true;
	
	bbprint( "zombie_events", "category %s type %s round %d playername %s name %s", "UPGRADE", "pickup", level.round_number, player_pickup.name, name );
		
	play_sound_at_pos( "grab_metal_bar", player_pickup.origin );

	if (!IsDefined(destOrigin))
	{
		self.upgrades[name].trigger Delete(); 
		if( IsDefined( OnFinishedFunction ) )
		{
			self [[OnFinishedFunction]]( player_pickup, name );
		}	
		return;
	}
	
	player_pickup.holdingUpgrade = name;
	player_pickup playerAddUpgradeHud(displayName);
//	self busSetPlayerVisibilityForUpgradeTriggers( player_pickup, false );// all other triggers are not available for this player

	
	
	// Player Must Carry It To Dest
	//------------------------------
//	player_pickup allowSprint(false);
//	player_pickup setmovespeedscale(0.6);
	if ( !isDefined(self.upgrades[name].trigger	GetLinkedEnt()))	//Dont enable link to if already linked
	{
		self.upgrades[name].trigger	enableLinkTo();
	}
	self.upgrades[name].trigger linkTo(self, "", destOrigin, (0,0,0));
	
	if(self.upgrades[name].upgrades.count == 0)
	{
		self.upgrades[name].trigger SetHintString( "Hold [{+activate}] To Place " + self.upgrades[name].display ); 
		self.upgrades[name].trigger SetVisibleToPlayer(player_pickup);
	}
	else
	{
		self.upgrades[name].trigger SetHintString( "Hold [{+activate}] To Upgrade " + self.upgrades[name].display ); 
		self.upgrades[name].trigger SetVisibleToPlayer(player_pickup);
		
		//Hide the use trigger
		if( isDefined(self.upgrades[name].upgrades.useTrigger) )
		{
			self.upgrades[name].upgrades.useTrigger SetInvisibleToPlayer(player_pickup, true);
		}
	}
	
	//Place model on player
	player_pickup playerAttachUpgradeModel(name);
	
	
	wait(0.1);
	

	
	//----------------------------------
	// TODO: Handle Player Death Here!
	//----------------------------------
	
	
	// Wait For The Player To Drop Off The Upgrade At The Destination
	//----------------------------------------------------------------
	self thread busIndicatorAtTrigger(self.upgrades[name].trigger, name, player_pickup);
	while(1)
	{
		self.upgrades[name].trigger waittill("trigger", player_place);
		if (player_place != player_pickup)
		{
			wait(0.2);
			continue;
		}
		self.upgrades[name].trigger SetVisibleToAll();
		break;
	}
	
	// Place The Model
	//-----------------
	player_pickup.holdingUpgrade = undefined;
//	self busSetPlayerVisibilityForUpgradeTriggers( player_pickup, true );	// allow this player to pick up upgrades again
	play_sound_at_pos( "barrier_rebuild_slam", player_pickup.origin );
	self.upgrades[name].installed	= true;
	if (IsDefined(destAngles) && self.upgrades[name].upgrades.count==0)
	{
		self.upgrades[name].model Show();
		self.upgrades[name].model linkTo(self, "", destOrigin, destAngles);
	}
	if(isDefined(player_pickUp.upgradeHud))
	{
		player_pickUp.upgradeHud Destroy();
	}
	
	bbprint( "zombie_events", "category %s type %s round %d playername %s name %s", "UPGRADE", "install", level.round_number, player_pickUp.name, name );

	//Detach the 3rd person model
	player_pickup playerDettachUpgradeModel(name);
	
	//Set the common use trigger for all upgrade upgrades
	if( !isDefined(self.upgrades[name].upgrades.useTrigger) )
	{
		self.upgrades[name].upgrades.useTrigger = self.upgrades[name].trigger;
	}
	else
	{
		//Allow use trigger to be used by player upgrading
		self.upgrades[name].upgrades.useTrigger SetInvisibleToPlayer(player_pickup, false);
	}

	
	self.upgrades[name].upgrades.count++;
	
	// Run The Finished Function
	//---------------------------
	if( IsDefined( OnFinishedFunction ) )
	{
		[[OnFinishedFunction]]( player_pickup, name );
	}
	if(IsDefined(OnUpgradeFunction))
	{
		[[OnUpgradeFunction]]( player_pickup, name );
		
		//Dont add a second use trigger
		if(self.upgrades[name].upgrades.count>1)
		{
			self.upgrades[name].trigger Delete(); 
			return;
		}
	}
	if (!IsDefined(OnUsedFunction))
	{
		self.upgrades[name].trigger Delete(); 
		return;
	}
	
	
	
	// Begin The Use Loop
	//--------------------
	while (1)
	{
		if( IsDefined( OnReadyFunction ) )
		{
			[[OnReadyFunction]]( name );
		}	
		self.upgrades[name].trigger waittill("trigger", player_use);
		[[OnUsedFunction]]( player_use, name );
	}
}

playerAttachUpgradeModel(name)
{
	self attach(level.the_bus.upgrades[name].model.model, "j_spineupper", true);
}

playerDettachUpgradeModel(name)
{
	self detach(level.the_bus.upgrades[name].model.model, "j_spineupper");
}

playerAddUpgradeHud(name)
{
	if ( isDefined(self.upgradeHud) )
	{
		self.upgradeHud Destroy();
	}

	self.upgradeHud = newClientHudElem(self);
	self.upgradeHud.color = (1, 1, 1);
	self.upgradeHud.alpha = .75;
	self.upgradeHud.fontScale = 1.5;
	self.upgradeHud.x = 140;
	self.upgradeHud.y = 190;
	self.upgradeHud.alignX = "center";
	self.upgradeHud.alignY = "bottom";
	self.upgradeHud.horzAlign = "center";
	self.upgradeHud.vertAlign = "middle";
	self.upgradeHud.font = "objective";
	self.upgradeHud.foreground = 1;
	self.upgradeHud.hidewheninmenu = true;
	self.upgradeHud SetText("Holding: " + name);
}

playerRemoveUpgradeHud()
{
	if(isDefined(self.upgradeHud))
	{
		self.upgradeHud Destroy();
	}
}

busIndicatorAtTrigger( trigger, name, visibleOnlyToPlayer )
{
	fxent = busIndicatorAtLoc( trigger.origin, visibleOnlyToPlayer );
	
	while(IsDefined(trigger) && !self.upgrades[name].installed)
	{
		wait(0.5);
	}
	fxent Delete();
}

busIndicatorAtLoc( loc, visibleOnlyToPlayer )
{
	fxOrigin = Spawn( "script_model", loc );
	fxOrigin SetModel("tag_origin");
	
	fxOrigin linkto(self, "", self worldtolocalcoords(fxOrigin.origin), fxOrigin.angles - self.angles);
			
	//Needed to get 'playfxontag' to properly work, as the setmodel needs a frame.
	wait .05;
		
	PlayFXOnTag(level._effect["powerup_on"], fxOrigin, "tag_origin" );
	
	if(isDefined(visibleOnlyToPlayer))
	{
		fxOrigin setVisibleToPlayer(visibleOnlyToPlayer);
	}
	
	
	return fxOrigin;
}


//*****************************************************************************
// Placement Callbacks
//*****************************************************************************
busOnHeadlightsPlaced( by_player, name )
{
//	headlightL = playfxontag(level._effect["headlight"], self, "R_headlight");
//	headlightR = playfxontag(level._effect["headlight"], self, "L_headlight");
	
	self.headLights = SpawnAndLinkFXToOffset(level._effect["fx_zbus_headlight_beam"], 	self, ( 230,    0,  40), ( 0, 0, 0));

//	floodL 	= SpawnAndLinkFXToOffset(level._effect["fx_zbus_light_flood"], 		self, ( 0,    90,  100), ( 0, 90, 0));
//	floodR 	= SpawnAndLinkFXToOffset(level._effect["fx_zbus_light_flood"], 		self, ( 0,   -90,  100), ( 0,-90, 0));
	
//	self waittill ("headlights_off");
	
//	tag1 delete();
//	tag2 delete();
}

busOnLFloodlightPlaced( by_player, name )
{
	self.floodLightL 	= SpawnAndLinkFXToOffset(level._effect["fx_zbus_light_flood"], 		self, ( 0,    90,  100), ( 0, 90, 0));
}
busOnRFloodlightPlaced( by_player, name )
{
	self.floodLightR 	= SpawnAndLinkFXToOffset(level._effect["fx_zbus_light_flood"], 		self, ( 0,   -90,  100), ( 0,-90, 0));
}

busOnPlowPlaced( by_player, name )
{
	self maps\mp\zm_transit_openings::busOpeningSetEnabled("front", false);	
	self.upgrades["Plow"].killcount = 0;
}
busOnNoxPlaced( by_player, name )
{
	iPrintLnBold("NOX:  Upgrade will eventually allow you to get a temporary speed boost");
}
busOnTeleportPlaced( by_player, name )
{
	self notify("OnTeleportPlaced");
}
busOnLadderPlaced( by_player, name )
{
//	iPrintLnBold("ZAPPER: allows you to insta-kill all nearby zombies");
}
busOnRadioPlaced( by_player, name )
{
	iPrintLnBold("Radio Will Activate Auto Turrets Near The Bus.");
	self notify("OnRadioPlaced");
}
busOnCoolerPlaced( by_player, name )
{
	iPrintLnBold("COOLER: Use this to get a random cola: increased sprint duration or 3 primary weapons");
}
busOnSonicBoomPlaced( by_player, name )
{
	iPrintLnBold("Sonic Boom: allows you to knock down all nearby zombies");
}
busOnTurretPlaced( by_player, name )
{
	self.turrets[name].trigger SetVisibleToAll();
	self.turrets[name].model SetVisibleToAll();
	if ( isDefined(self.turrets[name].useModel) )
	{
		self.turrets[name].useModel SetVisibleToAll();
	}
	self.turrets[name].installed = true;
	
	match = name + "_Match";
	if( isDefined(self.turrets[match]) )
	{
		self.turrets[match].trigger SetVisibleToAll();
		self.turrets[match].model SetVisibleToAll();
		if ( isDefined(self.turrets[match].useModel) )
		{
			self.turrets[match].useModel SetVisibleToAll();
		}
		self.turrets[match].installed = true;
	}
	
	//Update triggers for players clinging to the bus
//	for(i=0; i<level.cling_triggers.size; i++)
//	{
//		if(IsDefined(level.cling_triggers[i].player))
//		{
//			self busEnableTurrets(false, level.cling_triggers[i].player);
//		}
//	}
	
	iPrintLnBold("Turret Installed On The Bus.");
}
GetTurretNameFromUpgradeCount(upgrades, printName)
{
	if(!isDefined(printName))
	{
		printName = false;
	}
	switch ( upgrades )
	{
	case 1:
		if(printName)
			return "MG Turret";
		else 
			return "Turret";
	case 2:
		if(printName)
			return "Rocket Turret";
		else
			return "TurretRocket";
	case 3:
		if(printName)
			return "Laser Turret";
		else
			return "TurretRay";
	default:
		return "";
	}
}
busOnTurretPickedUp( by_player, name )
{
	for(i=0; i<self.turretUpgrades.size; i++)
	{
		upgrades = self.turretUpgrades[i].upgradeCount;
		
		turretName = GetTurretNameFromUpgradeCount(upgrades);
		useTrigger = undefined;
		if(turretName != "")
		{
			useTrigger = self.turretUpgrades[i].turrets[turretName].trigger;
		}
		upgradeTrigger = self.turretUpgrades[i].trigger;
		
		if ( upgrades >= 0 && upgrades <= 2)
		{
			if(isDefined(useTrigger))
			{
				useTrigger setInvisibleToPlayer(by_player);	//Hide use triggers
			}
			
			upgradeTrigger setvisibleToPlayer(by_player); //Show upgrade Trigger
			upgradeTrigger thread triggerWaitForTurretUpgradeUsed(self.turretUpgrades[i], by_player);
			self thread busIndicatorAtTurretUpgrade( upgradeTrigger, by_player );
			
		} 
	}
	
	//Update HUD
	by_player.holdingUpgrade = name;
	by_player playerAddUpgradeHud(self.upgrades[name].display);
	
	//Place model on player
	by_player playerAttachUpgradeModel(name);
	
	by_player waittill("turretUpgraded");
	
	by_player.holdingUpgrade = undefined;
	by_player playerDettachUpgradeModel(name);
	by_player playerRemoveUpgradeHud();
}

busIndicatorAtTurretUpgrade( trigger, visibleOnlyToPlayer )
{
	fxent = busIndicatorAtLoc( trigger.origin, visibleOnlyToPlayer );
	level waittill("turretUpgraded");
	fxent Delete();
}

triggerWaitForTurretUpgradeUsed(upgrade, player)
{
	level endon("turretUpgraded");
	self waittill("trigger");
	
	play_sound_at_pos( "grab_metal_bar", player.origin );
	
	upgrade.useModel SetVisibleToAll();
	
	for(i=0; i<upgrade.barricades.size; i++)
	{
		upgrade.barricades[i] SetVisibleToAll();
	}
	
	upgrade.upgradeCount++;
	
	if ( upgrade.upgradeCount == 1 || upgrade.upgradeCount == 2)
	{
		self SetHintString( "Hold [{+activate}] To Upgrade To " + GetTurretNameFromUpgradeCount(upgrade.upgradeCount+1, true)); 
	}
	else
	{
		self SetHintString( "" );
	}
	
	//hide and Show turret models
	{
		prevTurret = upgrade.turrets[GetTurretNameFromUpgradeCount(upgrade.upgradeCount-1)];
		turret = upgrade.turrets[GetTurretNameFromUpgradeCount(upgrade.upgradeCount)];
	
		turret.trigger setVisibleToAll();
		turret.model setVisibleToAll();
		
		if(isDefined(prevTurret))
		{
			//Kick the player off
			if( isdefined( prevTurret.model GetTurretOwner() ) )
			{
				prevTurret.model useby(prevTurret.model GetTurretOwner());
				//Work around for upgrading turrets when another player is useing them
				//Need to wait for player to transition out of the turret
				wait 1.0;
			}
		
			prevTurret.trigger setInvisibleToAll();
			prevTurret.model setInvisibleToAll();
		}
	}
	
	
	for(i=0;i<level.the_bus.turretUpgrades.size;i++)
	{
		//Hide all upgrade triggers
		level.the_bus.turretUpgrades[i].trigger setInvisibleToPlayer(player);
		
		//Enable turret use triggers
		curretTurretName = GetTurretNameFromUpgradeCount(level.the_bus.turretUpgrades[i].upgradeCount);
		if( curretTurretName != "" )
		{
			level.the_bus.turretUpgrades[i].turrets[curretTurretName].trigger setVisibleToAll();
		}
	}
	
	
	player notify("turretUpgraded");
	level notify("turretUpgraded");	//Cancel other trigger upgrade threads
}
busOnAutoTurretPlaced( by_player, name )
{
	level.bus_auto_turret_trigger SetVisibleToAll();
	level.bus_auto_turret_trigger usetriggerrequirelookat();
	level.bus_auto_turret SetVisibleToAll();
	iPrintLnBold("Auto Turret Installed On The Back Of The Bus.");	
}

busOnWeaponUpgradePickedUp( by_player, name )
{
	by_player.holdingBuyableWeaponUpgrade = true;
	
	//Update HUD
	by_player.holdingUpgrade = name;
	by_player playerAddUpgradeHud(self.upgrades[name].display);
	
	if( !isDefined(self.busWeaponFX) )
	{
		self.busWeaponFX = busIndicatorAtLoc( self.buyableWeaponsUpgradeTrigger.origin, by_player );
	}
	if(!isDefined(self.busWeaponFX_count))
	{
		self.busWeaponFX_count = 1;
	}
	else
	{
		self.busWeaponFX_count++;
		self.busWeaponFX setInvisibleToPlayer(by_player, false);
	}
	
	self busUpdateBuyableWeaponTriggers();
	by_player waittill("busWeaponUpgraded");
	
	self.busWeaponFX_count--;
	if(self.busWeaponFX_count==0)
	{
		self.busWeaponFX Delete();
		self.busWeaponFX = undefined;
	}
	else
	{
		self.busWeaponFX setInvisibleToPlayer(by_player, true);
	}
	
	by_player.holdingUpgrade = undefined;
	by_player playerRemoveUpgradeHud();	
	
	by_player.holdingBuyableWeaponUpgrade = false;
	
	self busUpgradeBuyableWeapon();
	self busUpdateBuyableWeaponTriggers();
}

triggerUpgradeBuyableWeapons()
{
	while(1)
	{
		self waittill("trigger", who);
		who notify("busWeaponUpgraded");
		wait .1;
	}
}

busAttachModels( model, origins )
{
	for (i=0; i<origins.size; i++)
	{
		spawnedModel = Spawn( "script_model", (0,0,0) );
		spawnedModel setModel(model);
		spawnedModel linkTo(self, "", origins[i], (0,0,0));
	}
}
busOnBarbedWireLPlaced( by_player, name )
{
	wireOrigins = [];
	wireOrigins[0] = (-164, 88, 24);
	wireOrigins[1] = (46, 86, 24);
	wireOrigins[2] = (150, 84, 24);
	
	self busAttachModels( "p_glo_barbed_wire02", wireOrigins );
	iPrintLnBold("Barbed wire will slow zombies entering the bus.");
}
busOnBarbedWireRPlaced( by_player, name )
{
	wireOrigins = [];
	wireOrigins[0] = (-162, -84, 24);
	wireOrigins[1] = (102, -82, 24);
	
	self busAttachModels( "p_glo_barbed_wire02", wireOrigins );
	iPrintLnBold("Barbed wire will slow zombies entering the bus.");
}
busOnPlatformPlaced( by_player, name )
{
	iPrintLnBold("Platform placed on the back of the bus.");
	iPrintLnBold("Platforms allows hop-ons to use two handed weapons.");
}
busOnPassPickedup( by_player, name )
{
	self busSetKeysTriggerHitText();
	iPrintLnBold("You found a metro pass.  The bus is now free.");
}
busOnMoneyPickedup( by_player, name )
{
	by_player maps\mp\zombies\_zm_score::add_to_player_score( 5000 );

	iPrintLnBold("The bank vault has been raided.");
}
busOnBlockerPickedup( player, name )
{
	busSetPlayerVisibilityForBlockerTriggers(player, true);		// can see blocker triggers until you place this blocker
	
	//Set up hud and prevent player from picking up other things
	player.holdingUpgrade = name;
	player playerAddUpgradeHud(self.upgrades[name].display);
	
	self waittill("OnBlockerPlaced", opening);
	
	player.holdingUpgrade = undefined;
	player playerRemoveUpgradeHud();
	
	for (i=0; i<opening.boards.size; i++)
	{
		opening.boards[i].model Delete();
	}

	opening.blockerTrigger 		Delete();
	opening.zombieTrigger 		Delete();
	opening.rebuildTrigger 		Delete();
	
	
	newModelPos = self GetTagOrigin(opening.bindTag) + (0,0,45);
	newModelPos +=  anglestoforward(self GetTagAngles(opening.bindTag)) * 12.0;
	
	self.upgrades[name].model 	Show();
	self.upgrades[name].model 	linkTo(self, "", self worldToLocalCoords(newModelPos), (0,0,0));

	busSetPlayerVisibilityForBlockerTriggers(player, false);	// can't see blocker triggers again until you pickup a new window
}



//*****************************************************************************
// Keys
//
// Keys are the first "upgrade" you get for the bus.  They allow you to start
// the engine and drive the bus around ("Pay the Fare").
//
//*****************************************************************************
busOnKeysPlaced( by_player, name )
{
	iPrintLnBold("The engine started.");
	playsoundatposition("evt_bus_start", by_player.origin);
	self notify("OnKeysPlaced");
	self busSetKeysTriggerHitText();
	self.keysRouteSelectionZone = undefined;
}

busOnKeysReady( name )
{
	self.upgrades[name].trigger SetVisibleToAll();
	self busSetKeysTriggerHitText();
}

busOnKeysUsed( by_player, name )
{
	bbprint( "zombie_events", "category %s type %s round %d playername %s", "UPGRADE", "purchase", level.round_number, by_player.name );
	
	// Start Moving
	//--------------
	if (!self.upgrades["Pass"].pickedup)
	{
		if (!playerCanAfford(by_player, 250))
		{
			play_sound_at_pos( "no_purchase", by_player.origin );
			return;
		}
	}
	play_sound_at_pos( "purchase", by_player.origin );	
	self.upgrades[name].trigger SetInvisibleToAll();	
	self notify("OnKeysUsed");
	wait(0.5);


	self waittill("KeysEnable");	// keys don't become available again until bus stopps
}

busSetKeysTriggerHitText()
{
	if ( self.upgrades["Pass"].pickedup )
	{
		self.upgrades["Keys"].trigger SetHintString( "Hold [{+activate}] To Ride For Free (Buss Pass)"); 	
	}
	else
	{
		self.upgrades["Keys"].trigger SetHintString( "Hold [{+activate}] To Pay Fare [cost 250]"); 
	}
}


//*****************************************************************************
// Sonic Boom
//*****************************************************************************
busOnSonicBoomReady( name )
{
	self.upgrades[name].trigger SetHintString( "Hold [{+activate}] To Sonic Boom All Zombies [cost 250]"); 
	self.upgrades[name].trigger SetVisibleToAll();	
}

busOnSonicBoomUsed( by_player, name )
{
	if (!playerCanAfford(by_player, 250))
	{
		play_sound_at_pos( "no_purchase", by_player.origin );
		return;
	}
	play_sound_at_pos( "purchase", by_player.origin );
	
	
	zombies = GetAiSpeciesArray( "axis" );
	
	//Play knockdown anim
	for ( i=0; i<zombies.size; i++ )
	{
		if(  Distance2DSquared(zombies[i].origin, self.origin) < 490000 /*700 * 700*/ )
		{
			zombies[i] notify("sonicBoom");
			
			//Reset the windows
			if ( isdefined(zombies[i].opening) )
			{
				zombies[i].opening.zombie = undefined;
				//zombies[i] anim_stopanimscripted();
				zombies[i] UnLink();
				zombies[i] TraverseMode("gravity");
				zombies[i] thread maps\mp\zombies\_zm_ai_basic::find_flesh();
			}
			zombies[i] finishActorDamage( by_player, by_player, 10, 0, "MOD_UNKNOWN", "thundergun_zm", (0,0,0), (1,0,0), "torso_upper", 0, 0 );
		}
		
	}
	
	playsoundatposition("wpn_thundergun_fire_plr", by_player.origin);

	self.upgrades[name].trigger SetInvisibleToAll();	
	wait (20); // cooldown
}
//*****************************************************************************
// Ladder
//*****************************************************************************
busOnLadderReady( name )
{
	self.upgrades[name].trigger SetHintString( "Hold [{+activate}] To Climb"); 
	self.upgrades[name].trigger SetVisibleToAll();	
}

busOnLadderUsed( player, name )
{
	if (player.isOnBusRoof)
	{
		player setOrigin( player.origin + (0,0,-100) );
	}
	else
	{
		player setOrigin( player.origin + (0,0,100) );
	}
	
	self.upgrades[name].trigger SetInvisibleToAll();	
	wait (2);
}

//*****************************************************************************
// Zapper
//*****************************************************************************
busSetZapperUseText( name )
{
	self.upgrades[name].upgrades.useTrigger SetHintString( "Hold [{+activate}] To Zap All Zombies [cost " + self.zapper.cost + "]");	
}
busOnZapperReady( name )
{
	self busSetZapperUseText(name);
	self thread busZapperReadyFX(true, name);
}
busOnZapperPlaced( by_player, name )
{
	self notify("zapper_installed");
	self thread busZapperReadyFX(true, name);
	
}
busZapperReadyFX(isReady,name)
{
	if(isDefined(self.zapperReadyFX))
	{
		self.zapperReadyFX Delete();
	}
	
	offsetFromModelOrigin = self.upgrades[name].model LocalToWorldCoords((0,-10,30)) - self.upgrades[name].model.origin;
	fxOrigin = Spawn( "script_model", self.upgrades[name].model.origin + offsetFromModelOrigin );
	fxOrigin SetModel("tag_origin");
	
	
	fxOrigin linkto(self, "", self worldtolocalcoords(fxOrigin.origin), fxOrigin.angles - self.angles);
				
	//Needed to get 'playfxontag' to properly work, as the setmodel needs a frame.
	wait .05;
	
	if(isReady)
	{
		PlayFXOnTag(level._effect["zapper_light_ready"], fxOrigin, "tag_origin" );
	}
	else
	{
		PlayFXOnTag(level._effect["zapper_light_notready"], fxOrigin, "tag_origin" );	
	}
		
	self.zapperReadyFX = fxOrigin;	
}
busOnZapperUsed( by_player, name )
{
	if (!playerCanAfford(by_player, self.zapper.cost))
	{
		play_sound_at_pos( "no_purchase", by_player.origin );
		return;
	}
	play_sound_at_pos( "purchase", by_player.origin );
	//wait(0.5);
	
	bbprint( "zombie_events", "category %s type %s round %d playername %s", "UPGRADE", "zapper", level.round_number, by_player.name );
		
	//Play fx on the bus
	self thread busZapperBusFX(name);
	
	self.upgrades[name].trigger._trap_type = "electric";
	zombies = GetAiSpeciesArray( "axis" );
	for ( i=0; i<zombies.size; i++ )
	{
		if(  Distance2DSquared(zombies[i].origin, self.origin) < self.zapper.radius * self.zapper.radius )
		{
			self.zapper_kill_count++;
			zombies[i] thread maps\mp\zombies\_zm_traps::zombie_trap_death( self.upgrades[name].trigger, 0/*fire fx chance == 0 */ );
			wait_network_frame();
		}
	}
	
	self thread busZapperPauseZombieSpawning(self.zapper.pauseTime);

	self thread busZapperReadyFX(false, name);
	self.upgrades[name].upgrades.useTrigger SetHintString( "Cooling Down"); 
	wait (self.zapper.cooldown); // cooldown
}

busOnZapperUpgraded( by_player, name )
{
	self.zapper = self.zapperValues[self.upgrades[name].upgrades.count];
	self busSetZapperUseText(name);
}

busZapperPauseZombieSpawning(pauseTime)
{
	//Turn off zombie spawning for a short time
	maps\mp\zm_transit_utility::pause_zombie_spawning();
	wait(pauseTime);
	maps\mp\zm_transit_utility::try_resume_zombie_spawning();
}

busZapperBusFX(name)
{
	//16 possible locations, only 8 will play
	randomFXOrigins = [];
	randomFXOrigins[0] = (-216, -64, 112);
	randomFXOrigins[1] = (-152, -64, 72);
	randomFXOrigins[2] = (0, -72, 64);
	randomFXOrigins[3] = (136, -72, 64);
	randomFXOrigins[4] = (216, -72, 120);
	randomFXOrigins[5] = (224, 0, 72);
	randomFXOrigins[6] = (216, 56, 112);
	randomFXOrigins[7] = (136, 64, 104);
	randomFXOrigins[8] = (0, 64, 80);
	randomFXOrigins[9] = (-152, 64, 64);
	randomFXOrigins[10] = (-224, 64, 80);
	randomFXOrigins[11] = (-144, 8, 128);
	randomFXOrigins[12] = (-16, 8, 128);
	randomFXOrigins[13] = (112, 8, 128);
	randomFXOrigins[14] = (-98, 20, 40);
	randomFXOrigins[15] = (92, -10, 40);
	
	randomFXOrigins = array_randomize(randomFXOrigins);
	
	//Always play Fx in front of the player using the zapper
	randomFXOrigins[0] = (-115, -60, 78);
	
	for(i=0; i<8; i++)
	{
		worldFXOrigin = level.the_bus localtoWorldcoords(randomFXOrigins[i]);
		//self thread zapperFX(worldFXOrigin, randomfloatrange(1.5, 2.5));
	}
	

}

//*****************************************************************************
// Cooler
//*****************************************************************************
//busOnCoolerReady( name )
//{
//	turnOnCoolerTrigger();
//}

//busOnCoolerUsed( player, name )
//{
//	useCooler(player);
//}


//*****************************************************************************
// Tires
//*****************************************************************************


//--------------------------------------------------------
// name: 	initBusTires
// self: 	bus
// return:	nothing
// desc:	initializes all of the bus tires
//--------------------------------------------------------
initBusTires()
{
	self.tires = [];
	
	yLO = self.radius + 10;
	yRO = yLO * -1;
	
	self addTire( "TireFR", ( 138, yRO, 30) );
	self addTire( "TireFL", ( 138, yLO, 30) );
	self addTire( "TireBR", (-138, yRO, 30) );
	self addTire( "TireBL", (-138, yLO, 30) );
	
	self.flatTireChance = 10;
	self.flatTireChanceAccumulation = 0;
	
	/#
	//* AddDebugCommand( "devgui_cmd \"Zombies:1/Bus:14/Tires:8/fix all:1\" \"zombie_devgui tires fix\"\n" );
	//* AddDebugCommand( "devgui_cmd \"Zombies:1/Bus:14/Tires:7/flatten all:2\" \"zombie_devgui tires flatten\"\n" );
	//* AddDebugCommand( "devgui_cmd \"Zombies:1/Bus:14/Tires:7/flat tire chance 100 :3\" \"zombie_devgui tires flat_always\"\n" );
	//* AddDebugCommand( "devgui_cmd \"Zombies:1/Bus:14/Tires:7/flat tire chance 0 :4\" \"zombie_devgui tires flat_never\"\n" );
	#/
}


//--------------------------------------------------------
// name: 	addTire
// self: 	bus
// return:	nothing
// desc:	initializes a specific bus tire
//--------------------------------------------------------
addTire( name, local_offset )
{
	index 		= self.tires.size;
	
	self.tires[index]						= spawnstruct();
	self.tires[index].name					= name;
	self.tires[index].flat					= false;
	self.tires[index].local_offset 			= local_offset;
	self.tires[index].local_location		= self worldtolocalcoords( self GetTagOrigin("tag_origin") ) + local_offset;
	self.tires[index].model					= GetEnt(name, "targetname");
	
	if ( isDefined( self.tires[index].model ) )
	{
		self.tires[index].model 			Hide();
	}
}

//--------------------------------------------------------
// name: 	updateBusTires
// self: 	bus
// return:	nothing
// desc:	waits for all bus tires to be fixed
//--------------------------------------------------------
updateBusTires( zoneName )
{
	if( getNumFlatTires() )
	{
		self selectRandomTires( zoneName );
		self waittill("OnAllTiresPlaced");
	}
}


//--------------------------------------------------------
// name: 	selectRandomTires
// self: 	bus
// return:	nothing
// desc:	places tires in the zone
//--------------------------------------------------------
selectRandomTires( zoneName )
{
	// find and randomize tire locations
	tireLocations = GetStructArray( zoneName + "_tire", "targetname" );
	tireLocations = array_randomize( tireLocations );
	
	if( tireLocations.size < self.tires.size )
	{
		iPrintLnBold("Warning Not Enough Tire Locations in " + zoneName);
		self fixAllTires();
		return;
	}
	
	for( i = 0; i < self.tires.size; i++)
	{
		if( !self.tires[i].flat )
		{
			continue;
		}
		
		// set the tire's location
		self.tires[i].model Show();
		self.tires[i].model.origin = tireLocations[i].origin;
		
		if( IsDefined( tireLocations[i].angles) )
		{
			self.tires[i].model.angles = tireLocations[i].angles;
		}
		
		// setup a trigger for the tire
		self thread tireThreadWatcher( i );
	}
}

//--------------------------------------------------------
// name: 	getNumFlatTires
// self: 	bus
// return:	the number of flat tires on the bus
// desc:	finds the number of flat tires on the bus
//--------------------------------------------------------
getNumFlatTires()
{
	numFlatTires = 0;
	
	if( !IsDefined(self.tires) )
	{
		return numFlatTires;
	}
	
	for( i = 0; i < self.tires.size; i++)
	{
		if( self.tires[i].flat )
		{
			numFlatTires++;
		}
	}
	
	return numFlatTires;
}


//--------------------------------------------------------
// name: 	causeFlatTires
// self: 	bus
// return:	nothing
// desc:	causes the bus to have flat tires
//--------------------------------------------------------
causeFlatTires( numFlatTires, boolPrintMessage )
{
	numFlatTires = Max( 1, numFlatTires );
	flatTireCount = 0;
	randTireIndex = [];
	
	
	// create an array with every tire index
	for( i = 0; i < self.tires.size; i++)
	{
		randTireIndex[i] = i;
	}
	
	randTireIndex = array_randomize( randTireIndex );
	
	for( i = 0; i < self.tires.size; i++)
	{
		index = randTireIndex[i];
		
		if ( !self.tires[index].flat )
		{
			self.tires[index].flat = true;
			flatTireCount++;

			if( flatTireCount == numFlatTires )
			{
				break;
			}
		}
	}
	
	if( boolPrintMessage )
	{
		iPrintLnBold("Flat Tire. Look for better tires.");
	}
}


//--------------------------------------------------------
// name: 	createBusTriggers
// self: 	bus
// return:	nothing
// desc:	creates trigger on the bus for tire placement
//--------------------------------------------------------
createBusTriggers( player )
{	
	for( i = 0; i < self.tires.size; i++ )
	{
		if( !self.tires[i].flat )
		{
			continue;
		}
		
		if( !IsDefined( self.tires[i].busTrigger) )
		{
			// creates a trigger on the flat tire location
			//---------------------------------------------
			world_location 				= level.the_bus localtoworldcoords( self.tires[i].local_location );
			busTrigger 					= Spawn( "trigger_radius_use", world_location, 0, 2, 6 );
			busTrigger 					SetCursorHint( "HINT_NOICON" );
			busTrigger 					SetHintString( "Hold [{+activate}] To Place Tire");
			busTrigger					SetInvisibleToAll();
			busTrigger 					SetInvisibleToPlayer( player, false );
			self.tires[i].busTrigger 	= busTrigger;	
			
			// creates an effect on the flat tire location
			//---------------------------------------------
			fxObj = SpawnFx( level._effect["powerup_on"], world_location );
			triggerfx(fxObj);
			
			fxObj SetInvisibleToAll();
			fxObj SetInvisibleToPlayer( player, false );
			self.tires[i].busTrigger.fxent = fxObj;
			
			self.tires[i] thread busPlacementThreadWatcher();
		}
		else
		{
			self.tires[i].busTrigger 		SetInvisibleToPlayer( player, false );
			self.tires[i].busTrigger.fxent 	SetInvisibleToPlayer( player, false );
		}
		
	}
}


//--------------------------------------------------------
// name: 	tireThreadWatcher
// self: 	bus
// return:	nothing
// desc:	waits for a player to pick up the tire
//--------------------------------------------------------
tireThreadWatcher( tireIndex )
{
	self endon("OnAllTiresPlaced");
	
	if( IsDefined(self.tires[tireIndex].trigger) )
	{
		self.tires[tireIndex].trigger delete();
	}
		
	// create a trigger on the tire model
	//---------------------------------------------
	triggerOrigin	= self.tires[tireIndex].model.origin + ( 0, 0, 12 );
	tireTrigger 	= Spawn( "trigger_radius_use", triggerOrigin , 0, 16, 16 );
	tireTrigger 	SetCursorHint( "HINT_NOICON" );
	tireTrigger 	SetHintString( "Hold [{+activate}] To Pick Up Tire");
	
	self.tires[tireIndex].trigger 	= tireTrigger;
	
	
	// Wait For A Player To Pick Up Tire
	//-----------------------------------
	while (1)
	{
		self.tires[tireIndex].trigger waittill("trigger", player);
		if (IsDefined(player.holdingUpgrade))
		{
			wait(0.2);
			continue;
		}
		break;
	}
	
	// remove the tire
	self.tires[tireIndex].model 	Hide();
	self.tires[tireIndex].trigger 	delete();
	
	play_sound_at_pos( "grab_metal_bar", player.origin );
	
	// give the player the tire
	player attach(self.tires[tireIndex].model.model, "j_spineupper", true);
	player.attachedTireModel = tireIndex;
	player.holdingUpgrade = self.tires[tireIndex].name;
	player playerAddUpgradeHud("Tire");
	
	// setup the triggers on the bus
	self createBusTriggers( player );
}


//--------------------------------------------------------
// name: 	busPlacementThreadWatcher
// self: 	a bus tire
// return:	nothing
// desc:	waits for the tire to be placed on the bus
//--------------------------------------------------------
busPlacementThreadWatcher()
{
	level.the_bus endon("OnAllTiresPlaced");
	
	// Wait For A Player To Replace The Tire
	//-----------------------------------------
	while (1)
	{
		self.busTrigger waittill( "trigger", player );
		if ( !IsDefined(player.holdingUpgrade))
		{
			wait(0.2);
			continue;
		}
		break;
	}
		
	// tire fixed
	self.flat = false;
	
	// bus trigger clean up
	self.busTrigger.fxent delete();
	self.busTrigger delete();
	
	for( i = 0; i < level.the_bus.tires.size; i++)
	{
		if ( !level.the_bus.tires[i].flat )
		{
			continue;
		}
		
		if( IsDefined(level.the_bus.tires[i].busTrigger) )
		{
			level.the_bus.tires[i].busTrigger 		SetInvisibleToPlayer( player );
			level.the_bus.tires[i].busTrigger.fxent SetInvisibleToPlayer( player );
		}
	}
	
	// update the player
	player.holdingUpgrade = undefined;
	player detach( self.model.model, "j_spineupper");
	player.attachedTireModel = undefined;
	
	if( IsDefined(player.upgradeHud) )
	{
		player.upgradeHud Destroy();
	}
	
	level.the_bus onTirePlaced( player );
}

//--------------------------------------------------------
// name: 	fixAllTires
// self: 	bus
// return:	nothing
// desc:	dev gui function to fix all tires
//--------------------------------------------------------
fixAllTires()
{
	players = GET_PLAYERS();
	
	// remove any tires the players may have picked up
	for( i = 0; i < players.size; i++ )
	{
		if( IsDefined(players[i].attachedTireModel) )
		{
			players[i] detach( self.tires[players[i].attachedTireModel].model.model, "j_spineupper");
			players[i].attachedTireModel = undefined;
			players[i].holdingUpgrade = undefined;
			
			if( IsDefined(players[i].upgradeHud) )
			{
				players[i].upgradeHud Destroy();
			}
		}
	}
	
	// disable all the active triggers
	for( i = 0; i < self.tires.size; i++)
	{
		self.tires[i].model Hide();
		self.tires[i].flat = false;
		
		// disable tire triggers
		if( IsDefined(self.tires[i].trigger) )
		{
			self.tires[i].trigger delete();
		}
		
		// disable bus triggers
		if( IsDefined(self.tires[i].busTrigger) )
		{
			if( IsDefined(self.tires[i].busTrigger.fxent) )
			{
				self.tires[i].busTrigger.fxent delete();
			}
			
			self.tires[i].busTrigger delete();
		}
	}
	
	iPrintLnBold("Cheater!");
	self notify("OnAllTiresPlaced");
}


//--------------------------------------------------------
// name: 	flattenAllTires
// self: 	bus
// return:	nothing
// desc:	dev gui function to flatten all tires
//--------------------------------------------------------
flattenAllTires( zoneName )
{
	self causeFlatTires( 4, true );
	self selectRandomTires( zoneName );
}

//--------------------------------------------------------
// name: 	chanceToFlattenTires
// self: 	bus
// return:	nothing
// desc:	random chance of causing a flat tire
//--------------------------------------------------------
chanceToFlattenTires( percentageInt )
{
	randomFlat = randomint( 100 );
	
	self.flatTireChanceAccumulation = self.flatTireChanceAccumulation + percentageInt;
	
	if( randomFlat < self.flatTireChanceAccumulation)
	{
		self causeFlatTires( 1, true );
		self.flatTireChanceAccumulation = 0;
	}
}


//--------------------------------------------------------
// name: 	onTirePlaced
// self: 	bus
// return:	nothing
// desc:	sends notify when all the tires are fixed
//--------------------------------------------------------
onTirePlaced( by_player )
{
	playsoundatposition("evt_bus_replace_tire", by_player.origin);
	
	switch ( getNumFlatTires() )
	{
		case 0:
			iPrintLnBold("All tires fixed.  Let's Roll.");
			self notify("OnAllTiresPlaced");
			break;
		case 1:
			iPrintLnBold("1 More Tire");
			break;
		case 2:
			iPrintLnBold("2 More Tires");
			break;
		case 3:
			iPrintLnBold("3 More Tires");
			break;
		default:
			iPrintLnBold("4 More Tires");
			break;
	}

}
