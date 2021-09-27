#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_common;
#include maps\castle_code;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_intro()
{
	move_player_to_start( "start_approach" );
	setup_price_for_start( "start_approach", undefined, true );
	set_ents_visible( "startvista", true );
}

// Main Functions	/////////////////////////////////////////////////////////////////////////////////////

main()
{
	level.SAFE_HEIGHT_MIN = 300;
	
	init_event();
	maps\castle_parachute_sim::setup_player_rig();
	//maps\castle_parachute_sim::setup_altimeter();
	maps\castle_parachute_sim::setup_parachute_model();
	level thread maps\castle_ruins::ruins_weather();
	
	//set_cloud_lightning( 3, 6 );
	
	level.player thread maps\castle_parachute_sim::start_parachute_sim();	
	//level thread maps\castle_parachute_sim::setup_thermal_vents();
		
	//level.player thread altimeter();
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	
	level.player thread player_fx();
	level.player thread parachute_scripting();
	level.player.parachute_tweaks["disable_input"] = true;
	//level.player thread parachute_tree_tops();
		
	setup_price( ::parachute_price, true );
	
	maps\_utility::vision_set_fog_changes( "castle_intro", 0 );
	
	aud_send_msg("map_start");
	
	wait(4.75);
	level.player NightvisionGogglesForceOn();

	level.fake_price = level.price;
	setup_price( ::do_landing_scene );

	flag_wait( "player_landed" );
	
	flag_set( "start_water_splash_fx" );
	
	save_game( "ruins_start" );

	set_ents_visible( "startvista", true );
	
	wait(0.5);
}

init_event_flags()
{
	flag_init( "too_low" );
	flag_init( "too_high" );
	
	flag_init( "intro_done" );	
	flag_init( "parachute_cliff_drop" );
	flag_init( "objective_landing" );
	flag_init( "player_landing" );
	flag_init( "player_landed" );
}

init_event()
{
	battlechatter_off( "allies" );
	
	parachute_player = GetEnt( "parachute_ground_ruins", "targetname" );
	parachute_player Hide();
}

player_fx()
{
	fx_wind = getfx( "wind_rush_chute" );
	PlayFXOnTag( fx_wind, self.m_player_rig, "tag_camera" );
}

stop_player_fx()
{
	fx_wind = getfx( "wind_rush_chute" );
	StopFXOnTag( fx_wind, self.m_player_rig, "tag_camera" );
}

parachute_price()
{
//	level endon( "player_landing" );
//	
//	if ( level.start_point != "landing" )
//	{
//		self thread parachute_price_vo();
//	}
	
	//flag_wait( "parachute_cliff_drop" );
	//wait 1.8;
	
	maps\castle_parachute_sim::start_ai_parachute_sim( self.target );
//	self thread price_speed_control();
//	
//	if ( !flag( "intro_done" ) )
//	{
//		self price_intro_anim();
//	}
	
	self thread maps\castle_parachute_sim::parachute_ai_anims();
	
	//level.player.m_altimeter thread track_price();
}

#using_animtree( "generic_human" );
price_intro_anim()
{
	self thread price_parachute_intro_anim();
	
	self SetFlaggedAnimKnobAll( "intro", self getanim( "intro" ), %root, 1, 0, 1 );
	self waittillmatch( "intro", "end" );	
}

#using_animtree( "vehicles" );
price_parachute_intro_anim()
{
	self.parachute_canopy SetFlaggedAnimKnobAll( "intro", self.parachute_canopy getanim( "intro" ), %root, 1, 0, 1 );
	self waittillmatch( "intro", "end" );
}

