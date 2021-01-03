#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

                                                                                       	                                
                                                                                                                               

#namespace zm_blockers;

function autoexec __init__sytem__() {     system::register("zm_blockers",&__init__,&__main__,undefined);    }
	
function __init__()
{
	//////////////////////////////////////////////////////////////////////////////////////	//
	// Zombie Window and Blockers speaks between two main scripts _zombiemode_blockers
	// and _zombiemode_spawner and _zombimode _utility
	//////////////////////////////////////////////////////////////////////////////////////
	 
	// Debris
	zm_utility::add_zombie_hint( "default_buy_debris", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_COST" );

	// Doors
	zm_utility::add_zombie_hint( "default_buy_door", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_COST" );
	zm_utility::add_zombie_hint( "default_buy_door_close", &"ZOMBIE_BUTTON_BUY_CLOSE_DOOR" );

	init_blockers(); 

//	level thread rebuild_barrier_think(); 

	//////////////////////////////////////////
	//designed by prod
	//zombie_utility::set_zombie_var( "rebuild_barrier_cap_per_round", 500 );
	//////////////////////////////////////////
}

function __main__()
{
  	if ( isdefined( level.quantum_bomb_register_result_func ) )
  	{
  		[[level.quantum_bomb_register_result_func]]( "open_nearest_door", &quantum_bomb_open_nearest_door_result, 35, &quantum_bomb_open_nearest_door_validation );
  	}	
}

//
//	BLOCKERS
//
function init_blockers()
{
	// EXTERIOR BLOCKERS ----------------------------------------------------------------- //
	level.exterior_goals = struct::get_array( "exterior_goal", "targetname" ); 
	array::thread_all(level.exterior_goals, &blocker_init);

	// DOORS ----------------------------------------------------------------------------- //
	zombie_doors = GetEntArray( "zombie_door", "targetname" ); 
	if(IsDefined(zombie_doors))
	{
		level flag::init("door_can_close");
		array::thread_all(zombie_doors, &door_init);
	}
	// DEBRIS ---------------------------------------------------------------------------- //
	zombie_debris = GetEntArray( "zombie_debris", "targetname" ); 
	array::thread_all(zombie_debris, &debris_init);

	// Flag Blockers ---------------------------------------------------------------------- //
	flag_blockers = GetEntArray( "flag_blocker", "targetname" );
	array::thread_all(flag_blockers, &flag_blocker);
}


//
// DOORS --------------------------------------------------------------------------------- //
//
function door_init()
{
	self.type = undefined; 
	self.purchaser = undefined;	
	self._door_open = false;


	// Figure out what kind of door we are
	targets = GetEntArray( self.target, "targetname" ); 
	
	//CHRIS_P - added script_flag support for doors as well
	if( isDefined(self.script_flag) && !IsDefined( level.flag[self.script_flag] ) ) 
	{
		// Initialize any flags called
		if( IsDefined( self.script_flag ) )
		{
			tokens = Strtok( self.script_flag, "," );
			for ( i=0; i<tokens.size; i++ )
			{
				level flag::init( self.script_flag );
			}
		}

	}	

	// Door trigger types
	if ( !IsDefined( self.script_noteworthy ) )
	{
		self.script_noteworthy = "default";
	}

	//MM Consolidate type codes for each door into script_string
	self.doors = [];
	for(i=0;i<targets.size;i++)
	{
		targets[i] door_classify( self );
		
		if(!isDefined(targets[i].og_origin))
		{
			targets[i].og_origin = targets[i].origin;
			targets[i].og_angles = targets[i].angles;
		}
	}

	//assert( IsDefined( self.type ), "You must determine how this door opens. Specify script_angles, script_vector, or a script_noteworthy... Door at: " + self.origin ); 
	cost = 1000;
	if( IsDefined( self.zombie_cost ) )
	{
		cost = self.zombie_cost;
	}

	self SetCursorHint( "HINT_NOICON" );

	// MM (03/09/10) - Allow activation at any time in order to make it easier to open bigger doors.
//	self UseTriggerRequireLookAt();
	self thread door_think(); 

	// MM - Added support for electric doors.  Don't have to add them to level scripts
	if ( IsDefined( self.script_noteworthy ) )
	{
		if ( self.script_noteworthy == "electric_door" || self.script_noteworthy == "electric_buyable_door" )
		{
			if ( GetDvarString( "ui_gametype" ) == "zgrief" )
			{
				self SetInvisibleToAll();
				return;
			}
			
			self sethintstring(&"ZOMBIE_NEED_POWER");
//			self set_door_unusable();
			if( isDefined( level.door_dialog_function ) )
			{
				self thread [[ level.door_dialog_function ]]();
			}
			return;
		}
		else if ( self.script_noteworthy == "local_electric_door" )
		{
			if ( GetDvarString( "ui_gametype" ) == "zgrief" )
			{
				self SetInvisibleToAll();
				return;
			}
			
			self sethintstring(&"ZOMBIE_NEED_LOCAL_POWER");
//			self set_door_unusable();
			if( isDefined( level.door_dialog_function ) )
			{
				self thread [[ level.door_dialog_function ]]();
			}
			return;
		}
		else if ( self.script_noteworthy == "kill_counter_door" )
		{
			self sethintstring(&"ZOMBIE_DOOR_ACTIVATE_COUNTER", cost);
			return;
		}
	}

	self zm_utility::set_hint_string( self, "default_buy_door", cost );
}


//
//	Help fix-up doors not using script_string and also to reclassify non-door entities.
//
function door_classify( parent_trig )
{
	if ( IsDefined(self.script_noteworthy) && self.script_noteworthy == "clip" )
	{
		parent_trig.clip = self;
		parent_trig.script_string = "clip";
	}
	else if( !IsDefined( self.script_string ) )
	{
		if( IsDefined( self.script_angles ) )
		{
			self.script_string = "rotate";
		}
		else if( IsDefined( self.script_vector ) )
		{
			self.script_string = "move";
		}
	}
	else
	{
		if ( !IsDefined( self.script_string ) )
		{
			self.script_string = "";
		}

		// Handle other script_strings here
		switch( self.script_string )
		{
		case "anim":
			assert( IsDefined( self.script_animname ), "Blocker_init: You must specify a script_animname for "+self.targetname ); 
			assert( IsDefined( level.scr_anim[ self.script_animname ] ), "Blocker_init: You must define a level.scr_anim for script_anim -> "+self.script_animname ); 
			assert( IsDefined( level.blocker_anim_func ), "Blocker_init: You must define a level.blocker_anim_func" ); 
			break;

		case "counter_1s":
			parent_trig.counter_1s = self;
			return;	// this is not a door element

		case "counter_10s":
			parent_trig.counter_10s = self;
			return;	// this is not a door element

		case "counter_100s":
			parent_trig.counter_100s = self;
			return;	// this is not a door element

		case "explosives":
			if ( !IsDefined(parent_trig.explosives) )
			{
				parent_trig.explosives = [];
			}
			parent_trig.explosives[parent_trig.explosives.size] = self;
			return;	// this is not a door element
		}
	}

	if ( self.classname == "script_brushmodel" )
	{
		self DisconnectPaths();
	}
	parent_trig.doors[parent_trig.doors.size] = self;
}


//
//	Someone just tried to buy the door
//		return true if door was bought
//		NOTE: This is currently intended to be used as a non-threaded call 
//	self is a door trigger
function door_buy()
{
	self waittill( "trigger", who, force ); 
	
	if ( IsDefined( level.custom_door_buy_check ) )
	{
		if ( !who [[ level.custom_door_buy_check ]]( self ) )
		{
			return false;		
		}
	}
	
	if(GetDvarInt( "zombie_unlock_all") > 0 || ( isdefined( force ) && force ) )
	{
		return true;		
	}	
	
	if( !who UseButtonPressed() )
	{
		return false;
	}

	if( who zm_utility::in_revive_trigger() )
	{
		return false;
	}

	if( ( who.is_drinking > 0 ) )
	{
		return false;
	}

	if( zm_utility::is_player_valid( who ) )
	{
		players = GetPlayers();

		// Get the cost of the door
		cost = self.zombie_cost;
		if( who zm_pers_upgrades_functions::is_pers_double_points_active() )
		{
			cost = who zm_pers_upgrades_functions::pers_upgrade_double_points_cost( cost );
		}

		if( /*(IsDefined(self.purchaser) && self.purchaser == who) &&*/ self._door_open == true)
		{
			self.purchaser = undefined;
		}	
		else if( who.score >= cost )
		{
			who zm_score::minus_to_player_score( cost, true );
			demo::bookmark( "zm_player_door", gettime(), who );
			who zm_stats::increment_client_stat( "doors_purchased" );
			who zm_stats::increment_player_stat( "doors_purchased" );
			self.purchaser = who;
		}
		else // Not enough money
		{
			zm_utility::play_sound_at_pos( "no_purchase", self.doors[0].origin );
			
			if(isDefined(level.custom_generic_deny_vo_func))
			{
				who thread [[level.custom_generic_deny_vo_func]](true);
			}
			else
			{
				who zm_audio::create_and_play_dialog( "general", "outofmoney" );
			}
			return false;
		}

	}

	if(IsDefined(level._door_open_rumble_func))
	{
		who thread [[ level._door_open_rumble_func ]]();
	}
	
	return true;
}


//
//	Open a delay door once the time has expired
//	self is a door
function door_delay()
{
	// Show explosives
	if ( IsDefined( self.explosives ) )
	{
		for ( i=0; i<self.explosives.size; i++ )
		{
			self.explosives[i] Show();
		}
	}

	// Now wait
	if (!IsDefined(self.script_int) )
	{
		self.script_int = 5;
	}

	// Turn off the triggers.
	all_trigs = getentarray( self.target, "target" ); 
	for( i = 0; i < all_trigs.size; i++ )
	{
		all_trigs[i] TriggerEnable( false ); 
	}

	wait (self.script_int);
	for ( i=0; i<self.script_int; i++ )
	{
		/#
		iprintln( self.script_int - i );
		#/
		wait(1);
	}

	// Time's Up!
	// Show explosives
	if ( IsDefined( self.explosives ) )
	{
		for ( i=0; i<self.explosives.size; i++ )
		{
			PlayFX( level._effect["def_explosion"], self.explosives[i].origin, AnglesToForward(self.explosives[i].angles) );
			self.explosives[i] Hide();
		}
	}
}




//
//	Make the door do its thing
//	self is a door
//	open: true makes the door open, false makes it close (reverse operation).  Defaults to TRUE
//		NOTE: open is currently ONLY supported for  "move" type doors
//	time is a time override
function door_activate( time, open, quick, use_blocker_clip_for_pathing )
{
	if ( !IsDefined( open ))
	{
		open = true;
	}	

	if ( !IsDefined(time) )
	{
		time = 1; 
		if( IsDefined( self.script_transition_time ) )
		{
			time = self.script_transition_time; 
		}
	}
	

	// Prevent multiple triggers from making doors move more than once
	if ( IsDefined(self.door_moving) )
	{
		if ( ( IsDefined( self.script_noteworthy )	&& self.script_noteworthy == "clip" ) ||
			( IsDefined( self.script_string )		&& self.script_string == "clip" ) )
		{
			if ( !( isdefined( use_blocker_clip_for_pathing ) && use_blocker_clip_for_pathing ) )
			{
				if(!open)
					return;	
			}
		}
		else
		{	
			return;
		}	
	}
	self.door_moving = 1;	
	level notify( "sndDoorOpening" );
		
	if (open || !( isdefined( quick ) && quick ))
		self NotSolid();
	//else
	//	self Solid();

	if(self.classname == "script_brushmodel" || self.classname == "script_model")
	{
		if ( open )
		{
			self ConnectPaths();
		}	
	}

	if ( ( IsDefined( self.script_noteworthy )	&& self.script_noteworthy == "clip" ) ||
		( IsDefined( self.script_string )		&& self.script_string == "clip" ) )
	{
		if(!open)
		{
			self util::delay( time, undefined, &self_disconnectpaths );
			wait(.1);
			self Solid();
		}
		return;
	}
	
	if( IsDefined( self.script_sound ) )
	{
		if( open )
			playsoundatposition( self.script_sound, self.origin );
		else
			playsoundatposition( self.script_sound + "_close", self.origin );
	}
	else
	{
		zm_utility::play_sound_at_pos( "zmb_heavy_door_open", self.origin );
	}

	// scale
	scale = 1;
	if ( !open )
	{
		scale = -1;
	}

	// MM - each door can now have a different opening style instead of
	//	needing to be all the same
	switch( self.script_string )
	{
	case "rotate":
		if(isDefined(self.script_angles))
		{
			rot_angle = self.script_angles;
			if(!open)
			{
				rot_angle = self.og_angles;
			}
			self RotateTo( rot_angle, time, 0, 0 ); 
			//if (open || !IS_TRUE(quick))
				self thread door_solid_thread();
			if ( !open )
			{
				self thread disconnect_paths_when_done();
			}
		}
		wait(randomfloat(.15));						
		break;
	case "move":
	case "slide_apart":
		if(isDefined(self.script_vector))
		{
			vector = VectorScale( self.script_vector, scale );
			if ( time >= 0.5 )
			{
				self MoveTo( self.origin + vector, time, time * 0.25, time * 0.25 ); 
			}
			else
			{
				self MoveTo( self.origin + vector, time ); 
			}
			//if (open || !IS_TRUE(quick))
				self thread door_solid_thread();
			if ( !open )
			{
				self thread disconnect_paths_when_done();
			}
		}
		wait(randomfloat(.15));
		break;

	case "anim":
		//						self animscripted( "door_anim", self.origin, self.angles, level.scr_anim[ self.script_animname ] );
		self [[ level.blocker_anim_func ]]( self.script_animname ); 
		self thread door_solid_thread_anim();
		wait(randomfloat(.15));						
		break;

	case "physics":
		self thread physics_launch_door( self );
		wait(0.10);						
		break;
	case "zbarrier":
		self thread door_zbarrier_move();
		break;
	}

	if( IsDefined( self.script_firefx ) )
	{
		PlayFX( level._effect[self.script_firefx], self.origin );
	}
}


function kill_trapped_zombies(trigger)
{
	zombies = GetAiTeamArray( level.zombie_team );
	if ( !isDefined( zombies ) )
	{
		return;
	}	
		
	for (i=0; i<zombies.size; i++)
	{
		if ( !isdefined( zombies[i] ) )
		{
			continue;
		}

		if ( zombies[i] istouching(trigger) )
		{
			zombies[i].marked_for_recycle = 1;
			zombies[i] DoDamage( zombies[i].health + 666, trigger.origin, self );
			wait RandomFloat(0.15);
		}
		else if(IsDefined(level.custom_trapped_zombies))
		{
			zombies[i] thread [[level.custom_trapped_zombies]]();
			wait RandomFloat(0.15);
		}
	}
}
	
function any_player_touching( trigger )
{
	foreach( player in GetPlayers() )
	{
		if ( player IsTouching(trigger))
			return true;
		wait 0.01;
	}
	return false;
}

function any_player_touching_any( trigger, more_triggers ) 
{
	foreach( player in GetPlayers() )
	{
		if( zm_utility::is_player_valid(player, false, true) )
		{
			if (isdefined(trigger) && player IsTouching(trigger))
				return true;
			if (isdefined(more_triggers) && more_triggers.size>0)
				foreach(trig in more_triggers)
					if (isdefined(trig) && player IsTouching(trig))
						return true;
		}
	}
	return false;
}
	

function any_zombie_touching_any( trigger, more_triggers ) 
{
	zombies = GetAiTeamArray( level.zombie_team );
	foreach ( zombie in zombies ) 
	{
		if (isdefined(trigger) && zombie IsTouching(trigger))
			return true;
		if (isdefined(more_triggers) && more_triggers.size>0)
			foreach(trig in more_triggers)
				if (isdefined(trig) && zombie IsTouching(trig))
					return true;
	}
	return false;
}
	
	
function wait_trigger_clear( trigger, more_triggers, end_on )
{
	self endon( end_on );
	while( any_player_touching_any( trigger, more_triggers ) || any_zombie_touching_any( trigger, more_triggers ) )
	{
		wait 1;
	}
	/# println("ZM BLOCKER local door trigger clear\n"); #/
	self notify("trigger_clear");
}


function waittill_door_trigger_clear_local_power_off(trigger, all_trigs)
{
	self endon("trigger_clear");
	while(1)
	{
		if (( isdefined( self.local_power_on ) && self.local_power_on ))
			self waittill( "local_power_off" );
		/# println("ZM BLOCKER local door power off\n"); #/
		self wait_trigger_clear( trigger, all_trigs, "local_power_on" );
	}
}
	
function waittill_door_trigger_clear_global_power_off(trigger, all_trigs)
{
	self endon("trigger_clear");
	while(1)
	{
		if (( isdefined( self.power_on ) && self.power_on ))
			self waittill( "power_off" );
		/# println("ZM BLOCKER global door power off\n"); #/
		self wait_trigger_clear( trigger, all_trigs, "power_on" );
	}
}
	
function waittill_door_can_close()
{
	trigger = undefined;
	if (isdefined(self.door_hold_trigger))
	{
		trigger = GetEnt(self.door_hold_trigger,"targetname");
	}
	all_trigs = getentarray( self.target, "target" ); 
		
	switch( self.script_noteworthy )
	{
	case "local_electric_door":
		if (isdefined(trigger) || isdefined(all_trigs) )
		{
			self waittill_door_trigger_clear_local_power_off(trigger, all_trigs);
			self thread kill_trapped_zombies(trigger);
		}
		else
		{
			if (( isdefined( self.local_power_on ) && self.local_power_on ))
				self waittill( "local_power_off" );
		}
		return;
		
	case "electric_door":
		if (isdefined(trigger) || isdefined(all_trigs) )
		{
			self waittill_door_trigger_clear_global_power_off(trigger, all_trigs);
			if (isdefined(trigger))
				self thread kill_trapped_zombies(trigger);
		}
		else
		{
			if (( isdefined( self.power_on ) && self.power_on ))
				self waittill( "power_off" );
		}
		return;
	}
}


//
//	Wait to be opened!
//	self is a door trigger
function door_think()
{
	self endon("kill_door_think");

	// maybe the door the should just bust open instead of slowly opening.
	// maybe just destroy the door, could be two players from opposite sides..
	// breaking into chunks seems best.
	// or I cuold just give it no collision

	cost = 1000;
	if( IsDefined( self.zombie_cost ) )
	{
		cost = self.zombie_cost;
	}
	
	self SetHintLowPriority( true );

	while( 1 )
	{
		switch( self.script_noteworthy )
		{
		case "local_electric_door":
			if (!( isdefined( self.local_power_on ) && self.local_power_on ))
				self waittill( "local_power_on" );
			if (!( isdefined( self._door_open ) && self._door_open )) 
			{
				/# println("ZM BLOCKER local door opened\n"); #/
				self door_opened(cost,true);
				if (!isdefined(self.power_cost))
					self.power_cost = 0;
				self.power_cost += 200;
			}
			self setHintString("");

			if( ( isdefined( level.local_doors_stay_open ) && level.local_doors_stay_open ) )
			{
				return;
			}

			//Else door can be closed
			wait 3;
			self waittill_door_can_close();
			self door_block();
			if (( isdefined( self._door_open ) && self._door_open )) 
			{
				/# println("ZM BLOCKER local door closed\n"); #/
				self door_opened(cost,true);
			}
			self sethintstring(&"ZOMBIE_NEED_LOCAL_POWER");
			wait 3;
			continue;
			
		case "electric_door":
			if (!( isdefined( self.power_on ) && self.power_on ))
				self waittill( "power_on" );
			if (!( isdefined( self._door_open ) && self._door_open )) 
			{
				/# println("ZM BLOCKER global door opened\n"); #/
				self door_opened(cost,true);
				if (!isdefined(self.power_cost))
					self.power_cost = 0;
				self.power_cost += 200;
			}
			self setHintString("");

			if( ( isdefined( level.local_doors_stay_open ) && level.local_doors_stay_open ) )
			{
				return;
			}

			//Else door can be closed
			wait 3;
			self waittill_door_can_close();
			self door_block();
			if (( isdefined( self._door_open ) && self._door_open )) 
			{
				/# println("ZM BLOCKER global door closed\n"); #/
				self door_opened(cost,true);
			}
			self sethintstring(&"ZOMBIE_NEED_POWER");
			wait 3;
			continue;
			//self self_and_flag_wait( "power_on" );
			//self door_opened(cost);
			//return;

		case "electric_buyable_door":
			if (!( isdefined( self.power_on ) && self.power_on ))
				self waittill( "power_on" );
				
			self zm_utility::set_hint_string( self, "default_buy_door", cost );
//			self UseTriggerRequireLookAt();

			if ( !self door_buy() )
			{
				continue;
			}
			break;

		case "delay_door":	// set timer and explode
			if ( !self door_buy() )
			{
				continue;
			}

			self door_delay();
			break;

		default:
			if(isDefined( level._default_door_custom_logic))
			{
				self [[level._default_door_custom_logic]]();
				break;
			}		
			if ( !self door_buy() )
			{
				continue;
			}
			break;
		}

		self door_opened(cost);
		if(!level flag::get("door_can_close"))
		{
			break;
		}	
	}
}

function self_and_flag_wait( msg )
{
	self endon( msg );
	
	if ( ( isdefined( self.power_door_ignore_flag_wait ) && self.power_door_ignore_flag_wait ) )
	{
		level waittill( "forever" );
	}
	else
	{
		level flag::wait_till( msg );
	}
}

function door_block()
{
	if(isdefined(self.doors)) //forces collision early
	{
		// block the door 
		for(i=0;i<self.doors.size;i++)
		{
			if ( ( IsDefined( self.doors[i].script_noteworthy )	&& self.doors[i].script_noteworthy == "clip" ) ||
				( IsDefined( self.doors[i].script_string )		&& self.doors[i].script_string == "clip" ) )
				self.doors[i] Solid();
		}
	}
}


function door_opened(cost,quick_close)
{
	if ( ( isdefined( self.door_is_moving ) && self.door_is_moving ) )
		return;
			
	self.has_been_opened = true;	//for tracking

	// get all trigs for the door, we might want a trigger on both sides
	// of some junk sometimes		
	all_trigs = getentarray( self.target, "target" ); 
	
	self.door_is_moving = true; // just in case this doesn't target itself
	foreach ( trig in all_trigs )
	{
		trig.door_is_moving = true;
		trig TriggerEnable( false ); 
		
		trig.has_been_opened = true;	//for achievement & stat tracking
		if ( !IsDefined( trig._door_open ) || (trig._door_open == false))
		{
			trig._door_open = true;
			trig notify("door_opened");			
		}
		else	// close the door instead.
		{
			trig._door_open = false;
		}
		
		// Set any flags called
		if( IsDefined( trig.script_flag ) && trig._door_open == true)
		{
			tokens = Strtok( trig.script_flag, "," );
			for ( i=0; i<tokens.size; i++ )
			{
				level flag::set( tokens[i] );
			}
		}
		else if(IsDefined( trig.script_flag ) && trig._door_open == false)
		{
			tokens = Strtok( trig.script_flag, "," );
			for ( i=0; i<tokens.size; i++ )
			{
				level flag::clear( tokens[i] );
			}
		}
		
		if ( ( isdefined( quick_close ) && quick_close ) )
		{
			trig zm_utility::set_hint_string( trig, "" );
		}
		else if(trig._door_open == true && level flag::get("door_can_close"))
		{
			trig zm_utility::set_hint_string( trig, "default_buy_door_close" );
		}
		else if(trig._door_open == false)
		{
			trig zm_utility::set_hint_string( trig, "default_buy_door", cost );
		}
	}

	level notify("door_opened");	//for achievement & stat tracking
	
	if(isdefined(self.doors))
	{
		is_script_model_door = false;
		have_moving_clip_for_door = false;
		use_blocker_clip_for_pathing = false;
		
		foreach ( door in self.doors )
		{
			if ( ( isdefined( door.ignore_use_blocker_clip_for_pathing_check ) && door.ignore_use_blocker_clip_for_pathing_check ) )
			{
				continue;
			}
			
			if ( door.classname == "script_model" )
			{
				is_script_model_door = true;
				continue;
			}
			
			if ( door.classname == "script_brushmodel" &&
			    ( !IsDefined( door.script_noteworthy ) || door.script_noteworthy != "clip" ) &&
			    ( !IsDefined( door.script_string ) || door.script_string != "clip" ) )
	    	{
				have_moving_clip_for_door = true;
	    	}
		}
		
		use_blocker_clip_for_pathing = is_script_model_door && !have_moving_clip_for_door;
		
		// Door has been activated, make it do its thing
		for(i=0;i<self.doors.size;i++)
		{			
			// Don't thread this so the doors don't move at once
			// DCS 072812: was there a reason? this breaks if two triggers activated simultaneously otherwise.
			self.doors[i] thread Door_Activate(self.doors[i].script_transition_time, self._door_open, quick_close, use_blocker_clip_for_pathing);
		}
		// Just play purchase sound on the first door
		if( self.doors.size )
		{
			zm_utility::play_sound_at_pos( "purchase", self.doors[0].origin );
		}
	}
	
	// Update the active zone names (so our unitriggers are responsive)
	// NOTE: THIS FUNCTION MAY BLOCK
	level.active_zone_names = zm_zonemgr::get_active_zone_names();

	wait( 1 ); // wait a second to ensure a trigger at a multi-door on the same frame (accounting for lag) doesn't trigger a close
	self.door_is_moving = false; // just in case this doesn't target itself
	foreach ( trig in all_trigs )
	{
		trig.door_is_moving = false;
	}

	if ( ( isdefined( quick_close ) && quick_close ) )
	{
		for( i = 0; i < all_trigs.size; i++ )
		{
			all_trigs[i] TriggerEnable( true ); 
		}	
		return;
	}

	
	// Check if doors can be closed.
	if(level flag::get("door_can_close") )
	{
		wait(2.0);
		
		for( i = 0; i < all_trigs.size; i++ )
		{
			all_trigs[i] TriggerEnable( true ); 
		}	
	}
}


//
//	Launch the door!
//	self = door entity
//	door_trig = door trigger
function physics_launch_door( door_trig )
{
	vec = VectorScale( VectorNormalize( self.script_vector ), 10 );
	self RotateRoll( 5, 0.05 );
	{wait(.05);};
	self MoveTo( self.origin + vec, 0.1 );
	self waittill( "movedone" );

	self PhysicsLaunch( self.origin, self.script_vector *300 );
	//wait(0.1);
	//PhysicsExplosionSphere( VectorScale( vec, -1 ), 120, 1, 100 );

	wait(60);

	self delete();
}


//
//	Waits until it is finished moving and then returns to solid once no player is touching it
//		(So they don't get stuck).  The door is made notSolid initially, otherwise, a player
//		could block its movement or cause a player to become stuck.
//	self is a door
function door_solid_thread()
{
	// MM - added support for movedone.
	self util::waittill_either( "rotatedone", "movedone" ); 

	self.door_moving = undefined;
	while( 1 )
	{
		players = GetPlayers(); 
		player_touching = false; 
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] IsTouching( self ) )
			{
				player_touching = true; 
				break; 
			}
		}

		if( !player_touching )
		{
			self Solid(); 
			return; 
		}

		wait( 1 ); 
	}
}


