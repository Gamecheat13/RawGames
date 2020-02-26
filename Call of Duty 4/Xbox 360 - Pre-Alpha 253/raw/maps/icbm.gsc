#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;

#using_animtree("generic_human");
main()
{

	default_start( ::parachute_player );
	add_start( "landing", ::parachute_player );
	add_start( "base", ::base_start );
	
	precacheItem( "m4_silencer" );
	precacheItem( "m4m203_silencer" );
	precacheItem( "usp_silencer" );
	precacheModel("weapon_saw_MG_setup");
    precacheModel("weapon_rpd_MG_setup");
	maps\_technical::main("vehicle_pickup_technical");
	maps\_mi17::main("vehicle_mi17_woodland_fly");
	maps\_bmp::main("vehicle_bmp");
	//maps\_truck::main("vehicle_bm21_mobile_cover_no_bench");
	maps\_bm21_troops::main("vehicle_bm21_mobile_cover_no_bench");
	maps\_claymores_sp::main();
	maps\icbm_fx::main();
	
	level.towerBlastRadius = 384;
	level.cosine = [];
	level.cosine["180"] = cos(180);
	level.minBMPexplosionDmg = 50;
	level.maxBMPexplosionDmg = 100;
	level.bmpCannonRange = 2048;
	level.bmpMGrange = 850;
	level.bmpMGrangeSquared = level.bmpMGrange * level.bmpMGrange;
	level.playerVehicleDamageRange = 256;
	level.playerVehicleDamageRangeSquared = level.playerVehicleDamageRange * level.playerVehicleDamageRange;
	
	maps\createart\icbm_art::main();
	maps\_load::main();
	maps\icbm_anim::main();
	maps\_breach_explosive_left::main(); 
	maps\_breach::main();
	maps\_c4::main();
	
	level thread maps\icbm_amb::main();	
	maps\_compass::setupMiniMap("compass_map_icbm");
	//setExpFog(0, 771.52, 0.5, 0.5, 0.5, 0);
	//VisionSetNaked( "icbm" );
	//maps\_utility::array_thread(getaiarray(),::PersonalColdBreath);
	//maps\_utility::array_thread(getspawnerarray(),::PersonalColdBreathSpawner);
	
	createthreatbiasgroup( "non_combat" );
	createthreatbiasgroup( "allies" );
	createthreatbiasgroup( "fight" );  
	level.player setthreatbiasgroup( "allies" ); 
	setignoremegroup( "allies", "non_combat" );
	setthreatbias ("allies", "fight",0);  	

	//FLAGS
	flag_init("regroup01_done");
   	flag_init( "sound alarm" );	
	flag_init( "truck arived" );
	flag_init("truckguys dead");
	flag_init("stop_snow");
	flag_init("open_basement");
	flag_init("enter_basement");
	flag_init("house01_clear");
	flag_init("attack_house2");
	flag_init ("breach_house02_done");
	flag_init("ready_for_breach");
	flag_init("courtyard_badguy01_dead");
	flag_init( "hq_entered" );
	flag_init("house02_clear");
	flag_init( "tower_destroyed" );
	flag_init("tower_blown");
	flag_init("unblock_path");
	flag_init( "bmp_dead" );
	flag_init("spawn_second_sqaud");
	flag_init("fire_missile");
	flag_init("launch_02");
	flag_init("level_done");
	
	//THREADS
	thread SunRise();
	level thread setup_price();
	level thread setupbuddies();
	level thread magic_buddies();
	level thread setup_badguys();
	

	battlechatter_off( "allies" );	
	battlechatter_off( "axis" );				

	//setupPlayer();

}

setupPlayer()
{
	level.player.engaged = false;
	level.player takeallweapons();
	level.player giveWeapon("m4m203_silencer");
	level.player giveWeapon("usp_silencer");
	level.player giveWeapon("fraggrenade");	
	level.player giveWeapon("flash_grenade");
	level.player switchToWeapon("m4m203_silencer");
	level.player setOffhandSecondaryClass( "flash" );
	//level.player giveWeapon("claymore");
	//level.player SetActionSlot( 3, "weapon" , "claymore" );
	level.player giveWeapon("c4");
	level.player SetActionSlot( 4, "weapon" , "c4" );


	//give unlimited flashbangs for now
	//level.player thread unlimitedFlashbangs();
	//thread maps\_utility::PlayerUnlimitedAmmoThread();
}

setup_price()
{
	level.price = getent("price","script_noteworthy");
	assertex(isdefined(level.price),"Price not getting defined!");
	//level.price set_goalradius(0);
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	//level.price setBattleChatter(false);
	//level.price.followmax = -3;
	//level.price.followmin = -5;
	//level.price thread stopblocking(); 
}

setup_mark()
{
	level.mark = getent("mark","script_noteworthy");
	assertex(isdefined(level.mark),"Mark not getting defined!");
	//level.mark set_goalradius(0);
	level.mark.animname = "mark";
	level.mark thread magic_bullet_shield();
	//level.mark setBattleChatter(false);
	//level.mark.followmax = -3;
	//level.mark.followmin = -5;
	//level.mark thread stopblocking(); 
}


setupbuddies()
{
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
		{
		allies[i].pacifist = true;
		allies[i].cqbwalking = false;
		allies[i] setthreatbiasgroup( "allies" );
		}
}

setup_badguys()
{

	axis = getaiarray("axis");
	for(i = 0; i < axis.size; i++)
		{
		axis[i] setthreatbiasgroup( "non_combat" );
		axis[i].cqbwalking = true;
		axis[i] thread stopIgnoringPlayerWhenShot();
		}

}

unlimitedFlashbangs()
{
    self endon("death");

    while(true)
    {
        level.player giveMaxAmmo("flash_grenade");
        wait(1);
    }	   
}


parachute_player ()
{
	musicPlay("icbm_intro_music"); 
	level thread maps\_introscreen::introscreen_delay(&"ICBM_INTRO", &"ICBM_DATE", &"ICBM_PLACE", &"CARGOSHIP_INFO", 1, 1, 0);
	//&"Ultimatum", &"Dec 02, 2008", &"Altay Mountains"
	
	level.player allowProne (false);
	level.player allowCrouch (false);
	para_start = getent ("para_start","targetname");
	para_stop = getent ("para_stop","targetname");
	level waittill ("starting final intro screen fadeout");
	
	
	level.player linkto (para_start);
	level.player takeallweapons();	
	para_start moveto (para_stop.origin,4,0,0);	
	//level.player thread maps\_utility::playSoundOnTag("parachute_land_player");

	para_start waittill ("movedone");
	level.player unlink();
	level.player allowProne (true);
	level.player allowCrouch (true);
	
	level thread setupPlayer();


	autosave_by_name( "on_the_ground" );

	level thread regroup_buddies01();
	level thread objectives();
	price_landing = getnode("price_landing","targetname");
	level.price setgoalnode(price_landing);
	wait 2;
	iprintlnbold ("Price - Haggerty, you see where Griggs landed?");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	wait 2;
	iprintlnbold ("Marine1 - Yeah, over by the buildings to the east. You think they got him? ");
	//level.marine1 dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.marine1 anim_single_solo( friendly, "contact_overpass" );  
       	
}

