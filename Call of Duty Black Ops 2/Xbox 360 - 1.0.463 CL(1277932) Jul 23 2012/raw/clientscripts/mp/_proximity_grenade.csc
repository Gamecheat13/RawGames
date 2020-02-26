// _proximity_grenade.csc 
// Sets up clientside behavior for the proximity grenade
#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

#define TASER_MINE_ZAP_COUNT			   3
#define TASER_MINE_ZAP_CYCLE_COUNT	 2
#define TASER_MINE_ZAP_PERIOD_SECONDS	0.25

main()
{
	level._effect["prox_grenade_friendly_default"] = loadfx( "weapon/grenade/fx_prox_grenade_scan_grn" );
	level._effect["prox_grenade_friendly_warning"] = loadfx( "weapon/grenade/fx_prox_grenade_wrn_grn" );

	level._effect["prox_grenade_enemy_default"] = loadfx( "weapon/grenade/fx_prox_grenade_scan_red" );
	level._effect["prox_grenade_enemy_warning"] = loadfx( "weapon/grenade/fx_prox_grenade_wrn_red" );

	level._effect["prox_grenade_player_shock"] = loadfx( "weapon/grenade/fx_prox_grenade_impact_player_spwner" );
}

spawned( localClientNum )
{	
	self thread playFlareFX( localClientNum );
	self thread checkForPlayerSwitch( localClientNum );
}

playFlareFX( localClientNum )
{
	self endon( "entityshutdown" );
	level endon( "player_switch" );
	
	if ( friendNotFoe(localClientNum) )
		self.proxyIdleFX = PlayFXOnTag( localClientNum, level._effect["prox_grenade_friendly_default"], self, "tag_fx" );
	else
		self.proxyIdleFX = PlayFXOnTag( localClientNum, level._effect["prox_grenade_enemy_default"], self, "tag_fx" );

	self thread watchProxyShutdown( localClientNum, self.proxyIdleFX );
}

watchProxyShutdown( localClientNum, fxHandle )
{
	msg = self waittill_any_return( "entityshutdown", "team_changed" );
	StopFX( localClientNum, fxHandle );

	if ( msg == "team_changed" )
	{
		self thread playFlareFX( localClientNum );
	}
}

checkForPlayerSwitch( localClientNum )
{
	self endon( "entityshutdown" );
	
	while ( true )
	{
		level waittill( "player_switch" );

		if ( isDefined( self.proxyIdleFX ) )
		{
			stopFx( localClientNum, self.proxyIdleFX );
			self.proxyIdleFX = undefined;
		}
	
		waittillframeend;
		
		self thread playFlareFX( localClientNum );
	}
}

taserHUDFX( localClientNum, grenadeEnt, position ) // self == localPlayer
{
	self endon("entityshutdown");
	level endon( "respawn" );
	grenadeEnt endon("entityshutdown");

	trace = bulletTrace( GetLocalClientEyePos( localClientNum ), position, false, self );

	if ( trace["fraction"] >= 1 )
	{
		if ( self HasPerk(localClientNum, "specialty_proximityprotection") )
		{
			self thread reducedShock(localClientNum, grenadeEnt, position);
		}
		else
		{
			self thread flickerVisionSet( localClientNum, 0.03, (TASER_MINE_ZAP_PERIOD_SECONDS * 5), 0.0 );
			cycles = TASER_MINE_ZAP_COUNT;

			for( i=0; i<TASER_MINE_ZAP_CYCLE_COUNT; i++ )
			{
				zap_wait = TASER_MINE_ZAP_PERIOD_SECONDS;

				for ( j=0; j<cycles; j++ )
				{
					menuname = "fullscreen_proximity";

					forwardVec = VectorNormalize( AnglesToForward( self.angles ) );
					rightVec = VectorNormalize( AnglesToRight( self.angles ) );
					explosionVec = VectorNormalize( position - self.origin );
					
					fDot = VectorDot( explosionVec, forwardVec );
					rDot = VectorDot( explosionVec, rightVec );

					if ( abs(fDot) > abs(rDot) )
					{
						if ( fDot > 0 )
						{
							menustate = "proximity_vertical_top"+j;
						}
						else
						{
							menustate = "proximity_vertical_bottom"+j;
						}
					}
					else
					{
						if ( rDot > 0 )
						{
							menustate = "proximity_horizontal_right"+j;
						}
						else
						{
							menustate = "proximity_horizontal_left"+j;
						}
					}

					AnimateUI( localClientNum, menuName, menustate, "in", 0 );

					wait zap_wait;
					zap_wait /= 2;
				}
				wait .2;
				cycles--;
			}
		}
	}
}

reducedShock(localClientNum, grenadeEnt, position)
{
	self endon("entityshutdown");
	grenadeEnt endon("entityshutdown");
	level endon( "respawn" );
	menuname = "fullscreen_proximity";
	
	self thread flickerVisionSet( localClientNum, .03, .15, 0.0 );
	
	//Eckert - Playing reduced shock sound
	self playsound (0, "wpn_taser_mine_tacmask");
	
	forwardVec = VectorNormalize( AnglesToForward( self.angles ) );
	rightVec = VectorNormalize( AnglesToRight( self.angles ) );
	explosionVec = VectorNormalize( position - self.origin );
					
	fDot = VectorDot( explosionVec, forwardVec );
	rDot = VectorDot( explosionVec, rightVec );

	if ( abs(fDot) > abs(rDot) )
	{
		if ( fDot > 0 )
		{
			menustate = "proximity_vertical_top0";
		}
		else
		{
			menustate = "proximity_vertical_bottom0";
		}
	}
	else
	{
		if ( rDot > 0 )
		{
			menustate = "proximity_horizontal_right0";
		}
		else
		{
			menustate = "proximity_horizontal_left0";
		}
	}

	AnimateUI( localClientNum, menuName, menustate, "in", 0 );
}


flickerVisionSet( localClientNum, period, duration_seconds, transition )
{
	level endon( "respawn" );
	flicker_start_time = GetRealTime();
	saved_vision = GetVisionSetNaked( localClientNum );
	toggle = true;

	duration_ms = duration_seconds * 1000;
	wait .1;

	while( true )
	{
		if ( GetRealTime() > ( flicker_start_time + duration_ms ))
		{
			break;
		}

		if ( toggle )
		{
			visionsetnaked( localClientNum, "taser_mine_shock", transition );
		}
		else
		{
			visionsetnaked( localClientNum, saved_vision, transition );
		}
		toggle = !toggle;

		wait period;
	}

	visionSetNaked( localClientNum, saved_vision, transition );
}

visionSetToggle( localClientNum, toggle )
{
	DURATION = 0.05;

	if ( toggle )
	{
		visionsetnaked( localClientNum, "taser_mine_shock", DURATION );
	}
	else
	{
		visionSetNaked( localClientNum, GetDvar( "mapname" ), DURATION );
	}

	return (!toggle);
}