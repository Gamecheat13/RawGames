#include maps\_vehicle_aianim;
#include maps\_vehicle;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_shg_utility;
#include maps\_pmove;
#include soundscripts\_snd;

PI = 3.141592653589793238462643383279;
MAX_USE_DIST = 64;
MAX_POSITION_ERROR = 45;
MAX_ANGLE_ERROR = 45; // degrees
COVER_FORWARD_OFFSET = 52;
COVER_HALF_WIDTH = 18;

MOBILE_COVER_FX_TAG = "tag_fx";

WINDOW_UP_TIME = .25;
WINDOW_DOWN_TIME = .25;

LINKED_MAX_TURN_RATE = 65; // degrees/second.  In the original tuning, yawscale was .25, for a turn rate of .25 * 260 = 65 with default sensitivity
LINKED_MOVE_SPEED_SCALE = .5;
LINKED_MAX_PITCH_TO_YAW_SCALE_RATIO = 5;

#using_animtree( "vehicles" );
main( model, type, classname )
{
	build_template( "cover_drone", model, type, classname );
	build_localinit( ::init_mobile_cover_drone );
	build_life( 2000 );
	build_cover_death( classname );
	build_team( "allies" );

	PreCacheString( &"COVER_DRONE_LINK" );
	PreCacheString( &"COVER_DRONE_UNLINK" );

	PreCacheModel( "vehicle_mobile_cover_tactics_friendly" );
	PreCacheModel( "vehicle_mobile_cover_active" );
	
	level._effect[ "link_light" ] 								= LoadFx( "fx/lights/light_green_pinlight" );
	level._effect[ "unlink_light" ] 							= LoadFx( "fx/lights/light_red_pinlight" );	
}


cover_drone_disable()
{
	Assert(self.is_mobile_cover);
	
	if(IsDefined(self.linked_player))
		player_unlink_from_cover();
	Assert(!IsDefined(self.linked_player));
	
	self.cover_drone_disabled = true;
}

cover_drone_enable()
{
	Assert(self.is_mobile_cover);
	
	self.cover_drone_disabled = undefined;
}

/#
debug_yaw()
{
	old_yaw = self.angles[1];
	while(true)
	{
		yaw_delta = self.angles[1] - old_yaw;
		old_yaw = self.angles[1];
		IPrintLn("yaw_delta " + yaw_delta);
		
		waitframe();
	}
}	

DEBUG_QUEUE_SIZE = 120;
debug_init()
{
	self.debug_queue = [];
	self.debug_queue_pos = 0;
	
	level.player.debug_pqueue = [];
	level.player.debug_pqueue_pos = 0;
	//level.player thread debug_ppos();
}

debug_ppos()
{
	old_ppos = self.origin;
	while (	1 )
	{
		player_pos = self.origin;
		if (Distance(old_ppos,player_pos) < 0.001)
		{	// don't add to the queue if no move
		}
		else
		{
			if (self.debug_pqueue.size >= DEBUG_QUEUE_SIZE)
			{	// circular queue
				self.debug_pqueue[self.debug_pqueue_pos] = player_pos;
				self.debug_pqueue_pos++;
				if (self.debug_pqueue_pos >= DEBUG_QUEUE_SIZE)
					self.debug_pqueue_pos = 0;
			}
			else
			{
				self.debug_pqueue[self.debug_pqueue.size] = player_pos;
			}
			old_ppos = player_pos;
		}
		if (self.debug_pqueue.size >= 2)
		{
			prv = self.debug_pqueue[self.debug_pqueue_pos];
			dPrv = [0,0,0,0];
			for (i=1; i<self.debug_pqueue.size; i++)
			{
				pos = (self.debug_pqueue_pos + i) % DEBUG_QUEUE_SIZE;
				cur = self.debug_pqueue[pos];
				dCur[0] = Distance(prv, cur);
				pcolor = (1,1,1);
		//		if (i & 1)
		//			pcolor = (0,0,0);
				line( prv+(0,0,10+dPrv[0]), cur+(0,0,10+dCur[0]), pcolor);				// player pos + delta on Z
				if ((i & 3)==0)
				{
					line( cur+(0,0,-10), cur+(0,0,50), (0,0,0));
				}
				prv = cur;
				dPrv = dCur;
			}
		}
		wait 0.05;
	}
}

debug_update( player_pos, goal_pos, speed, yaw )
{
	if (isdefined(self.debug_old_entry) && ((Distance(self.debug_old_entry[0],player_pos) < 0.001) || (Distance(self.debug_old_entry[1],goal_pos) < 0.001)))
	{	// don't add to the queue if no move
	}
	else
	{
		entry[0] = player_pos;
		entry[1] = goal_pos;
		entry[2] = self.origin;
		entry[3] = speed;
		entry[4] = yaw;
		self.debug_old_entry = entry;
		if (self.debug_queue.size >= DEBUG_QUEUE_SIZE)
		{	// circular queue
			self.debug_queue[self.debug_queue_pos] = entry;
			self.debug_queue_pos++;
			if (self.debug_queue_pos >= DEBUG_QUEUE_SIZE)
				self.debug_queue_pos = 0;
		}
		else
		{
			self.debug_queue[self.debug_queue.size] = entry;
		}
	}
	debug_draw();
}

