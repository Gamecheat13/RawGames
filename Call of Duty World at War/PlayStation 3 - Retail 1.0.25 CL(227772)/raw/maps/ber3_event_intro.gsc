//
// file: ber3_event_intro.gsc
// description: intro event script for berlin3
// scripter: joyal
//

// pak:  intro_road_pak
//
//
// node_scripted targetname for the waving flag on the reichstag: ber3_stag_flag_anim
// node_scripted targetname for column collapse: ber3_column_collapse
// node_scripted targetname for tank trap: ber3_tank_trap
// ber3_commisar_tank is the node for the commissar on the tank anim
//
// [15:58] ssasakiATVI: rolled up flag model
// [15:58] ssasakiATVI: [Melissa Buffaloe (Treyarch) -- 08/20/08 03:00:01 PM]
//  C:\cod5\cod\cod5\model_export\props_berlin\flag\static_berlin_rus_flag_rolled.ma 


#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\ber3;
#include maps\ber3_util;
#include maps\_music;
#include maps\_busing;
// -- STARTS --
// start at the very beginning of the intro
event_intro_start()
{		
	warp_players_underworld();
	warp_friendlies( "struct_intro_start_friends", "targetname" );
	warp_players( "struct_intro_start", "targetname" );

	// set up the spawners for the level
	thread simple_spawners_level_init();
	
	level thread event_intro_setup();
}
// -- END STARTS --



event_intro_setup()
{
	//wait(1);
	
	//TUEY CUSTOM BUSING
	setbusstate("INTRO");

	thread e1_intro_scene();
	
	thread hanged_germans_init();
	thread e1_drones();
	
	thread event_intro_action();
	thread e1_alley();
	thread e1_tank_trap();
	thread e1_move_vehicles();
	
	//thread drop_bodies();
	
	thread delete_street_allies();
	
	thread reich_flag_waving();
	
	// wait for the next event to start
	thread maps\ber3_event_plaza::e2_init_charge();
	
	battlechatter_off("allies");
}



event_intro_action()
{	
	wait(3);
	
	level notify("start katyusha");
	
	thread e1_rus_listeners();
	thread e1_intro_friendlies_move();		// Used to move the friendlies through the streets up until the first line battle
	
	getent("trig_intro_start_friendlies", "targetname" ) notify( "trigger" );
	getent("e1_spawn_vehicles", "targetname" ) notify( "trigger" );
	
	comm_node = getnode("ber3_commisar_tank", "targetname");
	
	level.comm = getent("Commissar", "targetname");
	level.comm.animname = "commissar";
	
	
	wait(5);
	level.comm anim_single_solo(level.comm, "intro_comm_1");	// "Brave comrades - This day - The Fascist empire will yield to the iron fist of the Red Army."
	
	wait(2);
	level.comm anim_single_solo(level.comm, "intro_comm_2");	// "Cut down those in front of you as though they are but fields of wheat and rye."
	
	wait(1);
	level.comm anim_single_solo(level.comm, "intro_comm_3");	// "We are Russia’s blood. "
	
	wait(2);
	level.comm anim_single_solo(level.comm, "intro_comm_4");	// "Drown this wretched Germany in the blood of its own!!!"
	
	level waittill("intro ended");
	
	
	autosave_by_name("berlin3 start");
	
	//TUEY CUSTOM BUSING
	setbusstate("RESET");
	
	thread art_move();			// Move the artillery piece to it's final place
	
	comm_node thread anim_loop_solo(level.comm, "comm_waving", undefined, "stop_comm_intro_loop");	
	
	getent("trig_intro_comm_totheleft", "targetname") waittill("trigger");
	
	thread hud_show();  // failsafe 1
	
	comm_node notify("stop_comm_intro_loop");
	
	comm_node anim_single_solo(level.comm, "comm_talking");
	//level.comm anim_single_solo(level.comm, "intro_comm_5");	// "Sergeant…"	-- these lines now called via notetrack
	//level.comm anim_single_solo(level.comm, "intro_comm_6");	// "Take the left flank and eradicate whatever scum remains in defense of each building."
	
	level notify("comm talked to rez");
	
	//TUEY CUSTOM BUSING
	setbusstate("RESET");
	
	comm_node thread anim_loop_solo(level.comm, "comm_waving");	
	
	thread hud_show();  // failsafe 2
}

e1_intro_friendlies_move()
{
	level waittill("intro ended");
	
	level.hit_first_move_trig = false;
	thread watch_first_move_trig();
	
	// Move the friendlies after the intro anim is done
	getent("e1_friendlies_move0", "targetname" ) notify( "trigger" );	
	
	level waittill("comm talked to rez");
	
	level.sarge anim_single_solo(level.sarge, "intro_rez_09");	// "Yes, Commissar."
	level.sarge	thread anim_single_solo(level.sarge, "intro_rez_10");	// "You heard him, comrades... To the left!"
	
	// Move the friendlies past the tanks
	if(!level.hit_first_move_trig)
	{
		getent("e1_friendlies_move1", "targetname" ) notify( "trigger" );	
	}
	
	wait (5);
	
	level.sarge anim_single_solo(level.sarge, "intro_rez_07");	// "We are in the final hours of Berlin's downfall…"
	level.sarge anim_single_solo(level.sarge, "intro_rez_08");	// "We are in the final hours of Berlin's downfall…"
}

watch_first_move_trig()
{
	getent("trig_move_tank", "targetname") waittill("trigger");
	
	level.hit_first_move_trig = true;
}

e1_rus_listeners()
{
	listeners = getentarray("e1_rus_listener", "targetname");
	
	for(i = 0; i < listeners.size; i++)
	{
		listeners[i].animname = "redshirt";
		
		if( randomint(2) == 0 )
		{
			listeners[i] thread anim_loop_solo(listeners[i], "comm_listen_idle");
		}
		else
		{
			listeners[i] thread anim_loop_solo(listeners[i], "comm_listen_idle2");
		}
	}
}



