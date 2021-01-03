#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_aquifer_fx;
#using scripts\cp\cp_mi_cairo_aquifer_sound;
#using scripts\shared\vehicle_shared;
#using scripts\cp\_vehicle;
#using scripts\shared\turret_shared;
#using scripts\shared\flag_shared;




#precache( "string", "CP_MI_CAIRO_AQUIFER_VTOL_LAUNCH_HINT" );
#precache( "string", "CP_MI_CAIRO_AQUIFER_VTOL_DROP_HINT" );
#precache( "string", "CP_MI_CAIRO_AQUIFER_VTOL_USE_HINT" );
#precache( "string", "CP_MI_CAIRO_AQUIFER_VTOL_GUNS" );
#precache( "string", "CP_MI_CAIRO_AQUIFER_VTOL_MISSILES" );
#precache( "string", "CP_MI_CAIRO_AQUIFER_VTOL_WEAPON_SWITCH_BUTTON" );

#precache( "lui_menu_data", "vehicle.weaponIndex" );
#precache( "lui_menu_data", "vehicle.outOfRange" );
#precache( "lui_menu_data", "vehicle.topRightButton.text" );

#namespace aquifer_util;

function autoexec __init__sytem__() {     system::register("aquifer_util",&__init__,undefined,undefined);    }

function __init__()
{
	init_clientfields();
	
	SetDvar( "cg_vehicleFocusEntFocalLengthMax", 100.0 );
	SetDvar( "cg_vehicleFocusEntFocalLengthMin", 30.0 );
}

function init_clientfields()
{
	// clientfield setup
	clientfield::register( "toplayer", "vtol_set_landing_zone_ent", 1, 10, "int" );
	clientfield::register( "toplayer", "vtol_landing_zone_update", 1, 2, "int" );
	clientfield::register( "toplayer", "vtol_highlight_ai", 1, 1, "int" );
}


function setup_reusable_destructible()
{
	if( isdefined( level.reusable_destructible ))
		return;
	
	level.reusable_destructible = true;

	level flag::wait_till( "player_active_in_level" );

	
	//setup fx.
	level._effect[ "fx_lg_explosion_destructible" ] = "explosions/fx_exp_generic_lg";
	level._effect[ "fx_glass_destructible" ] = "destruct/fx_dest_ramses_plaza_glass_bldg";
	level._effect[ "fx_electrical_destructible" ] = "explosions/fx_exp_equipment_lg";
	
	
	//get triggers.
	trigs = getentarray( "reusable_destructible","targetname");

	array::thread_all(trigs,&handle_reusable_destructible);
	
}
function handle_reusable_destructible()
{
	self endon("death");
	self endon("stop_reusable_destructibles");
	
	st = struct::get(self.target,"targetname");
	fwd = Anglestoforward( st.angles );
	up= anglestoup( st.angles );
	
	while(1)
	{
		self waittill( "trigger", ent );
		if ( isdefined( ent ) && isdefined( ent.pvtol ) && ent islinkedto( ent.pvtol ) )
		{
			PlayFX( level._effect[ self.script_noteworthy ],st.origin, fwd, up  );
			wait 10;
		}
	}
}

function coop_fly_test()
{
	
	if(isdefined(level.coop_fly_test_executed))
		return;
	level.coop_fly_test_executed = 1;
	
	wait 3;
	
	p_num = 1;
	level.lockon_enemies = [];

	foreach( player in level.players)
	{
		vtolname = "player" + p_num + "_vtol";
		player.pvtol = GetEnt( vtolname, "targetname" );
		p_num++;
		
		if( !IsDefined( player.pvtol ) )
		{
			IPrintLnBold( "missing a votl for player " + vtolname );
			continue;
		}
		player.pvtol MakeVehicleUnusable();
		player thread watch_player_call_vtol();
//		player thread watch_player_lockon();
	}
}

