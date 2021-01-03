/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// http://tawiki/display/Design/Scene+System /////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_debug_shared;
#using scripts\shared\scriptbundle_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using_animtree( "generic" );

#namespace scene;











	

	
// Player weapon animation indexes defined in code


	


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  ___    ___   ___   _  _   ___      ___    ___      _   ___    ___   _____ 
// / __|  / __| | __| | \| | | __|    / _ \  | _ )  _ | | | __|  / __| |_   _|
// \__ \ | (__  | _|  | .` | | _|    | (_) | | _ \ | || | | _|  | (__    | |  
// |___/  \___| |___| |_|\_| |___|    \___/  |___/  \__/  |___|  \___|   |_|  
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class cSceneObject : cScriptBundleObjectBase
{
	var _b_spawnonce_used;
	var _is_valid;
	var _str_name; 
	var _str_state;
	var _player;
	var _str_death_anim;
	var _str_death_anim_loop;
	var _b_set_goal;
	
	constructor()
	{
		_is_valid = true;
		_b_spawnonce_used = false;
		_b_set_goal = true;
	}
	
	destructor()
	{
	}
	
	function first_init( s_objdef, o_scene, e_ent )
	{
		cScriptBundleObjectBase::init( s_objdef, o_scene, e_ent );
			
		_assign_unique_name();
						
		return self;
	}
	
	function initialize()
	{
		if ( has_init_state() )
		{
			flagsys::clear( "ready" );   flagsys::clear( "done" );   flagsys::clear( "main_done" );   _str_state = "init";   self notify( "new_state" );   self endon( "new_state" );   self notify("init");   waittillframeend;;
			
			if ( ( isdefined( _s.spawnoninit ) && _s.spawnoninit ) )
			{
				_spawn( undefined, ( isdefined( _s.firstframe ) && _s.firstframe ) || isdefined( _s.initanim ) || isdefined( _s.initanimloop ) );
			}
			
			if ( ( isdefined( _s.firstframe ) && _s.firstframe ) )
			{
				if ( !error( !isdefined( _s.mainanim ), "No animation defined for first frame." ) )
				{
					_str_death_anim = _s.mainanimdeath;
					_str_death_anim_loop = _s.mainanimdeathloop;
					
					_play_anim( _s.mainanim, 0, 0, 0 );
				}
			}
			else if ( isdefined( _s.initanim ) )
			{
				_str_death_anim = _s.initanimdeath;
				_str_death_anim_loop = _s.initanimdeathloop;
				
				_play_anim( _s.initanim, _s.initdelaymin, _s.initdelaymax, 1 );
				
				if ( is_alive() )
				{
					if ( isdefined( _s.initanimloop ) )
					{
						_str_death_anim = _s.initanimloopdeath;
						_str_death_anim_loop = _s.initanimloopdeathloop;
						
						_play_anim( _s.initanimloop, 0, 0, 1 );
					}
				}
			}
			else if ( isdefined( _s.initanimloop ) )
			{
				_str_death_anim = _s.initanimloopdeath;
				_str_death_anim_loop = _s.initanimloopdeathloop;
				
				_play_anim( _s.initanimloop, _s.initdelaymin, _s.initdelaymax, 1 );
			}
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
		flagsys::clear( "ready" );   flagsys::clear( "done" );   flagsys::clear( "main_done" );   _str_state = "play";   self notify( "new_state" );   self endon( "new_state" );   self notify("play");   waittillframeend;;
		
		if ( isdefined( _s.mainanim ) && _is_valid )
		{
			_str_death_anim = _s.mainanimdeath;
			_str_death_anim_loop = _s.mainanimdeathloop;

			_play_anim( _s.mainanim, _s.maindelaymin, _s.maindelaymax, 1, _s.mainblend, _o_bundle.n_start_time );
			
			flagsys::set( "main_done" );
			
			if ( isdefined( _e ) && ( isdefined( _s.DynamicPaths ) && _s.DynamicPaths ) )
			{
				if ( Distance2DSquared( _e.origin, _e.scene_orig_origin ) > 4 )
				{
					_e DisconnectPaths();
				}
			}
			
			if ( is_alive() )
			{
				if ( isdefined( _s.endanim ) )
				{
					_str_death_anim = _s.endanimdeath;
					_str_death_anim_loop = _s.endanimdeathloop;
					
					_play_anim( _s.endanim, 0, 0, 1 );
					
					if ( is_alive() )
					{
						if ( isdefined( _s.endanimloop ) )
						{
							_str_death_anim = _s.endanimloopdeath;
							_str_death_anim_loop = _s.endanimloopdeathloop;
							
							_play_anim( _s.endanimloop, 0, 0, 1 );
						}
					}
				}
				else if ( isdefined( _s.endanimloop ) )
				{
					_str_death_anim = _s.endanimloopdeath;
					_str_death_anim_loop = _s.endanimloopdeathloop;
					
					_play_anim( _s.endanimloop, 0, 0, 1 );
				}
			}
		}
		
		thread finish();
	}
	
	function stop( b_clear = false )
	{
		if ( IsAlive( _e ) )
		{
			if ( is_shared_player() )
			{
				foreach ( player in level.players )
				{
					player StopAnimScripted( .2 );
				}
			}
			else if( IsActor(_e) || IsVehicle(_e) || IsPlayer( _e) )
			{
				_e StopAnimScripted( .2 );
			}
		}
		
		finish( b_clear );
	}
	
	function get_align_ent()
	{
		e_align = undefined;
		
		if ( isdefined( _s.aligntarget ) && !( _s.aligntarget === _o_bundle._s.aligntarget ) )
		{
			a_scene_ents = [[_o_bundle]]->get_ents();
			if ( isdefined( a_scene_ents[ _s.aligntarget ] ) )
			{
				e_align = a_scene_ents[ _s.aligntarget ];
			}
			else
			{
				e_align = scene::get_existing_ent( _s.aligntarget, false, true );
			}
			
			if ( !isdefined( e_align ) )
			{
				str_msg = "Align target '" + (isdefined(_s.aligntarget)?""+_s.aligntarget:"") + "' doesn't exist for scene object.";
				
				if ( !warning( _o_bundle._testing, str_msg ) )
				{
					error( GetDvarInt( "scene_align_errors", 1 ), str_msg );
				}
			}
		}
		
		if ( !isdefined( e_align ) )
		{
			e_align = [[scene()]]->get_align_ent();
		}
		
		return e_align;
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
	
	/* Scene Helpers */
	
	function scene()
	{
		return _o_bundle;
	}
		
	/* internal functions */
	
	function _on_damage_run_scene_thread()
	{
		self endon( "play" );
		self endon( "stop" );
		
		str_damage_types = ( !isdefined( _s.runsceneondmg0 ) || _s.runsceneondmg0 == "none" ? "" : _s.runsceneondmg0 ) + ( !isdefined( _s.runsceneondmg1 ) || _s.runsceneondmg1 == "none" ? "" : _s.runsceneondmg1 ) + ( !isdefined( _s.runsceneondmg2 ) || _s.runsceneondmg2 == "none" ? "" : _s.runsceneondmg2 ) + ( !isdefined( _s.runsceneondmg3 ) || _s.runsceneondmg3 == "none" ? "" : _s.runsceneondmg3 ) + ( !isdefined( _s.runsceneondmg4 ) || _s.runsceneondmg4 == "none" ? "" : _s.runsceneondmg4 );
		
		if ( str_damage_types != "" )
		{			
			b_run_scene = false;
			
			while ( !b_run_scene )
			{
				_e waittill( "damage", n_amount, e_attacker, v_org, v_dir, str_mod );
				
				switch ( str_mod )
				{
					case "MOD_PISTOL_BULLET":
					case "MOD_RIFLE_BULLET":
						
						if ( IsSubStr( str_damage_types, "bullet" ) )
						{
							b_run_scene = true;
						}
						
						break;
					
					case "MOD_GRENADE":
					case "MOD_GRENADE_SPLASH":
					case "MOD_EXPLOSIVE":
						
						if ( IsSubStr( str_damage_types, "explosive" ) )
						{
							b_run_scene = true;
						}
						
						break;
						
					case "MOD_PROJECTILE":
					case "MOD_PROJECTILE_SPLASH":
						
						if ( IsSubStr( str_damage_types, "projectile" ) )
						{
							b_run_scene = true;
						}
						
						break;
						
					case "MOD_MELEE":
						
						if ( IsSubStr( str_damage_types, "melee" ) )
						{
							b_run_scene = true;
						}
						
						break;
						
					default:
						
						if ( IsSubStr( str_damage_types, "all" ) )
						{
							b_run_scene = true;
						}
				}
			}
			
			thread [[scene()]]->play();
		}
	}
		
	function _assign_unique_name()
	{
		if ( is_player() )
		{
			_str_name = "player " + _s.player;
		}
		else
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
	}
	
	function get_name()
	{
		return _str_name;
	}
	
	function get_orig_name()
	{
		return _s.name;
	}
	
	function _spawn( e_spawner,  b_hide = true, b_set_ready_when_spawned = true )
	{
		if ( isdefined( e_spawner ) )
		{
			_e = e_spawner;
		}
		
		if ( is_player() )
		{
			if ( IsPlayer( _e ) )
			{
				_player = _e;
			}
			else
			{
				_player = util::get_spawned_players()[ _s.player ];
			}
		}
		
		b_skip = ( _s.type === "actor" ) && IsSubStr( _o_bundle._str_mode, "noai" );
		b_skip = b_skip || ( ( _s.type === "player" ) && IsSubStr( _o_bundle._str_mode, "noplayers" ) );
		
		if ( !b_skip )
		{		
			if ( !isdefined( _e ) && is_player() && ( isdefined( _s.newplayermethod ) && _s.newplayermethod ) )
			{
				_e = _player;
			}
			else if ( !isdefined( _e ) || IsSpawner( _e ) )
			{
				b_allows_multiple = [[scene()]]->allows_multiple();
				
				if ( /*error( !b_allows_multiple && !isdefined( _s.name ), "Scene that don't allow multiple instances must specify a name for all objects." )
				    || */error( b_allows_multiple && ( isdefined( _s.nospawn ) && _s.nospawn ), "Scene that allow multiple instances must be allowed to spawn (uncheck 'Do Not Spawn')." ) )
				{
					return;
				}
				
				if ( !IsSpawner( _e ) )
				{
					e = scene::get_existing_ent( _str_name, b_allows_multiple );
					
					if ( !isdefined( e ) && isdefined( _s.name ) )
					{
						e = scene::get_existing_ent( _s.name, b_allows_multiple );
					}
					
					if ( IsPlayer( e ) )
					{
						if ( !( isdefined( _s.newplayermethod ) && _s.newplayermethod ) )
						{
							e = undefined;
						}
					}
					
					if ( ( !isdefined( e ) || IsSpawner( e ) ) && ( ( !( isdefined( _s.nospawn ) && _s.nospawn ) && !_b_spawnonce_used ) || _o_bundle._testing ) )
					{
						e_spawned = spawn_ent( e );
					}
				}
				else
				{
					e_spawned = spawn_ent( _e );
				}
				
				if ( isdefined( e_spawned ) )
				{
					if ( b_hide && !_o_bundle._s scene::is_igc() )
					{
						e_spawned Ghost(); // Hide teleporting glitches and for any delay set on this object
					}
					
					e_spawned DontInterpolate();
					
					e_spawned.scene_spawned = _o_bundle._s.name;
	
					if ( !isdefined( e_spawned.targetname ) )
					{
						e_spawned.targetname = _s.name;
					}
					
					if ( is_player() )
					{
						e_spawned Hide();
					}
				}
				
				_e = ( isdefined( e_spawned ) ? e_spawned : e );
				
				if ( ( isdefined( _s.spawnonce ) && _s.spawnonce ) && _b_spawnonce_used )
				{
					 return;
				}
			}
			
			error( !( isdefined( _s.nospawn ) && _s.nospawn ) && ( !isdefined( _e ) || IsSpawner( _e ) ), "Object failed to spawn or doesn't exist." );
		}
		
		if ( isdefined( _e ) && !IsSpawner( _e ) )
		{
			[[self]]->_prepare();
			
			if ( b_set_ready_when_spawned )
			{
				flagsys::set( "ready" );
			}
			
			if ( ( isdefined( _s.spawnonce ) && _s.spawnonce ) )
			{
				_b_spawnonce_used = true;
			}
		}
		else
		{
			flagsys::set( "ready" );
			flagsys::set( "done" );
			finish();
		}
	}
	
	function _prepare()
	{
		str_scene_name = [[scene()]]->get_name();
		
		if ( ( isdefined( _s.DynamicPaths ) && _s.DynamicPaths ) && ( _str_state == "play" ) )
		{
			_e.scene_orig_origin = _e.origin;
			_e ConnectPaths();
		}
		
		if ( ( _e.current_scene === str_scene_name ) )
		{
			return false; // already prepared this entity for this scene
		}
		
		_e endon( "death" );
		
		if ( error( IsAI( _e ) && !IsAlive( _e ), "Trying to play a scene on a dead AI." ) )
		{
			return;
		}
		
		// cleanup any current/previous scenes
		_e StopAnimScripted( .2 );
		_e flagsys::wait_till_clear( "scriptedanim" );
		waittillframeend;
		
		if ( !IsAI( _e ) && !IsPlayer( _e ) )
		{
			if ( !is_player() || !( isdefined( _s.newplayermethod ) && _s.newplayermethod ) )
			{
				if ( !( _e.animtree === "generic" ) )
				{
					_e UseAnimTree( #animtree );
					_e.animtree = "generic";
				}
			}
		}
		
		if ( !is_player() )
		{
			if ( !isdefined( _e._scene_old_takedamage ) )
			{
				_e._scene_old_takedamage = _e.takedamage;
			}
			
			if ( IsSentient( _e ) )
			{
				// For sentients, don't override if damage/death is turned off
				_e.takedamage = ( isdefined( _e.takedamage ) && _e.takedamage ) && ( isdefined( _s.takedamage ) && _s.takedamage );
				
				if ( !( isdefined( _e.magic_bullet_shield ) && _e.magic_bullet_shield ) )
				{
					_e.allowdeath = ( isdefined( _s.allowdeath ) && _s.allowdeath );
				}
				
				if ( ( isdefined( _s.OverrideAICharacter ) && _s.OverrideAICharacter ) )
				{
					_e SetModel( _s.model );
				}
			}
			else
			{
				_e.health = ( _e.health > 0 ? _e.health : 1 );
				
				if ( _s.type === "actor" )	// Drone
				{
					_e MakeFakeAI();
					_e animation::attach_weapon( GetWeapon( "ar_standard" ) );
					// TODO: see if we can get the weapon from the aitype if using one for the character model
				}
				
				_e.takedamage = ( isdefined( _s.takedamage ) && _s.takedamage );
				_e.allowdeath = ( isdefined( _s.allowdeath ) && _s.allowdeath );
			}
			
			if ( ( isdefined( _s.RemoveWeapon ) && _s.RemoveWeapon ) )
			{
				if ( !( isdefined( _e.gun_removed ) && _e.gun_removed ) )
				{
					_e animation::detach_weapon();
				}
				else
				{
					_e._scene_old_gun_removed = true;
				}
			}
			
			set_objective();
			
			if ( ( isdefined( _s.DynamicPaths ) && _s.DynamicPaths ) )
			{
				_e DisconnectPaths();
			}
		}
		else if ( !is_shared_player() )
		{
			player = ( IsPlayer( _player ) ? _player : _e );
			
			_prepare_player( player );
		}
		
		// TODO: refactor all of this stuff so it can be set/cleared on all players in a shared animation
		
		_e.animname = _str_name;
		_e.anim_debug_name = _s.name;
				
		_e flagsys::set( "scene" );
		_e flagsys::set( str_scene_name );
		_e.current_scene = str_scene_name;
		_e.finished_scene = undefined;
		_e._o_scene = scene();
		
		if ( ( isdefined( _e.takedamage ) && _e.takedamage ) )
		{
			thread _on_damage_run_scene_thread();
			thread _on_death();
		}
		
		if ( IsActor( _e ) )
		{
			thread _track_goal();
			
			if ( ( isdefined( _s.LookAtPlayer ) && _s.LookAtPlayer ) )
			{
				_e LookAtEntity( util::get_spawned_players()[0] );
			}
		}
		
		return true;
	}
	
	function _prepare_player( player )
	{
		if ( !( isdefined( player.magic_bullet_shield ) && player.magic_bullet_shield ) )
		{
			player.allowdeath = ( isdefined( _s.allowdeath ) && _s.allowdeath );
		}
			
		player.scene_takedamage = ( isdefined( _s.takedamage ) && _s.takedamage );
		
		if ( player IsInVehicle() )
		{
			vh_occupied = player GetVehicleOccupied();
			n_seat = vh_occupied GetOccupantSeat( player );
			
			vh_occupied UseVehicle( player, n_seat );  // make player exit vehicle
		}
		
		if ( player.sessionstate === "spectator" )
		{		
			player thread [[level.spawnPlayer]]();
		}
		else if ( player laststand::player_is_in_laststand() )
		{
			player notify( "auto_revive" ); // currently CP only
		}
				
		player thread scene::scene_disable_player_stuff();
		
		if ( ( isdefined( _s.FirstWeaponRaise ) && _s.FirstWeaponRaise ) )
		{
			//SetDvar( "playerWeaponRaisePostIGC", WEAP_FIRST_RAISE );
		}
		
		player.player_anim_look_enabled	= !( isdefined( _s.LockView ) && _s.LockView );
		player.player_anim_clamp_right	= (isdefined(_s.viewClampRight)?_s.viewClampRight:0);
		player.player_anim_clamp_left	= (isdefined(_s.viewClampLeft)?_s.viewClampLeft:0);
		player.player_anim_clamp_top	= (isdefined(_s.viewClampBottom)?_s.viewClampBottom:0);
		player.player_anim_clamp_bottom	= (isdefined(_s.viewClampBottom)?_s.viewClampBottom:0);
	}
	
	function finish( b_clear = false )
	{
		if ( isdefined( _str_state ) )
		{
			_str_state = undefined;
			self notify( "new_state" );
			
			if ( !is_alive() )
			{
				_cleanup();
				
				_e = undefined;			
				_is_valid = false;
			}
			else
			{
				if ( !is_player() )
				{
					if ( isdefined( _e._scene_old_takedamage ) )
					{
						_e.takedamage = _e._scene_old_takedamage;
					}
					
					if ( ( isdefined( _s.RemoveWeapon ) && _s.RemoveWeapon ) && !( isdefined( _e._scene_old_gun_removed ) && _e._scene_old_gun_removed ) )
					{
						_e animation::attach_weapon();
					}
					
					if ( !( isdefined( _e.magic_bullet_shield ) && _e.magic_bullet_shield ) )
					{
						_e.allowdeath = true;
					}
					
					_e._scene_old_takedamage = undefined;
					_e._scene_old_gun_removed = undefined;
				}
				else
				{
					player = ( IsPlayer( _player ) ? _player : _e );
					
					if ( !is_shared_player() )
					{
						// Shared player anims called this already						
						_finish_player( player );
					}
				}
			}
			
			flagsys::set( "ready" );
			flagsys::set( "done" );
	
			if ( isdefined( _e ) )
			{
				if ( !is_player() )
				{
					if ( is_alive() && ( ( isdefined( _s.DeleteWhenFinished ) && _s.DeleteWhenFinished ) || b_clear ) )
					{
						_e thread scene::synced_delete();
					}
					else if ( is_alive() && ( isdefined( _s.DieWhenFinished ) && _s.DieWhenFinished ) )
					{
						_e.skipdeath = true;
						_e.allowdeath = true;
						
						_e Kill();
					}
				}
				
				if ( IsActor( _e ) && IsAlive( _e ) )
				{
					if ( ( isdefined( _s.DelayMovementAtEnd ) && _s.DelayMovementAtEnd ) )
					{
						_e PathMode( "move delayed", true, RandomIntRange( 2, 6 ) );
					}
					else
					{
						_e PathMode( "move allowed" );
					}
					
					if ( ( isdefined( _s.LookAtPlayer ) && _s.LookAtPlayer ) )
					{
						_e LookAtEntity();
					}
				}
			}
			
			self endon( "new_state" );
			
			waittillframeend;
			waittillframeend;
			
			_cleanup();
		}
	}
	
	function _finish_player( player )
	{
		if ( !( isdefined( player.magic_bullet_shield ) && player.magic_bullet_shield ) )
		{
			player.allowdeath = true;
		}
		
		player.scene_takedamage = undefined;		
		player._scene_old_gun_removed = undefined;
		
		player thread scene::scene_enable_player_stuff();
		
		//SetDvar( "playerWeaponRaisePostIGC", WEAP_RAISE );
		
		if(!([[_o_bundle]]->has_next_scene()) && ([[_o_bundle]]->is_player_anim_ending_early() || (_o_bundle._s scene::is_igc())) )
		{
			_o_bundle thread cscene::_stop_camera_anim_on_player(player);
		}
		
		n_camera_tween_out = get_camera_tween_out();
		if ( n_camera_tween_out > 0 )
		{
			player StartCameraTween( n_camera_tween_out );
		}
	}
	
	function set_objective()
	{
		if ( !isdefined( _e.script_objective ) )
		{
			if ( isdefined( _o_bundle._e_root.script_objective ) )
			{
				_e.script_objective = _o_bundle._e_root.script_objective;
			}
			else if ( isdefined( _o_bundle._s.script_objective ) )
			{
				_e.script_objective = _o_bundle._s.script_objective;
			}
		}
	}
	
	function _on_death()
	{
		self endon( "cleanup" );
		_e waittill( "death" );
		
		if ( isdefined( _e ) )
		{
			self thread do_death_anims();
		}
	}
	
	function do_death_anims()
	{
		ent = _e;
		
		if ( IsAI( ent ) && !isdefined( _str_death_anim ) && !isdefined( _str_death_anim_loop ) )
		{
			ent StopAnimScripted();
			
			if ( IsActor( ent ) )
			{
				ent StartRagDoll();
			}
		}
		
		if ( isdefined( _str_death_anim ) )
		{
			ent.skipdeath = true;
			ent animation::play( _str_death_anim, ent, undefined, 1, .2, 0 );
		}
		
		if ( isdefined( _str_death_anim_loop ) )
		{
			ent.skipdeath = true;
			ent animation::play( _str_death_anim_loop, ent, undefined, 1, 0, 0 );
		}
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
				_e._o_scene = undefined;
				
				if ( is_player() )
				{
					if ( !( isdefined( _s.newplayermethod ) && _s.newplayermethod ) )
					{
						_e Delete();
						thread reset_player();
					}
					
					_e.animname = undefined;
				}
			}
		}
		
		waittillframeend;
		self notify( "cleanup" );
		
		if ( IsAI( _e ) )
		{
			_set_goal();
		}
		
		if ( isdefined( _o_bundle ) && ( isdefined( _o_bundle.scene_stopped ) && _o_bundle.scene_stopped ) )	// don't clear this if the scene is looping
		{
			_o_bundle = undefined;
		}
	}
	
	function _set_goal()
	{
		if ( !( ( _e.scene_spawned === _o_bundle._s.name ) && isdefined( _e.target ) ) )
		{
			if ( !isdefined( _e.script_forcecolor ) && !_e flagsys::get( "anim_reach" ) )
			{
				if ( isdefined( _e.scenegoal ) )
				{
					_e SetGoal( _e.scenegoal );	// use secene goal
					_e.scenegoal = undefined;
				}
				else if ( _b_set_goal )
				{
					_e SetGoal( _e.origin );	// default to current location
				}
			}
		}
	}
	
	function _track_goal()
	{
		// disable setting goal when animation is done if goal is changed any time during animation
		// (assume scripter knows what they are doing and don't override it)
		self endon( "cleanup" );
		_e endon( "death" );
		_e waittill( "goal_changed" );
		_b_set_goal = false;
	}
	
	function _play_anim( animation, n_delay_min = 0, n_delay_max = 0, n_rate = 1, n_blend, n_time = 0 )
	{
		n_delay = n_delay_min;
		if ( n_delay_max > n_delay_min )
		{
			n_delay = RandomFloatRange( n_delay_min, n_delay_max );
		}
		
		do_reach = ( ( n_time == 0 ) && ( ( isdefined( _s.doreach ) && _s.doreach ) && ( !( isdefined( _o_bundle._testing ) && _o_bundle._testing ) || GetDvarInt( "scene_test_with_reach", 0 ) ) ) );
		
		_spawn( undefined, !do_reach, !do_reach );
		
		if ( !IsActor( _e ) )
		{
			do_reach = false;
		}
		
		if ( n_delay > 0 )
		{
			if ( n_delay > 0 )
			{
				wait n_delay;
			}
		}
		
		if ( do_reach )
		{
			[[scene()]]->wait_till_scene_ready( self );
			
			if ( ( isdefined( _s.DisableArrivalInAnimReach ) && _s.DisableArrivalInAnimReach ) )
			{
				_e animation::reach( animation, get_align_ent(), get_align_tag(), true );
			}				
			else 
			{
				_e animation::reach( animation, get_align_ent(), get_align_tag() );
			}
			
			flagsys::set( "ready" );
		}
		else
		{
			[[scene()]]->wait_till_scene_ready();
		}

		if ( is_alive() )
		{
			align = get_align_ent();
			tag = get_align_tag();
			
			if ( align == level )
			{
				align = ( 0, 0, 0 );
				tag = ( 0, 0, 0 );
			}
			
			if ( is_shared_player() )
			{
				_play_shared_player_anim( animation, align, tag, n_rate, n_time );
			}
			else
			{
				if ( is_player() && !( isdefined( _s.newplayermethod ) && _s.newplayermethod ) )
				{
					thread link_player();
				}
				
				if ( ( /*!is_player() && */_o_bundle._s scene::is_igc() ) || ( _e.scene_spawned === _o_bundle._s.name ) )
				{
					_e DontInterpolate();
					_e Show();
				}
				
				// Player Lerping
				n_lerp = 0;
				if ( IsPlayer( _e ) && !_o_bundle._s scene::is_igc() )
				{
					n_lerp = get_lerp_time();
					
					n_camera_tween = get_camera_tween();
					if ( n_camera_tween > 0 )
					{
						_e StartCameraTween( n_camera_tween );
					}
				}
				///////////////////
				
				n_blend_out = ( IsAI( _e ) ? .02 : 0 );
				if ( ( isdefined( _s.DieWhenFinished ) && _s.DieWhenFinished ) )
				{
					n_blend_out = 0;
				}
				
				_e animation::play( animation, align, tag, n_rate, n_blend, n_blend_out, n_lerp, n_time );
			}
		}
		else
		{
			/# log( "No entity for animation '" + animation + "' so not playing it." ); #/
		}
		
		_is_valid = ( is_alive() && !in_a_different_scene() );
	}
	
	function spawn_ent( e )
	{
		if ( is_player() && !( isdefined( _s.newplayermethod ) && _s.newplayermethod ) )
		{
			system::wait_till( "loadout" );
			m_player = util::spawn_anim_model( level.player_interactive_model );
			return m_player;
		}
		else if ( isdefined( e ) )
		{
			if ( IsSpawner( e ) )
			{
				/#
				if ( _o_bundle._testing )
				{
					e.count++;
				}
				#/
					
				if ( !error( e.count < 1, "Trying to spawn AI for scene with spawner count < 1" ) )
				{
					return e spawner::spawn( true );
				}
			}
		}
		else if ( isdefined( _s.model ) )
		{
			return util::spawn_anim_model( _s.model, _o_bundle._e_root.origin, _o_bundle._e_root.angles );
		}
	}
	
	function _play_shared_player_anim( animation, align, tag, n_rate, n_time )
	{
		self.player_animation = animation;
		self.player_animation_length = GetAnimLength( animation );
		self.player_align = align;
		self.player_tag = tag;
		self.player_rate = n_rate;
		self.player_time_frac = n_time;
		self.player_start_time = GetTime();
		
		callback::on_loadout( &_play_shared_player_anim_for_player, self );
		
		foreach ( player in level.players )
		{
			if ( player flagsys::get( "loadout_given" ) )
			{
				self thread _play_shared_player_anim_for_player( player );
			}
		}
		
		do
		{
			b_playing = false;			
			foreach ( player in level.players )
			{
				if ( player flagsys::get( self.player_animation ) )
				{
					b_playing = true;
					player flagsys::wait_till_clear( self.player_animation );
					break;
				}
			}
		}
		while ( b_playing );
		
		callback::remove_on_loadout( &_play_shared_player_anim_for_player, self );
		
		thread [[_o_bundle]]->_call_state_funcs( "players_done" );
	}
	
	function _play_shared_player_anim_for_player( player )
	{
		player endon( "death" );
		
		if ( !isdefined( _o_bundle ) )
			return;
		
//		player clientfield::increment_to_player( "postfx_igc", 1 );
		
		n_time_passed = ( GetTime() - self.player_start_time ) / 1000;
		n_start_time = self.player_time_frac * self.player_animation_length;
		n_time_left = self.player_animation_length - n_time_passed - n_start_time;
		
		n_time_frac = 1 - ( n_time_left / self.player_animation_length );
		
		if ( player != _e )
		{
			// Teleport coop players to the player who is triggering this scene
			// so that the camera tween and lerping happens from the same place
			player DontInterpolate();
			player SetOrigin( _e.origin );
			player SetPlayerAngles( _e GetPlayerAngles() );
		}
		
		// Player Lerping
		n_lerp = 0;
		if ( !_o_bundle._s scene::is_igc() )
		{
			n_lerp = get_lerp_time();
			
			n_camera_tween = get_camera_tween();
			if ( n_camera_tween > 0 )
			{
				player StartCameraTween( n_camera_tween );
			}
		}
		///////////////////
		
		if ( n_time_frac < 1 )
		{
			if(!isdefined(player.sceneAnimsPlaying))
			{
				player.sceneAnimsPlaying = 0;
			}
			
			player.sceneAnimsPlaying++;
			
			_prepare_player( player );
			
			player flagsys::set( self.player_animation );
			player flagsys::set( "shared_igc" );
			
			player SetInvisibleToAll();
			
			player animation::play( self.player_animation, self.player_align, self.player_tag, self.player_rate, 0, 0, n_lerp, n_time_frac );
			
			if ( isdefined( player ) )
			{
//				player clientfield::increment_to_player( "postfx_igc", 1 );
				
				if(isdefined(player.sceneAnimsPlaying) && player.sceneAnimsPlaying > 0)
				{
					player.sceneAnimsPlaying--;
				
					if(player.sceneAnimsPlaying == 0)
					{
						player.sceneAnimsPlaying = undefined;
						
						player SetVisibleToAll();
						
						player flagsys::clear( self.player_animation );
						player flagsys::clear( "shared_igc" );
					
						_finish_player( player );
					}
				}
			}
		}
	}
	
	function get_lerp_time()
	{
		return ( isdefined( _s.LerpTime ) ? _s.LerpTime : 0 );
	}
	
	function get_camera_tween()
	{
		return ( isdefined( _s.CameraTween ) ? _s.CameraTween : 0 );
	}
	
	function get_camera_tween_out()
	{
		return ( isdefined( _s.CameraTweenOut ) ? _s.CameraTweenOut : 0 );
	}
	
	function link_player()
	{
		self endon( "done" );
		
		level flag::wait_till( "all_players_spawned" );
		
		player = _player;
		player Hide();
		
		e_linked = player GetLinkedEnt();
		if ( isdefined( e_linked ) && ( e_linked == _e ) )
		{
			// Update link/clamp if linking to same entity
			
			if ( ( isdefined( _s.lockview ) && _s.lockview ) )
			{
				player PlayerLinkToAbsolute( _e, "tag_player" );
			}
			else
			{
				player LerpViewAngleClamp( .2, .1, .1, (isdefined(_s.viewclampright)?_s.viewclampright:0), (isdefined(_s.viewclampleft)?_s.viewclampleft:0), (isdefined(_s.viewclamptop)?_s.viewclamptop:0), (isdefined(_s.viewclampbottom)?_s.viewclampbottom:0) );
			}
			
			return;
		}
				
		player DisableUsability();
		player DisableOffhandWeapons();
//		player DisableWeapons( true );
		player DisableWeapons();			//TODO_CODE: QUICK weapon switch only supported for SP at the momement
			
		util::wait_network_frame();
		
		if ( _s.cameratween > 0 )
		{
//			player StartCameraTween( _s.cameratween );		//TODO_CODE: only supported for SP at the momement
		}
		
		player notify( "scene_link" );
		waittillframeend;	// allow level script to do custom stuff before linking
		
		if ( ( isdefined( _s.lockview ) && _s.lockview ) )
		{
			player PlayerLinkToAbsolute( _e, "tag_player" );
		}
		else
		{
			player PlayerLinkToDelta( _e, "tag_player", 1, (isdefined(_s.viewclampright)?_s.viewclampright:0), (isdefined(_s.viewclampleft)?_s.viewclampleft:0), (isdefined(_s.viewclamptop)?_s.viewclamptop:0), (isdefined(_s.viewclampbottom)?_s.viewclampbottom:0), 1, 1 );
//			player SetPlayerViewRateScale( 100 );	//TODO_CODE: only supported for SP at the momement
		}
		
		wait ( _s.cameratween > .2 ? _s.cameratween : .2 );
		
		_e Show();
	}
	
	function reset_player()
	{
		level flag::wait_till( "all_players_spawned" );
		
		player = _player;
		
//		player StartCameraTween( .2 );	//TODO_CODE: only supported for SP at the momement
//		player ShowViewModel();			//TODO_CODE: only supported for SP at the momement
//		player SetLowReady( false );		//TODO_CODE: only supported for SP at the momement
//		player ResetPlayerViewRateScale();	//TODO_CODE: only supported for SP at the momement
		player EnableUsability();
		player EnableOffhandWeapons();
		player EnableWeapons();
		
		player Show();
	}
		
	function has_init_state()
	{
		return _s scene::_has_init_state();
	}
	
	function is_alive()
	{
		return ( isdefined( _e ) && _e.health > 0 );
	}
	
	function is_player()
	{
		return ( IsDefined( _s.player ) );
	}
	
	function is_shared_player()
	{
		return ( IsDefined( _s.player ) && ( isdefined( _s.SharedIGC ) && _s.SharedIGC ) );
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
		_str_mode = "";
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
						
			foreach ( s_obj in a_objs )
			{
				add_object( [[ [[self]]->new_object() ]]->first_init( s_obj, self ) );
			}
			
			_e_root thread scene::debug_display();
				
			self thread initialize( a_ents );
		}
	}
	
	function new_object()
	{
		return new cSceneObject();
	}
	
	function get_valid_object_defs()
	{
		a_obj_defs = [];
		foreach ( s_obj in _s.objects )
		{
			if ( _s.vmtype == "server" || s_obj.vmtype == "server" )
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

	function initialize( a_ents, b_playing = false )
	{
		self notify( "new_state" );
		self endon( "new_state" );
		
		self thread sync_with_client_scene( "init", _testing );
		
		assign_ents( a_ents );
		
		if ( get_valid_objects().size > 0 )
		{
			level flagsys::set( _str_name + "_initialized" );
			_str_state = "init";
			
			foreach ( o_obj in _a_objects )
			{
				thread [[o_obj]]->initialize();
			}
		}
		
		if ( !b_playing )
		{
			thread _call_state_funcs( "init" );
		}
		
		// stops the scene if all objects die in the initialize state
		array::flagsys_wait( _a_objects, "done" );
		thread stop();
	}
	
	function get_object_id()
	{
		_n_object_id++;
		return _n_object_id;
	}
	
	function sync_with_client_scene( str_state, b_test_run = false )
	{
		if ( _s.vmtype == "both" && !_s scene::is_igc() )
		{
			self endon( "new_state" );
		
			wait_till_scene_ready();
		
			n_val = undefined;
			
			if ( b_test_run )
			{
				switch ( str_state )
				{
					case "stop":
						n_val = 3;
						break;
					case "init":
						n_val = 4;
						break;
					case "play":
						n_val = 5;
						break;
				}
			}
			else
			{			
				switch ( str_state )
				{
					case "stop":
						n_val = 0;
						break;
					case "init":
						n_val = 1;
						break;
					case "play":
						n_val = 2;
						break;
				}
			}
			
			level clientfield::set( _s.name, n_val );
		}
	}
	
	function assign_ents( a_ents )
	{
		if ( !isdefined( a_ents ) ) a_ents = []; else if ( !IsArray( a_ents ) ) a_ents = array( a_ents );;
		a_objects = ArrayCopy( _a_objects );
			
		if ( _assign_ents_by_name( a_objects, a_ents ) )
		{
			if ( _assign_ents_by_type( a_objects, a_ents, "player", &_is_ent_player ) )
			{
				if ( _assign_ents_by_type( a_objects, a_ents, "actor", &_is_ent_actor ) )
				{
					if ( _assign_ents_by_type( a_objects, a_ents, "vehicle", &_is_ent_vehicle ) )
					{
						if ( _assign_ents_by_type( a_objects, a_ents, "prop" ) )
						{
							foreach ( ent in a_ents )
							{
								obj = array::pop( a_objects );
								if ( !error( !isdefined( obj ), "No scene object to assign entity too.  You might have passed in more than the scene supports." ) )
								{
									obj._e = ent;
								}
							}
						}
					}
				}
			}
		}
	}
	
	function _assign_ents_by_name( &a_objects, &a_ents )
	{
		if ( a_ents.size )
		{
			foreach ( str_name, e_ent in ArrayCopy( a_ents ) )
			{
				foreach ( i, o_obj in ArrayCopy( a_objects ) )
				{
					if ( isdefined( o_obj._s.name ) && ( (isdefined(o_obj._s.name)?""+o_obj._s.name:"") == ToLower( (isdefined(str_name)?""+str_name:"") ) ) )
					{
						o_obj._e = e_ent;
						
						ArrayRemoveIndex( a_ents, str_name, true );
						ArrayRemoveIndex( a_objects, i );
						
						break;
					}
				}
			}
			
			/#
				// Check for any remaining entities with specific names that don't have objects to assign them to
				foreach ( i, ent in a_ents )
				{
					error( IsString( i ), "No scene object with name '" + i + "'." );
				}
			#/
		}
		
		return a_ents.size;
	}
	
	function _assign_ents_by_type( &a_objects, &a_ents, str_type, func_test )
	{
		if ( a_ents.size )
		{
			a_objects_of_type = get_objects( str_type );
			
			if ( a_objects_of_type.size )
			{		
				foreach ( ent in ArrayCopy( a_ents ) )
				{
					if ( isdefined( func_test ) && [[ func_test ]]( ent ) )
					{
						obj = array::pop_front( a_objects_of_type );
						if ( isdefined( obj ) )
						{
							obj._e = ent;
						
							ArrayRemoveValue( a_ents, ent, true );
							ArrayRemoveValue( a_objects, obj );
						}
						else
						{
							break;
						}
					}
				}
			}
		}
		
		return a_ents.size;
	}
	
	function _is_ent_player( ent )
	{
		return ( IsPlayer( ent ) );
	}
	
	function _is_ent_actor( ent )
	{
		return ( IsActor( ent ) || IsActorSpawner( ent ) );
	}
	
	function _is_ent_vehicle( ent )
	{
		return ( IsVehicle( ent ) || IsVehicleSpawner( ent ) );
	}
		
	function get_objects( str_type )
	{
		a_ret = [];
		foreach ( obj in _a_objects )
		{
			if ( obj._s.type == str_type )
			{
				if ( !isdefined( a_ret ) ) a_ret = []; else if ( !IsArray( a_ret ) ) a_ret = array( a_ret ); a_ret[a_ret.size]=obj;;
			}
		}
		return a_ret;
	}
	
	function is_player_anim_ending_early()
	{
		max_anim_length = -1;
		player_anim_length = -1;
		
		foreach ( obj in _a_objects )
		{
			if(isdefined(obj._s.MainAnim))
			{
				anim_length = GetAnimLength( obj._s.MainAnim );
			}
			   
			if ( ( obj._s.type === "player" ) )
			{
				player_anim_length = anim_length;
			}
			
			if(anim_length > max_anim_length)
			{
				max_anim_length = anim_length;
			}
		}
		
		return player_anim_length < max_anim_length;
	}

	function play( str_state = "play", a_ents, b_testing = false, str_mode = "" )
	{
		self notify( "new_state" );
		self endon( "new_state" );
		
		_testing = b_testing;
		_str_mode = str_mode;
		
		assign_ents( a_ents );
		
		if ( StrStartsWith( _str_mode, "capture" ) )
		{
			wait 3; // give scene time in the init state to load textures, also the code needs time in between captures
		}
		
		self thread sync_with_client_scene( "play", b_testing );
		
		/* Get animation start time from the mode string */
		
		self.n_start_time = 0;
		if ( IsSubStr( str_mode, "skipto" ) )
		{
			args = StrTok( str_mode, ":" );
			if ( isdefined( args[1] ) )
			{
				self.n_start_time = Float( args[1] );
			}
			else
			{
				// skip to end of animation - can't go all the way to 1 because looping animations will assert
				self.n_start_time = .9999;
			}
		}
		
		/* ---------------------------------------------- */
		
		if ( get_valid_objects().size || _s scene::is_igc() )
		{
			o_drive_scene_length = undefined;
			foreach ( o_obj in _a_objects )
			{
				if ( ( isdefined( o_obj._s.DriveSceneLength ) && o_obj._s.DriveSceneLength ) )
				{
					o_drive_scene_length = o_obj;
					break;
				}
			}
			
			foreach ( o_obj in _a_objects )
			{
				thread [[o_obj]]->play();
			}
				
			level flagsys::set( _str_name + "_playing" );
			_str_state = "play";
			
			wait_till_scene_ready();
			
			if ( StrStartsWith( _str_mode, "capture" ) )
			{
				util::wait_network_frame();
				/# AddDebugCommand( "startGfxCapture sceneFinal 0 30 tga captures/" + _str_name + " " + _str_name ); #/
			}
			
			self thread _play_camera_anims();

			thread _call_state_funcs( "play" );
			
			if ( _s scene::is_igc() || isdefined( o_drive_scene_length ) )
			{
				if ( isdefined( o_drive_scene_length ) )
				{
					_wait_server_time( GetAnimLength( o_drive_scene_length._s.MainAnim ), self.n_start_time );
				}
				else if ( IsString( _s.cameraswitcher ) )
				{
					_wait_for_camera_animation( _s.cameraswitcher );
				}
				else if ( IsString( _s.extraCamSwitcher1 ) )
				{
					_wait_for_camera_animation( _s.extraCamSwitcher1 );
				}
				else if ( IsString( _s.extraCamSwitcher2 ) )
				{
					_wait_for_camera_animation( _s.extraCamSwitcher2 );
				}
				else if ( IsString( _s.extraCamSwitcher3 ) )
				{
					_wait_for_camera_animation( _s.extraCamSwitcher3 );
				}
				else if ( IsString( _s.extraCamSwitcher4 ) )
				{
					_wait_for_camera_animation( _s.extraCamSwitcher4 );
				}
				
				foreach ( o_obj in _a_objects )
				{
					thread [[o_obj]]->stop();
				}
				
				_e_root notify( "scene_done", _str_name );
				thread _call_state_funcs( "done" );
			}
			else
			{
				array::flagsys_wait_any_flag( _a_objects, "done", "main_done" );
				
				_e_root notify( "scene_done", _str_name );
				thread _call_state_funcs( "done" );
				
				array::flagsys_wait( _a_objects, "done" );
			}
			
			if ( is_looping() || ( StrEndsWith( _str_mode, "loop" ) ) )
			{
				if ( has_init_state() )
				{
					level flagsys::clear( _str_name + "_playing" );
					
					thread initialize();
				}
				else
				{
					level flagsys::clear( _str_name + "_initialized" );
					
					thread play( str_state, undefined, b_testing, str_mode );
				}
			}
			else
			{
				if ( !StrEndsWith( _str_mode, "single" ) )
				{
					thread run_next();
				}
				
				if ( !_s scene::is_igc() || !( isdefined( _s.holdCameraLastFrame ) && _s.holdCameraLastFrame ) )
				{
					// Scenes set to hold camera last frame must be stopped manually with scene::stop()
					thread stop( false, true );
				}
			}
		}
		else
		{
			thread stop( false, true );
		}
	}
	
	function _wait_server_time( n_time, n_start_time = 0 )
	{
		n_len = ( n_time - ( n_time * n_start_time ) ); // get the length we need to wait from the desired start time fraction
		n_server_length = Floor( n_len / .05 ) * .05; // clamp to full server frames.
		wait n_server_length;
	}
	
	function _wait_for_camera_animation( str_cam )
	{
		if ( IsCamAnimLooping( str_cam ) )
		{
			level waittill( "forever" );
		}
		else
		{
			_wait_server_time( GetCamAnimTime( str_cam ) / 1000 );
		}
	}
	
	function _play_camera_anims()
	{
		level endon( "stop_camera_anims" );
		waittillframeend;
		
		e_align = get_align_ent();
			
		v_origin = ( isdefined( e_align.origin ) ? e_align.origin : ( 0, 0, 0 ) );
		v_angles = ( isdefined( e_align.angles ) ? e_align.angles : ( 0, 0, 0 ) );
			
		if ( IsString( _s.cameraswitcher ) )
		{
			array::thread_all_ents( level.players, &_play_camera_anim_on_player, v_origin, v_angles );
			
//			hide_players();
			
			/#display_dev_state();#/
		}
		
		if ( IsString( _s.extraCamSwitcher1 ) )
		{
			array::thread_all_ents( level.players, &_play_extracam_on_player, 0, _s.extraCamSwitcher1, v_origin, v_angles );
		}
		
		if ( IsString( _s.extraCamSwitcher2 ) )
		{
			array::thread_all_ents( level.players, &_play_extracam_on_player, 1, _s.extraCamSwitcher2, v_origin, v_angles );
		}
		
		if ( IsString( _s.extraCamSwitcher3 ) )
		{
			array::thread_all_ents( level.players, &_play_extracam_on_player, 2, _s.extraCamSwitcher3, v_origin, v_angles );
		}
		
		if ( IsString( _s.extraCamSwitcher4 ) )
		{
			array::thread_all_ents( level.players, &_play_extracam_on_player, 3, _s.extraCamSwitcher4, v_origin, v_angles );
		}
	}
	
	function _play_camera_anim_on_player( player, v_origin, v_angles )
	{
		player notify( "new_camera_switcher" );
		player DontInterpolate();
		player clientfield::set_to_player( "exposure_ignore_teleport", 1 );
		player thread scene::scene_disable_player_stuff();
		CamAnimScripted( player, _s.cameraswitcher, GetTime(), v_origin, v_angles );
	}
	
	function _play_extracam_on_player( player, n_index, str_camera_anim, v_origin, v_angles )
	{
		ExtraCamAnimScripted( player, n_index, str_camera_anim, GetTime(), v_origin, v_angles );
	}
	
	function _stop_camera_anims()
	{
		level notify( "stop_camera_anims" );
		
		foreach ( player in GetPlayers() )
		{
			self thread _stop_camera_anim_on_player( player );
		}
		
//		show_players();
	}
	
	function _stop_camera_anim_on_player( player )
	{
		player endon( "disconnect" );
		if ( IsString( _s.cameraswitcher ) )
		{
			player endon( "new_camera_switcher" );
			
			player DontInterpolate();
			EndCamAnimScripted( player );
			
			player thread scene::scene_enable_player_stuff();
			
			wait 1; // wait a bit before turning off exposure clientfield so we don't flash coming out of the last shot
			
			player clientfield::set_to_player( "exposure_ignore_teleport", 0 );
		}
		
		// TODO: do we want the extracam animations to stop?
		if ( IsString( _s.extraCamSwitcher1 ) )
		{		 
			EndExtraCamAnimScripted( player, 0 );
		}
		
		if ( IsString( _s.extraCamSwitcher2 ) )
		{		 
			EndExtraCamAnimScripted( player, 1 );
		}
		
		if ( IsString( _s.extraCamSwitcher3 ) )
		{		 
			EndExtraCamAnimScripted( player, 2 );
		}
		
		if ( IsString( _s.extraCamSwitcher4 ) )
		{		 
			EndExtraCamAnimScripted( player, 3 );
		}
	}
	
	function display_dev_state()
	{
		if ( IsString( _s.devstate ) )
		{
			if ( !isdefined( level.hud_scene_dev_info1 ) )
			{
				level.hud_scene_dev_info1 = NewHudElem();
				level.hud_scene_dev_info1.alignX = "left";
				level.hud_scene_dev_info1.alignY = "bottom";
				level.hud_scene_dev_info1.y = 400;
				level.hud_scene_dev_info1.fontScale = 1.3;
				level.hud_scene_dev_info1.color = (112/255,128/255,144/255);
				
				level.hud_scene_dev_info1 SetText( "SCENE: " + ToUpper( _s.name ) );
			}
			
			if ( !isdefined( level.hud_scene_dev_info2 ) )
			{
				level.hud_scene_dev_info2 = NewHudElem();
				level.hud_scene_dev_info2.alignX = "left";
				level.hud_scene_dev_info2.alignY = "bottom";
				level.hud_scene_dev_info2.y = 420;
				level.hud_scene_dev_info2.fontScale = 1.3;
				level.hud_scene_dev_info2.color = (112/255,128/255,144/255);
			}
			
			level.hud_scene_dev_info2 SetText( "SHOT: " + ToUpper( _s.name ) );
			
			if ( !isdefined( level.hud_scene_dev_info3 ) )
			{
				level.hud_scene_dev_info3 = NewHudElem();
				level.hud_scene_dev_info3.alignX = "left";
				level.hud_scene_dev_info3.alignY = "bottom";
				level.hud_scene_dev_info3.y = 440;
				level.hud_scene_dev_info3.fontScale = 1.3;
				level.hud_scene_dev_info3.color = (112/255,128/255,144/255);
				
				level.hud_scene_dev_info3 SetText( "STATE: " + ToUpper( _s.devstate ) );
			}
		}
	}
	
	function has_next_scene()
	{
		return isdefined(_s.nextscenebundle);
	}
	
	function run_next()
	{
		if ( isdefined( _s.nextscenebundle ) )
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
						_e_root thread scene::play( _s.nextscenebundle, get_ents(), undefined, undefined, undefined, _str_mode );
					}
					else
					{
						_e_root thread scene::play( _s.nextscenebundle, undefined, undefined, undefined, undefined, _str_mode );
					}
				}
			}
		}
	}
		
	function stop( b_clear = false, b_finished = false )
	{
		if ( isdefined( _str_state ) )
		{
			/#
				
			if ( StrStartsWith( _str_mode, "capture" ) )
			{
				AddDebugCommand( "stopGfxCapture 1" );
			}
			
			#/
			
			self thread sync_with_client_scene( "stop", b_clear );
			
			_str_state = undefined;
			
			self notify( "new_state" );
			
			level flagsys::clear( _str_name + "_playing" );
			level flagsys::clear( _str_name + "_initialized" );
			
			thread _call_state_funcs( "stop" );
			
			self.scene_stopped = true;
			
			if ( IsDefined( _a_objects ) && !b_finished )
			{
				foreach ( o_obj in _a_objects )
				{
					if ( isdefined( o_obj ) )
					{
						thread [[o_obj]]->stop( b_clear );
					}
				}
			}
			
			self thread _stop_camera_anims();
			
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
			
			if ( !isdefined( _s.nextscenebundle ) || !b_finished )
			{
				if ( isdefined( level.hud_scene_dev_info1 ) )
				{
					level.hud_scene_dev_info1 Destroy();
				}
				
				if ( isdefined( level.hud_scene_dev_info2 ) )
				{
					level.hud_scene_dev_info2 Destroy();
				}
			}
			
			self notify( "stopped", b_finished );
			_e_root notify( "scene_done", _str_name );
		}
	}
	
