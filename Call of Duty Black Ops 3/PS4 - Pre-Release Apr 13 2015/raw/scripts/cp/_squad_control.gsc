#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;

#using scripts\cp\cp_mi_sing_biodomes_warehouse;
#using scripts\cp\cp_mi_sing_biodomes_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                     

#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

    	   	                                                                                                                                                                                                                                                                                                                                                                                                                                               


	// if given no commands, the AI will move forward if the player is further than this dist
 //2400 units
 //1024 units

 //T7_hud_waypoints_arrow




#precache( "material", "waypoint_circle_arrow_green" );
#precache( "material", "waypoint_targetneutral" );
#precache( "material", "waypoint_captureneutral" );

#precache( "string", "CP_MI_SING_BIODOMES_ROBOT_CAMO_ENERGY" );
#precache( "string", "Scanline" );
#precache( "string", "SquadStartFlash" );

#precache( "objective", "robot_name_1" );
#precache( "objective", "robot_name_2" );
#precache( "objective", "robot_name_3" );
#precache( "objective", "robot_name_4" );
#precache( "objective", "robot_name_5" );
#precache( "objective", "robot_name_6" );
#precache( "objective", "robot_name_7" );
#precache( "objective", "robot_name_8" );
#precache( "objective", "robot_name_9" );
#precache( "objective", "robot_name_10" );
#precache( "objective", "robot_name_11" );
#precache( "objective", "cp_level_biodomes_robot_task_turret" );
#precache( "objective", "cp_level_biodomes_robot_task_door" );
#precache( "lui_menu", "SquadMenu" );
#precache( "lui_menu_data", "robot1" );
#precache( "lui_menu_data", "robot2" );
#precache( "lui_menu_data", "robot3" );
#precache( "lui_menu_data", "robot4" );
#precache( "lui_menu_data", "robot5" );
#precache( "lui_menu_data", "robot6" );
#precache( "lui_menu_data", "robot7" );
#precache( "lui_menu_data", "robot8" );
#precache( "lui_menu_data", "robot9" );
#precache( "lui_menu_data", "robot10" );
#precache( "lui_menu_data", "robot11" );
#precache( "lui_menu_data", "squad_camo_text" );
#precache( "lui_menu_data", "squad_camo_amount" );

#namespace squad_control;

function autoexec __init__sytem__() {     system::register("squad_control",&__init__,undefined,undefined);    }
	
//TODO - add in support for the animated portion of the hud/lui when it comes online

function __init__()
{
	for ( i = 0; i < 4; i++ )
	{
		str_cf_name = "keyline_outline_p" + i;
		clientfield::register( "actor", str_cf_name, 1, 2, "int" );
		clientfield::register( "vehicle", str_cf_name, 1, 2, "int" );
		clientfield::register( "scriptmover", str_cf_name, 1, 3, "int" );
	}
	
	for ( i = 0; i < 4; i++ )
	{
		str_cf_name = "squad_indicator_p" + i;
		clientfield::register( "actor", str_cf_name, 1, 1, "int" );
	}
	
	clientfield::register( "actor", "robot_camo_shader", 1, 3, "int" );
	
	level.a_ai_squad = [];
	level.b_squad_player_controlled = false;
	
	callback::on_disconnect( &on_player_disconnect );
}

function on_player_disconnect()
{
	self remove_player_robot_indicators();
	
	if ( isdefined( self.obj_icon ) )
	{
		self.obj_icon destroy_temp_icon();
	}
	
	//kill off robots when player disconnects
	if ( isdefined( self.a_robots ) )
	{
		for ( i = 0; i < self.a_robots.size; i++ )
		{
			self.a_robots[i] util::stop_magic_bullet_shield();
			self.a_robots[i] Kill();
		}
	}
	
	//cleanup any hanging squad control threads
	self notify( "end_squad_control" );
}

function init_squad_control( b_squad_player_controlled = false )  //self = player
{
	self.b_has_task = false;
	self.a_targets = [];
	self.a_robot_tasks = [];
	
	//this value determines what ends up processing in the functions below. Should allow for customization of squad logic as needed
	level.b_squad_player_controlled = b_squad_player_controlled;
	
	self thread squad_init();
	self thread squad_names();
	self thread squad_control_think();
	self thread squad_control_end();
}

function squad_control_end()  //self = player
{
	self endon( "death" );
	
	self waittill( "end_squad_control" );
	
	wait 0.5;  //allow time for squad control menu to check which message to display
	
	foreach( ai_robot in self.a_robots )
	{
		if ( isdefined( ai_robot ) )
		{
			ai_robot thread disable_keyline();
			ai_robot thread enable_indicator( self, false );
		}
	}
	
	self.a_robots = [];
	
	a_e_targets = GetAITeamArray( "axis" );
	
	foreach( e_target in a_e_targets )
	{
		if ( isdefined( e_target.obj_icon ) )
		{
			e_target.obj_icon destroy_temp_icon();
		}
	}
}

function squad_control_think()  //self = player
{
	self endon( "death" );
	self endon( "end_squad_control" );
	
	if ( level.b_squad_player_controlled )
	{
		self thread squad_control_command();
		self thread mark_potential_targets();
		self thread player_laststand_monitor();
	}
}

//self is a robot
function update_robot_escort_pos( player )
{
	self endon( "death" );
	player endon( "death" );
	player endon( "end_squad_control" );
	
	//don't run this on all the robots at once at the beginning
	wait RandomFloatRange( 1, 3 );
	
	v_escort_pos_last = player point_near_player_front( self );
	self.v_escort_pos_current = player point_near_player_front( self );
	self ai::set_behavior_attribute( "escort_position", self.v_escort_pos_current );
	
	while ( true )
	{	
		//only update if this robot is not in a task, and is in escort mode
		if ( self ai::get_behavior_attribute( "move_mode" ) === "escort" && self.b_avail )
		{
			self.v_escort_pos_current = player point_near_player_front( self );
			v_distance_squared = DistanceSquared( self.v_escort_pos_current, v_escort_pos_last );
		
			//and also only update if the player has actually looked/moved some amount to a different spot
			if ( v_distance_squared > 50 * 50 )
			{
				v_escort_pos_last = self.v_escort_pos_current;
				self ClearForcedGoal();
				self ai::set_behavior_attribute( "escort_position", self.v_escort_pos_current );
			}
		}
		
		wait 2;
	}
}

//self is a robot
//always makes sure robot has a valid goal somewhere around the player and doesn't get left behind
function update_robot_goal( player )
{
	self endon( "death" );
	player endon( "end_squad_control" );
	
	while( true )
	{
		wait 5; //check every few seconds
		
		if ( self ai::get_behavior_attribute( "move_mode" ) === "escort" && self.b_avail )
		{
			v_pos = GetClosestPointOnNavMesh( player.origin, 120, 32 );
			
			if ( isdefined( v_pos ) )
			{
				self SetGoal( v_pos );
			}
			else
			{
				self SetGoal( player.origin );
			}
		}
	}
}

//self is player
function point_near_player_front( e_robot )
{
	//find a spot in front of the player to be considered the escort point	
//	v_direction = AnglesToForward( self GetPlayerAngles() );
//	v_eye = self GetEye();
//	v_trace_pos = v_eye + ( v_direction * 400);
//	v_eye_trace =  BulletTrace( v_eye, v_trace_pos, false, self )["position"];
//	v_pos = groundpos_ignore_water( v_eye_trace ) + ( 0, 0, 5 );

	//TODO commenting out the above for performance reasons until I find a more optimized way to find points in front
	
	//try to put the escort point on the navmesh nearby if possible
	v_pos_nav = GetNavPointsInRadius( self.origin, 64, 200, 16, 4, 32, 16 );
	
	if ( v_pos_nav.size )
	{
		return v_pos_nav[0];
	}
	else
	{
		return self.origin;
	}
}