function handle_player_vtol_lockon()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	MAX_LOCK_ON_DIST_SQUARED = 1296000000; // 1000 yards
	MAX_LOCK_ON_ANGLE = 10;
	
	while ( IsDefined( self.pvtol ) && self IsLinkedTo( self.pvtol ) )
	{
		if ( self AdsButtonPressed() && ( !IsDefined( self GetVehicleFocusEntity() ) || !IsAlive( self GetVehicleFocusEntity() ) ) )
		{
			best_target = undefined;
			best_target_distance = MAX_LOCK_ON_DIST_SQUARED;
			best_target_angle = MAX_LOCK_ON_ANGLE;

			enemies = GetVehicleTeamArray( "axis" );//ArrayCombine( GetVehicleTeamArray( "allies" ), GetVehicleTeamArray( "axis" ), false, true );
			if ( IsDefined( level.quad_tank_objectives ) && level.quad_tank_objectives.size > 0 )
			{
				enemies = ArrayCombine( enemies, level.quad_tank_objectives, false, true );
			}
//			enemies = ArrayCombine( vehicles, GetAITeamArray( "axis" ), false, true );
			
			foreach ( enemy in enemies )
			{
				if ( enemy != self.pvtol && IsAlive( enemy ) )
				{
					angle_diff = VectorToAngles( enemy.origin - self getplayercamerapos() ) - self getplayerangles();
					angle_diff = ( AbsAngleClamp180( angle_diff[ 0 ] ), AbsAngleClamp180( angle_diff[ 1 ] ), 0 );
					angle_diff_avg = ( angle_diff[ 0 ] + angle_diff[ 1 ] ) / 2;
//					dist = DistanceSquared( self GetEye(), enemy.origin );
					
					if ( angle_diff_avg <= best_target_angle && angle_diff[ 0 ] <= MAX_LOCK_ON_ANGLE && angle_diff[ 1 ] <= MAX_LOCK_ON_ANGLE && BulletTracePassed( self getplayercamerapos(), enemy.origin, false, self.pvtol, enemy, true ) )//&& dist <= best_target_distance )
					{
						best_target = enemy;
//						best_target_distance = dist;
						best_target_angle = angle_diff_avg;
					}
				}
			}
			
			if ( IsDefined( best_target ) )
			{
				self SetVehicleFocusEntity( best_target );
			}
			else
			{
				self SetVehicleFocusEntity( undefined );
			}
			
			while ( self AdsButtonPressed() )
			{
				wait 0.05;
				
				if ( IsDefined( self GetVehicleFocusEntity() ) && !IsAlive( self GetVehicleFocusEntity() ) )
				{
					self SetVehicleFocusEntity( undefined );
				}
			}
		}
		else if ( !self AdsButtonPressed() && IsDefined( self GetVehicleFocusEntity() ) )
		{
			self SetVehicleFocusEntity( undefined );
		}
		else if ( self AdsButtonPressed() && IsDefined( self GetVehicleFocusEntity() ) && !IsAlive( self GetVehicleFocusEntity() ) )
		{
			while ( self AdsButtonPressed() )
			{
				wait 0.05;
			}
		}

		wait 0.05;
	}
}

function vtol_boost_meter_hud()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	width = 10;
	height = 100;
	x = 20;
	y = -20;
	
	boost_bar = self hud::createBar( ( 0, 1, 0 ), width, height );
	
	boost_bar.alignX = "center";
	boost_bar.alignY = "bottom";
	boost_bar.horzAlign = "left";
	boost_bar.vertAlign = "bottom";
	boost_bar.x = x;
	boost_bar.y = y;
	
	if ( !level.splitScreen )
	{
		boost_bar.y += 2;
	}
	
	boost_bar.bar.alignX = boost_bar.alignX;
	boost_bar.bar.alignY = boost_bar.alignY;
	boost_bar.bar.horzAlign = boost_bar.horzAlign;
	boost_bar.bar.vertAlign = boost_bar.vertAlign;
	boost_bar.bar.x = x;
	boost_bar.bar.y = y;
	
	boost_bar.barFrame.alignX = boost_bar.alignX;
	boost_bar.barFrame.alignY = boost_bar.alignY;
	boost_bar.barFrame.horzAlign = boost_bar.horzAlign;
	boost_bar.barFrame.vertAlign = boost_bar.vertAlign;
	boost_bar.barFrame.x = x;
	boost_bar.barFrame.y = y;

	boost_duration_max = self GetVehicleBoostTime();
	boost_duration_min = self GetVehicleMinBoostTime();
	
	while ( IsDefined( self.pvtol ) && self IsLinkedTo( self.pvtol ) )
	{
		boost_bar.bar SetShader( boost_bar.bar.shader, width, ( self GetVehicleBoostTime() > 0 ? Int( height * self GetVehicleBoostTimeLeft() / self GetVehicleBoostTime() ) : 1 ) );
		
		if ( self GetVehicleBoostTimeLeft() <= self GetVehicleMinBoostTime() )
		{
			boost_bar.bar.color = ( 1, 1, 0 );
		}
		else
		{
			boost_bar.bar.color = ( 0, 1, 0 );
		}
		
		wait 0.05;
	}
	
	boost_bar.bar Destroy();
	boost_bar.barFrame Destroy();
	boost_bar Destroy();
}

