#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;

#using_animtree("generic_human");
main()
{

	default_start( ::parachute_player );
	add_start( "landing", ::parachute_player );
	add_start( "tower", ::tower_start );
	add_start( "base", ::base_start );
	add_start( "launch", ::launch_start );
	
	precacheItem( "m4_silencer" );
	precacheItem( "m4m203_silencer" );
	precacheItem( "usp_silencer" );
	precacheModel("weapon_saw_MG_setup");
    precacheModel("weapon_rpd_MG_setup");
    precacheModel("com_powerline_tower_destroyed");
    precacheModel( "com_flashlight_on" );
    
	maps\_technical::main("vehicle_pickup_technical");
	maps\_mi17::main( "vehicle_mi17_woodland_fly_cheap" );
	maps\_bmp::main("vehicle_bmp");
	//maps\_truck::main("vehicle_bm21_mobile_cover_no_bench");
	maps\_bm21_troops::main("vehicle_bm21_mobile_cover_no_bench");
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
	flag_init("add_driveway");
	flag_init("driveway_done");
	flag_init("bldg1_grigs_todo");
   	flag_init( "sound alarm" );	
	flag_init( "truck arived" );
	flag_init("truckguys dead");
	flag_init("stop_snow");
	flag_init("open_basement");
	flag_init("enter_basement");
	flag_init("house01_clear");
	flag_init("clear_bldg1_done");
	flag_init("grigs_todo");
	flag_init("attack_house2");
	flag_init ("breach_house02_done");
	flag_init("ready_for_breach");
	flag_init("courtyard_badguy01_dead");
	flag_init( "hq_entered" );
	flag_init("house02_clear");
	flag_init( "tower_destroyed" );
	flag_init("tower_blown");
	flag_init("cut_fence1");
	flag_init("cut_fence2");
	flag_init("area1_started");
	flag_init("area2_started");
	flag_init("unblock_path");
	flag_init("add_kill_bmp");
	flag_init("bmp_fire");
	flag_init( "bmp_dead" );
	flag_init("in_last_bldg");
	flag_init("kill_area01_spawners");
	flag_init("kill_area02_spawners");
	flag_init("spawn_second_sqaud");
	flag_init("fire_missile");
	flag_init("launch_01");
	flag_init("launch_02");
	flag_init("lift_off_scene_done");
	flag_init("meetup_todo");
	flag_init("level_done");
	flag_init("move_to_house02_breach");
	
	//THREADS
	
	// trigger waits
	level thread trigger_wait_and_set_flag( "move01" );
	level thread trigger_wait_and_set_flag( "move02" );
	level thread trigger_wait_and_set_flag( "moveto_driveway" );
	
	

	level thread setup_price();
	level thread setupbuddies();
	level thread magic_buddies();
	level thread setup_badguys();
	level thread start_colors();

	battlechatter_off( "allies" );	
	battlechatter_off( "axis" );				

	//setupPlayer();

}

whiteIn()
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "white", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 1;
	overlay.sort = 2;
	
	trigger = getent("cloud","targetname");
	assertex(isDefined(trigger), "cloud trigger not found");
	trigger waittill("trigger");
	
	wait 1;	
	overlay fadeWhiteOut( 2, 0, 6 );
}

fadeWhiteOut( duration, alpha, blur )
{
	self fadeOverTime( duration );
	self.alpha = alpha;
	//setblur( blur, duration );
	wait duration;
}


setupPlayer()
{
	//level.player.engaged = false;
	level.player takeallweapons();
	level.player giveWeapon("m4m203_silencer");
	level.player giveWeapon("usp_silencer");
	level.player giveWeapon("fraggrenade");	
	level.player giveWeapon("flash_grenade");
	level.player switchToWeapon("m4m203_silencer");
	level.player setOffhandSecondaryClass( "flash" );
	//level.player giveWeapon("claymore");
	//level.player SetActionSlot( 3, "weapon" , "claymore" );



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
		allies[i] disable_cqbwalk();
		allies[i] setthreatbiasgroup( "allies" );
	}
}

setup_badguys()
{

	axis = getaiarray("axis");
	for(i = 0; i < axis.size; i++)
		{
		axis[i] setthreatbiasgroup( "non_combat" );
		axis[i] enable_cqbwalk();
		axis[i] thread stopIgnoringPlayerWhenShot();
		}

}
start_colors()
{
	trigger = getent("start_colors","targetname");
	assertex(isDefined(trigger), "start_colors trigger not found");
	trigger waittill("trigger");
   	trigger trigger_off();
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
	level thread whiteIn();
	level thread SunRise();
	musicPlay( "icbm_intro_music" ); 
	
	level.player allowProne (false);
	level.player allowCrouch (false);
	para_start = getent ("para_start","targetname");
	para_stop = getent ("para_stop","targetname");
	//level waittill ("starting final intro screen fadeout");
	
	
	level.player linkto (para_start);
	level.player takeallweapons();	
	para_start moveto (para_stop.origin,3,0,0);	
	//level.player thread maps\_utility::playSoundOnTag("parachute_land_player");

	para_start waittill ("movedone");
	level.player unlink();
	level.player allowProne (true);
	level.player allowCrouch (true);
	
	level thread setupPlayer();


	autosave_by_name( "on_the_ground" );
	//ADD INTRO SCREEN STUFF HERE
	//level thread maps\_introscreen::introscreen_delay(&"ICBM_INTRO", &"ICBM_DATE", &"ICBM_PLACE", &"CARGOSHIP_INFO", 1, 1, 0);
	//&"Ultimatum", &"Dec 02, 2008", &"Altay Mountains"
	
	level thread regroup_buddies01();
	level thread objectives();
	level thread small_objectives();
	price_landing = getnode("price_landing","targetname");
	level.price setgoalnode(price_landing);
 
       	
}

music()
{
//	level endon( "price_is_safe_after_wounding" );
	for( ;; )
	{
		musicPlay( "russian_suspense_01_music" ); 
		wait( 85 );
	}
}

objectives()
{

	//obj 1 - Regroup with price
	//obj 2 - Rescue Sgt.Grigsby
	//obj 3 - Regroup at driveway
	//obj 4 - clear building one
	//obj 5 - blow tower
	//obj 6 - Regroup with second squad
	//obj 7 - destroy BMP
	
	obj = getent( "landingzone", "targetname" );
	objective_add( 1, "active", "Regroup with Cpt.Price", obj.origin );
	objective_current( 1 );	
	
	flag_wait("regroup01_done");
	
	objective_state( 1, "done");
	obj = getent( "obj_grigsby", "targetname" );
	objective_add( 2, "active", "Rescue Sgt.Grigsby", obj.origin );
	objective_current( 2 );
	
	//wait for driveway and bldg1 to be done	
	flag_wait("grigs_todo");
	objective_current( 2 );	
	flag_wait("house02_clear");
	objective_state( 2, "done");
	
	obj = getent( "obj_tower", "targetname" );
	objective_add( 4, "active", "Destroy the power transmission tower", obj.origin );
	objective_current( 4 );	
	flag_wait("tower_blown");
		
	objective_state( 4, "done");
	obj = getent( "second_squad", "targetname" );
	objective_add( 5, "active", "Regroup with second squad", obj.origin );
	objective_current( 5 );	
	//add BMP and wait
	flag_wait("meetup_todo");
	objective_current( 5 );				
	flag_wait("level_done");
	objective_state( 5, "done");

}

small_objectives()
{
	//add driveway regroup (get grigsby,regroup at driveway)
	//flag_wait("add_driveway");
	//obj = getent( "driveway_regroup", "targetname" );
	//objective_add( 3, "active", "Regroup at driveway", obj.origin );

	//objective_current( 3 );
	flag_wait("driveway_done");
	//objective_state( 3, "done");	
	flag_set("bldg1_grigs_todo");
	
	//add clear bldg1 (get grigsby,clear_bldg1)	
	flag_wait("bldg1_grigs_todo");
	obj = getent( "clear_house1", "targetname" );
	objective_add( 3, "active", "Clear building one", obj.origin );
	objective_current( 3 );	
	flag_wait("clear_bldg1_done");
	objective_state( 3, "done");	
	flag_set("grigs_todo");

	//add bmp (meetup with second squad, kill BMP)
	flag_wait("add_kill_bmp");
	bmp = getent("base_bmp","targetname");
	objective_add( 6, "active", "Destroy the BMP", bmp.origin );
	objective_current( 6 );	
	flag_wait("bmp_dead");
	objective_state( 6, "done");	
	flag_set("meetup_todo");
}