objectives()
{

	obj = getent( "landingzone", "targetname" );
	objective_add( 1, "active", "Regroup with Price", obj.origin );
	objective_current( 1 );	
	
	flag_wait("regroup01_done");
	
	objective_state( 1, "done");
	obj = getent( "obj_grigsby", "targetname" );
	objective_add( 2, "active", "Rescue Sgt.Grigsby", obj.origin );
	objective_current( 2 );	
	
	flag_wait("house02_clear");
		
	objective_state( 2, "done");
	obj = getent( "obj_tower", "targetname" );
	objective_add( 3, "active", "Destroy the power transmission tower", obj.origin );
	objective_current( 3 );	
		
	flag_wait("tower_blown");
		
	objective_state( 3, "done");
	obj = getent( "second_squad", "targetname" );
	objective_add( 4, "active", "Regroup with second squad", obj.origin );
	objective_current( 4 );	
	
	flag_wait("level_done");
	objective_state( 4, "done");

	
}


regroup_buddies01()
{
	
	//level waittill ("get to positions");	  
	regroup_01 = getnode("regroup_01","targetname");


	trigger = getent("regroup01_trigger","targetname");
	assertex(isDefined(trigger), "regroup01_trigger trigger not found");
	trigger waittill("trigger");
    trigger delete();	
	
	iprintlnbold ("Price - We're about to find out. Haggerty, take point");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	wait 1;
	iprintlnbold ("Marine1 - You got it sir");
	//level.marine1 dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.marine1 anim_single_solo( friendly, "contact_overpass" );  
	flag_set("regroup01_done");	
	
	//move the squad out
	activate_trigger_with_targetname( "friendlies_moves_up_the_hill" );
	
	price_preambush = getnode("price_preambush","script_noteworthy");
	wait 2;
	level.price setgoalnode(price_preambush);
	
	     
	autosave_by_name("moveout01");
	level thread ambush();
	level thread truck_spawn();
	
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
		{
		allies[i].pacifist = true;
		allies[i].cqbwalking = true;
	    }   
	        	
}

truck_spawn()
{
	level thread truck_guys();
	level thread patrol_kill_counter();
	trigger = getent("truck_spawn","targetname");
	assertex(isDefined(trigger), "truck_spawn trigger not found");
	trigger waittill("trigger");
	trigger delete();
	wait 0.05;
	
	truck = getent("truck","targetname");
	truck maps\_vehicle::lights_on( "headlights" );
	wait .5;
	
	axis = getaiarray("axis");
	for(i = 0; i < axis.size; i++)
		{
		axis[i].pacifist = true;
		axis[i].cqbwalking = true;
		}
						
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
		{
		allies[i].pacifist = true;	
		}
		
	trigger = getent("truck_stop","targetname");
	assertex(isDefined(trigger), "truck_stop trigger not found");
	trigger waittill("trigger");
 	truck maps\_vehicle::lights_on( "brakelights" );	
	flag_set("truck arived");

}

truck_guys()
{
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("truck_guys","script_noteworthy"), ::spawnerThink, ent);
	ent waittill ("spawned_guy");
	waittillframeend;
	
	axis = getaiarray("axis");
	for(i = 0; i < axis.size; i++)
		{
		axis[i].pacifist = true;
		axis[i].cqbwalking = true;
		axis[i] thread stopIgnoringPlayerWhenShot();
		}
	
	
	waittill_dead(ent.guys);
	flag_set("truckguys dead");	
}


patrol_guys()
{
	patroller1 = self dospawn();	
	if(spawn_failed(patroller1))
		return;
	patroller1.ignoreall = true;
	patroller1.pacifist = true;
	patroller1.cqbwalking = true;
	patroller1 thread stopIgnoringPlayerWhenShot();
	patroller1.goalradius = 16;
	patroller1.script_radius = 16;
	wait 2;
	flag_wait("truckguys dead");
	wait 10;
	patroller1.ignoreall = false;
	patroller1.pacifist = false;	
		
}

patrol_kill_counter()
{
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("patroller1","script_noteworthy"), ::spawnerThink, ent);
	array_thread(getentarray("patroller1","script_noteworthy"), ::patrol_guys);
	ent waittill ("spawned_guy");
	waittillframeend;
	
	waittill_dead(ent.guys);
	
}


ambush()
{
	trigger = getent("enemy_truck01","targetname");
	assertex(isDefined(trigger), "enemy_truck01 trigger not found");
	trigger waittill("trigger");

	axis = getaiarray("axis");
	for(i = 0; i < axis.size; i++)
		{
		axis[i].pacifist = true;
		}		
	wait .5;
	iprintlnbold ("Marine1 - Contact front. Enemy vehicle.");
	//level.marine1 dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.marine1 anim_single_solo( friendly, "contact_overpass" );  
	wait 2;
	iprintlnbold ("Price - I see 'em. Spread out!  ");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );  
	wait 1;
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
		{
		allies[ i ].cqbwalking = false;
		}
		
	activate_trigger_with_targetname( "ambush_move_out" );
	price_ambush = getnode("price_ambush","script_noteworthy");
	level.price setgoalnode(price_ambush);	
	level.price.goalradius = 64 ;
	
	wait 2;
	iprintlnbold ("Jackson with me on the left");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );  	
				
	//level waittill ("in ambush position");
	//wait till the truck pulls up
	//NEED TO MAKE THIS WORK WITH A CHECK IF THE PLAYER SHOOTS EARLY	
	flag_wait("truck arived");
	wait 3;
	iprintlnbold ("Price - Attack!!");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );  
		
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
	{
		allies[i].pacifist = false;	
	}
		
	flag_wait("truckguys dead");
	wait 1;
	iprintlnbold ("Radio chatter (Russian accent)");
	//level.radio dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.radio anim_single_solo( friendly, "contact_overpass" );  
	wait 1;
	iprintlnbold ("Unit 4 come in! Have you found any others?");
	wait 1;
	iprintlnbold ("This one had explosives on him, there must be more of them.");
	wait 2;
	iprintlnbold ("Unit 4?....report!!");
	wait 1;	
	iprintlnbold ("Price - move out");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );  
	wait 1;
	level thread moveto_driveway();
	autosave_by_name("moveout02");
}

moveto_driveway()
{
	activate_trigger_with_targetname( "moveout_driveway" );
	
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
	{
		allies[ i ].cqbwalking = true;
	}

	
	wait 1;
	price_move01 = getnode("price_move01","script_noteworthy");
	level.price setgoalnode(price_move01);	
	level.price.goalradius = 64 ;
	

	trigger = getent("move01","targetname");
	assertex(isDefined(trigger), "move01 trigger not found");
	trigger waittill("trigger");
	trigger delete();
	
	price_move01 = getnode("price_move01","script_noteworthy");
	level.price setgoalnode(price_move01);	
	level.price.goalradius = 64 ;
	
	trigger = getent("move02","targetname");
	assertex(isDefined(trigger), "move01 trigger not found");
	trigger waittill("trigger");
    trigger delete();
    	
	price_move02 = getnode("price_move02","script_noteworthy");
	level.price setgoalnode(price_move02);	
	level.price.goalradius = 64 ;	
	
	trigger = getent("moveto_driveway","targetname");
	assertex(isDefined(trigger), "moveto_driveway trigger not found");
	trigger waittill("trigger");
    trigger delete();
    	
	price_driveway = getnode("price_driveway","script_noteworthy");
	level.price setgoalnode(price_driveway);	
	level.price.goalradius = 64 ;	
		
	trigger = getent("regroup_driveway","targetname");
	assertex(isDefined(trigger), "regroup_driveway trigger not found");
	trigger waittill("trigger");		
    trigger delete();
    								
	wait 1;
	iprintlnbold ("Price - Looks like we've got an entry point through that basement door. We'll work room to room from there");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );  
	wait 5;
	activate_trigger_with_targetname( "moveto_basement" );
	
	wait 2;
	iprintlnbold ("Price - Keep it quiet.");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	  
	//level thread beehive();
	//level thread reinforcements();
	level thread house_assault01();
	level thread price_opens_basement();

}

