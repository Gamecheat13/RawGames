// Test clientside script for pel1

#include clientscripts\_utility;
#include clientscripts\_music;

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\pel1_fx::main();

	clientscripts\_amtank::main( "vehicle_usa_tracked_lvta4_amtank" );
	clientscripts\_buffalo::main( "vehicle_usa_tracked_lvt4" );
	
//	thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\pel1_amb::main();

	clientscripts\_vehicle::build_treadfx( "corsair" );	// set up corsair for dust fx.

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

	//thread event1_fakefire();
	thread event1_aaa_client();
	//thread event1_fake_dist_lvts();
	thread beach_fakefire_starter();
	
	thread evet1_side_smoke_begin();
	thread kill_ambient_trees_right();
	
	println("*** Client : pel1 running...");	
}

evet1_side_smoke_begin()
{
	println("*** Client : SMOKE!");	
	level waittill ("pol");	// players_off_lvt
	
	println("*** Client : SMOKE!");	
	struct1 = getstruct("side_smoke1","targetname");
	struct2 = getstruct("side_smoke2","targetname");
	
	playfx (0, level._effect["side_smoke"], struct1.origin, anglestoforward(struct1.angles ));
	playfx (0, level._effect["side_smoke"], struct2.origin, anglestoforward(struct2.angles ));

}



setup_fake_dest_lvts()
{
	//vehicle_usa_tracked_lvta4_amtank
	
	wait 3;
	
//	lvts = getentarray("fake_dest_lvts_model","targetname");
//	
//	for (i = 0; i < lvts.size; i++)
//	{
//		lvts[i] hide();
//	}
//	
//	level waittill ("get out of lvt");
//	
//	for (i = 0; i < lvts.size; i++)
//	{
//		lvts[i] show();
//	}
//	
//	level waittill ("remove floaters");
//		
//	for (i = 0; i < lvts.size; i++)
//	{
//		lvts[i] delete();
//	}
}


event1_fake_dist_lvts()
{
	lvts_structs = getstructarray("fake_dist_lvts","targetname");
	
	lvts = [];
	
	players = getlocalplayers();
	for(i = 0; i < lvts_structs.size; i++)
	{
		// change this players.size when laufer fixes a splitscreen bug
		for (n = 0; n < 1; n++)
		{
			lvts[i] = spawn(n, lvts_structs[i].origin, "script_model");
			lvts[i] setmodel("vehicle_usa_tracked_lvt4");
			println("set model");
			lvts[i].angles = lvts_structs[i].angles;
		}
	}
	
	println("set everything");
	for (i = 0; i < lvts_structs.size; i++)
	{
		point = getstruct (lvts_structs[i].target, "targetname");
		println("starting movetos");
		//lvts[i] moveto (point.origin, 40);
	}
	
	level waittill ("rf");	// remove_floaters
	
	// this needs to be threaded at some point per client
	for (i = 0; i < lvts.size; i++)
	{
		lvts[i] delete();
	}
	

}


event1_aaa_client()
{
	level waittill ("ab");	// aaa_begin
	
	point1 = getent(0, "event1_aaa_fx_point1","targetname");
	point2 = getent(0, "event1_aaa_fx_point2","targetname");
	point3 = getent(0, "event1_aaa_fx_point3","targetname");
	point4 = getent(0, "event1_aaa_fx_point4","targetname");
	point5 = getent(0, "event1_aaa_fx_point5","targetname");
	point6 = getent(0, "event1_aaa_fx_point6","targetname");
	
			
	point1 thread event1_ambient_aaa_fx_think("mof");
	point1 thread event1_ambient_aaa_fx_rotate();
	wait 1.5;
			
	point2 thread event1_ambient_aaa_fx_think();
	point2 thread event1_ambient_aaa_fx_rotate();
	wait 1.5;
	point3 thread event1_ambient_aaa_fx_think();
	point3 thread event1_ambient_aaa_fx_rotate();	

	thread aaa_flak();

	wait 1.5;	
	point4 thread event1_ambient_aaa_fx_think();
	point4 thread event1_ambient_aaa_fx_rotate();
	wait 1.5;	
	point5 thread event1_ambient_aaa_fx_think();
	point5 thread event1_ambient_aaa_fx_rotate();	
	
	wait 1.5;
	point6 thread event1_ambient_aaa_fx_think();
	point6 thread event1_ambient_aaa_fx_rotate();
				
}


