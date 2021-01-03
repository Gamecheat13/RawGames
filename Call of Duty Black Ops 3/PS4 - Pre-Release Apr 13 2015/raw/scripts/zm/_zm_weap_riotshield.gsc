#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_riotshield;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                             
                                                                                                                               




#precache( "material", "riotshield_zm_icon" );
#precache( "string", "ZOMBIE_EQUIP_RIOTSHIELD_PICKUP_HINT_STRING" );

#namespace zm_equip_riotshield;

function autoexec __init__sytem__() {     system::register("zm_equip_riotshield",&__init__,&__main__,undefined);    }

function __init__()
{
	if(!isdefined(level.weaponRiotshield))level.weaponRiotshield=GetWeapon( "riotshield" );
	name = level.weaponRiotshield.name;
	
	_zm_riotshield::init();
	zombie_utility::set_zombie_var( "riotshield_cylinder_radius",		360 );
	zombie_utility::set_zombie_var( "riotshield_fling_range",			90 ); 
	zombie_utility::set_zombie_var( "riotshield_gib_range",				90 ); 
	zombie_utility::set_zombie_var( "riotshield_gib_damage",			75 );
	zombie_utility::set_zombie_var( "riotshield_knockdown_range",		90 ); 
	zombie_utility::set_zombie_var( "riotshield_knockdown_damage",		15 );

	zombie_utility::set_zombie_var( "riotshield_hit_points",			2250 );

	//damage applied to shield on melee
	zombie_utility::set_zombie_var( "riotshield_fling_damage_shield",			100 ); 
	zombie_utility::set_zombie_var( "riotshield_knockdown_damage_shield",		15 );

	level.riotshield_network_choke_count=0;
	level.riotshield_gib_refs = []; 
	level.riotshield_gib_refs[level.riotshield_gib_refs.size] = "guts"; 
	level.riotshield_gib_refs[level.riotshield_gib_refs.size] = "right_arm"; 
	level.riotshield_gib_refs[level.riotshield_gib_refs.size] = "left_arm"; 
	
	level.riotshield_damage_callback = &player_damage_shield;
	level.deployed_riotshield_damage_callback = &deployed_damage_shield;
	level.transferRiotShield = &transferRiotShield;
	level.canTransferRiotShield = &canTransferRiotShield;

	zm_spawner::register_zombie_damage_callback( &riotshield_zombie_damage_response );

	zm_equipment::register( name, &"ZOMBIE_EQUIP_RIOTSHIELD_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_RIOTSHIELD_HOWTO", "riotshield_zm_icon", "riotshield", &riotshield_activation_watcher_thread, undefined, &dropShield, &pickupShield ); //, &placeShield );
	zm_equipment::set_ammo_driven( name, level.weaponRiotshield.startammo );

	weaponobjects::createRetrievableHint("riotshield",  &"ZOMBIE_EQUIP_RIOTSHIELD_PICKUP_HINT_STRING");

	callback::on_connect( &onPlayerConnect);
}

function __main__()
{
	zm_equipment::register_for_level( "riotshield" );
	zm_equipment::include( "riotshield" );
	level thread watch_round_juke_ammo();
}

function onPlayerConnect()
{
	self.player_shield_reset_health = &player_init_shield_health;
	self.player_shield_apply_damage = &player_damage_shield;
	self.player_shield_reset_location = &player_init_shield_location;
	self thread watchRiotShieldUse();
	self thread watchRiotShieldMelee();
	self thread watchRiotShieldJuke();
	self thread player_watch_laststand();
}


function dropShield() // self == player
{
	self.shield_placement=0;
	self _zm_riotshield::UpdateRiotShieldModel();
	item = self zm_equipment::placed_equipment_think( "t6_wpn_zmb_shield_world", level.weaponRiotshield, self.origin+(0,0,30), self.angles );
	if (isdefined(item))
    {
		item.shieldDamageTaken = self.shieldDamageTaken;
		item.original_owner = self;
		item.owner = undefined;
		item.weapon = level.weaponRiotshield;
		item.isRiotShield = true;
		item deployed_damage_shield( 0 ); // update damage model if needed
		item SetScriptMoverFlag( 0 ); // SCRIPTMOVER_FLAG_RIOTSHIELD
 		item.requires_pickup = true;
 		item thread watchTooFriendly( self );
   }
	self TakeWeapon( level.weaponRiotshield );
	return item;
}