price_opens_basement()
{

	anim_ent = getnode( "price_basement_stack", "script_noteworthy" );
	anim_ent anim_reach_solo( level.price, "hunted_open_barndoor" );
	anim_ent anim_single_solo( level.price, "hunted_open_barndoor_stop" );
	anim_ent thread anim_loop_solo( level.price, "hunted_open_barndoor_idle", undefined, "stop_idle" );
	
	flag_wait("open_basement");	
	anim_ent notify( "stop_idle" );
	anim_ent thread anim_single_solo( level.price, "hunted_open_barndoor" );

	// todo: get notetrack.
	wait 1.75;

	door = getent( "house01_basement_door","targetname");
	door rotateto( door.angles + (0,70,0), 2, .5, 0 );
	door connectpaths();
	door waittill( "rotatedone");
	door rotateto( door.angles + (0,40,0), 2, 0, 2 );
	flag_set("enter_basement");

 
}



house_assault01()
{
	trigger = getent("laundryroom","targetname");
	assertex(isDefined(trigger), "laundryroom trigger not found");
	trigger waittill("trigger");
	trigger delete();
	
	flag_set("open_basement");
	flag_wait("enter_basement");
	level thread house01_badguy01();
	price_laundryroom = getnode("price_laundryroom","script_noteworthy");
	level.price setgoalnode(price_laundryroom);	
	level.price.goalradius = 64 ;
		
	autosave_by_name("house01");
	
	trigger = getent("firstroom_house01","targetname");
	assertex(isDefined(trigger), "firstroom_house01 trigger not found");
	trigger waittill("trigger");
	trigger delete();
	level thread second_floor_kill_counter();
	
	price_firstroom_house01 = getnode("price_firstroom_house01","script_noteworthy");
	level.price setgoalnode(price_firstroom_house01);	
	level.price.goalradius = 64 ;
	
	trigger = getent("firstroom_clear","targetname");
	assertex(isDefined(trigger), "firstroom_clear trigger not found");
	trigger waittill("trigger");
	trigger delete();
			
	price_firstfloor_clear = getnode("price_firstfloor_clear","script_noteworthy");
	level.price setgoalnode(price_firstfloor_clear);	
	level.price.goalradius = 64 ;
	
	trigger = getent("load_secondfloor_house01","targetname");
	assertex(isDefined(trigger), "load_secondfloor_house01 trigger not found");
	trigger waittill("trigger");
	trigger delete();	
	
	array_thread(getentarray("house01_bg02","script_noteworthy"), ::house01_secondfloor_guys);
	level thread house01_clear();
	level thread price_opens_door01();
		
}

house01_badguy01()
{

	bd01_spawner = getent("house01_badguy01","script_noteworthy");
	house01_badguy01 = bd01_spawner dospawn();	
	if(spawn_failed(house01_badguy01))
		return;
	house01_badguy01.cqbwalking = true;
	house01_badguy01 thread stopIgnoringPlayerWhenShot();

}

house01_secondfloor_guys()
{
	house01_bg02 = self dospawn();	
	if(spawn_failed(house01_bg02))
		return;
	house01_bg02.cqbwalking = true;
	house01_bg02 thread stopIgnoringPlayerWhenShot();
		
}

second_floor_kill_counter()
{
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("house01_bg02","script_noteworthy"), ::spawnerThink, ent);
	ent waittill ("spawned_guy");
	waittillframeend;
	
	waittill_dead(ent.guys);
	flag_set("house01_clear");
	autosave_by_name("house01_clear");	
	
}

house01_clear()
{
	flag_wait("house01_clear");
	level thread house02_assault();
	level thread price_opens_door02(); 
	wait 2;
	iprintlnbold ("Building clear");
	//level.marine1 dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.marine1 anim_single_solo( friendly, "contact_overpass" );  
	wait 2;
	iprintlnbold ("Price- On me, downstairs.");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
		
	//door slow breach
	activate_trigger_with_targetname( "house01_clear_regroup" );
	level thread courtyard_guy();
	

}

price_opens_door01()
{

	anim_ent = getnode( "price_open_door01_node", "script_noteworthy" );
	anim_ent anim_reach_solo( level.price, "hunted_open_barndoor" );
	anim_ent anim_single_solo( level.price, "hunted_open_barndoor_stop" );
	anim_ent thread anim_loop_solo( level.price, "hunted_open_barndoor_idle", undefined, "stop_idle" );
	
	flag_wait("house01_clear");
	trigger = getent( "price_open_door01_trigger", "targetname" );
	trigger waittill( "trigger" );
	
	//flag_wait("barn_truck");
	//flag_set("barn_interrogation_start");

	anim_ent notify( "stop_idle" );
	anim_ent thread anim_single_solo( level.price, "hunted_open_barndoor" );

	// todo: get notetrack.
	wait 1.75;

	door = getent( "house01_front_door","targetname");
	door rotateto( door.angles + (0,70,0), 2, .5, 0 );
	door connectpaths();
	door waittill( "rotatedone");
	door rotateto( door.angles + (0,40,0), 2, 0, 2 );

	price_courtyard = getnode("price_courtyard","script_noteworthy");
	level.price setgoalnode(price_courtyard);	
	level.price.goalradius = 64 ;
	wait 1;
	activate_trigger_with_targetname( "moveout_courtyard" );
 
}


courtyard_guy()
{
	
	cy01_spawner = getent("courtyard_badguy01","script_noteworthy");
	courtyard_badguy01 = cy01_spawner dospawn();	
	if(spawn_failed(courtyard_badguy01))
		return;
	courtyard_badguy01.cqbwalking = true;
	courtyard_badguy01 thread stopIgnoringPlayerWhenShot();
	//waittill_dead(courtyard_badguy01);
	//flag_set("courtyard_badguy01_dead");
	
}

price_opens_door02()
{

	anim_ent = getnode( "price_open_door02_node", "script_noteworthy" );
	anim_ent anim_reach_solo( level.price, "hunted_open_barndoor" );
	anim_ent anim_single_solo( level.price, "hunted_open_barndoor_stop" );
	anim_ent thread anim_loop_solo( level.price, "hunted_open_barndoor_idle", undefined, "stop_idle" );
	
	flag_wait("attack_house2");
	
	anim_ent notify( "stop_idle" );
	anim_ent thread anim_single_solo( level.price, "hunted_open_barndoor" );

	// todo: get notetrack.
	wait 1.75;

	door = getent( "house02_front_door","targetname");
	door rotateto( door.angles + (0,70,0), 2, .5, 0 );
	door connectpaths();
	door waittill( "rotatedone");
	door rotateto( door.angles + (0,40,0), 2, 0, 2 );

	flag_set("breach_house02_done");
}

