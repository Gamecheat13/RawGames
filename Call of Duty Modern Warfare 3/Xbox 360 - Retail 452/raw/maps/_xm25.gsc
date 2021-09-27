#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;


init()
{
	precacheitem( "xm25" );
	PrecacheShader( "hud_xm25_temp" );
	//PrecacheShader( "hud_xm25_scanlines" );
	
	level.mine_explode = loadfx( "explosions/xm25_explosion" );
	level.contact_explode = loadfx( "explosions/xm25_explosion_surface" );

//	array_thread( level.players, :: ClearCLUTarget );

	//level.player thread xm25_monitor();
	if ( is_coop() )
		array_thread( level.players, ::xm25_monitor );
	else
		level.player thread xm25_monitor();
	
}


xm25_monitor()
{
	// proximity burst
	//self thread watchProximityAirBurstFire();
	// marker burst
//	self thread watchAirBurstDistanceMarkerUse();
	self thread watchAirBurstFire();
	self thread watchHoldBreath();
	self thread watchADS();
}

xm25_destroy_hud( hud )
{
	if(!IsDefined(hud))
		return;
		
	if ( IsDefined( hud.data_value ) )
	{
		hud.data_value Destroy();
	}

	if ( IsDefined( hud.data_value_suffix ) )
	{
		hud.data_value_suffix Destroy();
	}

	hud Destroy();
}

cleanup_ADS_at_death()
{
	self waittill( "death" );
    if(IsDefined(self.hud0))
		xm25_destroy_hud(self.hud0);
}

watchWeaponSwitch()
{
	self endon ( "death" );
	while (true)
	{
		self waittill("weapon_switch_started");
	    if(IsDefined(self.hud0))
			xm25_destroy_hud(self.hud0);
		if (!self.cg_drawBreathHint && ( self GetCurrentWeapon() != "xm25" ))
		{
			SetSavedDvar("cg_drawBreathHint", true );
			self.cg_drawBreathHint = true;
		}
		if ( self GetCurrentWeapon() == "xm25" )
			self.weapon_change_timer = 20;	// we are switching from the xm25, so wait
	}
}

watchADS()
{
	thread cleanup_ADS_at_death();
	self endon ( "death" );
	self.cg_drawBreathHint = true;
	self.weapon_change_timer = 0;
	self thread watchWeaponSwitch();

	for(;;)
	{
		newADSState = self AdsButtonPressed();
		curweapon = self GetCurrentWeapon();
		if (curweapon == "xm25")
		{	// manually disabling breath hint, since code will automatically give us a hint if we use a crosshairs without scope
			// note that this method shouldn't be used for MP/SO
			if (newADSState || (self PlayerAds() >= 0))
			{
				SetSavedDvar("cg_drawBreathHint", false );
				self.cg_drawBreathHint = false;
			}
			else
			{
				SetSavedDvar("cg_drawBreathHint", true );
				self.cg_drawBreathHint = true;
			}
		}
		if ( !newADSState || curweapon != "xm25" || self IsReloading())
		{	// destroy the temp hud.
		    if(IsDefined(self.hud0))
				xm25_destroy_hud(self.hud0);
		    //if(IsDefined(self.hud1))
			//	xm25_destroy_hud(self.hud1);
		}
		if ( curweapon == "xm25" && newADSState && 
			 self PlayerAds() >= .75 && !IsDefined(self.hud) && (self.weapon_change_timer <= 0) )
		{	// bring up the temp hud!
			if(!IsDefined(self.hud0))
				self.hud0 = create_hud_xm25_screen( 1, 1, self );
			//if(!IsDefined(self.hud1))
			//	self.hud1 = create_hud_xm25_scanlines( 1, 1 );
		}
		
		if(IsDefined(self.hud1))
		{
			self.hud1.y += 1;
			if(self.hud1.y > 8)
				self.hud1.y = -4;
		}
		self.weapon_change_timer--;
		if (self.weapon_change_timer == 0)
		{	// getting ammo from an ammo box initiates a weapon change to the same weapon, so ensure the breath draw is correct
			if ( curweapon == "xm25" )
			{
				SetSavedDvar("cg_drawBreathHint", false );
				self.cg_drawBreathHint = false;
			}
			else
			{
				SetSavedDvar("cg_drawBreathHint", true );
				self.cg_drawBreathHint = true;
			}
		}
		wait (.05);
	}
}


