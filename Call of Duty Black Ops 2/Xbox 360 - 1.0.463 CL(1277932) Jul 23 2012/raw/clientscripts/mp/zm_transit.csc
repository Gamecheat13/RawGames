#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;

main()
{

	level.default_start_location = "transit";	
	level.default_game_mode = "zclassic";	
	
	//Common zombie stuff
	start_zombie_stuff();

	clientscripts\mp\zm_transit_fx::main();	
	
	//Level specific zombie stuff

	thread clientscripts\mp\zm_transit_amb::main();

	thread clientscripts\mp\zm_transit_gump::init_transit_gump();
	//clientscripts\mp\zm_transit_weather::main();
	
	register_client_flags();
	register_clientflag_callbacks();
	
	// This needs to be called after all systems have been registered.
	waitforclient(0);
	
	level thread clientscripts\mp\zm_transit_bus::main();

	level._power_on = false;

/#	println("*** Client : zm_transit running...");	#/
	
	level thread start_game_mode();

	// If the team nationalites change in this level's gsc file,
	// you must update the team nationality here!
	clientscripts\mp\_teamset_cdc::level_init();

	//Vision Set:
	level thread transit_vision_init();
	level thread set_fog_on_bus();

	//change eyes to blue
	level._override_eye_fx = level._effect["blue_eyes"];

	level thread rotate_wind_turbine();
	level thread power_controlled_lights();
}

register_client_flags()
{
	level._CLIENTFLAG_VEHICLE_BUS_FLASHING_LIGHTS = 0;
	level._CLIENTFLAG_VEHICLE_BUS_HEAD_LIGHTS = 1;
	level._CLIENTFLAG_VEHICLE_BUS_BRAKE_LIGHTS = 2;
	level._CLIENTFLAG_VEHICLE_BUS_TURN_SIGNAL_LEFT_LIGHTS = 3;
	level._CLIENTFLAG_VEHICLE_BUS_TURN_SIGNAL_RIGHT_LIGHTS = 4;
	
	if(getdvar("ui_gametype") == "zrace")
	{
		level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_GRIEF_1 = 11;
		level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_GRIEF_2 = 12;
		level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_1 = 13;
		level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_2 = 14;	
	}
	if(getdvar("ui_gametype") == "zmeat")
	{
		level._CLIENTFLAG_PLAYER_HOLDING_MEAT = 9;	
	}
	
}

register_clientflag_callbacks()
{
	register_clientflag_callback( "vehicle", level._CLIENTFLAG_VEHICLE_BUS_FLASHING_LIGHTS, clientscripts\mp\zm_transit_bus::bus_flashing_lights );
	register_clientflag_callback( "vehicle", level._CLIENTFLAG_VEHICLE_BUS_HEAD_LIGHTS, clientscripts\mp\zm_transit_bus::bus_head_lights );
	register_clientflag_callback( "vehicle", level._CLIENTFLAG_VEHICLE_BUS_BRAKE_LIGHTS, clientscripts\mp\zm_transit_bus::bus_brake_lights );
	register_clientflag_callback( "vehicle", level._CLIENTFLAG_VEHICLE_BUS_TURN_SIGNAL_LEFT_LIGHTS, clientscripts\mp\zm_transit_bus::bus_brake_lights );
	register_clientflag_callback( "vehicle", level._CLIENTFLAG_VEHICLE_BUS_TURN_SIGNAL_RIGHT_LIGHTS, clientscripts\mp\zm_transit_bus::bus_brake_lights );
	
	if(getdvar("ui_gametype") == "zrace")
	{
		register_clientflag_callback( "actor", level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_1, clientscripts\mp\zombies\_zm_game_mode_objects::team_1_zombie_release_soul );
		register_clientflag_callback( "actor", level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_2, clientscripts\mp\zombies\_zm_game_mode_objects::team_2_zombie_release_soul );
		register_clientflag_callback( "actor", level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_GRIEF_1, clientscripts\mp\zombies\_zm_game_mode_objects::team_1_zombie_release_grief_soul );
		register_clientflag_callback( "actor", level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_GRIEF_2, clientscripts\mp\zombies\_zm_game_mode_objects::team_2_zombie_release_grief_soul );
	
	}
	if(getdvar("ui_gametype") == "zmeat")
	{
		register_clientflag_callback( "player", level._CLIENTFLAG_PLAYER_HOLDING_MEAT, ::play_meat_glow);	
	}

}


