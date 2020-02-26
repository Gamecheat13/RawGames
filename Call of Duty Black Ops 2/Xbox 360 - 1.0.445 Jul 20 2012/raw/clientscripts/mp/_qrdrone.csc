// _qrdrone.csc
// Sets up clientside behavior for the qrdrone

#include clientscripts\mp\_vehicle;
#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

#insert raw\maps\mp\_clientflags.gsh;

#define UAV_REMOTE_MAX_PAST_RANGE 200
#define UAV_REMOTE_MIN_HELI_PROXIMITY 150
#define UAV_REMOTE_MAX_HELI_PROXIMITY 300

main()
{
	type = "qrdrone_mp";
	
	level._effect["qrdrone_enemy_light"] = loadfx( "weapon/qr_drone/fx_qr_light_red_3p" );
	level._effect["qrdrone_friendly_light"] = loadfx( "weapon/qr_drone/fx_qr_light_green_3p" );
	level._effect["qrdrone_viewmodel_light"] = loadfx( "weapon/qr_drone/fx_qr_light_green_1p" );
	level._effect["qrdrone_enemy_light_blink"] = loadfx( "vehicle/light/fx_rcbomb_light_red_os" );
	level._effect["qrdrone_friendly_light_blink"] = loadfx( "vehicle/light/fx_rcbomb_light_green_os" );

	// vehicle flags	
	level._client_flag_callbacks["helicopter"][CLIENT_FLAG_COUNTDOWN] = ::start_blink;
	level._client_flag_callbacks["helicopter"][CLIENT_FLAG_TIMEOUT] = ::final_blink;
	
}

spawned(localClientNum)
{
	self spawn_solid_fx(localClientNum);
	self thread blink_light(localClientNum);
	self thread cleanup_light(localClientNum);
	self thread collisionHandler(localClientNum);
	self thread check_for_player_switch_or_time_jump(localClientNum);
	self thread engineStutterHandler(localClientNum);
	self thread QRDrone_watch_distance();
}

spawn_solid_fx( localClientNum )
{
	self.spawnTime = level.serverTime;
	
	if ( IsDefined( self.lightFXID ) )
	{
		stopfx(localClientNum,self.lightFXID);
		self.lightFXID = undefined;
	}
	
	if ( self IsLocalClientDriver( localClientNum ) )
	{
		self.lightFXID = playfxontag( localClientNum, level._effect["qrdrone_viewmodel_light"], self, "tag_body" );		
	}
	else if ( self friendNotFoe( localClientNum ) )
	{
		self.lightFXID = playfxontag( localClientNum, level._effect["qrdrone_friendly_light"], self, "tag_body" );
	}
	else
	{
		self.lightFXID = playfxontag( localClientNum, level._effect["qrdrone_enemy_light"], self, "tag_body" );
	}
}

start_blink(localClientNum, set)
{
	if (!set)
		return;
		
	self notify("blink");
}

// this second state is necessary so killcams show the appropriate "fast blink" state
final_blink(localClientNum, set)
{
	if (!set)
		return;
	
	self.interval = .133;
}

loop_local_sound( localClientNum, alias, interval, fx )
{
	self endon( "entityshutdown" );
	self endon( "stop all effects" );
	level endon( "qrdrone_blowup" );
	level endon( "demo_jump" );
	level endon( "player_switch" );
	// also playing the blinking light fx with the sound

	if ( !IsDefined( self.interval ) )
	{
		self.interval = interval;
	}
	
	while(1)
	{
		self PlaySound( localClientNum, alias );
		//PlayFXOnTag( localClientNum, fx, self, "tag_turret" );
		
		self.lightFXID = playfxontag( localClientNum, fx, self, "tag_body" );
		serverwait( localClientNum, self.interval / 2);
		stopfx(localClientNum,self.lightFXID);
		self.lightFXID = undefined;
		
		serverWait( localClientNum, self.interval / 2);
		self.interval = (self.interval / 1.17);

		if (self.interval < .1)
		{
			self.interval = .1;
		}	
	}
}

check_for_player_switch_or_time_jump( localClientNum )
{
	self endon("entityshutdown");
	level waittill_any( "demo_jump", "player_switch" );
	
	waittillframeend;

	self thread blink_light( localClientNum );
	
	if ( isDefined( self.blinkStartTime ) && self.blinkStartTime <= level.serverTime )
	{
		self.interval = 1;
		self thread start_blink( localClientNum, true );
	}
	else
	{
		self spawn_solid_fx( localClientNum );
	}
	
	self thread check_for_player_switch_or_time_jump( localClientNum );
}

blink_light(localClientNum)
{
	self endon("entityshutdown");
	level endon( "demo_jump" );
	level endon( "player_switch" );
	self waittill("blink");
	
	if ( IsDefined( self.lightFXID ) )
	{
		stopfx(localClientNum,self.lightFXID);
		self.lightFXID = undefined;
	}
	
	if ( !isDefined( self.blinkStartTime ) )
	{
		self.blinkStartTime = level.serverTime;
	}	

	localPlayers = level.localPlayers;
	for ( localClientIndex = 0 ; localClientIndex < localPlayers.size ; localClientIndex++ )
	{
		player = localPlayers[localClientIndex];
		if ( self IsLocalClientDriver( localClientNum ) )
		{
			self thread loop_local_sound( localClientNum, "wpn_crossbow_alert", 1, level._effect["qrdrone_viewmodel_light"] );
		}
		else if ( self friendNotFoe( localClientIndex ) )
		{
			self thread loop_local_sound( localClientNum, "wpn_crossbow_alert", 1, level._effect["qrdrone_friendly_light"] );
		}
		else
		{
			self thread loop_local_sound( localClientNum, "wpn_crossbow_alert", 1, level._effect["qrdrone_enemy_light"] );
		}
	}
}