function squad_init()  //self = player
{
	str_name = self.playername;
	
	for ( i = 0; i < self.a_robots.size; i++ )
	{
		self robot_init( self.a_robots[i] );
	}
	
	self.a_squad = ArrayCopy( self.a_robots );  //TODO - probably don't need this anymore
	
	self thread monitor_squad();
	self thread robot_camo_energy_regen();
}

//self is a player
function robot_init( ai_robot )
{
	ai_robot.b_moving = false;
	ai_robot.b_avail = true;
	ai_robot.b_target = false;
	ai_robot.str_action = "Standard";
	ai_robot.b_camo = false;
	ai_robot.goalradius = 1024;
	
	ai_robot thread remove_squad_member( self );
	ai_robot ai::set_behavior_attribute( "sprint", true );
	ai_robot ai::set_behavior_attribute( "can_be_meleed", false );
	ai_robot thread update_robot_escort_pos( self );
	ai_robot thread squad_camo_intro();
	ai_robot thread update_robot_goal( self );

	if ( level.b_squad_player_controlled )
	{
		//draw indicators underneath robot. client script handles this only showing up for the player that owns the robots in co-op
		ai_robot enable_indicator( self, true );
		ai_robot ai::set_behavior_attribute( "move_mode", "escort" );
	}
	else
	{
		//don't need to worry about limited squad members, so allow it to replenish every time a robot dies
		self thread replenish_squad( ai_robot );
		ai_robot ai::set_behavior_attribute( "move_mode", "escort" ); //TODO change to normal and use color chains if possible at some point
	}
	
	array::add( level.a_ai_squad, ai_robot, false );
	
	if ( level.override_robot_damage )
	{
		ai_robot.overrideActorDamage = &callback_robot_damage;
	}
	
	self.n_entity = self GetEntityNumber();
}

//self is a robot
function random_robot_camo( player )
{
	self endon( "death" );
	player endon( "end_squad_control" );
	self endon( "stop_camo" );
	
	if ( level.b_squad_player_controlled )
	{
		return;
	}
	
	//periodically have a 50% chance of going into camo for 10 seconds if robot is not already in camo
	//TODO create #defines for these values if we end up keeping this system
	while ( true )
	{		
		wait RandomIntRange( 6, 12 );
		
		n_chance = RandomFloatRange( 0, 1 );
		
		if ( n_chance >= 0.5 && !self.b_camo && self.b_avail )
		{
			self thread robot_camo( 1, player );
			self ai::set_behavior_attribute( "move_mode", "rusher" );
			self.perfectaim = true;
			
			wait 10;
			
			self ai::set_behavior_attribute( "move_mode", "escort" );
			self thread robot_camo( 0, player );
			self.perfectaim = false;
		}
	}
}

//self is a robot
function squad_camo_intro()
{
	self endon( "death" );
	
	//don't go through the camo meter resource yet since this is just an intro
	self clientfield::set( "robot_camo_shader", 1 );
	self PlaySound( "gdt_camo_suit_on" );
	self.ignoreme = true;
	self.b_camo = true;
	
	wait RandomIntRange( 3, 6 ); //have some robots come out of intro camo at different times
	
	self clientfield::set( "robot_camo_shader", 0 );
	self PlaySound( "gdt_camo_suit_off" );
	self.ignoreme = false;
	self.b_camo = false;
}

function squad_names()  //self = player
{
	if( !level.b_squad_player_controlled )
	{
		return; //TODO do we need to do anything special for non-player controlled robots?
	}
	
	self.n_entity = self GetEntityNumber();
	str_name = self.playername;
	
	if ( self.n_entity == 0 )
	{
		objectives::set( "robot_name_1", self.a_robots[0] );
		objectives::set_value( "robot_name_1", "robot1", str_name + "-" + 0 );
		self.a_robots[0] thread remove_squad_name_ondeath( "robot_name_1", self );
		self.a_robots[0] thread remove_squad_name( "robot_name_1", self );
		
		if ( self.a_robots.size > 1 )
		{
			objectives::set( "robot_name_2", self.a_robots[1] );
			objectives::set_value( "robot_name_2", "robot2", str_name + "-" + 1 );
			self.a_robots[1] thread remove_squad_name_ondeath( "robot_name_2", self );
			self.a_robots[1] thread remove_squad_name( "robot_name_2", self );
		}
		
		if ( self.a_robots.size > 2 )
		{
			objectives::set( "robot_name_3", self.a_robots[2] );
			objectives::set_value( "robot_name_3", "robot3", str_name + "-" + 2 );
			self.a_robots[2] thread remove_squad_name_ondeath( "robot_name_3", self );
			self.a_robots[2] thread remove_squad_name( "robot_name_3", self );
		}
		if ( self.a_robots.size > 3 )
		{
			objectives::set( "robot_name_4", self.a_robots[3] );
			objectives::set_value( "robot_name_4", "robot4", str_name + "-" + 3 );
			self.a_robots[3] thread remove_squad_name_ondeath( "robot_name_4", self );
			self.a_robots[3] thread remove_squad_name( "robot_name_4", self );
		}
	}
	else if ( self.n_entity == 1 )
	{
		objectives::set( "robot_name_5", self.a_robots[0] );
		objectives::set_value( "robot_name_5", "robot5", str_name + "-" + 0 );
		self.a_robots[0] thread remove_squad_name_ondeath( "robot_name_5", self );
		self.a_robots[0] thread remove_squad_name( "robot_name_5", self );
		
		objectives::set( "robot_name_6", self.a_robots[1] );
		objectives::set_value( "robot_name_6", "robot6", str_name + "-" + 1 );
		self.a_robots[1] thread remove_squad_name_ondeath( "robot_name_6", self );
		self.a_robots[1] thread remove_squad_name( "robot_name_6", self );
		
		if ( self.a_robots.size > 2 )
		{
			objectives::set( "robot_name_7", self.a_robots[2] );
			objectives::set_value( "robot_name_7", "robot7", str_name + "-" + 2 );
			self.a_robots[2] thread remove_squad_name_ondeath( "robot_name_7", self );
			self.a_robots[2] thread remove_squad_name( "robot_name_7", self );
		}
	}
	else if ( self.n_entity == 2 )
	{
		objectives::set( "robot_name_8", self.a_robots[0] );
		objectives::set_value( "robot_name_8", "robot8", str_name + "-" + 0 );
		self.a_robots[0] thread remove_squad_name_ondeath( "robot_name_8", self );
		self.a_robots[0] thread remove_squad_name( "robot_name_8", self );
		
		objectives::set( "robot_name_9", self.a_robots[1] );
		objectives::set_value( "robot_name_9", "robot9", str_name + "-" + 1 );
		self.a_robots[1] thread remove_squad_name_ondeath( "robot_name_9", self );
		self.a_robots[1] thread remove_squad_name( "robot_name_9", self );
	}
	else
	{
		objectives::set( "robot_name_10", self.a_robots[0] );
		objectives::set_value( "robot_name_10", "robot10", str_name + "-" + 0 );
		self.a_robots[0] thread remove_squad_name_ondeath( "robot_name_10", self );
		self.a_robots[0] thread remove_squad_name( "robot_name_10", self );
		
		objectives::set( "robot_name_11", self.a_robots[1] );
		objectives::set_value( "robot_name_11", "robot11", str_name + "-" + 1 );
		self.a_robots[1] thread remove_squad_name_ondeath( "robot_name_11", self );
		self.a_robots[1] thread remove_squad_name( "robot_name_11", self );
	}
}

