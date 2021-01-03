#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\cp_mi_sing_biodomes_util;
#using scripts\cp\cp_mi_sing_biodomes;

#using scripts\shared\ai\robot_phalanx;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	           	              	           	                                                                                                                                                                                                                                                                                             

#using scripts\cp\_dialog;
#using scripts\cp\_load;
//#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_squad_control;
#using scripts\cp\_objectives;

    	   	                                                                                                                                                                                                                                                                                                                                                                                                                                               

#precache( "objective", "cp_level_biodomes_find_xiulan" );
#precache( "objective", "cp_level_biodomes_find_xiulan_waypoint" );

function warehouse_main()
{
	// Set these AI to stay within starting volume until they see a player
	spawner::add_spawn_function_group( "warehouse_left_waiting" , "script_noteworthy" , &wait_for_sight_to_engage );
	spawner::add_spawn_function_group( "robots_warehouse_crates" , "script_noteworthy" , &robots_crates_spawn );
	spawner::add_spawn_function_group( "warehouse_container_shooter" , "targetname" , &shoot_container );
	spawner::add_spawn_function_group( "wasps_warehouse", "script_noteworthy", &wasps_warehouse_spawn );
	                                  
	wait 0.5; //need to wait a brief bit of time to allow level.ai_hendricks to spawn and get defined so it doesn't SRE below
	
	level thread container_crash();
	level thread container_done();
	level thread warehouse_warlord_surprise();
	level thread wait_for_objective_complete();
	level thread back_door_shooters();
	level thread warehouse_phalanx();
	level thread warehouse_open_door_double_jump();
	level.ai_hendricks thread vo_warehouse_wasps();
	level.ai_hendricks thread hendricks_color_chains();
	level.ai_hendricks thread hendricks_hero_moment( "right" );
	level.ai_hendricks thread hendricks_hero_moment( "left" );
	
	cp_mi_sing_biodomes_util::enable_traversals( false, "warehouse_robot_exit_traversal", "targetname" );
	
	trigger::wait_till( "trig_back_door_close" ); 
	
	back_door_close();
}

function precache()
{
	// DO ALL PRECACHING HERE
}

//Warehouse

function objective_warehouse_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_warehouse_init" );
	
	objectives::set( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_warehouse" ) );
	
	level thread warehouse_main();
	
	if ( b_starting )
	{
		cp_mi_sing_biodomes_util::init_hendricks( str_objective );
		
		wait 0.5; //slight delay before Hendricks is told to use initial color trigger
		
		trigger::use( "trig_markets2_colors_end" );
		
		//will get rid of Markets 1 & 2 triggers when starting Warehouse skipTo to prevent players activating things behind them
		array::delete_all( GetEntArray( "triggers_markets1", "script_noteworthy" ) );
		array::delete_all( GetEntArray( "triggers_markets2", "script_noteworthy" ) );
	}
	else
	{
		//only play this if we're progressing naturally from markets 2 to warehouse
		level thread vo_warehouse_intro();		
	}
}

function vo_warehouse_intro()
{
	//"Loyal Immortals. This is your mother, Goh Xiulan. Agents of the Winslow Accord have invaded our  home and slain your Father, my Brother, Goh Min. (beat)
	//They must be punished for their crimes.  Whoever brings me their heads will be rewarded."
	level dialog::remote( "xiul_loyal_immortals_thi_0" );
	
	level.ai_hendricks dialog::say( "hend_that_bitch_really_is_0" ); //That bitch really isn’t too happy with us.
	
	level dialog::player_say( "plyr_you_shot_her_brother_0" ); //You shot her brother.
	
	level.ai_hendricks dialog::say( "hend_i_should_have_shot_h_0" ); //I should have shot her.
}

function objective_warehouse_done( str_objective, b_starting, b_direct, player )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_warehouse_done" );
	
	objectives::complete( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_warehouse" ) );
	
	objectives::complete( "cp_level_biodomes_cloud_mountain" );
}

//skip to the door opening scene to test out animation and fx
function dev_warehouse_door_init( str_objective, b_starting )
{
	level thread dev_warehouse_door_func( str_objective, 2 );
}

function dev_warehouse_door_without_robots_init( str_objective, b_starting )
{
	level thread dev_warehouse_door_func( str_objective, 1 );
}

