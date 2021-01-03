#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_rank;

#using scripts\cp\_util;

#precache( "lui_menu", "FadeToBlack" );
#precache( "menu", "team_marinesopfor" );
#precache( "menu", "StartMenu_Main" );
#precache( "menu", "class" );
#precache( "menu", "ChooseClass_InGame" );
#precache( "menu", "ingame_controls" );
#precache( "menu", "ingame_options" );
#precache( "menu", "popup_leavegame" );
#precache( "menu", "spectate" );
#precache( "eventstring", "open_ingame_menu" );
#precache( "string", "MP_HOST_ENDED_GAME" );
#precache( "string", "MP_HOST_ENDGAME_RESPONSE" );

#namespace menus;

function autoexec __init__sytem__() {     system::register("menus",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );
	callback::on_connect( &on_player_connect );
}

function init()
{
	game["menu_team"] = "team_marinesopfor";
	game["menu_start_menu"] = "StartMenu_Main";
	game["menu_class"] = "class";
	game["menu_changeclass"] = "ChooseClass_InGame";
	game["menu_changeclass_offline"] = "ChooseClass_InGame";

	foreach( team in level.teams )
	{
		game["menu_changeclass_" + team ] = "ChooseClass_InGame";
	}
	
	game["menu_controls"] = "ingame_controls";
	game["menu_options"] = "ingame_options";
	game["menu_leavegame"] = "popup_leavegame";
}

function on_player_connect()
{	
	self thread on_menu_response();
}

function on_menu_response()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		//println( self getEntityNumber() + " menuresponse: " + menu + " " + response );
		
		//iprintln("^6", response);
			
		if ( response == "back" )
		{
			self closeInGameMenu();

			if ( level.console )
			{
				if( menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_team"] || menu == game["menu_controls"] )
				{
//					assert( isdefined( level.teams[self.pers["team"]] ) );
	
					if( isdefined( level.teams[self.pers["team"]] ) )
					{
						self openMenu( game["menu_start_menu"] );
					}
				}
			}
			continue;
		}
		
		if(response == "changeteam" && level.allow_teamchange == "1")
		{
			self closeInGameMenu();
			self openMenu(game["menu_team"]);
		}
							
		if(response == "endgame")
		{
			// TODO: replace with onSomethingEvent call 
			if(level.splitscreen)
			{
				//if ( level.console )
				//	endparty();
				level.skipVote = true;

				if ( !level.gameEnded )
				{
					level thread globallogic::forceEnd();
				}
			}
				
			continue;
		}
		
		if(response == "killserverpc")
		{
				level thread globallogic::killserverPc();
				
			continue;
		}

		if ( response == "endround" )
		{
			if ( !level.gameEnded )
			{
				self globallogic::gameHistoryPlayerQuit();
				self closeInGameMenu();

//				level notify("end_game");
				level thread globallogic::forceEnd();
			}
			else
			{
				self closeInGameMenu();
				self iprintln( &"MP_HOST_ENDGAME_RESPONSE" );
			}			
			continue;
		}

		if(menu == game["menu_team"] && level.allow_teamchange == "1")
		{
			switch(response)
			{
			case "autoassign":
				self [[level.autoassign]]( true );
				break;

			case "spectator":
				self [[level.spectator]]();
				break;
				
			default:
				self [[level.teamMenu]](response);
				break;
			}
		}	// the only responses remain are change class events
		else if( menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] )
		{
			if ( response != "back" && response != "cancel" && (!isdefined(self.disableClassCallback) || !self.disableClassCallback) )
			{
				self closeInGameMenu();
				
				if(  level.rankedMatch && isSubstr(response, "custom") )
				{
					if ( self IsItemLocked( rank::GetItemIndex( "feature_cac" ) ) )
					kick( self getEntityNumber() );
				}
	
				self.selectedClass = true;
				self [[level.curClass]](response);
			}
		}
		else if ( menu == "spectate" )
		{
			player = util::getPlayerFromClientNum( int( response ) );
			if ( isdefined ( player ) )
			{
				self SetCurrentSpectatorClient( player );
			}
		}
	}
}

/*
// sort response message from CAC menu
function cacMenuStatOffset( menu, response )
{
	stat_offset = -1;
	
	if( menu == "menu_cac_assault" )
		stat_offset = 0;
	else if( menu == "menu_cac_specops" )
		stat_offset = 10;
	else if( menu == "menu_cac_heavygunner" )
		stat_offset = 20;
	else if( menu == "menu_cac_demolitions" )
		stat_offset = 30;
	else if( menu == "menu_cac_sniper" )
		stat_offset = 40;
	
	assert( stat_offset >= 0, "The response: " + response + " came from non-CAC menu" );	
	
	return stat_offset;
}
*/
