#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\zombies\_zm_net; 

init()
{
	if( !maps\mp\zombies\_zm_weapons::is_weapon_included( "jetgun_zm" ) )
	{
		return;
	}

	maps\mp\zombies\_zm_equipment::register_equipment( "jetgun_zm", &"ZOMBIE_EQUIP_JETGUN_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_JETGUN_HOWTO", "jetgun", ::jetgun_activation_watcher_thread );


/*
	// precache the clientside effects
	level._effect["jetgun_viewmodel_power_cell1"] = loadfx("weapon/thunder_gun/fx_thundergun_power_cell_view1");
	level._effect["jetgun_viewmodel_power_cell2"] = loadfx("weapon/thunder_gun/fx_thundergun_power_cell_view2");
	level._effect["jetgun_viewmodel_power_cell3"] = loadfx("weapon/thunder_gun/fx_thundergun_power_cell_view3");
	level._effect["jetgun_viewmodel_steam"] = loadfx("weapon/thunder_gun/fx_thundergun_steam_view");

	level._effect["jetgun_viewmodel_power_cell1_upgraded"] = loadfx("weapon/thunder_gun/fx_thundergun_power_cell_view1");
	level._effect["jetgun_viewmodel_power_cell2_upgraded"] = loadfx("weapon/thunder_gun/fx_thundergun_power_cell_view2");
	level._effect["jetgun_viewmodel_power_cell3_upgraded"] = loadfx("weapon/thunder_gun/fx_thundergun_power_cell_view3");
	level._effect["jetgun_viewmodel_steam_upgraded"] = loadfx("weapon/thunder_gun/fx_thundergun_steam_view");


	level._effect["jetgun_knockdown_ground"]	= loadfx( "weapon/thunder_gun/fx_thundergun_knockback_ground" );
*/
	level._effect["jetgun_smoke_cloud"]			= loadfx( "weapon/thunder_gun/fx_thundergun_smoke_cloud" );

	level._effect["jetgun_vortex"]					= loadfx( "weapon/jet_gun/fx_jetgun_on" );
	level._effect["jetgun_meat_grinder"]			= loadfx( "weapon/jet_gun/fx_jetgun_kill" );


	set_zombie_var( "jetgun_cylinder_radius",		180 );
	set_zombie_var( "jetgun_grind_range",			250 ); 
	set_zombie_var( "jetgun_fling_range",			250 ); 
	set_zombie_var( "jetgun_gib_range",				255 ); 
	set_zombie_var( "jetgun_gib_damage",			75 );
	set_zombie_var( "jetgun_knockdown_range",		260 ); 
	set_zombie_var( "jetgun_drag_range",			500 ); 
	set_zombie_var( "jetgun_knockdown_damage",		15 );

	level.jetgun_gib_refs = []; 
	level.jetgun_gib_refs[level.jetgun_gib_refs.size] = "guts"; 
	level.jetgun_gib_refs[level.jetgun_gib_refs.size] = "right_arm"; 
	level.jetgun_gib_refs[level.jetgun_gib_refs.size] = "left_arm"; 
	level.jetgun_gib_refs[level.jetgun_gib_refs.size] = "right_leg"; 
	level.jetgun_gib_refs[level.jetgun_gib_refs.size] = "left_leg"; 
	level.jetgun_gib_refs[level.jetgun_gib_refs.size] = "no_legs"; 

/#
	level thread jetgun_devgui_dvar_think();
#/
	
	OnPlayerConnect_Callback(::jetgun_on_player_connect);
}


jetgun_activation_watcher_thread()
{
	self endon("zombified");
	self endon("disconnect");
	self endon("riotshield_zm_taken");

	while(1)
	{
		self waittill_either("jetgun_zm_activate", "jetgun_zm_deactivate");
		// nothing 
	}
}


