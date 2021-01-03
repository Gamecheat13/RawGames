    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
   	                                                         	                                                                                                                                               	                                                      	                                                                              	                                                          	                                    	                                     	                                                     	                                                                                      	                                                             	                                                                                                    	                                             	                                     	                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                 
                                                                                                                                                                                                                         
                                                                                                                               

#using scripts\codescripts\struct;

#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_bgb_machine;
#using scripts\zm\_zm_bgb_token;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

// BGB stands for BubbleGum Buffs





#namespace bgb;

function autoexec __init__sytem__() {     system::register("bgb",&__init__,&__main__,undefined);    }

function private __init__()
{
	callback::on_spawned( &on_player_spawned );

	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	level.weaponBGBGrab = GetWeapon( "zombie_bgb_grab" );
	level.weaponBGBUse = GetWeapon( "zombie_bgb_use" );
	
	level.bgb = []; // array for actual buffs

	clientfield::register( "clientuimodel", "bgb_current", 1, 8, "int" );
	clientfield::register( "clientuimodel", "bgb_display", 1, 1, "int" );
	clientfield::register( "clientuimodel", "bgb_timer", 1, 8, "float" );
	clientfield::register( "clientuimodel", "bgb_activations_remaining", 1, 3, "int" );
	clientfield::register( "clientuimodel", "bgb_invalid_use", 1, 1, "counter" );
	clientfield::register( "clientuimodel", "bgb_one_shot_use", 1, 1, "counter" );

	clientfield::register( "toplayer", "bgb_blow_bubble", 1, 1, "counter" );
	
	zm::register_vehicle_damage_callback( &vehicle_damage_override );
}

function private __main__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	bgb_finalize();

/#
	level thread setup_devgui();
#/
}


function private on_player_spawned()
{
	self.bgb = "none";

	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	self thread bgb_player_init();
}

function private bgb_player_init()
{
	if ( IsDefined( self.bgb_pack ) )
	{
		return;
	}

	self.bgb_pack = self GetBubblegumPack();
	self.bgb_pack_randomized = [];

	self.bgb_stats = []; // bgb_stats will hold the player's gained/used stats, indexed by bgb name
	foreach( bgb in self.bgb_pack )
	{
		if( !( isdefined( level.bgb[ bgb ].consumable ) && level.bgb[ bgb ].consumable ) )
		{
			continue;
		}
		
		self.bgb_stats[ bgb ] = SpawnStruct();
		self.bgb_stats[ bgb ].bgb_gained = self GetDStat( "ItemStats", level.bgb[ bgb ].item_index, "itemStatsByGameTypeGroup", "ZCLASSIC", "stats", "bgbConsumablesGained", "statValue" );
		self.bgb_stats[ bgb ].bgb_used = self GetDStat( "ItemStats", level.bgb[ bgb ].item_index, "itemStatsByGameTypeGroup", "ZCLASSIC", "stats", "bgbConsumablesUsed", "statValue" );	
		self.bgb_stats[ bgb ].bgb_used_this_game = 0;
	}
	
	self.can_use_bgb_machine = true;

	self thread bgb_player_monitor();
	self thread bgb_end_game();
	//self thread bgb_debug_text_display_init(); // turning off debug for now
}

// when the game ends:
// - take any bgb that the player is carrying
// - add count of bgbs used this game to the player's stat
function private bgb_end_game()
{
	level waittill ( "end_game" );

	// - take any bgb that the player is carrying
	self thread take();
	
	// - add count of bgbs used this game to the player's stat
	foreach( bgb in self.bgb_pack )
	{
		// ignore non-consumables
		if( !isdefined( self.bgb_stats[ bgb ] ) )
		{
			continue;
		}
		
		self AddDStat( "ItemStats", level.bgb[ bgb ].item_index, "itemStatsByGameTypeGroup", "ZCLASSIC", "stats", "bgbConsumablesUsed", "statValue", self.bgb_stats[ bgb ].bgb_used_this_game );
	}
}

function private bgb_finalize()
{
	statsTableName = util::getStatsTableName();

	keys = GetArrayKeys( level.bgb );
	for ( i = 0; i < keys.size; i++ )
	{
		level.bgb[keys[i]].item_index = GetItemIndexFromRef( keys[i] );

		level.bgb[keys[i]].consumable = Int( tableLookup( statsTableName, 0, level.bgb[keys[i]].item_index, 16 ) );

		level.bgb[keys[i]].camo_index = Int( tableLookup( statsTableName, 0, level.bgb[keys[i]].item_index, 5 ) );
	}
}

// self = player
function private bgb_player_monitor()
{
	self endon( "disconnect" );
	
	while( true )
	{
		level waittill( "start_of_round" );
		
		// get your ability to grab a bubblegum buff back every round
		self.can_use_bgb_machine = true;
	}
}

