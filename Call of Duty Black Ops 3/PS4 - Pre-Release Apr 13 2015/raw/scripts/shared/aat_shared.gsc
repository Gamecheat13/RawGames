// AAT stands for Alternative Ammunition Types

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace aat;




function autoexec __init__sytem__() {     system::register("aat",&__init__,undefined,undefined);    }	

function private __init__()
{
	if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
	{
		return;
	}

	level.aat = [];
	level.aat_reroll = [];

	callback::on_connect( &on_player_connect );

	spawners = GetSpawnerArray();
	foreach ( spawner in spawners )
	{
		spawner spawner::add_spawn_function( &aat_damage_monitor );
		spawner spawner::add_spawn_function( &aat_death_monitor );
	}

	level thread setup_devgui();
}


function private on_player_connect()
{
	self.aat = [];

	self.aat_cooldown_start = [];

	keys = GetArrayKeys( level.aat );
	foreach ( key in keys )
	{
		self.aat_cooldown_start[key] = 0;
	}

/#
	self thread aat_debug_text_display_init();
#/
}


function private setup_devgui()
{
/#
	waittillframeend;

	SetDvar( "aat_acquire_devgui", "" );

	aat_devgui_base = "devgui_cmd \"Player/AAT/";
	keys = GetArrayKeys( level.aat );
	foreach ( key in keys )
	{
		AddDebugCommand( aat_devgui_base + key + "\" \"set " + "aat_acquire_devgui" + " " + key + "\" \n");
	}

	AddDebugCommand( aat_devgui_base + "Clear Current\" \"set " + "aat_acquire_devgui" + " " + "none" + "\" \n");

	level thread aat_devgui_think();
#/
}


/#
function private aat_devgui_think()
{
	for ( ;; )
	{
		aat_name = GetDvarString( "aat_acquire_devgui" );

		if ( aat_name != "" )
		{
			players = GetPlayers();
			for ( i = 0; i < players.size; i++ )
			{
				if ( aat_name == "none" )
				{
					players[i] thread remove( players[i] GetCurrentWeapon() );
				}
				else
				{
					players[i] thread acquire( players[i] GetCurrentWeapon(), aat_name );
				}

				players[i] thread aat_set_debug_text( aat_name, false, false, false );
			}
		}
	
		SetDvar( "aat_acquire_devgui", "" );
		
		wait( 0.5 );
	}
}
#/


function private aat_debug_text_display_init()
{
/#
	self.aat_debug_text = NewClientHudElem( self );
	self.aat_debug_text.elemType = "font";
	self.aat_debug_text.font = "objective";
	self.aat_debug_text.fontscale = 1.8;
	self.aat_debug_text.horzAlign = "left";
	self.aat_debug_text.vertAlign = "top";
	self.aat_debug_text.alignX = "left";
	self.aat_debug_text.alignY = "top";
	self.aat_debug_text.x = 15;
	self.aat_debug_text.y = 15;
	self.aat_debug_text.sort = 2;

	self.aat_debug_text.color = ( 1, 1, 1 );
	self.aat_debug_text.alpha = 1;

	self.aat_debug_text.hidewheninmenu = true;

	self thread aat_debug_text_display_monitor();
#/
}


function private aat_debug_text_display_monitor()
{
/#
	self endon( "disconnect" );

	while ( true )
	{
		self waittill( "weapon_change", weapon );

		name = "none";
		if ( IsDefined( self.aat[weapon] ) )
		{
			name = self.aat[weapon];
		}

		self thread aat_set_debug_text( name, false, false, false );
	}
#/
}


