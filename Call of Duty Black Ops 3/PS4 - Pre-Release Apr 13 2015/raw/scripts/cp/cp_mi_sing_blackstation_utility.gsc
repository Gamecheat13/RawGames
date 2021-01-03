#using scripts\codescripts\struct;

#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicleriders_shared;

       
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "lui_menu", "AnchorDeployed" );
#precache( "lui_menu", "WeatherWarning" );
#precache( "lui_menu", "SurgeWarning" );
#precache( "lui_menu", "WaveWarning" );

#namespace blackstation_utility;

function init_hendricks( str_objective )
{
	level.ai_hendricks = util::get_hero( "hendricks" );
	
	level.ai_hendricks colors::set_force_color( "b" );
	
	skipto::teleport_ai( str_objective , level.ai_hendricks );
	
	level.ai_hendricks SetGoal( level.ai_hendricks.origin, true );
}

function init_kane( str_objective )
{
    level.ai_kane = util::get_hero( "kane" );
    
    skipto::teleport_ai( str_objective , level.ai_kane );
}

//self = player
function player_anchor()
{
	self endon( "death" );
	self endon( "end_anchor" );
	
	self.is_anchored = false;
	self.is_wet = false;
	
	while( true )
	{
		if ( self ActionSlotFourButtonPressed() )
		{
			self toggle_player_anchor( true );
			
			while( self ActionSlotFourButtonPressed() )
			{
				{wait(.05);};	
			}
			
			self toggle_player_anchor( false );
		}
		
		{wait(.05);};
	}
}

//self = player
function toggle_player_anchor( b_anchor )
{
	if( self.is_anchored && !b_anchor )
	{
		self Unlink();
		if( isdefined( self.e_anchor ) )
		{
			self.e_anchor Delete();
		}
		
		self AllowStand( true );
		self AllowProne( true );	
		self AllowSprint( true );
		self SetStance( "stand" );  //TODO - this isn't working
		
		self CloseLUIMenu( self.anchor_deploy );
		
		self.is_anchored = false;
	}
	else if( b_anchor )
	{
		if( !self IsWallRunning() && !( isdefined( self.laststand ) && self.laststand ) )
		{	
			//force player into crouch for now
			self AllowStand( false );
			self AllowProne( false );
			self AllowSprint( false );
			self SetStance( "crouch" );
			
			self.e_anchor = Spawn( "script_origin", self.origin );
			self PlayerLinkTo( self.e_anchor );
			
			if ( !self IsOnGround() )
			{
				v_ground = groundpos_ignore_water( self.origin );
				n_speed = Distance( v_ground , self.origin ) * .005;
				self.e_anchor MoveTo( v_ground, n_speed );
				self.e_anchor waittill( "movedone" );
			}
			
			self.anchor_deploy = self OpenLUIMenu( "AnchorDeployed" );
			
			//Sound when anchor is attched TODO: have sounds also play from impact tables
			self playsound ("evt_player_anchor");
			
			self.is_anchored = true;
		}
	}
}

function setup_wind_storm( t_storm )
{
	t_storm thread wind_manager();
	t_storm thread hendricks_anchor( "wind_warning", "kill_weather", "wind_done" );  //flag "wind_done" set by "trigger_wind_done"
	
	foreach( player in level.players )
	{
		player thread player_wind_trigger_tracker( t_storm );
		player thread player_wind_sound_tracker( t_storm );
	}
}

//self = player
function player_wind_trigger_tracker( t_storm )
{
	self endon( "death" );
	t_storm endon( "death" );
	
	self.is_wind_affected = false;
		
	while( true )
	{
		while( self IsTouching( t_storm ) )
		{
			self.is_wind_affected = true;
			
			//Handle default wind
			if( !( isdefined( t_storm.is_gusting ) && t_storm.is_gusting ) )
			{				
				self SetMoveSpeedScale( .7 );
				//check anchor and shake accordingly
				if( self.is_anchored )
				{
					//earthquale and rumble
					self PlayRumbleOnEntity( "fallwind_loop_slow" );
					Earthquake( 0.05, 0.05, self.origin, 128.0 );			
				}
				else
				{
					//earthquale and rumble
					self PlayRumbleOnEntity( "fallwind_loop_med" );
					Earthquake( 0.1, 0.05, self.origin, 128.0 );			
				}
			}
			else
			{
				self SetMoveSpeedScale( .5 );
			}
			
			{wait(.05);};
		}
		
		self SetMoveSpeedScale( 1 );
		self.is_wind_affected = false;
		
		{wait(.05);};
	}
}

function player_wind_sound_tracker( t_storm )  //self = player
{
	self endon( "death" );
	t_storm endon( "death" );
	
	self.currentSndWind = 0;
	
	while( true )
	{
		while( self IsTouching( t_storm ) )
		{
			if( !( isdefined( t_storm.is_high ) && t_storm.is_high ) )
			{				
				if( self.currentSndWind != 1 )
				{
					self.currentSndWind = 1;
					self clientfield::set_to_player( "sndWindSystem", 1 );
				}
			}
			else
			{
				if( self.currentSndWind != 2 )
				{
					self.currentSndWind = 2;
					self clientfield::set_to_player( "sndWindSystem", 2 );
				}
			}
			
			{wait(.05);};
		}
		
		if( self.currentSndWind != 0 )
		{
			self.currentSndWind = 0;
			self clientfield::set_to_player( "sndWindSystem", 0 );
		}
		
		{wait(.05);};
	}
}