debug_draw()
{
	if (self.debug_queue.size < 2)
		return;
	prv = self.debug_queue[self.debug_queue_pos];
	dPrv = [0,0,0,0,0];
	for (i=1; i<self.debug_queue.size; i++)
	{
		pos = (self.debug_queue_pos + i) % DEBUG_QUEUE_SIZE;
		cur = self.debug_queue[pos];
		dCur[0] = Distance(prv[0], cur[0]);
		dCur[1] = Distance(prv[1], cur[1]);
		dCur[2] = Distance(prv[2], cur[2]);
		dCur[3] = cur[4] - prv[4];
		dCur[4] = Distance(cur[1],cur[2]);
		pcolor = (1,1,1);
//		if (i & 1)
//			pcolor = (0,0,0);
		line( prv[0]+(0,0,dPrv[0]), cur[0]+(0,0,dCur[0]), pcolor);				// player pos + delta on Z
		line( prv[1]+(0,0,dPrv[1]), cur[1]+(0,0,dCur[1]), (1,1,0));				// goal pos + delta on Z
		line( prv[2]+(0,0,5+dPrv[2]), cur[2]+(0,0,5+dCur[2]), (1,0,0));			// actual pos + delta on Z
		line( prv[1]+(0,0,10+dPrv[0]), cur[1]+(0,0,10+dCur[0]), (0,1,1));		// goal pos + player delta on Z
		line( prv[1]+(0,0,20+prv[3]), cur[1]+(0,0,20+cur[3]), (1,0,1));			// goal pos + actual delta on Z
		line( prv[1]+(0,0,80+5*dPrv[3]), cur[1]+(0,0,80+5*dCur[3]), (1,1,1));	// goal pos + yaw delta on Z
		line( prv[1]+(0,0,2+dPrv[4]), cur[1]+(0,0,2+dCur[4]), (1,0.5,0));			// goal pos + error on Z
		if ((i & 3)==0)
		{
			line( cur[1]+(0,0,-10), cur[1]+(0,0,50), (0,0,0));
		}
		prv = cur;
		dPrv = dCur;
	}
}

debug_update2( goal_yaw )
{
	dummy_player_yaw = self.dummy_player.angles[1];
	player_gun_yaw = self.linked_player GetGunAngles()[1];
	if (isdefined(self.debug_old_entry) && ((abs(self.debug_old_entry[0]-dummy_player_yaw) < 0.001) || (abs(self.debug_old_entry[1]-goal_yaw) < 0.001)))
	{	// don't add to the queue if no move
	}
	else
	{
		entry[0] = AngleClamp180(dummy_player_yaw);
		entry[1] = AngleClamp180(goal_yaw);
		entry[2] = AngleClamp180(self.angles[1]);
		entry[3] = AngleClamp180(player_gun_yaw);
		self.debug_old_entry = entry;
		if (self.debug_queue.size >= DEBUG_QUEUE_SIZE)
		{	// circular queue
			self.debug_queue[self.debug_queue_pos] = entry;
			self.debug_queue_pos++;
			if (self.debug_queue_pos >= DEBUG_QUEUE_SIZE)
				self.debug_queue_pos = 0;
		}
		else
		{
			self.debug_queue[self.debug_queue.size] = entry;
		}
	}
	debug_draw2();
}

debug_draw2()
{
	if (self.debug_queue.size < 2)
		return;
	prv = self.debug_queue[self.debug_queue_pos];
	dPrv = [0,0,0,0,0];
	eye = self.linked_player GetEye();
	gunAngles = self.linked_player GetGunAngles();
	forward = AnglesToForward(gunAngles);
	right = AnglesToRight(gunAngles);
	up = AnglesToUp(gunAngles);
	start = eye + 240*forward - 120*right;
	delta = (240/DEBUG_QUEUE_SIZE)*right;
	offset = 12*up;
	colors = [ (1,1,1), (1,1,0), (1,0,0), (0,1,1), (1,0,1) ];
	for (i=1; i<self.debug_queue.size; i++)
	{
		pos = (self.debug_queue_pos + i) % DEBUG_QUEUE_SIZE;
		cur = self.debug_queue[pos];
		dCur = [];
		foreach (idx, val in cur)
		{
			if (idx == 0)
				dCur[idx] = AngleClamp180(val - prv[idx]);
			else
				dCur[idx] = AngleClamp180(val - cur[0]);
			line( start + dPrv[idx]*up + idx*offset, start +dCur[idx]*up + idx*offset + delta, colors[idx]);
		}
		if ((i & 3)==3)
		{
			line( start + -120*up, start + 120*up, (0,0,0));
		}
		start += delta;
		prv = cur;
		dPrv = dCur;
	}
}

#/

build_cover_death( classname )
{
	build_deathmodel( "moving_cover_standing_01", "moving_cover_standing_destroyed_01", 0.05, classname );
}


init_mobile_cover_drone()
{
	level.player endon( "death" );
	
	self.is_mobile_cover = true;

	// ugh - have to wait for warzone tactics to init.  precache goes beofre _load::main(), but warzone init must go after
	waittillframeend;
	
	self.original_model = self.model;
	self.tactics_model	= "vehicle_mobile_cover_tactics_friendly";
	self.tactics_type	= "tool";
	self.no_line		= true;
	self.description = "Mobile Cover";
	maps\_warzone_tactics::add_object_to_tactics_system( self );
	
	self.window_position = "up";
	self.extra_slow_player = false;

	self.yaw_scale = 1.0;
	self.move_scale = 1.0;
	self.position_error = (0,0,0);
	self.accumulated_restore = 0;
	
	// we don't support crashing for now, and it looks realy jank when it happens
	self.godmode = true;
	
	// VehPhys_DisableCrashing() unfortunately controls two things: whether or not the crazy crash physics can ever be applied, and also whether
	// this vehicle can be pushed and collide against other vehicles.  We want to disable the former but not the later, but can't, so hopefully godmode
	// will be enough.
	//self VehPhys_DisableCrashing();
	
	/#
//	self debug_init();
	#/
	
	self thread mobile_cover_impulse();
	
	mobile_cover_drone_trigger_think();
}


mobile_cover_drone_trigger_think()
{
	time		 = 0.25;
	counter		 = 0;
	
	text = undefined;
	
	PlayFXOnTag( getfx( "unlink_light" ), self, MOBILE_COVER_FX_TAG );
	
	while ( IsDefined(self) )
	{
		if ( should_show_prompt(level.player) )
		{
			if ( !IsDefined( text ) )
			{
				text = create_trigger_hint_string( "link" );
				level.player disable_weapon_pickup_wrapper();
				level.player notify( "showing_cover_drone_hint", self );
			}
			
			if ( level.player UseButtonPressed() )
			{
				counter += 0.05;
			}
			else
			{
				counter = 0;
			}
		}
		else
		{
			if ( IsDefined( text ) )
			{
				text Destroy();
				level.player enable_weapon_pickup_wrapper();
				level.player notify( "hiding_cover_drone_hint", self );
			}
			counter = 0;
		}

		if ( counter >= time )
		{
			counter = 0;
			level.player enable_weapon_pickup_wrapper();
			level.player notify( "hiding_cover_drone_hint", self );
			self thread player_link_to_cover( level.player );
			
			text Destroy();
			wait( 0.5 );
			if(IsDefined(self))
			self player_wait_to_unlink();
			wait( 0.5 );
		}

		
		wait( 0.05 );
	}
}

