#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_zurich_newworld_fx;
#using scripts\cp\cp_mi_zurich_newworld_sound;
#using scripts\cp\cp_mi_zurich_newworld_util;

function main()
{
	init_clientfields();
	
	cp_mi_zurich_newworld_fx::main();
	cp_mi_zurich_newworld_sound::main();

	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
}

function init_clientfields()
{
	// Maglev Train
	clientfield::register( "world", "train_brake_flaps", 1, 1, "int", &train_brake_flaps, !true, !true );
}

function train_brake_flaps( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) 
{
	if( newVal == 1 )
	{
		// Init the flaps
		a_e_flaps = GetEntArray( localClientNum, "train_roof_flap", "targetname" );
		foreach( e_flap in a_e_flaps )
		{
			e_flap RotatePitch( 90, 0.5 );	
		}
	}
	else
	{
		// Raise the flaps	
		s_back = struct::get( "back_of_the_train", "targetname" );
		a_e_flaps = GetEntArray( localClientNum, "train_roof_flap", "targetname" );
		a_e_flaps = array::get_all_closest( s_back.origin, a_e_flaps );
		
		n_count = 0;
		foreach( e_flap in a_e_flaps )
		{
			// Make the brake flap pop up
			e_flap RotatePitch( -90, 0.5 );
			e_flap thread train_brake_flaps_ambient_movement();
			
			// Add a small wait so the brake flaps are slightly staggered when popping up
			n_count++;
			if( n_count % 3 == 0 )
			{
				wait 0.25;	
			}
		}
	}
}

function train_brake_flaps_ambient_movement() // self = brake flap model
{
	level endon( "newworld_train_complete" );
	
	// This wait allows the previous RotatePitch call to play out before ambient movement kicks in
	// Otherwise, subequent calls of RotatePitch will stomp on each other
	self waittill( "rotatedone" );

	while( 1 )
	{
		n_rotate_amount = RandomFloatRange( 2, 5 );
		n_rotate_time = RandomFloatRange( 0.15, 0.25 );
		
		self RotatePitch( n_rotate_amount, n_rotate_time );
		
		self waittill( "rotatedone" );
		
		n_rotate_amount = n_rotate_amount * -1;
		
		self RotatePitch( n_rotate_amount, n_rotate_time );
		
		self waittill( "rotatedone" );
	}	
}
