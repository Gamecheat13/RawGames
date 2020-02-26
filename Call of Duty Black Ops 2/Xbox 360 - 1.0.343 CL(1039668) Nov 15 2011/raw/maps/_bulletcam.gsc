#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;

#using_animtree("generic_human");

main()
{
	level._effect["_bulletcam_trail"] = LoadFX("maps/creek/fx_bullet_distortion_emitter");

	// SUMEET - if this effect is alredy defined by level script, do not override it
	if( !IsDefined( level._effect["_bulletcam_impact"] ) )
		level._effect["_bulletcam_impact"] = LoadFX("maps/creek/fx_impact_bullet_time");

	level._effect["_bulletcam_noncam_impact"] = LoadFX("impacts/fx_flesh_hit_body_nonfatal");
	
	level thread init_player_flags();
}

/* --------------------------------------------------------------------------------
Called from maps/_callbackglobal::Callback_ActorDamage.
-------------------------------------------------------------------------------- */
try_bulletcam( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	
	if (is_true(self.in_bulletcam))
	{
		return 0;	// prevent damage if already in bullet cam
	}
	else if (is_true(self.bulletcam_death))
	{

		// SUMEET - Added magic bullet shield logic
		magic_bullet_active = IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield;
		should_die = ( ( iDamage >= self.health ) || magic_bullet_active );

		if ( (should_die || is_true(self.bulletcam_fakedeath)) && IsPlayer(eAttacker) )	// kill shot from player
		{			
			if( sMeansOfDeath == "MOD_RIFLE_BULLET" || sMeansOfDeath == "MOD_PISTOL_BULLET" )
			{
				target_tag = "tag_eye"; // the default
				
				if(IsDefined(self._bulletcam_alternatetag))
				{
					target_tag = self._bulletcam_alternatetag;
				}
				
				vPoint = self GetTagOrigin(target_tag);  // always at the head for now
				
				if( !IsDefined( self.deathAnim ) )
				{
					self.deathAnim = %ai_death_upontoback;
				}

				// If this guy has magic bullet shield, stop it
				if( magic_bullet_active )
				{
					self stop_magic_bullet_shield();
					iDamage = self.health + 100;
				}

				self do_bulletcam(eAttacker, vPoint);
	
				//spot = Spawn("script_model", GetTagOrigin(target_tag));
				//spot SetModel("tag_origin");
				//spot.angles = GetTagAngles(target_tag)
				
				if( is_mature() && IsDefined(self.bulletcam_impactptfx) && self.bulletcam_impactptfx)
				{
					fx_player = Spawn("script_model", vPoint);
					fx_player SetModel("tag_origin");
					//fx_player.origin = vPoint;
					fx_player.angles = VectorToAngles( VectorScale(vDir, -1) );
					
					fx_player LinkTo( self, target_tag );
										
					PlayFXOnTag(level._effect["_bulletcam_impact"], fx_player, "tag_origin");
					
					fx_player thread delete_me_in_a_bit();
				}
				else if( is_mature() )
				{
					PlayFXOnTag(level._effect["_bulletcam_impact"], self, target_tag);
				}
				
			}
			else
			{
				eAttacker notify("_bulletcam:end");
			}
		}
		else
		{
			// since the regular blood effects are turned off so they don't play on the last
			// shot before the bullet gets there fake them here instead
			if( is_mature() )
			{
				PlayFX( level._effect["_bulletcam_noncam_impact"], vPoint, VectorScale(vDir, -1), (0,0,1) );
			}
		}
	
		if( IsDefined( self.bulletcam_nodeath ) )
			iDamage = self.health - 1;
	}
	else if( is_true(self.bulletcam_fakedeath ) )
	{
		
	}

	return iDamage;	// finish damage when bullet cam is done
}

#using_animtree("animated_props");

