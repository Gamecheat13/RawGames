#include common_scripts\utility;
#include maps\_utility;
#include maps\_dynamic_nodes;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_skipto;
#include maps\_scene;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\monsoon.gsh;

// sets flags for the skipto's and exits out at appropriate skipto point.  All previous skipto setups in this functions will be called before the current skipto setup is called
skipto_setup()
{
	load_gumps_monsoon();
	
	skipto = level.skipto_point;
	
	if (skipto == "intro")
		return;	

	if (skipto == "harper_reveal")
		return;		
	
	if (skipto == "rock_swing")
		return;	
	
	flag_set( "jet_stream_launch_obj" );
	flag_set( "player_equipped_suit" );
	flag_set( "squad_equipped_suits" );
	
	if (skipto == "suit_jump")
		return;													

	flag_set( "jet_stream_launch_obj_complete" );
	
	if (skipto == "suit_flying")
		return;			
	
	SetSavedDvar( "r_skyTransition", 1 );
	
	if (skipto == "camo_intro")
		return;													

	flag_set( "wingsuit_player_landed" );
	flag_set( "predator_intro_started" );
	flag_set( "predator_intro_scene_done" );
	
	if (skipto == "camo_battle")
		return;		

	flag_set( "player_reached_helipad" );
	
	if (skipto == "helipad_battle")
		return;													

	flag_set( "player_reached_outer_ruins" );

	if (skipto == "outer_ruins")
		return;													

	flag_set( "player_has_emp" );
	
	if (skipto == "inner_ruins")
		return;			

	flag_set( "helicopter_destroyed" );	
	flag_set( "player_reached_temple_entrance" );
	flag_set( "ruins_door_destroyed" );
	
	if (skipto == "ruins_interior")
		return;													

	
	if (skipto == "lab")
		return;													

	level.asd_destroyed = true;
	
	flag_set( "start_asd_battle" );	
	flag_set( "obj_lab_entrance_regroup" );
	flag_set( "player_at_lab_entrance" );
	flag_set( "lab_entrance_open" );
	flag_set( "player_at_clean_room" );
	flag_set( "lab_clean_room_open" );
	flag_set( "start_player_asd_anim" );
	flag_set( "end_player_asd_anim" );
	flag_set( "asd_tutorial_died" );
	flag_set( "spawn_lobby_guys" );
	flag_set( "lab_lobby_doors" );
	
	if (skipto == "lab_battle")
		return;													

	flag_set( "elevator_is_ready" );
	flag_set( "start_lift_move_down" );
	flag_set( "lift_at_top" );
	flag_set( "lift_at_bottom" );
	flag_set( "spawn_nitrogen_guys" );
	flag_set( "start_shooting_lift" );
	
	if (skipto == "fight_to_isaac")
		return;		

	
	if (skipto == "lab_defend")
		return;	
	
	flag_set( "start_lab_defend" );
	flag_set( "player_at_ddm" );
	flag_set( "set_obj_help_isaac" );
	flag_set( "player_at_isaac" );
	flag_set( "isaac_defend_start" );
	flag_set( "lab_defend_done" );
	flag_set( "set_celerium_door_obj" );
	flag_set( "isaac_is_killed" );
	
	if (skipto == "celerium_chamber")
		return;			
}

load_gumps_monsoon()
{
	if ( is_after_skipto( "ruins_interior" ) )
	{
		load_gump( "monsoon_gump_interior" );
	}
	else
	{
		load_gump( "monsoon_gump_exterior" );
	}
}

////////////////////////////////
//                            //
//        OBJECTIVES          //
//                            //
////////////////////////////////

setup_objectives()
{
	// SECTION 1
	level.OBJ_INTRO_LEAP			= register_objective( &"MONSOON_OBJ_INTRO_LEAP" );
	level.OBJ_WINGSUIT_LAND			= register_objective( &"MONSOON_OBJ_WINGSUIT_LAND" );
	level.OBJ_WINGSUIT_EAVESDROP	= register_objective( &"MONSOON_OBJ_WINGSUIT_EAVESDROP" );

	// SECTION 2 
	level.OBJ_REACH_LAB				= register_objective( &"MONSOON_OBJ_REACH_LAB" );
	level.OBJ_DESTROY_HELI			= register_objective( &"MONSOON_OBJ_DESTROY_HELI" );
	level.OBJ_DESTROY_DOOR			= register_objective( &"MONSOON_OBJ_DESTROY_DOOR" );
	
	// SECTION 3
	level.OBJ_INFILTRATE_LAB		 = register_objective( &"MONSOON_OBJ_INFILTRATE_LAB" );
	level.OBJ_OBTAIN_CELERIUM 		 = register_objective( &"MONSOON_OBJ_OBTAIN_CELERIUM" );
	level.OBJ_DESTROY_ASD			 = register_objective( &"MONSOON_OBJ_DESTROY_ASD" );
	level.OBJ_DESTROY_ASD_BOSSES	 = register_objective( &"MONSOON_OBJ_ASD_BOSSES" );
	
	//PERKS
	level.OBJ_INTRUDER				= register_objective( "" );
	level.OBJ_LOCKBREAKER			= register_objective( "" );
	level.OBJ_BRUTEFORCE			= register_objective( "" );
	
	level thread monsoon_objectives();
}

monsoon_objectives()
{
	objectives_intro();
	objectives_ruins();
	objectives_lab();
}

objectives_intro()
{
	flag_wait( "jet_stream_launch_obj" );
	
	set_objective( level.OBJ_INTRO_LEAP, GetEnt( "launch_obj", "targetname" ), "breadcrumb" );

	flag_wait( "jet_stream_launch_obj_complete" );

	set_objective( level.OBJ_INTRO_LEAP, undefined, "done" );
}