/#
jetgun_devgui_dvar_think()
{
	if ( !maps\mp\zombies\_zm_weapons::is_weapon_included( "jetgun_zm" ) )
	{
		return;
	}

	SetDvar( "scr_jetgun_cylinder_radius", level.zombie_vars["jetgun_cylinder_radius"] );
	SetDvar( "scr_jetgun_fling_range", level.zombie_vars["jetgun_fling_range"] );
	SetDvar( "scr_jetgun_grind_range", level.zombie_vars["jetgun_grind_range"] );
	SetDvar( "scr_jetgun_drag_range", level.zombie_vars["jetgun_drag_range"] );
	SetDvar( "scr_jetgun_gib_range", level.zombie_vars["jetgun_gib_range"] );
	SetDvar( "scr_jetgun_gib_damage", level.zombie_vars["jetgun_gib_damage"] );
	SetDvar( "scr_jetgun_knockdown_range", level.zombie_vars["jetgun_knockdown_range"] );
	SetDvar( "scr_jetgun_knockdown_damage", level.zombie_vars["jetgun_knockdown_damage"] );

	for ( ;; )
	{
		level.zombie_vars["jetgun_cylinder_radius"]		= GetDvarInt( "scr_jetgun_cylinder_radius" );
		level.zombie_vars["jetgun_fling_range"]			= GetDvarInt( "scr_jetgun_fling_range" );
		level.zombie_vars["jetgun_grind_range"]			= GetDvarInt( "scr_jetgun_grind_range" );
		level.zombie_vars["jetgun_drag_range"]			= GetDvarInt( "scr_jetgun_drag_range" );
		level.zombie_vars["jetgun_gib_range"]			= GetDvarInt( "scr_jetgun_gib_range" );
		level.zombie_vars["jetgun_gib_damage"]			= GetDvarInt( "scr_jetgun_gib_damage" );
		level.zombie_vars["jetgun_knockdown_range"] 	= GetDvarInt( "scr_jetgun_knockdown_range" );
		level.zombie_vars["jetgun_knockdown_damage"]	= GetDvarInt( "scr_jetgun_knockdown_damage" );

		wait( 0.5 );
	}
}
#/


jetgun_on_player_connect()
{
	self thread wait_for_jetgun_fired(); 
}


get_jetgun_engine_direction()
{
	return self getcurrentweaponspinlerp();
}

set_jetgun_engine_direction( nv )
{
	self setcurrentweaponspinlerp(nv);
}


wait_for_jetgun_fired()
{
	self endon( "disconnect" );
	self waittill( "spawned_player" ); 

	for( ;; )
	{
		self waittill( "weapon_fired" ); 
		currentweapon = self GetCurrentWeapon(); 
		if( ( currentweapon == "jetgun_zm" ) || ( currentweapon == "jetgun_upgraded_zm" ) )
		{
			self thread jetgun_fired(); 

			view_pos = self GetTagOrigin( "tag_flash" );
			view_angles = self GetTagAngles( "tag_flash" );
			if ( self get_jetgun_engine_direction() < 0)
				playfx( level._effect["jetgun_smoke_cloud"], view_pos- self GetPlayerViewHeight(), AnglesToForward( view_angles ), AnglesToUp( view_angles ) );
			else
				playfx( level._effect["jetgun_smoke_cloud"], view_pos- self GetPlayerViewHeight(), -AnglesToForward( view_angles ), AnglesToUp( view_angles ) );

//			playfxOnTag( level._effect[ "jetgun_vortex" ], self, "tag_flash" );
			wait 0.25;
		}
	}
}


jetgun_network_choke()
{
	level.jetgun_network_choke_count++;
	
	if ( !(level.jetgun_network_choke_count % 10) )
	{
		wait_network_frame();
		wait_network_frame();
		wait_network_frame();
	}
}


jetgun_fired()
{
	if ( abs(self get_jetgun_engine_direction()) < 0.2)
		return;

	// ww: physics hit when firing
	origin = self GetWeaponMuzzlePoint();
	PhysicsJetThrust( origin, - (self GetWeaponForwardDir()), level.zombie_vars["jetgun_fling_range"], self get_jetgun_engine_direction(), 0.85 );
	
	if ( !IsDefined( level.jetgun_knockdown_enemies ) )
	{
		level.jetgun_knockdown_enemies = [];
		level.jetgun_knockdown_gib = [];
		level.jetgun_drag_enemies = [];
		level.jetgun_fling_enemies = [];
		level.jetgun_fling_vecs = [];
		level.jetgun_grind_enemies = [];
	}

	self jetgun_get_enemies_in_range(self get_jetgun_engine_direction());

	//iprintlnbold( "flg: " + level.jetgun_fling_enemies.size + " gib: " + level.jetgun_gib_enemies.size + " kno: " + level.jetgun_knockdown_enemies.size );

	level.jetgun_network_choke_count = 0;
	for ( i = 0; i < level.jetgun_fling_enemies.size; i++ )
	{
		jetgun_network_choke();
		if (isdefined(level.jetgun_fling_enemies[i]))
			level.jetgun_fling_enemies[i] thread jetgun_fling_zombie( self, level.jetgun_fling_vecs[i], i, level.jetgun_grind_enemies[i] );
	}
	for ( i = 0; i < level.jetgun_drag_enemies.size; i++ )
	{
		jetgun_network_choke();
		if (isdefined(level.jetgun_drag_enemies[i]))
			level.jetgun_drag_enemies[i] thread jetgun_drag_zombie( origin );
	}

/*
	for ( i = 0; i < level.jetgun_knockdown_enemies.size; i++ )
	{
		jetgun_network_choke();
		level.jetgun_knockdown_enemies[i] thread jetgun_knockdown_zombie( self, level.jetgun_knockdown_gib[i] );
	}
*/

	level.jetgun_knockdown_enemies = [];
	level.jetgun_knockdown_gib = [];
	level.jetgun_drag_enemies = [];
	level.jetgun_fling_enemies = [];
	level.jetgun_fling_vecs = [];
	level.jetgun_grind_enemies = [];
}


