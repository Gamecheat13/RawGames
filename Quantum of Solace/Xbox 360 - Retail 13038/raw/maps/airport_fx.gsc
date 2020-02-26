// Airport effects file
// Builder: Brian Glines
// Scritper: Walter Williams
// Created: 10-08-2007
#include maps\_utility;

main()
{
				// setup the animations
				level fx_precache();

				// Register FX Events
				//registerFXTargetName("halon_on");
				registerFXTargetName("forklift1_smoking");
				registerFXTargetName("forklift2_smoking");
				registerFXTargetName("controlpanel_sparks1");
				registerFXTargetName("controlpanel_sparks2");
				registerFXTargetName("controlpanel_sparks3");
				registerFXTargetName("controlpanel_sparks4");
				registerFXTargetName("controlpanel_sparks5");
				registerFXTargetName("controlpanel_sparks6");
				registerFXTargetName("controlpanel_sparks7");
				registerFXTargetName("controlpanel_sparks8");

				//start animations
				initFXModelAnims();

				// Load all environmental entities:
				maps\createfx\airport_fx::main();

				//turning on the quick kill effects
				level thread maps\_fx::quick_kill_fx_on();
}

propane_tanks1()
{
				ptank01 = getent( "fxanim_catwalk02", "targetname" );	

				if (IsDefined(ptank01))
				{
//								playfxontag ( level._effect["airport_propane_fire"], ptank01, "catwalk02_propane01_joint" );
//								playfxontag ( level._effect["airport_propane_fire"], ptank01, "catwalk02_propane02_joint" );
//								playfxontag ( level._effect["airport_propane_fire"], ptank01, "catwalk02_propane03_joint" );
//								playfxontag ( level._effect["airport_propane_fire"], ptank01, "catwalk02_propane04_joint" );
				}
}

propane_tanks2()
{
				ptank01 = getent( "fxanim_exit_explode", "targetname" );	

				if (IsDefined(ptank01))
				{
//								playfxontag ( level._effect["airport_propane_fire"], ptank01, "propane_tank_01_jnt" );
//								playfxontag ( level._effect["airport_propane_fire"], ptank01, "propane_tank_02_jnt" );
				}
}

start_fxfunc( targetname, func, param )
{
				ent = getent( targetname, "targetname" );
				if ( IsDefined( ent ) )
				{
								if ( IsDefined( param ) )
								{
												ent thread [[func]]( param );
								}
								else
								{
												ent thread [[func]]();
								}
				}
}

initFXModelAnims()
{
				ent1 = getent( "fxanim_door_kick", "targetname" );
				ent2 = getent( "fxanim_catwalk02", "targetname" );
				ent3 = getent( "fxanim_exit_explode", "targetname" );
				ent6 = getent( "fxanim_chair_throw", "targetname" );
				// 06-12-08
				// wwilliams
				// had to define the fans under a script_noteworthy instead of a
				// targetname. this is because the streamers must link to the fan
				// in a prefab, but if the fans have a special targetname instead
				// of a generic targetname then script can't grab them properly
				ent_array7 = getentarray( "fxanim_airport_fan", "script_noteworthy" );

				if (IsDefined(ent1)) { ent1 thread door_kick();   println("************* door_kick ****************"); }
				if (IsDefined(ent2)) { ent2 thread anim_catwalk();   println("************* fxanim_catwalk02 ****************"); }
				if (IsDefined(ent3)) { ent3 thread exit_explode();   println("************* fxanim_exit_explode ****************"); }
				if (IsDefined(ent6)) { ent6 thread chair_throw();   println("************* fxanim_chair_throw ****************"); }
				// 06-12-08
				// wwilliams
				// fx fans double check definition of object
				if( isdefined( ent_array7 ) )
				{
								// thread the function on the array
								ent_array7 thread fx_airport_fans();

								// println
								println( "************* fxanim_airport_fan ****************" );

								// frame wait
								// wait( 0.05 );

				}


				start_fxfunc( "fxanim_luggage_flaps_1",		::luggage_flaps_animation,		"luggage_flaps_1_start" );
				start_fxfunc( "fxanim_luggage_flaps_2",		::luggage_flaps_animation,		"luggage_flaps_2_start" );
				start_fxfunc( "fxanim_luggage_flaps_3",		::luggage_flaps_animation,		"luggage_flaps_3_start" );
				start_fxfunc( "fxanim_luggage_flaps_4",		::luggage_flaps_animation,		"luggage_flaps_4_start" );
				start_fxfunc( "fxanim_luggage_flaps_5",		::luggage_flaps_animation,		"luggage_flaps_5_start" );
				start_fxfunc( "fxanim_luggage_flaps_6",		::luggage_flaps_animation,		"luggage_flaps_6_start" );
				start_fxfunc( "fxanim_luggage_flaps_7",		::luggage_flaps_animation,		"luggage_flaps_7_start" );
				start_fxfunc( "fxanim_luggage_flaps_8",		::luggage_flaps_animation,		"luggage_flaps_8_start" );
				start_fxfunc( "fxanim_luggage_flaps_9",		::luggage_flaps_animation,		"luggage_flaps_9_start" );
				start_fxfunc( "fxanim_luggage_flaps_10",		::luggage_flaps_animation,		"luggage_flaps_10_start" );
				start_fxfunc( "fxanim_luggage_flaps_11",		::luggage_flaps_animation,		"luggage_flaps_11_start" );
}

