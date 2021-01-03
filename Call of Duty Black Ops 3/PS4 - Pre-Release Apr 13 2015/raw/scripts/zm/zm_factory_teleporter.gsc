#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_factory;


#precache( "model", "collision_wall_128x128x10" );

function autoexec __init__sytem__() {     system::register("zm_factory_teleporter",&__init__,&__main__,undefined);    }

function __init__()
{	
	// DCS: added to fix non-attacking dogs.
	level.dog_melee_range = 130;
	level thread dog_blocker_clip();

	level.teleport = [];
	level.active_links = 0;
	level.countdown = 0;

	level.teleport_delay = 2;
	level.teleport_cost = 1500;
	level.teleport_cooldown = 5;
	level.is_cooldown = false;
	level.active_timer = -1;
	level.teleport_time = 0;

	// use this array to convert a teleport_pad index to a, b, or c
	level.teleport_pad_names = [];
	level.teleport_pad_names[0] = "a";
	level.teleport_pad_names[1] = "c";
	level.teleport_pad_names[2] = "b";

	level flag::init( "teleporter_pad_link_1" );
	level flag::init( "teleporter_pad_link_2" );
	level flag::init( "teleporter_pad_link_3" );

	visionset_mgr::register_info( "overlay", "zm_factory_transported", 1, 20, 15, true, &visionset_mgr::duration_lerp_thread_per_player, false );
}


function __main__()
{
	// Get the Pad triggers
	for ( i=0; i<3; i++ )
	{
		trig = GetEnt( "trigger_teleport_pad_" + i, "targetname");
		if ( IsDefined(trig) )
		{
			level.teleporter_pad_trig[i] = trig;
		}
	}

	level thread teleport_pad_think( 0 );
	level thread teleport_pad_think( 1 );
	level thread teleport_pad_think( 2 );
	level thread teleport_core_think();

	level thread init_pack_door();
	
	//mp_downhill_fx::SetDvar( "factoryAftereffectOverride", "-1" );
	//SetSavedDvar( "zombiemode_path_minz_bias", 13 );
	level.no_dog_clip = true;

	packapunch_see = getent( "packapunch_see", "targetname" );
	if(isdefined( packapunch_see ) )
	{
		packapunch_see thread play_packa_see_vox();
	}
	
	level.teleport_ae_funcs = [];
	
	if( !IsSplitscreen() )
	{
		level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_factory_teleporter::teleport_aftereffect_fov;
	}
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_factory_teleporter::teleport_aftereffect_shellshock;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_factory_teleporter::teleport_aftereffect_shellshock_electric;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_factory_teleporter::teleport_aftereffect_bw_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_factory_teleporter::teleport_aftereffect_red_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_factory_teleporter::teleport_aftereffect_flashy_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_factory_teleporter::teleport_aftereffect_flare_vision;
}

//-------------------------------------------------------------------------------
// sets up up the pack a punch door
//-------------------------------------------------------------------------------
function init_pack_door()
{
	//DCS: create collision blocker till door in place at load.
	collision = Spawn("script_model", (-56, 467, 157));
	collision setmodel("collision_wall_128x128x10");
	collision.angles = (0, 0, 0);
	collision Hide();	
	
	door = getent( "pack_door", "targetname" );
	door movez( -50, 0.05, 0 );
	wait(1.0);

	level flag::wait_till( "start_zombie_round_logic" );

	door movez(  50, 1.5, 0 );
	door playsound( "evt_packa_door_1" );

	//DCS: waite for door to be in place then delete blocker.
	wait(2);
	collision Delete();

	// Open slightly the first two times
	level flag::wait_till( "teleporter_pad_link_1" );
	door movez( -35, 1.5, 1 );
	door playsound( "evt_packa_door_2" );
	door thread packa_door_reminder();
	wait(2);

	// Second link
	level flag::wait_till( "teleporter_pad_link_2" );
	door movez( -25, 1.5, 1 );
	door playsound( "evt_packa_door_2" );
	wait(2);

	// Final Link
	level flag::wait_till( "teleporter_pad_link_3" );

	door movez( -60, 1.5, 1 );
	door playsound( "evt_packa_door_2" );

	//door rotateyaw( -90, 1.5, 1 );

	clip = getentarray( "pack_door_clip", "targetname" );
	for ( i = 0; i < clip.size; i++ )
	{
		clip[i] connectpaths();
		clip[i] delete();
	}
}

