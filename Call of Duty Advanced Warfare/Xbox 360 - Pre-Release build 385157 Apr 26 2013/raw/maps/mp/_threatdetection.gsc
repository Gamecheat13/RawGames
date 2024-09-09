#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	level._threatdetection = SpawnStruct();
		
	SetDevDvarIfUninitialized( "threat_detection_mark_time", 3 );  //How long the threat is visible
	
	PrecacheMpAnim( "pb_crouch_ads" );
	PrecacheMPAnim( "pb_prone_aim" );
	PrecacheMpAnim( "pb_stand_ads" );
	
	PreCacheShader( "waypoint_threat_friendly" );
	PreCacheShader( "waypoint_threat_hostile" );
	
	// PreCache temp overlay for threat notification to player.
	PreCacheShader( "combathigh_overlay" );
	
	
	//What method we use to show threatDetection
	//options are:
	// glow 	-- glowy vfx blobs
	// model 	-- script model of the threat that is posed
	// vfx_model-- a vfx posed model 
	// attached_glow -- glowy vfx blobs that are attached to the players
	// stencil_outline -- red dot/line things in screen space stenciled to the player's shape
	level._threatdetection.default_style = "stencil_outline";
	SetDevDvarIfUninitialized( "threat_detection_highlight_style", level._threatdetection.default_style );  
	threatStyle = GetDvar( "threat_detection_highlight_style", level._threatdetection.default_style );
	
	//we set up all types now so we can switch at runtime
	
	//if( threatStyle == "glow" )
	{
		level._effect[ "skel_main" ]					= LoadFX( "fx/test/test_glow_drone_skel_pelvis" );
		level._effect[ "skel_elbow_le" ]				= LoadFX( "fx/test/test_glow_drone_skel_elbow_le" );
		level._effect[ "skel_elbow_ri" ]				= LoadFX( "fx/test/test_glow_drone_skel_elbow_ri" );
		level._effect[ "skel_head" ]					= LoadFX( "fx/test/test_glow_drone_skel_head" );
		level._effect[ "skel_leg_le" ]					= LoadFX( "fx/test/test_glow_drone_skel_leg_le" );
		level._effect[ "skel_leg_ri" ]					= LoadFX( "fx/test/test_glow_drone_skel_leg_ri" );
        
		level._effect[ "skel_main_sight" ]				= LoadFX( "fx/test/enmy_glow_skel_pelvis_zdep" );
		level._effect[ "skel_elbow_le_sight" ]			= LoadFX( "fx/test/enmy_glow_skel_elbow_le_zdep" );
		level._effect[ "skel_elbow_ri_sight" ]			= LoadFX( "fx/test/enmy_glow_skel_elbow_ri_zdep" );
		level._effect[ "skel_head_sight" ]				= LoadFX( "fx/test/enmy_glow_skel_head_zdep" );
		level._effect[ "skel_leg_le_sight" ]			= LoadFX( "fx/test/enmy_glow_skel_leg_le_zdep" );
		level._effect[ "skel_leg_ri_sight" ]			= LoadFX( "fx/test/enmy_glow_skel_leg_ri_zdep" );
        
		level._effect[ "skel_main_friendly" ]			= LoadFX( "fx/test/test_glow_drone_skel_pelvis_green" );
		level._effect[ "skel_elbow_le_friendly" ]		= LoadFX( "fx/test/test_glow_drone_skel_elbow_le_green" );
		level._effect[ "skel_elbow_ri_friendly" ]		= LoadFX( "fx/test/test_glow_drone_skel_elbow_ri_green" );
		level._effect[ "skel_head_friendly" ]			= LoadFX( "fx/test/test_glow_drone_skel_head_green" );
		level._effect[ "skel_leg_le_friendly" ]			= LoadFX( "fx/test/test_glow_drone_skel_leg_le_green" );
		level._effect[ "skel_leg_ri_friendly" ]			= LoadFX( "fx/test/test_glow_drone_skel_leg_ri_green" );
        
		level._effect[ "skel_main_friendly_sight" ]		= LoadFX( "fx/test/enmy_glow_skel_pelvis_zdep_green" );
		level._effect[ "skel_elbow_le_friendly_sight" ] = LoadFX( "fx/test/enmy_glow_skel_elbow_le_zdep_green" );
		level._effect[ "skel_elbow_ri_friendly_sight" ] = LoadFX( "fx/test/enmy_glow_skel_elbow_ri_zdep_green" );
		level._effect[ "skel_head_friendly_sight" ]		= LoadFX( "fx/test/enmy_glow_skel_head_zdep_green" );
		level._effect[ "skel_leg_le_friendly_sight" ]	= LoadFX( "fx/test/enmy_glow_skel_leg_le_zdep_green" );
		level._effect[ "skel_leg_ri_friendly_sight" ]	= LoadFX( "fx/test/enmy_glow_skel_leg_ri_zdep_green" );
		
		setUpThreatFXData();
	}	
	//else if( threatStyle == "vfx_model" )
	{
		level._effect[ "threat_detect_model_stand" ]	= LoadFX( "fx/test/test_mp_hud_char_stand" );
		level._effect[ "threat_detect_model_crouch" ]	= LoadFX( "fx/test/test_mp_hud_char_crouch" );
		level._effect[ "threat_detect_model_prone" ]	= LoadFX( "fx/test/test_mp_hud_char_prone" );
		
		level._effect[ "threat_detect_model_stand_hostile" ]	= LoadFX( "fx/test/test_mp_hud_char_stand_hostile" );
		level._effect[ "threat_detect_model_crouch_hostile" ]	= LoadFX( "fx/test/test_mp_hud_char_crouch_hostile" );
		level._effect[ "threat_detect_model_prone_hostile" ]	= LoadFX( "fx/test/test_mp_hud_char_prone_hostile" );		
	}
	//else if( threatStyle == "model" )
	{
		precacheModel( "mp_hud_stand_char" );
		precacheModel( "mp_hud_stand_char_hostile" );
		
		precacheModel( "mp_hud_crouch_char" );
		precacheModel( "mp_hud_crouch_char_hostile" );

		precacheModel( "mp_hud_prone_char" );
		precacheModel( "mp_hud_prone_char_hostile" );
		
		level._threatdetection.hostileModel = "mp_hud_stand_char_hostile";
		level._threatdetection.friendlyModel = "mp_hud_stand_char";	
	}

	level._threatdetection.activeStyle = threatStyle;
	
	minimapOrigins = getEntArray( "minimap_corner", "targetname" );
	if ( miniMapOrigins.size )
		level.map_center = maps\mp\gametypes\_spawnlogic::findBoxCenter( miniMapOrigins[0].origin, miniMapOrigins[1].origin );
	else	
		level.map_center = ( 0,0,0 );
	
	setMapWestOrigin();
	setMapWidth();
	
	level thread onPlayerConnect();
	//level thread monitorRadarUpdates( "allies" );
	//level thread monitorRadarUpdates( "axis" );
	//level thread highlightFriendlyStaticOrigin( "allies" );
	//level thread highlightFriendlyStaticOrigin( "axis" );
}

