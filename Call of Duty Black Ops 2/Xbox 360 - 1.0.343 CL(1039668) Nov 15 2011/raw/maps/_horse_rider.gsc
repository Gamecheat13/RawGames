#include common_scripts\utility; 
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include animscripts\utility;

#insert raw\common_scripts\utility.gsh;

#using_animtree ("generic_human");

//----------------------------------------------------------------------------------------
// AI for horse rider - ported from _motorcycle.gsc
ride_and_shoot( horse )
{
	self.ridingvehicle = horse;
	self AnimCustom( ::ai_ride_and_shoot );
}

ai_ride_and_shoot()
{
	self endon("death");
	self endon("start_ragdoll");
	self endon("stop_riding");

	self.riderIsArmed				= false;
	self.riderIsAiming				= false;
	self.riderShouldJump			= false;
	self.riderShouldLand			= false;
	self.prevRiderYawAimWeight		= 0;
	self.prevRiderPitchAimWeight	= 0;
	self.prevSideAnimWeight			= 99999;

	//self.max_horse_aim_yaw_angle		= 45;	// this is how far the additive aim_6 and aim_4's will go
	self.max_horse_aim_yaw_angle		= 0;	// this is how far the additive aim_6 and aim_4's will go
	self.max_horse_aim_pitch_angle		= 60;	// this is how far the additive aim_2 and aim_8's will go
//	self.max_horse_aim_angle_delta		= 30;	// max yaw angle change per frame
	self.max_horse_aim_angle_delta		= 12;	// max yaw angle change per frame
	self.max_horse_side_yaw_angle		= 90;	// this is how far the delta aim_5's will go

	if( !IsDefined(self.max_horse_total_yaw_angle) )
	{
		self.max_horse_total_yaw_angle	= self.max_horse_side_yaw_angle + self.max_horse_aim_yaw_angle;
	}

	//self.max_bike_roll_angle		= 30;	// how much roll there needs to be for the lean anims to play at full weight

	//if( !IsDefined(self.min_blindspot_time) )
	//{
	//	self.min_blindspot_time			= 0.5;	// how much time the target has to spend in the blindspot before blindfiring (seconds)
	//}

	//blindSpotTime					= 0;

	if( !IsDefined(level.ai_horse_death_launch_vector) )
	{
//		level.ai_horse_death_launch_vector = (200, 200, 40);
		level.ai_horse_death_launch_vector = (10, 10, 40);
	}

	self maps\_utility::disable_pain();
	self maps\_utility::disable_react();

	self.overrideActorDamage = ::ai_ride_and_shoot_damage_override;

	//self animscripts\shared::placeWeaponOn( self.primaryweapon, "left" );

	// don't let code override the tag linkto
	self AnimMode( "point relative" );
	
	// let the AI use the horse's pitch and roll as well
	self.fixedLinkYawOnly = false;
	self.a.useTagAim = true;

	self ai_ride_and_shoot_linkto_horse();
	self ai_ride_and_shoot_idle();

	//self thread ai_ride_and_shoot_watch_jump();
	
	self thread call_overloaded_func( "animscripts\shoot_behavior", "decideWhatAndHowToShoot", "normal" );
	
	while(1)
	{
		// try aiming if we have an enemy
		//self animscripts\shoot_behavior::setShootEnt( getplayers()[0] );
		if( IS_TRUE( self.riderIsPain ) )
		{
			wait_network_frame();
			continue;
		}

		if( IsDefined(self.shootEnt) )
		{
			shootPos = self.shootEnt GetShootAtPos(self);

			shootFromPos	= self animscripts\shared::trackLoopGetShootFromPos();
			shootFromAngles = self animscripts\shared::trackLoopGetShootFromAngles();

			vectorToShootPos = shootPos - shootFromPos;
			anglesToShootPos = VectorToAngles( vectorToShootPos );

			facingVector = anglesToForward( shootFromAngles );
			//recordLine( shootFromPos, shootFromPos + VectorScale(facingVector, 100), (0,0,1), "Script", self );

			yawToEnemy		= AngleClamp180( shootFromAngles[1] - anglesToShootPos[1] );
			pitchToEnemy	= AngleClamp180( shootFromAngles[0] - anglesToShootPos[0] );

			realYawToEnemy = self GetYawToOrigin(shootPos);

			// only a certain range is covered by the additive aims
			if( abs(realYawToEnemy) < self.max_horse_total_yaw_angle )
			{
				if( !self.riderIsArmed )
				{
					self ai_ride_and_shoot_gun_pullout();
					continue;
				}

				// additive isn't needed until the side yaw is exceeded
				if ( abs(realYawToEnemy) > self.max_horse_side_yaw_angle )
				{
					// yaw aiming
					yawAimWeight = abs(yawToEnemy / self.max_horse_aim_yaw_angle);
					aimDelta = yawAimWeight - self.prevRiderYawAimWeight;

					// slow down the aiming speed
					maxWeightChange = self.max_horse_aim_angle_delta / self.max_horse_aim_yaw_angle;
					if( abs(aimDelta) > maxWeightChange )
					{
						yawAimWeight = self.prevRiderYawAimWeight + maxWeightChange * sign(aimDelta);
					}

					// clamp
					if( yawAimWeight > 1 )
					{
						yawAimWeight = 1;
					}

					// aim left
					if( yawToEnemy < 0 )
					{
						self SetAnimLimited( %horse_aim_4, yawAimWeight, 0.05 );
						self SetAnimLimited( %horse_aim_6, 0, 0.05 );
					}
					else // aim right
					{
						self SetAnimLimited( %horse_aim_6, yawAimWeight, 0.05 );
						self SetAnimLimited( %horse_aim_4, 0, 0.05 );
					}
				}

				// pitch aiming
				pitchAimWeight = abs(pitchToEnemy / self.max_horse_aim_pitch_angle);
				if( abs(pitchAimWeight) > 1 )
				{
					pitchAimWeight = sign(pitchAimWeight);
				}

				aimDelta = pitchAimWeight - self.prevRiderPitchAimWeight;

				// slow down the aiming speed
				maxWeightChange = self.max_horse_aim_angle_delta / self.max_horse_aim_pitch_angle;
				if( abs(aimDelta) > maxWeightChange )
				{
					pitchAimWeight = self.prevRiderPitchAimWeight + maxWeightChange * sign(aimDelta);
				}

				// aim down
				if( pitchToEnemy < 0 )
				{
					self SetAnimLimited( %horse_aim_2, pitchAimWeight, 0.05 );
					self SetAnimLimited( %horse_aim_8, 0, 0.05 );
				}
				else // aim up
				{
					self SetAnimLimited( %horse_aim_8, pitchAimWeight, 0.05 );
					self SetAnimLimited( %horse_aim_2, 0, 0.05 );
				}

				self.prevRiderYawAimWeight = yawAimWeight;
				self.prevRiderPitchAimWeight = pitchAimWeight;

				//blindSpotTime = 0;
			}
			else
			{
				//blindSpotTime += 0.05;

				//if( blindSpotTime > self.min_blindspot_time )
				//{
				//	self ai_ride_and_shoot_gun_blindfire();
				//	self ai_ride_and_shoot_gun_putaway(0);
				//	blindSpotTime = 0;
				//	continue;
				//}
				//else if( self.riderIsArmed )
				//{
				//	self ai_ride_and_shoot_gun_putaway();
				//}

				if ( self.riderIsArmed )
				{
					self ai_ride_and_shoot_gun_putaway();
				}
			}
		}
		else if( self.riderIsArmed )
		{
			self ai_ride_and_shoot_gun_putaway();
		}

		// play the proper idle
		if( self.riderIsArmed )
		{
			self ai_ride_and_shoot_aim_idle();
		}
		else
		{
			self ai_ride_and_shoot_idle();
		}

		wait(0.05);
	}
}

