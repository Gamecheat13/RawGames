#include animscripts\Utility;
#include common_scripts\Utility;

#using_animtree( "generic_human" );


////////////////////////////////////////////
// Initialize anim sets
//
// anim.initAnimSet is used as a temporary buffer, because variables, including arrays, can't be passed by reference
// Set it up in each init_animset_* function and then store it in anim.animset.*
// This allows using helpers such as "set_animarray_stance_change" for different sets
////////////////////////////////////////////

init_anim_sets()
{
	if ( isDefined( anim.archetypes ) )
	{
		return;
	}

	anim.archetypes = [];
	anim.archetypes[ "soldier" ] = [];
	animscripts\cover_left::init_animset_cover_left();
	animscripts\cover_right::init_animset_cover_right();
	animscripts\cover_prone::init_animset_cover_prone();
	animscripts\cover_multi::init_animset_cover_multi();
	animscripts\cover_wall::init_animset_cover_wall();

	animscripts\reactions::init_animset_reactions();
	animscripts\pain::init_animset_pain();
	animscripts\death::init_animset_death();
	animscripts\combat::init_animset_combat();
	
	// move
	animscripts\move::init_animset_default_move();
	animscripts\move::init_animset_smg_move();
	
	animscripts\flashed::init_animset_flashed();
	animscripts\stop::init_animset_idle();
	animscripts\melee::init_animset_melee();

	anim.animsets = spawnstruct();
	anim.animsets.move = [];
	
	// combat stand
	init_animset_default_stand();
	init_animset_cqb_stand();
	init_animset_pistol_stand();
	init_animset_rpg_stand();
	init_animset_shotgun_stand();
	init_animset_heat_stand();
	init_animset_smg_stand();
	
	// combat crouch
	init_animset_default_crouch();
	init_animset_rpg_crouch();
	init_animset_shotgun_crouch();	
	init_animset_smg_crouch();
	
	// combat prone
	init_animset_default_prone();
	
	// move
	init_animset_run_move();
	init_animset_walk_move();
	init_animset_cqb_move();
	init_animset_heat_run_move();
	
	init_moving_turn_animations();
	init_exposed_turn_animations();
	init_animset_heat_reload();

	init_grenade_animations();
	init_animset_run_n_gun();
	init_animset_ambush();
	init_animset_smg_ambush();
	init_animset_smg_crouch_run();

	/#
	//PrintArchetype( "soldier" );
	#/
}

RegisterArchetype( name, anims, calc_splits )
{
	init_anim_sets(); // Make sure default archetype is fully setup before adding a new one

	assert (!isDefined( anim.archetypes[name] ));
	
	anim.archetypes[name] = anims;

	// Add flashed anim index
	if ( IsDefined( anims["flashed"] ) )
	{
		anim.flashAnimIndex[ name ] = 0;
	}

	// Resolve the transition animation data if necessary
	if ( IsDefined( calc_splits ) && calc_splits )
	{
		animscripts\init_move_transitions::GetSplitTimes( name );
	}

	// Make sure if idles exist that idle weights exist
	/#
	if ( IsDefined( anims["idle"] ) )
	{
		AssertEx( IsDefined( anims["idle_weights"] ), "idle animset defined without idle_weights in archetype" );
	}
	#/

	//PrintArchetype( name );
}

ArchetypeExists( name )
{
	return IsDefined( anim.archetypes[name] );
}

/#
PrintArchetype( name )
{
	assert( IsDefined( anim.archetypes[ name ] ) );
	archetype = anim.archetypes[ name ];
	foreach ( animset_name, animset in archetype )
	{
		println ( "" );
		println( "Animset:" + animset_name );
		foreach ( anim_name, animation in animset )
		{
			if ( IsArray( animation ) )
			{
				//println( "----#" + anim_name + " (Array)" );
				foreach ( array_index, array_anim in animation )
				{
					print( "   archetype[\"" + animset_name + "\"][\"" + anim_name + "\"][" + array_index + "] = %" );
					print( array_anim );
					print( "\n" );
					//println( "--------" + array_index + ": " + array_anim );
				}
			}
			else
			{
				print( "   archetype[\"" + animset_name + "\"][\"" + anim_name + "\"] = %" );
				print( animation );
				print( "\n" );
				//println( "----#" + anim_name + " (Array)" );
			}
		}
	}
}
#/

init_animset_run_move()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "sprint" ] = %sprint_loop_distant;
	anim.initAnimSet[ "sprint_short" ] = %sprint1_loop;
	anim.initAnimSet[ "prone" ] = %prone_crawl;

	anim.initAnimSet[ "straight" ] = %run_lowready_F;
	anim.initAnimSet[ "smg_straight" ] = %smg_run_lowready_F;
	
	anim.initAnimSet[ "move_f" ] = %walk_forward;
	anim.initAnimSet[ "move_l" ] = %walk_left;
	anim.initAnimSet[ "move_r" ] = %walk_right;
	anim.initAnimSet[ "move_b" ] = %walk_backward; //this looks too fast to be natural
	
	anim.initAnimSet[ "crouch" ] = %crouch_fastwalk_F;
	anim.initAnimSet[ "crouch_l" ] = %crouch_fastwalk_L;
	anim.initAnimSet[ "crouch_r" ] = %crouch_fastwalk_R;
	anim.initAnimSet[ "crouch_b" ] = %crouch_fastwalk_B;
	
	anim.initAnimSet[ "stairs_up" ] = %traverse_stair_run_01;
	anim.initAnimSet[ "stairs_down" ] = %traverse_stair_run_down;

	anim.initAnimSet[ "reload" ] = %run_lowready_reload;
	
	assert( !isdefined( anim.archetypes["soldier"]["run"] ) );
	anim.archetypes["soldier"]["run"] = anim.initAnimSet;	
}


init_animset_heat_run_move()
{
	assert( isdefined( anim.archetypes["soldier"]["run"] ) );
	anim.initAnimSet = anim.archetypes["soldier"]["run"];

	anim.initAnimSet[ "straight" ] = %heat_run_loop;
	
	assert( !isdefined( anim.archetypes["soldier"]["heat_run"] ) );
	anim.archetypes["soldier"]["heat_run"] = anim.initAnimSet;	
}


