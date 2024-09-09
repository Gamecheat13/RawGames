#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;

/*
=============
///ScriptDocBegin
"Name: move_player_to_start( struct_targetname )"
"Summary: attempts to move the player to the struct with the targetname"
"MandatoryArg: <struct_targetname>: the targetname of the struct you want the player to be moved to (and match angles if they are set)"
"Example: return move_player_to_start( player_berlin_chopper_crash )"
"Module: Player"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
move_player_to_start( struct_targetname )
{
	if ( !IsDefined( struct_targetname ) )
	{
		struct_targetname = level.start_point + "_playerstart";
	}
	
	start = getstruct( struct_targetname, "targetname" );
	AssertEx( IsDefined( start ), "start position not defined: " + struct_targetname );
	if ( IsDefined( start ) )
	{
		teleport_player( start );
	}
}

/*
=============
///ScriptDocBegin
"Name: spawn_friendlies(thing)"
"Summary: spawn friendlies at a target and possibly call replace_on_death on them"
"MandatoryArg: <struct_targetname>: target name of the struct loction to teleport them to"
"MandatoryArg: <friendly_noteworthy>: script_noteworthy name of the array of spawners to use"
"OptionalArg: <bShouldReplaceOnDeath>: if the ai should have replace_on_death called on them"
"OptionalArg: <limit>: maximum number of spawns we should do"
"Example: spawn_friendlies( player_start_berlin, little_bird_friendlies, false )"
"Module: AI"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
spawn_friendlies( struct_targetname, friendly_noteworthy, bShouldReplaceOnDeath, limit )
{
	if(!isdefined(bShouldReplaceOnDeath))
		bShouldReplaceOnDeath = true;
	entarr = getentarray(friendly_noteworthy, "script_noteworthy");
	spawner_arr = [];
	ent_count = 0;
	guy_arr = [];
	
	
	foreach(ent in entarr)
	{
		if( isSpawner(ent) )
		{
			spawner_arr[spawner_arr.size] = ent;
		}
	}
	
	loc = getstruct( struct_targetname, "targetname");
	
	count = 0;
	foreach(spawner in spawner_arr)
	{
		new_guy = spawner spawn_ai( true );
		if(bShouldReplaceOnDeath)
			new_guy thread replace_on_death();
		new_guy forceTeleport( loc.origin, loc.angles );
		new_guy setgoalpos( new_guy.origin );
		guy_arr = array_add(guy_arr, new_guy);
		count++;
		if(isdefined(limit) && count >= limit)
			return guy_arr;
	}
	return guy_arr;
}

/*
=============
///ScriptDocBegin
"Name: setup_player_for_scene( <wait_until_ready> )"
"Summary: prepare the player for a scripted animated scene (opposite call to setup_player_for_gameplay)"
"OptionalArg: <wait_until_ready>: function will wait until player is ready to play a scripted animation (until player is standing and not using a grenade or switching a weapon)"
"Example: level.player setup_player_for_scene( true )"
"Module: Player"
"CallOn: A Player"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
setup_player_for_scene( wait_until_ready )
{
	self AllowMelee( false );
	self DisableWeapons();
	self DisableOffhandWeapons();
	
	self AllowStand( true );
	self AllowCrouch( false );
	self AllowProne( false );
	self AllowSprint( false );
	
	if ( IsDefined( wait_until_ready ) && wait_until_ready )
	{
		while ( ( self GetStance() != "stand" ) || self IsThrowingGrenade() || self IsSwitchingWeapon() )
		{
			self SetStance( "stand" );
			wait 0.05;
		}
	}
}

/*
=============
///ScriptDocBegin
"Name: setup_player_for_gameplay()"
"Summary: prepare the player for gameplay after animations have been called (opposite call to setup_player_for_scene)"
"Example: level.player setup_player_for_gameplay()"
"Module: Player"
"CallOn: A Player"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
setup_player_for_gameplay()
{
	self AllowSprint( true );	
	self AllowProne( true );
	self AllowCrouch( true );
	self AllowStand( true );
	
	self EnableOffhandWeapons();
	self EnableWeapons();
	self AllowMelee(true);
}

/*
=============
///ScriptDocBegin
"Name: monitorScopeChange()"
"Summary: monitor weapon usage for changing the magnification of weapons while in ads"
call this as a thread from your level and specify the names of any number of weapons in the level.variable_scope_weapons array
"Example: thread monitorScopeChange()"
"Module: Utility (SHG)"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
monitorScopeChange()
{
	foreach( p in level.players )
	{
		if ( !isdefined( p.sniper_zoom_hint_hud) )
		{
			p.sniper_zoom_hint_hud = p createClientFontString( "default", 1.75 );
			p.sniper_zoom_hint_hud.horzAlign = "center";
			p.sniper_zoom_hint_hud.vertAlign = "top";
			p.sniper_zoom_hint_hud.alignX = "center";
			p.sniper_zoom_hint_hud.alignY = "top";
			p.sniper_zoom_hint_hud.x = 0;
			p.sniper_zoom_hint_hud.y = 20;
			p.sniper_zoom_hint_hud SetText(&"VARIABLE_SCOPE_SNIPER_ZOOM");
			p.sniper_zoom_hint_hud.alpha = 0;
			p.sniper_zoom_hint_hud.sort = 0.5;
			p.sniper_zoom_hint_hud.foreground = 1;
		}
		
		p.fov_snipe = 1;
	}

	was_using_ads = false;
	
	level.players[0].sniper_dvar = "cg_playerFovScale0";
	if(level.players.size == 2)
		level.players[1].sniper_dvar = "cg_playerFovScale1";

	foreach (p in level.players)
	{
		p thread monitorMagCycle();
		p thread DisableVariableScopeHudOnDeath();
	}
	
	if(!isdefined(level.variable_scope_weapons))
		level.variable_scope_weapons = [];

	match_player = undefined;
	last_match_player = undefined;
	while( 1 )
	{
		match = false;
		last_match_player = match_player;
		match_player = undefined;
		foreach( wep in level.variable_scope_weapons )
		{
			foreach( p in level.players )
			{
				if( p getcurrentweapon() == wep && IsAlive(p) )
				{
					match = true;
					match_player = p;
					break;
				}
			}
			
			if( match )
				break;
		}
				
		if( match && !match_player IsReloading() && !match_player isswitchingweapon() )
		{
			if( match_player isADS() && match_player ADSButtonPressed() )
			{
				match_player TurnOnVariableScopeHud(was_using_ads);
				
				was_using_ads = true;

				if(isdefined(level.variable_scope_shadow_center))
				{
					//find the closest override location and use it
					best_loc = undefined;
					best_dot = undefined;
					player_forward = AnglesToForward(match_player GetPlayerAngles());
					player_org = match_player.origin;
					foreach( org in level.variable_scope_shadow_center)
					{			
						to_vec = AnglesToForward(VectorToAngles(org - player_org));
						dot = VectorDot( player_forward, to_vec );
						if(!isdefined(best_loc) || dot > best_dot)
						{
							best_loc = org;
							best_dot = dot;
						}
					}
					
					if(isdefined(best_loc))
					{
						SetSavedDVar( "sm_sunShadowCenter", best_loc );
					}
				}
			}
			else if( was_using_ads )
			{
				//once we've entered the scope and turned on the hud we need to turn it off first chance we get
				was_using_ads = false;
				
				if( isdefined( match_player ) )
					match_player TurnOffVariableScopeHud();
				SetSavedDVar( "sm_sunShadowCenter", "0 0 0" );
			}
		}
		else if( was_using_ads )
		{
			//once we've entered the scope and turned on the hud we need to turn it off first chance we get
			was_using_ads = false;
			
			if(isdefined(last_match_player))
				last_match_player TurnOffVariableScopeHud();
			SetSavedDVar( "sm_sunShadowCenter", "0 0 0" );
		}
		wait(0.05);
	}
}

TurnOnVariableScopeHud( prev )
{
	//has entered ADS on the correct weapon
	self DisableOffhandWeapons();
	setsaveddvar( self.sniper_dvar, self.fov_snipe );
	//self.sniper_mag_hud.alpha = 1;
	self.sniper_zoom_hint_hud.alpha = 1;

	if( !prev )
		level notify("variable_sniper_hud_enter");	
}

TurnOffVariableScopeHud()
{
	level notify("variable_sniper_hud_exit");	
	
	self EnableOffhandWeapons();
	
	setsaveddvar( self.sniper_dvar, 1 );
//	turn this line back on to make the scope reset every time you exit it
//	self.fov_snipe = 1;
	self.sniper_zoom_hint_hud.alpha = 0;			
}

monitorMagCycle()
{
	notifyOnCommand( "mag_cycle", "+melee_zoom" );
	notifyOnCommand( "mag_cycle", "+sprint_zoom" );
	
	while(1)
	{
		self waittill( "mag_cycle" );
		
		if(self.sniper_zoom_hint_hud.alpha) //dont change the zoom unless we're in the view
		{
			//1 , 0.5
			assert(self.fov_snipe == 0.5 || self.fov_snipe == 1);
			if(self.fov_snipe == 0.5)
				self.fov_snipe = 1;
			else
				self.fov_snipe = 0.5;
		}
	}
}


DisableVariableScopeHudOnDeath()
{
	self waittill("death");

	self TurnOffVariableScopeHud();
}

/*
=============
///ScriptDocBegin
"Name: dialogue_reminder( <character>, <while_flag>, <lines>, [min_delay], [max_delay] )"
"Summary: This function will perdiodically play reminder dialog while the <while_flag> is not true (IE - a nag if the player takes too long to do his current objective).  Lines are chosen randomly from <lines>.  Lines will not play twice in a row.  Random wait between [delay_min] and [delay_max] between lines.  "
"CallOn: Nothing"
"MandatoryArg: <character>: The name of the character to play the lines.  If "radio" is passed in as <character> the line is played with radio_dialogue rather than dialogue_queue"
"MandatoryArg: <while_flag>: Reminder dialog will continue to play until this flag is set to true."
"MandatoryArg: <lines>: an array of lines to choose from.  No lines will repeat back to back"
"OptionalArg: [delay_min]: Min delay to wait between lines - defaults to 10"
"OptionalArg: [delay_max]: Max delay to wait between lines - defaults to 20"
"Example: dialogue_reminder ( level.sandman, "bomb_planted", lines, 10, 20 ); "
"Module: Dialogue"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
dialogue_reminder ( character, while_flag, lines, delay_min, delay_max )
{
	level endon ( "stop_reminders" );
	level endon ( "missionfailed" );
	//assertex ( ( isdefined ( character ) ) && ( isai ( character ) ), "Character is not properly defined" );
	//assertex ( ( isdefined ( lines ) && isarray ( lines ) ), "Lines is undefined, or is not an array" );
	last_line = undefined;
	if ( !isdefined ( delay_min ) )
		delay_min = 10;
	if ( !isdefined ( delay_max ) )
		delay_max = 20;
		
	while (!flag ( while_flag ) )
	{
		rand_delay = RandomfloatRange ( delay_min, delay_max );
		rand_line = random ( lines );
		
		if ( isdefined ( last_line ) && rand_line == last_line )
			continue;
		else
		{
			last_line = rand_line;
			wait rand_delay;
			
			if ( !flag ( while_flag ) ) 
			{
				if ( IsString ( character ) && character == "radio" )
				{
					conversation_start();
					radio_dialogue ( rand_line );
					conversation_stop();
				}					
				else 
				{
					conversation_start();
					character dialogue_queue ( rand_line );
					conversation_stop();
				}
			}
			
		}
		
	}
	
}


/*
=============
///ScriptDocBegin
"Name: conversation_start()"
"Summary: Call this when you're just about to start several consecutive dialogue lines.  Other conversations using conversation_start will be blocked until it finishes"
"CallOn: Nothing"
"Example: conversation_start()"
"Module: Dialogue"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
conversation_start()
{
	if (!flag_exist("flag_conversation_in_progress"))
	{
		flag_init("flag_conversation_in_progress");
	}
	/#
	if(flag("flag_conversation_in_progress"))
	{
		if(GetDebugDvarInt("developer") != 0)
	{
		IPrintLn("conversation_start(): conversation is being delayed by another conversation.");	
	}	
	}
	#/
	
	flag_waitopen("flag_conversation_in_progress");
	flag_set("flag_conversation_in_progress");
	
	/#
	thread conversation_debug_timeout();
	#/
}

/*
=============
///ScriptDocBegin
"Name: conversation_stop()"
"Summary: Call after conversation_start() to signal that other conversations can begin"
"CallOn: Nothing"
"Example: conversation_stop()"
"Module: Dialogue"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
conversation_stop()
{
	flag_clear("flag_conversation_in_progress");	
}

/#
conversation_debug_timeout()
{
	start_timescale = Float( GetDebugDvar( "timescale" ) );
	timeout = 60 * start_timescale;
	flag_waitopen_or_timeout("flag_conversation_in_progress", timeout);
	if(flag("flag_conversation_in_progress"))
	{
		// don't assert if you're in slowmo/fastforward; or if you changed the timescale since calling it.
		//   still doesn't catch all cases, but helps
		debug_timescale = Float( GetDebugDvar( "timescale" ) );
		if ( debug_timescale == 1 && start_timescale == debug_timescale )
		{
			AssertEx(false, "A conversation lasted > 60 seconds, and other dialogue might be waiting.  Possible misplaced conversation_begin()?");	
		}
	}
}
#/

 /* 
 ============= 
///ScriptDocBegin
"Name: array_combine_unique( <array1> , <array2> )"
"Summary: Combines the two arrays and returns the resulting array. This function doesn't duplicate any entries."
"Module: Array"
"CallOn: "
"MandatoryArg: <array1> : first array"
"MandatoryArg: <array2> : second array"
"Example: combinedArray = array_combine_unique( array1, array2 );"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 
array_combine_unique( array1, array2 )
{
	array3 = [];
	foreach ( item in array1 )
	{
		if (!isdefined(array_find(array3, item)))
			array3[ array3.size ] = item;
	}
	foreach ( item in array2 )
	{
		if (!isdefined(array_find(array3, item)))
			array3[ array3.size ] = item;
	}
	return array3;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///laser designator
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

laser_targeting_device( player )
{
	player endon( "remove_laser_targeting_device" );
	
	player.lastUsedWeapon = undefined;
	
	assert(!isdefined(player.laserForceOn));
	player.laserForceOn = false;
	player setWeaponHudIconOverride( "actionslot4", "dpad_laser_designator" );
	player thread CleanUpLaserTargetingDevice();
	
	player notifyOnPlayerCommand( "use_laser", "+actionslot 4" );
	player notifyOnPlayerCommand( "fired_laser", "+attack" );
	player notifyOnPlayerCommand( "fired_laser", "+attack_akimbo_accessible" );	// support accessibility control scheme
	
	player.laserAllowed = true;
	player.laserCoolDownAfterHit = 20;
	
	player childthread monitorLaserOff();

	for ( ;; )
	{
		player waittill( "use_laser" );
		
		if ( player.laserForceOn || !player.laserAllowed || player ShouldForceDisableLaser())
		{
			player notify( "cancel_laser" );
			player laserForceOff();
			player.laserForceOn = false;
			player AllowADS( true );
			wait 0.2;
			player allowFire( true );			
		}
		else
		{
			player laserForceOn();
			player allowFire( false );
			player.laserForceOn = true;		
			player AllowADS( false );
			player thread laser_designate_target();
		}
	}
}

ShouldForceDisableLaser()
{
	weap = self GetCurrentWeapon();
	if(weap == "rpg")
		return true;
	if(string_starts_with(weap, "gl"))
		return true;
	if(isdefined(level.laser_designator_disable_list) && isarray(level.laser_designator_disable_list))
	{
		foreach( w in level.laser_designator_disable_list)
			if(weap == w)
				return true;
	}
	
	if( self IsReloading() )
	{
		return true;
	}
	
	if( self IsThrowingGrenade() )
	{
		return true;
	}
	
	return false;
}

CleanUpLaserTargetingDevice()
{
	self waittill( "remove_laser_targeting_device" );
	self setWeaponHudIconOverride( "actionslot4", "none" );
	
	//force shut down the laser if on when we turn the system off
	self notify( "cancel_laser" );
	self laserForceOff();
	self.laserForceOn = undefined;
	self allowFire( true );
	self AllowADS( true );
}

monitorLaserOff()
{
	while(1)
	{
		if(ShouldForceDisableLaser() && isdefined(self.laserForceOn) && self.laserForceOn)
		{
			self notify( "use_laser" );
			wait(2.0);
		}
		wait(0.05);
	}
}

laser_designate_target()
{
	self endon( "cancel_laser" );
	
	while(1)
	{
		self waittill( "fired_laser" );
	
		trace = self get_laser_designated_trace();
		viewpoint = trace[ "position" ];
		entity = trace[ "entity" ];
		
		level notify( "laser_coordinates_received" );
			
		// Check if we are supposed to be targeting for artillery now
		laser_target = undefined;
		
		if(isdefined(level.laser_targets) && isdefined(entity) && array_contains(level.laser_targets, entity))
		{
				laser_target = entity;
				level.laser_targets = array_remove(level.laser_targets, entity);
		}
		else
		{
			laser_target = GetTargetTriggerHit(viewpoint);
		}
		
		if ( isdefined( laser_target ) )
		{
			thread laser_artillery( laser_target );
				
			//play a rumble for feedback here?
			
			//notify level that target has been painted to remove objective dots.
			level notify("laser_target_painted");
			
			//add a delay to prevent the gun from firing
			wait(0.5);
			// take away laser on a hit
			self notify( "use_laser" );		
		}
	}
}

GetTargetTriggerHit(viewpoint)
{
	if(!isdefined(level.laser_triggers) || level.laser_triggers.size == 0)
		return undefined;
	foreach( trigger in level.laser_triggers)
	{
		d = distance2d( viewpoint, trigger.origin );
		h = viewpoint[2] - trigger.origin[2];
		if(!isdefined(trigger.radius))
			continue;
		if(!isdefined(trigger.height))
			continue;
		if ( d <= trigger.radius && h <= trigger.height && h >= 0)
		{
			level.laser_triggers = array_remove(level.laser_triggers, trigger);
			return getent(trigger.target, "script_noteworthy");
		}
	}
	return undefined;
}

get_laser_designated_trace()
{
	eye = self geteye();
	angles = self getplayerangles();
	
	forward = anglestoforward( angles );
	end = eye + ( forward * 7000 );
	trace = bullettrace( eye, end, true, self );
	
	//thread draw_line_for_time( eye, end, 1, 1, 1, 10 );
	//thread draw_line_for_time( eye, trace[ "position" ], 1, 0, 0, 10 );
	
	entity = trace[ "entity" ];
	if ( isdefined( entity ) )
		trace[ "position" ] = entity.origin;
	
	return trace;
}

//add objects to the level.laser_targets list
//for triggers:
//we use trigger.target = obj.script_notworthy
//how we tag geo targetname and script_group
//explosion group should be script_index on the entity

laser_artillery(target_ent)
{
	level.player endon( "remove_laser_targeting_device" );//so we can disable laser during cool down.
	level.player.laserAllowed = false;
	self setWeaponHudIconOverride( "actionslot4", "dpad_killstreak_hellfire_missile_inactive" );
	flavorbursts_off( "allies" );
	
	soundEnt = level.player;
	
	wait 2.5;
	
	//assert is commented out until we get the data updated
	if(!isdefined(target_ent.script_index))
		target_ent.script_index = 99;

	wait 1;
	
	// swap the geo
	if(isdefined(target_ent.script_group))
	{
		before = get_geo_group( "geo_before", target_ent.script_group );
		if( before.size > 0 )
			array_call( before, ::hide );
			
		after = get_geo_group( "geo_after", target_ent.script_group );
		if( after.size > 0 )
			array_call( after, ::show );
	}
	
	//laser cooldown
	wait(level.player.laserCoolDownAfterHit);
	level.player.laserAllowed = true;
	self setWeaponHudIconOverride( "actionslot4", "dpad_laser_designator" );
}

get_geo_group( targetname, groupNum )
{
	ents = getentarray( targetname, "targetname" );
	returnedEnts = [];
	foreach( ent in ents )
	{
		if ( isdefined(ent.script_group) && ent.script_group == groupNum )
			returnedEnts[ returnedEnts.size ] = ent;
	}
	return returnedEnts;
}

/* 
 ============= 
///ScriptDocBegin
"Name: update_weapon_tag_visibility()"
"Summary: Make sure to hide all the correct tags on a weapon"
"Module: SP"
"CallOn: the object whos weapon needs to be updated"
"MandatoryArg: <weapon> : the weapon we're updating"
"OptionalArg: <weapon_model_override> : if youre using a _obj model you should pass in the real model name"
"Example: level.sandman update_weapon_tag_visibility( self.primaryweapon )"
"Module: Utility (SHG)"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
update_weapon_tag_visibility( weapon, weapon_model_override )
{
	if( isdefined( weapon ) && weapon != "none")
	{
		hideTagList = GetWeaponHideTags( weapon );
		assert( isdefined( hideTagList ) );
		
		variant = 0;
		weapon_model = getWeaponModel( weapon, variant );
		if( isdefined( weapon_model_override ) )
			weapon_model = weapon_model_override;
		
		assert( isdefined( weapon_model ) );
		
		for ( i = 0; i < hideTagList.size; i++ )
		{
			self HidePart( hideTagList[ i ], weapon_model );
		}
	}	
}

/* 
 ============= 
///ScriptDocBegin
"Name: linear_map(<x>, <in_a>, <in_b>, <out_a>, <out_b>)"
"Summary: Returns <x>, linearly mapped such that <in_a> maps to <out_a>, <in_b> maps to <out_b>, and other values are interpolated."
"MandatoryArg: <x> : the input value, a float or int"
"MandatoryArg: <in_a> : one endpoint of the input range.  If x == in_a, the return value will be out_a"
"MandatoryArg: <in_b> : one endpoint of the input range.  If x == in_b, the return value will be out_b"
"MandatoryArg: <out_a> : one endpoint of the output range"
"MandatoryArg: <out_b> : one endpoint of the output range"
"Example: degrees_c = linear_map(degrees_f, 32, 212, 0, 100);"
"Module: Utility (SHG)"
"SPMP: both"
///ScriptDocEnd
 ============= 
*/
linear_map(x, in_a, in_b, out_a, out_b)
{
	AssertEx(in_b - in_a != 0, "input range must have nonzero length");
	return out_a + (x - in_a) * (out_b - out_a) / (in_b - in_a);
}

