#using scripts\codescripts\struct;

#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_debug_shared;
#using scripts\shared\scriptbundle_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using_animtree( "generic" );

#namespace scene;









/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  ___    ___   ___   _  _   ___      ___    ___      _   ___    ___   _____ 
// / __|  / __| | __| | \| | | __|    / _ \  | _ )  _ | | | __|  / __| |_   _|
// \__ \ | (__  | _|  | .` | | _|    | (_) | | _ \ | || | | _|  | (__    | |  
// |___/  \___| |___| |_|\_| |___|    \___/  |___/  \__/  |___|  \___|   |_|  
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class cSceneObject : cScriptBundleObjectBase
{
	var _e_align;			// align entity for object
	var _str_name;
	
	var _is_valid;
	
	var _b_spawnonce_used;
			
	constructor()
	{
		_b_spawnonce_used = false;
		_is_valid = true;
	}
	
	destructor()
	{
	}
	
	function first_init( s_objdef, o_scene, e_ent )
	{
		cScriptBundleObjectBase::init( s_objdef, o_scene, e_ent );
			
		_assign_unique_name();
			
		if ( isdefined( _e ) )
		{
			_prepare();
		}
						
		return self;
	}
	
	function initialize()
	{
		if ( ( isdefined( _s.spawnoninit ) && _s.spawnoninit ) )
		{
			_spawn( ( isdefined( _s.firstframe ) && _s.firstframe ) || isdefined( _s.initanim ) || isdefined( _s.initanimloop ) );
		}
		
		flagsys::clear( "ready" );   flagsys::clear( "done" );   flagsys::clear( "main_done" );   self notify( "new_state" );   self endon( "new_state" );   self notify("init");   waittillframeend;;
		
		if ( ( isdefined( _s.firstframe ) && _s.firstframe ) )
		{
			if ( !error( !isdefined( _s.mainanim ), "No animation defined for first frame." ) )
			{
				_play_anim( _s.mainanim, 0, 0, 0, undefined, _s.mainshot );
			}
		}
		else if ( isdefined( _s.initanim ) )
		{
			_play_anim( _s.initanim, _s.initdelaymin, _s.initdelaymax, 1, undefined, _s.initshot );
			
			if ( is_alive() )
			{
				if ( isdefined( _s.initanimloop ) )
				{
					_play_anim( _s.initanimloop, 0, 0, 1, undefined, _s.initshotloop, true );
				}
			}
		}
		else if ( isdefined( _s.initanimloop ) )
		{
			_play_anim( _s.initanimloop, _s.initdelaymin, _s.initdelaymax, 1, undefined, _s.initshotloop, true );
		}
		else
		{
			flagsys::set( "ready" );
		}
		
		if ( !_is_valid )
		{
			flagsys::set( "done" );
		}
	}
	
	function play()
	{
		flagsys::clear( "ready" );   flagsys::clear( "done" );   flagsys::clear( "main_done" );   self notify( "new_state" );   self endon( "new_state" );   self notify("play");   waittillframeend;;
		
		if ( isdefined( _s.mainanim ) )
		{
			_play_anim( _s.mainanim, _s.maindelaymin, _s.maindelaymax, 1, _s.mainblend, _s.mainshot );
			
			flagsys::set( "main_done" );
						
			if ( is_alive() )
			{
				if ( isdefined( _s.endanim ) )
				{
					_play_anim( _s.endanim, 0, 0, 1, undefined, _s.endshot, true );
					
					if ( is_alive() )
					{
						if ( isdefined( _s.endanimloop ) )
						{
							_play_anim( _s.endanimloop, 0, 0, 1, undefined, _s.endshotloop, true );
						}
					}
				}
				else if ( isdefined( _s.endanimloop ) )
				{
					_play_anim( _s.endanimloop, 0, 0, 1, undefined, _s.endshotloop, true );
				}
			}
		}
		
		thread finish();
	}
	
	function finish( b_clear = false )
	{
		self notify( "new_state" );
		
		if ( !is_alive() )
		{
			_cleanup();
			
			_e = undefined;			
			_is_valid = false;
		}
		
		flagsys::set( "ready" );
		flagsys::set( "done" );

		if ( isdefined( _e ) )
		{
			if ( is_alive() && ( ( isdefined( _s.deletewhenfinished ) && _s.deletewhenfinished ) || b_clear ) )
			{
				_e Delete();
			}
		}
				
		self endon( "new_state" );
		
		waittillframeend;
		waittillframeend;
		
		_cleanup();
	}
	
	function get_align_ent()
	{
		e_align = undefined;
		
		if ( isdefined( _s.aligntarget ) )
		{
			a_scene_ents = [[_o_bundle]]->get_ents();
			if ( isdefined( a_scene_ents[ _s.aligntarget ] ) )
			{
				e_align = a_scene_ents[ _s.aligntarget ];
			}
			else
			{
				e_align = scene::get_existing_ent( _s.aligntarget );
			}
			
			error( !isdefined( e_align ), "Align target '" + (isdefined(_s.aligntarget)?""+_s.aligntarget:"") + "' doesn't exist for scene object." );
		}
		
		if ( !isdefined( e_align ) )
		{
			e_align = [[scene()]]->get_align_ent();
		}
		
		return e_align;
	}
	
	/* Scene Helpers */
	
	function scene()
	{
		return _o_bundle;
	}
		
	/* internal functions */
		
	function _assign_unique_name()
	{
		if ( [[scene()]]->allows_multiple() )
		{
			if ( isdefined( _s.name ) )
			{
				_str_name = _s.name + "_gen" + level.scene_object_id;
			}
			else
			{
				_str_name = [[scene()]]->get_name() + "_noname" + level.scene_object_id;
			}
			
			level.scene_object_id++;
		}
		else
		{
			if ( isdefined( _s.name ) )
			{
				_str_name = _s.name;
			}
			else
			{
				_str_name = [[scene()]]->get_name() + "_noname" + [[scene()]]->get_object_id();
			}
		}
	}
	
	function get_name()
	{
		return _str_name;
	}
	
	function get_orig_name()
	{
		return _s.name;
	}
	
	function _spawn( b_hide = true )
	{
		if ( !isdefined( _e ) )
		{
			b_allows_multiple = [[scene()]]->allows_multiple();
			
			if ( /*error( !b_allows_multiple && !isdefined( _s.name ), "Scene that don't allow multiple instances must specify a name for all objects." )
			    || */error( b_allows_multiple && ( isdefined( _s.nospawn ) && _s.nospawn ), "Scene that allow multiple instances must be allowed to spawn (uncheck 'Do Not Spawn')." ) )
			{
				return;
			}
						
			_e = scene::get_existing_ent( _str_name );
			if ( !isdefined( _e ) && isdefined( _s.name ) && !b_allows_multiple )
			{
				_e = scene::get_existing_ent( _s.name );
			}
			
			if ( !isdefined( _e ) && !( isdefined( _s.nospawn ) && _s.nospawn ) && !_b_spawnonce_used )
			{
				_e_align = get_align_ent();
				_e = util::spawn_model( 0, _s.model, _e_align.origin, _e_align.angles );
				
				if ( isdefined( _e ) )
				{
					if ( b_hide )
					{
						_e Hide();	// Hide teleporting glitches
					}
					
					_e.scene_spawned = _o_bundle._s.name;
					_e.targetname = _s.name;
				}
				else
				{
					error( !( isdefined( _s.nospawn ) && _s.nospawn ), "No entity exists with matching name of scene object." );
				}
			}
			
			if ( ( isdefined( _s.spawnonce ) && _s.spawnonce ) && _b_spawnonce_used )
			{
				 return;
			}

			if ( !error( !( isdefined( _s.nospawn ) && _s.nospawn ) && !isdefined( _e ), "No entity exists with matching name of scene object. Make sure a model is specified if you want to spawn it." ) )
			{			
				_prepare();
			}
		}

		if ( isdefined( _e ) )
		{
			flagsys::set( "ready" );
			
			if ( ( isdefined( _s.spawnonce ) && _s.spawnonce ) )
			{
				_b_spawnonce_used = true;
			}
		}
	}
	
	function _prepare()
	{
		if ( !( isdefined( _s.issiege ) && _s.issiege ) )
		{
			if( !_e HasAnimTree() )
			{
				_e UseAnimTree( #animtree );
			}
		}
		
		_e.animname = _str_name;
		_e.anim_debug_name = _s.name;
		
		str_scene_name = [[scene()]]->get_name();
		_e flagsys::set( "scene" );
		_e flagsys::set( str_scene_name );
		_e.current_scene = str_scene_name;
		_e.finished_scene = undefined;
	}
	
	function _cleanup()
	{
		if ( isdefined( _e ) && isdefined( _e.current_scene ) )
		{
			str_scene_name = [[scene()]]->get_name();
			_e flagsys::clear( str_scene_name );
			
			if ( _e.current_scene == str_scene_name )
			{
				_e flagsys::clear( "scene" );
				_e.finished_scene = str_scene_name;
				_e.current_scene = undefined;
			}
		}
		
		if ( isdefined( _o_bundle ) && ( isdefined( _o_bundle.scene_stopped ) && _o_bundle.scene_stopped ) )	// don't clear this if the scene is looping
		{
			_o_bundle = undefined;
		}
	}
	
	function _play_anim( animation, n_delay_min = 0, n_delay_max = 0, n_rate = 1, n_blend, str_siege_shot, loop )
	{
		n_delay = n_delay_min;
		if ( n_delay_max > n_delay_min )
		{
			n_delay = RandomFloatRange( n_delay_min, n_delay_max );
		}
		
		if ( n_delay > 0 )
		{
			flagsys::set( "ready" ); // tell scene to go on without this object
			
			wait n_delay;
			_spawn();
		}
		else
		{
			_spawn();
			
			//[[scene()]]->wait_till_scene_ready();
		}
		
		if ( is_alive() )
		{
			/*
			if ( IS_EQUAL( _e.scene_spawned, _o_bundle._s.name ) )
			{
				_e util::delay( .05, undefined, &Show ); // Entity was hidden to hide teleporting glitches
			}
			*/
			_e Show();
			
			if ( ( isdefined( _s.issiege ) && _s.issiege ) )
			{
				_e notify( "end" ); // make sure previous thread dies
				_e animation::play_siege( animation, str_siege_shot, n_rate, loop );
			}
			else
			{
				align = get_align_ent();
				tag = get_align_tag();
				
				if ( align == level )
				{
					align = ( 0, 0, 0 );
					tag = ( 0, 0, 0 );
				}
			
				_e animation::play( animation, align, tag, n_rate, n_blend );
			}
		}
		else
		{
			/# log( "No entity for animation '" + animation + "' so not playing it." ); #/
		}
		
		_is_valid = is_alive();
	}
	
	function get_align_tag()
	{
		if ( isdefined( _s.AlignTargetTag ) )
		{
			return _s.AlignTargetTag;
		}
		else
		{
			return _o_bundle._s.AlignTargetTag;
		}
	}
		
	function wait_till_scene_ready()
	{
		[[scene()]]->wait_till_scene_ready();
	}
	
	function has_init_state()
	{
		return _s scene::_has_init_state();
	}
	
	function is_alive()
	{
		return isdefined( _e );
	}

	function in_a_different_scene()
	{
		return ( isdefined( _e ) && isdefined( _e.current_scene ) && ( _e.current_scene != [[scene()]]->get_name() ) );
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  ___    ___   ___   _  _   ___ 
// / __|  / __| | __| | \| | | __|
// \__ \ | (__  | _|  | .` | | _| 
// |___/  \___| |___| |_|\_| |___|
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class cScene : cScriptBundleBase
{
	var _e_root;
	var _str_state;
	var _n_object_id;
	var _str_mode;

	constructor()
	{
		_n_object_id = 0;
		_str_state = "";
	}
		
	destructor()
	{
	}
	
	function init( str_scenedef, s_scenedef, e_align, a_ents, b_test_run )
	{
		cScriptBundleBase::init( str_scenedef, s_scenedef, b_test_run );
		
		if ( !isdefined( a_ents ) ) a_ents = []; else if ( !IsArray( a_ents ) ) a_ents = array( a_ents );;
		
		if ( !error( a_ents.size > _s.objects.size, "Trying to use more entities than scene supports." ) )
		{
			_e_root = e_align;
			
			if ( !isdefined( level.active_scenes[ _str_name ] ) ) level.active_scenes[ _str_name ] = []; else if ( !IsArray( level.active_scenes[ _str_name ] ) ) level.active_scenes[ _str_name ] = array( level.active_scenes[ _str_name ] ); level.active_scenes[ _str_name ][level.active_scenes[ _str_name ].size]=_e_root;;
			if ( !isdefined( _e_root.scenes ) ) _e_root.scenes = []; else if ( !IsArray( _e_root.scenes ) ) _e_root.scenes = array( _e_root.scenes ); _e_root.scenes[_e_root.scenes.size]=self;;
			
			a_objs = get_valid_object_defs();
			
			foreach ( str_name, e_ent in ArrayCopy( a_ents ) )
			{
				foreach ( i, s_obj in ArrayCopy( a_objs ) )
				{
					if ( ( s_obj.name === (isdefined(str_name)?""+str_name:"") ) )
					{
						add_object( [[new cSceneObject()]]->first_init( s_obj, self, e_ent ) );
						
						ArrayRemoveIndex( a_ents, str_name );
						ArrayRemoveIndex( a_objs, i );
						
						break;
					}
				}
			}
			
			foreach ( s_obj in a_objs )
			{
				add_object( [[new cSceneObject()]]->first_init( s_obj, self, array::pop( a_ents ) ) );
			}
			
			_e_root thread scene::debug_display();
				
			self thread initialize();
		}
	}
	
	function get_valid_object_defs()
	{
		a_obj_defs = [];
		foreach ( s_obj in _s.objects )
		{
			if ( _s.vmtype == "client" || s_obj.vmtype == "client" )
			{
				if ( isdefined( s_obj.name ) || isdefined( s_obj.model ) || isdefined( s_obj.initanim ) || isdefined( s_obj.mainanim ) )
				{
					if ( !( isdefined( s_obj.disabled ) && s_obj.disabled ) )
					{
						if ( !isdefined( a_obj_defs ) ) a_obj_defs = []; else if ( !IsArray( a_obj_defs ) ) a_obj_defs = array( a_obj_defs ); a_obj_defs[a_obj_defs.size]=s_obj;;
					}
				}
			}
		}
		return a_obj_defs;
	}

	function initialize( b_playing = false )
	{
		self notify( "new_state" );
		self endon( "new_state" );
		
		if ( get_valid_objects().size > 0 )
		{
			level flagsys::set( _str_name + "_initialized" );
			_str_state = "init";
						
			foreach ( o_obj in _a_objects )
			{
				thread [[o_obj]]->initialize();
			}
			
			if ( !b_playing )
			{
				thread _call_state_funcs( "init" );
			}
		}
		
		// stops the scene if all objects die in the initialize state
		wait_till_scene_done();
		thread stop();
	}
	
	function get_object_id()
	{
		_n_object_id++;
		return _n_object_id;
	}

	function play( b_testing = false, str_mode = "" )
	{
		self notify( "new_state" );
		self endon( "new_state" );
		
		_testing = b_testing;
		_str_mode = str_mode;
		
		if ( get_valid_objects().size > 0 )
		{
			foreach ( o_obj in _a_objects )
			{
				thread [[o_obj]]->play();
			}
			
			level flagsys::set( _str_name + "_playing" );
			_str_state = "play";
			
			wait_till_scene_ready();

			thread _call_state_funcs( "play" );
			
			wait_till_scene_done();
			
			array::flagsys_wait_any_flag( _a_objects, "done", "main_done" );
				
			_e_root notify( "scene_done", _str_name );
			thread _call_state_funcs( "done" );
			
			array::flagsys_wait( _a_objects, "done" );

			if ( is_looping() || ( _str_mode == "loop" ) )
			{
				if ( has_init_state() )
				{
					level flagsys::clear( _str_name + "_playing" );
					
					thread initialize();
				}
				else
				{
					level flagsys::clear( _str_name + "_initialized" );
					
					thread play( b_testing, str_mode );
				}
			}
			else
			{
				thread run_next();
				thread stop( false, true );
			}
		}
		else
		{
			thread stop( false, true );
		}
	}
	
	function run_next()
	{
		if ( isdefined( _s.nextscenebundle ) && ( _s.vmtype != "both" ) )
		{
			self waittill( "stopped", b_finished );
			
			if ( b_finished )
			{
				if ( _s.scenetype == "fxanim" && ( _s.nextscenemode === "init" ) )
				{
					if ( !error( !has_init_state(), "Scene can't init next scene '" + _s.nextscenebundle + "' because it doesn't have an init state." ) )
					{
						if ( allows_multiple() )
						{
							_e_root thread scene::init( _s.nextscenebundle, get_ents() );
						}
						else
						{
							_e_root thread scene::init( _s.nextscenebundle );
						}
					}
				}
				else
				{
					if ( allows_multiple() )
					{
						_e_root thread scene::play( _s.nextscenebundle, get_ents() );
					}
					else
					{
						_e_root thread scene::play( _s.nextscenebundle );
					}
				}
			}
		}
	}
		
	function stop( b_clear = false, b_finished = false )
	{
		self notify( "new_state" );
		
		level flagsys::clear( _str_name + "_playing" );
		level flagsys::clear( _str_name + "_initialized" );
		_str_state = "";
		
		thread _call_state_funcs( "stop" );
		
		self.scene_stopped = true;
			
		foreach ( o_obj in _a_objects )
		{
			thread [[o_obj]]->finish( b_clear );
		}
		
		ArrayRemoveValue( level.active_scenes[ _str_name ], _e_root );
		
		if ( level.active_scenes[ _str_name ].size == 0 )
		{
			level.active_scenes[ _str_name ] = undefined;
		}
		
		if ( isdefined( _e_root ) )
		{				
			ArrayRemoveValue( _e_root.scenes, self );
		
			if ( _e_root.scenes.size == 0 )
			{
				_e_root.scenes = undefined;
			}
		}
		
		self notify( "stopped", b_finished );
		_e_root notify( "scene_done", _str_name );
	}
	
	function has_init_state()
	{
		b_has_init_state = false;
		
		foreach ( o_scene_object in _a_objects )
		{
			if ( [[o_scene_object]]->has_init_state() )
			{
				b_has_init_state = true;
				break;
			}
		}
		
		return b_has_init_state;
	}
	
	function _call_state_funcs( str_state )
	{
		self endon( "stopped" );
		
		wait_till_scene_ready();
		
		if ( str_state == "play" )
		{
			waittillframeend;	// HACK: need to allow init callbacks to happen first if init and play happen on same frame
		}
		
		if ( isdefined( level.scene_funcs ) && isdefined( level.scene_funcs[ _str_name ] ) && isdefined( level.scene_funcs[ _str_name ][ str_state ] ) )
		{
			a_ents = get_ents();
			
			foreach ( handler in level.scene_funcs[ _str_name ][ str_state ] )
			{
				func = handler[0];
				args = handler[1];
				
				switch ( args.size )
				{
					case 6:
						_e_root thread [[ func ]]( a_ents, args[0], args[1], args[2], args[3], args[4], args[5] );
						break;
					case 5:
						_e_root thread [[ func ]]( a_ents, args[0], args[1], args[2], args[3], args[4] );
						break;
					case 4:
						_e_root thread [[ func ]]( a_ents, args[0], args[1], args[2], args[3] );
						break;
					case 3:
						_e_root thread [[ func ]]( a_ents, args[0], args[1], args[2] );
						break;
					case 2:
						_e_root thread [[ func ]]( a_ents, args[0], args[1] );
						break;
					case 1:
						_e_root thread [[ func ]]( a_ents, args[0] );
						break;
					case 0:
						_e_root thread [[ func ]]( a_ents );
						break;
					default: AssertMsg( "Too many args passed to scene func." );
				}
			}
		}
	}
	
	function get_ents()
	{
		a_ents = [];
		foreach ( o_obj in _a_objects )
		{
			ent = [[o_obj]]->get_ent();
			
			if ( isdefined( o_obj._s.name ) )
			{
				a_ents[ o_obj._s.name ] = ent;
			}
			else
			{
				if ( !isdefined( a_ents ) ) a_ents = []; else if ( !IsArray( a_ents ) ) a_ents = array( a_ents ); a_ents[a_ents.size]=ent;;
			}
		}
		
		return a_ents;
	}
		
	function get_root()
	{
		return _e_root;
	}
	
	function get_align_ent()
	{
		e_align = _e_root;
		
		if ( isdefined( _s.aligntarget ) )
		{
			e_gdt_align = scene::get_existing_ent( _s.aligntarget );
			if ( isdefined( e_gdt_align ) )
			{
				e_align = e_gdt_align;
			}
		}
		
		return e_align;
	}
	
	function allows_multiple()
	{
		return ( isdefined( _s.allowmultiple ) && _s.allowmultiple );
	}
	
	function is_looping()
	{
		return ( isdefined( _s.looping ) && _s.looping );
	}
	
	function wait_till_scene_ready()
	{
		if ( isdefined( _a_objects ) )
		{
			array::flagsys_wait( _a_objects, "ready" );
		}
	}
	
	function wait_till_scene_done()
	{
		array::flagsys_wait( _a_objects, "done" );
	}
	
	function get_valid_objects()
	{
		a_obj = [];
		
		foreach ( obj in _a_objects )
		{
			if ( obj._is_valid && ![[obj]]->in_a_different_scene() )
			{
				if ( !isdefined( a_obj ) ) a_obj = []; else if ( !IsArray( a_obj ) ) a_obj = array( a_obj ); a_obj[a_obj.size]=obj;;
			}
		}
		
		return a_obj;
	}
	
	function on_error()
	{
		stop();
	}
	
	function get_state()
	{
		return _str_state;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  _  _   ___   _      ___   ___   ___   ___ 
// | || | | __| | |    | _ \ | __| | _ \ / __|
// | __ | | _|  | |__  |  _/ | _|  |   / \__ \
// |_||_| |___| |____| |_|   |___| |_|_\ |___/
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function get_existing_ent( str_name )
{
	e = GetEnt( 0, str_name, "animname" );	// entity already exists
	if ( !isdefined( e ) )
	{
		e = GetEnt( 0, str_name, "script_animname" );	// a spawner exists with script_animname
		if ( !isdefined( e ) )
		{
			e = GetEnt( 0, str_name, "targetname" );	// lastly grab any ent with targetname
			if ( !isdefined( e ) )
			{
				e = struct::get( str_name, "targetname" );	// if no ent, grab struct with targetname
			}
		}
	}
	
	return e;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  _   _   _____   ___   _      ___   _____  __   __
// | | | | |_   _| |_ _| | |    |_ _| |_   _| \ \ / /
// | |_| |   | |    | |  | |__   | |    | |    \ V / 
//  \___/    |_|   |___| |____| |___|   |_|     |_|  
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function autoexec __init__sytem__() {     system::register("scene",&__init__,&__main__,undefined);    }

function __init__()
{
	a_scenedefs = struct::get_script_bundles( "scene" );
	
	/* FIX UP STUFF FROM THE GDT */
	
	level.server_scenes = [];
	
	foreach ( s_scenedef in a_scenedefs )
	{
		s_scenedef.editaction = undefined;	// only used in the asset editor
		s_scenedef.newobject = undefined;	// only used in the asset editor
		
		if ( s_scenedef is_igc() )
		{
			level.server_scenes[ s_scenedef.name ] = s_scenedef; // This is used in code callback through xcam code to make sure client scenes sync with the xcam
		}
		else if ( s_scenedef.vmtype == "both" )
		{
			n_clientbits = GetMinBitCountForNum( 3 );
			
			/#
				n_clientbits = GetMinBitCountForNum( 6 );
			#/
			
			clientfield::register( "world", s_scenedef.name, 1, n_clientbits, "int", &cf_server_sync, !true, !true );
		}
	}
	
	clientfield::register( "toplayer", "postfx_igc", 1, 1, "counter", &postfx_igc, !true, !true );
	clientfield::register( "toplayer", "exposure_ignore_teleport", 1, 1, "int", &exposure_ignore_teleport, !true, !true );
	
	/* INIT SYSTEM VARS */
	
	level.scene_object_id = 0;	
	level.active_scenes = [];
}

function postfx_igc( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		self thread postfx::PlayPostfxBundle( "pstfx_igc" );
		//Play DNI Interrupt Sound
		//playsound( 0, "evt_dni_interrupt", (0,0,0) ); //TODO: put new sound here
	}
}

function exposure_ignore_teleport( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	SetExposureIgnoreTeleport( localClientNum, newVal );
}

function cf_server_sync( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	switch ( newVal )
	{
		case 0:
			
			if ( is_active( fieldName ) )
			{
				level thread scene::stop( fieldName );
			}
			
			break;
				
		case 1:
				
			level thread scene::init( fieldName );
			break;
				
		case 2:
				
			level thread scene::play( fieldName );
			break;
	}
	
	/#

		switch ( newVal )
		{
			case 3:
			
				if ( is_active( fieldName ) )
				{
					level thread scene::stop( fieldName, true, undefined, undefined, true );
				}
				
				break;
			
			case 4:
				
				level thread scene::init( fieldName, undefined, undefined, true );
				break;
				
			case 5:
				
				level thread scene::play( fieldName, undefined, undefined, true );
				break;
		}
	
	#/
}

function remove_invalid_scene_objects( s_scenedef )
{
	a_invalid_object_indexes = [];
	
	foreach ( i, s_object in s_scenedef.objects )
	{
		if ( !isdefined( s_object.name ) && !isdefined( s_object.model ) )
		{
			if ( !isdefined( a_invalid_object_indexes ) ) a_invalid_object_indexes = []; else if ( !IsArray( a_invalid_object_indexes ) ) a_invalid_object_indexes = array( a_invalid_object_indexes ); a_invalid_object_indexes[a_invalid_object_indexes.size]=i;;
		}
	}
	
	for ( i = a_invalid_object_indexes.size - 1; i >= 0 ; i-- )
	{
		ArrayRemoveIndex( s_scenedef.objects, a_invalid_object_indexes[i] );
	}
	
	return s_scenedef;
}

function is_igc()
{
	return ( IsString( self.cameraswitcher )
	        || IsString( self.extraCamSwitcher1 )
	        || IsString( self.extraCamSwitcher2 )
	        || IsString( self.extraCamSwitcher3 )
	        || IsString( self.extraCamSwitcher4 ) );
}

function __main__()
{
	wait(0.05);//wait for initialization stage to end so we can toggle client fields
	/* RUN INSTANCES */
			
	a_instances = ArrayCombine(
							struct::get_array( "scriptbundle_scene", "classname" ),
	                        struct::get_array( "scriptbundle_fxanim", "classname" ),
	                        false, false
	                       );
	
	foreach ( s_instance in a_instances )
	{
		/* TODO: can we get these to work client side? The KVPs aren't currently available client side
		if ( isdefined( s_instance.scriptgroup_initscenes ) )
		{
			trigs = GetEntArray( 0, s_instance.scriptgroup_initscenes, "scriptgroup_initscenes" );
			if ( isdefined( trigs ) )
			{
				foreach ( trig in trigs )
				{
					s_instance thread _trigger_init( trig );
				}
			}
		}
		
		if ( isdefined( s_instance.scriptgroup_playscenes ) )
		{
			trigs = GetEntArray( 0, s_instance.scriptgroup_playscenes, "scriptgroup_playscenes" );
			if ( isdefined( trigs ) )
			{
				foreach ( trig in trigs )
				{
					s_instance thread _trigger_play( trig );
				}
			}
		}
		
		if ( isdefined( s_instance.scriptgroup_stopscenes ) )
		{
			trigs = GetEntArray( 0, s_instance.scriptgroup_stopscenes, "scriptgroup_stopscenes" );
			if ( isdefined( trigs ) )
			{
				foreach ( trig in trigs )
				{
					s_instance thread _trigger_stop( trig );
				}
			}
		}
		*/
		
		/# s_instance thread debug_display(); #/
	}
	
	foreach ( s_instance in a_instances )
	{
		s_scenedef = struct::get_script_bundle( "scene", s_instance.scriptbundlename );
		
		if ( s_scenedef.vmtype == "client" )
		{		
			if ( (isdefined(s_instance.spawnflags)&&((s_instance.spawnflags & 2) == 2)) )
			{
				s_instance thread play();
			}
			else if ( (isdefined(s_instance.spawnflags)&&((s_instance.spawnflags & 1) == 1)) )
			{
				s_instance thread init();
			}
			
			/# s_instance thread debug_display(); #/
		}
	}
}

function _trigger_init( trig )
{
	trig endon( "death" );
	trig waittill( "trigger" );
	_init_instance();
}

function _trigger_play( trig )
{
	trig endon( "death" );
	
	do
	{	
		trig waittill( "trigger" );
		_play_instance();
	}
	while ( ( isdefined( get_scenedef( self.scriptbundlename ).looping ) && get_scenedef( self.scriptbundlename ).looping ) );
}

function _trigger_stop( trig )
{
	trig endon( "death" );
	trig waittill( "trigger" );
	_stop_instance();
}

/@
"Summary: Adds a function to be called when a scene starts"
"SPMP: shared"

	
"Name: add_scene_func( str_scenedef, func, str_state = "play" )"
"CallOn: level"
"MandatoryArg: <str_scenedef> Name of scene"
"MandatoryArg: <func> function to call when scene starts"
"OptionalArg: [str_state] set to "init" or "done" if you want to the function to get called in one of those states"

"Example: level scene::init( "my_scenes", "targetname" );"
@/
function add_scene_func( str_scenedef, func, str_state = "play", ... )
{
	if(!isdefined(level.scene_funcs))level.scene_funcs=[];
	if(!isdefined(level.scene_funcs[ str_scenedef ]))level.scene_funcs[ str_scenedef ]=[];
	if ( !isdefined( level.scene_funcs[ str_scenedef ][ str_state ] ) ) level.scene_funcs[ str_scenedef ][ str_state ] = []; else if ( !IsArray( level.scene_funcs[ str_scenedef ][ str_state ] ) ) level.scene_funcs[ str_scenedef ][ str_state ] = array( level.scene_funcs[ str_scenedef ][ str_state ] ); level.scene_funcs[ str_scenedef ][ str_state ][level.scene_funcs[ str_scenedef ][ str_state ].size]=Array( func, vararg );;
}

/@
"Summary: Removes a function to be called when a scene starts"
"SPMP: shared"


"Name: remove_scene_func( str_scenedef, func, str_state = "play" )"
"CallOn: level"
"MandatoryArg: <str_scenedef> Name of scene"
"MandatoryArg: <func> function to remove"
"OptionalArg: [str_state] set to "init" or "done" if you want to the function to get removed from one of those states"
"Example: level scene::init( "my_scenes", "targetname" );"
@/
function remove_scene_func( str_scenedef, func, str_state = "play" )
{
	if(!isdefined(level.scene_funcs))level.scene_funcs=[];
	
	if ( isdefined( level.scene_funcs[ str_scenedef ] ) && isdefined( level.scene_funcs[ str_scenedef ][ str_state ] ) )
	{
		for ( i = level.scene_funcs[ str_scenedef ][ str_state ].size - 1; i >= 0; i-- )
		{
			if ( level.scene_funcs[ str_scenedef ][ str_state ][ i ][ 0 ] == func )
			{
				ArrayRemoveIndex( level.scene_funcs[ str_scenedef ][ str_state ], i );
			}
		}
	}
}

/@
"Summary: Spawns a scene"
"SPMP: shared"


"Name: spawn( str_scenedef, v_origin, v_angles, ents )"
"CallOn: NA
"MandatoryArg: <str_scenedef> Name of scene to spawn"
"OptionalArg: [v_origin] The origin to spawn the scene at - defaults to (0, 0, 0)"
"OptionalArg: [v_angles] The angles to spawn the scene at - defaults to (0, 0, 0)"
"OptionalArg: [a_ents] Entities to use for the scene"
"Example: level scene::spawn( "my_scene", (99, 45, 156) );"


"Name: spawn( str_scenedef, ents, v_origin, v_angles )"
"CallOn: NA
"MandatoryArg: <str_scenedef> Name of scene to spawn"
"OptionalArg: [a_ents] Entities to use for the scene"
"OptionalArg: [v_origin] The origin to spawn the scene at - defaults to (0, 0, 0)"
"OptionalArg: [v_angles] The angles to spawn the scene at - defaults to (0, 0, 0)"
"Example: level scene::spawn( "my_scene", array( my_ent1, my_ent2 ) );"
@/
function spawn( arg1, arg2, arg3, arg4, b_test_run )
{
	str_scenedef = arg1;
	
	Assert( isdefined( str_scenedef ), "Cannot create a scene without a scene def." );
	
	if ( IsVec( arg2 ) )
	{
		v_origin = arg2;
		v_angles = arg3;
		a_ents = arg4;
	}
	else	// overloaded the params so you can put them in different orders
	{
		a_ents = arg2;
		v_origin = arg3;
		v_angles = arg4;
	}
	
	s_instance = SpawnStruct();
	s_instance.origin = ( isdefined( v_origin ) ? v_origin : (0, 0, 0) );
	s_instance.angles = ( isdefined( v_angles ) ? v_angles : (0, 0, 0) );
	s_instance.classname = "scriptbundle_scene";
	s_instance.scriptbundlename = str_scenedef;
	s_instance struct::init();
	
	s_instance scene::init( str_scenedef, a_ents, undefined, b_test_run );
		
	return s_instance;
}

/@
"Summary: Initializes a scene or multiple scenes"
"SPMP: shared"
	

"Name: init( str_val, str_key, ents )"
"CallOn: level using KVP to specify the scene instances"
"MandatoryArg: <str_val> value of the KVP of the scene entity"
"MandatoryArg: <str_key> key of the KVP of the scene entity"
"OptionalArg: [ents] override the entities used for this scene"
"Example: level scene::init( "my_scenes", "targetname" );"
	

"Name: init( str_scenedef, ents )"
"CallOn: level"
"MandatoryArg: <str_scenedef> specify the scene name, will play all instances of this scene"
"OptionalArg: [ents] override the entities used for this scene"
"Example: level scene::init( "level1_scene_3" );"
	
	
"Name: init( str_scenedef, ents )"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"OptionalArg: [str_scenedef] specify the scene name if needed"
"OptionalArg: [ents] override the entities used for this scene"
"Example: e_scene_root scene::init( "level1_scene_3" );"
	
	
"Name: init( ents, str_scenedef )"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"OptionalArg: [ents] override the entities used for this scene"
"OptionalArg: [str_scenedef] specify the scene name if needed"
"Example: s_scene_object scene::init( array( e_guy1, e_guy2 ) );"
@/
function init( arg1, arg2, arg3, b_test_run )
{
	if ( self == level )
	{
		if ( IsString( arg1 ) )
		{
			if ( IsString( arg2 ) )
			{
				str_value	= arg1;
				str_key		= arg2;
				a_ents		= arg3;
			}
			else
			{
				str_value	= arg1;
				str_key		= "scriptbundlename";
				a_ents		= arg2;
			}
			
			a_instances = struct::get_array( str_value, str_key );
			
			if ( a_instances.size == 0 )
			{
				if ( str_key == "scriptbundlename" )
				{
					level _init_instance( str_value, a_ents, b_test_run );
				}
				else
				{
					/#
			
					AssertMsg( "No scene instances with KVP '" + str_key + "'/'" + str_value + "'." );
					
					#/
				}
			}
			
			foreach ( s_instance in a_instances )
			{
				if ( isdefined( s_instance ) )
				{
					s_instance _init_instance( undefined, a_ents, b_test_run );
				}
			}
		}
	}
	else
	{
		if ( IsString( arg1 ) )
		{
			_init_instance( arg1, arg2, b_test_run );
		}
		else
		{		
			_init_instance( arg2, arg1, b_test_run );
		}
		
		return self;
	}
}

function get_scenedef( str_scenedef )
{
	return struct::get_script_bundle( "scene", str_scenedef );
}

function get_scenedefs( str_type = "scene" )
{
	a_scenedefs = [];
	
	foreach ( s_scenedef in struct::get_script_bundles( "scene" ) )
	{
		if ( s_scenedef.sceneType == str_type )
		{
			if ( !isdefined( a_scenedefs ) ) a_scenedefs = []; else if ( !IsArray( a_scenedefs ) ) a_scenedefs = array( a_scenedefs ); a_scenedefs[a_scenedefs.size]=s_scenedef;;
		}
	}
	
	return a_scenedefs;
}

function _init_instance( str_scenedef, a_ents, b_test_run = false )
{
	if(!isdefined(str_scenedef))str_scenedef=self.scriptbundlename;
	
	s_bundle = get_scenedef( str_scenedef );
	
	/#
	
	Assert( isdefined( str_scenedef ), "Scene at (" + ( isdefined( self.origin ) ? self.origin : "level" ) + ") is missing its scene def." );
	Assert( isdefined( s_bundle ), "Scene at (" + ( isdefined( self.origin ) ? self.origin : "level" ) + ") is using a scene name '" + str_scenedef + "' that doesn't exist." );
	
	#/
	
	o_scene = get_active_scene( str_scenedef );
	
	if ( isdefined( self.scriptbundlename ) )
	{
		if ( ( isdefined( self.scene_initialized ) && self.scene_initialized ) && !b_test_run )
		{
			return o_scene;
		}
		
		self.scene_initialized = true;
	}
	
	if ( !isdefined( o_scene ) )
	{
		o_scene = new cScene();
		[[o_scene]]->init( str_scenedef, s_bundle, self, a_ents, b_test_run );
	}
	else
	{
		thread [[o_scene]]->initialize( true );
	}
	
	return o_scene;
}

/@
"Summary: Plays a scene or multiple scenes"
"SPMP: shared"


"Name: play( str_val, str_key, ents )"
"CallOn: level using KVP to specify the scene instances"
"MandatoryArg: <str_val> value of the KVP of the scene entity"
"MandatoryArg: <str_key> key of the KVP of the scene entity"
"OptionalArg: [ents] override the entities used for this scene"
"Example: level scene::play( "my_scenes", "targetname" );"


"Name: play( str_scenedef, ents )"
"CallOn: level"
"MandatoryArg: <str_scenedef> specify the scene name, will play all instances of this scene"
"OptionalArg: [ents] override the entities used for this scene"	
"Example: level scene::play( "level1_scene_3" );"

	
"Name: play( str_scenedef, ents )"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"OptionalArg: [str_scenedef] specify the scene name if needed"
"OptionalArg: [ents] override the entities used for this scene"	
"Example: e_scene_root scene::play( "level1_scene_3" );"


"Name: play( ents, str_scenedef )"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"OptionalArg: [ents] override the entities used for this scene"
"OptionalArg: [str_scenedef] specify the scene name if needed"
"Example: s_scene_object scene::play( array( e_guy1, e_guy2 ) );"
@/
function play( arg1, arg2, arg3, b_test_run = false, str_mode = "" )
{
	s_tracker = SpawnStruct();
	s_tracker.n_scene_count = 1;
	
	if ( self == level )
	{
		if ( IsString( arg1 ) )
		{
			if ( IsString( arg2 ) )
			{
				str_value	= arg1;
				str_key		= arg2;
				a_ents		= arg3;
			}
			else
			{
				str_value	= arg1;
				str_key		= "scriptbundlename";
				a_ents		= arg2;
			}
			
			a_instances = struct::get_array( str_value, str_key );
			
			if ( a_instances.size == 0 )
			{
				if ( str_key == "scriptbundlename" )
				{
					self thread _play_instance( s_tracker, str_value, a_ents, b_test_run, str_mode );
				}
				else
				{
					/#
			
					AssertMsg( "No scene instances with KVP '" + str_key + "'/'" + str_value + "'." );
					
					#/
				}
			}
			
			if ( a_instances.size )
			{
				s_tracker.n_scene_count = a_instances.size;
				
				foreach ( s_instance in a_instances )
				{
					if ( isdefined( s_instance ) )
					{
						s_instance thread _play_instance( s_tracker, undefined, a_ents, b_test_run, str_mode );
					}
				}
				
				// TODO: these need to wait on a waittillmatch for the specific scenename
				array::wait_till( a_instances, "scene_done" );
			}
		}
	}
	else
	{
		if ( IsString( arg1 ) )
		{
			self thread _play_instance( s_tracker, arg1, arg2, b_test_run, str_mode );
		}
		else
		{
			self thread _play_instance( s_tracker, arg2, arg1, b_test_run, str_mode );
		}
	}
	
	for ( i = 0; i < s_tracker.n_scene_count; i++ )
	{	
		s_tracker waittill( "scene_done" );
	}
}

function _play_instance( s_tracker, str_scenedef, a_ents, b_test_run, str_mode )
{
	if ( isdefined( self.scriptbundlename ) && !isdefined( str_scenedef ) )
	{
		str_scenedef = self.scriptbundlename;
		
		if ( !( isdefined( self.script_play_multiple ) && self.script_play_multiple ) )
		{
			if ( ( isdefined( self.scene_played ) && self.scene_played ) && !b_test_run )
			{
				return;
			}
		}
		
		self.scene_played = true;
	}
	
	o_scene = _init_instance( str_scenedef, a_ents, b_test_run );	
	thread [[o_scene]]->play( b_test_run, str_mode );
	
	self waittillmatch( "scene_done", str_scenedef );
	
	if ( isdefined( self.scriptbundlename ) && ( isdefined( get_scenedef( self.scriptbundlename ).looping ) && get_scenedef( self.scriptbundlename ).looping ) )
	{
		self.scene_played = false;
	}
	
	s_tracker notify( "scene_done" );
}

/@
"Summary: Stops a scene or multiple scenes"
"SPMP: shared"


"Name: stop( str_val, str_key, b_clear )"
"CallOn: level using KVP to specify the scene instances"
"MandatoryArg: <str_val> value of the KVP of the scene entity"
"MandatoryArg: <str_key> key of the KVP of the scene entity"
"OptionalArg: [b_clear] optionally delete the ents if they were spawned by the scene, regardless of options in scene definition"	
"Example: level scene::stop( "my_scenes", "targetname" );"
	
	
"Name: stop( str_scenedef, b_clear )"
"CallOn: level"
"MandatoryArg: <str_scenedef> specify the scene name, will stop all instances of this scene"
"OptionalArg: [b_clear] optionally delete the ents if they were spawned by the scene, regardless of options in scene definition"
"Example: level scene::stop( "level1_scene_3" );"
	
	
"Name: stop( str_scenedef, b_clear )"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"OptionalArg: [str_scenedef] specify the scene name if multiple scenes are running on the entity"
"OptionalArg: [b_clear] optionally delete the ents if they were spawned by the scene, regardless of options in scene definition"
"Example: e_my_scene scene::stop( "level1_scene_3" );"
	
	
"Name: stop( b_clear, str_scenedef )"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"OptionalArg: [b_clear] optionally delete the ents if they were spawned by the scene, regardless of options in scene definition"
"OptionalArg: [str_scenedef] specify the scene name if multiple scenes are running on the entity"
"Example: s_scene_object scene::stop( true );"
@/
function stop( arg1, arg2, arg3, b_cancel, b_no_assert = false )
{
	if ( self == level )
	{
		if ( IsString( arg1 ) )
		{
			if ( IsString( arg2 ) )
			{
				/* Stop all instances by KVP */
				
				b_clear		= arg3;				
				a_instances = struct::get_array( arg1, arg2 );
				
				/#
			
				Assert( a_instances.size > 0, "No scene instances with KVP '" + arg2 + "'/'" + arg1 + "'." );
				
				#/
					
				foreach ( s_instance in ArrayCopy( a_instances ) )
				{
					if ( isdefined( s_instance ) )
					{
						s_instance _stop_instance( b_clear, undefined, b_cancel );
					}
				}
			}
			else
			{
				/* Stop all instances of a specific scenedef */
				
				b_clear		= arg2;
				a_instances = get_active_scenes( arg1 );
				
				/#
			
				if ( IsString( arg1 ) )
				{
					Assert( b_no_assert || ( isdefined( a_instances ) && a_instances.size > 0 ), "No scenes definitions with GDT name '" + arg1 + "'." );
				}
				
				#/
				
				foreach ( s_instance in ArrayCopy( a_instances ) )
				{
					if ( isdefined( s_instance ) )
					{
						s_instance _stop_instance( b_clear, arg1, b_cancel );
					}
				}
			}
		}
	}
	else
	{
		if ( IsString( arg1 ) )
		{
			_stop_instance( arg2, arg1, b_cancel );
		}
		else
		{
			_stop_instance( arg1, arg2, b_cancel );
		}
	}
}

function _stop_instance( b_clear = false, str_scenedef, b_cancel = false )
{
	if ( isdefined( self.scenes ) )
	{
		foreach ( o_scene in ArrayCopy( self.scenes ) )
		{
			str_scene_name = [[o_scene]]->get_name();
			
			if ( !isdefined( str_scenedef ) || ( str_scene_name == str_scenedef ) )
			{
				thread [[o_scene]]->stop( b_clear, b_cancel );
			}
		}
	}
}

function cancel( arg1, arg2, arg3 )
{
	stop( arg1, arg2, arg3, true );
}

function has_init_state( str_scenedef )
{
	s_scenedef = get_scenedef( str_scenedef );
	foreach ( s_obj in s_scenedef.objects )
	{
		if ( !( isdefined( s_obj.disabled ) && s_obj.disabled ) && s_obj _has_init_state() )
		{
			return true;
		}
	}
	
	return false;
}

function _has_init_state()
{
	return ( ( isdefined( self.spawnoninit ) && self.spawnoninit ) || isdefined( self.initanim ) || isdefined( self.initanimloop ) || ( isdefined( self.firstframe ) && self.firstframe ) );
}

/@
"Summary: returns the number of props defined for a scene"
"SPMP: shared"


"Name: get_prop_count( str_scenedef )"
"CallOn: Any"
"MandatoryArg: <str_scenedef> scene definition name (from gdt)"
"Example: level scene::get_prop_count( "my_scene" );"

	
"Name: get_prop_count()"
"CallOn: scene object"
"Example: s_scene scene::get_prop_count();"
@/
function get_prop_count( str_scenedef )
{
	return _get_type_count( "prop", str_scenedef );
}

/@
"Summary: returns the number of vehicles defined for a scene"
"SPMP: shared"


"Name: get_vehicle_count( str_scenedef )"
"CallOn: Any"
"MandatoryArg: <str_scenedef> scene definition name (from gdt)"
"Example: level scene::get_vehicle_count( "my_scene" );"

	
"Name: get_vehicle_count()"
"CallOn: scene object"
"Example: s_scene scene::get_vehicle_count();"
@/
function get_vehicle_count( str_scenedef )
{
	return _get_type_count( "vehicle", str_scenedef );
}

/@
"Summary: returns the number of actors defined for a scene"
"SPMP: shared"


"Name: get_actor_count( str_scenedef )"
"CallOn: Any"
"MandatoryArg: <str_scenedef> scene definition name (from gdt)"
"Example: level scene::get_actor_count( "my_scene" );"

	
"Name: get_actor_count()"
"CallOn: scene object"
"Example: s_scene scene::get_actor_count();"
@/
function get_actor_count( str_scenedef )
{
	return _get_type_count( "actor", str_scenedef );
}

/@
"Summary: returns the number of actors defined for a scene"
"SPMP: shared"


"Name: get_player_count( str_scenedef )"
"CallOn: Any"
"MandatoryArg: <str_scenedef> scene definition name (from gdt)"
"Example: level scene::get_player_count( "my_scene" );"

	
"Name: get_player_count()"
"CallOn: scene object"
"Example: s_scene scene::get_player_count();"
@/
function get_player_count( str_scenedef )
{
	return _get_type_count( "player", str_scenedef );
}

function _get_type_count( str_type, str_scenedef )
{
	s_scenedef = ( isdefined( str_scenedef ) ? get_scenedef( str_scenedef ) : get_scenedef( self.scriptbundlename ) );
	
	n_count = 0;
	foreach ( s_obj in s_scenedef.objects )
	{
		if ( isdefined( s_obj.type ) )
		{
			if ( ToLower( s_obj.type ) == ToLower( str_type ) )
			{
				n_count++;
			}
		}
	}
	
	return n_count;
}

/@
"Summary: Checks if a scene is playing"
"SPMP: shared"

"Name: is_active( str_scenedef )"
"CallOn: level or a scene instance"
"OptionalArg: [str_scenedef] The name of the scene to check"
"Example: level scene::is_active( "my_scene" );"
"Example: s_scene scene::is_active();"
@/
function is_active( str_scenedef )
{
	if ( self == level )
	{
		return ( get_active_scenes( str_scenedef ).size > 0 );
	}
	else
	{
		return ( isdefined( get_active_scene( str_scenedef ) ) );
	}
}

/@
"Summary: Checks if a scene is playing"
"SPMP: shared"

"Name: is_playing( str_scenedef )"
"OptionalArg: [str_scenedef] The name of the scene to check"
"Example: s_scene scene::is_playing( "my_scene" );"
"Example: s_scene scene::is_playing();"
@/
function is_playing( str_scenedef )
{
	if ( self == level )
	{
		return ( level flagsys::get( str_scenedef + "_playing" ) );
	}
	else
	{
		if(!isdefined(str_scenedef))str_scenedef=self.scriptbundlename;
		
		o_scene = get_active_scene( str_scenedef );
		if ( isdefined( o_scene ) )
		{
			return ( ( o_scene._str_state === "play" ) );
		}
	}
	
	return false;
}

function get_active_scenes( str_scenedef )
{
	if ( isdefined( str_scenedef ) )
	{
		return ( isdefined( level.active_scenes[ str_scenedef ] ) ? level.active_scenes[ str_scenedef ] : [] );
	}
	else
	{
		a_active_scenes = [];
		foreach ( str_scenedef in level.active_scenes )
		{
			ArrayCombine( a_active_scenes, level.active_scenes[ str_scenedef ], false, false );
		}
		
		return a_active_scenes;
	}
}

function get_active_scene( str_scenedef )
{
	if ( isdefined( str_scenedef ) && isdefined( self.scenes ) )
	{
		foreach ( o_scene in self.scenes )
		{			
			if ( [[o_scene]]->get_name() == str_scenedef )
			{
				return o_scene;
			}
		}
	}
}
