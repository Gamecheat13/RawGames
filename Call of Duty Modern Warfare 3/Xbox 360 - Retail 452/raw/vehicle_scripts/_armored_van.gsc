#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type, classname )
{
	build_template( "armored_van", model, type, classname );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_armored_van", "vehicle_armored_van_destroyed" );// RADNAME = _troops
	
	build_deathfx( "explosions/large_vehicle_explosion", 	undefined, 				"car_explode", 						undefined, 			undefined, 		undefined, 		0 );
//	build_deathfx( "fire/firelp_med_pm", 					"TAG_CAB_FIRE"/* right_wheel_02_jnt */, 	undefined, 							undefined, 			undefined, 		true, 			0 );
//	build_deathfx( "fire/firelp_med_pm", 					"TAG_CARGO_FIRE"/* tag_headlight_left */, 			"fire_metal_medium", 				undefined, 			undefined, 		true, 			0 );
		
	build_radiusdamage( ( 0, 0, 32 ), 300, 200, 100, false );
    build_drive( %uaz_driving_idle_forward, %uaz_driving_idle_backward, 10 );
        

	build_deathquake( 1, 1.6, 500 );
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	build_treadfx();

	build_aianims( ::setanims, ::set_vehicle_anims );
	build_unload_groups( ::Unload_Groups );

}

init_local()
{
// 	maps\_vehicle::lights_on( "headlights" );
// 	maps\_vehicle::lights_on( "brakelights" );

}


set_vehicle_anims( positions )
{		
	positions[ 0 ].vehicle_getoutanim = %russian_swat_van_driver_getout_door;
	positions[ 0 ].vehicle_getoutsoundtag = "front_door_left_jnt";

	positions[ 0 ].vehicle_getoutanim_clear = true;
	positions[ 1 ].vehicle_getoutanim_clear = false;
	positions[ 2 ].vehicle_getoutanim_clear = false;
	positions[ 3 ].vehicle_getoutanim_clear = false;
	positions[ 4 ].vehicle_getoutanim_clear = false;
	positions[ 5 ].vehicle_getoutanim_clear = false;
	positions[ 6 ].vehicle_getoutanim_clear = false;
	positions[ 7 ].vehicle_getoutanim_clear = false;
	positions[ 8 ].vehicle_getoutanim_clear = false;
	
	return positions;
}

#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for ( i = 0;i < 9;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].sittag 			= "tag_driver";
	positions[ 0 ].idle 			= %russian_swat_van_driver_idle;
	positions[ 0 ].getout 			= %russian_swat_van_driver_getout;
	
	positions[ 1 ].sittag 			= "tag_detach";
	positions[ 1 ].idle 			= %russian_swat_van_guyL1_idle;
	positions[ 1 ].getout 			= %russian_swat_van_guyL1_getout;
	positions[ 1 ].getout_secondary = %russian_swat_van_guyL_runoff;
	positions[ 1 ].explosion_death 	= %death_explosion_stand_B_v1;
	
	positions[ 2 ].sittag 			= "tag_detach";
	positions[ 2 ].idle 			= %russian_swat_van_guyR1_idle;
	positions[ 2 ].getout 			= %russian_swat_van_guyR1_getout;
	positions[ 2 ].getout_secondary = %russian_swat_van_guyR_runoff;
	positions[ 2 ].explosion_death 	= %death_explosion_stand_B_v2;
	
	positions[ 3 ].sittag 			= "tag_detach";
	positions[ 3 ].idle 			= %russian_swat_van_guyL2_idle;
	positions[ 3 ].getout 			= %russian_swat_van_guyL2_getout;
	positions[ 3 ].getout_secondary = %russian_swat_van_guyL_runoff;
	positions[ 3 ].explosion_death 	= %death_explosion_stand_B_v3;
	
	positions[ 4 ].sittag 			= "tag_detach";
	positions[ 4 ].idle 			= %russian_swat_van_guyR2_idle;
	positions[ 4 ].getout 			= %russian_swat_van_guyR2_getout;
	positions[ 4 ].getout_secondary = %russian_swat_van_guyR_runoff;
	positions[ 4 ].explosion_death 	= %death_explosion_stand_B_v4;
	
	positions[ 5 ].sittag 			= "tag_detach";
	positions[ 5 ].idle 			= %russian_swat_van_guyL3_idle;
	positions[ 5 ].getout 			= %russian_swat_van_guyL3_getout;
	positions[ 5 ].getout_secondary = %russian_swat_van_guyL_runoff;
	positions[ 5 ].explosion_death 	= %death_explosion_stand_B_v2;
	
	positions[ 6 ].sittag 			= "tag_detach";
	positions[ 6 ].idle 			= %russian_swat_van_guyR3_idle;
	positions[ 6 ].getout 			= %russian_swat_van_guyR3_getout;
	positions[ 6 ].getout_secondary = %russian_swat_van_guyR_runoff;
	positions[ 6 ].explosion_death 	= %death_explosion_stand_B_v1;
	
	positions[ 7 ].sittag 			= "tag_detach";
	positions[ 7 ].idle 			= %russian_swat_van_guyL4_idle;
	positions[ 7 ].getout 			= %russian_swat_van_guyL4_getout;
	positions[ 7 ].getout_secondary = %russian_swat_van_guyL_runoff;
	positions[ 7 ].explosion_death 	= %death_explosion_stand_B_v4;
	
	positions[ 8 ].sittag 			= "tag_detach";
	positions[ 8 ].idle 			= %russian_swat_van_guyR4_idle;
	positions[ 8 ].getout 			= %russian_swat_van_guyR4_getout;
	positions[ 8 ].getout_secondary = %russian_swat_van_guyR_runoff;
	positions[ 8 ].explosion_death 	= %death_explosion_stand_B_v3;
	
	return positions;

}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "passengers" ] = [];
	unload_groups[ "all" ] = [];

	group = "passengers";
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;
	unload_groups[ group ][ unload_groups[ group ].size ] = 6;
	unload_groups[ group ][ unload_groups[ group ].size ] = 7;
	unload_groups[ group ][ unload_groups[ group ].size ] = 8;
	
	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;
	unload_groups[ group ][ unload_groups[ group ].size ] = 6;
	unload_groups[ group ][ unload_groups[ group ].size ] = 7;
	unload_groups[ group ][ unload_groups[ group ].size ] = 8;
	
	unload_groups[ "default" ] = unload_groups[ "all" ];

	return unload_groups;
}
/*QUAKED script_vehicle_armored_van (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER


This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_armored_van::main( "vehicle_armored_van", undefined, "script_vehicle_armored_van" );


These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_armored_van
sound,vehicle_armored_van,vehicle_standard,all_sp


defaultmdl="vehicle_armored_van"
default:"vehicletype" "armored_van"
default:"script_team" "axis"
*/ 
