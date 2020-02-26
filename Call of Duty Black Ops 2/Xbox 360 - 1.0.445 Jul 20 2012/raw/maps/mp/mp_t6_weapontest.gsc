// All triggers for the lanes should start at 1, not 0, or things will probably look bad.  And crash

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\mp_weapontest_share;

main()
{
	weapontest_init();

	precacheitem("teststorm_dualoptic_mp");
	precacheitem("dualoptic_teststorm_mp");
	precacheitem("teststorm_mp");
	
	level._effect["sensor_grenade_fx"] = loadfx("weapon/sensor_grenade/fx_sensor_scan" );
	level._effect["sensor_grenade_runner_fx"] = loadfx("weapon/sensor_grenade/fx_sensor_scan_runner" );


	maps\mp\_load::main();
	
	maps\mp\mp_t6_weapontest_fx::main();
	maps\mp\mp_t6_weapontest_amb::main();

	maps\mp\mp_weapontest_share::init();

	// TFLAME - 4/28/11 - TODO - currently broken
	//level thread watch_heli_trig();

	level thread triggers_print();
	
		//TFLAME - 8/8/11 - Not supported ATM
	//level thread target_board_range();
	level thread knife_mp_test();
	//level thread normalized_test();
	//level thread prox_grenade_test();
	level thread rumble_hit_test();
	level thread tunables();
	level thread sensor_grenade_test();

	thermal_setup();

}


weapontest_init()
{
	helicopter_setup();

	viewarms_setup();		// precache all viewarms

	weapon_setup();			// precache all guns
}

helicopter_setup()
{
	maps\mp\killstreaks\_helicopter::precachehelicopter( "vehicle_cobra_helicopter_mp_dark" );
	//level.coptertailrotordamaged_fx = loadfx ("vehicle/props/fx_huey_small_blade_dmg");
}

/*-------------------------------
   *** Viewarms Cycling ***
Precaches all available viewmodel arms in SP and MP
-------------------------------*/
viewarms_setup()
{
	// SP / MP
	
	level.viewarms = add_to_array(level.viewarms, "c_usa_mp_sealteam6_assault_viewhands");
	/*
	level.viewarms = add_to_array(level.viewarms, "viewmodel_vtn_nva_standard_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_cia_standard_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_ciawin_standard_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_rus_spet_standard_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_rus_spetwin_standard_arms");
	*/
	/*level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_sog_armor_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_vtn_nva_armor_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_cia_armor_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_ciawin_armor_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_rus_spet_armor_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_rus_spetwin_armor_arms");
	
	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_sog_standard_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_vtn_nva_standard_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_cia_standard_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_ciawin_standard_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_rus_spet_standard_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_rus_spetwin_standard_arms");

	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_sog_camo_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_vtn_nva_camo_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_cia_camo_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_ciawin_camo_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_rus_spet_camo_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_rus_spetwin_camo_arms");

	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_sog_flak_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_vtn_nva_flak_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_cia_flak_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_ciawin_flak_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_rus_spet_flak_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_rus_spetwin_flak_arms");

	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_sog_utility_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_vtn_nva_utility_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_cia_utility_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_ciawin_utility_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_rus_spet_utility_arms");
	level.viewarms = add_to_array(level.viewarms, "viewmodel_rus_spetwin_utility_arms");
	*/
	for( i = 0; i < level.viewarms.size; i++ )
	{
		PrecacheModel( level.viewarms[i] );
	}

}



/*-------------------------------
   *** Weapon Pickup ***
Defines the level.gun_structs array.  Used for spawning
the weapons each time they are picked up, and for
printing their name above the gun
-------------------------------*/
weapon_setup()
{
	level.guns = getentarray("weapontest_weapon", "targetname");
	level.gunstructs = [];

	level.equipment = [];
	level.equipment[0] = "acoustic_sensor_mp";
	level.equipment[1] = "camera_spike_mp";
	level.equipment[2] = "claymore_mp";
	level.equipment[3] = "satchel_charge_mp";
	level.equipment[4] = "scrambler_mp";
	level.equipment[5] = "tactical_insertion_mp";
}


triggers_print()
{
	triggers = GetEntArray( "trigger_prints", "targetname" );
	while( true )
	{
		for( i = 0; i < triggers.size; i++ )
		{
			if( IsDefined( triggers[i].script_noteworthy ) )
			{
				/# Print3d( triggers[i].origin, triggers[i].script_noteworthy, (1,1,1), 1, .3); #/
			}
		}

		wait(0.05);
	}
}