house02_assault()
{

    trigger = getent("moveto_house02","targetname");
    assertex(isDefined(trigger), "moveto_house02 trigger not found");
    trigger waittill("trigger");
    trigger delete();
    	
	flag_set("attack_house2");
	level thread house02_badguy01();
	flag_wait("breach_house02_done");
		
	price_house02_enter = getnode("price_house02_enter","script_noteworthy");
	level.price setgoalnode(price_house02_enter);	
	level.price.goalradius = 64 ;
	
	//wait till breech
	trigger = getent("movein_house02","targetname");
	assertex(isDefined(trigger), "movein_house02 trigger not found");
	trigger waittill("trigger");
	trigger delete();
	

	
	trigger = getent("movein_kitchen","targetname");
	assertex(isDefined(trigger), "movein_kitchen trigger not found");
	trigger waittill("trigger");
	trigger delete();


	wait 1;	
	price_house02_flr01_clear = getnode("price_house02_flr01_clear","script_noteworthy");
	level.price setgoalnode(price_house02_flr01_clear);	
	level.price.goalradius = 64 ;
	
	
	trigger = getent("movein_upstairs","targetname");
	assertex(isDefined(trigger), "movein_upstairs trigger not found");
	trigger waittill("trigger");
	trigger delete();
	level thread h2_floor2_kill_counter();
	level thread rescue_breach();
	level thread spawn_mark();
	level thread rescue_entered_wait();
	level thread moveto_tower();
	level thread chopper();

	wait 1;	
	price_house02_flr02_clear = getnode("price_house02_flr02_clear","script_noteworthy");
	level.price setgoalnode(price_house02_flr02_clear);	
	level.price.goalradius = 64 ;
	//ADD DET CORD BREACH
	//flag_wait("ready_for_breach");
	       
    trigger = getent("kitchen2","targetname");
    assertex(isDefined(trigger), "kitchen2 trigger not found");
    trigger delete();
}

house02_badguy01()
{

	h2bd01_spawner = getent("house02_badguy01","script_noteworthy");
	house02_badguy01 = h2bd01_spawner dospawn();	
	if(spawn_failed(house02_badguy01))
		return;
	house02_badguy01.cqbwalking = true;
	house02_badguy01 thread stopIgnoringPlayerWhenShot();

}

house02_secondfloor_guys()
{
	house02_bd02 = self dospawn();	
	if(spawn_failed(house02_bd02))
		return;
	house02_bd02.pacifist = true;
	house02_bd02.cqbwalking = true;
	house02_bd02 thread stopIgnoringPlayerWhenShot();
		
}

h2_floor2_kill_counter()
{
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("house02_bd02","script_noteworthy"), ::spawnerThink, ent);
	array_thread(getentarray("house02_bd02","script_noteworthy"), ::house02_secondfloor_guys);
	ent waittill ("spawned_guy");
	waittillframeend;
	
	waittill_dead(ent.guys);
	

	autosave_by_name("house02_clear");
	
	wait 1;
	iprintlnbold ("Grigsby -Bout damn time... I was starting to think you guys were gonna leave me behind");
	//level.mark dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.mark anim_single_solo( friendly, "contact_overpass" );
	wait 2;
	iprintlnbold ("Price - Yeah, that was the plan, but your sexy ass had all the C4. You ok?");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	wait 2;
	iprintlnbold ("Grigsby - Yeah I'm good to go.");
	//level.mark dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.mark anim_single_solo( friendly, "contact_overpass" );
	flag_set("house02_clear");

	
}	

spawn_mark()
{

	mark_spawner = getent("mark","script_noteworthy");
	level.mark = mark_spawner dospawn();	
	if(spawn_failed(level.mark))
		return;
	level.mark.pacifist = true;
	level.mark setthreatbiasgroup( "non_combat" );
	level.mark.cqbwalking = true;
	level.mark.ignoreme = true;
	level.mark thread magic_bullet_shield();
	level.mark.animname = "mark";
	//thread setup_mark();
}

rescue_breach()
{
	trigger = getent ("start_breach", "targetname");
	trigger waittill("trigger");
	trigger delete();
	
	eVolume = getent("volume_room01", "targetname");
	thread breach_dialog(eVolume);
	
//	aBreachers = getentarray("buddies", "script_noteworthy");
	aBreachers = [];
	aBreachers = add_to_array ( aBreachers, level.price );
	aBreachers = add_to_array ( aBreachers, level.buddies[0] );
	sBreachType = "explosive_breach_left";
	eVolume thread maps\_breach::breach_think(aBreachers, sBreachType);
	
	while (!eVolume.breached)
            wait (0.05);


	level.mark set_force_color( "b" );
	level.price set_force_color( "b" );
	
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
		{
		allies[i].pacifist = false;
		allies[i].cqbwalking = false;
		allies[i] set_force_color("b");
		}
}

breach_dialog(eVolume)
{
	//level.price playsound ( "armada_pri_targetbuildingleftbreach" );
	//wait 3;
	//level.breacher playsound ( "armada_gm4_withyou" );
	
	//trigger_volume_room01 waittill("trigger");
	eVolume waittill ("detpack_about_to_blow");
	
	wait 3;
	iprintlnbold ("GO GO GO!!");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	/*
	level.price playsound ( "armada_pri_blowcharge" );
	wait 2;
	level.breacher playsound ( "armada_gm1_breaching" );
	wait 1;
	level.price playsound ( "armada_pri_gogogo" );
	*/
}


rescue_entered_wait()
{
	trigger = getent ("trigger_volume_room01", "targetname");
	trigger waittill("trigger");
	flag_set( "hq_entered" );	
}

moveto_tower()
{	
	flag_wait("house02_clear");
	wait 2;
	activate_trigger_with_targetname( "house2_clear" );	

	trigger = getent("moveout_tower","targetname");
	assertex(isDefined(trigger), "moveout_tower trigger not found");
	trigger waittill("trigger");
	trigger delete();

	activate_trigger_with_targetname( "color_b20_trigger" );
	
	trigger = getent("choppers_inbound","targetname");
	assertex(isDefined(trigger), "choppers_inbound trigger not found");
	trigger waittill("trigger");
	trigger delete();
	
	iprintlnbold ("Marine1 - Enemy helicopters!");
	//level.marine1 dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.marine1 anim_single_solo( friendly, "contact_overpass" );
	wait 1;
	iprintlnbold ("Price - Roger. Slicks inbound! Hit the deck!");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	level thread blow_tower();


}

chopper()
{
	flag_wait("house02_clear");
	trigger = getent("chopper_gone","targetname");
	assertex(isDefined(trigger), "chopper_gone trigger not found");
	trigger waittill("trigger");
	trigger delete();
	iprintlnbold ("Price - Move!");
	wait 1;
	activate_trigger_with_targetname( "chopper_gone_moveout" );
	wait 1;
	iprintlnbold ("Price - Team Two, what's your status over?");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );

	
}

tower_c4()
{

	tower = getent("tower", "targetname");
	
	tower maps\_c4::c4_location( undefined, (0, 0, 0), tower.angles, tower.origin);
	tower waittill( "c4_detonation" );
	tower notify( "death" ); 
		

	level.towerExplosion_fx	= loadfx( "explosions/large_vehicle_explosion" );
	playfx(level.towerExplosion_fx, tower.origin);
	
	//thread play_sound_in_space("bog_aagun_explode", tower.origin);
	
	//tower setmodel( "tower_burn" );
	radiusDamage(tower.origin + (0,0,96), level.towerBlastRadius, 1000, 50);
	
	flag_set("tower_destroyed");
}

