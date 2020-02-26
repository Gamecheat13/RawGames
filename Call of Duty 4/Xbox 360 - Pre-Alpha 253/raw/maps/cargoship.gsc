#include maps\_utility;
#include maps\_anim;
#include maps\mo_tools;
#include maps\cargoship_code;

main()
{
	// level.fogvalue["min"] = 4000;
	// level.fogvalue["max"] = 20000;
	level.fogvalue["near"] = 100;
	level.fogvalue["half"] = 9900;	
	level.fogvalue["r"] = 20/256;
	level.fogvalue["g"] = 30/256; 
	level.fogvalue["b"] = 38/256;
	setExpFog (level.fogvalue["near"], level.fogvalue["half"], level.fogvalue["r"], level.fogvalue["g"], level.fogvalue["b"], 0.1);
	
	// level.fogvalue["min"] = 200;
	// level.fogvalue["max"] = 1000;
	level.fogvalue["near"] = 100;
	level.fogvalue["half"] = 2700;	
	
	setExpFog (level.fogvalue["near"], level.fogvalue["half"], level.fogvalue["r"], level.fogvalue["g"], level.fogvalue["b"], 40);
	
	add_start( "bridge", maps\cargoship::misc_dummy );	
	//add_start( "quarters", maps\cargoship::misc_dummy );
	add_start( "deck", maps\cargoship::misc_dummy );
	add_start( "hallways", maps\cargoship::misc_dummy );
	add_start( "cargohold", maps\cargoship::misc_dummy );
	add_start( "escape", maps\cargoship::misc_dummy );
	
	flag_init("topside_fx");
	flag_set("topside_fx");
	flag_init("cargohold_fx");
	flag_init("heroes_ready");
	flag_init("at_bridge");
	flag_init("bridge_landing");
	flag_init("bridgefight");
	flag_init("quarters");
	flag_init("quarters_drunk_spawned");
	flag_init("quarters_drunk_ready");
	flag_init("price_at_top_of_stairs");
	flag_init("quarters_price_says_clear");
	flag_init("quarters_sleepers_dead");
	flag_init("deck_heli");
	flag_init("walk_deck");
	flag_init("deck_windows");
	flag_init("escape");
	flag_init("escape_cargohold2_fx");
	flag_init("start_sinking_boat");
	flag_init("escape_explosion");
	
	//maps\createart\cargoship_art::main();
	level.start_point = "default";
	
	maps\cargoship_fx::main();
	maps\_blackhawk::main("vehicle_blackhawk");
	maps\scriptgen\cargoship_scriptgen::main();
	maps\cargoship_anim::main();
	maps\mo_globals::main("cargoship");
	maps\_sea::main();
	maps\mo_fastrope::main();
	level thread maps\cargoship_amb::main();
	
	level.xenon = false;
    
    if (isdefined( getdvar("xenonGame") ) && getdvar("xenonGame") == "true" )
		level.xenon = true;
		
	setsaveddvar("sm_sunSampleSizeNear", ".75");
	setSavedDvar("r_specularColorScale", "5");
	
	jumptoInit();
	misc_precacheInit();
	misc_setup();		
	thread initial_setup();
	thread objective_main();
	thread jumptoThink();
	
	switch(level.jumptosection)
	{
		case "bridge":	bridge_main();
		case "deck":	deck_main();
		case "escape":	escape_main();
	}
}

#using_animtree("generic_human");
initial_setup()
{
	temp = getentarray("intro_spawners", "target");
	name = temp[0].targetname;
	level.heli = level.fastrope_globals.helicopters[maps\mo_fastrope::fastrope_heliname(name)];	
	
	level.heli initial_setup_vehicle_override();
	level.heli maps\mo_fastrope::fastrope_ropeanimload(%bh_rope_idle_ri, %bh_rope_drop_ri, "right");
	level.heli maps\mo_fastrope::fastrope_ropeanimload(%bh_rope_idle_le, %bh_rope_drop_le, "left");
//	level.heli maps\mo_fastrope::fastrope_override(1, undefined, %cs_bh_1_idle_start, %cs_bh_1_drop);
//	level.heli maps\mo_fastrope::fastrope_override(2, undefined, %cs_bh_2_idle_start, %cs_bh_2_drop);
	level.heli maps\mo_fastrope::fastrope_override(1, %cargoship_opening_position1);
	level.heli maps\mo_fastrope::fastrope_override(2, %cargoship_opening_price);
	level.heli maps\mo_fastrope::fastrope_override(4, undefined, %bh_idle_start_guy2, %bh_4_drop);
	level.heli maps\mo_fastrope::fastrope_override(5, undefined, undefined, %bh_5_drop);
	level.heli maps\mo_fastrope::fastrope_override(6, undefined, %bh_idle_start_guy1, %bh_6_drop);
	
	trig =  getent("intro_spawners","targetname");
	trig notify ("trigger");
	wait .1;
	level notify("level heli ready");
	
	ai = getaiarray("allies");
	
	level.heroes = [];
	for(i=0; i<ai.size; i++)
	{
		switch( ai[i].seat_pos )
		{
			case 1:{	level.heroes["alavi"] 	= ai[i];  }break;
			case 2:{  	level.heroes["price"] 	= ai[i];  }break;
			case 4:{ 	level.heroes["grigsby"]	= ai[i];  }break;
			case 9:{  	level.heroes["pilot"] 	= ai[i];  }break;
			case 10:{  	level.heroes["copilot"]	= ai[i];  }break;
			case 5:{	level.heroes["seat5"]	= ai[i];  }break;
			case 6:{	level.heroes["seat6"]	= ai[i];  }break;
		}
	}
	
	createthreatbiasgroup( "hero_price" );
	level.heroes["price"] setthreatbiasgroup( "hero_price" );
	createthreatbiasgroup( "hero_alavi" );
	level.heroes["alavi"] setthreatbiasgroup( "hero_alavi" );
	
	level.heroes["price"].accuracy = 1000;
	level.heroes["price"].baseAccuracy = 1000;
	level.heroes["price"].fixednode = false;
	level.heroes["price"].script_noteworthy = "price";
	
	level.heroes["alavi"].accuracy = 1000;
	level.heroes["alavi"].baseAccuracy = 1000;
	level.heroes["alavi"].fixednode = false;
	level.heroes["alavi"].script_noteworthy = "alavi";
	
	level.heroes["grigsby"].accuracy = 1000;
	level.heroes["grigsby"].baseAccuracy = 1000;
	level.heroes["grigsby"].fixednode = false;
	level.heroes["grigsby"].script_noteworthy = "grigsby";
	
	level.heroes["seat5"].accuracy = 1000;
	level.heroes["seat5"].baseAccuracy = 1000;
	level.heroes["seat5"].fixednode = false;
	level.heroes["seat5"].script_noteworthy = "seat5";
	
	level.heroes["seat6"].accuracy = 1000;
	level.heroes["seat6"].baseAccuracy = 1000;
	level.heroes["seat6"].fixednode = false;
	level.heroes["seat6"].script_noteworthy = "seat6";
	
	flag_set("heroes_ready");
	
	water = getentarray("sink_waterlevel","targetname");
	for(i=0; i<water.size; i++)
		water[i] hide();
	
	bigcontainerend = getent("escape_first_fallen_container","targetname");
	bigcontainerend hide();
	
	blockerend = getentarray("escape_big_blocker","targetname");
	for(i=0; i< blockerend.size; i++)
	{
		blockerend[i] hide();
		blockerend[i] notsolid();
		if(blockerend[i].spawnflags & 1)
			blockerend[i] connectpaths();
	}
}

