#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace fx;

function autoexec __init__sytem__() {     system::register("fx",&__init__,undefined,undefined);    }

function __init__()
{
}	

function set_forward_and_up_vectors()
{
	self.v["up"] = anglestoup(self.v["angles"]);
	self.v["forward"] = anglestoforward(self.v["angles"]);
}
	
function get( fx )
{
	assert( isdefined( level._effect[ fx ] ), "Fx " + fx + " is not defined in level._effect." );
	return level._effect[ fx ];
}

// Adds effects as entities in level.createFXent[].
function create_effect( type, fxid )
{
	ent = undefined;
	
	if (!isdefined(level.createFXent))
	{
		level.createFXent = [];
	}
	if(type == "exploder")
	{
		ent = SpawnStruct();
	}
	else
	{
		if(!isdefined(level._fake_createfx_struct))
		{
			level._fake_createfx_struct = SpawnStruct();
		}
		
		ent = level._fake_createfx_struct;
	}
	
	level.createFXent[level.createFXent.size] = ent;
	ent.v = [];
	ent.v["type"] = type;
	ent.v["fxid"] = fxid;
	ent.v["angles"] = (0,0,0);
	ent.v["origin"] = (0,0,0);
	ent.drawn = true;
	return ent;
}

function create_loop_effect( fxid )
{
	ent = create_effect( "loopfx", fxid );
	ent.v[ "delay" ] = 0.5;
	return ent;
}

function create_oneshot_effect( fxid )
{
	ent = create_effect( "oneshotfx", fxid );
	ent.v[ "delay" ] = -15;
	return ent;
}

/@
"Name: play( <str_fx>, <v_origin>, [v_angles], [time_to_delete_or_notify], [b_link_to_self], [str_tag] )"
"Summary: play an effect at an origin or relative to an entity for a time or unitl a notify."
"Module: Utility"
"CallOn: level or entity to link fx to"
"MandatoryArg: <str_fx> : identifier of fx."
"MandatoryArg: <v_origin> : origin to play fx."
"OptionalArg: [v_angles] : angles to play fx."
"OptionalArg: [time_to_delete_or_notify] : when to delete to fx entity (time or notify). can be undefined if linking to an ent. it will die when it dies."
"OptionalArg: [b_link_to_self] : set to true to link to the entity this function is called on."
"OptionalArg: [str_tag] : tag to link to if linking."
"OptionalArg: [b_no_cull] : set to true to force it to not cull out."
"OptionalArg: [b_ignore_pause_world] : set to true to keep playing the effect even when the world is paused
"Example: e_ent play( "splosion", undefined, undefined, 3, true, "tag_bone" );"
"SPMP: SP"
@/
function play( str_fx, v_origin = ( 0, 0, 0 ), v_angles = ( 0, 0, 0 ), time_to_delete_or_notify, b_link_to_self = false, str_tag, b_no_cull, b_ignore_pause_world )
{
	self notify( str_fx );
	
	if ( ( !isdefined( time_to_delete_or_notify ) || ( !IsString( time_to_delete_or_notify ) && time_to_delete_or_notify == -1 ) )
	    && ( isdefined( b_link_to_self ) && b_link_to_self ) && isdefined( str_tag ) )
	{
		PlayFXOnTag( get( str_fx ), self, str_tag, b_ignore_pause_world );
		return self;
	}
	else
	{
		if ( isdefined( time_to_delete_or_notify ) )
		{
			m_fx = util::spawn_model( "tag_origin", v_origin, v_angles );
			
			if ( ( isdefined( b_link_to_self ) && b_link_to_self ) )
			{
				if ( isdefined( str_tag ) )
				{
					m_fx LinkTo( self, str_tag, (0, 0, 0), (0, 0, 0) );
				}
				else
				{
					m_fx LinkTo( self );
				}
			}
			
			if ( ( isdefined( b_no_cull ) && b_no_cull ) )
			{
				m_fx SetForceNoCull();
			}
			
			PlayFXOnTag( get( str_fx ), m_fx, "tag_origin", b_ignore_pause_world );
			m_fx thread _play_fx_delete( self, time_to_delete_or_notify );
			return m_fx;
		}
		else
		{
			PlayFX( get( str_fx ), v_origin, AnglesToForward( v_angles ), AnglesToUp( v_angles ), b_ignore_pause_world );
		}
	}
}

function _play_fx_delete( ent, time_to_delete_or_notify = (-1) )
{
	if ( IsString( time_to_delete_or_notify ) )
	{
		ent util::waittill_either( "death", time_to_delete_or_notify );
	}
	else if ( time_to_delete_or_notify > 0 )
	{
		ent util::waittill_any_timeout( time_to_delete_or_notify, "death" );
	}
	else
	{
		ent waittill( "death" );
	}
	
	if ( isdefined( self ) )
	{
		self Delete();
	}
}
