    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace trigger;

//trigger_thread
function function_thread( ent, on_enter_payload, on_exit_payload )
{
	ent endon( "entityshutdown" );

	if ( ent ent_already_in( self ) )
	{
		return;
	}

	add_to_ent( ent, self );

//	iprintlnbold("Trigger " + self.targetname + " hit by ent " + ent getentitynumber());

	if ( isdefined( on_enter_payload ) )
	{
		[[on_enter_payload]]( ent );
	}

	while ( isdefined( ent ) && ent istouching( self ) )
	{
		{wait(.016);};
	}

//	iprintlnbold(ent getentitynumber() + " leaves trigger " + self.targetname + ".");

	if ( isdefined( ent ) && isdefined( on_exit_payload ) )
	{
		[[on_exit_payload]]( ent );
	}

	if ( isdefined( ent ) )
	{
		remove_from_ent( ent, self );
	}
}

function ent_already_in( trig )
{
	if ( !isdefined( self._triggers ) )
	{
		return false;
	}

	if ( !isdefined( self._triggers[trig getentitynumber()] ) )
	{
		return false;
	}

	if ( !self._triggers[trig getentitynumber()] )
	{
		return false;
	}

	return true;	// We're already in this trigger volume.
}

function add_to_ent( ent, trig )
{
	if ( !isdefined( ent._triggers ) )
	{
		ent._triggers = [];
	}

	ent._triggers[trig getentitynumber()] = 1;
}

function remove_from_ent( ent, trig )
{
	if ( !isdefined( ent._triggers ) )
	{
		return;
	}

	if ( !isdefined( ent._triggers[trig getentitynumber()] ) )
	{
		return;
	}

	ent._triggers[trig getentitynumber()] = 0;
}

function death_monitor( ent, ender )
{
	ent waittill( "death" );
	self endon( ender );
	self remove_from_ent( ent );
}
