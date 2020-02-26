#include maps\_utility;


main()
{

	initFXModelAnims();

	precacheFX();
	
	
	registerFXTargetName("fx_pipe_1_on");
	registerFXTargetName("fx_pipe_2_on");
	registerFXTargetName("fx_pipe_3_on");
	registerFXTargetName("fx_deck_fire_on");
	registerFXTargetName("fx_door_explosion");
	registerFXTargetName("fx_fog_on"); 
	registerFXTargetName("fx_overload_sparks");
	
	registerFXTargetName("fx_enginefire_on");
	
	
	maps\createfx\barge_fx::main();
	
	
	level thread wait_start_lighthouse();
	
	

	
	
	
	
	
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
	ent8 = getent( "fxanim_door_bash", "targetname" );
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
	if (IsDefined(ent8)) { ent8 thread door_bash_01();   println("************* FX: door_bash_01 *************"); }
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
	wait(13);
	cargo_drop_container_slip();
}

#using_animtree("fxanim_cargo_drop_container_slip");
cargo_drop_container_slip()
{
	level waittill("cargo_drop_container_slip_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cargo_drop_container_slip", self.origin, self.angles, %fxanim_cargo_drop_container_slip);
}

#using_animtree("fxanim_cargo_drop_inards");
cargo_drop_inards()
{
	level waittill("cargo_drop_inards_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cargo_drop_inards", self.origin, self.angles, %fxanim_cargo_drop_inards);
	wait(13);
	cargo_drop_inards_slip();
}

#using_animtree("fxanim_cargo_drop_inards_slip");
cargo_drop_inards_slip()
{
	level waittill("cargo_drop_inards_slip_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cargo_drop_inards_slip", self.origin, self.angles, %fxanim_cargo_drop_inards_slip);
}

#using_animtree("fxanim_cargo_drop_fence");
cargo_drop_fence()
{
	level waittill("cargo_drop_fence_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cargo_drop_fence", self.origin, self.angles, %fxanim_cargo_drop_fence);
	wait(13);
	cargo_drop_fence_slip();
}

#using_animtree("fxanim_cargo_drop_fence_slip");
cargo_drop_fence_slip()
{
	level waittill("cargo_drop_fence_slip_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cargo_drop_fence_slip", self.origin, self.angles, %fxanim_cargo_drop_fence_slip);
}

#using_animtree("fxanim_cargo_drop_glass");
cargo_drop_glass()
{
	level waittill("cargo_drop_glass_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cargo_drop_glass", self.origin, self.angles, %fxanim_cargo_drop_glass);
}

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


rotate_effect(effect, start_origin, start_angle, anim_time)
{
	
	
	ent_tag = undefined;
	ent_tag = Spawn("script_model", start_origin);
	ent_tag SetModel("tag_origin");
	ent_tag.angles = start_angle;
		
	PlayFxOnTag(level._effect[effect], ent_tag, "tag_origin");
	
	
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
}






precacheFX()
{
	
	
	level._effect["default_explosion"]  = loadfx ("maps/barge/barge_explosion_tanks");	
	
	



	
	
	
	
	
	
	


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	level._effect["pipe_steam01"]       = loadfx ( "maps/barge/barge_pipe_steam01" );
	level._effect["pipe_steam02"]       = loadfx ( "maps/barge/barge_pipe_steam02" );
	level._effect["vol_light01"]        = loadfx ( "maps/barge/barge_vol_light01" ); 
	level._effect["vol_light02"]        = loadfx ( "maps/barge/barge_vol_light02" ); 
	
	
	level._effect["vol_light05"]        = loadfx ( "maps/barge/barge_vol_light05" ); 
	level._effect["vol_light06"]        = loadfx ( "maps/barge/barge_vol_light06" ); 
	level._effect["barge_spotlight"]    = loadfx ( "maps/barge/barge_spotlight" );
	
	level._effect["door_exp01"]    		= loadfx ( "maps/barge/barge_door_exp01" );
	level._effect["fxlighthouse"] 		= loadfx ( "maps/barge/barge_lighthouse_vol");
	level._effect["barge_port_smk1"] 	= loadfx ( "maps/barge/barge_porthole_smk1");
	
	
	
	
	level._effect["fxspark01"]        = loadfx ( "impacts/large_metalhit" );    
	level._effect["fxsteam01"]        = loadfx ( "impacts/pipe_steam" );
	
	level._effect["fxfire2"]          = loadfx ( "maps/barge/barge_smallfire" ); 

	
	
	level._effect["bullets"] = loadfx ("impacts/ac130_25mm_IR_impact");	
	level._effect["fxfire3"] = loadfx ( "maps/barge/barge_smallfire" );
	
	
	level._effect["fxgen09"] = loadfx ( "maps/barge/barge_explosion_tanks" );
	level._effect["fxgen10"] = loadfx ( "explosions/powerlines_b" );
	level._effect["corfire"] = loadfx ( "maps/barge/barge_pipe_steam03" );
	level._effect["pipesteam"] = loadfx ( "maps/barge/barge_pipe_steam01" );
	level._effect["roof_fog"] = loadfx ("maps/barge/barge_cloud_bank");
	
	level._effect["fxpumpgen"] = loadfx ( "maps/barge/barge_explosion_tanks" );
	level._effect["fxdoor"] = loadfx ( "maps/barge/barge_explosion_tanks" );
	level._effect["flash"] = loadfx ( "weapons/MP/flashbang");
	
	
	level._effect["bow_glass"] = loadfx ( "breakables/glass_shatter_large");
	
	
	
	
	
	
	
	
	
	level._effect["barge_room_fire"] 	= loadfx ("maps/barge/barge_smallfire");
	
	
	
	
	
	level._effect["barge_control_vol_light1"]	= loadfx ("maps/barge/barge_control_vol_light1"); 
	level._effect["light_pulsing_yellow"]	 	= loadfx ("misc/light_pulsing_yellow"); 
	level._effect["light_blinking_green"]	 	= loadfx ("misc/light_blinking_green"); 
	
	level._effect["light_blue_sm"]	 			= loadfx ("misc/light_blue_sm"); 
	
	
	level._effect["spark0"]	= loadfx ("maps/barge/barge_electric_ark1");
	level._effect["spark1"]	= loadfx ("maps/barge/barge_electric_ark2");
	level._effect["spark2"]	= loadfx ("maps/barge/barge_electric_ark3");
	
	level._effect["spark3"]	= loadfx ("maps/barge/barge_electric_ark_r2");
	level._effect["spark4"]	 	= loadfx ("maps/barge/barge_electric_ark_r");
	
	level._effect["barge_electric_spark1"]	 	= loadfx ("maps/barge/barge_electric_spark1");
	
	
	level._effect["barge_indoor_mist1"]	 		= loadfx ("maps/barge/barge_indoor_mist1");
	
	level._effect["barge_cargodrop"]	 		= loadfx ("maps/barge/barge_cargodrop");
	
	
	level._effect["dust"]	 	= loadfx ("impacts/large_dirt_b");
	level._effect["casino_vent_bullet_vol"]	 	= loadfx ("maps/casino/casino_vent_bullet_vol");
	
	level._effect["barge_door_smoke"]	 	= loadfx ("maps/barge/barge_door_smoke");
	
	level._effect["roof_fog2"]	 	= loadfx ("maps/barge/barge_cloud_bank_thin");
	
}
