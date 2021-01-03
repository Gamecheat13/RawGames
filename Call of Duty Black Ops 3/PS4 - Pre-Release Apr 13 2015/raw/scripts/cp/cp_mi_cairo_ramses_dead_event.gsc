#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;

#using scripts\shared\vehicles\_hunter;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_objectives;
#using scripts\cp\_dialog;
#using scripts\cp\_oed;

#using scripts\cp\cp_mi_cairo_ramses3_fx;
#using scripts\cp\cp_mi_cairo_ramses3_sound;
#using scripts\cp\cp_mi_cairo_ramses_dead_system;
#using scripts\cp\cp_mi_cairo_ramses_utility;

#precache( "lui_menu", "DeadSystemOverlay" );
#precache( "lui_menu_data", "weaponStatus" );
#precache( "lui_menu_data", "healthbar1" );
#precache( "lui_menu_data", "healthbar2" );
#precache( "string", "Firing" );
#precache( "string", "WeaponRDY" );
#precache( "lui_menu", "DeadSystemWeaponTutorial" );
#precache( "lui_menu", "DeadSystemAimFireTutorial" );
#precache( "objective", "cp_level_ramses_dead_control_panel" );
#precache( "objective", "cp_level_ramses_dead_event_targets" );
#precache( "objective", "cp_level_ramses_dead_turret_marker" );
#precache( "model", "p7_grid_dead_system_01" );
#precache( "model", "p7_tech_panel_metal_01" );
#precache( "triggerstring", "CP_MI_CAIRO_RAMSES_HACK_DEAD" );

function main()
{
	precache();
	
	flag::init( "dead_event_complete" );
	
	level setup_threat_bias();
	
	callback::on_connect( &dead_event_player_connect );
	callback::on_disconnect( &dead_event_player_disconnect );
	callback::on_spawned( &dead_event_player_spawned );
	
	//level.vehicle_main_callback["hunter"] = &hunter_callback;
	
	scene::add_scene_func( "cin_gen_player_hack", &hacking_scene_complete, "done" );
	
	foreach( player in level.players )
	{
		player thread player_threat_bias_group();
	}
	
	level thread dead_turret_interact();
	
	level thread start_freeway_destruction_logic();
	level thread khalil_scenes();
	level thread hendricks_moves_to_freeway();
	
	flag::wait_till( "player_has_dead_control" );
	
	level thread mission_complete();
	
//	level thread debug_increase_bullet_range();
//	level thread start_dead_event_enemy_logic();
}

function precache()
{
	// DO ALL PRECACHING HERE
}

function init_heroes( str_objective )
{
	level.ai_hendricks = util::get_hero( "hendricks" );
	level.ai_khalil = util::get_hero( "khalil" );
		
    skipto::teleport_ai( str_objective );
    
    if( IsDefined( level.ai_khalil ) )
    {
    	level.ai_khalil colors::set_force_color( "o" );
    }
}

function pre_skipto()
{
	level setup_threat_bias();
	
	trigger::wait_till( "dead_event_pre_skipto" );
	
	level thread dead_event_start_ambient_combat();
}

function initial_reinforcements()
{
	a_ai = spawner::simple_spawn( "dead_event_initial_reinforcements" );
}

/***********************************
 * DEAD TURRET CONTROL
 * ********************************/

function dead_event_player_connect() // self = player
{
	self.has_dead_control = false;
	self.a_e_dead_turrets = [];
	self.n_max_dead_turrets = 0;
	
	self thread player_threat_bias_group();
	
	// Make sure the interact trigger is visible to this dude
	foreach( trigger in level.a_t_dead_turret_interacts )
	{
		trigger SetVisibleToPlayer( self );
	}
	
	objectives::show( "cp_level_ramses_dead_control_panel", self );
}

function dead_event_player_disconnect() // self = player
{
	if( IsDefined( self.a_e_dead_turrets ) )
	{
		foreach( e_turret in self.a_e_dead_turrets )
		{
			e_turret.dead_turret_owned = false;
		}	
	}
	
	level assign_max_possible_turrets_per_player();
	level reassign_dead_turrets();
}

function dead_event_player_spawned() // self = player
{
	if( ( isdefined( self.has_dead_control ) && self.has_dead_control )  && !(self HasWeapon( level.DEAD_CONTROL_WEAPON )) )
	{
		self GiveWeapon( level.DEAD_CONTROL_WEAPON );
		self SetActionSlot( 4, "weapon", level.DEAD_CONTROL_WEAPON );
		
		self thread dead_control_weapon_check();
	}
}

function remove_all_dead_control() // self = player
{
	if( IsDefined( self.a_e_dead_turrets ) )
	{
		foreach( e_turret in self.a_e_dead_turrets )
		{
			e_turret thread oed::disable_keyline();
		}
		
		self.a_e_dead_turrets = [];
	}
	
	self notify( "dead_control_stop" );
	self TakeWeapon( level.DEAD_CONTROL_WEAPON );	
}

// Setup Dead Turret Interact Triggers and Markers
function dead_turret_interact()
{
	level.a_t_dead_turret_interacts = [];
	
	// Spawn panel to save ents - p7_tech_panel_metal_01 - used in interview room area
	s_dead_system_panel_spot = struct::get( "dead_turret_panel", "targetname" );
	mdl_dead_panel = util::spawn_model( s_dead_system_panel_spot.model, s_dead_system_panel_spot.origin, s_dead_system_panel_spot.angles );
	mdl_dead_panel.targetname = "dead_turret_panel";
	
	a_t_dead = GetEntArray( "use_dead_turret", "targetname" );
	foreach( trigger in a_t_dead )
	{
		level.a_t_dead_turret_interacts[ level.a_t_dead_turret_interacts.size ] = trigger;
		trigger thread dead_turret_interact_think();
	}	
}

function dead_turret_interact_think() // self = trigger
{
	self SetHintString( &"CP_MI_CAIRO_RAMSES_HACK_DEAD" );
	
	e_panel = GetEnt( "dead_turret_panel", "targetname" );

	objectives::set( "cp_level_ramses_dead_control_panel", e_panel );
	
	while( 1 )
	{
		self waittill( "trigger", e_player );
	
		if( IsPlayer( e_player ) && !( isdefined( e_player.has_dead_control ) && e_player.has_dead_control ) && !( isdefined( self.dead_turret_interact_in_use ) && self.dead_turret_interact_in_use ) )
		{
			self SetInvisibleToAll();
			objectives::hide( "cp_level_ramses_dead_control_panel", e_player );
			self.dead_turret_interact_in_use = true;
			
			e_player scene::play( "cin_gen_player_hack", e_player );
			
			e_player give_player_dead_control();
			
			level flag::set( "player_has_dead_control" );
			self.dead_turret_interact_in_use = false;
			self make_dead_turret_interact_trigger_visible();
		}			
	}
}

function make_dead_turret_interact_trigger_visible() // self = trigger
{
	foreach( player in level.players )
	{
		if( !( isdefined( player.has_dead_control ) && player.has_dead_control ) )
		{
			self SetVisibleToPlayer( player );
		}
	}
}

function give_player_dead_control() // self = player
{
	self.has_dead_control = true;
	self.a_e_dead_turrets = [];
	
	self flag::init( "dead_aim_too_low" );
	self flag::init( "dead_ads_change" );
	self flag::init( "dead_weapon_status_firing" );
	self flag::init( "show_health_bar" );
	self flag::init( "hide_health_bar" );
	self flag::init( "dead_system_ui_anim_playing" );
	self flag::init( "dead_system_aim_fire_tutorial" );
	
	level assign_max_possible_turrets_per_player();
	level reassign_dead_turrets();	

	self clientfield::set_to_player( "dead_event_gridlines", 1 );
	
	self GiveWeapon( level.DEAD_CONTROL_WEAPON );
	self SetActionSlot( 4, "weapon", level.DEAD_CONTROL_WEAPON );
	self thread dead_control_weapon_check();
	
	self thread dead_weapon_switch_tutorial();
}

