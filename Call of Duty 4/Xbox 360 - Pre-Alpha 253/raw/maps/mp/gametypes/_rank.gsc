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

	registerScoreInfo( "kill", 2, &"MP_KILL" );
	registerScoreInfo( "headshot", 3, &"MP_HEADSHOT" );
	registerScoreInfo( "suicide", 0, &"MP_SUICIDE" );
	registerScoreInfo( "teamkill", 0, &"MP_TEAMKILL" );
	registerScoreInfo( "assist", 1, &"MP_ASSIST" );
	
	registerScoreInfo( "win", 10, &"MP_WIN" );
	registerScoreInfo( "loss", 0, &"MP_LOSS" );
	registerScoreInfo( "capture", 1, &"MP_CAPTURE" );
	registerScoreInfo( "defend", 1, &"MP_DEFEND" );
	
	registerScoreInfo( "challenge", 50, &"MP_CHALLENGE" );
	

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
	registerRankInfo( 	"PVT",		0,		100,	&"RANK_PVT",	&"RANK_PVT_FULL",		"rank_private"		);
	registerRankInfo( 	"PFC",		100,	300,	&"RANK_PFC",	&"RANK_PFC_FULL",		"rank_private"		);
	registerRankInfo( 	"LCPL",		400,	600,	&"RANK_LCPL",	&"RANK_LCPL_FULL",		"rank_corporal"		);
	registerRankInfo( 	"CPL",		1000,	1000,	&"RANK_CPL",	&"RANK_CPL_FULL",		"rank_corporal"		);
	registerRankInfo( 	"SGT",		2000,	1500,	&"RANK_SGT",	&"RANK_SGT_FULL",		"rank_sergeant"		);
	registerRankInfo( 	"SSGT",		3500,	2000,	&"RANK_SSGT",	&"RANK_SSGT_FULL",		"rank_sergeant"		);
	registerRankInfo( 	"GYSGT",	5500,	2500,	&"RANK_GYSGT",	&"RANK_GYSGT_FULL",		"rank_sergeant" 	);
	registerRankInfo( 	"MSGT",		8000,	3000,	&"RANK_MSGT",	&"RANK_MSGT_FULL",		"rank_sergeant" 	);
	registerRankInfo( 	"MGYSGT",	11000,	4500,	&"RANK_MGYSGT",	&"RANK_MGYSGT_FULL",	"rank_sergeant" 	);
	registerRankInfo( 	"2NDLT",	15500,	6000,	&"RANK_2NDLT",	&"RANK_2NDLT_FULL",		"rank_lieutenant" 	);
	registerRankInfo( 	"1STLT",	21500,	8000,	&"RANK_1STLT",	&"RANK_1STLT_FULL",		"rank_lieutenant" 	);
	registerRankInfo( 	"CAPT",		29500,	10500,	&"RANK_CAPT",	&"RANK_CAPT_FULL",		"rank_captain" 		);
	registerRankInfo( 	"MAJ",		40000,	13500,	&"RANK_MAJ",	&"RANK_MAJ_FULL",		"rank_major" 		);
	registerRankInfo( 	"LTCOL",	53500,	17000,	&"RANK_LTCOL",	&"RANK_LTCOL_FULL",		"rank_colonel" 		);
	registerRankInfo( 	"COL",		70500,	24000,	&"RANK_COL",	&"RANK_COL_FULL",		"rank_colonel" 		);
	registerRankInfo( 	"BGEN",		94500,	31000,	&"RANK_BGEN",	&"RANK_BGEN_FULL",		"rank_general" 		);
	registerRankInfo( 	"MAJGEN",	125500,	42000,	&"RANK_MAJGEN",	&"RANK_MAJGEN_FULL",	"rank_general" 		);
	registerRankInfo( 	"LTGEN",	167500,	65500,	&"RANK_LTGEN",	&"RANK_LTGEN_FULL",		"rank_general" 		);
	registerRankInfo( 	"GEN",		233000,	99999,	&"RANK_GEN",	&"RANK_GEN_FULL",		"rank_general" 		);
	/*
	registerRankInfo( 	"PVT",		0,		10,	&"RANK_PVT",	&"RANK_PVT_FULL",		"rank_private"		);
	registerRankInfo( 	"PFC",		10,		10,	&"RANK_PFC",	&"RANK_PFC_FULL",		"rank_private"		);
	registerRankInfo( 	"LCPL",		20,		10,	&"RANK_LCPL",	&"RANK_LCPL_FULL",		"rank_corporal"		);
	registerRankInfo( 	"CPL",		30,		10,	&"RANK_CPL",	&"RANK_CPL_FULL",		"rank_corporal"		);
	registerRankInfo( 	"SGT",		40,		10,	&"RANK_SGT",	&"RANK_SGT_FULL",		"rank_sergeant"		);
	registerRankInfo( 	"SSGT",		50,		10,	&"RANK_SSGT",	&"RANK_SSGT_FULL",		"rank_sergeant"		);
	registerRankInfo( 	"GYSGT",	60,		10,	&"RANK_GYSGT",	&"RANK_GYSGT_FULL",		"rank_sergeant" 	);
	registerRankInfo( 	"MSGT",		70,		10,	&"RANK_MSGT",	&"RANK_MSGT_FULL",		"rank_sergeant" 	);
	registerRankInfo( 	"MGYSGT",	80,		10,	&"RANK_MGYSGT",	&"RANK_MGYSGT_FULL",	"rank_sergeant" 	);
	registerRankInfo( 	"2NDLT",	90,		10,	&"RANK_2NDLT",	&"RANK_2NDLT_FULL",		"rank_lieutenant" 	);
	registerRankInfo( 	"1STLT",	100,	10,	&"RANK_1STLT",	&"RANK_1STLT_FULL",		"rank_lieutenant" 	);
	registerRankInfo( 	"CAPT",		110,	10,	&"RANK_CAPT",	&"RANK_CAPT_FULL",		"rank_captain" 		);
	registerRankInfo( 	"MAJ",		120,	10,	&"RANK_MAJ",	&"RANK_MAJ_FULL",		"rank_major" 		);
	registerRankInfo( 	"LTCOL",	130,	10,	&"RANK_LTCOL",	&"RANK_LTCOL_FULL",		"rank_colonel" 		);
	registerRankInfo( 	"COL",		140,	10,	&"RANK_COL",	&"RANK_COL_FULL",		"rank_colonel" 		);
	registerRankInfo( 	"BGEN",		150,	10,	&"RANK_BGEN",	&"RANK_BGEN_FULL",		"rank_general" 		);
	registerRankInfo( 	"MAJGEN",	160,	10,	&"RANK_MAJGEN",	&"RANK_MAJGEN_FULL",	"rank_general" 		);
	registerRankInfo( 	"LTGEN",	170,	10,	&"RANK_LTGEN",	&"RANK_LTGEN_FULL",		"rank_general" 		);
	registerRankInfo( 	"GEN",		180,	99999,	&"RANK_GEN",	&"RANK_GEN_FULL",		"rank_general" 		);
	*/

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

		player.rankxp = player.pers["rankxp"];
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
	if ( self getRankXP() < 100 )
		return "PVT";
	else if ( self getRankXP() < 400 )
		return "PFC";
	else if ( self getRankXP() < 1000 )
		return "LCPL";
	else if ( self getRankXP() < 2000 )
		return "CPL";
	else if ( self getRankXP() < 3500 )
		return "SGT";
	else if ( self getRankXP() < 5500 )
		return "SSGT";
	else if ( self getRankXP() < 8000 )
		return "GYSGT";
	else if ( self getRankXP() < 11000 )
		return "MSGT";
	else if ( self getRankXP() < 15500 )
		return "MGYSGT";
	else if ( self getRankXP() < 21500 )
		return "2NDLT";
	else if ( self getRankXP() < 29500 )
		return "1STLT";
	else if ( self getRankXP() < 40000 )
		return "CAPT";
	else if ( self getRankXP() < 53500 )
		return "MAJ";
	else if ( self getRankXP() < 70500 )
		return "LTCOL";
	else if ( self getRankXP() < 94500 )
		return "COL";
	else if ( self getRankXP() < 125500 )
		return "BGEN";
	else if ( self getRankXP() < 167500 )
		return "MAJGEN";
	else if ( self getRankXP() < 233000 )
		return "LTGEN";
	else
		return "GEN";
}

