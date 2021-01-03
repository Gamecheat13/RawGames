#using scripts\codescripts\struct;

#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace dogs;

function autoexec __init__sytem__() {     system::register("dogs",&__init__,undefined,undefined);    }	

function __init__()
{
/#
	thread dog_dvar_updater();
#/
	level.movementStateSound = [];

	level.maxStateSoundDistance = 99999999;
	
	level.movementStateSound["normal"] = spawnStruct();	
	level.movementStateSound["normal"].sound = "aml_dog_bark";
	level.movementStateSound["normal"].waitMax = 4;
	level.movementStateSound["normal"].waitMin = 1;
	level.movementStateSound["normal"].enemyrange = level.maxStateSoundDistance;  // this has no range
	level.movementStateSound["normal"].localenemyonly = false;
	
	// this is for everyone other then the enemy
	level.movementStateSound["attack_mid_everyone"] = spawnStruct();	
	level.movementStateSound["attack_mid_everyone"].sound = "aml_dog_bark_mid";
	level.movementStateSound["attack_mid_everyone"].waitMax = 2;
	level.movementStateSound["attack_mid_everyone"].waitMin = 0.5;
	level.movementStateSound["attack_mid_everyone"].enemyrange = 1500;
	level.movementStateSound["attack_mid_everyone"].localenemyonly = false;
	
	// this is only for the enemy to hear
	level.movementStateSound["attack_mid_enemy"] = spawnStruct();	
	level.movementStateSound["attack_mid_enemy"].sound = "aml_dog_bark_mid";
	level.movementStateSound["attack_mid_enemy"].waitMax = 0.5;
	level.movementStateSound["attack_mid_enemy"].waitMin = 0.01;
	level.movementStateSound["attack_mid_enemy"].enemyrange = 1500;
	level.movementStateSound["attack_mid_enemy"].localenemyonly = true;
	
	// this is only for the enemy to hear
	level.movementStateSound["attack_close_enemy"] = spawnStruct();	
	level.movementStateSound["attack_close_enemy"].sound = "aml_dog_bark_close";
	level.movementStateSound["attack_close_enemy"].waitMax = 0.1;
	level.movementStateSound["attack_close_enemy"].waitMin = 0.01;
	level.movementStateSound["attack_close_enemy"].enemyrange = 1000;
	level.movementStateSound["attack_close_enemy"].localenemyonly = true;
	
}

/#
function dog_dvar_updater()
{
	while(1)
	{
		level.dog_debug_sound = dog_get_dvar_int("debug_dog_sound", "0" );
		level.dog_debug = dog_get_dvar_int("debug_dogs", "0" );
		wait (1);
	}
}
#/

function spawned( localClientNum )
{
	self endon( "entityshutdown" );

	self thread animCategoryWatcher( localClientNum );
	self thread enemyWatcher( localClientNum );

/#
	self thread shutdownWatcher( localClientNum );
#/
}

/#
function shutdownWatcher( localClientNum )
{
	if ( !isdefined (level.dog_debug) )
		return;
	if ( !level.dog_debug )
		return;
		
	number = self getentnum();
	
	println( "_+_+_+_+_+_+_+_+_+_+_  NEWLY SPAWNED DOG"  + number);
	self waittill("entityshutdown");
	println( "_+_+_+_+_+_+_+_+_+_+_  DOG SHUTDOWN"  + number);
}
#/

function animCategoryChanged( localClientNum, animCategory )
{
	self.animCategory = animCategory;
	self notify("killanimscripts");

	dog_print( "anim category changed " + animCategory);

	switch (animCategory )
	{
	case "move":
		self thread playMovementSounds( localClientNum );
		break;
	case "pain":
		self thread playPainSounds( localClientNum );
		break;
	case "death":
		self thread playDeathSounds( localClientNum );
		break;
	};
	
	
}

function animCategoryWatcher( localClientNum )
{
	self endon("entityshutdown");

	if ( !isdefined(self.animCategory) )
	{
		animCategoryChanged( localClientNum, self GetAnimStateCategory() );
	}
	
	while(1)
	{
		animCategory = self GetAnimStateCategory();
		
		if ( isdefined( animCategory) && self.animCategory != animCategory && animCategory != "traverse" )
		{
			animCategoryChanged( localClientNum, animCategory );
		}
		wait(0.05);
	}
}

function enemyWatcher(localClientNum)
{
	self endon("entityshutdown");
	
	while(1)
	{
		self waittill("enemy");
/#		
		if (isdefined(self.enemy)) 
		{
			dog_print( "NEW ENEMY "  + self.enemy getentnum());
			
			if ( isLocalPlayerEnemy( self.enemy ) )
			{
				self thread playLockOnSounds( localClientNum );
			}
		}
		else
		{
			dog_print( "NEW ENEMY CLEARED");
		}
#/
	}
}

function getOtherTeam( team )
{
	if ( team == "allies" )
		return "axis";
	else if ( team == "axis" )
		return "allies";
	else if ( team == "free" )
		return "free";
		
	assertMsg( "getOtherTeam: invalid team " + team );
}

