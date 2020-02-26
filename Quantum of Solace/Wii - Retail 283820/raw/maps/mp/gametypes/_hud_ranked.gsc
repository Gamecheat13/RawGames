#include maps\mp\gametypes\_hud_util;

init()
{
	level.placements = [];
	level.placements[level.placements.size] = "";
	level.placements[level.placements.size] = "MP_1ST";
	level.placements[level.placements.size] = "MP_2ND";
	level.placements[level.placements.size] = "MP_3RD";
	level.placements[level.placements.size] = "MP_4TH";
	level.placements[level.placements.size] = "MP_5TH";
	level.placements[level.placements.size] = "MP_6TH";
	level.placements[level.placements.size] = "MP_7TH";
	level.placements[level.placements.size] = "MP_8TH";
	level.placements[level.placements.size] = "MP_9TH";
	level.placements[level.placements.size] = "MP_10TH";
	level.placements[level.placements.size] = "MP_11TH";
	level.placements[level.placements.size] = "MP_12TH";
	level.placements[level.placements.size] = "MP_13TH";
	level.placements[level.placements.size] = "MP_14TH";
	level.placements[level.placements.size] = "MP_15TH";
	level.placements[level.placements.size] = "MP_16TH";
	level.placements[level.placements.size] = "MP_17TH";
	level.placements[level.placements.size] = "MP_18TH";
	level.placements[level.placements.size] = "MP_19TH";
	level.placements[level.placements.size] = "MP_20TH";
	level.placements[level.placements.size] = "MP_21ST";
	level.placements[level.placements.size] = "MP_22ND";
	level.placements[level.placements.size] = "MP_23RD";
	level.placements[level.placements.size] = "MP_24TH";




	precacheString(&"MP_ST");
	precacheString(&"MP_ND");
	precacheString(&"MP_RD");
	precacheString(&"MP_TH");
	precacheString(&"MP_PTS");
	precacheString(&"MPUI_MARINES");
	precacheString(&"MPUI_OPFOR");

	if ( !maps\mp\gametypes\_tweakables::getTweakableValue( "hud", "showscore" ) )
		return;

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
	
	self setClientDvar( "ui_rank_name", self.name );
	
	for(;;)
	{
		self waittill("spawned_player");
		
		if ( isDefined( level.hud_scoreBar ) )
		{
			if(!isdefined(self.hud_rankedicon))
			{
				self.hud_rankedicon = createIcon( undefined, 22, 22 );
				self.hud_rankedicon setPoint( "TOPRIGHT", "TOPRIGHT", 0, -2 );
				self.hud_rankedicon.foreground = true;
			}
	
			if(!isdefined(self.hud_rankedname))
			{
				self.hud_rankedname = createFontString( "default", 1.5 );
				self.hud_rankedname setParent( self.hud_rankedicon );
				self.hud_rankedname setPoint( "RIGHT", "LEFT", -5, 0 );
				self.hud_rankedname.foreground = true;
			}
	
			if(!isdefined(self.hud_rankedbar))
			{
				self.hud_rankedbar = createBar( (1,1,0), 80, 20 );
				self.hud_rankedbar setParent( self.hud_rankedicon );
				self.hud_rankedbar setPoint( "TOPRIGHT", "BOTTOMRIGHT", 0, 4 );
				self.hud_rankedbar.foreground = true;
				self.hud_rankedbar.bar.foreground = true;
				self.hud_rankedbar.barFrame.foreground = true;
			}
		}
		else
		{
			if(!isdefined(self.hud_rankedicon))
			{
				self.hud_rankedicon = createIcon( undefined, 48, 48 );
				self.hud_rankedicon setPoint( "TOPRIGHT", undefined, -6, 6 );
			}
	
			if(!isdefined(self.hud_rankedname))
			{
				self.hud_rankedname = createFontString( "default", 1.5 );
				self.hud_rankedname setParent( self.hud_rankedicon );
				self.hud_rankedname setPoint( "CENTER", "CENTER", 0, 0 );
			}
	
			if(!isdefined(self.hud_rankedbar))
			{
				self.hud_rankedbar = createBar( (1,1,0), 80, 20 );
				self.hud_rankedbar setParent( self.hud_rankedicon );
				self.hud_rankedbar setPoint( "TOP", "BOTTOM", 0, 0 );
			}
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
	
		self.hud_rankedicon	setIconShader( icon );
	}




	if(isDefined(self.hud_rankedname))
	{
		self.hud_rankedname.label = self maps\mp\gametypes\_rank::getRankInfoFull( self maps\mp\gametypes\_rank::getRank() );
	}

	if(isDefined(self.hud_rankedbar))
	{
		rank = self maps\mp\gametypes\_rank::getRank();
		
		xpAmt = self maps\mp\gametypes\_rank::getRankXP() - self maps\mp\gametypes\_rank::getRankInfoMinXP( rank );
		self.hud_rankedbar updateBar( xpAmt / self maps\mp\gametypes\_rank::getRankInfoXPAmt( rank ) );
	}

	
}

removeRankedHUD()
{
	if(isDefined(self.hud_rankedname))
		self.hud_rankedname destroy();

	if(isDefined(self.hud_rankedicon))
		self.hud_rankedicon destroy();

	if(isDefined(self.hud_rankedscore))
		self.hud_rankedscore destroy();

	if(isDefined(self.hud_rankedplace))
		self.hud_rankedplace destroy();
}
