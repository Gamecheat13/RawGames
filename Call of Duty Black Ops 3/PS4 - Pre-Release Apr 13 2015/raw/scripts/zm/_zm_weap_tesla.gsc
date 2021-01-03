#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\zombie_utility;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weapons;

//#using scripts\zm\_zm_ai_avogadro;

//#using scripts\zm\_zm_deadpool;

#precache( "fx", "zombie/fx_tesla_bolt_secondary_zmb" );
#precache( "fx", "zombie/fx_tesla_shock_zmb" );
#precache( "fx", "zombie/fx_tesla_rail_view_zmb" );
#precache( "fx", "zombie/fx_tesla_tube_view_zmb" );
#precache( "fx", "zombie/fx_tesla_tube_view2_zmb" );
#precache( "fx", "zombie/fx_tesla_tube_view3_zmb" );
#precache( "fx", "zombie/fx_tesla_rail_view_ug_zmb" );
#precache( "fx", "zombie/fx_tesla_tube_view_ug_zmb" );
#precache( "fx", "zombie/fx_tesla_tube_view2_ug_zmb" );
#precache( "fx", "zombie/fx_tesla_tube_view3_ug_zmb" );
#precache( "fx", "zombie/fx_tesla_shock_eyes_zmb" );

// T7 TODO
// Restore Removed GDT Entries
// Trail Effect: fx\_t6\maps\zombie\fx_zombie_tesla_electric_bolt.efx
// Trail Effect (upgraded tesla gun): fx\_t6\maps\zombie\fx_zombie_tesla_ug_elec_bolt.efx

function init()
{
	level.weaponZMTeslaGun = GetWeapon( "tesla_gun" );
	level.weaponZMTeslaGunUpgraded = GetWeapon( "tesla_gun_upgraded" );
	if ( !zm_weapons::is_weapon_included( level.weaponZMTeslaGun ) && !( isdefined( level.uses_tesla_powerup ) && level.uses_tesla_powerup ) )
	{
		return;
	}

	level._effect["tesla_bolt"]				= "zombie/fx_tesla_bolt_secondary_zmb";
	level._effect["tesla_shock"]			= "zombie/fx_tesla_shock_zmb";
	level._effect["tesla_shock_secondary"]	= "zombie/fx_tesla_bolt_secondary_zmb";

	level._effect["tesla_viewmodel_rail"]	= "zombie/fx_tesla_rail_view_zmb";
	level._effect["tesla_viewmodel_tube"]	= "zombie/fx_tesla_tube_view_zmb";
	level._effect["tesla_viewmodel_tube2"]	= "zombie/fx_tesla_tube_view2_zmb";
	level._effect["tesla_viewmodel_tube3"]	= "zombie/fx_tesla_tube_view3_zmb";
	level._effect["tesla_viewmodel_rail_upgraded"]	= "zombie/fx_tesla_rail_view_ug_zmb";
	level._effect["tesla_viewmodel_tube_upgraded"]	= "zombie/fx_tesla_tube_view_ug_zmb";
	level._effect["tesla_viewmodel_tube2_upgraded"]	= "zombie/fx_tesla_tube_view2_ug_zmb";
	level._effect["tesla_viewmodel_tube3_upgraded"]	= "zombie/fx_tesla_tube_view3_ug_zmb";

	level._effect["tesla_shock_eyes"]		= "zombie/fx_tesla_shock_eyes_zmb";
	
	zm_spawner::register_zombie_damage_callback( &tesla_zombie_damage_response );
	zm_spawner::register_zombie_death_animscript_callback( &tesla_zombie_death_response );
	
	zombie_utility::set_zombie_var( "tesla_max_arcs",			5 );
	zombie_utility::set_zombie_var( "tesla_max_enemies_killed", 10 );
	zombie_utility::set_zombie_var( "tesla_radius_start",		300 );
	zombie_utility::set_zombie_var( "tesla_radius_decay",		20 );
	zombie_utility::set_zombie_var( "tesla_head_gib_chance",	75 );
	zombie_utility::set_zombie_var( "tesla_arc_travel_time",	0.11, true );
	zombie_utility::set_zombie_var( "tesla_kills_for_powerup",	10 );
	zombie_utility::set_zombie_var( "tesla_min_fx_distance",	128 );
	zombie_utility::set_zombie_var( "tesla_network_death_choke",4 );
	
	// T7 TODO - Find out how these are actually supposed to be populated and match the animations accordingly.
	//
	level._zombie_tesla_death = [];
	level._zombie_tesla_death["zombie"] = array( "ai_zombie_tesla_death_a", "ai_zombie_tesla_death_b", "ai_zombie_tesla_death_c", "ai_zombie_tesla_death_d", "ai_zombie_tesla_death_e" );
	level._zombie_tesla_crawl_death = [];
	level._zombie_tesla_crawl_death["zombie"] = array( "ai_zombie_tesla_death_a", "ai_zombie_tesla_death_b", "ai_zombie_tesla_death_c", "ai_zombie_tesla_death_d", "ai_zombie_tesla_death_e" );

/#
	level thread tesla_devgui_dvar_think();
#/
	
	callback::on_spawned( &on_player_spawned );
}


