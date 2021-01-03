#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_announcer;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                                                                       	                                
                                                                                                                               

#precache( "fx", "zombie/fx_weapon_box_marker_zmb" );
#precache( "fx", "zombie/fx_weapon_box_marker_fl_zmb" );
#precache( "fx", "zombie/fx_barrier_buy_zmb" );

#namespace zm_magicbox;

function autoexec __init__sytem__() {     system::register("zm_magicbox",&__init__,&__main__,undefined);    }

function __init__()
{
	level.start_chest_name = "start_chest";

	level._effect["lght_marker"] 										= "zombie/fx_weapon_box_marker_zmb";
	level._effect["lght_marker_flare"] 							= "zombie/fx_weapon_box_marker_fl_zmb";
	level._effect["poltergeist"]										= "zombie/fx_barrier_buy_zmb";

	clientfield::register( "zbarrier", "magicbox_open_glow", 1, 1, "int" );
	clientfield::register( "zbarrier", "magicbox_closed_glow", 1, 1, "int" );
	
	clientfield::register( "zbarrier", "zbarrier_show_sounds", 1, 1, "counter");
	clientfield::register( "zbarrier", "zbarrier_leave_sounds", 1, 1, "counter");	
	
	level thread magicbox_host_migration();
}

function __main__()
{
	// Set values that may be overwritten by level specific scripts
	if( !IsDefined( level.chest_joker_model ) )
	{
		level.chest_joker_model = "p7_zm_teddybear";
	}
	
	if( !IsDefined( level.magic_box_zbarrier_state_func ) )
	{
		level.magic_box_zbarrier_state_func = &process_magic_box_zbarrier_state;
	}
	
	if (!IsDefined(level.magic_box_check_equipment))
		level.magic_box_check_equipment =  &default_magic_box_check_equipment;	

	wait(0.05);//wait for initialization stage to end so we can toggle client fields

	if ( zm_utility::is_Classic() )
	{
		level.chests = struct::get_array( "treasure_chest_use", "targetname" );
		treasure_chest_init( level.start_chest_name );
	}
}

// for the random weapon chest
//
//	The chests need to be setup as follows:
//		trigger_use - for the chest
//			targets the lid
//		lid - script_model.  Flips open to reveal the items
//			targets the script origin inside the box
//		script_origin - inside the box, used for spawning the weapons
//			targets the box
//		box - script_model of the outer casing of the chest
//		rubble - pieces that show when the box isn't there
//			script_noteworthy should be the same as the use_trigger + "_rubble"
//
function treasure_chest_init( start_chest_name )
{
	level flag::init("moving_chest_enabled");
	level flag::init("moving_chest_now");
	level flag::init("chest_has_been_used");
	
	level.chest_moves = 0;
	level.chest_level = 0;	// Level 0 = normal chest, 1 = upgraded chest
	//level.chests = GetEntArray( "treasure_chest_use", "targetname" );

	//level.chests = struct::get_array( "treasure_chest_use", "targetname" );		

	if( level.chests.size==0 )
		return;
	
	for (i=0; i<level.chests.size; i++ )
	{
		level.chests[i].box_hacks = [];
		
		level.chests[i].orig_origin = level.chests[i].origin;
		level.chests[i] get_chest_pieces();

		if ( isDefined( level.chests[i].zombie_cost ) )
		{
			level.chests[i].old_cost = level.chests[i].zombie_cost;
		}
		else
		{
			// default chest cost
			level.chests[i].old_cost = 950;
		}
	}

	if(!level.enable_magic)
	{
		foreach(chest in level.chests)
		{
			chest hide_chest();
		}
		return;
	}
	
	level.chest_accessed = 0;

	if (level.chests.size > 1)
	{
		level flag::set("moving_chest_enabled");
	
		level.chests = array::randomize(level.chests);

		//determine magic box starting location at random or normal
		//init_starting_chest_location();
	}
	else
	{
		level.chest_index = 0;
		level.chests[0].no_fly_away = true;
	}
	
	//determine magic box starting location at random or normal
	init_starting_chest_location( start_chest_name );

	array::thread_all( level.chests, &treasure_chest_think );
}

function init_starting_chest_location( start_chest_name )
{
	level.chest_index = 0;
	start_chest_found = false;
	
	if( level.chests.size==1 )
	{
		//Only 1 chest in the map
		start_chest_found = true;
		
		if(isdefined(level.chests[level.chest_index].zbarrier))
		{
			level.chests[level.chest_index].zbarrier set_magic_box_zbarrier_state("initial");
		}
	}
	else
	{
		for( i = 0; i < level.chests.size; i++ )
		{
			if( isdefined( level.random_pandora_box_start ) && level.random_pandora_box_start == true )
			{
				//start_exclude is a KVP, just need to add start_exclude 1 to the box script struct to exclude it from the initial random box selection
				if ( start_chest_found || (IsDefined( level.chests[i].start_exclude ) && level.chests[i].start_exclude == 1) )
				{
					level.chests[i] hide_chest();	
				}
				else
				{
					level.chest_index = i;
					level.chests[level.chest_index].hidden = false;
					if(isdefined(level.chests[level.chest_index].zbarrier))
					{
						level.chests[level.chest_index].zbarrier set_magic_box_zbarrier_state("initial");
					}					
					start_chest_found = true;
				}

			}
			else
			{
				// Semi-random implementation (not completely random).  The list is randomized
				//	prior to getting here.
				// Pick from any box marked as the "start_chest"
				if ( start_chest_found || !IsDefined(level.chests[i].script_noteworthy ) || ( !IsSubStr( level.chests[i].script_noteworthy, start_chest_name ) ) )
				{
					level.chests[i] hide_chest();	
				}
				else
				{
					level.chest_index = i;
					level.chests[level.chest_index].hidden = false;
					if(isdefined(level.chests[level.chest_index].zbarrier))
					{
						level.chests[level.chest_index].zbarrier set_magic_box_zbarrier_state("initial");
					}					
					start_chest_found = true;
				}
			}
		}
	}

	// Show the beacon
	if( !isDefined( level.pandora_show_func ) )
	{
		level.pandora_show_func = &default_pandora_show_func;
	}

	level.chests[level.chest_index] thread [[ level.pandora_show_func ]]();
}

function set_treasure_chest_cost( cost )
{
	level.zombie_treasure_chest_cost = cost;
}

