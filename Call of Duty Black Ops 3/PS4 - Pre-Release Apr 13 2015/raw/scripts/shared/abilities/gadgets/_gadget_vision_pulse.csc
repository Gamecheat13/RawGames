#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

                                                                           
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                             	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	               	   	    	  	                                                                                 	                                                                                                        

#using scripts\shared\system_shared;

#namespace gadget_vision_pulse;

function autoexec __init__sytem__() {     system::register("gadget_vision_pulse",&__init__,undefined,undefined);    }

function __init__()
{
	if ( !SessionModeIsCampaignGame() )
	{
		callback::on_spawned( &on_player_spawned );
		
		callback::on_localclient_connect( &on_localclient_connect);

		duplicate_render::set_dr_filter_offscreen( "reveal_en", 50, "reveal_enemy", undefined, 2, "mc/hud_outline_model_z_orange"  );
		duplicate_render::set_dr_filter_offscreen( "reveal_self", 50, "reveal_self", undefined, 2, "mc/hud_outline_model_z_orange_alpha"  );
	}
	
	clientfield::register( "toplayer", "vision_pulse_active", 1, 1, "int", &vision_pulse_changed, !true, true );
}

function on_localclient_connect( local_client_num )
{
	filter::init_filter_vision_pulse( self );
}

function on_player_spawned( local_client_num )
{
	if(!((self GetInKillcam(local_client_num)) && (GetLocalPlayer(local_client_num) == self)))
	{
		self gadgetpulseresetreveal();
		self set_reveal_self( local_client_num, false );
		self set_reveal_enemy( false );
	}
}

function disableShader( localClientNum, duration )
{
	self endon ("startVPShader" );
	self endon( "death" );
	self endon( "entityshutdown" );
	self notify( "disableVPShader" );
	self endon( "disableVPShader" );
	
	wait( duration );
	
	filter::disable_filter_vision_pulse( self, 3 );
}

function do_vision_world_pulse( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "death" );
	
	self notify( "startVPShader" );
	
	filter::enable_filter_vision_pulse( self, 3 );
	filter::set_filter_vision_pulse_constant( self, 3, 1, 1.0 );
	filter::set_filter_vision_pulse_constant( self, 3, 2, 0.08 );
	filter::set_filter_vision_pulse_constant( self, 3, 3, 0.0 );
	filter::set_filter_vision_pulse_constant( self, 3, 4, 1.0 );
	
	startTime = GetServerTime( localClientNum );
	
	{wait(.016);};
	amount = 1.0;
	irisAmount = 0.0;
	pulsemaxradius = 0;
	while( ( GetServerTime( localClientNum ) - starttime ) < 1333 )
	{
		elapsedTime = ( GetServerTime( localClientNum ) - starttime ) * 1.0;
		if( elapsedTime < ( 1333 * .2 ) )
		{
			irisAmount = elapsedTime / ( 1333 * .2 );
		}
		else if( elapsedTime < ( 1333 * .6 ) )
		{
			irisAmount = 1.0 - elapsedTime / ( 1333 * .6 );
		}
		else
		{
			irisAmount = 0.0;
		}
		amount = 1.0 -  elapsedTime / 1333;
		pulseRadius = getvisionpulseradius( localClientNum );
		pulseMaxRadius = getvisionpulsemaxradius( localClientNum );
		filter::set_filter_vision_pulse_constant( self, 3, 0, pulseRadius );
		filter::set_filter_vision_pulse_constant( self, 3, 3, irisAmount );
		filter::set_filter_vision_pulse_constant( self, 3, 11, pulseMaxRadius );
		{wait(.016);};
	}
	
	filter::set_filter_vision_pulse_constant( self, 3, 0, pulseMaxRadius + 1 ); 	// Weird thing needed by the shader
	
	self thread disableShader( localClientNum, 4000 / 1000 );	
}

function do_vision_local_pulse( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "death" );
	
	self notify( "startVPShader" );
	
	origin = getrevealpulseorigin( localClientNum );
	//pulseMaxRadius = getrevealpulsemaxradius( localClientNum );
	filter::enable_filter_vision_pulse( self, 3 );
	filter::set_filter_vision_pulse_constant( self, 3, 5, 0.4 );
	filter::set_filter_vision_pulse_constant( self, 3, 6, 0.0001 );
	filter::set_filter_vision_pulse_constant( self, 3, 8, origin[0] );
	filter::set_filter_vision_pulse_constant( self, 3, 9, origin[1] );
	filter::set_filter_vision_pulse_constant( self, 3, 7, 1 );
	
	startTime = GetServerTime( localClientNum );
	while( ( GetServerTime( localClientNum ) - starttime ) < 4000 )
	{
		if( (GetServerTime( localClientNum ) - starttime ) < 1333 )
		{
			pulseRadius = ( (GetServerTime( localClientNum ) - starttime ) / 1333) * 2000;
		}
		//pulseRadius = GetRevealPulseRadius( localClientNum );
		filter::set_filter_vision_pulse_constant( self, 3, 10, pulseRadius );
		
		{wait(.016);};
	}
	
	filter::set_filter_vision_pulse_constant( self, 3, 7, 0 );
	self thread disableShader( localClientNum, 4000 / 1000 );
}

function vision_pulse_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{		
	if ( newVal )
	{
		if( self == GetLocalPlayer( localClientNum ) )
		{
			self thread do_vision_world_pulse( localClientNum );
		}
	}
}

function set_reveal_enemy( on_off )
{
	self duplicate_render::set_dr_flag( "reveal_enemy", on_off );
	self duplicate_render::update_dr_filters();
}

function set_reveal_self( local_client_num, on_off )
{
	if( on_off && ( self == GetLocalPlayer( local_client_num ) ) )
	{
		self thread do_vision_local_pulse( local_client_num );
	}
	else if( !on_off )
	{
		filter::set_filter_vision_pulse_constant( self, 3, 7, 0 );
	}
}

function gadget_visionpulse_reveal(local_client_num, bReveal)
{
	self notify( "gadget_visionpulse_changed" );
	
	player = GetLocalPlayer( local_client_num );
	player motionpulse_enable( true );
	if( !isDefined( self.visionPulseRevealSelf ) && player == self )
	{
		self.visionPulseRevealSelf = false;
	}
	
	if( !isDefined( self.visionPulseReveal ) )
	{
		self.visionPulseReveal = false;
	}
	
	if(player == self)
	{
		if ( self.visionPulseRevealSelf != bReveal )
		{
			self.visionPulseRevealSelf = bReveal;
			self set_reveal_self( local_client_num, bReveal );
		}
	}
	else
	{
		if ( self.visionPulseReveal != bReveal )
		{
			self.visionPulseReveal = bReveal;
			self set_reveal_enemy( bReveal );
		}
	}
}