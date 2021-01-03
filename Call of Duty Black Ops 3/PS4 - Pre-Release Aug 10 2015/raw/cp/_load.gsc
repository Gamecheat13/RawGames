#using scripts\codescripts\struct;

//TODO T7 - move gamewide shared files into load_shared once ZM gets a T7 pass
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\clientids_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\clientfield_shared;
#using scripts\shared\containers_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\load_shared;
#using scripts\shared\math_shared;
#using scripts\shared\medals_shared;
#using scripts\shared\music_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\_oob;
#using scripts\shared\rank_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\serverfaceanim_shared;
#using scripts\shared\string_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\weapons\antipersonnelguidance;
#using scripts\shared\weapons\multilockapguidance;

#using scripts\shared\archetype_shared\archetype_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\cp\_util;

//DO NOT REMOVE - the files below are needed for registration

//Gametype registration
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_spawning;

//System registration
#using scripts\cp\_ammo_cache;
#using scripts\cp\_art;
#using scripts\cp\_cache;
#using scripts\cp\_challenges;
#using scripts\cp\_debug;
#using scripts\cp\_destructible;
#using scripts\cp\_devgui;
#using scripts\cp\_laststand;
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_vehicle;
#using scripts\cp\_mobile_armory;
#using scripts\cp\bots\_bot;

//Weapon registration
//#using scripts\cp\_acousticsensor;
#using scripts\cp\_ballistic_knife;
#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\_bouncingbetty;
//#using scripts\cp\_claymore;
#using scripts\cp\_decoy;
#using scripts\cp\_explosive_bolt;
#using scripts\cp\_flashgrenades;
#using scripts\cp\_hacker_tool;
#using scripts\cp\_heatseekingmissile;
#using scripts\cp\_proximity_grenade;
#using scripts\cp\_riotshield;
#using scripts\cp\_satchel_charge;
//#using scripts\cp\_scrambler;
#using scripts\cp\_sensor_grenade;
#using scripts\cp\_smokegrenade;
#using scripts\cp\_tabun;
#using scripts\cp\_tacticalinsertion;
#using scripts\cp\_trophy_system;
#using scripts\cp\gametypes\_weaponobjects;

//Abilities registration
#using scripts\shared\abilities\_ability_player;

#precache( "material", "overlay_low_health_splat" );
#precache( "fx", "_t6/bio/player/fx_footstep_dust" );
#precache( "fx", "_t6/bio/player/fx_footstep_sand" );
#precache( "fx", "_t6/bio/player/fx_footstep_mud" );
#precache( "fx", "_t6/bio/player/fx_footstep_water" );

#namespace load;

function main()
{
	/#
	
	Assert( isdefined( level.first_frame ), "There should be no waits before load::main." );
	
	#/
	
	if ( ( isdefined( level._loadStarted ) && level._loadStarted ) )
	{
		// In CP let load::main be called more than once for simplicity in setting up HUB neighborhoods
		return;
	}

	level flag::init( "bsp_swap_ready" );
	level flag::init( "initial_streamer_ready" );
	
	level._loadStarted = true;
	
	//TODO T7 - TEMP Hack to disable doublejump by default. Still required to support levels where it is needed for progression
    SetDvar( "playerEnenergy_enabled", 0 );
	
	// AE 10-29-09: added this to turn off the water fog
	SetDvar("r_waterFogTest", 0);
	SetDvar( "tu6_player_shallowWaterHeight", "0.0" );

	level.aiTriggerSpawnFlags = getaitriggerflags();
	level.vehicleTriggerSpawnFlags = getvehicletriggerflags();
	
	//Last stand
	level flag::init( "wait_and_revive" );
	level flag::init( "instant_revive" );

	util::registerClientSys( "lsm" );
	level thread register_clientfields();
	
	setup_traversals();

	level thread onAllPlayersReady();

 	footsteps();
	
 	if ( isdefined( level.skill_override ) )
	{
		gameskill::setSkill( undefined, level.skill_override );
	}
	else
	{
		gameskill::setSkill();
	}
	
	
	system::wait_till( "all" );
	
	load::art_review();

	level flagsys::set( "load_main_complete" );
	
	//scripters can override this value on a per level basis, but globally we're going to fail a cybercom lockon check if player is out of bounds
	level.cybercomTargetLockRequirementCB = &cybercom_out_of_bounds_check;
	
	level thread save_start_checkpoints();
}