jetgun_get_enemies_in_range(invert)
{
	view_pos = self GetWeaponMuzzlePoint();
	zombies = get_array_of_closest( view_pos, GetAiSpeciesArray( "axis", "all" ), undefined, undefined, level.zombie_vars["jetgun_drag_range"] );
	if ( !isDefined( zombies ) )
	{
		//return;
	}

	knockdown_range_squared = level.zombie_vars["jetgun_knockdown_range"] * level.zombie_vars["jetgun_knockdown_range"];
	drag_range_squared = level.zombie_vars["jetgun_drag_range"] * level.zombie_vars["jetgun_drag_range"];
	gib_range_squared = level.zombie_vars["jetgun_gib_range"] * level.zombie_vars["jetgun_gib_range"];
	fling_range_squared = level.zombie_vars["jetgun_fling_range"] * level.zombie_vars["jetgun_fling_range"];
	grind_range_squared = level.zombie_vars["jetgun_grind_range"] * level.zombie_vars["jetgun_grind_range"];
	cylinder_radius_squared = level.zombie_vars["jetgun_cylinder_radius"] * level.zombie_vars["jetgun_cylinder_radius"];

	forward_view_angles = self GetWeaponForwardDir();
	end_pos = view_pos + VectorScale( forward_view_angles, level.zombie_vars["jetgun_knockdown_range"] );

/#
	if ( 2 == GetDvarInt( "scr_jetgun_debug" ) )
	{
		// push the near circle out a couple units to avoid an assert in Circle() due to it attempting to
		// derive the view direction from the circle's center point minus the viewpos
		// (which is what we're using as our center point, which results in a zeroed direction vector)
		near_circle_pos = view_pos + VectorScale( forward_view_angles, 2 );

		Circle( near_circle_pos, level.zombie_vars["jetgun_cylinder_radius"], (1, 0, 0), false, false, 100 );
		Line( near_circle_pos, end_pos, (0, 0, 1), 1, false, 100 );
		Circle( end_pos, level.zombie_vars["jetgun_cylinder_radius"], (1, 0, 0), false, false, 100 );
	}
#/

	for ( i = 0; i < zombies.size; i++ )
	{

		self jetgun_check_enemies_in_range(	zombies[i],
											view_pos,
											drag_range_squared,
											gib_range_squared,
											grind_range_squared,
											fling_range_squared,
											cylinder_radius_squared,
											forward_view_angles,
											end_pos,
											invert);
											 
	}
	/*
	corpses = getcorpsearray();
	for ( i = 0; i < corpses.size; i++ )
	{
		self jetgun_check_enemies_in_range(	corpses[i],
											view_pos,
											drag_range_squared,
											gib_range_squared,
											grind_range_squared,
											fling_range_squared,
											cylinder_radius_squared,
											forward_view_angles,
											end_pos,
											invert);
	}
	*/
}

