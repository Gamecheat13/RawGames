#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;


isRegisteredEvent( type )
{
	if ( isDefined( level.scoreInfo[type] ) )
		return true;
	else
		return false;
}

registerScoreInfo( type, value, label )
{
	level.scoreInfo[type]["value"] = value;
	level.scoreInfo[type]["label"] = label;
}

getScoreInfoValue( type )
{
	return ( level.scoreInfo[type]["value"] );
}

getScoreInfoLabel( type )
{
	return ( level.scoreInfo[type]["label"] );
}

registerRankInfo( rank, minxp, xp, abbr, full, icon )
{
	level.ranks[rank]["minxp"] = minxp;
	level.ranks[rank]["xpamt"] = xp;	
	level.ranks[rank]["abbr"] = abbr;
	level.ranks[rank]["full"] = full;
	level.ranks[rank]["icon"] = icon;
	
	precacheString( level.ranks[rank]["abbr"] );
	precacheString( level.ranks[rank]["full"] );
	precacheShader( level.ranks[rank]["icon"] );
}

getRankInfoMinXP( rank )
{
	return ( level.ranks[rank]["minxp"] );
}

getRankInfoXPAmt( rank )
{
	return ( level.ranks[rank]["xpamt"] );
}

getRankInfoAbbr( rank )
{
	return ( level.ranks[rank]["abbr"] );
}

getRankInfoFull( rank )
{
	return ( level.ranks[rank]["full"] );
}

getRankInfoIcon( rank )
{
	return ( level.ranks[rank]["icon"] );
}

