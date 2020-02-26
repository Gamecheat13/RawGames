#include maps\_utility;
#include maps\_equalizer;
#include common_scripts\utility;

//TODO: handle get_players array better than always assuming players[0]


/*			Example map_amb.gsc file:
#include maps\_ambientpackage;


main()
{
	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	declareAmbientPackage( "outdoors_pkg" );
	addAmbientElement( "outdoors_pkg", "elm_dog1", 3, 6, 1800, 2000, 270, 450 );
	addAmbientElement( "outdoors_pkg", "elm_dog2", 5, 10 );
	addAmbientElement( "outdoors_pkg", "elm_dog3", 10, 20 );
	addAmbientElement( "outdoors_pkg", "elm_donkey1", 25, 35 );
	addAmbientElement( "outdoors_pkg", "elm_horse1", 10, 25 );

	declareAmbientPackage( "west_pkg" );
	addAmbientElement( "west_pkg", "elm_insect_fly", 2, 8, 0, 150, 345, 375 );
	addAmbientElement( "west_pkg", "elm_owl", 3, 10, 400, 500, 269, 270 );
	addAmbientElement( "west_pkg", "elm_wolf", 10, 15, 100, 500, 90, 270 );
	addAmbientElement( "west_pkg", "animal_chicken_idle", 3, 12 );
	addAmbientElement( "west_pkg", "animal_chicken_disturbed", 10, 30 );

	declareAmbientPackage( "northwest_pkg" );
	addAmbientElement( "northwest_pkg", "elm_wind_buffet", 3, 6 );
	addAmbientElement( "northwest_pkg", "elm_rubble", 5, 10 );
	addAmbientElement( "northwest_pkg", "elm_industry", 10, 20 );
	addAmbientElement( "northwest_pkg", "elm_stress", 5, 20, 200, 2000 );

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	activateAmbientPackage( "outdoors_pkg", 0 );


	//the same pattern is followed for setting up ambientRooms
	declareAmbientRoom( "outdoors_room" );
	setAmbientRoomTone( "outdoors_room", "amb_shanty_ext_temp" );

	declareAmbientRoom( "west_room" );
	setAmbientRoomTone( "west_room", "bomb_tick" );

	declareAmbientRoom( "northwest_room" );
	setAmbientRoomTone( "northwest_room", "weap_sniper_heartbeat" );

	activateAmbientRoom( "outdoors_room", 0 );
}
*/

init()
{
	if(!level.clientscripts)	// Not running client scripts - handle ambient sounds on the server.
	{
		level.activeAmbientPackage = "";
		level.ambientPackages = [];
		thread updateActiveAmbientPackage();
	
		level.ambientPackageScriptOriginPool = [];
		for ( i = 0; i < 5; i++ )
		{
			level.ambientPackageScriptOriginPool[i] = spawnStruct();
			level.ambientPackageScriptOriginPool[i].org = spawn( "script_origin", (0, 0, 0) );
			level.ambientPackageScriptOriginPool[i].inuse = false;
			level.ambientPackageScriptOriginPool[i] thread scriptOriginPoolThread();
		}
	
		level.activeAmbientRoom = "";
		level.ambientRoomToneOriginPool = [];
		level.ambientRoomToneOriginPoolIndex = 0;
		for ( i = 0; i < 5; i++ )
		{
			level.ambientRoomToneOriginPool[i] = spawnStruct();
			level.ambientRoomToneOriginPool[i].org = spawn( "script_origin", (0, 0, 0) );
			level.ambientRoomToneOriginPool[i].inuse = false;
			level.ambientRoomToneOriginPool[i].alias = "";
		}
		level.ambientRooms = [];
		thread updateActiveAmbientRoom();
		thread delayed_first_notify();
	}
	else	// We're running client scripts...
	{
		maps\_utility::registerClientSys("ambientPackageCmd");
		maps\_utility::registerClientSys("ambientRoomCmd");
	}
}


wait_until_first_player()
{
	players = get_players();
	if( !IsDefined( players[0] ) )
	{
		level waittill( "first_player_ready" );
	}
}


delayed_first_notify()
{
	//this resolves a race condition where the activateAmbient functions called before the player loads never get processed
	wait_until_first_player();
	wait .1; //MUST wait one frame to make sure these notify happen after the update threads are active
	level notify( "updateActiveAmbientPackage" );
	level notify( "updateActiveAmbientRoom" );
}

