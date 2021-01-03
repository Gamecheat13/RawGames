#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace decoy;

function init_shared()
{
//	level._effect["decoy_fire"] = "_t6/weapon/grenade/fx_nightingale_grenade_mp";
	
	level thread level_watch_for_fake_fire();
	
	callback::add_weapon_type( "nightingale", &spawned );
}

function spawned(localClientNum)
{	
	self thread watch_for_fake_fire(localClientNum);
}

function watch_for_fake_fire( localClientNum )
{
	self endon("entityshutdown");
	
	while(1)
	{
		self waittill( "fake_fire" );
		
		PlayFxOnTag( localClientNum, level._effect["decoy_fire"], self, "tag_origin" );
	}
}

function level_watch_for_fake_fire( )
{
	while(1)
	{
		self waittill( "fake_fire", origin );
		
		//PlayFX( 0, level._effect["decoy_fire"], origin );
	}
}