changeThreatStyle( threatStyle )
{
	if( threatStyle == level._threatdetection.activeStyle )
		return;
	
	//turn everything off
	foreach( p in level.players )
	{
		//model and vfx_model
		if( IsDefined( p._threatdetection.mark_enemy_model ) )
			p._threatdetection.mark_enemy_model Delete();
		
		if( IsDefined( p._threatdetection.mark_friendly_model ) )
			p._threatdetection.mark_friendly_model Delete();
		
		//vfx
		if( IsDefined( p.mark_fx ) && IsDefined( p.mark_fx.fx_ent ))
		{
			foreach( i, fx in p.mark_fx.fx_ent )
			{
				if( IsDefined( fx.enemyMarker ) )
					fx.enemyMarker Delete();
				
				if( IsDefined( fx.friendlyMarker ) )
					fx.friendlyMarker Delete();
				
				if( IsDefined( fx.enemyLosMarker ) )
					fx.enemyLosMarker Delete();
				
				if( IsDefined( fx.friendlyLosMarker ) )
					fx.friendlyLosMarker Delete();			
			}
		}
		
	}
	
	//turn on the new one
	foreach( p in level.players )
		p threat_init( threatStyle ); 
	
	level._threatdetection.activeStyle = threatStyle;
}

GetThreatStyle()
{
	threatStyle = GetDvar( "threat_detection_highlight_style", level._threatdetection.default_style );
	if( threatStyle != level._threatdetection.activeStyle )
		changeThreatStyle( threatStyle );
	return threatStyle;
}

/*monitorRadarUpdates( in_team )
{
	while( 1 ) 
	{
		value = 0;
		level waittill( "radar_status_change", team );
		
		value = GetTeamRadar( in_team );
		str = GetTeamRadarStrength( in_team );
		blocked = IsTeamRadarBlocked( in_team );
		
		level notify( "highlight_hostile_"+in_team );
		if( value )
		{
			thread highlightHostile( in_team );
		}
	}
}*/

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();
	}
}


//called from player connect
onPlayerSpawned()
{
	self endon("disconnect");
	
	self._threatdetection = SpawnStruct();
	self._threatdetection.showlist = [];	
	self waittill( "spawned_player" );

	//childthread highlightFriendly();
	childthread monitorThreatHighlight();
	childthread cleanUpOnDeath();
	//if( self != level.players[0] )
	//{
		//childthread debugHelper();
	//}
	
	// Monitors if/when threat overlay should be displayed.
	childthread monitorThreatHighlightNotification();
	
	//for respawns
	while( 1 )
	{
		self waittill( "spawned_player" );
		
		threatStyle = GetThreatStyle();
		if( threatStyle == "attached_glow" )
		    visitFXEnt( ::visitorRelink, ::getHostileMarker, undefined );
}
}


// Monitors if/when threat overlay should be displayed.
monitorThreatHighlightNotification()
{
	// Create a new hud element on client for the overlay.  Set initially to have an alpha of 0.0 so it's not visible.
	notification_overlay_element = NewClientHudElem( self );
	notification_overlay_element.x = 0;
	notification_overlay_element.y = 0;
	notification_overlay_element.alignX = "left";
	notification_overlay_element.alignY = "top";
	notification_overlay_element.horzAlign = "fullscreen";
	notification_overlay_element.vertAlign = "fullscreen";
	notification_overlay_element SetShader( "combathigh_overlay", 640, 480 );
	notification_overlay_element.alpha = 0.0;
	notification_overlay_element.sort = -3;
	
	// Make sure nothing is getting set unexpectedly elsewhere.
	Assert( !IsDefined(notification_overlay_element.hidden));
	
	notification_overlay_element.hidden = true;
	
	FadeInTime = .5;
	FadeOutTime = .3;
	
	while(1)
	{

		AssertEx(IsDefined(self._threatdetection), "_threatdetection isn't defined");
		
		// Check if the showlist isn't empty (value updated in monitorThreatHighlight())
		if(self._threatdetection.showlist.size != 0) 
		{
			// If hud element (overlay) is hidden, branch out a thread to fade the overlay in and out.
			if( notification_overlay_element.hidden )
			{
				notification_overlay_element.hidden = false;
				notification_overlay_element childthread threatNotificationOverlayFlash( FadeInTime, FadeOutTime );
			}
		}
		else // If showlist is empty...
		{
			// ...and the hud element is visible, tell the looping thread to stop fading the overlay in and out.
			if(!notification_overlay_element.hidden)
			{
				notification_overlay_element.hidden = true;
				notification_overlay_element notify( "stop_overlay_flash" );
			
				// If the overlay wasn't completely faded out, force it to fade out quickly.
				if(notification_overlay_element.alpha > 0.0)
				{
					notification_overlay_element FadeOverTime( FadeOutTime );
					notification_overlay_element.alpha = 0.0;
					wait( FadeOutTime );
				}
				
			}
		}
		
		wait(0.05);
	}
}

