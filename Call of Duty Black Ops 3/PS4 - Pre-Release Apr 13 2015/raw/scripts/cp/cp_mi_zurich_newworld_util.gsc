#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons_shared;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom_gadget;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
           	    

#namespace newworld_util;


//	Replace the weapons based on the section
//	self is a player
function replace_weapons()
{
	w_ar 		= GetWeapon( "ar_standard" );
	w_smg 		= GetWeapon( "smg_standard" );
	w_lmg		= GetWeapon( "lmg_light" );
	w_shotgun 	= GetWeapon( "shotgun_pump" );
	w_pistol	= GetWeapon( "pistol_standard" );
	w_frag		= GetWeapon( "frag_grenade" );
	w_emp		= GetWeapon( "emp_grenade" );
	
	switch( level.skipto_current_objective[0] )
	{
	case "white_infinite_igc":
	case "pallas_igc":
	case "factory_exterior":
	case "alley":
	case "warehouse":
	case "foundry":
	case "vat_room":
	case "inside_man_igc":
		self take_weapons();

		self GiveWeapon( w_ar );
		self GiveWeapon( w_pistol );
		self GiveWeapon( w_frag );
		self GiveWeapon( w_emp );
		
		self SwitchToWeapon( w_ar );
		break;
	case "apartment_igc":
	case "chase":
	case "bridge_collapse_igc":
	case "rooftops":
	case "glass_ceiling_igc":
		self take_weapons();

		self GiveWeapon( w_smg );
		self GiveWeapon( w_pistol );
		self GiveWeapon( w_frag );
		self GiveWeapon( w_emp );
		
		self SwitchToWeapon( w_smg );
		break;
	case "pinned_down_igc":
	case "subway":
	case "crossroads":
	case "construction":
	case "maintenance":
	case "water_plant":
		self take_weapons();

		self GiveWeapon( w_lmg );
		self GiveWeapon( w_pistol );
		self GiveWeapon( w_frag );
		self GiveWeapon( w_emp );
		
		self SwitchToWeapon( w_lmg );
		break;
	case "inbound_igc":
	case "train":
	case "train_rooftop":
	case "detach_bomb_igc":
		self take_weapons();

		self GiveWeapon( w_shotgun );
		self GiveWeapon( w_pistol );
		self GiveWeapon( w_frag );
		self GiveWeapon( w_emp );
		
		self SwitchToWeapon( w_shotgun );
		break;
	default:
		break;
	}
}


//	Take away the player's weapons
//	self is a player
function take_weapons( b_save = true )
{
	// Take away weapons
	a_w_old_weapons = self GetWeaponsList();
	foreach( w_weapon in a_w_old_weapons )
	{
		self TakeWeapon( w_weapon );
	}
	
	if ( b_save )
	{
		self.a_w_old_weapons = a_w_old_weapons;
	}
}

//	Reassign Cyber Core abilities based on the current skipto when player spawns in
//	self is a player
function replace_cyber_abilities()
{	
	self cybercom_gadget::takeAllAbilities();

	switch( level.skipto_current_objective[0] )
	{
//	case "":	//TODO will need to add this if there's a skipto added after the foundry
//		self cybercom_gadget::giveAbility( "cybercom_hijack", false );
//		break;
	case "chase":
	case "bridge_collapse_igc":
	case "rooftops":
		self cybercom_gadget::giveAbility( "cybercom_systemoverload", false );
		self cybercom_gadget::equipAbility( "cybercom_systemoverload" );
		break;
	case "construction":
	case "crossroads":
	case "maintenance":
	case "water_plant":
		self cybercom_gadget::giveAbility( "cybercom_sensoryoverload", false );
		self cybercom_gadget::giveAbility( "cybercom_immolation", false );
		self cybercom_gadget::equipAbility( "cybercom_immolation" );
		break;
	case "train":
	case "train_rooftop":
		self cybercom_gadget::giveAbility( "cybercom_concussive", false );
		self cybercom_gadget::giveAbility( "cybercom_takedown", false );
		self cybercom_gadget::equipAbility( "cybercom_takedown" );
		break;
	default:
		break;
	}
}


