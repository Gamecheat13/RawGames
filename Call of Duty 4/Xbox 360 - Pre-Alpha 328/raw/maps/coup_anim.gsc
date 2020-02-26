#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

main()
{
	anim_generic_human();
	anim_player();
	anim_car();
	anim_door();
	anim_trashcan_rig();
	anim_props();
	anim_drones();
	anim_chickens();
	anim_dogs();
}

#using_animtree( "player" );
anim_player()
{
	level.scr_animtree[ "playerview" ] 							 = #animtree;
	level.scr_model[ "playerview" ] 							 = "viewhands_player_usmc";
	level.scr_anim[ "playerview" ][ "intro" ]					 = %coup_opening_playerview;
	level.scr_anim[ "playerview" ][ "car_idle" ][ 0 ]			 = %coup_opening_playerview_idle;
	level.scr_anim[ "playerview" ][ "car_idle_firstframe" ]		 = %coup_opening_playerview_idle;
	level.scr_anim[ "playerview" ][ "carexit" ]				 	 = %coup_ending_drag_playerview;
	level.scr_anim[ "playerview" ][ "ending" ]			 		 = %coup_ending_player;

	level.scr_anim[ "playerview" ][ "playerview_idle_normal" ]	 = %coup_opening_playerview_idle_normal;
	level.scr_anim[ "playerview" ][ "playerview_idle_smooth" ]	 = %coup_opening_playerview_idle_smooth;
	level.scr_anim[ "playerview" ][ "playerview_idle_bumpy" ]	 = %coup_opening_playerview_idle_bumpy;
	level.scr_anim[ "playerview" ][ "playerview_idle_static" ]	 = %coup_opening_playerview_idle_static;
	
	// addNotetrack_customFunction( animname, notetrack, function, anime )
	addNotetrack_customFunction( "playerview", "hit", ::playerHit, "intro" );
}