init_animset_walk_move()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "sprint" ] = %sprint_loop_distant;
	anim.initAnimSet[ "sprint_short" ] = %sprint1_loop;
	anim.initAnimSet[ "prone" ] = %prone_crawl;

	anim.initAnimSet[ "straight" ] = %walk_CQB_F;
	
	anim.initAnimSet[ "move_f" ] = %walk_CQB_F;
	anim.initAnimSet[ "move_l" ] = %walk_left;
	anim.initAnimSet[ "move_r" ] = %walk_right;
	anim.initAnimSet[ "move_b" ] = %walk_backward;
	
	anim.initAnimSet[ "crouch" ] = %crouch_fastwalk_F;
	anim.initAnimSet[ "crouch_l" ] = %crouch_fastwalk_L;
	anim.initAnimSet[ "crouch_r" ] = %crouch_fastwalk_R;
	anim.initAnimSet[ "crouch_b" ] = %crouch_fastwalk_B;	
	
	anim.initAnimSet[ "aim_2" ] = %walk_aim_2;
	anim.initAnimSet[ "aim_4" ] = %walk_aim_4;
	anim.initAnimSet[ "aim_6" ] = %walk_aim_6;
	anim.initAnimSet[ "aim_8" ] = %walk_aim_8;
	
	anim.initAnimSet[ "stairs_up" ] = %traverse_stair_run;
	anim.initAnimSet[ "stairs_down" ] = %traverse_stair_run_down_01;

	assert( !isdefined( anim.archetypes["soldier"]["walk"] ) );
	anim.archetypes["soldier"]["walk"] = anim.initAnimSet;	
}


init_animset_cqb_move()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "sprint" ] = %sprint_loop_distant;
	anim.initAnimSet[ "sprint_short" ] = %sprint1_loop;
	anim.initAnimSet[ "straight" ] = %run_CQB_F_search_v1;
	anim.initAnimSet[ "straight_v2" ] = %run_CQB_F_search_v2;
	
	anim.initAnimSet[ "move_f" ] = %walk_CQB_F;
	anim.initAnimSet[ "move_l" ] = %walk_left;
	anim.initAnimSet[ "move_r" ] = %walk_right;
	anim.initAnimSet[ "move_b" ] = %walk_backward;

	anim.initAnimSet[ "stairs_up" ] = %traverse_stair_run;
	anim.initAnimSet[ "stairs_down" ] = %traverse_stair_run_down_01;

	anim.initAnimSet[ "shotgun_pullout" ] = %shotgun_CQBrun_pullout;
	anim.initAnimSet[ "shotgun_putaway" ] = %shotgun_CQBrun_putaway;

	assert( !isdefined( anim.archetypes["soldier"]["cqb"] ) );
	anim.archetypes["soldier"]["cqb"] = anim.initAnimSet;	
}


init_animset_pistol_stand()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "add_aim_up" ] = %pistol_stand_aim_8_add;
	anim.initAnimSet[ "add_aim_down" ] = %pistol_stand_aim_2_add;
	anim.initAnimSet[ "add_aim_left" ] = %pistol_stand_aim_4_add;
	anim.initAnimSet[ "add_aim_right" ] = %pistol_stand_aim_6_add;
	anim.initAnimSet[ "straight_level" ] = %pistol_stand_aim_5;

	anim.initAnimSet[ "fire" ] = %pistol_stand_fire_A;
	anim.initAnimSet[ "single" ] = array( %pistol_stand_fire_A );

	anim.initAnimSet[ "reload" ] = array( %pistol_stand_reload_A );
	anim.initAnimSet[ "reload_crouchhide" ] = [];

	anim.initAnimSet[ "exposed_idle" ] = [ %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 ];

	set_animarray_standing_turns_pistol();

	anim.initAnimSet[ "add_turn_aim_up" ] = %pistol_stand_aim_8_alt;
	anim.initAnimSet[ "add_turn_aim_down" ] = %pistol_stand_aim_2_alt;
	anim.initAnimSet[ "add_turn_aim_left" ] = %pistol_stand_aim_4_alt;
	anim.initAnimSet[ "add_turn_aim_right" ] = %pistol_stand_aim_6_alt;
	
	assert( !isdefined( anim.archetypes["soldier"]["pistol_stand"] ) );
	anim.archetypes["soldier"]["pistol_stand"] = anim.initAnimSet;
}

init_animset_rpg_stand()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "add_aim_up" ] = %RPG_stand_aim_8;
	anim.initAnimSet[ "add_aim_down" ] = %RPG_stand_aim_2;
	anim.initAnimSet[ "add_aim_left" ] = %RPG_stand_aim_4;
	anim.initAnimSet[ "add_aim_right" ] = %RPG_stand_aim_6;
	anim.initAnimSet[ "straight_level" ] = %RPG_stand_aim_5;

	anim.initAnimSet[ "fire" ] = %RPG_stand_fire;
	anim.initAnimSet[ "single" ] = [ %exposed_shoot_semi1 ];

	anim.initAnimSet[ "reload" ] = [ %RPG_stand_reload ];
	anim.initAnimSet[ "reload_crouchhide" ] = [];

	anim.initAnimSet[ "exposed_idle" ] = [ %RPG_stand_idle ];

	set_animarray_stance_change();
	set_animarray_standing_turns();
	set_animarray_add_turn_aims_stand();
	
	assert( !isdefined( anim.archetypes["soldier"]["rpg_stand"] ) );
	anim.archetypes["soldier"]["rpg_stand"] = anim.initAnimSet;
}

init_animset_shotgun_stand()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "add_aim_up" ] = %shotgun_aim_8;
	anim.initAnimSet[ "add_aim_down" ] = %shotgun_aim_2;
	anim.initAnimSet[ "add_aim_left" ] = %shotgun_aim_4;
	anim.initAnimSet[ "add_aim_right" ] = %shotgun_aim_6;
	anim.initAnimSet[ "straight_level" ] = %shotgun_aim_5;
	
	anim.initAnimSet[ "fire" ] = %exposed_shoot_auto_v3;
	anim.initAnimSet[ "single" ] = [ %shotgun_stand_fire_1A, %shotgun_stand_fire_1B ];
	set_animarray_burst_and_semi_fire_stand();
	
	anim.initAnimSet[ "exposed_idle" ] = [ %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 ];

	anim.initAnimSet[ "reload" ] = [ %shotgun_stand_reload_A, %shotgun_stand_reload_B, %shotgun_stand_reload_C, %shotgun_stand_reload_C, %shotgun_stand_reload_C ];// ( C is standing, want it more often )
	anim.initAnimSet[ "reload_crouchhide" ] = [ %shotgun_stand_reload_A, %shotgun_stand_reload_B ];
	
	set_animarray_stance_change();
	set_animarray_standing_turns();
	set_animarray_add_turn_aims_stand();
	
	assert( !isdefined( anim.archetypes["soldier"]["shotgun_stand"] ) );
	anim.archetypes["soldier"]["shotgun_stand"] = anim.initAnimSet;
}