/* --------------------------------------------------------------------------------
The meat of the bullet cam work.
-------------------------------------------------------------------------------- */
do_bulletcam(player, end_point)
{
	BULLET_MODEL = "p_glo_bullet_tip";
	
	// SUMEET - Now level can specify its own bulletcam anim,
	// make sure this animation is in animated_props.atr animtree
	if( IsDefined( level.BULLET_ANIM_CAM ) )
		BULLET_ANIM_CAM = level.BULLET_ANIM_CAM;
	else
		BULLET_ANIM_CAM = %prop_meatshield_bullet_tip_cam;
	
	BULLET_ANIM_SPIN = %prop_meatshield_bullet_tip_spin;

	BULLET_DIST_FROM_CAMERA = 15;
	HOLD_DIST = 10;

	if(IsDefined(self.bulletcam_finaldist))
	{
		HOLD_DIST = self.bulletcam_finaldist;
	}

	if ( getdvar("r_stereo3DOn") == "1" )
	{
		// Bump out distance to make the bullet easier to focus on.
		BULLET_DIST_FROM_CAMERA = BULLET_DIST_FROM_CAMERA * 2;
		HOLD_DIST = HOLD_DIST * 2;
	}

	self.in_bulletcam = true;
	self notify("_bulletcam:start");
	self.bulletcam_death = undefined;// so we don't come in here again even after bulletcam is done (like during long deaths)

	player_ang = player GetPlayerAngles();

	pos = player get_eye();
	forward = AnglesToForward(player_ang);
	start = pos + forward * BULLET_DIST_FROM_CAMERA;

	// Spawn Real Bullet
	bullet = Spawn("script_model", start);
	vec_to_end = end_point - start;
	ang_to_end = VectorToAngles(vec_to_end);
	bullet.angles = ang_to_end;
	bullet SetModel(BULLET_MODEL);
	bullet UseAnimTree(#animtree);
	bullet SetAnim(BULLET_ANIM_SPIN, 1, 0, 3);

	// Spawn Fake (hidden) Bullet
	fake_bullet = Spawn("script_model", start);
	vec_to_player_end = VectorNormalize(vec_to_end) * (Length(vec_to_end) - HOLD_DIST);
	player_end_point = pos + vec_to_player_end;
	fake_bullet.angles = ang_to_end;
	fake_bullet SetModel(BULLET_MODEL);
	fake_bullet UseAnimTree(#animtree);
	fake_bullet SetAnim(BULLET_ANIM_CAM, 1, 0, 3);
	fake_bullet Hide();

	/#
 		//player SetClientDvar("g_dumpAnimsNetwork", bullet GetEntNum());
 		//player SetClientDvar("g_dumpAnims", bullet GetEntNum());
 		//player SetClientDvar("cg_dumpAnims", bullet GetEntNum());
		recordEnt(bullet);
	#/

	PlayFXOnTag(level._effect["_bulletcam_trail"], bullet, "tag_origin");

	player thread move_player(bullet, fake_bullet, player_end_point, player_ang, self);
	self move_bullet(bullet, end_point, player);

	if (IsDefined(self) && IsAlive(self))
	{
		self.in_bulletcam = undefined;
		self disable_long_death();
		//self.force_gib = true;
	}

	//wait .1;
}

/* --------------------------------------------------------------------------------
self = AI
-------------------------------------------------------------------------------- */
move_bullet(bullet, end_point, player)
{
	MOVE_TIME = .4;
	MOVE_ACCEL = .3;
	MOVE_DECEL = 0;

	bullet MoveTo(end_point, MOVE_TIME, MOVE_ACCEL, MOVE_DECEL);
	bullet waittill("movedone");
	bullet Delete();

	player notify("_bulletcam:impact");
	//AUDIO: C. Ayers - Adding Client Notifies
 	clientNotify( "blt_imp" );
}

/* --------------------------------------------------------------------------------
self = player
-------------------------------------------------------------------------------- */
move_player(bullet, fake_bullet, end_point, player_ang, victim)
{
	MOVE_TIME = .16;
	MOVE_ACCEL = 0;
	MOVE_DECEL = 0;
	BLUR_TIME = 0.8; //BLUR_TIME is a percentage of MOVE_TIME. 

	HOLD_TIME = .25; // how long to hold the player close to the victim before returning control.

	player_org = self.origin;

	self set_near_plane(1);
	self StartCameraTween(.1);
	fake_bullet LinkTo(bullet);
	self PlayerLinkToAbsolute(fake_bullet);
	self HideViewModel();
	self DisableWeapons();
	self FreezeControls(true);

	self notify("_bulletcam:start");
	self StartFadingBlur(6, MOVE_TIME * BLUR_TIME );
	
	//AUDIO: C. Ayers - Notifying the client so we can set snapshots and other goodies
	clientNotify( "blt_st" );

	level thread timescale_tween(.06, 1, MOVE_TIME, .1, .1);

	wait .3;

	fake_bullet Unlink();
	fake_bullet MoveTo(end_point, MOVE_TIME, MOVE_ACCEL, MOVE_DECEL);
	self thread adjust_view(fake_bullet, victim);
	
	if( IsDefined(self.bulletcam_timeontargdeath))
	{
		HOLD_TIME = self.bulletcam_timeontargetdeath;
	}
	
	
	self ent_flag_set("_bulletcam:watching_death");
	
	level timescale_death(HOLD_TIME);

	//wait (HOLD_TIME);

	self reset_near_plane();
	self Unlink();

	fake_bullet Delete();

	self ent_flag_set("_bulletcam:end");

	self StartCameraTween(.5);

	self SetOrigin(player_org);
	self SetPlayerAngles(player_ang);

	wait .5;
	self ShowViewModel();
	self EnableWeapons();

	self FreezeControls(false);
}

adjust_view(bullet, victim)
{
	bullet waittill("movedone");
	self Unlink();
	wait .05;
	self thread look_at(victim GetTagOrigin("tag_eye"), .2);
}

timescale_death(time)
{
	wait .1;
	level thread timescale_tween(1, .06, .1);
	wait time;
	//level timescale_tween(GetTimeScale(), .3, .35);
	level timescale_tween(1, 1, 0);
}

enable( enable )
{
	if( enable )
	{
		self.bulletcam_death = true;

		// effects will be handle by _bulletcam::try_bulletcam
		self BloodImpact("none");
	}
	else
	{
		self.bulletcam_death = false;
		self BloodImpact("normal");
	}
}

set_alternate_tag( tag_name )
{
	self._bulletcam_alternatetag = tag_name;
}

set_death_anim( _death_anim )
{
	self.deathAnim = _death_anim;
}

enable_fake_death( enable )
{
	self.bulletcam_fakedeath = enable;
}

set_end_distance_from_target( _dist )
{
	self.bulletcam_finaldist = _dist;
}

set_hold_distance_on_target_death( _time )
{
	self.bulletcam_timeontargdeath = _time;
}

play_fx_on_impact_point_not_joint( bool )
{
	self.bulletcam_impactptfx = true;
}

delete_me_in_a_bit()
{
	wait(10);
	self Delete();
}

init_player_flags()
{
	wait_for_first_player();
	// Player Flags
	player = get_players()[0]; 
	player ent_flag_init("_bulletcam:watching_death");
	player ent_flag_init("_bulletcam:end");
}