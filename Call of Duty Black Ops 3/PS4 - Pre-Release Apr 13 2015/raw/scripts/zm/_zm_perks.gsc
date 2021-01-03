#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_buildables;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                                                                       	                                
                                                                                                                               

#precache( "fx", "_t6/misc/fx_zombie_cola_dtap_on" );
#precache( "fx", "_t6/misc/fx_zombie_cola_jugg_on" );
#precache( "fx", "_t6/misc/fx_zombie_cola_on" );

#namespace zm_perks;

function init()
{
	level.perk_purchase_limit = 4;

	// Register the perk client field
	perks_register_clientfield();
	
	if(!level.enable_magic)
	{
		return;
	}
	
	initialize_custom_perk_arrays();
	
	//sets up spawned perk machines.
	perk_machine_spawn_init();	

	vending_weapon_upgrade_trigger = [];

	// Perks-a-cola vending machine use triggers
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	//level flag::init( "solo_game" );

	if ( vending_triggers.size < 1 )
	{
		return;
	}
	
	level.machine_assets = [];
	
	//Perks machine
	if( !isDefined( level.custom_vending_precaching ) )
	{
		level.custom_vending_precaching = &default_vending_precaching;
	}
	[[ level.custom_vending_precaching ]]();

	zombie_utility::set_zombie_var( "zombie_perk_cost",					2000 );

	array::thread_all( vending_triggers, &vending_trigger_think );
	array::thread_all( vending_triggers, &electric_perks_dialog );
	
	if ( level._custom_perks.size > 0 )
	{
		a_keys = GetArrayKeys( level._custom_perks );
		
		for ( i = 0; i < a_keys.size; i++ )
		{
			if ( IsDefined( level._custom_perks[ a_keys[ i ] ].perk_machine_thread ) )
			{
				level thread [[ level._custom_perks[ a_keys[ i ] ].perk_machine_thread ]]();
			}
			if( isdefined( level._custom_perks[ a_keys[ i ] ].perk_machine_power_override_thread ) )//Quick Revive uses this
			{
				level thread [[ level._custom_perks[ a_keys[ i ] ].perk_machine_power_override_thread ]]();
			}
			else if( isdefined( level._custom_perks[ a_keys[ i ] ].alias ) && isdefined( level._custom_perks[ a_keys[ i ] ].radiant_machine_name ) && isdefined( level._custom_perks[ a_keys[ i ] ].machine_light_effect ) )
			{
				level thread perk_machine_think( a_keys[ i ], level._custom_perks[ a_keys[ i ] ] );	
			}
		}
	}
		
	if ( isdefined( level.quantum_bomb_register_result_func ) )
	{
		[[level.quantum_bomb_register_result_func]]( "give_nearest_perk", &quantum_bomb_give_nearest_perk_result, 10, &quantum_bomb_give_nearest_perk_validation );
	}

	level thread perk_hostmigration();
}

function perk_machine_think( str_key, s_custom_perk )
{	
	str_endon = str_key + "_power_thread_end";
	level endon( str_endon );//Support endon for any perk machine
	
	str_on = s_custom_perk.alias + "_on";
	str_off = s_custom_perk.alias + "_off";
	str_notify = str_key + "_power_on";
	
	while ( true )
	{
		machine = getentarray( s_custom_perk.radiant_machine_name, "targetname");
		machine_triggers = GetEntArray( s_custom_perk.radiant_machine_name, "target" );
		
		for( i = 0; i < machine.size; i++ )
			machine[i] SetModel(level.machine_assets[str_key].off_model);
		
		level thread zm_perks::do_initial_power_off_callback( machine, str_key );
		array::thread_all( machine_triggers, &zm_perks::set_power_on, false );
	
		level waittill( str_on );
	
		for( i = 0; i < machine.size; i++ )
		{
			machine[i] SetModel(level.machine_assets[str_key].on_model);
			machine[i] vibrate((0,-100,0), 0.3, 0.4, 3);
			machine[i] playsound("zmb_perks_power_on");
			machine[i] thread zm_perks::perk_fx( s_custom_perk.machine_light_effect );
			machine[i] thread zm_perks::play_loop_on_machine();
		}
		level notify( str_notify );
		
		array::thread_all( machine_triggers, &zm_perks::set_power_on, true );
		if( IsDefined( level.machine_assets[ str_key ].power_on_callback ) )
		{
			array::thread_all( machine, level.machine_assets[ str_key ].power_on_callback );
		}
		
		level waittill( str_off );
			
		if( IsDefined( level.machine_assets[ str_key ].power_off_callback ) )
		{
			array::thread_all( machine, level.machine_assets[ str_key ].power_off_callback );
		}
		array::thread_all( machine, &zm_perks::turn_perk_off );
	}
}

//
//	Precaches all machines
//
//	"weapon" - 1st person Bottle when drinking
//	icon - Texture for when perk is active
//	model - Perk Machine on/off versions
//	fx - machine on
//	sound
function default_vending_precaching()
{	
	// precache all custom perks
	if ( level._custom_perks.size > 0 )
	{
		a_keys = GetArrayKeys( level._custom_perks );
		for ( i = 0; i < a_keys.size; i++ )
		{
			if ( IsDefined( level._custom_perks[ a_keys[ i ] ].precache_func ) )
			{
				level [[ level._custom_perks[ a_keys[ i ] ].precache_func ]]();
			}
		}
	}
}



//############################################################################
//		P E R K   M A C H I N E S
//############################################################################

//
//	Threads to turn the machines to their ON state.
//

function do_initial_power_off_callback( machine_array, perkname )
{
	if( !IsDefined( level.machine_assets[ perkname ] ) )
	{
		/#PrintLn( "Error: doing setup for a machine with no level.machine_assets! Check your perk initialization!" );#/
		return;
	}
	if( !IsDefined( level.machine_assets[ perkname ].power_off_callback ) )
	{
		return;
	}
	
	{wait(.05);}; // wait to prevent setting the clientflag before it has been initialized
	
	array::thread_all( machine_array, level.machine_assets[ perkname ].power_off_callback );
}

function use_solo_revive()
{
	if( isdefined(level.override_use_solo_revive) )
	{
		return [[level.override_use_solo_revive]]();
	}

	// TODO: lock out games with potential hotjoins
	if (isdefined(level.using_solo_revive))
		return level.using_solo_revive;
		
	players = GetPlayers();
	solo_mode = 0;
	if ( players.size == 1 || ( isdefined( level.force_solo_quick_revive ) && level.force_solo_quick_revive ) )
	{
		solo_mode = 1;
	}
	level.using_solo_revive = solo_mode;
	return solo_mode;
}

//
//
function set_power_on( state )
{
	self.power_on = state;
}

//
//
function turn_perk_off(ishidden)
{	
	self notify( "stop_loopsound" );
	
	newMachine = Spawn( "script_model", self.origin );
	newMachine.angles = self.angles;
	newMachine.targetname = self.targetname;
	if(( isdefined( ishidden ) && ishidden ))
	{
		newMachine.ishidden = true;
		newMachine hide();
	}
	
	self Delete();
}

