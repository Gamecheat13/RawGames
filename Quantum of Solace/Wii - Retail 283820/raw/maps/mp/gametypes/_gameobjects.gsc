#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main(allowed)
{
	entitytypes = getentarray();
	for(i = 0; i < entitytypes.size; i++)
	{
		if(isdefined(entitytypes[i].script_gameobjectname))
		{
			dodelete = true;
			
			
			gameobjectnames = strtok(entitytypes[i].script_gameobjectname, ",");
			
			for(j = 0; j < allowed.size; j++)
			{
				for (k = 0; k < gameobjectnames.size; k++)
				{
					if(gameobjectnames[k] == allowed[j])
					{	
						dodelete = false;
						break;
					}
				}
				if (!dodelete)
					break;
			}
			
			if(dodelete)
			{
				
				entitytypes[i] delete();
			}
		}
	}
}


init()
{
	level.numGametypeReservedObjectives = 0;

	level thread onPlayerConnect();
}


onPlayerConnect()
{
	level endon ( "game_ended" );
	
	for( ;; )
	{
		level waittill( "connecting", player );
		
		player thread onPlayerSpawned();
		player thread onDisconnect();
	}
}



onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );
	
	for(;;)
	{
		self waittill( "spawned_player" );
		
		self thread onDeath();
		self.touchTriggers = [];
		self.carryObject = undefined;
		self.claimTrigger = undefined;
		self.canPickupObject = true;
		self.disabledWeapon = 0;
	}
}



onDeath()
{
	level endon ( "game_ended" );

	self waittill ( "death" );
	if ( isDefined( self.carryObject ) )
		self.carryObject thread setDropped();
}



onDisconnect()
{
	level endon ( "game_ended" );

	self waittill ( "disconnect" );
	if ( isDefined( self.carryObject ) )
		self.carryObject thread setDropped();
}