//self = trigger
function wind_manager()
{
	self endon( "death" );
	
	while( true )
	{
		//TODO - we may need to adjust this per section
		wait RandomFloatRange( 2.5, 5.5 );//Time between gusts
		
		level thread create_gust( self );
		
		//Warning UI
		foreach( player in level.players )
		{
			if( ( isdefined( player.is_wind_affected ) && player.is_wind_affected ) )
			{
				player thread weather_menu( "WeatherWarning", "kill_weather" );//High winds
			}
		}
		
		//TODO - we may need to adjust this per section
		wait RandomFloatRange( 3, 4 );//Variable time for wind to be active
		
		level flag::set( "kill_weather" );
		
		self.is_gusting = false;
		self.is_high = false;
	}
}

function create_gust( t_storm )
{
	level flag::clear( "kill_weather" );
	level endon( "kill_weather" );
	t_storm endon( "death" );
	
	const STR_MENU = "WeatherWarning";
	
	s_wind = struct::get( t_storm.target );
	
	level notify( "wind_warning" );
	
	t_storm.is_high = true;  //used to play gusting sfx earlier as a warning
	
	wait 1.5;//Give players a bit of time to anchor
	
	while( true )
	{		
		foreach( player in level.players )
		{
			if ( player IsTouching( t_storm ) )
			{
				if( !isdefined( player GetLUIMenu( STR_MENU ) ) )//To cover player entering an event that is already active
				{
					player thread weather_menu( STR_MENU, "kill_weather" );//High winds	
				}
			
				v_dir = AnglesToForward( ( 0, s_wind.angles[1], 0 ) );	
				n_push_strength = 250;//TODO - we may need to adjust this per section
			
				t_storm.is_gusting = true;
				
				if ( !player.b_safezone )
				{
					player SetVelocity( v_dir * n_push_strength );
				}
				
				//check anchor and shake accordingly
				if( player.is_anchored )
				{
					//earthquale and rumble
					player PlayRumbleOnEntity( "damage_light" );
					Earthquake( 0.2, 0.05, player.origin, 128.0 );			
				}
				else
				{
					//earthquale and rumble
					player PlayRumbleOnEntity( "damage_heavy" );
					Earthquake( 0.4, 0.05, player.origin, 128.0 );
				}
			}
		}

		{wait(.05);};
	}
}

function debris_at_players()
{
	level endon( "anchor_intro_done" );
	
	s_debris = struct::get( "debris_junk_fling" );
	s_move = struct::get( "debris_junk_move" );
	
	level thread boat_fly();
	
	while( 1 )
	{
		level waittill( "wind_warning" );
		
		wait 1.5;  //set in "create_gust" function
		
		foreach( player in level.players )
		{
			e_debris = Spawn( "script_model", s_debris.origin );
			e_debris get_debris_model();
			e_debris SetPlayerCollision( false );
			
			player fling_player_debris( e_debris );
		}
	}
}

function boat_fly()  //TODO - replace with FXAnim
{
	trigger::wait_till( "trigger_boat_fly" );
	
	e_boat = GetEnt( "debris_boat", "targetname" );
	s_start = struct::get( "flying_boat" );
	s_end = struct::get( s_start.target );
	
	e_boat MoveTo( s_start.origin, 0.05 );
	e_boat waittill( "movedone" );
	
	e_boat RotatePitch( -30, 1 );
	e_boat MoveTo( s_end.origin, 1 );
	e_boat waittill( "movedone" );
	e_boat Delete();
}

function random_debris()
{
	level endon( "anchor_intro_done" );
	
	while( 1 )
	{
		level waittill( "wind_warning" );
		
		level thread setup_random_debris();
	}
}

function setup_random_debris()
{
	a_s_starts = struct::get_array( "debris_random_start" );
	a_e_debris = array( "p7_debris_junkyard_scrap_pile_01", "p7_debris_junkyard_scrap_pile_02", "p7_debris_junkyard_scrap_pile_03", 
	                   "p7_debris_concrete_rubble_lg_03", "p7_debris_metal_scrap_01", "p7_debris_ibeam_dmg", "p7_sin_wall_metal_slats", "p7_toilet_bathroom_open" );
	
	for ( i = 0; i < RandomIntRange(10, 16); i++ )
	{
		e_debris = Spawn( "script_model", a_s_starts[RandomInt(a_s_starts.size)].origin );
		e_debris SetModel( a_e_debris[RandomInt(a_e_debris.size)] );
			
		wait RandomFloatRange( 0.1, 0.5 );
			
		e_debris thread fling_random_debris();
	}
}

function constant_debris()
{
	level endon( "anchor_intro_done" );
	
	while( 1 )
	{
		setup_constant_debris();
		
		wait RandomFloatRange( 0.3, 0.8 );
	}
}

function setup_constant_debris()
{
	a_s_starts = struct::get_array( "debris_random_start" );
	a_e_debris = array( "p7_debris_wood_board_2pc_2x4x128_lt_burn", "p7_debris_wood_plywood_4x4_flat", "p7_foliage_palm_frond_05", 
	                   "p7_debris_wood_plywood_4x8_bowed_blue", "p7_bucket_plastic_5_gal_blue", "p7_debris_drywall_chunks_corner_01",
	                   "p7_debris_drywall_chunks_01", "p7_debris_cardboard_flat_01" );
	
	for ( i = 0; i < RandomIntRange(15, 20); i++ )
	{
		e_debris = Spawn( "script_model", a_s_starts[RandomInt(a_s_starts.size)].origin );
		e_debris SetModel( a_e_debris[RandomInt(a_e_debris.size)] );
			
		wait RandomFloatRange( 0.1, 0.5 );
			
		e_debris thread fling_random_debris();
	}
}

