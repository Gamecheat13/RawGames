#include maps\_anim;
#using_animtree( "generic_human" );

main()
{
	level.scr_anim[ "price" ][ "rappel_end" ]					= %sniper_escape_rappel_finish;
	level.scr_anim[ "price" ][ "rappel_start" ]					= %sniper_escape_rappel_start;
	level.scr_anim[ "price" ][ "rappel_idle" ][ 0 ]				= %sniper_escape_rappel_idle;


	level.scr_anim[ "price" ][ "spin" ]							= %combatwalk_f_spin;
	
	level.scr_anim[ "price" ][ "wounded_idle" ][ 0 ]			= %dying_back_idle;
	level.scr_anim[ "price" ][ "wounded_idle" + "weight" ][ 0 ]	= 100;
	level.scr_anim[ "price" ][ "wounded_idle" ][ 1 ]			= %dying_back_twitch_A;
	level.scr_anim[ "price" ][ "wounded_idle" + "weight" ][ 1 ]	= 35;

	level.scr_anim[ "price" ][ "wounded_fire" ]					= %dying_back_fire;
	level.scr_anim[ "price" ][ "wounded_death" ]				= %dying_back_death_v1;

	level.scr_anim[ "price" ][ "wounded_carry" ][ 0 ]			= %sniper_escape_price_walk;
	level.scr_anim[ "player" ][ "wounded_carry" ][ 0 ]			= %sniper_escape_playerview_walk;

	level.scr_anim[ "price" ][ "wounded_pickup" ]				= %sniper_escape_price_getup;
	level.scr_anim[ "price" ][ "wounded_putdown" ]				= %sniper_escape_price_putdown;
	level.scr_anim[ "price" ][ "pickup_idle" ][ 0 ]				= %sniper_escape_price_wounded_idle;


		
	level.scr_anim[ "axis" ][ "patrolwalk_1" ] 					= %active_patrolwalk_v1;
	level.scr_anim[ "axis" ][ "patrolwalk_2" ] 					= %active_patrolwalk_v2;
	level.scr_anim[ "axis" ][ "patrolwalk_3" ] 					= %active_patrolwalk_v3;
	level.scr_anim[ "axis" ][ "patrolwalk_4" ] 					= %active_patrolwalk_v4;
	level.scr_anim[ "axis" ][ "patrolwalk_5" ] 					= %active_patrolwalk_v5;



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
	
	//* Standby…!	
	level.scr_sound[ "price" ][ "standby" ] = "sniperescape_mcm_standby";
	
	//* Now!	
	level.scr_sound[ "price" ][ "now" ] = "sniperescape_mcm_now";
	
	//* Bloody 'ell I’m hit, I can't move!!!!	
	level.scr_sound[ "price" ][ "im_hit" ] = "sniperescape_mcm_imhit";
	
	//* Sorry mate, you're gonna have to carry me!	
	level.scr_sound[ "price" ][ "carry_me" ] = "sniperescape_mcm_sorrymate";
	
	//* Price! Put me down where I can cover you!	
	level.scr_radio[ "put_me_down_1" ] = "sniperescape_mcm_coveryou";
	
	//* Oi! Sit me down where I can cover your back!	
	level.scr_radio[ "put_me_down_2" ] = "sniperescape_mcm_oisit";
	
	//* You'd better put me down quick so I can fight back…	
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
	addNotetrack_sound( "dog", "bark", "fence_attack", "anml_dog_attack_jump" );
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
	level.scr_anim[ "curtain" ][ "curtain_right" ][ 0 ]			= %chechnya_curtain_sway_ri;
	level.scr_anim[ "curtain" ][ "curtain_left" ][ 0 ]			= %chechnya_curtain_sway_le;
	level.scr_animtree[ "curtain" ] 							= #animtree;	
	level.scr_model[ "curtain" ] 								= "ch_curtain01";
}