tidyup_triggers(client_num)
{
	amb_triggers = GetEntArray( "ambient_package","targetname");
	
	if(isdefined(amb_triggers) && amb_triggers.size > 0)
	{
		for(i = 0; i < amb_triggers.size; i ++)
		{
			trig = amb_triggers[i];
			
			if(isdefined(trig.in_volume) && isdefined(trig.in_volume[client_num]))
			{
				trig.in_volume[client_num] = 0;
			}
		}
	}
}

monitor_for_player_leave_trigger(trigPlayer, useAmbientRoom, useAmbientPackage)
{
	trigPlayer endon("disconnect");
	while ( trigPlayer isTouching ( self ) )
	{
		wait 0.1;
	}

	//iprintlnbold("Audio Trigger at " + self.origin + " not active");

	self.in_volume[trigPlayer getentitynumber()] = 0;

	if ( useAmbientPackage )
		deactivateAmbientPackage( self.script_ambientpackage, self.script_ambientpriority, trigPlayer );
	if ( useAmbientRoom )
		deactivateAmbientRoom( self.script_ambientroom, self.script_ambientpriority, trigPlayer );	
}

player_entered_trigger(trigPlayer, useAmbientRoom, useAmbientPackage)
{
	index = trigPlayer getentitynumber();
	
	if(!isdefined(self.in_volume[index]))
	{
		self.in_volume[index] = 0;
	}
	
	if(self.in_volume[index] == 0)
	{
		if ( useAmbientPackage )
			activateAmbientPackage( self.script_ambientpackage, self.script_ambientpriority, trigPlayer );
		if ( useAmbientRoom )
			activateAmbientRoom( self.script_ambientroom, self.script_ambientpriority, trigPlayer );

		self.in_volume[index] = 1;

		//iprintlnbold("Audio Trigger at " + self.origin + " active");

		self thread monitor_for_player_leave_trigger(trigPlayer, useAmbientRoom, useAmbientPackage);
	}
}

ambientPackageTrigger()
{
	wait_until_first_player();

	if(!level.clientscripts)
	{
		hasAmbientRoom = isdefined ( self.script_ambientroom );
		useAmbientRoom = hasAmbientRoom && isdefined( level.ambientRooms[self.script_ambientroom] );
	
		hasAmbientPackage = isdefined ( self.script_ambientpackage );
		useAmbientPackage = hasAmbientPackage && isdefined( level.ambientPackages[self.script_ambientpackage] );
		
		if (hasAmbientRoom && !useAmbientRoom)
		{
			assertmsg( "Trigger at " + self.origin + " references ambient room '" + self.script_ambientroom + "', but no such room has been declared\n" );
			return;
		}
	
		if (hasAmbientPackage && !useAmbientPackage)
		{
			assertmsg( "Trigger at " + self.origin + " references ambient package '" + self.script_ambientpackage + "', but no such package has been declared\n" );
			return;
		}
	
		if(!useAmbientPackage && !useAmbientRoom)
		{
			assertmsg( "Trigger at " + self.origin + " is an ambient trigger but has no room or package \n" );
			return; 
		}
		
	}
	else
	{
		useAmbientRoom = isdefined ( self.script_ambientroom );
	
		useAmbientPackage = isdefined ( self.script_ambientpackage );
	}
	

	if ( !isdefined( self.script_ambientpriority ) )
	{
		self.script_ambientpriority = 1;
	}

	self.in_volume = [];

	for (;;)
	{
		self waittill ( "trigger", trigPlayer );

		self player_entered_trigger(trigPlayer, useAmbientRoom, useAmbientPackage);
		
		wait(0.01);
	}
}

findHighestPriorityAmbientPackage()
{
	package = "";
	priority = -1;

	packageArray = getArrayKeys( level.ambientPackages );
	for ( i = 0; i < packageArray.size; i++ )
	{
		for ( j = 0; j < level.ambientPackages[packageArray[i]].priority.size; j++ )
		{
			if ( level.ambientPackages[packageArray[i]].refcount[j] && level.ambientPackages[packageArray[i]].priority[j] > priority )
			{
				package = packageArray[i];
				priority = level.ambientPackages[packageArray[i]].priority[j];
			}
		}
	}

	return package;
}