function debris_embedded_trigger()
{
	e_car1 = GetEnt( "debris_car_02", "targetname" );
	e_vending = GetEnt( "debris_vending", "targetname" );
	a_e_debris1 = GetEntArray( "debris_stage_1", "targetname" );
	
	ArrayInsert( a_e_debris1, e_car1, 0 );
	ArrayInsert( a_e_debris1, e_vending, 0 );
		
	foreach( e_debris1 in a_e_debris1 )
	{
		e_debris1 thread debris_shake();
	}
	
	trigger::wait_till( "trigger_stage_1" );
	
	foreach( e_debris1 in a_e_debris1 )
	{
		e_debris1 thread debris_launch();
		e_debris1 thread debris_rotate();
		e_debris1 thread check_player_hit();
	}
	
	e_car2 = GetEnt( "debris_car_01", "targetname" );
	e_fridge = GetEnt( "debris_fridge", "targetname" );
	a_e_debris2 = GetEntArray( "debris_stage_2", "targetname" );
		
	ArrayInsert( a_e_debris2, e_car2, 0 );
	ArrayInsert( a_e_debris2, e_fridge, 0 );
	
	foreach( e_debris2 in a_e_debris2 )
	{
		e_debris2 thread debris_shake();
	}
	
	trigger::wait_till( "trigger_stage_2" );
	
	level waittill( "wind_warning" );
	
	wait 1.7;  //set in "create_gust" function
	
	foreach( e_debris2 in a_e_debris2 )
	{
		e_debris2 thread debris_launch();
		e_debris2 thread debris_rotate();
		e_debris2 thread check_player_hit();
	}
	
	e_tree = GetEnt( "debris_tree", "targetname" );
	e_tree thread debris_shake();
	
	trigger::wait_till( "trigger_stage_3" );
	
	level waittill( "wind_warning" );
	
	wait 1.7;  //set in "create_gust" function
	
	e_tree thread debris_launch();
	e_tree thread debris_rotate();
	e_tree thread check_player_hit();
}

function debris_shake()  //self = embedded debris to launch
{
	self endon( "death" );
	self endon( "launch" );
	
	while( 1 )
	{
		self MoveY( 1, 0.05 );
		self RotatePitch( 1, 0.05 );
		self waittill( "movedone" );
		self MoveY( -1, 0.05 );
		self RotatePitch( -1, 0.05 );
		self waittill( "movedone" );
	}
}

function debris_launch()  //self = embedded debris to launch
{
	self notify( "launch" );
	
	self MoveTo( self.origin + ( 0, 200, 0 ), 0.5 );
	self waittill( "movedone" );
	
	self MoveTo( self.origin + ( 0, 6000, 1200 ), 8 );
	self waittill( "movedone" );
	
	self Delete();
}

//TODO - replace with FXAnim
function fling_random_debris()  //self = debris
{
	self MoveZ( 240, 0.1 );
	self waittill( "movedone" );
	
	self thread debris_rotate();
	self thread check_player_hit();
	
	self MoveTo( self.origin + ( 0, 6000, RandomIntRange(20, 60) ), 4 );
	self waittill( "movedone" );
	
	self Delete();
}

//TODO - replace with FXAnim
function fling_player_debris( e_debris )  //self = player
{
	self endon( "disconnect" );
	
	e_debris thread debris_rotate();
	e_debris thread check_player_hit();
	
	e_debris MoveZ( 240, 0.1 );
	e_debris waittill( "movedone" );
	
	e_debris MoveTo( self.origin + ( RandomInt(100), 1000, RandomIntRange(80, 100) ), 3 );
	e_debris waittill( "movedone" );
	
	e_debris Delete();
}

function debris_rotate()  //self = debris
{
	self endon( "death" );
	
	while( 1 )
	{
		self RotateRoll( -90, 0.3 );
		wait 0.25;  //to avoid hitching
	}
}

function get_debris_model()  //self = debris model
{
	n_rand = RandomInt( 7 );
	
	switch( n_rand )
	{
		case 0:
			str_debris = "veh_t7_city_car_static_dead";
			break;
			
		case 1:
			str_debris = "veh_t6_v_van_whole";
			break;
			
		case 2:
			str_debris = "veh_t7_civ_gt_sedan_bluemetallic_dest";
			break;
			
		case 3:
			str_debris = "p7_water_container_plastic_large_distressed";
			break;
			
		case 4:
			str_debris = "p7_light_spotlight_generator_02";
			break;
			
		case 5:
			str_debris = "p7_foliage_treetrunk_fallen_01";
			break;
			
		case 6:
			str_debris = "veh_t7_civ_truck_med_cargo_54i_dead";
			break;
	}
	
	self SetModel( str_debris );
}

//TODO - replace with FXAnim
function shake_debris()  //self = debris object
{
	self endon( "death" );
		
	while( 1 )
	{
		self MoveZ( 3, 0.1 );
		wait 0.05;  //since "movedone" causes noticeable pause
		self MoveZ( -3, 0.1 );
		wait 0.05;
	}
}

//TODO - need collision on debris objects
function check_player_hit()  //self = debris object
{
	self endon( "death" );
	self endon( "stop_moving" );
	
	n_hit_dist_sq = 40*40;
	
	while( 1 )
	{
		foreach( player in level.players )
		{
			if ( DistanceSquared( self.origin, player GetCentroid() ) < n_hit_dist_sq )
			{
				player DoDamage( player.health/8, self.origin );
				player ShellShock( "default", 1.5 );
				player PlayRumbleOnEntity( "damage_heavy" );
				
				break;
			}
		}
		
		wait 0.05;
	}
}

