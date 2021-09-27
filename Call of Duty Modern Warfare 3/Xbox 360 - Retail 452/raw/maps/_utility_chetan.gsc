#include maps\_hud_util;
#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;

// *************************************
// OVERRIDE FUNCTIONS
// *************************************

override_array_call( ents, process, args )
{
	Assert( IsDefined( ents ) );
	Assert( IsDefined( process ) );
	
	if ( !IsDefined( args ) )
	{
		foreach ( ent in ents )
			if ( IsArray( ent ) )
				override_array_call( ent, process );
			else
				ent call [[ process ]]();
		return;
	}
	
	Assert( IsArray( args ) );
				
	switch( args.size )
	{
		case 0:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				override_array_call( ent, process, args );
			else
				ent call [[ process ]]();
			break;
		case 1:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				override_array_call( ent, process, args );
			else
				ent call [[ process ]]( args[ 0 ] );
			break;
		case 2:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				override_array_call( ent, process, args );
			else
				ent call [[ process ]]( args[ 0 ], args[ 1 ] );
			break;
		case 3:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				override_array_call( ent, process, args );
			else
				ent call [[ process ]]( args[ 0 ], args[ 1 ], args[ 2 ] );
			break;
		case 4:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				override_array_call( ent, process, args );
			else
				ent call [[ process ]]( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ] );
			break;
		case 5:
			foreach ( ent in ents )
			if ( IsArray( ent ) )
				override_array_call( ent, process, args );
			else
				ent call [[ process ]]( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ], args[ 4 ] );
			break;
	}
	return;
}

override_is_in_array( array, item )
{
	Assert( IsDefined( array ) && IsArray( array ) );
		
	foreach ( _item in array )
		if ( compare( item, _item ) )
			return true;
	return false;
}

override_array_delete( array, msgs, delay )
{
	Assert( IsDefined( array ) && IsArray( array ) );
	
	if ( !IsDefined( msgs ) )
		msgs = [ "death" ];
	Assert( IsArray( msgs ) );
	
	delay 	= gt_op( delay, 0 );
	
	foreach( item in array )
	{
		if ( IsDefined( item ) )
		{
			if ( IsArray( item ) )
			{
				if ( delay > 0 )
				{
					override_array_delete( item, msgs, delay );
					wait 0.05;
				}
				else
					thread override_array_delete( item, msgs, 0 );
			}
			else
			{
				foreach ( msg in msgs )
					item notify( msg );
					
				if ( delay > 0 )
				{
					wait 0.05;
					if ( IsDefined( item ) )
						item Delete();
				}
				else
					item Delete();
			}
		}
	}
}

override_delayThread( timer, func, args )
{
	Assert( IsDefined( func ) );

	if ( IsDefined( args ) )
		Assert( IsArray( args ) );
		
	thread override_delayThread_internal( timer, func, args );
}

override_delayThread_internal( timer, func, args )
{
	self endon( "death" );
	
	wait timer;

	if ( !IsDefined( args ) )
		thread [[ func ]]();
	else
		switch( args.size )
		{
			case 0:
				thread [[ func ]]();
				break;
			case 1:
				thread [[ func ]]( args[ 0 ] );
				break;
			case 2:
				thread [[ func ]]( args[ 0 ], args[ 1 ] );
				break;
			case 3:
				thread [[ func ]]( args[ 0 ], args[ 1 ], args[ 2 ] );
				break;
			case 4:
				thread [[ func ]]( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ] );
				break;
			case 5:
				thread [[ func ]]( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ], args[ 4 ] );
				break;
			case 6:
				thread [[ func ]]( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ], args[ 4 ], args[ 5 ] );
				break;
			case 7:
				thread [[ func ]]( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ], args[ 4 ], args[ 5 ], args[ 6 ] );
				break;
		}
}

override_waittill_any( msgs )
{
	Assert( IsDefined( msgs ) && IsArray( msgs ) );
	
	msgs = array_removeundefined( msgs );
	
	Assert( IsDefined( msgs[ 0 ] ) );
	
	struct 			= SpawnStruct();
	struct.notified = [];
	
	foreach ( i, msg in msgs )
	{
		struct.notified[ i ] = 0;
		self thread override_waittill_any_internal( struct, i, msg );
	}
		
	for ( ; ; wait 0.05 )
		foreach ( notified in struct.notified )
			if ( notified )
				return;
}

override_waittill_any_internal( struct, index, msg )
{
	self waittill_any( msg, "death" );
	struct.notified[ index ] = 1;
}

override_flag_wait_all( flags )
{
	Assert( IsDefined( flags ) && IsArray( flags ) );
	flags = array_removeundefined( flags );
	foreach ( flag in flags )
		Assert( flag_exist( flag ) );
	
	set = 0;
	
	for ( ; !set ; wait 0.05 )
	{
		set = 1;
		
		foreach ( flag in flags )
		{
			if ( !flag( flag ) )
			{
				set *= 0;
				break;
			}			
		}
		
		if ( set )
			return;
	}
}

override_ent_flag_wait_all( flags )
{
	Assert( IsDefined( flags ) && IsArray( flags ) );
	flags = array_removeundefined( flags );
	foreach ( flag in flags )
		Assert( ent_flag_exist( flag ) );
	
	self endon( "death" );
	
	set = 0;
	
	for ( ; !set && IsDefined( self ); wait 0.05 )
	{
		set = 1;
		
		foreach ( flag in flags )
		{
			if ( !ent_flag( flag ) )
			{
				set *= 0;
				break;
			}			
		}
		
		if ( set || !IsDefined( self ) )
			return;
	}
}

override_flag_wait_any( flags )
{
	Assert( IsDefined( flags ) && IsArray( flags ) );
	flags = array_removeundefined( flags );
	foreach ( flag in flags )
		Assert( flag_exist( flag ) );
	
	set = false;
	
	for ( ; !set ; wait 0.05 )
	{
		foreach ( flag in flags )
		{
			if ( flag( flag ) )
			{
				set = true;
				return;
			}			
		}
	}
}

override_ent_flag_wait_any( flags )
{
	Assert( IsDefined( flags ) && IsArray( flags ) );
	flags = array_removeundefined( flags );
	foreach ( flag in flags )
		Assert( flag_exist( flag ) );
	
	self endon( "death" );
	
	set = false;
	
	for ( ; !set && IsDefined( self ); wait 0.05 )
	{
		foreach ( flag in flags )
		{
			if ( ent_flag( flag ) )
			{
				set = true;
				return;
			}			
		}
	}
}

// *************************************
// GENERIC FUNCTIONS
// *************************************

// flag_and_all
// flag_or_all

// TODO: the ease in, out should go along an arc of a circle, rather than lerp direcly to the player's eyes
// the arc seems to be a more natural type of head tracking
lookat_player( ease_in_speed, ease_out_speed, lookat_time )
{
	ease_in_speed 	= gt_op( ease_in_speed, 0.05 ); 	// units per sec
	ease_out_speed	= gt_op( ease_out_speed, 0.05 ); 	// units per sec
	lookat_time		= gt_op( lookat_time, 0 );
	
	angles		= ( 0, self GetTagAngles( "j_head" )[ 1 ], 0 ); // Ideally this should be the original angles the head is facing. TODO: fix
	origin 		= self GetTagOrigin( "j_head" ) + 32 * AnglesToForward( angles );
	tag 		= Spawn( "script_model", origin );
	tag.angles 	= angles;
	tag SetModel( "tag_origin" );
	tag LinkTo( self, "j_head" );
	
	self SetLookAtEntity( tag );
	wait 0.05;
	tag UnLink();
	
	// Ease In
	
	dist = Distance( tag.origin, level.player GetEye() );
	time = dist / ease_in_speed;
	
	for ( ; IsDefined( self ) && time > 0; time = dec_op( time, 0.05, 0.05, 0 ) )
	{
		delta_dist  = level.player GetEye() - tag.origin;
		delta_dist /= time * 20;
		
		tag MoveTo( tag.origin + delta_dist, 0.05 );
		wait 0.05;
	}
	
	if ( !IsDefined( self ) )
		return;
	self SetLookAtEntity( level.player );
	
	wait lookat_time;
	
	// East Out
	
	tag.origin	= level.player GetEye();
	angles		= ( 0, self GetTagOrigin( "j_spine4" )[ 1 ], 0 );
	origin 		= self GetTagOrigin( "j_head" ) + 32 * AnglesToForward( angles );
	dist 		= Distance( tag.origin, origin );
	time 		= dist / ease_out_speed;
	
	for ( ; IsDefined( self ) && time > 0; time = dec_op( time, 0.05, 0.05, 0 ) )
	{
		angles		= ( 0, self GetTagOrigin( "j_spine4" )[ 1 ], 0 );
		origin 		= self GetTagOrigin( "j_head" ) + 32 * AnglesToForward( angles );
		delta_dist 	= origin - tag.origin;
		delta_dist /= time * 20;
		
		tag MoveTo( tag.origin + delta_dist, 0.05 );
		wait 0.05;
	}
	
	if( IsDefined( self ) )
		self SetLookAtEntity();
	tag Delete();
}

flag_remove( flag )
{
	Assert( IsDefined( flag ) );
	
	if ( IsDefined( level.flag ) && IsDefined( level.flag[ flag ] ) )
		level.flag[ flag ] = undefined;
}

ent_flag_remove( flag )
{
	Assert( IsDefined( flag ) );
	
	if ( IsDefined( self.ent_flag ) && IsDefined( self.ent_flag_lock ) &&
		 IsDefined( self.ent_flag[ flag ] ) && IsDefined( self.ent_flag_lock[ flag ] ) )
	{
		self.ent_flag[ flag ] 		= undefined;
		self.ent_flag_lock[ flag ] 	= undefined;
	}
}

set_target_radius_over_time( target, start_radius, end_radius, time )
{
	Assert( IsDefined( target ) );
	
	start_radius 	= gt_op( start_radius, 0.05 );
	end_radius		= gt_op( end_radius, 0.05 );
	time			= gt_op( time, 0.05 );
	
	delta_radius 	= ( end_radius - start_radius ) / ( time * 20 );
	radius			= start_radius;
	
	for ( elapsed = 0; IsDefined( target ) && Target_IsTarget( target ) && elapsed < time; elapsed += 0.05 )
	{
		radius = gt_op( radius + delta_radius, 0 );
		Target_DrawSquare( target, radius );
		wait 0.05;
	}
}

set_saved_dvar_over_time( dvar, value, time )
{
	Assert( IsDefined( dvar ) && IsString( dvar ) );
	Assert( IsDefined( value ) );
	
	time = gt_op( time, 0 );
	
	if ( time == 0 )
		SetSavedDvar( dvar, value );
	
	_value = GetDvarFloat( dvar );
	delta  = ( value - _value ) / ( time * 20 );
		
	for ( ; abs( value - _value ) > abs( delta ) ; _value += delta )
	{
		SetSavedDvar( dvar, _value );
		wait 0.05;
	}
	SetSavedDvar( dvar, value );
} 

flag_wait_any_set_flags( flag_waits, flags )
{
	Assert( IsDefined( flag_waits ) && IsArray( flag_waits ) );
	Assert( IsDefined( flags ) && IsArray( flags ) );
	
	flag_waits 	= array_removeundefined( flag_waits );
	foreach ( flag_wait in flag_waits )
		Assert( flag_exist( flag_wait ) );
	flags = array_removeundefined( flags );
	foreach ( flag in flags )
		Assert( flag_exist( flag ) );
	
	override_flag_wait_any( flag_waits );
	
	foreach ( flag in flags )
		flag_set( flag );
}

ent_flag_wait_any_set_flags( flag_waits, flags )
{
	Assert( IsDefined( flag_waits ) && IsArray( flag_waits ) );
	Assert( IsDefined( flags ) && IsArray( flags ) );
	
	flag_waits 	= array_removeundefined( flag_waits );
	foreach ( flag_wait in flag_waits )
		Assert( ent_flag_exist( flag_wait ) );
	flags = array_removeundefined( flags );
	foreach ( flag in flags )
		Assert( ent_flag_exist( flag ) );
	
	override_ent_flag_wait_any( flag_waits );
	
	foreach ( flag in flags )
		ent_flag_set( flag );
}

flag_wait_all_set_flags( flag_waits, flags )
{
	Assert( IsDefined( flag_waits ) && IsArray( flag_waits ) );
	Assert( IsDefined( flags ) && IsArray( flags ) );
	
	flag_waits 	= array_removeundefined( flag_waits );
	foreach ( flag_wait in flag_waits )
		Assert( flag_exist( flag_wait ) );
	flags = array_removeundefined( flags );
	foreach ( flag in flags )
		Assert( flag_exist( flag ) );
	
	override_flag_wait_all( flag_waits );
	
	foreach ( flag in flags )
		flag_set( flag );
}

ent_flag_wait_all_set_flags( flag_waits, flags )
{
	Assert( IsDefined( flag_waits ) && IsArray( flag_waits ) );
	Assert( IsDefined( flags ) && IsArray( flags ) );
	
	flag_waits 	= array_removeundefined( flag_waits );
	foreach ( flag_wait in flag_waits )
		Assert( ent_flag_exist( flag_wait ) );
	flags = array_removeundefined( flags );
	foreach ( flag in flags )
		Assert( ent_flag_exist( flag ) );
	
	override_ent_flag_wait_all( flag_waits );
	
	foreach ( flag in flags )
		ent_flag_set( flag );
}

do_random_dialogue_until_flags( ent, sounds, flags, interval )
{
	Assert( IsDefined( ent ) );
	Assert( IsDefined( sounds ) && IsArray( sounds ) );
	Assert( IsDefined( flags ) && IsArray( flags ) );
    
    array = [];
    
    for ( i = 0; i < sounds.size; i++ )
    	array[ array.size ] = i;
    	
    interval = gt_op( interval, 0.05 );
    
    flag = "FLAG_do_random_sound_until_flags_" + ent GetEntityNumber() + "_" + RandomInt( 1000 ) + "_" + GetTime();
    
    if ( !flag_exist( flag ) )
    	flag_init( flag );
    flag_clear( flag );
    
    thread flag_wait_all_set_flags( flags, [ flag ] );
    
	for ( index = 0; !flag( flag ) && IsDefined( ent ); wait interval )
	{
		if ( array.size == 0 )
		{
			for ( i = 0; i < sounds.size; i++ )
    			array[ array.size ] = i;
    		if ( array.size > 1 )
    			array = array_remove_index( array, index );
    	}
		
		index = RandomInt( array.size );
		
		ent thread dialogue_queue( sounds[ array[ index ] ] );
    	array = array_remove_index( array, index );
	}
	flag_set( flag );
	wait 0.05;
	flag_remove( flag );
}

xor( a, b )
{
	Assert( IsDefined( a ) && IsDefined( b ) );
	
	if ( a & b )
		return 0;
	if ( !a & !b )
		return 0;
	if ( a | b )
		return 1;
}

flat_angle_yaw( angle )
{
	Assert( IsDefined( angle ) );
	return ( 0, angle[ 1 ], 0 );
}

round_to( val, mult )
{
	return ( int( val * mult ) / mult );
}

return_place( val, place )
{
	Assert( IsDefined( val ) );
	val = abs( val );
	place = ter_op( place < 0, 0, place );
	
	if ( place <= 0 )
		return val;
	if ( place >= 1 )
	{
		_val = Int( val );
		val_highest_dec_place = 1;
		ten_exp = 1;
		while ( _val - ten_exp > 0 )
		{
			val_highest_dec_place++;
			ten_exp *= 10;
		}
		
		power = val_highest_dec_place - 1;
		
		if ( place > ten_to_int_power( power ) )
			return 0;
		while ( power != place && power > 0 )
		{
			ten_to_power = ten_to_int_power( power );
			while ( _val - ten_to_power >= 0 )
				_val -= ten_to_power;
			power--;
		}
		return Int( _val );
	}
	else
	{
		_val = val - Int( val );
		place = 1 / place;
		_val *= place;
		
		val_highest_dec_place = 0;
		ten_exp = 1;
		while ( _val - ten_exp > 0 )
		{
			val_highest_dec_place++;
			ten_exp *= 10;
		}
		
		power = val_highest_dec_place - 1;
		while ( power > 0 )
		{
			ten_to_power = ten_to_int_power( power );
			while ( _val - ten_to_power >= 0 )
				_val -= ten_to_power;
			power--;
		}
		return Int( _val );
	}
}