should_show_prompt( player )
{
	Assert(self.is_mobile_cover);
	
	if(IsDefined(self.cover_drone_disabled))
		return false;
	
	if(IsDefined(self.linked_player))
		return false;
	
	if(IsDefined(player.linked_to_cover))
		return false;
	
	if(IsDefined(player.disable_cover_drone))
		return false;

	// we treat the cover as a line rather than a point so it's not hard to attach when you're close to it
	cover_right = AnglesToRight(self.angles);
	player_to_cover = PointOnSegmentNearestToPoint(self.origin + COVER_HALF_WIDTH * cover_right, self.origin - COVER_HALF_WIDTH * cover_right, player.origin) - player.origin;
		
	if(Length(player_to_cover) > MAX_USE_DIST)
		return false;
	
	player_to_cover_dir = VectorNormalize(player_to_cover);
	
	// player looking within an angle of cover
	if(VectorDot(AnglesToForward(player.angles), flat_origin(player_to_cover_dir)) < Cos(45))
		return false;	

	// player on correct side of cover
	if(VectorDot(player_to_cover_dir, AnglesToForward(self.angles)) < 0)
		return false;
	
	// would immediately detach for angles
	if(Abs(AngleClamp180(player.angles[1] - self.angles[1])) > MAX_ANGLE_ERROR)
		return false;
	
	// would immediately detach for being too far away	
	if(Distance(player.origin + AnglesToForward(player.angles) * COVER_FORWARD_OFFSET, self.origin) > MAX_POSITION_ERROR)
		return false;
	
	return true;
}

// note that if the positions are not quite right, it is possible for this to fail, in which self.linked_player will be undefined
player_link_to_cover( player )
{
	Assert( self.is_mobile_cover );
	
	Assert( !IsDefined( self.linked_player ) );
	self.linked_player = player;
	
	self vehicle_scripts\_cover_drone_aud::snd_init_cover_drone();

	Assert( !IsDefined(self.linked_player.linked_to_cover) );
	self.linked_player.linked_to_cover = self;

	maps\_warzone_tactics::remove_object_from_tactics_system( self );
	
	self.linked_player endon( "death" );
	
	self.linked_player player_update_slow_aim(true, self);
		
	self.linked_player AllowJump( false );
	
	level.old_viewBobAmplitudeStanding	= GetDvar( "bg_viewBobAmplitudeStanding" );
	level.old_viewBobAmplitudeDucked	= GetDvar( "bg_viewBobAmplitudeDucked" );
	level.old_viewBobAmplitudeSprinting = GetDvar( "bg_viewBobAmplitudeSprinting" );
	SetSavedDvar( "bg_viewBobAmplitudeStanding" , "0 0" );
	SetSavedDvar( "bg_viewBobAmplitudeDucked"	, "0 0" );
	SetSavedDvar( "bg_viewBobAmplitudeSprinting", "0 0" );
	
	self.window_position = "up";
	self.blend = 0;
	
	self.linked_player notify( "player_linked_to_cover" );
	if (!isdefined(self.dummy_player))
		self.dummy_player = spawn_tag_origin();
	self.dummy_player.origin = self.linked_player.origin;
	self.dummy_player.angles = (0, self.linked_player GetGunAngles()[1], 0);
	self.dummy_player.vel = (0,0,0);
	self.tag_origin = spawn_tag_origin();
	self.tag_origin.origin = self.dummy_player.origin;
	self.tag_origin.angles = self.dummy_player.angles;
//	self.tag_origin linkto( self, "TAG_MOBILE_COVER_UPRIGHT" );
	self.linked_player PlayerLinkToDelta( self.tag_origin, "tag_origin", 1.0, 0, 0, 80, 80, false, false);
	self.ads = self.linked_player AdsButtonPressed();
	self.linked_player EnableMouseSteer( true );
	
	StopFXOnTag( getfx( "unlink_light" ), self, MOBILE_COVER_FX_TAG );
	PlayFXOnTag( getfx( "link_light" ), self, MOBILE_COVER_FX_TAG );
	
	self SetModel( "vehicle_mobile_cover_active" );
	
	self thread player_ads_think();
	self thread mobile_cover_link_think();
	self thread mobile_cover_sound_think();
	self thread player_unlink_on_sprint();
	self thread player_unlink_on_death();
	self thread player_enable_highlight();
}