//
//	Called on doors using anims.  It needs a different waittill, 
//		and expects the animname message to be the same as the one passed into scripted anim
//	self is a door
function door_solid_thread_anim( )
{
	// MM - added support for movedone.
	self waittillmatch( "door_anim", "end" ); 

	self.door_moving = undefined;
	while( 1 )
	{
		players = GetPlayers(); 
		player_touching = false; 
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] IsTouching( self ) )
			{
				player_touching = true; 
				break; 
			}
		}

		if( !player_touching )
		{
			self Solid(); 
			return; 
		}

		wait( 1 ); 
	}
}


//
//
//
function disconnect_paths_when_done()
{
	self util::waittill_either( "rotatedone", "movedone" );

	self DisconnectPaths();
}


//
//
//
function self_disconnectpaths()
{
	self DisconnectPaths();
}

//
// DEBRIS - these are "doors" that consist of various pieces of piled objects
//		they lift up and disappear when bought.
//
function debris_init()
{
	cost = 1000;
	if( IsDefined( self.zombie_cost ) )
	{
		cost = self.zombie_cost;
	}

	self zm_utility::set_hint_string( self, "default_buy_debris", cost );
	self setCursorHint( "HINT_NOICON" );
	
	if( isdefined (self.script_flag)  && !IsDefined( level.flag[self.script_flag] ) )
	{
		level flag::init( self.script_flag ); 
	}
	
	// Look for zbarrier debris and initialize it.
	if ( isdefined( self.target ) )
	{
		targets = GetEntArray( self.target, "targetname" );
		foreach( target in targets )
		{
			if ( target IsZBarrier() )
			{
				for( i=0; i < target GetNumZBarrierPieces(); i++ )
				{
					target SetZBarrierPieceState( i, "closed" );		
				}
			}
		}
	}

//	self UseTriggerRequireLookAt();
	self thread debris_think(); 
}


