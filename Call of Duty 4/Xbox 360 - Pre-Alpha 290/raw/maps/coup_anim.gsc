#include maps\_utility;
#include maps\_anim;

main()
{
	//precacheShader( "credits_titlescreen" );
	
	anim_generic_human();
	anim_player();
	anim_car();
	// anim_props();
	animated_model_setup();
}

#using_animtree( "player" );
anim_player()
{
	level.scr_animtree[ "playerview" ] 						 = #animtree;
	level.scr_model[ "playerview" ] 						 = "viewhands_player_usmc";
	level.scr_anim[ "playerview" ][ "coup_opening" ]		 = %coup_opening_playerview;
	level.scr_anim[ "playerview" ][ "car_idle" ][ 0 ]		 = %coup_opening_playerview_idle;
	level.scr_anim[ "playerview" ][ "car_idle_firstframe" ]	 = %coup_opening_playerview_idle;
	level.scr_anim[ "playerview" ][ "coup_ending" ]			 = %coup_ending_player;

	level.scr_anim[ "playerview" ][ "playerview_idle_normal" ]	 = %coup_opening_playerview_idle_normal;
	level.scr_anim[ "playerview" ][ "playerview_idle_smooth" ]	 = %coup_opening_playerview_idle_smooth;
	level.scr_anim[ "playerview" ][ "playerview_idle_bumpy" ]	 = %coup_opening_playerview_idle_bumpy;
	level.scr_anim[ "playerview" ][ "playerview_idle_static" ]	 = %coup_opening_playerview_idle_static;
	
	// addNotetrack_customFunction( animname, notetrack, function, anime )
	addNotetrack_customFunction( "playerview", "hit", ::playerHit, "coup_opening" );
}

#using_animtree( "generic_human" );
anim_generic_human()
{
	level.scr_animtree[ "intro_leftguard" ] 				 = #animtree;
	level.scr_anim[ "intro_leftguard" ][ "coup_opening" ]	 = %coup_opening_guyL;

	level.scr_animtree[ "intro_rightguard" ] 				 = #animtree;
	level.scr_anim[ "intro_rightguard" ][ "coup_opening" ]	 = %coup_opening_guyR;
	
	level.scr_animtree[ "car_driver" ] 						 = #animtree;
	level.scr_anim[ "car_driver" ][ "car_idle" ][ 0 ]		 = %luxurysedan_driver_idle;

	level.scr_animtree[ "car_shotgun" ] 					 = #animtree;
	level.scr_anim[ "car_shotgun" ][ "car_idle" ][ 0 ]		 = %luxurysedan_passenger_idle;

	level.scr_animtree[ "car_backseat" ] 					 = #animtree;
	level.scr_anim[ "car_backseat" ][ "car_idle" ][ 0 ]		 = %luxurysedan_rear_passenger_idle;
	
	level.scr_animtree[ "ending_leftguard" ] 				 = #animtree;
	level.scr_anim[ "ending_leftguard" ][ "coup_ending" ]	 = %coup_ending_guyL;

	level.scr_animtree[ "ending_rightguard" ] 				 = #animtree;
	level.scr_anim[ "ending_rightguard" ][ "coup_ending" ]	 = %coup_ending_guyR;

	level.scr_animtree[ "ending_alasad" ] 					 = #animtree;
	level.scr_anim[ "ending_alasad" ][ "coup_ending" ]		 = %coup_ending_alasad;

	level.scr_animtree[ "ending_zakhaev" ] 					 = #animtree;
	level.scr_anim[ "ending_zakhaev" ][ "coup_ending" ]		 = %coup_ending_zakhaev;

	// addNotetrack_attach / detach( animname, notetrack, model, tag, anime )
	addNotetrack_detach( "ending_zakhaev", "detach gun", "weapon_desert_eagle_silver_HR_promo", "tag_inhand", "coup_ending" );
	addNotetrack_attach( "ending_alasad", "attach gun", "weapon_desert_eagle_silver_HR_promo", "tag_inhand", "coup_ending" );
	
	// addNotetrack_customFunction( animname, notetrack, function, anime )
	addNotetrack_customFunction( "ending_alasad", "fire_gun", ::playerDeath, "coup_ending" );
}

