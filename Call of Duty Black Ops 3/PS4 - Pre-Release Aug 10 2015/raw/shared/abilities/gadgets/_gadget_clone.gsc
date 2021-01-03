#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\ai_puppeteer_shared;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\array_shared;
#using scripts\shared\_oob;
#using scripts\shared\scoreevents_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
   	                                                         	                                                                                                                                               	                                                      	                                                                              	                                                          	                                    	                                     	                                                     	                                                                                      	                                                             	                                                                                                    	                                             	                                     	                                                     

#using scripts\shared\system_shared;

#precache( "fx", "player/fx_plyr_clone_vanish" );
#precache( "fx", "player/fx_plyr_clone_reaper_orb" );
#precache( "fx", "player/fx_plyr_clone_reaper_appear" );

function autoexec __init__sytem__() {     system::register("gadget_clone",&__init__,undefined,undefined);    }


 // don't change this.

















 // ( Max time is equivalent to CLONE_SPAWN_FROM_PLAYER_MAX / ORB_TRAVEL_VELOCITY )




	
	
function __init__()
{
	ability_player::register_gadget_activation_callbacks( 42, &gadget_clone_on, &gadget_clone_off );
	ability_player::register_gadget_possession_callbacks( 42, &gadget_clone_on_give, &gadget_clone_on_take );
	ability_player::register_gadget_flicker_callbacks( 42, &gadget_clone_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 42, &gadget_clone_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 42, &gadget_clone_is_flickering );

	callback::on_connect( &gadget_clone_on_connect );
	
	clientfield::register( "actor", "clone_activated", 1, 1, "int" );
	clientfield::register( "actor", "clone_damaged", 1, 1, "int" );
	clientfield::register( "allplayers", "clone_activated", 1, 1, "int" );
	
	level._clone = [];
}

function gadget_clone_is_inuse( slot )
{
	return self GadgetIsActive( slot );
}

function gadget_clone_is_flickering( slot )
{
	// returns true when the gadget is flickering
	return self GadgetFlickering( slot );
}

function gadget_clone_on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
}

function gadget_clone_on_give( slot, weapon )
{

}

function gadget_clone_on_take( slot, weapon )
{

}

//self is the player
function gadget_clone_on_connect()
{
	// setup up stuff on player connect	
}

function killClones( player )
{
	if( isDefined( player._clone ) )
	{
		foreach( clone in player._clone )
		{
			if( isDefined( clone ) )
			{
				clone notify( "clone_shutdown" );
			}
		}
	}
}

function is_jumping()
{
	// checking PMF_JUMPING in code would give more accurate results
	ground_ent = self GetGroundEnt();
	return (!isdefined(ground_ent));
}

function CalculateSpawnOrigin( origin, angles, cloneDistance )
{
	player = self;
	
	startAngles = [];
		
	testangles = [];
	testangles[0] = ( 0, 0, 0);
	testangles[1] = ( 0, -30, 0);
	testangles[2] = ( 0, 30, 0);
	testangles[3] = ( 0, -60, 0);
	testangles[4] = ( 0, 60, 0);
	testangles[5] = ( 0, 90, 0);
	testangles[6] = ( 0, -90, 0);
	testangles[7] = ( 0, 120, 0);
	testangles[8] = ( 0, -120, 0);
	testangles[9] = ( 0, 150, 0);
	testangles[10] = ( 0, -150, 0);
	testangles[11] = ( 0, 180, 0);
	
	validSpawns = spawnStruct();
	
	validPositions = [];
	validAngles = [];
	
	zoffests = [];
	zoffests[0] = 5;
	zoffests[1] = 0;
	if( player is_jumping() )
		zoffests[2] = -5;
	
	foreach( zoff in zoffests )
	{
		for( i = 0; i < testangles.size; i++ )
		{
			startAngles[i] = ( 0, angles[1], 0 );
			startPoint = origin + VectorScale( anglestoforward( startAngles[i] + testangles[i]), cloneDistance );
			startPoint += ( 0, 0, zoff );
				
			if( PlayerPositionValidIgnoreEnt( startPoint, self ) )
			{
				closestNavMeshPoint = GetClosestPointOnNavMesh( startpoint, 500 );
				if( isDefined( closestNavMeshPoint ) )
				{
					startPoint = closestNavMeshPoint;
				}
				validpositions[ validpositions.size ] = startPoint;
				validAngles[ validAngles.size ] = startAngles[i] + testangles[i];
				
				if( validAngles.size == 3 )
				{
					break;
				}				
			}
		}
		
		if( validAngles.size == 3 )
		{
			break;
		}
	}
	
	validspawns.validPositions = validpositions;
	validspawns.validAngles = validAngles;	
	return validspawns;
}