mimic_player_move( player, dummy_player, forwardmove, rightmove )
{
	frametime = 0.05;
	stopspeed =  100.0;
	friction = 5.5;
	// Equivalent to PM_Friction
	speed = Length( dummy_player.vel );
	if (speed < 1.0)
	{
		dummy_player.vel = (0,0,0);
	}
	else
	{
		if (speed < stopspeed)
			control = stopspeed;
		else
			control = speed;
		drop = control * friction * frametime;
		newspeed = speed - drop;
		if (newspeed < 0)
			newspeed = 0;
		dummy_player.vel = (newspeed/speed)*dummy_player.vel;
	}
	// Equivalent to PM_CmdScale_Walk
	total = sqrt( forwardmove*forwardmove + rightmove*rightmove );
	if (forwardmove < 0) // moving backwards
		fmove = abs( forwardmove * 0.7 );
	else
		fmove = abs( forwardmove );
	smove = abs( rightmove * 0.8 );
	mx = max( fmove, smove );
	if (mx <= 0)
		scale = 0;
	else
	{
		scale = GetDvarInt("g_speed",190) * mx / (127 * total);
	}
	// assume walking
	scale *= 0.4;	// WALK_SPEED_SCALE
	// PM_CmdScaleForStance, no lerp during changing stance
	stance = player GetStance();
	acceleration = 9.0;	// pm_accelerate
	if (stance == "prone")
	{
		scale *= 0.15; // PRONE_SPEED_SCALE
		acceleration = 19.0;	// pm_prone_accelerate
	}
	else if (stance == "crouch")
	{
		scale *= 0.65; // CROUCH_SPEED_SCALE
		acceleration = 12.0;	// pm_ducked_acclerate
	}
	// BG_GetMoveSpeedScale, we'll ignore this for now, though we,ll hardcode a result
	ads = player PlayerAds();
	if (ads > 0.5)
		scale *= 0.5;	// get this from the standard weapon
	// if shell shocked, apply the pm_shellshockScale
	// apply the moveSpeedScaleMultiplier
	scale *= self.move_scale;
	
	forward = AnglesToForward(dummy_player.angles);
	right = AnglesToRight(dummy_player.angles);
	wishvel = forwardmove*forward + rightmove*right;
	wishspeed = Length(wishvel);
	wishdir = VectorNormalize(wishvel);
	wishspeed *= scale;
	// PM_ProjectVelocity
	trace = PlayerPhysicsTraceInfo( dummy_player.origin + (0,0,100), dummy_player.origin + (0,0,-100) );
	normal = trace["normal"];
	wishvel = PM_ProjectVelocity( wishvel, normal );
	
	// PM_Accelerate (not the ladder case)
	currentspeed = VectorDot(dummy_player.vel, wishdir);
	addspeed = wishspeed - currentspeed;
	if (addspeed <= 0)
	{
	}
	else
	{
		if (wishspeed < stopspeed)
			control = stopspeed;
		else
			control = wishspeed;
		accelspeed = acceleration * frametime * control;
		if (accelspeed > addspeed)
			accelspeed = addspeed;
		dummy_player.vel += accelspeed*wishdir;
	}
	dummy_player.vel = PM_ProjectVelocity( dummy_player.vel, normal );
	// add external push vector
	
	if ((dummy_player.vel[0] != 0) || (dummy_player.vel[1] != 0))
	{	// PM_StepSlideMove
		PM_StepSlideMove(dummy_player, normal, false);
		
	}
	
	// move to ground, we'll only trace as far as we want to move each frame
	groundpos = PlayerPhysicsTrace( dummy_player.origin, dummy_player.origin + (0,0,-5) );
	dummy_player.origin = groundpos;
}

mobile_cover_dummy_player_think()
{
	/*
	 * The chain of interconnectedness
	 * dummy_player represents the player that the mobile_cover is tracking
	 * tag_origin is what the player links to
	 * tag_origin is linked to the mobile_cover
	 * The controller for the mobile_cover will generate goal positions based on dummy_player
	 * tag_origin's position relative to the mobile_cover is manipulated to give the hysteresis/loose player connection
	*/
	// This moves our dummy player (hopefully close to the way the player moved before).
	input = self.linked_player GetNormalizedMovement();	// get the movement stick
	rinput = self.linked_player GetNormalizedCameraMovement();	// get the amount of camera movement
	raainput = self.linked_player GetAimAssistDeltas();
	frametime = 0.05;
	old_org = self.dummy_player.origin;
	self mimic_player_move( self.linked_player, self.dummy_player, 127*input[0], 127*input[1] );

	position_error_flat = flat_origin(self.position_error);
	position_error_flat_length = Length( position_error_flat );
	FORCE_PLAYER_ZONE_RADIUS = 16;	
	RELEASE_THRESH = 10;
	dp = VectorDot(position_error_flat, self.dummy_player.vel*frametime);
	// Handle resistance for player when cover is restrained
	if((position_error_flat_length > FORCE_PLAYER_ZONE_RADIUS) && (dp > 0))
	{	// if player is pushing in a direction that increases error and we haven't accumulated too much pushing
		if (self.accumulated_restore < RELEASE_THRESH)
		{	// clear vel.
			self.accumulated_restore += abs(dp);
			self.dummy_player.vel = (0,0,0);
			self.dummy_player.origin = old_org;
		}
	}
	else
	{
		self.accumulated_restore -= 2;
		if (self.accumulated_restore < 0)
			self.accumulated_restore = 0;
	}

//	origin = self.dummy_player.origin + self.dummy_player.vel*frametime;
//	self.dummy_player.origin = PlayerPhysicsTrace( self.dummy_player.origin, origin );

	// handle the angles
	// 
	//viewSensitivity = self GetLocalPlayerProfileData("viewSensitivity");
//		dyaw = -2*rinput[1]*self.yaw_scale;	// backout the delta from the player turning in the linked range
	if (raainput[1])
	dyaw = frametime*raainput[1]*self.yaw_scale;
	else
		dyaw = 2*rinput[1]*self.yaw_scale;	// Allow mouse moves to affect yaw
	newYaw = self.dummy_player.angles[1] + dyaw;
	// handle snap autoaim
	if ((self.linked_player AdsButtonPressed()) && !self.ads)
	{
		self.ads = true;
		targetangles = self.linked_player GetAimAssistTargetAngles();
		if ((targetangles[1] != 0) || (targetangles[0] != 0))
			newYaw = targetangles[1];
	}
	else
	{
		self.ads = self.linked_player AdsButtonPressed();
	}
	self.dummy_player.angles = (self.dummy_player.angles[0], AngleClamp180(newYaw), self.dummy_player.angles[2]);
}

mobile_cover_link_think()
{
	self endon("stop_mobile_cover_link_think");
	self endon("death");
	self.linked_player endon("death");
	
	// choose one of the below
	
	//mobile_cover_vehicle_controller();
	mobile_cover_link_think_angle_controller();
}