createCarryObject( ownerTeam, trigger, visuals, teamObjective )
{
	carryObject = spawnStruct();
	carryObject.type = "carryObject";
	carryObject.curOrigin = trigger.origin;
	carryObject.ownerTeam = ownerTeam;
	carryObject.entNum = trigger getEntityNumber();
	
	if ( isSubStr( trigger.classname, "use" ) )
		carryObject.triggerType = "use";
	else
		carryObject.triggerType = "proximity";
		
	
	trigger.baseOrigin = trigger.origin;
	carryObject.trigger = trigger;
	
	
	for ( index = 0; index < visuals.size; index++ )
	{
		visuals[index].baseOrigin = visuals[index].origin;
		visuals[index].baseAngles = visuals[index].angles;
	}
	carryObject.visuals = visuals;
	
	
	carryObject.compassIcons = [];
	carryObject.objIDAllies = getNextObjID();
	carryObject.objIDAxis = getNextObjID();
	level.objIDStart += 2;

	objective_add( carryObject.objIDAllies, "invisible", carryObject.curOrigin );
	objective_add( carryObject.objIDAxis, "invisible", carryObject.curOrigin );

	if ( !isDefined( teamObjective ) || teamObjective == true )
	{
		objective_team( carryObject.objIDAllies, "allies" );
		objective_team( carryObject.objIDAxis, "axis" );
	}

	carryObject.objPoints["allies"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + carryObject.entNum, carryObject.curOrigin, "allies", undefined, 0 );
	carryObject.objPoints["axis"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_axis_" + carryObject.entNum, carryObject.curOrigin, "axis", undefined, 0 );
	
	
	carryObject.carrier = undefined;
	
	
	carryObject.isResetting = false;	
	carryObject.interactTeam = "none"; 
	carryObject.allowWeapons = false;
	
	
	carryObject.worldIcons = [];
	carryObject.carrierVisible = false; 
	carryObject.visibleTeam = "none"; 

	carryObject.carryIcon = undefined;

	
	carryObject.onDrop = undefined;
	carryObject.onPickup = undefined;
	carryObject.onReset = undefined;
	
	if ( carryObject.triggerType == "use" )
		carryObject thread carryObjectUseThink();
	else
		carryObject thread carryObjectProxThink();
		
	carryObject thread updateCarryObjectOrigin();

	return carryObject;
}




carryObjectUseThink()
{
	level endon ( "game_ended" );

	while ( true )
	{
		self.trigger waittill ( "trigger", player );
		
		if ( self.isResetting )
			continue;
		
		if ( !isAlive( player ) )
			continue;
			
		if ( !self canInteractWith( player.pers["team"] ) )
			continue;
		
		if ( !player.canPickupObject )
			continue;
			
		if ( isDefined( player.carryObject ) )
			continue;

		if ( player.throwingGrenade )
			continue;

		if ( player.sessionstate == "spectator" )
			continue;

		if ( isDefined( self.carrier ) )
			return;
			
		self setPickedUp( player );
	}
}



carryObjectProxThink()
{
	level endon ( "game_ended" );

	while ( true )
	{
		self.trigger waittill ( "trigger", player );

		if ( self.isResetting )
			continue;

		if ( !isAlive( player ) )
			continue;

		if ( !self canInteractWith( player.pers["team"] ) )
			continue;
	
		if ( !player.canPickupObject )
			continue;

		if ( isDefined( player.carryObject ) )
			continue;			
	
		if ( player.throwingGrenade )
			continue;
	
		if ( player.sessionstate == "spectator" )
			continue;
	
		if ( isDefined( self.carrier ) )
			return;

		self setPickedUp( player );
	}
}



pickupObjectDelay( origin )
{
	level endon ( "game_ended" );

	self endon("death");
	self endon("disconnect");
	
	self.canPickupObject = false;
	
	for( ;; )
	{
		if ( distanceSquared( self.origin, origin ) > 64*64 )
			break;

		wait 0.2;
	}
	
	self.canPickupObject = true;
}



setPickedUp( player )
{
	player giveObject( self );
	
	self.carrier = player;

	for ( index = 0; index < self.visuals.size; index++ )
		self.visuals[index] hide();
			
	self.trigger.origin += (0,0,10000);

	self notify ( "pickup_object" );
	if ( isDefined( self.onPickup ) )
		self [[self.onPickup]]( player );
		
	self updateCompassIcons();
	self updateWorldIcons();
}


updateCarryObjectOrigin()
{
	level endon ( "game_ended" );
	

	allieObjName = "objpoint_allies_" + self.entNum;
	axisObjName = "objpoint_axis_" + self.entNum;
	
	for ( ;; )
	{
		if ( isDefined( self.carrier ) )
			self.curOrigin = self.carrier.origin + (0,0,75);
		
		self.objPoints["allies"] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin );
		self.objPoints["axis"] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin );

		wait ( 0.05 );
	}
}



giveObject( object )
{
	assert( !isDefined( self.carryObject ) );
	
	self.carryObject = object;
	self thread trackCarrier();
		
	if ( !object.allowWeapons )
	{
		self _disableWeapon();
		self thread manualDropThink();
	}

	if ( isDefined( object.carryIcon ) )
	{
		self.carryIcon = createIcon( object.carryIcon, 75, 75 );

		if ( !object.allowWeapons )
			self.carryIcon setPoint( "CENTER", "CENTER", 0, 60 );
		else
			self.carryIcon setPoint( "CENTER", "CENTER", 150, 50 );
	}
}



returnHome()
{
	self.isResetting = true;

	for ( index = 0; index < self.visuals.size; index++ )
	{
		self.visuals[index].origin = self.visuals[index].baseOrigin;
		self.visuals[index].angles = self.visuals[index].baseAngles;
		self.visuals[index] show();
	}
	self.trigger.origin = self.trigger.baseOrigin;
	
	self.curOrigin = self.trigger.origin;
	
	if ( isDefined( self.onReset ) )
		self [[self.onReset]]();

	if ( isAlive( self.carrier ) )
		self.carrier takeObject( self );

	self.carrier = undefined;
	
	updateWorldIcons();
	updateCompassIcons();
	
	self.isResetting = false;
}



