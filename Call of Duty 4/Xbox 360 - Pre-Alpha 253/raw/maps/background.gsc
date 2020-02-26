#include maps\_utility;
#include maps\_hud_util;
#include common_scripts\utility;
#include maps\_anim;
#using_animtree("generic_human");

main()
{
	if (!isdefined (level.xenon))
		level.xenon = (getdvar ("xenonGame") == "true");

	level.player = getent("player", "classname" );

	maps\_hud::init();
	maps\_menus::init();
	maps\_camera::main("vehicle_camera");
	maps\_blackhawk::main("vehicle_blackhawk");
	//maps\_vehicle::main();	
	maps\_vehicle::init_vehicles();
	maps\_load::main();
	maps\_utility::battlechatter_off( "allies" );
	maps\_utility_code::struct_class_init();
	maps\mo_fastrope::main();
	
	precacheMenu("background_main");
	
	level.player openMenu("background_main");
	
	level initCameraPaths();

	sequences = [];
	sequences[0] = ::sequence1;
	sequences[1] = ::sequence2;
	sequences[2] = ::sequence3;
	//sequences[3] = ::sequence4;

	level thread playSequences(sequences);
	
	musicPlay("menu_music"); 
}

playSequences(sequences)
{
	for(;;)
	{
		for(i = 0; i < sequences.size; i++)
		{
			level thread [[sequences[i]]]();
			level waittill("sequence_done");
		}
	}
}

sequence1()
{
	//setdvar("cg_fov", "40");

	spawners1 = getentarray("sequence4_spawner1", "targetname");
	spawners2 = getentarray("sequence4_spawner2", "targetname");
	spawners3 = getentarray("sequence4_spawner3", "targetname");
	spawners4 = getentarray("sequence4_spawner4", "targetname");
	
	ai1 = blah(spawners1);
	ai2 = blah(spawners2);
	ai3 = blah(spawners3);
	ai4 = blah(spawners4);
	
	level.camera attachpath(getvehiclenode( "sequence4_path", "targetname" ));
	thread maps\_vehicle::gopath(level.camera);

	level.camera waittill( "reached_end_node" );
	//wait 8;
	level notify( "sequence_done" );
	
	wait 5;
	
	for(i = 0; i < ai1.size; i++)
		ai1[i] delete();

	for(i = 0; i < ai2.size; i++)
		ai2[i] delete();

	for(i = 0; i < ai3.size; i++)
		ai3[i] delete();

	for(i = 0; i < ai4.size; i++)
		ai4[i] delete();

	/*temp = maps\mo_fastrope::fastrope_get_heli("sequence4_spawner1");
	temp.vehicle delete();
	temp = maps\mo_fastrope::fastrope_get_heli("sequence4_spawner2");
	temp.vehicle delete();
	temp = maps\mo_fastrope::fastrope_get_heli("sequence4_spawner3");
	temp.vehicle delete();
	temp = maps\mo_fastrope::fastrope_get_heli("sequence4_spawner4");
	temp.vehicle delete();*/
	
	/*blackhawk1 = getent("sequence4_blackhawk1", "targetname");
	blackhawk2 = getent("sequence4_blackhawk2", "targetname");
	blackhawk3 = getent("sequence4_blackhawk3", "targetname");
	blackhawk4 = getent("sequence4_blackhawk4", "targetname");
	
	blackhawk1 attachpath(getvehiclenode( "sequence4_path1", "targetname" ));
	blackhawk2 attachpath(getvehiclenode( "sequence4_path2", "targetname" ));
	blackhawk3 attachpath(getvehiclenode( "sequence4_path3", "targetname" ));
	blackhawk4 attachpath(getvehiclenode( "sequence4_path4", "targetname" ));
	
	thread maps\_vehicle::gopath(blackhawk1);
	thread maps\_vehicle::gopath(blackhawk2);
	thread maps\_vehicle::gopath(blackhawk3);
	thread maps\_vehicle::gopath(blackhawk4);
	
	level.camera attachpath(getvehiclenode( "sequence4_path", "targetname" ));
	thread maps\_vehicle::gopath(level.camera);
	
	level.camera waittill( "reached_end_node" );
	level notify( "sequence_done" );
	
	//delete ents*/
}

sequence2()
{
	//setdvar("cg_fov", "65");
	
	spawners = getentarray("sequence3_spawner", "targetname");
	
	ai = [];
	for(i = 0; i < spawners.size; i++)
	{
		spawner = spawners[i];

		spawner.count = 1;
		ai[i] = spawner stalingradspawn();
		ai[i].dontavoidplayer = true;
	}
	
	level.camera attachpath(getvehiclenode( "sequence3_path", "targetname" ));
	thread maps\_vehicle::gopath(level.camera);

	level.camera waittill( "reached_end_node" );
	//wait 8;
	level notify( "sequence_done" );
	
	for(i = 0; i < ai.size; i++)
		ai[i] delete();
}

sequence3()
{
	//setdvar("cg_fov", "65");
	
	spawner = getent("sequence1_spawner", "targetname");
	spawner.count = 1;
	actor = spawner stalingradspawn();

	if(!spawn_failed(actor))
		actor.dontavoidplayer = true;
	
	level.camera attachpath(getvehiclenode( "sequence1_path", "targetname" ));
	thread maps\_vehicle::gopath(level.camera);

	level.camera waittill( "reached_end_node" );
	wait 3;
	level notify( "sequence_done" );
	
	if(isdefined(actor))
		actor delete();
}

sequence4()
{
	//setdvar("cg_fov", "65");
	
	spawner = getent("sequence2_spawner", "targetname");
	spawner.count = 1;
	actor = spawner stalingradspawn();

	if(!spawn_failed(actor))
		actor.dontavoidplayer = true;

	level.camera attachpath(getvehiclenode( "sequence2_path", "targetname" ));
	thread maps\_vehicle::gopath(level.camera);
	
	level.camera waittill( "reached_end_node" );
	level notify( "sequence_done" );
	
	actor delete();
}

initCameraPaths()
{
	vehicles = maps\_vehicle::scripted_spawn(0);
	level.camera = vehicles[0];
	level.camera hide();
	
	level thread updateCameraPathSettings();
}

updateCameraPathSettings()
{
	for(;;)
	{
		camerapaths = getdvar("scr_camerapaths");
		if(camerapaths == "")
			setdvar("scr_camerapaths", "1");

		camerapaths = getdvarInt("scr_camerapaths");
		if(camerapaths > 1)
			camerapaths = 1;
		else if(camerapaths < 0)
			camerapaths = 0;
		
		if(!isdefined(level.camerapaths) || level.camerapaths != camerapaths)
		{
			level.camerapaths = camerapaths;
			setdvar("scr_camerapaths", level.camerapaths);
	
			if(level.camerapaths)
				level.player playerlinktoabsolute(level.camera);
			else
				level.player unlink();
		}

		wait .05;
	}
}

blah(array)
{
	ai = [];
	
	for(i = 0; i < array.size; i++)
	{
		spawner = array[i];

		spawner.count = 1;
		ai[i] = spawner stalingradspawn();
		ai[i].dontavoidplayer = true;
	}

	return ai;
}