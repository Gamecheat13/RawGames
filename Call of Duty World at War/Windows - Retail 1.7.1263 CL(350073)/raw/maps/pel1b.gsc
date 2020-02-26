#include common_scripts\utility; 
#include maps\_utility;
#include maps\_anim;
#include maps\_music;
#using_animtree ("generic_human");


/*
=================
All the level precaching goes here.
=================
*/
do_precaching()
{
	precacheShellShock("teargas");
	precacheModel("weapon_ger_panzershreck_rocket");
	precachemodel("weapon_usa_explosive");	
	precachemodel("aircraft_bomb");
	precachemodel("char_usa_marine_radiohandset");
	precacheRumble( "artillery_rumble" );
	precacheRumble( "explosion_generic" );
	precacheRumble( "damage_heavy" );
	precacheRumble( "tank_rumble" );
	precacheModel("projectile_us_smoke_grenade");
}


main()
{
	// objective flags
	flag_init( "art_1_destroyed" );
	flag_init( "art_2_destroyed" );
	flag_init( "tank3_reached" );
	
	// trap guy flags
	flag_init("guy_trapped");
	flag_init("guy_trapped2");

	// adding a flag to tank destruction event
	flag_init("flametank_destroy_trig");

	// flag to check if the player has finished the artillery objectives
	flag_init("event1_objectives_done");

	// flag to initiate the script, for the second area on the tank 
	flag_init("flametank_in_second_area");

	// outr flags
	flag_init("roebuck_reached_outro");
	flag_init("polonsky_reached_outro");
	flag_init("radio_guy_reached_outro");

	// dialogue
	flag_init("start_dialogue");
	
	// Level Inits
	maps\pel1b_fx::main();
	
	// level precaching
	do_precaching();

	// vehicle init
	maps\_sherman::main( "vehicle_usa_tracked_shermanm4a3_camo" );
	maps\_artillery::main("artillery_jap_47mm", "at47");
	maps\_sherman::main( "vehicle_usa_tracked_shermanm4a3_camo","sherman_flame" );
	maps\_aircraft::main( "vehicle_usa_aircraft_f4ucorsair", "corsair" );
	maps\_triple25::main("artillery_jap_triple25mm", "triple25");
	maps\_p51::main( "vehicle_p51_mustang" );
	maps\_model3::main( "artillery_jap_model3" );

	// destructible_init
	maps\_destructible_type94truck::init();

	// drones
	character\char_jap_makpel_rifle::precache();
	character\char_usa_marine_r_rifle::precache();
	level.drone_spawnFunction["axis"] = character\char_jap_makpel_rifle::main;
	level.drone_spawnFunction["allies"] = character\char_usa_marine_r_rifle::main; 	
	maps\_drones::init();	

	default_start( ::event1_dogAttack );

/#
	add_start("ArtilleryKill", ::event1_dogAttack, &"STARTS_PEL1B_EVENT1");
	add_start("ArtilleryKilla", ::event1a_skipto_setup, &"STARTS_PEL1B_EVENT1A");
	add_start("FlameDeath", ::event1b_skipto_setup, &"STARTS_PEL1B_EVENT1b");
	add_start("outro", ::outro_skipto_setup, &"STARTS_PEL1B_OUTRO");
#/

	// Custom Introscreen pointer
	//level.custom_introscreen = ::pel1b_custom_introscreen; 

	//skip to setup
	level.startskip = "event1";
	
	// _load
	maps\_load::main();
	
	// banzai init	
	maps\_banzai::init();

	// tree snipers
	maps\_tree_snipers::main();	

	// mganim script
	maps\_mganim::main();
	
	// load the animations
	maps\pel1b_anim::main();
	
	// global levelvars
	level.maxfriendlies = 6;
	
	// CO-OP Optimization
	if( NumRemoteClients() > 1 )
	{
		// cap the AI count or more than 2 player co-op game.
		SetAiLimit( 24 );
	}
	
	// threatbias group setups
	createthreatbiasgroup("players");
	createthreatbiasgroup("heroes");
	
	// hero setup
	level.heroes    = [];
	
	level.sarge     = getent("sarge", 	"script_noteworthy");
	level.heroes[0] = level.sarge;
	
	level.walker 	= getent("walker", 		"script_noteworthy");
	level.heroes[1] = level.walker;

	level.sarge 	setthreatbiasgroup("heroes");	
	level.walker 	setthreatbiasgroup("heroes");	
	
	level.allies = [];
	level.allies = getentarray("starting_allies", "targetname");

	// set allies to ignore everything at first
	players_ignoreall( level.allies, 1 );

	// setup magic bullet shield on the hero's
	array_thread( level.heroes, ::magic_bullet_shield );
	
	// spawn functions set-up
	level thread setup_spawn_functions();

	//start ambient packages
	level thread maps\pel1b_amb::main();

	// right side battle setup
	createthreatbiasgroup( "friendlies_right_side" );
	createthreatbiasgroup( "japs_on_right_art" );
	createthreatbiasgroup( "japs_on_hut" );

	setignoremegroup("friendlies_right_side", "japs_on_right_art");
	setignoremegroup("japs_on_right_art", "friendlies_right_side");
	
}

/*
==============================================================================================================
Event1 Functions
==============================================================================================================
*/

event1_dogAttack()
{
	//Glocke - wait for the first player before letting all the script continue
	flag_wait("all_players_connected");
	
	wait(0.1);
	freezecontrols_all( false ); //-- locked by the introscreen
	
	//Glocke: putting this here, because it doesn't seem to be updating early enough
	players = get_players();
	for( i=0; i < players.size; i++)
	{
		// restrict the movement
		players[i] AllowCrouch( false ); 
		players[i] AllowProne( false ); 
		players[i] AllowStand( true ); 
	}
	
	wait(0.5);
	freezecontrols_all( true );  //-- relock because we haven't faded out yet
	
	
	
	// sets up dialogue
	level thread in_game_dialogue_setup();
	
	level thread event1_battlechatter();

	level thread event1_set_start_position();

	// hide all the hud stuff and scoreboard
	level thread event1_hide_hud();
	level thread event1_show_hud();
	
	level.event1 = true;
	level.tank2 = getent("tank2", "targetname");
	level.tank3 = getent("tank3", "targetname");	
	level.flametank = getent("flametank", "targetname");

	// thread that keeps the tanks alive
	level.flametank thread keep_flametank_alive();
	level.tank3 thread keep_tank_alive();
	

	// start the tanks before the fading screen, with the players riding the tanks.
	level thread event1_startothertanks();
	level thread event1_tank3_targets_link();
	level thread event1_player_ride_think();
	level thread event1_ai_ride_think();

	level thread event1_setup_aa_gun();

	//level waittill("finished final intro screen fadein");

	level thread event1_Objectivewaiter();
	level thread event1_objective_blocker();
	level thread event1_artillaryattack();
	level thread event1_right_artsetup();

	// TEMP - removed the plane crash - have to think about this later.
	//level thread event1_bomber_crash();
	
	level thread event1_followtanks();

	//clean up of event 1 - kills all ai once player moves upto the trench.
	level thread event1_cleanup();
	
	// CO-OP optimization 
	level thread event1b_friendlies_cleaup1_co_op();

	// start event1 objective thread
	level thread event1_objective_thread_right_art(); // objective on right art
	level thread event1_objective_thread_left_art(); // objective on left art
	level thread event1_objective_thread_follow_squad(); // objective to get into second area

	// POW event
	level thread event1_held_guy();

	// setup planes
	level thread event1_ambient_planes_setup();

	//level thread log_trap_thread();
	level thread snare_trap_thread();

}

// Hud related stuff
event1_hide_hud()
{
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", "0" ); 
		player SetClientDvar( "compass", "0" ); 
		player SetClientDvar( "ammoCounterHide", "1" );
		player setclientdvar("miniscoreboardhide","1");
	}
}

event1_show_hud()
{
	level waittill("tank2_attacked");
	
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", "1" ); 
		player SetClientDvar( "compass", "1" ); 
		player SetClientDvar( "ammoCounterHide", "0" );
		player setclientdvar("miniscoreboardhide","0");
	}
}


// links targets where right side AT gun will fire to tank3
event1_tank3_targets_link()
{
	level.tank3_targets = getentarray("tank2_firepoints", "targetname");

	for(i=0;i<level.tank3_targets.size - 1;i++)
		level.tank3_targets[i] linkto(level.tank3);

	// final attack target linking
	targetpos = getent("tank2_firepoints_final","targetname");
	targetpos linkto(level.tank3);
}

event1_battlechatter()
{
	//TUEY SetMusic State to "INTRO"
	setmusicstate("INTRO");

	thread battlechatter_off( "allies" );
	thread battlechatter_off( "axis" );
	
	level waittill( "tank2_attacked" );
	
	//TUEY SetMusic State to "INTRO"
	setmusicstate("FIRST_FIGHT");

	thread battlechatter_on( "allies" );
	thread battlechatter_on( "axis" );
}

event1_set_start_position()
{
	players	= get_sorted_players();
	player_starts = get_sorted_starts();

	for ( i = 0; i < players.size; i++ )
	{
		players[i] SetOrigin( player_starts[i].origin ); 
		players[i] SetPlayerAngles( player_starts[i].angles ); 
	}

}


event1_objectivewaiter()
{
	self waittill("tank2_attacked");

	// set objective on the left artillery
	art_on_left = getent("event1_art_left","targetname");
	thread set_objectives( 1 );

}

event1_startothertanks()
{
	// tank2 moves up
	tank2_trig = getent("tank2start", "targetname");
	tank2_trig notify("trigger");

	// tank3 moves up
	tank3_trig = getent("tank3start", "targetname");
	tank3_trig notify("trigger");
	
	wait(2);
	
	// flametank moves up
	tank1_trig = getent("tank1start", "targetname");
	tank1_trig notify("trigger");
	
	thread event1_flame_tank_waiter();

	player_unblocker = getvehiclenode("auto3683", "targetname");
	player_unblocker waittill("trigger");

	// Player starts moving.	
	event1_unlockplayer();
	event1_guys_with_player_follow_tanks();
}


// Need Animations of dismounting ( 1st and third person )
event1_player_ride_think()
{
	// tags where players are going to fall down
	tags = getentarray("player_dismount_points","targetname");

	for (i=0; i<tags.size; i++ )
	{	
		// link tags to perticular tank ( either flametank or tank2 )
		if ( issubstr(tags[i].script_noteworthy,"flametank" ) )
			tags[i] linkto( level.flametank );
		else if ( issubstr(tags[i].script_noteworthy,"tank2" ) )
			tags[i] linkto( level.tank3 );  
	}

	// get all the player available in the game
	players	= get_sorted_players();

	// start placing guys on tag 8 of flametank
	passenger_pos = 8;
		
	// process first two players - riding flametank
	for ( i = 0; i < 2; i++ )
	{
		// check if there is any player
		if ( isdefined( players[i] ) )
		{
			// restrict the movement
			//players[i] AllowCrouch( true ); 
			//players[i] AllowProne( false ); 
			//players[i] AllowStand( false ); 
			
			// put first two players on flametank
			link_tag = "tag_passenger" + passenger_pos;
			fall_tag = getent( "flametank_" + link_tag, "script_noteworthy" );

			// set players angles same as tag
	 		org 	= level.flametank gettagOrigin (link_tag);
			angles  = level.flametank gettagangles (link_tag);

			// spawn in an origin for player 3rd person angles, and link it to flametank
			players[i].lvt_linkspot_ref = spawn("script_origin", org);
	
			if ( passenger_pos == 8  )
				players[i].lvt_linkspot_ref linkto( level.flametank, link_tag, (0,0,0), (0,80,0) );
			else
				players[i].lvt_linkspot_ref linkto( level.flametank, link_tag, (0,0,0), (0,280,0) );	
						
			// disable weapons and link the player to tank
			players[i] DisableWeapons();
			players[i] PlayerLinkToDelta( players[i].lvt_linkspot_ref, undefined, 1 );
				
			players[i] setorigin (org);
			players[i] setplayerangles ( angles );
						
			// Play 3rd person animations on the player
			players[i] thread player_combatidleanimloop( link_tag );
			players[i] thread player_combatdismountanimloop( link_tag );
	
			// start the dismount thread, tell it where to fall when attacked
			players[i] thread event1_player_tank_dismount( players[i], fall_tag );
			
			// next tag
			passenger_pos++;
		}
	
	}

	// start placing guys on tag 8 of tank2
	passenger_pos = 8;
	
	// process next two players - riding tank2
	for ( i = 2; i < 4; i++ )
	{
		// check if there is any player
		if ( isdefined( players[i] ) )
		{
			// restrict the movement
			//players[i] AllowCrouch( true ); 
			//players[i] AllowProne( false ); 
			//players[i] AllowStand( false ); 
			
			// put next two players on tank2
			link_tag = "tag_passenger" + passenger_pos;
			fall_tag = getent( "tank2_" + link_tag, "script_noteworthy" );

			// set players angles same as tag
	 		org 	= level.tank3 gettagOrigin (link_tag);
			angles  = level.tank3 gettagangles (link_tag);

			// spawn in an origin for player 3rd person angles, and link it to flametank
			players[i].lvt_linkspot_ref = spawn("script_origin", org);
	
			if ( passenger_pos == 8  )
				players[i].lvt_linkspot_ref linkto( level.tank3, link_tag, (0,0,0), (0,80,0) );
			else
				players[i].lvt_linkspot_ref linkto( level.tank3, link_tag, (0,0,0), (0,280,0) );
	
			// disable weapons and link the player to tank
			players[i] DisableWeapons();
			players[i] PlayerLinkToDelta( level.tank3, link_tag, 1 );
						
			players[i] setorigin (org);
			players[i] setplayerangles ( angles );
			
			// Play 3rd person animations on the player
			players[i] thread player_combatidleanimloop( link_tag );
			players[i] thread player_combatdismountanimloop( link_tag );
	
			// start the dismount thread, tell it where to fall when attacked
			players[i] thread event1_player_tank_dismount( players[i], fall_tag );
			
			// next tag
			passenger_pos++;
		}
	
	}

}