function dev_warehouse_door_func( str_objective, n_squad )
{
	cp_mi_sing_biodomes_util::init_hendricks( str_objective );
	level.players[0] cp_mi_sing_biodomes::init_squad_robots( str_objective, n_squad );
	level.players[0] thread cp_mi_sing_biodomes::squad_hud();
	
	level flag::wait_till( "first_player_spawned" );
	
	wait 2; //allow a bit of time to get bearings before spawning warlord
	
	//have a simplified warlord spawn in to test his entrance here as well
	spawner::simple_spawn( "warehouse_enemy_warlord" , &warehouse_warlord_dev );
	level flag::set( "warehouse_warlord" );
	
	level thread clientfield::set( "warehouse_window_break", 1 );
	
	GetEnt( "warehouse_overwatch_window" , "targetname" ) Delete();
	
	s_container = struct::get( "warehouse_surprise" );
	Earthquake( .25, .5, s_container.origin, 1200 );
	
	cp_mi_sing_biodomes_util::enable_traversals( false, "warehouse_robot_exit_traversal", "targetname" );
	back_door_close();
}

function warehouse_warlord_dev()
{
	self endon( "death" );
	
	self.health = 100;
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	
	wait 1;					//make ai pause just a moment before opening fire
	
	self.ignoreall = false;
	self.ignoreme = false;
}

//self is Hendricks
function vo_warehouse_wasps()
{
	//flag set in radiant triggers
	level flag::wait_till( "warehouse_wasps" );
	
	
}

//self are the robots that spawn on top near the crates that get knocked over
function robots_crates_spawn()
{
	self endon( "death" );
	
	nd_start = GetNode( self.target, "targetname" );
	if ( isdefined( nd_start ) )
	{
		self thread ai::force_goal( nd_start, 36, true, "goal", true, true );
	}
	
	self thread robot_jump_landing_exploder();
}

//self is a robot that jumps down from the crates
//only need to play exploder once on each robot
function robot_jump_landing_exploder()
{
	self endon( "death" );
	self endon( "crate_jump_landed" );

	t_exploders = GetEntArray( "trig_robot_jump_landing", "script_noteworthy" );
	
	while ( true )
	{
		foreach ( trigger in t_exploders )
		{
			if ( self IsTouching( trigger ) )
			{
				if ( trigger.targetname === "trig_warehouse_robot_landing_left" )
				{
					exploder::exploder( "fx_warehouse_robot_jmp_dust_l" );
				}
				else if ( trigger.targetname === "trig_warehouse_robot_landing_right" )
				{
					exploder::exploder( "fx_warehouse_robot_jmp_dust_r" );
				}
				
				self notify( "crate_jump_landed" );
			}
		}
		
		wait 0.05;
	}
}

//after container falls, bring in robot phalanx ambush from each side of the warehouse
function warehouse_phalanx()
{
	level flag::wait_till( "container_drop" );
	
	v_start_left = struct::get( "phalanx_warehouse_left_start" ).origin;
	v_end_left = struct::get( "phalanx_warehouse_left_end" ).origin;
	
	v_start_right = struct::get( "phalanx_warehouse_right_start" ).origin;
	v_end_right = struct::get( "phalanx_warehouse_right_end" ).origin;
	
	n_phalanx = 1;
	
	if ( level.players.size >= 3 )
	{
		n_phalanx = 2;
	}
	
	phalanx_left = new RobotPhalanx();
	[[ phalanx_left ]]->Initialize( "phanalx_wedge", v_start_left, v_end_left, 2 , n_phalanx );
	
	phalanx_right = new RobotPhalanx();
	[[ phalanx_right ]]->Initialize( "phanalx_wedge", v_start_right, v_end_right, 2 , n_phalanx );
}

