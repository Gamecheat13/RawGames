#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;

#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;

#using scripts\cp\cp_mi_cairo_infection_util;
#using scripts\cp\cp_mi_cairo_infection_hideout_outro;
#using scripts\cp\_objectives;

                                               	                                                          	              	                                                                                           

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                           	                                     	                                                                                                                                                                                                         

#using scripts\cp\_util;





#precache( "fx", "zombie/fx_dog_lightning_buildup_zmb" );
#precache( "fx", "fire/fx_fire_ai_human_torso_loop" );
#precache( "fx", "fire/fx_fire_ai_human_arm_left_loop" );
#precache( "fx", "fire/fx_fire_ai_human_arm_right_loop" );
#precache( "fx", "fire/fx_fire_wall_moving_infection_city" );

#namespace infection_zombies;
//--------------------------------------------------------------------------------------------------
//		MAIN
//--------------------------------------------------------------------------------------------------
function main()
{
	level flag::init( "sarah_tree" );
	level flag::init( "end_round_wait" );
	level flag::init( "spawn_zombies", true );
	level flag::init("zombies_completed");
	level flag::init("zombies_final_round");

//TODO:	level.riser_type = "snow";

	level.gamedifficulty = GetLocalProfileInt( "g_gameskill" );
	if(!IsDefined(level.gamedifficulty))
	{
		level.gamedifficulty = 1; //normal difficulty
	}	

	init_levelvars();
	init_client_field_callback_funcs();

	level.zombie_spawn_locations = [];
	level.playable_areas = GetEntArray("player_volume", "script_noteworthy" );

	for( i=0; i < level.playable_areas.size; i++ )
	{
		if(IsDefined(level.playable_areas[i].target))
		{
			level.playable_areas[i] thread spawn_locations_init();
		}	
	}
	
	level.zombie_spawners = GetEntArray( "zombie_spawner", "script_noteworthy" ); 
	array::thread_all(level.zombie_spawners, &spawner::add_spawn_function, &zombie_spawn_init);

	level thread sarah_at_stalingrad();
}

function spawn_locations_init()
{
	points = struct::get_array( self.target, "targetname" );
	for( i=0; i < points.size; i++ )
	{
		
		//enabling all spawn locations now, but leaving ability to add back if this doesn't test well.
		points[i].enabled = true;
				
		array::add(level.zombie_spawn_locations, points[i], false);
	}
}	

function init_client_field_callback_funcs()
{	
	if( !GetDvarint("ai_spawn_only_zombies") == 1 )
	{
		clientfield::register("actor", "zombie_riser_fx", 1, 1, "int" );
		clientfield::register("actor", "zombie_has_eyes", 1, 1, "int" );
		clientfield::register("actor", "zombie_gut_explosion", 1, 1, "int" );
	}
	clientfield::register("scriptmover", "zombie_fire_wall_fx", 1, 1, "int" );
	clientfield::register("scriptmover", "zombie_fire_backdraft_fx", 1, 1, "int" );
	clientfield::register("toplayer", "zombie_fire_overlay_init", 1, 1, "int" );
	clientfield::register("toplayer", "zombie_fire_overlay", 1, 7, "float" );
	clientfield::register("world", "zombie_root_grow", 1, 1, "int" );
}


//temp debug util
function check_num_alive()
{
	while( true )
	{
		num_zombies = zombie_utility::get_current_zombie_count();
		/# IPrintLnBold( "number of zombies alive is ", num_zombies );	#/

		wait 1;	
	}
}

//--------------------------------------------------------------------------------------------------
//		ZOMBIE SPECIFIC LEVEL VARS
//--------------------------------------------------------------------------------------------------
function init_levelvars()
{
	// Variables
	level.zombie_team = "axis";
	level.is_zombie_level				= true; 
	level.first_round					= true;	
	level.start_round					= 1;
	level.round_number					= level.start_round;
	level.zombie_total					= 0;
	level.total_zombies_killed			= 0;
	level.zombie_spawn_locations		= [];	
	level.zombie_vars = [];	
	level.current_zombie_array = [];
	level.current_zombie_count = 0;
	level.zombie_total_subtract = 0;
	level.zombie_actor_limit = 31;
	level.zombies_timeout_playspace = 0;
	level.zombie_game_time = 150; //2 minutes 30 seconds
	level.zombie_total_min = 2 ; //initial minimum, adjusted for player count.

	level._effect[ "lightning_dog_spawn" ]	= "zombie/fx_dog_lightning_buildup_zmb";
	level._effect[ "burn_loop_zombie_left_arm" ] 	= "fire/fx_fire_ai_human_arm_left_loop";
	level._effect[ "burn_loop_zombie_right_arm" ] 	= "fire/fx_fire_ai_human_arm_right_loop";
	level._effect[ "burn_loop_zombie_torso" ] 		= "fire/fx_fire_ai_human_torso_loop";
	level._effect[ "zombie_firewall_fx" ] = "fire/fx_fire_wall_moving_infection_city";

	difficulty = 1;
	column = int(difficulty) + 1;

	// AI
	zombie_utility::set_zombie_var( "zombie_health_increase", 			0,	false,	column );	//	cumulatively add this to the zombies' starting health each round (up to round 7)
	zombie_utility::set_zombie_var( "zombie_health_increase_multiplier",0.1, 	true,	column );	//	after round 7 multiply the zombies' starting health by this amount
	zombie_utility::set_zombie_var( "zombie_health_start", 				125,	false,	column );	//	starting health of a zombie at round 1
	zombie_utility::set_zombie_var( "zombie_spawn_delay", 				2.0,	true,	column );	// Base time to wait between spawning zombies.  This is modified based on the round number.
	zombie_utility::set_zombie_var( "zombie_ai_per_player", 			8,		false,	column );	//	additional zombie modifier for each player in the game
	zombie_utility::set_zombie_var( "zombie_between_round_time", 		1 );		// How long to pause after the round ends
	zombie_utility::set_zombie_var( "game_start_delay", 				0,		false,	column );	// How much time to give people a break before starting spawning
	zombie_utility::set_zombie_var( "zombie_use_failsafe", 				true );		// Will slowly kill zombies who are stuck
	zombie_utility::set_zombie_var( "below_world_check", 				-5000 );					//	Check height to see if a zombie has fallen through the world.
	zombie_utility::set_zombie_var( "zombie_max_ai", 					32,		false,	column );	//	Base number of zombies per player (modified by round #)
	
	level.zombie_ai_limit	= level.zombie_vars["zombie_max_ai"];

	level.move_spawn_func	= &move_zombie_spawn_location;
	level.max_zombie_func = &infection_max_zombie_func;

	timer = level.zombie_vars["zombie_spawn_delay"];
	if ( timer > 0.08 )
	{
		level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;
	}
	else if ( timer < 0.08 )
	{
		level.zombie_vars["zombie_spawn_delay"] = 0.08;
	}

	level.speed_change_max = 0;
	level.speed_change_num = 0;
}

