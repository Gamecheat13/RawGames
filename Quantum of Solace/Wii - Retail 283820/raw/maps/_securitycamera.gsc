






































































#include common_scripts\utility;
#include maps\_utility;







init(use_model)
{
	
	if (!IsDefined(use_model) || use_model)
	{
		PrecacheModel( "p_msc_security_cam_laser_head_d" );

		
		level._securitycamera["death"]				= Loadfx( "explosions/powerlines_b" );
		level._securitycamera["spark"]				= Loadfx( "misc/camera_sparks" );
		level._securitycamera["smoke"]				= Loadfx( "smoke/chimney_small" );
		level._securitycamera["laser"]				= Loadfx( "props/security_camera_on" );
		level._securitycamera["light_green"]		= Loadfx ("misc/camera_green");
		
		level._securitycamera["light_red"]			= Loadfx( "misc/camera_red");
		level._securitycamera["light_red_solid"]	= Loadfx( "misc/camera_red_solid" );
		level._securitycamera["spotlight"]			= Loadfx( "props/security_camera_on" );
	}

	
	level.player = GetEnt("player", "classname" );

	






	
	level._securitycamera_tap = [];
	camera_clear_array();

	
	level.player thread camera_tap_monitor();
}




camera_start( eHackbox, bTrack, UnusedbVideoOn, UnusedbEnablePhone )
{
	
	self.spotted = false;

	
	self.destroyed = false;

	
	self.disabled = false;

	
	self.angle_start = self.angles;

	
	self.can_use_override = true;

	
	self._secr_cam_target = level.player;

	
	if( !IsDefined( bTrack ) )
	{
		bTrack = true;
	}

	
	
	
	if( bTrack )
	{
		
		
		
		set_camera_state( "green" );

		
		self thread cone_trace( self );
		self thread camera_track_check( self );

		
		if( IsDefined( eHackbox ) )
		{
			
			eHackbox.camera = self;
			self._hackbox	= eHackbox;

			
			if ( IsDefined( eHackbox.target ) )
			{
				eHackbox._lid = GetEnt( eHackbox.target, "targetname" );

				
				if ( IsDefined( eHackbox._lid ) && IsDefined( eHackbox._lid.target ) )
				{
					eHackbox._switch = GetEnt( eHackbox._lid.target, "targetname" );
					if ( IsDefined( eHackbox._switch ) )
					{
						eHackbox._switch RotatePitch( -30.0, 0.05 );
					}
				}
			}

			
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

	
	if ( self.classname == "script_model" )
	{
		
		self thread camera_fov_fx( bTrack );

		
		self thread camera_damage( eHackbox );
	}

	
	self thread camera_rotate( self );
}







cone_trace( entCamera )
{
	
	entCamera endon( "damage" );
	entCamera endon( "disable" );

	
	fFOV = .9;
	
	
	
	

	
	vCamera_origin = entCamera.origin;

	
	iMax_dist = 512;
	
	if ( IsDefined( entCamera.script_radius ) )
	{
		iMax_dist = entCamera.script_radius;
	}


	while( true )
	{
		
		entaVis_ents = entsearch( level.CONTENTS_CORPSE + level.CONTENTS_PLAYER, vCamera_origin, iMax_dist );

		
		
		for( i = 0; i < entaVis_ents.size; i++ )
		{
			
			if( entaVis_ents[i] == level.player )
			{
				vTarget_origin = level.player GetEye();
			}
			else
			{
				vTarget_origin = entaVis_ents[i].origin;
			}

			
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

		
		vOffset = vTarget_origin - vCamera_origin;
		vNormal = vectorNormalize( vOffset );
		vCamera_forward = anglesToForward( entCamera.angles );

		fDot = vectorDot( vCamera_forward, vNormal );
		if ( fDot >= fFOV )	
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




camera_fov_fx( bTrack )
{
	
	

	
	if ( bTrack )
	{
		self.spotlight = Spawn( "script_model", self GetTagOrigin( "tag_flash" ) );
		self.spotlight SetModel( "tag_origin" );
		self.spotlight.angles = self.angles;

		
		
		
		
		self.spotlight LinkTo( self );
		PlayfxOnTag( level._securitycamera["spotlight"], self.spotlight, "tag_origin" );

		
		self waittill_any( "damage", "disable" );

		self.spotlight Delete();
	}
}









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
		
		break;
	case "red":
		set_camera_light( "off" );
		self notify( "spotted" );
		self thread camera_spawn_reinforcements();
		
		self PlaySound( "Security_Cam_Siren" );
		break;
	case "off":
		set_camera_light( "off" );
		self stoploopsound();
		
	default:
		set_camera_light( "off" );
		break;
	}
}




set_camera_light( state )
{
	
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



camera_rotate( entCamera )
{
	
	entCamera endon( "damage" );
	entCamera endon( "spotted" );


	
	fRotation_angle = 45;
	if ( IsDefined( entCamera.script_float ) )
	{
		fRotation_angle = entCamera.script_float/2;

		if ( fRotation_angle == 0.0 )
		{
			
			return;
		}
	}


	
	fRotation_time = 6;
	if ( IsDefined( entCamera.script_int ) )
	{
		fRotation_time = entCamera.script_int/2;
	}

	
	entCamera.angle_min = ( entCamera.angle_start[0], entCamera.angle_start[1] + fRotation_angle, entCamera.angle_start[2] );
	entCamera.angle_max = ( entCamera.angle_start[0], entCamera.angle_start[1] - fRotation_angle, entCamera.angle_start[2] );

	
	self thread camera_audio();

	
	while( !self.destroyed )
	{
		
		entCamera RotateTo( entCamera.angle_min, fRotation_time );
		
		
		
		entCamera waittill( "rotatedone" );
		
		entCamera stoploopsound();
		entCamera playsound ("security_cam_move_end");
		wait( 1.5 );	
		
		entCamera RotateTo( entCamera.angle_start, fRotation_time );
		
		entCamera playsound ("security_cam_move_start");
		entCamera playloopsound ("Security_Cam_Move", .2);
		entCamera waittill( "rotatedone" );
		entCamera RotateTo( entCamera.angle_max, fRotation_time );
		entCamera waittill( "rotatedone" );
		
		entCamera stoploopsound();
		entCamera playsound ("security_cam_move_end");
		wait( 1.5 );	
		
		entCamera RotateTo( entCamera.angle_start, fRotation_time );
		entCamera playsound ("security_cam_move_start");
		entCamera playloopsound ("Security_Cam_Move");
		entCamera waittill( "rotatedone" );
		
		
	}
}



camera_track_check( entCamera )
{
	
	entCamera endon( "damage" );
	entCamera endon( "disable" );

	
	while( true )
	{
		
		if( !entCamera.spotted )
		{
			wait( 0.15 );
			continue;
		}
		else
		{
			set_camera_state( "yellow" );
			self thread camera_track();
			wait( 2.0 );	

			if ( !entCamera.spotted )
			{
				
				set_camera_state( "green" );
				continue;
			}
			set_camera_state( "red" );
			wait( 1.0 );
			
			
			entCamera thread camera_disable();
			return;
		}
	}
}





camera_track()
{
	
	self endon( "damage" );
	self endon( "disable" );
	
	lost_LOS_time = 0;
	
	if( !IsDefined( self._secr_cam_target ) )
	{
		self.spotted = false;
		return;
	}

	
	while( self.state != "green" )
	{
		
		if( !IsDefined( self._secr_cam_target ) )
		{
			self.spotted = false;
			self notify( "sound_done" );
			return;
		}

		
		if ( !self.spotted )
		{
			if ( lost_LOS_time == 0 )
			{
				lost_LOS_time = GetTime() + 200;	
			}
			if ( GetTime() > lost_LOS_time )
			{
				
				while ( !self.spotted )
				{
					wait( 0.1 );
				}
				lost_LOS_time = 0;
			}
		}		

		
		if( self._secr_cam_target == level.player )
		{
			vTarget_origin = level.player GetEye();
		}
		else
		{
			vTarget_origin = self._secr_cam_target.origin;
		}

		angles = VectorToAngles( vTarget_origin - self.origin );
		
		if ( angles[0] > 35 )
		{
			angles = (35, angles[1], angles[2]);
		}
		else if ( angles[0] < -35 )
		{
			angles = (-35, angles[1], angles[2]);
		}

		
		
		
		
		
		
		
		
		
		

		self RotateTo( angles, 0.2 );
		wait( 0.2 );
	}

	
	self notify( "sound_done" );
}







camera_damage( eHackbox )
{
	
	self SetCanDamage( true );
	self.health = 100;


	self waittill( "damage" );
	self thread camera_drop();

	
	self.destroyed = true;
	self camera_disable_tap();
	self showSecurityCameraOnMap( false );

	
	self notify( "sound_done" );

	
	if( !self.disabled )
	{
		self RotateTo( ( 55, self.angles[1], self.angles[2] ), 0.55 );
		
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

	
	
	
	
	
	
	self SetModel( "p_msc_security_cam_laser_head_d" );
	

	
	Playfx( level._securitycamera["death"], self.origin );
	
	
	self PlaySound( "Security_Cam_Break" );

	
	self StopLoopSound();

	
	CreateDistraction( "Subtle", "", 0, 60, "", "", self.origin, 60, "" );
}


camera_drop()
{
	
	wait( 0.05 );

	spark = SpawnFx(level._securitycamera["spark"], self.origin);
	TriggerFx(spark);

	
	
	self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
	while ( self.health > 0 )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
	}

	
	spark Delete();
	Playfx( level._securitycamera["death"], self.origin );
	self set_camera_state( "off" );

	
	self PhysicsLaunch( point, vector_multiply( direction_vec, 1 ) );

	
	for( i = 0; i < 10; i++ )
	{
		self RadiusDamage( self.origin + (0, 0, -32), 64, 250, 200 );
		wait( 0.1 );
	}

	
	wait( 0.5 );
	CreateDistraction( "obvious", "", 0, 60, "", "", self.origin, 60, "" );
}


camera_disable()
{
	
	self notify( "disable" );

	
	
	
	
	
	
	
	level thread maps\_achievements::ach_cam_d_watch();
	

	
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

	
	
	self notify( "sound_done" );
	







	
	
	self PlaySound( "security_cam_disable" );
	
}


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







camera_hackbox_disable( strcObject )
{
	
	spark = undefined;
	eHackbox = strcObject.primaryEntity;

	
	if( IsDefined( eHackbox._lid ) )
	{
		

		eHackbox._lid RotateRoll( RandomFloatRange( -165.0, -145.0 ), 0.5 );
		eHackbox._lid PlaySound( "security_cam_disable_open" );
		

		
		if ( IsDefined( eHackbox._switch ) &&
			 ( eHackbox.camera.state != "red" && eHackbox.camera.state != "off" ) )
		{
			wait( 0.5 );
			eHackbox._switch RotatePitch( 60.0, 0.25 );
			
			spark = SpawnFx(level._securitycamera["spark"], eHackbox._switch.origin);
			TriggerFx(spark);
		}
	}

	
	eHackbox.camera camera_disable();

	if ( IsDefined(spark) )
	{
		wait( 2.0 );
		spark Delete();
	}
}






camera_spawn_reinforcements()
{
	
	
	level notify( "start_camera_spawner" );
	

	
	if( !IsDefined( self.target ) )
	{
		return;
	}

	
	self notify( "start_camera_spawner" );

	
	entaSpawners = GetEntArray( self.target, "targetname" );

	
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

	
	if( self.destroyed == false )
	{
		self camera_disable();
	}
}









camera_audio()
{
	
}





camera_audio_alert()
{
	
	self endon( "damage" );
	self endon( "hacked" );
	self endon( "disable" );
	
	self PlaySound( "Security_Cam_Siren" );
	
	
}









camera_tap_start( entFeed, entCameras )
{
	
	self endon( "damage" );
	self endon( "disable" );

	if( !IsDefined( entCameras ) )
	{
		assertmsg( "Invalid camera array passed to camera_tap_start function" );
	}

	
	if ( IsDefined( entFeed ) )
	{
		
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

	
	camera_tap_off();

	
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




camera_tap_enable( strcObject )
{
	entFeedBox = strcObject.primaryEntity;

	
	if( IsDefined( entFeedBox.target ) )
	{
		entLid = GetEnt( entFeedBox.target, "targetname" );

		

		entLid RotateYaw( -135, 0.5 );
		entlid playsound ("security_cam_hack_open");
		
	}

	entFeedBox notify( "tapped" );
}




camera_clear_array()
{
	for( i = 0; i < 8; i++ )
	{
		level._securitycamera_tap[i] = undefined;
	}
}





camera_tap_monitor()
{
	while( true )
	{
		
		level.player waittill( "show_camera", iCameraID );

		
		if ( iCameraID >= 1 && iCameraID <= 8 )
		{
			if( is_camera_valid( level._securitycamera_tap[iCameraID-1] ) )
			{
				level._securitycamera_tap[iCameraID-1] thread camera_phone_track( false, undefined );
				level.player customcamera_checkcollisions( 0 );
			}
		}
		else
		{
 			if ( IsDefined(level._securitycamera_camid) )
			{
				level.player customCamera_pop( level._securitycamera_camid, 0.0, 0.0, 0.0 );
				level.player customcamera_checkcollisions( 1 );
			}
		}
	}
}



















































camera_phone_track( bVideoOn, unused )
{
	



	level.player endon( "show_camera" );

	
	if( !IsDefined( bVideoOn ) )
	{
		bVideoOn = false;
	}

	





	if ( bVideoOn )
	{
		
	 	level.player setsecuritycameraparams( 55, 3/4 );		
	 	level.player setsecuritycamerapos( (10,10,10) );		
	 	level.player setsecuritycameralookatpos( (0,0,0) );		
		level.player enablevideocamera( true );

		
		while( true )
		{
			if( is_camera_valid( self ) )
			{

				if ( self.classname == "script_model" )
				{
 					level.player setsecuritycamerapos( self GetTagOrigin( "tag_camera" ) );
 					level.player setsecuritycameralookatpos( self GetTagOrigin( "tag_target" ) );
				}
				else
				{
 					level.player setsecuritycamerapos( self.origin );
 					
 					level.player setsecuritycameralookatpos( self.origin+AnglesToForward(self.angles) );
				}
				wait( 0.07 );
			}
			else
			{
	 			level.player setsecuritycamerapos( (0,0,-10000) );		
	 			level.player setsecuritycameralookatpos( (0,0,-10001) );		


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

		
		while( true )
		{
			if( is_camera_valid( self ) )
			{

				if ( self.classname == "script_model" )
				{


					pos = self GetTagOrigin( "tag_camera" );
				}
				else
				{
					pos = self.origin;



				}
				level.player customCamera_change(
					level._securitycamera_camid,		
					"world",							
					pos,								
					self.angles,	    				
					(0.05),								
					(0.00),								
					(0.00)								
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