//
//	Save off the references to all of the chest pieces
//		self = trigger
function get_chest_pieces()
{
	//self.chest_lid		= GetEnt(self.target,				"targetname");
	//self.chest_origin	= GetEnt(self.chest_lid.target,		"targetname");

//	println( "***** LOOKING FOR:  " + self.chest_origin.target );

	self.chest_box = GetEnt( self.script_noteworthy + "_zbarrier", "script_noteworthy" ); // Needed for zm_hackables_box for Moon port

	//TODO fix temp hax to separate multiple instances
	self.chest_rubble	= [];
	rubble = GetEntArray( self.script_noteworthy + "_rubble", "script_noteworthy" );
	for ( i=0; i<rubble.size; i++ )
	{
		if ( DistanceSquared( self.origin, rubble[i].origin ) < 10000 )
		{
			self.chest_rubble[ self.chest_rubble.size ]	= rubble[i];
		}
	}
	
	self.zbarrier = GetEnt(self.script_noteworthy + "_zbarrier", "script_noteworthy");
	if(isdefined(self.zbarrier))
	{
		self.zbarrier ZBarrierPieceUseBoxRiseLogic(3);
		self.zbarrier ZBarrierPieceUseBoxRiseLogic(4);
	}
	
	self.unitrigger_stub = spawnstruct();
	self.unitrigger_stub.origin = self.origin + (anglestoright(self.angles) * -22.5);
	self.unitrigger_stub.angles = self.angles;
	self.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	self.unitrigger_stub.script_width = 104;
	self.unitrigger_stub.script_height = 50;
	self.unitrigger_stub.script_length = 45;
	self.unitrigger_stub.trigger_target = self;
	zm_unitrigger::unitrigger_force_per_player_triggers(self.unitrigger_stub, true);
	self.unitrigger_stub.prompt_and_visibility_func = &boxtrigger_update_prompt;
	self.zbarrier.owner = self;
	
}

function boxtrigger_update_prompt( player )
{
	can_use = self boxstub_update_prompt( player );
	if(isdefined(self.hint_string))
	{
		if (IsDefined(self.hint_parm1))
			self SetHintString( self.hint_string, self.hint_parm1 );
		else
			self SetHintString( self.hint_string );
	}
	return can_use;
}

function boxstub_update_prompt( player )
{
	//self setCursorHint( "HINT_NOICON" );

	if (!self trigger_visible_to_player( player ))
		return false;

	self.hint_parm1 = undefined;
	if(( isdefined( self.stub.trigger_target.grab_weapon_hint ) && self.stub.trigger_target.grab_weapon_hint ))
	{
		cursor_hint = "HINT_WEAPON";
		cursor_hint_weapon = self.stub.trigger_target.grab_weapon;
		self setCursorHint( cursor_hint, cursor_hint_weapon ); 
		if (IsDefined(level.magic_box_check_equipment) && [[level.magic_box_check_equipment]]( cursor_hint_weapon ) )
			self.hint_string = &"ZOMBIE_TRADE_EQUIP_FILL"; 
		else
			self.hint_string = &"ZOMBIE_TRADE_WEAPON_FILL"; 
	}
	else
	{
		self setCursorHint( "HINT_NOICON" );
		self.hint_parm1 = self.stub.trigger_target.zombie_cost; 
		self.hint_string = zm_utility::get_hint_string( self, "default_treasure_chest" );
	}
	return true;
} 

function default_magic_box_check_equipment( weapon )
{
	return zm_utility::is_offhand_weapon( weapon );
}


function trigger_visible_to_player(player)
{
	self SetInvisibleToPlayer(player);

	visible = true;	
	
	if(IsDefined(self.stub.trigger_target.chest_user) && !IsDefined(self.stub.trigger_target.box_rerespun))
	{
		if( player != self.stub.trigger_target.chest_user || zm_utility::is_placeable_mine( self.stub.trigger_target.chest_user GetCurrentWeapon() ) || self.stub.trigger_target.chest_user zm_equipment::hacker_active())
		{
			visible = false;
		}
	}	
	else
	{
		if( !player can_buy_weapon())
		{
			visible = false;
		}
	}
	
	
	if(!visible)
	{
		return false;
	}
	
	self SetVisibleToPlayer(player);
	return true;
}

function magicbox_unitrigger_think()
{
	self endon("kill_trigger");

	while ( 1 )
	{
		self waittill( "trigger", player );
		self.stub.trigger_target notify("trigger", player);
	}
}

function play_crazi_sound()
{
	self playlocalsound( level.zmb_laugh_alias );
}

//
//	Show the chest pieces
//		self = chest use_trigger
//
function show_chest()
{
	self.zbarrier set_magic_box_zbarrier_state("arriving");
	self.zbarrier waittill("arrived");
	
	self thread [[ level.pandora_show_func ]]();

	self.zbarrier clientfield::set( "magicbox_closed_glow", true );

	//self TriggerEnable( true );
	thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &magicbox_unitrigger_think);

	self.zbarrier clientfield::increment("zbarrier_show_sounds" );

	self.hidden = false;

	if(IsDefined(self.box_hacks["summon_box"]))
	{
		self [[self.box_hacks["summon_box"]]](false);
	}
	
}

function hide_chest(doBoxLeave)
{
	//self TriggerEnable( false );
	if(isDefined(self.unitrigger_stub))
	{
		thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	}
	if ( IsDefined( self.pandora_light ) )
	{
		self.pandora_light delete();
	}

	self.zbarrier clientfield::set( "magicbox_closed_glow", false );
	
	self.hidden = true;
	
	if(isDefined(self.box_hacks) && IsDefined(self.box_hacks["summon_box"]))
	{
		self [[self.box_hacks["summon_box"]]](true);
	}
	
	if(isdefined(self.zbarrier))
	{
		if(( isdefined( doBoxLeave ) && doBoxLeave ))
		{
			self.zbarrier clientfield::increment("zbarrier_leave_sounds" );
			
			level thread zm_audio::sndAnnouncerPlayVox("boxmove");

			self.zbarrier thread magic_box_zbarrier_leave();
			self.zbarrier waittill("left");
			
			playfx( level._effect["poltergeist"], self.zbarrier.origin, AnglesToUp( self.zbarrier.angles ), AnglesToForward( self.zbarrier.angles ) );  // effect has X facing up, Z facing forward
	
			//TUEY - Play the 'disappear' sound
			playsoundatposition ("zmb_box_poof", self.zbarrier.origin);
		}
		else
		{
			self.zbarrier thread set_magic_box_zbarrier_state("away");			
		}
	}	
}

function magic_box_zbarrier_leave()
{
	self set_magic_box_zbarrier_state("leaving");
	self waittill("left");
	self set_magic_box_zbarrier_state("away");
}

function default_pandora_fx_func( )
{
	self endon( "death" );

	self.pandora_light = Spawn( "script_model", self.zbarrier.origin );
	self.pandora_light.angles = self.zbarrier.angles + (-90, 0, -90);
	//	level.pandora_light.angles = (-90, anchorTarget.angles[1] + 180, 0);
	self.pandora_light SetModel( "tag_origin" );
	if(!( isdefined( level._box_initialized ) && level._box_initialized ))
	{
		level flag::wait_till("start_zombie_round_logic");
		level._box_initialized = true;
	}
	wait(1);
	if ( IsDefined( self ) && IsDefined( self.pandora_light ) )
	{
		playfxontag(level._effect["lght_marker"], self.pandora_light, "tag_origin");
	}

}


