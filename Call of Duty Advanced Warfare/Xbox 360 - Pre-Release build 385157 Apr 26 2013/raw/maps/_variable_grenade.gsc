#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include soundscripts\_snd;

main()
{
	//grenade types:	
	variable_grenade["normal"][0] = "frag_grenade_var";
	variable_grenade["normal"][1] = "contact_grenade_var";
	variable_grenade["normal"][2] = "semtex_grenade_var";
	
	variable_grenade["special"][0] = "flash_grenade_var";
	variable_grenade["special"][1] = "emp_grenade_var";
	variable_grenade["special"][2] = "paint_grenade_var";
	level.player.variable_grenade = variable_grenade;
	
	
	foreach( mode in ["normal", "special"] )
	{
		foreach( weapon in variable_grenade[mode] )
		{
			PreCacheItem( weapon );
		}
	}

	init_grenade_hints();
	
	precache_var_grenade_fx();
	
	need_new_offhands = false;
	foreach(offhand_weapon in level.player GetWeaponsListOffhands())
	{
		if(!IsDefined(level.player get_index_for_weapon_name(offhand_weapon)))
		{
			need_new_offhands = true;
			break;
		}
	}
	
	if(need_new_offhands)
	{
		foreach(offhand_weapon in level.player GetWeaponsListOffhands())
		{
			level.player TakeWeapon(offhand_weapon);
		}
		level.player GiveWeapon( variable_grenade["normal"][0] );
		level.player GiveWeapon( variable_grenade["special"][0] );
	}
	

	axis_spawners = GetSpawnerTeamArray( "axis" );
	if(axis_spawners.size > 0)
		array_spawn_function( axis_spawners, ::handle_detection );
	kva_drones = GetEntArray( "script_vehicle_pdrone_kva", "classname" );
	if(kva_drones.size > 0)
		array_spawn_function( kva_drones, ::handle_detection );
			
	level.player thread monitor_grenade_fire();
	level.player thread monitor_offhand_cycle();
	// /# level.player thread debug_ammo(); #/
}

/#
debug_ammo()
{
	while(true)
	{
		str = "";
		foreach(weapon in self GetWeaponsListOffhands())
		{
			str += weapon + ":" + self GetWeaponAmmoStock(weapon) + " ";
		}
		IPrintLn(str);
		
		waitframe();
	}
}
#/

get_mode_for_weapon_name(weapon_name)
{
	if(!IsDefined(weapon_name))
		return undefined;
	current_mode = undefined;
	foreach(mode in ["normal", "special"])
	{
		if(array_contains(self.variable_grenade[mode], weapon_name))
		{			  
		   current_mode = mode;
		   break;
		}
	}
	return current_mode;
}

get_index_for_weapon_name(weapon_name)
{
	mode = get_mode_for_weapon_name(weapon_name);
	if(!IsDefined(mode))
		return undefined;
	foreach(index, value in self.variable_grenade[mode])
		if(value == weapon_name)
			return index;
}


monitor_grenade_fire()
{
	Assert(IsPlayer(self));
	self endon ( "death" );
	
	while ( true )
	{
		self waittill ( "grenade_fire", grenade, weapon_name );
		
		// hide hints immediately on throwing any of the types we handle, as it will be a little while before IsThrowingGrenade() starts being false
		foreach(mode in ["normal", "special"])
			if(array_contains(self.variable_grenade[mode], weapon_name))
				hide_grenade_hints();
		
		switch(weapon_name)
		{		
			case "emp_grenade_var":
				grenade thread emp_grenade_think(self);
				break;
				
			case "paint_grenade_var":
				grenade thread detection_grenade_think(self);
				break;
				
			default:
				// the other types don't require special script
				break;
		}
	}
}

