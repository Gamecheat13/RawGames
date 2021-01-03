#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_util;

#namespace shellshock;

function autoexec __init__sytem__() {     system::register("shellshock",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &main );

	level.shellshockOnPlayerDamage = &on_damage;
}	

function main()
{
}

function on_damage( cause, damage, weapon )
{
	//if ( self _flashgrenades::isFlashbanged() )
	//	return; // don't interrupt flashbang shellshock
	
	if ( cause == "MOD_EXPLOSIVE" ||
	     cause == "MOD_GRENADE" ||
	     cause == "MOD_GRENADE_SPLASH" ||
	     cause == "MOD_PROJECTILE" ||
	     cause == "MOD_PROJECTILE_SPLASH" )
	{
		time = 0;
		
		if(damage >= 90)
			time = 4;
		else if(damage >= 50)
			time = 3;
		else if(damage >= 25)
			time = 2;
		else if(damage > 10)
			time = 2;
		
		if ( time )
		{
			if ( self util::mayApplyScreenEffect() )
				self shellshock("frag_grenade_mp", 0.5);
		}
	}
}

function endOnDeath()
{
	self waittill( "death" );
	waittillframeend;
	self notify ( "end_explode" );
}

function endOnTimer( timer )
{
	self endon( "disconnect" );

	wait( timer );
	self notify( "end_on_timer" );
}

function rcbomb_earthQuake(position)
{
	PlayRumbleOnPosition( "grenade_rumble", position );
	Earthquake( 0.5, 0.5, self.origin, 512 );
}