watchHoldBreath()
{
	self endon ( "death" );
	
	for (;;)
	{
		self notifyOnPlayerCommand( "holding_breath", "+breath" );
		self notifyOnPlayerCommand( "holding_breath", "+breath_sprint" );
		self notifyOnPlayerCommand( "holding_breath", "+melee_breath" );
		wait( .05 );	
	}
}

watchAirBurstFire()
{
	self endon("death");
	
	for(;;)
	{
		self waittill( "missile_fire", projectile, weaponName );
		
		if ( !isAirburstWeapon( weaponName ) )
			continue;
		
		if ( !isDefined( self.markedAirburstDistance ) || ( self.markedAirburstDistance < 50625 )) //min arming distance ^2
		{
			self thread proximityDetonateGrenade( projectile );	
		}
		else
		{
			distance = sqrt( self.markedAirburstDistance );
			forward = AnglesToForward( self GetPlayerAngles() );
			explodePoint = self GetEye() + forward * (distance + 64);
			
			if ( isDefined( self.markedAirburstDistance ) && self.markedAirburstDistance )
			{
				self thread detonateGrenadeAtDistance( distance, projectile, explodePoint, forward );	
			}
		}		
	}
}

detonateGrenadeAtDistance( distance, projectile, explodePoint, forward )
{
	
	timeToDetonate = ( distance/3500 );
	
	wait ( timeToDetonate );
	
	if( !isDefined( projectile ) )
		return;
	
	projPosition = projectile.origin;
	projType = projectile.model;
	projAngles = projectile.angles;
	
	projectile delete();
	//self thread drawLine( self GetEye(), explodePoint, 10, (0,0,1) );
	
	playFX( level.mine_explode, explodePoint, AnglesToForward( projAngles ), AnglesToUp( projAngles ) );
	RadiusDamage( explodePoint, 175, 75, 45, self, "MOD_EXPLOSIVE", "xm25" );
}

watchAirBurstDistanceMarkerUse()
{
	self endon("death");
	
	for(;;)
	{
		self waittill( "holding_breath" );
		
		if ( !isAirburstWeapon( self GetCurrentWeapon() ) )
		{
			wait ( .05 );
			continue;
		}
		
		if ( !self AdsButtonPressed() )
		{
			wait (.05);
			continue;
		}
		
		origin = self GetEye();
		forward = AnglesToForward( self GetPlayerAngles() );
		endpoint = origin + forward * 15000;
		
		traceData = BulletTrace( origin, endpoint, true, self );
		
		self.markedAirburstDistance = DistanceSquared( traceData["position"], self.origin );
		self notify("new_trace");
		//self thread drawLine( origin, traceData["position"], 10, (1,0,0) );
		self thread show_range( 5, (1,0,0) );
		wait( .20 );
	}
	
}

show_range( timeSlice, color )
{
	self endon("new_trace");
	drawTime = int(timeSlice * 20);
	distance = sqrt( self.markedAirburstDistance );
	offset = (0, 0, -12);
	for( time = 0; time < drawTime; time++ )
	{
		if (self AdsButtonPressed())
		{	// only draw while in ads
			origin = self GetEye() + offset;
			forward = AnglesToForward( self GetPlayerAngles() );
			explodePoint = origin + forward * (distance + 64);
			line( origin, explodePoint, color,false, 1 );
		}
		wait ( 0.05 );
	}
}

drawLine( start, end, timeSlice, color )
{
	self endon("new_trace");
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		line( start, end, color,false, 1 );
		wait ( 0.05 );
	}
}

isAirBurstWeapon( weapon )
{
	switch( weapon )
	{
		case "xm25":
			return true;
		default:
			return false;
	}
}


watchProximityAirBurstFire()
{
	self endon("death");
	
	for(;;)
	{
		self waittill( "missile_fire", projectile, weaponName );
		
		if ( !isAirburstWeapon( weaponName ) )
			continue;
		
		self thread proximityDetonateGrenade( projectile );	
		
	}
}

