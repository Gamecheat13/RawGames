
#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_util;
#using scripts\zm\_zm_buildables;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;

#namespace zm_altbody;



function autoexec __init__sytem__() {     system::register("zm_altbody",&__init__,undefined,undefined);    }
	
function __init__()
{
	clientfield::register( "toplayer", "player_lives", 1, 2, "int", &set_player_lives, !true, true );
	clientfield::register( "toplayer", "player_afterlife_mana", 1, 5, "float", &set_player_mana, !true, true );
	clientfield::register( "toplayer", "player_in_afterlife",	1, 1, "int", &toggle_player_altbody, !true, true );
	
	SetupClientFieldCodeCallbacks( "toplayer", 1, "player_lives" );
	SetupClientFieldCodeCallbacks( "toplayer", 1, "player_in_afterlife" );
	SetupClientFieldCodeCallbacks( "toplayer", 1, "player_afterlife_mana" );
}
	
function init( name, trigger_name, trigger_hint, visionset_name, visionset_priority, enter_callback, exit_callback )
{
	if(!isdefined(level.altbody_enter_callbacks))level.altbody_enter_callbacks=[];
	if(!isdefined(level.altbody_exit_callbacks))level.altbody_exit_callbacks=[];
	if(!isdefined(level.altbody_visionsets))level.altbody_visionsets=[];
	level.altbody_name = name;
	if ( IsDefined(visionset_name) )
	{
		level.altbody_visionsets[name] = visionset_name;
		visionset_mgr::register_visionset_info( visionset_name, 1, 1, visionset_name, visionset_name );
	}
	level.altbody_enter_callbacks[name]=enter_callback;
	level.altbody_exit_callbacks[name]=exit_callback;
}

//*********** USED FOR AFTERLIFE LUI HUD **********************
function set_player_mana( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self.mana = newVal;	
}

function set_player_lives( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self.lives = newVal;	
}

function toggle_player_altbody( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self.altbody = newVal;
	self UseAlternateHud(newVal);
	if( newVal == 1 )
	{
		callback = level.altbody_enter_callbacks[level.altbody_name]; 
		if ( IsDefined(callback) )
		{
			self [[callback]](localClientNum);
		}
	}
	else
	{
		callback = level.altbody_exit_callbacks[level.altbody_name]; 
		if ( IsDefined(callback) )
		{
			self [[callback]](localClientNum);
		}
	}
}

