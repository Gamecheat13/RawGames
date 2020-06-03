/*-----------------------------------------------------
Effects used for Okinawa 3
-----------------------------------------------------*/
#include maps\_utility;
#include common_scripts\utility;

main()
{

	level thread maps\oki3_courtyard::dvar_watcher();

	precacheFX();
	thread wind_settings();
//	thread vision_settings(); // - Added by Rich 3/25/08 NOW HANDLED BY oki3_art.gsc
	maps\createart\oki3_art::main(); //Added by Rich 3/25/08 calls the oki3_art.gsc that controls the vision sets and fog
	maps\createfx\oki3_fx::main();	// Calls in ambient effects created with CreateFX
	level thread tunnel_light();
}

// Global Wind Settings
wind_settings()
{
	// These values are supposed to be in inches per second.
	SetSavedDvar( "wind_global_vector", "-168 -111 0" ); // 200 inches per second or about 12mph with wind going SW (if N is (0,1,0))
	// Courtyard value: "wind_global_vector", "60 -200 0"
	SetSavedDvar( "wind_global_low_altitude", -700 );
	SetSavedDvar( "wind_global_hi_altitude", 1200 );
	SetSavedDvar( "wind_global_low_strength_percent", 0.5 ); // brings ground level wind down to 6mph


//	SetSavedDvar( "wind_global_vector", "-200 -15 0" ); // 200 inches per second or about 12mph with wind going E (if N is (0,1,0))
//	SetSavedDvar( "wind_global_low_altitude", -700 );
//	SetSavedDvar( "wind_global_hi_altitude", 1100 );
//	SetSavedDvar( "wind_global_low_strength_percent", 0.4 ); // brings ground level wind down to 6mph
//	


}

////set initial vision settings - Added by Rich 3/25/08 NOW HANDLED BY oki3_art.gsc
//vision_settings()
//{
//wait .5;
//VisionSetNaked( "oki3", 1 );
//wait .5;
//setVolFog(2500, 3500, 285, -380, 0.54, 0.43, 0.32, 0);
//}

