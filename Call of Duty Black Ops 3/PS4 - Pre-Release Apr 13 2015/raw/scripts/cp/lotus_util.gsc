#using scripts\codescripts\struct;

#using scripts\cp\_cic_turret;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

 	               	                    
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "string", "CP_MI_CAIRO_LOTUS_GRAB_MINIGUN" );

//*****************************************************************************
// MINIGUN
//*****************************************************************************
function mobile_shop_setup( str_groupname, b_armory = false, b_turret_off = false, b_model_turret = false, str_model_turret_override, b_minigun_hidden = false )
{
	a_mobile_parts = GetEntArray( str_groupname , "groupname" );
	
	Assert( IsArray( a_mobile_parts ) && a_mobile_parts.size >= 3, "Make sure you are not just passing in the mobile armory." );
	
	a_destructibles = []; // for breakable pieces (script_brushmodels)
	a_models = []; // props (script_models) inside mobile shop
	a_weapons = []; // weapons
	foreach ( e_mobile_part in a_mobile_parts )
	{	
		if ( e_mobile_part.classname == "script_brushmodel" )
		{
			// mobile destructible pieces
			if ( e_mobile_part.targetname === "mobile_destructible" )
			{
				if ( isdefined( e_mobile_part.a_destructibles ) && e_mobile_part.a_destructibles.size > 0 )
				{
					e_mobile_part.a_destructibles = array::remove_undefined( e_mobile_part.a_destructibles );
				}
				
				e_mobile_part thread destructible_watch();
				if ( !isdefined( a_destructibles ) ) a_destructibles = []; else if ( !IsArray( a_destructibles ) ) a_destructibles = array( a_destructibles ); a_destructibles[a_destructibles.size]=e_mobile_part;;
			}
			else
			{
				if ( isdefined( e_mobile_part.a_miniguns ) && e_mobile_part.a_miniguns.size > 0 )
				{
					e_mobile_part.a_miniguns = array::remove_undefined( e_mobile_part.a_miniguns );
				}
				
				// mobile shop
				e_mobile_shop = e_mobile_part;
			}
		}
		else if( e_mobile_part.classname == "script_model" )
		{	
			if ( e_mobile_part.targetname === "mobile_weapon" )
			{
				if ( isdefined( e_mobile_part.a_weapons ) && e_mobile_part.a_weapons.size > 0 )
				{
					e_mobile_part.a_weapons = array::remove_undefined( e_mobile_part.a_weapons );
				}
				
				e_mobile_part Hide();
				
				// put prop pieces in a_mobile_props array
				if ( !isdefined( a_weapons ) ) a_weapons = []; else if ( !IsArray( a_weapons ) ) a_weapons = array( a_weapons ); a_weapons[a_weapons.size]=e_mobile_part;;
			}
			else
			{
				if ( isdefined( e_mobile_part.a_models ) && e_mobile_part.a_models.size > 0 )
				{
					e_mobile_part.a_models = array::remove_undefined( e_mobile_part.a_models );
				}
				
				// put prop pieces in a_mobile_props array
				if ( !isdefined( a_models ) ) a_models = []; else if ( !IsArray( a_models ) ) a_models = array( a_models ); a_models[a_models.size]=e_mobile_part;;
			}
		}
	}
	
	// remove all mobile shops & props in the general a_mobile_parts array; the turrets should be the only thing left in the general a_mobile_parts array
	ArrayRemoveValue( a_mobile_parts, e_mobile_shop  );
	a_mobile_parts = array::exclude( a_mobile_parts, a_destructibles );
	a_mobile_parts = array::exclude( a_mobile_parts, a_models );
	a_mobile_parts = array::exclude( a_mobile_parts, a_weapons );
	e_mobile_shop.a_destructibles = a_destructibles;
	e_mobile_shop.a_models = a_models;
	e_mobile_shop.a_weapons = a_weapons;
	
	a_mobile_models = ArrayCombine( a_destructibles, a_models, false, false );
	a_mobile_models = ArrayCombine( a_mobile_models, a_weapons, false, false );
	foreach( mdl_mobile_piece in a_mobile_models ) // link all mobile shop models to the mobile shop
	{
		mdl_mobile_piece LinkTo( e_mobile_shop );
	}

	if ( ( isdefined( b_armory ) && b_armory ) )
	{
		// go through all the turret spawners and setup them up
		foreach ( sp_minigun_auto in a_mobile_parts )
		{
			// spawn the turret and link it to the mobile shop
			if ( ( isdefined( b_model_turret ) && b_model_turret ) )
			{
				if( !isdefined( str_model_turret_override ) )
				{
					e_minigun_auto = util::spawn_model( "t6_wpn_minigun_world", sp_minigun_auto.origin + ( 0, 8, 46 ), sp_minigun_auto.angles );
				}
				else
				{
					e_minigun_auto = util::spawn_model( str_model_turret_override, sp_minigun_auto.origin, sp_minigun_auto.angles );	
				}
			}
			else
			{
				e_minigun_auto = spawner::simple_spawn_single( sp_minigun_auto );
				if ( ( isdefined( b_turret_off ) && b_turret_off ) )
				{
					e_minigun_auto cic_turret::cic_turret_off();
				}
			}
			
			e_minigun_auto LinkTo( e_mobile_shop );
			
			if ( ( isdefined( b_minigun_hidden ) && b_minigun_hidden ) )
			{
				e_minigun_auto Hide();
			}
			else
			{
				t_minigun_auto = e_minigun_auto minigun_usable( b_model_turret, b_minigun_hidden );
				t_minigun_auto LinkTo( e_mobile_shop );
			}
			
			if ( !isdefined( e_mobile_shop.a_miniguns ) )
			{
				e_mobile_shop.a_miniguns = [];
			}
			
			if ( !isdefined( e_mobile_shop.a_miniguns ) ) e_mobile_shop.a_miniguns = []; else if ( !IsArray( e_mobile_shop.a_miniguns ) ) e_mobile_shop.a_miniguns = array( e_mobile_shop.a_miniguns ); e_mobile_shop.a_miniguns[e_mobile_shop.a_miniguns.size]=e_minigun_auto;;
		}
	}
	
	return e_mobile_shop;
}