mobile_cover_link_think_angle_controller()
{
	Assert(self.is_mobile_cover);
	Assert(IsAlive(self.linked_player));
	
	// in this loop, we decompose the cover's position into yaw and range, and control them separately

	// the range we try to maintain from the drone	
	MIN_RANGE = COVER_FORWARD_OFFSET - 2;
	MAX_RANGE = COVER_FORWARD_OFFSET + 4;
	
	// essentially the width of the window, we change our angle to let the player see thorough it
	LINEAR_YAW_DEADZONE_RADIUS = 12;
	LINEAR_YAW_DEADZONE_RADIUS_ADS = 4;
	
	// while moving forward and backward (to fix range), we also center ourselves at this speed
	CENTERING_WHILE_MOVING_SPEED = 25;
	
	// need lots of smoothing on player position and velocity :-(
	ORIGIN_POSITION_SMOOTHING = .3;
	ORIGIN_VELOCITY_SMOOTHING = .6;
	ORIGIN_LEAD_TIME = 0.05 * 2;
	YAW_POSITION_SMOOTHING = .8;
	YAW_VELOCITY_SMOOTHING = .8;
	YAW_LEAD_TIME = .05 * 2;
	
	player_origin_controller = filter_lead_controller_init(self.dummy_player.origin, ORIGIN_POSITION_SMOOTHING, ORIGIN_VELOCITY_SMOOTHING, ORIGIN_LEAD_TIME);
	player_yaw_controller = filter_lead_controller_init(self.dummy_player.angles[1], YAW_POSITION_SMOOTHING, YAW_VELOCITY_SMOOTHING, YAW_LEAD_TIME, true);
	
	cover_origin = self.origin;
	cover_angles = self.angles;
	
	while(true)
	{
		// update our dummy_player based on the control input
		self mobile_cover_dummy_player_think();
		
		// get smoothed player stuff
		player_origin = player_origin_controller [[player_origin_controller.update_func]](self.dummy_player.origin);
		// flatten into plane of cover
		player_origin = (player_origin[0], player_origin[1], cover_origin[2]);
		player_yaw = player_yaw_controller [[player_yaw_controller.update_func]](self.dummy_player.angles[1]);
		
		// decompose into yaw and range
		player_to_cover = cover_origin - player_origin;	
		player_to_cover_angles = VectorToAngles(player_to_cover);
		player_to_cover_yaw = player_to_cover_angles[1];
		player_to_cover_range = Length(player_to_cover);
		
		// compute width of the window in angular space, which depends on our current range
		current_linear_yaw_deadzone_radius = linear_interpolate(self.blend, LINEAR_YAW_DEADZONE_RADIUS, LINEAR_YAW_DEADZONE_RADIUS_ADS);
		current_yaw_deadzone_radius = ATan(current_linear_yaw_deadzone_radius / player_to_cover_range);

		error_yaw = AngleClamp180(player_yaw - player_to_cover_yaw);
		
		// drive our angles to within the angle range of the window
		self.extra_slow_player = false;
		if(Abs(error_yaw) < current_yaw_deadzone_radius)
		{
			commanded_yaw_delta = 0;
		}
		else
		{
			commanded_yaw_delta = error_yaw - current_yaw_deadzone_radius * Sign(error_yaw);
			self.extra_slow_player = true;
		}
		
		// drive our range to within the deadzone
		// range_extension_factor makes it so the front and back edges of the deadzone are flat instead of curved
		range_extension_factor = 1 / Max(Cos(AngleClamp180(player_to_cover_yaw - cover_angles[1])), .5);
		commanded_range = Clamp(player_to_cover_range, MIN_RANGE * range_extension_factor, MAX_RANGE * range_extension_factor);
		
		// while moving forwards or backwards, we also center ourselves
		error_range = commanded_range - player_to_cover_range;
		if(abs(error_range) > 2)
		{
			if(error_range > 0)
			{
				// /#IPrintLn("close");#/
				centering = CENTERING_WHILE_MOVING_SPEED * 2;
			}
			else
			{
				// /#IPrintLn("far");#/
				centering = CENTERING_WHILE_MOVING_SPEED;
			}
			
			commanded_yaw_delta += Clamp(error_yaw, centering * -.05, centering * .05);
		}
		
		commanded_yaw = AngleClamp(player_to_cover_yaw + commanded_yaw_delta);
		
		// this is where we want to be this frame
		commanded_origin = player_origin + AnglesToForward((0, commanded_yaw, 0)) * commanded_range;
		commanded_angles = (0, player_yaw, 0);

		// update the position of what our player is attached to and relink to mobile_cover so it's smooth during client frames		
		self.tag_origin unlink();
		self.tag_origin.origin = self.dummy_player.origin;
		self.tag_origin.angles = self.dummy_player.angles;
	//	self.tag_origin linkto( self, "TAG_MOBILE_COVER_UPRIGHT" );
			
		drive_cover(commanded_origin, commanded_angles);
		
		waitframe();
				
		// /# thread draw_line_for_time(commanded_origin, self.origin, 1, 0, 0, 10); #/
	
			
		cover_origin = self.origin;
		cover_angles = self.angles;
	}
}


mobile_cover_vehicle_controller()
{
	Assert(self.is_mobile_cover);
	Assert(IsAlive(self.linked_player));

	// simple loop designed for the vehicle version	
	
	while(true)
	{
		commanded_origin = self.dummy_player.origin + AnglesToForward(self.dummy_player.angles) * COVER_FORWARD_OFFSET;
		commanded_angles = self.dummy_player.angles;
		
		drive_cover(commanded_origin, commanded_angles);
		
		waitframe();
	}
}