function insertClone( clone )
{
	insertedClone = false;
	for( i = 0; i < 20; i++ )
	{
		if( !isDefined( level._clone[i] ) )
		{
			level._clone[i] = clone;
			insertedClone = true;
			
			/#
			PrintLn( "inserted at index: " + i + " clone count is: " + level._clone.size );
			#/
			break;
		}
	}
	assert( insertedClone );
}

function removeClone( clone )
{
	for( i = 0; i < 20; i++ )
	{
		if( isDefined( level._clone[i] ) && ( level._clone[i] == clone ) )
		{
			level._clone[i] = undefined;
			array::remove_undefined( level._clone );
			
			/#
			PrintLn( "removed clone at index: " + i + " clone count is: " + level._clone.size );
			#/
			break;
		}
	}
}

function removeOldestClone()
{
	assert( level._clone.size == 20 );
	
	oldestClone = undefined;
	for( i = 0; i < 20; i++ )
	{
		if( !isDefined( oldestClone ) && isDefined( level._clone[i] ) )
		{
			oldestClone = level._clone[i];
			oldestIndex = i;
		}
		else if( isDefined( level._clone[i] ) && ( level._clone[i].spawnTime < oldestClone.spawnTime ) )
		{
			oldestClone = level._clone[i];
			oldestIndex = i;
		}
	}
	
				
	/#
	PrintLn( "Exceeded max clones: removing clone at index: " + i + " clone count is: " + level._clone.size );
	#/
	
	level._clone[oldestIndex] notify ( "clone_shutdown" );
	level._clone[oldestIndex] = undefined;
	
	array::remove_undefined( level._clone );
}

function spawnClones() // self is player
{
	self endon( "death" );
	
	self killClones( self );
	
	self._clone = [];
	velocity = self getvelocity();
	velocity = velocity + ( 0, 0, -velocity[2] );
	velocity = Vectornormalize( velocity );
	origin = self.origin + velocity * 17 + VectorScale( anglestoforward( self getangles() ), 17 );
	validSpawns = CalculateSpawnOrigin( origin, self getangles(), 60 );
	
	// If there weren't enough valid spawn positions, try extending the spawn distance to find additional spawn points.
	if ( validSpawns.validPositions.size < 3 )
	{
		validExtendedSpawns = CalculateSpawnOrigin( origin, self getangles(), 60 * 3 );
		
		for ( index = 0; index < validExtendedSpawns.validPositions.size && validSpawns.validPositions.size < 3; index++ )
		{
			validSpawns.validPositions[ validSpawns.validPositions.size ] = validExtendedSpawns.validPositions[ index ];
			validSpawns.validAngles[ validSpawns.validAngles.size ] = validExtendedSpawns.validAngles[ index ];
		}
	}
	
	for( i = 0; i < validSpawns.validpositions.size; i++ )
	{
		travelDistance = Distance( validSpawns.validpositions[i], self.origin );
		validspawns.spawnTimes[i] = travelDistance / 800;
		self thread _CloneOrbFx( validSpawns.validpositions[i], validspawns.spawnTimes[i] );
	}
	for( i = 0; i < validSpawns.validpositions.size; i++ )
	{
		if( level._clone.size < 20 )
		{
			// do nothing here
		}
		else
		{
			removeOldestClone();
		}
		
		clone = SpawnActor(
						"spawner_bo3_human_male_reaper_mp",
						validSpawns.validpositions[i],
						validSpawns.validAngles[i],
						"",
						true );
	
		_ConfigureClone( clone, self, AnglesToForward( validSpawns.validAngles[i] ), validspawns.spawnTimes[i] );
		self._clone[self._clone.size] = clone;
		insertClone( clone );
		{wait(.05);};
	}
	self notify( "reveal_clone" );
	
	if( self oob::IsOutOfBounds() )
	{
		gadget_clone_off( self, undefined );
	}
}