player_combatidleanimloop(link_tag)
{
	self endon("dismounted");

	//time =  getanimlength( %crew_sherman_passenger9_combatidle_player );
	//time = time - 0.1;
	if ( issubstr( link_tag, "8" ) )
	{	
		self playeranimscriptevent( "sherman_ride_player_combat_idle_8" ); 
	}
	else
	{
		self playeranimscriptevent( "sherman_ride_player_combat_idle_9" ); 
	}
	
}


player_combatdismountanimloop(link_tag)
{
	self waittill("attacked");
	// Hide the player model until the animsctipted event on the player is over.
	self hide();
	wait(16);
	self show();
}



event1_player_tank_dismount( player,fall_tag )
{
	level waittill("tank2_attacked");

	hud = newClientHudElem(player);
	hud.alignX = "center";
	hud.x = 450;
	hud.y = 300;
	hud.alignX = "right";
	hud.alignY = "bottom";
	hud.fontScale = 1.5;
	hud.alpha = 1.0;
	hud.sort = 20;
	hud.font = "default";
	
	if( level.console )
		hud SetText(&"PEL1B_PLAYER_DISMOUNT");
	else
		hud SetText(&"SCRIPT_PLATFORM_PEL1B_PLAYER_DISMOUNT");

	player thread event1_tank_explosion_effect();

	// create a timer flag on the player, will dismount player if this timer goes off
	player.dismount_timer_over = false;

	// create a thread for timer
	player thread dismount_timer();

	// stop the animscripted event on the player early so that the other players will not be able to see the
	// player into the ground
	player notify("attacked");

	while( ( !player useButtonPressed() ) && ( player.dismount_timer_over != true ) )
	{		
		wait(0.05);
	}

	player notify("dismounted");

	hud settext("");

	player unlink();
	fall_tag unlink();

	player SetOrigin( fall_tag.origin + ( 0, 0, 0 ) ); 
	
	// Fixed a bug where players are getting crooked angles.
	angles = ( fall_tag.angles[0], fall_tag.angles[1], 0.0 );
	fall_tag.angles = angles;

	player SetPlayerAngles( fall_tag.angles ); 
	
	player AllowProne( true ); 
	player AllowCrouch( true ); 
	player AllowStand( true ); 
			
	wait(RandomFloatRange( 3.0,5.0 ));
	
	player enableWeapons();

	hud destroy();
}

dismount_timer()
{
	timer = gettime() + ( 2 * 1000 );

	while(getTime() < timer)
	{
		wait(0.05);
	}

	// timer is over set the dismount flag on the player
	self.dismount_timer_over = true;
}

event1_tank_explosion_effect()
{
	Earthquake( RandomFloatRange(0.5, 1.5 ), 1, self.origin, 1000 );
	self shellshock("tankblast", randomfloatrange(9, 12));
	self PlayRumbleOnEntity( "artillery_rumble" );
	
	self thread set_all_players_double_vision( 2, 1 ); 
	self thread set_all_players_blur( 2, 1 ); 
	
	wait(5);

	self thread set_all_players_double_vision( 0, 1 ); 
	self thread set_all_players_blur( 0, 1 ); 
}	

event1_artillaryattack()
{
	//spawn the left artillery before the tanks get attacked.
	//event1_artillery_trig = getent("event1_artillery_left_trig", "targetname");
	//event1_artillery_trig notify("trigger")	;
	
	thread event1_tank2_attacked();
	thread event1_tank3_attacked();
}

event1_right_artsetup()
{
	//trig = getent("event1_japs_flow_4", "targetname");
	//trig waittill("trigger");

	art_on_right = maps\_vehicle::waittill_vehiclespawn( "event1_art_right" );

	wait(2);

	art_on_right = getent("event1_art_right","targetname");

	random_target = randomintrange( 0, level.tank3_targets.size - 1 );
	art_on_right setTurretTargetEnt( level.tank3_targets[random_target] );

	//arty fire stopper	
	art_on_right thread  event1_right_art_stop_fire();

	// arty fire	
	art_on_right thread event1_arty_fire();
}

event1_setup_aa_gun()
{
	aa_gun = maps\_vehicle::waittill_vehiclespawn( "aa_gun_bunker" );

	// setup gun firing in the air loop
	aa_gun thread event1_aa_gun_fire();

	// setup the dismount on death or trigger
	aa_gun thread event1_aa_gunner_alert();
}

event1_aa_gun_fire()
{
	self endon("crew dead");

	targetent = getentarray("event1_aa_gun_target", "targetname");
	
	while(!flag("tank2_move_1"))
	{
		self notify("change target");
		self thread maps\_triple25::triple25_shoot(targetent[randomintrange( 0, targetent.size - 1 )]);		
		wait(randomintrange(0,5));	
	}
	
}


event1_aa_gunner_alert()
{
	wait(2);

	// trigger that will cause the alert dismount for the gunners
	trig = getent("test","script_noteworthy");
	
	// dismount think trig	
	thread maps\_triple25::dismount_think(trig, self.triple25_gunner[0], self);
	thread maps\_triple25::dismount_think(trig, self.triple25_gunner[1], self);

	// waittill crew is dismounted
	self waittill_either("crew dismount", "crew dead");
	
	// make the aa gun usable from now on for the player - Thanks to James S for help.
	if( self.health )
	{
		self clearturrettarget();
		self makevehicleusable();
	}
}

event1_followtanks()
{		
	guys = [];

	guys[0] = getent("guys_following_tank2_1", "script_noteworthy");
	guys[1] = getent("guys_following_tank2_2", "script_noteworthy");
	guys[2] = getent("guys_following_tank3_1", "script_noteworthy");
	guys[3] = getent("guys_following_tank3_2", "script_noteworthy");
	
	event1_followtankInternal( level.tank2, 2, guys[0] );
	event1_followtankInternal( level.tank2, 1, guys[1] );
	event1_followtankInternal( level.tank3, 2, guys[2] );
	event1_followtankInternal( level.tank3, 1, guys[3] );
}


event1_unlockplayer()
{
	blocker = [];
	blocker = getentarray("player_blocker", "targetname");
	for(i=0; i<blocker.size; i++)
	{
		blocker[i] delete();
	}
}

// heros start moving with the tanks
event1_guys_with_player_follow_tanks()
{
	//first_color_trig = getent("first_color_trig", "targetname");
	//first_color_trig notify("trigger");
}


event1_tank2_attacked()
{

	// thread magic bullet shiled so that guys dont die 
	riding_guys = getentarray ("passenger_"+ level.tank2.targetname, "targetname");
	//magic_bullet_to_keep_guys_alive(riding_guys);

	//artillery starts firing.
	thread event1_artillary_fire();

	// mis - fire attack on tank2
	tank2_first_attack = getvehiclenode("auto3590", "targetname");
	tank2_first_attack waittill("trigger");	

	// fake trail effect attacking the tank2	
	shreck_start_pos = getstruct("shreck_start", "targetname");
	shreck_end_pos = getstruct("shreck_end", "targetname");
	thread fire_shrecks( shreck_start_pos, shreck_end_pos, 1);
	
	// fake trail effect supposed to be passing by the players tank, just to show him the treat.
	shreck_start_pos = getstruct("shreck_start2", "targetname");
	shreck_end_pos = getstruct("shreck_end2", "targetname");
	thread fire_shrecks( shreck_start_pos, shreck_end_pos, 1);
	
	level notify("incoming");

	wait(1)	;
	
	level notify("tank2_attacked");

	// riders on the tank.7/21/2008 2:44:59 PM
	thread event1_riders_take_cover_and_die();

	// ai's run to the covers
	thread event1_ai_takes_cover_behind_rocks();

	// ai starts taking on to the japs
	players_ignoreall( level.allies, 0 );

	thread event1_kill_if_riders_are_alive( level.tank2 );
		
	tank2_second_attack = getvehiclenode("auto3578", "targetname");
	tank2_second_attack waittill("trigger");
	
	fire_shrecks_with_damage( level.tank2, level.tank2.health + 200 );
	
	level.tank2 disconnectpaths();

	wait(1);

	// move the friendlies to the first cover to the g1 position.
	friendlies_move = getent("second_color_trig","targetname");
	friendlies_move notify("trigger");

	// Trigger the first wave of the japanese by hand so that in co-op if the players hand 
	japs_first_wave();
}

japs_first_wave()
{
	// this will get the first wave of japs going
	trig_jap_first_wave = getent("first_jap_attack_trig","script_noteworthy");
	trig_jap_first_wave notify("trigger");

	wait_network_frame();

	// this will trigger the grass_guys too
	grass_trig = getent("grass_guy_trig","targetname");
	grass_trig notify("trigger");

}



event1_kill_if_riders_are_alive(tank)
{

	riding_guys = getentarray ("passenger_"+ tank.targetname, "targetname");

	thread 	event1_tank3_riders_explosion_death(riding_guys);
	
	if( riding_guys.size > 0 )
	{
			
		for(i=0;i<riding_guys.size;i++)
		{
			if(isdefined(riding_guys[i]) && isalive(riding_guys[i]) )
			{
				thread event1_rider_dismount_anim( tank, riding_guys[i], "unloaded"+i );
			}
		}
	}

	waittill_multiple("unloaded0","unloaded1","unloaded2");
	level notify("unload_done");
}

event1_tank3_riders_explosion_death(riding_guys)
{
	level waittill ("unload_done");

	//stop_magic_bullet(riding_guys);
 
	for(i=0;i<riding_guys.size;i++)
	{
		if(isdefined(riding_guys[i]) && isalive(riding_guys[i]) )
		{	
			riding_guys[i].deathanim = level.explosion_anim["explosion_death"][i];
			riding_guys[i] dodamage(riding_guys[i].health + 100, riding_guys[i].origin);
		}
	}
}

event1_bomber_crash()
{
	crash_plane = maps\_vehicle::waittill_vehiclespawn( "event1b_crashing_plane1" );

	hitnoode = getvehiclenode("auto5004", "targetname");
	hitnoode waittill("trigger");

	looper = PlayFXOnTag( level._effect["bomber_wing_hit"], crash_plane,"tag_origin" );

	// bomber hit the ground - time for earthquake
	hitnoode = getvehiclenode("auto4225", "targetname");
	hitnoode waittill("trigger");
	
	players	= get_sorted_players();
	
	for(i=0; i< players.size;i++)	
		earthquake(0.4, 4, players[i].origin, 850);

	
	destroyed_model = getent("destroyed_corsair","targetname");
	destroyed_model.origin = hitnoode.origin;

}


