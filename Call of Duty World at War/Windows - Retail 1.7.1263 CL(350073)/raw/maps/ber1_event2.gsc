// scripting by Bloodlust
// level design by BSouds

#include maps\_anim;
#include maps\_utility;
#include maps\ber1_util;
#include maps\pel2_util;
#include common_scripts\utility;
#include maps\_music;

#using_animtree("generic_human");

// main function for handeling Event 2
main()
{
	
	/#
	maps\_status::show_task("event2");
	#/
	
	level thread cafe_wall_crumble();
	level thread street_ambush();
	level thread street_first_floodspawners();

}


// play FXs for Tank 1 getting killed and the wall blowing up, opening the way into the asylum
street_ambush()
{
	
	// TODO might want to add another node closer
	wallnode = getVehicleNode( "tank1_cleared_wall", "targetname" );
	wallnode waittill( "trigger" );

	//TUEY set music state to  TANK_HIT
	setmusicstate("TANK_HIT");


	flag_set( "tank_ambush" );

	street_battle();

}



///////////////////
//
// where most of the street battle threads are started
//
///////////////////////////////

street_battle()
{

	maps\_debug::set_event_printname( "Streets" );

	// decrease amount of color spawners by 1
	redshirts = getaiarray( "allies" );
	
	for( i  = 0; i < redshirts.size; i++ )
	{
		
		if( isdefined( redshirts[i].script_forcecolor ) && redshirts[i].script_forcecolor == "r" )
		{
			redshirts[i] disable_replace_on_death();
			break;
		}
		
	}
	
	level thread bookcase_push();
	level thread chain_near_asylum();
	level thread chain_street_right_1();
	level thread chain_street_right_2();
	level thread chain_street_left_1();
	level thread chain_street_left_2();
	level thread roof_shreks();
	level thread panzershrek_hits_wall();
	level thread monitor_killspawner_151();
	level thread save_mid_yard();
	level thread save_asylum_entry();
	level thread spawn_street_pickup_weapons();
	level thread maps\ber1_asylum::setup_crows();
	//level thread bathroom_mg_exploder_200();
	
	bathroom_mg = getent( "bathroom_mg", "script_noteworthy" );
	bathroom_mg setturretignoregoals( true );
	
	maps\ber1_asylum::main();
	
}



//bathroom_mg_exploder_200()
//{
//
//	// notify from flag on trigger
//	level endon( "asylum_exit" );
//
//	dmg_trigger = getent( "exploder_200", "targetname" );
//	dmg_trigger waittill( "trigger" );
//	
//	//mg_sandbag_cleanup( "auto3749", 165 );
//	
//	dmg_trigger delete();
//	
//}



streets_vo()
{

	play_vo( level.commissar, "vo", "keep_pushing" );
	
	wait( 2.5 );
	
	play_vo( level.chernov, "vo", "panzershrek_fire" );
	
	wait( 3 );
	
	play_vo( level.reznov, "vo", "deal_with_it" );
	
	wait( 2 );
	
	flag_wait( "roof_shreks" );
	
	play_vo( level.reznov, "vo", "split_up" );
	
	wait( 3 );
	
	play_vo( level.reznov, "vo", "rest_of_you" );
	
	wait( 3 );
	
	flag_wait( "last_yard_floodspawners" );
	
	play_vo( level.commissar, "vo", "fight_your_way" );
	
	wait( 3 );
	
	play_vo( level.reznov, "vo", "hunt_them_down" );
	
}



street_first_floodspawners()
{
	trigger_wait( "trig_street_first_floodspawners", "targetname" );
	simple_floodspawn( "street_first_floodspawners" );
	
	level thread streets_vo();
	
}



///////////////////
//
// will delete a floodspawner trigger that targets a spawner that may be killspawned early, depending if the yard path is taken
//
///////////////////////////////

monitor_killspawner_151()
{

	trigger_wait( "trig_killspawner_151", "targetname" );	
	
	spawn_trig = getent( "trig_spawn_street_guys_late_2", "script_noteworthy" );
	if( isdefined( spawn_trig ) )
	{
		spawn_trig delete();	
	}
	
}