//
//	Show a column of light
//
function default_pandora_show_func( anchor, anchorTarget, pieces )
{
	
	if ( !IsDefined(self.pandora_light) )
	{
		// Show the column light effect on the box
		if( !IsDefined( level.pandora_fx_func ) )
		{
			level.pandora_fx_func = &default_pandora_fx_func;
		}
		self thread [[ level.pandora_fx_func ]]();
	}

	playfx( level._effect["lght_marker_flare"],self.pandora_light.origin );
	
	//Add this location to the map
	//Objective_Add( 0, "active", "Mystery Box", self.chest_lid.origin, "minimap_icon_mystery_box" );
}

function unregister_unitrigger_on_kill_think()
{
	self notify( "unregister_unitrigger_on_kill_think" );
	self endon( "unregister_unitrigger_on_kill_think" );
	
	self waittill("kill_chest_think");
	thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	
}

function treasure_chest_think()
{
	self endon("kill_chest_think");
	// waittill someuses uses this
	user = undefined;
	user_cost = undefined;
	self.box_rerespun = undefined;
	self.weapon_out = undefined;
	
	self thread unregister_unitrigger_on_kill_think();
	
	while( 1 )
	{
		if(!IsDefined(self.forced_user))
		{
			self waittill( "trigger", user ); 
			if (user == level)
				continue;
		}
		else
		{
			user = self.forced_user;
		}
		
		if( user zm_utility::in_revive_trigger() )
		{
			wait( 0.1 );
			continue;
		}
		
		if( ( user.is_drinking > 0 ) )
		{
			wait( 0.1 );
			continue;
		}

		if ( ( isdefined( self.disabled ) && self.disabled ) )
		{
			wait( 0.1 );
			continue;
		}

		if( user GetCurrentWeapon() == level.weaponNone )
		{
			wait( 0.1 );
			continue;
		}

		// If the player has the double points persistent upgrade, reduce the COST
		reduced_cost = undefined;
		if( zm_utility::is_player_valid(user) && (user zm_pers_upgrades_functions::is_pers_double_points_active()) )
		{
			reduced_cost = int( self.zombie_cost / 2 );
		}
		
		// Make sure the user is a player, and that they can afford it
		if( IsDefined(self.auto_open) && zm_utility::is_player_valid( user ) )
		{
			if(!IsDefined(self.no_charge))
			{
				user  zm_score::minus_to_player_score( self.zombie_cost );
				user_cost = self.zombie_cost; 
			}
			else
			{
				user_cost = 0;
			}			
			
			self.chest_user = user;
			break;
		}
		// Do we have enough money to use the box?
		else if( zm_utility::is_player_valid( user ) && user.score >= self.zombie_cost )
		{
			user  zm_score::minus_to_player_score( self.zombie_cost );
			user_cost = self.zombie_cost; 
			self.chest_user = user;
			break; 
		}
		// Has the box cost been reduced?
		else if( IsDefined(reduced_cost) && (user.score >= reduced_cost) )
		{
			user  zm_score::minus_to_player_score( reduced_cost );
			user_cost = reduced_cost;
			self.chest_user = user;
			break; 
		}
		// Can't afford the box purchase
		else if ( user.score < self.zombie_cost )
		{
			zm_utility::play_sound_at_pos( "no_purchase", self.origin );
			user  zm_audio::create_and_play_dialog( "general", "outofmoney" );
			continue;	
		}

		{wait(.05);}; 
	}

	level flag::set("chest_has_been_used");
	
	//stat tracking
	demo::bookmark( "zm_player_use_magicbox", gettime(), user );
	user zm_stats::increment_client_stat( "use_magicbox" );
	user zm_stats::increment_player_stat( "use_magicbox" );
	
	if ( isDefined( level._magic_box_used_VO ) )
	{
		user thread [[ level._magic_box_used_VO ]]();
	}
	
	self thread watch_for_emp_close();
	
	self._box_open = true;
	self._box_opened_by_fire_sale = false;
	if ( ( isdefined( level.zombie_vars["zombie_powerup_fire_sale_on"] ) && level.zombie_vars["zombie_powerup_fire_sale_on"] ) && !IsDefined(self.auto_open) && self [[level._zombiemode_check_firesale_loc_valid_func]]())
	{
		self._box_opened_by_fire_sale = true;
	}

	//open the lid
	if(isdefined(self.chest_lid))
	{
		self.chest_lid thread treasure_chest_lid_open();
	}

	if(isdefined(self.zbarrier))
	{
		zm_utility::play_sound_at_pos( "open_chest", self.origin );
		zm_utility::play_sound_at_pos( "music_chest", self.origin );
		self.zbarrier set_magic_box_zbarrier_state("open");
	}
	
	// SRS 9/3/2008: added to help other functions know if we timed out on grabbing the item
	self.timedOut = false;

	// mario kart style weapon spawning
	self.weapon_out = true;
	self.zbarrier thread treasure_chest_weapon_spawn( self, user ); 

	// the glowfx	
	self.zbarrier thread treasure_chest_glowfx(); 

	// take away usability until model is done randomizing
	//self TriggerEnable( false ); 
	thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);

	self.zbarrier util::waittill_any( "randomization_done", "box_hacked_respin" ); 

	// refund money from teddy.
	if ( level flag::get( "moving_chest_now" ) && !self._box_opened_by_fire_sale && isdefined( user_cost ) )
	{
		user zm_score::add_to_player_score( user_cost, false );
	}

	if ( level flag::get( "moving_chest_now" ) && !level.zombie_vars[ "zombie_powerup_fire_sale_on" ] && !self._box_opened_by_fire_sale )
	{
		//CA AUDIO: 01/12/10 - Changed dialog to use correct function
		//self.chest_user zm_audio::create_and_play_dialog( "general", "box_move" );
		self thread treasure_chest_move( self.chest_user );
	}
	else
	{
		// Let the player grab the weapon and re-enable the box //
		self.grab_weapon_hint = true;
		self.grab_weapon = self.zbarrier.weapon;
		self.chest_user = user;

		// Limit its visibility to the player who bought the box
		//self TriggerEnable( true ); 
		thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &magicbox_unitrigger_think);
		
		if( isDefined(self.zbarrier) && !( isdefined( self.zbarrier.closed_by_emp ) && self.zbarrier.closed_by_emp ) )
		{
			self thread treasure_chest_timeout();
		}

		// make sure the guy that spent the money gets the item
		// SRS 9/3/2008: ...or item goes back into the box if we time out
		while( !( isdefined( self.closed_by_emp ) && self.closed_by_emp ) )
		{
			self waittill( "trigger", grabber );
			self.weapon_out = undefined;

			if ( ( isdefined( level.magic_box_grab_by_anyone ) && level.magic_box_grab_by_anyone ) )
			{
				if( IsPlayer(grabber) )
				{
					user = grabber;
				}
			}

			// Is the persistent player upgrade "box weapon" available?
			if( ( isdefined( level.pers_upgrade_box_weapon ) && level.pers_upgrade_box_weapon ) )
			{
				self zm_pers_upgrades_functions::pers_upgrade_box_weapon_used( user, grabber );
			}

			if( IsDefined( grabber.is_drinking ) && ( grabber.is_drinking > 0 ) )
			{
				wait( 0.1 );
				continue;
			}

			if ( grabber == user && user GetCurrentWeapon() == level.weaponNone )
			{
				wait( 0.1 );
				continue;
			}

			if(grabber != level && (IsDefined(self.box_rerespun) && self.box_rerespun))
			{
				user = grabber;
			}
			
			if( grabber == user || grabber == level )			
			{
				self.box_rerespun = undefined;
				current_weapon = level.weaponNone;
				
				if(zm_utility::is_player_valid(user))
				{
					current_weapon = user GetCurrentWeapon();
				}
				
				if( grabber == user && zm_utility::is_player_valid( user ) && !( user.is_drinking > 0 ) && !zm_utility::is_placeable_mine( current_weapon ) && !zm_equipment::is_equipment( current_weapon ) && level.weaponReviveTool != current_weapon )
				{
					self notify( "user_grabbed_weapon" );
					user notify( "user_grabbed_weapon" );
					user thread treasure_chest_give_weapon( self.zbarrier.weapon );
					
					demo::bookmark( "zm_player_grabbed_magicbox", gettime(), user );
					
					//stat tracking
					user zm_stats::increment_client_stat( "grabbed_from_magicbox" );
					user zm_stats::increment_player_stat( "grabbed_from_magicbox" );

					break; 
				}
				else if( grabber == level )
				{
					// it timed out
					self.timedOut = true;
					break;
				}
			}

			{wait(.05);}; 
		}

		self.grab_weapon_hint = false;
		self.zbarrier notify( "weapon_grabbed" );

		if ( !( isdefined( self._box_opened_by_fire_sale ) && self._box_opened_by_fire_sale ) )
		{
			//increase counter of amount of time weapon grabbed, but not during a fire sale
			level.chest_accessed += 1;
		}

		//self TriggerEnable( false );
		thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);

		// spend cash here...
		// give weapon here...
		if(isdefined(self.chest_lid))
		{
			self.chest_lid thread treasure_chest_lid_close( self.timedOut );
		}

		if(isdefined(self.zbarrier))
		{
			self.zbarrier set_magic_box_zbarrier_state("close");
			zm_utility::play_sound_at_pos( "close_chest", self.origin );
			self.zbarrier waittill("closed");
			
			wait 1;
		}
		else
		{
			wait 3.0;
		}
		
		// Magic box dissapears and moves to a new spot after a predetermined number of uses
		if ( (( isdefined( level.zombie_vars["zombie_powerup_fire_sale_on"] ) && level.zombie_vars["zombie_powerup_fire_sale_on"] ) && self [[level._zombiemode_check_firesale_loc_valid_func]]()) || self == level.chests[level.chest_index] )
		{
			//self TriggerEnable( true );
			thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &magicbox_unitrigger_think);
			