function ai_death_derez()  // self = AI
{
	if ( self should_derez_on_death() )
	{
		self thread derez_when_actor_becomes_corpse();
		self thread derez_on_ragdoll_start();
	}
}

function should_derez_on_death()  // self = AI
{
	return ( !IsVehicle( self ) );
}

function derez_when_actor_becomes_corpse()
{
	self endon( "ai_derez_death" );

	self waittill( "actor_corpse", e_corpse );  // 'actor_corpse' sent when AI is deleted and is replaced with corpse entity
	
	if( ( isdefined( level.player_on_top_of_train ) && level.player_on_top_of_train ) )
	{
		wait 1.0;	
	}

	if ( IsDefined( e_corpse ) )
	{
		e_corpse clientfield::set( "derez_ai_deaths", 1 );
	}

	util::wait_network_frame();

	if ( IsDefined( e_corpse ) )
	{
		e_corpse Delete();
	}

	if ( IsDefined( self ) )
	{
		self notify( "ai_derez_death" );
	}
}

function derez_on_ragdoll_start()
{
	self endon( "ai_derez_death" );

	self waittill( "start_ragdoll" );
	
	if( ( isdefined( level.player_on_top_of_train ) && level.player_on_top_of_train ) )
	{
		wait 1.0;	
	}

	if ( IsDefined( self ) )
	{
		self clientfield::set( "derez_ai_deaths", 1 );
	}

	util::wait_network_frame();

	if ( IsDefined( self ) )
	{
		self Delete();
		self notify( "ai_derez_death" );
	}
}

function delete_ai_at_path_end( should_die )
{
	self endon( "death" );
	self waittill( "reached_path_end" );
	delete_ai( self, should_die );
}

function delete_ai( ai, should_die )
{
	if ( ( isdefined( should_die ) && should_die ) )
	{
		ai Kill();
	}
	else
	{
		a_ai = Array( ai );
		level thread delete_ai_when_out_of_sight( a_ai, 512 );
	}
}

function delete_ai_when_out_of_sight( a_ai, n_dist = 512 )
{
	if ( !IsDefined( a_ai ) )
	{
		return;
	}
	
	n_off_screen_dot = 0.75;

	while ( a_ai.size > 0 )
	{
		for ( i = 0; i < a_ai.size; i++ )
		{
 			if ( !IsDefined( a_ai[ i ] ) || !IsAlive( a_ai[ i ] ) )
			{
				ArrayRemoveValue( a_ai, a_ai[ i ] );
				continue;
			}

			if ( players_within_distance( n_dist, a_ai[ i ].origin ) )
			{
				continue;
			}

			if ( any_player_looking_at( a_ai[ i ].origin + ( 0, 0, 48 ), n_off_screen_dot, true ) )
			{
				continue;
			}

			if ( !( isdefined( a_ai[ i ].allowdeath ) && a_ai[ i ].allowdeath ) )
			{
				a_ai[ i ] util::stop_magic_bullet_shield();
			}

			a_ai[ i ] Delete();
			ArrayRemoveValue( a_ai, a_ai[ i ] );
		}

		wait ( 1 );
	}
}

function players_within_distance( n_dist, v_org )
{
	n_dist_squared = ( (n_dist) * (n_dist) );

	for ( i = 0; i < level.players.size; i++ )
	{
		if ( DistanceSquared( v_org, level.players[ i ].origin ) < n_dist_squared )
		{
			return true;
		}
	}

	return false;
}

function any_player_looking_at( v_org, n_dot, b_dot_only, e_ignore )
{
	for ( i = 0; i < level.players.size; i++ )
	{
		if ( level.players[ i ] util::is_player_looking_at( v_org, n_dot, b_dot_only, e_ignore ) )
		{
			return true;
		}
	}

	return false;
}

function event_trigger_toggle( str_objective, str_state )
{
	a_t_event = trigger::get_all( "trigger_multiple", "trigger_once", "trigger_use", "trigger_radius", "trigger_lookat", "trigger_damage", "trigger_box" );

	foreach ( t_event in a_t_event )
	{
		if ( ( t_event.script_objective === str_objective ) )
		{
			if ( ( ToLower( str_state ) === "on" ) )
			{
				t_event TriggerEnable( true );
			}
			else
			{
				t_event TriggerEnable( false );
			}
		}
	}
}