///////////////////
//
// guys way up on the roof that shoot towards the street
//
///////////////////////////////

roof_shreks()
{

	trigger_wait( "trig_roof_shreks", "targetname" );
	
	flag_set( "roof_shreks" );
	
	simple_spawn( "street_asylum_roof_shreks", ::street_asylum_roof_shreks_strat );
	
	shrek_target = getent( "shrek_1_orig", "targetname" );
	shrek_target.health = 1000000;
	level thread flame_move_target( shrek_target, 6 );	
	
	shrek_target = getent( "shrek_2_orig", "targetname" );
	shrek_target.health = 1000000;
	level thread flame_move_target( shrek_target, 6 );		
	
	shrek_target = getent( "shrek_3_orig", "targetname" );
	shrek_target.health = 1000000;
	level thread flame_move_target( shrek_target, 6 );		
	
	shrek_target = getent( "shrek_4_orig", "targetname" );
	shrek_target.health = 1000000;
	level thread flame_move_target( shrek_target, 6 );		
	
}



street_asylum_roof_shreks_strat()
{

	self endon( "death" );
	
	self.accuracy = 0.05;
	self.ignoreme = 1;
	self.pacifist = 1;
	self.pacifistwait = 0.05;
	self.ignoresuppression = 1;
	
	origins = [];
	origins[origins.size] = getent( "shrek_1_orig", "targetname" );
	origins[origins.size] = getent( "shrek_2_orig", "targetname" );
	origins[origins.size] = getent( "shrek_3_orig", "targetname" );
	origins[origins.size] = getent( "shrek_4_orig", "targetname" );
	
	self.a.rockets =  7;
	
	self waittill( "goal" );
	
	while( 1 )
	{
		
		// dont fire further up the street until flag has been set (flag set on a trigger)
		if( flag( "chain_street_left_1" ) || flag( "chain_street_right_1" ) )
		{
			self SetEntityTarget( origins[ randomint( origins.size ) ] );
		}
		else
		{
			self SetEntityTarget( origins[ randomint( 2 ) ] );
		}
		
		wait( RandomIntRange( 10, 13 ) );
			
		self ClearEntityTarget();
			
			
		if( !self.a.rockets )
		{
			break;
		}
		
		wait( 0.5 );	
		
	}	
	
	goal = getnode( "node_shrek_goto_die", "targetname" );
	self setgoalnode( goal );
	
	self waittill( "goal" );
	
	self delete();
	
	
}



///////////////////
//
// if all axis near asylum entrance are cleared, move up friendlies
//
///////////////////////////////

chain_near_asylum()
{
	
	// notify from flag on trigger
	level endon( "asylum_start" );
	
	waittill_aigroupcount( "last_street_ai", 3 );
	waittill_aigroupcleared( "last_street_mg" );

	killspawner_trig = getent( "trig_killspawner_164", "targetname" );
	if( isdefined( killspawner_trig ) )
	{
		killspawner_trig notify( "trigger" );	
	}
	
	color_trig = getent( "chain_near_asylum", "targetname" );
	if( isdefined( color_trig ) )
	{
		quick_text( "chain_near_asylum" );
		color_trig notify( "trigger" );	
	}
	
}



///////////////////
//
// if all axis near street area 1 are cleared, move up friendlies
//
///////////////////////////////

