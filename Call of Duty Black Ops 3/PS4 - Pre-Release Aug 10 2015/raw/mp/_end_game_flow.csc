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
	clientfield::register( "world", "displayTop3Players", 1, 1, "int", &handleTopThreePlayers, !true, !true );
	clientfield::register( "world", "triggerScoreboardCamera", 1, 1, "int", &showScoreboard, !true, !true );

	level thread streamerWatcher();
}

function setAnimationOnModel( localClientNum, characterModel, topPlayerIndex )
{
	bodyType = GetTopPlayersBodyType( localClientNum, topPlayerIndex );
	if ( bodyType >= 0 )
	{
		bodyTypeFields = GetCharacterFields( bodyType, CurrentSessionMode() );
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
		characterModel util::waittill_dobj( localClientNum );

		if( !characterModel HasAnimTree() )
		{
			characterModel UseAnimTree( #animtree );
		}
		
		characterModel SetAnim( anim_name );
	}
}


function loadCharacterOnModel( localClientNum, characterModel, topPlayerIndex )
{	
	assert( isdefined( characterModel ) );
	
	// swap out our body
	bodyModel = GetTopPlayersBodyModel( localClientNum, topPlayerIndex );	
	displayTopPlayerModel = CreateUIModel( GetUIModelForController( localClientNum ), "displayTopPlayer" + (topPlayerIndex+1) );
	SetUIModelValue( displayTopPlayerModel, 1 );			
	
	// This happens when the client has never spawned in, we should not show his model and not show his playercard as well.
	if ( !IsDefined( bodyModel ) || bodymodel == "" )
	{
		SetUIModelValue( displayTopPlayerModel, 0 );
		return;		
	}
	
	characterModel SetModel( bodyModel );
	
	// swap out our helmet
	helmetModel = GetTopPlayersHelmetModel( localClientNum, topPlayerIndex );

	if ( !( characterModel IsAttached( helmetModel, "" ) ) )
	{
		characterModel Attach( helmetModel, "" );
	}
	
	// set up our render options
	modeRenderOptions =  GetCharacterModeRenderOptions( CurrentSessionMode() );
	bodyRenderOptions = GetTopPlayersBodyRenderOptions( localClientNum, topPlayerIndex );
	helmetRenderOptions = GetTopPlayersHelmetRenderOptions( localClientNum, topPlayerIndex );

	weapon_right = GetTopPlayersWeaponInfo( localClientNum, topPlayerIndex );

	if ( !isDefined( level.weaponNone ) )
    {
	  	level.weaponNone = GetWeapon( "none" );
	}

	if ( weapon_right["weapon"] == level.weaponNone )
	{
		weapon_right["weapon"] = GetWeapon("ar_standard");
	}

	characterModel SetBodyRenderOptions( modeRenderOptions, bodyRenderOptions, helmetRenderOptions, helmetRenderOptions );
	characterModel AttachWeapon( weapon_right["weapon"], weapon_right["acvi"] );
}



function setupModelAndAnimation( localClientNum, characterModel, topPlayerIndex )
{
	characterModel endon("entityshutdown");

	loadCharacterOnModel( localClientNum, characterModel, topPlayerIndex );
	setAnimationOnModel( localClientNum, characterModel, topPlayerIndex );
}
	


function prepareTopThreePlayers( localClientNum )
{
	numClients = GetNumClientsInScoreboard( localClientNum );
	position = struct::get( "endgame_top_players_struct", "targetname" );

	if( !isdefined( position ) )
	{
		return;
	}

	for( index = 0; index < 3; index++ )
	{
		if ( index < numClients )
		{
			model = Spawn( localClientNum, position.origin, "script_model" );
			loadCharacterOnModel( localClientNum, model, index );
			model Hide();
			model SetHighDetail( true );
		}
	}
}


function showTopThreePlayers( localClientNum )
{
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
			thread setupModelAndAnimation( localClientNum, characterModel, index );
		}
	}
	
	position = struct::get( "endgame_top_players_struct", "targetname" );
	PlayMainCamXCam( localClientNum, level.endGameXCamName, 0, "cam_topscorers", "topscorers", position.origin, position.angles );
	PlayRadiantExploder( localClientNum, "exploder_mp_endgame_lights" );
	SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "displayTop3Players" ), 1 );	
}


function streamerWatcher()
{
	while( true )
	{
		level waittill( "streamFKsl", localClientNum );
		prepareTopThreePlayers( localClientNum );
	}
}


function handleTopThreePlayers( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( isdefined( newVal ) && newVal > 0 && isDefined( level.endGameXCamName ) )
	{
		showTopThreePlayers( localClientNum );
	}
}

function showScoreboard( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( isdefined( newVal ) && newVal > 0 && isDefined( level.endGameXCamName ) )
	{
		position = struct::get( "endgame_top_players_struct", "targetname" );
		PlayMainCamXCam( localClientNum, level.endGameXCamName, 0, "cam_topscorers", "", position.origin, position.angles );
		SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), "forceScoreboard" ), 1 );
		level.inEndGameFlow = true;
	}
}