// Called on the overlay hud element in monitorThreatHighlightNotification() to cause it to fade in and out until notified to stop.
threatNotificationOverlayFlash( FadeInTime, FadeOutTime )
{
	self endon( "stop_overlay_flash" );
	
	while(1)
	{
		self FadeOverTime( FadeInTime );
		self.alpha = 1.0;
		wait( FadeInTime );
		self FadeOverTime( FadeOutTime );
		self.alpha = 0.0;
		wait( FadeOutTime );
	}
}

debugHelper()
{
	while( 1 )
	{
		dist = Distance( self.origin, level.players[0].origin );
		Print3d( self.origin + (0,0,64), dist );
		thread draw_line_for_time( level.players[0].origin, self.origin, 1,1,1, 0.3 );
		if( isdefined( self._threatdetection.mark_enemy_model ) )
			thread draw_line_for_time( level.players[0].origin, self._threatdetection.mark_enemy_model.origin, 1,1,1, 0.3 );	
		wait 0.3;
	}
}

setUpThreatFXData()
{
	fx_data = SpawnStruct();
	fx_data = [];
	
	// add fx here, tuple of tag, enemyMaker Fx, friendlyMarker FX
	fx_data[ fx_data.size ] = [ "j_mainroot"   , GetFX( "skel_main"		), GetFX( "skel_main_friendly"	   ), GetFX( "skel_main_sight"	   ), GetFX( "skel_main_friendly_sight"		) ];
	fx_data[ fx_data.size ] = [ "J_Spine4"	   , GetFX( "skel_main"		), GetFX( "skel_main_friendly"	   ), GetFX( "skel_main_sight"	   ), GetFX( "skel_main_friendly_sight"		) ];
	fx_data[ fx_data.size ] = [ "j_head"	   , GetFX( "skel_head"		), GetFX( "skel_head_friendly"	   ), GetFX( "skel_head_sight"	   ), GetFX( "skel_head_friendly_sight"		) ];
	fx_data[ fx_data.size ] = [ "j_elbow_le"   , GetFX( "skel_elbow_le" ), GetFX( "skel_elbow_le_friendly" ), GetFX( "skel_elbow_le_sight" ), GetFX( "skel_elbow_le_friendly_sight" ) ];
	fx_data[ fx_data.size ] = [ "j_elbow_ri"   , GetFX( "skel_elbow_ri" ), GetFX( "skel_elbow_ri_friendly" ), GetFX( "skel_elbow_ri_sight" ), GetFX( "skel_elbow_ri_friendly_sight" ) ];
	//fx_data[ fx_data.size ] = [ "j_shoulder_le", GetFX( "skel_elbow_le" ), GetFX( "skel_elbow_le_friendly" ), GetFX( "skel_elbow_le_sight" ), GetFX( "skel_elbow_le_friendly_sight" ) ];
	//fx_data[ fx_data.size ] = [ "j_shoulder_ri", GetFX( "skel_elbow_ri" ), GetFX( "skel_elbow_ri_friendly" ), GetFX( "skel_elbow_ri_sight" ), GetFX( "skel_elbow_ri_friendly_sight" ) ];
	//fx_data[ fx_data.size ] = [ "j_hip_le"	   , GetFX( "skel_leg_le"	), GetFX( "skel_leg_le_friendly"   ), GetFX( "skel_leg_le_sight"   ), GetFX( "skel_leg_le_friendly_sight"	) ];
	//fx_data[ fx_data.size ] = [ "j_hip_ri"	   , GetFX( "skel_leg_ri"	), GetFX( "skel_leg_ri_friendly"   ), GetFX( "skel_leg_ri_sight"   ), GetFX( "skel_leg_ri_friendly_sight"	) ];
	fx_data[ fx_data.size ] = [ "j_knee_le"	   , GetFX( "skel_leg_le"	), GetFX( "skel_leg_le_friendly"   ), GetFX( "skel_leg_le_sight"   ), GetFX( "skel_leg_le_friendly_sight"	) ];
	fx_data[ fx_data.size ] = [ "j_knee_ri"	   , GetFX( "skel_leg_ri"	), GetFX( "skel_leg_ri_friendly"   ), GetFX( "skel_leg_ri_sight"   ), GetFX( "skel_leg_ri_friendly_sight"	) ];
	
	level._threatdetection.fx_data = fx_data;
}

cleanUpOnDeath()
{
	self endon("disconnect");
	
	while( 1 )
	{
		self waittill("death");
		self removeThreatEvents();
	}
}

removeThreatEvents()
{
	foreach( obj in self._threatdetection.showlist )
	{
		obj.endTime = 0;
	}
	
	threatStyle = GetThreatStyle();
	if( threatStyle == "attached_glow" )
	{
		visitFXEnt( ::visitorHideAll, ::getHostileMarker, undefined );
	}
}

detection_highlight_hud_effect( player, duration )
{
	Assert( IsDefined( player ) );
	
	radar_highlight = NewClientHudElem( player );

	radar_highlight.color = (1, 0.05, 0.025);
	radar_highlight.alpha = 0.1;
	
	radar_highlight SetRadarHighlight( duration );
	wait duration;
	radar_highlight Destroy();
}