//-------------------------------------------------------------------------------
// handles activating and deactivating pads for cool down
//-------------------------------------------------------------------------------
function pad_manager()
{
	for ( i = 0; i < level.teleporter_pad_trig.size; i++ )
	{
		// shut off the pads
		level.teleporter_pad_trig[i] sethintstring( &"ZOMBIE_TELEPORT_COOLDOWN" );
		level.teleporter_pad_trig[i] teleport_trigger_invisible( false );
	}

	level.is_cooldown = true;
	wait( level.teleport_cooldown );
	level.is_cooldown = false;

	for ( i = 0; i < level.teleporter_pad_trig.size; i++ )
	{
		if ( level.teleporter_pad_trig[i].teleport_active )
		{
			level.teleporter_pad_trig[i] sethintstring( &"ZOMBIE_TELEPORT_TO_CORE" );
		}
		else
		{
			level.teleporter_pad_trig[i] sethintstring( &"ZOMBIE_LINK_TPAD" );
		}
//		level.teleporter_pad_trig[i] teleport_trigger_invisible( false );
	}
}

//-------------------------------------------------------------------------------
// handles turning on the pad and waiting for link
//-------------------------------------------------------------------------------
function teleport_pad_think( index )
{
	tele_help = getent( "tele_help_" + index, "targetname" );
	if(isdefined( tele_help ) )
	{
		tele_help thread play_tele_help_vox();
	}
	
	active = false;
	
	// init the pad
	level.teleport[index] = "waiting";

	trigger = level.teleporter_pad_trig[ index ];

	trigger setcursorhint( "HINT_NOICON" );
	trigger sethintstring( &"ZOMBIE_NEED_POWER" );

	level flag::wait_till( "power_on" );

	trigger sethintstring( &"ZOMBIE_POWER_UP_TPAD" );
	trigger.teleport_active = false;

	if ( isdefined( trigger ) )
	{
		while ( !active )
		{
			trigger waittill( "trigger" );

			if ( level.active_links < 3 )
			{
				trigger_core = getent( "trigger_teleport_core", "targetname" );
				trigger_core teleport_trigger_invisible( false );
			}

			// when one starts the others disabled
			for ( i=0; i<level.teleporter_pad_trig.size; i++ )
			{
				level.teleporter_pad_trig[ i ] teleport_trigger_invisible( true );
			}
			level.teleport[index] = "timer_on";
			
			// start the countdown back to the core
			trigger thread teleport_pad_countdown( index, 30 );
			teleporter_vo( "countdown", trigger );

			// wait for the countdown
			while ( level.teleport[index] == "timer_on" )
			{
				wait( .05 );
			}

			// core was activated in time
			if ( level.teleport[index] == "active" )
			{
				active = true;
				level util::clientNotify( "pw" + index );	// pad wire #
											
				//AUDIO
				level util::clientNotify( "tp" + index );	// Teleporter #

				// MM - Auto teleport the first time
				teleporter_wire_wait( index );

//				trigger teleport_trigger_invisible( true );
				trigger thread player_teleporting( index );
			}
			else
			{
				// Reenable triggers
 				for ( i=0; i<level.teleporter_pad_trig.size; i++ )
 				{
 					level.teleporter_pad_trig[ i ] teleport_trigger_invisible( false );
 				}
			}
			wait( .05 );
		}

		if ( level.is_cooldown )
		{
			// shut off the pads
			trigger sethintstring( &"ZOMBIE_TELEPORT_COOLDOWN" );
			trigger teleport_trigger_invisible( false );
			trigger.teleport_active = true;
		}
		else
		{
			trigger thread teleport_pad_active_think( index );
		}
	}
}

