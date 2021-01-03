#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_weapons;

                                                                                                                               

function init()
{
	if( isdefined( level.bowie_cost ) )
	{
		cost = level.bowie_cost;
	}
	else
	{
		cost = 3000;
	}

	zm_melee_weapon::init( "bowie_knife", 
							"zombie_bowie_flourish",
							"knife_ballistic_bowie",
							"knife_ballistic_bowie_upgraded",
	                        cost,
							"bowie_upgrade",
							&"ZOMBIE_WEAPON_BOWIE_BUY",
							"bowie",
							undefined);

	zm_weapons::add_retrievable_knife_init_name( "knife_ballistic_bowie" );
	zm_weapons::add_retrievable_knife_init_name( "knife_ballistic_bowie_upgraded" );
}
