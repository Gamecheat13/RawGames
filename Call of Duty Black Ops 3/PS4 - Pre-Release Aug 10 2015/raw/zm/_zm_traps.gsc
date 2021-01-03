#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\zombie_death;

#using scripts\zm\_util;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;

                                                                                       	                                
                                                        
                                                                                                                               

#namespace zm_traps;

#precache( "model", "zombie_zapper_cagelight_red");
#precache( "model", "zombie_zapper_cagelight_green");
#precache( "model", "zombie_zapper_cagelight" );
#precache( "model", "zombie_zapper_handle" );

function autoexec __init__sytem__() {     system::register("zm_traps",&__init__,&__main__,undefined);    }
//TODO T7 - break out trap types into their own files to support p&p

//
//	NOTES:
//		See trap_init for trap trigger setup info.
//		Make sure you precache the trap effects for your level.
//		Also, start a trap monitor thread for each unique trap in your clientscripts
//		(see zombie_cosmodrome for examples)

//*****************************************************************************
//	All traps are trigger_multiples that will be used to determine if the
//		zombie is within the trap zone.
//*****************************************************************************

function __init__()
{
	level.trap_kills = 0;

	level.burning_zombies = [];		//JV max number of zombies that can be on fire
	
	callback::on_finalize_initialization( &init );
}

function init()
{
	traps = GetEntArray( "zombie_trap", "targetname" );
	
	array::thread_all( traps, &trap_init );
	//DCS: needs to be properly setup.
	//level thread register_visionsets( traps );	
}

function __main__()
{
	traps = GetEntArray( "zombie_trap", "targetname" );
	
	array::thread_all( traps, &trap_main );
}

//*****************************************************************************
// This gets information from the trap trigger and then loops through its targets
//	to identify and sets up each component.
//
//	TRAP KVPs:
//	target
//		Trap components including use_triggers, switches and lights
//	script_noteworthy
//		The type of trap it is, such as "fire" or "electric"
//	script_string
//		Two character unique ID (used for clientnotify messages, which should
//			be max 3 characters long.  The first character should not be a number.
//			The extra character will have "1" for on and "0" for off
//		Alternatively, this could be a number which will be used to fire off an exploder.
//	script_flag_wait
//		Set if you want it to wait for a flag like "power_on" before being usable
//*****************************************************************************
function trap_init()
{
	//Setup ent flag
	self flag::init( "flag_active" );
	self flag::init( "flag_cooldown" );

	self._trap_type = "";
	// Figure out what kind of trap we are.
	if ( isdefined(self.script_noteworthy) )
	{
		self._trap_type = self.script_noteworthy;

		// Note make sure you define your own _trap_activate_func!!
		if( isdefined( level._custom_traps ) && isdefined( level._custom_traps[ self.script_noteworthy ] ) && isdefined( level._custom_traps[ self.script_noteworthy ].activate ) )
		{
			self._trap_activate_func = level._custom_traps[ self.script_noteworthy ].activate;
		}
		else
		{
			switch( self.script_noteworthy )
			{
			case "rotating":
				self._trap_activate_func =&trap_activate_rotating;
				break;
			case "flipper":
				self._trap_activate_func =&trap_activate_flipper;
				break;
			case "fire":
			default:
				self._trap_activate_func =&trap_activate_fire;
			}
		}

		// Note make sure you define your own _trap_use_func!!
		if ( isdefined( level._zombiemode_trap_use_funcs ) &&
			 isdefined( level._zombiemode_trap_use_funcs[ self._trap_type ] ) )
		{
			self._trap_use_func = level._zombiemode_trap_use_funcs[ self._trap_type ];
		}
		else
		{
			self._trap_use_func =&trap_use_think;
		}
	}
	
	// WW: adding function to issue which models switch based on trigger script_parameters
	self trap_model_type_init();

	// Okay sort through the targets
	self._trap_use_trigs = [];	// What the player needs to use to activate the trap
	self._trap_lights = [];		// Indicates if the trap is available
	self._trap_movers = [];		// Physical part of the trap that moves
	self._trap_switches = [];	// Move when trap turned on/off

	components = GetEntArray( self.target, "targetname" );
	for ( i=0; i<components.size; i++ )
	{
		if ( isdefined( components[i].script_noteworthy ) )
		{
			switch ( components[i].script_noteworthy )
			{
			case "counter_1s":
				self.counter_1s = components[i];
				continue;

			case "counter_10s":
				self.counter_10s = components[i];
				continue;

			case "counter_100s":
				self.counter_100s = components[i];
				continue;

			case "mover":
				self._trap_movers[ self._trap_movers.size ] = components[i];
				continue;
			case "switch":
				self._trap_switches[ self._trap_switches.size ] = components[i];
				continue;
			case "light":
				self._trap_lights[ self._trap_lights.size ] = components[i];
				continue;
			}
		}
		if( isdefined( components[i].script_string ) ) // If a script noteworthy is defined
		{
			switch ( components[i].script_string )
			{
			case "flipper1":
				self.flipper1 = components[i];
				continue;
			case "flipper2":
				self.flipper2 = components[i];
				continue;
			case "flipper1_radius_check":
				self.flipper1_radius_check = components[i];
				continue;
			case "flipper2_radius_check":
				self.flipper2_radius_check = components[i];
				continue;
			case "target1":
				self.target1 = components[i];
				continue;
			case "target2":
				self.target2 = components[i];
				continue;
			case "target3":
				self.target3 = components[i];
				continue;
			}
		}

		switch ( components[i].classname )
		{
		case "trigger_use":
			self._trap_use_trigs[ self._trap_use_trigs.size ] = components[i];
			break;
		case "script_model":
			if ( components[i].model == self._trap_light_model_off )
			{
				self._trap_lights[ self._trap_lights.size ] = components[i];
			}
			else if ( components[i].model == self._trap_switch_model )  // "zombie_zapper_handle"
			{
				self._trap_switches[ self._trap_switches.size ] = components[i];
			}
		}
	}

//	self.use_this_angle = struct::get ("use_this_angle", "script_string");

	self._trap_fx_structs = [];
	components = struct::get_array( self.target, "targetname" );
	
	for ( i=0; i<components.size; i++ )
	{
		if ( isdefined( components[i].script_string ) && components[i].script_string == "use_this_angle" )
		{
			self.use_this_angle = components[i];
		}
		else
		{
			self._trap_fx_structs[ self._trap_fx_structs.size ] = components[i];
		}
	}

	assert( self._trap_use_trigs.size > 0, "zm_traps::init no use triggers found for "+self.target );

	if ( !isdefined( self.zombie_cost ) )
	{
		self.zombie_cost = 1000;
	}
	self._trap_in_use = 0;
	self._trap_cooling_down = 0;

	self thread trap_dialog();
}

