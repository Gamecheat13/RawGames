#include maps\_utility;
#include maps\_anim;
#using_animtree ("generic_human");

main()
{
// drone loading
	//character\char_jap_rifle3::precache();
	character\char_usa_marine_r_rifle::precache();
	//character\usinf_all::precache();

	//maps\_willys::main( "dest_test_jeep_main_dmg0" );	
	maps\_vehicle_lvt4::main("vehicle_usa_tracked_lvt4_gunners");
	maps\_vehicle_lvt4::main("vehicle_usa_tracked_lvt4_mp");
	level._effect["character_fire_pain_sm"] = LoadFx( "env/fire/fx_fire_player_sm_1sec" );
	level._effect["character_fire_death_sm"] = LoadFx( "env/fire/fx_fire_player_md" );
	level._effect["character_fire_death_torso"] = LoadFx( "env/fire/fx_fire_player_torso" );
	level._effect["character_bayonet_blood_in"] = LoadFx( "impacts/fx_flesh_bayonet_impact" );
	level._effect["character_bayonet_blood_front"] = LoadFx( "impacts/fx_flesh_bayonet_fatal_fr" );
	level._effect["character_bayonet_blood_back"] = LoadFx( "impacts/fx_flesh_bayonet_fatal_bk" );
	level._effect["character_bayonet_blood_right"] = LoadFx( "impacts/fx_flesh_bayonet_fatal_rt" );
	level._effect["character_bayonet_blood_left"] = LoadFx( "impacts/fx_flesh_bayonet_fatal_lf" );

	animscripts\utility::setFootstepEffect( "fire", LoadFx( "bio/player/fx_footstep_fire" ) );
	
	// Setup the raft
	setup_raft();
	
// These are called everytime a drone is spawned in to set up the character
	//level.drone_spawnFunction["axis"] = character\char_jap_rifle3::main;
	level.drone_spawnFunction["allies"] = character\char_usa_marine_r_rifle::main; 

// Call this before maps\_load::main(); to allow drone usage
	maps\_drones::init();	
	
	//level.bypassVehicleScripts = true;

//Loads everything else first
	maps\_load::main();

//threading runs these scripts now to make sure they are always available - newb move
	thread maps\living_battlefield_amb::main();
	thread maps\living_battlefield_fx::main();
	thread maps\living_battlefield_anim::main();

	thread maps\createcam\living_battlefield_cam::main();

//threading functions to make sure they run when the level loads
	//level thread camera_control();
	level thread endless_mf_grenades_mf();	
	
	level thread patrol_guys();
//	level thread foliage_attackers();
	level thread maps\_tree_snipers::main();
	
	//level thread curve_test();
	//level thread lvt_test();
	
//	setVolFog( 0, 11.5, 46, 0, .62, .68, .57, 0);
	watersimenable(true);
	
	level thread spawn_guys();
	
	maps\_load::all_players_connected();

	guy1 = getEnt( "hanging_corpse1", "targetname" );
	guy1 hangguy();
	guy2 = getEnt( "hanging_corpse2", "targetname" );
	guy2 hangguy();
	
	guy3 = getEnt( "testdoll1", "targetname" );
	guy3 hangguy_with_ragdoll( "j_ankle_ri" );
	guy4 = getEnt( "testdoll2", "targetname" );
	guy4 hangguy_with_ragdoll1( "j_ankle_ri", "j_wrist_le" );
	
	guy5 = getEnt( "floatdoll1", "targetname" );
	guy6 = getEnt( "floatdoll2", "targetname" );	
	guy7 = getEnt( "floatdoll3", "targetname" );	
	
	start = ( 736, -2448, 24 );
	end = ( 0, 0, 0 );
	createrope( start, end, 45, guy5, "j_ankle_ri" );
	
	guy5 startragdoll();
	
	guy6 startragdoll();
	
	guy7 startragdoll();
	
	wait 25;

	level thread do_rain();
	
	savegame( "save1" );
}

do_rain()
{
	players = get_players();
	for (i=0;i<4;i++)
	{
		if ( IsDefined(players[i]) )
		{
			players[i] setwaterdrops(250);
		}
	}
}

