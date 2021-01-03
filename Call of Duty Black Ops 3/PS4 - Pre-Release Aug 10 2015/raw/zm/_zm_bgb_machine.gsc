    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                 
                                                                                                                                                                                                                         
                                                                                                                               

#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm;
#using scripts\zm\_bb;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#precache( "triggerstring", "ZOMBIE_BGB_MACHINE_AVAILABLE" );
#precache( "triggerstring", "ZOMBIE_BGB_MACHINE_COMEBACK" );
#precache( "triggerstring", "ZOMBIE_BGB_MACHINE_OFFERING" );
#precache( "triggerstring", "ZOMBIE_BGB_MACHINE_AWAY" );
#precache( "triggerstring", "ZOMBIE_BGB_MACHINE_OUT_OF" );








#namespace bgb_machine;

function autoexec __init__sytem__() {     system::register("bgb_machine",&__init__,&__main__,undefined);    }

function private __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	callback::on_connect( &on_player_connect );
	callback::on_disconnect( &on_player_disconnect );

	clientfield::register( "zbarrier", "zm_bgb_machine", 1, 1, "int" );
	clientfield::register( "zbarrier", "zm_bgb_machine_selection", 1, 8, "int" );
	clientfield::register( "zbarrier", "zm_bgb_machine_fx_state", 1, 3, "int" );
	clientfield::register( "zbarrier", "zm_bgb_machine_ghost_ball", 1, 1, "int" );

	level thread bgb_machine_host_migration();
}

function private __main__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	if ( !IsDefined( level.bgb_machine_count ) )
	{
		level.bgb_machine_count = 3;
	}

	if ( !IsDefined( level.bgb_machine_state_func ) )
	{
		level.bgb_machine_state_func = &process_bgb_machine_state;
	}

/#
	level thread setup_devgui();
#/
	level thread setup_bgb_machines();
}

function private on_player_connect()
{	
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	level thread bgb_machine_movement_frequency();
}


function private on_player_disconnect()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	level thread bgb_machine_movement_frequency();
}

/#
function private setup_devgui()
{
	waittillframeend;

	SetDvar( "bgb_machine_arrive_devgui", 0 );
	SetDvar( "bgb_machine_move_devgui", 0 );
	SetDvar( "bgb_machine_force_give_devgui", "" );
	SetDvar( "bgb_machine_reset_usable_devgui", 0 );
	SetDvar( "bgb_machine_toggle_never_move_devgui", 0 );

	bgb_devgui_base = "devgui_cmd \"ZM/BGB/Machine/";

	keys = GetArrayKeys( level.bgb );
	for ( i = 0; i < keys.size; i++ )
	{
		AddDebugCommand( bgb_devgui_base + "Force Give/" + keys[i] + "\" \"set " + "bgb_machine_force_give_devgui" + " " + keys[i] + "\" \n");
	}

	AddDebugCommand( bgb_devgui_base + "Location/Arrive\" \"set " + "bgb_machine_arrive_devgui" + " 1\" \n");
	AddDebugCommand( bgb_devgui_base + "Location/Move\" \"set " + "bgb_machine_move_devgui" + " 1\" \n");
	AddDebugCommand( bgb_devgui_base + "Reset Usable\" \"set " + "bgb_machine_reset_usable_devgui" + " 1\" \n");
	AddDebugCommand( bgb_devgui_base + "Location/Toggle Never Move\" \"set " + "bgb_machine_toggle_never_move_devgui" + " 1\" \n");

	level thread bgb_machine_devgui_think();
}