//--------------------------------------------------------------------------------------------------
//		ZOMBIE INIT WHEN SPAWNED
//--------------------------------------------------------------------------------------------------
function zombie_spawn_init( animname_set )
{
	self endon("death");
	
	if( !isDefined( animname_set ) )
	{
		animname_set = false;
	}
	
	self.targetname = "zombie";
	self.script_noteworthy = undefined;

	if( !animname_set )
	{
		self.animname = "zombie"; 		
	}
	
	self thread infection_util::zmbAIVox_NotifyConvert();
	self.zmb_vocals_attack = "zmb_vocals_zombie_attack";
	
	self.ignoreall = true; 
	self.ignoreme = true; // don't let attack dogs give chase until the zombie is in the playable area
	self.allowdeath = true; 			// allows death during animscripted calls
	self.force_gib = true; 		// needed to make sure this guy does gibs
	self.is_zombie = true; 			// needed for melee.gsc in the animscripts
	self allowedStances( "stand" ); 
	self.gibbed = false; 
	self.head_gibbed = false;
	
	self setPhysParams( 15, 0, 72 );
	self.goalradius = 32;
	
	self.disableArrivals = true; 
	self.disableExits = true; 
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;

	self.ignoreSuppression = true; 	
	self.suppressionThreshold = 1; 
	self.noDodgeMove = true; 
	self.dontShootWhileMoving = true;
	self.pathenemylookahead = 0;

	self.badplaceawareness = 0;
	self.chatInitialized = false; 

	self.a.disablepain = true;
	self.a.disableReact = true;
	self.allowReact = false;
	
	self.disableAmmoDrop = true;
	
	if ( isdefined( level.zombie_health ) )
	{
		self.maxhealth = level.zombie_health; 
		
		if(IsDefined(level.zombie_respawned_health) && level.zombie_respawned_health.size > 0)
		{
			self.health = level.zombie_respawned_health[0];
			ArrayRemoveValue(level.zombie_respawned_health, level.zombie_respawned_health[0]);		
		}
		else
		{
			self.health = level.zombie_health;
		}	 
	}
	else
	{
		self.maxhealth = level.zombie_vars["zombie_health_start"]; 
		self.health = self.maxhealth; 
	}

	//setting avoidance parameters for zombies
	self setAvoidanceMask( "avoid none" );

	// wait for zombie to teleport into position before pathing
	self PathMode( "dont move" );

	level thread zombie_death_event( self );

	self infection_run_speed();
	self thread zombie_think(); 
	self thread zombie_utility::zombie_gib_on_damage();
		
	if ( !isdefined( self.no_eye_glow ) || !self.no_eye_glow )
	{
		self thread zombie_utility::delayed_zombie_eye_glow();	// delayed eye glow for ground crawlers (the eyes floated above the ground before the anim started)
	}
	self.deathFunction = &zombie_death_animscript;
	self.flame_damage_time = 0;

	self.meleeDamage = 60;	// 45
	self.no_powerups = true;
	
	self.team = level.zombie_team;

	self.zombie_init_done = true;

	self notify( "zombie_init_done" );
}


function zombie_think()
{
	self endon( "death" ); 
	
	
	self thread do_zombie_spawn();
	self waittill("risen");

	self zombie_setup_attack_properties();
	
	self SetGoal( self.origin );
	self PathMode( "move allowed" );
	self.zombie_think_done = true;
	
	//make sure doesn't get bad path attack properties set.
	self thread zombie_bad_path();
}

// this is where zombies go into attack mode, and need different attributes set up
function zombie_setup_attack_properties()
{
	self.ai_state = "find_flesh"; //no barricades in this map.
	
	// allows zombie to attack again
	self.ignoreall = false; 

	self.meleeAttackDist = 64;
	
	//try to prevent always turning towards the enemy
	self.maxsightdistsqrd = 128 * 128;

	// turn off transition anims
	self.disableArrivals = true; 
	self.disableExits = true; 
}


//--------------------------------------------------------------------------------------------------
//		INFECTION MAX ZOMBIES PER ROUND / HEALTH PER ROUND
//		more zombies per round, less health ramp.
//--------------------------------------------------------------------------------------------------
function infection_max_zombie_func( max_num )
{
	max = max_num;

	if ( level.round_number < 2 ) //round 1
	{
		max = int( max_num * 0.44 );//14	
	}
	else if (level.round_number < 3 ) // round 2
	{
		max = int( max_num * 0.5 );//16	
	}	
	else if (level.round_number < 4 ) // round 3
	{
		if( level.players.size == 1 )
		{
			max = int( max_num * 0.5 );//16	
		}		
		else
		{		
			max = int( max_num * 0.63 ); //20
		}			
	}
	else if (level.round_number < 5 ) // round 4
	{
		if( level.players.size == 1 )
		{
			max = int( max_num * 0.63 ); //20
		}		
		else
		{		
			max = int( max_num * 0.82 ); //26
		}			
	}
	else if (level.round_number < 6 ) // round 5+
	{
		max = int( max_num * 1.0 ); //32
	}
	
	return max;
}

function infection_calculate_health( round_number )
{
	level.zombie_health = level.zombie_vars["zombie_health_start"]; 

	// gets much harder after sarah at tree.
	if( level flag::get( "sarah_tree" ) )
	{
		level.zombie_health = Int( level.zombie_health + (level.zombie_vars["zombie_health_increase"] * (round_number * 1.5)) ); 
		
	}
	else
	{
		level.zombie_health = Int( level.zombie_health + (level.zombie_vars["zombie_health_increase"] * (round_number - 1 )) ); 
	}
}

//--------------------------------------------------------------------------------------------------
//		CUSTOM INFECTION RUN SPEED CHANGES
//--------------------------------------------------------------------------------------------------
function infection_run_speed()
{
	self endon( "death" );
	
	//initial define
	self.zombie_move_speed = "walk";
	n_chance = RandomInt( 100 );
	
	if ( level.round_number < 2 )
	{
		self.zombie_move_speed = "walk";
		
		if( n_chance > 75) //25%
		{
			self.zombie_move_speed = "run"; 
		}	 
	}
	else if (level.round_number < 3 ) // round 2
	{
		self.zombie_move_speed = "walk";

		if( n_chance > 50) //50%
		{
			self.zombie_move_speed = "run"; 
		}	 
	}	
	else if (level.round_number < 4 ) // round 3
	{
		self.zombie_move_speed = "run";

		if( n_chance > 95 ) //5%
		{
			self.zombie_move_speed = "sprint"; 
		} 
	}
	else if (level.round_number < 5 ) // round 4
	{
		self.zombie_move_speed = "run";

		if( n_chance > 85) //15%
		{
			self.zombie_move_speed = "sprint"; 
		}	 
	}
	else if (level.round_number < 6 ) // round 5
	{
		self.zombie_move_speed = "run";

		if( n_chance > 50 ) //50%
		{
			self.zombie_move_speed = "sprint"; 
		} 
	}	
	else
	{
		self.zombie_move_speed = "sprint"; 
	}
	
	self thread speed_increase_over_time();
}

