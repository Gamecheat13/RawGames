//
// file: frontend_amb.csc
// description: clientside ambient script for frontend: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_music;
#include clientscripts\_busing;
#include clientscripts\_audio;

main()
{

	declaremusicState ("FRONT_END_MAIN");
		
		musicAliasloop ("mus_frontend_loop", 0, 0);
}