e1_drones()
{
	drone_trigs = getentarray("drone_allies", "targetname");
	drone_trigs_axis = getentarray("drone_axis", "targetname");
	
	for(i = 0; i < drone_trigs_axis.size; i++)
	{
		drone_trigs = array_add( drone_trigs, drone_trigs_axis[i] );
	}
	
	trig_int_drones = undefined;
	
	level.trig_charge_drones = [];

	// These are only used for coop, to turn off the drone trigger
	level.trig_building_drones = [];
	level.trig_alley1_drones = [];
	level.trig_plaza_drones = [];
	level.trig_reich_drones = [];
	
	// find the two correct triggers
	for(i = 0; i < drone_trigs.size; i++)
	{
		if( isdefined(drone_trigs[i].script_string) && drone_trigs[i].script_string == "intro_drones")
		{
			trig_int_drones = drone_trigs[i];
		}
		else if( isdefined(drone_trigs[i].script_string) && drone_trigs[i].script_string == "charge_drones")
		{
			//array_add( level.trig_charge_drones, drone_trigs[i] );
			level.trig_charge_drones[level.trig_charge_drones.size] = drone_trigs[i];
		}
		else if( isdefined(drone_trigs[i].script_string) && drone_trigs[i].script_string == "final_drones")
		{			
			level.trig_final_drones = drone_trigs[i];
		}
		else if( isdefined(drone_trigs[i].script_string) && drone_trigs[i].script_string == "building_drones")
		{
			level.trig_building_drones[level.trig_building_drones.size] = drone_trigs[i];
		}			
		else if( isdefined(drone_trigs[i].script_string) && drone_trigs[i].script_string == "alley1_drones")
		{
			level.trig_alley1_drones[level.trig_alley1_drones.size] = drone_trigs[i];
		}	
		else if( isdefined(drone_trigs[i].script_string) && drone_trigs[i].script_string == "plaza_drones")
		{
			level.trig_plaza_drones = array_add( level.trig_plaza_drones, drone_trigs[i] );
			//level.trig_plaza_drones[level.trig_plaza_drones.size] = drone_trigs[i];
		}	
		else if( isdefined(drone_trigs[i].script_string) && drone_trigs[i].script_string == "reich_drones")
		{
			level.trig_reich_drones[level.trig_reich_drones.size] = drone_trigs[i];
		}	
	}
	
	if(NumRemoteClients())	// In coop, remove all drones from events with bandwidth problems.
	{
		for(i = 0; i < level.trig_alley1_drones.size; i ++)
		{
			level.trig_alley1_drones[i] delete();
		}
		
		for(i = 0; i < level.trig_plaza_drones.size; i ++)
		{
			level.trig_plaza_drones[i] delete();
		}

		for(i = 0; i < level.trig_reich_drones.size; i ++)
		{
			level.trig_reich_drones[i] delete();
		}
		
		ent = getent("e2_spawn_right_tanks", "targetname");
		if(isdefined(ent))
		{
			ent delete();
		}

	}
	
	// wait to trigger each of them
	level waittill("intro ended");
	trig_int_drones notify("trigger");
}


////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Intro:  Player getting dragged up the stairs / Vision Settings
////////////////////////////////////////////////////////////////////////////////////////////////////////

// The AI animation for the intro
e1_intro_scene()
{
	//level waittill( "finished final intro screen fadein" ); 
	share_screen( get_host(), true, true );
	
	players = get_players();
	array_thread(players, ::wakeup_in_fountain);	
	
	thread do_custom_introscreen();
	
	wait(.5);
	
	guys = [];
	guys[0] = level.sarge;
	guys[0].animname = "reznov";
	guys[1] = level.chernov;
	guys[1].animname = "chernov";
	guys[2] = getent("redshirt1", "script_noteworthy");
	guys[2].animname = "redshirt1";
	
	anode = getent("e1_anim_intro_struct", "targetname");	
	
	thread play_intro_on_all_players(anode);
	//thread play_intro_vo();
	
	//level.sarge.disableArrivals = true;
	
	level.chernov Attach( "static_berlin_books_diary", "tag_inhand" );
	level.sarge attach( "weapon_rus_ppsh_smg", "tag_inhand" );
	//guys[2] Attach( "static_ber_rus_flag", "tag_inhand" );
	
	guys[2] thread intro_rus_flag();
	anode anim_single( guys, "intro" );
	
	level notify("intro ended");
	
	level.chernov detach( "static_berlin_books_diary", "tag_inhand" );
	//guys[2] detach( "static_ber_rus_flag", "tag_inhand" );
	thread add_flag_to_chernov();
	
	wait(1);
	
	share_screen( get_host(), false );
	//show_all_player_models();
	
	//level.sarge.disableArrivals = false;
	
	thread e1_objectives();
	
	level.sarge detach( "weapon_rus_ppsh_smg", "tag_inhand" );
}

add_flag_to_chernov()
{
	level.cher_rus_flag = spawn("script_model", level.chernov.origin);
	level.cher_rus_flag setmodel("anim_berlin_rus_flag_rolled_sm");
	level.cher_rus_flag linkto( level.chernov, "TAG_STOWED_BACK", (10, 1.5, 0), (16, 178, 0) );
}

play_intro_on_all_players(anode)
{
	hide_all_player_models();

	flag_wait( "all_players_connected" );
	flag_wait( "all_players_spawned" );
	
	players = get_players();
	lerp_nodes = getstructarray("intro_coop_starts", "targetname");
	//players[0] thread play_intro_on_player( "intro", anode );
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread play_intro_on_player( "intro", anode, i, lerp_nodes[i] );
	}
	
	for(i=0;i<18;i++)
	{
		rumble_all_players("damage_light");
		earthquake(.2,1,players[0].origin,128);
		wait(1);				
	}
	
}



// Handles the spawning/lerping/playing animation of the viewhands
// self is a player
play_intro_on_player( anime, node, index, lerp_node )
{
	self endon( "disconnect" );

	self disableWeapons();

	viewhands = spawn_anim_model( "player_hands" );
	//viewhands Hide();

	wait_network_frame();

	self.viewhands = viewhands;

	// Set the origin of the viewhands
	org = GetStartOrigin( node.origin, node.angles, level.scr_anim["player_hands"][anime] );
	angles = GetStartAngles( node.origin, node.angles, level.scr_anim["player_hands"][anime] );
	viewhands.origin = org;
	viewhands.angles = angles; 

	self PlayerLinkTo( viewhands, "tag_player", 1, 20, 20, 20, 0); //, 30, 30, 20, 20 );

	node anim_single_solo( viewhands, anime ); 

	//self Unlink();
	if( index != 0 )
	{
		self Unlink();
	}	
	
	viewhands Delete();

	level notify( anime + "_viewhands_anim_done" );
	
	self play_player_lerp_to_pos( index, lerp_node );
}



// See1_anim love, to get multiple players not starting inside one another
play_player_lerp_to_pos( index, lerp_node )
{
	level notify( "intro_restore_share_screen" );

	if( index != 0 )
	{
		org = Spawn( "script_origin", self.origin );
		org.angles = self.angles;
	
		self PlayerLinkTo( org, "", 1, 5, 5, 5, 5 );
	
		org MoveTo( lerp_node.origin + ( 0, 0, 5 ), .5, 0, .5 );
		org RotateTo( lerp_node.angles, .5, 0, .5 );

		wait( .5 );
	
		self Unlink();
	
		self show();
	
		org Delete();
	}
	else
	{
		org = Spawn( "script_origin", self.origin );
		org.angles = self.angles;
	
		self PlayerLinkTo( org, "", 1, 5, 5, 5, 5 );
	
		org MoveTo( self.origin + ( 0, 0, 4 ), .5, 0, .5 );		

		wait( .5 );
		self Unlink();
		//iprintlnbold( "unlink" );
		self show();
	}

//	self AllowStand( true );
//	self Allowcrouch( true );
//	self allowprone( true );
//	self setstance( "stand" );
	self enableWeapons();
}



