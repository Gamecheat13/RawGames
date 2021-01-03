#using scripts\codescripts\struct;
#using scripts\shared\util_shared;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

//#precache( "client_fx", "electric/fx_elec_sparks_burst_sm_circuit_os" );	

// Ritual progress effects
#precache( "client_fx", "zombie/fx_ritual_altar_zod_zmb" );
#precache( "client_fx", "zombie/fx_ritual_key_trail_zod_zmb" );
#precache( "client_fx", "zombie/fx_ritual_sacrafice_glow_chest_zod_zmb" );
#precache( "client_fx", "zombie/fx_ritual_sacrafice_glow_head_zod_zmb" );
#precache( "client_fx", "zombie/fx_ritual_sacrafice_death_zod_zmb" );
// Pack-a-Punch Room
#precache( "client_fx", "zombie/fx_ritual_altar_pap_zod_zmb" ); // fire for the quest key altar in the Pack-a-Punch Room
// Cocoon
#precache( "client_fx", "zombie/fx_idgun_cocoon_wrap_zod_zmb" );
#precache( "client_fx", "zombie/fx_idgun_cocoon_explo_zod_zmb" );
// Crane Light
#precache( "client_fx", "light/fx_light_zm_crane_light" );
// Cultist Crate effects
#precache( "client_fx", "zombie/fx_cultist_crate_smk_zod_zmb" );
// Octobomb
#precache( "client_fx", "zombie/fx_octobomb_scurry_trail_zod_zmb" ); // Additive scurry trail
#precache( "client_fx", "zombie/fx_octobomb_splash_sm_zod_zmb" ); // Mouse hole splash for previous to dash starting
#precache( "client_fx", "zombie/fx_octobomb_splash_lg_zod_zmb" ); // Mouse hole splash for moment of dash
// Portal Shortcuts
#precache( "client_fx", "zombie/fx_portal_rift_zod_zmb" ); // the unformed portal
#precache( "client_fx", "zombie/fx_portal_shortcut_zod_zmb" ); // the stable portal


function main()
{
	precache_createfx_fx();
	precache_scripted_fx();
}

function precache_scripted_fx()
{
	// ritual progress effects
	level._effect[ "ritual_altar" ]			= "zombie/fx_ritual_altar_zod_zmb";
	level._effect[ "ritual_trail" ]			= "zombie/fx_ritual_key_trail_zod_zmb";
	level._effect[ "ritual_glow_chest" ]	= "zombie/fx_ritual_sacrafice_glow_chest_zod_zmb";
	level._effect[ "ritual_glow_head" ]		= "zombie/fx_ritual_sacrafice_glow_head_zod_zmb";
	level._effect[ "ritual_bloodsplosion" ]	= "zombie/fx_ritual_sacrafice_death_zod_zmb";
	
	// Cocoon
	level._effect[ "idgun_cocoon_on" ]		= "zombie/fx_idgun_cocoon_wrap_zod_zmb";
	level._effect[ "idgun_cocoon_off" ]		= "zombie/fx_idgun_cocoon_explo_zod_zmb";
	
	// Pack-a-Punch Room
	level._effect[ "pap_altar_glow" ]		= "zombie/fx_ritual_altar_pap_zod_zmb"; // fire for the quest key altar in the Pack-a-Punch Room
	
	// Crane Light
	level._effect[ "crane_light" ]			= "light/fx_light_zm_crane_light";
	
	// Cultist Crate effects
	level._effect[ "cultist_crate_personal_item" ]	= "zombie/fx_cultist_crate_smk_zod_zmb";

	// Octobomb	
	level._effect[ "octobomb_dash_during" ]		= "zombie/fx_octobomb_scurry_trail_zod_zmb";
	level._effect[ "octobomb_dash_before" ]		= "zombie/fx_octobomb_splash_sm_zod_zmb";
	level._effect[ "octobomb_dash_start" ]		= "zombie/fx_octobomb_splash_lg_zod_zmb";
	
	// Portal Shortcuts
	level._effect[ "portal_shortcut_closed" ] 	= "zombie/fx_portal_rift_zod_zmb";
	level._effect[ "portal_shortcut_open" ]		= "zombie/fx_portal_shortcut_zod_zmb";
}

function precache_createfx_fx()
{
	//level._effect["zombie_grain"]					= "misc/fx_zombie_grain_cloud";
}
