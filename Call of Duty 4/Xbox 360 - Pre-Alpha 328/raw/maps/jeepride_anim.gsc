#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle_aianim;

#using_animtree( "generic_human" );
main_anim()
{
	
	level.scr_sound[ "price" ][ "stand_down" ]				 = "armada_pri_allteamsstanddown";
	level.scr_sound[ "price" ][ "roger_hq" ]				 = "armada_pri_rogerhq";
	level.scr_sound[ "price" ][ "heads_up" ]				 = "armada_pri_headsup";
	// level.price anim_single_queue( level.price
	
	level.scr_sound[ "generic" ][ "tvstation" ]				 = "armada_gm1_tvstation";
	level.scr_sound[ "generic" ][ "breaching_breaching" ] = "armada_gm1_breachingbreaching";// Breaching breaching!

	level.scr_sound[ "price" ][ "jeepride_pri_helistatus" ] = 			"jeepride_pri_helistatus"     	;
	level.scr_sound[ "price" ][ "jeepride_pri_notgood" ] =          "jeepride_pri_notgood"          ;
	level.scr_sound[ "price" ][ "jeepride_pri_lockandload" ] =      "jeepride_pri_lockandload"      ;
	level.scr_sound[ "price" ][ "jeepride_pri_bmprear" ] =          "jeepride_pri_bmprear"          ;
	level.scr_sound[ "price" ][ "jeepride_pri_bmpright" ] =         "jeepride_pri_bmpright"         ;
	level.scr_sound[ "price" ][ "jeepride_pri_bmpleft" ] =          "jeepride_pri_bmpleft"          ;
	level.scr_sound[ "price" ][ "jeepride_pri_bmpfront" ] =         "jeepride_pri_bmpfront"         ;
	level.scr_sound[ "price" ][ "jeepride_pri_hind6oclock" ] =      "jeepride_pri_hind6oclock"      ;
	level.scr_sound[ "price" ][ "jeepride_pri_hind9oclock" ] =      "jeepride_pri_hind9oclock"      ;
	level.scr_sound[ "price" ][ "jeepride_pri_hind3oclock" ] =      "jeepride_pri_hind3oclock"      ;
	level.scr_sound[ "price" ][ "jeepride_pri_hinddeadahead" ] =    "jeepride_pri_hinddeadahead"    ;
	level.scr_sound[ "price" ][ "jeepride_pri_grabrpg" ] =          "jeepride_pri_grabrpg"          ;
	level.scr_sound[ "price" ][ "jeepride_pri_letsgetfire" ] =      "jeepride_pri_letsgetfire"      ;
	level.scr_sound[ "price" ][ "jeepride_pri_openfire" ] =         "jeepride_pri_openfire"         ;
	level.scr_sound[ "price" ][ "jeepride_pri_takehimout" ] =       "jeepride_pri_takehimout"       ;
	level.scr_sound[ "price" ][ "jeepride_pri_firefire" ] =         "jeepride_pri_firefire"         ;
	level.scr_sound[ "price" ][ "jeepride_pri_takehimdown" ] =      "jeepride_pri_takehimdown"      ;
	level.scr_sound[ "price" ][ "jeepride_pri_company" ] =          "jeepride_pri_company"          ;
	level.scr_sound[ "price" ][ "jeepride_pri_truckleft" ] =        "jeepride_pri_truckleft"        ;
	level.scr_sound[ "price" ][ "jeepride_pri_truckright" ] =       "jeepride_pri_truckright"       ;
	level.scr_sound[ "price" ][ "jeepride_pri_truck12oclock" ] =    "jeepride_pri_truck12oclock"    ;
	level.scr_sound[ "price" ][ "jeepride_pri_getoffyour" ] =       "jeepride_pri_getoffyour"       ;
	level.scr_sound[ "price" ][ "jeepride_pri_fireontruck" ] =      "jeepride_pri_fireontruck"      ;
	level.scr_sound[ "price" ][ "jeepride_pri_takeouttruck" ] =     "jeepride_pri_takeouttruck"     ;
	level.scr_sound[ "price" ][ "jeepride_pri_shootthattruck" ] =   "jeepride_pri_shootthattruck"   ;
	level.scr_sound[ "price" ][ "jeepride_pri_goodshot" ] =         "jeepride_pri_goodshot"         ;
	level.scr_sound[ "price" ][ "jeepride_pri_wegothim" ] =         "jeepride_pri_wegothim"         ;
	level.scr_sound[ "price" ][ "jeepride_pri_damaged" ] =          "jeepride_pri_damaged"          ;
	level.scr_sound[ "price" ][ "jeepride_pri_takinghits" ] =       "jeepride_pri_takinghits"       ;
	level.scr_sound[ "price" ][ "jeepride_pri_watchyour6" ] =       "jeepride_pri_watchyour6"       ;
	level.scr_sound[ "price" ][ "jeepride_pri_coverfront" ] =       "jeepride_pri_coverfront"       ;
	level.scr_sound[ "price" ][ "jeepride_pri_coverflanks" ] =      "jeepride_pri_coverflanks"      ;
	level.scr_sound[ "price" ][ "jeepride_pri_coverrear" ] =        "jeepride_pri_coverrear"        ;
	
	level.scr_sound[ "friendguy" ][ "jeepride_gaz_boxingin" ] = 			"jeepride_gaz_boxingin";
	level.scr_sound[ "friendguy" ][ "jeepride_gaz_takecareofit" ] = "jeepride_gaz_takecareofit";
	
	level.scr_sound[ "hq" ][ "jeepride_hqr_griggsisnthere" ] = "jeepride_hqr_griggsisnthere";
	
	level.scr_sound[ "griggs" ][ "jeepride_grg_hangon" ] = "jeepride_grg_hangon";
	level.scr_sound[ "griggs" ][ "jeepride_grg_bmpbehind" ] = "jeepride_grg_bmpbehind";
	level.scr_sound[ "griggs" ][ "jeepride_grg_bmpright" ] =              "jeepride_grg_bmpright"       ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_bmpleft" ] =               "jeepride_grg_bmpleft"        ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_bmp12oclock" ] =           "jeepride_grg_bmp12oclock"    ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_hindbehind" ] =            "jeepride_grg_hindbehind"     ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_hind9oclock" ] =           "jeepride_grg_hind9oclock"    ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_hind3oclock" ] =           "jeepride_grg_hind3oclock"    ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_hind12oclock" ] =          "jeepride_grg_hind12oclock"   ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_rpgfirehind" ] =           "jeepride_grg_rpgfirehind"    ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_hithelicopter" ] =         "jeepride_grg_hithelicopter"  ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_rpgontruck" ] =            "jeepride_grg_rpgontruck"     ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_takemout" ] =              "jeepride_grg_takemout"       ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_anotherrpg" ] =            "jeepride_grg_anotherrpg"     ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_hostilerpg" ] =            "jeepride_grg_hostilerpg"     ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_truck6oclock" ] =          "jeepride_grg_truck6oclock"   ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_truck3oclock" ] =          "jeepride_grg_truck3oclock"   ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_truck9oclock" ] =          "jeepride_grg_truck9oclock"   ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_truckdeadahead" ] =        "jeepride_grg_truckdeadahead" ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_killfirm" ] =              "jeepride_grg_killfirm"       ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_niceshootin" ] =              "jeepride_grg_niceshootin"       ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_success" ] =              "jeepride_grg_success"       ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_thatsahit" ] =              "jeepride_grg_thatsahit"       ;
	level.scr_sound[ "griggs" ][ "jeepride_grg_devastation" ] =              "jeepride_grg_devastation"       ;
	
	
	level.scr_anim[ "price" ][ "jeepride_ending_price01" ]				 = %jeepride_ending_price;
	level.scr_anim[ "price" ][ "jeepride_ending_price02" ]				 = %jeepride_ending_price;
	level.scr_anim[ "price" ][ "wave_player_over" ]				 = %bog_a_start_briefing;
	
	level.scr_animtree[ "price" ] 							 = #animtree;
	
	level.scr_anim[ "griggs" ][ "drag_player" ]				 = %jeepride_drag_grigsby;
	level.scr_anim[ "price" ][ "drag_player" ]				 = %jeepride_ending_price;
	level.scr_animtree[ "griggs" ] 							 = #animtree;


	addNotetrack_customFunction( "griggs", "drop_pistol", ::drop_pistol );
	addNotetrack_customFunction( "griggs", "scripted_weaponswitch", ::scripted_weaponswitch );
	
	
	level.scr_anim[ "zakhaev" ][ "end_scene_01" ]				 = %jeepride_zak_approach;
	level.scr_anim[ "zakhaev_buddy1" ][ "end_scene_01" ]				 = %jeepride_lguy_approach;
	level.scr_anim[ "zakhaev_buddy2" ][ "end_scene_01" ]				 = %jeepride_rguy_approach;
	level.scr_anim[ "end_friend_1" ][ "end_scene_01" ]				 = %jeepride_dying_approach;
	

	level.scr_anim[ "zakhaev" ][ "end_scene_02" ]				 = %jeepride_zak_end;
	level.scr_anim[ "zakhaev_buddy1" ][ "end_scene_02" ]				 = %jeepride_Lguy_end;
	level.scr_anim[ "zakhaev_buddy2" ][ "end_scene_02" ]				 = %jeepride_Rguy_end;
	

	vehicle_anims();
	player_anims();
}

