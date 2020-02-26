#include maps\_anim;
#using_animtree( "generic_human" );

main()
{
	level.scr_anim[ "price" ][ "rappel_end" ]					= %sniper_escape_rappel_finish;
	level.scr_anim[ "price" ][ "rappel_start" ]					= %sniper_escape_rappel_start;
	level.scr_anim[ "price" ][ "rappel_idle" ][ 0 ]				= %sniper_escape_rappel_idle;
	
	// We値l have to take the short cut! Follow my lead!	
	level.scr_sound[ "price" ][ "rappel_start" ] = "sniperescape_mcm_shortcut";



	level.scr_anim[ "price" ][ "spin" ]							= %combatwalk_f_spin;
	level.scr_anim[ "price" ][ "halt" ]							= %stand_exposed_wave_halt_v2;
	
	level.scr_anim[ "price" ][ "wounded_turn_left" ] 			= %sniper_escape_price_turn_L;
	level.scr_anim[ "price" ][ "wounded_turn_right" ] 			= %sniper_escape_price_turn_R;
	

	// Chopper!!! Get back! I'll cover you!	sniperescape_mcm_choppergetback
	addNotetrack_dialogue( "price", "dialog", "wounded_begins", "sniperescape_mcm_choppergetback" );

	level.scr_anim[ "price" ][ "wounded_begins" ]				= %sniper_escape_price_hit;
	level.scr_anim[ "price" ][ "wounded_idle" ][ 0 ]			= %sniper_escape_price_hit_idle;
	level.scr_anim[ "price" ][ "wounded_idle" + "weight" ][ 0 ]	= 100;
	level.scr_anim[ "price" ][ "wounded_idle" ][ 1 ]			= %sniper_escape_price_hit_idle;
	level.scr_anim[ "price" ][ "wounded_idle" + "weight" ][ 1 ]	= 35;
	level.scr_anim[ "price" ][ "wounded_fire" ]					= %sniper_escape_price_hit_fire;

	level.scr_anim[ "price" ][ "wounded_crawl_start" ]			= %sniper_escape_price_crawl_start;
	level.scr_anim[ "price" ][ "wounded_crawl_end" ]			= %sniper_escape_price_crawl_end;
	level.scr_anim[ "price" ][ "wounded_crawl" ]				= %sniper_escape_price_crawl;
	
	

	level.scr_anim[ "price" ][ "wounded_death" ]				= %sniper_escape_price_killed;

	level.scr_anim[ "price" ][ "wounded_base" ]					= %wounded_aim;
	level.scr_anim[ "price" ][ "wounded_aim_left" ]				= %sniper_escape_price_aim_L;
	level.scr_anim[ "price" ][ "wounded_aim_right" ]			= %sniper_escape_price_aim_R;

	level.scr_anim[ "price" ][ "wounded_carry" ][ 0 ]			= %sniper_escape_price_walk;
	level.scr_anim[ "player" ][ "wounded_carry" ][ 0 ]			= %sniper_escape_playerview_walk;

	level.scr_anim[ "price" ][ "wounded_pickup" ]				= %sniper_escape_price_getup;
	level.scr_anim[ "price" ][ "wounded_putdown" ]				= %sniper_escape_price_putdown;
	level.scr_anim[ "price" ][ "pickup_idle" ][ 0 ]				= %sniper_escape_price_wounded_idle;

	level.scr_anim[ "price" ][ "pickup_idle" ][ 0 ]				= %sniper_escape_price_wounded_idle;


	level.scr_anim[ "generic" ][ "patrol_look_up" ]					= %patrol_jog_look_up;
	level.scr_anim[ "generic" ][ "patrol_360" ] 					= %patrol_jog_360;
	level.scr_anim[ "generic" ][ "patrol_jog" ] 					= %patrol_jog;
	level.scr_anim[ "generic" ][ "patrol_orders" ] 					= %patrol_jog_orders;

	level.scr_anim[ "generic" ][ "patrol_look_up_once" ]			= %patrol_jog_look_up_once;
	level.scr_anim[ "generic" ][ "patrol_360_once" ] 				= %patrol_jog_360_once;
	level.scr_anim[ "generic" ][ "patrol_jog_once" ] 				= %patrol_jog_once;
	level.scr_anim[ "generic" ][ "patrol_orders_once" ]				= %patrol_jog_orders_once;



	addNotetrack_customFunction( "price", "fire", maps\sniperescape_code::price_fires, "wounded_fire" );


	
	// Delta Two Four, this is Alpha Six! We have been compromised, I repeat we have been compromised, now heading to Extraction Point four!	
	level.scr_radio[ "compromised" ] = "sniperescape_mcm_comrpomised";
	
	//* Alpha Six, Seaknight Five-Niner is en route, E.T.A. - 20 minutes. Don't be late. We're stretchin' our fuel as it is. Out.	
	level.scr_radio[ "eta_20_min" ] = "sniperescape_hqr_stretchingourfuel";
	

	//* Leftenant Price, follow me!	
	level.scr_sound[ "price" ][ "follow_me" ] = "sniperescape_mcm_followme";

	//* We've got to head for the extraction point! Move!	
	level.scr_sound[ "price" ][ "head_for_extract" ] = "sniperescape_mcm_headforpoint";
	
	// More behind us!	
	level.scr_sound[ "price" ][ "more_behind" ] = "sniperescape_mcm_morebehind";
	
	// In the bushes, behind us to the north.	
	level.scr_sound[ "price" ][ "bushes_north" ] = "sniperescape_mcm_bushesnorth";
	
	// More enemies behind us, in the bushes to the northwest.	
	level.scr_sound[ "price" ][ "bushes_northwest" ] = "sniperescape_mcm_bushesNW";

	// In the woods!	
	level.scr_sound[ "price" ][ "woods_north" ] = "sniperescape_mcm_inthewoods";
	
	// Behind us! Movement in the woods to the northeast.	
	level.scr_sound[ "price" ][ "woods_northeast" ] = "sniperescape_mcm_woodsNE";
	
	// More in the woods behind us to the east.	
	level.scr_sound[ "price" ][ "woods_east" ] = "sniperescape_mcm_woodseast";
	
	// In the woods!	
	level.scr_sound[ "price" ][ "woods_southeast" ] = "sniperescape_mcm_inthewoods";
	
	// Enemies behind us in the woods to the south.	
	level.scr_sound[ "price" ][ "woods_south" ] = "sniperescape_mcm_woodssouth";
	
	// Behind us! In the woods to the southwest.	
	level.scr_sound[ "price" ][ "woods_southwest" ] = "sniperescape_mcm_woodsSW";
	
	// In the woods!	
	level.scr_sound[ "price" ][ "woods_west" ] = "sniperescape_mcm_inthewoods";
	
	// In the woods!	
	level.scr_sound[ "price" ][ "woods_northwest" ] = "sniperescape_mcm_inthewoods";
	
	// Movement behind us. Coming through the bushes to the west.	
	level.scr_sound[ "price" ][ "bushes_west" ] = "sniperescape_mcm_busheswest";
	
	// More coming from the north.	
	level.scr_sound[ "price" ][ "enemies_north" ] = "sniperescape_mcm_comingnorth";
	
	// Movement. Northeast.	
	level.scr_sound[ "price" ][ "enemies_northeast" ] = "sniperescape_mcm_movementNE";
	
	// Tangos moving to the east.	
	level.scr_sound[ "price" ][ "enemies_east" ] = "sniperescape_mcm_tangoseast";
	
	// Targets southeast.	
	level.scr_sound[ "price" ][ "enemies_southeast" ] = "sniperescape_mcm_targetsSE";
	
	// More of them moving in from the south.	
	level.scr_sound[ "price" ][ "enemies_south" ] = "sniperescape_mcm_morefromsouth";
	
	// Contact southwest.	
	level.scr_sound[ "price" ][ "enemies_southwest" ] = "sniperescape_mcm_contactSW";
	
	// Hostiles closing from the west.	
	level.scr_sound[ "price" ][ "enemies_west" ] = "sniperescape_mcm_hostileswest";
	
	// More tangos to the northwest.	
	level.scr_sound[ "price" ][ "enemies_northwest" ] = "sniperescape_mcm_tangosNW";
	
	//* We'll lose 'em in that apartment! Come on!	
	level.scr_sound[ "price" ][ "lose_them_in_apartment" ] = "sniperescape_mcm_apartmentcomeon";
	
	// Quickly - plant a claymore in case they come this way!	
	level.scr_sound[ "price" ][ "place_claymore" ] = "sniperescape_mcm_plantclaymore";
	
	//* Standby�!	
	level.scr_sound[ "price" ][ "standby" ] = "sniperescape_mcm_standby";
	
	//* Now!	
	level.scr_sound[ "price" ][ "now" ] = "sniperescape_mcm_now";
	
	//* Bloody 'ell I知 hit, I can't move!!!!	
	level.scr_sound[ "price" ][ "im_hit" ] = "sniperescape_mcm_imhit";
	
	//* Sorry mate, you're gonna have to carry me!	
	level.scr_sound[ "price" ][ "carry_me" ] = "sniperescape_mcm_sorrymate";
	
	//* Price! Put me down where I can cover you!	
	level.scr_radio[ "put_me_down_1" ] = "sniperescape_mcm_coveryou";
	
	//* Oi! Sit me down where I can cover your back!	
	level.scr_radio[ "put_me_down_2" ] = "sniperescape_mcm_oisit";
	
	//* You'd better put me down quick so I can fight back�	
	level.scr_radio[ "put_me_down_quick" ] = "sniperescape_mcm_fightback";
	
	//* Leftenant Price! Don't get too far ahead.	
	level.scr_sound[ "price" ][ "dont_go_far" ] = "sniperescape_mcm_toofarahead";
	
	// plays after you pick him up so its on the "radio" ie in your head
	// The extraction point is to the southwest. We can still make it if we hurry.	
	level.scr_radio[ "extraction_is_southwest" ] = "sniperescape_mcm_makeithurry";
	
	//* Got one.	
	level.scr_sound[ "price" ][ "got_one" ] = "sniperescape_mcm_gotone";
	
	//* Tango down.	
	level.scr_sound[ "price" ][ "tango_down" ] = "sniperescape_mcm_tangodown";
	
	//* He's down.	
	level.scr_sound[ "price" ][ "he_is_down" ] = "sniperescape_mcm_hesdown";
	
	//* Got another.	
	level.scr_sound[ "price" ][ "got_another" ] = "sniperescape_mcm_gotanother";
	
	//*  Got him.	
	level.scr_sound[ "price" ][ "got_him" ] = "sniperescape_mcm_gothim";
	
	//* Target neutralized.	
	level.scr_sound[ "price" ][ "target_neutralized" ] = "sniperescape_mcm_targetneutralized";
	
	// Head for that apartment, we'll try to lose 'em in there..	
	level.scr_sound[ "price" ][ "head_for_apartment" ] = "sniperescape_mcm_headforapartment";
	
	// We're almost there. The extraction point is on the other side of that building.	
	level.scr_sound[ "price" ][ "almost_there" ] = "sniperescape_mcm_otherside";

	// Leftenant Price, the meeting is underway. Enemy transport sighted entering the target area.	
	level.scr_sound[ "price" ][ "transport_inbound" ] = "sniperescape_mcm_enemysighted";
	

	// Enemy contact up ahead. Let's cut through the woods.	
	level.scr_sound[ "price" ][ "cut_through_woods" ] = "sniperescape_mcm_cutthruwoods";
	
	// The extraction point is to the southwest. We can still make it if we hurry.	
	level.scr_sound[ "price" ][ "extract_southwest" ] = "sniperescape_mcm_makeithurry";
	
	// Head for that apartment, we'll try to lose 'em in there..	
	level.scr_radio[ "head_for_apartment" ] = "sniperescape_mcm_headforapartment";
	
	// Alright, go!	
	level.scr_sound[ "price" ][ "alright_go" ] = "sniperescape_mcm_alrightgo";
	
	// Get ready�	
	level.scr_sound[ "price" ][ "get_ready" ] = "sniperescape_mcm_getready";
	
	// Go!	
	level.scr_sound[ "price" ][ "go!" ] = "sniperescape_mcm_go";
	
	// Come on let's go!	
	level.scr_sound[ "price" ][ "come_on_lets_go" ] = "sniperescape_mcm_comeon";
	
	// It's time to move.	
	level.scr_sound[ "price" ][ "time_to_move" ] = "sniperescape_mcm_timetomove";
	
	// You'd better put me down and sweep the rooms, I'll cover the entrance.	
	level.scr_radio[ "sweep_the_rooms" ] = "sniperescape_mcm_putmedown";
	
	// Easy does it�	
	level.scr_sound[ "price" ][ "put_down_1" ] = "sniperescape_mcm_easydoesit";
	
	// Easy now�	
	level.scr_sound[ "price" ][ "put_down_2" ] = "sniperescape_mcm_easynow";
	
	// Careful�	
	level.scr_sound[ "price" ][ "put_down_3" ] = "sniperescape_mcm_careful";
	
	// It's time to move, give me a lift.	
	level.scr_sound[ "price" ][ "lets_get_moving_1" ] = "sniperescape_mcm_givemealift";
	
	// Looks like we're in the clear, we should get moving.	
	level.scr_sound[ "price" ][ "lets_get_moving_2" ] = "sniperescape_mcm_intheclear";
	
	// Leftenant, put me down in a good sniping position.	
	level.scr_sound[ "price" ][ "good_sniping_position" ] = "sniperescape_mcm_snipingposition";

	
// Great shot Leftenant! Now let's go! They'll be searching for us!	
//sniperescape_mcm_greatshot


	



	/*
	level.scr_anim[ "axis" ][ "patrolwalk_1" ] 					= %huntedrun_2;
	level.scr_anim[ "axis" ][ "patrolwalk_2" ] 					= %huntedrun_2;
	level.scr_anim[ "axis" ][ "patrolwalk_3" ] 					= %huntedrun_2;
	level.scr_anim[ "axis" ][ "patrolwalk_4" ] 					= %huntedrun_2;
	level.scr_anim[ "axis" ][ "patrolwalk_5" ] 					= %huntedrun_2;
	*/
	
	player_rappel();
	dog_anims();
	seaknight_anims();
	curtains();
}

