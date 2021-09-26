#include maps\_utility;

Objectives()
{
	precacheString( &"DECOYTRENCHES_OBJ_RENDEZVOUSBREN" );
	precacheString( &"DECOYTRENCHES_OBJ_RENDEZVOUSDEPOT" );
	precacheString( &"DECOYTRENCHES_OBJ_FLAK88" );
	precacheString( &"DECOYTRENCHES_OBJ_HARDPOINTS" );
	precacheString( &"DECOYTRENCHES_OBJ_HARDPOINTSDONE" );
	precacheString( &"DECOYTRENCHES_OBJ_DOCUMENTS" );
	precacheString( &"DECOYTRENCHES_OBJ_DOCUMENTSDONE" );
	precacheString( &"DECOYTRENCHES_OBJ_STOCKPILES" );
	precacheString( &"DECOYTRENCHES_OBJ_STOCKPILESDONE" );
	precacheString( &"DECOYTRENCHES_OBJ_FUELCACHES" );
	precacheString( &"DECOYTRENCHES_OBJ_FUELCACHESDONE" );
	
	curObjective = 1;

	level thread Objective_Emplacements( curObjective );
	objective_additionalcurrent( curObjective );
	curObjective++;

	level thread Objective_Rendezvous( curObjective );
	curObjective++;

	level thread Objective_Stockpiles( curObjective );
	curObjective++;

	level thread Objective_FuelCaches( curObjective );
	curObjective++;
	
	while ( !flag( "objectives completed" ) )
	{
		level waittill_any( "stockpiles destroyed", "fuel caches destroyed" );
		
		if ( !flag( "stockpiles destroyed" ) || !flag( "fuel caches destroyed" ) )
			continue;

		flag_set( "objectives completed" );
	}

	level thread Objective_Documents( curObjective );
	objective_additionalcurrent( curObjective );
	curObjective++;
	flag_wait( "documents recovered" );


	objective_add( curObjective, "active", &"DECOYTRENCHES_OBJ_RENDEZVOUSBREN", (8628,-13510,-297) );
	objective_current( curObjective );
	getEnt( "rally point radius", "targetname" ) waittill ( "trigger" );
	flag_set ( "arrived at BCV" );
	objective_state( curObjective, "done" );
	curObjective++;	
}


Objective_Rendezvous( objectiveIndex )
{
	objective_add( objectiveIndex, "invisible", &"DECOYTRENCHES_OBJ_RENDEZVOUSDEPOT", (8594,-14684,-374) );
	flag_wait( "emplacements cleared" );
	objective_state( objectiveIndex, "active" );
	objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_RENDEZVOUSDEPOT" );
	objective_current( objectiveIndex );
	flag_wait( "depot reached" );
	objective_state( objectiveIndex, "done" );
}


Objective_Flak88( objectiveIndex )
{
	flak88 = getEnt( "flak objective", "targetname" );
	
	objective_add( objectiveIndex, "active", &"DECOYTRENCHES_OBJ_FLAK88", flak88.origin );
	
	while ( true )
	{
		flak88 waittill ( "death" );
		flag_set( "flak88 destroyed" );

		objective_state( objectiveIndex, "done" );
		return;
	}
}


Objective_Emplacements( objectiveIndex  )
{
	emplacementsRemaining = 3;

	objective_add( objectiveIndex, "invisible", &"DECOYTRENCHES_OBJ_HARDPOINTSDONE", (6282,-12724,-146) );
	objective_state( objectiveIndex, "active" );
	objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_HARDPOINTS", emplacementsRemaining );
	level thread Emplacement_Think( 1 );
	level thread Emplacement_Think( 2 );	
	level thread Emplacement_Think( 3 );


	while ( !flag ( "emplacement 1 cleared" ) || !flag( "emplacement 2 cleared" ) || !flag( "emplacement 3 cleared" ) )
	{
		level waittill ( "emplacement cleared" );
		emplacementsRemaining--;
		
		if ( !flag( "emplacement 1 cleared" ) )
		{
			objective_position( objectiveIndex, (6282,-12724,-146) );
			objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_HARDPOINTS", emplacementsRemaining );
		}
		else if ( !flag( "emplacement 2 cleared" ) )
		{
			objective_position( objectiveIndex, (7288,-12306,-112) );
			objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_HARDPOINTS", emplacementsRemaining );
		}
		else if ( !flag( "emplacement 3 cleared" ) )
		{
			objective_position( objectiveIndex, (8906,-12421,-74) );
			objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_HARDPOINTS", emplacementsRemaining );
		}
		else
		{
			objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_HARDPOINTSDONE" );
		}		
	}
	
	flag_set( "emplacements cleared" );

	objective_state( objectiveIndex, "done" );
}