ten_to_int_power( power )
{
	result = 1;
	if ( power >= 1 )
		for( i = 0; i < power; i++ )
			result *= 10;
	else
	if ( power < 0 )
		for ( i = 1; i < abs( power ); i++ )
			result /= 10;
	return result;
}

get_closest_within_fov( origin, angles, targets, fov, offset )
{
	Assert( IsDefined( origin ) );
	Assert( IsDefined( angles ) );
	Assert( IsDefined( targets ) && IsArray( targets ) );
	Assert( IsDefined( fov ) );
	
	offset = ter_op( IsDefined( offset ), offset, ( 0, 0, 0 ) );
	
	targets = SortByDistance( targets, origin );
	
	foreach ( target in targets )
	{
		n 	= VectorNormalize( target.origin + offset - origin );
		fwd = AnglesToForward( angles );
		dot = VectorDot( fwd, n );
		
		if ( dot >= fov )
			return target;
	}
}

is_entity()
{
	return IsDefined( self.classname );
}

is_struct()
{
	return !IsDefined( self.classname );
}

hide_and_not_solid()
{
	self Hide();
	self NotSolid();
}

show_and_solid()
{
	self Show();
	self Solid();
}

random_sign()
{
	if ( RandomInt( 2 ) )
		return 1;
	return -1;
}

ent1_is_in_front_of_ent2( ent1, ent2 )
{
	fwd = AnglesToForward( flat_angle( ent2.angles ) );
	n 	= VectorNormalize( flat_origin( ent1.origin ) - ent2.origin );
	dot = VectorDot( fwd, n );
	
	if ( dot > 0 )
		return true;
	else
		return false;
}

copy_keys( copy_ents, master_ent, keys )
{
	AssertEX( IsDefined( copy_ents ), "copy_ents is not defined" );
	AssertEX( IsArray( copy_ents ), "copy_ents is not an array" );
	AssertEX( IsDefined( master_ent ), "master_ent is not defined" );
	
	if ( !IsDefined( keys ) || !IsArray( keys ) )
		return;
		
	foreach ( ent in copy_ents )
		foreach ( key in keys )
			ent set_key( master_ent get_key( key ), key );
}

array_remove_keys( array, keys )
{
	Assert( IsDefined( array ) && IsArray( array ) );
	
	if ( !IsDefined( keys ) )
		return array;
	Assert( IsArray( keys ) );
	
	_array = [];
	
	foreach ( item in array )
	{
		remove = 0;
		
		foreach ( key in keys )
		{
			if ( IsDefined( item get_key( key ) ) )
			{
				remove = 1;
				break;
			}
		}
		if ( !remove )
			_array[ _array.size ] = item;
	}
	return _array;
}

array_remove_values( array, keys, values, op )
{
	Assert( IsDefined( array ) && IsArray ( array ) );
	
	if ( !IsDefined( keys ) || !IsDefined( values ) )
		return array;
	Assert( IsArray( keys ) && IsArray( values ) && keys.size == values.size );
	
	op = ToLower( ter_op( IsDefined( op ), op, "or" ) );
	switch( op )
	{
		case "and":
		case "or":
			break;
		default:
			op = "and";
	}
	
	_array = [];
	keep = 1;
	
	foreach ( item in array )
	{
		switch( op )
		{
			case "and":
				keep = 0;
				foreach ( i, key in keys )
				{
					value = item get_key( key );
					if ( !compare( value, values[ i ] ) )
					{
						keep = 1;
						break;
					}
				}
				break;
			case "or":
				keep = 1;
				foreach ( i, key in keys )
				{
					value = item get_key( key );
					if ( compare( value, values[ i ] ) )
					{
						keep *= 0;
						break;
					}
				}
				break;
		}
		if ( keep )
			_array[ _array.size ] = item;
	}
	return _array;
}

array_keep_keys( array, keys )
{
	Assert( IsDefined( array ) && IsArray( array ) );
	
	if ( !IsDefined( keys ) )
		return array;
	Assert( IsArray( keys ) );
	
	_array = [];
	
	foreach ( item in array )
	{
		keep = 0;
		
		foreach ( key in keys )
		{
			if ( IsDefined( item get_key( key ) ) )
			{
				keep = 1;
				break;
			}
		}
		if ( keep )
			_array[ _array.size ] = item;
	}
	return _array;
}

array_keep_values( array, keys, values, op )
{
	Assert( IsDefined( array ) && IsArray ( array ) );
	
	if ( !IsDefined( keys ) || !IsDefined( values ) )
		return array;
	Assert( IsArray( keys ) && IsArray( values ) && keys.size == values.size );
	
	op = ToLower( ter_op( IsDefined( op ), op, "and" ) );
	switch( op )
	{
		case "and":
		case "or":
			break;
		default:
			op = "and";
	}
	
	_array = [];
	keep = 1;
	
	foreach ( item in array )
	{
		switch( op )
		{
			case "and":
				keep = 1;
				foreach ( i, key in keys )
				{
					value = item get_key( key );
					if ( !compare( value, values[ i ] ) )
					{
						keep *= 0;
						break;
					}
				}
				break;
			case "or":
				keep = 0;
				foreach ( i, key in keys )
				{
					value = item get_key( key );
					if ( compare( value, values[ i ] ) )
					{
						keep = 1;
						break;
					}
				}
				break;
		}
		if ( keep )
			_array[ _array.size ] = item;
	}
	return _array;
}

array_keep_key_values( array, key, values )
{
	Assert( IsDefined( array ) && IsArray ( array ) );
	Assert( IsDefined( key ) );
	Assert( IsDefined( values ) && IsArray( values ) );
	
	_array = [];
	
	foreach ( item in array )
	{
		keep = 0;
		foreach( value in values )
		{
			if ( item compare_value( key, value ) )
			{
				keep = 1;
				break;
			}
		}
		
		if ( keep )
			_array[ _array.size ] = item;
	}
	return _array;
}

array_remove_duplicates( array )
{
	Assert( IsDefined( array ) && IsArray( array ) );
	
	_array = [];
	
	foreach ( i, item in array )
	{
		keep = 1;
		
		foreach ( j, _item in array )
		{
			if ( i != j && compare( item, _item ) )
			{
				keep = 0;
				break;
			}
		}
		
		if ( keep )
			_array[ _array.size ] = item;
	}
	return _array;
}

array_item_exists( array, item )
{
	Assert( IsDefined( array ) && IsArray( array ) );
	
	foreach ( _item in array )
		if ( compare( item, _item ) )
			return true;
	return false;
}

spawn_struct_array( size )
{
	size = gt_op( size, 0 );
	
	array = [];
	
	if ( size )
		for ( i = 0; i < size; i++ )
			array[ i ] = SpawnStruct();
	return array;
}

play_fx_x_times( fx, pos, fwd, x, delay )
{
	Assert( IsDefined( fx ) );
	Assert( IsDefined( pos ) );
	Assert( IsDefined( fwd ) );
	
	x = gt_op( x, 0 );
	delay = gt_op( delay, 0 );
	
	for ( i = 0; i < x; i++ )
	{
		PlayFX( fx, pos, fwd );
		wait delay;
	}
}

set_grenadeawareness( value )
{
	self.grenadeawareness = value;
}

set_neverEnableCQB( value )
{
	self.neverEnableCQB = value;
}

compare_value( key, value )
{
	if ( !IsDefined( self ) || !IsDefined( value ) )
		return false;
	return compare( self get_key( key ), value );
}

compare_keys( ents, key, _default )
{
	if ( !IsDefined( ents ) || !IsArray( ents ) )
		return ter_op( IsDefined( _default ), _default, false );
	result = true;
	foreach ( ent in ents )
		if ( !IsDefined( ent ) )
			return false;
		else
			result *= compare( ents[ 0 ] get_key( key ), ent get_key( key  ) );
	return result;
}

compare_values( ents, key, value, _default )
{
	if ( !IsDefined( ents ) || !IsArray( ents ) )
		return ter_op( IsDefined( _default ), _default, false );
	result = true;
	foreach ( ent in ents )
		if ( !IsDefined( ent ) )
			return false;
		else
			result *= compare( ent get_key( key  ), value );
	return result;
}

compare( a, b )
{
	if ( IsDefined( a ) && IsDefined( b ) )
		return ter_op( a == b, true, false );
	if ( IsDefined( a ) && !IsDefined( b ) )
		return false;
	if ( !IsDefined( a ) && IsDefined( b ) )
		return false;
	if ( !IsDefined( a ) && !IsDefined( b ) )
		return false;
}

dec_op( a, b, float_error, floor )
{
	Assert( IsDefined( a ) );
	Assert( IsDefined( b ) );
	Assert( IsDefined( float_error ) );
	Assert( IsDefined( floor ) );
	
	a -= b;
	a = ter_op( a < float_error, floor, a );
	return a;
}

gt_op( a, b, _default )
{
	if ( IsDefined( a ) && IsDefined( b ) )
		return ter_op( a > b, a, b );
	if ( IsDefined( a ) && !IsDefined( b ) )
		return a;
	if ( !IsDefined( a ) && IsDefined( b ) )
		return b;
	return _default;		
}

lt_op( a, b, _default )
{
	if ( IsDefined( a ) && IsDefined( b ) )
		return ter_op( a < b, a, b );
	if ( IsDefined( a ) && !IsDefined( b ) )
		return a;
	if ( !IsDefined( a ) && IsDefined( b ) )
		return b;
	return _default;		
}

clamp_op( x, a, b, _clamp, _default )
{
	// 0 - floor, if x undefined
	// 1 - ceil, if x undefined
	
	_clamp = ter_op( IsDefined( _clamp ), _clamp, 0 );
	
	if ( IsDefined( x ) && IsDefined( a ) && IsDefined( b ) )
		return Clamp( x, a, b );
	if ( IsDefined( x ) )
		if ( IsDefined( a ) && !IsDefined( b ) )
			return ter_op( a <= x, a, b );
		else
		if ( !IsDefined( a ) && IsDefined( b ) )
			return ter_op( x <= b, x, b );
		else
			return x;
	if ( !_clamp && IsDefined( a ) )
		return a;
	if ( IsDefined( b ) )
		return b;
	if ( IsDefined( a ) )
		return a;
	return _default;
}

dsq_2d_lt( a, b, r, h, _default )
{
	if ( IsDefined( a ) && IsDefined( b ) && IsDefined( r ) )
		if ( IsDefined( h ) )
			return ter_op ( distance_2d_squared( a, b ) < Squared( r ) && abs( b[ 2 ] - a[ 2 ] ) < h, true, false );
		else
			return ter_op ( distance_2d_squared( a, b ) < Squared( r ), true, false );
	return ( ter_op( IsDefined( _default ), _default, false ) );
}

dsq_2d_ents_lt( ent1, ent2, r, h, _default )
{
	if ( IsDefined( ent1 ) && IsDefined( ent2 ) && IsDefined( r ) )
		if ( IsDefined( h ) )
			return ter_op ( distance_2d_squared( ent1.origin, ent1.origin ) < Squared( r ) && abs( ent2.origin[ 2 ] - ent1.origin[ 2 ] ) < h, true, false );
		else
			return ter_op ( distance_2d_squared( ent1.origin, ent2.origin ) < Squared( r ), true, false );
	return ( ter_op( IsDefined( _default ), _default, false ) );
}

dsq_2d_ents_gt( ent1, ent2, r, h, _default )
{
	if ( IsDefined( ent1 ) && IsDefined( ent2 ) && IsDefined( r ) )
		if ( IsDefined( h ) )
			return ter_op ( distance_2d_squared( ent1.origin, ent1.origin ) > Squared( r ) && abs( ent2.origin[ 2 ] - ent1.origin[ 2 ] ) > h, true, false );
		else
			return ter_op ( distance_2d_squared( ent1.origin, ent2.origin ) > Squared( r ), true, false );
	return ( ter_op( IsDefined( _default ), _default, false ) );
}

dsq_2d_gt( a, b, r, h, _default )
{
	if ( IsDefined( a ) && IsDefined( b ) && IsDefined( r ) )
		if ( IsDefined( h ) )
			return ter_op ( distance_2d_squared( a, b ) > Squared( r ) && abs( b[ 2 ] - a[ 2 ] ) > h, true, false );
		else
			return ter_op ( distance_2d_squared( a, b ) > Squared( r ), true, false );
	return ( ter_op( IsDefined( _default ), _default, false ) );
}

dsq_lt( a, b, r, _default )
{
	if ( IsDefined( a ) && IsDefined( b ) && IsDefined( r ) )
		return ter_op ( DistanceSquared( a, b ) < Squared( r ), true, false );
	return ( ter_op( IsDefined( _default ), _default, false ) );
}

dsq_gte( a, b, r, _default )
{
	if ( IsDefined( a ) && IsDefined( b ) && IsDefined( r ) )
		return ter_op ( DistanceSquared( a, b ) >= Squared( r ), true, false );
	return ( ter_op( IsDefined( _default ), _default, false ) );
}

dsq_gt( a, b, r, _default )
{
	if ( IsDefined( a ) && IsDefined( b ) && IsDefined( r ) )
		return ter_op ( DistanceSquared( a, b ) > Squared( r ), true, false );
	return ( ter_op( IsDefined( _default ), _default, false ) );
}

dsq_ents_gt( ent1, ent2, r, _default )
{
	if ( IsDefined( ent1 ) && IsDefined( ent2 ) && IsDefined( r ) )
		return ter_op ( DistanceSquared( ent1.origin, ent2.origin ) > Squared( r ), true, false );
	return ( ter_op( IsDefined( _default ), _default, false ) );

}

dsq_ents_lt( ent1, ent2, r, _default )
{
	if ( IsDefined( ent1 ) && IsDefined( ent2 ) && IsDefined( r ) )
		return ter_op ( DistanceSquared( ent1.origin, ent2.origin ) < Squared( r ), true, false );
	return ( ter_op( IsDefined( _default ), _default, false ) );

}

/*
params:
	[ fxid, origin ]
*/

delete_createFXent_fx( fx_ids )
{
	Assert( IsDefined( fx_ids ) && IsArray( fx_ids ) );
	
	level.createFXent = array_removeundefined( level.createFXent );
	
	foreach ( fx_id in fx_ids )
	{
		Assert( IsDefined( fx_id[ 0 ] ) && IsDefined( fx_id[ 1 ] ) );
		
		foreach ( i, ent in level.createFXent )
		{
			if ( IsDefined( ent ) && IsDefined( ent.v ) )
			{	
				if ( compare( ent.v[ "fxid" ], fx_id[ 0 ] ) && compare( ent.v[ "origin" ], fx_id[ 1 ] ) )
				{
					if ( IsDefined( ent.looper ) )
						ent.looper Delete();
					level.createFXent[ i ] = undefined;
				}
			}
		}
	}
	level.createFXent = array_removeundefined( level.createFXent );
}

