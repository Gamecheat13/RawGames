#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Deathmatch
	Objective: 	Score points by eliminating other players
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
			game["axis"] = "opfor";
			Because Deathmatch doesn't have teams with regard to gameplay or scoring, this effectively sets the available weapons.

		If using minefields or exploders:
			maps\mp\_load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["american_soldiertype"] = "normandy";
			game["german_soldiertype"] = "normandy";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				american_soldiertype	normandy
				british_soldiertype		normandy, africa
				russian_soldiertype		coats, padded
				german_soldiertype		normandy, africa, winterlight, winterdark
*/

/*QUAKED mp_dm_spawn (1.0 0.5 0.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies at one of these positions.*/

main()
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 8, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 100, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 10 );

	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	
	level.pointMultiplier = 40;

	maps\mp\gametypes\_globallogic::findMapCenter();
}


onStartGameType()
{
	if ( getdvar( "scr_os_pickupweaponrespawntime" ) == "" )
		setdvar( "scr_os_pickupweaponrespawntime", "5" );
	level.pickupWeaponRespawnTime = getdvarfloat( "scr_os_pickupweaponrespawntime" );

	if ( getdvar( "scr_os_pickupperkrespawntime" ) == "" )
		setdvar( "scr_os_pickupperkrespawntime", "25" );
	level.pickupPerkRespawnTime = getdvarfloat( "scr_os_pickupperkrespawntime" );

	thread initPickups();

	oldschoolLoadout = spawnstruct();
	oldschoolLoadout.primaryWeapon = "saf45_mp";
	oldschoolLoadout.secondaryWeapon = "glock_18_mp";

	oldschoolLoadout.inventoryWeapon = "";
	oldschoolLoadout.inventoryWeaponAmmo = 0;
	
	//grenade types: "", "frag", "smoke", "flash"
	oldschoolLoadout.grenadeTypePrimary = "frag";
	oldschoolLoadout.grenadeCountPrimary = 1;
	
	oldschoolLoadout.grenadeTypeSecondary = "";
	oldschoolLoadout.grenadeCountSecondary = 0;
	
	level.oldschoolLoadout = oldschoolLoadout;
	
	// mp_player_join
	level.oldschoolPickupSound = "oldschool_pickup";
	level.oldschoolRespawnSound = "oldschool_return";



	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_DM" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_DM" );

	maps\mp\gametypes\_globallogic::setObjectiveMenuText( "allies", "OBJECTIVES_DM" );
	maps\mp\gametypes\_globallogic::setObjectiveMenuText( "axis", "OBJECTIVES_DM" );

	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_DM" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_DM" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_DM_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_DM_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_DM_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_DM_HINT" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );

	level.spawnpoints = getentarray("mp_dm_spawn", "classname");

	allowed[0] = "os";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	level.QuickMessageToAll = true;
}

spawnClient()
{
	self endon ( "disconnect" );
	self endon ( "end_respawn" );

	if ( game["state"] == "prematch" )
	{
		self thread	[[level.spawnPlayer]]();
		return;
	}

	respawnDelay = 0;
	respawnTime = 0;

	// TODO
	//respawnDelay += suicide or teamkill penalty
	
	remainingTime = 0;

	if ( level.numLives )
	{
		// disallow spawning for late comers
		if ( !level.inGracePeriod && !self.hasSpawned )
			self.canSpawn = false;
		else if ( !self.pers["lives"] )
			self.canSpawn = false;
	}

	if ( !self.canSpawn )
	{
		currentorigin =	self.origin;
		currentangles =	self.angles;

		// respawn next round text
		setLowerMessage( &"MP_SPAWN_NEXT_ROUND" );
		self thread	[[level.spawnSpectator]]( currentorigin	+ (0, 0, 60), currentangles	);
		return;
	}

	if ( respawnTime && (!level.inGracePeriod || self.hasSpawned) )
	{
		if ( respawnDelay > remainingTime )
		{
			setLowerMessage( &"MP_WAITING_TO_SPAWN", respawnTime + remainingTime );
			wait( respawnDelay );
		}
		else
		{
			setLowerMessage( &"MP_WAITING_TO_SPAWN", level.waveDelay[self.pers["team"]] - (getTime() - level.lastWave[self.pers["team"]]) / 1000 );
		}

		if ( self.pers["team"] == "allies" )
			level waittill ( "wave_respawn_allies" );
		else if	( self.pers["team"]	== "axis" )
			level waittill ( "wave_respawn_axis" );		
	}
	
	else if ( respawnDelay && (!level.inGracePeriod || self.hasSpawned) )
	{
		setLowerMessage( &"MP_WAITING_TO_SPAWN", respawnDelay );
		wait ( respawnDelay );
	}

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "player", "forcerespawn" ) == 0 && self.hasSpawned && !respawnTime )
	{
		setLowerMessage( &"PLATFORM_PRESS_TO_SPAWN" );
		self waitRespawnButton();
	}
		
	self setLowerMessage( "" );
	self thread	[[level.spawnPlayer]]();
}


onSpawnPlayer()
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );

	self spawn( spawnPoint.origin, spawnPoint.angles );
}

