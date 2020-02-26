// All triggers for the lanes should start at 1, not 0, or things will probably look bad.  And crash

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\mp_weapontest_share;

main()
{
	precacheitem("knife_mp");
	precacheitem("knife_held_mp");
	precacheitem("srm1216_metalstorm_mp");
	
	weapontest_init();


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
	level thread shield_bounce_test();
	
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
	
	level.viewarms = add_to_array(level.viewarms, "viewmodel_usa_sog_standard_arms");
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

	maps\mp\teams\_teamset_urbanspecops::level_init();
	//maps\mp\teams\_teamset_winterspecops::level_init();
	//maps\mp\teams\_teamset_cubans::level_init();
	//maps\mp\teams\_teamset_junglemarines::level_init();
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
				Print3d( triggers[i].origin, triggers[i].script_noteworthy, (1,1,1), 1, .3);
			}
		}

		wait(0.05);
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

shield_bounce_test()
{
	shield = getent("shield", "targetname");
	shield_linker = getent("shield_linker", "targetname");
	shield_trig = getent("shield_trig", "targetname");
	
	shield linkto(shield_linker);
	
	setdvar("shieldtest_pitchmin", "1");
	setdvar("shieldtest_pitchmax", "3");
	setdvar("shieldtest_pitch", "0");
	setdvar("shieldtest_pitchtime", "0.05");
	setdvar("shieldtest_pitchchance", "20");
	
	while(1)
	{
		
		shield_trig waittill ("trigger");
		pitch = getdvarfloat("shieldtest_pitch")*-1;
		time = getdvarfloat("shieldtest_pitchtime");
		chance = getdvarint("shieldtest_pitchchance");
		
		if (randomint(100) < chance )
			continue;
		
		if (pitch == 0)
		{
			pitchmin = getdvarfloat("shieldtest_pitchmin")*-1;
			pitchmax = getdvarfloat("shieldtest_pitchmax")*-1;
			pitch = randomfloat(pitchmin, pitchmax);
		}
		
		shield_linker rotatepitch(pitch, time);
		shield_linker waittill("rotatedone");
		shield_linker rotatepitch(pitch*-1, time);
		shield_linker waittill("rotatedone");
	}
}
		