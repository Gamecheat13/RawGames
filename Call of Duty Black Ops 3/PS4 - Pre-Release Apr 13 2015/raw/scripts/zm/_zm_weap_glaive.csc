#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;


#namespace zm_weap_glaive;

function autoexec __init__sytem__() {     system::register("zm_weap_glaive",&__init__,undefined,undefined);    }

#precache( "client_fx", "weapon/fx_hero_grvity_spk_grnd_hit_dust" );
#precache( "client_fx", "zombie/fx_sword_trail_1p_zod_zmb" );
#precache( "client_fx", "zombie/fx_sword_slash_1p_zod_zmb" );
#precache( "client_fx", "zombie/fx_sword_trail_3p_zod_zmb" );

#precache( "client_fx", "weapon/fx_hero_grvity_spk_grnd_hit_1p" );
#precache( "client_fx", "weapon/fx_hero_grvity_spk_grnd_hit" );

function __init__()
{
	clientfield::register( "toplayer", "slam_fx", 1, 1, "counter", &do_slam_fx, !true, !true );
	clientfield::register( "toplayer", "swipe_fx", 1, 1, "counter", &do_swipe_fx, !true, !true );


	level._effect["gravity_spike_dust"] = "weapon/fx_hero_grvity_spk_grnd_hit_dust";
	level._effect["sword_swipe_1p"] = "zombie/fx_sword_trail_1p_zod_zmb";
	level._effect["sword_bloodswipe_1p"] = "zombie/fx_sword_slash_1p_zod_zmb";
	level._effect["sword_swipe_3p"] = "zombie/fx_sword_trail_3p_zod_zmb";
	level._effect["groundhit_1p"] = "weapon/fx_hero_grvity_spk_grnd_hit_1p";
	level._effect["groundhit_3p"] = "weapon/fx_hero_grvity_spk_grnd_hit";

	
	level.gravity_spike_table = "surface_explosion_gravityspikes";
}

function do_swipe_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	owner = self GetOwner( localClientNum );
	if ( IsDefined(owner) && owner == GetLocalPlayer(localClientNum) )
	{
		swipe_fx = PlayViewmodelFx( localclientnum, level._effect["sword_swipe_1p"] , "tag_flash" );
		bloodswipe_fx = PlayViewmodelFx( localclientnum, level._effect["sword_bloodswipe_1p"] , "tag_flash" );	
		wait( 3.0 );
		DeleteFx( localClientNum, swipe_fx, true );
		DeleteFx( localClientNum, bloodswipe_fx, true );
	}
}

function do_slam_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	thread do_gravity_spike_fx( localClientNum, self, self.origin );
}

function do_gravity_spike_fx( localClientNum, owner, position )
{
	// this value will bring in the outermost circle so the effects don't spawn
	// right on the outer edge of the explosion
	radius_of_effect = 50;  
	
	number_of_circles = 3;
	base_number_of_effects = 2;
	additional_number_of_effects_per_circle = 4;
	
	explosion_radius = 0;//weapon.explosionRadius;
	radius_per_circle = ( explosion_radius - radius_of_effect ) / number_of_circles;

	fx = level._effect["groundhit_3p"];
	PlayFx( localClientNum, fx, position );
	
	for ( circle = 0; circle < number_of_circles; circle++ )
	{
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
	
	randomization = 50;
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

