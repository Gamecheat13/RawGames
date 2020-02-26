precache()
{
	PrecacheTurret("bigdog_dual_turret");

	LoadFx( "env/electrical/fx_elec_bigdog_spark_lg_runner" );
	LoadFx( "explosions/fx_large_vehicle_explosion" );
	LoadFx( "destructibles/fx_claw_metal_scrape_sparks" );
	LoadFx( "destructibles/fx_claw_exp_panel" );
	LoadFx( "destructibles/fx_claw_exp_panel_lg" );
	LoadFx( "destructibles/fx_claw_exp_leg_break" );
	LoadFx( "destructibles/fx_claw_stun_electric" );
	LoadFx( "destructibles/fx_claw_dmg_smk_lt" );
	
	// semtex grenade
	loadfx( "weapon/crossbow/fx_trail_crossbow_blink_grn_os" );
	loadfx( "weapon/crossbow/fx_trail_crossbow_blink_red_os" );
}