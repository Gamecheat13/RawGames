#using scripts\shared\animation_debug_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\shaderanim_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace animation;


	
function autoexec __init__sytem__() {     system::register("animation",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "scriptmover", "cracks_on", 1, GetMinBitCountForNum( 4 ), "int",	&cracks_on, !true, !true );
	clientfield::register( "scriptmover", "cracks_off", 1, GetMinBitCountForNum( 4 ), "int",	&cracks_off, !true, !true );
	
	setup_notetracks();
}

/@
"Name: first_frame( <ents>, <scene>, [str_tag], [animname_override] )"
"Summary: Puts the animating models or AI or vehicles into the first frame of the animated scene. The animation is played relative to the entity that calls the scene"
"Module: Animation"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <ents> Array of entities that will animate."
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: [str_tag] The str_tag to animate relative to (must exist in the entity this function is called on)."
"OptionalArg: [animname_override] Animname to use instead of ent.animname"
"Example: node first_frame( guys, "rappel_sequence" );"
"SPMP: singleplayer"
@/
function first_frame( animation, v_origin_or_ent, v_angles_or_tag )
{
	self thread play( animation, v_origin_or_ent, v_angles_or_tag, 0 );
}

function play( animation, v_origin_or_ent, v_angles_or_tag, n_rate = 1, n_blend_in = .2, n_blend_out = .2, n_lerp )
{
	self endon( "death" );
	self thread _play( animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp );
	self waittill( "scriptedanim" );
}

function _play( animation, v_origin_or_ent, v_angles_or_tag, n_rate = 1, n_blend_in = .2, n_blend_out = .2, n_lerp )
{
	self endon( "death" );
	
	self notify( "new_scripted_anim" );
	self endon( "new_scripted_anim" );
	
	flagsys::set_val( "firstframe", n_rate == 0 );
	flagsys::set( "scripted_anim_this_frame" );
	flagsys::set( "scriptedanim" );
	
	if(!isdefined(v_origin_or_ent))v_origin_or_ent=self;
	
	b_link = false;
	
	if ( IsVec( v_origin_or_ent ) && IsVec( v_angles_or_tag ) )
	{
		self AnimScripted( "_anim_notify_", v_origin_or_ent, v_angles_or_tag, animation, n_blend_in, n_rate );
	}
	else
	{
		if ( IsString( v_angles_or_tag ) )
		{
			Assert( isdefined( v_origin_or_ent.model ), "Cannot align animation '" + animation + "' to tag '" + v_angles_or_tag + "' because the animation is not aligned to a model." );
			
			v_pos = v_origin_or_ent GetTagOrigin( v_angles_or_tag );
			v_ang = v_origin_or_ent GetTagAngles( v_angles_or_tag );
			
			self.origin = v_pos;
			self.angles = v_ang;
						
			b_link = true;
			
//			self LinkTo( v_origin_or_ent, v_angles_or_tag, ( 0, 0, 0 ), ( 0, 0, 0 ) ); // TODO: LinkTo with animation is broken client side and will mis-align the entities
			self AnimScripted( "_anim_notify_", self.origin, self.angles, animation, n_blend_in, n_rate );
		}
		else
		{		
			v_angles = ( isdefined( v_origin_or_ent.angles ) ? v_origin_or_ent.angles : ( 0, 0, 0 ) );
			self AnimScripted( "_anim_notify_", v_origin_or_ent.origin, v_angles, animation, n_blend_in, n_rate );
		}
	}
	
	if ( !b_link )
	{
		self Unlink();
	}
		
	/#
		self thread anim_info_render_thread( animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp );
	#/
	
//	if ( !IsAnimLooping( animation ) && ( n_blend_out > 0 ) && ( n_rate > 0 ) )
//	{
//		self thread _blend_out( animation, n_blend_out, n_rate );
//	}
		
	self thread handle_notetracks();
	
	self waittillmatch( "_anim_notify_", "end" );
	
	if ( b_link )
	{
		self Unlink();
	}
	
	flagsys::clear( "scriptedanim" );
	flagsys::clear( "firstframe" );
	
	waittillframeend;
	
	flagsys::clear( "scripted_anim_this_frame" );
}

//function _blend_out( animation, n_blend, n_rate )
//{
//	self endon( "death" );
//	self endon( "scriptedanim" );
//	
//	n_len = GetAnimLength( animation );
//	n_wait = ( n_len - n_blend ) * ( 1 / n_rate );
//	
//	if ( n_wait > n_len )
//	{
//		wait n_wait;
//	
//		self StopAnimScripted( n_blend );
//	}
//}

function _get_align_ent( e_align )
{
	e = self;
	if ( isdefined( e_align ) )
	{
		e = e_align;
	}
	
	if(!isdefined(e.angles))e.angles=( 0, 0, 0 );
	return e;
}

function _get_align_pos( v_origin_or_ent, v_angles_or_tag )
{
	if(!isdefined(v_origin_or_ent))v_origin_or_ent=self.origin;
	if(!isdefined(v_angles_or_tag))v_angles_or_tag=(isdefined(self.angles)?self.angles:( 0, 0, 0 ));
	
	s = SpawnStruct();
	
	if ( IsVec( v_origin_or_ent ) )
	{
		Assert( IsVec( v_angles_or_tag ), "Angles must be a vector if origin is." );
		
		s.origin = v_origin_or_ent;
		s.angles = v_angles_or_tag;
	}
	else
	{
		e_align = _get_align_ent( v_origin_or_ent );
					
		if ( IsString( v_angles_or_tag ) )
		{
			s.origin = e_align GetTagOrigin( v_angles_or_tag );
			s.angles = e_align GetTagAngles( v_angles_or_tag );
		}
		else
		{
			s.origin = e_align.origin;
			s.angles = e_align.angles;
		}			
	}
	
	if(!isdefined(s.angles))s.angles=( 0, 0, 0 );
	
	return s;
}