drive_cover(commanded_origin, commanded_angles)
{
	SPEED_CONSTANT = 1/17.6 * 13;
	MAX_SPEED = 15;
	FORCE_PLAYER_ZONE_RADIUS = 16;	
	PLAYER_FORCE_SCALE = .05 * 15;
	
	Assert(self.is_mobile_cover);
	Assert(IsAlive(self.linked_player));
	Assert(!IsDefined(self.cover_drone_disabled));

	position_error = commanded_origin - self.origin;
	position_error_flat = flat_origin(position_error);
	position_error_flat_length = Length(position_error_flat);
	self.position_error = position_error;
	
	if(position_error_flat_length > MAX_POSITION_ERROR)
	{
		/# IPrintLn("unlinked due to position"); #/
		snd_message("cdrn_auto_unlink");
		self thread player_unlink_from_cover();
	}
	if(abs(AngleClamp180(commanded_angles[1] - self.angles[1])) > MAX_ANGLE_ERROR)
	{
		/# IPrintLn("unlinked due to angles"); #/
		snd_message("cdrn_auto_unlink");
		self thread player_unlink_from_cover();
	}
	
	/*
	if(position_error_flat_length > FORCE_PLAYER_ZONE_RADIUS)
	{
		player_force = position_error_flat * ((FORCE_PLAYER_ZONE_RADIUS / position_error_flat_length) - 1) * PLAYER_FORCE_SCALE;
		self.linked_player PushPlayerVector(player_force, true);
	}
	else
	{
		self.linked_player PushPlayerVector((0, 0, 0), true);
	}
	*/
	
	
	speed = Distance2d(self.origin, commanded_origin) * SPEED_CONSTANT;
	player_speed = (self.dummy_player get_differentiated_speed()) / 17.6;
	speed = Clamp(speed, 0.01, player_speed + 3);
	// /# IPrintLn("speed: " + speed + " player speed: " + player_speed); #/
	
	/#
//	debug_update( self.linked_player.origin, commanded_origin, speed, commanded_angles[1] );
//	debug_update2( commanded_angles[1] );
	#/

	self Vehicle_RotateYaw(commanded_angles[1]);
	self VehicleDriveTo(commanded_origin, speed);
	
	/#
	//Line(commanded_origin, commanded_origin + (0, 0, 32), (1, 1, 0));
	//Line(commanded_origin + (0, 0, 32), commanded_origin + (0, 0, 32) + 32 * AnglesToForward(commanded_angles), (0, 1, 1));
	//Line(commanded_origin + (0, 0, 33), commanded_origin + (0, 0, 33) + (speed / MAX_SPEED * 32) * AnglesToForward(commanded_angles), (1, 0, 0));
	#/	
}

filter_lead_controller_init(start_position, position_smoothing, velocity_smoothing, lead_time, is_angles)
{
	controller = SpawnStruct();
	controller.is_filter_lead_controller = true;

	controller.update_func = ::filter_lead_controller_update;
	
	controller.position_smoothing = position_smoothing;
	controller.velocity_smoothing = velocity_smoothing;
	controller.lead_time = lead_time;
	controller.is_angles = IsDefined(is_angles) && is_angles;

	if(controller.is_angles)
		start_position = AngleClamp180(start_position);
	
	controller.target_position = start_position;
	controller.smooth_target_position = start_position;
	controller.smooth_target_velocity = start_position * 0;
		
	return controller;
}

filter_lead_controller_update(target_position, delta_t)
{
	Assert(self.is_filter_lead_controller);
	if(!IsDefined(delta_t)) delta_t = .05;
	
	if(self.is_angles)
		target_position = AngleClamp180(target_position);
	
	target_delta = target_position - self.target_position;
	
	if(self.is_angles)
		target_delta = AngleClamp180(target_delta);
	
	target_velocity = target_delta / delta_t;
	self.target_position = target_position;
	
	if(self.is_angles)
	{
		self.smooth_target_position = angle_interpolate(self.position_smoothing, target_position, self.smooth_target_position);
	}
	else
	{
		self.smooth_target_position = linear_interpolate(self.position_smoothing, target_position, self.smooth_target_position);		
	}
	self.smooth_target_velocity = linear_interpolate(self.velocity_smoothing, target_velocity, self.smooth_target_velocity);
	
	advanced_target_position = self.smooth_target_position + self.smooth_target_velocity * self.lead_time;
	
	if(self.is_angles)
		advanced_target_position = AngleClamp(advanced_target_position);
	
	return advanced_target_position;	
}

angle_interpolate(t, a, b)
{
	return AngleClamp180(a + AngleClamp180(b - a) * t);
}

sigmoid( t )
{
	graph = [ [0,0], [0.3, 0.05], [0.4, 0.2], [0.5, 0.5], [0.6,0.8], [0.7,0.95], [1.0,1.0] ];
	foreach (idx,pnt2 in graph)
	{
		if (pnt2[0] >= t)
		{
			if (idx > 0)
			{
				pnt = graph[idx-1];
				d = t-pnt[0];
				r = pnt2[0] - pnt[0];
				f = d/r;
				t = f*(pnt2[1] - pnt[1]) + pnt[1];
				return t;
			}
			else
				return pnt2[1];
		}
	}
	return t;
}

#using_animtree("vehicles");
player_ads_think()
{
	Assert( self.is_mobile_cover );
	Assert(IsDefined(self.linked_player));
	self.linked_player endon( "death" );
	self.linked_player endon( "player_unlinked_from_cover" );
	self endon("death");
	
	self notify("new_ads_think");
	self thread close_ads_window_on_unlink();

	self.window_position = "up";

	blend_down_delta = .05 / WINDOW_DOWN_TIME;
	blend_up_delta = -.05 / WINDOW_UP_TIME;

	old_blend = 0;
	going_down = 0;
	down_release_to = 0;
	while(true)
	{
		go_down = (self.linked_player AdsButtonPressed() || self.linked_player IsThrowingGrenade());
		if(go_down || going_down || (down_release_to>0))
		{
			self.blend += blend_down_delta;
			if (go_down)
				going_down = 1;
		}
		else
		{
			self.blend += blend_up_delta;
		}
		if (down_release_to > 0)
			down_release_to--;
		self.blend = clamp(self.blend, 0, 1);
		if (self.blend == 1)
		{
			going_down = 0;
			if(go_down)
				down_release_to = 3;
		}
		
		if(old_blend == 0 && self.blend != 0)
		{
			self PlaySound("cdrn_window_open");
		}
		else if(old_blend == 1 && self.blend != 1)
		{
			self PlaySound("cdrn_window_close");			
		}
		else if(old_blend != 0 && self.blend == 0)
		{
			self PlaySound("cdrn_window_open_latch");
		}
		else if(old_blend != 1 && self.blend == 1)
		{
			self PlaySound("cdrn_window_close_latch");
		}
		blend = sigmoid(self.blend);
		
		self SetAnim(%mobile_cover_window_down_pose, blend, 0.05, 1);
		self SetAnim(%mobile_cover_window_up_pose, 1 - blend, 0.05, 1);
		
		self.linked_player player_update_slow_aim(true, self);
		
		if(self.blend > .5)
		{
			self.window_position = "down";
		}
		else
		{
			self.window_position = "up";			
		}
		
		
		old_blend = self.blend;
		waitframe();
	}
}

