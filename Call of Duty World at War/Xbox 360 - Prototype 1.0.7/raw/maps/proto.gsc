#include maps\_utility;
main()
{
	music_track( 1 );
//	precacheString(&"INTROSCREEN_TITLE");
//	precacheString(&"INTROSCREEN_PLACE");
//	precacheString(&"INTROSCREEN_DATE");
//	precacheString(&"INTROSCREEN_INFO");
//	level thread maps\_introscreen::introscreen_delay( "Moving Forward", "8 Days Scripting and 6 Days Building", "", "No Nights + No Weekends = No Overtime", 1, 1, 2 );
	strings = [];
	strings[0] = "\"Moving Forward\"";
	strings[1] = "1 Scripter, 8 Days of Work";
	strings[2] = "1 Builder, 6 Days of Work";
	strings[3] = "No Nights + No Weekends = No Overtime";
	level thread custom_introscreen( strings );

	//precacheModel("xmodel/fastrope_arms");
	precacheRumble("tank_rumble");
		
	level._effect["launch_smoke"] = loadfx ("smoke/emitter_rocket_trail");
	level._effect["launch_fire"] = loadfx ("smoke/smoke_geotrail_icbm");
	level._effect["launch_pre_smoke"] = loadfx ("smoke/smoke_grenade");
	level._effect["vehicle_explode"] = loadfx ("explosions/cobrapilot_vehicle_explosion");
	level._effect["oil_fire"] = loadfx ("fire/firelp_vhc_lrg_pm_farview");	
		
	level.stopwatch = 2;
	level.missiles = [];
	level.missioncount = 0;
	
	maps\_humvee50cal::main("vehicle_humvee_camo_50cal_nodoors");
	maps\_blackhawk::main("vehicle_blackhawk");
	maps\_truck::main("vehicle_pickup_roobars");
	maps\_technical::main("vehicle_pickup_technical");
	maps\_m1a1::main("vehicle_m1a1_abrams");
	maps\_bradley::main("vehicle_bradley");

	// cover system init
	maps\_covertest::init();

	maps\_load::main();
	maps\_javelin::init();
	
	// cover system startup
	maps\_covertest::main();
	
	oil_fires();
	level thread rpg_fire();

	// MikeD: Don't draw fps.
//	SetSavedDvar( "cg_drawfps", "0" );
	
	//level thread killmans();
	
	flag_init( "fastrope" );
	flag_init("start timer");
	
	// MikeD: Make the player regen quick.
	level.difficultySettings["playerHealth_RegularRegenDelay"]["easy"] = 1; // 1500; //4700;
	level.difficultySettings["playerHealth_RegularRegenDelay"]["normal"] = 1; // 1500; //4700;
	level.difficultySettings["playerHealth_RegularRegenDelay"]["hardened"] = 1; // 1500; //4700;
	level.difficultySettings["playerHealth_RegularRegenDelay"]["veteran"] = 1; // 1500; //4700;
	println( "level.playerHealth_RegularRegenDelay = ", level.playerHealth_RegularRegenDelay );
	level.playerHealth_RegularRegenDelay = 1;

	level.difficultySettings["longRegenTime"]["easy"] = 1;
	level.difficultySettings["longRegenTime"]["normal"] = 1;
	level.difficultySettings["longRegenTime"]["hardened"] = 1;
	level.difficultySettings["longRegenTime"]["veteran"] = 1;
	level.longRegenTime = 1;

	primaryweapon = "m16_basic";
	secondaryweapon = "beretta";

	players = getentarray ("player","classname");
	for (i=0;i<players.size;i++)
	{
		players[i] takeallweapons();
	        players[i] giveWeapon( secondaryweapon );
	        players[i] giveWeapon( primaryweapon );
	        players[i] giveWeapon("fraggrenade");
	        players[i] giveWeapon("smoke_grenade_american");
	        players[i] switchToWeapon( primaryweapon );
	}
	
	if (getdvar ("skipto") == "")
	{
//		level thread maps\_introscreen::introscreen_delay("The Eight Day Operation", "Secure Radio Tower and Destroy three Missle Silos", "0730 Jan 12 2014", "Iraqi Airfield", 2, 2, 2);
		event1_begin();
	}
	else
	{
		skipto_setup(getdvar ("skipto"));
	}
		
}