function play_siege( str_anim, str_shot = "default", n_rate = 1, b_loop = false )
{
	self endon( "death" );
	
	if ( n_rate == 0 )
	{
		self SiegeCmd( "set_anim", str_anim, "set_shot", str_shot, "pause", "goto_start" );
	}
	else
	{
		self SiegeCmd( "set_anim", str_anim, "set_shot", str_shot, "unpause", "set_playback_speed", n_rate, "send_end_events", true, ( b_loop ? "loop" : "unloop" ) );
	}
	
	self waittill( "end" );
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Notetrack Handling
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function add_notetrack_func( funcname, func )
{
	if(!isdefined(level._animnotifyfuncs))level._animnotifyfuncs=[];

	Assert( !isdefined( level._animnotifyfuncs[ funcname ] ), "Notetrack function already exists." );
	
	level._animnotifyfuncs[ funcname ] = func;
}

function add_global_notetrack_handler( str_note, func, ... )
{
	if(!isdefined(level._animnotetrackhandlers))level._animnotetrackhandlers=[];
	if(!isdefined(level._animnotetrackhandlers[ str_note ]))level._animnotetrackhandlers[ str_note ]=[];
	
	if ( !isdefined( level._animnotetrackhandlers[ str_note ] ) ) level._animnotetrackhandlers[ str_note ] = []; else if ( !IsArray( level._animnotetrackhandlers[ str_note ] ) ) level._animnotetrackhandlers[ str_note ] = array( level._animnotetrackhandlers[ str_note ] ); level._animnotetrackhandlers[ str_note ][level._animnotetrackhandlers[ str_note ].size]=array( func, vararg );;
}

function call_notetrack_handler( str_note )
{
	if ( isdefined( level._animnotetrackhandlers ) && isdefined( level._animnotetrackhandlers[ str_note ] ) )
	{
		foreach ( handler in level._animnotetrackhandlers[ str_note ] )
		{
			func = handler[0];
			args = handler[1];
			
			switch ( args.size )
			{
				case 6:
					self [[ func ]]( args[0], args[1], args[2], args[3], args[4], args[5] );
					break;
				case 5:
					self [[ func ]]( args[0], args[1], args[2], args[3], args[4] );
					break;
				case 4:
					self [[ func ]]( args[0], args[1], args[2], args[3] );
					break;
				case 3:
					self [[ func ]]( args[0], args[1], args[2] );
					break;
				case 2:
					self [[ func ]]( args[0], args[1] );
					break;
				case 1:
					self [[ func ]]( args[0] );
					break;
				case 0:
					self [[ func ]]();
					break;
				default: AssertMsg( "Too many args passed to notetrack handler." );
			}
		}
	}
}

function setup_notetracks()
{
	add_notetrack_func( "flag::set", &flag::set );
	add_notetrack_func( "flag::clear", &flag::clear );
	
	add_notetrack_func( "postfx::PlayPostFxBundle", &postfx::PlayPostFxBundle );
	add_notetrack_func( "postfx::StopPostFxBundle", &postfx::StopPostFxBundle );
}

function handle_notetracks()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "_anim_notify_", str_note );
		
		if ( str_note != "end" && str_note != "loop_end" )
		{
			self thread call_notetrack_handler( str_note );
		}
		else
		{
			return;
		}
	}
}









	
function cracks_on( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	const delay = 0;
	const duration = 3;
	const start = 0;
	const end = 1;
	
	switch ( newVal )
	{
		case 1:
			shaderanim::animate_crack( localClientNum, "scriptVector1", delay, duration, start, end );
			break;
		case 2:
			shaderanim::animate_crack( localClientNum, "scriptVector2", delay, duration, start, end );
			break;
		case 3:
			shaderanim::animate_crack( localClientNum, "scriptVector3", delay, duration, start, end );
			break;
		case 4:
			shaderanim::animate_crack( localClientNum, "scriptVector1", delay, duration, start, end );
			shaderanim::animate_crack( localClientNum, "scriptVector2", delay, duration, start, end );
			shaderanim::animate_crack( localClientNum, "scriptVector3", delay, duration, start, end );
	}
}

function cracks_off( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	const delay = 0;
	const duration = 0;
	const start = 1;
	const end = 0;
	
	switch ( newVal )
	{
		case 1:
			shaderanim::animate_crack( localClientNum, "scriptVector1", delay, duration, start, end );
			break;
		case 2:
			shaderanim::animate_crack( localClientNum, "scriptVector2", delay, duration, start, end );
			break;
		case 3:
			shaderanim::animate_crack( localClientNum, "scriptVector3", delay, duration, start, end );
			break;
		case 4:
			shaderanim::animate_crack( localClientNum, "scriptVector1", delay, duration, start, end );
			shaderanim::animate_crack( localClientNum, "scriptVector2", delay, duration, start, end );
			shaderanim::animate_crack( localClientNum, "scriptVector3", delay, duration, start, end );
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// !Notetrack Handling
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
