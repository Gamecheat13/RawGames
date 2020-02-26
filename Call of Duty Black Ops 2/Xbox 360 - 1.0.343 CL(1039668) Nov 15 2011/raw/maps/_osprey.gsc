
#include maps\_vehicle;

#using_animtree ("vehicles");
main()
{
	self.script_badplace = false; //All helicopters dont need to create bad places

	level._effect["rotor_full"] = LoadFX("vehicle/props/fx_hind_main_blade_full");
	level._effect["rotor_small_full"] = LoadFX("vehicle/props/fx_hind_small_blade_full");

	init_fastrope();
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_attach_models(::set_attached_models);
	build_unload_groups( ::unload_groups );
}

set_vehicle_anims(positions)
{
	positions[ 1 ].vehicle_getoutanim = %v_vtol_doors_open;
	positions[ 1 ].vehicle_getoutanim_clear = false;
	
	positions[ 1 ].vehicle_getoutsound = "osprey_door_open";
	positions[ 1 ].vehicle_getinsound = "osprey_door_close";

	positions[ 1 ].delay = getanimlength( %v_vtol_doors_open ) - 1.7;
	positions[ 2 ].delay = getanimlength( %v_vtol_doors_open ) - 1.7;
	positions[ 3 ].delay = getanimlength( %v_vtol_doors_open ) - 1.7;
	positions[ 4 ].delay = getanimlength( %v_vtol_doors_open ) - 1.7;
		
	return positions;
}

init_fastrope()
{
	self.fastropeoffset = 775 + distance( self gettagorigin( "tag_origin" ), self gettagorigin( "tag_ground" ) );
}

#using_animtree ("generic_human");
setanims()
{
	positions = [];
	for(i = 0; i < 6; i++)
	{
		positions[i] = spawnstruct();
	}
	
	positions[ 1 ].idle = %ai_crew_vtol_1_idle;
	positions[ 2 ].idle = %ai_crew_vtol_2_idle;
	positions[ 3 ].idle = %ai_crew_vtol_3_idle;
	positions[ 4 ].idle = %ai_crew_vtol_4_idle;
		
	positions[ 0 ].bHasGunWhileRiding = false;
	positions[ 5 ].bHasGunWhileRiding = false;
	
	positions[ 0 ].idle[ 0 ] = %ai_crew_vtol_pilot1_idle;
	positions[ 0 ].idle[ 1 ] = %ai_crew_vtol_pilot1_idle_twitch_clickpanel;
	positions[ 0 ].idle[ 2 ] = %ai_crew_vtol_pilot1_idle_twitch_lookback;
	positions[ 0 ].idle[ 3 ] = %ai_crew_vtol_pilot1_idle_twitch_lookoutside;
	positions[ 0 ].idleoccurrence[ 0 ] = 500;
	positions[ 0 ].idleoccurrence[ 1 ] = 100;
	positions[ 0 ].idleoccurrence[ 2 ] = 100;
	positions[ 0 ].idleoccurrence[ 3 ] = 100;
	
	positions[ 5 ].idle[ 0 ] = %ai_crew_vtol_pilot2_idle;
	positions[ 5 ].idle[ 1 ] = %ai_crew_vtol_pilot2_idle_twitch_clickpanel;
	positions[ 5 ].idle[ 2 ] = %ai_crew_vtol_pilot2_idle_twitch_lookoutside;
	positions[ 5 ].idleoccurrence[ 0 ] = 450;
	positions[ 5 ].idleoccurrence[ 1 ] = 100;
	positions[ 5 ].idleoccurrence[ 2 ] = 100;
		
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_detach";
	positions[ 2 ].sittag = "tag_detach";
	positions[ 3 ].sittag = "tag_detach";
	positions[ 4 ].sittag = "tag_detach";
	positions[ 5 ].sittag = "tag_passenger";
	
	positions[ 1 ].getout = %ai_crew_vtol_1_drop;
	positions[ 2 ].getout = %ai_crew_vtol_2_drop;
	positions[ 3 ].getout = %ai_crew_vtol_3_drop;
	positions[ 4 ].getout = %ai_crew_vtol_4_drop;
	
	positions[ 1 ].getoutstance = "crouch";
	positions[ 2 ].getoutstance = "crouch";
	positions[ 3 ].getoutstance = "crouch";
	positions[ 4 ].getoutstance = "crouch";
	
	positions[ 1 ].ragdoll_getout_death = true;
	positions[ 2 ].ragdoll_getout_death = true;
	positions[ 3 ].ragdoll_getout_death = true;
	positions[ 4 ].ragdoll_getout_death = true;
	
//	positions[ 1 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 2 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 3 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 4 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 5 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 6 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 7 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 8 ].getoutloopsnd = "fastrope_loop_npc";

	positions[ 1 ].getoutrig = "rope_test_ri";
	positions[ 2 ].getoutrig = "rope_test_ri";
	positions[ 3 ].getoutrig = "rope_test_ri";
	positions[ 4 ].getoutrig = "rope_test_ri";
	
	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "back" ] = [];
	unload_groups[ "front" ] = [];
	unload_groups[ "both" ] = [];

	unload_groups[ "back" ][ unload_groups[ "back" ].size ] = 1;
	unload_groups[ "back" ][ unload_groups[ "back" ].size ] = 2;
	unload_groups[ "back" ][ unload_groups[ "back" ].size ] = 3;
	unload_groups[ "back" ][ unload_groups[ "back" ].size ] = 4;

	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 1;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 2;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 3;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 4;

	unload_groups[ "default" ] = unload_groups[ "both" ];

	return unload_groups;
}

set_attached_models()
{
	array = [];
	
	array[ "rope_test_ri" ] = spawnstruct();
	array[ "rope_test_ri" ].model = "rope_test_ri";
	array[ "rope_test_ri" ].tag = "TAG_FastRope_RI";
	array[ "rope_test_ri" ].idleanim = %o_vtol_rope_idle_RI;
	array[ "rope_test_ri" ].dropanim = %o_vtol_rope_drop_RI;
	
	return array;
}

precache_extra_models()
{
	PrecacheModel("rope_test_ri");
}

