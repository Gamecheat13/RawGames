#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "bmp", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_bmp", "vehicle_bmp_dsty" );
	build_deathmodel( "vehicle_bmp_thermal" );

//	build_deathfx( effect, 									tag, 				sound, 								bEffectLooping, 	delay, 			bSoundlooping, waitDelay, stayontag, notifyString )
	build_deathfx( "fire/firelp_med_pm",					"tag_deathfx",		"smallfire",						undefined,			undefined,		true,			0 );
	build_deathfx( "fire/firelp_med_pm",					"tag_cargofire",	"smallfire",						undefined,			undefined,		true,			0 );
	build_deathfx( "explosions/vehicle_explosion_bmp",		undefined,			"building_explosion3",				undefined,			undefined,		undefined,		0 );

	
	build_turret( "bmp_turret2", "tag_turret2", "vehicle_bmp_machine_gun", false );
	
	build_radiusdamage( ( 0, 0, 53 ), 512, 300, 20, false );
	
	build_treadfx();

	build_life( 999, 500, 1500 );
	
	build_team( "allies" );
	
	build_aianims( ::setanims , ::set_vehicle_anims );
	
	build_frontarmor( .33 ); //regens this much of the damage from attacks to the front
	
}

init_local()
{
}

set_vehicle_anims( positions )
{
	
	//positions[ 0 ].vehicle_getinanim = %tigertank_hatch_open;
	//positions[ 1 ].vehicle_getoutanim = %tigertank_hatch_open;
	
	positions[ 0 ].vehicle_getoutanim = %bmp_doors_open;
	
	return positions;
}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for( i=0;i<4;i++ )
		positions[ i ] = spawnstruct();
	
	positions[ 0 ].sittag = "tag_guy1";
	positions[ 1 ].sittag = "tag_guy2";
	positions[ 2 ].sittag = "tag_guy3";
	positions[ 3 ].sittag = "tag_guy4";

	positions[ 0 ].idle = %bmp_idle_1;
	positions[ 1 ].idle = %bmp_idle_2;
	positions[ 2 ].idle = %bmp_idle_3;
	positions[ 3 ].idle = %bmp_idle_4;

	positions[ 0 ].getout = %bmp_exit_1;
	positions[ 1 ].getout = %bmp_exit_2;
	positions[ 2 ].getout = %bmp_exit_3;
	positions[ 3 ].getout = %bmp_exit_4;

	positions[ 0 ].getin = %humvee_driver_climb_in;
	positions[ 1 ].getin = %humvee_passenger_in_L;
	positions[ 2 ].getin = %humvee_passenger_in_R;
	positions[ 3 ].getin = %humvee_passenger_in_R;

	return positions;
}

