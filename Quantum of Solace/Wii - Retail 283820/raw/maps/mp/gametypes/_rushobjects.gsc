#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;








init()
{
	level.numGametypeReservedObjectives = 0;
	level thread onPlayerConnect();
	logprint("\n%%% rushobjects::init has been called. %%% \n");
}





onPlayerConnect()
{
	level endon ( "game_ended" );
	
	while (1)
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
	
	self.carryObjects = [];

	while(1)
	{
		self waittill( "spawned_player" );
		
		self thread onDeath();
		self.touchTriggers = [];
		self.claimTrigger = undefined;
		self.canPickupObject = true;
		self.disabledWeapon = 0;
	}
}

onDeath()
{
	level endon ( "game_ended" );

	self waittill ( "death" );

	while (isDefined(self.carryObjects) && self.carryObjects.size) 
	{
		logprint( "\n Number of objects carried " + self.carryObjects.size + "\n" );
		self.carryObjects[0] setDropped(); 
	}
}



onDisconnect()
{
	level endon ( "game_ended" );

	self waittill ( "disconnect" );

	while (isDefined(self.carryObjects) && self.carryObjects.size) 
	{
		logprint( "\n Number of objects carried " + self.carryObjects.size + "\n" );
		self.carryObjects[0] setDropped(); 
	}
}





onDropOut()
{
	if (!isDefined(self)) 
		return;	

	self.droppedout = true;

	if (isDefined(level.currentObjectiveIndex) && level.currentObjectiveIndex == 3) 
	{
		if (isDefined(level.target) && self == level.target)
		{
			level.objectiveDone = true;
			level.target.dead = true;			
			level.target.droppedOutAssasination = true;
			level notify ("objective_done");
			iprintlnbold(&"MP_OBJECTIVE_ABORTED");
		}
	}

	while (isDefined(self.carryObjects) && self.carryObjects.size) 
	{
		logprint( "\n Number of objects carried " + self.carryObjects.size + "\n" );
		self.carryObjects[0] setDropped(); 
	}
		
	
	self setclientdvar("genmsg_enabled",false);
}