//if the zombie has been alive quite awhile speed him up.
function speed_increase_over_time()
{
	self endon( "death" );
	
	//already going as fast as possible.
	if(	( self.zombie_move_speed === "sprint" ) )	
	{
		return;
	}
		
	timepassed = 0;
	starttime = GetTime();
	time_segment = 	level.zombie_game_time * 0.4;
	
	while( true )
	{
		if( timepassed >= time_segment )
		{
			//speed up
			if(	( self.zombie_move_speed === "walk" ) )
			{
				self zombie_utility::set_zombie_run_cycle( "run" );
			}
			else if(	( self.zombie_move_speed === "run" ) )
			{
				self zombie_utility::set_zombie_run_cycle( "sprint" );
				return;
			}
			
			//reset after speed up
			timepassed = 0;
		}		
		
		wait 1;
		timepassed = (GetTime() - starttime) / 1000;
	}
}	

//--------------------------------------------------------------------------------------------------
//		ZOMBIE AT LOCATION
//--------------------------------------------------------------------------------------------------
function do_zombie_spawn()
{
	self endon("death");

	zones = [];
	spots = [];
	
	// add spawner locations
	if(IsDefined(level.playable_areas))
	{
		for( i=0; i < level.playable_areas.size; i++ )
		{
			in_zone = player_in_zone( level.playable_areas[i] );
	
			if(( isdefined( in_zone ) && in_zone ))
			{
				spots = add_zone_spawn_locations( level.playable_areas[i], spots );
			}
		}
		
		if(spots.size <= 0 && IsDefined(level.zombie_spawn_locations))
		{
			for( i=0; i < level.zombie_spawn_locations.size; i++ )
			{
				if(( isdefined( level.zombie_spawn_locations[i].enabled ) && level.zombie_spawn_locations[i].enabled ))
				{
					spots[spots.size] = level.zombie_spawn_locations[i];
				}	
			}	
		}	
			
	}	
	else if(IsDefined(level.zombie_spawn_locations))
	{
		for( i=0; i < level.zombie_spawn_locations.size; i++ )
		{
			if(( isdefined( level.zombie_spawn_locations[i].enabled ) && level.zombie_spawn_locations[i].enabled ))
			{
				spots[spots.size] = level.zombie_spawn_locations[i];
			}	
		}	
	}

	assert( spots.size > 0, "No spawn locations found" );

	spot = array::random(spots);
	//preferential selection of barriers if starting zombies sequence.
	if( level.round_number < 3 )
	{
		spot = self select_barrier_spot(spots);
	}

	self.spawn_point = spot;

	self thread [[level.move_spawn_func]](spot);
}

function player_in_zone( volume )
{
	players = GetPlayers();
	for (j = 0; j < players.size; j++)
	{
		if ( players[j] IsTouching(volume))
		{	
			return true;
		}	
	}
	return false;
}

function select_barrier_spot( spots )
{
	//add ALL barrier spawn locations to initial spawning array to check
	all_spots = [];
	if(IsDefined(level.playable_areas))
	{
		for( i=0; i < level.playable_areas.size; i++ )
		{
			all_spots = add_zone_spawn_locations( level.playable_areas[i], all_spots );
		}	
	}
	
	//now add all barrier locations to the spots array, false will not allow added twice.
	//this will create an array with all barrier spots as well as the spots in the active zone.
	for( i=0; i < all_spots.size; i++ )
	{
		if(IsDefined(all_spots[i].barrier))
		{
			array::add(spots, all_spots[i], false);
		}		
	}	
	
	spots = array::randomize(spots);
	for(i = 0; i < spots.size; i++)
	{
		//must be barrier to check, barrier must not be occupied already or opened to get preference.
		if(IsDefined(spots[i].barrier) && !( isdefined( spots[i].barrier.opened ) && spots[i].barrier.opened ) && !( isdefined( spots[i].occupied ) && spots[i].occupied ) )
		{
			spots[i].occupied = true;
			level.barrier_occupied++;

			self thread barrier_spot_watcher( spots[i] );

			return spots[i];
		}
	}
	
	//didn't find an unoccupied barrier spot. select first non-barrier or opened spot.
	for(i = 0; i < spots.size; i++)
	{
		if(!IsDefined(spots[i].barrier) || ( isdefined( spots[i].barrier.opened ) && spots[i].barrier.opened ))
		{
			return spots[i];
		}		
	}
}	

function barrier_spot_watcher( spot )
{
	while(IsAlive(self) && (isdefined( spot.barrier )))
	{
		wait 0.1;
	}	
	
	spot.occupied = undefined;
	level.barrier_occupied--;
}	

function add_zone_spawn_locations( zone, spots )
{
	assert( IsDefined(zone.target), "No spawn locations found for zone volume " +zone.targetname);
	
	points = struct::get_array( zone.target, "targetname" );
	for( i=0; i < points.size; i++ )
	{
		if(( isdefined( points[i].enabled ) && points[i].enabled ))
		{
			array::add(spots, points[i], false);
		}		
	}	
	return spots;
}	

function move_zombie_spawn_location(spot)
{
	if(IsDefined(self.spawn_pos))
	{
		self notify("risen", self.spawn_pos.script_string );
		return;
	}		
	self.spawn_pos = spot;	
	
	if(IsDefined(spot.script_parameters))
	{
		self.script_parameters = spot.script_parameters;
	}	

	if(!IsDefined(spot.script_noteworthy))
	{
		spot.script_noteworthy = "spawn_location";
	}	


	if(isdefined(spot.barrier) && !( isdefined( spot.barrier.opened ) && spot.barrier.opened ))
	{
		self thread do_zombie_move( spot );
		return;
	}
	
	tokens = StrTok( spot.script_noteworthy, " " );
	foreach ( index, token in tokens )
	{
		if(token == "riser_location")
		{
			self thread do_zombie_rise(spot);
		}
		else // just spawn where at and go.
		{
			self thread do_zombie_move(spot);
		}
	}
}	

function do_zombie_move(spot)
{
	if(isdefined(spot.barrier) && !( isdefined( spot.barrier.opened ) && spot.barrier.opened ))
	{
		pos = spot.barrier;
	}
	else
	{
		pos = spot;
	}		
	
	self.anchor = spawn("script_origin", self.origin);
	self.anchor.angles = self.angles;
	self linkto(self.anchor);

	if( !isdefined( pos.angles ) )
	{
		pos.angles = (0, 0, 0);
	}

	self Ghost();
	self.anchor moveto(pos.origin, .05);
	self.anchor RotateTo((0, pos.angles[1], 0), .05);
	self.anchor waittill("movedone");

	// face goal
	target_org = zombie_utility::get_desired_origin();
	if (IsDefined(target_org))
	{
		anim_ang = VectorToAngles(target_org - self.origin);
		self.anchor RotateTo((0, anim_ang[1], 0), .05);
		self.anchor waittill("rotatedone");
	}
	if(isdefined(level.zombie_spawn_fx))
	{
		PlayFx(level.zombie_spawn_fx,pos.origin);
	}
	self unlink();
	if(isDefined(self.anchor))
	{
		self.anchor delete();
	}

	if(	isdefined( spot.barrier ) && ( pos == spot.barrier ) )
	{
		PlayFx( level._effect["lightning_dog_spawn"], self.origin );
		self Show();
		self thread zombie_to_barrier( spot );
	}		
	else
	{	
		self Show();
		self notify("risen", spot.script_string );
	}	
}	

