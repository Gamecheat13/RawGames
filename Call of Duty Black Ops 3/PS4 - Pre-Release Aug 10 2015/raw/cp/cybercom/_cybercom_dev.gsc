    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                     	   	                                                                      	  	  	
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\clientfield_shared;

#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;

#namespace cybercom_dev;



function debugPoint(point,timeSec,size,color)
{
	end = GetTime()+(timeSec*1000);
	halfWidth = int(size/2);
	l1 = point + (-halfWidth,0,0);
	l2 = point + (halfWidth,0,0);
	w1 = point + (0,-halfWidth,0);
	w2 = point + (0,halfWidth,0);
	h1 = point + (0,0,-halfWidth);
	h2 = point + (0,0,halfWidth);
	while( end>GetTime() )
	{
/#
		line( l1, l2, color, 1, 0, 1 );
		line( w1, w2, color, 1, 0, 1 );
		line( h1, h2, color, 1, 0, 1 );
#/	
		{wait(.05);};
	}
}

function cybercom_SetupDevgui()
{
/#
	execdevgui( "devgui/devgui_cyber" );
	level thread cybercom_DevguiThink();
#/	
}

function constantJuice()
{
	self notify("constantJuice");
	self endon("constantJuice");
	self endon("disconnect");
	self endon("spawned");
	while(1)
	{
		wait 1;
		if (( isdefined( self.cybercom.block_juice ) && self.cybercom.block_juice ))
			continue;
		if (isDefined(self.cybercom.activeCybercomWeapon))
		{
			slot = self GadgetGetSlot(self.cybercom.activeCybercomWeapon);
			isCharging = self GadgetCharging(slot);			//if gadget is charging, boost it
			if(isCharging)
				self GadgetPowerChange( slot, 100 );
		}
	}
}


function cybercom_DevguiThink()
{
	SetDvar( "devgui_cybercore", "" );
	SetDvar( "devgui_cybercore_upgrade", "" );

	while(1)
	{
		cmd = GetDvarString( "devgui_cybercore" );
		if ( cmd == "" )
		{
			wait 0.5;
			continue;
		}
		playerNum = GetDvarInt( "scr_player_number" )-1;
		players = GetPlayers();
		if(playerNum >= players.size)
		{
			SetDvar( "devgui_cybercore", "" );
			SetDvar( "devgui_cybercore_upgrade", "" );
			iprintlnbold("Invalid Player specified. Use SET PLAYER NUMBER in Cybercom DEVGUI to set valid player");
			continue;
		}
		if(cmd == "juiceme")
		{
			SetDvar( "devgui_cybercore", "" );
			SetDvar( "devgui_cybercore_upgrade", "" );
			iprintlnbold("Giving Constant Juice to all players");
			foreach(player in players)
			{
				player thread constantJuice();
			}
			continue;
		}
		
		if(cmd == "clearAll")
		{
			iprintlnbold("Clearing all abilities on all players");
			foreach(player in players)
			{
				player cybercom_tacrig::takeAllRigAbilities();
				player cybercom_gadget::takeAllAbilities();
			}
			SetDvar( "devgui_cybercore", "" );
			SetDvar( "devgui_cybercore_upgrade", "" );
			continue;
		}
		if(cmd == "giveAll")
		{
			iprintlnbold("Giving all abilities on all players");
			foreach(player in players)
			{
				//player cybercom_tacrig::giveAllRigAbilities();
				player cybercom_gadget::giveAllAbilities();
			}
			SetDvar( "devgui_cybercore", "" );
			SetDvar( "devgui_cybercore_upgrade", "" );
			continue;
		}
		
		player = players[playerNum];
		playerNum++;
		upgrade = GetDvarInt( "devgui_cybercore_upgrade" );		
		
		if(cmd == "clearPlayer")
		{
			iprintlnbold("Clearing abilities on player: " + playerNum);
			player cybercom_tacrig::takeAllRigAbilities();
			player cybercom_gadget::takeAllAbilities();
			SetDvar( "devgui_cybercore", "" );
			SetDvar( "devgui_cybercore_upgrade", "" );
			continue;
		}
		else
		if(cmd == "control")
		{
//			player SetCyberComAbilitiesByType(CCOM_TYPE_CONTROL,upgrade);
			SetDvar( "devgui_cybercore", "" );
			SetDvar( "devgui_cybercore_upgrade", "" );
			continue;
		}
		else
		if(cmd == "martial")
		{
//			player SetCyberComAbilitiesByType(CCOM_TYPE_MARTIAL,upgrade);
			SetDvar( "devgui_cybercore", "" );
			SetDvar( "devgui_cybercore_upgrade", "" );
			continue;
		}
		else
		if(cmd == "chaos")
		{
//			player SetCyberComAbilitiesByType(CCOM_TYPE_CHAOS,upgrade);
			SetDvar( "devgui_cybercore", "" );
			SetDvar( "devgui_cybercore_upgrade", "" );
			continue;
		}
		
		if( isDefined( level._cybercom_rig_ability[ cmd ] ))
			player cybercom_tacrig::giveRigAbility( cmd, upgrade );
		else		
			player cybercom_gadget::giveAbility(cmd,upgrade);
			
		iprintlnbold("Adding ability on player: " + playerNum +" --> "+cmd+"  Upgraded:"+(upgrade?"TRUE":"FALSE"));
		

		SetDvar( "devgui_cybercore", "" );
		SetDvar( "devgui_cybercore_upgrade", "" );
	}
}

