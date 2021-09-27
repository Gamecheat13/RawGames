#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname, turret_info )
{
	build_template( "super_dvora", model, type, classname );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_russian_super_dvora_mark2" );
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	if (isdefined(turret_info))
	{
		turret_model = "weapon_m2_50cal_dshkVersion";
		build_turret( turret_info, "tag_turret", turret_model, undefined, "auto_ai", 0.5, 20, -14 );
		build_turret( turret_info, "tag_turret2", turret_model, undefined, "auto_ai", 0.5, 20, -14 );
	}
	build_aianims( ::setanims, ::set_vehicle_anims );
	//build_unload_groups( ::Unload_Groups );
	//build_treadfx();  //currently disabled because vehicle type "boat" isn't supported. http://bugzilla.infinityward.net/show_bug.cgi?id=85644

}

#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for ( i = 0; i < 4; i++ )
		positions[ i ] = SpawnStruct();
/*
rough pass

technical_driver_duck
technical_driver_idle
technical_driver_climb_out


technical_passenger_duck
technical_passenger_idle


technical_passenger_climb_out
technical_turret_aim_2
technical_turret_aim_8
technical_turret_death
technical_turret_jam
technical_turret_turn_L
technical_turret_turn_R
door_technical_driver_climb_out
door_technical_passenger_climb_out
*/
//	positions[ 0 ].getout_delete = true;

	positions[ 0 ].sittag = "tag_guy";
	positions[ 1 ].sittag = "tag_guy2";
	positions[ 2 ].sittag = "tag_guy3";
	positions[ 3 ].sittag = "tag_guy4";
	
	positions[ 0 ].unload_ondeath = .9; // doesn't have unload but lets other parts know not to delete him.
	positions[ 1 ].unload_ondeath = .9; // doesn't have unload but lets other parts know not to delete him.
	positions[ 2 ].unload_ondeath = .9;
	positions[ 3 ].unload_ondeath = .9;

/*  no anim for machine gun guy just yet
	positions[ 1 ].idle[ 0 ] = %technical_driver_idle;
	positions[ 1 ].idle[ 1 ] = %technical_driver_duck;
	positions[ 1 ].idleoccurrence[ 0 ] = 1000;
	positions[ 1 ].idleoccurrence[ 1 ] = 100;
*/	

	positions[ 3 ].getout = %technical_driver_climb_out;
//	positions[ 1 ].getout = %humvee_passenger_out_L;
	positions[ 2 ].getout = %technical_passenger_climb_out;

	//positions[ 0 ].getin = %humvee_driver_climb_idle;
	//positions[ 1 ].getin = %humvee_passenger_in_L;
	//positions[ 2 ].getin = %humvee_passenger_in_R;

//	positions[ 1 ].deathscript = ::deleteme;

//	positions[ 0 ].explosion_death = %death_explosion_left11;
//	positions[ 1 ].explosion_death = %death_explosion_back13;
//	positions[ 2 ].explosion_death = %death_explosion_right13;
//
//	positions[ 0 ].explosion_death_offset = (0,0,-24);
//	positions[ 1 ].explosion_death_offset = (-16,0,-24);
//	positions[ 2 ].explosion_death_offset = (0,0,-24);
//		
//	positions[ 0 ].explosion_death_ragdollfraction = .3;
//	positions[ 1 ].explosion_death_ragdollfraction = .3;
//	positions[ 2 ].explosion_death_ragdollfraction = .3;

	positions[ 0 ].mgturret = 0; // which of the turrets is this guy going to use
	positions[ 1 ].mgturret = 1;

	return positions;
}

set_vehicle_anims( positions )
{
	return positions;
}

init_local()
{
}

/*QUAKED script_vehicle_super_dvora (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_super_dvora::main( "vehicle_russian_super_dvora_mark2", undefined, "script_vehicle_super_dvora", "50cal_turret_technical" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_super_dvora
sound,vehicle_super_dvora,vehicle_standard,all_sp


defaultmdl="vehicle_russian_super_dvora_mark2"
default:"vehicletype" "super_dvora"
default:"script_team" "axis"
*/

/*QUAKED script_vehicle_super_dvora_slowmo (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_super_dvora::main( "vehicle_russian_super_dvora_mark2", undefined, "script_vehicle_super_dvora_slowmo", "50cal_turret_technical_slomo" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_super_dvora
sound,vehicle_super_dvora,vehicle_standard,all_sp


defaultmdl="vehicle_russian_super_dvora_mark2"
default:"vehicletype" "super_dvora"
default:"script_team" "axis"
*/