detection_grenade_hud_effect( player, position, duration, radius )
{
	Assert( IsDefined( player ) );
	
	radar_ping = NewClientHudElem( player );

	radar_ping.x = position[0];
	radar_ping.y = position[1];
	radar_ping.z = position[2];
			
	radar_ping.color = (1, 0.05, 0.025);
	radar_ping.alpha = 0.1; // mp uses 5 bits to store alpha
	
	width = 500;
	// doubling radius and duration so we have no chance of it cycling
	radar_ping SetRadarPing(int(radius + width / 2), int(width), duration + .05);
	// /# IPrintLn("PING"); #/
	wait duration;
	// /# IPrintLn("PONG"); #/
	radar_ping Destroy();
}

addThreatEvent( players_arr, event_duration_sec, event_type, updateHostile, updateFriendly )
{
	if( !IsAlive( self ) )
		return;
	
	currTime	= GetTime();
	endTime		= currTime + ( event_duration_sec * 1000 );
	losEndTime	= endTime - ( 9 * ( event_duration_sec * 1000 ) / 10 );
	
	threatStyle = GetThreatStyle();
	
	
	if( endTime - losEndTime < 250 )
		losEndTime = 250 + currTime;
	
	if( threatStyle == "model" )
	{
		losEndTime = currTime;
	}
	else if( threatStyle == "vfx_model" )
	{
		losEndTime = currTime;
	}
	else if( threatStyle == "attached_glow" )
	{
		losEndTime = endTime; //attached glow stays glowy
	}
	else if( threatStyle == "stencil_outline" )
	{
		losEndTime = endTime;
	}
	
	foreach( p in players_arr )
	{
		if( p == self )
			continue;
		
		found = false;
		foreach( obj in self._threatdetection.showlist )
		{
			if( obj.player == p )
			{
				//only update the time if it would last longer
				if( endTime > obj.endTime )
				{
					obj.endTime		= endTime;
					obj.losEndTime	= losEndTime;				
				}
				found = true;
				break;
			}
		}
		
		if( !found )
		{
			index = self._threatdetection.showlist.size;
			
			self._threatdetection.showlist[ index ]				= SpawnStruct();
			self._threatdetection.showlist[ index ].player		= p;
			self._threatdetection.showlist[ index ].endTime		= endTime;
			self._threatdetection.showlist[ index ].losEndTime	= losEndTime;
			
			self PlayLocalSound( "flag_spawned" );  // Play the flag_spawned oneshot any time someone is added to the showlist.
		}
	}
				
	if( updateFriendly ) 
		visitFXEnt( ::visitorUpdateMarkerPos, ::getFriendlyMarker, undefined );
	
	if( updateHostile )
		visitFXEnt( ::visitorUpdateMarkerPos, ::getHostileMarker, undefined );
}

visitFXEnt( visitorFn, accessorFn, show_to )
{
	assert( IsPlayer( self ) );

	threatStyle = GetThreatStyle();
	if( threatStyle == "glow" )
	{
		foreach( i, fx in self.mark_fx.fx_ent )
		{
			assert( IsDefined( [[accessorFn]]( fx ) ) );
			[[visitorFn]]( [[accessorFn]]( fx ), show_to, level._threatdetection.fx_data[i][0] );
		}	
	}
	else if( threatStyle == "model" )
	{
		assert( IsDefined( [[accessorFn]]( self._threatdetection ) ) );
		[[visitorFn]]( [[accessorFn]]( self._threatdetection ), show_to, "tag_origin" );
	}
	else if( threatStyle == "vfx_model" )
	{
		assert( IsDefined( [[accessorFn]]( self._threatdetection ) ) );
		[[visitorFn]]( [[accessorFn]]( self._threatdetection ), show_to, "tag_origin" );
	}
	else if( threatStyle == "attached_glow" )
	{
		foreach( i, fx in self.mark_fx.fx_ent )
		{
			assert( IsDefined( [[accessorFn]]( fx ) ) );
			[[visitorFn]]( [[accessorFn]]( fx ), show_to, level._threatdetection.fx_data[i][0] );
		}
	}
	else if( threatStyle == "stencil_outline" )
	{
		[[visitorFn]]( self, show_to, "tag_origin" );
	}
	else
	{
		AssertEx( 0, "unknown threat style " + threatStyle + ".  i dont know how to set it up" );
	}
}



visitorRelink( member, player, bone )
{
	member Unlink();
	member.origin = self GetTagOrigin( bone );
	member.angles = self GetTagAngles( bone );
	member LinkTo( self, bone );
	wait .05;
	playFXOnTag( member.fx, member, "tag_origin" );
}


visitorHideAll( member, player, bone )
{
	threatStyle = GetThreatStyle();
	if( threatStyle == "attached_glow" )
	{
		StopFXOnTag( member.fx, member, "tag_origin" );
	}
}

