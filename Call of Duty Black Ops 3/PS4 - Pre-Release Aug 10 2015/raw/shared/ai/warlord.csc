#using scripts\shared\clientfield_shared;


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  	   	   	   	   	   	   	    	    	                                                                                                                                                                                                           	      	                        	   	   	   	   	   	  /#         #/	  	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  	    	                                                                                                                                                                                                         

#precache( "client_fx", "electric/fx_elec_warlord_damage_1" );
#precache( "client_fx", "electric/fx_elec_warlord_damage_2" );
#precache( "client_fx", "explosions/fx_exp_warlord_death" );
#precache( "client_fx", "vehicle/fx_exhaust_jetpack_warlord_juke" );

function autoexec precache()
{
	level._effect[ "fx_elec_warlord_damage_1" ] = "electric/fx_elec_warlord_damage_1";
	level._effect[ "fx_elec_warlord_damage_2" ] = "electric/fx_elec_warlord_damage_2";
	level._effect[ "fx_exp_warlord_death" ] = "explosions/fx_exp_warlord_death";
	level._effect[ "fx_exhaust_jetpack_warlord_juke" ] = "vehicle/fx_exhaust_jetpack_warlord_juke";
}

function autoexec main()
{
	clientfield::register(
		"actor",
		"warlord_type",
		1,
		2,
		"int",
		&WarlordClientUtils::warlordTypeHandler,
		!true,
		!true);

	clientfield::register(
		"actor",
		"warlord_damage_state",
		1,
		2,
		"int",
		&WarlordClientUtils::warlordDamageStateHandler,
		!true,
		!true);
		
	clientfield::register(
		"actor",
		"warlord_thruster_direction",
		1,
		3,
		"int",
		&WarlordClientUtils::warlordThrusterHandler,
		!true,
		!true);
}

#namespace WarlordClientUtils;

function warlordDamageStateHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	entity = self;
	
	if ( IsDefined( entity.damageStateFx ) )
	{
		StopFx( localClientNum, entity.damageStateFx );
		entity.damageStateFx = undefined;
	}
	
	if ( IsDefined( entity.damageHeavyStateFx ) )
	{
		StopFx( localClientNum, entity.damageHeavyStateFx );
		entity.damageHeavyStateFx = undefined;
	}
	
	switch ( newValue )
	{
	case 0:
		break;
	case 2:
		entity.damageHeavyStateFx =
			PlayFxOnTag( localClientNum, level._effect[ "fx_elec_warlord_damage_2" ], entity, "j_spineupper");
		// break;  // This is on purpose to enable multiple FX for HEAVY_DAMAGE
	case 1:
		entity.damageStateFx =
			PlayFxOnTag( localClientNum, level._effect[ "fx_elec_warlord_damage_1" ], entity, "j_spineupper");
		break;
	case 3:
		PlayFxOnTag( localClientNum, level._effect[ "fx_exp_warlord_death" ], entity, "tag_origin");
		break;
	}
}

function warlordTypeHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	entity = self;
	entity.warlordType = newValue;
}

function warlordThrusterHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	entity = self;
	
	if ( IsDefined( entity.thrusterFx ) )
	{
		assert( IsArray( entity.thrusterFx ) );
		
		for ( index = 0; index < entity.thrusterFx.size; index++ )
		{
			StopFx( localClientNum, entity.thrusterFx[index] );
		}
	}
	
	entity.thrusterFx = [];
	tags = [];
	
	switch ( newValue )
	{
	case 0:
		break;
	case 1:
		tags = array( "tag_jets_left_front", "tag_jets_right_front" );
		break;
	case 2:
		tags = array( "tag_jets_left_back", "tag_jets_right_back" );
		break;
	case 3:
		tags = array( "tag_jets_left_side" );
		break;
	case 4:
		tags = array( "tag_jets_right_side" );
		break;
	}
	
	for ( index = 0; index < tags.size; index++ )
	{
		entity.thrusterFx[ entity.thrusterFx.size] =
			PlayFxOnTag( localClientNum, level._effect[ "fx_exhaust_jetpack_warlord_juke" ], entity, tags[index] );
	}
}

// end of #namespace WarlordClientUtils