gamemode_common_setup( gametype, location, vision_set, fog_bank )
{
	level thread clientscripts\mp\zombies\_zm_game_mode_objects::init_game_mode_objects(gametype,location);	
	//level thread clientscripts\mp\zombies\_zm_audio::zmbMusLooper();
	players = GetLocalPlayers();
	for(i=0;i<players.size;i++)
	{
		localclientnum = players[i] GetLocalClientNumber();
		if(!isDefined(localclientnum))
		{
			return;
		}
		visionsetnaked(localclientnum,vision_set,5);
		SetWorldFogActiveBank(localclientnum,fog_bank);
	}	
}



start_game_mode()
{
	
	gametype = getdvar("ui_gametype"); 
	location = getdvar("ui_zm_mapstartlocation");
	if( gametype == "zclassic" )
	{
		return;
	}
	
	/#
	if(getdvar("zm_location") != "")
	{
		location = getdvar("zm_location");
		gametype = getdvar("zm_gametype");
	}
	#/
	
	level endon("end_game");
	
	while(1)
	{
		
		gametype = getdvar("ui_gametype"); 
		location = getdvar("ui_zm_mapstartlocation");
		SetSavedDvar( "r_skyTransition", 1 );	

		switch(gametype)
		{	
			case "zrace":			
				switch(location)
				{
					case "town": level thread clientscripts\mp\zm_transit_race_town::main(); break;
					case "farm": level thread clientscripts\mp\zm_transit_race_farm::main();break;
					case "tunnel": level thread clientscripts\mp\zm_transit_race_tunnel::main();break;
					case "power": level thread clientscripts\mp\zm_transit_race_power::main();break;
				}				
				break;
						
			case "zmeat":
				switch(location)
				{
					case "town": level thread clientscripts\mp\zm_transit_meat_town::main();break;
					case "farm": level thread clientscripts\mp\zm_transit_meat_farm::main();break;
					case "tunnel": level thread clientscripts\mp\zm_transit_meat_tunnel::main();break;
				}
				break;
			case "zcleansed":
			case "zturned":
				switch(location)
				{
					case "town" :level thread clientscripts\mp\zm_transit_turned_town::main();break;
					case "farm" :level thread clientscripts\mp\zm_transit_turned_farm::main();break;
				}
				break;
			case "znml":
				switch(location)
				{
					case "town": level thread clientscripts\mp\zm_transit_nml_town::main();break;
					case "cornfield" :level thread clientscripts\mp\zm_transit_nml_cornfield::main();break;
				}
				break;
			case "zstandard":
				switch(location)
				{
					case "town": level thread clientscripts\mp\zm_transit_standard_town::main();break;
					case "farm" :level thread clientscripts\mp\zm_transit_standard_farm::main();break;
					case "transit" :level thread clientscripts\mp\zm_transit_standard_station::main();break;
				}
				break;
		}
		
		level waittill("gme",clientNum);
		wait(.1);	
				
	}
}

start_zombie_stuff()
{
	level._uses_crossbow = true;

	include_weapons();
	include_equipment_for_level();

	// _load!
	clientscripts\mp\zombies\_zm::init();
	//level thread clientscripts\mp\_explosive_bolt::main();


	clientscripts\mp\zombies\_zm_weap_riotshield::init();

	clientscripts\mp\zombies\_zm_weap_jetgun::init();
}