//self are the wasps that spawns. Do a special spline entrance, then put it on a goal volume afterward
function wasps_warehouse_spawn()
{
	self endon( "death" );
	
	self vehicle_ai::start_scripted();
	
	nd_start = GetVehicleNode( self.target, "targetname" );
	self thread vehicle::get_on_and_go_path( nd_start );
	
	self waittill( "reached_end_node" );

	//this gets the wasp moving away from the endpoint asap, so they don't bunch up at the end of the path
	v_pos = self GetClosestPointOnNavVolume( self.origin, 1024 );
	v_pos = ( v_pos[0], v_pos[1], v_pos[2] + RandomIntRange( 0, 72 ) );
	if ( isdefined( v_pos ) )
	{
		self SetVehGoalPos( v_pos, false );
		self waittill( "goal" );
	}	
	
	//depending on which side we spawned on, use appropriate goal volume
	e_volume = undefined;
	if ( self.script_aigroup == "wasps_warehouse_left" )
	{
		e_volume = GetEnt( "volume_warehouse_wasps_left", "targetname" );	
	}
	else if ( self.script_aigroup == "wasps_warehouse_right" )
	{
		e_volume = GetEnt( "volume_warehouse_wasps_right", "targetname" );	
	}
	
	self vehicle_ai::stop_scripted( "combat" );
	
	if ( isdefined( e_volume ) )
	{
		self SetGoal( e_volume, true );
	}
}

function hendricks_hero_moment( str_path ) //TODO much of this is temp, just roughing it in for now
{
	if ( str_path == "right" )
	{
		level endon( "left_path" );
	}
	else
	{
		level endon( "right_path" );
	}
	
	level trigger::wait_till( "trig_hero_sprint_" + str_path );
	
	//spawn robot just around corner that will wait for Hendricks to stomp on him
	ai_target = spawner::simple_spawn_single( "warehouse_hero_target_" + str_path );
	
	ai_target ai::set_ignoreme( true ); //make sure hendricks or friendly robots don't kill him too early
	
	//keep robot in place for scene
	ai_target ai::set_behavior_attribute( "can_become_rusher", false );
	ai_target.goalradius = 8;
	
	ai_target endon( "death" );
	
	//get Hendricks into place at the right spot
	if ( str_path == "right" )
	{
		level thread scene::init( "scene_warehouse_hendricks_jump_right", "targetname", array( level.ai_hendricks, ai_target ) );
	}
	else
	{
		level thread scene::init( "scene_warehouse_hendricks_jump_left", "targetname", array( level.ai_hendricks, ai_target ) );
	}	
	
	level trigger::wait_till( "trig_hero_moment_" + str_path );
	
	if ( str_path == "right" )
	{
		level scene::play( "scene_warehouse_hendricks_jump_right", "targetname", array( level.ai_hendricks, ai_target ) );
	}
	else
	{
		level scene::play( "scene_warehouse_hendricks_jump_left", "targetname", array( level.ai_hendricks, ai_target ) );
	}
	
	level.ai_hendricks ClearForcedGoal();
}	

function hendricks_color_chains() //self = hendricks //TODO Need some logic here to make sure Hendricks continues moving if the player decides to turn around and take a different path
{
	level endon( "right_path" ); //right path uses default color chaining
	
	level flag::wait_till( "left_path" ); //left path uses seperate color chaining
	
	self colors::set_force_color( "p" );
	
	level flag::wait_till( "warehouse_done" );
	
	self colors::set_force_color( "b" );
}

function make_an_exit() //this is called when the back door shooters are spawned
{
	level flag::wait_till( "warehouse_warlord_dead" );
	
	if ( level.a_ai_squad.size < 2 )
	{		
		e_forklift = GetEnt( "warehouse_forklift" , "targetname" );
		e_forklift_clip = GetEnt( "warehouse_forklift_clip" , "targetname" );
		e_forklift_clip Linkto( e_forklift );
		
		level scene::play( "cin_bio_06_02_backdoor_vign_forklift", array( level.ai_hendricks, e_forklift ) );
		
		e_forklift_clip Unlink();
		
		cp_mi_sing_biodomes_util::enable_traversals( true, "forklift_traverse_start", "targetname" );
		cp_mi_sing_biodomes_util::enable_traversals( true, "forklift_traverse_end", "targetname" );
		cp_mi_sing_biodomes_util::enable_traversals( true, "warehouse_robot_exit_traversal", "targetname" );
		
		level.ai_hendricks SetGoal( GetNode( "warehouse_exit" , "targetname" ) , true );
		
		level.ai_hendricks thread dialog::say( "hend_found_a_way_through_0" , 1 ); //Found a way through. On me.
		
		//allow for case where there is only 1 robot left
		if ( level.a_ai_squad.size == 1 )
		{
			level.a_ai_squad[0] ClearForcedGoal();			
			level.a_ai_squad[0] SetGoal( GetNode( "warehouse_robot_exit" , "targetname" ) , true );
		}
	}
	else
	{
		level thread dialog::remote( "kane_the_robots_should_be_0" , 2 ); //The Robots should be able to get that door open.
		
		objectives::set( "cp_level_biodomes_robot_task_door" , struct::get( "s_warehouse_door_indicator" ) );
		
		level.players[0] thread squad_control::squad_assign_task_independent( "pry_door" );
		
		//keyline door to mark it as a robot target if there are enough robots
		level.mdl_door_upper squad_control::enable_keyline( 4 );
		level.mdl_door_lower squad_control::enable_keyline( 4 );
	}
}

