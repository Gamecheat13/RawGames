#include maps\_utility;


main()
{
	initFXModelAnims();
	
	precacheFX();
	
	maps\createfx\siena_rooftops_fx::main();
	
	
	
	
	
	level thread create_boss_fight_fx();	
}

create_boss_fight_fx()
{
	level waittill("fx_mitchell_fight");
	
	level thread maps\_fx::play_igcEffect(level.badguy, level.player, "fx_r_shoulder_dust", "qkill_hit_blood_r", "L_Wrist", -1);  
	level thread maps\_fx::play_igcEffect(level.badguy, level.badguy, "fx_r_knee_dust", "qkill_dust", "R_Knee_Bulge", -1);	
	level thread maps\_fx::play_igcEffect(level.badguy, level.badguy, "fx_spineupper_impact", "qkill_dust", "L_Wrist", -1);	
	level thread maps\_fx::play_igcEffect(level.player, level.player, "fx_l_foot_dust", "qkill_dust", "L_Foot", -1);	
	level thread maps\_fx::play_igcEffect(level.badguy, level.badguy, "fx_siena_glass_mith", "mitchell_glass", "SpineUpper", -1);	
	

	level.player waittillmatch( "anim_notetrack", "fx_pigeons_launch" );
	level notify("fx_tower_birds");
}	
	
initFXModelAnims()
{
	ent1 = getent( "fxanim_sn_door_kick", "targetname" );
	ent2 = getent( "fxanim_tower_boards", "targetname" );
	ent3 = getent( "fxanim_bell_tower_top", "targetname" );
	ent4 = getent( "fxanim_bell_tower_btm", "targetname" );
	
	ent_array1 = getentarray( "fxanim_curtain_01", "targetname" );
	ent_array2 = getentarray( "fxanim_curtain_02", "targetname" );
	ent_array3 = getentarray( "fxanim_curtain_03", "targetname" );
	ent_array4 = getentarray( "fxanim_curtain_04", "targetname" );
	ent_array5 = getentarray( "fxanim_tower_rope", "targetname" );
	ent_array6 = getentarray( "fxanim_thick_rope_01", "targetname" );
	ent_array7 = getentarray( "fxanim_thick_rope_02", "targetname" );
	ent_array8 = getentarray( "fxanim_rope_arch", "targetname" );
		
	if (IsDefined(ent1)) { ent1 thread sn_door_kick();   println("************* FX: sn_door_kick *************"); }
	if (IsDefined(ent2)) { ent2 thread tower_boards();   println("************* FX: tower_boards *************"); }
	if (IsDefined(ent3)) { ent3 thread bell_tower_top_01();   println("************* FX: bell_tower_top *************"); }
	if (IsDefined(ent4)) { ent4 thread bell_tower_btm();   println("************* FX: bell_tower_btm *************"); }
	
	if (IsDefined(ent_array1)) { ent_array1 thread curtain_01();   println("************* FX: curtain_01 *************"); }
	if (IsDefined(ent_array2)) { ent_array2 thread curtain_02();   println("************* FX: curtain_02 *************"); }
	if (IsDefined(ent_array3)) { ent_array3 thread curtain_03();   println("************* FX: curtain_03 *************"); }
	if (IsDefined(ent_array4)) { ent_array4 thread curtain_04();   println("************* FX: curtain_04 *************"); }
	if (IsDefined(ent_array5)) { ent_array5 thread tower_rope();   println("************* FX: tower_rope *************"); }
	if (IsDefined(ent_array6)) { ent_array6 thread thick_rope_01();   println("************* FX: thick_rope_01 *************"); }
	if (IsDefined(ent_array7)) { ent_array7 thread thick_rope_02();   println("************* FX: thick_rope_02 *************"); }
	if (IsDefined(ent_array8)) { ent_array8 thread rope_arch();   println("************* FX: rope_arch *************"); }
}


#using_animtree("fxanim_sn_door_kick");
sn_door_kick()
{
	level waittill("sn_door_kick_start");
	self UseAnimTree(#animtree);
	self animscripted("a_sn_door_kick", self.origin, self.angles, %fxanim_sn_door_kick);
}

#using_animtree("fxanim_curtain_01");
curtain_01()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_curtain_01", self[i].origin, self[i].angles, %fxanim_curtain_01);
	}
}

#using_animtree("fxanim_curtain_02");
curtain_02()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_curtain_02", self[i].origin, self[i].angles, %fxanim_curtain_02);
	}
}

#using_animtree("fxanim_curtain_03");
curtain_03()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_curtain_03", self[i].origin, self[i].angles, %fxanim_curtain_03);
	}
}

#using_animtree("fxanim_curtain_04");
curtain_04()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_curtain_04", self[i].origin, self[i].angles, %fxanim_curtain_04);
	}
}

#using_animtree("fxanim_tower_rope");
tower_rope()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_tower_rope", self[i].origin, self[i].angles, %fxanim_rope_dangle);
	}
}