#using_animtree("vehicles");
initial_setup_vehicle_override()
{
	node = getstruct("intro_ride_node","targetname");
	self maps\mo_fastrope::fastrope_override_vehicle(%bh_cargo_path, node);
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  	BRIDGE LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

bridge_main()
{
	switch(level.jumpto)
	{
		case "start":{
			musicPlay("cargoship_intro_music"); 
			level thread maps\_introscreen::introscreen_delay(level.strings["intro1"], level.strings["intro2"], level.strings["intro3"], level.strings["intro4"], 2, 2, 1);
				
			thread bridge_intro();
			thread bridge_intro_thunder();
			thread bridge_heroes();
			thread bridge_heli_1();
			}
		case "bridge":{
			thread bridge_setup();								
			thread bridge_heli_2();
			thread bridge_standoff();
			}
		case "quarters":{
			flag_wait("quarters");
			thread quarters_sleeping();
			thread quarters_dialogue();
			quarters();
			}
	}
}

bridge_intro_thunder()
{
	thread maps\cargoship_fx::normal();
	wait 5;
	thread maps\_weather::lightningFlash( maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	wait 10;
	thread maps\_weather::lightningFlash( maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	wait 4;
	maps\_weather::lightningFlash( maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	wait 1;
	maps\_weather::lightningFlash( maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	wait .5;
	maps\_weather::lightningFlash( maps\cargoship_fx::normal, maps\cargoship_fx::flash );
}

bridge_intro()
{	
	level._sea_scale = 2;
	setsaveddvar("sm_sunSampleSizeNear", ".25");	
	wait 10;
	setsaveddvar("sm_sunSampleSizeNear", "1.25");
	wait 12;
	flag_set("_sea_waves");
	level._sea_scale = 1;
	wait 4;
	flag_clear("_sea_bob");
	wait 12;
	flag_set("_sea_viewbob");
	flag_set("_sea_bob");
	//wait 4;
	setsaveddvar("sm_sunSampleSizeNear", ".75");
}

bridge_setup()
{
	trig = [];
	trig[trig.size] = getent("stair_bottom_save","script_noteworthy");
	trig = array_combine(trig, getentarray("bridge_flags","script_noteworthy") );
	array_thread(trig, ::trigger_off);	
	
	level waittill("level heli ready");
	
	thread battleChatter_Off();
	
	ai = getaiarray("allies");
	for(i=0; i<ai.size; i++)
	{
		if( isdefined( ai[i].spawner.nounload ) && ai[i].spawner.nounload == true )
			continue;
		node = getnode( ( "seat" + ai[i].seat_pos ), "targetname" );
		ai[i] setgoalnode( node );
		ai[i].goalradius = 32;
		ai[i].ignoresuppression = true;
	}
				
	level.heli.vehicle waittill("reached_wait_node");
	flag_set("at_bridge");
	thread maps\cargoship_fx::flash(2, 4, 2, 3, ( -25, -160, 0 ) );
	level.player thread play_sound_on_entity ("elm_thunder_distant");
	level.player thread play_sound_on_entity ("elm_thunder_strike");
	autosave_by_name("fastrope");
	
	wait 4.5;
	thread maps\cargoship_fx::flash(3, 4, 2, 3, ( -25, -110, 0 ) );
	level.player thread play_sound_on_entity ("elm_thunder_distant");
	level.player thread play_sound_on_entity ("elm_thunder_strike");
}

bridge_heli_1()
{
	level waittill("level heli ready");
		
	fxmodel = spawn("script_model", level.heli.model gettagorigin( "main_rotor_jnt" ) );
	fxmodel setmodel(level.heli.modelname);
	fxmodel.angles = level.heli.model.angles;
	fxmodel linkto(level.heli.model);
	fxmodel hide();
	fxmodel setcontents(0);
	fxmodel thread maps\mo_fastrope::fastrope_heli_playExteriorLightFX();
	//fxmodel maps\mo_fastrope::fastrope_heli_playInteriorLightFX();
	
	fxfill1 = spawn("script_model", level.heli.model gettagorigin( "tag_light_cargo01" ) + (0,0,0) );
	fxfill1 setmodel("tag_origin");
	fxfill1.angles = level.heli.model gettagangles( "tag_light_cargo01" );
	fxfill2 = spawn("script_model", level.heli.model gettagorigin( "tag_light_cargo01" ) + (0,0,0) );
	fxfill2 setmodel("tag_origin");
	fxfill2.angles = level.heli.model gettagangles( "tag_light_cargo01" );
	fxfill1 linkto(level.heli.model, "tag_light_cargo01",(24,-32,0), (0,0,0));	
	fxfill2 linkto(level.heli.model, "tag_light_cargo01",(24,-32,48), (0,0,0));
	fxfill1 hide();
	fxfill2 hide();
	
	level waittill("going_dark");
	wait 1;
	
	//playfxontag( level._effect[ "aircraft_light_cockpit_fill_fade" ], fxfill1, "tag_origin" );
	//playfxontag( level._effect[ "aircraft_light_cockpit_fill_fade" ], fxfill2, "tag_origin" );
	
	wait .5;
	fxmodel delete();
	wait 1.5;
	//playfxontag( level._effect[ "aircraft_light_cockpit_fill" ], fxfill1, "tag_origin" );
	//playfxontag( level._effect[ "aircraft_light_cockpit_fill" ], fxfill2, "tag_origin" );
	
	level.heli.vehicle waittill("reached_wait_node");
	fxfill1 delete();
	wait 5;
	fxfill2 delete();
}

bridge_heli_2()
{	
	level waittill("level heli ready");
	//iprintlnbold("wtf");
	wait 29;
	level.heli.vehicle notify("fake_wait_node");
	//level.heli.vehicle waittill("reached_wait_node");
	
	level.heli.model thread maps\mo_fastrope::fastrope_heli_playExteriorLightFX();
	level.heli.model maps\mo_fastrope::fastrope_heli_playInteriorLightFX();
	level.heli maps\mo_fastrope::fastrope_heli_overtake();
		
	thread bridge_heli_3();
	
	wait 1;
		
	level.heli.model heli_searchlight_on();
	
	target = spawn("script_origin", (3184, 152, 364) );
	target.targetname = "bridge_fake_spottarget";
	level.heli.model thread heli_searchlight_target("targetname", "bridge_fake_spottarget");	
		
	wait 4;
	target moveto( (2896, -232, 364), 4, 1, 1);
}

bridge_heli_3()
{
	level endon("price_wait_at_stairs");
			
	level.heli.vehicle sethoverparams( 32, 10, 3 );
	level.heli.vehicle clearlookatent();
	
	node = getstruct("heli_bridge_node","targetname");
	level.heli.vehicle setspeed( 15, 10, 10 );
	level.heli.vehicle setLookAtEnt( level.heroes["price"] );
	
	while( isdefined(node) )
	{
		stop = true;
		if( isdefined(node.target) )
			stop = false;
					
		level.heli.vehicle setvehgoalpos( node.origin + (0,0,150), stop );
		level.heli.vehicle setNearGoalNotifyDist( 150 );
		level.heli.vehicle waittill( "near_goal" );	
	
		if( isdefined(node.target) )
			node = getstruct( node.target, "targetname" );
		else
			node = undefined;
	}
}

bridge_heroes()
{			
	flag_wait("heroes_ready");
	
	cigar = spawn("script_model", level.heroes["price"] gettagorigin("tag_inhand") );
	cigar.angles = level.heroes["price"] gettagangles("tag_inhand");
	cigar linkto(level.heroes["price"], "tag_inhand");
	cigar setmodel("prop_price_cigar");
	playfxontag (level._effect["cigar_glow"], cigar, "tag_cigarglow");
	level.heroes["price"] thread priceCigarPuffFX(cigar);
	level.heroes["price"] thread priceCigarExhaleFX(cigar);
	cigar thread priceCigarDelete();
	
	wait 1;
	//base plate this is hammer two four, we have visual on the target, eta 60 seconds
	radio_dialogue("cargoship_hp1_baseplatehammertwo");
	//copy two four
	radio_dialogue("cargoship_hqr_copytwofour");
		
	wait 5;	
	level notify("going_dark");
	//30 seconds, going dark
	radio_dialogue("cargoship_hp1_thirtysecdark");
	
	wait 8;
	//ten secounds
	radio_dialogue("cargoship_hp1_tensecondsradio");
	
	wait 1;
	//radio check, going to secure channel
	thread radio_dialogue("cargoship_hp1_radiocheck");
	
	wait 1;
	thread PlayerMaskPuton();
			
	wait 2.75;
	//lock and load
	radio_dialogue("cargoship_pri_crewexpend");
		
	level.heli.vehicle waittill("reached_wait_node");
	
	//green light, go go go
	radio_dialogue("cargoship_hp1_greenlightgoradio");
}

bridge_standoff()
{
	trig1 = getent("bridge_standoff_guys","target");
	start = getent("start_bridge_standoff", "targetname");
	damage = getent("bridge_damage_trig","targetname");
	damage thread bridge_standoff_damage();

	array_thread( getentarray( "bridge_standoff_guys","targetname" ), ::add_spawn_function, ::bridge_standoff_behavior);
	level.enemies = [];
	trig1 notify("trigger");
	
	start waittill("trigger");
	flag_set("bridge_landing");
	wait .1;
	//bridge secure
	thread ai_clear_dialog(undefined, undefined, undefined, level.heroes["alavi"], "cargoship_gm1_bridgesecure");
	
	damage wait_for_trigger_or_timeout(.75);
	
	level.enemies[ "bridge_capt" ] notify("bridge_react");
	wait .4;
	level.enemies[ "bridge_tv" ] notify("bridge_react");
	level.enemies[ "bridge_stand1" ] notify("bridge_react");
	wait .5;
	level.enemies[ "bridge_clipboard" ] notify("bridge_react");
	
	//weapons free
	radio_dialogue("cargoship_pri_weaponsfree");
	
	//flag_set("bridgefight");
	level waittill("ai_clear_dialog_done");
	flag_set("quarters");
}

bridge_standoff_damage()
{
	while(1)
	{
		self waittill( "trigger", other);
		if( other == level.player )
			break;
	}
	flag_set("bridgefight");
}

bridge_standoff_behavior()
{
	node = getnode(self.target, "targetname");
		
	self.animname = self.script_noteworthy;
	self.deathanim = level.scr_anim[self.animname]["death"];
	level.enemies[ self.script_noteworthy ] = self;
	self.grenadeAmmo = 0;
	
	if(self.animname == "bridge_stand1")
		node = getent(self.target, "targetname");
			
	node thread anim_loop_solo(self, "idle", undefined, "stoploop");
	self thread ignoreAllEnemies( true );
	self gun_remove();
	
	self thread bridge_standoff_behavior_earlydeath(node);
	
	self endon ("death_by_player");
	self waittill("bridge_react");
			
	node notify("stoploop");
	
	length = getanimlength( level.scr_anim[self.animname]["react"] );
	delay = length - .5;
	node thread anim_single_solo(self, "react");
		
	wait delay;	
	
	switch( self.animname )
	{
		case "bridge_capt":
			level.heroes[ "alavi" ] thread execute_ai_solo( self, .5, 6 );
			wait .5;
			self.ignoreme = false;
			break;	
		case "bridge_tv":
			level.heroes[ "price" ] thread execute_ai_solo( self, .5, 6 );
			wait .5;
			self.ignoreme = false;
			break;	
		case "bridge_stand1":
			wait .25;
			level.heroes[ "alavi" ] thread execute_ai_solo( self, .25, 6 );
			self.ignoreme = false;
			wait .25;
			break;	
		case "bridge_clipboard":
			wait .25;
			level.heroes[ "price" ] thread execute_ai_solo( self, .25, 6 );
			self.ignoreme = false;
			wait .25;
			break;	
	}
	
	self notify("already_dying");
	self stopanimscripted();
	self dodamage(self.health + 300, self.origin);
	thread play_sound_in_space("generic_death_russian_" + randomintrange(1,8), node.origin );
}

bridge_standoff_behavior_earlydeath(node)
{
	self endon("already_dying");
	while(1)
	{
		self waittill( "damage", damage, other);
		if( other == level.player )
			break;
	}
	
	self notify ("death_by_player");

	self stopanimscripted();
	self dodamage(self.health + 300, self.origin);
	thread play_sound_in_space("generic_death_russian_" + randomintrange(1,8), node.origin );
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  	QUARTERS LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

quarters_sleeping()
{
	org = getentarray("sleeping_nodes","targetname");
	spawners = getentarray("quarters_sleepers", "targetname");
	guys = []; 
	for(i=0; i<org.size; i++)
	{
		guys[i] = spawners[i] stalingradspawn();
		spawn_failed(guys[i]);
		guys[i].animname = ( "sleeper_" + i );
		guys[i].ignoreme = true;
		guys[i].deathanim = level.scr_anim[guys[i].animname]["death"];
		guys[i].grenadeAmmo = 0;
		
		//guys[i].deathanim = level.scr_anim[ guys[i].animname ]["death"];
		org[i] thread anim_loop_solo(guys[i], "sleep", undefined, "stop_sleeping");
		guys[i] thread quarters_sleeping_death(org[i]);
		//guys[i] thread quarters_sleeping_awake(org[i]);
		guys[i] thread quarters_sleeping_player();
	}
	
	waittill_dead(guys);  
	flag_set("quarters_sleepers_dead");
	flag_set("deck");
}

quarters_sleeping_player()
{
	level endon("deck");
	while(1)
	{
		if(self cansee(level.player) )
			break;
		wait .1;	
	}	
	wait 1;
	flag_set("deck");
}

quarters_sleeping_death(node)
{
	self gun_remove();
	self thread ignoreAllEnemies( true );
	
	self waittill("damage", damage, other);
	
	level notify("sleeping_guys_wake");
	
	self stopanimscripted();
	self dodamage(self.health + 300, other.origin, other);
	self startragdoll();
	thread play_sound_in_space("generic_death_russian_" + randomintrange(1,8), self.origin );
	//wait .1;
	//self notify("death");
}

quarters_sleeping_awake(node)
{
	self endon("death");
	level waittill("sleeping_guys_wake");
	
	node notify("stop_sleeping");
}

quarters_dialogue()
{
	wait 1;
	//griggs, stay in the bird till we secure the deck, over
	radio_dialogue("cargoship_pri_holdyourfire");
	//roger that
	radio_dialogue("cargoship_grg_rogerthatradio");
}

quarters_heli()
{	
	level endon("deck");
	level endon("deck_heli");
	
	flag_wait("price_wait_at_stairs");
	
	node = getstruct( "heli_deck_landing_node", "targetname" );	
	ang = node.angles[1];	
	
	level.heli.vehicle setspeed( 20, 10, 10 );
	level.heli.vehicle sethoverparams( 32, 10, 3 );
	level.heli.vehicle clearlookatent();
	level.heli.vehicle cleargoalyaw();	
	node = getstruct( "heli_quarters_node", "targetname" );
	
	level.heli.vehicle setvehgoalpos( node.origin, 1 );
	
	level.heli.vehicle setgoalyaw(ang);
	level.heli.vehicle settargetyaw(ang);
	
	while( isdefined(node) )
	{
		stop = false;
		if(!isdefined(node.target))
			stop = true;
		level.heli.vehicle setvehgoalpos( node.origin + (0,0,150), stop );
		level.heli.vehicle setNearGoalNotifyDist( 150 );
		level.heli.vehicle waittill( "near_goal" );
		
		if( isdefined(node.target) )
			node = getstruct( node.target, "targetname" );
		else
			node = undefined;			
	}
	flag_set( "deck_heli" );
}

quarters_redlightatstairs()
{
	org = spawn("script_model", (2811, -346, 299));
	org setmodel("tag_origin");
	org hide();
	playfxontag( level._effect[ "aircraft_light_cockpit_red" ], org, "tag_origin" );

	flag_wait("deck");
	
	org delete();
}

quarters()
{
	thread quarters_redlightatstairs();
	
	thread quarters_heli();
	
	trig = [];
	trig = array_combine(trig, getentarray("bridge_flags","script_noteworthy") );
	array_thread(trig, ::trigger_on);
	
	level.heroes[ "price" ] pushplayer(true);
	level.heroes[ "price" ].animname = "price";
	level.heroes[ "price" ].animplaybackrate = 1.04;
	
	level.heroes[ "alavi" ] pushplayer(true);
	level.heroes[ "alavi" ].animname = "alavi";
	level.heroes[ "alavi" ].animplaybackrate = 1.04;
		
	rnode = getnode("bridge_door_open","targetname");
	node1 = spawn( "script_origin", rnode.origin + ( -20, -13, 0 ));
	node1.angles = rnode.angles;
	
	node2 = spawn( "script_origin", node1.origin);
	node2.angles = node1.angles + (0,-15,0);
	guys = [];
	guys[ guys.size ] = level.heroes[ "price" ];
	guys[ guys.size ] = level.heroes[ "alavi" ];
	node2 thread anim_reach_and_idle_solo( level.heroes[ "alavi" ], "door_breach_setup", "door_breach_setup_idle", "stop_loop" );
	node1 anim_reach_and_idle_solo( level.heroes[ "price" ], "door_breach_setup", "door_breach_setup_idle", "stop_loop" );
	node2 notify( "stop_loop" );
	node1 notify( "stop_loop" );
	node1 thread anim_single_solo( level.heroes[ "price" ], "door_breach" );	
	node2 thread anim_single_solo( level.heroes[ "alavi" ], "door_breach" );	
		
	level.heroes[ "price" ] waittillmatch( "single anim", "kick" );
	door = getent( "bridge_door", "targetname" );
	clip = getent(door.target, "targetname");
	clip notsolid();
	clip connectpaths();
	door door_opens();	
		
	level.heroes[ "price" ] enable_cqbwalk();
	level.heroes[ "alavi" ] enable_cqbwalk();
	
	wait 1;
	level.heroes[ "alavi" ] stopanimscripted();
	level.heroes[ "alavi" ] thread quarters_alavi();
	
	wait .25;
	level.heroes[ "price" ] stopanimscripted();
	level.heroes[ "price" ] thread quarters_price();
	
	node1 delete();
	node2 delete();
	
	flag_wait( "quarters_killem" );
	flag_clear("_sea_bob");
	getent("quarters_drunk","targetname") quarters_drunk();
}

quarters_drunk()
{
	guy = self stalingradspawn();
	level.quartersdrunk = guy;
	spawn_failed( guy );
	guy.ignoreme = true;
	guy.grenadeAmmo = 0;
	level.player.ignoreme = true;
	guy thread ignoreAllEnemies( true );
	guy gun_remove();
	
	flag_set("quarters_drunk_spawned");
	guy.animname = "drunk";
	guy.deathanim = level.scr_anim[guy.animname]["death"];
	
	node = getnode(self.target, "targetname");	
	
	guy thread quarters_drunk_earlydeath(node);
	guy endon ("death_by_player");
	
	node thread anim_single_solo(guy, "walk");	
	length = getanimlength( level.scr_anim[guy.animname]["walk"] );
	
	wait 3.5;
	guy.ignoreme = false;
	flag_set("quarters_drunk_ready");
					
	guy notify("already_dying");
	guy stopanimscripted();
	guy dodamage(guy.health + 300, guy.origin);
	thread play_sound_in_space("generic_death_russian_" + randomintrange(1,8), node.origin );
}

quarters_drunk_earlydeath(node)
{
	self endon("already_dying");
	while(1)
	{
		self waittill( "damage", damage, other);
		if( other == level.player )
			break;
	}
	
	self notify ("death_by_player");
	flag_set("quarters_drunk_ready");
	
	self stopanimscripted();
	self dodamage(self.health + 300, self.origin);
	thread play_sound_in_space("generic_death_russian_" + randomintrange(1,8), node.origin );
}

quarters_price()
{
	//squad on me
	thread radio_dialogue("cargoship_pri_squadonme");
	level notify("bridge_secured");
	
	node0 = getnode("quarters_price_0", "targetname");
	node1 = getnode("quarters_price_1", "targetname");
	node2 = getnode("quarters_price_2", "targetname");	
	
	self.ignoreme = true;
	self.ignoresuppression = true;
	
	if( !flag( "price_wait_at_stairs" ) )
	{
		self setgoalnode(node0);
		self.goalradius = node0.radius;
		flag_wait( "price_wait_at_stairs" );
		//stairs clear
		thread radio_dialogue("cargoship_pri_stairsclear");
		wait .4;
	}
	
	level endon("deck");
	
	self setgoalnode(node1);
	self.goalradius = node1.radius;
	
	flag_wait("quarters_drunk_spawned");
	self cqb_aim(level.quartersdrunk);
	flag_wait("quarters_drunk_ready");
	
	while( isalive( level.quartersdrunk ) )
	{
		shots = randomintrange(3,6);
		self burstshot(shots);
		wait .2;
	}
	
	self cqb_aim( undefined );
	
	//hallway clear
	thread radio_dialogue("cargoship_pri_hallwayclear");
	wait .3;
	
	self setgoalnode(node2);
	self.goalradius = node2.radius;
	
	flag_set("quarters_price_says_clear");
}

quarters_alavi_stairs()
{
	while(1)
	{
		self waittill("trigger", other);
		if(other == level.heroes[ "price" ])
			break;
	}	
	
	flag_set("price_at_top_of_stairs");
}

quarters_alavi()
{	
	node0 = getnode("quarters_price_0", "targetname");
	node1 = getnode("quarters_alavi_1", "targetname");
	node2 = getnode("quarters_alavi_2", "targetname");
	
	self.ignoreme = true;
	self.ignoresuppression = true;
	
	getent("price_at_top_of_stairs","targetname") thread quarters_alavi_stairs();
	
	if( !flag( "price_at_top_of_stairs" ) )
	{
		self setgoalnode(node0);
		self.goalradius = node0.radius;
		flag_wait( "price_at_top_of_stairs" );
	}
		
	level endon("deck");
	
	self setgoalnode(node1);
	self.goalradius = node1.radius;
	
	flag_wait("quarters_drunk_spawned");
	self cqb_aim(level.quartersdrunk);
	flag_wait("quarters_drunk_ready");
	
	wait .25;
	
	while( isalive( level.quartersdrunk ) )
	{
		shots = randomintrange(3,6);
		self burstshot(shots);
		wait .2;
	}
	
	flag_wait("quarters_price_says_clear");
	
	wait .25;
	
	self setgoalnode(node2);
	self.goalradius = node2.radius;
	
	self waittill( "goal" );
	ai = getaiarray("axis");
	self cqb_aim( ai[0] );
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 				  	DECK LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

deck_main()
{
	jumpto = level.jumpto;
	if(level.jumptosection != "deck")
		jumpto = "deck";	
	
	switch(jumpto)
	{
		case "deck":{
			thread deck_heli();
			flag_wait("deck");
			flag_set("deck_heli");
			thread deck_start();
			thread deck_enemies_main();
			}	
	}
}

deck_start()
{
	level.heroes["alavi"] disable_ai_color();
	level.heroes["price"] pushplayer(false);
	level.heroes["alavi"] pushplayer(false);
	level.heroes["price"].ignoresuppression = false;
	level.heroes["alavi"].ignoresuppression = false;
	level.heroes["price"].ignoreme = false;
	level.heroes["alavi"].ignoreme = false;
	level.heroes["price"] disable_cqbwalk();
	level.heroes["alavi"] disable_cqbwalk();
	
	wait .25;
	//Crew quarters clear. Move up.
	thread radio_dialogue("cargoship_pri_crewquarters");
	
	if( !flag("quarters_sleepers_dead"))
		level.heroes["alavi"] execute_ai( getaiarray("axis") );
	
	level.heroes["alavi"] cqb_aim( undefined );
	
	temp = getallnodes();
	list = [];
	for(i=0; i<temp.size; i++)
	{
		if( issubstr( tolower( temp[i].type ), "cover" ) )
			list[ list.size ] = temp[i];
	}	
	
	temp = getnodearray("decknodes", "targetname");
	nodes = [];
	for(i=0; i<temp.size; i++)
		nodes[ temp[i].script_noteworthy ] = temp[i];
	
	keys = getarraykeys(level.heroes);
	for(i=0; i<keys.size; i++)
	{
		key = keys[i];
		if( issubstr(key, "pilot") )
			continue;
		level.heroes[ key ] thread deck_heroes( nodes[ key ], list );	
	}
	deck_heroes_holdtheline();
		
	flag_wait("walk_deck");
	
	//talk and shit
}

deck_heroes_holdtheline()
{
	flag_wait("walk_deck");
	maxrate = 1.13;
	avgrate = 1;
	minrate = .9;
	maxdist = 140;
	
	pack = [];
	keys = getarraykeys(level.heroes);
	for(i=0; i<keys.size; i++)
	{
		key = keys[i];
		if( issubstr(key, "pilot") )
			continue;
		pack[ pack.size ] = level.heroes[ key ];
	}
	
	for(i=0; i<pack.size; i++)
	{
		pack[i].oldanimplaybackrate = pack[i].animplaybackrate;
		pack[i].animplaybackrate = avgrate;
	}
	//this only works because the deck of the shit is on perfect 
	//angles and we're headed exactly in the 180 degree direction
	
	while( !flag("deck_windows") )
	{
		//(1) find the leader of the pack...and make his animrate a little slower
		//the leader is based on the x value - the furthest left is less than right
		leader = pack[0];
		for(i=0; i<pack.size; i++)
		{
			if(leader.origin[0] > pack[i].origin[0])
				leader = pack[i];
		}
		
		//(2) anyone who's too far behind, crank up their animrate
		//and anyone who's within range - take their animrate back down to avg
		for(i=0; i<pack.size; i++)
		{
			range = pack[i].origin[0] - leader.origin[0];
				
			if( range > maxdist && pack[i].animplaybackrate < maxrate)
				pack[i].animplaybackrate += .05;
			else if(pack[i].animplaybackrate > avgrate)
				pack[i].animplaybackrate -= .05;
		}
		
		wait .1;
	}
	for(i=0; i<pack.size; i++)
		pack[i].animplaybackrate = pack[i].oldanimplaybackrate;
	
	level.player.ignoreme = false;
}

deck_heroes(node, list)
{
	self pushplayer( true );
	self.goalradius = 32;
	self.ignoreme = true;
	
	if( node.script_noteworthy == "grigsby" )
	{
		self waittillmatch("single_anim_done");
		self setgoalpos (self.origin);
		self.desired_anim_pose = "crouch";	
		self allowedstances("crouch");
		self thread animscripts\utility::UpdateAnimPose();
		//Ready sir.
		radio_dialogue("cargoship_grg_readysir");
		//Fan out. Three metre spread.
		thread radio_dialogue("cargoship_pri_fanout");
		self allowedstances("stand","crouch","prone");
		
		flag_set("_sea_bob");
		flag_set("walk_deck");
		iprintlnbold("END OF CURRENTLY SCRIPTED LEVEL");
	}
	

	self setgoalnode( node );
	if( node.radius )
		self.goalradius = node.radius;
	else
		self.goalradius = 32;
	
	node = getnode(node.target, "targetname");
	
	self waittill("goal");
	flag_wait("walk_deck");
	
	self enable_cqbwalk();
		
	while( isdefined( node.target ) )
	{
		self setgoalnode( node );
		
		if( node.radius )
			self.goalradius = node.radius;
		else
			self.goalradius = 32;
	
		self waittill("goal");
		
		struct = getstruct(node.targetname, "target");
		if( isdefined( struct ) )
		{
			trig = getent( struct.targetname, "target" );
			if( !flag( trig.script_flag ) )
			{
				if( node.radius )
				{
					self setgoalnode( getClosest(node.origin, list, node.radius) );	
					self.goalradius = 16;
				}
				flag_wait( trig.script_flag );
			}
		}
		
		node = getnode(node.target, "targetname");
	}
	
	flag_set("deck_windows");
	self setgoalnode( node );
	self.goalradius = 16;
	self disable_cqbwalk();
	self.ignoreme = false;
	self pushplayer( false );
}

deck_heli()
{
	flag_wait("deck_heli");
		
	spot = getstruct( "heli_deck_landing_node", "targetname" );	
	level.heli.vehicle setspeed( 40, 30, 20 );
	level.heli.vehicle sethoverparams( 0, 0, 0 );
		
	level.heli.vehicle setgoalyaw(spot.angles[1]);
	level.heli.vehicle settargetyaw(spot.angles[1]);
	level.heli.vehicle setvehgoalpos( spot.origin + (0,0,146), 1 );
	level.heli.vehicle setNearGoalNotifyDist( 32 );
	level.heli.vehicle waittill( "near_goal" );
		
	flag_wait("deck_drop");
	thread radio_dialogue("cargoship_hp1_forwarddeckradio");
	level.heli.model thread heli_searchlight_target("default");	
	level.heli notify("unload_rest");
	
	wait 2;
	maps\cargoship_fx::flash(3, 4, 2, 3);
	level.player thread play_sound_on_entity ("elm_thunder_distant");
	level.player thread play_sound_on_entity ("elm_thunder_strike");	
	wait 1;
	maps\cargoship_fx::flash(3, 4, 2, 3);
	level.player thread play_sound_on_entity ("elm_thunder_distant");
	level.player thread play_sound_on_entity ("elm_thunder_strike");
	wait 2;
	maps\cargoship_fx::flash(3, 4, 2, 3);
	level.player thread play_sound_on_entity ("elm_thunder_distant");
	
	wait 3.5;

	level.heli.vehicle sethoverparams( 48, 15, 8 );
	
	wait 1;
	
	level.heli.model thread heli_searchlight_target( "hero", "price" );
	level.heli.vehicle setyawspeed(140, 80, 60, .2);
	level.heli.vehicle setgoalyaw(spot.angles[1] - 150);
	level.heli.vehicle settargetyaw(spot.angles[1] - 150);
	
	wait .75;
	
	spot = getstruct(spot.target, "targetname");
	level.heli.vehicle setvehgoalpos( spot.origin, 0 );
	level.heli.vehicle setNearGoalNotifyDist( 96 );
	
	wait .5;
	
	level.heli.vehicle setyawspeed(80, 40, 40, .1);
		
	level.heli.vehicle waittill( "near_goal" );
	level.heli.vehicle setspeed( 30, 10, 15 );
	
	spot = getstruct(spot.target, "targetname");
	level.heli.vehicle setvehgoalpos( spot.origin, 1 );
	level.heli.vehicle setNearGoalNotifyDist( 96 );
	
	wait .5;
		
	level.heli.vehicle waittill( "near_goal" );
	
	level.heli.vehicle setgoalyaw(45);
	level.heli.vehicle settargetyaw(45);
	
	wait 2;
}

deck_enemies_main()
{
	array = getentarray( "deck2_patrol","targetname" );
	array = array_combine( array, getentarray( "deck2_smoker", "targetname" ) );
	array = array_combine( array, getentarray( "deck2_platform", "targetname" ) );
	array_thread( array, ::add_spawn_function, ::deck_enemies_logic);	
}

deck_enemies_platform()
{
	if( !isdefined(level.deck2_platform) )
		level.deck2_platform = [];
		
	switch(level.deck2_platform.size)
	{
		case 0:
			self.animname = "platform_center";
			level.deck2_platform[0] = self;
			break;
		case 1:
			self.animname = "platform_right";
			level.deck2_platform[1] = self;
			break;
	}
	
	node = getnode("deck_platform_node","targetname");
	self thread deck_enemies_platform2(node);
	//this is a wierd way to check to see if the array is complete AND 
	//to make sure only one instance of this thread runs
	if(self.animname != "platform_right")
		return;
	
	level endon("deck_platform_aware");
	
	node anim_reach_and_idle( level.deck2_platform, "talk", "talk_idle", "stop_loop" );
	flag_wait("moveup_deck2a");
	node notify( "stop_loop" );
	node anim_single( level.deck2_platform, "talk" );
}

deck_enemies_platform2(node)
{	
	self waittill_either("damage", "see_enemy");
	
	array_notify(level.deck2_platform, "see_enemy");
	node notify( "stop_loop" );
	self stopanimscripted();
	level endon("deck_platform_aware");
}

deck_enemies_logic()
{
	self.ignoreme = true;
	self.health = 10;
	self.maxhealth = 10;
	node = getnode(self.target,"targetname");
	
	if( isdefined(self.script_noteworthy) && self.script_noteworthy == "deck2_smoker" )
		self thread smoking_loop( node, "moveup_deck1b" );
	else if( isdefined(self.script_noteworthy) && self.script_noteworthy == "deck2_patrol" )
		self thread patrol();
	else if( isdefined(self.script_noteworthy) && self.script_noteworthy == "deck2_platform" )
		self thread deck_enemies_platform();
	
	self thread deck_enemies_behavior();
	
	self endon("death");
	self waittill("in_range");
	self.ignoreme = false;
}

deck_enemies_behavior()
{
	self endon("death");
	
	ai = getaiarray("allies");
	ai = array_add(ai, level.player);
	
	maxdist = 800;
	maxdistsqrd = maxdist * maxdist;
	loop = true;
	
	while( loop )
	{
		for(i=0; i<ai.size; i++)
		{
			check1 = distancesquared( ai[i].origin, self.origin ) < maxdistsqrd;
						
			if( check1 )
			{
				check2 = ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "deck2_platform" );
				check3 = ( isdefined( ai[i].execute_mode ) && ai[i].execute_mode == true );
				loop = false;
				if( check2 && !check3)
					ai[i] thread execute_ai_solo(self, 1);
				break;
			}
		}
		wait .25;
	}
	
	self notify("in_range");
	
	maxdist = 350;
	maxdistsqrd = maxdist * maxdist;
	
	while( 1 )
	{
		for(i=0; i<ai.size; i++)
		{
			if( distancesquared( ai[i].origin, self.origin ) < maxdistsqrd  && self cansee(ai[i]) )
				ai[i] thread deck_enemies_see( self );
		}
		wait .25;
	}
}

deck_enemies_see( enemy )
{
	self notify ("deck2_enemies_see");
	self.ignoreme = false;
	
	enemy notify( "stop_smoking" );
	enemy notify( "patrol_stop" );
	enemy notify( "see_enemy" );
	enemy stopanimscripted();
		
	self endon ("deck2_enemies_see");
	enemy waittill("dead");
	self.ignoreme = true;
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 				  	ESCAPE LOGIC														*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/
escape_main()
{
	flag_wait("escape");
	array_thread(getentarray("escape_flags","script_noteworthy"), maps\_utility::trigger_on);
	flag_set("escape_cargohold2_fx");
	
	thread escape_explosion();
	thread escape_tiltboat();
	array_thread( getentarray("escape_event","targetname"), ::escape_event );
	array_thread( getentarray("light_cargohold","targetname"), ::misc_light_flicker, "cargo_vl_white", "cargohold_fx", "escape_explosion");
	array_thread( getentarray("lights_cargohold_up","targetname"), ::misc_light_flicker, "cargo_vl_white_soft", "cargohold_fx", "escape_explosion");
	array_thread( getentarray("lights_hallway_lower","targetname"), ::misc_light_flicker, undefined, "cargohold_fx", "escape_explosion");
	
	heroes = [];
	keys = getarraykeys( level.heroes );
	for(i=0; i<keys.size; i++)
	{
		key = keys[i];
		if( issubstr(key, "pilot") || issubstr(key, "seat") )
			continue;
		heroes[ heroes.size ] = level.heroes[ key ];
	}
	
	level.heroes["price"] thread escape_heroes_holdtheline(350, heroes, 25);
	level.heroes["grigsby"] thread escape_heroes_holdtheline(350, heroes, 25);
	level.heroes["alavi"] thread escape_heroes_holdtheline(350, heroes, 25);
	
	array_thread( heroes, ::escape_heroes );
	array_thread( getentarray("sink_waterlevel","targetname"), ::escape_waterlevel );
	
	flag_wait("escape_explosion");
	array_thread( heroes, ::escape_heroes2 );
	//talk a whole bunch about shit - then go
	wait 11;
	
	level.heroes["alavi"] thread escape_heroes_run( "escape_cargohold2" );	
	wait .5;
	level.heroes["price"] thread escape_heroes_run( "escape_cargohold2" );	
	wait .5;
	level.heroes["grigsby"] thread escape_heroes_run( "escape_cargohold2" );	
	
	wait 1.5;
	
	musicPlay("cargoship_intro_music");
	
	level.heroes["alavi"] thread escape_heroes_holdtheline(400, heroes, 200);
	level.heroes["price"] thread escape_heroes_holdtheline(400, heroes, 150);
	level.heroes["grigsby"] thread escape_heroes_holdtheline(350, heroes, 150);
	
	flag_wait( "escape_cargohold2_flag" );
	array_thread( heroes, ::escape_heroes_run, "escape_cargohold1" );
	
	flag_wait( "escape_cargohold1_enter" );
	flag_clear( "escape_cargohold2_fx" );
	
	flag_wait( "escape_cargohold1_flag" );
	array_thread( heroes, ::escape_heroes_run, "escape_hallway_lower" );
	
	flag_wait( "escape_hallway_lower_flag" );
	array_thread( heroes, ::escape_heroes_run, "escape_hallway_upper" );
	
	flag_wait( "escape_hallway_upper_flag" );
	array_thread( heroes, ::escape_heroes_run, "escape_aftdeck" );
}


escape_heroes_run(name)
{				
	self allowedstances("stand", "crouch");
	
	self pushplayer( true );
	self.goalradius = 116;
	self.ignoreme = true;
	self.ignoresuppression = true;
	self.interval = 0;//self.oldinterval;
	self.disableArrivals = true;
		
	temp = getnodearray(name + "_start","targetname");
	node = undefined;
	for(i=0; i<temp.size; i++)
	{
		if(	temp[i].script_noteworthy == self.script_noteworthy )
		{
			node = temp[i];
			break;	
		}
	}

	while( isdefined( node ) )
	{
		self setgoalnode( node );
		
		if( node.radius )
			self.goalradius = node.radius;
		else
			self.goalradius = 116;
	
		self waittill("goal");
		
		if(isdefined(node.target))
			node = getnode(node.target, "targetname");
		else
			node = undefined;
	}
	
	if( flag(name + "_flag") )
		return;
	
	self escape_heroes_run_wait(name);
}

escape_heroes2()
{	
	self.animplaybackrate = 1.0;
		
	node = spawn("script_origin", self.origin);
	node.angles = (0, 180, 0);
	
	self.oldanimname = self.animname;
	self.animname = "escape";
	
	self allowedstances("crouch", "stand");
	
	self stopanimscripted();
	node thread anim_single_solo(self, "blowback");
	
	wait 10;
	self stopanimscripted();
	
	self setgoalpos(self.origin);
	self.goalradius = 16;
	self.animname = self.oldanimname;
	node delete();
}

escape_heroes()
{
	level endon ("escape_explosion");
	self.disableArrivals = true;
	temp = getnodearray("escape_nodes","targetname");
	node = undefined;
	for(i=0; i<temp.size; i++)
	{
		if(	temp[i].script_noteworthy == self.script_noteworthy )
		{
			node = temp[i];
			break;	
		}
	}
	
	self allowedstances("crouch", "stand");
	
	time = 0;
	switch(self.script_noteworthy)
	{
		case "grigsby":
			time = 0;
			break;
		case "price":
			time = .4;
			break;
		case "alavi":
			time = 1.25;
			break;	
	}
	
	self pushplayer( true );
	self.goalradius = 32;
	self.ignoreme = true;
	self.ignoresuppression = true;
	self.oldinterval = self.interval;
	self.interval = 0;
		
	while( isdefined( node ) )
	{
		self setgoalnode( node );
		
		if( node.radius )
			self.goalradius = node.radius;
		else
			self.goalradius = 32;
	
		self waittill("goal");
		
		struct = getstruct(node.targetname, "target");
		if( isdefined( struct ) )
		{
			trig = getent( struct.targetname, "target" );
			if( !flag( trig.script_flag ) )
				flag_wait( trig.script_flag );
			if(trig.script_flag == "escape_moveup1")
				wait time;
		}
		
		if(isdefined(node.target))
			node = getnode(node.target, "targetname");
		else
			node = undefined;
	}
	
}

escape_waterlevel()
{
	array_thread(getstructarray(self.target, "targetname"), ::escape_waterlevel_parts, self);
	level waittill("escape_show_waterlevel");
	
	start = self.path;
	self show();
	self moveto(start.origin, .5);
	self rotateto(start.angles, .5);
	
	wait .5;
	self notify("show");
	
	level._sea_org waittill("tilt_20_degrees");
	
	start = getstruct(start.target, "targetname");
	self moveto(start.origin, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);
	self rotateto(start.angles, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);
	
	level._sea_org waittill("tilt_30_degrees");
	
	start = getstruct(start.target, "targetname");
	self moveto(start.origin, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);
	self rotateto(start.angles, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);
}

escape_tiltboat()
{
	flag_wait("start_sinking_boat");
	objects = getentarray("boat_sway", "script_noteworthy");
	for(i=0; i<objects.size; i++)
		objects[i].link.setscale = 1.0;
	
	level waittill("escape_show_waterlevel");
	
	level._sea_org.time = 1;
	level._sea_org.rotation = (0,0,-10);	//10 degrees
	
	level._sea_org notify("sway1");
	level._sea_org notify("sway2");
	
	level._sea_link rotateto(level._sea_org.rotation, level._sea_org.time, 1, 0);	
	level._sea_org 	rotateto(level._sea_org.rotation, level._sea_org.time, 1, 0);	
	wait level._sea_org.time;
	
	
	level waittill("escape_unlink_player");
	level._sea_org.time = 15;
	level._sea_org.acctime = 0;
	level._sea_org.dectime = 3;
	level._sea_org.rotation = (0,0,-20);	//20 degrees
	
	level._sea_org notify("tilt_20_degrees");
	level._sea_org notify("sway1");
	level._sea_org notify("sway2");
	
	level._sea_link rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	level._sea_org 	rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	wait level._sea_org.time;
	
	flag_wait("escape_cargohold1_enter");
	level._sea_org.time = 3.5;
	level._sea_org.acctime = 1.75;
	level._sea_org.dectime = 1.75;
	level._sea_org.rotation = (0,0,-32);	//30 degrees
	
	level._sea_org notify("tilt_30_degrees");
	level._sea_org notify("sway1");
	level._sea_org notify("sway2");
	
	level._sea_link rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	level._sea_org 	rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	wait level._sea_org.time;
	
	level._sea_org.time = 1;
	level._sea_org.acctime = level._sea_org.time * .5;
	level._sea_org.dectime = level._sea_org.time * .5;
	level._sea_org.rotation = (0,0,-30);
	
	level._sea_link rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	level._sea_org 	rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	wait level._sea_org.time;
}

escape_explosion()
{
	allcargoholdfx	= getfxarraybyID( "cgoshp_drips_cargohold_center" );
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cgoshp_drips_cargohold_edge" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_red_thin" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_red_lrg" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_steam" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_steam_add" ));
		
	trig = getent("escape_sink_start", "targetname");
	trig waittill("trigger");
	
	flag_clear("_sea_bob");
	flag_set("start_sinking_boat");
	level._sea_org notify("manual_override");
	
	for(i=0; i<allcargoholdfx.size; i++)
		allcargoholdfx[i] pauseEffect();
	level notify("sinking the ship");
	
	wait .2;
	flag_set("escape_explosion");
	thread escape_explosion_drops();
	earthquake(0.3, .5, level.player.origin, 256);
	
	exp = spawn("script_model", (8, -360, -216));
	exp.angles = (0,90,0);
	exp setmodel("tag_origin");
	exp playsound( "cgo_helicopter_hit" );
	playfxontag(level._effect["sinking_explosion"], exp, "tag_origin");
	VisionSetNaked( "cargoship_blast", .25 );	
	
	
	wait .2;
	thread escape_shellshock();
	
	wait .3;
	exp.origin = (8, -600, -70);	
	exp.angles = (0,-90,0);
	playfxontag(level._effect["sinking_leak_large"], exp, "tag_origin");
	
	wait 8;
	level.player thread escape_quake();
	//flag_set("start_sinking_boat");
	VisionSetNaked( "cargoship_indoor", 6 );
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 				  	MISC LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

misc_dummy()
{
	
}

misc_setup()
{
	array_thread(getstructarray("spotlights","targetname"), ::misc_spotlight_fx);	
	array_thread(getstructarray("floorlights","targetname"), ::misc_floorlight_fx);
	array_thread(getentarray("cargohold_drip_center","targetname"), ::misc_cargohold_fx_center);
	array_thread(getstructarray("cargohold_drip_edge","targetname"), ::misc_cargohold_fx_edge);	
	array_thread(getentarray("fx_handler", "targetname"), ::misc_fx_handler_trig);
	thread misc_fx_handlers();
	thread misc_radar();	
	array_thread(getentarray("vision_change","targetname"), ::misc_vision);	
	array_thread(getentarray("tv","targetname"), ::misc_tv);
	array_thread(getentarray("tv","targetname"), ::misc_tv_stairs_on);
	array_thread(getentarray("light_flicker","targetname"), ::misc_light_flicker, undefined, "topside_fx");
	array_thread(getentarray("light_cargohold","targetname"), ::misc_light_sway);
	array_thread(getentarray("escape_flags","script_noteworthy"), maps\_utility::trigger_off);
}

misc_light_sway()
{
	ang = self.angles;
	ang += (0,90,0);
	while(1)
	{
		level._sea_org waittill("sway1");
		
		time =  (level._sea_org.time);
		acc = time * .5;
		
		self rotateto( ang + (-5,0,0), time, acc, acc );
		
		level._sea_org waittill("sway2");
		
		time =  (level._sea_org.time );
		acc = time * .5;
		
		self rotateto( ang + (5,0, 0), time, acc, acc );
	}	
}

misc_tv_stairs_on()
{
	wait 1;
	self.usetrig notify("trigger");
	start = getent("start_bridge_standoff", "targetname");
	start waittill("trigger");
	self.usetrig notify("trigger");	
}

misc_tv()
{
	self setcandamage(true);
	self.damagemodel = undefined;
	self.offmodel = undefined;
	
	switch(self.model)
	{
		case "com_tv2_testpattern":
			self.damagemodel = "com_tv2_d";
			self.offmodel = "com_tv2";
			self.onmodel = "com_tv2_testpattern";
			break;
		case "com_tv1_testpattern":
			self.damagemodel = "com_tv2_d";
			self.offmodel = "com_tv1";
			self.onmodel = "com_tv1_testpattern";
			break;	
	}
		
	self.glow = undefined;
	self.gloworg = self.origin + (0,0,14) + vector_multiply(anglestoforward(self.angles), 55);
	self.usetrig = getent(self.target, "targetname");
	self.usetrig usetriggerrequirelookat();
	
	if( isdefined( self.usetrig.target ) )
	{
		self.lite = getent(self.usetrig.target, "targetname");
		if( isdefined( self.lite ) )
			self.liteintensity = self.lite getLightIntensity();
	}
	self thread misc_tv_damage();
	self thread misc_tv_off();
}

misc_tv_off()
{
	self.usetrig endon("death");
	
	while(1)
	{
		self.glow = spawn("script_model", self.gloworg);
		self.glow setmodel("tag_origin");
		self.glow hide();
		playfxontag( level._effect[ "aircraft_light_cockpit_blue" ], self.glow, "tag_origin" );
		
		if( isdefined( self.lite ) )
			self.lite setLightIntensity(self.liteintensity);
		
		wait .2;
		self.usetrig waittill("trigger");
		self setmodel(self.offmodel);
		
		self.glow delete();
		self.glow = undefined;
		
		if( isdefined( self.lite ) )
			self.lite setLightIntensity(0);
		
		wait .2;
		self.usetrig waittill("trigger");
		self setmodel(self.onmodel);
	}
}

misc_tv_damage()
{
	self waittill("damage", damage, other, direction_vec, P, type );
	
	self.usetrig notify("death");
		
	obj = spawn("script_model", self.origin);
	obj.angles = self.angles;
	obj setmodel(self.damagemodel);
	
	if(isdefined(self.glow))
		self.glow delete();
	
	if( isdefined( self.lite ) )
		self.lite setLightIntensity(0);
	
	self.usetrig delete();
	self delete();
	
	obj physicsLaunch( p, vector_multiply(direction_vec, damage) );
}

misc_vision()
{
	attr = strtok(self.script_parameters, ":;, ");
	time = 2;
	for(j=0;j<attr.size; j++)
	{
		if(attr[j] == "time")
		{
			j++;
			time = int(attr[j]);
		}
	}
	while(1)
	{
		self waittill("trigger");
		VisionSetNaked( self.script_noteworthy, time );
	}
}

misc_fx_handler_trig()
{
	if(!isdefined(level.fx_handlers))
		level.fx_handlers = [];
	level.fx_handlers[level.fx_handlers.size] = self.script_noteworthy;
	
	while(1)
	{
		self waittill("trigger");
		
		for(i=0; i<level.fx_handlers.size; i++)
		{
			if(level.fx_handlers[i] == self.script_noteworthy)
				flag_set( self.script_noteworthy );
			else
				flag_clear( level.fx_handlers[i] );
		}	
	}
}

misc_fx_handlers()
{
	wait .1; 
	allcargoholdfx	= getfxarraybyID( "cgoshp_drips_cargohold_center" );
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cgoshp_drips_cargohold_edge" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_red_thin" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_soft" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_eql" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_eql_flare" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_sml" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_sml_a" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_red_lrg" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_steam" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_steam_add" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "chains" ));
	
	alltopsidefx 	= getfxarraybyID( "rain_noise" );
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "rain_noise_ud" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgoshp_lights_cr" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgoshp_lights_flr" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgoshp_drips" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgoshp_drips_a" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgo_ship_puddle_small" ));
		
	while(1)
	{
		
		if(flag("cargohold_fx"))
		{
			for(i=0; i<alltopsidefx.size; i++)
				alltopsidefx[i] pauseEffect();
			for(i=0; i<allcargoholdfx.size; i++)
				allcargoholdfx[i] restartEffect();
			
			flag_clear("_sea_waves");
			level.sea_model hide();
			thread maps\_weather::rainNone(1);
				
			flag_wait("topside_fx");
		}
		if(flag("topside_fx"))
		{
			for(i=0; i<allcargoholdfx.size; i++)
				allcargoholdfx[i] pauseEffect();
			for(i=0; i<alltopsidefx.size; i++)
				alltopsidefx[i] restartEffect();
				
			if(level.jumpto != "start" || flag("quarters"))
				flag_set("_sea_waves");
			level.sea_model show();
			thread maps\_weather::rainHard(1);
			
			flag_wait("cargohold_fx");
		}	
		
	}
}

misc_radar()
{
	radar = getent("radar","targetname");
	time = 5000;
	
	while(1)
	{
		radar rotatevelocity((0,120,0), time);	
		wait time;
	}
}

misc_floorlight_fx()
{
	ent = createOneshotEffect("cgoshp_lights_flr");
 	ent.v["origin"] = (self.origin);
	ent.v["angles"] = (self.angles);
 	ent.v["fxid"] = "cgoshp_lights_flr";
 	ent.v["delay"] = -15;	
}

misc_spotlight_fx()
{
	ent = createOneshotEffect("cgoshp_lights_cr");
	ent.v["origin"] = (self.origin);
	ent.v["angles"] = (self.angles);
	ent.v["fxid"] = "cgoshp_lights_cr";
	ent.v["delay"] = -15;
}

misc_cargohold_fx_edge()
{
	level endon("sinking the ship");
	center =  getstruct("wave_fx_center", "targetname");
	forward = vector_multiply(anglestoforward(self.angles), -1);
	right = anglestoright(center.angles);
	msg = "none";
	
	if(vectordot(forward, right) > 0)
		msg = "sway1";
	else
		msg = "sway2";

	while(1)
	{
		level._sea_org waittill(msg);
		wait (level._sea_org.time - 1.5);
		
		wait randomfloat(0, .5);
		if(flag("cargohold_fx") && randomfloat(100) > 50)
		{
			playfx(level._effect["cgoshp_drips_cargohold_edge"], self.origin, forward);
			if(isdefined(self.script_noteworthy))
				thread play_sound_in_space("elm_wave_crash_ext", self.origin);
		}
	}
	
}

misc_cargohold_fx_center()
{
	level endon("sinking the ship");
	xmodel = spawn("script_model", self.origin);
	xmodel setmodel("fastrope_arms");
	xmodel hide();
	self.angles = level._sea_org.angles;
	xmodel.angles = (-90,0,0);
	xmodel thread misc_cargohold_fx_center2();
	xmodel linkto(self);
	
	while(1)
	{
		level._sea_org waittill("sway1");
		self rotateto(vector_multiply(level._sea_org.rotation, 2), level._sea_org.time, level._sea_org.time * .5, level._sea_org.time * .5);	

		level._sea_org waittill("sway2");
		self rotateto(vector_multiply(level._sea_org.rotation, 2), level._sea_org.time, level._sea_org.time * .5, level._sea_org.time * .5);
	}
}

misc_cargohold_fx_center2()
{	
	level endon("sinking the ship");
	wait randomfloat(0, 2);
	while(1)
	{
		while(flag("cargohold_fx"))
		{
			playfxontag(level._effect["cgoshp_drips_cargohold_center"], self, "tag_origin");
			wait randomfloatrange(5,10);
		}
		
		flag_wait("cargohold_fx");
	}
}

misc_precacheInit()
{
	//level.strings["obj_alassad"] 		= &"DESCENT_OBJ_ALASSAD";
	//precacheString(level.strings["obj_alassad"]);
	
	level.strings["intro1"]				= &"CARGOSHIP_TITLE";	
	level.strings["intro2"]				= &"CARGOSHIP_DATE";
	level.strings["intro3"]				= &"CARGOSHIP_PLACE";
	level.strings["intro4"]				= &"CARGOSHIP_INFO";
	
	precacheString(level.strings["intro1"]);
	precacheString(level.strings["intro2"]);
	precacheString(level.strings["intro3"]);
	precacheString(level.strings["intro4"]);
	
	precacheItem("rpg");
	precacheItem("rpg_straight");
	precacheItem("facemask");
	precacheTurret("heli_spotlight");
	precacheTurret("heli_minigun_noai");
	precacheModel("vehicle_blackhawk_hero");
	precacheModel("tag_flash");
	precacheModel("tag_origin");
	precacheModel("weapon_saw_MG_setup");
	precachemodel("com_tv2_d");
	precachemodel("com_tv1");
	precachemodel("com_tv2");
	precachemodel("prop_price_cigar");
	precachemodel("ch_industrial_light_02_off");
	precachemodel("com_lightbox");
	precachemodel("me_lightfluohang");
	precacheshellshock("cargoship");
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  	OBJECTIVE LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/
objective_main()
{
	if(level.jumpto == "start")
		wait 5;
	
	objnum = 1;
	
	objective_add(objnum, "active");
	objective_string_nomessage(objnum, "Capture Zaekhev alive.");
	objnum++;
	
	switch(level.jumpto)
	{
		case "start":
			flag_wait("at_bridge");
		case "bridge":{
			objective_add(objnum, "active", "Secure the bridge", (3052, 15, 407) );
			objective_current(objnum);	
	
			level waittill("bridge_secured");
			objective_state( objnum, "done");
			objnum++;
			
			objective_add(objnum, "active", "Secure the forward deck for alpha squad.", ( 2640, 624, 208 ));
			objective_current(objnum);		
			
			flag_wait("deck");
			objective_state( objnum, "done");
			objnum++;
			}
		case "deck":{
			objective_add(objnum, "active", "Make your way across the deck.", ( -2116, 0, 80 ));
			objective_current(objnum);		
			}
	}	
}

objective_move(name, objnum, check, msg)
{
	if(isdefined(check) && level.jumpto != check)
		return;
	
	if(!isdefined(level.objective_position))
		level.objective_position = [];
	
	if(isdefined(msg))
		level waittill(msg);
		
	level notify("objective_move_" + objnum);
	level endon("objective_move_" + objnum);
	
	trig = getent("objective_move_" + name, "targetname");
	
	while(isdefined(trig))
	{
		objective_position(objnum, trig.origin);
		level.objective_position[objnum] = trig.origin;
		trig waittill("trigger");
		if(!isdefined(trig.target))
			trig = undefined;
		else
			trig = getent(trig.target, "targetname");	
	}
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  	JUMPTO LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

jumptoInit()
{
	if (getdvar("jumpto") == "")
    	setdvar("jumpto", "");
    
    if (!isdefined(getdvar ("jumpto")))
	 	setdvar ("jumpto", "");
    	
	//skip to a point in the level
	string1 = getdvar("start");
	string2 = getdvar("jumpto");
	level.jumpto	= "start";
	level.jumptosection = "bridge";
	
	if(isdefined(string1) && !( string1 == "" || issubstr( string1 , " ** ")) )
		level.jumpto = string1;
	if(isdefined(string2) && string2 != "")
		level.jumpto = string2;
	
	jumpnum = 1;
	if(level.jumpto == "bridge" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "bridge"; level.jumpto = "bridge"; return; }
	jumpnum++;
	if(level.jumpto == "quarters" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "quarters"; level.jumpto = "quarters"; return; }
	jumpnum++;
	if(level.jumpto == "deck" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "deck"; level.jumpto = "deck"; return; }
	jumpnum++;
	if(level.jumpto == "hallways" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "hallways"; level.jumpto = "hallways"; return; }
	jumpnum++;
	if(level.jumpto == "cargohold" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "cargohold"; level.jumpto = "cargohold"; return; }
	jumpnum++;
	if(level.jumpto == "escape" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "escape"; level.jumpto = "escape"; return; }
	jumpnum++;
}

jumptoThink()
{
	jumptoRandomTrig(level.jumpto);
	trig = [];
	
	switch(level.jumpto)
	{
		case "start":
			//flag_set("_sea_viewbob");
			break;
		case "bridge":
			flag_set("_sea_viewbob");
			flag_set("_sea_waves");
			flag_wait("heroes_ready");
			
			level.heli maps\mo_fastrope::fastrope_heli_overtake_now();
			level.heli.vehicle setspeed(700, 700);
			level.heli.vehicle setvehgoalpos(getstruct( "intro_ride_node", "targetname" ).origin + (0,0,920), 1);
			level.heli.vehicle settargetyaw(220);
			
			wait 7;
			level.heli.model heli_searchlight_on();
			
			break;
		case "deck":
			flag_set("_sea_viewbob");
			flag_set("_sea_waves");
			flag_clear("_sea_bob");
			flag_wait("heroes_ready");
			
			
			level.heli maps\mo_fastrope::fastrope_heli_overtake_now();
			level.heli.vehicle setspeed(400, 400);
			level.heli.vehicle setvehgoalpos(getstruct( "heli_deck_landing_node", "targetname" ).origin + (0,0,146), 1);
			
												
			node = getnode("quarters_price_2","targetname");
			level.heroes["price"] thread jumptoActor(node.origin);
						
			node = getnode("quarters_alavi_2","targetname");
			level.heroes["alavi"] thread jumptoActor(node.origin);
						
			level.heli.model heli_searchlight_on();
			level.heli.model heli_minigun_attach("left");
		
			wait .5;
	
			flag_set("deck_drop");
			flag_set("deck_heli");
			flag_set("deck");
			
			break;
		case "cargohold":
			flag_clear("_sea_waves");
			flag_clear("topside_fx");
			flag_set("_sea_viewbob");
			flag_set("cargohold_fx");
			thread maps\_weather::rainNone(1);
			VisionSetNaked( "cargoship_indoor", 2 );
			break;
		case "escape":
			flag_clear("_sea_waves");
			flag_clear("topside_fx");
			flag_set("_sea_viewbob");
			flag_set("cargohold_fx");
			thread maps\_weather::rainNone(1);
			VisionSetNaked( "cargoship_indoor", 2 );
			
			flag_wait("heroes_ready");
			level.heli maps\mo_fastrope::fastrope_heli_overtake_now();
						
			temp = getnodearray("escape_nodes","targetname");
			node = [];
			for(i=0; i<temp.size; i++)
				node[temp[i].script_noteworthy] = temp[i];
			
			level.heroes["price"] 	thread jumptoActor(node["price"].origin);
			level.heroes["grigsby"] thread jumptoActor(node["grigsby"].origin);
			level.heroes["alavi"] 	thread jumptoActor(node["alavi"].origin);
			
			level.heroes["price"] 	disable_cqbwalk();
			level.heroes["grigsby"] disable_cqbwalk();
			level.heroes["alavi"] 	disable_cqbwalk();
						
			wait .1;
			level.heli.model delete();
			level.heli.vehicle delete();
						
			level.heroes["seat5"] stop_magic_bullet_shield();
			level.heroes["seat6"] stop_magic_bullet_shield();
			
			level.heroes["seat5"] delete();
			level.heroes["seat6"] delete();
			level.heroes["pilot"] delete();
			level.heroes["copilot"] delete();
			
			flag_set("escape");
			break;
	}
		
	array_thread(trig, ::jumptoRandomTrigThink);
	
	playerWeaponGive();
	
	node = getstruct(("jumpto_" + level.jumpto), "targetname");
	if(!isdefined(node))
		return;
	
	level.player unlink();
	level.player allowLean(true);
	level.player allowcrouch(true);
	level.player allowprone(true);
	level.player setorigin (node.origin + (0,0,32));
	level.player setplayerangles (node.angles);
}

jumptoActor(org)
{
	self notify("overtakenow");
	self unlink();
	self stopanimscripted();
		
	link = spawn("script_origin", self.origin);
	self linkto(link);
	link moveto(org, .2);
	
	wait .25;
	
	self unlink();
	link delete();
	
	self setgoalpos(org);
	self.goalradius = 16;
}

jumptoRandomTrig(name)
{
	array = getentarray("jumptoRandomTrig", "script_noteworthy");
	for(i=0;i<array.size;i++)
	{
		attr = strtok(array[i].script_parameters, ":;, ");
		for(j=0;j<attr.size; j++)
		{
			if(attr[j] == name)
			{
				array[i].jumptoRandomType = tolower(attr[j+1]);
				array[i] thread jumptoRandomTrigThink();
				break;	
			}
		}
	}
}

jumptoRandomTrigThink()
{
	if(self.classname != "trigger_multiple" && self.classname != "trigger_radius" && (!isdefined(self.jumptoRandomType)) )
		return;
	if(!isdefined(self.jumptoRandomType))
		self.jumptoRandomType = "trigger";
	switch(self.jumptoRandomType)
	{
		case "trigger":		{wait .1; self notify("trigger"); 	}break;
		case "off":			{self trigger_off(); 				}break;
		case "open":		{self door_breach_door(); 			}break;
	}
}