/#
function private setup_devgui()
{
	waittillframeend;

	SetDvar( "bgb_acquire_devgui", "" );
	SetDvar( "bgb_add_devgui", "" );
	SetDvar( "bgb_sub_devgui", "" );

	bgb_devgui_base = "devgui_cmd \"ZM/BGB/";
	keys = GetArrayKeys( level.bgb );
	foreach ( key in keys )
	{
		AddDebugCommand( bgb_devgui_base + key + "/.Give\" \"set " + "bgb_acquire_devgui"	+ " " + key + "\" \n");
		AddDebugCommand( bgb_devgui_base + key + "/Add One\" \"set " + "bgb_add_devgui"		+ " " + key + "\" \n");
		AddDebugCommand( bgb_devgui_base + key + "/Subtract One\" \"set " + "bgb_sub_devgui"		+ " " + key + "\" \n");
	}

	AddDebugCommand( bgb_devgui_base + "Clear Current\" \"set " + "bgb_acquire_devgui" + " " + "none" + "\" \n");

	level thread bgb_devgui_think();
}

function private bgb_devgui_think()
{
	for ( ;; )
	{
		bgb_acquire_name = GetDvarString( "bgb_acquire_devgui" );
		bgb_add_name = GetDvarString( "bgb_add_devgui" );
		bgb_sub_name = GetDvarString( "bgb_sub_devgui" );

		if ( bgb_acquire_name != "" )
		{
			bgb_devgui_acquire( bgb_acquire_name );
		}
		if ( bgb_add_name != "" )
		{
			bgb_devgui_add( bgb_add_name, 1 );
		}
		if ( bgb_sub_name != "" )
		{
			bgb_devgui_sub( bgb_sub_name, 1 );
		}
		
		SetDvar( "bgb_acquire_devgui", "" );
		SetDvar( "bgb_add_devgui", "" );
		SetDvar( "bgb_sub_devgui", "" );
		
		wait( 0.5 );
	}
}

function private bgb_devgui_acquire( bgb_name )
{
	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( "none" == bgb_name )
		{
			players[i] thread take();
		}
		else
		{
			players[i] thread bgb_gumball_anim( bgb_name, false );
		}
	}
}

function bgb_devgui_add( bgb_name, n_count )
{
	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		players[i] thread add_consumable_bgb( bgb_name );
	}
}

function bgb_devgui_sub( bgb_name, n_count )
{
	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		players[i] thread sub_consumable_bgb( bgb_name );
	}
}

#/

function private bgb_debug_text_display_init()
{
/#	
	self.bgb_debug_text = NewClientHudElem( self );
	self.bgb_debug_text.elemType = "font";
	self.bgb_debug_text.font = "objective";
	self.bgb_debug_text.fontscale = 1.8;
	self.bgb_debug_text.horzAlign = "left";
	self.bgb_debug_text.vertAlign = "top";
	self.bgb_debug_text.alignX = "left";
	self.bgb_debug_text.alignY = "top";
	self.bgb_debug_text.x = 15;
	self.bgb_debug_text.y = 35;
	self.bgb_debug_text.sort = 2;

	self.bgb_debug_text.color = ( 1, 1, 1 );
	self.bgb_debug_text.alpha = 1;

	self.bgb_debug_text.hidewheninmenu = true;
#/
}



function private bgb_set_debug_text( name, activations_remaining )
{
/#
	if( !isdefined( self.bgb_debug_text ) ) // can disable bgb debug by not calling the init function
	{
		return;
	}

	if ( IsDefined( activations_remaining ) )
	{
		self clientfield::set_player_uimodel( "hudItems.showDpadDown", 1 );
	}
	else
	{
		self clientfield::set_player_uimodel( "hudItems.showDpadDown", 0 );
	}

	self notify( "bgb_set_debug_text_thread" );
	self endon( "bgb_set_debug_text_thread" );
	self endon( "disconnect" );

	self.bgb_debug_text fadeOverTime( 0.05 );
	self.bgb_debug_text.alpha = 1;

	prefix = "zm_bgb_";
	short_name = name;
	if ( IsSubStr( name, prefix ) )
	{
		short_name = GetSubStr( name, prefix.size );
	}

	if ( IsDefined( activations_remaining ) )
	{
		self.bgb_debug_text SetText( "BGB: " + short_name + ", [{+actionslot 2}] to activate (" + activations_remaining + " left)");
	}
	else
	{
		self.bgb_debug_text SetText( "BGB: " + short_name );
	}

	wait( 1 );

	if ( "none" == name )
	{
		self.bgb_debug_text fadeOverTime( 1 );
		self.bgb_debug_text.alpha = 0;
	}
#/
}