//-------------------------------------------------------------------------------
// updates the teleport pad timer
//-------------------------------------------------------------------------------
function teleport_pad_countdown( index, time )
{
	self endon( "stop_countdown" );

//	iprintlnbold( &"WAW_ZOMBIE_START_TPAD" );

	if ( level.active_timer < 0 )
	{
		level.active_timer = index;
	}

	level.countdown++;

	self thread sndCountdown();
	level util::clientNotify( "TRf" );	// Teleporter receiver map light flash

	// start timer for all players
	//	Add a second for VO sync
	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread zm_timer::start_timer( time+1, "stop_countdown" );
	}
	wait( time+1 );

	if ( level.active_timer == index )
	{
		level.active_timer = -1;
	}

	// ran out of time to activate teleporter
	level.teleport[index] = "timer_off";
//	iprintlnbold( "out of time" );
	level util::clientNotify( "TRs" );	// Stop flashing the receiver map light

	level.countdown--;
}
function sndCountdown()
{
	self endon( "stop_countdown" );
	

	clock_sound = spawn ("script_origin", (0,0,0));
	clock_sound thread clock_timer();
	
	level thread zm_factory::sndPA_DoVox( "vox_maxis_teleporter_ultimatum_0" );

	count = 30;
	num = 11;
	while ( count > 0 )
	{
		play = (count == 20 || count == 15 || count <= 10);
		if ( play )
		{
			level thread zm_factory::sndPA_DoVox( "vox_maxis_teleporter_count_" + num, undefined, true );
			num--;
		}
		//playsoundatposition( "evt_clock_tick_1sec", (0,0,0) );	Changed this to looped sound to avoid stuttering audio
		wait( 1 );
		count--;
	}
	level notify ("stop_countdown");
	
	level thread zm_factory::sndPA_DoVox( "vox_maxis_teleporter_expired_0" );
}
function clock_timer()
{
	level util::delay( 0, undefined, &zm_audio::sndMusicSystem_PlayState, "timer" );
	self playloopsound ("evt_clock_tick_1sec");	
	level waittill ("stop_countdown");
	
	if( isdefined( level.musicSystem.currentState ) && level.musicSystem.currentState == "timer" )
	{
		level thread zm_audio::sndMusicSystem_StopAndFlush();
	}
	
	self stoploopsound(0);
	self delete();
	
}
//-------------------------------------------------------------------------------
// handles teleporting players when triggered
//-------------------------------------------------------------------------------
function teleport_pad_active_think( index )
{
//	self endon( "player_teleported" );

	// link established, can be used to teleport
	self setcursorhint( "HINT_NOICON" );
	self.teleport_active = true;

	user = undefined;

//	self sethintstring( &"WAW_ZOMBIE_TELEPORT_TO_CORE" );
//	self teleport_trigger_invisible( false );

	while ( 1 )
	{
		self waittill( "trigger", user );

		if ( zm_utility::is_player_valid( user ) && user.score >= level.teleport_cost && !level.is_cooldown )
		{
			for ( i = 0; i < level.teleporter_pad_trig.size; i++ )
			{
				level.teleporter_pad_trig[i] teleport_trigger_invisible( true );
			}

			user zm_score::minus_to_player_score( level.teleport_cost );

			// Non-threaded so the trigger doesn't activate before the cooldown
			self player_teleporting( index );
		}
	}
}