pip_test_init()
{
	// PIP starts drawing from TOP LEFT CORNER 
	// Screen Bounds
	// - [ -128, 682 ]
	// - [ 0, 480 ]
	
	cam = GetEnt( "test_ss_pip", "targetname" );
	
	level.pip = level.player NewPip();
	level.pip.freeCamera = true;
	level.pip.entity = cam;
	
	level.pip.fov = 65;
	level.pip.enableshadows = false;
	level.pip.tag = "tag_origin";
	level.pip.x = 0;
	level.pip.y = 0;
	level.pip.width = 64;
	level.pip.height = 64;
	level.pip.visionsetnaked = "paris_ac130_night"; //paris_ac130_thermal
	level.pip.enable = true;
}

pip_test( ss_coord )
{
	// PIP Mapping to Screen Space Mapping
	// x: [ -128, 682 ] -> [ 320, -320 ]
	// y: [ 0, 416 ] -> [ -240 , 240 ]
	
	x = ss_coord[ 0 ];
	y = ss_coord[ 1 ];
	
	if ( x > 320 || x < -320 || y > 240 || y < -240 )
	{
		level.pip.enable = false;
		return;
	}

	level.pip.enable = true;
	level.pip.x = ( x * 1.265625 ) + 277 + 32;
	level.pip.y =  0.866667 * y + 208 - 32;
}
	
cross( a, b )
{
	return ( a[ 1 ] * b[ 2 ] - a[ 2 ] * b[ 1 ],
	         a[ 2 ] * b[ 0 ] - a[ 0 ] * b[ 2 ],
	         a[ 0 ] * b[ 1 ] - a[ 1 ] * b[ 0 ] );
}

get_view_matrix()
{
	eye = level.player GetEye();
	n = VectorNormalize( ( ( AnglesToForward( level.player GetPlayerAngles() ) * 65535 ) + eye ) - eye );
	v_up = cross( n, ( 0, 0, 1 ) );
	v = VectorNormalize( v_up - ( n * ( VectorDot( v_up, n ) / VectorDot( n, n ) ) ) );
	u = VectorNormalize( cross( v, n ) );
	
	return matrix44_multiply( [ [ u[ 0 ], u[ 1 ], u[ 2 ], 0 ], 
			 				    [ v[ 0 ], v[ 1 ], v[ 2 ], 0 ],
			 				    [ n[ 0 ], n[ 1 ], n[ 2 ], 0 ],
			 				    [ 0, 0, 0,  1 ] ], 
			 				  [ [ 1, 0, 0, -1*eye[ 0 ] ], 
			 				    [ 0, 1, 0, -1*eye[ 1 ] ],
			 				    [ 0, 0, 1, -1*eye[ 2 ] ],
			 				    [ 0, 0, 0,  1 ] ] );
}

get_projection_matrix()
{
	// ** TODO make sure you use the right fov values!!
	//near_plane = GetDvarFloat( "r_znear" );
	//far_plane = 65535;
	//height = 480;
	//width = 640; //854 
	// height / width = 0.75; // 1 / aspect ratio
	// fov = 55;
	return matrix44_multiply( matrix44_multiply( [ [ 1, 0, 0, 0 ],
			 				    				   [ 0, 1, 0, 0 ],
			 				    				   [ 0, 0, 1, 8 ],
			 				    				   [ 0, 0, -1, 0 ] ],
			 				  					 [ [ 1.92, 0, 0, 0 ],
			 				    				   [ 0, 1.92, 0, 0 ],
			 				    				   [ 0, 0, 1, 0 ],
			 				    				   [ 0, 0, 0, 1 ] ] ),
			 				    				 [ [ 0.5625, 0, 0, 0 ],
			 				    				   [ 0, 1, 0, 0 ],
			 				    				   [ 0, 0, 1, 0 ],
			 				    				   [ 0, 0, 0, 1 ] ] );
}

get_screen_space_coord( ent )
{
	model_view = matrix41_multiply( get_view_matrix(), [ [ ent.origin[ 0 ] ], [ ent.origin[ 1 ] ] ,[ ent.origin[ 2 ] ],[ 1 ] ] );
	clip_coord = matrix41_multiply( get_projection_matrix(), model_view );
	ndc = [ [ clip_coord[ 0 ][ 0 ] / clip_coord[ 3 ][ 0 ] ], [ clip_coord[ 1 ][ 0 ] / clip_coord[ 3 ][ 0 ] ], [ clip_coord[ 2 ][ 0 ] / clip_coord[ 3 ][ 0 ] ] ];
	return [ [ 320 * ndc[ 0 ][ 0 ] + 320 ], [ 240 * ndc[ 1 ][ 0 ] + 240 ], [ ( ( 65535 - 4 ) / 2 ) * ndc[ 2 ][ 0 ] + ( ( 65535 + 4 ) / 2 ) ] ];
}

matrix41_multiply( m1, m2 )
{
	m3 = [ [ 0 ],
	       [ 0 ],
	       [ 0 ],
	       [ 0 ] ];

	for ( i = 0; i < 4; i++ )
		for ( j = 0; j < 1; j++ )
			for ( k = 0; k < 4; k++ )
				m3[ i ][ j ] += m1[ i ][ k ] * m2[ k ][ j ];
	return m3;
}

matrix14_multiply( m1, m2 )
{
	m3 = [ [ 0, 0, 0, 0 ] ];

	for ( i = 0; i < 1; i++ )
		for ( j = 0; j < 4; j++ )
			for ( k = 0; k < 4; k++ )
				m3[ i ][ j ] += m1[ i ][ k ] * m2[ k ][ j ];
	return m3;
}

matrix13_multiply( m1, m2 )
{
	m3 = [ [ 0, 0, 0, 0 ] ];

	for ( i = 0; i < 1; i++ )
		for ( j = 0; j < 3; j++ )
			for ( k = 0; k < 3; k++ )
				m3[ i ][ j ] += m1[ i ][ k ] * m2[ k ][ j ];
	return m3;
}

matrix33_multiply( m1, m2 )
{
	m3 = [ [ 0, 0, 0 ], 
		   [ 0, 0, 0 ],
		   [ 0, 0, 0 ] ];

	for ( i = 0; i < 3; i++ )
		for ( j = 0; j < 3; j++ )
			for ( k = 0; k < 3; k++ )
				m3[ i ][ j ] += m1[ i ][ k ] * m2[ k ][ j ];
	return m3;
}

matrix44_multiply( m1, m2 )
{
	m3 = [ [ 0, 0, 0, 0 ], 
		   [ 0, 0, 0, 0 ],
		   [ 0, 0, 0, 0 ],
		   [ 0, 0, 0, 0 ] ];

	for ( i = 0; i < 4; i++ )
		for ( j = 0; j < 4; j++ )
			for ( k = 0; k < 4; k++ )
				m3[ i ][ j ] += m1[ i ][ k ] * m2[ k ][ j ];
	return m3;
}

matrix44_inverse( m )
{
    inv = [ [ 0, 0, 0, 0 ],
    	 	[ 1, 1, 1, 1 ],
    	    [ 1, 1, 1, 1 ],
    		[ 1, 1, 1, 1 ] ];

	inv[ 0 ][ 0 ] =  m[ 1 ][ 1 ]*m[ 2 ][ 2 ]*m[ 3 ][ 3 ] - m[ 1 ][ 1 ]*m[ 2 ][ 3 ]*m[ 3 ][ 2 ] - m[ 2 ][ 1 ]*m[ 1 ][ 2 ]*m[ 3 ][ 3 ]
					 + m[ 2 ][ 1 ]*m[ 1 ][ 3 ]*m[ 3 ][ 2 ] + m[ 3 ][ 1 ]*m[ 1 ][ 2 ]*m[ 2 ][ 3 ] - m[ 3 ][ 1 ]*m[ 1 ][ 3 ]*m[ 2 ][ 2 ];
	inv[ 1 ][ 0 ] =  -1*m[ 1 ][ 0 ]*m[ 2 ][ 2 ]*m[ 3 ][ 3 ] + m[ 1 ][ 0 ]*m[ 2 ][ 3 ]*m[ 3 ][ 2 ] + m[ 2 ][ 0 ]*m[ 1 ][ 2 ]*m[ 3 ][ 3 ] 
				- m[ 2 ][ 0 ]*m[ 1 ][ 3 ]*m[ 3 ][ 2 ] - m[ 3 ][ 0 ]*m[ 1 ][ 2 ]*m[ 2 ][ 3 ] + m[ 3 ][ 0 ]*m[ 1 ][ 3 ]*m[ 2 ][ 2 ];
	inv[ 2 ][ 0 ] =   m[ 1 ][ 0 ]*m[ 2 ][ 1 ]*m[ 3 ][ 3 ] - m[ 1 ][ 0 ]*m[ 2 ][ 3 ]*m[ 3 ][ 1 ] - m[ 2 ][ 0 ]*m[ 1 ][ 1 ]*m[ 3 ][ 3 ] 
				+ m[ 2 ][ 0 ]*m[ 1 ][ 3 ]*m[ 3 ][ 1 ] + m[ 3 ][ 0 ]*m[ 1 ][ 1 ]*m[ 2 ][ 3 ] - m[ 3 ][ 0 ]*m[ 1 ][ 3 ]*m[ 2 ][ 1 ];
	inv[ 3 ][ 0 ] = -1*m[ 1 ][ 0 ]*m[ 2 ][ 1 ]*m[ 3 ][ 2 ] + m[ 1 ][ 0 ]*m[ 2 ][ 2 ]*m[ 3 ][ 1 ] + m[ 2 ][ 0 ]*m[ 1 ][ 1 ]*m[ 3 ][ 2 ]
				- m[ 2 ][ 0 ]*m[ 1 ][ 2 ]*m[ 3 ][ 1 ] - m[ 3 ][ 0 ]*m[ 1 ][ 1 ]*m[ 2 ][ 2 ] + m[ 3 ][ 0 ]*m[ 1 ][ 2 ]*m[ 2 ][ 1 ];
	inv[ 0 ][ 1 ] =  -1*m[ 0 ][ 1 ]*m[ 2 ][ 2 ]*m[ 3 ][ 3 ] + m[ 0 ][ 1 ]*m[ 2 ][ 3 ]*m[ 3 ][ 2 ] + m[ 2 ][ 1 ]*m[ 0 ][ 2 ]*m[ 3 ][ 3 ] 
				- m[ 2 ][ 1 ]*m[ 0 ][ 3 ]*m[ 3 ][ 2 ] - m[ 3 ][ 1 ]*m[ 0 ][ 2 ]*m[ 2 ][ 3 ] + m[ 3 ][ 1 ]*m[ 0 ][ 3 ]*m[ 2 ][ 2 ];
	inv[ 1 ][ 1 ] =   m[ 0 ][ 0 ]*m[ 2 ][ 2 ]*m[ 3 ][ 3 ] - m[ 0 ][ 0 ]*m[ 2 ][ 3 ]*m[ 3 ][ 2 ] - m[ 2 ][ 0 ]*m[ 0 ][ 2 ]*m[ 3 ][ 3 ] 
				+ m[ 2 ][ 0 ]*m[ 0 ][ 3 ]*m[ 3 ][ 2 ] + m[ 3 ][ 0 ]*m[ 0 ][ 2 ]*m[ 2 ][ 3 ] - m[ 3 ][ 0 ]*m[ 0 ][ 3 ]*m[ 2 ][ 2 ];
	inv[ 2 ][ 1 ] =  -1*m[ 0 ][ 0 ]*m[ 2 ][ 1 ]*m[ 3 ][ 3 ]  + m[ 0 ][ 0 ]*m[ 2 ][ 3 ]*m[ 3 ][ 1 ] + m[ 2 ][ 0 ]*m[ 0 ][ 1 ]*m[ 3 ][ 3 ] 
				- m[ 2 ][ 0 ]*m[ 0 ][ 3 ]*m[ 3 ][ 1 ] - m[ 3 ][ 0 ]*m[ 0 ][ 1 ]*m[ 2 ][ 3 ] + m[ 3 ][ 0 ]*m[ 0 ][ 3 ]*m[ 2 ][ 1 ];
	inv[ 3 ][ 1 ] =  m[ 0 ][ 0 ]*m[ 2 ][ 1 ]*m[ 3 ][ 2 ] - m[ 0 ][ 0 ]*m[ 2 ][ 2 ]*m[ 3 ][ 1 ] - m[ 2 ][ 0 ]*m[ 0 ][ 1 ]*m[ 3 ][ 2 ]
				+ m[ 2 ][ 0 ]*m[ 0 ][ 2 ]*m[ 3 ][ 1 ] + m[ 3 ][ 0 ]*m[ 0 ][ 1 ]*m[ 2 ][ 2 ] - m[ 3 ][ 0 ]*m[ 0 ][ 2 ]*m[ 2 ][ 1 ];
	inv[ 0 ][ 2 ] =   m[ 0 ][ 1 ]*m[ 1 ][ 2 ]*m[ 3 ][ 3 ] - m[ 0 ][ 1 ]*m[ 1 ][ 3 ]*m[ 3 ][ 2 ] - m[ 1 ][ 1 ]*m[ 0 ][ 2 ]*m[ 3 ][ 3 ] 
				+ m[ 1 ][ 1 ]*m[ 0 ][ 3 ]*m[ 3 ][ 2 ] + m[ 3 ][ 1 ]*m[ 0 ][ 2 ]*m[ 1 ][ 3 ] - m[ 3 ][ 1 ]*m[ 0 ][ 3 ]*m[ 1 ][ 2 ];
	inv[ 1 ][ 2 ] =  -1*m[ 0 ][ 0 ]*m[ 1 ][ 2 ]*m[ 3 ][ 3 ]  + m[ 0 ][ 0 ]*m[ 1 ][ 3 ]*m[ 3 ][ 2 ] + m[ 1 ][ 0 ]*m[ 0 ][ 2 ]*m[ 3 ][ 3 ] 
				- m[ 1 ][ 0 ]*m[ 0 ][ 3 ]*m[ 3 ][ 2 ] - m[ 3 ][ 0 ]*m[ 0 ][ 2 ]*m[ 1 ][ 3 ] + m[ 3 ][ 0 ]*m[ 0 ][ 3 ]*m[ 1 ][ 2 ];
	inv[ 2 ][ 2 ] =  m[ 0 ][ 0 ]*m[ 1 ][ 1 ]*m[ 3 ][ 3 ]  - m[ 0 ][ 0 ]*m[ 1 ][ 3 ]*m[ 3 ][ 1 ] - m[ 1 ][ 0 ]*m[ 0 ][ 1 ]*m[ 3 ][ 3 ] 
				+ m[ 1 ][ 0 ]*m[ 0 ][ 3 ]*m[ 3 ][ 1 ] + m[ 3 ][ 0 ]*m[ 0 ][ 1 ]*m[ 1 ][ 3 ] - m[ 3 ][ 0 ]*m[ 0 ][ 3 ]*m[ 1 ][ 1 ];
	inv[ 3 ][ 2 ] = -1*m[ 0 ][ 0 ]*m[ 1 ][ 1 ]*m[ 3 ][ 2 ] + m[ 0 ][ 0 ]*m[ 1 ][ 2 ]*m[ 3 ][ 1 ] + m[ 1 ][ 0 ]*m[ 0 ][ 1 ]*m[ 3 ][ 2 ]
				- m[ 1 ][ 0 ]*m[ 0 ][ 2 ]*m[ 3 ][ 1 ] - m[ 3 ][ 0 ]*m[ 0 ][ 1 ]*m[ 1 ][ 2 ] + m[ 3 ][ 0 ]*m[ 0 ][ 2 ]*m[ 1 ][ 1 ];
	inv[ 0 ][ 3 ] =  -1*m[ 0 ][ 1 ]*m[ 1 ][ 2 ]*m[ 2 ][ 3 ] + m[ 0 ][ 1 ]*m[ 1 ][ 3 ]*m[ 2 ][ 2 ] + m[ 1 ][ 1 ]*m[ 0 ][ 2 ]*m[ 2 ][ 3 ]
				- m[ 1 ][ 1 ]*m[ 0 ][ 3 ]*m[ 2 ][ 2 ] - m[ 2 ][ 1 ]*m[ 0 ][ 2 ]*m[ 1 ][ 3 ] + m[ 2 ][ 1 ]*m[ 0 ][ 3 ]*m[ 1 ][ 2 ];
	inv[ 1 ][ 3 ] =   m[ 0 ][ 0 ]*m[ 1 ][ 2 ]*m[ 2 ][ 3 ] - m[ 0 ][ 0 ]*m[ 1 ][ 3 ]*m[ 2 ][ 2 ] - m[ 1 ][ 0 ]*m[ 0 ][ 2 ]*m[ 2 ][ 3 ]
				+ m[ 1 ][ 0 ]*m[ 0 ][ 3 ]*m[ 2 ][ 2 ] + m[ 2 ][ 0 ]*m[ 0 ][ 2 ]*m[ 1 ][ 3 ] - m[ 2 ][ 0 ]*m[ 0 ][ 3 ]*m[ 1 ][ 2 ];
	inv[ 2 ][ 3 ] = -1*m[ 0 ][ 0 ]*m[ 1 ][ 1 ]*m[ 2 ][ 3 ] + m[ 0 ][ 0 ]*m[ 1 ][ 3 ]*m[ 2 ][ 1 ] + m[ 1 ][ 0 ]*m[ 0 ][ 1 ]*m[ 2 ][ 3 ]
				- m[ 1 ][ 0 ]*m[ 0 ][ 3 ]*m[ 2 ][ 1 ] - m[ 2 ][ 0 ]*m[ 0 ][ 1 ]*m[ 1 ][ 3 ] + m[ 2 ][ 0 ]*m[ 0 ][ 3 ]*m[ 1 ][ 1 ];
	inv[ 3 ][ 3 ]  =  m[ 0 ][ 0 ]*m[ 1 ][ 1 ]*m[ 2 ][ 2 ] - m[ 0 ][ 0 ]*m[ 1 ][ 2 ]*m[ 2 ][ 1 ] - m[ 1 ][ 0 ]*m[ 0 ][ 1 ]*m[ 2 ][ 2 ]
				+ m[ 1 ][ 0 ]*m[ 0 ][ 2 ]*m[ 2 ][ 1 ] + m[ 2 ][ 0 ]*m[ 0 ][ 1 ]*m[ 1 ][ 2 ] - m[ 2 ][ 0 ]*m[ 0 ][ 2 ]*m[ 1 ][ 1 ];
	
	det = m[ 0 ][ 0 ]*inv[ 0 ][ 0 ] + m[ 0 ][ 1 ]*inv[ 1 ][ 0 ] + m[ 0 ][ 2 ]*inv[ 2 ][ 0 ] + m[ 0 ][ 3 ]*inv[ 3 ][ 0 ];
	if (det == 0)
	        return;
	
	det = 1.0 / det;
	
	for ( i = 0; i < 4; i++ )
		for ( j = 0; j < 4; j++ )
	        inv[ i ][ j ] *= det;
	return inv;
}

