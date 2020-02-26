#include maps\_utility;
#using_animtree("generic_human");

// call this function before starting _load
init()
{
	level.avatar_muzzleflash = loadfx( "muzzleflashes/mp16_flash_view" );
	PrecacheModel( "character_us_cod3_preview" );
}

// call this function after starting _load
main()
{
	covertest_setup();
}


// -- cover test steez --

covertest_setup()
{
	trigs = GetEntArray( "coverspot", "targetname" );

	if( trigs.size <= 0 )
	{
		println( "no cover spots found!  aborting covertest." );
		return;
	}
	else
	{
		println( "there were " + trigs.size + " cover spots found.  continuing setup..." );
	}

	// for each trigger...
	for( i = 0; i < trigs.size; i++ )
	{
		trig = trigs[i];

		// see if it points to a script_origin pair
		if( IsDefined( trig.target ) )
		{
			trigtarget = GetEnt( trig.target, "targetname" );

			// if the script origin is valid, run the function on the trigger
			if( IsDefined( trigtarget ) )
			{
				trigs[i] thread covertest_init( false );
			}
		}
	}

	//level.player thread watchADS();
}

watchADS()
{
	adsval = self playerads();

	while(1)
	{
		if( adsval != self playerads() )
		{
			adsval = self playerads();
			//println( adsval );
		}
		wait( 0.1 );
	}
}

// "self" is the coverspot trigger
covertest_init( debugMe )
{
	if( !IsDefined( debugMe ) )
	{
		debugMe = false;
	}

	// -- cover system settings! --
	level.viewyaw = 55;  // degrees
	level.lastview = "none";  // "left" or "right"
	level.viewRotateSpeed = 0.15;  // seconds
	level.stopSlideDist = 56;  // units from either origin on the side of the cover to stop sliding
	level.slideIncrement_dist = 20;  // units to slide each time
	level.slideIncrement_time = 0.15; // seconds it takes to slide
	level.adsActive = false;  // is the player ADSing?
	level.adsPopUpDist_1P = 7;  // units to pop up in 1st person mode
	level.adsPopUpDist_3P = -3;  // units to pop up in 3rd person mode
	level.adsPopSideDist_1P = 7;  // units to pop to the side in 1P mode
	level.adsPopSideDist_3P = 25;  // units to pop to the side in 3P mode
	level.adsPopTime = 0.1;  // seconds it takes to pop the view out from behind cover when ADSing
	level.thirdPersonMode = true;  // set to false for first-person cover
	level.thirdPersonOffset_back = -35;  // units
	level.thirdPersonOffset_up = 5;  // units
	level.thirdPersonOffset_side = 15;  // units to offset the view from center when firing over a wall
	level.thirdPersonOffset_fromWall = -16;  // units from the wall to put the avatar
	level.thirdPersonViewYaw = 5;  // degrees
	level.thirdPersonTransitionTime = 0.5;  // seconds it takes to move the player in/out of his avatar
	level.thirdPersonTransitionTime_accel = 0.4;  // seconds we'll accelerate while moving in/out of the avatar
	level.thirdPersonAvatar_walkAnimSpeed = 2.5;  // how fast does the looping coverwalk anim go?
	level.thirdPersonAvatar_rotateTime = 0.1;  // seconds for the avatar to rotate towards a side
	level.thirdPersonAvatar_isCrouchWalking = false;  // is the avatar doing the locomotion animation?
	level.thirdPersonAvatar_isAiming = false;  // is the avatar aiming?
	level.thirdPersonAvatar_isBlindfiring = false;  // is the avatar blindfiring?
	level.thirdPersonAvatar_isReloading = false;  // is the avatar reloading?
	level.thirdPersonAvatar_isTraversing = false;  // is the avatar traversing?
	level.thirdPersonAvatar_mantleTime = 1;  // seconds it takes the mantling animation to do its thing
	level.thirdPersonAvatar = undefined;
	level.thirdPersonAvatar_weaponName = undefined;
	level.thirdPersonAvatar_model = "character_us_cod3_preview";

	if( level.xenon )
	{
		// Xenon controller settings
		level.leftbutton = "APAD_LEFT";
		level.rightbutton = "APAD_RIGHT";
		level.leavebutton = "BUTTON_LSTICK";
		level.firebutton = "BUTTON_RTRIG";
		level.reloadbutton = "BUTTON_X";
		level.grenadebutton = "BUTTON_RSHLDR";
		level.interactbutton = "BUTTON_A";
	}
	else
	{
		// PC settings
		level.leftbutton = "a";
		level.rightbutton = "d";
		level.leavebutton = "s";
		level.firebutton = "mouse1";
		level.reloadbutton = "r";
		level.grenadebutton = "mouse3";
		level.interactbutton = "w";
	}

	// get the script origins
	leftpoint = GetEnt( self.target, "targetname" );
	rightpoint = GetEnt( leftpoint.target, "targetname" );

	// error check
	if( !IsDefined( leftpoint ) )
	{
		println( "the left script origin was not found!  aborting covertest_think." );
		return;
	}
	else if( !IsDefined( rightpoint ) )
	{
		println( "the right script origin was not found!  aborting covertest_think." );
		return;
	}

	// draw the line between the points for debugging
	if( debugMe )
	{
		self thread covertest_drawline( leftpoint, rightpoint );
	}

	// wait for player to use trigger
	self waittill( "trigger" );

	// spawn our mover origin and link player
	if( level.thirdPersonMode )
	{
		offset = covertest_get_third_person_offset( level.player.origin, leftpoint.angles );

		// spawn the third-person player avatar
		covertest_spawn_thirdperson_avatar( level.player.origin, leftpoint.angles );

		level notify( "thirdperson_avatar_spawned" );

		mover = Spawn( "script_origin", level.thirdPersonAvatar.origin );
		mover.angles = leftpoint.angles;

		// entity, tag, viewfraction, rightarc, leftarc, toparc, bottomarc
		level.player PlayerLinkToDelta( mover, "", 0.5, 30, 30, 15, 20 );

		// slide the camera out of the avatar
		mover MoveTo( level.player.origin + offset, level.thirdPersonTransitionTime, level.thirdPersonTransitionTime_accel );
	}
	else
	{
		mover = Spawn( "script_origin", level.player.origin );
		level.player PlayerLinkToDelta( mover, "", 1.0, 20, 20, 15, 45 );
	}

	//iprintlnbold( "in cover! press " + level.leavebutton + " to leave." );
	level.player AllowProne( false );
	level.player AllowCrouch( true );
	level.player AllowStand( false );
	//level.player TakeWeapon( "fraggrenade" );
	level.player TakeWeapon( "smoke_grenade_american" );

	traversedOutOfCover = false;

	if( level.thirdPersonMode )
	{
		//SetSavedDvar( "cg_drawGun", "0" );
		//SetDvar( "cg_fov", "90" );

		// HACK this is so that the loop doesn't start before the avatar is against the wall, thus avoiding
		//  avatar insta-reload issues on Xenon (X button enters cover and also reloads)
		wait( 0.5 );
	}

	self thread covertest_thinkloop( mover, leftpoint, rightpoint );

	// wait for the player to leave cover
	while( 1 )
	{
		if( !level.player buttonPressed( level.leavebutton ) && !level.thirdPersonAvatar_isTraversing )
		{
			wait( 0.05 );
		}
		else
		{
			// if traversing, wait to go back to 1P until the anim is mostly done
			if( level.thirdPersonAvatar_isTraversing )
			{
				traversedOutOfCover = true;
				level waittill( "avatar_starting_traverse" );
				wait( level.thirdPersonAvatar_mantleTime );
			}
			
			// if aiming, wait for it to be over til breaking cover
			if( level.thirdPersonAvatar_isAiming )
			{
				wait( 0.05 );
			}
			
			// otherwise, go back to 1P immediately
			break;
		}
	}

	// handle leaving cover
	level.player notify( "player_leavecover" );
	//iprintlnbold( "player left cover" );

	// delete the third person guy, if necessary
	if( level.thirdPersonMode )
	{
		if( !traversedOutOfCover )
		{
			level.thirdPersonAvatar thread covertest_thirdperson_avatar_animate( "crouch_leave_cover" );
		}

		if( IsDefined( level.thirdPersonAvatar ) )
		{
			//SetSavedDvar( "cg_drawGun", "1" );
			//SetDvar( "cg_fov", "80" );

			// slide the player back into the avatar
			// if the player didn't traverse out, handle being on the backside of cover
			if( !traversedOutOfCover )
			{
				moveBackDist = 8;
				backangles = AnglesToForward( leftpoint.angles - ( 0, 180, 0 ) );
				movespot = level.thirdPersonAvatar.origin + ( backangles[0] * moveBackDist, backangles[1] * moveBackDist, 0 );
			}
			// otherwise we don't want to move the lerp spot back, cause it would be
			//  inside the cover
			else
			{
				movespot = level.thirdPersonAvatar.origin;
			}
			
			mover MoveTo( movespot, level.thirdPersonTransitionTime, level.thirdPersonTransitionTime_accel );
			mover waittill( "movedone" );

			level.thirdPersonAvatar_weapon Unlink();
			level.thirdPersonAvatar_weapon Delete();
			level.thirdPersonAvatar Delete();
		}
	}

	level.player Unlink();
	level.player AllowStand( true );
	level.player AllowCrouch( false );
	wait( 0.05 );
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	level.player GiveWeapon( "fraggrenade" );
	level.player GiveWeapon( "smoke_grenade_american" );
	wait( 0.1 );
	mover Delete();

	// restart the function
	self thread covertest_init( debugMe );
}