function watchTooFriendly( player )
{
	wait 1;
	if ( isdefined(self) && 
	     isdefined(player) &&
		Distance2DSquared( self.origin, player.origin ) < 6 * 6 )
	{
		if( IsAlive( player ) )
		{
			player playlocalsound( level.zmb_laugh_alias );
		}
		player zm_stats::increment_client_stat( "cheat_total",false );
		self deployed_damage_shield( 2000 ); 
	}
}


function pickupShield(item) // self == player
{
	item.owner = self;
	damage = item.shieldDamageTaken;
	damageMax = level.zombie_vars["riotshield_hit_points"]; 
	self.shieldDamageTaken = damage;
	self player_set_shield_health( damage, damageMax );
}

function placeShield(origin,angles) // self == player
{
	// BROKEN
	if ( self GetCurrentWeapon() != level.weaponRiotshield)
	{
		self SwitchToWeapon(level.weaponRiotshield);
		self waittill ( "weapon_change" );
	}
	item = self _zm_riotshield::DoRiotshieldDeploy(origin,angles);
	if (isdefined(item))
	{
		item.origin = self.origin+(0,0,30);
		item.angles = self.angles;
		item.owner = self;
	}
	return item;
}

function canTransferRiotShield( fromplayer, toplayer )
{
	if( IsDefined( toplayer.is_drinking ) && ( toplayer.is_drinking > 0 ) )
		return false;

	if( toplayer laststand::player_is_in_laststand() || toplayer zm_utility::in_revive_trigger() )
	{
		return false;
	}

	if( toplayer isThrowingGrenade() )
	{
		return false;
	}
	
	// you can pick up your own shield
	if ( fromplayer==toplayer )
		return true;

	// can't pick up if you already have one and it's not deployed
	if ( toplayer zm_equipment::is_player_equipment(level.weaponRiotshield) && toplayer.shield_placement!=3 ) 
		return false;

	// can't pick up if it's not from your team
	if ( fromplayer.session_team!=toplayer.session_team )
		return false;

	return true;
}

function transferRiotShield( fromplayer, toplayer )
{
	damage = fromplayer.shieldDamageTaken;
	toplayer _zm_riotshield::player_take_riotshield();
	fromplayer _zm_riotshield::player_take_riotshield();
	toplayer.shieldDamageTaken = damage;
	toplayer.shield_placement = 3;
	toplayer.shield_damage_level = 0;
	toplayer zm_equipment::give( level.weaponRiotshield );
	toplayer SwitchToWeapon( level.weaponRiotshield );
	damageMax = level.zombie_vars["riotshield_hit_points"]; 
	toplayer player_set_shield_health( damage, damageMax );
}

function player_watch_laststand()
{
	self endon( "disconnect" );
	
	while ( 1 )
	{
		self waittill( "entering_last_stand" );
		if ( self GetCurrentWeapon() == level.weaponRiotshield )
		{
			new_primary = self.laststandpistol;
			self GiveWeapon(new_primary);
			self SwitchToWeaponImmediate( new_primary );
		}
	}
}

function player_init_shield_health()
{
	retval = (self.shieldDamageTaken > 0);
	self.shieldDamageTaken=0;
	self.shield_damage_level=0;
	self _zm_riotshield::UpdateRiotShieldModel();
	return retval;
}

function player_init_shield_location()
{
	self.hasRiotShield=true;
	self.hasRiotShieldEquipped = false;
	self.shield_placement=2;
	self _zm_riotshield::UpdateRiotShieldModel();
}

function player_set_shield_health( damage, max_damage )
{
	shieldHealth = int( 100 * (max_damage - damage) / max_damage );
//iprintlnbold( "riot shield at " + shieldHealth + " percent strength" );
	if (shieldHealth >= 50)
		self.shield_damage_level=0;
	else if (shieldHealth >= 25)
		self.shield_damage_level=2;
	else
		self.shield_damage_level=3;
	self _zm_riotshield::UpdateRiotShieldModel();
}