matrix_transpose( m )
{
	t = [];
	
 	foreach( i, r in m )
		foreach( j, c in r )
			t[ j ][ i ] = c;	
 	return t;
}

get_rotation_matrix33_x( x )
{
	Assert( IsDefined( x ) );
	return [ [ 1,        0,         0 ],
			 [ 0, Cos( x ), -1 * Sin( x ) ],
			 [ 0, Sin( x ),  Cos( x ) ] ];
}

get_rotation_matrix33_y( y )
{
	Assert( IsDefined( y ) );
	return [ [ Cos( y ), 		 0,  Sin( y ) ],
			 [ 0, 		         1, 		0 ],
		 	 [ 0, 		 -1 * Sin( y ),  Cos( y ) ] ];
}

get_rotation_matrix33_z( z )
{
	Assert( IsDefined( z ) );
	return [ [ Cos( z ), -1 * Sin( z ), 0 ],
			 [ Sin( z ),  Cos( z ), 0 ],
		 	 [ 0, 		 		  0, 1 ] ];
}

vector_rotate_x( v, x )
{
	Assert( IsDefined( v ) );
	Assert( IsDefined( x ) );
	
	vr = matrix13_multiply( [ [ v[ 0 ], v[ 1 ], v[ 2 ] ] ], get_rotation_matrix33_x( x ) );
	return ( vr[ 0 ][ 0 ], vr[ 0 ][ 1 ], vr[ 0 ][ 2 ] ); 
}

vector_rotate_y( v, y )
{
	Assert( IsDefined( v ) );
	Assert( IsDefined( y ) );
	
	vr = matrix13_multiply( [ [ v[ 0 ], v[ 1 ], v[ 2 ] ] ], get_rotation_matrix33_y( y ) );
	return ( vr[ 0 ][ 0 ], vr[ 0 ][ 1 ], vr[ 0 ][ 2 ] );
}

vector_rotate_z( v, z )
{
	Assert( IsDefined( v ) );
	Assert( IsDefined( z ) );
	
	vr = matrix13_multiply( [ [ v[ 0 ], v[ 1 ], v[ 2 ] ] ], get_rotation_matrix33_z( z ) );
	return ( vr[ 0 ][ 0 ], vr[ 0 ][ 1 ], vr[ 0 ][ 2 ] );
}

vector_rotate( v, x, y, z )
{
	Assert( IsDefined( v ) );
	Assert( IsDefined( x ) && IsDefined( y ) && IsDefined( z ) );
	
	vr = matrix13_multiply( [ [ v[ 0 ], v[ 1 ], v[ 2 ] ] ], 
							matrix33_multiply( get_rotation_matrix33_x( x ),
										   	   matrix33_multiply( get_rotation_matrix33_y( y ), get_rotation_matrix33_z( z ) ) ) );
	return ( vr[ 0 ][ 0 ], vr[ 0 ][ 1 ], vr[ 0 ][ 2 ] );
}

set_badplaceawareness( value )
{
	value = gt_op( value, 0 );
	
	if ( IsDefined( self.badplaceawareness ) )
		self.old_badplaceawareness = self.badplaceawareness;
	self.badplaceawareness = value;
}

unset_badplaceawareness()
{
	if ( IsDefined( self.old_badplaceawareness ) )
		self.badplaceawareness = self.old_badplaceawareness;
}

fade_to_black( fade_time, alpha )
{
 	fade_time = gt_op( fade_time, 0 );
 	alpha = clamp_op( alpha, 0, 1 );
 	   
	level.black_overlay = maps\_hud_util::create_client_overlay( "black", 0, level.player );
	if ( fade_time > 0 )
		level.black_overlay FadeOverTime( fade_time );
	level.black_overlay.alpha = alpha;
	level.black_overlay.foreground = true;
	
	wait fade_time;
}

fade_in_from_black( fade_time, alpha )
{
 	fade_time = gt_op( fade_time, 0 );
 	alpha = clamp_op( alpha, 0, 1 );
    
    if ( !IsDefined( level.black_overlay ) )
        return;
    
    if ( fade_time > 0 )    
		level.black_overlay FadeOverTime( fade_time );
	level.black_overlay.alpha = alpha;
	
	wait fade_time;
	
	level.black_overlay Destroy();
}

earthquake_at_ent( scale, duration, ent, radius )
{
	Assert( IsDefined( ent ) );
	
	scale = gt_op( scale, 0 );
	duration = gt_op( duration, 0.05 ); 
	radius = gt_op( radius, 0 );
	
	for ( elapsed = 0; IsDefined( ent ) && elapsed < duration; elapsed += 0.05 )
	{ 
		Earthquake( scale, 0.05, ent.origin, radius );
		wait 0.05;
	}
}

earthquake_at_ent_flag( scale, flag, ent, radius )
{
	
	Assert( IsDefined( ent ) );
	Assert( IsDefined( flag ) );
	
	if ( self != level )	
		Assert( self ent_flag_exist( flag ) );
	else
		Assert( flag_exist( flag ) );
		
	scale = gt_op( scale, 0 );
	radius = gt_op( radius, 0 );

	flag_set = false;
	
	for ( ;!flag_set; wait 0.05 )
	{ 
		if ( self != level )	
			flag_set = self ent_flag( flag );
		else
			flag_set = flag_exist( flag );
			
		Earthquake( scale, 0.05, ent.origin, radius );
	}
}

modulus_float( f, m )
{
	Assert( IsDefined( f ) );
	Assert( IsDefined( m ) );
	
	m = abs( m );
	
	while ( f > m )
		f -= m;
	while ( f < 0 )
		f += m;
	return ter_op( f == m, 0, f );
}

modulus_vector( v, m )
{
	return ( modulus_float( v[ 0 ], m ), modulus_float( v[ 1 ], m ), modulus_float( v[ 2 ], m ) );
}

reset_player_sprint_speed_scale()
{
	set_player_sprint_speed_scale( 1.5 );
}

set_player_sprint_speed_scale( sprint_speed_scale )
{
	sprint_speed_scale = gt_op( sprint_speed_scale, 0 );
	
	SetSavedDvar( "player_sprintSpeedScale", sprint_speed_scale );
}

_mission_failed( msg )
{
	Assert( IsDefined( msg ) );
	
	if ( GetDvarInt( "mission_fail_enabled", 1 ) )
	{
		level notify( "new_quote_string" );
		SetDvar( "ui_deadquote", msg );
		maps\_utility::missionFailedWrapper();
	}
}

get_2d_closest_with_key( _origin, array, key, dist )
{
	Assert( IsDefined( _origin ) );
	Assert( IsDefined( array ) && IsArray ( array ) );
	Assert( IsDefined( key ) && IsString( key ) );
	
	max_dist = 5000000;
	ent = undefined;
	
	foreach ( item in array )
	{
		dist = distance_2d_squared( _origin, item.origin );
		value = item get_key( key );
		
		if ( IsDefined( value ) && dist >= max_dist )
			continue;
		max_dist = dist;
		ent = item;
	}
	return ent;
}

switch_vehicle_path( node )
{
	Assert( IsDefined( node ) );
	
	self Vehicle_Teleport( node.origin, node.angles );
	if ( IsDefined( node.targetname ) )
		self.target = node.targetname;
	self.attachedpath = node;
	self StartPath( node );
}

// **TODO: instead of using "target", use the real target the vehicle points to... i.e. if StartPath() has been called previously
switch_vehicle_path_lerp( node )
{
	Assert( IsDefined( node ) );
	
	if ( IsDefined( node.targetname ) )
	{
		nodes = GetVehicleNodeArray( node.targetname, "targetname" );
		
		if ( nodes.size > 1 )
			self.target = node.target;
		else
			self.target = node.targetname;
	}
	self.attachedpath = node;
	
	ent_path_list = get_connected_ents( self.target );
	Assert( ent_path_list.size > 0 );

	// Try to get the appropriate resume speed
	
	closest_node = get_2d_closest_with_key( node.origin, ent_path_list, "speed" );
	
	speed = 1;
	
	if ( IsDefined( ent_path_list[ 0 ].speed ) )
		speed = ent_path_list[ 0 ].speed;
	else
	if ( IsDefined( closest_node ) )
		speed = closest_node.speed;
	else
	if ( IsDefined( node.speed ) )
		speed = node.speed;
		
	self StartPath( node );
	self ResumeSpeed( abs( speed ) );
}

switch_vehicle_between_paths( node_1, node_2 )
{
	Assert( IsDefined( node_1 ) );
	Assert( IsDefined( node_2 ) );
	
	self endon( "death" );
	
	node_1 waittill( "trigger", triggerer );
	Assert( self == triggerer );

	self switch_vehicle_path( node_2 );
}

switch_vehicle_between_paths_lerp( node_1, node_2 )
{
	Assert( IsDefined( node_1 ) );
	Assert( IsDefined( node_2 ) );
	
	self endon( "death" );
	
	node_1 waittill( "trigger", triggerer );
	Assert( self == triggerer );

	self switch_vehicle_path_lerp( node_2 );
}

switch_vehicle_between_paths_lerp_set_flag( node_1, node_2, flag )
{
	Assert( IsDefined( node_1 ) );
	Assert( IsDefined( node_2 ) );
	Assert( IsDefined( flag ) && flag_exist( flag ) );
	
	self endon( "death" );
	
	node_1 waittill( "trigger", triggerer );
	Assert( self == triggerer );

	self switch_vehicle_path_lerp( node_2 );
	flag_set( flag );
}

random_vector( min, max )
{
	Assert( IsDefined( min ) );
	
	max = gt_op( max, min + 0.05 );
	
	return ( RandomFloatRange( min, max ), RandomFloatRange( min, max ), RandomFloatRange( min, max ) );
}

random_int_vector( min, max )
{
	Assert( IsDefined( min ) );
	
	max = gt_op( max, min + 1 );
	
	return ( RandomIntRange( min, max ), RandomIntRange( min, max ), RandomIntRange( min, max ) );
}

proc_delete()
{
	if ( IsDefined( self ) )
	{
		self notify( "death" );
		self Delete();
	}
}

is_ent_left_of_2d_line( ent, slope, intercept )
{
	Assert( IsDefined( ent ) );
	Assert( IsDefined( slope ) );
	Assert( IsDefined( intercept ) );
	
	if ( slope > 0 )
		return ( ent.origin[ 1 ] >= ( ( slope * ent.origin[ 0 ] ) + intercept ) );
	if ( slope < 0 )
		return ( ent.origin[ 1 ] <= ( ( slope * ent.origin[ 0 ] ) + intercept ) );
}

get_random_x_from_array( x, array )
{
    Assert( IsDefined( array ) && IsArray( array ) );
    
    x = clamp_op( x, 0, array.size );
    array = array_randomize( array );
    random_x = [];
    
    foreach ( item in array )
        random_x[ random_x.size ] = item;
    return random_x;
}

anim_generic_single_solo_simple( guy, anime )
{
    Assert( IsDefined( guy ) && IsAlive( guy ) );
    Assert( IsDefined( anime ) );
    
    self maps\_anim::anim_single_solo( guy, anime, undefined, undefined, "generic" );
}

ai_end_cover_behavior()
{
    Assert( IsDefined( self ) && IsAI( self ) && IsAlive( self ) );
    
    self animscripts\cover_behavior::end_script( "stand" );
    self animscripts\cover_behavior::end_script( "left" );
    self animscripts\cover_behavior::end_script( "right" );
    self animscripts\cover_behavior::end_script( "crouch" );
}

add_unique_to_array( array, ent )
{
    if ( !IsDefined( ent ) )
		return array;

	if ( !IsDefined( array ) )
		array[ 0 ] = ent;
	else
	{
	    foreach ( item in array )
	        if ( IsDefined( item ) && item == ent )
	            return array;
		array[ array.size ] = ent;
	}
	return array;
}

at_least_x_alive_array( x, array )
{
    Assert( IsDefined( array ) && IsArray( array ) );
    
    x = clamp_op( x, 0, array.size );
    
    count = 0;
    
    foreach ( item in array )
    {
        if ( IsDefined( item ) && IsAlive( item ) )
            count++;
        if ( count >= x )
            return true;
    }
    return false;
}

is_alive_array( array )
{
    Assert( IsDefined( array ) && IsArray( array ) );
    
    is_alive = 1;
    
    foreach ( item in array )
        is_alive *= ter_op( IsDefined( item ) && IsAlive( item ), 1, 0 );
    return is_alive;
}

at_least_percent_dead_array( percent, array )
{
    Assert( IsDefined( array ) && IsArray( array ) );
    
    percent = gt_op( percent, 0 );
    
    count = 0;
    
    foreach ( item in array )
        if ( !IsDefined( item ) || !IsAlive( item ) )
            count++;
    return ter_op( array.size == 0 || ( count / array.size ) >= percent, true, false );
}

