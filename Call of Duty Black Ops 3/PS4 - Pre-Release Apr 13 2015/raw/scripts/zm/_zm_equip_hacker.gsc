#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_hacker_utility;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;

/*
 * Hacker tool script struct values of interest
 *
 * script_noteworthy:  hackable_*
 *
 * script_int: 		cost
 * script_float: 	time in seconds
 * targetname:		If set, will be filled in with the 'owner' struct or ent of the hackable struct, so that we can get access to any 'useful' 
 *								data in there.
 *								Also, the hacker tool will send a "hacked" notify to that ent or struct on successful hack.
 * radius:  			If set, used for the hacker tool activation radius
 * height:				If set, used for the hacker tool activation radius
 * 
 */


// Utility functions

// register_hackable("targetname",&function_to_call_on_hack);
// deregister_hackable(struct);
// deregister_hackable("script_noteworthy"); 

#precache( "string", "ZOMBIE_EQUIP_HACKER_PICKUP_HINT_STRING" );

#namespace zm_equip_hacker;

function autoexec __init__sytem__() {     system::register("zm_equip_hacker",&__init__,undefined,undefined);    }

//TODO NOTE - any functions called from outside of this should be placed in zm_hacker_utility(), not here
function __init__()
{
	level.weaponZMEquipHacker = GetWeapon( "equip_hacker" );
	name = level.weaponZMEquipHacker.name;

	zm_equipment::register( name, &"ZOMBIE_EQUIP_HACKER_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_HACKER_HOWTO", undefined, "hacker" );

	level._hackable_objects = [];
	level._pooled_hackable_objects = [];

	callback::on_connect(&hacker_on_player_connect);
	
	level thread hack_trigger_think();
		
	level thread hacker_trigger_pool_think();
	
	level thread hacker_round_reward();
	
	if(GetDvarInt("scr_debug_hacker") == 1)
	{
		level thread hacker_debug();
	}
}

function hacker_round_reward()
{
	while(1)
	{
		level waittill("end_of_round" );
		
		if(!isdefined(level._from_nml))
		{
			players = GetPlayers();
			
			for(i = 0; i < players.size; i ++)
			{
				if(players[i] zm_equipment::get_player_equipment() == level.weaponZMEquipHacker)
				{
					if(isdefined(players[i].equipment_got_in_round[level.weaponZMEquipHacker]))
					{
						got_in_round = players[i].equipment_got_in_round[level.weaponZMEquipHacker];
						
						rounds_kept = level.round_number - got_in_round;
						
						rounds_kept -= 1;
						
						if(rounds_kept > 0)
						{
							rounds_kept = min(rounds_kept, 5);
							
							score = rounds_kept * 500;
							
							players[i] zm_score::add_to_player_score( Int(score) );
						}
					}
				}
			}
		}
		else
		{
			level._from_nml = undefined;
		}
	}
}

function hacker_debug()
{
/#
	while(1)
	{
		for(i = 0; i < level._hackable_objects.size; i ++)
		{
			hackable = level._hackable_objects[i];
			
			if(isdefined(hackable.pooled) && hackable.pooled)
			{
				if(isdefined(hackable._trigger))
				{
					col = (0,255,0);
					
					if(isdefined(hackable.custom_debug_color))
					{
						col = hackable.custom_debug_color;
					}
					
					Print3d(hackable.origin, "+", col, 1, 1);
				}
				else
				{
					Print3d(hackable.origin, "+", (0,0,255), 1, 1);
				}
			}
			else
			{
				Print3d(hackable.origin, "+", (255,0,0), 1, 1);
			}
		}
		wait(0.1);
	}
	#/
}

function hacker_trigger_pool_think()
{	
	if(!isdefined(level._zombie_hacker_trigger_pool_size))
	{
		level._zombie_hacker_trigger_pool_size = 8;
	}
	
	pool_active = false;
	
	level._hacker_pool = [];
	
	while(1)
	{
		if(pool_active)
		{
			if(!hacker_util::any_hackers_active())
			{
				destroy_pooled_items();
			}
			else
			{
				sweep_pooled_items();

				add_eligable_pooled_items();
	
			}
		}
		else
		{
			if(hacker_util::any_hackers_active())
			{
				pool_active = true;
			}
		}
		
		wait(0.1);
	}	
}

function destroy_pooled_items()
{
	pool_active = false;
	
	for(i = 0; i < level._hacker_pool.size; i ++)
	{
		level._hacker_pool[i]._trigger Delete();
		level._hacker_pool[i]._trigger = undefined;
	}
	
	level._hacker_pool = [];
}

