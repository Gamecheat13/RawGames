#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       


//#precache( "fx", "env/zombie/fx_dust_ceiling_impact_lg_mdbrown" );
#precache( "fx", "_t6/maps/zombie/fx_dust_ceiling_impact_lg_mdbrown" );

#precache( "fx", "zombie/fx_barrier_buy_zmb" );
#precache( "fx", "destructibles/fx_dest_fire_vert" );
#precache( "fx", "electric/fx_elec_sparks_directional_orange" );
#precache( "fx", "electrical/fx_elec_wire_spark_dl_oneshot" );
	
#precache( "fx", "zombie/fx_dog_eyes_zmb" );
#precache( "fx", "zombie/fx_dog_explosion_zmb" );
#precache( "fx", "zombie/fx_dog_fire_trail_zmb" );
#precache( "fx", "zombie/fx_dog_ash_trail_zmb" );
#precache( "fx", "zombie/fx_dog_breath_zmb" );	
	
#precache( "fx", "zombie/fx_weapon_box_marker_zmb" );
#precache( "fx", "zombie/fx_weapon_box_marker_fl_zmb" );

#precache( "fx", "weapon/fx_betty_exp" );
#precache( "fx", "weapon/fx_betty_launch_dust" );

#precache( "fx", "zombie/fx_elec_trap_zmb" );
#precache( "fx", "maps/zombie/fx_zombie_light_glow_green" );
#precache( "fx", "maps/zombie/fx_zombie_light_glow_red" );
#precache( "fx", "fx_zombie_light_elec_room_on" );
#precache( "fx", "zombie/fx_elec_player_md_zmb" );
#precache( "fx", "zombie/fx_elec_player_sm_zmb" );
#precache( "fx", "zombie/fx_elec_player_torso_zmb" );

#precache( "fx", "electric/fx_elec_sparks_burst_sm_circuit_os" );
#precache( "fx", "electric/fx_elec_sparks_burst_sm_circuit_os" );
#precache( "fx", "zombie/fx_powerup_on_green_zmb" );

/*
#precache( "fx", "maps/zombie_old/fx_mp_battlesmoke_thin_lg" );
#precache( "fx", "maps/zombie_old/fx_mp_fire_150x150_tall_distant" );
#precache( "fx", "maps/zombie_old/fx_mp_fire_150x600_tall_distant" );
#precache( "fx", "maps/zombie_old/fx_mp_fire_small_detail" );
#precache( "fx", "maps/zombie_old/fx_mp_fire_window_smk_rt" );
#precache( "fx", "maps/zombie_old/fx_mp_fire_window_smk_lf" );
#precache( "fx", "maps/zombie_old/fx_mp_fire_window" );
#precache( "fx", "maps/zombie_old/fx_mp_fire_rubble_small" );
#precache( "fx", "maps/zombie_old/fx_mp_fire_rubble_md_smk" );
#precache( "fx", "maps/zombie_old/fx_mp_fire_rubble_md_lowsmk" );
#precache( "fx", "maps/zombie_old/fx_mp_fire_rubble_detail_grp" );
#precache( "fx", "maps/zombie_old/fx_mp_ray_fire_thin" );
//#precache( "fx", "maps/mp_maps/fx_mp_fire_column_sm" );
#precache( "fx", "maps/mp_maps/fx_mp_fire_column_lg" );
#precache( "fx", "maps/zombie_old/fx_mp_fire_furnace" );
	
#precache( "fx", "maps/zombie_old/fx_mp_smoke_fire_column" );
#precache( "fx", "maps/zombie_old/fx_mp_smoke_plume_lg" );
#precache( "fx", "maps/zombie_old/fx_mp_smoke_hall" );
#precache( "fx", "maps/zombie_old/fx_mp_ash_falling_large" );
#precache( "fx", "maps/zombie_old/fx_mp_light_glow_indoor_short_loop" );
#precache( "fx", "maps/zombie_old/fx_mp_light_glow_outdoor_long_loop" );
#precache( "fx", "maps/zombie_old/fx_mp_insects_lantern" );
#precache( "fx", "maps/zombie_old/fx_mp_fire_torch_noglow" );	
*/

#precache( "fx", "env/fire/fx_embers_falling_sm" );
	
//#precache( "fx", "maps/ber3/fx_tracers_flak88_amb" );
//#precache( "fx", "maps/mp_maps/fx_mp_flak_field" );
//#precache( "fx", "maps/mp_maps/fx_mp_flak_field_flash" );

