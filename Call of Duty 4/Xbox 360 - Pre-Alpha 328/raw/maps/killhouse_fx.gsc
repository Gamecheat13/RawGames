main()

{
	level._effect["watermelon"]						= loadfx("props/watermelon");
	level._effect["ambush_vl"]						= loadfx ("misc/ambush_vl");

	

//	maps\_treadfx::setallvehiclefx( "cobra", undefined ); //disables cobras treads
//	setExpFog(800, 6000, .583, .644 , .587, 0);

	maps\createfx\killhouse_fx::main();

}