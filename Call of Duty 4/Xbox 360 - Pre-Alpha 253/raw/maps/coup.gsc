#include maps\_utility;
#include maps\_anim;

main()
{
	precachemodel ("fx");
	maps\_luxurysedan::main("vehicle_luxurysedan_test");
	maps\_luxurysedan::main("vehicle_luxurysedan");
	maps\_load::main();
	maps\coup_anim::main();
	thread maps\coup_amb::main();

	flag_init("start_ride");
	flag_init("villians_ready");
	
	thread playerInit();

    setExpFog(0, 6000, .583, 0.632813 , 0.664063, 0.611385); 
	VisionSetNaked( "coup" );
	
	precachemodel("viewhands_player_usmc");
	
	musicPlay("music_coup_intro"); 
	thread moment_handler();
}

temp_prints(line1, line2, line3, line4)
{
	temp_killprints();
	level.intro_offset = 0;
	lines = [];
	if(isdefined(line1))
		lines[ lines.size ] = line1;
	
	if(isdefined(line2))
		lines[ lines.size ] = line2;
	
	if(isdefined(line3))
			lines[ lines.size ] = line3;
	
	if(isdefined(line4))
			lines[ lines.size ] = line4;


	for ( i=0; i < lines.size; i++ )
		maps\_introscreen::introscreen_corner_line( lines[ i ] );
	
	thread temp_prints_internal();
}

temp_prints_internal()
{
	level endon( "destroy_hud_elements" );	
	wait 3.5;
	temp_killprints();
}

temp_killprints()
{
	level notify( "destroy_hud_elements" );
}

moment_handler()
{
	level.txt = [];
	level.txt["red"] = (1,0,0);
	level.txt["blue"] = (0,0,1);
	level.txt["green"] = (0,1,0);
	level.txt["yellow"] = (1,1,0);
	
	thread moment_intro();
	
	flag_wait("villians_ready");
	
	moment_carintro();	
	thread moment_burningcar();
	thread moment_runforwall();
	thread moment_sidewalkrunners();
	thread moment_stoptruck();
	thread moment_firingaks1();
	moment_gatecheckpoint();
	thread moment_dogsdiggingthroughtrash();
	moment_truckunloading();
	moment_convoypass();
	thread moment_massacre();
	thread moment_dogsrunning();
	thread moment_loadingammo();
	thread moment_firingaks2();
	thread moment_spraypaint();
	thread moment_cellphone();
	thread moment_lineup();
	thread moment_trashdrop();
	thread moment_paperdrop();
	thread moment_heliflyby();
	thread moment_waves();
	thread moment_migflyby();
	thread moment_helitouchdown();
	thread moment_trip();
	moment_torture();
	moment_stairs();
	moment_hallway();
	moment_execution();
	moment_lastwords();
	
}

moment_intro()
{
	temp_prints("doors burst open and you're being", "dragged to the car by a man on each side");
	villians_spawn();
	moment_playerdrag();
}

villians_spawn()
{
	spawners = getentarray("test_riders","targetname");
	level.villians = [];
	ai =[];
	for(i=0; i<spawners.size; i++)
	{
		ai[i] = spawners[i] stalingradspawn();
		ai[i] thread magic_bullet_shield();
	}
	wait .1;
	
	level.villians["driver"] 	= ai[0];
	level.villians["driver"].animname = "driver";
	level.villians["shotgun"] 	= ai[1];
	level.villians["shotgun"].animname = "shotgun";
	level.villians["left"] 		= ai[2];
	level.villians["left"].animname = "left";
	level.villians["right"] 	= ai[3];
	level.villians["right"].animname = "right";
}

#using_animtree("generic_human");
moment_playerdrag()
{
	rig = create_drag_rig();
		
	level.villians["shotgun"] linkto (rig);
	level.villians["right"] linkto (rig);
	
	rig thread anim_loop_solo(level.villians["shotgun"], "drag_loop", "tag_origin", "stop_drag");
	rig thread anim_loop_solo(level.villians["right"], "drag_loop", "tag_origin", "stop_drag");
	rig thread anim_loop_solo(rig, "drag_loop", "tag_origin", "stop_drag");
	level.player playerlinktodelta(rig.camera, "tag_origin", 1, 50, 60, 25, 30);//right, left, top, bottom
	level.player allowprone(false);
	level.player allowcrouch(false);
	//level.player thread anim_loop_solo(level.player, "coup_opening_playerview"
	
	wait .05;
	
	link = spawn("script_origin", rig.origin);
	link.angles = rig.angles;
	rig linkto(link);
	
	link moveto(level.playersride.origin + (0,0,4), 11);
	link thread tempbob();
	
	flag_wait("start_ride");
	rig notify("stop_drag");
	level.player unlink();
}