precacheFX()
{
	
	//fire stuffs
	level._effect["flame_death1"] = loadfx("env/fire/fx_fire_player_sm");
	level._effect["flame_death2"] = loadfx("env/fire/fx_fire_player_torso");
	level._effect["flame_death3"] = loadfx("env/fire/fx_fire_player_sm");	
	
	//outro smoke
	level._effect["outro_smoke"] = loadfx("maps/oki3/fx_smokebank_black_lg_oki3");
	
	
	//courtyard explosion effects
	level._effect["courtyard_rooftop_sm"] = loadFX("maps/oki3/fx_exp_shuri_bldg_roof01");
	level._effect["courtyard_shock_sm"] = loadfx("maps/oki3/fx_exp_shuri_bldg_grnd01");
	level._effect["courtyard_rooftop_lg"] = loadFX("maps/oki3/fx_exp_shuri_bldg_roof02");
	level._effect["courtyard_shock_lg"] = loadfx("maps/oki3/fx_exp_shuri_bldg_grnd02");
	
	level._effect["headshot"] = LoadFX( "maps/oki3/fx_head_pop" );
	
	level._effect["smoke_grn_trail"] = loadFX("weapon/grenade/fx_geotrail_smk_grn");
	level._effect["after_mortars"] = loadfx("maps/oki3/fx_smokebank_postmortar");	
	level._effect["cratersmoke"]		= loadfx("env/smoke/fx_smoke_crater_w");	
	level.mortar = loadfx("weapon/mortar/fx_mortar_exp_dirt_brown");
	level._effect["flesh_hit"] = LoadFX( "impacts/flesh_hit" );
	//level._effect["smoke_screen1"]				= loadfx("env/smoke/fx_battlefield_beach_smokebank_ling_lg");
	level._effect["tree_burst"]	= loadfx("maps/oki3/fx_exp_palm_dir1");//("maps/pel1/fx_exp_treeburst_palm");
	//level._effect["light_smoke_nade"] = loadfx("weapon/grenade/fx_smoke_grenade_light");
	level._effect["bunker_satchel"] = loadfx("maps/oki3/fx_exp_bunker_satchel");

	//dirt mortars
	level._effectType["dirt_mortar"] 			= "mortar";
	level._effect["dirt_mortar"]					= loadfx("weapon/mortar/fx_mortar_exp_dirt_brown");
	level.explosion_stopNotify["dirt_mortar"] = "stop_ambush_mortars";
	
	//mortars in trenches
	level._effectType["trench_mortars"] 			= "mortar";
	level._effect["trench_mortars"]					= loadfx("weapon/mortar/fx_mortar_exp_dirt_brown");
	level.explosion_stopNotify["trench_mortars"] = "stop_trench_mortars";
	
	//mortars after tree sniper
	level._effectType["ambush_mortars"] 			= "mortar";
	level._effect["ambush_mortars"]					= loadfx("weapon/mortar/fx_mortar_exp_dirt_brown");
	level.explosion_stopNotify["ambush_mortars"] = "stop_ambush_mortars";
	
	
	//first mortar that falls near the player
	level._effectType["first_mortar"] 	= "mortar";
	level._effect["first_mortar"]				= loadfx("weapon/mortar/fx_mortar_exp_dirt_brown");
	
	//mortars on the hill behind the players
	level._effectType["hill_mortars"] 			= "mortar";
	level._effect["hill_mortars"]					= loadfx("weapon/mortar/fx_mortar_exp_dirt_brown");
	level.explosion_stopNotify["hill_mortars"] = "stop_hill_mortars";
	
	//mortars at the castle courtyard
	level._effectType["castle_mortar"] = "mortar";
	level._effect["castle_mortar"] = 	loadfx("weapon/mortar/fx_mortar_exp_dirt_brown");
	level.explosion_stopNotify["castle_mortar"] = "stop castle mortars";
	
	level._effectType["roof_ambient_mortars"] = "mortar";
	level._effect["roof_ambient_mortars"] = 	loadfx("weapon/mortar/fx_mortar_exp_dirt_brown");
	level.explosion_stopNotify["roof_ambient_mortars"] = "stop_ambient_roof_mortars";
	
	//dust falling from ceiling in bunkers 
	level._effect["bunker_dust"] = loadfx("maps/oki3/fx_bunker_dust_shock");
	level._effect["tunnel_dust"] = loadfx("maps/oki3/fx_bunker_ceiling_impact");
	
	//when players throw a mortar onto the bunkers in the back area
	level._effect["bunker_explode"] = loadfx("maps/oki3/fx_exp_mortar_bunker");
	
	//generic smoke fx for japanese banzai attack in beginning
	level._effect["smoke1"] =  loadfx("weapon/grenade/fx_smoke_grenade_generic");	
	//level._effect["mortar_launch"] = loadfx("weapon/mortar/fx_mortar_launch_w_trail");
	
	//toss a mortar into the mortar pits
	level._effect["mortar_pit_debris"] = loadfx("maps/oki3/fx_exp_mortar_punji");
	
	//supply drop crashes into bunker 
	//level._effect["bunker_supply_impact"] = loadfx("maps/oki3/fx_impact_supplydrop");
	
	level._effectType["dirt_mortar"] 			= "mortar";
	level._effect["dirt_mortar"]					= loadfx("weapon/mortar/fx_mortar_exp_dirt_brown");
	level.explosion_stopNotify["dirt_mortar"] = "stop_ambush_mortars";
	
	level._effectType["arty_tile_roof"] 			= "artillery";
	level._effect["arty_tile_roof"] = loadfx("maps/oki3/fx_exp_art_ctyd_roof");
	
	level._effectType["courtyard_ambient_ground"] 	= "artillery";
	level._effect["courtyard_ambient_ground"]				= loadfx("weapon/mortar/fx_mortar_exp_dirt_brown");
	level.explosion_stopNotify["courtyard_ambient_ground"] 			= "stop_courtyard_ambients";
	
	level._effectType["courtyard_ambient_roof"] 	= "artillery";
	level._effect["courtyard_ambient_roof"]				= loadfx("maps/oki3/fx_exp_art_ctyd_roof");
	level.explosion_stopNotify["courtyard_ambient_roof"] 			= "stop_courtyard_ambients";
	
	//tree sniper leafy stuff
	level._effect["sniper_leaf_loop"]							= loadfx("destructibles/fx_dest_tree_palm_snipe_leaf01");	
	level._effect["sniper_leaf_canned"]							= loadfx("destructibles/fx_dest_tree_palm_snipe_leaf02");
	
	level._effect["null"] = loadfx("system_elements/fx_null");
	
	//mortarteam stuff
	level.scr_sound["mortar_flash"] = "wpn_mortar_fire";
	level._effect["mortar_flash"] = loadfx("weapon/mortar/fx_mortar_launch_w_trail");
	
	//radio zort
	level._effect["zort"] = loadfx("env/electrical/fx_elec_short_oneshot");
	
	//light fx test
	level._effect["tunnel_light_fx"] = loadfx("env/light/fx_glow_hanginglamp");
	
	//--------------------AMBIENT EFFECTS--------------------------------
	level._effect["a_circling_birds"] = loadfx("bio/animals/fx_birds_circling");
	level._effect["a_insects"] = 				loadfx("bio/insects/fx_insects_ambient");
	level._effect["a_ash_and_embers"] = loadfx("maps/oki3/fx_oki3_ash_embers");
	level._effect["a_pollen_lg"] = loadfx("env/foliage/fx_pollen_lg");
	level._effect["a_dust_kickup_sm"] = loadfx("env/dirt/fx_dust_kickup_sm");
	level._effect["a_dust_kickup_lg"] = loadfx("env/dirt/fx_dust_kickup_lg_lf");
	level._effect["a_godray_window_high"] = loadfx("maps/oki3/fx_ray_window_high");
	level._effect["a_godray_window_lg"] = loadfx("maps/oki3/fx_ray_window_lg");
	level._effect["a_godray_window_high_dim"] = loadfx("maps/oki3/fx_ray_window_high_dim");
	level._effect["a_godray_window_lg_dim"] = loadfx("maps/oki3/fx_ray_window_lg_dim");
	
	level._effect["a_smoke_field_lg"] = loadfx("maps/oki3/fx_smokebank_black_lg_oki3"); //Play every 1 second
	level._effect["a_smoke_field_sm"] = loadfx("env/smoke/fx_battlefield_smokebank_ling_sm_w");
	level._effect["a_smoke_impact"] = loadfx("env/smoke/fx_smoke_impact_smolder");
	level._effect["a_smoke_smolder_lg"] = 		loadfx("maps/oki3/fx_smoke_ash_smldr_md");	
	level._effect["a_smoke_plume_low_gray"] = loadfx("env/smoke/fx_smk_column_md_gray_dir");
	level._effect["a_smoke_window_lg"] = loadfx("env/smoke/fx_smoke_window_lg_gry");
	level._effect["a_smoke_window_md"] = loadfx("env/smoke/fx_smoke_window_md_gry");
	level._effect["a_smoke_window_lg_w"] = loadfx("env/smoke/fx_smk_window_lg_smldr_lf");
	level._effect["a_smoke_brush_smldr_sm"] = loadfx("env/smoke/fx_smoke_brush_smolder_sm");
	level._effect["a_smoke_brush_smldr_md"] = loadfx("env/smoke/fx_smoke_brush_smolder_md");
	level._effect["a_smoke_crater"]		= loadfx("env/smoke/fx_smoke_crater_w");
	level._effect["a_smoke_smolder_sm_blk"]	= loadfx("env/smoke/fx_smoke_smolder_sm_blk");
	level._effect["a_smk_column_lg_blk"]	= loadfx("env/smoke/fx_smk_column_lg_blk");
	level._effect["a_smk_column_md_blk_dir"]	= loadfx("env/smoke/fx_smk_column_md_blk_dir");
	level._effect["a_smk_plume_xlg"]	= loadfx("env/smoke/fx_smoke_plume_xlg_slow_blk_tall_w");
	level._effect["a_embers_falling_sm"]	= loadfx("env/fire/fx_embers_falling_sm");
	
	level._effect["a_fire_smoke_med"] = loadfx("env/fire/fx_fire_house_md_jp");
	level._effect["a_fire_smoke_med_dist"] = loadfx("env/fire/fx_fire_smoke_md_dist_jp");
	level._effect["a_fire_smoke_sm_dist"] = loadfx("env/fire/fx_fire_smoke_sm_dist_jp");
	level._effect["a_fire_smoke_med_int"] = loadfx("env/fire/fx_fire_md_low_smk_jp");
	level._effect["a_fire_brush_smldr_sm"] = loadfx("env/fire/fx_fire_brush_smolder_sm_jp");
	level._effect["a_fire_brush_smldr_md"] = loadfx("env/fire/fx_fire_brush_smolder_md_jp");
	level._effect["a_fire_rubble_sm_oki3"]	= loadfx("env/fire/fx_fire_rubble_sm_jp");
	level._effect["a_fire_rubble_detail_md"]	= loadfx("env/fire/fx_fire_rubble_detail_md_jp");
	level._effect["a_fire_rubble_smolder_sm_oki3"]	= loadfx("env/fire/fx_fire_rubble_smolder_sm_jp");
	level._effect["a_fire_tree_smldr_sm"] = loadfx("env/fire/fx_fire_tree_smolder_sm_jp");
	level._effect["a_fire_tree_sm"] = loadfx("env/fire/fx_fire_tree_sm_jp");
	level._effect["a_fire_brush_detail"] = loadfx("env/fire/fx_fire_rubble_detail_jp");
	level._effect["a_fire_150x600_distant"]	= loadfx("env/fire/fx_fire_150x600_tall_distant_jp");
	
	level._effect["a_exp_shuri_window"]	= loadfx("maps/oki3/fx_exp_shuri_window");
	level._effect["a_paper_ash_burning"]	= loadfx("maps/oki3/fx_paper_ash_burning");
	level._effect["a_dirt_falling"]	= loadfx("env/dirt/fx_dirt_falling_quick_md");
	level._effect["a_tunnel_dust_hit"]	= loadfx("maps/oki3/fx_bunker_ceiling_impact");
	level._effect["a_tunnel_dust_hit_splash"]	= loadfx("maps/oki3/fx_bunker_ceiling_impact2");
	level._effect["a_tunnel_dust_amb"]	= loadfx("maps/oki3/fx_bunker_ceiling_ambient");
	level._effect["a_tunnel_dust_hit_thin"]	= loadfx("maps/oki3/fx_tunnel_ceiling_impact");
	level._effect["a_puddle_debris_splash"]	= loadfx("env/water/fx_wtr_splash_debris_sm");
	level._effect["a_shuri_collapse_gate"]	= loadfx("maps/oki3/fx_shuri_collapse_gate");
	level._effect["a_roof_collapse_bomb"]	= loadfx("maps/oki3/fx_roof_collapse_bomb");
	level._effect["a_exp_mortarpit_bldg01"]	= loadfx("maps/oki3/fx_exp_mortarpit_bldg01");
	level._effect["a_exp_mortarpit_bldg02"]	= loadfx("maps/oki3/fx_exp_mortarpit_bldg02");
	
	// Lights -- BA Section --
	level._effect["lantern_on_global"]	= LoadFX( "env/light/fx_lights_lantern_on" );	
}

