#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace beam;

function launch( ent_1, str_tag1, ent_2, str_tag2, str_beam_type )
{
	s_beam = _get_beam( ent_1, str_tag1, ent_2, str_tag2, str_beam_type );
	
	if ( !isdefined( s_beam ) )
	{
		s_beam = _new_beam( ent_1, str_tag1, ent_2, str_tag2, str_beam_type );
	}
	
	if ( self == level )
	{
		if ( isdefined( level.localplayers ) )
		{
			foreach ( player in level.localplayers )
			{
				if ( isdefined( player ) )
				{
					player launch( ent_1, str_tag1, ent_2, str_tag2, str_beam_type );
				}
			}
		}
	}
	else if ( isdefined( s_beam ) )
	{
		s_beam.beam_id = BeamLaunch( self.localclientnum, ent_1, str_tag1, ent_2, str_tag2, str_beam_type );		
		self thread _kill_on_ent_death( s_beam, ent_1, ent_2 );
		return s_beam.beam_id;
	}
}

function kill( ent_1, str_tag1, ent_2, str_tag2, str_beam_type )
{
	if ( isdefined( self.active_beams ) )
	{
		s_beam = _get_beam( ent_1, str_tag1, ent_2, str_tag2, str_beam_type );
		ArrayRemoveValue( self.active_beams, s_beam, false );
	}
	
	if ( self == level )
	{
		if ( isdefined( level.localplayers ) )
		{
			foreach ( player in level.localplayers )
			{
				if ( isdefined( player ) )
				{
					player kill( ent_1, str_tag1, ent_2, str_tag2, str_beam_type );
				}
			}
		}
	}
	else if ( isdefined( s_beam ) )
	{
		s_beam notify( "kill" );
		BeamKill( self.localclientnum, s_beam.beam_id );
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
// Private  //////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

function private _new_beam( ent_1, str_tag1, ent_2, str_tag2, str_beam_type )
{
	if(!isdefined(self.active_beams))self.active_beams=[];
		
	s_beam = SpawnStruct();
	s_beam.ent_1 = ent_1;
	s_beam.str_tag1 = str_tag1;
	s_beam.ent_2 = ent_2;
	s_beam.str_tag2 = str_tag2;
	s_beam.str_beam_type = str_beam_type;
	
	if ( !isdefined( self.active_beams ) ) self.active_beams = []; else if ( !IsArray( self.active_beams ) ) self.active_beams = array( self.active_beams ); self.active_beams[self.active_beams.size]=s_beam;;
	
	return s_beam;
}

function private _get_beam( ent_1, str_tag1, ent_2, str_tag2, str_beam_type )
{
	if ( isdefined( self.active_beams ) )
	{
		foreach ( s_beam in self.active_beams )
		{
			if ( ( s_beam.ent_1 == ent_1 )
			    && ( s_beam.str_tag1 == str_tag1 )
			    && ( s_beam.ent_2 == ent_2 )
			    && ( s_beam.str_tag2 == str_tag2 )
			   	&& ( s_beam.str_beam_type == str_beam_type ) )
			{
				return s_beam;
			}
		}
	}
}

function private _kill_on_ent_death( s_beam, ent_1, ent_2 )
{
	s_beam endon( "kill" );
	self endon( "death" );
	
	util::waittill_any_ents( ent_1, "entityshutdown", ent_2, "entityshutdown" );
	
	if ( isdefined( self ) )
	{
		ArrayRemoveValue( self.active_beams, s_beam, false );
		BeamKill( self.localclientnum, s_beam.beam_id );
	}
}