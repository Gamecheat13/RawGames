#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

#include maps\mp\zm_transit_utility;

#insert raw\common_scripts\utility.gsh;

//*****************************************************************************
// RiotShield Buildable
//*****************************************************************************

onBeginUse_RiotShield( player )
{
	// CallBack When Player Uses Buildable Piece On Target
	//----------------------------------------------------
/#	PrintLn( "ZM >> RiotShield Buildable CallBack onBeginUse()" );	#/

}

onCantUse_RiotShield( player )
{
	// CallBack When Player Doesn't Have Buildable Piece And Tries To Use Target
	//--------------------------------------------------------------------------
/#	PrintLn( "ZM >> RiotShield Buildable CallBack onCantUse()" );	#/

}

onDrop_RiotShield( player )
{
	// CallBack When Player Drops Buildable Piece
	//-------------------------------------------
/#	PrintLn( "ZM >> RiotShield Buildable CallBack onDrop()" );	#/

	self dropOnBus( player );
}

onEndUse_RiotShield( team, player, result )
{
	// CallBack When Player Stops Using Buildable Piece On Target
	//-----------------------------------------------------------
/#	PrintLn( "ZM >> RiotShield Buildable CallBack onEndUse()" );	#/

}

onPickup_RiotShield( player )
{
	// CallBack When Player Picks Up Buildable Piece
	//----------------------------------------------
/#	PrintLn( "ZM >> RiotShield Buildable CallBack onPickUp()" );	#/

	self pickupFromBus();
}

onUsePlantObject_RiotShield( player )
{
	// CallBack When Player Successfully Builds On Target
	//---------------------------------------------------
/#	PrintLn( "ZM >> RiotShield Buildable CallBack onUsePlantObject()" );	#/

}

//*****************************************************************************
// Cattle Catcher Buildable
//*****************************************************************************

onBeginUse_CattleCatcher( player )
{
	// CallBack When Player Uses Buildable Piece On Target
	//----------------------------------------------------
/#	PrintLn( "ZM >> CattleCatcher Buildable CallBack onBeginUse()" );	#/

}

onCantUse_CattleCatcher( player )
{
	// CallBack When Player Doesn't Have Buildable Piece And Tries To Use Target
	//--------------------------------------------------------------------------
/#	PrintLn( "ZM >> CattleCatcher Buildable CallBack onCantUse()" );	#/

}

onDrop_CattleCatcher( player )
{
	// CallBack When Player Drops Buildable Piece
	//-------------------------------------------
/#	PrintLn( "ZM >> CattleCatcher Buildable CallBack onDrop()" );	#/

	self dropOnBus( player );

	usePlowTrigger = GetEnt( "trigger_plow_use", "targetname" );
	if ( IsDefined( usePlowTrigger ) )
	{
		usePlowTrigger SetInvisibleToAll();
	}
}

onEndUse_CattleCatcher( team, player, result )
{
	// CallBack When Player Stops Using Buildable Piece On Target
	//-----------------------------------------------------------
/#	PrintLn( "ZM >> CattleCatcher Buildable CallBack onEndUse()" );	#/

}

onPickup_CattleCatcher( player )
{
	// CallBack When Player Picks Up Buildable Piece
	//----------------------------------------------
/#	PrintLn( "ZM >> CattleCatcher Buildable CallBack onPickUp()" );	#/

	self pickupFromBus();

	usePlowTrigger = GetEnt( "trigger_plow_use", "targetname" );
	if ( IsDefined( usePlowTrigger ) )
	{
		usePlowTrigger SetVisibleToPlayer( player );
	}
}

onUsePlantObject_CattleCatcher( player )
{
	// CallBack When Player Successfully Builds On Target
	//---------------------------------------------------
/#	PrintLn( "ZM >> CattleCatcher Buildable CallBack onUsePlantObject()" );	#/

	usePlowTrigger = GetEnt( "trigger_plow_use", "targetname" );
	if ( IsDefined( usePlowTrigger ) )
	{
		usePlowTrigger UnLink();
		usePlowTrigger SetInvisibleToAll(); // TODO: Cleanup
	}

	if ( IsDefined( level.the_bus ) )
	{
		plowPoint = GetEnt( "plow_attach_point", "targetname" );
		level.the_bus.plow = Spawn( "script_model", plowPoint.origin );
		level.the_bus.plow.angles = plowPoint.angles;
		level.the_bus.plow SetModel( "zb_plow" );
		level.the_bus.plow LinkTo( level.the_bus );

		level.the_bus.upgrades[ "Plow" ].installed = true;
		level.the_bus maps\mp\zm_transit_openings::busOpeningSetEnabled( "front", false );
	}
}

