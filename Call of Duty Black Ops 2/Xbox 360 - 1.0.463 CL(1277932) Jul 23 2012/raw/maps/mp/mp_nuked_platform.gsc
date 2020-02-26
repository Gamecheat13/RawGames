#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	level thread nuked_radio_think();
	level.destructible_callbacks[ "headless" ] = ::nuked_mannequin_headless;
}

nuked_radio_think()
{
	radio_trig = GetEnt( "nuketown_radio", "script_noteworthy" );

	if( IsDefined( radio_trig ) )
	{
		radio_trig waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon  );

		if( weapon == "rcbomb_mp" )
		{
//			PrintLn( "music pa play" );
			clientnotify ( "notify_stones" );
		}
	}
}

nuked_mannequin_headless( event, attacker )
{
	if ( level.mannequin_count <= 0 )
	{
		return;
	}

	if ( GetTime() - level.mannequin_time > 15000 )
	{
		return;
	}
	
	level.mannequin_count--;

	if ( level.mannequin_count <= 0 )
	{
		clientnotify ( "notify_stones" );
	}
}
