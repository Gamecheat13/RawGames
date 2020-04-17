#include maps\_utility;


main()
{

	initFXModelAnims();

	precacheFX();
	
	// Register FX Events
	registerFXTargetName("fx_pipe_1_on");
	registerFXTargetName("fx_pipe_2_on");
	registerFXTargetName("fx_pipe_3_on");
	registerFXTargetName("fx_deck_fire_on");
	registerFXTargetName("fx_door_explosion");
	registerFXTargetName("fx_fog_on"); //this is not used yet but it will be soon
	registerFXTargetName("fx_overload_sparks");
	
	registerFXTargetName("fx_enginefire_on");
	
	// Load all environmental entities:
	maps\createfx\barge_fx::main();
	
	//animate the lighthouse light
	level thread wait_start_lighthouse();
	
	//setting the fog 
//	setExpFog(0.0, 5000, 0.13, 0.18, 0.21, 0);
	
	//turning on the quick kill effects
	level thread maps\_fx::quick_kill_fx_on();
}

initFXModelAnims()
{
	ent1 = getent( "fxanim_door_blast", "targetname" );
	ent2 = getent( "fxanim_ramp_explode", "targetname" );
	ent3 = getent( "fxanim_flash_door", "targetname" );
	ent4 = getent( "fxanim_cargo_drop_container", "targetname" );
	ent5 = getent( "fxanim_cargo_drop_inards", "targetname" );
	ent6 = getent( "fxanim_cargo_drop_fence", "targetname" );
	ent7 = getent( "fxanim_cargo_drop_glass", "targetname" );
	//ent8 = getent( "fxanim_door_bash", "targetname" );
	ent9 = getent( "fxanim_vents_break", "targetname" );
	ent10 = getent( "fxanim_spark_wires", "targetname" );
	ent_array1 = getentarray( "fxanim_bg_trash_pile", "targetname" );
	ent_array2 = getentarray( "fxanim_bg_trash_1", "targetname" );
	ent_array3 = getentarray( "fxanim_bg_trash_2", "targetname" );
	ent_array4 = getentarray( "fxanim_bg_trash_3", "targetname" );
	ent_array5 = getentarray( "fxanim_bg_trash_4", "targetname" );
	ent_array6 = getentarray( "fxanim_bg_trash_5", "targetname" );
	ent_array7 = getentarray( "fxanim_bg_cup_1", "targetname" );
	ent_array8 = getentarray( "fxanim_bg_cup_2", "targetname" );
	
	if (IsDefined(ent1)) { ent1 thread door_blast();   println("************* FX: door_blast *************"); }
	if (IsDefined(ent2)) { ent2 thread ramp_explode();   println("************* FX: ramp_explode *************"); }
	if (IsDefined(ent3)) { ent3 thread flash_door();   println("************* FX: flash_door *************"); }
	if (IsDefined(ent4)) { ent4 thread cargo_drop_container();   println("************* FX: cargo_drop_container *************"); }
	if (IsDefined(ent5)) { ent5 thread cargo_drop_inards();   println("************* FX: cargo_drop_inards *************"); }
	if (IsDefined(ent6)) { ent6 thread cargo_drop_fence();   println("************* FX: cargo_drop_fence *************"); }
	if (IsDefined(ent7)) { ent7 thread cargo_drop_glass();   println("************* FX: cargo_drop_glass *************"); }
	//if (IsDefined(ent8)) { ent8 thread door_bash_01();   println("************* FX: door_bash_01 *************"); }
	if (IsDefined(ent9)) { ent9 thread vents_break();   println("************* FX: vents_break *************"); }
	if (IsDefined(ent10)) { ent10 thread spark_wires();   println("************* FX: spark_wires *************"); }
	if (IsDefined(ent_array1)) { ent_array1 thread bg_trash_pile();   println("************* FX: bg_trash_pile *************"); }
	if (IsDefined(ent_array2)) { ent_array2 thread bg_trash_1();   println("************* FX: bg_trash_1 *************"); }
	if (IsDefined(ent_array3)) { ent_array3 thread bg_trash_2();   println("************* FX: bg_trash_2 *************"); }
	if (IsDefined(ent_array4)) { ent_array4 thread bg_trash_3();   println("************* FX: bg_trash_3 *************"); }
	if (IsDefined(ent_array5)) { ent_array5 thread bg_trash_4();   println("************* FX: bg_trash_4 *************"); }
	if (IsDefined(ent_array6)) { ent_array6 thread bg_trash_5();   println("************* FX: bg_trash_5 *************"); }
	if (IsDefined(ent_array7)) { ent_array7 thread bg_cup_1();   println("************* FX: bg_cup_1 *************"); }
	if (IsDefined(ent_array8)) { ent_array8 thread bg_cup_2();   println("************* FX: bg_cup_2 *************"); }




	
}