visitorUpdateMarkerPos( member, player, bone )
{	
	threatStyle = GetThreatStyle();
	member.origin = self GetTagOrigin( bone );
	member.angles = self GetTagAngles( bone );		
	if( threatStyle == "glow" )
	{	
		triggerFx( member );
	}
	else if( threatStyle == "model" )
	{
		//update model pose now
		desired_pose = "mp_hud_" + self GetStance() + "_char";
		assert( isdefined( member ) );
		is_hostile = ( member != self._threatDetection.mark_friendly_model );
		
		if( is_hostile )
		{
			desired_pose += "_hostile";
		}
		
		current_pose = member.model;
				
		if( desired_pose != current_pose )
			member SetModel( desired_pose );
	}
	else if( threatStyle == "vfx_model" )
	{
		switch( self GetStance() )
		{
			case "prone":
				desired_pose = "threat_detect_model_prone";
				break;
			case "crouch":
				desired_pose = "threat_detect_model_crouch";
				break;
			case "stand":					
				//fallthrough
			default:
				desired_pose = "threat_detect_model_stand";//self.stance;
				break;
		}
		
		assert( isdefined( member ) );
		is_hostile = ( member != self._threatDetection.mark_friendly_model );
		current_pose = self._threatdetection.friendly_pose;
		
		if( is_hostile )
		{
			desired_pose += "_hostile";
			current_pose = self._threatdetection.hostile_pose;
		}
		
		assert( IsDefined( current_pose ) );
		if( current_pose != desired_pose )
		{
			forward = AnglesToForward( self.angles );
			up = AnglesToUp( self.angles );
			if( is_hostile ) 
			{
				self._threatdetection.mark_enemy_model delete();
				self._threatdetection.mark_enemy_model = SpawnFx(  GetFX( desired_pose ), self.origin, forward, up );
				self._threatdetection.mark_enemy_model hide();
				self._threatdetection.hostile_pose = desired_pose; 
			}
			else		
			{
				self._threatdetection.mark_friendly_model delete();
				self._threatdetection.mark_friendly_model = SpawnFx(  GetFX( desired_pose ), self.origin, forward, up );
				self._threatdetection.mark_friendly_model hide();
				self._threatdetection.friendly_pose = desired_pose; 			
			}		
		}
		
		if( is_hostile ) 
			TriggerFX( self._threatdetection.mark_enemy_model );
		else
			TriggerFX( self._threatdetection.mark_friendly_model );
	}
	else if( threatStyle == "attached_glow" )
	{
		//do nothing on purpose
	}
	else if( threatStyle == "stencil_outline" )
	{
		//do nothing on purpose
	}
	else
	{
		AssertEx( 0, "unknown threat style " + threatStyle + ".  i dont know how to set it up" );
	}
}


getHostileMarker( obj )
{
	threatStyle = GetThreatStyle();
	if( threatStyle == "glow" )	
		return obj.enemyMarker;
	else if( threatStyle == "model" )
		return obj.mark_enemy_model;
	else if( threatStyle == "vfx_model" )
		return obj.mark_enemy_model;
	else if( threatStyle == "attached_glow" )
		return obj;
	else if( threatStyle == "stencil_outline" )
		return obj;
	else
	{
		AssertEx( 0, "unknown threat style " + threatStyle + ".  i dont know how to set it up" );
	}	
}

getFriendlyMarker( obj )
{
	threatStyle = GetThreatStyle();
	if( threatStyle == "glow" )
		return obj.friendlyMarker;
	else if( threatStyle == "model" )
		return obj.mark_friendly_model;
	else if( threatStyle == "vfx_model" )
		return obj.mark_friendly_model;	
	else
	{
		AssertEx( 0, "unknown threat style " + threatStyle + ".  i dont know how to set it up" );
	}			
}

getFriendlyLOSMarker( obj )
{
	threatStyle = GetThreatStyle();
	if( threatStyle == "glow" )
		return obj.friendlyLOSMarker;
	else if( threatStyle == "model" )
		return obj.mark_friendly_model;
	else if( threatStyle == "vfx_model" )
		return obj.mark_friendly_model;		
	else
	{
		AssertEx( 0, "unknown threat style " + threatStyle + ".  i dont know how to set it up" );
	}	
}

getHostileLOSMarker( obj )
{
	threatStyle = GetThreatStyle();
	if( threatStyle == "glow" )	
		return obj.enemyLOSMarker;
	else if( threatStyle == "model" )
		return obj.mark_enemy_model;		
	else if( threatStyle == "vfx_model" )
		return obj.mark_enemy_model;
	else if( threatStyle == "attached_glow" )
		return obj;	
	else if( threatStyle == "stencil_outline" )
		return obj;	
	else
	{
		AssertEx( 0, "unknown threat style " + threatStyle + ".  i dont know how to set it up" );
	}
}

//left for an exmple
visitHideAllMarkers( memberArr, player, bone )
{
	assert( !isdefined( player ) );
	foreach( m in memberArr )
	{
		m Hide();
	}
}
	
accessAllMarkers( obj )
{
	assert( isdefined( obj) );
	return [obj.friendlyMarker, obj.enemyMarker, obj.friendlyLOSMarker, obj.enemyLOSMarker];
}

getNormalDirectionVec( raw_vec )
{
	return VectorNormalize( flat_origin( raw_vec ) );
}