function play_loop_on_machine()
{
	if( isdefined( level.sndPerksacolaLoopOverride ) )
		return;
	
	sound_ent = spawn( "script_origin", self.origin );
	sound_ent playloopsound("zmb_perks_machine_loop");
	sound_ent LinkTo( self );
	self waittill( "stop_loopsound" );
	sound_ent UnLink();
	sound_ent delete();
}

//	
//
function perk_fx( fx, turnOffFx )
{
	if( IsDefined( turnOffFx ) )
	{
		self.perk_fx = false;
	}
	else
	{
		wait(3);
		if ( IsDefined( self ) && !( isdefined( self.perk_fx ) && self.perk_fx ) )
		{
			playfxontag( level._effect[ fx ], self, "tag_origin" );
			self.perk_fx = true;
		}
	}
}




function electric_perks_dialog()
{
	self endon("death");
	
	// TODO: This hack allows the thread to start after the gametype init has had a chance to run 
	wait 0.01;	

	//TODO  TEMP Disable Revive in Solo games
	level flag::wait_till( "start_zombie_round_logic" );
	players = GetPlayers();
	if ( players.size == 1 )
	{
		return;
	}
	
	self endon ("warning_dialog");
	level endon("switch_flipped");
	timer =0;
	while(1)
	{
		wait(0.5);
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{	
			if(!isDefined(players[i] ))
			{
				continue;
			}
			
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
				if(!isDefined(players[i] ))
				{
					continue;
				}
				
				players[i] thread zm_utility::do_player_vo("vox_start", 5);	
				wait(3);				
				self notify ("warning_dialog");
				/#
				iprintlnbold("warning_given");
				#/
			}
		}
	}
}

function reset_vending_hint_string()
{
	perk = self.script_noteworthy;
	solo = zm_perks::use_solo_revive();
	
	if( IsDefined( level._custom_perks ) )
	{
		if ( IsDefined( level._custom_perks[ perk ] ) && IsDefined( level._custom_perks[ perk ].cost ) && IsDefined( level._custom_perks[ perk ].hint_string ) )
		{
			self SetHintString( level._custom_perks[ perk ].hint_string, level._custom_perks[ perk ].cost );
		}		
	}
}

function vending_trigger_can_player_use( player )
{
	if (player laststand::player_is_in_laststand() || ( isdefined( player.intermission ) && player.intermission ) )
	{
		return false;
	}

	if(player zm_utility::in_revive_trigger())
	{
		return false;
	}
	
	if( !player zm_magicbox::can_buy_weapon() )
	{
		return false;
	}
	
	if( player isThrowingGrenade() )
	{
		return false;
	}
	
	if( player isSwitchingWeapons() )
	{
		return false;
	}

	if( ( player.is_drinking > 0 ) )
	{
		return false;
	}
	
	return true;		
}

//
//
function vending_trigger_think()
{
	self endon( "death" );

	// TODO: This hack allows the thread to start after the gametype init has had a chance to run 
	wait 0.01;	

	//self thread turn_cola_off();
	perk = self.script_noteworthy;
	solo = false;
	start_on = false;
	level.revive_machine_is_solo = false;	

	//TODO  TEMP Disable Revive in Solo games
	if ( IsDefined( perk ) && perk == "specialty_quickrevive" )
	{
		level flag::wait_till( "start_zombie_round_logic" );
		solo = use_solo_revive();
		self endon("stop_quickrevive_logic");
		level.quick_revive_trigger = self;
		if (solo)
		{
			if (!( isdefined( level.revive_machine_is_solo ) && level.revive_machine_is_solo ))
			{
				start_on = true;
				players = GetPlayers();
				foreach ( player in players )
				{
					if(!isDefined(player.lives))
						player.lives = 0;
				}
				level zm::set_default_laststand_pistol( true );
			}
			level.revive_machine_is_solo = true;
		}
	}

	//if ( !solo )
	{
		self SetHintString( &"ZOMBIE_NEED_POWER" );
	}

	self SetCursorHint( "HINT_NOICON" );
	self UseTriggerRequireLookAt();

	cost = level.zombie_vars["zombie_perk_cost"];
	
	if ( IsDefined( level._custom_perks[ perk ] ) && IsDefined( level._custom_perks[ perk ].cost ) )
	{
		if( IsInt( level._custom_perks[ perk ].cost ) )
		{
			cost = level._custom_perks[ perk ].cost;
		}
		else
		{
			cost = [[ level._custom_perks[ perk ].cost ]]();
		}
	}

	self.cost = cost;

	if ( !start_on )
	{
		notify_name = perk + "_power_on";
		level waittill( notify_name );
	}
	start_on = false;

	if(!IsDefined(level._perkmachinenetworkchoke))
	{
		level._perkmachinenetworkchoke = 0;
	}
	else
	{
		level._perkmachinenetworkchoke ++;
	}
	
	for(i = 0; i < level._perkmachinenetworkchoke; i ++)
	{
		util::wait_network_frame();
	}
	
	//Turn on music timer
	self thread zm_audio::sndPerksJingles_Timer();

	self thread check_player_has_perk(perk);
	
	if ( IsDefined( level._custom_perks[ perk ] ) && IsDefined( level._custom_perks[ perk ].hint_string ) )
	{
		self SetHintString( level._custom_perks[ perk ].hint_string, cost );
	}

	for( ;; )
	{
		self waittill( "trigger", player );
		
		index = zm_weapons::get_player_index(player);

		if ( !vending_trigger_can_player_use( player ) )
		{
			wait( 0.1 );
			continue;
		}

		if ( player HasPerk( perk ) || player has_perk_paused( perk ) )
		{
			cheat = false;

			/#
			if ( GetDvarInt( "zombie_cheat" ) >= 5 )
			{
				cheat = true;
			}
			#/

			if ( cheat != true )
			{
				//player iprintln( "Already using Perk: " + perk );
				self playsound("deny");
				player zm_audio::create_and_play_dialog( "general", "sigh" );

				
				continue;
			}
		}

		if( IsDefined( level.custom_perk_validation ) )
		{
			valid = self [[ level.custom_perk_validation ]]( player );
			
			if( !valid )
			{
				continue;
			}
		}
		
		current_cost = cost;
		// If the persistent upgrade "double_points" is active, the cost is halved
		if( player zm_pers_upgrades_functions::is_pers_double_points_active() )
		{
			current_cost = player zm_pers_upgrades_functions::pers_upgrade_double_points_cost( current_cost );
		}

		if( player.score < current_cost )
		{
			//player iprintln( "Not enough points to buy Perk: " + perk );
			self playsound("evt_perk_deny");
			player zm_audio::create_and_play_dialog( "general", "outofmoney" );
			continue;
		}

		if ( player.num_perks >= player zm_utility::get_player_perk_purchase_limit() )
		{
			//player iprintln( "Too many perks already to buy Perk: " + perk );
			self playsound("evt_perk_deny");
			// COLLIN: do we have a VO that would work for this? if not we'll leave it at just the deny sound
			player zm_audio::create_and_play_dialog( "general", "sigh" );
			continue;
		}

		sound = "evt_bottle_dispense";
		playsoundatposition(sound, self.origin);
		player zm_score::minus_to_player_score( current_cost, true );

		player.perk_purchased = perk;

		self thread zm_audio::sndPerksJingles_Player(1);
	
		self thread vending_trigger_post_think( player, perk );
	}
}