//-------------------------------------------------------------------------------
// handles moving the players and fx, etc...moved out so it can be threaded
//-------------------------------------------------------------------------------
function player_teleporting( index )
{
	time_since_last_teleport = GetTime() - level.teleport_time;

	// begin the teleport
	// add 3rd person fx
	exploder::exploder_duration( "teleporter_" + level.teleport_pad_names[index] + "_teleporting", 5.3 );

	// play startup fx at the core
	exploder::exploder_duration( "mainframe_warm_up", 4.8 );

	//AUDIO
	level util::clientNotify( "tpw" + index );
	level thread zm_factory::sndPA_DoVox( "vox_maxis_teleporter_success_0" );

	// start fps fx
	self thread teleport_pad_player_fx( level.teleport_delay );
	
	//AUDIO
	self thread teleport_2d_audio();

	// Activate the TP zombie kill effect
	self thread teleport_nuke( 20, 300);	// Max 20 zombies and range 300

	// wait a bit
	wait( level.teleport_delay );

	// end fps fx
	self notify( "fx_done" );

	// add 3rd person beam fx
//	teleport_pad_end_exploder( index );

	// teleport the players
	self teleport_players();

	// only need this if it's not cooling down
	if ( level.is_cooldown == false )
	{
		thread pad_manager();
	}

	// Now spawn a powerup goodie after a few seconds
	wait( 2.0 );
	ss = struct::get( "teleporter_powerup", "targetname" );
	if ( IsDefined( ss ) )
	{
		ss thread zm_powerups::special_powerup_drop(ss.origin);
	}

	// Special for teleporting too much.  The Dogs attack!
	if ( time_since_last_teleport < 60000 && level.active_links == 3 && level.round_number > 20 )
	{
		//dog_spawners = GetEntArray( "special_dog_spawner", "targetname" );
		//_zombiemode_ai_dogs::special_dog_spawn( undefined, 4 );
		//iprintlnbold( "Samantha Sez: No Powerup For You!" );
		thread zm_utility::play_sound_2D( "vox_sam_nospawn" );
	}
	level.teleport_time = GetTime();
}

//-------------------------------------------------------------------------------
// used to enable / disable the pad use trigger for players
//-------------------------------------------------------------------------------
function teleport_trigger_invisible( enable )
{
	players = GetPlayers();

	for ( i = 0; i < players.size; i++ )
	{
		if ( isdefined( players[i] ) )
		{
			self SetInvisibleToPlayer( players[i], enable );
		}
	}
}

//-------------------------------------------------------------------------------
// checks if player is within radius of the teleport pad
//-------------------------------------------------------------------------------
function player_is_near_pad( player )
{
	radius = 88;
	scale_factor = 2;

	dist = Distance2D( player.origin, self.origin );
	dist_touching = radius * scale_factor;

	if ( dist < dist_touching )
	{
		return true;
	}

	return false;
}


//-------------------------------------------------------------------------------
// this is the 1st person effect seen when touching the teleport pad
//-------------------------------------------------------------------------------
function teleport_pad_player_fx( duration )
{
	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( isdefined( players[i] ) )
		{
			if ( self player_is_near_pad( players[i] ) )
			{
				visionset_mgr::activate( "overlay", "zm_factory_transported", players[i], duration, duration );
			}
		}
	}
}

