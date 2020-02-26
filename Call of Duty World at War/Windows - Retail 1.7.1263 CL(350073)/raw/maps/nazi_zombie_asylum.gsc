#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;
#include maps\_music; 
#include maps\_anim; 


#using_animtree("generic_human");

main()
{
	// enable for dog rounds
	level.dogs_enabled = true;
	
	maps\_destructible_opel_blitz::init();
	precacheshellshock("electrocution");
	
	//add_zombie_hint( "default_buy_door_2500", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_2500" );
	maps\_zombiemode_weapons::add_zombie_weapon( "mine_bouncing_betty",&"ZOMBIE_WEAPON_SATCHEL_2000", 2000 );
	
	precachemodel("tag_origin");
	precachemodel("zombie_zapper_power_box");
	precachemodel("zombie_zapper_power_box_on");
	precachemodel("zombie_zapper_cagelight_red");
	precachemodel("zombie_zapper_cagelight_green");
	precachemodel("lights_tinhatlamp_off");
	precachemodel("lights_tinhatlamp_on");
	precachemodel("lights_indlight_on");
	precachemodel("lights_indlight");
	
	level.valve_hint_north = (&"ZOMBIE_BUTTON_NORTH_FLAMES");
	level.valve_hint_south = (&"ZOMBIE_BUTTON_NORTH_FLAMES");
	
	precachestring(level.valve_hint_north);
	precachestring(level.valve_hint_south);	
	precachestring(&"ZOMBIE_BETTY_ALREADY_PURCHASED");
	precachestring(&"ZOMBIE_BETTY_HOWTO");
	precachestring(&"ZOMBIE_FLAMES_UNAVAILABLE");
	precachestring(&"ZOMBIE_USE_AUTO_TURRET");
	precachestring(&"ZOMBIE_ELECTRIC_SWITCH");
	precachestring(&"ZOMBIE_INTRO_ASYLUM_LEVEL_BERLIN");
	precachestring(&"ZOMBIE_INTRO_ASYLUM_LEVEL_HIMMLER");
	precachestring(&"ZOMBIE_INTRO_ASYLUM_LEVEL_SEPTEMBER");
	
	include_weapons();
	include_powerups();		
	maps\nazi_zombie_asylum_fx::main();	
	
	if(getdvar("light_mode") != "")
	{
		return;
	}
		//init the perk machines
	maps\_zombiemode_perks::init();
	maps\_zombiemode_asylum::main();		
	level.burning_zombies = [];
	level.electrocuted_zombies = [];
	
	init_sounds();
	
	//the electric switch in the control room
	level thread master_electric_switch();
	
	//keeps track of the buyable doors surroundong the control room
	level thread watch_magic_doors();
	
	//special spawn point logic for the map
	level thread spawn_point_override();

	level.custom_spawnPlayer = ::spectator_respawn_new;	
	
	//zombie asylum custom stuff
	init_zombie_asylum();	
	
	//hide the turret
	mgs = getentarray( "fountain_mg", "targetname" );
	//hide the real mg's
	for(i=0;i<mgs.size;i++)
	{
		mgs[i] hide();
	}
	level thread intro_screen();
	//level thread debug_health();
	level thread toilet_useage();
	level thread chair_useage();
	level thread magic_box_light();
	
	
	// If you want to modify/add to the weapons table, please copy over the _zombiemode_weapons init_weapons() and paste it here.
	// I recommend putting it in it's own function...
	// If not a MOD, you may need to provide new localized strings to reflect the proper cost.
	
}

player_zombie_awareness()
{
	self endon("disconnect");
	self endon("death");
	
	while(1)
	{
		wait(1);
		
		zombie = get_closest_ai(self.origin,"axis");
		
		if(!isDefined(zombie))
		{
			continue;
		}
		
		dist = 200;
		
		switch(zombie.zombie_move_speed)
		{
			case "walk": dist = 200;break;
			case "run": dist = 250; break;
			case "sprint": dist = 275;break;
		}
		
		if(distance2d(zombie.origin,self.origin) < dist)
		{				
			yaw = self animscripts\utility::GetYawToSpot(zombie.origin );
			
			//check to see if he's actually behind the player
			if(yaw < -95 || yaw > 95)
			{
				zombie playsound ("behind_vocals");
			}			
		}		
	}	
}

//debug_health()
//{
//	players = get_players(); 
//	hud = newHudElem();
//	hud.foreground = true; 
//	hud.sort = 1; 
//	hud.hidewheninmenu = false; 
//	hud.alignX = "left"; 
//	hud.alignY = "top";
//	hud.horzAlign = "left"; 
//	hud.vertAlign = "top";
//	hud.x = 0; 
//	hud.y = 0; 
//	hud.alpha = 1;
//	//hud SetShader( shader, 24, 24 );
//
//	while(true)
//	{
//
//		wait(0.5);
//
//		hud settext(players[0].maxhealth + ": " + players[0].health);
//		//iprintlnbold(players[0].maxhealth + ": " + players[0].health);
//	}
//}
intro_screen()
{

	flag_wait( "all_players_connected" );
	wait(2);
	level.intro_hud = [];
	for(i = 0;  i < 3; i++)
	{
		level.intro_hud[i] = newHudElem();
		level.intro_hud[i].x = 0;
		level.intro_hud[i].y = 0;
		level.intro_hud[i].alignX = "left";
		level.intro_hud[i].alignY = "bottom";
		level.intro_hud[i].horzAlign = "left";
		level.intro_hud[i].vertAlign = "bottom";
		level.intro_hud[i].foreground = true;
		
		if ( level.splitscreen && !level.hidef )
		{
			level.intro_hud[i].fontScale = 2.75;
		}
		else
		{
			level.intro_hud[i].fontScale = 1.75;
		}
		level.intro_hud[i].alpha = 0.0;
		level.intro_hud[i].color = (1, 1, 1);
		level.intro_hud[i].inuse = false;
	}
	level.intro_hud[0].y = -110;
	level.intro_hud[1].y = -90;
	level.intro_hud[2].y = -70;
	
	
	level.intro_hud[0] settext(&"ZOMBIE_INTRO_ASYLUM_LEVEL_BERLIN");
	level.intro_hud[1] settext(&"ZOMBIE_INTRO_ASYLUM_LEVEL_HIMMLER");
	level.intro_hud[2] settext(&"ZOMBIE_INTRO_ASYLUM_LEVEL_SEPTEMBER");
	
	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] FadeOverTime( 1.5 ); 
		level.intro_hud[i].alpha = 1;
		wait(1.5);

	
	}
	wait(1.5);
	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] FadeOverTime( 1.5 ); 
		level.intro_hud[i].alpha = 0;
		wait(1.5);
	
	
	}	
	//wait(1.5);
	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] destroy();
	
	}
	
	
	level thread magic_box_limit_location_init();

}

/* Moved sound to the loudspeaker */
play_pa_system()
{
	//level notify("");
	clientnotify("switch_flipped_generator");
	speakerA = getstruct("loudspeaker", "targetname");
	playsoundatposition("alarm", speakerA.origin);

	level thread play_comp_sounds();
	
	generator_arc = getent("generator_arc", "targetname");
	generator_arc playloopsound("gen_arc_loop");
	
	wait(4.0);
	generator = getent("generator_origin", "targetname");
	generator playloopsound("generator_loop");

	
	wait(8.0);	
	playsoundatposition ("amb_pa_system", speakerA.origin);

}
play_comp_sounds()
{
	computer = getent("comp", "targetname");
	computer playsound ("comp_start");
	wait(6);
	computer playloopsound("comp_loop");
}