// self == weapon script_model
function mobile_weapon_usable( str_weapon )
{
	self Show();
	self oed::enable_keyline( true );
	
	// spawn the trigger for the turret and link it to the appropriate mobile shop
	t_weapon = spawn( "trigger_radius_use", self.origin );
	t_weapon TriggerIgnoreTeam();
	t_weapon SetHintString( &"CP_MI_CAIRO_LOTUS_GRAB_SMAW" );
	t_weapon SetCursorHint( "HINT_NOICON" );
	t_weapon EnableLinkTo();
	t_weapon.targetname = "trig_weapon";
	self.t_weapon = t_weapon;
	self thread mobile_weapon_pickup( t_weapon, str_weapon );
	
	return t_weapon;
}

// self == weapon script_model
function mobile_weapon_pickup( t_weapon, str_weapon )
{
	self endon( "death" );
	
	self thread mobile_weapon_cleanup();
	t_weapon waittill( "trigger", player );
	
	w_weapon = GetWeapon( str_weapon );
	n_ammo_total = w_weapon.clipSize + w_weapon.maxammo;
	n_ammo = player GetAmmoCount( w_weapon );
	if ( player HasWeapon( w_weapon ) && n_ammo >= n_ammo_total )
	{
		// reinitialize this thread again
		self thread mobile_weapon_pickup( t_weapon, str_weapon );
		
		return;
	}
	
	t_weapon Delete();
	player thread mobile_weapon_give( str_weapon );
	
	self notify( "mobile_weapon_cleanup" );
}

// self == weapon script_model
function mobile_weapon_cleanup()
{
	self endon( "death" );
	
	self waittill( "mobile_weapon_cleanup" );
	
	self Hide();
	
	if ( isdefined( self.t_weapon ) )
	{
		self.t_weapon Delete();
	}
}

