#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace weaponobjects;

function autoexec __init__sytem__() {     system::register("weaponobjects",&__init__,undefined,undefined);    }

function __init__()
{
	weaponobjects::init_shared();
	
	level setupScriptMoverCompassIcons();
	level setupMissileCompassIcons();
}

function setupScriptMoverCompassIcons()
{
	if(!isdefined(level.scriptMoverCompassIcons))level.scriptMoverCompassIcons=[];	
	
	level.scriptMoverCompassIcons["wpn_t7_turret_emp_core"] = "compass_empcore_white";
	level.scriptMoverCompassIcons["t6_wpn_turret_ads_world"] = "compass_guardian_white";
	level.scriptMoverCompassIcons["veh_t7_drone_uav_enemy_vista"] = "compass_uav";
	level.scriptMoverCompassIcons["veh_t7_mil_vtol_fighter_mp"] = "compass_lightningstrike";
	level.scriptMoverCompassIcons["veh_t7_drone_rolling_thunder"] = "compass_lodestar";
}

function setupMissileCompassIcons()
{
	if(!isdefined(level.missileCompassIcons))level.missileCompassIcons=[];	
	
	if ( isdefined( getweapon("drone_strike") ) )
	{
		level.missileCompassIcons[getweapon("drone_strike")] = "compass_lodestar";
	}
}