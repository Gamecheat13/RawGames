#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

init()
{
	if( !emp_bomb_exists() )
	{
		return;
	}

	// zombie stun
	set_zombie_var( "emp_stun_range",			12*50 ); 
	set_zombie_var( "emp_stun_time",			20 ); 
	// perk break
	set_zombie_var( "emp_perk_off_range",		12*75 ); 
	set_zombie_var( "emp_perk_off_time",		90 ); 


/#
	level.zombiemode_devgui_emp_bomb_give = ::player_give_emp_bomb;
#/

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
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self thread watch_for_grenade_throw();
	}
}


player_give_emp_bomb()
{
	self giveweapon( "emp_grenade_zm" );
	self set_player_tactical_grenade( "emp_grenade_zm" );
	//self thread player_handle_emp_bomb();
}

emp_bomb_exists()
{
	return IsDefined( level.zombie_weapons["emp_grenade_zm"] );
}

watch_for_grenade_throw()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("grenade_fire", grenade, weapname);
		
		if ( weapname != "emp_grenade_zm" )
			continue;

		grenade waittill( "explode", grenade_origin );

		self thread emp_detonate( grenade_origin );
	}
}


emp_detonate( grenade_origin )
{
	// Level specific EMP 
	if (isdefined(level.custom_emp_detonate))
		thread [[level.custom_emp_detonate]](grenade_origin);


	// check for zombies
	self thread emp_detonate_zombies(grenade_origin);

	// check for perk machines
	self thread emp_detonate_perks(grenade_origin);
}



emp_detonate_zombies(grenade_origin)
{
	zombies = get_array_of_closest( grenade_origin, GetAiSpeciesArray( "axis", "all" ), undefined, undefined, level.zombie_vars["emp_stun_range"] );
	if ( !isDefined( zombies ) )
	{
		return;
	}

	for (i=0; i<zombies.size; i++)
	{
		zombies[i] thread stun_zombie();		
		wait 0.05;
	}
}


stun_zombie()
{
	self endon("death");

	self notify( "stun_zombie" );
	self endon( "stun_zombie" );

	if ( is_true( self.ignore_inert ) )
	{
		return;
	}

	if ( isdefined( self.stun_zombie ) )
	{
		self thread [[ self.stun_zombie ]]();
		return;
	}

	self thread maps\mp\zombies\_zm_ai_basic::start_inert();
	//stun_time = level.zombie_vars["emp_stun_time"];
	//self thread maps\mp\zombies\_zm_ai_basic::stop_inert();
}

emp_detonate_perks(grenade_origin)
{

	origin = ( 0, 0, 0 );

	emp_radius = level.zombie_vars["emp_perk_off_range"];
	emp_time = level.zombie_vars["emp_perk_off_time"];

	vending_triggers_deactivated = [];
	pack_a_punch_triggers_deactivated = [];

	origin = grenade_origin;

	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	foreach ( trigger in vending_triggers )
	{
		if ( DistanceSquared( trigger.origin, origin ) < ( emp_radius * emp_radius ) )
		{
			if ( flag( "power_on" ) || is_true(trigger.turbine_powered) )
			{
				trigger.emp_disabled = true;

				vending_triggers_deactivated[ vending_triggers_deactivated.size ] = trigger;
				
				trigger notify( "death" );
				trigger thread maps\mp\zombies\_zm_perks::vending_trigger_think();

				maps\mp\zombies\_zm_perks::perk_pause(trigger.script_noteworthy);

				level notify( trigger maps\mp\zombies\_zm_perks::getVendingMachineNotify() + "_off" );
			}
		}
	}

	pack_a_punch = GetEntArray( "specialty_weapupgrade", "script_noteworthy" );
	foreach ( trigger in pack_a_punch )
	{
		if ( DistanceSquared( trigger.origin, origin ) < ( emp_radius * emp_radius ) )
		{
			trigger.emp_disabled = true;
			pack_a_punch_triggers_deactivated[ pack_a_punch_triggers_deactivated.size ] = trigger;

// NOTE: This will cause problems if there is more than one pack-a-punch machine in the level
			level notify( "Pack_A_Punch_off" );

			trigger notify( "death" );

			trigger thread maps\mp\zombies\_zm_perks::vending_weapon_upgrade();

		}
	}



	wait emp_time;

	{
		foreach ( trigger in vending_triggers_deactivated )
		{
			trigger.emp_disabled = false;
			if ( flag( "power_on" ) || is_true(trigger.turbine_powered) )
				level notify( trigger maps\mp\zombies\_zm_perks::getVendingMachineNotify() + "_on" );
			maps\mp\zombies\_zm_perks::perk_unpause(trigger.script_noteworthy);
		}
		foreach ( trigger in pack_a_punch_triggers_deactivated )
		{
			trigger.emp_disabled = false;
			if ( flag( "power_on" ) || is_true(trigger.turbine_powered) )
				level notify( "Pack_A_Punch_on" );
		}
	}

}

