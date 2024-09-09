#include common_scripts\utility;
#include maps\_utility;

// just for godon for now
#include maps\_vehicle;

initialize()
{
	SetSavedDvar( "vehHelicopterControlsAltitude", 1 );
	
	PreCacheModel( "tag_laser" );
	PreCacheItem( "pdrone_weapon" );
	PreCacheItem( "pdrone_weapon_bullet" );
	PreCacheShader( "dpad_killstreak_remote_uav" );
	PreCacheShader( "dpad_laser_designator" );
}

give_player_pdrone( vehicle_pdrone_spawner )
{
	self.pdroneActive = false;
	self.pdroneReturning = false;
	
	self setWeaponHudIconOverride( "actionslot4", "dpad_killstreak_remote_uav" );
	self NotifyOnPlayerCommand( "use_pdrone", "+actionslot 4" );
	
	//thread pd_laser_targeting_device( self ); // Not using laser for slice, commenting out for now
	
	for( ;; )
	{
		self waittill( "use_pdrone" );
		
		if ( self IsThrowingGrenade() )
			continue;
		
		if ( !self.pdroneActive )
		{
			self AllowFire( false );
				
			current_weapon = self GetCurrentPrimaryWeapon();
			self TakeWeapon( current_weapon );

			self GiveWeapon( "pdrone_weapon_bullet" );
			self SwitchToWeaponImmediate( "pdrone_weapon_bullet" );
			self GiveMaxAmmo( "pdrone_weapon_bullet" );
		
			self wait_til_pdrone_launched();
			self AllowFire( true );
		
			if ( IsDefined( self.pdrone_launched ) && self.pdrone_launched )
			{
				self DisableWeaponSwitch();
				self DisableOffhandWeapons();
				
				wait 1.75;
				self pdrone_launch( vehicle_pdrone_spawner );
				self.pdrone_launched = undefined;
				
				wait 0.25;
				
				self EnableOffhandWeapons();
				self EnableWeaponSwitch();
			}

			self TakeWeapon( "pdrone_weapon_bullet" );
			self GiveWeapon( current_weapon );
			self SwitchToWeaponImmediate( current_weapon );
		}
		else
		{
			self pdrone_return();
		}
	}
}

pdrone_return()
{
	player = self;
	pdrone = player.pdrone;
	
	pdrone ent_flag_clear( "sentient_controlled" );
	player notify( "pdrone_returning" );
	
	pdrone thread pdrone_return_pathing();
	
	pdrone waittill( "goal" );
	pdrone delete();
	player notify( "pdrone_returned" );
}

pdrone_return_pathing()
{
	self endon( "goal" );
	
	self.goalradius = 40;
	self Vehicle_SetSpeed( 20, 20, 20 );
	self SetLookAtEnt( self.owner );
	
	while( 1 )
	{
		self SetVehGoalPos( self.owner.origin + (0, 0, 84), false );
		wait 0.05;
	}
}

wait_til_pdrone_launched()
{
	self endon( "death" );
	self endon( "use_pdrone" );
	self endon( "weapon_switch_started" );
	
	self notifyOnPlayerCommand( "launch_pdrone", "+attack" );
	
	self waittill( "launch_pdrone" );
	self.pdrone_launched = true;
}

pdrone_launch( vehicle_pdrone_spawner )
{	
	self.pdroneActive = true;
	
	pdrone = self spawn_pdrone( vehicle_pdrone_spawner );
	if ( IsDefined( pdrone ) )
	{
		pdrone MakeEntitySentient( "allies" );
		pdrone.pov_mode = 0;
		pdrone.owner = self;
		pdrone godon();
		
		self.pdrone = pdrone;
		self notify( "pdrone_launched" );
		
		self.pdrone = pdrone;
		pdrone thread pdrone_monitor_death();
	}
}

