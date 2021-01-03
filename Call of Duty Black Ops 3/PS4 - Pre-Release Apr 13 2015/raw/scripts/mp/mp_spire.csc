#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       


#using scripts\mp\_load;

#using scripts\mp\mp_spire_amb;
#using scripts\mp\mp_spire_fx;



	



// Test clientside script for mp_spire

function main()
{
	clientfield::register( "world", "mpSpireExteriorBillboard", 1, 2, "int", &exteriorBillboard, true, true );
	
	// _load!
	load::main();

	mp_spire_fx::main();

	thread mp_spire_amb::main();

	exteriorBillboardSetup();
	//conferenceBillboardSetup();

	// This needs to be called after all systems have been registered.
	util::waitforclient( 0 );	
	
	/# println("*** Client : mp_spire running..."); #/
	//level thread conference_billboard_exploders_manager( 0 );	
}

function exteriorBillboardSetup()
{
	level.billboardFXRightArray = [];
	level.billboardFXRightArray[0] = "mp_spire_billboard_r_A";
	level.billboardFXRightArray[1] = "mp_spire_billboard_r_B";
	level.billboardFXRightArray[2] = "mp_spire_billboard_r_C";
	level.billboardFXRightArray[3] = "mp_spire_billboard_r_D";
	assert( level.billboardFXRightArray.size == 4 );

	level.billboardFXLeftArray = [];
	level.billboardFXLeftArray[0] = "mp_spire_billboard_L_A";
	level.billboardFXLeftArray[1] = "mp_spire_billboard_L_B";
	level.billboardFXLeftArray[2] = "mp_spire_billboard_L_C";
	level.billboardFXLeftArray[3] = "mp_spire_billboard_L_D";
	assert( level.billboardFXLeftArray.size == 4 );
	
	level.billboardFXArray = [];
	level.billboardFXArray[0] = "mp_spire_billboard_fx_A";
	level.billboardFXArray[1] = "mp_spire_billboard_fx_B";
	level.billboardFXArray[2] = "mp_spire_billboard_fx_C";
	level.billboardFXArray[3] = "mp_spire_billboard_fx_D";
	assert( level.billboardFXLeftArray.size == 4 );

//	level.billboardLightRightArray = [];
//	level.billboardLightRightArray[0] = "lgt_billboard_sm_r_01_spire";
//	level.billboardLightRightArray[1] = "lgt_billboard_sm_r_02_spire";
//	level.billboardLightRightArray[2] = "lgt_billboard_sm_r_03_spire";
//	level.billboardLightRightArray[3] = "lgt_billboard_sm_r_04_spire";
//	assert( level.billboardLightRightArray.size == EXTERNAL_BILLBOARD_EXPLODER_COUNT );
//
//	level.billboardLightLeftArray = [];
//	level.billboardLightLeftArray[0] = "lgt_billboard_sm_L_01_spire";
//	level.billboardLightLeftArray[1] = "lgt_billboard_sm_L_02_spire";
//	level.billboardLightLeftArray[2] = "lgt_billboard_sm_L_03_spire";
//	level.billboardLightLeftArray[3] = "lgt_billboard_sm_L_04_spire";
//	assert( level.billboardLightLeftArray.size == EXTERNAL_BILLBOARD_EXPLODER_COUNT );
//
//
//	level.billboardLightArray = [];
//	level.billboardLightArray[0] = "mp_spire_billboard_LGT_A";
//	level.billboardLightArray[1] = "mp_spire_billboard_LGT_B";
//	level.billboardLightArray[2] = "mp_spire_billboard_LGT_C";
//	level.billboardLightArray[3] = "mp_spire_billboard_LGT_D";
//	assert( level.billboardLightLeftArray.size == EXTERNAL_BILLBOARD_EXPLODER_COUNT );	
}

function conferenceBillboardSetup()
{
	level.conferenceRoomA_LightArray = [];
	level.conferenceRoomA_LightArray[0] = "lgt_financial_R_1";
	level.conferenceRoomA_LightArray[1] = "lgt_financial_R_2";
	level.conferenceRoomA_LightArray[2] = "lgt_financial_R_3";
	level.conferenceRoomA_LightArray[3] = "lgt_financial_R_4";
	assert( level.conferenceRoomA_LightArray.size == 4 );
		
	level.conferenceRoomA_FXArray = [];
	level.conferenceRoomA_FXArray[0] = "fx_exp_spire_con_room_a_01";
	level.conferenceRoomA_FXArray[1] = "fx_exp_spire_con_room_a_02";
	level.conferenceRoomA_FXArray[2] = "fx_exp_spire_con_room_a_03";
	level.conferenceRoomA_FXArray[3] = "fx_exp_spire_con_room_a_04";
	assert( level.conferenceRoomA_FXArray.size == 4 );
	
	level.conferenceRoomB_LightArray = [];
	level.conferenceRoomB_LightArray[0] = "lgt_financial_L_1";
	level.conferenceRoomB_LightArray[1] = "lgt_financial_L_2";
	level.conferenceRoomB_LightArray[2] = "lgt_financial_L_3";
	level.conferenceRoomB_LightArray[3] = "lgt_financial_L_4";
	assert( level.conferenceRoomB_LightArray.size == 4 );
		
	level.conferenceRoomB_FXArray = [];
	level.conferenceRoomB_FXArray[0] = "fx_exp_spire_con_room_b_01";
	level.conferenceRoomB_FXArray[1] = "fx_exp_spire_con_room_b_02";
	level.conferenceRoomB_FXArray[2] = "fx_exp_spire_con_room_b_03";
	level.conferenceRoomB_FXArray[3] = "fx_exp_spire_con_room_b_04";
	assert( level.conferenceRoomB_FXArray.size == 4 );
}

