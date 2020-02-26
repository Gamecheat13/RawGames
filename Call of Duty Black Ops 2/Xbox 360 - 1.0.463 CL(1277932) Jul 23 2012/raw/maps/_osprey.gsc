
#include maps\_vehicle;
#include common_scripts\utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

#using_animtree ("vehicles");
main()
{
	self.script_badplace = false; //All helicopters dont need to create bad places

	//level._effect["rotor_full"] = LoadFX("vehicle/props/fx_hind_main_blade_full");
	//level._effect["rotor_small_full"] = LoadFX("vehicle/props/fx_hind_small_blade_full");

	init_fastrope();
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_attach_models(::set_attached_models);
	build_unload_groups( ::unload_groups );
	
	self.vehicle_numDrivers = 2;
	
	if ( !self has_spawnflag( SPAWNFLAG_VEHICLE_SPAWNER ) )
	{
	    if ( IsDefined( self.script_doorstate ) && self.script_doorstate == 0 )
			self close_hatch();
	}
}

set_vehicle_anims(positions)
{
	positions[ 2 ].vehicle_getoutanim = %v_vtol_hover_idle;
	positions[ 2 ].vehicle_getoutanim_clear = false;	
	
	positions[ 3 ].vehicle_getoutanim = %v_vtol_doors_open;
	positions[ 3 ].vehicle_getoutanim_clear = false;
	
	positions[ 2 ].vehicle_getoutsound = "osprey_door_open";
	positions[ 2 ].vehicle_getinsound = "osprey_door_close";

	positions[ 1 ].delay = getanimlength( %v_vtol_doors_open ) - 1.7;
	positions[ 2 ].delay = getanimlength( %v_vtol_doors_open ) - 1.7;
	positions[ 3 ].delay = getanimlength( %v_vtol_doors_open ) - 1.7;
	positions[ 4 ].delay = getanimlength( %v_vtol_doors_open ) - 1.7;
	
	anim_for_client_script = %veh_anim_v78_vtol_engine_left;
	anim_for_client_script = %veh_anim_v78_vtol_engine_right;
	
	return positions;
}

init_fastrope()
{
	// Needed to comment out for gump support, should do this at a later time when we know the model is loaded.
	self.fastropeoffset = 819; //775 + distance( self gettagorigin( "tag_origin" ), self gettagorigin( "tag_ground" ) );
}

#using_animtree ("generic_human");
setanims()
{
	positions = [];
	
	num_positions = ( IsSubStr( self.vehicleType, "heli_v78" ) ? 7 : 6 );
	for(i = 0; i < num_positions; i++)
	{
		positions[i] = spawnstruct();
	}
		
	positions[ 0 ].bHasGunWhileRiding = false;
	positions[ 1 ].bHasGunWhileRiding = false;
	
	positions[ 0 ].idle[ 0 ] = %ai_crew_vtol_pilot1_idle;
	positions[ 0 ].idle[ 1 ] = %ai_crew_vtol_pilot1_idle_twitch_clickpanel;
	positions[ 0 ].idle[ 2 ] = %ai_crew_vtol_pilot1_idle_twitch_lookback;
	positions[ 0 ].idle[ 3 ] = %ai_crew_vtol_pilot1_idle_twitch_lookoutside;
	positions[ 0 ].idleoccurrence[ 0 ] = 500;
	positions[ 0 ].idleoccurrence[ 1 ] = 100;
	positions[ 0 ].idleoccurrence[ 2 ] = 100;
	positions[ 0 ].idleoccurrence[ 3 ] = 100;
	
	positions[ 1 ].idle[ 0 ] = %ai_crew_vtol_pilot2_idle;
	positions[ 1 ].idle[ 1 ] = %ai_crew_vtol_pilot2_idle_twitch_clickpanel;
	positions[ 1 ].idle[ 2 ] = %ai_crew_vtol_pilot2_idle_twitch_lookoutside;
	positions[ 1 ].idleoccurrence[ 0 ] = 450;
	positions[ 1 ].idleoccurrence[ 1 ] = 100;
	positions[ 1 ].idleoccurrence[ 2 ] = 100;
		
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";
	positions[ 2 ].sittag = "tag_detach";
	positions[ 3 ].sittag = "tag_detach";
	positions[ 4 ].sittag = "tag_detach";
	positions[ 5 ].sittag = "tag_detach";
	
	positions[ 2 ].idle = %ai_crew_vtol_1_idle;
	positions[ 3 ].idle = %ai_crew_vtol_2_idle;
	positions[ 4 ].idle = %ai_crew_vtol_3_idle;
	positions[ 5 ].idle = %ai_crew_vtol_4_idle;
	
	positions[ 2 ].getout = %ai_crew_vtol_1_drop;
	positions[ 3 ].getout = %ai_crew_vtol_2_drop;
	positions[ 4 ].getout = %ai_crew_vtol_3_drop;
	positions[ 5 ].getout = %ai_crew_vtol_4_drop;
	
	positions[ 2 ].getoutstance = "crouch";
	positions[ 3 ].getoutstance = "crouch";
	positions[ 4 ].getoutstance = "crouch";
	positions[ 5 ].getoutstance = "crouch";
	
	positions[ 2 ].ragdoll_getout_death = true;
	positions[ 3 ].ragdoll_getout_death = true;
	positions[ 4 ].ragdoll_getout_death = true;
	positions[ 5 ].ragdoll_getout_death = true;
	
//	positions[ 2 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 3 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 4 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 5 ].getoutloopsnd = "fastrope_loop_npc";

	positions[ 2 ].getoutrig = "rope_test_ri";
	positions[ 3 ].getoutrig = "rope_test_ri";
	positions[ 4 ].getoutrig = "rope_test_ri";
	positions[ 5 ].getoutrig = "rope_test_ri";
	
	if ( num_positions == 7 )
	{
		positions[ 6 ].sittag = "tag_gunner1";
		positions[ 6 ].vehiclegunner = 1;
		positions[ 6 ].idle = %ai_50cal_gunner_aim;
		positions[ 6 ].aimup = %ai_50cal_gunner_aim_up;
		positions[ 6 ].aimdown = %ai_50cal_gunner_aim_down;
	}

	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "back" ] = [];
	unload_groups[ "front" ] = [];
	unload_groups[ "both" ] = [];

	unload_groups[ "back" ][ unload_groups[ "back" ].size ] = 2;
	unload_groups[ "back" ][ unload_groups[ "back" ].size ] = 3;
	unload_groups[ "back" ][ unload_groups[ "back" ].size ] = 4;
	unload_groups[ "back" ][ unload_groups[ "back" ].size ] = 5;

	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 2;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 3;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 4;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 5;

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

// self == osprey/vtol/x78/v78
open_hatch()
{
	self SetAnim( %vehicles::v_vtol_doors_open, 1, 0.1, 1 );
}

close_hatch()
{
	self SetAnim( %vehicles::v_vtol_doors_open, 1, 0.1, 0 );	
}