//
//
//TEMP Stolen from Biodomes
function wait_for_all_players_to_spawn()
{
	level flag::wait_till( "all_players_spawned" );

	wait 0.1;  //start IGC before the CACWaitMenu is still displayed

//	level thread close_cacwaitmenu();
}


//
//	waits until a flag is set or until X number of ais in the group are killed
function wait_till_flag_or_ai_group_killed_count( str_flag, str_aigroup, n_count )
{
	if ( flag::get( str_flag ) )
	{
		return;
	}

	level endon( str_flag );

	spawner::waittill_ai_group_amount_killed( str_aigroup, int( n_count ) );
}


//
//	waits until a flag is set or until X number of ais are left in the group
function wait_till_flag_or_ai_group_ai_count( str_flag, str_aigroup, n_count )
{
	if ( flag::get( str_flag ) )
	{
		return;
	}

	level endon( str_flag );

	spawner::waittill_ai_group_ai_count( str_aigroup, int( n_count ) );
}


//
//	Shooting at a steam pipe will send a notify to see if we can play steam fx.
//	NOTE:  This currently does not work as intended because the "point" information is always (0,0,0)
function steam_pipe()
{
	level endon( "staging_room_igc_complete" );

	self SetCanDamage( true );
	self.n_hits = 0;	// keep track of the number of hits
	self.b_playing_cloud = false;
	
	if ( isdefined( self.script_float ) )
	{
		self SetScale( self.script_float );
	}
	
	while ( true )
	{
		self waittill( "damage", n_damage, e_attacker, v_direction, v_point, str_type, str_tag, str_model, str_part, str_weapon );

		if ( ( isdefined( self.b_playing_cloud ) && self.b_playing_cloud ) )
		{
			continue;
		}
		
		level notify( "steam_fx", self, v_point, v_direction );
	}
}


//
//	Play an effect to cloud up the space
function steam_cloud( v_point, v_angles )
{
	level.n_steam_clouds++;
	
	self.b_playing_cloud = true;

	fx::play( "steam_cloud", v_point, v_angles );

	wait( 15 );	// wait for the cloud to dissipate
	
	self.b_playing_cloud = false;
	self.n_hits = 0;
	level.n_steam_clouds--;
}

//
//	steam FX master controller.  Limits amount of Steam FX that is played
function steam_controller()
{
	level.n_steam_clouds = 0;	// number of steam clouds being played

	while ( true )
	{
		level waittill( "steam_fx", mdl_pipe, v_point, v_direction );
		
		// Need to reverse the direction that the steam shoots out (opposite of the bullet)
		v_angles = VectorToAngles( -1*v_direction );

		mdl_pipe.n_hits++;
		if ( mdl_pipe.n_hits > 1 )
		{
			if ( !mdl_pipe.b_playing_cloud && level.n_steam_clouds < 5 )
			{
				mdl_pipe thread steam_cloud( v_point, v_angles );
				wait 0.5;
			}
		}
		else
		{
			fx::play( "pipe_steam", v_point, v_angles );
			wait 0.5;	// This is the throttle for how often the steam FX can play
		}
	}
}


//
//	self is an icicle
function icicle()
{
	level endon( "staging_room_igc_complete" );
	
	self SetCanDamage( true );
	
	while( 1 )
	{
		self waittill( "damage", n_damage );
	
		if( n_damage > 1)
		{
			break;	
		}
	}
	
	// Drop to the ground
	ground_trace = BulletTrace( self.origin, self.origin + ( 0, 0, -1000 ), false, self );
	v_ground = ground_trace[ "position" ];	//	subtract out the length of the icicle
	
	n_fall = v_ground[2] - self.origin[2];
	// 9.8 m/s = 385.827 in/s
	n_time = Abs(n_fall) / 385.827;
	self MoveZ( n_fall, n_time );
	wait n_time - 0.4;
	
	// Play shatter effect
	fx::play( "icicle_impact", v_ground, self.angles );

	self RadiusDamage( v_ground, 64, 500, 400 );	// origin, radius, max_damage, min_damage
	
	wait 0.4;

	self delete();

}




