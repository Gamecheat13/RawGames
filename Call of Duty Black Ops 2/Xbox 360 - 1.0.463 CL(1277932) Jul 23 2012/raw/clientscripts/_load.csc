// clientscripts/_load.csc

#include clientscripts\_utility;
#include clientscripts\_lights;
#include clientscripts\_music;
#include clientscripts\_busing;
#include clientscripts\_clientfaceanim;
#include clientscripts\_filter;


levelNotifyHandler(clientNum, state, oldState)
{
	if(state != "")
	{
		level notify(state, clientNum);
	}
}

end_last_stand(clientNum)
{
	self waittill("lastStandEnd");
	
	/#println("Last stand ending for client " + clientNum);#/
	
	if(level.localPlayers.size == 1)	// No busing modifications in split screen.
	{
		setBusState("return_default");
	}
	
	waitrealtime(0.7);
	
	/#println("Gasp.");#/
	playsound(clientNum, "revive_gasp");
}

last_stand_thread(clientNum)
{
	self thread end_last_stand(clientNum);
	
	self endon("lastStandEnd");
	
	/#println("*** Client : Last stand starts on client " + clientNum);#/
	
	if(level.localPlayers.size == 1)
	{
		setBusState("last_stand_start");
		waitrealtime(0.1);
		setBusState("last_stand_duration");
	}
	
	const startVol = 0.5;
	const maxVol = 1.0;
	
	const startPause = 0.5;
	const maxPause = 2.0;
	
	pause = startPause;
	vol = startVol;
	
	while(1)
	{
		id = playsound(clientNum, "chr_heart_beat");
		setSoundVolume(id, vol);
		//iprintlnbold( "LASTSTAND ON CLIENT " + clientNum );
		
		waitrealtime(pause);
		
		if(pause < maxPause)
		{
			pause *= 1.05;
			
			if(pause > maxPause)
			{
				pause = maxPause;
			}
		}
		
		if(vol < maxVol)
		{
			vol *= 1.05;
			
			if(vol > maxVol)
			{
				vol = maxVol;
			}
		}
	}
}

last_stand_monitor(clientNum, state, oldState)
{
	player = level.localPlayers[clientNum];
	players = level.localPlayers;
	
	if(state == "1")
	{
		if(!level._laststand[clientNum])
		{
			if(!isdefined(level.lslooper))
			{
				level.lslooper = spawn(0, player.origin, "script.origin");
			}	
			player thread last_stand_thread(clientNum);
			
			//Check to make sure this sound doesn't play during a splitscreen game
			if( players.size <= 1 )
			{
			    level.lslooper playloopsound("evt_laststand_loop", 0.3);
			}
			
			level._laststand[clientNum] = true;
		}
	}
	else
	{
		if(level._laststand[clientNum])
		{
			if(isdefined(level.lslooper))
			{
				level.lslooper stoploopsound(0.7);
			}	
			player notify("lastStandEnd");
			level._laststand[clientNum] = false;
		}
	}
}

damage_visionset_think(local_client_num)
{

	player = level.localPlayers[local_client_num];
	player endon("disconnect");
	level endon("save_restore");	// Don't know if I need this.  DSL
	
	wait(1.0);	// Let player's health get set up.
	
	const max_health = 100;	// GetLocalClientMaxHealth(local_client_num);
	
	health_threshold = max_health * 0.75;
	
	health_threshold_off = max_health;
	
	visionset = false;

	/#PrintLn("*** HTH " + health_threshold);#/
			
	while(1)
	{
		health = GetLocalClientHealth(local_client_num);
		
		if(visionset == false)
		{
			if(health < health_threshold)
			{
				VisionSetDamage(local_client_num, 1, "low_health", 2);
				visionset = true;
			}
		}
		else
		{
			if(health >= max_health)
			{
				/#PrintLn("*** VS OFF");#/
				VisionSetDamage(local_client_num, 0, "low_health", 2);
				visionset = false;
			}
		}
		waitrealtime(0.01);
	}
}

default_flag_change_handler(localClientNum, flag, set, newEnt)
{
/*
	action = "SET";
	if(!set)
	{
		action = "CLEAR";
	}

	println("*** DEFAULT client_flag_callback to " + action + "  flag " + flag + " - for ent " + self getentitynumber() + "["+self.type+"]");
*/		
}

init_client_flags()
{
	level.CF_PLAYER_UNDERWATER = 15;
}

