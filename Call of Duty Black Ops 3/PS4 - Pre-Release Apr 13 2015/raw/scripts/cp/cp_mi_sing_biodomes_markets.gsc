#using scripts\cp\_objectives;
//#using scripts\cp\_oed;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_squad_control;
#using scripts\cp\_cic_turret;
#using scripts\cp\_util;
#using scripts\cp\_skipto;
#using scripts\cp\_dialog;

    	   	                                                                                                                                                                                                                                                                                                                                                                                                                                               

#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\vehicle_shared;

#using scripts\cp\cp_mi_sing_biodomes;
#using scripts\cp\cp_mi_sing_biodomes_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

//#precache( "objective", "cp_level_biodomes_find_xiulan" );
#precache( "triggerstring", "CP_MI_SING_BIODOMES_FREE_PRISONER" );

function main()
{
	level thread lookat_trigger_setup();
	
	//turned off by default
	trig_markets1_shelf_hurt = GetEnt( "trig_markets1_shelf_hurt", "targetname" );
	trig_markets1_shelf_hurt TriggerEnable( false );
	
	a_markets1_hendricks_scenes_triggers = GetEntArray( "hendricks_markets1_scene_triggers", "script_noteworthy" );
	level thread array::thread_all( a_markets1_hendricks_scenes_triggers, &hendricks_market1_scenes_trigger );
	
	//handles triggers around the bound up guys
	a_bound_guy_triggers = GetEntArray( "bound_guy_triggers", "script_noteworthy" );
	level thread array::thread_all( a_bound_guy_triggers, &bound_guy_triggers );
	
	//animated headpop guys in Markets 2
	spawner::add_spawn_function_group( "headpop_guys", "script_noteworthy", &headpop_tracking );
	
	//strung up prisoners in Markets 2
	spawner::add_spawn_function_group( "bound_guys", "script_noteworthy", &bound_guy_tracking );
	
	//rpg guy in Markets 2, when he dies, his tower collapses also
	spawner::add_spawn_function_group( "markets2_rpg_tower", "script_noteworthy", &markets2_rpg_tower );
	
	//initial set of enemies in Markets 2 will stay in place until player gets close
	spawner::add_spawn_function_group( "markets2_ambush_guys", "script_noteworthy", &markets2_ambush_guys );
	
	//guys that run across bridge when you cross the arch
	spawner::add_spawn_function_group( "sp_markets2_bridge_retreat", "targetname", &markets2_bridge_retreaters );
	
	spawner::add_spawn_function_group( "markets2_robot_rushers", "script_noteworthy", &markets2_robot_rushers );
	
	//keeps track of active prisoners
	level.a_prisoner_ai = [];
	
	//enemies that are part of Markets 1 intro scene who grab weapons and/or run away
	spawner::add_spawn_function_group( "markets1_intro_guys", "script_noteworthy", &markets1_enemy_intro );
	
	//rocket guy who shoots ceiling in Markets 1
	spawner::add_spawn_function_group( "markets1_magic_rpg", "script_noteworthy", &markets1_magic_rpg );
	
	//enemies are set in radiant spawners to be ignored initially, have them go back into combat once scene finishes
	scene::add_scene_func( "cin_bio_03_01_market_vign_engage", &scene_markets1_enemy_done, "done" );
}

function scene_markets1_enemy_done( a_ents )
{
	foreach ( ent in a_ents )
	{
		if ( IsAI( ent ) && IsAlive( ent ) )
		{
			self.ignoreall = false;
			self.ignoreme = false;
		}
	}
}

