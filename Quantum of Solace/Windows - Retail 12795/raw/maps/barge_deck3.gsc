#include maps\_utility;
//#include maps\_distraction;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;
#using_animtree("generic_human");

//createdistraction()
//startdistraction()
//killdistraction()

//starboard = right side of the ship
//larboard = left side of the ship

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////             Is THIS IS DECK THREE     ?     why yes...        //////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

main()
{

	//TEMP
	//level thread temp_trigger_skipto();
	
	//level waittill ( "kratt_dead" );

	level waittill ( "second_half" );
	savegame ( "barge" );
	
	level.kratt_dmg_var = 0;
	
	// ------------- PLAYER -------------

	// ------ GLOBAL FUNCTIONS ----------
	//level thread checkpoint_Kratt_dead();

	//bbekian
	//--------Torture room---------
	level thread torture_room_trigger();
	
	//level thread monitor_utility();
	
	level thread fuel_room();
	
	level thread escape_one();

	level thread escape_two();

	level thread torture_light();
	
	level thread kratt_room();
	
	
	
	//level thread test_camera();
	
	
	//bbbekian
	//custom distractions
	//level thread make_some_noise1();
	
	level thread chain_slide_one();
	
	level thread chain_slide_two();
	
	
	level thread fuel_room_fan_spin();
	
	level thread fuel_room_fuel_pipe_explode();
	
	//level thread force_cover_initializer();
	
	//level thread kratt_door_x();
	
	level thread camera_group1_multi();
	
	
	
	




	//level thread storage_room_box_slide2();
	//level thread end_level_igc();

	level maps\_playerawareness::setupSingleDamageOnlyNoWait( "hull_break_dmgT", ::hull_break_dmgT, true , undefined, level.awarenessMaterialMetal, 1, 0);
	
	level maps\_playerawareness::setupSingleUseOnlyNoWait("make_some_noise1T", ::make_some_noise1, undefined, 1, undefined, true, false, undefined, 
		level.awarenessMaterialElectric, 
		1, 
		0);
	
	
}



camera_group1_multi()
{
	tr_mid = getent("escape_mainT", "targetname");
	tr_left = getent("camera1a_left", "targetname");
	tr_right = getent("camera1a_right", "targetname");
	tr_mid waittill("trigger");
	level.camera_escape1 = level.player customCamera_Push( "world", level.player, (-286.46, 237.66 ,-230.89), (-29.06, -7.81 ,-0.11), 2.0);
	level.player freezeControls(true);
	wait(2);
	level.player customCamera_change( level.camera_escape1, "world", level.player, (178, 346.79, -230.05), (45.85, 169.14 , 0.00), 4.0);
	wait(4);
	level.player customCamera_change( level.camera_escape1, "world", level.player, (729, 346.79, -277.05), (12.85, 176.14 , 0.00), 2.5);
	wait(2.5);
	//level.player customCamera_change( level.camera_escape1, "world", level.player, (729, 346.79, -386.05), (12.85, 176.14 , 0.00), 1.5);
	//wait(1.5);
	level.player customCamera_change( level.camera_escape1, "world", level.player, (1070, 383.79, -386.05), (12.85, 173.14 , 0.00), 2.5);
	wait(2.5);
	level.player customCamera_change( level.camera_escape1, "world", level.player, (2212, -11.06, -386.05), (7.85, -126.14 , 0.00), 1.5);
	wait(1.5);
	level.player customCamera_change( level.camera_escape1, "world", level.player, (2626, 375.06, -254.05), (10.85, -1.14 , 0.00), 1.5);
	wait(1.5);
	level.player customCamera_pop( level.camera_escape1, 4.0);
	wait(4);
	level.player freezeControls(false);
	/*
	while(1) //here is the 3rd person test
	{
		if(level.player istouching(tr_mid))
		{
			level.player customCamera_change( level.camera_escape1, "world", level.player, (-286.46, 237.66 ,-230.89), (-29.06, -7.81 ,-0.11), 2.0);
			break;
		}
		else if(level.player istouching(tr_left))
		{
			//level.player customCamera_pop( level.camera_escape1, 2.0 );
			//level.camera_escape2 = level.player customCamera_Push( "world", level.player, (-266.43, -101.79, -197.05), (23.85, 57.14 , 0.00), 1.0);
			level.player customCamera_change( level.camera_escape1, "world", level.player, (-240.43, 887.79, -237.05), (-23.85, 26.14 , 0.00), 2.0);
			//break;
		}
		else if(level.player istouching(tr_right))
		{
			level.player customCamera_change( level.camera_escape1, "world", level.player, (-259.43, -77.79, -197.05), (-27.85, 14.14 , 0.00), 3.0);
			//break;
		}
		wait(1);
	}
	*/
}

