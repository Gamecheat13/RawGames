#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_hacker_utility;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;

#namespace zm_hackables_powerups;

function unhackable_powerup(name)
{
	ret = false;
	
	switch(name)
	{
		case 	"bonus_points_team":
		case "lose_points_team":
		case "bonus_points_player":
		case "random_weapon":
			ret = true;
			break;
	}
	
	return ret;
}

function hack_powerups()
{
	while(1)
	{
		level waittill("powerup_dropped", powerup);
	
		if(!unhackable_powerup(powerup.powerup_name))
		{
			struct = SpawnStruct();
			struct.origin = powerup.origin;
			struct.radius = 65;
			struct.height = 72;
			struct.script_float = 5;
			struct.script_int = 5000;
			struct.powerup = powerup;
			
			powerup thread powerup_pickup_watcher(struct);
			
			hacker_util::register_pooled_hackable_struct(struct,&powerup_hack );		
		}
	}
}

function powerup_pickup_watcher(powerup_struct)
{
	self endon("hacked");
	self waittill("death");
	
	hacker_util::deregister_hackable_struct(powerup_struct);
}

function powerup_hack(hacker)
{
	self.powerup notify("hacked");

	if(isdefined(self.powerup.zombie_grabbable) && self.powerup.zombie_grabbable)
	{
		self.powerup notify("powerup_timedout");
		origin = self.powerup.origin;
		self.powerup Delete();
		
		self.powerup = zm_net::network_safe_spawn( "powerup", 1, "script_model", origin);
		
		if ( isdefined(self.powerup) )
		{
			self.powerup zm_powerups::powerup_setup( "full_ammo" );
	
			self.powerup thread zm_powerups::powerup_timeout();
			self.powerup thread zm_powerups::powerup_wobble();
			self.powerup thread zm_powerups::powerup_grab();
		}
	}
	else if(self.powerup.powerup_name == "full_ammo")
	{
	  self.powerup zm_powerups::powerup_setup("fire_sale");
	}
	else
	{
	  self.powerup zm_powerups::powerup_setup("full_ammo");
	}

	hacker_util::deregister_hackable_struct(self);
}