function shoot_container() //self = AI spawned to shoot at container
{
	self endon( "death" );
	
	self.ignoreall = true;
	self.upaimlimit = 80;
	
	util::magic_bullet_shield( self );
	
	self util::waittill_notify_or_timeout( "goal" , 1 );
	
	e_target = GetEnt( "container_target" , "targetname" );
	
	self thread ai::shoot_at_target( "normal" , e_target , "tag_origin", 1 );
	
	//damage trigger around target sets flag, safety timeout added just in case
	level flag::wait_till_timeout( 4, "container_drop" );
	
	level  flag::set( "container_drop" );

	util::stop_magic_bullet_shield( self );
	self.ignoreall = false;
}

function container_done() //takes a notify from an animation and sets corresponding flag
{
	level waittill( "container_done" );
	level flag::set( "container_done" );
}

function container_crash() 
{	
	e_container_clip = GetEnt( "container_drop_clip" , "targetname" );
	
	e_container_clip ConnectPaths(); //TODO Can't seem to order Robot squad through here, investigate. May be a squad control targeting issue rather than pathing.
	
	spawn_manager::enable( "sm_warehouse_intro" );
	
	level flag::wait_till( "container_drop" );
	
	//bring in robot ambush as crates fall
	spawn_manager::enable( "sm_warehouse_robot_jumpdown" );
	
	level thread scene::play( "p7_fxanim_cp_biodomes_container_collapse_bundle" );
	
	level thread vo_warehouse_container();
	
	level waittill( "container_hit_01" ); //notetrack set in animation
	
	level thread container_crushes_robots();
	
	e_container_clip DisconnectPaths();
	
	wait 0.25; //wait a moment before playing camera shake and rumble
	
	s_container = struct::get( "container_crash" );	
	
	Earthquake( 1, 1, s_container.origin, 1000 );
	PlaySoundAtPosition( "evt_warlord_door_smash" , s_container.origin );	//TODO Temp SFX
	
	foreach ( player in level.players ) 
	{
		player PlayRumbleOnEntity( "damage_heavy" );
	}
}

function vo_warehouse_container()
{
	level dialog::remote( "kane_woah_get_out_of_t_0" ); //Woah! - Get out of the way!!
	
	level dialog::remote( "kane_tracking_enemy_units_0", 3 ); //Tracking Enemy units moving in on both sides.
	
	level dialog::player_say( "plyr_tell_me_something_i_0" ); //Tell me something I don’t know!
}

function container_crushes_robots()
{
	a_robots = GetAITeamArray( "allies" );
	e_container_clip = GetEnt( "container_drop_clip" , "targetname" );
	
	ArrayRemoveValue( a_robots, level.ai_hendricks );
	
	for ( i = 0; i < a_robots.size; i++ )
	{
		if ( a_robots[i] IsTouching( e_container_clip ) )
		{
			util::stop_magic_bullet_shield( a_robots[i] );
			a_robots[i] Kill();
		}
	}
	
	a_robots = [];
}

function container_ambusher() //run as spawn function, self = AI
{
	self endon( "death" );
	
	self SetGoal( self.origin , true , 1 );
	
	level flag::wait_till( "container_done" );
	
	self ai::set_behavior_attribute( "move_mode", "rambo" );
	
	nd_target = GetNode( self.target , "targetname" );
	
	self SetGoal( nd_target , true );
	
	self waittill( "goal" );
	
	self ai::set_behavior_attribute( "move_mode", "normal" );
	
	wait 10; //stay in position for a bit
	
	self SetGoal( self.origin , false , 1200 ); //now you can go chase the player
}