Emplacement_Think( emplacementIndex )
{
	waittill_aigroupcleared( "emplacement" + emplacementIndex );

	flag_set( "emplacement " + emplacementIndex + " cleared" );
	level notify ( "emplacement cleared" );
}


EmplacementOne_Think()
{
	waittill_aigroupcleared( "emplacement1" );

	flag_set( "emplacement 1 cleared" );
	level notify ( "emplacement cleared", 0 );
}


EmplacementTwo_Think()
{
	waittill_aigroupcleared( "emplacement2" );

	flag_set( "emplacement 2 cleared" );
	level notify ( "emplacement cleared", 1 );
}


EmplacementThree_Think()
{
	waittill_aigroupcleared( "emplacement3" );

	flag_set( "emplacement 3 cleared" );
	level notify ( "emplacement cleared", 2 );
}


/*
EmplacementOne_Think()
{
	liveSoldiers = true;
	while ( liveSoldiers )
	{
		entities = getEntArray( "emplacement one ai", "script_noteworthy" );
		
		liveSoldiers = false;
		for ( index = 0; index < entities.size; index++ )
		{
			if ( !isSentient( entities[index] ) )
				continue;
				
			if ( !isAlive( entities[index] ) )
				continue;
				
			liveSoldiers = true;
		}
		wait ( 2.0 );
	}
	wait ( 0.5 );
	flag_set( "emplacement 1 cleared" );
	level notify ( "emplacement cleared", 0 );
}


EmplacementTwo_Think()
{
	flag_wait( "bunker one passed" );

	liveSoldiers = true;
	while ( liveSoldiers )
	{
		entities = getEntArray( "emplacement two ai", "script_noteworthy" );
		
		liveSoldiers = false;
		for ( index = 0; index < entities.size; index++ )
		{
			if ( !isSentient( entities[index] ) )
				continue;
				
			if ( !isAlive( entities[index] ) )
				continue;
				
			liveSoldiers = true;
		}
		wait ( 2.0 );
	}
	wait ( 0.5 );
	flag_set( "emplacement 2 cleared" );
	level notify ( "emplacement cleared", 1 );
}


EmplacementThree_Think()
{
	getEnt( "bunker two reached", "script_noteworthy") waittill ( "trigger" );
	wait ( 1.0 );

	liveSoldiers = true;
	while ( liveSoldiers )
	{
		entities = getEntArray( "bunker two ai", "script_noteworthy" );
		
		liveSoldiers = false;
		for ( index = 0; index < entities.size; index++ )
		{
			if ( !isSentient( entities[index] ) )
				continue;
				
			if ( !isAlive( entities[index] ) )
				continue;
				
			liveSoldiers = true;
		}
		wait ( 2.0 );
	}
	wait ( 0.5 );
	
	flag_set( "emplacement 3 cleared" );
	level notify ( "emplacement cleared", 2 );
}
*/

Objective_Documents( objectiveIndex  )
{
	documents = getEntArray( "documents objective", "script_noteworthy" );

	for ( index = 0; index < documents.size; index++ )
	{
		if ( index == 0 )
		{
			objective_add( objectiveIndex, "invisible", &"DECOYTRENCHES_OBJ_DOCUMENTSDONE", documents[index].origin );
			objective_state( objectiveIndex, "active" );
			objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_DOCUMENTS", documents.size );
		}
		else
		{
			objective_additionalPosition( objectiveIndex, index, documents[index].origin );
		}
			
		documents[index].document = getEnt( documents[index].target, "targetname" );
		documents[index] thread Documents_Think( index );
	}

	level.documentsRemaining = documents.size;
	while ( level.documentsRemaining )
	{
		level waittill ( "document recovered", documentIndex );
		
		objective_additionalPosition( objectiveIndex, documentIndex, (0,0,0) );
		level.documentsRemaining--;

		if ( level.documentsRemaining )
			objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_DOCUMENTS", level.documentsRemaining );
		else
			objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_DOCUMENTSDONE" );
	}

	objective_state( objectiveIndex, "done" );
	flag_set( "documents recovered" );
}