// self == player
function mobile_weapon_give( str_weapon )
{
	self endon( "death" );
	
	w_weapon = GetWeapon( str_weapon );
	if ( self HasWeapon( w_weapon ) )
	{
		self GiveMaxAmmo( w_weapon );
		self SetWeaponAmmoClip( w_weapon, w_weapon.clipSize );
	}
	else
	{
		self GiveWeapon( w_weapon );
		self SwitchToWeapon( w_weapon );
		self notify( "weapon_given" );
	}
}

//*****************************************************************************
// MINIGUN
//*****************************************************************************
// self == minigun
function minigun_usable( b_model_turret, b_minigun_hidden )
{
	if ( ( isdefined( b_minigun_hidden ) && b_minigun_hidden ) )
	{
		self Show();
	}
	
	// spawn the trigger for the turret and link it to the appropriate mobile shop
	t_minigun_auto = spawn( "trigger_radius_use", self.origin );
	t_minigun_auto TriggerIgnoreTeam();
	t_minigun_auto SetHintString( &"CP_MI_CAIRO_LOTUS_GRAB_MINIGUN" );
	t_minigun_auto SetCursorHint( "HINT_NOICON" );
	t_minigun_auto EnableLinkTo();
	t_minigun_auto.targetname = "trig_minigun";
	self.t_minigun_auto = t_minigun_auto;
	self thread minigun_pickup( t_minigun_auto, b_model_turret, b_minigun_hidden );
	
	// if a player already have a minigun, do not let that player see the trigger
	w_minigun = GetWeapon( "minigun_lotus" );
	foreach ( player in level.players )
	{
		if ( player HasWeapon( w_minigun ) )
		{
			t_minigun_auto SetInvisibleToPlayer( player );
		}
	}
	
	return t_minigun_auto;
}

// self == auto minigun
function minigun_pickup( t_minigun_auto, b_model_turret, b_minigun_hidden )
{
	self endon( "death" );
	
	self thread minigun_turret_cleanup( b_model_turret, b_minigun_hidden );
	t_minigun_auto waittill( "trigger", player );
	
	w_minigun = GetWeapon( "minigun_lotus" );
	if ( player HasWeapon( w_minigun ) )
	{
		// reinitialize this thread again
		self thread minigun_pickup( t_minigun_auto, b_model_turret, b_minigun_hidden );
			
		return;
	}
	
	t_minigun_auto Delete();
	player thread minigun_give();
	if ( !( isdefined( player.lotus_minigun_damage_callback_applied ) && player.lotus_minigun_damage_callback_applied ) ) 
	{
		player.lotus_minigun_damage_callback_applied=true;
		player.previous_damage_callback = player.overridePlayerDamage;	// save damage override function in case one has already been set
		player.overridePlayerDamage = &player_minigun_damage_override;
	}
	
	self notify( "minigun_picked_up" );
	level notify( "minigun_turret_picked_up" );
	
	// the player just picked up a minigun, so all the other minigun triggers need to be invisible to him
	a_minigun_triggers = GetEntArray( "trig_minigun", "targetname" );
	foreach ( t_minigun in a_minigun_triggers )
	{
		t_minigun SetInvisibleToPlayer( player );
	}
	
	objectives::complete( "cp_level_lotus_minigun", self );
	objectives::hide( "cp_level_lotus_minigun", player );
	self notify( "minigun_turret_cleanup" );
}

// self == player
function player_minigun_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, w_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime )
{
	if ( e_attacker === self )
	{
		n_damage = 0;
	}
	else
	{
		// support the previously set damage override function	
		if( isdefined( self.previous_damage_callback ) )
		{
			n_damage = [[ self.previous_damage_callback ]]( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, w_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime );
		}
	}
	
	return n_damage;
}

