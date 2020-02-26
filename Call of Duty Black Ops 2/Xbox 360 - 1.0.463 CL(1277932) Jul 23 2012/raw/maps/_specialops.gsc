#include common_scripts\utility;
#include maps\_utility;

main()
{
// this was deleting anything not marked script_specialops - now you have to delete yourself in your script.
//	delete_by_type( ::type_reg );

	//needs to be first for create fx
	//maps\mp\mp_cairo_fx::main();

	if( IsSplitScreen() )
	{
		const halfway_height  = 10000;
		const cull_dist		= 10000;
		set_splitscreen_fog( 350, 2986.33, halfway_height, -480, 0.805, 0.715, 0.61, 0.0, cull_dist );
	}

	// load map defaults
	maps\_load::main();

	SetDvar( "ui_specops", 1 );

	level.is_specops_level = true;
}

for_each( array, functor, unary_predicate, predicate_argument )
{
	if( isdefined( functor ) )
	{
		for( i = 0; i < array.size; i++ )
		{
			if( isdefined( array[i] ) )
			{
				if( !isdefined( unary_predicate ) || 
					( isdefined( unary_predicate ) && 
					(	(isdefined(predicate_argument) && array[i] [[ unary_predicate ]](predicate_argument)) || 
						(!isdefined(predicate_argument) && array[i] [[ unary_predicate ]]()) )) )
				{
					array[i] [[ functor ]]();
				}
			}
		}
	}
}

type_so()
{
	if( isdefined( self ) && 
		isdefined( self.classname ) && 
		isdefined( self.script_specialops ) && 
		( self.script_specialops == 1 ) )
		return true;
	else 
		return false;
}

type_reg()
{
	return !self type_so();
}

type_spawners()
{
	return isdefined( self.classname ) && isSubStr( self.classname, "actor_" );	
}

type_so_spawners()
{
	return self type_so() && self type_spawners();	
}

type_reg_spawners()
{
	return self type_reg() && self type_spawners();	
}

type_vehicle()
{
	return isdefined( self.classname ) && isSubStr( self.classname, "script_vehicle" );
}

type_so_vehicle()
{
	return self type_so() && self type_vehicle();	
}

type_reg_vehicle()
{
	return self type_reg() && self type_vehicle();	
}

type_spawn_trigger()
{
	if ( !isdefined( self.classname ) )
		return false;

	if ( self.classname == "trigger_multiple_spawn" ) 
		return true;

	if ( self.classname == "trigger_multiple_spawn_reinforcement" )
		return true;

	if ( self.classname == "trigger_multiple_friendly_respawn" )
		return true;

	if ( isdefined( self.targetname ) && self.targetname == "flood_spawner" )
		return true;

	if ( isdefined( self.targetname ) && self.targetname == "friendly_respawn_trigger" )
		return true;

	if ( isdefined( self.spawnflags ) && self.spawnflags & 32 )
		return true;

	return false;
}

type_so_spawn_trigger()
{
	return self type_so() && self type_so_spawn_trigger();	
}

type_reg_spawn_trigger()
{
	return self type_reg() && self type_so_spawn_trigger();	
}

type_trigger()
{
	array = [];
	array[ "trigger_multiple" ]	= 1;
	array[ "trigger_once" ]		= 1;
	array[ "trigger_use" ]		= 1;
	array[ "trigger_radius" ]	= 1;
	array[ "trigger_lookat" ]	= 1;
	array[ "trigger_disk" ]		= 1;
	array[ "trigger_damage" ]	= 1;
	
	return isdefined( self.classname ) && isdefined( array[ self.classname ] );
}

type_so_trigger()
{
	return self type_so() && self type_so_trigger();	
}

type_reg_trigger()
{
	return self type_reg() && self type_so_trigger();	
}

type_flag_trigger()
{
	array = [];
	array[ "trigger_multiple_flag_set" ]			= 1;
	array[ "trigger_multiple_flag_set_touching" ]	= 1;
	array[ "trigger_multiple_flag_clear" ]			= 1;
	array[ "trigger_multiple_flag_looking" ]		= 1;
	array[ "trigger_multiple_flag_lookat" ]			= 1;
	
	return isdefined( self.classname ) && isdefined( array[ self.classname ] );
}

type_so_flag_trigger()
{
	return self type_so() && self type_flag_trigger();	
}

type_reg_flag_trigger()
{
	return self type_reg() && self type_flag_trigger();	
}

type_killspawner_trigger()
{
	return ( self type_trigger() && isdefined( self.script_killspawner ) );
}

type_so_killspawner_trigger()
{
	return self type_so() && self type_killspawner_trigger();	
}

type_reg_killspawner_trigger()
{
	return self type_reg() && self type_killspawner_trigger();	
}

type_goalvolume()
{
	return ( isdefined( self.classname ) && ( self.classname == "info_volume" ) && isdefined( self.script_goalvolume ) );
}

type_so_goalvolume()
{
	return self type_so() && self type_goalvolume();
}

type_reg_goalvolume()
{
	return self type_reg() && self type_goalvolume();
}

delete_ent()
{
	self delete();
}

delete_by_type( type_predicate )
{
	for_each( getentarray(), ::delete_ent, type_predicate );
}

noteworthy_check( value )
{
	if( IsDefined( self ) && 
			IsDefined( self.classname ) &&
			self.classname == "script_origin" )
		return false;
	else if( isdefined( self ) && 
		isdefined( self.script_noteworthy ) && 
		( self.script_noteworthy != value ) )
		return true;
	else if( IsDefined( self ) && IsDefined( self.script_gameobjectname ) )
		return true;
	else 
		return false;
}

// delete stuff that's not pertaining to this particular SO level
delete_by_noteworthy( level_name )
{
	for_each( getentarray(), ::delete_ent, ::noteworthy_check, level_name );
}