include_weapons()
{
	//Weapons - Pistols	
	include_weapon( "knife_zm", false );
	include_weapon( "frag_grenade_zm", false );
	include_weapon( "claymore_zm", false );
	include_weapon( "sticky_grenade_zm", false );

	//	Weapons - Pistols
	include_weapon( "m1911_zm", false );
	include_weapon( "m1911_upgraded_zm", false );
	include_weapon( "python_zm" );
	include_weapon( "python_upgraded_zm", false );
	include_weapon( "judge_zm" );
	include_weapon( "judge_upgraded_zm", false );
	include_weapon( "kard_zm" );
	include_weapon( "kard_upgraded_zm", false );
  	include_weapon( "fiveseven_zm" );
  	include_weapon( "fiveseven_upgraded_zm", false );
	include_weapon( "beretta93r_zm", false );
	include_weapon( "beretta93r_upgraded_zm", false );

	//	Weapons - Dual Wield
  	include_weapon( "fivesevendw_zm" );
  	include_weapon( "fivesevendw_upgraded_zm", false );

	//	Weapons - SMGs
	include_weapon( "ak74u_zm", false );
	include_weapon( "ak74u_upgraded_zm", false );
	include_weapon( "mp5k_zm", false );
	include_weapon( "mp5k_upgraded_zm", false );
	include_weapon( "qcw05_zm" );
	include_weapon( "qcw05_upgraded_zm", false );

	//	Weapons - Shotguns
	include_weapon( "870mcs_zm", false );
	include_weapon( "870mcs_upgraded_zm", false );
	include_weapon( "rottweil72_zm", false );
	include_weapon( "rottweil72_upgraded_zm", false );
	include_weapon( "saiga12_zm" );
	include_weapon( "saiga12_upgraded_zm", false );
	include_weapon( "srm1216_zm" );
	include_weapon( "srm1216_upgraded_zm", false );

	//	Weapons - Rifles
	include_weapon( "m14_zm", false );
	include_weapon( "m14_upgraded_zm", false );
	include_weapon( "saritch_zm" );
	include_weapon( "saritch_upgraded_zm", false );
	include_weapon( "m16_zm", false );						
	include_weapon( "m16_gl_upgraded_zm", false );
	include_weapon( "xm8_zm" );
	include_weapon( "xm8_upgraded_zm", false );
	include_weapon( "type95_zm" );
	include_weapon( "type95_upgraded_zm", false );
	include_weapon( "tar21_zm" );
	include_weapon( "tar21_upgraded_zm", false );
	include_weapon( "galil_zm" );
	include_weapon( "galil_upgraded_zm", false );
	include_weapon( "fnfal_zm" );
	include_weapon( "fnfal_upgraded_zm", false );

	//	Weapons - Sniper Rifles
	include_weapon( "dsr50_zm" );
	include_weapon( "dsr50_upgraded_zm", false );
	include_weapon( "barretm82_zm" );
	include_weapon( "barretm82_upgraded_zm", false );

	//	Weapons - Machineguns
	include_weapon( "rpd_zm" );
	include_weapon( "rpd_upgraded_zm", false );
	include_weapon( "hamr_zm" );
	include_weapon( "hamr_upgraded_zm", false );

	//	Weapons - Misc
	include_weapon( "usrpg_zm" );
	include_weapon( "usrpg_upgraded_zm", false );
	include_weapon( "m32_zm" );
	include_weapon( "m32_upgraded_zm", false );
	include_weapon( "xm25_zm" );
	include_weapon( "xm25_upgraded_zm", false );
	
	////////////////////
	//Special grenades//
	////////////////////
	include_weapon( "zombie_cymbal_monkey" );
	include_weapon( "emp_grenade_zm", false );

	///////////////////
	//Special weapons//
	///////////////////
	include_weapon( "ray_gun_zm" );
	include_weapon( "ray_gun_upgraded_zm", false );
	//include_weapon( "crossbow_explosive_zm" );
	//include_weapon( "crossbow_explosive_upgraded_zm", false );
	include_weapon( "jetgun_zm", false );
	include_weapon( "riotshield_zm", false );

	include_weapon( "knife_ballistic_zm" );
	include_weapon( "knife_ballistic_upgraded_zm", false );
	include_weapon( "knife_ballistic_bowie_zm", false );
	include_weapon( "knife_ballistic_bowie_upgraded_zm", false );
}

include_equipment_for_level()
{
	clientscripts\mp\zombies\_zm_equipment::include_equipment( "riotshield_zm" );
}

rotate_wind_turbine()
{
	turbine = GetEntArray(0, "depot_turbine_rotor","targetname");
	if(IsDefined(turbine))
	{
		array_thread(turbine, ::spin_transit_turbines);
	}
}
spin_transit_turbines()
{
	while(true)
	{
		
		self RotatePitch(360, 15);
		self waittill("rotatedone");
	}
}	

