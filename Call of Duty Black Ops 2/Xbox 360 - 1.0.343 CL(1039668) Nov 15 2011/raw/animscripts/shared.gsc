// Shared.gsc - Functions that are shared between animscripts and level scripts.  
// Functions in this file can't rely on the animscripts\init function having run, and can't call any 
// functions not allowed in level scripts.

#include maps\_utility;
#include animscripts\utility;
#include animscripts\combat_utility;
#include animscripts\anims;
#include common_scripts\utility;

#insert raw\common_scripts\utility.gsh;

#using_animtree ("generic_human");

placeWeaponOn( weapon, position )
{	
	//assert( AIHasWeapon( weapon ) ); // removed to support script_dropweapon
	// This allows any weapon to be attached even if we don't start out with this weapon

	// AI_TODO: update anim set for new weapon?
	
	self notify("weapon_position_change");

	if (!IsDefined(self.weaponInfo[weapon]))
	{
		self call_overloaded_func( "animscripts\init", "initWeapon", weapon );
	}
	
	curPosition = self.weaponInfo[weapon].position;
	
	// make sure we're not out of sync
	assert( curPosition == "none" || self.a.weaponPos[curPosition] == weapon );
	
	// weapon already in place
	if ( position != "none" && self.a.weaponPos[position] == weapon )
	{
		return;
	}
	
	//println("detach all (" + weapon + ", " + position + ")"); // ALEXP_PRINT
	self detachAllWeaponModels();
	
	// detach if we're already in a position
	if ( curPosition != "none" )
	{
		self detachWeapon( weapon );
	}
		
	// nothing more to do
	if ( position == "none" )
	{
		//println("update(1) all (" + weapon + ", " + position + ")"); // ALEXP_PRINT
		self updateAttachedWeaponModels();
	
		// Update the weapon distances used for weapon switching, as the weapon loadout changed.
		call_overloaded_func( "animscripts\init", "SetWeaponDist" );	

		return;
	}

	if ( self.a.weaponPos[position] != "none" )
	{
		self detachWeapon( self.a.weaponPos[position] );
	}

	// to ensure that the correct tags for the active weapon are used, we need to make sure it gets attached first
	if ( position == "left" || position == "right" )
	{
		self attachWeapon( weapon, position );
		self.weapon = weapon;

		self animscripts\anims::clearAnimCache();
		
		self.aimThresholdYaw = 10;
		self.aimThresholdPitch = 20;

		if( weaponIsGasWeapon( self.weapon ) )
		{
			self.aimThresholdYaw = 25;
			self.aimThresholdPitch = 25;
		}
	}
	else
	{
		self attachWeapon( weapon, position );
	}

	//println("update(2) all (" + weapon + ", " + position + ")"); // ALEXP_PRINT
	self updateAttachedWeaponModels();

	// Update the weapon distances used for weapon switching, as the weapon loadout changed.
	call_overloaded_func( "animscripts\init", "SetWeaponDist" );	
	
	// make sure we don't have a weapon in each hand
	assert( self.a.weaponPos["left"] == "none" || self.a.weaponPos["right"] == "none" );
}	

detachWeapon( weapon )
{
	self.a.weaponPos[self.weaponInfo[weapon].position] = "none";
	self.weaponInfo[weapon].position = "none";
}


attachWeapon( weapon, position )
{
	self.weaponInfo[weapon].position = position;
	self.a.weaponPos[position] = weapon;
}

detachAllWeaponModels()
{
	if( isdefined(self.weapon_positions) )
	{
		for ( index = 0; index < self.weapon_positions.size; index++ )
		{
			weapon = self.a.weaponPos[self.weapon_positions[index]];
			
			if ( weapon == "none" )
			{
				continue;
			}
				
			self detach( getWeaponModel( weapon ), getTagForPos( self.weapon_positions[index] ) );
		}
	}
}

updateAttachedWeaponModels()
{
	if( isdefined(self.weapon_positions) )
	{
		for ( index = 0; index < self.weapon_positions.size; index++ )
		{
			weapon = self.a.weaponPos[self.weapon_positions[index]];
			
			if ( weapon == "none" )
			{
				continue;
			}
				
			self attach( getWeaponModel( weapon ), getTagForPos( self.weapon_positions[index] ) );

			if ( self.weaponInfo[weapon].useClip && !self.weaponInfo[weapon].hasClip )
			{
				self hidepart( "tag_clip" );
			}
		}
	}
}

getTagForPos( position )
{
	switch ( position )
	{
		case "chest":
			return "tag_weapon_chest";
		case "back":
			return "tag_stowed_back";
		case "left":
			return "tag_weapon_left";
		case "right":
			return "tag_weapon_right";
		case "hand":
			return "tag_inhand";
		default:
			assertMsg( "unknown weapon placement position: " + position );
		break;
	}
}

DropAIWeapon()
{
	if (IS_TRUE(self.a.dropping_weapons))
	{
		// already dropping all weapons
		return;
	}

	if( self.weapon == "none" || self.weapon == "")
	{
		return;
	}

	if (IS_TRUE(self.script_nodropsecondaryweapon) && (self.weapon == self.initial_secondaryweapon))
	{
		PrintLn("Not dropping secondary weapon '" + self.weapon + "'");
		return;
	}
	else if (IS_TRUE(self.script_nodropsidearm) && (self.weapon == self.sidearm))
	{
		PrintLn("Not dropping sidearm '" + self.weapon + "'");
		return;
	}

	// This assumes we are dying, so if you call DropAIWeapon on a guy who has two weapons
	// and isn't dying, his secondary weapon may be swapped instead of the one we are dropping.
	self swapDropWeapon();

	current_weapon = self.weapon;
	position = self.weaponInfo[ current_weapon ].position;

	if( IsDefined( current_weapon ) && current_weapon != "none" )
	{
		animscripts\shared::placeWeaponOn( current_weapon, "none" );

		if( current_weapon == self.primaryweapon )
		{
			self.primaryweapon = "none";
		}
		else if( current_weapon == self.secondaryweapon )
		{
			self.secondaryweapon = "none";			
		}
	}
		
	if( self.dropWeapon )
	{
		dropWeaponName = player_weapon_drop(self.weapon);

		velocity = self GetAiVelocity();
		speed = Length( velocity ) * 0.5;

		droppedWeapon = self DropWeapon( dropWeaponName, position, speed );
	}

	self.weapon = "none";
}

DropAllAIWeapons()
{
	if (IS_TRUE(self.a.dropping_weapons))
	{
		// already called
		return;
	}

	if( !self.dropweapon )
	{
		if( self.weapon != "none" )
		{
			animscripts\shared::placeWeaponOn( self.weapon, "none" );
			self.weapon = "none";
		}

		return;
	}

	self.a.dropping_weapons = true;
	
	self swapDropWeapon();
	self detachAllWeaponModels();
	
	if( isdefined(self.weapon_positions) )
	{
		for ( index = 0; index < self.weapon_positions.size; index++ )
		{
			weapon = self.a.weaponPos[ self.weapon_positions[ index ] ];

			if ( weapon != "none" )
			{
				self.weaponInfo[ weapon ].position = "none";			
				self.a.weaponPos[ self.weapon_positions[ index ] ] = "none";

				if (IS_TRUE(self.script_nodropsecondaryweapon) && (weapon == self.initial_secondaryweapon))
				{
					PrintLn("Not dropping secondary weapon '" + weapon + "'");
				}
				else if (IS_TRUE(self.script_nodropsidearm) && (weapon == self.sidearm))
				{
					PrintLn("Not dropping sidearm '" + weapon + "'");
				}
				else
				{
					weapon = player_weapon_drop(weapon);

					velocity = self GetAiVelocity();
					speed = Length( velocity ) * 0.5;

					droppedWeapon = self DropWeapon( weapon, self.weapon_positions[ index ], speed );
				}
			}
		}
	}
	
	self.weapon = "none";

	self.a.dropping_weapons = undefined;
}

swapDropWeapon()
{
	if (has_script_drop_weapon())
	{
		found_weapon = false;
		for ( i = 0; i < self.weapon_positions.size; i++ )
		{
			weapon = self.a.weaponPos[ self.weapon_positions[ i ] ];

			weapon_toks = StrTok(weapon, "_");
			drop_weapon_toks = StrTok(self.script_dropweapon, "_");

			if ( weapon_toks[0] == drop_weapon_toks[0] )
			{
				PrintLn("Swapping out weapon '" + weapon + "' for script_dropweapon '" + self.script_dropweapon + "'");

				self placeWeaponOn(weapon, "none");
				
				if (self.weapon == weapon)
				{
					// if the weapon we are swapping is the current weapon, make our current weapon the drop weapon
					self.weapon = self.script_dropweapon;
				}

				self placeWeaponOn(self.script_dropweapon, self.weapon_positions[i]);
				found_weapon = true;

				break;
			}
		}

		if (!found_weapon)
		{
			self swapDropWeaponPrimary();			
		}

		// Once we swapped, don't do it again
		self.script_dropweapon = undefined;
	}
}

swapDropWeaponPrimary()
{
	if (has_script_drop_weapon())
	{
		position = self.weaponInfo[ self.primaryweapon ].position;
		if (position != "none")
		{
			PrintLn("Swapping out weapon '" + self.primaryweapon + "' for script_dropweapon '" + self.script_dropweapon + "'");

			self placeWeaponOn(self.primaryweapon, "none");
			self placeWeaponOn(self.script_dropweapon, position);
			//self.weapon = self.script_dropweapon;
		}
	}
}

addPhysWeapon()
{
	self thread deleteAtLimit();
}

has_script_drop_weapon()
{
	if (IsDefined(self.script_dropweapon) && IsString(self.script_dropweapon) && (self.script_dropweapon != ""))
	{
		return true;
	}

	return false;
}

player_weapon_drop(weapon_name)
{
	if (IsSubStr( ToLower( weapon_name ), "rpg" ))
	{
		return "rpg_player_sp";
	}
	else if (IsSubStr( ToLower( weapon_name ), "panzerschreck" ))
	{
		return "panzerschreck_player_sp";
	}
	
	return weapon_name;
}

deleteAtLimit()
{
	wait 30.0;
	
	self delete();
}