#using_animtree( "generic_human" );
anim_generic_human()
{
	// merge into this animname when possible
	level.scr_animtree[ "ai_human" ]						 	 		 = #animtree;
	level.scr_anim[ "ai_human" ][ "run_panicked1" ] 					 = %unarmed_panickedrun_loop_V1;
	level.scr_anim[ "ai_human" ][ "run_panicked2" ] 					 = %unarmed_panickedrun_loop_V2;
	level.scr_anim[ "ai_human" ][ "runinto_garage_left" ]	  			 = %unarmed_runinto_garage_left;
	level.scr_anim[ "ai_human" ][ "runinto_garage_right" ]	 			 = %unarmed_runinto_garage_right;
	level.scr_anim[ "ai_human" ][ "spraypainting" ]						 = %coup_spraypainting_sequence;
	level.scr_anim[ "ai_human" ][ "trash_stumble" ]						 = %unarmed_stumble_trashcan;
	level.scr_anim[ "ai_human" ][ "wall_climb" ]						 = %unarmed_climb_wall_v2;
	level.scr_anim[ "ai_human" ][ "sneakattack_attack_side" ]			 = %melee_L_attack;
	level.scr_anim[ "ai_human" ][ "sneakattack_defend_side" ]			 = %melee_L_defend;
	level.scr_anim[ "ai_human" ][ "sneakattack_attack_behind" ]			 = %melee_B_attack;
	level.scr_anim[ "ai_human" ][ "sneakattack_defend_behind" ]			 = %melee_B_defend;
	level.scr_anim[ "ai_human" ][ "patrol_walk" ]						 = %patrol_bored_patrolwalk;
	level.scr_anim[ "ai_human" ][ "aim_straight" ][ 0 ]					 = %stand_aim_straight;
	level.scr_anim[ "ai_human" ][ "cowerstand_idle" ][ 0 ]				 = %unarmed_cowerstand_idle;
	level.scr_anim[ "ai_human" ][ "cowerstand_pointidle" ][ 0 ] 		 = %unarmed_cowerstand_pointidle;
	level.scr_anim[ "ai_human" ][ "cowerstand_point_to_idle" ]			 = %unarmed_cowerstand_point2idle;
	level.scr_anim[ "ai_human" ][ "cowerstand_idle_to_point" ]			 = %unarmed_cowerstand_idle2point;
	level.scr_anim[ "ai_human" ][ "cowerstand_react" ]	 				 = %unarmed_cowerstand_react;
	level.scr_anim[ "ai_human" ][ "cowerstand_react_to_crouch" ]		 = %unarmed_cowerstand_react_2_crouch;
	level.scr_anim[ "ai_human" ][ "cowercrouch_idle" ][ 0 ]				 = %unarmed_cowercrouch_idle;
	level.scr_anim[ "ai_human" ][ "cowercrouch_idle_duck" ] 			 = %unarmed_cowercrouch_idle_duck;
	level.scr_anim[ "ai_human" ][ "cowercrouch_react_a" ] 				 = %unarmed_cowercrouch_react_A;
	level.scr_anim[ "ai_human" ][ "cowercrouch_react_b" ] 				 = %unarmed_cowercrouch_react_B;
	level.scr_anim[ "ai_human" ][ "cowercrouch_to_stand" ]				 = %unarmed_cowercrouch_crouch_2_stand;

	level.scr_animtree[ "ending_leftguard" ] 				 			 = #animtree;
	level.scr_anim[ "ending_leftguard" ][ "ending_escort" ]				 = %coup_ending_guyL;
	
	level.scr_animtree[ "ending_rightguard" ] 				 			 = #animtree;
	level.scr_anim[ "ending_rightguard" ][ "ending_escort" ] 			 = %coup_ending_guyR;

	level.scr_animtree[ "ending_alasad" ] 					 			 = #animtree;
	level.scr_anim[ "ending_alasad" ][ "ending_execution" ]	 			 = %coup_ending_alasad;

	level.scr_animtree[ "ending_zakhaev" ] 					 			 = #animtree;
	level.scr_anim[ "ending_zakhaev" ][ "ending_execution" ] 			 = %coup_ending_zakhaev;

	level.scr_animtree[ "doorkick_leftguard" ] 				 			 = #animtree;
	level.scr_anim[ "doorkick_leftguard" ][ "idle_before_step_out" ]	 = %shotgunbreach_v1_shoot_hinge_idle;
	level.scr_anim[ "doorkick_leftguard" ][ "step_out" ]				 = %shotgunbreach_v1_shoot_hinge;
	level.scr_anim[ "doorkick_leftguard" ][ "run_in" ]					 = %shotgunbreach_v1_shoot_hinge_runin;

	level.scr_animtree[ "doorkick_rightguard" ] 			 			 = #animtree;
	level.scr_anim[ "doorkick_rightguard" ][ "idle_before_step_out" ]	 = %shotgunbreach_v1_stackB_idle;
	level.scr_anim[ "doorkick_rightguard" ][ "step_out_and_run_in" ]	 = %shotgunbreach_v1_stackB;

	level.scr_animtree[ "ziptie_guard" ]		 			 			 = #animtree;
	level.scr_anim[ "ziptie_guard" ][ "ziptie_tie" ]					 = %ziptie_soldier;

	level.scr_animtree[ "ziptie_civilian" ]		 			 			 = #animtree;
	level.scr_anim[ "ziptie_civilian" ][ "ziptie_tie" ]					 = %ziptie_suspect;
	level.scr_anim[ "ziptie_civilian" ][ "ziptie_tie_idle" ][ 0 ]		 = %ziptie_suspect_idle;


	// addNotetrack_attach / detach( animname, notetrack, model, tag, anime )
	addNotetrack_detach( "ending_zakhaev", "detach gun", "weapon_desert_eagle_silver_HR_promo", "tag_inhand", "ending_execution" );
	addNotetrack_attach( "ending_alasad", "attach gun", "weapon_desert_eagle_silver_HR_promo", "tag_inhand", "ending_execution" );
	
	// addNotetrack_customFunction( animname, notetrack, function, anime )
	addNotetrack_customFunction( "ending_alasad", "fire_gun", ::playerDeath, "ending_execution" );

	// sneak attack rag doll deaths
	addNotetrack_customFunction( "ai_human", "melee", ::melee_kill, "sneakattack_attack_side" );
	addNotetrack_customFunction( "ai_human", "no death", ::rag_doll_death, "sneakattack_defend_side" );
	addNotetrack_customFunction( "ai_human", "end", ::kill_self, "sneakattack_defend_side" );

	addNotetrack_customFunction( "ai_human", "melee", ::melee_kill, "sneakattack_attack_behind" );
	addNotetrack_customFunction( "ai_human", "no death", ::rag_doll_death, "sneakattack_defend_behind" );
	addNotetrack_customFunction( "ai_human", "end", ::kill_self, "sneakattack_defend_behind" );
}