camera_group2()
{
	tr_floor = getent("camera_floor_t1", "targetname");
	tr_right_high = getent("force_cover_enter", "targetname");
}
	
	
	
	

/*
force_cover_initializer()
{
    enter_trigger = getEnt( "force_cover_enter", "targetname" );
    enter_trigger thread force_cover_enter();
 
    exit_trigger = getEnt( "force_cover_exit", "targetname" );
    exit_trigger thread force_cover_exit();
}
 
force_cover_enter()
{
   while( true )
   {
      self waittill( "trigger" );
  
      level.player playerSetForceCover( true );
   }
}
 
force_cover_exit()
{
   while( true )
   {
      self waittill( "trigger" );
  
      level.player playerSetForceCover( false );
   }
}
*/

torture_light()
{
	light = getent("light_torture_1","targetname");
	trigger = getent("torture_light_switch", "targetname");
	trigger waittill("trigger");
	light setlightintensity(0);
}

torture_room_trigger()
{
	trigger = getent("torture_room_trigger","targetname");
	trigger waittill("trigger");
	level thread torture_door_x();
	axis = getaiarray("axis");
	for (i = 0; i < axis.size; i++)
	{
		axis[i] delete();
	}
	maps\_utility::holster_weapons();
	wait(1);
	trigger2 = getent("bond_gets_clocked", "targetname");
	trigger2 trigger_off();
	iprintlnbold("Barge: second half");
	guy = getent("torture_guard", "targetname");
	guy = guy stalingradspawn("torture_guard");
  if(!maps\_utility::spawn_failed(guy)) 
  {                                      
  	guy.targetname = "torture_guard";
  	guy startpatrolroute("tourture_patrol1");  
  }
  objective_add(2, "current", "Escape from the Barge.");
  level thread torture_wheel(guy);
}


torture_door_x()
{
	door = getent("torture_door3", "targetname");
	door rotateYaw(-90, .5);
	//door connectpaths();
}

kratt_door_x()
{
	door = getent("kratt_room", "targetname");
	door rotateYaw(-90, .5);
	//door connectpaths();
}


	
//torture_room_door2
//torture_room_door1

torture_wheel(guy)
{
	trigger = getent("torture_wheel_trigger" , "targetname");
	wheel = getent("torture_wheel", "targetname");
	door = getent("torture_room_door2", "targetname");
	node = getnode("torture_node", "targetname");
	//guy = getent("torture_guard", "targetname");
	//trigger waittill("trigger");
	wheel rotatePitch(360, 3);
	wheel waittill ( "rotatedone" );
	door connectpaths();
	door rotateYaw(90, .5);
	wait(1);
	guy setgoalnode(node);
	//wait(1);
	startdistraction("torture_distract", 0);
	trigger delete();
	guy dodamage( 200, (0,0,1) );  //<<<<<<--------temp 11/14
}
//light_tourture_1

escape_one()
{
	trigger = getent("escape_one_spawnT", "targetname");
	trigger waittill("trigger");
	chfspawn = getent("escape_one_chiffre1","targetname");
	guy = chfspawn stalingradspawn();
	if( !maps\_utility::spawn_failed (guy) )
	{
		guy.targetname = "chiffre1";
		guy lockalertstate( "alert_green" );
	}		
	array = getentarray("escape_one_enemyW", "targetname");
	nodes = getnodearray("escape_one_enemyN", "targetname");
	for (i = 0; i < array.size; i++)
	{
		array[i]= array[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( array[i]) )
		{
			//array[i] lockalertstate( "alert_red" );
			array[i].targetname = "escape_enemy" + i;
			array[i] setgoalnode(nodes[i]);
		}
	}
	chi1 = getent("chiffre1", "targetname");
	dialog[0] = "No, let me work for you!";
	dialog[1] = "Dont Kill me";
	wait(2);
	Print3d( chi1.origin + ( 0,0,64 ), dialog[ randomint(2) ] , (0, 1, 0), 1, 1, 90);
	wait(2);
	en1 = getent("escape_enemy0", "targetname");
	en2 = getent("escape_enemy1", "targetname");
	wait(1);
	//en1 shoot();
	//en2 shoot();
	chi1 dodamage( 200, (0,0,1) );
	wait(2);
	en1 SetAlertStateMax("alert_green");
	//en2 SetAlertStateMax("alert_green");
	en1 startpatrolroute("escape_one_pat1");
	//en2 startpatrolroute("escape_one_pat2");
	alert_reset();
}