groggy_wakeup()
{
	//TUEY SET MUSIC STATE TO INTRO
	setmusicstate("INTRO");

	overlay = newClientHudElem(self);
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	overlay.sort = 1;

	//VisionSetNaked("ber3",0);
	self shellshock( "ber3_intro", 18 );// fade out over 1 sec, wait 2, fade in over 5
	overlay fadeOverlay( 0.01, 1, 6 );
	wait 2.5;
	overlay restoreVision( 2, .8);
	wait 2;
	overlay fadeOverlay( 2.5, 1, 5 );
	//VisionSetNaked("ber3",15);
	wait 0.5;
	overlay fadeOverlay( 2.5, 0.2, 3);
	earthquake(0.1, 15, get_players()[0].origin, 500);
	overlay restoreVision( 6, 0 );
	
	// Allow standing and all that jazz again after the anim ends
	level waittill("intro ended");
	turn_off_vision_settings();
}

wakeup_in_fountain()
{
	self thread groggy_wakeup();
	self allowstand(true);
	self allowcrouch(false);
	self allowprone(false);
	self allowsprint(false);
	self allowjump(false);
	//self setstance("prone");
	self hud_hide();
	self setclientdvar("miniscoreboardhide","1");
	//self Setclientdvar( "bg_prone_yawcap", "42" );
	//self.nopronerotation = true;
	//self player_speed_set(1,1);
	
}

turn_off_vision_settings()
{
	players = get_players();
	
	for (i=0; i < players.size; i++)
	{
		players[i] allowprone(true);
		players[i] allowcrouch(true);
		players[i] allowsprint(true);
		players[i] allowjump(true);
		players[i] setclientdvar("miniscoreboardhide","0");
		//players[i].nopronerotation = false;
	}	
	
	hud_show();
	
	//TUEY SET MUSIC STATE TO INTRO
	setmusicstate("WAKE_UP");
}

// copied from hunted, only use at begining of level in fountain
player_speed_set(speed, time)
{
	currspeed = int( getdvar( "g_speed" ) );
	goalspeed = speed;
	if( !isdefined( self.g_speed ) )
		self.g_speed = currspeed;     
	range = goalspeed - currspeed;
	interval = .05;
	numcycles = time / interval;
	fraction = range / numcycles;          
	while( abs(goalspeed - currspeed) > abs(fraction * 1.1) )
	{
		currspeed += fraction;
		setsaveddvar( "g_speed", int(currspeed) );
  		wait interval;
	}
	setsaveddvar( "g_speed", goalspeed );
}

hud_hide()
{
	wait 0.1;
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", "0" );
		player SetClientDvar( "compass", "0" );
		player SetClientDvar( "ammoCounterHide", "1" );
	}
}

hud_show()
{
	wait 0.1;
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", "1" );
		player SetClientDvar( "compass", "1" );
		player SetClientDvar( "ammoCounterHide", "0" );
	}
}

// copied from coup, fades screen from black and sets a blur
restoreVision( duration, blur )
{
	//wait duration;
	self fadeOverlay( duration, 0, blur );
}

// copied from coup, basically fades screen to/from black and sets a blur
fadeOverlay( duration, alpha, blur )
{
	self fadeOverTime( duration );
	self.alpha = alpha;
	get_players()[0] setblur( blur, duration );
	wait duration;
}



do_custom_introscreen()
{
	wait(1);
	custom_introscreen( &"BER3_INTROSCREEN_TITLE", &"BER3_INTROSCREEN_DATE", &"BER3_INTROSCREEN_PLACE", &"BER3_INTROSCREEN_NAME", &"BER3_INTROSCREEN_INFO" );
}

