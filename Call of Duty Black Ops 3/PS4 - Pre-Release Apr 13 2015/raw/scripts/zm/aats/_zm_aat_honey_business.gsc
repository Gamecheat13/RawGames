#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_utility;

                    

                                                                                                                               

#precache( "material", "t7_hud_zm_aat_honey_business" );

#namespace zm_aat_honey_business;

function autoexec __init__sytem__() {     system::register("zm_aat_honey_business",&__init__,undefined,"aat");    }

function __init__()
{
	if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
	{
		return;
	}

	aat::register( "zm_aat_honey_business", 0.5, (0.25 * 6), (0.25 * 6), false, &result, "t7_hud_zm_aat_honey_business", "wpn_aat_honey_business_plr" );

	clientfield::register( "actor", "zm_aat_honey_business", 1, 1, "int" ); 
}


function result( death, attacker, mod, weapon )
{
	if ( death )
	{
		return;
	}

	self notify( "zm_aat_honey_business" );
	self endon( "zm_aat_honey_business" );

	self clientfield::set( "zm_aat_honey_business", 1 );
	self ASMSetAnimationRate( 0.4 );

	self thread damage_over_time( death, attacker, mod, weapon );

	self util::waittill_any_timeout( (0.25 * 6), "death" );

	self ASMSetAnimationRate( 1.0 );
	self clientfield::set( "zm_aat_honey_business", 0 );
}


function damage_over_time( death, attacker, mod, weapon )
{
	self endon( "zm_aat_honey_business" );
	self endon( "death" );

	for ( i = 0; i < 6; i++ )
	{
		wait( 0.25 );

		self DoDamage( 150, self.origin, attacker, self, self.damageLocation, mod, 0, level.weaponNone );
	}
}
