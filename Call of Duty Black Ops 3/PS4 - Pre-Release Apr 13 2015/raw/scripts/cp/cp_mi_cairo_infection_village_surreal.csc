#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                               	                                                          	              	                                                                                           

#using scripts\cp\_load;
#using scripts\shared\util_shared;

#namespace village_surreal;
//--------------------------------------------------------------------------------------------------
//		MAIN
//--------------------------------------------------------------------------------------------------
function main()
{
	init_clientfields();
}

//--------------------------------------------------------------------------------------------------
// 	init_clientfields
//--------------------------------------------------------------------------------------------------
function init_clientfields()
{
	clientfield::register( "world", "infection_fold_debris_1",	1, 1, "int", &infection_fold_debris_1, 			!true, true);
	clientfield::register( "world", "infection_fold_debris_2",	1, 1, "int", &infection_fold_debris_2, 			!true, true);
	clientfield::register( "world", "infection_fold_debris_3",	1, 1, "int", &infection_fold_debris_3, 			!true, true);
	clientfield::register( "world", "infection_fold_debris_4",	1, 1, "int", &infection_fold_debris_4, 			!true, true);
	clientfield::register( "world", "light_church_ext_window",	1, 1, "int", &callback_light_church_ext_window,	!true, !true );
	clientfield::register( "world", "light_church_int_all",		1, 1, "int", &callback_light_church_int_all,		!true, !true );
	clientfield::register( "world", "dynent_catcher",			1, 1, "int", &callback_dynent_catcher,			!true, !true );
}

//--------------------------------------------------------------------------------------------------
// 	infection_fold_debris_1
//--------------------------------------------------------------------------------------------------
function infection_fold_debris_1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if ( oldVal != newVal && newVal != 0 )
	{
		level thread fold_debris( localClientNum, 1 );
	}
}

//--------------------------------------------------------------------------------------------------
// 	infection_fold_debris_2
//--------------------------------------------------------------------------------------------------
function infection_fold_debris_2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if ( oldVal != newVal && newVal != 0 )
	{
		level thread fold_debris( localClientNum, 2 );
	}
}

//--------------------------------------------------------------------------------------------------
// 	infection_fold_debris_3
//--------------------------------------------------------------------------------------------------
function infection_fold_debris_3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if ( oldVal != newVal && newVal != 0 )
	{
		level thread fold_debris( localClientNum, 3 );
	}
}

//--------------------------------------------------------------------------------------------------
// 	infection_fold_debris_4
//--------------------------------------------------------------------------------------------------
function infection_fold_debris_4(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if ( oldVal != newVal && newVal != 0 )
	{
		level thread fold_debris( localClientNum, 4 );
	}
}

//--------------------------------------------------------------------------------------------------
// 	callback_light_church_ext_window
//--------------------------------------------------------------------------------------------------
function callback_light_church_ext_window(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if ( newVal == 1 )
	{
		exploder::exploder( "light_church_ext_window" );
	}
	else
	{
		exploder::stop_exploder( "light_church_ext_window" );
	}
}

//--------------------------------------------------------------------------------------------------
// 	callback_light_church_int_all
//--------------------------------------------------------------------------------------------------
function callback_light_church_int_all(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if ( newVal == 1 )
	{
		exploder::exploder( "light_church_int_all" );
	}
	else
	{
		exploder::stop_exploder( "light_church_int_all" );
	}
}