setup_raft()
{
	death_sound = "explo_metal_rand";
	health = 2000;
	turretType = undefined;
	turretModel = undefined;
	model = "makin_raft_rubber";
	death_fx = undefined;
	death_model = "makin_raft_rubber";
	health = 7500;
	min_health = 5000;
	max_health = 10000;
	team = "allies";
	func = ::rubber_raft_init;
	
	maps\_vehicle::build_template( "rubber_raft", model );
	maps\_vehicle::build_life( health, min_health, max_health );
	maps\_vehicle::build_treadfx();
	maps\_vehicle::build_team( team );
	maps\_vehicle::build_localinit( func );

	if( IsDefined( death_model ) )
	{
		maps\_vehicle::build_deathmodel( model, death_model );
	}

	if( IsDefined( death_fx ) )
	{
		maps\_vehicle::build_deathfx( death_fx, "tag_engine", death_sound, undefined, undefined, undefined, undefined );  // TODO change to actual explosion fx/sound when we get it
	}

	if( IsDefined( turretType ) && IsDefined( turretModel ) )
	{
		maps\_vehicle::build_turret( turretType, "tag_gunLeft", turretModel, true );
		maps\_vehicle::build_turret( turretType, "tag_gunRight", turretModel, true );
	}

	thread start_raft();
}

rubber_raft_init()	// damn vehicle scripts, why do I need this crap.
{
}

start_raft()
{
	boat = GetEnt( "raft", "targetname" );
	v_node = GetVehicleNode( "raftpath", "targetname" );
	boat AttachPath( v_node );
	wait 10;
	boat StartPath();


}

spawn_guys()
{
	wait 5;
	player = get_players()[0];

	sp1 = GetEnt("sp1", "targetname"); 
	goal1 = GetNode( "goal1", "targetname" );
	sp2 = GetEnt("sp2", "targetname"); 
	goal2 = GetNode( "goal2", "targetname" );
	
	trig = getent( "trap_trigger", "targetname" );
	trig waittill( "trigger" );

	guy1 = sp1 stalingradspawn();
	if( spawn_failed( guy1 ) )
	{
		assert( "Doh!" );
	}
	else
	{
		guy1.ignoreall = true;
		guy1.ignoreme = true;
		guy1.goalradius = 5;
	}
	guy1 SetGoalNode( goal1 );
	
	guy2 = sp2 stalingradspawn();
	if( spawn_failed( guy2 ) )
	{
		assert( "Doh!" );
	}
	else
	{
		guy2.ignoreall = true;
		guy2.ignoreme = true;
		guy2.goalradius = 5;
	}
	guy2 SetGoalNode( goal2 );

		
	guy1 waittill( "goal" );
	
	trap = getEnt("auto1115", "targetname");
	forcex = randomFloatRange( 1000, 8000 );
	forcey = randomFloatRange( -3000, 8000 );
	forcez = randomFloatRange( 1000, 3000 );

	dir = (forcex, forcey, forcez);
	contactPoint = trap.origin + ( randomfloatrange(-1,1), randomfloatrange(-1,1), randomfloatrange(-1,1) ) * 5;
	trap physicsLaunch( contactPoint, dir );
}

curve_test()
{
	i = 0;
	step = 36;
	scalar = -1;
	points = []; 
	points[i] = (-448, 673, 397);
	
	nNodes = 34;
	
	for(i = 1; i < nNodes; i ++)
	{
		x = points[0][0];
		y = points[i-1][1];
		z = points[i-1][2];
		
		x += step*scalar;
		y += step;
		
		points[i] = (x,y,z);
		
		scalar *= -1;
	}
	
	
	sorted = 0;
	
	while(1)
	{
		curve = getcurve();
		setcurvebspline(curve);

		if(!sorted)
		{				
			for(i = 0; i < nNodes; i ++)
			{
				addnodetocurve(curve, points[i]);
			}
		}
		else
		{
			numDone = 1;
			
			pointsAdded = [];
			
			for(i = 0; i < nNodes; i ++)
			{
				pointsAdded[i] = 0;
			}	
			
			addnodetocurve(curve, points[0]);
			pointsAdded[0] = 1;
			
			while(numDone < nNodes)
			{

				index = randomInt(nNodes);
				
				while(pointsAdded[index] == 1)
				{
					index ++;
					if(index >= nNodes)
					{
						index = 0;
					}
				}
						
				pointsAdded[index] = 1;
				
				addnodetocurve(curve, points[index]);
				
				numDone ++;
			
			}
			//sortcurve(curve, points[0]);
		}
		
		buildcurve(curve);
		drawcurve(curve);

		wait(2.0);
		
		freecurve(curve);

		wait(2.0);		
		
		sorted = !sorted;
	}
}