//*****************************************************************************
// PowerSwitch Buildable
//*****************************************************************************

onBeginUse_PowerSwitch( player )
{
	// CallBack When Player Uses Buildable Piece On Target
	//----------------------------------------------------
/#	PrintLn( "ZM >> PowerSwitch Buildable CallBack onBeginUse()" );	#/

}

onCantUse_PowerSwitch( player )
{
	// CallBack When Player Doesn't Have Buildable Piece And Tries To Use Target
	//--------------------------------------------------------------------------
/#	PrintLn( "ZM >> PowerSwitch Buildable CallBack onCantUse()" );	#/

}

onDrop_PowerSwitch( player )
{
	// CallBack When Player Drops Buildable Piece
	//-------------------------------------------
/#	PrintLn( "ZM >> PowerSwitch Buildable CallBack onDrop()" );	#/

	self dropOnBus( player );
}

onEndUse_PowerSwitch( team, player, result )
{
	// CallBack When Player Stops Using Buildable Piece On Target
	//-----------------------------------------------------------
/#	PrintLn( "ZM >> PowerSwitch Buildable CallBack onEndUse()" );	#/

}

onPickup_PowerSwitch( player )
{
	// CallBack When Player Picks Up Buildable Piece
	//----------------------------------------------
/#	PrintLn( "ZM >> PowerSwitch Buildable CallBack onPickUp()" );	#/

	self pickupFromBus();
}

onUsePlantObject_PowerSwitch( player )
{
	// CallBack When Player Successfully Builds On Target
	//---------------------------------------------------
/#	PrintLn( "ZM >> PowerSwitch Buildable CallBack onUsePlantObject()" );	#/

	switch( player.carryObject.visuals[ 0 ].model )
	{
		case "p_zom_pack_a_punch_battery":
		{
			GetEnt( "powerswitch_p_zom_pack_a_punch_battery", "targetname" ) Show();
		} break;
		case "p_zom_moon_power_lever_short":
		{
			GetEnt( "powerswitch_p_zom_moon_power_lever_short", "targetname" ) Show();
		} break;
		case "p6_power_lever":
		{
			GetEnt( "powerswitch_p6_power_lever", "targetname" ) Show();
		} break;
	}
}

//*****************************************************************************
// PackAPunch Buildable
//*****************************************************************************

onBeginUse_PackAPunch( player )
{
	// CallBack When Player Uses Buildable Piece On Target
	//----------------------------------------------------
/#	PrintLn( "ZM >> PackAPunch Buildable CallBack onBeginUse()" );	#/

}

onCantUse_PackAPunch( player )
{
	// CallBack When Player Doesn't Have Buildable Piece And Tries To Use Target
	//--------------------------------------------------------------------------
/#	PrintLn( "ZM >> PackAPunch Buildable CallBack onCantUse()" );	#/

}

onDrop_PackAPunch( player )
{
	// CallBack When Player Drops Buildable Piece
	//-------------------------------------------
/#	PrintLn( "ZM >> PackAPunch Buildable CallBack onDrop()" );	#/

	self dropOnBus( player );
}

onEndUse_PackAPunch( team, player, result )
{
	// CallBack When Player Stops Using Buildable Piece On Target
	//-----------------------------------------------------------
/#	PrintLn( "ZM >> PackAPunch Buildable CallBack onEndUse()" );	#/

}

onPickup_PackAPunch( player )
{
	// CallBack When Player Picks Up Buildable Piece
	//----------------------------------------------
/#	PrintLn( "ZM >> PackAPunch Buildable CallBack onPickUp()" );	#/

	self pickupFromBus();
}

onUsePlantObject_PackAPunch( player )
{
	// CallBack When Player Successfully Builds On Target
	//---------------------------------------------------
/#	PrintLn( "ZM >> PackAPunch Buildable CallBack onUsePlantObject()" );	#/

}

