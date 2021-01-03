#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai\systems\gib;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                             	     	                                                                                                                                                                

#using scripts\zm\_zm_utility;

                                                 	       	

                                                                                                                               

#precache( "material", "t7_hud_zm_aat_blast_furnace" );

#namespace zm_aat_blast_furnace;

function autoexec __init__sytem__() {     system::register("zm_aat_blast_furnace",&__init__,undefined,"aat");    }

function __init__()
{
	if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
	{
		return;
	}

	aat::register( "zm_aat_blast_furnace", 0.05, 1, 1, true, &result, "t7_hud_zm_aat_blast_furnace", "wpn_aat_blast_furnace_plr" );

	clientfield::register( "actor", "zm_aat_blast_furnace" + "_explosion", 1, 1, "int" ); 
	clientfield::register( "actor", "zm_aat_blast_furnace" + "_burn", 1, 1, "int" );
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
	
	self thread blast_furnace_explosion( attacker, weapon );
	self clientfield::set( "zm_aat_blast_furnace" + "_explosion", 1 );
}

// Sets Time Limit before zombie dies
// self == explosion point entity model
function blast_furnace_explosion( e_attacker, w_weapon )
{
	// Get array of zombies 
	a_e_blasted_zombies = GetAIArchetypeArray( "zombie" );
	a_e_blasted_zombies = ArraySort( a_e_blasted_zombies, self.origin, true, undefined, 150 );
	
	if ( a_e_blasted_zombies.size > 0 )
	{
		n_damage = a_e_blasted_zombies[0].health;
		
		foreach ( e_blasted_zombie in a_e_blasted_zombies )
		{
			if ( IsAlive( e_blasted_zombie ) )
			{
				e_blasted_zombie thread clientfield::set( "zm_aat_blast_furnace" + "_burn", 1 );
				if ( e_blasted_zombie == self )
				{
					self thread zombie_death_gib( e_attacker, w_weapon );
				}
			}
		}
		
		wait .25;
		
		array::remove_dead( a_e_blasted_zombies );
		array::remove_undefined( a_e_blasted_zombies );
		array::thread_all( a_e_blasted_zombies, &zombie_death_gib, e_attacker );
	}
}

// Gibs and Kills zombie
// self == affected zombie
function zombie_death_gib( e_attacker, w_weapon )
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
	
	self DoDamage( self.health, self.origin, e_attacker, w_weapon, "torso_upper" );
}