#using_animtree( "vehicles" );
anim_car()
{
	level.scr_animtree[ "car" ] 							 = #animtree;
	level.scr_model[ "car" ] 								 = "vehicle_luxurysedan_viewmodel";

	level.scr_anim[ "car" ][ "intro" ]						 = %coup_opening_car;
	level.scr_anim[ "car" ][ "coup_car_driving" ]			 = %coup_opening_car_driving;
	level.scr_anim[ "car" ][ "car_idle_normal" ]			 = %coup_opening_car_driving_idle_normal;
	level.scr_anim[ "car" ][ "car_idle_smooth" ]			 = %coup_opening_car_driving_idle_smooth;
	level.scr_anim[ "car" ][ "car_idle_bumpy" ]				 = %coup_opening_car_driving_idle_bumpy;
	level.scr_anim[ "car" ][ "car_idle_static" ]			 = %coup_opening_car_driving_idle_static;
	level.scr_anim[ "car" ][ "carexit" ]					 = %coup_ending_drag_cardoor;

	level.scr_anim[ "car" ][ "wheel_bigleft2center" ]		 = %coup_driver_bigleft2center_car;
	//level.scr_anim[ "car" ][ "wheel_bigleft_idle" ]			 = %coup_driver_bigleft_idle_car;
	level.scr_anim[ "car" ][ "wheel_bigleft_idle" ]		 	 = %coup_driver_bigleftloop_idle_car;
	level.scr_anim[ "car" ][ "wheel_bigleft_loop" ]			 = %coup_driver_bigleft_loop_car;
	level.scr_anim[ "car" ][ "wheel_bigleftloop2center" ]	 = %coup_driver_bigleftloop2center_car;
	level.scr_anim[ "car" ][ "wheel_center2smallleft" ]		 = %coup_driver_center2smallleft_car;
	level.scr_anim[ "car" ][ "wheel_center2smallright" ]	 = %coup_driver_center2smallright_car;
	level.scr_anim[ "car" ][ "wheel_idle" ]					 = %coup_driver_idle_car;
	level.scr_anim[ "car" ][ "wheel_smallleft2bigleft" ]	 = %coup_driver_smallleft2bigleft_car;
	level.scr_anim[ "car" ][ "wheel_smallleft2center" ]	 	 = %coup_driver_smallleft2center_car;
	level.scr_anim[ "car" ][ "wheel_smallleft_idle" ]		 = %coup_driver_smallleft_idle_car;
	level.scr_anim[ "car" ][ "wheel_smallright2center" ]	 = %coup_driver_smallright2center_car;
	level.scr_anim[ "car" ][ "wheel_smallright_idle" ]	 	 = %coup_driver_smallright_idle_car;

	// addNotetrack_customFunction( animname, notetrack, function, anime )
	addNotetrack_customFunction( "car", "idle_normal_start", ::car_normal, "coup_car_driving" );
	addNotetrack_customFunction( "car", "idle_smooth_start", ::car_smooth, "coup_car_driving" );
	addNotetrack_customFunction( "car", "idle_bumpy_start", ::car_bumpy, "coup_car_driving" );
	addNotetrack_customFunction( "car", "idle_static_start", ::car_static, "coup_car_driving" );
	
	// turn events
	addNotetrack_customFunction( "car", "turnright_1", ::car_turnright1, "coup_car_driving" );
	addNotetrack_customFunction( "car", "turnleft_1", ::car_turnleft1, "coup_car_driving" );
	addNotetrack_customFunction( "car", "turnleft_2", ::car_turnleft2, "coup_car_driving" );
	addNotetrack_customFunction( "car", "turnleft_3", ::car_turnleft3, "coup_car_driving" );
}

