#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_flashgrenades;

                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       





#namespace hacker_tool;

function init_shared()
{	
	clientfield::register( "toplayer", "hacker_tool", 1, 2, "int", &player_hacking, !true, !true );
	level.hackingSoundId = [];
	level.hackingSweetSpotId = [];
	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned( localClientNum )
{
	player = self;
	if ( player islocalplayer() == false )
	{
		return;
	}
	
	if ( isdefined( level.hackingSoundId[localclientnum] ) )
	{
		player stopLoopSound( level.hackingSoundId[localclientnum] );
		level.hackingSoundId[localclientnum] = undefined;
	}
	if ( isdefined( level.hackingSweetSpotId[localclientnum] ) )
	{
		player stopLoopSound(level.hackingSweetSpotId[localclientnum] );
		level.hackingSweetSpotId[localclientnum] = undefined;
	}
}


function player_hacking( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self notify( "player_hacking_callback" );
	player = self;
	if ( isdefined( level.hackingSoundId[localclientnum] ) )
	{
		player stopLoopSound( level.hackingSoundId[localclientnum] );
		level.hackingSoundId[localclientnum] = undefined;
	}
	if ( isdefined( level.hackingSweetSpotId[localclientnum] ) )
	{
		player stopLoopSound(level.hackingSweetSpotId[localclientnum] );
		level.hackingSweetSpotId[localclientnum] = undefined;
	}
	if ( isdefined( player.targetEnt ) )
	{
		player.targetEnt duplicate_render::set_hacker_tool_hacking( false );
		player.targetEnt duplicate_render::set_hacker_tool_breaching( false );
		player.targetEnt.isbreachingfirewall = false;
		player.targetEnt = undefined;
	}

	if ( newVal == 2 )
	{
		player thread watchHackSpeed( localClientNum, false );
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.blackhat.status" ), 2 );
	}
	else if ( newVal == 3 )
	{
		player thread watchHackSpeed( localClientNum, true );
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.blackhat.status" ), 1 );
	}
	else if ( newVal == 1 )
	{	
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.blackhat.status" ), 0 );
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.blackhat.perc" ), 0 );
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.blackhat.offsetShaderValue" ), 0  + " " + 0 + " 0 0" );	
		self thread watchForEMP( localClientNum );
	}
	else
	{
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.blackhat.status" ), 0 );
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.blackhat.perc" ), 0 );
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.blackhat.offsetShaderValue" ), 0  + " " + 0 + " 0 0" );
	}
}


function watchHackSpeed( localClientNum, isBreachingFirewall )
{
	self endon( "entityshutdown" );
	self endon( "player_hacking_callback" );
	player = self;

	for ( ;; )
	{
		targetEntArray = self GetTargetLockEntityArray(); 
		if ( targetEntArray.size > 0 )
		{
			targetEnt = targetEntArray[0];
			break;
		}
		wait ( 0.02 );
	}
	targetEnt watchTargetHack( localclientNum, player, isBreachingFirewall );
}

function watchTargetHack( localclientnum, player, isBreachingFirewall )
{
	self endon( "entityshutdown" );
	player endon( "entityshutdown" );
	self endon( "player_hacking_callback" );
	
	targetEnt = self;
	player.targetEnt = targetEnt;
	if ( isBreachingFirewall )
	{
		targetEnt.isbreachingfirewall = true;
		targetEnt duplicate_render::set_hacker_tool_breaching( true );
	}

	targetEnt thread watchHackerPlayerShutdown( player, targetEnt );
	
	for( ;; )
	{
		distanceFromCenter = targetent getDistanceFromScreenCenter( localClientNum );
		inverse = 50 - distancefromcenter;
		ratio = inverse / 50;
		heatVal = GetWeaponHackRatio( localclientnum );
		if ( ratio > 1.0 || ratio < 0 ) 
		{
			ratio = 0;
			horizontal = 0;
		}
		else
		{
			horizontal = targetent getHorizontalOffsetFromScreenCenter( localClientNum, 50 );
		}

		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.blackhat.offsetShaderValue" ), horizontal + " " + ratio + " 0 0" );
		
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.blackhat.perc" ), heatVal );
		
		if ( ratio > 0.625 )
		{
			if ( !isdefined( level.hackingSweetSpotId[localclientnum] ) ) 
			{
				level.hackingSweetSpotId[localclientnum] = player playloopsound( "evt_hacker_hacking_sweet" );
			}
		}
		else
		{
			if ( isdefined( level.hackingSweetSpotId[localclientnum] ) ) 
			{
				player stopLoopSound( level.hackingSweetSpotId[localclientnum] );
				level.hackingSweetSpotId[localclientnum] = undefined;
			}
			if ( !isdefined( level.hackingSoundId[localclientnum] ) )
			{
				level.hackingSoundId[localclientnum] = player playloopsound( "evt_hacker_hacking_loop" );
			}
			if ( isdefined( level.hackingSoundId[localclientnum] ) )
			{
				setSoundPitch( level.hackingSoundId[localclientnum], ratio );
			}
		}

		wait ( 0.1 );
	}
}

function watchHackerPlayerShutdown( hackerPlayer, targetEnt )
{
	self endon( "entityshutdown" );
	killstreakEntity = self;
	hackerPlayer endon( "player_hacking_callback" );
		
	hackerPlayer waittill( "entityshutdown" );
	
	if ( isdefined( targetEnt ) )
	{
		targetEnt.isbreachingfirewall = true;
	}
	killstreakEntity duplicate_render::set_hacker_tool_hacking( false );
	killstreakEntity duplicate_render::set_hacker_tool_breaching( false );
}


function watchForEMP( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "player_hacking_callback" );
	
	while ( 1 ) 
	{
		if ( self IsEMPJammed() )
		{
			SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.blackhat.status" ), 3 );
		}
		else 
		{
			SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "hudItems.blackhat.status" ), 0 );
		}
		wait( 0.1 );
	}
	
}
