#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

init()
{
	if ( !maps\mp\zombies\_zm_equipment::is_equipment_included( "equip_turbine_zm" ) )
	{
		return;
	}

	level.turbine_name = "equip_turbine_zm";

	maps\mp\zombies\_zm_equipment::register_equipment( "equip_turbine_zm", &"ZOMBIE_EQUIP_TURBINE_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_TURBINE_HOWTO", "turbine" );

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for( ;; )
	{
		level waittill( "connecting", player );

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );

		self thread watchTurbineUse();
	}
}

watchTurbineUse()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "grenade_fire", weapon, weapname );

		if ( weapname == level.turbine_name && !IsDefined( self.buildableTurbine ) )
		{
			self.buildableTurbine = weapon;

			self thread startTurbineDeploy( weapon );
		}
	}
}

startTurbineDeploy( weapon )
{
	self endon( "disconnect" );

	origin = weapon.origin;

	powerRadius = 128;

	if ( !IsDefined( self.turbine_round_start ) )
	{
		self.turbine_round_start = level.round_number;
		self.turbine_power_on = true;

		self thread turbineDecay();
		self thread turbinePowerDiminish( origin, powerRadius );
	}

	if ( IsDefined( weapon ) )
	{
		/#
		weapon thread debugTurbine( powerRadius );
		#/

		self thread turbineAudio();
		self thread turbinePowerThink( origin, powerRadius );
		
		self thread maps\mp\zombies\_zm_buildables::delete_on_disconnect( weapon );

		// Wait For Turbine To Be Removed
		//-------------------------------
		weapon waittill( "death" );

		self thread turbinePowerOff( origin, powerRadius );
	}
}

turbinePowerThink( origin, powerRadius )
{
	self endon( "disconnect" );
	self.buildableTurbine endon( "death" );

	if ( is_true( self.turbine_power_on ) )
	{
		self thread turbinePowerOn( origin, powerRadius );
	}

	while ( IsDefined( self.buildableTurbine ) )
	{
		self waittill( "turbine_power_change" );

		if ( is_true( self.turbine_power_on ) )
		{
			self thread turbinePowerOn( origin, powerRadius );
		}
		else
		{
			self thread turbinePowerOff( origin, powerRadius );
		}
	}
}

turbinePowerOn( origin, powerRadius )
{
	if ( !IsDefined( self.buildableTurbine ) )
	{
		return;
	}

	if ( !flag( "power_on" ) )
	{
		// Perk Machines
		//--------------
		vending_triggers = GetEntArray( "zombie_vending", "targetname" );
		foreach ( trigger in vending_triggers )
		{
			if ( DistanceSquared( trigger.origin, origin ) < ( powerRadius * powerRadius ) )
			{
				trigger.turbine_powered = true;
	
				level notify( trigger maps\mp\zombies\_zm_perks::getVendingMachineNotify() + "_on" );
	
				maps\mp\zombies\_zm_perks::perk_unpause(trigger.script_noteworthy);
			}
		}
	
		pack_a_punch = GetEntArray( "specialty_weapupgrade", "script_noteworthy" );
		foreach ( trigger in pack_a_punch )
		{
			if ( DistanceSquared( trigger.origin, origin ) < ( powerRadius * powerRadius ) )
			{
				trigger.turbine_powered = true;
				level notify( "Pack_A_Punch_on" );
			}
		}
	}

	// Electric Doors
	//---------------
	zombie_doors = GetEntArray( "zombie_door", "targetname" );
	foreach ( door in zombie_doors )
	{
		if ( IsDefined( door.script_noteworthy ) && door.script_noteworthy == "electric_door" )
		{
			if ( DistanceSquared( door.origin, origin ) < ( powerRadius * powerRadius ) )
			{
				door notify( "power_on" );
			}
		}
	}
}