objectives_ruins()
{
	flag_wait( "wingsuit_player_landed" );
	
	set_objective( level.OBJ_REACH_LAB, level.harper, "follow" );
	
	flag_wait( "predator_intro_started" );
	
	set_objective( level.OBJ_REACH_LAB, undefined, "remove" );
		
	flag_wait( "predator_intro_scene_done" );
	
	set_objective( level.OBJ_REACH_LAB, GetEnt( "obj_helipad", "targetname" ) );
	
	flag_wait( "player_reached_helipad" );
	
	set_objective( level.OBJ_REACH_LAB, GetEnt( "obj_ruins", "targetname" ) );
	
	flag_wait( "player_reached_outer_ruins" );
	
	set_objective( level.OBJ_REACH_LAB, undefined, "remove" );
	
	flag_wait( "helicopter_destroyed" );
	
	set_objective( level.OBJ_REACH_LAB, GetEnt( "obj_temple", "targetname" ) );
	
	flag_wait( "player_reached_temple_entrance" );
	
	//don't display the "destroy" objective if the player cannot do this
	if( player_has_titus_6_weapon() )
	{
		set_objective( level.OBJ_REACH_LAB, undefined, "remove" );
		set_objective( level.OBJ_DESTROY_DOOR, GetEnt( "temple_doors", "targetname" ), "destroy" );
		flag_wait( "ruins_door_destroyed" );
		set_objective( level.OBJ_DESTROY_DOOR, undefined, "done" );
	}
	else
	{
		flag_wait( "ruins_door_destroyed" );
	}
	
	set_objective( level.OBJ_REACH_LAB, GetEnt( "obj_ruins_interior", "targetname" ) );	
		
	flag_wait( "obj_lab_entrance_regroup" );
	
	set_objective( level.OBJ_REACH_LAB, undefined, "done" );
}

objectives_lab()
{
	//place breadcrumb by the entrance door
	set_objective( level.OBJ_INFILTRATE_LAB, getstruct( "obj_infiltrate_lab" ), "breadcrumb" );
	
	flag_wait( "player_at_lab_entrance" );
	
	//remove breadcrumb by the entrance door
	set_objective( level.OBJ_INFILTRATE_LAB, undefined, "remove" );
	
	flag_wait( "lab_entrance_open" );
	
	set_objective( level.OBJ_INFILTRATE_LAB, undefined, "done" );	
	
	//place breadcrumb at the clean room
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_clean_room" ), "breadcrumb" );	

	flag_wait( "player_at_clean_room" ); //trigger flag
	
	//remove breadcrumb by the entrance door
	set_objective( level.OBJ_OBTAIN_CELERIUM, undefined, "remove" );	
	
	flag_wait( "lab_clean_room_open" );
	
	//place breadcrumb in the lobby 
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_lobby_breadcrumb" ), "breadcrumb" );		
	
	flag_wait( "start_player_asd_anim" );
	          
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_lobby_breadcrumb" ), "remove" );
	
	//wait until player is on his feet
	flag_wait( "end_player_asd_anim" );
	
	//place objective to be destory the asd until death or when guys spawn in lobby
	set_objective( level.OBJ_DESTROY_ASD, level.vh_asd_tutorial, "destroy" );
	
	flag_wait_any( "asd_tutorial_died", "spawn_lobby_guys" );
	
	//if the player destroyed the asd, complete it, then move on. otherwise just delete
	if ( level.asd_destroyed )
	{
		set_objective( level.OBJ_DESTROY_ASD, undefined, "done" );		
	}
	else
	{
		set_objective( level.OBJ_DESTROY_ASD, undefined, "delete" );
	}
		
	//place breadcrumb at the elevator
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_interior_elevator" ), "breadcrumb" );		
	
	flag_wait( "lift_at_top" );
	
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_interior_elevator" ), "remove" );		
	
	flag_wait( "elevator_is_ready" );
	
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_elevator_panel" ), "breadcrumb" );		
	
	flag_wait( "start_lift_move_down" );
	
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_elevator_panel" ), "remove" );

	flag_wait( "lift_at_bottom" );
	
	//place breadcrumb in DDM room
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_ddm_regroup" ), "breadcrumb" );	

	flag_wait( "start_lab_defend" );
	
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_ddm_regroup" ), "remove" );
	
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_ddm_regroup" ), "breadcrumb" );	

	flag_wait( "player_at_ddm" );
	
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_ddm_regroup" ), "remove" );	
	
	flag_wait( "set_obj_help_isaac" );
	
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_help_isaac" ), "breadcrumb" );	
	
	flag_wait( "player_at_isaac" );
	
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_help_isaac" ), "remove" );	
	
	flag_wait( "isaac_defend_start" );
	
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_protect_hacker" ), "protect" );
	
	flag_wait( "lab_defend_done" );
	
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_protect_hacker" ), "remove" );
	
	flag_wait( "set_celerium_door_obj" );
	
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_player_celerium_door" ), "breadcrumb" );
	
	flag_wait( "player_triggered_celerium_door" );
	
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_player_celerium_door" ), "remove" );
	
	flag_wait( "set_celerium_chip_obj" );

	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_celerium_chip" ), "breadcrumb" );
	
	flag_wait( "player_at_celerium" );
	
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_celerium_chip" ), "remove" );
	
	set_objective( level.OBJ_OBTAIN_CELERIUM, getstruct( "obj_celerium_chip" ), "done" );
	
}

// Each event's init_flags called here
level_init_flags()
{
	// LEVEL
	flag_init( "show_introscreen_title" );
	flag_init( "monsoon_gump_interior" );
	flag_init( "monsoon_gump_exterior" );
	
	// SYSTEMS
	flag_init( "monsoon_is_raining" );
	flag_init( "monsoon_is_rain_drops" );
	
	// PERKS
	flag_init( "intruder_perk_used" );
	flag_init( "brute_force_perk_used" );
	flag_init( "lock_breaker_perk_used" );
	flag_init( "player_asd_died" );
	
	// SECTION 1
	maps\monsoon_intro::init_intro_flags();
	maps\monsoon_wingsuit::init_wingsuit_flags();
	
	// SECTION 2
	maps\monsoon_ruins::init_ruins_flags();
	
	// SECTION 3
	maps\monsoon_lab::init_lab_flags();
	maps\monsoon_lab_defend::init_lab_defend_flags();
	maps\monsoon_celerium_chamber::init_celerium_flags();
}