#using_animtree( "door" );
anim_door()
{
	level.scr_animtree[ "door" ]							 = #animtree;	
	level.scr_anim[ "door" ][ "run_in" ]					 = %shotgunbreach_door_immediate;
	level.scr_model[ "door" ]								 = "com_door_01_handleright";
}

#using_animtree( "trash_can" );
anim_trashcan_rig()
{
	level.scr_animtree[ "trashcan_rig" ]					 = #animtree;
	level.scr_model[ "trashcan_rig" ]						 = "prop_rig";
	level.scr_anim[ "trashcan_rig" ][ "trash_stumble" ]		 = %prop_stumble_trashcan;
}

#using_animtree( "animated_props" );
anim_props()
{
	level.anim_prop_models[ "foliage_tree_palm_bushy_2" ][ "still" ]	 = %palmtree_bushy2_still;
	level.anim_prop_models[ "foliage_tree_palm_bushy_2" ][ "strong" ]	 = %palmtree_bushy2_sway;
	level.anim_prop_models[ "foliage_tree_palm_bushy_1" ][ "still" ]	 = %palmtree_bushy1_still;
	level.anim_prop_models[ "foliage_tree_palm_bushy_1" ][ "strong" ]	 = %palmtree_bushy1_sway;
	level.anim_prop_models[ "foliage_tree_palm_bushy_3" ][ "still" ]	 = %palmtree_bushy3_still;
	level.anim_prop_models[ "foliage_tree_palm_bushy_3" ][ "strong" ]	 = %palmtree_bushy3_sway;
	level.anim_prop_models[ "foliage_tree_palm_med_2" ][ "still" ]		 = %palmtree_med2_still;
	level.anim_prop_models[ "foliage_tree_palm_med_2" ][ "strong" ]		 = %palmtree_med2_sway;
	level.anim_prop_models[ "foliage_tree_palm_med_1" ][ "still" ]		 = %palmtree_med1_still;
	level.anim_prop_models[ "foliage_tree_palm_med_1" ][ "strong" ]		 = %palmtree_med1_sway;
	level.anim_prop_models[ "foliage_tree_palm_tall_1" ][ "still" ]		 = %palmtree_tall1_still;
	level.anim_prop_models[ "foliage_tree_palm_tall_1" ][ "strong" ]	 = %palmtree_tall1_sway;
	level.anim_prop_models[ "foliage_tree_palm_tall_3" ][ "still" ]		 = %palmtree_tall3_still;
	level.anim_prop_models[ "foliage_tree_palm_tall_3" ][ "strong" ]	 = %palmtree_tall3_sway;
	level.anim_prop_models[ "foliage_tree_palm_tall_2" ][ "still" ]		 = %palmtree_tall2_still;
	level.anim_prop_models[ "foliage_tree_palm_tall_2" ][ "strong" ]	 = %palmtree_tall2_sway;
}