//ai_enableAudition   disable the ai hearing


alert_reset()
{
	wait(6);
	en1 = getent("escape_enemy0", "targetname");
	if(isdefined(en1))
	{
		en1 SetAlertStateMax("alert_red");
	}
}


/*
alert_reset2()
{
	en2 = getent("escape_enemy1", "targetname");
	en2 SetAlertStateMax("alert_red");
	en2 SetAlertStateMin("alert_green");
}
*/


escape_two()
{
	trigger = getent("escape_mainT", "targetname");
	trigger waittill("trigger");
	array = getentarray("escape2_enemies", "targetname");
	for (i = 0; i < array.size; i++)
	{
		array[i]= array[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( array[i]) )
		{
			array[i] SetAlertStateMin("alert_green");
			array[i].targetname = "escape2_enemy" + i;
			array[i] startpatrolroute( "escape2_pat" + i );
		}
	}
	wait(3);
	level thread escape2_enemy3_death();
	level thread escape2_enemy2_death();
}


make_some_noise1()
{
	trigger = getent("make_some_noise1T", "targetname");
	ori1 = getent("make_some_noise_ori", "targetname");
	//trigger waittill("trigger");
	physicsExplosionSphere( ori1.origin, 100, 10, 7 );
	startdistraction("make_some_noise1_dist", 0);
	trigger trigger_off();
}



test_camera()
{
	//getent ( "test_camera", "targetname" ) thread maps\_securitycamera::camera_start();
	/*
	while(1)
	{
		if(camera.spotted == true)
		{
			iprintlnbold("The camera sees you");
		}
		else
		{
		}
	wait(1);
	}
	*/
}

cargo_dist1(awareness_object)
{
	trigger = getent("cargo_dist1T", "targetname");
	trigger waittill("trigger");
	//level notify("XXX");
	startdistraction("cargo_dist1", 0);
	//fx = getent("dist1_fx_ori", "targetname");
	//playfx (level._effect["fxsmoke1"], fx.origin +(0, 0, 0));
	wait(1);
	trigger trigger_off();
}






fuel_room()
{
	trigger = getent("fuel_room_trigger_fan", "targetname");
	trigger waittill("trigger");
	cleanup2();
	enhtrig1 = getent("engine_fire_hurt1", "targetname");
	enhtrig1 trigger_off();
	enhtrig2 = getent("engine_fire_hurt2", "targetname");
	enhtrig2 trigger_off();
	maps\_utility::unholster_weapons();
	door = getent("kratt_room", "targetname");
	door rotateYaw(90, .5);
	//door connectpaths();
	spawner = getent("kratt_boss_spawner", "targetname");
	spawner stalingradspawn("kratt");
	//spawner.targetname = "kratt" ;
	kratt = getent("kratt", "targetname");
	kratt lockalertstate("alert_green");
	kratt SetEnableSense( false );
	kratt startpatrolroute("kratt_fight1");
	kratt SetScriptSpeed("run");
}

kratt_room()
{
	trigger = getent("kratt_roomT", "targetname");
	trigger waittill("trigger");
	objective_state(1, "done");
	//wait(1);
	iprintlnbold("Kratt Fight");
	level thread kratt_wave1();
}

kratt_say1()
{
	iprintlnbold("Kratt yells: Get Him!");
	ori = spawn("script_origin",level.player.origin);
	wait(1);
	playfx (level._effect["flash"], ori.origin);
	reviveeffect(true);
	reviveeffectcenter( 5.9, 5.5, 5.8, 5.56, 5.57, 5.69, 1.0, 1.0, 1.0 );  // contrast RGB, Brightness RGB, Desaturation, Light Tint, Dark Tint
	reviveeffectedge( 6.4, 1.4, 2.84, 0.86, 0.15, 1.8, 2.0, 2.0, 0.73, 1.23, 1.12 ); // Blur Radius, Motionblur, Contrast RGB, Brightness RGB, Desaturation, Light Tint, Dark Tint.
	earthquake(0.5, 0.8, level.player.origin, 100);
	wait(3);
	reviveeffect(false);
	fire_debris();
}

