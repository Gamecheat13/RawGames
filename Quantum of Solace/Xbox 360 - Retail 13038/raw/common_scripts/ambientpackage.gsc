#include common_scripts\utility;

/*			Example map_amb.gsc file:
main()
{
	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	package = "outdoors_pkg";
	declareAmbientPackage( package );
	addAmbientElement( package, "elm_dog1", 3, 6, 1800, 2000, 270, 450 );
	addAmbientElement( package, "elm_dog2", 5, 10 );
	addAmbientElement( package, "elm_dog3", 10, 20 );
	addAmbientElement( package, "elm_donkey1", 25, 35 );
	addAmbientElement( package, "elm_horse1", 10, 25 );

	package = "west_pkg";
	declareAmbientPackage( package );
	addAmbientElement( package, "elm_insect_fly", 2, 8, 0, 150, 345, 375 );
	addAmbientElement( package, "elm_owl", 3, 10, 400, 500, 269, 270 );
	addAmbientElement( package, "elm_wolf", 10, 15, 100, 500, 90, 270 );
	addAmbientElement( package, "animal_chicken_idle", 3, 12 );
	addAmbientElement( package, "animal_chicken_disturbed", 10, 30 );

	package = "northwest_pkg";
	declareAmbientPackage( package );
	addAmbientElement( package, "elm_wind_buffet", 3, 6 );
	addAmbientElement( package, "elm_rubble", 5, 10 );
	addAmbientElement( package, "elm_industry", 10, 20 );
	addAmbientElement( package, "elm_stress", 5, 20, 200, 2000 );



	//the same pattern is followed for setting up ambientRooms
	room = "outdoors_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "amb_shanty_ext_temp" );
	setAmbientRoomReverb( room, "generic", 1, 0 );
	setAmbientRoomBusVolumes( room, "teargas" ); // second parameter is name of shock file specifying bus volumes

	room = "west_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "bomb_tick" );
	setAmbientRoomReverb( room, "underwater", 0.5, 1 );
	setAmbientRoomBusVolumes( room, "tankblast" );

	room = "northwest_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "weap_sniper_heartbeat" );
	setAmbientRoomReverb( room, "hangar", 0.75, 0.75 );
	setAmbientRoomBusVolumes( room, "dog_bite" );




	// set the base ambientpackage and ambientroom, which are used when not touching any ambientPackageTriggers
	// the other trigger based packages will be activated automatically when the player is touching them
	setBaseAmbientPackageAndRoom( "outdoors_pkg", "outdoors_room" );

	// finally, call this to allow the trigger initialization to complete, since it was waiting for all declarations
	// so that it could perform error checking
	signalAmbientPackageDeclarationComplete();
}
*/

init()
{
	level.ambientPackages = [];
	level.ambientRooms = [];
	level.ambientPerPlayerInfo = [];
	
	level.ambientPackageDeclarationComplete = false;
}

setBaseAmbientPackageAndRoom( package, room )
{
	level.ambientPackageBase = package;
	level.ambientRoomBase = room;
}

