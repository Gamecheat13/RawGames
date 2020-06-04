init()
{
	level.collectible_unlocks["collectible_sticksstones"]	= 0;
	level.collectible_unlocks["collectible_vampire"]		= 1;	
	level.collectible_unlocks["collectible_berserker"]		= 2;
	level.collectible_unlocks["collectible_zombie"]			= 3;	
	level.collectible_unlocks["collectible_paintball"]		= 4;
	level.collectible_unlocks["collectible_dirtyharry"]		= 5;
	level.collectible_unlocks["collectible_morphine"]		= 6;	
	level.collectible_unlocks["collectible_thunder"]		= 7;	
	level.collectible_unlocks["collectible_flak_jacket"]	= 8;
	level.collectible_unlocks["collectible_hardcore"]		= 9;
	level.collectible_unlocks["collectible_body_armor"]		= 10;
	level.collectible_unlocks["collectible_hard_headed"]	= 11;
	level.collectible_unlocks["collectible_dead_hands"]		= 12;
	
	clientscripts\_utility::RegisterSystem( "collectibles", ::collectibleHandler );
	
	level thread collectible_vampire_think();
}


collectibleHandler( clientNum, state, oldState )
{
	collectible_value = Int( state );
	
	clientscripts\_utility::splitscreen_populate_dvars( clientNum );
				
	if ( !has_collectible( collectible_value ) )
	{
		give_collectible( clientNum, collectible_value );
	}
	
	if ( GetDvarInt( "cheat_points" ) >= level.collectible_unlocks.size )
	{
		GiveAchievement( clientNum, "ANY_ACHIEVEMENT_GRAVEFULL" );
	}
	
	clientscripts\_utility::splitscreen_restore_dvars();
	
	PlayLocalSound( clientNum, "collectable_pickup_plr" );
}


has_collectible( collectible_value )
{
	found_collectibles = GetDvarInt( "cheat_items_set1" );
	
	return ( ( found_collectibles & (1 << collectible_value) ) != 0 );
}


give_collectible( client_num, collectible_value )
{
	found_collectibles = GetDvarInt( "cheat_items_set1" );
	found_collectibles |= ( 1 << collectible_value );
	
	total_found = GetDvarInt( "cheat_points" );
	
	SetClientDvar( "cheat_items_set1", found_collectibles );
	SetClientDvar( "cheat_points", total_found + 1 );
	
	UpdateGamerProfile( client_num );
}

collectible_vampire_think()
{
	level endon( "vampire_end" );
	level waittill( "vampire_start" );
	
	max_health = GetLocalClientMaxHealth( 0 ); 
	last_health = 0;
	
	health_high		= Int( max_health * .93 );
	health_low		= Int( max_health * .10 );
	health_normal	= Int( max_health * ( 1 / 1.5 ) );
	
	ent = SpawnFakeEnt( 0 );
	
	level thread collectible_vampire_end( ent );

	for ( ;; )
	{
		wait ( 0.05 );
		
		health = GetLocalClientHealth( 0 );
		
		if ( health > last_health )
		{
			VisionSetNaked( 0, "vampire_high", 0.5 );
			StopLoopSound( 0, ent, 1 );
		}
		
		if ( health <= health_low )
		{
			VisionSetNaked( 0, "vampire_low" );
			PlayLoopSound( 0, ent, "vampire_loop", 1 );
		}
		else if ( health >= health_high )
		{
			VisionSetNaked( 0, "vampire_high", 1.5 );
			StopLoopSound( 0, ent, 1 );
		}
		else
		{
			VisionSetNaked( 0, "vampire_low", health - health_low );
			
			playTime = health - health_low; 
			if( 32 < playTime ) //cap it off as playloop takes a max
			{
				playTime = 32;
			}
			
			PlayLoopSound( 0, ent, "vampire_loop", playTime );
		}
		
		last_health = health;
	}
}

collectible_vampire_end( ent )
{
	level waittill( "vampire_end" );

	VisionSetNaked( 0, "vampire_low" );
	StopLoopSound( 0, ent, 0 );
}