function remove_squad_name( str_obj, e_player )  //self = robot
{
	self endon( "death" );
	
	e_player waittill( "end_squad_control" );
	
	//get rid of the names, so they don't overlap when players reconnect and bots respawn
	objectives::complete( str_obj, self );
}

function remove_squad_name_ondeath( str_obj, e_player )  //self = robot
{
	e_player endon( "end_squad_control" );
	
	self waittill( "death" );
	
	//get rid of the names, so they don't overlap when players reconnect and bots respawn
	objectives::complete( str_obj, self );
	
	self enable_indicator( e_player, false );
}

function mark_potential_targets()  //self = player
{
	self endon( "disconnect" );
	self endon( "end_squad_control" );
	
	while( 1 )
	{
		if ( !self laststand::player_is_in_laststand() )
		{
			a_e_targets = GetAITeamArray( "axis" );
			
			for ( i = 0; i < a_e_targets.size; i++ )
			{
				n_dist = Distance2DSquared( self.origin, a_e_targets[i].origin );
			
				if ( self util::is_player_looking_at( a_e_targets[i].origin, 0.95, false, self ) && self SightConeTrace( a_e_targets[i] GetEye(), a_e_targets[i] ) && IsAlive( a_e_targets[i] ) && n_dist < 5760000 )
				{
					if ( isdefined( a_e_targets[i].b_keylined ) && !a_e_targets[i].b_keylined && isdefined( a_e_targets[i].b_targeted ) && !a_e_targets[i].b_targeted )
					{
						a_e_targets[i] thread enable_keyline( 1, self );
						a_e_targets[i].b_keylined = true;
					}
				}
				else if ( IsAlive( a_e_targets[i] ) && isdefined( a_e_targets[i].b_targeted ) && !a_e_targets[i].b_targeted )
				{
					a_e_targets[i] thread disable_keyline( self );
					a_e_targets[i].b_keylined = false;
				}
			}
		}
		
		wait 3; //slow update time to help with performance
	}
}

function show_scanline() //self = player
{
	self endon( "death" );
	self endon( "end_squad_control" );
	
	if ( !isdefined( self.is_playing_scanline ) )
	{
		self.is_playing_scanline = false;
	}
	
	if ( !self.is_playing_scanline && isdefined( self.reticule_menu ) )
	{
		self.is_playing_scanline = true;
		self lui::play_animation( self.reticule_menu, "Scanline" );
		
		wait 2; //wait for animation to finish. TODO Is there an easy notify for this? play_animation doesn't pause execution the way play_movie does
		self.is_playing_scanline = false;
	}
}

function squad_control_command()  //self = player
{
	self endon( "disconnect" );
	self endon( "end_squad_control" );
	
	n_trace = 1600;
	n_count = 10;
	
	while ( 1 )
	{
		if ( !self laststand::player_is_in_laststand() )
		{
			if ( self ActionSlotOneButtonPressed() ) //DPAD_UP
			{
				v_direction = AnglesToForward( self GetPlayerAngles() );
				v_eye = self GetEye();
				v_trace_pos = v_eye + ( v_direction * n_trace );
				v_eye_trace =  BulletTrace( v_eye, v_trace_pos, false, self )["position"];
				
				//if player is pointing at a wall or object, get the ground pos directly under it plus a few units for a workaround with a navmesh bug
				v_pos = groundpos_ignore_water( v_eye_trace ) + ( 0, 0, 5 );
					
				v_moveto = GetClosestPointOnNavMesh( v_pos, 100, 32 );  //sometimes points on navmesh boundary are off the mesh
				
				n_inc = 0;
				
				while ( self ActionSlotOneButtonPressed() )
				{
					n_inc++;
					
					if ( n_inc > 2 )
					{
						//draw a temporary line from player to move destination while button is held
						//TODO draw destination particle effect continuously on client instead?
						/#
						level util::debug_line( self.origin + (0, 0, 32), v_pos, (0, 0.25, 1), 0.25, undefined, 1 );
						
						v_direction = AnglesToForward( self GetPlayerAngles() );
						v_eye = self GetEye();
						v_trace_pos = v_eye + ( v_direction * n_trace );
						v_eye_trace =  BulletTrace( v_eye, v_trace_pos, false, self )["position"];
						
						//if player is pointing at a wall or object, get the ground pos directly under it plus a few units for a workaround with a navmesh bug
						v_pos = groundpos_ignore_water( v_eye_trace ) + ( 0, 0, 5 );
							
						v_moveto = GetClosestPointOnNavMesh( v_pos, 100, 32 );  //sometimes points on navmesh boundary are off the mesh
						#/
					}
					
					if ( n_inc >= n_count )
					{
						n_inc = n_count; //in case player holds button down forever, this doesn't become some absurdly large number
					}
					
					wait 0.05;
				}
				
				self thread cp_mi_sing_biodomes_util::player_interact_anim_generic();
				
				if ( n_inc >= n_count )
				{					
					self squad_move_command( v_moveto );
					self playsoundtoplayer( "evt_robocommand_assign_task", self );
				}
				else
				{					
					self playsoundtoplayer( "evt_robocommand_assign_task", self );
					self squad_update_task();
					self squad_assign_task();
					self squad_carryout_orders( v_moveto );
				}
				
				while ( self ActionSlotOneButtonPressed() )
				{
					wait 0.05;
				}
			}
		}
		
		wait 0.05;
	}
}

function squad_move_command( v_moveto )  //self = player
{
	self endon( "end_squad_control" );
	
	if ( isdefined( v_moveto ) )
	{
		//makes sure to remove only indicators on this specific player's robots
		self thread remove_player_robot_indicators();
		
		a_v_points = GetNavPointsInRadius( v_moveto, 16, 240, 64, 32 );
				
		if ( isdefined( a_v_points ) && a_v_points.size >= self.a_robots.size )
		{
			if ( isdefined( self.obj_icon ) )
			{
				self.obj_icon destroy_temp_icon();
			}
			
			foreach( robot in self.a_robots )
			{
				robot enable_indicator( self, false );
			}
					
			self.a_robots = ArraySortClosest( self.a_robots, self.origin );
							
			a_goal_markers = [];
			for ( i = 0; i < self.a_robots.size; i++ )
			{
				if ( self.a_robots[i].b_avail )
				{
					str_removal_notify = "remove_waypoint_p"+ self GetEntityNumber() + "_robot" + i;
					a_goal_markers[i] = level fx::play( "squad_waypoint_base", a_v_points[i] + (0,0,4), ( -90, 0, 0 ), str_removal_notify, false, undefined, true );
					
					//let only commanding player see this
					a_goal_markers[i] SetInvisibleToAll();
					a_goal_markers[i] SetVisibleToPlayer( self );
					
					self.a_robots[i] notify( "moving" );
					self.a_robots[i].b_moving = true;
					self.a_robots[i].str_action = "Moving";
					self.a_robots[i] notify( "action" );
					self.a_robots[i] colors::disable();
					self.a_robots[i] ClearEntityTarget();
					self.a_robots[i] ai::set_behavior_attribute( "move_mode", "normal" );
					self.a_robots[i] SetGoal( a_v_points[i], true );
					self.a_robots[i] thread sndPlayDelayedAcknowledgement();
							
					self thread return_to_player( self.a_robots[i], str_removal_notify );
				}
			}
		}
		else
		{
			self notify( "invalid_pos" );
			self thread squad_invalid_message();
		}
	}
	else
	{
		self notify( "invalid_pos" );
		self thread squad_invalid_message();
	}
}

//self is a player
function remove_player_robot_indicators()
{
	n_player = self GetEntityNumber();
	
	if( isdefined( self.a_robots ) )
	{
		for( i = 0; i < self.a_robots.size; i++ )
		{
			str_removal_notify = "remove_waypoint_p"+ n_player + "_robot" + i;
			level notify( str_removal_notify );
		}
	}
}