at_least_x_dead_array( x, array )
{
    Assert( IsDefined( array ) && IsArray( array ) );
    
    x = gt_op( x, 0 );
    
    count = 0;
    
    foreach ( item in array )
        if ( !IsDefined( item ) || !IsAlive( item ) )
            count++;
    return ter_op( count >= x, true, false );
}

get_random_alive_from_array( array )
{
    Assert( IsDefined( array ) && IsArray( array ) );
    
    array = array_removedead( array );
    array = array_removeundefined( array );
    array = array_randomize( array );
    
    return ( ter_op( array.size > 0, array[ 0 ], undefined ) ); 
}

get_random_defined_from_array( array )
{
    Assert( IsDefined( array ) && IsArray( array ) );
    
    array = array_removeundefined( array );
    array = array_randomize( array );
    
    return ( ter_op( array.size > 0, array[ 0 ], undefined ) ); 
}

get_key( key, _default )
{
    value = undefined;
    
    if ( !IsDefined( self ) || !IsDefined( key ) )
		return ter_op( IsDefined( _default ) && !IsDefined( value ), _default, value );
    	
    switch ( key )
    {
        case "angles":
            value = ter_op( IsDefined( self.angles ), self.angles, ( 0, 0, 0 ) );
            break;
        case "health":
        	value = self.health;
        	break;
        case "magic_bullet_shield":
        	value = self.magic_bullet_shield;
        	break;
        case "maxhealth":
        	value = self.maxhealth;
        	break;
        case "origin":
        	value = self.origin;
        	break;
       	case "script_drone":
       		value = self.script_drone;
       		break;
       	case "script_group":
       		value = self.script_group;
       		break;
        case "script_index":
        	value = self.script_index;
        	break;
        case "script_linkname":
        	value = self.script_linkname;
        	break;
        case "script_noteworthy":
            value = self.script_noteworthy;
            break;
        case "script_parameters":
        	value = self.script_parameters;
        	break;
        case "script_specialops":
        	value = self.script_specialops;
        	break;
        case "script_team":
        	value = self.script_team;
        	break;
        case "script_vehicleride":
        	value = self.script_vehicleride;
        	break;
        case "spawnflags":
        	value = self.spawnflags;
        	break;
        case "speed":
        	value = self.speed;
        	break;
        case "target":
            value = self.target;
            break;
        case "targetname":
            value = self.targetname;
            break;
        case "team":
        	value = self.team;
        	break;
    }
    return ter_op( IsDefined( _default ) && !IsDefined( value ), _default, value );
}

set_key( value, key )
{
	if ( !IsDefined( self ) || !IsDefined( key ) )
		return;
    
    switch ( key )
    {
        case "angles":
            self.angles = ter_op( IsDefined( value ), value, ( 0, 0, 0 ) );
            break;
       	case "ignoreall":
            self.ignoreall = value;
       		break;
       	case "ignoreme":
            self.ignoreme = value;
       		break;
       	case "magic_bullet_shield":
        	self.magic_bullet_shield = value;
        	break;
        case "maxhealth":
        	self.maxhealth = value;
        	break;
       	case "origin":
			self.origin = ter_op( IsDefined( value ), value, ( 0, 0, 0 ) );
       		break;
       	case "script_drone":
       		self.script_drone = value;
       		break;
       	case "script_group":
       		self.script_group = value;
       		break;
       	case "script_index":
        	self.script_index = value;
        	break;
        case "script_linkname":
        	self.script_linkname = value;
        	break;
        case "script_noteworthy":
            self.script_noteworthy = value;
            break;
    	case "script_parameters":
    		self.script_parameters = value;
    		break;
    	case "script_specialops":
    		self.script_specialops = value;
    		break;
    	case "script_team":
    		self.script_team = value;
    		break;
    	case "script_vehicleride":
        	self.script_vehicleride = value;
        	break;
        case "spawnflags":
        	self.spawnflags = value;
        	break;
        case "target":
           	self.target = value;
            break;
        case "targetname":
          	self.targetname = value;
            break;
        case "team":
        	self.team = value;
        	break;  
    }
}

get_ents_from_array( value, key, array, partial )
{
	Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	Assert( IsDefined( array ) );

	partial = ter_op( IsDefined( partial ), partial, true );
	ents = [];
	
	foreach ( ent in array )
	{
		_value = ent get_key( key );
		
		if ( IsDefined( _value ) )
		{
			if ( partial && IsSubStr( _value, value ) )
				ents = add_to_array( ents, ent );
			else
			if ( _value == value )
				ents = add_to_array( ents, ent );
		}
	}
	return ents;
}

get_connected_ents( start_value, start_key, next_value_key, next_key )
{
    Assert( IsDefined( start_value ) );
    
    start_key = ter_op( IsDefined( start_key ), start_key, "targetname" );
    next_value_key = ter_op( IsDefined( next_value_key ), next_value_key, "target" );
    next_key = ter_op( IsDefined( next_key ), next_key, "targetname" );
    
    ent_list = [];
    head_ent = getent_or_struct_or_node( start_value, start_key );
	next_ent = head_ent;
	prev_ent = undefined;
	
	if ( !IsDefined( head_ent ) )
	    return ent_list;
	
	ent_list[ ent_list.size ] = head_ent;
	
	while ( IsDefined( next_ent ) )
	{	
		prev_ent = next_ent;
	    value = next_ent get_key( next_value_key );
	    
		if ( IsDefined( value ) )
			next_ent = getent_or_struct_or_node( value, next_key );
		else
			next_ent = undefined;
	    
	    if ( IsDefined( next_ent ) )
	    {
	        if ( override_is_in_array( ent_list, next_ent ) )
	            break;
	        ent_list[ ent_list.size ] = next_ent;
	    }
	}
	return ent_list;
}

distance_2d_squared( a, b )
{
	return LengthSquared( ( a[ 0 ] - b[ 0 ], a[ 1 ] - b[ 1 ], 0 ) );
}

notify_thread( msgs, func, args )
{
	Assert( IsDefined( msgs ) && IsArray( msgs ) );
	Assert( IsDefined( func ) );
	//thread notify_thread_proc( msgs, func, args );
}
/*
notify_thread_proc( _notify, func, param1, param2, param3, param4, param5 )
{
	self endon( "death" );

	if ( self != level )	
		self waittill( _notify );
	else
		level waittill( _notify );
		
	if ( !IsDefined( param1 ) )
	{
		AssertEX( !IsDefined( param2 ), "flag wait thread does not support vars after undefined." );
		AssertEX( !IsDefined( param3 ), "flag wait thread does not support vars after undefined." );
		AssertEX( !IsDefined( param4 ), "flag wait thread does not support vars after undefined." );
		AssertEX( !IsDefined( param5 ), "flag wait thread does not support vars after undefined." );
		thread [[ func ]]();
	}
	else
	if ( !IsDefined( param2 ) )
	{
		AssertEX( !IsDefined( param3 ), "flag wait thread does not support vars after undefined." );
		AssertEX( !IsDefined( param4 ), "flag wait thread does not support vars after undefined." );
		AssertEX( !IsDefined( param5 ), "flag wait thread does not support vars after undefined." );
		thread [[ func ]]( param1 );
	}
	else
	if ( !IsDefined( param3 ) )
	{
		AssertEX( !IsDefined( param4 ), "flag wait thread does not support vars after undefined." );
		AssertEX( !IsDefined( param5 ), "flag wait thread does not support vars after undefined." );
		thread [[ func ]]( param1, param2 );
	}
	else
	if ( !IsDefined( param4 ) )	
	{
		AssertEX( !IsDefined( param5 ), "flag wait thread does not support vars after undefined." );
		thread [[ func ]]( param1, param2, param3 );
	}
	else
	if ( !IsDefined( param5 ) )	
	{
		thread [[ func ]]( param1, param2, param3, param4 );
	}
	else
	{
		thread [[ func ]]( param1, param2, param3, param4, param5 );
	}
}
*/
flag_wait_thread( flag, func, param1, param2, param3, param4, param5 )
{
	thread flag_wait_thread_proc( flag, func, param1, param2, param3, param4, param5 );
}

flag_wait_thread_proc( flag, func, param1, param2, param3, param4, param5 )
{
	self endon( "death" );

	if ( self != level )	
		Assert( self ent_flag_exist( flag ) );
	else
		Assert( flag_exist( flag ) );
	
	if ( self != level )	
		self ent_flag_wait( flag );
	else
		flag_wait( flag );
		
	if ( !IsDefined( param1 ) )
	{
		AssertEX( !IsDefined( param2 ), "flag wait thread does not support vars after undefined." );
		AssertEX( !IsDefined( param3 ), "flag wait thread does not support vars after undefined." );
		AssertEX( !IsDefined( param4 ), "flag wait thread does not support vars after undefined." );
		AssertEX( !IsDefined( param5 ), "flag wait thread does not support vars after undefined." );
		thread [[ func ]]();
	}
	else
	if ( !IsDefined( param2 ) )
	{
		AssertEX( !IsDefined( param3 ), "flag wait thread does not support vars after undefined." );
		AssertEX( !IsDefined( param4 ), "flag wait thread does not support vars after undefined." );
		AssertEX( !IsDefined( param5 ), "flag wait thread does not support vars after undefined." );
		thread [[ func ]]( param1 );
	}
	else
	if ( !IsDefined( param3 ) )
	{
		AssertEX( !IsDefined( param4 ), "flag wait thread does not support vars after undefined." );
		AssertEX( !IsDefined( param5 ), "flag wait thread does not support vars after undefined." );
		thread [[ func ]]( param1, param2 );
	}
	else
	if ( !IsDefined( param4 ) )	
	{
		AssertEX( !IsDefined( param5 ), "flag wait thread does not support vars after undefined." );
		thread [[ func ]]( param1, param2, param3 );
	}
	else
	if ( !IsDefined( param5 ) )	
	{
		thread [[ func ]]( param1, param2, param3, param4 );
	}
	else
	{
		thread [[ func ]]( param1, param2, param3, param4, param5 );
	}
}

safe_delete( ent )
{
    if ( IsDefined( ent ) )
        ent Delete();
}

point_between_ent2_ent1( percent, ent2, ent1 )
{
    Assert( IsDefined( ent2 ) );
    Assert( IsDefined( ent1 ) );
    percent = clamp_op( percent, 0, 1 );
    
    return ( ent2.origin + percent * Length( ent2.origin - ent1.origin ) * VectorNormalize( ent2.origin - ent1.origin ) );
}

point_between_2_points( percent, p1, p2 )
{
	Assert( IsDefined( p1 ) );
	Assert( IsDefined( p2 ) );
	percent = clamp_op( percent, 0, 1 );

	return ( p1 + percent * Length( p2 - p1 ) * VectorNormalize( p2 - p1 ) );
}

random_chance( percent )
{
    precent = clamp_op( percent, 0, 1 );
    return ter_op( ( RandomInt( 100 ) <= 100 * percent ), 1, 0 );
}

get_ai_in_range( team, point, range )
{
    Assert( IsDefined( team ) );
    Assert( IsDefined( point ) );
    
    ai_array = SortByDistance( GetAIArray( team ), point );
    ai_array = array_removedead_or_dying( ai_array );
    ai_array = array_removeundefined( ai_array );
    
    range = gt_op( range, 0 );
    
    sorted_ai_array = [];
    
    foreach ( ai in ai_array )
        if ( dsq_gte( ai.origin, point, range ) )
            sorted_ai_array[ sorted_ai_array.size ] = ai;   
    return sorted_ai_array;
}

get_ai_in_2d_range( team, point, range )
{
    Assert( IsDefined( team ) );
    Assert( IsDefined( point ) );
        
    ai_array = SortByDistance( GetAIArray( team ), point );
    ai_array = array_removedead_or_dying( ai_array );
    ai_array = array_removeundefined( ai_array );
    
    range = gt_op( range, 0 );
    
    sorted_ai_array = [];
    
    foreach ( ai in ai_array )
        if ( distance_2d_squared( ai.origin, point ) >= Squared( range ) )
            sorted_ai_array[ sorted_ai_array.size ] = ai;   
    return sorted_ai_array;
}

get_ai_in_cylinder( team, point, _radius, _height )
{
	Assert( IsDefined( team ) );
    Assert( IsDefined( point ) );
    
    _radius = gt_op( _radius, 0 );
    _height = gt_op( _height, 0 );
    
    ai_array = get_ai_in_2d_range( team, point, _radius );
    
    sorted_ai_array = [];
    
    foreach ( ai in ai_array )
    	if ( abs ( ai.origin[ 2 ] - point[ 2 ] ) <= -1*( _height / 2.0 ) )
    		sorted_ai_array[ sorted_ai_array.size ] = ai; 
    return sorted_ai_array;
}

to_string( str )
{
	Assert( IsDefined( str ) );
	return ( "" + str );
}

get_string_up_to( base_string, del )
{
	Assert( IsDefined( base_string ) );
	Assert( IsDefined( del ) );
	
	// Convert to string just in case
	
	del = to_string( del );
	prefix = "";
	
	for ( i = 0; i < base_string.size; i++ )
	{
		if ( base_string[ i ] == del )
			break;
		prefix += base_string[ i ];
	}
	return prefix;
}

move_to_ent_over_time( ent, time, offset, tag )
{
	Assert( IsDefined( ent ) );
	
	self notify( "LISTEN_stop_move_to" );
	self endon( "LISTEN_stop_move_to" );
		
	offset = ter_op( IsDefined( offset ), offset, ( 0, 0, 0 ) );
	
	for ( time = gt_op( time, 0.05 ); IsDefined( self ) && IsDefined( ent ) && time > 0; time = dec_op( time, 0.05, 0.05, 0 ) )
	{
		ent_pos = undefined;
		
		if ( IsDefined( tag ) )
			ent_pos = ent GetTagOrigin( tag );
		ent_pos = ter_op( IsDefined( ent_pos ), ent_pos, ent.origin );

		pos_diff = ( ent_pos + offset ) - self.origin;
		pos_diff /= time * 20;
		
		self MoveTo( self.origin + pos_diff, 0.05 );
		wait 0.05;
	}
}

rotate_to_ent_over_time( ent, time, offset )
{
	Assert( IsDefined( ent ) );
	
	self notify( "LISTEN_stop_rotate_to" );
	self endon( "LISTEN_stop_rotate_to" );
	
	offset = ter_op( IsDefined( offset ), offset, ( 0, 0, 0 ) );
		
	for ( time = gt_op( time, 0.05 ); IsDefined( self ) && IsDefined( ent ) && time > 0; time = dec_op( time, 0.05, 0.05, 0 ) )
	{
		angle_diff = ( ent.angles + offset ) - self.angles;
		angle_diff /= time * 20;
	
		self RotateTo( self.angles + angle_diff, 0.05 );
		wait 0.05;
	}
}