//parachute_price_vo()
//{
//	if ( !flag( "reached_fire_pockets" ) )
//	{
//		level waittill( "introscreen_complete" );
//		
//		level.player.parachute_tweaks["disable_input"] = true;
//		
//		wait 3;
//		
//		self dialogue_queue( "castle_pri_upgrades" );
//		
//		//one shot bolt in the distance
//		set_lightning( 10, 15 );
//		
//		level.player.parachute_tweaks["disable_input"] = false;
//		
//		self display_hint( "parachute_steer" );
//		level thread autosave_by_name( "intro_over" );
//		
//		wait 0.5;
//		self dialogue_queue( "castle_pri_controlcenter" );
//		wait 0.5;
//		self dialogue_queue( "castle_pri_halfaclick" );
//		
//		//no more lightning until we land
//		set_lightning( 0, 0 );
//		
////		wait 0.5;
////		self dialogue_queue( "castle_pri_mylead" );
////		wait 3;
////		self dialogue_queue( "castle_pri_nice" );
//		flag_wait( "reached_fire_pockets" );
//	}	
//	
//	self dialogue_queue( "castle_pri_harvest" );
//	wait .5;
//	self dialogue_queue( "castle_pri_smokecover" );
////	wait 1;
////	self dialogue_queue( "castle_pri_staywithme" );
//	wait 1;
//	self dialogue_queue( "castle_pri_lzupahead" );
//	wait 1;
//	self dialogue_queue( "castle_pri_land" );
//}
//
//price_speed_control()
//{
//	self endon( "death" );
//	level endon( "player_landing" );
//	
//	level.PRICE_ACCELERATION = 150;
//	
//	n_speed_current = level.PRICE_SPEED_MIN;
//	
//	self.parachute_canopy Hide();
//	
//	self thread chute_show();
//	
//	while ( true )
//	{
//		if ( IsDefined( self.speed_override ) )
//		{
//			maps\castle_parachute_sim::set_ai_speed( self.speed_override );
//		}
//		else
//		{
//			v_player_origin = level.player.parachute_canopy.origin;
//			v_player_angles = level.player.parachute_canopy.angles;
//			
//			v_price_origin = level.price.parachute_canopy.origin;
//			v_price_angles = level.price.parachute_canopy.angles;
//			
//			v_player_forward = AnglesToForward( v_player_angles );
//			
//			n_dist = clamp( Distance2D( v_price_origin, v_player_origin ), 0, level.PRICE_MAX_DIST );
//			
//			v_price_pos = ( v_price_origin[0], v_price_origin[1], v_player_origin[2] );
//			n_dot_to_price = VectorDot( v_player_forward, VectorNormalize( v_price_pos - v_player_origin ) );
//			n_dot_scale = linear_map_clamp( n_dot_to_price, -1, 1, 0, 1 );
//			
//			n_dist_frac = ( n_dist / level.PRICE_MAX_DIST );
//			n_speed_scale = 1 - ( n_dot_scale * n_dist_frac );
//			
//			n_speed_new = linear_map_clamp( n_speed_scale, 0, 1, level.PRICE_SPEED_MIN, level.PRICE_SPEED_MAX );
//			
//			if ( ( n_speed_new - n_speed_current ) > 0 )
//			{
//				n_speed_new = n_speed_current + level.PRICE_ACCELERATION * .05;
//			}
//			else
//			{
//				n_speed_new = n_speed_current - level.PRICE_ACCELERATION * .05;
//			}
//			
//			maps\castle_parachute_sim::set_ai_speed( n_speed_new );
//			n_speed_current = n_speed_new;
//		}
//		
//		wait .05;
//	}
//}
//
//chute_show()
//{
//	wait 3.0;
//
//	self.parachute_canopy Show();
//}

