
//*****************************************************************************
// codescripts
//*****************************************************************************

#using scripts\codescripts\struct;


//*****************************************************************************
// shared
//*****************************************************************************

#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;

#using scripts\shared\array_shared;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
#using scripts\shared\util_shared;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                               	                                                          	              	                                                                                           

#using scripts\cp\cp_mi_cairo_infection_util;



#precache( "client_fx", "explosions/fx_exp_mortar_snow" );


#precache( "client_fx", "explosions/fx_exp_torso_blood_infection" );



//*****************************************************************************
//*****************************************************************************

function main()
{
	init_clientfields();

	level thread mortar_test();
}


//*****************************************************************************
// init_clientfields
//*****************************************************************************

function init_clientfields()
{
	// Callbacks for actors
	clientfield::register( "world", "forest_mortar_index", 1, 3, "int", &callback_mortar_index, !true, !true );

	clientfield::register( "world", "forest_sgen_falling_debris_1", 1, 1, "int", &callback_forest_sgen_falling_debris, !true, !true );

	clientfield::register( "toplayer", "pstfx_frost_up", 		1, 1, "counter", 	&callback_pstfx_frost_up, 		!true, !true );
	clientfield::register( "toplayer", "pstfx_frost_down", 		1, 1, "counter", 	&callback_pstfx_frost_down, 	!true, !true );
}


//*****************************************************************************
//*****************************************************************************

function callback_mortar_index( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	// Turn Off
	if( newVal == 0 )
	{
		level.mortar_start = false;
	}		
	else if( newVal )
	{
		level.mortar_start = true;
		level.mortar_index = newVal;
		level.mortar_index_randomize = 1;
	}
	else
	{
	}
}


//*****************************************************************************
//*****************************************************************************

function mortar_test()
{
	if( !IsDefined(level.mortar_index) )
	{
		// The start index for the intro
		level.mortar_index = 0;
		level.mortar_index_randomize = 1;
	}

	index = 0;
	delay = 3.0;
	while( true )
	{
		while( !( isdefined( level.mortar_start ) && level.mortar_start ))
		{
			wait 1;
		}	
		
		switch( level.mortar_index )
		{
			// Anim falling into the map
			case 0:
				a_struct = struct::get_array( "s_background_mortar_0", "targetname" );
				delay = randomfloatRange( 0.5, 1.0 );		// 2, 5
			break;
			
			// The intro on thebattle field
			case 1:
				a_struct = struct::get_array( "s_background_mortar_1", "targetname" );
				delay = randomfloatRange( 1.5, 2.5 );		// 2, 5
			break;
						
			case 2:
				a_struct = struct::get_array( "s_background_mortar_2", "targetname" );
				delay = randomfloatRange( 1.5, 2.0 );		// 2, 4
			break;
			
			case 3:
				a_struct = struct::get_array( "s_background_mortar_3", "targetname" );
				delay = randomfloatRange( 1.5, 2.5 );		// 3, 4
			break;

			case 4:
				a_struct = struct::get_array( "s_background_mortar_4", "targetname" );
				delay = randomfloatRange( 5, 8 );		// 5, 8
			break;

			case 5:
				a_struct = struct::get_array( "s_background_mortar_5", "targetname" );
				delay = randomfloatRange( 5, 8 );		// 5, 8
			break;

			default:
			case 6:
				return;
			break;
		}

		if( IsDefined(level.mortar_index_randomize) )
		{
			index = randomint( a_struct.size );
			level.mortar_index_randomize = undefined;
		}

		PlayFx( 0, "explosions/fx_exp_mortar_snow", a_struct[index].origin );

		index++;
		if( index >= a_struct.size )
		{
			index = 0;
		}
		
		wait( delay );
	}
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

function callback_forest_sgen_falling_debris( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal )
	{
		level thread forest_debris_manager( localClientNum, 1, 0.4 );
		level thread forest_debris_manager( localClientNum, 5, 0.4 );
		level thread forest_debris_manager( localClientNum, 9, 0.4 );
		level thread forest_debris_manager( localClientNum, 12, 0.4 );
	}
	else
	{
		level notify( "sgen_debris_cleanup" );
	}
}


//*****************************************************************************
//*****************************************************************************

function forest_debris_manager( localClientNum, start_index, delay )
{
	level endon( "sgen_debris_cleanup" );

	debris_num = start_index;

	while( 1 )
	{
		level thread forest_debris( localClientNum, debris_num );

		wait_time = delay + randomfloatrange( -delay/4, delay/4 );
		wait( wait_time );

		debris_num++;
		if( debris_num > 15 )
		{
			debris_num = 1;
		}
	}
}


//*****************************************************************************
// fold_debris
//*****************************************************************************