/*------------------------------------
Zombie Asylum special sauce
------------------------------------*/
init_zombie_asylum()
{
	level.magic_box_uses = 1;
	
	//flags
	flag_init("both_doors_opened");			//keeps track of the players opening the 'magic box' room doors
	flag_init("electric_switch_used");	//when the players use the electric switch in the control room
	
	flag_set("spawn_point_override");
	
	//custom spawner function for respawning from spec mode
	//level.custom_spawnPlayer = ::respawn_from_spectator_new;	
	
	//bouncing betties
	level thread purchase_bouncing_betties();
	
	//electric traps
	level thread init_elec_trap_trigs();
	
	//activate the initial exterior goals
	north_ext_goals = getstructarray("north_init_goal","script_noteworthy");
	south_ext_goals = getstructarray("south_init_goal","script_noteworthy");
	
	for(i=0;i<north_ext_goals.size;i++)
	{
		north_ext_goals[i].is_active = 1;
	}
	for(i=0;i<south_ext_goals.size;i++)
	{
		south_ext_goals[i].is_active = 1;
	}
	
	//activate the goals for the courtyard inner stairways ,so they can be disabled
	struct1 = getstruct("north_upstairs_volume_goal","script_noteworthy");
	struct2 = getstruct("south_upstairs_volume_goal","script_noteworthy");	
	struct1.is_active = 1;
	struct2.is_active = 1;	

	//activate goals when doors are opened
	level thread activate_goals_when_door_opened("north_lower_door","script_noteworthy","zombie_door");
	level thread activate_goals_when_door_opened("north_lower_door","script_noteworthy","zombie_debris");
	level thread activate_goals_when_door_opened("south_upstairs_debris","script_noteworthy","zombie_debris");
	level thread activate_goals_when_door_opened("magic_door","script_noteworthy","zombie_door");
		
	//managed zones are areas in the map that have associated spawners/goals that are turned on/off 
	//depending on where the players are in the map
	getent("north_upstairs_volume","targetname") thread manage_zone();
	getent("south_upstairs_volume","targetname") thread manage_zone();	
	getent("south_spawners","targetname") thread manage_zone();
	getent("south_west_upper_corner","targetname") thread manage_zone();	
	getent("north_spawners","targetname") thread manage_zone();

	//bouncing betties!!
	level thread give_betties_after_rounds();
	
	level thread init_lights();	
	
	//water sheeting triggers
	water_trigs = getentarray("waterfall","targetname");
	array_thread(water_trigs,::watersheet_on_trigger);
}

init_lights()
{
	
	tinhats = [];
	arms = [];
	
	ents = getentarray("elect_light_model","targetname");
	for(i=0;i<ents.size;i++)
	{
		if( issubstr(ents[i].model, "tinhat"))
		{
			tinhats[tinhats.size] = ents[i];
		}
		if(issubstr(ents[i].model,"indlight"))
		{
			arms[arms.size] = ents[i];
		}
	}	
	
	for(i = 0;i<tinhats.size;i++)
	{
		wait_network_frame();
		tinhats[i] setmodel("lights_tinhatlamp_off");
	}
	for(i = 0;i<arms.size;i++)
	{
		wait_network_frame();
		arms[i] setmodel("lights_indlight");
	}	
	
	flag_wait("electric_switch_used");

	for(i = 0;i<tinhats.size;i++)
	{
		wait_network_frame();
		tinhats[i] setmodel("lights_tinhatlamp_on");
	}
	for(i = 0;i<arms.size;i++)
	{
		wait_network_frame();
		arms[i] setmodel("lights_indlight_on");
	}	
	
	//shut off magic box light
	open_light = getent("opened_chest_light", "script_noteworthy");
	hallway_light = getent("magic_box_hallway_light", "script_noteworthy");

	open_light setLightIntensity(0.01);
	hallway_light setLightIntensity(0.01);


	open_light_model = getent("opened_chest_model", "script_noteworthy");
	hallway_light_model = getent("magic_box_hallway_model", "script_noteworthy");

	open_light_model setmodel("lights_tinhatlamp_off");
	hallway_light_model setmodel("lights_tinhatlamp_off");


}

/*------------------------------------
grab the attached spawners and make sure they are locked
------------------------------------*/
lock_zombie_spawners(door_name)
{
	door = getentarray(door_name,"targetname");
	if(door.size > 0 && isDefined(door[0].target))
	{
		spawners = getentarray(door[0].target,"targetname");
		for(i=0;i<spawners.size;i++)
		{
			spawners[i].locked_spawner = true;
			level.enemy_spawns = array_remove_nokeys(level.enemy_spawns,spawners[i]);
		}
	}	
}


/*------------------------------------
activate any access points that are associated with a door
types: zombie_door, zombie_debris
------------------------------------*/
activate_goals_when_door_opened(door,key,type)
{	

	//grab the door purchase triggers
	trigs = getentarray(door,key);
	purchase_trigs = [];

	for(i=0;i<trigs.size;i++)
	{
		if ( isDefined(trigs[i].targetname ) && trigs[i].targetname == type )
		{
			purchase_trigs[purchase_trigs.size] = trigs[i];
		}
	}		
	//lock any zombie spawners until they are activated by the door
	lock_zombie_spawners(purchase_trigs[0].target);

	//deactivate the goals until door is opened
	entry_points = getstructarray(door,key);
	for(i=0;i<entry_points.size;i++)
	{
		if ( entry_points[i].script_noteworthy == door)
		{
			entry_points[i].is_active = undefined;
			entry_points[i] trigger_off();
		}
	}

	//double check that we have set the flags	and wait for the door to be used
	if( !IsDefined( level.flag[purchase_trigs[0].script_flag] ) )
	{
		flag_init( purchase_trigs[0].script_flag); 
	}

	flag_wait(purchase_trigs[0].script_flag);
	
	//activate any zombie entrypoints now that the door/debris has been removed
	entry_points = getstructarray(door,key);
	for(i=0;i<entry_points.size;i++)
	{
		if ( entry_points[i].script_noteworthy == door )
		{
			entry_points[i].is_active = 1;
			entry_points[i] trigger_on();
		}
	}
}

/*------------------------------------
have a info_volume target spawners
to turn them on/off - probably the best way to handle this

TODO: switch over the previous script_string stuff in the other function
------------------------------------*/
manage_zone()
{	
	spawners = undefined;
	dog_spawners = [];
	
	if(isDefined(self.target))
	{
		spawners = getentarray(self.target,"targetname");
		
		for (i = 0; i < spawners.size; i++)
		{
			if ( issubstr(spawners[i].classname, "dog") )
			{
				dog_spawners 	= array_add( dog_spawners, spawners[i] );
				spawners 		= array_remove( spawners, spawners[i] );
			}
		}
	}
	
	goals = getstructarray("exterior_goal","targetname");
	check_ent = undefined;
	while(getdvarint("noclip") == 0 ||getdvarint("notarget") != 0	)
	{
		//test to see if any players are in the volume
		zone_active = false;
		players = get_players();
		
		//check magic box volume
		if(self.targetname == "south_upstairs_volume" && flag("magic_box_south"))
		{
			check_ent = getent("magic_room_south_volume","targetname");
		}
		if(self.targetname == "north_upstairs_volume" && flag("magic_box_north"))
		{
			check_ent = getent("magic_room_north_volume","targetname");
		}
		
		for(i=0;i<players.size;i++)
		{
			if(isDefined(check_ent))
			{
				if(players[i] istouching(self) || players[i] istouching(check_ent))
				{
					zone_active = true;
				}
			}
			else
			{
			if(players[i] istouching(self))
			{
				zone_active = true;
			}
		}
		}
	//players are in the volume, activate any associated spawners
		if(zone_active )
		{
			if(isDefined(spawners))
			{
				for(x=0;x<spawners.size;x++)
				{
					//make sure that there are no duplicate spawners 
					no_dupes = array_check_for_dupes( level.enemy_spawns, spawners[x] );
					if(no_dupes)
					{
						if( (!isDefined(spawners[x].locked_spawner)) || ( isDefined(spawners[x].locked_spawner && !spawners[x].locked_spawner)) )
						{
							level.enemy_spawns = add_to_array(level.enemy_spawns,spawners[x]);
						}
					}
				}
				
//				// do check again for dogs
//				for(x=0;x<dog_spawners.size;x++)
//				{
//					//make sure that there are no duplicate spawners 
//					no_dupes = array_check_for_dupes( level.enemy_dog_spawns, dog_spawners[x] );
//					if(no_dupes)
//					{
//						if( (!isDefined(dog_spawners[x].locked_spawner)) || ( isDefined(dog_spawners[x].locked_spawner && !dog_spawners[x].locked_spawner)) )
//						{
//							level.enemy_dog_spawns = add_to_array(level.enemy_dog_spawns, dog_spawners[x]);
//						}
//					}
//				}
				
			}
				
			//activate the associated goals
			for(x=0;x<goals.size;x++)
			{
				if(isDefined(goals[x].is_active) )
				{
					if( isDefined(goals[x].script_string) && (goals[x].script_string == self.targetname + "_goal"))
					{
						goals[x] thread trigger_on();
					}
					if(isDefined(check_ent))
					{
						if( isDefined(goals[x].script_string) && isDefined(check_ent.script_noteworthy) && goals[x].script_string == check_ent.script_noteworthy + "_goal")
						{
							goals[x] thread trigger_on();
						}
					}
				}
			}
		}
							
	//players are not in the volume, so disable the spawners
		else
		{	
			if(isDefined(spawners))
			{
				for(x=0;x<spawners.size;x++)
				{
					if(isDefined(spawners[x].script_string) && spawners[x].script_string == self.targetname)
					{
						level.enemy_spawns = array_remove_nokeys(level.enemy_spawns, spawners[x]);
					}
				}
				
//				// check again for dogs
//				for(x=0;x<dog_spawners.size;x++)
//				{
//					if(isDefined(dog_spawners[x].script_string) && dog_spawners[x].script_string == self.targetname)
//					{
//						level.enemy_dog_spawns = array_remove_nokeys(level.enemy_dog_spawns, dog_spawners[x]);
//					}
//				}
			}
			
			//disable the associated goals
			for(x=0;x<goals.size;x++)
			{
				if(isDefined(goals[x].is_active) )
				{
					if ( isDefined(goals[x].script_string) && (goals[x].script_string == self.targetname + "_goal") )
					{
						goals[x] thread trigger_off();
					}
					if(isDefined(check_ent))
					{
						if( (isDefined(goals[x].script_string)) && (isDefined(check_ent.script_noteworthy)) && (goals[x].script_string == check_ent.script_noteworthy + "_goal"))
						{
							goals[x] thread trigger_off();
						}
					}				
				}
			}	
		}
	
	//wait a second before another check
	wait(1);			
	}
}