regroup_buddies01()
{
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
	{
		allies[i] thread unawareBehavior();
	}

	level thread truck_spawn();
	//level waittill ("get to positions");	  
	regroup_01 = getnode("regroup_01","targetname");


	trigger = getent("regroup01_trigger","targetname");
	assertex(isDefined(trigger), "regroup01_trigger trigger not found");
	trigger waittill("trigger");
   	trigger trigger_off();
    wait 0.5;
	//iprintlnbold ("Price - Haggerty, you see where Griggs landed?");
	level.price anim_single_queue( level.price, "grigsby_landed" );
    wait 0.2;
	//iprintlnbold ("Marine1 - Yeah, over by the buildings to the east. You think they got him? ");
	level.buddies[0] anim_single_queue( level.buddies[0], "bybuildingseast" ); 	
	//iprintlnbold ("Price - We're about to find out. Haggerty, take point");
	level.price anim_single_queue( level.price, "abouttofindout" );
	//iprintlnbold ("Marine1 - You got it sir");
	level.buddies[0] anim_single_queue( level.buddies[0], "yougotit" );   
	flag_set("regroup01_done");	
	
	//move the squad out
	activate_trigger_with_targetname( "friendlies_moves_up_the_hill" );
		     
	autosave_by_name("moveout01");

	wait 3;
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
	{
		allies[i] enable_cqbwalk();
	} 
	
	price_preambush = getnode("price_preambush","script_noteworthy");
	level.price setgoalnode(price_preambush);        	
}

truck_spawn()
{
	level thread truck_guys();
	trigger = getent("truck_spawn","targetname");
	assertex(isDefined(trigger), "truck_spawn trigger not found");
	trigger waittill("trigger");
	
	level thread ambush();
	
	trigger trigger_off();
	wait 0.05;
	level thread ai_sight_clip();
	level thread patrol_kill_counter();
	wait 0.05;
	
	truck = getent("truck","targetname");
	truck maps\_vehicle::lights_on( "headlights" );
	wait .5;
									
	trigger = getent("truck_stop","targetname");
	assertex(isDefined(trigger), "truck_stop trigger not found");
	trigger waittill("trigger");
 	truck maps\_vehicle::lights_on( "brakelights" );	
	flag_set("truck arived");
	wait 10;


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
		axis[i] enable_cqbwalk();
		axis[i] thread unawareBehavior();
		axis[i] attach_flashlight( true );
	}
	
	
	waittill_dead(ent.guys);
	flag_set("truckguys dead");	
	//iprintlnbold ("Radio chatter (Russian accent)")

		
	
}


patrol_guys()
{
	//self.script_moveoverride = 1;
	//self.script_patroller = undefined;
	
	patroller1 = self dospawn();
	
	// hack to prevent him from acquiring and shooting an enemy during spawn_failed
	if ( isAlive( patroller1 ) )
		patroller1.maxsightdistsqrd = 1;
	if(spawn_failed(patroller1))
		return;
	
	patroller1 enable_cqbwalk();
	patroller1 thread unawareBehavior();
	patroller1.maxsightdistsqrd = 10000*10000;
	patroller1.goalradius = 64;
	patroller1.script_radius = 64;
	
	while ( distance( level.player.origin, self.origin ) > 6000 )
    {
        wait 0.2;
    }
	
	patroller1 attach_flashlight( true );

	flag_wait( "truck arived" );
			
}

patrol_kill_counter()
{
	
	//flag_wait("truck arived");	
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("patroller1","script_noteworthy"), ::spawnerThink, ent);
	array_thread(getentarray("patroller1","script_noteworthy"), ::patrol_guys);
	ent waittill ("spawned_guy");
	waittillframeend;

	waittill_dead(ent.guys);
	level.buddies[0] anim_single_queue( level.buddies[0], "tangodown" );
	wait 1;
	level.buddies[0] anim_single_queue( level.buddies[0], "allclear" ); 
	wait .5;
	level.price anim_single_queue( level.price, "move" );   
}

ai_sight_clip()
{
	wait 10;
	ai_sight_clip = getent("ai_sight_clip","targetname");
	ai_sight_clip connectpaths();
	ai_sight_clip delete();

}


ambush()
{
	wait 3;
	//iprintlnbold ("Marine1 - Contact front. Enemy vehicle.");
	level.buddies[0] anim_single_queue( level.buddies[0], "enemyvehicle" );  
	//iprintlnbold ("Price - I see 'em. Spread out!");
	//level.price anim_single_queue( level.price, "abouttofindout" ); 
	
	flag_wait("truckguys dead");

	activate_trigger_with_targetname( "ambush_move_out" );
	price_ambush = getnode("price_ambush","script_noteworthy");
	level.price setgoalnode(price_ambush);	
	level.price.goalradius = 64 ;
	
	wait 1;
	level.buddies[0] anim_single_queue( level.buddies[0], "tangodown" ); 
	wait 1;	
	//iprintlnbold ("Price - move out");
	level.price anim_single_queue( level.price, "move" );  
	level thread moveto_driveway();
	autosave_by_name("moveout02");
	wait 3;
	truck_radio = getent( "truck_radio", "targetname" );
	truck_radio play_sound_in_space("icbm_ru1_unit4report", truck_radio.origin);



}

trigger_wait_and_set_flag( trigger_targetname )
{
	flag_init( "trigger_" + trigger_targetname );

	trigger = getent( trigger_targetname, "targetname" );
	assertex( isDefined( trigger ), trigger_targetname + " trigger not found" );
	trigger waittill("trigger");
	trigger trigger_off();
	
	flag_set( "trigger_" + trigger_targetname );
}

