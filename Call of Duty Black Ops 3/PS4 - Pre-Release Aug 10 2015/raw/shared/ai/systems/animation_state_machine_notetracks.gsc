#using scripts\shared\ai\systems\blackboard;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                              	         	    	                                                                                                   
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
                                                                  	                             	  	                                      

#namespace AnimationStateNetwork;

// ------------- NotatrackHandler Initialization ----------- //
function autoexec InitNotetrackHandler()
{	
	level._NOTETRACK_HANDLER = [];
}

// ------------- NotetrackHandler internals ----------- //
function private RunNotetrackHandler( entity, notetracks )
{
	assert( IsArray( notetracks ) );
	
	for ( index = 0; index < notetracks.size; index++ )
	{
		HandleNotetrack( entity, notetracks[index] );
	}
}

function private HandleNotetrack( entity, notetrack )
{
	notetrackHandler = level._NOTETRACK_HANDLER[notetrack];
	
	If( !IsDefined( notetrackHandler ) )
	{
		return;
	}
	
	if( IsFunctionPtr( notetrackHandler ) )
	{	
		// run the notetrackHandler function
		[[notetrackHandler]]( entity );
	}
	else
	{
		// assume notetrackHandler is setting a blackboard variable for entity
		Blackboard::SetBlackBoardAttribute(
			entity,
			notetrackHandler.blackboardAttributeName,
			notetrackHandler.blackBoardValue );
	}
}

// ------------- NotatrackHandler Function utility ----------- //
function RegisterNotetrackHandlerFunction( notetrackName, notetrackFuncPtr )
{
	Assert(
		IsString( notetrackName ),
		"NotetrackHandler - notetrackName must be of string type." );
	
	Assert(
		IsFunctionPtr( notetrackFuncPtr ),
		"NotetrackHandler - notetrackFunc name must be of function pointer type." );
	
	Assert(
		!IsDefined( level._NOTETRACK_HANDLER[notetrackName] ),
		"NotetrackHandler - notetrackName \"" + notetrackName + "\" is already registered." );
	
	// add the notetrack handler to the global list
	level._NOTETRACK_HANDLER[notetrackName] = notetrackFuncPtr;
}

// ------------- BlackBoard NotetrackHandler utility ----------- //

function RegisterBlackboardNotetrackHandler(
	notetrackName, blackboardAttributeName, blackBoardValue )
{
	notetrackHandler = SpawnStruct();
	notetrackHandler.blackboardAttributeName = blackboardAttributeName;
	notetrackHandler.blackBoardValue = blackBoardValue;
	
	level._NOTETRACK_HANDLER[notetrackName] = notetrackHandler;
}