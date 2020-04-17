///////////////////////////////////////////////////////////////////
// _securitycamera
//
// revision date: 11/15/07
//
//	Setup:
//		CAMERAS - bare minimum to get a camera functional:
//		1) Place a camera (script_model) and base (misc_model) in the map.  
//				For a wall mounted camera: p_msc_security_cam_laser_head and p_lvl_secrty_cmra_arm
//				For a ceiling mounted camera: p_lvl_secrty_cmra_arm_ceiling and p_lvl_secrty_cmra_head_ceiling
//			Give the camera a targetname.  Additional attributes can be found below.
//		2) Place reinforcements to spawn if camera spots player or body.  Have the camera target the spawners.
//		3) In script, call:
//				maps\_securitycamera::init();	It's already included in _common.csv
//			Also, for each camera:
//				camera_ent = GetEnt( "cameraname", "targetname" );
//				camera_ent maps\_securitycamera::camera_start( power_box, true, undefined, undefined);	// see list of parameters below if you want to change
//			(or if it's a montitor/view camera):
//				camera_ent maps\_securitycamera::camera_start( undefined, false, undefined, undefined);	// see list of parameters below if you want to change
//		4) Add to levelname.csv:
//				include,security_camera
//
//		POWER BOXES - a box placed near the camera.  The player can interact with it to disable the camera safely.
//		1) Place the box and lid (script_models):  p_msc_cctv_box & p_msc_cctv_box_lid
//		2) Give the hackbox a name and have it target the lid.
//		3) When you call camera_start, the first parameter is the power_box entity, so remember to pass that along
//
//		FEED BOXES - a box that will show the feeds of up to 3 cameras at once.
//		1) Place the feed box and lid (script_models): p_msc_cctv_box_02 && p_msc_cctv_box_lid_02
//		2) Give the feedbox a name and have it target the lid.
//		3) In Script: The feedbox needs to be initialized separately by calling:
//				_securitycamera::camera_tap_start( feedbox, cameraArray);
//			Where cameraArray is an array of the camera entities you want to be able to see through
//		4) The feed will be enabled after you hack into the box.  Use the phone menu to see them.
//			A feed will be disabled if the camera is damaged or disabled or if new feeds are setup.
//
//	Security Cameras Keys Used
//		script_int - rotation time to do a complete arc
//		script_float - rotation arc
//		script_delay - wait time before spawners are spawned
//		script_radius - distance that camera will go check out to
//		use_range - sets max distance the player can be from the camera to initiate hack ( max 192 units )
//		target - name of spawners to spawn if player spotted
//
//
//	Remote Hack Entity Keys Used
//		script_alert - notification string to wait for before hacking enabled
//		use_range - sets max distance the player can be from the camera to initiate hack ( max 192 units )
//
//
//	Misc info
//		ai_camera_guard_[x] - targetname of ai spawned from camera
//		level.player.camera_phone - this is set to the camera entity that is currently being rendered to a texture
//
//
//	camera_start() parameters
//		eHackbox - entity to be used for disabling the camera
//		bTrack - bool flag to enable or disable player & corpse tracking
//		UnusedbVideoOn - This is currently unused.  Used to set the initial world video camera to this security camera
//		UnusedbEnablePhone - This is currently unused.  bool flag to force video to phone immediately
//
//
///////////////////////////////////////////////////////////////////
//security camera
// BONE 0 -1 "TAG_ORIGIN"
// BONE 1 0 "TAG_CAMERA"
// BONE 2 0 "TAG_FLASH"
// BONE 3 0 "TAG_LASER"
// BONE 4 0 "TAG_LIGHT"
// BONE 5 1 "TAG_TARGET"
//
#include common_scripts\utility;
#include maps\_utility;


///////////////////////////////////////////////////////////////////
// Camera Init and Start
///////////////////////////////////////////////////////////////////

// init security camera settings
init(use_model)
{
	// precache model
	if (!IsDefined(use_model) || use_model)
	{
		PrecacheModel( "p_msc_security_cam_laser_head_d" );

		// precache fx
		level._securitycamera["death"]				= Loadfx( "explosions/powerlines_b" );
		level._securitycamera["spark"]				= Loadfx( "misc/camera_sparks" );
		level._securitycamera["smoke"]				= Loadfx( "smoke/chimney_small" );
		level._securitycamera["laser"]				= Loadfx( "props/security_camera_on" );
		level._securitycamera["light_green"]		= Loadfx ("misc/camera_green");
		//	level._securitycamera["light_yellow"]		= Loadfx ("misc/camera_yellow");
		level._securitycamera["light_red"]			= Loadfx( "misc/camera_red");
		level._securitycamera["light_red_solid"]	= Loadfx( "misc/camera_red_solid" );
		level._securitycamera["spotlight"]			= Loadfx( "props/security_camera_on" );
	}

	// get player entity
	level.player = GetEnt("player", "classname" );

	// setup array of cameras taps
	level._securitycamera_tap = [];
	camera_clear_array();

	// start thread to monitor security camera taps
	level.player thread camera_tap_monitor();
	level.player thread camera_close_monitor();
}