#using_animtree( "player" );
player_rappel()
{
	level.scr_anim[ "player_rappel" ][ "rappel" ]						= %sniper_escape_player_rappel;
	level.scr_animtree[ "player_rappel" ] 								= #animtree;	
	level.scr_model[ "player_rappel" ] 									= "viewhands_player_marines";

	level.scr_anim[ "player_carry" ][ "wounded_putdown" ]				= %sniper_escape_player_putdown;
	level.scr_anim[ "player_carry" ][ "wounded_pickup" ]				= %sniper_escape_player_getup;
	level.scr_animtree[ "player_carry" ] 								= #animtree;	
	level.scr_model[ "player_carry" ] 									= "viewhands_player_marines";
}

#using_animtree( "dog" );

dog_anims()
{
	level.scr_anim[ "dog" ][ "fence_attack" ] 					= %sniper_escape_dog_fence;
	addNotetrack_sound( "dog", "sound_dog_attack_fence", "fence_attack", "anml_dog_attack_jump" );
	addNotetrack_sound( "dog", "fence", "fence_attack", "fence_smash" );
}

#using_animtree( "vehicles" );
seaknight_anims()
{
	level.scr_anim[ "seaknight" ][ "idle" ][ 0 ] 				= %sniper_escape_ch46_idle;
	level.scr_anim[ "seaknight" ][ "landing" ] 					= %sniper_escape_ch46_land;
	level.scr_anim[ "seaknight" ][ "take_off" ] 				= %sniper_escape_ch46_take_off;
	level.scr_animtree[ "seaknight" ] 							= #animtree;
}