function isLocalPlayerEnemy( enemy )
{
	if ( !isdefined(enemy) )
	{
		return false;
	}
		
	players = level.localPlayers;
	
	if ( isdefined( players ) )
	{
		for ( i = 0; i < players.size; i++ )
		{
			if ( players[i] == enemy )
				return true;
		}
	}
	return false;
}

function hasEnemyChanged( last_enemy )
{
	if ( !isdefined(last_enemy) && isdefined(self.enemy) )
		return true;
		
	if ( isdefined(last_enemy) && !isdefined(self.enemy) )
		return true;

	if ( last_enemy != self.enemy )
		return true;
		
	return false;
}

function getMovementSoundState()
{
		localPlayer = isLocalPlayerEnemy( self.enemy );
		closest_dist = level.maxStateSoundDistance * level.maxStateSoundDistance;
		closest_key = "normal";
		has_enemy = isdefined(self.enemy);
		if ( has_enemy )
		{
			enemy_distance = distancesquared( self.origin, self.enemy.origin );
		}
		else
		{
			return "normal";
		}
		
		stateArray = getArrayKeys( level.movementStateSound );
		for ( i = 0; i < stateArray.size; i++ )
		{
//			dog_sound_print("checking " +  stateArray[i]);
			if ( level.movementStateSound[stateArray[i]].localenemyonly && !localPlayer )
				continue;
				
			state_dist = level.movementStateSound[stateArray[i]].enemyrange;
			state_dist *= state_dist;
			
			if ( state_dist < enemy_distance )
				continue;
				
			if ( state_dist < closest_dist )
			{
				closest_dist = state_dist;
				closest_key = stateArray[i];
			}
		}
		
//		dog_sound_print("returning " +  closest_key);
		return closest_key;
}

function playMovementSounds( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "killanimscripts" );

	last_state = "normal";
	last_time = 0;
	wait_time = 0;
	// getting t5 running
	

	while (1)
	{
		state = getMovementSoundState();
//		dog_sound_print( "Sound State: " + state);
	
		next_sound = false;
		if ( state != last_state  && level.movementStateSound[state].waitMax < wait_time )
		{
			dog_sound_print( "New State forcing next sound");
			next_sound = true;
		}
	
		if ( next_sound || ((last_time + wait_time) < GetRealTime()) )
		{
			if (isdefined(self.enemy) )
			{
				dog_sound_print( "enemy distance: " + distance( self.origin, self.enemy.origin ));
			}
	
			soundId = self play_dog_sound( localClientNum, level.movementStateSound[state].sound );
			last_state = state;
			
			if ( soundId >= 0 )
			{
				while( soundplaying( soundId ) )
				{
					wait( 0.05 );
				}
	
				last_time = GetRealTime();
				wait_time = 1000 * randomfloatrange( level.movementStateSound[state].waitMin, level.movementStateSound[state].waitMax );
				dog_sound_print( "wait_time: " + wait_time);
			}
			else
			{
				// could not play for some reason so dont bother trying again real quick
				wait(0.5);
			}
		}
		
		wait( 0.05 );
	}
	
}

function playPainSounds( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "killanimscripts" );

	soundId = self play_dog_sound( localClientNum, "aml_dog_pain" );
}

function playDeathSounds( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "killanimscripts" );

	soundId = self play_dog_sound( localClientNum, "aml_dog_death" );
}

function playLockOnSounds( localClientNum )
{
	self endon( "entityshutdown" );
	
	soundId = self play_dog_sound( localClientNum, "aml_dog_lock" );
}

function soundNotify(client_num, entity,  note )
{
	if ( note == "sound_dogstep_run_default" )
	{	
		entity playsound( client_num, "fly_dog_step_run_default" );
		return true;
	}
	
	alias = "aml" + getsubstr( note, 5 );
	entity play_dog_sound( client_num, alias);
}

function dog_get_dvar_int( dvar, def )
{
	return int( dog_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
function dog_get_dvar( dvar, def )
{
	if ( GetDvarString( dvar ) != "" )
		return getdvarfloat( dvar );
	else
	{
//		SetDvar( dvar, def );
		return def;
	}
}

function dog_sound_print( message )
{
/# 
	if ( !isdefined (level.dog_debug_sound) )
		return;
		
	if (!level.dog_debug_sound)
		return;
		
	println("CLIENT DOG SOUND("+self getentnum()+"," + GetRealTime() +"): " + message );
#/
}

function dog_print( message )
{
/# 
	if ( !isdefined (level.dog_debug) )
		return;
	if (!level.dog_debug)
		return;
	
		
	println("CLIENT DOG DEBUG("+self getentnum()+"): " + message );
#/
}

function play_dog_sound( localClientNum, sound, position )
{
//	dog_sound_print( "SOUND " + sound);
	
//	if ( isdefined( position ) )
//	{
//		return self playsound( localClientNum, sound, position );
//	}
	
//	return self playsound( localClientNum, sound );
}