monitorThreatHighlight()
{
	self threat_init( GetThreatStyle() );
	
	height_offset = ( 0, 0, 32 );
	all_hidden = false;
	while( 1 )
	{
		wait .05;		
		currTime = GetTime();
		
		anyoneNeedsDraw = false;
		foreach( obj in self._threatdetection.showlist )
		{	
			if( obj.endTime >= currTime )
			{	
				if( !IsDefined( obj.player ) )
				{
					self._threatdetection.showlist = array_remove( self._threatdetection.showlist, obj );
					continue;
				}
				
				obj.los = false;
				
				//see if we're even in the view cone for the guy on the list
				forward = getNormalDirectionVec( anglesToForward( obj.player.angles ) );
				toTarget = getNormalDirectionVec( self.origin - obj.player.origin );
				cos = VectorDot( toTarget, forward );
				//we will cast against +/- 90
				if( cos < 0 )
					continue;
				
				if( check_los( obj ) )
				{
					//use LOS vfx
					obj.los = true;
					
					//if we're in LOS we have a different end time
					if( obj.losEndTime <= currTime )
					{
						self._threatdetection.showlist = array_remove( self._threatdetection.showlist, obj );
						continue;
					}
				}
				anyoneNeedsDraw = true;
			}
			else
			{
				self._threatdetection.showlist = array_remove( self._threatdetection.showlist, obj );
			}			
		}
		
		threatStyle = GetThreatStyle();
		if( !all_hidden )
		{
			all_hidden = true;
			if( threatStyle == "glow" )
			{
				foreach( i, fx in self.mark_fx.fx_ent )
				{
					fx.enemyMarker hide();
					fx.friendlyMarker hide();
					fx.enemyLosMarker hide();
					fx.friendlyLosMarker hide();
				}
			}
			else if( threatStyle == "model" )
			{
				self._threatdetection.mark_friendly_model hide();
				self._threatdetection.mark_enemy_model hide();
			}
			else if( threatStyle == "vfx_model" )
			{
				self._threatdetection.mark_friendly_model hide();
				self._threatdetection.mark_enemy_model hide();
			}
			else if( threatStyle == "attached_glow" )
			{
				foreach( i, obj in self.mark_fx.fx_ent )
				{
					StopFXOnTag( obj.fx, obj, "tag_origin" );
					obj hide();
				}				
			}
			else if( threatStyle == "stencil_outline" )
			{
				self clearThreatDetected();
			}
			else
			{
				AssertEx( 0, "unknown threat style " + threatStyle + ".  i dont know how to set it up" );
			}			
			
		}	
		if( !anyoneNeedsDraw )
			continue;
		
		//walk the list of players and show to who we want
		foreach( p in self._threatdetection.showlist )
		{
			assert( isdefined( p ) );
			if( p.los )
			{
				assert( p.losEndTime >= currTime );
				showThreat( p.player, ::getFriendlyLOSMarker, ::getHostileLOSMarker, ::visitorUpdateLOSMarker );
				prepare_show_threat( all_hidden, threatStyle, p.player );//playfxontag needs to be after the show of the ent
				all_hidden = false;
			}
			else
			{
				assert( p.endTime >= currTime );
				//if we cant see our target make sure we cant see the marker object
				result = BulletTrace( p.player.origin + height_offset, self.origin + height_offset, true, p.player );
				
				if( result["fraction"] < 1 && !isplayer(result["entity"]) ) // we can't see the blob
				{
					showThreat( p.player, ::getFriendlyMarker, ::getHostileMarker, ::visitorShowToPlayer );
					prepare_show_threat( all_hidden, threatStyle, p.player );//playfxontag needs to be after the show of the ent
					all_hidden = false;
				}
			}
		}
				
	}
}

prepare_show_threat( already_drawn, threatStyle, player )
{
	assert( IsPlayer( self ) );
	if( already_drawn ) //meaning we have not shown to anyone yet this frame
	{
		if( threatStyle == "attached_glow" )
		{
			showThreat( player, ::getFriendlyLOSMarker, ::getHostileLOSMarker, ::visitorRetriggerFX );
		}
	}				
}

visitorRetriggerFX( member, player, bone )
{
	/#
	threatStyle = GetThreatStyle();
	assert(threatStyle == "attached_glow" );
	#/
	//StopFXOnTag( member.fx, member, "tag_origin" );//stop is happening in the hide of monitorThreatHighlight
	PlayFXOnTag( member.fx, member, "tag_origin" );
}

check_los( obj )
{
	//temp to solve problem if player is behind partial cover.
	if( BulletTracePassed( obj.player GetEye(), self GetEye(), false, obj.player ) )
		return true;
	
	return false;
}

threat_init( threatStyle )
{
	mark_fx_struct = SpawnStruct();
	mark_fx_struct.fx_ent = [];

	if( threatStyle == "glow" )
	{
		foreach ( i,fx in level._threatdetection.fx_data )
		{
			mark_fx_ent = SpawnStruct();
			mark_fx_ent.origin = self GetTagOrigin( fx[0] );
			mark_fx_ent.angles = self GetTagAngles( fx[0] );
			
			mark_fx_ent.enemyMarker = SpawnFx( fx[1], mark_fx_ent.origin );
			triggerFx( mark_fx_ent.enemyMarker );
			mark_fx_ent.enemyMarker hide();
			
			mark_fx_ent.enemyLosMarker = SpawnFx( fx[3], mark_fx_ent.origin );
			triggerFx( mark_fx_ent.enemyLosMarker );
			mark_fx_ent.enemyLosMarker hide();
			
			mark_fx_ent.friendlyMarker = SpawnFx( fx[2], mark_fx_ent.origin );
			triggerFx( mark_fx_ent.friendlyMarker );
			mark_fx_ent.friendlyMarker hide();
			
			mark_fx_ent.friendlyLosMarker = SpawnFx( fx[4], mark_fx_ent.origin );
			triggerFx( mark_fx_ent.friendlyLosMarker );
			mark_fx_ent.friendlyLosMarker hide();
	
			mark_fx_struct.fx_ent[ i ] = mark_fx_ent;
		}
		
		self.mark_fx = mark_fx_struct;
	}
	else if( threatStyle == "model" )
	{
		model = spawn( "script_model", self.origin );
		model.origin = self.origin;
		model.angles = self.angles;
		//print( "we would like to use " + self.model );
		model setmodel( level._threatdetection.friendlyModel );
		model SetContents( 0 );
		//model codescripts\character::attachHead( "alias_africa_militia_heads_mp", xmodelalias\alias_africa_militia_heads_mp::main() );
		self._threatDetection.mark_friendly_model = model;
		
		model = spawn( "script_model", self.origin );
		model.origin = self.origin;
		model.angles = self.angles;
		//print( "we would like to use " + self.model );
		model setmodel( level._threatdetection.hostileModel );
		model SetContents( 0 );
		//model codescripts\character::attachHead( "alias_africa_militia_heads_mp", xmodelalias\alias_africa_militia_heads_mp::main() );
		self._threatDetection.mark_enemy_model = model;		
	}
	else if( threatStyle == "vfx_model")
	{	
		self._threatDetection.mark_friendly_model = SpawnStruct();
		self._threatDetection.mark_friendly_model = SpawnFx(  GetFX( "threat_detect_model_stand" ), self.origin, AnglesToForward( self.angles ), AnglesToUp( self.angles ) );
		self._threatDetection.friendly_pose = "threat_detect_model_stand";
		
		self._threatDetection.mark_enemy_model = SpawnStruct();
		self._threatDetection.mark_enemy_model = SpawnFx( GetFX( "threat_detect_model_stand_hostile" ), self.origin, AnglesToForward( self.angles ), AnglesToUp( self.angles ) );
		self._threatDetection.hostile_pose = "threat_detect_model_stand_hostile";
	}
	else if( threatStyle == "attached_glow" )
	{
	
		foreach ( i,fx in level._threatdetection.fx_data )
		{
			tag_org = spawn_tag_origin();
			tag_org show();  //spawn_tag_origin calls hide and if we dont show it, it will not be sent to any clients
			tag_org.origin = self GetTagOrigin( fx[0] );
			tag_org.angles = self GetTagAngles( fx[0] );
			tag_org LinkTo( self, fx[0] );
			tag_org.fx = fx[1];
			//wait .05;
			//PlayFXOnTag( tag_org.fx, tag_org, "tag_origin" );
			mark_fx_struct.fx_ent[ i ] = tag_org;
		}
		
		self.mark_fx = mark_fx_struct;
	}
	else if( threatStyle == "stencil_outline" )
	{
		// does nothing on purpose
	}
	else
	{
		AssertEx( 0, "unknown threat style " + threatStyle + ".  i dont know how to set it up" );
	}
}