function assign_max_possible_turrets_per_player()
{
	n_player_count = level.players.size;
	
	foreach( player in level.players )
	{
		if( ( isdefined( player.has_dead_control ) && player.has_dead_control ) )
		{
			if( n_player_count == 1 )
			{
				// *** In a SOLO game, the player gets control of all 4 turrets ***
				player.n_max_dead_turrets = 4;
			}
			else if( n_player_count == 2 )
			{
				// *** In a 2 player game, each player gets control of 2 turrets ***
				player.n_max_dead_turrets = 2;
			}
			else if( n_player_count == 3 )
			{
				// *** In a 3 player game, one player gets control of 2 turrets, the other two players get control of 1 turret each ***
				n_turrets_owned = get_number_dead_turrets_owned();
				
				if( n_turrets_owned >= 2 )
				{
					player.n_max_dead_turrets = 1;	
				}
				else
				{
					player.n_max_dead_turrets = 2;
				}
			}
			else if( n_player_count == 4 )
			{
				// *** In a 4 player game, each player gets control of 1 turret ***
				player.n_max_dead_turrets = 1;
			}
		}
	}	
}

function get_number_dead_turrets_owned() // self = level
{
	n_turrets_owned = 0;

	foreach( player in level.players )
	{
		if( IsDefined( player.a_e_dead_turrets ) )
		{
			n_turrets_owned+= player.a_e_dead_turrets.size;	
		}
	}
	
	return n_turrets_owned;
}

// TODO - test drop-in, drop-out co-op (especially three players)
function reassign_dead_turrets() // self = level
{
	foreach( player in level.players )
	{
		if( ( isdefined( player.has_dead_control ) && player.has_dead_control ) )
		{
			if( player.a_e_dead_turrets.size < player.n_max_dead_turrets )
			{
				// GIVE PLAYER CONTROL OF MORE TURRETS UNTIL THEY'RE AT THE MAX

				n_turrets_needed = player.n_max_dead_turrets - player.a_e_dead_turrets.size;
				
				foreach( e_turret in level.a_e_dead_turrets )
				{
					if( !( isdefined( e_turret.dead_turret_owned ) && e_turret.dead_turret_owned ) )
					{ 
						player.a_e_dead_turrets[ player.a_e_dead_turrets.size ] = e_turret;
						n_turrets_needed--;
					}
					
					if( n_turrets_needed == 0 )
					{
						break;	
					}
				}
			}
			else if( player.a_e_dead_turrets.size > player.n_max_dead_turrets )
			{
				// TAKE TURRETS AWAY
				
				n_turrets_to_take = player.a_e_dead_turrets.size - player.n_max_dead_turrets;
				
				foreach( e_turret in player.a_e_dead_turrets )
				{
					// remove the turret from the array
					ArrayRemoveValue( player.a_e_dead_turrets, e_turret );
					e_turret.dead_turret_owned = false;
					
					n_turrets_to_take--;
					if( n_turrets_to_take == 0 )
					{
						break;	
					}
				}
			}
		}
	}
	
	// Set the Owners of each player's turrets
	foreach( player in level.players )
	{
		if( ( isdefined( player.has_dead_control ) && player.has_dead_control ) )
		{
			foreach( e_turret in player.a_e_dead_turrets )
			{
				e_turret oed::enable_keyline( true );
				e_turret SetOwner( player );
				e_turret.dead_turret_owned = true;
			}
			
			// TODO - This is a hack because keylines cannot be enabled on a per player basis
			objectives::set( "cp_level_ramses_dead_turret_marker", player.a_e_dead_turrets );
			objectives::hide( "cp_level_ramses_dead_turret_marker" );
			objectives::show( "cp_level_ramses_dead_turret_marker", player );
		}
	}
}

function dead_control_weapon_check() // self = player
{
	self endon( "death_or_disconnect" );
	
	while( 1 )
	{		
		self waittill( "weapon_change", newWeapon );

		if( newWeapon == level.DEAD_CONTROL_WEAPON)
		{
			// Player Equipped the DEAD CONTROL WEAPON	
			self thread player_dead_control_think();
			self thread show_dead_turret_ui();
		}
		else
		{
			// Player Unequipped the DEAD CONTROL WEAPON	
			self notify( "dead_control_stop" );
			self thread hide_dead_turret_ui();
		}
	}
}

function dead_weapon_switch_tutorial() // self = player
{
	self endon( "death_or_disconnect" );
	self endon( "dead_control_stop" );
	
	w_current = self GetCurrentWeapon();

	if(  w_current != level.DEAD_CONTROL_WEAPON )
	{
		hint = self OpenLUIMenu( "DeadSystemWeaponTutorial" );
			
		self ramses_util::wait_till_weapon_held( level.DEAD_CONTROL_WEAPON, "dead_control_stop" );
		
		self CloseLUIMenu( hint );	
	}
	
	// Small delay before showing the fire tutorial to allow the Dead Control Hands animation to start
	wait 2.0;
	
	self thread dead_system_aim_fire_tutorial();
}

function dead_system_aim_fire_tutorial()  // self = player
{
	self endon( "death_or_disconnect" );
	self endon( "dead_control_stop" );

	w_current = self GetCurrentWeapon();

	if(  w_current == level.DEAD_CONTROL_WEAPON )
	{
		if( flag::get( "dead_system_aim_fire_tutorial" ) )
		{
			return;		
		}
		
		self flag::set( "dead_system_aim_fire_tutorial" );
		              
		hint = self OpenLUIMenu( "DeadSystemAimFireTutorial" );
			
		// Delay - this is how long the player sees the tutorial message for
		wait 5.0;
		
		self CloseLUIMenu( hint );
		
		// COOLDOWN
		wait 30.0;
		
		self flag::clear( "dead_system_aim_fire_tutorial" );
	}	
}

function player_dead_control_think() // self = player
{
	self endon( "death_or_disconnect" );
	self endon( "dead_control_stop" );
	
	foreach( turret in self.a_e_dead_turrets )
	{
		self thread player_aim_dead_turret( turret );
	}
	
	while( 1 )
	{
		if( self util::ads_button_held() )
		{
			if( !( self flag::get( "dead_ads_change" ) ) )
			{
				self flag::set( "dead_ads_change" );
				self thread show_ads_reticule();
			}
			
			if( self AttackButtonPressed()  && (IsDefined(self.deadTarget) && self.deadLockFinalized))
			{
				if( !(self flag::get( "dead_aim_too_low" ) ) )
				{
					self thread ui_text_firing();
					
					// Make the turret fire
					array::thread_all( self.a_e_dead_turrets, &turret::fire_for_time, 0.05 );	
				}
				else
				{
					// Prevent the player from firing the turret if he's aiming too low
					self thread show_weaponanglelow_text();
				}
			}
			else
			{
				if( self flag::get( "dead_weapon_status_firing" ) )
				{
					self flag::clear( "dead_weapon_status_firing" );
					self thread ui_text_weapon_rdy();
				}
			}
		}
		else
		{
			if( self flag::get( "dead_ads_change" ) ) 
			{
				self flag::clear( "dead_ads_change" );
				self thread hide_ads_reticule();
			}

			if( self flag::get( "dead_weapon_status_firing" ) )
			{
				self flag::clear( "dead_weapon_status_firing" );
				self thread ui_text_weapon_rdy();
			}
			
//			if( self AttackButtonPressed() )
//			{
//				self thread dead_system_aim_fire_tutorial();
//			}
		}
		
		wait 0.05;
	}
}