function private bgb_machine_devgui_think()
{
	for ( ;; )
	{
		arrive = GetDvarInt( "bgb_machine_arrive_devgui" );
		move = GetDvarInt( "bgb_machine_move_devgui" );
		if ( move || arrive )
		{
			pos = level.players[0].origin;
			best_dist_sq = 999999999;
			best_index = -1;
			for ( i = 0; i < level.bgb_machines.size; i++ )
			{
				new_dist_sq = DistanceSquared( pos, level.bgb_machines[i].origin );
				if ( new_dist_sq < best_dist_sq )
				{
					best_index = i;
					best_dist_sq = new_dist_sq;
				}
			}

			if ( 0 <= best_index )
			{
				if ( arrive )
				{
					if ( !level.bgb_machines[best_index].current_bgb_machine )
					{
						for ( i = 0; i < level.bgb_machines.size; i++ )
						{
							if ( level.bgb_machines[i].current_bgb_machine )
							{
								level.bgb_machines[i] thread hide_bgb_machine();
								break;
							}
						}

						level.bgb_machines[best_index].current_bgb_machine = true;
						level.bgb_machines[best_index] thread show_bgb_machine();
					}
				}
				else
				{
					level.bgb_machines[best_index] thread bgb_machine_move();
				}
			}

			SetDvar( "bgb_machine_arrive_devgui", 0 );
			SetDvar( "bgb_machine_move_devgui", 0 );

		}

		force_give = GetDvarString( "bgb_machine_force_give_devgui" );
		if ( GetDvarInt( "bgb_machine_reset_usable_devgui" ) || "" != force_give )
		{
			for ( i = 0; i < level.players.size; i++ )
			{
				level.players[i].can_use_bgb_machine = true;
			}

			SetDvar( "bgb_machine_reset_usable_devgui", 0 );
		}

		if ( "" != force_give )
		{
			level.bgb_machine_force_give = force_give;

			SetDvar( "bgb_machine_force_give_devgui", "" );
		}

		wait( 0.5 );
	}
}
#/

function private setup_bgb_machines()
{
	waittillframeend;

	level.bgb_machines = GetEntArray( "bgb_machine_use", "targetname" );
	bgb_machine_init();
}

function private bgb_machine_init()
{
	if ( !level.bgb_machines.size )
	{
		return;
	}
	
	for ( i = 0; i < level.bgb_machines.size; i++ )
	{
		if ( !isDefined( level.bgb_machines[i].cost ) )
		{
			// default chest cost
			level.bgb_machines[i].cost = 500;
		}
		level.bgb_machines[i].old_cost = level.bgb_machines[i].cost;

		level.bgb_machines[i].current_bgb_machine = false;
		level.bgb_machines[i].uses_at_current_location = 0;
		level.bgb_machines[i] create_bgb_machine_unitrigger_stub();
	}

	if ( !level.enable_magic )
	{
		foreach ( bgb_machine in level.bgb_machines )
		{
			bgb_machine thread hide_bgb_machine();
		}
		return;
	}

	level.bgb_machines = array::randomize( level.bgb_machines );

	init_starting_bgb_machine_location();

	array::thread_all( level.bgb_machines, &bgb_machine_think );
}

function private init_starting_bgb_machine_location()
{
	start_bgb_machine_found = 0;
	bgb_machines_to_hide = [];
	
	for ( i = 0; i < level.bgb_machines.size; i++ )
	{
		level.bgb_machines[i] clientfield::set( "zm_bgb_machine", 1 );

		// Semi-random implementation (not completely random).  The list is randomized
		//	prior to getting here.
		// Pick from any bgb_machine marked as the "start_bgb_machine"
		if ( start_bgb_machine_found >= level.bgb_machine_count || !IsDefined( level.bgb_machines[i].script_noteworthy ) || !IsSubStr( level.bgb_machines[i].script_noteworthy, "start_bgb_machine" ) )
		{
			bgb_machines_to_hide[bgb_machines_to_hide.size] = level.bgb_machines[i];
		}
		else
		{
			level.bgb_machines[i].hidden = false;
			level.bgb_machines[i].current_bgb_machine = true;
			level.bgb_machines[i] set_bgb_machine_state( "initial" );
			start_bgb_machine_found++;
		}
	}

	// if we didn't find enough start machines, just show them from the start of the to_hide array until there's enough, and then hide the rest
	for ( i = 0; i < bgb_machines_to_hide.size; i++ )
	{
		if ( start_bgb_machine_found >= level.bgb_machine_count )
		{
			bgb_machines_to_hide[i] thread hide_bgb_machine();
		}
		else
		{
			bgb_machines_to_hide[i].hidden = false;
			bgb_machines_to_hide[i].current_bgb_machine = true;
			bgb_machines_to_hide[i] set_bgb_machine_state( "initial" );
			start_bgb_machine_found++;
		}
	}
}

function create_bgb_machine_unitrigger_stub()
{
	self.unitrigger_stub = spawnstruct();
	self.unitrigger_stub.origin = self.origin + (anglestoright( self.angles ) * -22.5);
	self.unitrigger_stub.angles = self.angles;
	self.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	self.unitrigger_stub.script_width = 96;
	self.unitrigger_stub.script_height = 96;
	self.unitrigger_stub.script_length = 96;
	self.unitrigger_stub.trigger_target = self;
	zm_unitrigger::unitrigger_force_per_player_triggers( self.unitrigger_stub, true );
	self.unitrigger_stub.prompt_and_visibility_func = &bgb_machine_trigger_update_prompt;
}