init_animset_smg_stand()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "add_aim_up" ] = %smg_exposed_aim_8;
	anim.initAnimSet[ "add_aim_down" ] = %smg_exposed_aim_2;
	anim.initAnimSet[ "add_aim_left" ] = %smg_exposed_aim_4;
	anim.initAnimSet[ "add_aim_right" ] = %smg_exposed_aim_6;

	anim.initAnimSet[ "straight_level" ] = %smg_exposed_aim_5;

	anim.initAnimSet[ "fire" ] = %smg_exposed_shoot_auto_v3;
	anim.initAnimSet[ "fire_corner" ] = %smg_exposed_shoot_auto_v2;
	anim.initAnimSet[ "single" ] = array( %smg_exposed_shoot_semi1 );
	set_animarray_burst_and_semi_fire_stand();

	anim.initAnimSet[ "exposed_idle" ] = array( %smg_exposed_idle_alert_v1, %smg_exposed_idle_alert_v2, %smg_exposed_idle_alert_v3 );
	anim.initAnimSet[ "exposed_grenade" ] = array( %smg_exposed_grenadeThrowB, %smg_exposed_grenadeThrowC );

	anim.initAnimSet[ "reload" ] = array( %smg_exposed_reload );
	anim.initAnimSet[ "reload_crouchhide" ] = array( %smg_exposed_reloadb );

	set_animarray_stance_change_smg();
	set_animarray_smg_standing_turns();
	set_animarray_add_smg_turn_aims_stand();
	
	assert( !isdefined( anim.archetypes["soldier"]["smg_stand"] ) );
	anim.archetypes["soldier"]["smg_stand"] = anim.initAnimSet;
}

init_animset_cqb_stand()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "add_aim_up" ] = %CQB_stand_aim8;
	anim.initAnimSet[ "add_aim_down" ] = %CQB_stand_aim2;
	anim.initAnimSet[ "add_aim_left" ] = %CQB_stand_aim4;
	anim.initAnimSet[ "add_aim_right" ] = %CQB_stand_aim6;

	anim.initAnimSet[ "straight_level" ] = %CQB_stand_aim5;

	anim.initAnimSet[ "fire" ] = %exposed_shoot_auto_v3;
	anim.initAnimSet[ "single" ] = [ %exposed_shoot_semi1 ];
	set_animarray_burst_and_semi_fire_stand();

	anim.initAnimSet[ "exposed_idle" ] = [ %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 ];

	anim.initAnimSet[ "reload" ] = [ %CQB_stand_reload_steady ];
	anim.initAnimSet[ "reload_crouchhide" ] = [ %CQB_stand_reload_knee ];
	
	set_animarray_stance_change();
	set_animarray_standing_turns();
	set_animarray_add_turn_aims_stand();
	
	assert( !isdefined( anim.archetypes["soldier"]["cqb_stand"] ) );
	anim.archetypes["soldier"]["cqb_stand"] = anim.initAnimSet;
}

init_animset_heat_stand()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "add_aim_up" ] = %heat_stand_aim_8;
	anim.initAnimSet[ "add_aim_down" ] = %heat_stand_aim_2;
	anim.initAnimSet[ "add_aim_left" ] = %heat_stand_aim_4;
	anim.initAnimSet[ "add_aim_right" ] = %heat_stand_aim_6;

	anim.initAnimSet[ "straight_level" ] = %heat_stand_aim_5;

	anim.initAnimSet[ "fire" ] = %heat_stand_fire_auto;
	anim.initAnimSet[ "single" ] = array( %heat_stand_fire_single );
	set_animarray_custom_burst_and_semi_fire_stand( %heat_stand_fire_burst );

	anim.initAnimSet[ "exposed_idle" ] = array( %heat_stand_idle, /*%heat_stand_twitchA, %heat_stand_twitchB, %heat_stand_twitchC,*/ %heat_stand_scanA, %heat_stand_scanB );
	//heat_stand_scanA
	//heat_stand_scanB
	
	anim.initAnimSet[ "reload" ] = array( %heat_exposed_reload );
	anim.initAnimSet[ "reload_crouchhide" ] = array();
	
	set_animarray_stance_change();

	anim.initAnimSet[ "turn_left_45" ] = %heat_stand_turn_L;
	anim.initAnimSet[ "turn_left_90" ] = %heat_stand_turn_L;
	anim.initAnimSet[ "turn_left_135" ] = %heat_stand_turn_180;
	anim.initAnimSet[ "turn_left_180" ] = %heat_stand_turn_180;
	anim.initAnimSet[ "turn_right_45" ] = %heat_stand_turn_R;
	anim.initAnimSet[ "turn_right_90" ] = %heat_stand_turn_R;
	anim.initAnimSet[ "turn_right_135" ] = %heat_stand_turn_180;
	anim.initAnimSet[ "turn_right_180" ] = %heat_stand_turn_180;

	set_animarray_add_turn_aims_stand();
	
	assert( !isdefined( anim.archetypes["soldier"]["heat_stand"] ) );
	anim.archetypes["soldier"]["heat_stand"] = anim.initAnimSet;
}

init_animset_heat_reload()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "reload_cover_left" ] = %heat_cover_reload_R;
	anim.initAnimSet[ "reload_cover_right" ] = %heat_cover_reload_L;
	anim.initAnimSet[ "reload_default" ] = %heat_cover_reload_L;

	assert( !isdefined( anim.archetypes["soldier"]["heat_reload"] ) );
	anim.archetypes["soldier"]["heat_reload"] = anim.initAnimSet;
}

