#using scripts\cp\_load;
#using scripts\cp\_util;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

function autoexec init()
{
	level.laststands = [];
	for( i = 0; i < 4; i++ )
	{
		level.laststands[i] = SpawnStruct();
		level.laststands[i].bleedoutTime = 0;
		level.laststands[i].laststand_update_clientfields = "laststand_update" + i;
		level.laststands[i].lastBleedoutTime = 0;
		
		clientfield::register( "world", level.laststands[i].laststand_update_clientfields, 1, 5, "counter", &update_bleedout_timer, !true, !true );
	}

	
	level thread wait_and_set_revive_shader_constant();
}

function wait_and_set_revive_shader_constant()
{
	while( 1 )
	{
		level waittill( "notetrack", localClientNum, note );
		if( note == "revive_shader_constant" )
		{
			//received startup notetrack on revive weapon anim
			player = GetLocalPlayer( localClientNum );
			//the time at the end tells the flipbook shader what time to play relative to
			player MapShaderConstant( localClientNum, 0, "scriptVector2", 0, 1, 0, GetServerTime( localClientNum ) / 1000.0 );
		}		
	}
}

function animation_update( model, oldValue, newValue )
{
	self endon( "new_val" );
	startTime = GetRealTime();
	timeSinceLastUpdate = 0;
	
	if( oldValue == newValue )
	{
		newValue = oldValue - 1;
	}
	
	while( timeSinceLastUpdate <= 1.0 )
	{
		timeSinceLastUpdate = ( ( GetRealTime() - startTime ) / 1000.0 );
		lerpValue = ( LerpFloat( oldValue, newValue, timeSinceLastUpdate ) / 30.0 );
		SetUIModelValue( model, lerpValue );
		{wait(.016);};
	}
}

function update_bleedout_timer( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	substr =  GetSubStr( fieldName, 16 ) ;
	playerNum = Int( substr );
	
	level.laststands[ playerNum ].lastBleedoutTime = level.laststands[ playerNum ].bleedoutTime;
	level.laststands[ playerNum ].bleedoutTime = newVal - 1;
	
	if( level.laststands[ playerNum ].lastBleedoutTime < level.laststands[ playerNum ].bleedoutTime )
	{
		level.laststands[ playerNum ].lastBleedoutTime = level.laststands[ playerNum ].bleedoutTime;
	}
	
	model = GetUIModel(GetUIModelForController(localClientNum), "WorldSpaceIndicators.bleedOutModel" + playerNum + ".bleedOutPercent" );
	if( isdefined( model ) )
	{
		if( newVal == 30 )
		{
			level.laststands[ playerNum ].bleedoutTime = 0;
			level.laststands[ playerNum ].lastBleedoutTime = 0;
			SetUIModelValue( model, 1.0 );
		}
		else if( newVal == 29 )
		{
			level.laststands[ playerNum ] notify( "new_val" );
			level.laststands[ playerNum ] thread animation_update( model, 30, 28 );
		}
		else
		{
			level.laststands[ playerNum ] notify( "new_val" );
			level.laststands[ playerNum ] thread animation_update( model, level.laststands[ playerNum ].lastBleedoutTime, level.laststands[ playerNum ].bleedoutTime );
		}
	}
}