//			self setvisibletoall();
		}
	}

	self._box_open = false;
	self._box_opened_by_fire_sale = false;
	self.chest_user = undefined;
	
	self notify( "chest_accessed" );
	
	self thread treasure_chest_think();
}

function watch_for_emp_close()
{
	self endon( "chest_accessed" );
	self.closed_by_emp = 0;
	if (!zm_utility::should_watch_for_emp())
		return;
	if(isDefined(self.zbarrier))
	{
		self.zbarrier.closed_by_emp = 0;
	}
	
	while (1)
	{
		level waittill("emp_detonate",origin,radius);
		if ( DistanceSquared( origin, self.origin) < radius * radius )
		{
			break;
		}
	}
	
	if (level flag::get("moving_chest_now"))
		return;
	
	// kill the threads
	self.closed_by_emp = 1;
	if(isdefined(self.zbarrier))
	{
		self.zbarrier.closed_by_emp = 1;
		self.zbarrier notify("box_hacked_respin");	
		if(isDefined(self.zbarrier.weapon_model))
		{
			self.zbarrier.weapon_model notify("kill_weapon_movement");
		}
		if(IsDefined(self.zbarrier.weapon_model_dw))
		{
			self.zbarrier.weapon_model_dw notify("kill_weapon_movement");
		}
	}
	
	wait 0.1;	
	
	self notify( "trigger", level );
}
	

function can_buy_weapon()
{
	if( IsDefined( self.is_drinking ) && ( self.is_drinking > 0 ) )
	{
		return false;
	}

	if(self zm_equipment::hacker_active())
	{
		return false;
	}
	
	current_weapon = self GetCurrentWeapon();
	if( zm_utility::is_placeable_mine( current_weapon ) || zm_equipment::is_equipment_that_blocks_purchase( current_weapon ) )
	{
		return false;
	}
	if( self zm_utility::in_revive_trigger() )
	{
		return false;
	}
	
	if( current_weapon == level.weaponNone )
	{
		return false;
	}

	/*if ( current_weapon.isheroweapon )
	{
		return false;
	}*/

	return true;
}

function default_box_move_logic()
{
	// Check to see if there's a chest selection we should use for this move
	// This is indicated by a script_noteworthy of "moveX*"
	//	(e.g. move1_chest0, move1_chest1)  We will randomly choose between 
	//		one of those two chests for that move number only.
	index = -1;
	for ( i=0; i<level.chests.size; i++ )
	{
		// Check to see if there is something that we have a choice to move to for this move number
		if ( IsSubStr( level.chests[i].script_noteworthy, ("move"+(level.chest_moves+1)) ) &&
			 i != level.chest_index )
		{
			index = i;
			break;
		}
	}

	if ( index != -1 )
	{
		level.chest_index = index;
	}
	else
	{
		level.chest_index++;
	}

	if (level.chest_index >= level.chests.size)
	{
		//PI CHANGE - this way the chests won't move in the same order the second time around
		temp_chest_name = level.chests[level.chest_index - 1].script_noteworthy;
		level.chest_index = 0;
		level.chests = array::randomize(level.chests);
		//in case it happens to randomize in such a way that the chest_index now points to the same location
		// JMA - want to avoid an infinite loop, so we use an if statement
		if (temp_chest_name == level.chests[level.chest_index].script_noteworthy)
		{
			level.chest_index++;
		}
		//END PI CHANGE
	}
}