init_animset_default_stand()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "add_aim_up" ] = %exposed_aim_8;
	anim.initAnimSet[ "add_aim_down" ] = %exposed_aim_2;
	anim.initAnimSet[ "add_aim_left" ] = %exposed_aim_4;
	anim.initAnimSet[ "add_aim_right" ] = %exposed_aim_6;

	anim.initAnimSet[ "straight_level" ] = %exposed_aim_5;

	anim.initAnimSet[ "fire" ] = %exposed_shoot_auto_v3;
	anim.initAnimSet[ "fire_corner" ] = %exposed_shoot_auto_v2;
	anim.initAnimSet[ "single" ] = array( %exposed_shoot_semi1 );
	set_animarray_burst_and_semi_fire_stand();

	anim.initAnimSet[ "exposed_idle" ] = array( %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 );
	anim.initAnimSet[ "exposed_grenade" ] = array( %exposed_grenadeThrowB, %exposed_grenadeThrowC );

	anim.initAnimSet[ "reload" ] = array( %exposed_reload );// %exposed_reloadb, %exposed_reloadc
	anim.initAnimSet[ "reload_crouchhide" ] = array( %exposed_reloadb );
	
	set_animarray_stance_change();
	set_animarray_standing_turns();
	set_animarray_add_turn_aims_stand();
	
	assert( !isdefined( anim.archetypes["soldier"]["default_stand"] ) );
	anim.archetypes["soldier"]["default_stand"] = anim.initAnimSet;
}


init_animset_default_crouch()
{
	anim.initAnimSet = [];
	set_animarray_crouch_aim();

	anim.initAnimSet[ "fire" ] = %exposed_crouch_shoot_auto_v2;
	anim.initAnimSet[ "single" ] = array( %exposed_crouch_shoot_semi1 );
	set_animarray_burst_and_semi_fire_crouch();

	anim.initAnimSet[ "reload" ] = array( %exposed_crouch_reload );
	anim.initAnimSet[ "exposed_idle" ] = array( %exposed_crouch_idle_alert_v1, %exposed_crouch_idle_alert_v2, %exposed_crouch_idle_alert_v3 );
	
	set_animarray_stance_change();
	set_animarray_crouching_turns();
	set_animarray_add_turn_aims_crouch();
	
	assert( !isdefined( anim.archetypes["soldier"]["default_crouch"] ) );
	anim.archetypes["soldier"]["default_crouch"] = anim.initAnimSet;
}	

init_animset_rpg_crouch()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "add_aim_up" ] = %RPG_crouch_aim_8;
	anim.initAnimSet[ "add_aim_down" ] = %RPG_crouch_aim_2;
	anim.initAnimSet[ "add_aim_left" ] = %RPG_crouch_aim_4;
	anim.initAnimSet[ "add_aim_right" ] = %RPG_crouch_aim_6;
	anim.initAnimSet[ "straight_level" ] = %RPG_crouch_aim_5;

	anim.initAnimSet[ "fire" ] = %RPG_crouch_fire;
	anim.initAnimSet[ "single" ] = [ %RPG_crouch_fire ];

	anim.initAnimSet[ "reload" ] = [ %RPG_crouch_reload ];

	anim.initAnimSet[ "exposed_idle" ] = [ %RPG_crouch_idle ];
	
	set_animarray_stance_change();
	set_animarray_crouching_turns();
	set_animarray_add_turn_aims_crouch();	
	
	assert( !isdefined( anim.archetypes["soldier"]["rpg_crouch"] ) );
	anim.archetypes["soldier"]["rpg_crouch"] = anim.initAnimSet;
}	


init_animset_shotgun_crouch()
{
	anim.initAnimSet = [];
	set_animarray_crouch_aim();

	anim.initAnimSet[ "fire" ] = %exposed_crouch_shoot_auto_v2;
	anim.initAnimSet[ "single" ] = [ %shotgun_crouch_fire ];
	set_animarray_burst_and_semi_fire_crouch();

	anim.initAnimSet[ "reload" ] = [ %shotgun_crouch_reload ];
	anim.initAnimSet[ "exposed_idle" ] = [ %exposed_crouch_idle_alert_v1, %exposed_crouch_idle_alert_v2, %exposed_crouch_idle_alert_v3 ];

	set_animarray_stance_change();
	set_animarray_crouching_turns();
	set_animarray_add_turn_aims_crouch();	
	
	assert( !isdefined( anim.archetypes["soldier"]["shotgun_crouch"] ) );
	anim.archetypes["soldier"]["shotgun_crouch"] = anim.initAnimSet;
}	


init_animset_smg_crouch()
{
	anim.initAnimSet = [];
	set_animarray_crouch_aim();

	anim.initAnimSet[ "fire" ] = %exposed_crouch_shoot_auto_v2;
	anim.initAnimSet[ "single" ] = array( %exposed_crouch_shoot_semi1 );
	set_animarray_burst_and_semi_fire_crouch();

	anim.initAnimSet[ "reload" ] = array( %exposed_crouch_reload );
	anim.initAnimSet[ "exposed_idle" ] = array( %exposed_crouch_idle_alert_v1, %exposed_crouch_idle_alert_v2, %exposed_crouch_idle_alert_v3 );
	
	set_animarray_stance_change_smg();
	set_animarray_crouching_turns();
	set_animarray_add_turn_aims_crouch();
	
	assert( !isdefined( anim.archetypes["soldier"]["smg_crouch"] ) );
	anim.archetypes["soldier"]["smg_crouch"] = anim.initAnimSet;
}	


init_animset_default_prone()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "add_aim_up" ] = %prone_aim_8_add;
	anim.initAnimSet[ "add_aim_down" ] = %prone_aim_2_add;
	anim.initAnimSet[ "add_aim_left" ] = %prone_aim_4_add;
	anim.initAnimSet[ "add_aim_right" ] = %prone_aim_6_add;

	anim.initAnimSet[ "straight_level" ] = %prone_aim_5;
	anim.initAnimSet[ "fire" ] = %prone_fire_1;

	anim.initAnimSet[ "single" ] = [ %prone_fire_1 ];
	anim.initAnimSet[ "reload" ] = [ %prone_reload ];

	anim.initAnimSet[ "burst2" ] = %prone_fire_burst;
	anim.initAnimSet[ "burst3" ] = %prone_fire_burst;
	anim.initAnimSet[ "burst4" ] = %prone_fire_burst;
	anim.initAnimSet[ "burst5" ] = %prone_fire_burst;
	anim.initAnimSet[ "burst6" ] = %prone_fire_burst;

	anim.initAnimSet[ "semi2" ] = %prone_fire_burst;
	anim.initAnimSet[ "semi3" ] = %prone_fire_burst;
	anim.initAnimSet[ "semi4" ] = %prone_fire_burst;
	anim.initAnimSet[ "semi5" ] = %prone_fire_burst;

	anim.initAnimSet[ "exposed_idle" ] = [ %exposed_crouch_idle_alert_v1, %exposed_crouch_idle_alert_v2, %exposed_crouch_idle_alert_v3 ];

	set_animarray_stance_change();

	assert( !isdefined( anim.archetypes["soldier"]["default_prone"] ) );
	anim.archetypes["soldier"]["default_prone"] = anim.initAnimSet;
}