function do_zombie_rise(spot)
{	
	self endon("death");

	self.in_the_ground = true;

	if ( IsDefined( self.anchor ) )
	{
		self.anchor Delete();
	}
	
	self.anchor = spawn("script_origin", self.origin);
	self.anchor.angles = self.angles;
	self linkto(self.anchor);

	if( !isDefined( spot.angles ) )
	{
		spot.angles = (0, 0, 0);
	}

	anim_org = spot.origin;
	anim_ang = spot.angles;

	anim_org = anim_org + (0, 0, 0);	// start the animation 45 units below the ground

	self Ghost();
	self.anchor moveto(anim_org, .05);
	self.anchor waittill("movedone");

	// face goal
	target_org = zombie_utility::get_desired_origin();
	if (IsDefined(target_org))
	{
		anim_ang = VectorToAngles(target_org - self.origin);
		self.anchor RotateTo((0, anim_ang[1], 0), .05);
		self.anchor waittill("rotatedone");
	}

	self unlink();
	
	if(isDefined(self.anchor))
	{
		self.anchor delete();
	}

	self thread zombie_utility::hide_pop();	// hack to hide the pop when the zombie gets to the start position before the anim starts

	level thread zombie_utility::zombie_rise_death(self, spot);
	spot thread zombie_rise_fx(self);

	if(!IsDefined(self.zombie_move_speed))
	{
		self.zombie_move_speed = "walk";
	}	

	substate = 0;
	if ( self.zombie_move_speed == "walk" )
	{
		substate = RandomInt( 2 );
	}
	else if ( self.zombie_move_speed == "run" )
	{
		substate = 2;
	}
	else if ( self.zombie_move_speed == "sprint" )
	{
		substate = 3;
	}

	self OrientMode( "face default" );
	
	self AnimScripted( "rise_anim", self.origin, self.angles, "ai_zombie_traverse_ground_climbout_fast" );		
	self zombie_shared::DoNoteTracks( "rise_anim", &zombie_utility::handle_rise_notetracks, spot );

	self notify("rise_anim_finished");
	spot notify("stop_zombie_rise_fx");
	self.in_the_ground = false;
	
	self notify("risen", spot.script_string );
}

function zombie_rise_fx(zombie)
{
	zombie endon("death");
	self endon("stop_zombie_rise_fx");
	self endon("rise_anim_finished");
	
	// this needs to have "level.riser_type = "snow" set in the level script to work properly in snow levels!
	zombie clientfield::set("zombie_riser_fx", 1);
}

//--------------------------------------------------------------------------------------------------
//		ZOMBIE DEATH
//--------------------------------------------------------------------------------------------------
function zombie_death_event( zombie )
{
	zombie.marked_for_recycle = 0;

	force_explode = 0;
	force_head_gib = 0;
	
	zombie waittill( "death", attacker);
	time_of_death = gettime();
	
	if(isDefined(zombie))
	{
		zombie StopSounds();
	}

	// The Insta Kill Upgrade - Forces melee deaths on close proximity
	if( IsDefined(zombie) && IsDefined(zombie.marked_for_insta_upgraded_death) )
	{
		force_head_gib = 1;
	}

	if ( !isdefined( zombie.damagehit_origin ) && isdefined( attacker ) && IsAlive( attacker ) )
	{
		zombie.damagehit_origin = attacker GetWeaponMuzzlePoint();
	}

	// Need to check in case he got deleted earlier
	if ( !IsDefined( zombie ) )
	{
		return;
	}
	
	//Track all zombies killed
	level.total_zombies_killed++;

	name = zombie.animname;
	if( isdefined( zombie.sndname ) )
	{
		name = zombie.sndname;
	}
	
	zombie thread zombie_utility::zombie_eye_glow_stop();

	if( IsActor( zombie ) )
	{
		if( (zombie.damagemod == "MOD_GRENADE") || (zombie.damagemod == "MOD_GRENADE_SPLASH") || (zombie.damagemod == "MOD_EXPLOSIVE") || (force_explode == 1) )
		{
			splode_dist = 12 * 15;
			if ( isdefined(zombie.damagehit_origin) && distancesquared(zombie.origin,zombie.damagehit_origin) < splode_dist * splode_dist )
			{
				tag = "J_SpineLower";
				
				
				if (!( isdefined( zombie.is_on_fire ) && zombie.is_on_fire ) && !( isdefined( zombie.guts_explosion ) && zombie.guts_explosion ))
				{
					zombie thread zombie_utility::zombie_gut_explosion();
				}
			}
		}
	}
	
	if(isdefined (zombie.attacker) && isplayer(zombie.attacker) )
	{
		zombie.attacker notify( "zom_kill", zombie );
	}

		
	level notify( "zom_kill" );
	level.total_zombies_killed++;
}

//--------------------------------------------------------------------------------------------------
function zombie_death_animscript()
{
	team = undefined;

	if(isDefined(self._race_team))
	{
		team = self._race_team;
	}
	
	self zombie_utility::reset_attack_spot();

	// animscript override
	if( IsDefined( level.zombie_death_animscript_override ) )
	{
		self [ [ level.zombie_death_animscript_override ] ] ();
	}

	// If no_legs, then use the AI no-legs death
	if( !self.missingLegs && IsDefined( self.a.gib_ref ) && self.a.gib_ref == "no_legs" )
	{
		self.deathanim = "zm_death";
	}

	self.grenadeAmmo = 0;

	// switch to inflictor when SP DoDamage supports it
	if( isdefined( self.attacker ) && isai( self.attacker ) )
	{
		self.attacker notify( "killed", self );
	}
	

	if( self.damagemod == "MOD_BURNED" )
	{
		self thread zombie_death::flame_death_fx();
	}
	if( self.damagemod == "MOD_GRENADE" || self.damagemod == "MOD_GRENADE_SPLASH" ) 
	{
		level notify( "zombie_grenade_death", self.origin );
	}

	return false;
}

