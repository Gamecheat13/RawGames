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
	if( !IsDefined(horse) )
	{
		/#
		IPrintLnBold( "Warning: ride_and_shoot called with an undefined horse" );
		#/
		return;
	}
	
	self.ridingvehicle = horse;
	self horse_rider_setup_anim_funcs();
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

	self.pauseAnimation				= false;

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

	self thread ai_ride_and_shoot_stop();
	self thread ai_ride_and_shoot_exit_vehicle();
	self.overrideActorDamage = ::ai_ride_and_shoot_damage_override;

	//self animscripts\shared::placeWeaponOn( self.primaryweapon, "left" );

	// don't let code override the tag linkto
	self AnimMode( "point relative" );
	
	// let the AI use the horse's pitch and roll as well
	self.fixedLinkYawOnly = false;
	self.a.useTagAim = true;

	//self ai_ride_and_shoot_linkto_horse();
	self ai_ride_and_shoot_noncombat();

	//self thread ai_ride_and_shoot_watch_jump();
	
	self thread animscripts\shoot_behavior::decideWhatAndHowToShoot("normal");
	
	while(1)
	{
		// try aiming if we have an enemy
		//self animscripts\shoot_behavior::setShootEnt( getplayers()[0] );
		if( IS_TRUE( self.riderIsPain ) || IS_TRUE( self.pauseAnimation ) )
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
			self ai_ride_and_shoot_aim_idle( 0.2 );
		}
		//else
		//{
		//	self ai_ride_and_shoot_noncombat();
		//}

		wait(0.05);
	}
}

ai_ride_and_shoot_stop()
{
	self waittill( "stop_riding" );
	self.overrideActorDamage = undefined;
}

ai_ride_and_shoot_exit_vehicle()
{
	self waittill( "exit_vehicle" );
	self maps\_utility::enable_pain();
	self maps\_utility::enable_react();
}

ai_ride_play_anim( animname )
{
	self endon( "death" );
	self endon( "stop_riding" );

	self SetAnimKnobAllRestart( animname, %generic_human::body, 1, 0.2, 1 );
	wait( GetAnimLength( animname ) );
}

ai_ride_stop_horse()
{
	self endon( "death" );
	self endon( "stop_riding" );

	if ( !self horse_rider_can_update_anim() )
	{
		return;
	}

	self.pauseAnimation = true;

	self ai_ride_play_anim( %ai_horse_rider_short_stop_init );
	self ai_ride_play_anim( %ai_horse_rider_short_stop_finish );

	self.pauseAnimation = false;

	if ( !self.riderIsArmed )
	{
		self ai_ride_and_shoot_noncombat();
	}
}

ai_ride_transition( start, speed )
{
	self endon( "death" );
	self endon( "stop_riding" );

	if ( !self horse_rider_can_update_anim() )
	{
		return;
	}

	self.pauseAnimation = true;

	if ( is_true( start ) )
	{
		self ai_ride_play_anim( %ai_horse_rider_idle_to_walk );
	}
	else
	{
		if ( speed == level.TROT )
		{
			self ai_ride_play_anim( %ai_horse_rider_trot_to_idle );
		}
		else if ( speed == level.RUN )
		{
			self ai_ride_play_anim( %ai_horse_rider_canter_to_idle );
		}
		else if ( speed == level.SPRINT )
		{
			self ai_ride_play_anim( %ai_horse_rider_sprint_to_idle );
		}
		else
		{
			self ai_ride_play_anim( %ai_horse_rider_walk_to_idle );
		}
	}

	self.pauseAnimation = false;

	//if ( !self.riderIsArmed )
	//{
	//	self ai_ride_and_shoot_noncombat();
	//}
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
	horse = self.ridingvehicle;

	tag_driver_origin = horse GetTagOrigin("tag_driver");
	tag_driver_angles = horse GetTagAngles("tag_driver");

	self ForceTeleport( tag_driver_origin, tag_driver_angles );
	self LinkTo( horse, "tag_driver" );

	self ClearAnim( %root, 0 );
}