function groundpos_ignore_water( origin )
{
	return groundtrace( origin, ( origin + ( 0, 0, -100000 ) ), false, undefined, true )[ "position" ];
}

//self = player
function weather_menu( str_menu, str_flag, str_notify )
{
	self endon( "death" );
	
	if ( !isdefined( self GetLUIMenu( str_menu ) ) )
	{
		warning = self OpenLUIMenu( str_menu );
	}
	
	if ( isdefined( str_notify ) )
	{
		self util::waittill_any_timeout( 3, str_notify );
	}
	else
	{
		level flag::wait_till( str_flag );
	}
	
	if ( isdefined( warning ) )
	{
		self CloseLUIMenu( warning );
	}
}

//self = trigger
function hendricks_anchor( str_warning, str_flag, str_endon )
{
	self thread hendricks_safe_area_tracker();
	
	while( true )
	{
		level waittill( str_warning );
		
		if( level.ai_hendricks IsTouching( self ) && !level.ai_hendricks.is_in_safety_zone )
		{
			level.ai_hendricks scene::play( "cin_gen_ground_anchor_start", level.ai_hendricks );
			
			level.ai_hendricks thread scene::play( "cin_gen_ground_anchor_idle", level.ai_hendricks );
			
			wait 0.5;  //allow wave fx to pass
			
			level flag::wait_till( str_flag );
			
			level.ai_hendricks scene::play( "cin_gen_ground_anchor_end", level.ai_hendricks );
		}
		
		if ( level flag::get( str_endon ) )  //with "level endon( str_endon )" it's possible hendricks gets stuck playing his looping anim
		{
			break;
		}
	}
}

//self = trigger
function hendricks_safe_area_tracker()
{
	level endon( "kill_hendricks_anchor" );
	
	//check for safe areas
	t_safe_area = GetEnt( self.targetname + "_hero_safety", "script_noteworthy" );
	
	if( !isdefined( t_safe_area ) )
	{
		return;//No safe areas here
	}
	
	while( true )
	{
		while( level.ai_hendricks IsTouching( t_safe_area ) )
		{
			level.ai_hendricks.is_in_safety_zone = true;
			
			{wait(.05);};	
		}
		
		level.ai_hendricks.is_in_safety_zone = false;
		
		{wait(.05);};
	}
}

function setup_surge( t_storm )
{
	t_storm thread surge_manager();
	t_storm thread hendricks_anchor( "surge_warning", "kill_surge", "surge_done" );  //flag "surge_done" set by "trigger_hendricks_pier"
	
	foreach( player in level.players )
	{
		player thread player_surge_trigger_tracker( t_storm );
	}
}

function is_touching_triggers( a_triggers )
{
	b_touched = false;

	foreach( trigger in a_triggers )
	{
		if( self IsTouching( trigger ) )
		{
			b_touched = true;
			continue;			
		}
	}	
	
	return b_touched;	
}

//self = trigger
function surge_manager()
{
	self endon( "death" );
	
	while( true )
	{		
		level flag::set( "surging_inward" );
		
		level thread create_surge( self );
		
		wait 2.5;  //surging in
		
		level flag::wait_till_clear( "surging_inward" );
		
		self.is_surging = false;
		
		wait RandomFloatRange( 3.5, 4.5 );  //time at low surge
	}
}

function water_manager()
{
	level endon( "tanker_smash" );
	
	while( true )
	{
		level flag::wait_till( "surging_inward" );
		
		level clientfield::set( "water_level", 1 );
		
		level flag::wait_till_clear( "surging_inward" );
		
		wait 2.5;
		
		level clientfield::set( "water_level", 2 );		
	}
}

function water_surge( s_start, a_e_debris, str_endon )  //TODO - temp surge fx
{
	level flag::wait_till_clear( "surge_active" );
		
	v_moveto = struct::get( s_start.target ).origin;
	
	n_speed = Distance( v_moveto , s_start.origin ) * .005;
	
	e_surge = util::spawn_model( "tag_origin", s_start.origin + ( 0, 0, -120 ), s_start.angles );
		
	e_surge.t_surge = GetEnt( s_start.targetname, "script_noteworthy" );
	e_surge.t_surge EnableLinkTo();
	e_surge.t_surge LinkTo( e_surge );
	
	{wait(.05);};  //allow link to complete
	
	if ( isdefined( a_e_debris ) )
	{
		array::thread_all( a_e_debris, &debris_surge_movement, e_surge );
	}
	
	while( !level flag::get( str_endon ) )
	{
		e_surge surge_mover( v_moveto, n_speed, s_start, str_endon );
		
		level flag::wait_till( "surging_inward" );
	}
}

function surge_mover( v_moveto, n_speed, s_start, str_endon )  //self = surge entity
{
	self endon( "death" );
	
	level flag::set( "surge_active" );
	
	self fx::play( "wave_pier", self.origin , self.angles, "movedone", true, "tag_origin", true );
	
	{wait(.05);};  //allow link to complete
	
	foreach( player in level.players )
	{
		self.t_surge thread surge_player_tracker( player );
		self.t_surge thread surge_warning( player );
	}
	
	self.t_surge thread hendricks_surge_tracker();
	self.t_surge thread enemy_surge_tracker();
	
	self MoveTo( v_moveto + ( 0, 0, -120 ), n_speed );
	self waittill( "movedone" );
		
	self.t_surge notify( self.t_surge.script_noteworthy );  //ends surge tracker functions
		
	level flag::set( "end_surge" );
		
	if ( s_start.targetname == "surge_port_authority" )  //for moving cover in mini-frogger event
	{
		level flag::set( "cover_switch" );
	}
		
	level flag::clear( "surging_inward" );
	level flag::clear( "surge_active" );
		
	self MoveTo( s_start.origin + ( 0, 0, -120 ), 0.05 );  //move surge back to start point
	self waittill( "movedone" );
		
	level flag::clear( "end_surge" );
	
	if ( level flag::get( str_endon ) )
	{
		self.t_surge Delete();
		self Delete();
	}
}

