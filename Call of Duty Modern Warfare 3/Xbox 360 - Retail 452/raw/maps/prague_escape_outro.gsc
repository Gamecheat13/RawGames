#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_escape_code;
#include maps\_shg_common;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_outro()
{
	move_player_to_start( "outro_player" );
	
	if ( !IsDefined( level.player ) )
	{
		level.player = GetEntArray( "player", "classname" )[ 0 ];
		level.player.animname = "player_rig";
	}
	setup_outro_anim();
	setup_hero_for_start( "price", "outro" );
	
	set_screen_fade_shader( "black" );
	set_screen_fade_timer( 0.1 );
	screen_fade_out();
	
	//hide hud
	maps\prague_escape_code::hide_player_hud();
		
	battlechatter_off();	
	
	maps\prague_escape_sniper::prague_escape_skippast_cleanup();
}

// Main Functions	/////////////////////////////////////////////////////////////////////////////////////
outro_main()
{
	level.cover_warnings_disabled = undefined;
	
	price_trust_anim();
}

init_outro_level_flags()
{
	flag_init( "begin_outro_anim" );
	flag_init( "price_gun_to_head_dialog_02" );
	flag_init( "price_gun_to_head_dialog_03" );	
}

setup_outro_anim()
{
	//in case a skipto is used
	if ( !IsDefined( level.price )  )
	{
		setup_hero_for_start( "price", "outro" );
	}	
	
	s_anim_align_soap_death = getstruct( "anim_align_soap_death", "targetname" );		
	
	level.m_player_rig = spawn_anim_model( "player_rig", level.player.origin );
	level.m_player_rig.angles = level.player GetPlayerAngles();
	level.m_player_rig DontCastShadows();

	level.a_anim_ents = [];
	level.a_anim_ents[0] = level.m_player_rig;
	level.a_anim_ents[1] = level.price;

	//Give Price the pistol
	level.price gun_remove();
	level.price forceUseWeapon( "deserteagle", "primary" );
			
	s_anim_align_soap_death anim_first_frame( level.a_anim_ents, "gun_to_head" );	
}

price_trust_anim()
{
	level thread fade_into_price();
	
	s_anim_align_soap_death = getstruct( "anim_align_soap_death", "targetname" );	
	
	flag_wait( "begin_outro_anim" );

	Objective_State_NoMessage( level.n_obj_escape, "done" );
	
	level thread intro_blur();

	e_cellar_stream_ent = GetEnt( "e_cellar_stream_ent", "targetname" );	
	e_cellar_stream_ent Delete();

	level	thread maps\_utility::set_ambient("prague_bar_cellar_int" );
		
	level.player PlayerLinkToDelta( level.m_player_rig, "tag_player", 0, 10, 10, 7, 7, true );	

	s_anim_align_soap_death anim_single( level.a_anim_ents, "gun_to_head" );
}

#using_animtree( "generic_human" );
fade_into_price()
{
	flag_set( "begin_outro_anim" );	
	
	if ( IsDefined( level.flashback_overlay ) )
	{
		level.flashback_overlay Destroy();
	}
	
	set_screen_fade_timer( 1 );
	screen_fade_in();
	
	n_gun_to_head = GetAnimLength( %ch_pragueb_16_1_gun_to_head_price );	
	wait( n_gun_to_head - 1 );
	
	set_screen_fade_timer( 0.8 );
	level thread screen_fade_out();
	
	nextmission();
}

price_gun_to_head_dialogue( guy )
{
	level.price dialogue_queue( "presc_pri_okyuri" ); 	// Okay, Yuri...
	flag_wait( "price_gun_to_head_dialog_02" );
	level.price dialogue_queue( "presc_pri_boughtyourself" );	// You've bought yourself some time...
	flag_wait( "price_gun_to_head_dialog_03" );
	level.price dialogue_queue( "presc_pri_watchingyou" ); // ...But I'm watching you.
}