//self is an ai, gives the AI a more aggressive behavior during combat
monsoon_hero_rampage( b_on )
{
	if( b_on )
	{
		self.oldgrenadeawareness = self.grenadeawareness;
		self.grenadeawareness = 0;
		self.ignoresuppression = true;
		self disable_react();
		self disable_careful();
	}
	else
	{
		if( IsDefined( self.oldgrenadeawareness ) )
		{
			self.grenadeawareness = self.oldgrenadeawareness;
			self.oldgrenadeawareness = undefined;
		}
		self.ignoresuppression = false;
		self enable_react();
		self enable_careful();
	}
}

//self is an enemy, made much easier to kill for whatever circumstance
weaken_ai()
{
	self.health = 1;
	self.attackerAccuracy = 10;	
}

//returns true if the player has a silenced weapon
player_has_silenced_weapon()
{
	a_current_weapons = level.player GetWeaponsList();
	
	foreach ( weapon in a_current_weapons )
	{
		if ( IsSubStr( weapon, "silencer" )  )
		{
			return true;
		}
	}
	
	return false;
}

//returns true if the player has the titus 6 weapon and it has ammo
#define TITUS_6_WEAPON_NAME "m32_titus_sp"
player_has_titus_6_weapon()
{
	if( level.player HasWeapon( TITUS_6_WEAPON_NAME ) )
	{
		if( level.player GetAmmoCount( TITUS_6_WEAPON_NAME ) )
		{
			return true;
		}
	}
	
	return false;
}

player_dualoptic_tutorial()
{
	self endon( "death" );
	
	while( 1 )
	{
		if( self ads_button_held() )
		{
			if ( IsSubStr( self GetCurrentWeapon(), "dualoptic" )  )
			{
				screen_message_create( &"MONSOON_TUTORIAL_SCOPE" );
				self thread _player_dualoptic_tutorial_timeout();
				self waittill_notify_or_timeout( "scope_toggled", 5 );
				self notify ( "tutorial_timeout" );
				screen_message_delete();
				return;
			}
		}
		wait 0.05;
	}	
}

_player_dualoptic_tutorial_timeout()
{
	self endon( "tutorial_timeout" );
	
	while( !self SprintButtonPressed() )
	{
		wait 0.05;
	}
	
	self notify( "scope_toggled" );
}

////////////////////////////////
//                            //
//         CAMO SUIT          //
//                            //
////////////////////////////////

//called on all AI in the level
setup_camo_suit_ai()
{
	if( !IsSubStr( ToLower( self.classname ), "camo" ) )
	{
		return;
	}
	
	self ent_flag_init( "camo_suit_on" );
	self ent_flag_set( "camo_suit_on" );
	
	self.movePlaybackRate = 1.6;
    self.canFlank = 1;
    self.aggressiveMode = 1;
    self.a.disableWoundedSet = true;
    self enable_heat();
    self thread deathFunction_clear_camo();
    
    //don't want the lower behavior if in the intro
    if( IsDefined( self._stealth ) )
	{
		return;
	}
    
    self.health = 250;
    self.maxHealth = 250;
       
    wait(RandomIntRange(5, 8));
    
    if(RandomInt(100) < 40)
    {
		self maps\_rusher::rush();
    }
}
	
deathFunction_clear_camo()
{
	self waittill( "death" );
	
	//if the camo suit was on take it off at death
	if( self ent_flag( "camo_suit_on" ) )
	{
		self toggle_camo_suit( true );
	}
}

setup_gasfreeze_ai()
{
	self.deathFunction = ::handle_gasfreeze_ai_death;
}

handle_gasfreeze_ai_death()
{
	if( self.damagemod != "MOD_GAS" )
		return false;
	
	self SetClientFlag( CLIENT_FLAG_GASFREEZE_TOGGLE );
	return false;
}

//self is an AI with the camo suit texture, turning on will take turn the suit off since the default is on
toggle_camo_suit( b_on, b_play_fx = true )
{
	//check to make sure AI has the camo suit
	if( !IsSubStr( ToLower( self.classname ), "camo" ) )
	{
		return;
	}
	
	//take camo off
	if( b_on )
	{
		self SetClientFlag( CLIENT_FLAG_CAMO_TOGGLE );
		self ent_flag_clear( "camo_suit_on" );
	}
	//turn camo on
	else
	{
		self ClearClientFlag( CLIENT_FLAG_CAMO_TOGGLE );
		self ent_flag_set( "camo_suit_on" );
	}

	if( b_play_fx )
	{
		PlayFXOnTag( getfx( "camo_transition" ), self, "J_SpineLower" );
	}
}

// lerps dof, fov, and maybe other stuff
lerp_vision( n_lerp_time, n_fov, n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur ) // self = player
{
	if( !IsDefined( n_fov ) ) // set defaults
	{
		n_fov = 65;
		n_near_start = .1;
		n_near_end = .6;
		n_far_start = 1;
		n_far_end = 6;
		n_near_blur = 0;
		n_far_blur = 0;
	}
	
	self thread lerp_fov_overtime( n_lerp_time, n_fov );
	self thread depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_lerp_time );
	
	wait n_lerp_time;
}

////////////////////////////////
//                            //
//         HELI CHAFF         //
//                            //
////////////////////////////////

heli_evade()
{
	self endon( "death" );
	
	while(1)
	{
		self waittill( "missile_fire", missile );
		
		if(self GetCurrentWeapon() != "strela_sp")
		{
			wait(0.05);
			continue;
		}
		
		heli = self.stingerTarget;
		heli thread heli_deploy_flares( missile );
		break;
	}
	
}