/#
showNoteTrack( note )
{
	if ( GetDebugDvar("scr_shownotetracks") != "on" && getdebugdvarint("scr_shownotetracks") != self getentnum() )
	{
		return;
	}
	
	self endon("death");
	
	anim.showNotetrackSpeed = 30; // units/sec
	anim.showNotetrackDuration = 30; // frames
	
	if ( !IsDefined( self.a.shownotetrackoffset ) )
	{
		thisoffset = 0;
		self.a.shownotetrackoffset = 10;
		self thread reduceShowNotetrackOffset();
	}
	else
	{
		thisoffset = self.a.shownotetrackoffset;
		self.a.shownotetrackoffset += 10;
	}
	
	duration = anim.showNotetrackDuration + int(20.0 * thisoffset / anim.showNotetrackSpeed);
	
	color = (.5,.75,1);
	if ( note == "end" || note == "finish" )
	{
		color = (.25,.4,.5);
	}
	else if ( note == "undefined" )
	{
		color = (1,.5,.5);
	}
	
	for ( i = 0; i < duration; i++ )
	{
		if ( duration - i <= anim.showNotetrackDuration )
		{
			amnt = 1.0 * (i - (duration - anim.showNotetrackDuration)) / anim.showNotetrackDuration;
		}
		else
		{
			amnt = 0.0;
		}

		time = 1.0 * i / 20;
		
		alpha = 1.0 - amnt*amnt;
		pos = self geteye() + (0, 0, 20 + anim.showNotetrackSpeed * time - thisoffset);
		
		Print3d( pos, note, color, alpha );
		
		wait .05;
	}
}
reduceShowNotetrackOffset()
{
	self endon("death");

	while( self.a.shownotetrackoffset > 0 )
	{
		wait .05;
		self.a.shownotetrackoffset -= anim.showNotetrackSpeed * .05;
	}

	self.a.shownotetrackoffset = undefined;
}
#/

HandleDogSoundNoteTracks( note )
{
	if ( note == "sound_dogstep_run_default" )
	{
		self PlaySound( "fly_dog_step_run_default" );
		return true;
	}

	prefix = getsubstr( note, 0, 5 );

	if ( prefix != "sound" )
	{
		return false;
	}

	alias = "aml" + getsubstr( note, 5 );

	//	if ( growling() && !issubstr( alias, "growl" ) )
	//		return false;

	if ( IsAlive( self ) )
	{
		self thread play_sound_on_tag_endon_death( alias, "tag_eye" );
	}
	else
	{
		self thread play_sound_in_space( alias, self gettagorigin( "tag_eye" ) );
	}

	return true;
}

registerNoteTracks()
{
	anim.notetracks["anim_pose = \"stand\""] = ::noteTrackPoseStand;
	anim.notetracks["anim_pose = \"crouch\""] = ::noteTrackPoseCrouch;
	anim.notetracks["anim_pose = \"prone\""] = ::noteTrackPoseProne;
	anim.notetracks["anim_pose = \"crawl\""] = ::noteTrackPoseCrawl;
	anim.notetracks["anim_pose = \"back\""] = ::noteTrackPoseBack;

	anim.notetracks["anim_movement = \"stop\""] = ::noteTrackMovementStop;
	anim.notetracks["anim_movement = \"walk\""] = ::noteTrackMovementWalk;
	anim.notetracks["anim_movement = \"run\""] = ::noteTrackMovementRun;

	anim.notetracks["anim_aiming = 1"] = ::noteTrackAlertnessAiming;
	anim.notetracks["anim_aiming = 0"] = ::noteTrackAlertnessAlert;
	anim.notetracks["anim_alertness = causal"] = ::noteTrackAlertnessCasual;
	anim.notetracks["anim_alertness = alert"] = ::noteTrackAlertnessAlert;
	anim.notetracks["anim_alertness = aiming"] = ::noteTrackAlertnessAiming;
	
	anim.notetracks["gunhand = (gunhand)_left"] = ::noteTrackGunhand;
	anim.notetracks["anim_gunhand = \"left\""] = ::noteTrackGunhand;
	anim.notetracks["anim_gunhand = \"leftright\""] = ::noteTrackGunhand;
	anim.notetracks["gunhand = (gunhand)_right"] = ::noteTrackGunhand;
	anim.notetracks["anim_gunhand = \"right\""] = ::noteTrackGunhand;	
	anim.notetracks["anim_gunhand = \"none\""] = ::noteTrackGunhand;	
	anim.notetracks["gun drop"] = ::noteTrackGunDrop;
	anim.notetracks["dropgun"] = ::noteTrackGunDrop;

	anim.notetracks["gun_2_chest"] = ::noteTrackGunToChest;	
	anim.notetracks["gun_2_back"] = ::noteTrackGunToBack;	
	anim.notetracks["chest_2_back"] = ::noteTrackChestToBack;
	anim.notetracks["pistol_pickup"] = ::noteTrackPistolPickup;
	anim.notetracks["pistol_putaway"] = ::noteTrackPistolPutaway;
	anim.notetracks["drop clip"] = ::noteTrackDropClip;
	anim.notetracks["refill clip"] = ::noteTrackRefillClip;
	anim.notetracks["reload done"] = ::noteTrackRefillClip;
	anim.notetracks["load_shell"] = ::noteTrackLoadShell;
	anim.notetracks["pistol_rechamber"] = ::noteTrackPistolRechamber;
	anim.notetracks["weapon_switch"] = ::noteTrackWeaponSwitch;
	//anim.notetracks["glint"] = ::noteTrackWeaponSwitchGlint;
	
	anim.notetracks["gravity on"] = ::noteTrackGravity;
	anim.notetracks["gravity off"] = ::noteTrackGravity;

	anim.notetracks["bodyfall large"] = ::noteTrackBodyFall;
	anim.notetracks["bodyfall small"] = ::noteTrackBodyFall;
	
	anim.notetracks["footstep"] = ::noteTrackFootStep;
	anim.notetracks["step"] = ::noteTrackFootStep;
	anim.notetracks["footstep_right_large"] = ::noteTrackFootStep;
	anim.notetracks["footstep_right_small"] = ::noteTrackFootStep;
	anim.notetracks["footstep_left_large"] = ::noteTrackFootStep;
	anim.notetracks["footstep_left_small"] = ::noteTrackFootStep; 
	anim.notetracks["footscrape"] = ::noteTrackFootScrape; 
	anim.notetracks["land"] = ::noteTrackLand;
	
//	anim.notetracks["laser_on"] = ::noteTrackLaser;
//	anim.notetracks["laser_off"] = ::noteTrackLaser;
	
	anim.notetracks["start_ragdoll"] = ::noteTrackStartRagdoll;

	anim.notetracks["fire"] = ::noteTrackFire;
	anim.notetracks["fire_spray"] = ::noteTrackFireSpray;
	anim.notetracks["fire spray"] = ::noteTrackFireSpray;
	anim.notetracks["lookat = \"player\""] = ::noteTrackLookatPlayer;
	anim.notetracks["headlookat = \"player\""] =::noteTrackHeadLookatPlayer;
	anim.notetracks["lookat = \"\""] = ::noteTrackClearLookAt;
	
	anim.notetracks["hide"] = ::noteTrackHide;
	anim.notetracks["show"] = ::noteTrackShow;
}

noteTrackHide( note, flagname )
{
	self Hide();
	self notify( "hide" );
}

noteTrackShow( note, flagname )
{
	self Show();
	self notify( "show" );
}

noteTrackLookAtPlayer(note, flagName)
{
	if(!IsSentient(self))
	{
		return;
	}
	
	relax_ik_headtracking_limits();
	
	self.lookat_set_in_anim = true;
	
	self LookAtEntity(get_players()[0]);
}

noteTrackHeadLookAtPlayer(note, flagName)
{
	if(!IsSentient(self))
	{
		return;
	}
	
	relax_ik_headtracking_limits();
	
	SetSavedDvar("ik_dvar_lookatentity_notorso", true);
	
	self.lookat_set_in_anim = true;
	
	self LookAtEntity(get_players()[0]);
}

noteTrackClearLookAt(note, flagName)
{
	if(!IsSentient(self))
	{
		return;
	}
	
	restore_ik_headtracking_limits();
	
	self.lookat_set_in_anim = false;
	
	SetSavedDvar("ik_dvar_lookatentity_notorso", false);
	
	self LookAtEntity();
}

noteTrackFire( note, flagName )
{
	// SCRIPTER_MOD: JesseS (10/7/2007): added since playing anim_loop on a spawned in
	// drone guy with fire notetracks wanted a bunch of extra stuff setup
	if (!IsSentient(self))
	{
		return;
	}

	if ( IsDefined( anim.fire_notetrack_functions[ self.a.script ] ) )
	{
		thread [[ anim.fire_notetrack_functions[ self.a.script ] ]]();
	}
	else
	{
		thread [[ animscripts\shared::shootNotetrack ]]();
	}
}

//noteTrackLaser( note, flagName )
//{
//	if ( isSubStr( note, "on" ) )
//		self.a.laserOn = true;
//	else
//		self.a.laserOn = false;
//	self animscripts\shared::updateLaserStatus();
//}


noteTrackStopAnim( note, flagName )
{
}

noteTrackStartRagdoll( note, flagName )
{
	if( IsDefined( self.noragdoll ) )
	{
		return; // Nate - hack for armless zakhaev who doesn't do ragdoll
	}

	self do_ragdoll_death();
}

noteTrackMovementStop( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.movement = "stop";
	}
}

noteTrackMovementWalk( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.movement = "walk";
	}
}

noteTrackMovementRun( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.movement = "run";
	}
}


noteTrackAlertnessAiming( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.alertness = "aiming";
	}
}

noteTrackAlertnessCasual( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.alertness = "casual";
	}
}

noteTrackAlertnessAlert( note, flagName )
{
	if( IsSentient( self ) )
	{
		self.a.alertness = "alert";
	}
}