//
//	Chest movement sequence, including lifting the box up and disappearing
//
function treasure_chest_move( player_vox )
{
	level waittill("weapon_fly_away_start");

	players = GetPlayers();
	
	array::thread_all(players, &play_crazi_sound);
	
	//Delaying the Player Vox
	if( IsDefined( player_vox ) )
    {    
		player_vox util::delay( randomintrange(2,7), undefined, &zm_audio::create_and_play_dialog, "general", "box_move"  );
    }	
	
	level waittill("weapon_fly_away_end");

	if(isdefined(self.zbarrier))
	{
		self hide_chest(true);
	}

	wait(0.1);
	
	post_selection_wait_duration = 7;	

	// DCS 072710: check if fire sale went into effect during move, reset with time left.
	if(level.zombie_vars["zombie_powerup_fire_sale_on"] == true && self [[level._zombiemode_check_firesale_loc_valid_func]]())
	{
		current_sale_time = level.zombie_vars["zombie_powerup_fire_sale_time"];
		//IPrintLnBold("need to reset this box spot! Time left is ", current_sale_time);

		util::wait_network_frame();				
		self thread fire_sale_fix();
		level.zombie_vars["zombie_powerup_fire_sale_time"] = current_sale_time;

		while(level.zombie_vars["zombie_powerup_fire_sale_time"] > 0)
		{
			wait(0.1);
		}	
	}	
	else
	{
		post_selection_wait_duration += 5;
	}
	level.verify_chest = false;


	if(IsDefined(level._zombiemode_custom_box_move_logic))
	{
		[[level._zombiemode_custom_box_move_logic]]();
	}
	else
	{
		default_box_move_logic();
	}

	if(IsDefined(level.chests[level.chest_index].box_hacks["summon_box"]))
	{
		level.chests[level.chest_index] [[level.chests[level.chest_index].box_hacks["summon_box"]]](false);
	}

	// Now choose a new location

	//wait for all the chests to reset 
	wait(post_selection_wait_duration);
		
	playfx(level._effect["poltergeist"], level.chests[level.chest_index].zbarrier.origin, AnglesToUp( level.chests[level.chest_index].zbarrier.angles ), AnglesToForward( level.chests[level.chest_index].zbarrier.angles ));
	level.chests[level.chest_index] show_chest();
	
	level flag::clear("moving_chest_now");
	self.zbarrier.chest_moving = false;
}


function fire_sale_fix()
{
	if( !isdefined ( level.zombie_vars["zombie_powerup_fire_sale_on"] ) )
	{
		return;
	}

	if( level.zombie_vars["zombie_powerup_fire_sale_on"] )
	{
		self.old_cost = 950;
		self thread show_chest();
		self.zombie_cost = 10;
		self.unitrigger_stub zm_utility::unitrigger_set_hint_string( self , "default_treasure_chest", self.zombie_cost );

		util::wait_network_frame();

		level waittill( "fire_sale_off" );
		
		while(( isdefined( self._box_open ) && self._box_open ))
		{
			wait(.1);
		}		

		self hide_chest(true);
	
		self.zombie_cost = self.old_cost;
	}
}

function check_for_desirable_chest_location()
{
	if( !isdefined( level.desirable_chest_location ) )
		return level.chest_index;

	if( level.chests[level.chest_index].script_noteworthy == level.desirable_chest_location )
	{
		level.desirable_chest_location = undefined;
		return level.chest_index;
	}
	for(i = 0 ; i < level.chests.size; i++ )
	{
		if( level.chests[i].script_noteworthy == level.desirable_chest_location )
		{
			level.desirable_chest_location = undefined;
			return i;
		}
	}

	/#
		iprintln(level.desirable_chest_location + " is an invalid box location!");
#/
	level.desirable_chest_location = undefined;
	return level.chest_index;
}


function rotateroll_box()
{
	angles = 40;
	angles2 = 0;
	//self endon("movedone");
	while(isdefined(self))
	{
		self RotateRoll(angles + angles2, 0.5);
		wait(0.7);
		angles2 = 40;
		self RotateRoll(angles * -2, 0.5);
		wait(0.7);
	}
	


}
//verify if that magic box is open to players or not.
function verify_chest_is_open()
{

	//for(i = 0; i < 5; i++)
	//PI CHANGE - altered so that there can be more than 5 valid chest locations
	for (i = 0; i < level.open_chest_location.size; i++)
	{
		if(isdefined(level.open_chest_location[i]))
		{
			if(level.open_chest_location[i] == level.chests[level.chest_index].script_noteworthy)
			{
				level.verify_chest = true;
				return;		
			}
		}

	}

	level.verify_chest = false;


}


function treasure_chest_timeout()
{
	self endon( "user_grabbed_weapon" );
	self.zbarrier endon( "box_hacked_respin" );
	self.zbarrier endon( "box_hacked_rerespin" );

	wait( 12 );
	self notify( "trigger", level );  
}

function treasure_chest_lid_open()
{
	openRoll = 105;
	openTime = 0.5;

	self RotateRoll( 105, openTime, ( openTime * 0.5 ) );

	zm_utility::play_sound_at_pos( "open_chest", self.origin );
	zm_utility::play_sound_at_pos( "music_chest", self.origin );
}

function treasure_chest_lid_close( timedOut )
{
	closeRoll = -105;
	closeTime = 0.5;

	self RotateRoll( closeRoll, closeTime, ( closeTime * 0.5 ) );
	zm_utility::play_sound_at_pos( "close_chest", self.origin );
	
	self notify("lid_closed");
}


function treasure_chest_CanPlayerReceiveWeapon( player, weapon, pap_triggers )
{
	if ( !zm_weapons::get_is_in_box( weapon ) )
	{
		return false;
	}

	if ( IsDefined( player ) && player zm_weapons::has_weapon_or_upgrade( weapon ) )
	{
		return false;
	}

	if ( !zm_weapons::limited_weapon_below_quota( weapon, player, pap_triggers ))
		return false;
	
	if ( !player zm_weapons::player_can_use_content( weapon ) )
		return false;
	
	if(isdefined(level.custom_magic_box_selection_logic))
	{
		if(![[level.custom_magic_box_selection_logic]](weapon, player, pap_triggers))
		{
			return false;
		}
	}

	// enable special level by level weapon checks
	if( IsDefined( player ) && isdefined( level.special_weapon_magicbox_check ) )
	{
		return player [[level.special_weapon_magicbox_check]]( weapon );
	}

	return true;
}