init_animset_complete_custom_stand( completeSet )
{
	self.combatStandAnims = completeSet;
}

init_animset_custom_stand( fireAnim, aimStraight, idleAnim, reloadAnim )
{
	assert( isdefined( anim.archetypes ) );
	//assert( isdefined( anim.animsets ) && isdefined( anim.animsets.defaultStand ) );
	
	anim.initAnimSet = self lookupAnimArray( "default_stand" );

	if ( isdefined( aimStraight ) )
		anim.initAnimSet[ "straight_level" ] = aimStraight;
	
	if ( isdefined( fireAnim ) )
	{
		anim.initAnimSet[ "fire" ] = fireAnim;
		anim.initAnimSet[ "single" ] = array( fireAnim );
		set_animarray_custom_burst_and_semi_fire_stand( fireAnim );
	}

	if ( isdefined( idleAnim ) )
		anim.initAnimSet[ "exposed_idle" ] = array( idleAnim );

	if ( isdefined( reloadAnim ) )
	{
		anim.initAnimSet[ "reload" ] = array( reloadAnim );
		anim.initAnimSet[ "reload_crouchhide" ] = array( reloadAnim );
	}

	self.combatStandAnims = anim.initAnimSet;
}


init_animset_complete_custom_crouch( completeSet )
{
	self.combatCrouchAnims = completeSet;
}

init_animset_custom_crouch( fireAnim, idleAnim, reloadAnim )
{
	assert( isdefined( anim.archetypes ) );
	
	anim.initAnimSet = self lookupAnimArray( "default_crouch" );

	if ( isdefined( fireAnim ) )
	{
		anim.initAnimSet[ "fire" ] = fireAnim;
		anim.initAnimSet[ "single" ] = array( fireAnim );
		set_animarray_custom_burst_and_semi_fire_crouch( fireAnim );
	}

	if ( isdefined( idleAnim ) )
		anim.initAnimSet[ "exposed_idle" ] = array( idleAnim );

	if ( isdefined( reloadAnim ) )
		anim.initAnimSet[ "reload" ] = array( reloadAnim );

	self.combatCrouchAnims = anim.initAnimSet;
}	


clear_custom_animset()
{
	self.customMoveAnimSet = undefined;
	self.customIdleAnimSet = undefined;

	self.combatStandAnims = undefined;
	self.combatCrouchAnims = undefined;
}


////////////////////////////////////////////
// Helpers for the above init_*
////////////////////////////////////////////

set_animarray_standing_turns_pistol( animArray )
{
	anim.initAnimSet[ "turn_left_45" ] = %pistol_stand_turn45L;
	anim.initAnimSet[ "turn_left_90" ] = %pistol_stand_turn90L;
	anim.initAnimSet[ "turn_left_135" ] = %pistol_stand_turn90L;
	anim.initAnimSet[ "turn_left_180" ] = %pistol_stand_turn180L;
	anim.initAnimSet[ "turn_right_45" ] = %pistol_stand_turn45R;
	anim.initAnimSet[ "turn_right_90" ] = %pistol_stand_turn90R;
	anim.initAnimSet[ "turn_right_135" ] = %pistol_stand_turn90R;
	anim.initAnimSet[ "turn_right_180" ] = %pistol_stand_turn180L;
}

set_animarray_standing_turns()
{
	anim.initAnimSet[ "turn_left_45" ] = %exposed_tracking_turn45L;
	anim.initAnimSet[ "turn_left_90" ] = %exposed_tracking_turn90L;
	anim.initAnimSet[ "turn_left_135" ] = %exposed_tracking_turn135L;
	anim.initAnimSet[ "turn_left_180" ] = %exposed_tracking_turn180L;
	anim.initAnimSet[ "turn_right_45" ] = %exposed_tracking_turn45R;
	anim.initAnimSet[ "turn_right_90" ] = %exposed_tracking_turn90R;
	anim.initAnimSet[ "turn_right_135" ] = %exposed_tracking_turn135R;
	anim.initAnimSet[ "turn_right_180" ] = %exposed_tracking_turn180R;
}

set_animarray_smg_standing_turns()
{
	anim.initAnimSet[ "turn_left_45" ] = %smg_exposed_tracking_turn45L;
	anim.initAnimSet[ "turn_left_90" ] = %smg_exposed_tracking_turn90L;
	anim.initAnimSet[ "turn_left_135" ] = %smg_exposed_tracking_turn135L;
	anim.initAnimSet[ "turn_left_180" ] = %smg_exposed_tracking_turn180L;
	anim.initAnimSet[ "turn_right_45" ] = %smg_exposed_tracking_turn45R;
	anim.initAnimSet[ "turn_right_90" ] = %smg_exposed_tracking_turn90R;
	anim.initAnimSet[ "turn_right_135" ] = %smg_exposed_tracking_turn135R;
	anim.initAnimSet[ "turn_right_180" ] = %smg_exposed_tracking_turn180R;
}

set_animarray_crouching_turns()
{
	anim.initAnimSet[ "turn_left_45" ] = %exposed_crouch_turn_90_left;
	anim.initAnimSet[ "turn_left_90" ] = %exposed_crouch_turn_90_left;
	anim.initAnimSet[ "turn_left_135" ] = %exposed_crouch_turn_180_left;
	anim.initAnimSet[ "turn_left_180" ] = %exposed_crouch_turn_180_left;
	anim.initAnimSet[ "turn_right_45" ] = %exposed_crouch_turn_90_right;
	anim.initAnimSet[ "turn_right_90" ] = %exposed_crouch_turn_90_right;
	anim.initAnimSet[ "turn_right_135" ] = %exposed_crouch_turn_180_right;
	anim.initAnimSet[ "turn_right_180" ] = %exposed_crouch_turn_180_right;
}


