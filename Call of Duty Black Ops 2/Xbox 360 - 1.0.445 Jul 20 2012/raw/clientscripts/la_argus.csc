#include clientscripts\_utility;
#include clientscripts\_argus;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

//autoexec main()
//{
//	register_argus_zone( "off", ::on_argus_notify_off );
//	register_argus_zone( "default", ::on_argus_notify_default );
//	register_argus_zone( "intro", ::on_argus_notify_intro );
//}
//
//autoexec switch_argus_zones()
//{
//	str_zone_notify = "";
//	
//	waitforclient( 0 );
//	
//	if ( IsDefined( level.argus_zones[ "argus_zone:default" ] ) )
//	{
//		level.onArgusNotify = level.argus_zones[ "argus_zone:default" ];
//	}
//	
//	while ( level.argus_zones.size > 0 )
//	{
//		str_zone_notify = waittill_any_array_return( GetArrayKeys( level.argus_zones ) );
//		if ( IsDefined( level.argus_zones[ str_zone_notify ] ) )
//		{
//			level.onArgusNotify = level.argus_zones[ str_zone_notify ];
//		}
//	}
//}

register_argus_zone( str_zone, func_handler )
{
	if ( !IsDefined( level.argus_zones ) )
	{
		level.argus_zones = [];
	}
	
	level.argus_zones[ "argus_zone:" + str_zone ] = func_handler;
}

on_argus_notify_off( n_client, n_argus_id, str_user_tag, str_message )
{
	return false;
}

on_argus_notify_intro( n_client, n_argus_id, str_user_tag, str_message )
{
	switch ( str_message )
	{
	case "buildui":
			
		//construct the ui elem and return it - the system will manage it from that point
		return argus_build_ui( n_client, str_user_tag );
		
	case "create":
		
		switch ( str_user_tag )
		{
			case "harper":
			case "sam":
			case "hillary":
			case "jones":
				
				ArgusSetOffset( n_argus_id, (0, 0, 30) );
		}
		
		break;
		
	case "in":
		break;
		
	case "active":		
		break;
		
	case "out":		
		break;
	}

	return true;
}

on_argus_notify_default( n_client, n_argus_id, str_user_tag, str_message )
{
	switch ( str_message )
	{
	case "buildui":
			
		//construct the ui elem and return it - the system will manage it from that point
		return argus_build_ui( n_client, str_user_tag );
		
	case "create":
		
		switch ( str_user_tag )
		{
			case "harper":
			case "sam":
			case "hillary":
			case "jones":
				
				ArgusSetOffset( n_argus_id, (0, 0, 60) );
		}
		
		break;
		
	case "in":
		
		switch ( str_user_tag )
		{
			case "harper":
			case "sam":
			case "hillary":
			case "jones":
				
				if ( !within_fov( level.localPlayers[n_client] GetEye(), level.localPlayers[n_client] GetPlayerAngles(), ArgusGetOrigin( n_argus_id ), .99 ) )
				{	
					return false;
				}
		}
		
		break;
		
	case "active":
		
		case "harper":
		case "sam":
		case "hillary":
		case "jones":
			
			if ( !within_fov( level.localPlayers[n_client] GetEye(), level.localPlayers[n_client] GetPlayerAngles(), ArgusGetOrigin( n_argus_id ), .99 ) )
			{	
				return false;
			}
				
		break;
		
	case "out":		
		break;
	}

	return true;
}

argus_build_ui( n_client, str_user_tag )
{
	switch ( str_user_tag )
	{
	case "harper":
			
		return argusImageAndText2UI( n_client, "white", &"LA_SHARED_ARGUS_HARPER", &"LA_SHARED_ARGUS_HARPER_INFO" );
		
	case "sam":
		
		return argusImageAndText2UI( n_client, "white", &"LA_SHARED_ARGUS_SAM", &"LA_SHARED_ARGUS_SAM_INFO" );
	
	case "hillary":
	
		return argusImageAndText2UI( n_client, "white", &"LA_SHARED_ARGUS_POTUS", &"LA_SHARED_ARGUS_POTUS_INFO" );
	
	case "jones":
	
		return argusImageAndText2UI( n_client, "white", &"LA_SHARED_ARGUS_JONES", &"LA_SHARED_ARGUS_JONES_INFO" );
	
	}
}
