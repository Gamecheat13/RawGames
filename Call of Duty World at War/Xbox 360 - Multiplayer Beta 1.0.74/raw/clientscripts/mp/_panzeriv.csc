// _panzeriv.csc
// Sets up clientside behavior for the panzeriv

#include clientscripts\mp\_vehicle;

main(model,type)
{
	model = "vehicle_ger_tracked_panzer4_mp";
	type = "panzer4_mp";
	build_exhaust( model, "vehicle/exhaust/fx_exhaust_panzerIV" );
	build_treadfx( "panzer4_mp" );
	build_rumble( "panzer4_mp", "tank_rumble_mp", 0.1, 2, 500, 0.1, 0 );
	level.tread_damage_fx[ type ] = [];
	level.tread_damage_fx[ type ][0] = [];
	level.tread_damage_fx[ type ][1] = [];
	level.tread_damage_fx[ type ][0][0] = loadfx( "destructibles/fx_dest_tank_panzer_tread_lf_0" );
	level.tread_damage_fx[ type ][0][1] = loadfx( "destructibles/fx_dest_tank_panzer_tread_lf_1" );
	level.tread_damage_fx[ type ][0][2] = loadfx( "destructibles/fx_dest_tank_tread_lf_exp" );
	level.tread_damage_fx[ type ][1][0] = loadfx( "destructibles/fx_dest_tank_panzer_tread_rt_0" );
	level.tread_damage_fx[ type ][1][1] = loadfx( "destructibles/fx_dest_tank_panzer_tread_rt_1" );
	level.tread_damage_fx[ type ][1][2] = loadfx( "destructibles/fx_dest_tank_tread_rt_exp" );
	level.tread_grind_fx[ type ] = [];
	level.tread_grind_fx[ type ][0] = loadfx( "destructibles/fx_dest_tank_panzer_tread_lf_grind" );
	level.tread_grind_fx[ type ][1] = loadfx( "destructibles/fx_dest_tank_panzer_tread_rt_grind" );
}