function vtol_monitor_landing_zone()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	if ( !IsDefined( self.vtol_lz_fx_ent ) )
	{
		self.vtol_lz_fx_ent = util::spawn_model( "tag_origin", self.origin, self.angles );
	}
	
	self clientfield::set_to_player( "vtol_set_landing_zone_ent", self.vtol_lz_fx_ent GetEntityNumber() );
	
	MaxLandingDist = 1800; // 50 yards
	
	while ( IsDefined( self.pvtol ) && self IsLinkedTo( self.pvtol ) )
	{
		if ( self GetPlayerAngles()[ 0 ] > 0 )
		{
			self.landing_zone_launch_origin = undefined;
			self.landing_zone_drop_origin = undefined;
			curr_landing_dist = MaxLandingDist;// * ( self.pvtol.angles[ 0 ] / 90.0 );
			trace = BulletTrace( self GetPlayerCameraPos(), self GetPlayerCameraPos() + AnglesToForward( self GetPlayerAngles() + ( 7.5, 0, 0 ) ) * curr_landing_dist, true, self, false, false, self.pvtol );
			if ( trace[ "fraction" ] < 1.0 && !IsDefined( trace[ "entity" ] ) )
			{
				if ( VectorDot( trace[ "normal" ], ( 0, 0, 1 ) ) > 0.707 && PlayerPositionValid( trace[ "position" ] ) )
				{
					// All the checks passed.  This is a valid LZ.
					self clientfield::set_to_player( "vtol_landing_zone_update", 1 );
					self.landing_zone_launch_origin = trace[ "position" ];
				}
				else
				{
					self clientfield::set_to_player( "vtol_landing_zone_update", 2 );
				}
				
				self.vtol_lz_fx_ent.origin = trace[ "position" ];
				self.vtol_lz_fx_ent.angles = VectorToAngles( trace[ "normal" ] );
//				self.vtol_lz_fx_ent.angles = ( self.vtol_lz_fx_ent.angles[ 0 ], 180 - self GetPlayerAngles()[ 1 ], self.vtol_lz_fx_ent.angles[ 2 ] );
			}
			else
			{
				self clientfield::set_to_player( "vtol_landing_zone_update", 0 );
			}
		}
		else
		{
			self clientfield::set_to_player( "vtol_landing_zone_update", 0 );
		}
		
		trace = BulletTrace( self GetPlayerCameraPos(), self GetPlayerCameraPos() - ( 0, 0, MaxLandingDist / 2 ), true, self, false, false, self.pvtol );
		if ( trace[ "fraction" ] < 1.0 && !IsDefined( trace[ "entity" ] ) && VectorDot( trace[ "normal" ], ( 0, 0, 1 ) ) > 0.707 && PlayerPositionValid( trace[ "position" ] ) )
		{
			self.landing_zone_drop_origin = trace[ "position" ];
		}

		wait 0.05;
	}
	
	// Destroy the landing zone effect if it's playing
	self clientfield::set_to_player( "vtol_landing_zone_update", 0 );
}

function vtol_hud()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	self thread vtol_boost_meter_hud();
	
	self clientfield::set_to_player( "vtol_highlight_ai", 1 );
	
	self SetControllerUIModelValue( "vehicle.outOfRange", false );
			
	launch_hint = self hud::createfontstring( "big", 1.5 );
	launch_hint.horzAlign = "center";
	launch_hint.vertAlign = "bottom";
	launch_hint.alignx = "right";
	launch_hint.aligny = "bottom";
	launch_hint.x = -150;
	launch_hint.y = -30;
	launch_hint SetText( &"CP_MI_CAIRO_AQUIFER_VTOL_LAUNCH_OUT_HINT" );
	launch_hint.color = ( 0.5, 0.5, 0.5 );
	launch_hint.alpha = 0.5;
	
	while ( IsDefined( self.pvtol ) && self IsLinkedTo( self.pvtol ) )
	{
		if ( IsDefined( self.landing_zone_launch_origin ) )
		{
			launch_hint.color = ( 1.0, 1.0, 1.0 );
			launch_hint.alpha = 1.0;
		}
		else
		{
			launch_hint.color = ( 0.5, 0.5, 0.5 );
			launch_hint.alpha = 0.5;
		}
		
		if ( IsDefined( self.landing_zone_drop_origin ) )
		{
			self SetControllerUIModelValue( "vehicle.topRightButton.text", "CP_MI_CAIRO_AQUIFER_VTOL_DROP_OUT_HINT" );
		}
		else
		{
			self SetControllerUIModelValue( "vehicle.topRightButton.text", "" );
		}
		
		wait 0.05;
	}
	
	self clientfield::set_to_player( "vtol_highlight_ai", 0 );
	
	launch_hint Destroy();
}

function vtol_monitor_missile_lock()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "vtol_stop_monitor_missile_lock" );
	
	last_target = undefined;
	lock_time = 0.0;
	
	veh_weapon = self.pvtol SeatGetWeapon( 0 );
	
	while ( IsDefined( self.pvtol ) && self IsLinkedTo( self.pvtol ) && IsDefined( veh_weapon ) )
	{
		focus_ent = self GetVehicleFocusEntity();
		
		if ( IsDefined( focus_ent ) && IsVehicle( focus_ent ) )
		{
			if ( !IsDefined( last_target ) || focus_ent != last_target || lock_time == 0.0 )
			{
				last_target = focus_ent;
				lock_time = 0.05;
				self WeaponLockStart( focus_ent );
			}
			else
			{
				lock_time += 0.05;
			}
		}
		else if ( IsDefined( last_target ) )
		{
			self WeaponLockFree();
			last_target = undefined;
			lock_time = 0.0;
		}
		
		if ( IsDefined( last_target ) )
		{
			if ( BulletTracePassed( self getplayercamerapos(), last_target.origin, false, self.pvtol, last_target, true ) )
			{
				if ( lock_time >= veh_weapon.lockonspeed / 1000.0 )
				{
					self WeaponLockFinalize( focus_ent );
				}
			}
			else
			{
				self WeaponLockFree();
				lock_time = 0.0;
			}
		}
		
		wait 0.05;
	}
}

