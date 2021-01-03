#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\serverfaceanim_shared;
#using scripts\shared\system_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;

                                                                                                             	     	                                                                                                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	



#namespace BonusZMSpawner;

function BZM_SpawnerInit()
{
	level.bonuszm_zombie_spawners = [];
	
	// Female
	level.bonuszm_zombie_spawners["female"] = [];
	level.bonuszm_zombie_spawners_female_chance = 0;
	
	if( IsDefined( level.bonusZMSkiptoData["aitypeFemale"] ) )
	{
		array::add( level.bonuszm_zombie_spawners["female"], "actor_" + level.bonusZMSkiptoData["aitypeFemale"] );
		
		if( IsDefined( level.bonusZMSkiptoData["femaleSpawnChance"] ) )
		{
			level.bonuszm_zombie_spawners_female_chance = Int( level.bonusZMSkiptoData["femaleSpawnChance"] );
		}
	}
	
	// Male
	level.bonuszm_zombie_spawners["male"] = [];
	
	if( IsDefined( level.bonusZMSkiptoData["aitypeMale1"] ) )
	{
		array::add( level.bonuszm_zombie_spawners["male"], "actor_" + level.bonusZMSkiptoData["aitypeMale1"] );
	}
	
	if( IsDefined( level.bonusZMSkiptoData["aitypeMale2"] ) )
	{
		if( IsDefined( level.bonusZMSkiptoData["maleSpawnChance2"] ) && RandomInt(100) < level.bonusZMSkiptoData["maleSpawnChance2"] )
		{
			array::add( level.bonuszm_zombie_spawners["male"], "actor_" + level.bonusZMSkiptoData["aitypeMale2"] );
		}
	}
	
	if( IsDefined( level.bonusZMSkiptoData["aitypeMale3"] ) )
	{
		if( IsDefined( level.bonusZMSkiptoData["maleSpawnChance3"] ) && RandomInt(100) < level.bonusZMSkiptoData["maleSpawnChance3"] )
		{
			array::add( level.bonuszm_zombie_spawners["male"], "actor_" + level.bonusZMSkiptoData["aitypeMale3"] );
		}
	}
	
	if( IsDefined( level.bonusZMSkiptoData["aitypeMale4"] ) )
	{
		if( IsDefined( level.bonusZMSkiptoData["maleSpawnChance4"] ) && RandomInt(100) < level.bonusZMSkiptoData["maleSpawnChance4"] )
		{
			array::add( level.bonuszm_zombie_spawners["male"], "actor_" + level.bonusZMSkiptoData["aitypeMale4"] );
		}
	}	
}

function BZM_SpawnerChooseRandomAIType()
{
	if( !IsDefined(level.bonuszm_zombie_spawners) )
	{
		return undefined;
	}
	
	if( !level.bonuszm_zombie_spawners.size )
	{
		return undefined;
	}

	spawnerAIType = undefined;
	spawnFemaleZombie = ( RandomInt(100) < level.bonuszm_zombie_spawners_female_chance );
	
	if( spawnFemaleZombie && level.bonuszm_zombie_spawners["female"].size )
	{
		spawnerAIType = array::random( level.bonuszm_zombie_spawners["female"] );
	}
	else
	{
		spawnerAIType = array::random( level.bonuszm_zombie_spawners["male"] );
	}
	
	assert( IsDefined( spawnerAIType ) );
	
	return spawnerAIType;
}

function BZM_SpawnerSetupSkipto()
{
	if( level.bonusZMSkiptoData["zombifyenabled"] )
	{
		level.overrideGlobalSpawnFunc = &bonuzm_spawn;
	}
	else
	{
		level.overrideGlobalSpawnFunc = undefined;
	}	
}

function private BZM_ShouldReplaceActor( spawner )
{
	// HAKIM - For lotus towers
	// DIREWOLVES - For infection
	if( ( spawner.archetype == "direwolf" )
	   	|| ( spawner.archetype == "civilian" )
	   	|| IsSubStr( spawner.classname, "hero" )
	   	|| IsSubStr( spawner.classname, "boss" )
	   	|| ( IsDefined( spawner.targetname ) && IsSubStr( spawner.targetname, "hakim" ) )
	   	|| ( IsDefined( spawner.targetname ) && IsSubStr( spawner.targetname, "chase_bomber" ) )
   	)
	{
		return false;
	}
	
	if( IsDefined( spawner.script_vehicleride ) )
	{
		return false;
	}
	
	return true;
}

function private BZM_ShouldReplaceVehicle( spawner )
{
	// For new world
	if( IsDefined( spawner.targetname ) && spawner.targetname == "foundry_hackable_vehicle" )
		return false;	
	
	return true;
}