//after "bullet time" cutscene, start of actual gameplay
function objective_markets_start_init( str_objective, b_starting )
{
	objectives::set( "cp_level_biodomes_cloud_mountain" );
	
	cp_mi_sing_biodomes_util::objective_message( "objective_markets_start_init" );
	
	if ( b_starting )
	{
		level flag::wait_till( "all_players_connected" );
		
		cp_mi_sing_biodomes_util::init_hendricks( str_objective );
				
		//make sure triggers from level_setup() are re-enabled if skipTo was used
		
		level notify( "end_igc" );
		level flag::set( "bullet_start" );
		level flag::set( "bullet_over" );
				
		GetEnt( "party_room_shutter" , "targetname" ) Delete();

		a_mdl_windows = GetEntArray( "party_room_window", "targetname" );
		foreach( mdl_window in a_mdl_windows )
		{
			mdl_window Delete();
		}
		
		level thread spawn_markets1_enemies();
		
		//will have looping intro animation at beginning of this area; play scene/trigger linked in radiant
		level thread scene::init( "cin_bio_03_01_market_vign_engage" );
		
		level thread cp_mi_sing_biodomes_util::group_triggers_enable( "igc_trigger_disable_group", true );
		level thread cp_mi_sing_biodomes_util::group_triggers_enable( "trigger_color_market", true );
		
		level notify( "igc_at_window" );
		
		foreach( player in level.players )
		{
			player thread cp_mi_sing_biodomes::squad_color_triggers();
			player thread cp_mi_sing_biodomes::squad_color_markets_start();
			player thread cp_mi_sing_biodomes::squad_color_markets_rpg();
			player thread cp_mi_sing_biodomes::squad_color_markets2();
		}
		
		wait 1; //slight delay for everything to enable before Hendricks uses color trigger
		
		level flag::wait_till( "first_player_spawned" );
		
		//get Hendricks into position
		trigger::use( "trig_hendricks_color_marketst1" );
	}
	
	level flag::set( "markets1_enemies_alert" );
	objectives::set( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_markets1" ) );
	
	trigger::wait_till( "trig_markets1_combat2" );
	
	//get active enemies on each side of markets and push them back midway
	level thread aigroup_retreat( "markets1_retreaters_left", "info_volume_markets1_left", 3, 5 );
	level thread aigroup_retreat( "markets1_retreaters_right", "info_volume_markets1_right", 3, 5 );
	
	//if player moves forward, catch any other enemies and have them fall back a bit
	trigger::wait_till( "trig_markets1_pushback" );
	
	//get any active enemies and push them back further
	level thread aigroup_retreat( "markets1_retreaters", "info_volume_markets1_rear", 3, 7 );
	level thread aigroup_retreat( "markets1_retreaters_left", "info_volume_markets1_rear", 2, 4 );
	level thread aigroup_retreat( "markets1_retreaters_right", "info_volume_markets1_rear", 1, 3 );
	level thread aigroup_retreat( "markets1_retreaters_last", "info_volume_markets1_rear", 5, 10 );
	
	trigger::wait_till( "trig_markets_rpg" );
	
	level skipto::objective_completed( "objective_markets_start" );
}

//self is one of the AI that spawns for the cin_bio_03_01_market_vign_engage scene, or grouped around the markets similar to that scene
function markets1_enemy_intro()
{
	self endon( "death" );
	
	//don't want robots or Hendricks attacking these guys initially.
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	self.goalradius = 4;
	
	self thread animation::play( "ai_patrol_54i_white_idle" );
	
	level flag::wait_till( "markets1_enemies_alert" );
	
	wait RandomFloatRange( 0.05, 0.25 ); //stagger animations
	
	self thread ai_random_reaction();
	
	//delay to keep every single person from reacting at the same time
	if ( level.skipto_point == "objective_markets_start" )
	{
		wait RandomFloatRange( 2, 5 );
	}
	else
	{
		wait RandomFloatRange( 3, 6 );
	}
	
	self ai::set_ignoreme( false );
	self.goalradius = 2048;
	
	//get them moving towards cover points with regular AI now
	if ( self IsInScriptedState() )
	{
		self StopAnimScripted();
	}
	
	//another delay before firing to make sure player has the upper hand. Shorter delay if starting from skipto
	if ( level.skipto_point == "objective_markets_start" )
	{
		wait RandomFloatRange( 1, 4 );
	}
	else
	{
		wait RandomFloatRange( 3, 6 );
	}
	
	self ai::set_ignoreall( false );
}

//self is an AI
function ai_random_reaction()
{
	self endon( "death" );
	
	n_reaction = RandomIntRange( 0, 6 );
	
	switch ( n_reaction )
	{
		case 0:
			self animation::play( "ai_patrol_54i_white_idle_react_left" );
			break;
		case 1:
			self animation::play( "ai_patrol_54i_white_idle_react_right" );
			break;
		case 2:
			self thread scene::play( "cin_gen_vign_confusion_01", self );
			break;
		case 3:
			self thread scene::play( "cin_gen_vign_confusion_02", self );
			break;
		case 4:
			self thread scene::play( "cin_gen_vign_confusion_03", self );
			break;
		case 5:
			self animation::play( "ai_patrol_54i_white_idle_react_right" );
			break;
		default:
			break;
	}
}

//self is an RPG guy who shoots an errant rocket after dying
function markets1_magic_rpg()
{
	self waittill ( "death" );
	
	weapon = GetWeapon( "smaw" );
	v_rocket_launch = self GetTagOrigin( "tag_weapon_right" );
	s_rocket_hit = struct::get( "markets1_magic_rpg_dest" , "targetname" );
		
	e_rocket = MagicBullet( weapon, v_rocket_launch, s_rocket_hit.origin );
	wait 0.5; //wait a moment to play explosion
	fx::play( "explosion_dome", s_rocket_hit.origin );
	Earthquake( 0.1, 1, s_rocket_hit.origin, 2000 );
	
	//TODO glass "rain" effect from dome will go here
}

function spawn_markets1_enemies()
{
	//notetrack is in hendricks stab animations, triggers when players about to exit out of the window
	level util::waittill_notify_or_timeout( "igc_at_window", 30 );
	
	//first turret in distance
	level.turret_markets1 = spawner::simple_spawn_single( "turret_markets1" );
	level.turret_markets1.ignoreall = true;
	level.turret_markets1.ignoreme = true;
	level.turret_markets1 thread turret_spawn_func();
	
	//these guys start off the battle from beginning of level
	spawn_manager::enable( "sm_markets1_combat0" );
	
	level thread vo_markets1();
	
	//this trigger enables sm_markets1_combat1 spawn manager, and sets the flag to keep markets1_enemy_intro() going
	trigger::use( "trig_markets1_combat1" );
	
	wait 2; //allow some time for enemies to spawn in, then have them start looking around and running away
	
	level flag::set( "markets1_enemies_alert" );
}

function vo_markets1()
{	
	//make sure hendricks is initialized after cutscene before this continues
	while ( !isdefined ( level.ai_hendricks ) )
	{
		wait 0.05;
	}
	
	level.ai_hendricks dialog::say( "hend_plan_b_into_comms_0" );//"Plan B. (into comms) Kane - initiate Secondary Protocol Echo Two."
	
	level.ai_hendricks dialog::say( "hend_you_finished_triangu_0", 2 ); //I hope you’ve located those Data Drives, Kane - We’re taking a lot of heat down here!
	
	level dialog::remote( "kane_got_em_data_drives_0" ); //Got ‘em - The server room in Cloud Mountain.
	
	level.ai_hendricks dialog::say( "hend_are_you_fucking_kidd_0" ); //"Right at the heart of their operations. (beat) How much you wanna bet that’s where Goh Xiulan’s heading?"
	
	level dialog::remote( "kane_ex_fil_on_marker_bi_0" ); //"Ex-fil on marker. Biodome Rooftop above Cloud Mountain. (beat) VTOL wings up on package confirmation."
	
	level.ai_hendricks dialog::say( "hend_copy_that_0" ); //Copy that.
    
	level flag::wait_till( "turret1" );
    
    level.ai_hendricks dialog::say( "hend_take_out_that_turret_1", 2 );//Take out that Turret!
}

//self is the trigger that tells hendricks to get into a given position in Markets 1
function hendricks_market1_scenes_trigger()
{
	//make sure trigger doesn't get activated during opening igc
	self TriggerEnable( false );
	level flag::wait_till( "bullet_over" );
	self TriggerEnable( true );
	
	//hendricks is apparently still in cutscene, so wait for him to be defined TODO update to be a flag or something
	while ( !isdefined( level.ai_hendricks ) )
	{
		wait 0.05;
	}
	
	while ( self IsTriggerEnabled() )
	{
		self trigger::wait_till();
		
		//only want Hendricks to follow the first player in these scenarios
		if ( self.who == level.players[0] )
		{			
			//trigger is targeting a cover node for Hendricks to go to and play and scene
			if ( IsString( self.target ) )
			{
				level.ai_hendricks thread hendricks_markets1_scenes( self.target );
			}
		
			//no longer need trigger
			self TriggerEnable( false );
		}
	}
	
}

//self is hendricks
function hendricks_markets1_scenes( str_node_name )
{
	switch ( str_node_name )
	{
		case "nd_hendricks_wok1": //left markets1 path
			ai_enemy_thrown = spawner::simple_spawn_single( "sp_hendricks_enemy_throw_1", &spawn_markets1_hero_moment_enemy );
			ai_enemy_hit = spawner::simple_spawn_single( "sp_hendricks_enemy_throw_2", &spawn_markets1_hero_moment_enemy );
			level scene::play( "cin_bio_03_01_market_vign_hendricksmoment_throw", array( self, ai_enemy_thrown, ai_enemy_hit ) );
			break;
		case "nd_hendricks_shelves": //right markets1 path
			ai_shelf_death = spawner::simple_spawn_single( "sp_markets1_shelfguy", &spawn_markets1_hero_moment_enemy );
			level scene::play( "cin_bio_03_01_market_vign_hendricksmoment_rush", array( self, ai_shelf_death ) );
			break;
		default:
			nd_hendricks = GetNode( str_node_name, "targetname" );
			
			if ( isdefined( nd_hendricks ) )
			{
				self ai::force_goal( nd_hendricks, 12, false, "goal", true, true );
			}
			break;			
	}
}

//self is an ai that spawns and runs to a spot ASAP where it can be killed by Hendricks
function spawn_markets1_hero_moment_enemy()
{
	self endon( "death" );
	
	self.goalradius = 8;
	self.ignoreme = true;
	
	nd_dest = GetNode( self.target, "targetname" );
	if ( isdefined( nd_dest ) )
	{
		self ai::force_goal( nd_dest, 12, false, "goal", false, true );
	}
}

function objective_markets_start_done( str_objective, b_starting, b_direct, player )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_markets_start_done" );
}