function deployed_set_shield_health(damage, max_damage)
{
	shieldHealth = int( 100 * (max_damage - damage) / max_damage );
//iprintlnbold( "riot shield at " + shieldHealth + " percent strength" );
	if (shieldHealth >= 50)
		self.shield_damage_level=0;
	else if (shieldHealth >= 25)
		self.shield_damage_level=2;
	else
		self.shield_damage_level=3;
	self _zm_riotshield::UpdateStandaloneRiotShieldModel();
}

function player_damage_shield( iDamage, bHeld )
{
	// EOtodo - needs to be exposed for tuning
	damageMax = level.zombie_vars["riotshield_hit_points"]; 
	if (!IsDefined(self.shieldDamageTaken))
		self.shieldDamageTaken=0;

	self.shieldDamageTaken += iDamage;

	if( self.shieldDamageTaken >= damageMax  )
	{
		if( bHeld || !IsDefined( self.shield_ent ) )
		{
			self PlayRumbleOnEntity( "damage_heavy" );
			Earthquake( 1.0, 0.75, self.origin, 100 );
		}
		else if ( isdefined( self.shield_ent ) )
		{
			if ( ( isdefined( self.shield_ent.destroy_begun ) && self.shield_ent.destroy_begun ) )
			{
				return;
			}
			self.shield_ent.destroy_begun = true;

			shield_origin = self.shield_ent.origin;

			level thread zm_equipment::disappear_fx( shield_origin, level._riotshield_dissapear_fx );
			wait(1);
			PlaySoundAtPosition( "wpn_riotshield_zm_destroy" , shield_origin );
		}
		self thread _zm_riotshield::player_take_riotshield();
	}
	else
	{
		if( bHeld )
		{
			self PlayRumbleOnEntity( "damage_light" );
			Earthquake( 0.5, 0.5, self.origin, 100 );
		}
		self player_set_shield_health( self.shieldDamageTaken, damageMax );
		self PlaySound( "fly_riotshield_zm_impact_zombies" );//sound for zombie attacks hitting the shield while held
	}
}

function deployed_damage_shield( iDamage ) // self = shield
{
	// EOtodo - needs to be exposed for tuning
	damageMax = level.zombie_vars["riotshield_hit_points"]; 
	if (!IsDefined(self.shieldDamageTaken))
		self.shieldDamageTaken=0;

	self.shieldDamageTaken += iDamage;

	if( self.shieldDamageTaken >= damageMax  )
	{
		shield_origin = self.origin;

		if ( isdefined( self.stub ) )
		{
			thread zm_unitrigger::unregister_unitrigger(self.stub);
		}

		if (isdefined(self.original_owner))
			self.original_owner zm_equipment::take(level.weaponRiotshield);
		zm_equipment::disappear_fx( shield_origin, level._riotshield_dissapear_fx );
		PlaySoundAtPosition( "wpn_riotshield_zm_destroy" , shield_origin );
		zm_utility::self_delete();
	}
	else
	{
		self deployed_set_shield_health(self.shieldDamageTaken, damageMax);
	}
}


function riotshield_activation_watcher_thread()
{
	self endon("zombified");
	self endon("disconnect");
	self endon("riotshield_zm_taken");

	while(1)
	{
		self util::waittill_either("riotshield_zm_activate", "riotshield_zm_deactivate");
		// nothing 
	}
}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchRiotShieldUse() // self == player
{
	self endon( "death" );
	self endon( "disconnect" );

	self.shieldDamageTaken=0;

	// watcher for attaching the model to correct player bones
	self thread _zm_riotshield::trackRiotShield();
	self thread _zm_riotshield::trackEquipmentChange();
	self thread _zm_riotshield::watchShieldLastStand();
	//self thread trackRiotShieldAttractor();
	self thread trackStuckZombies();
	//self thread watchShieldKnockback();

	for ( ;; )
	{
		self waittill( "raise_riotshield" );
		if ( _zm_riotshield::riotshieldSupportsPlacement(level.weaponRiotshield) )
		{
			self thread _zm_riotshield::startRiotshieldDeploy();
		}
	}
}


function watchRiotShieldMelee() // self == player
{
	for ( ;; )
	{
		self waittill( "weapon_melee", weapon );
		if ( weapon == level.weaponRiotshield )
			self riotshield_melee();
	}
}

function watchRiotShieldJuke() // self == player
{
	for ( ;; )
	{
		self waittill( "weapon_melee_juke", weapon );
		if ( weapon == level.weaponRiotshield )
		{
			self DisableOffhandWeapons();
			self riotshield_melee_juke(weapon);
			self EnableOffhandWeapons();
		}
	}
}