function treasure_chest_ChooseWeightedRandomWeapon( player )
{
	keys = array::randomize( GetArrayKeys( level.zombie_weapons ) );
	if (IsDefined(level.CustomRandomWeaponWeights))
	{
		keys = player [[level.CustomRandomWeaponWeights]](keys); 
	}
/#
	forced_weapon_name = GetDvarString( "scr_force_weapon" );
	forced_weapon = GetWeapon( forced_weapon_name );
	if ( forced_weapon_name != "" && IsDefined( level.zombie_weapons[ forced_weapon ] ) )
	{
		ArrayInsert( keys, forced_weapon, 0 );
	}
#/
	pap_triggers = zm_pap_util::get_triggers();
	for ( i = 0; i < keys.size; i++ )
	{
		if ( treasure_chest_CanPlayerReceiveWeapon( player, keys[i], pap_triggers ) )
		{
			return keys[i];
		}
	}

	return keys[0];
}


function weapon_show_hint_choke()
{
	level._weapon_show_hint_choke = 0;
	
	while(1)
	{
		{wait(.05);};
		level._weapon_show_hint_choke = 0;
	}
}

function decide_hide_show_hint( endon_notify, second_endon_notify, onlyplayer )
{
	self endon("death");
	
	if( isDefined( endon_notify ) )
	{
		self endon( endon_notify );
	}

	if( isDefined( second_endon_notify ))
	{
		self endon( second_endon_notify );
	}
	
	if(!IsDefined(level._weapon_show_hint_choke))
	{
		level thread weapon_show_hint_choke();
	}

	use_choke = false;
	
	if(IsDefined(level._use_choke_weapon_hints) && level._use_choke_weapon_hints == 1)
	{
		use_choke = true;
	}


	while( true )
	{

		last_update = GetTime();

		if(IsDefined(self.chest_user) && !IsDefined(self.box_rerespun))
		{
			if( zm_utility::is_placeable_mine( self.chest_user GetCurrentWeapon() ) || self.chest_user zm_equipment::hacker_active())
			{
				self SetInvisibleToPlayer( self.chest_user);
			}
			else
			{
				self SetVisibleToPlayer( self.chest_user );
			}
		}
		else if (IsDefined(onlyplayer))
		{
			if( onlyplayer can_buy_weapon())
			{
				self SetInvisibleToPlayer( onlyplayer, false );
			}
			else
			{
				self SetInvisibleToPlayer( onlyplayer, true );
			}
		}
		else // all players
		{	
			players = GetPlayers();
			for( i = 0; i < players.size; i++ )
			{
				if( players[i] can_buy_weapon())
				{
					self SetInvisibleToPlayer( players[i], false );
				}
				else
				{
					self SetInvisibleToPlayer( players[i], true );
				}
			}
		}	
		
		if(use_choke)
		{
			while((level._weapon_show_hint_choke > 4) && (GetTime() < (last_update + 150)))
			{
				{wait(.05);};
			}
		}
		else
		{
			wait(0.1);
		}		
		
		level._weapon_show_hint_choke ++;
	}
}

function get_left_hand_weapon_model_name( weapon )
{
	dw_weapon = weapon.dualWieldWeapon;
	if ( dw_weapon != level.weaponNone )
	{
		return dw_weapon.worldModel;
	}

	return weapon.worldModel;
}

function clean_up_hacked_box()
{
	self waittill("box_hacked_respin");
	self endon("box_spin_done");
	
	if(IsDefined(self.weapon_model))
	{
		self.weapon_model Delete();
		self.weapon_model = undefined;
	}

	if(IsDefined(self.weapon_model_dw))
	{
		self.weapon_model_dw Delete();
		self.weapon_model_dw = undefined;
	}
	

	self HideZBarrierPiece(3);
	self HideZBarrierPiece(4);
	self SetZBarrierPieceState(3, "closed");
	self SetZBarrierPieceState(4, "closed");
}