heli_deploy_flares( missile )
{
	self endon( "death" );
	
	if ( !IsDefined( missile ) )
		return;
		
	//Create an entity for the stinger to track
	vec_toForward = AnglesToForward( self.angles );
	vec_toRight = AnglesToRight( self.angles );
		
	self.chaff_fx = spawn( "script_model", self.origin );
	self.chaff_fx.angles = (0,180,0);
	self.chaff_fx SetModel( "tag_origin" );
	self.chaff_fx LinkTo( self , "tag_origin", ( 0, 0, -120 ), ( 0, 0, 0 ) );
		
	delta = self.origin - missile.origin;
	dot = VectorDot(delta,vec_toRight);
		
	sign = 1;
	if ( dot > 0 ) 
		sign = -1;
			
	// out to one side or the other slightly backwards
	chaff_dir = VectorNormalize(VectorScale( vec_toForward, -0.2 ) + VectorScale( vec_toRight, sign ));
		
	velocity = VectorScale( chaff_dir, RandomIntRange(400, 600));
	velocity = (velocity[0], velocity[1], velocity[2] - RandomIntRange(10, 100) );
	
	self.chaff_target = spawn( "script_model", self.chaff_fx.origin );
	self.chaff_target SetModel( "tag_origin" );
	self.chaff_target MoveGravity( velocity, 5.0 );
	
	// need to give the particle effect time to finish
	//self.chaff_fx thread delete_after_time( 5.0 );
		
	//Play the particle on this new spawned entity
	wait(0.1); // must wait a bit because of the bug where a new entity has its events ignored on the client side

	self.chaff_fx thread play_flares_fx();
		
	missile Missile_SetTarget( self.chaff_target );
		
	wait 0.5;
	
	if ( IsDefined(self.chaff_target) )
	{
		self.chaff_target Delete();
	}

	if ( IsDefined( missile ) )
	{
		missile Missile_SetTarget( undefined );
	}
				
	wait 1;
	
	if ( IsDefined( missile ) )
	{
		missile ResetMissileDetonationTime( 0 );
	}
}

play_flares_fx()
{
	self endon( "death" );
	
	for ( i = 0; i < 3; i++ )
	{
		PlayFXOnTag( getfx( "heli_chaff" ), self, "tag_origin" );
		wait 0.25;
	}
}

////////////////////////////////
//                            //
//         CHALLENGES         //
//                            //
////////////////////////////////

//self is the player in all challenge functions
setup_challenges( )
{
	//global challenges	
	self thread maps\_challenges_sp::register_challenge( "nodeath", ::challenge_nodeath );
	self thread maps\_challenges_sp::register_challenge( "locateintel", ::challenge_locateintel );
	
	//level challenges
	self thread maps\_challenges_sp::register_challenge( "tituskills", ::challenge_tituskills );
	self thread maps\_challenges_sp::register_challenge( "spotguys", maps\monsoon_intro::challenge_spotguys );
	self thread maps\_challenges_sp::register_challenge( "stealth", maps\monsoon_ruins::challenge_stealth );
	self thread maps\_challenges_sp::register_challenge( "turretkills", maps\monsoon_ruins::challenge_turretkills );
	
	self thread maps\_challenges_sp::register_challenge( "camokills", maps\monsoon_lab::challenge_camo_kills );
	self thread maps\_challenges_sp::register_challenge( "freezeasds", maps\monsoon_lab::challenge_freeze_asds );
	self thread maps\_challenges_sp::register_challenge( "saveisaac", ::challenge_save_isaac );
	self thread maps\_challenges_sp::register_challenge( "playerasd", ::challenge_save_player_asd );
}

challenge_nodeath( str_notify )
{
	self waittill( "mission_finished" );
	n_deaths = get_player_stat( "deaths" );
	
	if ( n_deaths == 0 )
	{
		self notify( str_notify );
	}
}
		
challenge_locateintel( str_notify )
{
	self waittill( "mission_finished" );
	b_player_collected_all = collected_all();
	
	if( b_player_collected_all )
	{
		self notify( str_notify );		
	}	
}

#define N_TITUS_KILLS 6
#define N_TITUS_WATCH 8
challenge_tituskills( str_notify )
{
	level.n_titus_kills = 0;
	
	while( 1 )
	{
		self waittill( "weapon_fired", str_weapon );
		if( str_weapon == "m32_titus_sp" )
		{
			a_living_enemies = GetAIArray( "axis" );
			array_thread( a_living_enemies, ::challenge_tituskills_think );
			
			wait N_TITUS_WATCH;
			
			level notify( "stop_titus_challenge_watch" );
			
			//if kills are 6 or greater award challenge
			if( level.n_titus_kills >= N_TITUS_KILLS )
			{
				self notify( str_notify );
				return;
			}
			else
			{
				level.n_titus_kills = 0;
			}
		}
	}
}

challenge_tituskills_think()
{
	level endon( "stop_titus_challenge_watch" );
	
	self waittill( "death", attacker, type, weapon );
	
	if( IsDefined( weapon ) )
	{
		if( weapon == "explosive_dart_sp" || weapon == "m32_titus_dart_sp" )
		{
			level.n_titus_kills++;	
		}
	}
}

challenge_save_isaac( str_notify )
{
	flag_wait( "lab_defend_done" );
	
	if ( !flag( "isaac_is_killed" ) )
    {
		self notify( str_notify ); 	
    }
}

challenge_save_player_asd( str_notify )
{
	flag_wait( "player_at_celerium" );
	
	if ( !flag( "player_asd_died" ) )
    {
		self notify( str_notify ); 	
    }	
}


////////////////////////////////
//                            //
//     WEATHER SCRIPTS        //
//                            //
////////////////////////////////

set_rain_level( n_level )
{
	if ( n_level > 5 )
	{
		n_level = 5;
	}
	
	if ( n_level == 0 )
	{
		flag_clear( "monsoon_is_raining" );
		remove_global_spawn_function( "axis", ::_ai_rain_thread );
		level notify( "_rain_thread" );
		level notify( "_rain_drops" );
		level.player ClearClientFlag( CLIENT_FLAG_PLAYER_RAIN );
	}
	else
	{
		level thread _rain_thread( n_level );
		if( !flag( "monsoon_is_raining" ) )
		{
			add_global_spawn_function( "axis", ::_ai_rain_thread );
			level thread _rain_drops();
			level thread _lightning();
		}
		level.player SetClientFlag( CLIENT_FLAG_PLAYER_RAIN );
		flag_set( "monsoon_is_raining" );
		/#
			IPrintLn( "rain level: " + n_level );
		#/
	}
}