turbinePowerOff( origin, powerRadius )
{
	if ( !flag( "power_on" ) )
	{	
		// Perk Machines
		//--------------
		vending_triggers = GetEntArray( "zombie_vending", "targetname" );
		foreach ( trigger in vending_triggers )
		{
			if ( DistanceSquared( trigger.origin, origin ) < ( powerRadius * powerRadius ) )
			{
				trigger notify( "death" );
				trigger thread maps\mp\zombies\_zm_perks::vending_trigger_think();
				
				if ( IsDefined( trigger.perk_hum ) )
				{
					trigger.perk_hum Delete();
				}
	
				level notify( trigger maps\mp\zombies\_zm_perks::getVendingMachineNotify() + "_off" );
			}
			maps\mp\zombies\_zm_perks::perk_pause(trigger.script_noteworthy);
	
		}
	
		if ( IsDefined( level.buildables_built ) && is_true( level.buildables_built[ "pap" ] ) )
		{
			pack_a_punch = GetEntArray( "specialty_weapupgrade", "script_noteworthy" );
			foreach ( trigger in pack_a_punch )
			{
				trigger.turbine_powered = false;
				if ( !flag( "power_on" ) )
				{
					// NOTE: This will cause problems if there is more than one pack-a-punch machine in the level
					level notify( "Pack_A_Punch_off" );
		
					trigger notify( "death" );
					trigger thread maps\mp\zombies\_zm_perks::vending_weapon_upgrade();
				}
			}
		}
	}
}

turbineAudio()
{
	if ( !IsDefined( self.buildableTurbine ) )
	{
		return;
	}
	
	switch ( self.turbine_power_level )
	{
		case 4: // Full Power
		case 3:
		{
			self.buildableTurbine StopLoopSound();
			self.buildableTurbine PlayLoopSound( "zmb_turbine_stage_one" );
		} break;
		case 2:
		{
			self.buildableTurbine StopLoopSound();
			self.buildableTurbine PlayLoopSound( "zmb_turbine_stage_two" );
		} break;
		case 1:
		{
			self.buildableTurbine StopLoopSound();
			self.buildableTurbine PlayLoopSound( "zmb_turbine_stage_three" );
		} break;
	}
}

turbineDecay()
{
	self endon( "disconnect" );

	roundLives = 4;
	roundToDie = self.turbine_round_start + roundLives;

	self.turbine_power_level = roundLives;

	while ( level.round_number < roundToDie )
	{
		self notify( "turbine_power_change" );

		self thread turbineAudio();

		level waittill( "between_round_over" );

		self.turbine_power_level--;
	}

	PlaySoundAtPosition( "zmb_turbine_explo", self.origin );

	self maps\mp\zombies\_zm_equipment::equipment_take();

	if ( IsDefined( self.buildableTurbine ) )
	{
		self.buildableTurbine Delete();
	}

	self.turbine_power_level = undefined;
	self.turbine_round_start = undefined;
	self.turbine_power_on = undefined;
}

turbinePowerDiminish( origin, powerRadius )
{
	self endon( "disconnect" );

	while ( true )
	{
		if ( IsDefined( self.turbine_power_level ) && IsDefined( self.buildableTurbine ) )
		{
			switch ( self.turbine_power_level )
			{
				case 4: // Full Power
				{
				} break;
				case 3:
				{
				} break;
				case 2:
				{
					self.turbine_power_on = true;

					wait ( RandomIntRange( 12, 20 ) );
					self turbinePowerOff( origin, powerRadius );

					self.turbine_power_on = false;

					wait ( RandomIntRange( 3, 8 ) );
					self turbinePowerOn( origin, powerRadius );
				} break;
				case 1:
				{
					self.turbine_power_on = true;

					wait ( RandomIntRange( 3, 7 ) );
					self turbinePowerOff( origin, powerRadius );

					self.turbine_power_on = false;

					wait ( RandomIntRange( 6, 12 ) );
					self turbinePowerOn( origin, powerRadius );
				} break;
			}
		}

		wait ( 0.05 );
	}
}

debugTurbine( radius )
{
	/#
	while ( IsDefined( self ) )
	{
		Circle( self.origin, radius, ( 1, 1, 1 ), false, true, 1 );

		wait ( 0.05 );
	}
	#/
}