covertest_spawn_thirdperson_avatar( spawnOrigin, spawnAngles )
{
	coverspot = covertest_wall_trace( spawnOrigin, spawnAngles );

	level.thirdPersonAvatar = Spawn( "script_model", coverspot );
	level.thirdPersonAvatar SetModel( level.thirdPersonAvatar_model );
	level.thirdPersonAvatar.angles = spawnAngles;

	level.thirdPersonAvatar_weaponName = GetWeaponModel( level.player GetWeaponSlotWeapon( "primaryb" ) );
	level.thirdPersonAvatar_weapon = Spawn( "script_model", level.thirdPersonAvatar GetTagOrigin( "tag_weapon_right" ) );
	level.thirdPersonAvatar_weapon.angles = level.thirdPersonAvatar GetTagAngles( "tag_weapon_right" );
	level.thirdPersonAvatar_weapon SetModel( level.thirdPersonAvatar_weaponName );
	level.thirdPersonAvatar_weapon LinkTo( level.thirdPersonAvatar, "tag_weapon_right" );

	level.thirdPersonAvatar UseAnimTree( #animtree );
	level.thirdPersonAvatar thread covertest_thirdperson_avatar_animate( "crouch_idle" );
}


// self = the third person avatar
covertest_thirdperson_avatar_animate( actiontype )
{
	level endon( "covertest_kill_thirdperson_animthread" );

	//
	// --- CROUCHING IDLE ---
	//
	if( actiontype == "crouch_idle" )
	{
		anime = %hidelowwallc_idle1;
		self thread covertest_loop_anim( anime );
	}

	//
	// --- CROUCHING CORNER RIGHT IDLE ---
	// currently not used.
	//
	if( actiontype == "crouch_corner_right_idle" )
	{
		anime = %hidelowwallc_idle1;
		self thread covertest_loop_anim( anime );
	}

	//
	// --- CROUCHING CORNER LEFT IDLE ---
	// currently not used.
	//
	if( actiontype == "crouch_corner_left_idle" )
	{
		anime = %hidelowwallc_idle1;
		self thread covertest_loop_anim( anime );
	}

	//
	// --- CROUCHING TO LEAVE COVER ---
	//
	if( actiontype == "crouch_leave_cover" )
	{
		// wait for the locomotion animations to finish
		while( level.thirdPersonAvatar_isCrouchWalking )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isAiming )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isReloading )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isBlindfiring )
		{
			wait( 0.05 );
		}

		// stop any other running anims
		level notify( "covertest_end_animloop" );

		anime = %hidelowwallc2hidelowwallb;
		self covertest_single_anim( anime, 1.0 );
	}


	//
	// --- CROUCHING RELOAD ---
	//
	if( actiontype == "crouch_reload" )
	{
		anime_turnaround = %hidelowwallc2hidelowwallb;  // turn around to face the wall
		anime_reload = %covercrouch_reload_hide;  // reload
		anime_getdown = %crouch_aim2hidelowwallc;  // get back down

		// wait for the locomotion animations to finish
		while( level.thirdPersonAvatar_isCrouchWalking )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isAiming )
		{
			wait( 0.05 );
		}

		// stop any other running anims
		level notify( "covertest_end_animloop" );

		level.thirdPersonAvatar_isReloading = true;

		self covertest_single_anim( anime_turnaround, 4.0 );
		self covertest_single_anim( anime_reload, 3.5 );
		self covertest_single_anim( anime_getdown, 4.0 );

		// idle again
		// TODO idle for left/right corners if we're next to them
		self thread covertest_thirdperson_avatar_animate( "crouch_idle" );

		level.thirdPersonAvatar_isReloading = false;
	}

	//
	// --- CROUCHWALK ---
	//
	if( actiontype == "crouchwalk" )
	{
		// wait for the locomotion animations to finish
		while( level.thirdPersonAvatar_isCrouchWalking )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isAiming )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isReloading )
		{
			wait( 0.05 );
		}

		// stop any other running anims
		level notify( "covertest_end_animloop" );

		level.thirdPersonAvatar_isCrouchWalking = true;

		anime_turnaround = %hidelowwallc2hidelowwallb;  // first turn around
		anime_getup = %hidelowwallb2crouch_aim;  // then get up
		anime_startwalking = %crouch2crouchwalk_straight;  // then start walking
		anime_walkloop = %crouchwalk_loop;  // loop the walk cycle
		anime_getdown = %crouchwalk_stop_rff;  // get back down

		og_avatarAngles = self.angles;
		newangles = undefined;

		// turn the back away from the wall
		self covertest_single_anim( anime_turnaround, 4.0 );

		// rotate to the direction we're walking towards
		if( level.lastview == "right" )
		{
			//println( "rotating right" );
			newangles = self.angles + ( 0, -90, 0 );
		}
		else
		{
			//println( "rotating left" );
			newangles = self.angles + ( 0, 90, 0 );
		}

		self RotateTo( newangles, level.thirdPersonAvatar_rotateTime );
		wait( level.thirdPersonAvatar_rotateTime );

		// get up from being crouched
		self covertest_single_anim( anime_getup, 4.0 );

		// animate him getting from crouching to walking
		self covertest_single_anim( anime_startwalking, 3.0 );

		// loop the walking anim til we're done
		self thread covertest_loop_anim( anime_walkloop, level.thirdPersonAvatar_walkAnimSpeed );

		// wait for the player to stop moving the guy
		if( level.player buttonPressed( level.leftbutton ) )
		{
			while( level.player buttonPressed( level.leftbutton ) )
			{
				// if we're ADSing we have to stop
				if( !level.adsActive )
				{
					wait( 0.05 );
				}
				else
				{
					break;
				}
			}
		}
		else if( level.player buttonPressed( level.rightbutton ) )
		{
			while( level.player buttonPressed( level.rightbutton ) )
			{
				// if we're ADSing we have to stop
				if( !level.adsActive )
				{
					wait( 0.05 );
				}
				else
				{
					break;
				}
			}
		}

		// when done make him stop
		level notify( "covertest_end_animloop" );

		// "blend" out of walking
		self covertest_single_anim( anime_getdown, 4.0 );
		
		if( !IsDefined( self ) )
		{
			return;
		}

		// rotate back to face the wall
		self RotateTo( og_avatarAngles, level.thirdPersonAvatar_rotateTime );
		wait( level.thirdPersonAvatar_rotateTime );

		// idle again
		// TODO idle for left/right corners if we're next to them
		self thread covertest_thirdperson_avatar_animate( "crouch_idle" );

		level.thirdPersonAvatar_isCrouchWalking = false;
	}

	//
	// --- AIM OVER COVER ---
	//
	if( actiontype == "aim_over_cover" )
	{
		// wait for the locomotion animations to finish
		while( level.thirdPersonAvatar_isCrouchWalking )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isReloading )
		{
			wait( 0.05 );
		}

		level.thirdPersonAvatar_isAiming = true;

		level notify( "covertest_end_animloop" );

		anime_turnaround = %hidelowwallc2hidelowwallb;  // first turn around
		anime_getup = %hidelowwallb2crouch_aim; // then get up
		anime_aimloop = %crouch_aim_straight;  // aim loop
		anime_fireloop = %crouch_shoot_auto_straight;  // fire loop
		anime_fireloop_stop = %crouch_shoot_autoend_straight;  // end for the fire loop
		anime_getdown = %crouch_aim2hidelowwallc;  // get back down and turn around

		// get up from being crouched
		self covertest_single_anim( anime_turnaround, 4.0 );
		self covertest_single_anim( anime_getup, 4.0 );

		// handle aiming/firing
		while( level.adsActive )
		{
			// idle on aiming
			self thread covertest_loop_anim( anime_aimloop, 1.0 );

			// wait till fire, or until the ADS is no longer active
			while( !level.player ButtonPressed( level.firebutton ) && level.adsActive )
			{
				wait( 0.05 );
			}

			// stop the aiming animloop
			level notify( "covertest_end_animloop" );

			// if the player is firing, do the firing animloop
			if( level.player ButtonPressed( level.firebutton ) )
			{
				self thread covertest_loop_anim( anime_fireloop, 1.0 );

				// fakefire the avatar's weapon
				level.thirdPersonAvatar_weapon thread covertest_fakefire();

				// wait for player to stop firing, or for him to un-ADS
				while( level.player ButtonPressed( level.firebutton ) && level.adsActive )
				{
					wait( 0.05 );
				}

				// stop the fakefire
				level notify( "covertest_end_fakefire" );

				// play the ending anim for automatic fire
				self covertest_single_anim( anime_fireloop_stop, 1.0 );
			}

			// stop the firing animloop
			level notify( "covertest_end_animloop" );
		}

		// get back down
		self covertest_single_anim( anime_getdown, 4.0 );

		level.thirdPersonAvatar_isAiming = false;

		// idle again
		// TODO idle for left/right corners if we're next to them
		self thread covertest_thirdperson_avatar_animate( "crouch_idle" );
	}

	//
	// --- AIM AROUND COVER L/R ---
	//
	if( actiontype == "aim_around_cover_left" || actiontype == "aim_around_cover_right" )
	{
		// wait for the locomotion animations to finish
		while( level.thirdPersonAvatar_isCrouchWalking )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isReloading )
		{
			wait( 0.05 );
		}

		level.thirdPersonAvatar_isAiming = true;

		level notify( "covertest_end_animloop" );

		if( actiontype == "aim_around_cover_right" )
		{
			anime_swingout = %corner_crouch_alert2aim_left_15right; // swing out around the corner
			anime_aimloop = %corner_crouch_aim_left_15right;  // aim loop
			anime_fireloop = %corner_crouch_autofire_left_15right;  // fire loop
			anime_swingin = %corner_crouch_aim2alert_left_15right;  // swing back into cover
		}
		else
		{
			anime_swingout = %corner_crouch_alert2aim_right_15left; // swing out around the corner
			anime_aimloop = %corner_crouch_aim_right_15left;  // aim loop
			anime_fireloop = %corner_crouch_autofire_right_15left;  // fire loop
			anime_swingin = %corner_crouch_aim2alert_right_15left;  // swing back into cover
		}

		// HACK - rotate the guy around so the anims look right
		ogAngles = self.angles;
		self RotateTo( self.angles + ( 0, -180, 0 ), 0.05 );

		// get up from being crouched
		self covertest_single_anim( anime_swingout, 3.0 );

		// handle aiming/firing
		while( level.adsActive )
		{
			// idle on aiming
			self thread covertest_loop_anim( anime_aimloop, 1.0 );

			// wait till fire, or until the ADS is no longer active
			while( !level.player ButtonPressed( level.firebutton ) && level.adsActive )
			{
				wait( 0.05 );
			}

			// stop the aiming animloop
			level notify( "covertest_end_animloop" );

			// if the player is firing, do the firing animloop
			if( level.player ButtonPressed( level.firebutton ) )
			{
				self thread covertest_loop_anim( anime_fireloop, 1.0 );

				// fakefire the avatar's weapon
				level.thirdPersonAvatar_weapon thread covertest_fakefire();

				// wait for player to stop firing, or for him to un-ADS
				while( level.player ButtonPressed( level.firebutton ) && level.adsActive )
				{
					wait( 0.05 );
				}
			}

			// stop the firing animloop
			level notify( "covertest_end_animloop" );
			level notify( "covertest_end_fakefire" );
		}

		// get back down
		self covertest_single_anim( anime_swingin, 2.0 );

		// rotate back
		self RotateTo( ogAngles, 0.05 );

		level.thirdPersonAvatar_isAiming = false;

		// idle again
		// TODO idle for left/right corners if we're next to them
		self thread covertest_thirdperson_avatar_animate( "crouch_idle" );
	}

	//
	// --- BLINDFIRE OVER COVER ---
	//
	if( actiontype == "blindfire_over_cover" )
	{
		// wait for the locomotion animations to finish
		while( level.thirdPersonAvatar_isCrouchWalking )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isReloading )
		{
			wait( 0.05 );
		}

		level notify( "covertest_end_animloop" );

		level.thirdPersonAvatar_isBlindfiring = true;

		anime_turnaround = %hidelowwallc2hidelowwallb;  // turn around to face the wall
		anime_blindfire = %covercrouch_blindfire_1;  // the blindfire anim
		anime_getdown = %crouch_aim2hidelowwallc;  // get back down

		if( level.player ButtonPressed( level.firebutton ) )
		{
			// turn him around
			//self covertest_single_anim( anime_turnaround, 1.0 );

			// while the fire button is pressed, loop the blindfire anim - TODO get one that loops
			self thread covertest_loop_anim( anime_blindfire, 1.0 );

			// fakefire the avatar's weapon
			level.thirdPersonAvatar_weapon thread covertest_fakefire();

			while( level.player ButtonPressed( level.firebutton ) )
			{
				wait( 0.05 );
			}

			// end loop
			level notify( "covertest_end_animloop" );
			level notify( "covertest_end_fakefire" );

			// sit him back down
			//self covertest_single_anim( anime_getdown, 1.0 );
		}

		level.thirdPersonAvatar_isBlindfiring = false;

		// idle again
		// TODO idle for left/right corners if we're next to them
		self thread covertest_thirdperson_avatar_animate( "crouch_idle" );
	}

	//
	// --- CROUCHING GRENADE THROW OVER COVER ---
	//
	if( actiontype == "crouch_grenade_over_cover" )
	{
		anime_turnaround = %hidelowwallc2hidelowwallb;  // turn around to face the wall
		anime_throwgrenade = %crouch_grenade_throw;  // throw the grenade
		anime_getdown = %crouch_aim2hidelowwallc;  // get back down

		// wait for the locomotion animations to finish
		while( level.thirdPersonAvatar_isCrouchWalking )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isAiming )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isBlindfiring )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isReloading )
		{
			wait( 0.05 );
		}

		// stop any other running anims
		level notify( "covertest_end_animloop" );

		level.thirdPersonAvatar_isAiming = true;

		self covertest_single_anim( anime_turnaround, 4.0 );

		// throw the grenade
		// TODO make the avatar throw a real grenade
		//self thread covertest_avatar_throwgrenade();
		self covertest_single_anim( anime_throwgrenade, 1.5 );


		self covertest_single_anim( anime_getdown, 4.0 );

		// idle again
		// TODO idle for left/right corners if we're next to them
		self thread covertest_thirdperson_avatar_animate( "crouch_idle" );

		level.thirdPersonAvatar_isAiming = false;

		level notify( "grenade_throw_done" );
	}

	//
	// --- MANTLING OVER CROUCHED COVER ---
	//
	if( actiontype == "crouch_mantle_over_cover" )
	{
		anime_turnaround = %hidelowwallc2hidelowwallb;  // turn around to face the wall
		anime_standup = %crouchhide2stand;  // stand up
		anime_mantle = %traverse_wallhop_3;  // mantle the wall

		// wait for the locomotion animations to finish
		while( level.thirdPersonAvatar_isCrouchWalking )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isAiming )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isBlindfiring )
		{
			wait( 0.05 );
		}

		while( level.thirdPersonAvatar_isReloading )
		{
			wait( 0.05 );
		}

		// stop any other running anims
		level notify( "covertest_end_animloop" );

		level.thirdPersonAvatar_isTraversing = true;

		self covertest_single_anim( anime_turnaround, 2.0 );
		self covertest_single_anim( anime_standup, 2.0 );

		level notify( "avatar_starting_traverse" );

		self covertest_single_anim( anime_mantle, 1.0 );

		level.thirdPersonAvatar_isTraversing = false;
		level notify( "avatar_finished_traversing" );
	}
}


