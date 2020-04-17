#include maps\_utility;
#using_animtree("fx_shantytown_shackExplode1");

main()
{
	
	
	
	
	
	
	registerFXTargetName("fx_debug");							
	registerFXTargetName("fx_OK");								
	
	
	
	registerFXTargetName("fx_propane_exp1");									
	
	
	
	
	
	
	
	
	
	
	
	registerFXTargetName("shop_explosion");								
	registerFXTargetName("truck_explosion");								

	initFXModelAnims();
	
	precacheFX();
	
	maps\createfx\shantytown_fx::main();
	
	
	
	
	
	
	
	
	
	level notify("fx_OK");





	eye = getent( "viewfx", "targetname" );	
	
			
	if (IsDefined(eye))
	{
		vision_fx = playfxontag(level._effect["grenade_teargas_viewfx"], eye, "TAG_ORIGIN");
		eye thread doFxUpdate();
	}	
	



	
	level thread maps\_fx::quick_kill_fx_on();
}






doFxUpdate()
{
	wait(1.0);
	
	println();
	println();
	println("************************************************************************************************************************************************");
	println("************************************************************************************************************************************************");
	println();
	println();
	
	tLerp = 0.03333;
	
	while(1)
	{
		if (IsDefined(level.player))
		{
			posvector = level.player getViewOrigin();
			dirvector = level.player getViewAngles();
			
			self moveTo  (posvector, tLerp );
			
		}
		wait(0.03);
	}
}




initFXModelAnims()
{
	ent_array1 = getentarray( "fxanim_seagull_circle", "targetname" );
	ent_array2 = getentarray( "fxanim_rope_arch", "targetname" );
	ent_array3 = getentarray( "fxanim_rope_long", "targetname" );
	ent_array4 = getentarray( "fxanim_rope_short", "targetname" );
	
	ent1 = getent( "fxanim_weapon_case_lrg", "targetname" );
	ent2 = getent( "fxanim_seagull_sitting", "targetname" );
	ent3 = getent( "fxanim_banana_banner", "targetname" );
	ent4 = getent( "fxanim_board_chuck", "targetname" );
	
		
	if (IsDefined(ent_array1)) { ent_array1 thread seagull_circle();   println("************* FX: seagull_circle *************"); }
	if (IsDefined(ent_array2)) { ent_array2 thread rope_arch();   println("************* FX: rope_arch *************"); }
	if (IsDefined(ent_array3)) { ent_array3 thread rope_long();   println("************* FX: rope_long *************"); }
	if (IsDefined(ent_array4)) { ent_array4 thread rope_short();   println("************* FX: rope_short *************"); }
	
	if (IsDefined(ent1)) { ent1 thread weapon_case_lrg();   println("************* FX: weapon_case_lrg *************"); }
	if (IsDefined(ent2)) { ent2 thread seagull_sitting();   println("************* FX: seagull_sitting *************"); }
	if (IsDefined(ent3)) { ent3 thread banana_banner();   println("************* FX: banana_banner *************"); }
	if (IsDefined(ent4)) { ent4 thread board_chuck();   println("************* FX: board_chuck *************"); }
	
}

#using_animtree("fxanim_seagull_circle");
seagull_circle()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_seagull_circle", self[i].origin, self[i].angles, %fxanim_seagull_circle);
	}
}