wait_start_lighthouse()
{
	level waittill("lighthouse_start");
	level rotate_effect("fxlighthouse", (-5699.87, -8566.82, 3504), (0,0,0), 12);
}

#using_animtree("fxanim_door_blast");
door_blast()
{
	level waittill("door_blast_start");
	level notify("fx_door_explosion");
	self UseAnimTree(#animtree);
	self animscripted("a_door_blast", self.origin, self.angles, %fxanim_door_blast);
}

#using_animtree("fxanim_ramp_explode");
ramp_explode()
{
	level waittill("ramp_explode_start");
	self UseAnimTree(#animtree);
	self animscripted("a_ramp_explode", self.origin, self.angles, %fxanim_ramp_explode);
}

#using_animtree("fxanim_flash_door");
flash_door()
{
	level waittill("flash_door_start");
	self UseAnimTree(#animtree);
	self animscripted("a_flash_door", self.origin, self.angles, %fxanim_flash_door);
}

#using_animtree("fxanim_cargo_drop_container");
cargo_drop_container()
{
	level waittill("cargo_drop_container_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cargo_drop_container", self.origin, self.angles, %fxanim_cargo_drop_container);
	wait(2);
	level notify("fx_cargo_dust");
	//wait(11);
	//cargo_drop_container_slip();
}
/*
#using_animtree("fxanim_cargo_drop_container_slip");
cargo_drop_container_slip()
{
	level waittill("cargo_drop_container_slip_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cargo_drop_container_slip", self.origin, self.angles, %fxanim_cargo_drop_container_slip);
}
*/
#using_animtree("fxanim_cargo_drop_inards");
cargo_drop_inards()
{
	level waittill("cargo_drop_inards_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cargo_drop_inards", self.origin, self.angles, %fxanim_cargo_drop_inards);
	//wait(13);
	//cargo_drop_inards_slip();
}
/*
#using_animtree("fxanim_cargo_drop_inards_slip");
cargo_drop_inards_slip()
{
	level waittill("cargo_drop_inards_slip_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cargo_drop_inards_slip", self.origin, self.angles, %fxanim_cargo_drop_inards_slip);
}
*/
#using_animtree("fxanim_cargo_drop_fence");
cargo_drop_fence()
{
	level waittill("cargo_drop_fence_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cargo_drop_fence", self.origin, self.angles, %fxanim_cargo_drop_fence);
	//wait(13);
	//cargo_drop_fence_slip();
}
/*
#using_animtree("fxanim_cargo_drop_fence_slip");
cargo_drop_fence_slip()
{
	level waittill("cargo_drop_fence_slip_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cargo_drop_fence_slip", self.origin, self.angles, %fxanim_cargo_drop_fence_slip);
}
*/
#using_animtree("fxanim_cargo_drop_glass");
cargo_drop_glass()
{
	level waittill("cargo_drop_glass_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cargo_drop_glass", self.origin, self.angles, %fxanim_cargo_drop_glass);
}
/*
#using_animtree("fxanim_door_bash_01");
door_bash_01()
{
	level waittill("door_bash_01_start");
	self UseAnimTree(#animtree);
	self animscripted("a_door_bash_01", self.origin, self.angles, %fxanim_door_bash_01);
	wait(3.87);
	door_bash_02();
}

#using_animtree("fxanim_door_bash_02");
door_bash_02()
{
	level waittill("door_bash_02_start");
	self UseAnimTree(#animtree);
	self animscripted("a_door_bash_02", self.origin, self.angles, %fxanim_door_bash_02);
}
*/
//animate the lighthouse light
rotate_effect(effect, start_origin, start_angle, anim_time)
{
	//println("************* FX: animation started! *************");
	
	ent_tag = undefined;
	ent_tag = Spawn("script_model", start_origin);
	ent_tag SetModel("tag_origin");
	ent_tag.angles = start_angle;
		
	PlayFxOnTag(level._effect[effect], ent_tag, "tag_origin");
	//ent_tag moveto( end_origin, anim_time );
	
	while (IsDefined(effect))
	{
		ent_tag rotatevelocity( ( 0,-70,0 ), anim_time );	       
		wait anim_time;
	}
}

#using_animtree("fxanim_bg_trash_pile");
bg_trash_pile()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_bg_trash_pile", self[i].origin, self[i].angles, %fxanim_bg_trash_pile);
	}
}

#using_animtree("fxanim_bg_trash_1");
bg_trash_1()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_bg_trash_1", self[i].origin, self[i].angles, %fxanim_bg_trash_1);
	}
}