// self = player
function bgb_print_stats( bgb )
{
	/#
		PrintTopRightln( bgb + " gained: " + self.bgb_stats[ bgb ].bgb_gained, ( 1, 1, 1 ) );
		PrintTopRightln( bgb + " used: " + self.bgb_stats[ bgb ].bgb_used, ( 1, 1, 1 ) );
		PrintTopRightln( bgb + " used_this_session: " + self.bgb_stats[ bgb ].bgb_used_this_game, ( 1, 1, 1 ) );
		n_available = self.bgb_stats[ bgb ].bgb_gained - self.bgb_stats[ bgb ].bgb_used - self.bgb_stats[ bgb ].bgb_used_this_game;
		PrintTopRightln( bgb + " available: " + n_available, ( 1, 1, 1 ) );
	#/
}

// check if player has a bgb in their pack, and if the bgb is consumable
function has_consumable_bgb( bgb )
{
	if( !isdefined( self.bgb_stats[ bgb ] ) || !( isdefined( level.bgb[bgb].consumable ) && level.bgb[bgb].consumable ) )
	{
		return false;
	}
	else
	{
		return true;
	}
}

// add one to the player's count of a consumable bgb (adds to bgb_gained)
// self = player
function add_consumable_bgb( bgb )
{
	// if this isn't a consumable bgb, ignore
	if( !has_consumable_bgb( bgb ) )
	{
		return;
	}
	
	self.bgb_stats[ bgb ].bgb_gained++;
	/#
		bgb_print_stats( bgb );
	#/
}

// subtract one from the player's count of a consumable bgb (adds to bgb_used)
// self = player
function sub_consumable_bgb( bgb )
{
	// if this isn't a consumable bgb, ignore
	if( !has_consumable_bgb( bgb ) )
	{
		return;
	}
	
	self.bgb_stats[ bgb ].bgb_used_this_game++;
	/#
		bgb_print_stats( bgb );
	#/
}

// self = player
function get_bgb_gained( bgb )
{
	// if this isn't a consumable bgb, ignore
	if( !has_consumable_bgb( bgb ) )
	{
		return;
	}
	
	n_bgb_gained = self.bgb_stats[ bgb ].bgb_gained;
	return n_bgb_gained;
}

// self = player
function get_bgb_used( bgb )
{
	// if this isn't a consumable bgb, ignore
	if( !has_consumable_bgb( bgb ) )
	{
		return;
	}
	
	n_bgb_used = self.bgb_stats[ bgb ].bgb_used;
	return n_bgb_used;
}

// self = player
function get_bgb_used_this_game( bgb )
{
	// if this isn't a consumable bgb, ignore
	if( !has_consumable_bgb( bgb ) )
	{
		return;
	}
	
	n_bgb_used_this_game = self.bgb_stats[ bgb ].bgb_used_this_game;
	return n_bgb_used_this_game;
}

// return true if the named bgb is available, false if not (activates ghost ball effect in bgb machine)
// self = player
function get_bgb_available( bgb )
{
	// if .bgb_stats entry doesn't exist, the bgb is non-consumable
	if( !isdefined( self.bgb_stats[ bgb ] ) )
	{
		return true;
	}

	// consumable test
	n_bgb_gained = self.bgb_stats[ bgb ].bgb_gained;
	n_bgb_used = self.bgb_stats[ bgb ].bgb_used;
	n_bgb_used_this_game = self.bgb_stats[ bgb ].bgb_used_this_game;
	n_bgb_remaining = n_bgb_gained - ( n_bgb_used + n_bgb_used_this_game );
	return ( 0 < n_bgb_remaining ); // return availability
}

function bgb_gumball_anim( bgb, activating )
{
	self endon( "disconnect" );
	self endon( "end_game" );

	while ( self IsSwitchingWeapons() )
	{
		self waittill( "weapon_change_complete" );
	}

	gun = self bgb_play_gumball_anim_begin( bgb, activating );
	evt = self util::waittill_any_return( "fake_death", "death", "player_downed", "weapon_change_complete" );

	if ( evt == "weapon_change_complete" )
	{
		if ( activating )
		{
			self activation_start();
			self thread run_activation_func( bgb );
		}
		else
		{
			self thread give( bgb );
		}
	}
	
	// restore player controls and movement
	self bgb_play_gumball_anim_end( gun, bgb, activating );
}

/@
"Name: run_activation_func( bgb )"
"Summary: Run the activation func for the current gumball on the player. Manage setting the player's active state before and after.
"Module: BGB"
"Example: self bgb::run_activation_func( bgb );"
"SPMP: both"
@/
function run_activation_func( bgb )
{
	self set_active( true );
	self [[level.bgb[bgb].activation_func]]();
	self set_active( false );
}