contactExtraFX( projectile )
{
	projectile waittill("explode", impactpt);
	if (!isdefined(projectile.airburst))
	{
		// we need to get the normal of the surface we hit for the fx to look right
		// we'll do a probe
		forward = AnglesToForward( projectile.angles );
		up = AnglesToUp( projectile.angles );
		trace = BulletTrace( impactpt - (24*forward), impactpt + (24*forward), true, projectile );
		if ((trace["fraction"] > 0.9) || (lengthsquared(trace["normal"]) < 0.1))
		{
			playFX( level.contact_explode, impactpt, AnglesToForward( projectile.angles ), AnglesToUp( projectile.angles ) );
		}
		else
		{
			playFX( level.contact_explode, impactpt, trace["normal"], AnglesToUp( projectile.angles ) );
		}
		ent = trace["entity"];
		if (isdefined(ent))
		{
			if (isai(ent))
			{
				//if (!IsSubStr( ent.classname, "ally"))
				{	// don't kill allies (though friendly fire would be  caught)
					if (!isdefined(ent.damageShield) || !ent.damageShield)
					{	// don't kill if damageshield is enabled
						ent kill();	// ensure a contact explosion kills the enemy
					}
				}
			}
		}
		if (!isdefined(projectile.in_proximity_loop))
		{	// we contact exploded before entering proximity detection, so do the full damage here
			RadiusDamage( impactpt, 240, 300, 120, self, "MOD_EXPLOSIVE", "xm25" );
			projectile notify("early_contact");
		}
		aud_send_msg( "xm25_contact_explode", impactpt );
	}
}

proximityDetonateGrenade( projectile )
{
	projectile endon("death");
	projectile endon("early_contact");
	minDetonateTime = 0.25;
	maxDetonateTime = 5.0;
	proximityRadius = 6*12;
	proximityHeight = 15*12;
	delayed_explosion = false;
	thread contactExtraFX( projectile );
	
	wait ( minDetonateTime );
	
	if( !isDefined( projectile ) )
		return;
		
	projectile.in_proximity_loop = true;
	
	// wait until we're near or over enemies or we've timed out
	time = minDetonateTime;
	inrange = delayed_explosion;
	deltaz = 0;
	tgtpos = (0, 0, 0);
	while ((time < maxDetonateTime) && isDefined( projectile ) && !inrange)
	{
		projPosition = projectile.origin;
		forward = AnglesToForward(projectile.angles);
		forward = (forward[0], forward[1], 0);
		forward = VectorNormalize(forward);
		
		enemies	= GetAIArray("axis");
		
		if (IsDefined(enemies))
		{
			foreach (enemy in enemies)
			{
				enemypos = enemy GetEye();
				dist = distance2d(projPosition, enemypos );
				if (dist < proximityRadius)
				{
					delta = projPosition - enemypos;
					deltaz = delta[2];
					delta = (delta[0], delta[1], 0);
					if ((deltaz < proximityHeight) && (deltaz > (-1*proximityHeight)))
					{
						// ensure we're behind the enemy to have a better chance of killing
						dp = VectorDot(forward,delta);	// delta is from enemy to projectile
						// we'll move the exploding point forward so we are slightly behind the target_clearreticlelockon
						tgtpos = projPosition + (24 - dp)*forward;
						inrange = true;
					}
				}
			}
		}
		if (!inrange)
			wait 0.05;
		time += 0.05;
	}
	if (isDefined( projectile ))
	{
		projPosition = projectile.origin;
		projType = projectile.model;
		projAngles = projectile.angles;
		// adjust down to create better downward damage
		if (deltaz > 60)
			deltaz = 30;
		else if (deltaz > 30)
			deltaz = deltaz - 30;
		else
			deltaz = 0;
		
		aud_send_msg( "xm25_contact_explode", projPosition );
		playFX( level.mine_explode, projPosition, AnglesToForward( projAngles ), AnglesToUp( projAngles ) );
		RadiusDamage( (tgtpos[0], tgtpos[1], tgtpos[2] - deltaz), 240, 300, 120, self, "MOD_EXPLOSIVE", "xm25" );
		projectile.airburst = true;
		projectile delete();
	}
}

create_hud_xm25_screen( sortOrder, alphaValue, client )
{
	overlay = "hud_xm25_temp";
	hud = NewClientHudElem( client );
	hud.x = 0;
	hud.y = 0;
	hud.sort = sortOrder;
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";
	hud.alpha = alphaValue;
	hud SetShader( overlay, 640, 480 );

	return hud;
}

create_hud_xm25_scanlines( sortOrder, alphaValue )
{
	overlay = "hud_xm25_scanlines";
	hud = NewHudElem();
	hud.x = 0;
	hud.y = 0;
	hud.sort = sortOrder;
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";
	hud.alpha = alphaValue;
	hud SetShader( overlay, 640, 480 );

	return hud;
}