event1_tank3_attacked()
{
	
	self waittill("tank2_attacked");

	// temp right side events
	thread event1_right_side_friendly_setup();
	thread event1_hutexplosion();
	thread event1_explosion_near_right_side_friendlies();
	
	// explosion effect but no damage	
	thread fire_shrecks_without_damage(level.tank3, false);
	level.tank3 joltbody ( level.tank3.origin + (0,0,20), 0.5 );
	thread play_rumble_effect();
	
	self thread tank_loopfire( level.tank3, 5 );

	tank3_attack = getvehiclenode("auto4133", "targetname");
	tank3_attack waittill("trigger");

	level.tank3 setspeed(0,6,8);
	level.tank3 disconnectpaths();

	//TEMP checkpoint
//	autosave_by_name( "after_intro" );

	// setup the startergy on the tank move event
	thread event1_tank3_moveup_start();

	// sets the target for the right AT gun - fires around the tanks
	thread right_art_target_strat();
	
}

// sets random target around the tank3
right_art_target_strat()
{
	flag_wait( "tank2_move_1" );

	art_on_right = getent("event1_art_right","targetname");
	
	while( !flag("tank3_reached") )
	{
		random_target = randomintrange( 0, level.tank3_targets.size - 1 );
		art_on_right setTurretTargetEnt( level.tank3_targets[random_target] );

		//iprintlnbold("AT target -> " + random_target );
		
		wait( randomintrange(3,5) );
	}

	// finally the tank3 is in line of sight, AT gun shoots directly into it.
	art_on_right setTurretTargetEnt( getent("tank2_firepoints_final","targetname") );

	wait(1);

	// tank3 is dead
	if ( isalive( level.tank3 ) )
		fire_shrecks_with_damage( level.tank3, level.tank3.health + 200 );
}


event1_tank3_moveup_start()
{
	flag_wait( "tank2_move_1" );
	
	level.tank3 thread tank_loopfire_forever();
	
	// 1st move 
	level.tank3  setspeed(5,6,8);
	stop_at_node = getvehiclenode( "auto4137", "targetname");
	stop_at_node waittill("trigger");
	targetent = getent("tank3_targets_1","targetname");
	level.tank3 setTurretTargetEnt( targetent );

	if ( !flag("tank2_move_2") )
	{
		level.tank3 setspeed(0,6,8);
		flag_wait("tank2_move_2");
	}
	
	level.tank3  setspeed(4,6,8);
	stop_at_node = getvehiclenode( "auto4139", "targetname");
	stop_at_node waittill("trigger");
	targetent = getent("tank3_targets_2","targetname");
	level.tank3 setTurretTargetEnt( targetent );
	

	if ( !flag("tank2_move_3") )
	{
		level.tank3 setspeed(0,6,8);
		flag_wait("tank2_move_3");
	}
	
	level.tank3  setspeed(4,6,8);
	stop_at_node = getvehiclenode( "auto4144", "targetname");
	stop_at_node waittill("trigger");
	targetent = getent("tank3_targets_3","targetname");
	level.tank3 setTurretTargetEnt( targetent );

	wait(0.5);
	
	targetent = getent("tank3_targets_4","targetname");
	level.tank3 setTurretTargetEnt( targetent );

	// tell the level that the tank is reached the last attack point
	flag_set("tank3_reached");
}

// forever fire loop for tank
tank_loopfire_forever()
{
	self endon("death");

	while(!flag ("tank3_reached") )
	{
		if ( self.health > 0 )
		{
			self fireweapon();
			wait (randomintrange(5,8));
		}
	}
}


event1_flametank_moveup_strat()
{
	flag_wait( "tank2_move_1" );
	
	level.flametank.script_nomg = undefined;
	level.flametank  setspeed(5,6,8);
	stop_at_node = getvehiclenode( "auto3694", "targetname");
	stop_at_node waittill("trigger");

	if ( !flag("tank2_move_2") )
	{
		level.flametank setspeed(0,6,8);
		flag_wait("tank2_move_2");
	}

	level.flametank  setspeed(4,6,8);
	stop_at_node = getvehiclenode( "auto3695", "targetname");
	stop_at_node waittill("trigger");

	
	if ( !flag("tank2_move_3") )
	{
		level.flametank setspeed(0,6,8);
		flag_wait("tank2_move_3");
	}
	
	level.flametank  setspeed(4,6,8);
	stop_at_node = getvehiclenode( "auto3711", "targetname");
	stop_at_node waittill("trigger");

	if ( !flag("flametank_move") )
	{
		level.flametank setspeed(0,6,8);
		flag_wait("flametank_move");
	}

	// set the flametank in the opening of second area.
	level.flametank  setspeed(4,6,8);
	stop_at_node = getvehiclenode( "event2_tank_start", "targetname");
	stop_at_node waittill("trigger");

	// stop the tank before getting into second area.
	level.flametank setspeed(0,6,8);
	
	// notify the level that flametank is in the second area
	// unless this happens the second event cant take control of the tank
	flag_set("flametank_in_second_area");
}


event1_right_side_friendly_setup()
{
	flag_wait("tank2_move_2");

	// CO-OP Optimization
	if( !NumRemoteClients() || ( NumRemoteClients() == 1 ) )
	{
		// start working on the second area right side as the tank started rolling up
		friendly_trig = getent("second_area_friendlies_trig","script_noteworthy");
		friendly_trig notify("trigger");
	}
}

event1_hutexplosion()
{
	thread event1_hut_waiter_setup();	

	// get the hut target ent
	hut_explode = getent("tank3_targets_2","targetname");
	level waittill_any( "hut_explode1", "hut_explode2" );	

	wait(2);

	// explosion effects and sounds
	playfx ( level._effect["hut_explosion"] , hut_explode.origin );
	playsoundatposition( "hut_explo", hut_explode.origin );		
	earthquake( 0.3, 1.5, hut_explode.origin, 1000 );

	event1_hutexplosion_remains();

	// delete some parts of the hut
	things = getentarray("hut_explosion_debris", "targetname");
	for( i=0;i<things.size;i++ )
	{
		things[i] delete();
	}

}

event1_hutexplosion_remains()
{
	fire_points = getstructarray("hut_fire_effect","targetname");

	for(i=0;i<fire_points.size;i++)
	{
		size = randomintrange(0,1);
		
		if(size == 0)
			playfx( level._effect["fire_foliage_small"], fire_points[i].origin );
		else
			playfx( level._effect["fire_foliage_xsmall"], fire_points[i].origin );
	}
}

event1_hut_waiter_setup()
{

	thread event1_hut_waiter_setup2();

	lookat_hut = getent("hut_explosion_lookat_trig", "targetname");
	lookat_hut waittill("trigger");
	
	level notify("hut_explode1");
}

event1_hut_waiter_setup2()
{
	lookat_hut = getent("eleventh_color_trig", "targetname");
	lookat_hut waittill("trigger");
	
	level notify("hut_explode2");
}


event1_explosion_near_right_side_friendlies()
{
	level waittill( "tank3_attacked" );
	
	friendlyattacked = getstructarray("right_friendly_attacked", "targetname" );

	for(i=0;i<friendlyattacked.size;i++)
	{
		playfx(level._effect["rocket_explode"],friendlyattacked[i].origin);
	}
}

event1_friendlies_on_right_side_think()
{
	iprintlnbold("right side friendlies spawned");
}


event1_japs_on_hut_strat()
{
	self setthreatbiasgroup("japs_on_hut");
}

event1_ai_takes_cover_behind_rocks()
{
	rightnodes = [];
	leftnodes  = [];

	rcount = 0;
	lcount  = 0;
	
	// get all cover nodes
	rightnodes = getnodearray("guys_go_right","targetname");
	leftnodes = getnodearray("guys_go_left","targetname");	
	
	//guys go right and left
	for(i=0;i<level.allies.size;i++)
	{
		if( isdefined(level.allies[i]) && isalive(level.allies[i]) )
		{
			if(level.allies[i].script_string == "guys_go_right")
			{
				level.allies[i] notify("unload");
				level.allies[i] setgoalnode( rightnodes[rcount] );
				rcount++;

				// start a kill thread on them as we dont need them anymore.
				level.allies[i] thread event1_ai_kill_redshirts();
			}
			else if (level.allies[i].script_string == "guys_go_left")
			{
				level.allies[i] notify("unload");
				level.allies[i] setgoalnode( leftnodes[lcount] );
				lcount++;

				// put one red shirt in our squad
				if ( level.allies[i].script_noteworthy == "guys_following_tank3_1" )
					level.allies[i]  thread magic_bullet_shield();

				// This is a trap guy
				if ( level.allies[i].script_noteworthy == "guys_following_tank2_1" )
				{
					level.allies[i] thread magic_bullet_shield();
					level.allies[i] snare_trap_handle_triggerer();	
				}
			}
		}

	}


}

event1_ai_kill_redshirts()
{
	self waittill("goal");
	self thread bloody_death();
}

event1_riders_take_cover_and_die()
{

	tank3 = getent("tank3", "targetname");
	
	// guys dismounting the second tank need to take cover too.
	riding_guys = getentarray ("passenger_tank3", "targetname");

	riding_guys[0] thread magic_bullet_shield();
	riding_guys[1] thread  magic_bullet_shield();

	// setting the vehicle ride to some crazy number 
	riding_guys[0].script_vehicleride = 300;
	riding_guys[1].script_vehicleride = 300;

	thread event1_rider_dismount_anim( tank3, riding_guys[0] );
	thread event1_rider_dismount_anim( tank3, riding_guys[1] );

	// make this part of players squad put magic bullet shield on them.
	riding_guys[0] thread set_force_color("g");
	riding_guys[1] thread set_force_color("g");

	// flametank dismount animations - roebuck and Polonsky
	roebuck  = getent("walker","script_noteworthy");
	polonsky = getent("sarge","script_noteworthy") ;

	thread event1_rider_dismount_anim( level.flametank, roebuck );
	thread event1_rider_dismount_anim( level.flametank, polonsky );
}

// riding animation when AI is idle
event1_ai_ride_think()
{
	// tank2 - get all the riders
	tank2_riders = getentarray("passenger_tank2", "targetname");
	// call idle anim loop on tank2_riders, there are three of them
	tank2_riders[0] thread event1_rider_idle_anim( level.tank2, tank2_riders[0] );
	tank2_riders[1] thread event1_rider_idle_anim( level.tank2, tank2_riders[1] );
	tank2_riders[2] thread event1_rider_idle_anim( level.tank2, tank2_riders[2] );

	// tank3 - get all the riders
	tank3_riders = getentarray("passenger_tank3", "targetname");
	// call idle anim loop on tank3_riders, there are two of them
	tank3_riders[0] thread event1_rider_idle_anim( level.tank3, tank3_riders[0] );
	tank3_riders[1] thread event1_rider_idle_anim( level.tank3, tank3_riders[1] );

	// flametank - get all the riders, Roebuck and Polonsky
	flametank_riders[0] = getent("walker", "script_noteworthy");
	flametank_riders[1] = getent("sarge", "script_noteworthy");

	// call idle anim loop on flametank_riders, Roebuck and Polonsky
	flametank_riders[0] thread event1_rider_idle_anim_roebuck_roebuck( level.flametank, flametank_riders[0] );
	flametank_riders[1] thread event1_rider_idle_anim( level.flametank, flametank_riders[1] );
}

event1_rider_idle_anim( tank, rider )
{
	self endon("dismounting");
	
	// keep doing animation till AI is dismounted
	while(1)
	{
		// set animname and the tag where he will be on the tank
		rider.animname = "rider" + rider.script_startingposition;
		tag = "tag_passenger" + rider.script_startingposition;
		// link ai to the tag
		rider linkto( tank, tag );
	
		// play the idle animation
		tank anim_single_solo ( rider,"idle", tag, undefined, tank );
	}
}

// roebuck idle cycle on the tank
event1_rider_idle_anim_roebuck_roebuck( tank, rider )
{
	self endon("dismounting");
	
	// keep doing animation till AI is dismounted
	while(1)
	{
		// set animname and the tag where he will be on the tank
		rider.animname = "roebuck";
		tag = "tag_passenger" + rider.script_startingposition;
		// link ai to the tag
		rider linkto( tank, tag );
	
		// play the idle animation
		tank anim_single_solo ( rider,"idle", tag, undefined, tank );
	}
}