function trap_main()
{
	level flag::wait_till( "start_zombie_round_logic" );

	// Setup Use triggers
	for ( i=0; i<self._trap_use_trigs.size; i++ )
	{
		self._trap_use_trigs[i] SetCursorHint( "HINT_NOICON" );
	}

	// Wait for activation flag if necessary
	if ( !isdefined( self.script_string ) || "disable_wait_for_power" != self.script_string )
	{
		self trap_set_string( &"ZOMBIE_NEED_POWER" );

		if ( IsDefined( self.script_int ) )
		{
			level flag::wait_till( "power_on" + self.script_int );
		}
		else
		{	
			level flag::wait_till( "power_on" );
		}	
	}

	if ( IsDefined( self.script_flag_wait ) )
	{
		self trap_set_string( "" );
		self TriggerEnable( false );
		self trap_lights_red();

		if ( !isdefined( level.flag[ self.script_flag_wait ] ) )
		{
			level flag::init( self.script_flag_wait );
		}
		level flag::wait_till( self.script_flag_wait );

		self TriggerEnable( true );
	}

	// Set buy string
	self trap_set_string( &"ZOMBIE_BUTTON_BUY_TRAP", self.zombie_cost );

	// Open for business!
	self trap_lights_green();

	for ( i=0; i<self._trap_use_trigs.size; i++ )
	{
		self._trap_use_trigs[i] thread [[ self._trap_use_func ]]( self );
	}
}


