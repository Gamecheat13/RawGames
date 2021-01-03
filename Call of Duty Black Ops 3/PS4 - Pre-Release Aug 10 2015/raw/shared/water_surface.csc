#using scripts\shared\system_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
#using scripts\shared\util_shared;

#namespace water_surface;

#precache( "client_fx", "player/fx_plyr_water_jump_in_bubbles_1p" );
#precache( "client_fx", "player/fx_plyr_water_jump_out_splash_1p" );



	
//#define START_WATER_SHEETING { filter::enable_filter_water_sheeting( self, FILTER_INDEX_WATER_SHEET ); }


//#define START_WATER_DIVE { filter::enable_filter_water_dive( self, FILTER_INDEX_WATER_SHEET ); }

	
function autoexec __init__sytem__() {     system::register("water_surface",&__init__,undefined,undefined);    }		

function __init__()
{
	level._effect["water_player_jump_in"] = "player/fx_plyr_water_jump_in_bubbles_1p";
	level._effect["water_player_jump_out"] = "player/fx_plyr_water_jump_out_splash_1p";
	
	if ( isdefined( level.disableWaterSurfaceFX ) && level.disableWaterSurfaceFX == true )
	{
		return;
	}
	
	callback::on_spawned( &player_spawned );
}

function player_spawned( localClientNum )
{
	if ( isdefined( level.disableWaterSurfaceFX ) && level.disableWaterSurfaceFX == true )
	{
		return;
	}
		
	if ( self isLocalPlayer() == false )
	{
		return;
	}
	
	filter::init_filter_water_sheeting( self );
	filter::init_filter_water_dive( self );
	
	self thread underwaterWatchBegin();
	self thread underwaterWatchEnd();
	
	{ filter::disable_filter_water_sheeting( self, 1 ); stop_player_fx( self ); };
}

function underwaterWatchBegin()
{
	self notify( "underwaterWatchBegin" );
	self endon( "underwaterWatchBegin" );
	self endon( "entityshutdown" );
	
	while( true )
	{
		self waittill( "underwater_begin", teleported );
		if ( teleported ) 
		{
			{ filter::disable_filter_water_sheeting( self, 1 ); stop_player_fx( self ); };
			{ filter::disable_filter_water_dive( self, 1 ); stop_player_fx( self );};
		}
		else
		{
			self thread underwaterBegin();
		}
	}
}

function underwaterWatchEnd()
{
	self notify( "underwaterWatchEnd" );
	self endon( "underwaterWatchEnd" );
	self endon( "entityshutdown" );
	
	while( true )
	{
		self waittill(  "underwater_end", teleported );
		if ( teleported ) 
		{
			{ filter::disable_filter_water_sheeting( self, 1 ); stop_player_fx( self ); };
			{ filter::disable_filter_water_dive( self, 1 ); stop_player_fx( self );};
		}
		else
		{
			self thread underwaterEnd();
		}
	}
}

function underwaterBegin()
{ 
	self notify( "water_surface_underwater_begin" );
	self endon( "water_surface_underwater_begin" );
	self endon( "entityshutdown" );
	
	localClientNum = self getlocalclientnumber();
	
	{ filter::disable_filter_water_sheeting( self, 1 ); stop_player_fx( self ); };
	
	if ( islocalclientdead( localClientNum ) == false )
	{
		self.firstperson_water_fx = PlayFXOnCamera( localClientNum, level._effect["water_player_jump_in"], (0,0,0), (1,0,0), (0,0,1)  );
		if ( !isdefined( self.playingPostfxBundle ) || self.playingPostfxBundle != "pstfx_watertransition" )
		{
			self thread postfx::PlayPostfxBundle( "pstfx_watertransition" );	
		}
	}
}