init_sounds()
{
	maps\_zombiemode_utility::add_sound( "break_stone", "break_stone" );
	maps\_zombiemode_utility::add_sound( "couch_slam", "couch_slam" );
	
}

// Include the weapons that are only inr your level so that the cost/hints are accurate
// Also adds these weapons to the random treasure chest.
include_weapons()
{
	// Pistols
	//include_weapon( "colt" );
	//include_weapon( "colt_dirty_harry" );
	//include_weapon( "walther" );
	include_weapon( "sw_357" );
	
	// Semi Auto
	include_weapon( "m1carbine" );
	include_weapon( "m1garand" );
	include_weapon( "gewehr43" );

	// Full Auto
	include_weapon( "stg44" );
	include_weapon( "thompson" );
	include_weapon( "mp40" );
	include_weapon("ppsh");

	
	// Bolt Action
	include_weapon( "kar98k" );
	include_weapon( "springfield" );

	// Scoped
	include_weapon( "ptrs41_zombie" );
	//include_weapon( "kar98k_scoped_zombie" );
		
	// Grenade
	include_weapon( "molotov" );
	// JESSE: lets go all german grenades for consistency and to reduce annoyance factor
	//	include_weapon( "fraggrenade" );
	include_weapon( "stielhandgranate" );

	// Grenade Launcher
	include_weapon( "m1garand_gl_zombie" );
	include_weapon( "m7_launcher_zombie" );
	
	// Flamethrower
	include_weapon( "m2_flamethrower_zombie" );
	
	// Shotgun
	include_weapon( "doublebarrel" );
	include_weapon( "doublebarrel_sawed_grip" );
	include_weapon( "shotgun" );
	
	// Bipod
	include_weapon( "fg42_bipod" );
	include_weapon( "mg42_bipod" );
	include_weapon( "30cal_bipod" );

	// Heavy MG
	include_weapon( "bar" );
	include_weapon( "bar_bipod");

	// Rocket Launcher
	include_weapon( "panzerschrek_zombie" );

	// Special
	include_weapon( "ray_gun" );
	
	//bouncing betties
	include_weapon("mine_bouncing_betty");
	
}

include_powerups()
{
	include_powerup( "nuke" );
	include_powerup( "insta_kill" );
	include_powerup( "double_points" );
	include_powerup( "full_ammo" );
}

include_weapon( weapon_name )
{
	maps\_zombiemode_weapons::include_zombie_weapon( weapon_name );
}

include_powerup( powerup_name )
{
	maps\_zombiemode_powerups::include_zombie_powerup( powerup_name );
}


/*------------------------------------
BOUNCING BETTY STUFFS - 
a rough prototype for now, needs a bit more polish

------------------------------------*/
purchase_bouncing_betties()
{
	trigs = getentarray("betty_purchase","targetname");
	array_thread(trigs,::buy_bouncing_betties);
}

buy_bouncing_betties()
{
	self.zombie_cost = 1000;
	
	betty_model = getent(self.target, "targetname");
	betty_model hide();
	self sethintstring( &"ZOMBIE_BETTY_PURCHASE" );

	level thread set_betty_visible();
	while(1)
	{
		self waittill("trigger",who);
		if( who in_revive_trigger() )
		{
			continue;
		}
						
		if( is_player_valid( who ) )
		{
			
			if( who.score >= self.zombie_cost )
			{				
				if(!isDefined(who.has_betties))
				{
					who.has_betties = 1;
					play_sound_at_pos( "purchase", self.origin );
					betty_model show();
					//set the score
					who maps\_zombiemode_score::minus_to_player_score( self.zombie_cost ); 
					who thread bouncing_betty_setup();
					//who thread show_betty_hint("betty_purchased");

					trigs = getentarray("betty_purchase","targetname");
					for(i = 0; i < trigs.size; i++)
					{
						trigs[i] SetInvisibleToPlayer(who);
					}
				}
				
			}
		}
	}
}

set_betty_visible()
{
	players = getplayers();	
	trigs = getentarray("betty_purchase","targetname");

	while(1)
	{
	for(j = 0; j < players.size; j++)
	{
		if( !isdefined(players[j].has_betties))
		{						
			for(i = 0; i < trigs.size; i++)
			{
				trigs[i] SetInvisibleToPlayer(players[j], false);
			}
		}
	}
	
	wait(1);
	}
}

bouncing_betty_watch()
{

	while(1)
	{
		self waittill("grenade_fire",betty,weapname);
		if(weapname == "mine_bouncing_betty")
		{
			betty.owner = self;
			betty thread betty_think();
			self thread betty_death_think();
		}
	}
}

betty_death_think()
{
	self waittill("death");
	
	if(isDefined(self.trigger))
	{
		self.trigger delete();
	}
	
	self delete();
	
}

bouncing_betty_setup()
{	
	self thread bouncing_betty_watch();
	
	self giveweapon("mine_bouncing_betty");
	self setactionslot(4,"weapon","mine_bouncing_betty");
	self setweaponammostock("mine_bouncing_betty",5);
}

betty_loadout()
{
	flag_wait("all_players_connected");
	//players = get_players();
	//array_thread(players,::bouncing_betty_setup);
}

betty_think()
{
	wait(2);
	trigger = spawn("trigger_radius",self.origin,9,80,64);
	trigger waittill( "trigger" );
	trigger = trigger;
	self playsound("betty_activated");
	wait(.1);	
	fake_model = spawn("script_model",self.origin);
	fake_model setmodel(self.model);
	self hide();
	tag_origin = spawn("script_model",self.origin);
	tag_origin setmodel("tag_origin");
	tag_origin linkto(fake_model);
	temp_origin = self.origin;
	playfxontag(level._effect["betty_trail"],tag_origin,"tag_origin");
	fake_model moveto (self.origin + (0,0,32),.2);
	fake_model waittill("movedone");
	playfx(level._effect["betty_explode"],fake_model.origin);
	earthquake(1,.4, temp_origin, 512);
	
	//CHris_P - betties do no damage to the players
	zombs = getaiarray("axis");
	for(i=0;i<zombs.size;i++)
	{
		if(DistanceSquared(zombs[i].origin, temp_origin) < 200 * 200)
		{
			zombs[i] thread maps\_zombiemode_spawner_asylum::zombie_damage( "MOD_EXPLOSIVE", "none", zombs[i].origin, self.owner );
		}
	}
	//radiusdamage(self.origin,128,1000,75,self.owner);
	
	trigger delete();
	fake_model delete();
	tag_origin delete();

	if(isdefined(self))
	{
		self delete();
	}
}