//*****************************************************************************
//	This controls the electric traps in the level
//		self = use trigger associated with the trap
//		trap = trap trigger entity
//*****************************************************************************
function trap_use_think( trap )
{	
	while(1)
	{
		//wait until someone uses the valve
		self waittill("trigger",who);

		if( who zm_utility::in_revive_trigger() )
		{
			continue;
		}

		if( ( who.is_drinking > 0 ) )
		{
			continue;
		}

		if( zm_utility::is_player_valid( who ) && !trap._trap_in_use )
		{
			// See if they can afford it
			players = GetPlayers();
			//if ( players.size == 1 && who.score >= trap.zombie_cost )
			if (who.score >= trap.zombie_cost )
			{
				// Solo buy
				who zm_score::minus_to_player_score( trap.zombie_cost ); 
			}
			/*
			else if( level.team_pool[who.team_num].score >= trap.zombie_cost )
			{
				// Team buy
				who zm_score::minus_to_team_score( trap.zombie_cost ); 
			}
			else if( level.team_pool[ who.team_num ].score + who.score >= trap.zombie_cost )
			{
				// team funds + player funds
				team_points = level.team_pool[ who.team_num ].score;
				who zm_score::minus_to_player_score( trap.zombie_cost - team_points ); 
				who zm_score::minus_to_team_score( team_points ); 
			}
			*/
			else
			{
				continue;
			}

			trap._trap_in_use = 1;
			trap trap_set_string( &"ZOMBIE_TRAP_ACTIVE" );

			zm_utility::play_sound_at_pos( "purchase", who.origin );

			if ( trap._trap_switches.size )
			{
				trap thread trap_move_switches();
				//need to play a 'woosh' sound here, like a gas furnace starting up
				trap waittill("switch_activated");
			}

			//this trigger detects zombies who need to be smacked
			trap TriggerEnable( true );

			//start the movement
			trap thread [[ trap._trap_activate_func ]]();
			//wait until done and then clean up and cool down
			trap waittill("trap_done");

			//turn the damage detection trigger off until the trap is used again
			trap TriggerEnable( false );

			trap._trap_cooling_down = 1;
			trap trap_set_string( &"ZOMBIE_TRAP_COOLDOWN" );
/#
			if ( GetDvarInt( "zombie_cheat" ) >= 1 )
			{
				trap._trap_cooldown_time = 5;
			}
#/
			wait( trap._trap_cooldown_time );
			trap._trap_cooling_down = 0;

			//COLLIN: Play the 'alarm' sound to alert players that the traps are available again (playing on a temp ent in case the PA is already in use.
			//speakerA = struct::get("loudspeaker", "targetname");
			playsoundatposition("zmb_trap_ready", trap.origin);
			
			if ( isdefined( level.sndTrapFunc ) )
			{
				level thread [[ level.sndTrapFunc ]]( trap, 0 );
			}
			
			trap notify("available");

			trap._trap_in_use = 0;
			trap trap_set_string( &"ZOMBIE_BUTTON_BUY_TRAP", trap.zombie_cost );
		}
	}
}


//*****************************************************************************
//	Swaps the cage light models to the red one.
//	self is a trap damage trigger
//*****************************************************************************
function trap_lights_red()
{
	for(i=0;i<self._trap_lights.size;i++)
	{
		light = self._trap_lights[i];
		light setmodel( self._trap_light_model_red );	

		if(isdefined(light.fx))
		{
			light.fx delete();
		}

		light.fx = zm_net::network_safe_spawn( "trap_lights_red", 2, "script_model", light.origin );
		light.fx setmodel("tag_origin");
		light.fx.angles = light.angles;
		str_light_red = light.targetname + "_red";
		str_light_green = light.targetname + "_green";
		exploder::stop_exploder( str_light_green  );
		exploder::exploder( str_light_red );
	}
}


//*****************************************************************************
//	Swaps the cage light models to the green one.
//	self is a trap damage trigger
//*****************************************************************************
function trap_lights_green()
{
	for(i=0;i<self._trap_lights.size;i++)
	{
		light = self._trap_lights[i];
		if(isdefined(light._switch_disabled))
		{
			continue;
		}
		
		light setmodel( self._trap_light_model_green );	

		if(isdefined(light.fx))
		{
			light.fx delete();
		}

		light.fx = zm_net::network_safe_spawn( "trap_lights_green", 2, "script_model", light.origin );
		light.fx setmodel("tag_origin");
		light.fx.angles = light.angles;
		str_light_red = light.targetname + "_red";
		str_light_green = light.targetname + "_green";
		exploder::stop_exploder( str_light_red  );
		exploder::exploder( str_light_green );
	}
}


//*****************************************************************************
// Set the hintstrings for all associated use triggers
//	self should be the trap entity
//*****************************************************************************
function trap_set_string( string, param1, param2 )
{
	// Set buy string
	for ( i=0; i<self._trap_use_trigs.size; i++ )
	{
		if ( !isdefined(param1) )
		{
			self._trap_use_trigs[i] SetHintString( string );
		}
		else if ( !isdefined(param2) )
		{
			self._trap_use_trigs[i] SetHintString( string, param1 );
		}
		else
		{
			self._trap_use_trigs[i] SetHintString( string, param1, param2 );
		}
	}
}