/#
function tesla_devgui_dvar_think()
{
	if ( !zm_weapons::is_weapon_included( level.weaponZMTeslaGun ) )
	{
		return;
	}

	SetDvar( "scr_tesla_max_arcs", level.zombie_vars["tesla_max_arcs"] ); 
	SetDvar( "scr_tesla_max_enemies", level.zombie_vars["tesla_max_enemies_killed"] ); 
	SetDvar( "scr_tesla_radius_start", level.zombie_vars["tesla_radius_start"] );
	SetDvar( "scr_tesla_radius_decay", level.zombie_vars["tesla_radius_decay"] );
	SetDvar( "scr_tesla_head_gib_chance", level.zombie_vars["tesla_head_gib_chance"] );
	SetDvar( "scr_tesla_arc_travel_time", level.zombie_vars["tesla_arc_travel_time"] );

	for ( ;; )
	{
		level.zombie_vars["tesla_max_arcs"]				= GetDvarInt( "scr_tesla_max_arcs" );
		level.zombie_vars["tesla_max_enemies_killed"]	= GetDvarInt( "scr_tesla_max_enemies" );
		level.zombie_vars["tesla_radius_start"]			= GetDvarInt( "scr_tesla_radius_start" );
		level.zombie_vars["tesla_radius_decay"]			= GetDvarInt( "scr_tesla_radius_decay" );
		level.zombie_vars["tesla_head_gib_chance"]		= GetDvarInt( "scr_tesla_head_gib_chance" );
		level.zombie_vars["tesla_arc_travel_time"]		= GetDvarFloat( "scr_tesla_arc_travel_time" );

		wait( 0.5 );
	}
}
#/


function tesla_damage_init( hit_location, hit_origin, player )
{
	player endon( "disconnect" );

	if ( IsDefined( player.tesla_enemies_hit ) && player.tesla_enemies_hit > 0 )
	{
		zm_utility::debug_print( "TESLA: Player: '" + player.name + "' currently processing tesla damage" );
		return;
	}

	if( IsDefined( self.zombie_tesla_hit ) && self.zombie_tesla_hit )
	{
		// can happen if an enemy is marked for tesla death and player hits again with the tesla gun
		return;
	}

	zm_utility::debug_print( "TESLA: Player: '" + player.name + "' hit with the tesla gun" );

	//TO DO Add Tesla Kill Dialog thread....
	
	player.tesla_enemies = undefined;
	player.tesla_enemies_hit = 1;
	player.tesla_powerup_dropped = false;
	player.tesla_arc_count = 0;
	
	self tesla_arc_damage( self, player, 1 );
	
	if( player.tesla_enemies_hit >= 4)
	{
		player thread tesla_killstreak_sound();
	}

	player.tesla_enemies_hit = 0;
}