kratt_wave1()
{
	array = getentarray("kratt_enemy1", "targetname");
	for (i = 0; i < array.size; i++)
	{
		array[i]= array[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( array[i]) )
		{
			array[i] SetAlertStateMin("alert_red");
			array[i].targetname = "kratt1_enemy" + i;
			array[i] setnormalhealth(1550);
			//array[i] startpatrolroute( "" + i );
			//array[i] SetScriptSpeed("walk")      
		}
	}
	wait(3);
	level thread kratt_wave1_check();
}

kratt_wave1_check()
{
	while(1)
	{
		if(level._ai_group["kratt1"].aicount == 0)
		{
			iprintlnbold("kratt phase2");
			kratt = getent("kratt","targetname");
			
			//the following is a super hack because I cant get kratt to change patrol routes 11/20  <<<<<<<<<<<<< super hack super hack super hack super hack
			kratt delete();
			wait(2);
			spawner = getent("kratt_boss_spawner2", "targetname");
			spawner stalingradspawn("kratt2");
			kratt = getent("kratt2", "targetname");
			kratt lockalertstate("alert_green");
			kratt SetEnableSense( true );
			//iprintlnbold("kratt ressurects aka Hack");
			kratt startpatrolroute("kratt_fight2");
			kratt SetScriptSpeed("run");
		
			//end hack
			
			level thread kratt_wave2();
			break;
		}
		wait(1);
	}
}

kratt_wave2()
{
	array = getentarray("kratt_enemy2", "targetname");
	nodes = getnodearray("kratt_enemy2_nodes", "targetname");
	for (i = 0; i < array.size; i++)
	{
		array[i]= array[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( array[i]) )
		{
			array[i] SetAlertStateMax("alert_red");
			array[i].targetname = "kratt2_enemy" + i;
			array[i] setnormalhealth(2550);
			array[i] setgoalnode(nodes[i]);
			
			array[i] SetEnableSense( false );
			//array[i] startpatrolroute( "" + i );
			array[i] SetScriptSpeed("run");      
		}
	}
	//x = randomintrange(5,10);
	level thread kratt_wave3();
}

kratt_say2()
{
	iprintlnbold("Kratt yells: Kill Him!");
	ori = spawn("script_origin",level.player.origin);
	wait(1);
	playfx (level._effect["flash"], ori.origin);
	reviveeffect(true);
	reviveeffectcenter( 5.9, 5.5, 5.8, 5.56, 5.57, 5.69, 1.0, 1.0, 0.1 );  // contrast RGB, Brightness RGB, Desaturation, Light Tint, Dark Tint
	reviveeffectedge( 8.4, 3.4, 2.84, 2.86, 2.15, 1.8, 2.0, 2.0, 0.73, 1.23, 0.12 ); // Blur Radius, Motionblur, Contrast RGB, Brightness RGB, Desaturation, Light Tint, Dark Tint.
	earthquake(0.5, 0.8, level.player.origin, 100);
	wait(3);
	reviveeffect(false);
	fire_debris();
}

kratt_wave3()
{
	ori = getent("kratt_shooters_ori", "targetname");
	ori2 = getent("kratt_shooters_ori2", "targetname");
	ori3 = getent("kratt_shooters_ori3", "targetname");
	ori4 = getent("kratt_shooters_ori4", "targetname");
	guy1 = getent("kratt2_enemy0", "targetname");
	guy2 = getent("kratt2_enemy1", "targetname");
	wait(2);
	guy1 cmdshootatentity(ori,false,5,.31);
	guy2 cmdshootatentity(ori,false,7,.31);
	//radiusdamage(ori3.origin,500,10,9);
	//radiusdamage(ori4.origin,500,10,9);
	level thread kratt_ori_move();
	fire_debris();
	while(level.kratt_dmg_var == 0)
	{
		//guy1 cmdshootatentity(ori,false,-1,.35);
		//guy2 cmdshootatentity(ori,false,-1,.35);
		wait(0.1);
	}
}