//
//	self is a debris trigger
//
function debris_think()
{
	
	if( isDefined( level.custom_debris_function ) )
	{
		self [[ level.custom_debris_function ]]();
	}	

	// cut the navmesh
	junk = getentarray( self.target, "targetname" ); 
	for( i = 0; i < junk.size; i++ )
	{	
		if( IsDefined( junk[i].script_noteworthy ) )
		{
			if( junk[i].script_noteworthy == "clip" )
			{
				junk[i] disconnectpaths(); 
			}
		}
	}
	
	while( 1 )
	{
		self waittill( "trigger", who, force ); 

		if(GetDvarInt( "zombie_unlock_all") > 0 || ( isdefined( force ) && force ) )
		{
			//bypass.
		}
		else
		{	
			if( !who UseButtonPressed() )
			{
				continue;
			}

			if( ( who.is_drinking > 0 ) )
			{
				continue;
			}
	
			if( who zm_utility::in_revive_trigger() )
			{
				continue;
			}
		}
		
		if( zm_utility::is_player_valid( who ) )
		{
			// Can we afford this door?
			players = GetPlayers();
			if(GetDvarInt( "zombie_unlock_all") > 0)
			{
				// bypass charge.
			}
			else if ( /*players.size == 1 &&*/ who.score >= self.zombie_cost )
			{
				// solo buy
				who zm_score::minus_to_player_score( self.zombie_cost ); 
				demo::bookmark( "zm_player_door", gettime(), who );
				who zm_stats::increment_client_stat( "doors_purchased" );
				who zm_stats::increment_player_stat( "doors_purchased" );
			}
/*
			else if( level.team_pool[ who.team_num ].score >= self.zombie_cost )
			{
				// team buy
				who zm_score::minus_to_team_score( self.zombie_cost ); 
			}
			else if( level.team_pool[ who.team_num ].score + who.score >= self.zombie_cost )
			{
				// team funds + player funds
				team_points = level.team_pool[ who.team_num ].score;
				who zm_score::minus_to_player_score( self.zombie_cost - team_points ); 
				who zm_score::minus_to_team_score( team_points ); 
			}
*/
			else
			{
				zm_utility::play_sound_at_pos( "no_purchase", self.origin );
				who zm_audio::create_and_play_dialog( "general", "outofmoney" );
				continue;
			}

			// Okay remove the debris
			// delete the stuff
			junk = getentarray( self.target, "targetname" ); 

			// Set any flags called
			if( IsDefined( self.script_flag ) )
			{
				tokens = Strtok( self.script_flag, "," );
				for ( i=0; i<tokens.size; i++ )
				{
					level flag::set( tokens[i] );
				}
			}

			zm_utility::play_sound_at_pos( "purchase", self.origin );
			level notify ("junk purchased");

			move_ent = undefined;
			clip = undefined;
			for( i = 0; i < junk.size; i++ )
			{	
				junk[i] connectpaths(); 
//				junk[i] add_new_zombie_spawners(); 

				if( IsDefined( junk[i].script_noteworthy ) )
				{
					if( junk[i].script_noteworthy == "clip" )
					{
						clip = junk[i];
						continue;
					}
				}

				struct = undefined;
				if ( junk[i] IsZBarrier() )
				{
					move_ent = junk[i];
					junk[i] thread debris_zbarrier_move();
				}
				else if( IsDefined( junk[i].script_linkTo ) )
				{
					struct = struct::get( junk[i].script_linkTo, "script_linkname" );
					if( IsDefined( struct ) )
					{
						move_ent = junk[i];
						junk[i] thread debris_move( struct );
					}
					else
					{
						junk[i] Delete();
					}
				}
				else
				{
					junk[i] Delete();
				}
			}
			
			// get all trigs, we might want a trigger on both sides
			// of some junk sometimes
			all_trigs = getentarray( self.target, "target" ); 
			for( i = 0; i < all_trigs.size; i++ )
			{
				all_trigs[i] delete(); 
			}

			if( IsDefined( clip ) )
			{
				if( IsDefined( move_ent ) )
				{
					move_ent waittill( "movedone" );
				}

				clip Delete();
			}
			
			break; 								
		}
	}
}