function bonuzm_spawn( b_force = false, str_targetname, v_origin, v_angles )
{
	e_spawned = undefined;
	force_spawn = false;
	makeroom = false;
	infinitespawn = false;
	deleteonzerocount = false;
	
	/#
	if ( GetDvarString( "noai" ) != "off" )
	{
		return;
	}
	#/
		
	if ( ( isdefined( self.script_minplayers ) && ( self.script_minplayers > level.players.size ) )
		    || ( isdefined( self.script_numplayers ) && ( self.script_numplayers > level.players.size ) )
		    || ( isdefined( self.script_maxplayers ) && ( self.script_maxplayers < level.players.size ) ) )
	{
		self Delete();
		return;
	}
		
	// SUMEET - This check is to avoid script errors due to spawning two AI's from the same spawner on the
	// same frame.
	while ( ( isdefined( self.lastSpawnTime ) && self.lastSpawnTime >= GetTime() )
	       || ( level.global_spawn_count >= 3 ) )
	{
		{wait(.05);};
	}
		
	if ( IsActorSpawner( self ) )
	{
		if ( (isdefined(self.spawnflags)&&((self.spawnflags & 2) == 2)) )
		{
			makeroom = true;
		}
	}
	else if ( IsVehicleSpawner( self ) )
	{
		if ( (isdefined(self.spawnflags)&&((self.spawnflags & 8) == 8)) )
		{
			makeroom = true;
		}
	}
	
	// ForceSpawn and InfiniteSpawn flags match between actors and vehicles
	if ( b_force || (isdefined(self.spawnflags)&&((self.spawnflags & 16) == 16)) || isdefined( self.script_forcespawn ) )
	{
		force_spawn = true;
	}
		
	if ( (isdefined(self.spawnflags)&&((self.spawnflags & 64) == 64)) )
	{
		infinitespawn = true;
	}

	if ( !IsDefined( e_spawned ) )
	{
		if( IsActorSpawner( self ) )
		{
			assert( IsDefined( self.archetype ) );
			
			shouldReplaceActor 	= BZM_ShouldReplaceActor( self );
						
			if( self.team == "axis" && shouldReplaceActor )
			{	
				bzmPreviousArchetype = self.archetype;
				
				if( self.archetype == "warlord" )
				{
					e_spawned = self SpawnFromSpawner( str_targetname, true, makeroom, infinitespawn, "actor_spawner_bo3_zombie_warlord_bonuszm" );
					e_spawned.BZMDoNotOverrideHealth = true;
					e_spawned.BZMMiniBoss = true;
				}
				else 
				{				
					zombify = true;					
					spawnerAIType = BZM_SpawnerChooseRandomAIType();
					
					if( IsDefined( spawnerAIType ) )
					{
						e_spawned = self SpawnFromSpawner( str_targetname, true, makeroom, infinitespawn, spawnerAIType, zombify );
					}
					else
					{
						e_spawned = self SpawnFromSpawner( str_targetname, true, makeroom, infinitespawn );
					}
					
					if( IsDefined( e_spawned ) && IsDefined( bzmPreviousArchetype ) )
					{
						e_spawned.bzmPreviousArchetype = bzmPreviousArchetype;
					}
				}
			}
			else 
			{
				e_spawned = self SpawnFromSpawner( str_targetname, force_spawn, makeroom, infinitespawn );
			}
		}
		else
		{
			shouldReplaceVehicle = BZM_ShouldReplaceVehicle( self );
			spawnerAIType = undefined;
			
			if( shouldReplaceVehicle && IsDefined( self.archetype ) )
			{
				if( self.archetype == "wasp" )
				{
					spawnerAIType = "spawner_bo3_parasite_enemy_tool";					
				}
				else if( self.archetype == "raps" )
				{
					spawnerAIType = "spawner_enemy_zombie_vehicle_raps_suicide";					
				}
			}
			
			if( IsDefined( spawnerAIType ) )
			{
				e_spawned = self SpawnFromSpawner( str_targetname, force_spawn, makeroom, infinitespawn, spawnerAIType );
			}
			else
			{
				e_spawned = self SpawnFromSpawner( str_targetname, force_spawn, makeroom, infinitespawn );
			}
		}
	}
	
	// Store the last spawned time on the spawner
	if ( IsDefined( e_spawned ) )
	{
		level.global_spawn_count++;
		
		if( isdefined( level.run_custom_function_on_ai ) )
		{
			e_spawned thread [[level.run_custom_function_on_ai]]( self, str_targetname, force_spawn );
		}

		if ( isdefined( v_origin ) || isdefined( v_angles ) )
		{
			e_spawned spawner::teleport_spawned( v_origin, v_angles );
		}
		
		self.lastSpawnTime = GetTime();
	}
	
	if ( ( deleteonzerocount || ( isdefined( self.script_delete_on_zero ) && self.script_delete_on_zero ) ) && isdefined( self.count ) && ( self.count <= 0 ) )
	{
		self Delete();
	}
	
	if ( IsSentient( e_spawned ) )
	{
		if ( !spawner::spawn_failed( e_spawned ) )
		{
			return e_spawned;
		}
	}
	else
	{
		return e_spawned;
	}
}