betty_smoke_trail()
{
	self.tag_origin = spawn("script_model",self.origin);
	self.tag_origin setmodel("tag_origin");
	playfxontag(level._effect["betty_trail"],self.tag_origin,"tag_origin");
	self.tag_origin moveto(self.tag_origin.origin + (0,0,100),.15);
}

give_betties_after_rounds()
{
	while(1)
	{
		level waittill( "between_round_over" );
		{
			players = get_players();
			for(i=0;i<players.size;i++)
			{
				if(isDefined(players[i].has_betties))
				{
					players[i] giveweapon("mine_bouncing_betty");
					players[i]  setactionslot(4,"weapon","mine_bouncing_betty");
					players[i]  setweaponammoclip("mine_bouncing_betty",2);
				}
			}
		}
	}
}

/*------------------------------------
	FIRE TRAPS 

- players can activate
	gas valves that enable a wall of fire for a few seconds
	
	NOT!
	it's been changed to electricity
	
	need to update the relevant function names/variables and such to reflect the change
------------------------------------*/
init_elec_trap_trigs()
{
	trap_trigs = getentarray("gas_access","targetname");
	array_thread (trap_trigs,::electric_trap_think);
	array_thread (trap_trigs,::electric_trap_dialog);
}
toilet_useage()
{

	toilet_counter = 0;
	toilet_trig = getent("toilet", "targetname");
	toilet_trig SetCursorHint( "HINT_NOICON" );
	toilet_trig UseTriggerRequireLookAt();

	players = getplayers();
	if (!IsDefined (level.eggs))
	{
		level.eggs = 0;
	}
	while (1)
	{
		wait(0.5);
		for(i=0;i<players.size;i++)
		{			
			toilet_trig waittill( "trigger", players);
			toilet_trig playsound ("toilet_flush", "sound_done");				
			toilet_trig waittill ("sound_done");				
			toilet_counter ++;
			if(toilet_counter == 3)
			{
				playsoundatposition ("cha_ching", toilet_trig.origin);
				level.eggs = 1;
				setmusicstate("eggs");
				wait(245);	
				setmusicstate("WAVE_1");
				level.eggs = 0;
				
			}
				
		}
	}
	
}
chair_useage()
{

	chair_counter = 0;
	chair_trig = getent("dentist_chair", "targetname");
	chair_trig SetCursorHint( "HINT_NOICON" );
	chair_trig UseTriggerRequireLookAt();

	players = getplayers();
	while (1)
	{
		wait(0.05);
		for(i=0;i<players.size;i++)
		{			
			chair_trig waittill( "trigger", players);
			chair_counter ++;
			if(chair_counter == 3)
			{
				playsoundatposition ("chair", chair_trig.origin);
				chair_counter = 0;
			}
				
		}
	}
	
}
electric_trap_dialog()
{

	self endon ("warning_dialog");
	level endon("switch_flipped");
	timer =0;
	while(1)
	{
		wait(0.5);
		players = get_players();
		for(i = 0; i < players.size; i++)
		{		
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
				
				players[i] thread do_player_vo("vox_start", 5);	
				wait(3);				
				self notify ("warning_dialog");
				//iprintlnbold("warning_given");
			}
		}
	}
}


/*------------------------------------
self = use trigger associated with the gas valve
------------------------------------*/
electric_trap_think()
{	
	self sethintstring(&"ZOMBIE_FLAMES_UNAVAILABLE");
	self.is_available = undefined;
	self.zombie_cost = 1000;
	self.in_use = 0;
	
	while(1)
	{
		valve_trigs = getentarray(self.script_noteworthy ,"script_noteworthy");		
	
		//wait until someone uses the valve
		self waittill("trigger",who);
		if( who in_revive_trigger() )
		{
			continue;
		}
		
		if(!isDefined(self.is_available))
		{			
			continue;			
		}
				
		if( is_player_valid( who ) )
		{
			if( who.score >= self.zombie_cost )
			{				
				if(!self.in_use)
				{
					self.in_use = 1;
					play_sound_at_pos( "purchase", who.origin );
					self thread electric_trap_move_switch(self);
					//need to play a 'woosh' sound here, like a gas furnace starting up
					self waittill("switch_activated");
					//set the score
					who maps\_zombiemode_score::minus_to_player_score( self.zombie_cost );

					//turn off the valve triggers associated with this valve until the gas is available again
					array_thread (valve_trigs,::trigger_off);
					
					//this trigger detects zombies walking thru the flames
					self.zombie_dmg_trig = getent(self.target,"targetname");
					self.zombie_dmg_trig trigger_on();
					
					//play the flame FX and do the actual damage
					self thread activate_electric_trap();					
					
					//wait until done and then re-enable the valve for purchase again
					self waittill("elec_done");
					
					clientnotify(self.script_string +"off");
										
					//delete any FX ents
					if(isDefined(self.fx_org))
					{
						self.fx_org delete();
					}
					if(isDefined(self.zapper_fx_org))
					{
						self.zapper_fx_org delete();
					}
					if(isDefined(self.zapper_fx_switch_org))
					{
						self.zapper_fx_switch_org delete();
					}
										
					
					//turn the damage detection trigger off until the flames are used again
			 		self.zombie_dmg_trig trigger_off();
					wait(25);
					array_thread (valve_trigs,::trigger_on);
				
					//Play the 'alarm' sound to alert players that the traps are available again (playing on a temp ent in case the PA is already in use.
					speakerA = getstruct("loudspeaker", "targetname");
					playsoundatposition("warning", speakera.origin);
					self notify("available");

					self.in_use = 0;					
				}
			}
		}
	}
}

//this used to be a gas valve, now it's a throw switch
electric_trap_move_switch(parent)
{
	tswitch = getent(parent.script_linkto,"script_linkname");
	if(tswitch.script_linkname == "4")
	{
		//turn the light above the door red
		north_zapper_light_red();
		//machine = getent("zap_machine_north","targetname");		

		tswitch rotatepitch(-180,.5);
		tswitch playsound("amb_sparks_l_b");
		tswitch waittill("rotatedone");
		self notify("switch_activated");
		self waittill("available");
		tswitch rotatepitch(180,.5);
		
		//turn the light back green once the trap is available again
		north_zapper_light_green();
	}
	else
	{
		south_zapper_light_red();	
		
		tswitch rotatepitch(180,.5);
		tswitch playsound("amb_sparks_l_b");
		tswitch waittill("rotatedone");
		self notify("switch_activated");
		self waittill("available");
		tswitch rotatepitch(-180,.5);
		
		south_zapper_light_green();
		

	}

}

activate_electric_trap()
{
	//the trap on the north side is kinda busted, so it has a sparky wire. 
	if(isDefined(self.script_string) && self.script_string == "north")
	{
		
		machine = getent("zap_machine_north","targetname");
		machine setmodel("zombie_zapper_power_box_on");
		clientnotify("north");
	}
	else
	{
		
		machine = getent("zap_machine_south","targetname");
		machine setmodel("zombie_zapper_power_box_on");
		clientnotify("south");
	}	
		
	clientnotify(self.target);
	
	fire_points = getstructarray(self.target,"targetname");
	
	for(i=0;i<fire_points.size;i++)
	{
		wait_network_frame();
		fire_points[i] thread electric_trap_fx(self);		
	}
	
	//do the damage
	self.zombie_dmg_trig thread elec_barrier_damage();
	
	// reset the zapper model
	level waittill("arc_done");
	machine setmodel("zombie_zapper_power_box");
}