function debris_zbarrier_move()
{
	playsoundatposition ("zmb_lightning_l", self.origin);
	PlayFX( level._effect["poltergeist"], self.origin );

	for( i = 0; i < self GetNumZBarrierPieces(); i++ )
	{
		self thread move_chunk( i, true );
	}
}

function door_zbarrier_move()
{
	playsoundatposition ("zmb_lightning_l", self.origin);

	for( i = 0; i < self GetNumZBarrierPieces(); i++ )
	{
		self thread move_chunk( i, false );
	}
}

function move_chunk( index, b_hide )
{
	self SetZBarrierPieceState(index, "opening");
	while(self GetZBarrierPieceState(index) == "opening")
	{
		wait (0.1);
	}
	self notify( "movedone" );
	
	if( b_hide )
	{
		self HideZBarrierPiece( index );
	}
}


//
//	Moves the debris out of place
//	self is a debris piece
//
function debris_move( struct )
{
	self util::script_delay();
	//chrisp - prevent playerse from getting stuck on the stuff
	self notsolid();
	
	self zm_utility::play_sound_on_ent( "debris_move" );
	playsoundatposition ("zmb_lightning_l", self.origin);
	if( IsDefined( self.script_firefx ) )
	{
		PlayFX( level._effect[self.script_firefx], self.origin );
	}

	// Do a little jiggle, then move.
	if( IsDefined( self.script_noteworthy ) )
	{
		if( self.script_noteworthy == "jiggle" )
		{
			num = RandomIntRange( 3, 5 );
			og_angles = self.angles;
			for( i = 0; i < num; i++ )
			{
				angles = og_angles + ( -5 + RandomFloat( 10 ), -5 + RandomFloat( 10 ), -5 + RandomFloat( 10 ) );
				time = RandomFloatRange( 0.1, 0.4 );
				self Rotateto( angles, time );
				wait( time - 0.05 );
			}
		}
	}

	time = 0.5;
	if( IsDefined( self.script_transition_time ) )
	{
		time = self.script_transition_time; 
	}

	self MoveTo( struct.origin, time, time * 0.5 );
	self RotateTo( struct.angles, time * 0.75 );

	self waittill( "movedone" );

	//Z2 commented out missing sound, wouldn't go past.
	//self play_sound_on_entity("couch_slam");

	if( IsDefined( self.script_fxid ) )
	{
		PlayFX( level._effect[self.script_fxid], self.origin );
		playsoundatposition("zmb_zombie_spawn", self.origin); //just playing the zombie_spawn sound when it deletes the blocker because it matches the particle.
	}

	self Delete();

}

function blocker_disconnect_paths(start_node, end_node, two_way)
{
/*	if(!IsDefined(two_way))
		two_way = false;
		
	if(IsDefined(start_node) && IsDefined(end_node))
	{
		if(NodesAreLinked(start_node, end_node))
		{
			zm_utility::unlink_nodes(start_node, end_node);
		}

		if(NodesAreLinked(end_node, start_node) && two_way == true)
		{
			zm_utility::unlink_nodes(end_node, start_node);
		}
	} */
}

function blocker_connect_paths(start_node, end_node, two_way)
{
/*	if(IsDefined(start_node) && IsDefined(end_node))
	{
		if(!IsDefined(two_way))
			two_way = false;		
			
		if(!NodesAreLinked(start_node, end_node))
		{
			zm_utility::link_nodes(start_node, end_node);
		}

		if(!NodesAreLinked(end_node, start_node) && two_way == true)
		{
			zm_utility::link_nodes(end_node, start_node);
		}
	} */
}


//
// BLOCKER (aka window, bar, board)
// Self = exterior_goal, it is the node that targets all of the boards and bars
// This sets up every window in level,
function blocker_init()
{
	if( !IsDefined( self.target ) ) // If the exterior_goal entity has no targets defined then return
	{
		return;
	}
	
	pos = zm_utility::groundpos( self.origin ) + ( 0, 0, 8 );
	if(IsDefined(pos))
	{
		self.origin = pos;
	}	

	targets = GetEntArray( self.target, "targetname" ); // Grab all the pieces that are targeted by the exterior_goal

	self.barrier_chunks = []; // self has a newly defined array of barrier_chunks

	for( j = 0; j < targets.size; j++ ) // count total targets of exterior_goal
	{
		if(targets[j] IsZBarrier())
		{
			if( IsDefined( level.zbarrier_override ) )
			{
				self thread [[level.zbarrier_override]]( targets[j] );
				continue;
			}
			
			self.zbarrier = targets[j];
			
			self.zbarrier.chunk_health = [];
			
			for( i = 0; i < self.zbarrier GetNumZBarrierPieces(); i ++)
			{
				self.zbarrier.chunk_health[i] = 0;
			}
			
			continue;
		}
		
		// jl/ jan/15/10 add new setup for grates	
		// I hide all the pieces you don't need to see right now.
		// This works
		// Now when they get pulled off, I just want them to swap out the model		
		
		if( IsDefined( targets[j].script_string ) && targets[j].script_string == "rock" )
		{
		    targets[j].material = "rock";
		}
		
		if( IsDefined( targets[j].script_parameters ) ) // If a script noteworthy is defined
		{
			if( targets[j].script_parameters == "grate" )
			{
				if( IsDefined( targets[j].script_noteworthy ) ) // If a script noteworthy is defined
				{
					if( targets[j].script_noteworthy == "2" || targets[j].script_noteworthy == "3" || targets[j].script_noteworthy == "4" ||
					 targets[j].script_noteworthy == "5" || targets[j].script_noteworthy == "6")
					{
						// this is an improper setup because each piece is still sitting there
						targets[j] Hide(); // this grabs all the pieces and hides it
						/#
						IPrintLnBold(" Hide ");
						#/
					}
				}
			}
			//DCS: new pentagon system where barricade starts as new and is repaired with boards, etc.
			// start with repair boards hidden.
			else if( targets[j].script_parameters == "repair_board" )
			{
				targets[j].unbroken_section = GetEnt(targets[j].target,"targetname");
				if(IsDefined(targets[j].unbroken_section))
				{
					targets[j].unbroken_section LinkTo(targets[j]);
					targets[j] Hide();
					targets[j] notSolid();
					targets[j].unbroken = true;
					
					// self is the goal (level.exterior_goals)
					if(IsDefined(targets[j].unbroken_section.script_noteworthy) && targets[j].unbroken_section.script_noteworthy == "glass")
					{
						targets[j].material = "glass";
						targets[j] thread destructible_glass_barricade(targets[j].unbroken_section, self);
					}
					else if(IsDefined(targets[j].unbroken_section.script_noteworthy) && targets[j].unbroken_section.script_noteworthy == "metal")
					{
						targets[j].material = "metal";
					}
				}	
			}
			else if( targets[j].script_parameters == "barricade_vents" )
			{
				targets[j].material = "metal_vent";
			}					
		}
			
		if( IsDefined ( targets[j].targetname ) )
		{
			if( targets[j].targetname == "auto2" )
			{
				//	 targets[j]
			}
		}

		targets[j] update_states("repaired"); // Change state to repaired
		targets[j].destroyed = false;
		targets[j] show();
		targets[j].claimed = false;
		targets[j].anim_grate_index = 0; // check this index to know where each piece is
		// I can create another thing to track here if I need to
		targets[j].og_origin = targets[j].origin; // This one piece's origin is defined by grabbing the starting origin 
		targets[j].og_angles = targets[j].angles; // The one piece's angles is defined by grabbing the starting angles 
		self.barrier_chunks[self.barrier_chunks.size] = targets[j]; // barrier_chunks is the total size of the bars windows or boards used 

	}
	
	target_nodes = GetNodeArray(self.target, "targetname" );
	
	for( j = 0; j < target_nodes.size; j++ ) // count total targets of exterior_goal
	{
		if(target_nodes[j].type == "Begin")
		{
			self.neg_start = target_nodes[j];
			
			if(isdefined(self.neg_start.target))
			{
				self.neg_end = getnode(self.neg_start.target, "targetname");
			}
			
			blocker_disconnect_paths(self.neg_start, self.neg_end);
		}		
	}
	
	if(isdefined(self.zbarrier))
	{
		if(isdefined(self.barrier_chunks))
		{
			for(i = 0; i < self.barrier_chunks.size; i ++)
			{
				self.barrier_chunks[i] delete();
			}
			
			self.barrier_chunks = [];
		}
	}

	if( isDefined(self.zbarrier) &&  should_delete_zbarriers() )
	{
		self.zbarrier delete();
		self.zbarrier = undefined;
		return;
	}

	self blocker_attack_spots(); // exterior_goal thread 
	
	//assert( IsDefined( self.clip ) );
	self.trigger_location = struct::get( self.target, "targetname" ); // trigger_location is the new name for exterior_goal targets -- which is auto1 in all cases

	self thread blocker_think(); // exterior_goal thread blocker_think
}

function should_delete_zbarriers()
{
	gametype = GetDvarString( "ui_gametype" );
	if(!zm_utility::is_Classic() && !zm_utility::is_Standard() && gametype != "zgrief"  )
	{
		return true;
	}
	return false;
}

//-------------------------------------------------------------------------------
// DCS 090710:	glass barricade. Player can damage.
//							self is chunk, aka. repair_board
//-------------------------------------------------------------------------------
function destructible_glass_barricade(unbroken_section, node)
{
	unbroken_section SetCanDamage( true );
	unbroken_section.health = 99999;
	unbroken_section waittill( "damage", amount, who);
	if( zm_utility::is_player_valid( who ) || who laststand::player_is_in_laststand())
	{
		self thread zm_spawner::zombie_boardtear_offset_fx_horizontle( self, node );
		level thread remove_chunk( self, node, true );
		self update_states("destroyed");
		self notify("destroyed");
		self.unbroken = false;
		
	}	
}
//-------------------------------------------------------------------------------