event1_ambient_aaa_fx_think(endon_string)
{
	if (isdefined(endon_string))
	{
		level endon (endon_string);
	}
	
	while (1)
	{
		//if (!flag("ambients_on"))
		//{
		//	wait randomfloatrange(1, 4.0);
		//	continue;
		//}
			
		firetime = randomintrange (3, 8);
		
		for (i = 0; i < firetime * 5; i++)
		{
			playfx (0, level._effect["aaa_tracer"], self.origin, anglestoforward(self.angles ));
			// muzzle pop sound from gary
			playsound (0, "pacific_fake_fire", self.origin);
			wait 0.2;
		}
		wait randomintrange (1,3);
	}		
}

event1_ambient_aaa_fx_rotate()
{
	going_forward = true;
	
	while (1)
	{
			self rotateto((312.6, 180, -90), randomfloatrange (3.5,6));
			self waittill ("rotatedone");
			self rotateto((307.4, 1.7, 90), randomfloatrange(3.5,6));
			self waittill ("rotatedone");
	}
}

ambient_fakefire( endonString, delayStart )
{
	level endon ("do aftermath");
	
	if( delayStart )
	{
		wait( RandomFloatRange( 0.25, 3.5 ) );
	}
	
	if( IsDefined( endonString ) )
	{
		level endon( endonString );
	}
	
	team = undefined;
	fireSound = undefined;
	weapType = "rifle";
	
	if( !IsDefined( self.script_noteworthy ) )
	{
		team = "axis_mg";
	}
	else
	{
		team = self.script_noteworthy;
	}
	
	switch( team )
	{
		case "axis_mg":
			fireSound = "weap_type92_fire";
			weapType = "mg";
			break;
			
		default:
			ASSERTMSG( "ambient_fakefire: team name '" + team + "' is not recognized." );
	}
	
	// TODO make the sound chance dependent on player proximity?
	
	if( weapType == "rifle" )
	{
		muzzleFlash = level._effect["distant_muzzleflash"];
		soundChance = 60;
		
		burstMin = 1;
		burstMax = 4;
		betweenShotsMin = 0.8;
		betweenShotsMax = 1.3;
		reloadTimeMin = 5;
		reloadTimeMax = 10;
	}
	else
	{
		muzzleFlash = level._effect["distant_muzzleflash"];
		soundChance = 45;
		
		burstMin = 3;
		burstMax = 12;
		betweenShotsMin = 0.112;		// type92 fire time from turretsettings.gdt
		betweenShotsMax = 0.113;
		reloadTimeMin = 0.3;
		reloadTimeMax = 3.0;
	}
	
	
	burst_area = (1250,8250,1000);
	
	traceDist = 10000;
	orig_target = self.origin + vector_multiply( AnglesToForward( self.angles ),  traceDist );
			
	target_org = spawn (0, orig_target, "script_origin");
	
	//target_org thread drawlineon_org();
	
//	println("org" + target_org.origin);
//	println("BA" + burst_area);
		
	while( 1 )
	{		
		// burst fire
		burst = RandomIntRange( burstMin, burstMax );

		targ_point = (	(orig_target[0]) - (burst_area[0]/2) + randomfloat(burst_area[0]),
						(orig_target[1]) - (burst_area[1]/2) + randomfloat(burst_area[1]), 
						(orig_target[2]) - (burst_area[2]/2) + randomfloat(burst_area[2]));
						
		// TODO randomize the target a bit so we're not always firing in the same direction
		// get a point in front of where the struct is pointing
		target_org moveto(targ_point, randomfloatrange(0.5, 6.0));

		
		for (i = 0; i < burst; i++)
		{			
			target = target_org.origin;
			//BulletTracer( self.origin, target, false );
			
			// play fx with tracers
			fx_angles = VectorNormalize(target - self.origin);
			PlayFX( 0, muzzleFlash, self.origin, fx_angles );
			
			if (self.origin[0] > 1850 && self.origin[0] < 2300)
			{
				thread whiz_by_sound(self.origin, target);
			}
			// muzzle pop sound from gary
			playsound (0, "pacific_fake_fire", self.origin);
			
			// snyder steez - reduce popcorn effect
			if( RandomInt( 100 ) <= soundChance )
			{
				playsound( 0, fireSound, self.origin );
			}
			
			wait( RandomFloatRange( betweenShotsMin, betweenShotsMax ) );
		}
		
		wait( RandomFloatRange( reloadTimeMin, reloadTimeMax ) );
	}
	
}