//--------------------------------------------------------------------------------------------------
// 	fold_debris
//--------------------------------------------------------------------------------------------------
function fold_debris( localClientNum, n_path_id )
{
	debris = [];
	
	position = struct::get_array( "fold_debris" );
	
	for( i=0; i < position.size; i++ )
	{
		if( IsDefined(position[i].model) && position[i].script_index == n_path_id )
		{	
			junk = spawn(localClientNum, position[i].origin, "script_model" );
			junk SetModel( position[i].model );
			junk.targetname = position[i].targetname;
			
			junk.speed = RandomFloatRange( position[i].script_physics, position[i].script_physics + 50 );
			junk.speed_rotate = RandomFloatRange( position[i].script_turnrate, position[i].script_turnrate + 0.5 );

			if ( isdefined( position[i].angles ) )
			{
				junk.angles = position[i].angles;
			}
			
			array::add(debris, junk, false);
		}
	}
	
	foreach ( junk in debris )
	{
		junk thread move_junk( localClientNum, n_path_id );
		junk thread sndJunkWhizby();
	}
}

//--------------------------------------------------------------------------------------------------
// 	move_junk
//--------------------------------------------------------------------------------------------------
function move_junk( localClientNum, n_path_id )
{
	s_current = struct::get( "fold_debris_path_" + n_path_id );
	
	junk_rotater = util::spawn_model(localClientNum, "tag_origin", self.origin, self.angles );
	self LinkTo( junk_rotater );
	
	junk_mover = util::spawn_model(localClientNum, "tag_origin", s_current.origin, self.angles );
	junk_rotater LinkTo( junk_mover );
	
	self thread rotate_junk( junk_rotater );
	
	while ( IsDefined( s_current.target ) )
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
	
	self Delete();
	junk_mover Delete();
	junk_rotater Delete();
}

//--------------------------------------------------------------------------------------------------
// 	rotate_junk
//--------------------------------------------------------------------------------------------------
function rotate_junk( junk_rotater )
{
	self endon( "junk_path_end" );
	
	n_revolution = 1000;
	n_rotation = 360 * n_revolution;
	n_time = n_rotation / ( 360 * self.speed_rotate );
	
	while ( true )
	{
		junk_rotater RotateRoll( n_rotation, n_time, 0, 0 );
		
		junk_rotater waittill ( "rotatedone" );
	}
}	

function sndJunkWhizby()
{
	self endon( "junk_path_end" );
	self endon( "death" );
	
	players = level.localPlayers;

	while(isdefined(self) && isdefined( self.origin ))
	{
		if ( isdefined( players[0] ) && isdefined( players[0].origin ))
		{
			junkDistance = DistanceSquared( self.origin, players[0].origin);

			if( junkDistance <= 300 * 300 )
			{
				self playsound(0, "amb_junk_flyby");
				return;
			}
		}
		
		wait (.2);	
	}
}

//--------------------------------------------------------------------------------------------------
// 	callback_dynent_catcher
//--------------------------------------------------------------------------------------------------
function callback_dynent_catcher( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		level thread dynent_catcher( localClientNum );
	}
	else
	{
		level notify( "dynent_catcher_disable" );
	}
}

//--------------------------------------------------------------------------------------------------
// 	callback_dynent_catcher
//--------------------------------------------------------------------------------------------------
function dynent_catcher( localClientNum )
{
	level endon( "dynent_catcher_disable" );
	
	t_dynent_catcher = GetEnt( localClientNum, "t_dynent_catcher", "targetname" );
	e_touch_test = spawn( localClientNum, (0,0,0), "script_origin" );
	e_touch_test SetModel( "tag_origin" );
	a_dynent_hidden = [];
	
	while ( true )
	{
		a_dynent_junks = GetDynEntArray( "fold_dynent" );
		
		foreach ( dynent_junk in a_dynent_junks )
		{
			e_touch_test.origin = dynent_junk.origin;
			
			if ( e_touch_test IsTouching( t_dynent_catcher ) )
			{
				If ( !IsInArray( a_dynent_hidden, dynent_junk ) )
				{
					array::add( a_dynent_hidden, dynent_junk );
					SetDynEntEnabled( dynent_junk, false );				
					wait 0.1; // Spread out the deletion over frames.
				}
			}
		}
		
		wait 1;	// Do not try to delete every frame for performance issue. Do it once every second.
	}
}