//RPG and Machine Gunner guy
//TODO dev skipTo functions are now completely skipped as opposed to just "not saved", 
//will need to restructure code so that this stuff runs in the full game, but isn't saved as an actual checkpoint.
function objective_markets_rpg_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_markets_rpg_init" );
	
	if ( b_starting )
	{
		level flag::wait_till( "all_players_connected" );
		
		cp_mi_sing_biodomes_util::init_hendricks( str_objective );
				
		level.turret_markets1 = spawner::simple_spawn_single( "turret_markets1" );
		
		level.turret_markets1 thread turret_spawn_func();
		
		GetEnt( "party_room_shutter" , "targetname" ) Delete();
		
		objectives::set( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_markets1" ) );
	}
	
	level.turret_markets1.ignoreall = false;
	level.turret_markets1.ignoreme = false;
	
	foreach( player in level.players )
	{
		player thread cp_mi_sing_biodomes::squad_color_markets_rpg();
		player thread cp_mi_sing_biodomes::squad_color_markets2();
	}
	
	//there's a lookat trigger and a regular trigger both named trig_markets_rpg. Disable both once either is triggered
	trigger::wait_till( "trig_markets_rpg" );
	
	spawn_manager::enable( "sm_markets_rpg_nest" );
	
	a_markets_rpg_triggers = GetEntArray( "trig_markets_rpg", "targetname" );
	foreach ( trigger in a_markets_rpg_triggers )
	{
		trigger Delete();
	}
	
	wait 0.5;
	
	//open the shutters in front of the rpg and turret
	level thread markets_shutters_open();
	
	//have robots automatically destroy turret if they're not under direct squad control
	level.players[0] thread squad_control::squad_assign_task_independent( "floor_collapse", 3 );
	level.turret_markets1 thread util::delay( 3, undefined, &squad_control::enable_keyline, 2 );
	
	trigger::wait_till( "trig_markets2_start" );
	level skipto::objective_completed( "objective_markets_rpg" );
}