monitor_offhand_cycle()
{
	Assert(IsPlayer(self));
	self endon ( "death" );

	switch_count = 0;
	button_was_down = false;
	was_holding = false;
	last_switch_millis = 0;
	while(true)
	{	
		button_is_down = self UseButtonPressed();
		throwing = self IsThrowingGrenade();
		// it takes two frames from when we start switching until IsHoldingGrenade() goes false
		holding_grenade = self IsHoldingGrenade() && (GetTime() - last_switch_millis >= 150);
		
		if(throwing)
		{
			// make sure this is one of the grenades we're handling
			current_weapon = self GetCurrentOffhand();
			current_mode = get_mode_for_weapon_name(current_weapon);
			if(IsDefined(current_mode))
			{
				if(holding_grenade)
					show_grenade_hint(current_mode);
				
				// count button presses, and also if you're holding_grenade down the button as a switch finishes
				if((button_is_down && !button_was_down) || (button_is_down && holding_grenade && !was_holding && switch_count == 0))
					switch_count++;
				
				// in case you're spamming the button so much it would wrap, don't queue up that many switches
				switch_count = switch_count % self.variable_grenade[current_mode].size;
			
				if(holding_grenade && switch_count > 0)
				{
					switch_count--;
					last_switch_millis = GetTime();
					cycle_offhand_grenade();
				}
			}
			else
			{
				switch_count = 0;
				hide_grenade_hints();	
			}
		}
		else
		{
			switch_count = 0;
			hide_grenade_hints();
		}
			
		button_was_down = button_is_down;
		was_holding = holding_grenade;
				
		waitframe();
	}		
}

cycle_offhand_grenade()
{
	assert(IsPlayer(self));
	assert(self IsThrowingGrenade() && self IsHoldingGrenade());
	
	current_weapon = self GetCurrentOffhand();
	
	if(IsDefined(current_weapon))
	{
		current_mode = get_mode_for_weapon_name(current_weapon);
		current_index = get_index_for_weapon_name(current_weapon);
		
		if(IsDefined(current_mode) && IsDefined(current_index))
		{
			next_index = (current_index + 1) % self.variable_grenade[current_mode].size;
			handle_weapon_switch(current_mode, next_index);
			self snd_message( "variable_grenade_type_switch", next_index );
		}
		else
		{
			AssertEx(false, "called cycle_offhand_grenade() with unknown current weapon");
		}
	}
	else
	{
		AssertEx(false, "called cycle_offhand_grenade() with no current weapon");
	}
}

// switch us to the given weapon 
handle_weapon_switch( mode, index )
{
	assert( isPlayer(  self ) );
	assert( isDefined( mode ) && (mode == "normal" || mode == "special"));
	assert( isDefined( index ) );
		
	ammo_remaining = 0;
	
	foreach( weaponname in self GetWeaponsListOffhands() )
	{		
		if(array_contains(self.variable_grenade[mode], weaponname))
		{
			ammo_remaining = int(max(ammo_remaining, self GetWeaponAmmoStock(weaponname)));
			self TakeWeapon(weaponname);
		}
	}
	
	self GiveWeapon(self.variable_grenade[mode][index]);
	self SetWeaponAmmoStock(self.variable_grenade[mode][index], ammo_remaining);
}


///////////////////
//Hint Stuff
///////////////////

init_grenade_hints()
{
   	PreCacheString( &"VARIABLE_GRENADE_HINT_CYCLE_LETHAL" );
   	PreCacheString( &"VARIABLE_GRENADE_HINT_CYCLE_TACTICAL" );
   	
   	add_hint_string( "variable_grenade_hint_special", &"VARIABLE_GRENADE_HINT_CYCLE_TACTICAL", ::turn_off_cycle_hint );
   	add_hint_string( "variable_grenade_hint_normal", &"VARIABLE_GRENADE_HINT_CYCLE_LETHAL", ::turn_off_cycle_hint );	
}

show_grenade_hint(mode)
{
	if(!IsDefined(self.variable_grenade["display_hint"]) || self.variable_grenade["display_hint"] != mode)
	{
		self.variable_grenade["display_hint"] = mode;
		self thread display_hint_timeout( "variable_grenade_hint_" + mode, undefined, undefined, undefined, undefined, 158);		
	}	
}

hide_grenade_hints()
{
	self.variable_grenade["display_hint"] = undefined;
}

turn_off_cycle_hint()
{
	return !IsDefined(self.variable_grenade["display_hint"]);	
}

///////////////////
//VFX
///////////////////

