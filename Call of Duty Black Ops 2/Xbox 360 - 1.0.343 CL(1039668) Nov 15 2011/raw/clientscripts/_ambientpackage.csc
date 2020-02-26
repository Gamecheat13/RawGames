#include clientscripts\_utility;

// Client side re-imagining.


/*			Example map_amb.gsc file:
#include clientscripts\_ambientpackage;


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


deactivateAmbientPackage(client, package, priority)
{
	if ( !isdefined( level.ambientPackages[package] ) )
	{
		assertmsg( "deactivateAmbientPackage: must declare ambient package \"" + package + "\" in level_amb main before it can be deactivated" );
		return;
	}

	for( i = 0; i < level.ambientPackages[package].priority.size; i++)
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

deactivateAmbientRoom(client, room, priority)
{
	if ( !isdefined( level.ambientRooms[room] ) )
	{
		assertmsg( "deactivateAmbientRoom: must declare ambient room \"" + room + "\" in level_amb main before it can be deactivated" );
		return;
	}

	for( i = 0; i < level.ambientRooms[room].priority.size; i++ )
	{
		if( level.ambientRooms[room].priority[i] == priority && level.ambientRooms[room].refcount[i] )
		{
			level.ambientRooms[room].refcount[i]--;
			//iprintlnbold( "leaving room: " + room + " priority: " + priority );
			level notify( "updateActiveAmbientRoom" );
			return;
		}
	}
}

trig_enter(ent)
{
	if( self.useAmbientPackage )
		activateAmbientPackage( 0, self.script_ambientpackage, self.script_ambientpriority);
	if( self.useAmbientRoom )
		activateAmbientRoom( 0, self.script_ambientroom, self.script_ambientpriority );
	}

trig_leave(ent)
{
	if( self.useAmbientPackage )
		deactivateAmbientPackage( 0, self.script_ambientpackage, self.script_ambientpriority );
	if( self.useAmbientRoom )
		deactivateAmbientRoom( 0, self.script_ambientroom, self.script_ambientpriority );
}

AmbientPackageTrigger()
{

	hasAmbientRoom = isdefined ( self.script_ambientroom );
	useAmbientRoom = hasAmbientRoom && isdefined( level.ambientRooms[self.script_ambientroom] );

	hasAmbientPackage = isdefined ( self.script_ambientpackage );
	useAmbientPackage = hasAmbientPackage && isdefined( level.ambientPackages[self.script_ambientpackage] );
	
	self.useAmbientRoom = useAmbientRoom;
	self.useAmbientPackage = useAmbientPackage;
	
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

	if ( !isdefined( self.script_ambientpriority ) )
	{
		self.script_ambientpriority = 1;
	}

	self.in_volume = [];

	for (;;)
	{
		self waittill ( "trigger", trigPlayer );

		if(trigPlayer issplitscreenhost())
		{
			self thread trigger_thread(trigPlayer, ::trig_enter, ::trig_leave);
		}
		
		wait(0.01);
	}
}

init_ambient_package_triggers()
{
	wait(0.1);	// Let the other thread add the packages and rooms.
	
	player = level.localPlayers[0];
	remove_triggers_from_ent( player );

	trigs = GetEntArray( 0, "ambient_package","targetname");
	
	array_thread( trigs, ::ambientPackageTrigger);
	println("Client : " + trigs.size + " ambient package triggers.");
	
}

init()
{
	level.activeAmbientPackage = "";
	level.ambientPackages = [];
	level.ambientNumMissedSounds = 0;
	level.ambientNumSeqMissedSounds = 0;
	
	thread updateActiveAmbientPackage();
	thread saveRestore();

	level.ambientPackageScriptOriginPool = [];
	for ( i = 0; i < 5; i++ )
	{
		level.ambientPackageScriptOriginPool[i] = spawnStruct();
		level.ambientPackageScriptOriginPool[i].org = spawnfakeent(0);	
		
		level.ambientPackageScriptOriginPool[i].inuse = false;
		level.ambientPackageScriptOriginPool[i] thread scriptOriginPoolThread();
	}

	level.activeAmbientRoom = "";
	level.ambientRooms = [];
	level thread updateActiveAmbientRoom();

	clientscripts\_utility::registerSystem("ambientPackageCmd", ::ambientPackageCmdHandler);
	clientscripts\_utility::registerSystem("ambientRoomCmd", ::ambientRoomCmdHandler);
	
	level thread init_ambient_package_triggers();	
}


declareAmbientPackage( package )
{
	if ( isdefined( level.ambientPackages[package] ) )
		return;

	level.ambientPackages[package] = spawnStruct();
	level.ambientPackages[package].priority = [];
	level.ambientPackages[package].refcount = [];
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

declareAmbientRoom( room )
{
		if ( isdefined( level.ambientRooms[room] ) )
			return;
	
		level.ambientRooms[room] = spawnStruct();
		level.ambientRooms[room].priority = [];
		level.ambientRooms[room].refcount = [];
		level.ambientRooms[room].ent = spawnfakeent(0);
}


setAmbientRoomTone( room, alias, fadeIn, fadeOut )
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


setAmbientRoomSnapshot( room, snapshot)
{
	if ( !isdefined( level.ambientRooms[room] ) )
	{
		assertmsg( "setAmbientRoomSnapshot: must declare ambient room \"" + room + "\" in level_amb main before it can have a room snapshot set" );
		return;
	}
	
	level.ambientRooms[room].snapshot = snapshot;
}


setAmbientRoomContext( room, type, value)
{
	if ( !isdefined( level.ambientRooms[room] ) )
	{
		assertmsg( "setAmbientRoomContext: must declare ambient room \"" + room + "\" in level_amb main before it can have a room context set" );
		return;
	}
	
	if(!isdefined(level.ambientRooms[room].context))
	{
		level.ambientRooms[room].context = [];
	}
	
	level.ambientRooms[room].context[type] = value;
	
	if(!isdefined(level.ambientContexts))
	{
		level.ambientContexts = [];
	}
	
	level.ambientContexts[type] = type;
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

activateAmbientPackage( clientNum, package, priority )
{
		if ( !isdefined( level.ambientPackages[package] ) )
		{
			assertmsg( "activateAmbientPackage: must declare ambient package \"" + package + "\" in level_amb.csc main before it can be activated" );
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
		
		level notify( "updateActiveAmbientPackage" );			
}

activateAmbientRoom( clientNum, room, priority )
{
	if ( !isdefined( level.ambientRooms[room] ) )
	{
		assertmsg( "activateAmbientRoom: must declare ambient room \"" + room + "\" in level_amb.csc main before it can be activated" );
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

	level notify( "updateActiveAmbientRoom" );
}

ambientPackageCmdHandler(clientNum, state, oldState)
{
	if(state != "")
	{
		split_state = splitargs(state);
		
		if(split_state.size != 3)
		{
			println("*** Client : Malformed arguements to ambient packages " + state);
		}
		else
		{
			command = split_state[0];
			package = split_state[1];
			priority = int(split_state[2]);
			
			println("### APC : " + command + " " + package + " " + priority);
			
			if(command == "A")
			{
				if ( !isdefined( level.ambientPackages[package] ) )
				{
					assertmsg( "activateAmbientPackage: must declare ambient package \"" + package + "\" in level_amb.csc main before it can be activated" );
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
			
	/#
//				iprintlnbold( "entering: " + package + " priority: " + priority );
	#/			
				level notify( "updateActiveAmbientPackage" );			
			}
			else if(command == "D")
			{
				if ( !isdefined( level.ambientPackages[package] ) )
				{
					assertmsg( "deactivateAmbientPackage: must declare ambient package \"" + package + "\" in level_amb.csc main before it can be deactivated" );
					return;
				}
			
				for ( i = 0; i < level.ambientPackages[package].priority.size; i++ )
				{
					if ( level.ambientPackages[package].priority[i] == priority && level.ambientPackages[package].refcount[i] )
					{
						level.ambientPackages[package].refcount[i]--;
	/#					
//						iprintlnbold( "leaving package: " + package + " priority: " + priority );
	#/					
						level notify( "updateActiveAmbientPackage" );
						return;
					}
				}					
			}
			else
			{
				assertmsg("Unknown command in ambientPackageCmdHandler " + state);
				return;
			}			
		}
	}
}


ambientRoomCmdHandler(clientNum, state, oldState)
{
	if(state != "")
	{
		split_state = splitargs(state);
		
		if(split_state.size != 3)
		{
			println("*** Client : Malformed arguements to ambient packages " + state);
		}
		else
		{

			command = split_state[0];
			room = split_state[1];
			priority = int(split_state[2]);			
			
			if(command == "A")
			{
				if ( !isdefined( level.ambientRooms[room] ) )
				{
					assertmsg( "activateAmbientRoom: must declare ambient room \"" + room + "\" in level_amb.csc main before it can be activated" );
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
/#			
//				iprintlnbold( "entering room: " + room + " priority: " + priority );
#/
				level notify( "updateActiveAmbientRoom" );
			}
			else if(command == "D")
			{
				if ( !isdefined( level.ambientRooms[room] ) )
				{
					assertmsg( "deactivateAmbientRoom: must declare ambient room \"" + room + "\" in level_amb.csc main before it can be deactivated" );
					return;
				}
			
				for ( i = 0; i < level.ambientRooms[room].priority.size; i++ )
				{
					if ( level.ambientRooms[room].priority[i] == priority && level.ambientRooms[room].refcount[i] )
					{
						level.ambientRooms[room].refcount[i]--;
/#						
//						iprintlnbold( "leaving room: " + room + " priority: " + priority );
#/						
						level notify( "updateActiveAmbientRoom" );
						return;
					}
				}
			}
			else
			{
				assertmsg("Unknown command in ambientRoomCmdHandler " + state);
				return;			
			}
		}
	}
}

ambientElementThread()
{
	level endon( "killambientElementThread" + level.activeAmbientPackage );
	
/*	players = get_players();

	player = players[0];	

	player endon("disconnect"); */
	
	timer = 0;
	
	if ( self.distMin < 0 )
	{
		for (;;)
		{
			timer = randomfloatrange( self.spawnMin, self.spawnMax );
			wait timer;
			if( GetDvarint( "debug_audio" ) > 0 )
			{
				/#
				iprintlnbold( "AP : playing2d: " + self.alias );
				#/
			}
			playsound( 0, self.alias );
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
				player_angle = getlocalclientangles(0)[1];
				offset = anglestoforward( ( 0, angle + player_angle, 0 ) );
				offset = VectorScale( offset, dist );
				
				pos = getlocalclienteyepos(0) + offset;
				setfakeentorg(0, level.ambientPackageScriptOriginPool[index].org, pos);
				
				level.ambientPackageScriptOriginPool[index].soundId =  playSound( 0, self.alias, pos );
				//iprintlnbold( "playing3d: " + self.alias + " angle: " + angle + " dist: " + dist + " id " + level.ambientPackageScriptOriginPool[index].soundId);

				if( GetDvarint( "debug_audio" ) > 0 )
				{
					if(level.ambientPackageScriptOriginPool[index].soundId == -1)
					{
						col = (0.8, 0.0, 0.0);
					}
					else
					{
						col = (0.0, 0.8, 0.0);
					}
					
					print3d (pos, "AP : " + self.alias, col, 1, 3, 30);
				}

				while(level.ambientPackageScriptOriginPool[index].soundId != -1)
				{
					wait(0.01);
				}

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
			level.ambientNumSeqMissedSounds = 0;	
	
			return index;
		}
	}

	level.ambientNumMissedSounds++;
	level.ambientNumSeqMissedSounds++;	

	if( GetDvarint( "debug_audio" ) > 0 )
	{
		/#
		iprintlnbold("No free origins " + level.ambientNumSeqMissedSounds + " ( " + level.ambientNumMissedSounds + " )");	
		#/
	}
	
	return -1;
}