function surge_warning( player )  //self = surge trigger
{
	self endon( "death" );
	self endon( "wave_stop" );
	level endon( "end_surge" );
		
	STR_MENU = "SurgeWarning";
		
	while( Distance2DSquared( self.origin, player.origin ) > 490000 )
	{
		wait 0.1;	
	}
	
	if ( player.is_wet && !isdefined( player GetLUIMenu( STR_MENU ) ) )
	{
		player thread weather_menu( STR_MENU, "end_surge", "stop_surge" );
	}
	else
	{
		while( !player.is_wet )
		{
			{wait(.05);};
		}
		
		if ( !isdefined( player GetLUIMenu( STR_MENU ) ) )
		{
			player thread weather_menu( STR_MENU, "end_surge", "stop_surge" );
		}
	}
}

function enemy_surge_tracker()  //self = surge trigger
{
	self endon( "death" );
	level endon( self.script_noteworthy );
	
	while( 1 )
	{
		self waittill( "trigger", ai_entity );
		
		if ( IsAlive( ai_entity ) && ai_entity.team == "axis" && !ai_entity.b_swept )
		{
			ai_entity.b_swept = true;
			
			ai_entity thread enemy_surge_hit();
		}
	}
}

function enemy_surge_hit()  //self = ai
{
	self endon( "death" );
	
	n_face = self.angles[1];
							
	if ( ( n_face >= 0 && n_face <= 90 ) || ( n_face >= 270 ) )
	{
		self thread scene::play( "cin_bla_06_02_vign_wave_swept_left", self );
	}
	else
	{
		self thread scene::play( "cin_bla_06_02_vign_wave_swept_right", self );
	}
	
	self waittill( "swept_away" );
	
	self StartRagDoll();
	self LaunchRagDoll( ( 0, 100, 40 ) );  //TODO - get anim to launch these guys farther
	self Kill();
}

function debris_surge_movement( e_surge )  //self = debris object
{
	self endon( "death" );
	e_surge endon( "death" );
	
	n_factor = .012;
	n_offset = 180;
	
	if ( isdefined( self.target ) )
	{
		//TODO - use linked trigger like ai setup
		while( ( self.origin[1] - n_offset ) > e_surge.origin[1] )  //surge is always moving in positive Y direction
		{
			wait 0.1;
		}
		
		s_goal = struct::get( self.target );
		
		n_speed = Distance( s_goal.origin, self.origin ) * n_factor;
		
		self MoveTo( s_goal.origin, n_speed );
		self RotateTo( s_goal.angles, n_speed );
		self waittill( "movedone" );
		
		level flag::wait_till_clear( "surging_inward" );
		
		while( isdefined( s_goal.target ) )
		{
			s_goal = struct::get( s_goal.target );
			
			level flag::wait_till( "surging_inward" );
			
			while( ( self.origin[1] - n_offset ) > e_surge.origin[1] )
			{
				wait 0.1;
			}
			
			n_speed = Distance( s_goal.origin, self.origin ) * n_factor;
			
			self MoveTo( s_goal.origin, n_speed );
			self RotateTo( s_goal.angles, n_speed );
			self waittill( "movedone" );
			
			level flag::wait_till_clear( "surging_inward" );
		}
	}
}

function set_model_scale()  //self = script model
{
	if ( isdefined( self.modelscale ) )
	{
		self SetScale( self.modelscale );
	}
}

function hendricks_surge_tracker()  //self = surge trigger
{
	self endon( "death" );
	level endon( self.script_noteworthy );
	
	while( 1 )
	{
		self waittill( "trigger", ai_entity );
	
		if ( ai_entity == level.ai_hendricks )
		{
			self thread hendricks_surge_warning();
				
			break;
		}
	}
}

function hendricks_surge_warning()  //self = surge trigger
{
	level flag::clear( "kill_surge" );
	
	level notify( "surge_warning" );
	
	while( isdefined( self ) && level.ai_hendricks IsTouching( self ) )
	{
		{wait(.05);};	
	}
	
	level flag::set( "kill_surge" );
}

function surge_player_tracker( player )  //self = surge trigger
{
	self endon( "death" );
	self endon( "wave_stop" );
	level endon( self.script_noteworthy );
	player endon( "death" );
		
	while( 1 )
	{
		self waittill( "trigger", e_hit );
		
		if ( e_hit == player && !player.is_surged )
		{
			player.is_surged = true;
			player thread surge_trigger_watcher( self );
			
			t_water = GetEnt( "port_assault_low_surge", "targetname" );
			
			if ( IsPlayer( player ) && player IsTouching( t_water ) )
			{
				player thread surge_player_push( self );
				player thread surge_player_rumble( self );
				
				break;
			}
		}
	}
}

function surge_trigger_watcher( t_surge )  //self = player
{
	self endon( "death" );
	
	level set_low_ready_movement( true, self );
		
	while( isdefined( t_surge) && self IsTouching( t_surge ) )
	{
		{wait(.05);};
	}
	
	self.is_surged = false;
	
	level set_low_ready_movement( false, self );
	
	t_surge notify( "wave_stop" );
}