noteTrackPoseStand( note, flagName )
{
	if( IsSentient( self ) )
	{
		if (self.a.pose == "prone")
		{
			self OrientMode ("face default");	// We were most likely in "face current" while we were prone.
			self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
	//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		}

		self.a.pose = "stand";
		self notify ("entered_pose" + "stand");
	}
}

noteTrackPoseCrouch( note, flagName )
{
	if( IsSentient( self ) )
	{
		if (self.a.pose == "prone")
		{
			self OrientMode ("face default");	// We were most likely in "face current" while we were prone.
			self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
	//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		}

		self.a.pose = "crouch";
		self notify ("entered_pose" + "crouch");

		if (self.a.crouchPain)
		{
			// for dying pain
			self.a.crouchPain = false;
			self.health = 150;
		}
	}
}

noteTrackPoseProne( note, flagName )
{
	if( IsSentient( self ) )
	{
		self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_aiming, %prone_legs_up );
		self EnterProneWrapper(1.0); // make code start lerping in the prone orientation to ground
		self.a.pose = "prone";
		self notify ("entered_pose" + "prone");
	}
}


noteTrackPoseCrawl( note, flagName )
{
	if( IsSentient( self ) )
	{
		self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_aiming, %prone_legs_up );
		self EnterProneWrapper(1.0); // make code start lerping in the prone orientation to ground
		self.a.pose = "prone";
		self notify ("entered_pose" + "prone");
	}
}


noteTrackPoseBack( note, flagName )
{
	if (self.a.pose == "prone")
	{
		self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
		//self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	}

	self.a.pose = "back";
	self notify ("entered_pose" + "back");
	self.a.movement = "stop";
}


noteTrackGunHand( note, flagName )
{
	if ( isSubStr( note, "leftright" ) )
	{
		animscripts\shared::placeWeaponOn( self.weapon, "left" );
		self thread placeWeaponOnRightOnInterrupt();
	}
	else if ( isSubStr( note, "left" ) )
	{
		animscripts\shared::placeWeaponOn( self.weapon, "left" );
		self notify( "placed_weapon_on_left" );
	}
	else if ( isSubStr( note, "right" ) )
	{
		animscripts\shared::placeWeaponOn( self.weapon, "right" );
		self notify( "placed_weapon_on_right" );
	}
	else if ( isSubStr( note, "none" ) )
	{
		animscripts\shared::placeWeaponOn( self.weapon, "none" );
	}
}

placeWeaponOnRightOnInterrupt( )
{
	self endon( "death" );
	self endon( "placed_weapon_on_right" );
	
	self waittill( "killanimscript" );

	// For whatever reason, the AI may not have the weapon specified
	// in its weapon field (according to the definition of AIHasWeapon())
	// after a killanimscript notify.
	if ( AIHasWeapon( self.weapon ) )
	{
		animscripts\shared::placeWeaponOn( self.weapon, "right" );
	}
}

noteTrackGunDrop( note, flagName )
{
	// save these here, because DropAIWeapon sets them to "none"
	self.lastWeapon		= self.weapon;
	primaryweapon		= self.primaryweapon;
	secondaryweapon		= self.secondaryweapon;
	pistolOnlyAI		= AIHasOnlyPistol();

	self animscripts\shared::DropAIWeapon();
		
	if ( self.lastWeapon == primaryweapon )
	{
		self.weapon = self.secondaryweapon;
	}
	else if ( self.lastWeapon == secondaryweapon )
	{
		self.weapon = self.primaryweapon;
	}

	self animscripts\anims::clearAnimCache();
}


noteTrackGunToChest( note, flagName )
{
	//assert( !usingSidearm() );
	animscripts\shared::placeWeaponOn( self.weapon, "chest" );
}


noteTrackGunToBack( note, flagName )
{
	animscripts\shared::placeWeaponOn( self.weapon, "back" );
	// TODO: more asserts and elegant handling of weapon switching here
	self.weapon = self getPreferredWeapon();
	self.bulletsInClip = weaponClipSize( self.weapon );

	self animscripts\anims::clearAnimCache();
}

noteTrackChestToBack( note, flagName )
{
	assert( hasSecondaryWeapon() );
	animscripts\shared::placeWeaponOn( getSecondaryWeapon(), "back" );
}

noteTrackPistolPickup( note, flagName )
{
	if( AIHasSidearm() )
	{
		animscripts\shared::placeWeaponOn( self.sidearm, "right" );
		self.bulletsInClip = weaponClipSize( self.weapon );
		self notify ( "weapon_switch_done" );
	}
}

	
noteTrackPistolPutaway( note, flagName )
{
	animscripts\shared::placeWeaponOn( self.weapon, "none" );
	// TODO: more asserts and elegant handling of weapon switching here
	self.weapon = self getPreferredWeapon();
	self.bulletsInClip = weaponClipSize( self.weapon );

	self animscripts\anims::clearAnimCache();
}

noteTrackWeaponSwitch( note, flagName )
{
	assert( hasSecondaryWeapon(), "no secondary weapon available! check the aitype for this actor. " );

	if( self.weapon == self.primaryweapon )
	{
		if( self.weapon != "none" )
		{
			self animscripts\shared::placeWeaponOn( self.weapon, "back" );
		}

		self animscripts\shared::placeWeaponOn( self.secondaryweapon, "right" );
	}
	else
	{
		if( self.weapon != "none" )
		{
			self animscripts\shared::placeWeaponOn( self.weapon, "back" );
		}

		self animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );
	}

	clipSize = 	weaponClipSize( self.weapon );

	// In exposed combat AI reloads when clip is completely empty (0 threshold). We dont want the AI to reload 
	// right after the switching happens cause that would make it look stupid. In non-exposed, such as cover and 
	// corner it doesnt matter if reload happens after switching.
	if (NeedToReload( 0.5 ))
	{
		// Check if the weaponclipsize is more than 1, then only we will be able to give him 50% clip.
		// This is a special case of rpg weapon type right now as RPG has a clipsize on 1.

		if(clipSize > 1)
		{
			self.bulletsInClip = Int(clipSize * 0.5);
		}
		else
		{
			self.bulletsInClip = clipSize;
		}
	}
	else if( self.bulletsInClip > clipSize )
	{
		// AI_TODO: bulletsInClip needs to work on a per-weapon basis
		// this is just temporary to fix the switch to an RPG
		self.bulletsInClip = clipSize;
	}

	self notify( "complete_weapon_switch" );
	noteTrackWeaponSwitchGlint( note, flagName );

	// Update the last weapon
	self.lastWeapon = self.weapon;	

}

noteTrackWeaponSwitchGlint( note, flagName )
{
	// AP_MOD 5/11/09 - commented out because switch can happen after one weapon was dropped
	//assert( hasSecondaryWeapon(), "no secondary weapon available! check the aitype for this actor. " );

	// AI_TODO : This is currently being worked on and not finished yet.
	// - we should find a better way to know if the weapon is of sniper type. 
	//   Currently, all we can do is to add the weapon
	//   to anim.sniperRifles list and query that list with isSniperRifle function.
	// - Add weapon specific effects one we come up with design
	if (IsDefined(self.weapon))
	{
		//PlayFXOnTag( anim._effect[ "dragunov_switch" ], self, "tag_weapon_right" );
	}
			
}

noteTrackDropClip( note, flagName )
{
	self thread handleDropClip( flagName );
}

noteTrackRefillClip( note, flagName )
{
	if ( weaponClass( self.weapon ) == "rocketlauncher" )
	{
		self showRocket();
	}

	self animscripts\weaponList::RefillClip();
}

noteTrackLoadShell( note, flagName )
{
	//Kevin commenting these out to prevent new naming convention breaks.  These will eventually be taken out.
	//self PlaySound("wpn_reload_shotgun_loop_npc");
}

noteTrackPistolRechamber( note, flagName )
{
	//Kevin commenting these out to prevent new naming convention breaks.  These will eventually be taken out.
	//self PlaySound("wpn_reload_pistol_chamber_npc");
}

noteTrackGravity( note, flagName )
{
	if ( isSubStr( note, "on" ) )
	{
        self AnimMode( "gravity" );
	}
	else if ( isSubStr( note, "off" ) )
	{
		self AnimMode( "nogravity" );
	}
}

noteTrackBodyFall( note, flagName )
{
	if ( IsDefined( self.groundType ) )
	{
		groundType = self.groundType;
	}
	else
	{
		groundType = "dirt";
	}
		
	if ( isSubStr( note, "large" ) )
	{
		self PlaySound ("fly_bodyfall_large_" + groundType);
	}
	else if ( isSubStr( note, "small" ) )
	{
		self PlaySound ("fly_bodyfall_small_" + groundType);
	}
}

noteTrackFootStep( note, flagName )
{
	// CODER_MOD - DSL - 03/28/08
	// Moved footsteps over to client side - clientscripts/_footsteps.csc
}


noteTrackFootScrape( note, flagName )
{
	if ( IsDefined( self.groundType ) )
	{
		groundType = self.groundType;
	}
	else
	{
		groundType = "dirt";
	}
		
	self PlaySound ("fly_step_scrape_" + groundType );
}

	
noteTrackLand( note, flagName )
{
	if ( IsDefined( self.groundType ) )
	{
		groundType = self.groundType;
	}
	else
	{
		groundType = "dirt";
	}
	
	if(IsPlayer ( self ))
	{
		self PlaySound ("fly_land_plr_" + groundType );
	}
	else
	{
		self PlaySound ("fly_land_npc_"	+ groundType);
	}
}