// jl jan/05/10 
// Self = exterior_goal, it is the node that targets all of the boards and bars
// Creates three spots that the AI can now choose from to attack the window
function blocker_attack_spots()
{

	spots = [];
	

	numSlots = self.zbarrier GetZBarrierNumAttackSlots();
	
	numSlots = int(max(numSlots, 1));
	
	if(numSlots % 2)
	{
		spots[spots.size] = zm_utility::groundpos_ignore_water_new( self.zbarrier.origin + ( 0, 0, 60 ) );
	}
	
	if(numSlots > 1)
	{
		reps = floor(numSlots / 2);
		
		slot = 1;
		
		for(i = 0; i < reps; i ++)
		{
			offset = self.zbarrier GetZBarrierAttackSlotHorzOffset() * (i + 1);
			
			spots[spots.size] = zm_utility::groundpos_ignore_water_new( spots[0] + ( AnglesToRight( self.angles ) * offset ) + ( 0, 0, 60 ) );
			
			slot ++;
			
			if(slot < numSlots)
			{
				spots[spots.size] = zm_utility::groundpos_ignore_water_new( spots[0] + ( AnglesToRight( self.angles ) * -offset ) + ( 0, 0, 60 ) );
				
				slot ++;
			}
		}
	}
	
	taken = []; // new array
	for( i = 0; i < spots.size; i++ ) // cycle through all spots and define as not taken
	{
		taken[i] = false;
	}

	self.attack_spots_taken = taken; // set attack_spots_taken to taken
	self.attack_spots = spots; // set attack_spots to spots

/#
		self thread zm_utility::debug_attack_spots_taken(); // self = exterior_goal
#/
}


function blocker_choke()
{
	level._blocker_choke = 0;
	level endon("stop_blocker_think");
	while(1)
	{
		{wait(.05);};
		level._blocker_choke = 0;
	}
}


// jl jan/05/10 
// Self = exterior_goal, it is the node that targets all of the boards and bars
function blocker_think()
{
	level endon("stop_blocker_think");
	if(!IsDefined(level._blocker_choke))
	{
		level thread blocker_choke();
	}

	use_choke = false;
	
	if(IsDefined(level._use_choke_blockers) && level._use_choke_blockers == 1)
	{
		use_choke = true;
	}
	
	while( 1 ) // exterior_goal is going to constantly loop
	{
		wait( 0.5 ); 

		if(use_choke)
		{
			if(level._blocker_choke > 3)
			{
				{wait(.05);};
			}
		}
		
		level._blocker_choke ++;

		if( zm_utility::all_chunks_intact( self, self.barrier_chunks ) ) // speak to zm_utility and into all_chunks_intact function 
		{
			// if any piece has the state of not repaired then return false
			// if the board has been repaired then return true 
			continue;  
		}

		if( zm_utility::no_valid_repairable_boards( self, self.barrier_chunks ) )// speak to zm_utility and into no_valid_repairable_boards function
		{
			// if any piece has been destroyed return false
			// if any piece is not destroyed then return true
			continue;
		}

		self blocker_trigger_think(); 
	}
}

function player_fails_blocker_repair_trigger_preamble(player, players, trigger, hold_required)
{
	
	if( !isdefined(trigger))
	{
		return true;
	}
	
//	if( !player IsTouching( trigger ) )
//	{
//			return true;
//	}

	if( !zm_utility::is_player_valid( player ) )
	{
		return true; 
	}

	if( players.size == 1 && IsDefined( players[0].intermission ) && players[0].intermission == 1)
	{
		return true;
	}
	
	//if( player zm_equipment::hacker_active() )
	//{
	//	return true;
	//}
	
	if( hold_required && !player UseButtonPressed() )
	{
		return true; 
	}

	if( !hold_required && !player util::use_button_held() )
	{
		return true; 
	}	
	
	if( player zm_utility::in_revive_trigger() )
	{
		return true;
	}

	if( ( player.is_drinking > 0 ) )
	{
		return true;
	}
	
	return false;
}

function has_blocker_affecting_perk()
{
	has_perk = undefined;
	
	if( self hasperk( "specialty_fastreload" ) )
	{
		has_perk = "specialty_fastreload";
	}

	return has_perk;
}

function do_post_chunk_repair_delay(has_perk)
{
	if( !self util::script_delay() )
	{
		wait( 1 ); 
	}	
}

function handle_post_board_repair_rewards( cost, zbarrier )
{
	self zm_stats::increment_client_stat( "boards" );
	self zm_stats::increment_player_stat( "boards" );		
	
	// 5% chance every 5 boards, with a 60 sec minimum time between repeats
	if( isDefined(self.pers["boards"] ) && self.pers["boards"] %10 == 0 )
	{
		self zm_audio::create_and_play_dialog( "general", "rebuild_boards" );
	}

	// Update the persistent boarding stats
	self zm_pers_upgrades_functions::pers_boards_updated( zbarrier );

	// set the score
	self.rebuild_barrier_reward += cost;
	if( self.rebuild_barrier_reward < level.zombie_vars["rebuild_barrier_cap_per_round"] )
	{
		self zm_score::player_add_points( "rebuild_board", cost );
		self zm_utility::play_sound_on_ent( "purchase" );
		
	}
	// general contractor achievement for dlc 2. keep track of how many board player repaired.
	if(IsDefined(self.board_repair))
	{
		self.board_repair += 1;
	}
}

function blocker_unitrigger_think()
{
	self endon("kill_trigger");

	while ( 1 )
	{
		self waittill( "trigger", player );
		self.stub.trigger_target notify("trigger", player);
	}
}

// Self = exterior_goal, it is the node that targets all of the boards and bars
// trigger_location 
// this function repairs the boards
function blocker_trigger_think()
{
	self endon( "blocker_hacked" );
	
	if(( isdefined( level.no_board_repair ) && level.no_board_repair )) // don't create the repair trigger if this is true
	{
		return;
	}
	
/#	println( "ZM >> TRIGGER blocker_trigger_think " );	#/
	level endon("stop_blocker_think");

	// They don't cost, they now award the player the cost...
	cost = 10;
	if( IsDefined( self.zombie_cost ) )
	{
		cost = self.zombie_cost; 
	}

	original_cost = cost;
	
	
	/*trigger = Spawn( "trigger_radius", trigger_pos, 0, radius, height ); // spawn in a trigger at the location of the exterior_goal
	trigger TriggerIgnoreTeam();*/
	
	if(!isdefined(self.unitrigger_stub))
	{
		radius = 94.21; 
		height = 94.21; 


		if( IsDefined( self.trigger_location ) ) // this is defined in the blocker_init function
		{
			trigger_location = self.trigger_location; // trigger_location is the new name for exterior_goal targets -- which is auto1 in all cases
		}
		else
		{
			trigger_location = self; // if it is not defined then just use self as the trigger_location
		}
	
		if( IsDefined( trigger_location.radius ) ) // he is asking if it is defined here, yet he never defines it anywhere
		{
			radius = trigger_location.radius; 
		}
	
		if( IsDefined( trigger_location.height ) ) // he is asking if it is defined here, yet he never defines it anywhere
		{
			height = trigger_location.height; 
		}

		trigger_pos = zm_utility::groundpos( trigger_location.origin ) + ( 0, 0, 4 ); // this is from trigger_location and is reset to trigger_pos

		
		self.unitrigger_stub = spawnstruct();
		self.unitrigger_stub.origin = trigger_pos;
		self.unitrigger_stub.radius = radius;
		self.unitrigger_stub.height = height;
		self.unitrigger_stub.script_unitrigger_type = "unitrigger_radius";
		self.unitrigger_stub.hint_string = zm_utility::get_hint_string( self, "default_reward_barrier_piece" ); // this is the string to call when the player is the trigger
		self.unitrigger_stub.cursor_hint = "HINT_NOICON";
		self.unitrigger_stub.trigger_target = self;
		
		zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &blocker_unitrigger_think);	// Register to grab the zone we're in.
		zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);	// Unregister straight away.
		
		if(!isdefined(trigger_location.angles))
		{
			trigger_location.angles = (0,0,0);
		}
		
		self.unitrigger_stub.origin = zm_utility::groundpos( trigger_location.origin ) + ( 0, 0, 4 ) + (anglestoforward(trigger_location.angles) * - 11);	// Move backwards for T5 parity.
	}
	
	
	self thread trigger_delete_on_repair(); // This function waits till the boards/bars are repaired 
	thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &blocker_unitrigger_think);
	
/*	if(IsDefined(level._zombiemode_blocker_trigger_extra_thread))
	{
		trigger thread [[level._zombiemode_blocker_trigger_extra_thread]]();
	}*/
	/#
		if( GetDvarInt( "zombie_debug" ) > 0 ) // 
		{
			thread zm_utility::debug_blocker( trigger_pos, radius, height ); 
		}
	#/

	// Rebuilding no longer costs us money... It's rewarded
	
	//////////////////////////////////////////
	//designed by prod; NO reward hint (See DT#36173)
	// trigger zm_utility::set_hint_string( self, "default_reward_barrier_piece" ); // this is the string to call when the player is the trigger
	//trigger thread blocker_doubler_hint( "default_reward_barrier_piece_", original_cost );
	//////////////////////////////////////////
	