function squad_update_task()  //self = player
{
	if ( self.b_has_task )
	{
		for ( i = 0; i < self.a_robot_tasks.size; i++ )
		{
			//TODO - temp target marker
			if ( isdefined( self.a_robot_tasks[i] ) && isdefined( self.a_robot_tasks[i].obj_icon ) )
			{
				self.a_robot_tasks[i] notify( "end" );
				self.a_robot_tasks[i].obj_icon destroy_temp_icon();
			}
		}
				
		self.b_has_task = false;
	}
	
	// remove old target if defined
	if ( self.a_targets.size )
	{
		foreach( ai_robot in self.a_robots )
		{
			if ( ai_robot.b_target )
			{
				ai_robot notify( "stop_shooting" );
				ai_robot.str_action = "Standard";
				ai_robot notify( "action" );
				ai_robot.b_target = false;
				ai_robot ClearEntityTarget();
			}
		}
				
		for ( i = 0; i < self.a_targets.size; i++ )
		{
			if ( IsAlive( self.a_targets[i] ) )
			{
				self.a_targets[i].b_targeted = false;
				self.a_targets[i] disable_keyline( self );
			}
		}
				
		self.a_targets = [];
	}	
}

function squad_assign_task()  //self = player
{
	// assign task
	for ( i = 0; i < self.a_robot_tasks.size; i++ )
	{
		if ( isdefined( self.a_robot_tasks[i] ) )
		{
			n_dist = Distance2DSquared( self.origin, self.a_robot_tasks[i].origin );
			
			if ( !self.a_robot_tasks[i].b_engaged && n_dist < 5760000 )
			{
				if ( self util::is_player_looking_at( self.a_robot_tasks[i].origin, 0.9, false, self ) )
				{
					if ( self.a_robots.size >= self.a_robot_tasks[i].n_required )
					{
						self.a_robot_tasks[i].b_engaged = true;
						self.b_has_task = true;
							
						a_ai_robots = [];
								
						if ( self.a_robot_tasks[i].script_noteworthy == "turret_hall" )
						{
							a_ai_robots = ArrayCopy( level.a_ai_squad );
						}
						else
						{
							a_temp = ArrayCopy( level.a_ai_squad );
									
							while( 1 )
							{
								ai_closest = array::get_closest( self.a_robot_tasks[i].origin, a_temp );
										
								ArrayRemoveValue( a_temp, ai_closest );
										
								if ( ai_closest.b_avail )
								{
									ai_closest.b_avail = false;
									array::add( a_ai_robots, ai_closest );
									
									if ( a_ai_robots.size > 1 )
									{
										break;	
									}
								}
										
								if ( !a_temp.size )
								{
									IPrintLnBold( "NOT ENOUGH ROBOTS" );  //TODO - replace with LUI menu message
									
									self.a_robot_tasks[i].b_engaged = false;
									self.b_has_task = false;
									a_ai_robots = [];
									break;	//ran out of robots to check
								}
										
								wait 0.05;
							}
									
							a_temp = [];
						}
						
						if ( a_ai_robots.size )
						{
							self thread robot_task( a_ai_robots, self.a_robot_tasks[i] );
						}
														
						break;
					}
					else
					{
						IPrintLnBold( self.playername + " DOES NOT HAVE ENOUGH ROBOTS" );  //TODO - replace with LUI menu message
					}
				}
			}
		}
	}
}

//self is a player
//this is used if we want to command the robots to do any task without any direct player input
function squad_assign_task_independent( str_task, n_delay_timer = 0 )
{
	if ( level.b_squad_player_controlled )
	{
		return;
	}
	
	wait n_delay_timer; //delay if we don't want to do the task immediately
	
	self squad_update_task();
	
	e_robot_task = GetEnt( str_task, "script_noteworthy" );
	
	for ( i = 0; i < self.a_robot_tasks.size; i++ )
	{
		if ( self.a_robot_tasks[i] === e_robot_task )
		{
			if ( self.a_robots.size >= self.a_robot_tasks[i].n_required )
			{
				self.a_robot_tasks[i].b_engaged = true;
				self.b_has_task = true;
					
				a_ai_robots = [];
				a_temp = ArrayCopy( level.a_ai_squad );
							
				while( true )
				{
					ai_closest = array::get_closest( self.a_robot_tasks[i].origin, a_temp );
							
					ArrayRemoveValue( a_temp, ai_closest );
							
					if ( ai_closest.b_avail )
					{
						ai_closest.b_avail = false;
						array::add( a_ai_robots, ai_closest );
						
						if ( a_ai_robots.size > 1 )
						{
							break;	
						}
					}
							
					if ( !a_temp.size )
					{
						self.a_robot_tasks[i].b_engaged = false;
						self.b_has_task = false;
						a_ai_robots = [];
						break;	//ran out of robots to check
					}
							
					wait 0.05;
				}
						
				a_temp = [];
				
				if ( a_ai_robots.size )
				{
					self thread robot_task( a_ai_robots, self.a_robot_tasks[i] );
				}
												
				break;
			}
		}
	}
}
				

function squad_carryout_orders( v_moveto )  //self = player
{
	a_e_targets = GetAITeamArray( "axis" );
			
	if ( !self.b_has_task )
	{
		for ( i = 0; i < a_e_targets.size; i++ )
		{
			n_dist = Distance2DSquared( self.origin, a_e_targets[i].origin );
			
			if ( self util::is_player_looking_at( a_e_targets[i].origin, 0.95, false, self ) && self SightConeTrace( a_e_targets[i] GetEye(), a_e_targets[i] ) && IsAlive( a_e_targets[i] ) && n_dist < 5760000 )
			{
				if ( !isdefined( a_e_targets[i].b_engaged ) )  //don't include interactive enemies (i.e. turrets)
				{
					if ( !isdefined( self.a_targets ) ) self.a_targets = []; else if ( !IsArray( self.a_targets ) ) self.a_targets = array( self.a_targets ); self.a_targets[self.a_targets.size]=a_e_targets[i];;
					
					self thread mark_target( a_e_targets[i], "target" );
					self thread remove_target_ondeath( a_e_targets[i] );
				}
			}
		}
	}
			
	if ( self.a_targets.size )
	{
		foreach ( ai_robot in self.a_robots )
		{
			if ( IsAlive( ai_robot ) && ai_robot.b_avail )
			{
				self thread robot_attack_target( ai_robot );
			}
		}
	}
	else
	{					
		self squad_move_command( v_moveto );
		self playsoundtoplayer( "evt_robocommand_assign_task", self );
	}
}

function sndPlayDelayedAcknowledgement()  //self = robot
{
	self endon( "death" );
	
	wait(randomfloatrange(.4,1.2));
	
	if( isdefined( self ) )
	{
		self playsound( "evt_robocommand_acknowledge" );
	}
}

function squad_invalid_message()  //self = player
{
	self endon( "disconnect" );
	self endon( "invalid_pos" );
	
	if ( isdefined( self.invalid_menu ) )
	{
		self CloseLUIMenu( self.invalid_menu );
		
		self.invalid_menu = undefined;
	}
	
	self.invalid_menu = self OpenLUIMenu( "SquadInvalidPosMenu" );
	
	wait 2;
	
	self CloseLUIMenu( self.invalid_menu );
	
	self.invalid_menu = undefined;
}
	