//*****************************************************************************
// Turbine Buildable
//*****************************************************************************

onBeginUse_Turbine( player )
{
	// CallBack When Player Uses Buildable Piece On Target
	//----------------------------------------------------
/#	PrintLn( "ZM >> Turbine Buildable CallBack onBeginUse()" );	#/

}

onCantUse_Turbine( player )
{
	// CallBack When Player Doesn't Have Buildable Piece And Tries To Use Target
	//--------------------------------------------------------------------------
/#	PrintLn( "ZM >> Turbine Buildable CallBack onCantUse()" );	#/

}

onDrop_Turbine( player )
{
	// CallBack When Player Drops Buildable Piece
	//-------------------------------------------
/#	PrintLn( "ZM >> Turbine Buildable CallBack onDrop()" );	#/

	self dropOnBus( player );
}

onEndUse_Turbine( team, player, result )
{
	// CallBack When Player Stops Using Buildable Piece On Target
	//-----------------------------------------------------------
/#	PrintLn( "ZM >> Turbine Buildable CallBack onEndUse()" );	#/

}

onPickup_Turbine( player )
{
	// CallBack When Player Picks Up Buildable Piece
	//----------------------------------------------
/#	PrintLn( "ZM >> Turbine Buildable CallBack onPickUp()" );	#/

	self pickupFromBus();
}

onUsePlantObject_Turbine( player )
{
	// CallBack When Player Successfully Builds On Target
	//---------------------------------------------------
/#	PrintLn( "ZM >> Turbine Buildable CallBack onUsePlantObject()" );	#/
	
}

//*****************************************************************************
// Turret Buildable
//*****************************************************************************

onBeginUse_Turret( player )
{
	// CallBack When Player Uses Buildable Piece On Target
	//----------------------------------------------------
/#	PrintLn( "ZM >> Turret Buildable CallBack onBeginUse()" );	#/

}

onCantUse_Turret( player )
{
	// CallBack When Player Doesn't Have Buildable Piece And Tries To Use Target
	//--------------------------------------------------------------------------
/#	PrintLn( "ZM >> Turret Buildable CallBack onCantUse()" );	#/

}

onDrop_Turret( player )
{
	// CallBack When Player Drops Buildable Piece
	//-------------------------------------------
/#	PrintLn( "ZM >> Turret Buildable CallBack onDrop()" );	#/

	self dropOnBus( player );
}

onEndUse_Turret( team, player, result )
{
	// CallBack When Player Stops Using Buildable Piece On Target
	//-----------------------------------------------------------
/#	PrintLn( "ZM >> Turret Buildable CallBack onEndUse()" );	#/

}

onPickup_Turret( player )
{
	// CallBack When Player Picks Up Buildable Piece
	//----------------------------------------------
/#	PrintLn( "ZM >> Turret Buildable CallBack onPickUp()" );	#/

	self pickupFromBus();
}

onUsePlantObject_Turret( player )
{
	// CallBack When Player Successfully Builds On Target
	//---------------------------------------------------
/#	PrintLn( "ZM >> Turret Buildable CallBack onUsePlantObject()" );	#/

}

//*****************************************************************************
// ElectricTrap Buildable
//*****************************************************************************

onBeginUse_ElectricTrap( player )
{
	// CallBack When Player Uses Buildable Piece On Target
	//----------------------------------------------------
/#	PrintLn( "ZM >> ElectricTrap Buildable CallBack onBeginUse()" );	#/

}

onCantUse_ElectricTrap( player )
{
	// CallBack When Player Doesn't Have Buildable Piece And Tries To Use Target
	//--------------------------------------------------------------------------
/#	PrintLn( "ZM >> ElectricTrap Buildable CallBack onCantUse()" );		#/

}

onDrop_ElectricTrap( player )
{
	// CallBack When Player Drops Buildable Piece
	//-------------------------------------------
/#	PrintLn( "ZM >> ElectricTrap Buildable CallBack onDrop()" );	#/

	self dropOnBus( player );
}

onEndUse_ElectricTrap( team, player, result )
{
	// CallBack When Player Stops Using Buildable Piece On Target
	//-----------------------------------------------------------
/#	PrintLn( "ZM >> ElectricTrap Buildable CallBack onEndUse()" );	#/

}