//--------------------------------------------------------------------------------------------------
//		SARAH AND THE TREE
//--------------------------------------------------------------------------------------------------
function sarah_at_stalingrad( a_ents )
{
	level endon("end_game");
	level endon("game_ended");
	level endon("zombies_completed");
	
	ai = GetEnt("sarah","targetname");
	sarah_goal = struct::get("tag_align_pavlovs_tree","targetname");	
	ai.script_friendname = "Sarah Hall";		
	
	level waittill("start_zombie_sequence");	

	level thread zombie_fire_wall_init();
	level thread zombie_barriers_init();

	level.barrier_occupied = 0;

	starttime = GetTime();

	//level thread check_round_timing( starttime );

	// minimum alive changed based on number of players for difficulty.
	//4 highest min for any number of players.
	if( level.players.size > 2 )
	{	
		level.zombie_total_min = int( 1 * level.players.size );
	}
	
	level thread round_think();

	level.pavlov_sarah = ai spawner::spawn( true );
	
	level.pavlov_sarah.goalradius = 32;
	level.pavlov_sarah SetTeam( "allies" );
	level.pavlov_sarah ai::set_ignoreall( true );
	level.pavlov_sarah ai::set_ignoreme( true );
	level.pavlov_sarah util::magic_bullet_shield();
	level.pavlov_sarah ai::gun_remove();
	level.pavlov_sarah.allowPain = false;
	level.pavlov_sarah.targetname = "sarah_stalingrad";

	level.pavlov_sarah thread scene::play( "cin_inf_16_01_nazizombies_vign_treemoment_gameplay_loop", level.pavlov_sarah );
	level.pavlov_sarah thread hideout_outro::pavlovs_temp_messages();

	//roots start growing into house
	level clientfield::set("zombie_root_grow", 1);

	level flag::wait_till( "zombies_final_round" ); //wait till final round to set up finale

	//override player damage for zombie finale, will end once players hit.
	level.overridePlayerDamage = &override_player_damage;

	//just to debug and see how many alive waiting for move out.
	//level thread check_num_alive();

	//wait for player to get hit
	level waittill( "sarah_begs_death" );

	//level.pavlov_sarah scene::stop(); //whatever scene is playing on her must stop
	level.pavlov_sarah scene::play( "cin_inf_16_01_nazizombies_vign_treemoment_talk02", level.pavlov_sarah ); //"how do I make this nightmare end..."
		
	//moves directly into moving out scene now.	
	level.pavlov_sarah thread scene::play( "cin_inf_16_01_nazizombies_vign_treemoment_outro", level.pavlov_sarah );

	level.pavlov_sarah notify( "running_out" );
	
	level waittill( "sarah_at_tree" );

	objectives::complete( "cp_level_infection_access_sarah" );
	objectives::set( "cp_level_infection_kill_sarah", level.pavlov_sarah );

	level flag::set( "sarah_tree" );

	level.pavlov_sarah infection_util::light_flash_dim( true );
	level.pavlov_sarah util::stop_magic_bullet_shield();
	level.pavlov_sarah SetTeam( "axis" );
	level.pavlov_sarah.allowPain = true;
	level.pavlov_sarah.overrideActorDamage = &callback_sarah_damaged;

	level.pavlov_sarah waittill("death");

	level.overridePlayerDamage = undefined;

	level flag::set("zombies_completed");
	level notify("end_round_think");
}

//need to cleanup as she dies
function callback_sarah_damaged( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	self.overrideActorDamage = undefined;
	
	objectives::complete( "cp_level_infection_kill_sarah", self );
		
	self infection_util::light_flash_dim( false );
		
	self thread scene::stop( "cin_inf_16_01_nazizombies_vign_treemoment_outro" );
	
	self Kill();
}

function pause_zombie_spawning()
{
	level flag::clear("spawn_zombies");

	timepassed = 0;
	starttime = GetTime();

	//30 seconds to kill all remaining zombies.
	while( ( zombie_utility::get_current_zombie_count() > 0 ) )
	{
		zombies = GetAiTeamArray( "axis" );
		for ( i = 0; i < zombies.size; i++ )
		{	
			if( !( isdefined( zombies[i] infection_util::player_can_see_me( 256 ) ) && zombies[i] infection_util::player_can_see_me( 256 ) ) )
			{
				zombies[i] Kill();
			}		
		}
		
		timepassed = (GetTime() - starttime) / 1000;
		if( timepassed >= 30 )
		{
			zombies = GetAiTeamArray( "axis" );
			for ( i = 0; i < zombies.size; i++ )
			{
				zombies[i] Kill();
			}			
			return;
		}

		wait(0.1);
	}
}		

function kill_all_zombies()
{
	level flag::clear("spawn_zombies");

	zombies = GetAiTeamArray( "axis" );
	for ( i = 0; i < zombies.size; i++ )
	{
		if(!IsSubStr( zombies[i].targetname, "sarah" ) )
		{	
			zombies[i] dodamage(zombies[i].health + 100, zombies[i].origin);
		}
	}	
}	

function check_round_timing( starttime )
{
	level endon("end_game");
	level endon("game_ended");	

	n_game_period = level.zombie_game_time / 4 ;
	starttime = 0;
	n_timepassed = 0;

	while(n_timepassed < level.zombie_game_time )
	{
		level waittill( "between_round_over" );

		n_timepassed = (GetTime() - starttime) / 1000;
		n_gametime = int( n_timepassed / n_game_period );
		
		//force round forward at specific game time segments.
		if( level.round_number < 	n_gametime )
		{
			if(n_gametime > 4) // never push past round 4 
			{
				n_gametime = 4;
			}		
			level.round_number = n_gametime;
		}		
	}	
}	

//--------------------------------------------------------------------------------------------------
//		PLAYER DAMAGE OVERRIDE
//--------------------------------------------------------------------------------------------------
function override_player_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	if( isdefined(eAttacker) )
	{
		if(!isdefined( self.numhits ) )
		{
			self.numhits = 0;
		}		
		self.numhits++;
	
		//if a player loses 1/2 health or gets hit 5 times total
		if( self.health < self.maxhealth / 2  || ( self.numhits === 5 ) )
		{	
			iDamage = 0;
			level thread sarah_flash_kill();
		}
	}
	
	return iDamage;
}

function sarah_flash_kill()
{
	level.pavlov_sarah thread infection_util::actor_camo( 0 );
	
	wait 1; //wait for fx to kick in.
	
	fadetowhite = newhudelem();

	fadetowhite.x = 0;
	fadetowhite.y = 0;
	fadetowhite.alpha = 0;

	fadetowhite.horzAlign = "fullscreen";
	fadetowhite.vertAlign = "fullscreen";
	fadetowhite.foreground = true;
	fadetowhite SetShader( "white", 640, 480 );
	fadetowhite.color = ( 0.5, 0.6, 1 );

	fadetowhite FadeOverTime( 0.2 );
	fadetowhite.alpha = 0.8;
	playsoundatposition( "evt_infection_thunder_special", (0,0,0) ); //TODO: should be a special sound
	
	//no more spawning, kill all zombies
	level flag::clear("spawn_zombies");
	level thread kill_all_zombies();

	wait 0.5;

	fadetowhite FadeOverTime( 1.0 );
	fadetowhite.alpha = 0;
		
	wait 1;
	fadetowhite destroy();

	wait 2; //wait for player to recover from zombie onslaught
	
	level notify( "sarah_begs_death" );
}