//	trigger SetCursorHint( "HINT_NOICON" ); 
	
	//***************************************************************************
	// The trigger constantly loops while the player interacts with it.
	//  - The player is in position to board a window
	//***************************************************************************

	while( 1 ) 
	{
		self waittill( "trigger", player ); 
				
		has_perk = player has_blocker_affecting_perk(); 
				
		if( zm_utility::all_chunks_intact( self, self.barrier_chunks ) ) // barrier chunks are all the pieces targeted from the exterior_goal
		{
			// if any piece has the state of not repaired then return false
			// if the board has been repaired then return true 
			self notify("all_boards_repaired");
			return;
		}

		if( zm_utility::no_valid_repairable_boards( self, self.barrier_chunks ) ) // barrier chunks are all the pieces targeted from the exterior_goal
		{
			// if any piece has been destroyed return false
			// if any piece is not destroyed then return true
			self notify("no valid boards");
			return;
		}
		
		if( isdefined( level._zm_blocker_trigger_think_return_override ) )
		{
			if( self [[ level._zm_blocker_trigger_think_return_override ]]( player ) )
			{
				return;	
			}
		}
	
		while( 1 )
		{
			players = GetPlayers();

			// Checks for the player to press the repair button
			if(player_fails_blocker_repair_trigger_preamble(player, players, self.unitrigger_stub.trigger, false))
			{
				break;
			}
			
			if(isdefined(self.zbarrier))
			{
				chunk = zm_utility::get_random_destroyed_chunk(self, self.barrier_chunks);
				
				// sound played in handle_post_board_repair_rewards(cost,zbarrier)
				//playsoundatposition ("zmb_cha_ching", self.origin);
				
				self thread replace_chunk( self, chunk, has_perk, ( isdefined( player.pers_upgrades_awarded["board"] ) && player.pers_upgrades_awarded["board"] ) ); // writing out
			}
			else
			{
				chunk = zm_utility::get_random_destroyed_chunk( self, self.barrier_chunks ); // calls get_random_destroyed_chunk in zm_utility, continue if the chunk was destroyed
	
				if(IsDefined(chunk.script_parameter) && chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents")
				{
					if(IsDefined(chunk.unbroken_section))
					{
						chunk Show();
						chunk Solid();
						chunk.unbroken_section zm_utility::self_delete();
					}	
				}
				else
				{	
					chunk Show(); 			
				}
	
				if ( !isDefined( chunk.script_parameters ) || chunk.script_parameters == "board" || chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents")
				{
					//sounds now played on client
					if(!( isdefined( level.use_clientside_board_fx ) && level.use_clientside_board_fx ))
					{
	
						if( !IsDefined( chunk.material ) || ( IsDefined( chunk.material ) && chunk.material != "rock" ) )
						{
							chunk zm_utility::play_sound_on_ent( "rebuild_barrier_piece" );
						}
						playsoundatposition ("zmb_cha_ching", (0,0,0));
					}
				}
				if ( chunk.script_parameters == "bar" )
				{
					chunk zm_utility::play_sound_on_ent( "rebuild_barrier_piece" );
					playsoundatposition ("zmb_cha_ching", (0,0,0));
				}
	
				// I need to do this in a different place	
				if(isdefined(chunk.script_parameters))
				{
					if( chunk.script_parameters == "bar"  )
					{	
						if(isdefined(chunk.script_noteworthy))
						{
							if(chunk.script_noteworthy == "5") // this is the far left , this bar now bends it does not leave
							{
								chunk hide();
							}
							else if(chunk.script_noteworthy == "3" ) 
							{
								chunk hide();
							}
						}
					}
				}
			
				self thread replace_chunk( self, chunk, has_perk, ( isdefined( player.pers_upgrades_awarded["board"] ) && player.pers_upgrades_awarded["board"] ) ); // writing out
			}

			//assert( IsDefined( self.clip ) );
			if(IsDefined(self.clip))
			{
				self.clip TriggerEnable( true ); 
				self.clip DisconnectPaths(); // the boards disconnect paths everytime they are used here
			}
			else
			{
				blocker_disconnect_paths(self.neg_start, self.neg_end);
			}
			
			//maps\_zombiemode_challenges::doMissionCallback( "zm_board_repair", player );	

			self do_post_chunk_repair_delay(has_perk);

			if( !zm_utility::is_player_valid( player ) )
			{
				break;
			}

			player handle_post_board_repair_rewards(cost,self);

			if( zm_utility::all_chunks_intact( self, self.barrier_chunks ) ) // This calls into zm_utility
			{
				// if any piece has the state of not repaired then return false
				// if the board has been repaired then return true 
				self notify("all_boards_repaired");
				return;
			}

			if( zm_utility::no_valid_repairable_boards( self, self.barrier_chunks ) ) // This calls into zm_utility
			{
				// if any piece has been destroyed return false
				// if any piece is not destroyed then return true
				self notify("no valid boards");
				return;
			}
			
		}
	}
}


//*****************************************************************************
//*****************************************************************************

function random_destroyed_chunk_show( )
{
	wait( 0.5 );
	self Show(); 
}


// jl this calls a rumble and zombie scream on the players if they are next to a door being opened.
// call a distance check of the the last chunk replaced
function door_repaired_rumble_n_sound()
{
	players = GetPlayers();
	//players[0] PlayRumbleOnEntity("damage_heavy");
	// only do this if they are close enough
	// add distnace check

	for(i = 0; i < players.size; i++)
	{
		
		if (distance (players[i].origin, self.origin) < 150)
		{
		
			if(isalive(players[i]))
				//-- not usedif(isalive(players[i]) && (isdefined(players[i].pers["team"])) && (players[i].pers["team"] == team)) 
			{
				
			players[i] thread board_completion();
					
			}
		}
	}
}

function board_completion()
{
	self endon ("disconnect");
	
		// need to be place a delay if done within a certain time frame
		//wait(1.2);
		//self zm_utility::play_sound_on_ent( "purchase" );
		//players[i] iprintlnbold("Entrance 1 is fixed!!!");
		//wait(0.3);
		//self zm_utility::play_sound_on_ent( "purchase" );
		//wait(0.3);
		//self zm_utility::play_sound_on_ent( "purchase" );
}


// self is a trigger that is spawned off of the exterior_goal entity.
function trigger_delete_on_repair()
{
	while( 1 )
	{
		self util::waittill_either("all_boards_repaired", "no valid boards");
//		self thread door_repaired_rumble_n_sound(); // jl added cool repair sound
		//self delete(); // when the boards are totally repaired then delete your self
		zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
		break;
	}

}

/*
function blocker_doubler_hint( hint, original_cost )
{
	self endon( "death" );

	doubler_status = level.zombie_vars["zombie_powerup_double_points_on"];
	while( 1 )
	{
		wait( 0.5 );

		if( doubler_status != level.zombie_vars["zombie_powerup_double_points_on"] )
		{
			doubler_status = level.zombie_vars["zombie_powerup_double_points_on"];
			cost = original_cost;
			if( level.zombie_vars["zombie_powerup_double_points_on"] )
			{
				cost = original_cost * 2;
			}
			self zm_utility::set_hint_string( self, hint + cost );
		}
	}
}
*/

function rebuild_barrier_reward_reset()
{
	self.rebuild_barrier_reward = 0;
}

function remove_chunk( chunk, node, destroy_immediately, zomb )
{
	chunk update_states("mid_tear");
	
	// jl dec 15 09
	// jl added check for differnt types of windows
	if(IsDefined(chunk.script_parameters))
	{
		if( chunk.script_parameters == "board" || chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents") // jl this is new check to see if it is a board then do board anims, this needs to hold the entire function
		{
			chunk thread zombie_boardtear_audio_offset(chunk);
		}
	}
	
	if(IsDefined(chunk.script_parameters))
	{
		if( chunk.script_parameters == "bar" ) // jl this is new check to see if it is a board then do board anims, this needs to hold the entire function
		{
			chunk thread zombie_bartear_audio_offset(chunk);
		}
	}
	
	
	chunk NotSolid();
	// here I do a check for if it is a bar 
	
	//if ( isdefined( destroy_immediately ) && destroy_immediately)
	//{
	//	chunk.destroyed = true;
	//}
		
	fx = "wood_chunk_destory";
	if( IsDefined( self.script_fxid ) )
	{
		fx = self.script_fxid;
	}
	
	

		if ( IsDefined( chunk.script_moveoverride ) && chunk.script_moveoverride )
		{
			chunk Hide();
		}	
		
	
		// an origin is created and the current chunk is linked to it. Then it flings the chunk and deletes the origin	
		if ( IsDefined( chunk.script_parameters ) && ( chunk.script_parameters == "bar" ) )
		{
			
			// added top bar check so it goes less higher
			if( IsDefined ( chunk.script_noteworthy ) && ( chunk.script_noteworthy == "4" ) )
			{
				ent = Spawn( "script_origin", chunk.origin ); 
				ent.angles = node.angles +( 0, 180, 0 );
				
				//DCS 030711: adding potential for having max distance movement 
				//for boards in closets that aren't very deep.
				dist = 100; // base number.
				if(IsDefined(chunk.script_move_dist))
				{
						dist_max = chunk.script_move_dist - 100;
						dist = 100 + RandomInt(dist_max);
				}
				else
				{	
					dist = 100 + RandomInt( 100 );
				}
			
				dest = ent.origin + ( AnglesToForward( ent.angles ) * dist );
				trace = BulletTrace( dest + ( 0, 0, 16 ), dest + ( 0, 0, -200 ), false, undefined );
		
				if( trace["fraction"] == 1 )
				{
					dest = dest + ( 0, 0, -200 );
				}
				else
				{
					dest = trace["position"];
				}
			
		//		time = 1; 
				chunk LinkTo( ent ); 
		
				//time = ent zm_utility::fake_physicslaunch( dest, 200 + RandomInt( 100 ) );
				time = ent zm_utility::fake_physicslaunch( dest, 300 + RandomInt( 100 ) );

		
				if( RandomInt( 100 ) > 40 )
				{
					ent RotatePitch( 180, time * 0.5 );
				}
				else
				{
					ent RotatePitch( 90, time, time * 0.5 ); 
				}
				wait( time );
		
				chunk Hide();
			
				// try sending the notify now...
				wait( 0.1);
				//wait( 1 ); // the notify is sent out late... so I can't call it right away... 
				// I need to keep track of what the last peice is...
				ent Delete(); 
			}
			
			else
			{
				ent = Spawn( "script_origin", chunk.origin ); 
				ent.angles = node.angles +( 0, 180, 0 );


				//DCS 030711: adding potential for having max distance movement 
				//for boards in closets that aren't very deep.
				dist = 100; // base number.
				if(IsDefined(chunk.script_move_dist))
				{
						dist_max = chunk.script_move_dist - 100;
						dist = 100 + RandomInt(dist_max);
				}
				else
				{	
					dist = 100 + RandomInt( 100 );
				}

				dest = ent.origin + ( AnglesToForward( ent.angles ) * dist );
				trace = BulletTrace( dest + ( 0, 0, 16 ), dest + ( 0, 0, -200 ), false, undefined );
		
				if( trace["fraction"] == 1 )
				{
					dest = dest + ( 0, 0, -200 );
				}
				else
				{
					dest = trace["position"];
				}
			
		//		time = 1; 
				chunk LinkTo( ent ); 
		
				time = ent zm_utility::fake_physicslaunch( dest, 260 + RandomInt( 100 ) );
				
				// here you will do a random damage... however it would be better if you made them fall over
				// call damage function out of here so the wait doesn't interrupt normal flow.
				
				
				//time = ent zm_utility::fake_physicslaunch( dest, 200 + RandomInt( 100 ) );
		
				//forward = AnglesToForward( ent.angles + ( -60, 0, 0 ) ) * power ); 
				//ent MoveGravity( forward, time ); 
		
				if( RandomInt( 100 ) > 40 )
				{
					ent RotatePitch( 180, time * 0.5 );
				}
				else
				{
					ent RotatePitch( 90, time, time * 0.5 ); 
				}
				wait( time );
		
				chunk Hide();
			
				// try sending the notify now...
				wait( 0.1);
				//wait( 1 ); // the notify is sent out late... so I can't call it right away... 
				// I need to keep track of what the last peice is...
				ent Delete();
				
			}
			//if (isdefined( destroy_immediately ) && destroy_immediately)
			//{
			//	return;
			//}
			chunk update_states("destroyed");
			chunk notify( "destroyed" );			
		}

	if ( IsDefined ( chunk.script_parameters ) && chunk.script_parameters == "board" || chunk.script_parameters == "repair_board" || chunk.script_parameters == "barricade_vents" ) 
	{
		
			ent = Spawn( "script_origin", chunk.origin ); 
			ent.angles = node.angles +( 0, 180, 0 );
			
			//DCS 030711: adding potential for having max distance movement 
			//for boards in closets that aren't very deep.
				dist = 100; // base number.
				if(IsDefined(chunk.script_move_dist))
				{
						dist_max = chunk.script_move_dist - 100;
						dist = 100 + RandomInt(dist_max);
				}
				else
				{	
					dist = 100 + RandomInt( 100 );
				}
				
			dest = ent.origin + ( AnglesToForward( ent.angles ) * dist );
			trace = BulletTrace( dest + ( 0, 0, 16 ), dest + ( 0, 0, -200 ), false, undefined );
	
			if( trace["fraction"] == 1 )
			{
				dest = dest + ( 0, 0, -200 );
			}
			else
			{
				dest = trace["position"];
			}
		
	//		time = 1; 
			chunk LinkTo( ent ); 
	
			time = ent zm_utility::fake_physicslaunch( dest, 200 + RandomInt( 100 ) );
			//time = ent zm_utility::fake_physicslaunch( dest, 200 + RandomInt( 100 ) );
	
	//		forward = AnglesToForward( ent.angles + ( -60, 0, 0 ) ) * power ); 
	//		ent MoveGravity( forward, time ); 

			// DCS 090110: delete glass or wall piece before sending flying.
			//DCS 090910: but not metal.
			if(IsDefined(chunk.unbroken_section))
			{
				if(!IsDefined(chunk.material) || chunk.material != "metal")
				{
					chunk.unbroken_section zm_utility::self_delete();
				}	
			}
	
			if( RandomInt( 100 ) > 40 )
			{
				ent RotatePitch( 180, time * 0.5 );
			}
			else
			{
				ent RotatePitch( 90, time, time * 0.5 ); 
			}
			wait( time );

			// DCS 090910: let the metal vents go fly.
			if(IsDefined(chunk.unbroken_section))
			{
				if(IsDefined(chunk.material) && chunk.material == "metal")
				{
					chunk.unbroken_section zm_utility::self_delete();
				}	
			}

			chunk Hide();
						
			// try sending the notify now...
			wait( 0.1);
			//wait( 1 ); // the notify is sent out late... so I can't call it right away... 
			// I need to keep track of what the last peice is...
			ent Delete(); 
		
	
			//if (isdefined( destroy_immediately ) && destroy_immediately)
			//{
			//	return;
			//}
		
			chunk update_states("destroyed");
			chunk notify( "destroyed" );
		}

	
	if ( IsDefined ( chunk.script_parameters ) && ( chunk.script_parameters == "grate" ) )
	{
		// Only make the last piece of the grate get pulled off.
		if( IsDefined ( chunk.script_noteworthy ) && ( chunk.script_noteworthy == "6" ) )
		{
	//		angles = node.angles +( 0, 180, 0 );
	//		force = AnglesToForward( angles + ( -60, 0, 0 ) ) * ( 200 + RandomInt( 100 ) ); 
	//		chunk PhysicsLaunch( chunk.origin, force );
		
			ent = Spawn( "script_origin", chunk.origin ); 
			ent.angles = node.angles +( 0, 180, 0 );
			dist = 100 + RandomInt( 100 );
			dest = ent.origin + ( AnglesToForward( ent.angles ) * dist );
			trace = BulletTrace( dest + ( 0, 0, 16 ), dest + ( 0, 0, -200 ), false, undefined );
	
			if( trace["fraction"] == 1 )
			{
				dest = dest + ( 0, 0, -200 );
			}
			else
			{
				dest = trace["position"];
			}
		
	//		time = 1; 
			chunk LinkTo( ent ); 
	
			time = ent zm_utility::fake_physicslaunch( dest, 200 + RandomInt( 100 ) );
			//time = ent zm_utility::fake_physicslaunch( dest, 200 + RandomInt( 100 ) );
	
	//		forward = AnglesToForward( ent.angles + ( -60, 0, 0 ) ) * power ); 
	//		ent MoveGravity( forward, time ); 
	
			if( RandomInt( 100 ) > 40 )
			{
				ent RotatePitch( 180, time * 0.5 );
			}
			else
			{
				ent RotatePitch( 90, time, time * 0.5 ); 
			}
			wait( time );
			chunk Hide();
			//wait( 1 ); // the notify is sent out late... so I can't call it right away... 
			// I need to keep track of what the last peice is...
			ent Delete(); 
			chunk update_states("destroyed");
			chunk notify( "destroyed" );
		}
		
		else
		{
			chunk Hide();
			//chunk moveto( chunk.origin + ( 0, 0, -1000 ), 0.3, 0.1, 0.1 );
			chunk update_states("destroyed");
			chunk notify( "destroyed" );
		}
			//chunk Hide();
	}

	/*
	// this is kicking off but is to late to send the notify
	if( zm_utility::all_chunks_destroyed( node.barrier_chunks ) )
	{
	
		if( IsDefined( node.clip ) )
		{
			node.clip ConnectPaths(); 
			WAIT_SERVER_FRAME; 
			node.clip TriggerEnable( false );
		}
		else
		{
			for( i = 0; i < node.barrier_chunks.size; i++ )
			{
				node.barrier_chunks[i] ConnectPaths(); 
			}
		}
	}
	else
	{
		EarthQuake( RandomFloatRange( 1, 3 ), 0.9, chunk.origin, 500 ); 
	}
	*/
}


// jl dec 15 09
function remove_chunk_rotate_grate( chunk )
{
	// this is going to rotate all of them.. I need to some how do this off of the node pointing to it..
	//chunk_rotate_piece = GetEntArray( "grate", "script_parameters");
	
	//chunk_rotate_piece = GetEnt( "grate", "script_parameters");
	//chunk vibrate(( 0, 270, 0 ), 0.2, 0.4, 0.4);
	
	
	// how do I only effect the one for that window and not affect all of them
	// This is actually checked every time
	
	if( IsDefined (chunk.script_parameters) && chunk.script_parameters == "grate" ) //&& chunk.script_parameters != "grate" )
	{
		chunk vibrate(( 0, 270, 0 ), 0.2, 0.4, 0.4);	
		return;
	}
}

// jl just for now I added an audio offset to give more length and depth to the tearing off feeling
// i should add these to the same area where the fx is called, which is zombie_boardtear_offset_fx_horizontle(chunk) 
// in zombiemode_spawner
function zombie_boardtear_audio_offset(chunk)
{
	if( IsDefined(chunk.material) && !IsDefined( chunk.already_broken ) )
	    chunk.already_broken = false;
	
	if( IsDefined(chunk.material) && chunk.material == "glass" && chunk.already_broken == false )
	{
	    chunk PlaySound( "zmb_break_glass_barrier" );
	    wait( randomfloatrange( 0.3, 0.6 ));
	    chunk PlaySound( "zmb_break_glass_barrier" );
	    chunk.already_broken = true;
	}
	else if( IsDefined(chunk.material) && chunk.material == "metal" && chunk.already_broken == false )
	{
	    chunk PlaySound( "grab_metal_bar" );
	    wait( randomfloatrange( 0.3, 0.6 ));
	    chunk PlaySound( "break_metal_bar" );
	    chunk.already_broken = true;
	}	
	else if( IsDefined(chunk.material) && chunk.material == "rock" )
	{
	    if(!( isdefined( level.use_clientside_rock_tearin_fx ) && level.use_clientside_rock_tearin_fx ))
			{
	    	chunk PlaySound( "zmb_break_rock_barrier" );
	    	wait( randomfloatrange( 0.3, 0.6 ));
	    	chunk PlaySound( "zmb_break_rock_barrier" );
	    }
	    chunk.already_broken = true;
	}
	else if( IsDefined(chunk.material) && chunk.material == "metal_vent")
	{
			if(!( isdefined( level.use_clientside_board_fx ) && level.use_clientside_board_fx ))
			{
	    	//chunk PlaySound( "evt_vent_slat_grab" );
	    	//wait( randomfloatrange( 0.3, 0.6 ));
	    	chunk PlaySound( "evt_vent_slat_remove" );
	  	}
	}		
	else
	{
			if(!( isdefined( level.use_clientside_board_fx ) && level.use_clientside_board_fx ))
			{
	    	chunk zm_utility::play_sound_on_ent( "break_barrier_piece" );
	    	wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...
	    	chunk zm_utility::play_sound_on_ent( "break_barrier_piece" );
	    }
	    chunk.already_broken = true;
	}
}

function zombie_bartear_audio_offset(chunk)
{
	chunk zm_utility::play_sound_on_ent( "grab_metal_bar" );
	//iprintlnbold("RRIIIPPPPP!!!");
	wait( randomfloatrange( 0.3, 0.6 ));
	chunk zm_utility::play_sound_on_ent( "break_metal_bar" );
	wait( randomfloatrange( 1.0, 1.3 ));
	chunk zm_utility::play_sound_on_ent( "drop_metal_bar" );
}

function ensure_chunk_is_back_to_origin( chunk )
{
	if ( chunk.origin != chunk.og_origin )
	{
		chunk notsolid();
		chunk waittill( "movedone" );
	}
}

function replace_chunk( barrier, chunk, perk, upgrade, via_powerup )
{
	if(!isdefined(barrier.zbarrier))
	{
		chunk update_states("mid_repair");
		assert( IsDefined( chunk.og_origin ) );
		assert( IsDefined( chunk.og_angles ) );
		
		sound = "rebuild_barrier_hover";
		if( IsDefined( chunk.script_presound ) )
		{
			sound = chunk.script_presound;
		}		
		
	}
	
	has_perk = false;

	if( isDefined( perk ) )
	{
		has_perk = true;
	}
	

	if( !isdefined( via_powerup  ) && isdefined(sound))
	{
		zm_utility::play_sound_at_pos( sound, chunk.origin );
	}


	if(upgrade)
	{
		barrier.zbarrier ZBarrierPieceUseUpgradedModel(chunk);
		barrier.zbarrier.chunk_health[chunk] = barrier.zbarrier GetUpgradedPieceNumLives(chunk);
	}
	else
	{
		barrier.zbarrier ZBarrierPieceUseDefaultModel(chunk);
		barrier.zbarrier.chunk_health[chunk] = 0;
	}
	
	scalar = 1.0;
	if(has_perk)
	{
		if("specialty_fastreload" == perk)	
		{
			scalar = 0.31;
		}
	}
	
	barrier.zbarrier ShowZBarrierPiece(chunk);
	
	barrier.zbarrier SetZBarrierPieceState(chunk, "closing", scalar);
	waitDuration = barrier.zbarrier GetZBarrierPieceAnimLengthForState(chunk, "closing", scalar);
	wait(waitDuration);

}

function open_all_zbarriers()
{
	foreach ( barrier in level.exterior_goals )
	{
		if ( IsDefined( barrier.zbarrier ) )
		{
			for ( x = 0; x < barrier.zbarrier GetNumZBarrierPieces(); x++ )
			{
				barrier.zbarrier SetZBarrierPieceState( x, "opening" );
			}
		}
		
		if ( IsDefined( barrier.clip ) )
		{
			barrier.clip TriggerEnable( false );
			barrier.clip ConnectPaths();
		}
		else
		{
			blocker_connect_paths( barrier.neg_start, barrier.neg_end );
		}			

	}
}

// Jl we want different audio for each type of board or bar when they are repaired
// Need tags so the off sets for the effects is less code.
function zombie_boardtear_audio_plus_fx_offset_repair_horizontal( chunk )
{
	
	if(isDefined(chunk.material) && chunk.material == "rock" )
	{
		if(( isdefined( level.use_clientside_rock_tearin_fx ) && level.use_clientside_rock_tearin_fx ))
		{
			chunk clientfield::set( "tearin_rock_fx", 0 );//PlayFX( level._effect["wall_break"], chunk.origin );
		}
		else 
		{
			EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), chunk.origin, 150 ); // do I want an increment if more are gone...
//			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (0, 0, 30));
			wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...
			chunk zm_utility::play_sound_on_ent( "break_barrier_piece" );
//			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (0, 0, -30));
		}
	}	
	else 
	{
		if(( isdefined( level.use_clientside_board_fx ) && level.use_clientside_board_fx ))
		{
			chunk clientfield::set( "tearin_board_vertical_fx", 0 );
		}
		else 
		{
			EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), chunk.origin, 150 ); // do I want an increment if more are gone...
//			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (0, 0, 30));
			wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...
			chunk zm_utility::play_sound_on_ent( "break_barrier_piece" );
//			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (0, 0, -30));
		}
	}
	

}