HandleNoteTrack( note, flagName, customFunction, var1 )
{
	/#
	self thread showNoteTrack( note );
	#/
	
	if ( isAI( self ) && self.isdog )
	{
		if ( HandleDogSoundNoteTracks( note ) )
		{
			return;
		}
	}
	
	//handles VO notetracks
	a_vo_note = StrTok( note, "#" );
	if( a_vo_note[0] == "vox" )
	{
		assert( IsDefined( a_vo_note[1] ), "VO alias not defined after a #vox notetrack" );
		
		if ( IsDefined( level.scr_sound["generic"] ) && IsDefined ( level.scr_sound["generic"][a_vo_note[1]] ) )
		{
			self PlaySound( level.scr_sound["generic"][a_vo_note[1]] );
		}
	}
	
	notetrackFunc = anim.notetracks[note];
	if ( IsDefined( notetrackFunc ) )
	{
		return [[notetrackFunc]]( note, flagName );
	}
	
	switch ( note )
	{
	case "end":
	case "finish":
	case "undefined":
		return note;


	case "swish small":
		self thread play_sound_in_space ("wpn_melee_swing_large", self gettagorigin ("TAG_WEAPON_RIGHT"));
		break;
	case "swish large":
		self thread play_sound_in_space ("wpn_melee_swing_large", self gettagorigin ("TAG_WEAPON_RIGHT"));
		//self thread play_sound_in_space ("melee_swing_large", self gettagorigin ("TAG_WEAPON_RIGHT"));
		break;
		
	case "rechamber":
		// if ( self usingShotgun() )
		//Kevin commenting these out to prevent new naming convention breaks.  These will eventually be taken out.
		//self PlaySound("weap_reload_shotgun_pump_npc");

		break;
	case "no death":
		// does not play a death anim when he dies
		self.a.nodeath = true;
		break;
	case "no pain":
		self disable_pain();
		break;		
	case "allow pain":
		self enable_pain();
		break;
	case "anim_melee = right":
	case "anim_melee = \"right\"":
		self.a.meleeState = "right";
		break;
	case "anim_melee = left":
	case "anim_melee = \"left\"":
		self.a.meleeState = "left";
		break;
	case "weapon_retrieve":
	/*
		assert( IsDefined( self.oldWeapon ), "Tried to do notetrack weapon_retrieve but pistol_pickup had never been used" );
		self.secondaryWeapon = self.weapon;
		self.weapon = self.oldWeapon;
		self animscripts\shared::PutGunInHand("right");
		*/
		break;
	case "swap taghelmet to tagleft":
		if ( IsDefined ( self.hatModel ) )
		{
			if (IsDefined(self.helmetSideModel))
			{
				self detach(self.helmetSideModel, "TAG_HELMETSIDE");
				self.helmetSideModel = undefined;
			}
			self detach ( self.hatModel, "");
			self attach ( self.hatModel, "TAG_WEAPON_LEFT");
			self.hatModel = undefined;
		}
		break;
	case "stop anim":
		anim_stopanimscripted();
		return note;
//		break;
	default:
		if (IsDefined(customFunction))
		{
			if (!IsDefined(var1))
			{
				return [[customFunction]] (note);
			}
			else
			{
				return [[customFunction]] (note, var1);
			}
		}
		break;
	}
}

// DoNoteTracks waits for and responds to standard noteTracks on the animation, returning when it gets an "end" or a "finish"
// For level scripts, a pointer to a custom function should be passed as the second argument, which handles notetracks not
// already handled by the generic function. This call should take the form DoNoteTracks(flagName, ::customFunction);
// The custom function will be called for each notetrack not recognized, and will pass the notetrack name. Note that this
// function could be called multiple times for a single animation.
DoNoteTracks( flagName, customFunction, debugIdentifier, var1 ) // debugIdentifier isn't even used. we should get rid of it.
{
	for (;;)
	{
		self waittill (flagName, note);

		if ( !IsDefined( note ) )
		{
			note = "undefined";
		}

		val = self HandleNoteTrack( note, flagName, customFunction, var1 );
		
		if ( IsDefined( val ) )
		{
			return val;
		}
	}
}


DoNoteTracksIntercept( flagName, interceptFunction, debugIdentifier ) // debugIdentifier isn't even used. we should get rid of it.
{
	assert( IsDefined( interceptFunction ) );
	
	for (;;)
	{
		self waittill ( flagName, note );

		if ( !IsDefined( note ) )
		{
			note = "undefined";
		}

		intercepted = [[interceptFunction]]( note );
		if ( IsDefined( intercepted ) && intercepted )
		{
			continue;
		}

		val = self HandleNoteTrack( note, flagName );
		
		if ( IsDefined( val ) )
		{
			return val;
		}
	}
}


DoNoteTracksPostCallback( flagName, postFunction )
{
	assert( IsDefined( postFunction ) );
	
	for (;;)
	{
		self waittill ( flagName, note );

		if ( !IsDefined( note ) )
		{
			note = "undefined";
		}

		val = self HandleNoteTrack( note, flagName );
		
		[[postFunction]]( note );
		
		if ( IsDefined( val ) )
		{
			return val;
		}
	}
}

// Don't call this function except as a thread you're going to kill - it lasts forever.
DoNoteTracksForever(flagName, killString, customFunction, debugIdentifier)
{
	DoNoteTracksForeverProc( ::DoNoteTracks, flagName, killString, customFunction, debugIdentifier);
}

DoNoteTracksForeverIntercept(flagName, killString, interceptFunction, debugIdentifier)
{
	DoNoteTracksForeverProc( ::DoNoteTracksIntercept, flagName, killString, interceptFunction, debugIdentifier );
}

DoNoteTracksForeverProc( notetracksFunc, flagName, killString, customFunction, debugIdentifier )
{
	if (IsDefined (killString))
	{
		self endon (killString);
	}

	self endon ("killanimscript");
	
	if (!IsDefined(debugIdentifier))
	{
		debugIdentifier = "undefined";
	}

	for (;;)
	{
		time = GetTime();
		returnedNote = [[notetracksFunc]](flagName, customFunction, debugIdentifier);
		timetaken = GetTime() - time;
		if ( timetaken < 0.05)
		{
			time = GetTime();
			returnedNote = [[notetracksFunc]](flagName, customFunction, debugIdentifier);
			timetaken = GetTime() - time;
			if ( timetaken < 0.05)
			{
				println (GetTime()+" "+debugIdentifier+" animscripts\shared::DoNoteTracksForever is trying to cause an infinite loop on anim "+flagName+", returned "+returnedNote+".");
				wait ( 0.05 - timetaken );
			}
		}
		//(GetTime()+" "+debugIdentifier+" DoNoteTracksForever returned in "+timetaken+" ms.");#/
	}	
}

// Designed for using DoNoteTracks on looping animations, so you can wait for a time instead of the "end" parameter
DoNoteTracksForTime(time, flagName, customFunction, debugIdentifier)
{
	ent = SpawnStruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc( ::DoNoteTracksForever, time, flagName, customFunction, debugIdentifier, ent);
}

DoNoteTracksForTimeIntercept( time, flagName, interceptFunction, debugIdentifier)
{
	ent = SpawnStruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc( ::DoNoteTracksForeverIntercept, time, flagName, interceptFunction, debugIdentifier, ent);
}

DoNoteTracksForTimeProc( doNoteTracksForeverFunc, time, flagName, customFunction, debugIdentifier, ent)
{
	ent endon ("stop_notetracks");
	[[doNoteTracksForeverFunc]](flagName, undefined, customFunction, debugIdentifier);
}

doNoteTracksForTimeEndNotify(time)
{
	wait (time);
	self notify ("stop_notetracks");
}

shootNotetrack()
{
	waittillframeend; // Unfortunately, this doesn't guarantee that all other notetrack handlers this frame execute first.
	now = GetTime();
	if ( now > self.a.lastShootTime ) 
	{
		self.a.lastShootTime = now;
		//println( "shootNotetrack calling shootEnemyWrapper(): Entity " + self getEntityNumber() + " shooting at time " + GetTime() );
		self shootEnemyWrapper();
		self decrementBulletsInClip();

		if ( weaponClass( self.weapon ) == "rocketlauncher" )
		{
			self.a.rockets--;
		}
	}
}

fire_straight()
{
	if( self.a.weaponPos[ "right" ] == "none" && self.a.weaponPos[ "left" ] == "none" )
	{
		return;
	}
		
	if ( IsDefined( self.dontShootStraight ) )
	{
		shootNotetrack();
		return;
	}
	
	weaporig = self gettagorigin( "tag_weapon" );
	dir = AnglesToForward( self GetTagAngles( "tag_weapon" ) );
	pos = weaporig + VectorScale( dir, 1000 );
	// note, shootwrapper is not called because shootwrapper applies a random spread, and shots
	// fired in a scripted sequence need to go perfectly straight so they get the same result each time.
	self.a.lastShootTime = GetTime();
	self shoot( 1, pos );
	self decrementBulletsInClip();
}

noteTrackFireSpray( note, flagName )
{
	//TODO: make AI not use anims with this notetrack if they don't have a weapon
	if ( self.a.weaponPos["right"] == "none" )
	{
		return;
	}
		
	weaporig = self gettagorigin("tag_weapon");
	dir = AnglesToForward( self GetTagAngles( "tag_weapon" ) );
	
	hitenemy = false;
	// check if we're aiming closish to our enemy
	if ( IsSentient(self.enemy) && IsAlive(self.enemy) && self canShoot( self.enemy GetShootAtPos() ) )
	{
		enemydir = VectorNormalize(self.enemy geteye() - weaporig);
		if ( vectordot(dir, enemydir) > cos(10) )
		{
			hitenemy = true;
		}
	}
	
	if ( hitenemy )
	{
		//println( "noteTrackFireSpray calling shootEnemyWrapper(): Entity " + self getEntityNumber() + " shooting at time " + GetTime() );
		self shootEnemyWrapper();
	}
	else
	{
		dir += ((RandomFloat(2)-1) * .1, (RandomFloat(2)-1) * .1, (RandomFloat(2)-1) * .1);
		pos = weaporig + VectorScale(dir, 1000);
		
		self shootPosWrapper( pos );
	}
	
	self decrementBulletsInClip();
	
}	


getPredictedAimYawToShootEntOrPos(time)
{
	if ( !IsDefined( self.shootEnt ) )
	{
		if ( !IsDefined( self.shootPos ) )
		{
			return 0;
		}
		
		return getAimYawToPoint( self.shootPos );
	}
	
	predictedPos = self.shootEnt.origin + VectorScale( self.shootEntVelocity, time );
	return getAimYawToPoint( predictedPos );
}

getAimYawToShootEntOrPos()
{
	// make use of the fact that shootPos = shootEnt GetShootAtPos() if shootEnt is defined
	if ( !IsDefined( self.shootEnt ) )
	{
		if ( !IsDefined( self.shootPos ) )
		{
			return 0;
		}
		
		return getAimYawToPoint( self.shootPos );
	}
	
	return getAimYawToPoint( self.shootEnt GetShootAtPos(self) );
}

getAimPitchToShootEntOrPos()
{
	pitch = getPitchToShootEntOrPos();
	if ( self.a.script == "cover_crouch" && IsDefined( self.a.coverMode ) && self.a.coverMode == "lean" )
	{
		pitch -= anim.coverCrouchLeanPitch;
	}

	return pitch;
}