/* 
 ============= 
///ScriptDocBegin
"Name: linear_map_clamp(<x>, <in_a>, <in_b>, <out_a>, <out_b>)"
"Summary: Returns <x>, linearly mapped such that <in_a> maps to <out_a>, <in_b> maps to <out_b>, and other values are interpolated.  Will never return a value outside the range specified by <out_a> and <out_b> (inclusive)."
"MandatoryArg: <x> : the input value, a float or int"
"MandatoryArg: <in_a> : one endpoint of the input range.  If x == in_a, the return value will be out_a"
"MandatoryArg: <in_b> : one endpoint of the input range.  If x == in_b, the return value will be out_b"
"MandatoryArg: <out_a> : one endpoint of the output range"
"MandatoryArg: <out_b> : one endpoint of the output range"
"Example: damage = linear_map(distance, 0, max_dist, max_damage, 0);"
"Module: Utility (SHG)"
"SPMP: both"
///ScriptDocEnd
 ============= 
*/
linear_map_clamp(x, in_a, in_b, out_a, out_b)
{
	return clamp(linear_map(x, in_a, in_b, out_a, out_b), min(out_a, out_b), max(out_a, out_b));
}


differentiate_motion()
{
	time = GetTime() * .001;
	
	if(!IsDefined(self.differentiated_last_update))
	{
		self.differentiated_last_update = time;
		self.differentiated_last_origin = self.origin;
		self.differentiated_last_velocity = (0, 0, 0);
		self.differentiated_last_acceleration = (0, 0, 0);
		self.differentiated_jerk = (0, 0, 0);
		self.differentiated_acceleration = (0, 0, 0);
		self.differentiated_velocity = (0, 0, 0);
		self.differentiated_speed = 0;		
	}
	else if(self.differentiated_last_update != time)
	{	
		dt = time - self.differentiated_last_update;
		self.differentiated_last_update = time;
		self.differentiated_jerk = (self.differentiated_acceleration - self.differentiated_last_acceleration) / dt;
		self.differentiated_last_acceleration = self.differentiated_acceleration;		
		self.differentiated_acceleration = (self.differentiated_velocity - self.differentiated_last_velocity) / dt;
		self.differentiated_last_velocity = self.differentiated_velocity;
		self.differentiated_velocity = (self.origin - self.differentiated_last_origin) / dt;
		self.differentiated_last_origin = self.origin;
		self.differentiated_speed = Length(self.differentiated_velocity);
	}
}