visitorUpdateLOSMarker( member, player, bone )
{
	visitorUpdateMarkerPos( member, player, bone );
	visitorShowToPlayer( member, player, bone );
}

visitorShowToPlayer( member, player, bone )
{
	assert( IsDefined( player ) && isplayer( player ) );
	assert( IsDefined( member ) );
	
	threatStyle = GetThreatStyle();
	
	if (threatStyle == "stencil_outline")
	{
		member threatDetectedToPlayer( player );
	}
	else
	{
		member showToPlayer( player );	
	}
}

showThreat( player, friendlyFn, hostileFn, visitorFn )
{
	assert( player != self );
	assert( level.teamBased );
	
	memberFunc = hostileFn;
	if ( player.team == self.team )
		memberFunc = friendlyFn;
	
	visitFXEnt( visitorFn, memberFunc, player );
}

getSelfOrg( team )
{
	return self.origin;
}

getUavOrg( team )
{
	return ( 0, 0, 0 );
}

getSelfList( team )
{
	return [self];
}

/*highlightHostile( team )
{
	level endon( "highlight_hostile_" + team );
	
	team_to_highlight = getOtherTeam( team );
	/*
	check_radius_grow_rate = 375;
	check_radius_max = 9000;	
	
	show_time = 1;//.5
	pulse_cooldown = 1.25;
	* /
	
	update_time = GetDvarfloat( "compassRadarUpdateTime" );
	
	update_time_in_frames = update_time * 10;//20 server fps
	
	check_radius_grow_rate = level.map_width_dist / update_time_in_frames;
	check_radius_max = level.map_width_dist;	
	
	show_time = GetDvarfloat( "compassRadarPingFadeTime" );
	pulse_cooldown = show_time + .1;
	
	
	
	getShowList = ::getPlayersOnTeam;
	getPulseOrg = ::getWestOrigin;
	
	updateHostile = true;
	updateFriendly = true;	
	
	event_name = "hostile_pulse";
	
	//assertEx( IsDefined ( level.UAVModels[ team ].size ), "there are no UAV's to start the highlighting with" );
	childthread highlightInternal( team, team_to_highlight, show_time, pulse_cooldown, getPulseOrg, getShowList, event_name, updateFriendly, updateHostile, check_radius_max, check_radius_grow_rate);
}

highlightInternal( team, team_to_highlight, show_time, pulse_cooldown, getPulseOrg, getShowList, event_name, updateFriendly, updateHostile, check_radius_max, check_radius_rate)
{
	check_radius_start = 0;
	current_index = 0;
	check_radius = check_radius_start;
	
	assert( show_time < pulse_cooldown );
	pulse_org = [[getPulseOrg]]( team );
	players_on_team = getPulseList( pulse_org, team_to_highlight );

	while( 1 )
	{
		showlist = [[getShowList]]( team );
		
		foreach( idx, player in players_on_team )
		{
			if( idx < current_index )
				continue;
			
			distsq = DistanceSquared( pulse_org, player.origin );
			
			if( distsq < check_radius * check_radius )
			{
				if( updateHostile && IsAlive( player ) )
				{
					//level.players[0] PlayLocalSound( "uav_ping" );
					player PlayLocalSound( "uav_ping" );
				}
				// note:  if you uncomment this, you will need to get the HUD elements to display before this will work.
				player addThreatEvent( showlist, show_time, event_name, updateHostile, updateFriendly );
				current_index++;				
			}
			else
			{
				break;
			}
		}
		
		if( check_radius >= check_radius_max )
		{
			current_index = 0;			
			check_radius = check_radius_start;
			
			pulse_org = [[getPulseOrg]]( team );
			players_on_team = getPulseList( pulse_org, team_to_highlight );			
			wait pulse_cooldown;
		}
		else
		{
			check_radius += check_radius_rate;
		}
		wait .05;
	}	
}

highlightFriendly()
{
	team_to_highlight = self.team;
	//pings friendlies in an extending radius around the player
	check_radius_grow_rate = 250;
	check_radius_max = 6000;
	
	show_time = 1;
	pulse_cooldown = 1.5;
	
	getShowList = ::getSelfList;
	getPulseOrg = ::getSelfOrg;


	updateHostile = false;
	updateFriendly = true;
	
	event_name = "friendly_pulse";
	
	childthread highlightInternal( self.team, team_to_highlight, show_time, pulse_cooldown, getPulseOrg, getShowList, event_name, updateFriendly, updateHostile, check_radius_max, check_radius_grow_rate);
}

highlightFriendlyStaticOrigin( team )
{
	level endon( "highlight_friendly_" + team );
	
	team_to_highlight = team;
	/*
	check_radius_grow_rate = 375;
	check_radius_max = 9000;	
	
	show_time = 1;//.5
	pulse_cooldown = 1.25;
	* /
	update_time = GetDvarfloat( "compassRadarUpdateTime" );
	
	update_time_in_frames = update_time * 10;//20 server fps
	
	check_radius_grow_rate = level.map_width_dist / update_time_in_frames;
	check_radius_max = level.map_width_dist;	
	
	show_time = GetDvarfloat( "compassRadarPingFadeTime" );
	pulse_cooldown = show_time + .1;
	
	getShowList = ::getPlayersOnTeam;
	getPulseOrg = ::getWestOrigin;
	
	updateHostile = false;
	updateFriendly = true;	
	
	event_name = "friendly_pulse";
	
	childthread highlightInternal( team, team_to_highlight, show_time, pulse_cooldown, getPulseOrg, getShowList, event_name, updateFriendly, updateHostile, check_radius_max, check_radius_grow_rate);
}*/

