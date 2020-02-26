#include maps\_utility;

#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;
#using_animtree("generic_human");














main()
{

	
	
	
	

	level waittill ( "second_half" );
	savegame ( "barge" );
	
	level.kratt_dmg_var = 0;
	
	

	
	

	
	
	level thread torture_room_trigger();
	
	
	
	level thread fuel_room();
	
	level thread escape_one();

	level thread escape_two();

	level thread torture_light();
	
	level thread kratt_room();
	
	
	
	
	
	
	
	
	
	
	level thread chain_slide_one();
	
	level thread chain_slide_two();
	
	
	level thread fuel_room_fan_spin();
	
	level thread fuel_room_fuel_pipe_explode();
	
	
	
	
	
	level thread camera_group1_multi();
	
	
	
	




	
	

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
	
	
	level.player customCamera_change( level.camera_escape1, "world", level.player, (1070, 383.79, -386.05), (12.85, 173.14 , 0.00), 2.5);
	wait(2.5);
	level.player customCamera_change( level.camera_escape1, "world", level.player, (2212, -11.06, -386.05), (7.85, -126.14 , 0.00), 1.5);
	wait(1.5);
	level.player customCamera_change( level.camera_escape1, "world", level.player, (2626, 375.06, -254.05), (10.85, -1.14 , 0.00), 1.5);
	wait(1.5);
	level.player customCamera_pop( level.camera_escape1, 4.0);
	wait(4);
	level.player freezeControls(false);
	
}

camera_group2()
{
	tr_floor = getent("camera_floor_t1", "targetname");
	tr_right_high = getent("force_cover_enter", "targetname");
}
	
	
	
	



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
	
}

kratt_door_x()
{
	door = getent("kratt_room", "targetname");
	door rotateYaw(-90, .5);
	
}


	



torture_wheel(guy)
{
	trigger = getent("torture_wheel_trigger" , "targetname");
	wheel = getent("torture_wheel", "targetname");
	door = getent("torture_room_door2", "targetname");
	node = getnode("torture_node", "targetname");
	
	
	wheel rotatePitch(360, 3);
	wheel waittill ( "rotatedone" );
	door connectpaths();
	door rotateYaw(90, .5);
	wait(1);
	guy setgoalnode(node);
	
	startdistraction("torture_distract", 0);
	trigger delete();
	guy dodamage( 200, (0,0,1) );  
}


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
	
	
	chi1 dodamage( 200, (0,0,1) );
	wait(2);
	en1 SetAlertStateMax("alert_green");
	
	en1 startpatrolroute("escape_one_pat1");
	
	alert_reset();
}





alert_reset()
{
	wait(6);
	en1 = getent("escape_enemy0", "targetname");
	if(isdefined(en1))
	{
		en1 SetAlertStateMax("alert_red");
	}
}





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
	
	physicsExplosionSphere( ori1.origin, 100, 10, 7 );
	startdistraction("make_some_noise1_dist", 0);
	trigger trigger_off();
}



test_camera()
{
	
	
}

cargo_dist1(awareness_object)
{
	trigger = getent("cargo_dist1T", "targetname");
	trigger waittill("trigger");
	
	startdistraction("cargo_dist1", 0);
	
	
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
	
	spawner = getent("kratt_boss_spawner", "targetname");
	spawner stalingradspawn("kratt");
	
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
	reviveeffectcenter( 5.9, 5.5, 5.8, 5.56, 5.57, 5.69, 1.0, 1.0, 1.0 );  
	reviveeffectedge( 6.4, 1.4, 2.84, 0.86, 0.15, 1.8, 2.0, 2.0, 0.73, 1.23, 1.12 ); 
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
			
			
			kratt delete();
			wait(2);
			spawner = getent("kratt_boss_spawner2", "targetname");
			spawner stalingradspawn("kratt2");
			kratt = getent("kratt2", "targetname");
			kratt lockalertstate("alert_green");
			kratt SetEnableSense( true );
			
			kratt startpatrolroute("kratt_fight2");
			kratt SetScriptSpeed("run");
		
			
			
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
			
			array[i] SetScriptSpeed("run");      
		}
	}
	
	level thread kratt_wave3();
}

