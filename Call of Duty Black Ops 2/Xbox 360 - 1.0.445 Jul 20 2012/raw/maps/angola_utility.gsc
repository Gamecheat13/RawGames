
#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_skipto;
#include maps\_scene;
#include maps\_anim;
#include maps\_dialog;


#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\angola.gsh;

level_init_flags()
{
	//non event specific flags
	flag_init( "show_introscreen_title" );
	flag_init( "end_angola" );
	
	maps\angola_riverbed::init_flags();
	maps\angola_savannah::init_flags();
}

// sets flags for the skipto's and exits out at appropriate skipto point.  All previous skipto setups in this functions will be called before the current skipto setup is called
skipto_setup()
{
	skipto = level.skipto_point;

	if ( skipto == "riverbed_intro" )
		return;		
	
	flag_set( "riverbed_player_intro_done" );
	
	if ( skipto == "riverbed" )
		return;	

	if ( skipto == "savannah_start" )
		return;	
	
	flag_set( "savannah_brim_reached" );
	
	if ( skipto == "savannah_hill" )
		return;	
	
	if ( skipto == "savannah_finish" )
		return;	
}

setup_objectives()
{
	//MAIN PROGRESSION
	level.OBJ_FOLLOW_BUFFEL = register_objective( &"ANGOLA_OBJ_FOLLOW_BUFFEL" );
	///level.OBJ_DESTROY_TANKS	= register_objective( &"ANGOLA_OBJ_DESTROY_TANKS" );
	level.OBJ_KILL_RPG_ONE = register_objective( &"ANGOLA_OBJ_DESTROY_RPGS" );
	level.OBJ_DESTROY_FIRST_WAVE	= register_objective( &"ANGOLA_OBJ_DESTROY_FIRST_WAVE" );
	level.OBJ_KILL_RPG_TWO = register_objective( &"ANGOLA_OBJ_DESTROY_RPGS" );
	level.OBJ_DESTROY_SECOND_WAVE	= register_objective( &"ANGOLA_OBJ_DESTROY_SECOND_WAVE" );	
	level.OBJ_GET_TO_BUFFEL = register_objective( &"ANGOLA_OBJ_GET_TO_BUFFEL" );
	level.OBJ_DESTROY_FINAL_WAVE = register_objective( &"ANGOLA_OBJ_DESTROY_FINAL_WAVE" );
	
	//PERKS
	level.OBJ_LOCKBREAKER = register_objective( "" );
	
	level thread angola_objectives();
}

angola_objectives()
{
	while( !IsDefined( level.savimbi ) )
	{
		wait 0.05;
	}
	
	flag_wait( "riverbed_player_intro_done" );
	
	set_objective( level.OBJ_FOLLOW_BUFFEL, level.savimbi, "follow" );

	flag_wait( "savannah_brim_reached" );
	
	set_objective( level.OBJ_FOLLOW_BUFFEL, level.savimbi, "done" );
}

setup_challenges()
{
	wait_for_first_player();

	//global challenges TODO needs to be moved over to angola_2 utility
	level.player thread maps\_challenges_sp::register_challenge( "locateintel", ::locate_int );
	
	//perk challenges
//	level.player thread maps\_challenges_sp::register_challenge( "rescuesoldier", maps\panama_slums::challenge_rescue_soldier );
//	level.player thread maps\_challenges_sp::register_challenge( "findweaponcache", maps\panama_slums::challenge_find_weapon_cache );
//	level.player thread maps\_challenges_sp::register_challenge( "hangardoors", maps\panama_airfield::challenge_close_hangar_doors );	

	//level specific challenges
	level.player thread maps\_challenges_sp::register_challenge( "heliruns", maps\angola_savannah::challenge_heli_runs );
//	level.player thread maps\_challenges_sp::register_challenge( "destroylearjet", maps\panama_airfield::challenge_destroy_learjet );
//	level.player thread maps\_challenges_sp::register_challenge( "destroyzpu", maps\panama_slums::challenge_destroy_zpu );
//	level.player thread maps\_challenges_sp::register_challenge( "grenadecombo", maps\panama_slums::challenge_grenade_combo );
//	level.player thread maps\_challenges_sp::register_challenge( "docksguardsspeedkill", maps\panama_docks::challenge_docks_guards_speed_kill );
	level.player thread maps\_challenges_sp::register_challenge( "machetegib", maps\angola_savannah::challenge_machete_gibs );
	level.player thread maps\_challenges_sp::register_challenge( "mortarkills", maps\angola_savannah::challenge_mortar_kills );
}