look_at_ent_over_time( ent, time, tag )
{
	Assert( IsDefined( ent ) );
	
	self notify( "LISTEN_stop_look_at" );
	self endon( "LISTEN_stop_look_at" );
	
	for ( time = gt_op( time, 0.05 ); IsDefined( self ) && IsDefined( ent ) && time > 0; time = dec_op( time, 0.05, 0.05, 0 ) )
	{
		ent_pos = undefined;
		
		if ( IsDefined( tag ) )
			ent_pos = ent GetTagOrigin( tag );
		ent_pos = ter_op( IsDefined( ent_pos ), ent_pos, ent.origin );
		
		angles_to_look 		= modulus_vector( VectorToAngles( ent_pos - self.origin ), 360 );
		self_angles_look 	= modulus_vector( self.angles, 360 );
		
		// See which way self will start rotating to, clockwise or counter-clockwise
		
		angle_diff = [ 0, 0, 0 ];

		mag 			= ter_op( angles_to_look[ 0 ] - self_angles_look[ 0 ] > 0, 1, -1 );
		angle_diff[ 0 ] = angles_to_look[ 0 ] - self_angles_look[ 0 ];
		angle_diff[ 0 ] = ter_op( abs( angle_diff[ 0 ] ) > 180, -1 * mag * ( 360 - abs( angle_diff[ 0 ] ) ), mag * abs( angle_diff[ 0 ] ) );
		
		mag 			= ter_op( angles_to_look[ 1 ] - self_angles_look[ 1 ] > 0, 1, -1 );
		angle_diff[ 1 ] = angles_to_look[ 1 ] - self_angles_look[ 1 ];
		angle_diff[ 1 ] = ter_op( abs( angle_diff[ 1 ] ) > 180, -1 * mag * ( 360 - abs( angle_diff[ 1 ] ) ), mag * abs( angle_diff[ 1 ] ) );
		
		mag 			= ter_op( angles_to_look[ 2 ] - self_angles_look[ 2 ] > 0, 1, -1 );
		angle_diff[ 2 ] = angles_to_look[ 2 ] - self_angles_look[ 2 ];
		angle_diff[ 2 ] = ter_op( abs( angle_diff[ 2 ] ) > 180, -1 * mag * ( 360 - abs( angle_diff[ 2 ] ) ), mag * abs( angle_diff[ 2 ] ) );
		
		angle_diff = ( angle_diff[ 0 ], angle_diff[ 1 ], angle_diff[ 2 ] );
		angle_diff /= time * 20;
	
		self RotateTo( self.angles + angle_diff, 0.05 );
		wait 0.05;
	}
}

get_trimmed_array( array, value, key )
{
	Assert( IsDefined( array ) );
	Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	
	new_array = array;
	
	foreach( item in array )
		if ( compare( item get_key( key ), value ) )
			new_array = array_remove( new_array, item );
	return new_array;
}

get_array_from_array( array, value, key )
{
	Assert( IsDefined( array ) );
	Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	
	sub_array = [];
	
	foreach ( item in array )
		if ( compare( item get_key( key ), value ) )
			sub_array = add_to_array( sub_array, item );
	return sub_array;
}

get_array_from_array_prefix( array, prefix, key )
{
	Assert( IsDefined( array ) );
	Assert( IsDefined( prefix ) );
	Assert( IsDefined( key ) );
	
	sub_array = [];
	
	foreach ( item in array )
	{
		value = item get_key( key );
		
		if ( IsDefined( value ) && string_starts_with( value, prefix ) )
			sub_array = add_to_array( sub_array, item );
	}
	return sub_array;
}

set_flag_ent_in_range_of_point( ent, point, range, flag )
{
    Assert( IsDefined( ent ) );
	Assert( IsDefined( point ) );

	if ( self != level )
	    self endon( "death" );
	    
	if ( self != level )	
		Assert( self ent_flag_exist( flag ) );
	else
		Assert( flag_exist( flag ) );
	
	for ( range = gt_op( range, 0 ); IsDefined( ent ) && dsq_gt( ent.origin, point, range ); wait 0.05 ){}
		
	if ( self != level )
		self ent_flag_set( flag );
	else
		flag_set( flag );
}

set_flag_ent1_in_2d_range_of_ent2( ent1, ent2, range, flag )
{
    Assert( IsDefined( ent1 ) );
	Assert( IsDefined( ent2 ) );
	
	if ( self != level )
	    self endon( "death" );
	    
	if ( self != level )	
		Assert( self ent_flag_exist( flag ) );
	else
		Assert( flag_exist( flag ) );
	
	for ( range = gt_op( range, 0 ); dsq_2d_ents_gt( ent1, ent2, range ); wait 0.05 ){}
	
	if ( IsDefined( ent1 ) && IsDefined( ent2 ) )	
		if ( self != level )
			self ent_flag_set( flag );
		else
			flag_set( flag );
}

set_flag_ent1_in_range_of_ent2( ent1, ent2, range, flag )
{
    Assert( IsDefined( ent1 ) );
	Assert( IsDefined( ent2 ) );
	
	if ( self != level )
	    self endon( "death" );
	    
	if ( self != level )	
		Assert( self ent_flag_exist( flag ) );
	else
		Assert( flag_exist( flag ) );
	
	for ( range = gt_op( range, 0 ); dsq_ents_gt( ent1, ent2, range ); wait 0.05 ){}
	
	if ( IsDefined( ent1 ) && IsDefined( ent2 ) )	
		if ( self != level )
			self ent_flag_set( flag );
		else
			flag_set( flag );
}

set_flags_delete_ent_in_range( ent, range, flags )
{
	Assert( IsDefined( ent ) );
	Assert( IsDefined( flags ) && IsArray( flags ) );
	
	foreach ( flag in flags )
		Assert( self ent_flag_exist( flag ) );
	
	for ( range = gt_op( range, 0 ); dsq_ents_gt( self, ent, range ); wait 0.05 ){}
		
	if ( IsDefined( self ) && IsDefined( ent ) )
	{
		foreach ( flag in flags )
			self ent_flag_set( flag );
		ent Delete();
	}
}

set_flag_ai_in_range_of_ent( ai, ent, range, flag )
{
	Assert( IsDefined( ai ) && IsAI( ai ) );
	Assert( IsDefined( ent ) );
	
	if ( self != level )
	    self endon( "death" );
	    
	if ( self != level )	
		Assert( self ent_flag_exist( flag ) );
	else
		Assert( flag_exist( flag ) );
	
	for ( range = gt_op( range, 0 ); IsAlive( ai ) && dsq_ents_gt( ai, ent, range ); wait 0.05 ){}
		
	if ( self != level )
		self ent_flag_set( flag );
	else
		flag_set( flag );
}

set_flag_ai_in_range_of_ent_timeout( ai, ent, range, flag, timeout )
{
	Assert( IsDefined( ai ) && IsAI( ai ) );
	Assert( IsDefined( ent ) );
	
	range = gt_op( range, 0 );
	
	if ( self != level )
	    self endon( "death" );
	    
	if ( self != level )	
		Assert( self ent_flag_exist( flag ) );
	else
		Assert( flag_exist( flag ) );
		
	if ( !IsDefined( timeout ) )
		set_flag_ai_in_range_of_ent( ai, ent, range, flag );
	else
	{
		elapsed = 0;
		for( ; elapsed <= timeout && IsAlive( ai ) && dsq_ents_gt( ai, ent,range ); elapsed += 0.05 )
			wait 0.05;
		
		if ( elapsed <= timeout )
		{
			if ( self != level )
				self ent_flag_set( flag );
			else
				flag_set( flag );
		}
	}
}

set_flag_ai_in_2d_range_of_ent( ai, ent, range, flag )
{
	Assert( IsDefined( ai ) && IsAI( ai ) );
	Assert( IsDefined( ent ) );
	
	if ( self != level )
	    self endon( "death" );
	    
	if ( self != level )	
		Assert( self ent_flag_exist( flag ) );
	else
		Assert( flag_exist( flag ) );
	
	for ( range = gt_op( range, 0 ); IsAlive( ai ) && dsq_2d_ents_gt( ai, ent, range ); wait 0.05 ){}
		
	if ( self != level )
		self ent_flag_set( flag );
	else
		flag_set( flag );
}

set_flag_ai_in_2d_range_of_ent_timeout( ai, ent, range, flag, timeout )
{
	Assert( IsDefined( ai ) && IsAI( ai ) );
	Assert( IsDefined( ent ) );
	
	range = gt_op( range, 0 );
	
	if ( self != level )
	    self endon( "death" );
	    
	if ( self != level )	
		Assert( self ent_flag_exist( flag ) );
	else
		Assert( flag_exist( flag ) );
		
	if ( !IsDefined( timeout ) )
		set_flag_ai_in_2d_range_of_ent( ai, ent, range, flag );
	else
	{
		for( elapsed = 0; elapsed < timeout && IsAlive( ai ) && dsq_2d_ents_gt( ai, ent, range ); elapsed += 0.05 )
			wait 0.05;
		
		if ( elapsed <= timeout )
		{
			if ( self != level )
				self ent_flag_set( flag );
			else
				flag_set( flag );
		}
	}
}

force_set_flag_ai_in_range_of_ent_timeout( ai, ent, range, flag, timeout )
{
	Assert( IsDefined( ai ) && IsAI( ai ) );
	Assert( IsDefined( ent ) );
	
	range = gt_op( range, 0 );
	
	if ( self != level )
	    self endon( "death" );
	
	if ( self != level )	
		Assert( self ent_flag_exist( flag ) );
	else
		Assert( flag_exist( flag ) );
		
	if ( !IsDefined( timeout ) )
		set_flag_ai_in_range_of_ent( ai, ent, range, flag );
	else
	{
		for( elapsed = 0; elapsed < timeout && IsAlive( ai ) && dsq_ents_gt( ai, ent, range ); elapsed += 0.05 )
			wait 0.05;
		
		if ( self != level )
			self ent_flag_set( flag );
		else
			flag_set( flag );
	}
}

notify_ai_when_in_range_of_ent( ai, ent, range, msg )
{
    Assert( IsDefined( ai ) && IsAI( ai ) );
    Assert( IsDefined( ent ) );
    Assert( IsDefined( msg ) );

	for ( range = gt_op( range, 0 ); IsAlive( ai ) && dsq_ents_gt( ai, ent, range ); wait 0.05 ){}
	
	if ( IsAlive( ai ) )	
        ai notify( msg );
}

notify_ai_when_in_2d_range_of_ent( ai, ent, range, msg )
{
    Assert( IsDefined( ai ) && IsAI( ai ) );
    Assert( IsDefined( ent ) );
    Assert( IsDefined( msg ) );
    
	for ( range = gt_op( range, 0 ); IsAlive( ai ) && dsq_2d_ents_gt( ai, ent, range ); wait 0.05 ){}
	
	if ( IsAlive( ai ) )	
        ai notify( msg );
}

notify_ent1_when_in_2d_range_of_ent2( ent1, ent2, range, msg )
{
    Assert( IsDefined( ent1 ) );
    Assert( IsDefined( ent2 ) );
    Assert( IsDefined( msg ) );
    
	for ( range = gt_op( range, 0 ); dsq_2d_ents_gt( ent1, ent2, range ); wait 0.05 ){}
	
	if ( IsDefined( ent1 ) )	
        ent1 notify( msg );
}

thread_func_ent1_in_2d_range_of_ent2( ent1, ent2, range, func )
{
	Assert( IsDefined( ent1 ) );
	Assert( IsDefined( ent2 ) );
	
	self endon( "death" );
	
	range = gt_op( range, 0 );
	
	waittill_ent1_in_2d_range_of_ent2( ent1, ent2, range );
	self thread [[ func ]]();
}

thread_func_ent1_in_2d_range_of_ent2_timeout( ent1, ent2, range, func, timeout )
{
	Assert( IsDefined( ent1 ) );
	Assert( IsDefined( ent2 ) );
	
	self endon( "death" );
	
	range = gt_op( range, 0 );
	timeout = gt_op( timeout, 0 );
	
	if ( timeout == 0 )
		thread_func_ent1_in_2d_range_of_ent2( ent1, ent2, range, func );
	else
	{
		waittill_ent1_in_2d_range_of_ent2_timeout( ent1, ent2, range, timeout );
		self thread [[ func ]]();
	}
}

waittill_ai_in_range_of_ent( ai, ent, range )
{
	Assert( IsDefined( ai ) && IsAI( ai ) );
	Assert( IsDefined( ent ) );
		
	for ( range = gt_op( range, 0 ); IsAlive( ai ) && dsq_ents_gt( ai, ent, range ); wait 0.05 ){}
}

waittill_ai_in_range_of_ent_timeout( ai, ent, range, timeout )
{
	Assert( IsDefined( ai ) && IsAI( ai ) );
	Assert( IsDefined( ent ) );
	
	range = gt_op( range, 0 );
	
	if ( !IsDefined( timeout ) )
		waittill_ai_in_range_of_ent( ai, ent, range );
	else
		for( elapsed = 0; elapsed < timeout && IsAlive( ai ) && dsq_ents_gt( ai, ent, range ); elapsed += 0.05 )
			wait 0.05;
}

waittill_ent1_in_2d_range_of_ent2( ent1, ent2, range )
{
	Assert( IsDefined( ent1 ) );
	Assert( IsDefined( ent2 ) );
	
	for( range = gt_op( range, 0 ); dsq_2d_ents_gt( ent1, ent2, range ); wait 0.05 ){}
}

waittill_ent1_in_2d_range_of_ent2_timeout( ent1, ent2, range, timeout )
{
	Assert( IsDefined( ent1 ) );
	Assert( IsDefined( ent2 ) );
	
	range = gt_op( range, 0 );
	timeout = gt_op( timeout, 0 );
	
	if ( timeout == 0 )
		waittill_ent1_in_2d_range_of_ent2( ent1, ent2, range );
	else
		for ( elapsed = 0; elapsed < timeout && dsq_2d_ents_gt( ent1, ent2, range ); elapsed += 0.05 )
			wait 0.05;
}

waittill_ent1_in_range_of_ent2( ent1, ent2, range )
{
	Assert( IsDefined( ent1 ) );
	Assert( IsDefined( ent2 ) );
	
	for ( range = gt_op( range, 0 ); dsq_ents_gt( ent1, ent2, range ); wait 0.05 ){}
}

waittill_ent1_in_range_of_ent2_timeout( ent1, ent2, range, timeout )
{
	Assert( IsDefined( ent1 ) );
	Assert( IsDefined( ent2 ) );
	
	range = gt_op( range, 0 );
	
	if ( !IsDefined( timeout ) )
		waittill_ent1_in_range_of_ent2( ent1, ent2, range );
	else
		for( elapsed = 0; elapsed <= timeout && dsq_ents_gt( ent1, ent2, range ); elapsed += 0.05 )
			wait 0.05;
}

waittill_ent_in_2d_range_of_point( ent, point, range, height )
{
    Assert( IsDefined( ent ) );
	Assert( IsDefined( point ) );
	
	for ( range = gt_op( range, 0 ); IsDefined( ent ) && dsq_2d_gt( ent.origin, point, range, height ); wait 0.05 ){}
}

waittill_ent_in_range_of_point( ent, point, range )
{
    Assert( IsDefined( ent ) );
	Assert( IsDefined( point ) );
	
	for ( range = gt_op( range, 0 ); IsDefined( ent ) && dsq_gt( ent.origin, point, range ); wait 0.05 ){}
}

waittill_ent_in_range_of_point_timeout( ent, point, range, timeout )
{
	Assert( IsDefined( ent ) );
	Assert( IsDefined( point ) );
	
	range = gt_op( range, 0 );
	
	if ( !IsDefined( timeout ) )
		waittill_ent_in_range_of_point( ent, point, range );
	else
		for( elapsed = 0; elapsed < timeout && IsDefined( ent ) && dsq_gt( ent.origin, point, range ); elapsed += 0.05 )
			wait 0.05;
			
}

// **TODO Might be useful to have a function based on the percentage of entities
//        meeting a condition ( in this case notifies )

waittill_ents_notified_set_flag( ent_array, msg, flag )
{
    Assert( IsDefined( ent_array ) );
    Assert( IsDefined( msg ) );
    Assert( IsDefined( flag ) );
    
    waittill_ents_notified( ent_array, msg );
    
    if ( flag_exist( flag ) )
        flag_set( flag );
}

waittill_ents_notified_set_flag_timeout( ent_array, msg, flag, timeout )
{
    Assert( IsDefined( ent_array ) );
    Assert( IsDefined( msg ) );
    Assert( IsDefined( flag ) );
    
    if ( !IsDefined( timeout ) )
        waittill_ents_notified_set_flag( ent_array, msg, flag );
    else
        waittill_ents_notified_timeout( ent_array, msg, timeout );
    
    if ( flag_exist( flag ) )
        flag_set( flag );
}

