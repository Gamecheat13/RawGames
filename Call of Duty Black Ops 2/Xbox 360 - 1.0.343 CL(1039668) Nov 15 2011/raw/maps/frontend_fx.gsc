#include common_scripts\utility; 
#include maps\_utility;
#include maps\_anim;
#using_animtree("fxanim_props");

// fx used by utility scripts
precache_util_fx()
{
	
}

// Scripted effects
precache_scripted_fx()
{
	level._effect["battery_spark"] 					= LoadFX("maps/interrogation_escape/fx_interrog_battery_spark");
	level._effect["camera_light"]						= LoadFX("props/fx_lights_int_security_camera");
}

// Ambient effects
precache_createfx_fx()
{
	level._effect["fx_nix_numbers"]							     = loadfx("misc/fx_misc_nix_numbers");
	level._effect["fx_nix_numbers_mover"]				     = loadfx("misc/fx_misc_nix_numbers_mover");
	level._effect["fx_nix_numbers_pc"]						   = loadfx("misc/fx_misc_nix_numbers_pc");
	level._effect["fx_misc_nix_num_ceiling_pc"]		   = loadfx("misc/fx_misc_nix_numbers_cl_pc");
	level._effect["fx_nix_numbers_rotate"]				   = loadfx("misc/fx_misc_nix_numbers_rotate");
  level._effect["fx_nix_numbers_sphere"]				   = loadfx("misc/fx_misc_nix_numbers_sphere");
  level._effect["fx_nix_numbers_wall"]				     = loadfx("misc/fx_misc_nix_numbers_wall");
  
	level._effect["fx_fog_low"]								= loadfx("env/smoke/fx_fog_low");
	level._effect["fx_fog_low_sm"]						= loadfx("env/smoke/fx_fog_low_sm");
	level._effect["fx_cig_smoke"]							= loadfx("env/smoke/fx_cig_smoke_front_end");
	level._effect["fx_fog_low_hall_500"]			= loadfx("env/smoke/fx_fog_low_hall_500");
	level._effect["fx_dust_motes_lg"]					= loadfx("maps/frontend/fx_frontend_dust_motes_lg");
	level._effect["fx_dust_motes_sm"]					= loadfx("maps/frontend/fx_frontend_dust_motes_sm");
	level._effect["fx_light_ceiling"]					= loadfx("maps/frontend/fx_light_ceiling");	
	level._effect["fx_light_chair_flood"]			= loadfx("maps/frontend/fx_light_chair_flood");	
	level._effect["fx_axis_marker"]						= loadfx("fx_tools/fx_Tools_axis_sm");
	
	level._effect["fx_interrog_little_bubbles"]	    = loadfx("maps/interrogation_escape/fx_interrog_little_bubbles");
	level._effect["fx_interrog_cart_cig_smk"]	      = loadfx("maps/interrogation_escape/fx_interrog_cart_cig_smk");						

}

// FXanim Props
initModelAnims()
{
	level.scr_anim["fxanim_props"]["a_respirator"] = %fxanim_escape_respirator_anim;
	level.scr_anim["fxanim_props"]["a_tray_curtains"] = %fxanim_escape_tray_curtains_anim;
	level.scr_anim["fxanim_props"]["a_wires_single"] = %fxanim_escape_int_room_wires_single_anim;
	level.scr_anim["fxanim_props"]["a_wires_multi"] = %fxanim_escape_int_room_wires_multi_anim;
	
	ent1 = GetEnt( "fxanim_escape_respirator_mod", "targetname" );
	ent2 = GetEnt( "fxanim_escape_tray_mod", "targetname" );
	ent3 = GetEnt( "wires_single", "targetname" );
	
	enta_wires_multi = GetEntArray( "wires_multi", "targetname" );

	if (IsDefined(ent1)) 
	{
		ent1 thread respirator();
		println("************* FX: respirator *************");
	}
	
	if (IsDefined(ent2)) 
	{
		ent2 thread tray_curtains();
		println("************* FX: tray_curtains *************");
	}
	
		if (IsDefined(ent3)) 
	{
		ent3 thread wires_single();
		println("************* FX: wires_single *************");
	}
	
	for(i=0; i<enta_wires_multi.size; i++)
	{
 		enta_wires_multi[i] thread wires_multi(.1,2);
 		println("************* FX: wires_multi *************");
	}
}

respirator()
{
	wait(1);
	self UseAnimTree(#animtree);
	anim_single(self, "a_respirator", "fxanim_props");
}

tray_curtains()
{
	wait(1);
	self UseAnimTree(#animtree);
	anim_single(self, "a_tray_curtains", "fxanim_props");
}

wires_single()
{
	wait(.1);
	self UseAnimTree(#animtree);
	anim_single(self, "a_wires_single", "fxanim_props");
}

wires_multi(delay_min,delay_max)
{
	wait(delay_min);
	wait(randomfloat(delay_max-delay_min));
	self UseAnimTree(#animtree);
	anim_single(self, "a_wires_multi", "fxanim_props");
}


	
	
main()
{
	initModelAnims();
	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
	VisionSetNaked( "int_frontend_default" );
	
	footsteps();
		
	maps\createfx\frontend_fx::main();
}

footsteps()
{
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_sand" );
	LoadFx( "bio/player/fx_footstep_sand" );
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_mud" );
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_water" );
	LoadFx( "bio/player/fx_footstep_dust" );
}