//
// initialize the camera, get it working.
//
camera_start( eHackbox, bTrack, UnusedbVideoOn, UnusedbEnablePhone, remoteViewEnt )
{
	// set camera alert
	self.spotted = false;

	// set camera destroyed flag
	self.destroyed = false;

	// set camera hack flag
	self.disabled = false;

	// set init angles of camera
	self.angle_start = self.angles;

	// overrides can_use_check from _unlock_mechanisms
	self.can_use_override = true;

	// setup default entity to be tracked
	self._secr_cam_target = level.player;

	// set camera tracking default to true
	if( !IsDefined( bTrack ) )
	{
		bTrack = true;
	}

	// start tracking check
	//	if bTrack is false, then this is a "view" camera.  Only for showing off certain areas.
	//	It will not track the player or bodies and is not being monitored.
	if( bTrack )
	{
		// State = green (normal), yellow (suspcious), red (alerted)
		//	a yellow state will transition to red in X secs. if suspicious entity still visible.
		//		will go back to green if not
		set_camera_state( "green" );

		// start cone trace
		self thread cone_trace( self );
		self thread camera_track_check( self );

		// setup entity used to disable camera
		if( IsDefined( eHackbox ) )
		{
			// setup camera that this box is connected to
			eHackbox.camera = self;
			self._hackbox	= eHackbox;

			// Get Lid 
			if ( IsDefined( eHackbox.target ) )
			{
				eHackbox._lid = GetEnt( eHackbox.target, "targetname" );

				// Get switch
				if ( IsDefined( eHackbox._lid ) && IsDefined( eHackbox._lid.target ) )
				{
					eHackbox._switch = GetEnt( eHackbox._lid.target, "targetname" );
					if ( IsDefined( eHackbox._switch ) )
					{
						eHackbox._switch RotatePitch( -30.0, 0.05 );
					}
				}
			}

			// setup usable camera remote disabler object
			maps\_playerawareness::SetupEntSingleUseOnly(	eHackbox, 
				::camera_hackbox_disable,
				&"HINT_CAMERA_POWERBOX", 
				0, 
				undefined, 
				true, 
				true, 
				undefined, 
				level.awarenessMaterialNone, 
				false, 
				false, 
				false );
		}

		self showSecurityCameraOnMap( true );
	}
	else
	{
		set_camera_state( "view" );
	}

	// check to see if it's a model or a disembodied camera
	if ( self.classname == "script_model" )
	{
		// start fov fx
		self thread camera_fov_fx( bTrack );

		// start damage check & mousetrap
		self thread camera_damage( eHackbox );
	}

	// start rotation
	self thread camera_rotate( self, remoteViewEnt );
}


///////////////////////////////////////////////////////////////////
// Camera FOV, movement and tracking
///////////////////////////////////////////////////////////////////