/* 
 ============= 
///ScriptDocBegin
"Name: get_differentiated_speed()"
"Summary: returns any entity's speed (a float), based on current and previous positions.  Units are inches / second."
"Example: speed = guy get_differentiated_speed();"
"Module: Utility (SHG)"
"Note: for best accuracy, you should call this once per frame."
"SPMP: both"
///ScriptDocEnd
 ============= 
*/
get_differentiated_speed()
{
	self differentiate_motion();
	return self.differentiated_speed;	
}

/* 
 ============= 
///ScriptDocBegin
"Name: get_differentiated_velocity()"
"Summary: returns any entity's velocity (a vector), based on current and previous positions.  Units are inches / second."
"Example: velocity = guy get_differentiated_velocity();"
"Module: Utility (SHG)"
"Note: for best accuracy, you should call this once per frame."
"SPMP: both"
///ScriptDocEnd
 ============= 
*/
get_differentiated_velocity()
{
	self differentiate_motion();
	return self.differentiated_velocity;	
}

/* 
 ============= 
///ScriptDocBegin
"Name: get_differentiated_acceleration()"
"Summary: returns any entity's acceleration (a vector), based on current and previous positions.  Units are inches / second^2"
"Example: acceleration = guy get_differentiated_acceleration();"
"Module: Utility (SHG)"
"Note: for best accuracy, you should call this once per frame."
"SPMP: both"
///ScriptDocEnd
 ============= 
*/
get_differentiated_acceleration()
{
	self differentiate_motion();
	return self.differentiated_acceleration;	
}