waittill_ents_notified( ent_array, msg )
{
    Assert( IsDefined( ent_array ) );
    Assert( IsDefined( msg ) );
    
    // Setup flags corresponding to the msg
    
    flag = "FLAG_ent_" + msg;
    
    foreach ( ent in ent_array )
    {
        if ( IsDefined( ent ) && IsAlive( ent ) )
        {  
            if ( ent ent_flag_exist( flag ) )
                ent ent_flag_clear( flag );
            else
                ent ent_flag_init( flag );     
            ent thread ent_monitor_notify_flag( msg, flag );
        }
    } 

    // Waittill at all entities have sent out msg ( i.e. corresponding flag is set )
    
    count = 0;
    size = ent_array.size;
    
    while ( count < size )
    { 
        foreach ( ent in ent_array )
        {
            if ( IsDefined( ent ) && 
                 ent ent_flag_exist( flag ) && 
                 ent ent_flag( flag ) )
            {
                count++;
                ent notify( "LISTEN_kill_ent_monitor_" + msg + "_" + flag + "_thread" );
                ent ent_flag_clear( flag );  
            }
            else 
            if ( !IsDefined( ent ) )
            {
            	count++;
            }
        }
        ent_array = array_removedead( ent_array );
        ent_array = array_removeundefined( ent_array );
        wait 0.05;
    }
    
    // Cleanup: clear flags and kill threads
        
    foreach ( ent in ent_array )
    {
        if ( IsDefined( ent ) && IsAlive( ent ) )
        {    
            if ( ent ent_flag_exist( flag ) )
                ent ent_flag_clear( flag );
        	ent notify( "LISTEN_kill_ent_monitor_" + msg + "_" + flag + "_thread" ); 
        }
    } 
}

waittill_ents_notified_timeout( ent_array, msg, timeout )
{
    Assert( IsDefined( ent_array ) );
    Assert( IsDefined( msg ) );
    
    if ( !IsDefined( timeout ) )
        waittill_ents_notified( ent_array, msg );
    else
    {
        // Setup flags corresponding to the msg
        
        flag = "FLAG_ent_" + msg;
    
        foreach ( ent in ent_array )
        {
            if ( IsDefined( ent ) && IsAlive( ent ) )
            {  
                if ( ent ent_flag_exist( flag ) )
                    ent ent_flag_clear( flag );
                else
                    ent ent_flag_init( flag );
                ent thread ent_monitor_notify_flag( msg, flag );
            }
        }
        
        // Waittill timeout or when all ai have sent out msg ( i.e. corresponding flag is set )
        
        count = 0;
        elapsed = 0;
	    size = ent_array.size;
	    
	    while ( count < size && elapsed < timeout )
	    { 
	        foreach ( ent in ent_array )
	        {
	            if ( IsDefined( ent ) && 
	                 ent ent_flag_exist( flag ) && 
	                 ent ent_flag( flag ) )
	            {
	                count++;
	                ent notify( "LISTEN_kill_ent_monitor_" + msg + "_" + flag + "_thread" );
	                ent ent_flag_clear( flag );  
	            }
	            else 
	            if ( !IsDefined( ent ) )
	            {
	            	count++;
	            }
	        }
	        ent_array = array_removedead( ent_array );
	        ent_array = array_removeundefined( ent_array );
	        elapsed += 0.05;
	        wait 0.05;
	    } 
        
        // Cleanup: clear flags and kill threads
        
        foreach ( ent in ent_array )
        {
            if ( IsDefined( ent ) && IsAlive( ent ) )
            {
                if ( ent ent_flag_exist( flag ) )
                    ent ent_flag_clear( flag );
                ent notify( "LISTEN_kill_ent_monitor_" + msg + "_" + flag + "_thread" ); 
            }
        }              
    }
}

waittill_x_ents_notified_set_flag( x, ent_array, msg, flag )
{
    Assert( IsDefined( ent_array ) );
    Assert( IsDefined( msg ) );
    Assert( IsDefined( flag ) );
    
    x = clamp_op( x, 0, ent_array.size, 1 );
    
    waittill_x_ents_notified( x, ent_array, msg );
    
    if ( flag_exist( flag ) )
        flag_set( flag );
}

waittill_x_ents_notified_set_flag_timeout( x, ent_array, msg, flag, timeout )
{
    Assert( IsDefined( ent_array ) );
    Assert( IsDefined( msg ) );
    Assert( IsDefined( flag ) );
    
    x = clamp_op( x, 0, ent_array.size, 1 );
    
    if ( !IsDefined( timeout ) )
        waittill_x_ents_notified_set_flag( x, ent_array, msg, flag );
    else
        waittill_x_ents_notified_timeout( x, ent_array, msg, timeout );
    
    if ( flag_exist( flag ) )
        flag_set( flag );
}

waittill_x_ents_notified( x, ent_array, msg )
{
    Assert( IsDefined( ent_array ) && IsArray ( ent_array ) );
    Assert( IsDefined( msg ) );
    
   	x = clamp_op( x, 0, ent_array.size, 1 );
    
    // Setup flags corresponding to the msg
    
    flag = "FLAG_ent_" + msg;
    
    foreach ( ent in ent_array )
    {
        if ( IsDefined( ent ) && IsAlive( ent ) )
        {  
            if ( ent ent_flag_exist( flag ) )
                ent ent_flag_clear( flag );
            else
                ent ent_flag_init( flag );      
            ent thread ent_monitor_notify_flag( msg, flag );
        }
    } 

    // Waittill at least x entities have sent out msg ( i.e. corresponding flag is set )
    
    count = 0;
    
    while ( count < x )
    { 
        foreach ( ent in ent_array )
        {
            if ( IsDefined( ent ) && 
                 ent ent_flag_exist( flag ) && 
                 ent ent_flag( flag ) )
            {
                count++;
                ent notify( "LISTEN_kill_ent_monitor_" + msg + "_" + flag + "_thread" );
                ent ent_flag_clear( flag );  
            }
            else 
            if ( !IsDefined( ent ) )
            {
            	count++;
            }
        }
        ent_array = array_removedead( ent_array );
        ent_array = array_removeundefined( ent_array );
        wait 0.05;
    }
    
    // Cleanup: clear flags and kill threads
        
    foreach ( ent in ent_array )
    {
        if ( IsDefined( ent ) && IsAlive( ent ) )
        {
            if ( ent ent_flag_exist( flag ) )
                ent ent_flag_clear( flag );
            ent notify( "LISTEN_kill_ent_monitor_" + msg + "_" + flag + "_thread" ); 
        }
    } 
}

waittill_x_ents_notified_timeout( x, ent_array, msg, timeout )
{
    Assert( IsDefined( ent_array ) );
    Assert( IsDefined( msg ) );
    
    x = clamp_op( x, 0, ent_array.size, 1 );
    
    if ( !IsDefined( timeout ) )
        waittill_x_ents_notified( x, ent_array, msg );
    else
    {
        // Setup flags corresponding to the msg
        
        flag = "FLAG_ent_" + msg;
    
        foreach ( ent in ent_array )
        {
            if ( IsDefined( ent ) && IsAlive( ent ) )
            {  
                if ( ent ent_flag_exist( flag ) )
                    ent ent_flag_clear( flag );
                else
                    ent ent_flag_init( flag ); 
                ent thread ent_monitor_notify_flag( msg, flag );
            }
        } 

        // Waittill at least x entities have sent out msg ( i.e. corresponding flag is set )
    
        count = 0;
        elapsed = 0;
        
        while ( count < x || elapsed < timeout )
        { 
            foreach ( ent in ent_array )
	        {
	            if ( IsDefined( ent ) && 
	                 ent ent_flag_exist( flag ) && 
	                 ent ent_flag( flag ) )
	            {
	                count++;
	                ent notify( "LISTEN_kill_ent_monitor_" + msg + "_" + flag + "_thread" );
	                ent ent_flag_clear( flag );  
	            }
	            else 
	            if ( !IsDefined( ent ) )
	            {
	            	count++;
	            }
	        }
           	ent_array = array_removedead( ent_array );
           	ent_array = array_removeundefined( ent_array );
            elapsed += 0.05;
            wait 0.05;
        }
        
        // Cleanup: clear flags and kill threads
        
        foreach ( ent in ent_array )
        {
            if ( IsDefined( ent ) && IsAlive( ent ) )
            {
                if ( ent ent_flag_exist( flag ) )
                    ent ent_flag_clear( flag );
                ent notify( "LISTEN_kill_ent_monitor_" + msg + "_" + flag + "_thread" ); 
            }
        }              
    }
}

ent_monitor_notify_flag( msg, flag )
{
    Assert( IsDefined( msg ) );
    Assert( IsDefined( flag ) );
        
    self endon( "LISTEN_kill_ent_monitor_" + msg + "_" + flag + "_thread" );
        
    self waittill_any( msg, "death" );
    
    if ( IsDefined( self ) && self ent_flag_exist( flag ) )
        self ent_flag_set( flag );
}

waittill_all( msgs )
{
	Assert( IsDefined( msgs ) && IsArray( msgs ) );
	
	struct			= SpawnStruct();
	struct.notified = [];
	
	foreach ( i, msg in msgs )
	{
		struct.notified[ i ] = 0;
		self thread waittill_all_internal( struct, i, msg );
	}
		
	for( all_notified = false; !all_notified; wait 0.05 )
	{
		i = 0;
		for ( ; i < struct.notified.size && struct.notified[ i ]; i++ ){}
		if ( i == struct.notified.size )
			all_notified = true;
	}
}

waittill_all_internal( struct, index, msg )
{
	self waittill_any( msg, "death" );
	struct.notified[ index ] = 1;
}

waittill_thread( msgs, type, func, args )
{
	Assert( IsDefined( msgs ) && IsArray( msgs ) );
	Assert( IsDefined( func ) );
	
	type = ter_op( IsDefined( type ), type, "any" );
	type = ter_op( ToLower( type ) == "any", "any", "and" );
	
	thread waittill_thread_internal( msgs, type, func, args );	
}

waittill_thread_internal( msgs, type, func, args )
{
	notify_death = array_item_exists( msgs, "death" );
		
	if ( !notify_death )
		self endon( "death" );
	
	switch ( type )
	{
		case "all":
			self waittill_all( msgs );
			break;
		case "any":
			self override_waittill_any( msgs );
			break;
	}
	
	if ( !IsDefined( args ) )
		thread [[ func ]]();
	else
		switch( args.size )
		{
			case 0:
				thread [[ func ]]();
				break;
			case 1:
				thread [[ func ]]( args[ 0 ] );
				break;
			case 2:
				thread [[ func ]]( args[ 0 ], args[ 1 ] );
				break;
			case 3:
				thread [[ func ]]( args[ 0 ], args[ 1 ], args[ 2 ] );
				break;
			case 4:
				thread [[ func ]]( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ] );
				break;
			case 5:
				thread [[ func ]]( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ], args[ 4 ] );
				break;
			case 6:
				thread [[ func ]]( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ], args[ 4 ], args[ 5 ] );
				break;
			case 7:
				thread [[ func ]]( args[ 0 ], args[ 1 ], args[ 2 ], args[ 3 ], args[ 4 ], args[ 5 ], args[ 6 ] );
				break;
		}
}

/*
nofities = [ [ notify1, arg11, arg12, arg13, ... , arg1N ],
			   ...
			 [ notifyN, argN1, argN2, argN3, ... , argNM ] ]
*/
/*
waittill_x_ents_notifies_set_flags( x, ent_array, notifies, flags )
{
    Assert( IsDefined( ent_array ) );
    Assert( IsDefined( notifies ) && IsArray( notifies ) && IsDefined( notifies[ 0 ][ 0 ] ) );
    Assert( IsDefined( flags ) && IsArray( flags ) );
    
    x = clamp_op( x, 0, ent_array.size, 1 );
    
    waittill_x_ents_notifies( x, ent_array, notifies );
    
    foreach ( _flag in flags )
    	if ( flag_exist( _flag ) )
        	flag_set( _flag );
}

waittill_x_ents_notifies_set_flags_timeout( x, ent_array, notifies, flags, timeout )
{
    Assert( IsDefined( ent_array ) );
    Assert( IsDefined( notifies ) && IsArray( notifies ) && IsDefined( notifies[ 0 ][ 0 ] ) );
    Assert( IsDefined( flags ) && IsArray( flags ) );
    
    x = clamp_op( x, 0, ent_array.size, 1 );
    
    if ( !IsDefined( timeout ) )
        waittill_x_ents_notifies_set_flags( x, ent_array, notifies, flags );
    else
        waittill_x_ents_notified_timeout( x, ent_array, notifies, timeout );
    
    foreach ( _flag in flags )
    	if ( flag_exist( _flag ) )
        	flag_set( _flag );
}
*/
/*
waittill_x_ents_notifies( x, ent_array, notifies, type )
{
	Assert( IsDefined( ent_array ) && IsArray ( ent_array ) );
    Assert( IsDefined( notifies ) && IsArray( notifies ) );
    
   	x = clamp_op( x, 0, ent_array.size, 1 );
    
    type = ter_op( IsDefined( type ), type, "any" );
	type = ter_op( ToLower( type ) == "any", "any", "and" );
	
}

waittill_x_ents_notifies_internal( struct, notifies, type )
{
	if ( "any" )
	{
		self override_waittill_any( 
	}
	else
	{
		
	}
	self [[ func ]]( notifies );
}
*/
/*
waittill_x_ents_notifies_timeout( x, ent_array, notifies, timeout )
{
	Assert( IsDefined( ent_array ) && IsArray ( ent_array ) );
    Assert( IsDefined( notifies ) && IsArray( notifies ) && IsDefined( notifies[ 0 ][ 0 ] ) );
    
   	x = clamp_op( x, 0, ent_array.size, 1 );
    
    if ( !IsDefined( timeout ) )
        waittill_x_ents_notifies( x, ent_array, notifies );
    else
    {    
	    // Setup flags corresponding to the _notify
	        
	   	timestamp = Int( GetTime() );
	    _flag = "FLAG_ent_" + timestamp + "_" + notifies[ 0 ][ 0 ];
	
	    foreach ( ent in ent_array )
	    {
	        if ( IsDefined( ent ) && IsAlive( ent ) )
	        {  
	            if ( ent ent_flag_exist( _flag ) )
	                ent ent_flag_clear( _flag );
	            else
	                ent ent_flag_init( _flag ); 
	            ent thread waittill_ent_notifies_set_flags( notifies, [ _flag ], timestamp );
	        }
	    }  
	
	    // Waittill at least x entities have sent out _notify ( i.e. corresponding flag is set )
	    
	    count = 0;
	    elapsed = 0;
	    
	    while ( count < x || elapsed < timeout )
	    { 
	        foreach ( ent in ent_array )
	        {
	            if ( IsDefined( ent ) && 
	                 ent ent_flag_exist( _flag ) && 
	                 ent ent_flag( _flag ) )
	            {
	                count++;
	                ent notify( "LISTEN_kill_ent_monitor_" + timestamp + "_" + notifies[ 0 ][ 0 ] + "_" + _flag + "_thread" );
	                ent ent_flag_clear( _flag );  
	            }
	            else 
	            if ( !IsDefined( ent ) )
	            {
	            	count++;
	            }
	        }
	        ent_array = array_removedead( ent_array );
	        ent_array = array_removeundefined( ent_array );
	        elapsed += 0.05;
	        wait 0.05;
	    }
	    
	    // Cleanup: clear flags and kill threads
	        
	    foreach ( ent in ent_array )
	    {
	        if ( IsDefined( ent ) && IsAlive( ent ) )
	        {
	            if ( ent ent_flag_exist( _flag ) )
	                ent ent_flag_clear( _flag );
	            ent notify( "LISTEN_kill_ent_monitor_" + timestamp + "_" + notifies[ 0 ][ 0 ] + "_" + _flag + "_thread" ); 
	        }
	    }
	}
}

waittill_ent_notifies_set_flags( notifies, flags, timestamp )
{
	Assert( IsDefined( notifies ) && IsArray( notifies ) && IsDefined( notifies[ 0 ][ 0 ] ) );
    Assert( IsDefined( flags ) && IsArray ( flags ) && IsDefined( flags[ 0 ] ) );
    Assert( IsDefined( timestamp ) );
    
    self endon( "LISTEN_kill_ent_monitor_" + timestamp + "_" + notifies[ 0 ][ 0 ] + "_" + flags[ 0 ] + "_thread" );
    
    self waittill_any_complex( notifies );
    
    if ( IsDefined( self ) )
    	foreach ( _flag in flags )
    		if ( IsDefined ( _flag ) && self ent_flag_exist( _flag ) )
        		self ent_flag_set( _flag );
}

waittill_any_complex( notifies )
{
	Assert( IsDefined( notifies ) && IsArray( notifies ) );
	
	struct = SpawnStruct();
	
	foreach ( _notify in notifies )
		self thread waittill_complex_internal( struct, _notify );
	struct waittill( "LISTEN_waittill_any_complex_notified" );
}

waittill_complex_internal( struct, _notify )
{
	Assert( IsDefined( _notify ) && IsArray( _notify ) );
	
	switch( _notify.size )
	{
		case 0:
			self waittill( _notify[ 0 ] );
			break;
		case 1:
			self waittill( _notify[ 0 ], arg1 );
			if ( !compare( _notify[ 1 ], arg1 ) )
				return;
			break;
		case 2:
			self waittill( _notify[ 0 ], arg1, arg2 );
			if ( !compare( _notify[ 1 ], arg1 ) || 
				 !compare( _notify[ 2 ], arg2 )	)
				return;
			break;
		case 3:
			self waittill( _notify[ 0 ], arg1, arg2, arg3 );
			if ( !compare( _notify[ 1 ], arg1 ) || 
				 !compare( _notify[ 2 ], arg2 )	|| 
				 !compare( _notify[ 2 ], arg2 ) )
				return;
			break;
	}
	struct notify( "LISTEN_waittill_any_complex_notified" );
}
*/
set_level_flag_on_vehicle_node_notify( value, key, flag )
{
	Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	Assert( IsDefined( flag ) && flag_exist( flag ) );
	
	self endon( "death" );
	
	notifying_ent = getent_or_struct_or_node( value, key ); 
	Assert( IsDefined( notifying_ent ) );
	
	notifying_ent waittill( "trigger", triggerer );
	Assert( self == triggerer );
	
	flag_set( flag );
}