set_animarray_stance_change()
{
	anim.initAnimSet[ "crouch_2_stand" ] = %exposed_crouch_2_stand;
	anim.initAnimSet[ "crouch_2_prone" ] = %crouch_2_prone;
	anim.initAnimSet[ "stand_2_crouch" ] = %exposed_stand_2_crouch;
	anim.initAnimSet[ "stand_2_prone" ] = %stand_2_prone;
	anim.initAnimSet[ "prone_2_crouch" ] = %prone_2_crouch;
	anim.initAnimSet[ "prone_2_stand" ] = %prone_2_stand;
}

set_animarray_stance_change_smg()
{
	anim.initAnimSet[ "crouch_2_stand" ] = %smg_exposed_crouch_2_stand;
	anim.initAnimSet[ "crouch_2_prone" ] = %crouch_2_prone;
	anim.initAnimSet[ "stand_2_crouch" ] = %smg_exposed_stand_2_crouch;
	anim.initAnimSet[ "stand_2_prone" ] = %stand_2_prone;
	anim.initAnimSet[ "prone_2_crouch" ] = %prone_2_crouch;
	anim.initAnimSet[ "prone_2_stand" ] = %prone_2_stand;
}

set_animarray_burst_and_semi_fire_stand()
{
	anim.initAnimSet[ "burst2" ] = %exposed_shoot_burst3;// ( will be stopped after second bullet )
	anim.initAnimSet[ "burst3" ] = %exposed_shoot_burst3;
	anim.initAnimSet[ "burst4" ] = %exposed_shoot_burst4;
	anim.initAnimSet[ "burst5" ] = %exposed_shoot_burst5;
	anim.initAnimSet[ "burst6" ] = %exposed_shoot_burst6;

	anim.initAnimSet[ "semi2" ] = %exposed_shoot_semi2;
	anim.initAnimSet[ "semi3" ] = %exposed_shoot_semi3;
	anim.initAnimSet[ "semi4" ] = %exposed_shoot_semi4;
	anim.initAnimSet[ "semi5" ] = %exposed_shoot_semi5;
}


set_animarray_custom_burst_and_semi_fire_stand( fireAnim )
{
	anim.initAnimSet[ "burst2" ] = fireAnim;
	anim.initAnimSet[ "burst3" ] = fireAnim;
	anim.initAnimSet[ "burst4" ] = fireAnim;
	anim.initAnimSet[ "burst5" ] = fireAnim;
	anim.initAnimSet[ "burst6" ] = fireAnim;

	anim.initAnimSet[ "semi2" ] = fireAnim;
	anim.initAnimSet[ "semi3" ] = fireAnim;
	anim.initAnimSet[ "semi4" ] = fireAnim;
	anim.initAnimSet[ "semi5" ] = fireAnim;
}


set_animarray_burst_and_semi_fire_crouch()
{
	anim.initAnimSet[ "burst2" ] = %exposed_crouch_shoot_burst3;
	anim.initAnimSet[ "burst3" ] = %exposed_crouch_shoot_burst3;
	anim.initAnimSet[ "burst4" ] = %exposed_crouch_shoot_burst4;
	anim.initAnimSet[ "burst5" ] = %exposed_crouch_shoot_burst5;
	anim.initAnimSet[ "burst6" ] = %exposed_crouch_shoot_burst6;

	anim.initAnimSet[ "semi2" ] = %exposed_crouch_shoot_semi2;
	anim.initAnimSet[ "semi3" ] = %exposed_crouch_shoot_semi3;
	anim.initAnimSet[ "semi4" ] = %exposed_crouch_shoot_semi4;
	anim.initAnimSet[ "semi5" ] = %exposed_crouch_shoot_semi5;
}


set_animarray_crouch_aim()
{
	anim.initAnimSet[ "add_aim_up" ] = %exposed_crouch_aim_8;
	anim.initAnimSet[ "add_aim_down" ] = %exposed_crouch_aim_2;
	anim.initAnimSet[ "add_aim_left" ] = %exposed_crouch_aim_4;
	anim.initAnimSet[ "add_aim_right" ] = %exposed_crouch_aim_6;
	anim.initAnimSet[ "straight_level" ] = %exposed_crouch_aim_5;
}


set_animarray_custom_burst_and_semi_fire_crouch( fireAnim )
{
	anim.initAnimSet[ "burst2" ] = fireAnim;
	anim.initAnimSet[ "burst3" ] = fireAnim;
	anim.initAnimSet[ "burst4" ] = fireAnim;
	anim.initAnimSet[ "burst5" ] = fireAnim;
	anim.initAnimSet[ "burst6" ] = fireAnim;

	anim.initAnimSet[ "semi2" ] = fireAnim;
	anim.initAnimSet[ "semi3" ] = fireAnim;
	anim.initAnimSet[ "semi4" ] = fireAnim;
	anim.initAnimSet[ "semi5" ] = fireAnim;
}


set_animarray_add_turn_aims_stand()
{
	anim.initAnimSet[ "add_turn_aim_up" ] = %exposed_turn_aim_8;
	anim.initAnimSet[ "add_turn_aim_down" ] = %exposed_turn_aim_2;
	anim.initAnimSet[ "add_turn_aim_left" ] = %exposed_turn_aim_4;
	anim.initAnimSet[ "add_turn_aim_right" ] = %exposed_turn_aim_6;
}

set_animarray_add_smg_turn_aims_stand()
{
	anim.initAnimSet[ "add_turn_aim_up" ] = %smg_exposed_turn_aim_8;
	anim.initAnimSet[ "add_turn_aim_down" ] = %smg_exposed_turn_aim_2;
	anim.initAnimSet[ "add_turn_aim_left" ] = %smg_exposed_turn_aim_4;
	anim.initAnimSet[ "add_turn_aim_right" ] = %smg_exposed_turn_aim_6;
}

set_animarray_add_turn_aims_crouch()
{
	anim.initAnimSet[ "add_turn_aim_up" ] = %exposed_crouch_turn_aim_8;
	anim.initAnimSet[ "add_turn_aim_down" ] = %exposed_crouch_turn_aim_2;
	anim.initAnimSet[ "add_turn_aim_left" ] = %exposed_crouch_turn_aim_4;
	anim.initAnimSet[ "add_turn_aim_right" ] = %exposed_crouch_turn_aim_6;
}