function glass_break( str_trigger_name )
{
	t_glass = GetEnt( str_trigger_name , "targetname" );
	
	t_glass flag::init( "glass_broken" );
	
	while ( t_glass flag::get( "glass_broken" ) == false )
	{
		t_glass trigger::wait_till();
	
		if ( !IsPlayer( t_glass.who ) || ( IsPlayer( t_glass.who ) && t_glass.who IsSprinting() ) )
		{
			GlassRadiusDamage( t_glass.origin , 100 , 500 , 500 );
		
			t_glass flag::set( "glass_broken" );
		}
	}
	
	t_glass Delete();
}

function wait_for_objective_complete()
{
	trigger::wait_till( "trig_warehouse_objective_complete" );
	
	level flag::set( "warehouse_done" );
	
	skipto::objective_completed( "objective_warehouse" );
}

function back_door_shooters() //used to be anim scene for guys walking backwards out of warehouse back door. now just using spawned ai because it plays better.
{	
	trigger::wait_till( "trig_back_door_group" );
	
	spawner::simple_spawn( GetEntArray( "back_door_enemy" , "script_aigroup" ) );
	
	GetEnt( "back_door_look_trigger" , "script_noteworthy" ) TriggerEnable( true ); //enable the lookat trigger which causes the back door to close
}