// self = the third person avatar
covertest_avatar_throwgrenade()
{
	wait( 1.45 );

	// figure out where we're throwing the grenade
	traceDir = VectorNormalize( AnglesToForward( level.player GetPlayerAngles() ) );
	trace = BulletTrace( level.player getEye(), level.player getEye() + vecscale( traceDir, 1000 ), true, level.thirdPersonAvatar );
	targetSpot = trace["position"];

	level.player MagicGrenade( self.origin + ( 0, 0, 50 ), targetSpot, 2.5 );
}


// self = the third person avatar
covertest_single_anim( anime, animRate )
{
	level endon( "covertest_end_anim" );

	if( !IsDefined( self ) )
	{
		return;
	}

	if( !IsDefined( animRate ) )
	{
		animRate = 1.0;
	}

	self SetFlaggedAnimKnobAllRestart( "single anim", anime, %body, 1, 0.1, animRate );
	self waittillmatch( "single anim", "end" );
}

// self = the third person avatar
covertest_loop_anim( anime, animRate )
{
	level endon( "covertest_end_animloop" );

	if( !IsDefined( animRate ) )
	{
		animRate = 1.0;
	}

	while( 1 )
	{
		//self animscripted( "looping anim", self.origin, self.angles, anime );
		self SetFlaggedAnimKnobAllRestart( "looping anim", anime, %body, 1, 0.1, animRate );
		self waittillmatch( "looping anim", "end" );
	}
}