giveLoadout()
{
	assert( isdefined( level.oldschoolLoadout ) );
	
	loadout = level.oldschoolLoadout;
	
	primaryTokens = strtok( loadout.primaryWeapon, "_" );
	self.pers["primaryWeapon"] = primaryTokens[0];
	
	//self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );		
	
	//self GiveWeapon( loadout.primaryWeapon );
	//self giveStartAmmo( loadout.primaryWeapon );
	//self setSpawnWeapon( loadout.primaryWeapon );
	
	// give secondary weapon
	self GiveWeapon( loadout.secondaryWeapon );
	self giveStartAmmo( loadout.secondaryWeapon );
	self setSpawnWeapon( loadout.secondaryWeapon );

}


playSoundinSpace( alias, origin )
{
	org = spawn( "script_origin", origin );
	org.origin = origin;
	org playSound( alias );
	wait 10; // MP doesn't have "sounddone" notifies =(
	org delete();
}

deletePickups()
{
	pickups = getentarray( "oldschool_pickup", "targetname" );
	
	for ( i = 0; i < pickups.size; i++ )
	{
		if ( isdefined( pickups[i].target ) )
			getent( pickups[i].target, "targetname" ) delete();
		pickups[i] delete();
	}
}

initPickups()
{
	level.pickupAvailableEffect = loadfx( "impacts/small_dust_impact" );
	level.pickupUnavailableEffect = loadfx( "impacts/small_dust_impact" );
	
	wait .5; // so all pickups have a chance to spawn and drop to the ground
	
	pickups = getentarray( "oldschool_pickup", "targetname" );
	
	for ( i = 0; i < pickups.size; i++ )
		thread trackPickup( pickups[i], i );
}

spawnPickupFX( groundpoint, fx )
{
	effect = spawnFx( fx, groundpoint, (0,0,1), (1,0,0) );
	triggerFx( effect );
	
	return effect;
}

playEffectShortly( fx )
{
	self endon("death");
	wait .05;
	playFxOnTag( fx, self, "tag_origin" );
}

getPickupGroundpoint( pickup )
{
	trace = bullettrace( pickup.origin, pickup.origin + (0,0,-128), false, pickup );
	groundpoint = trace["position"];
	
	finalz = groundpoint[2];
	
	for ( radiusCounter = 1; radiusCounter <= 3; radiusCounter++ )
	{
		radius = radiusCounter / 3.0 * 50;
		
		for ( angleCounter = 0; angleCounter < 10; angleCounter++ )
		{
			angle = angleCounter / 10.0 * 360.0;
			
			pos = pickup.origin + (cos(angle), sin(angle), 0) * radius;
			
			trace = bullettrace( pos, pos + (0,0,-128), false, pickup );
			hitpos = trace["position"];
			
			if ( hitpos[2] > finalz && hitpos[2] < groundpoint[2] + 15 )
				finalz = hitpos[2];
		}
	}
	return (groundpoint[0], groundpoint[1], finalz);
}

trackPickup( pickup, id )
{
	groundpoint = getPickupGroundpoint( pickup );
	
	effectObj = spawnPickupFX( groundpoint, level.pickupAvailableEffect );
	
	classname = pickup.classname;
	origin = pickup.origin;
	angles = pickup.angles;
	spawnflags = pickup.spawnflags;
	model = pickup.model;
	
	isWeapon = false;
	isPerk = false;
	weapname = undefined;
	perk = undefined;
	trig = undefined;
	respawnTime = undefined;

	if ( issubstr( classname, "weapon_" ) )
	{
		isWeapon = true;
		weapname = pickup maps\mp\gametypes\_weapons::getItemWeaponName();
		respawnTime = level.pickupWeaponRespawnTime;
	}
	else if ( classname == "script_model" )
	{
		isPerk = true;
		perk = pickup.script_noteworthy;
		for ( i = 0; i < level.validPerks.size; i++ )
		{
			if ( level.validPerks[i] == perk )
				break;
		}
		if ( i == level.validPerks.size )
		{
			maps\mp\_utility::error( "oldschool_pickup with classname script_model does not have script_noteworthy set to a valid perk" );
			return;
		}
		trig = getent( pickup.target, "targetname" );
		respawnTime = level.pickupPerkRespawnTime;
		
		if ( !getDvarInt( "scr_game_perks" ) )
		{
			pickup delete();
			trig delete();
			effectObj delete();
			return;
		}
		
		if ( isDefined( level.perkPickupHints[ perk ] ) )
			trig setHintString( level.perkPickupHints[ perk ] );
	}
	else
	{
		maps\mp\_utility::error( "oldschool_pickup with classname " + classname + " is not supported (at location " + pickup.origin + ")" );
		return;
	}
	
	if ( isDefined( pickup.script_delay ) )
		respawnTime = pickup.script_delay;
	
	while(1)
	{
		pickup thread spinPickup();
		
		player = undefined;
		
		if ( isWeapon )
		{
			//pickup thread changeSecondaryGrenadeType( weapname );
			pickup setPickupStartAmmo( weapname );
			
			while(1)
			{
				pickup waittill( "trigger", player, dropped );
				
				if ( !isdefined( pickup ) )
					break;
				
				// player only picked up ammo. the pickup still remains.
				assert( !isdefined( dropped ) );
			}
			
			if ( isdefined( dropped ) )
			{
				// delete the weapon we dropped immediately
				dropped delete();
			}
		}
		else
		{
			assert( isPerk );
			
			/*
			while(1)
			{
				trig waittill( "trigger", player );
				if ( !player hasPerk( perk ) )
					break;
			}
			*/
			
			trig waittill( "trigger", player );
			
			pickup delete();
			trig triggerOff();
		}
		
		
		if ( isWeapon )
		{
			if ( weaponInventoryType( weapname ) == "item" && (!isdefined( player.inventoryWeapon ) || weapname != player.inventoryWeapon) )
			{
				player GiveWeapon( weapname );
			}
		}
		
		else
		{
			assert( isPerk );
			
			if ( !player hasPerk( perk ) )
			{
				//player setPerk( perk );
				//player showPerk( player.numperks, perk, -50 );
				//player thread hidePerkNameAfterTime( player.numperks, 3.0 );
				
				//player.numPerks++;
			}
		}
		
		
		thread playSoundinSpace( level.oldschoolPickupSound, origin );
		
		effectObj delete();
		effectObj = spawnPickupFX( groundpoint, level.pickupUnavailableEffect );
		
		wait respawnTime;
		
		pickup = spawn( classname, origin, spawnflags );
		pickup.angles = angles;
		if ( isPerk )
		{
			pickup setModel( model );
			trig triggerOn();
		}
		
		pickup playSound( level.oldschoolRespawnSound );
		
		effectObj delete();
		effectObj = spawnPickupFX( groundpoint, level.pickupAvailableEffect );
	}
}