chain_street_right_1()
{
	
	// notify from flag on trigger
	level endon( "asylum_start" );
	
	waittill_aigroupcount( "street_right_ai_0", 2 );
	
	
	wait( randomfloatrange( 0.75, 1.75 ) );
	
	color_trig = getent( "chain_street_1a", "targetname" );
	if( isdefined( color_trig ) )
	{
		quick_text( "chain_street_1a" );
		color_trig notify( "trigger" );	
	}	
	
	// some spawners that should get triggered
	spawn_trig = getent( "trig_roof_shreks", "targetname" );
	if( isdefined( spawn_trig ) )
	{
		spawn_trig notify( "trigger" );	
	}
	
	waittill_aigroupcleared( "street_right_ai_1" );


	wait( randomfloatrange( 0.75, 1.75 ) );

	// color chain
	color_trig = getent( "chain_street_right_1", "targetname" );
	if( isdefined( color_trig ) )
	{
		quick_text( "chain_street_right_1" );
		color_trig notify( "trigger" );	
	}
	
	// some spawners that should get triggered
	spawn_trig = getent( "trig_spawn_street_guys_late", "script_noteworthy" );
	if( isdefined( spawn_trig ) )
	{
		spawn_trig notify( "trigger" );	
	}
	
	wait( 7 );
	
	spawn_trig = getent( "trig_spawn_street_guys_late_2", "script_noteworthy" );
	if( isdefined( spawn_trig ) )
	{
		spawn_trig notify( "trigger" );	
	}	
	
}



///////////////////
//
// if all axis near street area 2 are cleared, move up friendlies
//
///////////////////////////////

chain_street_right_2()
{

	// notify from flag on trigger
	level endon( "asylum_start" );
	
	waittill_aigroupcleared( "street_right_ai_2a" );
	waittill_aigroupcount( "street_right_ai_2", 2 );

	wait( randomfloatrange( 0.75, 1.75 ) );
	
	color_trig = getent( "chain_street_2", "targetname" );
	if( isdefined( color_trig ) )
	{
		quick_text( "chain_street_2" );
		color_trig notify( "trigger" );	
	}
	
	// delete some earlier chains if not hit yet
	old_color_trig = getent( "chain_street_right_1", "targetname" );
	if( isdefined( old_color_trig ) )
	{
		old_color_trig delete();	
	}
	old_color_trig = getent( "chain_street_left_1", "targetname" );
	if( isdefined( old_color_trig ) )
	{
		old_color_trig delete();	
	}		
	
}



///////////////////
//
// if all axis near street-left-1 area are cleared, move up friendlies
//
///////////////////////////////

chain_street_left_1()
{

	// notify from flag on trigger
	level endon( "asylum_start" );
	
	// notify from script_notify on trigger
	level endon( "end_chain_street_left_1" );
	
	waittill_aigroupcleared( "street_left_ai_1" );
	
	wait( randomfloatrange( 0.75, 1.75 ) );
	
	// color chain
	color_trig = getent( "chain_street_left_1", "targetname" );
	if( isdefined( color_trig ) )
	{
		quick_text( "chain_street_left_1" );
		color_trig notify( "trigger" );	
	}
	
	// some spawners that should get triggered
	spawn_trig = getent( "trig_spawn_street_guys_left_1", "script_noteworthy" );
	if( isdefined( spawn_trig ) )
	{
		spawn_trig notify( "trigger" );	
	}	
	
	bookcase_trig = getent( "trig_close_to_bookcase", "targetname" );
	if( isdefined( bookcase_trig ) )
	{
		bookcase_trig notify( "trigger" );	
	}	
	
}



///////////////////
//
// if all axis near street-left-2 area are cleared, move up friendlies
//
///////////////////////////////

chain_street_left_2()
{

	// notify from flag on trigger
	level endon( "asylum_start" );
	
	// notify from script_notify on trigger
	level endon( "end_chain_street_left_2" );
	
	waittill_aigroupcount( "street_left_ai_2", 2 );
	
	wait( randomfloatrange( 0.75, 1.75 ) );
	
	quick_text( "chain_street_left_2" );	
	
//	// color chain
//	color_trig = getent( "chain_street_left_1", "targetname" );
//	if( isdefined( color_trig ) )
//	{
//		color_trig notify( "trigger" );	
//	}
	
	// some spawners that should get triggered
	spawn_trig = getent( "trig_asylum_entryway_spawners", "script_noteworthy" );
	if( isdefined( spawn_trig ) )
	{
		spawn_trig notify( "trigger" );	
	}	
	
	waittill_aigroupcount( "last_street_ai", 8 );
	
	spawn_trig = getent( "trig_last_yard_floodspawners", "script_noteworthy" );
	if( isdefined( spawn_trig ) )
	{
		spawn_trig notify( "trigger" );	
	}	
	
}