scripted_weaponswitch( guy )
{
	guy attach("weapon_saw","tag_weapon_right");
	guy.scriptedweapon = "saw";
}

drop_pistol( guy )
{
	tag = "tag_weapon_right";
	orgbefore = guy gettagorigin( tag );
	wait(.2);
	guy detach( "weapon_colt1911_white","tag_weapon_right" );
	pistol = spawn( "script_model", guy gettagorigin( tag ) );
	pistol setmodel( "weapon_colt1911_white" );
	pistol.angles = guy gettagorigin( tag );
	pistol PhysicsLaunch( pistol.origin + ( 0, 0, 0 ), vector_multiply( pistol.origin - orgbefore, 25 ) );
}

#using_animtree( "player" );
player_anims()
{
	level.scr_anim[ "playerview" ][ "drag_player" ]				 = %jeepride_drag_player;
	level.scr_model[ "playerview" ]  = "viewhands_player_usmc";
	level.scr_animtree[ "playerview" ] = #animtree;

}

#using_animtree( "vehicles" );
vehicle_anims()
{
	level.scr_anim[ "mi28" ]["end_scene_01"] = %jeepride_mi28_flyby;
	level.scr_animtree[ "mi28" ] = #animtree;
	
	level.jeepride_crash_model = [];
	level.jeepride_crash_anim[ "Jeepride_crash_tunnel_pickup" ] = %jeepride_crash_tunnel_pickup;

	level.jeepride_crash_anim[ "Jeepride_crash_tunnel_pickup2" ] = %jeepride_flip_pickup; // truck flies up on to it's front side smashes into pillar
	level.jeepride_crash_model[ "Jeepride_crash_tunnel_pickup2" ] = "vehicle_pickup_tankcrush";   
	level.jeepride_crash_animtree[ "Jeepride_crash_tunnel_pickup2" ] = #animtree;

// 	level.jeepride_crash_anim[ "Jeepride_crash_tunnel_pickup3" ] = %jeepride_crash_tunnel_pickup;	// truck gets hit from behind with a missile and is propelled towards the player

	precache_crash_models();
}