function is_riotshield_damage( mod, player, amount ) 
{
	if( IsPlayer( player ) )  //check because robot companion can fire off this function, and internally requires a player
	{
		if ( mod == "MOD_MELEE" && player HasWeapon( level.weaponRiotshield ) && amount < 10 )
			return true;
	}
	return false;
}

function riotshield_damage( amount )
{
	// you get nothing for doing plain melee damage with the riot shield
}



function riotshield_fling_zombie( player, fling_vec, index )
{
	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us 
		return;
	}

	if (( isdefined( self.ignore_riotshield ) && self.ignore_riotshield ))
		return;
	
	if ( IsDefined( self.riotshield_fling_func ) )
	{
		self [[ self.riotshield_fling_func ]]( player );
		return;
	}
	
	damage = 2500;
	
	self playsound( "fly_rocketshield_hit_zombie" );
	self DoDamage( damage, player.origin, player, player, "", "MOD_IMPACT" );
	if ( self.health < 1 )
	{
		self.riotshield_death = true;
		self StartRagdoll();
		self LaunchRagdoll( fling_vec );
	}
	//self.ignore_riotshield=1;
}


function zombie_knockdown( player, gib )
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
			self.a.gib_ref = array::random( level.riotshield_gib_refs );
			self thread zombie_death::do_gib();
		}

		self DoDamage( damage, player.origin, player );
	}

}



function riotshield_knockdown_zombie( player, gib )
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
//	self.riotshield_handle_pain_notetracks = &handle_riotshield_pain_notetracks;
	self DoDamage( level.zombie_vars["riotshield_knockdown_damage"], player.origin, player );
	self playsound( "fly_riotshield_forcehit" );
	
}

