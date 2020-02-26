//
// file: ber3_util.gsc
// description: utility script for berlin3 and berlin3b
// scripter: slayback
//
#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

// ----------------
//     COOP/PLAYER
// ----------------
get_playerone()
{
	return get_players()[0];
}

// returns the "average" of all players' origins 
get_players_avg_origin()
{
	players = get_players();
	
	meanX = 0;
	meanY = 0;
	meanZ = 0;
	
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		meanX += player.origin[0];
		meanY += player.origin[1];
		meanZ += player.origin[2];
	}
	
	meanX /= players.size;
	meanY /= players.size;
	meanZ /= players.size;
	
	return ( meanX, meanY, meanZ );
}

// self = a player
take_player_weapons()
{
	self.weaponInventory = self GetWeaponsList();
	self.lastActiveWeapon = self GetCurrentWeapon();
	//ASSERTEX( self.lastActiveWeapon != "none", "Last active weapon is 'none,' an unexpected result." );
	
	self.weaponAmmo = [];
	
	for( i = 0; i < self.weaponInventory.size; i++ )
	{
		weapon = self.weaponInventory[i];
		
		self.weaponAmmo[weapon]["clip"] = self GetWeaponAmmoClip( weapon );
		self.weaponAmmo[weapon]["stock"] = self GetWeaponAmmoStock( weapon );
	}
	
	self TakeAllWeapons();
}

// self = a player
giveback_player_weapons()
{
	ASSERTEX( IsDefined( self.weaponInventory ), "player.weaponInventory is not defined - did you run take_player_weapons() first?" );
	
	for( i = 0; i < self.weaponInventory.size; i++ )
	{
		weapon = self.weaponInventory[i];
		
		self GiveWeapon( weapon );
		self SetWeaponAmmoClip( weapon, self.weaponAmmo[weapon]["clip"] );
		self SetWeaponAmmoStock( weapon, self.weaponAmmo[weapon]["stock"] );
	}
	
	// if we can't figure out what the last active weapon was, try to switch a primary weapon
	if( self.lastActiveWeapon != "none" )
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

waittill_okToSpawn()
{
	while( !OkToSpawn() )
	{
		wait( 0.05 );
	}
}

generic_rumble_explosion()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self PlayRumbleOnEntity( "explosion_generic_no_broadcast" );
}

// --------------
// AI MANAGEMENT
// --------------

// Grab starting AI, probably heroes
grab_starting_friends()
{
	startguys = GetEntArray( "starting_allies", "targetname" );
	ASSERT( IsDefined( startguys ) && startguys.size > 0, "grab_starting_guys(): can't find the starting guys!" );
	
	return startguys;
}

// renames a friendly.
//  newName: the name
//  doWait: if calling at level start, set to true so that you override _name::get_name() 
rename_friendly( newName, doWait )
{
	if( IsDefined( doWait ) && doWait == true )
	{
		self waittill("set name and rank" );
	}
	
	self.name = newName;
}

// sets the current color chain (Guzzo status)
set_color_chain( trigTN )
{
	color_trigger = GetEnt( trigTN, "targetname" );
	ASSERTEX( IsDefined( color_trigger ), "color_trigger " + trigTN + " is not defined!" );
	
	color_trigger notify( "trigger" );
}


// adds self to level.friends
friend_add()
{
	if( !IsDefined( level.friends ) )
	{
		level.friends = [];
	}
	
	if( !IsAlive( self ) )
	{
		ASSERTMSG( "Tried to add a guy to level.friends but the entity is not alive." );
		return;
	}
	
	// don't add twice
	if( level.friends array_contains_element( self ) )
	{
		return;
	}
	
	level.friends = array_add( level.friends, self );
	
	self SetThreatBiasGroup( "friends" );
	self thread friend_remove_on_death();
}

// removes a guy from level.friends when he dies
// self = the guy
friend_remove_on_death()
{
	self waittill( "death" );
	level thread friend_remove( self );
}

// removes a guy from level.friends
friend_remove( guy )
{
	if( IsDefined( level.friends ) )
	{
		level.friends = array_remove( level.friends, guy );
	}
}

// grabs all the AIs in level.friends
// includeSarge = optionally, you can choose to not return an AI who is level.sarge
get_friends( includeSarge )
{
	if( !IsDefined( includeSarge ) )
	{
		includeSarge = false;
	}
	
	friends = [];
	
	for( i = 0; i < level.friends.size; i++ )
	{
		guy = level.friends[i];
		if( is_active_ai( guy ) )
		{
			if( !includeSarge && ( guy == level.sarge ) )
			{
				continue;
			}
			else
			{
				friends[friends.size] = guy;
			}
		}
	}
	
	return friends;
}

