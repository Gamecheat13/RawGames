#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\cp\sidemissions\_sm_ammo_cache;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       

function autoexec __init__sytem__() {     system::register("supply_manager",undefined,&__main__,undefined);    }



#precache( "material", "compass_supply_drop_green" ); 

function __main__()
{
	level.n_ammo_cache_id = 31;
	
	// Ammo Cache
	//-----------

	a_s_ammo_cache = struct::get_array( "ammo_cache", "script_noteworthy" );

	foreach ( s_ammo_cache in a_s_ammo_cache )
	{
		if ( !IsDefined( s_ammo_cache.targetname ) ) // Not tied to a zone, always exist
		{
			ammo_cache = new cAmmoCrate();
			[[ ammo_cache ]]->spawn_ammo_cache( s_ammo_cache.origin, s_ammo_cache.angles );
		}
	}
}