ai_ride_stop_riding()
{
	self endon("death");
	self endon("start_ragdoll");
		
	self notify("stop_riding");
	self ClearAnim( %root, 0 );
	self Unlink();
}

ai_ride_and_shoot_linkto_horse()
{
	assert( IsDefined(self.ridingvehicle) );

	tag_driver_origin = self.ridingvehicle GetTagOrigin("tag_driver");
	tag_driver_angles = self.ridingvehicle GetTagAngles("tag_driver");

	self ForceTeleport( tag_driver_origin, tag_driver_angles );
	self LinkTo( self.ridingvehicle, "tag_driver" );

	self ClearAnim( %root, 0 );
}

ai_ride_and_shoot_aiming_on( sideAnimWeight )
{
	if( !IsDefined(sideAnimWeight) )
	{
		sideAnimWeight = 0;
	}

	if( sideAnimWeight < 0 )
	{
		sideAnimWeight = abs(sideAnimWeight);

		self SetAnimKnobLimited( %ai_horse_rider_aim_l_2, sideAnimWeight, 0 );
		self SetAnimKnobLimited( %ai_horse_rider_aim_l_4, sideAnimWeight, 0 );
		self SetAnimKnobLimited( %ai_horse_rider_aim_l_6, sideAnimWeight, 0 );
		self SetAnimKnobLimited( %ai_horse_rider_aim_l_8, sideAnimWeight, 0 );

		// firing
		if( sideAnimWeight > 0.5 )
		{
			self SetFlaggedAnimLimited( "fireAnim", %ai_horse_rider_aim_l_fire, sideAnimWeight, 0 );
		}
		else
		{
			self SetAnimLimited( %ai_horse_rider_aim_l_fire, sideAnimWeight, 0 );
		}
	}
	else
	{
		self SetAnimKnobLimited( %ai_horse_rider_aim_r_2, sideAnimWeight, 0 );
		self SetAnimKnobLimited( %ai_horse_rider_aim_r_4, sideAnimWeight, 0 );
		self SetAnimKnobLimited( %ai_horse_rider_aim_r_6, sideAnimWeight, 0 );
		self SetAnimKnobLimited( %ai_horse_rider_aim_r_8, sideAnimWeight, 0 );

		// firing
		if( sideAnimWeight > 0.5 )
		{
			self SetFlaggedAnimLimited( "fireAnim", %ai_horse_rider_aim_r_fire, sideAnimWeight, 0 );
		}
		else
		{
			self SetAnimLimited( %ai_horse_rider_aim_r_fire, sideAnimWeight, 0 );
		}
	}

	// forward
	//self SetAnimLimited( %ai_horse_rider_aim_f_2, 1 - sideAnimWeight, 0 );
	//self SetAnimLimited( %ai_horse_rider_aim_f_4, 1 - sideAnimWeight, 0 );
	//self SetAnimLimited( %ai_horse_rider_aim_f_6, 1 - sideAnimWeight, 0 );
	//self SetAnimLimited( %ai_horse_rider_aim_f_8, 1 - sideAnimWeight, 0 );

	// firing
	if( sideAnimWeight < 1 )
	{
		if( sideAnimWeight < 0.5 )
		{
			self SetFlaggedAnimLimited( "fireAnim", %ai_horse_rider_aim_f_fire, 1 - sideAnimWeight, 0 );
		}
		else
		{
			self SetAnimLimited( %ai_horse_rider_aim_f_fire, 1 - sideAnimWeight, 0 );
		}
	}

	// unlimited ammo
	self animscripts\weaponList::RefillClip();
}