function squad_control_follow()  //self = player
{
	self endon( "disconnect" );
	self endon( "end_squad_control" );
	
	while( 1 )
	{
		n_min_dist = 48;
		n_max_dist = 400;
		n_max_height = 48;
	
		if ( ( isdefined( self.b_narrow_space ) && self.b_narrow_space ) )
		{
			n_min_dist = 24;
			n_max_dist = 82;
			n_max_height = 0;
		}
		
		v_player_pos = GetClosestPointOnNavMesh( self.origin, 82, 32 );
		
		if ( isdefined( v_player_pos ) )
		{
			a_v_points = GetNavPointsInRadius( v_player_pos, n_min_dist, n_max_dist, 100, 32, n_max_height );
			
			if ( a_v_points.size >= self.a_robots.size )
			{
				self.a_robots = ArraySortClosest( self.a_robots, self.origin );
				
				for ( i = 0; i < self.a_robots.size; i++ )
				{
					if ( ( Distance2DSquared( self.origin, self.a_robots[i].origin ) > ( 200 * 200 ) ) )
					{
						if ( !self.a_robots[i].b_moving && !self.a_robots[i].b_target  && self.a_robots[i].b_avail )
						{
							self.a_robots[i] SetGoal( a_v_points[i], true );
												
							wait RandomFloatRange( 0.1, 0.3 );  //don't want robots all moving at once
						}
					}
				}
			}
			else
			{
				a_alt_pos = [];
				
				for ( i = 0; i < self.a_robots.size; i++ )
				{
					if ( ( Distance2DSquared( self.origin, self.a_robots[i].origin ) > ( 200 * 200 ) ) )
					{
						if ( !self.a_robots[i].b_moving && !self.a_robots[i].b_target  && self.a_robots[i].b_avail )
						{
							a_alt_pos[i] = GetClosestPointOnNavMesh( self.origin + ( i * 50, i * 50, 0 ), 82, 32 );
							
							if ( isdefined( a_alt_pos[i] ) )
							{
								self.a_robots[i] SetGoal( a_alt_pos[i], true );
												
								wait RandomFloatRange( 0.1, 0.3 );  //don't want robots all moving at once
							}
						}
					}
				}
				
				a_alt_pos = undefined;
			}
		}
		
		wait 0.1;
	}
}

function player_laststand_monitor()  //self = player
{
	self endon( "disconnect" );
	self endon( "end_squad_control" );
	
	while( 1 )
	{
		self waittill( "player_downed" );
		
		for ( i = 0; i < self.a_robots.size; i++ )
		{
			if ( IsAlive( self.a_robots[i] ) )
			{
				self.a_robots[i] notify( "stop_shooting" );
				//self.a_robots[i] notify( "stop_shoot_at_target" );
				self.a_robots[i].b_target = false;
				self.a_robots[i].b_moving = false;
				self.a_robots[i].str_action = "Standard";
				self.a_robots[i] notify( "action" );
			}
		}
		
		wait 0.5;  //give time for player to reach downed state
		
		if ( self.a_targets.size )
		{
			foreach( e_target in self.a_targets )
			{
				if ( IsAlive( e_target ) )
				{
					e_target thread disable_keyline( self );
				}
			}
		}
	}
}

function robot_wait_goal()  //self = robot
{
	self endon( "death" );
	self endon( "moving" );
	
	str_msg = self util::waittill_any_timeout( 20, "goal" );
	
	if ( str_msg == "goal" )
	{
		wait 3;
	}
	
	self.b_moving = false;
}
	
function return_to_player( ai_robot, str_removal_notify )  //self = player
{
	self endon( "disconnect" );
	self endon( "end_squad_control" );
	ai_robot endon( "moving" );
	ai_robot endon( "death" );
		
	str_msg = ai_robot util::waittill_any_timeout( 20, "goal" );
	
	level notify( str_removal_notify );
	
	ai_robot enable_indicator( self, true );
	
	if ( str_msg == "goal" )
	{
		wait 3;
	}
	
	ai_robot ai::set_behavior_attribute( "move_mode", "escort" );
	ai_robot.b_moving = false;
	ai_robot.str_action = "Standard";
	ai_robot notify( "action" );
}

// self == player
function mark_target( e_target, str_obj )
{
	e_target endon( "death" );
	e_target endon( "end" );
	
	e_target disable_keyline( self );
	
	wait 0.05;  //need to wait a frame to allow for white keyline to disable
	
	e_target enable_keyline( 2, self );
	
	e_target.b_targeted = true;
}

function mark_task( e_target, str_obj )
{
	//TODO - temp target marker
	e_target.obj_icon = create_temp_icon( str_obj, e_target getentitynumber(), e_target.origin + (0,0,72) );	
}

function remove_target_ondeath( ai_target )
{
	ai_target waittill( "death" );
	
	if ( isdefined( ai_target ) && isdefined( self.a_targets ) && IsInArray( self.a_targets, ai_target ) )
	{
		ArrayRemoveValue( self.a_targets, ai_target );		
	}
		
	if ( isdefined( ai_target ) )
	{
		ai_target disable_keyline();
	}
	
	if ( isdefined( ai_target.obj_icon ) )
	{
		ai_target.obj_icon destroy_temp_icon();
	}
}

function squad_control_task( e_task )  //self = player
{
	e_task.b_engaged = false;
		
	if ( !isdefined( self.a_robot_tasks ) ) self.a_robot_tasks = []; else if ( !IsArray( self.a_robot_tasks ) ) self.a_robot_tasks = array( self.a_robot_tasks ); self.a_robot_tasks[self.a_robot_tasks.size]=e_task;;
	
	switch( e_task.script_noteworthy )
	{
		case "pry_door":
			e_task.n_required = 2;
			break;
				
		case "floor_collapse":
			e_task.n_required = 2;
			break;
				
		case "tear_apart":
			e_task.n_required = 2;
			break;
				
		case "turret_hall":
			e_task.n_required = 1;
			break;
	}
}
	
function robot_task( a_ai_robots, e_task )  //self = player
{
	foreach( ai_robot in a_ai_robots )
	{
		if ( IsAlive( ai_robot ) )
		{
			ai_robot ai::set_behavior_attribute( "move_mode", "normal" );
			ai_robot util::magic_bullet_shield();
			ai_robot.b_avail = false;
			ai_robot ai::disable_pain();
			ai_robot.ignoresuppression = true;
			ai_robot ai::set_ignoreall( true );
			ai_robot notify( "stop_shooting" );
			ai_robot notify( "stop_camo" );
			ai_robot thread robot_camo( 0, self );
			ai_robot.str_action = "Interacting";
			ai_robot.perfectaim = false;
			ai_robot notify( "action" );
		}
		else
		{
			return; //bail out if any of the robots died before robot_task was assigned
		}
	}
	
	switch( e_task.script_noteworthy )
	{
		case "pry_door":
			self thread robot_interact_warehouse_door( a_ai_robots, e_task );
			break;
				
		case "floor_collapse":
			self thread robot_interact_markets1_turret( a_ai_robots, e_task );
			break;
				
		case "tear_apart":
			self thread robot_interact_markets2_turret( a_ai_robots, e_task );
			break;
	}
}