moveto_driveway()
{
	activate_trigger_with_targetname( "moveout_driveway" );
		
	wait 1;
	price_move01 = getnode("price_move01","script_noteworthy");
	level.price setgoalnode(price_move01);	
	level.price.goalradius = 64 ;
	
	flag_wait("trigger_move01");
	activate_trigger_with_targetname( "move01_color" );	
	
	price_move01 = getnode("price_move01","script_noteworthy");
	level.price setgoalnode(price_move01);	
	level.price.goalradius = 64 ;
	
	flag_wait("trigger_move02");
    activate_trigger_with_targetname( "move02_color" );	
    
	price_move02 = getnode("price_move02","script_noteworthy");
	level.price setgoalnode(price_move02);	
	level.price.goalradius = 64 ;	
	
	flag_wait("trigger_moveto_driveway");
    flag_set("add_driveway");    
    activate_trigger_with_targetname( "moveto_driveway_trigger" );	
       	
	price_driveway = getnode("price_driveway","script_noteworthy");
	level.price setgoalnode(price_driveway);	
	level.price.goalradius = 64 ;	
	
	//AI trigger	
	trigger = getent("regroup_driveway","targetname");
	assertex(isDefined(trigger), "regroup_driveway trigger not found");
	trigger waittill("trigger");		
    trigger trigger_off();
 							
	//iprintlnbold ("Price - Looks like we've got an entry point through that basement door. We'll work room to room from there");
	level.price anim_single_queue( level.price, "keepitquiet" ); 
	wait .5;
	activate_trigger_with_targetname( "moveto_basement" );
	flag_set("driveway_done");

	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
	{
		allies[i].maxsightdistsqrd = 10000*10000;
	}
			
	//STEALTH GAMEPLAY GO!!!!///	  
	//level thread beehive();
	//level thread reinforcements();
	level thread house_assault01();
	level thread price_opens_basement();
	level thread laundryroom_inside();
	level thread firstroom_house01();
	level thread firstroom_clear();
	
	

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

laundryroom_inside()
{
	trigger = getent("laundryroom_inside","targetname");
	assertex(isDefined(trigger), "laundryroom_inside trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
	level thread music();
	level thread second_floor_house1();
	wait 1;
	level.buddies[0] anim_single_queue( level.buddies[0], "roomclear2" );
}


house_assault01()
{
	trigger = getent("laundryroom","targetname");
	assertex(isDefined(trigger), "laundryroom trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();

	flag_set("open_basement");
	flag_wait("enter_basement");
	level thread house01_badguy01();
	price_laundryroom = getnode("price_laundryroom","script_noteworthy");
	level.price setgoalnode(price_laundryroom);	
	level.price.goalradius = 64 ;
		
	autosave_by_name("house01");

}
firstroom_house01()
{	
	trigger = getent("firstroom_house01","targetname");
	assertex(isDefined(trigger), "firstroom_house01 trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
	level thread second_floor_kill_counter();
	level thread bldg1_flr2();

	
	price_firstroom_house01 = getnode("price_firstroom_house01","script_noteworthy");
	level.price setgoalnode(price_firstroom_house01);	
	level.price.goalradius = 64 ;
	wait 1;
	level.price anim_single_queue( level.price, "move" ); 
}

firstroom_clear()
{	
	trigger = getent("firstroom_clear","targetname");
	assertex(isDefined(trigger), "firstroom_clear trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
		
	price_firstfloor_clear = getnode("price_firstfloor_clear","script_noteworthy");
	level.price setgoalnode(price_firstfloor_clear);	
	level.price.goalradius = 64 ;
}

second_floor_house1()
{		
	trigger = getent("load_secondfloor_house01","targetname");
	assertex(isDefined(trigger), "load_secondfloor_house01 trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();	
	
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
	house01_badguy01 enable_cqbwalk();
	house01_badguy01 thread unawareBehavior();
	house01_badguy01 waittill ("death");
	level.buddies[0] anim_single_queue( level.buddies[0], "roomclear" );
	wait 1;
	level.buddies[1] anim_single_queue( level.buddies[1], "roger" );	
}

house01_secondfloor_guys()
{
	house01_bg02 = self dospawn();	
	if(spawn_failed(house01_bg02))
		return;
	house01_bg02 enable_cqbwalk();
	house01_bg02 thread unawareBehavior();
		
}

second_floor_kill_counter()
{
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("house01_bg02","script_noteworthy"), ::spawnerThink, ent);
	ent waittill ("spawned_guy");
	waittillframeend;
	
	waittill_dead(ent.guys);

 

	autosave_by_name("house01_clear");
	wait 1;
	level.buddies[0] anim_single_queue( level.buddies[0], "tangodown" );
	wait 2;
	level.buddies[1] anim_single_queue( level.buddies[1], "roomclear2" );	
	flag_set("house01_clear");
}

bldg1_flr2()
{

	trigger = getent("bldg1_flr2","targetname");
	assertex(isDefined(trigger), "bldg1_flr2 trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();	

}

house01_clear()
{
	flag_wait("house01_clear");
	level thread house02_assault();
	level thread price_opens_door02();
	level thread movein_house02();
	level thread movein_kitchen(); 
	level thread movein_upstairs();
	wait 1;
	//iprintlnbold ("Building clear");
	level.buddies[1] anim_single_queue( level.buddies[1], "building1clear" );
	wait 1; 
	level.buddies[0] anim_single_queue( level.buddies[0], "copythat" );   
	flag_set("clear_bldg1_done");
	wait 1;		
	activate_trigger_with_targetname( "house01_clear_regroup" );
	

}

price_opens_door01()
{
	flag_wait("house01_clear");
	anim_ent = getnode( "price_open_door01_node", "script_noteworthy" );
	anim_ent anim_reach_solo( level.price, "hunted_open_barndoor" );
	anim_ent anim_single_solo( level.price, "hunted_open_barndoor_stop" );
	anim_ent thread anim_loop_solo( level.price, "hunted_open_barndoor_idle", undefined, "stop_idle" );
	
	flag_wait("house01_clear");
	trigger = getent( "price_open_door01_trigger", "targetname" );
	trigger waittill( "trigger" );
	//iprintlnbold ("Price- On me, downstairs.");
	level.price anim_single_queue( level.price, "letsgo" );
	
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

	activate_trigger_with_targetname( "moveout_courtyard" );
	wait 1;
	//level.buddies[0] anim_single_queue( level.buddies[0], "contact" );
	flag_set("move_to_house02_breach");
 
}



price_opens_door02()
{
	flag_wait("move_to_house02_breach");
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
    trigger trigger_off();
    	
	flag_set("attack_house2");
	level thread house02_badguy01();
	flag_wait("breach_house02_done");
		
	price_house02_enter = getnode("price_house02_enter","script_noteworthy");
	level.price setgoalnode(price_house02_enter);	
	level.price.goalradius = 64 ;
}

movein_house02()
{	

	trigger = getent("movein_house02","targetname");
	assertex(isDefined(trigger), "movein_house02 trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();


}

movein_kitchen()
{	
	trigger = getent("movein_kitchen","targetname");
	assertex(isDefined(trigger), "movein_kitchen trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
	wait 1;
	if (level.buddies[1].animname != "frnd")
		level.buddies[1] anim_single_queue( level.buddies[1], "roomclear2" );

	wait 1;	
	price_house02_flr01_clear = getnode("price_house02_flr01_clear","script_noteworthy");
	level.price setgoalnode(price_house02_flr01_clear);	
	level.price.goalradius = 64 ;
}	

movein_upstairs()
{	
	trigger = getent("movein_upstairs","targetname");
	assertex(isDefined(trigger), "movein_upstairs trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
	
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
		allies[i] endUnawareBehavior();
	
	//level.buddies[0] anim_single_queue( level.buddies[0], "roomclear" );
	level thread h2_floor2_kill_counter();
	level thread rescue_breach();
	level thread spawn_mark();
	level thread rescue_entered_wait();
	level thread moveto_tower();
	level thread chopper_gone();

	wait 1;	
	price_house02_flr02_clear = getnode("price_house02_flr02_clear","script_noteworthy");
	level.price setgoalnode(price_house02_flr02_clear);	
	level.price.goalradius = 64 ;
	//ADD DET CORD BREACH
	//flag_wait("ready_for_breach");
	       
    trigger = getent("kitchen2","targetname");
    assertex(isDefined(trigger), "kitchen2 trigger not found");
    trigger trigger_off();
}

house02_badguy01()
{

	h2bd01_spawner = getent("house02_badguy01","script_noteworthy");
	house02_badguy01 = h2bd01_spawner dospawn();	
	if(spawn_failed(house02_badguy01))
		return;
	house02_badguy01 enable_cqbwalk();
	house02_badguy01 thread unawareBehavior();
	house02_badguy01 waittill ("death");
	wait 1;
	if (level.buddies[0].animname != "frnd")	
		level.buddies[0] anim_single_queue( level.buddies[0], "tangodown" );

}

house02_secondfloor_guys()
{
	house02_bd02 = self dospawn();	
	if(spawn_failed(house02_bd02))
		return;
	house02_bd02.pacifist = true;
	house02_bd02 enable_cqbwalk();
	//house02_bd02 thread unawareBehavior();
		
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

	if (level.buddies[0].animname != "frnd")	
		level.buddies[0] anim_single_queue( level.buddies[0], "allclear" );
		level.buddies[1] anim_single_queue( level.buddies[1], "building2secured" );
	autosave_by_name("house02_clear");
	activate_trigger_with_targetname( "grigs_scene" );
	
	price_grigs = getnode("price_grigs","script_noteworthy");
	level.price setgoalnode(price_grigs);	
	level.price.goalradius = 64 ;	
	
	wait 1;
	//iprintlnbold ("Grigsby -Bout damn time... I was starting to think you guys were gonna leave me behind");
	level.mark anim_single_queue( level.mark, "leavemebehind" );
	//iprintlnbold ("Price - Yeah, that was the plan, but your sexy ass had all the C4. You ok?");
	//level.price anim_single_queue( level.price, "wastheplan" );
	//iprintlnbold ("Grigsby - Yeah I'm good to go.");
	//level.mark anim_single_queue( level.mark, "goodtogo" );
	

	//Price - Got Grigsby
	level.price anim_single_queue( level.price, "gotgriggs" );
	
	level.mark set_force_color( "b" );
	level.price set_force_color( "b" );
	
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
	{
		allies[i].pacifist = false;
		allies[i] disable_cqbwalk();
		allies[i] set_force_color("b");
	}
	activate_trigger_with_targetname( "house2_clear" );	
	wait 1;
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
	level.mark enable_cqbwalk();
	level.mark.ignoreme = true;
	level.mark thread magic_bullet_shield();
	level.mark.animname = "mark";
	//thread setup_mark();
}

rescue_breach()
{
	trigger = getent ("start_breach", "targetname");
	trigger waittill("trigger");
	trigger trigger_off();
	
	level thread trigger_wait_and_set_flag( "moveout_tower" );
	level thread trigger_wait_and_set_flag( "player_in_chopper_area" );	
	
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



}

breach_dialog(eVolume)
{
	//level.price playsound ( "armada_pri_targetbuildingleftbreach" );
	//wait 3;
	//level.breacher playsound ( "armada_gm4_withyou" );
	
	//trigger_volume_room01 waittill("trigger");
	eVolume waittill ("detpack_about_to_blow");
	
	//wait 2;
	//level.price playsound("icbm_us_lead_move" ); 

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
	flag_wait("trigger_moveout_tower");

	activate_trigger_with_targetname( "color_b21_trigger" );
	//Price - lets go
	level.price anim_single_queue( level.price, "letsgo" );
	wait 0.5;
	level.buddies[0] anim_single_queue( level.buddies[0], "yougotit" ); 

	//AI trigger
	trigger = getent("choppers_inbound","targetname");
	assertex(isDefined(trigger), "choppers_inbound trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
	flag_wait("trigger_player_in_chopper_area");
	
	activate_trigger_with_targetname( "choppers" );
	autosave_by_name("chopper_flyover");
	wait 3;
	//iprintlnbold ("Marine1 - Enemy helicopters!");
	level.buddies[0] anim_single_queue( level.buddies[0], "enemyhelicopters" );
	//iprintlnbold ("Price - Move!");
	level.price anim_single_queue( level.price, "movin" ); 
	
}

chopper_gone()
{
	flag_wait("house02_clear");
	trigger = getent("chopper_gone","targetname");
	assertex(isDefined(trigger), "chopper_gone trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
	level thread tower();

	
}

tower_nag()
{
	
	level endon ("tower_destroyed");
	while (1)
	{
		wait 50;
		//iprintlnbold ("Price - Jackson DO IT!");
		level.price anim_single_queue( level.price, "doit" );
    } 
}



tower()
{	

	//iprintlnbold ("Price - Team Two, what's your status over?");
	level.price anim_single_queue( level.price, "status" );
	wait 0.2;
	//iprintlnbold ("Marine4 - Team Two in position at the perimeter. Waiting on you to kill the power, over.  ");
	level.price anim_single_queue( level.price, "killthepower" );
	//iprintlnbold ("Price - Roger. Jackson. Griggs. Plant the charges. Go");
	level.price anim_single_queue( level.price, "jackgriggsplant" );
	
	trigger = getent("start_planting","targetname");
	assertex(isDefined(trigger), "start_planting trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
	
	tower = getent("tower", "targetname");
	tower.multiple_c4 = true;
	tower maps\_c4::c4_location( "tag_origin", (-185.75, -178, 57.87), (288, 270, 0) );
	tower maps\_c4::c4_location( "tag_origin", (184.3, -178.1, 57.9), (288, 270, 0) );
	
	level waittill( "c4_in_place" );
	level waittill( "c4_in_place" );

	level thread tower_interface();	
	level thread c4_set();
	
	tower waittill( "c4_detonation" );

	tower setmodel("com_powerline_tower_destroyed");
	tower useanimtree(level.scr_animtree[ "tower_explosion" ]);
	tower setanim(level.scr_anim[ "tower" ][ "explosion" ]);
	
	
	level.towerExplosion_fx	= loadfx( "explosions/large_vehicle_explosion" );
	playfx(level.towerExplosion_fx, tower.origin);
	
	tower thread play_sound_in_space( "building_explosion3", tower gettagorigin( "tag_origin" ) );
	
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

c4_set()
{

	activate_trigger_with_targetname( "c4_planted" );
	
	//iprintlnbold ("Grigsby - Charges set. Everyone get clear");
	level.mark anim_single_queue( level.mark, "chargesset" );
	
	tower = getent("tower", "targetname");
	dist = length( level.player.origin - tower.origin );
	//% buffer safe blast distance
	while( dist <= ( level.towerBlastRadius +128 ) && !flag( "tower_destroyed" ))
	{
		dist = length( level.player.origin - tower.origin );
		wait 0.05;	
	}
	
	
	if ( !flag( "tower_destroyed" ))
	{	
		//iprintlnbold ("Price - Jackson DO IT!");
		level.price anim_single_queue( level.price, "doit" );
	}
	
	level thread tower_nag();
	flag_wait("tower_destroyed");

	//kill lights
	wait 1;
	activate_trigger_with_targetname( "move_to_watch" );
	wait 7;
	//iprintlnbold ("Price - Team Two, the tower's down and the power's out. Twenty seconds.");
	level.price anim_single_queue( level.price, "towersdown" );

	wait 0.5;
	//iprintlnbold ("Marine4 - Roger. We're breaching the perimeter. Standby.");
	level.price anim_single_queue( level.price, "breachingperimeter" );
	wait 1;
	//iprintlnbold ("Grigsby - Backup power in ten seconds…");
	level.mark anim_single_queue( level.mark, "backuppower" );
	wait 1;
	//iprintlnbold ("Marine4 - Standby");
	level.price anim_single_queue( level.price, "standby" );
	wait 2;
	//iprintlnbold ("Grigsby - Five seconds…");
	level.mark anim_single_queue( level.mark, "fiveseconds" );
	wait 1;
	//iprintlnbold ("Marine4 - Ok. We're through. Team One, meet us at the rally point");
	level.price anim_single_queue( level.price, "rallypoint" );
	//iprintlnbold ("Price - Roger Team Two, we're on our way. Out");
	level.price anim_single_queue( level.price, "onourway" );
	//iprintlnbold ("Price - Come on, let's go!");
	level.price anim_single_queue( level.price, "letsgo" );
	activate_trigger_with_targetname( "move_to_fence01" );
	flag_set("tower_blown");
	autosave_by_name("tower_destroyed");
	level thread cut_fence01();
	level thread cut_fence02();
	level thread old_base();
	wait 0.5;
	//iprintlnbold ("Grigsby - Backup power's online. Damn that was close!");
	level.mark anim_single_queue( level.mark, "poweronline" );
	wait 10;
	//level thread fence1_nag();


		
}	


fence1_nag()
{
	level endon ("cut_fence1");
	while (1)
	{
		wait 10;
		iprintlnbold ("Price - Regroup! Regroup on my position!"); 	
       	//level.price anim_single_queue( level.price, "move" );
    }   		
}


cut_fence01()
{

	trigger = getent("fence01","targetname");
	assertex(isDefined(trigger), "fence01 trigger not found");
	trigger waittill("trigger");
	flag_set("cut_fence1");
	//iprintlnbold ("Price - Grigsby, Haggerty chop the fence");
	//level.price anim_single_queue( level.price, "doit" );
	//chainlink fence cutting anims
	wait 2;
	fence01_clip = getent("fence01_clip","targetname");
	fence01_clip connectpaths();
	fence01_clip delete();
	
	iprintlnbold ("fence is cut");
	//peeps move through
	//iprintlnbold ("Price - C'mon lets go! Move it!");
	level.price anim_single_queue( level.price, "move" );
	wait 0.5;
	activate_trigger_with_targetname( "fence01_moveout" );
	
	trigger = getent("move_to_oldbase01","targetname");
	assertex(isDefined(trigger), "move_to_oldbase01 trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
	//iprintlnbold ("Marine1 - Enemy helicopters!");
	level.buddies[0] anim_single_queue( level.buddies[0], "enemyhelicopters" );
	
	trigger = getent("move_to_oldbase02","targetname");
	assertex(isDefined(trigger), "move_to_oldbase02 trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();

	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
	{
		allies[i] enable_cqbwalk();
		allies[i].pacifist = true;
	}
	
}

//START BASE TO JUMP TO THE OLD BASE AREA
base_start()
{
	VisionSetNaked( "icbm_sunrise3");
	thread stopSnow();
	setExpFog( 200, 60000, .8, .65, .5, 0 );
	level thread cut_fence02();
	level thread old_base();
	level thread setupPlayer();
	base_start = getent( "base_start", "targetname" );
	level.player setOrigin( base_start.origin );
	level.player setPlayerAngles( base_start.angles );
	base_start_spawners = getentarray("base_start_spawners", "targetname");
	array_thread( base_start_spawners, maps\_spawner::spawn_ai );
	 
	level thread objectives();
	level thread small_objectives();
	flag_set( "regroup01_done" );
	flag_set("clear_bldg1_done");
	flag_set("grigs_todo");
	flag_set( "house02_clear" );
	flag_set( "tower_blown" );

	
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
		{
		allies[i].pacifist = true;
		allies[i] enable_cqbwalk();
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

//START TOWER
tower_start()
{
	VisionSetNaked( "icbm_sunrise2");
	thread stopSnow();
	setExpFog( 200, 12000, .27, .25, .35, 0 );
	

	level thread setupPlayer();
	tower_start = getent( "tower_start", "targetname" );
	level.player setOrigin( tower_start.origin );
	level.player setPlayerAngles( tower_start.angles );
	tower_start_spawners = getentarray("tower_start_spawners", "targetname");
	array_thread( tower_start_spawners, ::add_spawn_function, ::init_ally );
	array_thread( tower_start_spawners, maps\_spawner::spawn_ai );
	 
	level thread objectives();
	level thread small_objectives();
	level thread tower();
	flag_set( "regroup01_done" );
	flag_set("clear_bldg1_done");
	flag_set("grigs_todo");
	flag_set( "house02_clear" );

		
	level thread magic_buddies();

	price3_spawner = getent("price3","script_noteworthy");
	level.price = price3_spawner dospawn();
	if(spawn_failed(level.price))
		return;
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	level.price thread init_ally();
	
	mark3_spawner = getent("mark3","script_noteworthy");
	level.mark = mark3_spawner dospawn();
	
	if(spawn_failed(level.mark))
		return;
	assertex(isdefined(level.mark),"Mark not getting defined!");
	level.mark.animname = "mark";
	level.mark thread magic_bullet_shield();	
	level.mark thread init_ally();

	activate_trigger_with_targetname( "color_b21_trigger" );
	
}

init_ally()
{
	self.pacifist = true;
	self enable_cqbwalk();
	self setthreatbiasgroup( "allies" );
	self set_force_color( "b" );
}

//START TOWER
launch_start()
{
	VisionSetNaked( "icbm_sunrise4");
	thread stopSnow();
	setExpFog( 200, 15000, .169, .168, .244, 0 );
	level thread trigger_wait_and_set_flag( "lift_off" );
	level thread setupPlayer();
	launch_start = getent( "launch_start", "targetname" );
	level.player setOrigin( launch_start.origin );
	level.player setPlayerAngles( launch_start.angles );
	activate_trigger_with_targetname( "base_clear_moveout" );
	launch_start_spawners = getentarray("launch_start_spawners", "targetname");
	array_thread( launch_start_spawners, ::add_spawn_function, ::init_ally );
	array_thread( launch_start_spawners, maps\_spawner::spawn_ai );
	 
	level thread objectives();
	level thread small_objectives();
	
	level thread missile_launch();
	level thread missile_launch01();
	level thread missile_launch02();	
	level thread meetup_second_squad();
	
	flag_set( "regroup01_done" );
	flag_set("clear_bldg1_done");
	flag_set("grigs_todo");
	flag_set( "house02_clear" );
	flag_set("tower_blown");
	flag_set( "bmp_dead" );
	flag_set("meetup_todo");
	//flag_set("trigger_lift_off");
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
		{
		allies[i].pacifist = true;
		allies[i] enable_cqbwalk();
		allies[i] setthreatbiasgroup( "allies" );
		allies[i] set_force_color( "b" );
		}
	level thread magic_buddies();

	price4_spawner = getent("price4","script_noteworthy");
	level.price = price4_spawner dospawn();
	if(spawn_failed(level.price))
		return;
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	level.price set_force_color( "b" );
	
	mark4_spawner = getent("mark4","script_noteworthy");
	level.mark = mark4_spawner dospawn();
	
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
	
	//iprintlnbold ("Marine4 - Team One, this is Team Two.  Three trucks packed with shooters are headed your way.");
	level.price anim_single_queue( level.price, "truckswithshooters" );
	wait 0.5;
	
	//iprintlnbold ("Price - Copy. We're entering the old base now. Standby.");
	level.price anim_single_queue( level.price, "approachingbase" );
	//iprintlnbold ("Price - Cut it");
	//level.price anim_single_queue( level.price, "movin" );
	//chainlink fence cutting anims
	
	level.price disable_ai_color();
	level.mark disable_ai_color();
	
	price_oldbase = getnode("price_oldbase","script_noteworthy");
	level.price setgoalnode(price_oldbase);	
	level.price.goalradius = 64 ;

	mark_oldbase = getnode("mark_oldbase","script_noteworthy");
	level.mark setgoalnode(mark_oldbase);	
	level.mark.goalradius = 64 ;
	activate_trigger_with_targetname( "fence02_moveout" );
	

	
}

old_base()
{
	trigger = getent("entered_oldbase","targetname");
	assertex(isDefined(trigger), "entered_oldbase trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
	level thread bmp();	
	level thread bmp_road_trigger();
	trigger = getent("incoming_oldbase","targetname");
	assertex(isDefined(trigger), "incoming_oldbase trigger not found");
	trigger waittill("trigger");
	level thread start_area01();
	level thread start_area02();
	level thread area2_preattackers();
	level thread master_base_control();
	trigger trigger_off();
	
	//iprintlnbold ("Marine1 - I have a visual on the trucks. There's a shitload of troops sir.");
	level.buddies[0] anim_single_queue( level.buddies[0], "haveavisual" );	
	autosave_by_name("base_fight");
	level.mark set_force_color( "b" );
	level.price set_force_color( "b" );	
	
	activate_trigger_with_targetname( "old_base_flank" );
	//iprintlnbold ("Price - All right squad, you know the drill.  Griggs, you're with Jackson. Haggerty, on me. Move.");
	level.price anim_single_queue( level.price, "youknowdrill" );	
	battlechatter_on( "allies" );	
	battlechatter_on( "axis" );
	wait 3;
	
	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
	{
		allies[i] disable_cqbwalk();
		allies[i].pacifist = false;
	}
	
	
	//COUNT UP BUDDIES
	level.buddies = getentarray("buddies", "script_noteworthy");       
  	for(i=0;i<level.buddies.size;i++)
    {
               if(isalive(level.buddies[i]))
               {
				level.buddies[i] thread stop_magic_bullet_shield();

               }
    }
    
}

reinforcements_think()

{
	self waittill( "trigger" );           
	guys = get_force_color_guys( "allies", "b" );	
	reinforcements_needed =( 2 - guys.size );
	
	spawners = getentarray( "buddie_replace", "targetname" );	
	for( i=0;i<reinforcements_needed;i++ )
	{
		guy = spawners[ i ] maps\_spawner::spawn_ai();
	}
	

}




start_area01()
{		
	trigger = getent("start_area01","targetname");
	assertex(isDefined(trigger), "start_area01 trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
	//iprintlnbold ("start area one");
	flag_set("area1_started");
	
	level thread setup_sortie();
	level thread attacker_wave01();
	level thread attacker_wave01b();
	level thread area1_flankers_counter();
	level thread kill_area01_spawns();

	//color triggers
	level thread area1_trigger1();
	level thread area1_trigger2();
	level thread load_bldg02();
	level.player playsound ( "icbm_gm3_enemyinsight" );


}	

bmp()
{

	flag_wait("bmp_fire");

	bmp = getent("base_bmp","targetname");
	bmp thread vehicle_turret_think();
	bmp.script_turretmg = true;
	bmp thread vehicle_c4_think();
	bmp waittill ("death");	
	//wait till dead
	flag_set( "bmp_dead" );
	autosave_by_name("bmp_dead");
	

}

bmp_road_trigger()
{
	trigger = getent("bmp_fire","targetname");
	assertex(isDefined(trigger), "bmp_fire trigger not found");
	trigger waittill("trigger");
	flag_set("bmp_fire");
	//iprintlnbold ("BMP starts firing MG");
	level thread base_fillers();
	level thread trigger_wait_and_set_flag( "play_leaving_base" );
	level thread trigger_wait_and_set_flag( "lift_off" );
	level thread meetup_second_squad();
	level thread fastrope_guys_spawn();
}

vehicle_c4_think()
{

	iEntityNumber = self getentitynumber();	
	self maps\_c4::c4_location( "rear_hatch_open_jnt_left", (0, -33, 10), (0, 90, -90) );
	self maps\_c4::c4_location( "tag_origin", (129, 0, 35), (0, 90, 144) );
	
	self waittill( "c4_detonation" );

	/*-----------------------
	C4 STUNS AI CLOSEBY
	-------------------------*/			
	AI = get_ai_within_radius(512, self.origin, "axis");
	if ( (isdefined(AI)) && (AI.size > 0) )
		array_thread(AI, ::AI_stun, .75);

	self thread vehicle_death(iEntityNumber);
}

vehicle_death(iEntityNumber)
{
	self notify("clear_c4");
	setplayerignoreradiusdamage(true);
	
	/*-----------------------
	SECONDARY EXPLOSIONS
	-------------------------*/		

//	wait ( randomfloatrange(0.5, 1) );
//	thread play_sound_in_space( "explo_metal_rand", self.origin );
//	playfxontag( level._effect["c4_secondary_explosion_01"], self, sC4tag );
//	radiusdamage(self.origin, 128, level.maxBMPexplosionDmg, level.minBMPexplosionDmg);
//
//	wait ( randomfloatrange(1, 1.5) );
//	thread play_sound_in_space( "explo_metal_rand", self gettagorigin( "tag_turret" ) );
//	playfxontag( level._effect["c4_secondary_explosion_02"], self, "tag_turret" );
//	radiusdamage(self.origin, 128, level.maxBMPexplosionDmg, level.minBMPexplosionDmg);
//	wait ( randomfloatrange(0.55, .75) );
	
	/*-----------------------
	FINAL EXPLOSION
	-------------------------*/		
	earthquake (0.6, 2, self.origin, 2000);	
	self notify( "death" );
	thread play_sound_in_space( "exp_armor_vehicle", self gettagorigin( "tag_turret" ) );
	AI = get_ai_within_radius(1024, self.origin, "axis");
	if ( (isdefined(AI)) && (AI.size > 0) )
		array_thread(AI, ::AI_stun, .85);

	/*-----------------------
	ONLY TOKEN DAMAGE INFLICTED ON PLAYER
	-------------------------*/
	radiusdamage(self.origin, 256, level.maxBMPexplosionDmg, level.minBMPexplosionDmg);
	thread player_token_vehicle_damage(self.origin);
	thread autosave_by_name("bmp_" + iEntityNumber + "_destroyed");	
	
	wait (2);
	setplayerignoreradiusdamage(false);
}

player_token_vehicle_damage(org)
{
	if ( distancesquared(org,level.player.origin) <= level.playerVehicleDamageRangeSquared )
		level.player dodamage(level.player.health / 3, (0,0,0));
}
AI_stun(fAmount)
{
	self endon ("death");
	if ( (isdefined(self)) && (isalive(self)) && (self getFlashBangedStrength() == 0) )
		self setFlashBanged(true, fAmount);
}

get_ai_within_radius(fRadius, org, sTeam)
{
	if (isdefined(sTeam))
		ai= getaiarray(sTeam);
	else
		ai= getaiarray();
	
	aDudes = [];
	for(i=0;i<ai.size;i++)
	{
		if ( distance(org,self.origin) <= fRadius)
			array_add(aDudes, ai[i]);
	}
	return aDudes;
}

base_fillers()
{
	//Guys entering the front of the base
	trigger = getent("base_fillers", "target");
	trigger notify("trigger");
	   

}



area2_preattackers()
{
	trigger = getent("area2_preattackers","targetname");
	assertex(isDefined(trigger), "area2_preattackers trigger not found");
	trigger waittill("trigger");
	//flag_set("area2_preattackers");
	//iprintlnbold ("area2_preattackers_spawned");
	level thread attacker_wave03();

}
attacker_wave01()
{
	//guys for behind the container
	trigger = getent("base_attackers01", "target");
	trigger notify("trigger");
	   
}

attacker_wave01b()
{
	//guy to the middel area
	trigger = getent("base_attackers01b", "target");
	trigger notify("trigger");

}

area1_flankers()
{

	area1_flankers = self dospawn();	
	if(spawn_failed(area1_flankers))
		return;
		
}

area1_flankers_counter()
{
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("area1_flankers","targetname"), ::spawnerThink, ent);
	array_thread(getentarray("area1_flankers","targetname"), ::area1_flankers);


}

area1_trigger1()
{
	//first color tigger in area one
	trigger = getent("area1_trigger1","targetname");
	assertex(isDefined(trigger), "area1_trigger1 not found");
	trigger waittill("trigger");
	trigger trigger_off();
	level.player playsound ( "icbm_gm1_contact" );

}

area1_trigger2()
{
	//second color trigger in area one
	trigger = getent("area1_trigger2","targetname");
	assertex(isDefined(trigger), "area1_trigger2 not found");
	trigger waittill("trigger");
	trigger trigger_off();

}


load_bldg02()
{
	trigger = getent("load_bldg02","targetname");
	assertex(isDefined(trigger), "load_bldg02 trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
	level thread attacker_wave02();
	level thread cross_road();
	level thread enter_crossroad_bldg();
	//level.buddies[0] anim_single_queue( level.buddies[0], "building1clear" );	

}

attacker_wave02()
{
	//guys in the cross road building
	trigger = getent("base_attackers02", "target");
	trigger notify("trigger");
	   

}

kill_area01_spawns()
{
	flag_wait("kill_area01_spawners");
	//kill these spawners
	//attacker_wave01()
	//attacker_wave01b()
	//attacker_wave02()
	activate_trigger_with_targetname( "kill_spawners01" );
	wait 1;
	enemies = getentarray ("roortop_guys1","script_noteworthy");	
	for( i = 0 ; i < enemies.size ; i++ )
		enemies[ i ] dodamage( enemies[ i ].health + 100 , enemies[ i ].origin );

}

kill_area02_spawns()
{
	flag_wait("bmp_dead");
	//kill these spawners
	//attacker_wave04();
	//base_flankers01();
	//base_fillers();
	activate_trigger_with_targetname( "kill_spawners02" );	
	wait 1;
	enemies = getentarray ("roortop_guys2","script_noteworthy");	
	for( i = 0 ; i < enemies.size ; i++ )
		enemies[ i ] dodamage( enemies[ i ].health + 100 , enemies[ i ].origin );

}

enter_crossroad_bldg()
{
	enter_crossroad_bldg = getent("enter_crossroad_bldg","targetname");
	assertex(isDefined(enter_crossroad_bldg), "enter_crossroad_bldg not found");
	enter_crossroad_bldg reinforcements_think();
	enter_crossroad_bldg trigger_off();

}

cross_road()
{
	area_trigger = getent("kill_counter_volume","targetname");
	trigger = getent("cross_road","targetname");
	assertex(isDefined(trigger), "cross_road not found");
	trigger waittill("trigger");
	trigger trigger_off();

	flag_set("bmp_fire");	
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

	level.player playsound ( "icbm_gm1_allclear" );
	activate_trigger_with_targetname( "move_to_cross_road" );
	wait 3;	
	iprintlnbold ("Price - We have to flank around that damn BMP, lets go!!");
	wait 1;
	activate_trigger_with_targetname( "cross_road_go" );
	level.price anim_single_queue( level.price, "letsgo" );
	//level thread path_blocker();

}	

path_blocker()
{
	blocker = getent("path_blocker","targetname");
	flag_wait("unblock_path");
	blocker connectpaths();
	blocker delete();
}

start_area02()
{
	trigger = getent("start_area02","targetname");
	assertex(isDefined(trigger), "start_area02 trigger not found");
	trigger waittill("trigger");
	flag_set("area2_started");
	trigger trigger_off();
	//iprintlnbold ("started area two");
	
	autosave_by_name("base_second_area");
	
	level thread attacker_wave03();
	//level thread cleanup_first_area();
	trigger = getent("spawn_wave4","targetname");
	assertex(isDefined(trigger), "spawn_wave4 trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
	level thread attacker_wave04();
	level thread base_flankers01();
	level thread base_last_bldg();
	level thread play_leaving_base();
	level thread kill_area02_spawns();
	
	//color triggers
	level thread area2_trigger2();
	level thread area2_trigger3();
	level thread area2_trigger4();


}

master_base_control()
{
	flag_wait("area2_started");
	trigger = getent("start_area01","targetname");
	assertex(isDefined(trigger), "start_area01 trigger not found");
	trigger trigger_off();
	//iprintlnbold ("area one off");
	flag_set("kill_area01_spawners");


}


attacker_wave03()
{
	//area2 pre-attckers
	trigger = getent("base_attackers03", "target");
	trigger notify("trigger");
	
}

base_cleaner()
{
		 
	if ( !flag( "bmp_dead" ) )
	level thread bmp_nag();
	
	axis = getaiarray("axis");
	for(i = 0; i < axis.size; i++)
	{
		if ( distance(axis[i].origin, level.player.origin) > 2048)
		{
			axis[i] doDamage (axis[i].health+5, axis[i].origin);
			continue;
		}
		
		axis[i] setgoalentity(level.player);
		axis[i].goalradius = 128;
	}
	// count up axis and waittill dead
	while (1)
	{
		axis = getaiarray("axis");
		if (axis.size == 0)
		{
			break;
		}
		wait .05;
	}  

}

attacker_wave04()
{
	//RPD guys
	trigger = getent("base_attackers04", "target");
	trigger notify("trigger");
	   

}



area2_trigger2()
{
	trigger = getent("area2_trigger2","targetname");
	assertex(isDefined(trigger), "area2_trigger2 not found");
	trigger waittill("trigger");
	trigger trigger_off();
	//level.buddies[0] anim_single_queue( level.buddies[0], "roomclear" );

}

area2_trigger3()
{
	trigger = getent("area2_trigger3","targetname");
	assertex(isDefined(trigger), "area2_trigger3 not found");
	trigger waittill("trigger");
	trigger trigger_off();
	//level.buddies[0] anim_single_queue( level.buddies[0], "roomclear" );

}

area2_trigger4()
{
	trigger = getent("area2_trigger4","targetname");
	assertex(isDefined(trigger), "area2_trigger4 not found");
	trigger waittill("trigger");
	trigger trigger_off();
	
	if (flag("bmp_dead"))
	{
		return;
	}
	
	iprintlnbold ("Price - Jackson grab an RPG and take that BMP out!!");
	flag_set("add_kill_bmp");
	//level.buddies[0] anim_single_queue( level.buddies[0], "roomclear" );

}

base_flankers01()
{
	trigger = getent("base_flankers01_spawn","targetname");
	assertex(isDefined(trigger), "base_flankers01_spawn trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
	level thread flanker_hint();

	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("base_flankers01","targetname"), ::spawnerThink, ent);
	array_thread(getentarray("base_flankers01","targetname"), ::selfdospawn);
	
	ent waittill ("spawned_guy");
	waittillframeend;
	waittill_dead(ent.guys);
	
	autosave_by_name("flanker_save");
	activate_trigger_with_targetname( "flank_defended" );
	
	wait 2;
	level.player playsound ( "icbm_gm2_building2secured" );
	wait 2;
	level.price anim_single_queue( level.price, "movin" );


}

flanker_hint()
{
	wait 2;
	iprintlnbold ("Price - Watch out behind us!!");
	//level.buddies[0] anim_single_queue( level.buddies[0], "allclear" );

}


base_last_bldg()
{
	trigger = getent("base_last_bldg","targetname");
	assertex(isDefined(trigger), "base_last_bldg trigger not found");
	trigger waittill("trigger");
	trigger trigger_off();
	level thread base_cleaner();
	flag_set("in_last_bldg");
	///if bmp dead	
	flag_wait("bmp_dead");


}	

bmp_nag()
{
	
	level endon ("bmp_dead");
	while (1)
	{
		wait 50;
		iprintlnbold ("Price - Jackson, take out that BMP!"); 	
       	//level.price anim_single_queue( level.price, "move" );
    } 
}

fastrope_guys_spawn()
{
	flag_wait("in_last_bldg");
	flag_wait("bmp_dead");
	wait 8;
	activate_trigger_with_targetname( "fastrope_spawn" );
	wait 7;
	level.player playsound ( "icbm_gm1_enemyhelicopters" );
	wait 1;
	level.price anim_single_queue( level.price, "slicksinbound" ); 

}

play_leaving_base()
{	
	flag_wait("bmp_dead");
	wait 5;
	//iprintlnbold ("Price - Clear, move out");
	level.price anim_single_queue( level.price, "letsgo" );
	wait 1;
	activate_trigger_with_targetname( "base_clear_regroup" );
	
	flag_wait("trigger_play_leaving_base");
	
	autosave_by_name("leave_base");	

	activate_trigger_with_targetname( "ambush_base" );

				
	axis = getaiarray("axis");
	for(i = 0; i < axis.size; i++)
	{
		axis[i] enable_cqbwalk();
		axis[i].goalradius = 1024;
		axis[i].goalheight = 512;
	}
	waittill_dead(axis);
	
	
	activate_trigger_with_targetname( "base_clear_moveout" );
	
	//need to wait for all axis to be dead		
	//flag_wait(base_ambush_clear");
	level.player playsound ( "icbm_gm1_tangodown" );
	wait 3;
	level.player playsound ( "icbm_gm1_allclear" );
	
	autosave_by_name("base_done");	
	
	level thread missile_launch();
	level thread missile_launch01();
	level thread missile_launch02();

	
	
}	



missile_launch()
{

	trigger = getent("buddies_at_launch","targetname");
	assertex(isDefined(trigger), "buddies_at_launch trigger not found");
	trigger waittill("trigger");
	
	flag_wait("trigger_lift_off");
					
	//FIRE!!
	flag_set("launch_02");
	thread LaunchVision();
	wait 3;
	//iprintlnbold ("Grigsby - What the hell…");
	level.player playsound ( "icbm_gm1_whatthe" );
	wait 1;
	//iprintlnbold ("Marine01 - Uhh we got a problem here!...");
	level.mark anim_single_queue( level.mark, "problemhere" );	
	//icbm_missile thread maps\_utility::playSoundOnTag("parachute_land_player");

	//missile01_start waittill ("movedone");
	//icbm_missile delete();
	
	flag_set("launch_01");
	//iprintlnbold ("Price - Delta One X-Ray, we have a missile launch, I repeat we have a missile");
	level.price anim_single_queue( level.price, "onemissile" );
	wait 1;
	//iprintlnbold ("Grigsby - There's another one!");
	level.mark anim_single_queue( level.mark, "anotherone" );
	//iprintlnbold ("Price - Delta One X-Ray - we have two missiles in the air over!");
	level.price anim_single_queue( level.price, "twomissiles" );
	wait 0.5;
	//iprintlnbold ("HQ - Uh…roger Bravo Six, we're working on getting the abort codes from the Russians. There's a telemetry station inside the facility. Get your team in there now.");
	level.price anim_single_queue( level.price, "gettingabortcodes" );
	activate_trigger_with_targetname( "moveto_ending" );
	flag_set("lift_off_scene_done");
	//iprintlnbold ("Price - Roger that. Movin'!");
	level.price anim_single_queue( level.price, "movin" );


	
}

missile_launch01()
{
	missile01_start = getent ("missile01_start","targetname");
	missile01_end = getent ("missile01_end","targetname");
	icbm_missile01 = getent ("icbm_missile01","targetname");
	flag_wait("launch_01");	
	//FIRE!!
	exploder(1);
	icbm_missile01 linkto (missile01_start);
	missile01_start moveto (missile01_end.origin,50,10,0);	
	//icbm_missile thread maps\_utility::playSoundOnTag("parachute_land_player");
	playfxontag( level._effect["smoke_geotrail_icbm"], icbm_missile01, "tag_nozzle" );
	missile01_start waittill ("movedone");
	icbm_missile01 delete();

}

missile_launch02()
{
	missile02_start = getent ("missile02_start","targetname");
	missile02_end = getent ("missile02_end","targetname");
	icbm_missile02 = getent ("icbm_missile02","targetname");
	flag_wait("launch_02");	
	//FIRE!!
	exploder(2);
	icbm_missile02 linkto (missile02_start);
	missile02_start moveto (missile02_end.origin,50,10,0);	
	//icbm_missile thread maps\_utility::playSoundOnTag("parachute_land_player");
	playfxontag( level._effect["smoke_geotrail_icbm"], icbm_missile02, "tag_nozzle" );
	missile02_start waittill ("movedone");
	icbm_missile02 delete();

}

LaunchVision()
{
	VisionSetNaked( "icbm_launch", 4 );	
	wait 10;
	VisionSetNaked( "icbm_sunrise4", 6 );
}


meetup_second_squad()
{

	squad_02 = getentarray("squad_02", "script_noteworthy");
	array_thread( squad_02, ::second_squad_guys );
	
	
	//battlechatter_off( "allies" );	
	//battlechatter_off( "axis" );

	flag_wait("lift_off_scene_done");
	trigger = getent("buddies_at_end","targetname");
	assertex(isDefined(trigger), "buddies_at_end trigger not found");
	trigger waittill("trigger");
	
	trigger = getent("second_squad_trigger","targetname");
	assertex(isDefined(trigger), "second_squad_trigger trigger not found");
	trigger waittill("trigger");

	wait 0.5;
	//iprintlnbold ("Marine04 - Shit's hit the fan now");
	level.mark anim_single_queue( level.mark, "itsonnow" );
	//iprintlnbold ("Price - You're tellin' me…. Let's go! We gotta move!");
	level.price anim_single_queue( level.price, "youretellinme" );

	flag_set("level_done");
	wait 1;
	missionsuccess( "launchfacility_a", false );

}

second_squad_guys()
{
	second_squad_spawn = self stalingradspawn();	
	if(spawn_failed(second_squad_spawn))
		return;	
	second_squad_spawn.pacifist = true;
	second_squad_spawn.ignoreme = true;

			
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
		allies[i] disable_cqbwalk();
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
				level.buddies[i].animname = "generic";
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
	beehive_spawn disable_cqbwalk();
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
   	//level.player anim_single_queue( level.player, "contact" );
   	wait 5;
   	flag_set( "sound alarm" );
}

unawareBehavior()
{
   	self endon ("death");
   	self endon ("end_unaware_behavior");
   	
   	self.lastFoughtTime = -9999999;
   	
   	self.preUnawareBehaviorSightDistSqrd = self.maxSightDistSqrd;
   	self.maxSightDistSqrd = 600 * 600;
	
	otherteam = "allies";
	if ( self.team == "allies" )
		otherteam = "axis";
	
	while( 1 )
	{
		self.pacifist = true;
		debugUnawareBehavior( "unaware of enemy" );
		
		// wait until we see an enemy
		self waitUntilAwareOfEnemy();
		
		// we've seen someone!
		debugUnawareBehavior( "i think i see an enemy! waiting..." );
		self.pacifist = false;
		
		// alert our friends.
		debugUnawareBehavior( "telling friends about enemies while i fight" );
		self thread alertFriendsAboutEnemies();
		self waitUntilHaventFoughtForAWhile();
		self notify("stop_alerting_friends_about_enemies");
	}
}

endUnawareBehavior()
{
	self notify("end_unaware_behavior");
	self.pacifist = false;
	self.maxSightDistSqrd = self.preUnawareBehaviorSightDistSqrd;
	self detach_flashlight();
}

waitUntilAwareOfEnemy()
{
	self endon("find_out_about_enemies");
	self endon("bulletwhizby");
	self endon("suppression");
	
	otherteam = "allies";
	if ( self.team == "allies" )
		otherteam = "axis";
	
	seeEnemyDist = 400;
	if ( self.team == "allies" )
		seeEnemyDist = 512;
	
	// todo:
	// break out if someone shoots a non-silenced weapon
	
	while(1)
	{
		if ( !self.pacifist )
			break;
		if ( isdefined( self.grenade ) )
			break;
		
		sawSomeone = false;
		
		potentialEnemies = getaiarray( otherteam );
		if ( level.player.team == otherteam )
			potentialEnemies[potentialEnemies.size] = level.player;
		for ( i = 0; i < potentialEnemies.size; i++ )
		{
			if ( distance( potentialEnemies[i].origin, self.origin ) > seeEnemyDist )
				continue;
			
			if ( !sightTracePassed( self geteye(), potentialEnemies[i] getShootAtPos(), false, undefined ) )
				continue;
			
			sawSomeone = true;
			break;
		}
		
		if ( sawSomeone )
			break;
			
		wait .3;		
	}
}

alertFriendsAboutEnemies()
{
	self endon("death");
	self endon("stop_alerting_friends_about_enemies");

	wait randomFloatRange( 0.8, 1.2 );
	
	// if we're not actually fighting, don't alert other friendlies
	while ( self.lastFoughtTime < gettime() - 1000 )
		wait .3;
	
	while(1)
	{
		others = getaiarray( self.team );
		// if I'm axis, I don't have a silenced weapon
		if ( self.team == "axis" )
			others = getaiarray();
		
		for ( i = 0; i < others.size; i++ )
		{
			if ( others[i] == self )
				continue;
			
			if ( distance( others[i].origin, self.origin ) > 512 )
				continue;

			if ( !sightTracePassed( self geteye(), others[i] geteye(), false, undefined ) )
				continue;

			others[i] notify("find_out_about_enemies");
		}
		
		wait .3;
	}
}

waitUntilHaventFoughtForAWhile()
{
	forgetTime = 2;
	
	self.lastFoughtTime = gettime();
	
	while(1)
	{
		amFighting = false;
		if ( isdefined( self.enemy ) && sightTracePassed( self geteye(), self.enemy getShootAtPos(), false, undefined ) )
			amFighting = true;
		
		if ( amFighting )
		{
			self.lastFoughtTime = gettime();
		}
		else
		{
			if ( gettime() - self.lastFoughtTime > forgetTime * 1000 )
				break;
		}
		
		wait .03;
	}
}

debugUnawareBehavior( text )
{
	/#
	self notify("stop_debugging_unaware");
	
	if ( getdebugdvar("scr_unaware") != "on" )
		return;
	
	self thread debugUnawareProx( text );
	#/
}

/#
debugUnawareProx( text )
{
	self endon("death");
	self endon("stop_debugging_unaware");
	self endon ("end_unaware_behavior");
	
	while(1)
	{
		print3d(self.origin + (0,0,60), text);
		foughttime = (gettime() - self.lastFoughtTime) / 1000;
		print3d(self.origin + (0,0,40), "last fought " + foughttime + " seconds ago");
		
		wait .05;
	}
}
#/

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


attach_flashlight( state )
{
	self attach( "com_flashlight_on" ,"tag_inhand", true );
	self.have_flashlight = true;
	self flashlight_light( state );
}

detach_flashlight()
{
	if ( !isdefined( self.have_flashlight ) )
		return;
	self detach( "com_flashlight_on", "tag_inhand" );
	self flashlight_light( false );
	self.have_flashlight = undefined;
}

flashlight_light( state )
{
	flash_light_tag = "tag_inhand";

	if ( state )
	{
		flashlight_fx_ent = spawn( "script_model", ( 0, 0, 0 ) );
		flashlight_fx_ent setmodel( "tag_origin" );
		flashlight_fx_ent hide();
		flashlight_fx_ent linkto( self, flash_light_tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );

		self thread flashlight_light_death( flashlight_fx_ent );
		playfxontag( level._effect["flashlight"], flashlight_fx_ent, "tag_origin" );
	}
	else if( isdefined( self.have_flashlight ) )
		self notify( "flashlight_off" );
}

flashlight_light_death( flashlight_fx_ent )
{
	self waittill_either( "death", "flashlight_off" );

	flashlight_fx_ent delete();
	self.have_flashlight = undefined;

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
	sunRiseSetColorTarget( "sun", vectorScale( (1,.5,.2), .75 ), interval );
	VisionSetNaked( "icbm_sunrise2", interval );
	//iprintlnbold( "Sunrise 2" );
	thread stopSnow();

	///////////////////////////////////////////////////////////
	// #3: approaching the industrial area. sun becomes strong red over 20 seconds
	getent("sunrise3", "targetname") waittill("trigger");
	interval = 20;
	setExpFog( 200, 12000, .169, .168, .244, interval );
	sunRiseSetColorTarget( "sun", vectorScale( (1,.6,.3), 1 ), interval );
	VisionSetNaked( "icbm_sunrise3", interval );
	//iprintlnbold( "Sunrise 3" );
	
	///////////////////////////////////////////////////////////
	// #4: leaving the industrial area. sun becomes near white over 20 seconds
	getent("sunrise4", "targetname") waittill("trigger");
	interval = 20;
	setExpFog( 200, 15000, .169, .168, .244, interval );
	sunRiseSetColorTarget( "sun", vectorScale( (1,.7,.4), 1.35 ), interval );
	VisionSetNaked( "icbm_sunrise4", interval );
	//iprintlnbold( "Sunrise 4" );

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

stopSnow()
{
	wait 20;
	flag_set("stop_snow");
	thread killCloudCover();
}

killCloudCover()
{
	
	cloudcoverfx	= getfxarraybyID( "cloud_cover" );
//	cloudcoverfx 	= array_combine(cloudcoverfx, getfxarraybyID( "cgoshp_drips_cargohold_edge" ));

	for(i=0; i<cloudcoverfx.size; i++)
		cloudcoverfx[i] pauseEffect();

}

#using_animtree("generic_human");
spawnerThink(ent)
{
	self endon ("death");
	self waittill ("spawned",spawn);
	ent.guys[ent.guys.size] = spawn;
	ent notify ("spawned_guy");
}