//*****************************************************************************
// It's a throw switch
//	self should be the trap entity
//*****************************************************************************
function trap_move_switches()
{
	self trap_lights_red();
	for ( i=0; i<self._trap_switches.size; i++ )
	{
		// Rotate switch model "on"
		self._trap_switches[i] rotatepitch( 180, .5 );
		self._trap_switches[i] playsound( "evt_switch_flip_trap" );
	}
	self._trap_switches[0] waittill( "rotatedone" );

	// When "available" notify hit, bring back the level
	self notify( "switch_activated" );

	self waittill( "available" );
	for ( i=0; i<self._trap_switches.size; i++ )
	{
		// Rotate switch model "off"
		self._trap_switches[i] rotatepitch( -180, .5 );
	}
	self._trap_switches[0] waittill( "rotatedone" );
	self trap_lights_green();
}

//*****************************************************************************
// 
//*****************************************************************************

function trap_activate_fire()
{
	self._trap_duration = 40;
	self._trap_cooldown_time = 60;

	// Kick off the client side FX structs
	util::clientNotify( self.script_string+"1" );
	util::clientNotify( self.script_parameters );

	// Kick off audio
	fx_points = struct::get_array( self.target,"targetname" );
	for( i=0; i<fx_points.size; i++ )
	{
		util::wait_network_frame();
		fx_points[i] thread trap_audio_fx(self);		
	}

	// Do the damage
	self thread trap_damage();
	wait( self._trap_duration );

	// Shut down
	self notify ("trap_done");	
	util::clientNotify(self.script_string +"0");	// turn off FX
	util::clientNotify( self.script_parameters );
}


//*****************************************************************************
// Any traps that spin and cause damage from colliding
//*****************************************************************************

function trap_activate_rotating()
{
	self endon( "trap_done" );	// used to end the trap early

	self._trap_duration = 30;
	self._trap_cooldown_time = 60;

	// Kick off the client side FX structs
//	util::clientNotify( self.script_string+"1" );

	// Kick off audio
// 	fx_points = struct::get_array( self.target,"targetname" );
// 	for( i=0; i<fx_points.size; i++ )
// 	{
// 		util::wait_network_frame();
// 		fx_points[i] thread trap_audio_fx(self);		
// 	}

	// Do the damage
	self thread trap_damage();
	self thread trig_update( self._trap_movers[0] );
	old_angles = self._trap_movers[0].angles;
	
	//Shawn J Sound - power up sound for centrifuge
//	self playsound ("evt_centrifuge_rise");
	
	for ( i=0; i<self._trap_movers.size; i++ )
	{
		self._trap_movers[i] RotateYaw( 360, 5.0, 4.5 );
	}
	wait( 5.0 );
	step = 1.5;
	
	//Shawn J Sound - loop sound for centrifuge
//	self playloopsound ("evt_centrifuge_loop", .6);
		
	for (t=0; t<self._trap_duration; t=t+step )
	{
		for ( i=0; i<self._trap_movers.size; i++ )
		{
			self._trap_movers[i] RotateYaw( 360, step );
		}
		wait( step );
	}
	
	//Shawn J Sound - power down sound for centrifuge
//	self stoploopsound (2);
//	self playsound ("evt_centrifuge_fall");
	
	for ( i=0; i<self._trap_movers.size; i++ )
	{
		self._trap_movers[i] RotateYaw( 360, 5.0, 0.0, 4.5 );
	}
	wait( 5.0 );
	for ( i=0; i<self._trap_movers.size; i++ )
	{
		self._trap_movers[i].angles = old_angles;
	}

	// Shut down
	self notify ("trap_done");	
//	util::clientNotify(self.script_string +"0");	// turn off FX3/16/2010 3:44:13 PM
}

//*****************************************************************************
// Any traps that spin and cause damage from colliding
//*****************************************************************************


//*****************************************************************************
// New zombapult or flipper traps
//*****************************************************************************

function trap_activate_flipper()
{ // basics of the trap are setup 
//	IPrintLnBold("trap is almost working...");
	
//	self endon( "trap_done" );	// Used to end the trap early

	
//	wait( 4 ); 
//	self._trap_duration = 3;
//	self._trap_cooldown_time = 0;
	
	
//	self notify ("trap_done");	
	
	//I need to communicate from here to the actual funcion
}


//*****************************************************************************
// 
//*****************************************************************************