function gadget_clone_on( slot, weapon )
{
	self clientfield::set( "clone_activated", 1 );
	PlayFx( "player/fx_plyr_clone_reaper_appear", self.origin, AnglesToForward( self getangles() ));
	thread spawnClones();
}

function private _UpdateClonePathing() // self is clone
{
	self endon( "death" );
	while( true )
	{
		distance = 0;
		if( isDefined( self._clone_goal ) )
		{
			distance = DistanceSquared( self._clone_goal, self.origin );
		}
		
		if( distance < 120 * 120 || !self HasPath() )
		{
			forward = AnglesToForward( self getangles() );
			searchOrigin = self.origin + forward * 750;
			self._goal_center_point = searchOrigin;
		
			queryResult = PositionQuery_Source_Navigation(
			self._goal_center_point,
			500,
			750,
			750,
			100,
			self );
			
			if( queryResult.data.size == 0 )
			{
				queryResult = PositionQuery_Source_Navigation(
				self.origin,
				500,
				750,
				750,
				100,
				self );
			}
			
			if( queryResult.data.size > 0 )
			{
				randIndex = RandomIntRange( 0, queryResult.data.size );
			
				self setgoalpos( queryResult.data[ randIndex ].origin, true );
				self._clone_goal = queryresult.data[ randIndex ].origin;
				self._clone_goal_max_dist = 750;
			}
		}
		//util::drawcylinder( self._goal_center_point, self._clone_goal_max_dist, 10, .5, "stop_notify_asdf" );
		//util::debug_sphere( self._clone_goal, 10, ( 1, 0, 1 ), 1, 1 );
		wait( .5 );
	}
}

function _CloneOrbFx( endPos, travelTime ) //self is player
{
	spawnPos = self GetTagOrigin( "j_spine4" );
	fxOrg = spawn( "script_model", spawnPos );
	fxOrg SetModel( "tag_origin" );

	fx = PlayFxOnTag( "player/fx_plyr_clone_reaper_orb", fxOrg, "tag_origin" );
	
	fxEndPos = endPos + ( 0, 0, ( 40 - 5 ) );
	fxOrg MoveTo( fxEndPos, travelTime );
	self util::waittill_any_timeout( traveltime, "death", "disconnect" );
	
	fxOrg delete();
}

function private _ConfigureClone( clone, player, forward, spawnTime ) // self is player
{
	clone.isAiClone = true;
	clone.properName = "";
	clone.ignoreTriggerDamage = true;
	clone.minWalkDistance = 125;
	clone.overrideActorDamage = &cloneDamageOverride;
	clone.spawnTime = GetTime();
	
	clone PushActors( true );  // Don't collide with other actors.
	clone PushPlayer( true );  // Don't collide with players.
	clone SetContents( (1 << 13) );  // Collide with bullets.
	clone SetAvoidanceMask( "avoid none" );  // Disable all avoidance.
	
	clone ASMSetAnimationRate( RandomFloatRange( 0.98, 1.02 ) );
	
	clone setclone();
	clone _CloneSelectWeapon( player );
	clone thread _CloneWatchDeath();
	clone thread _CloneWatchOwnerDisconnect( player );
	clone thread _CloneWatchShutdown();
	clone thread _CloneFakeFire();
	clone._goal_center_point = forward * 1000 + clone.origin;
	
	clone._goal_center_point = GetClosestPointOnNavMesh( clone._goal_center_point, 600 );
	
	if ( IsDefined( clone._goal_center_point ) &&
		clone FindPath( clone.origin, clone._goal_center_point, true, false ) )
	{
		queryResult = PositionQuery_Source_Navigation(
			clone._goal_center_point,
			0,
			450,
			450,
			100,
			clone );
	
		if( queryResult.data.size > 0 )
		{
			clone setgoalpos( queryResult.data[0].origin, true );
			clone._clone_goal = queryresult.data[0].origin;
			clone._clone_goal_max_dist = 450;
		}
	}
	else
	{
		clone._goal_center_point = clone.origin;
	}
	
	clone thread _UpdateClonePathing();
	clone ghost();
	clone thread _show( spawnTime );
	_ConfigureCloneTeam( clone, player, false );
}

