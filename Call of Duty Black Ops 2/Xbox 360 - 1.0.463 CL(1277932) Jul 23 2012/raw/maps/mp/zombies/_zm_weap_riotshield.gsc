#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility; 

init()
{
	maps\mp\zombies\_zm_riotshield::init();
	set_zombie_var( "riotshield_cylinder_radius",		360 );
	set_zombie_var( "riotshield_fling_range",			90 ); 
	set_zombie_var( "riotshield_gib_range",				90 ); 
	set_zombie_var( "riotshield_gib_damage",			75 );
	set_zombie_var( "riotshield_knockdown_range",		90 ); 
	set_zombie_var( "riotshield_knockdown_damage",		15 );

	set_zombie_var( "riotshield_hit_points",			3000 );

	//damage applied to shield on melle
	set_zombie_var( "riotshield_fling_damage_shield",			100 ); 
	set_zombie_var( "riotshield_knockdown_damage_shield",		15 );

	level.riotshield_network_choke_count=0;
	level.riotshield_gib_refs = []; 
	level.riotshield_gib_refs[level.riotshield_gib_refs.size] = "guts"; 
	level.riotshield_gib_refs[level.riotshield_gib_refs.size] = "right_arm"; 
	level.riotshield_gib_refs[level.riotshield_gib_refs.size] = "left_arm"; 
	
	level.riotshield_damage_callback = ::player_damage_shield;
	level.transferRiotShield = ::transferRiotShield;
	level.canTransferRiotShield = ::canTransferRiotShield;

	maps\mp\zombies\_zm_equipment::register_equipment( "riotshield_zm", &"ZOMBIE_EQUIP_RIOTSHIELD_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_RIOTSHIELD_HOWTO", "riotshield", ::riotshield_activation_watcher_thread );

	OnPlayerConnect_Callback(::onPlayerConnect);

}

onPlayerConnect()
{
	self thread onPlayerSpawned(); 
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self.player_shield_reset_health = ::player_init_shield_health;
		self.player_shield_apply_damage = ::player_damage_shield;
		self thread watchRiotShieldUse();
		self thread watchRiotShieldMelee();
	}
}


canTransferRiotShield( fromplayer, toplayer )
{
	// this will require some mucking around in code to support - EO
	return true; 
/*
	// you can pick up your own shield
	if ( fromplayer==toplayer )
		return true;

	// can't pick up if you already have one and it's not deployed
	if ( toplayer is_player_equipment(level.riotshield_name) && toplayer.shield_placement!=3 ) 
		return false;

	// can't pick up if it's not from your team
	if ( fromplayer.session_team!=toplayer.session_team )
		return false;

	return true;
*/
}

transferRiotShield( fromplayer, toplayer )
{
	damage = fromplayer.shieldDamageTaken;
	toplayer player_take_riotshield();
	fromplayer player_take_riotshield();
	toplayer.shieldDamageTaken = damage;
	toplayer.shield_placement = 3;
	toplayer.shield_damage_level = 0;
	toplayer maps\mp\zombies\_zm_equipment::equipment_give( "riotshield_zm" );
	toplayer SwitchToWeapon( "riotshield_zm" );
	damageMax = level.zombie_vars["riotshield_hit_points"]; 
	toplayer player_set_shield_health( damage, damageMax );
}


player_take_riotshield()
{
//iprintlnbold( "riot shield destroyed" );
	self notify( "destroy_riotshield" );

	if ( self GetCurrentWeapon() == "riotshield_zm" )
	{
		new_primary = "";
		primaryWeapons = self GetWeaponsListPrimaries();
		for ( i = 0; i < primaryWeapons.size; i++ )
		{
			if ( primaryWeapons[i] !="riotshield_zm" )
			{
				new_primary = primaryWeapons[i];
				break;
			}
		}
		self SwitchToWeapon( new_primary );
		self waittill ( "weapon_change" );
	}

	self maps\mp\zombies\_zm_riotshield::RemoveRiotShield();	

	self maps\mp\zombies\_zm_equipment::equipment_take();

	self.hasRiotShield = false;
	self.hasRiotShieldEquipped = false;

}

