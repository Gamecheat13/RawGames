#include maps\_anim;
#using_animtree("generic_human");

main()
{
	anims();
	tmp_anims();
}

tmp_anims()
{
	// PRICE
	level.scr_sound[ "price" ][ "ambush_pri_notbad" ]		= "ambush_pri_notbad";

	level.scr_sound[ "price" ][ "ambush_pri_onmymark" ]		= "ambush_pri_onmymark";
	level.scr_sound[ "price" ][ "ambush_pri_takethemout" ]	= "ambush_pri_takethemout";
	level.scr_sound[ "price" ][ "ambush_pri_cleartower" ]	= "ambush_pri_cleartower";
	level.scr_sound[ "price" ][ "ambush_pri_movemove" ]		= "ambush_pri_movemove";

	level.scr_sound[ "price" ][ "ambush_pri_sortedout" ]	= "ambush_pri_sortedout";
	level.scr_sound[ "price" ][ "ambush_pri_keepbusy" ]		= "ambush_pri_keepbusy";
	level.scr_sound[ "price" ][ "ambush_pri_muchtime" ]		= "ambush_pri_muchtime";

	level.scr_sound[ "price" ][ "ambush_pri_copythat" ]		= "ambush_pri_copythat";
	level.scr_sound[ "price" ][ "ambush_pri_youknow" ]		= "ambush_pri_youknow";

	level.scr_sound[ "price" ][ "ambush_pri_thirdfront" ]	= "ambush_pri_thirdfront";
	level.scr_sound[ "price" ][ "ambush_pri_takealive" ]	= "ambush_pri_takealive";
	level.scr_sound[ "price" ][ "ambush_pri_standby" ]		= "ambush_pri_standby";
	level.scr_sound[ "price" ][ "ambush_pri_go" ]			= "ambush_pri_go";

	level.scr_sound[ "price" ][ "ambush_pri_runforit" ]		= "ambush_pri_runforit";
	level.scr_sound[ "price" ][ "ambush_pri_chasehim" ]		= "ambush_pri_chasehim";

	level.scr_sound[ "price" ][ "ambush_pri_goafterhim" ]	= "ambush_pri_goafterhim";

	level.scr_sound[ "price" ][ "ambush_pri_cantriskit" ]	= "ambush_pri_cantriskit";
	level.scr_sound[ "price" ][ "ambush_pri_2isdead" ]		= "ambush_pri_2isdead";
	level.scr_sound[ "price" ][ "ambush_pri_knowtheman" ]	= "ambush_pri_knowtheman";

	// GAZ
	level.scr_sound[ "steve" ][ "ambush_gaz_visualtarget" ]	= "ambush_gaz_visualtarget";
	level.scr_sound[ "steve" ][ "ambush_gaz_gotcompany" ]	= "ambush_gaz_gotcompany";

	level.scr_sound[ "steve" ][ "ambush_gaz_fivestory" ]	= "ambush_gaz_fivestory";
	level.scr_sound[ "steve" ][ "ambush_gaz_heavyfire" ]	= "ambush_gaz_heavyfire";

	level.scr_sound[ "steve" ][ "ambush_gaz_dropgun" ]		= "ambush_gaz_dropgun";
	level.scr_sound[ "steve" ][ "ambush_gaz_no" ]			= "ambush_gaz_no";
	level.scr_sound[ "steve" ][ "ambush_gaz_onlylead" ]		= "ambush_gaz_onlylead";


	// TEMP TEMP TEMP TEMP TEMP

	level.scr_text[ "generic" ][ "best_way" ]				= "This is the best way in. The vehicle checkpoint is directly ahead.";

	level.scr_text[ "radio" ][ "radio_jammers1" ]			= "Bravo Six, this is Vulture One-Six. Radio jammers are active,";
	level.scr_text[ "radio" ][ "radio_jammers2" ]			= "you're cleared to engage the guard station. Out.";

	level.scr_text[ "radio" ][ "caravan_inbound1" ]			= "Bravo Six this is Vulture One-Six, we're tracking an enemy convoy headed your way.";
	level.scr_text[ "radio" ][ "caravan_inbound2" ]			= "I count six vehicles in the convoy, over.";

	level.scr_text[ "mark" ][ "area_secure" ]			= "Area secure.";
	
	// ambush
	level.scr_text[ "mark" ][ "black_russian" ]			= "Who said there where no such thing as a black russian.";
	level.scr_text[ "mark" ][ "outfit1" ]				= "Man, you look ridiculous in that outfit.";
	level.scr_text[ "mark" ][ "outfit2" ]				= "Good thing you are up here couse you look nothing like a russian.";

	level.scr_text[ "generic" ][ "delaying1" ]			= "Papers please!";
	level.scr_text[ "enemy" ][ "background1" ]			= "Papers, what papers are you talking about?";
	level.scr_text[ "enemy" ][ "background2" ]			= "Who the fuck do you think you are standing there like a fat politisian asking me for anything.";
	level.scr_text[ "enemy" ][ "background3" ]			= "What are you waiting for, open the fucking gate you idiot!";
	level.scr_text[ "generic" ][ "delaying2" ]			= "Yes, sorry sir. I'll do that right now.";

	// village
	level.scr_text[ "radio" ][ "heli_greetings1" ]		= "Ground unit this is Vulture,";
	level.scr_text[ "radio" ][ "heli_greetings2" ]		= "I'll keep an eye out for our target and any threats I can spot.";
	level.scr_text[ "radio" ][ "heli_target_junkyard" ]	= "Ground unit, I have an visual of the target. He's leaving the junk yard to north west.";

	level.scr_text[ "radio" ][ "heli_outskirts" ]		= "The target. Is moving north, down towards the outskirts of the city.";
	level.scr_text[ "radio" ][ "heli_sympatisers" ]		= "Intel suggests that this area have a great number of enemy sympatisers.";

	level.scr_text[ "badguy" ][ "my_turf" ]				= "You idiot people, you think you can capture me on my own turf?";
	level.scr_text[ "badguy" ][ "enemies_to_kill" ]		= "Come friends of mine, we have enemies to kill!";

	level.scr_text[ "mark" ][ "friendlies_six" ]		= "Friendlies six o'clock. About time it was getting a bit tight around here.";
	level.scr_text[ "price" ][ "sorry_wait" ]			= "Sorry for the wait, better late then never.";

	level.scr_text[ "radio" ][ "keep_alive" ]			= "Check your fire check your fire. We gotta take this guy alive.";

	level.scr_text[ "radio" ][ "heli_alley" ]			= "The target is moving away. There is a side alley to the left that might let you cut him off.";
	level.scr_text[ "price" ][ "go_after_him" ]			= "Player, go after him, We'll stay here and keep there bastards off your back. Griggs, Smith go with him.";

	// Morpheus alley
	level.scr_text[ "radio" ][ "heli_dumpster" ]		= "Got another two enemies on the other side of the dumpster straight ahead.";
	level.scr_text[ "radio" ][ "heli_green_car" ]		= "A couple of enemies behind a green car around the corner.";
	level.scr_text[ "radio" ][ "heli_yard" ]			= "Multiple hostiles on the other side of that iron fence.";
	level.scr_text[ "radio" ][ "heli_flank_right" ]		= "Two hostiles comming up on your right flank.";
	level.scr_text[ "radio" ][ "heli_roof" ]			= "I got movement on the roof tops.";
	level.scr_text[ "radio" ][ "heli_rpg_roof" ]		= "RPG on the roof, top right";
	level.scr_text[ "radio" ][ "heli_second_floor" ]	= "Hostiles, second floor, to your right.";
	level.scr_text[ "radio" ][ "heli_overturned" ]		= "Single guy behind the overturned dumpster.";
	level.scr_text[ "radio" ][ "heli_target" ]			= "I have visual of the target, he is running past behind those overturned cars atraight ahead.";
	level.scr_text[ "radio" ][ "heli_alley_left" ]		= "Small group of hostiles comming your way down the alley to the left.";

	level.scr_text[ "radio" ][ "heli_you_got_them" ]	= "You got them, good work.";
	level.scr_text[ "radio" ][ "heli_nice_work" ]		= "nice work!";
	level.scr_text[ "radio" ][ "heli_nicely_done" ]		= "nicely_done.";
	level.scr_text[ "radio" ][ "heli_all_clear" ]		= "All clear.";


	// Parking lot
	level.scr_text[ "radio" ][ "heli_building" ]			= "Targets moving across the parking lot towards a five story building.";
	level.scr_text[ "radio" ][ "heli_targer_visual" ]		= "Ground unit, do you have visual, over";
	level.scr_text[ "radio" ][ "heli_heavy_fire" ]			= "Acknowledged ground force, let's see what I can do.";

	// Building
	level.scr_text[ "radio" ][ "heli_target_second_floor" ]	= "Target is on the move in the north east part of the building, on the second floor.";
	level.scr_text[ "radio" ][ "heli_staircase" ]			= "Target is on your left one floor above. There is a staircase in the north corner.";
	level.scr_text[ "radio" ][ "heli_deeper" ]				= "Target moved deeper into the building, hold on, let me give you a hand there.";
	level.scr_text[ "radio" ][ "heli_threat" ]				= "threat neutralized";
	level.scr_text[ "radio" ][ "heli_movement_roof" ]		= "I have motion on the roof. Hold on.";
	level.scr_text[ "radio" ][ "heli_confirmed_roof" ]		= "Confirmed, Visual of the target on the roof";

	// End scene ( What ever fits with the mocap )
}

anims()
{
	level.scr_anim[ "price" ][ "cleanup" ]					= %bog_javelin_dialogue_briefing;

	level.scr_anim[ "price" ][ "jump" ]						= %ambush_Price_jump;
	level.scr_anim[ "badguy" ][ "jump" ]					= %ambush_VIP_son_jump;
	level.scr_anim[ "badguy" ][ "idle" ]					= %ambush_VIP_son_idle;

	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;
	
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;
	
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle_smoke;

	level.scr_anim[ "generic" ][ "sprint" ]					= %sprint1_loop;
	level.scr_anim[ "mark" ][ "sprint" ]					= %sprint_loop_distant;

	level.scr_anim[ "generic" ][ "death_pose_0" ]			= %death_sitting_pose_v1;
	level.scr_anim[ "generic" ][ "death_pose_1" ]			= %death_sitting_pose_v2;
}