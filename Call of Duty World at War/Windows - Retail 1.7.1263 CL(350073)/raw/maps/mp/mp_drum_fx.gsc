#include maps\mp\_utility;

main()
{
	maps\mp\createart\mp_drum_art::main();
	precacheFX();
	spawnFX();
	
	thread water_settings();
}
water_settings()

{
  //-- All of these values are modded values from Pel1--BarryW
  /* Water Dvars                          Default Values   							What They Do
  ========================                ==============                ================================
  r_watersim_enabled                      default=true                  Enables dynamic water simulation
  r_watersim_debug                        default=false                 Enables bullet debug markers
  r_watersim_flatten                      default=false                 Flattens the water surface out
  r_watersim_waveSeedDelay                default=500.0                 Time between seeding a new wave (ms)
  r_watersim_curlAmount                   default=0.5                   Amount of curl applied
  r_watersim_curlMax                      default=0.4                   Maximum curl limit
  r_watersim_curlReduce                   default=0.95                  Amount curl gets reduced by when over limit
  r_watersim_minShoreHeight               default=0.04                  Allows water to lap over the shoreline edge
  r_watersim_foamAppear                   default=20.0                  Rate foam appears at
  r_watersim_foamDisappear                default=0.78                  Rate foam disappears at
  r_watersim_windAmount                   default=0.02                  Amount of wind applied
  r_watersim_windDir                      default=45.0                  Wind direction (degrees)
  r_watersim_windMax                      default=0.4                   Maximum wind limit
  r_watersim_particleGravity              default=0.03                  Particle gravity
  r_watersim_particleLimit                default=2.5                   Limit at which particles get spawned
  r_watersim_particleLength               default=0.03                  Length of each particle
  r_watersim_particleWidth                default=2.0                   Width of each particle
            */

	SetDvar( "r_watersim_waveSeedDelay", 10 );
	SetDvar( "r_watersim_curlAmount", 0.18 );
	SetDvar( "r_watersim_curlMax", 0.32 );
	SetDvar( "r_watersim_curlReduce", 0.261 );
	SetDvar( "r_watersim_minShoreHeight", 0.358 );
	SetDvar( "r_watersim_foamAppear", 3.01 );
	SetDvar( "r_watersim_foamDisappear", 0.40 );
	SetDvar( "r_watersim_windAmount", 0.179 );
	SetDvar( "r_watersim_windDir", 275 );
	SetDvar( "r_watersim_windMax", 2.69 );
	SetDvar( "r_watersim_particleGravity", 0.03 );
	SetDvar( "r_watersim_particleLimit", 2.5 );
	SetDvar( "r_watersim_particleLength", 0.03 );
	SetDvar( "r_watersim_particleWidth", 2.0 );	        

}

precacheFX()
{
	level._effect["mp_fire_rubble_md_smk"]						= loadfx("maps/mp_maps/fx_mp_fire_rubble_md_smk");
	level._effect["mp_fire_column_xsm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_xsm");
	level._effect["mp_fire_column_sm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_sm");
	level._effect["mp_fire_dlight"]										= loadfx("maps/mp_maps/fx_mp_fire_dlight");
	level._effect["mp_fire_dlight_sm"]								= loadfx("maps/mp_maps/fx_mp_fire_dlight_sm");
	level._effect["mp_roof_ash_embers"]							  = loadfx("maps/mp_maps/fx_mp_roof_ash_embers");
	
	level._effect["mp_smoke_plume_lg"]								= loadfx("maps/mp_maps/fx_mp_smoke_plume_lg");
	level._effect["mp_smoke_plume_med"]								= loadfx("maps/mp_maps/fx_mp_smoke_plume_med_slow_def");
	level._effect["mp_smoke_sm_slow"]									= loadfx("maps/mp_maps/fx_mp_smoke_sm_slow");
	level._effect["mp_smoke_crater"]									= loadfx("maps/mp_maps/fx_mp_smoke_crater");

	level._effect["mp_ray_light_sm"]									= loadfx("env/light/fx_light_godray_overcast_sm");
	level._effect["light_godray_overcast_xsm"]				= loadfx("env/light/fx_light_godray_overcast_xsm");
	level._effect["mp_ray_slit"]											= loadfx("maps/mp_maps/fx_mp_ray_slit");	

	level._effect["mp_water_drips_hvy_long"]					= loadfx("maps/mp_maps/fx_mp_water_drips_hvy_long");
	level._effect["mp_water_drips_rust"]							= loadfx("maps/mp_maps/fx_mp_water_drips_rust");
	level._effect["mp_water_wake_wide"]								= loadfx("maps/mp_maps/fx_mp_water_wake_wide");
	level._effect["mp_water_shimmers"]								= loadfx("maps/mp_maps/fx_mp_water_shimmers");
	level._effect["mp_water_wake_pillar"]							= loadfx("maps/mp_maps/fx_mp_water_wake_pillar");
	level._effect["mp_wavebreak_runner"]							= loadfx("maps/mp_maps/fx_mp_wavebreak_runner");
	
	level._effect["mp_dust_motes"]										= loadfx("maps/mp_maps/fx_mp_ray_motes_lg");
	level._effect["mp_dust_motes_md"]									= loadfx("maps/mp_maps/fx_mp_ray_motes_md");
	
	level._effect["mp_light_glow_indoor_short_red"]		= loadfx("maps/mp_maps/fx_mp_light_glow_indoor_short_red");
	level._effect["mp_flashlight_yellow"]							= loadfx("maps/mp_maps/fx_mp_flashlight_yellow");
	
	level._effect["mp_elec_spark_runner"]							= loadfx("maps/mp_maps/fx_mp_elec_spark_runner");
	level._effect["mp_pipe_steam_lg"]									= loadfx("maps/mp_maps/fx_mp_pipe_steam_lg");
	level._effect["mp_insect_swarm"]									= loadfx("maps/mp_maps/fx_mp_insect_swarm");
	level._effect["mp_fog_low_brown_thick"]						= loadfx("maps/mp_maps/fx_mp_fog_low_brown_thick");
	level._effect["mp_sea_mist_rolling"]							= loadfx("maps/mp_maps/fx_mp_sea_mist_rolling");
	level._effect["mp_birds_circling"]								= loadfx("maps/mp_maps/fx_mp_birds_circling");
	level._effect["mp_sea_mine"]											= loadfx("maps/mp_maps/fx_mp_sea_mine");
	level._effect["mp_seaweed"]												= loadfx("maps/mp_maps/fx_mp_seaweed");													
}

spawnFX()
{
	maps\mp\createfx\mp_drum_fx::main();
}