endless_mf_grenades_mf()
{
	while (1)
	{
		wait(5.0);
		players = get_players();
		for (i=0;i<4;i++)
		{
			if ( IsDefined(players[i]) )
			{
				offhand = players[i] GetCurrentOffhand();

				if ( offhand == "none" )
					continue;

				if ( players[i] GetAmmoCount( offhand ) > 0 )
					continue;

				players[i] TakeWeapon( offhand );

				if( offhand == "fraggrenade" )
					offhand = "molotov";
				else
					offhand = "fraggrenade";
				
				players[i] GiveWeapon( offhand );
				players[i] SetWeaponAmmoClip( offhand, 4 );
				players[i] SwitchToOffhand( offhand );
			}
		}
	}
}

end_curve_1(player)
{
	self waittill("curve_end", curveID);
	wait(1.0);
	player thread second_shot(player);
	wait(0.01);
	freecurve(curveID);
}

first_shot(player)
{
	points = []; times = [];
	i = 0;
	
	points[i] = (-223, -1645, 231); times[i] = 0; 	i = i + 1;
	points[i] = (-442, -1253, 335); times[i] = 3; 	i = i + 1;
	points[i] = (-1029, 1, 683); times[i] = 5; 	i = i + 1;
	points[i] = (-275, -287, 683); times[i] = 7; 	i = i + 1;
	
	curve1 = getcurve();
	
	for(i = 0; i < points.size; i ++)
	{
		addnodetocurve(curve1, points[i], times[i]);
	}
	
	buildcurve(curve1);
	/#
	drawcurve(curve1);
	#/
	setcurvenotifyent(curve1, player);
	
	//
	//  Assign cam to curve, give target point, turn on camera.
	//
	
	allies = getAIArray("allies");
	targetPoint = allies[0].origin;
	
	level.smash_cam cameralinktocurve(curve1);
	level.smash_cam setlookatorigin(targetPoint);
	player playerlinktocamera(level.smash_cam);
	
	startcurve(curve1);
	player thread end_curve_1(player);	
}

end_curve_2(player)
{
	self waittill("curve_end", curveID);
	wait(1.0);

	player thread third_shot(player);
	wait(0.4);
	freecurve(curveID);
}

second_shot(player)
{
	i = 0;
	points = []; 
	
	points[i] = (-448, 673, 397); i = i + 1;
	points[i] = (-352, 588, 328); i = i + 1;
	points[i] = (-177, 603, 308); i = i + 1;
	points[i] = (33, 499, 320); i = i + 1;
	points[i] = (142, 425, 320); i = i + 1;
	points[i] = (408, 349, 441); i = i + 1;

	curve2 = getcurve();
	
	for(i = 0; i < points.size; i ++)
	{
		addnodetocurve(curve2, points[i]);
	}
	
	buildcurve(curve2);
	setcurvespeed(curve2, 12 * 8);
	/#
	drawcurve(curve2);
	#/
	setcurvenotifyent(curve2, player);
	
	//
	//  Assign cam to curve, give target vector, turn on camera.
	//
	
	targetVec = (-100,0,0);
	
	level.smash_cam cameralinktocurve(curve2);
	level.smash_cam setlookatdirection(targetVec);
		
	startcurve(curve2);
	player thread end_curve_2(player);	
}

end_curve_3(player, cam_curve)
{
	self waittill("curve_end", curveID);
	wait(3.0);
	
	player thread forth_shot(player);
	wait(0.01);
	freecurve(curveID);
	freecurve(cam_curve);
}

