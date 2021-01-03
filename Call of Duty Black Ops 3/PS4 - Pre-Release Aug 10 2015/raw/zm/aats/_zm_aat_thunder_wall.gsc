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

                                                  	      

                                                                                                                               

#precache( "material", "t7_hud_zm_aat_thunder_wall" );

#namespace zm_aat_thunder_wall;

function autoexec __init__sytem__() {     system::register("zm_aat_thunder_wall",&__init__,undefined,"aat");    }

function __init__()
{
	if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
	{
		return;
	}

	aat::register( "zm_aat_thunder_wall", 0.025, 1, 20, true, &result, "t7_hud_zm_aat_thunder_wall", "wpn_aat_thunder_wall_plr" );

	clientfield::register( "actor", "zm_aat_thunder_wall", 1, 1, "int" ); 
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
	
	v_thunder_wall_blast_pos = self.origin; // Stores origin point of Thunder Wall
	
	zombies = array::get_all_closest( v_thunder_wall_blast_pos, GetAIArchetypeArray( "zombie" ), undefined, undefined, 2 * 200 );
	if ( !isDefined( zombies ) )
	{
		return;
	}

	f_thunder_wall_range_sq = 200 * 200;
	f_thunder_wall_effect_area_sq = 360 * 360;

	fling_force_v = 0.5;
	
	v_attacker_facing = attacker GetWeaponForwardDir();
	end_pos = v_thunder_wall_blast_pos + VectorScale( v_attacker_facing, 200 );

	self PlaySound( "wpn_aat_thunder_wall_plr" );
	self clientfield::set( "zm_aat_thunder_wall", 1 );

	n_flung_zombies = 0; // Tracks number of flung zombies, compares to ZM_AAT_THUNDER_WALL_MAX_ZOMBIES_FLUNG
	for ( i = 0; i < zombies.size; i++ )
	{
		// If current zombie is already dead
		if ( !IsDefined( zombies[i] ) || !IsAlive( zombies[i] ) )
		{
			continue;
		}
		
		// If current zombie is the one hit by Thunder Wall, bypass checks
		if ( zombies[i] == self )
		{
			v_curr_zombie_origin = self.origin;
			v_curr_zombie_origin_sq = 0;
		}
		else
		{
			// Get current zombie's data
			v_curr_zombie_origin = zombies[i] GetCentroid();
			v_curr_zombie_origin_sq = DistanceSquared( v_thunder_wall_blast_pos, v_curr_zombie_origin );
			v_curr_zombie_to_thunder_wall = VectorNormalize( v_curr_zombie_origin - v_thunder_wall_blast_pos );
			v_curr_zombie_facing_dot = VectorDot( v_attacker_facing, v_curr_zombie_to_thunder_wall );
	
			// If the current zombie is in front of the zombie hit by Thunder Wall, is unaffected
			if ( v_curr_zombie_facing_dot < 0 )
			{
				continue;
			}
	
			// If current zombie is out of range
			radial_origin = PointOnSegmentNearestToPoint( v_thunder_wall_blast_pos, end_pos, v_curr_zombie_origin );
			if ( DistanceSquared( v_curr_zombie_origin, radial_origin ) > f_thunder_wall_effect_area_sq )
			{
				continue;
			}
		}
		
		// Executes the fling. If the zombie is the one hit by the bullet, will fling automatically
		if ( v_curr_zombie_origin_sq < f_thunder_wall_range_sq )
		{
			// Adds a slight variance to the direction of the fling
			n_random_x = RandomFloatRange( -3, 3 );
			n_random_y = RandomFloatRange( -3, 3 );
			
			zombies[i] DoDamage( zombies[i].health, v_curr_zombie_origin, attacker, attacker, "", "MOD_IMPACT" );
			zombies[i] StartRagdoll( true );
			zombies[i] LaunchRagdoll ( 100 * VectorNormalize( v_curr_zombie_origin - attacker.origin + ( n_random_x, n_random_y, 25 ) ) );
			
			n_flung_zombies++;
		}
		
		// Limits the number of zombies flung by the bullet
		if ( 0 != 0 && n_flung_zombies >= 0 )
		{
			break;
		}
		
	}
}