ai_ride_and_shoot_idle()
{
	//if( self.riderShouldJump )
	//{
	//	self ai_ride_and_shoot_jump();
	//	return;
	//}

	if ( IS_TRUE( self.riderIsDead ) )
	{
		return;
	}

	self.riderIsAiming = false;
	self.riderIsArmed  = false;

	//rollAnimWeight = ai_ride_and_shoot_lean();
//	rollAnimWeight = 0;

	//self SetAnim( %ai_horse_rider_forward_idle, 1 - rollAnimWeight, 0.2, 1 );
	if ( isdefined( self.nextAnimation ) )
	{
		//self SetAnim( self.nextAnimation, 1, 0.2, 1 );
		self SetAnimKnobAll( self.nextAnimation, %generic_human::root, 1, 0.2, 1 );
	}
	else if ( isdefined( self.ridingvehicle.rider_nextAnimation ) )
	{
		//self SetAnim( self.ridingvehicle.rider_nextAnimation, 1, 0.2, 1 );
		self SetAnimKnobAll( self.ridingvehicle.rider_nextAnimation, %generic_human::root, 1, 0.2, 1 );
		self.ridingvehicle.rider_nextAnimation = undefined;
	}
}

ai_ride_and_shoot_aim_idle( blendTime )
{
	//if( self.riderShouldJump )
	//{
	//	self ai_ride_and_shoot_jump();
	//	return;
	//}

	self.riderIsAiming = true;

	//rollAnimWeight = ai_ride_and_shoot_lean();

	if ( !isdefined( self.shootEnt ) )
	{
		return;
	}
	assert( IsDefined(self.shootEnt) );

	// left and right aims turn 90 degrees
	realYawToEnemy = self GetYawToOrigin(self.shootEnt.origin);	
	sideAnimWeight = realYawToEnemy / self.max_horse_side_yaw_angle;

	aimDelta = sideAnimWeight - self.prevSideAnimWeight;

	// slow down the aiming speed
	maxWeightChange = self.max_horse_aim_angle_delta / self.max_horse_side_yaw_angle;
	if( abs(aimDelta) > maxWeightChange )
	{
		sideAnimWeight = self.prevSideAnimWeight + maxWeightChange * sign(aimDelta);
	}

	// clamp to [-1,1]
	if( abs(sideAnimWeight) > 1 )
	{
		sideAnimWeight = sign(sideAnimWeight);
	}

	// save some anim command traffic
	if( self.prevSideAnimWeight == sideAnimWeight )
	{
		return;
	}

	self.prevSideAnimWeight = sideAnimWeight;

	// aiming
	ai_ride_and_shoot_aiming_on( sideAnimWeight );
	
	if( !IsDefined(blendTime) )
	{
		blendTime = 0.05;
	}

	// set the side anim
	if( sideAnimWeight < 0 )
	{
		sideAnimWeight = abs(sideAnimWeight);

		self SetAnim( %ai_horse_rider_aim_l_5, sideAnimWeight, blendTime, 1 );
		self SetAnim( %ai_horse_rider_aim_r_5, 0, blendTime, 1 );
	}
	else
	{
		self SetAnim( %ai_horse_rider_aim_r_5, sideAnimWeight, blendTime, 1 );
		self SetAnim( %ai_horse_rider_aim_l_5, 0, blendTime, 1 );
	}

	// forward
	self SetAnim( %ai_horse_rider_aim_f_5, 1 - sideAnimWeight, blendTime, 1 );
}

