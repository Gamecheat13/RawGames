#include clientscripts\mp\_utility;

#insert raw\maps\mp\_clientflags.gsh;

#using_animtree ( "mp_vehicles" );

init()
{
	level._client_flag_callbacks[ "scriptmover" ][ CLIENT_FLAG_DESTRUCTIBLE_CAR ] = ::destructible_car_animate;
}

destructible_car_animate( localClientNum, set )
{
	if ( !set )
	{
		return;
	}

	player = GetLocalPlayer( localClientNum );

	if ( !IsDefined( player ) )
	{
		return;
	}

	if ( player GetInKillcam( localClientNum ) )
	{
		return;
	}

	self UseAnimTree( #animtree );
	self SetAnim( %veh_car_destroy, 1.0, 0.0, 1.0 );
}