_ai_rain_thread()
{
	self endon( "death" );
	
	while( 1 )
	{
		PlayFXOnTag( getfx( "ai_rain" ), self, "j_spine4" );
		PlayFXOnTag( getfx( "ai_rain_helmet" ), self, "j_head_end" );
		wait RandomFloatRange( 0.2, 0.3 );
	}
}

_rain_thread( n_level )
{
	level notify( "_rain_thread" );
	level endon( "_rain_thread" );
	
	if( n_level == 5 )
	{
		level thread _wind_shake();
	}
	
	n_wait = 0.6 - ( n_level / 10 );
	
	while ( true )
	{
		PlayFX( getfx( "player_rain" ), level.player GetOrigin() );
		wait n_wait;
	}
}

#define WIND_SHAKE_TIME_MIN 5.0
#define WIND_SHAKE_TIME_MAX 15.0
_wind_shake()
{
	level endon( "_rain_thread" );
	
	level.weather_wind_shake = true;
	
	while( IsAlive( level.player ) )
	{
		wait RandomFloatRange( WIND_SHAKE_TIME_MIN, WIND_SHAKE_TIME_MAX );
		
		if( level.weather_wind_shake && ( level.player GetStance() != "prone" ) )
		{
			n_wind_time = RandomFloatRange( 2.0, 4.0 );
			
			Earthquake( 0.1, n_wind_time + 2.0, level.player.origin, 500, level.player );
			level.player PlayRumbleLoopOnEntity( "tank_rumble" );

			level.player playsound( "evt_wind_shake" );	
			
			wait n_wind_time;
			level.player StopRumble( "tank_rumble" );
		}
	}
}

_rain_drops()
{
	level endon( "_rain_drops" );
	
//TODO rewrite this with the shader
//	while ( IsAlive( level.player ) )
//	{
//		v_p_angles = level.player GetPlayerAngles();
//	
//		if( v_p_angles[0] < -30 )
//		{
//			traceData = BulletTrace( level.player.origin, level.player.origin + ( 0, 0, 500 ), false, level.player );
//			if( tracedata[ "fraction" ] == 1)
//			{
//				if( !flag( "monsoon_is_rain_drops" ) )
//				{
//   					level.player SetWaterDrops( 50 );
//   					flag_set( "monsoon_is_rain_drops" );
//				}
//			}
//			else
//			{
//				flag_clear( "monsoon_is_rain_drops" );
//				level.player SetWaterDrops( 1 );
//			}
//		}
//		else
//		{
//			flag_clear( "monsoon_is_rain_drops" );
//			level.player SetWaterDrops( 1 );
//		}
//
//		wait 0.5;	
//	}
}

_lightning()
{
	level endon( "_rain_drops" );
	
	while ( IsAlive( level.player ) )
	{
		v_p_angles = level.player GetPlayerAngles();
		
		//find a position far away from the player in front of him
		v_forward = AnglesToForward( level.player GetPlayerAngles() ) * 25000;
		v_end_pos = level.player.origin + ( v_forward[0], v_forward[1], 0 );
		
		//an additional offset in case the player is just standing there
		v_offset = ( RandomIntRange( -5000, 5000 ), RandomIntRange( -5000, 5000 ), RandomInt( 3000 ) );
		v_end_pos = v_end_pos + v_offset;
		
		PlayFX( getfx( "fx_lightning_flash_single_lg" ), v_end_pos );
		
		wait RandomFloatRange( 0.2, 0.5 );
		
		n_level_exposure = GetDvarFloat( "r_exposureValue" );
	
		SetDvar( "r_exposureValue", 2.8 );
		lerp_dvar( "r_exposureValue", n_level_exposure, 0.3 );
		SetDvar( "r_exposureValue", 2.8 );
		lerp_dvar( "r_exposureValue", n_level_exposure, 0.2 );
		
		wait RandomFloatRange( 5.0, 10.0 );
	}
}

////////////////////////////////
//                            //
//      OUTSIDE LIFT          //
//                            //
////////////////////////////////

#define LIFT_MOVE_TIME 10
#define LIFT_DOOR_DIST 60
#define LIFT_DOOR_TIME 2
outside_lift_init()
{
	m_lift = GetEnt( "lift_ruins_clip", "targetname" );
	m_lift SetMovingPlatformEnabled( true );
	
	//set position of lift
	m_lift.b_top = true;
	
	//link the use trigger
	t_use = GetEnt( "lift_use_trigger", "targetname" );
	t_use EnableLinkTo();
	t_use LinkTo( m_lift );
	t_use SetHintString( &"MONSOON_LIFT_PROMPT" );
	t_use SetCursorHint( "HINT_NOICON" );
	
	//link the elevator doors
	a_m_doors[0] = GetEnt( "lift_ruins_door_2_left", "targetname" );
	a_m_doors[1] = GetEnt( "lift_ruins_door_2_right", "targetname" );
	a_m_doors[2] = GetEnt( "lift_ruins_door_1_left", "targetname" );
	a_m_doors[3] = GetEnt( "lift_ruins_door_1_right", "targetname" );
	foreach( m_door in a_m_doors )
	{
		m_door LinkTo( m_lift );
	}
	
	//link clips to models
	m_lift.m_model = GetEnt( "lift_ruins", "targetname" );
	m_lift.m_model LinkTo( m_lift );
	a_m_doors_clip[0] = GetEnt( "lift_ruins_door_2_left_clip", "targetname" );
	a_m_doors_clip[1] = GetEnt( "lift_ruins_door_2_right_clip", "targetname" );
	a_m_doors_clip[2] = GetEnt( "lift_ruins_door_1_left_clip", "targetname" );
	a_m_doors_clip[3] = GetEnt( "lift_ruins_door_1_right_clip", "targetname" );
	for( i = 0; i < a_m_doors_clip.size; i++ )
	{
		a_m_doors_clip[i] LinkTo( a_m_doors[i] );
	}
	
	//play FX on the lift model
	m_lift.m_model play_fx( "lift_light", m_lift.m_model.origin, m_lift.m_model.angles, undefined, true );
	
	//sort through the various nodes on the lift
	m_lift.a_top_nodes = GetNodeArray( "lift_top", "targetname" );
	m_lift.a_bottom_nodes = GetNodeArray( "lift_bottom", "targetname" );
	array_func( m_lift.a_top_nodes, ::node_connect_to_path );
		
	//assign the top and bottom position of the lift
	m_lift.v_lift_top = m_lift.origin;
	m_lift.v_lift_bottom = ( m_lift.origin[0], m_lift.origin[1], getstruct( "lift_end", "targetname" ).origin[2] );

	//start player elevator logic
	while( !flag( "seal_ruins" ) )
	{
		t_use SetHintString( &"MONSOON_LIFT_PROMPT" );
		t_use waittill( "trigger" );
		t_use SetHintString( "" );
		
		if( flag( "seal_ruins" ) )
		{
			continue;
		}
		
		level notify( "player_used_outside_lift" );
		
		if( m_lift.b_top )
		{
			outside_lift_move_down();
		}
		else
		{
			outside_lift_move_up();
		}
	}
	
	//cleanup
	foreach( model in a_m_doors )
	{
		model Delete();
	}
	foreach( model in a_m_doors_clip )
	{
		model Delete();
	}
	t_use Delete();
	m_lift.m_model Delete();
	m_lift Delete();
}

