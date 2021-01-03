#using scripts\codescripts\struct;

#using scripts\shared\array_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_hacker_utility;

#namespace zm_hackables_wallbuys;

function hack_wallbuys()
{
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" ); 	
	
	for(i = 0; i < weapon_spawns.size; i ++)
	{
		type = weapon_spawns[i].weapon.type;
		if ( type == "grenade" )
		{
			continue;
		}

		if ( type == "melee" )
		{
			continue;
		}

		if ( type == "mine" )
		{
			continue;
		}

		if ( type == "bomb" )
		{
			continue;
		}

		
		struct = SpawnStruct();
		struct.origin = weapon_spawns[i].origin;
		struct.radius = 48;
		struct.height = 48;
		struct.script_float = 2;
		struct.script_int = 3000;
		struct.wallbuy = weapon_spawns[i];		
		hacker_util::register_pooled_hackable_struct(struct,&wallbuy_hack);
	}
	
	bowie_triggers = GetEntArray( "bowie_upgrade", "targetname" );
	
	array::thread_all(bowie_triggers, &hacker_util::hide_hint_when_hackers_active);
}

function wallbuy_hack(hacker)
{
	self.wallbuy.hacked = true;
	model = getent( self.wallbuy.target, "targetname" ); 
	model RotateRoll(180, 0.5);
	hacker_util::deregister_hackable_struct(self);
}
