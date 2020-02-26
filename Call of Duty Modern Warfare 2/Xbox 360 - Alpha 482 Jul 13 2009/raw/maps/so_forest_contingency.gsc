#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_specialops;
#include maps\_hud_util;
#include maps\_stealth_utility;
#include maps\_stealth_shared_utilities;

CONST_regular_obj	= &"SO_FOREST_CONTINGENCY_OBJ_REGULAR";
CONST_hardened_obj	= &"SO_FOREST_CONTINGENCY_OBJ_HARDENED";
CONST_veteran_obj	= &"SO_FOREST_CONTINGENCY_OBJ_VETERAN";

main()
{
	// optimization
	setsaveddvar( "sm_sunShadowScale", 0.5 );
	setsaveddvar( "r_lightGridEnableTweaks", 1 );
	setsaveddvar( "r_lightGridIntensity", 1.5 );
	setsaveddvar( "r_lightGridContrast", 0 );
	
	// delete certain non special ops entities
	so_delete_all_by_type( ::type_vehicle );
	thread remove_dead_trees();
	
	default_start( ::start_so_forest );
	add_start( "so_forest", ::start_so_forest );
	
	flag_init( "forest_success" );
	flag_init( "escaped_trigger" );
	flag_init( "stop_stealth_music" );
	flag_init( "someone_became_alert" );
	flag_init( "so_forest_contingency_start" );
	
	// init stuff
	maps\contingency_precache::main();
	maps\createart\contingency_fog::main();
	maps\contingency_fx::main();
	maps\contingency_anim::main_anim();
	
	maps\_load::main();
	
	maps\_load::set_player_viewhand_model( "viewhands_player_arctic_wind" );
	thread maps\contingency_amb::main();
	maps\createart\contingency_art::main();
	
	maps\_idle::idle_main();
	maps\_idle_coffee::main();
	maps\_idle_smoke::main();
	maps\_idle_lean_smoke::main();
	maps\_idle_phone::main();
	maps\_idle_sleep::main();
	maps\_idle_sit_load_ak::main();
	
	animscripts\dog\dog_init::initDogAnimations();
	maps\_patrol_anims::main();

	// original contingency threat bias setup
	threat_bias_code();
	
	maps\_stealth::main();
	stealth_settings();
	thread maps\contingency::stealth_music_control();
	
	// no weapon reloading inform during coop since this is stealth
	level.so_override[ "skip_inform_reloading" ] 	= true;
	//level.so_override[ "inform_reloading" ]		= "some kind of radio voice informing weapon reload";
	
	foreach ( player in level.players )
	{
		player stealth_plugin_basic();
		player thread playerSnowFootsteps();
	}

	maps\_compass::setupMiniMap( "compass_map_contingency" );	
}

remove_dead_trees()
{
	dead_trees = getentarray( "destroyable_tree_base", "script_noteworthy" );
	foreach( dead_tree in dead_trees )
	{
		dead_parts = getentarray( dead_tree.target, "targetname" );
		if( isdefined( dead_parts ) )
			foreach( part in dead_parts ) part delete();
	}
}

so_setup_regular()
{
	level.challenge_objective 	= CONST_regular_obj;
	level.new_enemy_accuracy	= 2;
}

so_setup_hardened()
{
	level.challenge_objective 	= CONST_hardened_obj;
	level.new_enemy_accuracy 	= 2;
}

so_setup_veteran()
{
	level.challenge_objective 	= CONST_veteran_obj;
	level.new_enemy_accuracy	= 1.75;
}

so_forest_init()
{
	add_global_spawn_function( "axis", ::enemy_nerf );

	assert( isdefined( level.gameskill ) );
	switch( level.gameSkill )
	{
		case 0:								// Easy
		case 1:	so_setup_Regular();	break;	// Regular
		case 2:	so_setup_hardened();break;	// Hardened
		case 3:	so_setup_veteran();	break;	// Veteran
	}

	escape_trig = getent( "escaped_trigger", "script_noteworthy" );
	escape_obj_origin = getent( escape_trig.target, "targetname" ).origin;
	Objective_Add( 1, "current", level.challenge_objective, escape_obj_origin );
	
	thread enable_escape_warning();
	thread enable_escape_failure();
	thread enable_triggered_complete( "escaped_trigger", "forest_success" );
	thread fade_challenge_out( "forest_success" );
	thread enable_challenge_timer( "so_forest_contingency_start", "forest_success" );
}

enemy_nerf()
{
	self.baseaccuracy = level.new_enemy_accuracy;
}

start_so_forest()
{
	so_forest_init();
	
	// ----- modified original contingency functions -----
	maps\contingency::sight_ranges_foggy_woods();
	thread maps\contingency::dialog_russians_looking_for_you();
	thread woods_first_patrol_cqb();
	thread woods_second_dog_patrol();
	thread break_stealth();
	
	thread fade_challenge_in();
}

break_stealth()
{
	break_trig = getent( "break_stealth", "targetname" );
	break_trig waittill( "trigger" );
	disable_stealth_system();
}

// ==================================================================================
// ======================= modified functions from contingency ======================
// ==================================================================================