////////////////////////////////////////////
// Stand
////////////////////////////////////////////

set_animarray_standing()
{
	if ( usingSidearm() )
	{
		self.a.array = self lookupAnimArray( "pistol_stand" );
	}
	else if ( isdefined( self.combatStandAnims ) )
	{
		assert( isArray( self.combatStandAnims ) );
		self.a.array = self.combatStandAnims;
	}
	else if ( isdefined( self.heat ) )
	{
		self.a.array = self lookupAnimArray( "heat_stand" );
	}
	else if ( usingRocketLauncher() )
	{
		self.a.array = self lookupAnimArray( "rpg_stand" );
	}
	else if ( usingSMG() )
	{
		self.a.array = self lookupAnimArray( "smg_stand" );
	}
	else if ( isdefined( self.weapon ) && weapon_pump_action_shotgun() )
	{
		self.a.array = self lookupAnimArray( "shotgun_stand" );
	}
	else if ( self isCQBWalking() )
	{
		self.a.array = self lookupAnimArray( "cqb_stand" );
	}
	else
	{
		self.a.array = self lookupAnimArray( "default_stand" );
	}
}


////////////////////////////////////////////
// Crouch
////////////////////////////////////////////

set_animarray_crouching()
{
	if ( usingSidearm() )
		animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );
	
	if ( isdefined( self.combatCrouchAnims ) )
	{
		assert( isArray( self.combatCrouchAnims ) );
		self.a.array = self.combatCrouchAnims;
	}
	else if ( usingRocketLauncher() )
	{
		self.a.array = self lookupAnimArray( "rpg_crouch" );
	}
	else if ( usingSMG() )
	{
		self.a.array = self lookupAnimArray( "smg_crouch" );
	}
	else if ( isdefined( self.weapon ) && weapon_pump_action_shotgun() )
	{
		self.a.array = self lookupAnimArray( "shotgun_crouch" );
	}
	else
	{
		self.a.array = self lookupAnimArray( "default_crouch" );
	}
}



////////////////////////////////////////////
// Prone
////////////////////////////////////////////

set_animarray_prone()
{
	if ( usingSidearm() )
		animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );

	self.a.array = self lookupAnimArray( "default_prone" );
}


////////////////////////////////////////////
// Moving turn
////////////////////////////////////////////

init_moving_turn_animations()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ 0 ] = %run_turn_180;
	anim.initAnimSet[ 1 ] = %run_turn_L135;
	anim.initAnimSet[ 2 ] = %run_turn_L90;
	anim.initAnimSet[ 3 ] = %run_turn_L45;
	//anim.initAnimSet[ 4 ] = no turn.
	anim.initAnimSet[ 5 ] = %run_turn_R45;
	anim.initAnimSet[ 6 ] = %run_turn_R90;
	anim.initAnimSet[ 7 ] = %run_turn_R135;
	anim.initAnimSet[ 8 ] = %run_turn_180;
	assert( !isdefined( anim.archetypes["soldier"]["run_turn"] ) );
	anim.archetypes["soldier"]["run_turn"] = anim.initAnimSet;	

	anim.initAnimSet = [];
	anim.initAnimSet[ 0 ] = %smg_run_turn_180;
	anim.initAnimSet[ 1 ] = %smg_run_turn_L135;
	anim.initAnimSet[ 2 ] = %smg_run_turn_L90;
	anim.initAnimSet[ 3 ] = %smg_run_turn_L45;
	//anim.initAnimSet[ 4 ] = no turn.
	anim.initAnimSet[ 5 ] = %smg_run_turn_R45;
	anim.initAnimSet[ 6 ] = %smg_run_turn_R90;
	anim.initAnimSet[ 7 ] = %smg_run_turn_R135;
	anim.initAnimSet[ 8 ] = %smg_run_turn_180;
	assert( !isdefined( anim.archetypes["soldier"]["smg_run_turn"] ) );
	anim.archetypes["soldier"]["smg_run_turn"] = anim.initAnimSet;	

	anim.initAnimSet = [];
	anim.initAnimSet[ 0 ] = %CQB_walk_turn_2;
	anim.initAnimSet[ 1 ] = %CQB_walk_turn_1;
	anim.initAnimSet[ 2 ] = %CQB_walk_turn_4;
	anim.initAnimSet[ 3 ] = %CQB_walk_turn_7;
	//anim.initAnimSet[ 4 ] = no turn.
	anim.initAnimSet[ 5 ] = %CQB_walk_turn_9;
	anim.initAnimSet[ 6 ] = %CQB_walk_turn_6;
	anim.initAnimSet[ 7 ] = %CQB_walk_turn_3;
	anim.initAnimSet[ 8 ] = %CQB_walk_turn_2;

	assert( !isdefined( anim.archetypes["soldier"]["cqb_turn"] ) );
	anim.archetypes["soldier"]["cqb_turn"] = anim.initAnimSet;	
}

////////////////////////////////////////////
// Cover turn
////////////////////////////////////////////

init_exposed_turn_animations()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "turn_left_45" ] = %exposed_tracking_turn45L;
	anim.initAnimSet[ "turn_left_90" ] = %exposed_tracking_turn90L;
	anim.initAnimSet[ "turn_left_135" ] = %exposed_tracking_turn135L;
	anim.initAnimSet[ "turn_left_180" ] = %exposed_tracking_turn180L;
	anim.initAnimSet[ "turn_right_45" ] = %exposed_tracking_turn45R;
	anim.initAnimSet[ "turn_right_90" ] = %exposed_tracking_turn90R;
	anim.initAnimSet[ "turn_right_135" ] = %exposed_tracking_turn135R;
	anim.initAnimSet[ "turn_right_180" ] = %exposed_tracking_turn180R;

	assert( !isdefined( anim.archetypes["soldier"]["exposed_turn"] ) );
	anim.archetypes["soldier"]["exposed_turn"] = anim.initAnimSet;	

	anim.initAnimSet = [];
	anim.initAnimSet[ "turn_left_45" ] = %exposed_crouch_turn_90_left;
	anim.initAnimSet[ "turn_left_90" ] = %exposed_crouch_turn_90_left;
	anim.initAnimSet[ "turn_left_135" ] = %exposed_crouch_turn_180_left;
	anim.initAnimSet[ "turn_left_180" ] = %exposed_crouch_turn_180_left;
	anim.initAnimSet[ "turn_right_45" ] = %exposed_crouch_turn_90_right;
	anim.initAnimSet[ "turn_right_90" ] = %exposed_crouch_turn_90_right;
	anim.initAnimSet[ "turn_right_135" ] = %exposed_crouch_turn_180_right;
	anim.initAnimSet[ "turn_right_180" ] = %exposed_crouch_turn_180_right;

	assert( !isdefined( anim.archetypes["soldier"]["exposed_turn_crouch"] ) );
	anim.archetypes["soldier"]["exposed_turn_crouch"] = anim.initAnimSet;
}