function zombie_boardtear_audio_plus_fx_offset_repair_verticle( chunk )
{
	if(isDefined(chunk.material) && chunk.material == "rock")
	{
		if (( isdefined( level.use_clientside_rock_tearin_fx ) && level.use_clientside_rock_tearin_fx ))
		{
			chunk clientfield::set( "tearin_rock_fx", 0 );//PlayFX( level._effect["wall_break"], chunk.origin );
		}
		else
		{

			EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), chunk.origin, 150 ); // do I want an increment if more are gone...
//			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (30, 0, 0));
			wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...
			chunk zm_utility::play_sound_on_ent( "break_barrier_piece" );
//			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (-30, 0, 0));
		}
	}
	else
	{
		if(( isdefined( level.use_clientside_board_fx ) && level.use_clientside_board_fx ))
		{
			chunk clientfield::set( "tearin_board_horizontal_fx", 0 );
		}
		else
		{
			EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), chunk.origin, 150 ); // do I want an increment if more are gone...
//			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (30, 0, 0));
			wait( randomfloatrange( 0.3, 0.6 )); // 06 might be too much, a little seperation sounds great...
			chunk zm_utility::play_sound_on_ent( "break_barrier_piece" );
//			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (-30, 0, 0));
		}
	}

	
}


function zombie_gratetear_audio_plus_fx_offset_repair_horizontal( chunk )
{
	EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), chunk.origin, 150 ); // do I want an increment if more are gone...
	chunk zm_utility::play_sound_on_ent( "bar_rebuild_slam" );
	
		switch( randomInt( 9 ) ) // This sets up random versions of the bars being pulled apart for variety
		{
			case 0:
							PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin + (-30, 0, 0) );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFX( level._effect["fx_zombie_bar_break_lite"], chunk.origin + (-30, 0, 0) );
				break;
				
			case 1:
							PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin + (-30, 0, 0) );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin + (-30, 0, 0) );

				break;
				
			case 2:
							PlayFX( level._effect["fx_zombie_bar_break_lite"], chunk.origin + (-30, 0, 0) );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin + (-30, 0, 0) );
			
				break;
				
			case 3:
							PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin + (-30, 0, 0) );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFX( level._effect["fx_zombie_bar_break_lite"], chunk.origin + (-30, 0, 0) );
			
				break;
				
			case 4:
							PlayFX( level._effect["fx_zombie_bar_break_lite"], chunk.origin + (-30, 0, 0) );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFX( level._effect["fx_zombie_bar_break_lite"], chunk.origin + (-30, 0, 0) );
				break;
				
			case 5:
							PlayFX( level._effect["fx_zombie_bar_break_lite"], chunk.origin + (-30, 0, 0) );
				break;
			case 6:
							PlayFX( level._effect["fx_zombie_bar_break_lite"], chunk.origin + (-30, 0, 0) );
				break;
			case 7:
							PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin + (-30, 0, 0) );
				break;
			case 8:
							PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin + (-30, 0, 0) );
				break;
		} 
	
}