electric_trap_fx(notify_ent)
{
	self.tag_origin = spawn("script_model",self.origin);
	//self.tag_origin setmodel("tag_origin");

	//playfxontag(level._effect["zapper"],self.tag_origin,"tag_origin");

	if(isDefined(self.script_sound))
	{
		self.tag_origin playsound("elec_start");
		self.tag_origin playloopsound("elec_loop");
		self thread play_electrical_sound();
	} 
	wait(25);
		
	if(isDefined(self.script_sound))
	{
		self.tag_origin stoploopsound();
	}
	self.tag_origin delete(); 
	notify_ent notify("elec_done");
	level notify ("arc_done");
	
}
play_electrical_sound()
{
	level endon ("arc_done");
	while(1)
	{	
		wait(randomfloatrange(0.1, 0.5));
		playsoundatposition("elec_arc", self.origin);
	}
	

}
elec_barrier_damage()
{	
	while(1)
	{
		self waittill("trigger",ent);
		
		//player is standing flames, dumbass
		if(isplayer(ent) )
		{
			ent thread player_elec_damage();
		}
		else
		{
		
			if(!isDefined(ent.marked_for_death))
			{
				ent.marked_for_death = true;
				ent thread zombie_elec_death( randomint(100) );
			}
		}
	}
}
play_elec_vocals()
{
	if(IsDefined (self)) 
	{
		org = self.origin;
		wait(0.15);
		playsoundatposition("elec_vocals", org);
		playsoundatposition("zombie_arc", org);
		playsoundatposition("exp_jib_zombie", org);
	}
}
player_elec_damage()
{	
	self endon("death");
	self endon("disconnect");
	
	if(!IsDefined (level.elec_loop))
	{
		level.elec_loop = 0;
	}	
	
	if( !isDefined(self.is_burning) && !self maps\_laststand::player_is_in_laststand() )
	{
		self.is_burning = 1;		
		self setelectrified(1.25);	
		shocktime = 2.5;			
		//Changed Shellshock to Electrocution so we can have different bus volumes.
		self shellshock("electrocution", shocktime);
		
		if(level.elec_loop == 0)
		{	
			elec_loop = 1;
			//self playloopsound ("electrocution");
			self playsound("zombie_arc");
		}
		if(!self hasperk("specialty_armorvest") || self.health - 100 < 1)
		{
			
			radiusdamage(self.origin,10,self.health + 100,self.health + 100);
			self.is_burning = undefined;

		}
		else
		{
			self dodamage(50, self.origin);
			wait(.1);
			//self playsound("zombie_arc");
			self.is_burning = undefined;
		}


	}

}

zombie_elec_death(flame_chance)
{
	self endon("death");
	
	//10% chance the zombie will burn, a max of 6 burning zombs can be goign at once
	//otherwise the zombie just gibs and dies
	if(flame_chance > 90 && level.burning_zombies.size < 6)
	{
		level.burning_zombies[level.burning_zombies.size] = self;
		self thread zombie_flame_watch();
		self playsound("ignite");
		self thread animscripts\death::flame_death_fx();
		wait(randomfloat(1.25));		
	}
	else
	{
		
		refs[0] = "guts";
		refs[1] = "right_arm"; 
		refs[2] = "left_arm"; 
		refs[3] = "right_leg"; 
		refs[4] = "left_leg"; 
		refs[5] = "no_legs";
		refs[6] = "head";
		self.a.gib_ref = refs[randomint(refs.size)];

		playsoundatposition("zombie_arc", self.origin);
		if(randomint(100) > 50 )
		{
			self thread electroctute_death_fx();
			self thread play_elec_vocals();
		}
		wait(randomfloat(1.25));
		self playsound("zombie_arc");
	}

	self dodamage(self.health + 666, self.origin);
}

zombie_flame_watch()
{
	self waittill("death");
	self stoploopsound();
	level.burning_zombies = array_remove_nokeys(level.burning_zombies,self);
}


/*------------------------------------
	SPAWN POINT OVERRIDE
	
- special asylum spawning hotness
------------------------------------*/
spawn_point_override()
{
	flag_wait( "all_players_connected" );
	
	players = get_players(); 

	//spawn points are split, so grab them both seperately
	north_structs = getstructarray("north_spawn","script_noteworthy");
	south_structs = getstructarray("south_spawn","script_noteworthy");

	side1 = north_structs;
	side2 = south_structs;
	if(randomint(100)>50)
	{
		side1 = south_structs;
		side2 = north_structs;
	}
		
	//spawn players on a specific side, but randomize it up a bit
	for( i = 0; i < players.size; i++ )
	{
		
		//track zombies for sounds
		players[i] thread player_zombie_awareness();
		players[i] thread player_killstreak_timer();
		
		//fix exploits found after release
		players[i] thread fix_hax();

			
		if(i<2)
		{
			players[i] setorigin( side1[i].origin ); 
			players[i] setplayerangles( side1[i].angles );
			players[i].respawn_point = side1[i];
			players[i].spawn_side = side1[i].script_noteworthy;
		}
		else
		{
			players[i] setorigin( side2[i].origin);
			players[i] setplayerangles( side2[i].angles);
			players[i].respawn_point = side2[i];
			players[i].spawn_side = side2[i].script_noteworthy;
		}	
	}	
}

//betty hint stuff
init_hint_hudelem(x, y, alignX, alignY, fontscale, alpha)
{
	self.x = x;
	self.y = y;
	self.alignX = alignX;
	self.alignY = alignY;
	self.fontScale = fontScale;
	self.alpha = alpha;
	self.sort = 20;
	//self.font = "objective";
}

setup_client_hintelem()
{
	self endon("death");
	self endon("disconnect");
	
	if(!isDefined(self.hintelem))
	{
		self.hintelem = newclienthudelem(self);
	}
	self.hintelem init_hint_hudelem(320, 220, "center", "bottom", 1.6, 1.0);
}


show_betty_hint(string)
{
	self endon("death");
	self endon("disconnect");
	
	if(string == "betty_purchased")
		text = &"ZOMBIE_BETTY_HOWTO";
	else
		text = &"ZOMBIE_BETTY_ALREADY_PURCHASED";
	
	self setup_client_hintelem();
	self.hintelem setText(text);
	wait(3.5);
	self.hintelem settext("");
}


/*------------------------------------
Temp stuff for the automated turret in the courtyard

------------------------------------*/
Fountain_Mg42_Activate()
{
	trig = getent("trig_courtyard_mg","targetname");
	trig sethintstring(&"ZOMBIE_USE_AUTO_TURRET");
	
	mgs = getentarray( "fountain_mg", "targetname" );
	fake_mgs = getentarray("fake_mg","script_noteworthy");
	
	//hide the real mg's
	for(i=0;i<mgs.size;i++)
	{
		mgs[i] hide();
	}		
	
	//wait for someone to purchase the mg 
	while(1)
	{
		trig waittill("trigger",who);
		if(isDefined(trig.is_activated))
		{
			continue;
		}
		if( who in_revive_trigger() )
		{
			continue;
		}
						
		if( is_player_valid( who ) )
		{
			
			if( who.score >= trig.zombie_cost )
			{				
				play_sound_at_pos( "purchase", trig.origin );
				//set the score
				who maps\_zombiemode_score::minus_to_player_score( trig.zombie_cost ); 
				trig.is_activated = true;
				trig trigger_off();
				trig sethintstring(&"ZOMBIE_FLAMES_UNAVAILABLE");
				
				//the fountain top sinks down	
				fountain_top = getent("fountain_top","targetname");
			
				fountain_top moveto(fountain_top.origin + (0,0,-200),3);
				fountain_top waittill("movedone");
				trig trigger_on();
				
				fountain_mg = getentarray( "fountain_turret", "targetname" );
				
				for(i=0;i<fountain_mg.size;i++)
				{
					fountain_mg[i] moveto(fountain_mg[i].origin + (0,0,200),3);	
				}
				
				fountain_mg[0] waittill("movedone");
				
				//hide the fake MG's once they're in place
				for(i=0;i<fake_mgs.size;i++)
				{
					fake_mgs[i] hide();
				}		
				array_thread(fake_mgs,::trigger_off);
				
				//show the real MG's
				for(i=0;i<mgs.size;i++)
				{
					mgs[i] show();
				}	
				
				for(i=0;i<mgs.size;i++)
				{
					mg = mgs[i];
					mg setTurretTeam( "allies" );
					mg SetMode( "auto_nonai" );
					mg thread maps\_mgturret::burst_fire_unmanned();
				}
				wait(30);
				
				for(i=0;i<mgs.size;i++)
				{
					mg = mgs[i];
					mg notify("stop_burst_fire_unmanned");
					mg SetMode( "manual" );
				}
				
				array_thread(fake_mgs,::trigger_on);
				for(i=0;i<fake_mgs.size;i++)
				{
					fake_mgs[i] show();
				}
				
				for(i=0;i<mgs.size;i++)
				{
					mgs[i] hide();
				}
						
				for(i=0;i<fountain_mg.size;i++)
				{
					fountain_mg[i] moveto(fountain_mg[i].origin + (0,0,-200),3);	
				}
				
				fountain_mg[0] waittill("movedone");
				
				fountain_top moveto(fountain_top.origin + (0,0,200),3);
				fountain_top waittill("movedone");
				wait(15);
				trig.is_activated = undefined;
				trig sethintstring(&"ZOMBIE_USE_AUTO_TURRET");
			}
		}
	}
}