///////////////////
//
// animation of guy pushing over bookcase for cover
//
///////////////////////////////

bookcase_push()
{

	// wait till near the pub
	trigger_wait( "trig_close_to_bookcase", "targetname" );
	
	// pushes over bookcase if player doesn't look at the lookat trigger but moves far ahead enough
	level thread trig_override( "trig_lookat_bookcase" );
	// wait for player to look at the bookcase area
	trigger_wait( "trig_lookat_bookcase", "targetname" );
	
	simple_spawn_single( "pub_bookcase_spawner", ::pub_bookcase_strat );	

	// Wii optimizations
	if( !level.wii)
	{
		simple_spawn_single( "extra_bookcase_guy", ::extra_bookcase_strat );	
	}
	
}



pub_bookcase_strat()
{

	self endon( "death" );

	self.goalradius = 30;
	self.animname = "street";
	
	anim_node = getent( "orig_pub_bookcase", "targetname" );
	anim_reach_solo( self, "bookcase_push", undefined, anim_node );
	
	// clip brush turn on
	bookcase_clip_brush = getent( "pub_bookcase_brush", "targetname" );
	bookcase_clip_brush solid();	

	self.a.pose = "crouch"; 
	
	flag_set( "bookcase_push_starting" );
	
	self setcandamage( false );
	
	anim_single_solo( self, "bookcase_push", undefined, anim_node );		
	
	self setcandamage( true );
	
	flag_set( "bookcase_pushed_over" );
	
	goal_node = getnode( "node_bookcase_goto", "targetname" );
	self setgoalnode( goal_node );
	
	wait( 5 );
	
	self.goalradius = 250;
		
}



///////////////////
//
// 2nd bookcase guy
//
///////////////////////////////

extra_bookcase_strat()
{

	self endon( "death" );
	
	self.goalradius = 20;
	
	flag_wait_or_timeout( "bookcase_push_starting", 5 );
	
	original_pusher = get_specific_single_ai( "bookcase_ai" );
	
	// if bookcase pushed over already, take cover behind it
	if( isdefined( original_pusher ) && isalive( original_pusher ) )
	{
		
		goal = getnode( "node_bookcase_goto_2", "targetname" );
		
		self setgoalnode( goal );
		
		self waittill( "goal" );
		
		self.goalradius = 60;		
		
	}
	// or if the pusher has been killed, push it over yourself
	else
	{
		self thread pub_bookcase_strat();
	}
	
}



///////////////////
//
// play anim of cafe wall crumbling
//
///////////////////////////////

cafe_wall_crumble()
{

	vnode = getvehiclenode( "auto3542", "targetname" );
	vnode waittill( "trigger" );
	
	waittillframeend;

	// animate all the wall pieces
	org_node = getNode("cafe_wall_node", "targetname");
	pieces = getEntArray("tank_wall", "targetname");
	
	for (i = 0; i < pieces.size; i++)
	{
		pieces[i] notsolid();
		pieces[i] connectpaths();
	}	
	
	getent( "delete_chunk","targetname" ) connectpaths();
	getent( "delete_chunk","targetname" ) delete();

	playfx(level._effect["tank_thru_cafe_wall"], org_node.origin + (0,0,54), anglestoforward(org_node.angles - (0,90,0)));
	//client notify for Kevins audio
	SetClientSysState("levelNotify","tank_wall_sound");
	level maps\_anim::anim_ents(pieces, "crumble", undefined, undefined, org_node, "cafe_wall");

	autosave_by_name( "Ber1 cafe crumble" );
	
	set_flags_on_street_triggers();
	
	level thread event2_split_squad();
	
	simple_floodspawn( "street_right_spawners_1" );
	
	// Wii optimizations
	if( !level.wii && !NumRemoteClients())
	{
		// start ambient drones
		drone_trig = getent( "street_drones_1", "script_noteworthy" );
		drone_trig notify( "trigger" );
	}
	
}



