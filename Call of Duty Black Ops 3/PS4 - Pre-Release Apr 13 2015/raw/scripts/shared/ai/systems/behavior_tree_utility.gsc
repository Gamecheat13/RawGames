    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               

#namespace Blackboard;
		
function RegisterBlackBoardAttribute( entity, attributeName, defaultAttributeValue, getterFunction )
{
	Assert( IsDefined( entity.__blackboard ), "Blackboard - No blackboard has been created for this entity." );
	Assert( !IsDefined( entity.__blackboard[attributeName] ), "BlackBoard - Attribute " + attributeName + " already registered." );
		
	if( IsDefined( getterFunction ) )
	{		
		// When a blackboard is registered with getterFunction, then every single time its requested, it will 
		// execure getterFunction and return the value.	
		Assert( IsFunctionPtr( getterFunction ) );
					
		entity.__blackboard[attributeName] = getterFunction;
	}
	else
	{
		// If there is no getterFunction, then it will just store the default value
		if( !IsDefined( defaultAttributeValue ) )
		{
			defaultAttributeValue = undefined;
		}
		
		entity.__blackboard[attributeName] = defaultAttributeValue;
	}
}

function GetBlackBoardAttribute( entity, attributeName )
{	
	if( IsFunctionPtr( entity.__blackboard[attributeName] ) )
	{
		getterFunction = entity.__blackboard[attributeName];
		attributeValue = entity [[getterFunction]]();
		
		/#
			if( IsActor( entity ) )
				entity updatetrackedblackboardattribute( attributeName ); 
		#/
		
		return attributeValue;
	}
	else
	{
		/#
			if( IsActor( entity ) )
				entity updatetrackedblackboardattribute( attributeName ); 
		#/
		return entity.__blackboard[attributeName];
	}
}
	
function SetBlackBoardAttribute( entity, attributeName, attributeValue )
{	
	if ( IsDefined( entity.__blackboard[attributeName] ) )
	{
		if ( !IsDefined( attributeValue ) && IsFunctionPtr( entity.__blackboard[attributeName] ) )
		{
			// Attempts to clear attributes with getter functions is meaningless.
			return;
		}
	
		Assert( !IsFunctionPtr( entity.__blackboard[attributeName] ), "Blackboard - Attribute value can not be set explicitly, as it has a getterFunction." );
	}
	
	entity.__blackboard[attributeName] = attributeValue;
	
	/#
		if ( IsActor( entity ) )
			entity updatetrackedblackboardattribute( attributeName ); 
	#/
}

function CreateBlackBoardForEntity( entity )
{
	if( !IsDefined( entity.__blackboard ) )
	{
		entity.__blackboard = [];
	}
	
	if( !IsDefined( level._setBlackboardAttributeFunc ) )
	{
		level._setBlackboardAttributeFunc = &SetBlackBoardAttribute;
	}
}

