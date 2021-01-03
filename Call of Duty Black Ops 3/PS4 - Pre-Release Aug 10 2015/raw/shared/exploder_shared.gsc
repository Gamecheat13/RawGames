#using scripts\codescripts\struct;

#using scripts\shared\fx_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace exploder;

function autoexec __init__sytem__() {     system::register("exploder",&__init__,&__main__,undefined);    }

//TODO T7 make another pass when the system becomes string id only
//TODO T7 delete all server side functions that are now run on the client
function __init__()
{
	level._client_exploders = [];
	level._client_exploder_ids = [];
}

function __main__()
{
	level.exploders = [];
	
	// Hide exploder models.
	ents = GetEntArray( "script_brushmodel", "classname" );
	smodels = GetEntArray( "script_model", "classname" );
	for ( i = 0; i < smodels.size; i++ )
	{
		ents[ents.size] = smodels[i];
	}

	for ( i = 0; i < ents.size; i++ )
	{
		if ( isdefined( ents[i].script_prefab_exploder ) )
		{
			ents[i].script_exploder = ents[i].script_prefab_exploder;
		}

		if ( isdefined( ents[i].script_exploder ) )
		{
			if ( ents[i].script_exploder < 10000 )
			{
				level.exploders[ents[i].script_exploder] = true;  // nate. I wanted a list
			}

			if ( ( ents[i].model == "fx" ) &&( ( !isdefined( ents[i].targetname ) ) || ( ents[i].targetname != "exploderchunk" ) ) )
			{
				ents[i] Hide();
			}
			else if ( ( isdefined( ents[i].targetname ) ) &&( ents[i].targetname == "exploder" ) )
			{
				ents[i] Hide();
				ents[i] NotSolid();

				if( isdefined( ents[i].script_disconnectpaths ) )
				{
					ents[i] ConnectPaths();
				}
			}
			else if ( ( isdefined( ents[i].targetname ) ) &&( ents[i].targetname == "exploderchunk" ) )
			{
				ents[i] Hide();
				ents[i] NotSolid();

				if( (isdefined(ents[i].spawnflags)&&((ents[i].spawnflags & 1) == 1)))
				{
					ents[i] ConnectPaths();
				}
			}
		}
	}

	script_exploders = [];

	potentialExploders = GetEntArray( "script_brushmodel", "classname" );
	for ( i = 0; i < potentialExploders.size; i++ )
	{
		if( isdefined( potentialExploders[i].script_prefab_exploder ) )
		{
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder;
		}
			
		if( isdefined( potentialExploders[i].script_exploder ) )
		{
			script_exploders[script_exploders.size] = potentialExploders[i];
		}
	}

	/#println("Server : Potential exploders from brushmodels " + potentialExploders.size);#/

	potentialExploders = GetEntArray( "script_model", "classname" );
	for ( i = 0; i < potentialExploders.size; i++ )
	{
		if( isdefined( potentialExploders[i].script_prefab_exploder ) )
		{
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder;
		}

		if( isdefined( potentialExploders[i].script_exploder ) )
		{
			script_exploders[script_exploders.size] = potentialExploders[i];
		}
	}

	/#println("Server : Potential exploders from script_model " + potentialExploders.size);#/

	potentialExploders = GetEntArray( "item_health", "classname" );
	for ( i = 0; i < potentialExploders.size; i++ )
	{
		if( isdefined( potentialExploders[i].script_prefab_exploder ) )
		{
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder;
		}

		if( isdefined( potentialExploders[i].script_exploder ) )
		{
			script_exploders[script_exploders.size] = potentialExploders[i];
		}
	}
	
	/#println("Server : Potential exploders from item_health " + potentialExploders.size);#/

	
	if( !isdefined( level.createFXent ) )
	{
		level.createFXent = [];
	}
	
	acceptableTargetnames = [];
	acceptableTargetnames["exploderchunk visible"] = true;
	acceptableTargetnames["exploderchunk"] = true;
	acceptableTargetnames["exploder"] = true;
	
	for ( i = 0; i < script_exploders.size; i ++ )
	{
		exploder = script_exploders[ i ];
		ent = createExploder( exploder.script_fxid );
		ent.v = [];
		ent.v[ "origin" ] = exploder.origin;
		ent.v[ "angles" ] = exploder.angles;
		ent.v[ "delay" ] = exploder.script_delay;
		ent.v[ "firefx" ] = exploder.script_firefx;
		ent.v[ "firefxdelay" ] = exploder.script_firefxdelay;
		ent.v[ "firefxsound" ] = exploder.script_firefxsound;
		ent.v[ "firefxtimeout" ] = exploder.script_firefxtimeout;
		ent.v[ "earthquake" ] = exploder.script_earthquake;
		ent.v[ "damage" ] = exploder.script_damage;
		ent.v[ "damage_radius" ] = exploder.script_radius;
		ent.v[ "soundalias" ] = exploder.script_soundalias;
		ent.v[ "repeat" ] = exploder.script_repeat;
		ent.v[ "delay_min" ] = exploder.script_delay_min;
		ent.v[ "delay_max" ] = exploder.script_delay_max;
		ent.v[ "target" ] = exploder.target;
		ent.v[ "ender" ] = exploder.script_ender;
		ent.v[ "type" ] = "exploder";
// 		ent.v[ "worldfx" ] = true;

		if ( !isdefined( exploder.script_fxid ) )
		{
			ent.v[ "fxid" ] = "No FX";
		}
		else
		{
			ent.v[ "fxid" ] = exploder.script_fxid;
		}
		
		ent.v[ "exploder" ] = exploder.script_exploder;
		assert( isdefined( exploder.script_exploder ), "Exploder at origin " + exploder.origin + " has no script_exploder" );

		if ( !isdefined( ent.v[ "delay" ] ) )
		{
			ent.v[ "delay" ] = 0;
		}
			
		if ( isdefined( exploder.target ) )
		{
			// BJoyal (1/12/12) - Added a check to see if the GetEnt returns undefined, in which case, use struct::get
			e_target = GetEnt( ent.v[ "target" ], "targetname" );
			if( !isdefined( e_target ) )
			{
				e_target = struct::get( ent.v[ "target" ], "targetname" );
			}
			
			org = e_target.origin;
			ent.v[ "angles" ] = vectortoangles( org - ent.v[ "origin" ] );
// 			forward = anglestoforward( angles );
// 			up = anglestoup( angles );
		}
			
		// this basically determines if its a brush / model exploder or not
		if ( exploder.classname == "script_brushmodel" || isdefined( exploder.model ) )
		{
			ent.model = exploder;
			ent.model.disconnect_paths = exploder.script_disconnectpaths;
		}
		
		if ( isdefined( exploder.targetname ) && isdefined( acceptableTargetnames[ exploder.targetname ] ) )
		{
			ent.v[ "exploder_type" ] = exploder.targetname;
		}
		else
		{
			ent.v[ "exploder_type" ] = "normal";
		}
	}

	level.createFXexploders = [];
	
	for (i = 0; i < level.createFXent.size;i ++ )
	{
		ent = level.createFXent[i];
		
		if(ent.v["type"] != "exploder")
		{
			continue;
		}
			
		ent.v["exploder_id"] = getExploderId( ent );

		if (!isdefined(level.createFXexploders[ent.v["exploder"]]))
		{
			level.createFXexploders[ent.v["exploder"]] = [];
		}
		
		level.createFXexploders[ent.v["exploder"]][level.createFXexploders[ent.v["exploder"]].size] = ent;

	}
	
	level.radiantExploders = [];
	

	reportExploderIds();
	
	foreach ( trig in trigger::get_all() )
	{
		if ( isdefined( trig.script_prefab_exploder ) )
		{
			trig.script_exploder = trig.script_prefab_exploder;
		}
		
		if ( isdefined( trig.script_exploder ) )
		{
			level thread exploder_trigger( trig, trig.script_exploder );
		}
		
		if ( isdefined( trig.script_exploder_radiant ) )
		{
			level thread exploder_trigger( trig, trig.script_exploder_radiant );
		}

		if ( isdefined( trig.script_stop_exploder ) )
		{
			level trigger::add_function( trig, undefined, &stop_exploder, trig.script_stop_exploder );
		}
		
		if ( isdefined( trig.script_stop_exploder_radiant ) )
		{
			level trigger::add_function( trig, undefined, &stop_exploder, trig.script_stop_exploder_radiant );
		}
	}
}