init()
{
	level.scoreInfo = [];

	precacheShader("white");
	
	precacheString(&"MP_KILL");
	precacheString(&"MP_HEADSHOT");
	precacheString(&"MP_SUICIDE");
	precacheString(&"MP_TEAMKILL");
	precacheString(&"MP_ASSIST");
	precacheString(&"MP_WIN");
	precacheString(&"MP_LOSS");
	precacheString(&"MP_CAPTURE");
	precacheString(&"MP_DEFEND");
	precacheString(&"MP_CHALLENGE");

	registerScoreInfo( "kill", 10, &"MP_KILL" );
	registerScoreInfo( "headshot", 10, &"MP_HEADSHOT" );
	registerScoreInfo( "suicide", 0, &"MP_SUICIDE" );
	registerScoreInfo( "teamkill", 0, &"MP_TEAMKILL" );
	registerScoreInfo( "assist", 5, &"MP_ASSIST" );
	
	registerScoreInfo( "win", 50, &"MP_WIN" );
	registerScoreInfo( "loss", 10, &"MP_LOSS" );
	registerScoreInfo( "capture", 5, &"MP_CAPTURE" );
	registerScoreInfo( "defend", 5, &"MP_DEFEND" );
	
	registerScoreInfo( "challenge", 250, &"MP_CHALLENGE" );
	

	precacheString(&"MP_PLUS");
	precacheString(&"RANK_NEWRANK");
	precacheString(&"RANK_PVT");
	precacheString(&"RANK_PVT_FULL");
	precacheString(&"RANK_PFC");
	precacheString(&"RANK_PFC_FULL");
	precacheString(&"RANK_LCPL");
	precacheString(&"RANK_LCPL_FULL");
	precacheString(&"RANK_CPL");
	precacheString(&"RANK_CPL_FULL");
	precacheString(&"RANK_SGT");
	precacheString(&"RANK_SGT_FULL");
	precacheString(&"RANK_SSGT");
	precacheString(&"RANK_SSGT_FULL");
	precacheString(&"RANK_GYSGT");
	precacheString(&"RANK_GYSGT_FULL");
	precacheString(&"RANK_MSGT");
	precacheString(&"RANK_MSGT_FULL");
	precacheString(&"RANK_MGYSGT");
	precacheString(&"RANK_MGYSGT_FULL");
	precacheString(&"RANK_2NDLT");
	precacheString(&"RANK_2NDLT_FULL");
	precacheString(&"RANK_1STLT");
	precacheString(&"RANK_1STLT_FULL");
	precacheString(&"RANK_CAPT");
	precacheString(&"RANK_CAPT_FULL");
	precacheString(&"RANK_MAJ");
	precacheString(&"RANK_MAJ_FULL");
	precacheString(&"RANK_LTCOL");
	precacheString(&"RANK_LTCOL_FULL");
	precacheString(&"RANK_COL");
	precacheString(&"RANK_COL_FULL");
	precacheString(&"RANK_BGEN");
	precacheString(&"RANK_BGEN_FULL");
	precacheString(&"RANK_MAJGEN");
	precacheString(&"RANK_MAJGEN_FULL");
	precacheString(&"RANK_LTGEN");
	precacheString(&"RANK_LTGEN_FULL");
	precacheString(&"RANK_GEN");
	precacheString(&"RANK_GEN_FULL");

	level.ranks = [];
	registerRankInfo( 	"PVT",		0,			500,	&"RANK_PVT",	&"RANK_PVT_FULL",		"rank_private"		);
	registerRankInfo( 	"PFC",		500,		1500,	&"RANK_PFC",	&"RANK_PFC_FULL",		"rank_private"		);
	registerRankInfo( 	"LCPL",		2000,		3000,	&"RANK_LCPL",	&"RANK_LCPL_FULL",		"rank_corporal"		);
	registerRankInfo( 	"CPL",		5000,		5000,	&"RANK_CPL",	&"RANK_CPL_FULL",		"rank_corporal"		);
	registerRankInfo( 	"SGT",		10000,		7500,	&"RANK_SGT",	&"RANK_SGT_FULL",		"rank_sergeant"		);
	registerRankInfo( 	"SSGT",		17500,		10000,	&"RANK_SSGT",	&"RANK_SSGT_FULL",		"rank_sergeant"		);
	registerRankInfo( 	"GYSGT",	27500,		12500,	&"RANK_GYSGT",	&"RANK_GYSGT_FULL",		"rank_sergeant" 	);
	registerRankInfo( 	"MSGT",		40000,		15000,	&"RANK_MSGT",	&"RANK_MSGT_FULL",		"rank_sergeant" 	);
	registerRankInfo( 	"MGYSGT",	55000,		22500,	&"RANK_MGYSGT",	&"RANK_MGYSGT_FULL",	"rank_sergeant" 	);
	registerRankInfo( 	"2NDLT",	77500,		30000,	&"RANK_2NDLT",	&"RANK_2NDLT_FULL",		"rank_lieutenant" 	);
	registerRankInfo( 	"1STLT",	107500,		40000,	&"RANK_1STLT",	&"RANK_1STLT_FULL",		"rank_lieutenant" 	);
	registerRankInfo( 	"CAPT",		147500,		52500,	&"RANK_CAPT",	&"RANK_CAPT_FULL",		"rank_captain" 		);
	registerRankInfo( 	"MAJ",		200000,		67500,	&"RANK_MAJ",	&"RANK_MAJ_FULL",		"rank_major" 		);
	registerRankInfo( 	"LTCOL",	267500,		85000,	&"RANK_LTCOL",	&"RANK_LTCOL_FULL",		"rank_colonel" 		);
	registerRankInfo( 	"COL",		352500,		120000,	&"RANK_COL",	&"RANK_COL_FULL",		"rank_colonel" 		);
	registerRankInfo( 	"BGEN",		472500,		155000,	&"RANK_BGEN",	&"RANK_BGEN_FULL",		"rank_general" 		);
	registerRankInfo( 	"MAJGEN",	627500,		210000,	&"RANK_MAJGEN",	&"RANK_MAJGEN_FULL",	"rank_general" 		);
	registerRankInfo( 	"LTGEN",	837500,		327500,	&"RANK_LTGEN",	&"RANK_LTGEN_FULL",		"rank_general" 		);
	registerRankInfo( 	"GEN",		1165000,	999999,	&"RANK_GEN",	&"RANK_GEN_FULL",		"rank_general" 		);

	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player.pers["rankxp"] = player maps\mp\gametypes\_persistence_util::statGet( "stats", "rankxp" );
		
		player.pers["rank"] = player getRank();
		player.rankUpdateTotal = 0;

		player setClientDvar("ui_rank", player.pers["rank"]);

		rank = player getRank();
		player.rankicon = player getRankInfoIcon( rank );

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
		self thread removeRankHUD();
	}
}


onJoinedSpectators()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_spectators");
		self thread removeRankHUD();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		if(!isdefined(self.hud_rankscroreupdate))
		{
			self.hud_rankscroreupdate = newClientHudElem(self);
			self.hud_rankscroreupdate.horzAlign = "center";
			self.hud_rankscroreupdate.vertAlign = "middle";
			self.hud_rankscroreupdate.alignX = "center";
			self.hud_rankscroreupdate.alignY = "middle";
	 		self.hud_rankscroreupdate.x = 0;
			self.hud_rankscroreupdate.y = -60;
			self.hud_rankscroreupdate.font = "default";
			self.hud_rankscroreupdate.fontscale = 2;
			self.hud_rankscroreupdate.archived = false;
			self.hud_rankscroreupdate.color = (1,1,0);
			self.hud_rankscroreupdate maps\mp\gametypes\_money::fontPulseInit();
		}

		/*		
		if ( !isDefined( self.hud_xp ) )
		{
			self.hud_xp = createFontString( "default", 1.0 );
			self.hud_xp setPoint( "TOPRIGHT" );
			self thread updateXP();
			
		}
		*/
	}
}