/*
getRank()
{
	if ( self getRankXP() < 10 )
		return "PVT";
	else if ( self getRankXP() < 20 )
		return "PFC";
	else if ( self getRankXP() < 30 )
		return "LCPL";
	else if ( self getRankXP() < 40 )
		return "CPL";
	else if ( self getRankXP() < 50 )
		return "SGT";
	else if ( self getRankXP() < 60 )
		return "SSGT";
	else if ( self getRankXP() < 70 )
		return "GYSGT";
	else if ( self getRankXP() < 80 )
		return "MSGT";
	else if ( self getRankXP() < 90 )
		return "MGYSGT";
	else if ( self getRankXP() < 100 )
		return "2NDLT";
	else if ( self getRankXP() < 110 )
		return "1STLT";
	else if ( self getRankXP() < 120 )
		return "CAPT";
	else if ( self getRankXP() < 130 )
		return "MAJ";
	else if ( self getRankXP() < 140 )
		return "LTCOL";
	else if ( self getRankXP() < 150 )
		return "COL";
	else if ( self getRankXP() < 160 )
		return "BGEN";
	else if ( self getRankXP() < 170 )
		return "MAJGEN";
	else if ( self getRankXP() < 180 )
		return "LTGEN";
	else
		return "GEN";
}
*/

getRankXP()
{
	return self.pers["rankxp"];
}


setRankXP( amount )
{
	self.pers["rankxp"] += amount;
	self.rankxp += amount;
	self maps\mp\gametypes\_persistence_util::statSet( "stats", "rankxp", amount );
}


incRankXP( amount )
{
	xp = self getRankXP();
	self.pers["rankxp"] = (xp + amount);
	self.rankxp = (xp + amount);
	self maps\mp\gametypes\_persistence_util::statAdd( "stats", "rankxp", amount );
}