// HACK - all of these #define waits are here because we can't query the length of a UI animation

function show_weaponanglelow_text() // self = player
{
    if ( !isDefined( self.playing_show_anim ) )
    {
    	self wait_till_ui_anim_playing_cleared();
    	
    	self flag::set( "dead_system_ui_anim_playing" );
    	
    	self.playing_show_anim = true;
    	if( isdefined( self.dead_system_ui ) )
    	{
    		self lui::play_animation( self.dead_system_ui, "wpnAngleTextShow" );	
    	}
    	
        wait( 1.0 );
        self.playing_show_anim = undefined;
        
        self flag::clear( "dead_system_ui_anim_playing" );
    }    
}


function show_ads_reticule() // self = player
{
    self endon( "death_or_disconnect" );
    self endon( "dead_control_stop" );
    self notify( "show_ads_logic_running" );
	self endon( "show_ads_logic_running" );
	
	if ( !isDefined( self.playing_ads_show_anim ) )
    {
        while( ( isdefined( self.playing_ads_hide_anim ) && self.playing_ads_hide_anim ) && IsDefined( self.dead_system_ui ) )
    	{
    		wait 0.05;	
    	}
        
    	self wait_till_ui_anim_playing_cleared();
    	
    	self flag::set( "dead_system_ui_anim_playing" );
    	
    	self.playing_ads_show_anim = true;
        if( isdefined( self.dead_system_ui ) )
        {
			self lui::play_animation( self.dead_system_ui, "ADS_ON" );    	
        }
        wait( 0.2 );
        self.playing_ads_show_anim = undefined;
        
        self flag::clear( "dead_system_ui_anim_playing" );
    }    
}

function hide_ads_reticule() // self = player
{
   	self endon( "death_or_disconnect" );
   	self endon( "dead_control_stop" );
    self notify( "hide_ads_logic_running" );
   	self endon( "hide_ads_logic_running" );
   	
   	if ( !isDefined( self.playing_ads_hide_anim ) )
    {
    	while( ( isdefined( self.playing_ads_show_anim ) && self.playing_ads_show_anim ) && IsDefined( self.dead_system_ui ) )
    	{
    		wait 0.05;	
    	}
    	
    	self wait_till_ui_anim_playing_cleared();
    	
    	self flag::set( "dead_system_ui_anim_playing" );
    	
    	self thread hide_health_bar();
    	
    	self.playing_ads_hide_anim = true;
        if( isdefined( self.dead_system_ui ) )
        {
        	self lui::play_animation( self.dead_system_ui, "ADS_OFF" );	
        }
    	wait( 0.2 );
        self.playing_ads_hide_anim = undefined;
        
        self flag::clear( "dead_system_ui_anim_playing" );
    }    
}

function ui_text_firing()	// self = player
{
	self endon( "death_or_disconnect" );
	self endon( "dead_control_stop" );
	
	if( IsDefined( self.dead_system_ui ) )
	{
		self wait_till_ui_anim_playing_cleared();
    	
    	self flag::set( "dead_system_ui_anim_playing" );
		
		self SetLUIMenuData( self.dead_system_ui, "weaponStatus", "Firing" );
		self flag::set( "dead_weapon_status_firing" );
		
		self flag::clear( "dead_system_ui_anim_playing" );
	}
}

function ui_text_weapon_rdy()	// self = player
{
	self endon( "death_or_disconnect" );
	self endon( "dead_control_stop" );
	
	if( IsDefined( self.dead_system_ui ) )
	{
		self wait_till_ui_anim_playing_cleared();
    	
    	self flag::set( "dead_system_ui_anim_playing" );
		
		self SetLUIMenuData( self.dead_system_ui, "weaponStatus", "WeaponRDY" );
		self flag::clear( "dead_weapon_status_firing" );
		
		self flag::clear( "dead_system_ui_anim_playing" );
	}
}


function reticule_red()	// self = player
{
    self endon( "death_or_disconnect" );
	self endon( "dead_control_stop" );
	
	if ( !isDefined( self.playing_reticule_red_anim ) )
    {
        self wait_till_ui_anim_playing_cleared();
    	
    	self flag::set( "dead_system_ui_anim_playing" );
    	
    	self.playing_reticule_red_anim = true;
        if( isdefined( self.dead_system_ui ) )
        {
        	self lui::play_animation( self.dead_system_ui, "ReticuleRed" );	
        }
        wait( 0.1 );
        self.playing_reticule_red_anim = undefined;
        
        self flag::clear( "dead_system_ui_anim_playing" );
    }   
}

function reticule_white() // self = player
{
    self endon( "death_or_disconnect" );
	self endon( "dead_control_stop" );
	
	if ( !isDefined( self.playing_reticule_white_anim ) )
    {
		self wait_till_ui_anim_playing_cleared();
    	
    	self flag::set( "dead_system_ui_anim_playing" );

    	self.playing_reticule_white_anim = true;
        if( isdefined( self.dead_system_ui ) )
        {
        	self lui::play_animation( self.dead_system_ui, "ReticuleWhite" );	
        }
        wait( 0.1 );
        self.playing_reticule_white_anim = undefined;
        
        self flag::clear( "dead_system_ui_anim_playing" );
    }   
}


function show_health_bar() // self = player
{
	self endon( "death_or_disconnect" );
	self endon( "dead_control_stop" );
	
	if( flag::get( "show_health_bar" ) )
	{
		return;	
	}
	
	if( ( isdefined( self.show_health_bar ) && self.show_health_bar ) )
	{
		return;	
	}
	
	while( IsDefined( self.dead_system_ui ) && !self flag::get( "show_health_bar" ) )
	{
		if( !( isdefined( self.show_health_bar ) && self.show_health_bar ) && !( isdefined( self.playing_health_show_anim ) && self.playing_health_show_anim ) && !( isdefined( self.playing_health_hide_anim ) && self.playing_health_hide_anim ) )
        {
			flag::set( "show_health_bar" );
        	return;
        }
		
		wait 0.05;
	}  
}

function hide_health_bar() // self = player
{	
	self endon( "death_or_disconnect" );
	self endon( "dead_control_stop" );
	
	if( flag::get( "hide_health_bar" ) )
	{
		return;	
	}
	
	if( !( isdefined( self.show_health_bar ) && self.show_health_bar ) )
	{
		return;	
	}
	
	while( IsDefined( self.dead_system_ui )&& !self flag::get( "hide_health_bar" ) )
	{
		if( ( isdefined( self.show_health_bar ) && self.show_health_bar ) && !( isdefined( self.playing_health_hide_anim ) && self.playing_health_hide_anim ) && !( isdefined( self.playing_health_show_anim ) && self.playing_health_show_anim ) )
		{
			flag::set( "hide_health_bar" );
			return;
		}
		
		wait 0.05;
	} 
}

function handle_show_health_bar_animation() // self = player
{
	self endon( "death_or_disconnect" );
	self endon( "dead_control_stop" );
	
	while( IsDefined( self.dead_system_ui ) )
	{
		flag::wait_till( "show_health_bar" );
		
		self wait_till_ui_anim_playing_cleared();
    	
    	self flag::set( "dead_system_ui_anim_playing" );
		
		self.show_health_bar = true;
		self.playing_health_show_anim = true;
	    if( isdefined( self.dead_system_ui ) )
	    {
	    	self lui::play_animation( self.dead_system_ui, "ShowHealthBar" );	
	    }
	    wait( 0.1 );
	    self.playing_health_show_anim = undefined;

	    flag::clear( "show_health_bar" );
	    
	    self flag::clear( "dead_system_ui_anim_playing" );
	}
}