#using_animtree( "drones" );
anim_drones()
{
	level.scr_animtree[ "drone_human" ] 							 	 = #animtree;
	level.scr_anim[ "drone_human" ][ "cardriver_idle" ][ 0 ]		 	 = %coup_driver_idle;
	level.scr_anim[ "drone_human" ][ "cardriver_bigleft2center" ]	 	 = %coup_driver_bigleft2center;
	level.scr_anim[ "drone_human" ][ "cardriver_bigleft_idle" ]		 	 = %coup_driver_bigleft_idle;
	level.scr_anim[ "drone_human" ][ "cardriver_bigleft_loop" ] 		 = %coup_driver_bigleft_loop;
	level.scr_anim[ "drone_human" ][ "cardriver_center2smallleft" ]	 	 = %coup_driver_center2smallleft;
	level.scr_anim[ "drone_human" ][ "cardriver_center2smallright" ] 	 = %coup_driver_center2smallright;
	level.scr_anim[ "drone_human" ][ "cardriver_lookright" ]	 	 	 = %coup_driver_lookright;
	level.scr_anim[ "drone_human" ][ "cardriver_smallleft2bigleft" ] 	 = %coup_driver_smallleft2bigleft;
	level.scr_anim[ "drone_human" ][ "cardriver_smallleft2center" ]	 	 = %coup_driver_smallleft2center;
	level.scr_anim[ "drone_human" ][ "cardriver_smallleft_idle" ]		 = %coup_driver_smallleft_idle;
	level.scr_anim[ "drone_human" ][ "cardriver_smallright2center" ] 	 = %coup_driver_smallright2center;
	level.scr_anim[ "drone_human" ][ "cardriver_smallright_idle" ]		 = %coup_driver_smallright_idle;
	level.scr_anim[ "drone_human" ][ "cardriver_wave1" ]			 	 = %coup_driver_wave1;
	level.scr_anim[ "drone_human" ][ "cardriver_wave2" ]			 	 = %coup_driver_wave2;

	level.scr_anim[ "drone_human" ][ "carpassenger_idle" ][ 0 ]		 	 = %coup_passenger_idle;
	level.scr_anim[ "drone_human" ][ "carpassenger_phone" ]			 	 = %coup_passenger_phone;
	level.scr_anim[ "drone_human" ][ "carpassenger_point" ]			 	 = %coup_passenger_point;
	level.scr_anim[ "drone_human" ][ "carpassenger_lookback" ]		 	 = %coup_passenger_lookback;
	level.scr_anim[ "drone_human" ][ "carpassenger_lookright" ]		 	 = %coup_passenger_lookright;
	level.scr_anim[ "drone_human" ][ "carpassenger_shiftweight" ]	 	 = %coup_passenger_shiftweight;

	level.scr_anim[ "drone_human" ][ "intro_leftguard" ]			 	 = %coup_opening_guyL;
	level.scr_anim[ "drone_human" ][ "intro_rightguard" ]			 	 = %coup_opening_guyR;
	level.scr_anim[ "drone_human" ][ "carexit_leftguard" ]			 	 = %coup_ending_drag_guyL;
	level.scr_anim[ "drone_human" ][ "carexit_rightguard" ]			 	 = %coup_ending_drag_guyR;
	level.scr_anim[ "drone_human" ][ "close_garage_a" ]	 			 	 = %unarmed_close_garage;
	level.scr_anim[ "drone_human" ][ "close_garage_b" ]	 			 	 = %unarmed_close_garage_v2;
	level.scr_anim[ "drone_human" ][ "window_shout_a" ]	 			 	 = %unarmed_shout_window;
	level.scr_anim[ "drone_human" ][ "window_shout_b" ]				 	 = %unarmed_shout_window_v2;
	level.scr_anim[ "drone_human" ][ "leaning_smoking_idle" ][ 0 ]	 	 = %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "drone_human" ][ "radio" ]						 	 = %casual_stand_v2_twitch_radio;
	level.scr_anim[ "drone_human" ][ "talkingguards_leftguard" ]		 = %coup_talking_patrol_guy1;
	level.scr_anim[ "drone_human" ][ "talkingguards_rightguard" ]		 = %coup_talking_patrol_guy2;
	level.scr_anim[ "drone_human" ][ "ziptie_tie_idle" ][ 0 ]			 = %ziptie_suspect_idle;
	
	level.scr_animtree[ "drone_dog" ]								 	 = #animtree;
	level.scr_anim[ "drone_dog" ][ "idle" ]							 	 = %german_shepherd_idle;
	level.scr_anim[ "drone_dog" ][ "sleeping" ][ 0 ]		 		 	 = %german_shepherd_sleeping;
	level.scr_anim[ "drone_dog" ][ "eating" ][ 0 ]			 		 	 = %german_shepherd_eating_loop;
}

#using_animtree( "chicken" );
anim_chickens()
{
	level.scr_animtree[ "chicken" ] 						 = #animtree;
	level.scr_model[ "chicken" ] 							 = "chicken";
	level.scr_anim[ "chicken" ][ "walk_basic" ]				 = %chicken_walk_basic;
	level.scr_anim[ "chicken" ][ "cage_freakout" ]			 = %chicken_cage_freakout;
}