custom_introscreen( string1, string2, string3, string4, string5 )
{
/#
	if( GetDvar( "introscreen" ) == "0" )
	{
		waittillframeend; 
		level notify( "finished final intro screen fadein" ); 
		waittillframeend; 
		flag_set( "starting final intro screen fadeout" );
		waittillframeend; 
		level notify( "controls_active" ); // Notify when player controls have been restored
		waittillframeend; 
		flag_set( "introscreen_complete" ); // Do final notify when player controls have been restored
		flag_set( "pullup_weapon" ); 
		return; 
	}

	if( level.start_point != "default" )
	{
		return;
	}
#/

	level.introstring = []; 
	wait 2;
	//Title of level
	if( IsDefined( string1 ) )
	{
		maps\_introscreen::introscreen_create_line( string1, "lower_left" ); 
	}

	wait( 2 );

	if( IsDefined( string2 ) )
	{
		maps\_introscreen::introscreen_create_line( string2, "lower_left" ); 
		wait 2;
	}

	if( IsDefined( string3 ) )
	{
		maps\_introscreen::introscreen_create_line( string3, "lower_left" ); 
		wait 1.5;
	}

	
	if( IsDefined( string4 ) )
	{
		maps\_introscreen::introscreen_create_line( string4, "lower_left" ); 
		wait 1.5;
	}

	if( IsDefined( string5 ) )
	{
		maps\_introscreen::introscreen_create_line( string5, "lower_left" ); 
	}

	wait 3;
	level thread maps\_introscreen::introscreen_fadeOutText(); 
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Intro:  Vehicle Movement and Whatnot
////////////////////////////////////////////////////////////////////////////////////////////////////////

// Start all the vehicles
e1_move_vehicles()
{
	thread start_vehicle_trig();
	thread loop_fire_katyusha();	// Have the katyusha fire it's rockets
	if(!NumRemoteClients())
	{
		thread overhead_planes();	// Pulled out of coop
	}

	tank1 = getent("e1_tank1", "targetname");
	tank2 = getent("e1_tank2", "targetname");
	tank3 = getent("e1_tank3", "targetname");
	//tank4 = getent("e1_tank4", "targetname");
	//tank5 = getent("e1_tank5", "targetname");
	
	// Move all the tanks forward
	tank1 thread move_tank_on_trigger("e1_amb_tank", "e1_start_vehicles");
	tank2 thread move_tank_on_trigger("e1_amb_tank2", "e1_start_vehicles");
	tank3 thread move_tank_on_trigger("e1_amb_tank3", "e1_start_vehicles");
	//tank4 thread move_tank_on_trigger("e1_amb_tank4", "e1_start_vehicles");
	//tank5 thread move_tank_on_trigger("e1_amb_tank5", "e1_start_vehicles");
	
	getent("e1_start_vehicles", "targetname") waittill("trigger");
	
	// Stop the back two tanks until the artillery has moved forward
	//wait(9);			// TEMP: replace with a trigger or something
	
	//tank2 SetSpeed(0, 2, 1);
	//tank3 SetSpeed(0, 2, 1);
	
	// Have the tanks resume their drive forward
	// level waittill("artillery moved");
	
	//wait(9);		// need a few extra seconds
	
	//tank2 SetSpeed(5, 2, 1);
	//tank3 SetSpeed(5, 2, 1);
}



// Grab the trigger to start the vehicles and start it at the correct time
start_vehicle_trig()
{
	//level waittill("intro ended"); 
	
	wait(32);
	
	getent("e1_start_vehicles", "targetname") notify("trigger");
}



// Move the artillery forward
art_move()
{	
	level endon("delete street allies");
	
	//getent("e1_start_vehicles", "targetname") waittill("trigger");
	
	wait (0.1);	
	
	thread e1_pak2_animate();
	
	artpiece = getent("e1_art1","targetname");	
		
	thread e1_pak_crew_move();				// Set up the actors for the animation
	thread e1_pak_move();							// Set up the pak43 for the animation
	
	wait(2);		// Replace with a trigger or something
	
	level notify("start pak anims");	
	
	//thread notify_tanks();
	
	//artpiece maps\_artillery::arty_move(getnode("e1_art1_goto3","targetname").origin);		
	//artpiece maps\_artillery::arty_fire();	
}

e1_pak2_animate()
{
	level endon("delete street allies");
	
	art2 = getent("e1_art2", "targetname");
	anode = getstruct("intro_pak2_struct", "targetname");
	
	crew = getentarray("e1_art2_crew", "targetname");
	
	art2 thread e1_pak_shoot(art2, anode);
	crew thread e1_pak_crew_shoot(crew, anode);
}



// Wait a few seconds, then notify the tanks to move
notify_tanks()
{
	wait(3);
	level notify("artillery moved");	
}



loop_fire_katyusha()
{
	level endon("stop katyusha");
	level.loop_katyusha = true;
	
	//getent("e1_start_vehicles", "targetname") waittill("trigger");
	
	level waittill("start katyusha");
	
	kat1 = getent("e1_katyusha", "targetname");
	kat2 = getent("e1_katyusha2", "targetname");
	
	targets = getstructarray( "e1_katyusha_target", "targetname" );
	
	kat1 thread katyusha_trucks_fire( targets, 2500, 150 );
	kat2 thread katyusha_trucks_fire( targets, 2500, 150 );
	
	while(level.loop_katyusha)
	{
		kat1 notify("fire rockets");
		wait(7);
		kat2 notify("fire rockets");
		wait(10);
	}
}



// Removes the friendles around the street
delete_street_allies()
{
	getent("trig_left_street", "targetname") waittill("trigger");
	
	wait(.25);
	
	level notify("delete street allies");
	level notify("stop katyusha");
	
	street_vehicles = getentarray("rus_street_vehicles", "script_noteworthy");
	street_allies = getentarray("rus_street_soldiers", "script_noteworthy");
	
	wait(2);
	
	// Delete the allies
	for(i = 0; i < street_allies.size; i++)
	{
		if( isdefined(street_allies[i]) )
		{
			//street_allies[i] notify("death");
			street_allies[i] thread bloody_death( true );
			//wait_network_frame();
			//street_allies[i] delete();
		}
	}
	
	wait(1);
	
	// delete the vehicles
	for(i = 0; i < street_vehicles.size; i++)
	{
		if( isdefined(street_vehicles[i]) )
		{			
			street_vehicles[i] delete();
		}
	}	
	
	// hax!
	for(i = 0; i < street_allies.size; i++)
	{
		if( isdefined(street_allies[i]) )
		{
			//street_allies[i] notify("death");
			street_allies[i] delete();
		}
	}	
	
	wait(1);
	battlechatter_on("allies");		// turn battle chatter back on
}


// Spawn in the planes
overhead_planes()
{
	//getent("e1_start_vehicles", "targetname") waittill("trigger");
	
	stuka_nodes = getvehiclenodearray("e1_stuka_start", "targetname");
	il2_nodes = getvehiclenodearray("e1_il2_start", "targetname");
	
	for(i = 0; i < stuka_nodes.size; i++)
	{
		thread spawn_plane("vehicle_stuka_flying", stuka_nodes[i]);
		wait_network_frame();
	}	
	
	for(i = 0; i < il2_nodes.size; i++)
	{
		thread spawn_plane("vehicle_rus_airplane_il2", il2_nodes[i]);
		wait_network_frame();
	}
}



hanged_germans_init()
{
	wait(1);
	
	hanged_ger = getentarray("hanged_ger", "script_noteworthy");
	for(i = 0; i < hanged_ger.size; i++)
	{
		hanged_ger[i] hangguy_with_ragdoll( "J_Neck", hanged_ger[i].script_int );		
		wait_network_frame();
	}
}



// Dead bodies tossed out of buildings
drop_bodies()
{
	drop_guy1 = getent("temp_drop_body1", "targetname");
	drop_guy3 = getent("temp_drop_body3", "targetname");
	drop_guy4 = getent("temp_drop_body4", "targetname");
	
	getent("temp_trig_drop_body1", "targetname") waittill("trigger");
	drop_guy1 startragdoll();
	
	getent("temp_trig_drop_body3", "targetname") waittill("trigger");
	level.sarge thread anim_single_solo(level.sarge, "intro_rez_11");	// "This way!"
	drop_guy3 startragdoll();
	//Kevin adding scream and smack of falling guy
	drop_guy3 playsound("german_fall_scream");
	wait 1.5;
	drop_guy3 playsound("german_fall_smack");
	
	getent("temp_trig_drop_body4", "targetname") waittill("trigger");
	drop_guy4 startragdoll();
	
}



////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Event 1:  Player reaches the alley
////////////////////////////////////////////////////////////////////////////////////////////////////////

e1_alley()
{
	thread e1_init_molotov_throwers();
	thread shreck_fired_to_house();
	thread rus_shreck_fired();
	thread delete_house_allies();
	thread move_other_tanks();
	thread amb_alley();
	thread e1_library_knock_bookshelf_over(); // TEMP location - find a proper home for it
	thread e1_exiting_library_vo();
	thread e2_alley_tanks();
	thread e1_entering_house_vo();
	
	// spawn repopulate_flak on each of the flaks in the level
	for(i = 0; i < 4; i++)
	{
		thread maps\ber3_event_plaza::wait_repopulate_flak(i + 10);
	}	
}

e1_entering_house_vo()
{
	getent("trig_alley_flank_vo", "targetname") waittill("trigger");
	
	level.sarge anim_single_solo(level.sarge, "e1_rez_03");	// "Flank the building from both sides!"
	level.sarge anim_single_solo(level.sarge, "e1_rez_04");	// "Dimitri - With me!"
}

// Fires shrecks at the house
shreck_fired_to_house()
{
	getent("e1_shreck_to_house", "targetname") waittill("trigger");
	
	shreck_start_pos = getstruct("shreck_start", "targetname");
	shreck_end_pos = getstruct("e1_house_shreck_pos", "targetname");
	
	thread fire_shrecks(shreck_start_pos, shreck_end_pos, 1.5);
	wait(.5);
	
	shreck_end_pos = getstruct("e1_house_shreck_pos2", "targetname");
	thread fire_shrecks(shreck_start_pos, shreck_end_pos, 1.5);
}



rus_shreck_fired()
{
	getent("trig_entering_alley", "targetname") waittill("trigger");
	
	wait(4);
	
	shreck_start_pos = getstruct("e1_rus_shreck_start", "targetname");
	shreck_end_pos = getstruct("e1_rus_shreck_end", "targetname");
	
	thread fire_shrecks(shreck_start_pos, shreck_end_pos, 0.5);	
	
	wait(.6);
	
	e1_alley_bricks();
	
	fxorg = getent("fx_e1_exp_wall", "targetname");
	playFX( level._effect["brick_explode"], fxorg.origin, fxorg.angles );
	
	level notify("shreck_hit_window");
	
	//wait(1);
	
	level.sarge  anim_single_solo(level.sarge, "intro_rez_12");	// "Look Chernov, the Germans hang their cowards from trees."
	
	wait(1);
	
	level.sarge anim_single_solo(level.sarge, "e1_rez_01");	// "Make sure you keep hold of that  flag, Chernov."	
	
	wait(1);
	
	level.sarge anim_single_solo(level.sarge, "e1_rez_02");	// "Keep fire on that building!"
}


// Moves the other tanks outside of the library around the side of the building
move_other_tanks()
{
	tank2 = getent("e1_tank2", "targetname");
	tank3 = getent("e1_tank3", "targetname");
	
	tank2 thread move_tank_on_trigger("e1_tank2_start_node", "trig_exiting_library");
	tank3 thread move_tank_on_trigger("e1_tank3_start_node", "trig_exiting_library");
}


overhead_fire_start()
{
	thread overhead_german_firing();
	
	getent("trig_left_street", "targetname") waittill("trigger");
	
	thread overhead_fire_end();
	
	clientNotify("iff");
	/*
	struct_tracers = getstructarray("e1_tracer_struct", "targetname");
	
	for(i = 0; i < struct_tracers.size; i++)
	{
		thread loop_tracers(struct_tracers[i].origin, struct_tracers[i].targeted[0].origin);
	}
	*/
}

loop_tracers(startPoint, endPoint)
{
	level endon("stop_tracers");
	
	while(true)
	{
		wait( randomFloatRange(0.1, 0.5) );
		
		bulletTracer(startPoint, endPoint);
	}
}

overhead_fire_end()
{
	getent("e1_shreck_to_house", "targetname") waittill("trigger");
	
	level notify("stop_tracers");
	clientNotify("siff");
}

overhead_german_firing()
{	
	shooting_ai = getentarray( "e1_ger_upstairs", "script_noteworthy" );
	amb_target = getentarray( "e1_ger_target", "targetname" );
	
	for(i = 0; i < shooting_ai.size; i++)
	{
		if( isdefined(shooting_ai[i]) )
		{
			shooting_ai[i] thread add_spawn_function(::ai_set_target, amb_target[i] );
		}
	}	
	
	mg_ai = getent("e1_ger_upstairs_mg", "script_noteworthy");
	mg_ai_targ = getent("e1_ger_target_mg", "targetname");
	
	mg_ai thread add_spawn_function(::ai_set_target, mg_ai_targ);
	mg_ai thread add_spawn_function(::e1_alley_mg_death);
	
	thread wait_upstairs_fallback();
}



ai_set_target(targ)
{
	self endon("death");
	
	wait(2);
	
	if( isdefined(targ) )
	{
		self setentitytarget( targ, 1 );
	}
	
	level waittill("house_fallback");
	
	// Allow the actor to fall back to a different goal volume
	self clearEntityTarget();
	self.script_goalvolume = 6;
}



e1_alley_mg_death()
{
	level waittill("shreck_hit_window");
	
	//TUEY Set Music State to First Fight
	setmusicstate("FIRST_FIGHT");

	mg_ai = getent("e1_ger_upstairs_mg", "script_noteworthy");
	mg_ai delete();

	self thread bloody_death(true);
}



wait_upstairs_fallback()
{
	getent("trig_e1_upstairs_ger_fallback", "script_noteworthy") waittill("trigger");
	level notify("house_fallback");
}

// Removes the friendlies from the house, as the player will not see them anymore
delete_house_allies()
{
	getent("trig_exited_library", "targetname") waittill("trigger");

	//TUEY SET MUSIC STATE to "POST_LIBRARY"
	setmusicstate("POST_LIBRARY");
	
//	house_allies = getentarray("rus_house_soldiers", "script_noteworthy");
//	
//	for(i = 0; i < house_allies.size; i++)
//	{
//		if( isdefined(house_allies[i]) )
//		{
//			house_allies[i] delete();
//		}
//	}
	
	remove_allies = get_ai_group_ai("house_ai");
	for(i = 0; i < remove_allies.size; i++)
	{
		remove_allies[i] notify( "_disable_reinforcement" );
		remove_allies[i].script_no_respawn = 1;
		remove_allies[i] thread bloody_death(true);
	}	
}



amb_alley()
{	
	thread overhead_fire_start();
	
	getent("trig_entering_alley", "targetname") waittill("trigger");
	
	wait(1);											// pause so the network can calm down
	
	thread amb_alley_katyusha();
	wait(1);											// pause so the network can calm down
	thread amb_alley_planes();
	
	// Change the color on a few friendlies
	guys = getentarray("rus_leave_at_library", "script_noteworthy");
	
	for(i = 0; i < guys.size; i++)
	{
		if( isdefined(guys[i]) && isalive(guys[i]) )
		{
			guys[i] set_force_color("o");
			guys[i].script_noteworthy = "e1_friendly_fodder";
			guys[i] notify( "_disable_reinforcement" );
		}
	}
	
	thread remove_friendly_fodder();
	
	if(!NumRemoteClients())	// Dont do alley tanks in coop
	{
		wait(3);
		
		// spawn some tanks past the alley
		tank_node = getvehiclenode("alley_tank_node", "targetname");
		thread spawn_tank("vehicle_rus_tracked_t34", tank_node, true );
		wait(7);
		thread spawn_tank("vehicle_rus_tracked_t34", tank_node, true );
		wait(10);
		thread spawn_tank("vehicle_rus_tracked_t34", tank_node, true );	
	}
}



remove_friendly_fodder()
{
	getent("trig_exited_library", "targetname") waittill("trigger");
	
	guys = getentarray("e1_friendly_fodder", "script_noteworthy");
	
	for(i = 0; i < guys.size; i++)
	{
		if( isdefined(guys[i]) && isalive(guys[i]) )
		{
//			guys[i] notify("death");
//			wait(.1);
			guys[i] delete();
		}
	}	
}

e1_exiting_library_vo()
{
	getent("trig_exiting_library", "targetname") waittill("trigger");
	
	thread bullet_shield_commissar();
	thread warp_players_after_library();
	
	level.sarge anim_single_solo(level.sarge, "e1_rez_window");	// "Through the window - GO!"
	
	wait(1);

	level.sarge anim_single_solo(level.sarge, "e1_rez_06");	// "Our tanks will have to find another way around."
	level.sarge anim_single_solo(level.sarge, "e1_rez_07");	// "We take the direct route!"
}

bullet_shield_commissar()
{
	spawner = getent("basement_comm", "script_noteworthy");
	
	spawner add_spawn_function( ::give_bullet_shield );
}

give_bullet_shield()
{
	level.comm = self;
	self.animname = "commissar";
	self thread magic_bullet_shield();
	
	self animscripts\shared::PlaceWeaponOn( self.primaryweapon, "none");
	
	self thread anim_loop_solo( level.comm, "comm_whistle_idle", undefined, "stop_comm_idle" );
}



warp_players_after_library()
{
	getent("trig_warp_after_library", "targetname") waittill("trigger");
	
	volume = getent("trig_trap_warpto_check", "targetname");
	warpto_spots = getstructarray("struct_warp_after_library", "targetname");
	
	players = get_players();
	
	for(i = 0; i < players.size; i++)
	{
		if( !(players[i] istouching(volume)) )
		{
			players[i] warp_player( warpto_spots[i].origin );
		}
	}
}



amb_alley_planes()
{
	if(!NumRemoteClients()) // Pulled out of coop.
	{
		// Spawn a formation of planes past the alley
		plane_nodes1 = getvehiclenodearray("e1_il2_alley1", "targetname");
		plane_nodes2 = getvehiclenodearray("e1_il2_alley2", "targetname");
		plane_nodes3 = getvehiclenodearray("e1_il2_alley3", "targetname");
	
		// spawn first formation of planes	
		for(i = 0; i < plane_nodes1.size; i++)
		{
			thread spawn_plane("vehicle_rus_airplane_il2", plane_nodes1[i]);
			wait_network_frame();
		}	
		
		wait(2);
		
		// spawn second formation of planes
		for(i = 0; i < plane_nodes2.size; i++)
		{
			thread spawn_plane("vehicle_rus_airplane_il2", plane_nodes2[i]);
			wait_network_frame();
		}	
		
		wait(4);
		
		// spawn second formation of planes
		for(i = 0; i < plane_nodes3.size; i++)
		{
			thread spawn_plane("vehicle_rus_airplane_il2", plane_nodes3[i]);
			wait_network_frame();
		}	
	}
}



amb_alley_katyusha()
{	
	level endon("stop katyusha");
	
	wait(10);
	
	kat = getent("e1_alley_katyusha", "targetname");
	targets = getstructarray( "e1_katyusha_target", "targetname" );
	
	kat thread katyusha_trucks_fire( targets, 2500, 150 );
	
	while(level.loop_katyusha)
	{
		//kat thread fire_katyusha();
		kat notify("fire rockets");
		wait(15);
	}	
}



// setup the forward Katyusha trucks and rockets then fire them
// catenary is the flatness of the rockets trajectory
// z_moveto_offset is helps determine how to move them along the truck's platform
katyusha_trucks_fire( targets, catenary, z_moveto_offset )
{
	self endon("stop firing");
	self endon("death");
	
	while(true)	
	{
		truck_rockets = [];
		
		tag = undefined;
		tag_pos = undefined;
		tag_angles = undefined;
		rocket = undefined;

		numRockets = 16;
		
		if(NumRemoteClients())
		{
			numRockets = 12;		// Slight reduction in barrage size...
		}
	
		self waittill("fire rockets");
		
		for(i = 0; i < numRockets; i++)
		{
			// to deal with network issues, pause after every other rocket
			while( !OkToSpawn() )
			{
				wait_network_frame();
			}					
			if(i <= 9)
			{
				tag = "tag_rocket0" + i;
				tag_pos = self getTagOrigin(tag);
				tag_angles = self getTagAngles(tag);
			}
			else
			{
				tag = "tag_rocket" + i;
				tag_pos = self getTagOrigin(tag);
				tag_angles = self getTagAngles(tag);
			}
			
			if( isDefined( tag_pos ) )
			{
				while(!oktospawn())
				{
					wait(0.1);
				}
				
				rocket = spawn("script_model", tag_pos);
				rocket.angles = ( tag_angles );
				rocket setmodel("katyusha_rocket");
				truck_rockets[truck_rockets.size] = rocket;				
			}			
		}
		
		target = targets[randomInt(targets.size)];
		
		close_targets = [];
		
		for(i = 0; i < targets.size; i++)
		{
			//dist = distancesquared(target.origin, targets[i].origin);
			
			//if(dist <= 512*512)
			//{
				close_targets[close_targets.size] = targets[i];
			//}
		}
		
		for(i = 0; i < truck_rockets.size; i++)
		{
			target_pos = targets[randomInt(close_targets.size)];
			truck_rockets[i] thread katyusha_rocket_fire( target_pos, self, tag_pos, catenary, z_moveto_offset );
		}
	}
}



// move the rocket and play the fx
//self = the rocket
katyusha_rocket_fire( target_pos, truck, tag_pos, catenary, z_moveto_offset )
{
	
	wait( randomfloatrange( 1, 3 ) );
	
	self thread fire_rocket( target_pos.origin, tag_pos, false, catenary, z_moveto_offset );
	
	self playsound("katyusha_launch_rocket");
	playFxOnTag(level._effect["rocket_launch"], self, "tag_fx");
	
	level thread rumble_all_players("damage_light", "damage_heavy", self.origin, 256, 128);
	earthquake(.25,.5,self.origin,512);

	wait( 0.1 );
	
	//self playloopsound("katy_rocket_run");
	playFxOnTag(level._effect["rocket_trail"], self, "tag_fx");
	
}



// fire the katyusha rockets
fire_rocket( target_pos, tag_org, far, catenary, z_moveto_offset )
{

	if( !isdefined( z_moveto_offset ) )
	{
		z_moveto_offset = 110;	
	}
	
	forwardVec = anglestoforward( self.angles );
	normal = VectorNormalize( forwardVec );
	vecScale = vectorScale( normal, 200 );
	
	moveto_pos = self.origin + vecScale;
	
	// move the rocket flatly along the rocket rack
	//moveto_pos = tag_org + ( 0, 200, z_moveto_offset );
	self moveTo( moveto_pos, 0.2 );	
	wait( 0.2 );
	
	// get the rocket's new position
	// this is where the trajectory math will begin
	start_pos = self.origin;
	
	///////// Math Section
	// Reverse the gravity so it's negative, you could change the gravity
	// by just putting a number in there, but if you keep the dvar, then the
	// user will see it change.
	gravity = getDvarInt("g_gravity") * -1;
	
	// Get the distance
	dist = distance( start_pos, target_pos );
	
	// Figure out the time depending on how fast we are going to
	// throw the object... 2200 changes the "strength" of the velocity.
	// To make it more lofty, lower the number.
	// To make it more of a bee-line throw, increase the number.
	// Katyushas need a flatter trajectory due to the rocket rack
	time = dist / catenary; // 2200 is default for ambient rockets
	time_to_wait = time / 3;
	
	// Get the delta between the 2 points.
	delta = target_pos - start_pos;
	
	// Here's the math I stole from the grenade code. :) First figure out
	// the drop we're going to need using gravity and time squared.
	drop = 0.5 * gravity * (time * time);
	
	// Now figure out the trajectory to throw the object at in order to
	// hit our map, taking drop and time into account.
	velocity = ((delta[0] / time), (delta[1] / time), (delta[2] - drop) / time);
	///////// End Math Section
	
	
	self MoveGravity( velocity, time );
	//Kevin changing where this is called to prevent audio clipping
	self playloopsound("katy_rocket_run",.1);
	
	// from pel1
	self rotatepitch( 100, time ); 
	
	self thread rotate_rocket_at_midpoint( time_to_wait );
	wait( time );
	//Kevin Stopping the looped sound
	self stoploopsound(1);

	if(far)
	{
		playFX(level._effect["rocket_explode_far"], self.origin);
	}
	else
	{
		playFX(level._effect["rocket_explode"], self.origin);
	}
	
	earthquake( 0.3, 2, self.origin, 512 );
	playSoundAtPosition( "shell_explode_default",self.origin );
	
	//Kevin putting a wait the same time as the loop fade
	//I had to do this or all the rockets clip on impact.
	//I put the wait before the delete so the particle isn't delayed.
	wait 1;

	self delete();
	
}

// make the Katyusha rocket's nose follow the flight path
rotate_rocket_at_midpoint( time )
{
	wait( time );
	self rotatePitch( 20, time / 1.5 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
//	TANK STUFF
////////////////////////////////////////////////////////////////////////////////////////////////////////

e1_tank_trap()
{
	thread move_tank_1();
}



// Moves the first tank outside of the library, which gets shot by an 88 and falls into the tank trap
move_tank_1()
{
	tank1 = getent("e1_tank1", "targetname");
	tank1 move_tank_on_trigger("e1_tank1_start_node", "trig_exiting_library");
	
	//wait(1.3);
	
	// Have a panzershreck shoot the tank
	aim_org = (tank1.origin + (0,0,40));
	
	wait(.9);
	
	shreck_start_pos = getstruct("shreck_start", "targetname");
	shreck_end_pos = getstruct("e1_house_shreck_pos", "targetname");
	
	thread fire_shrecks(shreck_start_pos, tank1, 1.5);
	
	//tank1 waittill ("damage");
	
	wait(1.5);
	
	tank1 notify ("death");
	tank1 setmodel("vehicle_rus_tracked_t34_dmg");
	
	//tank1 thread e1_tank_into_trap();
}



// used to shoot Panzershrecks at the players and tank in Event 1
fire_shrecks(spwn, targit, time)
{
	shreck = spawn("script_model", spwn.origin);
	shreck.angles = targit.angles;
	shreck setmodel("weapon_ger_panzershreck_rocket");
	
	dest = targit.origin;
	
	shreck moveTo(dest, time);
	playFxOnTag(level._effect["shreck_trail"], shreck, "tag_fx");
	//shreck playloopsound("rpg_rocket");
	wait time;
	
	shreck hide();
	
	playfx(level._effect["shreck_explode"], shreck.origin);
	
	targit notify ("shreck_hit");
	
	//shreck stoploopsound();
	//playSoundAtPosition("rpg_impact_boom", shreck.origin);
	radiusdamage(shreck.origin, 180, 300, 35);
	earthquake(0.7, 1.5, shreck.origin, 512);
	
	shreck delete();
}

e1_objectives()
{
	// First objective, gather in the house
	obj_struct = getstruct( "obj_gather_in_house", "targetname" );
	objective_add( 0, "current", &"BER3_OBJ0", obj_struct.origin );
	
	getent("e1_shreck_to_house", "targetname") waittill("trigger");
	wait(3);
	objective_state( 0, "done");
	
	// Objective 2:  Clear out the Buildings
	obj_struct = getstruct("obj_clear_library", "targetname");
	objective_add( 1, "current", &"BER3_OBJ1", obj_struct.origin );
	
	getent("trig_exiting_library", "targetname") waittill("trigger");
	objective_state(1, "done");
	
	// Objective 3:  Storm the Plaza
	obj_struct = getstruct( "obj_storm_konigsplatz", "targetname" );
	objective_add( 2, "current", &"BER3_OBJ2", obj_struct.origin );		
	
	getent("e2_tank1_destroy", "targetname") waittill("trigger");
	objective_state(2, "done");
		
}



// Modified from See1
e1_init_molotov_throwers()
{
	getent("trig_entering_alley", "targetname") waittill("trigger");

	spawners = getentarray( "e1_molotov_thrower", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::e1_molotov_thrower_think );

	for( i = 0; i < spawners.size; i++ )
	{
		russian = spawners[i] stalingradspawn();
		if( i % 2 )
		{
			wait_network_frame();
		}
	}
}

e1_molotov_thrower_think()
{
	self endon( "death" );

	self.goalradius = 32;
	self.health = 99999;
	self.grenadeammo = 0;

	//first_node_name = self.script_noteworthy + "_node1";
	second_node_name = self.script_noteworthy + "_node";

	//first_node = getnode( first_node_name, "script_noteworthy" );
	second_node = getnode( second_node_name, "script_noteworthy" );

	self setgoalnode( second_node );
	self thread hold_fire();
	self.ignoreme = true;

	self waittill( "goal" );

	self.animname = "russian";
	second_node thread anim_single_solo( self, "toss_molotov" );
	self thread fake_throw_molotov();
	self waittillmatch( "single anim", "end" );

	self.ignoreme = false;
	self resume_fire();
	
	next_node = getnode("alley_molotov_thrower_node_end", "script_noteworthy" );
	self setgoalnode( next_node );
}


fake_throw_molotov()
{
	self endon( "death" );

	molotov = spawn( "script_model", self gettagorigin( "tag_weapon_right" ) );
	molotov setmodel( "weapon_rus_molotov_grenade" );
	molotov linkto( self, "tag_weapon_left" );
	wait( 3.5 );
	playfxontag( level._effect["molotov_trail_fire"], molotov, "tag_flash" );

	wait( 2 );
	molotov unlink();
	molotov_target = getstruct( self.script_noteworthy, "targetname" );
	forward = VectorNormalize( ( molotov_target.origin + ( 0, 0, 600 ) ) - molotov.origin );
	velocities = forward * 15000;
	molotov physicslaunch( ( molotov.origin ), velocities );

	//velocities = ( forward + ( 300, 0, 0 ) ) * 10;
	//molotov movegravity( velocities, 4 );

	wait( 2 );
	playfx( level._effect["molotov_explosion"], molotov_target.origin );
//	level thread start_spreading_fire( molotov_target.origin, 0.2 );
	molotov delete();
}

e1_library_knock_bookshelf_over()
{
	getent("e1_trig_drop_shelf", "targetname") waittill("trigger");
	
	level.sarge anim_single_solo(level.sarge, "e1_rez_05");	// "Keep pushing forward!"
	
	shelf = getent("e1_library_shelf", "targetname");
	
// Fake the building getting hit by artillery
	earthquake( 0.3, 1.5, shelf.origin, 850);
	
	wait(.5);
	
	shelf rotatepitch(90, 1);
	wait(1);
	shelf PhysicsLaunch();
}

e2_alley_tanks()
{
	getent("trig_exiting_library", "targetname") waittill("trigger");
	
	// spawn some tanks past the alley
	tank_node = getvehiclenode("e2_alley_tank_node", "targetname");
	thread spawn_tank("vehicle_rus_tracked_t34", tank_node, true );
	wait(7);
	thread spawn_tank("vehicle_rus_tracked_t34", tank_node, true );
	wait(10);
	thread spawn_tank("vehicle_rus_tracked_t34", tank_node, true );	
}

//temp_side_smoke()
//{
//	effectStructs = getstructarray("e2_smoke_struct", "targetname");
//	
//	for(i = 0; i < effectStructs.size; i++)
//	{
//		playfx (level._effect["e2_plaza_side_smoke"], effectStructs[i].origin, anglestoforward(effectStructs[i].angles ));
//	}
//}




#using_animtree("ber3_alley_bricks");
e1_alley_bricks()
{
	anode = getnode("ber3_alley_bricks_chunks_anim", "targetname");
	
	amodel = spawn("script_model", anode.origin);
	amodel setmodel( level.scr_model["e1_wall_bricks"] );
	amodel.animname = "e1_wall_bricks";
	amodel useanimtree( level.scr_animtree["e1_wall_bricks"] );	
	
	bricks = [];
	bricks[0] = getent("ber3_alley_bricks_chunk_01", "targetname");
	bricks[1] = getent("ber3_alley_bricks_chunk_02", "targetname");
	bricks[2] = getent("ber3_alley_bricks_chunk_03", "targetname");
	
	for(i = 0; i < bricks.size; i++)
	{
		bricks[i] linkto(amodel, "chunk" + (i+1));
	}
	
	anode anim_single_solo(amodel, "e1_alley_brick_chunks");
}

#using_animtree("ber3_reich_flag");
reich_flag_waving()
{
	anode = getnode("ber3_stag_flag_anim", "targetname");
	
	amodel = spawn("script_model", anode.origin);
	amodel setmodel( level.scr_model["reich_flag"] );
	amodel.animname = "reich_flag";
	amodel useanimtree( level.scr_animtree["reich_flag"] );	
	
	anode anim_single_solo(amodel, "flag_wave");	
}



#using_animtree("ber3_russian_flag");
intro_rus_flag()
{
	anode = getent("e1_anim_intro_struct", "targetname");
	
	amodel = spawn("script_model", anode.origin);
	amodel setmodel( level.scr_model["rus_flag"] );
	amodel.animname = "rus_flag";
	amodel useanimtree( level.scr_animtree["rus_flag"] );	
	
	amodel linkto(self, "tag_inhand", (0,0,0), (0,0,0));
	
	level waittill("intro ended");
	
	amodel unlink();
	amodel delete();
}



#using_animtree("ber3_pak43");
e1_pak_move()
{
	level endon ("delete street allies");
	pak_struct = getstruct("intro_road_pak_struct", "targetname");
	
	pak43 = getent("e1_art1", "targetname");
	
	pak43.animname = "e1_pak43";
	pak43 useanimtree( level.scr_animtree["e1_pak43"] );
	
	level waittill("start pak anims");
	pak_struct anim_single_solo( pak43, "e1_push_pak" );
	pak_struct anim_single_solo( pak43, "e1_settle_pak" );
	e1_pak_shoot(pak43, pak_struct);
}

e1_pak_shoot(pak43, anode)
{
	level endon("delete street allies");	
	
	pak43.animname = "e1_pak43";
	pak43 useanimtree( level.scr_animtree["e1_pak43"] );
	
	anode anim_loop_solo( pak43, "e1_fire_pak", undefined, "delete street allies" );
}

#using_animtree("generic_human");
e1_pak_crew_move()
{
	level endon ("delete street allies");
	pak_struct = getstruct("intro_road_pak_struct", "targetname");
	
	pak_crew = getentarray("e1_art1_crew", "targetname");
	
	ASSERTEX( pak_crew.size == 4, "Need exactly 4 actors with targetname e1_art1_crew" );
	
	pak_crew[0].animname = "lbrace_pusher";
	pak_crew[1].animname = "lwheel_pusher";
	pak_crew[2].animname = "rbrace_pusher";
	pak_crew[3].animname = "rwheel_pusher";
	
	level waittill("start pak anims");
	pak_struct anim_single( pak_crew, "e1_push_pak" );
	pak_struct anim_single( pak_crew, "e1_settle_pak" );
	e1_pak_crew_shoot(pak_crew, pak_struct);
}

e1_pak_crew_shoot(pak_crew, anode)
{
	level endon("stop pak anims");
	
	pak_crew[0].animname = "lbrace_pusher";
	pak_crew[1].animname = "lwheel_pusher";
	pak_crew[2].animname = "rbrace_pusher";
	pak_crew[3].animname = "rwheel_pusher";	
	
	pak_crew[3] Attach( "static_peleliu_flak88_shell", "tag_inhand" );
	
	anode anim_loop( pak_crew, "e1_fire_pak", undefined, "delete street allies" );
}

e1_pak_fire( guy )
{
	playfxontag( level._effect["pak43_muzzleflash"], guy, "tag_barrel" );	
	guy playsound("pak43_fire_scripted");
	earthquake(.3, 1, guy.origin,1024);
	level thread rumble_all_players("damage_light", "damage_heavy", guy.origin, 523, 256);
	
}

#using_animtree("ber3_tank");
e1_tank_into_trap()
{
	org = self.origin;
	
	self doDamage ( self.health + 10, self.origin );
	
	self delete();
	
	tankModel = spawn("script_model", org);
	tankModel setmodel("vehicle_rus_tracked_t34");
	
	anode = getnode("ber3_tank_trap", "targetname");
	
	tankModel.animname = "ber3_dtank";
	tankModel useanimtree( level.scr_animtree["ber3_dtank"] );	
	
	anode anim_single_solo(tankModel, "fall_into_trap");	
	
	tankModel setModel("vehicle_rus_tracked_t34_dmg");
}