// Save checkpoint at the start of every map
function save_start_checkpoints()
{
	CheckpointCreate();
	CheckpointCommit();
	
	flag::wait_till( "all_players_spawned" );
	
	wait 0.5; 	// Don't save right when all the shit goes down, wait for things to setting down.  This will just cause a bigger spike and expose checkpoint bugs
	
	CheckpointCreate();
	CheckpointCommit();
}

function cybercom_out_of_bounds_check( player , target )
{
	return !player oob::isoutofbounds();
}

//
//	player_damage_override
//		MUST return the value of the damage override
//
// MM (08/10/09) - Removed calls to PlayerDamageWrapper because it's always called in 
//		Callback_PlayerDamage now.  We just need to return the damage.
//
function player_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	finalDamage = iDamage;
	
	if ( isDefined( self.player_damage_override ) )
	{
		self thread [[ self.player_damage_override ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}

	//Stop the player from taking any damage while in laststand
	if( self laststand::player_is_in_laststand() )
		return 0;
	
	if ( level.teamBased && isPlayer( eAttacker ) && (self != eAttacker) && (self.team == eAttacker.team) )
	{
		if ( level.friendlyfire == 0 ) // no one takes damage
		{
			return 0;
		}
	}
		
	if( iDamage < self.health )
	{
		return finalDamage;
	}

	//player died

	players = GetPlayers();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] == self || players[i] laststand::player_is_in_laststand() || players[i].sessionstate == "spectator" )
		{
			count++;
		}
	}

	solo_death = ( players.size == 1 && ( self.lives == 0 ));
	non_solo_death = ( (players.size>1) && (count == players.size) );
	if ( solo_death || non_solo_death )
	{	
		level notify("stop_suicide_trigger");
		self thread laststand::PlayerLastStand( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime );
		if( !isdefined( vDir ) )
		{
			vDir = ( 1.0, 0.0, 0.0 );
		}
		level notify("last_player_died");
		self FakeDamageFrom(vDir);
		self thread player_fake_death();
	}

	if( count == players.size )
	{
		if ( players.size == 1 )
		{
			if ( self.lives == 0 )
			{
				self.lives = 0;
				level notify("pre_end_game");
				util::wait_network_frame();				
				level notify( "end_game" );
			}
			else
			{
				return finalDamage;
			}
		}
		else
		{
			level notify("pre_end_game");
			util::wait_network_frame();
			level notify( "end_game" );
		}
		return 0;	// MM (09/16/09) Need to return something
	}

	return finalDamage;
}

function player_fake_death()
{
	level notify ("fake_death");
	self notify ("fake_death");

	self TakeAllWeapons();
	self AllowStand( false );
	self AllowCrouch( false );
	self AllowProne( true );

	self.ignoreme = true;
	self EnableInvulnerability();

	wait( 1 );
	self FreezeControls( true );
}

function setFootstepEffect(name, fx)
{
	assert(isdefined(name), "Need to define the footstep surface type.");
	assert(isdefined(fx), "Need to define the mud footstep effect.");
	if (!isdefined(anim.optionalStepEffects))
		anim.optionalStepEffects = [];
	anim.optionalStepEffects[anim.optionalStepEffects.size] = name;
	level._effect["step_" + name] = fx;
}