ai_ride_and_shoot_aiming_on( sideAnimWeight )
{
	animSpeed = self _horse_rider_get_anim_speed();

	if ( animSpeed == level.WALK )
	{
		horse_fire_anim = %horse_fire_walk;
	}
	else if ( animSpeed == level.TROT )
	{
		horse_fire_anim = %horse_fire_trot;
	}
	else if ( animSpeed == level.RUN )
	{
		horse_fire_anim = %horse_fire_canter;
	}
	else if ( animSpeed == level.SPRINT )
	{
		horse_fire_anim = %horse_fire_sprint;
	}
	else
	{
		horse_fire_anim = %horse_fire_idle;
	}

	if( !IsDefined(sideAnimWeight) )
	{
		sideAnimWeight = 0;
	}

	aim_blend = 0.2;

	if( sideAnimWeight < 0 )
	{
		sideAnimWeight = abs(sideAnimWeight);

		self SetAnimKnobLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_L][2], sideAnimWeight, aim_blend );
		self SetAnimKnobLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_L][4], sideAnimWeight, aim_blend );
		self SetAnimKnobLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_L][6], sideAnimWeight, aim_blend );
		self SetAnimKnobLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_L][8], sideAnimWeight, aim_blend );

		// firing
		self SetAnimKnobLimited( horse_fire_anim, sideAnimWeight, 0.2 );
		if( sideAnimWeight > 0.5 )
		{
			self SetFlaggedAnimLimited( "fireAnim", level.horse_ai_aim_anims[animSpeed][level.AIM_L][level.FIRE], sideAnimWeight, aim_blend );
		}
		else
		{
			self SetAnimLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_L][level.FIRE], sideAnimWeight, aim_blend );
		}

		self SetAnimLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_R][level.FIRE], 0, aim_blend );
	}
	else
	{
		self SetAnimKnobLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_R][2], sideAnimWeight, aim_blend );
		self SetAnimKnobLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_R][4], sideAnimWeight, aim_blend );
		self SetAnimKnobLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_R][6], sideAnimWeight, aim_blend );
		self SetAnimKnobLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_R][8], sideAnimWeight, aim_blend );
		
		// firing
		self SetAnimKnobLimited( horse_fire_anim, sideAnimWeight, 0.2 );
		if( sideAnimWeight > 0.5 )
		{
			self SetFlaggedAnimLimited( "fireAnim", level.horse_ai_aim_anims[animSpeed][level.AIM_R][level.FIRE], sideAnimWeight, aim_blend );
		}
		else
		{
			self SetAnimLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_R][level.FIRE], sideAnimWeight, aim_blend );
		}

		self SetAnimLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_L][level.FIRE], 0, aim_blend );
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
			self SetFlaggedAnimLimited( "fireAnim", level.horse_ai_aim_anims[animSpeed][level.AIM_F][level.FIRE], 1 - sideAnimWeight, aim_blend );
		}
		else
		{
			self SetAnimLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_F][level.FIRE], 1 - sideAnimWeight, aim_blend );
		}
	}

	// unlimited ammo
	self animscripts\weaponList::RefillClip();
}

ai_ride_and_shoot_noncombat()
{
	horse = self.ridingvehicle;
	if ( !isdefined( horse ) )
	{
		return;
	}
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
	
	/#
	if ( isdefined( horse ) && isdefined( horse.horse_animating_override ) )
	{
		return;
	}
	#/

	if ( !isdefined( horse.rider_nextAnimation ) )
	{
		self thread wait_for_horse_anim( horse );
		return;
	}

	self SetAnim( horse.rider_nextAnimation, 1, 0, 1 );
	self SetAnimTime( horse.rider_nextAnimation, horse.current_time );
}

