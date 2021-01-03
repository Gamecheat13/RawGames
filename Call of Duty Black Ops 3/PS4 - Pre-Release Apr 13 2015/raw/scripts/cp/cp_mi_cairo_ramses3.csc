#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\shared\util_shared;

#using scripts\cp\cp_mi_cairo_ramses3_fx;
#using scripts\cp\cp_mi_cairo_ramses3_sound;
#using scripts\cp\cp_mi_cairo_ramses_utility;
#using scripts\shared\vehicles\_quadtank;

function main()
{
	init_clientfields();
	
	cp_mi_cairo_ramses3_fx::main();
	cp_mi_cairo_ramses3_sound::main();
	
	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
}

function init_clientfields()
{
	// Dead Event
	clientfield::register( "toplayer", "dead_event_gridlines", 1, 1, "int", &dead_event_gridlines, !true, !true );
}

function dead_event_gridlines( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) // self = player
{
	if( newVal == 1 )
	{
		if( !IsDefined( self.e_gridlines ) )
		{
			self.a_e_gridlines = [];
			
			for( i = 0; i < 2; i++ )
			{
				e_grid = spawn( localClientNum, (0,0,0), "script_model" );
				e_grid SetModel( "p7_grid_dead_system_01" );
				
				self.a_e_gridlines[ self.a_e_gridlines.size ] = e_grid;
				
				if( i == 0 )
				{
					s_low = struct::get( "dead_event_gridline_low", "targetname" );
					e_grid.origin = s_low.origin;
					e_grid.angles = s_low.angles;
				}
				else
				{
					s_high = struct::get( "dead_event_gridline_high", "targetname" );
					e_grid.origin = s_high.origin;
					e_grid.angles = s_high.angles;
				}
				
				self.a_e_gridlines[ i ] = e_grid;
				//OptionalArg: <linkType>, 0 - pitch only, 1 - yaw only, 2 - roll only, 3 - swimming, 4 - full, 5 - 3d compass.  Full is the default if not specified."
				//e_grid LinkToCamera( 1 );
			}

			self thread delete_gridlines_on_disconnect();
		}
		else
		{
			// SHOW THE GRIDLINES
			foreach( e_grid in self.a_e_gridlines )
			{
				e_grid Show();
			}
		}
	}
	else
	{
		// HIDE THE GRIDLINES
		foreach( e_grid in self.a_e_gridlines )
		{
			e_grid Hide();
		}
	}
}

function delete_gridlines_on_disconnect() // self = player
{
	self waittill( "disconnect" );
	
	if( IsDefined( self ) && IsDefined( self.a_e_gridlines ) )
	{
		foreach( e_gridline in self.a_e_gridlines )
		{
			e_gridline delete();
			
			{wait(.016);};
		}
	}
}