function exploder_before_load( num )
{
	// gotta wait twice because the createfx_init function waits once then inits all exploders. This guarentees
	// that if an exploder is run on the first frame, it happens after the fx are init.
	waittillframeend;
	waittillframeend;
	exploder( num );
}

function exploder( exploder_id )
{
	if( IsInt( exploder_id ) )
	{
		activate_exploder( exploder_id );
	}
	else//This is a radiant exploder
	{
		activate_radiant_exploder( exploder_id );
	}
}

function exploder_stop( num )
{
	stop_exploder( num );
}

function exploder_sound()
{
	if(isdefined(self.script_delay))
	{
		wait self.script_delay;
	}
		
	self playSound(level.scr_sound[self.script_sound]);
}

function cannon_effect()
{
	if( isdefined( self.v[ "repeat" ] ) )
	{
		for( i = 0;i < self.v[ "repeat" ];i ++ )
		{
			playfx( level._effect[ self.v[ "fxid" ] ], self.v[ "origin" ], self.v[ "forward" ], self.v[ "up" ] );
			//exploder_playSound();
			self exploder_delay();
		}
		return;
	}

	self exploder_delay();

//	playfx( level._effect[ self.v[ "fxid" ] ], self.v[ "origin" ], self.v[ "forward" ], self.v[ "up" ] );
	if ( isdefined( self.looper ) )
	{
		self.looper delete();
	}
	
	self.looper = spawnFx( fx::get( self.v[ "fxid" ] ), self.v[ "origin" ], self.v[ "forward" ], self.v[ "up" ] );
	triggerFx( self.looper );
	exploder_playSound();
}