/*------------------------------------
the electric switch in the control room
once this is used, it activates other objects in the map
and makes them available to use
------------------------------------*/
master_electric_switch()
{
	
	trig = getent("use_master_switch","targetname");
	master_switch = getent("master_switch","targetname");	
	master_switch notsolid();
	//master_switch rotatepitch(90,1);
	trig sethintstring(&"ZOMBIE_ELECTRIC_SWITCH");
	
	//turn off the buyable door triggers downstairs
	door_trigs = getentarray("electric_door","script_noteworthy");
	//door_trigs[0] sethintstring(&"ZOMBIE_FLAMES_UNAVAILABLE");
	//door_trigs[0] UseTriggerRequireLookAt();
	array_thread(door_trigs,::set_door_unusable);
	array_thread(door_trigs,::play_door_dialog);
	fx_org = spawn("script_model", (-674.922, -300.473, 284.125));
	fx_org setmodel("tag_origin");
	fx_org.angles = (0, 90, 0);
	playfxontag(level._effect["electric_power_gen_idle"], fx_org, "tag_origin");  
	
	
		
	cheat = false;
	
/# 
	if( GetDvarInt( "zombie_cheat" ) >= 3 )
	{
		wait( 5 );
		cheat = true;
	}
#/

	if ( cheat != true )
	{
		trig waittill("trigger",user);
	}
	
	array_thread(door_trigs,::trigger_off);
	master_switch rotateroll(-90,.3);

	//TO DO (TUEY) - kick off a 'switch' on client script here that operates similiarly to Berlin2 subway.
	master_switch playsound("switch_flip");

	//level thread electric_current_open_middle_door();
	//level thread electric_current_revive_machine();
	//level thread electric_current_reload_machine();
	//level thread electric_current_doubletap_machine();
	//level thread electric_current_juggernog_machine();

	clientnotify("revive_on");
	clientnotify("middle_door_open");
	clientnotify("fast_reload_on");
	clientnotify("doubletap_on");
	clientnotify("jugger_on");
	level notify("switch_flipped");
	maps\_audio::disable_bump_trigger("switch_door_trig");
	level thread play_the_numbers();
	left_org = getent("audio_swtch_left", "targetname");
	right_org = getent("audio_swtch_right", "targetname");
	left_org_b = getent("audio_swtch_b_left", "targetname");
	right_org_b = getent("audio_swtch_b_right", "targetname");

	if( isdefined (left_org)) 
	{
		left_org playsound("amb_sparks_l");
	}
	if( isdefined (left_org_b)) 
	{
		left_org playsound("amb_sparks_l_b");
	}
	if( isdefined (right_org)) 
	{
		right_org playsound("amb_sparks_r");
	}
	if( isdefined (right_org_b)) 
	{
		right_org playsound("amb_sparks_r_b");
	}
	// TUEY - Sets the "ON" state for all electrical systems via client scripts
	SetClientSysState("levelNotify","start_lights");
	level thread play_pa_system();	

	//cut for now :(
	//enable the MG fountain 
	//level thread fountain_mg42_activate();
	
	//set the trigger hint on the fountain
	//getent("trig_courtyard_mg","targetname") sethintstring(&"ZOMBIE_FLAMES_UNAVAILABLE");
	
	flag_set("electric_switch_used");
	trig delete();	
	
	//enable the electric traps
	traps = getentarray("gas_access","targetname");
	for(i=0;i<traps.size;i++)
	{
		traps[i] sethintstring(&"ZOMBIE_BUTTON_NORTH_FLAMES");
		traps[i].is_available = true;
	}
	
	master_switch waittill("rotatedone");
	playfx(level._effect["switch_sparks"] ,getstruct("switch_fx","targetname").origin);
	
	//activate perks-a-cola
	level notify( "master_switch_activated" );
	fx_org delete();
	
	fx_org = spawn("script_model", (-675.021, -300.906, 283.724));
	fx_org setmodel("tag_origin");
	fx_org.angles = (0, 90, 0);
	playfxontag(level._effect["electric_power_gen_on"], fx_org, "tag_origin");  
	fx_org playloopsound("elec_current_loop");


	//elec room fx on
	//playfx(level._effect["elec_room_on"], (-440, -208, 8));
	
	//turn on green lights above the zapper trap doors
	north_zapper_light_green();
	south_zapper_light_green();

	wait(6);
	fx_org stoploopsound();
	level notify ("sleight_on");
	level notify("revive_on");
	level notify ("electric_on_middle_door");
	level notify ("doubletap_on");
	level notify ("juggernog_on");



	//level waittill("electric_on_middle_door");
	doors = getentarray(door_trigs[0].target,"targetname");
	open_bottom_doors(doors);
	
	exploder(101);
	//exploder(201);
	
	//This wait is to time out the SFX properly
	wait(8);
	playsoundatposition ("amb_sparks_l_end", left_org.origin);
	playsoundatposition ("amb_sparks_r_end", right_org.origin);
	
}
play_door_dialog()
{
	self endon ("warning_dialog");
	timer = 0;
	while(1)
	{
		wait(0.05);
		players = get_players();
		for(i = 0; i < players.size; i++)
		{		
			dist = distancesquared(players[i].origin, self.origin );
			if(dist > 70*70)
			{
				timer =0;
				continue;
			}
			while(dist < 70*70 && timer < 3)
			{
				wait(0.5);
				timer++;
			}
			if(dist > 70*70 && timer >= 3)
			{
				self playsound("door_deny");
				players[i] thread do_player_vo("vox_start", 5);	
				wait(3);				
				self notify ("warning_dialog");
				//iprintlnbold("warning_given");
			}
			
				
		}
	}
}
set_door_unusable()
{
	
	self sethintstring(&"ZOMBIE_FLAMES_UNAVAILABLE");
	self UseTriggerRequireLookAt();
	 
}

/*------------------------------------
this keeps track of when booth doorrs to the 'magic box' room are purchased
and then sets a flag ( used for spawning )
------------------------------------*/
watch_magic_doors()
{
	level thread magic_door_flags();
	trigs = getentarray("magic_door","script_noteworthy");
	array_thread (trigs,::magic_door_monitor);	
	
	used = 0;
	while(1)
	{
		level waittill("magic_door_used");
		used++;
		if( used >1 )
		{
			break;
		}
	}
	flag_Set("both_doors_opened");
}


/*------------------------------------
waits for someone to buy a door
leading into the magic box/control room
------------------------------------*/
magic_door_monitor()
{
	self waittill("trigger");
	
	level notify("magic_door_used");	
}


/*------------------------------------
waits for some flags to be set, and 
------------------------------------*/
magic_door_flags()
{
	
	north_vol = getent("magic_room_north_volume","targetname");
	south_vol = getent("magic_room_south_volume","targetname");
	north_vol trigger_off();
	south_vol trigger_off();
	north_vol thread waitfor_flag("north");
	south_vol thread waitfor_flag("south");
			
}

waitfor_flag(which)
{
	
	if(which == "south")
	{
		flag_wait("magic_box_south");
		flag_wait("south_access_1");
		self trigger_on();
	}
	else
	{
		flag_wait("upstairs_north_door1");
		flag_wait("upstairs_north_door2");
		flag_wait("magic_box_north");		
		//iprintlnbold("north_enabled");
		self trigger_on();

	}
	
}

/*------------------------------------
This opens the bottom 'divider' doors 
once the electric swtich is activated
------------------------------------*/
open_bottom_doors(doors)
{

	time = 1;
		
	for(i=0;i<doors.size;i++)
	{
		doors[i] NotSolid(); 
	
		time = 1; 
		if( IsDefined( doors[i].script_transition_time ) )
		{
			time = doors[i].script_transition_time; 
		}
		 
		doors[i] connectpaths();
		
		if(isDefined(doors[i].script_vector))
		{
			doors[i] MoveTo( doors[i].origin + doors[i].script_vector, time, time * 0.25, time * 0.25 ); 
			doors[i] playsound ("door_slide_open");			
		}
		wait(randomfloat(.15));
	}
}

