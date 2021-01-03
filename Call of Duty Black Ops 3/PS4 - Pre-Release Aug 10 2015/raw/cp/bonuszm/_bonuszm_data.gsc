#using scripts\codescripts\struct;

#using scripts\cp\bonuszm\_bonuszm_spawner_shared;
#using scripts\cp\bonuszm\_bonuszm;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

#namespace bonuszmdata;

function autoexec BZM_ScriptBundle()
{
	level.bonusZmData = struct::get_script_bundle( "bonuszmdata", GetDvarString( "mapname" ) );	
}

function BZM_FillDataFromForSkipto( mapName, checkPointName )
{	
	level.bonusZMSkiptoData = undefined; // clear previous info
	
	if( !IsDefined( level.bonusZmData ) )
	{		
		BZM_SetupAITypeData();
		BZM_SetupDefaultData( true, false );
		BZM_ValidateData();
		
		BonusZMSpawner::BZM_SpawnerInit();
		
		return;
	}

	skiptoIndex = undefined;
	prefix = "";
	
	numSkiptos = GetStructField( level.bonusZmData, "skiptocount" );
	
	if( !IsDefined( numSkiptos ) )
		numSkiptos = 0;
	
	for( i = 1; i <= numSkiptos; i++ )
	{
		prefix 		= BZM_GetSkiptoPrefix( i );
		skiptoName 	= GetStructField( level.bonusZmData, prefix + "skiptoname" );
		
		if( skiptoName == checkPointName )
		{
			skiptoIndex = i;
			break;
		}
	}	
	
	level.bonusZMSkiptoData = [];
	
	if( !IsDefined( skiptoIndex ) )
	{		
		/#
		level.usingDefaultData = true;
		#/
			
		BZM_SetupAITypeData();
		BZM_SetupDefaultData( true, false );
		BZM_ValidateData();
		
		BonusZMSpawner::BZM_SpawnerInit();
		
		return;
	}
	
	/#
	level.usingDefaultData = false;
	#/
		
		
	level.bonusZMSkiptoData["skiptoname"] 		= skiptoName;
		
	level.bonusZMSkiptoData["powerdropchance"] 	= GetStructField( level.bonusZmData, "powerdropchance" );	
	level.bonusZMSkiptoData["cybercoredropchance"] = GetStructField( level.bonusZmData, "cybercoredropchance" );	
	level.bonusZMSkiptoData["cybercoreupgradeddropchance"] = GetStructField( level.bonusZmData, "cybercoreupgradeddropchance" );	
	
	level.bonusZMSkiptoData["maxdropammochance"] 	= GetStructField( level.bonusZmData, "maxdropammochance" );	
	level.bonusZMSkiptoData["weapondropchance"] 	= GetStructField( level.bonusZmData, "weapondropchance" );	
	level.bonusZMSkiptoData["instakilldropchance"] = GetStructField( level.bonusZmData, "instakilldropchance" );

	level.bonusZMSkiptoData["instakillupgradeddropchance"] = GetStructField( level.bonusZmData, "instakillupgradeddropchance" );
		
	level.bonusZMSkiptoData["powerupdropsenabled"] 		= GetStructField( level.bonusZmData, prefix + "powerupdropsenabled" );	
	
	level.bonusZMSkiptoData["zigzagdeviationmin"] 		= GetStructField( level.bonusZmData, prefix + "zigzagdeviationmin" );	
	level.bonusZMSkiptoData["zigzagdeviationmax"] 		= GetStructField( level.bonusZmData, prefix + "zigzagdeviationmax" );	
		
	level.bonusZMSkiptoData["zigzagdeviationmintime"] 		= GetStructField( level.bonusZmData, prefix + "zigzagdeviationmintime" );	
	level.bonusZMSkiptoData["zigzagdeviationmaxtime"] 		= GetStructField( level.bonusZmData, prefix + "zigzagdeviationmaxtime" );
	
	level.bonusZMSkiptoData["onlyuseonstart"] 	= GetStructField( level.bonusZmData, prefix + "onlyuseonstart" );	
	level.bonusZMSkiptoData["zombifyenabled"] 		= GetStructField( level.bonusZmData, prefix + "zombifyenabled" );	
	
	level.bonusZMSkiptoData["startunaware"] 		= GetStructField( level.bonusZmData, prefix + "startunaware" );
	level.bonusZMSkiptoData["alertnessspreaddelay"] = GetStructField( level.bonusZmData, prefix + "alertnessspreaddelay" );
	
	level.bonusZMSkiptoData["forcecleanuponcompletion"] 		= GetStructField( level.bonusZmData, prefix + "forcecleanuponcompletion" );
	level.bonusZMSkiptoData["disablefailsafelogic"] 		= GetStructField( level.bonusZmData, prefix + "disablefailsafelogic" );
			
	level.bonusZMSkiptoData["extraspawns"] 			= GetStructField( level.bonusZmData, prefix + "extraspawns" );
	level.bonusZMSkiptoData["extraspawngapmin"] 		= GetStructField( level.bonusZmData, prefix + "extraspawngapmin" );
	
	level.bonusZMSkiptoData["walkpercent"] 			= GetStructField( level.bonusZmData, prefix + "walkpercent" );
	level.bonusZMSkiptoData["runpercent"] 			= GetStructField( level.bonusZmData, prefix + "runpercent" );
	level.bonusZMSkiptoData["sprintpercent"] 		= GetStructField( level.bonusZmData, prefix + "sprintpercent" );
	
	level.bonusZMSkiptoData["levelonehealth"] 		= GetStructField( level.bonusZmData, prefix + "levelonehealth" );
	level.bonusZMSkiptoData["leveltwohealth"] 		= GetStructField( level.bonusZmData, prefix + "leveltwohealth" );
	level.bonusZMSkiptoData["levelthreehealth"] 		= GetStructField( level.bonusZmData, prefix + "levelthreehealth" );
	
	level.bonusZMSkiptoData["levelonezombies"] 			= GetStructField( level.bonusZmData, prefix + "levelonezombies" );
	level.bonusZMSkiptoData["leveltwozombies"] 			= GetStructField( level.bonusZmData, prefix + "leveltwozombies" );
	level.bonusZMSkiptoData["levelthreezombies"] 			= GetStructField( level.bonusZmData, prefix + "levelthreezombies" );
	
	level.bonusZMSkiptoData["suicidalzombiechance"] 		= GetStructField( level.bonusZmData, prefix + "suicidalzombiechance" );
	
	level.bonusZMSkiptoData["zombiehealthscale1"] 		= GetStructField( level.bonusZmData, "zombiehealthscale1" );
	level.bonusZMSkiptoData["zombiehealthscale2"] 		= GetStructField( level.bonusZmData, "zombiehealthscale2" );
	level.bonusZMSkiptoData["zombiehealthscale3"] 		= GetStructField( level.bonusZmData, "zombiehealthscale3" );
	level.bonusZMSkiptoData["zombiehealthscale4"] 		= GetStructField( level.bonusZmData, "zombiehealthscale4" );
	level.bonusZMSkiptoData["zombiehealthscale5"] 		= GetStructField( level.bonusZmData, "zombiehealthscale5" );
	
	level.bonusZMSkiptoData["extrazombiescale1"] 	= GetStructField( level.bonusZmData, "extrazombiescale1" );
	level.bonusZMSkiptoData["extrazombiescale2"] 	= GetStructField( level.bonusZmData, "extrazombiescale2" );
	level.bonusZMSkiptoData["extrazombiescale3"] 	= GetStructField( level.bonusZmData, "extrazombiescale3" );
	level.bonusZMSkiptoData["extrazombiescale4"] 	= GetStructField( level.bonusZmData, "extrazombiescale4" );
		
	level.bonusZMSkiptoData["magicboxonlyweaponchance"] 	= GetStructField( level.bonusZmData, "magicboxonlyweaponchance" );
	level.bonusZMSkiptoData["maxmagicboxonlyweapons"] 		= GetStructField( level.bonusZmData, "maxmagicboxonlyweapons" );
	
	BZM_SetupAITypeData();
	BZM_SetupDefaultData( false, true );
	BZM_ValidateData();
	
	BonusZMSpawner::BZM_SpawnerInit();
	
	BonusZMSpawner::BZM_SpawnerSetupSkipto();
	bonuszm::BZM_SetupZombieCustomSpawnFunction();
	
	// Zigzag deviation values for the skipto
	level._zombieZigZagDistanceMin 	= level.bonusZMSkiptoData["zigzagdeviationmin"]; 
	level._zombieZigZagDistanceMax 	= level.bonusZMSkiptoData["zigzagdeviationmax"];
	level._zombieZigZagTimeMin 		= level.bonusZMSkiptoData["zigzagdeviationmintime"];
	level._zombieZigZagTimeMax 		= level.bonusZMSkiptoData["zigzagdeviationmaxtime"];
	
}

