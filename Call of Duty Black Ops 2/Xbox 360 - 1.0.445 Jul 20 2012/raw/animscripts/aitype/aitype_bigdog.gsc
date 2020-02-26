precache()
{
	PrecacheTurret("bigdog_dual_turret");
	
	PrecacheModel( "veh_t6_drone_claw_mk2_dead" );

	LoadFx( "env/electrical/fx_elec_bigdog_spark_lg_runner" );
	LoadFx( "destructibles/fx_claw_exp_death" );
	LoadFx( "destructibles/fx_claw_metal_scrape_sparks" );
	LoadFx( "destructibles/fx_claw_exp_panel" );
	LoadFx( "destructibles/fx_claw_exp_panel_lg" );
	LoadFx( "destructibles/fx_claw_exp_leg_break" );
	LoadFx( "destructibles/fx_claw_stun_electric" );
	LoadFx( "destructibles/fx_claw_dmg_smk_lt" );
	
	LoadFx( "dirt/fx_dust_impact_claw" );
	
	// semtex grenade
	loadfx( "weapon/crossbow/fx_trail_crossbow_blink_grn_os" );
	loadfx( "weapon/crossbow/fx_trail_crossbow_blink_red_os" );
}