tower_interface()
{
	level endon ( "tower_destroyed" );
	
	while( !flag( "tower_destroyed" ) )
	{
		weapon = level.player getcurrentweapon();
		
		if( weapon != "c4" )
			level.player switchtoweapon( "c4" );
			
		wait 0.5;
	}
}

blow_tower()
{
	trigger = getent("start_planting","targetname");
	assertex(isDefined(trigger), "start_planting trigger not found");
	trigger waittill("trigger");
	trigger delete();
	level thread tower_c4();
	iprintlnbold ("Marine4 - Team Two in position at the perimeter. Waiting on you to kill the power, over.  ");
	//level.marine4 dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.marine4 anim_single_solo( friendly, "contact_overpass" );
	wait 1;
	iprintlnbold ("Price - Roger. Jackson. Griggs. Plant the charges. Go");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );

	level waittill( "c4_in_place" );
	level thread tower_interface();
	activate_trigger_with_targetname( "c4_planted" );
	iprintlnbold ("Grigsby - Charges set. Everyone get clear");
	//level.mark dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.mark anim_single_solo( friendly, "contact_overpass" );
	
	//trigger = getent("fall_back","targetname");
	//assertex(isDefined(trigger), "fall_back trigger not found");
	//trigger waittill("trigger");
	//trigger delete();

	tower = getent("tower", "targetname");
	dist = length( level.player.origin - tower.origin );
	//% buffer safe blast distance
	while( dist <= ( level.towerBlastRadius * 1.05 ) )
	{
		dist = length( level.player.origin - tower.origin );
		wait 0.05;	
	}
	
	
	wait 3;
	iprintlnbold ("Price - Jackson DO IT!");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	
	flag_wait("tower_destroyed");
	//player blows it up
	//play FX and anims
	//kill lights
	wait 1;
	activate_trigger_with_targetname( "move_to_watch" );
	wait 2;
	iprintlnbold ("Price - Team Two, the tower's down and the power's out. Twenty seconds.");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	wait 2;
	iprintlnbold ("Marine4 - Roger. We're breaching the perimeter. Standby.");
	//level.marine4 dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.marine4 anim_single_solo( friendly, "contact_overpass" );
	wait 3;
	iprintlnbold ("Grigsby - Backup power in ten seconds…");
	//level.mark dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.mark anim_single_solo( friendly, "contact_overpass" );
	wait 2;
	iprintlnbold ("Marine4 - Standby");
	//level.marine4 dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.marine4 anim_single_solo( friendly, "contact_overpass" );
	wait 3;
	iprintlnbold ("Grigsby - Five seconds…");
	//level.mark dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.mark anim_single_solo( friendly, "contact_overpass" );
	wait 2;
	iprintlnbold ("Marine4 - Ok. We're through. Team One, meet us at the rally point");
	//level.marine4 dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.marine4 anim_single_solo( friendly, "contact_overpass" );
	wait 2;
	iprintlnbold ("Price - Roger Team Two, we're on our way. Out");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	wait 2;
	iprintlnbold ("Grigsby - Backup power's online. Damn that was close!");
	//level.mark dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.mark anim_single_solo( friendly, "contact_overpass" );
	wait 1;
	iprintlnbold ("Price - Come on, let's go!");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	activate_trigger_with_targetname( "move_to_fence01" );
	flag_set("tower_blown");
	autosave_by_name("tower_destroyed");
	level thread cut_fence01();
	level thread cut_fence02();
	level thread old_base();

		
}	

cut_fence01()
{
	trigger = getent("fence01","targetname");
	assertex(isDefined(trigger), "fence01 trigger not found");
	trigger waittill("trigger");
	wait 2;
	iprintlnbold ("Price - Grigsby, Haggerty chop the fence");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	//chainlink fence cutting anims
	wait 4;
	fence01_clip = getent("fence01_clip","targetname");
	fence01_clip connectpaths();
	fence01_clip delete();
	
	iprintlnbold ("fence is cut");
	//peeps move through
	wait 1;
	iprintlnbold ("Price - C'mon lets go! Move it!");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	wait 1;
	activate_trigger_with_targetname( "fence01_moveout" );
	
	trigger = getent("move_to_oldbase01","targetname");
	assertex(isDefined(trigger), "move_to_oldbase01 trigger not found");
	trigger waittill("trigger");
	trigger delete();
	
	trigger = getent("move_to_oldbase02","targetname");
	assertex(isDefined(trigger), "move_to_oldbase02 trigger not found");
	trigger waittill("trigger");
	trigger delete();

	
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
	{
		allies[i].cqbwalking = true;
		allies[i].pacifist = true;
	}
	
}

//START BASE TO JUMP TO THE OLD BASE AREA
base_start()
{
	VisionSetNaked( "icbm_sunrise4");
	level thread cut_fence02();
	level thread old_base();
	level thread setupPlayer();
	base_start = getent( "base_start", "targetname" );
	level.player setOrigin( base_start.origin );
	level.player setPlayerAngles( base_start.angles );
	base_start_spawners = getentarray("base_start_spawners", "targetname");
	array_thread( base_start_spawners, maps\_spawner::spawn_ai );
	 
	level thread objectives();
	flag_set( "regroup01_done" );
	flag_set( "house02_clear" );
	flag_set( "tower_blown" );
	
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
		{
		allies[i].pacifist = true;
		allies[i].cqbwalking = true;
		allies[i] setthreatbiasgroup( "allies" );
		allies[i] set_force_color( "b" );
		}
	level thread magic_buddies();

	price2_spawner = getent("price2","script_noteworthy");
	level.price = price2_spawner dospawn();
	if(spawn_failed(level.price))
		return;
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	level.price set_force_color( "b" );
	
	mark2_spawner = getent("mark2","script_noteworthy");
	level.mark = mark2_spawner dospawn();
	
	if(spawn_failed(level.mark))
		return;
	assertex(isdefined(level.mark),"Mark not getting defined!");
	level.mark.animname = "mark";
	level.mark thread magic_bullet_shield();	
	level.mark set_force_color( "b" );

	
}



cut_fence02()
{
	trigger = getent("fence02","targetname");
	assertex(isDefined(trigger), "fence02 trigger not found");
	trigger waittill("trigger");
	wait 1;
	iprintlnbold ("Price - Cut it");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	//chainlink fence cutting anims
	wait 4;
	fence02_clip = getent("fence02_clip","targetname");
	fence02_clip connectpaths();
	fence02_clip delete();
	iprintlnbold ("fence is cut");
	wait 1;
	
	level.price disable_ai_color();
	level.mark disable_ai_color();
	
	price_oldbase = getnode("price_oldbase","script_noteworthy");
	level.price setgoalnode(price_oldbase);	
	level.price.goalradius = 64 ;

	mark_oldbase = getnode("mark_oldbase","script_noteworthy");
	level.mark setgoalnode(mark_oldbase);	
	level.mark.goalradius = 64 ;
	activate_trigger_with_targetname( "fence02_moveout" );
	
	iprintlnbold ("Marine4 - Team One, this is Team Two.  Three trucks packed with shooters are headed your way.");
	//level.marine4 dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.marine4 anim_single_solo( friendly, "contact_overpass" );
	wait 1;
	iprintlnbold ("Price - Copy. We're entering the old base now. Standby.");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	
}