function vending_trigger_post_think( player, perk )
{
	player endon( "disconnect" );
	player endon( "end_game" );
	player endon( "perk_abort_drinking" );

	// do the drink animation
	gun = player perk_give_bottle_begin( perk );
	evt = player util::waittill_any_return( "fake_death", "death", "player_downed", "weapon_change_complete" );
	
	// once they start drinking they get the perk - if the machine is disabled in mid drink they will have it disabled
	if (evt == "weapon_change_complete" )
	{
		player thread wait_give_perk( perk, true );
	}
	
	// restore player controls and movement
	player perk_give_bottle_end( gun, perk );

	// TODO: race condition?
	if ( player laststand::player_is_in_laststand() || ( isdefined( player.intermission ) && player.intermission ) )
	{
		return;
	}

	player notify("burp");
	
	// Only in classic mode - Update the "cash_back" persistent unlock
	if( ( isdefined( level.pers_upgrade_cash_back ) && level.pers_upgrade_cash_back ) )
	{
		player zm_pers_upgrades_functions::cash_back_player_drinks_perk();
	}

	// Another persistent player ability
	if( ( isdefined( level.pers_upgrade_perk_lose ) && level.pers_upgrade_perk_lose ) )
	{
		player thread zm_pers_upgrades_functions::pers_upgrade_perk_lose_bought();
	}
	
	if ( isDefined( level.perk_bought_func ) )
	{
		player [[ level.perk_bought_func ]]( perk );
	}

	player.perk_purchased = undefined;

	// Check If Perk Machine Was Powered Down While Drinking, Is So Pause The Perks
	//-----------------------------------------------------------------------------
	if ( !( isdefined( self.power_on ) && self.power_on ) )
	{
		wait 1; 
		perk_pause( self.script_noteworthy );
	}

	//player iprintln( "Bought Perk: " + perk );
}


//*****************************************************************************
//*****************************************************************************

// unlocked_perk_upgrade( perk )
// {
// 	ch_ref = string(tablelookup( "mp/challengeTable_zmPerk.csv", 12, perk, 7 ));
// 	ch_max = int(tablelookup( "mp/challengeTable_zmPerk.csv", 12, perk, 4 ));
// 	ch_progress = self getdstat( "challengeStats", ch_ref, "challengeProgress" );
// 	
// 	if( ch_progress >= ch_max )
// 	{
// 		return true;
// 	}
// 	return false;
// }

function wait_give_perk( perk, bought )
{
	self endon( "player_downed" );
	self endon( "disconnect" );
	self endon( "end_game" );
	self endon( "perk_abort_drinking" );
	
	self util::waittill_any_timeout(0.5, "burp" );
	self give_perk( perk, bought );
}

function return_retained_perks()
{
	if ( IsDefined(self._retain_perks_array)  )
	{
		keys = getarraykeys( self._retain_perks_array );
		foreach( perk in keys )
		{
			if ( ( isdefined( self._retain_perks_array[perk] ) && self._retain_perks_array[perk] )  )
				self give_perk( perk, false );
		}
		
	}
}

//*****************************************************************************
//*****************************************************************************
	
function give_perk( perk, bought )
{
	self SetPerk( perk );
	self.num_perks++;

	if( ( isdefined( bought ) && bought ) )
	{
		//AUDIO: Ayers - Sending Perk Name over to audio common script to play VOX
		self zm_audio::playerExert( "burp" );
		if ( ( isdefined( level.remove_perk_vo_delay ) && level.remove_perk_vo_delay ) )
		{
			self zm_audio::create_and_play_dialog( "perk", perk );
		}
		else
		{
			self util::delay(1.5, undefined, &zm_audio::create_and_play_dialog, "perk", perk );
		}
		self setblur( 4, 0.1 );
		wait(0.1);
		self setblur(0, 0.1);
		//earthquake (0.4, 0.2, self.origin, 100);

		self notify( "perk_bought", perk );
	}
	
	if ( IsDefined( level._custom_perks[ perk ] ) && IsDefined( level._custom_perks[ perk ].player_thread_give ) )
	{
		self thread [[ level._custom_perks[ perk ].player_thread_give ]]();
	}

	self set_perk_clientfield( perk, 1 );

	demo::bookmark( "zm_player_perk", gettime(), self );

	//stat tracking
	self zm_stats::increment_client_stat( "perks_drank" );
	self zm_stats::increment_client_stat( perk + "_drank" );
	self zm_stats::increment_player_stat( perk + "_drank" );
	self zm_stats::increment_player_stat( "perks_drank" );
	
	//Happy Hour achievement tracking
	if(!isDefined(self.perk_history))
	{
		self.perk_history = [];
	}
	array::add(self.perk_history,perk,false);
	
	if ( !IsDefined( self.perks_active ) )
	{
		self.perks_active = [];
	}
	
	if ( !isdefined( self.perks_active ) ) self.perks_active = []; else if ( !IsArray( self.perks_active ) ) self.perks_active = array( self.perks_active ); self.perks_active[self.perks_active.size]=perk;;
	
	self notify("perk_acquired");	

	self thread perk_think( perk );
}


//*****************************************************************************
// Increment player max health if its the jugg perk
//*****************************************************************************

// self = player
function perk_set_max_health_if_jugg( perk, set_preMaxHealth, clamp_health_to_max_health )
{
	max_total_health = undefined;

	// Is it the Jugg (or upgraded) Perk?
	if( perk == "specialty_armorvest" )
	{
		if( set_preMaxHealth )
		{
			self.preMaxHealth = self.maxhealth;
		}
		max_total_health = level.zombie_vars["zombie_perk_juggernaut_health"];
	}
	// Is if the Jugg persistent upgrade?
	else if( perk == "jugg_upgrade" )
	{
		if( set_preMaxHealth )
		{
			self.preMaxHealth = self.maxhealth;
		}
		// If we have jugg
		if( self hasperk("specialty_armorvest") )
		{
			max_total_health = level.zombie_vars["zombie_perk_juggernaut_health"];
		}
		else
		{
			max_total_health = 100;			// hardcoded number, same as player health set in onPlayerSpawned()
		}
	}
	else if ( perk == "health_reboot" )
	{
		max_total_health = 100;
	}

	// Was the health upgraded by Jugg?
	if( IsDefined(max_total_health) )
	{
		// If the PERSISTENT Jugg upgrade is active, add the extra health
		if( self zm_pers_upgrades_functions::pers_jugg_active() )
		{
			max_total_health = max_total_health + level.pers_jugg_upgrade_health_bonus;
		}

		self SetMaxHealth( max_total_health );

		if( IsDefined(clamp_health_to_max_health) && (clamp_health_to_max_health == true) )
		{
			if( self.health > self.maxhealth )
			{
				self.health = self.maxhealth;
			}
		}
	}
}


//*****************************************************************************
//*****************************************************************************