function bgb_machine_trigger_update_prompt( player )
{
	can_use = self bgb_machine_stub_update_prompt( player );
	if ( IsDefined( self.hint_string ) )
	{
		if ( IsDefined( self.hint_parm1 ) )
		{
			self SetHintString( self.hint_string, self.hint_parm1 );
		}
		else
		{
			self SetHintString( self.hint_string );
		}
	}

	return can_use;
}

function bgb_machine_stub_update_prompt( player )
{
	b_result = false;
	
	if( !self trigger_visible_to_player( player ) )
	{
		return b_result;
	}
	
	self.hint_parm1 = undefined; 
	if( ( isdefined( self.stub.trigger_target.grab_bgb_hint ) && self.stub.trigger_target.grab_bgb_hint ) )
	{
		if( !( isdefined( self.stub.trigger_target.b_bgb_is_available ) && self.stub.trigger_target.b_bgb_is_available ) )
		{
			str_hint = &"ZOMBIE_BGB_MACHINE_OUT_OF";
			b_result = false;
		}
		else
		{
			str_hint = &"ZOMBIE_BGB_MACHINE_OFFERING";
			b_result = true;
		}
		cursor_hint = "HINT_BGB";
		cursor_hint_bgb = level.bgb[self.stub.trigger_target.selected_bgb].item_index;
		self setCursorHint( cursor_hint, cursor_hint_bgb );
		self.hint_string = str_hint;
	}
	else
	{
		self setCursorHint( "HINT_NOICON" );
		if( ( isdefined( player.can_use_bgb_machine ) && player.can_use_bgb_machine ) )
		{
			self.hint_string = &"ZOMBIE_BGB_MACHINE_AVAILABLE";
			self.hint_parm1 = self.stub.trigger_target.cost;
			b_result = true;
		}
		else
		{
			self.hint_string = &"ZOMBIE_BGB_MACHINE_COMEBACK";
			b_result = false;
		}
	}

	return b_result;
}

function trigger_visible_to_player( player )
{
	self SetInvisibleToPlayer( player );

	visible = true;	

	if ( !player zm_magicbox::can_buy_weapon() )
	{
		visible = false;
	}

	if ( !visible )
	{
		return false;
	}
	
	// don't let non-users steal the gum
	if( isdefined( self.stub.trigger_target.bgb_machine_user ) && ( player !== self.stub.trigger_target.bgb_machine_user ) )
	{
		return false;
	}
	
	self SetVisibleToPlayer( player );
	return true;
}

function bgb_machine_unitrigger_think()
{
	self endon( "kill_trigger" );

	while ( 1 )
	{
		self waittill( "trigger", player );
		self.stub.trigger_target notify("trigger", player );
	}
}

function show_bgb_machine()
{
	self set_bgb_machine_state( "arriving" );
	self waittill( "arrived" );

	self.hidden = false;
}

function hide_bgb_machine( do_bgb_machine_leave )
{
	self thread zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );

	self.hidden = true;
	self.uses_at_current_location = 0;
	self.current_bgb_machine = false;

	if ( ( isdefined( do_bgb_machine_leave ) && do_bgb_machine_leave ) )
	{
		self thread set_bgb_machine_state( "leaving" );
	}
	else
	{
		self thread set_bgb_machine_state( "away" );
	}
}

// sets the .selected_bgb on the machine
// return whether the selected bgb is available
function private bgb_machine_select_bgb( player )
{
	if ( !player.bgb_pack_randomized.size )
	{
		player.bgb_pack_randomized = array::randomize( player.bgb_pack );
	}

	self.selected_bgb = array::pop_front( player.bgb_pack_randomized );

	if ( IsDefined( level.bgb_machine_force_give ) )
	{
		self.selected_bgb = level.bgb_machine_force_give;
		level.bgb_machine_force_give = undefined;
	}
	
	clientfield::set( "zm_bgb_machine_selection", level.bgb[self.selected_bgb].item_index );
	
	// return whether the selected bgb is available to the player
	return player bgb::get_bgb_available( self.selected_bgb );
}