third_shot(player)
{
	i = 0;
	points = []; 
	
	points[i] = (729, -3399, 221); i = i + 1;
	points[i] = (715, -2389, 211); i = i + 1;
	points[i] = (728, -1426, 211); i = i + 1;
	points[i] = (642, -1216, 211); i = i + 1;
	points[i] = (425, -1111, 255); i = i + 1;
	points[i] = (126, -1013, 235); i = i + 1;
	points[i] = (-74, -923, 236); i = i + 1;
	points[i] = (-295, -779, 346); i = i + 1;
	points[i] = (-650, -759, 451); i = i + 1;
	points[i] = (-956, -659, 451); i = i + 1;
	points[i] = (-1631, -1293, 270); i = i + 1;
	points[i] = (-1917, -1530, 260); i=i+1;

	curve3 = getcurve();
	
	for(j = 0; j < points.size; j ++)
	{
		addnodetocurve(curve3, points[j]);
	}
	
	setcurvesmooth(curve3);
	buildcurve(curve3);
	setcurvespeed(curve3, 20*12);
	/#
	drawcurve(curve3);
	#/
	points[i] = (-1987, -1697, 250);

	curve4 = getcurve();
	
	for(i = 0; i < points.size; i ++)
	{
		addnodetocurve(curve4, points[i]);
	}
	
	setcurvesmooth(curve4);
	buildcurve(curve4);
	setcurvespeed(curve4, 20*12);
	/#
	drawcurve(curve4);
	#/
	setcurvenotifyent(curve4, player);
	startcurve(curve4);
	wait(0.2);
	
	//
	//  Assign cam to curve4, give target curve, turn on camera.
	//	

	level.smash_cam cameralinktocurve(curve3);
	level.smash_cam setlookatcurve(curve4);
	
	startcurve(curve3);

	player thread end_curve_3(player, curve3);
}

end_curve_4(player)
{
	self waittill("curve_end", curveID);
	wait(2.0);
	
	//
	//  Destroy script cam...
	//
	
	player unlink();
	level.smash_cam delete();
}

forth_shot(player)
{
	points = []; times = [];
	i = 0;
	
	t = 3;
	
	points[i] = (-3043, 447, 1340); times[i] = 0; 	i = i + 1;	
	points[i] = (-2513, 3034, 1340); times[i] = t; 	i = i + 1;	
	points[i] = (243, 2698, 646); times[i] = t; 	i = i + 1;	
	points[i] = (1193, 2239, 889); times[i] = t; 	i = i + 1;	
	points[i] = (1739, 1491, 1343); times[i] = t; 	i = i + 1;	
	points[i] = (1587, -615, 1343); times[i] = t; 	i = i + 1;	
	points[i] = (-191, -1140, 503); times[i] = t; 	i = i + 1;	
	points[i] = (-1341, -1153, 1036); times[i] = t; 	i = i + 1;	
	points[i] = (-3043, 447, 1340); times[i] = t; 	i = i + 1;	
	
	curve5 = getcurve();
	
	for(i = 0; i < points.size; i ++)
	{
		addnodetocurve(curve5, points[i],times[i]);
	}

	buildcurve(curve5);
	/#
	drawcurve(curve5);
	#/
	setcurvenotifyent(curve5, player);
	
	//
	//  Assign cam to curve, give target point, turn on camera.
	//

	targetPoint = (-859, 296, 561);
	
	level.smash_cam cameralinktocurve(curve5);
	level.smash_cam setlookatorigin(targetPoint);
	
	
	startcurve(curve5);
	player thread end_curve_4(player);

		
}


camera_control()
{
	getent("cutscene_begin","targetname") waittill ("trigger", player);
	//maps\_camsys::playback_scene( "smash" );
	
	level.smash_cam = spawn("script_camera", (0,0,0));
	/#
	valid_player = false;
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( player == players[i] )
		{
			valid_player = true;
		}
	}
	assert( valid_player );
	#/
	player thread first_shot(player);
}



