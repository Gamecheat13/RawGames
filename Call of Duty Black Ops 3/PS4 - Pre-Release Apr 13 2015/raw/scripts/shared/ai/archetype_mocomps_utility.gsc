#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\archetype_utility;

   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
                                                              	   	                             	  	                                      
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

//*****************************************************************************
// NOTE! When adding a new motion compensator you must also declare the 
// mocomp within the ast_definitions file found at:
//
// //t7/main/game/share/raw/animtables/ast_definitions.json
//
// You should add the new mocomp to the list of "possibleValues" for the
// "_animation_mocomp" animation selector table column.
//
// This allows the AI Editor to know about all possible mocomps that can be
// used.
//
//*****************************************************************************

function autoexec RegisterDefaultAnimationMocomps()
{
	// mocomps have been moved into code now, although you can still add new ones here
	
	AnimationStateNetwork::RegisterAnimationMocomp("adjust_to_cover",&mocompAdjustToCoverInit,&mocompAdjustToCoverUpdate,&mocompAdjustToCoverTerminate);;
	AnimationStateNetwork::RegisterAnimationMocomp("locomotion_explosion_death",&mocompLocoExplosionInit,undefined,undefined);;
}

function private debugLocoExplosion( entity )
{
	entity endon( "death" );

	/#
	startOrigin = entity.origin;
	startYawForward = AnglesToForward( ( 0, entity.angles[1], 0 ) );
	damageYawForward = AnglesToForward( ( 0, entity.damageyaw - entity.angles[1], 0 ) );

	startTime = GetTime();
	
	while ( GetTime() - startTime < 10000 )
	{
		RecordSphere( startOrigin, 5, ( 1, 0, 0 ), "Animscript", entity );
		RecordLine( startOrigin, startOrigin + startYawForward * 100, ( 0, 0, 1 ), "Animscript", entity );
		RecordLine( startOrigin, startOrigin + damageYawForward * 100, ( 1, 0, 0 ), "Animscript", entity );
		
		{wait(.05);};
	}
	#/
}

function private mocompLocoExplosionInit( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity AnimMode( "nogravity", false );
	entity OrientMode( "face angle", entity.angles[1] );
	
	/#
	if ( GetDvarInt( "ai_debugLocoExplosionMocomp" ) )
	{
		entity thread debugLocoExplosion( entity );
	}
	#/
}



function private mocompAdjustToCoverInit( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity OrientMode( "face angle", entity.angles[1] );
	entity AnimMode( "angle deltas", false );
	entity.blockingPain = true;
	
	if ( IsDefined( entity.node ) )
	{
		entity.nodeOffsetOrigin = entity GetNodeOffsetPosition( entity.node );
		entity.nodeOffsetAngles = entity GetNodeOffsetAngles( entity.node );
		entity.nodeOffsetForward = AnglesToForward( entity.nodeOffsetAngles );
		entity.nodeForward = AnglesToForward( entity.node.angles );
		entity.nodeFinalStance = Blackboard::GetBlackBoardAttribute( entity, "_desired_stance" );
		coverType = Blackboard::GetBlackBoardAttribute( entity, "_cover_type" );
		
		// [0, 360) relative to the node.
		angleDifference = Floor( AbsAngleClamp360( entity.angles[1] - entity.nodeOffsetAngles[1] ) );
		
		if ( angleDifference < 90 || angleDifference > 270 ) // [0,90) or (270, 360)
		{
			// Front quadrant covers the forward 180 degrees, treat this as a special case.
			entity.mocompAngleStartTime = 0.4;
		}
		else if ( angleDifference > 135 && angleDifference < 225 ) // (135, 225)
		{
			if ( entity.nodeFinalStance == "stand" )
			{
				if ( coverType == "cover_left" )
				{
					// Back quadrant covers the rear 90 degrees, handle this as a special case.
					entity.mocompAngleStartTime = 0.6;
				
					if ( angleDifference < 180 )
					{
						entity.mocompAngleStartTime = 0.4;
					}
				}
				else
				{
					entity.mocompAngleStartTime = 0.4;
				
					if ( angleDifference < 180 )
					{
						entity.mocompAngleStartTime = 0.6;
					}
				}
			}
			else
			{
				entity.mocompAngleStartTime = 0.7;
			}
		}
		else
		{
			// This is either the quadrant [90, 135] or [225, 270]
		
			// Move the angle difference into quadrant space [0, 90]
			angleDifference = AbsAngleClamp180( angleDifference ) - 90;
			
			// If the angleDifference is 45, this is the worst case, 90 is the best case.
			normalAnglePercent = abs( angleDifference - 45 ) / 45;
			
			// Start blending sooner, in the worst case.
			entity.mocompAngleStartTime = max( normalAnglePercent - 0.2, 0.4 );
		}
	}
}

function private mocompAdjustToCoverUpdate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	if( !IsDefined( entity.node ) )
	{
		return;
	}
		
	moveVector = entity.nodeOffsetOrigin - entity.origin;
		
	if ( LengthSquared( moveVector ) > ( 1 * 1 ) )
	{
		// Scale the moveVector by the max move distance.
		moveVector = VectorNormalize( moveVector ) * 1;
	}
	
	entity ForceTeleport( entity.origin + moveVector, entity.angles, false );
	
	normalizedTime = entity GetAnimTime( mocompAnim ) + mocompAnimBlendOutTime / mocompDuration;

	if ( normalizedTime > entity.mocompAngleStartTime )
	{
		entity OrientMode( "face angle", entity.nodeOffsetAngles );
		entity AnimMode( "normal", false );
	}
	
	/#
	if ( GetDvarInt( "ai_debugAdjustMocomp" ) )
	{
		record3DText( entity.mocompAngleStartTime, entity.origin + (0, 0, 5), ( 0, 1, 0 ), "Animscript" );
		
		hipTagOrigin = entity GetTagOrigin( "j_mainroot" );
		
		recordLine( entity.nodeOffsetOrigin, entity.nodeOffsetOrigin + entity.nodeOffsetForward * 30, ( 1, .5, 0 ), "Animscript", entity );
		recordLine( entity.node.origin, entity.node.origin + entity.nodeForward * 20, ( 0, 1, 0 ), "Animscript", entity );
		recordLine( entity.origin, entity.origin + AnglesToForward( entity.angles ) * 10, ( 1, 0, 0 ), "Animscript", entity );
		
		recordLine( hipTagOrigin, ( hipTagOrigin[0], hipTagOrigin[1], entity.origin[2] ), ( 0, 0, 1 ), "Animscript", entity );
	}
	#/
}

function private mocompAdjustToCoverTerminate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity.blockingPain = false;
	entity.mocompAngleStartTime = undefined;
	entity.nodeOffsetAngle = undefined;
	entity.nodeOffsetForward = undefined;
	entity.nodeForward = undefined;
	entity.nodeFinalStance = undefined;
	
	if( !IsDefined( entity.node ) )
	{
		entity.nodeOffsetOrigin = undefined;
		return;
	}

	entity ForceTeleport( entity.nodeOffsetOrigin, entity.node.angles, false );
	entity.nodeOffsetOrigin = undefined;
}