//self is the lift model
outside_lift_move_down()
{
	m_lift = GetEnt( "lift_ruins_clip", "targetname" );
		
	array_func( m_lift.a_top_nodes, ::node_disconnect_from_path );
	
	m_door_north_l = GetEnt( "lift_ruins_door_2_left", "targetname" );
	m_door_north_r = GetEnt( "lift_ruins_door_2_right", "targetname" );
	
	m_door_north_l Unlink();
	m_door_north_r Unlink();
	
	m_door_north_l MoveY( -LIFT_DOOR_DIST, LIFT_DOOR_TIME, LIFT_DOOR_TIME / 4 );
	m_door_north_r MoveY( LIFT_DOOR_DIST, LIFT_DOOR_TIME, LIFT_DOOR_TIME / 4 );
	
	m_door_north_r waittill( "movedone" );
	m_door_north_l LinkTo( m_lift );
	m_door_north_r LinkTo( m_lift );	
	
	m_lift MoveTo( m_lift.v_lift_bottom, LIFT_MOVE_TIME, ( LIFT_MOVE_TIME / 5 ), ( LIFT_MOVE_TIME / 5 ) );
	m_lift waittill( "movedone" );
	
	m_door_south_l = GetEnt( "lift_ruins_door_1_left", "targetname" );
	m_door_south_r = GetEnt( "lift_ruins_door_1_right", "targetname" );
	
	m_door_south_l Unlink();
	m_door_south_r Unlink();
	
	m_door_south_l MoveY( LIFT_DOOR_DIST, LIFT_DOOR_TIME, LIFT_DOOR_TIME / 4 );
	m_door_south_r MoveY( -LIFT_DOOR_DIST, LIFT_DOOR_TIME, LIFT_DOOR_TIME / 4 );
	
	m_door_south_r waittill( "movedone" );

	m_door_south_l LinkTo( m_lift );
	m_door_south_r LinkTo( m_lift );	
	
	array_func( m_lift.a_bottom_nodes, ::node_connect_to_path );
	
	m_lift.b_top = false;
}

//self is the lift model
outside_lift_move_up()
{
	m_lift = GetEnt( "lift_ruins_clip", "targetname" );
		
	array_func( m_lift.a_bottom_nodes, ::node_disconnect_from_path );
	
	m_door_south_l = GetEnt( "lift_ruins_door_1_left", "targetname" );
	m_door_south_r = GetEnt( "lift_ruins_door_1_right", "targetname" );
	
	m_door_south_l Unlink();
	m_door_south_r Unlink();
	
	m_door_south_l MoveY( -LIFT_DOOR_DIST, LIFT_DOOR_TIME, LIFT_DOOR_TIME / 4 );
	m_door_south_r MoveY( LIFT_DOOR_DIST, LIFT_DOOR_TIME, LIFT_DOOR_TIME / 4 );
	
	m_door_south_r waittill( "movedone" );

	m_door_south_l LinkTo( m_lift );
	m_door_south_r LinkTo( m_lift );	
	
	m_lift MoveTo( m_lift.v_lift_top, LIFT_MOVE_TIME, ( LIFT_MOVE_TIME / 5 ), ( LIFT_MOVE_TIME / 5 ) );
	m_lift waittill( "movedone" );
	
	m_door_north_l = GetEnt( "lift_ruins_door_2_left", "targetname" );
	m_door_north_r = GetEnt( "lift_ruins_door_2_right", "targetname" );
	
	m_door_north_l Unlink();
	m_door_north_r Unlink();
	
	m_door_north_l MoveY( LIFT_DOOR_DIST, LIFT_DOOR_TIME, LIFT_DOOR_TIME / 4 );
	m_door_north_r MoveY( -LIFT_DOOR_DIST, LIFT_DOOR_TIME, LIFT_DOOR_TIME / 4 );
	
	m_door_north_r waittill( "movedone" );
	m_door_north_l LinkTo( m_lift );
	m_door_north_r LinkTo( m_lift );	
	
	array_func( m_lift.a_top_nodes, ::node_connect_to_path );
	
	m_lift.b_top = true;

}

////////////////////////////////
//                            //
//       COLORS UTILITY		  //
//                            //
////////////////////////////////

use_trigger_on_group_clear( str_group_name, str_trigger_name )
{
	t_color = GetEnt( str_trigger_name, "targetname" );
	
	if( IsDefined( t_color ) )
	{
		t_color thread _use_trigger_on_group_clear_think( str_group_name );
	}
}

