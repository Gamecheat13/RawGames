#include maps\_vehicle;

#using_animtree( "vehicles" );
main()
{
	//build_aianims( ::setanims , ::set_vehicle_anims );

	//self build_drive( %abrams_movement, %abrams_movement_backwards, 10 );
//	build_deckdust( "dust/abrams_desk_dust" );
}

set_vehicle_anims( positions )
{
	/*
	positions[ 0 ].vehicle_getinanim = %tigertank_hatch_open;
	positions[ 1 ].vehicle_getoutanim = %tigertank_hatch_open;
	*/
	return positions;
}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for( i=0;i<11;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].getout_delete = true;


	return positions;
}
