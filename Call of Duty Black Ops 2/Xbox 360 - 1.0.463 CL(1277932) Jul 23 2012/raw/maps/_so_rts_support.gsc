#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_scene;
#include maps\_music;

#insert raw\maps\_utility.gsh;
#insert raw\animscripts\utility.gsh;
#insert raw\maps\_so_rts.gsh;


find_ground_pos( v_current, v_trace_end )
{
	v_ground = v_current; // default 
	if (!isDefined(v_trace_end) )
	{
		v_down = ( 0, 0, -20000 );
		v_trace_end = v_current + v_down;
	}
	a_trace = BulletTrace( v_current, v_trace_end, false, level.player );
	v_hit = a_trace[ "position" ];
	n_distance = Distance( v_current, v_hit );
	n_threshold = 5000;
	
	if ( n_distance < n_threshold )
	{
		v_ground = v_hit;
	}	
	
	return v_ground;
}

// ==========================================================================
do_switch_transition(targetEnt)
{ //these hardcoded waits must match the .CSC implementation of the satelitte transition
	assert(isDefined(level.rts.static_trans_time));
	level.rts.switch_trans = 1;
	self SetClientFlag( FLAG_CLIENT_FLAG_ALLY_SWITCH );
	wait 0.1;
	// actual slamming 
	if (isDefined(targetEnt) && isDefined(level.rts.playerLinkObj) )
	{
		level.rts.playerLinkObj MoveTo( targetEnt.origin + ( 0, 0, 0 ), 0.4, 0 );
	}
	start	= GetTime();
	cur 	= start;
	last 	= cur; 
	end		= start + level.rts.static_trans_time;
	half	= start + level.rts.static_trans_time_half;
	near	= start + level.rts.static_trans_time_nearhalf;
	/#
	println("^^^^^^^^^^^^^^ do_switch_transition start ->" + start);
	#/
	while(cur<end)
	{
		if ( last < near && cur >= near )
		{
			/#
			println("^^^^^^^^^^^^^^ notify switch_nearfullstatic at " + GetTime());
			#/
			level notify("switch_nearfullstatic");
			self notify("switch_nearfullstatic");
		}
		if ( last < half && cur >= half )
		{
			/#
			println("^^^^^^^^^^^^^^ notify switch_fullstatic at " + GetTime());
			#/
			level notify("switch_fullstatic");
			self notify("switch_fullstatic");
		}
		last = cur; 
		cur  = GetTime();
		wait 0.05;
	}
	level notify("switch_complete");
	self notify("switch_complete");	

	self ClearClientFlag(FLAG_CLIENT_FLAG_ALLY_SWITCH);
	/#
	println("^^^^^^^^^^^^^^ do_switch_transition end ->" + GetTime() + " Total Time: " + int(GetTime()-start));
	#/
	level.rts.switch_trans = undefined;
}

hide_player_hud()
{
	level notify("hide_hint"); //take down any hints that might currently be up
	SetSavedDvar( "hud_showStance", "0" );
	SetSavedDvar("hud_showObjectives","0");
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "cg_drawCrosshair", 0 );
	
	foreach(player in GetPlayers())
	{
		player clearDamageIndicator();
		player SetClientDvars("cg_drawfriendlynames", 0);
		player SetClientUIVisibilityFlag( "hud_visible", 0 );
	}
}

show_player_hud()
{
	SetSavedDvar( "hud_showStance", "1" );
	SetSavedDvar("hud_showObjectives","1");
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "cg_drawCrosshair", 1 );
	
	foreach(player in GetPlayers())
	{
		player SetClientDvars("cg_drawfriendlynames", 1);
		player SetClientUIVisibilityFlag( "hud_visible", 1 );
	}
}