function private bgb_get_gumball_anim_weapon( bgb, activating )
{
	if ( activating )
	{
		return level.weaponBGBUse;
	}

	return level.weaponBGBGrab;
}


function private bgb_play_gumball_anim_begin( bgb, activating )
{
	self zm_utility::increment_is_drinking();
	
	self zm_utility::disable_player_move_states(true);

	original_weapon = self GetCurrentWeapon();
	
	weapon = bgb_get_gumball_anim_weapon( bgb, activating );

	self GiveWeapon( weapon, self CalcWeaponOptions( level.bgb[bgb].camo_index, 0, 0 ) );
	self SwitchToWeapon( weapon );

	if ( weapon == level.weaponBGBGrab )
	{
		self playsound( "zmb_bgb_powerup_default" );
	}

	if ( weapon == level.weaponBGBUse )
	{
		self clientfield::increment_to_player( "bgb_blow_bubble" );
	}

	return original_weapon;
}


function private bgb_play_gumball_anim_end( original_weapon, bgb, activating )
{
	assert( !original_weapon.isPerkBottle );
	assert( original_weapon != level.weaponReviveTool );

	self zm_utility::enable_player_move_states();

	weapon = bgb_get_gumball_anim_weapon( bgb, activating );

	// TODO: race condition?
	if ( self laststand::player_is_in_laststand() || ( isdefined( self.intermission ) && self.intermission ) )
	{
		self TakeWeapon( weapon );
		return;
	}

	self TakeWeapon( weapon );

	if ( self zm_utility::is_multiple_drinking() )
	{
		self zm_utility::decrement_is_drinking();
		return;
	}
	else if ( original_weapon != level.weaponNone && !zm_utility::is_placeable_mine( original_weapon ) && !zm_equipment::is_equipment_that_blocks_purchase( original_weapon ) )
	{
		self SwitchToWeapon( original_weapon );
		// ww: the knives have no first raise anim so they will never get a "weapon_change_complete" notify
		// meaning it will never leave this function and will break buying weapons for the player
		if ( zm_utility::is_melee_weapon( original_weapon ) )
		{
			self zm_utility::decrement_is_drinking();
			return;
		}
	}
	else 
	{
		// try to switch to first primary weapon
		primaryWeapons = self GetWeaponsListPrimaries();
		if ( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}

	self waittill( "weapon_change_complete" );

	if ( !self laststand::player_is_in_laststand() && !( isdefined( self.intermission ) && self.intermission ) )
	{
		self zm_utility::decrement_is_drinking();
	}
}

function private bgb_clear_monitors_and_clientfields()
{
	self notify( "bgb_limit_monitor" );
	self notify( "bgb_activation_monitor" );

	self clientfield::set_player_uimodel( "bgb_display", 0 );
	self clientfield::set_player_uimodel( "bgb_activations_remaining", 0 );
	self clear_timer();
}

function private bgb_limit_monitor()
{
	self endon( "disconnect" );

	self notify( "bgb_limit_monitor" );
	self endon( "bgb_limit_monitor" );

	self clientfield::set_player_uimodel( "bgb_display", 1 );

	switch ( level.bgb[self.bgb].limit_type )
	{
	case "activated":
		self thread bgb_activation_monitor();

		for ( i = level.bgb[self.bgb].limit; i > 0; i-- )
		{
			self set_timer( i, level.bgb[self.bgb].limit );
			self clientfield::set_player_uimodel( "bgb_activations_remaining", i );

			self thread bgb_set_debug_text( self.bgb, i );
			self waittill( "bgb_activation" );
			
			while( ( isdefined( self get_active() ) && self get_active() ) ) // if we have a long, timed activation period, wait for that to end before updating the remaining-activations ui
			{
				{wait(.05);};
			}
		}

		self set_timer( 0, level.bgb[self.bgb].limit );

		while ( ( isdefined( level.bgb_activation_in_progress ) && level.bgb_activation_in_progress ) )
		{
			{wait(.05);};
		}
		break;

	case "time":
		self thread bgb_set_debug_text( self.bgb );
		self thread run_timer( level.bgb[self.bgb].limit );
		wait( level.bgb[self.bgb].limit );
		break;

	case "rounds":
		self thread bgb_set_debug_text( self.bgb );
		count = level.bgb[self.bgb].limit + 1;
		for ( i = 0; i < count; i++ ) // + 1 to make the count full rounds
		{
			self set_timer( count - i, count );
			level waittill( "end_of_round" );
		}
		break;

	case "event":
		self thread bgb_set_debug_text( self.bgb );

		self bgb_set_timer_clientfield( 1 );

		self [[level.bgb[self.bgb].limit]]();
		break;

	default:
		assert( false, "bgb::bgb_limit_monitor(): BGB '" + self.bgb + "': limit_type '" + level.bgb[self.bgb].limit_type + "' is not supported" );
	}

	self thread take();
}

// takes the bgb on "bled_out", but sends notify ahead of time
function private bgb_bled_out_monitor()
{
	self endon( "disconnect" );
	self endon( "bgb_update" );
	self notify( "bgb_bled_out_monitor" );
	self endon( "bgb_bled_out_monitor" );
	
	self waittill( "bled_out" );
	
	self notify( "bgb_about_to_take_on_bled_out" );
	
	wait 0.1; // need a wait here; otherwise nothing gets a chance to respond to the "bgb_about_to_take_on_bled_out" notify before take() gets called
	
	self thread take();
}

function private bgb_activation_monitor()
{
	self endon( "disconnect" );

	self notify( "bgb_activation_monitor" );
	self endon( "bgb_activation_monitor" );

	if ( "activated" != level.bgb[self.bgb].limit_type )
	{
		return;
	}

	for ( ;; )
	{
		self waittill( "bgb_activation_request" );

		if ( ( isdefined( level.bgb_activation_in_progress ) && level.bgb_activation_in_progress ) || (IsDefined( level.bgb[self.bgb].validation_func ) && !self [[level.bgb[self.bgb].validation_func]]()) )
		{
			self clientfield::increment_uimodel( "bgb_invalid_use" );
			self playlocalsound( "zmb_bgb_deny_plr" );
			continue;
		}

		self bgb_gumball_anim( self.bgb, true );

		self notify( "bgb_activation", self.bgb );
	}
}


/@
"Name: do_one_shot_use()"
"Summary: Updates the clientfield that signals a one shot use has occurred
"Module: BGB"
"Example: self bgb::do_one_shot_use();"
"SPMP: both"
@/
function do_one_shot_use()
{
	self clientfield::increment_uimodel( "bgb_one_shot_use" );

	self activation_complete();
}


/@
"Name: activation_start()"
"Summary: Declares an activation has begun
"Module: BGB"
"Example: self bgb::activation_start();"
"SPMP: both"
@/
function private activation_start()
{
	level.bgb_activation_in_progress = true;
}


/@
"Name: activation_complete()"
"Summary: Marks the current activation as complete
"Module: BGB"
"Example: self bgb::activation_complete();"
"SPMP: both"
@/
function activation_complete()
{
	level.bgb_activation_in_progress = false;
}


/@
"Name: set_active( b_is_active )"
"Summary: Set whether a bgb is currently activated on self (the player).
"Module: BGB"
"Example: self bgb::set_active( b_is_active );"
"SPMP: both"
@/
function set_active( b_is_active )
{
	self.bgb_active = b_is_active;
}


/@
"Name: get_active()"
"Summary: Get whether a bgb is currently activated on self (the player).
"Module: BGB"
"Example: self bgb::get_active();"
"SPMP: both"
@/
function get_active()
{
	return self.bgb_active;
}


function private bgb_set_timer_clientfield( percent )
{
	self clientfield::set_player_uimodel( "bgb_timer", percent );
}


/@
"Name: set_timer( <current>, <max> )"
"Summary: Set the BGB timer based on a current and max value so it can calculate the percentage for you as a convenience
"Module: BGB"
"MandatoryArg: <current> current timer value in seconds
"MandatoryArg: <max> max timer value in seconds, so the percentage can be calculated
"Example: self bgb::set_timer( 1, 2 );"
"SPMP: both"
@/
function set_timer( current, max )
{
	self bgb_set_timer_clientfield( current / max );
}


/@
"Name: run_timer( <max> )"
"Summary: Runs a thread that updates the BGB timer for max seconds
"Module: BGB"
"MandatoryArg: <max> how long to run the timer in seconds
"Example: self bgb::run_timer( 2 );"
"SPMP: both"
@/
function run_timer( max )
{
	self notify( "bgb_run_timer" );
	self endon( "bgb_run_timer" );

	current = max;

	while ( current > 0 )
	{
		self set_timer( current, max );

		{wait(.05);};

		current = current - .05;
	}

	self clear_timer();
}


/@
"Name: clear_timer()"
"Summary: Clear the BGB timer
"Module: BGB"
"Example: self bgb::clear_timer();"
"SPMP: both"
@/
function clear_timer()
{
	self bgb_set_timer_clientfield( 0 );

	self notify( "bgb_run_timer" );
}


/@
"Name: register( <name>, <limit_type>, <limit>, <enable_func>, <disable_func>, <validation_func>, <activation_func> )"
"Summary: Register a BGB
"Module: BGB"
"MandatoryArg: <name> Unique name to identify the BGB.
"MandatoryArg: <limit_type> One of the BGB_LIMIT_TYPE_*'s.
"MandatoryArg: <limit> A function pointer if it is an BGB_LIMIT_TYPE_EVENT to track the limit timeout, an int otherwise to track the limit timeout
"MandatoryArg: <enable_func> Function pointer to run in response to the BGB being given to the player. May be undefined
"MandatoryArg: <disable_func> Function pointer to run in response to the BGB being taken from the player. May be undefined
"MandatoryArg: <validation_func> Function pointer to run in response to an activation to validate whether the activation can occur. Must be undefined if limit_type is not BGB_LIMIT_TYPE_ACTIVATED.
"MandatoryArg: <activation_func> Function pointer to run in response to a validated activation. Must be undefined if limit_type is not BGB_LIMIT_TYPE_ACTIVATED.
"Example: level bgb::register( "zm_bgb_respin_cycle", BGB_LIMIT_TYPE_ACTIVATED, 2, &_zm_bgb_respin_cycle::validation, &_zm_bgb_respin_cycle::activation );"
"SPMP: both"
@/
function register( name, limit_type, limit, enable_func, disable_func, validation_func, activation_func )
{
	assert( IsDefined( name ), "bgb::register(): name must be defined" );
	assert( "none" != name, "bgb::register(): name cannot be '" + "none" + "', that name is reserved as an internal sentinel value" );
	assert( !IsDefined( level.bgb[name] ), "bgb::register(): BGB '" + name + "' has already been registered" );

	assert( IsDefined( limit_type ), "bgb::register(): BGB '" + name + "': limit_type must be defined" );
	assert( IsDefined( limit ), "bgb::register(): BGB '" + name + "': limit must be defined" );

	assert( !IsDefined( enable_func ) || IsFunctionPtr( enable_func ), "bgb::register(): BGB '" + name + "': enable_func must be undefined or a function pointer" );
	assert( !IsDefined( disable_func ) || IsFunctionPtr( disable_func ), "bgb::register(): BGB '" + name + "': disable_func must be undefined or a function pointer" );

	switch ( limit_type )
	{
	case "activated":
		assert( !IsDefined( validation_func ) || IsFunctionPtr( validation_func ), "bgb::register(): BGB '" + name + "': validation_func must be undefined or a function pointer for limit_type '" + limit_type + "'" );
		assert( IsDefined( activation_func ), "bgb::register(): BGB '" + name + "': activation_func must be defined for limit_type '" + limit_type + "'" );
		assert( IsFunctionPtr( activation_func ), "bgb::register(): BGB '" + name + "': activation_func must be a function pointer for limit_type '" + limit_type + "'" );
		// fallthrough
	case "time":
	case "rounds":
		assert( IsInt( limit ), "bgb::register(): BGB '" + name + "': limit '" + limit + "' must be an int for limit_type '" + limit_type + "'" );
		break;
	case "event":
		assert( IsFunctionPtr( limit ), "bgb::register(): BGB '" + name + "': limit must be a function pointer for limit_type '" + limit_type + "'" );
		break;
	default:
		assert( false, "bgb::register(): BGB '" + name + "': limit_type '" + limit_type + "' is not supported" );
	}

	level.bgb[name] = SpawnStruct();

	level.bgb[name].name = name;
	level.bgb[name].limit_type = limit_type;
	level.bgb[name].limit = limit;
	level.bgb[name].enable_func = enable_func;
	level.bgb[name].disable_func = disable_func;

	if ( "activated" == limit_type )
	{
		level.bgb[name].validation_func = validation_func;
		level.bgb[name].activation_func = activation_func;
	}
}

/@
"Name: register_actor_damage_override( <name>, <actor_damage_override_func> )"
"Summary: Set up a damage override that will play on any actor.
"Module: BGB"
"MandatoryArg: <name> Unique name to identify the BGB
"MandatoryArg: <actor_damage_override_func> Damage override that plays on any actor.
"Example: register_actor_damage_override( name, actor_damage_override_func );"
"SPMP: both"
@/
function register_actor_damage_override( name, actor_damage_override_func )
{
	level.bgb[name].actor_damage_override_func = actor_damage_override_func;
}

/@
"Name: register_vehicle_damage_override( <name>, <register_vehicle_damage_override> )"
"Summary: Set up a damage override that will play on any vehicle.
"Module: BGB"
"MandatoryArg: <name> Unique name to identify the BGB
"MandatoryArg: <register_vehicle_damage_override> Damage override that plays on any vehicle.
"Example: register_vehicle_damage_override( name, register_vehicle_damage_override );"
"SPMP: both"
@/
function register_vehicle_damage_override( name, vehicle_damage_override_func )
{
	level.bgb[name].vehicle_damage_override_func = vehicle_damage_override_func;
}

/@
"Name: register_lost_perk_override( <name>, <register_lost_perk_override> )"
"Summary: Set up a lost perk override that will play when a player would normally lose a perk.
"Module: BGB"
"MandatoryArg: <name> Unique name to identify the BGB
"MandatoryArg: <register_lost_perk_override> Lost perk override that plays on the player.
"Example: register_lost_perk_override( name, register_lost_perk_override );"
"SPMP: both"
@/
function register_lost_perk_override( name, lost_perk_override_func )
{
	level.bgb[name].lost_perk_override_func = lost_perk_override_func;
}

/@
"Name: perk_purchase_limit_override_func( <name>, <register_lost_perk_override> )"
"Summary: Set up a perk purchase limit override that will play on the player trying to purchase a perk.
"Module: BGB"
"MandatoryArg: <name> Unique name to identify the BGB
"MandatoryArg: <perk_purchase_limit_override_func> Perk purchase limit override that plays on a player trying to purchase a perk.
"Example: perk_purchase_limit_override_func( name, perk_purchase_limit_override_func );"
"SPMP: both"
@/
function register_perk_purchase_limit_override( name, perk_purchase_limit_override_func )
{
	level.bgb[name].perk_purchase_limit_override_func = perk_purchase_limit_override_func;
}

/@
"Name: register_add_to_player_score_override( <name>, <add_to_player_score_override_func> )"
"Summary: Set up a player score override that will play on the player about to receive points.
"Module: BGB"
"MandatoryArg: <name> Unique name to identify the BGB
"MandatoryArg: <add_to_player_score_override_func> Player score override that plays on a player about to receive points.
"Example: register_add_to_player_score_override( name, add_to_player_score_override_func );"
"SPMP: both"
@/
function register_add_to_player_score_override( name, add_to_player_score_override_func )
{
	level.bgb[name].add_to_player_score_override_func = add_to_player_score_override_func;
}

/@
"Name: give( <name> )"
"Summary: The player is given the specified BGB.
"Module: BGB"
"MandatoryArg: <name> Unique name to identify the BGB to be given.
"Example: self bgb::give( "im_feelin_lucky" );"
"SPMP: both"
@/
function give( name )
{
	self thread take();

	if ( "none" == name )
	{
		return;
	}

	assert( IsDefined( level.bgb[name] ), "bgb::give(): BGB '" + name + "' was never registered" );

	self notify( "bgb_update", name, self.bgb );

	self.bgb = name;

	self clientfield::set_player_uimodel( "bgb_current", level.bgb[name].item_index );

	if ( IsDefined( level.bgb[name].enable_func ) )
	{
		self thread [[level.bgb[name].enable_func]]();
	}

	if ( IsDefined( "activated" == level.bgb[name].limit_type ) )
	{
		self SetActionSlot( 2, "bgb" );
	}

	self thread bgb_limit_monitor();
	self thread bgb_bled_out_monitor();
}


/@
"Name: take()"
"Summary: Removes the currently enabled BGB from the player if any
"Module: BGB"
"Example: self bgb::take();"
"SPMP: both"
@/
function take()
{
	if ( "none" == self.bgb )
	{
		return;
	}

	self SetActionSlot( 2, "" );
	self notify( "bgb_update", "none", self.bgb );
	self thread bgb_set_debug_text( "none" );

	if ( IsDefined( level.bgb[self.bgb].disable_func ) )
	{
		self thread [[level.bgb[self.bgb].disable_func]]();
	}

	self bgb_clear_monitors_and_clientfields();

	self.bgb = "none";
}


/@
"Name: get_enabled()"
"Summary: Gets the currently enabled BGB from the player
"Module: BGB"
"Example: self bgb::get_enabled();"
"SPMP: both"
@/
function get_enabled()
{
	return self.bgb;
}


/@
"Name: is_enabled( <name> )"
"Summary: Returns whether the specified BGB is the player's currently enabled BGB
"Module: BGB"
"MandatoryArg: <name> Unique name to identify the BGB to be given.
"Example: self bgb::is_enabled( "zm_bgb_im_feelin_lucky" );"
"SPMP: both"
@/
function is_enabled( name )
{
	assert( IsDefined( self.bgb ) );

	return ( self.bgb == name );
}


/@
"Name: any_enabled()"
"Summary: Returns whether the player has any BGB active
"Module: BGB"
"Example: self bgb::any_enabled();"
"SPMP: both"
@/
function any_enabled()
{
	assert( IsDefined( self.bgb ) );
	
	return ( self.bgb !== "none" );
}

/@
"Name: get_player_dropped_powerup_origin()"
"Summary: Returns the origin that we want to drop a powerup relative to self (the player) when dropped by activating a BGB
"Module: BGB"
"Example: self bgb::get_player_dropped_powerup_origin();"
"SPMP: both"
@/
function get_player_dropped_powerup_origin()
{
	powerup_origin = self.origin + ( VectorScale( AnglesToForward( (0, self GetPlayerAngles()[1], 0) ), 60 ) ) + (0, 0, 5);
	
	return powerup_origin;
}

/@
"Name: actor_damage_override()"
"Summary: Gets called when any actor takes damage. Checks to see if the attacker is a player who has a registered damage buff, and calls that buff's damage override.
"Module: BGB"
"Example: self bgb::actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, modelIndex, surfaceType, vSurfaceNormal );
"SPMP: both"
@/
function actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType )
{
	if( IsPlayer( attacker ) )
	{
		name = attacker get_enabled(); // get the name of the attacking player's bgb

		if( ( name !== "none" ) && isdefined( level.bgb[name] ) && isdefined( level.bgb[name].actor_damage_override_func ) )
		{
			damage = [[ level.bgb[name].actor_damage_override_func ]]( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType );
		}
	}
	
	return damage;
}