parachute_scripting()
{
	level.PRICE_SPEED_MIN = 805;
	level.PRICE_SPEED_MAX = 1000;
	level.PRICE_MAX_DIST = 10;
	level.PRICE_ACCELERATION = 10;
	
	self.parachute_tweaks["max_speed"] = 800;
	self.parachute_tweaks["min_speed"] = 800;
	
	self.parachute_tweaks["disable_flare"] = false;
	self.parachute_tweaks["disable_fall"] = false;
	
	delayThread( 6, ::exploder, 301 );
	
	if ( !flag( "parachute_cliff_drop" ) )
	{
		self.parachute_tweaks["max_fall_speed"] = 120;
		self.parachute_tweaks["gravity"] = 100;
		
		//returning early for new design
		while ( !flag( "player_landing" ) )
		{
			Earthquake( 0.1, 0.05, self.origin, 100 );
			wait .05;
		}
		if( flag( "player_landing" ) )
		{
			return;
		}

		flag_wait( "parachute_cliff_drop" );
		
		self.parachute_tweaks["max_speed"] = 900;
		self.parachute_tweaks["min_speed"] = 900;
		
		self.parachute_tweaks["max_fall_speed"] = 500;
		self.parachute_tweaks["gravity"] = 500;
		
		s_fire_pockets = getstruct( "start_fire_pockets", "targetname" );
	
		self.parachute_tweaks["max_speed"] = 800;
		self.parachute_tweaks["min_speed"] = 800;
		
		flag_set( "objective_landing" );
		flag_set( "parachute_cliff_drop" );
	}
	
	//allow some fall off	
	self.parachute_tweaks["gravity"] = 20;
	self.parachute_tweaks["max_fall_speed"] = 20;
	
	//guide the player through the turn
	wait 4;
	level.PRICE_MAX_DIST = 100;
	self thread fail_thread();
	self.parachute_dynamics["goal_pos"] = getstruct( "parachute_steer", "targetname" ).origin;
	
	wait 5;
	
	//Price slows down to give player the lead
	level.PRICE_SPEED_MIN = 700;
	level.PRICE_SPEED_MAX = 750;
	
	wait 3.25;
	
	self.parachute_dynamics["goal_pos"] = undefined;
	
	flag_wait( "reached_fire_pockets" );
		
	self.parachute_tweaks["max_speed"] = 900;
	self.parachute_tweaks["min_speed"] = 900;
		
	self.parachute_tweaks["gravity"] = 0;
	self.parachute_tweaks["max_fall_speed"] = 0;
	
	//level.PRICE_MAX_DIST = 600;
	//level.PRICE_ACCELERATION = 80;
	
	// ramp speed up for fire pockets
//	while ( self.parachute_tweaks["max_speed"] < 700 )
//	{
//		self.parachute_tweaks["min_speed"] = self.parachute_tweaks["min_speed"] + 10;
//		self.parachute_tweaks["max_speed"] = self.parachute_tweaks["max_speed"] + 10;
//		wait .2;
//	}
	
	//level.PRICE_ACCELERATION = 150;
	
	flag_wait( "approaching_landing" );
	
	level.PRICE_ACCELERATION = 60;
	level.PRICE_MAX_DIST = 100;
}

fail_thread()
{
	if(level.start_point != "intro")
		return;
	
	MAX_DIST_FROM_PRICE = 3000;
	
	level endon( "missionfailed" );
	
	while ( !flag( "player_landing" ) )
	{
		n_dist = Distance2D( self.origin, level.price.origin );
					
		if ( n_dist > MAX_DIST_FROM_PRICE )
		{
			self.parachute_tweaks["gravity"] = 200;
			self.parachute_tweaks["max_fall_speed"] = 400;
			
			wait 5;
			
			SetDvar( "ui_deadquote", &"CASTLE_FAILED_TO_FOLLOW" );
			level thread missionFailedWrapper();
			break;
		}
		
		wait .05;
	}
}

MAX_HEIGHT = 9000;
get_player_height_from_ground()
{
	n_height = MAX_HEIGHT;
	
	a_trace = BulletTrace( self.origin, self.origin + ( 0, 0, -1 * MAX_HEIGHT ), false, undefined, true );
	
	if ( IsDefined( a_trace[ "position" ] ) )
	{
		n_height = Distance( a_trace[ "position" ], self.origin );
	}
	
	return n_height;
}

// self = align node
move_to_landing_spot()
{
	level.player.parachute_tweaks["disable_fall"] = true;
	level.player.parachute_dynamics["ai_controlled"] = true;
	level.player.parachute_dynamics["goal_velocity"] = Length( level.player.parachute_dynamics["velocity"] );
	
	level.player notify( "end_parachute_crash_watcher" );
	
	anim_start_org = GetStartOrigin( self.origin, self.angles, level.scr_anim[ level.player.parachute_canopy.animname ][ "landing" ] );
	level.player.parachute_dynamics["goal_pos"] = anim_start_org;

	level.player waittill( "goal" );
}

stop_parachute_sim_for_landing()
{
	self notify( "end_parachute" );
	self notify( "end_parachute_sim" );
	self notify( "end_parachute_crash_watcher" );
	
	level.price maps\castle_parachute_sim::end_ai_parachute_sim();
	
	maps\castle_parachute_sim::end_thermal_vents();
}

do_landing_scene()
{
	if ( IsDefined( level.fake_price ) )
	{
		self.parachute_canopy = level.fake_price.parachute_canopy;
		level.fake_price Delete();
	}
	
	self set_ignoreall( true );
	
	place_weapon_on( self.primaryweapon, "none" );
	
	level.player thread do_landing_scene_player();

	self.parachute_canopy.animname = "price_parachute";
	
	//play Price landing FX
	PlayFXOnTag( getfx( "price_smokewall_push" ), self, "tag_origin" );
		
	align_ai = get_new_anim_node( "landing" );
	align_ai anim_single( make_array( self, self.parachute_canopy ), "landing" );
	
	self.parachute_canopy Delete();
	
	self place_weapon_on( level.price.primaryweapon, "right" );
	
	self thread price_kill_guard_2();
}