kratt_say2()
{
	iprintlnbold("Kratt yells: Kill Him!");
	ori = spawn("script_origin",level.player.origin);
	wait(1);
	playfx (level._effect["flash"], ori.origin);
	reviveeffect(true);
	reviveeffectcenter( 5.9, 5.5, 5.8, 5.56, 5.57, 5.69, 1.0, 1.0, 0.1 );  
	reviveeffectedge( 8.4, 3.4, 2.84, 2.86, 2.15, 1.8, 2.0, 2.0, 0.73, 1.23, 0.12 ); 
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
	
	
	level thread kratt_ori_move();
	fire_debris();
	while(level.kratt_dmg_var == 0)
	{
		
		
		wait(0.1);
	}
}

engine_explosion()
{
	ori2 = getent("kratt_shooters_ori2", "targetname"); 
	ori3 = getent("kratt_shooters_ori3", "targetname"); 
	ori4 = getent("kratt_shooters_ori4", "targetname"); 
	fxarray = getentarray("engine_fires_ori", "script_noteworthy");   
	ef1 = getent("engine_fire1", "targetname"); 
	ef2 = getent("engine_fire2", "targetname"); 
	ef3 = getent("engine_fire3", "targetname"); 
	ef4 = getent("engine_fire4", "targetname"); 
	ef5 = getent("engine_fire5", "targetname"); 
	ef6 = getent("engine_fire6", "targetname"); 
	ef7 = getent("engine_fire7", "targetname"); 
	ef8 = getent("engine_fire8", "targetname"); 
	ef9 = getent("engine_fire8", "targetname"); 
	enhtrig1 = getent("engine_fire_hurt1", "targetname");
	enhtrig1 trigger_on();
	radiusdamage(ori3.origin,500,10,9);
	fire_debris();
	level thread gen_explode();
	level thread engine_explosion2();
	
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
	
}



engine_explosion2()
{
	wait(20);
	level thread kratt_death();
	ori2 = getent("kratt_shooters_ori2", "targetname"); 
	ori3 = getent("kratt_shooters_ori3", "targetname"); 
	ori4 = getent("kratt_shooters_ori4", "targetname"); 
	fxarray = getentarray("engine_fires_ori", "script_noteworthy");   
	ef1 = getent("engine2_fire1", "targetname"); 
	ef2 = getent("engine2_fire2", "targetname"); 
	ef3 = getent("engine2_fire3", "targetname"); 
	ef4 = getent("engine2_fire4", "targetname"); 
	ef5 = getent("engine2_fire5", "targetname"); 
	ef6 = getent("engine2_fire6", "targetname"); 
	enhtrig2 = getent("engine_fire_hurt2", "targetname");
	enhtrig2 trigger_on();
	
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
	
}


gen_explode()
{
	wait(6);
	ef8 = getent("engine_fire8", "targetname"); 
	ef9 = getent("engine_fire8", "targetname"); 
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
	
	for (i = 0; i < array.size; i++)
	{
		playfx(level._effect["ceiling_smoke01"], array[i].origin);
	}
}

fire_debris()
{
	array = getentarray("fire_debris_ori", "script_noteworthy");
	earthquake(0.1, 4, level.player.origin, 100);
	
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
	
	
}









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

	
	wait(3);

}




fuel_room_fan_spin()
{
	engine_fan_large = getentarray ( "engine_fan_large", "targetname" );

	for (i = 0; i < engine_fan_large.size; i++  )
	{
		level thread fuel_room_engine_fan_think ( engine_fan_large[i] );
	}
}



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




fuel_room_fuel_pipe_explode()
{
	
	fuel_pipe = getentarray ( "fuel_room_fuel_pipe", "targetname" );

	for (i = 0; i < fuel_pipe.size; i++  )
	{
		fuel_pipe[i] thread fuel_room_fuel_pipe_explode_think();
	}
}


fuel_room_fuel_pipe_explode_think()
{
	
	
	
	self waittill ( "damage" );
	
	earthquake(0.5, 0.3, self.origin, 100);
	
	playloopedfx (level._effect["fuelroom_fire01"],3000, self.origin);
	
	
	
}


cleanup2()
{
 	array_ai = getaiarray("axis");
	for (i = 0; i < array_ai.size; i++ )
	{
		array_ai[i] delete();
  }
}
