precache_var_grenade_fx()
{
	//paint grenade
	level._effect[ "paint_grenade" ]		= LoadFX( "vfx/explosion/paint_grenade" );
	level._effect[ "emp_grenade" ]			= LoadFX( "vfx/explosion/emp_grenade_explosion" );
	
	level._effect[ "skel_main" ]			= LoadFX( "fx/test/test_glow_drone_skel_pelvis" );
	level._effect[ "skel_elbow_le" ]		= LoadFX( "fx/test/test_glow_drone_skel_elbow_le" );
	level._effect[ "skel_elbow_ri" ]		= LoadFX( "fx/test/test_glow_drone_skel_elbow_ri" );
	level._effect[ "skel_head" ]			= LoadFX( "fx/test/test_glow_drone_skel_head" );
	level._effect[ "skel_leg_le" ]			= LoadFX( "fx/test/test_glow_drone_skel_leg_le" );
	level._effect[ "skel_leg_ri" ]			= LoadFX( "fx/test/test_glow_drone_skel_leg_ri" );
	
	level._effect[ "skel_main_fade" ]		= LoadFX( "fx/test/test_glow_drone_skel_pelvis_fade" );
	level._effect[ "skel_elbow_le_fade" ]	= LoadFX( "fx/test/test_glow_drone_skel_elbow_le_fade" );
	level._effect[ "skel_elbow_ri_fade" ]	= LoadFX( "fx/test/test_glow_drone_skel_elbow_ri_fade" );
	level._effect[ "skel_head_fade" ]		= LoadFX( "fx/test/test_glow_drone_skel_head_fade" );
	level._effect[ "skel_leg_le_fade" ]		= LoadFX( "fx/test/test_glow_drone_skel_leg_le_fade" );
	level._effect[ "skel_leg_ri_fade" ]		= LoadFX( "fx/test/test_glow_drone_skel_leg_ri_fade" );
}

///////////////////
//EMP Grenade
///////////////////

emp_grenade_think( attacker )
{
	self endon( "death" );
	
	wait 1;
	rad = 500;
	org = self.origin;
	dmg = 500;
	
	PlayFX( getfx( "emp_grenade" ), org );
	self snd_message( "emp_grenade_detonate" );
	
	if( !IsDefined( level.emp_vulnerable_list ) )
	{
		self delete();
	 	return;
	}
	
	targets = level.emp_vulnerable_list;
	
	foreach( thing in targets )
	{
		if ( !IsDefined( thing ) )
		{
			continue;
		}
		
		if(	thing DamageConeTrace( org, self ) )
		{
			if( DistanceSquared( thing.origin, org ) < (rad * rad) )
			{
				if( IsDefined( thing.emp_death_function ) )
					thing thread [[ thing.emp_death_function ]]();
				else
					thing DoDamage( dmg, org, attacker );
				
				//thing DoDamage( dmg, org, attacker );
				//thing
			}
		}
	}
	
	self delete();
}


///////////////////
//Paint grenade
///////////////////

DETECTION_GRENADE_RANGE = 1000;
DETECTION_GRENADE_SWEEP_TIME = 1.75;
DETECTION_GRENADE_DURATION = 10;
STENCILREF_DEFAULT = 8;
STENCILREF_MARKED = 9;

detection_grenade_think( player )
{
	assert( !IsDefined( player ) || IsPlayer( player ) );
	assert( isDefined( self ) );
	self endon ( "death" );
	
	wait( 1 );
	
	if ( IsDefined ( player ) )
	{
		thread detection_grenade_hud_effect( player );
		thread detection_highlight_hud_effect( player );
	}
	
	PlayFX( GetFx( "paint_grenade" ), self.origin );

	self snd_message("paint_grenade_detonate");

	enemies = GetAIArray( "axis" );
	enemies = array_combine( enemies, GetEntArray( "script_vehicle_pdrone_kva", "classname" ) );
	
	foreach( guy in enemies )
	{
		if( !IsDefined( guy ) )
			continue;
		else if( !IsAlive( guy ) ) //guy dead or a pdrone
		{
			if( !guy isPdrone() ) //guy not a pdrone
			{
				continue;
			}
		}
		//if(	guy DamageConeTrace( self.origin, self ) )
		//{
			if( Distance( guy.origin, self.origin ) < DETECTION_GRENADE_RANGE )
			{
				delay = Distance(guy.origin, self.origin) * DETECTION_GRENADE_SWEEP_TIME / DETECTION_GRENADE_RANGE;
				guy delayThread(delay, ::handle_marking_guy, "grenade", DETECTION_GRENADE_DURATION - delay);
			}
		//}
	}

	self delete();
}