//-------------------------------------------------------------------------------
// send players back to the core
//-------------------------------------------------------------------------------
function teleport_players()
{
	player_radius = 16;

	players = GetPlayers();

	core_pos = [];
	occupied = [];
	image_room = [];
	players_touching = [];		// the players that will actually be teleported

	player_idx = 0;

	prone_offset = (0, 0, 49);
	crouch_offset = (0, 0, 20);
	stand_offset = (0, 0, 0);

	// send players to a black room to flash images for a few seconds
	for ( i = 0; i < 4; i++ )
	{
		core_pos[i] = getent( "origin_teleport_player_" + i, "targetname" );
		occupied[i] = false;
		image_room[i] = getent( "teleport_room_" + i, "targetname" );

		if ( isdefined( players[i] ) )
		{
			// filter::SetTransported( players[i] );
			
			if ( self player_is_near_pad( players[i] ) )
			{
				players_touching[player_idx] = i;
				player_idx++;

				if ( isdefined( image_room[i] ) )
				{
					players[i] disableOffhandWeapons();
					players[i] disableweapons();
					if( players[i] getstance() == "prone" )
					{
						desired_origin = image_room[i].origin + prone_offset;
					}
					else if( players[i] getstance() == "crouch" )
					{
						desired_origin = image_room[i].origin + crouch_offset;
					}
					else
					{
						desired_origin = image_room[i].origin + stand_offset;
					}
					
					players[i].teleport_origin = Spawn( "script_origin", players[i].origin );
					players[i].teleport_origin.angles = players[i].angles;
					players[i] linkto( players[i].teleport_origin );
					players[i].teleport_origin.origin = desired_origin;
					players[i] FreezeControls( true );
					util::wait_network_frame();

					if( IsDefined( players[i] ) )
					{
						util::setClientSysState( "levelNotify", "black_box_start", players[i] );
						players[i].teleport_origin.angles = image_room[i].angles;
					}
				}
			}
		}
	}

	wait( 2 );

	// Nuke anything at the core
	core = GetEnt( "trigger_teleport_core", "targetname" );
	core thread teleport_nuke( undefined, 300);	// Max any zombies at the pad range 300

	// check if any players are standing on top of core teleport positions
	for ( i = 0; i < players.size; i++ )
	{
		if ( isdefined( players[i] ) )
		{
			for ( j = 0; j < 4; j++ )
			{
				if ( !occupied[j] )
				{
					dist = Distance2D( core_pos[j].origin, players[i].origin );
					if ( dist < player_radius )
					{
						occupied[j] = true;
					}
				}
			}
			util::setClientSysState( "levelNotify", "black_box_end", players[i] );
		}
	}

	util::wait_network_frame();

	// move players to the core
	for ( i = 0; i < players_touching.size; i++ )
	{
		player_idx = players_touching[i];
		player = players[player_idx];

		if ( !IsDefined( player ) )
		{
			continue;
		}

		// find a free space at the core
		slot = i;
		start = 0;
		while ( occupied[slot] && start < 4 )
		{
			start++;
			slot++;
			if ( slot >= 4 )
			{
				slot = 0;
			}
		}
		occupied[slot] = true;
		pos_name = "origin_teleport_player_" + slot;
		teleport_core_pos = getent( pos_name, "targetname" );

		player unlink();

		assert( IsDefined( player.teleport_origin ) );
		player.teleport_origin delete();
		player.teleport_origin = undefined;

		player enableweapons();
		player enableoffhandweapons();
		player setorigin( core_pos[slot].origin );
		player setplayerangles( core_pos[slot].angles );
		player FreezeControls( false );
		player thread teleport_aftereffects();
		
		vox_rand = randomintrange(1,100);  //RARE: Sets up rare post-teleport line
		
		if( vox_rand <= 2 )
		{
			//player teleporter_vo( "vox_tele_sick_rare" );
			//iprintlnbold( "Hey, this is the random teleport sickness line!" );
		}
		else
		{
			//player teleporter_vo( "vox_tele_sick" );
		}
		
		//player achievement_notify( "DLC3_ZOMBIE_FIVE_TELEPORTS" );
	}

	// play beam fx at the core
	exploder::exploder_duration( "mainframe_arrival", 1.7 );
	exploder::exploder_duration( "mainframe_steam", 14.6 );
}

//-------------------------------------------------------------------------------
// updates the hint string when countdown is started and expired
//-------------------------------------------------------------------------------
function teleport_core_hint_update()
{
	self setcursorhint( "HINT_NOICON" );

	while ( 1 )
	{
		// can't use teleporters until power is on
		if ( !level flag::get( "power_on" ) )
		{
			self sethintstring( &"ZOMBIE_NEED_POWER" );
		}
		else if ( teleport_pads_are_active() )
		{
			self sethintstring( &"ZOMBIE_LINK_TPAD" );
		}
		else if ( level.active_links == 0 )
		{
			self sethintstring( &"ZOMBIE_INACTIVE_TPAD" );
		}
		else
		{
			self sethintstring( "" );
		}

		wait( .05 );
	}
}

