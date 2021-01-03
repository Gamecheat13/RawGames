#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

//#precache( "fx", "electric/fx_elec_sparks_burst_sm_circuit_os" );
 
// Rain test effects
#precache( "fx", "weather/fx_rain_system_lite_runner" ); 
#precache( "fx", "weather/fx_rain_system_med_runner" );
#precache( "fx", "weather/fx_rain_system_hvy_runner" );

// ritual zombie stand-out effects
#precache( "fx", "fire/fx_fire_barrel_md" );

// shortcut portal
#precache( "fx", "zombie/fx_portal_bamf_zod_zmb" );

// cultist crate glow (for personal item crates)
#precache( "fx", "zombie/fx_cultist_crate_smk_zod_zmb" );

// keeper spawn vfx
#precache( "fx", "zombie/fx_portal_keeper_spawn_zod_zmb" );
// keeper stand-out effects
#precache( "fx", "zombie/fx_keeper_ambient_torso_zod_zmb" );
// glows to play on quest items
#precache( "fx", "zombie/fx_ritual_glow_key_zod_zmb" ); // quest key glow
#precache( "fx", "zombie/fx_ritual_glow_memento_zod_zmb" ); // personal item glow
#precache( "fx", "zombie/fx_ritual_glow_relic_zod_zmb" ); // gateworm glow
// basin fire
#precache( "fx", "zombie/fx_ritual_pap_basin_fire_zod_zmb" );
#precache( "fx", "zombie/fx_ritual_pap_basin_fire_lg_zod_zmb" );
// Cultist Crate effects
#precache( "fx", "zombie/fx_cultist_crate_smk_zod_zmb" );
	

function main()
{
	precache_scripted_fx();
	precache_createfx_fx();
}

function precache_scripted_fx()
{
	//level._effect["large_ceiling_dust"]				= "env/zombie/fx_dust_ceiling_impact_lg_mdbrown";

	//Rain test effects
	level._effect[ "rain_light" ]					= "weather/fx_rain_system_lite_runner";
	level._effect[ "rain_medium" ]					= "weather/fx_rain_system_med_runner";
	level._effect[ "rain_heavy" ]					= "weather/fx_rain_system_hvy_runner";
	
	// portal effects
	level._effect[ "portal_3p" ] 					= "zombie/fx_portal_bamf_zod_zmb";

	// keeper spawn point vfx
	level._effect[ "keeper_spawn" ] 				= "zombie/fx_portal_keeper_spawn_zod_zmb";
	// keeper stand-out effects
	level._effect[ "fire_head" ]					= "zombie/fx_keeper_ambient_torso_zod_zmb";	
	// glows to play on quest items
	level._effect[ "ritual_key_glow" ]				= "zombie/fx_ritual_glow_key_zod_zmb";
	level._effect[ "relic_glow" ]					= "zombie/fx_ritual_glow_relic_zod_zmb";
	level._effect[ "memento_glow" ]					= "zombie/fx_ritual_glow_memento_zod_zmb";
	// basin fire for when a gateworm is placed
	level._effect[ "pap_basin_glow" ]				= "zombie/fx_ritual_pap_basin_fire_zod_zmb";
	level._effect[ "pap_basin_glow_lg" ]			= "zombie/fx_ritual_pap_basin_fire_lg_zod_zmb";	
	// Cultist Crate effects
	level._effect[ "cultist_crate_personal_item" ]	= "zombie/fx_cultist_crate_smk_zod_zmb";
}

function precache_createfx_fx()
{
	//level._effect["a_embers_falling_sm"]				= "env/fire/fx_embers_falling_sm";
}