// check to see if player is within camera fov
cone_trace( entCamera )
{
	// setup endon conditions
	entCamera endon( "damage" );
	entCamera endon( "disable" );

	// define fov for camera default
	fFOV = .9;
	//if ( IsDefined( entCamera.script_dot ) )
	//{
	//	fFOV = entCamera.script_dot;
	//}

	// get camera position
	vCamera_origin = entCamera.origin;

	// define max distance
	iMax_dist = 512;
	//	iMax_dist = 350;
	if ( IsDefined( entCamera.script_radius ) )
	{
		iMax_dist = entCamera.script_radius;
	}


	while( true )
	{
/#	
		//If the player is set ignored by AI... it is the same as disabling camera
		if( IsDefined(level.player) && (level.player isignoredbyai()) )
		{
			wait(0.10);
			continue;
		}
#/

		// get array of cadavers & player
		entaVis_ents = entsearch( level.CONTENTS_CORPSE + level.CONTENTS_PLAYER, vCamera_origin, iMax_dist );

		// check to see if sight trace is passed
		// take 1st passed entity as target
		for( i = 0; i < entaVis_ents.size; i++ )
		{
			// use player eye position if ent is player
			if( entaVis_ents[i] == level.player )
			{
				vTarget_origin = level.player GetEye();
			}
			else
			{
				vTarget_origin = entaVis_ents[i].origin;
			}

			// check to see if camera can see target
			if( sightTracePassed( vCamera_origin, vTarget_origin, false, undefined ) )
			{
				entCamera._secr_cam_target = entaVis_ents[i];

				break;
			}
			else
			{
				entCamera.spotted = false;
			}
		}

		// check to see if entity is valid, mainly for dead self-deleting corpses
		if( !IsDefined( entCamera._secr_cam_target) )
		{
/#
			if( GetDVarInt( "secr_camera_debug" ) == 1 )
			{	
				Print3d( vCamera_origin + (0, 0, 64), "UNDEFINED TARGET", (0, 1, 0), 1, 1, 5 );
			}
#/
			entCamera.spotted = false;
			entCamera._secr_cam_target = level.player;
			wait( 0.15 );
			continue;
		}

		// check to see if camera can see target if it moves out of range
		if( entCamera._secr_cam_target == level.player )
		{
			vTarget_origin = level.player GetEye();
		}
		else
		{
			vTarget_origin = entCamera._secr_cam_target.origin;
		}
		if( (!sightTracePassed( vCamera_origin, vTarget_origin, false, undefined )) ||
			( ( entCamera.spotted == false ) && ( Distance( entCamera.origin, vTarget_origin ) > iMax_dist ) ) )
		{
/#
			if( GetDVarInt( "secr_camera_debug" ) == 1 )
			{	
				Print3d( vCamera_origin + (0, 0, 64), "NO LOS", (0, 1, 0), 1, 1, 5 );
			}
#/
			entCamera.spotted = false;
			wait( 0.15 );
			continue;
		}

		// simulate vision cone
		vOffset = vTarget_origin - vCamera_origin;
		vNormal = vectorNormalize( vOffset );
		vCamera_forward = anglesToForward( entCamera.angles );

		fDot = vectorDot( vCamera_forward, vNormal );
		if ( fDot >= fFOV )	// in view and not too far away
		{
			entCamera.spotted = true;

/#
			if( GetDVarInt( "secr_camera_debug" ) == 1 )
			{	
				Print3d( vCamera_origin + (0, 0, 64), "SPOTTED", (0, 1, 0), 1, 1, 5 );
			}
#/
		}
		else
		{
			entCamera.spotted = false;

/#
			if( GetDVarInt( "secr_camera_debug" ) == 1 )
			{	
				Print3d( vCamera_origin + (0, 0, 64), "OUTSIDE FOV", (0, 1, 0), 1, 1, 5 );
			}
#/
		}
		wait( 0.15 );
	}
}

// camera fov fx
//	Initializes fx to be played on the camera
//	05/17/08 mjm - redid effect attachments so they are in the right spots and lights work
camera_fov_fx( bTrack )
{
	//	self LaserOn();
	//	self LaserOff();

	// Only show spotlight if tracking cam
	if ( bTrack )
	{
		self.spotlight = Spawn( "script_model", self GetTagOrigin( "tag_flash" ) );
		self.spotlight SetModel( "tag_origin" );
		self.spotlight.angles = self.angles;

		// NOTE NOTE NOTE NOTE ########################################################################
		//	If you need to have your FX be moveable, the effect itself actually needs to have X flag set
		//	so that it WILL MOVE if it's linked.  Otherwise, it will remain static NO MATTER WHAT YOU DO!!!
		// NOTE NOTE NOTE NOTE ########################################################################
		self.spotlight LinkTo( self );
		PlayfxOnTag( level._securitycamera["spotlight"], self.spotlight, "tag_origin" );

		// wait for stop
		self waittill_any( "damage", "disable" );

		self.spotlight Delete();
	}
}

//
//	Camera states:
//		view - not monitored, for recon only
//		green - normal operation
//		yellow - spotted something suspicious (warning)
//		red - alerted
//		off - disabled/destroyed
//
set_camera_state( state )
{
	self.state = state;

	switch( state )
	{
	case "view":
	case "green":
		set_camera_light( state );
		break;
	case "yellow":
		set_camera_light( "yellow" );
		self playsound ("security_cam_beep_alert");
		//iprintlnbold ("SOUND: 6beep camera alert");
		break;
	case "red":
		set_camera_light( "off" );
		self notify( "spotted" );
		self thread camera_spawn_reinforcements();
		//self thread camera_audio_alert();
		self PlaySound( "Security_Cam_Siren" );
		break;
	case "off":
		set_camera_light( "off" );
		self stoploopsound();
		//iprintlnbold ("SOUND: Camera OFF");
	default:
		set_camera_light( "off" );
		break;
	}
}

//
//	The flashing light on the top of the camera
//
set_camera_light( state )
{
	// If there was an old light, change it to the new one
	if ( self.classname == "script_model" )
	{
		if ( IsDefined(self.light_origin) )
		{
			self.light_origin Delete();
			self.light_origin = undefined;
			wait(0.05);
		}

		if ( state == "off" )
		{
			return;
		}
		self.light_origin = Spawn( "script_model", self GetTagOrigin( "tag_light" ) );
		if ( IsDefined( self.light_origin ) )
		{
			self.light_origin SetModel( "tag_origin" );
			self.light_origin.angles = self.angles;

			// NOTE NOTE NOTE NOTE ########################################################################
			//	If you need to have your FX be moveable, the effect itself actually needs to have X flag set
			//	so that it WILL MOVE if it's linked.  Otherwise, it will remain static NO MATTER WHAT YOU DO!!!
			// NOTE NOTE NOTE NOTE ########################################################################
			self.light_origin LinkTo( self );

			switch( state )
			{
			case "view":
				PlayfxOnTag( level._securitycamera["light_green"], self.light_origin, "tag_origin" );
				break;
			case "green":
			case "yellow":
				PlayfxOnTag( level._securitycamera["light_red"], self.light_origin, "tag_origin" );
				break;
			case "red":
				PlayfxOnTag( level._securitycamera["light_red_solid"], self.light_origin, "tag_origin" );
				break;
			}
		}
	}
}