////////////////////////////////////////////
// Grenade
////////////////////////////////////////////

init_grenade_animations()
{
	anim.initAnimSet = [];
	anim.initAnimSet["cower_squat"] = %exposed_squat_down_grenade_F;
	anim.initAnimSet["cower_squat_idle"] = %exposed_squat_idle_grenade_F;
	anim.initAnimSet["cower_dive_back"] = %exposed_dive_grenade_B;
	anim.initAnimSet["cower_dive_front"] = %exposed_dive_grenade_F;

	anim.initAnimSet["return_throw_short"] = [ %grenade_return_running_throw_forward, %grenade_return_standing_throw_forward_1 ];
	anim.initAnimSet["return_throw_long"] = [ %grenade_return_running_throw_forward, %grenade_return_standing_throw_overhand_forward ];
	anim.initAnimSet["return_throw_default"] = [ %grenade_return_standing_throw_overhand_forward ];

	anim.initAnimSet["return_throw_short_smg"] = [ %smg_grenade_return_running_throw_forward, %smg_grenade_return_standing_throw_forward_1 ];
	anim.initAnimSet["return_throw_long_smg"] = [ %smg_grenade_return_running_throw_forward, %smg_grenade_return_standing_throw_overhand_forward ];
	anim.initAnimSet["return_throw_default_smg"] = [ %smg_grenade_return_standing_throw_overhand_forward ];

	assert( !isdefined( anim.archetypes["soldier"]["grenade"] ) );
	anim.archetypes["soldier"]["grenade"] = anim.initAnimSet;
}

////////////////////////////////////////////
// Misc
////////////////////////////////////////////


MAX_RUN_N_GUN_ANGLE = 130;
RUN_N_GUN_TRANSITION_POINT = 60 / MAX_RUN_N_GUN_ANGLE;

init_animset_run_n_gun()
{
	anim.initAnimSet = [];
	anim.initAnimSet["F"] = %run_n_gun_F;
	anim.initAnimSet["L"] = %run_n_gun_L;
	anim.initAnimSet["R"] = %run_n_gun_R;
	anim.initAnimSet["LB"] = %run_n_gun_L_120;
	anim.initAnimSet["RB"] = %run_n_gun_R_120;

	anim.initAnimSet["move_back"] = %combatwalk_B;

	assert( !isdefined( anim.archetypes["soldier"]["run_n_gun"] ) );
	anim.archetypes["soldier"]["run_n_gun"] = anim.initAnimSet;	

}

setup_run_n_gun()
{
	self.maxRunNGunAngle = MAX_RUN_N_GUN_ANGLE;
	self.runNGunTransitionPoint = RUN_N_GUN_TRANSITION_POINT;
	self.runNGunIncrement = 0.3;
}

init_animset_ambush()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "move_l" ] = %combatwalk_L;
	anim.initAnimSet[ "move_r" ] = %combatwalk_R;
	anim.initAnimSet[ "move_b" ] = %combatwalk_B;

	assert( !isdefined( anim.archetypes["soldier"]["ambush"] ) );
	anim.archetypes["soldier"]["ambush"] = anim.initAnimSet;	
}

init_animset_smg_ambush()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "move_l" ] = %smg_combatwalk_L;
	anim.initAnimSet[ "move_r" ] = %smg_combatwalk_R;
	anim.initAnimSet[ "move_b" ] = %smg_combatwalk_B;

	assert( !isdefined( anim.archetypes["soldier"]["smg_ambush"] ) );
	anim.archetypes["soldier"]["smg_ambush"] = anim.initAnimSet;	
}


init_animset_smg_crouch_run()
{
	anim.initAnimSet = [];
	anim.initAnimSet[ "crouch" ] = %smg_crouch_fastwalk_F;
	anim.initAnimSet[ "crouch_l" ] = %smg_crouch_fastwalk_L;
	anim.initAnimSet[ "crouch_r" ] = %smg_crouch_fastwalk_R;
	anim.initAnimSet[ "crouch_b" ] = %smg_crouch_fastwalk_B;

	assert( !isdefined( anim.archetypes["soldier"]["smg_crouch_run"] ) );
	anim.archetypes["soldier"]["smg_crouch_run"] = anim.initAnimSet;	
}

set_ambush_sidestep_anims()
{
	assert( isdefined( self.a.moveAnimSet ) );
	
	animset_name = "ambush";
	if ( usingSMG() )
	{
		animset_name = "smg_ambush";
	}
	self.a.moveAnimSet[ "move_l" ] = self lookupAnim( animset_name, "move_l" );
	self.a.moveAnimSet[ "move_r" ] = self lookupAnim( animset_name, "move_r" );
	self.a.moveAnimSet[ "move_b" ] = self lookupAnim( animset_name, "move_b" );
}

heat_reload_anim()
{
	if ( self.weapon != self.primaryweapon )
		return animArrayPickRandom( "reload" );
		
	if ( isdefined( self.node ) )
	{
		if ( self nearClaimNodeAndAngle() )
		{
			coverReloadAnim = undefined;
			if ( self.node.type == "Cover Left" )
				coverReloadAnim = lookupAnim( "heat_reload", "reload_cover_left" );
			else if ( self.node.type == "Cover Right" )
				coverReloadAnim = lookupAnim( "heat_reload", "reload_cover_right" );
				
			if ( isdefined( coverReloadAnim ) )
			{
				//self mayMoveToPoint( reloadAnimPos );
				return coverReloadAnim;
			}
		}
	}
	
	return lookupAnim( "heat_reload", "reload_default" );
}