//replaces the boarded window getting knocked down
function markets_shutters_open()
{
	turret_shutter_left = GetEnt( "market_turret_left", "targetname" );
	turret_shutter_right = GetEnt( "market_turret_right", "targetname" );
	turret_shutter_clip = GetEnt( "market_turret_clip", "targetname" );
	
	rpg_shutter_left = GetEnt( "market_rpg_left", "targetname" );
	rpg_shutter_right = GetEnt( "market_rpg_right", "targetname" );
	rpg_shutter_clip = GetEnt( "market_rpg_clip", "targetname" );
	
	//rotate left items
	turret_shutter_left RotateYaw( -120, 0.25 );
	rpg_shutter_left RotateYaw( -120, 0.25 );
	
	//rotate right items
	turret_shutter_right RotateYaw( 120, 0.25 );
	rpg_shutter_right RotateYaw( 120, 0.25 );
	
	level flag::set( "turret1" );
	
	turret_shutter_clip Delete();
	rpg_shutter_clip Delete();
}

function window_knockdown( str_model )
{
	e_markets_window = GetEnt( str_model, "targetname" );
	Assert( isdefined ( e_markets_window ), str_model+" boarded window doesn't exist" );
	
	s_window_dest = struct::get( e_markets_window.target, "targetname" );
	Assert( isdefined ( s_window_dest ), str_model+" boarded window needs to target a script_struct" );
	
	if ( isdefined ( e_markets_window ) && isdefined ( s_window_dest ) )
	{
		//effect needs to be rotated -90 degrees from the window's pivot to face forward
		fx_angle = e_markets_window.angles - ( 0, 90, 0 );
		
		e_markets_window fx::play( "dirt_impact", e_markets_window.origin, fx_angle, 4 );
		e_markets_window MoveTo( s_window_dest.origin, 0.5 );
		e_markets_window RotateTo( s_window_dest.angles , 0.5 );
	}
}


function objective_markets_rpg_done( str_objective, b_starting, b_direct, player )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_markets_rpg_done" );
	
	objectives::complete( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_markets1" ) );
}


//Latter half of combat in Markets
function objective_markets2_start_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_markets2_start_init" );
	
	objectives::set( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_markets2" ) );
	
	//make sure AI can get across the bridge initially
	e_bridge_collision = GetEnt( "turret_2_bridge_01_collision", "targetname" );
	e_bridge_collision ConnectPaths();
	
	level thread markets2_bridge_retract();
	
	if ( b_starting )
	{
		level flag::wait_till( "all_players_connected" );
		
		//will get rid of Markets 1 triggers when starting Markets 2 skipTo to prevent players activating things behind them
		array::delete_all( GetEntArray( "triggers_markets1", "script_noteworthy" ) );
		
		cp_mi_sing_biodomes_util::init_hendricks( str_objective );
				
		GetEnt( "party_room_shutter" , "targetname" ) Delete();
		
		//enable previous turret, but have it killed immediately to better represent state of the world
		level.turret_markets1 = spawner::simple_spawn_single( "turret_markets1" );
		level.turret_markets1 Kill();
		
		//window shutters were opened beforehand
		thread markets_shutters_open();
		
		trigger::wait_till( "trig_markets2_start" );		
	}
	
	foreach( player in level.players )
	{
		player thread cp_mi_sing_biodomes::squad_color_markets2();
	}
	
	spawn_markets2_enemies();
	
	//wait until we get into the warehouse to do some cleanup
	trigger::wait_till( "trig_warehouse_enemy_spawns" );
	
	//kill any active enemies in early markets areas
	cp_mi_sing_biodomes_util::kill_previous_spawns( "sm_markets1_combat0" );
	cp_mi_sing_biodomes_util::kill_previous_spawns( "sm_markets1_combat1" );
	cp_mi_sing_biodomes_util::kill_previous_spawns( "sm_markets1_combat2" );
	cp_mi_sing_biodomes_util::kill_previous_spawns( "sm_markets1_combat3" );
	cp_mi_sing_biodomes_util::kill_previous_spawns( "sm_markets_rpg_nest" );
	
	//kill the turrets too just in case
	if ( IsAlive( level.turret_markets1 ) )
	{
		level.turret_markets1 Kill();
	}
	
	if ( IsAlive( level.turret_markets2 ) )
	{
		level.turret_markets2 Kill();
	}
	
	level skipto::objective_completed( "objective_markets2_start" );
}

