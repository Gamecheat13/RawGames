#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons\_proximity_grenade;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace armblade;

function autoexec __init__sytem__() {     system::register("armblade",&__init__,undefined,undefined);    }	

function __init__()
{
	level.weaponArmblade = GetWeapon( "hero_armblade" );
	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned()
{	
	self thread armblade_sound_thread(); 
}

function armblade_sound_thread()
{
	self endon( "disconnect" );
	self endon( "death" );
	if( !IsDefined( self.armblade_loop_sound ) )
	{
		self.armblade_loop_sound = spawn( "script_origin", self.origin );
		self.armblade_loop_sound linkto( self );
	}

	for( ;; )
	{
		result = self util::waittill_any_return( "weapon_change" );		
		if( IsDefined( result ) )
		{
			if( ( result == "weapon_change" ) && ( self GetCurrentWeapon() == level.weaponArmblade ) )
			{
				self.armblade_loop_sound PlayLoopSound( "wpn_armblade_idle", 0.25 );
			}
			else
			{
				self.armblade_loop_sound StopLoopSound( 0.25 );
			}
		}
	}
}