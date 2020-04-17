



#include maps\_utility;

main()
{
				
				level fx_precache();

				
				
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

				
				initFXModelAnims();

				
				maps\createfx\airport_fx::main();

				
				level thread maps\_fx::quick_kill_fx_on();
}

propane_tanks1()
{
				ptank01 = getent( "fxanim_catwalk02", "targetname" );	

				if (IsDefined(ptank01))
				{




				}
}

propane_tanks2()
{
				ptank01 = getent( "fxanim_exit_explode", "targetname" );	

				if (IsDefined(ptank01))
				{


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
				
				
				
				
				
				
				
				

				if (IsDefined(ent1)) { ent1 thread door_kick();   println("************* door_kick ****************"); }
				if (IsDefined(ent2)) { ent2 thread anim_catwalk();   println("************* fxanim_catwalk02 ****************"); }
				if (IsDefined(ent3)) { ent3 thread exit_explode();   println("************* fxanim_exit_explode ****************"); }
				
				
				
				
				


	
	
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
				catwalk_coll = GetEnt("catwalk02_collision", "targetname");
				catwalk_coll delete();
				level.catwalk_invalid = true;
				self UseAnimTree(#animtree);
				self animscripted("a_catwalk", self.origin, self.angles, %fxanim_catwalk02);	
				level thread propane_tanks1(); 
}

#using_animtree("fxanim_exit_explode");
exit_explode()
{
				level waittill("exit_explode_start");
				self UseAnimTree(#animtree);
				self animscripted("a_exit_explode", self.origin, self.angles, %fxanim_exit_explode);
				level thread propane_tanks2(); 
}














fx_precache()
{
	
	level._effect[ "sprinkler1" ] 			= loadfx( "maps/MiamiAirport/airport_water_sprinkler02" );
				level._effect[ "sprinkler2" ] 			= loadfx( "maps/MiamiAirport/airport_water_sprinkler02" );
				
				
				level._effect[ "sprinkler_splash" ] 	= loadfx( "maps/MiamiAirport/airport_water_splash1" );
				level._effect[ "airport_forklift_smoke" ] 	= loadfx( "maps/MiamiAirport/airport_forklift_smoke" );
				level._effect[ "airport_vol_light03" ] 		= loadfx( "maps/MiamiAirport/airport_vol_light03" );
				level._effect[ "airport_vol_light04" ] 		= loadfx( "maps/MiamiAirport/airport_vol_light04" );
				level._effect[ "airport_vol_light05" ] 		= loadfx( "maps/MiamiAirport/airport_vol_light05" );
				level._effect[ "airport_desklight_vol1" ] 	= loadfx( "maps/MiamiAirport/airport_desklight_vol1" );
				level._effect[ "airport_desklight_vol2" ] 	= loadfx( "maps/MiamiAirport/airport_desklight_vol2" );
				level._effect[ "airport_panel_sparks" ] 	= loadfx( "maps/MiamiAirport/airport_panel_sparks" );
				level._effect[ "airport_emergency_light" ] 	= loadfx( "maps/MiamiAirport/airport_emergency_light" );
				
				level._effect[ "airport_moonlight02" ] 		= loadfx( "maps/MiamiAirport/airport_moonlight02" );
				level._effect[ "airport_moonlight03" ] 		= loadfx( "maps/MiamiAirport/airport_moonlight03" );
				
				

				level._effect[ "end_explosion" ] 	= loadfx( "maps/MiamiAirport/airport_final_explosion" );

				
				level._effect[ "halon_gas" ] = loadfx( "maps/MiamiAirport/airport_halon01" );

				

				
				
				
				
				

				
				
				level._effect[ "server_spark" ] = loadfx( "maps/MiamiConcourse/airport_malfunc_spark" );
				

				
				

				
				level._effect[ "f_explosion" ] = loadfx( "props/welding_exp" );

				
				level._effect["science_lightbeam05"] = loadfx( "maps/miamisciencecenter/science_copter_searchlite" );

				
				
				
				level._effect["pillar_smoke"] = loadfx( "smoke/car_damage_blacksmoke" );

				
				
				
				level._effect["garage_yellow"] =loadfx( "misc/light_solid_yellow" );

				
				
}