function surge_player_rumble( t_wave )  //self = player
{
	level endon( "end_surge" );
	self endon( "death" );
	self endon( "stop_surge" );
	t_wave endon( "wave_stop" );
	
	//TODO - user created rumble gdt doesn't have the same intensity
	Earthquake( 0.5, 2, self.origin, 100 );
				
	while( 1 )
	{
		self PlayRumbleOnEntity( "damage_heavy" );
					
		wait 0.1;  //let rumble play out a bit
	}
}

function surge_player_push( t_wave )  //self = player
{
	level endon( "end_surge" );
	self endon( "death" );
	self endon( "stop_surge" );
	t_wave endon( "wave_stop" );
	
	n_push_strength = 200;
	
	v_dir = AnglesToForward( ( 0, 90, 0 ) );  //positive Y direction in Radiant
	
	while ( 1 )
	{
		if ( !self.b_safezone && !self.is_anchored )
		{
			self SetVelocity( v_dir * n_push_strength );
		}
		
		if ( !self.is_wet )
		{
			self notify( "stop_surge" );
			break;	
		}
		
		{wait(.05);};
	}
}

function create_surge( t_storm )
{
	level endon( "end_surge" );
	t_storm endon( "death" );
	
	const STR_MENU = "SurgeWarning";
		
	while( true )
	{		
		foreach( player in level.players )
		{
			if ( player IsTouching( t_storm ) )
			{
				player.is_wet = true;
				
//				if ( !isdefined( player GetLUIMenu( STR_MENU ) ) )  //To cover player entering an event that is already active
//				{
//					player thread weather_menu( STR_MENU, "end_surge" );//High surge
//				}
				
				t_storm.is_surging = true;
			}
		}

		{wait(.05);};
	}
}

//self = player
function player_surge_trigger_tracker( t_storm )
{
	self endon( "death" );
	t_storm endon( "death" );
	
	self.is_surge_affected = false;
	
	while( true )
	{
		while( self IsTouching( t_storm ) )
		{
			self.is_surge_affected = true;
			self.is_wet = true;
			
			//Handle default wind
			if( !( isdefined( t_storm.is_surging ) && t_storm.is_surging ) )
			{
				switch( t_storm.script_string )
				{						
					case "high":
						self SetMoveSpeedScale( .7 );						
						break;
						
					default://"low"
						self SetMoveSpeedScale( .9 );
						break;
				}
			}
			else//Surge is active
			{
				switch( t_storm.script_string )
				{						
					case "high":
						self SetMoveSpeedScale( .5 );						
						break;
						
					default://"low"
						self SetMoveSpeedScale( .7 );
						break;
				}
			}
			
			{wait(.05);};
		}
		
		//Make sure we aren't touching a different trigger before reset
		a_t_surge = GetEntArray( t_storm.script_noteworthy, "script_noteworthy" );
		b_in_surge_trigger = false;
		foreach( trigger in a_t_surge )
		{
			if( self IsTouching( trigger ) )
			{
				b_in_surge_trigger = true;
			}
		}
		
		if( !b_in_surge_trigger )
		{
			self SetMoveSpeedScale( 1 );
			self.is_surge_affected = false;
			self.is_wet = false;
		}
		
		{wait(.05);};
	}
}

function setup_wave( t_storm )
{
	level prep_waves();
	
	t_storm thread wave_manager();
	t_storm thread hendricks_anchor( "wave_warning", "kill_wave", "wave_done" );  //flag "wave_done" set by "trigger_barge_cqb"
}

function prep_waves()
{
	a_waves_left = GetEntArray( "pier_wave_left", "script_noteworthy" );
	a_waves_right = GetEntArray( "pier_wave_right", "script_noteworthy" );
	
	a_waves = ArrayCombine( a_waves_left, a_waves_right, false, false );
	
	foreach( wave in a_waves )
	{
		wave Ghost();
		t_wave = GetEnt( wave.target, "targetname" );
		t_wave EnableLinkTo();
		t_wave LinkTo( wave );
	}
}

function pier_safe_zones()
{
	level flag::wait_till( "all_players_spawned" );
	
	foreach( player in level.players )
	{
		player thread player_safezone_watcher();
	}
}

function player_safezone_watcher() 
{
	a_t_safezones = GetEntArray( "trigger_pier_safe", "targetname" );  //get triggers
	
	for ( i = 0; i < a_t_safezones.size; i++ )
	{
		self thread player_safezone_watcher_trigger();
	}
}

function player_safezone_watcher_trigger() //self = trigger
{
	self endon( "death" );
	
	while( true )
	{
		self waittill( "trigger", player );
		
		if( IsPlayer( player ) )
		{
			self.b_safezone = true;
			
			player notify("safezone_trigger");
			self thread player_safezone_watcher_trigger_end(player);
		}
	}
}

function player_safezone_watcher_trigger_end(player) //self = trigger
{
	player endon( "death" );
	player endon( "safezone_trigger" );
	
	while( true )
	{
		if(!(player IsTouching(self)))
		{
			self.b_safezone = false;
			break;
		}
		
		wait 0.05;
	}
}

//self = trigger
function wave_manager()
{
	self endon( "death" );
	
	while( true )
	{
		wait RandomFloatRange( 3.5, 4.5 );  //Time between waves
		
		level thread create_wave( self );
		
		//Warning UI
		foreach( player in level.players )
		{
			if( player IsTouching( self ) )
			{
				player thread weather_menu( "WaveWarning", "kill_wave" );//High waves
			}
		}
		
		self.is_wavy = false;
	}
}

