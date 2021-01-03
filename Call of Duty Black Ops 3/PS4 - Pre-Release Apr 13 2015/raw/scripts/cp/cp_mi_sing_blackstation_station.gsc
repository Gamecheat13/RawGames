#using scripts\codescripts\struct;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;

#using scripts\cp\cp_mi_sing_blackstation;
#using scripts\cp\cp_mi_sing_blackstation_utility;

#using scripts\shared\ai\archetype_warlord_interface;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       





#precache( "triggerstring" , "CP_MI_SING_BLACKSTATION_USE_ZIPLINE" );
#precache( "triggerstring" , "CP_MI_SING_BLACKSTATION_OPEN_DOOR" );

#precache( "material" , "t7_hud_prompt_push_64" );

function station_main()
{
	level thread ally_behaviors();
	level thread station_waypoints();
	level thread lightning_strike();
	level thread setup_zipline_down( "trig_zipline01" );
	level thread setup_zipline_down( "trig_zipline02" );
	level thread technical_1_spawning();
	level thread technical_2_spawning();
	level thread technical_3_spawning();
	level thread exterior_ai_spawning();
	
	spawner::add_spawn_function_group( "exterior_robots_guards" , "script_aigroup" , &guard_behavior );
	spawner::add_spawn_function_group( "exterior_robots_pathers" , "script_aigroup" , &pather_behavior );
	spawner::add_spawn_function_group( "lightning_struck_gib" , "script_noteworthy" , &robot_lightning_behavior );
	spawner::add_spawn_function_group( "lightning_struck_shock" , "script_noteworthy" , &robot_lightning_behavior );
	spawner::add_spawn_function_group( "lightning_launch_ai" , "script_noteworthy" , &lightning_launch_ai );
	spawner::add_spawn_function_group( "exterior_gunner_front" , "script_noteworthy" , &lightning_launch_ai );
	spawner::add_spawn_function_group( "blackstation_warlord_spawner" , "script_noteworthy" , &warlord_behavior );
	
	a_starting_robots = spawner::simple_spawn( "exterior_robots" , &starting_ai_behavior );
	
	spawner::add_spawn_function_group( "exterior_patroller" , "script_noteworthy" , &patroller_behavior );
	a_starting_humans = spawner::simple_spawn( "exterior_group01" , &starting_ai_behavior );
	
	level.a_starting_ai = ArrayCombine( a_starting_robots , a_starting_humans , true , false );
	
	level flag::wait_till( "exterior_ready_weapons" );
	
	blackstation_utility::set_low_ready_movement( false );
}

function objective_blackstation_exterior_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		blackstation_utility::init_hendricks( "objective_blackstation_exterior" );
		blackstation_utility::init_kane( "objective_blackstation_exterior" );
		//move allies into position
		level.ai_kane SetGoal( GetNode( "kane_blackstation_exterior" , "targetname" ) );
		trigger::use( "trig_hendricks_color_node_b12", "targetname" );
		
		level flag::wait_till( "all_players_spawned" );
		
		level thread blackstation_utility::lightning_flashes( "lightning_looting", "hendricks_at_window" );
	}
	
	level thread blackstation_utility::player_rain_intensity( "med" );
	
	station_main();
}

function objective_blackstation_exterior_done( str_objective, b_starting, b_direct, player )
{
	
}

function station_waypoints()
{
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_station00" ) );
	
	trigger::wait_till( "trig_waypoint_station00" );
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_station00" ) );
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_station01" ) );
	
	trigger::wait_till( "trig_waypoint_station01" );
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_station01" ) );
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_station02" ) );
	
	skipto::objective_completed( "objective_blackstation_exterior" );
	
	trigger::wait_till( "trig_waypoint_station02" );
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_station02" ) );
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_station03" ) );

	trigger::wait_till( "trig_waypoint_station03" );
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_station03" ) );
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_station04" ) );
}

