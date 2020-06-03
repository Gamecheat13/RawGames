// _t34.gsc
// Sets up the behavior for the T34 Tank and variants.

#include maps\mp\_vehicles;

main(model,type)
{
	model = "vehicle_rus_tracked_t34_mp";
	build_template( "t34", model, type );
	build_exhaust( "vehicle/exhaust/fx_exhaust_t34" );
	build_treadfx( type );
	build_rumble( "tank_rumble_mp", 0.1, 2, 500, 0.1, 0 );
	loadfx( "destructibles/fx_dest_tank_t34_tread_lf_0" );
	loadfx( "destructibles/fx_dest_tank_t34_tread_lf_1" );
	loadfx( "destructibles/fx_dest_tank_t34_tread_rt_0" );
	loadfx( "destructibles/fx_dest_tank_t34_tread_rt_1" );
	loadfx( "destructibles/fx_dest_tank_tread_lf_exp" );
	loadfx( "destructibles/fx_dest_tank_tread_rt_exp" );
	loadfx( "destructibles/fx_dest_tank_t34_tread_lf_grind" );
	loadfx( "destructibles/fx_dest_tank_t34_tread_rt_grind" );
}

build_damage_states()
{
// damage indices
	k_mild_damage_index= 0;
	k_moderate_damage_index= 1;
	k_severe_damage_index= 2;
	k_total_damage_index= 3;
	
	// health_percentage constants
	k_mild_damage_health_percentage= 0.75;
	k_moderate_damage_health_percentage= 0.5;
	k_severe_damage_health_percentage= 0.25;
	k_total_damage_health_percentage= 0;

	vehicle_name = "t34_mp";
	{
		level.vehicles_damage_states[vehicle_name]= [];
		level.vehicles_damage_treadfx[vehicle_name] = [];
		// mild damage
		{
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index].health_percentage= k_mild_damage_health_percentage;
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array= [];
			// effect '0' - placed @ "tag_origin"
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array[0]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array[0].damage_effect= loadFX("vehicle/vfire/fx_vdamage_rus_t34_mp01"); // smoldering (smoke puffs)
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array[0].sound_effect= undefined;
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array[0].vehicle_tag= "tag_origin";
			level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array[0].damage_effect_loop_time= 0.2;
		}
		// moderate damage
		{
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].health_percentage= k_moderate_damage_health_percentage;
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array= [];
			// effect '0' - placed @ "tag_origin"
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array[0]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array[0].damage_effect= loadFX("vehicle/vfire/fx_vdamage_rus_t34_mp02"); // flames & more smoke
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array[0].sound_effect= undefined;
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array[0].vehicle_tag= "tag_origin";
			level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array[0].damage_effect_loop_time= 0.2;
		}
		// severe damage
		{
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index].health_percentage= k_severe_damage_health_percentage;
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array= [];
			// effect '0' - placed @ "tag_origin"
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array[0]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array[0].damage_effect= loadFX("vehicle/vfire/fx_vdamage_rus_t34_mp03"); // pillar of smoke
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array[0].sound_effect= undefined;
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array[0].vehicle_tag= "tag_origin";
			level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array[0].damage_effect_loop_time= 0.2;
		}
		// total damage
		{
			level.vehicles_damage_states[vehicle_name][k_total_damage_index]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].health_percentage= k_total_damage_health_percentage;
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array= [];
			// effect '0' - placed @ "tag_origin"
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[0]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[0].damage_effect= loadFX("vehicle/vfire/fx_vdamage_rus_t34_mp04");
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[0].sound_effect= undefined;
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[0].vehicle_tag= "tag_origin";
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[0].damage_effect_loop_time= 0.2;
				
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[1]= SpawnStruct();
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[1].damage_effect= loadFX("vehicle/vfire/fx_vexplode_rus_t34_mp");
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[1].sound_effect= "exp_suitcase_bomb_main"; // kaboom!
			level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[1].vehicle_tag= "tag_origin";
		}

		/*level.vehicles_damage_treadfx[vehicle_name][0] = SpawnStruct();
		level.vehicles_damage_treadfx[vehicle_name][0].damage_effect = loadFX("vehicle/treadfx/fx_treadfx_t34_damage_lft");
		level.vehicles_damage_treadfx[vehicle_name][0].sound_effect = undefined;
		level.vehicles_damage_treadfx[vehicle_name][0].vehicle_tag = "tag_origin";
		level.vehicles_damage_treadfx[vehicle_name][0].damage_effect_loop_time = 0.1;
		level.vehicles_damage_treadfx[vehicle_name][1] = SpawnStruct();
		level.vehicles_damage_treadfx[vehicle_name][1].damage_effect = loadFX("vehicle/treadfx/fx_treadfx_t34_damage_rt");
		level.vehicles_damage_treadfx[vehicle_name][1].sound_effect = undefined;
		level.vehicles_damage_treadfx[vehicle_name][1].vehicle_tag = "tag_origin";
		level.vehicles_damage_treadfx[vehicle_name][1].damage_effect_loop_time = 0.1;*/
		
		{
			default_husk_effects = SpawnStruct();
			default_husk_effects.damage_effect = undefined;//loadFX("vehicle/vfire/fx_vfire_med_12"); // flames & more smoke
			default_husk_effects.sound_effect = undefined;
			default_husk_effects.vehicle_tag = "tag_origin";
			
			level.vehicles_husk_effects[ vehicle_name ] = default_husk_effects;
		}
	}
}