#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
                                                                                     	                                    
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       



#using_animtree("all_player");
#namespace end_game_flow;

function autoexec __init__sytem__() {     system::register("end_game_flow",&__init__,undefined,undefined);    }		

function __init__()
{
	clientfield::register( "world", "displayTop3Players", 1, 1, "int", &showTopThreePlayers, !true, !true );
	clientfield::register( "world", "triggerScoreboardCamera", 1, 1, "int", &showScoreboard, !true, !true );
}

function loadCharacterOnModel( characterModel, localClientNum, topPlayerIndex )
{	
	assert( isdefined( characterModel ) );
	
	// swap out our body
	bodyModel = GetTopPlayersBodyModel( localClientNum, topPlayerIndex );
	characterModel SetModel( bodyModel );
	
	// swap out our helmet
	helmetModel = GetTopPlayersHelmetModel( localClientNum, topPlayerIndex );

	if ( !( characterModel IsAttached( helmetModel, "" ) ) )
	{
		characterModel Attach( helmetModel, "" );
	}
	
	// set up our render options
	bodyRenderOptions = GetTopPlayersBodyRenderOptions( localClientNum, topPlayerIndex );
	helmetRenderOptions = GetTopPlayersHelmetRenderOptions( localClientNum, topPlayerIndex );

	// replace this with the right weapon
	weapon_right = "wpn_t7_arak_paint_shop";

	bodyType = GetTopPlayersBodyType( localClientNum, topPlayerIndex );
	if ( bodyType >= 0 )
	{
		bodyTypeFields = GetHeroFields( bodyType );
		if ( topPlayerIndex == 0 )
		{
			anim_name = (isdefined(bodyTypeFields.final1stplaceIdle)?bodyTypeFields.final1stplaceIdle:"pb_rifle_endgame_1stplace_idle");
		}
		else if ( topPlayerIndex == 1 )
		{
			anim_name = (isdefined(bodyTypeFields.final2ndplaceIdle)?bodyTypeFields.final2ndplaceIdle:"pb_rifle_endgame_2ndplace_idle");
		}
		else if ( topPlayerIndex == 2 )
		{
			anim_name = (isdefined(bodyTypeFields.final3rdplaceIdle)?bodyTypeFields.final3rdplaceIdle:"pb_rifle_endgame_3rdplace_idle");
		}
	}

	if( isDefined(anim_name) )
	{
		if( !characterModel HasAnimTree() )
		{
			characterModel UseAnimTree( #animtree );
		}
		characterModel SetAnim( anim_name );
	}

	characterModel SetBodyRenderOptions( bodyRenderOptions, helmetRenderOptions, helmetRenderOptions );
	if ( isdefined( weapon_right ) && !( characterModel IsAttached( weapon_right, "tag_weapon_right" ) ) )
	{
		characterModel Attach( weapon_right, "tag_weapon_right" );
	}
}

function showTopThreePlayers( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( isdefined( newVal ) && newVal > 0 && isDefined( level.endGameXCamName ) )
	{
		SetUIModelValue( GetUIModel( GetUIModelForController( localClientNum ), "displayTop3Players" ), 1 );
		topPlayerCharacters = [];
		topPlayerScriptStructs = [];

		topPlayerScriptStructs[0] = struct::get( "TopPlayer1", "targetname" );
		topPlayerScriptStructs[1] = struct::get( "TopPlayer2", "targetname" );
		topPlayerScriptStructs[2] = struct::get( "TopPlayer3", "targetname" );

		foreach( index, scriptStruct in topPlayerScriptStructs )
		{
			topPlayerCharacters[index] = Spawn( localClientNum, scriptStruct.origin, "script_model" );
			topPlayerCharacters[index].angles = scriptStruct.angles;
		}

		numClients = GetNumClientsInScoreboard( localClientNum );
		
		foreach( index, characterModel in topPlayerCharacters )
		{
			if ( index < numClients )
			{
				loadCharacterOnModel( characterModel, localClientNum, index );
			}
		}
		
		position = struct::get( "endgame_top_players_struct", "targetname" );
		PlayMainCamXCam( localClientNum, level.endGameXCamName, 0, "cam_topscorers", "topscorers", position.origin, position.angles );
	}
}

function showScoreboard( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( isdefined( newVal ) && newVal > 0 && isDefined( level.endGameXCamName ) )
	{
		position = struct::get( "endgame_top_players_struct", "targetname" );
		PlayMainCamXCam( localClientNum, level.endGameXCamName, 0, "cam_topscorers", "endshot", position.origin, position.angles );
		SetUIModelValue( GetUIModel( GetUIModelForController( localClientNum ), "forceScoreboard" ), 1 );
	}
}