MP_ents_cleanup()
{
	entitytypes = getentarray();
	for ( i = 0; i < entitytypes.size; i++ )
	{
		if ( isdefined( entitytypes[ i ].script_gameobjectname ) )
		{
			if ( !isdefined( entitytypes[ i ].targetname ) || entitytypes[ i ].targetname != "so_dont_delete" )
				entitytypes[ i ] delete();
		}
		
		if ( isdefined( entitytypes[ i ].targetname ) && entitytypes[ i ].targetname == "so_delete" )
			entitytypes[ i ] delete();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
playerLinkObj_zoom(amount,time)
{
	if (isdefined(level.rts.fov_lerp))
		return;
	
	if (!isdefined(time) || time <= 0 )
		time = 0.05;
		
	if ( amount < 0 )
	{
		if (level.rts.fov == MIN_FOV )
			return;
			
		if ( level.rts.fov == DEFAULT_FOV )
			level.rts.fov = MIN_FOV;
		if ( level.rts.fov == MAX_FOV )
			level.rts.fov = DEFAULT_FOV;
	}
		
	if ( amount > 0 )
	{
		if (level.rts.fov == MAX_FOV )
			return;
			
		if ( level.rts.fov == DEFAULT_FOV )
			level.rts.fov = MAX_FOV;
		if ( level.rts.fov == MIN_FOV )
			level.rts.fov = DEFAULT_FOV;
	}

	if ( amount == 0 )
		level.rts.fov = DEFAULT_FOV;

	level.rts.fov_lerp = 1;
	level.rts.player  SetClientFlag( FLAG_CLIENT_FLAG_REMOTE_MISSILE);
	Rpc("clientscripts/_so_rts","lerp_fov_overtime",time,level.rts.fov);
	wait time;
	level.rts.player ClearClientFlag( FLAG_CLIENT_FLAG_REMOTE_MISSILE );
	level.rts.fov_lerp = undefined;
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
playerLinkObj_orient(x,y)
{
	x 		= angleclamp180(level.rts.playerLinkObj.angles[0]+x);
	y 		= angleclamp180(level.rts.playerLinkObj.angles[1]+y);
	z 		= angleclamp180(level.rts.playerLinkObj.angles[2]);
	if ( x > MAX_VIEW_ANGLE )
		x = MAX_VIEW_ANGLE;
	if ( x < MIN_VIEW_ANGLE )
		x = MIN_VIEW_ANGLE;
		
	level.rts.playerLinkObj.angles = (x,y,z);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
playerLinkObj_rotate(amount)
{
	angles 		= (0,amount,0);
	ground		= playerLinkObj_getTargetGroundPos();
	diff		= level.rts.playerLinkObj.origin - ground;							//delta between where we are and where our target is
	diff		= RotatePoint(diff,angles);											//rotate delta by angle
	newPoint    = ground + diff;		//add rotated diff back to ground to find newposition
	level.rts.playerLinkObj.origin	= (newPoint[0],newPoint[1],level.rts.playerLinkObj.origin[2]);	//set position
	level.rts.playerLinkObj.angles += (0,amount,0);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
playerLinkObj_getTargetGroundPos(force)
{
	if (isDefined(force) || !isDefined(level.rts.ground) )
	{
		forward 					= AnglesToForward(level.rts.playerLinkObj.angles);
		projected					= (forward * 10000) + level.rts.playerLinkObj.origin;
		level.rts.ground 			= find_ground_pos( level.rts.playerLinkObj.origin, projected );
	}
	
/#	
//	thread maps\_so_rts_support::debug_sphere( ground, 8, (0,1,0), 0.6, 3 );
//	thread maps\_so_rts_support::debugLine(level.rts.playerLinkObj.origin,ground, (0,1,0),1);
#/	
	return level.rts.ground;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
playerLinkObj_getForwardVector(scale)
{
	if(!isDefined(scale))
		scale = 5000;
	return AnglesToForward(level.rts.playerLinkObj.angles)*scale;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
playerLinkObj_defaultPos()
{
	maps\_so_rts_support::playerLinkObj_zoom(0,0);

	if(!isDefined(level.rts.lastFPSpoint) )
	{
		level.rts.lastFPSpoint = level.rts.player_startpos;
	}
	
	height = ((level.rts.maxPlayerZ-level.rts.minPlayerZ)*0.5);
	
	level.rts.playerLinkObj.origin = (level.rts.lastFPSpoint[0],level.rts.lastFPSpoint[1],level.rts.minPlayerZ + height);
	playerLinkObj_viewClamp();

	level.rts.playerLinkObj.angles = (level.rts.game_rules.default_camera_pitch,0,0) + level.rts.game_rules.camera_angle_offsets;

	groundPos = playerLinkObj_getTargetGroundPos(true);
	diff = level.rts.lastFPSpoint-groundPos;
		

	origin = level.rts.lastFPSpoint+diff;
	level.rts.playerLinkObj.origin = (origin[0],origin[1],level.rts.minPlayerZ+height);
	playerLinkObj_viewClamp();
}

playerLinkObj_viewClamp(onlyZ)
{
	obj = level.rts.playerLinkObj;
	/#	//dev only
		if ( level.rts.player isinmovemode( "ufo", "noclip" )  && !isDefined(level.rts.player_relink) )
		{
			level.rts.player ClearClientFlag( FLAG_CLIENT_FLAG_RETICLE );
			level.rts.player Unlink();
			level.rts.player_relink = true;
			return;
		}
		
		if ( isDefined(level.rts.player_relink) && isDefined(level.rts.playerLinkObj) )
		{
			// link player
			level.rts.player SetClientFlag( FLAG_CLIENT_FLAG_RETICLE );
			level.rts.player PlayerLinkTo( level.rts.playerLinkObj, undefined, 1, 0, 0, 0, 0 );
			level.rts.player_relink = undefined;
		}
	#/
	

	if ( obj.origin[2] < level.rts.minPlayerZ )
		obj.origin = (obj.origin[0],obj.origin[1],level.rts.minPlayerZ);
		
	if ( obj.origin[2] > level.rts.maxPlayerZ )
		obj.origin = (obj.origin[0],obj.origin[1],level.rts.maxPlayerZ);

	if(!isDefined(onlyZ) && level.rts.game_rules.camera_mode == CAMERA_MODE_ORBIT )
	{
		frac =  (obj.origin[2]-level.rts.minPlayerZ) / (level.rts.maxPlayerZ-level.rts.minPlayerZ);
		level.rts.viewAngle = MIN_VIEW_ANGLE + ( (MAX_VIEW_ANGLE - MIN_VIEW_ANGLE) * frac );
		obj.angles = (level.rts.viewAngle,obj.angles[1],0);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
#define PLAYER_ORDINAL_INC		(64)
playerLinkObj_moveObj(x,y)
{
	if ( !isDefined(level.rts.playerLinkObj_moveIncForward) )
	{
		angle = (0,level.rts.playerLinkObj.angles[1],level.rts.playerLinkObj.angles[2]);
		level.rts.playerLinkObj_moveIncForward = AnglesToForward( angle) * PLAYER_ORDINAL_INC;
		level.rts.playerLinkObj_moveIncRight = AnglesToRight( angle) * PLAYER_ORDINAL_INC;
	}
	forward = VectorScale(level.rts.playerLinkObj_moveIncForward,x);
	right   = VectorScale(level.rts.playerLinkObj_moveIncRight,y);
	level.rts.playerLinkObj.origin += forward + right;
	clampEntToMapBoundary(level.rts.playerLinkObj);
	
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
rotate_point_around_point( v_point_to_rotate, v_point_to_rotate_around, delta_angles )
{
/*	// get a direction vector between the point to rotate and the point to rotate around
	v_delta = v_point_to_rotate – v_point_to_rotate_around;
	
	// find out how far away is it
	n_dist = Length( v_delta );

	// det the normalized direction
	v_dir = VectorNormalize( v_delta );
	
	// convert to angles 
	current_angles = VectorToAngles( v_dir );
	
	// change the angles by whatever you want
	current_angles += delta_angles;
	
	// make a new direction from updated angles
	v_new_dir = AnglesToForward( current_angles );
	
	// move from point to rotate around to new rotated point
	v_rotated_point = v_point_to_rotate_around + v_new_dir * n_dist;
	
	return v_rotated_point;
*/	
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	


#define CAMERA_START_LOC (3025,3756,25750)
#define CAMERA_START_ANG (0, -112, 0)
ally_missile_watcher(ally)
{
	if(!isDefined(ally))
		return;
		
	self waittill("remote_missile_start");
	if(!isDefined(ally))
		return;

	if (IS_VEHICLE(ally) )
	{
		ally veh_magic_bullet_shield(true);
		ally UseBy( self );
		ally MakeVehicleUnusable();
		ally maps\_vehicle::stop();
	}
	else
	{
		ally.takedamage = false;
	}
	
	
	self waittill("remotemissile_done" );
	if(!isDefined(ally))
		return;
	
	if(!flag("rts_game_over"))
	{
		if (IS_VEHICLE(ally) )
		{
			ally maps\_vehicle::stop();
			ally veh_magic_bullet_shield(false);
			ally MakeVehicleUsable();
			ally UseVehicle( self, 0 );
			ally MakeVehicleUnusable();
		}
		else
		{
			ally.takedamage = true;
		}
	}
}

missile_out_of_bounds_watcher()
{
	level endon("fire_missile_done");
	
	while(1)
	{
		inBounds = true;
		rocket = level.rts.player.missile_sp;
		if (isDefined(rocket) && isDefined(level.rts.bounds) )
		{
			x		 = rocket.origin[0];
			y		 = rocket.origin[1];
			z		 = rocket.origin[2];
			
			if ( x <= level.rts.bounds.ulX )
				inBounds = false;
			else
			if ( x >= level.rts.bounds.lrX )
				inBounds = false;
	
			if ( y <= level.rts.bounds.ulY )
				inBounds = false;
			else
			if ( y >= level.rts.bounds.lrY )
				inBounds = false;
			
			if ( z <= level.rts.bounds.minZ )
				inBounds = false;
		}
		
		if ( !inBounds )
		{	
			maps\_so_rts_event::trigger_event("air_strike_aborted");
			if ( isdefined( rocket.owner ) )
			{
				rocket.owner Unlink();
			}
			rocket Delete();
			return;
		}
		wait 0.5;
	}
}

fire_missile()
{
	SetDvar("ui_specops","0");
	SetDvar("ui_hideminimap","1");
	toggle_damage_indicators(false);

	flag_set("block_input");
	player_vehicle = undefined;
	if ( !flag("rts_mode") )
	{
		if (isDefined(level.rts.player.ally) && isDefined(level.rts.player.ally.vehicle) )
		{
			player_vehicle = level.rts.player.ally.vehicle;
			player_vehicle veh_magic_bullet_shield(true);
		}
		level.rts.player EnableInvulnerability();
		level.rts.player.ignoreme = true;
	}
	
	level notify("fire_missile");
	level.rts.player ClearClientFlag( FLAG_CLIENT_FLAG_RETICLE );
	level.rts.player  SetClientFlag( FLAG_CLIENT_FLAG_REMOTE_MISSILE );

	if(!isDefined(level.remotemissile_override_origin))
		level.remotemissile_override_origin = CAMERA_START_LOC;
	if (!isDefined(level.remotemissile_override_angles))
		level.remotemissile_override_angles = CAMERA_START_ANG;
		
	level.rts.remotemissile = true;
	
	if ( flag("rts_mode") )
	{
		level.remotemissile_override_target = playerLinkObj_getTargetGroundPos();
	}
	else
	{
		if (isDefined(level.rts.enemy_base ) && isDefineD(isDefined(level.rts.enemy_base.entity) ))
			level.remotemissile_override_target = level.rts.enemy_base.entity.origin + (RandomInt(900),RandomInt(900),0);
		else
		if (isDefined(level.rts.enemy_center ))
			level.remotemissile_override_target = level.rts.enemy_center.origin;
		else
			level.remotemissile_override_target = level.rts.player.origin;
	}

	oldfov = GetDvarFloat("cg_missile_FOV");
	SetDvar("cg_missile_FOV",45);	
	SetDvar("throwback_enabled",0);
	SetDvar("grenade_indicators_enabled",0);

	level.rts.player  maps\sp_killstreaks\_killstreaks::useKillstreak( "remote_missile_sp");
	level.rts.player waittill("remote_missile_start");
	LUINotifyEvent( &"rts_predator_hud", 1, 1 );
	
	if ( !flag("rts_mode") )
	{
		if (isDefined(level.rts.player.ally) && isDefined(level.rts.player.ally.vehicle) )
		{
			player_vehicle = level.rts.player.ally.vehicle;
			player_vehicle maps\_vehicle::stop();
			level.rts.player thread maps\_so_rts_ai::restoreReplacement();
			level.rts.player waittill_notify_or_timeout( "exit_vehicle",0.1 );
			if ( isDefined(player_vehicle) )
			{
				player_vehicle veh_magic_bullet_shield(true);
				player_vehicle.ignoreme = true;
			}
		}
		level.rts.player EnableInvulnerability();
		level.rts.player.ignoreme = true;
	}

	maps\_so_rts_event::trigger_event("air_strike_start");
	level.rts.player thread take_and_giveback_weapons("remotemissile_done");
	level.rts.player thread missile_out_of_bounds_watcher();

	//Stop the music and set the command center Futz MOVE after Press CDC
	maps\_so_rts_event::trigger_event("mus_missile_fire");
	
	targetIcon = undefined;
	if (isDefined(level.rts.enemy_base ) && isDefined(isDefined(level.rts.enemy_base.entity) ))
	{	
		level.rts.enemy_base.entity.takedamage = 1;
		
		// show the reticle
		targetIcon = Spawn( "script_model", level.rts.enemy_base.entity.origin );
		targetIcon.angles = level.rts.enemy_base.entity.angles;
		targetIcon SetModel( "tag_origin" );
		targetIcon LinkTo( level.rts.enemy_base.entity );
		PlayFXOnTag( level._effect[ "missile_reticle" ], targetIcon, "tag_origin" );
	}

	level.rts.player  waittill( "remotemissile_done" );
	level.rts.remotemissile = undefined;
	level notify("fire_missile_done");
	SetDvar("cg_missile_FOV",oldfov);	
	SetDvar("throwback_enabled",1);
	SetDvar("grenade_indicators_enabled",1);
	LUINotifyEvent( &"rts_predator_hud", 1, 0 );
	
	if (isDefined(targetIcon))
	{
		targetIcon Delete();
	}
	
	level.rts.player  ClearClientFlag( FLAG_CLIENT_FLAG_REMOTE_MISSILE);
	wait 0.05;
	if ( !flag("rts_game_over") )
	{
		toggle_damage_indicators(true);
		maps\_so_rts_event::trigger_event("air_strike_failed");

		SetDvar("ui_hideminimap","0");
		flag_clear("block_input");
		
		if (!flag("fps_mode_only") )
		{
			SetDvar("ui_specops","1");
		}
		if ( flag("rts_mode") )
		{
			level.rts.player SetClientFlag( FLAG_CLIENT_FLAG_RETICLE);
			maps\_so_rts_main::rts_menu();
		}
		else
		{
			maps\_so_rts_main::fps_menu();
		}
		if ( !flag("rts_mode") )
		{
			if (isDefined(player_vehicle) )
			{
				level.rts.player maps\_so_rts_ai::takeOverSelectedVehicle(player_vehicle);
				player_vehicle veh_magic_bullet_shield(false);
				player_vehicle.ignoreme = false;
			}
			else
			{
				level.rts.player.ignoreme = false;
				level.rts.player DisableInvulnerability();
			}
		}
		
		if (isDefined(level.rts.enemy_base ) && isDefineD(isDefined(level.rts.enemy_base.entity) ))
		{	
			level.rts.enemy_base.entity.takedamage = 0;
		}
	}
}





/#
debugLine(fromPoint, toPoint, color, durationFrames)
{
	for (i=0;i<durationFrames*20;i++)
	{
		line (fromPoint, toPoint, color);
		wait (0.05);
	}
}


drawcylinder( pos, rad, height )
{

	currad = rad; 
	curheight = height; 

	for( r = 0; r < 20; r++ )
	{
		theta = r / 20 * 360; 
		theta2 = ( r + 1 ) / 20 * 360; 

		line( pos +( cos( theta ) * currad, sin( theta ) * currad, 0 ), pos +( cos( theta2 ) * currad, sin( theta2 ) * currad, 0 ) ); 
		line( pos +( cos( theta ) * currad, sin( theta ) * currad, curheight ), pos +( cos( theta2 ) * currad, sin( theta2 ) * currad, curheight ) ); 
		line( pos +( cos( theta ) * currad, sin( theta ) * currad, 0 ), pos +( cos( theta ) * currad, sin( theta ) * currad, curheight ) ); 
	}

}

debug_circle( origin, radius, color=(1,1,1), time=1000 )
{
	circle( origin, radius, color, true, true, time );
}

debug_sphere( origin, radius, color=(1,1,1), alpha=0.7, time=1000 )
{
	sides = Int(10 * ( 1 + Int(radius) % 100 ));
	sphere( origin, radius, color, alpha, true, sides, time );
}

debug_draw_goalpos(center,color)
{
	self endon("death");
	self notify("draw_goalpos");
	self endon("draw_goalpos");
	while(1)
	{
	
		if (isDefined(self.special_node) )
		{
			debug_sphere( self.special_node.origin, 32, (.7,0,1), 0.5, 1 );
			line (self.origin, self.special_node.origin, (0,0,1));
			drawnode(self.special_node);
			if(!isDefined(center))
				center = self.goalpos;
			line (self.origin, center, color);	
			debug_sphere( center, 32, color, 0.5, 1 );
		}
		else
		{
			if(!isDefined(center))
				center = self.goalpos;
				
			line (self.origin, center, color);	
			if(isDefined(self.node))
			{
				line (self.origin, self.node.origin, (0,0,1));
				drawnode(self.node);
			}
			
			debug_sphere( center, 32, color, 0.5, 1 );
		}
		wait 0.05;
	}
	
}
#/



/@
"Name: place_weapon_on( <weapon>, <location> )"
"Summary: Equip a wepaon on an AI."
"Module: AI"
"CallOn: An AI"
"MandatoryArg: <weapon> : The name of the weapon to equip"
"MandatoryArg: <> : Slot to store the weapon in. 'right', 'left', 'chest', or 'back'."
"Example: level.price place_weapon_on( "at4", "back" );"
"SPMP: singleplayer"
@/
place_weapon_on( weapon, location )
{
	Assert( IsAI( self ) );

	if( !animscripts\utility::AIHasWeapon( weapon ) )
		animscripts\init::initWeapon( weapon );

	animscripts\shared::placeWeaponOn( weapon, location );
}

/@
"Name: forceUseWeapon( <newWeapon>, <targetSlot> )"
"Summary: Forces the AI to switch to a specified weapon."
"Module: AI"
"CallOn: An AI"
"MandatoryArg: <newWeapon> : The name of the weapon to use/give"
"MandatoryArg: <target slot> : Slot to store the weapon in. primary, secondary or sidearm."
"Example: level.price forceUseWeapon( "glock", "sidearm" );"
"SPMP: singleplayer"
@/
forceUseWeapon( newWeapon, targetSlot )
{
	Assert( IsDefined( newWeapon ) );
	Assert( newWeapon != "none" );
	Assert( IsDefined( targetSlot ) );
	Assert( ( targetSlot == "primary" ) || ( targetSlot == "secondary" ) || ( targetSlot == "sidearm" ), "Target slot is either primary, secondary or sidearm." );

	// Setup the weaponInfo if it wasn't already done
	if ( !animscripts\init::isWeaponInitialized( newWeapon ) )
		animscripts\init::initWeapon( newWeapon );

	// Figure out whether the current and target weapons are side arms, and which slot to go to
	hasWeapon = ( self.weapon != "none" );
	isCurrentSideArm = AI_USINGSIDEARM(self);
	isNewSideArm = ( targetSlot == "sidearm" );
	isNewSecondary = ( targetSlot == "secondary" );

	// If we have a weapon and we're not replacing it with one of the same "type", we need to hoslter it first
	if ( hasWeapon && ( isCurrentSideArm != isNewSideArm ) )
	{
		Assert( self.weapon != newWeapon );

		// Based on the current weapon - Hide side arms completely, and holster based on the new target otherwise
		if ( isCurrentSideArm )
			holsterTarget = "none";
		else if ( isNewSecondary )
			holsterTarget = "back";
		else
			holsterTarget = "chest";

		animscripts\shared::placeWeaponOn( self.weapon, holsterTarget );

		// Remember we switched out of that weapon
		if( !isCurrentSideArm )
			self.lastWeapon = self.weapon;
	}
	else
	{
		// We didn't have a weapon before, or we're going to loose the one we had, so reset the lastWeapon.
		self.lastWeapon = newWeapon;
	}

	// Put the new weapon in hand
	animscripts\shared::placeWeaponOn( newWeapon, "right" );

	// Replace the equipped weapon slot of the same type with the new weapon ( could stay the same, too )
	// If the AI was using a secondary, replace that slot instead of primary
	if ( isNewSideArm )
	{
		self.sideArm = newWeapon;
	}
	else if ( isNewSecondary )
	{
		self setSecondaryWeapon(newWeapon);
	}
	else
	{
		self setPrimaryWeapon(newWeapon);
	}

	// Set our current weapon to the new one
	self setCurrentWeapon(newWeapon);
	self.bulletsinclip = WeaponClipSize( self.weapon );
	self notify( "weapon_switch_done" );
}


get_weapon_name_from_alt( weapon )
{
	if ( WeaponInventoryType( weapon ) != "altmode" )
	{
		assertmsg( "Get weapon name from alt called on non alt weapon." );
		return weapon;
	}

	weapon_name_parts = StrTok( weapon, "_" );
	weapon_primary = "";

	for ( i = 1; i < weapon_name_parts.size; i++ )
	{
		weapon_primary += weapon_name_parts[ i ];

		if ( i != weapon_name_parts.size - 1 )
			weapon_primary += "_";
	}

	return weapon_primary;
}


registerKeyBinding(binding,callback,param,flag)
{
	keyAction 			= spawnstruct();
	keyAction.binding 	= binding;
	keyAction.callback 	= callback;
	keyAction.param 	= param;
	keyAction.gateFlag 	= flag;
	if (!isDefined(level.rts.keyActions))
		level.rts.keyActions = [];
		
	level.rts.keyActions[binding] = keyAction;
}



#define BUTTON_STATE_DOWNLONG	(4)
#define BUTTON_STATE_ACTIVATED	(3)
#define BUTTON_STATE_PRESSED	(2)
#define BUTTON_STATE_DOWN		(1)
#define BUTTON_STATE_UP			(0)
#define LONG_TIME				(500)
getButtonPress()
{	
	retval = "NO_INPUT";
	
	if(!isDefined(level.rts.buttons))
	{
		level.rts.buttons	= spawnstruct();
		
		tags		= [];
		bits		= [];
		times		= [];
		tags[tags.size] = "BUTTON_BACK";
		tags[tags.size] = "DPAD_UP";
		tags[tags.size] = "DPAD_DOWN";
		tags[tags.size] = "DPAD_LEFT";
		tags[tags.size] = "DPAD_RIGHT";
		tags[tags.size] = "BUTTON_X";
		tags[tags.size] = "BUTTON_Y";
		tags[tags.size] = "BUTTON_B";
		tags[tags.size] = "BUTTON_A";
		tags[tags.size] = "BUTTON_RSHLDR";
		tags[tags.size] = "BUTTON_LSHLDR";
		tags[tags.size] = "BUTTON_LSTICK";
		tags[tags.size] = "BUTTON_RSTICK";
		tags[tags.size] = "BUTTON_LTRIG";
		tags[tags.size] = "BUTTON_RTRIG";
		for(i=0;i<tags.size;i++)
		{
			bits[bits.size] = BUTTON_STATE_UP;
			times[times.size] = GetTime();
		}
		level.rts.buttons.tags 	= tags;
		level.rts.buttons.bits 	= bits;
		level.rts.buttons.times = times;
	}

	tag = undefined;
	aux = undefined;
	for (i=0;i<level.rts.buttons.tags.size;i++)
	{
		if ( level.rts.buttons.bits[i] == BUTTON_STATE_ACTIVATED )
		{
			tag = level.rts.buttons.tags[i];
			level.rts.buttons.bits[i] = BUTTON_STATE_UP; 
			break;
		}
	
		if( level.rts.player ButtonPressed(level.rts.buttons.tags[i]) && level.rts.buttons.bits[i] == BUTTON_STATE_UP )
		{
			level.rts.buttons.bits[i]  = BUTTON_STATE_DOWN;
			level.rts.buttons.times[i] = GetTime();
		}
	}

	levelTime = GetTime();
	for (i=0;i<level.rts.buttons.tags.size;i++)
	{
		if ( level.rts.buttons.bits[i] == BUTTON_STATE_DOWN )
		{
			if (!(level.rts.player ButtonPressed(level.rts.buttons.tags[i])))
			{
				level.rts.buttons.bits[i] = BUTTON_STATE_ACTIVATED; 
				continue;
			}
			
			if ( leveltime - level.rts.buttons.times[i] > LONG_TIME  )
			{
				level.rts.buttons.bits[i]  =  BUTTON_STATE_DOWNLONG;
				tag = level.rts.buttons.tags[i]+"_LONG";
				break;
			}
		}
		if ( level.rts.buttons.bits[i] == BUTTON_STATE_DOWNLONG && !(level.rts.player ButtonPressed(level.rts.buttons.tags[i])) )
		{
			level.rts.buttons.bits[i]  =  BUTTON_STATE_UP;
		}
	}

	
	if (isDefined(tag) && isDefined(level.rts.keyActions) && isDefined(level.rts.keyActions[tag]))
	{
		action = level.rts.keyActions[tag];
	
		if (isDefined(action))
		{
			if(isDefined(action.gateFlag) )
			{
				if ( flag(action.gateFlag) )
					[[action.callback]](action.param);
			}
			else
			{
				[[action.callback]](action.param);
			}
		}
	}

	if (isDefined(tag))
	{
		retval = tag;
	}
	
	return retval;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
get_ents_touching_trigger( total_ents )
{
	touching = [];
	
	if( !IsDefined( total_ents ) )
		total_ents = ArrayCombine(GetPlayers(),getaiarray(), true, false);
	
	foreach (ent in total_ents)
	{
		if ( ent isTouching(self) )
			touching[touching.size] = ent;
	}
	return touching;
}

placeVehicle(ref, origin, team)
{
	assert(isDefined(ref));
	assert(isDefined(origin));
	if(!isDefined(team))
		team = "allies";
		
	
	spawner = get_vehicle_spawner( ref );
	assert( isdefined( spawner ), "Invalid vehicle spawner targetname: " + ref );
			
	spawner.origin = origin;

	vehicle = maps\_vehicle::spawn_vehicle_from_targetname( ref );
	assert( isdefined( vehicle ), "vehicle failed to spawn." );
	
	vehicle.team = team;
	vehicle.vteam = team;
	vehicle SetTeam(team);
	vehicle.hasBeenPlanted = true;
	/#
	RecordEnt( vehicle );
	#/
	vehicle AddVehicleToCompass( "tank" );
	
	vehicle maps\_vehicle::stop();


//	offset = level.talon_headicon_offset[ "default" ];
//	talon maps\sp_killstreaks\_entityheadicons::setEntityHeadIcon( talon.team, self, offset, undefined, false, 1 ); //passing in player, player is used to create the client hud elm
	

	return vehicle;
}

callbackOnNotify(note, cb, param1,param2)
{
	assert(isDefined(cb));
	
	if (note != "death" )
    {
		self endon("death");
		self waittill(note);
	}
	else
	{
		self waittill("death");
	}
	
	if( IsDefined( param1 ) && IsDefined( param2 ))
		self [[cb]]( param1, param2 );
	else
	if( IsDefined( param1 ) )
		self [[cb]]( param1 );
	else
		self [[cb]]();		
}

notifyLevelOnDelete(note)
{
	self waittill_any("death","delete");
	level notify(note);
}

deleteMeOnNotify(note)
{
	self endon("death");
	self waittill(note);
	self Delete();
}

setFlagInNSec(flag,seconds)
{
	wait seconds;
	flag_set(flag);
}
notifyMeInNSec(note,seconds,p1,p2,p3,p4,p5)
{
	self endon("death");
	wait seconds;
	if(isDefined(p1) && isDefined(p2) && isDefined(p3) && isDefined(p4) && isDefined(p5) )
		self notify(note,p1,p2,p3,p4,p5);
	else
	if(isDefined(p1) && isDefined(p2) && isDefined(p3) && isDefined(p4)) 
		self notify(note,p1,p2,p3,p4);
	else
	if(isDefined(p1) && isDefined(p2) && isDefined(p3)) 
		self notify(note,p1,p2,p3);
	else
	if(isDefined(p1) && isDefined(p2)) 
		self notify(note,p1,p2);
	else
	if(isDefined(p1)) 
		self notify(note,p1);
	else
		self notify(note);
}
getNearAI(fromOrigin,distSQ,team)
{
	if (!isDefined(team) )
	{
		ai = GetAIArray();
	}
	else
	{
		ai = GetAIArray(team);
	}
	
	aiNear = [];
	
	foreach(dude in ai)
	{
		if(distancesquared(dude.origin,fromOrigin)<distSQ)
			aiNear[aiNear.size] = dude;
	}
	
	return aiNear;
}
getFarAI(fromOrigin,distSQ,team)
{
	if (!isDefined(team) )
	{
		ai = GetAIArray();
	}
	else
	{
		ai = GetAIArray(team);
	}
	
	aiFar = [];
	
	foreach(dude in ai)
	{
		if(distancesquared(dude.origin,fromOrigin)>distSQ)
			aiFar[aiFar.size] = dude;
	}
	
	return aiFar;
}


/////////////////////////////////////////////////////////////////////////////////////////////////
// Vehicle support functions
/////////////////////////////////////////////////////////////////////////////////////////////////
chopper_wait_for_closest_open_path_start( target_origin, start_name, struct_string_field )
{
	path_start = undefined;
	while ( 1 )
	{
		path_start = chopper_closest_open_path_start( target_origin, start_name, struct_string_field );
		if ( isdefined( path_start ) )
			break;
			
		wait 0.25;
	}
	
	return path_start;
}

// returns the start struct of the helicopter path containing the
// closest struct with the specified struct_string_field that is
// not currently in use
chopper_closest_open_path_start( target_origin, start_name, struct_string_field )
{
	path_starts = GetVehicleNodeArray( start_name, "targetname" );
	assert( path_starts.size, "No heli path nodes with targetname: " + start_name );
	
	closest_path_start = undefined;
	closest_path_start_dist = undefined;
	closest_path_drop = undefined;
	
	foreach ( path_start in path_starts )
	{
		if ( isdefined( path_start.in_use ) )
			continue;
		
		path_drop = path_start;
		found_path = false;
		
		switch ( struct_string_field )
		{
			case "script_unload":
			{
				while ( !isdefined( path_drop.script_unload ) )
					path_drop = GetVehicleNode( path_drop.target, "targetname" );
					
				assert( isdefined( path_drop.script_unload ), "Level has a helicopter path without a struct with script_unload defined." );
				if ( !isdefined( path_drop.script_unload ) )
					continue;
				
				found_path = true;
					
				break;
			}
				
			case "script_stopnode":
			{
				while ( !isdefined( path_drop.script_stopnode ) )
					path_drop = GetVehicleNode( path_drop.target, "targetname" );
					
				assert( isdefined( path_drop.script_stopnode ), "Level has a helicopter path without a struct with script_stopnode defined." );
				if ( !isdefined( path_drop.script_stopnode ) )
					continue;
				
				found_path = true;
					
				break;
			}
				
			// look for script_noteworthy match
			default:
			{
				while ( isdefined( path_drop.target ) && ( !isdefined( path_drop.script_noteworthy ) || path_drop.script_noteworthy != struct_string_field ) )
					path_drop = GetVehicleNode( path_drop.target, "targetname" );
					
				// reject this path if it's the last node
				if ( !isdefined( path_drop.target ) )
					continue;
				
				found_path = true;
					
				// accept path
				break;
			}
		}
		
		assert( found_path, "No heli path found with a kvp matching: " + struct_string_field );
		
		if ( !isdefined( closest_path_drop ) )
		{
			closest_path_drop = path_drop;
			closest_path_start_dist = distance2d( target_origin, path_drop.origin );
			closest_path_start = path_start;
		}
		else
		{
			path_drop_dist = distance2d( target_origin, path_drop.origin );
			if ( path_drop_dist < closest_path_start_dist )
			{
				closest_path_drop = path_drop;
				closest_path_start_dist = distance2d( target_origin, closest_path_drop.origin );
				closest_path_start = path_start;
			}
		}	
	}
	
	if (isDefineD(closest_path_start))
	{
		// save the end point as well
		closest_path_start.path_drop = closest_path_drop;
	}
	
	return closest_path_start;	
}

// This is all wrapped up in one function so that as soon as a chopper is
// needed the desired path is flagged as in use.
chopper_spawn_from_targetname_and_drive( name, spawn_origin, path_start, team )
{
	msg = "passed start struct without targetname: " + name;
	assert( !isdefined( path_start.in_use ), "helicopter told to use path that is in use." );
	
	// Must happen first since chopper_spawn() functions could 
	// potentially wait for the spawner to be free
	path_start.in_use = true;
	
	chopper = chopper_spawn_from_targetname( name, spawn_origin, team );
	chopper.path_start = path_start;
	
	//chopper thread vehicle_paths( path_start );
	chopper thread go_path( path_start );

	return chopper;
}

chopper_spawn_from_targetname( name, spawn_origin, team )
{
	chopper_spawner = get_vehicle_spawner( name );
	assert( isdefined( chopper_spawner ), "Invalid chopper spawner targetname: " + name );
	
	// set health if defined in string table
	/*
	set_health = maps\_so_war_ai::get_ai_health( name );
	if ( isdefined( set_health ) )
		chopper_spawner.script_startinghealth = set_health;
	*/
	
	while ( isdefined( chopper_spawner.vehicle_spawned_thisframe ) )
		wait 0.05;
		
	chopper_spawner.vehicle_spawned_thisframe = true;
	
	if ( isdefined( spawn_origin ) )
		chopper_spawner.origin = spawn_origin;

	chopper = maps\_vehicle::spawn_vehicle_from_targetname( name );
	assert( isdefined( chopper ), "chopper failed to spawn." );
	
	chopper SetTeam( team );
	chopper GodOn();
	
	if( team == "axis" )
		Target_Set( chopper );
	
	wait( 0.05 );
	
	chopper_spawner.vehicle_spawned_thisframe = undefined;	
		
	return chopper;
}

chopper_drop_smoke_at_unloading()
{
	self endon( "death" );

	self waittill_either( "unloading", "unload" );

	rappel_left_origin = self GetTagOrigin("tag_fastrope_le");
	if( !IsDefined( rappel_left_origin ) )
	{
		rappel_left_origin = self GetTagOrigin("tag_enter_gunner");
		assert( IsDefined(rappel_left_origin), "Heli has no rappel tags" );
	}
	
	groundposition = GROUNDPOS(self, rappel_left_origin );
	self magicgrenadetype( "willy_pete_sp", groundposition, ( 0, 0, -1 ), 0 );
}


get_transport_startLoc(dropTarget)
{
	path_start = chopper_wait_for_closest_open_path_start( dropTarget, "drop_path_start", "script_unload" );	
	return path_start;
}


chopper_send( dropTarget, team, type, customUnload )
{
	assert( IsDefined( team ) );
	assert( IsDefined( type ) );
	assert( type == "helo" || type == "vtol", "Chopper type " + type + " not supported" );
	
	path_start = chopper_wait_for_closest_open_path_start( dropTarget, "drop_path_start", "script_unload" );	
	chopper = chopper_spawn_from_targetname_and_drive( team + "_drop_" + type, path_start.origin, path_start, team );
	chopper.script_vehicle_selfremove = true;
	if ( type == "helo" )
		chopper.speed = HELI_MPH;
	if ( type == "vtol" )
		chopper.speed = VTOL_MPH;
	chopper Vehicle_SetSpeed( chopper.speed, 30, "start helo path" );
	
	// save on the AI count
	chopper.vehicle_passengersOnly = true;
	
	level notify( "chopper_inbound", chopper );
	
	return chopper;
}

chopper_unload_rope_cargo( cargo, pkg_ref, team, squadID )
{
	self endon( "death" );
	
	if( IsAI( cargo ) || cargo IsVehicle() )
	{
		ai_ref = level.rts.ai[ pkg_ref.units[0] ];
		cargo.ai_ref = ai_ref;
		cargo maps\_so_rts_squad::addAIToSquad(squadID);
	}
	
	self waittill( "unload" );
	
	self.cargo = undefined;
	
	cargo Unlink();
	
	moverEnt = Spawn( "script_origin", cargo.origin );
	cargo LinkTo( moverEnt );
	
	// lower to the ground
	traceResults = BulletTrace( cargo.origin, cargo.origin - (0, 0, 2000), false, cargo );
	assert( traceResults[ "fraction" ] != 0, "Ground trace didn't hit anything" );
	groundPos = traceResults[ "position" ];// + (0,0,((cargo.maxs[2]-cargo.mins[2])+12));
	moveTime = 3.0;
	moverEnt MoveTo( groundPos, moveTime, 0.25, 0.25 );
	
	wait( moveTime );
	cargo Unlink();
	
	// init the AI	
	if( IsAI( cargo ) || cargo IsVehicle() )
	{
		if (cargo IsVehicle() )
		{
			cargo maps\_vehicle::defend( cargo.origin, 600 );
		}
	}
	else
	{		
		// spawn explosion (temp fx for now)
		for( i=0; i < 10; i++ )
			PlayFX( level._effect[ "cargo_box_open" ], groundPos + ( RandomInt(20), RandomInt(20), RandomInt(30) ) );		
		wait( 0.1 );		
		cargo Delete();		
		wait( 0.25 );
		
		// spawn the container units		
		x = 0;
		y = 0;
		foreach(unit in pkg_ref.units)
		{
			ai_ref = level.rts.ai[ unit ];

			if ( ai_ref.species == "vehicle" )
			{
				guy = placeVehicle(ai_ref.ref, groundPos + ( x*36, y*36, RandomInt(36) ), team);
				goalPos = groundpos + ( RandomInt(128), RandomInt(128), 0 );
				x++;
				x = x%2;
				if (x==0)
				{
					y++;
					y = y%2;
				}
			}
			else
			{
				guy = simple_spawn_single( ai_ref.ref, undefined, undefined, undefined, undefined, undefined, undefined, true);
				guy ForceTeleport( groundPos + ( RandomInt(30), RandomInt(30), 0 ), ( 0, RandomInt(180), 0 ) );
				goalPos = guy.origin;
			}
			if (isDefined(guy))
			{
				guy.ai_ref = ai_ref;
				guy maps\_so_rts_squad::addAIToSquad(squadID);
			}
		}
	}
	
	// delay chopper for a bit
	wait( 1 );
	
	self notify( "unloaded" );
}

chopper_release_path()
{
	self.path_start.in_use = undefined;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
hud_message_scroll_down(text,endNote)
{
	level endon(endNote);
	while(1)
	{
		text.y+=1;
		text.alpha -= 0.025;
		wait 0.05;
	}
}

kill_hud_message(text,note)
{
	level waittill_any(note,"kill_all_hud_messages");
	text	maps\_hud_util::destroyElem();
}
kill_hud_message_in_time(text,time,endNote)
{
	level endon(endNote);
	level thread kill_hud_message(text,endNote);
	wait time+0.5;
	level notify(endNote);
}

create_hud_message(text,dlg)
{
	objective_printtext("active",text);
	if (isDefined(dlg) )
	{
		assert(isDefined(level.scr_sound[ "generic" ]) && isDefined(level.scr_sound[ "generic" ][dlg]));
		level.rts.player playsound( level.scr_sound[ "generic" ][ dlg ] );
	}
}


/////////////////////////////////////////////////////////////////////////////////////////////////
time_countdown(timeMin,owner,killNotify="kill_countdown",luiNote="rts_time_left",expiredNote="expired",headerText="SO_RTS_MISSION_TIME_REMAINING_CAPS")
{
	level endon( "rts_terminated" );
	level endon("kill_timer");
	
	if(isDefined(killNotify))
		owner endon(killNotify);
	
	mSec = int(1000*timeMin*60);
	
	LUINotifyEvent( istring(luiNote), 2, mSec, istring(headerText));
	wait(timeMin*60);
	owner notify(expiredNote);
}

time_countdown_delete(luiNote="rts_time_left")
{
	level notify("kill_timer");
	LUINotifyEvent( istring(luiNote),1,0 );
}



missionCompleteMsg(success)
{
	//default game over handler.
	game_over_msg 					= NewHudElem();
	game_over_msg.alignX 			= "center";
	game_over_msg.alignY 			= "middle";
	game_over_msg.horzAlign			= "center";
	game_over_msg.vertAlign			= "middle";
	game_over_msg.y					-= 130;
	game_over_msg.foreground 		= true;
	game_over_msg.fontScale 		= 4;
	game_over_msg.hidewheninmenu	= false;
	game_over_msg.alpha 			= 0;
	if (success)
	{
		game_over_msg.color = ( 0.27, 0.76, 0.08 );
		game_over_msg SetText( &"SO_RTS_MISSION_SUCCESS" );
	}
	else
	{
		game_over_msg.color = ( 0.77, 0.0, 0.0 );
		game_over_msg SetText( &"SO_RTS_MISSION_FAILED" );
	}
	game_over_msg FadeOverTime( 1 );
	game_over_msg.alpha = 0.75;
	
	level.rts.game_success = success;
	flag_set("rts_game_over");
	
	level waittill( "fade_mission_complete" );
	               
	game_over_msg FadeOverTime( 1 );
	game_over_msg.alpha = 0.0;	
}

any_pending_gpr()
{
	if (isDefined(self) && isDefined(self.gpr_queue) )
	{
		return((self.gpr_queue.size>0));
	}
	return 0;
}
process_pending_gpr_sets()
{
	self endon("death");
	
	if (!isDefined(self.gpr_state) )
	{
		self.gpr_state = 0;
	}
	
	waittillframeend;
	
	while(1)
	{
		if (self any_pending_gpr())
		{
			nextGPR = self.gpr_queue[0];
			ArrayRemoveIndex(self.gpr_queue,0);
			
			self setGPR(nextGPR);
			self.gpr_state = !self.gpr_state;
			if ( self.gpr_state == 1 )
			{
				self SetClientFlag(FLAG_CLIENT_FLAG_GPR_UPDATED);
			}
			else
			{
				self ClearClientFlag(FLAG_CLIENT_FLAG_GPR_UPDATED);
			}
		}
		wait 0.1;
	}
}


set_gpr(val,clearAllFirst)
{
	if(!isDefined(self) )
		return;
		
	if (!isDefineD(self.gpr_queue) )
	{
		self.gpr_queue = [];
		self thread process_pending_gpr_sets();
	}
	if (IS_TRUE(clearAllFirst))
	{
		self.gpr_queue = [];
	}
	self.gpr_queue[self.gpr_queue.size] = val;
}

make_gpr_opcode(id)
{
	return (id<<GPR_SHIFT);
}

flush_gpr()
{
	while( self any_pending_gpr() )
	{
		wait 0.05;
	}
}


sortArrayByClosest(origin, array,maxdistSQ,no3d )
{
	if(isDefined(maxdistSQ))
	{
		valid = [];
		
		foreach(item in array)
		{
			if (!isDefineD(item))
				continue;
			if(IS_TRUE(no3d))
			{
				item calcEnt2DScreen();
				itemorigin = (item.fX2d,item.fY2d,0);
			}
			else
			{
				itemorigin = item.origin;
			}
		
			distSQ = distanceSquared(origin, itemorigin);
			if(distSQ>maxdistSQ)
			{
				continue;
			}
			valid[valid.size] = item;
		}
		array = valid;
	}

	if(IS_TRUE(no3d))
	{
		return maps\_utility_code::mergesort( array, ::closestCompareFunc2D, origin );
	}
	else
	{
		return maps\_utility_code::mergesort( array, ::closestCompareFunc, origin );
	}
}
sortArrayByFurthest(origin, array,mindistSQ,no3d )
{
	if(isDefined(mindistSQ))
	{
		valid = [];
		
		foreach(item in array)
		{
			if (!isDefineD(item))
				continue;
				
			if(IS_TRUE(no3d))
			{
				item calcEnt2DScreen();
				itemorigin = (item.fX2d,item.fY2d,0);
			}
			else
			{
				itemorigin = item.origin;
			}
		
			distSQ = distanceSquared(origin, itemorigin);
			item.lastDistCalc = distSQ;
			if(distSQ<mindistSQ)
			{
				continue;
			}
			valid[valid.size] = item;
		}
		array = valid;
	}

	if(IS_TRUE(no3d))
	{
		return maps\_utility_code::mergesort( array, ::furthestCompareFunc2D, origin );
	}
	else
	{
		return maps\_utility_code::mergesort( array, ::furthestCompareFunc, origin );
	}
}
getClosestInArray(origin, array )
{
	sortedArray =  maps\_utility_code::mergesort( array, ::closestCompareFunc, origin );
	return sortedArray[0];
}
getFurthestInArray(origin, array )
{
	sortedArray =  maps\_utility_code::mergesort( array, ::furthestCompareFunc, origin );
	return sortedArray[0];
}

closestCompareFunc2D( e1, e2, origin )
{
	e1 calcEnt2DScreen();
	e2 calcEnt2DScreen();

	e1origin = (e1.fX2d,e1.fY2d,0);
	e2origin = (e2.fX2d,e2.fY2d,0);
	
	distSQ1 = distanceSquared(origin, e1origin );
	distSQ2 = distanceSquared(origin, e2origin );
	
	return distSQ1 < distSQ2;
}
furthestCompareFunc2D( e1, e2, origin )
{
	e1 calcEnt2DScreen();
	e2 calcEnt2DScreen();

	e1origin = (e1.fX2d,e1.fY2d,0);
	e2origin = (e2.fX2d,e2.fY2d,0);
	
	distSQ1 = distanceSquared(origin, e1origin );
	distSQ2 = distanceSquared(origin, e2origin );
	
	return distSQ1 > distSQ2;
}
closestCompareFunc( e1, e2, origin )
{
	distSQ1 = distanceSquared(origin, e1.origin );
	distSQ2 = distanceSquared(origin, e2.origin );
	return distSQ1 < distSQ2;
}
furthestCompareFunc( e1, e2, origin )
{
	distSQ1 = distanceSquared(origin, e1.origin );
	distSQ2 = distanceSquared(origin, e2.origin );
	return distSQ1 > distSQ2;
}



getClosestAI(origin, team,distSQMax)
{
	aiteam 	 	= ArrayCombine( GetVehicleArray( team ), GetAIArray( team ) , false, false);
	closest 	= undefined;
	closestSQ	= 9999999;
	
	
	foreach (ai in aiteam)
	{
		distSQ = distanceSquared(origin, ai.origin );
		if (distSQ < distSQMax && distSQ < closestSQ )
		{
			closestSQ = distSQ;
			closest   = ai;
		}
	}
	return closest;
}

fadeModelOut(model,squadID,timeSec)
{
	self notify("fadeModelOut"+squadID);
	self endon("fadeModelOut"+squadID);
	wait timeSec;
	if(isDefined(model) )
	{
		model hide();
	}
}

player_plant_network_intruder(poi)
{
	flag_set("block_input");
	self EnableInvulnerability();
	self.plantingNetworkIntruder 	= true;
	poi.intruder_being_planted		= true;
	player_tag_origin 				= Spawn( "script_model", self.origin );
	player_tag_origin.angles 		= self.angles;
	player_tag_origin SetModel( "tag_origin" );
	player_tag_origin.targetname = "player_tag_origin";
	
	level thread run_scene( "plant_network_intruder" );
	
	wait( 0.05 );
	network_intruder = Spawn( "script_model", self.origin );
	network_intruder SetModel( "t6_wpn_hacking_device_world" );
	network_intruder.origin = self.m_scene_model GetTagOrigin( "tag_weapon" );
	network_intruder.angles = self.m_scene_model GetTagAngles( "tag_weapon" );
	network_intruder LinkTo( self.m_scene_model, "tag_weapon" );
	/#
	recordEnt( network_intruder );
	#/
	flag_wait( "plant_network_intruder_done" );
	self DisableInvulnerability();
	flag_clear("block_input");

	network_intruder Unlink();

	// set it upright
	network_intruder.origin = self.origin;
	network_intruder.angles = self.angles;
	
	player_tag_origin Delete();
	network_intruder thread setupNetworkIntruder(poi);
	
	self.plantingNetworkIntruder = false;
	poi.intruder_being_planted 	 = undefined;
}

ai_plant_network_intruder(poi)
{
	poi.ai_intruder_plant_attempt = GetTime()+1000;
	network_intruder = Spawn( "script_model", self.origin );
	network_intruder SetModel( "t6_wpn_hacking_device_world" );
	network_intruder thread setupNetworkIntruder(poi);
}

setupNetworkIntruder(poi)
{
	level.rts.networkIntruders[ level.rts.networkIntruders.size ] = self;
		
	level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_INTRUDER_SET");
	maps\_so_rts_event::trigger_event("intruder_placed");
			
	self.takedamage = true;
	self.health = 200;
	myOrigin = self.origin;
	
	self thread blinky_light( level._effect[ "network_intruder_blink" ], "tag_fx" );
	
	fakeVehicle = maps\_vehicle::spawn_vehicle_from_targetname( "fake_vehicle" );
	fakeVehicle.team = "allies";
	fakeVehicle.vteam = "allies";
	fakeVehicle.origin = self GetTagOrigin( "tag_fx" );
	fakeVehicle.threatbias = -1000;
	fakeVehicle LinkTo( self );
	
	entNum = self GetEntityNumber();
	LUINotifyEvent( &"rts_add_poi", 1, entNum );
	LUINotifyEvent( &"rts_protect_poi", 1, entNum );
	
	const NOTIFY_INTERVAL = 4000;	
	lastNotify = 0;
	
	// monitor damage
	while(1)
	{
		self waittill( "damage", damage, attacker );
		
		// death
		if( !IsAlive(self) )
		{
			LUINotifyEvent( &"rts_del_poi", 1, entNum );
			if( IsDefined(attacker) && attacker != self )
			{
				level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_INTRUDER_DESTROYED");
			}
			
			// play death fx
			maps\_so_rts_event::trigger_event("sfx_intruder_explode",self);
			maps\_so_rts_event::trigger_event("fx_intruder_explode",myOrigin);
			
			// remove the fake sentient once the network intruder's destroyed
			if(isDefined(fakeVehicle))
			fakeVehicle Delete();
			
			// remove the model
			self Delete();
			
			// remove from level list
			ArrayRemoveValue( level.rts.networkIntruders, self );
			if (!IS_TRUE(poi.captured))
			{
				maps\_so_rts_event::trigger_event("intruder_died");
			}
				
			return;
		}
		else if( GetTime() > (lastNotify - NOTIFY_INTERVAL) )
		{
			maps\_so_rts_event::trigger_event("intruder_hit");
			level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_INTRUDER_ATTACK");
			level notify("intruder_alert",self);
			lastNotify = GetTime();
		}
	}
}

sfxAndFx(origin,sfx_alias,fx_alias)
{
	PlayFX( level._effect[ fx_alias], origin );
	playsoundatposition( sfx_alias, origin );
	return true;
}


blinky_light( fx, tagName )
{
	self endon( "death" );

	while( true )
	{
		self playsound( "evt_rts_acoustic_sensor_beep" );
		PlayFXOnTag( fx, self, tagName );
		wait( 0.5 );
	}
}

/#
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// TEST FUNCTIONS ///////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
	
setup_devgui()
{
	SetDvar( "cmd_send_chopper",			"none" );
	SetDvar( "cmd_take_poi",				"none" );
		
	// set dvars to 0, if undefined
	if( GetDvarInt( "scr_rts_enemyDisabled" ) == 0 )
		SetDvar( "scr_rts_enemyDisabled", "0" );
	
	if( GetDvarInt( "scr_rts_enemyDebug" ) == 0 )
		SetDvar( "scr_rts_enemyDebug", "0" );
	
	if( GetDvarInt( "scr_rts_allpkgs" ) == 0 )
		SetDvar( "scr_rts_allpkgs", "0" );

	if( GetDvarInt( "scr_rts_cameraMode" ) == 0 )
		SetDvar( "scr_rts_cameraMode", "0" );
	
	if( GetDvarInt( "scr_rts_squadDebug" ) == 0 )
		SetDvar( "scr_rts_squadDebug", "0" );
	
	AddDebugCommand( "devgui_cmd \"|RTS|/Helicopters:1/Send Ally Infantry:1\" \"cmd_send_chopper allies_helo\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/Helicopters:1/Send Ally Quads:2\" \"cmd_send_chopper allies_quads\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/Helicopters:1/Send Ally ASD:3\" \"cmd_send_chopper allies_asd\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/Helicopters:1/Send Ally CLAW:4\" \"cmd_send_chopper allies_claw\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/Helicopters:1/Send Enemy Infantry:5\" \"cmd_send_chopper axis_helo\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/Helicopters:1/Send Enemy Quads:6\" \"cmd_send_chopper axis_quads\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/Helicopters:1/Send Enemy ASD:7\" \"cmd_send_chopper axis_asd\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/Helicopters:1/Send Enemy CLAW:8\" \"cmd_send_chopper axis_claw\"\n" );
	
	AddDebugCommand( "devgui_cmd \"|RTS|/Enemy Mgr:2/Enabled:1/True:1\" \"scr_rts_enemyDisabled 0\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/Enemy Mgr:2/Enabled:1/False:2\" \"scr_rts_enemyDisabled 1\"\n" );
	
	AddDebugCommand( "devgui_cmd \"|RTS|/Enemy Mgr:2/Debug:2/On:1\" \"scr_rts_enemyDebug 1\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/Enemy Mgr:2/Debug:2/Off:2\" \"scr_rts_enemyDebug 0\"\n" );
	
	AddDebugCommand( "devgui_cmd \"|RTS|/Packages:3/Allow All:1/On:1\" \"scr_rts_allpkgs 1\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/Packages:3/Allow All:1/Off:2\" \"scr_rts_allpkgs 0\"\n" );
	
	AddDebugCommand( "devgui_cmd \"|RTS|/POIs:4/All:1/Allies:1\" \"cmd_take_poi all_allies\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/POIs:4/All:1/Axis:2\" \"cmd_take_poi all_axis\"\n" );
	
	AddDebugCommand( "devgui_cmd \"|RTS|/POIs:4/1:2/Allies:1\" \"cmd_take_poi 1_allies\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/POIs:4/1:2/Axis:2\" \"cmd_take_poi 1_axis\"\n" );
	
	AddDebugCommand( "devgui_cmd \"|RTS|/POIs:4/2:3/Allies:1\" \"cmd_take_poi 2_allies\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/POIs:4/2:3/Axis:2\" \"cmd_take_poi 2_axis\"\n" );
	
	AddDebugCommand( "devgui_cmd \"|RTS|/POIs:4/3:4/Allies:1\" \"cmd_take_poi 3_allies\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/POIs:4/3:4/Axis:2\" \"cmd_take_poi 3_axis\"\n" );

	AddDebugCommand( "devgui_cmd \"|RTS|/Camera:5/Mode:1/Look:1\" \"scr_rts_cameraMode 0\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/Camera:5/Mode:1/Orbit:2\" \"scr_rts_cameraMode 1\"\n" );
	
	AddDebugCommand( "devgui_cmd \"|RTS|/Squads:2/Debug:2/On:1\" \"scr_rts_squadDebug 1\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/Squads:2/Debug:2/Off:2\" \"scr_rts_squadDebug 0\"\n" );


	thread watch_devgui();
}

watch_devgui()
{
	pkg_refs = [];
	pkg_refs[ "helo" ] 	= "infantry_ally_reg_pkg";
	pkg_refs[ "quads" ] = "quadrotor_pkg";
	pkg_refs[ "asd" ] 	= "metalstorm_pkg";
	pkg_refs[ "claw" ]	= "bigdog_pkg";
	
	//last_cmd_send_chopper = GetDvar("cmd_send_chopper");
	lastCameraMode = level.rts.game_rules.camera_mode;
	while(1)
	{
		lastCameraMode = int(GetDvar("scr_rts_cameraMode"));
		if (lastCameraMode != level.rts.game_rules.camera_mode  )
		{
			level.rts.game_rules.camera_mode = lastCameraMode;
			lastCameraMode = level.rts.game_rules.camera_mode;
			if (level.rts.game_rules.camera_mode ==CAMERA_MODE_ORBIT )
			{
				level.rts.game_rules.minPlayerZ = 320;	//taken from .csv
				level.rts.game_rules.maxPlayerZ = 1200;
				level.rts.game_rules.zoom_avail = 1;
			}
			else
			if (level.rts.game_rules.camera_mode ==CAMERA_MODE_LOOK )
			{
				level.rts.game_rules.minPlayerZ = 400;	//taken from .csv
				level.rts.game_rules.maxPlayerZ = 400;
				level.rts.game_rules.zoom_avail = 0;
			}
			level.rts.minPlayerZ	 = level.rts.player.origin[2] + level.rts.game_rules.minPlayerZ;
			level.rts.maxPlayerZ	 = level.rts.minPlayerZ + level.rts.game_rules.maxPlayerZ;
			
			if (flag("rts_mode"))
			{
				player_takeover_random_dude();	
			}
		}
	
		cmd_send_chopper = GetDvar("cmd_send_chopper");
		cmd_take_poi = GetDvar("cmd_take_poi");
		
		if( cmd_send_chopper != "none" )
		{
			cmd_tokens = StrTok( cmd_send_chopper, "_" );
			team = cmd_tokens[0];
			type = cmd_tokens[1];
			
			/#
			iprintln( "Send chopper: " + cmd_send_chopper );
			#/

			package = maps\_so_rts_catalog::package_GetPackageByType( pkg_refs[ type ] );
			
			test_heli_dropoff( type, team, package );

			SetDvar( "cmd_send_chopper", "none" );
		}
		
		if( cmd_take_poi != "none" )
		{
			cmd_tokens = StrTok( cmd_take_poi, "_" );
			which = cmd_tokens[0];
			team = cmd_tokens[1];
			/#
			iprintln( "Claim POI: " + cmd_take_poi );
			#/
			count = 1;
			for( i = 0; i < level.rts.poi.size; i++ )
			{
				poi = level.rts.poi[i];
				
			
				if( which == "all" )
				{
					maps\_so_rts_poi::ClaimPOI(poi, team);
					poi.dominate_weight = 99999;
				}
				else if( count == int(which) )
				{
					maps\_so_rts_poi::ClaimPOI(poi, team);
					poi.dominate_weight = 99999;
					break;
				}
				
				count++;
			}

			SetDvar( "cmd_take_poi", "none" );
		}
		
		wait( 0.05 );
	}
}


player_takeover_random_dude()
{
	if(flag("rts_mode"))
	{
		allies = GetAIArray("allies");
		valid  = [];
		foreach(guy in allies)
		{
			if (!maps\_so_Rts_ai::ai_IsSelectable(guy) || !IS_TRUE(level.rts.squads[guy.squadID].selectable) )
			{
				continue;
			}
			valid[valid.size] = guy;
		}
		allies = valid;
		if (allies.size == 0 )
		{
			return;
		}
		level.rts.targetTeamMate = allies[RandomInt(allies.size)];
		thread maps\_so_rts_main::player_in_control();
	}
}


test_heli_dropoff( type, team, pkg_ref )
{	
	availtransport = SpawnStruct();
	
	if( type == "quads" || type == "asd" || type == "claw" )
		availtransport.cb 	 		= maps\_so_rts_ai::spawn_ai_package_cargo;
	else
		availtransport.cb 	 		= maps\_so_rts_ai::spawn_ai_package_helo;
	
	availtransport.param		= undefined;
	availtransport.pkg_ref		= pkg_ref;
	availtransport.type			= type;
	availtransport.team			= team;
	availtransport.state 		= TRANSPORT_STATUS_BEINGLOADED;
	availtransport.loadTime 	= GetTime();
	availtransport.dropTarget 	= level.player.origin;
	availtransport.squadID 		= maps\_so_rts_squad::createSquad( availtransport.dropTarget, team, pkg_ref ); //every PACKAGE spawned should have a unique identifyer
	[[availtransport.cb]](availtransport);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
#/
	


toggle_damage_indicators(on)
{
	if(on == true )
	{
		SetDvar( "scr_damagefeedback", "1" );
		level.disable_damage_overlay = undefined;
	}
	else
	{
		SetDvar( "scr_damagefeedback", "0" );
		level.rts.player maps\_damagefeedback::updateDamageFeedback( );
		level.disable_damage_overlay = true;
	}
}

formatFloat( number, decimals )
{
	power = Pow( 10, decimals );
	temp = int( number * power );
	temp = float( temp / power );
	
	return temp;
}

#define FXY_2D_CALC_LATENCY		150
calcEnt2DScreen()
{
	if ( !flag("rts_mode"))
		return;
		
	time = GetTime();
	if (!isDefined(self.next2DCalc) || self.next2DCalc < time)
	{
		angles 			= level.rts.player GetPlayerAngles();
		up_vec1 		= AnglesToUp( angles );
		right_vec2 		= AnglesToRight( angles );
		forward_vec3 	= AnglesToForward( angles );
		
		p1				= level.rts.player.origin;
		p2				= p1 + VectorScale( up_vec1, 100 );
		p3				= p1 + VectorScale( right_vec2, 100 );
		r1				= self.origin;
		r2				= level.rts.player.origin +  VectorScale( forward_vec3, -100 );
		vRotRay1 		= ( VectorDot (up_vec1, r1-p1 ), VectorDot (right_vec2, r1-p1 ), VectorDot (forward_vec3, r1-p1 ) );
		vRotRay2 		= ( VectorDot (up_vec1, r2-p1 ), VectorDot (right_vec2, r2-p1 ), VectorDot (forward_vec3, r2-p1 ) ); 
		
		if (vRotRay1[2] == vRotRay2[2])
			return;
		
		fPercent 		= vRotRay1[2] / (vRotRay2[2]-vRotRay1[2]);
		vIntersect2d 	= vRotRay1 + (vRotRay1-vRotRay2) * fPercent;
		self.fX2d 		= vIntersect2d[0];
		self.fY2d 		= vIntersect2d[1];
		
		if ( !isDefined(self.next2DCalc) )
		{
			self.next2DCalc 	= time + RandomInt(FXY_2D_CALC_LATENCY);//random it so that all ents don't calc on same frame
		}
		else
		{
			self.next2DCalc 	= time + FXY_2D_CALC_LATENCY;
		}
		//Print3d( self.origin, "FXY: "+formatFloat(self.fX2d,2) + " " + formatFloat(self.fY2d,2), ( 0, 1, 0 ), 1, 1, 5 );

	}
}


#define UNIT_TYPE_ALLY	0
#define UNIT_TYPE_AXIS	1
#define UNIT_TYPE_POI	2
getClosestUnitType(type,threshCheckSQ = 100)
{
	origin = (0,0,0);//origin is set to 0,0(and 0)   0,0 represents center of screen, the sort below passes true in for no3d which will do a screenspace sort. 
	
	switch (type)
	{
		case UNIT_TYPE_ALLY:
			units = ArrayCombine( GetVehicleArray( "allies" ), GetAIArray( "allies" ) , false, false);
			checkAIValid = true;
		break;
		case UNIT_TYPE_AXIS:
			units = ArrayCombine( GetVehicleArray( "axis"), GetAIArray( "axis" ) , false, false);
			checkAIValid = true;
		break;
		case UNIT_TYPE_POI:
			units = maps\_so_rts_poi::getPOIEnts();
			checkNotPlayerTeam = true;
		break;
		default:
			assert(0,"unhandled type");
		break;
	}
	closest		= undefined;
	sortedUnits	= sortArrayByClosest(origin, units, threshCheckSQ, true ); 
	for (i=0;i<sortedUnits.size;i++)
	{
		unit = sortedUnits[i];
		if (IS_TRUE(checkAIValid) )
		{
			if (!maps\_so_rts_ai::ai_IsSelectable(unit))
				continue;
		}
		if ( IS_TRUE(checkNotPlayerTeam) )
		{
			if ( unit.team == level.rts.player.team )
				continue;
		}
		closest = unit;
		break;			
	}
	return closest;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
unitReticleTracker()
{
	level endon( "rts_terminated" );


	while(flag("rts_mode"))
	{
		closest			= undefined;
		closestTeamEnemy= undefined;

		closest = getClosestUnitType(UNIT_TYPE_POI);
			
		if ( isDefined(closest) )
		{
			if ( isDefined(level.rts.targetPOI)  && closest != level.rts.targetPOI )
		 	{
				LUINotifyEvent( &"rts_deselect_poi", 1, level.rts.targetPOI GetEntityNumber() );
				level.rts.targetPOI = undefined;
			}
			if (!isDefined(level.rts.targetPOI))
			{
				LUINotifyEvent( &"rts_target_poi", 1, closest GetEntityNumber() );
				level.rts.targetPOI = closest;
				level.rts.targetTeamEnemy  = undefined;
				thread pick_delayed_selection_sound( "poi", closest );
			}
		}
		else
		{
			if ( isDefined(level.rts.targetPOI) )
			{
				LUINotifyEvent( &"rts_deselect_poi", 1, level.rts.targetPOI GetEntityNumber() );
				level.rts.targetPOI = undefined;
			}
		}
		if (!isDefined(level.rts.targetPOI))
		{
			closestTeamEnemy = getClosestUnitType(UNIT_TYPE_AXIS);
			
			if ( isDefined(closestTeamEnemy) )
			{
				if ( isDefined(level.rts.targetTeamEnemy )  && closestTeamEnemy != level.rts.targetTeamEnemy )
			 	{
					LUINotifyEvent( &"rts_deselect_enemy", 1, level.rts.targetTeamEnemy GetEntityNumber() );
					level.rts.targetTeamEnemy = undefined;
			 	}
				if ( !isDefined(level.rts.targetTeamEnemy) )
				{
					LUINotifyEvent( &"rts_target_enemy", 1, closestTeamEnemy GetEntityNumber() );
					level.rts.targetTeamEnemy = closestTeamEnemy;
					thread pick_delayed_selection_sound( "axis", closestTeamEnemy );
				}
			}
			else
			{
				if ( isDefined(level.rts.targetTeamEnemy ) )
				{
					LUINotifyEvent( &"rts_deselect_enemy", 1, level.rts.targetTeamEnemy GetEntityNumber() );
					level.rts.targetTeamEnemy = undefined;
				}
			}
		}

		closest = getClosestUnitType(UNIT_TYPE_ALLY);
		
		if ( isDefined(closest) )
		{
			assert(maps\_so_rts_ai::ai_IsSelectable(closest),"illegal target");
			if ( isDefined(level.rts.targetTeamMate) && closest != level.rts.targetTeamMate )
		 	{
				LUINotifyEvent( &"rts_deselect", 1, level.rts.targetTeamMate GetEntityNumber() );
				level.rts.targetTeamMate = undefined;
			}
			if (!isDefined(level.rts.targetTeamMate ))
			{
				LUINotifyEvent( &"rts_target", 1, closest GetEntityNumber() );
				level.rts.targetTeamMate = closest;
				thread pick_delayed_selection_sound( "ally", closest );
			}
		}
		else
		{
			if ( isDefined(level.rts.targetTeamMate) )
			{
				LUINotifyEvent( &"rts_deselect", 1, level.rts.targetTeamMate GetEntityNumber() );
				level.rts.targetTeamMate = undefined;
			}
		}
		
	
		wait 0.1;
	}
	
	if(isDefined(level.rts.targetPOI))
	{	
		LUINotifyEvent( &"rts_deselect_poi", 1, level.rts.targetPOI GetEntityNumber() );
	}
	if(isDefined(level.rts.targetTeamEnemy ) )
	{
		LUINotifyEvent( &"rts_deselect_enemy", 1, level.rts.targetTeamEnemy GetEntityNumber() );
	}
	if(isDefined(level.rts.targetTeamMate))
	{
		LUINotifyEvent( &"rts_deselect", 1, level.rts.targetTeamMate GetEntityNumber() );
	}
}
pick_delayed_selection_sound( type, guy )
{
	wait(.1);
	
	switch( type )
	{
		case "poi":
			if( !isdefined( level.rts.targetPOI ) || level.rts.targetPOI != guy )
				return;
			maps\_so_rts_event::trigger_event("poi_select");
			return;
			
		case "axis":
			if( !isdefined( level.rts.targetTeamEnemy ) || level.rts.targetTeamEnemy != guy )
				return;
			maps\_so_rts_event::trigger_event("enemy_select");
			return;
		case "ally":
			maps\_so_rts_event::trigger_event("friendly_select",guy);
			return;
	}
}
get_selection_alias_from_targetname( guy, p2, p3 )
{
	if( !isdefined( guy )  || !isDefined(guy.ai_ref.select_alias) )
		alias = "evt_rts_selection_friendly_generic";
	else
		alias = guy.ai_ref.select_alias;
		
	PlaySoundAtPosition( alias, (0,0,0) );
	return true;
}

block_player_damage_fortime(time)//self is player
{
	self endon("death");
	level endon( "rts_terminated" );
	if (IS_TRUE(self.blockAllDamage))
		return;
		
	self EnableInvulnerability();
	self.blockAllDamage = true;
	wait time;
	if( !(isDefined(self.ally) && isDefined(self.ally.vehicle)))
	{
		self DisableInvulnerability();
	}
	self.blockAllDamage = undefined;
}

set_as_target( team )
{
	fakeTarget = maps\_vehicle::spawn_vehicle_from_targetname( "fake_vehicle" );
	fakeTarget.team = team;
	fakeTarget.vteam = team;
	fakeTarget.origin = self GetCentroid();
	fakeTarget.threatbias = -1000;
	fakeTarget LinkTo( self );
	
	self thread delete_ent_on_death( fakeTarget );
}

delete_ent_on_death( entity )
{
	self waittill( "death" );
	
	entity Delete();
}

isEntBelowMap()
{
	if (IS_TRUE(self.allow_OOB))
		return false;

	if (isDefined(level.rts.bounds) )
	{
		if ( self.origin[2] <= level.rts.bounds.minZ )
		{
			return true;
		}
	}
	return false;
}

setupMapBoundary()
{
	ulXY = GetStruct("rts_ulxy","targetname");
	lrXY = GetStruct("rts_lrxy","targetname");
	if(isDefineD(ulXY) && isDefineD(lrXY))
	{
		ux	 = (ulXY.origin[0]<lrXY.origin[0]?ulXY.origin[0]:lrXY.origin[0]);
		lx	 = (ulXY.origin[0]<lrXY.origin[0]?lrXY.origin[0]:ulXY.origin[0]);
		uy	 = (ulXY.origin[1]<lrXY.origin[1]?ulXY.origin[1]:lrXY.origin[1]);
		ly	 = (ulXY.origin[1]<lrXY.origin[1]?lrXY.origin[1]:ulXY.origin[1]);
		level.rts.bounds 		= spawnstruct();
		level.rts.bounds.ulX 	= ux;
		level.rts.bounds.ulY 	= uy;
		level.rts.bounds.lrX  	= lx;
		level.rts.bounds.lrY  	= ly;
		level.rts.bounds.minZ 	= (ulXY.origin[2]<lrXY.origin[2]?ulXY.origin[2]:lrXY.origin[2]);
		level.rts.bounds.maxZ 	= (ulXY.origin[2]<lrXY.origin[2]?lrXY.origin[2]:ulXY.origin[2]);
	}
}
clampEntToMapBoundary(ent,damage=false,warnMsg=false)
{
	if (!IS_TRUE(ent.rts_unloaded) && IS_TRUE(damage))
		return true;
	if (IS_TRUE(ent.allow_OOB))
		return true;

	val = clampOriginToMapBoundary(ent.origin);

	if (val.inBounds)
		return true;
			

	if (IS_TRUE(warnMsg) )
	{
		if(!isDefineD(ent.oob_warning_time))
		{
			ent.oob_warning_time = GetTime() + 5000;
			return false;
		}
			
		if ( GetTime()<ent.oob_warning_time )
			return false;
	}

	if (IS_TRUE(damage) )
	{
		ent.armor = 0;
		
		if (IS_VEHICLE(ent))
		{
			ent veh_magic_bullet_shield(false);
		}
		/#
		println("@@@@ RIP: AI["+ent.ai_ref.ref+"] destroyed for being out of bounds ("+ent.origin+")");
		#/
		ent DoDamage( int(ent.maxHealth+100), ent.origin,undefined,undefined,"explosive" );
	}
	else
	{
		if ( !isDefined(ent.classname) || ent.classname =="script_model" )
		{
			ent.origin = val.origin;
		}
		else
		{
			ent forceteleport( val.origin,ent.angles);
		}
	}
	return false;
}

clampOriginToMapBoundary(origin)
{
	ret = spawnStruct();
	ret.inBounds = true;
	ret.origin	 = origin;
	
	if (isDefined(level.rts.bounds) )
	{
		x		 = origin[0];
		y		 = origin[1];
		z		 = origin[2];
		
		if ( x <= level.rts.bounds.ulX )
		{
			ret.inBounds = false;
			x		 = level.rts.bounds.ulX;
		}
		else
		if ( x >= level.rts.bounds.lrX )
		{
			ret.inBounds = false;
			x		 = level.rts.bounds.lrX;
		}

		if ( y <= level.rts.bounds.ulY )
		{
			ret.inBounds = false;
			y		 = level.rts.bounds.ulY;
		}
		else
		if ( y >= level.rts.bounds.lrY )
		{
			ret.inBounds = false;
			y		 = level.rts.bounds.lrY;
		}
	
		if ( z <= level.rts.bounds.minZ )
		{
			ret.inBounds = false;
			z = level.rts.bounds.minZ;
		}

		if ( z >= level.rts.bounds.maxZ )
		{
			ret.inBounds = false;
			z = level.rts.bounds.maxZ;
		}
		ret.origin = (x,y,z);
	}
	return ret;
}


boundary_watcher(damage,interval=0.05,warnMsg,endNote)
{
	self notify("boundary_watcher");
	self endon("death");
	self endon("boundary_watcher");
	if (isDefineD(endNote))
	{
		self endon(endNote);
		level endon(endNote);
	}
	while(1)
	{
		clampEntToMapBoundary(self,damage,warnMsg);
		wait interval;
	}
}

flag_set_inNSeconds(flag,time)
{
	wait time;
	flag_set(flag);
}
flag_clear_inNSeconds(flag,time)
{
	wait time;
	flag_clear(flag);
}


custom_introscreen( string1, string2, string3, string4, string5 )
{
	level.introstring = []; 
	
	introblack = NewHudElem(); 
	introblack.x = 0; 
	introblack.y = 0; 
	introblack.horzAlign = "fullscreen"; 
	introblack.vertAlign = "fullscreen"; 
	introblack.foreground = true;
	introblack SetShader( "black", 640, 480 );

	flag_wait("all_players_connected");

	// Fade out black
	wait 0.1;
	introblack Destroy();

	flag_wait("all_players_connected");

	level.introstring = []; 
	
	letter_time = 0.05;
	decay_duration = 0.5;
	pausetime = 1;
	totaltime = 14.25;
	color = ( 1, 1, 1 );
	
	letter_time 		= Int( 1000 * letter_time );  		// convert to milliseconds
	decay_duration 		= Int( 1000 * decay_duration );		// convert to milliseconds
	decay_start 		= Int( 1000 * totaltime ); 			// convert to milliseconds
	totalpausetime		= 0; 								// track how much time we've waited so we can wait total desired waittime

	if( IsDefined( string1 ) )
	{
		level thread maps\_introscreen::introscreen_create_typewriter_line( string1, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 
		
		wait( pausetime );
		totalpausetime += pausetime;
	}

	if( IsDefined( string2 ) )
	{
		decay_start = Int( 1000 * ( totaltime - totalpausetime ) );
		level thread maps\_introscreen::introscreen_create_typewriter_line( string2, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 

		wait( pausetime );
		totalpausetime += pausetime;
	}

	if( IsDefined( string3 ) )
	{
		decay_start = Int( 1000 * ( totaltime - totalpausetime ) );
		level thread maps\_introscreen::introscreen_create_typewriter_line( string3, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 

		wait( pausetime );
		totalpausetime += pausetime;
	}
	
	if( IsDefined( string4 ) )
	{
		decay_start = Int( 1000 * ( totaltime - totalpausetime ) );
		level thread maps\_introscreen::introscreen_create_typewriter_line( string4, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 

		wait( pausetime );
		totalpausetime += pausetime;
	}		
	
	if( IsDefined( string5 ) )
	{
		decay_start = Int( 1000 * ( totaltime - totalpausetime ) );
		level thread maps\_introscreen::introscreen_create_typewriter_line( string5, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 

		wait( pausetime );
		totalpausetime += pausetime;
	}

	// Fade out text
	maps\_introscreen::introscreen_fadeOutText(); 

	flag_set( "introscreen_complete" ); // Notify when complete
}
//////////////////////////////////////////////////////////////////////////////////////////////////

trigger_use(trigger,banner,usedNote)
{
	trigger SetCursorHint( "HINT_NOICON" );
	while(isDefined(trigger))
	{
		wait 0.05;
		if (!isDefined(trigger))
			return;
			
		trigger SetHintString( "");
		trigger waittill("trigger",who);
		if (!isPlayer(who))
			continue;

		trigger SetHintString( banner );

		btnDown = false;
		while(isDefined(trigger) && who istouching(trigger))
		{
			if ( who UseButtonPressed() && !who.throwingGrenade && !who meleeButtonPressed() )
			{
				btnDown = true;
			}
			if (btnDown && !who UseButtonPressed())
			{
				self notify(usedNote,who);
				break;
			}
			wait 0.05;
		}
	}
}


delay_kill(delay)
{
	self endon("death");
	wait delay;
	self kill();
}

killZoneWatch()
{
	self endon("death");
	
	teams = [];
	if (isArray(self.teams))
		teams = self.teams;
	else
		teams[0] = self.teams;
	
	while(1)
	{
		self waittill("trigger",who);	
		valid = false;
		foreach(team in teams)
		{
			if (who.team == team)
			{
				valid = true;
				break;
			}
		}
		if(valid)
		{
			who kill();
		}
	}
}
createKillzone(origin, width, height, teams)
{
	
	killzone = spawn("trigger_radius", origin, 7, width, height);
	killzone.teams = teams;
	killzone thread killZoneWatch();
	return killzone;

}