old_base()
{
	trigger = getent("entered_oldbase","targetname");
	assertex(isDefined(trigger), "entered_oldbase trigger not found");
	trigger waittill("trigger");
	trigger delete();
	level thread bmp();	
	trigger = getent("incoming_oldbase","targetname");
	assertex(isDefined(trigger), "incoming_oldbase trigger not found");
	trigger waittill("trigger");
	trigger delete();
	wait 1;
	iprintlnbold ("Marine1 - I have a visual on the trucks. There's a shitload of troops sir.");
	//level.marine1 dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.marine1 anim_single_solo( friendly, "contact_overpass" );
	wait 2;
	iprintlnbold ("Price - All right squad, you know the drill.  Griggs, you're with Jackson. Haggerty, on me. Move.");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	
	autosave_by_name("base_fight");
	wait 1;
	level.mark set_force_color( "b" );
	level.price set_force_color( "b" );	
	wait 2;
	activate_trigger_with_targetname( "old_base_flank" );
	
	battlechatter_on( "allies" );	
	battlechatter_on( "axis" );
	wait 2;
	
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
	{
		allies[i].cqbwalking = false;
		allies[i].pacifist = false;
	}
		
	trigger = getent("start_base_attackers","targetname");
	assertex(isDefined(trigger), "start_base_attackers trigger not found");
	trigger waittill("trigger");
	trigger delete();
	
	level thread setup_sortie();
	level thread attacker_wave01();
	level thread attacker_wave01b();
	level thread first_base_area();
}	

bmp()
{

	trigger = getent("bmp_fire","targetname");
	assertex(isDefined(trigger), "bmp_fire trigger not found");
	trigger waittill("trigger");
	//iprintlnbold ("BMP starts firing MG");
	bmp = getent("base_bmp","targetname");
	bmp thread vehicle_turret_think();
	bmp.script_turretmg = true;
	bmp waittill ("death");	
	//wait till dead
	flag_set( "bmp_dead" );
	autosave_by_name("base_clear");
	
	axis = getaiarray("axis");
	for(i = 0; i < axis.size; i++)
	{
		axis[i] setgoalentity(level.player);
		axis[i].goalradius = 128;
	}
}

attacker_wave01()
{
	
	trigger = getent("base_attackers01", "target");
	trigger notify("trigger");
	   
}

attacker_wave01b()
{

	trigger = getent("spawn_attackers01b","targetname");
	assertex(isDefined(trigger), "spawn_attackers01btrigger not found");
	trigger waittill("trigger");
	trigger delete();	
		
	trigger = getent("base_attackers01b", "target");
	trigger notify("trigger");
	   

}



first_base_area()
{
	trigger = getent("load_bldg02","targetname");
	assertex(isDefined(trigger), "load_bldg02 trigger not found");
	trigger waittill("trigger");
	trigger delete();	
	level thread attacker_wave02();
	level thread second_base_area();
	level thread cross_road();
}


attacker_wave02()
{
	
	trigger = getent("base_attackers02", "target");
	trigger notify("trigger");
	   

}


cross_road()
{
	area_trigger = getent("kill_counter_volume","targetname");
	trigger = getent("cross_road","targetname");
	assertex(isDefined(trigger), "cross_road not found");
	trigger waittill("trigger");
	trigger delete();
	
	while (1)
	{
		axis = getaiarray("axis");
		anyaxis = false;
		for(i = 0; i < axis.size; i++)
		{
			if( axis[i] istouching(area_trigger))
			{
				anyaxis = true;
				break;
			}
		}
		if (anyaxis == true) 
		{
			wait 1;
			continue;
		}
		break;	
	}
	activate_trigger_with_targetname( "move_to_cross_road" );
	wait 3;	
	iprintlnbold ("Price - That BMP has us pinned down. Someone get a smoke grenade out there!!");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	wait 1;
	iprintlnbold ("Grigsby - I'm on it!");
	//level.mark dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.mark anim_single_solo( friendly, "contact_overpass" );
	wait .5;
	maps\_utility::exploder(13);
	wait 5;
	iprintlnbold ("Price - Get across the road, go go!!");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	wait 2;
	activate_trigger_with_targetname( "cross_road_go" );
	level thread path_blocker();
}	

path_blocker()
{
	blocker = getent("path_blocker","targetname");
	flag_wait("unblock_path");
	blocker connectpaths();
	blocker delete();

	

}

second_base_area()
{
	trigger = getent("load_second_area","targetname");
	assertex(isDefined(trigger), "load_second_area trigger not found");
	trigger waittill("trigger");
	trigger delete();
	autosave_by_name("base_second_area");	
	level thread attacker_wave03();
	level thread base_cleaner();
	//level thread cleanup_first_area();
	trigger = getent("spawn_wave4","targetname");
	assertex(isDefined(trigger), "spawn_wave4 trigger not found");
	trigger waittill("trigger");
	trigger delete();
	level thread attacker_wave04();
	level thread base_flankers01();
	level thread kill_bmp();
}

attacker_wave03()
{
	
	trigger = getent("base_attackers03", "target");
	trigger notify("trigger");
	   

}

base_cleaner()
{
	
	trigger = getent("base_cleaner", "target");
	trigger notify("trigger");
	   

}

attacker_wave04()
{
	
	trigger = getent("base_attackers04", "target");
	trigger notify("trigger");
	   

}



base_flankers01()
{
	trigger = getent("base_flankers01_spawn","targetname");
	assertex(isDefined(trigger), "base_flankers01_spawn trigger not found");
	trigger waittill("trigger");
	trigger delete();	
	
	trigger = getent("base_flankers01", "target");
	trigger notify("trigger");
	wait 2;
	iprintlnbold ("Price - Watch out behind us!!");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	wait 10;
	iprintlnbold ("Price - Keep moving, keep moving!!");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	flag_set("unblock_path");

}

stop_spawners()
{

	trigger = getent("kill_spawners","targetname");
	assertex(isDefined(trigger), "kill_spawners trigger not found");
	//level waittill("tank dead");
	trigger notify("trigger");
 
}




kill_bmp()
{
	trigger = getent("base_last_bldg","targetname");
	assertex(isDefined(trigger), "base_last_bldg trigger not found");
	trigger waittill("trigger");
	trigger delete();
	wait 2;
	iprintlnbold ("Price - Jackson take that BMP out!!");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );	
	//nag stuff
	flag_wait( "bmp_dead" );
	wait 2;
	iprintlnbold ("Price - Great job, everyone regroup on me");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	activate_trigger_with_targetname( "base_clear_regroup" );
	
	trigger = getent("play_leaving_base","targetname");
	assertex(isDefined(trigger), "play_leaving_base trigger not found");
	trigger waittill("trigger");
	trigger delete();
	iprintlnbold ("Price - Clear, move out");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );				
	activate_trigger_with_targetname( "bmp_dead_moveout" );		
	level thread missile_launch();
	level thread missile_launch02();
	level thread meetup_second_squad();
	
}	