price_kill_guard_2()
{
	flag_wait( "player_landed" );

	wait(1.5);
	
	if ( IsAlive( level.ai_guard2 ) )
	{
		level.ai_guard2 set_ignoreall( false );
		level.ai_guard2.health = 1;
		
		MagicBullet( self.weapon, self GetTagOrigin( "tag_flash"), level.ai_guard2 GetTagOrigin( "TAG_EYE" ) );
		wait 0.3;
		if( IsAlive( level.ai_guard2 ) )
		{
			level.ai_guard2 Kill();
		}
	}

	self set_ignoreall( false );

	level.price thread dialogue_queue("castle_pri_keepup");

// uncomment this to auto-turn fake nvgs off	
//	wait 3;
//	level.player notify("fake_nvg");
	wait 2;
	
	level.player thread display_hint_timeout( "disable_nvg", 7);
	
}

price_landing_gun( ai_price )
{
	ai_price place_weapon_on( ai_price.sidearm, "right" );	
}

LANDING_LERP_TIME = 0.5;
do_landing_scene_player()
{
	flag_set( "player_landing" );
	
	//wait 0.9;
	
	align = get_new_anim_node( "landing", true );
	
	//v_landing_org = align.origin;
	//v_landing_ang = align.angles;
	
	stop_parachute_sim_for_landing();
	
	self stop_player_fx();
	
	/* Player anim at player's position and lerp to original align origin durring animation */
	
	//align adjust_for_landing();
	
	self.m_player_rig Unlink();  // unlink from parachute
	
	//Earthquake( 0.3, .5, self.origin, 500 );
	self PlayRumbleOnEntity( "damage_heavy" );
	
	//self.m_player_rig LinkTo( align );
	//self.parachute_canopy LinkTo( align );
	
	//align MoveTo( v_landing_org, 3, 0, 1 );
	//align RotateTo( v_landing_ang, 3, 0, 1 );
	
	self.rig = spawn_anim_model( "player_rig" );
	self PlayerLinkToAbsolute(self.rig,"tag_player");
	
	align thread anim_single_solo(self.rig,"landing");
	align thread anim_single_solo(self.parachute_canopy,"landing");
		
	ai_guard1 = spawn_targetname( "landing_guard1", true );
	ai_guard1.animname = "landing_guard1";
	ai_guard1 thread anim_first_frame_solo(ai_guard1,"landing");
	 
	level.ai_guard2 = spawn_targetname( "landing_guard2", true );
	level.ai_guard2.ignoreall = true;
	level.ai_guard2 thread maps\_patrol::patrol( self.target );
	level.ai_guard2.animname = "landing_guard2";
//	align thread anim_first_frame_solo(level.ai_guard2,"landing");

	wait(0.5);
	//self PlayerLinkToDelta(self.rig,"tag_player",1.0,10,10,10,10);
		
	self.rig waittillmatch("single anim","start_guard_1");
	ai_guard1 thread anim_single_solo(ai_guard1,"landing");
	ai_guard1 set_ignoreall( true );
	ai_guard1.allowdeath = true;
	
    self.rig waittillmatch("single anim","guard_death");
    thread ai_guard2_react_new();

	wait(2);
	ai_guard1 animscripts\shared::DropAllAIWeapons();
	level.ai_guard2 animscripts\shared::DropAllAIWeapons();
	
//	self.rig waittillmatch("single anim","start_guard_2");
//	align thread anim_single_solo(level.ai_guard2,"landing");
	// react to shot guy and run away
	
	self.rig waittillmatch("single anim","end");
	ai_guard1 StartRagdoll();
	ai_guard1 Die();
	level.ai_guard2 SetGoalPos(level.ai_guard2.origin);
	self.parachute_canopy Delete();
	self Unlink();
	self.rig Delete();
	
	parachute_player = GetEnt( "parachute_ground_ruins", "targetname" );
	parachute_player Show();
	
	self AllowCrouch( true );
	self AllowProne( true );
	self EnableWeapons();
	self ShowViewModel();
	
	self SetStance( "crouch" );
	
	self FreezeControls( false );
	SetSavedDvar( "cg_drawCrosshair", 1 );
	
	thread handle_fake_nvg();
	
	self thread landing_angle_watch();
	
	flag_set( "player_landed" );
}