#using_animtree("fxanim_tower_boards");
tower_boards()
{
	level waittill("tower_boards_start");
	self UseAnimTree(#animtree);
	self animscripted("a_tower_boards", self.origin, self.angles, %fxanim_tower_boards);
	level notify("fx_boss_wood");
}

#using_animtree("fxanim_thick_rope_01");
thick_rope_01()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_thick_rope_01", self[i].origin, self[i].angles, %fxanim_thick_rope_01);
	}
}

#using_animtree("fxanim_thick_rope_02");
thick_rope_02()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_thick_rope_02", self[i].origin, self[i].angles, %fxanim_thick_rope_02);
	}
}

#using_animtree("fxanim_rope_arch");
rope_arch()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_rope_arch", self[i].origin, self[i].angles, %fxanim_rope_arch);
	}
}

#using_animtree("fxanim_bell_tower_top_01");
bell_tower_top_01()
{
	level waittill("bell_tower_top_01_start");
	self UseAnimTree(#animtree);
	self animscripted("a_bell_tower_top_01", self.origin, self.angles, %fxanim_bell_tower_top_01);
	
	
	self waittillmatch("a_bell_tower_top_01", "bell_hit1");
	level notify("fx_tower_hit1");
	wait(.15);
	
	wall_1 = GetEnt("bell_crash01","targetname");
	wall_1 delete();
	self waittillmatch("a_bell_tower_top_01", "bell_hit2");
	level notify("fx_tower_hit2");
	
	wait(.15);
	wall_2 = GetEnt("bell_crash02","targetname");
	wall_2 delete();
	self waittillmatch("a_bell_tower_top_01", "bell_hit3");
	level notify("fx_tower_hit3");
	
	level waittill("bell_tower_top_02_start");
	self stopanimscripted();
	self stopuseanimtree();
	bell_tower_top_02();
}

#using_animtree("fxanim_bell_tower_top_02");
bell_tower_top_02()
{
	self UseAnimTree(#animtree);
	self animscripted("a_bell_tower_top_02", self.origin, self.angles, %fxanim_bell_tower_top_02);
	
	self waittillmatch("a_bell_tower_top_02", "bell_hits");
	wait(0.05);
	self waittillmatch("a_bell_tower_top_02", "bell_hits");
	level notify("fx_tower_hit4");
}

#using_animtree("fxanim_bell_tower_btm");
bell_tower_btm()
{
	level waittill("bell_tower_btm_start");
	self UseAnimTree(#animtree);
	self animscripted("a_bell_tower_btm", self.origin, self.angles, %fxanim_bell_tower_btm);
}

link_effect_to_ent( effectID, bone, offset, angle )
{
	ent_tag = Spawn( "script_model", self.origin );
	ent_tag SetModel( "tag_origin" );
	ent_tag.angles = self.angles;
	ent_tag LinkTo( self, bone, offset, angle );
			
	PlayFxOnTag( level._effect[effectID], ent_tag, "tag_origin" );
}

precacheFX()
{
	level._effect["siena_chimney1"] 			= loadfx ( "maps/siena/siena_chimney1" );
	level._effect["siena_horsetrack_dust"] 		= loadfx ( "maps/siena/siena_horsetrack_dust" );
	level._effect["siena_headlight01"]	 		= loadfx ( "maps/casino/casino_dbs_headlight1");	
	level._effect["siena_taillight01"]	 		= loadfx ( "maps/casino/casino_dbs_tailight1");
	level._effect["siena_collapse1"]	 		= loadfx ( "maps/siena/siena_collapse1");
	
	
	level._effect["siena_birds_flying1"]	 	= loadfx ( "maps/siena/siena_birds_flying1");
	level._effect["siena_birds_flying2"]	 	= loadfx ( "maps/siena/siena_birds_flying2");
	level._effect["siena_birds_flying3"]	 	= loadfx ( "maps/siena/siena_birds_flying3");
	level._effect["siena_birds_flying4"]	 	= loadfx ( "maps/siena/siena_birds_flying4");
	level._effect["siena_collapse_aftermath1"] = Loadfx( "maps/siena/siena_collapse_aftermath1");
	
	
    
    
	level._effect["qkill_hit_blood_r"]		= loadfx ("impacts/qkill_hit_blood_r");
    level._effect["qkill_dust"]             = loadfx("impacts/qkill_hit_dust");
    
    level._effect["mitchell_glass"]         = loadfx("impacts/qkill_glass");	
	level._effect["siena_room_dust2"] 		= loadfx ( "maps/siena/siena_room_dust2" );
	level._effect["siena_bossfight_wood"]	= loadfx ( "maps/siena/siena_bossfight_wood" );
	
	
	level._effect["siena_tower_hit1"]	 		= loadfx ( "maps/siena/siena_tower_hit1");
	level._effect["siena_tower_hit2"]	 		= loadfx ( "maps/siena/siena_tower_hit2");
}
