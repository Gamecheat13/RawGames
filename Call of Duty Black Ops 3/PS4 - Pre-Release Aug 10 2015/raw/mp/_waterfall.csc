#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\water_surface;

#using scripts\mp\_load;
#using scripts\mp\_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace waterfall;

function waterfallOverlay( localClientNum )
{
	triggers = GetEntArray( localClientNum, "waterfall", "targetname" );
	foreach( trigger in triggers )
	{
		trigger thread setupWaterfall( localClientNum );
	}
}

function waterfallMistOverlay( localClientNum )
{
	triggers = GetEntArray( localClientNum, "waterfall_mist", "targetname" );
	foreach( trigger in triggers )
	{
		trigger thread setupWaterfallMist( localClientNum );
	}
}

function waterfallMistOverlayReset( localClientNum )
{
	localPlayer = GetLocalPlayer( localClientNum );
	localPlayer.rainOpacity = 0.0;
}

function setupWaterfallMist( localClientNum )
{
	trigger = self;
	for(;;)
	{
		trigger waittill( "trigger", trigPlayer );
		
		if( trigPlayer != GetLocalPlayer( localClientNum ) )
		{
			continue;
		}
		
		filter::init_filter_sprite_rain( trigPlayer );
		trigger thread trigger::function_thread( trigPlayer, &trig_enter_waterfall_mist, &trig_leave_waterfall_mist );
	}
}

function setupWaterfall( localClientNum )
{
	trigger = self;
	for(;;)
	{
		trigger waittill( "trigger", trigPlayer );
		
		if ( trigPlayer islocalplayer() == false )
		{
			continue;
		}
		
		trigger thread trigger::function_thread( trigPlayer, &trig_enter_waterfall, &trig_leave_waterfall );	
	}
}

function trig_enter_waterfall( ent )
{
	trigger = self;
	localClientNum = trigger.localClientNum;
	ent thread postfx::PlayPostfxBundle( "pstfx_waterfall" );

	while ( trigger istouching( ent ) )
	{
		ent PlayRumbleOnEntity( localClientNum, "waterfall_rumble" );
		
		playsound (0, "amb_waterfall_hit", (0,0,0));
		
		wait( 0.1 );
	}
}

function trig_leave_waterfall( ent )
{
	trigger = self;
	localClientNum = trigger.localClientNum;
	ent postfx::StopPostfxBundle();
	if ( IsUnderwater( localClientNum ) == false )
	{
		ent thread water_surface::startWaterSheeting();
	}
}

function trig_enter_waterfall_mist( localPlayer )
{
	localPlayer endon( "entityshutdown" );
	trigger = self;
	
	if ( !isdefined( localPlayer.rainOpacity ) )
		localPlayer.rainOpacity = 0;
	
	if ( localPlayer.rainOpacity == 0 )
	{
		filter::set_filter_sprite_rain_seed_offset( localPlayer, 0, RandomFloat( 1 ) );
	}

	filter::enable_filter_sprite_rain( localPlayer, 0 );
	while ( trigger istouching( localPlayer ) )
	{
		localClientNum = trigger.localClientNum;
		if ( !isdefined( localClientNum ) )
		{
			localClientNum = localPlayer getlocalclientnumber();
		}
		if ( IsUnderwater( localClientNum ) )
		{
			filter::disable_filter_sprite_rain( localPlayer, 0 );
			break;
		}
		
		localPlayer.rainOpacity += 0.003;
		if ( localPlayer.rainOpacity > 1 )
		{
			localPlayer.rainOpacity = 1;
		}
		filter::set_filter_sprite_rain_opacity( localPlayer, 0, localPlayer.rainOpacity );
		filter::set_filter_sprite_rain_elapsed( localPlayer, 0, localPlayer getClientTime() );
		
		{wait(.016);};
	}
	
}

function trig_leave_waterfall_mist( localPlayer )
{	
	localPlayer endon( "entityshutdown" );
	trigger = self;
	
	if ( isdefined( localPlayer.rainOpacity ) )
	{
		while ( !( trigger istouching( localPlayer ) ) && localPlayer.rainOpacity > 0.0 )
		{
			localClientNum = trigger.localClientNum;
			if ( IsUnderwater( localClientNum ) )
			{
				filter::disable_filter_sprite_rain( localPlayer, 0 );
				break;
			}
			
			localPlayer.rainOpacity -= 0.005;
			filter::set_filter_sprite_rain_opacity( localPlayer, 0, localPlayer.rainOpacity );
			filter::set_filter_sprite_rain_elapsed( localPlayer, 0, localPlayer getClientTime() );
			{wait(.016);};
		}
	}
	
	localPlayer.rainOpacity = 0;
	filter::disable_filter_sprite_rain( localPlayer, 0 );
}