// this enemy is in the range of the source_enemy's tesla effect
function tesla_arc_damage( source_enemy, player, arc_num )
{
	player endon( "disconnect" );

	zm_utility::debug_print( "TESLA: Evaulating arc damage for arc: " + arc_num + " Current enemies hit: " + player.tesla_enemies_hit );

	tesla_flag_hit( self, true );
	util::wait_network_frame();

	radius_decay = level.zombie_vars["tesla_radius_decay"] * arc_num;
	enemies = tesla_get_enemies_in_area( self GetTagOrigin( "j_head" ), level.zombie_vars["tesla_radius_start"] - radius_decay, player );
	tesla_flag_hit( enemies, true );

	self thread tesla_do_damage( source_enemy, arc_num, player );

	zm_utility::debug_print( "TESLA: " + enemies.size + " enemies hit during arc: " + arc_num );
			
	for( i = 0; i < enemies.size; i++ )
	{
		if( enemies[i] == self )
		{
			continue;
		}
		
		if ( tesla_end_arc_damage( arc_num + 1, player.tesla_enemies_hit ) )
		{			
			tesla_flag_hit( enemies[i], false );
			continue;
		}

		player.tesla_enemies_hit++;
		enemies[i] tesla_arc_damage( self, player, arc_num + 1 );
	}
}


function tesla_end_arc_damage( arc_num, enemies_hit_num )
{
	if ( arc_num >= level.zombie_vars["tesla_max_arcs"] )
	{
		zm_utility::debug_print( "TESLA: Ending arcing. Max arcs hit" );
		return true;
		//TO DO Play Super Happy Tesla sound
	}

	if ( enemies_hit_num >= level.zombie_vars["tesla_max_enemies_killed"] )
	{
		zm_utility::debug_print( "TESLA: Ending arcing. Max enemies killed" );		
		return true;
	}

	radius_decay = level.zombie_vars["tesla_radius_decay"] * arc_num;
	if ( level.zombie_vars["tesla_radius_start"] - radius_decay <= 0 )
	{
		zm_utility::debug_print( "TESLA: Ending arcing. Radius is less or equal to zero" );
		return true;
	}

	return false;
	//TO DO play Tesla Missed sound (sad)
}


function tesla_get_enemies_in_area( origin, distance, player )
{
	/#
		level thread tesla_debug_arc( origin, distance );
	#/
	
	distance_squared = distance * distance;
	enemies = [];

	if ( !IsDefined( player.tesla_enemies ) )
	{
		player.tesla_enemies = zombie_utility::get_round_enemy_array();
		player.tesla_enemies = array::get_all_closest( origin, player.tesla_enemies );
	}

	zombies = player.tesla_enemies; 

	if ( IsDefined( zombies ) )
	{
		for ( i = 0; i < zombies.size; i++ )
		{
			if ( !IsDefined( zombies[i] ) )
			{
				continue;
			}

			test_origin = zombies[i] GetTagOrigin( "j_head" );

			if ( IsDefined( zombies[i].zombie_tesla_hit ) && zombies[i].zombie_tesla_hit == true )
			{
				continue;
			}

			if ( zm_utility::is_magic_bullet_shield_enabled( zombies[i] ) )
			{
				continue;
			}

			if ( DistanceSquared( origin, test_origin ) > distance_squared )
			{
				continue;
			}

			if ( !BulletTracePassed( origin, test_origin, false, undefined ) )
			{
				continue;
			}

			enemies[enemies.size] = zombies[i];
		}
	}

	return enemies;
}


function tesla_flag_hit( enemy, hit )
{
	if( IsArray( enemy ) )
	{
		for( i = 0; i < enemy.size; i++ )
		{
			enemy[i].zombie_tesla_hit = hit;
		}
	}
	else
	{
		enemy.zombie_tesla_hit = hit;
	}
}