jetgun_check_enemies_in_range(	zombie,
								view_pos,
								drag_range_squared,
								gib_range_squared,
								grind_range_squared,
								fling_range_squared,
								cylinder_radius_squared,
								forward_view_angles,
								end_pos,
								invert)
{
	if ( !isDefined( zombie ) )
	{
		return;
	}

	if ( !IsDefined( zombie ) ) //|| !IsAlive( zombie ) )
	{
		// guy died on us
		return;
	}

	test_origin = zombie getcentroid();
	test_range_squared = DistanceSquared( view_pos, test_origin );
	if ( test_range_squared > drag_range_squared )
	{
		zombie jetgun_debug_print( "range", (1, 0, 0) );
		return; // everything else in the list will be out of range
	}

	normal = VectorNormalize( test_origin - view_pos );
	dot = VectorDot( forward_view_angles, normal );
	if ( abs(dot) < 0.7 )
	{
		// guy's not in the cone in front of or behind us
		zombie jetgun_debug_print( "dot", (1, 0, 0) );
		return;
	}
		
	radial_origin = PointOnSegmentNearestToPoint( view_pos, end_pos, test_origin );
	if ( DistanceSquared( test_origin, radial_origin ) > cylinder_radius_squared )
	{
		// guy's outside the range of the cylinder of effect
		zombie jetgun_debug_print( "cylinder", (1, 0, 0) );
		return;
	}

	if ( 0 == zombie DamageConeTrace( view_pos, self ) )
	{
		// guy can't actually be hit from where we are
		zombie jetgun_debug_print( "cone", (1, 0, 0) );
		return;
	}

	jetgun_blow_suck = invert;
	if ( 0 > dot )
		jetgun_blow_suck *= -1;
		
	if ( test_range_squared < fling_range_squared )
	{
		level.jetgun_fling_enemies[level.jetgun_fling_enemies.size] = zombie;

		// the closer they are, the harder they get flung
		dist_mult = (fling_range_squared - test_range_squared) / fling_range_squared;
		fling_vec = VectorNormalize( test_origin - view_pos );

		// within 6 feet, just push them straight away from the player, ignoring radial motion
		if ( 5000 < test_range_squared )
		{
//			fling_vec = fling_vec + VectorNormalize( test_origin - radial_origin );
		}
//		fling_vec = (fling_vec[0], fling_vec[1], abs( fling_vec[2] ));
		fling_vec = VectorScale( fling_vec, 100 + 100 * dist_mult );

		fling_vec = jetgun_blow_suck*fling_vec; //(jetgun_blow_suck*fling_vec[0], -fling_vec[1], -fling_vec[2] );

		level.jetgun_fling_vecs[level.jetgun_fling_vecs.size] = fling_vec;
		level.jetgun_grind_enemies[level.jetgun_grind_enemies.size] = ( dot < 0 );

	}
	else if ( test_range_squared < drag_range_squared && dot > 0 )
	{
		level.jetgun_drag_enemies[level.jetgun_drag_enemies.size] = zombie;
	}
/*
	else if ( test_range_squared < gib_range_squared )
	{
		level.jetgun_knockdown_enemies[level.jetgun_knockdown_enemies.size] = zombie;
		level.jetgun_knockdown_gib[level.jetgun_knockdown_gib.size] = true;
	}
	else
	{
		level.jetgun_knockdown_enemies[level.jetgun_knockdown_enemies.size] = zombie;
		level.jetgun_knockdown_gib[level.jetgun_knockdown_gib.size] = false;
	}
*/
}



jetgun_debug_print( msg, color )
{
/#
	if ( !GetDvarInt( "scr_jetgun_debug" ) )
	{
		return;
	}

	if ( !isdefined( color ) )
	{
		color = (1, 1, 1);
	}

	Print3d(self.origin + (0,0,60), msg, color, 1, 1, 40); // 10 server frames is 1 second
#/
}

try_gibbing()
{
	if ( isdefined(self) && isdefined(self.a) && !is_true( self.isscreecher ) )
	{
		self.a.gib_ref = random( level.jetgun_gib_refs );
		self thread maps\mp\animscripts\zm_death::do_gib();
	}
}


jetgun_grind_zombie( player, fling_vec )
{
	player endon("death");
	player endon("disconnect");
	self endon("death");
	
	if (!isdefined(self.jetgun_grind))
	{
		self.jetgun_grind=1;
		grind_range_squared = level.zombie_vars["jetgun_grind_range"] * level.zombie_vars["jetgun_grind_range"];
		dsquared = DistanceSquared(player.origin, self.origin);
		max_tries = 30;
		while ( isdefined(self) && isdefined(dsquared) && dsquared > (grind_range_squared) && max_tries > 0)
		{
			if (randomint(5)==0)
				self try_gibbing();
			wait 0.05;
			if (isdefined(self))
				dsquared = DistanceSquared(player.origin, self.origin);
			max_tries--;
		}
		if ( isdefined(dsquared) && dsquared < (grind_range_squared) )
		{
			player set_jetgun_engine_direction( 0.5 * player get_jetgun_engine_direction() );
//			player WeaponPlayEjectBrass();
			//playfxOnTag( level._effect[ "jetgun_meat_grinder" ], player, "tag_flash" );
			wait 0.05;
		}
		self Delete();
	}
	

}