//-------------------------------------------------------------------------------
// establishes the link between teleporter pads and the core
//-------------------------------------------------------------------------------
function teleport_core_think()
{
	trigger = getent( "trigger_teleport_core", "targetname" );
	if ( isdefined( trigger ) )
	{
		trigger thread teleport_core_hint_update();

		// disable teleporters to power is turned on
		level flag::wait_till( "power_on" );

		/#
			if ( GetDvarint( "zombie_cheat" ) >= 6 )
			{
				for ( i = 0; i < level.teleport.size; i++ )
				{
					level.teleport[i] = "timer_on";
				}
			}
        #/

			while ( 1 )
			{
				if ( teleport_pads_are_active() )
				{
					cheat = false;

					/#
						if ( GetDvarInt("zombie_cheat") >= 6 )
						{
							cheat = true;
						}
                     #/

				    if ( !cheat )
					{
						trigger waittill( "trigger" );
					}


					//				trigger teleport_trigger_invisible( true );

					//				iprintlnbold( &"WAW_ZOMBIE_LINK_ACTIVE" );

					// link the activated pads
					for ( i = 0; i < level.teleport.size; i++ )
					{
						if ( isdefined( level.teleport[i] ) )
						{
							if ( level.teleport[i] == "timer_on" )
							{
								level.teleport[i] = "active";
								level.active_links++;
								level flag::set( "teleporter_pad_link_"+level.active_links );

								//AUDIO
								level thread zm_factory::sndPA_DoVox( "vox_maxis_teleporter_" + i + "active_0" );
								level util::delay( 10, undefined, &zm_audio::sndMusicSystem_PlayState, "teleporter_"+level.active_links );

								exploder::exploder( "teleporter_" + level.teleport_pad_names[i] + "_linked" );
								exploder::exploder( "lgt_teleporter_" + level.teleport_pad_names[i] + "_linked" );
								exploder::exploder_duration( "mainframe_steam", 14.6 );

								// check for all teleporters active
								if ( level.active_links == 3 )
								{
									exploder::exploder_duration( "mainframe_link_all", 4.6 );
									exploder::exploder( "mainframe_ambient" );
									level util::clientNotify( "pap1" );	// Pack-A-Punch door on
									teleporter_vo( "linkall", trigger );
//									if( level.round_number <= 7 )
//									{
//										achievement_notify( "DLC3_ZOMBIE_FAST_LINK" );
//									}
									Earthquake( 0.3, 2.0, trigger.origin, 3700 );
								}

								// stop the countdown for the teleport pad
								pad = "trigger_teleport_pad_" + i;
								trigger_pad = getent( pad, "targetname" );
								trigger_pad stop_countdown();
								level util::clientNotify( "TRs" );	// Stop flashing the receiver map light
								level.active_timer = -1;
							}
						}
					}
				}

				wait( .05 );
			}
	}
}

function stop_countdown()
{
	self notify( "stop_countdown" );
	level notify ("stop_countdown");  //using this on the new loop timer
	players = GetPlayers();
	
	for( i = 0; i < players.size; i++ )
	{
		players[i] notify( "stop_countdown" );
	}
}

//-------------------------------------------------------------------------------
// checks if any of the teleporter pads are counting down
//-------------------------------------------------------------------------------
function teleport_pads_are_active()
{
	// have any pads started?
	if ( isdefined( level.teleport ) )
	{
		for ( i = 0; i < level.teleport.size; i++ )
		{
			if ( isdefined( level.teleport[i] ) )
			{
				if ( level.teleport[i] == "timer_on" )
				{
					return true;
				}
			}
		}
	}

	return false;
}

function teleport_2d_audio()
{
	self endon( "fx_done" );

	while ( 1 )
	{
		players = GetPlayers();
		
		wait(1.7);
		
		for ( i = 0; i < players.size; i++ )
		{
			if ( isdefined( players[i] ) )
			{
				if ( self player_is_near_pad( players[i] ) )
				{
					util::setClientSysState("levelNotify", "t2d", players[i]);	
				}
			}
		}
	}
}


// kill anything near the pad
function teleport_nuke( max_zombies, range )
{
	zombies = getaispeciesarray( level.zombie_team );

	zombies = util::get_array_of_closest( self.origin, zombies, undefined, max_zombies, range );

	for (i = 0; i < zombies.size; i++)
	{
		wait (randomfloatrange(0.2, 0.3));
		if( !IsDefined( zombies[i] ) )
		{
			continue;
		}

		if( zm_utility::is_magic_bullet_shield_enabled( zombies[i] ) )
		{
			continue;
		}

		if( !( zombies[i].isdog ) )
		{
			zombies[i] zombie_utility::zombie_head_gib();
		}

		zombies[i] dodamage( 10000, zombies[i].origin );
		playsoundatposition( "nuked", zombies[i].origin );
	}
}