engine_explosion()
{
	ori2 = getent("kratt_shooters_ori2", "targetname"); //engine higher level
	ori3 = getent("kratt_shooters_ori3", "targetname"); //the origin to make sure all the damage triggers are hit.
	ori4 = getent("kratt_shooters_ori4", "targetname"); //engine higher level
	fxarray = getentarray("engine_fires_ori", "script_noteworthy");   // all of th efx origins.
	ef1 = getent("engine_fire1", "targetname"); //engine floor right
	ef2 = getent("engine_fire2", "targetname"); //engine floor right mid 
	ef3 = getent("engine_fire3", "targetname"); //engine floor right front
	ef4 = getent("engine_fire4", "targetname"); //engine floor front
	ef5 = getent("engine_fire5", "targetname"); //engine floor left front
	ef6 = getent("engine_fire6", "targetname"); //engine floor left mid
	ef7 = getent("engine_fire7", "targetname"); //engine floor left 
	ef8 = getent("engine_fire8", "targetname"); //capacitor 1
	ef9 = getent("engine_fire8", "targetname"); //capacitor 2
	enhtrig1 = getent("engine_fire_hurt1", "targetname");
	enhtrig1 trigger_on();
	radiusdamage(ori3.origin,500,10,9);
	fire_debris();
	level thread gen_explode();
	level thread engine_explosion2();
	//enhtrig1 trigger_on();
	while(1)
	{
		playfx (level._effect["fuelroom_fire01"], ef1.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire02"], ef2.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire03"], ef3.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire04"], ef4.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire02"], ef5.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire03"], ef6.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire04"], ef7.origin);
		wait(10);
		playfx (level._effect["fuelroom_fire04"], ef5.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire02"], ef1.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire03"], ef7.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire04"], ef4.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire02"], ef6.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire03"], ef3.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire04"], ef2.origin);
		wait(10);
	}
	//level thread contiuous_fire();
}



engine_explosion2()
{
	wait(20);
	level thread kratt_death();
	ori2 = getent("kratt_shooters_ori2", "targetname"); //engine higher level
	ori3 = getent("kratt_shooters_ori3", "targetname"); //the origin to make sure all the damage triggers are hit.
	ori4 = getent("kratt_shooters_ori4", "targetname"); //engine higher level
	fxarray = getentarray("engine_fires_ori", "script_noteworthy");   // all of th efx origins.
	ef1 = getent("engine2_fire1", "targetname"); //engine floor right
	ef2 = getent("engine2_fire2", "targetname"); //engine floor right mid 
	ef3 = getent("engine2_fire3", "targetname"); //engine floor right front
	ef4 = getent("engine2_fire4", "targetname"); //engine floor front
	ef5 = getent("engine2_fire5", "targetname"); //engine floor left front
	ef6 = getent("engine2_fire6", "targetname"); //engine floor left mid
	enhtrig2 = getent("engine_fire_hurt2", "targetname");
	enhtrig2 trigger_on();
	//radiusdamage(ori3.origin,500,10,9);
	fire_debris();
	level thread gen_explode();
	while(1)
	{
		playfx (level._effect["fuelroom_fire01"], ef1.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire02"], ef2.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire03"], ef3.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire04"], ef4.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire02"], ef5.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire03"], ef6.origin);
		wait(10);
		playfx (level._effect["fuelroom_fire04"], ef5.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire02"], ef1.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire04"], ef4.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire02"], ef6.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire03"], ef3.origin);
		wait(0.1);
		playfx (level._effect["fuelroom_fire04"], ef2.origin);
		wait(10);
	}
	//level thread contiuous_fire();
}


gen_explode()
{
	wait(6);
	ef8 = getent("engine_fire8", "targetname"); //capacitor 1
	ef9 = getent("engine_fire8", "targetname"); //capacitor 2
	playfx (level._effect["fxpumpgen"], ef8.origin);
	earthquake(0.7, 5, level.player.origin, 500);
	wait(.2);
	playfx (level._effect["fxpumpgen"], ef9.origin);
	fire_debris();
	wait(4);
	ceiling_smoke();
}


ceiling_smoke()
{
	array = getentarray("fire_smoke_ori", "script_noteworthy");
	earthquake(0.1, 4, level.player.origin, 100);
	//iprintlnbold("debris");
	for (i = 0; i < array.size; i++)
	{
		playfx(level._effect["ceiling_smoke01"], array[i].origin);
	}
}

