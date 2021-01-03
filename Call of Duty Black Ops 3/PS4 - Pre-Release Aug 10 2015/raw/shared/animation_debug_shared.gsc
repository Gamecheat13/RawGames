#using scripts\shared\animation_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace animation;





/#

function autoexec __init__()
{
	SetDvar( "anim_debug", 0 );
	SetDvar( "anim_debug_pause", 0 );
	
	while ( true )
	{
		anim_debug = GetDvarInt( "anim_debug", 0 ) || GetDvarInt( "anim_debug_pause", 0 );
		level flagsys::set_val( "anim_debug", anim_debug );
		wait .05;
	}
}

function anim_info_render_thread( animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp )
{
	self endon( "death" );
	self endon( "scriptedanim" );
	
	self notify( "_anim_info_render_thread_" );
	self endon( "_anim_info_render_thread_" );
	
	if ( !IsVec( v_origin_or_ent ) )
	{
		v_origin_or_ent endon( "death" );
	}
	
	RecordEnt( self );
		
	while ( true )
	{
		level flagsys::wait_till( "anim_debug" );
		
		b_anim_debug_on = true;
		
		_init_frame();
		
		str_extra_info = "";
		color = ( 1, 1, 0 );
		
		if ( flagsys::get( "firstframe" ) )
		{
			str_extra_info += "(first frame)";
		}
		
		s_pos = _get_align_pos( v_origin_or_ent, v_angles_or_tag );
		self anim_origin_render( s_pos.origin, s_pos.angles, undefined, undefined, !b_anim_debug_on );
		
		if ( b_anim_debug_on )
		{
			Line( self.origin, s_pos.origin, color, .5, true );
			Sphere( s_pos.origin, 2, ( .3, .3, .3 ), .5, true );
		}
		
		RecordLine( self.origin, s_pos.origin, color, "ScriptedAnim" );		
		RecordSphere( s_pos.origin, 2, ( .3, .3, .3 ), "ScriptedAnim" );
		
		if ( !IsVec( v_origin_or_ent ) && ( v_origin_or_ent != self && v_origin_or_ent != level ) )
		{
			str_name = "no name";
			if ( isdefined( v_origin_or_ent.animname ) )
			{
				str_name = v_origin_or_ent.animname;
			}
			else if ( isdefined( v_origin_or_ent.targetname ) )
			{
				str_name = v_origin_or_ent.targetname;
			}
			
			if ( b_anim_debug_on )
			{
				Print3d( v_origin_or_ent.origin + ( 0, 0, 5 ), str_name, ( .3, .3, .3 ), 1, .15 );
			}
			
			Record3DText( str_name, v_origin_or_ent.origin + ( 0, 0, 5 ), ( .3, .3, .3 ), "ScriptedAnim" );
		}

		self anim_origin_render( self.origin, self.angles, undefined, undefined, !b_anim_debug_on );
		
		str_name = "no name";
		if ( isdefined( self.anim_debug_name ) )
		{
			str_name = self.anim_debug_name;
		}
		else if ( isdefined( self.animname ) )
		{
			str_name = self.animname;
		}
		else if ( isdefined( self.targetname ) )
		{
			str_name = self.targetname;
		}
		
		if ( b_anim_debug_on )
		{
			Print3d( self.origin, self GetEntNum() + get_ent_type() + ":name:" + str_name, color, .8, .3 );
			Print3d( self.origin - ( 0, 0, 5 ), "animation:" + animation, color, .8, .3 );
			Print3d( self.origin - ( 0, 0, 7 ), str_extra_info, color, .8, .15 );
		}
		
		Record3DText( self GetEntNum() + get_ent_type() + ":name:" + str_name, self.origin, color, "ScriptedAnim" );
		Record3DText( "animation:" + animation, self.origin - ( 0, 0, 5 ), color, "ScriptedAnim" );
		Record3DText( str_extra_info, self.origin - ( 0, 0, 7 ), color, "ScriptedAnim" );

		render_tag( "tag_weapon_right", "right", !b_anim_debug_on );
		render_tag( "tag_weapon_left", "left", !b_anim_debug_on );
		render_tag( "tag_player", "player", !b_anim_debug_on );
		render_tag( "tag_camera", "camera", !b_anim_debug_on );
		
		_reset_frame();
		
		{wait(.05);};
	}
}

function get_ent_type()
{
	if ( IsActor( self ) )
	{
		return "{ai}";
	}
	else if ( IsVehicle( self ) )
	{
		return "{vehicle}";
	}
	else
	{
		return "{" + self.classname + "}";
	}
}

function _init_frame()
{
	self.v_centroid = self GetCentroid();
}

function _reset_frame()
{
	self.v_centroid = undefined;
}

function render_tag( str_tag, str_label, b_recorder_only )
{
	if(!isdefined(str_label))str_label=str_tag;
	if(!isdefined(self.v_centroid))self.v_centroid=self GetCentroid();
	
	v_tag_org = self GetTagOrigin( str_tag );
	if ( isdefined( v_tag_org ) )
	{
		v_tag_ang = self GetTagAngles( str_tag );
		anim_origin_render( v_tag_org, v_tag_ang, 2, str_label, b_recorder_only );
		
		if ( !b_recorder_only )
		{
			Line( self.v_centroid, v_tag_org, ( .3, .3, .3 ), .5, true );
		}
		
		RecordLine( self.v_centroid, v_tag_org, ( .3, .3, .3 ), "ScriptedAnim" );
	}
}

function anim_origin_render( org, angles, line_length = 6, str_label, b_recorder_only )
{
	if ( isdefined( org ) && isdefined( angles ) )
	{
		originEndPoint = org + VectorScale( AnglesToForward( angles ), line_length );
		originRightPoint = org + VectorScale( AnglesToRight( angles ), -1 * line_length );
		originUpPoint = org + VectorScale( AnglesToUp( angles ), line_length );
		
		if ( !b_recorder_only )
		{		
			Line( org, originEndPoint, ( 1, 0, 0 ) );
			Line( org, originRightPoint, ( 0, 1, 0 ) );
			Line( org, originUpPoint, ( 0, 0, 1 ) );
		}
		
		RecordLine( org, originEndPoint, ( 1, 0, 0 ), "ScriptedAnim" );
		RecordLine( org, originRightPoint, ( 0, 1, 0 ), "ScriptedAnim" );
		RecordLine( org, originUpPoint, ( 0, 0, 1 ), "ScriptedAnim" );
		
		if ( isdefined( str_label ) )
		{
			if ( !b_recorder_only )
			{
				Print3d( org, str_label, (255/255,192/255,203/255), 1, .05 );
			}
			
			Record3DText( str_label, org, (255/255,192/255,203/255), "ScriptedAnim" );
		}
	}
}

#/