updateXP()
{
	self endon ( "disconnect" );

	for ( ;; )
	{
		self.hud_xp setValue( self getRankXP() );
		wait ( 1.0 );
	}
}


giveRankXP( type )
{
	self endon("disconnect");

	value = getScoreInfoValue( type );
	label = getScoreInfoLabel( type );
	
	self incRankXP( value );

	println( "giving xp" );

	if ( isDefined( self.enableText ) && self.enableText && level.xboxlive )
	{
		self maps\mp\gametypes\_hud_message::addMessageText( label, (0.7,0.7,0.7) );
		self thread updateRankScoreHUD( value, label );
	}

	self thread updateRankAnnounceHUD();
	self notify ("update_ranked_hud");
}

updateRankAnnounceHUD()
{
	self endon("disconnect");

	self notify("update_rank");
	self endon("update_rank");

	if ( self getRank() != self.pers["rank"] )
	{
		self.pers["rank"] = self getRank();
		self.rankicon = self getRankInfoIcon( self.pers["rank"]  );

		maps\mp\gametypes\_hud_message::addMessageText( level.ranks[self.pers["rank"]]["full"] );
		maps\mp\gametypes\_hud_message::addMessageText( &"RANK_NEWRANK" );
		
		self iprintlnbold( level.ranks[self.pers["rank"]]["full"] );
		self playLocalSound( "plr_new_rank" );
	}
}

updateRankScoreHUD( amount, label )
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	if ( amount == 0 )
		return;

	self notify( "update_score" );
	self endon( "update_score" );

	if( isDefined( self.hud_rankscroreupdate ) )
	{
		self.rankUpdateTotal += amount;
			
		self.hud_rankscroreupdate.label = &"MP_PLUS";

		self.hud_rankscroreupdate setValue(self.rankUpdateTotal);
		self.hud_rankscroreupdate.alpha = 1;
		self.hud_rankscroreupdate thread maps\mp\gametypes\_money::fontPulse( self );

		wait 1; // fixme -- if we get another script error here, put in if isdefined(self) checks
		self.hud_rankscroreupdate fadeOverTime( 0.75 );
		self.hud_rankscroreupdate.alpha = 0;
		
		self.rankUpdateTotal = 0;
	}
}


removeRankHUD()
{
	if(isDefined(self.hud_rankscroreupdate))
		self.hud_rankscroreupdate.alpha = 0;
}

getRank()
{
	if ( self getRankXP() < 500 )
		return "PVT";
	else if ( self getRankXP() < 2000 )
		return "PFC";
	else if ( self getRankXP() < 5000 )
		return "LCPL";
	else if ( self getRankXP() < 10000 )
		return "CPL";
	else if ( self getRankXP() < 17500 )
		return "SGT";
	else if ( self getRankXP() < 27500 )
		return "SSGT";
	else if ( self getRankXP() < 40000 )
		return "GYSGT";
	else if ( self getRankXP() < 55000 )
		return "MSGT";
	else if ( self getRankXP() < 77500 )
		return "MGYSGT";
	else if ( self getRankXP() < 107500 )
		return "2NDLT";
	else if ( self getRankXP() < 147500 )
		return "1STLT";
	else if ( self getRankXP() < 200000 )
		return "CAPT";
	else if ( self getRankXP() < 267500 )
		return "MAJ";
	else if ( self getRankXP() < 352500 )
		return "LTCOL";
	else if ( self getRankXP() < 472500 )
		return "COL";
	else if ( self getRankXP() < 627500 )
		return "BGEN";
	else if ( self getRankXP() < 837500 )
		return "MAJGEN";
	else if ( self getRankXP() < 1165000 )
		return "LTGEN";
	else
		return "GEN";
}


getRankXP()
{
	return self.pers["rankxp"];
}


setRankXP( amount )
{
	self.pers["rankxp"] += amount;
	self maps\mp\gametypes\_persistence_util::statSet( "stats", "rankxp", amount );
}


incRankXP( amount )
{
	xp = self getRankXP();
	self.pers["rankxp"] = (xp + amount);
	self maps\mp\gametypes\_persistence_util::statAdd( "stats", "rankxp", amount );
}