// self = the avatar's gun
covertest_fakefire()
{
	level endon( "covertest_end_fakefire" );

	while( 1 )
	{
		playfxontag( level.avatar_muzzleflash, self, "tag_flash" );
		wait( 0.075 );  // this is the fire rate for the m16 as defined in assman
	}
}


covertest_wall_trace( startOrigin, anglesToWall )
{
	// now get the spot where the wall is
	traceDir = vectorNormalize( anglesToForward( anglesToWall ) );
	trace = bulletTrace( startOrigin, startorigin + vecscale( traceDir, 128 ), false, level.player );
	coverspot = trace["position"];

	//println( "coverspot, next to the wall, is at: " + coverspot );

	// now move backwards so the avatar doesn't clip through the wall
	backangles = AnglesToForward( anglesToWall - ( 180, 180, 180 ) );
	coverspot = coverspot + ( backangles[0] * level.thirdPersonOffset_fromWall, backangles[1] * level.thirdPersonOffset_fromWall, 0 );

	//level thread covertest_drawline_to_player( coverspot );

	//println( "coverspot, moved, is at: " + coverspot );

	return coverspot;
}

covertest_get_third_person_offset( refPoint, refAngle )
{
	backangles = AnglesToForward( refAngle - ( 180, 180, 180 ) );
	offsetSpot = backangles + ( backangles[0] * level.thirdPersonOffset_back, backangles[1] * level.thirdPersonOffset_back, level.thirdPersonOffset_up );
	return offsetSpot;
}