// returns an array of guys from level.friends who match the color you pass in
get_friends_by_color( colorCode )
{
	colorguys = [];
	
	for( i = 0; i < level.friends.size; i++ )
	{
		guy = level.friends[i];
		
		if( guy check_force_color( colorCode ) )
		{
			colorguys[colorguys.size] = guy;
		}
	}
	
	return colorguys;
}

get_allies_by_color( colorCode )
{
	colorguys = [];
	
	allies = GetAIArray( "allies" );
	
	for( i = 0; i < allies.size; i++ )
	{
		if( allies[i] check_force_color( colorCode ) )
		{
			colorguys[colorguys.size] = allies[i];
		}
	}
	
	return colorguys;
}

// self = an AI
ignore_til_goal( timeout )
{
	self endon( "death" );
	
	self.ignoreall = true;
	
	if( IsDefined( timeout ) )
	{
		self waittill_notify_or_timeout( "goal", timeout );
	}
	else
	{
		self waittill( "goal" );
	}
	
	self.ignoreall = false;
}

// self = an AI
ignore_til_path_end()
{
	self endon( "death" );
	
	self thread disable_arrivalsandexits_til_lastnode();
	
	self.ignoreall = true;
	self waittill( "reached_path_end" );
	self.ignoreall = false;
}

// self = an AI
ignore_til_path_end_or_dmg()
{
	self endon( "death" );
	
	self thread disable_arrivalsandexits_til_lastnode();
	
	self.ignoreall = true;
	self waittill_either( "reached_path_end", "damage" );
	self.ignoreall = false;
}

// self = an AI
disable_arrivalsandexits_til_lastnode()
{
	self endon( "death" );
	self endon( "arrivalsandexits_enabled" );
	
	self.disableArrivals = true;
	self.disableExits = true;
	
	self thread disable_arrivalsandexits_dmg_watcher();
	
	node = GetNode( self.target, "targetname" );
	while( IsDefined( node.target ) )
	{
		self waittill( "goal" );
		node = GetNode( node.target, "targetname" );
	}
	
	self.disableArrivals = false;
	self.disableExits = false;
}

disable_arrivalsandexits_dmg_watcher()
{
	self endon( "death" );
	self endon( "reached_path_end" );
	
	self waittill( "damage" );
	self notify( "arrivalsandexits_enabled" );
	
	self.disableArrivals = false;
	self.disableExits = false;
}

// returns an array of spawned AIs
get_spawners_and_spawn_group( spawnerVal, spawnerKey )
{
	spawners = GetEntArray( spawnerVal, spawnerKey );
	
	if( !IsDefined( spawners ) || spawners.size <= 0 )
	{
		ASSERTMSG( "get_spawners_and_spawn_group(): couldn't find spawners with KVP of " + spawnerKey + "/" + spawnerVal );
		return;
	}
	
	return spawn_group( spawners );
}

// thread this if you need an instantaneous return, because spawning a guy might take some time
// returns an array of spawned AIs
spawn_group( spawners )
{
	if( !IsDefined( spawners ) || spawners.size <= 0 )
	{
		ASSERTMSG( "spawn_group: spawners array was empty or undefined." );
		return;
	}
	
	guys = [];
	
	for( i = 0; i < spawners.size; i++ )
	{
		if( IsDefined( spawners[i] ) )
		{
			guy = spawn_guy( spawners[i] );
			
			if( IsDefined( guy ) )
			{
				guys[guys.size] = guy;
			}
		}
	}
	
	if( guys.size <= 0 )
	{
		ASSERTMSG( "spawn_group: couldn't spawn anybody from the spawners provided.  do they need to be forcespawned?" );
	}
	
	return guys;
}

// spawns a guy
// spawner = the spawner to spawn a guy from
spawn_guy( spawner )
{
	spawnedGuy = spawner StalingradSpawn();
	spawn_failed (spawnedGuy);
	ASSERT( IsDefined( spawnedGuy ) );

	return spawnedGuy;
}

