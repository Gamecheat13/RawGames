    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                 	    
                                                                                                                               

#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

// BGB stands for BubbleGum Buffs



#precache( "triggerstring", "ZOMBIE_BGB_AVAILABLE" );
#precache( "triggerstring", "ZOMBIE_BGB_COMEBACK" );
#precache( "triggerstring", "ZOMBIE_BGB_AWAY" );
#precache( "triggerstring", "ZOMBIE_BGB_DISABLED" );



#namespace bgb;

function autoexec __init__sytem__() {     system::register("bgb",&__init__,undefined,undefined);    }

function private __init__()
{
	callback::on_connect( &on_player_connect );

	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	level.weaponBGBGrabActivated = GetWeapon( "zombie_bgb_grab_activated" );
	level.weaponBGBGrabPassive = GetWeapon( "zombie_bgb_grab_passive" );
	level.weaponBGBUseActivated = GetWeapon( "zombie_bgb_use_activated" );
	
	level.n_bgb_machine_count = 5;
	
	level.bgb = [];
	level thread setup_devgui();
	level thread setup_stub_machines();
	
	level flag::init( "bgb_machine_is_moving" ); // flag used to prevent multiple bgb machines from trying to move at the exact same time
}


function private on_player_connect()
{
	self.bgb = "none";

	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	self.can_use_bubblegum_buff = true;
	self thread bgb_player_monitor();
	self thread stub_machine_monitors();

/#
	self thread bgb_debug_text_display_init();
#/
}

// move this bgb machine to a new randomly selected location
function bgb_move( n_machine_index )
{
	flag::wait_till_clear( "bgb_machine_is_moving" );
	flag::set( "bgb_machine_is_moving" );
		
	if(IsDefined(level._zombiemode_custom_bgb_move_logic))
	{
		[[ level._zombiemode_custom_bgb_move_logic ]]();
	}
	else
	{
		default_bgb_move_logic( n_machine_index );
	}
	
	flag::clear( "bgb_machine_is_moving" );
}

function bgb_hide( n_machine_index )
{
	level.bgb_machine[ n_machine_index ] HidePart( "tag_sphere_anim" );
}

function bgb_show( n_machine_index )
{
	level.bgb_machine[ n_machine_index ] ShowPart( "tag_sphere_anim" );
}

// n_source_index - index in level.bgb_machine of the location that the machine is leaving from
function default_bgb_move_logic( n_source_index )
{
	// pick a machine with state BGB_AWAY to be the next available machine
	a_n_target_indexes = []; // will fill this array with indexes of machine locations that are available
	for( i = 0; i < level.bgb_machine.size; i++ )
	{
		if( level.bgb_machine[ i ].state == 5 )
		{
			if ( !isdefined( a_n_target_indexes ) ) a_n_target_indexes = []; else if ( !IsArray( a_n_target_indexes ) ) a_n_target_indexes = array( a_n_target_indexes ); a_n_target_indexes[a_n_target_indexes.size]=i;;
		}
	}
	// get the index of the target machine
	n_target_index = a_n_target_indexes[ RandomIntRange( 0, a_n_target_indexes.size ) ];
	
	// perform the move
	level.bgb_machine[ n_target_index ].times_until_next_move = RandomIntRange( 4, ( 8 + 1 ) );
	level.bgb_machine[ n_source_index ].state = 5;
	level.bgb_machine[ n_target_index ].state = 0;
	// TODO: trigger clientside fx
	bgb_hide( n_source_index ); // hide old bgb machine
	// TODO: trigger clientside fx
	bgb_show( n_target_index ); // show new bgb machine
}