// self = the trigger
covertest_thinkloop( mover, leftpoint, rightpoint )
{
	level.player endon( "player_leavecover" );

	if( !level.thirdPersonMode )
	{
		// which origin are we closer to?
		if( DistanceSquared( level.player.origin, leftpoint.origin ) < DistanceSquared( level.player.origin, rightpoint.origin ) )
		{
			// if left, angle view to the left
			mover covertest_angle_view( leftpoint, "left" );
		}
		else
		{
			// otherwise angle view to the right
			mover covertest_angle_view( rightpoint, "right");
		}
	}

	// figure out which entity to do edge distance checks against
	wallHugger = undefined;

	if( level.thirdPersonMode )
	{
		// in 3P, check against the avatar
		wallHuggerEnt = level.thirdPersonAvatar;
	}
	else
	{
		// in 1P, check against the player
		wallHuggerEnt = level.player;
	}

	// the loop
	while( 1 )
	{
		if( level.thirdPersonMode )
		{
			while( level.thirdPersonAvatar_isAiming )
			{
				wait( 0.05 );
			}

			while( level.thirdPersonAvatar_isBlindfiring )
			{
				wait( 0.05 );
			}

			while( level.thirdPersonAvatar_isReloading )
			{
				wait( 0.05 );
			}
		}

		// if the player hits the left direction...
		if( level.player buttonPressed( level.leftbutton ) )
		{
			//println( "caught left button input!" );

			// if we're facing right...
			if( level.lastview != "left" )
			{
				// angle view to the left
				mover covertest_angle_view( leftpoint, "left" );
			}
			// if we have room to move...
			else if( DistanceSquared( wallHuggerEnt.origin, leftpoint.origin ) > (level.stopSlideDist*level.stopSlideDist) )
			{
				// move to the right
				mover covertest_wall_slide( rightpoint, "left" );
			}
			// if we're at the edge...
			else if( DistanceSquared( wallHuggerEnt.origin, leftpoint.origin ) < (level.stopSlideDist*level.stopSlideDist) )
			{
				level notify( "covertest_hit_edge" );
			}
		}

		// if the player hits the right direction...
		else if( level.player buttonPressed( level.rightbutton ) )
		{
			//println( "caught right button input!" );

			// if we're facing left...
			if( level.lastview != "right" )
			{
				// angle view to the right
				mover covertest_angle_view( rightpoint, "right" );
			}
			// if we have room to move...
			else if( DistanceSquared( wallHuggerEnt.origin, rightpoint.origin ) > (level.stopSlideDist*level.stopSlideDist) )
			{
				//println( "player is " + Distance( level.player.origin, rightpoint.origin ) + "units from the edge." );

				// move to the right
				mover covertest_wall_slide( leftpoint, "right" );
			}
			// if we're at the edge...
			else if( DistanceSquared( wallHuggerEnt.origin, rightpoint.origin ) < (level.stopSlideDist*level.stopSlideDist) )
			{
				level notify( "covertest_hit_edge" );
			}
		}

		self covertest_check_interact_state( mover, leftpoint, rightpoint );

		// check our firing state and blindfire/reload/raise the camera if necessary
		covertest_check_fire_state( mover, leftpoint, rightpoint );

		wait 0.05;
	}
}