function private aat_set_debug_text( name, success, success_reroll, fail )
{
/#
	self notify( "aat_set_debug_text_thread" );
	self endon( "aat_set_debug_text_thread" );
	self endon( "disconnect" );

	percentage = "N/A";
	if ( IsDefined( level.aat[name] ) )
	{
		percentage = level.aat[name].percentage;
	}

	self.aat_debug_text fadeOverTime( 0.05 );
	self.aat_debug_text.alpha = 1;
	self.aat_debug_text SetText( "AAT: " + name + " PCT: " + percentage );

	if ( success )
	{
		self.aat_debug_text.color = ( 0, 1, 0 );
	}
	else if ( success_reroll )
	{
		self.aat_debug_text.color = ( 0.8, 0, 0.8 );
	}
	else if ( fail )
	{
		self.aat_debug_text.color = ( 1, 0, 0 );
	}
	else
	{
		self.aat_debug_text.color = ( 1, 1, 1 );
	}

	wait( 1 );

	self.aat_debug_text fadeOverTime( 1 );
	self.aat_debug_text.color = ( 1, 1, 1 );

	if ( "none" == name )
	{
		self.aat_debug_text.alpha = 0;
	}
#/
}


function private aat_damage_monitor()
{
	self.aat_cooldown_start = [];

	keys = GetArrayKeys( level.aat );
	foreach ( key in keys )
	{
		self.aat_cooldown_start[key] = 0;
	}

	self endon ("death");
	
	for ( ;; )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, mod, modelName, tagName, partName, weapon, iDFlags );

		if ( !isDefined( amount ) )
		{
			continue;
		}

		self thread aat_response( false, attacker, mod, weapon );
	}
}


function private aat_death_monitor()
{
	self waittill( "death", attacker, mod, weapon );

	self thread aat_response( true, attacker, mod, weapon );
}


function private aat_response( death, attacker, mod, weapon )
{
	if ( !IsPlayer( attacker ) )
	{
		return;
	}

	if ( mod != "MOD_PISTOL_BULLET" && mod != "MOD_RIFLE_BULLET" && mod != "MOD_GRENADE" && mod != "MOD_PROJECTILE" && mod != "MOD_EXPLOSIVE" && mod != "MOD_IMPACT" )
	{
		return;
	}

	name = attacker.aat[weapon];
	if ( !IsDefined( name ) )
	{
		return;
	}

	if ( death && !level.aat[name].occurs_on_death )
	{
		return;
	}

	now = GetTime();
	if ( now <= self.aat_cooldown_start[name] + level.aat[name].cooldown_time_entity )
	{
		return;
	}

	if ( now <= attacker.aat_cooldown_start[name] + level.aat[name].cooldown_time_global )
	{
		return;
	}

	success = false;
	reroll_icon = undefined;
	percentage = level.aat[name].percentage;

	if ( percentage >= RandomFloat( 1 ) )
	{
		success = true;

		attacker thread aat_set_debug_text( name, true, false, false );
	}

	if ( !success )
	{
		keys = GetArrayKeys( level.aat_reroll );
		keys = array::randomize( keys );// randomize the keys so players don't assume one reroll is better than another just because of registration order
		foreach ( key in keys )
		{
			if ( attacker [[level.aat_reroll[key].active_func]]() )
			{
				for ( i = 0; i < level.aat_reroll[key].count; i++ )
				{
					if ( percentage >= RandomFloat( 1 ) )
					{
						success = true;
						reroll_icon = level.aat_reroll[key].damage_feedback_icon;

						attacker thread aat_set_debug_text( name, false, true, false );

						break;
					}
				}
			}

			if ( success )
			{
				break;
			}
		}
	}

	if ( !success )
	{
		attacker thread aat_set_debug_text( name, false, false, true );

		return;
	}

	attacker.aat_cooldown_start[name] = now;

	self thread [[level.aat[name].result_func]]( death, attacker, mod, weapon );
	attacker thread damagefeedback::update_override( level.aat[name].damage_feedback_icon, level.aat[name].damage_feedback_sound, reroll_icon );
}