getPitchToShootEntOrPos()
{
	if ( !IsDefined( self.shootEnt ) )
	{
		// make use of the fact that shootPos = shootEnt GetShootAtPos() if shootEnt is defined
		if ( !IsDefined( self.shootPos ) )
		{
			return 0;
		}
		
		return animscripts\combat_utility::getPitchToSpot( self.shootPos );
	}
	
	return animscripts\combat_utility::getPitchToSpot( self.shootEnt GetShootAtPos(self) );
}

getAimYawToPoint(point)
{
	yaw = GetYawToSpot(point);

	// need to have fudge factor because the gun's origin is different than our origin,
	// the closer our distance, the more we need to fudge. 
	dist = distance(self.origin,point);
	if(dist > 3)
	{
		angleFudge = asin(-3/dist);
		yaw += angleFudge; 
	}
	yaw = AngleClamp180( yaw );
	return yaw;
}

trackShootEntOrPos()
{
	self animscripts\shared::setAimingAnims( %aim_2, %aim_4, %aim_6, %aim_8 );
	self animscripts\shared::trackLoopStart();
}

stopTracking()
{
	self notify("stop tracking");
}

trackLoopStart()
{
	self notify("trackLoopStart");
	self.pauseTrackLoop = false;
}

trackLoopPauseThread()
{
	self endon("death");

	while(1)
	{
		self waittill_any( "killanimscript", "stop tracking", "melee" );
		self.pauseTrackLoop = true;
	}
}

trackLoopPacer()
{
	self endon("death");

	wait(0.05);
	self notify("trackLoopStart");
//	println( self GetEntNum() + ": pace (time: " + GetTime() + ")" );
}

// optimization crap, ugh
scriptNeedsTagAim()
{
	if( IsDefined( self.a.script ) )
	{
		if( self.a.script == "move" || self.a.script == "cover_right" || self.a.script == "cover_left" || self.a.script == "cover_pillar" )
		{
			return true;
		}
	}

	if( IS_TRUE( self.a.useTagAim ) )
	{
		return true;
	}

	return false;
}

trackLoopGetShootFromPos()
{
	origin = undefined;
	
/*
	// SUMEET - Reverting Alex's optimization partially causing visual aiming issues for now
	// still checking scriptNeedsTagAim() though

	// don't check tag_aim (expensive) every frame if it's not being animated
	if( self.nextTagAimCheckTime <= GetTime() && scriptNeedsTagAim() )
	{
		origin = self getTagOrigin( "tag_aim" );
	}
*/
	if( scriptNeedsTagAim() )
	{
		origin = self getTagOrigin( "tag_aim" );
	}

	if( !IsDefined(origin) )
	{
		/#
		if( GetDvarint( "ai_debugAiming") ) //&& self.nextTagAimCheckTime < GetTime() )
		{
			println("no tag_aim in model " + self.model);
		}
		#/

		eyeHeight = self geteyeapprox()[2];
		if( self.a.pose == "crouch" )
		{
			eyeHeight = self.origin[2] + (eyeHeight - self.origin[2]) * 0.5;
		}

		origin = (self.origin[0], self.origin[1], eyeHeight);
	}

	return origin;
}

trackLoopGetShootFromAngles()
{

	angles = undefined;

/*
	// SUMEET - Reverting Alex's optimization partially causing visual aiming issues for now
	// still checking scriptNeedsTagAim() though

	// don't check tag_aim (expensive) every frame if it's not being animated
	if( self.nextTagAimCheckTime <= GetTime() && scriptNeedsTagAim() )
	{
		angles = self getTagAngles( "tag_aim" );

		if( IsDefined( angles ) && DistanceSquared(angles, self.angles) < 1 )
		{
			self.nextTagAimCheckTime = GetTime() + 200;
		}
	}
*/

	if( scriptNeedsTagAim() )	
	{
		angles = self getTagAngles( "tag_aim" );
	}
	
	if( !IsDefined(angles) )
	{
		/#
		if( GetDvarint( "ai_debugAiming") ) // && self.nextTagAimCheckTime < GetTime() )
		{
			println("no tag_aim in model " + self.model);
		}
		#/

		angles = self.angles;
	}

	return angles;
}


