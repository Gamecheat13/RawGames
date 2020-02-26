
#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_audio;

main()
{
	declareAmbientRoom("default", true );
		setAmbientRoomtone ("default", "amb_battel_2d", .2, .5);
		setAmbientRoomReverb( "default", "standoff_outdoor", 1, 1 );
		setAmbientRoomContext( "default", "ringoff_plr", "outdoor" );
/*	
	declareAmbientRoom("stone_room" );
		setAmbientRoomReverb( "under_bridge", "standoff_stoneroom", 1, 1 );
		setAmbientRoomContext( "under_bridge", "ringoff_plr", "outdoor" );

	declareAmbientRoom("small_room" );
		setAmbientRoomReverb( "small_room", "standoff_smallroom", 1, 1 );
		setAmbientRoomContext( "small_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("medium_room" );
		setAmbientRoomReverb( "medium_room", "standoff_mediumroom", 1, 1 );
		setAmbientRoomContext( "medium_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("large_room" );
		setAmbientRoomReverb( "largeroom_room", "standoff_largeroom", 1, 1 );
		setAmbientRoomContext( "largeroom_room", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("hall_room" );
		setAmbientRoomReverb( "hallroom", "standoff_hallroom", 1, 1 );
		setAmbientRoomContext( "hallroom", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("partial_room" );
		setAmbientRoomReverb( "partialroom", "standoff_partialroom", 1, 1 );
		setAmbientRoomContext( "partialroom", "ringoff_plr", "outdoor" );	
	*/
	activateAmbientRoom( 0, "default", 0 );	
}