#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "player/fx_plyr_breath_steam_1p" );
#precache( "client_fx", "player/fx_plyr_breath_steam_3p" );

#namespace util;

function set_streamer_hint_function( func, number_of_zones )
{
	level.func_streamer_hint = func;
	clientfield::register( "world", "force_streamer", 1, GetMinBitCountForNum( number_of_zones ), "int", &_force_streamer, !true, !true );
}

function _force_streamer( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJumpid )
{
	if ( newVal == 0 )
	{
		StopForcingStreamer();
	}
	else
	{
		[[ level.func_streamer_hint ]]( newVal );
		
		level util::waittill_notify_or_timeout( "streamer_100", 15 );
		StreamerNotify( newVal );
	}
}

/@
"Name: init_breath_fx()"
"Summary: will need to init fx in the main level init to use so clienfields get registered."
"CallOn: Level"
"Example: util::init_breath_fx();"
@/
function init_breath_fx()
{
	level.cold_breath = [];

	level._effect[ "player_cold_breath" ] = "player/fx_plyr_breath_steam_1p";
	level._effect[ "ai_cold_breath" ] = "player/fx_plyr_breath_steam_3p";	
	
	clientfield::register( "toplayer", "player_cold_breath", 1, 1, "int", &handle_cold_breath, !true, !true );
	clientfield::register( "actor", "ai_cold_breath", 1, 1, "counter", &handle_ai_breath, !true, !true );
}

function handle_cold_breath(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( newVal == 1 )
	{
		if( ( isdefined( level.cold_breath[localClientNum] ) && level.cold_breath[localClientNum] ) )
		{
			return;
		}		
		
		level.cold_breath[localClientNum] = true;
		self thread player_breath_1p( localClientNum );
	}
	else
	{
		level.cold_breath[localClientNum] = false;
	}			
}

function player_breath_1p( localClientNum )
{
	self endon( "disconnect" );
	self endon( "entityshutdown" );
	self endon( "death" );
	
	//One-shot breathing effect that needs to loop
	while( ( isdefined( level.cold_breath[localClientNum] ) && level.cold_breath[localClientNum] ) )
	{
		wait RandomIntRange(5, 7);
		PlayFXOnCamera( localClientNum, level._effect[ "player_cold_breath"],  (0,0,0), (1,0,0), (0,0,1) );
	}
}

function handle_ai_breath( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon( "entityshutdown" );
	self endon( "death" );
	
	//One-shot breathing effect that needs to loop
	while( IsAlive( self  ) )
	{
		wait RandomIntRange(6, 8);
		PlayFXOnTag(localClientNum, level._effect[ "ai_cold_breath" ], self, "j_head" );
	}
}