//#precache( "fx", "destructibles/fx_dest_fire_vert" );	
//#precache( "fx", "maps/zombie_old/fx_mp_light_lamp" );
#precache( "fx", "zombie/fx_smk_stack_burning_zmb" );
#precache( "fx", "electric/fx_elec_sparks_burst_sm_circuit_os" );
#precache( "fx", "zombie/fx_elec_gen_idle_zmb" );
#precache( "fx", "zombie/fx_moon_eclipse_zmb" );
#precache( "fx", "zombie/fx_clock_hand_zmb" );
#precache( "fx", "zombie/fx_elec_pole_terminal_zmb" );
#precache( "fx", "electric/fx_elec_sparks_burst_sm_circuit_os" );	
//#precache( "fx", "maps/zombie_old/fx_mp_light_lamp_no_eo" );																									

#precache( "fx", "electric/fx_elec_sparks_burst_sm_circuit_os" );

function autoexec __init__sytem__() {     system::register("zm_factory_fx",&__init__,undefined,undefined);    }
	
function __init__()
{
	level thread run_door_fxanim( "enter_outside_east", "fxanim_outside_east_door_snow", "door_snow_a_open" );
	level thread run_door_fxanim( "enter_outside_west", "fxanim_outside_west_door_snow", "door_snow_b_open" );
	level thread run_door_fxanim( "enter_tp_south", "fxanim_south_courtyard_door_lft_snow", "door_snow_c_open" );
	level thread run_door_fxanim( "enter_tp_south", "fxanim_south_courtyard_door_rt_snow" );
}

function main()
{
	precache_scripted_fx();
	precache_createfx_fx();
	//zm_factory_fx::main();
}

function run_door_fxanim( str_flag, str_scene, str_exploder )
{
	level waittill( "start_zombie_round_logic" );
	level flag::wait_till( str_flag );

	if ( IsDefined( str_scene ) )
	{
		level thread scene::play( str_scene, "targetname" );
	}

	if ( IsDefined( str_exploder ) )
	{
		level thread exploder::exploder( str_exploder );
	}
}

function precache_scripted_fx()
{
	//level._effect["large_ceiling_dust"]				= "env/zombie/fx_dust_ceiling_impact_lg_mdbrown";
	level._effect["large_ceiling_dust"]					= "_t6/maps/zombie/fx_dust_ceiling_impact_lg_mdbrown";


	level._effect["poltergeist"]						= "zombie/fx_barrier_buy_zmb";
	level._effect["gasfire"]							= "destructibles/fx_dest_fire_vert";
	level._effect["switch_sparks"]						= "electric/fx_elec_sparks_directional_orange";
	level._effect["wire_sparks_oneshot"]				= "electrical/fx_elec_wire_spark_dl_oneshot";
	

	level._effect["dog_eye_glow"]						= "zombie/fx_dog_eyes_zmb";
	level._effect["dog_gib"]							= "zombie/fx_dog_explosion_zmb";
	level._effect["dog_trail_fire"]						= "zombie/fx_dog_fire_trail_zmb";
	level._effect["dog_trail_ash"]						= "zombie/fx_dog_ash_trail_zmb";
	level._effect["dog_breath"]							= "zombie/fx_dog_breath_zmb";	
	
	level._effect["lght_marker"]						= "zombie/fx_weapon_box_marker_zmb";
	level._effect["lght_marker_flare"]					= "zombie/fx_weapon_box_marker_fl_zmb";

	level._effect["betty_explode"]						= "weapon/fx_betty_exp";
	level._effect["betty_trail"]						= "weapon/fx_betty_launch_dust";

	level._effect["zapper"]								= "zombie/fx_elec_trap_zmb";
	level._effect["zapper_light_ready"]					= "maps/zombie/fx_zombie_light_glow_green";
	level._effect["zapper_light_notready"]				= "maps/zombie/fx_zombie_light_glow_red";
	level._effect["elec_room_on"]						= "fx_zombie_light_elec_room_on";
	level._effect["elec_md"]							= "zombie/fx_elec_player_md_zmb";
	level._effect["elec_sm"]							= "zombie/fx_elec_player_sm_zmb";
	level._effect["elec_torso"]							= "zombie/fx_elec_player_torso_zmb";

	level._effect["elec_trail_one_shot"]				= "electric/fx_elec_sparks_burst_sm_circuit_os";
	level._effect["wire_spark"]							= "electric/fx_elec_sparks_burst_sm_circuit_os";
	level._effect["powerup_on"]							= "zombie/fx_powerup_on_green_zmb";
}