function robot_attack_target( ai_robot )  //self = player
{
	ai_robot endon( "death" );
	ai_robot endon( "stop_shooting" );
	//ai_robot endon( "stop_shoot_at_target" );
	self endon( "end_squad_control" );
	self endon( "disconnect" );
	
	n_min_dist = 60;
	n_max_dist = 200;
	
	ai_robot.goalradius = 1024;
	
	ai_robot ai::set_behavior_attribute( "move_mode", "rusher" );
	ai_robot thread robot_camo( 1, self );
	
	for ( i = 0; i < self.a_targets.size; i++ )
	{
		self.a_targets[i].b_targeted_by_robot = false; //track this so that friendly robots don't shoot at someone already being targeted
			
		if ( IsAlive( self.a_targets[i] ) )
		{
			//ignore if this is a warlord
			if ( self.a_targets[i].aitype === "spawner_enemy_54i_human_warlord_minigun" )
			{
				continue;
			}
			
			v_target_pos = GetClosestPointOnNavMesh( self.a_targets[i].origin, 64, 16 );
		
			if ( isdefined( v_target_pos ) )
			{
				a_v_points = ai_robot GetPathableNavPointsInRadius( n_min_dist, n_max_dist, 32, 32, v_target_pos );
				
				if ( a_v_points.size >= self.a_robots.size )
				{
					//only go to this goal if it's not a drastic difference in distance or height from player. Should help in places like Cloud Mountain
					n_height_diff = Abs( self.origin[2] - a_v_points[i][2] );
					if (  n_height_diff < 160 && DistanceSquared( self.origin, a_v_points[i] ) < 1048576  )
					{
						ai_robot SetGoal( a_v_points[i], true );
					}
					
					if ( IsActor( self.a_targets[i] ) )
					{
						ai_robot thread ai::shoot_at_target( "kill_within_time", self.a_targets[i], undefined, 0.05, 100 );
					}
					else
					{
						ai_robot thread ai::shoot_at_target( "shoot_until_target_dead", self.a_targets[i], undefined, 0.05, 100 );
					}
				}
				else
				{
					//don't be a rusher if I can't reach the target position
					ai_robot ai::set_behavior_attribute( "move_mode", "normal" );
					
					if ( IsActor( self.a_targets[i] ) )
					{
						ai_robot thread ai::shoot_at_target( "kill_within_time", self.a_targets[i], undefined, 0.05, 100 );
					}
					else
					{
						ai_robot thread ai::shoot_at_target( "shoot_until_target_dead", self.a_targets[i], undefined, 0.05, 100 );
					}
				}
			}
			else if ( IsActor( self.a_targets[i] ) )
			{
				ai_robot thread ai::shoot_at_target( "kill_within_time", self.a_targets[i], undefined, 0.05, 100 );
			}
			else
			{
				ai_robot thread ai::shoot_at_target( "shoot_until_target_dead", self.a_targets[i], undefined, 0.05, 100 );
			}

			self.a_targets[i].b_targeted_by_robot = true;
			ai_robot.b_target = true;
			ai_robot.str_action = "Attacking";
			ai_robot notify( "action" );
			
			//draw temporary red lines from robots to targets (time value is actually in frames)
			/#
			level util::debug_line( ai_robot.origin + (0, 0, 64), self.a_targets[i].origin + (0, 0, 64), (1, 0, 0), 0.1, undefined, 3 );
			#/
			
			ai_robot thread sndPlayDelayedAcknowledgement();
		}
	}
	
	while( self.a_targets.size )
	{
		wait 0.05;
	}
	
	ai_robot ClearForcedGoal();
	ai_robot thread robot_camo( 0, self );
	ai_robot ai::set_behavior_attribute( "move_mode", "escort" );
	ai_robot.b_target = false;
	ai_robot.str_action = "Standard";
	ai_robot notify( "action" );
}

function robot_interact_markets1_turret( a_ai_robots, e_task )  //self = player  (12356, 15539, -31), (12619, 16047, -15), (12543.5, 16065, -15)
{
	if ( IsInArray( self.a_robot_tasks, e_task ) )
	{
		ArrayRemoveValue( self.a_robot_tasks, e_task );
	}
	
	level thread squad_interaction_end( a_ai_robots, "turret1_dead", self );
	
	//e_task is the actual markets1 turret
	if ( isdefined( e_task ) && !level flag::get( "turret1_dead" ) )
	{
		a_nd_pos = GetNodeArray( "turret1_pos", "targetname" );
		
		for ( i = 0; i < a_ai_robots.size; i++ )
		{
			a_ai_robots[i] endon( "death" );
			a_ai_robots[i].b_ready = false;
			a_ai_robots[i] thread robot_camo( 1, self );
			a_ai_robots[i] ClearForcedGoal();
			a_ai_robots[i] thread ai::force_goal( a_nd_pos[i], 16, false, "goal", true, true );
			a_ai_robots[i] thread robot_waittill_goal( a_nd_pos[i] );
		}
		
		n_ready = 0;
		objectives::set( "cp_level_biodomes_robot_task_turret" , e_task );
	
		while( 1 )
		{
			for ( i = 0; i < a_ai_robots.size; i++ )
			{
				if ( a_ai_robots[i].b_ready )
				{
					n_ready++;
					a_ai_robots[i] ai::set_behavior_attribute( "sprint", true );
				}
			}
			
			if ( n_ready == a_ai_robots.size )
			{
				break;
			}
			else
			{
				n_ready = 0;
			}
			
			wait 0.05;
		}
		
		foreach( robot in a_ai_robots )
		{
			robot.b_ready = false;	
		}
		
		objectives::complete( "cp_level_biodomes_robot_task_turret" , e_task );
		
		if ( IsAlive( e_task ) )
		{
			a_ai_robots[0].animname = "turret1_robot01";
			a_ai_robots[1].animname = "turret1_robot02";
			
			a_ai_robots[0] thread robot_camo( 0, self );
			a_ai_robots[1] thread robot_camo( 0, self );
			
			level thread scene::play( "scene_turret1", "targetname" );
			
			e_task util::magic_bullet_shield();
			
			level waittill( "floor_fall" );
			
			//delete collision underneath turret
			e_floor_collision = GetEnt( "vendor_shop_turret_destroyed", "targetname" );
			
			if ( isdefined( e_floor_collision ) )
			{
				e_floor_collision Delete();
			}
			
			level thread scene::play( "p7_fxanim_cp_biodomes_turret_collapse_bundle" );
			
			e_turret_tag = GetEnt( "turret_collapse", "targetname" );
			
			if ( isdefined( e_task ) )
			{
				e_task LinkTo( e_turret_tag, "turret_jnt" );
				fx::play( "ceiling_collapse", e_task.origin );
			}
			
			if ( IsAlive( e_task ) )  //TODO - replace with scene
			{
				e_task util::stop_magic_bullet_shield();
				e_task Kill();
			}
		}
	}
}

//self is a robot
function robot_camo( n_camo_state, player )
{
	self endon( "death" );
	
	self clientfield::set( "robot_camo_shader", 2 );
	
	wait 1; //always flicker for a second before turning off/on
	
	self clientfield::set( "robot_camo_shader", n_camo_state );
	
	if ( n_camo_state == 1 )
	{
		self ai::set_ignoreme( true );
		self.b_camo = true;
		self thread robot_camo_energy_deplete( player );
		self PlaySound( "gdt_camo_suit_on" );
	}
	else
	{
		self ai::set_ignoreme( false );
		self.b_camo = false;
		self notify ( "robot_camo_off" );
		self PlaySound( "gdt_camo_suit_off" );
	}
}

//self is a player
function update_camo_energy_HUD( n_camo_pct )
{
	self endon( "death" );
	self endon( "end_squad_control" );
	
	if ( level.b_squad_player_controlled && isdefined( self.squad_menu ) )
	{
		self SetLUIMenuData( self.squad_menu, "squad_camo_amount", n_camo_pct );
		str_robot_camo_energy = &"CP_MI_SING_BIODOMES_ROBOT_CAMO_ENERGY"; //this string has the squad_camo_amount from above as a part of it via $(squad_camo_amount)
		self SetLUIMenuData( self.squad_menu, "squad_camo_text", str_robot_camo_energy );
	}
}