// rotate camera
camera_rotate( entCamera, remoteViewEnt )
{
	// setup endon thread
	entCamera endon( "damage" );
	entCamera endon( "spotted" );
//	entCamera endon( "disable" );

	// set default rotation
	fRotation_angle = 45;
	if ( IsDefined( entCamera.script_float ) )
	{
		fRotation_angle = entCamera.script_float/2;

		if ( fRotation_angle == 0.0 )
		{
			// We're not rotating, so get out!
			return;
		}
	}


	// set default roation time
	fRotation_time = 6;
	if ( IsDefined( entCamera.script_int ) )
	{
		fRotation_time = entCamera.script_int/2;
	}

	// set max/min rotation
	entCamera.angle_min = ( entCamera.angle_start[0], entCamera.angle_start[1] + fRotation_angle, entCamera.angle_start[2] );
	entCamera.angle_max = ( entCamera.angle_start[0], entCamera.angle_start[1] - fRotation_angle, entCamera.angle_start[2] );

	// start audio
	self thread camera_audio();

	// rotate camera
	while( !self.destroyed )
	{
		// rotate camera
		entCamera RotateTo( entCamera.angle_min, fRotation_time );
		//entCamera playsound ("security_cam_move_start");
		//iprintlnbold ("SOUND: rotate");
		//entCamera playloopsound ("Security_Cam_Move", .2);
		entCamera waittill( "rotatedone" );
		//iprintlnbold ("SOUND: rotate stop");
		entCamera stoploopsound();
		entCamera playsound ("security_cam_move_end");
		if ( isDefined( remoteViewEnt ) )
		{
			remoteViewEnt stoploopsound();
			remoteViewEnt playsound ("remote_security_cam_move_end");
		}
		wait( 1.5 );	// slight delay at the max angles
		
		entCamera RotateTo( entCamera.angle_start, fRotation_time );
		//iprintlnbold ("SOUND: rotate right to left");
		entCamera playsound ("security_cam_move_start");
		entCamera playloopsound ("Security_Cam_Move", .2);
		if ( isDefined( remoteViewEnt ) )
		{
			remoteViewEnt playsound ("remote_security_cam_move_start");
			remoteViewEnt playloopsound ("remote_Security_Cam_Move", .2);
		}
		entCamera waittill( "rotatedone" );
		entCamera RotateTo( entCamera.angle_max, fRotation_time );
		entCamera waittill( "rotatedone" );
		//iprintlnbold ("SOUND: rotate stop");
		entCamera stoploopsound();
		entCamera playsound ("security_cam_move_end");
		if ( isDefined( remoteViewEnt ) )
		{
			remoteViewEnt stoploopsound();
			remoteViewEnt playsound ("remote_security_cam_move_end");
		}
		wait( 1.5 );	// slight delay at the max angles
		
		entCamera RotateTo( entCamera.angle_start, fRotation_time );
		entCamera playsound ("security_cam_move_start");
		entCamera playloopsound ("Security_Cam_Move");
		if ( isDefined( remoteViewEnt ) )
		{
			remoteViewEnt playsound ("remote_security_cam_move_start");
			remoteViewEnt playloopsound ("remote_Security_Cam_Move");
		}
		entCamera waittill( "rotatedone" );
		//entCamera stoploopsound();
		//entCamera playsound ("security_cam_move_end");
	}
}


// track player with camera
camera_track_check( entCamera )
{
	// setup endon thread
	entCamera endon( "damage" );
	entCamera endon( "disable" );

	// track player
	while( true )
	{
		// if camera has spotted continue loop
		if( !entCamera.spotted )
		{
			wait( 0.15 );
			continue;
		}
		else
		{
			set_camera_state( "yellow" );
			self thread camera_track();
			wait( 2.0 );	// This is how long you have until you are positively identified.

			if ( !entCamera.spotted )
			{
				// lost track
				set_camera_state( "green" );
				continue;
			}
			set_camera_state( "red" );
			wait( 1.0 );
			//			camera_track( entCamera );
			//			entCamera thread camera_rotate( entCamera );
			entCamera thread camera_disable();
			return;
		}
	}
}