acquireNewPerPlayerInfoIndex( player )
{
	for ( playerIndex = 0; playerIndex < level.ambientPerPlayerInfo.size; playerIndex++ )
	{
		if ( !level.ambientPerPlayerInfo[playerIndex].inuse )
		{
			break;
		}
	}

	level.ambientPerPlayerInfo[playerIndex] = spawnStruct();
	level.ambientPerPlayerInfo[playerIndex].inuse = true;
	level.ambientPerPlayerInfo[playerIndex].player = player;
	level.ambientPerPlayerInfo[playerIndex].ambientPackageScriptOriginPool = [];
	level.ambientPerPlayerInfo[playerIndex].ambientRoomToneOriginPool = [];
	level.ambientPerPlayerInfo[playerIndex].activeAmbientPackage = "";

	for ( i = 0; i < 5; i++ )
	{
		level.ambientPerPlayerInfo[playerIndex].ambientPackageScriptOriginPool[i] = spawnStruct();
		level.ambientPerPlayerInfo[playerIndex].ambientPackageScriptOriginPool[i].org = spawn( "script_origin", (0, 0, 0) );
		level.ambientPerPlayerInfo[playerIndex].ambientPackageScriptOriginPool[i].inuse = false;
	}

	level.ambientPerPlayerInfo[playerIndex].activeAmbientRoom = "";
	level.ambientPerPlayerInfo[playerIndex].ambientRoomToneOriginPoolIndex = 0;
	for ( i = 0; i < 5; i++ )
	{
		level.ambientPerPlayerInfo[playerIndex].ambientRoomToneOriginPool[i] = spawnStruct();
		level.ambientPerPlayerInfo[playerIndex].ambientRoomToneOriginPool[i].org = spawn( "script_origin", (0, 0, 0) );
		level.ambientPerPlayerInfo[playerIndex].ambientRoomToneOriginPool[i].inuse = false;
		level.ambientPerPlayerInfo[playerIndex].ambientRoomToneOriginPool[i].alias = "";
	}

	level.ambientPerPlayerInfo[playerIndex].ambientPackages = [];
	keys = getArrayKeys( level.ambientPackages );
	for ( i = 0; i < keys.size; i++ )
	{
		level.ambientPerPlayerInfo[playerIndex].ambientPackages[ keys[ i ] ] = spawnStruct();
		level.ambientPerPlayerInfo[playerIndex].ambientPackages[ keys[ i ] ].priority = [];
		level.ambientPerPlayerInfo[playerIndex].ambientPackages[ keys[ i ] ].refcount = [];
	}

	level.ambientPerPlayerInfo[playerIndex].ambientRooms = [];
	keys = getArrayKeys( level.ambientRooms );
	for ( i = 0; i < keys.size; i++ )
	{
		level.ambientPerPlayerInfo[playerIndex].ambientRooms[ keys[ i ] ] = spawnStruct();
		level.ambientPerPlayerInfo[playerIndex].ambientRooms[ keys[ i ] ].priority = [];
		level.ambientPerPlayerInfo[playerIndex].ambientRooms[ keys[ i ] ].refcount = [];
	}
	
	return playerIndex;
}

getPerPlayerInfoIndex( player )
{
	for ( i = 0; i < level.ambientPerPlayerInfo.size; i++ )
	{
		if ( level.ambientPerPlayerInfo[i].player == player )
		{
			return i;
		}
	}
	
	assertmsg( "Tried to get ambientPerPlayerInfoIndex for a player that is not in the array.\n" );
}

initPlayer()
{
	if ( !level.ambientPackageDeclarationComplete )
	{
		level waittill( "ambientPackageDeclarationComplete" );
	}

	player = self;
	
	for ( i = 0; i < level.ambientPerPlayerInfo.size; i++ )
	{
		if ( level.ambientPerPlayerInfo[i].inuse && level.ambientPerPlayerInfo[i].player == player )
		{
			// this player was set up already
			return;
		}
	}

	acquireNewPerPlayerInfoIndex( player );

	player thread updateActiveAmbientPackage();
	player thread updateActiveAmbientRoom();

	ambientpackages = getentarray( "ambient_package", "targetname" );
	keys = getArrayKeys( ambientpackages );
	for( i = 0 ; i < keys.size ; i++ )
		ambientpackages[ keys[ i ] ] thread ambientPackageTrigger( player );
	
	activateAmbientPackage( player, level.ambientPackageBase, 0 );
	activateAmbientRoom( player, level.ambientRoomBase, 0 );

	player.ambientpackageplayerinitialized = true;
	player notify( "ambientpackageplayerinitialized" );
}

shutdownPlayer( disconnected )
{
	if ( !disconnected )
	{
		return;
	}

	player = self;

	if ( !isdefined( player.ambientpackageplayerinitialized ) )
	{
		player waittill( "ambientpackageplayerinitialized" );
	}

	playerIndex = getPerPlayerInfoIndex( player );
	player notify( "killambientElementThread" + level.ambientPerPlayerInfo[playerIndex].activeAmbientPackage );

	player notify( "killAmbientPackageUpdate" );
	player notify( "killAmbientRoomUpdate" );
	player notify( "killAmbientPackageTrigger" );
	
	level.ambientPerPlayerInfo[playerIndex].inuse = false;
}

