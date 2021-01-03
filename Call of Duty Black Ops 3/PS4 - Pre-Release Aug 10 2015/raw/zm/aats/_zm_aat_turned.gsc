#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\name_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai\systems\gib;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                             	     	                                                                                                                                                                

#using scripts\zm\_zm_utility;

                                             	

                                                                                                                               

#precache( "material", "t7_hud_zm_aat_turned" );

#namespace zm_aat_turned;

function autoexec __init__sytem__() {     system::register("zm_aat_turned",&__init__,undefined,"aat");    }

function __init__()
{
	if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
	{
		return;
	}

	aat::register( "zm_aat_turned", 0.05, 30, 30, false, &result, "t7_hud_zm_aat_turned", "wpn_aat_turned_plr" );

	clientfield::register( "actor", "zm_aat_turned", 1, 1, "int" ); 
}


function result( death, attacker, mod, weapon )
{
	if ( death )
	{
		return;
	}
	
	if ( self.archetype !== "zombie" )
	{
		return;
	}
	
	self clientfield::set( "zm_aat_turned", 1 );
	
	self thread zombie_death_time_limit( attacker );
	
	self.team = "allies";
	self.script_friendname = "Zombie Killer";
	self name::get();
	self.aat_turned = true;
}

// Sets Time Limit before zombie dies
// self == affected zombie
function zombie_death_time_limit( e_attacker )
{
	self endon( "death" );
	self endon( "entityshutdown" );
	
	wait 10;
	
	self zombie_death_gib( e_attacker );
}

// Gibs and Kills zombie
// self == affected zombie
function zombie_death_gib( e_attacker )
{
	gibserverutils::gibhead( self );
	
	if ( math::cointoss() )
	{
		gibserverutils::gibleftarm( self );
	}
	else
	{
		gibserverutils::gibrightarm( self );
	}
	
	gibserverutils::giblegs( self );
	
	self DoDamage( self.health, self.origin, e_attacker );
}