ai_ride_and_shoot_gun_pullout()
{
	self endon("rider_stop_pain");

	self.gun_pullout = true;
	self SetFlaggedAnimKnobAllRestart( "ride", %ai_horse_rider_pistol_pullout, %body, 1, 0.2, 1 );
	self waittillmatch("ride", "end");

	self.prevSideAnimWeight = 0;
	
	const blendTime = 0.2;

	if( IsDefined(self.shootEnt) )
	{
		self ClearAnim( %ai_horse_rider_pistol_pullout, blendTime );
		//self ClearAnim( %crew_bike_m72_lean_left_unarmed, blendTime );
		//self ClearAnim( %crew_bike_m72_lean_right_unarmed, blendTime );

		self.riderIsArmed				= true;
		self.gun_pullout				= false;
		self.prevRiderYawAimWeight		= 0;
		self.prevRiderPitchAimWeight	= 0;

		self ai_ride_and_shoot_aim_idle( blendTime );

		wait( blendTime );

		self thread ai_ride_and_shoot_gun_shoot();
	}
	else
	{
		self ai_ride_and_shoot_gun_putaway(0);
	}
}

ai_ride_and_shoot_gun_putaway( aimForwardTime )
{
	self endon("rider_stop_pain");
	self notify("stopShooting");
	self SetAnim( %horse_fire, 0, 0 );

	if( !IsDefined(aimForwardTime) )
	{
		aimForwardTime = 0.3;
	}

	self SetAnimLimited( %horse_aim_4, 0, aimForwardTime );
	self SetAnimLimited( %horse_aim_6, 0, aimForwardTime );

	wait(aimForwardTime);

	self SetFlaggedAnimKnobAllRestart( "ride", %ai_horse_rider_pistol_putaway, %body, 1, 0.2, 1 );
	self waittillmatch("ride", "end");
	self ClearAnim( %ai_horse_rider_pistol_putaway, 0.2 );

	self.riderIsArmed = false;

	self ai_ride_and_shoot_idle();
}

ai_ride_and_shoot_gun_shoot()
{
	self notify("stopShooting");
	self endon("death");
	self endon("stopShooting");
	self endon("start_ragdoll");

	self SetAnim( %horse_fire, 1, 0 );

	while(1)
	{
		self waittillmatch("fireAnim", "fire");

		self shootEnemyWrapper();

//		facingVector = AnglesToForward( self GetTagAngles("tag_flash") );
//		muzzle = self GetTagOrigin("tag_flash");
//
//		recordLine( muzzle, muzzle + VectorScale(facingVector, 500), (0,1,0), "Script", self );

		// wait at least a frame in between fires
		wait(0.05);
	}
}

