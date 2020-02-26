#include common_scripts\utility;

init()
{
	thread weaponmarks();
	thread weapontable();

	thread setfog();
	create_dvar( "go", "" );
	thread gowep_detection();
}

gowep_detection()
{
	for ( ;; )
    {
    	gowep = getdvar( "go" );
		if ( gowep != "" )
		{
			goto_wep( gowep );
		}
		wait( 0.05 );
	}		
}

goto_wep( gowep )
{
	setdvar( "go", "" );
	ents = getentarray();
	
	ent = undefined;
	gowep = tolower( gowep );
	foreach ( ent in ents )
	{
		classname = tolower( ent.classname );
		//print( " " + classname );
		if ( issubstr( classname, gowep, classname ) )
		{
			level.player setorigin( ent.origin + (0,0,64 ) );
			return;
		}
	}
	
	println( "^2Couldn't find weapon with substr " + gowep );
}

setfog()
{
	_setfog();

	level.dofDefault[ "nearStart" ] = 0;
	level.dofDefault[ "nearEnd" ] = 0;
	level.dofDefault[ "farStart" ] = 5000;
	level.dofDefault[ "farEnd" ] = 12000;
	level.dofDefault[ "nearBlur" ] = 5.62756;
	level.dofDefault[ "farBlur" ] = 1.15985;

	waittillframeend;
	_setfog();
}

_setfog()
{
	setExpFog( 5000, 6000, 0.627076, 0.611153, 0.5, 1, 0 );
}

//sp different?

//weaponadd( weapon, slot )
//{
//	precacheitem( weapon );
//	weaponobj = spawnstruct();
//	weaponobj.weapon = weapon;
//	slot[ slot.size ] = weaponobj;
//	return slot;
//}

weaponadd( weapon, slot )
{
	truename = weapon;
	if ( isdefined( level.precache_firingrange_weapons ) )
		precacheitem( weapon );
	weapon = "weapon_" + weapon;
	weaponobj = spawnstruct();
	weaponobj.weapon = weapon;
	weaponobj.truename = truename;

	slot[ slot.size ] = weaponobj;
	return slot;
}


weapontable()
{
	weaponslots = [[ level.weaponslotsthread ]]();

	// additional test weapons - dev only
	if ( isdefined( level.additional_weaponlist ) )
	for ( i = 0; i < level.additional_weaponlist.size; i++ )
	{
		weaponslots = weaponadd( level.additional_weaponlist[ i ], weaponslots );
	}

	inc = 0;
	weaponorg = [];
	while ( 1 )
	{
		inc++ ;
		org = getent( "weapontableorg_" + inc, "targetname" );
		if ( !isdefined( org ) )
			break;
		weaponorg[ weaponorg.size ] = org.origin;
	}

	limits[ 0 ] = 23;
	limits[ 1 ] = 23;
	limits[ 2 ] = 23;
	limits[ 3 ] = 23;
	limits[ 4 ] = 23;
	limits[ 5 ] = 23;

	weaponoffset[ 0 ] = ( 15, -39, 0 );
	weaponoffset[ 1 ] = ( -15, -39, 0 );

	weaponsOnTable = 0;
	currentTable = 0;
	offsetIdx = 0;

	for ( i = 0; i < weaponslots.size; i++ )
	{
		if ( WeaponInventoryType( weaponslots[ i ].truename ) != "primary" )
			continue;

		weaponslots[ i ].origin = weaponorg[ currentTable ];
		weaponorg[ currentTable ] += weaponoffset[ offsetIdx ];
		thread weaponspawn( weaponslots[ i ] );
		weaponsOnTable++ ;

		//PrintLn( "Table #" + currentTable + ", " + i + ": " + weaponslots[i].truename );

		if ( offsetIdx == 0 )
			offsetIdx = 1;
		else
			offsetIdx = 0;

		if ( currentTable >= ( weaponorg.size - 1 ) )
			continue;

		if ( weaponsOnTable >= limits[ currentTable ] )
		{
			weaponsOnTable = 0;
			offsetIdx = 0;
			currentTable++ ;
		}
	}

	level.weaponslots = weaponslots;

	thread weaponsprint();

}