wait_for_horse_anim( horse )
{
	self endon( "death" );

	self endon( "wait_for_horse_anim" );
	self notify( "wait_for_horse_anim" );

	while ( 1 )
	{
		if ( isdefined( horse.rider_nextAnimation ) )
		{
			self SetAnim( horse.rider_nextAnimation, 1, 0, 1 );
			self SetAnimTime( horse.rider_nextAnimation, horse.current_time );
			return;
		}

		wait( 0.05 );
	}
}

ai_ride_and_shoot_aim_time()
{
	horse = self.ridingvehicle;
	if ( !isdefined( horse ) )
	{
		return;
	}
	animSpeed = horse.current_anim_speed;

	self SetAnimTime( level.horse_ai_aim_anims[animSpeed][level.AIM_R][5], horse.current_time );
	self SetAnimTime( level.horse_ai_aim_anims[animSpeed][level.AIM_L][5], horse.current_time );
	self SetAnimTime( level.horse_ai_aim_anims[animSpeed][level.AIM_F][5], horse.current_time );
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

	animSpeed = self _horse_rider_get_anim_speed();

	// set the side anim
	if( sideAnimWeight < 0 )
	{
		sideAnimWeight = abs(sideAnimWeight);

		self SetAnimLimited( %horse_aim_l_5, sideAnimWeight, blendTime, 1 );
		self SetAnimLimited( %horse_aim_r_5, 0, blendTime, 1 );

		self SetAnimKnobLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_L][5], sideAnimWeight, blendTime, 1 );
		self SetAnimKnobLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_R][5], 0, blendTime, 1 );
	}
	else
	{
		self SetAnimLimited( %horse_aim_r_5, sideAnimWeight, blendTime, 1 );
		self SetAnimLimited( %horse_aim_l_5, 0, blendTime, 1 );

		self SetAnimKnobLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_R][5], sideAnimWeight, blendTime, 1 );
		self SetAnimKnobLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_L][5], 0, blendTime, 1 );
	}

	// forward
	self SetAnimLimited( %horse_aim_f_5, 1 - sideAnimWeight, blendTime, 1 );

	self SetAnimKnobLimited( level.horse_ai_aim_anims[animSpeed][level.AIM_F][5], 1 - sideAnimWeight, blendTime, 1 );
}