function vtol_end_missile_lock()
{
	self WeaponLockFree();
	self notify( "vtol_stop_monitor_missile_lock" );
}

function vtol_monitor_weapon_switching()
{
	self endon( "disconnect" );
	self endon( "death" );

	weapons_info = [];
	weapons_info[ weapons_info.size ] = SpawnStruct();
	weapons_info[ weapons_info.size - 1 ].weaponName = "vtol_fighter_player_turret";
	
	weapons_info[ weapons_info.size ] = SpawnStruct();
	weapons_info[ weapons_info.size - 1 ].weaponName = "vtol_fighter_player_missile_turret";
	weapons_info[ weapons_info.size - 1 ].switchToFunc = &vtol_monitor_missile_lock;
	weapons_info[ weapons_info.size - 1 ].switchFromFunc = &vtol_end_missile_lock;
	
	if ( !IsDefined( self.pvtol.cur_weapon_index ) )
	{
		self.pvtol.cur_weapon_index = 0;
		self SetControllerUIModelValue( "vehicle.weaponIndex", 0 );
	}
	
	if ( !IsDefined( self.pvtol.weapons ) )
	{
		self.pvtol.weapons = [];
		for ( i = 0; i < weapons_info.size; i++ )
		{
			self.pvtol.weapons[ i ] = GetWeapon( weapons_info[ i ].weaponName );
		}
	}
	
	while ( IsDefined( self.pvtol ) && self IsLinkedTo( self.pvtol ) )
	{
		if ( self WeaponSwitchButtonPressed() )
		{
			if ( IsDefined( weapons_info[ self.pvtol.cur_weapon_index ].switchFromFunc ) )
			{
			    self thread [[ weapons_info[ self.pvtol.cur_weapon_index ].switchFromFunc ]]();
			}
			
			self.pvtol.cur_weapon_index++;
			
			if ( self.pvtol.cur_weapon_index >= self.pvtol.weapons.size )
			{
				self.pvtol.cur_weapon_index = 0;
			}
			self SetControllerUIModelValue( "vehicle.weaponIndex", self.pvtol.cur_weapon_index );
			
			self.pvtol SetVehWeapon( self.pvtol.weapons[ self.pvtol.cur_weapon_index ] );
			
			if ( IsDefined( weapons_info[ self.pvtol.cur_weapon_index ].switchToFunc ) )
			{
			    self thread [[ weapons_info[ self.pvtol.cur_weapon_index ].switchToFunc ]]();
			}
			
			while ( self WeaponSwitchButtonPressed() && IsDefined( self.pvtol ) && self IsLinkedTo( self.pvtol ) )
			{
				wait 0.05;
			}
		}
		else
		{
			wait 0.05;
		}
	}
}

function vtol_monitor_toggle_navmesh()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	while ( IsDefined( self.pvtol ) && self IsLinkedTo( self.pvtol ) )
	{
		if ( self UseButtonPressed() )
		{
			self.pvtol SetHeliHeightLock( !self.pvtol GetHeliHeightLock() );
			
			while ( self UseButtonPressed() && IsDefined( self.pvtol ) && self IsLinkedTo( self.pvtol ) )
			{
				wait 0.05;
			}
		}
		else
		{
			wait 0.05;
		}
	}
}