blackscreen(fadein, stay, fadeout)
{
	blackscreen = NewHudElem();
	
	blackscreen.alpha = 0;
	blackscreen.horzAlign = "fullscreen";
	blackscreen.vertAlign = "fullscreen";
	
	blackscreen SetShader( "black", 640, 480 );
	if( fadein > 0 )
	{
		blackscreen fadeOverTime( fadein ); 
	}
	blackscreen.alpha = 1;
	
	wait (stay);
	
	if( fadeout > 0 )
	{
		blackscreen fadeOverTime( fadeout ); 
	}
	blackscreen.alpha = 0;	
	
	blackscreen destroy();
}

//TODO needs to be moved over to angola_2 utility
locate_int( str_notify )
{
	flag_wait( "savannah_base_reached" );
	
	player_collected_all = collected_all();
	
	if( player_collected_all )
	{
		self notify( str_notify );		
	}	
}

init_fight( str_node, str_friend, str_enemy )
{
	level.a_nd_engage = GetNodeArray( str_node, "targetname" );
	foreach( node in level.a_nd_engage )
	{
		node.open = true;
	}
	level.a_sp_friend = GetEntArray( str_friend, "targetname" );
	level.a_sp_enemy = GetEntArray( str_enemy, "targetname" );
}

create_fight( e_friend, e_enemy, b_all_nodes = false )
{
	if( !IsDefined( e_enemy ) )
	{
		e_enemy = level.a_sp_enemy[ RandomInt( level.a_sp_enemy.size ) ] spawn_ai( true );
		if( isdefined( e_enemy ) )
		{
			if( RandomInt( 100 ) > 70 )
			{
				e_enemy.script_string = "machete";
				e_enemy maps\_mpla_unita::setup_mpla();				
			}		
			e_enemy SetThreatBiasGroup( "enemy_dancer" );			
		}
	}
	
	if( !IsDefined( e_friend ) )
	{
		e_friend = level.a_sp_friend[ RandomInt( level.a_sp_friend.size ) ] spawn_ai( true );
		if( isdefined( e_friend ) )
		{
			e_friend SetThreatBiasGroup( "friendly_dancer" );	
		}
	}	
	
	nd_e_goal = _get_fight_node( b_all_nodes );
	
	if( IsDefined( nd_e_goal ) && IsDefined( e_enemy ) && IsDefined( e_friend ) )
	{
		e_enemy.e_opp = e_friend;
		e_friend.e_opp = e_enemy;
	
		nd_f_goal = GetNode( nd_e_goal.target, "targetname" );

		/#e_enemy thread _fight_think_debug( nd_e_goal, nd_f_goal );#/
		
		e_enemy thread _fight_think( nd_e_goal );
		e_friend thread _fight_think( nd_f_goal );
	}
	else //something went wrong, probably max AI spawned, abort!
	{
		if( IsDefined( e_enemy ) && IsAlive( e_enemy ) )
		{
			e_enemy die();
		}
		if( IsDefined( e_friend ) && IsAlive( e_friend ) )
		{
			e_friend die();
		}
		
		wait 1;
	}
}

enemy_melee_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	if(  !IsAlive( self ) )
		return n_damage;
	
	new_damage = n_damage;	
	
	if( e_inflictor == level.player )
	{
		// this AI is running to a melee spot, only take damage from the player
		self enable_pain();
		return new_damage;
	}
	else if( self.a.pose != "back" )
	{
		if( IsAI( e_inflictor ) )
	   {
			if( e_inflictor != level.savimbi )
			{
				self disable_pain();	// might have been enabled as the player/savimbi shot this AI
				self.health = self.health + new_damage;
			}
			else
			{
				self enable_pain();
				return new_damage;
			}
		}
		
	}
		
	return new_damage;
}