/@
"Name: vehicle_damage_override()"
"Summary: Gets called when any vehicle takes damage. Checks to see if the attacker is a player who has a registered damage buff, and calls that buff's damage override.
"Module: BGB"
"Example: self bgb::vehicle_damage_override( inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex );"
"SPMP: both"
@/
function vehicle_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	if( IsPlayer( eAttacker ) )
	{
		name = eAttacker get_enabled(); // get the name of the attacking player's bgb

		if( ( name !== "none" ) && isdefined( level.bgb[name] ) && isdefined( level.bgb[name].vehicle_damage_override_func ) )
		{
			iDamage = [[ level.bgb[name].vehicle_damage_override_func ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );
		}
	}
	
	return iDamage;
}

/@
"Name: lost_perk_override()"
"Summary: Gets called when a player would normally lose a perk. Checks to see if ANY player has a registered lost perk func, and calls it. Can return true to prevent the perk from being lost.
"Module: BGB"
"Example: bgb::lost_perk_override( perk );"
"SPMP: both"
@/
function lost_perk_override( perk )
{
	b_result = false; // by default, won't interfere with normal loss of the perk

	foreach( player in level.activeplayers )
	{
		name = self get_enabled(); // get the name of the player's bgb

		// if there's a lost perk override func associated with the player's bgb, call it, allowing it to prevent loss of the perk if desired
		if( ( name !== "none" ) && isdefined( level.bgb[name] ) && isdefined( level.bgb[name].lost_perk_override_func ) )
		{
			b_result = [[ level.bgb[name].lost_perk_override_func ]]( perk );
		}
	}
	
	return b_result;
}