function track_location_for_low_ready() //self = player
{
	self endon( "death" );
	self endon( "used_zipline" );
	
	trigger::wait_till( "trig_waypoint_station00" , "targetname" , self );
	
	blackstation_utility::set_low_ready_movement( true , self );
	
	do
	{
		wait 1;
	}
	while ( self isTouching( GetEnt( "trig_waypoint_station00" , "targetname" ) ) );
	
	blackstation_utility::set_low_ready_movement( false , self );
	
	if ( !level flag::get( "exterior_ready_weapons" ) )
	{
		self track_location_for_low_ready();
	}
}

function ally_behaviors()
{
	if ( !isdefined( level.ai_kane ) )
	{
		blackstation_utility::init_kane( "objective_blackstation_exterior" );
	}
	
	level.ai_hendricks.ignoreall = true;
	level.ai_kane.ignoreall = true;
	
	foreach ( player in level.players )
	{
		player thread track_location_for_low_ready();
	}
	
	trigger::wait_till( "trig_waypoint_station00" );
	
	level.ai_kane dialog::say( "Black Station is at the end of that street - and swarming with 54I." , 1 );
	level.ai_kane dialog::say( "We need to get down there and stop them. I'll take overwatch from here." );
	level.ai_hendricks thread dialog::say( "Hold fire until we're in position. Let's go." );
	
	level flag::set( "ziplines_ready" );
	
	level thread zipline_allies( level.ai_hendricks );
	
	level flag::wait_till( "zipline_player_landed" );
	
	level thread hendricks_dialog();
	
	level flag::wait_till( "blackstation_exterior_engaged" );
	
	level.ai_hendricks.ignoreall = false;
	level.ai_kane.ignoreall = false;
	level.ai_kane.engageMaxDistance = 5500;
	
	trigger::use( "trig_exterior_color01" );
	
	level flag::wait_till( "kane_move_up" ); //flag set on trigger in radiant
	
	zipline_allies( level.ai_kane );
	
	level flag::wait_till( "kane_landed" );
	
	level.ai_kane colors::set_force_color( "y" );
	
	trigger::use( "trig_exterior_color01" , "targetname" );
	
	level.ai_kane LaserOn();
	
	level thread kane_take_out_enemies();
	
	trigger::wait_till( "trig_blackstation_interior" );
	
	level.ai_kane LaserOff();
}

function hendricks_dialog()
{
	level thread hendricks_open_fire();
	
	level.ai_hendricks thread dialog::say( "Move forward. Heads down, everyone." , 0.5 );
	
	level util::waittill_notify_or_timeout( "exterior_moved_forward" , 30 );
	
	level.ai_hendricks dialog::say( "Got a truck moving in. Kane - on my mark, take out that gunner." );
	
	level flag::set( "exterior_ready_weapons" );
	
	level flag::wait_till( "truck_in_position" );
	
	level dialog::remote( "I have a shot. Ready for-" );
	
	level flag::set( "lightning_strike" );
	level flag::wait_till( "lightning_strike_done" );
	
	GetEnt( "blackstation_exterior_weapon_clip" , "targetname" ) Delete();
	
	if ( !level flag::get( "blackstation_exterior_engaged" ) )
	{
		level.ai_hendricks dialog::say( "They're scattering, open fire!" );
	}
	
	level flag::set( "blackstation_exterior_engaged" );
}

function hendricks_open_fire()
{
	level endon( "lightning_strike_done" );
	
	level flag::wait_till( "blackstation_exterior_engaged" );
	
	level.ai_hendricks dialog::say( "Too soon damnit, open fire!" , .5 );
}