_get_fight_node( b_all_nodes = false )
{
	//vehicle used to determine which fight nodes are valid
	vh_lead_buffel = GetEnt( "savimbi_buffel", "targetname" );
	
	//run through all fight nodes and determine which ones are in a valid range
	for( i = 0; i < level.a_nd_engage.size; i++ )
	{
		nd_eval = level.a_nd_engage[i];
		if( ( nd_eval.origin[0] > vh_lead_buffel.origin[0] &&
		     nd_eval.origin[0] < vh_lead_buffel.origin[0] + 2000 ) || b_all_nodes )
		{
			level.a_nd_engage[i].valid = true;
		}
		else
		{
			level.a_nd_engage[i].valid = true;
		}
	}
	
	//create an array of possible fight nodes
	a_valid_nodes = [];
	for( i = 0; i < level.a_nd_engage.size; i++ )
	{
		if( level.a_nd_engage[i].open && level.a_nd_engage[i].valid )
		{
			a_valid_nodes[ a_valid_nodes.size ] = level.a_nd_engage[i];
		}
	}

	//determine the node to return
	nd_goal = undefined;
	if( a_valid_nodes.size )
	{
		nd_goal = a_valid_nodes[ RandomInt( a_valid_nodes.size ) ];
		nd_goal.open = false;
		//nd_goal thread _fight_node_cooldown();
	}
	
	return nd_goal;
}

_fight_node_cooldown()
{
	wait 10;
	self.open = true;
}

/#
_fight_think_debug( nd_goal, nd_f_goal )
{
	self endon("death");
	self.e_opp endon("death");
	
	while(1)
	{
		// line from enemy to node
		RecordLine( self.e_opp.origin, nd_f_goal.origin, (1,0,0), "Script", self );
		
		// line from me to node
		RecordLine( self.origin, nd_goal.origin, (1,0,0), "Script", self );
		
		// line from me to my enemy
		RecordLine( self.origin, self.e_opp.origin, (1,1,1), "Script", self );
		
		// tell everone that I am a melee guy
		RecordEntText( "M", self, (1,1,1), "Script" );
		
		
		// tell everone that I am a melee guy
		RecordEntText( "M", self.e_opp, (1,1,1), "Script" );
		
		
		// node debug
		if( IsDefined( nd_goal.open ) )
		   Record3DText( nd_goal.open, nd_goal.origin, (1,1,1), "Script", self );
		   
		if( IsDefined( nd_f_goal.open ) )
		   Record3DText( nd_f_goal.open, nd_f_goal.origin, (1,1,1), "Script", self );
		
		wait(0.05);
	}
}
#/
	
	
_init_fighter()
{
	self ent_flag_init( "ready_for_fight" );
	self ent_flag_init( "engaged", true );

	if( IsDefined( self.e_opp ) )
		self.favoriteenemy = self.e_opp;
		
	self.goalradius = 64;
	
	self disable_pain();
	self disable_long_death();
	self disable_react();
	self.pathenemyfightdist		= 0;
	self.pathenemylookahead		= 0;
	self.ignoresuppression		= true;
	
	self.overrideActorDamage = ::enemy_melee_damage_override;
}

_release_fighter()
{
	self ent_flag_clear( "ready_for_fight" );
	self ent_flag_clear( "engaged" );
	
	self.favoriteenemy = undefined;	
	self enable_pain();
	
	self.overrideActorDamage = undefined;
}

_fight_think( nd_goal  )
{		
	self _init_fighter();
				
	if( !level.player is_player_looking_at( nd_goal.origin, 0.3, true ) )
	{
		self Teleport( nd_goal.origin );
	}
	
	self thread _fight_get_to_my_node( nd_goal );
	
	if( IsAlive( self.e_opp ) )
	{
		self thread _opponent_death_watcher();
		self waittill_any( "death", "opp_death" );			
	}
	
	// release the goal node
	nd_goal.open = true;
	
	if( IsAlive( self ) )
		self _release_fighter();
		
	self thread _random_death();
}

_fight_get_to_my_node( nd_goal )
{
	self endon("death");
	
	self SetGoalNode( nd_goal );
	self waittill( "goal" );
	self ent_flag_set( "ready_for_fight" );
}

_opponent_death_watcher()
{
	self endon("death");
	
	self.e_opp waittill( "death" );
	self notify("opp_death");
}