function bgb_machine_think()
{
	while( 1 )
	{
		self waittill( "trigger", user ); 
		if ( user == level )
		{
			continue;
		}

		if ( user zm_utility::in_revive_trigger() )
		{
			wait( 0.1 );
			continue;
		}
		
		if ( ( user.is_drinking > 0 ) )
		{
			wait( 0.1 );
			continue;
		}

		if ( ( isdefined( self.disabled ) && self.disabled ) )
		{
			wait( 0.1 );
			continue;
		}

		if ( user GetCurrentWeapon() == level.weaponNone )
		{
			wait( 0.1 );
			continue;
		}

		if ( zm_utility::is_player_valid( user ) && user.score >= self.cost )
		{
			user zm_score::minus_to_player_score( self.cost );
			self.bgb_machine_user = user;
			self.current_cost = self.cost; // store off the cost we paid, so we can refund the same amount (prevent issue with firesale, etc.)
			break;
		}
		else
		{
			zm_utility::play_sound_at_pos( "no_purchase", self.origin );
			user zm_audio::create_and_play_dialog( "general", "outofmoney" );
			continue;	
		}

		{wait(.05);}; 
	}
	
	//stat tracking
//	demo::bookmark( "zm_player_use_bgb_machine", gettime(), user );
//	user zm_stats::increment_client_stat( "use_bgb_machine" );
//	user zm_stats::increment_player_stat( "use_bgb_machine" );

	if ( isDefined( level.bgb_machine_used_VO ) )
	{
		user thread [[ level.bgb_machine_used_VO ]]();
	}

	self.bgb_machine_user = user;
	self.bgb_machine_open = true;
	self.bgb_machine_opened_by_fire_sale = false;
	if ( ( isdefined( level.zombie_vars["zombie_powerup_fire_sale_on"] ) && level.zombie_vars["zombie_powerup_fire_sale_on"] ) )
	{
		self.bgb_machine_opened_by_fire_sale = true;
	}
	else
	{
		self.uses_at_current_location++;
	}

	self.b_bgb_is_available = self thread bgb_machine_select_bgb( user );

	self thread zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );

	self set_bgb_machine_state( "open" );

	self waittill( "gumball_available" );

	// Let the player grab the bgb and re-enable the bgb_machine
	self.grab_bgb_hint = true;
	self thread zm_unitrigger::register_static_unitrigger( self.unitrigger_stub, &bgb_machine_unitrigger_think );
	
	// if we drew a ghost ball, continue to the calculation of whether the machine should leave
	if( self.b_bgb_is_available )
	{
		bb::LogPurchaseEvent(user, self, self.current_cost, self.selected_bgb, false, "_bgb", "_offered");
		user zm_audio::create_and_play_dialog( "bgb", "buy" );
	
		while ( true )
		{
			self waittill( "trigger", grabber );
	
			if ( IsDefined( grabber.is_drinking ) && ( grabber.is_drinking > 0 ) )
			{
				wait( 0.1 );
				continue;
			}
	
			if ( grabber == user && user GetCurrentWeapon() == level.weaponNone )
			{
				wait( 0.1 );
				continue;
			}
	
			if ( grabber == user || grabber == level )			
			{
				current_weapon = level.weaponNone;
	
				if ( zm_utility::is_player_valid( user ) )
				{
					current_weapon = user GetCurrentWeapon();
				}
	
				if ( grabber == user && 
				     zm_utility::is_player_valid( user ) && 
				     !( user.is_drinking > 0 ) && 
				     !zm_utility::is_placeable_mine( current_weapon ) && 
				     !zm_equipment::is_equipment( current_weapon ) && 
				     !user zm_utility::is_player_revive_tool(current_weapon) && 
				     !current_weapon.isheroweapon )
				{
					self notify( "user_grabbed_bgb" );
					user notify( "user_grabbed_bgb" );
					bb::LogPurchaseEvent(user, self, self.current_cost, self.selected_bgb, false, "_bgb", "_grabbed");
					user bgb::sub_consumable_bgb( self.selected_bgb ); // increment bgbs of type used
					
					user thread bgb::bgb_gumball_anim( self.selected_bgb, false );
	
					user zm_audio::create_and_play_dialog( "bgb", "eat" );
	
					//stat tracking
	//				demo::bookmark( "zm_player_grabbed_bgb", gettime(), user );
	//				user zm_stats::increment_client_stat( "grabbed_from_bgb" );
	//				user zm_stats::increment_player_stat( "grabbed_from_bgb" );
	
					break; 
				}
				else if ( grabber == level )
				{
					bb::LogPurchaseEvent(user, self, self.current_cost, self.selected_bgb, false, "_bgb", "_returned");
					break;
				}
			}
	
			{wait(.05);}; 
		}
	
		user.can_use_bgb_machine = false;
		
		if ( grabber == user )
		{
			self set_bgb_machine_state( "close" );
			self waittill( "closed" );
		}
		
	}
	else // bgb not available (ghost ball came up)
	{
		// give player a moment to see the prompt
		wait 3;

		self set_bgb_machine_state( "close" );
		self waittill( "closed" );
		
		// refund money
		bb::LogPurchaseEvent(user, self, self.current_cost, self.selected_bgb, false, "_bgb","_ghostball");
		user zm_score::add_to_player_score( self.current_cost, false );
	}

	self thread zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );
	self.grab_bgb_hint = false;

	wait( 1 );

	if ( bgb_machine_should_move() )
	{
		self thread bgb_machine_move();
	}
	else if ( ( isdefined( level.zombie_vars["zombie_powerup_fire_sale_on"] ) && level.zombie_vars["zombie_powerup_fire_sale_on"] ) || self.current_bgb_machine )
	{
		self thread set_bgb_machine_state( "initial" );
	}

	self.bgb_machine_open = false;
	self.bgb_machine_opened_by_fire_sale = false;
	self.bgb_machine_user = undefined;
	
	self notify( "bgb_machine_accessed" );
	
	self thread bgb_machine_think();
}
	