setPickupStartAmmo( weapname )
{
	curweapname = weapname;
	allammo = weaponStartAmmo( curweapname );
	clipammo = weaponClipSize( curweapname );
		
	reserveammo = 0;
	if ( clipammo >= allammo )
	{
		clipammo = allammo;
	}
	else
	{
		reserveammo = allammo - clipammo;
	}
	
	self itemWeaponSetAmmo( clipammo, reserveammo, weapname );
}

changeSecondaryGrenadeType( weapname )
{
	/*
	self endon("trigger");
	
	if ( weapname != level.weapons["smoke"] && weapname != level.weapons["flash"] && weapname != level.weapons["concussion"] )
		return;
	
	offhandClass = "smoke";
	if ( weapname == level.weapons["flash"] )
		offhandClass = "flash";
	
	trig = spawn( "trigger_radius", self.origin - (0,0,20), 0, 128, 64 );
	self thread deleteTriggerWhenPickedUp( trig );
	
	while(1)
	{
		trig waittill( "trigger", player );
		if ( player getWeaponAmmoTotal( level.weapons["smoke"] ) == 0 && 
			player getWeaponAmmoTotal( level.weapons["flash"] ) == 0 && 
			player getWeaponAmmoTotal( level.weapons["concussion"] ) == 0 )
		{
			player setOffhandSecondaryClass( offhandClass );
		}
	}
	*/
}

deleteTriggerWhenPickedUp( trig )
{
	self waittill("trigger");
	trig delete();
}

resetActionSlotToAltMode( weapname )
{
	self notify("resetting_action_slot_to_alt_mode");
	self endon("resetting_action_slot_to_alt_mode");
	
	while(1)
	{
		if ( self getWeaponAmmoTotal( weapname ) == 0 )
		{
			curweap = self getCurrentWeapon();
			if ( curweap != weapname && curweap != "none" )
				break;
		}
		wait .2;
	}
	
	self removeInventoryWeapon();
	self SetActionSlot( 3, "altmode" );
}

getWeaponAmmoTotal( weapname )
{
	return self getWeaponAmmoClip( weapname ) + self getWeaponAmmoStock( weapname );
}

removeInventoryWeapon()
{
	if ( isDefined( self.inventoryWeapon ) )
		self takeWeapon( self.inventoryWeapon );
	self.inventoryWeapon = undefined;
}

spinPickup()
{
	if ( self.spawnflags & 2 || self.classname == "script_model" )
	{
		self endon("death");
		
		org = spawn( "script_origin", self.origin );
		org endon("death");
		
		self linkto( org );
		self thread deleteOnDeath( org );
		
		while(1)
		{
			org rotateyaw( 360, 3, 0, 0 );
			wait 2.9;
		}
	}
}

deleteOnDeath( ent )
{
	ent endon("death");
	self waittill("death");
	ent delete();
}

delayedDeletion( delay )
{
	self thread delayedDeletionOnSwappedWeapons( delay );
	
	wait delay;
	
	if ( isDefined( self ) )
	{
		self notify("death");
		self delete();
	}
}

delayedDeletionOnSwappedWeapons( delay )
{
	self endon("death");
	while(1)
	{
		self waittill( "trigger", player, dropped );
		if ( isdefined( dropped ) )
			break;
	}
	dropped thread delayedDeletion( delay );
}