function create_wave( t_storm )
{
	level flag::clear( "kill_wave" );
	level endon( "kill_wave" );
	t_storm endon( "death" );
	
	const STR_MENU = "WaveWarning";
	
	level notify( "wave_warning" );
	
	wait 1;//Give players a bit of time to anchor
	
	a_waves_left = GetEntArray( "pier_wave_left", "script_noteworthy" );
	a_waves_right = GetEntArray( "pier_wave_right", "script_noteworthy" );
	
	a_waves = ArrayCombine( a_waves_left, a_waves_right, false, false );
	
	e_wave = a_waves[ RandomIntRange( 0, a_waves.size ) ];
	s_wave = struct::get( e_wave.target, "targetname" );
	t_wave = GetEnt( e_wave.target, "targetname" );
	
	//Sound - wave sounds secondary to mid and close
	e_wave playsound ("evt_wave_dist");
	t_wave playsound ("evt_wave_splash");
	
	array::thread_all( GetEntArray( "wave_fodder", "script_noteworthy" ), &enemy_wave_tracker, t_wave, s_wave );
	
	foreach( player in level.players )
	{
		player thread player_wave_trigger_tracker( t_wave );
	}
	
	t_wave thread ai_wave_trigger_tracker();
		
	level thread move_wave( e_wave );
	
	while( true )
	{
		foreach( player in level.players )
		{
			if ( player IsTouching( t_wave ) )
			{
				if( !isdefined( player GetLUIMenu( STR_MENU ) ) )//To cover player entering an event that is already active
				{
					player thread weather_menu( STR_MENU, "kill_wave" );//High wave	
				}
				
				v_dir = AnglesToForward( ( 0, s_wave.angles[1], 0 ) );
				n_push_strength = 250;
			
				t_wave.is_wavy = true;
				
				if ( !player.b_safezone )
				{
					player SetVelocity( v_dir * n_push_strength );
				}
				
				//check anchor and shake accordingly
				if( player.is_anchored )
				{
					//earthquale and rumble
					player PlayRumbleOnEntity( "bs_wave_anchored" );
				}
				else
				{
					//earthquale and rumble
					player PlayRumbleOnEntity( "bs_wave" );
				}
			}
		}

		{wait(.05);};
	}
}

//self = ai
function enemy_wave_tracker( t_wave, s_wave )
{
	self endon( "death" );
	t_wave endon( "death" );
	level endon( "kill_wave" );
	
	while( true )
	{
		if( self IsTouching( t_wave ) )
		{			
			v_dir = VectorNormalize( self.origin - ( s_wave.origin[0], self.origin[1], s_wave.origin[2] ) );
			
			//HACK - waiting for animation
			self StartRagdoll();
			self LaunchRagdoll( v_dir * 100 );
			self Kill();
		}
		
		{wait(.05);};
	}
}

function move_wave( e_wave )
{
	//HACK - replace with fxanim
	s_wave = struct::get( e_wave.target, "targetname" );
	e_wave.t_wave = GetEnt( e_wave.target, "targetname" );
	
	e_wave.origin = s_wave.origin;
	e_wave.angles = s_wave.angles;
		
	if ( e_wave.script_noteworthy == "pier_wave_left" )
	{
		n_dist = -450;	
	}
	else
	{
		n_dist = 450;	
	}
	
	e_wave MoveTo( e_wave.origin + ( 0, 0, 150 ), .1 );
	e_wave waittill( "movedone" );
	e_wave MoveTo( e_wave.origin + ( n_dist, 0, 150 ), 2.5 );
	
	foreach( player in level.players )
	{
		e_wave thread player_wave_protect( player );
	}
	
	e_wave thread play_temp_wave_fx();
	
	e_wave waittill( "movedone" );
	
	e_wave MoveTo( e_wave.origin + ( n_dist, 0, -150 ), 0.5 );
	e_wave waittill( "movedone" );
	
	e_wave notify( "wave_passed" );
	
	level flag::set( "kill_wave" );
}

function player_wave_protect( player )  //self = pier wave
{
	player endon( "death" );
	self endon( "wave_passed" );
		
	player.is_protected = false;
	
	while( 1 )
	{
		self.t_wave waittill( "trigger", e_hit );
		
		if ( e_hit == player && !player.is_protected )
		{
			n_attackerAccuracy = player.attackerAccuracy;
			player.attackerAccuracy = 0;
			player.is_protected = true;
		
			self waittill( "movedone" );
		
			player.attackerAccuracy = n_attackerAccuracy;
			player.is_protected = false;
		}
	}
}

//self = player
function player_wave_trigger_tracker( t_storm )
{
	self endon( "death" );
	t_storm endon( "death" );
	level endon( "kill_weather" );
	
	self.is_wavy = false;
	
	while( true )
	{
		while( self IsTouching( t_storm ) )
		{
			self.is_wavy = true;
			
			{wait(.05);};
		}
		
		self.is_wavy = false;
		{wait(.05);};
	}
}

function ai_wave_trigger_tracker()  //self = wave trigger
{
	self endon( "death" );
	level endon( "kill_weather" );
	
	while( 1 )
	{
		self waittill( "trigger", ai_entity );
		
		if ( IsAlive( ai_entity ) && ai_entity.team == "axis" && !isdefined( ai_entity.b_swept ) )
		{
			ai_entity.b_swept = true;
			
			n_face = ai_entity.angles[1];
			
			if ( n_face >= 0 && n_face <= 180 )  //facing port
			{
				if ( self.script_noteworthy == "pier_wave_left_trigger" )
				{
					n_dir = -100;
					ai_entity thread scene::play( "cin_bla_06_02_vign_wave_swept_left", ai_entity );
				}
				else
				{
					n_dir = 100;
					ai_entity thread scene::play( "cin_bla_06_02_vign_wave_swept_right", ai_entity );
				}
			}
			else
			{
				if ( self.script_noteworthy == "pier_wave_left_trigger" )
				{
					n_dir = -100;
					ai_entity thread scene::play( "cin_bla_06_02_vign_wave_swept_right", ai_entity );	
				}
				else
				{
					n_dir = 100;
					ai_entity thread scene::play( "cin_bla_06_02_vign_wave_swept_left", ai_entity );
				}
			}
			
			ai_entity waittill( "swept_away" );
			
			ai_entity StartRagDoll();
			ai_entity LaunchRagDoll( ( 0, 100, 40 ) );  //TODO - get anim to launch these guys farther
			ai_entity Kill();
		}
	}
}