function private bgb_machine_should_move()
{
/#
	if ( GetDvarInt( "bgb_machine_toggle_never_move_devgui" ) )
	{
		return false;
	}
#/

	if ( self.uses_at_current_location >= level.bgb_machine_max_uses_before_move )
	{
		return true;
	}

	if ( self.uses_at_current_location < level.bgb_machine_min_uses_before_move )
	{
		return false;
	}

	if ( Randomint( 100 ) < 30 )
	{
		return true;
	}

	return false;
}

function private bgb_machine_movement_frequency()
{
	if ( IsDefined( level.bgb_machine_movement_frequency_override_func ) )
	{
		[[ level.bgb_machine_movement_frequency_override_func ]]();
		return;
	}

	// set range of uses-before-move based on number of players
	switch ( level.players.size )
	{
		case 1:
			level.bgb_machine_min_uses_before_move = 1;
			level.bgb_machine_max_uses_before_move = 3;
			break;
		case 2:
			level.bgb_machine_min_uses_before_move = 1;
			level.bgb_machine_max_uses_before_move = 4;
			break;
		case 3:
			level.bgb_machine_min_uses_before_move = 3;
			level.bgb_machine_max_uses_before_move = 5;
			break;
		case 4:
			level.bgb_machine_min_uses_before_move = 3;
			level.bgb_machine_max_uses_before_move = 6;
			break;
	}
}

function turn_on_fire_sale()
{
	for ( i = 0; i < level.bgb_machines.size; i++ )
	{
		level.bgb_machines[i].old_cost = level.bgb_machines[i].cost;
		level.bgb_machines[i].cost = 10;

		if ( !level.bgb_machines[i].current_bgb_machine )
		{
			level.bgb_machines[i].was_fire_sale_temp = true;
			level.bgb_machines[i] thread show_bgb_machine();
		}
	}
}

function turn_off_fire_sale()
{
	for ( i = 0; i < level.bgb_machines.size; i++ )
	{
		level.bgb_machines[i].cost = level.bgb_machines[i].old_cost;

		if ( !level.bgb_machines[i].current_bgb_machine && ( isdefined( level.bgb_machines[i].was_fire_sale_temp ) && level.bgb_machines[i].was_fire_sale_temp ) )
		{
			level.bgb_machines[i].was_fire_sale_temp = undefined;
			level.bgb_machines[i] thread remove_temp_machine();
		}
	}
}

function private remove_temp_machine()
{
	while ( IsDefined( self.bgb_machine_user ) || ( isdefined( self.bgb_machine_open ) && self.bgb_machine_open ) )
	{
		util::wait_network_frame();
	}
	
	if ( level.zombie_vars["zombie_powerup_fire_sale_on"] ) // Grabbed a second FireSale while temp box was open and original FireSale ended
	{
		self.was_fire_sale_temp = true;
		self.cost = 10;
		return;
	}

	self thread hide_bgb_machine( true );
}