function spawn_markets2_enemies()
{	
	level thread vo_markets2();
	
	wait 2; //wait a couple seconds after passing checkpoint area to play this
	level thread scene::play( "cin_bio_04_01_market2_vign_pile" );
	level notify( "dead_body_pile_played" );
	
	trigger::wait_till( "trig_markets2_scene_headpop" );
	
	level thread scene::play( "cin_bio_04_01_market2_vign_explode" );
	
	//level notify is sent from headpop_tracking() function
	level util::waittill_notify_or_timeout( "headpop_played", 6 );
	
	level.ai_hendricks thread hendricks_pit_scene();
	
	//guys spawn in and run to target points, but won't shoot until player passes trigger
	spawn_manager::enable( "sm_markets2_combat0" );
	
	level.turret_markets2 = spawner::simple_spawn_single( "turret_markets2" );
	level.turret_markets2 thread turret_spawn_func();
	level.turret_markets2 thread markets2_turret_hint_fire();
	
	level flag::set( "turret2" );
	
	trigger::wait_till( "trig_markets2_combat2" );
		
	//just in case player gets there before Hendricks
	level.ai_hendricks notify( "player_in_pit" );
	level.ai_hendricks notify( "started_arch_scene" );
	
	//prisoners will have been enabled by the time player gets to pit
	level notify( "prisoners_enabled" );
	
	level.ai_hendricks thread hendricks_arch_scene();
	
	trigger::wait_till( "trig_markets2_combat2b" );
	
	//single enemy jumps down from arch
	spawner::simple_spawn_single( "sp_arch_thrown_off" );
	
	trigger::wait_till( "trig_markets2_turret_intro" );
	
	//have robots automatically destroy turret if they're not under direct squad control
	level.players[0] thread squad_control::squad_assign_task_independent( "tear_apart", 6 );
	
	level.ai_hendricks notify ( "player_past_arch" );
	
	//also have guys here retreat to front of warehouse if player gets ahead of them
	level thread aigroup_retreat( "markets2_retreaters", "info_volume_markets2_rear", 0, 2 );
}

//self is AI that spawns and waits in Markets 2 until player approaches
function markets2_ambush_guys()
{
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	
	//make sure AI don't peek out while in cover
	self ai::set_behavior_attribute( "coverIdleOnly", true );
	
	trigger::wait_till( "trig_markets2_combat2" );
	
	wait RandomFloatRange( 0, 0.5 );
	
	self ai::set_behavior_attribute( "coverIdleOnly", false );
	
	self ai::set_ignoreall( false );
	self ai::set_ignoreme( false );
}

//self is Hendricks
function hendricks_pit_scene()
{		
	self endon( "started_arch_scene" );
	
	wait 1.5; //allow a bit of time after heads explode before Hendricks runs ahead
	
	//update Hendricks' colors
	trigger::use( "trig_hendricks_color_markets2_pit" );
	
	//get into position for his freed prisoner scene.
	level thread scene::init( "cin_bio_04_03_market2_vign_free" );
}

