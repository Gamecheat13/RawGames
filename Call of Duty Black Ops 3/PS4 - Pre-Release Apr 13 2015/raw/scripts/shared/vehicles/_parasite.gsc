#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace quadtank;

function autoexec __init__sytem__() {     system::register("quadtank",&__init__,undefined,undefined);    }

function __init__()
{
	vehicle::add_vehicletype_callback( "quadtank", &_setup_ );

	clientfield::register( "toplayer", "player_shock_fx", 1, 1, "int", &player_shock_fx_handler, !true, !true );

	callback::on_localclient_connect( &on_player_connect );
}

function _setup_( localClientNum )
{
	player = GetLocalPlayer( localClientNum );
	if( isdefined( player ) )
	{
		player on_player_connect( localClientNum );
	}
}

function on_player_connect( localClientNum )
{
	filter::init_filter_ev_interference( self );
}

function player_shock_fx_handler( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( isdefined( self ) )
	{
		self thread player_shock_fx_fade_off( 1.0, 1.0 );
	}
}

function player_shock_fx_fade_off( amount, fadeoutTime )
{
	self endon ( "death" );
	self notify( "player_shock_fx_fade_off_end" );	// kill previous threads
	self endon( "player_shock_fx_fade_off_end" );

	startTime = GetTime();

	filter::set_filter_ev_interference_amount( self, 4, amount );
	filter::enable_filter_ev_interference( self, 4 );

	while ( GetTime() <= startTime + fadeoutTime * 1000 && isAlive( self ) )
	{
		ratio = ( GetTime() - startTime ) / ( fadeoutTime * 1000 );
		currentValue = LerpFloat( amount, 0, ratio );
		filter::set_filter_ev_interference_amount( self, 4, currentValue );
		wait .016;
	}

	filter::disable_filter_ev_interference( self, 4 );
}