updateActiveAmbientPackage()
{
	wait_until_first_player();

	for (;;)
	{
		level waittill( "updateActiveAmbientPackage" );
		newAmbientPackage = findHighestPriorityAmbientPackage();
		if ( newAmbientPackage != "" && level.activeAmbientPackage != newAmbientPackage )
		{
			level notify( "killambientElementThread" + level.activeAmbientPackage );
			level.activeAmbientPackage = newAmbientPackage;
			array_thread( level.ambientPackages[level.activeAmbientPackage].elements, ::ambientElementThread );
			//iprintlnbold( "switching to package: " + level.activeAmbientPackage );
		}
	}
}

activateAmbientPackage( package, priority, trigPlayer )
{
	if(!level.clientscripts)	// Not running client side scripts, so business as usual, here on the server.
	{
		if ( !isdefined( level.ambientPackages[package] ) )
		{
			assertmsg( "activateAmbientPackage: must declare ambient package \"" + package + "\" in level_amb main before it can be activated" );
			return;
		}
	
		for ( i = 0; i < level.ambientPackages[package].priority.size; i++ )
		{
			if ( level.ambientPackages[package].priority[i] == priority )
			{
				level.ambientPackages[package].refcount[i]++;
				break;
			}
		}
		if ( i == level.ambientPackages[package].priority.size )
		{
			level.ambientPackages[package].priority[i] = priority;
			level.ambientPackages[package].refcount[i] = 1;
		}
	
		//iprintlnbold( "entering: " + package + " priority: " + priority );
		level notify( "updateActiveAmbientPackage" );
	}
	else				// Client side scripts...
	{
		notifyString = "A " + package + " " + priority;
		maps\_utility::setClientSysState("ambientPackageCmd", notifyString, trigPlayer);
	}
}

deactivateAmbientPackage( package, priority, trigPlayer )
{
	if(!level.clientscripts)	// Not running client side scripts, so business as usual, here on the server.
	{
		if ( !isdefined( level.ambientPackages[package] ) )
		{
			assertmsg( "deactivateAmbientPackage: must declare ambient package \"" + package + "\" in level_amb main before it can be deactivated" );
			return;
		}
	
		for ( i = 0; i < level.ambientPackages[package].priority.size; i++ )
		{
			if ( level.ambientPackages[package].priority[i] == priority && level.ambientPackages[package].refcount[i] )
			{
				level.ambientPackages[package].refcount[i]--;
				//iprintlnbold( "leaving package: " + package + " priority: " + priority );
				level notify( "updateActiveAmbientPackage" );
				return;
			}
		}
	}
	else	// Client side scripts
	{
		notifyString = "D " + package + " " + priority;
		maps\_utility::setClientSysState("ambientPackageCmd", notifyString, trigPlayer);
	}
}

declareAmbientPackage( package )
{
	if(!level.clientscripts)	// Not running client side scripts....
	{
		if ( isdefined( level.ambientPackages[package] ) )
			return;
	
		level.ambientPackages[package] = spawnStruct();
		level.ambientPackages[package].priority = [];
		level.ambientPackages[package].refcount = [];
		level.ambientPackages[package].elements = [];
	}
}

addAmbientElement( package, alias, spawnMin, spawnMax, distMin, distMax, angleMin, angleMax )
{
	if(!level.clientscripts)	// Not running client side scripts...
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
}

ambientElementThread()
{
	level endon( "killambientElementThread" + level.activeAmbientPackage );
	
	players = get_players();

	player = players[0];	

	player endon("disconnect");
	
	timer = 0;
	
	if ( self.distMin < 0 )
	{
		for (;;)
		{
			timer = randomfloatrange( self.spawnMin, self.spawnMax );
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
			timer = randomfloatrange( self.spawnMin, self.spawnMax );
			wait timer;

			index = getScriptOriginPoolIndex();
			if ( index >= 0 )
			{
				dist = randomintrange( self.distMin, self.distMax );
				angle = randomintrange( self.angleMin, self.angleMax );
				player_angle = player.angles[1];
				offset = anglestoforward( ( 0, angle + player_angle, 0 ) );
				offset = vectorscale( offset, dist );
				level.ambientPackageScriptOriginPool[index].org.origin = player geteye() + offset;

				wait .05; // this wait ensures that the position has settled before the sound is played
				//iprintlnbold( "playing3d: " + self.alias + " angle: " + angle + " dist: " + dist );
				level.ambientPackageScriptOriginPool[index].org playSound( self.alias, "sounddone" );
				level.ambientPackageScriptOriginPool[index] waittill( "sounddone" );
			}
		}
	}
}