missile_launch()
{
	missile01_start = getent ("missile01_start","targetname");
	missile01_end = getent ("missile01_end","targetname");
	icbm_missile = getent ("icbm_missile","targetname");
	//flag_wait("fire_missile");
	trigger = getent("lift_off","targetname");
	assertex(isDefined(trigger), "lift_off trigger not found");
	trigger waittill("trigger");
	trigger delete();
			
	flag_set("spawn_second_sqaud");
	//FIRE!!
	icbm_missile linkto (missile01_start);
	missile01_start moveto (missile01_end.origin,5,3,0);	
	//icbm_missile thread maps\_utility::playSoundOnTag("parachute_land_player");

	missile01_start waittill ("movedone");
	icbm_missile delete();
	
	
	iprintlnbold ("Grigsby - What the hell…");
	//level.mark dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.mark anim_single_solo( friendly, "contact_overpass" );
	wait 2;
	iprintlnbold ("Marine01 - Uhh we got a problem here!...");
	//level.marine1 dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.marine1 anim_single_solo( friendly, "contact_overpass" );
	wait 2;
	iprintlnbold ("Price - Delta One X-Ray, we have a missile launch, I repeat we have a missile");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	flag_set("launch_02");
	wait 2;
	iprintlnbold ("Grigsby - There's another one!");
	//level.mark dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.markanim_single_solo( friendly, "contact_overpass" );
	wait 2;
	iprintlnbold ("Price - Delta One X-Ray - we have two missiles in the air over!");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	wait 2;
	iprintlnbold ("HQ - Uh…roger Bravo Six, we're working on getting the abort codes from the Russians. There's a telemetry station inside the facility. Get your team in there now.");
	//level.hq dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.hq anim_single_solo( friendly, "contact_overpass" );	
	wait 2;
	iprintlnbold ("Price - Roger that. Movin'!");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	wait 1;	
	activate_trigger_with_targetname( "moveto_ending" );	
}

missile_launch02()
{

	missile02_start = getent ("missile02_start","targetname");
	missile02_end = getent ("missile02_end","targetname");
	icbm_missile02 = getent ("icbm_missile02","targetname");
	flag_wait("launch_02");	
	//FIRE!!
	icbm_missile02 linkto (missile02_start);
	missile02_start moveto (missile02_end.origin,5,3,0);	
	//icbm_missile thread maps\_utility::playSoundOnTag("parachute_land_player");

	missile02_start waittill ("movedone");
	icbm_missile02 delete();


}

meetup_second_squad()
{
	flag_wait("spawn_second_sqaud");
	squad_02 = getentarray("squad_02", "script_noteworthy");
	array_thread( squad_02, maps\_spawner::spawn_ai );
	
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
	{
		allies[i].pacifist = true;
	}
	
	battlechatter_off( "allies" );	
	battlechatter_off( "axis" );

	trigger = getent("second_squad_trigger","targetname");
	assertex(isDefined(trigger), "second_squad_trigger trigger not found");
	trigger waittill("trigger");

	wait 1;
	iprintlnbold ("Marine04 - Shit's hit the fan now");
	//level.marine4 dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.marine4 anim_single_solo( friendly, "contact_overpass" );
	wait 2;
	iprintlnbold ("Price - You're tellin' me…. Let's go! We gotta move!");
	//level.price dialogue_thread("hill400_assault_rnd_getsmoke");
	//level.price anim_single_solo( friendly, "contact_overpass" );
	wait 1;
	flag_set("level_done");
	wait 5;
	missionsuccess( "launchfacility_a", false );

}



//**********************************************//
//		  UTILITIES								//
//**********************************************//

beehive()
{
	//POKE THE BEEHIVE
	trigger = getent("beehive01_dmg","targetname");
	assertex(isDefined(trigger), "beehive01_dmg trigger not found");
	trigger waittill("trigger");
	wait 2;
	flag_set( "sound alarm" );
}	

reinforcements()
{

	//Spawn extra men, sortie script (go here, wait, then target player)
	//need to play door open anim
	flag_wait( "sound alarm" );

	iprintlnbold ("ALARM SOUNDED!!");
	wait 2;
	battlechatter_on( "axis" );
	spawners = getentarray( "beehive_badguys", "script_noteworthy" );
	array_thread( spawners, ::spawn_beehive_guys );
	
	wait 2;

	door = getent( "beehive1_front_door","targetname");
	door rotateto( door.angles + (0,-110,0), .5, 0, .3 );
	door connectpaths();
		
	wait 1.75;

	door = getent( "beehive2_front_door","targetname");
	door rotateto( door.angles + (0,-110,0), .5, 0, .3 );
	door connectpaths();
	
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
		{
		allies[i].pacifist = false;
		allies[i].cqbwalking = false;
		allies[i] setthreatbiasgroup( "fight" );
		}
	battlechatter_on( "allies" );
							
}


set_goalradius(radius)
{
       if (!isdefined(radius))
       {
               if (isdefined(self.old_goalradius))
               {
                       self.goalradius = self.old_goalradius;
                       self.old_goalradius = undefined;
               }
               return;
       }

       if (!isdefined(self.old_goalradius))
               self.old_goalradius = self.goalradius;
       self.goalradius = radius;
}

set_goalnode(node,range)
{
       self endon("death");
       self notify("abort_chain");

       assert(isdefined(node));
       if (isdefined(range))
       {
               assert(range >= 0.1);
               wait randomfloatrange (0.1, range);
       }
       if (isdefined(node.radius))
               self.goalradius = node.radius;
       if (isalive(self))
               self setgoalnode(node);
}


setgoalentityforbuddies(target)
{
       //COUNT UP BUDDIES
       buddies = getentarray("buddies", "script_noteworthy");
       for(i=0;i<buddies.size;i++)
       {
               if(isalive(buddies[i]))
                       buddies[i] setgoalentity (target);
       }
}

setgoalforbuddies(goal)
{
       //COUNT UP BUDDIES
       buddies = getentarray("buddies", "script_noteworthy");
       for(i=0;i<buddies.size;i++)
       {
               if(isalive(buddies[i]))
               {
                       buddies[i] setgoalnode (goal);
                       buddies[i].goalradius = goal.radius;

               }
       }
 
}

magic_buddies()
{

       //COUNT UP BUDDIES
       level.buddies = getentarray("buddies", "script_noteworthy");
       for(i=0;i<level.buddies.size;i++)
       {
               if(isalive(level.buddies[i]))
               {
				level.buddies[i] thread magic_bullet_shield();

               }
       }


}

selfdospawn()
{

	self dospawn();

}

spawn_beehive_guys()
{

	beehive_spawn = self dospawn();	
	if(spawn_failed(beehive_spawn))
		return;	
	beehive_spawn.pacifist = false;
	beehive_spawn.cqbwalking = false;
	beehive_spawn.goalradius = 1024;
	beehive_spawn.goalheight = 512;
	beehive_spawn.fightdist = 0;
	beehive_spawn.maxdist = 0;
	beehive_radius = getnode("beehive_radius","targetname");	
	beehive_spawn setGoalNode( beehive_radius );
		
			

}
stopIgnoringPlayerWhenShot()
{
   self endon ("death");
   self waittill_any ("bulletwhizby","suppression","enemy");
   self setthreatbiasgroup();   // this removes self to default threatbiasgroup
   iprintlnbold ("Huh, who's that!!");
   wait 5;
   flag_set( "sound alarm" );
}

setup_sortie()
{
    aSpawner = getentarray("sortie","script_noteworthy");
    level array_thread(aSpawner, ::sortie); }

sortie()
{
    while(true)
    {
        self waittill("spawned",ai);
        ai thread sortie_wait(self.script_wait,self.script_waittill);
    }
}

sortie_wait(waittime, waitstring)
{
    self endon("death");
    self endon("escape your doom");

    if (isdefined(waitstring))
        level waittill(waitstring);
    else
        self waittill("goal");
    if (isdefined(waittime))
        wait randomfloatrange(waittime,waittime+4);

    println("sortie " + self getentitynumber());

    self setgoalentity(level.player);
    self.goalradius = 1536;
}