trackLoop()
{
	self endon("death");

	self.aimAngleOffset		= 0;
	self.pitchAngleOffset	= 0;

	// SUMEET - Reverting Alex's optimization partially causing visual aiming issues for now
	// still checking scriptNeedsTagAim() though
	//self.nextTagAimCheckTime = 0;

	self waittill("trackLoopStart");

	players = GetPlayers();
	
	prevYawDelta	= 0;
	prevPitchDelta	= 0;
	prevAim2		= self.a.aim_2;

	// max change in yaw or pitch in 1 frame
	const maxYawDeltaChange	= 5;
	const maxPitchDeltaChange = 5;
	
	yawDelta	= 0;

	pitchDelta	= 0;
	
	if ( self.isdog )
	{
		doMaxAngleCheck = false;
		self.shootEnt = self.enemy;
	}
	else
	{
		doMaxAngleCheck = true;
	}
	
	firstFrame = true;
	
	self.pauseTrackLoop = false;
	self thread trackLoopPauseThread();
	
	
	shootFromAngles = self trackLoopGetShootFromAngles();

	prevshootFromYawAngle	= shootFromAngles[1] + self.aimAngleOffset;
	prevshootFromPitchAngle = shootFromAngles[0] + self.pitchAngleOffset;

	for(;;)
	{
		/#
		debugAiming = false;

		if( GetDvarint( "ai_debugAiming") )
		{
			ai_entNum = GetDvarint( "ai_debugEntIndex");
			if( ai_entNum == -1 || ai_entNum == self getEntityNumber() )
			{
				debugAiming = true;
			}
		}
		#/

		// ALEXP_MOD (8/27/09): cache these values to prevent multithreading issues
		rightAimLimit	= self.rightAimLimit;
		leftAimLimit	= self.leftAimLimit;
		upAimLimit		= self.upAimLimit;
		downAimLimit	= self.downAimLimit;

		// ALEXP_MOD (8/28/09): aim limits may have changed, so fix up the previuos deltas
		if ( prevYawDelta > rightAimLimit )
		{
			prevYawDelta = rightAimLimit;
		}
		else if ( prevYawDelta < leftAimLimit )
		{
			prevYawDelta = leftAimLimit;
		}

		if ( prevPitchDelta > upAimLimit )
		{
			prevPitchDelta = upAimLimit;
		}
		else if ( prevPitchDelta < downAimLimit )
		{
			prevPitchDelta = downAimLimit;
		}

		aimingAnimsChanged = false;
		aimBlendTime = .05;

		// if the aiming roots have changed, start the new ones
		// at the exact weight right away so there's no catchup
		if( prevAim2 != self.a.aim_2 )
		{
			aimingAnimsChanged = true;
			aimBlendTime = 0;
			prevAim2 = self.a.aim_2;
		}
	
		incrAnimAimWeight();
		
		shootFromPos = self trackLoopGetShootFromPos();

		shootPos = self.shootPos;
		if ( IsDefined( self.shootEnt ) )
		{
			shootPos = self.shootEnt GetShootAtPos(self);
		}

		if ( !IsDefined( shootPos ) && self call_overloaded_func( "animscripts\cqb", "shouldCQB" ) )
		{
			selfForward = AnglesToForward( self.angles );
			if ( IsDefined( self.cqb_target ) )
			{
				shootPos = self.cqb_target GetShootAtPos(self);
				dir = shootPos - shootFromPos;
				vdot = vectorDot( dir, selfForward );
				if ( ( vdot < 0.0 ) || ( vdot * vdot < 0.413449 * lengthsquared( dir ) ) ) // 0.413449 = cos50 * cos50 
				{
					shootPos = undefined;
				}
			}

			if ( !IsDefined( shootPos ) && IsDefined( self.cqb_point_of_interest ) )
			{
				shootPos = self.cqb_point_of_interest;
				dir = shootPos - shootFromPos;
				vdot = vectorDot( dir, selfForward );
				if ( ( vdot < 0.0 ) || ( vdot * vdot < 0.413449 * lengthsquared( dir ) ) ) // 0.413449 = cos50 * cos50 
				{
					shootPos = undefined;
				}
			}
		}

		shootFromAngles = self trackLoopGetShootFromAngles();

		// take the current muzzle angles and remove the aiming before making calculations
		shootFromYawAngle = shootFromAngles[1] + self.aimAngleOffset; // TODO: remove offset once tag_aim goes in
		shootFromPitchAngle = shootFromAngles[0] + self.pitchAngleOffset;

		// figure out how much the muzzle has moved not due to aiming
		shootFromYawDelta = AngleClamp180(shootFromYawAngle - prevshootFromYawAngle);
		shootFromPitchDelta = AngleClamp180(shootFromPitchAngle - prevshootFromPitchAngle);

		const maxAngleDelta = 11; // (220/20) - ai_turnRate / server frames

		/#
		//debugging for changing tag_origin angles
		if( debugAiming )
		{
			printColor = (1,1,1);
			//recordEntText( GetTime() + ": actualAngle: " + shootFromAngles[1] + " shootFromYawAngle: " + shootFromYawAngle + " desiredAngle: " + self.desiredAngle, self, printColor, "Animscript" );
			tempAngles = ( shootFromPitchAngle, self.desiredangle, shootFromAngles[2] );
			tempVector = anglesToForward( tempAngles );
			recordLine( shootFromPos, shootFromPos + VectorScale(tempVector, 100), printColor, "Animscript", self );
		}
		#/

		// if it's the tag origin that's rotating, as opposed to tag_aim changes which are more like a permanent offset,
		// then try to "predict" the shootFromYawAngle since it takes a couple of frames for the animaton to catch up
		if( AbsAngleClamp180(self.angles[1] - self.desiredAngle) > 1 && AbsAngleClamp180(self.angles[1] - shootFromAngles[1]) < 1 )
		{
			// in order for aiming to match what the tag origin is doing, its rate of change needs to be faster
			const aimingCatchupFactor = 2;

			desiredDelta = AngleClamp180( self.desiredAngle - shootFromAngles[1] );
			newAngleDelta = min( maxAngleDelta * aimingCatchupFactor, abs(desiredDelta) );
			newAngleDelta *= sign(desiredDelta);

			shootFromYawAngle = AngleClamp180( shootFromAngles[1] + newAngleDelta );
		}
		else if( abs(shootFromYawDelta) > maxAngleDelta ) // smoothly blend into the new tag aim
		{
			shootFromYawAngle = prevshootFromYawAngle + maxAngleDelta * sign(shootFromYawDelta);
		}

		if( abs(shootFromPitchDelta) > maxAngleDelta )
		{
			shootFromPitchAngle  = prevshootFromPitchAngle + maxAngleDelta * sign(shootFromPitchDelta);
		}

		/#
		if( debugAiming )
		{
			recordEntText( "actualAngle: " + shootFromAngles[0] + " shootFromPitchAngle: " + shootFromPitchAngle + " shootFromPitchDelta: " + shootFromPitchDelta, self, level.color_debug["cyan"], "Animscript" );
			recordEntText( "actualAngle: " + shootFromAngles[1] + " shootFromYawAngle: " + shootFromYawAngle + " shootFromYawDelta: " + shootFromYawDelta, self, level.color_debug["orange"], "Animscript" );

			facingVector = anglesToForward( shootFromAngles );

			recordLine( shootFromPos, shootFromPos + VectorScale(facingVector, 100), (0,0,1), "Animscript", self );
		}
		#/

		shootFromAngles = ( shootFromPitchAngle, shootFromYawAngle, shootFromAngles[2] );

		/#
		if( debugAiming )
		{
			facingVector = anglesToForward( shootFromAngles );

			recordLine( shootFromPos, shootFromPos + VectorScale(facingVector, 100), (0,1,0), "Animscript", self );

			if( IsDefined(shootPos) )
			{
				recordLine( shootFromPos, shootPos, (1,0,0), "Animscript", self );
			}
		}
		#/
		///////////////
		
		if ( !IsDefined( shootPos ) )
		{
			assert( !IsDefined( self.shootEnt ) );
			
			if ( IsDefined( self.node ) && self.node.type == "Guard" && DistanceSquared(self.origin, self.node.origin) < 16 )
			{
				yawDelta = AngleClamp180( shootFromYawAngle - self.node.angles[1] );
				pitchDelta = 0;
			}
			else
			{
				likelyEnemyDir = self getAnglesToLikelyEnemyPath();
				if ( IsDefined( likelyEnemyDir ) )
				{
					yawDelta = AngleClamp180( shootFromYawAngle - likelyEnemyDir[1] );
					pitchDelta = AngleClamp180( 360 - likelyEnemyDir[0] );
				}
				else
				{
					yawDelta = 0;
					pitchDelta = 0;
				}
			}
		}
//		else if( abs(shootFromYawDelta) > 5 || abs(shootFromPitchDelta) > 5 ) // don't mess with aiming if the delta anim has a lot of movement
//		{
//			yawDelta = prevYawDelta;
//			pitchDelta = prevPitchDelta;
//		}
		else
		{
			vectorToShootPos = shootPos - shootFromPos;
			anglesToShootPos = VectorToAngles( vectorToShootPos );

			yawDelta = shootFromYawAngle - anglesToShootPos[1];
			yawDelta = AngleClamp180( yawDelta );
			
			pitchDelta = shootFromPitchAngle - anglesToShootPos[0];
			pitchDelta = AngleClamp180( pitchDelta );
		}
		
		if ( doMaxAngleCheck && !aimingAnimsChanged && ( abs( yawDelta ) > 60 || abs( pitchDelta ) > 60 ) )
		{
			yawDelta = 0;
			pitchDelta = 0;
		}
		else
		{
			if ( self.gunBlockedByWall )
			{
				yawDelta = clamp( yawDelta, -10, 10 );
			}
			if ( yawDelta > rightAimLimit )
			{
				yawDelta = rightAimLimit;
			}
			else if ( yawDelta < leftAimLimit )
			{
				yawDelta = leftAimLimit;
			}

			if ( pitchDelta > upAimLimit )
			{
				pitchDelta = upAimLimit;
			}
			else if ( pitchDelta < downAimLimit )
			{
				pitchDelta = downAimLimit;
			}
		}

		if ( firstFrame )
		{
			firstFrame = false;

			yawDelta	= 0;
			pitchDelta	= 0;
		}
		else
		{
			// adjust the max yaw and pitch delta change by the amount the delta anim has changed it, otherwise aiming will be too slow to catch up
			adjustedMaxYawDeltaChange	= maxYawDeltaChange + abs(shootFromYawDelta);
			adjustedMaxPitchDeltaChange = maxPitchDeltaChange + abs(shootFromPitchDelta);

			// clamp yaw and pitch
			yawDeltaChange = yawDelta - prevYawDelta;
			if ( abs( yawDeltaChange ) > adjustedMaxYawDeltaChange )
				yawDelta = prevYawDelta + adjustedMaxYawDeltaChange * sign( yawDeltaChange );

			pitchDeltaChange = pitchDelta - prevPitchDelta;
			if ( abs( pitchDeltaChange ) > adjustedMaxPitchDeltaChange )
				pitchDelta = prevPitchDelta + adjustedMaxPitchDeltaChange * sign( pitchDeltaChange );
		}

		/#
		if( debugAiming )
		{
			recordEntText( "pitchDelta: " + pitchDelta, self, level.color_debug["cyan"], "Animscript" );
			recordEntText( "yawDelta: " + yawDelta, self, level.color_debug["orange"], "Animscript" );
		}
		#/		
		
		// save for next run
		prevshootFromYawAngle	= shootFromYawAngle;
		prevshootFromPitchAngle	= shootFromPitchAngle;

		prevYawDelta			= yawDelta;
		prevPitchDelta			= pitchDelta;
		
		if ( yawDelta > 0 )
		{
			assert( yawDelta <= rightAimLimit );
			weight = yawDelta / rightAimLimit * self.a.aimweight;
			self SetAnimLimited( self.a.aim_4, 0, aimBlendTime );
			self SetAnimLimited( self.a.aim_6, weight, aimBlendTime );
		}
		else if ( yawDelta < 0 )
		{
			assert( yawDelta >= leftAimLimit );
			weight = yawDelta / leftAimLimit * self.a.aimweight;
			self SetAnimLimited( self.a.aim_6, 0, aimBlendTime );
			self SetAnimLimited( self.a.aim_4, weight, aimBlendTime );
		}
		
		if ( pitchDelta > 0 )
		{
			assert( pitchDelta <= upAimLimit );
			weight = pitchDelta / upAimLimit * self.a.aimweight;
			self SetAnimLimited( self.a.aim_2, 0, aimBlendTime );			
			self SetAnimLimited( self.a.aim_8, weight, aimBlendTime );
		}
		else if ( pitchDelta < 0 )
		{
			assert( pitchDelta >= downAimLimit );
			weight = pitchDelta / downAimLimit * self.a.aimweight;
			self SetAnimLimited( self.a.aim_8, 0, aimBlendTime );
			self SetAnimLimited( self.a.aim_2, weight, aimBlendTime );
		}
		
		//animcmd traffic throttle back		
		if ( players.size == 1 )
		{
			// this is set up so that this loop can run more than once per frame
			// this way if an animscript changes, it can force this loop to run again
			// so that the aiming doesn't stop

//			println( self GetEntNum() + ": waitForPace (time: " + GetTime() + ")" );

			// normally just a wait(0.05) that sends "trackLoopStart" right after
			self thread trackLoopPacer();
			self waittill("trackLoopStart");

//			println( self GetEntNum() + ": waittillframeend1 (time: " + GetTime() + ")" );

			// wait till after all the other anim cmds are done
			waittillframeend;

//			println( self GetEntNum() + ": waittillframeend2 (time: " + GetTime() + ")" );
		}
		else
		{
			wait( 1 ); //lower this value if it looks too jinky
		}

		if( self.pauseTrackLoop )
		{
			self.aimAngleOffset = 0;
			self.pitchAngleOffset = 0;

//			println( self GetEntNum() + ": pausing (time: " + GetTime() + ")" );
			self waittill("trackLoopStart");
			self.pauseTrackLoop = false;
//			println( self GetEntNum() + ": unpausing (time: " + GetTime() + ")" );

			// reset everything
			firstFrame = true;

			prevYawDelta	= 0;
			prevPitchDelta	= 0;

			shootFromAngles = self trackLoopGetShootFromAngles();

			prevshootFromYawAngle	= shootFromAngles[1] + self.aimAngleOffset;
			prevshootFromPitchAngle = shootFromAngles[0] + self.pitchAngleOffset;
		}

	}	
}

//setAnimAimWeight works just like SetAnimLimited on an imaginary anim node that affects the four aiming directions.
setAnimAimWeight(goalweight, goaltime)
{
	if ( !IsDefined( goaltime ) || goaltime <= 0 )
	{
		self.a.aimweight = goalweight;
		self.a.aimweight_start = goalweight;
		self.a.aimweight_end = goalweight;
		self.a.aimweight_transframes = 0;
	}
	else
	{
		if ( !isdefined( self.a.aimweight ) )
			self.a.aimweight = 0;
		self.a.aimweight_start = self.a.aimweight;
		self.a.aimweight_end = goalweight;
		self.a.aimweight_transframes = int(goaltime * 20);
	}

	self.a.aimweight_t = 0;
}
incrAnimAimWeight()
{
	if ( self.a.aimweight_t < self.a.aimweight_transframes )
	{
		self.a.aimweight_t++;
		t = 1.0 * self.a.aimweight_t / self.a.aimweight_transframes;
		self.a.aimweight = self.a.aimweight_start * (1 - t) + self.a.aimweight_end * t;
	}
}