drawlineon_org()
{
	while (1)
	{
		print3d (self.origin, "+", (1.0, 0.8, 0.5), 1, 3);
		wait 0.05;
	}
}

beach_fakefire_starter()
{
	//	while(1)
	//	{
			println("*** Client : Got to starting beachfire.");
			level waittill ("ab");	// aaa_begin
			println("*** Client : Starting beach fakefire");
			firePoints = GetStructArray( "beachwall_mgs", "targetname" );
		    ASSERTEX( IsDefined( firePoints ) && firePoints.size > 0, "Can't find fakefire points." );
		  	  				
			array_thread( firePoints, ::ambient_fakefire, "bfe", true );
	//	}
}

whiz_by_sound(start, end)
{
	org = spawn (0, start, "script_origin");

	org moveto (end, 4);
	
//	org thread drawlineon_org();
	
	fake_ent = spawnfakeent(0);
	setfakeentorg(0, fake_ent, start);
	playloopsound( 0, fake_ent, "pel1_beach_whizby"); 

//	println("playing_tracer");

	
	org thread whiz_by_sound_mover(fake_ent);
	
	org waittill ("movedone");
	deletefakeent(0,fake_ent);
	org delete();
}

whiz_by_sound_mover(fake_ent)
{
	self endon ("movedone");

	while (1)
	{
		realwait(0.05);
		setfakeentorg(0, fake_ent, self.origin);
	}
}

aaa_flak()
{	
	PlayFX( 0, level._effect["air_flak"], (8000, -4264, 5400));
	wait 0.5;
	PlayFX( 0, level._effect["air_flak"], (-8000, -4264, 4900));
	wait 0.5;	
	PlayFX( 0, level._effect["air_flak"], (0, -4264, 5400));
	wait 0.5;
	PlayFX( 0, level._effect["air_flak"], (16000, -4264, 5400));
	wait 0.5;
	PlayFX( 0, level._effect["air_flak"], (-16000, -4264, 5400));	
}

kill_ambient_trees_right()
{
	thread kill_ambient_trees_left();
	
	level waittill ("sfr");	// ship_fire_right
	
	trees = getentarray(0, "right_side_trees","targetname");
	
	println("TREEAMOUNT: " + trees.size);
	for (i = 0; i < trees.size; i++)
	{				
		level thread move_tree_and_delete(trees[i]);
	}	
}

kill_ambient_trees_left()
{
	level waittill ("sfl");	// ship_fire_left
	
	trees = getentarray(0, "left_side_trees","targetname");
	println("TREEAMOUNT: " + trees.size);
	for (i = 0; i < trees.size; i++)
	{
			
		level thread move_tree_and_delete(trees[i]);
	}
}

move_tree_and_delete(tree)
{

	wait randomfloatrange (3, 4);

	tree rotateto((180, 270, 0), 1.5, 0.6, 0.1);
	tree moveto (tree.origin - (0,0,1000), 1);
	wait randomfloatrange(1.3, 2.3);

	tree delete();
}