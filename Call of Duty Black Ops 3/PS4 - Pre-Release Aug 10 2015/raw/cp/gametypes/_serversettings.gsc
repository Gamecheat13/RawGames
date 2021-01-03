#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace serversettings;

function autoexec __init__sytem__() {     system::register("serversettings",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );
}

function init()
{
	level.hostname = GetDvarString( "sv_hostname");
	if(level.hostname == "")
		level.hostname = "CoDHost";
	SetDvar("sv_hostname", level.hostname);
	SetDvar("ui_hostname", level.hostname);
	//makeDvarServerInfo("ui_hostname", "CoDHost");

	level.motd = GetDvarString( "scr_motd" );
	if(level.motd == "")
		level.motd = "";
	SetDvar("scr_motd", level.motd);
	SetDvar("ui_motd", level.motd);
	//makeDvarServerInfo("ui_motd", "");

	level.allowvote = GetDvarString( "g_allowvote");
	if(level.allowvote == "")
		level.allowvote = "1";
	SetDvar("g_allowvote", level.allowvote);
	SetDvar("ui_allowvote", level.allowvote);
	//makeDvarServerInfo("ui_allowvote", "1");
	
	level.allow_teamchange = "0";
	if( SessionModeIsPrivate() || !SessionModeIsOnlinegame() )
	{
			level.allow_teamchange = "1";
	}
	SetDvar("ui_allow_teamchange", level.allow_teamchange);


	level.friendlyfire = GetGametypeSetting( "friendlyfiretype" );

	SetDvar("ui_friendlyfire", level.friendlyfire);
	//makeDvarServerInfo("ui_friendlyfire", "0");

	if(GetDvarString( "scr_mapsize") == "")
		SetDvar("scr_mapsize", "64");
	else if(GetDvarfloat( "scr_mapsize") >= 64)
		SetDvar("scr_mapsize", "64");
	else if(GetDvarfloat( "scr_mapsize") >= 32)
		SetDvar("scr_mapsize", "32");
	else if(GetDvarfloat( "scr_mapsize") >= 16)
		SetDvar("scr_mapsize", "16");
	else
		SetDvar("scr_mapsize", "8");
	level.mapsize = GetDvarfloat( "scr_mapsize");

	constrain_gametype(GetDvarString( "g_gametype"));
	constrain_map_size(level.mapsize);

	for(;;)
	{
		update();
		wait 5;
	}
}

function update()
{
	sv_hostname = GetDvarString( "sv_hostname");
	if(level.hostname != sv_hostname)
	{
		level.hostname = sv_hostname;
		SetDvar("ui_hostname", level.hostname);
	}

	scr_motd = GetDvarString( "scr_motd");
	if(level.motd != scr_motd)
	{
		level.motd = scr_motd;
		SetDvar("ui_motd", level.motd);
	}

	g_allowvote = GetDvarString( "g_allowvote");
	if(level.allowvote != g_allowvote)
	{
		level.allowvote = g_allowvote;
		SetDvar("ui_allowvote", level.allowvote);
	}
		
	scr_friendlyfire = GetGametypeSetting( "friendlyfiretype" );
	if(level.friendlyfire != scr_friendlyfire)
	{
		level.friendlyfire = scr_friendlyfire;
		SetDvar("ui_friendlyfire", level.friendlyfire);
	}
}

function constrain_gametype(gametype)
{
	entities = getentarray();
	for(i = 0; i < entities.size; i++)
	{
		entity = entities[i];
		
		if(gametype == "dm")
		{
			if(isdefined(entity.script_gametype_dm) && entity.script_gametype_dm != "1")
			{
				//iprintln("DELETED(GameType): ", entity.classname);
				entity delete();
			}
		}
		else if(gametype == "tdm")
		{
			if(isdefined(entity.script_gametype_tdm) && entity.script_gametype_tdm != "1")
			{
				//iprintln("DELETED(GameType): ", entity.classname);
				entity delete();
			}
		}
		else if(gametype == "ctf")
		{
			if(isdefined(entity.script_gametype_ctf) && entity.script_gametype_ctf != "1")
			{
				//iprintln("DELETED(GameType): ", entity.classname);
				entity delete();
			}
		}
		else if(gametype == "hq")
		{
			if(isdefined(entity.script_gametype_hq) && entity.script_gametype_hq != "1")
			{
				//iprintln("DELETED(GameType): ", entity.classname);
				entity delete();
			}
		}
		else if(gametype == "sd")
		{
			if(isdefined(entity.script_gametype_sd) && entity.script_gametype_sd != "1")
			{
				//iprintln("DELETED(GameType): ", entity.classname);
				entity delete();
			}
		}
		else if(gametype == "koth")
		{
			if(isdefined(entity.script_gametype_koth) && entity.script_gametype_koth != "1")
			{
				//iprintln("DELETED(GameType): ", entity.classname);
				entity delete();
			}
		}
	}
}

function constrain_map_size(mapsize)
{
	entities = getentarray();
	for(i = 0; i < entities.size; i++)
	{
		entity = entities[i];
		
		if(int(mapsize) == 8)
		{
			if(isdefined(entity.script_mapsize_08) && entity.script_mapsize_08 != "1")
			{
				//iprintln("DELETED(MapSize): ", entity.classname);
				entity delete();
			}
		}
		else if(int(mapsize) == 16)
		{
			if(isdefined(entity.script_mapsize_16) && entity.script_mapsize_16 != "1")
			{
				//iprintln("DELETED(MapSize): ", entity.classname);
				entity delete();
			}
		}
		else if(int(mapsize) == 32)
		{
			if(isdefined(entity.script_mapsize_32) && entity.script_mapsize_32 != "1")
			{
				//iprintln("DELETED(MapSize): ", entity.classname);
				entity delete();
			}
		}
		else if(int(mapsize) == 64)
		{
			if(isdefined(entity.script_mapsize_64) && entity.script_mapsize_64 != "1")
			{
				//iprintln("DELETED(MapSize): ", entity.classname);
				entity delete();
			}
		}
	}
}