function exteriorBillboard( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	level notify("exteriorBillboard" );
	level endon("exteriorBillboard" );
	
	assert( newVal >= 0 );
	assert( newVal < 4 );
	if ( newVal < 0 || newVal > 4 )
	{
		return;
	}
		
	util::WaitForClient( localClientNum );

	for ( i = 0; i < 4; i++ )
	{		
		//KillRadiantExploder( localClientNum, level.billboardLightRightArray[i] );
		//KillRadiantExploder( localClientNum, level.billboardLightLeftArray[i] );
		//KillRadiantExploder( localClientNum, level.billboardLightArray[i] );
		
		KillRadiantExploder( localClientNum, level.billboardFXRightArray[i] );
		KillRadiantExploder( localClientNum, level.billboardFXLeftArray[i] );
		KillRadiantExploder( localClientNum, level.billboardFXArray[i] );			
	}

	//PlayRadiantExploder( localClientNum, level.billboardLightRightArray[newVal] );
	//PlayRadiantExploder( localClientNum, level.billboardLightLeftArray[newVal] );
	//PlayRadiantExploder( localClientNum, level.billboardLightArray[newVal] );

	PlayRadiantExploder( localClientNum, level.billboardFXRightArray[newVal] );
	PlayRadiantExploder( localClientNum, level.billboardFXLeftArray[newVal] );
	PlayRadiantExploder( localClientNum, level.billboardFXArray[newVal] );
}

function conference_billboard_exploders_manager( localClientNum )
{
	level thread conference_billboard_exploders( localClientNum, &conferenceBillboardRoomA );
	level thread conference_billboard_exploders( localClientNum, &conferenceBillboardRoomB );
}

function conference_billboard_exploders( localClientNum, exploderFunction )
{
	currentExploder = 0;
	while( 1 )
	{
		currentExploder += randomInt( 4 - 1 );
		currentExploder = currentExploder % 4;
		
		level [[exploderFunction]]( localClientNum, currentExploder );

		util::server_wait( localClientNum, randomFloatRange( 0.04, 0.09 ) );
	}
}



function conferenceBillboardRoomA( localClientNum, exploderIndex )
{
	level notify("conferenceBillboardRoomA" );
	level endon("conferenceBillboardRoomA" );
	/#
	assert( exploderIndex >= 0 );
	assert( exploderIndex < 4 );
	if ( exploderIndex < 0 || exploderIndex > 4 )
	{
		return;
	}
	#/
	
	util::WaitForClient( localClientNum );
	
	if ( isdefined( level.conferenceBillboardRoomAExploder ) )
	{
		KillRadiantExploder( localClientNum, level.conferenceRoomA_LightArray[level.conferenceBillboardRoomAExploder] );
		KillRadiantExploder( localClientNum, level.conferenceRoomA_FXArray[level.conferenceBillboardRoomAExploder] );
	}
	level.conferenceBillboardRoomAExploder = exploderIndex;
	
	PlayRadiantExploder( localClientNum, level.conferenceRoomA_LightArray[exploderIndex] );
	PlayRadiantExploder( localClientNum, level.conferenceRoomA_FXArray[exploderIndex] );
}

function conferenceBillboardRoomB( localClientNum, exploderIndex )
{
	level notify("conferenceBillboardRoomB" );
	level endon("conferenceBillboardRoomB" );
	/#
	assert( exploderIndex >= 0 );
	assert( exploderIndex < 4 );
	if ( exploderIndex < 0 || exploderIndex > 4 )
	{
		return;
	}
	#/
	
	util::WaitForClient( localClientNum );

	if ( isdefined( level.conferenceBillboardRoomBExploder ) )
	{
		KillRadiantExploder( localClientNum, level.conferenceRoomB_LightArray[level.conferenceBillboardRoomBExploder] );
		KillRadiantExploder( localClientNum, level.conferenceRoomB_FXArray[level.conferenceBillboardRoomBExploder] );
	}
	level.conferenceBillboardRoomBExploder = exploderIndex;
	
	PlayRadiantExploder( localClientNum, level.conferenceRoomB_LightArray[exploderIndex] );
	PlayRadiantExploder( localClientNum, level.conferenceRoomB_FXArray[exploderIndex] );
}