function trap_audio_fx( trap )
{
	if( isdefined( level._custom_traps ) && isdefined( level._custom_traps[ trap.script_noteworthy ] ) && isdefined( level._custom_traps[ trap.script_noteworthy ].audio ) )
	{
		self [[ level._custom_traps[ trap.script_noteworthy ].audio ]]( trap );
	}
	else
	{
		sound_origin = undefined;
	    
		if( trap.script_noteworthy == "fire" )
		{
		    sound_origin = spawn( "script_origin", self.origin );
		    sound_origin playsound( "zmb_firetrap_start" );
		    sound_origin playloopsound( "zmb_firetrap_loop" );
		}
	
		trap util::waittill_any_timeout( trap._trap_duration, "trap_done");
	
		if(isdefined(sound_origin))
		{	
			if( trap.script_noteworthy == "fire" )
			    playsoundatposition( "zmb_firetrap_end", sound_origin.origin );
				else
				playsoundatposition( "wpn_zmb_electrap_stop", sound_origin.origin );	
			    
			sound_origin stoploopsound();
			wait(.05);
			sound_origin delete();
		}
	}
}

//*****************************************************************************
// 
//*****************************************************************************

function trap_damage()
{	
	self endon( "trap_done" );

	while(1)
	{
		self waittill( "trigger", ent );
		
		// Is player standing in the electricity?
		if( isplayer(ent) )
		{
			if( isdefined( level._custom_traps ) && isdefined( level._custom_traps[ self._trap_type ] ) && isdefined( level._custom_traps[ self._trap_type ].player_damage ) )
			{
				ent thread [[ level._custom_traps[ self._trap_type ].player_damage ]]();
				break;
			}
			else
			{
				switch ( self._trap_type )
				{
				case "fire":
				case "rocket":
					ent thread player_fire_damage();
					break;
				case "rotating":
					if ( ent GetStance() == "stand" )
					{
						ent dodamage( 50, ent.origin+(0,0,20) );
						ent SetStance( "crouch" );
					}
					break;
				}
			}
		}
		else
		{
			if(!isdefined(ent.marked_for_death))
			{
				if( isdefined( level._custom_traps ) && isdefined( level._custom_traps[ self._trap_type ] ) && isdefined( level._custom_traps[ self._trap_type ].damage ) )
				{
					ent thread [[ level._custom_traps[ self._trap_type ].damage ]]( self );
					break;
				}
				else
				{					
					switch ( self._trap_type )
					{
					case "rocket":
						ent thread zombie_trap_death( self, 100 );
						break;
					case "rotating":
						ent thread zombie_trap_death( self, 200 );
						break;
					case "fire":
					default:
						ent thread zombie_trap_death( self, randomint(100) );
						break;
					}
				}
			}
		}
	}
}


//*****************************************************************************
//	Updates the position of a trigger.	MoveTo and RotateTo do not support triggers
//TODO This is unneeded.  Should be able to Enable Linkto on the trigger.
//*****************************************************************************
function trig_update( parent )
{
	self endon( "trap_done" );
//	start_origin = self.origin;
	start_angles = self.angles;

	while (1)
	{
		self.angles = parent.angles;

//		segment = self.origin + VectorScale( AnglesToForward(self.angles), 300);
//		draw_line_for_time( self.origin, segment, 1, 1, 1, 0.1 );

		{wait(.05);};
	}
}

//*****************************************************************************
// 
//*****************************************************************************

function player_elec_damage()
{	
	self endon("death");
	self endon("disconnect");
	
	if( !isdefined(level.elec_loop) )
	{
		level.elec_loop = 0;
	}	
	
	if( !isdefined(self.is_burning) && zm_utility::is_player_valid( self ) )
	{
		self.is_burning = 1;
		
		if (( isdefined( level.trap_electric_visionset_registered ) && level.trap_electric_visionset_registered ))
		{
			visionset_mgr::activate( "overlay", "zm_trap_electric", self, 1.25, 1.25 );
		}
		else
		{
			self setelectrified(1.25);
		}
		shocktime = 2.5;

		//Changed Shellshock to Electrocution so we can have different bus volumes.
		self shellshock("electrocution", shocktime);
		
		if(level.elec_loop == 0)
		{	
			elec_loop = 1;
			//self playloopsound ("electrocution");
			self playsound("wpn_zmb_electrap_zap");
		}
		if(!self hasperk( "specialty_armorvest" ) || self.health - 100 < 1)
		{
			radiusdamage(self.origin,10,self.health + 100,self.health + 100);
			self.is_burning = undefined;

		}
		else
		{
			self dodamage(50, self.origin);
			wait(.1);
			//self playsound("wpn_zmb_electrap_zap");
			self.is_burning = undefined;
		}
	}
}