_random_death( offset )
{
	If( !IsDefined( self ) )
		return;

	if( IsDefined( offset ) )
	{
		wait ( RandomFloatRange( 5.0, 7.0 ) + offset );
	}
	else
	{
		wait RandomFloatRange( 5.0, 7.0 );
	}
	
	if ( IsDefined( self ) && isAlive( self ) )
	{
		//25% chance for this guy's death to be more awesome
		if( RandomInt( 100 ) > 75 )
		{
			//self MagicGrenadeType( "frag_grenade_sp", self.origin, (0, 1, 0), 0.25 );
			self kill();
		}
		else
		{
			self kill();
		}
	}
}

equip_machete()
{
	// hide the current weapon
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );

	self.melee_weapon = Spawn( "script_model", self GetTagOrigin("tag_weapon_right") );
	self.melee_weapon.angles = self GetTagAngles("tag_weapon_right");
	self.melee_weapon SetModel( "t6_wpn_machete_prop" );
	self.melee_weapon LinkTo( self, "tag_weapon_right" );
}

unequip_machete()
{
	// hide the current weapon
	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
	self.melee_weapon Delete();
}

equip_savimbi_machete()
{
	// hide the current weapon
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );

	self.melee_weapon = Spawn( "script_model", self GetTagOrigin("tag_weapon_left") );
	self.melee_weapon.angles = self GetTagAngles("tag_weapon_left");
	self.melee_weapon SetModel( "t6_wpn_machete_prop" );
	self.melee_weapon LinkTo( self, "tag_weapon_left" );
}

unequip_savimbi_machete()
{
	// hide the current weapon
	if( isdefined( self.melee_weapon ) )
	{
		self animscripts\shared::placeWeaponOn( self.weapon, "left" );
		self.melee_weapon Delete();		
	}
}

equip_savimbi_machete_battle()
{
	self.melee_weapon = spawn_model( "t6_wpn_machete_prop", self GetTagOrigin("tag_weapon_chest"), self GetTagAngles("tag_weapon_chest") );
	self.melee_weapon LinkTo( self, "tag_weapon_chest" );
}

unequip_savimbi_machete_battle()
{
	// hide the current weapon
	self animscripts\shared::placeWeaponOn( self.weapon, "chest" );
	self.melee_weapon Delete();
}

_drop_machete_on_death()
{
	self waittill("death");

	melee_weapon = self.melee_weapon;

	melee_weapon Unlink();
	melee_weapon PhysicsLaunch();

	wait(15);

	// save an ent
	melee_weapon Delete();
}