signalAmbientPackageDeclarationComplete()
{
	if ( !isdefined( level.ambientPackageBase ) || !isdefined( level.ambientRoomBase ) )
	{
		assertmsg( "setBaseAmbientPackageAndRoom() must be called before signalAmbientPackageDeclarationComplete()\n" );
	}

	level.ambientPackageDeclarationComplete = true;
	level notify( "ambientPackageDeclarationComplete" );
}

ambientPackageTrigger( player )
{
	player endon( "disconnect" );
	player endon( "killAmbientPackageTrigger" );

	playerIndex = getPerPlayerInfoIndex( player );
	if ( !isdefined( level.ambientPerPlayerInfo[playerIndex] ) )
	{
/#
		assertmsg( "ambientPackageTrigger function started for a player before that player's ambientPerPlayerInfo structure was created\n" );
#/
		return;
	}
	
	priority = 1;
	if ( isdefined( self.script_ambientpriority ) )
		priority = self.script_ambientpriority;

	if ( !level.ambientPackageDeclarationComplete )
	{
		level waittill( "ambientPackageDeclarationComplete" );
	}

	//error check on load that the package and room listed in this trigger have previously been declared
	useAmbientPackage = false;
	if ( isdefined ( self.script_ambientpackage ) )
	{
		packageArray = getArrayKeys( level.ambientPackages );
		for ( i = 0; i < packageArray.size; i++ )
		{
			if ( self.script_ambientpackage == packageArray[i] )
			{
				useAmbientPackage = true;
				break;
			}
		}
/#
		if ( i == level.ambientpackages.size )
		{
			assertmsg( "Trigger at " + self.origin + " references ambient package '" + self.script_ambientpackage + "', but no such package has been declared\n" );
		}
#/
	}

	useAmbientRoom = false;
	if ( isdefined ( self.script_ambientroom ) )
	{
		roomArray = getArrayKeys( level.ambientRooms );
		for ( i = 0; i < roomArray.size; i++ )
		{
			if ( self.script_ambientroom == roomArray[i] )
			{
				useAmbientRoom = true;
				break;
			}
		}
/#
		if ( i == level.ambientrooms.size )
		{
			assertmsg( "Trigger at " + self.origin + " references ambient room '" + self.script_ambientroom + "', but no such room has been declared\n" );
		}
#/
	}

	for (;;)
	{
		self waittill ( "trigger" );

		if ( useAmbientPackage )
			activateAmbientPackage( player, self.script_ambientpackage, priority );
		if ( useAmbientRoom )
			activateAmbientRoom( player, self.script_ambientroom, priority );

		while ( player isTouching( self ) )
			wait 0.1;

		if ( useAmbientPackage )
			deactivateAmbientPackage( player, self.script_ambientpackage, priority );
		if ( useAmbientRoom )
			deactivateAmbientRoom( player, self.script_ambientroom, priority );
	}
}

findHighestPriorityAmbientPackage( player )
{
	package = "";
	priority = -1;
	playerIndex = getPerPlayerInfoIndex( player );

	packageArray = getArrayKeys( level.ambientPerPlayerInfo[playerIndex].ambientPackages );
	for ( i = 0; i < packageArray.size; i++ )
	{
		for ( j = 0; j < level.ambientPerPlayerInfo[playerIndex].ambientPackages[packageArray[i]].priority.size; j++ )
		{
			if ( level.ambientPerPlayerInfo[playerIndex].ambientPackages[packageArray[i]].refcount[j] && level.ambientPerPlayerInfo[playerIndex].ambientPackages[packageArray[i]].priority[j] > priority )
			{
				package = packageArray[i];
				priority = level.ambientPerPlayerInfo[playerIndex].ambientPackages[packageArray[i]].priority[j];
			}
		}
	}

	return package;
}