Documents_Think( documentIndex )
{
	self setHintString ( &"SCRIPT_PLATFORM_HINTSTR_DOCUMENTS" );

	self waittill ( "trigger" );

	level.inv_docs = maps\_inventory::inventory_create( "inventory_docs", true );

	level thread playSoundinSpace( "paper_grab", self.document.origin );

	self.document hide();
	
	self triggerOff();
	
	level notify ( "document recovered", documentIndex );
}


Objective_Stockpiles( objectiveIndex )
{
	thread Stockpiles_Show( objectiveIndex );
	stockpiles = getEntArray( "stockpile objective", "targetname" );
	
	level.tnt = stockpiles.size;
	
	for ( index = 0; index < stockpiles.size; index++ )
	{
		if ( index == 0 )
		{
			objective_add( objectiveIndex, "invisible", &"DECOYTRENCHES_OBJ_STOCKPILESDONE", stockpiles[index].origin );
			objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_STOCKPILES", stockpiles.size );
		}
		else
		{
			objective_additionalPosition( objectiveIndex, index, stockpiles[index].origin );
		}
			
		stockpiles[index].bomb = getEnt( stockpiles[index].target, "targetname" );
		stockpiles[index] thread Stockpiles_Think( index );
	}

	level.stockpilesRemaining = stockpiles.size;
	while ( level.stockpilesRemaining )
	{
		level waittill ( "stockpile destroyed", stockpileIndex );
		
		flag_set( "bunker destroyed" );
		
		objective_additionalPosition( objectiveIndex, stockpileIndex, (0,0,0) );
		level.stockpilesRemaining--;
		
		if ( level.stockpilesRemaining )
			objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_STOCKPILES", level.stockpilesRemaining );
		else
			objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_STOCKPILESDONE" );
	}

	objective_state( objectiveIndex, "done" );
	flag_set( "stockpiles destroyed" );
}


Stockpiles_Think( stockpileIndex )
{
	self setHintString( &"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES" );

	self waittill ( "trigger" );

	level.tnt--;
	if (!level.tnt)
		level.inv_tnt maps\_inventory::inventory_destroy();

	self triggerOff();

	self.bomb setModel( "xmodel/military_tntbomb" );
	self.bomb playSound( "explo_plant_no_tick" );
	self.bomb playLoopSound( "bomb_tick" );

	if ( isDefined( level.bombstopwatch ) )
		level.bombstopwatch destroy();

	level.bombstopwatch = maps\_utility::getstopwatch(60);
	level.timersused++;
	wait ( level.explosiveplanttime );
	self.bomb stopLoopSound( "bomb_tick" );
	level.timersused--;
	
	if (level.timersused < 1)
	{
		if (isDefined( level.bombstopwatch ) )
			level.bombstopwatch destroy();
	}

	//BEGIN EXPLOSION
	self.bomb playSound( "explo_metal_rand" );

	//origin, range, max damage, min damage
	radiusDamage( self.bomb.origin, 350, 600, 50 );
	earthquake( 0.25, 3, self.bomb.origin, 1050 );

	parts = getEntArray( "bunker0" + self.script_noteworthy, "script_noteworthy" );
	
	uniqueExploders = [];
	for ( index = 0; index < parts.size; index++ )
	{
		exists = false;
		for (i=0;i<uniqueExploders.size;i++)
		{
			if (parts[index].script_exploder != uniqueExploders[i])
				continue;
			exists = true;
			break;
		}
		if (!exists)
			uniqueExploders[uniqueExploders.size] = parts[index].script_exploder;
	}
	
	for (i=0;i<uniqueExploders.size;i++)
		exploder(uniqueExploders[i]);

	thread maps\_utility::exploder( int( self.script_noteworthy ) );

	trigger = getEnt( "trigger_bunker0" + self.script_noteworthy + "kill", "targetname" );
	
	soldiers = getAIArray();
	for ( index = 0; index < soldiers.size; index++ )
	{
		if ( soldiers[index] isTouching( trigger ) )
			soldiers[index] doDamage( soldiers[index].health, soldiers[index].origin );
	}

	if ( level.player isTouching( trigger ) )
	{
		level.player enableHealthShield( false );
		level.player doDamage ( level.player.health, level.player.origin );
		level.player enableHealthShield( true );
		playFx (level._effect["exp_pack_doorbreach"], level.player.origin);
		setCullFog( 0, 1, 0, 0, 0, 100 );
		return;
	}

	truck = getEnt( "truck0" + self.script_noteworthy , "targetname" );
	if ( isDefined( truck ) )
		radiusDamage( truck.origin, 2, 10000, 10000);

	trigger = getEnt( "trigger_bunker0" + self.script_noteworthy + "shock", "targetname" );

	if ( level.player isTouching( trigger ) )
		maps\_shellshock::main( 5, 1, 1, 1 );

	wait ( 0.5 );
	self.bomb playSound( "decoytrenches_collapse" );
	self.bomb hide();

	level notify ( "stockpile destroyed", stockpileIndex );
}