//self == player.
function watch_player_call_vtol( player_controlled )
{
	self endon( "disconnect" );
	self endon( "death" );
	
	self thread vtol_track_owner();
	
	vtol_use_hint = self hud::createfontstring( "big", 1.5 );
	vtol_use_hint.horzAlign = "center";
	vtol_use_hint.vertAlign = "bottom";
	vtol_use_hint.alignx = "center";
	vtol_use_hint.aligny = "bottom";
	vtol_use_hint.x = 0;
	vtol_use_hint.y = -30;
	vtol_use_hint SetText( &"CP_MI_CAIRO_AQUIFER_VTOL_USE_HINT" );
	vtol_use_hint.color = ( 1, 1, 1 );
	vtol_use_hint.alpha = 0.0;
	
	if ( IsDefined( player_controlled ) && player_controlled )
	{
		self.pvtol MakeVehicleUsable();
		self.pvtol UseVehicle( self,0 );
		
		org = self.pvtol GetTagOrigin( "tag_driver_camera");
		ang = self.pvtol GetTagAngles( "tag_driver_camera");
		self setorigin( org );
		self setplayerangles( (0,ang[1],0) );
		
		self.pvtol UseVehicle( self,0 );
		self.pvtol MakeVehicleUnusable();
//		self EnableInvulnerability();
		self DisableWeaponCycling();
		
		wait 0.05;
		
		self.pvtol ReturnPlayerControl();
		self thread handle_player_vtol_lockon();
		self thread vtol_hud();
		self thread vtol_monitor_landing_zone();
		self thread vtol_monitor_weapon_switching();
		self thread vtol_monitor_toggle_navmesh();
		
		self.pvtol SetHeliHeightLock( true );
		self thread fixup_heightmap_on_use();
		
	}
	else
	{
		vtol_use_hint.alpha = 1.0;
	}
	
	self.pvtol SetHeliHeightLock( true );
	
	while(1)
	{
		dropping = ( self ActionSlotOneButtonPressed() || self StanceButtonPressed() ) && self IsLinkedTo( self.pvtol ) && IsDefined( self.landing_zone_drop_origin );
		launching = self IsLinkedTo( self.pvtol ) && IsDefined( self.landing_zone_launch_origin ) && self JumpButtonPressed();
		
		if ( ( self ActionSlotOneButtonPressed() && !self IsLinkedTo( self.pvtol ) ) || launching || dropping )// 3 is left. 2 is down,1 is up.
		{
			self.pvtol MakeVehicleUsable();

			org = self.pvtol GetTagOrigin( "tag_driver_camera");
			ang = self.pvtol GetTagAngles( "tag_driver_camera");
			
			self.pvtol UseVehicle( self,0 );
			
			wait 0.05;
			
			self.pvtol MakeVehicleUnusable();
			self.pvtol setvehvelocity((0,0,0));
			self.pvtol setangularvelocity((0,0,0));
			
			tp = org + (0,0,0 );
			
			self setorigin( tp );
			self setplayerangles( (0,ang[1],0) );

			if(!self islinkedto(self.pvtol))
			{
				force = Anglestoforward( ang );
				self notify( "leaving_vtol" );
				
				self WeaponLockFree();
				
				//IPrintLnBold( "Player LEAVING  VTOL!" );
				wait 0.05;

				force = VectorNormalize( force );
//				force += (0,0,0.8);
				//force = VectorNormalize(force) * 600;
				force = VectorNormalize(force) * 700;

				self enableinvulnerability();
				self EnableWeaponCycling();
				if ( launching )
				{
					self setvelocity(force);
				}
				else
				{
					self SetVelocity( ( 0, 0, 0 ) );
				}
				
				wait 0.05;
				speed = Length(self getvelocity());
				
				self.pvtol Clearvehgoalpos();
				self.pvtol setvehvelocity((0,0,0));
				self.pvtol setangularvelocity((0,0,0));
				self.pvtol CancelAIMove();	
				
				while( speed >20 )
				{
					wait 0.05;
					speed = Length(self getvelocity());
				}
				self DisableInvulnerability();
				
				vtol_use_hint.alpha = 1.0;
			}
			else
			{//player is controlling plane.
				vtol_use_hint.alpha = 0.0;
				//self EnableInvulnerability();
				self DisableWeaponCycling();
				self.pvtol ReturnPlayerControl();
				self thread handle_player_vtol_lockon();
				self thread vtol_hud();
				self thread vtol_monitor_landing_zone();
				self thread vtol_monitor_weapon_switching();
				self thread vtol_monitor_toggle_navmesh();
				self.my_heightmap = "none";
				self.pvtol SetHeliHeightLock( true );
				self thread fixup_heightmap_on_use();
			}
			
			self.landing_zone_launch_origin = undefined;
			self.landing_zone_drop_origin = undefined;
			
			while( !self ActionSlotOneButtonPressed() && !self StanceButtonPressed() && !self JumpButtonPressed() )
			{
				wait 0.05;
			}
		
			//debounce so can't recall immediately.
			wait 0.2;
		}
		wait 0.05;
	}
	
	vtol_use_hint Destroy();
}

function fixup_heightmap_on_use()
{
	self notify( "fixing_heightmap_on_use" );
	self endon( "fixing_heightmap_on_use" );
	
	if ( level flag::exists( "hack_terminals" ) && !level flag::get( "hack_terminals_completed" ) )
	{
		self player_init_heightmap_intro_state();
	}
	else if ( level flag::exists( "hack_terminals2" ) && !level flag::get( "hack_terminals2_completed" ) )// && level flag::get( "destroy_defenses3_completed" ) ) // this is needed if obj 3 and 2 get swapped back again.
	{
		self player_init_heightmap_obj3_state();
	}
	else
	{
		self player_init_heightmap_breach_state();
	}
}


function wait_until_height_change_safe( player, volname, blocking )
{
	if ( !isdefined( blocking ) )
		blocking = true;
	
	if(!isdefined(volname))
		volname = "contains_whole_aquifer";
	
	vol = GetEnt( volname, "targetname" );
	
	if ( !isdefined( vol ) )
		return true;
	
	if ( !blocking )
		return !( player istouching( vol ) );
	
	while( 1 )
	{
		if ( player islinkedto( player.pvtol ) )
		{
			if(! player istouching( vol ) )
			{
				return true;
			}
		}
			
		wait 0.05;
	}
	

}

