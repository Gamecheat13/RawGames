                                                                                                            	   	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	            	    	   	                           	                               	                                	                                                              	                                                                          	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	              	                  	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                          	                                   	                                   	                                                    	                                    
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                              	   	                             	  	                                      
                                                                                                                                                                                                                                                                                                                                                                   

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
	clientfield::register( "actor", "arch_human_fire_fx", 1, 2, "int" );
	
	//Enable if needed to add effects when the actor gets damage
	//callback::on_actor_damage(&OnActorDamage);
	
	callback::on_actor_killed(&OnActorKilled);
}


function OnActorDamage()
{
}

function OnActorKilled()
{
	if (isDefined(self.damageMod))
	{
		if(self.damageMod == "MOD_BURNED")
		{
			//special weapons will handle the initiation of the burn fx
			if(isDefined(self.damageWeapon) && isDefined(self.damageWeapon.specialpain) && self.damageWeapon.specialpain == false)
			{
				self clientfield::set("arch_human_fire_fx", 2 );
			}
		}
	}
}