function zombie_bartear_audio_plus_fx_offset_repair_horizontal( chunk )
{
	
	EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), chunk.origin, 150 ); // do I want an increment if more are gone...
	chunk zm_utility::play_sound_on_ent( "bar_rebuild_slam" );

	
		switch( randomInt( 9 ) ) // This sets up random versions of the bars being pulled apart for variety
		{			
			case 0:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
				break;
				
			case 1:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right" );
				break;
				
			case 2:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right" );
				break;
				
			case 3:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
				break;
				
			case 4:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
				break;
				
			case 5:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
				break;
			case 6:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
				break;
			case 7:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left" );
				break;
			case 8:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right" );
				break;
		} 
	
}

function zombie_bartear_audio_plus_fx_offset_repair_verticle(chunk)
{
	EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), chunk.origin, 150 ); // do I want an increment if more are gone...
	chunk zm_utility::play_sound_on_ent( "bar_rebuild_slam" );
	
	
		switch( randomInt( 9 ) ) // This sets up random versions of the bars being pulled apart for variety
		{
			case 0:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;
				
			case 1:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom" );
				break;
				
			case 2:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom" );
				break;
				
			case 3:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;
				
			case 4:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;
				
			case 5:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
				break;
			case 6:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;
			case 7:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top" );
				break;
			case 8:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom" );
				break;
		} 
}

function add_new_zombie_spawners()
{
	if( isdefined( self.target ) )
	{
		self.possible_spawners = getentarray( self.target, "targetname" ); 
	}	

	if( isdefined( self.script_string ) )
	{
		spawners = getentarray( self.script_string, "targetname" ); 
		self.possible_spawners = ArrayCombine( self.possible_spawners, spawners, true, false );
	}	
	
	if( !isdefined( self.possible_spawners ) )
	{
		return; 
	}
	
	// add new check if they've been added already
	zombies_to_add = self.possible_spawners; 

	for( i = 0; i < self.possible_spawners.size; i++ )
	{
		self.possible_spawners[i].is_enabled = true;
		zm_utility::add_spawner( self.possible_spawners[i] );
	}
}

//
// Flag Blocker ----------------------------------------------------------------------------------- //
//

function flag_blocker()
{
	if( !IsDefined( self.script_flag_wait ) )
	{
		AssertMsg( "Flag Blocker at " + self.origin + " does not have a script_flag_wait key value pair" );
		return;
	}

	if( !IsDefined( level.flag[self.script_flag_wait] ) )
	{
		level flag::init( self.script_flag_wait ); 
	}

	type = "connectpaths";
	if( IsDefined( self.script_noteworthy ) )
	{
		type = self.script_noteworthy;
	}

	level flag::wait_till( self.script_flag_wait );

	self util::script_delay();

	if( type == "connectpaths" )
	{
		self ConnectPaths();
		//FOCKER
		//iprintlnbold("BOARDS AREE ALL DOWN!!!");
		self TriggerEnable( false );
		return;
	}

	if( type == "disconnectpaths" )
	{
		self DisconnectPaths();
		//iprintlnbold("BOARDS ARE ALL UP!!!");
		self TriggerEnable( false );
		return;
	}

	AssertMsg( "flag blocker at " + self.origin + ", the type \"" + type + "\" is not recognized" );
}

function update_states( states )
{
	assert( isdefined( states ) );
	
	self.state = states;

}


function quantum_bomb_open_nearest_door_validation( position )
{
	range_squared = 180 * 180; // 15 feet

	zombie_doors = GetEntArray( "zombie_door", "targetname" ); 
	for( i = 0; i < zombie_doors.size; i++ )
	{
		if ( DistanceSquared( zombie_doors[i].origin, position ) < range_squared )
		{
			return true;
		}
	}

	zombie_airlock_doors = GetEntArray( "zombie_airlock_buy", "targetname" ); 
	for( i = 0; i < zombie_airlock_doors.size; i++ )
	{
		if ( DistanceSquared( zombie_airlock_doors[i].origin, position ) < range_squared )
		{
			return true;
		}
	}

	zombie_debris = GetEntArray( "zombie_debris", "targetname" ); 
	for( i = 0; i < zombie_debris.size; i++ )
	{
		if ( DistanceSquared( zombie_debris[i].origin, position ) < range_squared )
		{
			return true;
		}
	}

	return false;
}


function quantum_bomb_open_nearest_door_result( position )
{
	range_squared = 180 * 180; // 15 feet

	zombie_doors = GetEntArray( "zombie_door", "targetname" ); 
	for( i = 0; i < zombie_doors.size; i++ )
	{
		if ( DistanceSquared( zombie_doors[i].origin, position ) < range_squared )
		{
			self thread zm_audio::create_and_play_dialog( "kill", "quant_good" );
			zombie_doors[i] notify( "trigger", self, true );
			[[level.quantum_bomb_play_area_effect_func]]( position );
			return;
		}
	}

	zombie_airlock_doors = GetEntArray( "zombie_airlock_buy", "targetname" ); 
	for( i = 0; i < zombie_airlock_doors.size; i++ )
	{
		if ( DistanceSquared( zombie_airlock_doors[i].origin, position ) < range_squared )
		{
			self thread zm_audio::create_and_play_dialog( "kill", "quant_good" );
			zombie_airlock_doors[i] notify( "trigger", self, true );
			[[level.quantum_bomb_play_area_effect_func]]( position );
			return;
		}
	}

	zombie_debris = GetEntArray( "zombie_debris", "targetname" ); 
	for( i = 0; i < zombie_debris.size; i++ )
	{
		if ( DistanceSquared( zombie_debris[i].origin, position ) < range_squared )
		{
			self thread zm_audio::create_and_play_dialog( "kill", "quant_good" );
			zombie_debris[i] notify( "trigger", self, true );
			[[level.quantum_bomb_play_area_effect_func]]( position );
			return;
		}
	}
}

