#include common_scripts\utility;

registerMoneyInfo( type, value, label )
{
	level.moneyInfo[type]["value"] = value;
	level.moneyInfo[type]["label"] = label;
}

getMoneyInfoValue( type )
{
	return ( level.moneyInfo[type]["value"] );
}

getMoneyInfoLabel( type )
{
	return ( level.moneyInfo[type]["label"] );
}

init()
{
	level.moneyInfo = [];
	
	precacheString(&"MP_KILL_PREFIX");
	precacheString(&"MP_HEADSHOT_PREFIX");
	precacheString(&"MP_SUICIDE_PREFIX");
	precacheString(&"MP_TEAMKILL_PREFIX");
	precacheString(&"MP_ASSIST_PREFIX");

	registerMoneyInfo( "kill", 2, &"MP_KILL_PREFIX" );
	registerMoneyInfo( "headshot", 3, &"MP_HEADSHOT_PREFIX" );
	registerMoneyInfo( "suicide", 0, &"MP_SUICIDE_PREFIX" );
	registerMoneyInfo( "teamkill", 0, &"MP_TEAMKILL_PREFIX" );
	registerMoneyInfo( "assist", 1, &"MP_ASSIST_PREFIX" );

	precacheString(&"MP_DOLLAR");	
	precacheString(&"MP_PLUS_DOLLAR");	
	precacheString(&"MP_MINUS_DOLLAR");	

	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player setClientDvar( "ui_money", getMoney() );

		player.moneyUpdateTotal = 0;

		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
	}
}


onJoinedTeam()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_team");
		self thread removeMoneyHUD();
	}
}


onJoinedSpectators()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_spectators");
		self thread removeMoneyHUD();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");

/*
		if(!isdefined(self.hud_money))
		{
			self.hud_money = newClientHudElem(self);
			self.hud_money.horzAlign = "right";
			self.hud_money.vertAlign = "top";
			self.hud_money.alignX = "right";
	 		self.hud_money.x = -16;
			self.hud_money.y = 68;
			self.hud_money.font = "default";
			self.hud_money.fontscale = 2;
			self.hud_money.archived = false;
			self.hud_money.alpha = 0;
			self.hud_money.color = (0,0.75,0);
			self.hud_money fontPulseInit();
		}

		if(!isdefined(self.hud_moneyupdate))
		{
			self.hud_moneyupdate = newClientHudElem(self);
			self.hud_moneyupdate.horzAlign = "right";
			self.hud_moneyupdate.vertAlign = "top";
			self.hud_moneyupdate.alignX = "center";
			self.hud_moneyupdate.alignY = "middle";
	 		self.hud_moneyupdate.base_x = -90;
			self.hud_moneyupdate.base_y = 104;
	 		self.hud_moneyupdate.x = self.hud_moneyupdate.base_x;
			self.hud_moneyupdate.y = self.hud_moneyupdate.base_y;
			self.hud_moneyupdate.font = "default";
			self.hud_moneyupdate.fontscale = 2;
			self.hud_moneyupdate.archived = false;
			self.hud_moneyupdate.plusColor = (0,0.75,0);
			self.hud_moneyupdate.minusColor = (0.75,0,0);
			self.hud_moneyupdate.color = self.hud_moneyupdate.plusColor;
			self.hud_moneyupdate fontPulseInit();
		}
*/
		self updateMoneyHUD();
	}
}


giveMoney( type )
{
//	self thread updateMoney( getMoneyInfoValue( type ), getMoneyInfoLabel( type ) ); // threaded due to the wait
}


updateMoney( amount, label )
{
	self endon("disconnect");
	self endon("joined_team");
//	self.hud_moneyupdate endon("death");
//	self.hud_money endon("death");

	self notify("update_money");
	self endon("update_money");

	if(isDefined(self.hud_moneyupdate) && isDefined(self.hud_money))
	{
		self.hud_money fadeOverTime(0.5);
		self.hud_money.alpha = 1;
		
		self.moneyUpdateTotal += amount;
			
		if ( self.moneyUpdateTotal > 0 )
		{
			self.hud_moneyupdate.label = &"MP_PLUS_DOLLAR";
			self.hud_moneyupdate.color = self.hud_moneyupdate.plusColor;
		}
		else
		{ 
			self.hud_moneyupdate.label = &"MP_MINUS_DOLLAR";
			self.hud_moneyupdate.color = self.hud_moneyupdate.minusColor;
		}

		self.hud_moneyupdate setValue(self.moneyUpdateTotal);
		self.hud_moneyupdate.alpha = 1;
		self.hud_moneyupdate.x = self.hud_moneyupdate.base_x;
		self.hud_moneyupdate.y = self.hud_moneyupdate.base_y;
//		self.hud_moneyupdate thread fontPulse();

		wait 1; // fixme -- if we get another script error here, put in if isdefined(self) checks
		self.hud_moneyupdate moveOverTime(1);
		self.hud_moneyupdate fadeOverTime(0.75);
		self.hud_moneyupdate.alpha = 0;
		self.hud_moneyupdate.x = self.hud_money.x;
		self.hud_moneyupdate.y = self.hud_money.y;

		wait 1;
		self setMoney( self getMoney() + self.moneyUpdateTotal );
		self setClientDvar( "ui_money", self getMoney() );
		self.moneyUpdateTotal = 0;
		self updateMoneyHUD();

//		wait 2;
//		self.hud_money.label = &"MP_PLUS_DOLLAR";
//		self.hud_money fadeOverTime(2);
//		self.hud_money.alpha = 0;
	}
}


updateMoneyHUD()
{
	if( isDefined( self.hud_money ) )
	{
		self.hud_money.label = &"MP_DOLLAR";
		self.hud_money setValue( self getMoney() );
	}
}


removeMoneyHUD()
{
	if( isDefined( self.hud_money ) )
		self.hud_money destroy();

	if( isDefined( self.hud_moneyupdate ) )
		self.hud_moneyupdate destroy();
}


fontPulseInit()
{
	self.baseFontScale = self.fontScale;
	self.maxFontScale = self.fontScale * 2;
	self.inFrames = 3;
	self.outFrames = 5;
}


fontPulse(player)
{
	self notify ( "fontPulse" );
	self endon ( "fontPulse" );
	player endon("disconnect");
	player endon("joined_team");
	player endon("joined_spectators");
	
	scaleRange = self.maxFontScale - self.baseFontScale;
	
	while ( self.fontScale < self.maxFontScale )
	{
		self.fontScale = min( self.maxFontScale, self.fontScale + (scaleRange / self.inFrames) );
		wait 0.05;
	}
		
	while ( self.fontScale > self.baseFontScale )
	{
		self.fontScale = max( self.baseFontScale, self.fontScale - (scaleRange / self.outFrames) );
		wait 0.05;
	}
}


// CODE FUNCTION
getMoney()
{
	if ( !isDefined( self.code ) )
		self.code = [];
		
	if ( !isDefined( self.code["money"] ) )
		self.code["money"] = 0;
		
	return ( self.code["money"] );
}


// CODE FUNCTION
setMoney( amount )
{
	self.code["money"] = amount;
}
