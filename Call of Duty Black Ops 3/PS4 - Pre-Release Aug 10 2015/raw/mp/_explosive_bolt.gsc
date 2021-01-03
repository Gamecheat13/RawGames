#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\_util;

#precache( "fx", "weapon/fx_equip_light_os" );

#namespace explosive_bolt;

function autoexec __init__sytem__() {     system::register("explosive_bolt",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned()
{
	self thread begin_other_grenade_tracking();
}

function begin_other_grenade_tracking()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self notify( "boltTrackingStart" );	
	self endon( "boltTrackingStart" );

	weapon_bolt = GetWeapon( "explosive_bolt" );

	for (;;)
	{
		self waittill ( "grenade_fire", grenade, weapon, cookTime );

		if ( grenade util::isHacked() )
		{
			continue;
		}
		
		if ( weapon == weapon_bolt )
		{
			grenade.ownerWeaponAtLaunch = self.currentWeapon;
			grenade.ownerAdsAtLaunch = ( self PlayerAds() == 1 ? true : false );
			grenade thread watch_bolt_detonation( self );
			grenade thread weapons::check_stuck_to_player( true, false, weapon );
		}
	}
}

function watch_bolt_detonation( owner ) // self == explosive_bolt entity
{
	//self SetTeam( owner.team );
}