function precache_createfx_fx()
{
	/*level._effect["mp_battlesmoke_lg"]					= "maps/zombie_old/fx_mp_battlesmoke_thin_lg";
	level._effect["mp_fire_distant_150_150"]			= "maps/zombie_old/fx_mp_fire_150x150_tall_distant";
	level._effect["mp_fire_distant_150_600"]			= "maps/zombie_old/fx_mp_fire_150x600_tall_distant";
	level._effect["mp_fire_static_small_detail"]		= "maps/zombie_old/fx_mp_fire_small_detail";
	level._effect["mp_fire_window_smk_rt"]				= "maps/zombie_old/fx_mp_fire_window_smk_rt";
	level._effect["mp_fire_window_smk_lf"]				= "maps/zombie_old/fx_mp_fire_window_smk_lf";
	level._effect["mp_fire_window"]						= "maps/zombie_old/fx_mp_fire_window";
	level._effect["mp_fire_rubble_small"]				= "maps/zombie_old/fx_mp_fire_rubble_small";
	level._effect["mp_fire_rubble_md_smk"]				= "maps/zombie_old/fx_mp_fire_rubble_md_smk";
	level._effect["mp_fire_rubble_md_lowsmk"]			= "maps/zombie_old/fx_mp_fire_rubble_md_lowsmk";
	level._effect["mp_fire_rubble_detail_grp"]			= "maps/zombie_old/fx_mp_fire_rubble_detail_grp";
	level._effect["mp_ray_fire_thin"]					= "maps/zombie_old/fx_mp_ray_fire_thin";
//	level._effect["mp_fire_column_sm"]					= "maps/mp_maps/fx_mp_fire_column_sm";
	level._effect["mp_fire_column_lg"]					= "maps/mp_maps/fx_mp_fire_column_lg";
	level._effect["mp_fire_furnace"]					= "maps/zombie_old/fx_mp_fire_furnace";
	
	level._effect["mp_smoke_fire_column"]				= "maps/zombie_old/fx_mp_smoke_fire_column";
	level._effect["mp_smoke_plume_lg"]					= "maps/zombie_old/fx_mp_smoke_plume_lg";
	level._effect["mp_smoke_hall"]						= "maps/zombie_old/fx_mp_smoke_hall";
	level._effect["mp_ash_and_embers"]					= "maps/zombie_old/fx_mp_ash_falling_large";
	level._effect["mp_light_glow_indoor_short"]			= "maps/zombie_old/fx_mp_light_glow_indoor_short_loop";
	level._effect["mp_light_glow_outdoor_long"]			= "maps/zombie_old/fx_mp_light_glow_outdoor_long_loop";
	level._effect["mp_insects_lantern"]					= "maps/zombie_old/fx_mp_insects_lantern";
	level._effect["fx_mp_fire_torch_noglow"]			= "maps/zombie_old/fx_mp_fire_torch_noglow";	
*/	
	level._effect["a_embers_falling_sm"]				= "env/fire/fx_embers_falling_sm";
	
// 	level._effect["a_tracers_flak88_amb"]				= "maps/ber3/fx_tracers_flak88_amb";
//	level._effect["mp_flak_field"]						= "maps/mp_maps/fx_mp_flak_field";
//	level._effect["mp_flak_field_flash"]				= "maps/mp_maps/fx_mp_flak_field_flash";
	
//	level._effect["gasfire2"]							= "destructibles/fx_dest_fire_vert";	
//	level._effect["mp_light_lamp"]						= "maps/zombie_old/fx_mp_light_lamp";
	level._effect["mp_smoke_stack"]						= "zombie/fx_smk_stack_burning_zmb";
	level._effect["mp_elec_spark_fast_random"]			= "electric/fx_elec_sparks_burst_sm_circuit_os";
	level._effect["zombie_elec_gen_idle"]				= "zombie/fx_elec_gen_idle_zmb";
	level._effect["zombie_moon_eclipse"]				= "zombie/fx_moon_eclipse_zmb";
	level._effect["zombie_clock_hand"]					= "zombie/fx_clock_hand_zmb";
	level._effect["zombie_elec_pole_terminal"]			= "zombie/fx_elec_pole_terminal_zmb";
	level._effect["mp_elec_broken_light_1shot"]			= "electric/fx_elec_sparks_burst_sm_circuit_os";	
//	level._effect["mp_light_lamp_no_eo"]				= "maps/zombie_old/fx_mp_light_lamp_no_eo";																									

	level._effect["electric_short_oneshot"]				= "electric/fx_elec_sparks_burst_sm_circuit_os";
}