function tesla_do_damage( source_enemy, arc_num, player )
{
	player endon( "disconnect" );

	if ( arc_num > 1 )
	{
		wait( randomfloatrange( 0.2, 0.6 ) * arc_num );
	}

	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us 
		return;
	}

	if ( !self.isdog )
	{
		if( !self.missingLegs )
		{
			self.deathanim = array::random( level._zombie_tesla_death[self.animname] );
		}
		else
		{
			self.deathanim = array::random( level._zombie_tesla_crawl_death[self.animname] );
		}
	}
	else
	{
		self.a.nodeath = undefined;
	}
	
	if( ( isdefined( self.is_traversing ) && self.is_traversing ))
	{
		self.deathanim = undefined;
	}

	if( IsDefined( source_enemy ) && source_enemy != self )
	{
		if ( player.tesla_arc_count > 3 )
		{
			util::wait_network_frame();
			player.tesla_arc_count = 0;
		}
		
		player.tesla_arc_count++;
		source_enemy tesla_play_arc_fx( self );
	}

	while ( player.tesla_network_death_choke > level.zombie_vars["tesla_network_death_choke"] )
	{
		zm_utility::debug_print( "TESLA: Choking Tesla Damage. Dead enemies this network frame: " + player.tesla_network_death_choke );		
		{wait(.05);}; 
	}

	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us 
		return;
	}

	player.tesla_network_death_choke++;

	self.tesla_death = true;
	self tesla_play_death_fx( arc_num );
	
	// use the origin of the arc orginator so it pics the correct death direction anim
	origin = player.origin;
	if ( IsDefined( source_enemy ) && source_enemy != self  )
	{
		origin = source_enemy.origin;
	}

	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us 
		return;
	}
	
	if ( IsDefined( self.tesla_damage_func ) )
	{
		self [[ self.tesla_damage_func ]]( origin, player );
		return;
	}
	else
	{
		self DoDamage( self.health + 666, origin, player );
	}
	player zm_score::player_add_points( "death", "", "" );

// 	if ( !player.tesla_powerup_dropped && player.tesla_enemies_hit >= level.zombie_vars["tesla_kills_for_powerup"] )
// 	{
// 		player.tesla_powerup_dropped = true;
// 		level.zombie_vars["zombie_drop_item"] = 1;
// 		level thread zm_powerups::powerup_drop( self.origin );
// 	}
}


function tesla_play_death_fx( arc_num )
{
	tag = "J_SpineUpper";
	fx = "tesla_shock";

	if ( self.isdog )
	{
		tag = "J_Spine1";
	}

	if ( arc_num > 1 )
	{
		fx = "tesla_shock_secondary";
	}

	zm_net::network_safe_play_fx_on_tag( "tesla_death_fx", 2, level._effect[fx], self, tag );
	self playsound( "wpn_imp_tesla" );

	if ( IsDefined( self.tesla_head_gib_func ) && !self.head_gibbed )
	{
		[[ self.tesla_head_gib_func ]]();
	}
}


function tesla_play_arc_fx( target )
{
	if ( !IsDefined( self ) || !IsDefined( target ) )
	{
		// TODO: can happen on dog exploding death
		wait( level.zombie_vars["tesla_arc_travel_time"] );
		return;
	}
	
	tag = "J_SpineUpper";

	if ( self.isdog )
	{
		tag = "J_Spine1";
	}

	target_tag = "J_SpineUpper";

	if ( target.isdog )
	{
		target_tag = "J_Spine1";
	}
	
	origin = self GetTagOrigin( tag );
	target_origin = target GetTagOrigin( target_tag );
	distance_squared = level.zombie_vars["tesla_min_fx_distance"] * level.zombie_vars["tesla_min_fx_distance"];

	if ( DistanceSquared( origin, target_origin ) < distance_squared )
	{
		zm_utility::debug_print( "TESLA: Not playing arcing FX. Enemies too close." );		
		return;
	}
	
	fxOrg = spawn( "script_model", origin );
	fxOrg SetModel( "tag_origin" );

	fx = PlayFxOnTag( level._effect["tesla_bolt"], fxOrg, "tag_origin" );
	//playsoundatposition( "wpn_tesla_bounce", fxOrg.origin );
	fxOrg PlaySoundOnTag("wpn_tesla_bounce", "tag_origin");
	fxOrg MoveTo( target_origin, level.zombie_vars["tesla_arc_travel_time"] );
	fxOrg waittill( "movedone" );
	fxOrg delete();
}


function tesla_debug_arc( origin, distance )
{
/#
	if ( GetDvarInt( "zombie_debug" ) != 3 )
	{
		return;
	}

	start = GetTime();

	while( GetTime() < start + 3000 )
	{
		//_teargrenades::drawcylinder( origin, distance, 1 );
		{wait(.05);}; 
	}
#/
}