function private setup_stub_machines()
{
	level.bgb_machine = [];
	
	a_s_stub = struct::get_array( "bubble_gum_use", "targetname" );
	
	// spawn all the BGB Machine models and add them to the level array
	foreach( s_stub in a_s_stub )
	{
		mdl_machine = spawn( "script_model", s_stub.origin );
		mdl_machine setmodel( "p7_zm_zod_bubblegum_machine" );
		mdl_machine.angles = s_stub.angles;
		mdl_machine NotSolid();
		
		if ( !isdefined( level.bgb_machine ) ) level.bgb_machine = []; else if ( !IsArray( level.bgb_machine ) ) level.bgb_machine = array( level.bgb_machine ); level.bgb_machine[level.bgb_machine.size]=mdl_machine;;
	}
	
	// pick the active machines
	level.bgb_machine = array::randomize( level.bgb_machine ); // randomize the array of possible bgb machine locations
	
	for( i = 0; i < level.bgb_machine.size; i++ )
	{
		if( i < level.n_bgb_machine_count )
		{
			level.bgb_machine[ i ].state = 0;
			level.bgb_machine[ i ].times_until_next_move = RandomIntRange( 4, ( 8 + 1 ) );
		}
		else
		{
			level.bgb_machine[ i ].state = 5;
			level.bgb_machine[ i ] HidePart( "tag_sphere_anim" );
		}
	}
}

function private stub_machine_monitors()
{
	self endon( "disconnect" );

	a_s_stub = struct::get_array( "bubble_gum_use", "targetname" );
	
	for( i = 0; i < level.bgb_machine.size; i++ )
	{
		create_bgb_unitrigger( level.bgb_machine[ i ], i );
	}
}

function create_bgb_unitrigger( e_bgb_machine, n_machine_index )
{
	width = 128;
	height = 128;
	length = 128;

	e_bgb_machine.unitrigger_stub = spawnstruct();
	e_bgb_machine.unitrigger_stub.origin = e_bgb_machine.origin;
	e_bgb_machine.unitrigger_stub.angles = e_bgb_machine.angles;
	e_bgb_machine.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	e_bgb_machine.unitrigger_stub.cursor_hint = "HINT_NOICON";
	e_bgb_machine.unitrigger_stub.script_width = width;
	e_bgb_machine.unitrigger_stub.script_height = height;
	e_bgb_machine.unitrigger_stub.script_length = length;
	e_bgb_machine.unitrigger_stub.require_look_at = false;
	e_bgb_machine.unitrigger_stub.n_machine_index = n_machine_index;
	
	e_bgb_machine.unitrigger_stub.prompt_and_visibility_func = &bgb_trigger_visibility;
	zm_unitrigger::register_static_unitrigger( e_bgb_machine.unitrigger_stub, &bgb_trigger_think );
}
	
// self = unitrigger
function bgb_trigger_visibility( player )
{
	// is there a bgb machine at this location?
	n_machine_index = self.stub.n_machine_index;
	n_bgb_state = level.bgb_machine[ n_machine_index ].state;

	switch( n_bgb_state )
	{
		case 0:
			// has player used their bubblegum buff allowance yet?
			if( ( isdefined( player.can_use_bubblegum_buff ) && player.can_use_bubblegum_buff ) )
			{
				self SetHintString( &"ZOMBIE_BGB_AVAILABLE" );
			}
			else
			{
				self SetHintString( &"ZOMBIE_BGB_COMEBACK" );
			}
			break;
		case 1:
			self SetHintString( &"ZOMBIE_BGB_BUSY" );
			break;
		case 3:
		case 4:
		case 5:
			self SetHintString( &"ZOMBIE_BGB_AWAY" );
			break;
		case 6:
			self SetHintString( &"ZOMBIE_BGB_DISABLED" );
			break;
		default:
			break;
	}

	// visibility
	b_is_invis = ( isdefined( player.beastmode ) && player.beastmode );
	self setInvisibleToPlayer( player, b_is_invis );
	
	return !b_is_invis;
}

// self = unitrigger
function bgb_trigger_think()
{
	n_machine_index = self.stub.n_machine_index;
	
	while( true )
	{
		self waittill( "trigger", player ); // wait until someone uses the trigger

		if( !( isdefined( player.can_use_bubblegum_buff ) && player.can_use_bubblegum_buff ) )
		{
			continue;
		}
			
		if( level.bgb_machine[ n_machine_index ].state !== 0 ) // must have available machine
		{
			continue;
		}

		if( player zm_utility::in_revive_trigger() ) // revive triggers override trap triggers
		{
			continue;
		}
		
		if( ( player.is_drinking > 0 ) )
		{
			continue;
		}
	
		if( !zm_utility::is_player_valid( player ) ) // ensure valid player
		{
			continue;
		}
		
		level thread bgb_trigger_activate( self.stub, player );
		
		break;
	}
}