updateActiveAmbientPackage()
{
	player = self;
	playerIndex = getPerPlayerInfoIndex( player );

	player endon( "disconnect" );
	player endon( "killAmbientPackageUpdate" );

	for (;;)
	{
		player waittill( "updateActiveAmbientPackage" );
		newAmbientPackage = findHighestPriorityAmbientPackage( player );
		if ( newAmbientPackage != "" && level.ambientPerPlayerInfo[playerIndex].activeAmbientPackage != newAmbientPackage )
		{
			player notify( "killambientElementThread" + level.ambientPerPlayerInfo[playerIndex].activeAmbientPackage );
			level.ambientPerPlayerInfo[playerIndex].activeAmbientPackage = newAmbientPackage;

			keys = getArrayKeys( level.ambientPackages[level.ambientPerPlayerInfo[playerIndex].activeAmbientPackage].elements );
			for( i = 0 ; i < keys.size ; i++ )
				level.ambientPackages[level.ambientPerPlayerInfo[playerIndex].activeAmbientPackage].elements[ keys[ i ] ] thread ambientElementThread( player );
			//iprintlnbold( "switching to: " + level.ambientPerPlayerInfo[playerIndex].activeAmbientPackage );
		}
	}
}

activateAmbientPackage( player, package, priority )
{
	if ( !isdefined( level.ambientPackages[package] ) )
	{
		assertmsg( "activateAmbientPackage: must declare ambient package \"" + package + "\" in level_amb main before it can be activated" );
		return;
	}

	playerIndex = getPerPlayerInfoIndex( player );
	packageInfo = level.ambientPerPlayerInfo[playerIndex].ambientPackages[package];

	for ( i = 0; i < packageInfo.priority.size; i++ )
	{
		if ( packageInfo.priority[i] == priority )
		{
			packageInfo.refcount[i]++;
			break;
		}
	}
	if ( i == packageInfo.priority.size )
	{
		packageInfo.priority[i] = priority;
		packageInfo.refcount[i] = 1;
	}

	//iprintlnbold( "entering: " + package + " priority: " + priority );
	player notify( "updateActiveAmbientPackage" );
}

deactivateAmbientPackage( player, package, priority )
{
	if ( !isdefined( level.ambientPackages[package] ) )
	{
		assertmsg( "deactivateAmbientPackage: must declare ambient package \"" + package + "\" in level_amb main before it can be deactivated" );
		return;
	}

	playerIndex = getPerPlayerInfoIndex( player );
	packageInfo = level.ambientPerPlayerInfo[playerIndex].ambientPackages[package];

	for ( i = 0; i < packageInfo.priority.size; i++ )
	{
		if ( packageInfo.priority[i] == priority && packageInfo.refcount[i] )
		{
			packageInfo.refcount[i]--;
			//iprintlnbold( "leaving: " + package + " priority: " + priority );
			player notify( "updateActiveAmbientPackage" );
			return;
		}
	}
}

declareAmbientPackage( package )
{
	if ( isdefined( level.ambientPackages[package] ) )
		return;

	level.ambientPackages[package] = spawnStruct();
	level.ambientPackages[package].elements = [];
}

addAmbientElement( package, alias, spawnMin, spawnMax, distMin, distMax, angleMin, angleMax )
{
	if ( !isdefined( level.ambientPackages[package] ) )
	{
		assertmsg( "addAmbientElement: must declare ambient package \"" + package + "\" in level_amb main before it can have elements added to it" );
		return;
	}

	index = level.ambientPackages[package].elements.size;
	level.ambientPackages[package].elements[index] = spawnStruct();
	level.ambientPackages[package].elements[index].alias = alias;

	if ( spawnMin < 0 )
		spawnMin = 0;
	if ( spawnMin >= spawnMax )
		spawnMax = spawnMin + 1;
	level.ambientPackages[package].elements[index].spawnMin = spawnMin;
	level.ambientPackages[package].elements[index].spawnMax = spawnMax;

	level.ambientPackages[package].elements[index].distMin = -1;
	level.ambientPackages[package].elements[index].distMax = -1;
	if ( isdefined( distMin ) && isdefined( distMax ) && distMin >= 0 && distMin < distMax )
	{
		level.ambientPackages[package].elements[index].distMin = distMin;
		level.ambientPackages[package].elements[index].distMax = distMax;
	}

	level.ambientPackages[package].elements[index].angleMin = 0;
	level.ambientPackages[package].elements[index].angleMax = 359;
	if ( isdefined( angleMin ) && isdefined( angleMax ) && angleMin >= 0 && angleMin < angleMax && angleMax <= 720 )
	{
		level.ambientPackages[package].elements[index].angleMin = angleMin;
		level.ambientPackages[package].elements[index].angleMax = angleMax;
	}
}