getScriptOriginPoolIndex()
{
	for ( index = 0; index < level.ambientPackageScriptOriginPool.size; index++ )
	{
		if ( !level.ambientPackageScriptOriginPool[index].inuse )
		{
			level.ambientPackageScriptOriginPool[index].inuse = true;
			return index;
		}
	}
	
	return -1;
}

scriptOriginPoolThread()
{
	for (;;)
	{
		self.org waittill( "sounddone" );
		self.inuse = false;
		self notify( "sounddone" );
	}
}

roomToneFadeOutTimerThread( fadeOut )
{
	self endon( "killRoomToneFadeOutTimer" );

	wait fadeOut;
	self.inuse = false;
}

findHighestPriorityAmbientRoom()
{
	room = "";
	priority = -1;

	roomArray = getArrayKeys( level.ambientRooms );
	for ( i = 0; i < roomArray.size; i++ )
	{
		for ( j = 0; j < level.ambientRooms[roomArray[i]].priority.size; j++ )
		{
			if ( level.ambientRooms[roomArray[i]].refcount[j] )
			{
				//iprintlnbold("Found room "+roomArray[i] + " priority " + level.ambientRooms[roomArray[i]].priority[j] + " count " + level.ambientRooms[roomArray[i]].refcount[j]);
			}

			if ( level.ambientRooms[roomArray[i]].refcount[j] && level.ambientRooms[roomArray[i]].priority[j] > priority )
			{
				room = roomArray[i];
				priority = level.ambientRooms[roomArray[i]].priority[j];
			}
		}
	}

	return room;
}

updateActiveAmbientRoom()
{
	org = level.ambientRoomToneOriginPool[0].org;

	wait_until_first_player();

	players = get_players();

	player = players[0];

	for (;;)
	{
		level waittill( "updateActiveAmbientRoom" );
		newAmbientRoom = findHighestPriorityAmbientRoom();
		if ( newAmbientRoom != "" && level.activeAmbientRoom != newAmbientRoom )
		{
			if ( level.activeAmbientRoom != "" && isdefined( level.ambientRooms[level.activeAmbientRoom].tone ) )
			{
				for ( i = 0; i < level.ambientRoomToneOriginPool.size; i++ )
				{
					if ( level.ambientRoomToneOriginPool[i].inuse && level.ambientRoomToneOriginPool[i].alias == level.ambientRooms[level.activeAmbientRoom].tone )
					{
						//iprintlnbold("stopping "+level.ambientRoomToneOriginPool[i].alias);
						level.ambientRoomToneOriginPool[i].org stopLoopSound( level.ambientRooms[level.activeAmbientRoom].fadeOut );
						level.ambientRoomToneOriginPool[i] thread roomToneFadeOutTimerThread( level.ambientRooms[level.activeAmbientRoom].fadeOut );
						break;
					}
				}
			}

			level.activeAmbientRoom = newAmbientRoom;

			if ( isdefined( level.ambientRooms[level.activeAmbientRoom].tone ) )
			{
				//first check if the tone we are about to start is still fading out, if so fade it back in
				for ( i = 0; i < level.ambientRoomToneOriginPool.size; i++ )
				{
					if ( level.ambientRoomToneOriginPool[i].inuse && level.ambientRoomToneOriginPool[i].alias == level.ambientRooms[level.activeAmbientRoom].tone )
					{
						org = level.ambientRoomToneOriginPool[i].org;
						level.ambientRoomToneOriginPool[i] notify( "killRoomToneFadeOutTimer" );
						break;
					}
				}
				
				if ( i == level.ambientRoomToneOriginPool.size )
				{
					level.ambientRoomToneOriginPoolIndex++;
					if ( level.ambientRoomToneOriginPool.size == level.ambientRoomToneOriginPoolIndex )
					{
						level.ambientRoomToneOriginPoolIndex = 0;
					}
					org = level.ambientRoomToneOriginPool[level.ambientRoomToneOriginPoolIndex].org;
					level.ambientRoomToneOriginPool[level.ambientRoomToneOriginPoolIndex].alias = level.ambientRooms[level.activeAmbientRoom].tone;
					level.ambientRoomToneOriginPool[level.ambientRoomToneOriginPoolIndex].inuse = true;
				}
				//iprintlnbold("playing " + level.ambientRooms[level.activeAmbientRoom].tone);

				org playLoopSound( level.ambientRooms[level.activeAmbientRoom].tone, level.ambientRooms[level.activeAmbientRoom].fadeIn );
			}
			//iprintlnbold( "switching to room: " + level.activeAmbientRoom );
						
			if ( !isdefined( level.ambientRooms[level.activeAmbientRoom].reverb ) )
			{
				player deactivateReverb( "snd_enveffectsprio_level", 2 );
			}
			else
			{
				player setReverb( "snd_enveffectsprio_level", level.ambientRooms[level.activeAmbientRoom].reverb.reverbRoomType, level.ambientRooms[level.activeAmbientRoom].reverb.dry, level.ambientRooms[level.activeAmbientRoom].reverb.wet, level.ambientRooms[level.activeAmbientRoom].reverb.fade );
			}

		}
	}
}