/@
"Name: register( <name>, <percentage>, <cooldown_time_entity>, <cooldown_time_global>, <occurs_on_death>, <result_func>, <damage_feedback_icon>, <damage_feedback_sound> )"
"Summary: Register an AAT
"Module: AAT"
"MandatoryArg: <name> Unique name to identify the AAT.
"MandatoryArg: <percentage> Float value representing the percentage chance that the result occurs.
"MandatoryArg: <cooldown_time_entity> Cooldown time per entity where we don't check for the same result from the same player/AAT combo. To prevent particularly intense AATs from spamming. 0 is a valid value
"MandatoryArg: <cooldown_time_global> Cooldown time across all entities where we don't check for the same result from the same player/AAT combo. To prevent particularly intense AATs from spamming. 0 is a valid value
"MandatoryArg: <occurs_on_death> Bool representing whether the AAT can occur on death
"MandatoryArg: <result_func> Function pointer to run in response to the result occurring. This is responsible for 3rd person FX, sounds, and other results.
"MandatoryArg: <damage_feedback_icon> Name of the icon to use for damage_feedback.
"MandatoryArg: <damage_feedback_sound> Name of the sound to use for damage_feedback.
"Example: level aat::register( "dead_paint", 0.2, 0.5, true, &_zm_aat_dead_paint::result, "t7_hud_zm_aat_dead_paint", "wpn_aat_dead_paint_plr" );"
"SPMP: both"
@/
function register( name, percentage, cooldown_time_entity, cooldown_time_global, occurs_on_death, result_func, damage_feedback_icon, damage_feedback_sound )
{
	assert( IsDefined( name ), "aat::register(): name must be defined" );
	assert( "none" != name, "aat::register(): name cannot be '" + "none" + "', that name is reserved as an internal sentinel value" );
	assert( !IsDefined( level.aat[name] ), "aat::register(): AAT '" + name + "' has already been registered" );

	assert( IsDefined( percentage ), "aat::register(): AAT '" + name + "': percentage must be defined" );
	assert( 0 <= percentage && 1 > percentage, "aat::register(): AAT '" + name + "': percentage must be a value greater than or equal to 0 and less than 1" );

	assert( IsDefined( cooldown_time_entity ), "aat::register(): AAT '" + name + "': cooldown_time_entity must be defined" );
	assert( 0 <= cooldown_time_entity, "aat::register(): AAT '" + name + "': cooldown_time_entity must be a value greater than or equal to 0" );

	assert( IsDefined( cooldown_time_global ), "aat::register(): AAT '" + name + "': cooldown_time_global must be defined" );
	assert( 0 <= cooldown_time_global, "aat::register(): AAT '" + name + "': cooldown_time_global must be a value greater than or equal to 0" );

	assert( IsDefined( occurs_on_death ), "aat::register(): AAT '" + name + "': occurs_on_death must be defined" );

	assert( IsDefined( result_func ), "aat::register(): AAT '" + name + "': result_func must be defined" );

	assert( IsDefined( damage_feedback_icon ), "aat::register(): AAT '" + name + "': damage_feedback_icon must be defined" );
	assert( IsString( damage_feedback_icon ), "aat::register(): AAT '" + name + "': damage_feedback_icon must be a string" );

	assert( IsDefined( damage_feedback_sound ), "aat::register(): AAT '" + name + "': damage_feedback_sound must be defined" );
	assert( IsString( damage_feedback_sound ), "aat::register(): AAT '" + name + "': damage_feedback_sound must be a string" );

	level.aat[name] = SpawnStruct();

	level.aat[name].name = name;
	level.aat[name].percentage = percentage;
	level.aat[name].cooldown_time_entity = cooldown_time_entity;
	level.aat[name].cooldown_time_global = cooldown_time_global;
	level.aat[name].occurs_on_death = occurs_on_death;
	level.aat[name].result_func = result_func;
	level.aat[name].damage_feedback_icon = damage_feedback_icon;
	level.aat[name].damage_feedback_sound = damage_feedback_sound;
}