event1_rider_dismount_anim( tank, rider, notify_string )
{

	// tell the rider that he is dismouting now, this will stop playing the idle animation
	rider notify("dismounting");	

	rider.animname = "rider" + rider.script_startingposition;
	tag = "tag_passenger" + rider.script_startingposition;

	tank anim_single_solo ( rider,"dismounta", tag, undefined, tank );
	rider unlink();
	rider.animname = "rider" + rider.script_startingposition;
	rider anim_single_solo ( rider,"dismountb", "tag_origin", undefined, rider );

	if ( isdefined( notify_string ) )
		level notify(notify_string);

	//may be this will fix the weird unload blooping problem.
	//tank notify( "unloaded" );
}

event1_followtankInternal( tank, pos, guy )
{
	if( isdefined( tank.script_vehiclewalk )  )
	{	
		if(isdefined(guy) && isalive(guy))
		{
			guy.disableArrivals = true;
			tank thread maps\_vehicle_aianim::WalkWithVehicle(guy, pos);
		}
	}
}



event1_artillary_fire()
{
	//art_on_left = maps\_vehicle::waittill_vehiclespawn( "event1_art_left" );

	//art_on_left setTurretTargetEnt( level.tank2 );

	tank2_first_attack = getvehiclenode("auto3590", "targetname");
	tank2_first_attack waittill("trigger");	

	wait(0.1);

	//spawn the left artillery before the tanks get attacked.
	event1_artillery_trig = getent("event1_artillery_left_trig", "targetname");
	event1_artillery_trig notify("trigger")	;

	level waittill( "spawnvehiclegroup" + 0 );

	wait(0.05);
	
	art_on_left = getent("event1_art_left", "targetname");

	// arty fire	
	art_on_left thread event1_arty_fire();

	self waittill("tank2_attacked");

	art_on_left setTurretTargetEnt( level.tank3 );

	//arty fire stopper	
	art_on_left thread  event1_left_art_stop_fire();

	art_on_left event1_artillery_random_target();
	
}

event1_artillery_random_target()
{
	// tank3 reversed , try some fake targets now.
	reverse_stop = getvehiclenode("auto4108","targetname");
	reverse_stop waittill("trigger");

	targets = getentarray("at_gun_targets","targetname");
		
	while(!flag("left_tank_stop_fire"))
	{
		self setturrettargetent(targets[randomintrange( 0, targets.size -1 )]);
		wait( randomintrange(0,3) );
	}
}


event1_arty_fire()
{
	self endon("death");
	
	wait(0.05);
	
	self maps\_artillery::arty_fire_without_move();
	wait(0.2);
	self maps\_artillery::arty_fire();
}

event1_left_art_stop_fire()
{
	// thread magic_bullet_shield_on the arty crew
	for (i = 0; i < self.arty_crew.size; i++)
	{
		self.arty_crew[i] thread magic_bullet_shield();
	}

	stop_fire_trig = getent("fourth_color_trig","targetname");
	stop_fire_trig waittill("trigger");

	self notify("shut down arty");
	level notify("close to arty 1");

	//give guns
	for (i = 0; i < self.arty_crew.size; i++)
	{	
		if( isdefined( self.arty_crew[i] ) && isalive( self.arty_crew[i] ) )
		{
			if(isdefined( self.arty_crew[i].magic_bullet_shield ) )
				self.arty_crew[i] thread stop_magic_bullet_shield();

			self.arty_crew[i] animscripts\shared::placeWeaponOn( self.arty_crew[i].primaryweapon, "right");
			self.arty_crew[i].goalradius = 2000;	
		}
	}

	
}

event1_right_art_stop_fire()
{
	// thread magic_bullet_shield_on the arty crew
	//for (i = 0; i < self.arty_crew.size; i++)
	//{
	//	self.arty_crew[i] thread magic_bullet_shield();
	//}

	stop_fire_trig = getent("arty_stop_fire_right","targetname");
	stop_fire_trig waittill("trigger");

	self notify("shut down arty");
	level notify("close to arty 2");

	//give guns
	for (i = 0; i < self.arty_crew.size; i++)
	{	
		if( isdefined( self.arty_crew[i] ) && isalive( self.arty_crew[i] ) )
		{
			//if(isdefined( self.arty_crew[i].magic_bullet_shield ) )
			//	self.arty_crew[i] thread stop_magic_bullet_shield();

			self.arty_crew[i] animscripts\shared::placeWeaponOn( self.arty_crew[i].primaryweapon, "right");
			self.arty_crew[i].goalradius = 2000;		
		}
	}
}

// keeps the tank alive.
keep_flametank_alive()
{
	self endon("death");

	while( !flag("flametank_destroy_trig") )
	{
		self.health = 9999999;
		wait(0.05);
	}

	self.health = 500;
}

keep_tank_alive()
{
	self endon("death");

	while( !flag("tank3_reached") )
	{
		self.health = 9999999;
		wait(0.05);
	}

	self.health = 500;
}

// Event1b starts over here
event1_flame_tank_waiter()
{
	self endon("flametank_dead");
	
	//attach the reset target entity
	forward = AnglesToForward(level.flametank.angles);
	level.fake_target = getent("flametank_reset_target","targetname");
	level.fake_target.origin = forward + ( -300, 0 , 0 );
	level.fake_target linkto(level.flametank);
	level.flametank setTurretTargetEnt( level.fake_target ) ;

	// wait till tank2 is attacked
	self waittill("tank2_attacked");

	level.flametank setspeed(0, 6, 20);
	level.flametank joltbody ( level.flametank.origin + (0,0,20), 0.5 );

	// gear sound for sherman flametank
	level.flametank playsound ("tank_gear_grind");
	
	wait(2);

	fire_shrecks_without_damage( level.flametank, false );

	level.flametank disconnectpaths();

	level.flametank setspeed( 4, 5, 8 );

	reverse_stop = getvehiclenode("auto4082", "targetname");
	reverse_stop waittill("trigger");

	level.flametank setspeed( 0, 8, 8);

	event1_flametank_moveup_strat();

}

event1_set_up_grass_guy()
{
	self endon( "death" );

	self allowedstances ( "prone" );
	self.a.pose = "prone"; 
	self.allowdeath = 1;
	self.pacifist = 1;
	self.pacifistwait = 0.05;
	self.ignoreall = 1;
	self.ignoreme = 1;
	self.ignoresuppression = 1;
	self.grenadeawareness = 0;
	self.disableArrivals = true;
	self.disableExits = true;
	self.drawoncompass = false;
	self.activatecrosshair = false;
	self.animname = "bunkers";

	// set the surprise flag to false till the trigger is hit to wake them up
	self.surprisedplayer = false;
	// setup achievement thread
	self thread track_grass_guy_achievement();

	// special case for the trap event on the left side of the map
	if ( issubstr(self.script_string,"4")  )
	{
		self thread grass_guy_shoots_trapped_guy();
		//self thread magic_bullet_shield();	
	}

	// special case for the trap event on the right side in swamp
	//if ( issubstr(self.script_string,"21")  )
	//{
	//	self thread grass_guy_shoots_trapped_guy2();
	//	self thread magic_bullet_shield();	
	//}


	grass_trig = getent(self.script_string + "_trig", "targetname");
	grass_trig waittill("trigger", triggerer );

	// if the player triggers our special trig guys, then he should be able to kill them
	if ( ( issubstr(self.script_string,"4") || issubstr(self.script_string,"21") ) && isplayer( triggerer ) )
	{
		
		if(isdefined( self.magic_bullet_shield ) )
				self thread stop_magic_bullet_shield();
	}

	// surprise the player
	self.surprisedplayer = true;
		
	self allowedstances ( "stand" );
	self.a.pose = "stand";
	
	self.activatecrosshair = true;
	self.drawoncompass = true;

	// choose which variant anim to use
	prone_anim = undefined;
	if( RandomInt( 2 ) )
	{
		prone_anim = level.scr_anim["bunkers"]["prone_anim_fast"];	
	}
	else
	{
		prone_anim = level.scr_anim["bunkers"]["prone_anim_fast_b"];
	}
	
	// play water fx when the guys are coming out of water.
	if ( issubstr(self.script_string, "20" ) || issubstr(self.script_string, "21" ) || issubstr(self.script_string, "23" ) )
	{
		playfx( level._effect["grass_guy_water"], self.origin + ( 0, -20, 20 ) );
		self setwetness( 1.0, true );	
	}
	
	level.animtimefudge = 0.05;
	self maps\_anim::play_anim_end_early( prone_anim, level.animtimefudge );	
	
	self.pacifist = 0;
	self.ignoreall = 0;
	self.ignoreme = 0;
	self.ignoresuppression = 0;
	self.grenadeawareness = 0.2;
	self.disableArrivals = false;
	self.disableExits = false;		

}

// Track grass guy achievement 
track_grass_guy_achievement()
{
	while(1)
	{
		self waittill( "damage", damage_amount, attacker, direction_vec, point, type );
		
		if ( self.health <= 0 && !self.surprisedplayer )
		{
			if ( isdefined( attacker ) && isplayer( attacker )  )
				attacker maps\_utility::giveachievement_wrapper( "ANY_ACHIEVEMENT_GRASSJAP");
		}
	}
}

// cleans up unused/living entities in event1
event1_cleanup()
{
	// event1b cleanup
	thread event1b_cleanup();

	thread event1_cleanup2();

	// friendlies cleaup - CO-OP optimized
	if(!NumRemoteClients())
	{
		thread event1b_friendlies_cleaup1();
	}
	
	thread event1b_friendlies_hut_cleaup1();
	

	trig  = getent("fifth_color_trig","targetname");
	trig waittill("trigger");

	// axis clean up	
	japs1 = get_ai_group_ai("event1_japs_flow_1");
	japs2 = get_ai_group_ai("event1_japs_flow_2");
	

	for( i = 0;i<japs1.size;i++ )
	{
		if (isdefined ( japs1[i] ) )
			japs1[i] thread bloody_death();
	}

	for( i = 0;i<japs2.size;i++ )
	{
		if (isdefined ( japs2[i] ) )
			japs2[i] thread bloody_death();
	}
	
	// grass guy clean up
	grass_guys = get_ai_group_ai("event1_grass_guys");
	for( i = 0;i<grass_guys.size;i++ )
	{
		if (isdefined ( grass_guys[i] ) )
			grass_guys[i] thread bloody_death();
	}



}

// kills remaining japs in the left side trench
event1_cleanup2()
{
	trig  = getent("seventh_color_trig","targetname");
	trig waittill("trigger");

	japs3 = get_ai_group_ai("event1_japs_flow_3");
	
	for( i = 0;i<japs3.size;i++ )
	{
		if (isdefined ( japs3[i] ) )
			japs3[i] thread bloody_death();
	}
}


// cleaning up japs in second area
event1b_cleanup()
{

	trig  = getent("last_cleanup","script_noteworthy");
	trig waittill("trigger");

	japs1 = get_ai_group_ai("event1_japs_flow_4");
	
	for( i = 0;i<japs1.size;i++ )
	{
		if (isdefined ( japs1[i] ) )
			japs1[i] thread bloody_death();
	}
}


event1b_friendlies_cleaup1()
{
	trig  = getent("eleventh_color_trig","targetname");
	trig waittill("trigger");

	// stop magic bullet shield on friendlies
	riding_guys = getentarray ("passenger_tank3", "targetname");
	guy = getent( "guys_following_tank3_1", "script_noteworthy" );
	
	squad = [];
	squad[0] =  riding_guys[0];
	squad[1] =  riding_guys[1];
	squad[2] =  guy;

	for( i=0; i< squad.size - 1; i++ )
	{
		if(isdefined( squad[i].magic_bullet_shield ) )
			squad[i] thread stop_magic_bullet_shield();
	}
	
	// now start killing one by one.
	for( i=0; i< squad.size; i++ )
	{
		wait( randomintrange(2,5) );

		squad[i] thread bloody_death();
	}
}

// CO_OP Optimization
event1b_friendlies_cleaup1_co_op()
{
	level waittill("tank2_attacked");

	// If this is not a co-op game return, it means only SP game is going on
	if( !NumRemoteClients() )
		return;

	wait(randomintrange(5,15));

	// stop magic bullet shield on friendlies
	riding_guys = getentarray ("passenger_tank3", "targetname");
	guy = getent( "guys_following_tank3_1", "script_noteworthy" );
	
	squad = [];
	squad[0] =  riding_guys[0];
	squad[1] =  riding_guys[1];
	squad[2] =  guy;

	for( i=0; i< squad.size - 1; i++ )
	{
		if(isdefined( squad[i].magic_bullet_shield ) )
			squad[i] thread stop_magic_bullet_shield();
	}
	
	// now start killing one by one.
	for( i=0; i< squad.size; i++ )
	{
		wait( randomintrange(5,10) );

		squad[i] thread bloody_death();
	}
}


