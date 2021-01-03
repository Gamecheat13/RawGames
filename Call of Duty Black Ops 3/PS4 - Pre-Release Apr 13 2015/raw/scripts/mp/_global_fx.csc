#using scripts\codescripts\struct;

#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
	
#precache( "client_fx", "weapon/fx_hero_grvity_spk_grnd_hit_dust" );
	
#namespace gravity_spikes;

function autoexec __init__sytem__() {     system::register("gravity_spikes",&__init__,undefined,undefined);    }	

function __init__()
{	
	level._effect["gravity_spike_dust"] = "weapon/fx_hero_grvity_spk_grnd_hit_dust";
	level.gravity_spike_table = "surface_explosion_gravityspikes";
	
	level thread watchForGravitySpikeExplosion();
}


function watchForGravitySpikeExplosion()
{
	if ( GetActiveLocalClients() > 1 )
		return;

	weapon_proximity = GetWeapon( "hero_gravityspikes" );

	while ( true )
	{
		level waittill( "explode", localClientNum, position, mod, weapon, owner_cent );
		
		if ( weapon.rootWeapon != weapon_proximity )
		{
			continue;
		}
		
		thread do_gravity_spike_fx( localClientNum, owner_cent, weapon, position );
		thread audio::doRattle(position,200,700);
	}
}

function do_gravity_spike_fx( localClientNum, owner, weapon, position )
{
	// this value will bring in the outermost circle so the effects don't spawn
	// right on the outer edge of the explosion
	radius_of_effect = 40;  
	
	number_of_circles = 3;
	base_number_of_effects = 3;
	additional_number_of_effects_per_circle = 7;
	
	explosion_radius = weapon.explosionRadius;
	radius_per_circle = ( explosion_radius - radius_of_effect ) / number_of_circles;
	
	for ( circle = 0; circle < number_of_circles; circle++ )
	{
		wait( 0.1 );
		radius_for_this_circle = radius_per_circle * (circle + 1);
		number_for_this_circle = base_number_of_effects + (additional_number_of_effects_per_circle * circle);
		thread do_gravity_spike_fx_circle( localClientNum, owner, position, radius_for_this_circle, number_for_this_circle );
	}
}

function getIdealLocationForFX( startPos, fxIndex, fxCount, defaultDistance, rotation )
{
	currentAngle = ( ( 360 / fxCount ) * fxIndex );
	cosCurrent = cos( currentAngle + rotation );
	sinCurrent = sin( currentAngle + rotation );
	
	return startPos + ( defaultDistance * cosCurrent, defaultDistance * sinCurrent, 0 );
}

function randomizeLocation( startPos, max_x_offset, max_y_offset )
{
	half_x = int(max_x_offset / 2);
	half_y = int(max_y_offset / 2);
	rand_x = RandomIntRange( -half_x, half_x );
	rand_y = RandomIntRange( -half_y, half_y );
	
	return startPos + ( rand_x, rand_y, 0 );
}

function ground_trace( startPos, owner )
{
	trace_height = 50;
	trace_depth = 100;
	
	return bullettrace( startPos + ( 0,0,trace_height ), startPos - ( 0,0,trace_depth ), false, owner ); 
}


function do_gravity_spike_fx_circle( localClientNum, owner, center, radius, count )
{
	segment = 360 / count;
	up = ( 0,0,1 );
	
	randomization = 40;
	sphere_size = 5;
	
	for ( i = 0; i < count; i++ )
	{
		fx_position = getIdealLocationForFX( center, i, count, radius, 0 );
		/#
	 	// Sphere( fx_position, sphere_size, CYAN, 1, true, 8, 300 );
		#/
		fx_position = randomizeLocation( fx_position, randomization, randomization );
		
		trace = ground_trace( fx_position, owner );
	
		if ( trace["fraction"] < 1.0 )
		{
			/#
			// Sphere( fx_position, sphere_size, PURPLE, 1, true, 8, 300 );
			// Sphere( trace["position"], sphere_size, YELLOW, 1, true, 8, 300 );
			#/
			
			fx = GetFXFromSurfaceTable( level.gravity_spike_table, trace["surfacetype"] );
			
			if ( isdefined( fx ) )
			{
				angles = ( 0, RandomIntRange(0,359), 0 );
				forward = AnglesToForward( angles );
				
				normal = trace["normal"];
				if ( LengthSquared( normal ) == 0 )
				{
					normal = ( 1, 0, 0);
				}
				PlayFx( localClientNum, fx, trace["position"], normal, forward  );
			}
		}
		else
		{
			/#
//			Line( fx_position + ( 0,0,50 ), fx_position - ( 0,0,50 ), RED, 1, false, 300 );
			#/
		}
		
		{wait(.016);};
	}
}