/@
"Summary: Sets one or more players' weapons into low ready, reduces movement speed, and prevents jumping. Use for pacing and dialog moments."
"Name: set_low_ready_movement( b_enable = true )"
"CallOn: None"
"OptionalArg: [b_enable] Defaults to true. If false, sets players back to normal movement and removes set low ready."
"OptionalArg: [players] A player or an array of players to set low ready movement on. If undefined, will run on all players."
"Example: blackstation_utility::set_low_ready_movement();"
@/
function set_low_ready_movement( b_enable = true , players ) //TODO go over this with a lead type person and determine if this approach is appropriate for the game
{
	if ( !isdefined( players ) )
	{
		players = GetPlayers();
	}
	else
	{
		if ( !isdefined( players ) ) players = []; else if ( !IsArray( players ) ) players = array( players );;
	}
	
	if ( b_enable )
	{
		n_speed = 0.75;
	}
	else
	{
		n_speed = 1;
	}
	
	foreach ( player in players )
	{
		assert( isplayer( player ), "Tried to set low ready movement on something other than a player." );
			
		player SetMoveSpeedScale( n_speed );
		player SetLowReady( b_enable );
		player AllowJump( !b_enable );
		player AllowDoubleJump( !b_enable );
	}
}


/@
"Summary: Gets an enemy ai to replace the killed gunner on a vehicle"
"Name: truck_gunner_replace( n_gunners = 1, n_delay = 1, str_endon )"
"CallOn: Vehicle"
"OptionalArg: [n_gunners] How many times the gunner gets replaced."
"OptionalArg: [n_delay] How long to wait before attempting to find another gunner."
"OptionalArg: [str_endon] Level endon to stop looking for gunners."
"Example: vh_truck thread truck_gunner_replace( 2, 2, "warlord_fight_done" );"
@/
function truck_gunner_replace( n_gunners = 1, n_delay = 1, str_endon )  //self = truck
{
	self endon( "death" );
	
	if ( isdefined( str_endon ) )
	{
		level endon( str_endon );
	}
	
	n_guys = 0;
	
	while ( n_guys < n_gunners )
	{		
		ai_gunner = self vehicle::get_rider( "gunner1" );
		
		if ( IsAlive( ai_gunner ) )
		{
			ai_gunner waittill( "death" );
		}
		else
		{
			ai_gunner = get_truck_gunner( self );
			
			if ( IsAlive( ai_gunner ) )
			{
				ai_gunner vehicle::get_in( self, "gunner1", false );
				n_guys++;
			}
		}
		
		wait n_delay;
	}	
}

function get_truck_gunner( vh_truck )
{
	a_ai_enemies = GetAIArchetypeArray( "human" , "axis" );
	
	a_ai_gunners = ArraySortClosest( a_ai_enemies, vh_truck.origin );
	
	return a_ai_gunners[0];
}

function truck_unload( str_pos )  //self = truck
{
	ai_rider = self vehicle::get_rider( str_pos );
	
	if ( isdefined( ai_rider ) )
	{
		ai_rider vehicle::get_out();
		ai_rider util::stop_magic_bullet_shield();
	}
}

function play_temp_wave_fx()  //self = wave model
{
	self.e_fx = util::spawn_model( "tag_origin", self.origin );
	self.e_fx LinkTo( self );
	self.e_fx fx::play( "wave_pier", self.e_fx.origin + (0,0,-32), undefined, 2, true );
	
	self waittill( "movedone" );
	
	if ( isdefined( self.e_fx ) )
	{
		self.e_fx Delete();
	}
}

function police_station_corpses()
{
	a_corpses = GetEntArray( "immortal_police_station_corpse", "targetname" );
	foreach( a_e_corpse in a_corpses )
	{
		a_e_corpse thread scene::play( a_e_corpse.script_noteworthy, a_e_corpse ); //Play a specific death pose on each corpse 
	}

}

function player_rain_intensity( str_intensity )  //self = player or level
{
	switch( str_intensity )
	{
		case "none":
			n_rain = 0;
			break;
			
		case "light":
			n_rain = 1;
			break;
			
		case "med":
			n_rain = 2;
			break;
			
		case "heavy":
			n_rain = 3;
			break;
	}
	
	if ( self == level )
	{
		foreach( player in level.players )
		{
			player clientfield::set_to_player( "player_rain", n_rain );
		}
	}
	else if ( IsPlayer( self ) )
	{
		self clientfield::set_to_player( "player_rain", n_rain );
	}
}

function lightning_flashes( str_exploder, str_endon )
{
	level endon( str_endon );
	
	while( 1 )
	{
		for ( i = 0; i < 5; i++ )
		{
			level exploder::exploder( str_exploder );
			{wait(.05);};
			level exploder::stop_exploder( str_exploder );
			{wait(.05);};
		}
		
		playsoundatposition ("amb_2d_thunder_hits", (0,0,0));//TODO move alias call to exploders
		level exploder::exploder_duration( str_exploder, 1 );
	
		wait RandomFloatRange( 8.0, 11.5 );
	}	
}