// dpg - 10/1/07
// guys that patrol back and forth, to show foliage brushing away out of their path
patrol_guys()
{
	trig = getent( "trig_patrol_guys", "targetname" );
	trig waittill( "trigger" );
	
	wait( 0.05 );
	
	patrollers = get_ai_group_ai( "patrol_ai" );
	
	for( i  = 0; i < patrollers.size; i++ )
	{
		patrollers[i].hitpoints = 0;
//		patrollers[i].ignoreall = 1;
//		patrollers[i].ignoreme = 1;
	}
	
	
}

// JamesS 1/5/08
// test out the lvt guns and whatnot
lvt_test()
{
	wait 4;
	lvt = getent( "lvt", "targetname" );
	//lvt.mantleenabled = 1;
	if( isdefined(lvt) )
	{
		gunIndex = 0;
		player = get_players()[0];

		player thread player_wait_enter_vehicle();
		for( ;; )
		{
			//lvt usevehicle( player, gunIndex+1 );

			//lvt setgunnertargetent( player, (0,0,0), gunIndex );
			//lvt setgunnertargetvec( player.origin, gunIndex );
			//for( i = 0; i < 10; i++ )
			//{
			//	lvt firegunnerweapon( gunIndex );
			//	wait 0.1;
			//}

			wait 7;
			gunIndex++;
			if( gunIndex > 3 )
				gunIndex = 0;

			riders = lvt getvehoccupants();

			wait 1;
		}
	}
}

player_wait_enter_vehicle()
{
	self waittill( "enter_vehicle", vehicle, seat );

	if( vehicle.speed == 0)
		seat = 5;
}

// dpg - 10/1/07
// guys that shoot at each other and only each other, to demonstrate effect of weapons on foliage
foliage_attackers()
{

	createthreatbiasgroup("players");
	createthreatbiasgroup("foliage_axis_ai_threat");
	createthreatbiasgroup("foliage_ally_ai_threat");

	level thread threat_group_setter();
	
	trig = getent( "trig_foliage_guys", "targetname" );
	trig waittill( "trigger" );
	
	wait( 0.05 );
	
	axis_ai = get_ai_group_ai( "foliage_axis_ai" );
	ally_ai = get_ai_group_ai( "foliage_ally_ai" );
	
	// have foliage_axis_ai ignore players
	setignoremegroup( "foliage_axis_ai_threat", "players" );
	// have foliage guys try to target each other exclusively
	setthreatbias( "foliage_axis_ai_threat", "foliage_ally_ai_threat", 10000 );
	setthreatbias( "foliage_ally_ai_threat", "foliage_axis_ai_threat", 10000 );
	
	
	guys = array_combine( axis_ai, ally_ai );
	
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i] thread magic_bullet_shield();
		guys[i] allowedstances ("crouch");
		guys[i] thread refill_ammo();
	}
	
}


// dpg - 10/1/07
// so they don't switch to their pistols
refill_ammo()
{

	while( 1 )
	{
	
		self.bulletsinclip = 20;
		wait( 1 );
		
	}
	
}


// dpg - 10/1/07
// taken from pel1.gsc. ideally would want to set this threatbias group as players join
// until we get the proper way to do this
threat_group_setter()
{
	while (1)
	{
		players = get_players();
		for (i = 0; i < players.size; i++)
		{
			players[i] setthreatbiasgroup("players");
		}
		wait (1.5);
	}
}

hangguy_with_ragdoll( bonename )
{
	start = self.origin + ( 0, 0, 150 );
	end = ( 0, 0, 0 );
	createrope( start, end, 100, self, bonename );
	self startragdoll();
}

hangguy_with_ragdoll1( bonename, bonename1 )
{
	start = self.origin + ( 0, 0, 150 );
	end = ( 0, 0, 0 );
	createrope( start, end, 100, self, bonename );
	
	start = start + ( 100, 50, 0 );
	createrope( start, end, 100, self, bonename1 );
	
	self startragdoll();
}

hangguy()
{
	forcex = randomFloatRange( 1000, 8000 );
	forcey = randomFloatRange( -3000, 8000 );
	forcez = randomFloatRange( 1000, 3000 );

	dir = (forcex, forcey, forcez);
	contactPoint = self.origin + ( randomfloatrange(-1,1), randomfloatrange(-1,1), randomfloatrange(-1,1) );
	self physicsLaunch( contactPoint, dir );	
	//self makefakeai();
}