scriptOriginPoolThread()
{
	for (;;)
	{
	
		// On the server, this looked like :
		
		//		self.org waittill( "sounddone" );
		//		self.inuse = false;
		//		self notify( "sounddone" ); */

		// But because this isn't being done with entities, there's no sound notification,
		// so on the client side, we'll poll ourselves, to see if we've finished playing, and if so
		// mark our selves as free.
	
		if(self.inuse == true)
		{
			if(isdefined(self.soundId))
			{
				if(self.SoundId != -1)
				{
					if(!SoundPlaying(self.soundId))
					{
						self.inuse = false;
						self.soundId = -1;
//						iprintlnbold("Freeing script origin.");					
					}
				}
				else
				{
					self.inUse = false;	// Sound failed to play - free up the origin.
//					iprintlnbold("Freeing script origin.");					
				}
			}
		}

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
	for (;;)
	{
		level waittill( "updateActiveAmbientPackage" );
		newAmbientPackage = findHighestPriorityAmbientPackage();
		println("*** nap " + newAmbientPackage + " " + level.activeAmbientPackage);
		if ( newAmbientPackage != "" && level.activeAmbientPackage != newAmbientPackage )
		{
			level notify( "killambientElementThread" + level.activeAmbientPackage );
			level.activeAmbientPackage = newAmbientPackage;
			array_thread( level.ambientPackages[level.activeAmbientPackage].elements, ::ambientElementThread );
			//iprintlnbold( "switching to package: " + level.activeAmbientPackage );
		}
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
	
	if(isdefined(roomArray))
	{
		for ( i = 0; i < roomArray.size; i++ )
		{
			for ( j = 0; j < level.ambientRooms[roomArray[i]].priority.size; j++ )
			{
				if ( level.ambientRooms[roomArray[i]].refcount[j] )
				{
				/#
					//iprintlnbold("Found room "+roomArray[i] + " priority " + level.ambientRooms[roomArray[i]].priority[j] + " count " + level.ambientRooms[roomArray[i]].refcount[j]);
				#/					
				}
	
				if ( level.ambientRooms[roomArray[i]].refcount[j] && level.ambientRooms[roomArray[i]].priority[j] > priority )
				{
					room = roomArray[i];
					priority = level.ambientRooms[roomArray[i]].priority[j];
				}
			}
		}
	}

	return room;
}

saveRestore()
{
	for(;;)
	{
		level waittill("save_restore");
		level.activeAmbientRoom = "";
		level notify( "updateActiveAmbientRoom" );
	}
}

updateActiveAmbientRoom()
{
	for (;;)
	{
		newAmbientRoom = findHighestPriorityAmbientRoom();

		if(newAmbientRoom == level.activeAmbientRoom)
		{
			//PrintLn( "AAR_tst: WAITING for 'updateActiveAmbientRoom' notify" );
			level waittill( "updateActiveAmbientRoom" );
			//PrintLn( "AAR_tst: RECEIVED for 'updateActiveAmbientRoom' notify" );
		}

//		println("*** AAR_tst: nar " + newAmbientRoom + " " + level.activeAmbientRoom);

		if(newAmbientRoom == level.activeAmbientRoom)
		{
			continue;
		}

		oldroom = level.ambientRooms[level.activeAmbientRoom];
		newroom = level.ambientRooms[newAmbientRoom];

		if(isdefined(oldroom) && isdefined(newroom) 
		&& isdefined(oldroom.tone) && isdefined(newroom.tone) 
		&& oldroom.tone == newroom.tone)
		{	//keep same playing
			tmp = newroom.ent;
			newroom.ent = oldroom.ent;
			oldroom.ent = tmp;
		}
		else
		{   //crossfade
			if(isdefined(newroom) && isdefined(newroom.tone))
			{
				//println("AAR_tst: ambient room playing "+newroom.tone);
				newroom.id = playloopsound( 0, newroom.ent, newroom.tone, newroom.fadeIn );
			}
			else
			{
				//println("AAR_tst: no new ambient room alias" );
			}

			if(isdefined(oldroom) && isdefined(oldroom.tone))
			{
				//println("AAR_tst: ambient room stopping "+oldroom.tone);
				stoploopsound(0, oldroom.ent, oldroom.fadeOut);
				//while(SoundPlaying(oldroom.id))
				//wait(.01);
			}
			else
			{
				//println("AAR_tst: no old ambient room alias");
			}
		}
		
		if ( !isdefined( newroom ) || !isdefined( newroom.reverb ) )
		{
			deactivateReverb( "snd_enveffectsprio_level", 2 );
		}
		else
		{
			setReverb( "snd_enveffectsprio_level", newroom.reverb.reverbRoomType, newroom.reverb.dry, newroom.reverb.wet, newroom.reverb.fade );
		}
		
		snapshot = "default";
			
		if( isdefined( newroom ) && isdefined( newroom.snapshot ) )
		{
			snapshot = newroom.snapshot;
		}

		setAmbientSnapshot(snapshot);
		
		if(isdefined(newroom) && isdefined(level.ambientContexts))
		{
			contexts = getArrayKeys(level.ambientContexts);
			
			//reset all to default
			for(i=0; i<contexts.size; i++)
			{
				setsoundcontext( contexts[i], "");
			}
			
			//set contexts used in this box
			if( isdefined( newroom.context ) )
			{
				keys = getArrayKeys(newroom.context);
			
				for(i=0; i<keys.size; i++)
				{
					//iprintlnbold(keys[i]+ newroom.context[ keys[i]]);
					setsoundcontext( keys[i], newroom.context[ keys[i]]);
				}
			}
		}

		level.activeAmbientRoom = newAmbientRoom;
	}
}