event1b_friendlies_hut_cleaup1()
{
	trig  = getent("event1_objective_clear_trig2","targetname");
	trig waittill("trigger");

	squad = getentarray ("right_side_friendlies", "script_noteworthy");

	// now start killing one by one.
	for( i=0; i< squad.size; i++ )
	{
		wait( randomintrange(0,7) );

		if( isdefined( squad[i] ) && isalive( squad[i] ) )
			squad[i] thread bloody_death();
	}
}

// sets up ambient planes in the first part of the level.
event1_ambient_planes_setup()
{
	trig = getent("planes_point1","targetname");
	trig waittill("trigger");

	// first wave of planes
	thread planes_flying_strat("event1_ambient_planes1");

	trig = getent("planes_point2", "targetname");
	trig waittill("trigger");	

	thread planes_flying_strat("event1_ambient_planes2");
}

planes_flying_strat( start_struct_name )
{
	// get the start positions for the planes
	start_struct = getstructarray( start_struct_name,"targetname");
	end_struct = getstructarray( start_struct_name,"targetname");
	
	thread planes_move( start_struct, end_struct );
}

sound_planes(wait_time)
{
	self playsound("squadron_by");
}

planes_move( start_struct, end_struct )
{
	for( i = 0; i< start_struct.size;i++ )
	{
		// actually spawn in a plane at start position and angle it
		plane = spawn("script_model", start_struct[i].origin);
		plane.angles = start_struct[i].angles;
		plane setModel( "vehicle_usa_aircraft_f4ucorsair" );

		// get the destination struct
		end_struct = getstruct( "end_" + start_struct[i].script_int, "script_noteworthy");
		destination = end_struct.origin;
			
		// set the speed and fly the planes
		plane thread flyto(destination, randomintrange(90, 120));
		
		// play the sound on only one plane.
		if ( i == 3 )
		plane thread sound_planes();
	
	}
}

flyto(dest, mph)
{
	dist = distance(self.origin, dest);
	distinmiles = dist/63360;
	milespersec = mph / 3600;
	time = distinmiles / milespersec;
	self moveto (dest, time);

	// wait for some time and delete this model	as it reached the destination
	//wait(1);
	//self delete();	
}


/#
event1a_skipto_setup()
{
	level thread maps\_debug::set_event_printname("Artillery Kill A", false);

	level.event1a = true;
	level.startskip = "1a";

	players_ignoreall( level.allies, 0 );

	wait_for_first_player();

	// move up the players.
	players = get_players();
	for(i = 0; i < players.size; i++)
	{
		starts = getStructArray("event1a_start","targetname");
		start = starts[randomint(starts.size)];
		players[i] setOrigin(start.origin);
		players[i] setplayerangles(start.angles);
	}

	// spawn the right side artillery
	level thread event1_right_artsetup();

	level.heroes[0] forceteleport(( 48036.4, 2199.24, 187.443 ), ( 0, 100.95, 0 ));
 	level.heroes[1] forceteleport(( 47635.6, 2450.34, 198.352 ), ( 0, 356.25, 0 ));

	// kills all starting allies, better for me to test in this condition
	for( i=0;i<level.allies.size;i++ )
	{
		if ( isalive( level.allies[i] )  && level.allies[i].script_noteworthy != "sarge" && level.allies[i].script_noteworthy != "walker"  )
			level.allies[i] thread bloody_death();
	}

}

#/
/*
==============================================================================================================
other functions
==============================================================================================================
*/
magic_bullet_to_keep_guys_alive(the_squad)
{
		
	for(i=0; i<the_squad.size; i++) 
	{
		the_squad[i] thread magic_bullet_shield();
	}
}

stop_magic_bullet(the_squad)
{
	for(i=0; i<the_squad.size; i++) 
	{
		if ( isdefined( the_squad[i] ) && isalive( the_squad[i] ) && isdefined( the_squad[i].magic_bullet_shield )  )
			the_squad[i] stop_magic_bullet_shield();
	}
}


set_objectives( objectiveId )
{

	if ( objectiveId ==  0 )
	{
		objective_add( 0, "current" );
		objective_string( 0,  &"PEL1B_OBJECTIVE_MOVE_UP" );
	}
	if ( objectiveId == 1 )
	{
		level.obj_arty = 2;
		level.max_obj_arty = 2;

		objective_add( 1, "current" );
		objective_additionalposition( 1, 1, ( 48004.2, 2406, 174.6 ) );
		objective_additionalposition( 1, 2, ( 47438.2, 5726.9, 60.5 ) );
		objective_string( 1, &"PEL1B_OBJECTIVE_ARTILLERY", level.obj_arty );
	}
	if ( objectiveId == 2 )
	{

		// player has finished the objectives in first area
		flag_set("event1_objectives_done");

		objective_state( 1, "done");
		objective_add( 2, "current" );
		objective_additionalposition( 2, 1, (46093, 6259,0) );
		objective_string( 2, &"PEL1B_OBJECTIVE_FOLLOW_SQUAD");
		objective_state( 2, "done" );	

		// set the battlechatter off as we are along the alley
		thread battlechatter_off( "allies" );
		thread battlechatter_off( "axis" );

		// calling Sumeets event2 now.
		level thread maps\pel1b_event2::event2_main_function();
	}
	
}


/////////////////////////////////////// Blocks the player to get into second area
///////// if he has not finished the first two objectives.
event1_objective_blocker()
{

	// get the player blocked clip
	blocker = getent("event1_objective_clip", "targetname");
	// get the notification trigger
	blocker_trig = getent("event1_objective_clip_trig", "targetname");
	
	players = get_players();

	while(!flag("event1_objectives_done"))
	{
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];

			if ( isdefined( player ) )
			{
				// checking the flag again, it might have changed
				if ( isalive(player) &&	!flag("event1_objectives_done") )
				{
					// check if the player is touching the blocker trigger
					if ( player IsTouching( blocker_trig ) )
					{
	
						// if he doesnt have a active blocker hud on him, then create one, 
						// should happen only for the first time he walks blocker trigger 
						if ( !isdefined( player.Warning_hud_created ) )
						{
							player.Warning_hud = newClientHudElem(player);
							player.Warning_hud.alignX = "center";
							player.Warning_hud.x = 450;
							player.Warning_hud.y = 300;
							player.Warning_hud.alignX = "right";
							player.Warning_hud.alignY = "bottom";
							player.Warning_hud.fontScale = 1.5;
							player.Warning_hud.alpha = 1.0;
							player.Warning_hud.sort = 20;
							player.Warning_hud.font = "default";
							player.Warning_hud FadeOverTime( 1 ); 
	
							// set the active hud flag 
							player.Warning_hud_created = 1;
						}							
						
						// set the warning text
						player.Warning_hud SetText(&"PEL1B_OBJECTIVE_WARNING");
					}
					else if ( isdefined( player.Warning_hud_created ) )
					{
						player.Warning_hud SetText("");
					}
				}
			}
		}
	
		wait(0.1);		
	}

	// delete the blocker as the clear objective flag is set
	blocker = getent("event1_objective_clip", "targetname");
	blocker delete();

	// detete the trigger
	blocker_trig delete();	

	// now that objectives are clear then clear out the hudelements allocated on the players.
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		if ( isdefined( player ) )
		{
			// checking the flag again, it might have changed
			if ( isalive(player) && isdefined( player.Warning_hud_created ) )
			{
				player.Warning_hud destroy();			
			}
		}

	}

}

/*
=================
 used to shoot Panzershrecks at the players and tank in Event 1
=================
*/

fire_shrecks(spwn, targt, time)
{
	shreck = spawn("script_model", spwn.origin);
	shreck.angles = targt.angles;
	shreck setmodel("weapon_ger_panzershreck_rocket");
		
	wait 0.1;
	shreck moveTo(targt.origin, time);
	playfxontag( level._effect["rocket_trail"], shreck, "tag_origin" );
	shreck playloopsound( "rpg_rocket" );

	wait time;
	playfx(level._effect["rocket_explode"], shreck.origin);
	earthquake(0.3, 1.5, shreck.origin, 512);
	shreck stoploopsound();
	
	shreck hide();
	wait( 10 );
	shreck delete();
}

shrecksmoke(time)
{
	fxcounter = 0;
	
	while(time > 0)
	{
		time = time - 0.1;

		playfx(level._effect["rocket_trail"], self.origin);

		wait 0.1;
	}
}

/*
=================
used to blast/explosion for Panzershrecks, it will kill them
=================
*/

fire_shrecks_with_damage( tank, damage )
{
	radiusdamage(tank.origin + ( 0, 0, 200 ), 300, damage, 35);
	
	earthquake( 0.3, 1.5, tank.origin, 512 );

	//playfx( level._effect["tank_blowup"], tank.origin );
	//playfx( level._effect["smoke_destroyed_tank"], tank.origin );
}


/*
=================
used to blast/explosion for Panzershrecks, it wont kill them
=================
*/

fire_shrecks_without_damage(tank, switchmodel )
{
	// play fx of explosion
	shreck = spawn("script_model", tank.origin);
	shreck.angles = tank.angles;

	if ( switchmodel )
		shreck setmodel("weapon_ger_panzershreck_rocket");

	playfx(level._effect["rocket_explode"], shreck.origin);
	shreck playsound("explo_metal_rand");
}



/*
=================
tank_loopfire
=================
*/

tank_loopfire( tank, times )
{
	self endon("death");
	
	for( i = 0; i< times; i++ )
	{
		if ( tank.health > 0 )
		{
			tank fireweapon();
			wait (randomintrange(2,5));
		}

	}
}


player_shellshock()
{
	tank2 = getent("tank2", "targetname");
	tank3 = getent("tank3", "targetname");

	// Shell shock to the players
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{

		distance1 = Distance( tank2.origin, players[i].origin );
		distance2 = Distance( tank3.origin, players[i].origin );

		if ( distance1 < 200.0 || distance2 < 200.0 )
		{
			players[i] freezecontrols(true);
			players[i] shellshock("teargas", 10);
		
			wait 1;

			players[i] freezecontrols(false);
		}
	}
}


players_ignoreall( squad, ignoreflag )
{
	for(i=0;i<squad.size;i++)
	{
		if ( isalive(squad[i]) )
			squad[i].ignoreall = ignoreflag;
	}
}


// reset turret target
reset_turret_target()
{
	level.flametank setTurretTargetEnt( level.fake_target );
}

// Fake death function - Used to kill leftover entities.
bloody_death()
{
	self endon("death");

	if(!isalive(self))
	{
		return;
	}

	self.bloody_death = true;
	wait(randomfloatrange(1, 3));

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";
	
	for(i = 0; i < 2 + randomint(3); i++)
	{
		random = randomintrange(0, tags.size);
		
		// only play the effect if its mature mode.
		if( is_mature() )
		{
			playfxontag(level.fleshhit, self, tags[random]);
		}	
		

		wait(randomfloat(0.2));
	}

	self dodamage(self.health + 50, self.origin);
}

/*
=================
Sachel Setup

Input- trigger pointing to the "charge"
charge.script_noteworthy = swap model when charge is active
must be threaded on the artillery/vehicle that is getting sachel charged.

TODO : make this a utility script

=================
*/

satchel_setup( charge_trig, target_ent, flag_art )
{
	wait( 2 );

	charge = getent( charge_trig.target, "targetname" );

	// snap it to a tag_bomb later on
	charge.origin = self LocalToWorldCoords( ( -34, -15, 20 ) );
	charge.angles = self.angles;
	
	ASSERTEX( isdefined ( charge ), "Charge trigger should be pointing to a sachel charge" );
	ASSERTEX( isdefined ( charge.script_noteworthy ), "Charge should have a swap model specified as script_noteworthy" );
	
	// wait till its getting used
	charge_trig waittill ("trigger");

	iprintlnbold("Charge planted");
	
	// set the active model - make sure the model is precahced first.
	charge setmodel(charge.script_noteworthy);
	
	wait(5);

	// damage the target ent
	charge delete();
	charge_trig delete();
	fire_shrecks_with_damage( target_ent, target_ent.health + 200 );

	flag_set( flag_art );
}