//works similarly to squad_regen_health, camo meter recharges more quickly if not in combat
function robot_camo_energy_regen() //self is player
{
	self endon ( "death" );
	
	self.n_robot_camo_energy = 500;
	
	//convert to a percentage
	n_robot_camo_energy_pct = Int( ( self.n_robot_camo_energy/500 ) * 100 );
	
	while( true )
	{
		if ( level.skipto_point == "objective_cloudmountain" && level.b_squad_player_controlled )
		{
			break;
		}
		
		if ( self.n_robot_camo_energy < 500 )
		{
			self.n_robot_camo_energy += 20;
			
			if ( self.n_robot_camo_energy > 500 )
			{
				self.n_robot_camo_energy = 500;
			}
			
			//convert to a percentage
			n_robot_camo_energy_pct = Int( ( self.n_robot_camo_energy/500 ) * 100 );
			
			self thread update_camo_energy_HUD( n_robot_camo_energy_pct );			
		}
		
		for ( i = 0; i < self.a_robots.size; i++ )  //regen faster if no enemies are around
		{
			if ( isdefined( self.a_robots[i].enemy ) )
			{
				n_wait = 5;
				break;
			}
			else
			{
				n_wait = 0.5;		
			}
		}
		
		wait n_wait;  //regen time
	}
}

//self is a robot
function robot_camo_energy_deplete( player )
{
	self endon( "robot_camo_off" );
	self endon( "death" );
	player endon ( "death" );
	
	if ( player.n_robot_camo_energy >= 5 * 2 )
	{
		player.n_robot_camo_energy -= 5 * 2;
		
		//convert to a percentage
		n_robot_camo_energy_pct = Int( ( player.n_robot_camo_energy/500 ) * 100 );
		
		player thread update_camo_energy_HUD( n_robot_camo_energy_pct );
	
		while ( player.n_robot_camo_energy >= 0 )
		{
			wait 3;
			
			player.n_robot_camo_energy -= 5;
			
			if ( player.n_robot_camo_energy < 0 )
			{
				player.n_robot_camo_energy = 0;
				
				self robot_camo( 0, player);
			}
			
			//convert to a percentage
			n_robot_camo_energy_pct = Int( ( player.n_robot_camo_energy/500 ) * 100 );
			
			player thread update_camo_energy_HUD( n_robot_camo_energy_pct );
		}
	}
	else
	{
		self thread robot_camo( 0, player );
	}
}
	
function robot_interact_markets2_turret( a_ai_robots, e_task ) //self = player
{
	if ( IsInArray( self.a_robot_tasks, e_task ) )
	{
		ArrayRemoveValue( self.a_robot_tasks, e_task );
	}
	
	level thread squad_interaction_end( a_ai_robots, "turret2_dead", self );
	
	//e_task is the actual markets2 turret
	if ( isdefined( e_task ) && !level flag::get( "turret2_dead" ) )
	{
		a_nd_pos = GetNodeArray( "nd_turret2", "targetname" );
		
		for ( i = 0; i < a_ai_robots.size; i++ )
		{
			a_ai_robots[i] endon( "death" );
			a_ai_robots[i].b_ready = false;
			a_ai_robots[i] thread robot_camo( 1, self );
			a_ai_robots[i] ClearForcedGoal();
			a_ai_robots[i] thread ai::force_goal( a_nd_pos[i], 16, false, "goal", true, true );
			a_ai_robots[i] thread robot_waittill_goal( a_nd_pos[i] );
		}
		
		n_ready = 0;
		
		objectives::set( "cp_level_biodomes_robot_task_turret" , e_task );
	
		while( 1 )
		{
			for ( i = 0; i < a_ai_robots.size; i++ )
			{
				if ( a_ai_robots[i].b_ready )
				{
					n_ready++;
					a_ai_robots[i] ai::set_behavior_attribute( "sprint", true );
				}
			}
			
			if ( n_ready == a_ai_robots.size )
			{
				break;
			}
			else
			{
				n_ready = 0;
			}
			
			wait 0.05;
		}
		
		foreach( robot in a_ai_robots )
		{
			robot.b_ready = false;	
		}
		
		objectives::complete( "cp_level_biodomes_robot_task_turret" , e_task );
		
		a_ai_robots[0] thread robot_camo( 0, self );
		a_ai_robots[1] thread robot_camo( 0, self );
		
		//TODO animation needs to be updated to support "vehicle" type, so I can use the actual turret in the scene
		if ( IsAlive( e_task ) )
		{
			e_task Hide();
			
			a_ai_robots[0].animname = "turret2_robot01";
			a_ai_robots[1].animname = "turret2_robot02";
			
			level scene::play( "scene_turret2", "targetname" );
		}
			
		if ( IsAlive( e_task ) )
		{
			e_task Kill();
		}
	}
}

//self is a player
function squad_interaction_end( a_ai_robots, str_flag, player )
{
	level flag::wait_till( str_flag );
	
	wait 0.5;  //give time for scene to finish
	
	foreach( ai_robot in a_ai_robots )
	{
		ai_robot util::stop_magic_bullet_shield();
		ai_robot.allowdeath = true;
		ai_robot.goalradius = 1024;
		ai_robot.ignoresuppression = false;
		ai_robot ai::set_ignoreall( false );
		ai_robot ai::enable_pain();
		ai_robot.b_avail = true;
		ai_robot.animname = undefined;
		ai_robot.str_action = "Standard";
		ai_robot notify( "action" );
		ai_robot ClearForcedGoal();
		ai_robot ai::set_behavior_attribute( "move_mode", "escort" );
	}
	
	a_ai_robots = [];	
}

function squad_attack_target( v_goal, a_targets, str_endon )  //self = robot
{
	self endon( "death" );
	level endon( str_endon );
	
	str_msg = self util::waittill_any_timeout( 15, "goal" );
	
	if ( str_msg != "goal" )  //TODO - replace with anim
	{
		self SetGoal( self.origin, true );
		self waittill( "goal" );
		self ForceTeleport( v_goal );
		self SetGoal( v_goal, true );
	}
	
	if ( IsArray( a_targets ) )
	{
		ArraySortClosest( a_targets, self.origin );
		
		for ( i = 0; i < a_targets.size; i++ )
		{
			if ( IsAlive( a_targets[i] ) )
			{
				self thread ai::shoot_at_target( "normal", a_targets[i], undefined, 3 );  //TODO - replace with scripted anim
				
				wait 3;
				
				if ( IsAlive( a_targets[i] ) )
				{
					a_targets[i] Kill();
				}
			}
		}
	}
	else
	{
		if ( IsAlive( a_targets ) )
		{
			self thread ai::shoot_at_target( "shoot_until_target_dead", a_targets );  //TODO - replace with scripted anim
			self waittill( "stop_shoot_at_target" );
		}
	}
}