fire_debris()
{
	array = getentarray("fire_debris_ori", "script_noteworthy");
	earthquake(0.1, 4, level.player.origin, 100);
	//iprintlnbold("debris");
	for (i = 0; i < array.size; i++)
	{
		playfx(level._effect["debris_falling01"], array[i].origin);
	}
}

kratt_ori_move()
{
	iprintlnbold("Kratt yells: Shoot the pipes, burn him alive");
	ori = getent("kratt_shooters_ori", "targetname");
	ori movez(100, 6, 1, 1);
	ori waittill ("movedone");
	//array[i] SetEnableSense( false );
	guy1 = getent("kratt2_enemy0", "targetname");
	guy2 = getent("kratt2_enemy1", "targetname");
	if(isdefined(guy1))
	{
		guy1 SetEnableSense(true);
	}
	if(isdefined(guy2))
	{
		guy2 SetEnableSense(true);
	}	
	kratt = getent("kratt","targetname");
	kratt startpatrolroute("kratt_fight3");
	level thread engine_explosion();
	level.kratt_dmg_var = 1;
}


kratt_say3()
{
	iprintlnbold("Kratt yells: !!!");
	fire_debris();
}

////////////////////////////////////////////////////
//////////////// GLOBAL FUNCTIONS //////////////////
////////////////////////////////////////////////////


//avulaj
//
global_vesper_screams_deck03()
{
	iprintlnbold ( "Vesper screams for Bond!!!" );
}



chain_slide_one()
{
	sliding_block = getent ( "deck03_sliding_block2", "targetname" );
	box_end_point = getent ( "box_end_point2", "targetname" );
	box_end_point2 = getent ( "chain_slide_drop_ori", "targetname" );
	deck03_push_block_trigger = getent ( "deck03_push_block2_trigger", "targetname" );
	deck03_push_block_trigger waittill ( "trigger" );
	sliding_block playsound("BRG_cargo_pulley");
	sliding_block moveTo (box_end_point.origin, 11);
	sliding_block waittill ("movedone");
	sliding_block moveTo (box_end_point2.origin, 2);
	physicsExplosionSphere( box_end_point2.origin, 300, 10, 7 );
	startdistraction("box_chain_one", 0);
	wait(1);
	radiusdamage(box_end_point2.origin, 220,350,250);
	deck03_push_block_trigger trigger_off();
	// insert a search 
}

chain_slide_two()
{
	sliding_block = getent ( "deck03_sliding_blockX1", "targetname" );
	box_end_point = getent ( "boxX1_end_point", "targetname" );
	trigger = getent ( "deck03_push_blockX1_trigger", "targetname" );
	trigger waittill ( "trigger" );
	sliding_block playsound("BRG_cargo_pulley");
	guy = getent("escape2_enemy3", "targetname");
	node = getnode("pulley2_node", "targetname");
	guy setgoalnode(node);
	sliding_block moveTo (box_end_point.origin, 11);
	sliding_block waittill ("movedone");
	startdistraction("pulley2", 0);
	trigger trigger_off();
}

escape2_enemy3_death()
{
	guy = getent("escape2_enemy3", "targetname");
	guy waittill("death");
	maps\_utility::unholster_weapons();
}

escape2_enemy2_death()
{
	guy = getent("escape2_enemy2", "targetname");
	guy waittill("death");
	maps\_utility::unholster_weapons();
}


hull_break_dmgT()
{
	trigger = getent("hull_break_dmgT", "targetname");
	//trigger waittill("trigger");
	ori1 = getent("hull_break_ori1", "targetname");
	ori2 = getent("hull_break_ori2", "targetname");
	ori3 = getent("hull_break_ori3", "targetname");
	playfx(level._effect["debris_falling01"], ori1.origin);
	wait(1);
	playfx(level._effect["debris_falling01"], ori1.origin);
	startdistraction("hull_break_dist", "targetname");
	while(1)
	{
		wait(2);
		playfx(level._effect["debris_falling01"], ori1.origin);
		wait(2);
		playfx(level._effect["debris_falling01"], ori1.origin);
		wait(2);
	}
}



kratt_death()
{
	kratt = getent("kratt2", "targetname");
	kratt waittill("death");
	kratt_say3();
	wait(2);
	//missionsuccess("barge", true);
	//changelevel( "Gettler" );
}
//


////////////////////////////////////////////////////
///////////// STORAGE ROOM FUNCTIONS ///////////////
////////////////////////////////////////////////////