function back_door_close() //closes the door geo pieces when player approaches
{
	level.mdl_clip = GetEnt( "clip_warehouse_door", "targetname" );
	level.mdl_clip MoveZ( -95, 0.05 );
	level.mdl_clip Disconnectpaths();
	
	level.mdl_door_upper = GetEnt( "cloudmountain_door_upper" , "targetname" );
	level.mdl_door_lower = GetEnt( "cloudmountain_door_lower" , "targetname" );
	level.mdl_door_upper.v_open_pos = level.mdl_door_upper.origin;
	level.mdl_door_lower.v_open_pos = level.mdl_door_lower.origin;
	
	level.mdl_door_upper MoveZ( -40 , 2 );
	level.mdl_door_lower MoveZ( 60 , 2 );
	
	level.mdl_door_upper playsound ("evt_warehouse_door_close_start");
	level.mdl_door_upper playloopsound ("evt_warehouse_door_close_loop", 1);
	
	level.mdl_door_lower waittill( "movedone" );
	level.mdl_door_upper playsound ("evt_warehouse_door_close_stop");
	level.mdl_door_upper stoploopsound (.5);
	
	level flag::set( "back_door_closed" );
	
	GetEnt( "back_door_sight_clip" , "targetname" ) MoveZ( 128 , 0.05 );
	
	level thread dialog::remote( "kane_i_ve_located_a_backd_0" ); //I’ve located a backdoor entrance to Cloud Mountain - sending to your HUD.
	
	//get rid of indicator behind door since it's closed now
	objectives::complete( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_warehouse" ) );
	
	level flag::wait_till( "warehouse_warlord_dead" );
	
	//level thread scene::stop( "cin_bio_06_01_backdoor_vign_shooting" );
	level thread back_door_ai_side();
	level thread make_an_exit();
}

//used as a backup in case we need to force the door open manually for enemies later in the level
function warehouse_door_open()
{
	if ( !isdefined( level.mdl_door_upper ) || !isdefined( level.mdl_door_lower ) )
	{
		level.mdl_door_upper = GetEnt( "cloudmountain_door_upper" , "targetname" );
		level.mdl_door_lower = GetEnt( "cloudmountain_door_lower" , "targetname" );
	}
	
	level.mdl_door_upper MoveTo( level.mdl_door_upper.v_open_pos , 2 );
	level.mdl_door_lower MoveTo( level.mdl_door_lower.v_open_pos , 2 );
	
	level.mdl_door_upper playsound ("evt_warehouse_door_close_start");
	level.mdl_door_upper playloopsound ("evt_warehouse_door_close_loop", 1);
	
	level.mdl_door_lower waittill( "movedone" );
	level.mdl_door_upper playsound ("evt_warehouse_door_close_stop");
	level.mdl_door_upper stoploopsound (.5);
	
	level flag::set( "back_door_opened" );
	
	//TODO look into simplifying the clip on the warehouse door
	e_door_collision = GetEnt( "back_door_collision" , "targetname" );
	e_door_sight = GetEnt( "back_door_sight_clip" , "targetname" );
	
	if ( isdefined( e_door_collision ) )
	{
		e_door_collision Delete();
	}
	
	if ( isdefined( e_door_sight ) )
	{
		e_door_sight Delete();
	}
}

function warehouse_open_door_double_jump()
{
	//wait for trigger
	level flag::wait_till( "warehouse_done" );
	
	//check if door hasn't been opened and robots haven't been told to open it yet
	if ( !level flag::get( "back_door_opened" ) && !level scene::is_active( "cin_bio_06_01_backdoor_vign_open" ) && !level scene::is_active( "cin_bio_06_01_backdoor_vign_open_noshoot" ) )
	{
		level.players[0] thread squad_control::squad_assign_task_independent( "pry_door" );	
	}
}

function back_door_ai_side() //checks if player uses side exit and sends ai on other side to retreat if so
{
	a_back_door_ai = GetAIArray( "back_door_enemy" , "script_aigroup" );
	
	foreach (ai_back_door_enemy in a_back_door_ai)
	{
		if ( isAlive( ai_back_door_enemy ) )
		{
			ai_back_door_enemy.ignoreme = true;
			ai_back_door_enemy.ignoreall = true;
		}
	}

	trigger::wait_till( "trig_back_door_retreat" );
	
	if ( level flag::get( "back_door_opened" ) == false ) 
	{
		level thread back_door_ai_retreat();
	}
}
 
function back_door_ai_retreat()
{
	a_back_door_ai = GetAIArray( "back_door_enemy" , "script_aigroup" );
	e_retreat_goal = GetEnt( "back_door_goal_volume" , "targetname" );
	
	foreach (ai_back_door_enemy in a_back_door_ai)
	{
		if ( isAlive( ai_back_door_enemy ) )
		{
			ai_back_door_enemy.ignoreme = false;
			//e_retreat_goal = GetNode( "retreat_" + ai_back_door_enemy.script_noteworthy , "targetname" );	//using nodes instead of goal volume to workaround a bug
			ai_back_door_enemy SetGoal( e_retreat_goal , true );
		}
	}
	
	wait 10; //wait while the ai retreats, then set them to fight again
	
	foreach (ai_back_door_enemy in a_back_door_ai)
	{
		if ( isAlive( ai_back_door_enemy ) )
		{
			ai_back_door_enemy.ignoreall = false;		
		}
	}
}

function wait_for_sight_to_engage() // This function is used on a specific AI to keep them in their targeted area until they see a player
{
	self endon( "death" );
    self waittill( "enemy" );
    
    wait 0.05;
    
    while( isdefined( self.enemy) && !self CanSee( self.enemy ) ) 
    {
    	wait 0.5;
    }    
    
    self SetGoal( GetEnt( "entire_warehouse_setgoal_volume" , "targetname" ) );
}

function warehouse_warlord_surprise()
{
	trigger::wait_till( "trig_back_door_close" );
	
	wait 1.5; //door takes about 2 seconds to close, we want warlord to appear right before it finishes
	
	spawner::simple_spawn( "warehouse_enemy_warlord" , &warehouse_surprise_spawns );
	
	level flag::set( "warehouse_warlord" );
	
	spawner::simple_spawn( "warehouse_enemy_group3" , &warehouse_surprise_spawns );
	
	level thread dialog::remote( "kane_warlord_get_to_cove_0" ); //WARLORD! Get to cover!
	
	level thread clientfield::set( "warehouse_window_break", 1 );
	
	GetEnt( "warehouse_overwatch_window" , "targetname" ) Delete();
	
	s_container = struct::get( "warehouse_surprise" );
	Earthquake( .25, .5, s_container.origin, 1200 );
}

function warehouse_surprise_spawns() //self = ai, 
{
	self endon( "death" );
	self.ignoreall = true;
	wait 1;					//make ai pause just a moment before opening fire
	self.ignoreall = false;
}

//============================================================
// co-op gameplay options

function on_player_spawned()
{
	
}