//--------------------------------------------------------------------------------------------------
//		ZOMBIE INFECTION ROUND SYSTEM
//--------------------------------------------------------------------------------------------------
function round_think()
{
	level endon("end_round_think");
	level endon("end_game");
	level endon("game_ended");

	SetRoundsPlayed( level.round_number );
	
	if( level.players.size == 1 ) //reducing for solo 
	{	
		level.zombie_ai_limit = 28;
	}
	
	while( true )
	{
		while( level.zombie_spawn_locations.size <= 0 )
		{
			wait( 0.1 );
		}
	
		level thread round_spawning();

		level notify( "start_of_round" );

		/# IPrintLnBold( "Round Number ", level.round_number ); #/

		round_wait();

		//if pausing zombie spawning pause rounds as well even if all killed off.
		level flag::wait_till( "spawn_zombies" );		

		level.first_round = false;
		level notify( "end_of_round" );

		if ( level.round_number >= 4 ) //pause zombies till sarah done with speach
		{
			level.pavlov_sarah pause_zombie_spawning();
			level notify( "sarah_speaks_surge" );	
		}
		
		// here's the difficulty increase over time area
		timer = level.zombie_vars["zombie_spawn_delay"];
		if ( timer > 0.08 )
		{
			level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;
		}
		else if ( timer < 0.08 )
		{
			level.zombie_vars["zombie_spawn_delay"] = 0.08;
		}

		level.round_number++;

		SetRoundsPlayed( level.round_number );

		level round_over();
		level notify( "between_round_over" );
	}
}

function round_over()
{
	time = level.zombie_vars["zombie_between_round_time"];
	wait( time );
}

function round_wait()
{
	level endon("restart_round");

	wait( 1 );

	while( 1 )
	{
		should_wait = ( zombie_utility::get_current_zombie_count() > level.zombie_total_min || level.zombie_total > level.zombie_total_min );	//will start next round with min zombies left instead of zero.
		if( !should_wait )
		{
			return;
		}			
			
		if( level flag::get( "end_round_wait" ) )
		{
			return;
		}
		wait( 1.0 );
	}
}

function round_spawning()
{
	level endon( "end_of_round" );


	if( level.zombie_spawn_locations.size < 1 )
	{
		ASSERTMSG( "No active spawners in the map.  Check to see if the zone is active and if it's pointing to spawners." ); 
		return; 
	}

	infection_calculate_health( level.round_number ); 

	count = 0; 

	max = level.zombie_ai_limit;

	multiplier = level.round_number / 5;
	if( multiplier < 1 )
	{
		multiplier = 1;
	}

	if( level flag::get( "sarah_tree" ) )
	{
		multiplier *= level.round_number * 0.15;
	}

	player_num = GetPlayers().size;

	if( player_num == 1 )
	{
		max = int( max * multiplier ); 
	}
	else
	{
		max += int( ( ( player_num - 1 ) * level.zombie_vars["zombie_ai_per_player"] ) * multiplier ); 
	}

	if( !isDefined( level.max_zombie_func ) )
	{
		level.max_zombie_func = &zombie_utility::default_max_zombie_func;
	}
	
	//any zombies left from last round? does not have to be zero for infection, could be less than min if grenade, etc.
	old_total = level.zombie_total; 
		
	level.zombie_total = [[ level.max_zombie_func ]]( max );
		
	//add them back into this round. so round doesn't end with less zombies killed.	
	level.zombie_total = level.zombie_total + old_total; 
	level notify( "zombie_total_set" );
	
	if ( level.round_number < 10 || level.speed_change_max > 0 )
	{
		level thread zombie_utility::zombie_speed_up();
	}

	while( 1 )
	{
		while( zombie_utility::get_current_zombie_count() >= level.zombie_ai_limit  || level.zombie_total <= 0 )
		{
			wait( 0.1 );
		}
		
		while ( zombie_utility::get_current_actor_count() >= level.zombie_actor_limit )
		{
			zombie_utility::clear_all_corpses();
			wait( 0.1 );
		}

		// added ability to pause zombie spawning
		level flag::wait_till( "spawn_zombies" );
		
		while( level.zombie_spawn_locations.size <= 0 )
		{
			wait( 0.1 );
		}
		
		if( IsDefined( level.zombie_spawners ) )
		{
			spawner = array::random( level.zombie_spawners );		

			ai = zombie_utility::spawn_zombie( spawner, spawner.targetname ); 
 		}
 		
		if( IsDefined( ai ) )
		{
			level.zombie_total--;
			ai thread zombie_utility::round_spawn_failsafe();
			count++; 
		}

		//spawn all zombies quickly in round one so at barriers fast
		time = level.zombie_vars["zombie_spawn_delay"];
		if ( level.round_number == 1 )
		{
			time = level.zombie_vars["zombie_spawn_delay"] * 0.25;
		}		

		wait( time ); 
		util::wait_network_frame();
	}
}	

//--------------------------------------------------------------------------------------------------
//	No PLAYER TO PATH TO
//--------------------------------------------------------------------------------------------------
function zombie_bad_path()
{
	self endon("death");
	
	self.b_zombie_path_bad = false;

	level.a_s_zombie_escape = struct::get_array("zombie_escape_point", "targetname");
	
	while(1)
	{
		if ( !self.b_zombie_path_bad )
		{	
			while(self can_zombie_see_any_player())
			{
				wait(0.5);
			}	
		}
		
		found_player = undefined;

		foreach( e_player in level.players )
		{
			if( ( isdefined( zombie_utility::is_player_valid(e_player) ) && zombie_utility::is_player_valid(e_player) ) && self MayMoveToPoint( e_player.origin, true ) )
			{
				self.favoriteenemy = e_player;
				found_player = true;
				continue;
			}
		}

		if ( !IsDefined( found_player ) )
		{
			self.b_zombie_path_bad = true;

			self escaped_zombies_cleanup();
		}
		
		wait 0.1;
	}	
}

function private escaped_zombies_cleanup()
{
	self endon("death");
	
	s_escape = self get_escape_position();
	
	self notify( "stop_find_flesh" );
	self notify( "zombie_acquire_enemy" );	
	self ai::set_ignoreall( true );

	if ( IsDefined( s_escape ) )
	{
		self setgoalpos( s_escape.origin );
			
		self thread check_player_available();
		
		self util::waittill_any( "goal", "reaquire_player" );
	}
	
	wait 0.1;
	
	if ( !self.b_zombie_path_bad )
	{
		self.ai_state = "find_flesh";
		self ai::set_ignoreall( false );
	}
}

function private get_escape_position()  // self = AI
{
	self endon( "death" );
	
	s_farthest = self get_farthest_location( level.a_s_zombie_escape );
	
	return s_farthest;
}

function private get_farthest_location( locations )
{
	n_farthest_index = 0;  // initialization
	n_distance_farthest = 0;
	
	for ( i = 0; i < locations.size; i++ )
	{
		n_distance_sq = DistanceSquared( self.origin, locations[ i ].origin );
		
		if ( n_distance_sq > n_distance_farthest )
		{
			n_distance_farthest = n_distance_sq;
			n_farthest_index = i;
		}
	}
	
	return locations[ n_farthest_index ];
}

function private check_player_available()  // self = AI
{
	self notify( "_check_player_available" );  // only one copy of this thread per zombie
	self endon( "_check_player_available" );
	
	self endon("death");
	self endon("goal");

	while ( self.b_zombie_path_bad )
	{
		wait RandomFloatRange( 0.2, 0.5 );
		
		if ( self can_zombie_see_any_player() )
		{
			self.b_zombie_path_bad = false;
			self notify( "reaquire_player" );
			return;
		}
	}
}	

function private can_zombie_see_any_player()  // self = AI
{
	for ( i = 0; i < level.players.size; i++ )
	{
		if( !zombie_utility::is_player_valid( level.players[i] ) )
		{
			continue;
		}
		
		player_origin = level.players[i].origin;
		
		if ( self FindPath(self.origin, player_origin, true, false))
		{
			return true;
		}
	}	
	
	return false;
}