setDropped()
{
	self.isResetting = true;


	if ( isDefined( self.carrier ) )
		trace = bulletTrace( self.carrier.origin + (0,0,20), self.carrier.origin - (0,0,2000), false, self.carrier.body );
	else
		trace = bulletTrace( self.safeOrigin + (0,0,20), self.safeOrigin - (0,0,20), false, undefined );

	if ( trace["fraction"] < 1 )
	{
		tempAngle = randomfloat( 360 );
		forward = (cos( tempAngle ), sin( tempAngle ), 0);
		forward = vectornormalize( forward - vector_scale( trace["normal"], vectordot( forward, trace["normal"] ) ) );
		dropAngles = vectortoangles( forward );

		dropOrigin = trace["position"];
		
		for ( index = 0; index < self.visuals.size; index++ )
		{
			self.visuals[index].origin = dropOrigin;
			self.visuals[index].angles = dropAngles;
			self.visuals[index] show();
		}
		self.trigger.origin = dropOrigin;
		
		self.curOrigin = self.trigger.origin;

		self thread pickupTimeout();
	}
	else
	{
		for ( index = 0; index < self.visuals.size; index++ )
		{
			self.visuals[index].origin = self.visuals[index].baseOrigin;
			self.visuals[index].angles = self.visuals[index].baseAngles;
			self.visuals[index] show();
		}
		self.trigger.origin = self.trigger.baseOrigin;
		
		self.curOrigin = self.trigger.baseOrigin;
	}	
	
	if ( isDefined( self.onDrop ) )
		self [[self.onDrop]]( self.carrier );

	if ( isDefined( self.carrier ) )
		self.carrier takeObject( self );

	self.carrier = undefined;

	self updateCompassIcons();
	self updateWorldIcons();
	self.isResetting = false;
}


pickupTimeout()
{
	self endon ( "pickup_object" );
	
	mineTriggers = getEntArray( "minefield", "targetname" );
	hurtTriggers = getEntArray( "trigger_hurt", "classname" );

	for ( index = 0; index < mineTriggers.size; index++ )
	{
		if ( !self.visuals[0] isTouching( mineTriggers[index] ) )
			continue;

		self returnHome();
		return;
	}

	for ( index = 0; index < hurtTriggers.size; index++ )
	{
		if ( !self.visuals[0] isTouching( hurtTriggers[index] ) )
			continue;

		self returnHome();	
		return;
	}

	
	if ( isDefined( self.pickupTimer ) )
	{
		wait( self.pickupTimer );
		self returnHome();
	}
}


takeObject( object )
{
	if( isDefined(self.carryIcon) )
		self.carryIcon destroyElem();

	if ( !isAlive( self ) )
		return;

	self.carryObject = undefined;
	self notify ( "drop_object" );
	
	if ( object.triggerType == "proximity" )
		self thread pickupObjectDelay( object.trigger.origin );

	if ( !object.allowWeapons )
	{
		self _enableWeapon();
	}
}



trackCarrier()
{
	level endon ( "game_ended" );
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "drop_object" );
	
	while ( isDefined( self.carryObject ) && isAlive( self ) )
	{
		if ( self isOnGround() )
		{
			trace = bulletTrace( self.origin + (0,0,20), self.origin - (0,0,20), false, undefined );
			if ( trace["fraction"] < 1 ) 
				self.carryObject.safeOrigin = trace["position"];
		}
		wait ( 0.05 );
	}
}



manualDropThink()
{
	level endon ( "game_ended" );
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "drop_object" );
	
	for( ;; )
	{
		while ( self attackButtonPressed() || self fragButtonPressed() || self secondaryOffhandButtonPressed() )
			wait .05;
	
		while ( !self attackButtonPressed() && !self fragButtonPressed() && !self secondaryOffhandButtonPressed() )
			wait .05;
	
		if ( isDefined( self.carryObject ) && !self useButtonPressed() )
			self.carryObject thread setDropped();
	}
}



