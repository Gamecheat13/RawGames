#include maps\_weather;
#include maps\_utility;
main()
{
	
	flag_init("cargoship_lighting_off");
	 
	//don't kill me for making this effect, was curious about some lighting stuff and it ended up looking kind of cool -Nathan
	level._effect["tunnel_light"]					= loadfx ("test/jeepride_tunnellight");
	level._effect["tunnel_light_flicker"]					= loadfx ("test/jeepride_tunnellight_flicker");

	level._effect["fog_icbm"]					= loadfx ("weather/fog_icbm");
	level._effect["fog_icbm_a"]					= loadfx ("weather/fog_icbm_a");
	level._effect["fog_icbm_b"]					= loadfx ("weather/fog_icbm_b");
	level._effect["fog_icbm_c"]					= loadfx ("weather/fog_icbm_c");	
	level._effect["leaves_runner_lghtr"]		= loadfx ("misc/leaves_runner_lghtr");
	level._effect["leaves_runner_lghtr_1"]		= loadfx ("misc/leaves_runner_lghtr_1");
	level._effect["insect_trail_runner_icbm"]	= loadfx ("misc/insect_trail_runner_icbm");
//	level._effect["cloud_bank"]					= loadfx ("weather/cloud_bank");
//	level._effect["cloud_bank_a"]				= loadfx ("weather/cloud_bank_a");
	level._effect["cloud_bank_far"]				= loadfx ("weather/jeepride_cloud_bank_far");
	level._effect["moth_runner"]				= loadfx ("misc/moth_runner");
	level._effect["hawks"]						= loadfx ("misc/hawks");
	level._effect["mist_icbm"]					= loadfx ("weather/mist_icbm");	
//	level._effect["icbm_vl_int"]				= loadfx ("misc/icbm_vl_int");
//	level._effect["icbm_vl_od"]					= loadfx ("misc/icbm_vl_od");
//	level._effect["icbm_vl_od_a"]				= loadfx ("misc/icbm_vl_od_a");
//	level._effect["icbm_vl_int_wide"]			= loadfx ("misc/icbm_vl_int_wide");
//	level._effect["icbm_vl"]					= loadfx ("misc/icbm_vl");
//	level._effect["icbm_vl_a"]					= loadfx ("misc/icbm_vl_a");
//	level._effect["icbm_vl_b"]					= loadfx ("misc/icbm_vl_b");	
//	level._effect["icbm_vl_int_ls"]				= loadfx ("misc/icbm_vl_int_ls");
//	level._effect["icbm_dust_int"]				= loadfx ("smoke/icbm_dust_int");	
//	level._effect["icbm_smoke_add"]				= loadfx ("smoke/icbm_smoke_add");
//	level._effect["icbm_smoke_add_clr"]			= loadfx ("smoke/icbm_smoke_add_clr");
//	level._effect["icbm_smoke_add_clr_a"]		= loadfx ("smoke/icbm_smoke_add_clr_a");	
//	level._effect["birds_icbm_runner"]			= loadfx ("misc/birds_icbm_runner");

//	maps\createfx\jeepride_fx::main();
	thread no_createfx();
}

no_createfx()
{
	//this keeps effects away from createfx tool, without this createfx might add these effects into the script.
	if(getdvar("createfx") != "")
		return;
	waittillframeend;
	

	tunnel_lights = getstructarray("tunnel_light","targetname");
	if(isdefined(tunnel_lights))
		array_thread(tunnel_lights, ::tunnel_light_fx);	
	tunnel_lights_flicker = getstructarray("tunnel_light_flicker","targetname");
	if(isdefined(tunnel_lights_flicker))
		array_thread(tunnel_lights_flicker, ::tunnel_light_flicker_fx);	

}

tunnel_light_fx()
{
	ent = createOneshotEffect("cgoshp_lights_cr");
	ent.v["origin"] = (self.origin);
	ent.v["angles"] = (self.angles);
	ent.v["fxid"] = "tunnel_light";
	ent.v["delay"] = -15;
}

tunnel_light_flicker_fx()
{
	ent = createOneshotEffect("cgoshp_lights_cr");
	ent.v["origin"] = (self.origin);
	ent.v["angles"] = (self.angles);
	ent.v["fxid"] = "tunnel_light_flicker";
	ent.v["delay"] = -15;
}