detection_highlight_hud_effect( player )
{
	Assert( IsDefined( player ) );
	
	radar_highlight = NewClientHudElem( player );

	radar_highlight.color = (1, 0.05, 0.025);
	radar_highlight.alpha = 0.1;
	
	duration = DETECTION_GRENADE_DURATION;
	radar_highlight SetRadarHighlight( duration );
	wait duration;
	radar_highlight Destroy();
}

detection_grenade_hud_effect( player )
{
	Assert( IsDefined( player ) );
	
	radar_ping = NewClientHudElem( player );

	radar_ping.x = self.origin[0];
	radar_ping.y = self.origin[1];
	radar_ping.z = self.origin[2];
			
	radar_ping.color = (1, 0.05, 0.025);
	radar_ping.alpha = 0.1;
	
	duration = DETECTION_GRENADE_SWEEP_TIME;
	radius = DETECTION_GRENADE_RANGE;
	width = 500;
	// doubling radius and duration so we have no chance of it cycling
	radar_ping SetRadarPing(int(radius + width / 2), int(width), duration + .05);
	// /# IPrintLn("PING"); #/
	wait duration;
	// /# IPrintLn("PONG"); #/
	radar_ping Destroy();
}

handle_detection()
{
	self notify( "handle_detection" );
	self endon( "handle_detection" );
	self endon( "death" );
	
	self thread handle_detection_death();
	
	self.detected = [];
	old_ragdoll = self.noragdoll;
	
	self unmark_guy_fx();
	
	while( 1 )
	{
		self waittill( "detected" );
		
		detection_count = 0;
		
		foreach( method in self.detected )
		{
			if( method )
				detection_count++;
		}
		
		//guy is newly detected.  Start FX
		if( detection_count == 1 )
		{
			old_ragdoll = self.noragdoll;
			self.noragdoll = true;
			
			self mark_guy_fx();
		}
		
		still_detected = true;
		while( still_detected )
		{
			self waittill( "no_longer_detected" );
			still_detected = false;
			
			if( self.detected.size == 0 )
			{
				self unmark_guy_fx();
				self.mark_fx = undefined;
				self.noragdoll = old_ragdoll;
			}
			else
			{
				still_detected = true;
			}
		}
		
	}
}

handle_marking_guy( method, delay )
{
	self endon( "death" );
	self notify( "marking_" + method );
	self endon( "marking_" + method );
	
	self.detected[ method ] = true;
	self notify( "detected" );
	
	if( IsDefined( delay ) )
	{
		wait delay;	
		unmark_guy( method );
	}
}


unmark_guy( method )
{
	self.detected[ method ] = undefined;
	self notify( "no_longer_detected" );
}

setStencilOverride( stencilRef )
{
	self ClearStencilStateOverride();
	self SetStencilStateOverride( "stencil_onesided", "stencilfunc_always", "stencilop_keep", "stencilop_replace", "stencilop_replace", "stencilop_always", "stencilop_keep", "stencilop_keep", "stencilop_keep", stencilRef );	
}

mark_guy_fx()
{
	self endon( "death" );
	
	self.pdrone_marked_state = "marked";
	self setStencilOverride( STENCILREF_MARKED );	
}

unmark_guy_fx()
{	
	if ( IsDefined( self ) && IsAlive( self ) )
	{
		// can mark again now
		self.pdrone_marked_state = undefined;
		self setStencilOverride( STENCILREF_DEFAULT );
	}
}

clear_guy_fx()
{
	if ( IsDefined( self ) )
	{
		self ClearStencilStateOverride();
	}
}

handle_detection_death()
{
	self waittill_any( "death", "emp_death" );
	
	pdrone_marked_state = undefined;
	if ( IsDefined( self ) )
	{
		pdrone_marked_state = self.pdrone_marked_state;
	}
	
	wait 1;
	
	if ( IsDefined( pdrone_marked_state ) )
	{
		clear_guy_fx();
	}
}


isPdrone()
{
	return (self.classname == "script_vehicle_pdrone_kva");
}