//self is hendricks
function hendricks_arch_scene()
{
	self notify( "started_arch_scene" );
	
	//Have Hendricks free the first prisoner
	self thread dialog::say( "hend_get_outta_here_in_0" ); //"Get outta here. (in mandarin) Go! Run!"
	level thread scene::play( "cin_bio_04_03_market2_vign_free" );
	
	//wait until hendricks both frees the prisoner, and the player has moved forward
	self util::waittill_notify_or_timeout( "hendricks_prisoner_freed_done", 10 );
	
	//get Hendricks moving towards the top of the arch
	node_hendricks = GetNode( "node_hendricks_arch_throw", "targetname" );
	self thread ai::force_goal( node_hendricks, 12, true, "goal", true );
	
	//gets set on trigger in radiant
	level flag::wait_till( "hendricks_markets2_arch_throw" );
	
	//enemy will get thrown off arch by Hendricks in scene
	ai_arch_throw = spawner::simple_spawn_single( "sp_arch_thrown_off" );
	
	if ( IsAlive ( ai_arch_throw ) )
	{
		//tracks if we need to bail out of the hero moment scene due to enemy dying early
		ai_arch_throw thread stop_hendricks_throws( "markets2_hendricks_throw_arch" );
		
		//move them into spot to get thrown off
		ai_arch_throw ClearForcedGoal();
		node_arch_enemy = GetNode( "node_arch_enemy", "targetname" );
		ai_arch_throw thread ai::force_goal( node_arch_enemy, 12, true );
		
		//don't want robots or Hendricks to shoot him too early
		ai_arch_throw ai::set_ignoreme( true );
		
		ai_arch_throw util::waittill_notify_or_timeout( "goal", 4 );
		
		//wait for Hendricks to navigate into place and finish scene. stop_hendricks_throws() will stop this in case AI dies early
	
		//make sure enemy doesn't move
		ai_arch_throw.goalradius = 12;
		ai_arch_throw.goalheight = 12;
		
		level thread scene::play( "markets2_hendricks_throw_arch", "targetname", array( level.ai_hendricks, ai_arch_throw ) );
		
		//enemy will either die in the scene or from the player
		ai_arch_throw waittill( "death" );
		
		level notify( "enemy_thrown_off" );
	}
	
	//wait for player to move under arch, then move hendricks to wall run area (flag set in radiant)
	level flag::wait_till( "hendricks_markets2_wallrun" );
	
	//make sure Hendricks shoots on the way to wallrun
	self thread ai::set_behavior_attribute( "sprint", false );
	
	//get another AI in place for another Hendricks throw, this spawner has a node to target on spawn
	ai_balcony_throw = spawner::simple_spawn_single( "sp_hendricks_wallrun_fodder" );
	
	if( IsAlive( ai_balcony_throw ) )
	{
		ai_balcony_throw thread stop_hendricks_throws( "markets2_hendricks_throw_balcony" );
		
		//make sure enemy doesn't move and isn't shot
		ai_balcony_throw ai::set_ignoreme( true );
		
		//Hendricks runs into place and starts wallrun animation
		level scene::play( "cin_bio_04_03_market2_vign_wallrun" );
		
		//throw the other guy off if he's still alive
		if ( IsAlive ( ai_balcony_throw ) )
		{
			level thread scene::play( "markets2_hendricks_throw_balcony", "targetname", array( level.ai_hendricks, ai_balcony_throw ) );
			ai_balcony_throw waittill ( "death" );
			level notify( "enemy_thrown_off" );
		}
	}
	
	//hendricks runs to the window after all these hero moments are done
	nd_hendricks = GetNode( "nd_hendricks_window_after_wallrun", "targetname" );
	self ai::force_goal( nd_hendricks, 12, true, "goal", true );
	
	//make sure Hendricks is back in fighting mode
	self ClearForcedGoal();
	self ai::set_ignoreall( false );
	self ai::set_ignoreme( false );
}

//self is the AI that gets thrown by hendricks in a scene. end the scene if the AI is killed
function stop_hendricks_throws( str_scene_targetname )
{	
	level endon( "enemy_thrown_off" );
	
	self waittill( "death" );
	
	wait 0.5; //if enemy dies in scene, allow some time for the level endon to be hit, and then the scene can be played out normally instead of stopped
	
	level scene::stop( str_scene_targetname, "targetname" );
}

function vo_markets2()
{   
	level util::waittill_notify_or_timeout( "dead_body_pile_played", 5 );
	
	e_headpopper = GetEnt( "sp_civilian_headpop1_ai", "targetname" );
	if ( IsAlive( e_headpopper ) )
	{
		e_headpopper dialog::say( "sslv_help_us_help_us_0" ); //Help us! Save Us!
	}
	
	level.ai_hendricks thread dialog::say( "hend_shit_they_re_fitte_0" ); //"Shit.  They’re fitted with those damn proximity restraints. (beat) We’ve seen how this works out."
	
	trigger::wait_till( "trig_markets2_scene_headpop" );
	
	level.ai_hendricks thread dialog::say( "hend_don_t_move_stay_whe_0" ); //Don’t move! Stay where you are!
	
	//level notify is sent from headpop_tracking() function
	level util::waittill_notify_or_timeout( "headpop_played", 3 );
	
	trigger::wait_till( "trig_markets2_combat2" );
		
	level.ai_hendricks dialog::say( "hend_kane_i_know_these_0" ); //Kane - We can’t just leave them.
	
	level dialog::remote( "kane_data_drives_are_the_0" ); //Data Drives are the priority over Human casualty. Your call to release them, but we are not responsible for them.
	
	level.ai_hendricks dialog::say( "hend_when_are_we_ever_0" ); //I’ll take that as a yes.
	
    trigger::wait_till( "trig_markets2_combat3" );
    
    //check if any markets 2 robots are alive before saying dialog
    n_robots_alive = spawner::get_ai_group_sentient_count( "markets2_robots" );
    if ( n_robots_alive > 0 )
    {
    	level dialog::remote( "kane_heads_up_got_54i_r_0" );//Heads up - Got 54i Robot reinforcements inbound!
    }
}

//self is the civilian that gets its head popped
function headpop_tracking()
{
	self endon( "death" );
	
	self util::magic_bullet_shield();
	self ai::gun_remove();
	
	//don't play sound until player actually triggers the scene
	trigger::wait_till( "trig_markets2_scene_headpop" );
	
	self thread dialog::say( "AAAAAGGGHHH!!!" );
	
	wait 0.75; //slight delay after they start running to line up sound better
	
	//notetrack/notify is in animation
	self waittill( "head_pop" );
	
	//lets spawn_markets2_enemies() know to continue
	level notify( "headpop_played" );
	
	//slight camera shake for explosion
	Earthquake( 0.25, .5, self.origin, 600 );
	
	//if any players are close enough, have them take some minor damage
	foreach ( player in level.players )
	{
		distance = Distance2DSquared( player.origin, self.origin );
		if ( distance < 400 * 400 && self CanSee( player ) )
		{
			player dodamage( player.health * 0.1, self.origin );
		}
	}
	
	self util::stop_magic_bullet_shield();
}

