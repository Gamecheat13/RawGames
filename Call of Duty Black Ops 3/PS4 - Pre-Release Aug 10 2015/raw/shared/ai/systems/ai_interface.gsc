









function autoexec main()
{
	/#
	level.__ai_debugInterface = GetDvarInt( "ai_debugInterface" );
	#/
}

function private _CheckValue( archetype, attributeName, value )
{
	attribute = level.__ai_interface[ archetype ][ attributeName ];
	
	switch ( attribute[ "type" ] )
	{
	case "_interface_match":
		possibleValues = attribute[ "values" ];

		assert( !IsArray( possibleValues ) || IsInArray( possibleValues, value ),
			"AI: \"" + value + "\" is not one of the allowed values for attribute \"" +
			attributeName + "\"." );
		break;
		
	case "_interface_numeric":
		maxValue = attribute[ "max_value" ];
		minValue = attribute[ "min_value" ];
		
		assert( IsInt( value ) || IsFloat( value ), "AI: Attribute \"" + attributeName +
			"\" requires a numeric value and \"" + value + "\" does not qualify." );
		assert( ( !IsDefined( maxValue ) && !IsDefined( minValue ) ) ||
			( value <= maxValue && value >= minValue ),
			"AI: \"" + value + "\" is outside the allowed range of (" + minValue + "," +
			maxValue + ")." );
		break;
		
	case "_interface_vector":
		if ( IsDefined( value ) )
			assert( IsVec( value ), "AI: Attribute \"" + attributeName +
				"\" requires a vector value and \"" + value + "\" does not qualify." );
		break;
		
	default:
		assert( "AI: Unknown attribute type of \"" + attribute[ "type" ] +
			"\" for attribute \"" + attributeName + "\"." );
		break;
	}
}

function private _CheckPrerequisites( entity, attribute )
{
	assert( IsEntity( entity ), "AI: Must pass an entity to access an attribute." );
	assert( IsActor( entity ) || IsVehicle( entity ), "AI: Must pass an actor or vehicle to access an attribute." );
	assert( IsString( attribute ), "AI: Must pass in a valid attribute name." );
	
	// In depth debugging, only necessary to debug if an AI or the AI Interface system has been setup properly.
	if ( IsDefined( level.__ai_debugInterface ) && level.__ai_debugInterface > 0 )
	{
		assert( IsArray( entity.__interface ),
			"AI: Entity(" + entity.archetype + ")  must create an interface before accessing an " +
			"attribute, see \"ai::CreateInterfaceForEntity\"." );
		assert( IsArray( level.__ai_interface ),
			"AI: No attributes have been registered with the AI interface system yet." );
		assert( IsArray( level.__ai_interface[ entity.archetype ] ),
			"AI: No attributes for archetype \"" + entity.archetype + "\" have been registered." );
		assert( IsArray( level.__ai_interface[ entity.archetype ][ attribute ] ),
			"AI: Attribute \"" + attribute + "\" has not been registered for archetype \"" +
			entity.archetype + "\" yet." );
		assert( IsString( level.__ai_interface[ entity.archetype ][ attribute ][ "type" ] ),
			"AI: Attribute type is undefined for \"" + attribute + "\"." );
	}
}

function private _CheckRegistrationPrerequisites( archetype, attribute, callbackFunction )
{
	assert( IsString( archetype ), "AI: \"archetype\" value is mandatory for registration." );
	assert( IsString( attribute ), "AI: \"attribute\" value is mandatory for registration." );
	assert( !IsDefined( callbackFunction ) || IsFunctionPtr( callbackFunction ),
		"AI: \"callbackFunction\" is optional but must be a function pointer if specified." );
}

function private _InitializeLevelInterface( archetype )
{
	if ( !IsDefined( level.__ai_interface ) )
	{
		level.__ai_interface = [];
	}
	
	if ( !IsDefined( level.__ai_interface[ archetype ] ) )
	{
		level.__ai_interface[ archetype ] = [];
	}
}

#namespace ai;

function CreateInterfaceForEntity( entity )
{
	if ( !IsDefined( entity.__interface ) )
	{
		entity.__interface = [];
	}
}

function GetAiAttribute( entity, attribute )
{
	/#
	ai_interface::_CheckPrerequisites( entity, attribute );
	#/

	if ( !IsDefined( entity.__interface[ attribute ] ) )
	{
		return level.__ai_interface[ entity.archetype ][ attribute ][ "default_value" ];
	}
	
	return entity.__interface[ attribute ];
}

function HasAiAttribute( entity, attribute )
{
	return
		IsDefined( entity ) &&
		IsDefined( attribute ) &&
		IsDefined( entity.archetype ) &&
		IsDefined( level.__ai_interface ) &&
		IsDefined( level.__ai_interface[ entity.archetype ] ) &&
		IsDefined( level.__ai_interface[ entity.archetype ][ attribute ] );
}

