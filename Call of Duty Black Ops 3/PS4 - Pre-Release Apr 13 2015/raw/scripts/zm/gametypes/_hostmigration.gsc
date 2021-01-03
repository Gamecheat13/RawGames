#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace hostmigration;

/#
function debug_script_structs()
{	
	if(isdefined(level.struct))
	{
		println("*** Num structs " + level.struct.size);
		println("");
		
		for(i = 0; i < level.struct.size; i ++)
		{
			struct = level.struct[i];

			if (isdefined(struct.targetname))
				println("---" + i + " : " + struct.targetname);
			else
				println("---" + i + " : " + "NONE");
		}
	}
	else
	{
		println("*** No structs defined.");
	}
}
#/

function UpdateTimerPausedness()
{
	shouldBeStopped = isdefined( level.hostMigrationTimer );
	
	if ( !level.timerStopped && shouldBeStopped )
	{
		level.timerStopped = true;
		level.timerPauseTime = gettime();
	}
	else if ( level.timerStopped && !shouldBeStopped )
	{
		level.timerStopped = false;
		level.discardTime += gettime() - level.timerPauseTime;
	}
}

function Callback_HostMigrationSave()
{
// 	/#
//	debug_script_structs();
//	#/
}

function Callback_PreHostMigrationSave()
{
	zm_utility::undo_link_changes();
	
	if ( ( isdefined( level._hm_should_pause_spawning ) && level._hm_should_pause_spawning ) )
	{
		level flag::set( "spawn_zombies" );		// If we're migrating during a migration, this will allow the next migration to correctly start and stop the spawns.
	}
	
	for(i = 0; i < level.players.size; i++)
	{
		level.players[i] EnableInvulnerability();
	}	
}

function pauseTimer()
{	
	level.migrationTimerPauseTime = gettime();
}

function resumeTimer()
{	
	level.discardTime += gettime() - level.migrationTimerPauseTime;
}

function lockTimer()
{
	level endon( "host_migration_begin" );
	level endon( "host_migration_end" );
	
	for( ;; )
	{
		currTime = gettime();
		{wait(.05);};
		if ( !level.timerStopped && isdefined(level.discardTime) )
			level.discardTime += gettime() - currTime;
	}
}

function Callback_HostMigration()
{
//	/#
//	debug_script_structs();
//	#/

	zm_utility::redo_link_changes();
	
	setSlowMotion( 1, 1, 0 );
	//makeDvarServerInfo( "ui_guncycle", 0 );

	level.hostMigrationReturnedPlayerCount = 0;

	if ( level.gameEnded )
	{
	/#	println( "Migration starting at time " + gettime() + ", but game has ended, so no countdown." );	#/
		return;
	}

	sethostmigrationstatus(true);
	
	level notify( "host_migration_begin" );	
	
	for(i = 0; i < level.players.size; i++)
	{
		if(isdefined(level.hostmigration_link_entity_callback))
		{
			if(!isdefined(level.players[i]._host_migration_link_entity))
			{
				level.players[i]._host_migration_link_entity = level.players[i] [[level.hostmigration_link_entity_callback]]();
			}
		}
		
		level.players[i] thread hostMigrationTimerThink();
	}

	if(isdefined(level.hostmigration_ai_link_entity_callback))
	{
		zombies = GetAiTeamArray( level.zombie_team );
		if(IsDefined(zombies) && zombies.size > 0)
		{
			foreach(zombie in zombies)
			{
				if(!isdefined(zombie._host_migration_link_entity))
				{
					zombie._host_migration_link_entity = zombie [[level.hostmigration_ai_link_entity_callback]]();
				}
			}
		}
	}
	
	if (level.inPrematchPeriod)
		level waittill("prematch_over");
	
/#	println( "Migration starting at time " + gettime() );	#/

	level.hostMigrationTimer = true;

	
	thread lockTimer();
	
	zombies = GetAiTeamArray( level.zombie_team );
	if(IsDefined(zombies) && zombies.size > 0)
	{
		foreach(zombie in zombies)
		{
			if(isdefined(zombie._host_migration_link_entity))
			{
				
				ent = spawn("script_origin", zombie.origin);
				ent.angles = zombie.angles;
				zombie LinkTo(ent);
				
				ent LinkTo(zombie._host_migration_link_entity, "tag_origin", zombie._host_migration_link_entity WorldToLocalCoords(ent.origin), ent.angles + zombie._host_migration_link_entity.angles);
				zombie._host_migration_link_helper = ent;				
				zombie LinkTo(zombie._host_migration_link_helper);
			}
		}
	}
	
	level endon( "host_migration_begin" );
	
	//pause the spawning if it was active
	should_pause_spawning = level flag::get("spawn_zombies");
	
	if(should_pause_spawning )
	{
		level flag::clear("spawn_zombies");
	}
	
	hostMigrationWait();
	
	//make the players invulnerable for 3 seconds or so
	foreach(player in level.players)
	{
		player thread post_migration_invulnerability();
	}
	
	zombies = GetAiTeamArray( level.zombie_team );
	if(IsDefined(zombies) && zombies.size > 0)
	{
		foreach(zombie in zombies)
		{
			if(isdefined(zombie._host_migration_link_entity))
			{
				zombie Unlink();
				zombie._host_migration_link_helper delete();
				zombie._host_migration_link_helper = undefined;
				zombie._host_migration_link_entity = undefined;
			}
		}
	}
	
	if(should_pause_spawning )
	{
		level flag::set("spawn_zombies");
	}
	
	level.hostMigrationTimer = undefined;
	level._hm_should_pause_spawning = undefined;
	sethostmigrationstatus(false);
/#	println( "Migration finished at time " + gettime() );	#/
		
	level notify( "host_migration_end" );
}

