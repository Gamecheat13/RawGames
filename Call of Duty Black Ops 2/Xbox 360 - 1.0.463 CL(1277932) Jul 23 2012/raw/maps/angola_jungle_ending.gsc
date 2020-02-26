
#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\angola_2_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


//*****************************************************************************
//*****************************************************************************

skipto_jungle_ending()
{
	skipto_teleport_players( "player_skipto_jungle_ending" );

	level.ai_woods = init_hero( "woods" );
	level.ai_hudson = init_hero( "hudson" );

	maps\angola_jungle_Escape::je_setup_player_weapons();

	exploder( 200 );
}


//*****************************************************************************
//*****************************************************************************

init_flags()
{
	flag_init( "je_end_scene_started" );
	flag_init( "angola2_misssion_complete" );
}


//*****************************************************************************
//*****************************************************************************

main()
{
	level.player thread maps\createart\angola_art::jungle_escape();

	init_flags();

	level notify( "end_of_jungle_escape" );
	
	level thread angola_jungle_wave_spawning();

	// Objectives
	level thread angola_jungle_ending_objectives();

	//Shawn J - Sound
	SetDvar( "footstep_sounds_cutoff", 3000 );
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

angola_jungle_ending_objectives()
{
	wait( 0.25 );

	//************************************************************************
	// Once the 3rd battle is over, advance to the beach and the waiting Hind
	//************************************************************************
	
	set_objective( level.OBJ_HUDSON_MOVES_TO_BEACH_EVAC, level.ai_hudson, "follow" );

	wait( 7 );
	//IPrintLnBold( "Mason moving NOW, follow us to the Beach Evacuation Point" );
	level.ai_hudson thread say_dialog( "huds_we_gotta_get_out_of_0" );
	level.ai_hudson thread say_dialog( "huds_come_on_mason_0", 1.5 );

	// Used for Challenges
	level.player notify( "mission_finished" );

	autosave_by_name( "move_to_beach_evacuation" );

	level notify( "mason_protect_nag_end" );
	level thread nag_mason_to_get_to_the_beach();

	run_scene( "hudson_and_woods_jungle_escape_beach_evac" );
	level thread run_scene( "hudson_and_woods_jungle_escape_beach_collapse" );


	//************************************************************************
	// Wait for the Beach End Scene to playout
	// Waiting for the player to get into position
	//************************************************************************

	level.hudson_at_beach_evauation_point = true;

	flag_wait( "je_end_scene_started" );
	set_objective( level.OBJ_HUDSON_MOVES_TO_BEACH_EVAC, level.ai_hudson, "delete" );

	level notify( "mason_protect_nag_end" );

	wait( 0.1 );

	flag_wait( "angola2_misssion_complete" );
	
	nextmission();
}


//*****************************************************************************
//*****************************************************************************

nag_mason_to_get_to_the_beach()
{
	start_time = gettime();
	nag0 = 0;
	nag0_time = 8;			// 8

	nag1 = 0;
	nag1_time = 18;			// 18

	nag2 = 0;
	nag2_time = 32;			// 30

	reached_hudson_distance = (42.0) * 5.0;

	while( 1 )
	{
		time = gettime();

		dist = distance( level.player.origin, level.ai_woods.origin );
		if( dist <= reached_hudson_distance )
		{
			flag_set( "je_end_scene_started" );
			return;
		}

		dt = ( time - start_time ) / 1000;

		if( (nag0 == 0) && (dt >= nag0_time) )
		{
			level.ai_hudson say_dialog( "huds_come_on_mason_0" );	// Come on Mason
			level.ai_hudson say_dialog( "huds_follow_me_0" );		// Follow me.
			//IPrintLnBold( "MASON retreat, get to the evacuation point on the beach" );
			nag0 = 1;
		}
		
		if( (nag1 == 0) && (dt >= nag1_time) )
		{
			//IPrintLnBold( "MASON, you must get to the beach now" );
			level.ai_hudson say_dialog( "huds_mason_where_you_go_0" );		// Mason, where are going
			level.ai_hudson say_dialog( "huds_come_on_we_re_movin_0" );		// Come on, we’re moving!
			nag1 = 1;
		}

		if( (nag2 == 0) && (dt >= nag2_time) )
		{
			nag2 = 1;
			missionFailedWrapper( &"ANGOLA_2_MISSION_FAILED_LOST_CONTACT_WITH_HUDSON" );
			return;
		}

		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************

angola_jungle_wave_spawning()
{
	//**********************
	// Hind Beach Evacuation
	//**********************

	str_category = "jungle_beach_attack_guys";

	level thread je_trigger_hind_beach_evacuation( str_category );
}


//*****************************************************************************
//*****************************************************************************
// HIND BEACH END MISSION EVENT
//*****************************************************************************
//*****************************************************************************

je_trigger_hind_beach_evacuation( str_category )
{
	while( 1 )
	{
		if( IsDefined(level.hudson_at_beach_evauation_point) && (level.hudson_at_beach_evauation_point==true) )
		{
			break;
		}
		wait( 0.01 );
	}

	level clientnotify ( "heli_context_switch" ); //ensure heli audio context is exterior

	// Wait for the player to get to Hudsonand Woods on the beach
	flag_wait( "je_end_scene_started" );

	level.player magic_bullet_shield();
	level.player.ignoreme = true;

	enemy_spawn_time = 12.5;		// 9
	
	level thread enemy_run_from_forest_to_beach( enemy_spawn_time-1, str_category, 7 );	// 7
	level thread hind_fires_into_forest( undefined, enemy_spawn_time );							// undefined

	//*******************
	// Play the end Scene 
	//*******************

	str_end_scene = "hind_attack_end_scene";

	level thread run_scene( str_end_scene );
	
	// Creating and linking the pistol weapon
	wait( 0.1 );
	level.woods_weapon = spawn_model( "t6_wpn_pistol_browninghp_prop_view", level.ai_woods GetTagOrigin( "TAG_WEAPON_LEFT" ), level.ai_woods GetTagAngles( "TAG_WEAPON_LEFT" ) );
	level.woods_weapon LinkTo( level.ai_woods, "TAG_WEAPON_LEFT" );

	// Make Enemy shot by Woods invulnerable
	ai_enemy = getent( "hind_dummy_pilot_ai", "targetname" );
	ai_enemy.health = 666666;

	scene_wait( str_end_scene );
	
	level.woods_weapon delete();

	flag_set( "angola2_misssion_complete" );
}


//*****************************************************************************
//*****************************************************************************

hind_fires_into_forest( e_hind, delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	if( !IsDefined(e_hind) )
	{
		e_hind = getent( "hind_end_level", "targetname" );
	}

	level thread jungle_explosions();

	e_hind maps\_turret::fire_turret_for_time( 2, 0 );
	e_hind maps\_turret::fire_turret_for_time( 2, 1 );
	e_hind maps\_turret::fire_turret_for_time( 2, 2 );

	wait( 4 );

	e_hind maps\_turret::disable_turret( 0 ); 
	e_hind maps\_turret::disable_turret( 1 ); 
	e_hind maps\_turret::disable_turret( 2 ); 
}


//*****************************************************************************
//*****************************************************************************

jungle_explosions()
{
	// Debris effects
	exploder( 10000 );

	level thread tree_explosions();

	wait( 2.0 );

	radius_big = 300;			// 300
	radius_small = 200;			// 200
	minDamage = 100;			// 100
	maxDamage = 300;			// 300

	s_exp1 = getstruct( "je_end_explosion1", "targetname" );
	pos = s_exp1.origin;
	playfx( level._effect["def_explosion"], pos );
	radiusDamage( pos, radius_big, maxDamage, minDamage);

	wait( 1.5 );
	s_exp2 = getstruct( "je_end_explosion2", "targetname" );
	pos = s_exp2.origin;
	playfx( level._effect["def_explosion"], pos );
	radiusDamage( pos, radius_big, maxDamage, minDamage);

	wait( 1.25 );
	s_exp3 = getstruct( "je_end_explosion3", "targetname" );
	pos = s_exp3.origin;
	playfx( level._effect["def_explosion"], pos );
	radiusDamage( pos, radius_small, maxDamage, minDamage );
}


//*****************************************************************************
//*****************************************************************************

tree_explosions()
{
	wait( 1 );

	level notify( "fxanim_palm_grp01_start" );
	//IPrintLnBold( "TIMBER 1" );

	wait( 1.5 );
	
	level notify( "fxanim_palm_grp02_start" );
	//IPrintLnBold( "TIMBER 2" );
}


//*****************************************************************************
//*****************************************************************************

enemy_run_from_forest_to_beach( delay, str_category, alive_time )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	//IPrintLnBold( "Spawning Forest to Beach Attack" );

	a_spawners = getentarray( "ae_end_attack_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		a_ai = simple_spawn( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false, false );
	}

	for( i=0; i<a_ai.size; i++ )
	{
		e_ai = a_ai[ i ];
		e_ai.overrideactordamage = ::forest_enemy_damage_override_func;
	}

	wait( alive_time );

	cleanup_ents( str_category );

	cleanup_ents( "jungle_battle_3" );
}


forest_enemy_damage_override_func( eInflictor, e_attacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if ( !IsDefined( sMeansOfDeath ) || ( sMeansOfDeath == "MOD_UNKNOWN" ) )
	{
		return 0;
	}
	else
	{
		if ( !IsDefined(self.alreadyLaunched) )
		{
			self.alreadyLaunched = true;
			self StartRagdoll( true );
			
			v_launch = ( 0, 0, 100 );
			if( RandomInt( 100 ) < 40 )
			{
				v_launch += AnglesToForward( eInflictor.angles ) * 300;
			}
			self LaunchRagdoll( v_launch, "J_SpineUpper" );
		}
	}
	
	return iDamage;
}