createUseObject( ownerTeam, trigger, visuals, offset )
{
	useObject = spawnStruct();
	useObject.type = "useObject";
	useObject.curOrigin = trigger.origin;
	useObject.ownerTeam = ownerTeam;
	useObject.entNum = trigger getEntityNumber();
	useObject.keyObject = undefined;
	useObject.keyObjects = undefined;
	useObject.flashDrive = false;
	useObject.bomb = false;
	
	if ( isSubStr( trigger.classname, "use" ) )
		useObject.triggerType = "use";
	else
		useObject.triggerType = "proximity";
		
	
	useObject.trigger = trigger;
	
	
	for ( index = 0; index < visuals.size; index++ )
	{
		visuals[index].baseOrigin = visuals[index].origin;
		visuals[index].baseAngles = visuals[index].angles;
	}
	useObject.visuals = visuals;
	
	if ( !isDefined( offset ) )
		offset = (0,0,0);
	
	
	useObject.compassIcons = [];
	useObject.objIDAllies = getNextObjID();
	useObject.objIDAxis = getNextObjID();

	objective_add( useObject.objIDAllies, "invisible", useObject.curOrigin );
	objective_add( useObject.objIDAxis, "invisible", useObject.curOrigin );
	objective_team( useObject.objIDAllies, "allies" );
	objective_team( useObject.objIDAxis, "axis" );

	useObject.objPoints["allies"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + useObject.entNum, useObject.curOrigin + offset, "allies", undefined, 0 );
	useObject.objPoints["axis"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_axis_" + useObject.entNum, useObject.curOrigin + offset, "axis", undefined, 0 );
	
	
	useObject.interactTeam = "none"; 
	
	
	useObject.worldIcons = [];
	useObject.visibleTeam = "none"; 

	
	useObject.onUse = undefined;
	useObject.onCantUse = undefined;

	useObject.useText = "default";
	useObject.useTime = 10000;
	useObject.curProgress = 0;

	if ( useObject.triggerType == "proximity" )
	{
		useObject.numTouching["neutral"] = 0;
		useObject.numTouching["axis"] = 0;
		useObject.numTouching["allies"] = 0;
		useObject.numTouching["none"] = 0;
		useObject.useRate = 0;
		useObject.claimTeam = "none";
		useObject.claimPlayer = undefined;
		useObject.lastClaimTeam = "none";
		useObject.lastClaimTime = 0;
		
		useObject thread useObjectProxThink();
	}
	else
	{
		useObject.useRate = 1;
		useObject thread useObjectUseThink();
	}
	
	return useObject;
}



setKeyObject( object )
{
	self.keyObject = object;
}



setKeyObjects( objects )
{
	self.keyObjects = objects;
}



useObjectUseThink()
{
	level endon ( "game_ended" );
	
	while ( true )
	{
		self.trigger waittill ( "trigger", player );
		
		if ( !isAlive( player ) )
			continue;
			
		if ( !self canInteractWith( player.pers["team"] ) )
			continue;

		if ( isDefined( self.keyObject ) && (!isDefined( player.carryObject ) || player.carryObject != self.keyObject ) )
		{
			if ( isDefined( self.onCantUse ) )
				self [[self.onCantUse]]( player );
			continue;
		}
		
		if ( isDefined( self.keyObjects ) )
		{
			cantUse = true;
			if ( isDefined( player.carryObject ) )
			{
				for ( index = 0; index < self.keyObjects.size; index++ )
				{
					if( self.keyObjects[index] == player.carryObject )
					{
						cantUse = false;
					}
				}
			}
			if( cantUse )
			{
				if ( isDefined( self.onCantUse ) )
					self [[self.onCantUse]]( player );
				continue;
			}
		}

		result = true;
		if ( self.useTime > 0 )
		{
			if( self.flashDrive )
			{
				if( level.gameType == "vs" && isDefined( player.carryObject ) )
				{
					player.carryObject thread setDropped();
					wait 0.05;
				}

				player.preSearchWeapon = player getCurrentWeapon();
				player SwitchToWeapon( "phone_interact_mp" );
			}
			if ( isDefined( self.onBeginUse ) )
				self [[self.onBeginUse]]( player );

			result = self useHoldThink( player );
			
			if ( isDefined( self.onEndUse ) )
				self [[self.onEndUse]]( player, result );	

			if( self.flashDrive )
			{




				if( !isDefined(player.preSearchWeapon) || player.preSearchWeapon == "none" )
					player.preSearchWeapon = player.pers["weapon"];

				player SwitchToWeapon( player.preSearchWeapon );
			}
		}

		if ( !result )
			continue;
		
		if ( isDefined( self.onUse ) )
			self [[self.onUse]]( player );
	}
}









useObjectProxThink()
{
	level endon ( "game_ended" );
	
	self thread proxTriggerThink();
	
	while ( true )
	{
		if ( self.curProgress >= self.useTime )
		{
			self.curProgress = 0;

			if ( isDefined( self.onEndUse ) )
				self [[self.onEndUse]]( self.claimPlayer, true );

			if ( isDefined( self.onUse ) )
				self [[self.onUse]]( self.claimPlayer );

			self setClaimTeam( "none" );
			self.claimPlayer = undefined;
		}
		
		if ( self.claimTeam != "none" )
		{
			if ( !self.numTouching[self.claimTeam] )
			{
				if ( isDefined( self.onEndUse ) )
					self [[self.onEndUse]]( self.claimPlayer, false );
				
				self setClaimTeam( "none" );
				self.claimPlayer = undefined;				
			}
			else
			{
				self.curProgress += (50 * self.useRate);
			}
		}

		wait ( 0.05 );
	}
}



proxTriggerThink()
{
	level endon ( "game_ended" );
	
	entityNumber = self.entNum;
	
	while ( true )
	{
		self.trigger waittill ( "trigger", player );

		if ( self canInteractWith( player.pers["team"] ) && self.claimTeam == "none" )
		{
			setClaimTeam( player.pers["team"] );
			self.claimPlayer = player;
			
			if ( isDefined( self.onBeginUse ) )
				self [[self.onBeginUse]]( self.claimPlayer );
		}
			
		if ( !isDefined( player.touchTriggers[entityNumber] ) )
			player thread triggerTouchThink( self );
	}
}



setClaimTeam( newTeam )
{
	assert( newTeam != self.claimTeam );
	
	if ( self.claimTeam == "none" && getTime() - self.lastClaimTime > 1000 )
		self.curProgress = 0;
	else if ( newTeam != "none" && newTeam != self.lastClaimTeam )
		self.curProgress = 0;

	self.lastClaimTeam = self.claimTeam;
	self.lastClaimTime = getTime();
	self.claimTeam = newTeam;
	
	self updateUseRate();
}



triggerTouchThink( object )
{
	team = self.pers["team"];

	object.numTouching[team]++;
	object updateUseRate();

	self.touchTriggers[object.entNum] = object.trigger;

	while ( isAlive( self ) && self isTouching( object.trigger ) && !level.gameEnded )
	{
		self updateProxBar( object, false );
		wait ( 0.05 );
	}

	
	if ( isDefined( self ) )
	{
		self updateProxBar( object, true );
		self.touchTriggers[object.entNum] = undefined;
	}
	
	if ( level.gameEnded )
		return;

	object.numTouching[team]--;
	object updateUseRate();
}



updateProxBar( object, forceRemove )
{
	if ( forceRemove || !object canInteractWith( self.pers["team"] ) || self.pers["team"] != object.claimTeam )
	{
		if ( isDefined( self.proxBar ) )
			self.proxBar destroyElem();

		if ( isDefined( self.proxBarText ) )
			self.proxBarText destroyElem();
		return;
	}
	
	if ( !isDefined( self.proxBar ) )
	{
		self.proxBar = createPrimaryProgressBar();
		self.proxBar.lastUseRate = -1;
		
		self.proxBarText = createPrimaryProgressBarText();
		self.proxBarText setText( object.useText );
	}
		
	if ( self.proxBar.lastUseRate != object.useRate )
	{
		self.proxBar updateBar( object.curProgress / object.useTime , (1000 / object.useTime) * object.useRate );
		self.proxBar.lastUseRate = object.useRate;
	}
}



updateUseRate()
{
	numClaimants = self.numTouching[self.claimTeam];
	numOther = 0;
	
	if ( self.claimTeam != "axis" )
		numOther += self.numTouching["axis"];
	if ( self.claimTeam != "allies" )
		numOther += self.numTouching["allies"];

	self.useRate = 0;
	
	if ( numClaimants && !numOther )
		self.useRate = numClaimants;
}



useHoldThink( player )
{
	level endon ( "game_ended" );

	player linkTo( self.trigger );
	if( !self.flashDrive && !self.bomb )
	{
		player _disableWeapon();
		player.loopStart = 0;
	}
	else
	{


	}
	player clientClaimTrigger( self.trigger );
	player.claimTrigger = self.trigger;

	self.curProgress = 0;
	self.inUse = true;

	startWeapon = "none";
	if( self.bomb )
		startWeapon = player getCurrentWeapon();

	player thread personalUseBar( self );

	while( isAlive( player )  && player useButtonPressed() && self.curProgress < self.useTime ) 
	{
		self.curProgress += (50 * self.useRate);

		if( ( startWeapon != "none" ) && ( player getCurrentWeapon() != startWeapon ) )
			break;

		if ( self.curProgress >= self.useTime )
		{
			self.inUse = false;
			player clientReleaseTrigger( self.trigger );
			player.claimTrigger = undefined;
			player unlink();
			if( !self.flashDrive && !self.bomb )
			{
				player _enableWeapon();
			}		

			return true;
		}







		wait 0.05;
	}
	if ( isDefined( player ) )
	{
		player unlink();
		if( !self.flashDrive && !self.bomb )
		{
			player _enableWeapon();
		}
		player.claimTrigger = undefined;
	}

	self.inUse = false;
	self.trigger releaseClaimedTrigger();
	return false;
}


personalUseBar( object )
{
	self.useBar = createPrimaryProgressBar();
	self.useBarText = createPrimaryProgressBarText();
	self.useBarText setText( object.useText );

	lastRate = -1;
	while ( isAlive( self ) && object.inUse && !level.gameEnded )
	{
		if ( lastRate != object.useRate )
			self.useBar updateBar( object.curProgress / object.useTime, (1000 / object.useTime) * object.useRate );
			
		lastRate = object.useRate;
		wait ( 0.05 );
	}
	
	self.useBar destroyElem();
	self.useBarText destroyElem();
}



updateTrigger()
{
	if ( self.triggerType != "use" )
		return;
	
	if ( self.interactTeam == "none" )
	{
		self.trigger.origin -= (0,0,50000);
	}	
	else if ( self.interactTeam == "any" )
	{
		self.trigger.origin = self.curOrigin;
		self.trigger setTeamForTrigger( "none" );
	}
	else if ( self.interactTeam == "friendly" )
	{
		self.trigger.origin = self.curOrigin;
		if ( self.ownerTeam == "allies" )
			self.trigger setTeamForTrigger( "allies" );
		else if ( self.ownerTeam == "axis" )
			self.trigger setTeamForTrigger( "axis" );
		else
			self.trigger.origin -= (0,0,50000);
	}
	else if ( self.interactTeam == "enemy" )
	{
		self.trigger.origin = self.curOrigin;
		if ( self.ownerTeam == "allies" )
			self.trigger setTeamForTrigger( "axis" );
		else if ( self.ownerTeam == "axis" )
			self.trigger setTeamForTrigger( "allies" );
		else
			self.trigger setTeamForTrigger( "none" );
	}
}


updateWorldIcons()
{
	if ( self.visibleTeam == "any" )
	{
		updateWorldIcon( "friendly", true );
		updateWorldIcon( "enemy", true );
	}
	else if ( self.visibleTeam == "friendly" )
	{
		updateWorldIcon( "friendly", true );
		updateWorldIcon( "enemy", false );
	}
	else if ( self.visibleTeam == "enemy" )
	{
		updateWorldIcon( "friendly", false );
		updateWorldIcon( "enemy", true );
	}
	else
	{
		updateWorldIcon( "friendly", false );
		updateWorldIcon( "enemy", false );
	}	
}


updateWorldIcon( relativeTeam, showIcon )
{
	if ( !isDefined( self.worldIcons[relativeTeam] ) )
		showIcon = false;
	
	updateTeams = [];
	if ( relativeTeam == "friendly" )
	{
		if ( self isFriendlyTeam( "allies" ) )
			updateTeams[0] = "allies";
		else if ( self isFriendlyTeam( "axis" ) )
			updateTeams[0] = "axis";
	}
	else if ( relativeTeam == "enemy" )
	{
		if ( !self isFriendlyTeam( "allies" ) )
			updateTeams[updateTeams.size] = "allies";

		if ( !self isFriendlyTeam( "axis" ) )
			updateTeams[updateTeams.size] = "axis";
	}
	
	for ( index = 0; index < updateTeams.size; index++ )
	{
		opName = "objpoint_" + updateTeams[index] + "_" + self.entNum;			
		objPoint = maps\mp\gametypes\_objpoints::getObjPointByName( opName );
		
		if ( showIcon )
		{
			objPoint setShader( self.worldIcons[relativeTeam], level.objPointSize, level.objPointSize );
			objPoint.alpha = 1;
			objPoint setWayPoint( true );
		}
		else
		{
			objPoint.alpha = 0;
		}
	}
}


updateCompassIcons()
{
	if ( self.visibleTeam == "any" )
	{
		updateCompassIcon( "friendly", true );
		updateCompassIcon( "enemy", true );
	}
	else if ( self.visibleTeam == "friendly" )
	{
		updateCompassIcon( "friendly", true );
		updateCompassIcon( "enemy", false );
	}
	else if ( self.visibleTeam == "enemy" )
	{
		updateCompassIcon( "friendly", false );
		updateCompassIcon( "enemy", true );
	}
	else
	{
		updateCompassIcon( "friendly", false );
		updateCompassIcon( "enemy", false );
	}
}


updateCompassIcon( relativeTeam, showIcon )
{
	updateIDs = [];
	if ( relativeTeam == "friendly" )
	{
		if ( self isFriendlyTeam( "allies" ) )
			updateIDs[0] = self.objIDAllies;
		else if ( self isFriendlyTeam( "axis" ) )
			updateIDs[0] = self.objIDAxis;
	}
	else if ( relativeTeam == "enemy" )
	{
		if ( !self isFriendlyTeam( "allies" ) )
			updateIDs[updateIDs.size] = self.objIDAllies;
		
		if ( !self isFriendlyTeam( "axis" ) )
			updateIDs[updateIDs.size] = self.objIDAxis;
	}
	
	for ( index = 0; index < updateIDs.size; index++ )
	{
		if ( !isDefined( self.compassIcons[relativeTeam] ) || !showIcon )
		{
			objective_state( updateIDs[index], "invisible" );
			return;
		}
		
		objective_icon( updateIDs[index], self.compassIcons[relativeTeam] );
		objective_state( updateIDs[index], "active" );
		
		if ( self.type == "carryObject" )
		{
			if ( isDefined( self.carrier ) )
				objective_onentity( updateIDs[index], self.carrier );
			else
				objective_position( updateIDs[index], self.curOrigin );
		}
	}
}


setOwnerTeam( team )
{
	self.ownerTeam = team;
	self updateTrigger();	
	self updateCompassIcons();
	self updateWorldIcons();
}

getOwnerTeam()
{
	return self.ownerTeam;
}

setUseTime( time )
{
	self.useTime = int( time * 1000 );
}

setUseText( text )
{
	self.useText = text;
}

setUseHintText( text )
{
	self.trigger setHintString( text );
}

allowCarry( relativeTeam )
{
	self.interactTeam = relativeTeam;
}

allowUse( relativeTeam )
{
	self.interactTeam = relativeTeam;
	updateTrigger();
}

setVisibleTeam( relativeTeam )
{
	self.visibleTeam = relativeTeam;

	if ( !maps\mp\gametypes\_tweakables::getTweakableValue( "hud", "showobjicons" ) )
		self.visibleTeam = "none";

	updateCompassIcons();
	updateWorldIcons();
}

setCarrierVisible( relativeTeam )
{
	self.carrierVisible = relativeTeam;
}

setCanUse( relativeTeam )
{
	self.useTeam = relativeTeam;
}

set2DIcon( relativeTeam, shader )
{
	self.compassIcons[relativeTeam] = shader;
	updateCompassIcons();
}

set3DIcon( relativeTeam, shader )
{
	self.worldIcons[relativeTeam] = shader;
	updateWorldIcons();
}

set3DUseIcon( relativeTeam, shader )
{
	self.worldUseIcons[relativeTeam] = shader;	
}

setCarryIcon( shader )
{
	self.carryIcon = shader;
}

disableObject()
{
	if ( isDefined(self.isDisabled) && self.isDisabled == 1 )
	{
		return;
	}
	self.isDisabled = 1;
	if ( self.type == "carryObject" )
	{
		if ( isDefined( self.carrier ) )
			self.carrier takeObject( self );
			
		for ( index = 0; index < self.visuals.size; index++ )
		{
			self.visuals[index] hide();
		}
	}
		
	self.trigger.origin -= (0,0,50000);
	self.oldVisibleTeam = self.visibleTeam;
	self setVisibleTeam( "none" );
}

enableObject()
{
	if ( !isDefined(self.isDisabled) || self.isDisabled != 1 )
	{
		return;
	}
	self.isDisabled = 0;
	
	if ( self.type == "carryObject" )
	{
		for ( index = 0; index < self.visuals.size; index++ )
		{
			self.visuals[index] hide();
		}
	}
	
	self.trigger.origin += (0,0,50000);
	self setVisibleTeam( self.oldVisibleTeam );
}

getRelativeTeam( team )
{
	if ( team == self.ownerTeam )
		return "friendly";
	else if ( team == self.enemyTeam )
		return "enemy";
	else
		return "neutral";
}


isFriendlyTeam( team )
{
	if ( self.ownerTeam == "any" )
		return true;
	
	if ( self.ownerTeam == team )
		return true;

	return false;
}


canInteractWith( team )
{
	switch( self.interactTeam )
	{
		case "none":
			return false;

		case "any":
			return true;

		case "friendly":
			if ( team == self.ownerTeam )
				return true;
			else
				return false;

		case "enemy":
			if ( team != self.ownerTeam )
				return true;
			else
				return false;

		default:
			assertEx( 0, "invalid interactTeam" );
			return false;
	}
}


isTeam( team )
{
	if ( team == "neutral" )
		return true;
	if ( team == "allies" )
		return true;
	if ( team == "axis" )
		return true;
	if ( team == "any" )
		return true;
	if ( team == "none" )
		return true;
	
	return false;
}

isRelativeTeam( relativeTeam )
{
	if ( relativeTeam == "friendly" )
		return true;
	if ( relativeTeam == "enemy" )
		return true;
	if ( relativeTeam == "any" )
		return true;
	if ( relativeTeam == "none" )
		return true;
	
	return false;
}


_disableWeapon()
{
	self.disabledWeapon++;	
	self disableWeapons();
}

_enableWeapon()
{
	self.disabledWeapon--;
	
	if ( !self.disabledWeapon )
		self enableWeapons();
}


getEnemyTeam( team )
{
	if ( team == "neutral" )
		return "none";
	else if ( team == "allies" )
		return "axis";
	else
		return "allies";
}

getNextObjID()
{
	if ( isDefined( level.numHardpointReservedObjectives ) )
		nextID = level.numHardpointReservedObjectives + level.numGametypeReservedObjectives;
	else
		nextID = level.numGametypeReservedObjectives;
		
	level.numGametypeReservedObjectives++;
	return nextID;
}

getLabel()
{
	label = self.trigger.script_label;
	if ( !isDefined( label ) )
	{
		label = "";
		return label;
	}
	
	if ( label[0] != "_" )
		return ("_" + label);
	
	return label;
}