function treasure_chest_weapon_spawn( chest, player, respin )
{
	self endon("box_hacked_respin");
	self thread clean_up_hacked_box();
	assert(IsDefined(player));
	// spawn the model
//	model = spawn( "script_model", self.origin ); 
//	model.angles = self.angles +( 0, 90, 0 );

//	floatHeight = 40;

	//move it up
//	model moveto( model.origin +( 0, 0, floatHeight ), 3, 2, 0.9 ); 

	// rotation would go here

	// make with the mario kart
	const FLOAT_HEIGHT = 40;
	const BOX_MOVE_BEAR_FLYAWAY_DISTANCE = 500;
	const BOX_MOVE_BEAR_FLYAWAY_TIME = 4;
	const BOX_MOVE_BEAR_FLYAWAY_ACCEL = 3;
	self.weapon = level.weaponNone;
	modelname = undefined; 
	rand = undefined; 
	number_cycles = 40;
	
	if(isdefined(chest.zbarrier))
	{
		if ( IsDefined( level.custom_magic_box_do_weapon_rise ) )
		{
			chest.zbarrier thread [[level.custom_magic_box_do_weapon_rise]]();
		}
		else
		{
			chest.zbarrier thread magic_box_do_weapon_rise();
		}
	}
	
	for( i = 0; i < number_cycles; i++ )
	{

		if( i < 20 )
		{
			{wait(.05);}; 
		}
		else if( i < 30 )
		{
			wait( 0.1 ); 
		}
		else if( i < 35 )
		{
			wait( 0.2 ); 
		}
		else if( i < 38 )
		{
			wait( 0.3 ); 
		}
	}

	if ( IsDefined( level.custom_magic_box_weapon_wait ) )
	{
		[[level.custom_magic_box_weapon_wait]](); // wait to match up with any waits in the custom weapon rise
	}

	//**********************************
	// Pick a random weapon from the box
	//**********************************
	
	// Does the player have the box persistent ability active?
	if( ( isdefined( player.pers_upgrades_awarded["box_weapon"] ) && player.pers_upgrades_awarded["box_weapon"] ) )
	{
		rand = zm_pers_upgrades_functions::pers_treasure_chest_ChooseSpecialWeapon( player );
	}
	//  Pick a random weapon
	else
	{
		rand = treasure_chest_ChooseWeightedRandomWeapon( player );
	}

	// forcing box weapons from the devgui is now handled in treasure_chest_ChooseWeightedRandomWeapon
	// this allows us to test box weapon filtering. 
	// if you need to give yourself a weapon without filtering you can use 
	//   set zombie_devgui_gun gunyouwant_zm
	
	// Here's where the org get it's weapon type for the give function
	self.weapon = rand; 
	
	//util::wait_network_frame();
	wait( 0.1 );

	// get offset for floating weapon
	if ( IsDefined( level.custom_magicbox_float_height ) )
	{
		v_float = AnglesToUp( self.angles ) * level.custom_magicbox_float_height;
	}
	else
	{
		v_float = AnglesToUp( self.angles ) * FLOAT_HEIGHT;  // draw vector straight up with reference to the mystery box angles
	}

	self.model_dw = undefined;

	self.weapon_model = zm_utility::spawn_weapon_model( rand, undefined, self.origin + v_float, (-self.angles[0], self.angles[1] + 180, -self.angles[2]));

	if ( rand.isDualWield )
	{
		self.weapon_model_dw = zm_utility::spawn_weapon_model( rand, get_left_hand_weapon_model_name( rand ), self.weapon_model.origin - ( 3, 3, 3 ), self.weapon_model.angles ); 
	}

	// Increase the chance of joker appearing from 0-100 based on amount of the time chest has been opened.
	if( (GetDvarString( "magic_chest_movable") == "1") && !( isdefined( chest._box_opened_by_fire_sale ) && chest._box_opened_by_fire_sale ) && !(( isdefined( level.zombie_vars["zombie_powerup_fire_sale_on"] ) && level.zombie_vars["zombie_powerup_fire_sale_on"] ) && self [[level._zombiemode_check_firesale_loc_valid_func]]()) )
	{
		// random change of getting the joker that moves the box
		random = Randomint(100);

		if( !isdefined( level.chest_min_move_usage ) )
		{
			level.chest_min_move_usage = 4;
		}

		if( level.chest_accessed < level.chest_min_move_usage )
		{		
			chance_of_joker = -1;
		}
		else
		{
			chance_of_joker = level.chest_accessed + 20;

			// make sure teddy bear appears on the 8th pull if it hasn't moved from the initial spot
			if ( level.chest_moves == 0 && level.chest_accessed >= 8 )
			{
				chance_of_joker = 100;
			}

			// pulls 4 thru 8, there is a 15% chance of getting the teddy bear
			// NOTE:  this happens in all cases
			if( level.chest_accessed >= 4 && level.chest_accessed < 8 )
			{
				if( random < 15 )
				{
					chance_of_joker = 100;
				}
				else
				{
					chance_of_joker = -1;
				}
			}

			// after the first magic box move the teddy bear percentages changes
			if ( level.chest_moves > 0 )
			{
				// between pulls 8 thru 12, the teddy bear percent is 30%
				if( level.chest_accessed >= 8 && level.chest_accessed < 13 )
				{
					if( random < 30 )
					{
						chance_of_joker = 100;
					}
					else
					{
						chance_of_joker = -1;
					}
				}
				
				// after 12th pull, the teddy bear percent is 50%
				if( level.chest_accessed >= 13 )
				{
					if( random < 50 )
					{
						chance_of_joker = 100;
					}
					else
					{
						chance_of_joker = -1;
					}
				}
			}
		}

		if(IsDefined(chest.no_fly_away))
		{
			chance_of_joker = -1;
		}

		if(IsDefined(level._zombiemode_chest_joker_chance_override_func))
		{
			chance_of_joker = [[level._zombiemode_chest_joker_chance_override_func]](chance_of_joker);
		}

		if ( chance_of_joker > random )
		{
			self.weapon = level.weaponNone;

			self.weapon_model SetModel(level.chest_joker_model);
			//model rotateto(level.chests[level.chest_index].angles, 0.01);
			//wait(1);
			//self.weapon_model.angles = self.angles + ( 0, 90, 0 );
			//self.weapon_model.angles = (-self.angles[2], self.angles[1], self.angles[0]);
			if(IsDefined(self.weapon_model_dw))
			{
				self.weapon_model_dw Delete();
				self.weapon_model_dw = undefined;
			}
			
			self.chest_moving = true;
			level flag::set("moving_chest_now");
			level.chest_accessed = 0;

			//allow power weapon to be accessed.
			level.chest_moves++;
		}
	}

	self notify( "randomization_done" );

	if (level flag::get("moving_chest_now") && !(level.zombie_vars["zombie_powerup_fire_sale_on"] && self [[level._zombiemode_check_firesale_loc_valid_func]]()))
	{
		if( IsDefined( level.chest_joker_custom_movement ) )
		{
			self [[ level.chest_joker_custom_movement ]]();
		}
		else
		{
			wait .5;	// we need a wait here before this notify
			level notify("weapon_fly_away_start");
			wait 2;
			if( IsDefined( self.weapon_model ) )
			{
				v_fly_away = self.origin + ( AnglesToUp( self.angles ) * BOX_MOVE_BEAR_FLYAWAY_DISTANCE );
				self.weapon_model MoveTo( v_fly_away, BOX_MOVE_BEAR_FLYAWAY_TIME, BOX_MOVE_BEAR_FLYAWAY_ACCEL );
			}
			
			if ( IsDefined(self.weapon_model_dw ) )
			{
				v_fly_away = self.origin + ( AnglesToUp( self.angles ) * BOX_MOVE_BEAR_FLYAWAY_DISTANCE );
				self.weapon_model_dw MoveTo( v_fly_away, BOX_MOVE_BEAR_FLYAWAY_TIME, BOX_MOVE_BEAR_FLYAWAY_ACCEL );
			}
			
			self.weapon_model waittill("movedone");
			self.weapon_model delete();
			
			if(IsDefined(self.weapon_model_dw))
			{
				self.weapon_model_dw Delete();
				self.weapon_model_dw = undefined;
			}
			
			self notify( "box_moving" );
			level notify("weapon_fly_away_end");
		}
	}
	else
	{
		if(!IsDefined(respin))
		{
			if(IsDefined(chest.box_hacks["respin"]))
			{
				self [[chest.box_hacks["respin"]]](chest, player);
			}
		}
		else
		{
			if(IsDefined(chest.box_hacks["respin_respin"]))
			{
				self [[chest.box_hacks["respin_respin"]]](chest, player);
			}
		}

		// allow for custom back-into-box movement		
		if(IsDefined(level.custom_magic_box_timer_til_despawn))
		{
			self.weapon_model thread [[level.custom_magic_box_timer_til_despawn]]( self );
		}
		else
		{
			// weapon re-enters box
			self.weapon_model thread timer_til_despawn( v_float );
		}
		
		if(IsDefined(self.weapon_model_dw))
		{
			if(IsDefined(level.custom_magic_box_timer_til_despawn))
			{
				self.weapon_model_dw thread [[level.custom_magic_box_timer_til_despawn]]( self );
			}
			else
			{
				self.weapon_model_dw thread timer_til_despawn( v_float );
			}
		}
		
		self waittill( "weapon_grabbed" );

		if( !chest.timedOut )
		{
			if(IsDefined(self.weapon_model))
			{
				self.weapon_model Delete();
			}
			
			if(IsDefined(self.weapon_model_dw))
			{
				self.weapon_model_dw Delete();
			}
		}
	}

	self.weapon = level.weaponNone;
	self notify("box_spin_done");
}

//
//
function chest_get_min_usage()
{
	min_usage = 4;

	return( min_usage );
}