function sweep_pooled_items()
{
	// clear out any pooled triggers that are no longer eligable.
	
	new_hacker_pool = [];
	
	for(i = 0; i < level._hacker_pool.size; i ++)
	{
		if(level._hacker_pool[i] should_pooled_object_exist())
		{
			new_hacker_pool[new_hacker_pool.size] = level._hacker_pool[i];
		}
		else
		{
			level._hacker_pool[i]._trigger Delete();
			level._hacker_pool[i]._trigger = undefined;
		}
	}
	
	level._hacker_pool = new_hacker_pool;
}

function should_pooled_object_exist()
{
	players = GetPlayers();
	
	for(i = 0; i < players.size; i ++)
	{
		if(players[i] zm_equipment::hacker_active())
		{
			if(isdefined(self.entity))
			{
				if(self.entity != players[i])
				{
					if(distance2dsquared(players[i].origin, self.entity.origin) <= (self.radius * self.radius))
					{
						return true;
					}
				}
			}
			else
			{
				if(distance2dsquared(players[i].origin, self.origin) <= (self.radius * self.radius))
				{
					return true;
				}
			}
		}
	}
	
	return false;
}

function add_eligable_pooled_items()
{

	candidates = [];

	for(i = 0; i < level._hackable_objects.size; i ++)
	{
		hackable = level._hackable_objects[i];
		
		if(isdefined(hackable.pooled) && hackable.pooled && !isdefined(hackable._trigger))
		{
			if(!IsInArray(level._hacker_pool, hackable))
			{
				if(hackable should_pooled_object_exist())
				{
					candidates[candidates.size] = hackable;
				}
			}
		}
	}
	
	for(i = 0; i < candidates.size; i ++)
	{
		candidate = candidates[i];

		height = 72;
		radius = 32;
		
		if(isdefined(candidate.radius))
		{
			radius = candidate.radius;
		}
		
		if(isdefined(self.height))
		{
			height = candidate.height;
		}

		trigger = spawn( "trigger_radius_use", candidate.origin, 0, radius, height);
		trigger UseTriggerRequireLookAt();
		trigger SetCursorHint( "HINT_NOICON" );
		trigger.radius = radius;
		trigger.height = height;
		trigger.beingHacked = false;

		candidate._trigger = trigger;
		
		level._hacker_pool[level._hacker_pool.size] = candidate;
	}

}

function hack_trigger_think()
{
	while(1)
	{
		players = GetPlayers();
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			for(j = 0; j < level._hackable_objects.size; j ++)
			{
				hackable = level._hackable_objects[j];
				
				if(isdefined(hackable._trigger))
				{
					qualifier_passed = true;
					
					if(isdefined(hackable._hack_qualifier_func))
					{
						qualifier_passed = hackable [[hackable._hack_qualifier_func]](player);
					}
					
					if ( player zm_equipment::hacker_active() && qualifier_passed &&  !hackable._trigger.beingHacked)
					{
						hackable._trigger SetInvisibleToPlayer( player, false );
					}
					else
					{
						hackable._trigger SetInvisibleToPlayer( player, true );
					}
				}
			}
		}
		wait( 0.1 );
	}
}

function hacker_on_player_connect()
{
	struct = SpawnStruct();
	struct.origin = self.origin;
	struct.radius = 48;
	struct.height = 64;
	struct.script_float = 10;
	struct.script_int = 500;
	struct.entity = self;
	struct.trigger_offset = (0,0,48);
	
	hacker_util::register_pooled_hackable_struct(struct,&player_hack,&player_qualifier);
	
	struct thread player_hack_disconnect_watcher(self);
}

function player_hack_disconnect_watcher(player)
{
	player waittill("disconnect");
	hacker_util::deregister_hackable_struct(self);
}

function player_hack(hacker)
{
	if(isdefined(self.entity))
	{
		self.entity zm_score::player_add_points( "hacker_transfer", 500 );
	}
	
	if( isdefined( hacker ) )
	{
		hacker thread zm_audio::create_and_play_dialog( "general", "hack_plr" );
	}
}

function player_qualifier(player)
{
	if(player == self.entity)
	{
		return false;		// No hack self.
	}
	
	if(self.entity laststand::player_is_in_laststand())
	{
		return false;
	}
	
	if(player laststand::player_is_in_laststand())
	{
		return false;
	}
	
	if(( isdefined( self.entity.sessionstate == "spectator" ) && self.entity.sessionstate == "spectator" ))
	{
		return false;
	}
	
	return true;
}

function hacker_debug_print( msg, color )
{
/#
	if ( !GetDvarInt( "scr_hacker_debug" ) )
	{
		return;
	}

	if ( !isdefined( color ) )
	{
		color = (1, 1, 1);
	}

	Print3d(self.origin + (0,0,60), msg, color, 1, 1, 40); // 10 server frames is 1 second
#/
}