ambientElementThread( player )
{
	playerIndex = getPerPlayerInfoIndex( player );

	player endon( "disconnect" );
	player endon( "killambientElementThread" + level.ambientPerPlayerInfo[playerIndex].activeAmbientPackage );
	
	timer = 0;
	
	if ( self.distMin < 0 )
	{
		for (;;)
		{
			timer = randomintrange( self.spawnMin, self.spawnMax );
			wait timer;
			//iprintlnbold( "playing2d: " + self.alias );
			player playLocalSound( self.alias );
		}
	}
	else
	{
		dist = 0;
		angle = 0;
		offset = (0, 0, 0);
		index = -1;
		for (;;)
		{
			timer = randomintrange( self.spawnMin, self.spawnMax );
			wait timer;

			index = getScriptOriginPoolIndex( player );
			if ( index >= 0 )
			{
				dist = randomintrange( self.distMin, self.distMax );
				angle = randomintrange( self.angleMin, self.angleMax );
				offset = anglestoforward( ( 0, angle + player.angles[1], 0 ) );
				offset = vectorscale( offset, dist );
				level.ambientPerPlayerInfo[playerIndex].ambientPackageScriptOriginPool[index].org.origin = player geteye() + offset;

				wait .05; // this wait ensures that the position has settled before the sound is played
				//iprintlnbold( "playing3d: " + self.alias + " angle: " + angle + " dist: " + dist );
				level.ambientPerPlayerInfo[playerIndex].ambientPackageScriptOriginPool[index].org playSoundToPlayer( self.alias, level.ambientPerPlayerInfo[playerIndex].player );
				wait 3;
				level.ambientPerPlayerInfo[playerIndex].ambientPackageScriptOriginPool[index].inuse = false;
			}
		}
	}
}

getScriptOriginPoolIndex( player )
{
	playerIndex = getPerPlayerInfoIndex( player );

	for ( index = 0; index < level.ambientPerPlayerInfo[playerIndex].ambientPackageScriptOriginPool.size; index++ )
	{
		if ( !level.ambientPerPlayerInfo[playerIndex].ambientPackageScriptOriginPool[index].inuse )
		{
			level.ambientPerPlayerInfo[playerIndex].ambientPackageScriptOriginPool[index].inuse = true;
			return index;
		}
	}
	
	return -1;
}

roomToneFadeOutTimerThread( fadeOut )
{
	self endon( "killRoomToneFadeOutTimer" );

	wait fadeOut;
	self.inuse = false;
}

findHighestPriorityAmbientRoom( player )
{
	room = "";
	priority = -1;
	playerIndex = getPerPlayerInfoIndex( player );

	roomArray = getArrayKeys( level.ambientPerPlayerInfo[playerIndex].ambientRooms );
	for ( i = 0; i < roomArray.size; i++ )
	{
		for ( j = 0; j < level.ambientPerPlayerInfo[playerIndex].ambientRooms[roomArray[i]].priority.size; j++ )
		{
			if ( level.ambientPerPlayerInfo[playerIndex].ambientRooms[roomArray[i]].refcount[j] && level.ambientPerPlayerInfo[playerIndex].ambientRooms[roomArray[i]].priority[j] > priority )
			{
				room = roomArray[i];
				priority = level.ambientPerPlayerInfo[playerIndex].ambientRooms[roomArray[i]].priority[j];
			}
		}
	}

	return room;
}