function post_migration_become_vulnerable()
{
	self endon("disconnect");
	
}

function post_migration_invulnerability()
{
	self endon("disconnect");
	
	self EnableInvulnerability();
	wait(3);
	self DisableInvulnerability();
}


function matchStartTimerConsole_Internal( countTime, matchStartTimer )
{
	waittillframeend; // wait till cleanup of previous start timer if multiple happen at once
	//visionSetNaked( "mpIntro", 0 );
	
	level endon( "match_start_timer_beginning" );
	while ( countTime > 0 && !level.gameEnded )
	{
		matchStartTimer thread hud::font_pulse( level );
		wait ( matchStartTimer.inFrames * 0.05 );
		matchStartTimer setValue( countTime );
/*		if ( countTime == 2 )
			visionSetNaked( GetDvarString( "mapname" ), 3.0 ); */
		countTime--;
		wait ( 1 - (matchStartTimer.inFrames * 0.05) );
	}
}

function matchStartTimerConsole( type, duration )
{
	level notify( "match_start_timer_beginning" );
	{wait(.05);};
	
	matchStartText = hud::createServerFontString( "objective", 1.5 );
	matchStartText hud::setPoint( "CENTER", "CENTER", 0, -40 );
	matchStartText.sort = 1001;
	matchStartText setText( game["strings"]["waiting_for_teams"] );
	matchStartText.foreground = false;
	matchStartText.hidewheninmenu = true;
	
//	globallogic::waitForPlayers();
	matchStartText setText( game["strings"][type] ); // "match begins in:"
	
	matchStartTimer = hud::createServerFontString( "objective", 2.2 );
	matchStartTimer hud::setPoint( "CENTER", "CENTER", 0, 0 );
	matchStartTimer.sort = 1001;
	matchStartTimer.color = (1,1,0);
	matchStartTimer.foreground = false;
	matchStartTimer.hidewheninmenu = true;
	
	matchStartTimer hud::font_pulse_init();

	countTime = int( duration );
	
	if ( countTime >= 2 )
	{
		matchStartTimerConsole_Internal( countTime, matchStartTimer );
		//visionSetNaked( GetDvarString( "mapname" ), 3.0 );
	}
	else
	{
		//visionSetNaked( "mpIntro", 0 );
		//visionSetNaked( GetDvarString( "mapname" ), 1.0 );
	}
	
	matchStartTimer hud::destroyElem();
	matchStartText hud::destroyElem();
}