function is_tesla_damage( mod )
{
	return (self.damageweapon == level.weaponZMTeslaGun || self.damageweapon == level.weaponZMTeslaGunUpgraded ) && (mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH");
}

function enemy_killed_by_tesla()
{
	return ( isdefined( self.tesla_death ) && self.tesla_death );
}


function on_player_spawned()
{
	self thread tesla_sound_thread(); 
	self thread tesla_pvp_thread();
	self thread tesla_network_choke();
}


function tesla_sound_thread()
{
	self endon( "disconnect" );
			
	if(!IsDefined (self.tesla_loop_sound))
	{
		self.tesla_loop_sound = spawn ("script_origin", self.origin);
		self.tesla_loop_sound linkto(self);
	}

	for( ;; )
	{
		result = self util::waittill_any_return( "grenade_fire", "death", "player_downed", "weapon_change", "grenade_pullback" );		

		if ( !IsDefined( result ) )
		{
			continue;
		}

		if( ( result == "weapon_change" || result == "grenade_fire" ) && (self GetCurrentWeapon() == level.weaponZMTeslaGun || self GetCurrentWeapon() == level.weaponZMTeslaGunUpgraded) )
		{
				

			
			self.tesla_loop_sound PlayLoopSound( "wpn_tesla_idle", 0.25 );
			self thread tesla_engine_sweets();

		}
		else
		{
			self notify ("weap_away");
			self.tesla_loop_sound StopLoopSound(0.25);
		}
	}
}

function tesla_engine_sweets()
{

	self endon( "disconnect" ); 
	self endon ("weap_away");
	while(1)
	{
		wait(randomintrange(7,15));
		self play_tesla_sound ("wpn_tesla_sweeps_idle");
	}
}

function tesla_pvp_thread()
{
	self endon( "disconnect" );
	self endon( "death" );

	for( ;; )
	{
		self waittill( "weapon_pvp_attack", attacker, weapon, damage, mod );

		if( self laststand::player_is_in_laststand() )
		{
			continue;
		}

		if ( weapon != level.weaponZMTeslaGun && weapon != level.weaponZMTeslaGunUpgraded )
		{
			continue;
		}

		if ( mod != "MOD_PROJECTILE" && mod != "MOD_PROJECTILE_SPLASH" )
		{
			continue;
		}

		if ( self == attacker )
		{
			damage = int( self.maxhealth * .25 );
			if ( damage < 25 )
			{
				damage = 25;
			}

			if ( self.health - damage < 1 )
			{
				self.health = 1;
			}
			else
			{
				self.health -= damage;
			}
		}

		self setelectrified( 1.0 );	
		self shellshock( "electrocution", 1.0 );
		self playsound( "wpn_tesla_bounce" );
	}
}
function play_tesla_sound(emotion)
{
	self endon( "disconnect" );

	if(!IsDefined (level.one_emo_at_a_time))
	{
		level.one_emo_at_a_time = 0;
		level.var_counter = 0;	
	}
	if(level.one_emo_at_a_time == 0)
	{
		level.var_counter ++;
		level.one_emo_at_a_time = 1;
		org = spawn("script_origin", self.origin);
		org LinkTo(self);
		org PlaySoundWithNotify (emotion, "sound_complete"+ "_"+level.var_counter);
		org waittill("sound_complete"+ "_"+level.var_counter);
		org delete();
		level.one_emo_at_a_time = 0;
	}		
}

function tesla_killstreak_sound()
{
	self endon( "disconnect" );

	//TUEY Play some dialog if you kick ass with the Tesla gun

	self zm_audio::create_and_play_dialog( "kill", "tesla" );	
	wait(3.5);
	level util::clientNotify("TGH");
}


function tesla_network_choke()
{
	self endon( "disconnect" );
	self endon( "death" );

	self.tesla_network_death_choke = 0;

	for ( ;; )
	{
		util::wait_network_frame();
		util::wait_network_frame();
		self.tesla_network_death_choke = 0;
	}
}

function tesla_zombie_death_response()
{
	if( self enemy_killed_by_tesla() )
	{
		return true;
	}
	
	return false;
}

function tesla_zombie_damage_response( mod, hit_location, hit_origin, player, amount, weapon )
{
	if( self is_tesla_damage( mod ) )
	{
		self thread tesla_damage_init( hit_location, hit_origin, player );
		return true;
	}
	return false;
}