//
//	This moves the camera to track its target.
//	Actual line of sight check is in camera_fov_fx
camera_track()
{
	// setup endon thread
	self endon( "damage" );
	self endon( "disable" );
	
	lost_LOS_time = 0;
	// check to see if entity is valid
	if( !IsDefined( self._secr_cam_target ) )
	{
		self.spotted = false;
		return;
	}

	// track player with camera
	while( self.state != "green" )
	{
		// check to see if entity is valid
		if( !IsDefined( self._secr_cam_target ) )
		{
			self.spotted = false;
			self notify( "sound_done" );
			return;
		}

		// don't keep tracking if you can't see your target
		if ( !self.spotted )
		{
			if ( lost_LOS_time == 0 )
			{
				lost_LOS_time = GetTime() + 200;	// time in milliseconds
			}
			if ( GetTime() > lost_LOS_time )
			{
				// 
				while ( !self.spotted )
				{
					wait( 0.1 );
				}
				lost_LOS_time = 0;
			}
		}		

		// check to see what position to test against then rotate to position
		if( self._secr_cam_target == level.player )
		{
			vTarget_origin = level.player GetEye();
		}
		else
		{
			vTarget_origin = self._secr_cam_target.origin;
		}

		angles = VectorToAngles( vTarget_origin - self.origin );
		// Don't look too far down
		if ( angles[0] > 35 )
		{
			angles = (35, angles[1], angles[2]);
		}
		else if ( angles[0] < -35 )
		{
			angles = (-35, angles[1], angles[2]);
		}

		// Limit your yaw too
		// NOTE - needs an algorithm to figure out the shortest 
		// 		if ( angles[1] > 35 )
		// 		{
		// 			angles = (angles[0], self.angles_max, angles[2]);
		// 		}
		// 		else if ( angles[1] < -35 )
		// 		{
		// 			angles = (angles[0], , angles[2]);
		// 		}

		self RotateTo( angles, 0.2 );
		wait( 0.2 );
	}

	// stop alert sound thread
	self notify( "sound_done" );
}


///////////////////////////////////////////////////////////////////
// Camera Destruction/Disable
///////////////////////////////////////////////////////////////////

// tracks for camera damage
camera_damage( eHackbox )
{
	// set camera to take damage
	self SetCanDamage( true );
	self.health = 100;


	self waittill( "damage" );
	self thread camera_drop();

	// stop phone camera
	self.destroyed = true;
	self camera_disable_tap();
	self showSecurityCameraOnMap( false );

	if ( IsDefined( eHackbox ) )
	{
		eHackbox SetUseable( false );
	}

	// notify to stop alert sound
	self notify( "sound_done" );

	// stop rotation
	if( !self.disabled )
	{
		self RotateTo( ( 55, self.angles[1], self.angles[2] ), 0.55 );
		// Don't make view cams change to red
		if ( self.state == "view" )
		{
			self set_camera_state( "off" );
		}
		else
		{
			self set_camera_state( "red" );
		}
	}
	else
	{
		self set_camera_state( "off" );
	}

	// change model
	// self SetModel( "p_lvl_secrty_cmra_head_d" );
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// 04-21-08
	// wwilliams
	// changing this to call on the new model of the security camera
	self SetModel( "p_msc_security_cam_laser_head_d" );
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// playfx & sound
	Playfx( level._securitycamera["death"], self.origin );
	//	Playfx( level._securitycamera["smoke"], self.origin );
	//iprintlnbold ("SOUND: camera break");
	self PlaySound( "Security_Cam_Break" );

	// stop sound
	self StopLoopSound();

	// start distraction
	CreateDistraction( "Subtle", "", 0, 60, "", "", self.origin, 60, "" );
}

// drop camera as mousetrap
camera_drop()
{
	// loops sparx fx on 1st stage destruction
	wait( 0.05 );

	spark = SpawnFx(level._securitycamera["spark"], self.origin);
	TriggerFx(spark);

	// wait till destroyed
	// first waittill needs to be outside the loop so the variables can be used further down
	self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
	while ( self.health > 0 )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
	}

	// play spark fx
	spark Delete();
	Playfx( level._securitycamera["death"], self.origin );
	self set_camera_state( "off" );

	// launch camera into physics
	self PhysicsLaunch( point, vector_multiply( direction_vec, 1 ) );

	// fake drop damage
	for( i = 0; i < 10; i++ )
	{
		self RadiusDamage( self.origin + (0, 0, -32), 64, 25, 25);
		wait( 0.1 );
	}

	// create distraction
	wait( 0.5 );
	CreateDistraction( "obvious", "", 0, 60, "", "", self.origin, 60, "" );
}