#using_animtree( "generic_human" );
load_buffel( b_less_full, real_gunner = false )
{
	if( !IsSubStr( self.vehicletype, "buffel" ) )
	{
		return;	
	}
	
	if( self.riders.size > 0)
	{
		return;
	}
	
	self.riders = [];
	
	if( self.vehicletype == "apc_buffel" )
	{
		n_vehicle_size = level.vehicle_aianims[ "apc_buffel" ].size - 1;	
	}
	else
	{
		n_vehicle_size = level.vehicle_aianims[ "apc_buffel" ].size;
	}
	
	for( i = 0; i < n_vehicle_size; i++ )
	{
		//in case we don't want a full truck, a % chance to not place an ai
		if( ( i == 1 || i == 3 || i == 5 || i == 6 ) && IsDefined( b_less_full ) )
		{
			//if( RandomInt( 100 ) >= 60 )
			{
				continue;
			}
		}
		if( ( self.vehicletype == "apc_buffel_gun_turret" || self.vehicletype == "apc_buffel_gun_turret_nophysics" ) && ( i == 5 || i == 6 ))
		{
			continue;
		}
		if( (self.targetname == "savimbi_buffel") && ( i == 1) )
		{
			continue;
		}
		if( real_gunner && i == 9 )//we want a real gunner
		{
			sp_gunner_spawner = getent( "buffel_gunner", "targetname" );
			ai_buffel_gunner = simple_spawn_single( sp_gunner_spawner, ::buffel_gunner, self, level.vehicle_aianims[ "apc_buffel" ][i].sittag );
			self.riders[ self.riders.size ] = ai_buffel_gunner;
		}
		else//used in intro convoy
		{
			m_rider = create_friendly_model_actor();
			m_rider UseAnimTree( #animtree );
			m_rider LinkTo( self, level.vehicle_aianims[ "apc_buffel" ][i].sittag );
			v_origin = self GetTagOrigin( level.vehicle_aianims[ "apc_buffel" ][i].sittag );
			v_angles = self GetTagAngles( level.vehicle_aianims[ "apc_buffel" ][i].sittag );
			anim_ride = level.vehicle_aianims[ "apc_buffel" ][i].idle;
			
			m_rider AnimScripted( "ride_buffel_"+ i, v_origin, v_angles, anim_ride );	

			self.riders[ self.riders.size ] = m_rider;			
		}
		
	}
}

unload_buffel()
{
	if( !IsSubStr( self.vehicletype, "buffel" ) )
	{
		return;	
	}
	
	foreach( m_rider in self.riders )
	{
		m_rider Delete();
	}
}

buffel_gunner( vh_to_enter, str_seat_tag )
{
	self enter_vehicle( vh_to_enter, str_seat_tag );
	self thread magic_bullet_shield();
}

load_gaz66( b_less_full )
{
	if( self.vehicletype != "truck_gaz66_cargo" )
	{
		return;
	}
	
	self.riders = [];
	
	//n_random_max = RandomIntRange( 1,3 );
	n_random_max = 1;//Just driver for now
	
	for( i = 0; i < n_random_max; i++ )
	{
		m_rider = create_friendly_model_actor();
		m_rider UseAnimTree( #animtree );
		m_rider LinkTo( self, level.vehicle_aianims[ "truck_gaz66_cargo" ][i].sittag );
		v_origin = self GetTagOrigin( level.vehicle_aianims[ "truck_gaz66_cargo" ][i].sittag );
		v_angles = self GetTagAngles( level.vehicle_aianims[ "truck_gaz66_cargo" ][i].sittag );
		anim_ride = level.vehicle_aianims[ "truck_gaz66_cargo" ][i].idle;
		
		m_rider AnimScripted( "ride_gaz66_"+ i, v_origin, v_angles, anim_ride );

		self.riders[ self.riders.size ] = m_rider;
	}
}

unload_gaz66()
{
	if( self.vehicletype != "truck_gaz66_cargo" )
	{
		return;
	}
	
	foreach( m_rider in self.riders )
	{
		m_rider Delete();
	}
}

destroy_buffel()
{
	self.fire_turret = false;
	PlayFXOnTag( getfx( "buffel_explode" ), self, "tag_body" );
	self unload_buffel();
}

create_friendly_model_actor()
{
	sp_model = GetEnt( "savannah_ending_soldier", "targetname" );
	
	
	m_actor = sp_model spawn_drone(true);
	
	return m_actor;
}

savimbi_setup_start()
{
	self equip_savimbi_machete();
	self Attach( "t6_wpn_launch_mm1_world", "tag_weapon_right" );
	self set_ignoreme( true );
	self.a.allow_sideArm = 0;
}

savimbi_setup()
{
	self Attach( "t6_wpn_launch_mm1_world", "tag_weapon_right" );
	self set_ignoreme( true );
	self.a.allow_sideArm = 0;
}

savimbi_fire_mgl( savimbi )
{
	v_start = savimbi GetTagOrigin( "tag_flash" );
	//v_angles = savimbi GetTagAngles( "tag_flash" );
	//v_end = v_start + AnglesToForward( v_angles ) * 200;
	
	fire_node_array = GetEntArray( "mgl_fire", "targetname" );
	fire_node = fire_node_array[ RandomInt( fire_node_array.size ) ];
	
	MagicBullet( "mgl_sp", v_start, fire_node.origin );
}

//kills player if he strays to far from the convoy
#define DIST_X_MIN 600	
#define DIST_X_MAX 900
#define DIST_Y_MIN 800	
#define DIST_Y_MAX 1200
player_convoy_watch( str_flag )
{
	vh_lead_buffel = GetEnt( "savimbi_buffel", "targetname" );
	
	while( !flag( str_flag ) )
	{
		if( !flag( "player_in_helicopter" ) )
		{
			n_player_x = self.origin[0];
			n_player_y = self.origin[1];
			
			n_buffel_x = vh_lead_buffel.origin[0];
			n_buffel_y = vh_lead_buffel.origin[1];
			
			//warning damage
			if( n_player_x > ( n_buffel_x + DIST_X_MAX ) ||
			    n_player_x < ( n_buffel_x - DIST_X_MAX ) ||
			    n_player_y > ( n_buffel_y + DIST_Y_MAX ) ||
			    n_player_y < ( n_buffel_y - DIST_Y_MAX ) )
	 		{
				if( n_player_x < ( n_buffel_x - DIST_X_MAX ) )
				{
					missionfailedwrapper( &"ANGOLA_ABANDON_FAIL" );					
				}
				else
				{
					SetDvar( "ui_deadquote", &"ANGOLA_CONVOY_FAIL" );			
					//level.player maps\_mortar::explosion_boom( "mortar_savannah" );	
					level.player DoDamage( 60, vh_lead_buffel.origin + (1500, 0, 0) );
					wait RandomFloatRange( .2, .3 );
				}
			}
			else if( n_player_x > ( n_buffel_x + DIST_X_MIN ) ||
			    n_player_x < ( n_buffel_x - DIST_X_MIN ) ||
			    n_player_y > ( n_buffel_y + DIST_Y_MIN ) ||
			    n_player_y < ( n_buffel_y - DIST_Y_MIN ) )
			{
				level.savimbi thread savimbi_say_convoy_warning();
				//screen_message_create( &"ANGOLA_CONVOY_WARNING" );
				//TODO hook this up to only do damage after the battle has begun
				//level.player DoDamage( 20, vh_lead_buffel.origin );
				wait RandomFloatRange(2, 2.5);
			}
			else
			{
				//screen_message_delete();
			}
		}
		wait 0.1;
	}
}

savimbi_say_convoy_warning()
{
	switch( RandomIntRange( 0, 3 ) )
	{
		case 0:
	    	self say_dialog( "savi_you_should_stay_with_0" );//You should stay with the vehicles.
	    	break;
	    	
	    case 1:
	    	self say_dialog( "savi_where_are_you_going_0" );//Where are you going, Mason?
	    	break;
	    	
	    case 2:
	    	self say_dialog( "savi_you_cannot_leave_the_0" );//You cannot leave the convoy!    	
	    	break;     	
   }
}

#define NUM_FIGHTS 5
create_after_strafe_fights( n_heli_runs)
{
	switch( n_heli_runs )
	{
		case 1:
			a_spots = GetStructArray( "post_heli_fight_spot", "targetname" );
			break;
			
		case 2:
			a_spots = GetStructArray( "post_heli_fight_spot2", "targetname" );
			break;
			
		default:
			return;
			break;
	}	
	
	a_scenes[0] = "_01";
	a_scenes[1] = "_02";
	a_scenes[2] = "_03";
	a_scenes[3] = "_04";
	a_scenes[4] = "_05";
	a_scenes[5] = "_06";
	
	v_angles = level.player GetPlayerAngles();
	v_check = level.player.origin + AnglesToForward( v_angles ) * 500;
			
	//Print3d (v_check + ( 0, 0, 50 ), "check", (0,0,0), 1, 1, 500 );
			
	scene = array_randomize( a_scenes );
	align = get_array_of_closest( v_check, a_spots, undefined, NUM_FIGHTS );
		
	a_old_align = GetEntArray( "fight_align", "script_noteworthy" );
	for( i = 0; i < a_old_align.size; i++ )
	{
		a_old_align[i] Delete();
	}
	for( i = 0; i < NUM_FIGHTS; i++ )
	{
		level thread _fight_vignette( align[i], scene[i] );
		wait 0.05;
	}
}

_fight_vignette( align, scene )
{
	sp_enemy = GetEnt( "post_heli_enemy", "targetname" );
	sp_friend = GetEnt( "post_heli_friendly", "targetname" );
	
	m_align = Spawn( "script_origin" , align.origin );
	if( IsDefined( align.angles ) )
	{
		m_align.angles = ( align.angles[0], RandomInt( 360 ), align.angles[2] );
	}
	else
	{
		m_align.angles = ( 0, RandomInt( 360 ), 0 );
	}
	m_align.targetname = "hill_fight" + scene;
	m_align.script_noteworthy = "fight_align";
	
	//Print3d( m_align.origin + ( 0, 0, 100 ), "hill_fight" + scene, (0,0,0), 1, 1, 500 );
	
	add_scene_properties( "hill_fight" + scene, m_align.targetname );
	enemy = sp_enemy spawn_ai( true );
	enemy.animname = "hill_fight_mpla" + scene;
	enemy.script_string = "machete";
	enemy maps\_mpla_unita::setup_mpla();	
	
	friend = sp_friend spawn_ai( true );
	friend.animname = "hill_fight_unita" + scene;
	friend.script_string = "machete";
	friend maps\_mpla_unita::setup_mpla();	
	
	if( isdefined( enemy ) && isdefined( friend ) )
	{
		level thread run_scene( "hill_fight" + scene );
		
		enemy thread _fight_vignette_think( "hill_fight" + scene );
		friend thread _fight_vignette_think( "hill_fight" + scene );
		
		scene_wait( "hill_fight" + scene );
		
		if( IsAlive( enemy ) )
		{
			enemy notify( "stop_think" );
			enemy thread _random_death();
		}
		if( IsAlive( friend ) )
		{
			enemy notify( "stop_think" );
			friend thread _random_death();
		}
	}
	//something went wrong, probably max AI spawned, abort!
	else
	{
		if( IsDefined( enemy ) && IsAlive( enemy ) )
		{
			enemy die();
		}
		if( IsDefined( friend ) && IsAlive( friend ) )
		{
			friend die();
		}
		wait 1;
	}	
}

_fight_vignette_think( scene )
{
	self endon( "stop_think" );
	
	self waittill( "death" );
	
	end_scene( scene );
}

attach_weapon()
{
	weaponModel = "t6_wpn_ar_ak47_world"; 
	self Attach( weaponModel, "tag_weapon_right" ); 
	self UseWeaponHideTags(self.weapon); //Adrian B 08.23.10 make sure attachments dont show up
}

#using_animtree("fxanim_props");
animate_grass( is_default )
{
	grass_array = GetEntArray( "fxanim_heli_grass_flyover", "targetname" );
	foreach( grass in grass_array )
	{
		grass UseAnimTree( #animtree );
		grass notify( "stop_loop" );
		if( is_default )
		{
			grass thread anim_loop( grass, "grass_standing_amb_loop", "stop_loop", "fxanim_props" );	
		}
		else
		{
			grass thread anim_loop( grass, "grass_heli_fly_over_loop", "stop_loop", "fxanim_props" );	
		}
	}
}

stop_savannah_grass()
{
	grass_array = GetEntArray( "fxanim_heli_grass_flyover", "targetname" );
	foreach( grass in grass_array )
	{
		grass notify( "stop_loop" );
	}	
}

animate_heli_grass( is_default )
{
	grass_array = GetEntArray( "fxanim_heli_grass_land", "targetname" );
	foreach( grass in grass_array )
	{
		grass UseAnimTree( #animtree );
		grass notify( "stop_loop" );
		if( is_default )
		{
			grass thread anim_loop( grass, "grass_standing_amb_loop", "stop_loop", "fxanim_props" );	
		}
		else
		{
			grass thread anim_loop( grass, "grass_heli_fly_over_loop", "stop_loop", "fxanim_props" );	
		}
	}
}

turn_on_convoy_headlights()
{
	a_vh = GetEntArray( "convoy", "script_noteworthy" );
	foreach( vehicle in a_vh )
	{
		vehicle SetClientFlag( CLIENT_FLAG_VEHICLE_LIGHTS );	
	}
}

delete_array(value, key)
{
	stuff = GetEntArray(value, key);
	for (i=0; i < stuff.size; i++)
	{
		stuff[i] Delete();
	}
}

refill_player_clip()
{
	a_str_weapons = level.player GetWeaponsList();
	foreach( str_weapon in a_str_weapons )
	{
		//level.player GiveMaxAmmo( str_weapon );
		level.player SetWeaponAmmoClip( str_weapon, WeaponClipSize( str_weapon ) );
	}	
}

savannah_player_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime )
{
	damage_modifier = get_difficulty_damage_modifier();
	
	if( str_means_of_death == "MOD_PROJECTILE_SPLASH" )
	{
		n_damage = int(n_damage / (damage_modifier * 4) );//Take less damage from rpg/tank shells. We want to hurt the player, not kill them if possible
	}
	else
	{
		n_damage = int( n_damage / damage_modifier );//Half damage for everything else
	}
	return n_damage;
}

get_difficulty_damage_modifier()
{
	str_difficulty = getdifficulty();

	switch( str_difficulty )
	{
		case "fu":
			return 1;
			break;
			
		case "hard":
			return 1.5;
			break;
			
		case "medium":
			return 2;
			break;
			
		default://"easy"
			return 4;
			break;
	}
}