function fire_effect()
{
	forward = self.v[ "forward" ];
	up = self.v[ "up" ];

//	org = undefined;

	firefxSound = self.v[ "firefxsound" ];
	origin = self.v[ "origin" ];
	firefx = self.v[ "firefx" ];
	ender = self.v[ "ender" ];
	if( !isdefined( ender ) )
	{
		ender = "createfx_effectStopper";
	}

	fireFxDelay = 0.5;
	if( isdefined( self.v[ "firefxdelay" ] ) )
	{
		fireFxDelay = self.v[ "firefxdelay" ];
	}

	self exploder_delay();

	if( isdefined( firefxSound ) )	
	{
		level thread sound::loop_fx_sound( firefxSound, origin, ender );
	}

	playfx( level._effect[ firefx ], self.v[ "origin" ], forward, up );
}

function sound_effect()
{
	self effect_soundalias();
}

function effect_soundalias()
{
	// save off this info in case we delete the effect
	origin = self.v[ "origin" ];
	alias = self.v[ "soundalias" ];
	self exploder_delay();
	sound::play_in_space( alias, origin );
}

function trail_effect()
{
	self exploder_delay();

//	self.trailfx_looper = _utility::PlayLoopedFX( level._effect[self.v["trailfx"]], self.v["trailfxdelay"], self.v["origin"], 0, self.v["forward"], self.v["up"]);

	if( !isdefined( self.v["trailfxtag"] ) )
	{
		self.v["trailfxtag"] = "tag_origin";
	}

	temp_ent = undefined;

	
	if(self.v["trailfxtag"] == "tag_origin")
	{
		PlayFxOnTag( level._effect[self.v["trailfx"]], self.model, self.v["trailfxtag"] );
	}
	else
	{
		temp_ent = Spawn( "script_model", self.model.origin );
		temp_ent SetModel( "tag_origin" );
		temp_ent LinkTo( self.model, self.v[ "trailfxtag" ] );  // TravisJ 2/16/2011 - temporary solution to playing FX off of tags; previously wouldn't work unless using tag_origin
		PlayFxOnTag( level._effect[self.v["trailfx"]], temp_ent, "tag_origin" );
	}
//	self.trailfx_looper LinkTo( self, self.v["trailfxtag"] );
	
	if( isdefined( self.v["trailfxsound"] ) )
	{
//		self.trailfx_looper PlayLoopSound( self.v["trailfxsound"] );
//		self PlayLoopSound( self.v["trailfxsound"] );
		if(!isdefined(temp_ent))
		{
			self.model PlayLoopSound( self.v["trailfxsound"] );
		}
		else
		{
			temp_ent PlayLoopSound( self.v["trailfxsound"] );
		}
	}

	// TravisJ 2/16/2011 - allow deletion of temp fx ent for endon condition
	if( isdefined( self.v[ "ender" ] ) && isdefined( temp_ent ) )
	{
		level thread trail_effect_ender( temp_ent, self.v[ "ender" ] );
	}

	if( !isdefined( self.v["trailfxtimeout"] ) )
	{
		return;
	}

	wait( self.v["trailfxtimeout"] );
//	self.trailfx_looper Delete();

	if(isdefined(temp_ent))
	{
		temp_ent Delete();
	}
}