moment_player_drag2()
{
	rig = create_drag_rig();
	level.villians["shotgun"] unlink();
	level.villians["right"] unlink();
	level.villians["shotgun"].testnode notify("stop_loop");
	level.villians["right"].testnode notify("stop_loop");
	level.villians["shotgun"] linkto (rig);
	level.villians["right"] linkto (rig);
	
	rig.origin += (0,0,-64);
	
	rig thread anim_loop_solo(level.villians["shotgun"], "drag_loop", "tag_origin", "stop_drag");
	rig thread anim_loop_solo(level.villians["right"], "drag_loop", "tag_origin", "stop_drag");
	rig thread anim_loop_solo(rig, "drag_loop", "tag_origin", "stop_drag");
	level.player playerlinktodelta(rig.camera, "tag_origin", 1, 50, 60, 25, 30);
	
	link = spawn("script_origin", rig.origin);
	link.angles = rig.angles;
	rig linkto(link);
	
	link tempmove("fudgemove");
	level.villians["shotgun"] stop_magic_bullet_shield();
	level.villians["right"] stop_magic_bullet_shield();
	level.villians["shotgun"] delete();
	level.villians["right"] delete();
	link rotateyaw(180, 1);
}

tempmove(name)
{
	node = getent(name, "targetname");
	origin = node.origin;
	node = getent(node.target, "targetname");
	time = 1.25;
	time2 = .6;
	roll = 2;
	while(1)
	{
		ang = vectortoangles( vectornormalize( node.origin - origin ) );
		
		self moveto(node.origin + (0,0,-64), time);
		
		self rotateto( (self.angles[0],ang[1],self.angles[2]) , time);
		
		wait time;
		
		if(!isdefined(node.target))
			break;
		origin = node.origin;
		node = getent(node.target, "targetname");
	}
}

tempbob()
{
	time = .6;
	roll = 2;
	while( !flag("start_ride") )
	{
		self rotateto( (self.angles[0],self.angles[1],roll), time, time * .5, time * .5); 
		wait time;	
		self rotateto( (self.angles[0],self.angles[1],(roll * -1)) , time, time * .5, time * .5); 
		wait time;	
	}
}

#using_animtree("player");
create_drag_rig()
{
	rig = spawn("script_model", level.player.origin);
	rig.angles = level.player.angles;
	rig setmodel("viewhands_player_usmc");
	rig.animname = "player_rig";
	rig UseAnimTree(#animtree);
	
	rig.camera = spawn("script_model", rig gettagorigin("tag_player") );
	rig.camera.angles = rig gettagangles("tag_player");
	rig.camera setmodel("tag_origin");
	
	rig.camera linkto(rig, "tag_player", (10,0,0), (0,0,0));
	
	//rig hide();
	return rig;
}

playerInit()
{	
	level.player takeAllWeapons();
	level.player.ignoreme = true;
	level.playersride = getent("playersride","targetname");
	offset = vector_multiply(anglestoforward(level.playersride.angles), -23);
//	offset +=vector_multiply(anglestoright(playersride.angles), 20);
	offset += (0,0,8);
	trigger = spawn( "trigger_radius", level.playersride.origin+ (0,0,-50), 0, 180, 1024 );
	trigger waittill ("trigger");
	
	flag_set("start_ride");
	waittillframeend;
	org = spawn("script_model",level.playersride.origin);
	org.origin = level.playersride.origin + offset;
	org.angles = level.playersride.angles;
	org setmodel ("fx");
	org hide();
//	origin linkto (playersride,"tag_body", offset,playersride.angles);
	org linkto (level.playersride, "tag_body", (-27, 0, -24), (0,0,0));
	level.player player_fudge_moveto(org gettagorigin("Trim_Char_F_1_1"));
	level.player playerlinktodelta(org, "Trim_Char_F_1_1", 1, 360, 360, 60, 15);
	setsaveddvar("cg_fov", 50);
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );	
	thread maps\_vehicle::gopath(level.playersride);
	
	org test_riders();
	
	flag_set("villians_ready");
	
	level.playersride waittill("reached_end_node");
	wait 1;
	setsaveddvar("cg_fov", 65);
	setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "" );	
	level.player allowprone(true);
	level.player allowcrouch(true);
	level.player unlink();
	player_fudge_moveto(getent("fudgemove","targetname").origin);
	
	moment_player_drag2();
}