//self refers to the use trigger around the bound up prisoner.
function bound_guy_triggers()
{	
	self SetCursorHint( "HINT_NOICON" );
	
	level flag::wait_till( "all_players_connected" );
	
	//setup icon for use trigger on prisoner
	v_offset = ( 0, 0, 0 );
	
	self.gobj_visuals = [];
	
	self.e_use_object = gameobjects::create_use_object( "allies" , self, self.gobj_visuals, v_offset , undefined );
	
	self.e_use_object gameobjects::set_visible_team( "any" );
	self.e_use_object gameobjects::set_use_hint_text( &"CP_MI_SING_BIODOMES_FREE_PRISONER" );
	self.e_use_object gameobjects::set_3d_icon( "friendly", "t7_hud_prompt_push_64" );	
	self.e_use_object thread gameobjects::hide_icon_distance_and_los( (1,1,1), 500, false );

	//Wait for player to activate initial trigger
	self trigger::wait_till();
	
	self.who thread cp_mi_sing_biodomes_util::player_interact_anim_generic();
	
	//find the prisoner (who is being animated via a scene) that's associated with this trigger
	foreach ( ai in level.a_prisoner_ai )
	{
		if ( isdefined( ai ) && ai IsTouching( self ) )
		{
			//stop the scene that this trigger is targeting
			level scene::stop( self.target, "targetname" );
			
			//sound on release
			self playsound ("evt_prisoner_release");
			
			//disable trigger after we're done with it
			self.e_use_object gameobjects::disable_object();
			self TriggerEnable( false );
			
			if ( IsAlive( ai ) )
			{
				//allow bound_guy_tracking thread to continue for this guy
				ai notify( "prisoner_freed" );
			}
			else
			{
				//otherwise, you're freeing a dead guy. flop down lifelessly
				if ( ai IsInScriptedState() )
				{
					ai StopAnimScripted();
				}
				
				ai StartRagdoll();
			}
			
			break;
		}
	}
}

//self is the trigger that has the prisoner inside of it
function disable_trigger_on_prisoner_death()
{
	self endon( "death" );
	
	level waittill( "prisoners_enabled" );
	
	while ( self IsTriggerEnabled() )
	{
		ai_in_trigger = undefined;
		
		//look through prisoner AI and see who's touching the trigger
		foreach ( ai in level.a_prisoner_ai )
		{
			if ( IsAlive( ai ) && ai IsTouching( self ) )
			{
				ai_in_trigger = ai;
				break;
			}
		}
		
		//if no one is touching trigger, or the one doing the touching is dead, trigger is no longer valid
		if ( !isdefined( ai_in_trigger ) || !IsAlive( ai_in_trigger ) )
		{
			self.e_use_object gameobjects::disable_object();
			self TriggerEnable( false );
		}
		
		wait 0.05;
	}
}

//self is a prisoner that gets spawned by the cin_bio_04_01_market2_vign_bound_civ01 or cin_bio_04_01_market2_vign_bound_civ02 scriptbundle
function bound_guy_tracking()
{
	self endon( "death" );
	
	//add to a global array whenever this prisoner is spawned in to track them more easily
	array::add( level.a_prisoner_ai, self );
	
	self waittill( "prisoner_freed" );
	
	self thread dialog::say( "Thank you!" );
	
	wait 1; //slight delay after temp dialogue, don't want to use estimated temp dialogue delay now
	
	//have the civilian run off to safety
	s_prisoner_dest = struct::get( "s_prisoner_dest", "targetname" );
	self SetGoal( s_prisoner_dest.origin, true );

	//deletes AI when player is far enough distance away and not looking at it
	self cp_mi_sing_biodomes_util::wait_to_delete( 700 );
}

//as player approaches turret, have it target in front of the player
function markets2_turret_hint_fire()
{
	self endon ( "death" );
	
	trigger::wait_till( "trig_markets2_turret_intro" );
	
	s_markets2_turret_target = struct::get( "s_markets2_turret_target", "targetname" );
	
	m_turret_target = util::spawn_model( "tag_origin", s_markets2_turret_target.origin, s_markets2_turret_target.angles );
	
	level.turret_markets2 turret::set_target( m_turret_target, (0, 0, 0), 0 );
	
	//have the turret laser sweep a bit
	m_turret_target MoveX( 40, 3 );
	m_turret_target MoveY( -200, 3 );
	
	m_turret_target waittill( "movedone" );
	
	level.turret_markets2 turret::clear_target( 0 );
}

//self is rpg guy that spawns in guard tower just before the warehouse
function markets2_rpg_tower()
{
	self waittill( "death" );
	
	//blow himself up
	weapon = GetWeapon( "smaw" );
	v_rocket_launch = self GetTagOrigin( "tag_weapon_right" );
		
	MagicBullet( weapon, v_rocket_launch, self.origin );
	Earthquake( 0.1, 1, self.origin, 2000 );
	
	//tower collapses also
	level scene::play( "p7_fxanim_cp_biodomes_guard_tower_01_bundle" );
}

