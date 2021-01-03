#using scripts\codescripts\struct;

#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\clientfield_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                             	     	                                                                                                                                                                

                                                                  	                             	  	                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using_animtree( "generic" );
	
#namespace counteruav;

function autoexec __init__sytem__() {     system::register("counteruav",&__init__,undefined,undefined);    }

function __init__()
{	
	vehicle::add_main_callback( "counteruav", &counteruav_initialize );
}

function counteruav_initialize()
{
	self UseAnimTree( #animtree );
	
	Target_Set( self, ( 0, 0, 0 ) );

	self.health = self.healthdefault;

	self vehicle::friendly_fire_shield();

	//self EnableAimAssist();
	//self SetNearGoalNotifyDist( 40 );
	
	self SetVehicleAvoidance( true ); // this is ORCA avoidance

	self SetHoverParams( 50.0, 100.0, 100.0 );

	self.vehAirCraftCollisionEnabled = true;

	assert( isdefined( self.scriptbundlesettings ) );

	self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );
	self.goalRadius = 999999;
	self.goalHeight = 999999;
	self SetGoal( self.origin, false, self.goalRadius, self.goalHeight );
	
	self.overrideVehicleDamage = &drone_callback_damage;

	// self thread vehicle_ai::nudge_collision(); // do we need this?

	//disable some cybercom abilities
	if( IsDefined( level.vehicle_initializer_cb ) )
	{
    	[[level.vehicle_initializer_cb]]( self );
	}
}

function drone_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	iDamage = vehicle_ai::shared_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );

	return iDamage;
}