// decides on the number of shots to do in a burst.
decideNumShotsForBurst()
{
	numShots = 0;
	if ( animscripts\weaponList::usingSemiAutoWeapon() )
	{
		numShots = anim.semiFireNumShots[ RandomInt( anim.semiFireNumShots.size ) ];
	}
	else if ( self.fastBurst )
	{
		numShots = anim.fastBurstFireNumShots[ RandomInt( anim.fastBurstFireNumShots.size ) ];
	}
	else
	{
		numShots = anim.burstFireNumShots[ RandomInt( anim.burstFireNumShots.size ) ];
	}

	if ( numShots <= self.bulletsInClip )
	{
		return numShots;
	}
	
	assert( self.bulletsInClip >= 0, self.bulletsInClip );
	
	if ( self.bulletsInClip <= 0 )
	{
		return 1;
	}
	
	return self.bulletsInClip;
}

decideNumShotsForFull()
{
	numShots = self.bulletsInClip;
	if ( weaponClass( self.weapon ) == "mg" )
	{
		choice = RandomFloat(10);
		if ( choice < 3 )
		{
			numShots = randomIntRange( 2, 6 );
		}
		else if ( choice < 8 )
		{
			numShots = randomIntRange( 6, 12 );
		}
		else
		{
			numShots = randomIntRange( 12, 20 );
		}
	}
	
	return numShots;
}


//--------------------------------------------------------------------------------
// dropping clip while reloading
//--------------------------------------------------------------------------------
handleDropClip( flagName )
{
	self endon ( "killanimscript" );
	self endon ( "abort_reload" );
	
	if ( !IsSentient( self ) )
		return;
	
	// get the clip model for the weapon
	clipModel = undefined;
	if( self.weaponInfo[self.weapon].useClip )
		clipModel = getWeaponClipModel( self.weapon );
	
	if( self.weaponInfo[self.weapon].hasClip )
	{
		if ( IsDefined( clipModel ) )
		{
			self hidepart( "tag_clip" );
			self thread dropClipModel( clipModel, "tag_clip" );
			self.weaponInfo[self.weapon].hasClip = false;
			self thread resetClipOnAbort( clipModel );
		}
	}
	
	for ( ;; )
	{
		self waittill( flagName, noteTrack );
		
		switch ( noteTrack )
		{
 			case "attach clip left":
 			case "attach clip right":
				{
 					if( IsDefined( clipModel ) )
					{
						self attach( clipModel, "tag_inhand" );
						self hidepart( "tag_clip" );
						self.a.reloadClipInHand = true;
						self thread resetClipOnAbort( clipModel, "tag_inhand" );
					}

					// if we abort the reload after this point, we don't want to have to do it again
					self animscripts\weaponList::RefillClip();
				}

 				break;
			case "detach clip right":
			case "detach clip left":
				{
					if( IsDefined( clipModel ) && IS_TRUE( self.a.reloadClipInHand ) )
					{
						self.a.reloadClipInHand = false;
						self detach( clipModel, "tag_inhand" );
						self showpart( "tag_clip" );
						self notify ( "clip_detached" );
						self.weaponInfo[self.weapon].hasClip = true;
					}
				}

			return;
		}
	}
}


resetClipOnAbort( clipModel, currentTag )
{
	self notify ( "clip_detached" );
	self endon ( "clip_detached" );
	//self endon ( "death" ); // don't end on death or we won't delete the clip when we die!

	self waittill_any( "killanimscript", "abort_reload" );
	
	// we can be dead but still defined. if we're undefined we got deleted.
	if ( !IsDefined( self ) )
		return;

	self.a.reloadClipInHand = false;

	if ( IsDefined( currentTag ) )
		self detach( clipModel, currentTag );
		
	if ( IsAlive( self ) )
	{
		self showpart( "tag_clip" );
		self.weaponInfo[self.weapon].hasClip = true;
	}
	else
	{
		if( IsDefined( currentTag ) )
			dropClipModel( clipModel, currentTag );	
	}
}

dropClipModel( clipModel, tagName )
{
	origin = self getTagOrigin( tagName );
	angles = self getTagAngles( tagName );

	// take downward motion from the hand position
	dir = AnglesToUp( ( 0, 0, angles[2] ) ) * -1;
	CreateDynEntAndLaunch( clipModel, origin, angles, origin + ( 0, 0, -70 ), dir );
}

moveToOriginOverTime( origin, time )
{
	self endon("killanimscript");
	
	distSq = DistanceSquared( self.origin, origin );

	if ( distSq > 16*16 && !self mayMoveToPoint( origin ) )
	{
		dist = Distance( self.origin, origin );
		/# println("^1Warning: AI starting behavior for node at " + origin + " but could not move to that point. dist  = " + dist ); #/
		return;
	}
	
	self.keepClaimedNodeIfValid = true;
	
	offset = self.origin - origin;
	
	frames = int(time * 20);
	offsetreduction = VectorScale( offset, 1.0 / frames );
	
	for ( i = 0; i < frames; i++ )
	{
		offset -= offsetreduction;
		self Teleport( origin + offset );
		wait .05;
	}
	
	self.keepClaimedNodeIfValid = false;
}

returnTrue() { return true; }

playLookAnimation( lookAnim, lookTime, canStopCallback )
{
	if ( !IsDefined( canStopCallback ) )
	{
		canStopCallback = ::returnTrue;
	}
	
	for ( i = 0; i < lookTime * 10; i++ )
	{
		// Break out if you saw somebody lately
		if ( IsAlive( self.enemy ) )
		{
			if ( self canSeeEnemy() && [[ canStopCallback ]]() )
			{
				return;
			}
		}

		if ( self isSuppressedWrapper() && [[ canStopCallback ]]() )
		{
			return;
		}
		
		self SetAnimKnobAll( lookAnim, %body, 1, .1 );
		wait (0.1);
	}
}

////////////////////////////////////////////////////////////
// ThrowDownWeapon
////////////////////////////////////////////////////////////

getSecondaryWeapon()
{
	if( IsDefined(self.weapon) )
	{
		if( self.weapon == self.primaryweapon && AIHasWeapon(self.secondaryweapon) && weaponClass(self.secondaryweapon) != "pistol" )
		{
			return self.secondaryweapon;
		}
		else if( self.weapon == self.secondaryweapon && AIHasWeapon(self.primaryweapon) && weaponClass(self.secondaryweapon) != "pistol" )
		{
			return self.primaryweapon;
		}
	}

	return undefined;
}

hasSecondaryWeapon()
{
	weapon = getSecondaryWeapon();
	return( IsDefined(weapon) && (weapon != "none") );
}

shouldThrowDownWeapon()
{
	if( !hasSecondaryWeapon() )
	{
		return false;
	}

/#
	if(GetDvarint( "aiForceThrowDownWeapon"))
	{
		return true;
	}
#/

	if( !self.a.allow_weapon_switch )
	{
		return false;
	}

	curWeaponClass = weaponAnims();
	if( curWeaponClass == "none" )
	{
		return false;
	}

	if( IsDefined(self.shootPos) )
	{
		distSqToShootPos = lengthsquared( self.origin - self.shootPos );
			
		// too close for RPG or out of ammo
		if ( weaponAnims() == "rocketlauncher" && (distSqToShootPos < squared( 512 ) || self.a.rockets < 1 ) )
		{
			return true;
		}
	}

	return false;
}

throwDownWeapon()
{
	self endon ( "killanimscript" );

	swapAnim = animArray("throw_down_weapon");
	if( !IsDefined(swapAnim) || swapAnim == %void )
	{
		return;
	}

	/#
	self animscripts\debug::debugPushState( "throwdownWeapon" );
	#/

	//println("throwDownWeapon"); // ALEXP_PRINT

	// Too many issues right now
	self AnimMode( "angle deltas" );
	self SetFlaggedAnimKnobAllRestart( "weapon swap", swapAnim, %body, 1, .1, 1 );
//	self DoNoteTracks( "weapon swap" );

	note = "";
	while (note!="end")
	{
		self waittill("weapon swap",note);
		if ( note == "dropgun" || note == "gun drop")
		{
			DropAIWeapon();
		}
			
		if ( note == "anim_gunhand = \"right\"" )
		{
			assert( hasSecondaryWeapon(), "self.secondaryweapon not defined! check the aitype for this actor. " );

			if( AIHasWeapon(self.secondaryweapon) )
			{
				self animscripts\shared::placeWeaponOn( self.secondaryweapon, "right" );
			}
			else
			{
				self animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );
			}
		}
	}

	// AI_TODO: bulletsInClip needs to work on a per-weapon basis
	if( self.bulletsInClip > weaponClipSize( self.weapon ) )
	{
		self.bulletsInClip = weaponClipSize( self.weapon );
	}

	self maps\_gameskill::didSomethingOtherThanShooting();

	/#
	self animscripts\debug::debugPopState();
	#/
}

////////////////////////////////////////////////////////////
// SwitchWeapons
////////////////////////////////////////////////////////////

// AI_TODO: optimize by storing past return value and only
// updating at certain intervals
shouldSwitchWeapons()
{
	// AI should have secondary weapon to be able to switch
	if (!hasSecondaryWeapon() || !self.a.allow_weapon_switch)
	{
		return false;
	}
	
	if( self.a.atPillarNode )
	{
		return false;
	}
	
	// Check if this AI needs a forced switch (can be a request via level script)
	// AI can be forced to switch by calling switch_weapon_ASAP() function
	if( IsDefined(self.a.weapon_switch_ASAP) && (self.a.weapon_switch_ASAP) )
	{
		assert( hasSecondaryWeapon(), "self.secondaryweapon not defined! check the aitype for this actor. " );
			
		self.a.weapon_switch_ASAP = false;
		return true;
	}

	// TODO: make the timer a const somewhere or a dvar
	if( (gettime() - self.a.weapon_switch_time) < 1000 )
	{
		return false;
	}

	////////////////////////////////////////////////////////////
	// decision-making should go here //
	////////////////////////////////////////////////////////////

	// if no primary, but has secondary, switch now
	// can happen if throwdown anim gets interrupted
	curWeaponClass = weaponAnims();
	if( curWeaponClass == "none" )
	{
		return true;
	}

	if( shouldSwitchWeaponForSituation() )
	{
		return true;
	}
	
	if( shouldSwitchWeaponForDistance() )
	{
		return true;
	}

	if( shouldForceBehavior("switchWeapons") )
	{
		return true;
	}

	return false;
}

////////////////////////////////////////////////////////////
// SwitchWeapons - Distance and Accuracy Conditions
////////////////////////////////////////////////////////////

