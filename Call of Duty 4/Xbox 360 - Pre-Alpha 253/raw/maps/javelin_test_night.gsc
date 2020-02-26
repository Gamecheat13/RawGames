#include maps\_utility;


main()
{
	precacheVehicles();

	maps\createart\parabolic_art::main();

	maps\_load::main();
	maps\_javelin::init();

    level.player takeallweapons();
    level.player giveWeapon( "m4_grenadier" );
    level.player giveWeapon( "javelin" );
    level.player switchToWeapon( "javelin" );
	
	VisionSetNaked( "parabolic" );
	
	thread mytargettest();
	thread dropJavelin();
}


dropJavelin()
{
	while(1)
	{
		wait 2.0;

		javelin = getent( "weapon_javelin", "classname" );
		if ( isDefined( javelin ) )
			continue;

		target = getent( "spawn_javelin", "targetname" );
		origin = target getOrigin();
		newJavelin = spawn( "weapon_javelin", origin );
	}
}


precacheVehicles()
{
	maps\_t72::main("vehicle_t72_tank");
}


TargetDeathWait( ent )
{
	ent waittill ( "death" );
	target_remove( ent );
}


SetTestTankTarget( name, attackmode )
{
	OFFSET = ( 0, 0, 20 );
	targ = getent( name, "targetname" );
	target_set( targ, OFFSET );
	target_setAttackMode( targ, attackmode );
	target_setJavelinOnly( targ, true );
	thread TargetDeathWait( targ );
}


SetTestPointTarget( name, attackmode )
{
	targ = getent( name, "targetname" );
	target_set( targ );
	target_setAttackMode( targ, attackmode );
	target_setJavelinOnly( targ, true );
}


mytargettest()
{
	wait( 0.5 );
	
	SetTestTankTarget( "tank1", "top" );
	SetTestTankTarget( "tank2", "top" );
	SetTestTankTarget( "tank3", "direct" );
	
	SetTestPointTarget( "building1", "direct" );
	SetTestPointTarget( "building2", "direct" );
}