ai_guard2_react()
{
	landing_guard_flee_dest = GetNode("landing_guard_flee_dest", "targetname");
	level.ai_guard2 anim_single_solo_run(level.ai_guard2, "react_to_parachute");
	level.ai_guard2 notify("end_patrol");
	level.ai_guard2 enable_sprint();
	level.ai_guard2 set_goal_radius(50);
	level.ai_guard2 SetGoalNode(landing_guard_flee_dest);
	level.ai_guard2.allowdeath = true;
}

ai_guard2_react_new()
{
    level.ai_guard2 notify("end_patrol");
    
    level.ai_guard2 gun_remove();
    level.ai_guard2.health = 1;
    level.ai_guard2.ignoreExplosionEvents = true;
    level.ai_guard2.ignoreme = true;
    level.ai_guard2.ignoreall = true;
    level.ai_guard2.IgnoreRandomBulletDamage = true;
    level.ai_guard2.grenadeawareness = 0;
    level.ai_guard2.no_pain_sound = true;
    level.ai_guard2.noragdoll = 1;
    level.ai_guard2.a.nodeath = true;
    
    level.ai_guard2 force_crawling_death( 165 , 4 , level.scr_anim[ "crawl_death_2" ] );  //the 165 is the angle you want him to crawl in, so when you move his starting position and his goal position, you will probably have to change this angle to make him crawl towards where the player is going.
    level.ai_guard2 DoDamage( 1 , level.ai_guard2.origin + ( 16, 0, 16 ) );
}


landing_angle_watch()
{
	level endon( "player_landed" );
	
	angles = self GetPlayerAngles();
	
	while( 1 )
	{
		new_angles = self GetPlayerAngles();
		if( VectorDot( angles, new_angles ) < 0.8 )
		{
			flag_set( "player_landed" );
			return;
		}
		waitframe();
	}
}

landing_hit_ground( player_rig )
{
	//trigger player landing FX
	exploder( 302 );
	exploder ( 5800 );
	
	
	level.player PlayRumbleOnEntity( "damage_heavy" );
	wait .05;
	level.player PlayRumbleOnEntity( "damage_heavy" );
	wait .05;
	level.player PlayRumbleOnEntity( "damage_heavy" );
	wait .05;
	level.player PlayRumbleOnEntity( "damage_heavy" );
	
	wait 1;
	
	level.player PlayRumbleOnEntity( "damage_heavy" );
}

price_landing_shoot( price )
{
	level.player PlayRumbleOnEntity( "damage_light" );
	wait .5;
	level.player PlayRumbleOnEntity( "damage_light" );	
}

adjust_for_landing()
{
	/*
 	* Adjust the align node for the landing animation so that the animation plays at the player's position.
	* This removes potitional popping/lerping when the animation starts.
	*/
	
	v_start_origin = GetStartOrigin( self.origin, self.angles, level.player.m_player_rig getanim( "landing" ) );
	v_start_angles = GetStartAngles( self.origin, self.angles, level.player.m_player_rig getanim( "landing" ) );
	
	v_start_offset = self.origin - v_start_origin;
	v_start_offset_length = Length( v_start_offset );
	
	v_angle_diff = (
		AngleClamp180( level.player.m_player_rig.angles[0] - v_start_angles[0] ),
		AngleClamp180( level.player.m_player_rig.angles[1] - v_start_angles[1] ),
		AngleClamp180( level.player.m_player_rig.angles[2] - v_start_angles[2] )
	);
	
	v_start_offset_ang = VectorToAngles( v_start_offset );
	v_rotated_offset = AnglesToForward( v_start_offset_ang + v_angle_diff );
	
	self.origin = level.player.m_player_rig.origin + v_rotated_offset * v_start_offset_length;
	self.angles = self.angles + v_angle_diff;
}

handle_fake_nvg()
{
	self SetActionSlot( 1, "" ); // temporarilly disable "real" nightvision
	
	level.player NotifyOnPlayerCommand("fake_nvg", "+actionslot 1");  // intercept any nightvision commands
	
	level.player waittill("fake_nvg");
	aud_send_msg("turn_off_fake_nvg");
	level.player.nightVision_Started = undefined;
    current_weapon = level.player GetCurrentWeapon();
    level.player ForceViewmodelAnimation( current_weapon , "nvg_up" );
    wait 0.5;
    level.player NightvisionGogglesForceOff();
	self SetActionSlot( 1, "nightvision" ); // player can now use "real" night vision
}
	