function bgb_trigger_activate( trig_stub, player )
{
	n_machine_index = trig_stub.n_machine_index;
	
	level.bgb_machine[ n_machine_index ].state = 1;
	player.can_use_bubblegum_buff = false;
	
	// deliver bgb
	keys = GetArrayKeys( level.bgb );
	keys = array::randomize( keys ); // get random buff
	player bgb_gumball_anim( keys[0], false );
	
	// should the machine still be available?
	level.bgb_machine[ n_machine_index ].times_until_next_move--;
	if( level.bgb_machine[ n_machine_index ].times_until_next_move == 0 )
	{
		bgb_move( n_machine_index );
	}
	else // make available again
	{
		level.bgb_machine[ n_machine_index ].state = 0;
	}

	// update the trigger's visibility
	trig_stub zm_unitrigger::run_visibility_function_for_all_triggers();
}

// self = player
function bgb_player_monitor()
{
	self endon( "disconnect" );
	
	while( true )
	{
		level waittill( "end_of_round" );
		
		// get your ability to grab a bubblegum buff back every round
		self.can_use_bubblegum_buff = true;
	}
}

function private setup_devgui()
{
/#
	waittillframeend;

	SetDvar( "bgb_acquire_devgui", "" );

	bgb_devgui_base = "devgui_cmd \"ZM/BubbleGum Buffs/";
	keys = GetArrayKeys( level.bgb );
	foreach ( key in keys )
	{
		AddDebugCommand( bgb_devgui_base + key + "\" \"set " + "bgb_acquire_devgui" + " " + key + "\" \n");
	}

	AddDebugCommand( bgb_devgui_base + "Clear Current\" \"set " + "bgb_acquire_devgui" + " " + "none" + "\" \n");

	level thread bgb_devgui_think();
#/
}


