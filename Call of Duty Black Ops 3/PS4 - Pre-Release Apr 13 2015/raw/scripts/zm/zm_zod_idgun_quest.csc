    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_load;

#using_animtree( "generic" );


#namespace zm_zod_idgun_quest;

function autoexec __init__sytem__() {     system::register("zm_zod_idgun_quest",&__init__,undefined,undefined);    }

function __init__()
{
	// clientfield - track idguns currently in magic box for the client
	clientfield::register( "world", "idguns_in_box", 1, 2, "int", &idguns_in_box, !true, true );

	// clientfield - which locations have been chosen for each idgun's upgrade point?
	n_bits = GetMinBitCountForNum( 4 );
	clientfield::register( "world", "idgun_0_quest_loc", 1, n_bits, "int", &idgun_0_quest_loc, !true, !true );
	clientfield::register( "world", "idgun_1_quest_loc", 1, n_bits, "int", &idgun_1_quest_loc, !true, !true );

	// clientfield - progression vfx for each idgun
	n_bits = GetMinBitCountForNum( 6 );
	clientfield::register( "world", "idgun_0_quest_state", 1, n_bits, "int", &idgun_0_quest_state, !true, !true );
	clientfield::register( "world", "idgun_1_quest_state", 1, n_bits, "int", &idgun_1_quest_state, !true, !true );
}

// add idguns to the client magic box, so they can appear in the visual rotation when the box is used
function idguns_in_box( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal > 0 )
	{
		weapon_idgun = GetWeapon( "idgun" );
		AddZombieBoxWeapon( weapon_idgun, weapon_idgun.worldModel, weapon_idgun.isDualWield );
	}
}

function idgun_setup_models( localClientNum, n_current_gun )
{
	// only do once
	idgun_setup_struct_for_gun_instance( localClientNum, n_current_gun );

	if( isdefined( level.idgun_client[ localClientNum ][ n_current_gun ].mdl_3rd_person ) && isdefined( level.idgun_client[ localClientNum ][ n_current_gun ].mdl_cocoon ) )
	{
		return;
	}

	n_quest_loc = level.idgun_client[ localClientNum ][ n_current_gun ].script_int;
	
	// get the upgrade point position that was rolled when the level started
	a_s_upgrade_points = struct::get_array( "idgun_upgrade_point", "targetname" );
	foreach( s_upgrade_point in a_s_upgrade_points )
	{
		if( s_upgrade_point.script_int == n_quest_loc )
		{
			level.idgun_client[ localClientNum ][ n_current_gun ].s_upgrade_point = s_upgrade_point;
		}
	}
	
	s_upgrade_point = level.idgun_client[ localClientNum ][ n_current_gun ].s_upgrade_point; // easy of reading
	
	// setup model for the upgrade point idgun
	level.idgun_client[ localClientNum ][ n_current_gun ].mdl_3rd_person = Spawn( localClientNum, s_upgrade_point.origin, "script_model" );
	level.idgun_client[ localClientNum ][ n_current_gun ].mdl_3rd_person.angles = s_upgrade_point.angles;
	level.idgun_client[ localClientNum ][ n_current_gun ].mdl_3rd_person SetModel( "wpn_t7_zmb_zod_idg_world" );
	
	// setup model for the upgrade point cocoon
	level.idgun_client[ localClientNum ][ n_current_gun ].mdl_cocoon = Spawn( localClientNum, s_upgrade_point.origin, "script_model" );
	level.idgun_client[ localClientNum ][ n_current_gun ].mdl_cocoon SetModel( "p7_zm_zod_cocoon" );
}

function idgun_0_quest_loc( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	idgun_record_cocoon_loc( localClientNum, 0, newVal );
}

function idgun_1_quest_loc( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	idgun_record_cocoon_loc( localClientNum, 1, newVal );
}

function idgun_record_cocoon_loc( localClientNum, n_current_gun, n_quest_loc )
{
	idgun_setup_struct_for_gun_instance( localClientNum, n_current_gun );

	level.idgun_client[ localClientNum ][ n_current_gun ].script_int = n_quest_loc;
}

function idgun_setup_struct_for_gun_instance( localClientNum, n_current_gun )
{
	if( !isdefined( level.idgun_client ) )
	{
		level.idgun_client = [];
	}

	if( !isdefined( level.idgun_client[ localClientNum ] ) )
	{
		level.idgun_client[ localClientNum ] = [];
	}
	
	if( !isdefined( level.idgun_client[ localClientNum ][ n_current_gun ] ) )
	{
		level.idgun_client[ localClientNum ][ n_current_gun ] = SpawnStruct();
	}
}

function idgun_0_quest_state( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	idgun_quest_state( localClientNum, newVal, 0 );
}

function idgun_1_quest_state( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	idgun_quest_state( localClientNum, newVal, 1 );
}

// display effects that are updated when the idgun advances in state
function idgun_quest_state( localClientNum, newVal, n_current_gun )
{
	level notify( "idgun_update_state_" + n_current_gun );

	idgun_setup_models( localClientNum, n_current_gun );

	// get the 3rd person model of the idgun
	mdl_idgun	=	level.idgun_client[ localClientNum ][ n_current_gun ].mdl_3rd_person;
	mdl_cocoon	=	level.idgun_client[ localClientNum ][ n_current_gun ].mdl_cocoon;
	
	switch( newVal )
	{
		case 0:
			mdl_idgun Hide();
			mdl_cocoon Hide();
			
			break;
			
		case 1:
			mdl_idgun Hide();
			mdl_cocoon Hide();
			
			break;
			
		case 2:
			mdl_idgun Show();
			mdl_cocoon Hide();
			
			// play cocooning vfx & hide gun / show cocoon
			mdl_cocoon.vfx_cocoon_on = PlayFXOnTag( localClientNum, level._effect[ "idgun_cocoon_on" ], mdl_cocoon, "tag_origin" );
			wait 1; // give effect a moment to play
			mdl_cocoon Show();
			mdl_idgun Hide();
			
			break;
			
		case 3:
			mdl_idgun Hide();
			mdl_cocoon Show();
			
			break;
			
		case 4:
			mdl_idgun Hide();
			mdl_cocoon Show();
			
			// play hatching vfx & hide cocoon / show gun
			mdl_cocoon.vfx_cocoon_off = PlayFXOnTag( localClientNum, level._effect[ "idgun_cocoon_off" ], mdl_cocoon, "tag_origin" );
			wait 1; // give effect a moment to play
			mdl_cocoon Hide();
			mdl_idgun Show();
			
			break;
			
		case 5:
			mdl_idgun Hide();
			mdl_cocoon Hide();
			
			break;
	}
}