#using_animtree( "script_model" );
curtains()
{
	precacheModel( "rappelrope100_ri" );
	level.scr_anim[ "curtain" ][ "curtain_right" ][ 0 ]			= %chechnya_curtain_sway_ri;
	level.scr_anim[ "curtain" ][ "curtain_left" ][ 0 ]			= %chechnya_curtain_sway_le;
	level.scr_animtree[ "curtain" ] 							= #animtree;	
	level.scr_model[ "curtain" ] 								= "ch_curtain01";

	level.scr_animtree[ "rope" ] 								= #animtree;
	level.scr_model[ "rope" ] 									= "rappelrope100_ri";

	level.scr_anim[ "rope" ][ "rappel_end" ]					= %sniper_escape_rappel_finish_rappelrope100;
	level.scr_anim[ "rope" ][ "rappel_start" ]					= %sniper_escape_rappel_start_rappelrope100;
	level.scr_anim[ "rope" ][ "rappel_idle" ][ 0 ]				= %sniper_escape_rappel_idle_rappelrope100;
}



/*

// Now get on the Barrett rifle and wait for my signal. Do not engage until I give the word.	
sniperescape_mcm_getonrifle

// Remember what I've taught you. Keep in mind variable humidity and wind speed along the bullet's flight path. At this distance you値l also have to take the Coriolis effect into account.	
sniperescape_mcm_corioliseffect

// Prepare for ranging. Standby.	
sniperescape_mcm_prepranging

// White truck on the left, range, 1203.5 meters.	
sniperescape_mcm_whitetruck

// Range to BMP, 1207 meters.	
sniperescape_mcm_bmprange

// The table with the briefcase, range, 1206 meters.	
sniperescape_mcm_table

// Ok... I think I see him. Wait for my mark.	
sniperescape_mcm_mymark

// Target...acquired. I have a positive I.D. on Imran Zakhaev.	
sniperescape_mcm_positiveid

// Ach, where did he come from? Patience laddie... Wait for a clear shot�.	
sniperescape_mcm_clearshot

// Ok take the shot.	
sniperescape_mcm_taketheshot

// Damn, my line of sight was blocked. Did you take him out? I thought I saw his arm fly off! Can you see him?	
sniperescape_mcm_armflyoff

// Shit... they池e on to us! Take out that helicopter, it値l buy us some time!	
sniperescape_mcm_buysometime

// Great shot Leftenant! Now let's go! They'll be searching for us!	
sniperescape_mcm_greatshot

// We値l have to take the short cut! Follow my lead!	
sniperescape_mcm_shortcut


// Delta Two Four, this is Alpha Six! We have been compromised, I repeat we have been compromised, now heading to Extraction Point four!	
sniperescape_mcm_comrpomised

Contact north.	sniperescape_mcm_contactnorth
Movement. Northeast.	sniperescape_mcm_movementNE
Tangos moving to the east.	sniperescape_mcm_tangoseast
Targets southeast.	sniperescape_mcm_targetsSE
Contact south.	sniperescape_mcm_contactsouth
Contact southwest.	sniperescape_mcm_contactSW
Hostiles closing from the west.	sniperescape_mcm_hostileswest
Contact northwest.	sniperescape_mcm_contactNW
More coming from the north.	sniperescape_mcm_comingnorth
More coming from the northeast.	sniperescape_mcm_moreNE
More to the east.	sniperescape_mcm_moreeast
More hostiles to the southeast.	sniperescape_mcm_hostilesSE
More of them moving in from the south.	sniperescape_mcm_morefromsouth
More to the southwest.	sniperescape_mcm_moreSW
More tangos to the west.	sniperescape_mcm_tangoswest
More tangos to the northwest.	sniperescape_mcm_tangosNW
In the woods to the north!	sniperescape_mcm_woodsnorth
Movement in the woods to the northeast.	sniperescape_mcm_woodsNE
More in the woods to the east.	sniperescape_mcm_woodseast
In the woods to the southeast!	sniperescape_mcm_woodsSE
Enemies in the woods to the south.	sniperescape_mcm_woodssouth
In the woods to the southwest.	sniperescape_mcm_woodsSW
In the woods to the west!	sniperescape_mcm_woodswest
They're in the woods to the northwest!	sniperescape_mcm_woodsNW
In the bushes to the north.	sniperescape_mcm_bushesnorth
In the bushes to the northeast.	sniperescape_mcm_bushesNE
In the bushes to the east.	sniperescape_mcm_busheseast
To the southeast, in the bushes.	sniperescape_mcm_bushesSE
More tangos in the bushes to the south.	sniperescape_mcm_tangosbushesS
Enemies moving in the bushes to the southeast.	sniperescape_mcm_enemiesSE
Movement behind us. Coming through the bushes to the west.	sniperescape_mcm_busheswest
More enemies behind us, in the bushes to the northwest.	sniperescape_mcm_bushesNW
In the woods!	sniperescape_mcm_inthewoods
More behind us!	sniperescape_mcm_morebehind


Price! Put me down where I can cover you!	sniperescape_mcm_coveryou

Oi! Sit me down where I can cover your back!	sniperescape_mcm_oisit

You'd better put me down quick so I can fight back�	sniperescape_mcm_fightback


Leftenant Price! Don't get too far ahead.	sniperescape_mcm_toofarahead

Got one.	sniperescape_mcm_gotone

Tango down.	sniperescape_mcm_tangodown

He's down.	sniperescape_mcm_hesdown

Got another.	sniperescape_mcm_gotanother

Target neutralized.	sniperescape_mcm_targetneutralized

Got him.	sniperescape_mcm_gothim

// We're almost there. The extraction point is on the other side of that building.	
sniperescape_mcm_otherside

// The fugitives are near the swimming pool complex! Send Groups A and B to cut them off now!	
sniperescape_rul_nearpool

// They are heading towards the amusement park! We need reinforcements in sector three!	
sniperescape_rul_amusementpk

// Enemy sighted near the Hotel Polissia! I repeat, enemy soldiers are moving from the Hotel Polissia!	
sniperescape_rul_hotelpolissa

// They've moved into Apartment Block D, we can't follow them in there. Cut off all the exits and stop them at the park.	
sniperescape_rul_cutoffexits


*/