test_riders()
{	
	
	keys = getArrayKeys( level.villians );
	
	for ( i=0; i < keys.size; i++ )
	{
		level.villians[keys[i]].testnode = spawn("script_model", self.origin);
		level.villians[keys[i]].testnode.angles = self.angles;
		level.villians[keys[i]].testnode setmodel("tag_origin");
		level.villians[keys[i]] linkto( level.villians[keys[i]].testnode );
	}
	
	level.villians["driver"].testnode 	linkto(self, "Trim_Char_F_1_1", (-97,-72,23), (0,0,0));
	level.villians["shotgun"].testnode 	linkto(self, "Trim_Char_F_1_1", (-97,-108,23), (0,0,0));
	level.villians["left"].testnode 	linkto(self, "Trim_Char_F_1_1", (-131,-70,23), (0,0,0));
	level.villians["right"].testnode 	linkto(self, "Trim_Char_F_1_1", (-131,-110,23), (0,0,0));
	
	for ( i=0; i < keys.size; i++ )
		level.villians[keys[i]].testnode thread anim_loop_solo(level.villians[keys[i]], "car_idle", "tag_origin", "stop_loop");
}

moment_carintro()
{
	level.playersride setspeed(0, 100);
	
		
	temp_prints("the driver changes the radio", "station and gets the speech");
	wait 2.5;	
	level.playersride resumespeed(15);
	temp_prints("guy on left loads an ak clip with ammo", "guy on right smokes a cigarette");
}

moment_burningcar()
{
	wait 2;
	print3d( (1525, 487, 60), "car on fire", level.txt["red"], 1, 1, 7 * 20);
}

moment_runforwall()
{
	wait 4;
	print3d( (2978, 408, 121), "guy runs for the wall", level.txt["yellow"], 1, 2, 5 * 20);	
	wait 1.5;
	print3d( (2975, 665, 149), "and gets pulled down here", level.txt["yellow"], 1, 2, 5 * 20);
}

moment_sidewalkrunners()
{
	wait 5;
	print3d( (3385, 362, 125), "3 guards running", level.txt["green"], 1, 1, 5 * 20);
}

moment_stoptruck()
{
	wait 6;
	print3d( (3825, 515, 114), "soldier shouting at driver of this truck", level.txt["green"], 1, 1, 7 * 20);
}

moment_firingaks1()
{
	wait 10;
	print3d( (6774, 560, 133), "guys jeering and firing AK's into the sky", level.txt["red"], 1, 3, 20 * 20);
}

moment_gatecheckpoint()
{
	node = getvehiclenode("gate_crossing", "script_noteworthy");
	level.playersride setwaitnode(node);
	level.playersride waittill("reached_wait_node");	
	
	level.playersride setspeed(0, 15);
	
	print3d( (4531, 842, 148), "2 soldiers standing at gated checkpoint", level.txt["yellow"], 1, 1, 20 * 20);
	
	temp_prints("the guard walks over and has a conversation with the driver", "his dog runs over and starts barking at the window");
	wait 3;
	temp_prints("the guard then looks over at you and comes", "over to the back window, pushing his dog away");
	wait 3;
	temp_prints("he leans in and spits in your face,", "then motions over to the other guard to open the gate");
	wait 3;
	
	level.playersride resumespeed(15);
}

moment_dogsdiggingthroughtrash()
{
	wait 3;
	print3d( (4191, 2043, 324), "dogs digging through the trash", level.txt["green"], 1, 2, 7 * 20);
}

moment_truckunloading()
{
	node = getvehiclenode("truck_unloading", "script_noteworthy");
	level.playersride setwaitnode(node);
	level.playersride waittill("reached_wait_node");	
	
	level.playersride setspeed(0, 15);	
	
	print3d( (3874, 3681, 470), "truck blocking the road, unloading troops", level.txt["yellow"], 1, 1, 20 * 20);
	
	temp_prints("Soldiers unload out of the back of the truck and", "start banging on doors to people homes and bursing in");
	wait 3;
	temp_prints("The guy to your left steps out of the", "car yelling at the truck to move it.");
	wait 3;
	temp_prints("Eventually, the truck pulls off onto the sidewalk");
	wait 2;
	
	level.playersride resumespeed(15);
}

moment_convoypass()
{
	node = getvehiclenode("convoy_pass", "script_noteworthy");
	level.playersride setwaitnode(node);
	level.playersride waittill("reached_wait_node");	
	
	level.playersride setspeed(0, 15);	
	
	print3d( (4236, 5470, 506), "convoy passes by to the left", level.txt["green"], 1, 1, 15 * 20);
	
	temp_prints("jeep pulls up and a guy gets out holding", "out his hand while a convoy passes by");
	wait 5;
	temp_prints("if we look back right now, we'll still see", "soldiers banging on peoples doors and dragging some out");
	wait 5;
	
	level.playersride resumespeed(15);
}