// self == auto minigun
function minigun_turret_cleanup( b_model_turret, b_minigun_hidden )
{
	self endon( "death" );
	
	self waittill( "minigun_turret_cleanup" );
	
	if ( ( isdefined( b_model_turret ) && b_model_turret ) )
	{
		if ( ( isdefined( b_minigun_hidden ) && b_minigun_hidden ) )
		{
			self Hide();
		}
		else
		{
			self Delete();
		}
	}
	else
	{
		self.delete_on_death = true;           self notify( "death" );           if( !IsAlive( self ) )           self Delete();;
	}
}

// self == player
function minigun_give( n_minigun_ammo )
{
	self endon( "death" );
	
	w_minigun = GetWeapon( "minigun_lotus" );
	self GiveWeapon( w_minigun );
	self SwitchToWeapon( w_minigun );
	self notify( "minigun_given" );
}

// self == player
function keeping_up_with_minigun_ammo_count( w_weapon )
{
	self endon( "death" );
	self endon( "drop_minigun" );
	
	n_ammo = self GetAmmoCount( w_weapon );
	while ( n_ammo > 0 )
	{
		self.n_minigun_ammo = n_ammo;
		n_ammo = self GetAmmoCount( w_weapon );
		
		wait 0.05;
	}
	
	self.n_minigun_ammo = n_ammo;
}

// self == player
function waittill_minigun_need_to_drop()
{
	self endon( "death" );
	self endon( "drop_minigun" );
	
	// it takes 2 "weapon_change" notifies to lower the minigun and bring up the pistol
	self waittill( "weapon_change" );
	self waittill( "weapon_change" );
	
	self notify( "drop_minigun" );
}

// self == player
function minigun_drop( n_minigun_ammo )
{
	self endon( "death" );
	
	w_weapon = GetWeapon( "minigun_lotus" );
	self TakeWeapon( w_weapon );
	self notify( "minigun_took_away" );
	
	m_minigun = util::spawn_model( "t6_wpn_minigun_world", self.origin + ( 0, 0, 12 ), self.angles );
	m_minigun PhysicsLaunch( m_minigun.origin, ( 0, 0, 0 ) );
	m_minigun.n_minigun_ammo = self.n_minigun_ammo;
	self.n_minigun_ammo = undefined;
	
	t_minigun = spawn( "trigger_radius_use", m_minigun.origin );
	t_minigun TriggerIgnoreTeam();
	t_minigun SetCursorHint( "HINT_NOICON" );
	t_minigun EnableLinkTo();
	t_minigun LinkTo( m_minigun );
//	t_minigun waittill( "trigger", player );
//	
//	player thread minigun_give( m_minigun.n_minigun_ammo );
//	
//	m_minigun Delete();
//	t_minigun Delete();
	
//	while ( true )
//	{
//		wait 0.05;
//		
//		m_minigun PhysicsLaunch( m_minigun.origin, ( 0, 0, 0 ) );
//	}
}

//*****************************************************************************
// JUICED SHOTGUN
//*****************************************************************************
function juiced_shotgun_trigger_setup()
{
	a_triggers = GetEntArray( "trig_juiced_shotgun", "targetname" );
	
	foreach( t_juiced_shotgun in a_triggers )
	{
		t_juiced_shotgun TriggerEnable( true );
		t_juiced_shotgun SetHintString( &"CP_MI_CAIRO_LOTUS_GRAB_SHOTGUN" );
		t_juiced_shotgun thread juiced_shotgun_watcher();
	}
}

// self == trigger
function juiced_shotgun_watcher()
{
	self endon( "death" );
	
	w_juiced_shotgun = GetWeapon( "shotgun_pump_taser" );
	
	while ( true )
	{
		self waittill( "trigger", e_player );
		
		//check if they already have one	
		if ( !e_player HasWeapon( w_juiced_shotgun ) )
		{
			e_player GiveWeapon( w_juiced_shotgun );
		}
		
		e_player SwitchToWeapon( w_juiced_shotgun );
	}
}