#using_animtree( "dog" );
anim_dogs()
{
	level.scr_animtree[ "dog" ] 							 = #animtree;
	level.scr_model[ "dog" ] 								 = "dog";
	level.scr_anim[ "dog" ][ "idle" ]						 = %german_shepherd_idle;
	level.scr_anim[ "dog" ][ "walk" ]						 = %german_shepherd_walk;
	level.scr_anim[ "dog" ][ "eating" ][ 0 ]				 = %german_shepherd_eating_loop;
	level.scr_anim[ "dog" ][ "sleep" ]						 = %german_shepherd_sleeping;
	level.scr_anim[ "dog" ][ "wakeup_slow" ]				 = %german_shepherd_wakeup_slow;
	level.scr_anim[ "dog" ][ "wakeup_fast" ]				 = %german_shepherd_wakeup_fast;
}

car_normal( car )
{
	car setanimknob( car getanim( "car_idle_normal" ), 1, 0, 1 );
	car.playerview setanimknob( car.playerview getanim( "playerview_idle_normal" ), 1, 0, 1 );
}

car_smooth( car )
{
	car setanimknob( car getanim( "car_idle_smooth" ), 1, 0, 1 );
	car.playerview setanimknob( car.playerview getanim( "playerview_idle_smooth" ), 1, 0, 1 );
}

car_bumpy( car )
{
	car setanimknob( car getanim( "car_idle_bumpy" ), 1, 0, 1 );
	car.playerview setanimknob( car.playerview getanim( "playerview_idle_bumpy" ), 1, 0, 1 );
}

car_static( car )
{
	car setanimknob( car getanim( "car_idle_static" ), 1, 0, 1 );
	car.playerview setanimknob( car.playerview getanim( "playerview_idle_static" ), 1, 0, 1 );
}

car_turnright1( car )
{
	println( "Started turnright1, idle OFF" );
	car notify( "stop_driver_idle" );
	car playTurnAnim("center2smallright");
	//car playTurnAnim("smallright_idle");
	car playTurnAnim("smallright2center");
	car thread anim_loop_solo( car.driver, "cardriver_idle", "tag_driver", "stop_driver_idle" );
	println( "Finished turnright1, idle ON" );
}

car_turnleft1( car )
{
	println( "Started turnleft1, idle OFF" );
	car notify( "stop_driver_idle" );
	car playTurnAnim("center2smallleft");
	car playTurnAnim("smallleft_idle");
	car playTurnAnim("smallleft2center");
	car thread anim_loop_solo( car.driver, "cardriver_idle", "tag_driver", "stop_driver_idle" );
	println( "Finished turnleft1, idle ON" );
}

car_turnleft2( car )
{
	println( "Started turnleft2, idle OFF" );
	car notify( "stop_driver_idle" );
	car playTurnAnim("center2smallleft");
	car playTurnAnim("smallleft2bigleft");
	car playTurnAnim("bigleft_idle");
	car playTurnAnim("bigleft2center");
	car thread anim_loop_solo( car.driver, "cardriver_idle", "tag_driver", "stop_driver_idle" );
	println( "Finished turnleft2, idle ON" );
}

car_turnleft3( car )
{
	println( "Started turnleft3, idle OFF" );
	car notify( "stop_driver_idle" );
	car playTurnAnim("center2smallleft");
	car playTurnAnim("smallleft2bigleft");
	car playTurnAnim("bigleft_loop");
	car playTurnAnim("bigleft_idle");
	car playTurnAnim("bigleft2center");
	car thread anim_loop_solo( car.driver, "cardriver_idle", "tag_driver", "stop_driver_idle" );
	println( "Finished turnleft3, idle ON" );
}