//self is an AI
function markets2_bridge_retreaters()
{
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	
	nd_goal = GetNode( self.target, "targetname" );
	
	self ai::force_goal( nd_goal, 12, false, "goal", false, true );
	
	level notify( "markets2_retract_bridge" ); //tells markets2_bridge_retract() to continue once enemies get across
	
	self ai::set_ignoreall( false );
}

//self is a robot
function markets2_robot_rushers()
{
	self endon( "death" );
	
	self ai::set_behavior_attribute( "move_mode", "rusher" );
}

function markets2_bridge_retract()
{
	level endon( "markets2_end" );
	
	//turret_2_bridge_01 - piece closest to turret
	//turret_2_bridge_02 - piece closest to rock arch
	//turret_2_bridge_01_collision - invisible piece that is only needed for connecting/disconnecting paths
	
	level waittill( "markets2_retract_bridge" );
	
	//bridge pieces
	e_bridge_1 = GetEnt( "turret_2_bridge_01", "targetname" );
	e_bridge_2 = GetEnt( "turret_2_bridge_02", "targetname" );
	e_bridge_collision = GetEnt( "turret_2_bridge_01_collision", "targetname" );
	
	e_bridge_collision DisconnectPaths();
	e_bridge_collision Hide();
	
	//locations bridge pieces will move to
	s_dest_1 = struct::get( e_bridge_1.target, "targetname" );
	s_dest_2 = struct::get( e_bridge_2.target, "targetname" );
		
	e_bridge_1 MoveTo( s_dest_1.origin, 4 );
	e_bridge_2 MoveTo( s_dest_2.origin, 4 );
}

function objective_markets2_start_done( str_objective, b_starting, b_direct, player )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_markets2_start_done" );
	
	level notify( "markets2_end" );
	
	objectives::complete( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_markets2" ) );
}

function turret_spawn_func()
{
	self.b_keylined = false;
	self.b_targeted = false;
	
	if ( self.targetname == "turret_markets1_ai" )
	{
		self.script_noteworthy = "floor_collapse";
	}
	else
	{
		self.script_noteworthy = "tear_apart";
	}
		
	self waittill( "death" );
	
	if ( self === level.turret_markets1 )
	{
		level flag::set( "turret1_dead" );
		
		//get hendricks moving up ahead when turret is down
		nd_hendricks = GetNode( "cover_hendricks_headpopper", "targetname" );
		level.ai_hendricks SetGoal( nd_hendricks, true );
	}
	else
	{
		level flag::set( "turret2_dead" );
	}
}

function lookat_trigger_setup()
{
	level flag::wait_till( "all_players_connected" );
	
	a_lookat_triggers = GetEntArray( "trig_lookats_markets", "script_noteworthy" );
	array::thread_all( a_lookat_triggers, &lookat_trigger_tracking);
	
}

//self is the lookat trigger
//trigger is only enabled when player is within its defined radius
function lookat_trigger_tracking()
{
	self endon ( "death" );
	
	//self SetInvisibleToAll(); TODO doesn't seem to work on lookat trigger types?
	self TriggerEnable( false );
	
	while ( true )
	{
		foreach ( player in level.players )
		{
			distance = Distance2DSquared( player.origin, self.origin );
			
			if ( distance <= ( self.radius * self.radius ) )
			{
				//iPrintLnBold( "Within Lookat Trigger "+self.targetname+" "+self.radius+" unit radius!" );
				//self SetVisibleToPlayer( player ); TODO doesn't seem to work on lookat trigger types?
				self TriggerEnable ( true );
			}
			else
			{
				//self SetInvisibleToPlayer( player ); TODO doesn't seem to work on lookat trigger types?
				self TriggerEnable ( false );
			}
		}
		
		wait 0.05;
	}
}

//*****************
//Utility functions for Markets

//have an aigroup collectively set their goal to a given volume
function aigroup_retreat( str_aigroup, str_volume, n_delay_min = 0, n_delay_max = 0 )
{
	a_enemies = spawner::get_ai_group_ai( str_aigroup );
	
	//have all of them retreat to the goal volume set to the rear of markets 1
	if ( isdefined ( a_enemies ) )
	{
		a_enemies set_group_goal_volume( str_volume, n_delay_min, n_delay_max );
	}
}

//self is an array of AI or AI vehicles
//tells every AI in the array to retreat to the goal volume, specified by targetname
function set_group_goal_volume( str_volume, n_delay_min = 0, n_delay_max = 0 )
{
	volume = GetEnt( str_volume, "targetname" );
	Assert( isdefined ( volume ), "Goal volume "+str_volume+" is undefined" );
	
	if ( isdefined ( volume ) )
	{
		foreach ( ai in self )
		{
			if ( IsAlive( ai ) )
			{
				ai SetGoal( volume, true );
			}
			
			if ( n_delay_max > n_delay_min )
			{
				wait RandomFloatRange( n_delay_min, n_delay_max ); //keep everyone from responding all at once
			}
		}
	}
}
