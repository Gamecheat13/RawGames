#include maps\_vehicle;
#include maps\_vehicle_aianim;
#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "vehicles" );

main( model, type, classname )
{
	build_template( "osprey", model, type, classname );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_v22_osprey" );
	build_deathmodel( "vehicle_v22_osprey_fly" );

	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	//Death by Rocket effects, explodes immediatly
	build_rocket_deathfx( "explosions/aerial_explosion_apache_mp", 	"tag_deathfx", 	"apache_helicopter_crash",	undefined, 			undefined, 		undefined, 		 undefined, true, 	undefined, 0, 5 );


	build_treadfx();

	build_life( 999, 500, 1500 );

	build_team( "allies" );
	build_aianims( ::setanims, ::set_vehicle_anims );

	build_drive( %v22_osprey_props, undefined, 0 );

	build_unload_groups( ::Unload_Groups );

	randomStartDelay = RandomFloatRange( 0, 1 );
	lightmodel = get_light_model( model, classname );
	build_light( lightmodel, "cockpit_red_cargo02", 		"tag_light_cargo02", 	"misc/aircraft_light_cockpit_red", 		"interior", 	0.0 );
	build_light( lightmodel, "cockpit_blue_cockpit01", 	"tag_light_cockpit01", 	"misc/aircraft_light_cockpit_blue", 	"interior", 	0.1 );
	build_light( lightmodel, "white_blink", 				"tag_light_belly", 		"misc/aircraft_light_red_blink", 		"running", 	randomStartDelay );
	build_light( lightmodel, "white_blink_tail", 		"tag_light_tail", 		"misc/aircraft_light_red_blink", 		"running", 	randomStartDelay );
	
	thread handle_landing();

}

handle_landing()
{
	level waittill ( "load_finished" );
	land_structs = GetVehicleNodeArray( "osprey_landing", "script_noteworthy" );
	take_off_nodes = GetVehicleNodeArray( "osprey_take_off", "script_noteworthy" );
	array_thread( land_structs, ::land_structs_think, true );
	array_thread( take_off_nodes, ::land_structs_think, false );
}


land_structs_think( landing )
{
	currentanim = %v22_osprey_wings_down;
	destanim = %v22_osprey_wings_up;

	if ( ! landing )
	{
		currentanim = %v22_osprey_wings_up;
		destanim = %v22_osprey_wings_down;
	}
	
	while ( true )
	{
		self waittill ( "trigger", osprey );
		osprey endon ( "death" );
		Assert( IsSubStr( osprey.classname, "osprey" ) );
		osprey ClearAnim( currentanim, 1 );
		wait 1;
		osprey SetAnimRestart( destanim,1,0,0.15 );
		if ( ! landing )
		{
			osprey notify ( "stop_kicking_up_dust" );
			osprey ClearAnim( %v22_osprey_hatch_down, 0.2 );
			wait 0.2;
			osprey SetAnimRestart( %v22_osprey_hatch_up );
		}
		else
			osprey thread maps\_vehicle::aircraft_dust_kickup();
	}
}

init_local()
{
	self.dontdisconnectpaths = true;
	self.originheightoffset = Distance( self GetTagOrigin( "tag_origin" ), self GetTagOrigin( "tag_ground" ) );
	self.script_badplace = false;// All helicopters dont need to create bad places
	
	self.enableRocketDeath = true;

	wait 0.05;

	self notify ( "stop_kicking_up_dust" );
	
	maps\_vehicle::lights_on( "running" );

}

