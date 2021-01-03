#using scripts\codescripts\struct;

#using scripts\cp\_load;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\audio_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                               	                                                          	              	                                                                                           




#precache( "client_fx", "explosions/fx_exp_mortar_snow" );


#namespace village;

function autoexec __init__sytem__() {     system::register("infection_village",&__init__,undefined,undefined);    }
	
//*****************************************************************************
// __init__
//*****************************************************************************
function __init__()
{	
	level thread sndRecordOutdoor();
}

//*****************************************************************************
//*****************************************************************************
function main()
{
	init_clientfields();

	level thread mortar_test();
}

//*****************************************************************************
// init_clientfields
//*****************************************************************************
function init_clientfields()
{
	clientfield::register( "world", "fold_earthquake", 		1, 1, "int", &callback_fold_earthquake, 		!true, !true );
	clientfield::register( "world", "village_mortar_index", 1, 3, "int", &callback_village_mortar_index, !true, !true );	
	clientfield::register( "world", "village_intro_mortar", 1, 1, "int", &callback_village_intro_mortar, !true, !true );
}

//*****************************************************************************
// callback_fold_earthquake
//*****************************************************************************
function callback_fold_earthquake( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	e_fold = GetEnt( localClientNum, "fold_earthquake_origin", "targetname" );
	Assert( IsDefined( e_fold ), "callback_fold_earthquake: e_fold is missing!" );
	
	if ( newVal )
	{		
		e_fold PlayRumbleLoopOnEntity( localClientNum, "cp_infection_fold" );  // note: rumble settings will determine broadcast distance
	}
	else 
	{
		e_fold StopRumble( localClientNum, "cp_infection_fold" );
	}
}

//*****************************************************************************
// sndRecordOutdoor
//*****************************************************************************
function sndRecordOutdoor()
{
	level waittill( "sndREC" );
	audio::playloopat( "evt_infection_record_outdoor", (-66583,-8277,539) );
	audio::playloopat( "evt_infection_record_outdoor", (-66974,-5736,481) );
	audio::playloopat( "evt_infection_record_outdoor", (-68367,-4740,469) );
}

//*****************************************************************************
// callback_mortar_index
//*****************************************************************************
function callback_village_mortar_index( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	level.village_mortar_index = newVal;
	level.village_mortar_index_randomize = 1;
}

//*****************************************************************************
// mortar_test
//*****************************************************************************
function mortar_test()
{
	if( !IsDefined(level.village_mortar_index) )
	{
		level.village_mortar_index = 0;		// The start index for the intro
		level.village_mortar_index_randomize = 1;
	}

	index = 0;

	delay = 0.1;

	while( 1 )
	{
		switch( level.village_mortar_index )
		{
			case 1:
				a_struct = struct::get_array( "s_village_mortar_1", "targetname" );
				delay = RandomFloatRange( 1.3, 2.0 );
			break;
						
			case 2:
				a_struct = struct::get_array( "s_village_mortar_2", "targetname" );
				delay = RandomFloatRange( 1.3, 2.0 );
			break;
			
			case 3:
				a_struct = struct::get_array( "s_village_mortar_3", "targetname" );
				delay = RandomFloatRange( 1.3, 2.2 );
			break;

			default:
			case 0:
				a_struct = undefined;
			break;
		}

		if ( IsDefined (a_struct) )
		{
			if( IsDefined(level.village_mortar_index_randomize) )
			{
				index = randomint( a_struct.size );
				level.village_mortar_index_randomize = undefined;
			}
	
			PlayFx( 0, "explosions/fx_exp_mortar_snow", a_struct[index].origin );
	
			index++;
			if( index >= a_struct.size )
			{
				index = 0;
			}
		}
			
		wait( delay );
	}
}

//*****************************************************************************
// callback_village_intro_mortar
//*****************************************************************************
function callback_village_intro_mortar( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	s_village_intro_mortar = struct::get( "s_village_intro_mortar", "targetname" );
	PlayFx( 0, "explosions/fx_exp_mortar_snow", s_village_intro_mortar.origin );
}