//avulaj
//
end_level_igc()
{
	igc_end_level = getent ( "storage_room_igc_end_level", "targetname" );
	igc_end_level waittill ( "trigger" );
	iprintlnbold ( "IGC: Bond gets jumped" );
	
	level.player takeallweapons();
	
	bondstart = getent ("bondstart", "targetname");
	bond_move01 = getent ("bond_move01", "targetname");

	org = spawn("script_origin",level.player.origin);
	
	org rotateYaw(180, .01);

	level.player allowprone(false);
	level.player allowStand(false);
	wait (.5);
	level.player allowcrouch(true);

	level.player linkto( org );
	level.player freezeControls(true);
	wait (.5);
	
	org moveTo (bondstart.origin, 1);
	org waittill ("movedone");
	
	org moveTo (bond_move01.origin, 3);
	org waittill ("movedone");

	//iprintlnbold ( "Begin butt clinching mini game :P" );
	wait(3);

}


//avulaj
//this function grabs the array of fans and threads the function that makes them spin
fuel_room_fan_spin()
{
	engine_fan_large = getentarray ( "engine_fan_large", "targetname" );

	for (i = 0; i < engine_fan_large.size; i++  )
	{
		level thread fuel_room_engine_fan_think ( engine_fan_large[i] );
	}
}

//avulaj
//this function makes the fans in the fuel room spin
fuel_room_engine_fan_think ( fan )
{
	fuel_room_trigger_fan = getent ( "fuel_room_trigger_fan", "targetname" );
	fuel_room_trigger_fan waittill ( "trigger" );

	while (1)
	{
		wait(1);
		fan rotateYaw(360, 2.5);
	}
}

//avulaj
//this controlls all fuel pipe flame that get created when the player shoots a fuel pipe
//bbekian ported over
fuel_room_fuel_pipe_explode()
{
	//fxflame	= LoadFx ( "barge/fuelroom_fire01" );
	fuel_pipe = getentarray ( "fuel_room_fuel_pipe", "targetname" );

	for (i = 0; i < fuel_pipe.size; i++  )
	{
		fuel_pipe[i] thread fuel_room_fuel_pipe_explode_think();
	}
}


fuel_room_fuel_pipe_explode_think()
{
	//org = getent ( self.target, "targetname" );
	//trig = getent ( org.target, "targetname" );
	//trig trigger_off();
	self waittill ( "damage" );
	//iprintlnbold("damage");
	earthquake(0.5, 0.3, self.origin, 100);
	//playfx (level._effect["fuelroom_fire01"], self.origin);
	playloopedfx (level._effect["fuelroom_fire01"],3000, self.origin);
	//fxid = playfx (fx, org.origin);
	//wait(6);
	//self trigger_on();
}


cleanup2()
{
 	array_ai = getaiarray("axis");
	for (i = 0; i < array_ai.size; i++ )
	{
		array_ai[i] delete();
  }
}

////////////////////////////////////////////////////// DECK THREE END //////////////////////////////////////////////////////


//TEMP
//temp_trigger_skipto()
//{
//	temp_trigger_for_skipto = getent ( "temp_trigger_for_skipto", "targetname" );
//	temp_trigger_for_skipto waittill ( "trigger" );
//	level notify ( "kratt_dead" );
//}


/*
//avulaj
//this saves the game state when Kratt is killed
checkpoint_Kratt_dead()
{
	savegame ( "barge" );
}

*/

/*

//bbekian
//setting up a prefab use distraction with awareness
monitor_utility_awareness()
{
	maps\_playerawareness::setupArrayUseOnly( "monitor_distract_useT",
																						::mon_distract,
																						"Press &&1 to have some fun",
																						undefined,
																						undefined,
																						true,
																						true,
																						level.awarenessMaterialMetal,
																						true,
																						true );
																						
}

monitor_utility()
{
	array = getentarray("monitor_distract_useT", "targetname");
	for (i = 0; i < array.size; i++)
	{
		array[i] thread mon_distract();
	}
}


mon_distract()    //mon_distract( strcEnt )
{
	monitor = getent( self.targetname, "target");
	distraction = getent(self.target, "targetname");
	self waittill("trigger");  //for
	//use_trigger = getent(self.target , "targetname");
	startdistraction("distraction", 2);
	playfx (level._effect["CPU"], monitor.origin);
	self delete();
}
*/