//*****************************************************************************
// Vision set changes
//*****************************************************************************
transit_vision_init()
{
	gametype = getdvar("ui_gametype"); 
	if(gametype != "zstandard" && gametype != "zclassic")
	{
		return;
	}
	/*
	zm_transit_base
	zm_transit_depot_ext
	zm_transit_depot_int
	zm_transit_diner_ext
	zm_transit_diner_int
	zm_transit_farm_ext
	zm_transit_farm_int
	zm_transit_power_ext
	zm_transit_power_int
	zm_transit_town_ext
	zm_transit_town_int
	zm_transit_transitional
	*/
	base_visionset = "zm_transit_base";
	players = GetLocalPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] clientscripts\mp\zombies\_zm::zombie_vision_set_apply( base_visionset, 1, 0, players[i] GetLocalClientNumber() );
		vision_trigs = GetEntArray(players[i] GetLocalClientNumber(), "vision_trig", "targetname");
		if(IsDefined(vision_trigs))
		{
			array_thread(vision_trigs, ::transit_vision_change, players[i]);
		}			
	}	
}

set_fog_on_bus()
{
	self endon("entityshutdown");
	
	while(true)
	{
		level waittill("OBS", who);
		SetWorldFogActiveBank(who,4); // fog_bank 3
/#		PrintLn( "Now using fog bank 3 for local client " + who );	#/

		
		level waittill("LBS", who);
		SetWorldFogActiveBank(who,1);
/#		PrintLn( "Now using fog bank 1 for local client " + who );	#/
	}	
}		

transit_vision_change(ent_player)
{
	ent_player endon("entityshutdown");
	
	while(true)
	{
		self waittill("trigger", who);
	
		if(!isDefined(ent_player) || !ent_player isLocalPlayer())
		{
			continue;
		}
		
		local_clientnum = ent_player GetLocalClientNumber();
		
		visionset = "zm_transit_base";
	
		if(IsDefined(self.script_noteworthy))
		{
			visionset = self.script_noteworthy;
		}
	
		if( IsDefined( ent_player._previous_vision ) && visionset == ent_player._previous_vision )
		{
			continue; // no need to change the visionset since they are the same
		}
	
		if(IsDefined(self.script_float))
		{
			trans_time = self.script_float;
		}
		else	
		{
			trans_time = 2;
		}
	
		if( !IsDefined( ent_player._previous_vision ) )
		{
			ent_player._previous_vision = visionset;
		}
		else
		{
	    ent_player clientscripts\mp\zombies\_zm::zombie_vision_set_remove( ent_player._previous_vision, trans_time, local_clientnum );
		}
	
/#		println("*** Client : Changing vision set " + self.script_noteworthy);	#/
			
		ent_player clientscripts\mp\zombies\_zm::zombie_vision_set_apply( visionset, 1, trans_time, local_clientnum );
		ent_player._previous_vision = visionset;
	}
}

power_controlled_lights()
{
	//Full bright safety lights are exploder #100
	//Dim safety lights are #110.
	
	if(isdefined(level.createFX_enabled))
	{
		return;
	}
	
	wait(0.2);
	
	while(true)
	{
		level.power_on = false;
		clientscripts\mp\_fx::deactivate_exploder(100);
		clientscripts\mp\_fx::activate_exploder(110);
		
		level waittill( "power_on" );
	
		level.power_on = true;		
		clientscripts\mp\_fx::deactivate_exploder(110);
		clientscripts\mp\_fx::activate_exploder(100);
	
		level waittill( "power_off" );
	}
}	

play_meat_glow(localClientNum, set, newEnt)
{
	if(localClientNum != 0)
	{
		return;
	}
	if(set)
	{
		if(!isDefined(self._meat_fx))
		{
			self._meat_fx = PlayFXOnTag( localclientnum, level._effect["meat_glow3p"],self, "tag_weapon_right" );
		}
	}
	else
	{
		if(isDefined(self._meat_fx))
		{
			deletefx(localclientnum,self._meat_fx);
			self._meat_fx = undefined;
		}
	}	
}