thermal_setup()
{
	thermal_vehicles = GetEntArray( "thermal_vehicle", "targetname" );
	/# println( "num thermal_vehicles:" + thermal_vehicles.size ); #/
	for( i = 0; i < thermal_vehicles.size; i++ )
	{
		thermal_vehicles[i] SetDrawInfrared( true );
	}
}

//////////////////////////////////////////////
// TESTING

watch_heli_trig()
{
	// spawn the helicopter
	trigger_wait("trig_drop_help", "targetname");

	iprintlnbold("spawn helicopter");

	org_heli_spawn = GetEnt("org_heli_spawn", "targetname");
	// spawnHelicopter( owner, origin, angles, model, targetname );
	level.heli = SpawnHelicopter( level.activeplayers[0], org_heli_spawn.origin, org_heli_spawn.angles, "cobra_mp", "vehicle_cobra_helicopter_mp_dark" );
	level.heli.maxhealth = 99999;
	Target_Set(level.heli, (0,0,-100));
	team = level.activeplayers[0].team;
	if( team == "allies" )
	{
		team = "axis";
	}
	else
	{
		team = "allies";
	}
	level.heli SetTeam( team );
	//org_dudes = GetEnt("org_dudes", "targetname");
	//org_dudes LinkTo(heli_drop_help);

	// attach the dudes

	//// tell the helicopter where to go
	//struct_drop_help = getstruct("struct_drop_help", "targetname");
	//heli_drop_help SetVehGoalPos(struct_drop_help.origin, 1);

	//// drop off some dudes
	//heli_drop_help waittill("goal");
	//struct_ground = getstruct("struct_ground", "targetname");
	//org_dudes MoveTo(struct_drop_help.origin, 3.0);

	//// have the dudes stay put and guard
	//org_dudes waittill("movedone");
	//for(i = 0; i < dude_array.size; i++)
	//{
	//	dude_array[i] Unlink();
	//	dude_array[i] AllowedStances("crouch");
	//}

	level thread watch_heli_delete_trig();
}

watch_heli_delete_trig()
{
	// delete the helicopter
	trigger_wait("trig_delete_help", "targetname");

	iprintlnbold("delete helicopter");

	if( IsDefined( level.heli ) )
	{
		target_remove( level.heli );
		level.heli delete();
	}

	level thread watch_heli_trig();
}

target_board_range()
{
	look_trig = getent("board_lookat_trig", "targetname");
	nearby_trig = getent("board_nearby_trig", "targetname");
	
	last_look_trig_time = gettime();
	last_nearby_trig_time = gettime();
	
	level.player_at_board_range = false;

	level thread target_board_range_distance_control();
	level thread target_board_range_hud();
	level thread target_board_swap();

	
	while(1)
	{
		if (get_players()[0] istouching(nearby_trig))
		{
			level.player_at_board_range = true;
		}
		wait 0.05;
	}
}

target_board_range_hud()
{
	target_board_range_hud = NewHudElem();
	target_board_range_hud.alignX = "center";
	target_board_range_hud.horzAlign = "center";
	target_board_range_hud.x = 0; 
	target_board_range_hud.y = 80;
	target_board_range_hud.color = (1, 1, 1);
	

	target_board_range_distance_hud = NewHudElem();
	target_board_range_distance_hud.alignX = "center";
	target_board_range_distance_hud.horzAlign = "center";
	target_board_range_distance_hud.x = 0; 
	target_board_range_distance_hud.y = 60;
	target_board_range_distance_hud.color = (1, 1, 1);
	
	while(1)
	{
		if ( level.player_at_board_range )
		{
			target_board_range_hud settext("Press in the Left or Right Stick to Modify Target Distances");
			target_board_range_distance_hud settext("Current Target Distance: " + level.current_board_distance);
		}
		else
		{
			target_board_range_hud settext(" ");
			target_board_range_distance_hud settext(" ");
		}
		wait 0.05;
	}
}

target_board_range_distance_control()
{
	level.current_board_distance = 250;
	
	while(1)
	{
		if (level.player_at_board_range && get_players()[0] buttonpressed("BUTTON_LSTICK") )
		{
			level notify ("switch_target_boards");
			if (level.current_board_distance == 3000)
			{
				level.current_board_distance = 250;
			}
			else
			{
				level.current_board_distance +=250;
			}
			while(get_players()[0] buttonpressed("BUTTON_LSTICK") )
				wait 0.05;
		}
		if (level.player_at_board_range && get_players()[0] buttonpressed("BUTTON_RSTICK") )
		{
			level notify ("switch_target_boards");
			if (level.current_board_distance == 250)
			{
				level.current_board_distance = 3000;
			}
			else
			{
				level.current_board_distance -=250;
			}
			while(get_players()[0] buttonpressed("BUTTON_RSTICK") )
				wait 0.05;
		}
		wait 0.05;
	}
}