function footsteps()
{
	setFootstepEffect( "asphalt",  "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "brick",    "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "carpet",   "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "cloth",    "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "concrete", "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "dirt",     "_t6/bio/player/fx_footstep_sand" ); 
	setFootstepEffect( "foliage",  "_t6/bio/player/fx_footstep_sand" ); 
	setFootstepEffect( "gravel",   "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "grass",    "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "metal",    "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "mud",      "_t6/bio/player/fx_footstep_mud" ); 
	setFootstepEffect( "paper",    "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "plaster",  "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "rock",     "_t6/bio/player/fx_footstep_dust" ); 
	setFootstepEffect( "sand",     "_t6/bio/player/fx_footstep_sand" ); 
	setFootstepEffect( "water",    "_t6/bio/player/fx_footstep_water" ); 
	setFootstepEffect( "wood",     "_t6/bio/player/fx_footstep_dust" ); 
}

// All "Begin" nodes get passed in here through _load.gsc
function init_traverse()
{
	point = GetEnt(self.target, "targetname");
	if (isdefined(point))
	{
		self.traverse_height = point.origin[2];
		point Delete();
	}
 	else
 	{
 		point = struct::get(self.target, "targetname");
 		if (isdefined(point))
 		{
 			self.traverse_height = point.origin[2];
 		}
 	}
}

function setup_traversals()
{
	potential_traverse_nodes = GetAllNodes();
	for (i = 0; i < potential_traverse_nodes.size; i++)
	{
		node = potential_traverse_nodes[i];
		if (node.type == "Begin")
		{
			node init_traverse();
		}
	}
}



// Call the script function 'switchmap_preload' to initiate preloading a level.  It takes the map name as an argument . 
//A 'switchmap_preload_finished' notify will be sent to the level when the fastfile has finished loading and the streamer cache finishes priming . 
//After your script has received that notify, call 'switchmap_switch' to perform the switch.  
//If 'switchmap_switch' is called before priming has finished, the engine will switch maps as soon as preloading finishes.
// Preloading a level can be cancelled by calling 'switchmap_cancel'.
function preload_next_mission()
{
	if( !isdefined(level.nextBSPgamemode) )
	{
		level.nextBSPgamemode = "coop";
	}

	switchmap_preload( level.nextBSPtoload, level.nextBSPgamemode );
	level waittill( "switchmap_preload_finished" );
	level flag::set( "bsp_swap_ready" );
}

function load_next_mission()
{
	level flag::wait_till( "bsp_swap_ready" );
	switchmap_switch();
}

function end_game()
{
	level waittill ( "end_game" );

	if( isdefined( level.nextBSPtoload ) )
	{
		level thread preload_next_mission();
	}

	check_end_game_intermission_delay();

/#	println( "end_game TRIGGERED " );	#/
	
	util::clientnotify( "zesn" );
	
	//AYERS: Turn off ANY last stand audio at the end of the game
	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		util::setClientSysState( "lsm", "0", players[i] );
	}

	for ( i = 0; i < players.size; i++ )
	{	
		//clean up the revive text hud if it's active
		if( isdefined( players[i].reviveTextHud ) )
		{
			players[i].reviveTextHud destroy();
		}
	}

	StopAllRumbles();

	level.intermission = true;
	wait 0.1;

	game_over = [];
	survived = [];

	players = GetPlayers();

	//disabled the ingame pause menu from opening after a game ends
	setMatchFlag( "disableIngameMenu", 1 );
	foreach( player in players )
	{
		player closeInGameMenu();
	}

	if ( !isdefined( level.gameEndUICallback ) )
	{
		for( i = 0; i < players.size; i++ )
		{
			game_over[i] = NewClientHudElem( players[i] );
			game_over[i].alignX = "center";
			game_over[i].alignY = "middle";
			game_over[i].horzAlign = "center";
			game_over[i].vertAlign = "middle";
			game_over[i].y -= 130;
			game_over[i].foreground = true;
			game_over[i].fontScale = 3;
			game_over[i].alpha = 0;
			game_over[i].color = ( 1.0, 1.0, 1.0 );
			game_over[i].hidewheninmenu = true;
			game_over[i] SetText( &"COOP_GAME_OVER" );
		
			game_over[i] FadeOverTime( 1 );
			game_over[i].alpha = 1;
			if ( players[i] isSplitScreen() )
			{
				game_over[i].fontScale = 2;
				game_over[i].y += 40;
			}
		}
	} else {
		level thread [[level.gameEndUICallback]]( "" );
	}

	for (i = 0; i < players.size; i++)
	{
		players[i] SetClientUIVisibilityFlag( "weapon_hud_visible", 0 );
		players[i] SetClientMiniScoreboardHide( true );
	}

	UploadStats();
	/*
	_zm_stats::update_players_stats_at_match_end( players );
	_zm_stats::update_global_counters_on_match_end();
	*/

	wait( 1 );
	// upload_leaderboards();
	
	//_zm_utility::play_sound_at_pos( "end_of_game", ( 0, 0, 0 ) );
	wait( 3.95 );

	foreach( icon in survived )
	{
		icon Destroy();
	}
	
	foreach( icon in game_over )
	{
		icon Destroy();
	}

	level notify( "round_end_done" );

	if( IsDefined(level.intermission_override_func) )
	{
		[[ level.intermission_override_func ]]();
		level.intermission_override_func = undefined;
	}
	else
	{
		intermission();
		wait( 15.0 );
		level notify( "stop_intermission" );
	}

	array::thread_all( GetPlayers(), &player_exit_level );

	wait( 1.5 );

	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		players[i] CameraActivate( false );
	}

	if ( isDefined( level.nextBspToLoad ) )
	{
		/# println( "nextBSPtoload ="+ level.nextBspToLoad );  #/
		level thread load_next_mission();
	}
	else
	{
		ExitLevel( false );	//back to lobby
	}

	// Let's not exit the function
	wait( 666 );
}