// checks to see if we should be traversing, etc.
// self = the trigger
covertest_check_interact_state( mover, leftpoint, rightpoint )
{
	level endon( "avatar_finished_traversing" );

	// figure out which entity to do edge distance checks against
	wallHugger = undefined;

	if( level.thirdPersonMode )
	{
		// in 3P, check against the avatar
		wallHuggerEnt = level.thirdPersonAvatar;
	}
	else
	{
		// in 1P, check against the player
		wallHuggerEnt = level.player;
	}

	if( level.player ButtonPressed( level.interactbutton ) )
	{
		if( level.thirdPersonMode )
		{
			// figure out how wide the cover is, so we can traverse over the correct distance
			movedist = 52;  // guessing the traversal distance.  needs to be farther than the wall so the player doesn't clip after moving!
			
			// make sure we only mantle on cover spots that allow it
			if( IsDefined( self.script_maxdist ) && self.script_maxdist > 0 )
			{
				movedist = self.script_maxdist + 36;
				//println( "the traversal distance will be: " + movedist );
			}
			else
			{
				println( "Can't mantle here!" );
				return;
			}

			avatarStartSpot = level.thirdPersonAvatar.origin;
			avatarStartAngles = level.thirdPersonAvatar.angles;

			level.thirdPersonAvatar thread covertest_thirdperson_avatar_animate( "crouch_mantle_over_cover" );
			
			// move the camera as the guy animates
			mover thread covertest_interact_movecamera( 26, 18, 2.1, 1.7 );

			level waittill( "avatar_starting_traverse" );

			// move the avatar forward as he traverses
			forward = AnglesToForward( avatarStartAngles );
			movespot = avatarStartSpot + ( forward[0] * movedist, forward[1] * movedist, 0 );

			level.thirdPersonAvatar MoveTo( movespot, level.thirdPersonAvatar_mantleTime );

			// just wait for the thread to die... this way we don't catch extra interact state inputs
			while( 1 )
			{
				wait( 1 );
			}
		}
	}
}