cleanup_light(localClientNum)
{
	self endon("entityshutdown");
	self waittill("hidden");
	self notify("stop all effects");
	if ( IsDefined( self.lightFXID ) )
	{
		stopfx(localClientNum,self.lightFXID);
		self.lightFXID = undefined;
	}
}

collisionHandler( localClientNum )
{
	self endon( "entityshutdown" );
	
	while( 1 )
	{
		self waittill( "veh_collision", hip, hitn, hit_intensity );

		driver_local_client = self GetLocalClientDriver();
		
		if( IsDefined( driver_local_client ) )
		{
			//println( "veh_collision " + hit_intensity );
			player = getlocalplayer( driver_local_client );

			if( IsDefined( player ) )
			{
				// todo - play sound here also
				if( hit_intensity > 15 )
				{
					player PlayRumbleOnEntity( driver_local_client, "damage_heavy" );
				}
				else
				{
					player PlayRumbleOnEntity( driver_local_client, "damage_light" );
				}
			}
		}
	}
}

engineStutterHandler( localClientNum )
{
	self endon( "entityshutdown" );
	
	while( 1 )
	{
		self waittill( "veh_engine_stutter" );
		if ( self IsLocalClientDriver( localClientNum ) )
		{
			player = getlocalplayer( localClientNum );
			
			if( IsDefined( player ) )
			{
				player PlayRumbleOnEntity( localClientNum, "rcbomb_engine_stutter" );
			}
		}
	}
}

getMinimumFlyHeight()
{	
	if ( !isdefined( level.airsupportHeightScale ) ) 
		level.airsupportHeightScale = 1;

	airsupport_height = getstruct( "air_support_height", "targetname");
	if ( IsDefined(airsupport_height) )
	{
		planeFlyHeight = airsupport_height.origin[2];
	}
	else
	{
/#
		PrintLn("WARNING:  Missing air_support_height entity in the map.  Using default height.");
#/
		// original system
		planeFlyHeight = 850;
	
		if ( isdefined( level.airsupportHeightScale ) )
		{
			level.airsupportHeightScale = GetDvarIntDefault( "scr_airsupportHeightScale", level.airsupportHeightScale );	
			planeFlyHeight *= GetDvarIntDefault( "scr_airsupportHeightScale", level.airsupportHeightScale );	
		}
		
		if ( isdefined( level.forceAirsupportMapHeight ) )
		{
			planeFlyHeight += level.forceAirsupportMapHeight;
		}	
	}
	
	return planeFlyHeight;
}

QRDrone_watch_distance()
{
	self endon ("entityshutdown" );
	
	qrdrone_height = getstruct( "qrdrone_height", "targetname");
	if ( IsDefined(qrdrone_height) )
	{
		self.maxHeight = qrdrone_height.origin[2];
	}
	else
	{
		self.maxHeight = int(getMinimumFlyHeight());
	}
	
	self.maxDistance = 12800;		
	
	level.mapCenter = GetMapCenter();
	
	self.minHeight = level.mapCenter[2] - 800;		

	//	shouldn't be possible to start out of range, but just in case
	inRangePos = self.origin;	

	soundent = spawn (0, self.origin, "script_origin" );
	soundent linkto(self);
	
	// end static on vehicle death
	self thread QRDrone_staticStopOnDeath( soundent );
	
	//	loop
	while ( true )
	{
		if ( !self QRDrone_in_range() )
		{
			//	increase static with distance from exit point or distance to heli in proximity
			staticAlpha = 0;		
			while ( !self QRDrone_in_range() )
			{	                        
				if ( isDefined( self.heliInProximity ) )
				{
					dist = distance( self.origin, self.heliInProximity.origin );
					staticAlpha = 1 - ( (dist-UAV_REMOTE_MIN_HELI_PROXIMITY) / (UAV_REMOTE_MAX_HELI_PROXIMITY-UAV_REMOTE_MIN_HELI_PROXIMITY) );
				}
				else
				{
					dist = distance( self.origin, inRangePos );
					staticAlpha = min( 1, dist/UAV_REMOTE_MAX_PAST_RANGE );	
				}

				
				// SOUND: put sound code here to change the volume of the static while the player is 
				// in static.  staticAlpha will be 0 - 1. 0 being no static, 1 being full static.

				
				sid = soundent playloopsound ( "veh_qrdrone_static_lp", .2 );	

				wait ( 0.05 );
			}
			
			
			//	fade out static
			self thread QRDrone_staticFade( staticAlpha, soundent, sid );
	
		}		
		inRangePos = self.origin;
		wait ( 0.05 );
	}
}


QRDrone_in_range()
{
	if ( self.origin[2] < self.maxHeight && self.origin[2] > self.minHeight )
	{
		if ( self isInsideHeightLock() )
		{
				return true;
		}
	}
	return false;
}


QRDrone_staticFade( staticAlpha, sndent, sid )
{
	self endon ( "entityshutdown" );
	while( self QRDrone_in_range() )
	{
		staticAlpha -= 0.05;
		if ( staticAlpha <= 0 )
		{
			// SOUND: Put call here to completely turn static sound off
			sndent stoploopsound (.5);
			//delete sid;
			break;
		}
		
		// SOUND:  Put call here to change volume of static based on staticAlpha
		setsoundvolumerate( sid, .6 );
		setsoundvolume( sid, staticAlpha );
	
			
		wait( 0.05 );
	}
}

QRDrone_staticStopOnDeath( sndent )
{
	self waittill ( "entityshutdown" );
	sndent stoploopsound (.1);
	sndent delete();
}