updateActiveAmbientRoom()
{
	player = self;
	playerIndex = getPerPlayerInfoIndex( player );
	perPlayerInfo = level.ambientPerPlayerInfo[playerIndex];
	
	player endon( "disconnect" );
	player endon( "killAmbientRoomUpdate" );

	org = perPlayerInfo.ambientRoomToneOriginPool[0].org;

	for (;;)
	{
		player waittill( "updateActiveAmbientRoom" );
		newAmbientRoom = findHighestPriorityAmbientRoom( player );
		if ( newAmbientRoom != "" && perPlayerInfo.activeAmbientRoom != newAmbientRoom )
		{
			if ( perPlayerInfo.activeAmbientRoom != "" && isdefined( level.ambientRooms[perPlayerInfo.activeAmbientRoom].tone ) )
			{
				for ( i = 0; i < perPlayerInfo.ambientRoomToneOriginPool.size; i++ )
				{
					if ( perPlayerInfo.ambientRoomToneOriginPool[i].inuse && perPlayerInfo.ambientRoomToneOriginPool[i].alias == level.ambientRooms[perPlayerInfo.activeAmbientRoom].tone.alias )
					{
						perPlayerInfo.ambientRoomToneOriginPool[i].org stopLoopSoundToPlayer( level.ambientRooms[perPlayerInfo.activeAmbientRoom].tone.fadeOut, perPlayerInfo.player );
						perPlayerInfo.ambientRoomToneOriginPool[i] thread roomToneFadeOutTimerThread( level.ambientRooms[perPlayerInfo.activeAmbientRoom].tone.fadeOut );
						break;
					}
				}
			}

			perPlayerInfo.activeAmbientRoom = newAmbientRoom;

			if ( isdefined( level.ambientRooms[perPlayerInfo.activeAmbientRoom].tone ) )
			{
				//first check if the tone we are about to start is still fading out, if so fade it back in
				for ( i = 0; i < perPlayerInfo.ambientRoomToneOriginPool.size; i++ )
				{
					if ( perPlayerInfo.ambientRoomToneOriginPool[i].inuse && perPlayerInfo.ambientRoomToneOriginPool[i].alias == level.ambientRooms[perPlayerInfo.activeAmbientRoom].tone.alias )
					{
						org = perPlayerInfo.ambientRoomToneOriginPool[i].org;
						perPlayerInfo.ambientRoomToneOriginPool[i] notify( "killRoomToneFadeOutTimer" );
						break;
					}
				}
				
				if ( i == perPlayerInfo.ambientRoomToneOriginPool.size )
				{
					perPlayerInfo.ambientRoomToneOriginPoolIndex++;
					if ( perPlayerInfo.ambientRoomToneOriginPool.size == perPlayerInfo.ambientRoomToneOriginPoolIndex )
					{
						perPlayerInfo.ambientRoomToneOriginPoolIndex = 0;
					}
					org = perPlayerInfo.ambientRoomToneOriginPool[perPlayerInfo.ambientRoomToneOriginPoolIndex].org;
					perPlayerInfo.ambientRoomToneOriginPool[perPlayerInfo.ambientRoomToneOriginPoolIndex].alias = level.ambientRooms[perPlayerInfo.activeAmbientRoom].tone.alias;
					perPlayerInfo.ambientRoomToneOriginPool[perPlayerInfo.ambientRoomToneOriginPoolIndex].inuse = true;
				}
				org playLoopSoundToPlayer( level.ambientRooms[perPlayerInfo.activeAmbientRoom].tone.alias, level.ambientRooms[perPlayerInfo.activeAmbientRoom].tone.fadeIn, perPlayerInfo.player );
			}
			
			if ( !isdefined( level.ambientRooms[perPlayerInfo.activeAmbientRoom].reverb ) )
			{
				player deactivateReverb( "snd_enveffectsprio_level", 2 );
			}
			else
			{
				player setReverb( "snd_enveffectsprio_level", level.ambientRooms[perPlayerInfo.activeAmbientRoom].reverb.reverbRoomType, level.ambientRooms[perPlayerInfo.activeAmbientRoom].reverb.dry, level.ambientRooms[perPlayerInfo.activeAmbientRoom].reverb.wet, level.ambientRooms[perPlayerInfo.activeAmbientRoom].reverb.fade );
			}
			
			if ( !isdefined( level.ambientRooms[perPlayerInfo.activeAmbientRoom].busVolumes ) )
			{
				player deactivateBusVolumes( "snd_busvolprio_level", 2 );
			}
			else
			{
				player setBusVolumes( "snd_busvolprio_level", level.ambientRooms[perPlayerInfo.activeAmbientRoom].busVolumes.shockName, level.ambientRooms[perPlayerInfo.activeAmbientRoom].busVolumes.fade );
			}
			//iprintlnbold( "switching to: " + perPlayerInfo.activeAmbientRoom );
		}
	}
}

