#include maps\_utility;

main()
{
	initFXModelAnims();
	
	precacheFX();
	
	
	
	registerFXTargetName("fx_kitchen_smoke");
	
	maps\createfx\eco_hotel_fx::main();
	
	
	level thread maps\_fx::quick_kill_fx_on();
}

initFXModelAnims()
{	
	ent1 = getent( "fxanim_kitchen_door", "targetname" );
	ent2 = getent( "fxanim_dining_doors", "targetname" );
	ent3 = getent( "fxanim_column_block", "targetname" );
	ent4 = getent( "fxanim_bedroom_doors", "targetname" );
	ent5 = getent( "fxanim_floor_collapse_2a", "targetname" );
	ent6 = getent( "fxanim_floor_collapse_2b", "targetname" );
	ent7 = getent( "fxanim_floor_collapse_1", "targetname" );
	ent8 = getent( "fxanim_kitchen_single", "targetname" );
	ent9 = getent( "fxanim_panel_drop_01", "targetname" );
	ent10 = getent( "fxanim_panel_drop_02", "targetname" );
	ent11 = getent( "fxanim_panel_drop_03", "targetname" );
	ent12 = getent( "fxanim_panel_drop_04", "targetname" );
	ent13 = getent( "fxanim_cafe_doors", "targetname" );

	if (IsDefined(ent1)) { ent1 thread kitchen_door();    }
	if (IsDefined(ent2)) { ent2 thread dining_doors();    }
	if (IsDefined(ent3)) { ent3 thread column_block();    }
	if (IsDefined(ent4)) { ent4 thread bedroom_doors();    }
	if (IsDefined(ent5)) { ent5 thread floor_collapse_2a();    }
	if (IsDefined(ent6)) { ent6 thread floor_collapse_2b();    }
	if (IsDefined(ent7)) { ent7 thread floor_collapse_1();    }
	if (IsDefined(ent8)) { ent8 thread kitchen_single();    }
	if (IsDefined(ent9)) { ent9 thread panel_drop_01();    }
	if (IsDefined(ent10)) { ent10 thread panel_drop_02();    }
	if (IsDefined(ent11)) { ent11 thread panel_drop_03();    }
	if (IsDefined(ent12)) { ent12 thread panel_drop_04();   }
	if (IsDefined(ent13)) { ent13 thread cafe_doors();    }	
}

#using_animtree("fxanim_kitchen_door");
kitchen_door()
{
	level waittill("kitchen_door_start");
	self UseAnimTree(#animtree);
	self animscripted("a_kitchen_door", self.origin, self.angles, %fxanim_kitchen_door);
}

#using_animtree("fxanim_dining_doors");
dining_doors()
{
	level waittill("dining_doors_start");
	self UseAnimTree(#animtree);
	self animscripted("a_dining_doors", self.origin, self.angles, %fxanim_dining_doors);
}

#using_animtree("fxanim_column_block");
column_block()
{
	level waittill("column_block_start");
	self UseAnimTree(#animtree);
	self animscripted("a_column_block", self.origin, self.angles, %fxanim_column_block);
}

#using_animtree("fxanim_bedroom_doors");
bedroom_doors()
{
	level waittill("bedroom_doors_start");
	self UseAnimTree(#animtree);
	self animscripted("a_bedroom_doors", self.origin, self.angles, %fxanim_bedroom_doors);
}

#using_animtree("fxanim_floor_collapse_2a");
floor_collapse_2a()
{
	level waittill("floor_collapse_2a_start");
	self UseAnimTree(#animtree);
	self animscripted("a_floor_collapse_2a", self.origin, self.angles, %fxanim_floor_collapse_2a);
}

#using_animtree("fxanim_floor_collapse_2b");
floor_collapse_2b()
{
	level waittill("floor_collapse_2b_start");
	self UseAnimTree(#animtree);
	self animscripted("a_floor_collapse_2b", self.origin, self.angles, %fxanim_floor_collapse_2b);
}

#using_animtree("fxanim_floor_collapse_1");
floor_collapse_1()
{
	level waittill("floor_collapse_1_start");
	self UseAnimTree(#animtree);
	self animscripted("a_floor_collapse_1", self.origin, self.angles, %fxanim_floor_collapse_1);
}

#using_animtree("fxanim_kitchen_single");
kitchen_single()
{
	level waittill("kitchen_single_start");
	self UseAnimTree(#animtree);
	self animscripted("a_kitchen_single", self.origin, self.angles, %fxanim_kitchen_single);
}

#using_animtree("fxanim_panel_drop");
panel_drop_01()
{
	level waittill("panel_drop_01_start");
	self UseAnimTree(#animtree);
	self animscripted("a_panel_drop_01", self.origin, self.angles, %fxanim_panel_drop);
}

#using_animtree("fxanim_panel_drop");
panel_drop_02()
{
	level waittill("panel_drop_02_start");
	self UseAnimTree(#animtree);
	self animscripted("a_panel_drop_02", self.origin, self.angles, %fxanim_panel_drop);
}

#using_animtree("fxanim_panel_drop");
panel_drop_03()
{
	level waittill("panel_drop_03_start");
	self UseAnimTree(#animtree);
	self animscripted("a_panel_drop_03", self.origin, self.angles, %fxanim_panel_drop);
}

#using_animtree("fxanim_panel_drop");
panel_drop_04()
{
	level waittill("panel_drop_04_start");
	self UseAnimTree(#animtree);
	self animscripted("a_panel_drop_04", self.origin, self.angles, %fxanim_panel_drop);
}

#using_animtree("fxanim_cafe_doors");
cafe_doors()
{
	level waittill("cafe_doors_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cafe_doors", self.origin, self.angles, %fxanim_cafe_doors);
}

precacheFX()
{	
	level._effect["dust_01"] = loadfx ("dust/dust_trail_IR");
	level._effect["fx_explosion"]	= loadfx ("explosions/small_vehicle_explosion");
	level._effect["fx_fire_small"]	= loadfx ("maps/Eco_Hotel/eco_fire_2");
	level._effect["fx_fire_large"]	= loadfx ("maps/Eco_Hotel/eco_fire_1");
	level._effect["fx_fire_med"]	= loadfx ("maps/Eco_Hotel/eco_fire_2");
	level._effect[ "propane_fire" ]	= loadfx( "maps/Eco_Hotel/eco_fire_1" );
	level._effect["electrical_explosion"]   = loadfx ("maps/miamisciencecenter/science_lamp_truss_hit");
	level._effect[ "propane_explosion" ] = loadfx( "props/welding_exp" );
	
	level._effect[ "fire_spout" ] = loadfx( "maps/Eco_Hotel/one_shot_fire" );
	level._effect[ "dir_explosion" ] = loadfx( "maps/Eco_Hotel/eco_explosion" );
	level._effect[ "end_explosion" ] = loadfx( "props/large_propane" );
	level._effect[ "end_explosion_ns" ] = loadfx( "props/large_propane" );
	

	
	level._effect["fireball_01"] 			= loadfx ("maps/eco_hotel/fireball_runner_1");
	level._effect["eco_ceiling_smoke01"]   	= loadfx ( "maps/eco_hotel/eco_ceiling_smoke01" );
	
	
	
	
}