/*------------------------------------
light under the bunkers in the tunnel
------------------------------------*/
tunnel_light()
{
	
	//playfx(level._effect["tunnel_light_fx"],(3354, 2268, -913), anglestoforward( (90,0,0)));
	
//	level._explosion_stop_barrage["ambush_mortars"] = true;
//	//wait(randomintrange(2,6));
//	level._explosion_stop_barrage["dirt_mortar"] = true;
	
	//grab the lantern model
	lantern = getent("lantern","script_noteworthy");
	lght = getent("lamp_light","targetname");
	
	
	// CODER_MOD : DSL 06/11/08 - Lights are clientsided - prevent undefined reference crash...
	
	if(!isdefined(lght))
		return;
	
	lght linkto(lantern);
	lght setlightintensity(2.1);
	
	mdl = spawn("script_model",lantern.origin);
	mdl.angles = (90,0,0);
	mdl setmodel("tag_origin");
	mdl linkto(lantern);
	playfxontag(level._effect["tunnel_light_fx"],mdl,"tag_origin");
	
	lantern thread monitor_lantern_dmg(mdl,lght);	
	//wait until the mortars start falling before putting the lantern into physics mode
	while(!isDefined(level.mortars_falling))
	{
		wait 1;
	}		
	while(level.mortars_falling)
	{
		level waittill("explosion");
		
		//15% chance to shake the light each time a mortar goes off
		if( randomint(100) < 15)
		{
			//commented out until bug is fixed
			lantern physicslaunch ( lantern.origin, (randomintrange(-20,20),randomintrange(-20,20),randomintrange(-20,20)) );
			wait(3);
		}
	}
}