target_board_swap()
{
	for (i=250; i < 3001; i+=250)
	{
		boards = getentarray(i+"_board", "targetname");
		for (j=0; j< boards.size; j++)
		{
			boards[j] hide();
		}
	}
	
	while(1)
	{
		current_board_dist = level.current_board_distance;
		
		board = getentarray(current_board_dist+"_board", "targetname");
		for (i=0; i< board.size; i++)
		{
			board[i] show();
		}
		
		
		//guy = getent(current_board_dist+"_board_spawner", "targetname") stalingradspawn();
		level waittill ("switch_target_boards");
		
		for (i=0; i< board.size; i++)
		{
			board[i] hide();
		}
	}
}
		
knife_mp_test()
{
	while(1)
	{
		trigger_wait("baseknife_trig");
		get_players()[0] takeallweapons();
		get_players()[0] giveweapon("knife_held_mp");
		get_players()[0] giveweapon("knife_mp");
		wait 3;
	}
}

normalized_test()
{
	level._mytextdisplay = newClientHudElem( get_players()[0] );
	level._mytextdisplay.x = 0; 
	level._mytextdisplay.y = 25;
	level._mytextdisplay.alignX = "left";
	level._mytextdisplay.alignY = "top";
	level._mytextdisplay.horzAlign = "left";
	level._mytextdisplay.vertAlign = "top";
	level._mytextdisplay.fontScale = 1.25;
	
	while(1)
	{
		nm = get_players()[0] getnormalizedmovement();
		level._mytextdisplay.text = nm;
		wait 0.5;
	}
}
			
/*
target_board_spawner_setup()
{
	self.candamage = false;
	self thread disable_pain();
	
	level waittill ("switch_target_boards");
	self.candamage = true;
	self delete();
}
*/

prox_grenade_test()
{
	wait 2;
	get_players()[0] takeallweapons();
	get_players()[0] giveweapon("proximity_grenade_mp");
	get_players()[0] giveweapon("srm1216_mp");
	setdvar ("player_sustainammo", "1");
	setdvar ("scr_weaponobject_debug", "1");
}
	
	
rumble_hit_test()
{
	
	while(!isdefined(get_players()[0]) || !isdefined(get_players()[1])  )
	{
			wait 0.05;
	}
		
	get_players()[0] thread rumble_on_hit();
	get_players()[1] thread rumble_on_hit();
	
}
	
rumble_on_hit()
{
	while(1)
	{
		self waittill ("damage", amount, attacker);
		attacker playRumbleOnEntity("damage_light");
	}
}
		
tunables()
{
	wait 2;
	while(1)
	{
		level.bettyMinDist = weapons_get_dvar_int( "scr_bettyMinDist", 20 );
		level.bettyGracePeriod = weapons_get_dvar( "scr_bettyGracePeriod", .6 );
		level.bettyRadius = weapons_get_dvar_int( "scr_bettyRadius", 192 );
		level.bettyStunTime = weapons_get_dvar_int( "scr_bettyStunTime", 5 );
		level.bettyDamageRadius = weapons_get_dvar_int( "scr_bettyDamageRadius",256 );
		level.bettyDamageMax = weapons_get_dvar_int( "scr_bettyDamageMax",210 );
		level.bettyDamageMin = weapons_get_dvar_int( "scr_bettyDamageMin", 70 );
		level.bettyJumpHeight = weapons_get_dvar_int( "scr_bettyJumpHeight", 75 );
		level.bettyJumpTime = weapons_get_dvar( "scr_bettyJumpTime", .65 );
		//level.bettyRotateVelocity = weapons_get_dvar( "scr_bettyRotateVelocity", level.bettyRotateVelocity );

		wait(1.0);
	}
}

sensor_grenade_test()
{
	while(!isdefined(get_players()[0]) )
	{
			wait 0.05;
	}
	
	loc = get_players()[0].origin + (0,100,3);
	model = spawn("script_model", loc);
	model setmodel ("t6_wpn_motion_sensor_world");
		
		while(1)
		{
			playfx(level._effect["sensor_grenade_fx"], model.origin);
			wait 1.95;
			playfx(level._effect["sensor_grenade_fx"], model.origin);
			wait 1.95;
			playfx(level._effect["sensor_grenade_runner_fx"], model.origin);
			wait 1.95;
		}

}