// disable camera
camera_disable()
{
	// notify to disable camera
	self notify( "disable" );

	/////////////////////////////////////////////////////////////////////////
	// 06-07-08
	// wwilliams
	// adding a level notify that the camera has been disabled
	// level notify( "ACH_CAM_DISABLED" );
	// WW 06-07-08
	// switching from teh notify to a single shot function call
	level thread maps\_achievements::ach_cam_d_watch(level.script, self._hackbox.script_int);
	/////////////////////////////////////////////////////////////////////////

	// mark camera for disable
	self.disabled = true;
	self camera_disable_tap();
	self showSecurityCameraOnMap( false );

	if ( self.state != "red" )
	{
		self set_camera_state( "view" );
	}
	else
	{
		self set_camera_state( "off" );
	}

	// Make box unuseable
	if ( IsDefined( self._hackbox ) )
	{
		self._hackbox SetUseable( false );
	}

	// notify to stop alert sound & stop sounds
	//iprintlnbold ("SOUND: disable camera Box");
	self notify( "sound_done" );
	//self StopLoopSound();

// stop rotation
// 	if( !self.destroyed )
// 	{
// 		self RotateTo( ( 45, self.angles[1], self.angles[2] ), 1.0 );
// 	}

	// play disable sound
	//iprintlnbold ("SOUND: camera toGreen beep");
	self PlaySound( "security_cam_disable" );
	
}

// disable tapped camera
camera_disable_tap()
{
	for( i = 0; i < 8; i++ )
	{
		if( !IsDefined( level._securitycamera_tap[i] ) )
		{
			continue;
		}
		if( self == level._securitycamera_tap[i] )
		{
			level._securitycamera_tap[i] = undefined;
			level.player EnableSecurityCameraOnPhone( false, (i + 1) );
		}
	}
}


///////////////////////////////////////////////////////////////////
// Camera Disabling
///////////////////////////////////////////////////////////////////

// Disable the camera - playerawareness callback
camera_hackbox_disable( strcObject )
{
	// get remote power box
	spark = undefined;
	eHackbox = strcObject.primaryEntity;

	// check to see if lid entity exists and remove it
	if( IsDefined( eHackbox._lid ) )
	{
		// send lid into physics
//		eHackbox._lid PhysicsLaunch( entLid.origin, vector_multiply( AnglesToForward(entLid.angles), 0.1 ) );
		eHackbox._lid RotateRoll( RandomFloatRange( -165.0, -145.0 ), 0.5 );
		eHackbox._lid PlaySound( "security_cam_disable_open" );
		//iprintlnbold ("SOUND: disable box lid");

		// Turn the switch down 
		if ( IsDefined( eHackbox._switch ) &&
			 ( eHackbox.camera.state != "red" && eHackbox.camera.state != "off" ) )
		{
			wait( 0.5 );
			eHackbox._switch RotatePitch( 60.0, 0.25 );
			
			spark = SpawnFx(level._securitycamera["spark"], eHackbox._switch.origin);
			TriggerFx(spark);
		}
	}

	// disable camera
	eHackbox.camera camera_disable();

	if ( IsDefined(spark) )
	{
		wait( 2.0 );
		spark Delete();
	}
}


///////////////////////////////////////////////////////////////////
// Camera Alert
///////////////////////////////////////////////////////////////////

camera_spawn_reinforcements()
{
	//-- Added 5/16/08 mjm
	// send notification to level for custom spawning behavior
	level notify( "start_camera_spawner" );
	//--

	// check for spawners
	if( !IsDefined( self.target ) )
	{
		return;
	}

	// send notification to camera that ai spawned
	self notify( "start_camera_spawner" );

	// get spawners
	entaSpawners = GetEntArray( self.target, "targetname" );

	// spawn guys
	for( i = 0; i < entaSpawners.size; i++ )
	{
		if (IsDefined(entaSpawners[i].script_forcespawn) && entaSpawners[i].script_forcespawn)
		{
			entaSpawners[i] StalingradSpawn( "ai_camera_guard_" + i );
		}
		else
		{
			entaSpawners[i] DoSpawn( "ai_camera_guard_" + i );
		}
	}

	// shut off camera if not destroyed
	if( self.destroyed == false )
	{
		self camera_disable();
	}
}


///////////////////////////////////////////////////////////////////
// Camera Audio
///////////////////////////////////////////////////////////////////

//
// camera audio
//
camera_audio()
{
	/* blink sound now called from vfx

	wait for damage or spot to stop
	self waittill_any( "damage", "spotted" );
	self StopLoopSound();
	
	self endon( "damage" );
	self endon( "hacked" );
	self endon( "disable" );
	
	
	while(1)
	{
			
		self playsound ("security_cam_beep");
		wait(.9);
	
	}
	*/
}


//
// play alert beep for a set time
//
camera_audio_alert()
{
	// setup endon thread
	self endon( "damage" );
	self endon( "hacked" );
	self endon( "disable" );
	
	self PlaySound( "Security_Cam_Siren" );
	
	/*

	time_limit = gettime()+(5*1000);

	while( gettime() < time_limit )
	{
		// alert sound lasts .38 seconds
		//self PlaySound( "Security_Cam_Alert", "sound_done" );
		//self waittill( "sound_done" );
		//iprintlnbold ("SOUND: camera alert");
		self stoploopsound();
		//self PlaySound( "Security_Cam_Siren" );
		//wait( 0.38 );
	}
	
	*/
}