//
// INTERMISSION =========================================================== //
//

function intermission()
{
	level.intermission = true;
	level notify( "intermission" );

	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		util::setclientsysstate( "levelNotify", "zi", players[i] ); // Tell clientscripts we're in zombie intermission

		players[i] SetClientThirdPerson( 0 );
		players[i] resetFov();

		players[i].health = 100; // This is needed so the player view doesn't get stuck
		players[i] thread player_intermission();
		
		players[i] StopSounds();
	}

	wait( 0.25 );

	// Delay the last stand monitor so we are 100% sure the zombie intermission ("zi") is set on the cients
	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		util::setClientSysState( "lsm", "0", players[i] );
	}

	//level thread zombie_game_over_death();
}


function player_intermission()
{
	self closeInGameMenu();

	level endon( "stop_intermission" );
	self endon("disconnect");
	self endon("death");
	self notify( "_zombie_game_over" ); // ww: notify so hud elements know when to leave

	//Show total gained point for end scoreboard and lobby
	//self.score = 123;//self.score_total;	

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0; 
	self.psoffsettime = 0; 
	self.friendlydamage = undefined;

	points =struct::get_array( "intermission", "targetname" );

	if( !IsDefined( points ) || points.size == 0 )
	{
		points = getentarray( "info_intermission", "classname" ); 
		if( points.size < 1 )
		{
		/#	println( "NO info_intermission POINTS IN MAP" ); 	#/
			return;
		}	
	}

	self.game_over_bg = NewClientHudelem( self );
	self.game_over_bg.horzAlign = "fullscreen";
	self.game_over_bg.vertAlign = "fullscreen";
	self.game_over_bg SetShader( "black", 640, 480 );
	self.game_over_bg.alpha = 1;

	org = undefined;
	while( 1 )
	{
		points = array::randomize( points );
		for( i = 0; i < points.size; i++ )
		{
			point = points[i];
			// Only spawn once if we are using 'moving' org
			// If only using info_intermissions, this will respawn after 5 seconds.
			if( !IsDefined( org ) )
			{
				self Spawn( point.origin, point.angles );
			}

			// Only used with STRUCTS
			if( IsDefined( points[i].target ) )
			{
				if( !IsDefined( org ) )
				{
					org = Spawn( "script_model", self.origin + ( 0, 0, -60 ) );
					org SetModel("tag_origin");
				}

//				self LinkTo( org, "", ( 0, 0, -60 ), ( 0, 0, 0 ) );
//				self SetPlayerAngles( points[i].angles );
				org.origin = points[i].origin;
				org.angles = points[i].angles;
				

				for ( j = 0; j < GetPlayers().size; j++ )
				{
					player = GetPlayers()[j];
					player CameraSetPosition( org );
					player CameraSetLookAt();
					player CameraActivate( true );	
				}

				speed = 20;
				if( IsDefined( points[i].speed ) )
				{
					speed = points[i].speed;
				}

				target_point = struct::get( points[i].target, "targetname" );
				dist = Distance( points[i].origin, target_point.origin );
				time = dist / speed;

				q_time = time * 0.25;
				if( q_time > 1 )
				{
					q_time = 1;
				}

				self.game_over_bg FadeOverTime( q_time );
				self.game_over_bg.alpha = 0;

				org MoveTo( target_point.origin, time, q_time, q_time );
				org RotateTo( target_point.angles, time, q_time, q_time );
				wait( time - q_time );

				self.game_over_bg FadeOverTime( q_time );
				self.game_over_bg.alpha = 1;

				wait( q_time );
			}
			else
			{
				self.game_over_bg FadeOverTime( 1 );
				self.game_over_bg.alpha = 0;

				wait( 5 );
				
				self.game_over_bg thread fade_up_over_time(1);

				//wait( 1 );
			}
		}
	}
}