#using_animtree("fxanim_weapon_case_lrg");
weapon_case_lrg()
{
	level waittill("weapon_case_lrg_start");
	self UseAnimTree(#animtree);
	self animscripted("a_weapon_case_lrg", self.origin, self.angles, %fxanim_weapon_case_lrg);
}

#using_animtree("fxanim_seagull_sitting");
seagull_sitting()
{
	level waittill("seagull_sitting_start");
	self UseAnimTree(#animtree);
	self animscripted("a_seagull_sitting", self.origin, self.angles, %fxanim_seagull_sitting);
}

#using_animtree("fxanim_banana_banner");
banana_banner()
{
	level waittill("banana_banner_start");
	self UseAnimTree(#animtree);
	self animscripted("a_banana_banner", self.origin, self.angles, %fxanim_banana_banner);
}

#using_animtree("fxanim_board_chuck");
board_chuck()
{
	level waittill("board_chuck_start");
	self UseAnimTree(#animtree);
	self animscripted("a_board_chuck", self.origin, self.angles, %fxanim_board_chuck);
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

#using_animtree("fxanim_rope_long");
rope_long()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_rope_long", self[i].origin, self[i].angles, %fxanim_rope_long);
	}
}

#using_animtree("fxanim_rope_short");
rope_short()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_rope_short", self[i].origin, self[i].angles, %fxanim_rope_short);
	}
}



testalley()
{
	wait(20.0);
	level notify("Alley_fire_ignite");
	wait(5.0);
	level notify("Alley_ceiling_crash_1");
	wait(5.0);
	level notify("Alley_ceiling_crash_2");
	wait(5.0);
	level notify("Alley_ceiling_crash_3");
	wait(5.0);
	level notify("Alley_fire_secondary explosion");
	wait(5.0);
	level notify("Alley_ceiling_crash_4");
	wait(5.0);
	level notify("Alley_door_smash");
	wait(5.0);
	level notify("Alley_ceiling_crash_5");
}


precacheFX()
{	
	


	level._effect["chimney_small"]						= loadfx ("smoke/chimney_small");
	
	
	level._effect["shanty_spotfire_lg"]				= loadfx ("maps/shantytown/shanty_spotfire_lg");
	level._effect["shanty_spotfire_med"]				= loadfx ("maps/shantytown/shanty_spotfire_med");
	level._effect["shanty_spotfire_sm"]				= loadfx ("maps/shantytown/shanty_spotfire_sm");
	
	
	level._effect["shanty_burning_fire"]			= loadfx ("maps/shantytown/shanty_spotfire_lg");
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	level._effect["shanty_carbomb_exp"]					= loadfx ("maps/shantytown/shanty_carbomb_exp");
	level._effect["shanty_carbomb_crashland"]		= loadfx ("maps/shantytown/shanty_carbomb_crashland");
	level._effect["shanty_elec_sparks01"]				= loadfx ("maps/shantytown/shanty_elec_sparks01");
	level._effect["shanty_elec_sparks02"]				= loadfx ("maps/shantytown/shanty_elec_sparks02");
	level._effect["shanty_elec_sparks03"]				= loadfx ("maps/shantytown/shanty_elec_sparks03");
	level._effect["shanty_elec_sparks04"]				= loadfx ("maps/shantytown/shanty_elec_sparks04");
	level._effect["shanty_carbomb_polecrash"]		= loadfx ("maps/shantytown/shanty_carbomb_polecrash");

	
	level._effect["Shanty_SmokeWind"]						= loadfx ("maps/shantytown/Shanty_SmokeWind");
	
	level._effect["Shanty_dustywind"]						= loadfx ("maps/shantytown/Shanty_dustywind");
	level._effect["Shanty_bbq"]									= loadfx ("maps/shantytown/Shanty_bbq");
	level._effect["shanty_startled_birds"]			= loadfx ("maps/shantytown/shanty_startled_birds");
	level._effect["shanty_container_exp"] 			= loadfx ("maps/shantytown/shanty_container_exp");
	
	
	level._effect["shanty_windy_trash"]					= loadfx ("maps/shantytown/shanty_windy_trash");
	level._effect["shanty_bustthrough_gate"]			= loadfx ("maps/shantytown/shanty_bustthrough_gate");
	
	
	level._effect["default_explosion"]					= loadfx ("maps/shantytown/shanty_butane_tank_exp");
	
	level._effect["shanty_windy_dust1"]					= loadfx ("maps/shantytown/shanty_windy_dust01");
	
	
	level._effect["hawk"]								= loadfx ("weather/hawk");
	level._effect["firelp_small_pm_a"]					= loadfx ("fire/firelp_small_pm_a");
	level._effect["muzzleflash"]						= loadfx ("muzzleflashes/standardflashworld");
	
	
	level._effect["exp_fruit_bananas"]					= loadfx ("breakables/exp_fruit_bananas");
	level._effect["exp_fruit_watermellons"]			= loadfx ("breakables/exp_fruit_watermellons");
	
	
}

link_effect_to_ent( effectID, bone, offset, angle )
{
	ent_tag = Spawn( "script_model", self.origin );
	ent_tag SetModel( "tag_origin" );
	ent_tag.angles = self.angles;
	ent_tag LinkTo( self, bone, offset, angle );
		
	PlayFxOnTag( level._effect[effectID], ent_tag, "tag_origin" );
}

container_propane_explosion()
{
		vPos = (-2226.84,596.46,70.0);
		vDir = (0,88,0);
		vFwd = anglestoforward(vDir);
		vUp  = anglestoup(vDir);
  	playfx( level._effect["shanty_container_exp"], vPos, vFwd, vUp);
  	
  	vPos = (-1969,250,212);
  	vDir = (88.0,104,0);
		vFwd = anglestoforward(vDir);
		vUp  = anglestoup(vDir);
		playfx( level._effect["shanty_startled_birds"], vPos, vFwd, vUp);
		
		vPos = (-2421,13,212);
  	vDir = (88.0,104,0);
		vFwd = anglestoforward(vDir);
		vUp  = anglestoup(vDir);
		playfx( level._effect["shanty_startled_birds"], vPos, vFwd, vUp);
		
		vPos = (-2683,678,164);
  	vDir = (86.5,222.4,178.5);	
		vFwd = anglestoforward(vDir);
		vUp  = anglestoup(vDir);
		playfx( level._effect["shanty_startled_birds"], vPos, vFwd, vUp);
		
  
  
  
  
}


StartPropaneFire(delay)
{
		level waittill("propane_explode");
		
		
		
		
		
		
		
		
}