//*****************************************************************************
// GENERIC ROGUE CONTROL ROBOTS
//*****************************************************************************
function spawn_funcs_generic_rogue_control()
{
	spawner::add_spawn_function_group( "robot_level_1", "script_noteworthy", &ai::set_behavior_attribute, "rogue_control", "level_1" );
	spawner::add_spawn_function_group( "robot_level_2", "script_noteworthy", &ai::set_behavior_attribute, "rogue_control", "level_2" );
	spawner::add_spawn_function_group( "robot_level_3", "script_noteworthy", &ai::set_behavior_attribute, "rogue_control", "level_3" );
	spawner::add_spawn_function_group( "robot_forced_level_1", "script_noteworthy", &ai::set_behavior_attribute, "rogue_control", "forced_level_1" );
	spawner::add_spawn_function_group( "robot_forced_level_2", "script_noteworthy", &ai::set_behavior_attribute, "rogue_control", "forced_level_2" );
	spawner::add_spawn_function_group( "robot_forced_level_3", "script_noteworthy", &ai::set_behavior_attribute, "rogue_control", "forced_level_3" );
}

//*****************************************************************************
// DESTRUCTIBLE COVER
//*****************************************************************************
// self == script_brushmodel
function destructible_watch()
{
	self endon( "death" );
	
	self SetCanDamage( true );
	self.health = 10000;
	
	while ( true )
	{
		self waittill( "damage", n_damage, e_attacker, v_vector, v_point, str_means_of_death, str_string_1, str_string_2, str_string_3, w_weapon );
		
		// can only be blown up by missiles or raps
		if ( e_attacker.vehicletype === "veh_bo3_mil_gunship_nrc" && ( str_means_of_death == "MOD_PROJECTILE" || str_means_of_death == "MOD_PROJECTILE_SPLASH" ) )
		{
			self Hide();
			self NotSolid();
		}
		
		self.health = 10000;
		
		wait 0.05;
	}
}

//*****************************************************************************
// ENEMIES ON FIRE
//*****************************************************************************
function enemy_on_fire( do_the_robot )	// self == enemy to burn
{
	if( GetDvarint("ai_spawn_only_zombies") == 1 )
	{
		type = "human";
		PlayFXOnTag( level._effect[ "burn_loop_" + type + "_torso" ], 		self, "j_mainroot" );
		return;
	}
		
// TODO: add some random chance in here so we're not playing 10 FX on every single burning robot/human. Checking in this way so FX dept can check their work easily
	if( do_the_robot )
	{
		type = "robot";	// TODO: figure out why robot FX aren't visible, but human ones are.  weird.
	}
	else
	{
		type = "human";
	}

	PlayFXOnTag( level._effect[ "burn_loop_" + type + "_left_arm" ], 	self, "j_shoulder_le_rot" );
	PlayFXOnTag( level._effect[ "burn_loop_" + type + "_left_arm" ], 	self, "j_elbow_le_rot" );
	PlayFXOnTag( level._effect[ "burn_loop_" + type + "_right_arm" ], 	self, "j_shoulder_ri_rot" );
	PlayFXOnTag( level._effect[ "burn_loop_" + type + "_right_arm" ], 	self, "j_elbow_ri_rot" );
	PlayFXOnTag( level._effect[ "burn_loop_" + type + "_left_leg" ], 	self, "j_hip_le" );
	PlayFXOnTag( level._effect[ "burn_loop_" + type + "_left_leg" ], 	self, "j_knee_le" );
	PlayFXOnTag( level._effect[ "burn_loop_" + type + "_right_leg" ], 	self, "j_hip_ri" );
	PlayFXOnTag( level._effect[ "burn_loop_" + type + "_right_leg" ], 	self, "j_knee_ri" );
	PlayFXOnTag( level._effect[ "burn_loop_" + type + "_head" ], 		self, "j_head" );
	PlayFXOnTag( level._effect[ "burn_loop_" + type + "_torso" ], 		self, "j_mainroot" );
}