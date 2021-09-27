#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
	build_template( "gaz_tigr_turret", model, type, classname );
	build_localinit( ::init_local );
	//build_radiusdamage( ( 0, 0, 32 ), 300, 200, 100, false );

	build_unload_groups( ::Unload_Groups );

	build_drive( %humvee_50cal_driving_idle_forward, %humvee_50cal_driving_idle_backward, 10 );

//	build_drive( %uaz_driving_idle_forward, %uaz_driving_idle_backward, 10 );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	
	if( IsSubStr( classname, "turret" ) )
	{
		build_aianims( ::setanims_turret, ::set_vehicle_anims );
		//build_turret( info,      tag,          model,               maxrange, defaultONmode, deletedelay, defaultdroppitch, defaultdropyaw )
		build_turret( "dshk_gaz", "tag_turret", "weapon_dshk_turret", undefined, "auto_ai", 0.2, -20, -14 );
	}
	else
	{
		build_aianims( ::setanims, ::set_vehicle_anims );
	}
	
	
	build_gaz_death( classname );
	
	
	lightmodel = get_light_model( model, classname );
	build_light( lightmodel, "headlight_L", 	"TAG_HEADLIGHT_LEFT", 	"misc/spotlight_btr80_daytime", 		"running", 	0.0 );
	build_light( lightmodel, "headlight_R", 	"TAG_HEADLIGHT_RIGHT", 	"misc/spotlight_btr80_daytime", 		"running", 	0.0 );
	build_light( lightmodel, "brakelight_L", 	"TAG_BRAKELIGHT_LEFT", 	"misc/car_taillight_btr80_eye", 		"running", 	0.0 );
	build_light( lightmodel, "brakelight_R", 	"TAG_BRAKELIGHT_RIGHT", "misc/car_taillight_btr80_eye", 		"running", 	0.0 );
}

init_local()
{
}

unload_groups()
{
	unload_groups = [];

	group = "passengers";
	unload_groups[ group ] = [];
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	
	group = "all_but_gunner";
	unload_groups[ group ] = [];
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;

	group = "rear_driver_side";
	unload_groups[ group ] = [];
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;

	group = "gunner";
	unload_groups[ group ] = [];
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;

	group = "all";
	unload_groups[ group ] = [];
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;

	unload_groups[ "default" ] = unload_groups[ "all" ];

	return unload_groups;
}

build_gaz_death( classname )
{
	//gaz death fx/////
	level._effect[ "gazfire" ]				= loadfx( "fire/firelp_med_pm_nolight" );
	level._effect[ "gazexplode" ]				= loadfx( "explosions/vehicle_explosion_gaz" );
	level._effect[ "gazcookoff" ]				= loadfx( "explosions/ammo_cookoff" );
	level._effect[ "gazsmfire" ]				= loadfx( "fire/firelp_small_pm_a" );


	//build_deathmodel( "vehicle_gaz_tigr_harbor", "vehicle_gaz_tigr_harbor_destroyed" );
	build_deathmodel( "vehicle_gaz_tigr_base", "vehicle_gaz_tigr_harbor_destroyed" );
	
	//	build_deathfx( effect, 									tag, 					sound, 				bEffectLooping, 	delay, 			bSoundlooping, waitDelay, stayontag, notifyString )
	build_deathfx( "explosions/vehicle_explosion_gaz", "tag_deathfx" );
		
	build_deathfx( "fire/firelp_med_pm_nolight", "tag_cab_fx", undefined, undefined, undefined, true, 0 );
	build_deathfx(  "fire/firelp_small_pm_a" , 					"tag_trunk_fx", 	undefined, 		undefined, 			undefined, 		true, 			3 );
	
	//build_death_jolt( 2.9 );
	build_deathquake( 1, 1.6, 500 );

	//"Name: build_radiusdamage( <offset> , <range> , <maxdamage> , <mindamage> , <bKillplayer>, <delay> )"
	build_radiusdamage( ( 0, 0, 32 ), 300, 200, 0, false );
	
}