function init_heightmap_intro_state()
{

	foreach(player in level.players)
	{
		if ( !isdefined( player.my_heightmap ) )
			player.my_heightmap = "none";
		player thread player_init_heightmap_intro_state();

	}	
}
function player_init_heightmap_intro_state( force )
{
	self notify( "changing_player_heighmaps" );
	self endon( "changing_player_heighmaps" );
	
	if ( !isdefined( force ) )
		force = false;

	this_heightmap = "intro";
		
	if(self.my_heightmap != this_heightmap )
	{
		if(!force)
			wait_until_height_change_safe( self );
		self.my_heightmap = this_heightmap;
		
		SetHeliHeightPatchEnabled( "heightmap_objective_mid",false,self);
		SetHeliHeightPatchEnabled( "heightmap_objective1",true,self);
		SetHeliHeightPatchEnabled( "heightmap_objective2",false,self);
		SetHeliHeightPatchEnabled( "heightmap_objective3",false,self);
	}
}

function init_heightmap_breach_state()
{
	foreach(player in level.players)
	{
		if ( !isdefined( player.my_heightmap ) )
			player.my_heightmap = "none";
		player thread player_init_heightmap_breach_state();
	}	
}
function player_init_heightmap_breach_state( force )
{
	self notify( "changing_player_heighmaps" );
	self endon( "changing_player_heighmaps" );
	
	if ( !isdefined( force ) )
		force = false;
	
	this_heightmap = "breach";
		
	if(self.my_heightmap != this_heightmap )
	{
		if(!force)
			wait_until_height_change_safe( self );
		self.my_heightmap = this_heightmap;
		
		SetHeliHeightPatchEnabled( "heightmap_objective_mid",false,self);
		SetHeliHeightPatchEnabled( "heightmap_objective1",false,self);
		SetHeliHeightPatchEnabled( "heightmap_objective2",true,self);
		SetHeliHeightPatchEnabled( "heightmap_objective3",false,self);
	}
}

function init_heightmap_obj3_state()
{
	foreach(player in level.players)
	{
		if ( !isdefined( player.my_heightmap ) )
			player.my_heightmap = "none";
		player thread player_init_heightmap_obj3_state();
	}	
}
function player_init_heightmap_obj3_state( force )
{
	self notify( "changing_player_heighmaps" );
	self endon( "changing_player_heighmaps" );
	
	if ( !isdefined( force ) )
		force = false;
	
	this_heightmap = "obj3";
		
	if(self.my_heightmap != this_heightmap )
	{
		if(!force)
			wait_until_height_change_safe( self );
		self.my_heightmap = this_heightmap;
		
		SetHeliHeightPatchEnabled( "heightmap_objective3",true,self);
		SetHeliHeightPatchEnabled( "heightmap_objective_mid",false,self);
		SetHeliHeightPatchEnabled( "heightmap_objective1",false,self);
		SetHeliHeightPatchEnabled( "heightmap_objective2",false,self);
		
//		SetHeliHeightPatchEnabled( "heightmap_objective_mid",false,self);
//		SetHeliHeightPatchEnabled( "heightmap_objective1",false,self);
//		SetHeliHeightPatchEnabled( "heightmap_objective2",true,self);
//		SetHeliHeightPatchEnabled( "heightmap_objective3",false,self);
		
	}
}
//If the player isn't in the vtol, try and keep it nearby based on the nav volumes.
function vtol_track_owner()
{
	self endon("disconnect");
	self endon("death");
	
	vtol = self.pvtol;
	
	self.in_vtol = self islinkedto(vtol);
	
	while(1)
	{
		//player isn't riding us- go near him on the nav volumes.
		if(!self islinkedto(vtol))
		{
//			if( self.in_vtol) //first frame we aren't in the vtol.
//			{
//				self.in_vtol = false;
//				wait 4; // don't let us start to fly off immediately.
//			
//			}
//			vtol setgoalyaw( self.angles[1] );
//			
//			pos = vtol GetClosestPointOnNavVolume( self.origin+(0,0,768), 4096 );
//			
//			if(!isdefined(pos))
//			{
//				//iprintlnbold("vtol couldn't find point on volume near player");
//				wait 2;
//				continue;
//			}
//			
//			dist = Distance(vtol.origin,pos);
//			if(dist >1024)
//			{
//				gotpath = vtol setvehgoalpos(pos,1,1);
//				if(!gotpath)
//				{
//					gotpath = vtol setvehgoalpos(pos,1,0);
//					
//				}
//				wait 1;
//				
//				while(dist > 128 )
//				{
//					wait 0.2;
//					dist = Distance(vtol.origin,pos);
//					if(dist > 1024)
//						break;
//				}
//			}
//			if(dist <129)
			{
				vtol Clearvehgoalpos();
				vtol setvehvelocity((0,0,0));
				vtol setangularvelocity((0,0,0));
				wait 0.2;
			}
		}
		else
		{
			self.in_vtol = true;
			level flag::set("start_aquifer_objectives");
			
			
		}
		wait 0.05;		
	}
}