playerDeath( guy )
{
	playfxontag( getfx( "execution_muzzleflash" ), guy, "tag_flash" );
	playfxontag( getfx( "execution_shell_eject" ), guy, "tag_brass" );

	wait .05;

	set_vision_set( "coup_death", .5 );

	wait 3.5;
	
	black = newHudElem();
	black.x = 0;
	black.y = 0;
	black setshader( "black", 640, 480 );
	black.alignX = "left";
	black.alignY = "top";
	black.horzAlign = "fullscreen";
	black.vertAlign = "fullscreen";
	black.alpha = 0;
	black.sort = 3;

	black fadeOverTime( 3 );
	black.alpha = 1;

	wait 3;
	
	changelevel( "blackout", false );
	//changelevel( "coup", false );
}

playerHit( unused )
{
	takeCoverWarnings = getdvarint( "takeCoverWarnings" );
	setdvar( "takeCoverWarnings", "0" );
	
	// thread playerBreathingSound( level.player.maxHealth * 0.35 );
	// thread playerBreathingSound( 100 * 0.35 );
	thread playerBreathingSound( 100 * 0.35, 25 );
	
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "overlay_low_health", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;

	thread maps\_gameskill::healthOverlay_remove( overlay );
	
	// for ( ;; )
	// {
		overlay fadeOverTime( 0.5 );
		overlay.alpha = 0;
		// flag_wait( "player_has_red_flashing_overlay" );
		maps\_gameskill::redFlashingOverlay( overlay );
		// redFlashingOverlay( overlay );
	// }*/ 
	
	setdvar( "takeCoverWarnings", takeCoverWarnings );
}

playerHitDamage( unused )
{
	newHealth = level.player.health * 0.10;
    healthDiff = level.player.health - newHealth;

    damage = healthDiff / getdvarfloat( "player_damageMultiplier" );
	// iprintln( level.player.health );
    level.player doDamage( damage, level.player.origin );
	// iprintln( level.player.health );
}

playerBreathingSound( maxhealth, hurthealth )
{
	wait( 2 );
	for ( ;; )
	{
		wait( 0.2 );
		if ( hurthealth <= 0 )
			return;
			
		// Player still has a lot of health so no breathing sound
		ratio = hurthealth / maxhealth;
		if ( ratio > level.healthOverlayCutoff )
			continue;
			
		level.player play_sound_on_entity( "breathing_hurt" );
		wait( 0.1 + randomfloat( 0.8 ) );
	}
}