close_ads_window_on_unlink()
{
	self endon("new_ads_think");
	self.linked_player endon( "death" );
	self endon("death");
	self.linked_player waittill( "player_unlinked_from_cover" );
	blend_up_delta = -.05 / WINDOW_UP_TIME;
	while (self.blend < 1.0)
	{
		self.blend += blend_up_delta;
		self.blend = clamp(self.blend, 0, 1);
		if(self.blend > .5)
		{
			self.window_position = "down";
		}
		else
		{
			self.window_position = "up";			
		}
		blend = sigmoid(self.blend);
		
		self SetAnim(%mobile_cover_window_down_pose, blend, 0.05, 1);
		self SetAnim(%mobile_cover_window_up_pose, 1 - blend, 0.05, 1);
		wait 0.05;
	}
}

// don't change these, they should match the corresponding constants at the top of aim_assist.cpp
AIM_TURNRATE_YAW = 260;
AIM_TURNRATE_YAW_ADS_FOV = 90 * .73;  // unfortunately the fudge factor varies per-weapon based on the ADS FOV

player_update_slow_aim(is_linked, mobile_cover)
{
	Assert(IsPlayer(self));
		
	if(is_linked)
	{
		Assert(IsDefined(mobile_cover));
		
		// as of current tunings, this will range from 0.6 to 4, defaulting to 1 (see sensitivityMap in gamerprofile.cpp)
		viewSensitivity = self GetLocalPlayerProfileData("viewSensitivity");
		// the pow is a fudge to counteract lag effect when coming out of ADS, which would cause you to move too fast momentarily.
		ads_blend = pow(self PlayerADS(), 3);
		yaw_scale = linear_interpolate(ads_blend, LINKED_MAX_TURN_RATE / AIM_TURNRATE_YAW, LINKED_MAX_TURN_RATE / AIM_TURNRATE_YAW_ADS_FOV) / viewSensitivity;
		
		if(mobile_cover.extra_slow_player)
		{
			yaw_scale *= .75;	
		}
		
		yaw_scale = clamp(yaw_scale, .01, .99);
		pitch_scale = clamp(yaw_scale * LINKED_MAX_PITCH_TO_YAW_SCALE_RATIO, .01, .99);
		self EnableSlowAim(pitch_scale, yaw_scale);
		self SetMoveSpeedScale(LINKED_MOVE_SPEED_SCALE);
		
		self.yaw_scale = linear_interpolate(ads_blend,LINKED_MAX_TURN_RATE / AIM_TURNRATE_YAW, 0.25*(LINKED_MAX_TURN_RATE / AIM_TURNRATE_YAW));
		self.move_scale = LINKED_MOVE_SPEED_SCALE;
	}
	else
	{
		self.yaw_scale = 1.0;
		self.move_scale = 1.0;
		self DisableSlowAim();
		self SetMoveSpeedScale(1);
	}
}

player_wait_to_unlink()
{
	Assert( self.is_mobile_cover );
	
	if(!IsDefined(self.linked_player))
		return;
			
	counter = 0;
	text	= undefined;
	time	= 0.5;
	
	while(IsDefined(self.linked_player) && self.linked_player UseButtonPressed())
		waitframe();
	
	while ( IsDefined(self.linked_player) )
	{
		if ( !IsDefined( text ) )
		{
			text = create_trigger_hint_string( "unlink" );
			level.player disable_weapon_pickup_wrapper();
		}
		
		if ( self.linked_player UseButtonPressed() )
		{
			counter += 0.05;
			
		}
		else
		{
			counter = 0;
		}
		
		if ( counter >= time )
		{
			self thread player_unlink_from_cover();
		}
		
		wait( 0.05 );
	}
	
	if(IsDefined(text))
	{
		text Destroy();
		level.player enable_weapon_pickup_wrapper();
	}			
}

player_unlink_on_sprint()
{
	Assert(self.is_mobile_cover);
	if(!IsDefined(self.linked_player))
	{
		return;
	}
	self.linked_player endon("death");
	self.linked_player endon("player_unlinked_from_cover");
	self endon("death");
		
	self.linked_player NotifyOnPlayerCommand("mobile_cover_sprint_pressed", "+sprint_zoom");
	self.linked_player NotifyOnPlayerCommand("mobile_cover_sprint_pressed", "+sprint");
	self.linked_player NotifyOnPlayerCommand("mobile_cover_sprint_pressed", "+breath_sprint");
	self.linked_player waittill("mobile_cover_sprint_pressed");
	self player_unlink_from_cover();
}

player_unlink_on_death()
{
	Assert(self.is_mobile_cover);
	if(!IsDefined(self.linked_player))
		return;
	
	self.linked_player endon("player_unlinked_from_cover");
	self.linked_player waittill("death");
	self player_unlink_from_cover();
}