function trail_effect_ender( ent, ender )
{
	ent endon( "death" ); 
	self waittill( ender );
	ent Delete(); 
}

function exploder_delay()
{
	if( !isdefined( self.v[ "delay" ] ) )
	{
		self.v[ "delay" ] = 0;
	}

	min_delay = self.v[ "delay" ];
	max_delay = self.v[ "delay" ] + 0.001;// cant randomfloatrange on the same #
	if( isdefined( self.v[ "delay_min" ] ) )
	{
		min_delay = self.v[ "delay_min" ];
	}

	if( isdefined( self.v[ "delay_max" ] ) )
	{
		max_delay = self.v[ "delay_max" ];
	}

	if( min_delay > 0 )
	{
		wait( randomfloatrange( min_delay, max_delay ) );
	}
}

function exploder_playSound()
{
	if( !isdefined( self.v[ "soundalias" ] ) || self.v[ "soundalias" ] == "nil" )
	{
		return;
	}
	
	sound::play_in_space( self.v[ "soundalias" ], self.v[ "origin" ] );
}

function brush_delete()
{
	num = self.v[ "exploder" ];
	
	if( isdefined( self.v[ "delay" ] ) )
	{
		wait( self.v[ "delay" ] );
	}
	else
	{
		wait( .05 );// so it disappears after the replacement appears
	}

	if( !isdefined( self.model ) )
	{
		return;
	}


	assert( isdefined( self.model ) );

	if( !isdefined( self.v[ "fxid" ] ) || self.v[ "fxid" ] == "No FX" )
	{
		self.v[ "exploder" ] = undefined;
	}
		
	waittillframeend;// so it hides stuff after it shows the new stuff
	self.model delete();
}

function brush_show()
{
	if( isdefined( self.v[ "delay" ] ) )
	{
		wait( self.v[ "delay" ] );
	}
	
	assert( isdefined( self.model ) );
	
	self.model show();
	self.model solid();
}

function brush_throw()
{
	if( isdefined( self.v[ "delay" ] ) )
	{
		wait( self.v[ "delay" ] );
	}

	ent = undefined;
	
	if( isdefined( self.v[ "target" ] ) )
	{
		ent = getent( self.v[ "target" ], "targetname" );
	}

	if( !isdefined( ent ) )
	{
		self.model delete();
		return;
	}

	self.model show();

	startorg = self.v[ "origin" ];
	startang = self.v[ "angles" ];
	org = ent.origin;


	temp_vec = ( org - self.v[ "origin" ] );
	x = temp_vec[ 0 ];
	y = temp_vec[ 1 ];
	z = temp_vec[ 2 ];

	self.model rotateVelocity( ( x, y, z ), 12 );

	self.model moveGravity( ( x, y, z ), 12 );
	
	self.v[ "exploder" ] = undefined;
	wait( 6 );
	self.model delete();
}