#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
	positions[ 0 ].vehicle_getoutanim = %gaz_dismount_frontl_door;
	positions[ 1 ].vehicle_getoutanim = %gaz_dismount_frontr_door;
	positions[ 2 ].vehicle_getoutanim = %gaz_dismount_backl_door;
	positions[ 3 ].vehicle_getoutanim = %gaz_dismount_backr_door;

	positions[ 0 ].vehicle_getinanim = %gaz_mount_frontl_door;
	positions[ 1 ].vehicle_getinanim = %gaz_mount_frontr_door;
	positions[ 2 ].vehicle_getinanim = %gaz_enter_back_door;
	positions[ 3 ].vehicle_getinanim = %gaz_enter_back_door;

	positions[ 0 ].vehicle_getoutsound = "gaz_door_open";
	positions[ 1 ].vehicle_getoutsound = "gaz_door_open";
	positions[ 2 ].vehicle_getoutsound = "gaz_door_open";
	positions[ 3 ].vehicle_getoutsound = "gaz_door_open";

	positions[ 0 ].vehicle_getinsound = "gaz_door_close";
	positions[ 1 ].vehicle_getinsound = "gaz_door_close";
	positions[ 2 ].vehicle_getinsound = "gaz_door_close";
	positions[ 3 ].vehicle_getinsound = "gaz_door_close";

	return positions;
}

set_vehicle_anims_turret( positions )
{
	positions[ 3 ].vehicle_getoutanim = %gaz_turret_getout_gaz;

	return positions;
}

#using_animtree( "generic_human" );
setanims()
{
	positions = [];
	for ( i = 0;i < 4;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";
	positions[ 2 ].sittag = "tag_guy0";
	positions[ 3 ].sittag = "tag_guy1";

	positions[ 0 ].bHasGunWhileRiding = false;

	positions[ 0 ].death = %gaz_dismount_frontl;  // todo: fixme
	positions[ 0 ].death_no_ragdoll = true;
	//positions[ 0 ].death_delayed_ragdoll = 3;

	positions[ 0 ].idle = %gaz_idle_frontl;
	positions[ 1 ].idle = %gaz_idle_frontr;
	positions[ 2 ].idle = %gaz_idle_backl;
	positions[ 3 ].idle = %gaz_idle_backr;

	positions[ 0 ].getout = %gaz_dismount_frontl;
	positions[ 1 ].getout = %gaz_dismount_frontr;
	positions[ 2 ].getout = %gaz_dismount_backl;
	positions[ 3 ].getout = %gaz_dismount_backr;

	positions[ 0 ].getin = %gaz_mount_frontl;
	positions[ 1 ].getin = %gaz_mount_frontr;
	positions[ 2 ].getin = %gaz_enter_backr; 
	positions[ 3 ].getin = %gaz_enter_backl;
	
	return positions;
}

setanims_turret()
{
	positions = setanims();
	
	positions[ 3 ].mgturret = 0;// which of the turrets is this guy going to use	
	positions[ 3 ].passenger_2_turret_func = ::gaz_turret_guy_gettin_func;
	positions[ 3 ].sittag = "tag_guy_turret";
	positions[ 3 ].getout = %gaz_turret_getout_guy1;
	positions = set_vehicle_anims_turret( positions );

	return positions;
}


gaz_turret_guy_gettin_func( vehicle, guy, pos, turret )
{
	// todo
	/*
	animation = %humvee_passenger_2_turret;
	guy animscripts\hummer_turret\common::guy_goes_directly_to_turret( vehicle, pos, turret, animation );	
	*/
}



/*QUAKED script_vehicle_gaz_tigr_turret (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_gaz_dshk::main( "vehicle_gaz_tigr_base", undefined, "script_vehicle_gaz_tigr_turret" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_gaz_tigr_turret
sound,vehicle_gaz_tigr_harbor,vehicle_standard,all_sp

defaultmdl="vehicle_gaz_tigr_base"
default:"vehicletype" "gaz_tigr_turret"
default:"script_team" "axis"
*/










