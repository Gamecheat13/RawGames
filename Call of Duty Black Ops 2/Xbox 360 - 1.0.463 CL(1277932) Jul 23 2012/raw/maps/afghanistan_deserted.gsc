#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_vehicle;
#include maps\_dialog;

/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

init_flags()
{
	flag_init( "deserted_sequence" );
	flag_init( "start_deserted_first_fade_out" );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions	(you may have more than one skipto in this file)
-------------------------------------------------------------------------------------------*/

skipto_deserted()
{
	skipto_setup();
	
	skipto_teleport( "skipto_deserted_player" );
	
	level.woods = init_hero("woods");
	level.rebel_leader = init_hero("rebel_leader");
	level.hudson = init_hero("hudson");
	level.zhao = init_hero("zhao");
	
	level maps\afghanistan_anim::init_afghan_anims_part2();
	
	flag_wait( "afghanistan_gump_ending" );
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/
main()
{
	maps\createart\afghanistan_art::turn_down_fog();
	maps\createart\afghanistan_art::open_area();
	maps\createart\afghanistan_art::deserted();
	
	deserted_sequence();
}


deserted_sequence()
{
	level thread screen_fade_in( 11 );
	level thread run_scene("e6_s2_ontruck_trucks");	
	level thread run_scene("e6_s2_ontruck_1");
	level thread play_fx_anim_bush();
	
	exploder( 900 );
	
	wait 1; // Run the scene to make the sounds in the background of the black screen
	
	autosave_by_name( "deserted_start" );
	
	//C. Ayers - Slowly turning on sounds again
	clientnotify( "snp_desert" );
	
	level.player disableweapons();
	
	SetSunDirection( (-0.283548, -0.779041, 0.559193) );
	
	level thread run_scene("e6_s2_ontruck_trucks");
	level thread run_scene("e6_s2_ontruck_1");
		
	//level.player shellshock( "death", 14);
	
	wait 1; // Now play the real scene
	
	//level screen_fade_in( 5 );

	scene_wait( "e6_s2_ontruck_1" );
	
	level.player DoDamage(50, level.player.origin);
	
	Earthquake(0.5, 0.6, level.player.origin, 128);
	
	// after the scene make sure you unlink the riders
	level.rebel_leader Unlink();
	level.woods Unlink();
	level.zhao Unlink();
	level.hudson Unlink();
	
	muj_guard = GetEnt("m01_guard_ai", "targetname");
	muj_guard Unlink();
	
	level thread run_scene("e6_s2_offtruck");
	anim_length = GetAnimLength(%player::p_af_06_01_deserted_player_offtruck);
	
	//wait 1.5; // when the player is knocked off the truck
	//Earthquake(0.5, 0.6, level.player.origin, 128);
	
	//level.player DoDamage(50, level.player.origin);
	//level.player play_fx( "fx_afgh_sand_body_impact", level.player.origin, level.player.angles);
	
	//wait 4.5; // woods hits your
	//Earthquake(0.5, 0.6, level.player.origin, 128);
	
	//wait 0.3; 
	//level.woods play_fx( "fx_afgh_sand_body_impact", level.woods.origin, level.woods.angles);
	
	//wait 3.2;  // zhao hits the ground
	//Earthquake(0.5, 0.6, level.player.origin, 128);
	//level.zhao play_fx( "fx_afgh_sand_body_impact", level.zhao.origin, level.zhao.angles);
	
	//wait 0.8; // plays the dirt on the screen when the truck runs
	//level thread capture_screen_dirt();
	
	//wait 0.7; // hudson hits the dirt
	//level.hudson play_fx( "fx_afgh_sand_body_impact", level.hudson.origin, level.hudson.angles);
	
	//wait 5; // player flips over
	//Earthquake(0.25, 0.6, level.player.origin, 128);	
		
	//wait anim_length - 18.7;
	level waittill( "start_deserted_first_fade_out" );
	//scene_wait( "e6_s2_offtruck" );
	
	//level.player thread lerp_fov_overtime( 2, 120 );
	//level.player VisionSetNaked("infrared_snow", 2);
	level.player thread lerp_dof_over_time_pass_out( 2 );
	
	wait 0.25;//TODO - play with this timing
	level screen_fade_out(1);
	//run_scene_first_frame("e6_s2_deserted_single");
	level thread run_scene_first_frame("e6_s2_deserted_part3_extras");
//	
	SetSavedDvar( "r_skyTransition", 1 );
	
	exploder( 1000 );
	stop_exploder( 900 );
	
	wait 1;
	level.player VisionSetNaked("afghanistan_deserted_sunset", 8);
	level.player reset_dof();
	
	fade_time = .75;
	level clientnotify( "set_deserted_fog_banks" );
	level screen_fade_in( fade_time );
	
	level thread lerp_sun_color_over_time();
	LerpSunDirection( (-0.283548, -0.779041, 0.559193), (0.283548, 0.779041, 0.359193), 10 );
	
	wait fade_time;
	
	level notify("timelapse");
	
	wait 7.5;
	
	//level.player VisionSetNaked("infrared_snow", 2);
//	level.player thread lerp_dof_over_time_pass_out( 2 );
	wait 0.5;
	level notify("timelapse_end");
//	level screen_fade_out(1);
	stop_exploder( 1000 );
	exploder( 900 );
		
//	wait 1;
//	SetSunLight( 0.80, 0.55, 0.6 );
//	level thread run_scene("e6_s2_deserted_part1");
//	
//	wait 0.05; // gets rid of a anim jump
//	level.player VisionSetNaked("afghanistan_deserted_sunset", 0.05);
//	level.player reset_dof();
//	
//	level screen_fade_in(0.5);
//	
//	anim_length = GetAnimLength(%player::p_af_06_02_deserted_player_view01);
//	wait anim_length - 2;
//	
//	//level.player VisionSetNaked("infrared_snow", 2);
//	level.player thread lerp_dof_over_time_pass_out( 2 );
//	
//	wait 0.5;
//	
//	level screen_fade_out(1);
//	SetSunLight( 0.75, 0.50, 0.6 );
//	run_scene_first_frame("e6_s2_deserted_single");
//	
//	wait 1;
//	level thread run_scene("e6_s2_deserted_part2");
//	level.player VisionSetNaked("afghanistan_deserted_sunset", 0.05);
//	level.player reset_dof();
//	
//	
//	wait 0.1; // fixes an animation pop
//	level screen_fade_in(0.5);
//	
//	anim_length = GetAnimLength(%player::p_af_06_02_deserted_player_view02);
//	wait anim_length - 2;
//	
//	//level.player VisionSetNaked("infrared_snow", 1);
	level.player thread lerp_dof_over_time_pass_out( 2 );
//	
	wait 0.5;
	
	level screen_fade_out(1);
	//run_scene_first_frame("e6_s2_deserted_single");
	wait 1;
	
	SetSunLight( 0.70, 0.50, 0.6 );
	
	level thread run_scene("e6_s2_deserted_part3");
	level thread run_scene("e6_s2_deserted_part3_extras");
	wait 0.05;
	reznov = get_model_or_models_from_scene("e6_s2_deserted_part3", "reznov");
	reznov_tag_origin =  reznov GetTagOrigin("tag_weapon_left");
	reznov_tag_angles =  reznov GetTagAngles("tag_weapon_left");

	canteen = spawn_model("p_jun_gear_canteen", reznov_tag_origin, reznov_tag_angles);
	canteen LinkTo(reznov, "tag_weapon_left");
	
	level.player VisionSetNaked("afghanistan_deserted_sunset", 0.05);
	level.player reset_dof();
	
	level screen_fade_in(0.5);
		
	anim_length = GetAnimLength(%player::p_af_06_02_deserted_player_view03);
	wait anim_length - 2;

	level thread old_man_woods( "old_woods_3", false );
	level.player say_dialog("your_father_swore_002");
	
	level thread screen_fade_out( .25 );
	level.player say_dialog("if_it_was_him_he_003");
	//Eckert - Fading out audio
	level clientnotify ( "fade_out" );
	level.player notify( "mission_finished" );  // send out end mission notify for challenges
	
	level nextmission();
}

#define COLOR_TWEEN 200

lerp_sun_color_over_time()
{
	end_sun_color = [];
	end_sun_color[0] = 0.9; // red
	end_sun_color[1] = 0.6; // green
	end_sun_color[2] = 0.6; // blue
	
	current_sun_color = [];
	current_sun_color[0] = 0.992157;
	current_sun_color[1] = 0.956863;
	current_sun_color[2] = 0.839216;
	
		
	time = 10;
	
	lerp_sun_color = [];
	lerp_sun_color[0] = ( end_sun_color[0] - current_sun_color[0] ) / COLOR_TWEEN; // 400 is the amount of times 0.05 goes into 20
	lerp_sun_color[1] = ( end_sun_color[1] - current_sun_color[1] ) / COLOR_TWEEN;
	lerp_sun_color[2] = ( end_sun_color[2] - current_sun_color[2] ) / COLOR_TWEEN;
	
	
	while(time > 0 )
	{
		current_sun_color[0] += lerp_sun_color[0];
		current_sun_color[1] += lerp_sun_color[1];
		current_sun_color[2] += lerp_sun_color[2];
		
		SetSunLight( current_sun_color[0], current_sun_color[1], current_sun_color[2] );
		wait 0.05;
		time -= 0.05;
	}
}


// Vultures need to be put back into radiant if vultures are to be put back
#using_animtree( "critter" );
handle_vulture()
{
	self endon("deleted");
	self useanimtree(#animtree);
	
	while(1)
	{
		rand = RandomInt(100);
		
		self clearanim(%root, 0.0);
		
		if(rand < 70)
		{
			self setanim( %critter::a_vulture_idle, 1, 0, 1);
			anim_durration = getanimlength(%critter::a_vulture_idle);
		}
		else
		{
			self setanim( %critter::a_vulture_idle_twitch , 1, 0, 1);
			anim_durration = getanimlength(%critter::a_vulture_idle_twitch);
		}	
		wait anim_durration;
	}
}

/* ------------------------------------------------------------------------------------------
	SUPPORT functions
-------------------------------------------------------------------------------------------*/

// Everything else goes here

deserted_truck_kickup_dust( vh_truck )
{
	fx_kickup = GetFX( "truck_kickup_dust" );
	PlayFXOnTag( fx_kickup, vh_truck, "tag_origin" );
	level thread capture_screen_dirt();
}

deserted_truck_kickout_impact( e_guy )
{
	fx_impact = GetFX( "fx_afgh_sand_body_impact" );
	PlayFX( fx_impact, e_guy.origin );
}

deserted_truck_kickout_impact_player( e_guy )
{
	fx_impact = GetFX( "fx_afgh_sand_body_impact" );
	Earthquake(0.5, 0.6, level.player.origin, 128);
	
	level.player DoDamage(50, level.player.origin);	
	PlayFX( fx_impact, e_guy.origin );
}

deserted_flip_over( e_guy )
{
	Earthquake(0.25, 0.6, e_guy.origin, 128);	
}

deserted_start_fade_out( e_guy )
{
	level notify( "start_deserted_first_fade_out" );
}

//Screen dirt overlay for near misses 
capture_screen_dirt()
{
    hud_dirt = NewClientHudElem( level.player );
    
    hud_dirt SetShader( "fullscreen_dirt_bottom_b", 640, 480 );

    hud_dirt.horzAlign = "center";
    hud_dirt.vertAlign = "middle";
    hud_dirt.alignX = "center";
    hud_dirt.alignY = "middle";
    hud_dirt.foreground = true;
    hud_dirt.alpha = 0;
    hud_dirt FadeOverTime( 0.5 );
    hud_dirt.alpha = 1;
    
    wait 3;//temp time
    
    hud_dirt FadeOverTime( 2 );
    hud_dirt.alpha = 0;
    
    wait 2;
    
    hud_dirt Destroy();
}

play_fx_anim_bush()
{
	level thread run_scene("e6_s2_deserted_bush_normal");
	
	level waittill("timelapse");
	
	level end_scene("e6_s2_deserted_bush_normal");
	
	level run_scene("e6_s2_deserted_bush_ramp");
	level thread run_scene("e6_s2_deserted_bush_fast");
	
	level waittill("timelapse_end");
	wait 1;//This wait should match the fadeout time called after 'timelapse_end' is raised
	
	level thread run_scene("e6_s2_deserted_bush_normal");
}
