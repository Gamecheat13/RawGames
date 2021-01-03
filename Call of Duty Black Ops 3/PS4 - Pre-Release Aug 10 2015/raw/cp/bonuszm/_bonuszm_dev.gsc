    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\clientfield_shared;

                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

#namespace bonuszm_dev;

function BZM_DevInit()
{
/#
	ExecDevgui( "devgui/devgui_bonuszm" );
	
	level thread BZM_ShowData();		
	
	level thread BZM_DebugCustomTraversals();
	
	level thread BZM_DebugSkipto();
#/	
}

/#
function BZM_ShowData()
{
	SetDvar("bonuszm_debugData", 0);
	
	while(1)
	{
		if( IsDefined( level.bonusZMSkiptoData ) && GetDvarString("bonuszm_debugData") == "1" )
		{
			PrintTopRightln( "powerdropchance" 		+ " : " + level.bonusZMSkiptoData["powerdropchance"] );
			PrintTopRightln( "maxdropammochance" 		+ " : " + level.bonusZMSkiptoData["maxdropammochance"] );
			PrintTopRightln( "cybercoredropchance" 	+ " : " + level.bonusZMSkiptoData["cybercoredropchance"] );
			PrintTopRightln( "cybercoreupgradeddropchance" 	+ " : " + level.bonusZMSkiptoData["cybercoreupgradeddropchance"] );
			
			PrintTopRightln( "weapondropchance" 		+ " : " + level.bonusZMSkiptoData["weapondropchance"] );
			PrintTopRightln( "instakilldropchance" 	+ " : " + level.bonusZMSkiptoData["instakilldropchance"] );
			PrintTopRightln( "instakillupgradeddropchance" 	+ " : " + level.bonusZMSkiptoData["instakillupgradeddropchance"] );
			
			PrintTopRightln( "powerupdropsenabled" 	+ " : " + level.bonusZMSkiptoData["powerupdropsenabled"] );
			PrintTopRightln( "waituntilskiptostarts" 	+ " : " + level.bonusZMSkiptoData["waituntilskiptostarts"] );			
			
			PrintTopRightln( "skiptoname" 		+ " : " + level.bonusZMSkiptoData["skiptoname"] );
			PrintTopRightln( "onlyuseonstart" 	+ " : " + level.bonusZMSkiptoData["onlyuseonstart"] );
			PrintTopRightln( "zombifyenabled" 		+ " : " + level.bonusZMSkiptoData["zombifyenabled"] );
			PrintTopRightln( "startunaware" 		+ " : " + level.bonusZMSkiptoData["startunaware"] );
			PrintTopRightln( "forcecleanuponcompletion" 		+ " : " + level.bonusZMSkiptoData["forcecleanuponcompletion"] );
			PrintTopRightln( "disablefailsafelogic" 		+ " : " + level.bonusZMSkiptoData["disablefailsafelogic"] );
			
			PrintTopRightln( "zigzagdeviationmin" 		+ " : " + level.bonusZMSkiptoData["zigzagdeviationmin"] );
			PrintTopRightln( "zigzagdeviationmax" 		+ " : " + level.bonusZMSkiptoData["zigzagdeviationmax"] );
			
			PrintTopRightln( "zigzagdeviationmintime" 		+ " : " + level.bonusZMSkiptoData["zigzagdeviationmintime"] );
			PrintTopRightln( "zigzagdeviationmaxtime" 		+ " : " + level.bonusZMSkiptoData["zigzagdeviationmaxtime"] );
			
			PrintTopRightln( "extraspawns" 			+ " : " + "Spawned->" + level.bzmExtraSpawnedNum + "/Dead->" + level.bzmExtraSpawnedDeadNum + "/" + level.bonusZMSkiptoData["extraspawns"] );
			PrintTopRightln( "extraspawngapmin"  		+ " : " + level.bonusZMSkiptoData["extraspawngapmin"] );
			PrintTopRightln( "walkpercent"   		+ " : " + level.bonusZMSkiptoData["walkpercent"] );
			PrintTopRightln( "runpercent"   		+ " : " + level.bonusZMSkiptoData["runpercent"] );
			PrintTopRightln( "sprintpercent"   		+ " : " + level.bonusZMSkiptoData["sprintpercent"] );
			PrintTopRightln( "levelonehealth"   		+ " : " + level.bonusZMSkiptoData["levelonehealth"] );
			PrintTopRightln( "leveltwohealth"   		+ " : " + level.bonusZMSkiptoData["leveltwohealth"] );
			PrintTopRightln( "levelthreehealth"   		+ " : " + level.bonusZMSkiptoData["levelthreehealth"] );
			PrintTopRightln( "levelonezombies"   		+ " : " + level.bonusZMSkiptoData["levelonezombies"] );
			PrintTopRightln( "leveltwozombies"   		+ " : " + level.bonusZMSkiptoData["leveltwozombies"] );
			PrintTopRightln( "levelthreezombies"   		+ " : " + level.bonusZMSkiptoData["levelthreezombies"] );			
		}
		
		wait 0.05;
	}
}







function BZM_DebugSkipto()
{
	SetDvar("bonuszm_debugskipto", 0);
	
	while(1)
	{
		if( GetDvarString("bonuszm_debugskipto") == "1" || ( isdefined( level.usingDefaultData ) && level.usingDefaultData ) )
		{	
			skiptos = GetSkipTos();
			
			if( !IsDefined( level.bzmSkiptoHud ) )
			{
				level.bzmSkiptoHud = NewHudElem();
				level.bzmSkiptoHud.alignX = "center";
				level.bzmSkiptoHud.alignY = "middle";
				level.bzmSkiptoHud.x = 200;
				level.bzmSkiptoHud.y = 100;
				level.bzmSkiptoHud.fontScale = 2;
				level.bzmSkiptoHud.sort = 20;
				level.bzmSkiptoHud.alpha = 1;
				level.bzmSkiptoHud.color = ( 0.8, 0.8, 0.8 );
				level.bzmSkiptoHud.font = "small";			
			}
			
			prefix = "";
			
			if( ( isdefined( level.usingDefaultData ) && level.usingDefaultData ) )
			{
				prefix = "[DEFAULT]";
			}
			
			if( IsDefined( level.current_skipto ) )
				level.bzmSkiptoHud SetText( prefix + " Skipto:" + level.current_skipto );
			else
				level.bzmSkiptoHud SetText( prefix + " Skipto:" + "" );
		}	
		else
		{
			if( IsDefined( level.bzmSkiptoHud ) )
			{
				level.bzmSkiptoHud Destroy();
			}
		}
		
		wait 0.05;
	}
}


function BZM_DebugCustomTraversals()
{
	SetDvar("bonuszm_dumpCustomTraversals", 0);
	
	nodes = GetAllNodes();
	
	while(1)
	{
		if( GetDvarString("bonuszm_dumpCustomTraversals") == "1" )
		{
			level._bzmCustomTraversals = [];
			
			foreach( node in nodes )
			{
				if(node.type == "Begin" || node.type == "End")
				{
					if(IsDefined(node.script_noteworthy) && node.script_noteworthy == "custom_traversal")
					{
						if( !IsInArray(level._bzmCustomTraversals, node.animscript) )
							level._bzmCustomTraversals[level._bzmCustomTraversals.size] = node.animscript;
					}
				}
			}
			
			foreach( animscript in level._bzmCustomTraversals )
			{
				println( "BZM_CUSTOM_TRAVERSAL:" + animscript );
			}
		}	
		
		SetDvar("bonuszm_dumpCustomTraversals", 0);	
		
		wait 0.1;
	}
	
	
}
#/