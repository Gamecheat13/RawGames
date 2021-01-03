#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_hacker_utility;

                                                                                       	                                

#namespace zm_hackables_perks;

function hack_perks()
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );	
	
	for(i = 0; i < vending_triggers.size; i ++)
	{
		struct = SpawnStruct();
		machine = getentarray(vending_triggers[i].target, "targetname");
		struct.origin = machine[0].origin  + (AnglesToRight(machine[0].angles) * 18) + (0,0,48);
		struct.radius = 48;
		struct.height = 64;
		struct.script_float = 5;
		
		while(!isdefined(vending_triggers[i].cost))
		{
			{wait(.05);};
		}
		
		struct.script_int = Int(vending_triggers[i].cost * -1);
		struct.perk = vending_triggers[i];
		vending_triggers[i].hackable = struct;
		hacker_util::register_pooled_hackable_struct(struct,&perk_hack,&perk_hack_qualifier);
	}
	
	level._solo_revive_machine_expire_func =&solo_revive_expire_func;
}

function solo_revive_expire_func()
{
	if(isdefined(self.hackable))
	{
		hacker_util::deregister_hackable_struct(self.hackable);
		self.hackable = undefined; 
	}
}

function perk_hack_qualifier(player)
{
	if(isdefined(player._retain_perks))
	{
		return false;
	}
	
	if(player HasPerk(self.perk.script_noteworthy))
	{
		return true;
	}
	
	return false;
}

function perk_hack(hacker)
{
	if ( level flag::get( "solo_game" ) && self.perk.script_noteworthy == "specialty_quickrevive" )
	{
		hacker.lives--;
	}

	hacker notify(self.perk.script_noteworthy + "_stop");
	hacker playsoundtoplayer( "evt_perk_throwup", hacker );
	
	if ( isdefined( hacker.perk_hud ) )
	{
		keys = getarraykeys( hacker.perk_hud );
		for ( i = 0; i < hacker.perk_hud.size; i++ )
		{
			hacker.perk_hud[ keys[i] ].x = i * 30;
		}
	}	
}
