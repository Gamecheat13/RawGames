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

setupFX( localClientNum )
{
	friend = self friendNotFoe( localClientNum );
	
	if ( !friend )
	{
		self.fxDefault = level._effect["prox_grenade_enemy_default"];
		self.fxWhenActivated = level._effect["prox_grenade_enemy_warning"];
	}
	else
	{
		self.fxDefault = level._effect["prox_grenade_friendly_default"];
		self.fxWhenActivated = level._effect["prox_grenade_friendly_warning"];
	}	
}

spawned( localClientNum ) // self == the grenade
{
	self endon( "entityshutdown" );
		
	self setupFX( localClientNum );
	self thread proximityGrenadeFxDefault( localClientNum );
	
	self thread checkForActivation();
	self thread checkForPlayerSwitch( localClientNum );
	//self thread proximityGrenadeFxActivated( localClientNum );
}

checkForActivation()
{
	self endon( "entityshutdown" );

	while( 1 )
	{
		if ( isDefined( self.enemyInProximity ) && self.enemyInProximity )
			self notify( "ent_in_proximity" );

		wait( 0.5 );
	}
}

checkForPlayerSwitch( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "ent_in_proximity" );
	
	while ( true )
	{
		level waittill( "player_switch" );

		if ( isDefined( self.proximityGrenadeFx ) )
		{
			stopFx( localClientNum, self.proximityGrenadeFx );
			self.proximityGrenadeFx = undefined;
		}
	
		waittillframeend;
		
		self setupFX( localClientNum );
		self proximityGrenadeFxDefault( localClientNum );
	}
}

proximityGrenadeFxDefault( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "ent_in_proximity" );
	
	if( isDefined( self.fxDefault ) )
	{
		self.proximityGrenadeFx = PlayFXOnTag( localClientNum, self.fxDefault, self, "tag_fx" );
	}	
}

proximityGrenadeFxActivated( localClientNum )
{
	self endon( "entityshutdown" );
	self waittill( "ent_in_proximity" );

	if ( isDefined( self.proximityGrenadeFx ) )
	{
		stopfx( localClientNum, self.proximityGrenadeFx );
		self.proximityGrenadeFx = undefined;
	}

	if( isDefined( self.fxWhenActivated ) )
	{
		PlayFXOnTag( localClientNum, self.fxWhenActivated, self, "tag_fx" );
		self playsound( 0, "wpn_pgrenade_alarm" );
	}
}



taserHUDFX( localClientNum, grenadeEnt, position ) // self == localPlayer
{
	self endon("entityshutdown");
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