ai_ride_and_shoot_pain()
{
	self notify( "rider_stop_pain" );
	self endon( "rider_stop_pain" );

	self SetFlaggedAnimKnobAllRestart( "painanim", self.pain_anim, %generic_human::body, 1, .1, 1 );
	self animscripts\shared::DoNoteTracks( "painanim" );

	self ClearAnim( self.pain_anim, 0.2 );

	if ( self.riderIsArmed )
	{
		self ai_ride_and_shoot_aim_idle();
		wait( 0.2 );
		self thread ai_ride_and_shoot_gun_shoot();
	}
	else
	{
		self ai_ride_and_shoot_idle();
	}

	self.riderIsPain = false;
	self.gun_pullout = false;
}

ai_ride_and_shoot_set_death_anim( dir )
{
	if ( self.riderIsArmed || IS_TRUE( self.gun_pullout ) )
	{
		if ( dir == "front" )
		{
			self.deathanim = %ai_horse_rider_aiming_death_f;
		}
		else if ( dir == "left" )
		{
			self.deathanim = %ai_horse_rider_aiming_death_l;
		}
		else if ( dir == "right" )
		{
			self.deathanim = %ai_horse_rider_aiming_death_r;
		}
		else
		{
			self.deathanim = %ai_horse_rider_aiming_death_b;
		}
	}
	else
	{
		if ( dir == "front" )
		{
			self.deathanim = %ai_horse_rider_death_f;
		}
		else if ( dir == "left" )
		{
			self.deathanim = %ai_horse_rider_death_l;
		}
		else if ( dir == "right" )
		{
			self.deathanim = %ai_horse_rider_death_r;
		}
		else
		{
			self.deathanim = %ai_horse_rider_death_b;
		}
	}
}

ai_ride_and_shoot_weapon_drop()
{
	self waittillmatch( "rider_death", "dropgun" );
	self animscripts\shared::DropAllAIWeapons();
}

ai_ride_and_shoot_death()
{
	self thread ai_ride_and_shoot_weapon_drop();
	self Unlink();

	self AnimScripted( "rider_death", self.origin, self.angles, self.deathanim, "normal", undefined, 1, 0.2 );
	self waittillmatch( "rider_death", "start_ragdoll" );

	self.overrideActorDamage = undefined;
	self StartRagdoll();
	self DoDamage( self.health, self.origin );
}

ai_ride_and_shoot_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if ( IS_TRUE( self.riderIsDead ) )
	{
		return 0;
	}

	self.riderIsPain = true;

	angles = VectorToAngles( vDir );
	yaw = AngleClamp180( angles[1] - self.angles[1] );
	dir = getAnimDirection( yaw );

	if ( iDamage >= self.health )
	{
		self.riderIsDead = true;
		self ai_ride_and_shoot_set_death_anim( dir );
		self thread ai_ride_and_shoot_death();
		return 0;
	}

	if ( self.riderIsArmed || IS_TRUE( self.gun_pullout ) )
	{
		if ( dir == "front" )
		{
			self.pain_anim = %ai_horse_rider_aiming_pain_f;
		}
		else if ( dir == "left" )
		{
			self.pain_anim = %ai_horse_rider_aiming_pain_l;
		}
		else if ( dir == "right" )
		{
			self.pain_anim = %ai_horse_rider_aiming_pain_r;
		}
		else
		{
			self.pain_anim = %ai_horse_rider_aiming_pain_b;
		}
	}
	else
	{
		if ( dir == "front" )
		{
			self.pain_anim = %ai_horse_rider_pain_f;
		}
		else if ( dir == "left" )
		{
			self.pain_anim = %ai_horse_rider_pain_l;
		}
		else if ( dir == "right" )
		{
			self.pain_anim = %ai_horse_rider_pain_r;
		}
		else
		{
			self.pain_anim = %ai_horse_rider_pain_b;
		}
	}

	self thread ai_ride_and_shoot_pain();

	//return self.health + 10;

	if ( IS_TRUE( self.magic_bullet_shield ) )
	{
		return 0;
	}

	return iDamage;
}

ai_ride_and_shoot_ragdoll_death()
{
	self.a.doingRagdollDeath = true;

	self animscripts\shared::DropAllAIWeapons();

	// first, just use the speed to launch
	velocity = AnglesToForward( self.angles );

	assert( IsDefined(level.ai_horse_death_launch_vector) );

	// if there's a level specific vector defined, use that as a multiplier
	velocity = ( velocity[0] * level.ai_horse_death_launch_vector[0],
				 velocity[1] * level.ai_horse_death_launch_vector[1],
				 level.ai_horse_death_launch_vector[2] );

	self Unlink();
	self StartRagdoll();
	self LaunchRagdoll( velocity );

	recordLine( self.origin, self.origin + velocity, (1,0,0), "Script", self );

	return true;
}