/*
==============================================================================================================
Spawn functions
==============================================================================================================
*/

setup_spawn_functions()
{

	//event 1 - spawn functions setup
	grass_guy = getentarray("grass_guy", "script_noteworthy");
	array_thread(grass_guy, ::add_spawn_function, ::event1_set_up_grass_guy);

	// suicide guy on the right gets owned by the flametank
	suicide_guy3 = getentarray("suicide_guy3", "script_noteworthy");
	array_thread(suicide_guy3, ::add_spawn_function, ::setup_suicide_guy);

	// event 1b - spawn function setup
	// suicide guy 1
	suicide_guy1 = getentarray("suicide_guy1", "script_noteworthy");
	array_thread(suicide_guy1, ::add_spawn_function, ::setup_suicide_guy);

	japs_on_hut = getentarray("event1_japs_on_hut","script_noteworthy");
	array_thread( japs_on_hut, ::add_spawn_function, ::event1_japs_on_hut_strat );

	// trap_guy
	trap_guy = getentarray("event1_right_side_trap_guy", "targetname");
	array_thread(trap_guy, ::add_spawn_function, ::setup_right_side_trap_guy);
}

event1_objective_thread_left_art()
{

	trig = getent( "arty_stop_fire_left", "targetname" );
	trig waittill("trigger");

	// check if all the guys in the truch area 1 are cleared
	trench_1 = getent( "event1_objective_clear_trig1", "targetname" );

	while( 1 )
	{
		cleared = true;
		axis_guys = GetAiArray( "axis" );
		for( i = 0; i < axis_guys.size; i++ )
		{
			if( axis_guys[i] istouching( trench_1 ) )
			{
				cleared = false;
			}
		}

		if( cleared )
		{
			break;
		}	

		wait( 1 );
	}

	// clear the star as left artillery is tanken	
	level.obj_arty--;
	Objective_String( 1, &"PEL1B_OBJECTIVE_ARTILLERY", level.obj_arty );
	Objective_AdditionalPosition( 1, 1, ( 0, 0, 0 ) );
	level notify("event1_objective_left_art_done");

	// checkpoint
	autosave_by_name( "after_left_artillery" );

	wait(2);
	
	// Trigger the color trigger so that the friendly AI starts moving
	//trigger = getent("seventh_color_trig", "targetname");
	//if ( isdefined  ( trigger ) )
	//	trigger notify("trigger");

}


event1_objective_thread_right_art()
{
	// wait for the players to get near to the second objective
	trig = getent("eleventh_color_trig","targetname");
	trig waittill("trigger");
	
	trench_2 = getent( "event1_objective_clear_trig2", "targetname" );
	
	while( 1 )
	{
		cleared = true;
		axis_guys = GetAiArray( "axis" );
		for( i = 0; i < axis_guys.size; i++ )
		{
			if( axis_guys[i] istouching( trench_2 ) )
			{
				cleared = false;
			}
		}

		if( cleared )
		{
			break;
		}	

		wait( 1 );
	}

	// clear the star as right artillery is tanken
	level.obj_arty--;
	Objective_String( 1, &"PEL1B_OBJECTIVE_ARTILLERY", level.obj_arty );
	Objective_AdditionalPosition( 1, 2, ( 0, 0, 0 ) );
	level notify("event1_objective_right_art_done");

	// checkpoint
	autosave_by_name( "after_right_artillery" );
}

event1_objective_thread_follow_squad()
{
	level waittill_multiple( "event1_objective_left_art_done", "event1_objective_right_art_done" );
	// set the regourp objective
	level thread set_objectives(2);

	// send the hero characters to the alley
	color_trig = getent( "event2_color_trig_change","targetname");
	color_trig notify ("trigger");
}

/*
==============================================================================================================
Event1 POW event in 2nd hut
==============================================================================================================
*/


// gun hiding and un-hiding
remove_gun( guy )
{
	if( !IsDefined( guy ) )
	{
		self gun_remove();
	}
	else
	{
		guy gun_remove();
	}
}

recall_gun( guy )
{
	guy gun_recall();
}


guy_make_killable()
{
	self.allowdeath = true;
}


event1_held_guy()
{
	//-- Glocke: 9/7/08 - removal of this vignette because of the flag and visibility
	if( true )
	{
		return;
	}
	
	if( !is_mature() )
	{
		return;
	}

	// here is where we will swap the flag model by creating an explosion
	// we have to make sure that the explosion happens just before the guys spawn 
	// Doesnt really work
	level thread swap_flag();

	level endon( "stop_held_guy_vignette" );

	flag_wait( "event1_held_guy" );
	
	spawners = GetEntArray( "event1_held_down_spawners", "targetname" );

	for( i = 0; i < spawners.size; i++ )
	{
		// Relying on DoSpawn (code) to copy this to the AI.
		spawners[i].animname = spawners[i].script_string;
		spawners[i] add_spawn_function( ::guy_make_killable );	
	
		if( spawners[i].animname == "ally_held_down" )
		{
			spawners[i] add_spawn_function( ::kill_ally );
			spawners[i] add_spawn_function( ::remove_gun );
			spawners[i] add_spawn_function( ::ally_screaming );
		}
		
	}

	node = GetNode( "event1_held_down", "targetname" );
	spawn_and_play( spawners, "vignette", node );

}

swap_flag()
{
	// swap the model
	new_flag = getent("new_flag", "targetname");
	new_flag hide();
}

// plays rumble on players
play_rumble_effect()
{
	// plays rumble 
	players = get_players();
	for( p = 0; p < players.size; p++ )
	{	
		players[p] PlayRumbleOnEntity( "artillery_rumble" );
	}

	wait( 2 );

	for( p = 0; p < players.size; p++ )
	{	
		players[p] PlayRumbleOnEntity( "artillery_rumble" );
	}

}

// killing the dead ally on the floor
kill_ally(notify_str)
{
	
	if( !IsDefined( notify_str ) )
	{
		notify_str = "single anim"; 
	}

	self waittill( notify_str ); 
	
	// do ragdoll
	self.skipDeathAnim = true; 
	self setcandamage( true );
	
	self dodamage( self.health + 200, self.origin );
}

// Functions from Mike's script
spawn_and_play( spawners, anime, node, anim_reach, death_anim )
{
	guys = spawn_guys( spawners );

	if( IsDefined( anim_reach ) && anim_reach )
	{
		level anim_reach( guys, anime, undefined, node );
	}
	
	level notify("execution_is_ready");

	level thread anim_single( guys, anime, undefined, node );
}
// Spawns in AI out of every spawner given
spawn_guys( spawners, target_name, ok_to_spawn )
{
	guys = [];

	for( i = 0; i < spawners.size; i++ )
	{
		guy = spawn_guy( spawners[i], target_name, ok_to_spawn );
		if( IsDefined( guy ) )
		{
			guys[guys.size] = guy;
		}
	}

	// We do not want to return the guys if ok_to_spawn is used. Since a guy in the array may be dead.
	// So, only return the guys array if we do not want to ok_to_spawn.
	if( !IsDefined( ok_to_spawn ) || !ok_to_spawn )
	{
		return guys;
	}
}

// Spawns in an AI (and returns the spawned AI)
spawn_guy( spawner, target_name, ok_to_spawn )
{
	if( IsDefined( ok_to_spawn ) && ok_to_spawn )
	{
		while( !OkToSpawn() )
		{
			wait( 0.1 );
		}
	}

	if( IsDefined( spawner.script_forcespawn ) && spawner.script_forcespawn )
	{
		guy = spawner StalingradSpawn(); 
	}
	else
	{
		guy = spawner DoSpawn(); 
	}

	if( !spawn_failed( guy ) )
	{
		if( IsDefined( target_name ) )
		{
			guy.targetname = target_name;
		}

		return guy; 
	}

	return undefined; 
}

/*
==============================================================================================================
Event2 Functions - Flame Death
==============================================================================================================
*/
/#

event1b_skipto_setup()
{
	//TEMP
	level thread maps\_debug::set_event_printname("Flame Death", false);

	level.event1b = true;
	level.startskip = "1b";

	wait_for_first_player();

	// teleport players.
	players = get_players();
	for(i = 0; i < players.size; i++)
	{
		starts = getStructArray("event1b_start","targetname");
		start = starts[randomint(starts.size)];
		players[i] setOrigin(start.origin);
		players[i] setplayerangles(start.angles);
	}


	// kills all starting allies, better for me to test in this condition
	for( i=0;i<level.allies.size;i++ )
	{
		if ( isalive( level.allies[i] )  && level.allies[i].script_noteworthy != "sarge" && level.allies[i].script_noteworthy != "walker"  )
			level.allies[i] thread bloody_death();
	}

	// let the flametank come up to hill entrance.
	tank1_trig = getent("tank1start", "targetname");
	tank1_trig notify("trigger");

	wait(0.05);

	level.flametank = getent("flametank", "targetname");
	level.flametank setspeed( 30, 5, 8 );
	
	// let the tank come to second area entrance
	node = getvehiclenode("event2_tank_start", "targetname");
	node waittill( "trigger" );
	level.flametank setspeed( 0, 6, 35 );

	// teleport hero characters.
	hero_start_structs = getstructarray( "ev2_temp_teleport_heroes", "targetname" );
	level.heroes[0] forceteleport( hero_start_structs[0].origin, hero_start_structs[0].angles );
	level.heroes[1] forceteleport( hero_start_structs[1].origin, hero_start_structs[1].angles );
	
	level.heroes[0].ignoreall = 0;
	level.heroes[1].ignoreall = 0;

	// set the flag for the tank to move up
	flag_set("flametank_in_second_area");

	// Calling sumeets event 2 function now.
	level thread maps\pel1b_event2::event2_main_function();
}


outro_skipto_setup()
{
	// spawn in the 200 mm gun too
	//vehicle_trig = getent("ev2_spawn_art","targetname");
	//vehicle_trig notify("trigger");
	
	// spawn the radio guy
	spawner = getent("ev2_radio_guy", "script_noteworthy");
	level.radio_guy = spawner stalingradspawn();
	
	player = get_players()[0];

	wait(1);

	//level.radio_guy = getent("ev2_radio_guy", "script_noteworthy");
	
	level.radio_guy thread magic_bullet_shield();
		
	// teleport the AI to the outro position
	hero_start_structs = getstructarray( "ev2_outro_teleport_heroes", "targetname" );

	level.heroes[0] forceteleport( hero_start_structs[0].origin, hero_start_structs[0].angles );
	level.heroes[1] forceteleport( hero_start_structs[1].origin, hero_start_structs[1].angles );
	level.radio_guy forceteleport( hero_start_structs[2].origin, hero_start_structs[2].angles );

	// call the outro function
	// teleport the player to the position at outro
	player = get_players()[0];

	starts = getStructArray("ev2_outro_player","targetname");
	player setOrigin(starts[0].origin);
	player setplayerangles(starts[0].angles);

	// spawn in the 200 mm gun too
	vehicle_trig = getent("ev2_spawn_art","targetname");
	vehicle_trig notify("trigger");
	
	
	// waittill player moves a little bit and gets into the outro trigger
	trig = getent("ev2_outro_player_trig_skipto","targetname");
	trig waittill("trigger");

		
	// start the outro
	// get the guys to do the outro animation
	guys = [];
	guys[0] = level.walker; // roebuck
	guys[1] = level.sarge; // polonsky
	guys[2] = level.radio_guy; 

	guys[0].animname = "walker";
	guys[1].animname = "sarge";
	guys[2].animname = "radio_guy";

	guys[0] disable_ai_color();
	guys[1] disable_ai_color();
	guys[2] disable_ai_color();

	guys[0].ignoreall = true;
	guys[1].ignoreall = true;
	guys[2].ignoreall = true;
	
	anim_struct = getstruct( "outro_anim", "targetname" );

	goal_node_roebuck = getnode( "roebuck_outro", "targetname" );
	goal_node_polonsky = getnode( "polonsky_outro", "targetname" );
	goal_node_radio = getnode( "radio_outro", "targetname" );

	guys[0] thread pacing_vignette_in_place_think( anim_struct, "roebuck_reached_outro", "outro_in", "outro_loop" );
	guys[1] thread pacing_vignette_in_place_think( anim_struct, "polonsky_reached_outro", "outro_in", "outro_loop" );
	guys[2] thread pacing_vignette_in_place_think( anim_struct, "radio_guy_reached_outro", "outro_in", "outro_loop" );

	flag_wait_all( "roebuck_reached_outro", "polonsky_reached_outro", "radio_guy_reached_outro" );

	//-- Check and see if the player is close by, if he is, then run the outro
	players = get_players();
	player_close = false;
	while(!player_close)
	{
		for( i=0; i < players.size; i++ )
		{
			if( distancesquared(players[i].origin, guys[0].origin) < 400*400 )
			{
				player_close = true;
			}
		}
		
		wait(0.05);
	}

	//guys[2] thread maps\pel1b_event2::outro_animate_radio_model(anim_struct);
	guys[2] notify( "radio_anim_starting" );
	anim_single( guys, "outro",  undefined, undefined, anim_struct );
	
	
	wait(0.5);

	iprintln("roebuck --------> " + guys[0].angles);
	iprintln("Polonsky --------> " + guys[1].angles);
}