//--------------------------------------------------------------------------------------------------
//		ZOMBIE WALL OF FIRE
//--------------------------------------------------------------------------------------------------
function zombie_fire_wall_init()
{
	//find fire damage trigger
	t_fire_trig = GetEnt("pavlov_house_fire","targetname");
	assert(IsDefined(t_fire_trig),"Couldn't find fire trigger" );

	//pavlov_house_fire_warning
	t_fire_warning_trig = GetEnt("pavlov_house_fire_warning","targetname");
	
	//spawn firewall align/movement model
	wall_pos = struct::get("firewall_align","targetname");
	assert(IsDefined(wall_pos),"Couldn't find fire align struct" );

	e_fire_wall	= util::spawn_model( "tag_origin", wall_pos.origin, wall_pos.angles );		
	e_fire_wall.targetname = "firewall_firepos";
	e_fire_wall clientfield::set("zombie_fire_wall_fx", 1);
	e_fire_wall clientfield::set("zombie_fire_backdraft_fx", 1);

	fxpos = struct::get_array("zombie_fire_wall", "targetname");
	foreach( pos in fxpos )
	{
		firepos = util::spawn_model("tag_origin", pos.origin, pos.angles );
		firepos linkto( e_fire_wall );
		firepos.targetname = "firewall_firepos";
		firepos clientfield::set("zombie_fire_wall_fx", 1);
	}
		
	t_fire_trig EnableLinkTo();
	t_fire_trig LinkTo(e_fire_wall);

	t_fire_warning_trig EnableLinkTo();
	t_fire_warning_trig LinkTo(e_fire_wall);

	final_pos = struct::get("final_fire_pos", "targetname");
	if(!IsDefined(final_pos))
	{
		pos = (e_fire_wall.origin[0] - 1292, e_fire_wall.origin[1], e_fire_wall.origin[2]);
	}
	else
	{
		pos = final_pos.origin;
	}				

	time  = ( level.zombie_game_time * 0.75 );

	//if using at tree skipto move firewall to end point.
	if(( isdefined( level.city_skipped ) && level.city_skipped ))
	{
		time = 0.1;
	}

	e_fire_wall MoveTo(pos, time);
	t_fire_trig thread zombie_fire_watcher();
	
	foreach(player in level.players)
	{
		player thread player_fire_damage( t_fire_trig, t_fire_warning_trig );
	}	
}

//--------------------------------------------------------------------------------------------------
function zombie_fire_watcher()
{
	while(true)
	{
		zombies = GetAiTeamArray( "axis" );
		
		num_on_fire = zombies num_zombies_on_fire();
		if(num_on_fire < 6 )
		{	
			for( i=0; i < zombies.size; i++ )
			{
				if(zombies[i] IsTouching(self) && !( isdefined( zombies[i].on_fire ) && zombies[i].on_fire ) && num_on_fire < 6)
				{
					zombies[i].on_fire = true;
					num_on_fire++;
					zombies[i] thread set_zombie_on_fire();
				}		
			}
		}
		wait 1;	
	}	
}	

function num_zombies_on_fire()
{
	num = 0;
	for( i=0; i < self.size; i++ )
	{
		if(( isdefined( self[i].on_fire ) && self[i].on_fire ))
		{	
			num++;
		}	
	}
	
	return num;
}

function set_zombie_on_fire()
{
	self endon("death");
	
	chance = RandomInt(10);
	
	self playloopsound( "chr_burn_start_loop", 1 );
	
	if(chance <= 2)
	{			
		PlayFXOnTag( level._effect[ "burn_loop_zombie_left_arm" ], self, "J_Elbow_LE" );
	}
	else if(chance <= 5)
	{	
		PlayFXOnTag( level._effect[ "burn_loop_zombie_right_arm" ], self, "J_Elbow_RI" );
	}
	else 
	{	
		PlayFXOnTag( level._effect[ "burn_loop_zombie_torso" ], self, "J_Spine4" );	
	}
}		

function player_fire_damage( trig, warning_trig )
{	
	//TODO: get fire fx for burning player added back in.
	self clientfield::set_to_player("zombie_fire_overlay_init", 1);
	
	self endon("death");
	self endon("disconnect");
	
	if( !isdefined( self.sndFireEnt ) )
	{
		self.sndFireEnt = spawn( "script_origin", self.origin );
		self.sndFireEnt linkto( self );
	}

	while(true)
	{
		//will trigger warning_trigger first
		warning_trig waittill("trigger", who);
		if(who == self)
		{	
			while( self IsTouching(trig) || self IsTouching(warning_trig) || (self.health != self.maxhealth))
			{
				n_intensity_amount = math::linear_map( self.maxhealth - self.health, 0, self.maxhealth, 0.15, 1.00 );
				self clientfield::set_to_player( "zombie_fire_overlay", n_intensity_amount );
				self.sndFireEnt playloopsound( "chr_burn_start_loop", .5 );
				wait 0.1;	
			}
			self clientfield::set_to_player( "zombie_fire_overlay", 0 );
			self.sndFireEnt stoploopsound( 1 );
		}	
		wait 0.1;
	
	}	
}