/* playerHealthRegen()
{
	thread healthOverlay();
	oldratio = 1;
	player = level.player;
	health_add = 0;
	
	regenRate = 0.1;
	veryHurt = false;
	playerJustGotRedFlashing = false;
	
	level.hurtTime = -10000;
	thread playerBreathingSound( level.player.maxHealth * 0.35 );
	invulTime = 0;
	hurtTime = 0;
	newHealth = 0;
	lastinvulratio = 1;
	
	player.boltHit = false;
	
	if ( getdvar( "scr_playerInvulTimeScale" ) == "" )
		setdvar( "scr_playerInvulTimeScale", 1.0 );
	
	for ( ;; )
	{
		wait( 0.05 );
		if ( player.health == level.player.maxHealth )
		{
			if ( flag( "player_has_red_flashing_overlay" ) )
			{
				flag_clear( "player_has_red_flashing_overlay" );
				level notify( "take_cover_done" );
			}
			
			lastinvulratio = 1;
			playerJustGotRedFlashing = false;
			veryHurt = false;
			continue;
		}
		
		if ( player.health <= 0 )
		{
			 /#showHitLog();#/ 
			return;
		}
		
		wasVeryHurt = veryHurt;
		ratio = player.health / level.player.maxHealth;
		if ( ratio <= level.healthOverlayCutoff )
		{
			veryHurt = true;
			if ( !wasVeryHurt )
			{
				hurtTime = gettime();
				level.hurtTime = hurtTime;
				thread blurView( 3.6, 2 );
				
				flag_set( "player_has_red_flashing_overlay" );
				playerJustGotRedFlashing = true;
			}
		}
	
		if ( player.health / player.maxHealth >= oldratio )
		{
			if ( gettime() - hurttime < level.playerHealth_RegularRegenDelay )
				continue;

			if ( veryHurt )
			{
				newHealth = ratio;
				if ( gettime() > hurtTime + level.longRegenTime )
					newHealth += regenRate;
			}
			else
				newHealth = 1;
							
			if ( newHealth > 1.0 )
				newHealth = 1.0;
			
			if ( newHealth <= 0 )
			{
				// Player is dead
				return;
			}
			
			 /#
			if ( newHealth > player.health / player.maxHealth )
				logRegen( newHealth );
			#/ 
			player setnormalhealth( newHealth );
			oldRatio = player.health / player.maxHealth;
			continue;
		}
		
		oldratio = lastinvulRatio;
		invulWorthyHealthDrop = oldratio - ratio >= level.worthyDamageRatio;
		
		if ( player.health <= 1 )
		{
			// if player's health is <= 1, code's player_deathInvulnerableTime has kicked in and the player won't lose health for a while.
			// set the health to 2 so we can at least detect when they're getting hit.
			player setnormalhealth( 2 / player.maxHealth );
			invulWorthyHealthDrop = true;
		}

		oldRatio = player.health / player.maxHealth;
		level notify( "hit_again" );
			
		health_add = 0;
		hurtTime = gettime();
		level.hurtTime = hurtTime;
		thread blurView( 3, 0.8 );
		
		if ( !invulWorthyHealthDrop || getdvarfloat( "scr_playerInvulTimeScale" ) <= 0.0 )
		{
			 /#logHit( player.health, 0 );#/ 
			continue;
		}
		if ( flag( "player_is_invulnerable" ) )
			continue;
		flag_set( "player_is_invulnerable" );
		level notify( "player_becoming_invulnerable" );// because "player_is_invulnerable" notify happens on both set * and * clear
		
		level.conserveAmmoAgainstInvulPlayer = false;
		level.conserveAmmoAgainstInvulPlayerTime = gettime();
		
		if ( playerJustGotRedFlashing )
		{
			invulTime = level.invulTime_onShield;
			playerJustGotRedFlashing = false;
		}
		else if ( veryHurt )
		{
			invulTime = level.invulTime_postShield;
		}
		else
		{
			invulTime = level.invulTime_preShield;
		}
		
		invulTime *= getdvarfloat( "scr_playerInvulTimeScale" );
		
		 /#logHit( player.health, invulTime );#/ 
		lastinvulratio = player.health / player.maxHealth;
		
		level.player.attackerAccuracy = 0;
		thread invulEnd( invulTime );
	}
}*/ 


melee_kill( guy )
{
	guy playsound( "melee_swing_large" );
	
	// alias = "generic_pain_russian_" + guy.favoriteenemy._stealth.behavior.sndnum;
	
	// guy.favoriteenemy playsound( alias );
	guy.favoriteenemy playsound( "melee_hit" );
	guy.favoriteenemy.allowdeath = false;
	guy.favoriteenemy notify( "anim_death" );
	
	thread kill_self( guy.favoriteenemy );
}

rag_doll_death( guy )
{		
	guy thread killed_by_player( true );	
}

kill_self( guy )
{
	guy endon( "death" );
	
	wait .1;// for no death to be sent
	guy.allowdeath = true;
	guy dodamage( guy.health + 200, guy.origin );
}

killed_by_player( ragdoll )
{
	self endon( "anim_death" );
	
	self notify( "killed_by_player_func" );
	self endon( "killed_by_player_func" );
	
	while ( 1 )
	{
		self waittill( "death", other );
		if ( isdefined( other ) && other == level.player )
			break;
	}
	self notify( "killed_by_player" );	
	if ( isdefined( ragdoll ) )
	{
		self animscripts\shared::DropAllAIWeapons();
		self startragdoll();	
	}
}

playTurnAnim( animsuffix )
{
	self setflaggedanimknob( "wheel_flag", self getanim( "wheel_" + animsuffix ), 1, 0, 1 );
	self.driver setflaggedanimknob( "cardriver_flag", self.driver getanim( "cardriver_" + animsuffix ), 1, 0, 1 );
	self.driver waittillend ( "cardriver_flag" );
	temp = 1;
}