function riotshield_get_enemies_in_range()
{
	view_pos = self geteye(); // GetViewPos(); //GetWeaponMuzzlePoint();
	zombies = array::get_all_closest( view_pos, zombie_utility::get_round_enemy_array(), undefined, undefined, 2 * level.zombie_vars["riotshield_knockdown_range"] );
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
		//test_origin = (test_origin[0], test_origin[1], view_pos[2] );
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


function riotshield_network_choke()
{
	level.riotshield_network_choke_count++;
	
	if ( !(level.riotshield_network_choke_count % 10) )
	{
		util::wait_network_frame();
		util::wait_network_frame();
		util::wait_network_frame();
	}
}


function riotshield_melee()
{
	// ww: physics hit when firing
	//PhysicsExplosionCylinder( self.origin, 600, 240, 1 );
	
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
		if (isdefined(level.riotshield_fling_enemies[i]))
		{
			level.riotshield_fling_enemies[i] thread riotshield_fling_zombie( self, level.riotshield_fling_vecs[i], i );
			shield_damage += level.zombie_vars["riotshield_fling_damage_shield"];
		}
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




function riotshield_melee_juke(weapon)
{
	self endon( "weapon_melee" );
	self endon( "weapon_melee_power" );
	self endon( "weapon_melee_charge" );
	
	start_time = GetTime(); 

	if(!isdefined(level.riotshield_knockdown_enemies))level.riotshield_knockdown_enemies=[];
	if(!isdefined(level.riotshield_knockdown_gib))level.riotshield_knockdown_gib=[];
	if(!isdefined(level.riotshield_fling_enemies))level.riotshield_fling_enemies=[];
	if(!isdefined(level.riotshield_fling_vecs))level.riotshield_fling_vecs=[];


	ammo = self GetWeaponAmmoClip( weapon );
	self SetWeaponAmmoClip( weapon, int(max(0,ammo-1)) );

	
/*	
	enemies = riotshield_get_juke_enemies_in_range();
	
	foreach( zombie in enemies )
	{
		//zombie Kill();
	}
*/	
	
	while( start_time + 3000 > GetTime() )
	{
		self PlayRumbleOnEntity( "zod_shield_juke" );
		forward = AnglesToForward(self GetPlayerAngles());
//		up = AnglesToUp(self GetPlayerAngles());
//		explorigin = self.origin + (15 * up) + (30 * forward);
		//self RadiusDamage( explorigin, RS_JUKE_MELEE_DAMAGE_RADIUS, RS_JUKE_MELEE_DAMAGE_AMOUNT, BEAST_MELEE_DAMAGE_AMOUNT, self, "MOD_MELEE" );
//		physicsExplosionSphere( explorigin, RS_JUKE_MELEE_DAMAGE_RADIUS, 1, 1, RS_JUKE_MELEE_DAMAGE_AMOUNT, RS_JUKE_MELEE_DAMAGE_AMOUNT );
		//PhysicsJetThrust( explorigin, forward, RS_JUKE_MELEE_DAMAGE_RADIUS, 1, 0.85 );
		
		enemies = riotshield_get_juke_enemies_in_range();
	
		foreach( zombie in enemies )
		{
			zombie thread riotshield_fling_zombie( self, zombie.fling_vec, 0 );
		}
	/*
		self riotshield_get_enemies_in_range();

		for ( i = 0; i < level.riotshield_fling_enemies.size; i++ )
		{
			if (isdefined(level.riotshield_fling_enemies[i]))
			{
				level.riotshield_fling_enemies[i] thread riotshield_fling_zombie( self, level.riotshield_fling_vecs[i], i );
			}
		}
		*/

		level.riotshield_knockdown_enemies = [];
		level.riotshield_knockdown_gib = [];
		level.riotshield_fling_enemies = [];
		level.riotshield_fling_vecs = [];

		
		//riotshield_melee(); 
		wait 0.1;
	}
}

function watch_round_juke_ammo()
{
	level waittill( "start_of_round" ); // skip the first round
	foreach( player in GetPlayers() )
	{
	}
	while ( 1 )
	{
		level waittill( "start_of_round" );
		foreach( player in GetPlayers() )
		{
			if ( player HasWeapon( level.weaponRiotshield ) )
			{
				player GiveStartAmmo( level.weaponRiotshield ); 
				//player SetWeaponAmmoClip( level.weaponRiotshield, 3 );
			}
		}
	}
}






function riotshield_get_juke_enemies_in_range()
{
	view_pos = self.origin; // GetViewPos(); //GetWeaponMuzzlePoint();
	zombies = array::get_all_closest( view_pos, zombie_utility::get_round_enemy_array(), undefined, undefined, (10 * 12) );
	if ( !isDefined( zombies ) )
	{
		return;
	}

	forward = AnglesToForward(self GetPlayerAngles());
	up = AnglesToUp(self GetPlayerAngles());
	segment_start = view_pos; 	
	segment_end = view_pos + ((10 * 12) * forward);

	enemies = [];
	
	for ( i = 0; i < zombies.size; i++ )
	{
		if ( !IsDefined( zombies[i] ) || !IsAlive( zombies[i] ) )
		{
			// guy died on us
			continue;
		}
		
		test_origin = zombies[i] getcentroid();

		radial_origin = PointOnSegmentNearestToPoint( segment_start, segment_end, test_origin );
		lateral = test_origin - radial_origin;
		len = Length(lateral);
		if ( len > (5 * 12) )
		{
			continue;
		}
	
		lateral = (lateral[0],lateral[1],0); 
		zombies[i].fling_vec = 200 * forward + randomfloatrange(50,60) * up; // + randomfloatrange(0,50) * (len / RIOTSHIELD_JUKE_KILL_HALFWIDTH) *lateral;
		
		
		enemies[enemies.size] = zombies[i];
	}
	
	return enemies; 
}



function trackStuckZombies()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	for ( ;; )
	{
		self waittill( "deployed_riotshield" );
		if ( isdefined(self.riotshieldentity) )
			self thread watchStuckZombies();
	}
}

function attack_shield(shield)
{
	self endon ("death"); // Jluyties 02/16/10 added death check, cause of crash 
	shield.owner endon( "death" );
	shield.owner endon( "disconnect" );
	shield.owner endon( "start_riotshield_deploy" );
	shield.owner endon( "destroy_riotshield" );

	if ( isdefined(	self.doing_shield_attack ) && self.doing_shield_attack )
	{
		return false;
	}

	self.old_origin = self.origin;
	if(GetDvarString( "zombie_shield_attack_freq") == "")
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


		self notify( "bhtn_action_notify", "attack" );
		
		attackAnim = "zm_riotshield_melee";
		
		if ( self.missingLegs )
		{
			attackAnim += "_crawl";
		}
		
		self OrientMode( "face point", shield.origin );
		self AnimScripted( self.origin, zm_utility::flat_angle( VectorToAngles( shield.origin - self.origin ) ), attackAnim );
		//self thread window_notetracks( "window_melee_anim", shield.owner );

		if ( isdefined(shield.owner.player_shield_apply_damage))
			shield.owner [[shield.owner.player_shield_apply_damage]](100, false);
		else
			shield.owner player_damage_shield( 100, false );
		
		self thread attack_shield_stop( shield );
		
		wait ( randomint(100) / 100.0 );
		self.doing_shield_attack = 0;
		
		self OrientMode( "face default" );
	}
}