function teleporter_vo( tele_vo_type, location )
{
	if( !isdefined( location ))
	{
		self thread teleporter_vo_play( tele_vo_type, 2 );
	}
	else
	{
		players = GetPlayers();
		for (i = 0; i < players.size; i++)
		{
			if (distance (players[i].origin, location.origin) < 64)
			{
				switch ( tele_vo_type )
				{
					case "linkall":
						players[i] thread teleporter_vo_play( "tele_linkall" );
						break;
					case "countdown":
						players[i] thread teleporter_vo_play( "tele_count", 3 );
						break;
				}
			}
		}
	}
}

function teleporter_vo_play( vox_type, pre_wait )
{
	if(!isdefined( pre_wait ))
	{
		pre_wait = 0;
	}
	wait(pre_wait);
//	self _zm_audio::create_and_play_dialog( "level", vox_type );
}

function play_tele_help_vox()
{
	level endon( "tele_help_end" );
	
	while(1)
	{
		self waittill("trigger", who);
		
		if( level flag::get( "power_on" ) )
		{
			who thread teleporter_vo_play( "tele_help" );	
			level notify( "tele_help_end" );
		}
		
		while(IsDefined (who) && (who) IsTouching (self))
		{
			wait(0.1);
		}
	}
}

function play_packa_see_vox()
{
	wait(10);
	
	if( !level flag::get( "teleporter_pad_link_3" ) )
	{
		self waittill("trigger", who);	
		who thread teleporter_vo_play( "perk_packa_see" );
	}
}


//	
//	This should match the perk_wire_fx_client function
//	waits for the effect to travel along the wire
function teleporter_wire_wait( index )
{
	targ = struct::get( "pad_"+index+"_wire" ,"targetname");
	if ( !IsDefined( targ ) )
	{
		return;
	}

	while(isDefined(targ))
	{
		if(isDefined(targ.target))
		{
			target = struct::get(targ.target,"targetname");
			wait( 0.1 );

			targ = target;
		}
		else
		{
			break;
		}		
	}
}

// Teleporter Aftereffects
function teleport_aftereffects()
{
	if( GetDvarString( "factoryAftereffectOverride" ) == "-1" )
	{
		self thread [[ level.teleport_ae_funcs[RandomInt(level.teleport_ae_funcs.size)] ]]();
	}
	else
	{
		self thread [[ level.teleport_ae_funcs[int(GetDvarString( "factoryAftereffectOverride" ))] ]]();
	}
}

function teleport_aftereffect_shellshock()
{
/#
	println( "*** Explosion Aftereffect***\n" );
#/
	self shellshock( "explosion", 4 );
}

function teleport_aftereffect_shellshock_electric()
{
/#
	println( "***Electric Aftereffect***\n" );
#/
	self shellshock( "electrocution", 4 );
}

// tae indicates to Clientscripts that a teleporter aftereffect should start

function teleport_aftereffect_fov()
{
	util::setClientSysState( "levelNotify", "tae", self );
}

function teleport_aftereffect_bw_vision( localClientNum )
{
	util::setClientSysState( "levelNotify", "tae", self );
}

function teleport_aftereffect_red_vision( localClientNum )
{
	util::setClientSysState( "levelNotify", "tae", self );
}

function teleport_aftereffect_flashy_vision( localClientNum )
{
	util::setClientSysState( "levelNotify", "tae", self );
}

function teleport_aftereffect_flare_vision( localClientNum )
{
	util::setClientSysState( "levelNotify", "tae", self );
}

function packa_door_reminder()
{
	while( !level flag::get( "teleporter_pad_link_3" ) )
	{
		rand = randomintrange(4,16);
		self playsound( "evt_packa_door_hitch" );
		wait(rand);
	}
}

function dog_blocker_clip()
{
	//DCS: create collision blocker for dog near revive.
	collision = Spawn("script_model", (-106, -2294, 216));
	collision setmodel("collision_wall_128x128x10");
	collision.angles = (0, 37.2, 0);
	collision Hide();	
	
	// adding clip for barricade glitch
	collision = Spawn("script_model", (-1208, -439, 363));
	collision setmodel("collision_wall_128x128x10");
	collision.angles = (0, 0, 0);
	collision Hide();		
}	