event1_begin()
{
	getent("ev1_start_chopper", "targetname") useby (level.player);
	wait(1);
	
	level.chopper = getent("player_blackhawk","targetname");
	level.chopper thread chopper_fly();	
	level.chopper thread attachPlayer();

	ai = getaiarray();
	for(i = 0; i< ai.size; i++)
	{
		ai[i] setgoalentity(level.player);
		if (ai[i].name == "Pvt. Snyder")
		{
			level.snyder = ai[i];
			level.snyder thread magic_bullet_shield();
		}
		if ( ai[i].name == "Pvt. McCord")
		{
			level.mccord = ai[i];
			level.mccord thread magic_bullet_shield();
		}
	}

	level waittill( "starting final intro screen fadeout" );
	
	getent("ev1_start_chopper_move", "targetname") useby (level.player);

	wait 5;
	flag_set("fastrope");
	
	level thread event2_vehicle_think();
}

target_missiles()
{
	while (level.player getCurrentWeapon() != "javelin")
	{
		wait (0.05);
	}
	
	OFFSET = ( 0, 0, 80 );
	
	for (i=0; i < level.missiles.size; i++)
	{
		target_set( level.missiles[i] );
		target_setAttackMode( level.missiles[i], "top" );
	}	
}

chopper_fly()
{
	/*
	//fly the chopper to a position
	setVehGoalPos( pos, stopAtGoal )
	
	
	//make the chopper face a direction once it gets to it's goal
	setGoalYaw( angle )
	clearGoalYaw()
	
	
	//make the chopper face a certain direction
	setTargetYaw( angle )
	clearTargetYaw()
	
	setLookAtEnt( ent, offset )
	clearLookAtEnt()
	
	
	//set the max speeds for rotation
	setYawSpeed( speed, accel )
	setMaxPitchRoll( pitch, roll )
	*/

//	pathstart = getent("point1","targetname");
//	
//	pathpoint = pathstart;
//	arraycount = 0;
//	pathpoints = [];
//	while(isdefined (pathpoint))
//	{
//		pathpoints[arraycount] = pathpoint;
//		arraycount++;
//		if(isdefined (pathpoint.target))
//		{
//			pathpoint = getent(pathpoint.target, "targetname");
//		}
//		else
//			break;
//	}
	
//	self setspeed(60,10);
//	self setGoalYaw ( 160 );
//	self setYawSpeed (20, 10);
	
	//for (i=0; i<pathpoints.size;i++)
	//{
	//	self setVehGoalPos( pathpoints[i].origin + (0,0,0) , 1 );
	//	self waittill ( "goal" );
	//	self setGoalYaw ( pathpoints[i].angles[1] );
	//}	
	
	getvehiclenode ("auto2784","targetname") waittill ("trigger");
	level.chopper setspeed(0.1, 30);
	level.chopper notify ("unload");
	
	//flag_set( "fastrope" );
	//self notify ("unload");
	//self setYawSpeed (40, 20);
	//self setspeed(80,20);
	self waittill ("get ready to fly away");
	maps\_vehicle::vehicle_pathdetach();
	
	level thread put_back_on_chain();
	
	wait 10;
	self setYawSpeed (40, 20);
	self setGoalYaw ( 180 );
	wait 3;
	self setVehGoalPos( getent("chopper_end","targetname").origin , 0 );
	//wait 5;
	self waittill ( "goal" );
	//self setGoalYaw ( 315 );
	//self setVehGoalPos( getent("point1","targetname").origin , 1 );
	//self waittill ( "goal" );
	self delete();	
}