//
//
function chest_get_max_usage()
{
	max_usage = 6;

	players = GetPlayers();

	// Special case max box pulls before 1st box move
	if( level.chest_moves == 0 )
	{
		if( players.size == 1 )
		{
			max_usage = 3;
		}
		else if( players.size == 2 )
		{
			max_usage = 4;
		}
		else if( players.size == 3 )
		{
			max_usage = 5;
		}
		else
		{
			max_usage = 6;
		}
	}
	// Box has moved, what is the maximum number of times it can move again?
	else
	{
		if( players.size == 1 )
		{
			max_usage = 4;
		}
		else if( players.size == 2 )
		{
			max_usage = 4;
		}
		else if( players.size == 3 )
		{
			max_usage = 5;
		}
		else
		{
			max_usage = 7;
		}
	}
	return( max_usage );
}


function timer_til_despawn( v_float )
{
	self endon("kill_weapon_movement");
	// SRS 9/3/2008: if we timed out, move the weapon back into the box instead of deleting it
	putBackTime = 12;
	self MoveTo( self.origin - ( v_float * 0.85 ), putBackTime, ( putBackTime * 0.5 ) );
	wait( putBackTime );

	if(isdefined(self))
	{	
		self Delete();
	}
}

function treasure_chest_glowfx()
{
	self clientfield::set( "magicbox_open_glow", true );
	self clientfield::set( "magicbox_closed_glow", false );

	ret_val = self util::waittill_any_return( "weapon_grabbed", "box_moving" ); 

	self clientfield::set( "magicbox_open_glow", false );

	if ( "box_moving" != ret_val )
	{
		self clientfield::set( "magicbox_closed_glow", true );
	}
}

// self is the player string comes from the randomization function
function treasure_chest_give_weapon( weapon )
{
	self.last_box_weapon = GetTime();

	// this function was almost identical to weapon_give() so it calls that instead

	//Audio: Raygun ALWAYS plays this stinger when getting it from the magicbox
	if( weapon.name == "ray_gun" )
	{
		playsoundatposition( "mus_raygun_stinger", (0,0,0) );
	}
	
	self zm_weapons::weapon_give(weapon, false, true);
}

function magic_box_teddy_twitches()
{
	self endon("zbarrier_state_change");
	
	self SetZBarrierPieceState(0, "closed");
	
	while(1)
	{
		wait(randomfloatrange(180, 1800));
		self SetZBarrierPieceState(0, "opening");
		wait(randomfloatrange(180, 1800));
		self SetZBarrierPieceState(0, "closing");
	}
}

function magic_box_initial()
{
	self SetZBarrierPieceState(1, "open");

	self clientfield::set( "magicbox_closed_glow", true );
}

function magic_box_arrives()
{
	self SetZBarrierPieceState(1, "opening");
	while(self GetZBarrierPieceState(1) == "opening")
	{
		{wait(.05);};
	}
	self notify("arrived");
}

function magic_box_leaves()
{
	self SetZBarrierPieceState(1, "closing");
	while(self GetZBarrierPieceState(1) == "closing")
	{
		wait (0.1);
	}
	self notify("left");
}

function magic_box_opens()
{
	self SetZBarrierPieceState(2, "opening");
	while(self GetZBarrierPieceState(2) == "opening")
	{
		wait (0.1);
	}
	self notify("opened");
}

function magic_box_closes()
{
	self SetZBarrierPieceState(2, "closing");
	while(self GetZBarrierPieceState(2) == "closing")
	{
		wait (0.1);
	}
	self notify("closed");
}

function magic_box_do_weapon_rise()
{
	self endon("box_hacked_respin");
	
	self SetZBarrierPieceState(3, "closed");
	self SetZBarrierPieceState(4, "closed");
	
	util::wait_network_frame();

	self ZBarrierPieceUseBoxRiseLogic(3);
	self ZBarrierPieceUseBoxRiseLogic(4);
	
	self ShowZBarrierPiece(3);
	self ShowZBarrierPiece(4);
	self SetZBarrierPieceState(3, "opening");
	self SetZBarrierPieceState(4, "opening");
	
	while(self GetZBarrierPieceState(3) != "open")
	{
		wait(0.5);
	}
	
	self HideZBarrierPiece(3);
	self HideZBarrierPiece(4);
	
}

function magic_box_do_teddy_flyaway()
{
	self ShowZBarrierPiece(3);
	self SetZBarrierPieceState(3, "closing");
}

function is_chest_active()
{
	curr_state = self.zbarrier get_magic_box_zbarrier_state();
	
	if( level flag::get( "moving_chest_now" ) )
	{
		return false;
	}
	
	if( curr_state == "open" || curr_state == "close" )
	{
		return true;
	}
	
	return false;
}

function get_magic_box_zbarrier_state()
{
	return self.state;
}

function set_magic_box_zbarrier_state(state)
{
	for(i = 0; i < self GetNumZBarrierPieces(); i ++)
	{
		self HideZBarrierPiece(i);
	}
	self notify("zbarrier_state_change");
	
	self [[level.magic_box_zbarrier_state_func]](state);
}

function process_magic_box_zbarrier_state(state)
{
	switch(state)
	{
		case "away":
			self ShowZBarrierPiece(0);
			self thread magic_box_teddy_twitches();
			self.state = "away";
			break;
		case "arriving":
			self ShowZBarrierPiece(1);
			self thread magic_box_arrives();
			self.state = "arriving";
			break;
		case "initial":
			self ShowZBarrierPiece(1);
			self thread magic_box_initial();
			thread zm_unitrigger::register_static_unitrigger(self.owner.unitrigger_stub, &magicbox_unitrigger_think);
			self.state = "initial";
			break;
		case "open":
			self ShowZBarrierPiece(2);
			self thread magic_box_opens();
			self.state = "open";
			break;
		case "close":
			self ShowZBarrierPiece(2);
			self thread magic_box_closes();
			self.state = "close";
			break;
		case "leaving":
			self showZBarrierPiece(1);
			self thread magic_box_leaves();
			self.state = "leaving";
			break;
		default:
			if( IsDefined( level.custom_magicbox_state_handler ) )
			{
				self [[ level.custom_magicbox_state_handler ]]( state );
			}
			break;
	}
}

function magicbox_host_migration()
{
	level endon("end_game");
	
	level notify("mb_hostmigration");
	level endon("mb_hostmigration");
		
	while(1)
	{
		level waittill("host_migration_end");
		
		if(!isDefined(level.chests))
			continue;
		
		foreach( chest in level.chests ) 
		{
			if ( !( isdefined( chest.hidden ) && chest.hidden ) ) 
			{
				if ( IsDefined( chest ) && IsDefined( chest.pandora_light ) )
				{
					playfxontag(level._effect["lght_marker"], chest.pandora_light, "tag_origin");
				}
			}
			util::wait_network_frame();
		}
	}
}