vehicle_get_target(aExcluders)
{
	eTarget = maps\_helicopter_globals::getEnemyTarget( level.bmpCannonRange, level.cosine[ "180" ], true, true, false, false,  aExcluders);
	return eTarget;
}


vehicle_turret_think()
{
	self endon ("death");
	self endon ( "c4_detonation" );
	self thread maps\_vehicle::mgoff();
	self.turretFiring = false;
	eTarget = undefined;
	aExcluders = [];

	aExcluders[0] = level.price;
	aExcluders[1] = level.mark;


	currentTargetLoc = undefined;

	
	//if (getdvar("debug_bmp") == "1")
		//self thread vehicle_debug();

	while (true)
	{
		wait (0.05);
		/*-----------------------
		GET A NEW TARGET UNLESS CURRENT ONE IS PLAYER
		-------------------------*/		
		if ( (isdefined(eTarget)) && (eTarget == level.player) )
		{
			sightTracePassed = false;
			sightTracePassed = sighttracepassed( self.origin, level.player.origin + ( 0, 0, 150 ), false, self );
			if ( !sightTracePassed )
			{
				//self clearTurretTarget();
				eTarget = self vehicle_get_target(aExcluders);
			}
				
		}
		else
			eTarget = self vehicle_get_target(aExcluders);

		/*-----------------------
		ROTATE TURRET TO CURRENT TARGET
		-------------------------*/		
		if ( (isdefined(eTarget)) && (isalive(eTarget)) )
		{
			targetLoc = eTarget.origin + (0, 0, 32);
			self setTurretTargetVec(targetLoc);
			
			
			if (getdvar("debug_bmp") == "1")
				thread draw_line_until_notify(self.origin + (0, 0, 32), targetLoc, 1, 0, 0, self, "stop_drawing_line");
			
			fRand = ( randomfloatrange(2, 3));
			self waittill_notify_or_timeout( "turret_rotate_stopped", fRand );

			/*-----------------------
			FIRE MAIN CANNON OR MG
			-------------------------*/
			if ( (isdefined(eTarget)) && (isalive(eTarget)) )
			{
				if ( distancesquared(eTarget.origin,self.origin) <= level.bmpMGrangeSquared)
				{
					if (!self.mgturret[0] isfiringturret())
						self thread maps\_vehicle::mgon();
					
					wait(.5);
					if (!self.mgturret[0] isfiringturret())
					{
						self thread maps\_vehicle::mgoff();
						if (!self.turretFiring)
							self thread vehicle_fire_main_cannon();			
					}
	
				}
				else
				{
					self thread maps\_vehicle::mgoff();
					if (!self.turretFiring)
						self thread vehicle_fire_main_cannon();	
				}				
			}

		}
		
		//wait( randomfloatrange(2, 5));
	
		if (getdvar( "debug_bmp") == "1")
			self notify( "stop_drawing_line" );
	}
}

vehicle_fire_main_cannon()
{
	self endon ("death");
	self endon ( "c4_detonation" );
	//self notify ("firing_cannon");
	//self endon ("firing_cannon");
	
	iFireTime = weaponfiretime("bmp_turret");
	assert(isdefined(iFireTime));
	
	iBurstNumber = randomintrange(3, 8);
	
	self.turretFiring = true;
	i = 0;
	while (i < iBurstNumber)
	{
		i++;
		wait(iFireTime);
		self fireWeapon();
	}
	self.turretFiring = false;
}


//////time of day change stuff///////


SunRise()
{
	level.sunRiseInterpColors = [];
	
	sunRiseInitColor( "sun", (0.1,0.1,0.1) );
	VisionSetNaked( "icbm_sunrise0" );

	thread doSunRiseColors();
	setExpFog(0.00, 4000.00, 0.5, 0.5, 0.5, 0);
	wait .05;
	setExpFog(0, 771.52, 0.5, 0.5, 0.5, 20);

	interval = .05;
	while(1)
	{
		sunColor = sunRiseIncrTime( "sun", interval );
		setSunLight( sunColor[0], sunColor[1], sunColor[2] );
		wait interval;
	}
}

doSunRiseColors()
{
	// these intervals will probably need tweaking when there's gameplay.

	// note that we don't actually wait for the intervals to pass.
	// if we hit the next trigger before it passes, everything will just
	// interpolate ahead from its current value.
	
	///////////////////////////////////////////////////////////
	// #1st trigger
	/*getent("sunrise1", "targetname") waittill("trigger");
	interval = 20;
	setExpFog( 200, 10000, .1, .1, .2, interval );
	sunRiseSetColorTarget( "sun", (0,0,0), interval );
	VisionSetNaked( "icbm_sunrise1", interval );*/
	
	///////////////////////////////////////////////////////////
	// #2nd trigger
	getent("sunrise2", "targetname") waittill("trigger");
	interval = 100;
	setExpFog( 200, 12000, .27, .25, .35, interval );
	sunRiseSetColorTarget( "sun", vectorScale( (1,.4,.1), .75 ), interval );
	VisionSetNaked( "icbm_sunrise2", interval );
	flag_set("stop_snow");


	///////////////////////////////////////////////////////////
	// #3: approaching the industrial area. sun becomes strong red over 20 seconds
	getent("sunrise3", "targetname") waittill("trigger");
	interval = 20;
	setExpFog( 200, 30000, .65, .5, .3, interval );
	sunRiseSetColorTarget( "sun", vectorScale( (1,.55,.25), 1 ), interval );
	VisionSetNaked( "icbm_sunrise3", interval );

	///////////////////////////////////////////////////////////
	// #4: leaving the industrial area. sun becomes near white over 20 seconds
	getent("sunrise4", "targetname") waittill("trigger");
	interval = 20;
	setExpFog( 200, 60000, .8, .65, .5, interval );
	sunRiseSetColorTarget( "sun", vectorScale( (1,.7,.4), 1.35 ), interval );
	VisionSetNaked( "icbm_sunrise4", interval );
}

sunRiseIncrTime(colorName, time)
{
	data = level.sunRiseInterpColors[colorName];
	
	assert( isdefined( data ) );
	
	data["timePassed"] += time;
	if ( data["timePassed"] >= data["timeTotal"] )
		data["timePassed"] = data["timeTotal"];
	
	A = data["start"];
	B = data["target"];
	t = data["timePassed"] / data["timeTotal"];
	
	data["current"] = vectorScale( A, 1 - t ) + vectorScale( B, t );
	
	level.sunRiseInterpColors[colorName] = data;
	
	return data["current"];
}

sunRiseInitColor(colorName, color)
{
	data["start"] = color;
	data["target"] = color;
	data["current"] = color;
	data["timePassed"] = 0;
	data["timeTotal"] = 1;
	
	level.sunRiseInterpColors[colorName] = data;
}

sunRiseSetColorTarget(colorName, targetColor, time)
{
	data = level.sunRiseInterpColors[colorName];
	
	assert( isdefined( data ) );
	
	data["start"] = data["current"];
	data["target"] = targetColor;
	data["timePassed"] = 0;
	data["timeTotal"] = time;
	
	level.sunRiseInterpColors[colorName] = data;
}

#using_animtree("generic_human");
spawnerThink(ent)
{
	self endon ("death");
	self waittill ("spawned",spawn);
	ent.guys[ent.guys.size] = spawn;
	ent notify ("spawned_guy");
}