// self = the mover script_origin
covertest_interact_movecamera( zOffset, forwardOffset, movetime, movetime_accel )
{
	level endon( "avatar_finished_traversing" );

	forward = AnglesToForward( self.angles );
	movespot = self.origin + ( forward[0] * forwardOffset, forward[1] * forwardOffset, zOffset );

	self MoveTo( movespot, movetime, movetime_accel );
	self waittill( "movedone" );
}


covertest_check_fire_state( mover, leftpoint, rightpoint )
{
	// figure out which entity to do edge distance checks against
	wallHugger = undefined;

	if( level.thirdPersonMode )
	{
		// in 3P, check against the avatar
		wallHuggerEnt = level.thirdPersonAvatar;
	}
	else
	{
		// in 1P, check against the player
		wallHuggerEnt = level.player;
	}

	adsval = level.player playerads();

	if( adsval > 0.5 )
	{
		level.adsActive = true;

		// pop the player out of cover
		oldspot = mover.origin;
		popspot = undefined;

		// figure out whether to pop sideways or over the top
		// if we're close to one of the corners...
		if( DistanceSquared( wallHuggerEnt.origin, rightpoint.origin ) < ( level.stopSlideDist * level.stopSlideDist ) || DistanceSquared( wallHuggerEnt.origin, leftpoint.origin ) < ( level.stopSlideDist * level.stopSlideDist ) )
		{
			// we will do a sideways pop
			referenceOrg = Spawn( "script_origin", mover.origin );

			// if closer to the right, pop right
			if( DistanceSquared( wallHuggerEnt.origin, rightpoint.origin ) < DistanceSquared( wallHuggerEnt.origin, leftpoint.origin ) )
			{
				// use the right point for angles
				referenceOrg.angles = rightpoint.angles;

				rightangles = AnglesToRight( referenceOrg.angles );

				if( level.thirdPersonMode )
				{
					level.thirdPersonAvatar thread covertest_thirdperson_avatar_animate( "aim_around_cover_right" );
					level thread covertest_draw_crosshair();
					//wait( 1.0 );

					movespot = rightangles + ( rightangles[0] * level.adsPopSideDist_3P, rightangles[1] * level.adsPopSideDist_3P, 0 );
				}
				else
				{
					movespot = rightangles + ( rightangles[0] * level.adsPopSideDist_1P, rightangles[1] * level.adsPopSideDist_1P, 0 );
				}

				popspot = mover.origin + movespot;
			}
			// otherwise we're closer to the left
			else
			{
				// use the left point for angles
				referenceOrg.angles = leftpoint.angles;

				rightangles = AnglesToRight( referenceOrg.angles + ( 0, 180, 0 ) );

				if( level.thirdPersonMode )
				{
					level.thirdPersonAvatar thread covertest_thirdperson_avatar_animate( "aim_around_cover_left" );
					level thread covertest_draw_crosshair();
					//wait( 1.0 );

					movespot = rightangles + ( rightangles[0] * level.adsPopSideDist_3P, rightangles[1] * level.adsPopSideDist_3P, 0 );
				}
				else
				{
					movespot = rightangles + ( rightangles[0] * level.adsPopSideDist_1P, rightangles[1] * level.adsPopSideDist_1P, 0 );
				}

				popspot = mover.origin + movespot;
			}
		}

		// if not close to a corner, do an over-the-top pop
		else
		{
			// animate the third person avatar, if using 3P mode
			if( level.thirdPersonMode )
			{
				level.thirdPersonAvatar thread covertest_thirdperson_avatar_animate( "aim_over_cover" );

				// draw a crosshair, since ADS removes the weapon crosshair overlay
				level thread covertest_draw_crosshair();

				// slide the camera to the side a little bit while aiming over the top
				// TODO when our guy is ambidextrous with the gun, slide to the left as well... for now just slide right
				//if( level.lastview == "right" )
				//{
					referenceOrg = rightpoint;
					rightangles = AnglesToRight( referenceOrg.angles );
				//}
				//else
				//{
				//	referenceOrg = leftpoint;
				//	rightangles = AnglesToRight( referenceOrg.angles + ( 0, 180, 0 ) );
				//}

				// now set the 3P pop spot
				// apply sideways offset as well as vertical offset
				movespot = rightangles + ( rightangles[0] * level.thirdPersonOffset_side, rightangles[1] * level.thirdPersonOffset_side, level.adsPopUpDist_3P );
				popspot = mover.origin + movespot;

				//popspot = mover.origin + ( 0, 0, level.adsPopUpDist_3P );
			}
			else
			{
				// first-person mode
				popspot = mover.origin + ( 0, 0, level.adsPopUpDist_1P );
			}
		}

		mover MoveTo( popspot, level.adsPopTime );

		// wait for the ADS to finish
		while( adsval > 0.5 )
		{
			wait( 0.05 );
			adsval = level.player playerads();
		}

		level.adsActive = false;
		level notify( "destroy_crosshair" );

		// put the player back behind cover
		mover MoveTo( oldspot, level.adsPopTime );
	}

	// if ADS is not enabled...
	else
	{
		// if the player is pressing the fire button...
		if( level.player ButtonPressed( level.firebutton ) )
		{
			// handle blindfire for third person mode
			if( level.thirdPersonMode )
			{
				level.thirdPersonAvatar thread covertest_thirdperson_avatar_animate( "blindfire_over_cover" );

				while( level.thirdPersonAvatar_isBlindfiring )
				{
					wait( 0.05 );
				}
			}
		}
		// if the player started a reload...
		else if( level.player ButtonPressed( level.reloadbutton ) )
		{
			// handle reloading for third person mode
			if( level.thirdPersonMode )
			{
				level.thirdPersonAvatar thread covertest_thirdperson_avatar_animate( "crouch_reload" );

				while( level.thirdPersonAvatar_isReloading )
				{
					wait( 0.05 );
				}
			}
		}
		// if the player is pressing the grenade button...
		if( level.player ButtonPressed( level.grenadebutton ) )
		{
			// handle grenade tossing for third person mode
			if( level.thirdPersonMode )
			{
				level.thirdPersonAvatar thread covertest_thirdperson_avatar_animate( "crouch_grenade_over_cover" );

				level waittill( "grenade_throw_done" );
			}
		}
	}
}