Stockpiles_Show( objectiveIndex )
{
	flag_wait( "depot reached" );
	objective_state( objectiveIndex, "active" );

	if ( level.stockpilesRemaining )
		objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_STOCKPILES", level.stockpilesRemaining );
	else
		objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_STOCKPILESDONE" );

	objective_additionalcurrent( objectiveIndex );
}


Objective_FuelCaches( objectiveIndex )
{
	thread FuelCaches_Show( objectiveIndex );
	fuelcaches = getEntArray( "fuel cache objective", "targetname" );

	level.fuelcachesRemaining = 0;
	for ( index = 0; index < fuelcaches.size; index++ )
	{
		if ( index == 0 )
		{
			objective_add( objectiveIndex, "invisible", &"DECOYTRENCHES_OBJ_FUELCACHESDONE", fuelcaches[index].origin );
		}
		else
		{
			objective_additionalPosition( objectiveIndex, index, fuelcaches[index].origin );
		}
			
		fuelcaches[index].barrels = getEntArray( fuelcaches[index].target, "targetname" );

		if ( !isDefined( fuelcaches[index].barrels ) )
			continue;
			
		intactBarrel = false;
		for ( barrelIndex = 0; barrelIndex < fuelcaches[index].barrels.size; barrelIndex++ )
		{
			if ( fuelcaches[index].barrels[barrelIndex].health < 0 )
				continue;
				
			intactBarrel = true;
			break;				
		}
		
		if ( !intactBarrel )
			continue;
			
		fuelcaches[index] thread FuelCache_Think( index );
		level.fuelcachesRemaining++;
	}

	objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_FUELCACHES", level.fuelcachesRemaining );

	while ( level.fuelcachesRemaining )
	{
		level waittill ( "fuel cache destroyed", fuelcacheIndex );
		
		objective_additionalPosition( objectiveIndex, fuelcacheIndex, (0,0,0) );
		level.fuelcachesRemaining--;
		
		if ( level.fuelcachesRemaining )
			objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_FUELCACHES", level.fuelcachesRemaining );
		else
			objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_FUELCACHESDONE" );
	}

	flag_wait( "depot reached" );
	wait ( 0.05 );
	objective_state( objectiveIndex, "done" );
	flag_set( "fuel caches destroyed" );
}


FuelCache_Think( fuelcacheIndex )
{
	for ( index = 0; index < self.barrels.size; index++ )
		self.barrels[index] thread Barrel_Think( self );
		
	self.count = self.barrels.size;
	
	while ( self.count )
		self waittill ( "barrel destroyed" );
		
	level notify ( "fuel cache destroyed", fuelcacheIndex );
}


Barrel_Think( fuelcache )
{
	self waittill ( "exploding" );
	fuelcache.count--;
	fuelcache notify ( "barrel destroyed" );
}


FuelCaches_Show( objectiveIndex )
{
	flag_wait( "depot reached" );
	objective_state( objectiveIndex, "active" );
	if ( level.fuelcachesRemaining )
		objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_FUELCACHES", level.fuelcachesRemaining );
	else
		objective_string( objectiveIndex, &"DECOYTRENCHES_OBJ_FUELCACHESDONE" );

	objective_additionalcurrent( objectiveIndex );
}