function handle_hide_health_bar_animation() // self = player
{
	self endon( "death_or_disconnect" );
	self endon( "dead_control_stop" );
	
	while( IsDefined( self.dead_system_ui ) )
	{
		flag::wait_till( "hide_health_bar" );
		
		self wait_till_ui_anim_playing_cleared();
    	
    	self flag::set( "dead_system_ui_anim_playing" );
		
		self.show_health_bar = false;
		self.playing_health_hide_anim = true;
        if( isdefined( self.dead_system_ui ) )
        {
        	self lui::play_animation( self.dead_system_ui, "HideHealthBar" );	
        }
        wait( 0.1 );
        self.playing_health_hide_anim = undefined;

	    flag::clear( "hide_health_bar" );
	    
	    self flag::clear( "dead_system_ui_anim_playing" );
	}
}







function update_target_health_bars( e_target ) // self = player
{	
	self endon( "death_or_disconnect" );
	self endon( "dead_control_stop" );
	e_target endon( "target_changed" );
	
	if( !IsDefined( e_target ) )
	{
		return;	
	}
	
	if (!IsDefined( self.dead_system_ui ) )
	{
		return;	
	}
		
	if( IsDefined( e_target.n_max_health ) )
	{
		n_max_health = e_target.n_max_health;		
	}
	else
	{
		return;	
	}
	
	// Animate the health bars to visible
	self thread show_health_bar();
	
	do
	{	
		if( e_target.health <= 0 )
		{
			// If the target is dead, both health bars should be empty
			self SetLUIMenuData( self.dead_system_ui, "healthbar1", 0 );
			self SetLUIMenuData( self.dead_system_ui, "healthbar2", 0 );
			
			break;
		}
		// If the target's health is over 50%, the first bar is partially full and the second bar is full
		else if( e_target.health > (n_max_health/2) )
		{
			n_scale = math::linear_map( e_target.health, (n_max_health/2), n_max_health, 0, 1.0 );
			
			self SetLUIMenuData( self.dead_system_ui, "healthbar1", n_scale );
			self SetLUIMenuData( self.dead_system_ui, "healthbar2", 1.0 );
		}
		// If the target's health is under 50%, the first bar is empty and the second bar is partially full
		else
		{
			n_scale = math::linear_map( e_target.health, 0, (n_max_health/2), 0, 1.0 );
			
			self SetLUIMenuData( self.dead_system_ui, "healthbar1", 0 );
			self SetLUIMenuData( self.dead_system_ui, "healthbar2", n_scale );
		}

		wait 0.05;

		e_target waittill( "damage" );
	}
	while( IsDefined( self.dead_system_ui ) && IsDefined( e_target ) );
}

// The DEAD turret aims at the current target lock if any, or at where the player is looking

function player_aim_dead_turret( e_turret ) // self = player
{
	self endon( "death_or_disconnect" );
	self endon( "dead_control_stop" );
	
	while( 1 )
	{
			v_player_angles = self GetPlayerAngles();
			v_player_forward = AnglesToForward( v_player_angles );
			
			v_start = self GetEye() + v_player_forward * 1000;
			v_end = v_start + v_player_forward * 100000;
			
			// Prevent the player from firing the turret if he's aiming too low
			if( v_end[ 2 ] <= 2000 )
			{
				self flag::set( "dead_aim_too_low" );
			}
			else
			{
				self flag::clear( "dead_aim_too_low" );
			}
			
		if (IsDefined(self.deadTarget))
		{
			e_turret SetTurretTargetEnt( self.deadTarget, (0,0,0) );
		}
		else
		{
			a_trace = BulletTrace( v_start, v_end, true, self );
			v_trace = a_trace[ "position" ];
			
			e_turret SetTurretTargetVec( v_trace );
		}	
		
		wait 0.05;
	}
}

function show_dead_turret_ui() // self = player
{
	// Open the UI MENU
	self.dead_system_ui = self OpenLUIMenu( "DeadSystemOverlay" );
	
	// Init LUI Datasets
	self SetLUIMenuData( self.dead_system_ui, "weaponStatus", "" );
	self SetLUIMenuData( self.dead_system_ui, "healthbar1", 1.0 );
	self SetLUIMenuData( self.dead_system_ui, "healthbar2", 1.0 );
	
	// Init "Weapon Rdy" Text
	self thread ui_text_weapon_rdy();
	
	// Kick off Health bar threads
	self thread handle_show_health_bar_animation();
	self thread handle_hide_health_bar_animation();
	
	// Show the Gridlines
	self clientfield::set_to_player( "dead_event_gridlines", 1 );
	
	// Show the Hunter markers
	objectives::show( "cp_level_ramses_dead_event_targets", self );
}

function hide_dead_turret_ui() // self = player
{	
	// Close the UI MENU
	if( IsDefined( self.dead_system_ui ) )
	{
		self CloseLUIMenu( self.dead_system_ui );	
		self.dead_system_ui = undefined;
	}
	
	// Hide the Gridlines
	self clientfield::set_to_player( "dead_event_gridlines", 0 );

	// Hide the Hunter markers
	objectives::hide( "cp_level_ramses_dead_event_targets", self );	
	
	// Clear flags
	self flag::clear( "dead_system_ui_anim_playing" );
	self flag::clear( "dead_aim_too_low" );
	self flag::clear( "dead_ads_change" );
	self flag::clear( "dead_weapon_status_firing" );
	self flag::clear( "show_health_bar" );
	self flag::clear( "hide_health_bar" );
	self flag::clear( "dead_system_ui_anim_playing" );
	
	// Clear other UI info
	self.playing_show_anim = undefined;
	self.playing_ads_show_anim = undefined;
	self.playing_ads_hide_anim = undefined;
	self.playing_reticule_red_anim = undefined;
	self.playing_reticule_white_anim = undefined;
	self.show_health_bar = undefined;
	self.playing_health_show_anim = undefined;
	self.playing_health_hide_anim = undefined;
}

// HACK - increased bullet range to get the DEAD Turrets firing far enough
function debug_increase_bullet_range()
{
	n_bullet_range = GetDvarInt( "bulletrange" );
	SetDvar( "bulletrange", 65000 );
	
	flag::wait_till( "dead_event_complete" );
	
	SetDvar( "bulletrange", n_bullet_range );
}

/***********************************
 * UTILITY FUNCTIONS FOR DEAD CONTROL
 * ********************************/ 

function are_all_dead_turrets_owned()
{
	foreach (e_turret in level.a_e_dead_turrets )
	{
		if ( !( isdefined( e_turret.dead_turret_owned ) && e_turret.dead_turret_owned ) )
		{
			return false;	
		}
	}
	
	return true;
}

function wait_till_ui_anim_playing_cleared() // self = player
{
	self endon( "death_or_disconnect" );
	self endon( "dead_control_stop" );
	
	while( self flag::get( "dead_system_ui_anim_playing" ) && IsDefined( self.dead_system_ui ) )
	{
		wait 0.05;	
	}
}

function add_dead_event_target_objective_marker() // self = AI/vehicle target
{
	objectives::set( "cp_level_ramses_dead_event_targets", self );
	
	if( !level flag::get( "player_has_dead_control" ) )
	{
		objectives::hide( "cp_level_ramses_dead_event_targets" );	
	}
	else
	{
		foreach (player in level.players )
		{
			if( !IsDefined( player.dead_system_ui ) )
			{
				objectives::hide( "cp_level_ramses_dead_event_targets", player );	
			}
		}	
	}
}