function check_player_has_perk(perk)
{
	self endon( "death" );
/#
	if ( GetDvarInt( "zombie_cheat" ) >= 5 )
	{
		return;
	}
#/

	dist = 128 * 128;
	while(true)
	{
		players = GetPlayers();
		for( i = 0; i < players.size; i++ )
		{
			if(DistanceSquared( players[i].origin, self.origin ) < dist)
			{
				if(!players[i] hasperk(perk) && 
				    self vending_trigger_can_player_use( players[i] ) &&
				   !players[i] has_perk_paused(perk) && 
				   !(players[i] zm_utility::in_revive_trigger()) && 
				   !(zm_equipment::is_equipment_that_blocks_purchase( players[i] getcurrentweapon() ) ) &&
				   (!players[i] zm_equipment::hacker_active()))
				{
					self setinvisibletoplayer(players[i], false);
				}
				else
				{
					self SetInvisibleToPlayer(players[i], true);
				}
			}
		}
		wait(0.1);

	}
}


function vending_set_hintstring( perk )
{
	switch( perk )
	{
	case "specialty_armorvest":
		break;

	}
}

function perk_think( perk )
{
/#
	if ( GetDvarInt( "zombie_cheat" ) >= 5 )
	{
		if ( IsDefined( self.perk_hud[ perk ] ) )
		{
			return;
		}
	}
#/

	perk_str = perk + "_stop";
	result = self util::waittill_any_return( "fake_death", "death", "player_downed", perk_str );

	do_retain = true;
	
	if( use_solo_revive() && perk == "specialty_quickrevive")
	{
		do_retain = false;
	}

	if( do_retain )
	{
		if ( IsDefined(self._retain_perks) && self._retain_perks )
		{
			return;
		}
		else if ( IsDefined( self._retain_perks_array ) && ( isdefined( self._retain_perks_array[ perk ] ) && self._retain_perks_array[ perk ] ) )
		{
			return;
		}
	}

	self UnsetPerk( perk );
	self.num_perks--;
	
	// turn off perk when perk is paused, if custom func is set
	if ( IsDefined( level._custom_perks[ perk ] ) && IsDefined( level._custom_perks[ perk ].player_thread_take ) )
	{
		self thread [[ level._custom_perks[ perk ].player_thread_take ]]( false, perk_str, result );
	}	
	
	self set_perk_clientfield( perk, 0 );
	//self perk_hud_destroy( perk );
	
	self.perk_purchased = undefined;
	//self iprintln( "Perk Lost: " + perk );


	if ( IsDefined( level.perk_lost_func ) )
	{
		self [[ level.perk_lost_func ]]( perk );
	}

	if ( IsDefined( self.perks_active ) && IsInArray( self.perks_active, perk ) )
	{
		ArrayRemoveValue( self.perks_active, perk, false );
	}
	
	self notify( "perk_lost" );
}

function set_perk_clientfield( perk, state )
{
	if ( IsDefined( level._custom_perks[ perk ] ) && IsDefined( level._custom_perks[ perk ].clientfield_set ) )
	{
		self [[ level._custom_perks[ perk ].clientfield_set ]]( state );
	}	
}


function perk_hud_destroy( perk )
{
	self.perk_hud[ perk ] zm_utility::destroy_hud();
	self.perk_hud[ perk ] = undefined;
}

function perk_hud_grey( perk, grey_on_off )
{
	if ( grey_on_off )
		self.perk_hud[ perk ].alpha = 0.3;
	else
		self.perk_hud[ perk ].alpha = 1.0;
}

function perk_give_bottle_begin( perk )
{
	self zm_utility::increment_is_drinking();
	
	self zm_utility::disable_player_move_states(true);

	original_weapon = self GetCurrentWeapon();
	
	weapon = "";
	
	if ( IsDefined( level._custom_perks[ perk ] ) && IsDefined( level._custom_perks[ perk ].perk_bottle_weapon ) )
	{
		weapon = level._custom_perks[ perk ].perk_bottle_weapon;
	}	

	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );

	return original_weapon;
}

function perk_give_bottle_end( original_weapon, perk )
{
	self endon( "perk_abort_drinking" );

	Assert( !original_weapon.isPerkBottle );
	Assert( original_weapon != level.weaponReviveTool );

	self zm_utility::enable_player_move_states();
	
	weapon = "";
	
	if ( IsDefined( level._custom_perks[ perk ] ) && IsDefined( level._custom_perks[ perk ].perk_bottle_weapon ) )
	{
		weapon = level._custom_perks[ perk ].perk_bottle_weapon;
	}	
	
	// TODO: race condition?
	if ( self laststand::player_is_in_laststand() || ( isdefined( self.intermission ) && self.intermission ) )
	{
		self TakeWeapon(weapon);
		return;
	}

	self TakeWeapon(weapon);

	if( self zm_utility::is_multiple_drinking() )
	{
		self zm_utility::decrement_is_drinking();
		return;
	}
	else if( original_weapon != level.weaponNone && !zm_utility::is_placeable_mine( original_weapon ) && !zm_equipment::is_equipment_that_blocks_purchase( original_weapon ) )
	{
		self SwitchToWeapon( original_weapon );
		// ww: the knives have no first raise anim so they will never get a "weapon_change_complete" notify
		// meaning it will never leave this funciton and will break buying weapons for the player
		if( zm_utility::is_melee_weapon( original_weapon ) )
		{
			self zm_utility::decrement_is_drinking();
			return;
		}
	}
	else 
	{
		// try to switch to first primary weapon
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
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

//*****************************************************************************
// Abort and cleanup the perk drinking process
//*****************************************************************************

// self = player
function perk_abort_drinking( post_delay )
{
	if( self.is_drinking )
	{
		self notify( "perk_abort_drinking" );
		self zm_utility::decrement_is_drinking();
		self zm_utility::enable_player_move_states();

		if( IsDefined(post_delay) )
		{
			wait( post_delay );
		}
	}
}


//*****************************************************************************
//*****************************************************************************

function give_random_perk()
{
	random_perk = undefined;

	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	perks = [];
	for ( i = 0; i < vending_triggers.size; i++ )
	{
		perk = vending_triggers[i].script_noteworthy;

		if ( isdefined( self.perk_purchased ) && self.perk_purchased == perk )
		{
			continue;
		}

		if ( !self HasPerk( perk ) && !self has_perk_paused( perk ) )
		{
			perks[ perks.size ] = perk;
		}
	}

	if ( perks.size > 0 )
	{
		perks = array::randomize( perks );
		random_perk = perks[0];
		self give_perk( random_perk );
	}
	else
	{
		// No Perks Left To Get
		self PlaySoundToPlayer( level.zmb_laugh_alias, self );
	}

	return( random_perk );
}


function lose_random_perk()
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	perks = [];
	for ( i = 0; i < vending_triggers.size; i++ )
	{
		perk = vending_triggers[i].script_noteworthy;

		if ( isdefined( self.perk_purchased ) && self.perk_purchased == perk )
		{
			continue;
		}

		if ( self HasPerk( perk ) || self has_perk_paused( perk ) )
		{
			perks[ perks.size ] = perk;
		}
	}

	if ( perks.size > 0 )
	{
		perks = array::randomize( perks );
		perk = perks[0];

		perk_str = perk + "_stop";
		self notify( perk_str );

		if ( use_solo_revive() && perk == "specialty_quickrevive" )
		{
			self.lives--;
		}
	}
}

function update_perk_hud()
{
	if ( isdefined( self.perk_hud ) )
	{
		keys = getarraykeys( self.perk_hud );
		for ( i = 0; i < self.perk_hud.size; i++ )
		{
			self.perk_hud[ keys[i] ].x = i * 30;
		}
	}
}

function quantum_bomb_give_nearest_perk_validation( position )
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	range_squared = 180 * 180; // 15 feet
	for ( i = 0; i < vending_triggers.size; i++ )
	{
		if ( DistanceSquared( vending_triggers[i].origin, position ) < range_squared )
		{
			return true;
		}
	}

	return false;
}


