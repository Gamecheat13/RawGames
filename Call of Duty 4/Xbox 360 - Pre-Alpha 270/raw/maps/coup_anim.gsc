#include maps\_utility;
#include maps\_anim;

main()
{
	anim_generic_human();
	anim_player();
	anim_car();
}

#using_animtree( "player" );
anim_player()
{
	level.scr_animtree[ "playerview" ] 						= #animtree;
	level.scr_model[ "playerview" ] 						= "viewhands_player_usmc";
	level.scr_anim[ "playerview" ][ "coup_opening" ]		= %coup_opening_playerview;
	level.scr_anim[ "playerview" ][ "car_idle" ][ 0 ]		= %coup_opening_playerview_idle;
	level.scr_anim[ "playerview" ][ "car_idle_firstframe" ]	= %coup_opening_playerview_idle;
	level.scr_anim[ "playerview" ][ "coup_ending" ]			= %coup_ending_player;

	level.scr_anim[ "playerview" ][ "playerview_idle_normal" ]	= %coup_opening_playerview_idle_normal;
	level.scr_anim[ "playerview" ][ "playerview_idle_smooth" ]	= %coup_opening_playerview_idle_smooth;
	level.scr_anim[ "playerview" ][ "playerview_idle_bumpy" ]	= %coup_opening_playerview_idle_bumpy;
	level.scr_anim[ "playerview" ][ "playerview_idle_static" ]	= %coup_opening_playerview_idle_static;
	
	//addNotetrack_customFunction( animname, notetrack, function, anime )
	addNotetrack_customFunction( "playerview", "hit", ::playerHit, "coup_opening" );
}

#using_animtree( "generic_human" );
anim_generic_human()
{
	level.scr_animtree[ "intro_leftguard" ] 				= #animtree;
	level.scr_anim[ "intro_leftguard" ][ "coup_opening" ]	= %coup_opening_guyL;

	level.scr_animtree[ "intro_rightguard" ] 				= #animtree;
	level.scr_anim[ "intro_rightguard" ][ "coup_opening" ]	= %coup_opening_guyR;
	
	level.scr_animtree[ "car_driver" ] 						= #animtree;
	level.scr_anim[ "car_driver" ][ "car_idle" ][ 0 ]		= %luxurysedan_driver_idle;

	level.scr_animtree[ "car_shotgun" ] 					= #animtree;
	level.scr_anim[ "car_shotgun" ][ "car_idle" ][ 0 ]		= %luxurysedan_passenger_idle;

	level.scr_animtree[ "car_backseat" ] 					= #animtree;
	level.scr_anim[ "car_backseat" ][ "car_idle" ][ 0 ]		= %luxurysedan_rear_passenger_idle;
	
	level.scr_animtree[ "ending_alasad" ] 					= #animtree;
	level.scr_anim[ "ending_alasad" ][ "coup_ending" ]		= %coup_ending_alasad;

	level.scr_animtree[ "ending_zakhaev" ] 					= #animtree;
	level.scr_anim[ "ending_zakhaev" ][ "coup_ending" ]		= %coup_ending_zakhaev;

	//addNotetrack_attach/detach( animname, notetrack, model, tag, anime )
	addNotetrack_detach("ending_zakhaev", "detach gun", "weapon_desert_eagle_silver_coup", "tag_inhand", "coup_ending");
	addNotetrack_attach("ending_alasad", "attach gun", "weapon_desert_eagle_silver_coup", "tag_inhand", "coup_ending");
	
	//addNotetrack_customFunction( animname, notetrack, function, anime )
	addNotetrack_customFunction( "ending_alasad", "fire_gun", ::playerDeath, "coup_ending" );
}

#using_animtree( "vehicles" );
anim_car()
{
	level.scr_animtree[ "car" ] 							= #animtree;
	level.scr_model[ "car" ] 								= "vehicle_luxurysedan_viewmodel";

	level.scr_anim[ "car" ][ "coup_opening" ]				= %coup_opening_car;
	level.scr_anim[ "car" ][ "coup_car_driving" ]			= %coup_opening_car_driving;
	level.scr_anim[ "car" ][ "car_idle_normal" ]			= %coup_opening_car_driving_idle_normal;
	level.scr_anim[ "car" ][ "car_idle_smooth" ]			= %coup_opening_car_driving_idle_smooth;
	level.scr_anim[ "car" ][ "car_idle_bumpy" ]				= %coup_opening_car_driving_idle_bumpy;
	level.scr_anim[ "car" ][ "car_idle_static" ]			= %coup_opening_car_driving_idle_static;

	//addNotetrack_customFunction( animname, notetrack, function, anime )
	addNotetrack_customFunction( "car", "idle_normal_start", ::car_normal, "coup_car_driving" );
	addNotetrack_customFunction( "car", "idle_smooth_start", ::car_smooth, "coup_car_driving" );
	addNotetrack_customFunction( "car", "idle_bumpy_start", ::car_bumpy, "coup_car_driving" );
	addNotetrack_customFunction( "car", "idle_static_start", ::car_static, "coup_car_driving" );
}

car_normal(car)
{
	car setanimknob(car getanim("car_idle_normal"), 1, 0, 1);
	car.playerview setanimknob(car.playerview getanim("playerview_idle_normal"), 1, 0, 1);
}

car_smooth(car)
{
	car setanimknob(car getanim("car_idle_smooth"), 1, 0, 1);
	car.playerview setanimknob(car.playerview getanim("playerview_idle_smooth"), 1, 0, 1);
}

car_bumpy(car)
{
	car setanimknob(car getanim("car_idle_bumpy"), 1, 0, 1);
	car.playerview setanimknob(car.playerview getanim("playerview_idle_bumpy"), 1, 0, 1);
}

car_static(car)
{
	car setanimknob(car getanim("car_idle_static"), 1, 0, 1);
	car.playerview setanimknob(car.playerview getanim("playerview_idle_static"), 1, 0, 1);
}

playerDeath(unused)
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 1;
	overlay.sort = 2;
}

playerHit(unused)
{
	level.coverwarnings = false;
	//wait 23.25;
	
	//thread playerBreathingSound(level.player.maxHealth * 0.35);
	//thread playerBreathingSound(100 * 0.35);
	thread playerBreathingSound(100 * 0.35, 25);
	
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ("overlay_low_health", 640, 480);
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;

	thread maps\_gameskill::healthOverlay_remove( overlay );
	
	//for (;;)
	//{
		overlay fadeOverTime(0.5);
		overlay.alpha = 0;
		//flag_wait("player_has_red_flashing_overlay");
		maps\_gameskill::redFlashingOverlay( overlay );
		//redFlashingOverlay(overlay);
	//}*/
}

playerHitDamage(unused)
{
	//wait 23.25;
	
	newHealth = level.player.health * 0.10;
    healthDiff = level.player.health - newHealth;

    damage = healthDiff / getdvarfloat( "player_damageMultiplier" );
	//iprintln( level.player.health );
    level.player doDamage( damage, level.player.origin );
	//iprintln( level.player.health );
}

playerBreathingSound(maxhealth, hurthealth)
{
	wait (2);
	for (;;)
	{
		wait (0.2);
		if (hurthealth <= 0)
			return;
			
		// Player still has a lot of health so no breathing sound
		ratio = hurthealth / maxhealth;
		if (ratio > level.healthOverlayCutoff)
			continue;
			
		level.player play_sound_on_entity("breathing_hurt");
		wait (0.1 + randomfloat (0.8));
	}
}