///////////////////
//
// sets some flags on triggers that can't be setup to use script_flag automatically through radiant
//
///////////////////////////////

set_flags_on_street_triggers()
{
	
	trig = getent( "chain_street_right_1", "targetname" );
	level thread set_flag_on_trigger( trig, "chain_street_right_1" );		

	trig = getent( "chain_street_left_1", "targetname" );
	level thread set_flag_on_trigger( trig, "chain_street_left_1" );		

	trig = getent( "trig_last_yard_floodspawners", "script_noteworthy" );
	level thread set_flag_on_trigger( trig, "last_yard_floodspawners" );		
	
}



///////////////////
//
// the wall between the street and yard that the panzershrek blows open
//
///////////////////////////////

panzershrek_hits_wall()
{
	
	trigger_wait( "trig_spawn_street_guys_late", "script_noteworthy" );

	panzershrek_2_spawn = getstruct( "ps2_spawn", "targetname" );
	low_wall = getstruct( "ps2_target", "targetname" );
	
	level thread fire_shrecks( panzershrek_2_spawn, low_wall, undefined, "rpg_impact_boom", 1 );
	//panzershrek_2_spawn playsound( "weap_pnzr_fire" );
	wait( 1 );
	
	playfx( level._effect["asylum_wall_explode"], low_wall.origin );
	playSoundAtPosition( "concrete_wall_explo", low_wall.origin );
	exploder( 103 );
	
	//wait randomfloatrange(1.5, 2);
	
	//thread fire_shrecks(panzershrek_2_spawn, gate, undefined, "iron_gate_explo", 1);
	//ps1_spawn playsound("weap_pnzr_fire");
	//wait 1;

	//gate_clip connectpaths();
	//waittillframeend;
	//gate_clip delete();
	
	//gate maps\ber1_anim::asylum_grounds_gate_open();
	
	//gate_clip2 solid();	
	
}



///////////////////
//
// split the squad to move through the asylum street and grounds simultaneously
//
///////////////////////////////

event2_split_squad()
{
	
	set_color_chain( "courtyard_squad_split" );	
	
	allies = getaiarray( "allies" );
	
	for (i = 0; i < allies.size; i++)
	{
		// if is an even number of the array
		if (i % 2 == 0)
		{
			allies[i] set_force_color("r");
		}
		else // odd
		{
			allies[i] set_force_color("c");
		}
	}
	
}



///////////////////
//
// piggybacking autosaves onto other triggers, to save entities
//
///////////////////////////////	

save_mid_yard()
{
	
	trigger_wait( "trig_save_mid_yard", "script_noteworthy" );
	
	autosave_by_name( "Ber1 mid yard" );
	
}



///////////////////
//
// piggybacking autosaves onto other triggers, to save entities
//
///////////////////////////////	

save_asylum_entry()
{
	
	trigger_wait( "trig_save_asylum_entry", "script_noteworthy" );
	
	autosave_by_name( "Ber1 asylum entry" );
	
}



///////////////////
//
// spawn these manually when the event starts, to save on entities at load time
//
///////////////////////////////

spawn_street_pickup_weapons()
{

	street_weapons = [];
	
	street_weapons[0] = spawnstruct();
	street_weapons[0].weapon_name = "weapon_panzerschrek";
	street_weapons[0].origin = (3169.9, 1566.6, -382.5);
	street_weapons[0].angles = (287.17, 355.56, -50.1497);

	street_weapons[1] = spawnstruct();
	street_weapons[1].weapon_name = "weapon_panzerschrek";
	street_weapons[1].origin = (3169.9, 1526.6, -382.5);
	street_weapons[1].angles = (287.17, 355.56, -50.1497);

	spawn_pickup_weapons( street_weapons );
	
}