monitor_lantern_dmg(mdl,lght)
{
	self setcandamage(true);
	candamage = true;
	dmg = 0;
	damaged = false;
	
	while(candamage )
	{
		self waittill("damage",amount,attacker);
		if(isPlayer(attacker))
		{
			//alert the guys around if the player shoots the lamp out 
			if(!isDefined(level.tunnel_guys_alerted))
			{
				level thread maps\oki3::alert_tunnel_guys();
			}
			
			if(damaged && dmg > 100)
			{
				ropeid = getrope( "tunnel_rope" );
				breakrope(ropeid,0);
				candamage = false;
			}
			dmg = dmg + amount;
			if(dmg > 15 && !damaged)
			{
				damaged = true;
				lght setlightintensity(0.01);
				self setmodel("lights_tinhatlamp_off");
				mdl delete();
				mdl2 = spawn("script_model",self.origin);
				mdl2 linkto(self);
				mdl2 setmodel("tag_origin");
				self thread light_zort(mdl2);
				maps\_utility::arcademode_assignpoints( "arcademode_score_generic250", attacker );			
			}
		}
	}	
}

light_zort(mdl)
{
	x=0;
	while(x<10)
	{
		playfxontag(level._effect["zort"],mdl,"tag_origin");
		self playsound("radio_destroyed");
		wait(randomfloatrange(.9,2.5));
		x++;
	}
	mdl delete();
}

mortarpits_fake_launch()
{
	ents = getstructarray("fake_mortar","targetname");
	while(!flag("stop_fake_mortar"))
	{
		for(i=0;i<ents.size;i++)
		{
			thread fake_launch(ents[i]);

			wait(randomfloat(2));				
		}
		wait(randomintrange(4,7));
	}
}

fake_launch(org)
{
	targs = getstructarray("dirt_mortar","targetname");
	playsoundatposition(level.scr_sound["mortar_flash"],org.origin);
	playfx(level._effect["mortar_flash"],org.origin,anglestoforward(org.angles));
	wait(randomintrange(4,7));
	targ = targs[randomint(targs.size)];
	playsoundatposition("mortar_dirt",targ.origin);
	playfx(level._effect["dirt_mortar"],targ.origin);
	earthquake(0.15,2.5,targ.origin,3000);
}



