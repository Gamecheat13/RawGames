#include maps\mp\gametypes\_hud_util;

init()
{
	precacheString(&"MP_ST");
	precacheString(&"MP_ND");
	precacheString(&"MP_RD");
	precacheString(&"MP_TH");
	precacheString(&"MP_PTS");
	precacheString(&"MPUI_MARINES");
	precacheString(&"MPUI_OPFOR");

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread onUpdateRankedHUD();
	}
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self thread removeRankedHUD();
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self thread removeRankedHUD();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	level.rankIconWidth = 32;
	level.rankIconHeight = 32;
	
	for(;;)
	{
		self waittill("spawned_player");

		if(!isdefined(self.hud_rankedicon))
		{
			self.hud_rankedicon = createIcon( undefined, 32, 32 );
			self.hud_rankedicon setPoint( "TOPRIGHT", undefined, -6, 6 );
		}

		if(!isdefined(self.hud_rankedscore))
		{
		    self.hud_rankedscore = createFontString( "default", 1.75 );
		    self.hud_rankedscore setParent( self.hud_rankedicon );
		    self.hud_rankedscore setPoint( "TOPRIGHT", "BOTTOMRIGHT", -30, 0 );
		    self.hud_rankedscore.color = (1.0,1.0,0);
		}
		
		if(!isdefined(self.hud_rankedscoresuffix))
		{
		    self.hud_rankedscoresuffix = createFontString( "default", 1.5 );
		    self.hud_rankedscoresuffix setParent( self.hud_rankedicon );
		    self.hud_rankedscoresuffix setPoint( "TOPRIGHT", "BOTTOMRIGHT", 0, 0 );
		    self.hud_rankedscoresuffix setText( &"MP_PTS" );
		    self.hud_rankedscoresuffix.color = (1.0,1.0,0);
		}

		if(!isdefined(self.hud_rankedplace))
		{
		    self.hud_rankedplace = createFontString( "default", 1.5 );
		    self.hud_rankedplace setParent( self.hud_rankedicon );
		    self.hud_rankedplace setPoint( "RIGHT", "CENTER" );
		}

		if(!isdefined(self.hud_rankedplacesuffix))
		{
		    self.hud_rankedplacesuffix = createFontString( "default", 1.5 );
		    self.hud_rankedplacesuffix setParent( self.hud_rankedicon );
		    self.hud_rankedplacesuffix setPoint( "LEFT", "CENTER" );
		}

		self thread updateRankedHUD();
	}
}


onUpdateRankedHUD()
{
	for(;;)
	{
		self waittill("update_ranked_hud");
		
		self thread updateRankedHUD();
	}
}


updateRankedHUD()
{
	if(isDefined(self.hud_rankedicon))
	{
		icon = maps\mp\gametypes\_rank::getRankInfoIcon( self maps\mp\gametypes\_rank::getRank() );
		if ( self.pers["team"] == "allies" )
			icon = "hudicon_american";
		else
			icon = "hudicon_opfor";
	
		self.hud_rankedicon	setIconShader( icon );
	}

	if(isDefined(self.hud_rankedscore))
	{
		self.hud_rankedscore setValue( self.score );
	}

	if(isDefined(self.hud_rankedplace))
	{
		if ( self.pers["place"] > 0 )
		{
			self.hud_rankedplace.alpha = 1;
			self.hud_rankedplace setValue( self.pers["place"] );
		}
		else
		{
			self.hud_rankedplace.alpha = 0;
		}
	}

	if(isDefined(self.hud_rankedplacesuffix))
	{
		if ( self.pers["place"] > 0 )
		{
			self.hud_rankedplacesuffix.alpha = 1;

			if ( self.pers["place"] > 10 && self.pers["place"] < 20 )
				self.hud_rankedplacesuffix setText( &"MP_TH" );
			else if ( (self.pers["place"] % 10) == 1 )
				self.hud_rankedplacesuffix setText( &"MP_ST" );
			else if ( (self.pers["place"] % 10) == 2 )
				self.hud_rankedplacesuffix setText( &"MP_ND" );
			else if ( (self.pers["place"] % 10) == 3 )
				self.hud_rankedplacesuffix setText( &"MP_RD" );
			else
				self.hud_rankedplacesuffix setText( &"MP_TH" );
		}
		else
		{
			self.hud_rankedplacesuffix.alpha = 0;
		}
	}
}


removeRankedHUD()
{
	if(isDefined(self.hud_rankedicon))
		self.hud_rankedicon destroy();

	if(isDefined(self.hud_rankedscore))
		self.hud_rankedscore destroy();

	if(isDefined(self.hud_rankedplace))
		self.hud_rankedplace destroy();
}
