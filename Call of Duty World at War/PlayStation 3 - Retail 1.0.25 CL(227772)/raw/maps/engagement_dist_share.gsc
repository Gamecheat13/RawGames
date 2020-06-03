#include common_scripts\utility; 
#include maps\_utility;
#include maps\firingrange_share;

//
// shared utilities for our engagement distance testmaps
//

engagement_dist_share_precache()
{
	level._effect["flesh_hit"] = LoadFX( "impacts/flesh_hit" );
}

engagement_dist_share_init()
{
	// weapon name printing
	level.weaponslots = [[level.weaponslotsthread]]();
	thread weaponsprint();
	
	wait 1;
	
	// toggle the center lines on/off
	thread init_debug_center_screen();
	thread debug_center_screen_toggle();
	
	// teleporters that warp you around the map
	thread teleporters();
	
	// unlimited ammo
	thread maps\_utility::PlayerUnlimitedAmmoThread();
		
	// killhouse spawngroups setup
	killhouse_init_spawngroups();
}

get_playerone()
{
	return get_players()[0];
}


killhouse_init_spawngroups()
{
	kickoff_trigs = GetEntArray( "trig_killhouse_spawngroup", "targetname" );
	
	if( !IsDefined( kickoff_trigs ) || kickoff_trigs.size < 1 )
	{
		return;
	}
	
	for( j = 0; j < kickoff_trigs.size; j++ )
	{
		kickoff_trig = kickoff_trigs[j];
		
		spawngroups = [];
		index = 0;
	
		spawngroups[index] = GetEntArray( kickoff_trig.target, "targetname" );
		
		while( 1 )
		{
			new_spawngroup = [];
			foundOne = false;
			
			for( i = 0; i < spawngroups[index].size; i++ )
			{
				spawner = spawngroups[index][i];
				
				if( IsDefined( spawner.target ) )
				{		
					nextspawners = GetEntArray( spawner.target, "targetname" );
					
					if( IsDefined( nextspawners ) && nextspawners.size > 0 )
					{
						foundOne = true;
						
						new_spawngroup = array_combine( new_spawngroup, nextspawners );
					}
				}
			}
			
			if( !foundOne )
			{
				break;
			}
			
			index++;
			spawngroups[index] = new_spawngroup;
		}
		
		kickoff_trig thread killhouse_trigger_wait( spawngroups );
	}
}

// self = the trigger that kicks off the spawning
killhouse_trigger_wait( spawngroups )
{
	while( 1 )
	{
		self waittill( "trigger" );
		
		level notify( "spawngroup_button_pressed" );
		thread kill_all_axis();
		wait( 0.5 );
		thread killhouse_spawn_enemies( spawngroups );
	}
}

killhouse_spawn_enemies( spawngroups )
{
	level endon( "spawngroup_button_pressed" );
	
	for( i = 0; i < spawngroups.size; i++ )
	{
		array_thread( spawngroups[i], ::spawn_killhouse_guy );
		wait( 1 );
			
		waittill_axis_dead();
		wait( 1 );
	}
}

// self = a spawner
spawn_killhouse_guy()
{
	self.count = 1;
	
	guy = self spawn_ai();
	
	if( spawn_failed( guy ) )
	{
		wait( 2 );
	}
	
	guy.goalradius = 32;
	
	node = GetNode( self.target, "targetname" );
	
	if( IsDefined( node ) )
	{
		guy SetGoalNode( node );
	}
}

waittill_axis_dead()
{
	while( 1 )
	{
		axis = GetAIArray( "axis" );
		
		if( IsDefined( axis ) && axis.size > 0 )
		{
			wait( 0.1 );
		}
		else
		{
			break;
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