newRushCarryObject(ownerTeam, trigger, visuals, shader)
{
	carryObject = spawnStruct();
	carryObject.type = "carryObject";
	if(isDefined(trigger))
		carryObject.curOrigin = trigger.origin;
	carryObject.ownerTeam = ownerTeam;
	carryObject.entNum = trigger getEntityNumber();
	carryObject.firstPickupDone = false;
	carryObject.end = false;


	
	
	if ( isSubStr( trigger.classname, "use" ) )
		carryObject.triggerType = "use";
	else
		carryObject.triggerType = "proximity";

		
	
	if(isDefined(trigger))
	{
		trigger.baseOrigin = trigger.origin;
		carryObject.trigger = trigger;
		carryObject.safeOrigin = trigger.origin;	
	}
	
	
	if(isDefined(visuals))
	{
		for ( index = 0; index < visuals.size; index++ )
		{
			visuals[index].baseOrigin = visuals[index].origin;
			visuals[index].baseAngles = visuals[index].angles;
			visuals[index].origin = trigger.origin;
			visuals[index].angles = trigger.angles; 
			visuals[index] show();
		}
		carryObject.visuals = visuals;
	}
	offset = (0,0,16);
		
	
	carryObject.compassIcons = [];
	carryObject.objIDAllies = getNextObjID();
	carryObject.objIDAxis = getNextObjID();
	carryObject.objIDPingFriendly = true;
	carryObject.objIDPingEnemy = true;

	logprint("\nOBJECTIVE_ADD FOR ALLIES IN CARRY OBJECT CREATION\n");
	objective_add( carryObject.objIDAllies, "active", carryObject.curOrigin +offset);
	logprint("\nOBJECTIVE_ADD FOR AXIS IN CARRY OBJECT CREATION \n");
	objective_add( carryObject.objIDAxis, "active", carryObject.curOrigin+offset);
	
	if(level.teambased)
	{
		objective_team( carryObject.objIDAllies, "allies" );
		objective_team( carryObject.objIDAxis, "axis" );
		carryObject.objPoints["allies"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + carryObject.entNum, carryObject.curOrigin + offset, "allies", shader,1.0,1.0 );
		carryObject.objPoints["axis"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_axis_" + carryObject.entNum, carryObject.curOrigin + offset, "axis", shader,1.0,1.0 );
	}
	else
	{
		objective_team( carryObject.objIDAllies, "none" );
		objective_team( carryObject.objIDAxis, "none" );
		logprint("\nOBJECTIVE_TEAM IN CARRY OBJECT CREATION\n");
		logprint("\n- entNum: " + carryObject.entNum + "\n");
		logprint("\n- objPoint name: " + "objpoint_allies_" + carryObject.entNum + "\n");
		logprint("\n- objPoint name: " + "objpoint_axis_" + carryObject.entNum + "\n");
		carryObject.objPoints["allies"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + carryObject.entNum, carryObject.curOrigin + offset, "all", shader,1.0,1.0 );
		carryObject.objPoints["axis"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_axis_" + carryObject.entNum, carryObject.curOrigin + offset, "all", shader,1.0,1.0 );
	}

	carryObject.objPoints["allies"].alpha = 1.0;
	carryObject.objPoints["axis"].alpha = 1.0;
	
	
	carryObject.carrier = undefined;
	
	
	carryObject.isResetting = false;	
	carryObject.interactTeam = "none"; 
	
	
	carryObject.worldIcons = [];
	carryObject.carrierVisible = false; 
	carryObject.visibleTeam = "none"; 
	
	carryObject.carryIcon = undefined;

	
	carryObject.onDrop = undefined;
	carryObject.onEndDrop = undefined;
	carryObject.onPickup = undefined;
	carryObject.onReset = undefined;
	
	if(isDefined(trigger))
	{
		carryObject thread carryObjectProxThink();
	}
	carryObject thread updateCarryObjectOrigin();
	return carryObject;
}








newRushUseObject(ownerTeam, trigger, hint_string,cursor_hint, shader)
{
	useObject = spawnStruct();
	useObject.type = "useObject";
	useObject.ownerTeam = ownerTeam;
	useObject.entNum = trigger getEntityNumber();
	useObject.resetOnEndUse = false;	
	useObject.safeOrigin = trigger.origin;
	useObject.end = false;
	useObject.hint_string = hint_string;
	useObject.cursor_hint = cursor_hint;
	
	
	useObject.trigger = trigger;
	useObject.trigger UseTriggerRequireLookAt(true);

	if ( isSubStr( trigger.classname, "use" ) )
		useObject.triggerType = "use";
	else
		useObject.triggerType = "proximity";
	
	useObject.visuals = getEnt(useObject.trigger.target,"targetname");
	useObject.visuals show();
	useObject.curOrigin = useObject.visuals.origin;
	
	offset = (0,0,16);
	
	
	useObject.compassIcons = [];
	useObject.objIDAllies = getNextObjID();
	useObject.objIDAxis = getNextObjID();
	useObject.objIDPingFriendly = true;
	useObject.objIDPingEnemy = true;

	logprint("\nOBJECTIVE_ADD IN ALLIES USE OBJECT CREATION\n");
	objective_add( useObject.objIDAllies, "active", useObject.curOrigin+offset);
	logprint("\nOBJECTIVE_ADD IN AXIS USE OBJECT CREATION\n");
	objective_add( useObject.objIDAxis, "active", useObject.curOrigin+offset);
	
	if (level.teambased)
	{
		objective_team( useObject.objIDAllies, "allies" );
		objective_team( useObject.objIDAxis, "axis" );
		useObject.objPoints["allies"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + useObject.entNum, useObject.curOrigin + offset, "allies", shader,1.0,1.0  );
		useObject.objPoints["axis"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_axis_" + useObject.entNum, useObject.curOrigin + offset, "axis",  shader,1.0,1.0 );
		
	}
	else
	{
		logprint("\nOBJECTIVE_TEAM IN USE OBJECT CREATION\n");
		objective_team( useObject.objIDAllies, "none" );
		objective_team( useObject.objIDAxis, "none" );
		useObject.objPoints["allies"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + useObject.entNum, useObject.curOrigin + offset, "all", shader,1.0,1.0  );
		useObject.objPoints["axis"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_axis_" + useObject.entNum, useObject.curOrigin + offset, "all",  shader,1.0,1.0 );
	}

	useObject.objPoints["allies"].alpha = 1.0;
	useObject.objPoints["axis"].alpha = 1.0;
	
	
	useObject.interactTeam = "none"; 
	
	
	useObject.worldIcons = [];
	useObject.visibleTeam = "none"; 

		
	
	useObject.onUse = undefined;
	useObject.onCantUse = undefined;

	useObject.useText = "";
	useObject.useTime = 10000;	
	useObject.curProgress = 0;

	useObject.useRate = 1;

	useObject thread useObjectUseThink();

	return useObject;
}





newRushZoneObject(ownerTeam,trigger,visuals, shader)
{
	zone = spawnStruct();
	zone.visuals = visuals;
	zone.trigger = trigger;
	zone.type = "zoneObject";
	zone.entNum = trigger getEntityNumber();
	zone.safeOrigin = trigger.origin;
	zone.ownerTeam = ownerTeam;

	
	zone.compassIcons = [];
	zone.objIDAllies = getNextObjID();
	zone.objIDAxis = getNextObjID();

	offset = (0,0,16);
	
	objective_add( zone.objIDAllies, "active", zone.safeOrigin+offset );
	objective_add( zone.objIDAxis, "active", zone.safeOrigin+offset );
	
	
	
	
	zone.worldIcons = [];
	zone.visibleTeam = "none"; 
	
	if (level.teambased)
	{
		objective_team( zone.objIDAllies, "allies" );
		objective_team( zone.objIDAxis, "axis" );
		zone.objPoints["allies"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + zone.entNum, zone.safeOrigin + offset, "allies", shader,1.0,1.0 );
		zone.objPoints["axis"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_axis_" + zone.entNum, zone.safeOrigin + offset, "axis", shader,1.0,1.0 );
	}
	else
	{
		objective_team( zone.objIDAllies, "none" );
		objective_team( zone.objIDAxis, "none" );
		zone.objPoints["allies"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + zone.entNum, zone.safeOrigin + offset, "all", shader,1.0,1.0 );
		zone.objPoints["axis"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_axis_" + zone.entNum, zone.safeOrigin + offset, "all", shader,1.0,1.0 );
	}


	
	zone.objPoints["allies"].alpha = 1.0;
	zone.objPoints["axis"].alpha = 1.0;

	zone.onEnter = undefined;

	return zone;
}





zoneObjectThink()
{
	level endon("game_ended");
	self endon ("deactivate");

	while (1)
	{
		self.trigger waittill("trigger",player);
		if (isDefined(self.onEnter))
			[[self.onEnter]](player);
	}
}






enableZone()
{
	for ( index = 0; index < self.visuals.size; index++ )
	{
		self.visuals[index].origin = self.trigger.origin;
		self.visuals[index].angles = self.trigger.angles;
		self.visuals[index] show();
	}

	
	
	
	

	self thread zoneObjectThink();
	
}








disableZone()
{
	for ( index = 0; index < self.visuals.size; index++ )
	{
		self.visuals[index].origin = self.trigger.origin;
		self.visuals[index].angles = self.trigger.angles;
		self.visuals[index] hide();
	}
	
	self notify ("deactivate");
	self setVisibleTeam( "none" );
}






updateCarryObjectOrigin()
{
	level endon ( "game_ended" );
	level endon ( "objective_done" );
	
	objPingDelay = 5.0;
	while (1)
	{
		
		
		if ( isDefined( self.carrier ) )
		{
			self.curOrigin = self.carrier.origin + (0,0,75);
			self.objPoints["allies"] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin );
			self.objPoints["axis"] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin );

			if ( (self.visibleTeam == "friendly" || self.visibleTeam == "any") && self isFriendlyTeam( "allies" ) && self.objIDPingFriendly )
			{
				if ( self.objPoints["allies"].isShown )
				{
					self.objPoints["allies"].alpha = self.objPoints["allies"].baseAlpha;
					self.objPoints["allies"] fadeOverTime( objPingDelay + 1.0 );
					self.objPoints["allies"].alpha = 0;
				}
				objective_position( self.objIDAllies, self.curOrigin );
			}
			else if ( (self.visibleTeam == "friendly" || self.visibleTeam == "any") && self isFriendlyTeam( "axis" ) && self.objIDPingFriendly )
			{
				if ( self.objPoints["axis"].isShown )
				{
					self.objPoints["axis"].alpha = self.objPoints["axis"].baseAlpha;
					self.objPoints["axis"] fadeOverTime( objPingDelay + 1.0 );
					self.objPoints["axis"].alpha = 0;
				}
				objective_position( self.objIDAxis, self.curOrigin );
			}

			if ( (self.visibleTeam == "enemy" || self.visibleTeam == "any") && !self isFriendlyTeam( "allies" ) && self.objIDPingEnemy )
			{
				if ( self.objPoints["allies"].isShown )
				{
					self.objPoints["allies"].alpha = self.objPoints["allies"].baseAlpha;
					self.objPoints["allies"] fadeOverTime( objPingDelay + 1.0 );
					self.objPoints["allies"].alpha = 0;
				}
				objective_position( self.objIDAllies, self.curOrigin );
			}
			else if ( (self.visibleTeam == "enemy" || self.visibleTeam == "any") && !self isFriendlyTeam( "axis" ) && self.objIDPingEnemy )
			{
				if ( self.objPoints["axis"].isShown )
				{
					self.objPoints["axis"].alpha = self.objPoints["axis"].baseAlpha;
					self.objPoints["axis"] fadeOverTime( objPingDelay + 1.0 );
					self.objPoints["axis"].alpha = 0;
				}
				objective_position( self.objIDAxis, self.curOrigin );
			}

			
		}
		else
		{

			offset = (0,0,16);
			self.offset3d = offset;
			self.objPoints["allies"] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin + self.offset3d );
			self.objPoints["axis"] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin + self.offset3d );

			
		}
		wait ( 0.05 );
		
	}
}








carryObjectProxThink()
{
	level endon ( "game_ended" );
	level endon ( "objective_done" );
	while (1)
	{
		self.trigger waittill ( "trigger", player );

		if ( self.isResetting )
			continue;
		if ( !isAlive( player ) )
			continue;
		if ( !self maps\mp\gametypes\_gameobjects::canInteractWith( player.pers["team"] ) )
			continue;
		if ( !player.canPickupObject )
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





setVisibleTeam( relativeTeam )
{
	
	self.visibleTeam = relativeTeam;

	
	
		
	updateCompassIcons();
	updateWorldIcons();
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
	
	self setOwnerTeam(self.carrier.pers["team"]);
	
	self updateCompassIcons();
	self updateWorldIcons();
	
	
}


enableHints()
{
	self setUseHintText(self.hint_string);
	self setUseHint(self.cursor_hint);
}

disableHints()
{
	self setUseHintText("");
	self setUseHint("HINT_NOICON");
}




setUseHintText(hint_string)
{
	self.trigger setHintString(hint_string);
}

setUseHint(cursor_hint)
{
	self.trigger setCursorHint(cursor_hint);
}








dropOnGround()
{
	trace = bulletTrace( self.safeOrigin + (0,0,20), self.safeOrigin - (0,0,2000), false, undefined );
	dropOrigin = trace["position"];
	
	for ( index = 0; index < self.visuals.size; index++ )
	{
		self.visuals[index].origin = dropOrigin;
		self.visuals[index] show();
	}
	self.trigger.origin = dropOrigin;
	self.curOrigin = self.trigger.origin;
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
			if (!level.objectiveCompleted)
				self.visuals[index] show();
			else 
				self.visuals[index] hide();		
		}
		self.trigger.origin = dropOrigin;
		
		self.curOrigin = self.trigger.origin;
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

	
	if ( isDefined( self.onDrop ))
		self [[self.onDrop]]( self.carrier );

	if ( isDefined( self.carrier ) )
		self.carrier takeObject( self );

	if (isDefined(self.onEndDrop))
		self [[self.onEndDrop]](self.carrier);
	self setOwnerTeam("any");

	self updateCompassIcons();
	self updateWorldIcons();

	self.carrier = undefined;
	self.isResetting = false;
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
	self.isResetting = false;
	
	
	
}








giveObject( object )
{
	self.carryObjects[self.carryObjects.size] = object;
	self thread trackCarrier();
		
	if ( isDefined( object.carryIcon ) )
	{
		self.carryIcon = createIcon( object.carryIcon, 75, 75 );
		self.carryIcon setPoint( "CENTER", "CENTER", 150, 50 );
	}
	
	object updateCompassIcons();
	object updateWorldIcons();
}








trackCarrier()
{
	level endon ( "game_ended" );
	level endon ( "objective_done" );
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "drop_object" );
	
	while ( self.carryObjects.size && isAlive( self ) )
	{
		if ( self isOnGround() )
		{
			trace = bulletTrace( self.origin + (0,0,20), self.origin - (0,0,20), false, undefined );
			if ( trace["fraction"] < 1 ) 
			{
				for (i = 0 ; i < self.carryObjects.size ; i++)
				{
					self.carryObjects[i].safeOrigin = trace["position"];
				}
			}
		}
		wait ( 0.05 );
	}
}








takeObject( object )
{
	if( isDefined(self.carryIcon) )
		self.carryIcon destroyElem();

	
	

	
	pos = 0;
	while (pos < self.carryObjects.size && self.carryObjects[pos] != object)  
	{ 
		pos++; 
	}
	
	if (pos == self.carryObjects.size - 1) 
	{
		self.carryObjects[pos] = undefined;
	}
	else
	{
		for (i = pos+1 ; i < self.carryObjects.size && isDefined(self.carryObjects[i]) ; i++)
		{
			self.carryObjects[i-1] = self.carryObjects[i];
		}
		self.carryObjects[self.carryObjects.size - 1] = undefined;
	}
	
	if (!isDefined(self.carryObjects)) 
		self.carryObjects = [];
		
	self notify ( "drop_object" );
	
	if ( object.triggerType == "proximity" )
		self thread pickupObjectDelay( object.trigger.origin );
}






pickupObjectDelay( origin )
{
	level endon ( "game_ended" );
	level endon ( "objective_done" );

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








checkTrigger()
{
	level waittill ("objective_done");
	self.checkForUse = false;
}





useObjectUseThink()
{
	level endon ( "game_ended" );
	
	
	self.checkForUse = true;

	self thread checkTrigger();

	while (self.checkForUse)
	{
		
		
		self.trigger waittill ( "trigger", player );		
		
		if ( !isAlive( player ) || isDefined(self.trigger.claimed))
			continue;
			
		if ( !self maps\mp\gametypes\_gameobjects::canInteractWith( player.pers["team"] ) )
			continue;

		result = false;

		if ( self.useTime > 0 )
		{
			if ( isDefined( self.onBeginUse ) )
				self [[self.onBeginUse]]( player );
		
			if (self.resetOnEndUse)
				self.curProgress = 0;		

			self.inUse = true;

			player linkTo( self.trigger );
			
			
			
			player disableweapons();

			player clientClaimTrigger( self.trigger );
			player.claimTrigger = self.trigger;
			self.trigger.claimed = true;

			
			for (i = 0 ; i < level.players.size; i++)
				level.players[i] thread personalUseBar( self );

			while( isAlive( player ) && player useButtonPressed() && self.curProgress < self.useTime && !level.objectiveDone) 
			{
				self.curProgress += (50 * self.useRate);

				if ( self.curProgress >= self.useTime )
					result = true;

				wait 0.05;
			}

			
			self.inUse = false;

			if ( isDefined( self.onEndUse ) )
				self [[self.onEndUse]]( player, result );	

			player clientReleaseTrigger( self.trigger );
			player.claimTrigger = undefined;
			player unlink();

			
			player enableweapons();

			self.trigger releaseClaimedTrigger();
			self.trigger.claimed = undefined;
		}
	}
}







personalUseBar( object )
{
	self.useBar = createPrimaryProgressBar((0,0.50,1),14);	

	if (object.useText != "")
	{
		self.useBarText = createPrimaryProgressBarText();
		self.useBarText setText( object.useText );
	}

	lastRate = -1;
	while (object.inUse && isalive(self) )
	{
		if ( lastRate != object.useRate )
			self.useBar updateBar( object.curProgress / object.useTime, (1000 / object.useTime) * object.useRate );
			
		lastRate = object.useRate;
		wait ( 0.05 );
	}

	
	self.useBar destroyElem();

	if (isDefined(self.useBarText))
		self.useBarText destroyElem();
}





syncBar(syncTime)
{
	self.syncBar = createPrimaryProgressBar((0,0.50,1),14);
	
	

	lastProgress = -1;
	while (isDefined(self.inSync) && self.inSync)
	{
		if (self.signalProgress != lastProgress)
			self.syncBar updateBar(self.signalProgress / syncTime, 1000/syncTime);
		lastProgress = self.signalProgress;
		wait (0.10);
	}

	self.syncBar destroyElem();
	
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
	updateTeams = getUpdateTeams( relativeTeam );
	
	for ( index = 0; index < updateTeams.size; index++ )
	{
		showIconThisTeam = showIcon;
		
		objId = self.objIDAllies;
		if ( updateTeams[ index ] == "axis" )
			objId = self.objIDAxis;
		
		if ( !isDefined( self.compassIcons[relativeTeam] ) || !showIconThisTeam )
		{
			objective_state( objId, "invisible" );
			continue;
		}
		
		objective_icon( objId, self.compassIcons[relativeTeam] );

		objective_state( objId, "active" );

		
		if ( self.type == "carryObject" )
		{
			if ( isAlive( self.carrier ) && !shouldPingObject( relativeTeam ) )
			{
				
				objective_onentity( objId, self.carrier );
			}
			else
			{
				
				objective_position( objId, self.curOrigin );
			}
		}
		
		if(self.type == "playerTarget")
			objective_onentity( objId, self );
	}
}



set2DIcon( relativeTeam, shader )
{
	
	self.compassIcons[relativeTeam] = shader;
	self updateCompassIcons();
}



set3DIcon( relativeTeam, shader )
{
	
	self.worldIcons[relativeTeam] = shader;
	self updateWorldIcons();
}


setCarryIcon( shader )
{
	self.carryIcon = shader;
}


allowCarry( relativeTeam )
{
	self.interactTeam = relativeTeam;
}

allowUse( relativeTeam )
{
	self.interactTeam = relativeTeam;
	maps\mp\gametypes\_gameobjects::updateTrigger();
}


isFriendlyTeam( team )
{
	
	if ( self.ownerTeam == "any" )
		return true;
	
	if ( self.ownerTeam == team )
		return true;

	return false;
}



getNextObjID()
{
	nextID = level.numGametypeReservedObjectives;
		
	level.numGametypeReservedObjectives++;
	

	return nextID;
}

getUpdateTeams( relativeTeam )
{
	
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
	
	return updateTeams;
}



shouldPingObject( relativeTeam )
{
	
	if ( relativeTeam == "friendly" && self.objIDPingFriendly )
		return true;
	else if ( relativeTeam == "enemy" && self.objIDPingEnemy )
		return true;
	
	return false;
}



updateWorldIcon( relativeTeam, showIcon )
{
	if ( !isDefined( self.worldIcons[relativeTeam] ) )
		showIcon = false;

	logprint("\n ### updateWorldIcon 1");

	updateTeams = getUpdateTeams( relativeTeam );
	
	logprint("\n ### updateWorldIcon 1.5");

	for ( index = 0; index < updateTeams.size; index++ )
	{
		opName = "objpoint_" + updateTeams[index] + "_" + self.entNum;			
		logprint("\n ### updateWorldIcon forloop with opname: " + opName);
		objPoint = maps\mp\gametypes\_objpoints::getObjPointByName( opName );
		
		if (!isDefined(objPoint))
			logprint("*** UPDATEWORLDICON: OBJPOINT IS UNDEFINED (opName: " + opName + ")\n");
		
		
		
		if ( showIcon && isDefined(objPoint))
		{
			logprint("\n ### updateWorldIcon 2");
			objPoint setShader( self.worldIcons[relativeTeam], level.objPointSize, level.objPointSize );
			objPoint fadeOverTime( 0.05 ); 
			objPoint.alpha = objPoint.baseAlpha;
			objPoint.isShown = true;

			objPoint setwaypoint( true, self.worldIcons[relativeTeam] );

			
			if ( self.type == "carryObject" )
			{
				logprint("\n ### updateWorldIcon 5");
				if (isDefined(self.carrier) )
				{
					if ( (isDefined(self.carrier.droppedout) && self.carrier.droppedout) ) 
					{
						logprint("\nCLEARING TARGET ENT\n");
						objPoint cleartargetent();
					}
					else if ( isAlive( self.carrier )   )
					{
						logprint("\n :**SCRIPTS**: setting target Ent on carrier***\n");
						objPoint settargetent( self.carrier );
					}
					else
					{
						logprint("\nCLEARING TARGET ENT\n");
						objPoint cleartargetent();
					}
				}
			}
			
			if(self.type == "playerTarget")
			{
				logprint("\n ### updateWorldIcon 6");
				objPoint settargetent(self);
			}
		}
		else
		{
			logprint("\n ### updateWorldIcon 7");
			if(isDefined(objPoint))
			{
				logprint("\n ### updateWorldIcon 8");
				objPoint fadeOverTime( 0.05 );
				objPoint.alpha = 0;
				objPoint.isShown = false;
				objPoint cleartargetent();
			}
		}
	}
}



updateWorldIcons()
{
	if ( self.visibleTeam == "any" )
	{
		logprint("\n ### UpdateWorldIcons 1");
		updateWorldIcon( "friendly", true );
		updateWorldIcon( "enemy", true );
	}
	else if ( self.visibleTeam == "friendly" )
	{
		logprint("\n ### UpdateWorldIcons 2");
		updateWorldIcon( "friendly", true );
		updateWorldIcon( "enemy", false );
	}
	else if ( self.visibleTeam == "enemy" )
	{
		logprint("\n ### UpdateWorldIcons 3");
		updateWorldIcon( "friendly", false );
		updateWorldIcon( "enemy", true );
	}
	else
	{
		logprint("\n ### updateWorldIcons 4");
		updateWorldIcon( "friendly", false );
		updateWorldIcon( "enemy", false );
	}
}



setOwnerTeam( team )	
{
	
	self.ownerTeam = team;
	self updateCompassIcons();
	self updateWorldIcons();
}



deleteObjPoint ()
{
	logprint("************Deleting objective point*******************\n");

	if ( isDefined( self.objPoints["allies"] ) )
	{
		self.objPoints["allies"] destroy();
		logprint("************Deleting hud object point*******************\n");
	}

	if ( isDefined( self.objPoints["axis"] ) )
	{
		self.objPoints["axis"] destroy();
		logprint("************Deleting hud object point*******************\n");
	}

	maps\mp\gametypes\_objpoints::deleteObjPoint( self.objIDAllies );
	maps\mp\gametypes\_objpoints::deleteObjPoint( self.objIDAxis );
	level.numGametypeReservedObjectives = 0;
}






object_fx(fx)
{
	level endon ("objective_done");
	self endon ("pickup_object");
	while (1)
	{
		wait(0.5);
		playfx(fx, (self.curOrigin[0],self.curOrigin[1],self.curOrigin[2] + 10));
	}
}