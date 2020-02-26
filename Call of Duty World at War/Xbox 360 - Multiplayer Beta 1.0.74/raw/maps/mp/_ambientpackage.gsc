init()
{
	
	if(level.clientscripts)	// We're running client scripts...
	{
		maps\mp\_utility::registerClientSys("ambientPackageCmd");
		maps\mp\_utility::registerClientSys("ambientRoomCmd");
	}
}

// CODER_MOD - DSL 03/24/08
// 

tidyup_triggers(client_num)
{
	amb_triggers = GetEntArray( "ambient_package","targetname");
	
	if(isdefined(amb_triggers) && amb_triggers.size > 0)
	{
		for(i = 0; i < amb_triggers.size; i ++)
		{
			trig = amb_triggers[i];
			
			if(isdefined(trig.in_volume) && isdefined(trig.in_volume[client_num]))
			{
				trig.in_volume[client_num] = 0;
			}
		}
	}
}

monitor_for_player_leave_trigger(trigPlayer, useAmbientRoom, useAmbientPackage)
{
	trigPlayer endon("disconnect");
	while ( trigPlayer isTouching ( self ) )
	{
		wait 0.1;
	}

	//iprintlnbold("Audio Trigger at " + self.origin + " not active");

	self.in_volume[trigPlayer getentitynumber()] = 0;

	if ( useAmbientPackage )
		deactivateAmbientPackage( self.script_ambientpackage, self.script_ambientpriority, trigPlayer );
	if ( useAmbientRoom )
		deactivateAmbientRoom( self.script_ambientroom, self.script_ambientpriority, trigPlayer );	
}

player_entered_trigger(trigPlayer, useAmbientRoom, useAmbientPackage)
{
	index = trigPlayer getentitynumber();
	
	if(!isdefined(self.in_volume[index]))
	{
		self.in_volume[index] = 0;
	}
	
	if(self.in_volume[index] == 0)
	{
		if ( useAmbientPackage )
			activateAmbientPackage( self.script_ambientpackage, self.script_ambientpriority, trigPlayer );
		if ( useAmbientRoom )
			activateAmbientRoom( self.script_ambientroom, self.script_ambientpriority, trigPlayer );

		self.in_volume[index] = 1;

		//iprintlnbold("Audio Trigger at " + self.origin + " active");

		self thread monitor_for_player_leave_trigger(trigPlayer, useAmbientRoom, useAmbientPackage);
	}
}

ambientPackageTrigger()
{
//	wait_until_first_player();

	useAmbientRoom = 0;
	useAmbientPackage = 0;

	if(level.clientscripts)
	{
		useAmbientRoom = isdefined ( self.script_ambientroom );
		useAmbientPackage = isdefined ( self.script_ambientpackage );
	}
	
	if ( !isdefined( self.script_ambientpriority ) )
	{
		self.script_ambientpriority = 1;
	}

	self.in_volume = [];

	for (;;)
	{
		self waittill ( "trigger", trigPlayer );

		self player_entered_trigger(trigPlayer, useAmbientRoom, useAmbientPackage);
		
		wait(0.01);
	}
}

activateAmbientPackage( package, priority, trigPlayer )
{
	if(level.clientscripts)	// Not running client side scripts, so business as usual, here on the server.
	{
		notifyString = "A " + package + " " + priority;
		maps\mp\_utility::setClientSysState("ambientPackageCmd", notifyString, trigPlayer);
	}
}

deactivateAmbientPackage( package, priority, trigPlayer )
{
	if(level.clientscripts)	// Not running client side scripts, so business as usual, here on the server.
	{
		notifyString = "D " + package + " " + priority;
		maps\mp\_utility::setClientSysState("ambientPackageCmd", notifyString, trigPlayer);
	}
}

activateAmbientRoom( room, priority, trigPlayer )
{
	if(level.clientscripts)	// Client side scripting
	{
		notifyString = "A " + room + " " + priority;
/#
		println("*** CS AR : " + room);
#/
		maps\mp\_utility::setClientSysState("ambientRoomCmd", notifyString, trigPlayer);
	}
}

deactivateAmbientRoom(room, priority, trigPlayer )
{
	if(level.clientscripts)	// Client side scripting
	{
		notifyString = "D " + room + " " + priority;
		maps\mp\_utility::setClientSysState("ambientRoomCmd", notifyString, trigPlayer);
	}
}