function fade_up_over_time(t)
{
		self FadeOverTime( t );
		self.alpha = 1;
}

//*****************************************************************************
//*****************************************************************************

function player_exit_level()
{
	self AllowStand( true );
	self AllowCrouch( false );
	self AllowProne( false );

	if( IsDefined( self.game_over_bg ) )
	{
		self.game_over_bg.foreground = true;
		self.game_over_bg.sort = 100;
		self.game_over_bg FadeOverTime( 1 );
		self.game_over_bg.alpha = 1;
	}
}

//*****************************************************************************
//*****************************************************************************

function disable_end_game_intermission( delay )
{
	level.disable_intermission = true;
	wait( delay );
	level.disable_intermission = undefined;
}


//*****************************************************************************
//*****************************************************************************

function check_end_game_intermission_delay()
{
	if( IsDefined(level.disable_intermission) )
	{
		while( 1 )
		{
			if( !IsDefined(level.disable_intermission) )
			{
				break;
			}
			wait( 0.01 );
		}
	}
}

//*****************************************************************************
//*****************************************************************************

function onAllPlayersReady()
{
	level flag::init( "start_coop_logic" );
	level thread end_game();

	timeOut = GetTime() + 5000;	// 5 second time out.
	
	while(GetNumExpectedPlayers() == 0  && (GetTime() < timeOut))
	{
		wait(0.1);
	}
	
	/#	println( "SP >> player_count_expected=" + GetNumExpectedPlayers());		#/
	player_count_actual = 0;
	while( (GetNumConnectedPlayers() < GetNumExpectedPlayers()) || (player_count_actual != GetNumExpectedPlayers()) )
	{
		players = GetPlayers();
		player_count_actual = 0;
		for( i = 0; i < players.size; i++ )
		{
			//players[i] FreezeControls( true );
			if( players[i].sessionstate == "playing" || players[i].sessionstate == "spectator" )
			{
				player_count_actual++;
			} 
		}
	
		/#	println( "SP >> Num Connected =" + GetNumConnectedPlayers() + " Expected : " + GetNumExpectedPlayers());	#/
		wait( 0.1 );	
	}

	SetInitialPlayersConnected();
	
	level flag::set( "all_players_connected" );
	SetDvar( "all_players_are_connected", "1" );
	
	level util::streamer_wait();
	
	/#
		PrintTopRightln( "INITIAL STREAMER READY", ( 1, 1, 1 ) );
	#/

	DisableGrenadeSuicide();
	
	level flag::set( "initial_streamer_ready" );
	level flag::set( "start_coop_logic" );
}

function register_clientfields()
{
//	clientfield::register( "missile", "cf_m_proximity", VERSION_SHIP, 1, "int" );
//	clientfield::register( "missile", "cf_m_emp", VERSION_SHIP, 1, "int" );
//	clientfield::register( "missile", "cf_m_stun", VERSION_SHIP, 1, "int" );
//	
//	clientfield::register( "scriptmover", "cf_s_emp", VERSION_SHIP, 1, "int" );
//	clientfield::register( "scriptmover", "cf_s_stun", VERSION_SHIP, 1, "int" );
	
	clientfield::register( "toplayer", "sndHealth", 1, 2, "int" );
	
}