///////////////////////////////////////////////////////////////////
// Camera Remote View
///////////////////////////////////////////////////////////////////
// Feed Box setup (similar to power box)
//	The camera feed will be disabled until the player uses the feed box to view the feeds.
//	- entFeed = the feed box entity
//	- entCameras = pass in the array of cameras you want to link to the box
camera_tap_start( entFeed, entCameras )
{
	// setup endon thread
	self endon( "damage" );
	self endon( "disable" );

	if( !IsDefined( entCameras ) )
	{
		assertmsg( "Invalid camera array passed to camera_tap_start function" );
	}

	// If no feedbox is entered, assume they're available
	if ( IsDefined( entFeed ) )
	{
		// setup usable camera remote feedbox object
		maps\_playerawareness::SetupEntSingleUseOnly(	entFeed, 
			::camera_tap_enable, 
			&"HINT_CAMERA_FEEDBOX", 
			1,
			undefined, 
			true, 
			true, 
			undefined, 
			level.awarenessMaterialNone, 
			false, 
			false, 
			false );
		entFeed waittill( "tapped" );
	}

	// disable previous feeds
	camera_tap_off();

	// enable ui video cameras
	for( i = 0; i < entCameras.size; i++ )
	{
		if( is_camera_valid( entCameras[i] ) )
		{
			level._securitycamera_tap[i] = entCameras[i];
			level.player EnableSecurityCameraOnPhone( true, (i + 1) );
		}
		else
		{
			level._securitycamera_tap[i] = undefined;
			level.player EnableSecurityCameraOnPhone( false, (i + 1) );
		}
	}
}


///////////////////////////////////////////////////////////////////
// disable camera taps
camera_tap_off()
{
	level.player EnableSecurityCameraOnPhone( false );

	if ( IsDefined(level._securitycamera_camid) )
	{
		level.player customCamera_pop( level._securitycamera_camid, 0.0, 0.0, 0.0 );
		level.player customcamera_checkcollisions( 1 );
		level._securitycamera_camid = undefined;
	}
	camera_clear_array();
}


///////////////////////////////////////////////////////////////////
// Enables the viewing of available camera feeds set through camera_tap_setup
camera_tap_enable( strcObject )
{
	entFeedBox = strcObject.primaryEntity;

	// check to see if lid entity exists and remove it
	if( IsDefined( entFeedBox.target ) )
	{
		entLid = GetEnt( entFeedBox.target, "targetname" );

		// send lid into physics
//		entLid PhysicsLaunch( entLid.origin, vector_multiply( AnglesToForward(entLid.angles), 0.1 ) );
		entLid RotateYaw( -135, 0.5 );
		entlid playsound ("security_cam_hack_open");
		//iprintlnbold("SOUND: open lid");
	}

	entFeedBox notify( "tapped" );
	wait(.1);
	forcephoneactive(true, "camera"); // pull up the phone on the camera screen
}


///////////////////////////////////////////////////////////////////
// clear camera tap array
camera_clear_array()
{
	for( i = 0; i < 8; i++ )
	{
		level._securitycamera_tap[i] = undefined;
	}
}


camera_tap_monitor_once()
{
	level.player endon( "close_camera" );

	// wait for notification
	level.player waittill( "show_camera", iCameraID );

	// switch to camera if valid
	if ( iCameraID >= 1 && iCameraID <= 8 )
	{
		if( is_camera_valid( level._securitycamera_tap[iCameraID-1] ) )
		{
			level._securitycamera_tap[iCameraID-1] thread camera_phone_track( false, undefined );
			level.player customcamera_checkcollisions( 0 );
		}
	}
}

//!
//	This gets activated when the phone's Security Cameras menu comes up.
//
camera_tap_monitor()
{
	while( true )
	{
		camera_tap_monitor_once();
	}
}

camera_close_monitor()
{
	while( true )
	{
		// wait for notification
		level.player waittill( "close_camera" );
		if ( IsDefined(level._securitycamera_camid) )
		{
			level.player customCamera_pop( level._securitycamera_camid, 0.0, 0.0, 0.0 );
			level.player customcamera_checkcollisions( 1 );
		}
	}
}

///////////////////////////////////////////////////////////////////
// This is the old way to enable the camera feeds.  You should use camera_tap_setup to setup your feeds.
// tap into up to 3 cameras to be viewed through ui
// camera_tap_on( entCamera )
// {
// 	if( !IsDefined( entCamera ) )
// 	{
// 		assertmsg( "Invalid camera array passed to camera_tap_on function" );
// 	}
// 
// 	// check to see if all cameras are valid
// 	iCounter = 0;
// 	for( i = 0; i < entCamera.size; i++  )
// 	{
// 		if( !is_camera_valid( entCamera[i] ) )
// 		{
// 			iCounter++;
// 		}
// 
// 		if( iCounter == entCamera.size )
// 		{
// 			return;
// 		}
// 	}
// 
// 	// enable global video camera
// 	level.player EnableVideoCamera( true );
// 
// 	// enable ui video cameras
// 	for( i = 0; i < 3; i++ )
// 	{
// 		if( is_camera_valid( entCamera[i] ) )
// 		{
// 			level._securitycamera_tap[i] = entCamera[i];
// 			level.player EnableSecurityCameraOnPhone( true, (i + 1) );
// 		}
// 		else
// 		{
// 			level._securitycamera_tap[i] = undefined;
// 			level.player EnableSecurityCameraOnPhone( false, (i + 1) );
// 		}
// 	}
// }