stealth_settings()
{
	stealth_set_default_stealth_function( "woods", ::stealth_woods );

	ai_event = [];
	ai_event[ "ai_eventDistNewEnemy" ] = [];
	ai_event[ "ai_eventDistNewEnemy" ][ "spotted" ]		 = 512;
	ai_event[ "ai_eventDistNewEnemy" ][ "hidden" ] 		 = 256;

	ai_event[ "ai_eventDistExplosion" ] = [];
	ai_event[ "ai_eventDistExplosion" ][ "spotted" ]	 = level.explosion_dist_sense;
	ai_event[ "ai_eventDistExplosion" ][ "hidden" ] 	 = level.explosion_dist_sense;

	ai_event[ "ai_eventDistDeath" ] = [];
	ai_event[ "ai_eventDistDeath" ][ "spotted" ] 		 = 512;
	ai_event[ "ai_eventDistDeath" ][ "hidden" ] 		 = 512; // used to be 256
	
	ai_event[ "ai_eventDistPain" ] = [];
	ai_event[ "ai_eventDistPain" ][ "spotted" ] 		 = 256;
	ai_event[ "ai_eventDistPain" ][ "hidden" ] 		 	 = 256; // used to be 256
	
	ai_event[ "ai_eventDistBullet" ] = [];
	ai_event[ "ai_eventDistBullet" ][ "spotted" ]		 = 96;
	ai_event[ "ai_eventDistBullet" ][ "hidden" ] 		 = 96;
	
	ai_event[ "ai_eventDistFootstep" ] = [];
	ai_event[ "ai_eventDistFootstep" ][ "spotted" ]		 = 300;
	ai_event[ "ai_eventDistFootstep" ][ "hidden" ] 		 = 300;

	ai_event[ "ai_eventDistFootstepWalk" ] = [];
	ai_event[ "ai_eventDistFootstepWalk" ][ "spotted" ]	 = 300;
	ai_event[ "ai_eventDistFootstepWalk" ][ "hidden" ] 	 = 300;

	ai_event[ "ai_eventDistFootstepSprint" ] = [];
	ai_event[ "ai_eventDistFootstepSprint" ][ "spotted" ]	 = 400;
	ai_event[ "ai_eventDistFootstepSprint" ][ "hidden" ] 	 = 400;

	stealth_ai_event_dist_custom( ai_event );
	
	rangesHidden = [];
	rangesHidden[ "prone" ]		= 800;
	rangesHidden[ "crouch" ]	= 1200;
	rangesHidden[ "stand" ]		= 1600;

	rangesSpotted = [];
	rangesSpotted[ "prone" ]	= 8192;
	rangesSpotted[ "crouch" ]	= 8192;
	rangesSpotted[ "stand" ]	= 8192;

	stealth_detect_ranges_set( rangesHidden, rangesSpotted );
	stealth_alert_level_duration( 0.5 );	
	stealth_ai_event_dist_custom( ai_event );

	array = [];
	array[ "sight_dist" ]	 = 400;
	array[ "detect_dist" ]	 = 200;
	stealth_corpse_ranges_custom( array );
}

threat_bias_code()
{
	createThreatBiasGroup( "bridge_guys" );
	createThreatBiasGroup( "truck_guys" );
	createThreatBiasGroup( "bridge_stealth_guys" );
	createThreatBiasGroup( "dogs" );
	createThreatBiasGroup( "price" );
	createThreatBiasGroup( "player" );
	createThreatBiasGroup( "end_patrol" );
	level.player setthreatbiasgroup( "player" );
	SetIgnoreMeGroup( "price", "dogs" );
	setthreatbias( "player", "bridge_stealth_guys", 1000 );
	setthreatbias( "player", "truck_guys", 1000 );
}

woods_second_dog_patrol()
{
	flag_wait( "dialog_woods_second_dog_patrol" );
	
	if( flag( "someone_became_alert" ) )
		return;

	end_patrol = getentarray( "end_patrol", "targetname" );
	foreach( guy in end_patrol )
	{
		if( isalive( guy ) )
			guy.threatbias = 10000;
	}
}

woods_first_patrol_cqb()
{
	flag_wait( "first_patrol_cqb" );
	first_patrol_cqb = getentarray( "first_patrol_cqb", "targetname" );
	foreach( guy in first_patrol_cqb )
		guy spawn_ai();	
}

stealth_woods()
{
	self stealth_plugin_basic();

	if ( isplayer( self ) )
		return;

	switch( self.team )
	{
		case "axis":
			if( self.type == "dog" )
			{
				self thread maps\contingency::dogs_have_small_fovs_when_stopped();
				self 		maps\contingency::set_threatbias_group( "dogs" );
			}
			else
			{
				self thread maps\contingency::attach_flashlight();
			}
			if( isdefined( self.script_noteworthy ) && ( self.script_noteworthy == "cqb_patrol" ) )
			{
				if( isdefined( self.script_patroller ) )
				{
					wait .05;
					self clear_run_anim();
				}
				self thread enable_cqbwalk();
				self.moveplaybackrate = .8;
			}
			self.pathrandompercent = 0;
			self stealth_plugin_threat();
			self stealth_pre_spotted_function_custom( ::woods_prespotted_func );

			threat_array[ "warning1" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning2;
			threat_array[ "attack" ] = ::small_goal_attack_behavior;//default
			self stealth_threat_behavior_custom( threat_array );
			
			self stealth_enable_seek_player_on_spotted();
			self stealth_plugin_corpse();
			self stealth_plugin_event_all();
			self.baseaccuracy = 2;
			self.fovcosine = .5;	
			self.fovcosinebusy = .1;
			
			self thread maps\contingency::monitor_someone_became_alert();
			self maps\contingency::init_cold_patrol_anims();
			
			break;

		case "allies":
			//use the bridge area settings!
	}
}

Small_Goal_Attack_Behavior()
{
	self.pathrandompercent = 200;
	self thread disable_cqbwalk();
	self thread maps\_stealth_shared_utilities::enemy_announce_spotted( self.origin );
	
	self.goalradius = 400;

	self endon( "death" );

	self ent_flag_set( "_stealth_override_goalpos" );

	while ( isdefined( self.enemy ) && self ent_flag( "_stealth_enabled" ) )
	{
		self setgoalpos( self.enemy.origin );

		wait 4;
	}
}

woods_prespotted_func()
{
	wait 5;//default is 2.25
}