function quantum_bomb_give_nearest_perk_result( position )
{
	[[level.quantum_bomb_play_mystery_effect_func]]( position );

	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	nearest = 0;
	for ( i = 1; i < vending_triggers.size; i++ )
	{
		if ( DistanceSquared( vending_triggers[i].origin, position ) < DistanceSquared( vending_triggers[nearest].origin, position ) )
		{
			nearest = i;
		}
	}

	players = GetPlayers();
	perk = vending_triggers[nearest].script_noteworthy;
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( player.sessionstate == "spectator" || player laststand::player_is_in_laststand() )
		{
			continue;
		}

		if ( !player HasPerk( perk ) && ( !isdefined( player.perk_purchased ) || player.perk_purchased != perk) && RandomInt( 5 ) ) // 80% chance
		{
			if( player == self )
			{
				self thread zm_audio::create_and_play_dialog( "kill", "quant_good" );
			}
			
			player give_perk( perk );
			player [[level.quantum_bomb_play_player_effect_func]]();
		}
	}
}

function perk_pause( perk )
{
	for ( j = 0; j < GetPlayers().size; j++ )
	{
		player = GetPlayers()[j];
		if (!isdefined(player.disabled_perks))
			player.disabled_perks=[];
		player.disabled_perks[perk] = ( isdefined( player.disabled_perks[perk] ) && player.disabled_perks[perk] ) || player HasPerk( perk ); 
		if ( player.disabled_perks[perk] )
		{
			player UnsetPerk( perk );
			player set_perk_clientfield( perk, 2 );

			// turn off perk when perk is paused, if custom func is set
			if ( IsDefined( level._custom_perks[ perk ] ) && IsDefined( level._custom_perks[ perk ].player_thread_take ) )
			{
				player thread [[ level._custom_perks[ perk ].player_thread_take ]]( true );
			}	
			
			//player perk_hud_grey( perk, true );
			/# println(" ZM PERKS " + player.name + " paused perk " + perk + "\n" ); #/
		}
	}
}

function perk_unpause( perk )
{
	if(!isDefined(perk))
	{
		return;
	}

	for ( j = 0; j < GetPlayers().size; j++ )
	{
		player = GetPlayers()[j];
		if ( isdefined(player.disabled_perks) && ( isdefined( player.disabled_perks[perk] ) && player.disabled_perks[perk] ) )
		{
			player.disabled_perks[perk]=false;
			player set_perk_clientfield( perk, 1 );
			// player perk_hud_grey( perk, false );
			player SetPerk( perk );
			/# println(" ZM PERKS " + player.name + " unpaused perk " + perk + "\n" ); #/

			player perk_set_max_health_if_jugg( perk, false, false );
			
			if ( IsDefined( level._custom_perks[ perk ] ) && IsDefined( level._custom_perks[ perk ].player_thread_give ) )
			{
				player thread [[ level._custom_perks[ perk ].player_thread_give ]]();
			}			
		}
	}
}

function perk_pause_all_perks( power_zone )
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	foreach ( trigger in vending_triggers )
	{
		//if power switch does not have an assigned zone will turn off all perk machines.
		if(!IsDefined(power_zone))
		{
			zm_perks::perk_pause(trigger.script_noteworthy);
		}
		//if power switch has a power zone associated with it will only turn off perk machines in its zone.			
		else if(IsDefined(trigger.script_int) && trigger.script_int == power_zone)
		{
			zm_perks::perk_pause(trigger.script_noteworthy);
		}		
	}
}


function perk_unpause_all_perks( power_zone )
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	foreach ( trigger in vending_triggers )
	{
		//if power switch does not have an assigned zone will turn on all perk machines.
		if(!IsDefined(power_zone))
		{
			zm_perks::perk_unpause(trigger.script_noteworthy);
		}
		//if power switch has a power zone associated with it will only turn on perk machines in its zone.			
		else if(IsDefined(trigger.script_int) && trigger.script_int == power_zone)
		{
			zm_perks::perk_unpause(trigger.script_noteworthy);
		}
	}
}

function has_perk_paused( perk ) // self = player
{
	if ( isdefined(self.disabled_perks) && isdefined(self.disabled_perks[perk]) && self.disabled_perks[perk] )
	{
		return true;
	}
	return false;
}


function getVendingMachineNotify()
{
	if(!isDefined(self))
	{
		return "";
	}
	
	str_perk = undefined;
	
	if ( IsDefined( level._custom_perks[ self.script_noteworthy ] ) && IsDefined( IsDefined( level._custom_perks[ self.script_noteworthy ].alias ) ) )
	{
		str_perk = level._custom_perks[ self.script_noteworthy ].alias;
	}	
	
	return str_perk;
}