player_init_shield_health()
{
	retval = (self.shieldDamageTaken > 0);
	self.shieldDamageTaken=0;
//iprintlnbold( "riot shield at full strength" );
	self.shield_damage_level=0;
	self maps\mp\zombies\_zm_riotshield::UpdateRiotShieldModel();
	return retval;
}

player_set_shield_health( damage, max_damage )
{
	shieldHealth = int( 100 * (max_damage - damage) / max_damage );
//iprintlnbold( "riot shield at " + shieldHealth + " percent strength" );
	if (shieldHealth >= 50)
		self.shield_damage_level=0;
	else if (shieldHealth >= 25)
		self.shield_damage_level=1;
	else
		self.shield_damage_level=2;
	self maps\mp\zombies\_zm_riotshield::UpdateRiotShieldModel();
}

player_damage_shield( iDamage, bHeld )
{
	// EOtodo - needs to be exposed for tuning
	damageMax = level.zombie_vars["riotshield_hit_points"]; 
	if (!IsDefined(self.shieldDamageTaken))
		self.shieldDamageTaken=0;

	self.shieldDamageTaken += iDamage;

	if( self.shieldDamageTaken >= damageMax  )
	{
		if( bHeld )
		{
			self PlayRumbleOnEntity( "damage_heavy" );
			Earthquake( 1.0, 0.75, self.origin, 100 );
		}
		self thread player_take_riotshield();
	}
	else
	{
		if( bHeld )
		{
			self PlayRumbleOnEntity( "damage_light" );
			Earthquake( 0.5, 0.5, self.origin, 100 );
		}
		self player_set_shield_health( self.shieldDamageTaken, damageMax );
	}
}


riotshield_activation_watcher_thread()
{
	self endon("zombified");
	self endon("disconnect");
	self endon("riotshield_zm_taken");

	while(1)
	{
		self waittill_either("riotshield_zm_activate", "riotshield_zm_deactivate");
		// nothing 
	}
}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchRiotShieldUse() // self == player
{
	self endon( "death" );
	self endon( "disconnect" );

	self.shieldDamageTaken=0;

	// watcher for attaching the model to correct player bones
	self thread maps\mp\zombies\_zm_riotshield::trackRiotShield();
	//self thread trackRiotShieldAttractor();
	self thread trackStuckZombies();
	//self thread watchShieldKnockback();

	for ( ;; )
	{
		self waittill( "raise_riotshield" );
		self thread maps\mp\zombies\_zm_riotshield::startRiotshieldDeploy();
	}
}


watchRiotShieldMelee() // self == player
{
	for ( ;; )
	{
		self waittill( "weapon_melee", weapon ); 
		if ( weapon == level.riotshield_name )
			self riotshield_melee();
	}
}


riotshield_fling_zombie( player, fling_vec, index )
{
	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us 
		return;
	}

	if ( IsDefined( self.riotshield_fling_func ) )
	{
		self [[ self.riotshield_fling_func ]]( player );
		return;
	}
	
	self DoDamage( self.health + 666, player.origin, player );

	if ( self.health <= 0 )
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
		player maps\mp\zombies\_zm_score::player_add_points( "riotshield_fling", points );
		
		self StartRagdoll();
		self LaunchRagdoll( fling_vec );

		self.riotshield_death = true;
	}
}


zombie_knockdown( player, gib )
{
	damage = level.zombie_vars["riotshield_knockdown_damage"];
	if(isDefined(level.override_riotshield_damage_func))
	{
		self[[level.override_riotshield_damage_func]](player,gib);
	}
	else
	{
		if ( gib )
		{
			self.a.gib_ref = random( level.riotshield_gib_refs );
			self thread maps\mp\animscripts\zm_death::do_gib();
		}

		self DoDamage( damage, player.origin, player );
	}

}



riotshield_knockdown_zombie( player, gib )
{
	self endon( "death" );
	playsoundatposition ("vox_riotshield_forcehit", self.origin);
	playsoundatposition ("wpn_riotshield_proj_impact", self.origin);


	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us 
		return;
	}

	if ( IsDefined( self.riotshield_knockdown_func ) )
	{
		self [[ self.riotshield_knockdown_func ]]( player, gib );
	}
	else
	{
		 self zombie_knockdown(player, gib);
		//self DoDamage( level.zombie_vars["riotshield_knockdown_damage"], player.origin, player );
	}
	