//	function hide_players()
//	{
//		if ( IS_TRUE( _s.HidePlayers ) )
//		{
//			foreach ( player in level.players )
//			{
//				player SetInvisibleToAll();
//			}
//		}
//	}
	
//	function show_players()
//	{
//		if ( IS_TRUE( _s.HidePlayers ) )
//		{
//			foreach ( player in level.players )
//			{
//				player SetVisibleToAll();
//			}
//		}
//	}
	
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
			e_gdt_align = scene::get_existing_ent( _s.aligntarget, false, true );
			
			if ( isdefined( e_gdt_align ) )
			{
				e_align = e_gdt_align;
			}
			
			if ( !isdefined( e_gdt_align ) )
			{
				str_msg = "Align target '" + (isdefined(_s.aligntarget)?""+_s.aligntarget:"") + "' doesn't exist for scene.";
				
				if ( !warning( _testing, str_msg ) )
				{
					error( GetDvarInt( "scene_align_errors", 1 ), str_msg );
				}
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
	
	function wait_till_scene_ready( o_exclude )
	{
		a_objects = [];
		
		if ( isdefined( o_exclude ) )
		{
			a_objects = array::exclude( _a_objects, o_exclude );
		}
		else
		{
			a_objects = _a_objects;
		}
		
		array::flagsys_wait( a_objects, "ready" );
	}
		
	function get_valid_objects()
	{
		a_obj = [];
		
		foreach ( obj in _a_objects )
		{
			if ( obj._is_valid )
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
//    _    __      __    _     ___   ___   _  _   ___   ___   ___     ___    ___   ___   _  _   ___      ___    ___      _   ___    ___   _____ 
//   /_\   \ \    / /   /_\   | _ \ | __| | \| | | __| / __| / __|   / __|  / __| | __| | \| | | __|    / _ \  | _ )  _ | | | __|  / __| |_   _|
//  / _ \   \ \/\/ /   / _ \  |   / | _|  | .` | | _|  \__ \ \__ \   \__ \ | (__  | _|  | .` | | _|    | (_) | | _ \ | || | | _|  | (__    | |  
// /_/ \_\   \_/\_/   /_/ \_\ |_|_\ |___| |_|\_| |___| |___/ |___/   |___/  \___| |___| |_|\_| |___|    \___/  |___/  \__/  |___|  \___|   |_|  
//                                                                                                                                              
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class cAwarenessSceneObject : cSceneObject
{
	function play( str_alert_state )
	{
		flagsys::clear( "ready" );   flagsys::clear( "done" );   flagsys::clear( "main_done" );   _str_state = "play";   self notify( "new_state" );   self endon( "new_state" );   self notify("play");   waittillframeend;;
		
		switch ( str_alert_state )
		{
			case "low_alert":
				log( "LOW ALERT" );
				if ( isdefined( _s.LowAlertAnim ) )
				{
					_str_death_anim = _s.LowAlertAnimDeath;
					_str_death_anim_loop = _s.LowAlertAnimDeathLoop;
						
					_play_anim( _s.LowAlertAnim );
				}
				break;
			case "high_alert":
				log( "HIGH ALERT" );
				if ( isdefined( _s.HighAlertAnim ) )
				{
					_str_death_anim = _s.HighAlertAnimDeath;
					_str_death_anim_loop = _s.HighAlertAnimDeathLoop;
					
					_play_anim( _s.HighAlertAnim );
				}
				break;
			case "combat":
				log( "COMBAT ALERT" );
				if ( isdefined( _s.CombatAlertAnim ) )
				{
					_str_death_anim = _s.CombatAlertAnimDeath;
					_str_death_anim_loop = _s.CombatAlertAnimDeathLoop;
					
					_play_anim( _s.CombatAlertAnim );
				}
				break;
			default: error( 1, "Unsupported alert state" );
		}
		
		thread finish();
	}
	
	function _prepare()
	{
		if ( cSceneObject::_prepare() )
		{		
			if ( IsAI( _e ) )
			{
				thread _on_alert_run_scene_thread();
			}
		}
	}
	
	function _on_alert_run_scene_thread()
	{
		self endon( "play" );
		self endon( "stop" );
	
		_e waittill( "alert", str_alert_state );
		
		/#
			
			if ( GetDvarInt( "anim_debug", 0 ) )
			{
				Print3d( _e.origin, "ALERT", ( 1, 0, 0 ), 1, .5, 20 );
			}
		
		#/
		
		thread [[scene()]]->play( str_alert_state );
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//    _    __      __    _     ___   ___   _  _   ___   ___   ___     ___    ___   ___   _  _   ___ 
//   /_\   \ \    / /   /_\   | _ \ | __| | \| | | __| / __| / __|   / __|  / __| | __| | \| | | __|
//  / _ \   \ \/\/ /   / _ \  |   / | _|  | .` | | _|  \__ \ \__ \   \__ \ | (__  | _|  | .` | | _| 
// /_/ \_\   \_/\_/   /_/ \_\ |_|_\ |___| |_|\_| |___| |___/ |___/   |___/  \___| |___| |_|\_| |___|
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class cAwarenessScene : cScene
{
	function new_object()
	{
		return new cAwarenessSceneObject();
	}
	
	function init( str_scenedef, s_scenedef, e_align, a_ents, b_test_run )
	{
		cScene::init( str_scenedef, s_scenedef, e_align, a_ents, b_test_run );
	}
	
	function play( str_awareness_state = "low_alert" )
	{
		self notify( "new_state" );
		self endon( "new_state" );
		
		if ( get_valid_objects().size > 0 )
		{
			foreach ( o_obj in _a_objects )
			{
				thread [[o_obj]]->play( str_awareness_state );
			}
			
			level flagsys::set( _str_name + "_playing" );
			_str_state = "play";
			
			wait_till_scene_ready();

			thread _call_state_funcs( str_awareness_state );
			
			array::flagsys_wait_any_flag( _a_objects, "done", "main_done" );

			if ( is_looping() )
			{
				if ( has_init_state() )
				{
					// TODO: do this on return to unaware?
					//level flagsys::clear( _str_name + "_playing" );					
					//thread initialize();
				}
			}
			else
			{
				thread stop();
			}
		}
		else
		{
			thread stop( false, true );
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  _  _   ___   _      ___   ___   ___   ___ 
// | || | | __| | |    | _ \ | __| | _ \ / __|
// | __ | | _|  | |__  |  _/ | _|  |   / \__ \
// |_||_| |___| |____| |_|   |___| |_|_\ |___/
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function get_existing_ent( str_name, b_spawner_only = false, b_nodes_and_structs = false )
{
	e = undefined;
	
	if ( b_spawner_only )
	{
		e_array = GetSpawnerArray( str_name, "script_animname" );	// a spawner exists with script_animname
		if ( e_array.size == 0 )
		{
			e_array = GetSpawnerArray( str_name, "targetname" );	// lastly grab any ent with targetname
		}
		
		Assert( e_array.size <= 1 , "Multiple spawners found." );
		
		foreach(ent in e_array)
		{
			if(!isdefined(ent.isDying))
			{
				e = ent;
				break;
			}
		}
	}
	else
	{
		e = GetEnt( str_name, "animname", false );	// entity already exists
		if ( !isdefined(e) || isdefined(e.isDying) )
		{
			e = GetEnt( str_name, "script_animname" );	// a spawner exists with script_animname
			if ( !isdefined(e) || isdefined(e.isDying) )
			{
				e = GetEnt( str_name + "_ai", "targetname", false );	// any already spawned AI
				if ( !isdefined(e) || isdefined(e.isDying) )
				{
					e = GetEnt( str_name + "_vh", "targetname", false );	// any already spawned vehicles
					if ( !isdefined(e) || isdefined(e.isDying) )
					{
						e = GetEnt( str_name, "targetname" );	// lastly grab any ent with targetname
						if ( (!isdefined(e) || isdefined(e.isDying) )&& b_nodes_and_structs )
						{
							e = GetNode( str_name, "targetname" );	// if no ent, grab node with targetname
							if ( !isdefined(e) || isdefined(e.isDying) )
							{
								e = struct::get( str_name, "targetname" );	// if no node, grab struct with targetname
							}
						}
					}
				}
			}
		}
	}
	
	if(isdefined(e) && isdefined(e.isDying))
	{
		e = undefined;
	}
	
	return e;
}

function synced_delete()
{
	self endon("disconnect");
	self endon("entityshutdown");
	
	self.isDying = true;
	
	{wait(.05);};
	self delete();
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
	/* INIT SYSTEM VARS */
	
	level.scene_object_id = 0;	
	level.active_scenes = [];
	
	foreach ( s_scenedef in struct::get_script_bundles( "scene" ) )
	{
		s_scenedef.editaction = undefined;	// only used in the asset editor
		s_scenedef.newobject = undefined;	// only used in the asset editor
	
		foreach ( i, s_object in s_scenedef.objects )
		{
			if ( ( s_object.type === "player" ) )
			{
				if(!isdefined(s_object.cameratween))s_object.cameratween=0;
				
				if ( isdefined( s_object.player ) )
				{
					s_object.player--;	// adjust for zero-based level.players index
				}
				else
				{
					s_object.player = 0;
				}
				
				s_object.name = "player " + ( s_object.player + 1 );
			}
			else
			{
				s_object.player = undefined;
			}
		}
		
		if ( s_scenedef.vmtype == "both" && !s_scenedef is_igc() )
		{
			n_clientbits = GetMinBitCountForNum( 3 );
			
			/#
				n_clientbits = GetMinBitCountForNum( 6 );
			#/
				
			clientfield::register( "world", s_scenedef.name, 1, n_clientbits, "int" );
		}
	}
	
	clientfield::register( "toplayer", "postfx_igc", 1, 1, "counter" );
	clientfield::register( "toplayer", "exposure_ignore_teleport", 1, 1, "int" );
}

function remove_invalid_scene_objects( s_scenedef )
{
	a_invalid_object_indexes = [];
	
	foreach ( i, s_object in s_scenedef.objects )
	{
		if ( !isdefined( s_object.name ) && !isdefined( s_object.model ) && !( s_object.type === "player" ) )
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

function __main__()
{
	/* RUN INSTANCES */
	
	a_instances = ArrayCombine(
							struct::get_array( "scriptbundle_scene", "classname" ),
	                        struct::get_array( "scriptbundle_fxanim", "classname" ),
	                        false, false
	                       );
	
	foreach ( s_instance in a_instances )
	{
		if ( isdefined( s_instance.script_flag_set ) )
		{
			level flag::init( s_instance.script_flag_set );
		}
		
		if ( isdefined( s_instance.scriptgroup_initscenes ) )
		{
			foreach ( trig in GetEntArray( s_instance.scriptgroup_initscenes, "scriptgroup_initscenes" ) )
			{
				s_instance thread _trigger_init( trig );
			}
		}
		
		if ( isdefined( s_instance.scriptgroup_playscenes ) )
		{
			foreach ( trig in GetEntArray( s_instance.scriptgroup_playscenes, "scriptgroup_playscenes" ) )
			{
				s_instance thread _trigger_play( trig );
			}
		}
		
		if ( isdefined( s_instance.scriptgroup_stopscenes ) )
		{
			foreach ( trig in GetEntArray( s_instance.scriptgroup_stopscenes, "scriptgroup_stopscenes" ) )
			{
				s_instance thread _trigger_stop( trig );
			}
		}
		
		/# s_instance thread debug_display(); #/
	}
	
	level thread on_load_wait();
	level thread run_instances();
}

function on_load_wait()
{
	// wait for client script so "both" type scenes will work properly on load.
	util::wait_network_frame();
	util::wait_network_frame();
	level flagsys::set( "scene_on_load_wait" );
}

function run_instances()
{
	foreach ( s_instance in struct::get_script_bundle_instances( "scene" ) )
	{
		if ( (isdefined(s_instance.spawnflags)&&((s_instance.spawnflags & 2) == 2)) )
		{
			s_instance thread play();
		}
		else if ( (isdefined(s_instance.spawnflags)&&((s_instance.spawnflags & 1) == 1)) )
		{
			s_instance thread init();
		}
	}
}

function _trigger_init( trig )
{
	trig endon( "death" );
	
	trig trigger::wait_till();
		
	a_ents = [];
	if ( get_player_count( self.scriptbundlename ) > 0 )
	{
		if ( IsPlayer( trig.who ) )
		{
			a_ents[ 0 ] = trig.who;
		}
	}

	self thread _init_instance( undefined, a_ents );
}

function _trigger_play( trig )
{
	trig endon( "death" );
	
	do
	{	
		trig trigger::wait_till();
		
		a_ents = [];
		if ( get_player_count( self.scriptbundlename ) > 0 )
		{
			if ( IsPlayer( trig.who ) )
			{
				a_ents[ 0 ] = trig.who;
			}
		}
	
		self thread play( a_ents );
	}
	while ( ( isdefined( get_scenedef( self.scriptbundlename ).looping ) && get_scenedef( self.scriptbundlename ).looping ) );
}

function _trigger_stop( trig )
{
	trig endon( "death" );
	trig trigger::wait_till();
	self thread stop();
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
	if(!isdefined(level.scene_funcs[ str_scenedef ][ str_state ]))level.scene_funcs[ str_scenedef ][ str_state ]=[];
	
	array::add( level.scene_funcs[ str_scenedef ][ str_state ], Array( func, vararg ), false );
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
				a_ents		= arg2;
			}
			
			if ( isdefined( str_key ) )
			{
				a_instances = struct::get_array( str_value, str_key );
				
				/#
					Assert( a_instances.size, "No scene instances with KVP '" + str_key + "'/'" + str_value + "'." );
				#/
			}
			else
			{
				a_instances = struct::get_array( str_value, "targetname" );
				if ( !a_instances.size )
				{
					a_instances = struct::get_array( str_value, "scriptbundlename" );
				}
			}
			
			if ( !a_instances.size )
			{
				_init_instance( str_value, a_ents, b_test_run );
			}
			else
			{
				foreach ( s_instance in a_instances )
				{
					if ( isdefined( s_instance ) )
					{
						s_instance thread _init_instance( undefined, a_ents, b_test_run );
					}
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

function _init_instance( str_scenedef, a_ents, b_test_run = false )
{
	level flagsys::wait_till( "scene_on_load_wait" );
	
	if(!isdefined(str_scenedef))str_scenedef=self.scriptbundlename;
	
	/#
		if ( array().size && !IsInArray( array(), str_scenedef ) )
		{
			return;
		}
	#/
	
	s_bundle = get_scenedef( str_scenedef );
	
	/#
	
	Assert( isdefined( str_scenedef ), "Scene at (" + ( isdefined( self.origin ) ? self.origin : "level" ) + ") is missing its scene def." );
	Assert( isdefined( s_bundle ), "Scene at (" + ( isdefined( self.origin ) ? self.origin : "level" ) + ") is using a scene name '" + str_scenedef + "' that doesn't exist." );
	
	#/
	
	o_scene = get_active_scene( str_scenedef );
	
	if ( !isdefined( o_scene ) )
	{
		if ( s_bundle.scenetype == "awareness" )
		{
			o_scene = new cAwarenessScene();
		}
		else
		{
			o_scene = new cScene();
		}
		
		s_bundle = _load_female_scene( s_bundle, a_ents );
		
		[[o_scene]]->init( s_bundle.name, s_bundle, self, a_ents, b_test_run );
	}
	else
	{
		thread [[o_scene]]->initialize( a_ents, true );
	}
	
	return o_scene;
}

function private _load_female_scene( s_bundle, a_ents )
{
	/* Check if this bundle has a player object */
	
	b_has_player = false;
	foreach ( s_object in s_bundle.objects )
	{
		if ( ( s_object.type === "player" ) )
		{
			b_has_player = true;
			break;
		}
	}
	
	/* Check if if a player was passed in to use for the scene */
	
	if ( b_has_player )
	{
		e_player = undefined;	
		if ( IsPlayer( a_ents ) )
		{
			e_player = a_ents;
		}
		else if ( IsArray( a_ents ) )
		{
			foreach ( ent in a_ents )
			{
				if ( IsPlayer( ent ) )
				{
					e_player = ent;
					break;
				}
			}
		}
		
		/* Default to first player none are passed in */
		
		if ( !isdefined( e_player ) )
		{
			e_player = util::get_spawned_players()[0];
		}
	
		if ( IsPlayer( e_player ) && ( e_player.bodyType === "female" ) )
		{
			if ( isdefined( s_bundle.FemaleBundle ) )
			{
				s_female_bundle = struct::get_script_bundle( "scene", s_bundle.FemaleBundle );
				if ( isdefined( s_female_bundle ) )
				{
					return s_female_bundle;
				}
			}
		}
	}
	
	return s_bundle;
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
function play( arg1, arg2, arg3, b_test_run = false, str_state, str_mode = "" )
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
				a_ents		= arg2;
			}
			
			if ( isdefined( str_key ) )
			{
				a_instances = struct::get_array( str_value, str_key );
				
				/#
					Assert( a_instances.size, "No scene instances with KVP '" + str_key + "'/'" + str_value + "'." );
				#/
			}
			else
			{
				a_instances = struct::get_array( str_value, "targetname" );
				if ( !a_instances.size )
				{
					a_instances = struct::get_array( str_value, "scriptbundlename" );
				}
			}
			
			if ( !a_instances.size )
			{
				self thread _play_instance( s_tracker, str_value, a_ents, b_test_run, undefined, str_mode );
			}
			else
			{
				if ( a_instances.size )
				{
					s_tracker.n_scene_count = a_instances.size;
					
					foreach ( s_instance in a_instances )
					{
						if ( isdefined( s_instance ) )
						{
							s_instance thread _play_instance( s_tracker, undefined, a_ents, b_test_run, str_state, str_mode );
						}
					}
				
					// TODO: these need to wait on a waittillmatch for the specific scenename
 					array::wait_till( a_instances, "scene_done" );
				}
			}
		}
	}
	else
	{
		if ( IsString( arg1 ) )
		{
			self thread _play_instance( s_tracker, arg1, arg2, b_test_run, str_state, str_mode );
		}
		else
		{		
			self thread _play_instance( s_tracker, arg2, arg1, b_test_run, str_state, str_mode );
		}
	}
	
	for ( i = 0; i < s_tracker.n_scene_count; i++ )
	{	
		s_tracker waittill( "scene_done" );
	}
}

function _play_instance( s_tracker, str_scenedef, a_ents, b_test_run = false, str_state, str_mode )
{	
	/#
		if ( array().size && !IsInArray( array(), str_scenedef ) )
		{
			return;
		}
	#/
	
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
	if ( IsDefined(o_scene) )
	{
		thread [[o_scene]]->play( str_state, a_ents, b_test_run, str_mode );
	}
		
	self waittillmatch( "scene_done", str_scenedef );
	
	if ( isdefined( self ) )
	{	
		if ( isdefined( self.scriptbundlename ) && ( isdefined( get_scenedef( self.scriptbundlename ).looping ) && get_scenedef( self.scriptbundlename ).looping ) )
		{
			self.scene_played = false;
		}
		
		if ( isdefined( self.script_flag_set ) )
		{
			level flag::set( self.script_flag_set );
		}
	}
	
	s_tracker notify( "scene_done" );
}

/@
"Summary: Skipts a scene or multiple scenes to the end state (last frame or looping animation).  Look at scene::play() for all the various ways this can be called."
"SPMP: shared"
"Example: level scene::skipto_end( "my_scene" );"
@/
function skipto_end( arg1, arg2, arg3, n_time, b_include_players = false )
{
	str_mode = "skipto";
	
	if ( !b_include_players )
	{
		str_mode += "_noplayers";
	}
	
	if ( isdefined( n_time ) )
	{
		str_mode += ":" + n_time;
	}
	
	play( arg1, arg2, arg3, false, undefined, str_mode );
}

/@
"Summary: Skipts a scene or multiple scenes to the end state (last frame or looping animation), but skips AI.  Look at scene::play() for all the various ways this can be called."
"SPMP: shared"
"Example: level scene::skipto_end_noai( "my_scene" );"
@/
function skipto_end_noai( arg1, arg2, arg3, n_time )
{
	str_mode = "skipto_noai_noplayers";
	if ( isdefined( n_time ) )
	{
		str_mode += ":" + n_time;
	}
	
	play( arg1, arg2, arg3, false, undefined, str_mode );
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
function stop( arg1, arg2, arg3 )
{
	if ( self == level )
	{
		if ( IsString( arg1 ) )
		{
			if ( IsString( arg2 ) )
			{
				str_value	= arg1;
				str_key		= arg2;
				b_clear		= arg3;
			}
			else
			{
				str_value	= arg1;
				b_clear		= arg2;
			}
			
			if ( isdefined( str_key ) )
			{
				a_instances = struct::get_array( str_value, str_key );
				
				/#
					Assert( a_instances.size, "No scene instances with KVP '" + str_key + "'/'" + str_value + "'." );
				#/
					
				str_value = undefined;
			}
			else
			{
				a_instances = struct::get_array( str_value, "targetname" );
				if ( !a_instances.size )
				{
					a_instances = get_active_scenes( str_value );
				}
			}
			
			foreach ( s_instance in ArrayCopy( a_instances ) )
			{
				if ( isdefined( s_instance ) )
				{
					s_instance _stop_instance( b_clear, str_value );
				}
			}
		}
	}
	else
	{
		if ( IsString( arg1 ) )
		{
			_stop_instance( arg2, arg1 );
		}
		else
		{
			_stop_instance( arg1 );
		}
	}
}

function _stop_instance( b_clear = false, str_scenedef )
{
	if ( isdefined( self.scenes ) )
	{
		foreach ( o_scene in ArrayCopy( self.scenes ) )
		{
			str_scene_name = [[o_scene]]->get_name();
			
			if ( !isdefined( str_scenedef ) || ( str_scene_name == str_scenedef ) )
			{
				thread [[o_scene]]->stop( b_clear );
			}
		}
	}
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
"Summary: returns the number of players defined for a scene"
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


//TODO: this should be turned into something more automatic and part of the system
function delete_scene_data( str_scenename )
{
	if(IsDefined( level.scriptbundles["scene"][str_scenename] ))
	{
		level.scriptbundles["scene"][str_scenename] = undefined;
	}
}

function is_igc()
{
	return ( IsString( self.cameraswitcher )
	        || IsString( self.extraCamSwitcher1 )
	        || IsString( self.extraCamSwitcher2 )
	        || IsString( self.extraCamSwitcher3 )
	        || IsString( self.extraCamSwitcher4 ) );
}

function scene_disable_player_stuff()
{
	self notify( "scene_disable_player_stuff" );

	level notify( "disable_cybercom", self );
	self SetClientUIVisibilityFlag( "hud_visible", 0 );
}

function scene_enable_player_stuff()
{
	self endon( "scene_disable_player_stuff" );

	wait .5;
	
	level notify( "enable_cybercom", self );
	self SetClientUIVisibilityFlag( "hud_visible", 1 );
}