function BZM_SetupAITypeData()
{
	if( !IsDefined( level.bonusZmData ) )
		return;
	
	if( !IsDefined( level.bonusZMSkiptoData ) )
		return;		
	
	level.bonusZMSkiptoData["aitypeMale1"] 			= GetStructField( level.bonusZmData, "aitypeMale1" );
	level.bonusZMSkiptoData["aitypeMale2"] 			= GetStructField( level.bonusZmData, "aitypeMale2" );
	level.bonusZMSkiptoData["aitypeMale3"] 			= GetStructField( level.bonusZmData, "aitypeMale3" );
	level.bonusZMSkiptoData["aitypeMale4"] 			= GetStructField( level.bonusZmData, "aitypeMale4" );
	
	level.bonusZMSkiptoData["maleSpawnChance2"] 	= GetStructField( level.bonusZmData, "maleSpawnChance2" );
	level.bonusZMSkiptoData["maleSpawnChance3"] 	= GetStructField( level.bonusZmData, "maleSpawnChance3" );
	level.bonusZMSkiptoData["maleSpawnChance4"] 	= GetStructField( level.bonusZmData, "maleSpawnChance4" );	
	
	level.bonusZMSkiptoData["aitypeFemale"] 		= GetStructField( level.bonusZmData, "aitypeFemale" );
	level.bonusZMSkiptoData["femaleSpawnChance"] 	= GetStructField( level.bonusZmData, "femaleSpawnChance" );
}