get_closest_from_group( testOrg, group, excludeMe, backup_spawner )
{
	doExclude = IsDefined( excludeMe );
	
	closest = undefined;
	
	for( i = 0; i < group.size; i++ )
	{
		if( !IsDefined( group[i] ) )
		{
			continue;
		}
		
		if( IsDefined( closest ) )
		{
			if( Closer( testOrg, group[i].origin, closest.origin ) )
			{
				if( doExclude )
				{
					if( group[i] != excludeMe )
					{
						closest = group[i];
					}
				}
				else
				{
					closest = group[i];
				}
			}
		}
		else
		{
			if( doExclude )
			{
				if( group[i] != excludeMe )
				{
					closest = group[i];
				}
			}
			else
			{
				closest = group[i];
			}
		}
	}

	//ASSERTEX( IsDefined( closest ), "Couldn't find an entity close to origin " + testOrg );
	if( !IsDefined( closest ) )
	{
		if( isdefined( backup_spawner ) )
		{
			// cannot find a closest, but we need an AI no matter what. Just spawn a new one
			spawner = getent( backup_spawner, "targetname" );
			spawnedGuy = spawner StalingradSpawn();
			spawn_failed (spawnedGuy);
			return spawnedGuy;
		}
	}
	
	return closest;
}

// returns a random friendly
get_randomfriend()
{
	while( 1 )
	{
		guy = level.friends[RandomInt( level.friends.size )];
		
		if( is_active_ai( guy ) )
		{
			return guy;
		}
		else
		{
			wait( 0.05 );
		}
	}
}

// returns a random friendly, excluding thisGuy
get_randomfriend_excluding( thisGuy )
{
	newguy = thisGuy;
	
	while( newguy == thisGuy && is_active_ai( thisGuy ) )
	{
		newguy = get_randomfriend();
		
		if( newguy == thisGuy )
		{
			wait( 0.05 );
		}
	}
	
	// in case thisGuy died while the loop was running
	if( !is_active_ai( thisGuy ) )
	{
		newguy = get_randomfriend();
	}
	
	return newguy;
}

// returns a random friendly, excluding level.sarge
get_randomfriend_notsarge()
{
	return get_randomfriend_excluding( level.sarge );
}

// returns a random friendly, excluding thisGuy and level.sarge
get_randomfriend_notsarge_excluding( thisGuy )
{
	newguy = thisGuy;
	
	while( newguy == thisGuy )
	{
		newguy = get_randomfriend_excluding( thisGuy );
		
		// if we got sarge, just reset
		if( newguy == level.sarge )
		{
			newguy = thisGuy;
		}
		
		if( newguy == thisGuy )
		{
			wait( 0.05 );
		}
	}
	
	return newguy;
}

playsound_generic_facial( sound, priority, lookTarget )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	if( !IsDefined( priority ) )
	{
		priority = 1.0;
	}
	
	notifyString = "sound_done";
	self thread anim_facialFiller( notifyString, lookTarget );
	self animscripts\face::SaySpecificDialogue( undefined, sound, priority, notifyString );
	self waittill( notifyString );
}

sarge_giveorder_soundonly( order, waitForEnd )
{
	level.sarge say_dialogue( "sarge", order, waitForEnd, undefined, true );
}

sarge_giveorder( order, waitForEnd )
{
	level.sarge say_dialogue( "sarge", order, waitForEnd );
}

// plays dialogue from a random friendly
say_dialogue_randomfriend( animname, theLine, waitForEnd )
{
	speaker = get_randomfriend();
	
	
	speaker say_dialogue( animname, theLine, waitForEnd );
}

// plays dialogue from a random friendly who isn't the sarge
say_dialogue_notsarge( animname, theLine, waitForEnd )
{
	// get someone other than sarge
	speaker = get_randomfriend_notsarge();
	
	speaker say_dialogue( animname, theLine, waitForEnd );
}

// plays dialogue from a specific AI
// self = the AI to speak
// waitForEnd = should we wait until the line is done before returning?
// giveMagicBulletShield = should we make the AI invincible while he's talking?
// soundOnly = are we only playing the sound?
//
// TODO make sure the guy can only say one line at a time
say_dialogue( animname, theLine, waitForEnd, giveMagicBulletShield, soundOnly )
{
	ASSERTEX( is_active_ai( self ), "play_dialogue(): the entity that's supposed to be speaking is not an active AI." );
	
	if( !IsDefined( waitForEnd ) )
	{
		waitForEnd = false;
	}
	
	if( !IsDefined( giveMagicBulletShield ) )
	{
		giveMagicBulletShield = true;
	}
	
	if( !IsDefined( soundOnly ) )
	{
		soundOnly = false;
	}
	
	if( !soundOnly )
	{
		self.og_animname = self.animname;
		self.animname = animname;
	}
	
	
	if( giveMagicBulletShield )
	{
		// don't want to mess up previously scripted values
		if( !IsDefined( self.magic_bullet_shield ) || !self.magic_bullet_shield )
		{
			self thread magic_bullet_shield();
			self.say_dialogue_bullet_shield = true;
		}
	}
	
	if( is_active_ai( self ) )
	{	
		if( !soundOnly )
		{
			self thread anim_single_solo( self, theLine );
		}
		else
		{
			self thread animscripts\face::SaySpecificDialogue( undefined, level.scr_sound[animname][theLine], 1.0, "soundOnly_done" );
		}
	}
	
	if( waitForEnd )
	{
		if( !soundOnly )
		{
			self waittill( theLine );
		}
		else
		{
			self waittill( "soundOnly_done" );
		}
	}
	
	if( !soundOnly )
	{
		self.animname = self.og_animname;
	}
	
	if( giveMagicBulletShield )
	{
		if( IsDefined( self.say_dialogue_bullet_shield ) && self.say_dialogue_bullet_shield )
		{
			self notify( "stop magic bullet shield" );
		}
	}
}