//	self playsound( "riotshield_impact" );
//	self.riotshield_handle_pain_notetracks = ::handle_riotshield_pain_notetracks;
	self DoDamage( level.zombie_vars["riotshield_knockdown_damage"], player.origin, player );
	self playsound( "fly_riotshield_forcehit" );
	
}

riotshield_get_enemies_in_range()
{
	view_pos = self geteye(); // GetViewPos(); //GetWeaponMuzzlePoint();
	zombies = get_array_of_closest( view_pos, GetAiSpeciesArray( "axis", "all" ), undefined, undefined, level.zombie_vars["riotshield_knockdown_range"] );
	if ( !isDefined( zombies ) )
	{
		return;
	}

	knockdown_range_squared = level.zombie_vars["riotshield_knockdown_range"] * level.zombie_vars["riotshield_knockdown_range"];
	gib_range_squared = level.zombie_vars["riotshield_gib_range"] * level.zombie_vars["riotshield_gib_range"];
	fling_range_squared = level.zombie_vars["riotshield_fling_range"] * level.zombie_vars["riotshield_fling_range"];
	cylinder_radius_squared = level.zombie_vars["riotshield_cylinder_radius"] * level.zombie_vars["riotshield_cylinder_radius"];

	forward_view_angles = self GetWeaponForwardDir();
	end_pos = view_pos + VectorScale( forward_view_angles, level.zombie_vars["riotshield_knockdown_range"] );

/#
	if ( 2 == GetDvarInt( "scr_riotshield_debug" ) )
	{
		// push the near circle out a couple units to avoid an assert in Circle() due to it attempting to
		// derive the view direction from the circle's center point minus the viewpos
		// (which is what we're using as our center point, which results in a zeroed direction vector)
		near_circle_pos = view_pos + VectorScale( forward_view_angles, 2 );

		Circle( near_circle_pos, level.zombie_vars["riotshield_cylinder_radius"], (1, 0, 0), false, false, 100 );
		Line( near_circle_pos, end_pos, (0, 0, 1), 1, false, 100 );
		Circle( end_pos, level.zombie_vars["riotshield_cylinder_radius"], (1, 0, 0), false, false, 100 );
	}
#/

	for ( i = 0; i < zombies.size; i++ )
	{
		if ( !IsDefined( zombies[i] ) || !IsAlive( zombies[i] ) )
		{
			// guy died on us
			continue;
		}

		test_origin = zombies[i] getcentroid();
		test_range_squared = DistanceSquared( view_pos, test_origin );
		if ( test_range_squared > knockdown_range_squared )
		{
			zombies[i] riotshield_debug_print( "range", (1, 0, 0) );
			return; // everything else in the list will be out of range
		}

		normal = VectorNormalize( test_origin - view_pos );
		dot = VectorDot( forward_view_angles, normal );
		if ( 0 > dot )
		{
			// guy's behind us
			zombies[i] riotshield_debug_print( "dot", (1, 0, 0) );
			continue;
		}

		radial_origin = PointOnSegmentNearestToPoint( view_pos, end_pos, test_origin );
		if ( DistanceSquared( test_origin, radial_origin ) > cylinder_radius_squared )
		{
			// guy's outside the range of the cylinder of effect
			zombies[i] riotshield_debug_print( "cylinder", (1, 0, 0) );
			continue;
		}

		if ( 0 == zombies[i] DamageConeTrace( view_pos, self ) )
		{
			// guy can't actually be hit from where we are
			zombies[i] riotshield_debug_print( "cone", (1, 0, 0) );
			continue;
		}

		if ( test_range_squared < fling_range_squared )
		{
			level.riotshield_fling_enemies[level.riotshield_fling_enemies.size] = zombies[i];

			// the closer they are, the harder they get flung
			dist_mult = (fling_range_squared - test_range_squared) / fling_range_squared;
			fling_vec = VectorNormalize( test_origin - view_pos );

			// within 6 feet, just push them straight away from the player, ignoring radial motion
			if ( 5000 < test_range_squared )
			{
				fling_vec = fling_vec + VectorNormalize( test_origin - radial_origin );
			}
			fling_vec = (fling_vec[0], fling_vec[1], abs( fling_vec[2] ));
			fling_vec = VectorScale( fling_vec, 100 + 100 * dist_mult );
			level.riotshield_fling_vecs[level.riotshield_fling_vecs.size] = fling_vec;

			zombies[i] riotshield_debug_print( "fling", (0, 1, 0) );
//			zombies[i] thread setup_riotshield_vox( self, true, false, false );
		}
/*
		else if ( test_range_squared < gib_range_squared )
		{
			level.riotshield_knockdown_enemies[level.riotshield_knockdown_enemies.size] = zombies[i];
			level.riotshield_knockdown_gib[level.riotshield_knockdown_gib.size] = true;

//			zombies[i] thread setup_riotshield_vox( self, false, true, false );
		}
*/
		else
		{
			level.riotshield_knockdown_enemies[level.riotshield_knockdown_enemies.size] = zombies[i];
			level.riotshield_knockdown_gib[level.riotshield_knockdown_gib.size] = false;

//			zombies[i] thread setup_riotshield_vox( self, false, false, true );
			zombies[i] riotshield_debug_print( "knockdown", (1, 1, 0) );
		}
	}
}