moment_massacre()
{
	wait 5;
	print3d( (6596, 6901, 655), "a row of dead bodies with blood splattered on the walls", level.txt["red"], 1, 2, 5 * 20);
	temp_prints("guy to your right flicks his cigarette", "out the window and lights another one");
}

moment_dogsrunning()
{
	wait 10;
	print3d( (6836, 8278, 628), "dogs jog by", level.txt["green"], 1, 2, 5 * 20);
}

moment_loadingammo()
{
	wait 14;
	print3d( (6796, 9464, 508), "guys loading crates into truck", level.txt["yellow"], 1, 2, 5 * 20);
}

moment_firingaks2()
{
	wait 21;
	print3d( (3586, 10194, 439), "big fire, 20 guys firing AK's into the sky", level.txt["red"], 1, 3, 5 * 20);
}

moment_spraypaint()
{
	wait 25;
	print3d( (3766, 12959, 446), "guys spray-painting grafiti", level.txt["green"], 1, 2, 5 * 20);
}

moment_cellphone()
{
	wait 29;
	temp_prints("the guy to your left gets a call on", "his cell phone, and talks for a few.");
	wait 3;
	temp_prints("He the passes the phone to", "the guy sitting shotgun");
}

moment_lineup()
{
	wait 33;
	print3d( (5741, 15042, 395), "line up of civilians, 2 guards walking the line", level.txt["green"], 1, 2, 5 * 20);
}

moment_trashdrop()
{
	wait 40;
	print3d( (6479, 17524, 415), "burning pile", level.txt["red"], 1, 2, 5 * 20);
	print3d( (6451, 17665, 654), "tv's, desks, chairs being thrown out the windows", level.txt["yellow"], 1, 2, 5 * 20);
}

moment_paperdrop()
{
	wait 50;
	print3d( (532, 17234, 870), "burning paper falling", level.txt["yellow"], 1, 5, 15 * 20);
}

moment_heliflyby()
{
	wait 51;
	print3d( (-128, 17284, 834), "2 heli's fly by", level.txt["green"], 1, 5, 5 * 20);
}

moment_waves()
{
	wait 60;
	print3d( (-721, 17302, 361), "huge waves crash", level.txt["yellow"], 1, 3, 5 * 20);
}

moment_migflyby()
{
	wait 63;
	print3d( (-1113, 13085, 1403), "2 mig's fly by", level.txt["green"], 1, 5, 5 * 20);
}

moment_helitouchdown()
{
	wait 70;
	print3d( (-5680, 14408, 926), "large heli lands", level.txt["green"], 1, 5, 5 * 20);
}

moment_trip()
{
	wait 86;
	print3d( (-3520, 9009, 475), "guards line the walls", level.txt["yellow"], 1, 1, 5 * 20);
	wait 3;
	temp_prints ("you get shoved to the ground and roll up", "then get a swift boot to the face. everyone laughs");
}

moment_torture()
{
	trigger = getent("moment_torture","targetname");
	trigger waittill("trigger");	
	temp_prints ("The walls are lined with tiny barred windows", "Sounds of people getting beat up, tortured,", "and whimpering in pain");
}

moment_stairs()
{
	trigger = getent("moment_stairs","targetname");
	trigger waittill("trigger");
	print3d( (-5597, 8872, 548), "smoking guard, waves to you", level.txt["green"], 1, 1, 5 * 20);
	print3d( (-5890, 8927, 448), "2 guard talking", level.txt["yellow"], 1, 1, 5 * 20);
}

moment_hallway()
{
	trigger = getent("moment_hallway","targetname");
	trigger waittill("trigger");
	temp_prints ("echoing footstep sounds");
}

moment_execution()
{
	trigger = getent("moment_execution","targetname");
	trigger waittill("trigger");
	print3d( (-6847, 8916, 440), "Al Asad giving speech", level.txt["green"], 1, 1, 120 * 20);
	print3d( (-6675, 9211, 440), "Revolver Ocelot looking hard", level.txt["yellow"], 1, 1, 120 * 20);
}

moment_lastwords()
{
	trigger = getent("moment_lastwords","targetname");
	trigger waittill("trigger");
	wait 2.5;
	temp_prints ("al asad grabs a gun from the russian", "and shoots you in the face");
}