#using_animtree ("fastrope");
player_fastrope()
{
	arms = getent("arms","targetname");
	
	arms.origin = level.chopper getTagOrigin("tag_detach");
	arms.angles = level.chopper getTagAngles("tag_detach");
	
	//arms linkto(level.chopper);
	arms useanimtree(#animtree);
	
	arms setanim(%ch_player_rope_idle);
	
	level.player playerLinkToAbsolute (arms, "tag_player");
	
	//flag_wait("fastrope");
	
	arms clearanim(%ch_player_rope_idle, 0);
	arms setanim(%ch_player_rope);
}

attachPlayer()
{
 	level.vehicle_rumble["blackhawk"] = maps\_vehicle::build_rumble( "tank_rumble", 0.12,4.5,850,1,1 ); 
      	level.chopper thread maps\_vehicle::vehicle_rumble(); 
 
	
	//playerlinktodelta( <linkto entity>, <tag>, <viewpercentag fraction>, <right arc>, <left arc>, <top arc>, <bottom arc> )
	level.player playerLinkToDelta (level.chopper, "tag_playerride", 1.0, 65, 65, 18, 40);
	wait 0.05;
	level.player allowProne( false );
	level.player allowCrouch( false );
	level.player setplayerangles ( level.chopper getTagAngles( "tag_playerride" ) );
	
	level.chopper waittill ("unload");
	wait(1);
	
	trig = getent("fastrope_use","targetname");
	trig thread  keep_ent_on_tag(level.chopper, "tag_fastrope_ri");
	trig waittill ("trigger");
	trig notify ("keep ent on tag stop");
	trig delete();

	// Music
	music_track( 2, 2 );
	
	level notify( "kill_rpg_guys" );
	level.chopper notify ("get ready to fly away");
	
	org_dropper = spawn("script_origin", (level.player.origin - (0,0,15)));
	org_dropper.angles = level.player.angles;
	level.player unlink();
	level.player playerLinkToDelta (org_dropper, "", 1.0, 65, 65, 18, 40);	
	org_dropper moveto(level.chopper GetTagOrigin("tag_detach") - (0,0,0), 1.3, 0.1, 0.1);
	//org_dropper waittill ("movedone");
	wait(1.2);
	org_dropper moveto(org_dropper.origin - (0,0,500), 2.5, 0.1, 0.1);
	org_dropper waittill ("movedone");
	level.player unlink();
	
	level.player allowProne( true );
	level.player allowCrouch( true );
	
// MikeD: For some reason it causes it to assert, so I do a safety check
//	getent("other_blackhawk", "targetname") delete();
	other_blackhawk = getent("other_blackhawk", "targetname");
	if( IsDefined( other_blackhawk ) )
	{
		other_blackhawk Delete();
	}
	
	deleteme = getentarray("ambientvehicles","targetname");
	
	for(i=0; i<deleteme.size; i++)
	{
		deleteme[i] delete();
	}
	
}

keep_ent_on_tag(ent, tag)
{
	self endon ("keep ent on tag stop");
	
	while (1)
	{
		self.origin = ent GetTagOrigin(tag);
		wait (0.05);	
	}
}

event2_vehicle_think()
{
	level thread tanker_explode();
	
	trig = getent("ev2_start_hum_move","targetname");
	trig waittill ("trigger");
	level.humvee = getent("player_humvee","targetname");
	
	v_node = getvehiclenode ("auto2736","targetname");
	v_node waittill ("trigger");
	
	level.humvee setspeed (0,30);
	level.humvee makevehicleusable();
	level.humvee waittill ("trigger");

	music_track( 4, 2 );

	level thread start_timer();
	level thread event3_missile_launch();
	
	enemy = getaiarray("axis");
	level thread kill_all_enemy();
	
	wait (1.5);
	
	level.humvee ResumeSpeed(10);
	v_node = getvehiclenode ("auto2738","targetname");
	v_node waittill ("trigger");
	level.humvee setspeed (0,30);
	
	humveeride_check_for_ai();

	
	level.humvee ResumeSpeed(10);
	v_node = getvehiclenode ("auto2740","targetname");
	v_node waittill ("trigger");
	level.humvee setspeed (0,30);
		
	humveeride_check_for_ai();
	
	level.humvee ResumeSpeed(10);
	v_node = getvehiclenode ("auto2743","targetname");
	v_node waittill ("trigger");	
	level.humvee setspeed (0,10);	
	
	humveeride_check_for_ai();

	level.humvee ResumeSpeed(10);
	v_node = getvehiclenode ("auto2774","targetname");
	v_node waittill ("trigger");	
	level.humvee setspeed (0,10);	
	
	wait (0.75);
	
	level.humvee useby(level.player);
	
	level thread target_missiles();	
	level thread playerammo();		
}

objective_stopwatch()
{
	flag_wait("start timer");

	// Setup the HUD display of the timer.
	level.hudTimerIndex = 20;
	
	level.timer = newHudElem();
	level.timer.alignX = "left";
	level.timer.alignY = "middle";
	level.timer.horzAlign = "right";
    	level.timer.vertAlign = "top";
    	
	level.timer.fontScale = 2;
	level.timer.x = -200;
	
	level.timer.y = 50;
	level.timer.label = "Launch in T minus ";
	level.timer setTimer(level.stopwatch*60);

	wait (level.stopwatch * 60);
	level.timer destroy();	
}

start_timer()
{
	level thread objective_stopwatch();
	wait 3;
	flag_set("start timer");
}

put_back_on_chain()
{
	wait (10);
	
	soldiers = getAIArray( "allies");
		
	for (i=0; i<soldiers.size; i++)
	{
		if (soldiers[i].name == "Pvt. Jones" || soldiers[i].name == "Pvt. Smith")
		{
			soldiers[i] delete();
		}
		
		wait(0.05);
		
		if (isalive(soldiers[i]))
		{
			soldiers[i] setgoalentity (level.player);
		}
	}
}

kill_all_enemy()
{
	enemy = getaiarray("axis");
	
	for (i = 0; i<enemy.size;i++)
	{
		if (isalive (enemy[i]))
		{
			enemy[i] dodamage( enemy[i].health + 5, (0,0,0));
		}
	}
}

humveeride_check_for_ai()
{
	while (1)
	{
		if (isdefined(get_closest_ai (level.player.origin, "axis")))
		{
			wait (3);
		}
		else
		{
			break;
		}
	}
}

skipto_setup(skipto)
{
	if (skipto == "humvee")
	{
		level thread event2_vehicle_think();
	}
	else if (skipto == "end")
	{
		level thread start_timer();
		level thread event3_missile_launch();
		level thread target_missiles();	
		level thread playerammo();	
	}
}

missile_launcher(groupname, init_wait, move_time, launch_wait, fire_wait)
{
	system = getentarray(groupname, "script_noteworthy");
	
	rod = undefined;
	truck = undefined;
	missile = undefined;
	smoke = undefined;
	killpoint = undefined;
	
	for (i=0; i<system.size; i++)
	{
		if (system[i].targetname == "launcher_rod")
		{
			rod = system[i];
		}
		else if (system[i].targetname == "launcher_truck")
		{
			truck = system[i];	
		}
		else if (system[i].targetname == "launcher_missile")
		{
			missile = system[i];	
		}
		else if (system[i].targetname == "launcher_smoke")
		{
			smoke = system[i];
		}
		else if (system[i].targetname == "launcher_killpoint")
		{
			killpoint = system[i];
		}
	}

	level thread kill_launcher(rod, truck, missile, smoke, killpoint);
	
	level.missiles = array_add ( level.missiles, missile );
	killpoint endon("trigger");
			
	missile linkto(rod);
	smoke linkto (missile);

	wait(init_wait);
	
	rod rotateroll (-85, move_time, 0.1, 0.1);		
	wait (move_time+launch_wait);
	
	playfxontag(level._effect["launch_pre_smoke"], smoke, "TAG_FX");
	
	wait (fire_wait);
	playfxontag(level._effect["launch_fire"], smoke, "TAG_FX");
	wait (3);
	missile unlink();
		
	missile moveto (getent(missile.target,"targetname").origin, 30, 0.1, 0.1);
	wait (1);
	missile moveto (getent(missile.target,"targetname").origin, 3, 0.1, 0.1);
	
	wait(1);
	missionfailed();
}

kill_launcher(rod, truck, missile, smoke, killpoint)
{
	killpoint waittill ("trigger");
	
	level.missioncount++;
	
	target_remove( missile );
	
	rod delete();
	smoke delete();
	
	truck setmodel("vehicle_tanker_truck_d");
	playfx (level._effect["vehicle_explode"], truck.origin);
	playfx (level._effect["vehicle_explode"], missile.origin);
	missile delete();
		
	if (level.missioncount == 3)
	{
		level thread music_track( 3, 2 );
		strings = [];
		strings[0] = "\"People rarely succeed unless they have fun in ";
		strings[1] = "what they are doing.\"";
		level thread custom_introscreen( strings, true );
		wait (43);
		missionsuccess( "credits", false );
	}
}
	
missile_smoke()
{
	self endon("kill missile");
	while (1)
	{
		playfxontag(level._effect["launch_smoke"], self, "TAG_FX");
		wait (0.1);
	}
}

event3_missile_launch()
{
	level thread missile_launcher("system1", 30, 55, 15, 20);
	wait(1);
	level thread missile_launcher("system2", 30, 55, 15, 20);
	wait(1);
	level thread missile_launcher("system3", 30, 55, 15, 20);
}

playerammo()
{
	while (1)
	{
		currentweapon = level.player getCurrentWeapon();
		currentammo = level.player getFractionMaxAmmo(currentweapon);

		if (currentammo < .2 && currentweapon == "javelin")
			level.player giveMaxAmmo(currentweapon);
		wait (1);
	}
}

tanker_explode()
{
	tanker_trig = getent("tanker_trig","targetname");
	tanker = getent("tanker","targetname");
	
	dmg_accum = 0;
	while (1)
	{
		tanker_trig waittill ("damage",dmg);
		dmg_accum = dmg_accum + dmg;
		if (dmg_accum > 1000)
		{
			break;
		}
	}
	
	tanker setmodel ("vehicle_tanker_truck_d");
	radiusdamage(tanker.origin, 400, 10000, 8000);
	playfx(level._effect["vehicle_explode"], tanker.origin);
}

oil_fires()
{
	fires = getentarray("oil_fires","targetname");
	
	for (i=0; i< fires.size;i++)
	{
		//ent = maps\_utility::createOneshotEffect("firelp_vhc_lrg_pm_farview");
    		//ent.v["origin"] = fires[i].origin;
     		//ent.v["angles"] = fires[i].angles;
     		//ent.v["fxid"] = "firelp_vhc_lrg_pm_farview";
     		//ent.v["delay"] = -15;
     		fxent = spawnfx(level._effect["oil_fire"], fires[i].origin);
     		triggerFx( fxent );
	}
}

killmans()
{
	trig = getent("killmans","targetname");

	level thread setgoal1();
	
	while (1)
	{
		trig waittill ("trigger", ai);
		if (isalive(ai)&& ai istouching(trig))
		{
			ai dodamage( ai.health + 5, (0,0,0));
		}
		wait (1);
	}
}

setgoal1()
{
	trig = getent("setgoal1","targetname");
	
	node = getnode ("killnode1","targetname");
	
	while (1)
	{
		trig waittill ("trigger", ai);
		
		if (ai istouching(trig) && isalive(ai))
		{
			ai dodamage( 2, (0,0,0));
			ai setgoalnode (node);
		}
		wait (1);	
	}
}

rpg_fire()
{
	trigger = GetEnt( "rpgs", "target" );
	trigger waittill( "trigger" );

	spawners = GetEntArray( "rpgs", "targetname" );
	for( i = 0; i < spawners.size; i++ )
	{
		spawned = spawners[i] Stalingradspawn();
		if(spawn_failed( spawned ) )
		{
			continue;
		}

		spawned.targetname = "rpgs";
	}
	wait( 20 );
	
	guys = getentarray("rpgs","targetname");
	
	for (i = 0; i< guys.size; i++)
	{
		if(isalive(guys[i]))
		{
			guys[i] dodamage(guys[i].health + 50, (0,0,0));
		}
	}
}

// Music
music_track( track, delay )
{
	if( IsDefined( delay ) )
	{
		MusicStop( delay );
		wait( delay + 0.1 );
	}

	if( track == 1 )
	{
		MusicPlay( "proto_music1" );
	}
	else if( track == 2 )
	{
		MusicPlay( "proto_music2" );
	}
	else if( track == 3 )
	{
		MusicPlay( "proto_music3" );
	}
	else if( track == 4 )
	{
		MusicPlay( "proto_music4" );
	}
}

custom_introscreen( strings, outro )
{		
	level.player = GetEnt("player", "classname" );

	level.introblack = NewHudElem();
	level.introblack.x = 0;
	level.introblack.y = 0;
	level.introblack.horzAlign = "fullscreen";
	level.introblack.vertAlign = "fullscreen";
	level.introblack.foreground = true;

	if( IsDefined( outro ) )
	{
		level.introblack.alpha = 0;
	}

	level.introblack SetShader( "black", 640, 480 );

	if( IsDefined( outro ) )
	{
		level.introblack fadeOverTime( 2.0 );
		level.introblack.alpha = 1;
		wait( 3 );
	}

	level.player FreezeControls( true );
	wait( 0.05 );

	level.introstring = [];

	for( i = 0; i < strings.size; i++ )
	{
		maps\_introscreen::introscreen_create_line( strings[i] );
		if( !IsDefined( outro ) )
		{
			wait( 2 );

			if( i == strings.size - 1 )
			{
				wait( 2.5 );
			}
		}
	}

//	//Title of level
//	if( IsDefined( string1 ) )
//	{
//		maps\_introscreen::introscreen_create_line( string1 );
//	}
//	
//	if( isdefined( pausetime1 ) )
//	{
//		wait pausetime1;
//	}
//	else
//	{
//		wait( 2 );	
//	}
//	
//	//City, Country, Date
//	
//	if( IsDefined( string2 ) )
//	{
//		maps\_introscreen::introscreen_create_line( string2 );
//	}
//
//	if( IsDefined( string3 ) )
//	{
//		maps\_introscreen::introscreen_create_line( string3 );
//	}
//	
//	//Optional Detailed Statement
//	
//	if( isdefined( string4 ) )
//	{
//		if( isdefined( pausetime2 ) )
//		{
//			wait pausetime2;
//		}
//		else
//		{
//			wait 2;
//		}
//	}
//	
//	if( isdefined( string4 ) )
//		maps\_introscreen::introscreen_create_line( string4 );
//	
//	//if( isdefined( string5 ) )
//		//introscreen_create_line( string5 );
//	
//	level notify( "finished final intro screen fadein" );
//	
//	if( isdefined( timebeforefade ) )
//	{
//		wait timebeforefade;
//	}
//	else
//	{
//		wait 3;
//	}

	// Fade out black
	if( !IsDefined( outro ) )
	{
		level.introblack fadeOverTime( 1.5 ); 
		level.introblack.alpha = 0;
	}
	else
	{
		return;
	}

	level notify ( "starting final intro screen fadeout" );


	// Restore player controls part way through the fade in
	level.player freezeControls( false );
	level notify( "controls_active" ); // Notify when player controls have been restored

	// Fade out text
	maps\_introscreen::introscreen_fadeOutText();

	level notify( "introscreen_complete" ); // Notify when complete
}