function bgb_machine_move()
{
	self hide_bgb_machine( true );

	wait( 0.1 );

	post_selection_wait_duration = 7;	

	// DCS 072710: check if fire sale went into effect during move, reset with time left.
	if ( ( isdefined( level.zombie_vars["zombie_powerup_fire_sale_on"] ) && level.zombie_vars["zombie_powerup_fire_sale_on"] ) )
	{
		current_sale_time = level.zombie_vars["zombie_powerup_fire_sale_time"];
		//IPrintLnBold( "need to reset this bgb_machine spot! Time left is ", current_sale_time );

		util::wait_network_frame();				
		self thread fire_sale_fix();
		level.zombie_vars["zombie_powerup_fire_sale_time"] = current_sale_time;

		while ( level.zombie_vars["zombie_powerup_fire_sale_time"] > 0 )
		{
			wait( 0.1 );
		}	
	}	
	else
	{
		post_selection_wait_duration += 5;
	}

	//wait for all the bgb_machines to reset 
	wait( post_selection_wait_duration );

	keys = GetArrayKeys( level.bgb_machines );
	keys = array::randomize( keys );
	for ( i = 0; i < keys.size; i++ )
	{
		if ( self == level.bgb_machines[keys[i]] || level.bgb_machines[keys[i]].current_bgb_machine )
		{
			continue;
		}

		level.bgb_machines[keys[i]].current_bgb_machine = true;
		level.bgb_machines[keys[i]] show_bgb_machine();
		break;
	}
}


function fire_sale_fix()
{
	if ( !IsDefined( level.zombie_vars["zombie_powerup_fire_sale_on"] ) )
	{
		return;
	}

	self.old_cost = self.cost;
	self thread show_bgb_machine();
	self.cost = 10;

	util::wait_network_frame();

	level waittill( "fire_sale_off" );

	while ( ( isdefined( self.bgb_machine_open ) && self.bgb_machine_open ) )
	{
		wait( 0.1 );
	}		

	self thread hide_bgb_machine( true );

	self.cost = self.old_cost;
}

function bgb_machine_lion_twitches()
{
	self endon( "zbarrier_state_change" );
	
	clientfield::set( "zm_bgb_machine_fx_state", 1 );

	self SetZBarrierPieceState( 0, "closed" );
	self SetZBarrierPieceState( 5, "closed" );
	
	while ( 1 )
	{
		wait( randomfloatrange( 180, 1800 ) );
		self SetZBarrierPieceState( 0, "opening" );
		wait( randomfloatrange( 180, 1800 ) );
		self SetZBarrierPieceState( 0, "closing" );
	}
}

function bgb_machine_initial()
{
	clientfield::set( "zm_bgb_machine_fx_state", 4 );

	self SetZBarrierPieceState( 2, "open" );
	self SetZBarrierPieceState( 3, "open" );
	self SetZBarrierPieceState( 5, "closed" );
}

function bgb_machine_arrives()
{
	self endon("zbarrier_state_change");

	self SetZBarrierPieceState( 3, "closed" );

	clientfield::set( "zm_bgb_machine_fx_state", 2 );

	self SetZBarrierPieceState( 1, "opening" );
	while ( self GetZBarrierPieceState( 1 ) == "opening" )
	{
		{wait(.05);};
	}

	self SetZBarrierPieceState( 1, "closing" );
	self SetZBarrierPieceState( 3, "opening" );
	while ( self GetZBarrierPieceState( 1 ) == "closing" )
	{
		{wait(.05);};
	}

	self notify( "arrived" );

	self thread set_bgb_machine_state( "initial" );
}

function bgb_machine_leaves()
{
	self endon("zbarrier_state_change");

	self SetZBarrierPieceState( 3, "open" );

	clientfield::set( "zm_bgb_machine_fx_state", 2 );

	self SetZBarrierPieceState( 1, "opening" );
	while ( self GetZBarrierPieceState( 1 ) == "opening" )
	{
		{wait(.05);};
	}

	self SetZBarrierPieceState( 1, "closing" );
	self SetZBarrierPieceState( 3, "closing" );
	while ( self GetZBarrierPieceState( 1 ) == "closing" )
	{
		{wait(.05);};
	}

	self notify( "left" );

	self thread set_bgb_machine_state( "away" );
}