set_flag_on_notify( msg, flag )
{
    Assert( IsDefined( msg ) );
    Assert( IsDefined( flag ) );
    
    if ( self != level )
    {	
        self waittill_any( msg, "death" );
		Assert( self ent_flag_exist( flag ) );
		self ent_flag_set( flag );
	}
	else
	{
	    level waittill( msg );
		Assert( flag_exist( flag ) );
		flag_set( flag );
	}
}

set_flags_on_notifies( msgs, flags )
{
	Assert( IsDefined( msgs ) && IsArray ( msgs ) );
	Assert( IsDefined( flags ) && IsArray( flags ) );
	
	self waittill_all( msgs );
	
	if ( self != level )
    {	
    	foreach ( flag in flags )
    	{
			Assert( self ent_flag_exist( flag ) );
			self ent_flag_set( flag );
		}
	}
	else
	{
		foreach ( flag in flags )
    	{
			Assert( flag_exist( flag ) );
			flag_set( flag );
		}
	}
}

set_flag_ai_in_range( flag, point, team, range )
{
    Assert( IsDefined( flag ) );
    Assert( IsDefined( point ) );
    Assert( IsDefined( team ) );
    
    range = gt_op( range, 0 );
    
    ai_array = get_ai_in_range( team, point, range );
    
    foreach( ai in ai_array )
    {
        if ( ai ent_flag_exist( flag ) )
            ai ent_flag_set( flag );
    }
}

get_ent_array_with_prefix_suffix( prefix, key, del, suffix )
{
	Assert( IsDefined( prefix ) );
	Assert( IsDefined( key ) );
	
	del = gt_op( del, 0 );
	
	if ( !IsDefined( suffix ) )
		return get_ent_array_with_prefix( prefix, key, del );
		
	ent_array = [];
	i = 0;
	
	for ( ; ; )
	{
		ent = getent_or_struct_or_node( prefix + del + suffix, key );
		
		if ( IsDefined( ent ) )
			ent_array[ i ] = ent;
		else
			break;
			
		del++;
		i++;
	}
	return ent_array;
}

get_ent_array_with_prefix_suffix_1_to_1( prefix, key, del, suffix )
{
	Assert( IsDefined( prefix ) );
	Assert( IsDefined( key ) );
	
	del = gt_op( del, 0 );
	
	if ( !IsDefined( suffix ) )
		return get_ent_array_with_prefix_1_to_1( prefix, key, del );
		
	ent_array = [];
	
	for ( ; ; )
	{
		ent = getent_or_struct_or_node( prefix + del + suffix, key );
		
		if ( IsDefined( ent ) )
			ent_array[ del ] = ent;
		else
			break;
		del++;
	}
	return ent_array;
}

get_ent_array_with_prefix_suffix_range( prefix, key, start_del, end_del, suffix )
{
	Assert( IsDefined( prefix ) );
	Assert( IsDefined( key ) );
	
	start_del = gt_op( start_del, 0 );
	end_del = gt_op( end_del, 0 );
	end_del = ter_op( start_del < end_del, end_del, start_del );
	
	if ( !IsDefined( suffix ) )
		return get_ent_array_with_prefix_range( prefix, key, start_del, end_del );
		
	ent_array = [];
	i = 0;
	del = start_del;
	
	while ( i <= ( end_del - start_del ) )
	{
		ent = getent_or_struct_or_node( prefix + del + suffix, key );
		
		if ( IsDefined( ent ) )
			ent_array[ i ] = ent;
		else
			break;
			
		del++;
		i++;
	}
	return ent_array;
}

get_ent_array_with_prefix_suffix_range_1_to_1( prefix, key, start_del, end_del, suffix )
{
	Assert( IsDefined( prefix ) );
	Assert( IsDefined( key ) );
	
	start_del = gt_op( start_del, 0 );
	end_del = gt_op( end_del, start_del );
	
	if ( !IsDefined( suffix ) )
		return get_ent_array_with_prefix_range( prefix, key, start_del, end_del );
		
	ent_array = [];
	del = start_del;
	
	while ( del <= end_del )
	{
		ent = getent_or_struct_or_node( prefix + del + suffix, key );
		
		if ( IsDefined( ent ) )
			ent_array[ del ] = ent;
		else
			break;
		del++;
	}
	return ent_array;
}

get_ent_array_with_prefix( prefix, key, del )
{
	Assert( IsDefined( prefix ) );
	Assert( IsDefined( key ) );
	
	del = gt_op( del, 0 );
		
	ent_array = [];
	i = 0;
	
	for ( ; ; )
	{
		ent = getent_or_struct_or_node( prefix + del, key );
		
		if ( IsDefined( ent ) )
			ent_array[ i ] = ent;
		else
			break;
			
		del++;
		i++;
	}
	return ent_array;
}

get_ent_array_with_prefix_1_to_1( prefix, key, del )
{
	Assert( IsDefined( prefix ) );
	Assert( IsDefined( key ) );
	
	del = gt_op( del, 0 );
		
	ent_array = [];
	
	for ( ; ; )
	{
		ent = getent_or_struct_or_node( prefix + del, key );
		
		if ( IsDefined( ent ) )
			ent_array[ del ] = ent;
		else
			break;
		del++;
	}
	return ent_array;
}

get_ent_array_with_prefix_range( prefix, key, start_del, end_del )
{
	Assert( IsDefined( prefix ) );
	Assert( IsDefined( key ) );
	
	start_del = gt_op( start_del, 0 );
	end_del = gt_op( end_del, start_del );
	
	ent_array = [];
	i = 0;
	del = start_del;
	
	while ( i <= ( end_del - start_del ) )
	{
		ent = getent_or_struct_or_node( prefix + del, key );
		
		if ( IsDefined( ent ) )
			ent_array[ i ] = ent;
		else
			break;
			
		del++;
		i++;
	}
	return ent_array;
}

get_ent_array_with_prefix_range_1_to_1( prefix, key, start_del, end_del )
{
	Assert( IsDefined( prefix ) );
	Assert( IsDefined( key ) );
	
	start_del = gt_op( start_del, 0 );
	end_del = gt_op( end_del, start_del );
	
	ent_array = [];
	i = 0;
	del = start_del;
	
	while ( del <= end_del )
	{
		ent = getent_or_struct_or_node( prefix + del, key );
		
		if ( IsDefined( ent ) )
			ent_array[ del ] = ent;
		else
			break;	
		del++;
	}
	return ent_array;
}

get_ent_array_indexed( value, key )
{
	Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	
	ents = GetEntArray( value, key );

	if ( !IsDefined( ents ) || ents.size == 0 )
		ents = getstructarray( value, key );
	if ( !IsDefined( ents ) || ents.size == 0 )
		return [];
		
	array = [];
	
	foreach ( ent in ents )
	{
		if ( IsDefined( ent.script_index ) )
			array[ ent.script_index ] = ent;
	}
	return array;
}

// Pass in prefix + del as param1 to func
// Pass in key as param2 to func 

array_spawn_function_pass_prefix_del_key( prefix, key, del, func, param1, param2, param3 )
{
	Assert( IsDefined( prefix ) );
	Assert( IsDefined( key ) );
	Assert( IsDefined( func ) );
	
	array = get_ent_array_with_prefix( prefix, key, del );

	if ( !IsDefined( array ) )
		return;
		
	foreach ( spawner in array )
	{
		if ( !IsDefined( spawner ) )
			continue;
			
		prefixx = spawner get_key( key );
		
		if ( !IsDefined( prefixx ) )
			continue;
		spawner thread add_spawn_function( func, prefixx, key, param1, param2, param3 );
	}
}

// Pass in prefix as param1 to func
// Pass in key as param2 to func 

array_spawn_function_pass_prefix_key( prefix, key, del, func, param1, param2, param3 )
{
	Assert( IsDefined( prefix ) );
	Assert( IsDefined( key ) );
	Assert( IsDefined( func ) );
	
	array = get_ent_array_with_prefix( prefix, key, del );

	if ( !IsDefined( array ) )
		return;
		
	foreach ( spawner in array )
	{
		if ( !IsDefined( spawner ) )
			continue;
		spawner thread add_spawn_function( func, prefix, key, param1, param2, param3 );
	}
}

array_spawn_function_prefix( prefix, key, del, func, param1, param2, param3, param4, param5 )
{
	Assert( IsDefined( prefix ) );
	Assert( IsDefined( key ) );
	Assert( IsDefined( func ) );
	
	array = get_ent_array_with_prefix( prefix, key, del );

	if ( !IsDefined( array ) )
		return;
		
	foreach ( spawner in array )
	{
		if ( !IsDefined( spawner ) )
			continue;
		spawner thread add_spawn_function( func, param1, param2, param3, param4, param5 );
	}
}

// Pass in prefix + del + suffix as param1 to func
// Pass in key as param2 to func 

array_spawn_function_pass_prefix_del_suffix_key( prefix, key, del, suffix, func, param1, param2, param3 )
{
	Assert( IsDefined( prefix ) );
	Assert( IsDefined( key ) );
	Assert( IsDefined( suffix ) );
	Assert( IsDefined( func ) );
	
	array = get_ent_array_with_prefix_suffix( prefix, key, del, suffix );

	if ( !IsDefined( array ) )
		return;
		
	foreach ( spawner in array )
	{
		if ( !IsDefined( spawner ) )
			continue;
			
		prefixx = spawner get_key( key );
		
		if ( !IsDefined( prefixx ) )
			continue;
		spawner thread add_spawn_function( func, prefixx, key, param1, param2, param3 );
	}
}

array_spawn_function_prefix_suffix( prefix, key, del, suffix, func, param1, param2, param3, param4, param5 )
{
	Assert( IsDefined( prefix ) );
	Assert( IsDefined( key ) );
	Assert( IsDefined( suffix ) );
	Assert( IsDefined( func ) );
	
	array = get_ent_array_with_prefix_suffix( prefix, key, del, suffix );

	if ( !IsDefined( array ) )
		return;
		
	foreach ( spawner in array )
	{
		if ( !IsDefined( spawner ) )
			continue;		
		spawner thread add_spawn_function( func, param1, param2, param3, param4, param5 );
	}
}

#using_animtree( "generic_human" );
setanimknoball_gh( anime, root, weight, time, rate )
{
	Assert( IsDefined( anime ) );
	Assert( IsDefined( root ) );
	
	_root = %root;
	
	switch ( root )
	{
		case "root":
			break;
		case "body":
			_root = "body";
			break;
		default:
			AssertMsg( "root of " + root + " is not specified for this anim tree" );
	}
	
	weight 	= gt_op( weight, 0 );
	time 	= gt_op( time, 0.05 );
	rate	= gt_op( rate, 0 );
	
	self SetAnimKnobAll( anime, _root, weight, time, rate );
}

#using_animtree( "player" );
setanimknoball_player( anime, root, weight, time, rate )
{
	Assert( IsDefined( anime ) );
	Assert( IsDefined( root ) );
	
	_root = %root;
	
	switch ( root )
	{
		case "root":
			break;
		case "body":
			_root = "body";
			break;
		default:
			AssertMsg( "root of " + root + " is not specified for this anim tree" );
	}
	
	weight 	= gt_op( weight, 0 );
	time 	= gt_op( time, 0.05 );
	rate	= gt_op( rate, 0 );
	
	self SetAnimKnobAll( anime, _root, weight, time, rate );
}

#using_animtree( "player" );
anim_single_freeze_frame_player( ent, time, anime )
{
	Assert( IsDefined( ent ) );
	Assert( IsDefined( anime ) );
	
	time = gt_op( time, 0 );
	
	ent setanimknoball_player( ent getanim( anime ), "root", 1.0, 0, 0 );
	wait 0.05;
	length = GetAnimLength( ent getanim( anime ) );
	ent SetAnimTime( ent getanim( anime ), Clamp( time / length, 0, 1 ) );
}

ai_anim_single_freeze_frame( ai, spawner, time, anime )
{
	Assert( IsDefined( ai ) && IsAI( ai ) );
	Assert( IsDefined( spawner ) && IsSpawner( spawner ) );
	Assert( IsDefined( anime ) );
	
	time = gt_op( time, 0 );
	
	origin 		= ai.origin;
	angles 		= ai.angles;
	animname 	= ai.animname;
	
	ai StopAnimScripted();
	ai notify( "death" );
	ai Delete();
	
	wait 0.05;
	
	spawner.count 			= 1;
	spawner.origin 			= origin;
	spawner.angles 			= angles;
	ai 			= spawner spawn_ai( true );
	wait 0.05;
	ai.animname 	= animname;
	ai.pushable 	= 0;
	ai notify( "killanimscript" );
	ai ClearAnim( ai.root_anim, 0 );
	ai SetAnim( ai getanim( anime ), 1.0, 0, 0 );
	wait 0.05;
	length = GetAnimLength( ai getanim( anime ) );
	ai SetAnimTime( ai getanim( anime ), Clamp( time / length, 0, 1 ) );
}