function exploder_trigger( trigger, script_value )
{
	trigger endon( "death" );
	
	level endon( "killexplodertridgers" + script_value );
	
	trigger trigger::wait_till();
	
	if( isdefined( trigger.script_chance ) && RandomFloat( 1 ) > trigger.script_chance )
	{
		if ( isdefined( trigger.script_delay ) )
		{
			wait( trigger.script_delay );
		}
		else
		{
			wait 4;
		}
		level thread exploder_trigger( trigger, script_value );
		return;
	}
	
	exploder( script_value );	
	level notify( "killexplodertridgers" + script_value );	
}

function reportExploderIds()
{
	if(!isdefined(level._exploder_ids))
	{
		return;
	}

	keys = GetArrayKeys( level._exploder_ids );

	/#
	println("Server Exploder dictionary : ");

	for( i = 0; i < keys.size; i++ )
	{
		println(keys[i] + " : " + level._exploder_ids[keys[i]]);
	}
	#/
}

function getExploderId( ent )
{
	if(!isdefined(level._exploder_ids))
	{
		level._exploder_ids = [];
		level._exploder_id = 1;
	}

	if(!isdefined(level._exploder_ids[ent.v["exploder"]]))
	{
		level._exploder_ids[ent.v["exploder"]] = level._exploder_id;
		level._exploder_id ++;
	}

	return level._exploder_ids[ent.v["exploder"]];
}

function createExploder( fxid )
{
	ent = fx::create_effect( "exploder", fxid );
	ent.v[ "delay" ] = 0;
	ent.v[ "exploder" ] = 1;
	ent.v[ "exploder_type" ] = "normal";

	return ent;
}

function activate_exploder( num )
{
	num = int( num );
	level notify( "exploder" + num );
	
	client_send = true;

	if(IsDefined(level.createFXexploders[num]))
	{
		for(i = 0; i < level.createFXexploders[num].size; i ++)
		{
			if(client_send && IsDefined(level.createFXexploders[num][i].v["exploder_server"]))
			{
				client_send = false;
			}
			
			level.createFXexploders[num][i] activate_individual_exploder( num );
		}
	}

	if(level.clientScripts)
	{
		if(client_send == true)
		{
			activate_exploder_on_clients(num);
		}
	}
}

//TODO T7 - update this if other functionality comes online for the new system
function activate_radiant_exploder( string )
{
	level notify( "exploder" + string );
	
	ActivateClientRadiantExploder( string );
}

/@
"Name: activate_individual_exploder( num )"
"Summary: Activates an individual exploder, rather than all the exploders of a given number"
"Module: Utility"
"CallOn: An exploder"
"Example: exploder activate_individual_exploder( num );"
"SPMP: singleplayer"
@/

function activate_individual_exploder( num )
{		
	level notify("exploder" + self.v["exploder"]);
	
	// CODER_MOD : DSL - Contents of if statement created on client.
	// GLocke (12/8/2008) - checking for self.v["exploder_server"] instead of self.exploder_server
	if(!level.clientScripts || !isdefined(level._exploder_ids[int(self.v["exploder"])] ) || isdefined(self.v["exploder_server"]))
	{
		/#		
			println("Exploder " + self.v["exploder"] + " created on server.");
		#/
		if( isdefined( self.v[ "firefx" ] ) )
		{
			self thread fire_effect();
		}

		if( isdefined( self.v[ "fxid" ] ) && self.v[ "fxid" ] != "No FX" )
		{
			self thread cannon_effect();
		}
		else if( isdefined( self.v[ "soundalias" ] ) )
		{
			self thread sound_effect();
		}
		
		if( isdefined( self.v[ "earthquake" ] ) )
		{
			self thread exploder::earthquake();
		}

		if( isdefined( self.v[ "rumble" ] ) )
		{
			self thread exploder::rumble();
		}			
	}		
		
	// CODER_MOD : DSL - Stuff below here happens on the server.

	if( isdefined( self.v[ "trailfx" ] ) )
	{
		self thread trail_effect();
	}

	if( isdefined( self.v[ "damage" ] ) )
	{
		self thread exploder_damage();
	}

	if( self.v[ "exploder_type" ] == "exploder" )
	{
		self thread brush_show();
	}
	else if( ( self.v[ "exploder_type" ] == "exploderchunk" ) || ( self.v[ "exploder_type" ] == "exploderchunk visible" ) )
	{
		self thread brush_throw();
	}
	else
	{
		self thread brush_delete();
	}
}