activateAmbientRoom( room, priority, trigPlayer )
{
	if(!level.clientscripts)	// No client side scripting
	{
		if ( !isdefined( level.ambientRooms[room] ) )
		{
			assertmsg( "activateAmbientRoom: must declare ambient room \"" + room + "\" in level_amb main before it can be activated" );
			return;
		}
	
		for ( i = 0; i < level.ambientRooms[room].priority.size; i++ )
		{
			if ( level.ambientRooms[room].priority[i] == priority )
			{
				level.ambientRooms[room].refcount[i]++;
				break;
			}
		}
		if ( i == level.ambientRooms[room].priority.size )
		{
			level.ambientRooms[room].priority[i] = priority;
			level.ambientRooms[room].refcount[i] = 1;
		}
	
		//iprintlnbold( "entering: " + room + " priority: " + priority );
		level notify( "updateActiveAmbientRoom" );
	}
	else
	{
		notifyString = "A " + room + " " + priority;
		println("*** CS AR : " + room);
		maps\_utility::setClientSysState("ambientRoomCmd", notifyString, trigPlayer);
	}
}

deactivateAmbientRoom(room, priority, trigPlayer )
{
	if(!level.clientscripts)	// No client side scripting
	{
		if ( !isdefined( level.ambientRooms[room] ) )
		{
			assertmsg( "deactivateAmbientRoom: must declare ambient room \"" + room + "\" in level_amb main before it can be deactivated" );
			return;
		}
	
		for ( i = 0; i < level.ambientRooms[room].priority.size; i++ )
		{
			if ( level.ambientRooms[room].priority[i] == priority && level.ambientRooms[room].refcount[i] )
			{
				level.ambientRooms[room].refcount[i]--;
				//iprintlnbold( "leaving room: " + room + " priority: " + priority );
				level notify( "updateActiveAmbientRoom" );
				return;
			}
		}
	}
	else
	{
		notifyString = "D " + room + " " + priority;
		maps\_utility::setClientSysState("ambientRoomCmd", notifyString, trigPlayer);
	}
}

declareAmbientRoom( room )
{
	if(!level.clientscripts)
	{
		if ( isdefined( level.ambientRooms[room] ) )
			return;
	
		level.ambientRooms[room] = spawnStruct();
		level.ambientRooms[room].priority = [];
		level.ambientRooms[room].refcount = [];
	}
}

setAmbientRoomTone( room, alias, fadeIn, fadeOut )
{
	if(!level.clientscripts)
	{
		if ( !isdefined( level.ambientRooms[room] ) )
		{
			assertmsg( "setAmbientRoomTone: must declare ambient room \"" + room + "\" in level_amb main before it can have a room tone set" );
			return;
		}
	
		level.ambientRooms[room].tone = alias;
	
		level.ambientRooms[room].fadeIn = 2;
		if ( isDefined( fadeIn ) && fadeIn >= 0 )
		{
			level.ambientRooms[room].fadeIn = fadeIn;
		}
		level.ambientRooms[room].fadeOut = 2;
		if ( isDefined( fadeOut ) && fadeOut >= 0 )
		{
			level.ambientRooms[room].fadeOut = fadeOut;
		}
	}
}
setAmbientRoomReverb( room, reverbRoomType, dry, wet, fade )
{
	if(!level.clientscripts)
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
}