ai_ride_and_shoot_gun_pullout()
{
	self endon("rider_stop_pain");

	self.gun_pullout = true;

	animSpeed = self _horse_rider_get_anim_speed();
	pulloutAnim = level.horse_ai_aim_anims[animSpeed][level.PISTOL_PULLOUT];

	//println( "rider " + self GetEntityNumber() + " pullout start " + GetTime() );

	self.pauseAnimation = true;
	self SetFlaggedAnimKnobAllRestart( "ride", pulloutAnim, %body, 1, 0.2, 1 );
	self waittillmatch("ride", "end");
	self.pauseAnimation = false;

	//println( "rider " + self GetEntityNumber() + " pullout finish " + GetTime() );

	self.prevSideAnimWeight = 0;
	
	const blendTime = 0.2;

	if( IsDefined(self.shootEnt) )
	{
		self ClearAnim( pulloutAnim, blendTime );

		self.riderIsArmed				= true;
		self.gun_pullout				= false;
		self.prevRiderYawAimWeight		= 0;
		self.prevRiderPitchAimWeight	= 0;

		//self ai_ride_and_shoot_aim_time();
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

	animSpeed = self _horse_rider_get_anim_speed();
	putawayAnim = level.horse_ai_aim_anims[animSpeed][level.PISTOL_PUTAWAY];

	//println( "rider " + self GetEntityNumber() + " putaway start " + GetTime() );

	self.pauseAnimation = true;
	self SetFlaggedAnimKnobAllRestart( "ride", putawayAnim, %body, 1, 0.2, 1 );
	self waittillmatch("ride", "end");
	self.pauseAnimation = false;
	self ClearAnim( putawayAnim, 0.2 );

	self.riderIsArmed = false;
	self.gun_pullout = false;

	//println( "rider " + self GetEntityNumber() + " putaway finish " + GetTime() );

	self ai_ride_and_shoot_noncombat();
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
	self endon( "death" );

	self SetFlaggedAnimKnobAllRestart( "painanim", self.pain_anim, %generic_human::body, 1, .1, 1 );
	self animscripts\shared::DoNoteTracks( "painanim" );

	self ClearAnim( self.pain_anim, 0.2 );

	if ( self.riderIsArmed )
	{
		//self ai_ride_and_shoot_aim_time();
		self ai_ride_and_shoot_aim_idle( 0.2 );
		wait( 0.2 );
		self thread ai_ride_and_shoot_gun_shoot();
	}
	else
	{
		self ai_ride_and_shoot_noncombat();
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

	if ( iDamage >= self.health && !is_true( self.magic_bullet_shield ) )
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

	/#recordLine( self.origin, self.origin + velocity, (1,0,0), "Script", self );#/

	return true;
}

_horse_rider_get_anim_speed()
{
	if ( !isdefined( self.ridingvehicle ) )
	{
		return level.IDLE;
	}

	animSpeed = self.ridingvehicle.current_anim_speed;
	if ( animSpeed < level.IDLE || animSpeed > level.SPRINT )
	{
		return level.IDLE;
	}

	return animSpeed;
}

horse_rider_setup_anim_funcs()
{
	self.update_rearback_anim = ::horse_rider_update_rearback_anim;
	self.update_idle_anim = ::horse_rider_update_idle_anim;
	self.update_reverse_anim = ::horse_rider_update_reverse_anim;
	self.update_turn_anim = ::horse_rider_update_turn_anim;
	self.update_run_anim = ::horse_rider_update_run_anim;
	self.update_transition_anim = ::ai_ride_transition;
	self.update_stop_anim = ::ai_ride_stop_horse;
}

horse_rider_can_update_anim()
{
	if ( is_true( self.pause_animation ) || is_true( self.riderIsArmed ) || is_true( self.gun_pullout ) )
	{
		return false;
	}

	if ( is_true( self.riderIsDead ) || is_true( self.riderIsPain ) )
	{
		return false;
	}

	return true;
}

horse_rider_update_rearback_anim()
{
	if ( !self horse_rider_can_update_anim() )
	{
		return;
	}

	rearback_anim = level.horse_ai_anims[ level.REARBACK ];

	self.pause_animation = true;

	self SetAnimKnobAllRestart( rearback_anim, %root, 1, 0.2, 1 );
	len = GetAnimLength( rearback_anim );
	wait( len );

	self.pause_animation = false;
}

horse_rider_update_idle_anim( idle_struct, anim_index )
{
	if ( !self horse_rider_can_update_anim() )
	{
		return;
	}

	idle_anim = idle_struct.ai_animations[ anim_index ];
	self SetAnimKnobAllRestart( idle_anim, %root, 1, 0.2, 1 );
}

horse_rider_update_reverse_anim( anim_rate )
{
	if ( !self horse_rider_can_update_anim() )
	{
		return;
	}

	self SetAnimKnobAll( level.horse_ai_anims[ level.REVERSE ], %root, 1, 0.2, anim_rate );
}

horse_rider_update_turn_anim( anim_rate, anim_index )
{
	if ( !self horse_rider_can_update_anim() )
	{
		return;
	}

	self SetAnimKnobAll( level.horse_ai_anims[ level.IDLE ][ anim_index ], %root, 1, 0.2, anim_rate );
}

horse_rider_update_run_anim( anim_rate, horse )
{
	if ( !self horse_rider_can_update_anim() )
	{
		//println( "rider " + self GetEntityNumber() + " failed run update " + GetTime() );
		return;
	}

	//println( "rider " + self GetEntityNumber() + " success run update " + GetTime() );
	self SetAnimKnobAll( level.horse_ai_anims[ horse.current_anim_speed ][0], %root, 1, 0.2, anim_rate );
}