/***********************************
 * FREEWAY DESTRUCTION
 * ********************************/

function start_freeway_destruction_logic()
{
	// Hide damaged pieces 
	a_e_debris = GetEntArray( "fwy_explode_remains", "targetname" );
	foreach( e_chunk in a_e_debris )
	{
		e_chunk NotSolid();
		e_chunk Hide();
	}
	
	// Set up freeway to be damaged
	a_e_debris = getentarray( "fwy_explode_chunk", "targetname" );
	foreach( e_chunk in a_e_debris )
	{
		e_chunk SetCanDamage( true );
		e_chunk.health = 1;
		e_chunk thread freeway_destruction_think();	
		
		e_chunk SetMovingPlatformEnabled( true );
	}
		
	// Connect traversals
	a_nd_traversal = GetNodeArray( "dead_event_freeway_traversal", "targetname" );
	foreach( node in a_nd_traversal )
	{
		LinkTraversal( node );
	}
}

function freeway_destruction_think()
{
	self endon( "freeway_hit_by_quadtank" );
	
	// Disable cover nodes
	a_nd_cover = GetNodeArray( "dead_event_cover_post_freeway_destruction", "targetname" );
	foreach (nd_cover in a_nd_cover )
	{
		SetEnableNode( nd_cover, false );
	}
	
	while( 1 )
	{
		self waittill( "damage", damage, attacker );
		
		if( IsDefined( attacker.archetype ) && (attacker.archetype == "quadtank" ) )
		{
			level thread freeway_hit_by_quadtank();
			break;
		}
	}
}

function freeway_hit_by_quadtank()
{
	// Delete "healthy" pieces
	a_e_debris = getentarray( "fwy_explode_chunk", "targetname" );
	foreach( e_chunk in a_e_debris )
	{
		e_chunk notify( "freeway_hit_by_quadtank" );
		
		e_chunk SetMovingPlatformEnabled( false );
		
		e_chunk connectpaths();
		e_chunk delete();
	}
	
	// Show "destroyed" pieces
	a_e_debris = getentarray( "fwy_explode_remains", "targetname" );
	foreach( e_chunk in a_e_debris )
	{
		e_chunk Show();
		e_chunk Solid();
		e_chunk disconnectpaths();
	}
	
	// Disable cover nodes
	a_nd_cover = GetNodeArray( "dead_event_cover_pre_freeway_destruction", "targetname" );
	foreach (nd_cover in a_nd_cover )
	{
		SetEnableNode( nd_cover, false );
	}
	
	// Enable cover nodes
	a_nd_cover = GetNodeArray( "dead_event_cover_post_freeway_destruction", "targetname" );
	foreach (nd_cover in a_nd_cover )
	{
		SetEnableNode( nd_cover, true );
	}
	
	// Disconect traversals
	a_nd_traversal = GetNodeArray( "dead_event_freeway_traversal", "targetname" );
	foreach( node in a_nd_traversal )
	{
		LinkTraversal( node );
	}
}

/***********************************
 * LEVEL EVENTS
 * ********************************/
 
function setup_threat_bias()
{
	CreateThreatBiasGroup( "players" );
	CreateThreatBiasGroup( "dead_event_hunters" );
	CreateThreatBiasGroup( "dead_event_egyptian_rpg" );
	
	foreach( player in level.players )
	{
		player thread player_threat_bias_group();
	}
}

function player_threat_bias_group() // self = player
{
	self setthreatbiasgroup( "players" );
}

function dead_event_start_ambient_combat()
{		
	// SPAWN FRIENDLIES
	spawn_manager::enable( "dead_event_egyptian_sm_left" );
	spawn_manager::enable( "dead_event_egyptian_sm_right" );
	a_ai_rpg = spawner::simple_spawn( "dead_event_roof_allies" );
	a_ai_egyptian_starters = spawner::simple_spawn( "dead_event_egyptian_starters" );
	
	foreach( ai_rpg in a_ai_rpg )
	{
		ai_rpg util::magic_bullet_shield();	
		ai_rpg setthreatbiasgroup( "dead_event_egyptian_rpg" );
	}
	
	foreach( ai_starter in a_ai_egyptian_starters )
	{
		ai_starter util::magic_bullet_shield();	
	}
	
	foreach( player in level.players )
	{
		player.ignoreme = true;
	}
	
	// SPAWN NRC ROBOTS
	a_ai_nrc_starters = spawner::simple_spawn( "dead_event_nrc_starters" );
	
	foreach( ai_starter in a_ai_nrc_starters )
	{
		ai_starter util::magic_bullet_shield();	
	}
	
	// SPAWN HUNTERS
	spawner::add_spawn_function_group( "dead_event_hunter", "targetname", &dead_event_hunter_spawn_func );
	
	a_ai_hunters = dead_event_hunter_wave_spawner( 5 );
	//a_ai_hunters = dead_event_hunter_wave_spawner( 1 );
	
	// Make this first wave of Hunters invulnerable until the event actually starts
	foreach( ai_hunter in a_ai_hunters )
	{
		ai_hunter util::magic_bullet_shield();
	}
	
	// Make RPG dudes fire at hunters
	SetThreatBias( "dead_event_hunters", "dead_event_egyptian_rpg", 100000 );
	
	// EVENT BEGINS!!!
	//flag::wait_till( "player_has_dead_control" );
	trigger::wait_till( "player_reached_dead_turrets" );
	
	foreach( player in level.players )
	{
		player.ignoreme = false;
	}
	
	// SPAWN FACTION FIGHT ROBOTS
	spawn_manager::enable( "dead_event_nrc_faction_fight_sm_left" );
	spawn_manager::enable( "dead_event_nrc_faction_fight_sm_right" );
	
	// TURN OFF MAGIC BULLET SHIELD
	
	foreach( ai_hunter in a_ai_hunters )
	{
		if( IsDefined( ai_hunter ) && IsAlive( ai_hunter ) )
		{
			ai_hunter util::stop_magic_bullet_shield();	
		}
	}
	
	foreach( ai_rpg in a_ai_rpg )
	{
		if( IsDefined( ai_rpg ) && IsAlive( ai_rpg ) )
		{
			ai_rpg util::stop_magic_bullet_shield();	
		}
	}
	
	foreach( ai_starter in a_ai_egyptian_starters )
	{
		if( IsDefined( ai_starter ) && IsAlive( ai_starter ) )
		{
			ai_starter util::stop_magic_bullet_shield();	
		}
	}
	
	foreach( ai_starter in a_ai_nrc_starters )
	{
		if( IsDefined( ai_starter ) && IsAlive( ai_starter ) )
		{
			ai_starter util::stop_magic_bullet_shield();
		}
	}
	
	// Delay before aritifically killing off RPG dudes
	wait 10.0;
	
	// HACK - kill off these RPG dudes to prevent a pathing failure when NRC Robots target these guys
	// TODO - show targeting/pathing problem to AI
	// TODO - prevent ground guys from targeting these guys, or kill them off in a better way using magic bullet
	// Kill off RPG dudes
	foreach( ai_rpg in a_ai_rpg )
	{
		if( isdefined( ai_rpg ) && IsAlive( ai_rpg ) )
		{
			ai_rpg dodamage( ai_rpg.health, (0,0,0) );
		}
		
		wait RandomFloatRange( 0.5, 3.0 );
	}
	
	// SET THREAT BIAS FOR FIGHT
	//SetThreatBias( "players", "dead_event_hunters", 700 );
}

