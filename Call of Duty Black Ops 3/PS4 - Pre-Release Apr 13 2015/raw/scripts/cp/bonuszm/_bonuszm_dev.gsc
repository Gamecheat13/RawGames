    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\clientfield_shared;


#namespace bonuszm_dev;



function SetupDevgui()
{
/#
	execdevgui( "devgui/devgui_bonuszm" );
	level thread DevguiThink();
#/	
}

function DevguiThink()
{
/*
	SetDvar( "zombie_devgui", "" );
	SetDvar( "scr_spawn_pickup", "" );
	SetDvar( "scr_spawn_room", "" );
//	SetDvar( "scr_zombie_round", "1" );

	while(1)
	{
		cmd = GetDvarString( "zombie_devgui" );
		if ( cmd == "" )
		{
			wait 0.5;
			continue;
		}
		
		switch ( cmd )
		{
			case "money":
				iprintln( "big money, BIG PRIZES!" );
				level thread doa_pickups::spawnMoneyGlob();
				level thread doa_pickups::spawnMoneyGlob(true);
			break;
			case "gem":
				iprintln( "Gem Launching!" );
				players = GetPlayers();
				for (i=0;i<players.size;i++)
				{
					level thread doa_pickups::spawnUberTreasure(players[i].origin, 4, 10, true, true );
				}
			break;
			case "gemX":
				iprintln( "Gem Launching!" );
				players = GetPlayers();
				scale = int(GetDvarString( "scr_spawn_pickup" ));
				for (i=0;i<players.size;i++)
				{
					level thread doa_pickups::spawnUberTreasure(players[i].origin, 1, 10, true, true,scale );
				}
			break;
			case "life":
				iprintln( "extra life granted" );
				players = GetPlayers();
				for (i=0;i<players.size;i++)
				{
					players[i] thread doa_pickups::directedItemAwardTo(players[i],"zombietron_extra_life");
					players[i] thread doa_pickups::directedItemAwardTo(players[i],"zombietron_extra_life");
					players[i] thread doa_pickups::directedItemAwardTo(players[i],"zombietron_extra_life");
					players[i] thread doa_pickups::directedItemAwardTo(players[i],"zombietron_extra_life");
				}
			break;
			case "bomb":
				iprintln( "extra bomb granted" );
				players = GetPlayers();
				for (i=0;i<players.size;i++)
				{
					players[i] thread doa_pickups::directedItemAwardTo(players[i],"zombietron_nuke");
					players[i] thread doa_pickups::directedItemAwardTo(players[i],"zombietron_nuke");
					players[i] thread doa_pickups::directedItemAwardTo(players[i],"zombietron_nuke");
					players[i] thread doa_pickups::directedItemAwardTo(players[i],"zombietron_nuke");
				}
			break;
			case "boost":
				iprintln( "extra boost granted" );
				players = GetPlayers();
				for (i=0;i<players.size;i++)
				{
					players[i] thread doa_pickups::directedItemAwardTo(players[i],"zombietron_lightning_bolt");
					players[i] thread doa_pickups::directedItemAwardTo(players[i],"zombietron_lightning_bolt");
					players[i] thread doa_pickups::directedItemAwardTo(players[i],"zombietron_lightning_bolt");
					players[i] thread doa_pickups::directedItemAwardTo(players[i],"zombietron_lightning_bolt");
				}
			break;
			case "pickup":
				iprintln( "spawning pickup" );
				level thread doa_pickups::spawnSpecificItem(GetDvarString( "scr_spawn_pickup" ));
			break;
			case "magic_room":
				level.doa.forced_magical_room = GetDvarInt("scr_spawn_room");
				if ( level.doa.forced_magical_room == ROOM_TYPE_JUDGEMENT )
				{
					players = GetPlayers();
					for (i=0;i<players.size;i++)
					{
						if ( players[i].doa.fate == FATE_TYPE_NONE )
						{
							players[i] doa_fate::awardFate(RandomIntRange(FATE_TYPE_FIREPOWER,FATE_TYPE_FEET+1));
						}
					}
				}
				flag::clear("doa_round_active");	
				wait 1;
				doa_utility::killAllEnemy();
			break;
			
			case "fate":
				iprintln( "Fating you" );
				level.doa.fates_have_been_chosen = true;
				players = GetPlayers();
				for (i=0;i<players.size;i++)
				{
					type = GetDvarInt( "scr_spawn_pickup" );
					if (type < FATE_TYPE_FURY )
					{
						players[i] doa_fate::awardFate(type) ;
					}
					else
					{
						type1 = type-9;
						players[i] doa_fate::awardFate(type1) ;
						wait 1;	
						players[i] doa_fate::awardFate(type) ;
					}
				}
			break;
			case "all_pickups":
				iprintln( "spawning ALL pickups" );
				for (i=0;i<level.doa.pickups.items.size;i++)
				{
					level thread doa_pickups::spawnSpecificItem(level.doa.pickups.items[i].gdtname);
				}
			break;
			case "round":
				level.doa.dev_level_skipped  = GetDvarInt( #"scr_zombie_round" )-1;
				flag::clear("doa_round_active");	
				SetDvar("timescale", "10");
				wait 1;
				doa_utility::killAllEnemy();
				break;
			case "round_next":
				flag::clear("doa_round_active");	
				doa_utility::killAllEnemy();
				wait 1;
				doa_utility::killAllEnemy();
			break;
			case "kill":
				iprintln( "death has been notified ..." );
				players = GetPlayers();
				if (players.size == 1 )
				{
					player = players[0];
				}
				else
				{
					player = players[RandomInt(players.size)];
				}
				player DoDamage(player.health+100,player.origin);
			break;
			case "kill_all":
				iprintln( "death to all..." );
				players = GetPlayers();
				for(i=0;i<players.size;i++)
				{
					player[i] DoDamage(player[i].health+100,player[i].origin);
				}
			break;
		}

		SetDvar( "zombie_devgui", "" );
	}
*/
}