shouldSwitchWeaponForDistance()
{
	// Special case -  to not switch to rpg based on distance, but we should evaluate this
// 	if( weaponClass( getSecondaryWeapon() ) == "rocketlauncher" )
// 	{
// 		return false;
// 	}
/*	else */
	
	if( ( weaponAnims() == "rocketlauncher" && isEnemyInExplodableVolume() ) || !IsSentient( self.enemy ) ) // Special case -  to not switch from rpg based on distance if shooting someone in an explodable volume
	{
		return false;
	}

	if ( IsDefined( self.shootPos ) )
	{
		distSqToShootPos = lengthsquared( self.origin - self.shootPos );
		shouldUseWeapon  = undefined;		
		
/#
		// Used for tuning and debugging runtime	
		call_overloaded_func( "animscripts\init", "SetWeaponDist" );	
#/

		Assert( IsDefined( self.primaryweapon_fightdist_minSq ) );
		Assert( IsDefined( self.secondaryweapon_fightdist_minSq ) );
	
		withinPrimaryRange   = ( ( self.primaryweapon_fightdist_minSq < distSqToShootPos ) && ( distSqToShootPos < self.primaryweapon_fightdist_maxSq ) );
		withinSecondaryRange = ( ( self.secondaryweapon_fightdist_minSq < distSqToShootPos ) && ( distSqToShootPos < self.secondaryweapon_fightdist_maxSq  ) );		
		
		// Accuracy based switching
		// If the distance falls into overlap or dead zone or outside max range,
		// then switch to the better weapon based on accuracy at the distance
		// from shoot position.
		if( ( withinPrimaryRange && withinSecondaryRange ) || ( !withinPrimaryRange && !withinSecondaryRange ) )
		{

			if (IsDefined(self.enemy))
			{
		
				primaryweapon_accuracy   = getweaponaccuracy(self, self.primaryweapon);
				secondaryweapon_accuracy = getweaponaccuracy(self, self.secondaryweapon);
		
				if ( primaryweapon_accuracy > secondaryweapon_accuracy )
				{
					shouldUseWeapon = self.primaryweapon;
				}
				else
				{
					shouldUseWeapon = self.secondaryweapon;
				}
			}
			else	
			{
				// just keep using the current weapon
				shouldUseWeapon = self.weapon;
			}
			
			
		}
		else // Distance based switching
		{

			if ( withinPrimaryRange )			
			{
				shouldUseWeapon = self.primaryweapon;
			}
			else if ( withinSecondaryRange )
			{
				shouldUseWeapon = self.secondaryweapon;
			}
		
		}

		// shouldUseWeapon shoule be evaluated in any case at this point.
		Assert( IsDefined(shouldUseWeapon) );

		// if the current weapon is different than the one AI should be using then switching needed.
		if ( self.weapon != shouldUseWeapon )	
		{
			if( self.a.weapon_switch_for_distance_time < 0 )
			{
				self.a.weapon_switch_for_distance_time = GetTime() + RandomFloatRange(2, 4) * 1000; // between 2 and 4 seconds
			}

			if( isExposed() && GetTime() < self.a.weapon_switch_for_distance_time )
			{
				return false;
			}

			return true;
		}

		self.a.weapon_switch_for_distance_time = -1;
		return false;			
	}
		
	// if no shoot ent position, no need to switch
	self.a.weapon_switch_for_distance_time = -1;
	return false;
}

isExposed()
{
	if( self.a.script == "cover_crouch" || self.a.script == "cover_stand" )
	{
		if( IsDefined(self.a.coverMode) && self.a.coverMode == "Hide" )
		{
			return false;
		}
	}
	else if( self.a.script == "cover_left" || self.a.script == "cover_right" || self.a.script == "cover_pillar" )
	{
		if( !IsDefined(self.cornerAiming) || !self.cornerAiming )
		{
			return false;
		}
	}

	return true;
}

getWeaponSwitchAnim()
{
	 //ALEXP_PRINT
//	println("******************************");
//	println("getWeaponSwitchAnim(): " + self.a.script + " - " + self.a.pose );
//	if(isDefined(self.a.coverMode))
//		println("coverMode: " + self.a.coverMode);
//	if(isDefined(self.a.cornerMode))
//		println("cornerMode: " + self.a.cornerMode);
//	if(isDefined(self.a.cornerDirection))
//		println("cornerDir: " + self.a.cornerDirection);
//	if(isDefined(self.cornerAiming) && self.cornerAiming)
//		println("cornerAiming is true");
//	println("******************************");

	animName = "weapon_switch";

	if( !isExposed() )
	{
		animName = "weapon_switch_cover";

		if(GetDvarint( "aiQuadrantSwitch") == 1)
		{
			animName = "weapon_switch_quadrants_cover";
		}
		else if(GetDvarint( "aiQuadrantSwitch") == 2)
		{
			animName = "weapon_putaway_cover";
		}
	}
	else
	{
		if(GetDvarint( "aiQuadrantSwitch") == 1)
		{
			animName = "weapon_switch_quadrants";
		}
		else if(GetDvarint( "aiQuadrantSwitch") == 2)
		{
			animName = "weapon_putaway";
		}
	}

	//println("animName: " + animName); //ALEXP_PRINT
	
	if( IsArray( animArray(animName) ) )
	{
		return animArrayPickRandom( animName );
	}

	return animArray(animName);
}

getWeaponPulloutAnim()
{
	animName = "weapon_pullout";

	if( !isExposed() )
	{
		animName = "weapon_pullout_cover";
	}

	//println("animName: " + animName); //ALEXP_PRINT

	assert( animArrayExist(animName) );
	
	if( IsArray( animArray(animName) ) )
	{
		return animArrayPickRandom( animName );
	}

	return animArray(animName);
}

// todo: handle via donotetracks like everything else
switchWeapons()
{
	swapAnim = getWeaponSwitchAnim();
	if( !IsDefined(swapAnim) )
	{
		return;
	}

	/#
	self animscripts\debug::debugPushState( "switchWeapons" );
	#/

	//println("switchWeapons"); // ALEXP_PRINT

	self animMode( "angle deltas" );
	self SetFlaggedAnimKnobAllRestart( "weapon swap", swapAnim, %body, 1, .1, 1 );
	
	self DoNoteTracks( "weapon swap" );

	// AI_TODO: need to clean this up if the two stage approach is chosen
	// now pullout the other weapon
	if( GetDvarint( "aiQuadrantSwitch") == 2 )
	{
		pulloutAnim = getWeaponPulloutAnim();
		if( IsDefined(swapAnim) )
		{
			self SetFlaggedAnimKnobAllRestart( "weapon swap", pulloutAnim, %body, 1, .1, 1 );
			self DoNoteTracks( "weapon swap" );
		}
	}

	self ClearAnim(%weapon_switch, 0.2);

	// only if the notetrack was hit
	self.a.weapon_switch_time				= gettime();
	self.a.weapon_switch_for_distance_time	= -1;
	
	// notify the AI that weapon switching is done
	self notify("weapon_switched");	

	self maps\_gameskill::didSomethingOtherThanShooting();

	/#
	self animscripts\debug::debugPopState();
	#/
}

isEnemyInExplodableVolume()
{
	if (!IsDefined(self.enemy))
	{
		return false;
	}

	// check that the enemy is in a designated volume near explodables - handled in _load.gsc//
	if (IsDefined(self.enemy._explodable_targets) /*&& IsPlayer(self.enemy)*/ ) // allow this on all enemies for now
	{
		for (i = 0; i < self.enemy._explodable_targets.size; i++)
		{
			// only switch if we can see the target we are going to shoot at
			if (IsDefined(self.enemy._explodable_targets[i]) && self CanSee(self.enemy._explodable_targets[i]))
			{
				return true;
			}
		}
	}
	else if( IsDefined(self.enemy.script_exploder) || self.enemy is_destructible())
	{
		// This means the enemy itself is an exploder or some other kind of destructible object
		return true;
	}

	return false;
}

shouldSwitchWeaponForSituation()
{
	self endon( "death" );

	secondaryWeaponClass = weaponClass( self getSecondaryWeapon() );

	// check that the enemy is in a designated volume near explodables - handled in _load.gsc//
	if( isEnemyInExplodableVolume() && secondaryWeaponClass == "rocketlauncher" && WeaponClass(self.weapon) != "rocketlauncher" )
	{
		return true;
	}
	
	return false;
}


setAimingAnims( aim_2, aim_4, aim_6, aim_8 )
{
	assert( IsDefined(aim_2) );
	assert( IsDefined(aim_4) );
	assert( IsDefined(aim_6) );
	assert( IsDefined(aim_8) );

	self.a.aim_2 = aim_2;
	self.a.aim_4 = aim_4;
	self.a.aim_6 = aim_6;
	self.a.aim_8 = aim_8;
}


//--------------------------------------------------------------------------------
// event reactions 
//--------------------------------------------------------------------------------


serviceReactionEvents()
{
	self notify( "srv_react_events" );
	self endon ( "srv_react_events" );
	self endon ( "death" );

	if ( !isDefined(level.serviceReactions) )
	{
		return;
	}
		
	while(1)
	{
		if( !self animscripts\react::canReactToNewEventAgain() ) 
		{
			wait 0.05;
			continue;
		}
		
		reactionCB		= undefined;
		event			= GetReactionEvent("none",self);//"none" will return highest priority event.
		type			= event[0];
		if ( isDefined(type) && isDefined(level.reactionEventCallbacks[type] ) )
		{
			variants	= level.reactionEventCallbacks[type].size;
			performance = RandomInt(variants);
			reactionCB	= level.reactionEventCallbacks[type][performance];
			assert (isDefined(reactionCB));
			// save the reaction spot
			self.a.eventReactionSpot = event[1];
			self.a.eventReactionEnt  = event[2];
			self.a.eventReactionNearbyAI = animscripts\react::getNearbyPerformanceAI(type);
			self animcustom( reactionCB, ::eventEndReact );
/#
			if( GetDvar( "reaction_influence_debug" ) == "1" )
				recordLine( self.origin, self.a.eventReactionSpot, level.color_debug["yellow"], "Animscript", self );
#/
		}
		
		wait 0.05;
	}
}


eventEndReact()
{
	self animscripts\react::eventReactionEnd();
}