// 5, 7, 9
function start_dead_event_enemy_logic()
{	
	// INITIAL WAVE OF 5 HUNTERS SPAWNED IN THE function dead_event_start_ambient_combat
	
	level thread start_dead_event_nrc_reinforcements();

	// Wait until the player kills off the initial wave of Hunters
	level waittill( "dead_event_hunter_wave_killed" );
	
	level thread dead_event_hunter_wave_spawner( 7 );
	spawn_manager::enable( "dead_event_wasp_sm" );
	level waittill( "dead_event_hunter_wave_killed" );
	
	// TODO - better scripting for this
	// ***Only add a third wave of Hunters if we're not playing SOLO
	if( level.players.size > 1 )
	{
		level thread dead_event_hunter_wave_spawner( 9 );
		level waittill( "dead_event_hunter_wave_killed" );	
	}
	
	level thread dead_event_crescendo();
}

function dead_event_hunter_wave_spawner( n_count )
{
	a_sp_hunter = getentarray( "dead_event_hunter", "targetname" );
	a_sp_hunter = array::randomize( a_sp_hunter );

	a_ai_hunters = [];
	
	for( i = 0; i < n_count; i++ )
	{
		ai_hunter = spawner::simple_spawn_single( a_sp_hunter[i] );
		a_ai_hunters[i] = ai_hunter;
		
		ai_hunter thread dead_event_hunter_death_func();
		
		wait( RandomFloatRange( 0.5, 3.0 ) );
	}
	
	level thread hunter_wave_check( a_ai_hunters );
	
	return a_ai_hunters;
}

function dead_event_hunter_death_func() // self = Hunter
{
	self waittill( "death" );
	
	level notify( "dead_event_hunter_killed" );
	
	objectives::complete( "cp_level_ramses_dead_event_targets", self );
}

function hunter_wave_check( a_ai_hunters )
{
	while( 1 )
	{
		b_all_hunters_killed = true;
		
		level waittill( "dead_event_hunter_killed" );
		
		foreach( ai_hunter in a_ai_hunters )
		{
			if( IsAlive( ai_hunter )  )
			{
				b_all_hunters_killed = false;	
				break;
			}
		}
		
		if( b_all_hunters_killed )
		{
			level notify( "dead_event_hunter_wave_killed" );
			break;
		}
	}
}

function dead_event_hunter_spawn_func() // self = Hunter
{
	self endon( "death" );
	
	// TODO - remove these debug calls later
	//self thread hunter_distance_debug();
	//self thread hunter_damage_debug();
	
	self thread hunter_dead_locked_watcher();
	
	// HACK - customize the Hunter's health for this event
	switch( level.players.size )
	{
		case 1:
			self.health = 40000;
		case 2:
			self.health = 30000;
		case 3:
			self.health = 30000;
		case 4:
			self.health = 20000;
		default:
			self.health = 40000;
	}
	
	self.n_max_health = self.health;
	
	// HACK - Ma, Ruoyao
	// delete the corpse after it's dead for 10 seconds
	self.waittime_before_delete = 10;
	self.delete_on_death = true;

	// Set Threat Bias Group
	self thread hunter_threat_bias_group();
		
	n_z_offset = RandomIntRange( 2500, 3500 );
	self SetGoal( self.origin + (0, 0, n_z_offset), true );
	
	self util::waittill_any_timeout( 10, "at_anchor" );
	
	// Handle red diamond UI markers
	self thread add_dead_event_target_objective_marker();
	
	e_goal_volume = GetEnt( "dead_event_goal_volume", "targetname" );
	
	self SetGoal( e_goal_volume );
	
	//add to target array
	Target_Set(self);
}

function hunter_damage_debug()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "damage", damage );
		
		IPrintLnBold( "Hunter Health: " + self.health );
		 
		wait 0.5;
	}
}

function hunter_distance_debug()
{
	self endon( "death" );
	
	e_dead_turret = level.a_e_dead_turrets[0];
	
	while( 1 )
	{
		n_distance = Distance2D( self.origin, e_dead_turret.origin );
		
		IPrintLnBold( "Hunter Distance: " + n_distance );
		
		// wait to prevent an infinite loop
		wait 1.0;
	}
}

function hunter_dead_locked_watcher() // self = Hunter
{
	self endon( "death" );

	ai::set_behavior_attribute("strafe_speed", 30);
	ai::set_behavior_attribute("strafe_distance", 1000);

	while( 1 )
	{
		self waittill( "dead_locked" );

		// If the Hunter gets targeted  by a player, make it strafe
		wait( RandomFloatRange( 0.5, 1.0 ) );
		
		self vehicle_ai::set_state( "strafe" );
		
		// Cooldown
		wait( RandomFloatRange( 10.0, 20.0 ) );
	}
}

function hunter_threat_bias_group() // self = hunter
{
	self setthreatbiasgroup( "dead_event_hunters" );
}

function start_dead_event_nrc_reinforcements()
{	
	spawner::add_spawn_function_group( "dead_event_robot_assault", "script_noteworthy", &dead_event_robot_spawn_func );
	spawner::add_spawn_function_group( "dead_event_robot_cqb", "script_noteworthy", &dead_event_robot_spawn_func );
	//spawner::add_spawn_function_group( "dead_event_wasp", "script_noteworthy", &dead_event_wasp_spawn_func );
	spawner::add_spawn_function_group( "dead_event_wasp_group", "targetname", &dead_event_wasp_group_spawn_func );
	spawner::add_spawn_function_group( "dead_event_quadtank", "targetname", &dead_event_quadtank_spawn_func );
	//spawner::add_spawn_function_group( "dead_event_nrc_faction_fight", "script_noteworthy", &dead_event_nrc_faction_fight_spawn_func );
	
	// VTOL DROPOFF
	level thread dead_event_nrc_vtol_watcher();
	
	// WASP GROUP
	level thread dead_event_wasp_group_spawner();
	
	//TODO - Better timing for this!!!
	wait 20.0;
		
	spawn_manager::enable( "dead_event_robot_sm" );
	
	spawner::simple_spawn_single( "dead_event_quadtank" );
}

// TODO - better scripting for this --> want this to happen once per "wave"
function dead_event_nrc_vtol_watcher()
{
	for( i = 1; i < 3; i++ )
	{
		util::waittill_notify_or_timeout( "dead_event_hunter_wave_killed", 10.0);	
		
		send_nrc_vtol();
	}
}

// TODO - use groups of three wasps
function dead_event_wasp_group_spawner()
{
	level endon( "outro_igc_started" );
	
	while( 1 )
	{
		a_wasp_group = spawner::simple_spawn( "dead_event_wasp_group" );
		
		a_wasp_group thread wasp_group_wave_check( a_wasp_group );
		
		level waittill( "dead_event_wasp_wave_killed" );
		
		wait 10.0;
	}
}

function wasp_group_wave_check( a_wasp_group )
{
	while( 1 )
	{
		b_all_wasps_killed = true;
		
		level waittill( "dead_event_wasp_group_killed" );
		
		foreach( ai_wasp in a_wasp_group )
		{
			if( IsAlive( ai_wasp )  )
			{
				b_all_wasps_killed = false;	
				break;
			}
		}
		
		if( b_all_wasps_killed )
		{
			level notify( "dead_event_wasp_wave_killed" );
			break;
		}
	}
}

function dead_event_robot_spawn_func() // self = AI
{
	self endon( "death" );
	
	e_goal_volume = GetEnt( "dead_event_nrc_robot_goalvolume", "targetname" );
	
	self SetGoal( e_goal_volume );
}

function dead_event_wasp_spawn_func() // self = AI
{
	self endon( "death" );
	
	e_goal_volume = GetEnt( "dead_event_nrc_wasp_goalvolume", "targetname" );
	
	self SetGoal( e_goal_volume );
}