function RegisterMatchedInterface( archetype, attribute, defaultValue, possibleValues, callbackFunction )
{
	/#
	ai_interface::_CheckRegistrationPrerequisites( archetype, attribute, callbackFunction );
	assert( !IsDefined( possibleValues ) || IsArray( possibleValues ),
		"AI: \"possibleValues\" is optional but must be an array if specified." );
	#/
	
	ai_interface::_InitializeLevelInterface( archetype );
	
	/#
	assert( !IsDefined( level.__ai_interface[ archetype ][ attribute ] ),
		"AI: \"" + attribute + "\" is already registered for archetype \"" + archetype + "\"" );
	#/
	
	level.__ai_interface[ archetype ][ attribute ] = [];
	level.__ai_interface[ archetype ][ attribute ][ "callback" ] = callbackFunction;
	level.__ai_interface[ archetype ][ attribute ][ "default_value" ] = defaultValue;
	level.__ai_interface[ archetype ][ attribute ][ "type" ] = "_interface_match";
	level.__ai_interface[ archetype ][ attribute ][ "values" ] = possibleValues;
	
	/#
	ai_interface::_CheckValue( archetype, attribute, defaultValue );
	#/
}

function RegisterNumericInterface( archetype, attribute, defaultValue, minimum, maximum, callbackFunction )
{
	/#
	ai_interface::_CheckRegistrationPrerequisites( archetype, attribute, callbackFunction );
	assert( !IsDefined( minimum ) || IsInt( minimum ) || IsFloat( minimum ),
		"AI: \"minimum\" is optional but must be a numeric if specified." );
	assert( !IsDefined( maximum ) || IsInt( maximum ) || IsFloat( maximum ),
		"AI: \"maximum\" is optional but must be a numeric if specified." );
	assert( ( !IsDefined( minimum ) && !IsDefined( maximum ) ) ||
		( IsDefined( minimum ) && IsDefined( maximum ) ),
		"AI: Either both a minimum and maximum must be defined or both undefined, not mixed.");
	assert( ( !IsDefined( minimum ) && !IsDefined( maximum ) ) ||
		( minimum <= maximum ),
		"AI: Attribute \"" + attribute + "\" cannot specify a minimum greater than " +
		"the attribute's maximum");
	#/
	
	ai_interface::_InitializeLevelInterface( archetype );
	
	/#
	assert( !IsDefined( level.__ai_interface[ archetype ][ attribute ] ),
		"AI: \"" + attribute + "\" is already registered for archetype \"" + archetype + "\"" );
	#/
	
	level.__ai_interface[ archetype ][ attribute ] = [];
	level.__ai_interface[ archetype ][ attribute ][ "callback" ] = callbackFunction;
	level.__ai_interface[ archetype ][ attribute ][ "default_value" ] = defaultValue;
	level.__ai_interface[ archetype ][ attribute ][ "max_value" ] = maximum;
	level.__ai_interface[ archetype ][ attribute ][ "min_value" ] = minimum;
	level.__ai_interface[ archetype ][ attribute ][ "type" ] = "_interface_numeric";
	
	/#
	ai_interface::_CheckValue( archetype, attribute, defaultValue );
	#/
}

function RegisterVectorInterface( archetype, attribute, defaultValue, callbackFunction )
{
	/#
	ai_interface::_CheckRegistrationPrerequisites( archetype, attribute, callbackFunction );
	#/
	
	ai_interface::_InitializeLevelInterface( archetype );
	
	/#
	assert( !IsDefined( level.__ai_interface[ archetype ][ attribute ] ),
		"AI: \"" + attribute + "\" is already registered for archetype \"" + archetype + "\"" );
	#/
	
	level.__ai_interface[ archetype ][ attribute ] = [];
	level.__ai_interface[ archetype ][ attribute ][ "callback" ] = callbackFunction;
	level.__ai_interface[ archetype ][ attribute ][ "default_value" ] = defaultValue;
	level.__ai_interface[ archetype ][ attribute ][ "type" ] = "_interface_vector";
	
	/#
	ai_interface::_CheckValue( archetype, attribute, defaultValue );
	#/
}

function SetAiAttribute( entity, attribute, value )
{
	/#
	ai_interface::_CheckPrerequisites( entity, attribute );
	ai_interface::_CheckValue( entity.archetype, attribute, value );
	#/
	
	oldValue = entity.__interface[ attribute ];
	
	if ( !IsDefined( oldValue ) )
	{
		oldValue = level.__ai_interface[ entity.archetype ][ attribute ][ "default_value" ];
	}
	
	entity.__interface[ attribute ] = value;
	
	callback = level.__ai_interface[ entity.archetype ][ attribute ][ "callback" ];
	
	if ( IsFunctionPtr( callback ) )
	{
		[[callback]]( entity, attribute, oldValue, value );
	}
}
