#using scripts\codescripts\struct;

#using scripts\shared\damagefeedback_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       


#namespace burnplayer;

function autoexec __init__sytem__() {     system::register("burnplayer",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "allplayers", "burn", 1, 1, "int" );
}

//self is burning player
function SetPlayerBurning( duration, interval, damagePerInterval, attacker )
{
	self clientfield::set( "burn", 1 );

	self thread WatchBurnTimer( duration );
	self thread WatchBurnDamage( interval, damagePerInterval, attacker );
	self thread WatchForWater();
	self thread WatchBurnFinished();
}

function WatchBurnFinished()
{
	self endon( "disconnect" );
	
	self util::waittill_any( "death", "burn_finished" );
	
	self clientfield::set("burn", 0 );

}

function WatchBurnTimer( duration )
{
	self notify( "BurnPlayer_WatchBurnTimer" );
	self endon( "BurnPlayer_WatchBurnTimer" );
	self endon( "disconnect" );
	self endon( "death" );
	
	wait( duration );
	self notify( "burn_finished" );
}

function WatchBurnDamage( interval, damage, attacker )
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "BurnPlayer_WatchBurnTimer" ); // Prevent damage stacking
	
	self endon( "burn_finished" );
	
	while( 1 )
	{
		wait( interval );
		self dodamage( damage, self.origin, attacker, undefined, undefined, "MOD_BURNED" );
	}
}

function watchForWater()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	self endon( "burn_finished" );
	
	while( 1 )
	{
		if( self IsPlayerUnderwater() )
		{
			self notify( "burn_finished" );
		}
		
		wait( .05 );
	}
}