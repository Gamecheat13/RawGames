#include maps\_vehicle;

#using_animtree ("vehicles");
main()
{
	self.script_badplace = false; //All helicopters dont need to create bad places

	//level._effect["rotor_full"] = LoadFX("vehicle/props/fx_hind_main_blade_full");
	//level._effect["rotor_small_full"] = LoadFX("vehicle/props/fx_hind_small_blade_full");

	init_fastrope();
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_attach_models(::set_attached_models);
	build_unload_groups(::unload_groups );
	
	self.vehicle_numDrivers = 2;
}

set_vehicle_anims(positions)
{		
	return positions;
}

init_fastrope()
{
	// Needed to comment out for gump support, should do this at a later time when we know the model is loaded.
	//self.fastropeoffset = 775 + distance( self gettagorigin( "tag_origin" ), self gettagorigin( "tag_ground" ) );
	self.fastropeoffset = 937;
}


#using_animtree( "generic_human" );
setanims()
{
	positions = [];
	for ( i = 0;i <= 9;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].idle[ 0 ] = %ai_crew_hind_pilot1_idle;
	positions[ 0 ].idle[ 1 ] = %ai_crew_hind_pilot1_idle_twitch_clickpanel;
	positions[ 0 ].idle[ 2 ] = %ai_crew_hind_pilot1_idle_twitch_lookback;
	positions[ 0 ].idle[ 3 ] = %ai_crew_hind_pilot1_idle_twitch_lookoutside;
	positions[ 0 ].idleoccurrence[ 0 ] = 500;
	positions[ 0 ].idleoccurrence[ 1 ] = 100;
	positions[ 0 ].idleoccurrence[ 2 ] = 100;
	positions[ 0 ].idleoccurrence[ 3 ] = 100;

	positions[ 1 ].idle[ 0 ] = %ai_crew_hind_pilot2_idle;
	positions[ 1 ].idle[ 1 ] = %ai_crew_hind_pilot2_idle_twitch_clickpanel;
	positions[ 1 ].idle[ 2 ] = %ai_crew_hind_pilot2_idle_twitch_lookoutside;
	positions[ 1 ].idle[ 3 ] = %ai_crew_hind_pilot2_idle_twitch_radio;
	positions[ 1 ].idleoccurrence[ 0 ] = 450;
	positions[ 1 ].idleoccurrence[ 1 ] = 100;
	positions[ 1 ].idleoccurrence[ 2 ] = 100;
	positions[ 1 ].idleoccurrence[ 3 ] = 100;

	positions[ 0 ].bHasGunWhileRiding = false;
	positions[ 1 ].bHasGunWhileRiding = false;

	positions[ 0 ].sittag = "tag_passenger";
	positions[ 1 ].sittag = "tag_driver";
	positions[ 2 ].sittag = "tag_detach";
	positions[ 3 ].sittag = "tag_detach";
	positions[ 4 ].sittag = "tag_detach";
	positions[ 5 ].sittag = "tag_detach";
	positions[ 6 ].sittag = "tag_detach";
	positions[ 7 ].sittag = "tag_detach";
	positions[ 8 ].sittag = "tag_detach";
	positions[ 9 ].sittag = "tag_detach";

	// 2, 4, 5, 6, 7, 8, 9
	positions[ 2 ].idle = %ai_crew_hind_1_idle;
	positions[ 3 ].idle = %ai_crew_hind_2_idle;
	positions[ 4 ].idle = %ai_crew_hind_3_idle;
	positions[ 5 ].idle = %ai_crew_hind_4_idle;
	positions[ 6 ].idle = %ai_crew_hind_5_idle;
	positions[ 7 ].idle = %ai_crew_hind_6_idle;
	positions[ 8 ].idle = %ai_crew_hind_7_idle;
	positions[ 9 ].idle = %ai_crew_hind_8_idle;
	
	// 2, 4, 5, 6, 7, 8, 9
	positions[ 2 ].getout = %ai_crew_hind_1_drop;
	positions[ 3 ].getout = %ai_crew_hind_2_drop;
	positions[ 4 ].getout = %ai_crew_hind_3_drop;
	positions[ 5 ].getout = %ai_crew_hind_4_drop;
	positions[ 6 ].getout = %ai_crew_hind_5_drop;
	positions[ 7 ].getout = %ai_crew_hind_6_drop;
	positions[ 8 ].getout = %ai_crew_hind_7_drop;
	positions[ 9 ].getout = %ai_crew_hind_8_drop;

	positions[ 2 ].getoutstance = "crouch";
	positions[ 3 ].getoutstance = "crouch";
	positions[ 4 ].getoutstance = "crouch";
	positions[ 5 ].getoutstance = "crouch";
	positions[ 6 ].getoutstance = "crouch";
	positions[ 7 ].getoutstance = "crouch";
	positions[ 8 ].getoutstance = "crouch";
	positions[ 9 ].getoutstance = "crouch";
	
	positions[ 2 ].ragdoll_getout_death = true;
	positions[ 3 ].ragdoll_getout_death = true;
	positions[ 4 ].ragdoll_getout_death = true;
	positions[ 5 ].ragdoll_getout_death = true;
	positions[ 6 ].ragdoll_getout_death = true;
	positions[ 7 ].ragdoll_getout_death = true;
	positions[ 8 ].ragdoll_getout_death = true;
	positions[ 9 ].ragdoll_getout_death = true;
	
//	positions[ 2 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 3 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 4 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 5 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 6 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 7 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 8 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 9 ].getoutloopsnd = "fastrope_loop_npc";

	// left side
	positions[ 4 ].getoutrig = "fastrope_80ft_le";
	positions[ 5 ].getoutrig = "fastrope_80ft_le";
	positions[ 6 ].getoutrig = "fastrope_80ft_le";
	positions[ 7 ].getoutrig = "fastrope_80ft_le";
	
	// right side
	positions[ 2 ].getoutrig = "fastrope_80ft_ri";
	positions[ 3 ].getoutrig = "fastrope_80ft_ri";
	positions[ 8 ].getoutrig = "fastrope_80ft_ri";
	positions[ 9 ].getoutrig = "fastrope_80ft_ri";

	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "left" ] = [];
	unload_groups[ "right" ] = [];
	unload_groups[ "both" ] = [];

	unload_groups[ "left" ][ unload_groups[ "left" ].size ] = 4;
	unload_groups[ "left" ][ unload_groups[ "left" ].size ] = 5;
	unload_groups[ "left" ][ unload_groups[ "left" ].size ] = 6;
	unload_groups[ "left" ][ unload_groups[ "left" ].size ] = 7;

	unload_groups[ "right" ][ unload_groups[ "right" ].size ] = 2;
	unload_groups[ "right" ][ unload_groups[ "right" ].size ] = 3;
	unload_groups[ "right" ][ unload_groups[ "right" ].size ] = 8;
	unload_groups[ "right" ][ unload_groups[ "right" ].size ] = 9;

	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 2;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 3;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 4;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 5;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 6;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 7;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 8;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 9;

	unload_groups[ "default" ] = unload_groups[ "both" ];

	return unload_groups;
}

set_attached_models()
{
	array = [];
	array[ "fastrope_80ft_le" ] = spawnstruct();
	array[ "fastrope_80ft_le" ].model = "fastrope_80ft_le";
	array[ "fastrope_80ft_le" ].tag = "tag_fastrope_le";
	array[ "fastrope_80ft_le" ].idleanim = %o_hind_rope_idle_le;
	array[ "fastrope_80ft_le" ].dropanim = %o_hind_rope_drop_le;

	array[ "fastrope_80ft_ri" ] = spawnstruct();
	array[ "fastrope_80ft_ri" ].model = "fastrope_80ft_ri";
	array[ "fastrope_80ft_ri" ].tag = "tag_fastrope_ri";
	array[ "fastrope_80ft_ri" ].idleanim = %o_hind_rope_idle_ri;
	array[ "fastrope_80ft_ri" ].dropanim = %o_hind_rope_drop_ri;
	
	return array;
}

precache_extra_models()
{
	PrecacheModel("fastrope_80ft_le");
	PrecacheModel("fastrope_80ft_ri");
}

