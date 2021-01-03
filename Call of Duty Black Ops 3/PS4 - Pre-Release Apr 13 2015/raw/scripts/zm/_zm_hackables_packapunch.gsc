#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_hacker_utility;
#using scripts\zm\_zm_pack_a_punch_util;

                                                                                       	                                

#namespace zm_hackables_packapunch;

function hack_packapunch()
{
	//flag_wait("power_on");
	
	vending_weapon_upgrade_trigger = zm_pap_util::get_triggers();

	perk = getent(vending_weapon_upgrade_trigger[0].target, "targetname");	
	
	if(isdefined(perk))
	{
		struct = SpawnStruct();
		struct.origin = perk.origin + (AnglesToRight(perk.angles) * 26) + (0,0,48);
		struct.radius = 48;
		struct.height = 48;
		struct.script_float = 5;
		struct.script_int = -1000;
		level._pack_hack_struct = struct;
		hacker_util::register_pooled_hackable_struct(level._pack_hack_struct,&packapunch_hack);		
		
		
		level._pack_hack_struct pack_trigger_think();
		
		//level thread zm_moon::packapunch_hack_think();
	}
}

function pack_trigger_think()
{
	if ( !flag::exists( "enter_nml" ) )
	{
		return;
	}

	while(1)
	{
		level flag::wait_till("enter_nml");
		self.script_int = -1000;
		
		while(level flag::get("enter_nml"))
		{
			wait(1.0);
		}
	}	
}

function packapunch_hack(hacker)
{
	hacker_util::deregister_hackable_struct(level._pack_hack_struct);
	level._pack_hack_struct.script_int = 0;
	level notify("packapunch_hacked");
}