#using_animtree("fxanim_bg_trash_2");
bg_trash_2()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_bg_trash_2", self[i].origin, self[i].angles, %fxanim_bg_trash_2);
	}
}

#using_animtree("fxanim_bg_trash_3");
bg_trash_3()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_bg_trash_3", self[i].origin, self[i].angles, %fxanim_bg_trash_3);
	}
}

#using_animtree("fxanim_bg_trash_4");
bg_trash_4()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_bg_trash_4", self[i].origin, self[i].angles, %fxanim_bg_trash_4);
	}
}

#using_animtree("fxanim_bg_trash_5");
bg_trash_5()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_bg_trash_5", self[i].origin, self[i].angles, %fxanim_bg_trash_5);
	}
}

#using_animtree("fxanim_bg_cup_1");
bg_cup_1()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_bg_cup_1", self[i].origin, self[i].angles, %fxanim_bg_cup_1);
	}
}

#using_animtree("fxanim_bg_cup_2");
bg_cup_2()
{
	level waittill("bg_cup_start");
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_bg_cup_2", self[i].origin, self[i].angles, %fxanim_bg_cup_2);
	}
}

#using_animtree("fxanim_vents_break");
vents_break()
{
	level waittill("vents_break_start");
	self UseAnimTree(#animtree);
	self animscripted("a_vents_break", self.origin, self.angles, %fxanim_vents_break);
}

#using_animtree("fxanim_spark_wires");
spark_wires()
{
	level waittill("door_blast_start");
	self UseAnimTree(#animtree);
	self animscripted("a_spark_wires", self.origin, self.angles, %fxanim_spark_wires);
	//adding sparks to the wire tips

	self thread link_effect_to_ent("a_spark_wires", "wire_1_spark", "barge_electric_spark3", "wire1_07_jnt", (0,0,0), (0,180,90) );
	self thread link_effect_to_ent("a_spark_wires", "wire_2_spark", "barge_electric_spark3", "wire2_08_jnt", (0,0,0), (0,180,90));
	self thread link_effect_to_ent("a_spark_wires", "wire_3_spark", "barge_electric_spark3", "wire3_07_jnt", (0,0,0), (0,180,90));
}

link_effect_to_ent( animName, noteName, effectID, bone, offset, angle )
{
	ent_tag = Spawn( "script_model", self.origin );
	ent_tag SetModel( "tag_origin" );
	ent_tag.angles = self.angles;
	ent_tag LinkTo( self, bone, offset, angle );

	while (IsDefined(self))
	{
		self waittillmatch(animName, noteName);
		PlayFxOnTag( level._effect[effectID], ent_tag, "tag_origin" );
	}
	ent_tag delete();
}

//
//=============bbekian optimization pass 05/21/08 :: all opti passes are marked with --> 05/21opti
//=============bbekian optimization pass 06/22/08 :: all opti passes are marked with --> 06/22opti


precacheFX()
{
	//bbekian
	//
	level._effect["default_explosion"]  = loadfx ("maps/barge/barge_explosion_tanks");	
	level._effect["barge_room_dust"]	 = loadfx ("maps/barge/barge_room_dust");	
	level._effect["ceiling_smoke01"]    = loadfx ( "maps/barge/barge_ceiling_smoke01" );	
	//level._effect["ceiling_smoke02"]    = loadfx ( "maps/barge/barge_ceiling_smoke02" );
	
//	level._effect["debris_falling01"]   = loadfx ( "maps/barge/barge_debris_falling01" );  //05/21opti
	
	
	//level._effect["exp_extinguisher"]   = loadfx ( "maps/barge/barge_exp_extinguisher" );  //05/21opti
	level._effect["exp_fireext_haze"]   = loadfx ( "maps/barge/barge_exp_fireext_haze" );  //05/21opti
	
	
	//level._effect["exp_generator01"]    = loadfx ( "maps/barge/barge_exp_generator01" ); //CG - not used


	//level._effect["fuelroom_fire01"]    = loadfx ( "maps/barge/barge_fuelroom_fire01" ); //CG - not used
	//level._effect["fuelroom_fire02"]    = loadfx ( "maps/barge/barge_fuelroom_fire01" ); //CG - not used
	//level._effect["fuelroom_fire03"]    = loadfx ( "maps/barge/barge_fuelroom_fire01" ); //CG - not used
	//level._effect["fuelroom_fire04"]    = loadfx ( "maps/barge/barge_fuelroom_fire01" ); //CG - not used
	//level._effect["insect_crawly01"]    = loadfx ( "maps/barge/barge_insect_crawly01" ); //CG - not used
	//level._effect["insect_moths01"]     = loadfx ( "maps/barge/barge_insect_moths01" ); //CG - not used
	
	
	//level._effect["ext_exhaust01"]      = loadfx ( "maps/barge/barge_ext_exhaust01" ); //05/21opti
	//level._effect["int_exhaust01"]      = loadfx ( "maps/barge/barge_int_exhaust01" ); //05/21opti
	
	
	//level._effect["patchy_mist01"]      = loadfx ( "maps/barge/barge_patchy_mist01" );	 //06/22opti
	//level._effect["patchy_mist02"]      = loadfx ( "maps/barge/barge_patchy_mist02" );	//06/22opti
	//level._effect["patchy_mist03"]      = loadfx ( "maps/barge/barge_patchy_mist03" );	//06/22opti
	//level._effect["patchy_mist04"]      = loadfx ( "maps/barge/barge_patchy_mist04" );	//06/22opti
	//level._effect["patchy_mist05"]      = loadfx ( "maps/barge/barge_patchy_mist05" );	//06/22opti
	//level._effect["deck_mist01"] 		= loadfx ( "maps/barge/barge_deck_mist01" );   //06/22opti
	//level._effect["deck_mist02"] 		= loadfx ( "maps/barge/barge_deck_mist02" );	//06/22opti
	//level._effect["deck_mist03"] 		= loadfx ( "maps/barge/barge_deck_mist03" );	//06/22opti
	
	//level._effect["deck_fire"] 			= loadfx ( "maps/barge/barge_deck_fire01" ); //CG - not used
	
	
	//level._effect["pipe_steam01"]       = loadfx ( "maps/barge/barge_pipe_steam01" );
	//level._effect["pipe_steam02"]       = loadfx ( "maps/barge/barge_pipe_steam02" );
	level._effect["vol_light01"]        = loadfx ( "maps/barge/barge_vol_light01" ); //06/22opti
	level._effect["vol_light02"]        = loadfx ( "maps/barge/barge_vol_light02" ); //06/22opti
	level._effect["vol_light03"]        = loadfx ( "maps/barge/barge_vol_light03" ); //06/22opti
	level._effect["vol_light04"]        = loadfx ( "maps/barge/barge_vol_light04" ); //06/22opti
	level._effect["vol_light05"]        = loadfx ( "maps/barge/barge_vol_light05" ); //06/22opti
	level._effect["vol_light06"]        = loadfx ( "maps/barge/barge_vol_light06" ); //06/22opti
	level._effect["barge_spotlight"]    = loadfx ( "maps/barge/barge_spotlight" );
	level._effect["moonlight_dust1"]    = loadfx ( "maps/barge/barge_moonlight_dust01" );
	level._effect["door_exp01"]    		= loadfx ( "props/welding_exp" );
	level._effect["fxlighthouse"] 		= loadfx ( "maps/barge/barge_lighthouse_vol");
	level._effect["barge_port_smk1"] 	= loadfx ( "maps/barge/barge_porthole_smk1");
	
	//effects from barge.gsc
	//level._effect["fog_villassault"]  = loadfx ("weather/fogbank_small_duhoc"); //06/22opti
	//level._effect["fxwater"]          = loadfx ( "misc/water_gush" ); 					//05/21opti
	level._effect["fxspark01"]        = loadfx ( "impacts/large_metalhit" );    //06/22opti
	level._effect["fxsteam01"]        = loadfx ( "impacts/pipe_steam" );
	
	level._effect["fxfire2"]          = loadfx ( "maps/barge/barge_smallfire" ); //06/22opti

	
	//effects in barge 11/06/07
	level._effect["bullets"] = loadfx ("impacts/ac130_25mm_IR_impact");	
	level._effect["fxfire3"] = loadfx ( "maps/barge/barge_smallfire" );
	level._effect["fxsmoke"] = loadfx ( "smoke/thin_light_smoke_M" ); 
	//level._effect["fxsmoke1"] = loadfx ( "smoke/smoke_grenade" );  //05/21opti
	level._effect["fxgen09"] = loadfx ( "props/welding_exp" );
	level._effect["fxgen10"] = loadfx ( "explosions/powerlines_b" );
	//level._effect["corfire"] = loadfx ( "maps/barge/barge_pipe_steam03" ); //CG - not used
	level._effect["pipesteam"] = loadfx ( "maps/barge/barge_pipe_steam01" );
	level._effect["roof_fog"] = loadfx ("maps/barge/barge_cloud_bank");
	level._effect["ambientS"] = loadfx ( "smoke/amb_smoke_add" );
	level._effect["fxpumpgen"] = loadfx ( "props/welding_exp" );
	level._effect["fxdoor"] = loadfx ( "maps/barge/barge_explosion_tanks" );
	level._effect["flash"] = loadfx ( "weapons/MP/flashbang");
	
	//new! 03/20/08
	level._effect["bow_glass"] = loadfx ( "breakables/glass_shatter_large");
	
	//05/20/08 disabled these in desparation for memory! -bbekian
	//level._effect["water_spray1"] = loadfx ("maps/venice/gettler_water_spray1");
	//level._effect["water_spray2"] = loadfx ("maps/venice/gettler_water_spray2");
	//level._effect["water_gush1"] = loadfx ("maps/venice/gettler_water_gush1");
	//level._effect["water_gush2"] = loadfx ("maps/venice/gettler_water_gush2");
	//level._effect["water_gush3"] = loadfx ("maps/venice/gettler_water_gush3");
	
	level._effect["fxmoths"] 			= loadfx ("maps/barge/barge_moths");
	level._effect["barge_room_fire"] 	= loadfx ("maps/barge/barge_smallfire");
	
	//level._effect["vehicle_night_headlight01"]	 	= loadfx ("vehicles/night/vehicle_night_headlight01"); //06/22opti
	//level._effect["vehicle_night_taillight"]	 	= loadfx ("vehicles/night/vehicle_night_taillight"); //06/22opti
	
	//electric door puzzle room effects
	level._effect["barge_control_vol_light1"]	= loadfx ("maps/barge/barge_control_vol_light1"); 
	level._effect["light_pulsing_yellow"]	 	= loadfx ("misc/light_pulsing_yellow"); 
	level._effect["light_blinking_green"]	 	= loadfx ("misc/light_blinking_green"); 
	level._effect["light_solid_red"]	 		= loadfx ("misc/light_solid_red"); 
	level._effect["light_blue_sm"]	 			= loadfx ("misc/light_blue_sm"); 
	
	
	level._effect["spark0"]						= loadfx ("maps/barge/barge_electric_ark1");
	level._effect["spark1"]						= loadfx ("maps/barge/barge_electric_ark2");
	level._effect["spark2"]						= loadfx ("maps/barge/barge_electric_ark3");		
	level._effect["spark3"]						= loadfx ("maps/barge/barge_electric_ark_r2");
	level._effect["spark4"]	 					= loadfx ("maps/barge/barge_electric_ark_r");	
	level._effect["barge_electric_spark1"]	 	= loadfx ("maps/barge/barge_electric_spark1");
	level._effect["barge_electric_spark3"]	 	= loadfx ("maps/barge/barge_electric_spark3");
	level._effect["barge_spotlight_spark"]	 	= loadfx ("maps/barge/barge_spotlight_spark");
	level._effect["barge_cargo_drop"]	 		= loadfx ("maps/barge/barge_cargo_drop");	
	
	level._effect["barge_indoor_mist1"]	 		= loadfx ("maps/barge/barge_indoor_mist1");
	
	//level._effect["barge_cargodrop"]	 		= loadfx ("maps/barge/barge_cargodrop"); //old effect
	level._effect["barge_falling_leaves1"]	 	= loadfx ("maps/barge/barge_falling_leaves1");
	
	level._effect["dust"]	 	= loadfx ("impacts/large_dirt_b");
	level._effect["casino_vent_bullet_vol"]	 	= loadfx ("maps/casino/casino_vent_bullet_vol");
	
	level._effect["barge_door_smoke"]	 	= loadfx ("maps/barge/barge_door_smoke");
	
	level._effect["roof_fog2"]	 	= loadfx ("maps/barge/barge_cloud_bank_thin");
	
	level._effect["birds5"]	 	= loadfx ( "maps/MedievalVillage/estate_birds_flying01");
	
	level._effect["headlight"]	 	= loadfx ("vehicles/night/vehicle_night_headlight02");
	
	level._effect["ocean_splash"]	 	= loadfx ("maps/Casino/casino_spa_splash1");
}