riotshield_network_choke()
{
	level.riotshield_network_choke_count++;
	
	if ( !(level.riotshield_network_choke_count % 10) )
	{
		wait_network_frame();
		wait_network_frame();
		wait_network_frame();
	}
}


riotshield_melee()
{
	// ww: physics hit when firing
	PhysicsExplosionCylinder( self.origin, 600, 240, 1 );
	
	if ( !IsDefined( level.riotshield_knockdown_enemies ) )
	{
		level.riotshield_knockdown_enemies = [];
		level.riotshield_knockdown_gib = [];
		level.riotshield_fling_enemies = [];
		level.riotshield_fling_vecs = [];
	}

	self riotshield_get_enemies_in_range();

	//iprintlnbold( "flg: " + level.riotshield_fling_enemies.size + " gib: " + level.riotshield_gib_enemies.size + " kno: " + level.riotshield_knockdown_enemies.size );

	shield_damage = 0;

	level.riotshield_network_choke_count = 0;
	for ( i = 0; i < level.riotshield_fling_enemies.size; i++ )
	{
		riotshield_network_choke();
		level.riotshield_fling_enemies[i] thread riotshield_fling_zombie( self, level.riotshield_fling_vecs[i], i );
		shield_damage += level.zombie_vars["riotshield_fling_damage_shield"];
	}

	for ( i = 0; i < level.riotshield_knockdown_enemies.size; i++ )
	{
		riotshield_network_choke();
		level.riotshield_knockdown_enemies[i] thread riotshield_knockdown_zombie( self, level.riotshield_knockdown_gib[i] );
		shield_damage += level.zombie_vars["riotshield_knockdown_damage_shield"];
	}

	level.riotshield_knockdown_enemies = [];
	level.riotshield_knockdown_gib = [];
	level.riotshield_fling_enemies = [];
	level.riotshield_fling_vecs = [];

	if (shield_damage)
		self player_damage_shield( shield_damage, false );
}


trackStuckZombies()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	for ( ;; )
	{
		self waittill( "deployed_riotshield" );
		self thread watchStuckZombies();
	}
}