pacing_vignette_in_place_think( goal_node, flag_name, anim_in, anim_looping )
{
	//-- plays the animation	
	startorg = getstartOrigin( goal_node.origin, goal_node.angles, level.scr_anim[self.animname][anim_in] );
	startang = getstartAngles( goal_node.origin, goal_node.angles, level.scr_anim[self.animname][anim_in] );
	
	self.goalradius = 32;
	//self setgoalnode( goal_node );
	self SetGoalPos( startorg, startang );
	self disable_ai_color();

	self waittill( "goal" );
	self waittill_notify_or_timeout( "orientdone", 1 );
	
	wait(0.75);
	
	anim_single_solo( self, anim_in, undefined, undefined, goal_node );
	thread anim_loop_solo( self, anim_looping, undefined, undefined, goal_node );
	
	if(self.animname == "radio_guy")
	{
		self thread maps\pel1b_event2::outro_animate_radio_model(goal_node);	
	}
	
	flag_set( flag_name );
}

#/

// 2nd area battle starts.
#using_animtree ("generic_human");
event1b_setup()
{
	
}


// flame tank flames the broken foliage
event1b_tank1_movesup()
{	
	self setspeed (7, 6, 8);

	// used to see if the tank is firing at a specific guy
	self.killingsuicideattackers = false;
	
	if ( level.startskip != "1b" )
	{

		firenode = getvehiclenode("auto3691","targetname");
		firenode waittill("trigger");
		self fireweapon();
		stopfirenode = getvehiclenode("auto3712","targetname");
		stopfirenode waittill("trigger");
		self stopfireweapon();

		//suicide guy for event1
		firenode = getvehiclenode("auto3697", "targetname");
		firenode waittill("trigger");
		self fireweapon();
		firepoint1 = getent("suicide_point3", "targetname");
		self setTurretTargetEnt( firepoint1 );
		self setspeed(0,6,8);
		self waittill("suicide_guy3_dead");
		self setspeed(5,6,8);
		self stopfireweapon();
		self clearturrettarget();
	}

	// tank waits for the players to gather around
	wait_for_players_here = getvehiclenode("auto3707", "targetname");
	wait_for_players_here waittill("trigger");

	// tank reached the wait node
	self setspeed(0, 6, 8);

	player_near_tank = getent("tank_player_mover_trig","targetname");
	player_near_tank waittill("trigger");
	
	//player is nearby
	self setspeed(5, 6, 8);

	firenode = [];
	firenode[0] = getvehiclenode("auto3713","targetname");
	firenode[1] = getvehiclenode("auto3716","targetname");
	firenode[2] = getvehiclenode("auto3731","targetname");
	firenode[3] = getvehiclenode("auto3720","targetname");
	firenode[4] = getvehiclenode("auto3723","targetname");

	firenode[0] waittill("trigger");

	// start firing for once for all
	self fireweapon();
	
	points = getentarray("left1","script_noteworthy");
	self thread event1b_randomfirepoint(points, "left1");

	firenode[1] waittill("trigger");
	self notify("left1");	
	points = getentarray("right1","script_noteworthy");
	self thread event1b_randomfirepoint(points, "right1");


	firenode[2] waittill("trigger");
	self notify("right1");	
	points1 = getentarray("left2","script_noteworthy");
	self thread event1b_randomfirepoint(points1, "left2");	

	firenode[3] waittill("trigger");
	self notify("left2");		
	points2 = getentarray("right2","script_noteworthy");
	self thread event1b_randomfirepoint(points2, "right2");	

	firenode[4] waittill("trigger");
	self notify("right2");		
	points3 = getentarray("left3","script_noteworthy");
	self thread event1b_randomfirepoint(points3, "left3");	
	
	// tank1 gets owned
	tank1attacknode = getvehiclenode("auto3724","targetname");
	tank1attacknode waittill("trigger");

	fire_shrecks_with_damage( self, self.health + 200 );
}

event1b_randomfirepoint( points, endonwhat )
{
	self endon( endonwhat );
	self endon("death");
	self clearturrettarget();

	while(1)
	{
		ASSERT(points.size > 1, " There should be atleast one point to point to.");
	
		which = randomintrange( 0 , points.size - 1 );
	
		if ( isdefined (points[which]) )
		{	
			if ( self.health > 0  && self.killingsuicideattackers == false )
			{
				self setTurretTargetEnt(points[which]);
				//iprintlnbold( "setting turret target to" + points[which].origin + "where - " + endonwhat  );
			}
			else
			{
				//iprintlnbold("turret target is suicide guy now, ignoring other targets.");
			}
		}
		
		wait(1);	
	}
	
}

event1b_fire_japs_up_hill()
{

	japs = getentarray("event1b_japs", "targetname");
	
	for(i=0;i<10;i++)
	{		
		if ( isdefined (japs) )
		{	
			which = randomintrange( 0 , japs.size - 1 );
			self setTurretTargetEnt(japs[which]);
		}
	
		wait(1);	
	}
}


// Suicide guys setup
setup_suicide_guy()
{
	self.ignoreall = 1;
	self.pacifist = 1;
	self.disableArrivals = true;
	self.animname = "animsingle1";
	// temp anims.
	self.a.combatrunanim = %ai_bonzai_sprint_a;
	self.goalradius = 32;
	
	// script string stores the goal script origin.
	goalnode = getent( self.script_string,"targetname");
	self setgoalentity(goalnode);

	// tell the level that tank is firing a specific guy
	level.flametank.killingsuicideattackers = true;
	
	// wait till these guys get near to the tank
	wait (1);
	
	// set this guys as the only target for the tank right now.
	level.flametank setTurretTargetEnt(self);
		
	// flame till guy is dead 
	self waittill("death");
	
	// guy is dead clear flametanks target and get back to normal firing.
	level.flametank notify( self.script_noteworthy + "_dead" );
	level.flametank.killingsuicideattackers = false;
	level.flametank clearturrettarget();
}



setup_sniper_guy()
{
	// tell the level that tank is firing a specific guy
	level.flametank.killingsuicideattackers = true;
	
	// wait till these guys get near to the tank
	wait (1);
	
	// set this guys as the only target for the tank right now.
	level.flametank setTurretTargetEnt(self);
		
	// flame till guy is dead 
	self waittill("death");
	
	// guy is dead clear flametanks target and get back to normal firing.
	level.flametank notify( "sniper_dead" );
	level.flametank.killingsuicideattackers = false;
	level.flametank clearturrettarget();
}