function forest_debris( localClientNum, n_path_id )
{
	debris = [];

	a_debris_s = struct::get_array( "forest_debris" );

	// Check through all the debris for this path id and generate a junk array
	for( i=0; i<a_debris_s.size; i++ )
	{
		if( IsDefined(a_debris_s[i].model) && a_debris_s[i].script_index == n_path_id )
		//if( IsDefined(a_debris_s[i].model) )
		{	
			junk = spawn(localClientNum, a_debris_s[i].origin, "script_model" );
			junk SetModel( a_debris_s[i].model );
			junk.targetname = a_debris_s[i].targetname;
			
			speed = a_debris_s[i].script_physics;
			speed = 120;		// 100

			junk.speed = RandomFloatRange( speed, speed + 150 );
			junk.speed_rotate = RandomFloatRange( a_debris_s[i].script_turnrate, a_debris_s[i].script_turnrate + 1.5 );

			if( IsDefined(a_debris_s[i].angles) )
			{
				junk.angles = a_debris_s[i].angles;
			}
			
			array::add( debris, junk, false );
		}
	}
	
	foreach( junk in debris )
	{
		junk thread move_junk( localClientNum, n_path_id );
	}
}


//*****************************************************************************
// 	move_junk
//*****************************************************************************

function move_junk( localClientNum, n_path_id )
{
	s_current = struct::get( "forest_debris_path_" + n_path_id );
	
	junk_rotater = util::spawn_model( localClientNum, "tag_origin", self.origin, self.angles );
	self LinkTo( junk_rotater );
	
	junk_mover = util::spawn_model( localClientNum, "tag_origin", s_current.origin, self.angles );
	junk_rotater LinkTo( junk_mover );
	
	self thread rotate_junk( junk_rotater );
	
	while( IsDefined(s_current.target) )
	{									
		s_next = struct::get( s_current.target );
		
		n_dist = Distance( s_current.origin, s_next.origin );
		
		n_time = n_dist / self.speed;
		
		junk_mover MoveTo( s_next.origin, n_time, 0, 0 );
		junk_mover waittill ( "movedone" );
		
		s_current = s_next;				
	}
	
	self notify( "junk_path_end" );
	self Unlink();


	// Get the final junk position
	pos = self.origin;
	angles = self.angles;
	
	// Delete piece
	self Delete();
	junk_mover Delete();

	// Play an explosion effect	
	fxObj = util::spawn_model( localClientNum, "tag_origin", pos, angles );
	fxObj infection_util::fx_play_on_tag( localClientNum, "exploding_death_fx", "explosions/fx_exp_torso_blood_infection", "tag_origin" );
//	fxObj playsound( 0, "evt_ai_explode" );
	waitrealtime( 6 );
	fxobj delete();		
}


//*****************************************************************************
// rotate_junk
//*****************************************************************************

function rotate_junk( junk_rotater )
{
	self endon( "junk_path_end" );
	
	n_revolution = 1000;
	n_rotation = 360 * n_revolution;
	n_time = n_rotation / ( 360 * self.speed_rotate );
	
	while( true )
	{
		junk_rotater RotateRoll( n_rotation, n_time, 0, 0 );
		junk_rotater waittill ( "rotatedone" );
	}
	
	junk_rotater Delete();
}	


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

//#if 0
//
//// ----------------------------------------------------------------------------
//// time_lapse
//// ----------------------------------------------------------------------------
//function callback_time_lapse( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
//{
//	n_wait_per_cycle = 1 / N_GROWTH_PER_SECOND;
//	
//	n_growth_increment = 1 / ( N_GROWTH_PER_SECOND * N_TIME_LAPSE_LENGTH );
//	n_growth = 0;
//	
//	for ( i = 0; i <= N_TIME_LAPSE_LENGTH; i = i + n_wait_per_cycle )
//	{
//		n_growth += n_growth_increment;
//		
//		wait n_wait_per_cycle;
//	}
//}
//
//#endif

// ----------------------------------------------------------------------------
// callback_pstfx_frost_up
// ----------------------------------------------------------------------------
function callback_pstfx_frost_up( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	player = GetLocalPlayer( localClientNum );
	
	if ( !isdefined( player.pstfx_frost ) )
	{
		player.pstfx_frost = 0;
	}
	
	if ( ( player.pstfx_frost == 0 ) )
	{
		player.pstfx_frost = 1;
		player postfx::PlayPostfxBundle( "pstfx_frost_up" );
		player postfx::PlayPostfxBundle( "pstfx_frost_loop" );
	}
}

// ----------------------------------------------------------------------------
// callback_pstfx_frost_down
// ----------------------------------------------------------------------------
function callback_pstfx_frost_down( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	player = GetLocalPlayer( localClientNum );
	
	if ( ( player.pstfx_frost === 1 ) )
	{
		player.pstfx_frost = 0;
		player postfx::PlayPostfxBundle( "pstfx_frost_down" );	
	}
}