attack_shield(shield)
{
	self endon ("death"); // Jluyties 02/16/10 added death check, cause of crash 
	shield.owner endon( "death" );
	shield.owner endon( "disconnect" );
	shield.owner endon( "start_riotshield_deploy" );
	shield.owner endon( "destroy_riotshield" );
	if( !self.has_legs)
	{
		return false;
	}
	if ( isdefined(	self.doing_shield_attack ) && self.doing_shield_attack )
	{
		return false;
	}

	self.old_origin = self.origin;
	if(GetDvar( "zombie_shield_attack_freq") == "")
	{
		SetDvar("zombie_shield_attack_freq","15");
	}
	freq = GetDvarInt( "zombie_shield_attack_freq");
	
	// still very placeholder - based on the board reach-through anim

	//if( freq >= randomint(100) )
	{
		self.doing_shield_attack = 1;
		self.enemyoverride[0] = shield.origin;
		self.enemyoverride[1] = shield;
		wait ( randomint(100) / 100.0 );


		self thread maps\mp\zombies\_zm_audio::do_zombies_playvocals( "attack", self.animname );
		self AnimScripted( self.origin, self.angles, "zm_window_melee" ); 
		self window_notetracks( "window_melee_anim", shield.owner );

		if ( isdefined(shield.owner.player_shield_apply_damage))
			shield.owner [[shield.owner.player_shield_apply_damage]](100, false);
		else
			shield.owner player_damage_shield( 100, false );
		wait ( randomint(100) / 100.0 );
		self.doing_shield_attack = 0;
	}
}

window_notetracks(msg, player)
{
	self endon("death");

	while(1)
	{
		self waittill( msg, notetrack );

		if( notetrack == "end" )
		{
			return;
		}
		if( notetrack == "fire" )
		{
			player player_damage_shield( 100, false );
		}
	}
}



watchStuckZombies()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "start_riotshield_deploy" );
	self endon( "destroy_riotshield" );
	self endon( "deployed_riotshield" );
	level endon( "intermission" );
	while( 1 )
	{
		wait 1;

		dist = 50 * 50;
		ai = GetAiArray( "axis" );
		for( i = 0; i < ai.size; i++ )
		{
			if( DistanceSquared( ai[i].origin, self.riotshieldentity.origin ) < dist )
			{
				if( !is_true( ai[i].isscreecher ) )
				{
					ai[i] thread attack_shield(self.riotshieldentity);
				}
			}
		}

	}
}

riotshield_active()
{
	return(self maps\mp\zombies\_zm_equipment::is_equipment_active("riotshield_zm"));
}

riotshield_debug_print( msg, color )
{
/#
	if ( !GetDvarInt( "scr_riotshield_debug" ) )
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






//******************************************************************
//                                                                 *
// OBSOLETE                                                        *
//                                                                 *
//******************************************************************

shield_zombie_attract_func(poi)
{
}

shield_zombie_arrive_func(poi)
{
	self endon( "death" );
	self endon( "zombie_acquire_enemy" );
	//self endon( "bad_path" );
	self endon( "path_timer_done" );
	 
	// once goal hits the ai is at their poi and should die
	self waittill( "goal" );
	
	if (isdefined(poi.owner)) //riotshieldEntity))
	{
		//poi.riotshieldEntity.owner 
		poi.owner player_damage_shield( 100, false );
		if ( isdefined(poi.owner.player_shield_apply_damage))
			poi.owner [[poi.owner.player_shield_apply_damage]](100, false);
	}
}


createRiotShieldAttractor() // self == shield
{
	//create_zombie_point_of_interest( attract_dist, num_attractors, added_poi_value, start_turned_on, initial_attract_func, arrival_attract_func )
	self create_zombie_point_of_interest( 50, 8, 0, 1, ::shield_zombie_attract_func, ::shield_zombie_arrive_func );
	//create_zombie_point_of_interest_attractor_positions( num_attract_dists, diff_per_dist, attractor_width )
	self thread create_zombie_point_of_interest_attractor_positions( 4, 15, 15 );
	//self thread wait_for_attractor_positions_complete();
	return get_zombie_point_of_interest( self.origin );
}

//******************************************************************
//                                                                 *
// OBSOLETE                                                        *
//                                                                 *
//******************************************************************

watchRiotshieldAttractor() // self == player
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "start_riotshield_deploy" );
	self endon( "destroy_riotshield" );
	self endon( "deployed_riotshield" );

	poi = self.riotshieldEntity createRiotShieldAttractor();
}


trackRiotShieldAttractor()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	for ( ;; )
	{
		self waittill( "deployed_riotshield" );
		self thread watchRiotshieldAttractor();
	}
}

