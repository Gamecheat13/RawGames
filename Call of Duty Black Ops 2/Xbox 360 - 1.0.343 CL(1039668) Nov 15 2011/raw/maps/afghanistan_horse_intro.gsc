/*
	
	PUT NEED TO KNOW EVENT INFO UP HERE

*/
#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_vehicle;
#include maps\_objectives;
#include maps\_dialog;
#include maps\_horse;

/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//
//	Declare event-specific flags here
init_flags()
{
//	flag_init( "event_flag" );
	flag_init("zhao_got_to_base");
	flag_init("woods_got_to_base");
	
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
//	add_spawn_function( "intro_drone", ::intro_drone );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions	(you may have more than one skipto in this file)
-------------------------------------------------------------------------------------------*/

//
//	This is run before your main function is executed.  Put any skipto-only initialization here.
skipto_intro()
{
//	init_hero( "hero_name_here" );

//	start_teleport( "skipto_structname_here" );
	level.player_horse = getent("player_horse_2", "targetname");
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
	// Temp Development info
	/#
		IPrintLn( "Horse Ride tutorial" );
	#/
	// Initialization

	// Additional event logic   
	level thread too_far_fail_managment();
	level thread e2_objective();
	level thread setup_tank();
	level.player_horse thread wait_until_player_on_horse();
	//level thread run_scene_first_frame("e2_base_activity_generic");
	level thread start_vulture_shooting_event();
	level thread start_sprinting_tutorial();
	flag_wait("zhao_got_to_base");
	flag_wait("woods_got_to_base");
}
e2_objective()
{
	set_objective( level.OBJ_AFGHAN_BC2, undefined, "done" );

	//iprintlnbold( "Get on your horse and follow Zhao");
	add_temp_dialog_line("Zhao", "Come on Keep up with me.");
	
	set_objective( level.OBJ_AFGHAN_BC3, level.player_horse, "use");
		
}

wait_until_player_on_horse()
{
	e2_spline = GetVehicleNode("e2_temp_horse_spline", "targetname");
	level.woods enter_vehicle(level.wood_horse);
 	self waittill( "enter_vehicle", player );
 	set_objective( level.OBJ_AFGHAN_BC3, level.zhao_horse, "follow");
 	//level.zhao_horse set_goalradius(64);
 	level.zhao_horse SetNearGoalNotifyDist( 64 );
 	level.zhao_horse.dontunloadonend = true;
	level.zhao_horse thread go_path(e2_spline);
	
	//wait(2);
	//level.wood_horse set_goalradius(64);
	level.wood_horse SetNearGoalNotifyDist( 64 );
	level.wood_horse.dontunloadonend = true;
	//level.wood_horse PathFixedOffset( (100, 45, 0) );
	level.wood_horse thread go_path( GetVehicleNode("e2_woods_horse_spline", "targetname") );
	
	trigger_wait("wood_zhao_wait_canyon_wait_trigger");
	
	level thread canyon_fog_settings();
	
	level.wood_horse thread go_to_vulture();
	level.zhao_horse thread go_to_vulture();
	
	set_objective( level.OBJ_AFGHAN_BC3, undefined, "done");

	//level waittill("stop_this");
	

}
go_to_vulture()
{
	
	zhao_vulture_struct = getstruct("zhao_vulture_stop", "targetname");
	woods_vulture_struct = getstruct("woods_vulture_stop", "targetname");
	
	wait(2);
	
	self ClearVehGoalPos();
	
	//self SetBrake( false );
	
	//self SetSpeedImmediate( 0 );
	
	if(self == level.zhao_horse)
	{
		self SetSpeed( 25, 15, 10 );
		self setvehgoalpos(zhao_vulture_struct.origin, 0, 1);
		self waittill_any( "goal", "near_goal" );
		self SetBrake( true );
	
		
	}
	else
	{
		self SetSpeed( 25, 15, 10 );
		self setvehgoalpos( woods_vulture_struct.origin, 0, 1);
		self waittill_any( "goal", "near_goal" );
		self SetBrake( true );
	}
	
	
	//wait(1);
	//self delete();	
}

start_vulture_shooting_event()
{

	trigger_wait("vulture_spawning_trigger");
	autosave_by_name("e2_vulture_event");
	
	level.zhao.ignoreall = true;
	level.woods.ignoreall = true;
	
	level thread start_vulture_tutorial();
	level thread scatter_vulture();
	//spawner = getent("vulture_spawner", "targetname");
	
	level thread setup_vultures();
	//run_scene("vulture_test");
	
	level.vultures_alive = 3;
	
	vulture_start = getstructarray("vulture_starting_struct", "targetname");

	level.vulture[0] thread setup_vulture(vulture_start[0]);
	level.vulture[0] thread check_for_vulture_death();
	level.vulture[1] thread setup_vulture(vulture_start[1]);
	level.vulture[1] thread check_for_vulture_death();
	level.vulture[2] thread setup_vulture(vulture_start[2]);
	level.vulture[2] thread check_for_vulture_death();
	
	
	while(level.vultures_alive > 0)
	{
		//level.vulture = array_removedead(level.vulture);
		wait(1);
	}
	
	
	level notify("vulture_event_over");
	
	level thread arena_fog_settings();
	
	level.zhao.ignoreall = false;
	level.woods.ignoreall = false;
	
	level.zhao_horse thread go_to_rebel_base();
	level.wood_horse thread go_to_rebel_base();
}

start_vulture_tutorial()
{
	level endon("kill_vulture_tutorial");
	
	//level.wood_horse.disable_mount_anim = true;
	//level.zhao_horse.disable_mount_anim = true;
	
	//level.zhao notify("stop_riding");
	//level.woods notify("stop_riding");
	
	wait(2);
	add_temp_dialog_line("Zhao", "Have you ever fired a gun on a horse? Mason.");
	wait(3);
	
	level.zhao maps\_horse_rider::ai_ride_stop_riding();
	level.woods maps\_horse_rider::ai_ride_stop_riding();
	
	//level.wood_horse vehicle_unload(0);
	//level.zhao_horse vehicle_unload(0);
	
	level thread run_scene("e1_s5_vulture_shoot_zhao");
	level thread run_scene("e1_s5_vulture_shoot_woods");
	
	add_temp_dialog_line("Zhao", "There are some vultures on that rusty tank, give it a go.");

	level.scene_sys waittill("e1_s5_vulture_shoot_zhao_done");
	
	level.zhao  maps\_horse_rider::ride_and_shoot( level.zhao_horse );
	level.woods maps\_horse_rider::ride_and_shoot( level.wood_horse );
}
setup_vulture(start)
{
	self endon("death");
	
	end_struct = getstruct(start.target, "targetname");
	self.origin = start.origin;
	self.angles = start.angles;
	//self forceteleport(start.origin, start.angles);
	self.linked_to = spawn("script_model", start.origin);
	self.linked_to setmodel("tag_origin");
	self linkto( self.linked_to );
	level.player_horse waittill("weapon_fired");
	self.flight = true;
	self notify("flying");
	self.linked_to moveto(end_struct.origin, 25);
	wait(15);
	//iprintlnbold("Zhao: You missed one");
	level notify( "vulture_flew_away" );
	add_temp_dialog_line("Zhao", "a little too slow, you missed.");
	level.vultures_alive -= 1;
	
	self notify("deleted");
	self delete();
}
check_for_vulture_death()
{
	self endon("deleted");
	self waittill("death");
	add_temp_dialog_line("Zhao", "An excellent shot, you are a natural.");
	
}
scatter_vulture()
{
	level.player_horse endon("weapon_fired");
	trigger_wait("vulture_flyoff_trigger");
	level.player_horse notify("weapon_fired");

}

start_sprinting_tutorial()
{
	trigger_wait("zhao_horse_sprint_trigger");
	
	level thread run_scene("e2_base_activity_generic");
	
	add_temp_dialog_line("Zhao", "We wasted too much time already, the attack will start soon.");
	wait(3);
	add_temp_dialog_line("Zhao", "Let's hurry.");
	wait(1);
	
	level thread sprint_message();
	
	level thread rebel_entrance_fog_settings();
	
	trigger_wait("player_in_rebel_base_trigger");
	//screen_message_delete();
	level thread rebel_camp_fog_settings();
}

sprint_message()
{
	
	screen_message_create(&"AFGHANISTAN_SPRINT");
	sprint_timer = 10.0;
	
	while( !(level.player SprintButtonPressed()) && sprint_timer > 0)
	{
		sprint_timer -= 0.05;
		wait 0.05;
	}
	
	screen_message_delete();
}

go_to_rebel_base()
{
	self ClearVehGoalPos();
	
	self SetBrake( false );
	
	//self SetSpeedImmediate( 0 );
	if(self == level.zhao_horse)
	{
		level.zhao_horse SetNearGoalNotifyDist( 64 );
		self SetSpeed( 25, 15, 10 );
		self setvehgoalpos( (6040, -7152, 112), 1, 0);
		self waittill( "near_goal" );
		self setvehgoalpos( (9720, -9464, 40), 1);
		self waittill( "near_goal" );
		self setvehgoalpos( (12856, -9520, -112), 1);
		self waittill( "near_goal" );
		self setvehgoalpos( (13560, -10104, -88), 1);
		self waittill( "near_goal" );
		self setvehgoalpos( (14872, -10184, -96), 1);
		self waittill( "near_goal" );
		self SetBrake( true );
		
		level.zhao notify("stop_riding");
		self vehicle_unload(0.05);
		self waittill("unloaded");
		
		flag_set("zhao_got_to_base");
	}
	else
	{
		level.wood_horse SetNearGoalNotifyDist( 64 );
		self SetSpeed( 25, 15, 10 );
		self setvehgoalpos( (6100, -7052, 112), 1, 1);
		self waittill( "near_goal" );
		self setvehgoalpos( (9620, -9564, 40), 1);
		self waittill( "near_goal" );
		self setvehgoalpos( (12856, -9520, -112), 1);
		self waittill( "near_goal" );
		self setvehgoalpos( (13560, -10104, -88), 1);
		self waittill( "near_goal" );
		self setvehgoalpos( (14752, -10184, -96), 1);
		self waittill( "near_goal" );
		self SetBrake( true );
		
		level.woods notify("stop_riding");
		
		self vehicle_unload(0.05);
		
		self waittill("unloaded");
		
		flag_set("woods_got_to_base");
	}
		
}

setup_tank()
{
	
	trigger_wait("setup_tank_base_intro");
	level.muj_tank = spawn_vehicle_from_Targetname("muj_tank");
	tank_starting = GetVehicleNode("ally_tank_start_node", "targetname");
	level.muj_tank go_path(tank_starting);
	
}

too_far_fail_managment()
{
	trigger_endon = GetEnt("player_in_rebel_base_trigger", "targetname");
	trigger_endon endon("trigger");
	
	trigger_array = GetEntArray("player_too_far_trigger", "targetname");
	
	for(i = 0; i < trigger_array.size; i++)
	{
		trigger_array[i] thread touching_fail_trigger();
	}
}

touching_fail_trigger()
{
	trigger_endon = GetEnt("player_in_rebel_base_trigger", "targetname");
	trigger_endon endon("trigger");
	
	durration = 10;
	
	while(durration > 0)
	{
		
		if( level.player IsTouching(self) )
		{
			durration -= 1;
		}
		else
		{
			durration = 10;
		}
		
		if( ( durration % 3 == 0 ) )
		{
			add_temp_dialog_line("Zhao", "Mason get back tot he base");
		}
		
		wait 1;
	}
	
	MissionFailed();
}

#using_animtree( "critter" );
setup_vultures()
{
//	vultures = [];
//	for(i = 0; i < 3; i++)
//	{
//		vultures[i] = GetEnt("vulture" + i+1, "targetname");
//		
//		if(!isDefined(vultures[i]))
//		{
//			iprintlnbold("not defined");
//		}
//		
//		//vultures[i] useanimtree(#animtree);
//	}
	level.vultures = [];
	level.vulture[0] = GetEnt("vulture1", "targetname");
	level.vulture[1] = GetEnt("vulture2", "targetname");
	level.vulture[2] = GetEnt("vulture3", "targetname");

	for(i = 0; i < 3; i++)
	{
		level.vulture[i] useanimtree(#animtree);
		level.vulture[i].flight = false;
		level.vulture[i] EnableAimAssist();
		level.vulture[i] thread vulture_anim_loop_ground();
		level.vulture[i] thread vulture_anim_loop_air();
		level.vulture[i] thread vulture_anim_death( i + 1 );
	}
}

vulture_anim_loop_ground()
{
	self endon("deleted");
	self endon("death");
	self endon("flying");
	
	
	self SetCanDamage(true);
	self.health = 99999;
	
	//self waittill( "damage" );
	
	while(1)
	{
		rand = RandomInt(100);
		
		self clearanim(%root, 0.0);
		
		if(rand < 70)
		{
			self setanim( %critter::a_vulture_idle, 1, 0, 1);
			anim_durration = getanimlength(%critter::a_vulture_idle);
		}
		else
		{
			self setanim( %critter::a_vulture_idle_twitch , 1, 0, 1);
			anim_durration = getanimlength(%critter::a_vulture_idle_twitch);
		}	
		wait anim_durration;
	}
}

vulture_anim_loop_air()
{
	self endon("deleted");
	self endon("death");
	
	self waittill("flying");
	
	while(1)
	{	
		self clearanim(%root, 0.0);

		self setanim( %critter::a_vulture_fly, 1, 0, 1);
		anim_durration = getanimlength(%critter::a_vulture_fly);
		
		wait anim_durration;
	}
}

vulture_anim_death( index )
{
	self endon("deleted");	
	self waittill( "damage" );
	
	self notify("death");
	
	self clearanim(%root, 0.0);
	
	rand = RandomInt(100);
	
	if(self.flight)
	{
		
		self thread handle_vulture_falling_death();
		
		while( self.linked_to.origin[2] > 35 )
		{
			self.linked_to.origin -= (0,0,10);
			wait 0.05;
		}
		
		self notify("hit_the_ground");
		
		self setanim( %critter::a_vulture_death_hitground_a , 1, 0, 1);
		anim_durration = getanimlength(%critter::a_vulture_death_hitground_a);
		wait anim_durration;
	}
	else
	{
	
		if(rand < 25)
		{
			self setanim( %critter::a_vulture_death_from_idle , 1, 0, 1);
			anim_durration = getanimlength(%critter::a_vulture_death_from_idle);
		}
		else if(rand < 50)
		{
			self setanim( %critter::a_vulture_death_from_idle_a , 1, 0, 1);
			anim_durration = getanimlength(%critter::a_vulture_death_from_idle_a);
		}
		else if(rand < 75)
		{
			self setanim( %critter::a_vulture_death_from_idle_b , 1, 0, 1);
			anim_durration = getanimlength(%critter::a_vulture_death_from_idle_b);
		}
		else
		{
			self setanim( %critter::a_vulture_death_from_idle_c , 1, 0, 1);
			anim_durration = getanimlength(%critter::a_vulture_death_from_idle_c);
		}
		
		wait anim_durration;
	}
	level.vultures_alive -= 1;
	self Delete();
}

handle_vulture_falling_death()
{
	self endon("hit_the_ground");
	self endon("deleted");	
	
	self setanim( %critter::a_vulture_death_from_flight_a , 1, 0, 1);
	anim_durration = getanimlength(%critter::a_vulture_death_from_flight_a);
	wait anim_durration;
	
	while(1)
	{
		self setanim( %critter::a_vulture_death_fall_loop_a , 1, 0, 1);
		anim_durration = getanimlength(%critter::a_vulture_death_fall_loop_a);
		wait anim_durration;
	}
}
/* ------------------------------------------------------------------------------------------
	SUPPORT functions
-------------------------------------------------------------------------------------------*/

// Everything else goes here