/@
"Name: perk_purchase_limit_override()"
"Summary: Gets called when getting the perk purchase limit. If returns a value, that value will override the perk purchase limit for the player who has the perk. Self is the player being tested.
"Module: BGB"
"MandatoryArg: <n_perk_purchase_limit_override> The current purchase limit of perks passed in from the limit function in _zm_utility.
"Example: self bgb::perk_purchase_limit_override( n_perk_purchase_limit_override );"
"SPMP: both"
@/
function perk_purchase_limit_override( n_perk_purchase_limit_override )
{
	name = self get_enabled(); // get the name of the attacking player's bgb

	if( ( name !== "none" ) && isdefined( level.bgb[name] ) && isdefined( level.bgb[name].perk_purchase_limit_override_func ) )
	{
		n_perk_purchase_limit_override = [[ level.bgb[name].perk_purchase_limit_override_func ]]( n_perk_purchase_limit_override );
	}

	return n_perk_purchase_limit_override;
}

/@
"Name: add_to_player_score_override()"
"Summary: Gets called when adding to player score. Can change the number of points that will be added to currency (doesn't impact the "score_total" stat).
"Module: BGB"
"MandatoryArg: <points> The number of points being considered to add to the player's score.
"Example: self bgb::add_to_player_score_override( points );"
"SPMP: both"
@/
function add_to_player_score_override( points )
{
	name = self get_enabled(); // get the name of the attacking player's bgb

	if( ( name !== "none" ) && isdefined( level.bgb[name] ) && isdefined( level.bgb[name].add_to_player_score_override_func ) )
	{
		points = [[ level.bgb[name].add_to_player_score_override_func ]]( points );
	}

	return points;
}