function dead_event_wasp_group_spawn_func() // self = wasp
{
	self endon( "death" );
	
	self thread dead_event_wasp_group_death_func();
	
	self.n_max_health = self.health;
	
	n_z_offset = RandomIntRange( 2000, 3500 );
	self SetGoal( self.origin + (0, 0, n_z_offset), true );
	
	// HACK - wasp's not getting a goal notify right now
	wait 5.0;
	
	self thread add_dead_event_target_objective_marker();
	
	e_goal_volume = GetEnt( "dead_event_goal_volume", "targetname" );
	
	self SetGoal( e_goal_volume );
	
	//add to target array
	Target_Set(self);
}

function dead_event_wasp_group_death_func()
{
	self waittill( "death" );
	
	level notify( "dead_event_wasp_group_killed" );
	
	objectives::complete( "cp_level_ramses_dead_event_targets", self );
}

function dead_event_nrc_faction_fight_spawn_func() // self = AI
{
	self endon( "death" );
	
	e_goal_volume = GetEnt( "dead_event_nrc_faction_fight_goal_volume", "targetname" );
	
	self SetGoal( e_goal_volume );	
}

function dead_event_quadtank_spawn_func() // self = AI
{
	self endon( "death" );
	
	e_goal_volume = GetEnt( "dead_event_quadtank_goalvolume", "targetname" );
	
	self SetGoal( e_goal_volume );
}

function dead_event_crescendo()
{
	spawn_manager::disable( "dead_event_wasp_sm" );	
	spawn_manager::disable( "dead_event_robot_sm" );
	
	//level thread debug_cleanup_of_enemies();
	
	// Wait so crescendo doesn't begin immediately after player kills last Hunter
	wait 3.0;
	
	IPrintLnBold( "Start Crescendo" );	
	
	// Spawn a LOT of Hunters
	level thread spawn_crescendo_hunters();
	
	// Spawn Lotus Towers Gunship
	e_lotus_towers_gunship = spawner::simple_spawn_single( "dead_event_end_gunship" );
	e_lotus_towers_gunship SetCanDamage( false );
	e_lotus_towers_gunship.health = 40000;
	e_lotus_towers_gunship.n_max_health = e_lotus_towers_gunship.health;
	e_lotus_towers_gunship setneargoalnotifydist( 1000 );
	self thread add_dead_event_target_objective_marker();
	Target_Set(e_lotus_towers_gunship);
	
	nd_start = GetVehicleNode( "lt_gunship_enter", "targetname" );
	e_lotus_towers_gunship SetVehGoalPos( nd_start.origin, 1 );
	
	e_lotus_towers_gunship util::waittill_any( "near_goal", "goal" );
	
	// Lotus Towers Gunship fires at Dead Control module
	e_panel = GetEnt( "dead_turret_panel", "targetname" );
	e_lotus_towers_gunship thread gunship_fire_missile( 0, e_panel );
	e_lotus_towers_gunship thread gunship_fire_missile( 1, e_panel );

	e_panel wait_for_dead_control_module_damage( e_lotus_towers_gunship );
	
	// Player loses Dead Control
	IPrintLnBold( "DEAD TURRETS DISABLED" );
	foreach( player in level.players )
	{
		if( ( isdefined( player.has_dead_control ) && player.has_dead_control ) )
		{
			player thread remove_all_dead_control();			
		}
	}
	
	objectives::complete( "cp_level_ramses_dead_turret_marker" );
	
	foreach( t_interact in level.a_t_dead_turret_interacts )
	{
		t_interact thread control_module_reactivate();	
	}
	
	level waittill( "control_module_reactivated" );
	
	foreach( trigger in level.a_t_dead_turret_interacts )
	{
		trigger delete();
	}
	
	level thread mission_complete();
}

function spawn_crescendo_hunters()
{
	level endon( "control_module_reactivated" );
	
	level.a_ai_end_hunters = [];
	a_sp_hunter = getentarray( "dead_event_hunter", "targetname" );
	
	for( i = 0; i < 14; i++ )
	{
		sp_hunter = array::random( a_sp_hunter );
		ai_hunter = spawner::simple_spawn_single( sp_hunter );
		ai_hunter thread dead_event_hunter_death_func();
		level.a_ai_end_hunters[ level.a_ai_end_hunters.size ] = ai_hunter;
		
		wait 0.25;
	}
	
	while( 1 )
	{
		level waittill( "dead_event_hunter_killed" );
		
		foreach( ai_hunter in level.a_ai_end_hunters )
		{
			if( !IsAlive( ai_hunter ) )
			{
				ArrayRemoveValue( level.a_ai_end_hunters, ai_hunter );
			}
		}
		
		if( level.a_ai_end_hunters.size < 10 )
		{
			sp_hunter = array::random( a_sp_hunter );
			ai_hunter = spawner::simple_spawn_single( sp_hunter );
			ai_hunter thread dead_event_hunter_death_func();
			level.a_ai_end_hunters[ level.a_ai_end_hunters.size ] = ai_hunter;	
		}
	}
}

function gunship_fire_missile( n_gunner_index, e_target ) // self = Lotus Towers Gunship
{
	n_tag_id = n_gunner_index + 1;
	str_tag = "tag_rocket" + n_tag_id;
	v_tag_origin = self GetTagOrigin( str_tag );
	w_gunship_cannon = GetWeapon( "gunship_cannon" );
	e_missile = MagicBullet( w_gunship_cannon, v_tag_origin, v_tag_origin + ( 0, 0, 1024 ), self, e_target );
}

function wait_for_dead_control_module_damage( e_lotus_towers_gunship ) // self = panel module
{
	self setcandamage( true );
	self.health = 9999;
	
	while( 1 )
	{
		self waittill( "damage", damage, attacker );
		
		if( attacker == e_lotus_towers_gunship )
		{
			break;
		}
	}
}

function control_module_reactivate() // self = trigger
{
	self SetVisibleToAll();
	self SetHintString( &"CP_MI_CAIRO_RAMSES_HACK_DEAD" );
	
	e_panel = GetEnt( "dead_turret_panel", "targetname" );

	objectives::set( "cp_level_ramses_dead_control_panel", e_panel );
	
	while( 1 )
	{
		self waittill( "trigger", e_player );
	
		if( IsPlayer( e_player ) )
		{
			objectives::hide( "cp_level_ramses_dead_control_panel" );
			
			e_player scene::play( "cin_gen_player_hack", e_player );
			
			level notify( "control_module_reactivated" );
			
			break;
		}			
	}
}

function mission_complete()
{
	IPrintLnBold( "Outro IGC" );
	
	level notify( "outro_igc_started" );
	
	foreach( player in level.players )
	{
		player enableinvulnerability();
	}
	
	level scene::play( "cin_ram_11_outro_3rd_pre100" );
		
	flag::set( "dead_event_complete" );
	
	util::screen_fade_out( 0.5 );
	
	skipto::objective_completed( "dead_event" );
}

function debug_cleanup_of_enemies()
{
	a_enemies = GetAITeamArray( "axis" );
	
	foreach( ai in a_enemies )
	{
		if( IsSubStr( ai.targetname, "hunter" ) )
		{
			continue;	
		}
		else
		{
			ai delete();
		}
	}
}

/***********************************
 * NRC VTOL
 * ********************************/