function player_fire_damage()
{	
	self endon("death");
	self endon("disconnect");
	
	if( !isdefined(self.is_burning) && !self laststand::player_is_in_laststand() )
	{
		self.is_burning = 1;		
		if (( isdefined( level.trap_fire_visionset_registered ) && level.trap_fire_visionset_registered ))
			visionset_mgr::activate( "overlay", "zm_trap_burn", self, 1.25, 1.25 );
		else
			self setburn(1.25);
			
		self notify("burned");

		if(!self hasperk( "specialty_armorvest" ) || self.health - 100 < 1)
		{
			radiusdamage(self.origin,10,self.health + 100,self.health + 100);
			self.is_burning = undefined;
		}
		else
		{
			self dodamage(50, self.origin);
			wait(.1);
			//self playsound("wpn_zmb_electrap_zap");
			self.is_burning = undefined;
		}
	}
}


//*****************************************************************************
//	trap is the parent trap entity
//	param is a multi-purpose paramater.  The exact use is described by trap type
//*****************************************************************************
function zombie_trap_death( trap, param )
{
	self endon("death");
	
	self.marked_for_death = true;

	switch (trap._trap_type)
	{
	case "fire":
	case "rocket":
		// Param is used as a random chance number

		if ( isdefined( self.animname ) && self.animname != "zombie_dog" )
		{
			// 10% chance the zombie will burn, a max of 6 burning zombs can be going at once
			// otherwise the zombie just gibs and dies
			if( (param > 90) && (level.burning_zombies.size < 6) )
			{
				level.burning_zombies[level.burning_zombies.size] = self;
				self thread zombie_flame_watch();
				self playsound("zmb_ignite");

				self thread zombie_death::flame_death_fx();
				PlayFxOnTag( level._effect["character_fire_death_torso"], self, "J_SpineLower" ); 

				wait( randomfloat(1.25) );
			}
			else
			{
				refs[0] = "guts";
				refs[1] = "right_arm"; 
				refs[2] = "left_arm"; 
				refs[3] = "right_leg"; 
				refs[4] = "left_leg"; 
				refs[5] = "no_legs";
				refs[6] = "head";
				self.a.gib_ref = refs[randomint(refs.size)];
                
				playsoundatposition("wpn_zmb_electrap_zap", self.origin);
				
				wait(randomfloat(1.25));
				self playsound("wpn_zmb_electrap_zap");
			}
		}

		// custom damage
		if ( isdefined( self.fire_damage_func ) )
		{
			self [[ self.fire_damage_func ]]( trap );
		}
		else
		{
			level notify( "trap_kill", self, trap );
			self dodamage(self.health + 666, self.origin, trap);
		}
	
//		iprintlnbold("should be damaged");
		break;

	case "rotating":
	case "centrifuge":
		// Param is used as a magnitude for the physics push

		// Get a vector for the force to be applied.  It needs to be perpendicular to the 
		//	bar
		ang = VectorToAngles( trap.origin - self.origin );
		// eliminate height difference factors
		//	calculate the right angle and increase intensity
		direction_vec = VectorScale( AnglesToRight( ang ), param);

		// custom reaction
		if ( isdefined( self.trap_reaction_func ) )
		{
			self [[ self.trap_reaction_func ]]( trap );
		}

		level notify( "trap_kill", self, trap );
		self StartRagdoll();
		self launchragdoll(direction_vec);
		util::wait_network_frame();

		// Make sure they're dead...physics launch didn't kill them.
		self.a.gib_ref = "head";
		self dodamage(self.health, self.origin, trap);

		break;
	}
}


//*****************************************************************************
// 
//*****************************************************************************

function zombie_flame_watch()
{
	self waittill("death");
	self stoploopsound();
	ArrayRemoveValue(level.burning_zombies,self);
}


//*****************************************************************************
// 
//*****************************************************************************

function play_elec_vocals()
{
	if( isdefined (self) )
	{
		org = self.origin;
		wait(0.15);
		playsoundatposition("zmb_elec_vocals", org);
		playsoundatposition("wpn_zmb_electrap_zap", org);
		playsoundatposition("zmb_exp_jib_zombie", org);
	}
}


//*****************************************************************************
// 
//*****************************************************************************
	