precache_crash_models()
{
	if ( ! isdefined( level.jeepride_crash_model ) )
		return;
	keys = getarraykeys( level.jeepride_crash_model );
	for ( i = 0; i < keys.size; i++ )
		precachemodel( 	level.jeepride_crash_model[ keys[ i ] ] );
}

#using_animtree( "generic_human" );   
uaz_overrides()
{
	positions = 	maps\_uaz::setanims();
	
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 
	positions[ 2 ].sittag = "tag_guy0";// RR
	positions[ 3 ].sittag = "tag_guy1"; // RR
	positions[ 4 ].sittag = "tag_guy2";// RR
	positions[ 5 ].sittag = "tag_guy3"; // RR

	positions[ 0 ].idle = %UAZ_driver_idle;
	positions[ 1 ].idle = %UAZ_Rguy_idle;
	
	positions[ 2 ].idle[0] = %UAZ_Lguy_idle_hide;
	positions[ 2 ].idle[1] = %UAZ_Lguy_idle_react;
	positions[ 2 ].idleoccurrence[0] = 1000;
	positions[ 2 ].idleoccurrence[1] = 100;

	positions[ 3 ].idle = %UAZ_Rguy_idle;
	positions[ 4 ].idle = undefined;
	positions[ 5 ].idle = undefined;
	
	positions[ 2 ].hidetoback = %UAZ_Lguy_trans_hide2back;
	positions[ 2 ].back_attack = %UAZ_Lguy_fire_back;
	positions[ 2 ].backtohide = %UAZ_Lguy_trans_back2hide;

	positions[ 2 ].hide_attack_forward = %UAZ_Lguy_fire_hide_forward;

	positions[ 2 ].hide_attack_left[0] = %UAZ_Lguy_fire_side_v1;
	positions[ 2 ].hide_attack_left[1] = %UAZ_Lguy_fire_side_v2;
	positions[ 2 ].hide_attack_left_occurrence[0] = 500;
	positions[ 2 ].hide_attack_left_occurrence[1] = 500;

	positions[ 2 ].hide_attack_left_standing[0] = %UAZ_Lguy_standfire_side_v3;
	positions[ 2 ].hide_attack_left_standing[1] = %UAZ_Lguy_standfire_side_v4;
	positions[ 2 ].hide_attack_left_standing_occurrence[0] = 100;
	positions[ 2 ].hide_attack_left_standing_occurrence[1] = 100;
	
	positions[ 2 ].hide_attack_back[0] = %UAZ_Lguy_fire_hide_back_v1;
	positions[ 2 ].hide_attack_back[1] = %UAZ_Lguy_fire_hide_back_v2;
	positions[ 2 ].hide_attack_back_occurrence[0] = 500;
	positions[ 2 ].hide_attack_back_occurrence[1] = 500;
	
	positions[ 1 ].hide_attack_back[0] = %UAZ_Rguy_fire_back_v2;
	positions[ 1 ].hide_attack_back[1] = %UAZ_Rguy_fire_back_v1;
	positions[ 1 ].hide_attack_back_occurrence[0] = 500;
	positions[ 1 ].hide_attack_back_occurrence[1] = 500;
	
	positions[ 1 ].hide_attack_left[0] = %UAZ_Lguy_fire_side_v1;
	positions[ 1 ].hide_attack_left[1] = %UAZ_Lguy_fire_side_v2;
	positions[ 1 ].hide_attack_left_occurrence[0] = 500;
	positions[ 1 ].hide_attack_left_occurrence[1] = 500;

	
	positions[ 0 ].duck_once = %UAZ_driver_duck;
	positions[ 0 ].turn_right = %UAZ_driver_turnright;
	positions[ 0 ].turn_left = %UAZ_driver_turnleft;
	positions[ 0 ].weave = %UAZ_driver_weave;
	
	positions[ 0 ].getout = %pickup_driver_climb_out;
	positions[ 1 ].getout = %pickup_passenger_climb_out;
	positions[ 2 ].getout = %pickup_driver_climb_out;
	positions[ 3 ].getout = %pickup_passenger_climb_out;
	
//UAZ_Rguy_fire_back_RPG
//UAZ_Rguy_fire_back_v1
//UAZ_Rguy_fire_back_v2
//UAZ_Rguy_idle
//UAZ_Rguy_scan_side_v1	
	
// UAZ_Lguy_idle_hide

// UAZ_Lguy_fire_hide_back_v1
// UAZ_Lguy_fire_hide_back_v2
// UAZ_Lguy_fire_side_v1
// UAZ_Lguy_fire_side_v2
// UAZ_Lguy_standfire_side_v3
// UAZ_Lguy_standfire_side_v4

// UAZ_Lguy_trans_back2hide
// UAZ_Lguy_trans_hide2back
	

	
// UAZ_driver_death
// UAZ_driver_duck
// UAZ_driver_idle
// UAZ_driver_turnleft
// UAZ_driver_turnright
// UAZ_driver_weave

// UAZ_steeringwheel_death
// UAZ_steeringwheel_duck
// UAZ_steeringwheel_idle
// UAZ_steeringwheel_turnleft
// UAZ_steeringwheel_turnright
// UAZ_steeringwheel_weave

	return positions;	
}

#using_animtree( "vehicles" );  
uaz_override_vehicle( positions )
{
	
		positions[ 0 ].vehicle_idle = %UAZ_steeringwheel_idle; 
		positions[ 0 ].vehicle_duck_once = %UAZ_steeringwheel_duck; 
		positions[ 0 ].vehicle_turn_left = %UAZ_steeringwheel_turnleft;
		positions[ 0 ].vehicle_turn_right = %UAZ_steeringwheel_turnright;
		positions[ 0 ].vehicle_weave = %UAZ_steeringwheel_weave;
		
		positions[ 0 ].vehicle_getoutanim = %door_pickup_driver_climb_out;
		positions[ 1 ].vehicle_getoutanim = %door_pickup_passenger_climb_out;
		positions[ 2 ].vehicle_getoutanim = %door_pickup_passenger_RR_climb_out;
		positions[ 3 ].vehicle_getoutanim = %door_pickup_passenger_RL_climb_out;
	
		positions[ 0 ].vehicle_getinanim = %door_pickup_driver_climb_in;
		positions[ 1 ].vehicle_getinanim = %door_pickup_passenger_climb_in;
		return positions;
}