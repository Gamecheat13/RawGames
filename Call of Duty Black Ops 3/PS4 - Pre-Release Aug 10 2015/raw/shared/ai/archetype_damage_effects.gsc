                                                                                                             	     	                                                                                                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                  	                             	  	                                      
                                                                                                                                                                                                       	     	                                                                                   

#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\callbacks_shared;


function autoexec main()
{
	// clientfield setup
	clientfield::register( "actor", "arch_actor_fire_fx", 1, 2, "int" );
	clientfield::register( "actor", "arch_actor_char", 1, 2, "int" );
	
	callback::on_actor_damage(&OnActorDamageCallback);
	callback::on_vehicle_damage(&OnVehicleDamageCallback);
	
	callback::on_actor_killed(&OnActorKilledCallback);
	callback::on_vehicle_killed(&OnVehicleKilledCallback);
}


//------------------------------------Callbacks

function OnActorDamageCallback( params )
{
	OnActorDamage( params );
}

function OnVehicleDamageCallback( params )
{
	OnVehicleDamage( params );
}


function OnActorKilledCallback( params )
{
	OnActorKilled();
	
	//follow the example if you need to add more archetypes
	switch(self.archetype)
	{
		case "human":
			OnHumanKilled();
			break;
		case "robot":
			OnRobotKilled();
			break;	
	}
}

function OnVehicleKilledCallback( params )
{
	OnVehicleKilled( params );
}


//------------------------------------Actor Damage FX

function OnActorDamage( params )
{}


//------------------------------------Vehicle Damage FX

function OnVehicleDamage( params )
{
	OnVehicleKilled( params );
}



//------------------------------------Actor Killed FX

function OnActorKilled()
{
	if (isDefined(self.damageMod))
	{
		if(self.damageMod == "MOD_BURNED")
		{
			//special weapons will handle the initiation of the burn fx
			if(isDefined(self.damageWeapon) && isDefined(self.damageWeapon.specialpain) && self.damageWeapon.specialpain == false)
			{
				self clientfield::set("arch_actor_fire_fx", 2 );
			}
		}
	}
}



function OnHumanKilled()
{
	
}

function OnRobotKilled()
{
	
}

//------------------------------------Vehicle Killed FX

function OnVehicleKilled( params )
{
}