function send_nrc_vtol()
{
	a_e_vtol = getentarray( "dead_event_nrc_vtol", "targetname" );
	sp_vtol = array::random( a_e_vtol );
	
	e_vtol = spawner::simple_spawn_single( sp_vtol );
	
	e_vtol endon( "vtol_destroyed" );
	
	//HACK - set the VTOL to the correct team
	e_vtol setteam( "axis" );
	
	a_e_nrc_robots = sp_vtol get_robot_drop_squad();
	
	foreach( e_robot in a_e_nrc_robots )
	{
		e_robot.saved_origin = e_robot.origin;
		e_robot.saved_angles = e_robot.angles;
		
		e_robot LinkTo( e_vtol );
	}
	
	// HACK - customize the VTOL's health for this event
	switch( level.players.size )
	{
		case 1:
			e_vtol.health = 40000;
		case 2:
			e_vtol.health = 30000;
		case 3:
			e_vtol.health = 30000;
		case 4:
			e_vtol.health = 20000;
		default:
			e_vtol.health = 40000;
	}
	
	e_vtol.n_max_health = e_vtol.health;
	
	// Handle red diamond UI markers
	self thread add_dead_event_target_objective_marker();
	
	//add to target array
	Target_Set(e_vtol);
	
	e_vtol thread dead_event_nrc_vtol_damage_watcher( a_e_nrc_robots );

	e_vtol vehicle::go_path();
	
	e_vtol dead_event_nrc_drop_off_robots( a_e_nrc_robots );

	a_nd_end = GetVehicleNodeArray( "dead_event_nrc_vtol_exit", "targetname" );
	nd_end = array::random( a_nd_end );
	
	e_vtol SetVehGoalPos( nd_end.origin, 0 );
	
	e_vtol setNearGoalNotifyDist( 500 );
	e_vtol waittill( "near_goal" );
	
	v_end = e_vtol.origin - (0, 0, 2000 );
	e_vtol SetVehGoalPos( v_end, 0 );
	
	e_vtol waittill( "near_goal" );
	
	if( IsDefined( e_vtol ) )
	{
		objectives::complete( "cp_level_ramses_dead_event_targets", e_vtol );
		e_vtol delete();
	}
}

// Self is vehicle spawner
function get_robot_drop_squad()
{
	a_mdl_robots = [];
	a_s_nrc_robot_spots = struct::get_array( self.script_string, "targetname" );
	
	for( i = 0; i < a_s_nrc_robot_spots.size; i++ )
	{
		a_mdl_robots[ i ] = util::spawn_model( a_s_nrc_robot_spots[ i ].model, a_s_nrc_robot_spots[ i ].origin, a_s_nrc_robot_spots[ i ].angles );
	}
	
	return a_mdl_robots;
}

function dead_event_nrc_vtol_damage_watcher( a_e_nrc_robots ) // self = VTOL
{
	while( 1 )
	{
		self waittill( "damage", damage, attacker );	
	
		if( self.health <= 0 )
		{
			self notify( "vtol_destroyed" );
			
			objectives::complete( "cp_level_ramses_dead_event_targets", self );

			vtol_robot_spawners_reset( a_e_nrc_robots );
			
			break;
		}
	}
}

function dead_event_nrc_drop_off_robots( a_e_nrc_robots ) // self = VTOL
{
	self endon( "vtol_destroyed" );
	
	self waittill( "dead_event_vtol_end" );
	
	foreach( e_robot in a_e_nrc_robots )
	{
		e_robot thread move_robot_to_ground();
		wait RandomFloatRange( 0.5, 1.0 );
	}
	
	level vtol_robot_spawners_reset( a_e_nrc_robots );
}

function move_robot_to_ground() // self = robot script model
{
	v_start = self.origin;
	v_end = self.origin - (0, 0, 10000);
	
	v_trace = BulletTrace( v_start, v_end, true, self )[ "position" ];
	
	// Spawn a robot
	self Unlink();
	self show();
	self MoveTo( v_trace, 1 );
	self waittill( "movedone" );
	self hide();
	
	sp_robot = getent( "sp_dead_event_vtol_robot", "targetname" );
	ai_robot = spawner::simple_spawn_single( sp_robot );
	while( !IsDefined( ai_robot ) )
	{
		wait 0.05;	
	}
	ai_robot forceteleport( self.origin, self.angles );
}

function vtol_robot_spawners_reset( a_e_nrc_robots )
{
	foreach( e_robot in a_e_nrc_robots )
	{
		e_robot unlink();
		e_robot.origin = e_robot.saved_origin;
		e_robot.angles = e_robot.saved_angles;
	}	
}

// TODO - Better scripting for this, when do we call play?
function khalil_scenes()
{	
	level thread scene::init( "cin_ram_09_05_escort_vign_interface" );
	
	level.ai_khalil thread dialog::say( "khal_i_can_interface_with_0", 1.0 );
	
	wait 5.0;
	
	level thread scene::play( "cin_ram_09_05_escort_vign_interface" );
	
	level.ai_khalil thread dialog::say( "khal_rebooting_the_system_0", 1.0 );
	
	wait 5.0;
	
	level thread rachel_vo();
}

function rachel_vo()
{
	e_panel = GetEnt( "dead_turret_panel", "targetname" );
	
	e_panel thread dialog::say( "kane_hack_into_the_d_e_a_0", 1.0, true );
	
	wait 5.0;
	
	flag::wait_till( "player_has_dead_control" );
	
	e_panel thread dialog::say( "kane_manually_target_and_0", 1.0, true );
}

function hendricks_moves_to_freeway()
{
	 if( IsDefined( level.ai_hendricks ) )
    {
    	level.ai_hendricks colors::set_force_color( "y" );
    }
	
	util::delay( 3.0, undefined, &trigger::use, "dead_event_color_start", "targetname" );
}

/***********************************
 * HUNTER CALLBACK
 * ********************************/

function hunter_callback()
{
	self endon( "death" );
	
	Target_Set( self, ( 0, 0, 0 ) );

	self.health = self.healthdefault;

	self vehicle::friendly_fire_shield();

	self EnableAimAssist();
	self SetNearGoalNotifyDist( 50 );

	self SetHoverParams( 15, 100, 40 );
	self.flyheight = GetDvarFloat( "g_quadrotorFlyHeight" );
	// self SetVehicleAvoidance( true );

	self.fovcosine = 0; // +/-90 degrees = 180
	self.fovcosinebusy = 0.574;	//+/- 55 degrees = 110 fov

	self.vehAirCraftCollisionEnabled = true;

	self.original_vehicle_type = self.vehicletype;

	self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );

	self SetSpeed( self.settings.defaultMoveSpeed, 5, 5 );
	self.goalRadius = 4096;
	self.goalHeight = 512;
	self SetGoal( self.origin, false, 4096, 512 );

	self hunter::hunter_initTagArrays();

	self.overrideVehicleDamage = &hunter::HunterCallback_VehicleDamage;

	self thread vehicle_ai::nudge_collision();

	self thread hunter::hunter_frontScanning();

//	self hunter_SpawnDrones();
//
//	wait 0.5;
//
//	foreach ( drone in self.dronesOwned )
//	{
//		if ( isalive( drone ) )
//		{
//			drone vehicle_ai::set_state( "attached" );
//		}
//	}
	self turret::_init_turret( 1 );
	self turret::_init_turret( 2 );
	self turret::set_best_target_func( &hunter::side_turret_get_best_target, 1 );
	self turret::set_best_target_func( &hunter::side_turret_get_best_target, 2 );

	self turret::set_burst_parameters( 1, 2, 1, 2, 1 );
	self turret::set_burst_parameters( 1, 2, 1, 2, 2 );

	self turret::set_target_flags( 1 | 2, 1 );
	self turret::set_target_flags( 1 | 2, 2 );

	hunter::defaultRole();
}

function hacking_scene_complete( a_ents )
{
	level notify( "hacking_scene_complete" );
}