function bgb_machine_opens()
{
	self endon("zbarrier_state_change");

	self SetZBarrierPieceState( 3, "open" );
	self SetZBarrierPieceState( 5, "closed" );

	// if bgb is not available, set the ghost ball visual
	clientfield::set( "zm_bgb_machine_ghost_ball", !self.b_bgb_is_available );

	state = "opening";
	if ( math::cointoss() )
	{
		state = "closing";
	}
	self SetZBarrierPieceState( 4, state );
	while ( self GetZBarrierPieceState( 4 ) == state )
	{
		{wait(.05);};
	}

	self SetZBarrierPieceState( 2, "opening" );

	wait( 1 );

	clientfield::set( "zm_bgb_machine_fx_state", 3 );

	self notify( "gumball_available" );

	wait( 5.5 );

	clientfield::set( "zm_bgb_machine_fx_state", 4 );

	self thread zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );
	while ( self GetZBarrierPieceState( 2 ) == "opening" )
	{
		{wait(.05);};
	}
	self notify( "trigger", level );  
}

function bgb_machine_closes()
{
	self endon("zbarrier_state_change");

	self SetZBarrierPieceState( 3, "open" );
	self SetZBarrierPieceState( 5, "closed" );

	clientfield::set( "zm_bgb_machine_fx_state", 4 );

	self SetZBarrierPieceState( 2, "closing" );
	while ( self GetZBarrierPieceState( 2 ) == "closing" )
	{
		{wait(.05);};
	}
	self notify( "closed" );
}

function is_bgb_machine_active()
{
	curr_state = self get_bgb_machine_state();
	
	if ( curr_state == "open" || curr_state == "close" )
	{
		return true;
	}
	
	return false;
}

function get_bgb_machine_state()
{
	return self.state;
}

function set_bgb_machine_state( state )
{
	for ( i = 0; i < self GetNumZBarrierPieces(); i++ )
	{
		self HideZBarrierPiece( i );
	}
	self notify( "zbarrier_state_change" );
	
	self [[level.bgb_machine_state_func]]( state );
}

function process_bgb_machine_state( state )
{
	switch ( state )
	{
		case "away":
			self ShowZBarrierPiece( 0 );
			self ShowZBarrierPiece( 5 );
			self thread bgb_machine_lion_twitches();
			self.state = "away";
			break;
		case "arriving":
			self ShowZBarrierPiece( 1 );
			self ShowZBarrierPiece( 3 );
			self thread bgb_machine_arrives();
			self.state = "arriving";
			break;
		case "initial":
			self ShowZBarrierPiece( 2 );
			self ShowZBarrierPiece( 3 );
			self ShowZBarrierPiece( 5 );
			self thread bgb_machine_initial();
			self thread zm_unitrigger::register_static_unitrigger( self.unitrigger_stub, &bgb_machine_unitrigger_think );
			self.state = "initial";
			break;
		case "open":
			self ShowZBarrierPiece( 2 );
			self ShowZBarrierPiece( 3 );
			self ShowZBarrierPiece( 4 );
			self ShowZBarrierPiece( 5 );
			self thread bgb_machine_opens();
			self.state = "open";
			break;
		case "close":
			self ShowZBarrierPiece( 2 );
			self ShowZBarrierPiece( 3 );
			self ShowZBarrierPiece( 5 );
			self thread bgb_machine_closes();
			self.state = "close";
			break;
		case "leaving":
			self ShowZBarrierPiece( 1 );
			self ShowZBarrierPiece( 3 );
			self thread bgb_machine_leaves();
			self.state = "leaving";
			break;
		default:
			if( IsDefined( level.custom_bgb_machine_state_handler ) )
			{
				self [[ level.custom_bgb_machine_state_handler ]]( state );
			}
			break;
	}
}

function bgb_machine_host_migration()
{
	level endon( "end_game" );
	
	level notify( "bgb_machine_host_migration" );
	level endon( "bgb_machine_host_migration" );
		
	while(1)
	{
		level waittill( "host_migration_end" );
		
		if ( !IsDefined( level.bgb_machines ) )
			continue;

		foreach ( bgb_machine in level.bgb_machines ) 
		{
			if ( !( isdefined( bgb_machine.hidden ) && bgb_machine.hidden ) ) 
			{
//				if ( IsDefined( bgb_machine ) && IsDefined( bgb_machine.pandora_light ) )
//				{
//					playfxontag( level._effect["lght_marker"], bgb_machine.pandora_light, "tag_origin" );
//				}
			}
			util::wait_network_frame();
		}
	}
}

