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
		
		duplicate_render::set_dr_filter_offscreen( "reveal_en", 50, "reveal_enemy", undefined, 2, "mc/hud_outline_model_z_red", 1  );
		duplicate_render::set_dr_filter_offscreen( "reveal_self", 50, "reveal_self", undefined, 2, "mc/hud_outline_model_z_red_alpha", 1  );
	}
	
	clientfield::register( "toplayer", "vision_pulse_active", 1, 1, "int", &vision_pulse_changed, !true, true );
	visionset_mgr::register_visionset_info( "vision_pulse", 1, 12, undefined, "vision_puls_bw" );
}


function on_player_spawned( localClientNum )
{
	if( self == GetLocalPlayer( localClientNum ) )
	{
		filter::init_filter_vision_pulse( self );
	}
	if(!((self GetInKillcam(localClientNum)) && (GetLocalPlayer(localClientNum) == self)))
	{
		self gadgetpulseresetreveal();
		self set_reveal_self( localClientNum, false );
		self set_reveal_enemy( localClientNum, false );
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
	while( ( GetServerTime( localClientNum ) - starttime ) < 2000 )
	{
		elapsedTime = ( GetServerTime( localClientNum ) - starttime ) * 1.0;
		if( elapsedTime < ( 2000 * .3 ) )
		{
			irisAmount = elapsedTime / ( 2000 * .3 );
		}
		else if( elapsedTime < ( 2000 * .3 ) )
		{
			irisAmount = 1.0 - elapsedTime / ( 2000 * .3 );
		}
		else
		{
			irisAmount = 0.0;
		}
		amount = 1.0 -  elapsedTime / 2000;
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
	
	self notify( "startLocalPulse" );
	self endon( "startLocalPulse" );
	
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
		if( (GetServerTime( localClientNum ) - starttime ) < 2000 )
		{
			pulseRadius = ( (GetServerTime( localClientNum ) - starttime ) / 2000) * 2000;
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

function do_reveal_enemy_pulse( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "death" );
	
	self notify( "startEnemyPulse" );
	self endon( "startEnemyPulse" );
	startTime = GetServerTime( localClientNum );
	currTime = startTime;
		
	self MapShaderConstant( localclientnum, 0, "scriptVector7", 0.0, 0, 0, 0 );
	while( ( currTime - starttime ) < 4000 )
	{
		if( ( currTime - starttime ) > ( 4000 - 500 ) )
		{
			value = float( ( currTime - starttime - ( 4000 - 500 ) ) / 500 );
			self MapShaderConstant( localclientnum, 0, "scriptVector7", value, 0, 0, 0 );
		}

		{wait(.016);};
		currTime = GetServerTime( localClientNum );
	}
}

function set_reveal_enemy( localClientNum, on_off )
{
	if( on_off )
	{
		self thread do_reveal_enemy_pulse( localClientNum );
	}
	self duplicate_render::update_dr_flag( "reveal_enemy", on_off );
}

function set_reveal_self( localClientNum, on_off )
{
	if( on_off && ( self == GetLocalPlayer( localClientNum ) ) )
	{
		self thread do_vision_local_pulse( localClientNum );
	}
	else if( !on_off )
	{
		filter::set_filter_vision_pulse_constant( self, 3, 7, 0 );
	}
}

function gadget_visionpulse_reveal(localClientNum, bReveal)
{
	self notify( "gadget_visionpulse_changed" );
	
	player = GetLocalPlayer( localClientNum );
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
		self.visionPulseRevealSelf = bReveal;
		self set_reveal_self( localClientNum, bReveal );
	}
	else
	{
		if ( self.visionPulseReveal != bReveal )
		{
			self.visionPulseReveal = bReveal;
			self set_reveal_enemy( localClientNum, bReveal );
		}
	}
}