set_animname_custom( newAnimname )
{
	self.ogAnimname = self.animname;
	self.animname = newAnimname;
}

reset_animname()
{
	if( !IsDefined( self.ogAnimname ) )
	{
		return;
	}
	
	self.animname = self.ogAnimname;
	self.ogAnimname = undefined;
}

// wrapper for magic_bullet_shield
magic_bullet_shield_safe()
{
	if( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
	{
		return;
	}
	
	self thread magic_bullet_shield();
}

// wrapper for stop_magic_bullet_shield
stop_magic_bullet_shield_safe()
{
	if( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
	{
		self thread stop_magic_bullet_shield();
	}
}

scr_ignoreme( b )
{
	if( IsDefined( self ) )
	{
		self.ignoreme = b;
	}
}

scr_ignoreall( b )
{
	if( IsDefined( self ) )
	{
		self.ignoreall = b;
	}
}

scr_reset_goalradius()
{
	if( IsDefined( self ) && IsDefined( self.og_goalradius ) )
	{
		self.goalradius = self.og_goalradius;
	}
}


// grabs triggers and does stuff to them
trigger_setup()
{
	fs_trigs = GetEntArray( "flood_spawner", "targetname" );

	for( i = 0; i < fs_trigs.size; i++ )
	{
		if( IsDefined( fs_trigs[i] ) )
		{
			fs_trigs[i] thread trigger_floodspawn_think();
		}
	}
	
	fc_trigs = GetEntArray( "trigger_friendlychain", "classname" );

	for( i = 0; i < fc_trigs.size; i++ )
	{
		if( IsDefined( fc_trigs[i] ) )
		{
			fc_trigs[i] thread trigger_friendlychain_think();
		}
	}
}

trigger_friendlychain_think()
{
	if( IsDefined( self.script_noteworthy ) )
	{
		if( self.script_noteworthy == "delete" )
		{
			self waittill( "trigger" );
			wait( 0.1 );
			self Delete();
		}
	}
}

// deletes a floodspawn trigger with a script_noteworthy=delete
trigger_floodspawn_think()
{
	if( IsDefined( self.script_noteworthy ) )
	{
		if( self.script_noteworthy == "delete" )
		{
			self waittill( "trigger" );
			wait( 0.1 );
			self Delete();
		}
		// otherwise it's telling us about another trigger, related to it in some way, that we want to delete
		//  for example for multipath stuff
		else
		{
			otherTrig = GetEnt( "self.script_noteworthy", "targetname" );

			if( IsDefined( otherTrig ) )
			{
				self waittill( "trigger" );
				otherTrig Delete();
			}
		}
	}
}


// waits until a trigger area is clear of enemies
// team = "axis", "allies", "neutral"
waittill_triggerarea_clear( trig, team, maxWait )
{
	startTime = GetTime();
	ais = [];
	loop = true;
	
	if( !IsDefined( trig ) )
	{
		println( "waittill_triggerarea_clear(): trig is not defined! aborting." );
		return;
	}
	
	while( 1 )
	{
		//println( "waittill_triggerarea_clear(): starting check loop" );
		
		foundOne = false;
		
		ais = GetAiArray( team );
		
		if( ais.size <= 0 )
		{
			return;
		}
		
		// see if any of the axis are standing in our trigger
		for( i = 0; i < ais.size; i++ )
		{
			guy = ais[i];
			
			if( guy IsTouching( trig ) )
			{
				//println( "waittill_triggerarea_clear(): found a guy touching the trigger" );
				foundOne = true;
				continue;
			}
		}
		
		// break if we didn't find anyone in the trigger
		if( !foundOne )
		{
			println( "waittill_triggerarea_clear(): didn't find anyone touching the trigger, done waiting." );
			break;
		}
	
		// break if our maxwait has been exceeded
		if( IsDefined( maxWait ) )
		{
			if( ( GetTime() - startTime ) > ( maxWait * 1000 ) )
			{
				println( "waittill_triggerarea_clear(): maxWait exceeded, done waiting." );
				break;
			}
		}
		
		wait( 0.25 );
	}		
}

wait_while_players_can_see( proxDist, checkInterval )
{
	self endon( "death" );
	
	// players must be this far away for self to be considered not visible
	if( !IsDefined( proxDist ) )
	{
 		proxDist = 256;
 	}
 	
 	if( !IsDefined( checkInterval ) )
 	{
 		checkInterval = 5;
 	}
	
	while( is_active_ai( self ) )
	{
		playerCanSee = false;
		
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( SightTracePassed( players[i] GetEye(), self GetEye(), false, players[i] ) || Distance( players[i].origin, self.origin ) < proxDist )
			{
				playerCanSee = true;
				break;
			}
		}
		
		if( !playerCanSee )
		{
			break;
		}
		else
		{
			wait( checkInterval );
		}
	}
}

// returns an array of AIs - should usually be off of script_noteworthy
get_ais( value, key )
{
	ents = GetEntArray( value, key );
	guys = [];
	endnodes = [];
	
	if( !IsDefined( ents.size ) || ents.size <=0 )
	{
		ASSERTMSG( "get_ais(): couldn't find any AIs of key/value " + key + "/" + value );
		return guys;
	}
	
	// get the guys
	for( i = 0; i < ents.size; i++ )
	{
		ent = ents[i];
		if( is_active_ai( ent ) )
		{
			guys[guys.size] = ent;
		}
	}
	
	return guys;
}


// wait for every AI in array "group" to die, before the script continues.
// group = the AI array
// maxWait = the maximum amount of time you want to wait before just moving on
// amount = the number of guys REMAINING that you'll be satisfied with before moving on
// kill_rest = once "amount" has been reached, should we kill the rest off artifically?
waittill_group_dies( group, maxWait, amount, kill_rest )
{
	level.groupIsDead = false;
	level.groupTimerDone = false;
	
	if( group.size <= 0 )
	{
		return;
	}

	if( IsDefined( maxWait ) )
	{
		level thread waittill_group_dies_timeout( maxWait );
		// if we time out, kill the rest of the guys
		kill_rest = true;
	}
	
	if( !IsDefined( amount ) )
	{
		amount = 0;  // we want the player to kill them all
	}
	
	if( !IsDefined( kill_rest ) )
	{
		kill_rest = true;
	}

	level.deathWaitTracker = group.size;

	println( "^5Waiting for " + level.deathWaitTracker + " AI to die..." );

	for( i = 0; i < group.size; i++ )
	{
		if( IsAlive( group[i] ) )
		{
			level thread death_wait( group[i], amount, kill_rest, group );
		}
	}

	while( !level.groupIsDead && !level.groupTimerDone )
	{
		wait( 0.25 );
	}

	return;	
}

waittill_group_dies_timeout( timer )
{
	startTime = GetTime();

	while( !level.groupIsDead && ( ( GetTime() - startTime ) < ( timer * 1000 ) ) )
	{
		wait( 0.25 );
	}

	if( !level.groupIsDead )
	{
		level.groupTimerDone = true;

		println( "waittill_group_dies_timeout() timed out after " + timer + " seconds.  Killing fools and continuing." );
	}
	else
	{
		println( "waittill_group_dies_timeout() didn't get a chance to time out." );
	}
}

death_wait( ent, amount, kill_rest, group )
{	
	while( IsAlive( ent ) )
	{
		if( !level.groupTimerDone )
		{
			wait( 0.25 );
		}
		else
		{
			break;
		}
	}

	level.deathWaitTracker--;

	if( !IsDefined( amount ) )
	{
		amount = 0;
	}

	println( "death_wait(): Waiting for " + level.deathWaitTracker + " AI to die... Needs to be: " + amount );

	if( level.deathWaitTracker <= amount )
	{
		if( kill_rest )
		{
			for( i = 0; i < group.size; i ++ )
			{
				guy = group[i];
				if( is_active_ai( guy ) )
				{
					guy thread bloody_death( true, 3.0 );
				}
			}
		}

		if( amount > 0 && level.deathWaitTracker <= 0 )
		{
			level.groupIsDead = true;
		}
		else
		{
			level.groupIsDead = true;
		}
	}
}

// kill axis in a given trigger
kill_axis_in_trigger( trig, randomDelayFloat )
{
	ASSERTEX( IsDefined( trig ), "kill_axis_in_trigger(): trig is not defined" );
	
	enemies = GetAIArray( "axis" );
	for( k = 0; k < enemies.size; k++ )
	{
		enemy = enemies[k];
		
		if( enemy IsTouching( trig ) && is_active_ai( enemy ) )
		{
			enemy thread bloody_death( true, randomDelayFloat );
		}
	}
}

// kill all the axis in the map.
kill_all_axis( delay )
{
	axis = GetAIArray( "axis" );
	
	if( axis.size <= 0 )
	{
		return;
	}
	
	if( !IsDefined( delay ) )
	{
		delay = 0;
	}
	
	for( i = 0; i < axis.size; i++ )
	{
		if( IsDefined( axis[i] ) )
		{
			axis[i] thread bloody_death( true, delay );
		}
	}
}

// kill guys in a given aigroup
kill_aigroup( aigroup, maxDelay )
{
	ais = get_ai_group_ai( aigroup );
	
	if( !IsDefined( ais ) || ais.size <= 0 )
	{
		return;
	}
	
	if( !IsDefined( maxDelay ) || maxDelay <= 0 )
	{
		maxDelay = 0;
	}
	
	for( i = 0; i < ais.size; i++ )
	{
		ais[i] disable_replace_on_death();
		
		ais[i] thread kill_aigroup_ai( maxDelay );
	}
}

kill_aigroup_ai( maxDelay )
{
	self endon( "death" );
	
	// wait for players to not be able to see the guy
	self wait_while_players_can_see( 400, 2.5 );
	
	self thread bloody_death( true, maxDelay );
}

kill_aigroup_at_trigger( trigVal, trigKey, aigroup, maxDelay )
{
	trigger_wait( trigVal, trigKey );
	kill_aigroup( aigroup, maxDelay );
}

cleanup_forcecolor_redshirts( forcecolor, trigValue, trigKey, waitTime )
{
	trigger_wait( trigValue, trigKey );
	
	if( !IsDefined( waitTime ) )
	{
		waitTime = 1;
	}
	
	redshirts = [];
	ais = GetAIArray( "allies" );
	
	for( i = 0; i < ais.size; i++ )
	{
		guy = ais[i];
		
		if( is_active_ai( guy ) )
		{
			if( IsDefined( guy.script_forcecolor ) && guy.script_forcecolor == forcecolor )
			{
				redshirts[redshirts.size] = guy;
			}
		}
	}
	
	if( !IsDefined( redshirts ) || redshirts.size <= 0 )
	{
		return;
	}
	
	for( i = 0; i < redshirts.size; i++ )
	{
		guy = redshirts[i];
		
		// turn off color respawning on this guy
		guy disable_replace_on_death();
		
		guy thread bloody_death( true, waitTime );
	}
	
	wait( 1 );
	
	level notify( "cleanup_forcecolor_redshirts_done" );
}

// Fake death
// self = the guy getting worked
bloody_death( die, delay )
{
	self endon( "death" );

	if( !is_active_ai( self ) )
	{
		return;
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	self.bloody_death = true;

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";
	
	for( i = 0; i < 3 + RandomInt( 5 ); i++ )
	{
		random = RandomIntRange( 0, tags.size );
		//vec = self GetTagOrigin( tags[random] );
		self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
	}

	if( die )
	{
		self DoDamage( self.health + 50, self.origin );
	}
}

// self = the AI on which we're playing fx
bloody_death_fx( tag, fxName ) 
{ 
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"];
	}

	PlayFxOnTag( fxName, self, tag );
}

bloody_death_after_wait( minWait, die, delay )
{
	if( IsDefined( minWait ) && minWait > 0 )
	{
		wait( minWait );
	}
	
	self bloody_death( die, delay );
}


is_active_ai( suspect )
{
	if( IsDefined( suspect ) && IsSentient( suspect ) && IsAlive( suspect ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

// keeps an AI safe until a player hits the specified trigger
// self = an AI
ai_safe_until_trigger( trigValue, trigKey, waitTime )
{
	self endon( "death" );
	
	self.ignoreme = true;
	self thread magic_bullet_shield();
	
	trigger_wait( trigValue, trigKey );
	
	if( IsDefined( waitTime ) && waitTime > 0 )
	{
		wait( waitTime );
	}
	self.ignoreme = false;
	self notify( "stop magic bullet shield" );
}

// keeps a guy on a turret until we say so
// snyder steez
guy_stay_on_turret( guy, turret )
{
	guy endon( "stop_stay_on_turret" );
	guy endon( "death" );
	turret endon( "death" );
	
	turret setdefaultdroppitch( 0 );
	turret SetLeftArc( 180 );
	turret SetRightArc( 180 );
	
	wait( 0.1 );
	level thread maps\_mgturret::mg42_setdifficulty( turret, GetDifficulty() );
	turret SetMode( "auto_ai" );
	turret setturretignoregoals( true );
		
	while( 1 )
	{
		if( !IsDefined( guy GetTurret() ) )
		{
			guy UseTurret( turret );
		}
		
		wait( 1 );
	}
}


//------------
// DEBUG
//------------

draw_line_to_player( color )
{
/#
	self endon( "death" );

	if( !IsDefined( color ) )
	{
		color = ( 1, 1, 1 );
	}

	while( 1 )
	{
		players = get_players();
		line( self.origin, players[0].origin, color );
		wait( 0.05 );
	}
#/
}

debug_ai()
{
	xPos = 50;
	yPos = 260;
	yInc = 18;
	
	fontScale = 1.5;
	
	red = ( 1, 0, 0 );
	white = ( 1, 1, 1 );
	
	level.friends_count = NewHudElem();
	level.friends_count.alignX = "right";
	level.friends_count.fontScale = fontScale;
	level.friends_count.x = xPos;
	level.friends_count.y = yPos;
	
	yPos += yInc;
	
	level.allies_count = NewHudElem();
	level.allies_count.alignX = "right";
	level.allies_count.fontScale = fontScale;
	level.allies_count.x = xPos;
	level.allies_count.y = yPos;
	
	yPos += yInc;

	level.axis_count = NewHudElem();
	level.axis_count.alignX = "right";
	level.axis_count.fontScale = fontScale;
	level.axis_count.x = xPos;
	level.axis_count.y = yPos;
	
	yPos += yInc;

	level.total_count = NewHudElem();
	level.total_count.alignX = "right";
	level.total_count.fontScale = fontScale;
	level.total_count.x = xPos;
	level.total_count.y = yPos;
	
	while( 1 )
	{
		if( IsDefined( level.friends ) )
		{
			level.friends_count SetText( "level.friends: " + level.friends.size );
		}
		else
		{
			level.friends_count SetText( "level.friends: UNDEFINED");
		}
		
		allies_ai = GetAiArray( "allies" );
		level.allies_count SetText( "other allies: " + ( allies_ai.size - level.friends.size ) );
		
		axis_ai = GetAiArray( "axis" );
		level.axis_count SetText( "total axis: " + axis_ai.size );
		
		total_ai = GetAiArray( "axis", "allies" );		
		level.total_count SetText( "total ai: " + total_ai.size );
		
		// warning colors
		if( total_ai.size > 28 )
		{
			if( level.total_count.color != red )
			{
				level.total_count.color = red;
			}
		}
		else
		{
			if( level.total_count.color != white )
			{
				level.total_count FadeOverTime( 1.25 );
				level.total_count.color = white;
			}
		}
	
		wait 1;
	}
}

y_pos_inc( pos, inc )
{
	pos += inc;
	return pos;
}


//------------
// MISC
//------------

// hacky from Mackey
stringToFloat( string ) 
{
	SetDvar( "stringToFloat", string );
	return GetDvarFloat( "stringToFloat" );
}

// does GetEnt, error checks the result, and if bad, gives the scripter a useable error message
// returns the result of the GetEnt call
// debugName = an arbitrary string that the scripter can use to ID his issue
getent_safe( value, key, debugName )
{
	ent = GetEnt( value, key );
	
	if( IsDefined( debugName ) )
	{
		debugString = "Couldn't GetEnt for: " + debugName;
	}
	else
	{
		debugString = "Couldn't GetEnt with KVP " + key + " / " + value;
	}
	
	if( IsDefined( ent ) )
	{
		return ent;
	}
	else
	{
		ASSERTMSG( debugString );
	}
}

// same as above, but for GetStruct
getstruct_safe( value, key, debugName )
{
	sstruct = GetStruct( value, key );
	
	if( IsDefined( debugName ) )
	{
		debugString = "Couldn't GetStruct for: " + debugName;
	}
	else
	{
		debugString = "Couldn't GetStruct with KVP " + key + " / " + value;
	}
	
	if( IsDefined( sstruct ) )
	{
		return sstruct;
	}
	else
	{
		ASSERTMSG( debugString );
	}
}

// same as above, but for GetNode
getnode_safe( value, key, debugName )
{
	node = GetNode( value, key );
	
	if( IsDefined( debugName ) )
	{
		debugString = "Couldn't GetNode for: " + debugName;
	}
	else
	{
		debugString = "Couldn't GetNode with KVP " + key + " / " + value;
	}
	
	if( IsDefined( node ) )
	{
		return node;
	}
	else
	{
		ASSERTMSG( debugString );
	}
}

// self = the array
array_contains_element( element )
{
	for( i = 0; i < self.size; i++ )
	{
		if( self[i] == element )
		{
			return true;
		}
	}
	
	return false;
}

// Returns a random element from the given array
get_random( array )
{
	return array[RandomInt( array.size )]; 
}

array_validate( array )
{
	if( IsDefined( array ) && array.size > 0 )
	{
		return true;
	}
	else
	{
		return false;
	}
}

scr_earthquake( scale, duration, source, radius )
{
	if( IsDefined( self ) )
	{
		Earthquake( scale, duration, source, radius );
	}
}

// waits till any player is within playerdist units of testOrigin
// optionally specify waitTime for more precision
waittill_player_within_range( testOrigin, playerdist, waitTime )
{
	if( !IsDefined( waitTime ) || waitTime <= 0 )
	{
		waitTime = 0.1;
	}
	
	closeEnough = false;
	
	while( !closeEnough )
	{
		players = get_players();
		
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if( Distance( player.origin, testOrigin ) <= playerdist )
			{
				closeEnough = true;
				break;
			}
		}
		
		if( closeEnough )
		{
			break;
		}
		else
		{
			wait( waitTime );
		}
	}
}

// waits till an enemy is within range of any player, and returns the enemy
waittill_enemy_in_range_of_player( enemyRange )
{	
	while( 1 )
	{
		players = get_players();
		axis = GetAIArray( "axis" );
		
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			for( j = 0; j < axis.size; j++ )
			{
				badguy = axis[j];
				
				if( !is_active_ai( badguy ) )
				{
					continue;
				}
				
				if( Distance2D( player.origin, badguy.origin ) <= enemyRange )
				{
					return badguy;
				}
			}
		}
		
		wait( 0.2 );
	}
}

// CLEANUP
delete_group( group, waitTime )
{
	if( IsDefined( group ) && group.size > 0 )
	{
		array_thread( group, ::scr_delete, waitTime );
	}
}

scr_delete( waitTime )
{
	if( IsDefined( waitTime ) && waitTime > 0 )
	{
		wait( waitTime );
	}
	
	if( IsDefined( self ) )
	{
		self Delete();
	}
}

// a big chunk of this was stolen from MikeD's mak.gsc
endscripting()
{
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] EnableInvulnerability();
		players[i] FreezeControls( true );
	}
	
	//TUEY Added "shock" file to control busses and fade out other sounds ()	
	set_all_players_shock( "level_end", 20 );
	
	thread fade_to_black( 0.5 );
	
	wait( 1.5 );

	continued_text = NewHudElem(); 
	continued_text.x = 0; 
	continued_text.y = 0; 
	continued_text.alignX = "center"; 
	continued_text.alignY = "middle"; 
	continued_text.horzAlign = "center"; 
	continued_text.vertAlign = "middle"; 
	continued_text.sort = 1; // force to draw after the background
	continued_text.foreground = true; 
	continued_text.fontScale = 1.75; 
	continued_text SetText( "To be continued..." ); 
	continued_text.alpha = 0; 
	continued_text FadeOverTime( 1.2 ); 
	continued_text.alpha = 1;
	
	wait( 10 );
	
	nextmission();
}

fade_to_black( fadeTime )
{
	if( !IsDefined( fadeTime ) )
	{
		fadeTime = 5;
	}
	
	// fade to black
	fadetoblack = NewHudElem(); 
	fadetoblack.x = 0; 
	fadetoblack.y = 0; 
	fadetoblack.alpha = 0; 
		
	fadetoblack.horzAlign = "fullscreen"; 
	fadetoblack.vertAlign = "fullscreen"; 
	fadetoblack.foreground = false;  // arcademode compatible
	fadetoblack.sort = 50;  // arcademode compatible
	fadetoblack SetShader( "black", 640, 480 ); 

	// Fade into black
	fadetoblack FadeOverTime( fadeTime );
	fadetoblack.alpha = 1;
}