function hostMigrationWait()
{
	level endon( "game_ended" );
	
	// start with a 20 second wait.
	// once we get enough players, or the first 15 seconds pass, switch to a 5 second timer.

	// Handle the case of the notify firing before we're even checking for it.
	if ( level.hostMigrationReturnedPlayerCount < level.players.size * 2 / 3 )
	{
		thread matchStartTimerConsole( "waiting_for_teams", 20.0 );
		hostMigrationWaitForPlayers();
	}
	
	thread matchStartTimerConsole( "match_starting_in", 5.0 );
	wait 5;
}


function hostMigrationWaitForPlayers()
{
	level endon( "hostmigration_enoughplayers" );
	wait 15;
}

function hostMigrationTimerThink_Internal()
{
	level endon( "host_migration_begin" );
	level endon( "host_migration_end" );
	
	self.hostMigrationControlsFrozen = false;

	while ( !isAlive( self ) )
	{
		self waittill( "spawned" );
	}

	if(isdefined(self._host_migration_link_entity))
	{
		ent = spawn("script_origin", self.origin);
		ent.angles = self.angles;
		self LinkTo(ent);
		
		ent LinkTo(self._host_migration_link_entity, "tag_origin", self._host_migration_link_entity WorldToLocalCoords(ent.origin), ent.angles + self._host_migration_link_entity.angles);
		self._host_migration_link_helper = ent;
		/# println("Linking player to ent " + self._host_migration_link_entity.targetname); #/
	}
	
	self.hostMigrationControlsFrozen = true;
	self freezeControls( true );
	
	level waittill( "host_migration_end" );
}

function hostMigrationTimerThink()
{
	self endon( "disconnect" );
	level endon( "host_migration_begin" );

	hostMigrationTimerThink_Internal();
	
	if ( self.hostMigrationControlsFrozen )
	{
		self freezeControls( false );
		self.hostMigrationControlsFrozen = false;
		/# println(" Host migration unfreeze controls"); #/

	}
	
	if(isdefined(self._host_migration_link_entity))
	{
		self Unlink();
		self._host_migration_link_helper delete();
		self._host_migration_link_helper = undefined;
		
		if(isdefined(self._host_migration_link_entity._post_host_migration_thread))
		{
			self thread [[self._host_migration_link_entity._post_host_migration_thread]](self._host_migration_link_entity);
		}
		
		self._host_migration_link_entity = undefined;
	}
}

function waitTillHostMigrationDone()
{
	if ( !isdefined( level.hostMigrationTimer ) )
		return 0;
	
	starttime = gettime();
	level waittill( "host_migration_end" );
	return gettime() - starttime;
}

function waitTillHostMigrationStarts( duration )
{
	if ( isdefined( level.hostMigrationTimer ) )
		return;
	
	level endon( "host_migration_begin" );
	wait duration;
}

function waitLongDurationWithHostMigrationPause( duration )
{
	if ( duration == 0 )
		return;
	assert( duration > 0 );
	
	starttime = gettime();
	
	endtime = gettime() + duration * 1000;
	
	while ( gettime() < endtime )
	{
		waitTillHostMigrationStarts( (endtime - gettime()) / 1000 );
		
		if ( isdefined( level.hostMigrationTimer ) )
		{
			timePassed = waitTillHostMigrationDone();
			endtime += timePassed;
		}
	}
	
	if( gettime() != endtime )
	/#	println("SCRIPT WARNING: gettime() = " + gettime() + " NOT EQUAL TO endtime = " + endtime);		#/
		
	waitTillHostMigrationDone();
	
	return gettime() - starttime;
}

function waitLongDurationWithGameEndTimeUpdate( duration )
{
	if ( duration == 0 )
		return;
	assert( duration > 0 );
	
	starttime = gettime();
	
	endtime = gettime() + duration * 1000;
	
	while ( gettime() < endtime )
	{
		waitTillHostMigrationStarts( (endtime - gettime()) / 1000 );
		
		while ( isdefined( level.hostMigrationTimer ) )
		{
			endTime += 1000;
			setGameEndTime( int( endTime ) );
			wait 1;
		}
	}
	/#
	if( gettime() != endtime )
		println("SCRIPT WARNING: gettime() = " + gettime() + " NOT EQUAL TO endtime = " + endtime);
	#/	
	while ( isdefined( level.hostMigrationTimer ) )
	{
		endTime += 1000;
		setGameEndTime( int( endTime ) );
		wait 1;
	}
	
	return gettime() - starttime;
}

