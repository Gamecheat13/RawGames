#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_load;

#using scripts\cp\cp_mi_sing_biodomes2_fx;
#using scripts\cp\cp_mi_sing_biodomes2_sound;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

function main()
{
	clientfields_init();
	
	cp_mi_sing_biodomes2_fx::main();
	cp_mi_sing_biodomes2_sound::main();
	
	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
}

function clientfields_init()
{
	// FX Anim bits
	clientfield::register( "world", "warehouse_window_break", 1, 1, "int", &warehouse_window_break, !true, !true );
	clientfield::register( "world", "server_room_window_break", 1, 1, "int", &server_room_window_break, !true, !true );
	clientfield::register( "world", "control_room_window_break", 1, 1, "int", &control_room_window_break, !true, !true );
	clientfield::register( "world", "tall_grass_init", 1, 1, "int", &tall_grass_init_func, !true, !true );
	clientfield::register( "world", "tall_grass_play", 1, 1, "int", &tall_grass_play_func, !true, !true );
	clientfield::register( "toplayer", "server_extra_cam", 1, 5, "int", &server_extra_cam, !true, !true );
	clientfield::register( "toplayer", "server_interact_cam", 1, 3, "int", &server_interact_cam, !true, !true );
	clientfield::register( "world", "supertree_fall_init", 1, 1, "int", &supertree_init, !true, !true );
	clientfield::register( "world", "supertree_fall_play", 1, 1, "int", &supertree_play, !true, !true );
	clientfield::register( "world", "ferriswheel_fall_play", 1, 1, "int", &ferriswheel_play, !true, !true );
}

function warehouse_window_break( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "p7_fxanim_cp_biodomes_warehouse_glass_break_bundle");
	}
}

function server_room_window_break( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "p7_fxanim_cp_biodomes_server_room_window_break_bundle" );
	}
}

function control_room_window_break( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "p7_fxanim_cp_biodomes_server_room_window_break_02_bundle");
	}
}

function tall_grass_init_func( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::init( "p7_fxanim_cp_biodomes_boat_grass_bundle" ); //this makes the grass it show up in the level
	}
}

function tall_grass_play_func( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "p7_fxanim_cp_biodomes_boat_grass_bundle" ); //this makes the grass start playing its canned animation
	}
}

function supertree_init( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::init( "p7_fxanim_cp_biodomes_super_tree_collapse_bundle" );
	}
}

function supertree_play( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "p7_fxanim_cp_biodomes_super_tree_collapse_bundle" );
	}
}

function ferriswheel_play( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "p7_fxanim_cp_biodomes_ferris_wheel_bundle" );
	}
}

function server_extra_cam( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	e_xcam1 = GetEnt( localClientNum, "server_camera1", "targetname" ); //hallway
	e_xcam2 = GetEnt( localClientNum, "server_camera2", "targetname" ); //hendricks
	e_xcam3 = GetEnt( localClientNum, "server_camera3", "targetname" ); //window
	e_xcam4 = GetEnt( localClientNum, "server_camera4", "targetname" ); //top floor
	
	switch ( newVal ) 
	{
		case 0: //turn it off
//HACK temp workaround for this clientfield function running whenever a player respawns
//			e_xcam1 Delete();
//			e_xcam2 Delete();
//			e_xcam3 Delete();
//			e_xcam4 Delete();			
			break;
			
		case 1: //turn it on
			e_xcam2 SetExtraCam( 0 ); //put hendricks on main screen to start
			e_xcam2 SetExtraCam( 3 ); //and put hendricks on interactable screen to start
			e_xcam1 SetExtraCam( 1 ); //hallway on 2nd
			e_xcam3 SetExtraCam( 2 ); //window on 3rd
			break;
			
		case 2: 
			e_xcam1 SetExtraCam( 0 ); //hallway cam on main screen
			break;
			
		case 3: 
			e_xcam3 SetExtraCam( 0 ); //window cam on main screen
			e_xcam3 RotateYaw( 35 , 2 ); //rotate towards window
			break;
			
		case 4:
			e_xcam4 SetExtraCam( 0 ); //top floor cam on main screen
			break;
		
		case 5:
			e_xcam3 SetExtraCam( 0 ); //window cam on main screen
			e_xcam3 RotateYaw( -35 , 2 ); //rotate towards vtol
			break;
	}
}
	
function server_interact_cam( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	e_xcam1 = GetEnt( localClientNum, "server_camera1", "targetname" ); //hallway
	e_xcam2 = GetEnt( localClientNum, "server_camera2", "targetname" ); //hendricks
	e_xcam3 = GetEnt( localClientNum, "server_camera3", "targetname" ); //window
	e_xcam4 = GetEnt( localClientNum, "server_camera4", "targetname" ); //top floor
	
	switch ( newVal ) 
	{
		case 0:
			e_xcam2 SetExtraCam( 3 ); //starts on Hendricks
			break;
			
		case 1:
			e_xcam3 SetExtraCam( 3 ); //window & vtol
			break;
			
		case 2:
			e_xcam4 SetExtraCam( 3 ); //top floor
			break;
			
		case 3:
			e_xcam1 SetExtraCam( 3 ); //hallway
			break;
	}
}