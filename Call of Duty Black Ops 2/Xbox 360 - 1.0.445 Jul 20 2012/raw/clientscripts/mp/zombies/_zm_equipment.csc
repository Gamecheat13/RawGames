#include clientscripts\mp\_utility;

is_equipment_included( equipment_name )
{
	if ( !IsDefined( level._included_equipment ) )
	{
		return false;
	}

	for ( i = 0; i < level._included_equipment.size; i++ )
	{
		if ( equipment_name == level._included_equipment[i] )
		{
			return true;
		}
	}

	return false;
}


include_equipment( equipment )
{
	if ( !IsDefined( level._included_equipment ) )
	{
		level._included_equipment = [];
	}

	level._included_equipment[level._included_equipment.size] = equipment;
}