function BZM_SetupDefaultData( zombify, takeCareOfUndefinedValues )
{
	if( !IsDefined( level.bonusZMSkiptoData["powerdropchance"] ) )
	{
		if( IsDefined( level.bonusZmData ) )
		{
			level.bonusZMSkiptoData["powerdropchance"] 	= GetStructField( level.bonusZmData, "powerdropchance" );
			
			if( !IsDefined( level.bonusZMSkiptoData["powerdropchance"] ) )
			{
				level.bonusZMSkiptoData["powerdropchance"] = 0;
			}
		}
		else
		{
			level.bonusZMSkiptoData["powerdropchance"] 	= 40;
		}
	}
	
	if( !IsDefined( level.bonusZMSkiptoData["maxdropammochance"] ) )
	{
		if( IsDefined( level.bonusZmData ) )
		{
			level.bonusZMSkiptoData["maxdropammochance"] 	= GetStructField( level.bonusZmData, "maxdropammochance" );
						
			if( !IsDefined( level.bonusZMSkiptoData["maxdropammochance"] ) )
			{
				level.bonusZMSkiptoData["maxdropammochance"] = 0;
			}
		}
		else
		{
			level.bonusZMSkiptoData["maxdropammochance"] 	= 50;	
		}
	}			
	
	if( !IsDefined( level.bonusZMSkiptoData["cybercoredropchance"] ) )
	{
		if( IsDefined( level.bonusZmData ) )
		{
			level.bonusZMSkiptoData["cybercoredropchance"] 	= GetStructField( level.bonusZmData, "cybercoredropchance" );
			
			if( !IsDefined( level.bonusZMSkiptoData["cybercoredropchance"] ) )
			{
				level.bonusZMSkiptoData["cybercoredropchance"] = 0;
			}
		}
		else
		{
			level.bonusZMSkiptoData["cybercoredropchance"] = 30;
		}
	}			
	
	if( !IsDefined( level.bonusZMSkiptoData["cybercoreupgradeddropchance"] ) )
	{
		if( IsDefined( level.bonusZmData ) )
		{
			level.bonusZMSkiptoData["cybercoreupgradeddropchance"] 	= GetStructField( level.bonusZmData, "cybercoreupgradeddropchance" );
			
			if( !IsDefined( level.bonusZMSkiptoData["cybercoreupgradeddropchance"] ) )
			{
				level.bonusZMSkiptoData["cybercoreupgradeddropchance"] = 0;
			}
		}
		else
		{
			level.bonusZMSkiptoData["cybercoreupgradeddropchance"] = 0;
		}
	}				
	
	
	if( !IsDefined( level.bonusZMSkiptoData["rapsdropchance"] ) )
	{
		if( IsDefined( level.bonusZmData ) )
		{
			level.bonusZMSkiptoData["rapsdropchance"] 	= GetStructField( level.bonusZmData, "rapsdropchance" );
			
			if( !IsDefined( level.bonusZMSkiptoData["rapsdropchance"] ) )
			{
				level.bonusZMSkiptoData["rapsdropchance"] = 0;
			}
		}
		else
		{
			level.bonusZMSkiptoData["rapsdropchance"] = 0;
		}
	}				
	
	if( !IsDefined( level.bonusZMSkiptoData["weapondropchance"] ) )
	{
		if( IsDefined( level.bonusZmData ) )
		{
			level.bonusZMSkiptoData["weapondropchance"] 	= GetStructField( level.bonusZmData, "weapondropchance" );
			
			
			if( !IsDefined( level.bonusZMSkiptoData["weapondropchance"] ) )
			{
				level.bonusZMSkiptoData["weapondropchance"] = 0;
			}
		}
		else
		{
			level.bonusZMSkiptoData["weapondropchance"] 	= 20;
		}
	}		
	
	if( !IsDefined( level.bonusZMSkiptoData["instakilldropchance"] ) )
	{
		if( IsDefined( level.bonusZmData ) )
		{
			level.bonusZMSkiptoData["instakilldropchance"] 	= GetStructField( level.bonusZmData, "instakilldropchance" );
			
			if( !IsDefined( level.bonusZMSkiptoData["instakilldropchance"] ) )
			{
				level.bonusZMSkiptoData["instakilldropchance"] = 0;
			}
		}
		else
		{
			level.bonusZMSkiptoData["powerdropchance"] 	= 15;
		}
	}		
	
	if( !IsDefined( level.bonusZMSkiptoData["instakillupgradeddropchance"] ) )
	{
		if( IsDefined( level.bonusZmData ) )
		{
			level.bonusZMSkiptoData["instakillupgradeddropchance"] 	= GetStructField( level.bonusZmData, "instakillupgradeddropchance" );
			
			if( !IsDefined( level.bonusZMSkiptoData["instakillupgradeddropchance"] ) )
			{
				level.bonusZMSkiptoData["instakillupgradeddropchance"] = 0;
			}
		}
		else
		{
			level.bonusZMSkiptoData["instakillupgradeddropchance"] 	= 0;
		}
	}	
	
	if( !IsDefined( level.bonusZMSkiptoData["powerupdropsenabled"] ) )
		level.bonusZMSkiptoData["powerupdropsenabled"] 	= false;
	
	if( !IsDefined( level.bonusZMSkiptoData["waituntilskiptostarts"] ) )
		level.bonusZMSkiptoData["waituntilskiptostarts"] 	= false;
		
	if( !IsDefined( level.bonusZMSkiptoData["skiptoname"] ) )
		level.bonusZMSkiptoData["skiptoname"] 	= "default";		
	
	if( !IsDefined( level.bonusZMSkiptoData["onlyuseonstart"] ) )
		level.bonusZMSkiptoData["onlyuseonstart"] 	= false;
	
	if( !IsDefined( level.bonusZMSkiptoData["zombifyenabled"] ) )
		level.bonusZMSkiptoData["zombifyenabled"] 	= zombify;
		
	if( !IsDefined( level.bonusZMSkiptoData["startunaware"] ) )
		level.bonusZMSkiptoData["startunaware"] 	= false;
	
	if( !IsDefined( level.bonusZMSkiptoData["alertnessspreaddelay"] ) )
		level.bonusZMSkiptoData["alertnessspreaddelay"] = 2;
	
	if( !IsDefined( level.bonusZMSkiptoData["forcecleanuponcompletion"] ) )
		level.bonusZMSkiptoData["forcecleanuponcompletion"] = false;
	
	if( !IsDefined( level.bonusZMSkiptoData["disablefailsafelogic"] ) )
		level.bonusZMSkiptoData["disablefailsafelogic"] = false;
	
	if( !IsDefined( level.bonusZMSkiptoData["extraspawns"] ) )
		level.bonusZMSkiptoData["extraspawns"] 		= 0;			
	
	if( !IsDefined( level.bonusZMSkiptoData["zigzagdeviationmin"] ) )
		level.bonusZMSkiptoData["zigzagdeviationmin"] 		= 250;
	
	if( !IsDefined( level.bonusZMSkiptoData["zigzagdeviationmax"] ) )
		level.bonusZMSkiptoData["zigzagdeviationmax"] 		= 400;
			
	if( !IsDefined( level.bonusZMSkiptoData["zigzagdeviationmintime"] ) )
		level.bonusZMSkiptoData["zigzagdeviationmintime"] 		= 2500;
	
	if( !IsDefined( level.bonusZMSkiptoData["zigzagdeviationmaxtime"] ) )
		level.bonusZMSkiptoData["zigzagdeviationmaxtime"] 		= 4000;	
	
	if( !IsDefined( level.bonusZMSkiptoData["extraspawngapmin"] ) )
		level.bonusZMSkiptoData["extraspawngapmin"] 	= 2;
			
	if( !IsDefined( level.bonusZMSkiptoData["walkpercent"] ) )
	{
		if( ( isdefined( takeCareOfUndefinedValues ) && takeCareOfUndefinedValues ) )
			level.bonusZMSkiptoData["walkpercent"] 	= 0;
		else
			level.bonusZMSkiptoData["walkpercent"] 		= 33;
	}
	
	if( !IsDefined( level.bonusZMSkiptoData["runpercent"] ) )
	{
		if( ( isdefined( takeCareOfUndefinedValues ) && takeCareOfUndefinedValues ) )
			level.bonusZMSkiptoData["runpercent"] 	= 0;
		else
			level.bonusZMSkiptoData["runpercent"] 		= 33;
	}
	
	if( !IsDefined( level.bonusZMSkiptoData["sprintpercent"] ) )
	{
		if( ( isdefined( takeCareOfUndefinedValues ) && takeCareOfUndefinedValues ) )
			level.bonusZMSkiptoData["sprintpercent"] 	= 0;
		else
			level.bonusZMSkiptoData["sprintpercent"] 	= 34;
	}

	if( !IsDefined( level.bonusZMSkiptoData["levelonehealth"] ) )
		level.bonusZMSkiptoData["levelonehealth"] 	= 150;
	
	if( !IsDefined( level.bonusZMSkiptoData["leveltwohealth"] ) )
		level.bonusZMSkiptoData["leveltwohealth"] 	= 350;
	
	if( !IsDefined( level.bonusZMSkiptoData["levelthreehealth"] ) )
		level.bonusZMSkiptoData["levelthreehealth"] 	= 650;
	
	if( !IsDefined( level.bonusZMSkiptoData["levelonezombies"] ) )
	{
		if( ( isdefined( takeCareOfUndefinedValues ) && takeCareOfUndefinedValues ) )
			level.bonusZMSkiptoData["levelonezombies"] 		= 0;
		else
			level.bonusZMSkiptoData["levelonezombies"] 		= 33;
	}
	
	if( !IsDefined( level.bonusZMSkiptoData["leveltwozombies"] ) )
	{
		if( ( isdefined( takeCareOfUndefinedValues ) && takeCareOfUndefinedValues ) )
			level.bonusZMSkiptoData["leveltwozombies"] 		= 0;
		else
			level.bonusZMSkiptoData["leveltwozombies"] 		= 33;
	}
	
	if( !IsDefined( level.bonusZMSkiptoData["levelthreezombies"] ) )
	{
		if( ( isdefined( takeCareOfUndefinedValues ) && takeCareOfUndefinedValues ) )
			level.bonusZMSkiptoData["levelthreezombies"] 		= 0;
		else
			level.bonusZMSkiptoData["levelthreezombies"] 		= 34;
	}
		
	// Health Scalars
	if( !IsDefined( level.bonusZMSkiptoData["zombiehealthscale1"] ) )
	{
		level.bonusZMSkiptoData["zombiehealthscale1"] 		= 0.5;		
	}
	
	if( !IsDefined( level.bonusZMSkiptoData["zombiehealthscale2"] ) )
	{
		level.bonusZMSkiptoData["zombiehealthscale2"] 		= 1;		
	}
	
	if( !IsDefined( level.bonusZMSkiptoData["zombiehealthscale3"] ) )
	{
		level.bonusZMSkiptoData["zombiehealthscale3"] 		= 1.25;		
	}
	
	if( !IsDefined( level.bonusZMSkiptoData["zombiehealthscale4"] ) )
	{
		level.bonusZMSkiptoData["zombiehealthscale4"] 		= 1.5;		
	}
	
	if( !IsDefined( level.bonusZMSkiptoData["zombiehealthscale5"] ) )
	{
		level.bonusZMSkiptoData["zombiehealthscale5"] 		= 2;		
	}
	
	// Extra Zombie Scalars
	if( !IsDefined( level.bonusZMSkiptoData["extrazombiescale1"] ) )
	{
		level.bonusZMSkiptoData["extrazombiescale1"] 		= 1;		
	}
	
	if( !IsDefined( level.bonusZMSkiptoData["extrazombiescale2"] ) )
	{
		level.bonusZMSkiptoData["extrazombiescale2"] 		= 1.5;		
	}
	
	if( !IsDefined( level.bonusZMSkiptoData["extrazombiescale3"] ) )
	{
		level.bonusZMSkiptoData["extrazombiescale3"] 		= 1.75;		
	}
	
	if( !IsDefined( level.bonusZMSkiptoData["extrazombiescale4"] ) )
	{
		level.bonusZMSkiptoData["extrazombiescale4"] 		= 2;		
	}	
	
	// Suicidal zombie	
	if( !IsDefined( level.bonusZMSkiptoData["suicidalzombiechance"] ) )
	{
		level.bonusZMSkiptoData["suicidalzombiechance"] = 0;
	}
	
	if( !IsDefined( level.bonusZMSkiptoData["magicboxonlyweaponchance"] ) )
	{
		level.bonusZMSkiptoData["magicboxonlyweaponchance"] = 0;		
	}
	
	if( !IsDefined( level.bonusZMSkiptoData["maxmagicboxonlyweapons"] ) )
	{
		level.bonusZMSkiptoData["maxmagicboxonlyweapons"] = 0;		
	}
}