_use_trigger_on_group_clear_think( str_group_name )
{
	self endon( "trigger" );
	self endon( "death" );
	
	waittill_ai_group_cleared( str_group_name );
	
	self notify( "trigger" );
}

use_trigger_on_group_count( str_group_name, str_trigger_name, n_count, b_weaken )
{
	if( !IsDefined( b_weaken) )
	{
		b_weaken = false;
	}
	
	t_color = GetEnt( str_trigger_name, "targetname" );
	
	if( IsDefined( t_color ) )
	{
		t_color thread _use_trigger_on_group_count_think( str_group_name, n_count, b_weaken );
	}
}

_use_trigger_on_group_count_think( str_group_name, n_count, b_weaken )
{
	self endon( "trigger" );
	self endon( "death" );
	
	waittill_ai_group_count( str_group_name, n_count );

	//make remaining AI in the group have low health and easier to hit
	if( b_weaken )
	{
		array_func( get_ai_group_ai( str_group_name ), ::weaken_ai );
	}
	
	self notify( "trigger" );
}

////////////////////////////////
//                            //
//       PLAYER ASD PERK	  //
//                            //
////////////////////////////////
bruteforce_perk_asd()
{
	flag_wait( "lift_at_bottom" );
	
	run_scene_first_frame( "bruteforce_perk_asd_door" );
	
	//create the use trigger for the perk
	t_use = GetEnt( "trig_asd_player", "targetname" );
	t_use SetHintString( &"MONSOON_LIFT_PROMPT" );
	t_use SetCursorHint( "HINT_NOICON" );
	t_use trigger_off();
	
	level.player waittill_player_has_brute_force_perk();
	
	t_use trigger_on();	
	set_objective( level.OBJ_BRUTEFORCE, t_use, "interact" );
	
	t_use waittill( "trigger", player );
	
	set_objective( level.OBJ_BRUTEFORCE, t_use, "remove" );	
	t_use Delete();
	
	flag_set( "brute_force_perk_used" );
	
	//play jaws of life, then play arm band hack
	vh_asd_player_perk = spawn_vehicle_from_targetname( "asd_player_perk" );
	vh_asd_player_perk thread asd_player_think();
	
	level thread run_scene( "bruteforce_perk_asd_door" );
	run_scene( "bruteforce_perk" );
	
	flag_set( "player_asd_rollout" );
}

monitor_player_asd_death()
{
	self waittill( "death" );
  	flag_set( "player_asd_died" );	
}

asd_player_think()
{
	self endon( "death" );

	flag_wait( "open_asd_door" );

	self thread monitor_player_asd_death();
	
	level.player PlayRumbleOnEntity( "damage_heavy" );	
		
	flag_wait( "player_asd_rollout" );	
	
	self maps\_metal_storm::metalstorm_on();
	self thread maps\_metal_storm::metalstorm_set_team( "allies" );
	
	wait 2;
	
	self.ignoreme = 1;
	self veh_magic_bullet_shield( true );
	self thread player_asd_rumble();
	
	s_asd_player_rollout_spot = getstruct( "asd_player_rollout_spot", "targetname" );
	self SetVehGoalPos( s_asd_player_rollout_spot.origin, true, 2, true );
	self waittill_any( "goal", "near_goal" );	
	
	s_asd_player_defend_spot = getstruct( "asd_player_defend_spot", "targetname" );
	self SetVehGoalPos( s_asd_player_defend_spot.origin, true, 2, true );
	self waittill_any( "goal", "near_goal" );	
	
	self.ignoreme = 0;
	self veh_magic_bullet_shield( false );
	
	self maps\_vehicle::defend( self.origin, 400 );
}

player_door_rumble() //self = struct by door
{	
	if ( self.is_big_door )
	{
		is_big_door = false;	
		n_rumble_distance = 1000;
	}
	else
	{
		n_rumble_distance = 500;
	}
	
	while ( self.is_moving )
	{	
		n_distance = Distance( self.origin, level.player.origin );
		if ( n_distance < n_rumble_distance )
		{	
			level.player PlayRumbleOnEntity( "tank_rumble" );
		}	
		
		wait 0.05;
	}
}

player_asd_rumble()
{
	self endon( "death" );
	
	while ( 1 )
	{	
		n_distance = Distance( self.origin, level.player.origin );
		if ( n_distance < 200 )
		{	
			level.player PlayRumbleOnEntity( "tank_rumble" );
		}	
		
		wait 0.05;
	}
}

monsoon_light_rumble( guy )
{

	level.player PlayRumbleOnEntity( "damage_light" );

}

monsoon_heavy_rumble( guy )
{
	level.player PlayRumbleOnEntity( "damage_heavy" );
	
}

////////////////////////////////
//                            //
//    PLAYER INPUT WATCH	  //
//                            //
////////////////////////////////

/* ------------------------------------------------------------------------
 * waits for player input
 * when the designated input happens, continue
 * Mandatory: button press - "ltrig_rtrig", "lstick", "rstick"
 * 			  direction (if stick) - "forward", "backward", "left", "right"
 ------------------------------------------------------------------------*/
waittill_input( str_hint, str_buttonpress, str_direction ) // self = player
{
	if( IsDefined( str_hint ) )
	{
		screen_message_create( str_hint );
	}
		
	if( str_buttonpress == "ltrig_rtrig" )
	{
		self _input_both_triggers_pulled();
	}
	else if( str_buttonpress == "lstick" || str_buttonpress == "rstick" )
	{
		self _input_stick( str_buttonpress, str_direction );
	}
	else
	{
		self _input_button( str_buttonpress );
	}
	
	if( IsDefined( str_hint ) )
	{
		screen_message_delete();
	}
}

/* -------------------------------------------------
 * listen for both triggers pulled
 -------------------------------------------------*/
_input_both_triggers_pulled() // self = player
{
	level endon( "input_trigs_detected" );
	self endon( "stop_input_detection" );
	
	while( true )
	{
		if( self ThrowButtonPressed() && self AttackButtonPressed() )
		{
			flag_set( "input_trigs_detected" );
			break;
		}
		wait .05;
	}
}