spawn_pdrone( vehicle_pdrone_spawner )
{
	while ( IsDefined( vehicle_pdrone_spawner.available ) && !vehicle_pdrone_spawner.available )
	{
		wait 0.05;
	}
	
	if ( !IsDefined( self ) )
	{
		return undefined;
	}
	
	vehicle_pdrone_spawner.available = false;
	vehicle_pdrone_spawner.script_team = self.team;
	
	if( IsPlayer( self ) )
	{
		angles = self GetPlayerAngles();
	}
	else
	{
		angles = self.angles;
	}
	forward = AnglesToForward( angles );
	up = AnglesToUp( angles );
	pdrone_spawn_offset = ( forward * 24 ) + ( up * 100 );
	if ( pdrone_spawn_offset[2] < 80 )
	{
		pdrone_spawn_offset = pdrone_spawn_offset + ( 0, 0, (80 - pdrone_spawn_offset[2]) );
	}
	
	vehicle_pdrone_spawner.origin = self.origin + pdrone_spawn_offset;
	vehicle_pdrone_spawner.angles = self.angles;
	
	waittillframeend;
	vehicle_pdrone_spawner.available = true;
	
	if( IsDefined( self ) && IsAlive( self ) )
	{
		return vehicle_pdrone_spawner spawn_vehicle();
	}
	else
	{
		return undefined;
	}
}

pdrone_monitor_death()
{
	self waittill( "death" );
	
	if( IsDefined( self ) )
	{
		if( IsDefined( self.owner ) )
		{
			self.owner.pdroneActive = false;
		}
	}
}

/////////////////////////////////////
//		Lasing Targets Logic
/////////////////////////////////////

pd_laser_targeting_device( player )
{
	player endon( "remove_laser_targeting_device" );
	
	player.lastUsedWeapon = undefined;
	player.laserForceOn = false;
	player setWeaponHudIconOverride( "actionslot4", "dpad_laser_designator" );
	
	player notifyOnPlayerCommand( "use_laser", "+actionslot 4" );
	player notifyOnPlayerCommand( "fired_laser", "+attack" );
	
	player childthread pd_monitorLaserOff();
	
	for ( ;; )
	{
		player waittill( "use_laser" );
		
		if ( player.laserForceOn || player pd_ShouldForceDisableLaser() )
		{
			player notify( "cancel_laser" );
			player laserForceOff();
			player.laserForceOn = false;
			wait 0.2;
			player allowFire( true );
		}
		else
		{
			player laserForceOn();
			player allowFire( false );
			player.laserForceOn = true;		
			player thread pd_laser_designate_target();
		}
		
		wait 0.05;
	}
}

pd_ShouldForceDisableLaser()
{
	weap = self GetCurrentWeapon();
	if(weap == "rpg")
		return true;
	if(weap == "c4")
		return true;
	if(string_starts_with(weap, "gl"))
		return true;
	//if(weap == "pdrone_weapon" )
	if(weap == "pdrone_weapon_bullet" )
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

pd_monitorLaserOff()
{
	while(1)
	{
		if(pd_ShouldForceDisableLaser() && isdefined(self.laserForceOn) && self.laserForceOn)
		{
			self notify( "use_laser" );
			wait(2.0);
		}
		wait(0.05);
	}
}

pd_laser_designate_target()
{
	self endon( "cancel_laser" );
	
	self waittill( "fired_laser" );
	
	trace = self pd_get_laser_designated_trace();
	viewpoint = trace[ "position" ];
	entity = trace[ "entity" ];
	
	if( Distance( self.origin, viewpoint ) < 100000 )
	{
		self notify( "pdrone_defend_point", trace );
	}
	else
	{
		iprintln( "too far" );
	}
	
//	/#
//	if ( getdvar( "debug_abrams" ) == "1" )
		//thread draw_line_for_time( viewpoint, viewpoint + ( 0, 0, 100 ), 1, 0, 0, 20 );
//	#/
	
		// check if target is in range
		
	
	wait 0.05;
	
	// take away laser
	self notify( "use_laser" );
}

pd_get_laser_designated_trace()
{
	eye = self geteye();
	angles = self getplayerangles();
	
	forward = anglestoforward( angles );
	end = eye + ( forward * 7000 );
	trace = bullettrace( eye, end, false, self );
	
	//thread draw_line_for_time( eye, end, 1, 1, 1, 10 );
	//thread draw_line_for_time( eye, trace[ "position" ], 1, 0, 0, 10 );
	
	entity = trace[ "entity" ];
	if ( isdefined( entity ) )
		trace[ "position" ] = entity.origin;
	
	return trace;
}