function electroctute_death_fx()
{
	self endon( "death" );

	if (isdefined(self.is_electrocuted) && self.is_electrocuted )
	{
		return;
	}

	self.is_electrocuted = true;
	
	self thread electrocute_timeout();
		
	if ( (self.team == level.zombie_team) )
	{
		level.bcOnFireTime = gettime();
		level.bcOnFireOrg = self.origin;
	}
	
	if (isdefined(level._effect["elec_torso"]))
		PlayFxOnTag( level._effect["elec_torso"], self, "J_SpineLower" );
	self playsound ("zmb_elec_jib_zombie");
	wait 1;

	tagArray = []; 
	tagArray[0] = "J_Elbow_LE"; 
	tagArray[1] = "J_Elbow_RI"; 
	tagArray[2] = "J_Knee_RI"; 
	tagArray[3] = "J_Knee_LE"; 
	tagArray = array::randomize( tagArray ); 

	if (isdefined(level._effect["elec_md"]))
		PlayFxOnTag( level._effect["elec_md"], self, tagArray[0] ); 
	self playsound ("zmb_elec_jib_zombie");

	wait 1;
	self playsound ("zmb_elec_jib_zombie");

	tagArray[0] = "J_Wrist_RI"; 
	tagArray[1] = "J_Wrist_LE"; 
	if( !isdefined( self.a.gib_ref ) || self.a.gib_ref != "no_legs" )
	{
		tagArray[2] = "J_Ankle_RI"; 
		tagArray[3] = "J_Ankle_LE"; 
	}
	tagArray = array::randomize( tagArray ); 

	if (isdefined(level._effect["elec_sm"]))
	{
		PlayFxOnTag( level._effect["elec_sm"], self, tagArray[0] ); 
		PlayFxOnTag( level._effect["elec_sm"], self, tagArray[1] );
	}
}


//*****************************************************************************
// 
//*****************************************************************************

function electrocute_timeout()
{
	self endon ("death");
	self playloopsound("amb_fire_manager_0");
	// about the length of the flame fx
	wait 12;
	self stoploopsound();
	if (isdefined(self) && isalive(self))
	{
		self.is_electrocuted = false;
		self notify ("stop_flame_damage");
	}
	
}


//*****************************************************************************
// 
//*****************************************************************************

function trap_dialog()
{

	self endon ("warning_dialog");
	level endon("switch_flipped");
	timer =0;
	while(1)
	{
		wait(0.5);
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{		
			if (!IsDefined(players[i]))
				continue;
			dist = distancesquared(players[i].origin, self.origin );
			if(dist > 70*70)
			{
				timer = 0;
				continue;
			}
			if(dist < 70*70 && timer < 3)
			{
				wait(0.5);
				timer ++;
			}
			if(dist < 70*70 && timer == 3)
			{
				
				index = zm_utility::get_player_index(players[i]);
				plr = "plr_" + index + "_";
				//players[i] zm_audio::create_and_play_dialog( plr, "vox_level_start", 0.25 );
				wait(3);				
				self notify ("warning_dialog");
				//iprintlnbold("warning_given");
			}
		}
	}
}


//*****************************************************************************
// Find Trap triggers
//*****************************************************************************
function get_trap_array( trap_type )
{
	ents = GetEntArray( "zombie_trap", "targetname" );
	traps = [];
	for ( i=0; i<ents.size; i++ )
	{
		if ( ents[i].script_noteworthy == trap_type )
		{
			traps[ traps.size ] = ents[i];
		}
	}

	return traps;
}

//*****************************************************************************
// 
//*****************************************************************************
function trap_disable()
{
	cooldown = self._trap_cooldown_time;

	if ( self._trap_in_use )
	{
		self notify( "trap_done" );
		self._trap_cooldown_time = 0.05;
		self waittill( "available" );
	}

	array::thread_all( self._trap_use_trigs,&TriggerEnable, false );
	self trap_lights_red();
	self._trap_cooldown_time = cooldown;
}

//*****************************************************************************
// 
//*****************************************************************************
function trap_enable()
{
	array::thread_all( self._trap_use_trigs,&TriggerEnable, true );
	self trap_lights_green();
}