function BZM_GetSkiptoPrefix(index)
{
	return ( "skipto" + index + "_" );
}


function private BZM_ValidateData()
{
	if( !level.bonusZMSkiptoData["zombifyenabled"] )
		return;
	
	// Health
	total_percentage 	= level.bonusZMSkiptoData["levelonezombies"] 
						+ level.bonusZMSkiptoData["leveltwozombies"] 
						+ level.bonusZMSkiptoData["levelthreezombies"];
	
	assert( total_percentage == 100, "Health percentatge does not add upto 100 for skipto " + level.bonusZMSkiptoData["skiptoname"] );	
	
	// Locomotion Speed
	total_percentage 	= level.bonusZMSkiptoData["walkpercent"] 
						+ level.bonusZMSkiptoData["runpercent"] 
						+ level.bonusZMSkiptoData["sprintpercent"];
	
	assert( total_percentage == 100, "Locomotion Speed percentatge does not add upto 100 for skipto " + level.bonusZMSkiptoData["skiptoname"] );	
	
	assert( level.bonusZMSkiptoData["zigzagdeviationmin"] < level.bonusZMSkiptoData["zigzagdeviationmax"], "zigzag min should be less than the zigzag max distance." );
	assert( level.bonusZMSkiptoData["zigzagdeviationmintime"] < level.bonusZMSkiptoData["zigzagdeviationmaxtime"], "zigzag min time should be less than the zigzag max time." );
}