function attack_shield_stop( shield )
{
	self notify( "attack_shield_stop" );
	self endon( "attack_shield_stop" );
	
	self endon( "death" );
	
	shield waittill( "death" );
	
	self StopAnimScripted();
	
	if ( ( isdefined( self.doing_shield_attack ) && self.doing_shield_attack ) )
	{
		breachAnim = "zm_riotshield_breakthrough";
		
		if ( self.missingLegs )
		{
			breachAnim += "_crawl";
		}
		
		self AnimScripted( self.origin, zm_utility::flat_angle( self.angles ), breachAnim );
	}
}

function window_notetracks(msg, player)
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



function watchStuckZombies()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "start_riotshield_deploy" );
	self endon( "destroy_riotshield" );
	self endon( "deployed_riotshield" );
	level endon( "intermission" );
	
	self.riotshieldentity zm_equipment::item_attract_zombies();
/*
	while( 1 )
	{
		wait 1;

		dist = 50 * 50;
		ai = GetAiTeamArray( level.zombie_team );
		for( i = 0; i < ai.size; i++ )
		{
			if ( isdefined( level.ignore_equipment ) )
			{
				if ( self [[ level.ignore_equipment ]]( ai[i] ) )
				{
					continue;
				}
			}

			if( isdefined(self.riotshieldentity) && DistanceSquared( ai[i].origin, self.riotshieldentity.origin ) < dist )
			{
				if( !IS_TRUE( ai[i].isscreecher ) && !ai[i] zm_utility::is_quad())
				{
					ai[i] thread attack_shield(self.riotshieldentity);
				}
			}
		}

	}
*/	
}

function riotshield_active()
{
	return(self zm_equipment::is_active(level.weaponRiotshield));
}

function riotshield_debug_print( msg, color )
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

function shield_zombie_attract_func(poi)
{
}

function shield_zombie_arrive_func(poi)
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


function createRiotShieldAttractor() // self == shield
{
	//zm_utility::create_zombie_point_of_interest( attract_dist, num_attractors, added_poi_value, start_turned_on, initial_attract_func, arrival_attract_func )
	self zm_utility::create_zombie_point_of_interest( 50, 8, 0, 1, &shield_zombie_attract_func, &shield_zombie_arrive_func );
	//zm_utility::create_zombie_point_of_interest_attractor_positions( num_attract_dists, diff_per_dist, attractor_width )
	self thread zm_utility::create_zombie_point_of_interest_attractor_positions( 4, 15, 15 );
	//self thread wait_for_attractor_positions_complete();
	return zm_utility::get_zombie_point_of_interest( self.origin );
}


function riotshield_zombie_damage_response( mod, hit_location, hit_origin, player, amount, weapon )
{
	if ( self is_riotshield_damage( mod, player, amount ) )
	{
		self riotshield_damage( amount );
		return true;
	}

	return false;
}


//******************************************************************
//                                                                 *
// OBSOLETE                                                        *
//                                                                 *
//******************************************************************

function watchRiotshieldAttractor() // self == player
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "start_riotshield_deploy" );
	self endon( "destroy_riotshield" );
	self endon( "deployed_riotshield" );

	poi = self.riotshieldEntity createRiotShieldAttractor();
}


function trackRiotShieldAttractor()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	for ( ;; )
	{
		self waittill( "deployed_riotshield" );
		self thread watchRiotshieldAttractor();
	}
}

function onBuyWeapon_RiotShield( player )
{
	if ( isdefined(player.player_shield_reset_health))
		player [[player.player_shield_reset_health]]();
	if ( isdefined(player.player_shield_reset_location))
		player [[player.player_shield_reset_location]]();
}