function exterior_ambiance()
{
	if(isdefined(level.exterior_ambiance_executed))
		return;
	level.exterior_ambiance_executed = 1;
	
	thread exterior_aerial_threats();
	
	wait 15;

	level.lockon_enemies = vehicle::simple_spawn( "ambient_enemy" );
//	level.lockon_enemies = vehicle::simple_spawn( "ambient_enemy_test" );	


	for( i = 0; i < level.lockon_enemies.size; i++ )
	{
		node = GetVehicleNode( level.lockon_enemies[ i ].target,"targetname");
		level.lockon_enemies[ i ] attachpath(node);
		level.lockon_enemies[ i ] startpath();
		level.lockon_enemies[ i ] thread watch_vehicle_notifies();
	
		/#
			//level.lockon_enemies[ i ] thread debug_ambient_vehicle();
		#/
		
		wait 4;
	}
	
}

function exterior_aerial_threats()
{
	self endon( "breach_hangar_finished" );
	
	level flag::wait_till( "player_active_in_level" );
	level flag::wait_till( "level_long_fly_in_completed" );
	wait 1;
	
	
	wave_min_time = 30000;
	
	last_out_time = -1;
	
	tname = "hunter_exterior_auto1";
	aerial_enemy_spawners = getentarray( tname, "targetname" );
	wait 3;
	while ( 1 )
	{
		tdiff =  last_out_time - GetTime();
		if ( tdiff >0 )
		{
			wait (tdiff / 1000);
			
		}
		//don't have too many active at once.
		active = getentarray( tname + "_vh", "targetname" );
		if ( active.size >= level.players.size * 2 )
		{
			last_out_time= GetTime() + wave_min_time;
			
			// check for dead.
			foreach(veh in active)
			{
				if ( !IsAlive( veh ) )
				{
					veh Delete();
					last_out_time = -1;
				}
			}
			wait 0.05;
			continue;
		}
		
		if( players_to_pilots_ratio() >0.35 )
		{
			// spawn in an ambient hunter.
			veh = vehicle::_vehicle_spawn( array::random( aerial_enemy_spawners ) );
			iprintlnbold( "Ambient Hunter in. Ttl: " + ( active.size + 1 ) );
			wait 4;
			
		}
		
		wait 0.05;
	}
	
	
}

function players_to_pilots_ratio()
{
	pilots = 0;
	foreach ( player in level.players )
	{
		if ( player islinkedto( player.pvtol ) )
		{
			pilots++;
		}
	}
	return ( pilots / level.players.size );
}


function watch_vehicle_notifies()
{
	self endon("death");
	
	start_node = self.target;
	self.last_started_path = GetVehicleNode( start_node,"targetname");
	self.disconnectPathOnStop = false;
	start_node_group = GetVehicleNodeArray( "restart_node_rear", "script_noteworthy");
	my_node_group = GetVehicleNodeArray( "restart_node_rear", "script_noteworthy");
	self.mylookat_ent = spawn("script_origin", self.origin);
	
	while(1)
	{
		node_name = start_node;
		ret_val = self util::waittill_any_return( "path_restart","delete_me","path_jump_node" );
		
		if( ret_val == "delete_me" || !isdefined( node_name ) )
		{
			self Delete();
			return;
		}
		self vehicle::get_off_path();
		curr_time = GetTime();
		my_node_group = [];
		search_group = [];
		
		if( IsDefined( self.currentnode.script_parameters ) )
		{
			search_group = GetVehicleNodeArray( self.currentnode.script_parameters, "script_noteworthy" );
		}
		else 
		{
			iprintlnbold("ERROR: no script parameter of next nodes to go to.");
			search_group = start_node_group;
		}
		
		foreach( node in search_group)
		{
			if(!isdefined(node.reuse_time) || curr_time > node.reuse_time )
			{
				my_node_group[my_node_group.size]= node;
			}
		}
		next_node = array::random(my_node_group);
		
		if( !isdefined(next_node))
		{
			self vehicle::suicide();
			return;	
		}
		next_node.reuse_time = curr_time + 3000;
		dist = Distance(self.origin,next_node.origin);

		if(dist > 128)
		{
			self setspeed( 120,50,125);
			
			self setvehgoalpos( next_node.origin,0,1);
			next = GetVehicleNode( next_node.target,"targetname");
			                      
			self.mylookat_ent.origin = next.origin;
			self setlookatent( self.mylookat_ent );
			
			while(dist > 150 )
			{
				wait 0.05;
				dist = Distance(self.origin,next_node.origin);
			}
			self clearlookatent();
			self CancelAIMove();	
			self ClearVehGoalPos();	
		}
		else
		{
			self CancelAIMove();	
			self ClearVehGoalPos();	
		}
		wait 0.05;

		self attachpath(next_node);
		self.last_started_path = next_node;
		self startpath();
		
		wait 0.05;		
	}
		
}