/*------------------------------------
electrical current FX once the traps are activated on the north side
------------------------------------*/
electric_trap_wire_sparks(side)
{
	self endon("elec_done");
			
	while(1)
	{
		sparks = getstruct("trap_wire_sparks_"+ side,"targetname");
		self.fx_org = spawn("script_model",sparks.origin);
		self.fx_org setmodel("tag_origin");
		self.fx_org.angles = sparks.angles;
		playfxontag(level._effect["electric_current"],self.fx_org,"tag_origin");
		
		targ = getstruct(sparks.target,"targetname");
		while(isDefined(targ))
		{
			self.fx_org moveto(targ.origin,.15);
		
		
		// Kevin adding playloop on electrical fx
			self.fx_org playloopsound("elec_current_loop",.1);
			self.fx_org waittill("movedone");
			self.fx_org stoploopsound(.1);
		
			if(isDefined(targ.target))
			{
				targ = getstruct(targ.target,"targetname");
			}
			else
			{
				targ = undefined;
			}
		}
		playfxontag(level._effect["electric_short_oneshot"],self.fx_org,"tag_origin");
		wait(randomintrange(3,9));
		self.fx_org delete();	
	}
}

//electric current to open the middle door
electric_current_open_middle_door()
{

		sparks = getstruct("electric_middle_door","targetname");
		fx_org = spawn("script_model",sparks.origin);
		fx_org setmodel("tag_origin");
		fx_org.angles = sparks.angles;
		playfxontag(level._effect["electric_current"], fx_org,"tag_origin");
		
		targ = getstruct(sparks.target,"targetname");
		while(isDefined(targ))
		{
			fx_org moveto(targ.origin,.075);
			//Kevin adding playloop on electrical fx
			if(isdefined(targ.script_noteworthy) && (targ.script_noteworthy == "junction_boxs" || targ.script_noteworthy == "electric_end"))
			{
				playfxontag(level._effect["electric_short_oneshot"], fx_org,"tag_origin");
			}
			
			fx_org playloopsound("elec_current_loop",.1);
			fx_org waittill("movedone");
			fx_org stoploopsound(.1);
			if(isDefined(targ.target))
			{
				targ = getstruct(targ.target,"targetname");
			}
			else
			{
				targ = undefined;
			}
		}
		level notify ("electric_on_middle_door");
		playfxontag(level._effect["electric_short_oneshot"], fx_org,"tag_origin");
		wait(randomintrange(3,9));
		fx_org delete();	



}

electric_current_revive_machine()
{

		sparks = getstruct("revive_electric_wire","targetname");
		fx_org = spawn("script_model",sparks.origin);
		fx_org setmodel("tag_origin");
		fx_org.angles = sparks.angles;
		playfxontag(level._effect["electric_current"], fx_org,"tag_origin");
		
		targ = getstruct(sparks.target,"targetname");
		wait(0.2);
		while(isDefined(targ))
		{
			fx_org moveto(targ.origin,.075);
			//Kevin adding playloop on electrical fx
			if(isdefined(targ.script_noteworthy) && targ.script_noteworthy == "junction_revive")
			{
				playfxontag(level._effect["electric_short_oneshot"], fx_org,"tag_origin");
			}
			
			fx_org playloopsound("elec_current_loop",.1);
			fx_org waittill("movedone");
			fx_org stoploopsound(.1);
			if(isDefined(targ.target))
			{
				targ = getstruct(targ.target,"targetname");
			}
			else
			{
				targ = undefined;
			}
		}
		level notify("revive_on");
		playfxontag(level._effect["electric_short_oneshot"], fx_org,"tag_origin");
		wait(randomintrange(3,9));
		fx_org delete();	



}

electric_current_reload_machine()
{

		sparks = getstruct("electric_fast_reload","targetname");
		fx_org = spawn("script_model",sparks.origin);
		fx_org setmodel("tag_origin");
		fx_org.angles = sparks.angles;
		playfxontag(level._effect["electric_current"], fx_org,"tag_origin");
		
		targ = getstruct(sparks.target,"targetname");
		while(isDefined(targ))
		{
			fx_org moveto(targ.origin,.075);
			//Kevin adding playloop on electrical fx
			if(isdefined(targ.script_noteworthy) && targ.script_noteworthy == "reload_junction")
			{
				playfxontag(level._effect["electric_short_oneshot"], fx_org,"tag_origin");
			}
			
			fx_org playloopsound("elec_current_loop",.1);
			fx_org waittill("movedone");
			fx_org stoploopsound(.1);
			if(isDefined(targ.target))
			{
				targ = getstruct(targ.target,"targetname");
			}
			else
			{
				targ = undefined;
			}
		}
		level notify ("sleight_on");
		playfxontag(level._effect["electric_short_oneshot"], fx_org,"tag_origin");
		wait(randomintrange(3,9));
		fx_org delete();	



}
electric_current_doubletap_machine()
{

		sparks = getstruct("electric_double_tap","targetname");
		fx_org = spawn("script_model",sparks.origin);
		fx_org setmodel("tag_origin");
		fx_org.angles = sparks.angles;
		playfxontag(level._effect["electric_current"], fx_org,"tag_origin");
		
		targ = getstruct(sparks.target,"targetname");
		while(isDefined(targ))
		{
			fx_org moveto(targ.origin,.075);
			//Kevin adding playloop on electrical fx
			if(isdefined(targ.script_noteworthy) && targ.script_noteworthy == "double_tap_junction")
			{
				playfxontag(level._effect["electric_short_oneshot"], fx_org,"tag_origin");
			}
			
			fx_org playloopsound("elec_current_loop",.1);
			fx_org waittill("movedone");
			fx_org stoploopsound(.1);
			if(isDefined(targ.target))
			{
				targ = getstruct(targ.target,"targetname");
			}
			else
			{
				targ = undefined;
			}
		}
		level notify ("doubletap_on");
		playfxontag(level._effect["electric_short_oneshot"], fx_org,"tag_origin");
		wait(randomintrange(3,9));
		fx_org delete();	



}
electric_current_juggernog_machine()
{

		sparks = getstruct("electric_juggernog","targetname");
		fx_org = spawn("script_model",sparks.origin);
		fx_org setmodel("tag_origin");
		fx_org.angles = sparks.angles;
		playfxontag(level._effect["electric_current"], fx_org,"tag_origin");
		
		targ = getstruct(sparks.target,"targetname");
		while(isDefined(targ))
		{
			fx_org moveto(targ.origin,.075);
			//Kevin adding playloop on electrical fx
			
			fx_org playloopsound("elec_current_loop",.1);
			fx_org waittill("movedone");
			fx_org stoploopsound(.1);
			if(isDefined(targ.target))
			{
				targ = getstruct(targ.target,"targetname");
			}
			else
			{
				targ = undefined;
			}
		}
		level notify ("juggernog_on");
		playfxontag(level._effect["electric_short_oneshot"], fx_org,"tag_origin");
		wait(randomintrange(3,9));
		fx_org delete();	



}

north_zapper_light_red()
{
	zapper_lights = getentarray("zapper_light_north","targetname");
	for(i=0;i<zapper_lights.size;i++)
	{
		zapper_lights[i] setmodel("zombie_zapper_cagelight_red");	
	}
	
	if(isDefined(level.north_light))
	{
		level.north_light delete();
	}
	
	level.north_light = spawn("script_model",(366, 480 ,324));
	level.north_light setmodel("tag_origin");
	level.north_light.angles = (0,270,0);	
	playfxontag(level._effect["zapper_light_notready"],level.north_light,"tag_origin");
}

north_zapper_light_green()
{
	zapper_lights = getentarray("zapper_light_north","targetname");
	for(i=0;i<zapper_lights.size;i++)
	{
		zapper_lights[i] setmodel("zombie_zapper_cagelight_green");	
	}
	
	if(isDefined(level.north_light))
	{
		level.north_light delete();
	}
	
	level.north_light = spawn("script_model",(366, 480 ,324));
	level.north_light setmodel("tag_origin");	
	level.north_light.angles = (0,270,0);
	playfxontag(level._effect["zapper_light_ready"],level.north_light,"tag_origin");

}