//=====================================================================
// Simple utility to remove a perk machine and replace it with a model.
//=====================================================================
function perk_machine_removal(machine, replacement_model)
{
	if(!IsDefined(machine))
	{
		return;
	}	

	trig = GetEnt(machine, "script_noteworthy");
	machine_model = undefined;

	if(IsDefined(trig))
	{
		// remove from vending array.
		trig notify ("warning_dialog");

		if(IsDefined(trig.target))
		{
			parts = GetEntArray(trig.target, "targetname");
			for ( i = 0; i < parts.size; i++ )
			{
				if(IsDefined(parts[i].classname) && parts[i].classname == "script_model")
				{
					machine_model = parts[i];
				}
				else if(IsDefined(parts[i].script_noteworthy && parts[i].script_noteworthy == "clip"))
				{
					model_clip = parts[i];
				}	
				else
				{
					parts[i] Delete();
				}		
			}
		}
		
		// If a replacement model is not specified it will just delete the perk machine.
		if(IsDefined(replacement_model) && IsDefined(machine_model))
		{
			machine_model SetModel(replacement_model);
		}
		else if(!IsDefined(replacement_model) && IsDefined(machine_model))
		{
			machine_model Delete();
			if(IsDefined(model_clip))
				model_clip Delete();
			if(IsDefined(trig.clip)) //from spawned perk clip.
				trig.clip Delete();
		}
		
		if(IsDefined(trig.bump))
			trig.bump Delete();
	
		trig Delete();		
	}
}	
//=====================================================================
// Simple utility to Add a perk machine.
// model and script_noteworthy need to be set on struct.
//=====================================================================
function perk_machine_spawn_init()
{
	match_string = "";

	location = level.scr_zm_map_start_location;
	if ((location == "default" || location == "" ) && IsDefined(level.default_start_location))
	{
		location = level.default_start_location;
	}		

	match_string = level.scr_zm_ui_gametype + "_perks_" + location;

	a_s_spawn_pos = [];
	if( IsDefined( level.override_perk_targetname ) )
		structs = struct::get_array( level.override_perk_targetname, "targetname");
	else
		structs = struct::get_array("zm_perk_machine", "targetname");
	
	foreach(struct in structs)
	{
		if(IsDefined(struct.script_string) )
		{
			tokens = strtok(struct.script_string," ");
			foreach(token in tokens)
			{
				if(token == match_string )
				{
					a_s_spawn_pos[a_s_spawn_pos.size] =	struct;
				}
			}
		}
		else
		{
			a_s_spawn_pos[a_s_spawn_pos.size] =	struct;
		}	
	}			
		
	if( a_s_spawn_pos.size == 0 )
	{
		return;
	}
	
	
	//randomize perk machine setup
	if( ( isdefined( level.randomize_perk_machine_location ) && level.randomize_perk_machine_location ) )
	{
		a_s_random_perk_locs = struct::get_array( "perk_random_machine_location", "targetname" );
	
		if( a_s_random_perk_locs.size > 0 )
		{
			a_s_random_perk_locs = array::randomize( a_s_random_perk_locs );
		}
	
		n_random_perks_assigned = 0;
	}

	// Now spawn perk machines
	foreach( s_spawn_pos in a_s_spawn_pos )
	{
		perk = s_spawn_pos.script_noteworthy;
		if(IsDefined(perk) && IsDefined(s_spawn_pos.model))
		{
			// Setting a script_notify on the perk machine struct indicates this machine will be assigned a random location
			// if script_notify doesn't exist on the perk machine, it's not randomized.
			// Make sure the number of perk_random_machine_locations matches the number you want to randomize
			if( ( isdefined( level.randomize_perk_machine_location ) && level.randomize_perk_machine_location ) && a_s_random_perk_locs.size > 0 && isdefined( s_spawn_pos.script_notify ) )
			{
				s_new_loc = a_s_random_perk_locs[n_random_perks_assigned];
				
				s_spawn_pos.origin = s_new_loc.origin;
				s_spawn_pos.angles = s_new_loc.angles;
				
				// Make sure it uses power at the current location
				if ( isdefined( s_new_loc.script_int ) )
				{
					s_spawn_pos.script_int = s_new_loc.script_int;
				}
					
				//setup up perk machine tells (broken bottle) if is available
				if( isdefined( s_new_loc.target ) )
				{
					s_tell_location = struct::get( s_new_loc.target );
					
					if( isdefined( s_tell_location ) )
					{
						util::spawn_model( "p7_zm_perk_bottle_broken_" + perk , s_tell_location.origin, s_tell_location.angles );
					}
				}
				
				n_random_perks_assigned++;
			}
			
			use_trigger = Spawn( "trigger_radius_use", s_spawn_pos.origin + (0, 0, 30), 0, 40, 70 );
			use_trigger.targetname = "zombie_vending";			
			use_trigger.script_noteworthy = perk;
			
			//DCS: setup power_zone if required
			if(IsDefined(s_spawn_pos.script_int))
			{
				use_trigger.script_int = s_spawn_pos.script_int;
			}	
			
			use_trigger TriggerIgnoreTeam();
			//use_trigger thread debug_spot();
	
			perk_machine = Spawn("script_model", s_spawn_pos.origin);
			if( !isdefined(s_spawn_pos.angles) )
				s_spawn_pos.angles = (0,0,0);
			perk_machine.angles = s_spawn_pos.angles;
			perk_machine SetModel(s_spawn_pos.model);
				
			
			if(( isdefined( level._no_vending_machine_bump_trigs ) && level._no_vending_machine_bump_trigs ))
			{
				bump_trigger = undefined; // make the var even though we might not use it	
			}
			else
			{
				bump_trigger = Spawn( "trigger_radius", s_spawn_pos.origin, 0, 35, 64);
				bump_trigger.script_activated = 1;
				bump_trigger.script_sound = "zmb_perks_bump_bottle";
				bump_trigger.targetname = "audio_bump_trigger";
			}


			if(( isdefined( level._no_vending_machine_auto_collision ) && level._no_vending_machine_auto_collision ))
			{
				collision = undefined; // make the var even though we might not use it		
			}
			else
			{
				collision = Spawn("script_model", s_spawn_pos.origin, 1);
				collision.angles = s_spawn_pos.angles;
				collision SetModel("zm_collision_perks1");
				collision.script_noteworthy = "clip";
				collision DisconnectPaths();
			}

			// Connect all of the pieces for easy access.
			use_trigger.clip = collision;
			use_trigger.machine = perk_machine;
			use_trigger.bump = bump_trigger;
			
			if( IsDefined( s_spawn_pos.blocker_model ) )
				use_trigger.blocker_model = s_spawn_pos.blocker_model;
			
			if( IsDefined( s_spawn_pos.script_int ) )
				perk_machine.script_int = s_spawn_pos.script_int;
			
			if( IsDefined( s_spawn_pos.turn_on_notify ) )
				perk_machine.turn_on_notify = s_spawn_pos.turn_on_notify;
			
			use_trigger.script_sound = "mus_perks_speed_jingle";
			use_trigger.script_string = "speedcola_perk";
			use_trigger.script_label = "mus_perks_speed_sting";
			use_trigger.target = "vending_sleight";
			perk_machine.script_string = "speedcola_perk";
			perk_machine.targetname = "vending_sleight";
			if(IsDefined(bump_trigger))
				bump_trigger.script_string = "speedcola_perk";
			
			// handle custom perk fields here
			if ( IsDefined( level._custom_perks[ perk ] ) && IsDefined( level._custom_perks[ perk ].perk_machine_set_kvps ) )
			{
				[[ level._custom_perks[ perk ].perk_machine_set_kvps ]]( use_trigger, perk_machine, bump_trigger, collision );
			}			
		}
	}	
}	


function get_perk_machine_start_state( perk )
{
	if ( ( isdefined( level.vending_machines_powered_on_at_start ) && level.vending_machines_powered_on_at_start ) )
	{
		return true;
	}

	if ( perk == "specialty_quickrevive" )
	{
		assert(isdefined(level.revive_machine_is_solo));
		return level.revive_machine_is_solo;
	}

	return false;
}


function perks_register_clientfield()
{
	if( ( isdefined( level.zombiemode_using_perk_intro_fx ) && level.zombiemode_using_perk_intro_fx ) )
	{
		clientfield::register( "scriptmover", "clientfield_perk_intro_fx" , 1 , 1 ,"int");
	}
	
	// run any custom perk clientfield registration funcs here
	if ( IsDefined( level._custom_perks ) )
	{
		a_keys = GetArrayKeys( level._custom_perks );
		
		for ( i = 0; i < a_keys.size; i++ )
		{
			if ( IsDefined( level._custom_perks[ a_keys[ i ] ].clientfield_register ) )
			{
				level [[ level._custom_perks[ a_keys[ i ] ].clientfield_register ]]();
			}
		}
	}
}

function thread_bump_trigger()
{
	for(;;)
	{
		self waittill( "trigger", trigPlayer );
		trigPlayer playsound( self.script_sound );
		
		while( zm_utility::is_player_valid(trigPlayer) && trigplayer istouching( self ) )
		{
			wait(.5);
		}
	}	
}