function find_alternate_player_place( v_origin, min_radius, max_radius, max_height, ignore_targetted_nodes )
{
	found_node = undefined;

	a_nodes = GetNodesInRadiusSorted( v_origin, max_radius, min_radius, max_height, "pathnodes" );
	
	if( IsDefined(a_nodes) && (a_nodes.size > 0) )
	{
		// Get the playable areas
		a_player_volumes = getentarray( "player_volume", "script_noteworthy" );

		// We have a bunch of suitable nodes, check that we won't telefrag if we use them
		index = a_nodes.size - 1;
		for( i=index; i>=0; i-- )
		{
			n_node = a_nodes[ i ];

			// Don't use nodes thar are targetting things, like elevator shaft nodes for example
			if( ignore_targetted_nodes == true )
			{
				if( IsDefined(n_node.target) )
				{
					continue;
				}
			}
			
			// Make sure we don't telefrag at this position
			if( !positionWouldTelefrag(n_node.origin) )
			{
				if( zm_utility::check_point_in_enabled_zone(n_node.origin, true, a_player_volumes) )
				{
					// Sanity check - Is the node on the ground
					v_start = ( n_node.origin[0], n_node.origin[1], n_node.origin[2]+30 );
					v_end = ( n_node.origin[0], n_node.origin[1], n_node.origin[2]-30 );
					trace = bulletTrace( v_start, v_end, false, undefined );
					if(trace["fraction"] < 1)
					{
						override_abort = 0;

						// Finally we have a potential custum level reject function for bad nodes, if they are found after ship
						if( IsDefined(level._whoswho_reject_node_override_func) )
						{
							override_abort = [[ level._whoswho_reject_node_override_func ]]( v_origin, n_node );
						}
						
						if( !override_abort )
						{
							found_node = n_node;
							break;
						}
					}
				}
			}
		}
	}

	return (found_node);
}

function hostmigration_put_player_in_better_place()
{
	spawnPoint = undefined;

	// Safety default range to get a required node from
	spawnPoint =  find_alternate_player_place(self.origin, 50, 150, 64, true);

	// We failed, lets try again but further out

	if( !IsDefined(spawnPoint) )
	{
		spawnPoint =  find_alternate_player_place(self.origin, 150, 400, 64, true);
	}
	
	// If we failed again, try again with much loser restrictions
	if( !IsDefined(spawnPoint) )
	{
		spawnPoint = find_alternate_player_place(self.origin, 50, 400, 256, false);
	}
	
	
	// If no luck, try and get a spawn point near the team
	if( !IsDefined(spawnPoint) )
	{
		spawnPoint = zm::check_for_valid_spawn_near_team( self, true );
	}

	// Still no luck, then use the start location
	if( !Isdefined(spawnPoint) )
	{ 
		match_string = "";
	
		location = level.scr_zm_map_start_location;
		if ((location == "default" || location == "" ) && IsDefined(level.default_start_location))
		{
			location = level.default_start_location;
		}		
	
		match_string = level.scr_zm_ui_gametype + "_" + location;
	
		spawnPoints = [];
		structs = struct::get_array("initial_spawn", "script_noteworthy");
		if(IsDefined(structs))
		{
			foreach(struct in structs)			
			{
				if(IsDefined(struct.script_string) )
				{
					
					tokens = strtok(struct.script_string," ");
					foreach(token in tokens)
					{
						if(token == match_string )
						{
							spawnPoints[spawnPoints.size] =	struct;
						}
					}
				}
				
			}			
		}
		
		if(!IsDefined(spawnPoints) || spawnPoints.size == 0) // old method, failed new method.
		{
			spawnPoints = struct::get_array("initial_spawn_points", "targetname");
		}	
						
		assert(IsDefined(spawnPoints), "Could not find initial spawn points!");

		spawnPoint = zm::getFreeSpawnpoint( spawnPoints, self );
	}	
	
	if(isdefined(spawnPoint))
	{
		self SetOrigin( spawnPoint.origin );
	}
}