south_zapper_light_red()
{
	zapper_lights = getentarray("zapper_light_south","targetname");
	for(i=0;i<zapper_lights.size;i++)
	{
		zapper_lights[i] setmodel("zombie_zapper_cagelight_red");	
	}	
	
	if(isDefined(level.north_light))
	{
		level.north_light delete();
	}
	level.north_light = spawn("script_model",(168, -407.5, 324));
	level.north_light setmodel("tag_origin");
	level.north_light.angles = (0,90,0);	
	playfxontag(level._effect["zapper_light_notready"],level.north_light,"tag_origin");
}

south_zapper_light_green()
{

	zapper_lights = getentarray("zapper_light_south","targetname");
	for(i=0;i<zapper_lights.size;i++)
	{
		zapper_lights[i] setmodel("zombie_zapper_cagelight_green");	
	}
	if(isDefined(level.north_light))
	{
		level.north_light delete();
	}
	
	level.north_light = spawn("script_model",(168, -407.5, 324));
	level.north_light setmodel("tag_origin");	
	level.north_light.angles = (0,270,0);
	playfxontag(level._effect["zapper_light_ready"],level.north_light,"tag_origin");

}



electroctute_death_fx()
{
	self endon( "death" );


	if (isdefined(self.is_electrocuted) && self.is_electrocuted )
	{
		return;
	}
	
	self.is_electrocuted = true;
	
	self thread electrocute_timeout();
		
	// JamesS - this will darken the burning body
	self StartTanning(); 

	if(self.team == "axis")
	{
		level.bcOnFireTime = gettime();
		level.bcOnFireOrg = self.origin;
	}
	
	
	PlayFxOnTag( level._effect["elec_torso"], self, "J_SpineLower" ); 
	self playsound ("elec_jib_zombie");
	wait 1;

	tagArray = []; 
	tagArray[0] = "J_Elbow_LE"; 
	tagArray[1] = "J_Elbow_RI"; 
	tagArray[2] = "J_Knee_RI"; 
	tagArray[3] = "J_Knee_LE"; 
	tagArray = array_randomize( tagArray ); 

	PlayFxOnTag( level._effect["elec_md"], self, tagArray[0] ); 
	self playsound ("elec_jib_zombie");

	wait 1;
	self playsound ("elec_jib_zombie");

	tagArray[0] = "J_Wrist_RI"; 
	tagArray[1] = "J_Wrist_LE"; 
	if( !IsDefined( self.a.gib_ref ) || self.a.gib_ref != "no_legs" )
	{
		tagArray[2] = "J_Ankle_RI"; 
		tagArray[3] = "J_Ankle_LE"; 
	}
	tagArray = array_randomize( tagArray ); 

	PlayFxOnTag( level._effect["elec_sm"], self, tagArray[0] ); 
	PlayFxOnTag( level._effect["elec_sm"], self, tagArray[1] );

}

electrocute_timeout()
{
	self endon ("death");
	self playloopsound("fire_manager_0");
	// about the length of the flame fx
	wait 12;
	self stoploopsound();
	if (isdefined(self) && isalive(self))
	{
		self.is_electrocuted = false;
		self notify ("stop_flame_damage");
	}
	
}
play_the_numbers()
{
	while(1)
	{
		wait(randomintrange(15,20));
		playsoundatposition("the_numbers", (-608, -336, 304));
		wait(randomintrange(15,20));

	}

}
magic_box_limit_location_init()
{

	level.open_chest_location = [];
	level.open_chest_location[0] = undefined;
	level.open_chest_location[1] = undefined;
	level.open_chest_location[2] = undefined;
	level.open_chest_location[3] = "opened_chest";
	level.open_chest_location[4] = "start_chest";


		level thread waitfor_flag_open_chest_location("magic_box_south");
		level thread waitfor_flag_open_chest_location("south_access_1");
		level thread waitfor_flag_open_chest_location("north_door1");
		level thread waitfor_flag_open_chest_location("north_upstairs_blocker");
		level thread waitfor_flag_open_chest_location("south_upstairs_blocker");
	


}

waitfor_flag_open_chest_location(which)
{

	wait(3);

	switch(which)
	{
	case "magic_box_south":
		flag_wait("magic_box_south");
		level.open_chest_location[0] = "magic_box_south";
		break;

	case "south_access_1":
		flag_wait("south_access_1");
		level.open_chest_location[0] = "magic_box_south";
		level.open_chest_location[1] = "magic_box_bathroom";
		break;

	case "north_door1":
		flag_wait("north_door1");
		level.open_chest_location[2] = "magic_box_hallway";
		break;

	case "north_upstairs_blocker":
		flag_wait("north_upstairs_blocker");
		level.open_chest_location[2] = "magic_box_hallway";
		break;
	
	case "south_upstairs_blocker":
		flag_wait("south_upstairs_blocker");
		level.open_chest_location[1] = "magic_box_bathroom";
		break;

	default:
		return;	

	}

}
magic_box_light()
{
	open_light = getent("opened_chest_light", "script_noteworthy");
	hallway_light = getent("magic_box_hallway_light", "script_noteworthy");
	
	open_light_model = getent("opened_chest_model", "script_noteworthy");
	hallway_light_model = getent("magic_box_hallway_model", "script_noteworthy");



	while(true)
	{
		level waittill("magic_box_light_switch");
		open_light setLightIntensity(0);
		hallway_light setLightIntensity(0);

		open_light_model setmodel("lights_tinhatlamp_off");
		hallway_light_model setmodel("lights_tinhatlamp_off");

		if(level.chests[level.chest_index].script_noteworthy == "opened_chest")
		{
				open_light setLightIntensity(1);
				open_light_model setmodel("lights_tinhatlamp_on");
		}
		else if(level.chests[level.chest_index].script_noteworthy == "magic_box_hallway")
		{
			hallway_light setLightIntensity(1);
			hallway_light_model setmodel("lights_tinhatlamp_on");
		}
		
	}

}


//water sheeting FX

// plays a water on the camera effect when you pass under a waterfall
watersheet_on_trigger( )
{

	while( 1 )
	{
		self waittill( "trigger", who );
		
		if( isDefined(who) && isplayer(who) && isAlive(who)  )
		{
			if( !who maps\_laststand::player_is_in_laststand() ) 
			{
				who setwatersheeting(true, 3);
				wait( 0.1 );
			}
		}
	}
}



fix_hax()
{
	self endon("disconnect");
	
	while(1)
	{
		wait(.5);

		//grenade upstairs by bathroom door 
		if(distance2d(self.origin, (245, -608, 266)) < 20)
		{
			self setorigin( (234,-628,self.origin[2]) );
		}
		
		//grenade purchase by right start
		if(distance( self.origin, ( 914, -621, 64))< 25)
		{
			self setorigin ( (914, -611, self.origin[2]) );
		}

		//grenade purchase on column
		if(distance2d( self.origin, ( 446,683,104))<10)
		{
			self setorigin ( (449, 667, self.origin[2]) );
		}

		//by electric door
		if(!flag("electric_switch_used"))
		{
			if(distance2d( self.origin, ( 975,54,75))<10)
			{
				self setorigin ( (985,43, self.origin[2]) );
			}

			if(distance2d( self.origin, ( 964, 46, 104))<15)
			{
				self setorigin ( (959, 20,self.origin[2]) );
			}

						
		}		
		
		//by bouncing betty upstairs
		if(distance2d(self.origin,(-245,537,266)) < 10)
		{
			self setorigin( (-234,537,self.origin[2]) );
		}

	}
}


spectator_respawn_new()
{

	self.has_betties = undefined;
	self.is_burning = undefined;
		
	origin = self.respawn_point.origin;
	angles = self.respawn_point.angles;	
	
	//add 10 units to the z value to prevent the player from spawning into the ground sometimes on stairs
	origin =  origin +  (0,0,10);
	

	self Spawn( origin, angles );

	if( IsSplitScreen() )
	{
		last_alive = undefined;
		players = get_players();

		for( i = 0; i < players.size; i++ )
		{
			if( !players[i].is_zombie )
			{
				last_alive = players[i];
			}
		}

		share_screen( last_alive, false );
	}

	// The check_for_level_end looks for this
	self.is_zombie = false;
	self.ignoreme = false;

	setClientSysState("lsm", "0", self);	// Notify client last stand ended.
	self RevivePlayer();

	self notify( "spawned_player" );

	// Penalize the player when we respawn, since he 'died'
	self maps\_zombiemode_score::player_reduce_points( "died" );

	return true;
}