weaponsprint()
{
	weaponslots = level.weaponslots;
	weapon = undefined;
	while ( 1 )
	{
		for ( i = 0;i < weaponslots.size;i++ )
		{
				weapon = getentarray( weaponslots[ i ].weapon, "classname" );
				if ( !weapon.size )
					continue;
				for ( j = 0;j < weapon.size;j++ )
					print3d( weapon[ j ].origin, getsubstr( weapon[ j ].classname, 7 ), ( 1, 1, 1 ), 1, .2 );
				weapon = [];
		}
		wait .05;
	}
}


weaponspawn( weaponorg )
{
	spawnedweapon = spawn( weaponorg.weapon, weaponorg.origin );
}



weaponmarks()
{
	array_levelthread( getentarray( "targetwall", "targetname" ), ::weaponmarks_trigger );
}

weaponmarks_trigger( trigger )
{
	trigger setcandamage( true );
	while ( 1 )
	{
		points = [];
		points[ "time" ] = [];
		points[ "origin" ] = [];
		points[ "normal" ] = [];
		counter = 0;
		while ( 1 )
		{
			trigger.health = 1000000;
			thread weaponmarks_triggerdamage( trigger );
			thread weaponmarks_triggertimeout( trigger );
			msg = trigger waittill_any_return( "donedmg", "timeout" );
			if ( isdefined( msg ) && msg == "timeout" )
				break;
			points[ "time" ][ counter ] = trigger.time;
			assert( isdefined( trigger.damage_origin ) );
			points[ "origin" ][ counter ] = trigger.damage_origin;
			points[ "normal" ][ counter ] = trigger.normal;
			counter++ ;
		}
		if ( points[ "time" ].size )
			thread weaponmarks_tracepoints( points );
	}
}

weaponmarks_triggerdamage( trigger )
{
		trigger endon( "donedmg" );
		trigger endon( "timeout" );
		trigger waittill( "damage", amount, who, normal, loc );

		assert( isdefined( loc ) );
		trigger.time = gettime();
		trigger.damage_origin = loc;
		trigger.normal = normal;

		[[ level.targmarks_func ]]( loc, normal );

		trigger notify( "donedmg" );
}

plot_circle_fortime( radius1, time, color, origin, normal, circleres )
{
	if ( !isdefined( color ) )
		color = ( 0, 1, 0 );
	hangtime = .05;
	if ( !isdefined( circleres ) )
		circleres = 6;
	hemires = circleres / 2;
	circleinc = 360 / circleres;
	circleres++ ;
	plotpoints = [];
	rad = 0;

	plotpoints = [];
	rad = 0.000;
	timer = gettime() + ( time * 1000 );
	radius = radius1;

	while ( gettime() < timer )
	{
		dist = distance( level.player.origin, origin );
		angletoplayer = vectortoangles( normal );
		for ( i = 0;i < circleres;i++ )
		{
			plotpoints[ plotpoints.size ] = origin + vector_multiply( anglestoforward( ( angletoplayer + ( rad, 90, 0 ) ) ), radius );
			rad += circleinc;
		}
		plot_points( plotpoints, color[ 0 ], color[ 1 ], color[ 2 ], hangtime );
		plotpoints = [];
		wait hangtime;
	}
}


weaponmarks_triggertimeout( trigger )
{
	trigger endon( "damage" );
	wait 1;
	trigger notify( "timeout" );
}

weaponmarks_tracepoints( points )
{
	count = points[ "time" ].size;
	for ( i = 0;i < count - 1;i++ )
	{
		assert( isdefined( points[ "origin" ][ i ] ) );
		thread draw_line_for_time( points[ "origin" ][ i ], points[ "origin" ][ i + 1 ], 0, i / count, ( count - i ) / count, 3 );
		if ( i!= 0 )
			wait( points[ "time" ][ i ] - points[ "time" ][ i - 1 ] ) / 1000;
	}
}


