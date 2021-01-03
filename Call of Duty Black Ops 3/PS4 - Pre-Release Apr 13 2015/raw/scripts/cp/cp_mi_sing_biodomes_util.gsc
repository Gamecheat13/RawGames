/*
 * Created by ScriptDevelop.
 * User: jalexander
 * Date: 1/13/2015
 * Time: 9:22 AM
 * 
 * This script is used for any functions that would be shared between multiple Biodomes levels
 */

#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\teamgather_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_ammo_cache;
#using scripts\cp\_objectives;

function objective_message( msg )
{
	/#
	//IPrintLnBold(msg);
	PrintLn("SKIPTO TEST: "+msg);
	#/
}

function init_hendricks( str_objective )
{
	level.ai_hendricks = util::get_hero( "hendricks" );
	
	//used in supertrees to determine if hendricks is on a zipline or not
	level.ai_hendricks flag::init( "hendricks_on_zipline" );

	skipto::teleport_ai( str_objective );
}

//kill off the passed in spawn manager
function kill_previous_spawns( spawn_str )
{
	//make sure this is actually an active spawn manager before diving into it
	if ( !spawn_manager::is_killed( spawn_str ) && spawn_manager::is_enabled( spawn_str ) )
	{
		//find any enemies spawned from the given spawn manager
		a_enemies = spawn_manager::get_ai( spawn_str );
		
		if ( isdefined ( a_enemies ) )
		{
			foreach( ai in a_enemies )
			{
				//TODO add checks for if any active player can see the enemy before killing
				//this could also potentially be a game-wide utility function
				ai util::stop_magic_bullet_shield();
				ai Kill();
			}
		}
		
		// make sure to kill the spawn manager itself if it happens to still be active for any reason
		if ( !spawn_manager::is_killed( spawn_str ) )
		{
			spawn_manager::kill( spawn_str );
		}
	}
}


// Finds all AI with the passed in targetname and deletes them once they are out of sight of the player.
// Can also pass in the distance the AI must be from the player before AI will be deleted. Defaults to 2000.
function delete_when_no_players_in_sight( str_targetname , n_dist )
{
	if ( !isdefined( str_targetname ) )
	{
	   	AssertMsg( "Must define a targetname for AI to delete." );
	}
	
	if ( !isdefined( n_dist) )
	{
		n_dist = 2000;
	}
	
	a_ai_to_delete = GetAIArray( str_targetname , "targetname" );
	
	foreach( ai in a_ai_to_delete )
	{
		ai thread wait_to_delete( n_dist );
	}
}

function wait_to_delete( n_dist )
{
	self endon( "death" );
	b_can_delete = false;
	
	while ( b_can_delete == false )
	{
		foreach ( player in level.players )
		{
			if ( IsVehicle( self ) )
			{
				b_can_see_player = self VehCanSee( player );
			}
			else if ( IsActor( self ) )
			{
				b_can_see_player = self CanSee( player );
			}
			else
			{
				AssertMsg( "wait_to_delete should only be used with vehicles or actors!" );
				return;
			}
			
			if ( ( b_can_see_player == false ) && ( Distance( self.origin, player.origin ) > n_dist ) && ( player util::is_player_looking_at( self.origin , undefined, false ) == false ) )
			{
				b_can_delete = true;
			}
		}
		
		wait 1;
	}
		
	self Delete();
}


//used to turn on and off groups of triggers (prevents the bullet scene from interfering at the beginning of the markets)
function group_triggers_enable( str_group, b_enable )
{
	a_triggers = GetEntArray( str_group, "script_noteworthy" );
	Assert( isdefined( a_triggers ), str_group+" is not a valid script_noteworthy associated with a trigger" );
	
	if ( isdefined( a_triggers ) )
	{
		foreach ( trigger in a_triggers )
		{
			trigger TriggerEnable( b_enable );
		}
	}
}

//TODO temp
function hendricks_follow_player()
{
	level.ai_hendricks endon( "stop_following" ); //notify  for Hendricks to stop following, used in cloud mountain
	
	level flag::wait_till( "all_players_spawned" );
	
	level.ai_hendricks colors::disable();
	
	while( 1 )
	{
		if ( Distance2DSquared( level.ai_hendricks.origin, level.players[0].origin ) > ( 600 * 600 ) )
		{
			level.ai_hendricks SetGoal( level.players[0].origin, true );
		
			level.ai_hendricks util::waittill_any_timeout( 5, "goal" );
		}
		
		wait 0.1;
	}
}

//enables/disables a set of nodes with the passed in KVP info
function enable_traversals( b_enable , str_name , str_key )
{
	a_nd_traversals = GetNodeArray( str_name , str_key );
	
	foreach ( node in a_nd_traversals )
	{
		SetEnableNode( node , b_enable );
	}
}

//return a random line from an array of dialogue lines
function vo_pick_random_line( a_dialogue_lines )
{
	return array::random( a_dialogue_lines );
}

//self is a player
function player_interact_anim_generic( n_duration = 1 )
{
	self endon( "death" );
	
	//functionality here shamelessly stolen from _laststand.gsc
	//Throws up player's left hand for the given duration, while still allowing freedom of movement
	weapon_current = self GetCurrentWeapon();
	weapon_fake_interact = GetWeapon( "syrette" );
	
	self GiveWeapon( weapon_fake_interact );
	self SwitchToWeapon( weapon_fake_interact );
	self SetWeaponAmmoStock( weapon_fake_interact, 1 );

	self DisableWeaponFire();
	self DisableWeaponCycling();
	self DisableUsability();
	self DisableOffhandWeapons();
	
	wait n_duration;
	
	self TakeWeapon( weapon_fake_interact );

	self EnableWeaponFire();
	self EnableWeaponCycling();
	self EnableUsability();
	self EnableOffhandWeapons();
	
	if ( self HasWeapon( weapon_current ) )
	{
		self SwitchToWeapon( weapon_current );
	}
	else
	{
		// try to switch to first primary weapon
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}
}