set_vehicle_anims( positions )
{
	positions[ 1 ].vehicle_getoutanim = %v22_osprey_hatch_down;
	positions[ 1 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getinanim = %v22_osprey_hatch_up;
	positions[ 1 ].vehicle_getinanim_clear = false;

	positions[ 1 ].vehicle_getoutsound = "osprey_door_open";
	positions[ 1 ].vehicle_getinsound = "osprey_door_close";

	positions[ 1 ].delay = GetAnimLength( %v22_osprey_hatch_down ) - 1.7;
	positions[ 2 ].delay = GetAnimLength( %v22_osprey_hatch_down ) - 1.7;
	positions[ 3 ].delay = GetAnimLength( %v22_osprey_hatch_down ) - 1.7;
	positions[ 4 ].delay = GetAnimLength( %v22_osprey_hatch_down ) - 1.7;

	return positions;
}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for ( i = 0;i < 6;i++ )
		positions[ i ] = SpawnStruct();

	positions[ 0 ].idle[ 0 ] = %SeaKnight_Pilot_idle;
	positions[ 0 ].idle[ 1 ] = %SeaKnight_Pilot_switches;
	positions[ 0 ].idle[ 2 ] = %SeaKnight_Pilot_twitch;
	positions[ 0 ].idleoccurrence[ 0 ] = 1000;
	positions[ 0 ].idleoccurrence[ 1 ] = 400;
	positions[ 0 ].idleoccurrence[ 2 ] = 200;

	positions[ 0 ].bHasGunWhileRiding = false;
	positions[ 5 ].bHasGunWhileRiding = false;

	positions[ 1 ].idle = %ch46_unload_1_idle;// these guys don't have an idle animation so I'm using copilot.
	positions[ 2 ].idle = %ch46_unload_2_idle;// these guys don't have an idle animation so I'm using copilot.
	positions[ 3 ].idle = %ch46_unload_3_idle;// these guys don't have an idle animation so I'm using copilot.
	positions[ 4 ].idle = %ch46_unload_4_idle;// these guys don't have an idle animation so I'm using copilot.

	positions[ 5 ].idle[ 0 ] = %SeaKnight_coPilot_idle;
	positions[ 5 ].idle[ 1 ] = %SeaKnight_coPilot_switches;
	positions[ 5 ].idle[ 2 ] = %SeaKnight_coPilot_twitch;

	positions[ 5 ].idleoccurrence[ 0 ] = 1000;
	positions[ 5 ].idleoccurrence[ 1 ] = 400;
	positions[ 5 ].idleoccurrence[ 2 ] = 200;

	positions[ 0 ].sittag = "tag_detach_pilots";
	positions[ 1 ].sittag = "tag_detach";
	positions[ 2 ].sittag = "tag_detach";
	positions[ 3 ].sittag = "tag_detach";
	positions[ 4 ].sittag = "tag_detach";
	positions[ 5 ].sittag = "tag_detach_pilots";

//	positions[ 1 ].getoutstance = "crouch";
//	positions[ 2 ].getoutstance = "crouch";
//	positions[ 3 ].getoutstance = "crouch";
//	positions[ 4 ].getoutstance = "crouch";

	positions[ 1 ].getout = %ch46_unload_1;
	positions[ 2 ].getout = %ch46_unload_2;
	positions[ 3 ].getout = %ch46_unload_3;
	positions[ 4 ].getout = %ch46_unload_4;



	positions[ 1 ].getin = %ch46_load_1;
	positions[ 2 ].getin = %ch46_load_2;
	positions[ 3 ].getin = %ch46_load_3;
	positions[ 4 ].getin = %ch46_load_4;

	return positions;

}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "passengers" ] = [];
	unload_groups[ "passengers" ][ unload_groups[ "passengers" ].size ] = 1;
	unload_groups[ "passengers" ][ unload_groups[ "passengers" ].size ] = 2;
	unload_groups[ "passengers" ][ unload_groups[ "passengers" ].size ] = 3;
	unload_groups[ "passengers" ][ unload_groups[ "passengers" ].size ] = 4;
	unload_groups[ "default" ] = unload_groups[ "passengers" ];
	return unload_groups;
}

set_attached_models()
{

}



/*QUAKED script_vehicle_osprey (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_osprey::main( "vehicle_v22_osprey",undefined, "script_vehicle_osprey" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_osprey
sound,vehicle_osprey,vehicle_standard,all_sp

defaultmdl="vehicle_v22_osprey"
default:"vehicletype" "osprey"
default:"script_team" "allies"
*/


/*QUAKED script_vehicle_osprey_fly (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_osprey::main( "vehicle_v22_osprey_fly",undefined, "script_vehicle_osprey_fly" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_osprey_fly
sound,vehicle_osprey,vehicle_standard,all_sp

defaultmdl="vehicle_v22_osprey_fly"
default:"vehicletype" "osprey"
default:"script_team" "allies"
*/