#using_animtree("fxanim_door_kick");
door_kick()
{
				level waittill("door_kick_start");
				self UseAnimTree(#animtree);
				self animscripted("a_door_kick", self.origin, self.angles, %fxanim_door_kick);
}

#using_animtree("fxanim_catwalk02");
anim_catwalk()
{
				level waittill("catwalk02_start");
				level.catwalk_invalid = true;
				self UseAnimTree(#animtree);
				self animscripted("a_catwalk", self.origin, self.angles, %fxanim_catwalk02);	
				level thread propane_tanks1(); //attaching fire effects on the tanks
}

#using_animtree("fxanim_exit_explode");
exit_explode()
{
				level waittill("exit_explode_start");
				self UseAnimTree(#animtree);
				self animscripted("a_exit_explode", self.origin, self.angles, %fxanim_exit_explode);
				level thread propane_tanks2(); //attaching fire effects on the tanks
}

#using_animtree("fxanim_chair_throw");
chair_throw()
{
				level waittill("chair_throw_start");
				self UseAnimTree(#animtree);
				self animscripted("a_chair_throw", self.origin, self.angles, %fxanim_chair_throw);
}

#using_animtree("fxanim_luggage_flaps");
luggage_flaps_animation( msg )
{
	while(true)
	{
		level waittill( msg );
		self UseAnimTree(#animtree);
		self animscripted("a_luggage_flaps", self.origin, self.angles, %fxanim_luggage_flaps);
		wait(0.5);
	}
}

// 06-12-08
// wwilliams
// adding the function that starts the animations on the fans in luggage
// runs on array
// fxanim
#using_animtree( "fxanim_airport_fan" );
fx_airport_fans()
{
				// wait for notify
				level waittill( "streamer_3_start" );

				// for loop goes through each array spot
				for( i=0; i<self.size; i++ )
				{
								self[i] UseAnimTree(#animtree);
								self[i] animscripted( "a_airport_fan", self[i].origin, self[i].angles, %fxanim_airport_fan );
				}

}

fx_precache()
{
				// sprinklers
				//level._effect[ "sprinkler1" ] 			= loadfx( "maps/MiamiAirport/airport_water_sprinkler_r" );
				level._effect[ "sprinkler1" ] 			= loadfx( "maps/MiamiAirport/airport_water_sprinkler_leak" );
				level._effect[ "sprinkler2" ] 			= loadfx( "maps/MiamiAirport/airport_water_sprinkler02" );
				//level._effect[ "sprinkler_walls" ] 	= loadfx( "maps/MiamiAirport/airport_water_walls01" );
				//level._effect[ "sprinkler_floor" ] 	= loadfx( "maps/MiamiAirport/airport_water_floor01" );
				level._effect[ "sprinkler_splash" ] 	= loadfx( "maps/MiamiAirport/airport_water_splash1" );
				level._effect[ "airport_forklift_smoke" ] 	= loadfx( "maps/MiamiAirport/airport_forklift_smoke" );
				level._effect[ "airport_vol_light03" ] 		= loadfx( "maps/MiamiAirport/airport_vol_light03" );
				level._effect[ "airport_vol_light04" ] 		= loadfx( "maps/MiamiAirport/airport_vol_light04" );
				level._effect[ "airport_vol_light05" ] 		= loadfx( "maps/MiamiAirport/airport_vol_light05" );
				level._effect[ "airport_desklight_vol1" ] 	= loadfx( "maps/MiamiAirport/airport_desklight_vol1" );
				level._effect[ "airport_desklight_vol2" ] 	= loadfx( "maps/MiamiAirport/airport_desklight_vol2" );
				level._effect[ "airport_panel_sparks" ] 	= loadfx( "maps/MiamiAirport/airport_panel_sparks" );
				level._effect[ "airport_emergency_light" ] 	= loadfx( "maps/MiamiAirport/airport_emergency_light" );
				level._effect[ "airport_moonlight01" ] 		= loadfx( "maps/MiamiAirport/airport_moonlight01" );
				level._effect[ "airport_moonlight02" ] 		= loadfx( "maps/MiamiAirport/airport_moonlight02" );
				level._effect[ "airport_moonlight03" ] 		= loadfx( "maps/MiamiAirport/airport_moonlight03" );
				level._effect[ "airport_moonlight04" ] 		= loadfx( "maps/MiamiAirport/airport_moonlight04" );
				level._effect[ "airport_propane_fire" ] 	= loadfx( "maps/MiamiAirport/airport_propane_fire2" );

				level._effect[ "end_explosion" ] 	= loadfx( "maps/MiamiAirport/airport_final_explosion" );

				// halon effect
				level._effect[ "halon_gas" ] = loadfx( "maps/MiamiAirport/airport_halon01" );

				level._effect[ "van_exhaust" ] = loadfx( "maps/MiamiAirport/airport_vehicle_exhaust01" );

				// awareness for hack spots
				// level._effect[ "hack_comp_one" ] = loadfx( "misc/action_awareness" );
				// level._effect[ "hack_comp_two" ] = loadfx( "misc/action_awareness2" );
				// level._effect[ "hack_comp_three" ] = loadfx( "misc/action_awareness3" );
				// level._effect[ "hack_comp_four" ] = loadfx( "misc/action_awareness4" );

				// malfunction spark
				//level._effect[ "electric_spark" ] = loadfx( "maps/MiamiConcourse/concourse_malfunc_spark" );
				level._effect[ "server_spark" ] = loadfx( "maps/MiamiConcourse/airport_malfunc_spark" );
				// level._effect[ "dmg_smoke" ] = loadfx( "impact/small_metalhit" );

				// tracer fire
				//level._effect[ "tracer_round" ] = loadfx( "misc/20mm_tracer" );

				// explosion for forklift
				level._effect[ "f_explosion" ] = loadfx( "props/welding_exp" );

				// heli light
				level._effect["science_lightbeam05"] = loadfx( "maps/miamisciencecenter/science_copter_searchlite" );

				// 04-07-08
				// wwilliams
				// adding the temp smoke effect
				level._effect["pillar_smoke"] = loadfx( "smoke/car_damage_blacksmoke" );

				// 06-19-08
				// wwilliams
				// light needed for the garage door
				level._effect["garage_yellow"] =loadfx( "misc/door_lock_yellow" );

				//test prop destruction effect
				//level._effect[ "airport_paper_stack" ] = loadfx( "maps/MiamiAirport/airport_paper_stack" );
}