function underwaterEnd()
{
	self notify( "water_surface_underwater_end" );
	self endon( "water_surface_underwater_end" );
	self endon( "entityshutdown" );
	
	localClientNum = self getlocalclientnumber();
	if ( islocalclientdead( localClientNum ) == false )
	{
		self thread startWaterSheeting();
		self.firstperson_water_fx = PlayFXOnCamera( localClientNum, level._effect["water_player_jump_out"], (0,0,0), (1,0,0), (0,0,1)  );
		self util::waittill_any_timeout( 2.0, "underwater_begin" );
	}
	{ filter::disable_filter_water_sheeting( self, 1 ); stop_player_fx( self ); };	
}


function startWaterDive()
{
	// turn on the water dive PostFX
	filter::enable_filter_water_dive( self, 1 );

	// allow the bubble clouds to proceed mostly straight upwards
	filter::set_filter_water_scuba_dive_speed( self, 1, 0.25 );

	// set the tint color of the wash bubble wash
	filter::set_filter_water_wash_color( self, 1, 0.16, 0.5, 0.9 );

	// set the wash reveal direction to down
	filter::set_filter_water_wash_reveal_dir( self, 1, -1 );
	// reveal the wash
	for ( i = 0; i < 0.05; i += 0.01 )
	{
		filter::set_filter_water_dive_bubbles( self, 1, i / 0.05 );
		wait 0.01;
	}
	filter::set_filter_water_dive_bubbles( self, 1, 1 );

	// set the bubble cloud fade direction to up
	filter::set_filter_water_scuba_bubble_attitude( self, 1, -1 );
	// start the bubble clouds
	filter::set_filter_water_scuba_bubbles( self, 1, 1 );

	// set the wash reveal direction to up
	filter::set_filter_water_wash_reveal_dir( self, 1, 1 );
	// hide the wash
	for ( i = 0.2; i > 0; i -= 0.01 )
	{
		filter::set_filter_water_dive_bubbles( self, 1, i / 0.2 );
		wait 0.01;
	}
	filter::set_filter_water_dive_bubbles( self, 1, 0 );

	// allow the bubble clouds to play
	wait 0.1;
	// hide the bubble clouds
	for ( i = 0.2; i > 0; i -= 0.01 )
	{
		filter::set_filter_water_scuba_bubbles( self, 1, i / 0.2 );
		wait 0.01;
	}
}

function startWaterSheeting()
{
	self notify( "startWaterSheeting_singleton" );
	self endon( "startWaterSheeting_singleton" );
	
	self endon( "entityshutdown" );
	
	// enabled the filter
	filter::enable_filter_water_sheeting( self, 1 ); 

	// start everything revealed and scrolling
	filter::set_filter_water_sheet_reveal( self, 1, 1.0 );
	filter::set_filter_water_sheet_speed( self, 1, 1.0 );

	// taper down and hide
	for ( i = 2.0; i > 0.0; i -= 0.01 )
	{
		filter::set_filter_water_sheet_reveal( self, 1, i / 2.0 );
		filter::set_filter_water_sheet_speed( self, 1, i / 2.0 );
		// reveal the rivulets as well
		rivulet1 = (i/2.0) - 0.19;
		rivulet2 = (i/2.0) - 0.13;
		rivulet3 = (i/2.0) - 0.07;
		filter::set_filter_water_sheet_rivulet_reveal( self, 1, rivulet1, rivulet2, rivulet3 );
		// pause
		wait 0.01;
	}
	filter::set_filter_water_sheet_reveal( self, 1, 0.0 );
	filter::set_filter_water_sheet_speed( self, 1, 0.0 );
	filter::set_filter_water_sheet_rivulet_reveal( self, 1, 0.0, 0.0, 0.0 );
}

function stop_player_fx( localClient )
{
	if ( IsDefined( localClient.firstperson_water_fx ) )
	{
		localClientNum = localClient getlocalclientnumber();
		StopFx( localClientNum, localClient.firstperson_water_fx );
		localClient.firstperson_water_fx = undefined;
	}
}