function players_are_in_perk_area(perk_machine)
{
	perk_area_origin = level.quick_revive_default_origin;
	
	if(isdefined(perk_machine._linked_ent))
	{
		perk_area_origin = perk_machine._linked_ent.origin;
		
		if(isdefined(perk_machine._linked_ent_offset))
		{
			perk_area_origin += perk_machine._linked_ent_offset;
		}
	}

	in_area = false;
	players = GetPlayers();
	dist_check = 96*96;
	
	foreach( player in players )
	{
		if( DistanceSquared(player.origin,perk_area_origin) < dist_check )
		{
			return true;
		}
	}
	
	return false;

}

function perk_hostmigration()
{
	level endon("end_game");
	
	level notify("perk_hostmigration");
	level endon("perk_hostmigration");
		
	while(1)
	{
		level waittill("host_migration_end");
		
		if( isdefined( level._custom_perks ) )
		{
			foreach( perk in level._custom_perks )
			{
				if( IsDefined( level._custom_perks[ perk ].radiant_machine_name ) && IsDefined( level._custom_perks[ perk ].machine_light_effect ) )
				{
					level thread host_migration_func( level._custom_perks[ perk ] );	
				}
			}
		}
	}
}

// when host migration occurs, fx don't carry over. If perk machine is on, turn the light back on.
function host_migration_func( s_custom_perk )
{
	a_machines = GetEntArray( s_custom_perk.radiant_machine_name, "targetname" );	
	
	foreach( perk in a_machines)
	{
		if(isDefined(perk.model) && perk.model == s_custom_perk.on_model)
		{
			perk zm_perks::perk_fx( undefined, true );
			perk thread zm_perks::perk_fx( s_custom_perk.machine_light_effect );
		}
	}
}


//*****************************************************************************
// Returns an array of all the perks the player has
//*****************************************************************************

// self = player
function get_perk_array()
{
	perk_array = [];
	
	// handle custom perks
	if ( level._custom_perks.size > 0 )
	{
		a_keys = GetArrayKeys( level._custom_perks );
		
		for ( i = 0; i < a_keys.size; i++ )
		{
			if ( self HasPerk( a_keys[ i ] ) )
			{
				perk_array[ perk_array.size ] = a_keys[ i ];
			}
		}
	}

	return( perk_array );
}

function initialize_custom_perk_arrays()
{
	if ( !IsDefined( level._custom_perks ) )
	{
		level._custom_perks = [];
	}
}

function register_revive_success_perk_func( revive_func )
{
	if( !isdefined( level.a_revive_success_perk_func ) )
	{
		level.a_revive_success_perk_func = [];
	}
	
	level.a_revive_success_perk_func[ level.a_revive_success_perk_func.size ] = revive_func;
}

/@
"Name: register_perk_basic_info( <str_perk>, <str_alias>, <n_perk_cost>, <str_hint_string>, <w_perk_bottle_weapon> )"
"Module: Zombie Perks"
"Summary: Register basic info for a custom perk"
"MandatoryArg: <str_perk>: the name of the specialty that this perk uses. This should be unique, and will identify this perk in system scripts."
"MandatoryArg: <str_alias>: the actual name of the perk, which is referenced by script as a notify."
"MandatoryArg: <n_perk_cost>: how much it will cost to buy this perk from a perk machine"
"MandatoryArg: <str_hint_string> the string hint that will show up when players can buy the perk from a machine"
"MandatoryArg: <w_perk_bottle_weapon>: the name of the unique weapon that shows up when the perk is given"
"Example: register_perk_basic_info( "specialty_vultureaid", "vulture", 2000, &"ZOMBIE_PERK_HINT_VULTURE", GetWeapon( "zombie_perk_bottle_vulture" ) );"
"SPMP: multiplayer"
@/
function register_perk_basic_info( str_perk, str_alias, n_perk_cost, str_hint_string, w_perk_bottle_weapon )
{
	Assert( IsDefined( str_perk ), "str_perk is a required argument for register_perk_basic_info!" );
	Assert( IsDefined( str_alias ), "str_alias is a required argument for register_perk_basic_info!" );
	Assert( IsDefined( n_perk_cost ), "n_perk_cost is a required argument for register_perk_basic_info!" );
	Assert( IsDefined( str_hint_string ), "str_hint_string is a required argument for register_perk_basic_info!" );
	Assert( IsDefined( w_perk_bottle_weapon ), "w_perk_bottle_weapon is a required argument for register_perk_basic_info!" );
	
	_register_undefined_perk( str_perk );
	
	level._custom_perks[ str_perk ].alias = str_alias;
	level._custom_perks[ str_perk ].cost = n_perk_cost;
	level._custom_perks[ str_perk ].hint_string = str_hint_string;
	level._custom_perks[ str_perk ].perk_bottle_weapon = w_perk_bottle_weapon;
}

/@
"Name: register_perk_machine( <str_perk>, <func_perk_machine_setup>, <func_perk_machine_thread> )"
"Module: Zombie Perks"
"Summary: Register perk machine functionality for use with a custom perk"
"MandatoryArg: <str_perk>: the name of the specialty that this perk uses. This should be unique, and will identify this perk in system scripts."
"MandatoryArg: <func_perk_machine_setup>: setup function for perk machine. Note that this will need to take in four arguments: use_trigger, perk_machine, bump_trigger, collision, and set fields on each ent."
"OptionalArg: <func_perk_machine_thread>: init function for a perk machine"
"Example: register_perk_machine( "specialty_vultureaid", &vulture_perk_machine_setup, &vulture_perk_machine_think );"
"SPMP: multiplayer"
@/
function register_perk_machine( str_perk, func_perk_machine_setup, func_perk_machine_thread )
{
	Assert( IsDefined( str_perk ), "str_perk is a required argument for register_perk_machine!" );
	Assert( IsDefined( func_perk_machine_setup ), "func_perk_machine_setup is a required argument for register_perk_machine!" );
	
	_register_undefined_perk( str_perk );
	
	if ( !IsDefined( level._custom_perks[ str_perk ].perk_machine_set_kvps ) )
	{
		level._custom_perks[ str_perk ].perk_machine_set_kvps = func_perk_machine_setup;
	}
	
	if ( !IsDefined( level._custom_perks[ str_perk ].perk_machine_thread ) && isdefined( func_perk_machine_thread ) )
	{
		level._custom_perks[ str_perk ].perk_machine_thread = func_perk_machine_thread;
	}	
}

/@
"Name: register_perk_machine_power_override( <str_perk>, <func_perk_machine_power_override> )"
"Module: Zombie Perks"
"Summary: Register perk machine power override for use with a custom perk that has specific power needs"
"MandatoryArg: <str_perk>: the name of the specialty that this perk uses. This should be unique, and will identify this perk in system scripts."
"OptionalArg: <func_perk_machine_power_override>: custom power function for a perk machine"
"Example: register_perk_machine_power_override( PERK_QUICK_REVIVE, &turn_revive_on );"
"SPMP: multiplayer"
@/
function register_perk_machine_power_override( str_perk, func_perk_machine_power_override )
{
	Assert( IsDefined( str_perk ), "str_perk is a required argument for register_perk_machine_power_override!" );
	Assert( IsDefined( func_perk_machine_power_override ), "func_perk_machine_power_override is a required argument for register_perk_machine_power_override!" );
	
	_register_undefined_perk( str_perk );
	
	if ( !IsDefined( level._custom_perks[ str_perk ].perk_machine_power_override_thread ) && isdefined( func_perk_machine_power_override ) )
	{
		level._custom_perks[ str_perk ].perk_machine_power_override_thread = func_perk_machine_power_override;
	}	
}