function activate_exploder_on_clients(num)
{

	if(!isdefined(level._exploder_ids[num]))
	{
		return;
	}

	if(!isdefined(level._client_exploders[num]))
	{
		level._client_exploders[num] = 1;
	}

	if(!isdefined(level._client_exploder_ids[num]))
	{
		level._client_exploder_ids[num] = 1;
	}

	ActivateClientExploder(level._exploder_ids[num]);
}

function stop_exploder( num )
{
	if(level.clientScripts)
	{
		delete_exploder_on_clients(num);
	}

	if(isdefined(level.createFXexploders[num]))
	{
		for(i = 0; i < level.createFXexploders[num].size; i ++)
		{

			if ( !isdefined( level.createFXexploders[num][i].looper ) )
			{
				continue;
			}

			level.createFXexploders[num][i].looper delete();
		}
	}
}

function delete_exploder_on_clients( exploder_id )
{
	//Check if this is a radiant exploder first
	if( IsString( exploder_id ) )
	{
		DeactivateClientRadiantExploder( exploder_id );
		return;
	}
	
	if(!isdefined(level._exploder_ids[exploder_id]))
	{
		return;
	}

	if(!isdefined(level._client_exploders[exploder_id]))
	{
		return;
	}

	level._client_exploders[exploder_id] = undefined;

	level._client_exploder_ids[exploder_id] = undefined;

	DeactivateClientExploder(level._exploder_ids[exploder_id]);
}

function kill_exploder( exploder_string )
{
	if( IsString( exploder_string ) )
	{
		KillClientRadiantExploder( exploder_string );
		return;
	}

	assertmsg( "unhandled exploder type, only radiant exploders are handled" );
}

function exploder_damage()
{
	if( isdefined( self.v[ "delay" ] ) )
	{
		delay = self.v[ "delay" ];
	}
	else
	{
		delay = 0;
	}

	if( isdefined( self.v[ "damage_radius" ] ) )
	{
		radius = self.v[ "damage_radius" ];
	}
	else
	{
		radius = 128;
	}

	damage = self.v[ "damage" ];
	origin = self.v[ "origin" ];

	wait( delay );
	// Range, max damage, min damage
	self.model RadiusDamage( origin, radius, damage, damage / 3 );
}

function earthquake()
{
	earthquake_name = self.v[ "earthquake" ];
	
	assert(isdefined(level.earthquake) && isdefined(level.earthquake[earthquake_name]),
		"No earthquake '" + earthquake_name + "' defined for exploder - call add_earthquake() in your level script.");

	self exploder::exploder_delay();
	eq = level.earthquake[earthquake_name];
	earthquake( eq[ "magnitude" ], eq[ "duration" ], self.v[ "origin" ], eq[ "radius" ] );
}

function rumble()
{
	self exploder_delay();
	
	// TravisJ (2/14/2011) - replaced level.player reference with get_players loop, and added distance check
	a_players = GetPlayers();  
	
	if( isdefined( self.v[ "damage_radius" ] ) )
	{
		n_rumble_threshold_squared = self.v[ "damage_radius" ] * self.v[ "damage_radius" ];	
	}
	else
	{
		/#println( "exploder #" + self.v[ "exploder" ] + " missing script_radius KVP, using default." );#/
		n_rumble_threshold_squared = 128 * 128;  // default distance of exploder_damage is 128
	}

	for( i = 0; i < a_players.size; i++ )
	{
		n_player_dist_squared = distancesquared( a_players[ i ].origin, self.v[ "origin" ] );

		if( n_player_dist_squared < n_rumble_threshold_squared )
		{	
			a_players[ i ] PlayRumbleonentity( self.v[ "rumble" ] );
		}
	}
}


function stop_after_duration( name, duration )
{
	wait( duration );
	stop_exploder( name );
}


function exploder_duration( name, duration )
{
	if ( !( isdefined( duration ) && duration ) )
	{
		return;
	}

	exploder( name );
	
	level thread stop_after_duration( name, duration );
}