function kane_take_out_enemies()
{
	level endon ( "trig_blackstation_interior" );
	
	while( true )
	{
		a_players = ArrayCopy( level.players );
		array::randomize( a_players );
		a_enemies = GetAITeamArray( "axis" );
		for( i = a_enemies.size - 1; i >= 0; i -- )
		{
			if( IsDefined( a_enemies[i].script_noteworthy ) && a_enemies[i].script_noteworthy == "blackstation_warlord_spawner" )
			{
				ArrayRemoveIndex( a_enemies, i );
			}
		}
		
		foreach( player in a_players )
		{
			for( i = 0; i < a_enemies.size; i ++ )
			{
				if( IsAlive( a_enemies[i] ) && 
				   player util::is_player_looking_at( a_enemies[i].origin, 0.7, true ) && 
				   SightTracePassed( level.ai_kane GetTagOrigin( "tag_eye" ), a_enemies[i].origin + ( 0, 0, 64 ) , false, player ) )
				{
					level.ai_kane ai::set_ignoreme( true );
					level.ai_kane thread ai::shoot_at_target( "shoot_until_target_dead", a_enemies[i], "j_head" );
					//MagicBullet( level.ai_kane.weapon, level.ai_kane GetTagOrigin( "tag_flash" ), a_enemies[i] GetTagOrigin( "tag_eye" ), level.ai_kane, a_enemies[i] );
					
					if( a_enemies[i].archetype == "human" )
					{
						a_enemies[i] fx::play( "blood_headpop" , undefined, undefined, undefined, true, "j_head", true );
					}
					
					a_enemies[i] Kill();
					
					switch( RandomInt( 2 ) )
					{
						case 0:
							level.ai_kane dialog::say( "Target down" ); 
							break;
							
						case 1:
							level.ai_kane dialog::say( "Dropped 'em" ); 
							break;	
					}
					
					level.ai_kane ai::set_ignoreme( false );
					
				}
				
			}
				
		}
		
		wait RandomIntRange( 5, 10 ); //wait to find another target
	}
	
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// LIGHTNING
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function lightning_ambient_strikes() //TODO temp mockup
{
	//One-off strike should fire right as player finishes zipline up. This struct is most in-view from top of tower.
	level fx::play( "lightning_strike" , struct::get( "station_ambient_strike8" ).origin ); //TODO temp FX
	
	wait 5; //brief wait before another strike plays
	
	a_structs = struct::get_array( "station_ambient_strike" , "script_noteworthy" );
	
	time = 15;
	
	while ( true ) //TODO set end condition for this
	{
		if ( a_structs.size == 1 ) 
		{	
			i = 0; //only one more strike location unplayed, set it to play next
		}
		else
		{
			i = RandomInt( a_structs.size - 1 ); //more than one location unplayed, choose one at random
		}
		
		level fx::play( "lightning_strike" , a_structs[i].origin ); //TODO temp FX
		
		ArrayRemoveIndex( a_structs , i ); //remove played loc from array
		
		wait RandomFloatRange( time , ( time + 10 ) ); //randomize strike timing
		
		if ( time > 4 )
		{
			time--; //increase frequency of strikes over time, up to a point
		}
		
		if ( a_structs.size == 0 )
		{	
			a_structs = struct::get_array( "station_ambient_strike" , "script_noteworthy" ); //no more strike locations unplayed, reset array
		}
	}
}

function lightning_look_trigger()
{
	level endon( "lightning_strike_done" );
	
	level flag::wait_till( "exterior_ready_weapons" );
	
	wait 2; //give a moment for gun to raise
	
	trigger::wait_till( "trig_lightning_look" , "targetname" );
	
	level flag::set( "lightning_strike" );
}

function lightning_strike()
{
	//level thread lightning_look_trigger(); //might bring this back at some point, but not needed for now
	
	level flag::wait_till( "lightning_strike" );
	
	level exploder::exploder_duration( "lightning_strike", 0.5 );
	
	level fx::play( "lightning_strike", struct::get( "station_strike01" ).origin, ( -90, 0, 0 ) ); //TODO temp FX
	
	wait 0.5; //pause for pacing, let fx and anims play a bit
	
	level flag::set( "lightning_strike_done" );
}

function lightning_launch_ai() //self = ai launched by lightning
{
	self endon( "death" );
	
	level flag::wait_till( "lightning_strike" );
	
	wait .2; //brief delay to let lightning FX play
	
	if ( self.script_noteworthy === "exterior_gunner_front" ) //launch the truck gunner
	{
		//this gets him out of the turret use animation
		self thread animation::play( self.rider_info.RideDeathAnim ); 
		
		self StartRagDoll();
		self LaunchRagDoll( ( 50, 0 , 90 ) );
		
		//cleanup vehicle stuff so others can still use turret
		self flagsys::clear( "in_vehicle" );
		vehicle::unclaim_position( self.vehicle, self.rider_info.position );
		self.vehicle = undefined;	
		self.rider_info = undefined;
		self animation::set_death_anim( undefined );
	}
	else
	{
		self StartRagDoll();
		self LaunchRagDoll( ( -50, -80, 70 ) );
	}
	
	level flag::wait_till( "blackstation_exterior_engaged" ); //prevents other AI from aggroing when this guy is killed
		
	self Kill();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// AI BEHAVIORS
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function exterior_ai_spawning()
{
	level flag::wait_till( "blackstation_exterior_engaged" );
	
	foreach ( ai in level.a_starting_ai )
	{
		if ( isdefined( ai ) )
		{
			ai notify( "under_attack" );  //notify other ai to stop ignoreall
		}
	}
	
	level.a_starting_ai = [];
	
	wait 3; //delay for pacing before sending in more spawns
	
	spawner::simple_spawn( "exterior_group02" ); //bring in the next set of ai spawns
	
	spawner::waittill_ai_group_ai_count( "exterior_front_group" , 5 ); //wait till most ai have been killed
	
	a_ai_group02 = GetAIArray( "exterior_front_group" , "script_aigroup" );
	
	foreach( ai in a_ai_group02 )
	{
		ai thread exterior_retreat();
	}
	
	wait 5; //give the players some time to regroup
	
	spawn_manager::enable( "exterior_group03_sm" );
	
	level flag::set( "exterior_truck_event" );
	
	level.ai_hendricks colors::disable(); //keeps hendricks from running at the truck
	
	level.ai_hendricks ai::set_behavior_attribute( "can_be_meleed" , false ); //TODO temp, prevents warlord from getting stuck up on Hendricks until his behaviors can be cleaned up
	
	spawn_manager::wait_till_complete( "exterior_group03_sm" );
	
	level.ai_hendricks colors::enable();
	
	trigger::use( "trig_hendricks_cross_street" , "targetname" ); //makes hendricks resume movement towards station
}

function warlord_behavior() //self = warlord
{
	a_warlord_nodes = GetNodeArray( "black_station_warlord_preferred_node", "targetname" );
	
	foreach ( node in a_warlord_nodes )
	{
		self WarlordInterface::AddPreferedPoint( node.origin, 5000, 10000 );
	}
	
	self waittill( "death" );

	//end group spawn once the warlord has been killed 
	spawn_manager::kill( "exterior_group03_sm" );
		
}

function exterior_retreat() //self = ai running away
{
	self endon( "death" );
	
	self SetGoal( GetEnt( "exterior_retreat_goal" , "targetname" ) );
	
	wait 4; //move normally at first, but then sprint once on the move for a few seconds
	
	self ai::set_behavior_attribute( "sprint" , true );
}

function technical_1_spawning()
{	
	vh_technical = vehicle::simple_spawn_single( "exterior_technical01" );
	
	vh_technical vehicle::lights_on();
	
	level flag::wait_till( "ziplines_ready" );
	
	vh_technical thread truck_notify();
	
	vh_technical thread vehicle::get_on_and_go_path( GetVehicleNode( vh_technical.target , "targetname" ) );
	
	level waittill( "truck_pause" );
	
	vh_technical SetSpeed( 0, 35, 35 );
	
	level flag::wait_till_any( Array( "exterior_ready_weapons" , "exterior_moved_forward" , "blackstation_exterior_engaged" ) );
	
	vh_technical ResumeSpeed( 35 );
	
	level flag::wait_till( "lightning_strike" );
	
	vh_technical DoDamage( vh_technical.health + 100, vh_technical.origin, undefined, undefined, undefined, "MOD_EXPLOSIVE" );

	trigger::wait_till( "trig_waypoint_station01" );
	
	vh_technical turret::enable_auto_use( false ); //prevents ai inside station from trying to use turret
}

function truck_notify() //self = technical #1
{
	level waittill( "truck_in_position" ); //set on path node in radiant
	
	level flag::set( "truck_in_position" );
}

function technical_2_spawning()
{
	vh_technical = vehicle::simple_spawn_single( "exterior_technical02" );
	
	level flag::wait_till( "exterior_truck_event" );
	
	wait 2; //wait a few seconds in case the player sprints ahead and triggers both cars 
	
	//this lets players use the turret
	vh_technical MakeVehicleUsable();
	vh_technical SetSeatOccupied( 0 );
	
	vh_technical turret::enable( 1, true );
	
	vh_technical thread vehicle::get_on_and_go_path( GetVehicleNode( vh_technical.target , "targetname" ) );
	
	vh_technical vehicle::lights_on();
	
	vh_technical waittill( "reached_end_node" );
	
	vh_technical turret::enable_auto_use( true ); //TODO turn this back on once bug is fixed (warlord tries to use turret, spits out SRE)
	
	wait 3; //wait before driver gets out to fight
	
	ai_driver = vh_technical vehicle::get_rider( "driver" );
	
	if ( isdefined( ai_driver ) )
	{
		ai_driver vehicle::get_out();
	}
	
	ai_passenger = vh_technical vehicle::get_rider( "passenger1" );
	
	if ( isdefined( ai_passenger ) )
	{
		ai_passenger vehicle::get_out();
	}
	
	trigger::wait_till( "trig_waypoint_station01" );
	
	vh_technical turret::enable_auto_use( false );	 //prevents ai inside station from trying to use turret
}

function technical_3_spawning()
{
	vh_technical = vehicle::simple_spawn_single( "exterior_technical03" );

	level flag::wait_till( "kane_move_up" );
	
	vh_technical thread vehicle::get_on_and_go_path( GetVehicleNode( vh_technical.target , "targetname" ) );
	
	vh_technical vehicle::lights_on();
	
	vh_technical ResumeSpeed( 35 );
	
	//this lets players use the turret
	vh_technical MakeVehicleUsable();
	vh_technical SetSeatOccupied( 0 );
	
	//this lets any ai use the turret
	vh_technical turret::enable( 1 , true );
	vh_technical turret::enable_auto_use();
	
	vh_technical waittill( "reached_end_node" );
	
	ai_driver = vh_technical vehicle::get_rider( "driver" );
	
	if ( isdefined( ai_driver ) )
	{
		ai_driver vehicle::get_out();
	}

	trigger::wait_till( "trig_waypoint_station01" );
	
	vh_technical turret::enable_auto_use( false );	 //prevents ai inside station from trying to use turret
}

function technical_riders( vh_technical ) //self = ai getting into technical
{
	self endon( "death" );
	
	self vehicle::get_in( vh_technical , "gunner1" );
	
	while ( !self flagsys::get( "in_vehicle" ) ) 
	{
		if ( !vh_technical flagsys::get( "driveroccupied" ) ) //if ai is not in the vh yet, check if there's a driver, and if not, get in driver spot
		{
			self vehicle::get_in( vh_technical , "driver" );
		}
		else
		{
			wait .05;
		}
	}
}	

function starting_ai_behavior()	//self = ai already spawned in at start of event
{	
	self endon( "death" );
	
	self.ignoreall = true;
	
	str_notify = self util::waittill_any_return( "bulletwhizby" , "damage" , "under_attack" , "death" );
	
	level flag::set( "exterior_ready_weapons" );
	
	if ( str_notify != "under_attack" )
	{
		wait 0.75; //simulate enemy reaction time after an ally gets attacked
	}
	
	if ( isAlive( self ) )
	{
		self.ignoreall = false;
	}
	
	level flag::set( "blackstation_exterior_engaged" );
	
	foreach ( ai in level.a_starting_ai )
	{
		if ( isdefined( ai ) )
		{
			ai notify( "under_attack" ); //notify other ai to stop ignoreall
		}
	}
	
	level.a_starting_ai = [];
	
	if ( self.archetype === "robot" )
	{
		self SetGoal( GetEnt( "exterior_retreat_goal" , "targetname" ) );
	}
}

function robot_lightning_behavior() //self = robot getting disabled by lightning
{	
	self endon( "death" );
	
	level flag::wait_till( "lightning_strike" );
	
	self ai::set_ignoreme( true ); //keeps allies from attacking disabled robots
	
	self DisableAimAssist(); //keeps robots from grabbing crosshair
	
	self fx::play( "disabled_robot" , self.origin , undefined , 15 , true , "j_neck" ); //TODO temp fx
	
	self playsound ("fly_bot_head_sparks_disable");
		
	for( i = 0; i < RandomIntRange( 3, 6 ); i++ )
	{

		switch( RandomInt( 3 ) )
		{
			case 0:
				self thread scene::play( "cin_bla_13_02_looting_vign_lightningstrike_robot01", self );
				break;
			
			case 1:
				self thread scene::play( "cin_bla_13_02_looting_vign_lightningstrike_robot02", self );
				break;
			
			case 2:
				self thread scene::play( "cin_bla_13_02_looting_vign_lightningstrike_robot03", self );
				break;
		}

		wait 3; // wait for the anim to play
	}
	
	if( self.script_noteworthy == "lightning_struck_gib" )
	{
		//self scene::play( "cin_bla_13_02_looting_vign_lightningstrike_robot04_falling", self ); //only gib for now 
		self thread ai::set_behavior_attribute( "force_crawler", "gib_legs" );
		self util::stop_magic_bullet_shield();
		self Kill();
	}
	else
	{
		self ai::set_ignoreall( false );
		self ai::set_ignoreme( false );
		self EnableAimAssist();
	}

}

function guard_behavior() //self = ai robot using guard feature
{
	self endon( "death" );
	
	self SetGoal( self.origin , false , 128 );
	
	self ai::set_behavior_attribute( "move_mode" , "guard" );
	
	level flag::wait_till( "blackstation_exterior_engaged" );
	
	self.goalradius = 1000;
	
	self ai::set_behavior_attribute( "move_mode" , "normal" );
}

function pather_behavior() //self = ai robot pathing towards lightning strike point
{
	self endon( "death" );
	
	level flag::wait_till( "zipline_player_landed" );
	
	nd_start = GetNearestNode( self.origin );
	
	self SetGoal( GetNode( nd_start.target , "targetname" ) );
}

function patroller_behavior() //self = patrolling ai
{
	self endon( "death" );
	
	self ai::patrol( GetNearestNode( self.origin ) );
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ZIPLINES
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function setup_zipline_down( str_zipline_trigger )
{	
	t_zip = GetEnt( str_zipline_trigger , "targetname" );

	t_zip endon( "death" );
	
	t_zip TriggerEnable( false );
	t_zip.b_in_use = false;
	
	level flag::wait_till( "ziplines_ready" );

	t_zip TriggerEnable( true );

	v_offset = ( 0, 0, 0 );
	visuals_use_object = [];
	e_zip_use = gameobjects::create_use_object( "allies" , t_zip , visuals_use_object , v_offset , undefined );
	
	e_zip_use gameobjects::set_use_hint_text( &"CP_MI_SING_BLACKSTATION_USE_ZIPLINE" );
	e_zip_use gameobjects::set_visible_team( "any" );
	e_zip_use gameobjects::set_3d_icon( "friendly", "t7_hud_prompt_push_64" );
	e_zip_use thread gameobjects::hide_icon_distance_and_los( (1,1,1), 1000, false );
	
	s_start = struct::get( t_zip.target, "targetname");
	s_end = struct::get( s_start.target, "targetname");

	while ( true ) //TODO runs forever as is, should find a safe time to end this loop
	{
		while ( t_zip.b_in_use == true )
		{
			wait .25; //wait while zipline is in use
		}
		
		//Wait for player to activate initial trigger
		t_zip trigger::wait_till();
		
		t_zip.b_in_use = true;
		
		if ( IsPlayer( t_zip.who ) )
		{
			t_zip.who notify( "used_zipline" );
			blackstation_utility::set_low_ready_movement( true , t_zip.who );
		}
		
		//Move player to start point
		t_zip.who SetOrigin( s_start.origin );
		t_zip.who playsoundtoplayer ("evt_zipline_attach", t_zip.who);
		
		//setup mover for player traveling on the zipline
		mdl_playermover = util::spawn_model( "tag_origin", s_start.origin, s_start.angles );
		t_zip.who PlayerLinkToDelta( mdl_playermover, "tag_origin", 1, 45, 45, 45, 45 );
		t_zip.who playsoundtoplayer ("evt_zipline_move", t_zip.who);
		
		n_dist = Distance( s_start.origin, s_end.origin );
		n_time = n_dist / 900;
		
		//TODO replace with animation up to the start point
		mdl_playermover MoveZ( 18, 0.25 );
		mdl_playermover waittill( "movedone" );
		
		mdl_playermover MoveTo( s_end.origin, n_time, n_time / 2 , 0.1 );
		
		mdl_playermover thread zipline_finish( t_zip.who );
		
		wait 1; //after brief wait zipline can be used again (prevents players stacking up on the zipline)

		t_zip.b_in_use = false;	
	}
}

function zipline_finish( e_zipline_user ) //self = tag origin linked to player/ally for zipline movement
{
	self waittill ( "movedone" ); //reached end of zipline

	//HACK simulate the dismount animating downward. Would be better if we could standardize dismount heights instead for animation
	v_on_navmesh = GetClosestPointOnNavMesh( self.origin, 100, 48 );
	if ( isdefined ( v_on_navmesh ) )
	{
		self MoveTo( v_on_navmesh, 0.25 );
	}
	
	if ( !isPlayer( e_zipline_user ) )
	{
		//self scene::play( "cin_gen_traversal_zipline_enemy01_dismount", e_zipline_user ); //TODO this was causing an SRE, disabled for now (2/10/15)
		
		self scene::stop( "cin_gen_traversal_zipline_enemy01_idle" );
		
		e_zipline_user SetGoal( GetNearestNode( e_zipline_user.origin ) );
	}
	
	self Unlink();
	self Delete();

	if ( e_zipline_user == level.ai_kane )
	{
		level flag::set( "kane_landed" );
	}
	else if ( isPlayer( e_zipline_user ) )
	{
		level flag::set( "zipline_player_landed" );
		
		if( level flag::get( "exterior_ready_weapons" ) )
		{
			blackstation_utility::set_low_ready_movement( false , e_zipline_user );
		}
	}
}

function zipline_allies( e_ally )
{
	if ( e_ally == level.ai_kane )
	{
		str_zipline_trigger = "trig_zipline01"; //Kane uses left zipline
	}
	else
	{
		str_zipline_trigger = "trig_zipline02"; //Hendricks uses right zipline
	}
	
	t_zip = GetEnt( str_zipline_trigger , "targetname" );
	t_zip.b_in_use = true; //disables zipline so players can't use while ally is using
	
	s_start = struct::get( t_zip.target, "targetname");
	s_end = struct::get( s_start.target, "targetname");
	
	e_ally ForceTeleport( s_start.origin , s_start.angles ); //Move ally to start point
	e_ally playsound( "evt_zipline_attach" );
	
	mdl_AImover = util::spawn_model( "tag_origin", s_start.origin, s_start.angles ); //setup mover for traveling on the zipline
	mdl_AImover thread scene::play( "cin_gen_traversal_zipline_enemy01_attach", e_ally ); //play attach anim
	
	e_ally playsound( "evt_zipline_move" );
	
	n_dist = Distance( s_start.origin, s_end.origin );
	n_time = n_dist / 900;
	
	mdl_AImover MoveZ( 64, 0.25 ); //move to attach point
	
	mdl_AImover waittill( "movedone" );
	
	mdl_AImover thread scene::play( "cin_gen_traversal_zipline_enemy01_idle", e_ally ); //play zipline anim
	mdl_AImover MoveTo( s_end.origin, n_time, n_time / 2 , 0.1 ); //move along zipline
	
	mdl_AImover thread zipline_finish( e_ally );
	
	wait 1; //after brief wait zipline can be used again (prevents characters stacking up on the zipline)

	t_zip.b_in_use = false; //let players use zipline again
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// STATION INTERIOR
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function objective_blackstation_interior_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		blackstation_utility::init_hendricks( "objective_blackstation_interior" );
		blackstation_utility::init_kane( "objective_blackstation_interior" );
		
		level.ai_kane colors::set_force_color( "y" );
		
		trigger::use( "trig_blackstation_interior" );
	}
	
	level thread blackstation_utility::player_rain_intensity( "none" );
	
	spawner::simple_spawn( "station_window_guy" , &window_guy );
	
	spawner::add_spawn_function_group( "interior_group01" , "targetname" , &ai::set_pacifist , true );
	
	level thread setup_igc_door();
	
	trigger::wait_till( "trig_waypoint_station03" , "targetname" );
	
	spawner::simple_spawn( "interior_driller" , &driller_behavior );
}

function objective_blackstation_interior_done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_blackstation_blackstation" );	
}

function driller_behavior() //self = ai with drill
{
	self endon( "death" );
	
	self.ignoreall = true;
	self.ignoreme = true;
	
	if ( isdefined( self.target ) )
	{
		s_scene = struct::get( self.target );

		self thread scene::play( s_scene.scriptbundlename , self );
	}
	
	self thread driller_detection();
	
	level flag::wait_till( "drill_engaged" );

	if ( isdefined( s_scene ) )
	{	
		self scene::stop( s_scene.scriptbundlename );
	}
	
	self.ignoreall = false;
	self.ignoreme = false;
}

function driller_detection() //self = ai with drill
{
	self util::waittill_any( "damage" , "bulletwhizby" , "enemy" , "death" );
	
	level flag::set( "drill_engaged" ); //flag can also be set on trigger in radiant
}

function track_window_flag()
{
	level endon( "cancel_window_kill" );
	
	t_ready = GetEnt( "trig_hendricks_at_window" , "targetname" );
	
	do
	{
		t_ready waittill( "trigger" , e_triggerer );
	}
	while ( e_triggerer != level.ai_hendricks ); //make sure hendricks triggered this

	level flag::set( "hendricks_at_window" );
}

function window_guy() //self = ai getting tossed through window
{
	level thread track_window_flag();
	
	self.ignoreall = true;
	self.ignoreme = true;
	
	trigger::wait_till( "trig_player_sees_window" , "targetname" );
	
	if ( level flag::get( "hendricks_at_window" ) && !level flag::get( "cancel_window_kill" ) ) //cancel flag is set on trigger in radiant if player gets too close to ai here
	{
		//TODO replace all this with an animated scene
		level scene::add_scene_func( "cin_blackstation_temp_climb_kill" , &climb_kill_end , "done" );
		
		level.ai_hendricks thread scene::play( "cin_blackstation_temp_climb_kill" );
	
		trigger::wait_till( "trig_window_kill" , "targetname" ); //hendricks hits this trigger once he is in position to grab AI
		
		wait .25; //delay for better timing	
		
		s_glass = struct::get( "station_window_break" );
		GlassRadiusDamage( s_glass.origin , 100 , 500 , 500 );
		
		if ( isAlive( self ) )
		{
			self StartRagdoll();
			self LaunchRagdoll( (-55, 0, 33) );
			self Kill();
		}
	}
	else if ( isAlive( self ) )
	{
		self.ignoreall = false;
		self.ignoreme = false;

		self GetPerfectInfo( util::get_closest_player( self.origin , "allies" ) ); //let ai know the player is there, otherwise he stands there oblivious
	}
}

function climb_kill_end()
{
	s_goal = struct::get( "station_hendricks_window_teleport" );
	
	level.ai_hendricks SetGoal( s_goal.origin , false , 16 );
}

function setup_igc_door()
{
	t_door = GetEnt( "trig_end_igc_door" , "targetname" );
	
	t_door SetHintString( &"CP_MI_SING_BLACKSTATION_OPEN_DOOR" );
	t_door SetCursorHint( "HINT_NOICON" );
	
	t_door trigger::wait_till();
	
	t_door Delete(); 
	
	//TODO temp, need a door that animates open
	foreach ( door in GetEntArray( "bs_security_door" , "script_noteworthy" ) )
	{
		door Delete();
	}
	
	skipto::objective_completed( "objective_blackstation_interior" );
	
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_station04" ) );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// END IGC 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function objective_end_igc_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		blackstation_utility::init_hendricks( "objective_end_igc" );
		blackstation_utility::init_kane( "objective_end_igc" );
	}	
	
	util::screen_message_create( "END IGC: MISSION COMPLETE"); //TODO Replace with actual IGC
	util::screen_message_delete( 5 );
	
	skipto::objective_completed( "objective_end_igc" );
}

function objective_end_igc_done( str_objective, b_starting, b_direct, player )
{
	
}