#using_animtree( "vehicles" );
anim_car()
{
	level.scr_animtree[ "car" ] 							 = #animtree;
	level.scr_model[ "car" ] 								 = "vehicle_luxurysedan_viewmodel";

	level.scr_anim[ "car" ][ "coup_opening" ]				 = %coup_opening_car;
	level.scr_anim[ "car" ][ "coup_car_driving" ]			 = %coup_opening_car_driving;
	level.scr_anim[ "car" ][ "car_idle_normal" ]			 = %coup_opening_car_driving_idle_normal;
	level.scr_anim[ "car" ][ "car_idle_smooth" ]			 = %coup_opening_car_driving_idle_smooth;
	level.scr_anim[ "car" ][ "car_idle_bumpy" ]				 = %coup_opening_car_driving_idle_bumpy;
	level.scr_anim[ "car" ][ "car_idle_static" ]			 = %coup_opening_car_driving_idle_static;

	// addNotetrack_customFunction( animname, notetrack, function, anime )
	addNotetrack_customFunction( "car", "idle_normal_start", ::car_normal, "coup_car_driving" );
	addNotetrack_customFunction( "car", "idle_smooth_start", ::car_smooth, "coup_car_driving" );
	addNotetrack_customFunction( "car", "idle_bumpy_start", ::car_bumpy, "coup_car_driving" );
	addNotetrack_customFunction( "car", "idle_static_start", ::car_static, "coup_car_driving" );
}

#using_animtree( "animated_props" );
animated_model_setup()
{
	level.anim_prop_models[ "foliage_tree_palm_bushy_2" ][ "still" ] = %palmtree_bushy2_still;
	level.anim_prop_models[ "foliage_tree_palm_bushy_2" ][ "strong" ] = %palmtree_bushy2_sway;
	level.anim_prop_models[ "foliage_tree_palm_bushy_1" ][ "still" ] = %palmtree_bushy1_still;
	level.anim_prop_models[ "foliage_tree_palm_bushy_1" ][ "strong" ] = %palmtree_bushy1_sway;
	level.anim_prop_models[ "foliage_tree_palm_bushy_3" ][ "still" ] = %palmtree_bushy3_still;
	level.anim_prop_models[ "foliage_tree_palm_bushy_3" ][ "strong" ] = %palmtree_bushy3_sway;
	level.anim_prop_models[ "foliage_tree_palm_med_2" ][ "still" ] = %palmtree_med2_still;
	level.anim_prop_models[ "foliage_tree_palm_med_2" ][ "strong" ] = %palmtree_med2_sway;
	level.anim_prop_models[ "foliage_tree_palm_med_1" ][ "still" ] = %palmtree_med1_still;
	level.anim_prop_models[ "foliage_tree_palm_med_1" ][ "strong" ] = %palmtree_med1_sway;
	level.anim_prop_models[ "foliage_tree_palm_tall_1" ][ "still" ] = %palmtree_tall1_still;
	level.anim_prop_models[ "foliage_tree_palm_tall_1" ][ "strong" ] = %palmtree_tall1_sway;
	level.anim_prop_models[ "foliage_tree_palm_tall_3" ][ "still" ] = %palmtree_tall3_still;
	level.anim_prop_models[ "foliage_tree_palm_tall_3" ][ "strong" ] = %palmtree_tall3_sway;
	level.anim_prop_models[ "foliage_tree_palm_tall_2" ][ "still" ] = %palmtree_tall2_still;
	level.anim_prop_models[ "foliage_tree_palm_tall_2" ][ "strong" ] = %palmtree_tall2_sway;
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

playerDeath( unused )
{
	wait .05;

	VisionSetNaked( "coup_death", .5 );

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

	/*title = newHudElem();
	title.x = 0;
	title.y = 0;
	title setshader( "credits_titlescreen", 800, 400 );
	title.alignX = "center";
	title.alignY = "middle";
	title.horzAlign = "center";
	title.vertAlign = "middle";
	title.alpha = 0;
	title.sort = 4;*/

	//black fadeOverTime( 5 );
	black fadeOverTime( 3 );
	black.alpha = 1;

	//wait 5;
	wait 3;
	black destroy();
	
	//cinematic("title");
	cinematicingame("title");

	/*title fadeOverTime( 5 );
	title.alpha = 1;

	wait 8;
	title fadeOverTime( 4 );
	title.alpha = 0;*/
	
	wait 4;
	//missionSuccess( "zipline", false );
	changelevel("zipline", false);
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
	// } */ 
	
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
				thread blurView( 3, 2 );
				
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
		thread blurView( 2.5, 0.8 );
		
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
} */ 