onPickup_ElectricTrap( player )
{
	// CallBack When Player Picks Up Buildable Piece
	//----------------------------------------------
/#	PrintLn( "ZM >> ElectricTrap Buildable CallBack onPickUp()" );	#/

	self pickupFromBus();
}

onUsePlantObject_ElectricTrap( player )
{
	// CallBack When Player Successfully Builds On Target
	//---------------------------------------------------
/#	PrintLn( "ZM >> ElectricTrap Buildable CallBack onUsePlantObject()" );	#/

}

//*****************************************************************************
// JetGun Buildable
//*****************************************************************************

onBeginUse_JetGun( player )
{
	// CallBack When Player Uses Buildable Piece On Target
	//----------------------------------------------------
/#	PrintLn( "ZM >> JetGun Buildable CallBack onBeginUse()" );	#/

}

onCantUse_JetGun( player )
{
	// CallBack When Player Doesn't Have Buildable Piece And Tries To Use Target
	//--------------------------------------------------------------------------
/#	PrintLn( "ZM >> JetGun Buildable CallBack onCantUse()" );	#/

}

onDrop_JetGun( player )
{
	// CallBack When Player Drops Buildable Piece
	//-------------------------------------------
/#	PrintLn( "ZM >> JetGun Buildable CallBack onDrop()" );	#/

	self dropOnBus( player );
}

onEndUse_JetGun( team, player, result )
{
	// CallBack When Player Stops Using Buildable Piece On Target
	//-----------------------------------------------------------
/#	PrintLn( "ZM >> JetGun Buildable CallBack onEndUse()" );	#/

}

onPickup_JetGun( player )
{
	// CallBack When Player Picks Up Buildable Piece
	//----------------------------------------------
/#	PrintLn( "ZM >> JetGun Buildable CallBack onPickUp()" );	#/

	self pickupFromBus();
}

onUsePlantObject_JetGun( player )
{
	// CallBack When Player Successfully Builds On Target
	//---------------------------------------------------
/#	PrintLn( "ZM >> JetGun Buildable CallBack onUsePlantObject()" );	#/

}

//*****************************************************************************
// BusHatch Buildable
//*****************************************************************************

onBeginUse_BusHatch( player )
{
	// CallBack When Player Uses Buildable Piece On Target
	//----------------------------------------------------
/#	PrintLn( "ZM >> BusHatch Buildable CallBack onBeginUse()" );	#/

}

onCantUse_BusHatch( player )
{
	// CallBack When Player Doesn't Have Buildable Piece And Tries To Use Target
	//--------------------------------------------------------------------------
/#	PrintLn( "ZM >> BusHatch Buildable CallBack onCantUse()" );		#/

}

onDrop_BusHatch( player )
{
	// CallBack When Player Drops Buildable Piece
	//-------------------------------------------
/#	PrintLn( "ZM >> BusHatch Buildable CallBack onDrop()" );		#/

	self dropOnBus( player );
}

onEndUse_BusHatch( team, player, result )
{
	// CallBack When Player Stops Using Buildable Piece On Target
	//-----------------------------------------------------------
/#	PrintLn( "ZM >> BusHatch Buildable CallBack onEndUse()" );		#/

}

onPickup_BusHatch( player )
{
	// CallBack When Player Picks Up Buildable Piece
	//----------------------------------------------
/#	PrintLn( "ZM >> BusHatch Buildable CallBack onPickUp()" );		#/

	self pickupFromBus();
}

onUsePlantObject_BusHatch( player )
{
	// CallBack When Player Successfully Builds On Target
	//---------------------------------------------------
/#	PrintLn( "ZM >> BusHatch Buildable CallBack onUsePlantObject()" );	#/

}

//*****************************************************************************
// Utility
//*****************************************************************************

dropOnBus( player )
{
	if ( IsDefined( player ) && is_true( player.isOnBus ) )
	{
		self.trigger LinkTo( level.the_bus );
		self.visuals[ 0 ] LinkTo( level.the_bus );

		self.linked_to_bus = true;
	}
}

pickupFromBus()
{
	if ( is_true( self.linked_to_bus ) )
	{
		self.trigger UnLink();
		self.visuals[ 0 ] UnLink();

		self.linked_to_bus = undefined;
	}
}