// should be safe to call any time
player_unlink_from_cover()
{
	self notify("stop_mobile_cover_link_think");
	
	self.linked_player.linked_to_cover = undefined;
	
	self vehicle_scripts\_cover_drone_aud::snd_stop_cover_drone( 1.0 , 0.5);
	
	maps\_warzone_tactics::add_object_to_tactics_system( self );
	
	self Unlink();
	self.linked_player unlink();
	self.tag_origin delete();
	self.tag_origin = undefined;
	self.dummy_player delete();
	self.dummy_player = undefined;
	self.linked_player EnableMouseSteer( false );
		
	SetSavedDvar( "bg_viewBobAmplitudeStanding" , level.old_viewBobAmplitudeStanding );
	SetSavedDvar( "bg_viewBobAmplitudeDucked"	, level.old_viewBobAmplitudeDucked );
	SetSavedDvar( "bg_viewBobAmplitudeSprinting", level.old_viewBobAmplitudeSprinting );
	
	self.linked_player AllowJump( true );
	self.linked_player enable_weapon_pickup_wrapper();
	
	self.linked_player player_update_slow_aim(false);
	self.linked_player PushPlayerVector((0, 0, 0), true);
	
	self VehicleDriveTo(self.origin, 0);
	
	StopFXOnTag( getfx( "link_light" ), self, MOBILE_COVER_FX_TAG );
	PlayFXOnTag( getfx( "unlink_light" ), self, MOBILE_COVER_FX_TAG );
	
	self SetModel( self.original_model );
	
	old_linked_player = self.linked_player;
	self.linked_player = undefined;
	
	// must be last in case people didn't thread this call
	old_linked_player notify( "player_unlinked_from_cover" );
}

get_mobile_cover_base_from_ent( ent )
{
	if ( IsDefined( ent.is_mobile_cover ) )
	{
		Assert( ent.is_mobile_cover );
		return ent;
	}
	return undefined;
}

player_enable_highlight()
{		
	if(!IsDefined(self.linked_player))
		return;
	
	self.linked_player endon( "death" );
	
	radar_highlight = NewClientHudElem( self.linked_player );

	radar_highlight.color = (1, 0.05, 0.025);
	radar_highlight.alpha = 0.01;

	radar_highlight SetRadarHighlight( -1 );

	self.linked_player waittill("player_unlinked_from_cover");
	
	radar_highlight Destroy();
}

create_trigger_hint_string( state )
{
	text = level.player createClientFontString( "default", 1.5 );
				
	text.alpha = 0.7;
	text.alignx = "center";
	text.aligny = "middle";
	text.y = 120;
	text.horzAlign = "center";
	text.vertAlign = "middle";
	text.foreground = false;
	text.hidewhendead = true;
	text.hidewheninmenu = true;
	
	AssertEx( isDefined( state ), "must specify if linking or unlinking for string" );
	
	if( state == "link" )
	{
		text SetText( &"COVER_DRONE_LINK" );
	}
	else
	{
		text SetText( &"COVER_DRONE_UNLINK" );
	}
	
	return text;
}

mobile_cover_sound_think()
{
	Assert(self.is_mobile_cover);
	
	if(!IsAlive(self.linked_player))
		return;
	
	sound_ent_l = spawn_tag_origin();
	sound_ent_r = spawn_tag_origin();
	sound_ent_l LinkTo(self, "", (0,     COVER_HALF_WIDTH, 0), (0, 0, 0));
	sound_ent_r LinkTo(self, "", (0, 0 - COVER_HALF_WIDTH, 0), (0, 0, 0));
	
	
	thread mobile_cover_sound_loop(sound_ent_l);
	thread mobile_cover_sound_loop(sound_ent_r);
	
	
	self.linked_player waittill_either("death", "player_unlinked_from_cover");
	
	sound_ent_l Delete();
	sound_ent_r Delete();
}

mobile_cover_sound_loop(sound_ent)
{
	sound_ent endon("death");
	//sound_ent PlayLoopSound("cover_drone_moving_loop");
	
	SPEED_SMOOTHING = .6;
	
	MIN_SPEED = 17.6 * 1;
	MAX_SPEED = 17.6 * 15;
	
	MIN_SPEED_VOLUME = .4;
	MAX_SPEED_VOLUME = .5;
	
	old_origin = sound_ent.origin;
	smooth_speed = 0;

	while(true)
	{
		// to run after the script that moves the cover
		waittillframeend;
		
		speed = Length(sound_ent.origin - old_origin) * 20;
		smooth_speed = linear_interpolate(SPEED_SMOOTHING, speed, smooth_speed);
		old_origin = sound_ent.origin;
		
		freq_scale = linear_map_clamp(smooth_speed, 0, MAX_SPEED, 0, 1);
		// these are the engine limits
		freq_scale = clamp(freq_scale, .002, 3.99);
		
		sound_ent SetPitch(freq_scale, .05);
		
		if(smooth_speed > MIN_SPEED)
		{
			sound_ent SetVolume(linear_map_clamp(smooth_speed, 0, MAX_SPEED, MIN_SPEED_VOLUME, MAX_SPEED_VOLUME), .05);			
		}
		else
		{			
			sound_ent SetVolume(0, .05);
		}
		
		waitframe();
	}
}

mobile_cover_impulse()
{
	// when the mobile cover moves, we generate some fake explosions to push things
	self endon("death");
	
	old_pos = self.origin;
	while (true)
	{
		if (isdefined(self.linked_player))
		{
			if (distance( self.origin, old_pos ) > 6)
			{
				old_pos = self.origin;
				PhysicsExplosionCylinder(self.origin, 26, 24, 0.25);
			}
			wait 0.1;
		}
		else
			wait 0.5;
	}
}

// if we enable pickup immediately upon hiding the prompt, since player has been holding X already, he may pickup the weapon
// immediately.  So don't re-enable it for a minute.
enable_weapon_pickup_wrapper()
{
	self thread enable_weapon_pickup_wrapper_internal();
}

enable_weapon_pickup_wrapper_internal()
{
	Assert(IsPlayer(self));
	self endon("death");
	self endon("stop_enable_weapon_pickup_wrapper");

	wait 2;
	self EnableWeaponPickup();	
}

disable_weapon_pickup_wrapper()
{
	Assert(IsPlayer(self));
	self notify("stop_enable_weapon_pickup_wrapper");
	self DisableWeaponPickup();
}


/*QUAKED script_vehicle_cover_drone (1 0 0) (-16 -16 -24) (16 16 32) x SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_cover_drone::main( "vehicle_mobile_cover", undefined, "script_vehicle_cover_drone" );
	
These will be added to your levels CSV when compile with Repackage Zone/Script:

include,cover_drone
 
defaultmdl="vehicle_mobile_cover"
default:"vehicletype" "cover_drone"
*/