/@
"Name: register_reroll( <name>, <count>, <active_func>, <damage_feedback_icon> )"
"Summary: Register an AAT
"Module: AAT"
"MandatoryArg: <name> Unique name to identify the AAT.
"MandatoryArg: <count> Int value the number of rerolls.
"MandatoryArg: <active_func> Function pointer to run to test if the player has the reroll currently active.
"MandatoryArg: <damage_feedback_icon> Name of the icon to use for damage_feedback in addition to the AAT's icon, this signifies the AAT occurred thanks to this reroll.
"Example: level aat::register_reroll( "good_night_from_good_luck", 2, &_zm_bbg_good_night_from_good_luck::active, "t7_hud_bbg_good_night_from_good_luck" );"
"SPMP: both"
@/
function register_reroll( name, count, active_func, damage_feedback_icon )
{
	assert( IsDefined( name ), "aat::register_reroll (): name must be defined" );
	assert( "none" != name, "aat::register_reroll(): name cannot be '" + "none" + "', that name is reserved as an internal sentinel value" );
	assert( !IsDefined( level.aat[name] ), "aat::register_reroll(): AAT Reroll'" + name + "' has already been registered" );

	assert( IsDefined( count ), "aat::register_reroll(): AAT Reroll '" + name + "': count must be defined" );
	assert( 0 < count, "aat::register_reroll(): AAT Reroll '" + name + "': count must be greater than 0" );

	assert( IsDefined( active_func ), "aat::register_reroll(): AAT Reroll '" + name + "': active_func must be defined" );

	assert( IsDefined( damage_feedback_icon ), "aat::register_reroll(): AAT Reroll '" + name + "': damage_feedback_icon must be defined" );
	assert( IsString( damage_feedback_icon ), "aat::register_reroll(): AAT Reroll '" + name + "': damage_feedback_icon must be a string" );

	level.aat_reroll[name] = SpawnStruct();

	level.aat_reroll[name].name = name;
	level.aat_reroll[name].count = count;
	level.aat_reroll[name].active_func = active_func;
	level.aat_reroll[name].damage_feedback_icon = damage_feedback_icon;
}


/@
"Name: acquire( <weapon>, <name> )"
"Summary: The player acquires the specified AAT on the specified weapon. If a specific AAT is not supplied, a random AAT is selected by the system, unless one alredy exists for that weapon, in which case no action is taken
"Module: AAT"
"MandatoryArg: <weapon> Weapon object to receive the AAT.
"OptionalArg: <name> Unique name to identify the AAT to receive, will be randomly selected if undefined.
"Example: self aat::acquire( ar_standard_upgraded_object );"
"SPMP: both"
@/
function acquire( weapon, name )
{
	if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
	{
		return;
	}

	assert( IsDefined( weapon ), "aat::acquire(): weapon must be defined" );
	assert( weapon != level.weaponNone, "aat::acquire(): weapon must not be level.weaponNone" );

	if ( IsDefined( name ) )
	{
		assert( "none" != name, "aat::acquire(): name cannot be '" + "none" + "', that name is reserved as an internal sentinel value" );
		assert( IsDefined( level.aat[name] ), "aat::acquire(): AAT '" + name + "' was never registered" );

		self.aat[weapon] = name;
	}
	else
	{
		if ( IsDefined( self.aat[weapon] ) )
		{
			return;
		}

		keys = GetArrayKeys( level.aat );
		rand = RandomInt( keys.size );
		self.aat[weapon] = keys[rand];
	}
}


/@
"Name: remove( <weapon> )"
"Summary: Removes the AAT from the specified weapon for the player
"Module: AAT"
"MandatoryArg: <weapon> Weapon object to remove the AAT from.
"Example: self aat::remove( ar_standard_upgraded_object );"
"SPMP: both"
@/
function remove( weapon )
{
	if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
	{
		return;
	}

	assert( IsDefined( weapon ), "aat::remove(): weapon must be defined" );
	assert( weapon != level.weaponNone, "aat::remove(): weapon must not be level.weaponNone" );

	self.aat[weapon] = undefined;
}

