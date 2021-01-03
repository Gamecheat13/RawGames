#using scripts\codescripts\struct;

#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "_t6/misc/fx_equip_tac_insert_light_grn" );
#precache( "client_fx", "_t6/misc/fx_equip_tac_insert_light_red" );

#namespace tacticalinsertion;

function init_shared()
{
	level._effect["tacticalInsertionFriendly"] = "_t6/misc/fx_equip_tac_insert_light_grn";
	level._effect["tacticalInsertionEnemy"] = "_t6/misc/fx_equip_tac_insert_light_red";

	clientfield::register( "scriptmover", "tacticalinsertion", 1, 1, "int", &spawned, !true, !true );

// Set the map's latitude and longitude
	latLongStruct = struct::get( "lat_long", "targetname" );
	if ( isdefined( latLongStruct ) )
	{
		mapX = latLongStruct.origin[0];
		mapY = latLongStruct.origin[1];
		Lat  = latLongStruct.script_vector[0];
		Long = latLongStruct.script_vector[1];
	}
	else
	{
		if ( isdefined( level.worldMapX ) && isdefined( level.worldMapY ) )
		{
			mapX = level.worldMapX;
			mapY = level.worldMapY;
		}
		else
		{
			mapX = 0.0;
			mapY = 0.0;
		}

		if ( isdefined( level.worldLat ) && isdefined( level.worldLong ) )
		{
			Lat  = level.worldLat;
			Long = level.worldLong;
		}
		else
		{
			// default is Treyarch's:
			Lat  = 34.021566;
			Long = -118.448689;
		}
	}

	SetMapLatLong( mapX, mapY, Long, Lat );
}

function spawned( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	if ( !newVal )
		return;
		
	self thread playFlareFX( localClientNum );
	self thread checkForPlayerSwitch( localClientNum );
}

function playFlareFX( localClientNum )
{
	self endon( "entityshutdown" );
	level endon( "player_switch" );
	
	if ( util::friend_not_foe(localClientNum) )
	{
		self.tacticalInsertionFX = PlayFXOnTag( localClientNum, level._effect["tacticalInsertionFriendly"], self, "tag_flash" );
	}
	else
	{
		self.tacticalInsertionFX = PlayFXOnTag( localClientNum, level._effect["tacticalInsertionEnemy"], self, "tag_flash" );
	}

	self thread watchTacInsertShutdown( localClientNum, self.tacticalInsertionFX );
	
	loopOrigin = self.origin;
	audio::playloopat( "fly_tinsert_beep", loopOrigin);
	
	self thread stopflareloopWatcher( loopOrigin );

}

function watchTacInsertShutdown( localClientNum, fxHandle )
{
	self waittill( "entityshutdown" );
	StopFX( localClientNum, fxHandle );
}

function stopflareloopWatcher( loopOrigin )
{
	while (1)
	{
		if (!isdefined( self ) || !isdefined( self.tacticalInsertionFX ) )
		{
			audio::stoploopat ( "fly_tinsert_beep", loopOrigin);
			//self notify ("stoppedLoop");
			break;
		}
		
		wait .5;
	}
}

function checkForPlayerSwitch( localClientNum )
{
	self endon( "entityshutdown" );
	
	while ( true )
	{
		level waittill( "player_switch" );

		if ( isdefined( self.tacticalInsertionFX ) )
		{
			stopFx( localClientNum, self.tacticalInsertionFX );
			self.tacticalInsertionFX = undefined;
		}
	
		waittillframeend;
		
		self thread playFlareFX( localClientNum );
	}
}