//--------------------------------------------------------------------------------------------------
//		ZOMBIE BARRIERS
//--------------------------------------------------------------------------------------------------
function zombie_barriers_init()
{
	level thread scene::init( "p7_fxanim_cp_infection_house_ceiling_enter_01_bundle" );
	level thread scene::init( "p7_fxanim_cp_infection_house_ceiling_enter_02_bundle" );
	level thread scene::init( "p7_fxanim_cp_infection_house_wall_enter_01_bundle" );
	level thread scene::init( "p7_fxanim_cp_infection_house_wall_enter_02_bundle" );

	
	level.barriers = struct::get_array("zombie_barrier","targetname");
	foreach(barrier in level.barriers)
	{
		barrier.scenes = []; //array of scenes used for each barrier
		
		//if skipping to end skipto city_tree remove all barriers
		if(( isdefined( level.city_skipped ) && level.city_skipped ))
		{
			level thread scene::skipto_end( "p7_fxanim_cp_infection_house_ceiling_enter_01_bundle" );
			level thread scene::skipto_end( "p7_fxanim_cp_infection_house_ceiling_enter_02_bundle" );
			level thread scene::skipto_end( "p7_fxanim_cp_infection_house_wall_enter_01_bundle" );
			level thread scene::skipto_end( "p7_fxanim_cp_infection_house_wall_enter_02_bundle" );			
			
			parts = GetEntArray(barrier.target, "targetname");
			for( i = 0; i < parts.size; i++ )
			{
				parts[i] Hide();
				parts[i] NotSolid();
			}
			barrier.opened = true;
		}
		else
		{	
			//Find the lookat trigger for each barrier and assign it.
			parts = GetEntArray(barrier.target, "targetname");
			for( i = 0; i < parts.size; i++ )
			{
				if( ( parts[i].script_noteworthy === "lookat_barrier" ) )
				{	
					barrier.look_trig = parts[i];
				}
				else if( ( parts[i].script_noteworthy === "clip" ) )
				{
					barrier.clip = parts[i];
				}		 	
			}
			
			//init all barrier scriptbundles associated with barrier.
			a_bundle = struct::get_array( barrier.target, "targetname" );
			for( i = 0; i < a_bundle.size; i++ )
			{
				if( ( a_bundle[i].script_noteworthy === "tearin_bundle" ) )
				{
					a_bundle[i] scene::init( a_bundle[i].scriptbundlename );
					array::add( barrier.scenes, a_bundle[i], false );
				}		
			}	
			
			for( i=0; i < level.zombie_spawn_locations.size; i++ )
			{
				if ( ( level.zombie_spawn_locations[i].script_linkto === barrier.script_string ) )
				{
					level.zombie_spawn_locations[i].barrier = barrier;
					break;
				}	
			}
			
			type  = barrier.script_noteworthy;
			
			switch ( type )
			{
				case "wall_filler":
					barrier.bundlename = "cin_inf_16_01_nazizombies_vign_tearins_wallbreak_pull_";
					barrier.num_parts = 2;
					if( ( barrier.script_string === "wall_barrier1" ) )
					{	
						barrier.fxanim = "p7_fxanim_cp_infection_house_wall_enter_01_bundle";
					}
					else
					{
						barrier.fxanim = "p7_fxanim_cp_infection_house_wall_enter_02_bundle";
					}		
					break;
				case "ceiling_filler_bedroom":
					barrier.bundlename = "cin_inf_16_01_nazizombies_vign_tearins_ceiling_bedroom_pull_";
					barrier.fxanim = "p7_fxanim_cp_infection_house_ceiling_enter_01_bundle";
					barrier.num_parts = 4;
					break;
				case "ceiling_filler_frontroom":
					barrier.bundlename = "cin_inf_16_01_nazizombies_vign_tearins_ceiling_frontroom_pull_";
					barrier.fxanim = "p7_fxanim_cp_infection_house_ceiling_enter_02_bundle";
					barrier.num_parts = 4;
					break;			
			}			
			
			barrier.opened = false;
		}
	}
}

function zombie_to_barrier( spot )
{
	barrier_pos = spot.barrier;
	assert(IsDefined(barrier_pos), "No barrier to open");

	if(( isdefined( barrier_pos.opened ) && barrier_pos.opened ))
	{
		self notify("risen", spot.script_string );
		return;
	}	
	
	self endon("death");
	
	//this shouldn't be necessary
	self.favoriteenemy = undefined;

	goalradius_old = self.goalradius;
	self.goalradius = 4;
	
	self SetGoal( barrier_pos.origin, true );

	self waittill( "goal" );
	self PathMode( "dont move" );
	self.goalradius = goalradius_old;
	self.is_inert = true;

	//if barrier has a lookat trigger, give some time to lookat before timing out.
	if(IsDefined( barrier_pos.look_trig ))
	{
		barrier_pos trigger_wait_timeout( 30 );
	}		

	//door and windows have barrier models in scriptbundle
	if( ( barrier_pos.script_noteworthy === "door_filler" ) || ( barrier_pos.script_noteworthy === "window_filler" ) )
	{
		self thread zombie_scriptbundle_barrier( spot );
		return;
	}	
	// others are zombie animations only
	else if(isdefined(barrier_pos.script_noteworthy))
	{	
		self thread play_zombie_barrier_anim( spot );

		self waittill("barrier_note");
	
		if( isdefined( barrier_pos.fxanim ) )
		{	
			level thread scene::play( barrier_pos.fxanim );
		}
	}
}

function play_zombie_barrier_anim( spot )
{
	barrier_pos = spot.barrier;

	self endon("death");

	if( !isdefined( barrier_pos.anim_num ) )
	{
		barrier_pos.anim_num = 1;
	}	

	//make sure in the right position
	self ForceTeleport( barrier_pos.origin, barrier_pos.angles);

	while( !( isdefined( barrier_pos.opened ) && barrier_pos.opened ) )
	{
		self thread scene::play( barrier_pos.bundlename + barrier_pos.anim_num, self );		

		notetrack = "destroy_piece";
		self waittill( notetrack );
		self notify("barrier_note");
		
		self waittill( "scene_done" );

		if ( barrier_pos.anim_num < barrier_pos.num_parts )
		{
			barrier_pos.anim_num++;
		}
		else // final part exit
		{
			barrier_pos.opened = true;		
		}		
	}
	
	//set zombie into attack state.
	self notify("risen", spot.script_string );
	self.is_inert = false;

	if( isdefined( barrier_pos.clip ) )
	{	
		barrier_pos.clip NotSolid();
		barrier_pos.clip ConnectPaths();	
	}
	
	spot.barrier = undefined;
	spot.occupied = undefined;	
}

function trigger_wait_timeout( time )
{
	self.look_trig thread timeout_notify( time );
	self.look_trig thread player_looked_at();

	self.look_trig util::waittill_any( "timeout", "was_seen" );

	if(IsDefined( self.look_trig ))
	{	
		self.look_trig delete();
	}
}

function player_looked_at()
{
	self endon("timeout");
	self endon("was_seen");
	
	while( true )
	{	
		self waittill( "trigger", who);

		if(( isdefined( zombie_utility::is_player_valid( who ) ) && zombie_utility::is_player_valid( who ) ))
		{
			self notify( "was_seen" );
			return;
		}
	}
	
}	

function timeout_notify( time )
{
	self endon("timeout");
	self endon("was_seen");
	
	end_time = gettime() + ( time * 1000 );
	while( GetTime() < end_time )
	{	
		wait 0.1;
		
		if(!IsDefined(self))
		{
			return;
		}		
	}
	
	self notify( "timeout" );
}	

function zombie_scriptbundle_barrier( spot )
{
	self endon( "death" );
	barrier_pos = spot.barrier;

	//make sure in the right position
	self ForceTeleport( barrier_pos.origin, barrier_pos.angles);

	while( barrier_pos.scenes.size > 0 )
	{
		if( !isdefined( barrier_pos.scene_num ) )
		{
			barrier_pos.scene_num = 1;
		}		
		
		//select bundles in order
		for( i = 0; i < barrier_pos.scenes.size; i++ )
		{
			if( IsSubStr( barrier_pos.scenes[i].scriptbundlename, "_" + barrier_pos.scene_num ) )
			{
				str_scene = barrier_pos.scenes[i].scriptbundlename;
				s_scene = barrier_pos.scenes[i];
				break;
			}
		}			

		s_scene scene::play( str_scene, self );
			
		barrier_pos.scene_num++;
		ArrayRemoveValue( barrier_pos.scenes, s_scene );
	}		

	//set zombie into attack state.
	self notify("risen", spot.script_string );
	self.is_inert = false;

	if( isdefined( barrier_pos.clip ) )
	{	
		barrier_pos.clip NotSolid();
		barrier_pos.clip ConnectPaths();	
	}
	
	spot.barrier = undefined;
	spot.occupied = undefined;
	barrier_pos.opened = true;		
}	