/#
function private bgb_devgui_think()
{
	for ( ;; )
	{
		bgb_name = GetDvarString( "bgb_acquire_devgui" );

		if ( bgb_name != "" )
		{
			players = GetPlayers();
			for ( i = 0; i < players.size; i++ )
			{
				players[i] thread bgb_gumball_anim( bgb_name, false );
			}
		}
	
		SetDvar( "bgb_acquire_devgui", "" );
		
		wait( 0.5 );
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


function private bgb_gumball_anim( bgb, activating )
{
	self endon( "disconnect" );
	self endon( "end_game" );

	gun = self bgb_play_gumball_anim_begin( bgb, activating );
	evt = self util::waittill_any_return( "fake_death", "death", "player_downed", "weapon_change_complete" );

	if ( evt == "weapon_change_complete" )
	{
		if ( activating )
		{
			self thread [[level.bgb[bgb].activation_func]]();
		}
		else
		{
			self thread give( bgb );
		}
	}
	
	// restore player controls and movement
	self bgb_play_gumball_anim_end( gun, bgb, activating );
}


function private bgb_get_gumball_anim_weapon( bgb, activating )
{
	if ( activating )
	{
		return level.weaponBGBUseActivated;
	}
	else if ( "activation" == level.bgb[bgb].limit_type )
	{
		return level.weaponBGBGrabActivated;
	}

	return level.weaponBGBGrabPassive;
}


function private bgb_play_gumball_anim_begin( bgb, activating )
{
	self zm_utility::increment_is_drinking();
	
	self zm_utility::disable_player_move_states(true);

	original_weapon = self GetCurrentWeapon();
	
	weapon = bgb_get_gumball_anim_weapon( bgb, activating );

	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );

	return original_weapon;
}


function private bgb_play_gumball_anim_end( original_weapon, bgb, activating )
{
	Assert( !original_weapon.isPerkBottle );
	Assert( original_weapon != level.weaponReviveTool );

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


function private bgb_clear_monitors()
{
	self notify( "bgb_limit_monitor" );
	self notify( "bgb_activation_monitor" );
}


function private bgb_limit_monitor()
{
	self endon( "disconnect" );

	self notify( "bgb_limit_monitor" );
	self endon( "bgb_limit_monitor" );

	switch ( level.bgb[self.bgb].limit_type )
	{
	case "activation":
		self thread bgb_activation_monitor();

		for ( i = 0; i < level.bgb[self.bgb].limit; i++ )
		{
			self thread bgb_set_debug_text( self.bgb, level.bgb[self.bgb].limit - i );
			self waittill( "bgb_activation" );
		}
		break;

	case "time":
		self thread bgb_set_debug_text( self.bgb );
		wait( level.bgb[self.bgb].limit );
		break;

	case "rounds":
		self thread bgb_set_debug_text( self.bgb );
		for ( i = 0; i < level.bgb[self.bgb].limit + 1; i++ ) // + 1 to make the count full rounds
		{
			level waittill( "end_of_round" );
		}
		break;

	case "event":
		self thread bgb_set_debug_text( self.bgb );
		self [[level.bgb[self.bgb].limit]]();
		break;

	default:
		assert( false, "bgb::bgb_limit_monitor(): BGB '" + self.bgb + "': limit_type '" + level.bgb[self.bgb].limit_type + "' is not supported" );
	}

	self thread take();
}


function private bgb_activation_monitor()
{
	self endon( "disconnect" );

	self notify( "bgb_activation_monitor" );
	self endon( "bgb_activation_monitor" );

	if ( "activation" != level.bgb[self.bgb].limit_type )
	{
		return;
	}

	for ( ;; )
	{
		if ( !self ActionSlotTwoButtonPressed() )
		{
			wait( 0.05 );
		}
		else
		{
			self bgb_gumball_anim( self.bgb, true );

			self notify( "bgb_activation", self.bgb );

			for ( ;; )
			{
				wait( 0.05 );

				if ( !self ActionSlotTwoButtonPressed() )
				{
					break;
				}
			}
		}
	}
}


/@
"Name: register( <name>, <limit_type>, <limit>, <activation_func> )"
"Summary: Register a BGB
"Module: BGB"
"MandatoryArg: <name> Unique name to identify the BGB.
"MandatoryArg: <limit_type> One of the BGB_LIMIT_TYPE_*'s.
"MandatoryArg: <limit> A function pointer if it is an BGB_LIMIT_TYPE_EVENT to track the limit timeout, an int otherwise to track the limit timeout
"MandatoryArg: <enable_func> Function pointer to run in response to the BGB being given to the player. May be undefined
"MandatoryArg: <disable_func> Function pointer to run in response to the BGB being taken from the player. May be undefined
"MandatoryArg: <activation_func> Function pointer to run in response to an activation. Must be undefined if limit_type is not BGB_LIMIT_TYPE_ACTIVATION.
"Example: level bgb::register( "zm_bgb_im_feelin_lucky", BGB_LIMIT_TYPE_ACTIVATION, 2, &_zm_bgb_im_feelin_lucky::activation );"
"SPMP: both"
@/
function register( name, limit_type, limit, enable_func, disable_func, activation_func )
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
	case "activation":
		assert( IsDefined( activation_func ), "bgb::register(): BGB '" + name + "': activation_func must be defined for limit_type '" + limit_type + "'" );
		assert( IsFunctionPtr( activation_func ), "bgb::register(): BGB '" + name + "': activation_func must be a function pointer for limit_type '" + limit_type + "'" );
		// fallthrough
	case "time":
	case "rounds":
		assert( IsInt( limit ), "bgb::register(): BGB '" + name + "': limit '" + limit + "' must be an int for limit_type '" + limit_type + "'" );
		break;
	case "event":
		assert( IsFunctionPtr( limit ), "bgb::register(): BGB '" + name + "': limit '" + limit + "' must be a function pointer for limit_type '" + limit_type + "'" );
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

	if ( "activation" == limit_type )
	{
		level.bgb[name].activation_func = activation_func;
	}
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

	if ( IsDefined( level.bgb[name].enable_func ) )
	{
		self thread [[level.bgb[name].enable_func]]();
	}

	self thread bgb_limit_monitor();
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

	self notify( "bgb_update", "none", self.bgb );
	self thread bgb_set_debug_text( "none" );

	if ( IsDefined( level.bgb[self.bgb].disable_func ) )
	{
		self thread [[level.bgb[self.bgb].disable_func]]();
	}

	self bgb_clear_monitors();

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
	return (self.bgb == name);
}
