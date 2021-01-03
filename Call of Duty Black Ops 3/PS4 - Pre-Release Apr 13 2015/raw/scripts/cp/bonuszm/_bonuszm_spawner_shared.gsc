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

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

// List of available spawners 



#namespace bonuszm_spawner;	

function autoexec init()
{
	if( !GetDvarint("ai_spawn_only_zombies") == 1 )
		return;
	
	level.overrideGlobalSpawnFunc = &bonuzm_spawn;
	
	/#
	_debug_spawners();
	#/
		
	setup_zombie_spawners();
}

function setup_zombie_spawners()
{
	level.bonuszm_zombie_spawners = [];
	
	array::add( level.bonuszm_zombie_spawners, "spawner_bo3_zombie" );
	array::add( level.bonuszm_zombie_spawners, "spawner_bo3_zombie_bonuszm" );
}

function _debug_spawners()
{
	SetDvar("bonuzm_spawner", "" );
	
	AddDebugCommand( "devgui_cmd \"|" + "bonuszm" + "|/Spawners:1/Zombie BO3 Spawner:1\" \"set bonuzm_spawner " + "spawner_bo3_zombie" + "\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + "bonuszm" + "|/Spawners:1/Zombie NRC Spawner:1\" \"set bonuzm_spawner " + "spawner_bo3_zombie_bonuszm" + "\"\n" );		
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
	       || ( level.global_spawn_count >= 8 ) )
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
			if( self.team == "axis" )
			{
				assert( IsDefined(level.bonuszm_zombie_spawners) );
				
				spawnerAIType = array::random(level.bonuszm_zombie_spawners);
					
				/#
				if( GetDvarString("bonuzm_spawner") != "" )
					spawnerAIType = GetDvarString("bonuzm_spawner");
				#/
				
				e_spawned = SpawnActor( spawnerAIType, self.origin, self.angles, str_targetname, force_spawn, true );			
			}
			else 
			{
				self SpawnFromSpawner( str_targetname, force_spawn, makeroom, infinitespawn );
			}
		}
		else
		{
			e_spawned = self SpawnFromSpawner( str_targetname, force_spawn, makeroom, infinitespawn );
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