// This will eventually include turrets, walker tanks etc.
function get_potential_lockon_targets()
{
	level.lockon_enemies = array::remove_dead( level.lockon_enemies );

	return level.lockon_enemies;
}

function watch_player_lockon()
{
	self endon("disconnect");
	self endon("death");

	wait 1;
	min_dot = 0.9;
	max_lockon_dist = 1024;
	lockon_ms = 500;
	heading_min_dot = 0.707;

/#
	min_dot = 0.7;
	max_lockon_dist = 6024;
	lockon_ms = 100;
#/
	
	last_best = undefined;
	best_enemy = undefined;
	
	while(1)
	{
		if( !self.in_vtol)
		{
			wait 0.1;
			continue;
		}
		
		last_best = best_enemy;
		best_enemy= undefined;
		best_dot = -1;
		
		targets = level get_potential_lockon_targets();
		
		foreach( enemy in level.lockon_enemies )
		{

			to_enemy = enemy.origin - self.origin;
			dist_to_enemy = Length( to_enemy );
			
			if(dist_to_enemy > max_lockon_dist )
				continue;
			
			forward = AnglesToForward( self getplayerangles() );

			//check our heading is in a similar direction to the enemies.
			enemy_forward = AnglesToForward( enemy.angles );
			heading_dot = VectorDot(forward, enemy_forward );
			
			if( heading_dot >= heading_min_dot )
			{
				normal = VectorNormalize( to_enemy );
				dot = VectorDot( forward, normal ); 
				
				if( dot > min_dot && dot > best_dot )
				{
					best_dot = dot;
					best_enemy = enemy;
				}
			}
				
			if( IsDefined( best_enemy ) )
			{
				if( !isdefined( last_best) || last_best != best_enemy)
				{
					if(IsAlive( last_best ) )
						last_best.lockon_time = -1;
					
					best_enemy.lockon_time = GetTime() + lockon_ms;
				}
				
				if( GetTime() > best_enemy.lockon_time )
				{
					if( self AdsButtonPressed() )
					{
						self handle_player_lockon( best_enemy );
					}
					else
					{
						/#
						print3d( best_enemy.origin+(0,0,100), "LOCK ON" , (0,0,1),1,2,1);  
						#/
					}
				}
			}
		}
		wait 0.05;
	}
	
}

function velocity_to_mph( vel )
{
	return Length( vel) * (3600.0 / 63360.0) ;
}

function handle_player_lockon( enemy )
{
	// put the player on the enemy's path, behind the enemy.
	self.pvtol takeplayercontrol();

	lerptime = 0.5;
	
	self.pvtol SetPathTransitionTime(lerptime );
	self.pvtol attachpath( enemy.currentnode);
	wait lerptime;
	self.pvtol startpath();
	
	while( self AdsButtonPressed() && IsAlive(enemy) )
	{
		wait 0.05;		
	}
	self.pvtol clearlookatent();
	self.pvtol CancelAIMove();	
	self.pvtol ClearVehGoalPos();	
	
	wait 0.05;
	
	//Getting in / out of the vtol "fixes" it so the player can drive it again.
	self.pvtol UseVehicle( self,0 );
	self.pvtol UseVehicle( self,0 );
	self.pvtol returnplayercontrol();
}


function handle_nrc_aa()
{
	self endon( "death" );
	
	wait 1;
	self setteam( "axis");
	if( ! self turret::is_turret_enabled( 1 ) )
		self turret::enable( 1 );
	
	while(1)
	{
	
		wait 0.05;		
	}
}


function toggle_interior_doors( going_in )
{
	open = going_in;
	
	toggle_door("boss_door", open);
	toggle_door("backwash_door", open);
	open = !going_in;
	toggle_door("hangar_door", open);
	toggle_door("stairwell_door", open);
	toggle_door("hideout_door", open);
	toggle_door("hideout_door2", open);
	
	toggle_door("Hangar_Door_Intact", true);
}

function toggle_door(name, open)
{
	doors = GetEntArray(name, "targetname");
	
	foreach (door in doors)
	{
		if ( IsDefined(door) )
		{
			if ( open )
			{
				door Hide();
				door Notsolid();
				door Connectpaths();
			}
			else
			{
				door Show();
				door solid();
				door disconnectpaths();
			}
		}
	}
}

function safe_use_trigger(name)
{
	trig = Getent(name, "targetname");
	
	if ( IsDefined(trig) )
	{
		trig trigger::use();
	}
}


/#

	function debug_ambient_vehicle()
{
	self endon("death");
	des_speed = 120;
	while(1)
	{
		des_speed = self getspeedmph();
		
		
		color = (1,1,1);
		size = 12;
		speed = velocity_to_mph( self getvelocity() );
		if(speed < des_speed - 10)
			color = (0,0,1);
		else if(speed > des_speed + 10)
			color = (1,0,0);
		else 
			size =6;
		
		
		print3d( self.origin+(0,0,400), des_speed , (1,1,1), 1, 6 );
		print3d( self.origin+(0,0,120), speed , color, 1, size );
		{wait(.05);};

	}
}


#/