function private _PlayDematerialization()
{
	if( isDefined( self ) )
	{
		PlayFx( "player/fx_plyr_clone_vanish", self.origin );
		PlaySoundAtPosition( "mpl_clone_holo_death", self.origin );
	}
}

function private _CloneWatchDeath()
{
	self waittill( "death" );
	
	if( isDefined( self ) )
	{
		self stoploopsound();
		self _PlayDematerialization();
		removeClone( self );
		self delete();
	}
}

function private _ConfigureCloneTeam( clone, player, isHacked )
{
	if ( isHacked == false )
	{
		clone.originalteam = player.team;
	}
	clone.ignoreall = true;
	clone.owner = player;	
	clone SetTeam( player.team );
	clone.team = player.team;
	clone SetEntityOwner( player );
}

function private _show( spawnTime )
{
	self endon( "death" );
	wait( spawnTime );
	self show();
	self clientfield::set( "clone_activated", 1 );
	PlayFx( "player/fx_plyr_clone_reaper_appear", self.origin, AnglesToForward( self getangles() ));
	self playloopsound( "mpl_clone_holo_loop" );
}

function gadget_clone_off( slot, weapon )
{
	self clientfield::set( "clone_activated", 0 );
	self killClones( self );
	self _PlayDematerialization();
	
	if ( IsAlive( self ) && isdefined( level.playHeroabilitySuccess ) )
    {
		self [[ level.playHeroabilitySuccess ]]( "cloneSuccessDelay" );
	}
}

function private _cloneDamaged()
{
	self endon ( "death" );
	self clientfield::set( "clone_damaged", 1 );
	util::wait_network_frame();
	self clientfield::set( "clone_damaged", 0 );
}

function ProcessCloneScoreEvent( clone, attacker, weapon )
{
	if ( isdefined( attacker ) && isplayer( attacker ) )
	{
		if ( !level.teamBased || (clone.team != attacker.pers["team"]) )
		{
			if( isDefined( clone.isAiClone ) && clone.isAiClone )
			{
				scoreevents::processScoreEvent( "killed_clone_enemy", attacker, clone, weapon );
			}
		}		
	}
}

function cloneDamageOverride( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, modelIndex, surfaceType, surfaceNormal )
{
	self thread _cloneDamaged();
	
	if( weapon.isEmp && sMeansOfDeath == "MOD_GRENADE_SPLASH" )
	{
		ProcessCloneScoreEvent( self, eAttacker, weapon );
		self notify( "clone_shutdown" );
	}
	
	if( isDefined( level.weaponLightningGun ) && weapon == level.weaponLightningGun )
	{
		ProcessCloneScoreEvent( self, eAttacker, weapon );
		self notify( "clone_shutdown" );
	}
	
	supplyDrop = GetWeapon( "supplydrop" );
	if( isDefined( supplyDrop ) && supplyDrop == weapon )
	{
		ProcessCloneScoreEvent( self, eAttacker, weapon );
		self notify( "clone_shutdown" );
	}
	
	return iDamage;
}