//!
// Display current camera
//	bVideoOn - do we want this to display to a secondary camera texture?  (like a monitor, but not the phone)
//
camera_phone_track( bVideoOn, unused )
{
	// endon conditions
//	self endon( "damage" );
//	self endon( "disable" );
//	self endon( "stop_tracking" );
	level.player endon( "close_camera" );
	level.player endon( "show_camera" );

	// set default for initial video on to false
	if( !IsDefined( bVideoOn ) )
	{
		bVideoOn = false;
	}

	// set default for enable phone to true
// 	if( !IsDefined( bEnablePhone ) )
// 	{
// 		bEnablePhone = true;
// 	}

	if ( bVideoOn )
	{
		// do some init stuff - only really need to do it once, but this is convenient to put here since it's a special case
	 	level.player setsecuritycameraparams( 55, 3/4 );		//fov, aspect ratio
	 	level.player setsecuritycamerapos( (10,10,10) );		//position
	 	level.player setsecuritycameralookatpos( (0,0,0) );		//lookat point (NOTE: position and lookat MUST be different or game will crash)
		level.player enablevideocamera( true );

		// start camera tracking
		while( true )
		{
			if( is_camera_valid( self ) )
			{
//				level.player setsecuritycameraparams( 55, 3/4 );
				if ( self.classname == "script_model" )
				{
 					level.player setsecuritycamerapos( self GetTagOrigin( "tag_camera" ) );
 					level.player setsecuritycameralookatpos( self GetTagOrigin( "tag_target" ) );
				}
				else
				{
 					level.player setsecuritycamerapos( self.origin );
 					// lookatpos is the origin direction plus 1 unit in the direction of the script_origin
 					level.player setsecuritycameralookatpos( self.origin+AnglesToForward(self.angles) );
				}
				wait( 0.07 );
			}
			else
			{
	 			level.player setsecuritycamerapos( (0,0,-10000) );		//position
	 			level.player setsecuritycameralookatpos( (0,0,-10001) );		//lookat point (NOTE: position and lookat MUST be different or game will crash)
//				level.player enablesecuritycameraonphone( false );
//				level.player enablevideocamera( false );
				return;
			}
		}
	}
	else
	{
		if ( IsDefined(level._securitycamera_camid) )
		{
			level.player customCamera_pop( level._securitycamera_camid, 0.0, 0.0, 0.0 );
		}

		if ( self.classname == "script_model" )
		{
			pos = self GetTagOrigin( "tag_camera" );
		}
		else
		{
			pos = self.origin;
		}
		level._securitycamera_camid = level.player customCamera_Push( "world", pos, self.angles, 0.0, 0.0, 0.0);

		// start camera tracking
		while( true )
		{
			if( is_camera_valid( self ) )
			{
//				level.player setsecuritycameraparams( 55, 3/4 );
				if ( self.classname == "script_model" )
				{
// 					level.player setsecuritycamerapos(  );
// 					level.player setsecuritycameralookatpos( self GetTagOrigin( "tag_target" ) );
					pos = self GetTagOrigin( "tag_camera" );
				}
				else
				{
					pos = self.origin;
// 					level.player setsecuritycamerapos( self.origin );
// 					// lookatpos is the origin direction plus 1 unit in the direction of the script_origin
// 					level.player setsecuritycameralookatpos( self.origin+AnglesToForward(self.angles) );
				}
				level.player customCamera_change(
					level._securitycamera_camid,		// <required ID returned from customCameraPush>
					"world",							// <required string, see camera types below>
					pos,								// <optional positional vector offset, default (0,0,0)>	
					self.angles,	    				// <optional angle vector offset, default (0,0,0)>
					(0.05),								// <optional time to 'tween/lerp' to the camera, default 0.5>
					(0.00),								// <optional time used to accel/'ease in', default 1/2 lerpTime> 
					(0.00)								// <optional time used to decel/'ease out', default (lerpTime - lerpAccelTime)>
				);
				wait( 0.05 );
			}
			else
			{
				return;
			}
		}
	}
}


// check for valid camera
is_camera_valid( entCamera )
{
	if( !IsDefined( entCamera ) )
	{
		return false;
	}

	if( entCamera.destroyed || entCamera.disabled )
	{
		return false;
	}

	return true;
}