/* -----------------------------------------------------------------------
 * listen for LStick input
 * Mandatory: desired direction - "forward", "right", "backward", "left"
 * 			  which stick - "rstick", "lstick"
 -----------------------------------------------------------------------*/
_input_stick( str_stick, str_direction ) // self = player
{
	level endon( "input_lstick_detected" );
	self endon( "stop_input_detection" );
	
	n_axis = 0; // z
	n_dot = -.75; // left, back
	
	if( IsDefined( str_direction ) )
	{
		if( str_direction == "forward" || str_direction == "right" )
		{
			n_dot = .85;
		}
		if( str_direction == "right" || str_direction == "left" )
		{
			n_axis = 1;
		}
	}
	
	while( true )
	{	
		if( str_stick == "lstick" )
		{	
			stick = self GetNormalizedMovement()[n_axis];
		}
		else 
		{
			stick = self GetNormalizedCameraMovement()[n_axis];
		}
		if( stick <= n_dot )
		{	
			break;
		}
		wait .05;
	}
	
	level notify( "input_stick_detected" );
	flag_set( "input_lstick_detected" );
}

/* ---------------------------------------------------------------------
 * listen for button input
 * Mandatory: button press (defaults to reload button for now)
 ---------------------------------------------------------------------*/
_input_button( str_button )
{
	level endon( "input_button_press_detected" );
	self endon( "stop_input_detection" );
	
	b_input = false;
	
	while( !b_input )
	{
		switch( str_button )
		{
			case "reload_button":
				if( self UseButtonPressed() )
					b_input = true;
				break;
			case "ads_button":
				if( self ThrowButtonPressed() )
					b_input = true;
				break;
			case "attack_button":
				if( self AttackButtonPressed() )
					b_input = true;
				break;
			case "jump_button":
				if( self JumpButtonPressed() )
					b_input = true;
				break;
		}
		wait 0.05;
	}
	
	level notify( "input_button_press_detected" );
}

////////////////////////////////
//                            //
//    SCRIPTED WIND SWAY	  //
//                            //
////////////////////////////////
sway_init()
{
	flag_wait( "monsoon_gump_exterior" );
	
	a_structs = getstructarray( "sway", "targetname" );
	foreach( struct in a_structs )
	{
		e_origin = Spawn( "script_origin" , struct.origin );
		e_origin.m_model = GetEnt( struct.target, "targetname" );
		switch( e_origin.m_model.model )
		{
			case "p6_container_yard_light":
				e_origin.m_model Attach( "p6_container_yard_light_on", "tag_origin" );
				e_origin.m_model _sway_fx( "light_yard", "tag_light1" );
				e_origin.m_model _sway_fx( "light_yard", "tag_light2" );
				break;
			case "ctl_light_spotlight_generator":
				e_origin.m_model Attach( "ctl_light_spotlight_generator_on", "tag_origin" );
				e_origin.m_model _sway_fx( "light_generator", "tag_fx_bulb_1" );
				e_origin.m_model _sway_fx( "light_generator", "tag_fx_bulb_2" );
				e_origin.m_model _sway_fx( "light_generator", "tag_fx_bulb_3" );
				break;
			case "p6_stadium_light_pole":
				e_origin.m_model Attach( "p6_stadium_light_pole_on", "tag_origin" );
				e_origin.m_model _sway_fx( "light_pole", "tag_fx_light1" );
				e_origin.m_model _sway_fx( "light_pole_b", "tag_fx_light2" );
				e_origin.m_model _sway_fx( "light_pole", "tag_fx_light3" );
				e_origin.m_model _sway_fx( "light_pole_b", "tag_fx_light4" );
				break;
			case "ctl_spotlight_modern_3x":
				e_origin.m_model Attach( "ctl_spotlight_modern_3x_on", "tag_origin" );
				e_origin.m_model _sway_fx( "light_3x", "tag_light" );
				break;
		}
		
		e_origin thread _sway_think( struct.script_noteworthy );
		wait 0.05;
	}
	
	//for large trees don't use an extra entity
	a_models = GetEntArray( "sway", "targetname" );
	foreach( model in a_models )
	{
		model thread _sway_tree_think();
		wait 0.05;
	}
}

//self is the model of the light
_sway_fx( str_fx_name, str_tag )
{
	//if the model has a script_noteworthy of "emp_light_model" it will need to be deleted later
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "emp_light_model" )
	{
		self play_fx( str_fx_name, undefined, undefined, "turn_off", true, str_tag );
	}
	//otherwise use PlayFXOnTag to save on entities
	else
	{
		PlayFXOnTag( getfx( str_fx_name ), self, str_tag );
	}					
}

_sway_tree_think()
{
	while( !flag( "seal_ruins" ) )
	{
		self _sway_model( 0.4, 0.75 );
	}
	self Delete();
}

_sway_think( str_type )
{
	Assert( IsDefined( str_type ), "Sway origin has no script_noteworthy set." );
	
	v_wind_dir = VectorToAngles( GetDvarVector( "wind_global_vector" ) );
	self RotateTo( v_wind_dir, 0.05 );
	self waittill( "rotatedone" );
	
	self.m_model LinkTo( self );
	
	while( !flag( "seal_ruins" ) )
	{
		switch( str_type )
		{
			case "tree":
				self _sway_model( 1, 0.5 );
				break;
			case "light":
				self _sway_model( 2, 0.5 );
				break;
			case "wheels":
				self _sway_model( 1, 0.5 );
				break;
			case "mounted":
				self _sway_model( 1, 0.5 );
				break;
		}
	}
	
	self.m_model Delete();
	self Delete();
}
	
_sway_model( n_degree, n_time )
{
	n_random = n_time / 2;
	
	self RotateRoll( n_degree, n_time, RandomFloatRange( 0.05, n_random ), RandomFloatRange( 0.05, n_random ) );
	self waittill( "rotatedone" );
	self RotateRoll( -n_degree, n_time, RandomFloatRange( 0.05, n_random ), RandomFloatRange( 0.05, n_random ) );
	self waittill( "rotatedone" );
}