register_default_vehicle_callbacks()
{
//	level._client_flag_callbacks["vehicle"] = clientscripts\_vehicle::vehicle_flag_change_handler;
	level._client_flag_callbacks["vehicle"] = [];
	register_clientflag_callback("vehicle", 0, clientscripts\_vehicle::vehicle_flag_toggle_lockon_handler);	
	//register_clientflag_callback("vehicle", 1, clientscripts\_vehicle::vehicle_flag_1_handler);
	register_clientflag_callback("vehicle", 2, clientscripts\_vehicle::vehicle_flag_toggle_sounds);
	register_clientflag_callback("vehicle", 3, clientscripts\_vehicle::vehicle_flag_3_handler);
	register_clientflag_callback("vehicle", 4, clientscripts\_vehicle::vehicle_flag_4_handler);
	register_clientflag_callback("vehicle", 6, clientscripts\_vehicle::vehicle_flag_turn_off_treadfx);
	//register_clientflag_callback("vehicle", 7, clientscripts\_vehicle::vehicle_flag_change_treadfx_handler);
	register_clientflag_callback("vehicle", 8, clientscripts\_vehicle::vehicle_flag_toggle_exhaustfx_handler);
	//register_clientflag_callback("vehicle", 9, clientscripts\_vehicle::vehicle_flag_change_exhaustfx_handler);
	register_clientflag_callback("vehicle", 10, clientscripts\_vehicle::vehicle_flag_toggle_lights_handler);
	//register_clientflag_callback("vehicle", 11, clientscripts\_vehicle::vehicle_flag_toggle_siren_lights_handler);
	//register_clientflag_callback("vehicle", 12, clientscripts\_vehicle::vehicle_flag_toggle_interior_lights_handler);
}

register_default_actor_callbacks()
{
//	level._client_flag_callbacks["actor"] = ::default_flag_change_handler;
	level._client_flag_callbacks["actor"] = [];
}

register_default_player_callbacks()
{
	level._client_flag_callbacks["player"] = [];
	//register_clientflag_callback("player", level.CF_PLAYER_UNDERWATER, ::player_underwater_flag_handler);  // moved to _swimming.csc
}

register_default_NA_callbacks()
{
	level._client_flag_callbacks["NA"] = [];
}

register_default_general_callbacks()
{
	level._client_flag_callbacks["general"] = [];
}

register_default_missile_callbacks()
{
	level._client_flag_callbacks["missile"] = [];
}

register_default_scriptmover_callbacks()
{
	level._client_flag_callbacks["scriptmover"] = [];
}

register_default_mg42_callbacks()
{
	level._client_flag_callbacks["mg42"] = [];
}

register_default_plane_callbacks()
{
	level._client_flag_callbacks["plane"] = [];
	register_clientflag_callback("plane", 6, clientscripts\_vehicle::vehicle_flag_turn_off_treadfx);
}

setup_default_client_flag_callbacks()
{
	init_client_flags();

	level._client_flag_callbacks	= [];
	
	register_default_vehicle_callbacks();
	register_default_actor_callbacks();
	register_default_player_callbacks();
	register_default_NA_callbacks();
	register_default_general_callbacks();
	register_default_missile_callbacks();
	register_default_scriptmover_callbacks();
	register_default_mg42_callbacks();
	register_default_plane_callbacks();
	level._client_flag_callbacks["helicopter"] = [];
}

main()
{
	clientscripts\_utility_code::init_session_mode_flags();
	
	clientscripts\_utility_code::struct_class_init();

	clientscripts\_utility::initLocalPlayers();
	
	clientscripts\_utility::registerSystem("levelNotify", ::levelNotifyHandler);
	clientscripts\_utility::registerSystem("lsm", ::last_stand_monitor);
	
	level.createFX_enabled = ( GetDvar( "createfx" ) != "" );
		
	if( !isDefined( level.scr_anim ) )
		level.scr_anim[ 0 ][ 0 ] = 0;
	
	setup_default_client_flag_callbacks();
	
	OnPlayerConnect_Callback( ::on_player_connect );
	
	clientscripts\_global_fx::main();
	clientscripts\_busing::busInit();
	clientscripts\_ambientpackage::init();
	clientscripts\_music::music_init();
	clientscripts\_vehicle::init_vehicles();
	clientscripts\_footsteps::init();
	clientscripts\_helicopter_sounds::init();
	clientscripts\_qrcode::init();

	/#
	clientscripts\_radiant_live_update::main();
	#/
	
	clientscripts\_face_generichuman::init();
	clientscripts\_clientfaceanim::init_clientfaceanim();
	
	// clientscripts\_russian_diary::init();

	level thread clientscripts\_explosive_bolt::main();
	level thread clientscripts\_explosive_dart::main();
	
	// Setup global listen threads

	// rfo = red flashing overlay from _gameskill.gsc
	add_listen_thread( "rfo1", clientscripts\_utility::loop_sound_on_client, "chr_breathing_hurt", 0.3, 0.7, "rfo2" );
	add_listen_thread( "rfo3", clientscripts\_utility::play_sound_on_client, "chr_breathing_better" );

	level.onlineGame = SessionModeIsOnlineGame(); 
	level._load_done = 1;
	
	waitforclient(0);
	
	init_code_filters( getlocalplayers()[0] );		
}

on_player_connect( n_client )
{
	clientscripts\_fx::fx_init( n_client );
	clientscripts\_ambient::init( n_client );
	level thread clientscripts\_empgrenade::init();		
}