function robot_interact_warehouse_door( a_ai_robots, e_task )  //self = player
{
	if ( IsInArray( self.a_robot_tasks, e_task ) )
	{
		ArrayRemoveValue( self.a_robot_tasks, e_task );
	}
		
	a_nd_pos = GetNodeArray( "nd_warehouse_door", "targetname" );
	nd_door = GetNode( "nd_warehouse_hendricks", "targetname" );
	
	level.ai_hendricks colors::disable();
	level.ai_hendricks notify( "stop_following" );
	level.ai_hendricks SetGoal( nd_door, true );
	
	level thread squad_interaction_end( a_ai_robots, "back_door_opened", self );
	
	for ( i = 0; i < a_nd_pos.size; i++ )
	{
		a_ai_robots[i].b_ready = false;
		a_ai_robots[i] ClearForcedGoal();
		a_ai_robots[i] thread robot_waittill_goal( a_nd_pos[i] );
	}
	
	n_ready = 0;
	
	while( 1 )
	{
		for ( i = 0; i < a_ai_robots.size; i++ )
		{
			if ( a_ai_robots[i].b_ready )
			{
				n_ready++;
			}
		}
		
		if ( n_ready == a_ai_robots.size )
		{
			break;
		}
		else
		{
			n_ready = 0;
		}
		
		wait 0.05;
	}
	
	foreach( robot in a_ai_robots )
	{
		robot.b_ready = false;	
	}
	
	wait 1;  //let ai idle for a bit before starting scene
	
	level flag::set( "phalanx" );
	
	a_ai_robots[0].animname = "warehouse_robot01";
	a_ai_robots[1].animname = "warehouse_robot02";
	
	//no longer need keyline on door pieces
	if ( isdefined( level.mdl_door_upper ) )
	{
		level.mdl_door_upper squad_control::disable_keyline();
	}
	
	if ( isdefined( level.mdl_door_lower ) )
	{
		level.mdl_door_lower squad_control::disable_keyline();
	}
	
	level thread cp_mi_sing_biodomes_warehouse::back_door_ai_retreat(); //used to make ai behind warehouse door retreat once it starts to open
	level.mdl_clip thread warehouse_door_clip();
	
	objectives::complete( "cp_level_biodomes_robot_task_door" , struct::get( "s_warehouse_door_indicator" ) );
	
	//see if there are any ai available for Hendricks to shoot and play appropriate scene
	n_alive_doorway = spawner::get_ai_group_sentient_count( "back_door_enemy" );
	
	if ( n_alive_doorway > 0 )
	{
		level thread scene::play( "scene_warehouse_door", "targetname" );
	}
	else
	{
		level thread scene::play( "scene_warehouse_door_noshoot", "targetname" );
	}
	
	//notetrack is called when robots finish opening door. Hendricks automatically goes into a waiting loop
	level waittill( "notetrack_warehouse_scene_done" );
	
	s_scene = struct::get( "tag_align_cloudmountain_warehouse_door" );
	s_scene thread scene::play( "cin_bio_06_01_backdoor_vign_open_loop" );
	
	level flag::set( "back_door_opened" );
	
	level.ai_hendricks colors::enable();
	
	level notify( "open" );
	
	wait 1;  //give time for scene to finish
	
	if ( isdefined( e_task ) )
	{
		e_task delete();
	}
	
	a_ai_robots = [];
	
	//wait for players to move through before breaking Hendricks out of his loop
	level flag::wait_till( "warehouse_done" );
	
	//this makes sure Hendricks breaks out of his loop that's at the end of the door opening scene
	level thread scene::stop( "scene_warehouse_door", "targetname" );
	level thread scene::stop( "scene_warehouse_door_noshoot", "targetname" );
}

function robot_waittill_goal( nd_pos )
{
	self endon( "death" );
	
	self SetGoal( nd_pos, true );
	self util::waittill_any_timeout( 20, "goal" );
	self.goalradius = 4;
	self.b_ready = true;
}

function warehouse_door_clip()  //self = clip
{
	level waittill( "notetrack_warehouse_door" );
	
	GetEnt( "back_door_collision" , "targetname" ) Delete();
	GetEnt( "back_door_sight_clip" , "targetname" ) Delete();
	
	self Connectpaths();
	self Delete();
}

function task_timeout( n_wait, str_flag )
{
	level endon( str_flag );
	
	wait n_wait;
	
	level flag::set( str_flag );
}

function robots_reached_positions( a_robots, str_flag )
{
	level endon( str_flag );
	
	array::wait_till( a_robots, "goal" );
	
	level flag::set( str_flag );
}

function monitor_squad()  //self = player
{
	self endon( "disconnect" );
	self endon( "end_squad_control" );
	
	if ( level.b_squad_player_controlled )
	{
		self waittill( "player_squad_dead" );
		
		self notify( "end_squad_control" );
	}

}

function replenish_squad( ai_robot )  //self = player
{
	self endon( "disconnect" );
	self endon( "end_squad_control" );
	
	while ( true )
	{
		ai_robot waittill( "death" );
		
		//TODO find a nearby robot spawner and bring in a new robot
		
		//add back to player's squad and reinitialize them
		
		//run replenish_squad on robot
		
		break;
	}
}

function remove_squad_member( player )  //self = squad member
{
	self waittill( "death" );
	
	ArrayRemoveValue( player.a_robots, self );
	ArrayRemoveValue( player.a_squad, self );
	ArrayRemoveValue( level.a_ai_squad, self );
	
	if ( player.a_squad.size <= 0 )
	{
		player notify( "player_squad_dead" );
	}
}
	
function create_temp_icon( str_obj_type, str_obj_name, v_pos, v_offset = ( 0,0,0 ) )
{
	switch( str_obj_type )
	{
		case "target":
			str_shader = "waypoint_targetneutral";
			break;
			
		case "task":
			str_shader = "waypoint_captureneutral";
			break;
			
		case "goto":
			str_shader = "waypoint_circle_arrow_green";
			break;
			
		default:
			AssertMsg( "Type '" + str_obj_type + "' not supported. Please see create_temp_icon() in _objectives.gsc for supported types." );
			break;
	}
	
	nextObjPoint = objpoints::create( str_obj_name, v_pos + v_offset, "all", str_shader, 0.75, 0.25 );
	nextObjPoint setWayPoint( false, str_shader );
	
	return nextObjPoint;
}

function destroy_temp_icon()
{
	objpoints::delete( self );
}

function callback_robot_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	iDamage *= 0.6;
	
	if ( isdefined( eAttacker ) && IsPlayer( eAttacker ) )
	{
		if ( sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSIVE" || sMeansOfDeath == "MOD_EXPLOSIVE_SPLASH" || sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" )
		{
			return Int( iDamage );
		}
		else
		{
			iDamage = 0;
		}
	}
	
	return Int( iDamage );
}

function groundpos_ignore_water( origin )
{
	return groundtrace( origin, ( origin + ( 0, 0, -100000 ) ), false, undefined, true )[ "position" ];
}


//////////////////////////////////////////////////////////////////////////////////
/// Keyline and Squad Indicator Stuff
//////////////////////////////////////////////////////////////////////////////////

// self == player
//
function get_keyline_field()
{
	return "keyline_outline_p" + self GetEntityNumber();
}

//self is a player
function get_indicator_field()
{
	return "squad_indicator_p" + self GetEntityNumber();
}

//self is a robot
function enable_indicator( e_player, b_indicator )
{
	self endon( "death" );
	
	str_field = e_player get_indicator_field();
	self clientfield::set( str_field, b_indicator );
}

function enable_keyline( n_color_value, e_player, str_disable_notify )  //self = entity
{
	self endon( "death" );
	
	if(!isdefined(self.keyline_players))self.keyline_players=[];
	a_players = GetPlayers();
	if ( isdefined( e_player ) )
	{
		a_players = array( e_player );
		e_player endon( "disconnect" );
	}
	
	foreach( player in a_players )
	{
		str_field = player get_keyline_field();
		self clientfield::set( str_field, n_color_value  );
		array::add( self.keyline_players, e_player, false );
	}
	
	self SetForceNoCull();
	
	self thread disable_keyline_on_death();
}

function disable_keyline_on_death()  //self = entity
{
	self notify( "disable_keyline_on_death" );
	self endon( "disable_keyline_on_death" );
	
	self waittill( "death" );
	
	if ( isdefined( self ) )
	{
		self thread disable_keyline();
	}
}

function disable_keyline( e_player )  //self = entity
{
	a_players = GetPlayers();
	
	if ( isdefined( e_player ) )
	{
		a_players = array( e_player );
	}
	
	if(!isdefined(self.keyline_players))self.keyline_players=[];
	
	foreach( player in a_players )
	{
		str_field = player get_keyline_field();
		
		self clientfield::set( str_field, 0  );
		
		ArrayRemoveValue( self.keyline_players, player, false );
	}
	
	if ( isdefined( self.keyline_players ) && self.keyline_players.size == 0 )
	{
		self RemoveForceNoCull();
	}
}