/* 
 ============= 
///ScriptDocBegin
"Name: get_differentiated_jerk()"
"Summary: returns any entity's jerk (a vector, the derivative of acceleration), based on current and previous positions.  Units are inches / second^3."
"Example: jerk = guy get_differentiated_jerk();"
"Module: Utility (SHG)"
"Note: for best accuracy, you should call this once per frame."
"SPMP: both"
///ScriptDocEnd
 ============= 
*/
get_differentiated_jerk()
{
	self differentiate_motion();
	return self.differentiated_jerk;	
}


show_player_hud()
{
	SetSavedDvar( "g_friendlyNameDist", 15000 );
	SetSavedDvar( "compass", "1" );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "actionSlotsHide", "0" );
	SetSavedDvar( "hud_showStance", "1");
	
	waitframe();
	
	LUINotifyEvent( &"init_hud", 0 );
}


hide_player_hud()
{
	SetSavedDvar( "g_friendlyNameDist", 0 );
	SetSavedDvar( "compass", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "actionSlotsHide", "1" );
	SetSavedDvar( "hud_showStance", "0");
	
	waitframe();
	
	LUINotifyEvent( &"close_hud", 0 );
}

/* 
 ============= 
///ScriptDocBegin
"Name: handle_portal_group( <script_flag>, <portal_group>, <ender> )"
"Summary: Swaps a portal_group on and off based on the state of a script flag."
"MandatoryArg: <script_flag> : the script flag to check to trigger portal_group back and forth"
"MandatoryArg: <portal_group> : the targetname or script_noteworthy of the portal_group entity from radiant to swap"
"OptionalArg: <ender> : an additional endon to allow users to endon something other than player death or mission failure"
"Example: handle_portal_group ( "portal_group1", "portal_group1", "objective1_complete" );"
"Module: Utility (SHG)"
"Note: Use with a trigger_multiple_flag_set_touching in radiant"
"SPMP: SP"
///ScriptDocEnd
 ============= 
*/
handle_portal_group ( script_flag, portal_group, ender )
{
	level.player endon ( "death" );
	level endon ( "missionfailed" );
	if ( isdefined ( ender ) && isstring ( ender ) )
		level endon ( ender );
	
	AssertEx ( isdefined ( script_flag ) && isstring ( script_flag ), "Tried to call handle_portal_group without passing in a valid script flag" );
	
	if ( !isdefined ( script_flag ) || !isstring ( script_flag ) )
		return;
	
	AssertEx ( flag_exist ( script_flag ), "Tried to call handle_portal_group without passing in a valid script flag" );
	AssertEx ( isdefined ( portal_group ) && isstring ( portal_group ), "You either didn't pass in a portal_group, or it wasn't a string" );
	
	if ( !isdefined ( portal_group ) || !isstring ( portal_group ) || !flag_exist ( script_flag ) )
		return;
	
	//get portal group, first try targetname, then try noteworthy
	pGroup = getent ( portal_group, "targetname" );
	if ( !isdefined ( pGroup ) )
		pGroup = getent ( portal_group, "script_noteworthy" );
	
	AssertEx ( isdefined ( pGroup ), "Tried to find a portal group with targetname or script_noteworthy of '" + portal_group + "', but none was found" );

	if ( !isdefined ( pGroup ) )
		return;
	
	//set the initial state
	pGroup EnablePortalGroup ( false );
	
	while ( true )
	{
		flag_wait ( script_flag );
		
		//flag becomes true, swap the portal groups
		pGroup EnablePortalGroup ( true );
		
		flag_waitopen ( script_flag );
		
		//flag becomes false again, swap the portals back
		pGroup EnablePortalGroup ( false );
		
		wait 0.05;
		
	}
	
}

// make entity vulnerable to an EMP variable grenade
make_emp_vulnerable()
{
	if( !IsDefined( level.emp_vulnerable_list ) )
		level.emp_vulnerable_list = [];
	
	level.emp_vulnerable_list = array_add( level.emp_vulnerable_list, self );
	
	self waittill( "death" );
	
	level.emp_vulnerable_list = array_remove( level.emp_vulnerable_list, self );
}