/@
"Name: register_perk_precache_func( <str_perk>, <func_precache> )"
"Module: Zombie Perks"
"Summary: Register precache function for a perk"
"MandatoryArg: <str_perk>: the name of the specialty that this perk uses. This should be unique, and will identify this perk in system scripts."
"MandatoryArg: <func_precache>: this function will run when perk machines are precached. Add in strings, fx, models, weapons, etc. here."
"Example: register_perk_precache_func( "specialty_vultureaid", &vulture_precache );"
"SPMP: multiplayer"
@/
function register_perk_precache_func( str_perk, func_precache )
{
	Assert( IsDefined( str_perk ), "str_perk is a required argument for register_perk_precache_func!" );
	Assert( IsDefined( func_precache ), "func_precache is a required argument for register_perk_precache_func!" );
	
	_register_undefined_perk( str_perk );
	
	if ( !IsDefined( level._custom_perks[ str_perk ].precache_func ) )
	{
		level._custom_perks[ str_perk ].precache_func = func_precache;
	}
}

/@
"Name: register_perk_threads( <str_perk>, <func_give_player_perk>, [func_take_player_perk] )"
"Module: Zombie Perks"
"Summary: Registers functions to run when zombie perks are given to and taken from players."
"MandatoryArg: <str_perk>: the name of the specialty that this perk uses. This should be unique, and will identify this perk in system scripts."
"MandatoryArg: <func_give_player_perk>: this function will run when the player gets the perk. All the perk functionality run on players should go here. This will be called on player."
"MandatoryArg: [func_take_player_perk]: this function will run when the player loses the perk (downed, power off, etc.). All the perk functionality should be taken away here. This will be called on player."
"Example: register_perk_threads( "specialty_vultureaid", &give_vulture_perk, &take_vulture_perk );"
"SPMP: multiplayer"
@/
function register_perk_threads( str_perk, func_give_player_perk, func_take_player_perk )
{
	Assert( IsDefined( str_perk ), "str_perk is a required argument for register_perk_threads!" );
	Assert( IsDefined( func_give_player_perk ), "func_give_player_perk is a required argument for register_perk_threads!" );

	_register_undefined_perk( str_perk );
	
	if( !IsDefined( level._custom_perks[ str_perk ].player_thread_give ) )
	{
		level._custom_perks[ str_perk ].player_thread_give = func_give_player_perk;
	}
	
	if ( IsDefined( func_take_player_perk ) )
	{
		if ( !IsDefined( level._custom_perks[ str_perk ].player_thread_take ) )
		{
			level._custom_perks[ str_perk ].player_thread_take = func_take_player_perk;
		}
	}
}


/@
"Name: register_perk_clientfields( <str_perk>, <func_clientfield_register>, <func_clientfield_set> )"
"Module: Zombie Perks"
"Summary: Registers functions to register and set clientfields for a perk. These are used to set and clear hud elements when the perk is toggled."
"MandatoryArg: <str_perk>: the name of the specialty that this perk uses. This should be unique, and will identify this perk in system scripts."
"MandatoryArg: <func_clientfield_register>: sets up the clientfield for the perk. Should look like 'clientfield::register( "toplayer", "perk_vulture", VERSION_SHIP, 1, "int" );' ."
"MandatoryArg: <func_clientfield_set>: this function will be called when perk is toggled. Should look like 'self clientfield::set_to_player( "perk_vulture", state );', and requires argument 'state'"
"Example: register_perk_clientfields( "specialty_vultureaid", &vulture_register_clientfield, &vulture_set_clientfield );"
"SPMP: multiplayer"
@/
function register_perk_clientfields( str_perk, func_clientfield_register, func_clientfield_set )
{
	Assert( IsDefined( str_perk ), "str_perk is a required argument for register_perk_clientfields!" );
	Assert( IsDefined( func_clientfield_register ), "func_clientfield_register is a required argument for register_perk_clientfields!" );
	Assert( IsDefined( func_clientfield_set ), "func_clientfield_set is a required argument for register_perk_clientfields!" );
	
	_register_undefined_perk( str_perk );
	
	if ( !IsDefined( level._custom_perks[ str_perk ].clientfield_register ) )
	{
		level._custom_perks[ str_perk ].clientfield_register = func_clientfield_register;
	}
	
	if ( !IsDefined( level._custom_perks[ str_perk ].clientfield_set ) )
	{
		level._custom_perks[ str_perk ].clientfield_set = func_clientfield_set;
	}		
}

/@
"Name: register_perk_host_migration_params( <str_perk>, <func_host_migration> )"
"Module: Zombie Perks"
"Summary: Registers function to run when host migration occurs. This is most commonly used to turn fx back on on active perk machines."
"MandatoryArg: <str_perk>: the name of the specialty that this perk uses. This should be unique, and will identify this perk in system scripts."
"MandatoryArg: <func_host_migration>: This function will be threaded off of level when host migration occurs."
"Example: register_perk_host_migration_params( "specialty_vultureaid", &vulture_host_migration_func );"
"SPMP: multiplayer"
@/
function register_perk_host_migration_params( str_perk, str_radiant_name, str_effect_name )
{
	Assert( IsDefined( str_perk ), "str_perk is a required argument for register_perk_host_migration_params!" );
	Assert( IsDefined( str_radiant_name ), "str_radiant_name is a required argument for register_perk_host_migration_params!" );
	Assert( IsDefined( str_effect_name ), "str_effect_name is a required argument for register_perk_host_migration_params!" );
	
	_register_undefined_perk( str_perk );
	
	if ( !IsDefined( level._custom_perks[ str_perk ].radiant_name ) )
	{
		level._custom_perks[ str_perk ].radiant_machine_name = str_radiant_name;
	}
	
	if ( !IsDefined( level._custom_perks[ str_perk ].light_effect ) )
	{
		level._custom_perks[ str_perk ].machine_light_effect = str_effect_name;
	}	
}

// make sure perk exists before we actually try to set fields on it. Does nothing if it exists already
function _register_undefined_perk( str_perk )
{
	if ( !IsDefined( level._custom_perks ) )
	{
		level._custom_perks = [];
	}
	
	if ( !IsDefined( level._custom_perks[ str_perk ] ) )
	{
		level._custom_perks[ str_perk ] = SpawnStruct();
	}	
}

/@
"Name: register_perk_damage_override_func( <func_damage_override> )"
"Module: Zombie Perks"
"Summary: Registers function to run when player damage occurs. Used to specify what happens for a specific perk."
"MandatoryArg: <func_damage_override>: This function will be threaded off of self when player damage occurs."
"Example: register_perk_damage_override_func( &divetonuke_damage_override_func );"
"SPMP: multiplayer"
@/
function register_perk_damage_override_func( func_damage_override )
{
	Assert( IsDefined( func_damage_override ), "func_damage_override is a required argument for register_perk_damage_override_func!" );
	
	if ( !IsDefined( level.perk_damage_override ) )
	{
		level.perk_damage_override = [];
	}
	
	array::add( level.perk_damage_override, func_damage_override, false );
}

// PI_CHANGE_END