getMapCenter( team )
{
	return level.map_center;
}

getWestOrigin( team )
{
	return level.map_west_origin;
}


setMapWestOrigin()
{
	
	minimapOrigins = getEntArray( "minimap_corner", "targetname" );
	if ( miniMapOrigins.size )
	{
		if( miniMapOrigins[0].origin[0] < miniMapOrigins[1].origin[0] )
		{
			west = miniMapOrigins[0].origin[0];
		}
		else
		{
			west = miniMapOrigins[1].origin[0];
		}
		level.map_west_origin =  ( west, 0, 0 );
	}
	else
	{
		level.map_west_origin =  ( 0, 0, 0 );
	}
}

setMapWidth()
{
	minimapOrigins = getEntArray( "minimap_corner", "targetname" );
	if ( miniMapOrigins.size )
	{
		level.map_width_dist = Distance2D( miniMapOrigins[0].origin, miniMapOrigins[1].origin );
	}
	else
	{
		level.map_width_dist = 9000;
	}
}


getPulseList( origin, team )
{
	players_on_team = getPlayersOnTeam( team );
	return SortByDistance( players_on_team, origin );
}

getPlayersOnTeam( team )
{
	teammates = [];
	foreach( player in level.players )
	{
		if( player.hasSpawned && isAlive( player ) && team == player.team && ( !IsPlayer( self ) || player != self ) )
		{
			teammates[ teammates.size ] = player;
		}
	}
	
	return teammates;
}



///killstreak threat detection

showInThreatDetection( team_override, obj_for_waittill, notify_to_remove_on )
{
	threat_icon_friendly = "waypoint_threat_friendly";
	threat_icon_hostile = "waypoint_threat_hostile";
	
	if( isdefined( team_override ) )
		team = team_override;
	else 
		team = self.team;
	
	enemy_team = maps\mp\gametypes\_gameobjects::getEnemyTeam( team );
	
	self createTeamThreatIcon( team, threat_icon_friendly );
	self createTeamThreatIcon( enemy_team, threat_icon_hostile );

	self thread removeThreatIcon( obj_for_waittill, notify_to_remove_on );

}

createTeamThreatIcon( team, shader )
{
	if( !isdefined( self.WayPoint ) )
		self.WayPoint = [];
	
	self.WayPoint[ team + "_icon" ] = newTeamHudElem( team );

	self.WayPoint[ team + "_icon" ] SetShader( shader, 1, 1 );

	self.WayPoint[ team + "_icon" ].alpha = .75;
	self.WayPoint[ team + "_icon" ].color = ( 1, 1, 1 );
	
	self.WayPoint[ team + "_icon" ].x = self.origin[0];
	self.WayPoint[ team + "_icon" ].y = self.origin[ 1 ];
	self.WayPoint[ team + "_icon" ].z = self.origin[ 2 ];	
	
	self.WayPoint[ team + "_icon" ] SetWayPoint( true, true, true );
	self.WayPoint[ team + "_icon" ] SetTargetEnt( self );
}

removeThreatIcon( obj_for_waittill, notify_to_remove_on )
{
	assert( ( IsDefined( obj_for_waittill ) && IsDefined( notify_to_remove_on ) ) 
	       || ( !IsDefined( obj_for_waittill ) && ! IsDefined( notify_to_remove_on ) ) );
	
	if( IsDefined( obj_for_waittill ) && isdefined( notify_to_remove_on ) )
		obj_for_waittill waittill( notify_to_remove_on );
	else if( !IsDefined( obj_for_waittill ) && !isdefined( notify_to_remove_on ) )
		self waittill( "death" );
	
	self.WayPoint[ "allies_icon" ] Destroy();
	self.WayPoint[ "axis_icon" ] Destroy();
}

///end killstreak threat detection stuff