activateAmbientRoom( player, room, priority )
{
	if ( !isdefined( level.ambientRooms[room] ) )
	{
		assertmsg( "activateAmbientRoom: must declare ambient room \"" + room + "\" in level_amb main before it can be activated" );
		return;
	}

	playerIndex = getPerPlayerInfoIndex( player );
	perPlayerInfo = level.ambientPerPlayerInfo[playerIndex];

	for ( i = 0; i < perPlayerInfo.ambientRooms[room].priority.size; i++ )
	{
		if ( perPlayerInfo.ambientRooms[room].priority[i] == priority )
		{
			perPlayerInfo.ambientRooms[room].refcount[i]++;
			break;
		}
	}
	if ( i == perPlayerInfo.ambientRooms[room].priority.size )
	{
		perPlayerInfo.ambientRooms[room].priority[i] = priority;
		perPlayerInfo.ambientRooms[room].refcount[i] = 1;
	}

	//iprintlnbold( "entering: " + room + " priority: " + priority );
	player notify( "updateActiveAmbientRoom" );
}

deactivateAmbientRoom( player, room, priority )
{
	if ( !isdefined( level.ambientRooms[room] ) )
	{
		assertmsg( "deactivateAmbientRoom: must declare ambient room \"" + room + "\" in level_amb main before it can be deactivated" );
		return;
	}

	playerIndex = getPerPlayerInfoIndex( player );
	perPlayerInfo = level.ambientPerPlayerInfo[playerIndex];

	for ( i = 0; i < perPlayerInfo.ambientRooms[room].priority.size; i++ )
	{
		if ( perPlayerInfo.ambientRooms[room].priority[i] == priority && perPlayerInfo.ambientRooms[room].refcount[i] )
		{
			perPlayerInfo.ambientRooms[room].refcount[i]--;
			//iprintlnbold( "leaving: " + room + " priority: " + priority );
			player notify( "updateActiveAmbientRoom" );
			return;
		}
	}
}

declareAmbientRoom( room )
{
	if ( isdefined( level.ambientRooms[room] ) )
		return;

	level.ambientRooms[room] = spawnStruct();
}

setAmbientRoomTone( room, alias, fadeIn, fadeOut )
{
	if ( !isdefined( level.ambientRooms[room] ) )
	{
		assertmsg( "setAmbientRoomTone: must declare ambient room \"" + room + "\" in level_amb main before it can have a room tone set" );
		return;
	}

	level.ambientRooms[room].tone = spawnStruct();
	level.ambientRooms[room].tone.alias = alias;

	level.ambientRooms[room].tone.fadeIn = 2;
	if ( isDefined( fadeIn ) && fadeIn >= 0 )
	{
		level.ambientRooms[room].tone.fadeIn = fadeIn;
	}
	level.ambientRooms[room].tone.fadeOut = 2;
	if ( isDefined( fadeOut ) && fadeOut >= 0 )
	{
		level.ambientRooms[room].tone.fadeOut = fadeOut;
	}
}

setAmbientRoomReverb( room, reverbRoomType, dry, wet, fade )
{
	if ( !isdefined( level.ambientRooms[room] ) )
	{
		assertmsg( "setAmbientRoomReverb: must declare ambient room \"" + room + "\" in level_amb main before it can have a room reverb set" );
		return;
	}

	level.ambientRooms[room].reverb = spawnStruct();
	level.ambientRooms[room].reverb.reverbRoomType = reverbRoomType;
	level.ambientRooms[room].reverb.dry = dry;
	level.ambientRooms[room].reverb.wet = wet;

	level.ambientRooms[room].reverb.fade = 2;
	if ( isDefined( fade ) && fade >= 0 )
	{
		level.ambientRooms[room].reverb.fade = fade;
	}
}

setAmbientRoomBusVolumes( room, shockName, fade )
{
	if ( !isdefined( level.ambientRooms[room] ) )
	{
		assertmsg( "setAmbientRoomBusVolumes: must declare ambient room \"" + room + "\" in level_amb main before it can have a room bus volume set" );
		return;
	}
	
	precacheshellshock( shockName );

	level.ambientRooms[room].busVolumes = spawnStruct();
	level.ambientRooms[room].busVolumes.shockName = shockName;

	level.ambientRooms[room].busVolumes.fade = 2;
	if ( isDefined( fade ) && fade >= 0 )
	{
		level.ambientRooms[room].busVolumes.fade = fade;
	}
}