//******************************************************************************
// WWilliams: checks the trigger script parameters and then assigns which models
// should be used for swapping
//******************************************************************************
function trap_model_type_init()
{
	// this depends on the trap trigger to have the script_parameters
	// to chose which models to use
	if( !isdefined( self.script_parameters ) ) 
	{
		self.script_parameters = "default";
	}
	
	// new models should be added here for updated trap
	switch( self.script_parameters )
	{
		case "pentagon_electric": //WW: TODO - REMOVE THIS ONCE A NEW PENTAGON BSP HAS BEEN GENERATED
			self._trap_light_model_off = "zombie_trap_switch_light";
			self._trap_light_model_green = "zombie_trap_switch_light_on_green";
			self._trap_light_model_red = "zombie_trap_switch_light_on_red";
			self._trap_switch_model = "zombie_trap_switch_handle";
			break;
				
		case "default":
		default:
			self._trap_light_model_off = "zombie_zapper_cagelight";
			self._trap_light_model_green = "zombie_zapper_cagelight"; // TODO T7 "zombie_zapper_cagelight_green";
			self._trap_light_model_red = "zombie_zapper_cagelight"; // TODO T7 "zombie_zapper_cagelight_red";
			self._trap_switch_model = "zombie_zapper_handle";
			break;	
	}
	
}

function register_visionsets( a_traps )
{
	a_registered_traps = [];
	
	//Check to see if a trap type has been registered yet and if not, add it to the array to get registered
	//We want to make sure each type is only registered once
	foreach( trap in a_traps )
	{
		if( isdefined( trap.script_noteworthy ) )
		{
			if( !trap is_trap_registered( a_registered_traps ) )
			{
				a_registered_traps[ trap.script_noteworthy ] = 1;
			}
		}
	}
	
	//Register each type used in the map
	keys = GetArrayKeys( a_registered_traps );
	foreach( key in keys )
	{
		switch( key )
		{				
			case "fire":
				if ( !IsDefined( level.vsmgr_prio_overlay_zm_trap_burn ) )
				{
					level.vsmgr_prio_overlay_zm_trap_burn = 61;
				}	
				visionset_mgr::register_info( "overlay", "zm_trap_burn", 1, level.vsmgr_prio_overlay_zm_trap_burn, 15, true, &visionset_mgr::duration_lerp_thread_per_player, false );				
				level.trap_fire_visionset_registered = true;
				break;
		}		
	}
}

function is_trap_registered( a_registered_traps )//self = struct
{
	return isdefined( a_registered_traps[ self.script_noteworthy ] );
}

/@
"Name: register_trap_basic_info( <str_trap>, <func_activate>, <func_audio> )"
"Module: Zombie Traps"
"Summary: Register basic info for a custom trap"
"MandatoryArg: <str_trap>: the name of the trap. This should be unique, and will identify this trap in system scripts."
"MandatoryArg: <func_activate> the function that will run when this trap is activated"
"MandatoryArg: <func_audio>: the audio function that will run when activated"
"Example: register_trap_basic_info( "electric", &trap_activate_electric, &trap_audio );"
"SPMP: multiplayer"
@/
function register_trap_basic_info( str_trap, func_activate, func_audio )
{
	Assert( IsDefined( str_trap ), "str_trap is a required argument for register_trap_basic_info!" );
	Assert( IsDefined( func_activate ), "str_alias is a required argument for register_trap_basic_info!" );
	Assert( IsDefined( func_audio ), "n_perk_cost is a required argument for register_trap_basic_info!" );
	
	_register_undefined_trap( str_trap );
	
	level._custom_traps[ str_trap ].activate = func_activate;
	level._custom_traps[ str_trap ].audio = func_audio;
}

// make sure trap exists before we actually try to set fields on it. Does nothing if it exists already
function _register_undefined_trap( str_trap )
{
	if ( !IsDefined( level._custom_traps ) )
	{
		level._custom_traps = [];
	}
	
	if ( !IsDefined( level._custom_traps[ str_trap ] ) )
	{
		level._custom_traps[ str_trap ] = SpawnStruct();
	}	
}

/@
"Name: register_trap_damage( <str_trap>, <func_player_damage>, <func_damage> )"
"Module: Zombie Traps"
"Summary: Register damage info for a custom trap"
"MandatoryArg: <str_trap>: the name of the trap. This should be unique, and will identify this trap in system scripts."
"MandatoryArg: <func_player_damage> the function that will run if a player is damaged by this trap"
"MandatoryArg: <func_damage>: the function that will run if a non-player is damaged by this trap"
"Example: register_trap_damage( "electric", &player_damage, &trap_damage );"
"SPMP: multiplayer"
@/
function register_trap_damage( str_trap, func_player_damage, func_damage )
{
	Assert( IsDefined( str_trap ), "str_trap is a required argument for register_trap_basic_info!" );
	
	_register_undefined_trap( str_trap );
	
	level._custom_traps[ str_trap ].player_damage = func_player_damage;
	level._custom_traps[ str_trap ].damage = func_damage;
}