event1b_tree_sniper()
{

	tree = getent( "test_tree", "script_noteworthy" );

	tree thread flame_notify();

	model_tag_origin = spawn( "script_model", tree.origin );
	model_tag_origin setmodel("tag_origin");
	model_tag_origin linkto( tree, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	

	playfxontag( level._effect["sniper_leaf_loop"], model_tag_origin, "TAG_ORIGIN" );
	
	// must wait for the vehicle node to hit i.e tankreaching to a perticular node.
	node = getvehiclenode("auto3730","targetname");
	node waittill("trigger");
	
	model_tag_origin unlink();
	model_tag_origin delete();
	
	wait( 0.05 );
	
	orig = getent( "test_orig", "targetname" );
	playfx( level._effect["sniper_leaf_canned"], tree.origin );
}




flame_notify()
{
	
	node = getvehiclenode("auto3730","targetname");
	node waittill("trigger");

	wait( 0.05 );

	guy = get_ai_group_ai( "tree_guy" )[0];
	
	while( 1 )
	{
	
		self waittill( "broken", broken_notify, attacker );
		
		if( broken_notify == "hideout_fronds_dmg0" )
		{
			
			guy animscripts\death::flame_death_fx();
			guy setcandamage( true );
			guy notify("fake tree death", attacker );
			
			break;
		}
		
	}
	
}



/*
==============================================================================================================
 Co-op warping of players
 Sorts the players in order of their entitynumber, good way to get the host
==============================================================================================================
*/
get_sorted_players()
{
	players = get_players(); 

	for( i = 0; i < players.size; i++ )
	{
		for( j = i; j < players.size; j++ )
		{
			if( players[j] GetEntityNumber() > players[i] GetEntityNumber() )
			{
				temp = players[i]; 
				players[i] = players[j]; 
				players[j] = temp; 
			}
		}
	}

	return players; 
}

get_sorted_starts( start_name )
{
	starts = getstructarray( "player_starts", "targetname" ); 

	player_starts = []; 
	

	for( i = 0; i < starts.size; i++ )
	{
		if( IsDefined( starts[i].script_int ) )
		{
			player_starts[player_starts.size] = starts[i]; 
		}
	}

	for( i = 0; i < player_starts.size; i++ )
	{
		for( j = i; j < player_starts.size; j++ )
		{
			if( player_starts[j].script_int < player_starts[i].script_int )
			{
				temp = player_starts[i]; 
				player_starts[i] = player_starts[j]; 
				player_starts[j] = temp; 
			}
		}
	}
	
	return player_starts;
}


/*
==============================================================================================================
Dialogue section for event 1
==============================================================================================================
*/

say_dialogue( theLine ) 
{  
	// check if the guy is alive to say the dialogue. Avoids a script error in the hut execution sequence.
	if ( isdefined( self ) && isalive( self ) )
	{
		self.og_animname = self.animname; 
    	self.animname = "generic";  
		self anim_single_solo( self, theLine );  
		self.animname = self.og_animname; 
	}
}


in_game_dialogue_setup()
{
	wait(1.6);

	roebuck = level.walker;
	polonsky = level.sarge;

	// incoming dialogue
	polonsky thread tank_hit_incoming();
	level thread tank2_is_attacked( polonsky,roebuck );
	
	// Over black -----------------------------------------
	// Roebuck - tank ride talk - 200 mm
	roebuck say_dialogue("intro1");
	
	// Roebuck - tank ride talk - hit shore
	roebuck say_dialogue("intro2");

	// fade in --------------------------------------------
	// Roebuck - tank ride talk - reinforcements
	roebuck say_dialogue("intro3");

	wait(0.5);

	// Polonsky - tank ride talk - bloodbath
	polonsky say_dialogue("intro4");

	// Roebuck - tank ride talk - Major Gordon
	roebuck say_dialogue("intro5");

	wait(1);

	// Roebuck - tank ride talk - Now Listen
	roebuck say_dialogue("intro6");

	wait(0.5);

	// Roebuck - tank ride talk - Tojo
	roebuck say_dialogue("intro7");

	// Roebuck - tank ride talk - dogs
	roebuck say_dialogue("intro8");
	
	// Roebuck - tank ride talk - close quarters
	roebuck say_dialogue("intro9");

	// Roebuck - tank ride talk - ain't pretty
	roebuck say_dialogue("intro10");

	// Roebuck - tank ride talk - watch each others back
	roebuck say_dialogue("intro11");

	// Roebuck - tank ride talk - dont get caught
	roebuck say_dialogue("intro12");

	// Roebuck - riverbed
	thread riverbed_dialogue(roebuck);
	
	// Roebuck - triple 25
	thread triple25_instruct(roebuck);

	// Polonsky - first position down
	thread first_objective_done(roebuck);

	//Take out that damn artillery position!!!
	thread close_to_art(roebuck);

	// redshirt - Lets go - Not doing this right now.
	thread event2_start(roebuck);
	
}

tank2_is_attacked( polonsky, roebuck )
{
	level waittill("tank2_attacked");

	// Roebuck - Get off the tank
	wait(0.5);
	roebuck say_dialogue("intro14");
		
	// Roebuck - Get to the cover
	wait(1);
	roebuck say_dialogue("intro15");
	
	// Polonsky - Japanese infantry
	wait(1);
	polonsky say_dialogue("event1");
	
	// Polonsky - Fallen tree
	polonsky say_dialogue("event2");

	// Polonsky - artillery northeast 
	wait(3);
	polonsky say_dialogue("event3");

	// Roebuck - knock'em out
	wait(0.5);
	roebuck say_dialogue("event4");
}

tank_hit_incoming()
{
	// tank in front is hit ---------------------------------
	// Polonsky - Incoming
	level waittill("incoming");
	wait(0.3);
	self say_dialogue("intro13");

}


// Move along the riverbed! Flank them!
riverbed_dialogue(roebuck)
{
	trig = getent("river_trig_1","script_noteworthy");
	trig waittill("trigger");

	roebuck say_dialogue("event5");
	
	// Roebuck - flamk'em	
	roebuck say_dialogue("event6");
}

//Miller! Get on that triple 25! Watch that bunker on the left!
triple25_instruct(roebuck)
{
	trig = getent("sixth_color_trig","targetname");
	trig waittill("trigger");
	
	roebuck say_dialogue("event7");
	
	wait(1);

	roebuck say_dialogue("event8");
	wait(0.2);
	
	//Make sure it's clear!
	roebuck say_dialogue("event9");
}

//First position - Down!
first_objective_done(roebuck)
{
	trig = getent("seventh_color_trig","targetname");
	trig waittill("trigger");

	wait(2);
	roebuck say_dialogue("event10");

	wait(2);

	//There's another one up ahead!	
	roebuck say_dialogue("event11");
	//Clear it out - so our tanks can move up!
	roebuck say_dialogue("event12");
}

//Take out that damn artillery position!!!
close_to_art(roebuck)
{
	trig = getent("nineth_color_trig","targetname");
	trig waittill("trigger");

	wait(2);
	roebuck say_dialogue("event13");
}


//Get off me!!! Get your damn hands off me!!! Help!!!
ally_screaming()
{
	wait(0.5);
	self say_dialogue("event14");
	self say_dialogue("event15");
	self say_dialogue("event16");
}


//Let's go!
event2_start(roebuck)
{
	//temp_regroup_trig = getent("temp_regroup_trig", "targetname");
	//temp_regroup_trig waittill("trigger");

	//roebuck  say_dialogue("event18");
}



/*
==============================================================================================================
Trap Section :=)
==============================================================================================================
*/

log_trap_thread()
{
	log = getent( "log", "targetname" );
	log_trigger = getent( "log_trap", "targetname" );

	log physicsLaunch( log.origin, (0, 0, 0) );

	log_trigger waittill( "trigger", triggerer );
	triggerer.a.gib_ref = "right_arm";

	ropeid = getrope( "break_log_rope" );
	breakrope( ropeid, 0 );

	// time the effects and sound
	wait 1.6;

	// play sound and particle for log hitting

}

snare_trap_thread()
{
	wait (1);

	// get the barrel and throw it into physics
	//barrel = getEnt( "trap_barrel", "targetname" );
	//barrel physicslaunch( barrel.origin, (0,0,-0.1) );
	
	// get the trigger for the trap
	trigger = getent("trap_barrel_trig", "targetname");
	
	// create a rope on the other side of the tree - hanging in the air
	start = trigger.origin + ( 0,0, -20 );
	end = start + (-15,10,500);
	offset = (0,-30,0);
	ropeid = createrope( start+offset, end+offset, 550 );

	// setup the firepoint for the grass guy
	firepoint = getstruct("trap_rope_struct", "targetname");
	firepoint.origin = trigger.origin + (0,0,320);

	// wait for someone to get into the trap	
	trigger waittill( "trigger", triggerer );

	// wait till this guy settles down - to avoid the hanging movement
	wait(0.2);

	// Just to make sure that triggerer is not player
	if ( !isplayer(triggerer) && ( triggerer.team != "axis" ) && ( triggerer.script_noteworthy == "guys_following_tank2_1"  )	)
	{
		flag_set("guy_trapped");

		// stop bullet shield and kill the guy
		if(isdefined( triggerer.magic_bullet_shield ) )
			triggerer thread stop_magic_bullet_shield();

		triggerer.NoFriendlyfire = true; 

		playsoundatposition( "trap_vx", triggerer.origin );

		triggerer thread bloody_death();

		triggerer thread blood_drop_effect();

		//should_gib = randomintrange(0,1);
		//if ( should_gib )
		//	triggerer.a.gib_ref = "right_arm";
		//else
		//	triggerer.a.gib_ref = "left_arm";

		deleterope( ropeid );
		createrope( end, (0,0,0), 320, triggerer, "j_ankle_ri" );
	
		wait(0.05);
		// delete the old barrel rope and create a new one so that barrel will drop down on ground
		//ropeid2 = getrope( "trap_rope" );
		//deleterope( ropeid2 );
				
		triggerer startragdoll();
		
		// get the struct to spawn rope
		//rope_start = getstruct("trap_rope_struct", "targetname");
		//createrope( rope_start.origin, (0,-8,40), 150, barrel );
	
		wait(0.1);
		triggerer animscripts\death::helmetPop();
	}
	
}

snare_trap_handle_triggerer()
{
	self.goalradius = 20;
	// Give the guy intermediate nodes
	self setgoalnode( getnode("trap_node1","targetname") );

	// set ignore all on this guy
	//self thread set_ignore_all();	

	if( !flag("trap_guy_area1") )
	{
		flag_wait("trap_guy_area1");
	}
		
	// kickoff the trap event
	self setgoalnode( getnode("trap_node","targetname") );
	
}

set_ignore_all()
{
	self waittill("goal");
	self.ignoreme = true;
	self.ignorall = true;
}

grass_guy_shoots_trapped_guy()
{
	self endon("death");

	flag_wait("guy_trapped");

	self.ignoreme = true;		

	// get rid of the exposure animscript
	self.exposedSetIgnore = true;

	// fire around the guy
	firepoint = getstruct("trap_rope_struct", "targetname");
	fireent = spawn ("script_origin", firepoint.origin + ( 0, 0, -100 ));	

	fireent.health = 1000000;

	self SetEntityTarget(fireent);
	
	if(isdefined( self.magic_bullet_shield ) )
		self thread stop_magic_bullet_shield();

	wait(randomintrange(4,7));

	self.ignoreme = false;
		
	if ( isdefined ( self ) && isalive(self) )	
		self ClearEntityTarget();
}



// Grass guy 2
setup_right_side_trap_guy()
{
	self thread print_trap_guy_overhead();

	// first set magic bullet shield on this guy
	self thread magic_bullet_shield();
	
	self thread right_side_grass_guy_trap_think();
	
	// then tell him to go to a node and kill some
	self setgoalnode( getnode("right_trap_node_1","targetname") );

	// make him ignore AI
	self thread set_ignore_all();
	
	// trigger 1
	trig = getent("check_point_with_trap","targetname");
	trig waittill("trigger");
	
	// then tell him to go to a node and kill some
	self setgoalnode( getnode("right_trap_node_2","targetname") );
}

right_side_grass_guy_trap_think()
{

	trigger = getent("grass_guy21_trig","targetname");

	// create a rope on the other side of the tree - hanging in the air
	start = trigger.origin + ( 0,0, -20 );
	end = start + (-15,10,800);
	offset = (0,-30,0);
	ropeid = createrope( start+offset, end+offset, 500 );

	// setup the firepoint for the grass guy
	firepoint = getstruct("trap_rope_struct2", "targetname");
	firepoint.origin = trigger.origin + (0,0,500);

	// wait for someone to get into the trap	
	trigger waittill( "trigger", triggerer );

	// wait till this guy settles down - to avoid the hanging movement
	wait(0.2);

	// Just to make sure that triggerer is not player
	if ( !isplayer(triggerer) && ( triggerer.team != "axis" ) && ( triggerer.script_noteworthy == "right_side_trap_guy"  )	)
	{

		flag_set("guy_trapped2");
		
		// stop bullet shield and kill the guy
		if(isdefined( self.magic_bullet_shield ) )
			triggerer thread stop_magic_bullet_shield();
	
		triggerer.NoFriendlyfire = true; 

		playsoundatposition( "trap_vx", triggerer.origin );

		triggerer thread blood_drop_effect();
		triggerer thread bloody_death();
	
		//should_gib = randomintrange(0,1);
		//if ( should_gib )
		//	triggerer.a.gib_ref = "right_arm";
		//else
		//	triggerer.a.gib_ref = "left_arm";	
	
		deleterope( ropeid );
		createrope( end, (0,0,0), 550, triggerer, "j_ankle_le" );
	
		wait(0.05);
		// delete the old barrel rope and create a new one so that barrel will drop down on ground
		//ropeid2 = getrope( "trap_rope" );
		//deleterope( ropeid2 );
				
		triggerer startragdoll();
		
		// get the struct to spawn rope
		//rope_start = getstruct("trap_rope_struct", "targetname");
		//createrope( rope_start.origin, (0,-8,40), 70, barrel );
	
		wait(0.1);
		triggerer animscripts\death::helmetPop();
	}
	else if ( !isplayer(triggerer) && ( triggerer.script_noteworthy != "right_side_trap_guy"  ) )
	{
		// in case an AI runs into this trigger other than the trap guy
		//flag_set("guy_trapped2");
	}

	
}


grass_guy_shoots_trapped_guy2()
{
	self endon("death");

	flag_wait("guy_trapped2");

	// get rid of the exposure animscript
	self.exposedSetIgnore = true;
	
	// fire around the guy
	firepoint = getstruct("trap_rope_struct2", "targetname");
	fireent = spawn ("script_origin", firepoint.origin + ( 0, 0, -100 ));	

	fireent.health = 1000000;

	self SetEntityTarget(fireent);

	if(isdefined( self.magic_bullet_shield ) )
		self thread stop_magic_bullet_shield();

	wait(randomintrange(5,8));
	
	// let him kill others now.	
	if ( isdefined ( self ) && isalive(self) )	
		self ClearEntityTarget();
}


blood_drop_effect()
{
	self endon("death");

	// show blood only if mature mode.
	if( !is_mature() )
		return;

	// play blood drop three time with 1 sec interval
	for ( i = 0; i < 5; i++ )
	{
		tags = "j_head";

		playfxontag(level._effect["blood_drop"], self, tags );
		
		wait(randomfloat(1 , 2));
		
	}
}

print_trap_guy_overhead()
{
	self endon("death");
	for(;;)
	{
		print3d(self.origin +(0,0,80) , "I am going to get trapped" );
		wait(0.5);
	}
}

/*
==============================================================================================================
custom introscreen setup - Not being used right now.
==============================================================================================================
*/

// do the custom introscreen
pel1b_custom_introscreen(string1, string2, string3, string4, string5)
{
	flag_wait( "all_players_connected" );

	level.introblack = NewHudElem(); 
	level.introblack.x = 0; 
	level.introblack.y = 0; 
	level.introblack.horzAlign = "fullscreen"; 
	level.introblack.vertAlign = "fullscreen"; 
	level.introblack.foreground = false; 
	level.introblack.sort = 50; 
	level.introblack SetShader( "black", 640, 480 ); 

	// MikeD (11/14/2007): Used for freezing controls on players who connect during the introscreen
	level._introscreen = false;

	wait( 4 );

	// Fade out black
	level.introblack FadeOverTime( 3 ); 
	level.introblack.alpha = 0;

	wait( 0.05 ); 
 
	level.introstring = []; 
	
	//Title of level
	if( IsDefined( string1 ) )
	{
		maps\_introscreen::introscreen_create_line( string1 ); 
	}

	wait(2);
	
	//City, Country, Date
	if( IsDefined( string2 ) )
	{
		maps\_introscreen::introscreen_create_line( string2 ); 
	}

	if( IsDefined( string3 ) )
	{
		maps\_introscreen::introscreen_create_line( string3 ); 
	}

	wait(1);
		
	if( IsDefined( string4 ) )
	{
		maps\_introscreen::introscreen_create_line( string4 ); 
	}

	wait(1);

	if( IsDefined( string5 ) )
	{
		maps\_introscreen::introscreen_create_line( string5 ); 
	}
	
	level notify( "finished final intro screen fadein" ); 

	wait(1);

	// Fade out text
	maps\_introscreen::introscreen_fadeOutText(); 

	flag_set( "introscreen_complete" ); // Notify when complete
}