// self is the mover script_origin
covertest_wall_slide( point, whichdir )
{
	movespot = undefined;
	movespot_avatar = undefined;
	movedist = level.slideIncrement_dist;
	movetime = level.slideIncrement_time;

	referenceOrg = Spawn( "script_origin", self.origin );
	referenceOrg.angles = point.angles;

	rightangles = undefined;

	if( whichdir == "right" )
	{
		//println( "move right" );
		rightangles = AnglesToRight( referenceOrg.angles );
	}
	else if( whichdir == "left" )
	{
		//println( "move left" );
		rightangles = AnglesToRight( referenceOrg.angles + ( 0, 180, 0 ) );
	}
	else
	{
		println( "ERROR, 'whichdir' is not defined or not recognized! aborting..." );
		return;
	}

	movedirection = rightangles + ( rightangles[0] * movedist, rightangles[1] * movedist, 0 );
	movespot = self.origin + movedirection;

	if( level.thirdPersonMode )
	{
		// we have to also move the third person avatar
		movespot_avatar = level.thirdPersonAvatar.origin + movedirection;
		level notify( "covertest_end_animloop" );

		if( !level.thirdPersonAvatar_isCrouchWalking )
		{
			level.thirdPersonAvatar thread covertest_thirdperson_avatar_animate( "crouchwalk" );
			wait( level.thirdPersonAvatar_rotateTime * 3.5 );
		}

		level.thirdPersonAvatar MoveTo( movespot_avatar, movetime );
	}

	self MoveTo( movespot, movetime );

	referenceOrg Delete();

	// TODO bob the view in 1st person cover mode
	//if( level.thirdPersonMode )
	//{
	//	level.player viewkick( 1, level.player.origin );
	//}

	//println( "-----" );
}


// self is the mover script_origin
covertest_angle_view( point, whichdir )
{
	anglevec = self.angles;

	if( whichdir == "left" )
	{
		//println( "angle left" );

		if( level.thirdPersonMode )
		{
			anglevec = ( point.angles[0], ( point.angles[1] + level.thirdPersonViewYaw ), point.angles[2] );
		}
		else
		{
			anglevec = ( point.angles[0], ( point.angles[1] + level.viewyaw ), point.angles[2] );
		}

		//println( "angle is "  + anglevec );
		level.lastview = "left";
	}
	else if( whichdir == "right" )
	{
		//println( "angle right" );

		if( level.thirdPersonMode )
		{
			anglevec = ( point.angles[0], ( point.angles[1] - level.thirdPersonViewYaw ), point.angles[2] );
		}
		else
		{
			anglevec = ( point.angles[0], ( point.angles[1] - level.viewyaw ), point.angles[2] );
		}

		//println( "angle is "  + anglevec );
		level.lastview = "right";
	}

	//self.angles = anglevec;
	self RotateTo( anglevec, level.viewRotateSpeed );
}

covertest_drawline( pt1, pt2 )
{
	self endon( "kill_lines" );

	color = ( 0, 255, 0 );

	while( 1 )
	{
		line( pt1.origin, pt2.origin, color );
		wait( 0.05 );
	}
}

covertest_drawline_to_player( origin1 )
{
	self endon( "kill_lines" );

	color = ( 0, 255, 0 );

	while( 1 )
	{
		line( level.player.origin, origin1, color );
		wait( 0.05 );
	}
}


vecscale(vec, scalar)
{
	return (vec[0]*scalar, vec[1]*scalar, vec[2]*scalar);
}

// traces a line to the ground and returns the position where the line hits the ground
ground_trace( origin )
{
	end_origin = ( ( origin + ( 0, 0, 32 ) ) + ( 0, 0, -1000 ) );

	// trace a result and put it in trace_result
	trace_result = BulletTrace( origin, end_origin, false, level.player );

	return trace_result["position"];
}


covertest_draw_crosshair()
{
	// setup "crosshair"
	crossHair = newHudElem();
	crossHair.location = 0;
	crossHair.alignX = "center";
	crossHair.alignY = "middle";
	crossHair.foreground = 1;
	crossHair.fontScale = 2;
	crossHair.sort = 20;
	crossHair.alpha = 1;
	crossHair.x = 320;
	crossHair.y = 233;
	crossHair setText(".");

	level waittill( "destroy_crosshair" );

	if( IsDefined( crossHair ) )
	{
		crossHair Destroy();
	}
}