function _CloneWatchOwnerDisconnect( player )
{
	clone = self;
	clone notify( "WatchCloneOwnerDisconnect" );
	clone endon( "WatchCloneOwnerDisconnect" );
	clone endon( "clone_shutdown" );
	
	player util::waittill_any( "joined_team", "disconnect", "joined_spectators" );
	if( isDefined( clone ) )
	{
		clone notify( "clone_shutdown" );
	}
}

function _CloneWatchShutdown()
{
	clone = self;
	clone waittill( "clone_shutdown" );
	
	removeClone( clone );
		
	if( isdefined( clone ) )
	{
		if( !level.gameEnded ) // kill and do damage do nothing after game end
		{
			clone Kill();
		}
		else
		{
			clone stoploopsound();
			self _PlayDematerialization();
			clone hide();
		}
	}
}

function _CloneFakeFire()
{
	clone = self;
	clone endon( "clone_shutdown" );
	clone endon( "death" );
	
	while( true )
	{
		waitTime = RandomFloatRange( .5, 3 );
		wait( waitTime );
		shotsFired = RandomIntRange( 1, 4 );
		if( isDefined( clone.fakeFireWeapon ) && ( clone.fakeFireWeapon != level.weaponnone ) )
		{
			players = GetPlayers();
			foreach( player in players )
			{
				if( isDefined( player ) && isAlive( player ) && ( player getteam() != clone.team ) )
				{
					if( DistanceSquared( player.origin, clone.origin ) < ( 750 * 750 ) )
					{
						if( clone cansee( player ) )
						{
							clone FakeFire( clone.owner, clone.origin, clone.fakeFireWeapon, shotsFired );
							break;
						}
					}
				}
			}
		}
		//clone SetFakeFire( true );
		wait( shotsFired / 2 );				// Either fire number of shots or simulate firing that duration.  May need to adjust this to get it even
		clone SetFakeFire( false );
	}
}

function _CloneSelectWeapon( player )
{
	clone = self;
	items = _CloneBuildItemList( player );
	playerWeapon = player GetCurrentWeapon();
	if( IsDefined( playerWeapon.worldModel ) && ( _TestPlayerWeapon( playerWeapon, items["primary"] ) ) )
	{
		weapon = playerWeapon;
	}
	else
	{
		weapon = _ChooseWeapon( player );
	}
	
	if( isDefined( weapon ) )
	{
		clone shared::placeWeaponOn( weapon, "right" );
		clone.fakeFireWeapon = weapon;
	}
}


function _CloneBuildItemList( player )
{
	pixbeginevent( "clone_build_item_list" );

	items = [];
	
	for( i = 0; i < 256; i++ )
	{
		row = tableLookupRowNum( level.statsTableID, 0, i );

		if ( row > -1 )
		{
			slot = tableLookupColumnForRow( level.statsTableID, row, 13 );

			if ( slot == "" )
			{
				continue;
			}

			number = Int( tableLookupColumnForRow( level.statsTableID, row, 0 ) );
			
			if ( player IsItemLocked( number ) )
			{
				continue;
			}

			allocation = Int( tableLookupColumnForRow( level.statsTableID, row, 12 ) );

			if ( allocation < 0 )
			{
				continue;
			}

			name = tableLookupColumnForRow( level.statsTableID, row, 3 );
			
			if ( !isdefined( items[slot] ) )
			{
				items[slot] = [];
			}

			items[ slot ][ items[slot].size ] = name;
		}
	}

	pixendevent();
	return items;
}

function private _ChooseWeapon( player )
{
	classNum = RandomInt( 10 );
	for( i = 0; i < 10; i++ )
	{
		weapon = player GetLoadoutWeapon( ( i + classNum ) % 10, "primary" );
		if( weapon != level.weaponnone )
		{
			break;
		}
	}
	return weapon;
}

function private _TestPlayerWeapon( playerweapon, items )
{
	if ( !isdefined( items ) || !items.size || !isdefined( playerweapon ) )
	{
		return false;
	}
	
	for( i = 0; i < items.size; i++ )
	{
		displayName = items[ i ];

		if ( playerweapon.displayname == displayName )
		{
			return true;
		}
	}
	return false;
}