jetgun_fling_zombie( player, fling_vec, index, grind )
{
	if( !IsDefined( self ) ) //|| !IsAlive( self ) )
	{
		// guy died on us 
		return;
	}

	if ( IsDefined( self.jetgun_fling_func ) )
	{
		self [[ self.jetgun_fling_func ]]( player );
		return;
	}
	
	was_alive = IsAlive( self );

	if( was_alive )
	{
		self try_gibbing();
		player WeaponPlayEjectBrass();
		self DoDamage( self.health + 666, player.origin, player );
		player playsound( "evt_jetgun_zmb_suck" );
		//self DoDamage( self.maxhealth * 0.25, player.origin, player );
	}
	if ( grind )
	{
		self thread jetgun_grind_zombie( player );
	}

	//if ( !was_alive || self.health <= 0 )
	{
		points = 10;
		if ( !index )
		{
			points = maps\mp\zombies\_zm_score::get_zombie_death_player_points();
		}
		else if ( 1 == index )
		{
			points = 30;
		}
		if ( was_alive )
		{
			player maps\mp\zombies\_zm_score::player_add_points( "jetgun_fling", points );
		
			self StartRagdoll();
			wait 0.05;
		}

		/#
			if ( 3 == GetDvarInt( "scr_jetgun_debug" ) )
			{
				Line( self.origin, self.origin + fling_vec, (0, 0, 1), 1, false, 100 );
			}
		#/

		self LaunchRagdoll( fling_vec );

		self.jetgun_death = true;
	}
}

jetgun_drag_zombie( vDir )
{
	self zombie_do_drag( vDir );
}

jetgun_knockdown_zombie( player, gib )
{
	self endon( "death" );

	//if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us 
		return;
	}

	if ( IsDefined( self.jetgun_knockdown_func ) )
	{
		self [[ self.jetgun_knockdown_func ]]( player, gib );
	}
	else
	{
		
		self DoDamage( level.zombie_vars["jetgun_knockdown_damage"], player.origin, player );
	

		
	}
	
	if ( gib )
	{
		self.a.gib_ref = random( level.jetgun_gib_refs );
		self thread maps\mp\animscripts\zm_death::do_gib();
	}

	self.jetgun_handle_pain_notetracks = ::handle_jetgun_pain_notetracks;
	self DoDamage( level.zombie_vars["jetgun_knockdown_damage"], player.origin, player );
}


handle_jetgun_pain_notetracks( note )
{
	if ( note == "zombie_knockdown_ground_impact" )
	{
		playfx( level._effect["jetgun_knockdown_ground"], self.origin, AnglesToForward( self.angles ), AnglesToUp( self.angles ) );
	}
}


is_jetgun_damage()
{
	return IsDefined( self.damageweapon ) && (self.damageweapon == "jetgun_zm" || self.damageweapon == "jetgun_upgraded_zm") && (self.damagemod != "MOD_GRENADE" && self.damagemod != "MOD_GRENADE_SPLASH");
}


enemy_killed_by_jetgun()
{
	return ( IsDefined( self.jetgun_death ) && self.jetgun_death == true ); 
}

zombie_do_drag( vDir )
{
	if (!self zombie_is_in_drag_state())
	{
		self zombie_enter_drag_state(vDir);
		self thread zombie_drag_think();
	}
	else
	{
		self zombie_keep_in_drag_state(vDir);
	}
}

zombie_is_in_drag_state()
{
	return is_true(self.drag_state);
}

zombie_should_stay_in_drag_state()
{
	if ( !IsDefined( self ) || !IsAlive( self ) )
		return false;
	if ( is_true(self.drag_state) && GetTime() - self.drag_start_time < 0.25 )
		return true;
	return false;
}

zombie_keep_in_drag_state(vDir)
{
	self.drag_start_time = GetTime();
	self.drag_target = vDir;
}

zombie_enter_drag_state(vDir)
{
	self.drag_state = true;
	self zombie_keep_in_drag_state(vDir);
}

zombie_exit_drag_state()
{
	self.drag_state = false;
}

AIPhysicsTrace( start, end )
{
	result = PhysicsTrace(start,end,(0,0,0),(0,0,0),self);//level.PhysicsTraceMaskPhysics
	return result["position"];
}


zombie_drag_think()
{
	drag_speed = 75;
	self endon("death");
	while ( self zombie_should_stay_in_drag_state() )
	{
		jetgun_network_choke();
		if (randomint(4)==0)
			self try_gibbing();
		drag_vector = self.drag_target - self.origin;
		range_squared = LengthSquared(drag_vector); //DistanceSquared( self.origin, self.drag_target );
		if ( range_squared > 100*100 )
		{
			drag_vector = VectorNormalize( drag_vector );
			drag_vector = drag_speed * drag_vector;
			end_pos = self AIPhysicsTrace( self.origin, self.origin + drag_vector );
			if ( IsDefined(end_pos) )
			{
				//Line( self.origin, end_pos, (0, 0, 1), 1, false, 100 );
				self.origin = end_pos;
			}
		}
		wait 0.05;
	}
	zombie_exit_drag_state();
}



