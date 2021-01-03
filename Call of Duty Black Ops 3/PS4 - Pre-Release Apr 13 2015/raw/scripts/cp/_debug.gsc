#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\ai\systems\init;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\weaponList;

#using scripts\cp\_debug_menu;
#using scripts\cp\_endmission;
#using scripts\cp\_util;

#using scripts\shared\ai_puppeteer_shared;

#precache( "material", "white" );





	
#namespace debug;

/#
function autoexec __init__sytem__() {     system::register("debug_script",&__init__,undefined,undefined);    }
#/

/#
function __init__()
{
	level.animsound_hudlimit = 14;
	
	level.debugTeamColors = [];
	level.debugTeamColors[ "axis" ] = ( 1.0, 0.0, 0.0 );
	level.debugTeamColors[ "allies" ] = ( 0.0, 1.0, 0.0 );
	level.debugTeamColors[ "team3" ] = ( 1.0, 1.0, 0.0 );
	level.debugTeamColors[ "neutral" ] = ( 1.0, 1.0, 1.0 );

	thread debugDvars();
	
	
	if( GetDvarString( "level_transition_test" ) != "off" )
	{
		thread complete_me();
	}

	thread engagement_distance_debug_toggle();
	
	thread debug_coop_bot_test();
}



function drawEntTag( num )
{
	ai = GetAIArray();
	for( i=0;i<ai.size;i++ )
	{
		if( ai[ i ] getentnum() != num )
		{
			continue;
		}
		ai[ i ] thread dragTagUntilDeath( GetDvarString( "debug_tag" ) );
	}
	/#SetDvar( "debug_enttag", "" );#/
}

function drawTag( tag, opcolor )
{
	org = self GetTagOrigin( tag );
	ang = self GetTagAngles( tag );
	drawArrow( org, ang, opcolor );
}

function drawOrgForever( opcolor )
{
	for( ;; )
	{
		drawArrow( self.origin, self.angles, opcolor );
		{wait(.05);};
	}
}


function drawArrowForever( org, ang )
{
	for( ;; )
	{
		drawArrow( org, ang );
		{wait(.05);};
	}
}

function drawOriginForever()
{
	for( ;; )
	{
		drawArrow( self.origin, self.angles );
		{wait(.05);};
	}
}

function drawArrow( org, ang, opcolor )
{
	const scale = 50;
	forward = anglestoforward( ang );
	forwardFar = VectorScale( forward, scale );
	forwardClose = VectorScale( forward, ( scale * 0.8 ) );
	right = anglestoright( ang );
	leftdraw = VectorScale( right, ( scale * -0.2 ) );
	rightdraw = VectorScale( right, ( scale * 0.2 ) );
	
	up = anglestoup( ang );
	right = VectorScale( right, scale );
	up = VectorScale( up, scale );
	
	red = ( 0.9, 0.2, 0.2 );
	green = ( 0.2, 0.9, 0.2 );
	blue = ( 0.2, 0.2, 0.9 );
	if ( isdefined( opcolor ) )
	{
		red = opcolor;
		green = opcolor;
		blue = opcolor;
	}
	
	line( org, org + forwardFar, red, 0.9 );
	line( org + forwardFar, org + forwardClose + rightdraw, red, 0.9 );
	line( org + forwardFar, org + forwardClose + leftdraw, red, 0.9 );

	line( org, org + right, blue, 0.9 );
	line( org, org + up, green, 0.9 );
}

function drawPlayerViewForever()
{
	for ( ;; )
	{
		drawArrow( level.player.origin, level.player getplayerangles(), (1,1,1) );
		{wait(.05);};
	}
}



function drawTagForever( tag, opcolor )
{
	self endon( "death" );
	for( ;; )
	{
		drawTag( tag, opcolor );
		{wait(.05);};
	}
}


function dragTagUntilDeath( tag )
{
	for( ;; )
	{
		if( !isdefined( self.origin ) )
		{
			break;
		}
		drawTag( tag );
		{wait(.05);};
	}
}

function viewTag( type, tag )
{
	if( type == "ai" )
	{
		ai = GetAIArray();
		for( i=0;i<ai.size;i++ )
		{
			ai[ i ] drawTag( tag );
		}
	}
	else
	{
		vehicle = getentarray( "script_vehicle", "classname" );
		for( i=0;i<vehicle.size;i++ )
		{
			vehicle[ i ] drawTag( tag );
		}
	}
}

function removeActiveSpawner( spawner )
{
	newSpawners = [];	
	for( p=0;p<level.activeNodes.size;p++ )
	{
		if( level.activeNodes[ p ] == spawner )
		{
			continue;
		}
		newSpawners[ newSpawners.size ] = level.activeNodes[ p ];
	}
	level.activeNodes = newSpawners;
}


function createLine( org )
{
	for( ;; )
	{
		line( org +( 0, 0, 35 ), org, ( 0.2, 0.5, 0.8 ), 0.5 );
		{wait(.05);};
	}
}

function createLineConstantly( ent )
{
	org = undefined;
	while( isalive( ent ) )
	{
		org = ent.origin;
		{wait(.05);};		
	}
	
	for( ;; )
	{
		line( org +( 0, 0, 35 ), org, ( 1.0, 0.2, 0.1 ), 0.5 );
		{wait(.05);};
	}
}

function debugMisstime()
{
	self notify( "stopdebugmisstime" );
	self endon( "stopdebugmisstime" );
	self endon( "death" );
	for( ;; )
	{
		if( self.a.misstime <= 0 )
		{
			print3d( self gettagorigin( "TAG_EYE" ) +( 0, 0, 15 ), "hit", ( 0.3, 1, 1 ), 1 );
		}
		else
		{
			print3d( self gettagorigin( "TAG_EYE" ) +( 0, 0, 15 ), self.a.misstime/20, ( 0.3, 1, 1 ), 1 );
		}
		{wait(.05);};
	}
}

function debugMisstimeOff()
{
	self notify( "stopdebugmisstime" );
}

function setEmptyDvar( dvar, setting )
{
	/#
	if( GetDvarString( dvar ) == "" )
	{
		SetDvar( dvar, setting );
	}
	#/
}

function debugJump( num )
{
	ai = GetAIArray();
	for( i=0;i<ai.size;i++ )
	{
		if( ai[ i ] getentnum() != num )
		{
			continue;
		}
			
		// SCRIPTER_MOD
		// JesseS (3/20/2007): removed level.player, added players[0]
		players = GetPlayers();			
		line (players[0].origin, ai[i].origin, (0.2,0.3,1.0));
		return;
	}
}

function debugDvars()
{
//	if( GetDvarString( "debug_vehiclesittags" ) == "" )
//	{
//		SetDvar( "debug_vehiclesittags", "off" );
//	}
	
	if ( GetDvarString( "level_transition_test" ) == "" )
	{
		SetDvar( "level_transition_test", "off" );
	}

	if ( GetDvarString( "level_completeall" ) == "" )
	{
		SetDvar( "level_completeall", "off" );
	}

	if ( GetDvarString( "level_clear_all" ) == "" )
	{
		SetDvar( "level_clear_all", "off" );	
	}
	
	setEmptyDvar( "debug_accuracypreview", "off" );

	if( GetDvarString( "debug_lookangle" ) == "" )
	{
		SetDvar( "debug_lookangle", "off" );
	}

	if( GetDvarString( "debug_grenademiss" ) == "" )
	{
		SetDvar( "debug_grenademiss", "off" );
	}
	
	if( GetDvarString( "debug_dotshow" ) == "" )
	{
		SetDvar( "debug_dotshow", "-1" );
	}

	if( GetDvarString( "debug_replayenemypos" ) == "" )
	{
		SetDvar( "debug_replayenemypos", "-1" );
	}

	if( GetDvarString( "debug_tag" ) == "" )
	{
		SetDvar( "debug_tag", "" );
	}

	if( GetDvarString( "debug_chatlook" ) == "" )
	{
		SetDvar( "debug_chatlook", "" );
	}
		
	if( GetDvarString( "debug_vehicletag" ) == "" )
	{
		SetDvar( "debug_vehicletag", "" );
	}
		

	if( GetDvarString( "debug_goalradius" ) == "" )
	{
		SetDvar( "debug_goalradius", "off" );
	}
	
	if( GetDvarString( "debug_maxvisibledist" ) == "" )
	{
		SetDvar( "debug_maxvisibledist", "off" );
	}
	
	if( GetDvarString( "debug_health" ) == "" )
	{
		SetDvar( "debug_health", "off" );
	}
	
	if( GetDvarString( "debug_engagedist" ) == "" )
	{
		SetDvar( "debug_engagedist", "off" );
	}

	if( GetDvarString( "debug_animreach" ) ==  "" )
	{
		SetDvar( "debug_animreach", "off" );
	}

	if( GetDvarString( "debug_hatmodel" ) == "" )
	{
		SetDvar( "debug_hatmodel", "on" );
	}

	if( GetDvarString( "debug_trace" ) == "" )
	{
		SetDvar( "debug_trace", "off" );
	}

	level.debug_badpath = false;
	if( GetDvarString( "debug_badpath" ) == "" )
	{
		SetDvar( "debug_badpath", "off" );
	}

	if( GetDvarString( "anim_lastsightpos" ) == "" )
	{
		SetDvar( "debug_lastsightpos", "off" );
	}

	if( GetDvarString( "debug_dog_sound" ) == "" )
	{
		SetDvar( "debug_dog_sound", "" );
	}

	if( GetDvarString( "debug_nuke" ) == "" )
	{
		SetDvar( "debug_nuke", "off" );
	}

	if( GetDvarString( "debug_deathents" ) == "on" )
	{
		SetDvar( "debug_deathents", "off" );
	}

	if( GetDvarString( "debug_jump" ) == "" )
	{
		SetDvar( "debug_jump", "" );
	}

	if( GetDvarString( "debug_hurt" ) == "" )
	{
		SetDvar( "debug_hurt", "" );
	}

	if( GetDvarString( "animsound" ) == "" )
	{
		SetDvar( "animsound", "off" );
	}
	if( GetDvarString( "tag" ) == "" )
	{
		SetDvar( "tag", "" );
	}
	
	for( i=1; i <= level.animsound_hudlimit; i++ )
	{
		if( GetDvarString( "tag" + i ) == "" )
		{
			SetDvar( "tag" + i, "" );
		}
	}
		
	if( GetDvarString( "animsound_save" ) == "" )
	{
		SetDvar( "animsound_save", "" );
	}

	if( GetDvarString( "debug_depth" ) == "" )
	{
		SetDvar( "debug_depth", "" );
	}
	
	if( GetDvarString( "debug_ik" ) == "" )
	{
		SetDvar( "debug_ik", "0" );
		SetDvar( "debug_head_ik", "0" );
		SetDvar( "debug_leg_ik", "0" );		
	}
	
	// SCRIPTER_MOD: JesseS (3/18/2008):  added dynamic guy spawning
	if( GetDvarString( "debug_dynamic_ai_spawning" ) == "" )
	{
		SetDvar( "debug_dynamic_ai_spawning", "0" );
	}
		
	level.last_threat_debug = -23430;
	if( GetDvarString( "debug_threat" ) == "" )
	{
		SetDvar( "debug_threat", "-1" );
	}

	waittillframeend; // for vars to get init'd elsewhere

	if(GetDvarString( "debug_character_count") == "")
	{
		SetDvar("debug_character_count","off");
	}
		
	//	thread hatmodel();	
	//	thread debug_character_count();
	// level thread debug_show_viewpos();

	noAnimscripts = GetDvarString( "debug_noanimscripts" ) == "on";
	for( ;; )
	{
		if( GetDvarString( "debug_jump" ) != "" )
		{
			debugJump( GetDvarString( "debug_jump" ) );
		}
		
		if( GetDvarString( "debug_tag" ) != "" )
		{
			thread viewTag( "ai", GetDvarString( "debug_tag" ) );
			if( GetDvarString( "debug_enttag" ) > 0 )
			{
				thread drawEntTag( GetDvarString( "debug_enttag" ) );
			}
		}

		if( GetDvarString( "debug_goalradius" ) == "on" )
		{
			level thread debug_goalradius();
		}
		
		if( GetDvarString( "debug_maxvisibledist" ) == "on" )
		{
			level thread debug_maxvisibledist();
		}
		
		if( GetDvarString( "debug_health" ) == "on" )
		{
			level thread debug_health();
		}
		
		if( GetDvarString( "debug_engagedist" ) == "on" )
		{
			level thread debug_engagedist();
		}

		if( GetDvarString( "debug_vehicletag" ) != "" )
		{
			thread viewTag( "vehicle", GetDvarString( "debug_vehicletag" ) );
		}

		
//		if( GetDvarString( "debug_vehiclesittags" ) != "off" )
//		{
//			thread debug_vehiclesittags();
//		}
//
		thread debug_animSound();

		if( GetDvarString( "tag" ) != "" )
		{
			thread debug_animSoundTagSelected();
		}
	
		for( i=1; i <= level.animsound_hudlimit; i++ )
		{
			if( GetDvarString( "tag" + i ) != "" )
			{
				thread debug_animSoundTag( i );
			}
		}

		if( GetDvarString( "animsound_save" ) != "" )
		{
			thread debug_animSoundSave();
		}

		if( GetDvarString( "debug_nuke" ) != "off" )
		{
			thread debug_nuke();
		}

		if( GetDvarString( "debug_misstime" ) == "on" )
		{
			SetDvar( "debug_misstime", "start" );
			array::thread_all( GetAIArray(),&debugMisstime );
		}
		else if( GetDvarString( "debug_misstime" ) == "off" )
		{
			SetDvar( "debug_misstime", "start" );
			array::thread_all( GetAIArray(),&debugMisstimeOff );
		}

		if( GetDvarString( "debug_deathents" ) == "on" )
		{
			thread deathspawnerPreview();	
		}

		if( GetDvarString( "debug_hurt" ) == "on" )
		{
			SetDvar( "debug_hurt", "off" );
			
			// SCRIPTER_MOD
			// JesseS (3/20/2007): dodamage on all players instead of level.player
			players = GetPlayers();
			for(i = 0; i < players.size; i++)
			{
				players[i] dodamage(50, (324234,3423423,2323));
			}
		}

		if( GetDvarString( "debug_hurt" ) == "on" )
		{
			SetDvar( "debug_hurt", "off" );
			
			// SCRIPTER_MOD
			// JesseS (3/20/2007): dodamage on all players instead of level.player
			players = GetPlayers();
			for(i = 0; i < players.size; i++)
			{
				players[i] dodamage(50, (324234,3423423,2323));
			}
		}

		if( GetDvarString( "debug_depth" ) == "on" )
		{
			thread fogcheck();
		}

		if( GetDvarString( "debug_threat" ) != "-1" && GetDvarString( "debug_threat" ) != "" )
		{
			debugThreat();
		}

		level.debug_badpath = GetDvarString( "debug_badpath" ) == "on";
			
		if( !noAnimscripts && GetDvarString( "debug_noanimscripts" ) == "on" )
		{
			noAnimscripts = true;
		}
		
		if( noAnimscripts && GetDvarString( "debug_noanimscripts" ) == "off" )
		{
			anim.defaultException =&util::empty;
			anim notify( "new exceptions" );
			noAnimscripts = false;
		}

		if( GetDvarString( "debug_trace" ) == "on" )
		{
			if( !isdefined( level.traceStart ) )
			{
				thread showDebugTrace();
			}
						
			players = GetPlayers();
			
			level.traceStart = players[0] geteye();
			SetDvar( "debug_trace", "off" );
		}
				
		if( GetDvarString( "debug_dynamic_ai_spawning" ) == "1" && (!isdefined(level.spawn_anywhere_active) || level.spawn_anywhere_active == false) )
		{
			level.spawn_anywhere_active = true;
			thread dynamic_ai_spawner();
		}
		else if (GetDvarString( "debug_dynamic_ai_spawning" ) == "0" && isdefined(level.spawn_anywhere_active) && level.spawn_anywhere_active == true )
		{
			level.spawn_anywhere_active = false;
			level notify ("kill dynamic spawning");	
		}

		debug_ik_on_actors();
				
		{wait(.05);};
	}
}

function debug_ik_on_actors()
{
	toggleOn = GetDvarString("debug_ik") == "1";
	
	if( !toggleOn )
		return;
	
	toggleLegIk = GetDvarString("debug_leg_ik") == "1";
	toggleHeadIk = GetDvarString("debug_head_ik") == "1";
	ais = GetActorArray();	
	
	foreach( ai in ais )
	{
		if( toggleLegIk )
			ai.enableTerrainIk = 1;
		else
			ai.enableTerrainIk = 0;
				
		if( toggleHeadIk )
			ai LookAtEntity( level.players[0] );
		else
			ai LookAtEntity();
	}	
}

function showDebugTrace()
{
	startOverride = undefined;
	endOverride = undefined;
	startOverride =( 15.1859, -12.2822, 4.071 );
	endOverride =( 947.2, -10918, 64.9514 );

	assert( !isdefined( level.traceEnd ) );
	for( ;; )
	{
		// SCRIPTER_MOD
		// JesseS (3/20/2007): level.player changed to players[0]
		players = GetPlayers();
		{wait(.05);};
		start = startOverride;
		end = endOverride;
		if( !isdefined( startOverride ) )
		{
			start = level.traceStart;
		}
		if( !isdefined( endOverride ) )
		{
			end = players[0] geteye();
		}
			
		trace = bulletTrace( start, end, false, undefined );
		line( start, trace[ "position" ], ( 0.9, 0.5, 0.8 ), 0.5 );
	}	
}

function hatmodel()
{
	for( ;; )
	{
		if( GetDvarString( "debug_hatmodel" ) == "off" )
		{
			return;
		}
		noHat = [];
		ai = GetAIArray();
		
		for( i=0;i<ai.size;i++ )
		{
			if( isdefined( ai[ i ].hatmodel ) )
			{
				continue;
			}
				
			alreadyKnown = false;
			for( p=0;p<noHat.size;p++ )
			{
				if( noHat[ p ] != ai[ i ].classname )
				{
					continue;
				}
				alreadyKnown = true;
				break;
			}
			if( !alreadyKnown )
			{
				noHat[ noHat.size ] = ai[ i ].classname;
			}
		}
		
		if( noHat.size )
		{
			println( " " );
			println( "The following AI have no Hatmodel, so helmets can not pop off on head-shot death:" );
			for( i=0;i<noHat.size;i++ )
			{
				println( "Classname: ", noHat[ i ] );
			}
			println( "To disable hatModel spam, type debug_hatmodel off" );
		}
		wait( 15 );
	}
}

function debug_nuke()
{
	// CODER_MOD - no more level.player
	players = GetPlayers();
	player = players[0];
	dvar = GetDvarString( "debug_nuke" );
	if( dvar == "on" )
	{
		ai = GetAITeamArray( "axis", "all" );
		for( i=0;i<ai.size;i++ )
		{
			ai[ i ] dodamage( ai[ i ].health, ( 0, 0, 0 ), player );
		}
	}
	else if( dvar == "ai" )
	{
		ai = GetAITeamArray( "axis" );
		for( i=0;i<ai.size;i++ )
		{
			ai[ i ] dodamage( ai[ i ].health, ( 0, 0, 0 ), player );
		}
	}
	else if( dvar == "dogs" )
	{
		ai = getaispeciesarray( "axis", "dog" );
		for( i=0;i<ai.size;i++ )
		{
			ai[ i ] dodamage( ai[ i ].health, ( 0, 0, 0 ), player );
		}
	}	
	SetDvar( "debug_nuke", "off" );
}

function debug_missTime()
{
	
}
	
function freePlayer()
{
	SetDvar( "cl_freemove", "0" );
}

function deathspawnerPreview()
{
	waittillframeend;
	for( i=0;i<50;i++ )
	{
		if( !isdefined( level.deathspawnerents[ i ] ) )
		{
			continue;
		}
		array = level.deathspawnerents[ i ];
		for( p=0;p<array.size;p++ )
		{
			ent = array[ p ];
			if( isdefined( ent.truecount ) )
			{
				print3d( ent.origin, i + ": " + ent.truecount, ( 0, 0.8, 0.6 ), 5 );
			}
			else
			{
				print3d( ent.origin, i + ": " +  ".", ( 0, 0.8, 0.6 ), 5 );
			}
		}
	}
}

function getchains()
{
	chainarray = [];
	chainarray = getentarray( "minimap_line", "script_noteworthy" );
	array = [];
	for( i=0;i<chainarray.size;i++ )
	{
		array[ i ] = chainarray[ i ] getchain();
	}
	return array;
}

function getchain()
{
	array = [];
	ent = self;
	while( isdefined( ent ) )
	{
		array[ array.size ] = ent;
		if( !isdefined( ent ) || !isdefined( ent.target ) )
		{
			break;
		}
		ent = getent( ent.target, "targetname" );
		if( isdefined( ent ) && ent == array[ 0 ] )
		{
			array[ array.size ] = ent;
			break;
		}
	}
	originarray = [];
	for( i=0;i<array.size;i++ )
	{
		originarray[ i ] = array[ i ].origin;
	}
	return originarray;
	
}

function vecscale( vec, scalar )
{
	return( vec[ 0 ]*scalar, vec[ 1 ]*scalar, vec[ 2 ]*scalar );
}

function islookingatorigin( origin )
{
	normalvec = vectorNormalize( origin-self getShootAtPos() );
	veccomp = vectorNormalize(( origin-( 0, 0, 24 ) )-self getShootAtPos() );
	insidedot = vectordot( normalvec, veccomp );
	
	anglevec = anglestoforward( self getplayerangles() );
	vectordot = vectordot( anglevec, normalvec );
	if( vectordot > insidedot )
	{
		return true;
	}
	else
	{
		return false;
	}
}



function fogcheck()
{
	if( GetDvarString( "depth_close" ) == "" )
	{
		SetDvar( "depth_close", "0" );
	}
		
	if( GetDvarString( "depth_far" ) == "" )
	{
		SetDvar( "depth_far", "1500" );
	}
		
	close = GetDvarint( "depth_close" );
	far = GetDvarint( "depth_far" );
	setexpfog( close, far, 1, 1, 1, 0 );
}

function debugThreat()
{
//	if( gettime() > level.last_threat_debug + 1000 )
	{
		level.last_threat_debug = gettime();
		thread debugThreatCalc();
	}
}

function debugThreatCalc()
{
	// debug the threatbias from entities towards the specified ent
	ai = GetAIArray();
	entnum = GetDvarString( "debug_threat" );
	entity = undefined;
	
	// SCRIPTER_MOD
	// JesseS (3/20/2007): level.player changed to players[0]
	// TODO: This one should be checked for co-op more closely
	players = GetPlayers();
			
	if( entnum == 0 )
	{
		entity = players[0];
	}
	else
	{
		for( i=0; i < ai.size; i++ )
		{
			if( entnum != ai[ i ] getentnum() )
			{
				continue;
			}
			entity = ai[ i ];
			break;
		}
	}
	
	if( !isalive( entity ) )
	{
		return;
	}
	
	entityGroup = entity getthreatbiasgroup();
	array::thread_all( ai,&displayThreat, entity, entityGroup );
	players[0] thread displayThreat( entity, entityGroup );
}

function displayThreat( entity, entityGroup )
{
	self endon( "death" );

	if( self.team == entity.team )
	{
		return;
	}

	selfthreat = 0;		
	selfthreat+= self.threatBias;

	threat = 0;
	threat+= entity.threatBias;
	myGroup = undefined;

	if( isdefined( entityGroup ) )
	{
		myGroup = self getthreatbiasgroup();
		if( isdefined( myGroup ) )
		{
			threat += getthreatbias( entityGroup, myGroup );
			selfThreat += getthreatbias( myGroup, entityGroup );
		}
	}
	
	if( entity.ignoreme || threat < -900000 )
	{
		threat = "Ignore";
	}

	if( self.ignoreme || selfthreat < -900000 )
	{
		selfthreat = "Ignore";
	}
			
	// SCRIPTER_MOD
	// JesseS (3/20/2007): level.player changed to players[0]
	// TODO: This one should be checked for co-op more closely
	players = GetPlayers();
			
	const timer = 1*20;
	col =( 1, 0.5, 0.2 );
	col2 =( 0.2, 0.5, 1 );
	pacifist = self != players[0] && self.pacifist;
	
	for( i=0; i <= timer; i++ )
	{
		print3d( self.origin +( 0, 0, 65 ), "Him to Me:", col, 3 );
		print3d( self.origin +( 0, 0, 50 ), threat, col, 5 );
		if( isdefined( entityGroup ) )
		{
			print3d( self.origin +( 0, 0, 35 ), entityGroup, col, 2 );
		}

		print3d( self.origin +( 0, 0, 15 ), "Me to Him:", col2, 3 );
		print3d( self.origin +( 0, 0, 0 ), selfThreat, col2, 5 );
		if( isdefined( mygroup ) )
		{
			print3d( self.origin +( 0, 0, -15 ), mygroup, col2, 2 );
		}

		if( pacifist )
		{
			print3d( self.origin +( 0, 0, 25 ), "( Pacifist )", col2, 5 );
		}
		
		{wait(.05);};
	}
}

function init_animSounds()
{
	level.animSounds = [];
	level.animSound_aliases = [];
	waittillframeend; // now we know _load has run and the level.scr_notetracks have been defined
	waittillframeend; // wait one extra frameend because _audio.gso files waittillframeend and we have to start after them
	
	animnames = getarraykeys( level.scr_notetrack );
	for( i=0; i < animnames.size; i++ )
	{
		init_notetracks_for_animname( animnames[ i ] );
	}
	
	animnames = getarraykeys( level.scr_animSound );
	for( i=0; i < animnames.size; i++ )
	{
		init_animSounds_for_animname( animnames[ i ] );
	}
}

function init_notetracks_for_animname( animname )
{
	// copy all the scr_notetracks into animsound_aliases so they show up properly
	notetracks = getarraykeys( level.scr_notetrack[ animname ] );
	
	for( i=0; i < notetracks.size; i++ )
	{
		soundalias = level.scr_notetrack[ animname ][ i ][ "sound" ];
		if( !isdefined( soundalias ) )
		{
			continue;
		}
			
		anime = level.scr_notetrack[ animname ][ i ][ "anime" ];
		notetrack = level.scr_notetrack[ animname ][ i ][ "notetrack" ];
		level.animSound_aliases[ animname ][ anime ][ notetrack ][ "soundalias" ] = soundalias;
		if( isdefined( level.scr_notetrack[ animname ][ i ][ "created_by_animSound" ] ) )
		{
			level.animSound_aliases[ animname ][ anime ][ notetrack ][ "created_by_animSound" ] = true;
		}
	}
}

function init_animSounds_for_animname( animname )
{
	// copy all the scr_animSounds into animsound_aliases so they show up properly
	animes = getarraykeys( level.scr_animSound[ animname ] );
	
	for( i=0; i < animes.size; i++ )
	{
		anime = animes[ i ];
		soundalias = level.scr_animSound[ animname ][ anime ];
		level.animSound_aliases[ animname ][ anime ][ "#" + anime ][ "soundalias" ] = soundalias;
		level.animSound_aliases[ animname ][ anime ][ "#" + anime ][ "created_by_animSound" ] = true;
	}
}

function add_hud_line( x, y, msg )
{
	hudelm = newHudElem();
	hudelm.alignX = "left";
	hudelm.alignY = "middle";
	hudelm.x = x;
	hudelm.y = y;
	hudelm.alpha = 1;
	hudelm.fontScale = 1;
	hudelm.label = msg;
	level.animsound_hud_extralines[ level.animsound_hud_extralines.size ] = hudelm;
	return hudelm;
}

function debug_animSound()
{
	enabled = GetDvarString( "animsound" ) == "on";
	if( !isdefined( level.animsound_hud ) )
	{
		if( !enabled )
		{
			return;
		}
			
		// init the related variables
		level.animsound_selected = 0;
		level.animsound_input = "none";
		level.animsound_hud = [];
		level.animsound_hud_timer = [];
		level.animsound_hud_alias = [];
		level.animsound_hud_extralines = [];

		level.animsound_locked = false;
		level.animsound_locked_pressed = false;

		level.animsound_hud_animname = add_hud_line( -30, 180, "Actor: " );
		level.animsound_hud_anime = add_hud_line( 100, 180, "Anim: " );

		add_hud_line( 10, 190, "Notetrack or label" );
		add_hud_line( -30, 190, "Elapsed" );
		add_hud_line( -30, 160, "Del: Delete selected soundalias" );
		add_hud_line( -30, 150, "F12: Lock selection" );
		add_hud_line( -30, 140, "Add a soundalias with /tag alias or /tag# alias" );

		level.animsound_hud_locked = add_hud_line( -30, 170, "*LOCKED*" );
		level.animsound_hud_locked.alpha = 0;
		
		for( i=0; i < level.animsound_hudlimit; i++ )
		{
			hudelm = newHudElem();
			hudelm.alignX = "left";
			hudelm.alignY = "middle";
			hudelm.x = 10;
			hudelm.y = 200 + i*10;
			hudelm.alpha = 1;
			hudelm.fontScale = 1;
			hudelm.label = "";
			level.animsound_hud[ level.animsound_hud.size ] = hudelm;

			hudelm = newHudElem();
			hudelm.alignX = "right";
			hudelm.alignY = "middle";
			hudelm.x = -10;
			hudelm.y = 200 + i*10;
			hudelm.alpha = 1;
			hudelm.fontScale = 1;
			hudelm.label = "";
			level.animsound_hud_timer[ level.animsound_hud_timer.size ] = hudelm;

			hudelm = newHudElem();
			hudelm.alignX = "right";
			hudelm.alignY = "middle";
			hudelm.x = 210;
			hudelm.y = 200 + i*10;
			hudelm.alpha = 1;
			hudelm.fontScale = 1;
			hudelm.label = "";
			level.animsound_hud_alias[ level.animsound_hud_alias.size ] = hudelm;
		}

		// selected is yellow
		level.animsound_hud[ 0 ].color =( 1, 1, 0 );
		level.animsound_hud_timer[ 0 ].color =( 1, 1, 0 );
	}
	else if( !enabled )
	{
		// animsound got turned off so delete the hud stuff
		for( i=0; i < level.animsound_hudlimit; i++ )
		{
			level.animsound_hud[ i ] destroy();
			level.animsound_hud_timer[ i ] destroy();
			level.animsound_hud_alias[ i ] destroy();
		}
		
		for( i=0; i < level.animsound_hud_extralines.size; i++ )
		{
			level.animsound_hud_extralines[ i ] destroy();
		}
		
		level.animsound_hud = undefined;
		level.animsound_hud_timer = undefined;
		level.animsound_hud_alias = undefined;
		level.animsound_hud_extralines = undefined;
		level.animSounds = undefined;
		return;
	}

	if( !isdefined( level.animsound_tagged ) )
	{
		level.animsound_locked = false;
	}

	if( level.animsound_locked )
	{
		level.animsound_hud_locked.alpha = 1;
	}
	else
	{
		level.animsound_hud_locked.alpha = 0;
	}
	
	if( !isdefined( level.animSounds ) )
	{
		init_animSounds();
	}
	
	/*
	if( !isdefined( level.anim_sound_was_opened ) )
	{
		thread test_animsound_file();
	}
	*/

	level.animSounds_thisframe = [];
	ArrayRemoveValue( level.animSounds, undefined );
	array::thread_all( level.animSounds,&display_animSound );

	players = GetPlayers();
	
	if( level.animsound_locked )
	{
		for( i=0; i < level.animSounds_thisframe.size; i++ )
		{
			animSound = level.animSounds_thisframe[ i ];
			animSound.animsound_color =( 0.5, 0.5, 0.5 );
		}
	}
	else if ( players.size > 0 )
	{
		dot = 0.85;
                
		forward = anglestoforward( players[0] getplayerangles() );
		for( i=0; i < level.animSounds_thisframe.size; i++ )
		{
			animSound = level.animSounds_thisframe[ i ];
			animSound.animsound_color =( 0.25, 1.0, 0.5 );
						
			difference = vectornormalize(( animSound.origin +( 0, 0, 40 ) ) -( players[0].origin +( 0, 0, 55 ) ) );
			newdot = vectordot( forward, difference );
			if( newdot < dot )
			{
				continue;
			}
	
			dot = newdot;
			level.animsound_tagged = animSound;
		}
	}

	if( isdefined( level.animsound_tagged ) )
	{
		level.animsound_tagged.animsound_color =( 1.0, 1.0, 0.0 );
	}

	is_tagged = isdefined( level.animsound_tagged );
	for( i=0; i < level.animSounds_thisframe.size; i++ )
	{
		animSound = level.animSounds_thisframe[ i ];
		const scale = 1;
		/*
		soundalias = get_alias_from_stored( animSound );
		scale = 0.9;
		
		if( is_tagged && level.animsound_tagged == animSound )
			scale = 1;
			
		if( isdefined( soundalias ) )
		{
			if( is_from_animsound( animSound.animname, animSound.anime, animSound.notetrack ) )
			{
				print3d( animSound.origin, animSound.notetrack + " " + soundalias, animSound.color, 1, scale );
			}
			else
			{
				// put in a * so they know its unchangeable
				print3d( animSound.origin, animSound.notetrack + " *" + soundalias, animSound.color, 1, scale );
			}
		}
		else
		{
			print3d( animSound.origin, animSound.notetrack, animSound.color, 1, scale );
		}
		*/
		msg = "*";
		if( level.animsound_locked )
		{
			msg = "*LOCK";
		}
		print3d( animSound.origin +( 0, 0, 40 ), msg + animSound.animsounds.size, animSound.animsound_color, 1, scale );
	}
	
	if( is_tagged )
	{
		draw_animsounds_in_hud();		
	}
}

function draw_animsounds_in_hud()
{
	guy = level.animsound_tagged;
	animsounds = guy.animSounds;

	animname = "generic";
	if ( isdefined( guy.animname ) )
	{
		animname = guy.animname;
	}
	level.animsound_hud_animname.label = "Actor: " + animname;
	
    players = GetPlayers();
	if( players[0] buttonPressed( "f12" ) )
	{
		if( !level.animsound_locked_pressed )
		{
			level.animsound_locked = !level.animsound_locked;
			level.animsound_locked_pressed = true;
		}
	}
	else
	{
		level.animsound_locked_pressed = false;
	}

	if( players[0] buttonPressed( "UPARROW" ) )
	{
		if( level.animsound_input != "up" )
		{
			level.animsound_selected--;
		}
		
		level.animsound_input = "up";
	}
	else if( players[0] buttonPressed( "DOWNARROW" ) )
	{
		if( level.animsound_input != "down" )
		{
			level.animsound_selected++;
		}
		
		level.animsound_input = "down";
	}
	else
	{
		level.animsound_input = "none";
	}

	// clear out the hudelems	
	for( i=0; i < level.animsound_hudlimit; i++ )
	{
		hudelm = level.animsound_hud[ i ];
		hudelm.label = "";
		hudelm.color =( 1, 1, 1 );
		hudelm = level.animsound_hud_timer[ i ];
		hudelm.label = "";
		hudelm.color =( 1, 1, 1 );
		hudelm = level.animsound_hud_alias[ i ];
		hudelm.label = "";
		hudelm.color =( 1, 1, 1 );
	}

	// get the highest existing animsound on the guy
	keys = getarraykeys( animsounds );
	highest = -1;
	for( i=0; i < keys.size; i++ )
	{
		if( keys[ i ] > highest )
		{
			highest = keys[ i ];
		}
	}
	if( highest == -1 )
	{
		return;
	}
		
	if( level.animsound_selected > highest )
	{
		level.animsound_selected = highest;
	}
	if( level.animsound_selected < 0 )
	{
		level.animsound_selected = 0;
	}

	// make sure the selected one exists
	for( ;; )
	{
		if( isdefined( animsounds[ level.animsound_selected ] ) )
		{
			break;
		}
		
		level.animsound_selected--;
		if( level.animsound_selected < 0 )
		{
			level.animsound_selected = highest;
		}
	}

	level.animsound_hud_anime.label = "Anim: " + animsounds[ level.animsound_selected ].anime;
	
	level.animsound_hud[ level.animsound_selected ].color =( 1, 1, 0 );
	level.animsound_hud_timer[ level.animsound_selected ].color =( 1, 1, 0 );
	level.animsound_hud_alias[ level.animsound_selected ].color =( 1, 1, 0 );
	
	time = gettime();
	for( i=0; i < keys.size; i++ )
	{
		key = keys[ i ];
		animsound = animsounds[ key ];
		hudelm = level.animsound_hud[ key ];
		soundalias = get_alias_from_stored( animSound );
		hudelm.label =( key + 1 ) + ". " + animsound.notetrack;

		hudelm = level.animsound_hud_timer[ key ];
		hudelm.label = int(( time -( animsound.end_time - 60000 ) ) * 0.001 );

		if( isdefined( soundalias ) )
		{
			hudelm = level.animsound_hud_alias[ key ];
			hudelm.label = soundalias;
			if( !is_from_animsound( animSound.animname, animSound.anime, animSound.notetrack ) )
			{
				hudelm.color =( 0.7, 0.7, 0.7 );
			}
		}
	}
	
	players = GetPlayers();
	if( players[0] buttonPressed( "del" ) )
	{
		// delete a sound on a guy
		animsound = animsounds[ level.animsound_selected ];
		soundalias = get_alias_from_stored( animsound );
		if( !isdefined( soundalias ) )
		{
			return;
		}
		
		if( !is_from_animsound( animSound.animname, animSound.anime, animSound.notetrack ) )
		{
			return;
		}

		level.animSound_aliases[ animSound.animname ][ animSound.anime ][ animSound.notetrack ] = undefined;
		debug_animSoundSave();
	}
}

function get_alias_from_stored( animSound )
{
	if( !isdefined( level.animSound_aliases[ animSound.animname ] ) )
	{
		return;
	}
		
	if( !isdefined( level.animSound_aliases[ animSound.animname ][ animSound.anime ] ) )
	{
		return;
	}
		
	if( !isdefined( level.animSound_aliases[ animSound.animname ][ animSound.anime ][ animSound.notetrack ] ) )
	{
		return;
	}
	return level.animSound_aliases[ animSound.animname ][ animSound.anime ][ animSound.notetrack ][ "soundalias" ];
}

function is_from_animsound( animname, anime, notetrack )
{
	return isdefined( level.animSound_aliases[ animname ][ anime ][ notetrack ][ "created_by_animSound" ] );
}

function display_animSound()
{
        players = GetPlayers();
	if( distance( players[0].origin, self.origin ) > 1500 )
	{
		return;
	}

	level.animSounds_thisframe[ level.animSounds_thisframe.size ] = self;

	/*
	timer = gettime();
	keys = getarraykeys( self.animSounds );
	for( i=0; i < keys.size; i++ )
	{
		key = keys[ i ];
		animSound = self.animSounds[ key ];
		if( !isdefined( animSound ) )
			continue;
		
		if( timer > animSound.end_time )
		{
			self.animSounds[ key ] = undefined;
			continue;
		}
		
		animSound.origin = self.origin +( 0, 0, 50 + 10 * key );
		level.animSounds_thisframe[ level.animSounds_thisframe.size ] = animSound;
	}
	*/
}

function debug_animSoundTag( tagnum )
{
	
	tag = GetDvarString( "tag" + tagnum );
	if( tag == "" )
	{
		iprintlnbold( "Enter the soundalias with /tag# aliasname" );
		return;
	}

	tag_sound( tag, tagnum - 1 );
	
	SetDvar( "tag" + tagnum, "" );
}

function debug_animSoundTagSelected()
{
	
	tag = GetDvarString( "tag" );
	if( tag == "" )
	{
		iprintlnbold( "Enter the soundalias with /tag aliasname" );
		return;
	}

	tag_sound( tag, level.animsound_selected );
	
	SetDvar( "tag", "" );
	
}

function tag_sound( tag, tagnum )
{
	if( !isdefined( level.animsound_tagged ) )
	{
		return;
	}
	if( !isdefined( level.animsound_tagged.animsounds[ tagnum ] ) )
	{
		return;
	}

	animSound = level.animsound_tagged.animsounds[ tagnum ];
	// store the alias to the array of aliases
	soundalias = get_alias_from_stored( animSound );
	if( !isdefined( soundalias ) || is_from_animsound( animSound.animname, animSound.anime, animSound.notetrack ) )
	{
		level.animSound_aliases[ animSound.animname ][ animSound.anime ][ animSound.notetrack ][ "soundalias" ] = tag;
		level.animSound_aliases[ animSound.animname ][ animSound.anime ][ animSound.notetrack ][ "created_by_animSound" ] = true;
		debug_animSoundSave();
	}
}

function debug_animSoundSave()
{
	filename = "createfx/" + level.script + "_audio.gsc";
	file = openfile( filename, "write" );
	if( file == -1 )
	{
		iprintlnbold( "Couldn't write to " + filename + ", make sure it is open for edit." );
		return;
	}

	iprintlnbold( "Saved to " + filename );
	print_aliases_to_file( file );
	saved = closefile( file );
	SetDvar( "animsound_save", "" );
	
}

function print_aliases_to_file( file )
{
	tab = "    ";
	fprintln( file, "#using scripts\sp\\_anim;" );
	fprintln( file, "main()" );
	fprintln( file, "{" );
	fprintln( file, tab + "// Autogenerated by AnimSounds. Threaded off so that it can be placed before _load( has to create level.scr_notetrack first )." );
	fprintln( file, tab + "thread init_animsounds();" );
	fprintln( file, "}" );
	fprintln( file, "" );
	fprintln( file, "init_animsounds()" );
	fprintln( file, "{" );
	fprintln( file, tab + "waittillframeend;" );

	animnames = getarraykeys( level.animSound_aliases );
	for( i=0; i < animnames.size; i++ )
	{
		animes = getarraykeys( level.animSound_aliases[ animnames[ i ] ] );
		for( p=0; p < animes.size; p++ )
		{
			anime = animes[ p ];
			notetracks = getarraykeys( level.animSound_aliases[ animnames[ i ] ][ anime ] );
			for( z=0; z < notetracks.size; z++ )
			{
				notetrack = notetracks[ z ];
				if( !is_from_animsound( animnames[ i ], anime, notetrack ) )
				{
					continue;
				}
				
				alias = level.animSound_aliases[ animnames[ i ] ][ anime ][ notetrack ][ "soundalias" ];

				if( notetrack == "#" + anime )
				{
					// this isn't really a notetrack, its from the _anim call.
					fprintln( file, tab + "addOnStart_animSound( " + tostr( animnames[ i ] ) + ", " + tostr( anime ) + ", " + tostr( alias ) + " ); " );
				}
				else
				{
					// this is attached to a notetrack					
					fprintln( file, tab + "addNotetrack_animSound( " + tostr( animnames[ i ] ) + ", " + tostr( anime ) + ", " + tostr( notetrack ) + ", " + tostr( alias ) + " ); " );
				}
				println( "^1Saved alias ^4" + alias + "^1 to notetrack ^4" + notetrack );
			}
		}
	}
	fprintln( file, "}" );
}

function tostr( str )
{
	newstr = "\"";
	for( i=0; i < str.size; i++ )
	{
		if( str[ i ] == "\"" )
		{
			newstr += "\\";
			newstr += "\"";
			continue;
		}
		
		newstr += str[ i ];
	}
	newstr += "\"";
	return newstr;
}

function drawDebugLineInternal(fromPoint, toPoint, color, durationFrames)
{
	//println ("Drawing line, color "+color[0]+","+color[1]+","+color[2]);
	//player = getent("player", "classname" );
	//println ( "Point1 : "+fromPoint+", Point2: "+toPoint+", player: "+player.origin );
	for (i=0;i<durationFrames;i++)
	{
		line (fromPoint, toPoint, color);
		{wait(.05);};
	}
}

function drawDebugLine(fromPoint, toPoint, color, durationFrames)
{
	thread drawDebugLineInternal(fromPoint, toPoint, color, durationFrames);
}

function drawDebugEntToEntInternal(ent1,ent2,color,durationFrames)
{
	for (i=0;i<durationFrames;i++)
	{
		if (!isdefined(ent1)||!isdefined(ent2) )
			return;
			
		line (ent1.origin,ent2.origin,color);
		{wait(.05);};
	}
}
function drawDebugLineEntToEnt(ent1, ent2, color, durationFrames)
{
	thread drawDebugEntToEntInternal(ent1,ent2,color,durationFrames);
}

function complete_me()
{
//	if( GetDvarString( "credits_active") == "1" )
//	{
//		wait 7;
//		SetDvar( "credits_active", "0" ); 
//		endmission::credits_end();
//		return;
//	}
	wait 7;
	endmission::nextmission();
}


function new_hud( hud_name, msg, x, y, scale )
{
	if( !isdefined( level.hud_array ) )
	{
		level.hud_array = [];
	}

	if( !isdefined( level.hud_array[hud_name] ) )
	{
		level.hud_array[hud_name] = [];
	}

	hud = debug_menu::set_hudelem( msg, x, y, scale );
	level.hud_array[hud_name][level.hud_array[hud_name].size] = hud;
	return hud;
}

function debug_show_viewpos()
{
	//util::wait_for_first_player();//TODO T7 - update to a suitable CP equivalent

	hud_title = NewDebugHudElem();
	hud_title.x = 10;
	hud_title.y = 300;
	hud_title.alpha = 0; 
	hud_title.alignX = "left";
	hud_title.fontscale = 1.2;
	hud_title SetText( &"DEBUG_POSITION" );

	x_pos = hud_title.x + 50;

	hud_x = NewDebugHudElem();
	hud_x.x = x_pos;
	hud_x.y = 300;
	hud_x.alpha = 0; 
	hud_x.alignX = "left";
	hud_x.fontscale = 1.2;
	hud_x SetValue( 0 );

	hud_y = NewDebugHudElem();
	hud_y.x = 10;
	hud_y.y = 300;
	hud_y.alpha = 0; 
	hud_y.alignX = "left";
	hud_y.fontscale = 1.2;
	hud_y SetValue( 0 );

	hud_z = NewDebugHudElem();
	hud_z.x = 10;
	hud_z.y = 300;
	hud_z.alpha = 0; 
	hud_z.alignX = "left";
	hud_z.fontscale = 1.2;
	hud_z SetValue( 0 );

	SetDvar( "debug_show_viewpos", "0" );

	players = GetPlayers();
	while( 1 )
	{
		if( GetDvarint( "debug_show_viewpos" ) > 0 )
		{
			hud_title.alpha = 1;
			hud_x.alpha = 1;
			hud_y.alpha = 1;
			hud_z.alpha = 1;

			x = players[0].origin[0];
			y = players[0].origin[1];
			z = players[0].origin[2];

			spacing1 = ( ( 2 + number_before_decimal( x ) ) * 8 ) + 10;
			spacing2 = ( ( 2 + number_before_decimal( y ) ) * 8 ) + 10;

			hud_y.x = x_pos + spacing1;
			hud_z.x = x_pos + spacing1 + spacing2;

			hud_x SetValue( round_to( x, 100 ) );
			hud_y SetValue( round_to( y, 100 ) );
			hud_z SetValue( round_to( z, 100 ) );
		}
		else
		{
			hud_title.alpha = 0;
			hud_x.alpha = 0;
			hud_y.alpha = 0;
			hud_z.alpha = 0;
		}

		wait( 0.5 );
	}
}

function number_before_decimal( num )
{
	abs_num = abs( num );
	count = 0;
	while( 1 )
	{
		abs_num *= 0.1; // Really doing num / 10
		count += 1;

		if( abs_num < 1 )
		{
			return count;
		}
	}
}

function round_to( val, num ) 
{
	return Int( val * num ) / num; 
}

function set_event_printname_thread( text, focus )
{

	level notify( "stop_event_name_thread" );
	level endon( "stop_event_name_thread" );

	// We don't localize these, so don't get out! :P
	if( GetDvarint( "loc_warnings" ) > 0 )
	{
		return;
	}

	if( !isdefined( focus ) )
	{
		focus = false;	
	}

	suffix = "";
	if( focus )
	{
		suffix = " [Focus Event]";
	}

	SetDvar( "cg_zoneName", text );
	text = "Event: " + text + suffix;

	if( !isdefined( level.event_hudelem ) )
	{
		hud = NewHudElem();
		hud.horzAlign = "center";
		hud.alignX = "center";
		hud.alignY = "top";
		hud.foreground = 1;
		hud.fontScale = 1.5;
		hud.sort = 50;
		hud.alpha = 1;
		hud.y = 15;

		level.event_hudelem = hud;
	}

	if( focus )
	{
		level.event_hudelem.color = ( 1, 1, 0 );
	}
	else
	{
		level.event_hudelem.color = ( 1, 1, 1 );
	}

	if( GetDvarString( "debug_draw_event" ) == "" )
	{
		SetDvar( "debug_draw_event", "1" );
	}

	level.event_hudelem SetText( text );

	enabled = true;
	while( 1 )
	{
		toggle = false;

		if( GetDvarint( "debug_draw_event" ) < 1 )
		{
			toggle = true;
			enabled = false;
		}
		else if( GetDvarint( "debug_draw_event" ) > 0 )
		{
			toggle = true;
			enabled = true;
		}

		if( toggle && enabled )
		{
			level.event_hudelem.alpha = 1;
		}
		else if( toggle )
		{
			level.event_hudelem.alpha = 0;
		}

		wait( 0.5 );
	}

}

// -- SRS 3/19/08: engagement distance debug.  only works for P1 --

function get_playerone()
{
	return level.players[0];
}

// this controls the engagement distance debug stuff with a dvar
function engagement_distance_debug_toggle()
{
	
	level endon( "kill_engage_dist_debug_toggle_watcher" );
	
	lastState = GetDvarInt( "debug_engage_dists" );
	
	while( 1 )
	{
		currentState = GetDvarInt( "debug_engage_dists" );
		
		if( dvar_turned_on( currentState ) && !dvar_turned_on( lastState ) )
		{
			// turn it on
			weapon_engage_dists_init();
			thread debug_realtime_engage_dist();
			thread debug_ai_engage_dist();
			
			lastState = currentState;
		}
		else if( !dvar_turned_on( currentState ) && dvar_turned_on( lastState ) )
		{
			// send notify to turn off threads
			level notify( "kill_all_engage_dist_debug" );
			
			lastState = currentState;
		}
		
		wait( 0.3 );
	}
	
}

function dvar_turned_on( val )
{
	if( val <= 0 )
	{
		return false;
	}
	else
	{
		return true;
	}
}

function engagement_distance_debug_init( player )
{
	// set up debug stuff
	
	level.realtimeEngageDist = NewClientHudElem( player );
	level.realtimeEngageDist.alignX = "left";
	level.realtimeEngageDist.fontScale = 1.5;
	level.realtimeEngageDist.x = -50;
	level.realtimeEngageDist.y = 250;
	level.realtimeEngageDist.color = ( 1, 1, 1 );
	level.realtimeEngageDist SetText( "Current Engagement Distance: " );
	
	xPos = -50 + 207;
	
	level.realtimeEngageDist_value = NewClientHudElem( player );
	level.realtimeEngageDist_value.alignX = "left";
	level.realtimeEngageDist_value.fontScale = 1.5;
	level.realtimeEngageDist_value.x = xPos;
	level.realtimeEngageDist_value.y = 250;
	level.realtimeEngageDist_value.color = ( 1, 1, 1 );
	level.realtimeEngageDist_value SetValue( 0 );
	
	xPos += 37;
	
	level.realtimeEngageDist_middle = NewClientHudElem( player );
	level.realtimeEngageDist_middle.alignX = "left";
	level.realtimeEngageDist_middle.fontScale = 1.5;
	level.realtimeEngageDist_middle.x = xPos;
	level.realtimeEngageDist_middle.y = 250;
	level.realtimeEngageDist_middle.color = ( 1, 1, 1 );
	level.realtimeEngageDist_middle SetText( " units, SHORT/LONG by " );
	
	xPos += 105;
	
	level.realtimeEngageDist_offvalue = NewClientHudElem( player );
	level.realtimeEngageDist_offvalue.alignX = "left";
	level.realtimeEngageDist_offvalue.fontScale = 1.5;
	level.realtimeEngageDist_offvalue.x = xPos;
	level.realtimeEngageDist_offvalue.y = 250;
	level.realtimeEngageDist_offvalue.color = ( 1, 1, 1 );
	level.realtimeEngageDist_offvalue SetValue( 0 );
	
	hudObjArray = [];
	hudObjArray[0] = level.realtimeEngageDist;
	hudObjArray[1] = level.realtimeEngageDist_value;
	hudObjArray[2] = level.realtimeEngageDist_middle;
	hudObjArray[3] = level.realtimeEngageDist_offvalue;
	
	return hudObjArray;
}

function engage_dist_debug_hud_destroy( hudArray, killNotify )
{
	level waittill( killNotify );
	
	for( i = 0; i < hudArray.size; i++ )
	{
		hudArray[i] Destroy();
	}
}

function weapon_engage_dists_init()
{
	level.engageDists = [];
	
	// first pass ok
	genericPistol = spawnstruct();
	genericPistol.engageDistMin = 125;
	genericPistol.engageDistOptimal = 400;
	genericPistol.engageDistMulligan = 100;  // range around the optimal value that is still optimal
	genericPistol.engageDistMax = 600;
	
	// first pass ok
	shotty = spawnstruct();
	shotty.engageDistMin = 0;
	shotty.engageDistOptimal = 300;
	shotty.engageDistMulligan = 100;
	shotty.engageDistMax = 600;
	
	// first pass ok
	genericSMG = spawnstruct();
	genericSMG.engageDistMin = 100;
	genericSMG.engageDistOptimal = 500;
	genericSMG.engageDistMulligan = 150;
	genericSMG.engageDistMax = 1000;
	
	
	// first pass ok
	genericRifleSA = spawnstruct();
	genericRifleSA.engageDistMin = 325;
	genericRifleSA.engageDistOptimal = 800;
	genericRifleSA.engageDistMulligan = 300;
	genericRifleSA.engageDistMax = 1600;
	
	// first pass NEED TEST
	genericHMG = spawnstruct();
	genericHMG.engageDistMin = 500;
	genericHMG.engageDistOptimal = 700;
	genericHMG.engageDistMulligan = 300;
	genericHMG.engageDistMax = 1400;
	
	// first pass ok
	genericSniper = spawnstruct();
	genericSniper.engageDistMin = 950;
	genericSniper.engageDistOptimal = 2000;
	genericSniper.engageDistMulligan = 500;
	genericSniper.engageDistMax = 3000;
	
	//-- break up weapons by class instead of type
	engage_dists_add( "pistol", genericPistol );
	engage_dists_add( "smg", genericSMG );
	engage_dists_add( "spread", shotty );
	engage_dists_add( "mg", genericHMG );
	engage_dists_add( "rifle", genericRifleSA );
	
	// start waiting for weapon changes
	level thread engage_dists_watcher();
}

function engage_dists_add( weaponName, values )
{
	level.engageDists[ weaponName ] = values;
}

// returns a script_struct, or undefined, if the lookup failed
function get_engage_dists( weapon )
{
	if( isdefined( level.engageDists[weapon] ) )
	{
		return level.engageDists[weapon];
	}
	else
	{
		return undefined;
	}
}

// checks currently equipped weapon to make sure that engagement distance values are correct
function engage_dists_watcher()
{
	level endon( "kill_all_engage_dist_debug" );
	level endon( "kill_engage_dists_watcher" );
	
	while( 1 )
	{
		player = get_playerone();
		playerWeapon = player GetCurrentWeapon();
		
		if( !isdefined( player.lastweapon ) )
		{
			player.lastweapon = playerWeapon;
		}
		else
		{
			if( player.lastweapon == playerWeapon )
			{
				{wait(.05);};
				continue;
			}
		}
		
		values = get_engage_dists( playerWeapon.weapClass );
		
		if( isdefined( values ) )
		{
			level.weaponEngageDistValues = values;
		}
		else
		{
			level.weaponEngageDistValues = undefined;
		}
		
		player.lastweapon = playerWeapon;
		
		{wait(.05);};
	}
}

function debug_realtime_engage_dist()
{
	level endon( "kill_all_engage_dist_debug" );
	level endon( "kill_realtime_engagement_distance_debug" );
	
	player = get_playerone();
	
	hudObjArray = engagement_distance_debug_init( player );
	level thread engage_dist_debug_hud_destroy( hudObjArray, "kill_all_engage_dist_debug" );
	
	level.debugRTEngageDistColor = ( 0, 1, 0 );
	
	while( 1 )
	{
		lastTracePos = ( 0, 0, 0 );
		
		// Trace to where the player is looking
		direction = player GetPlayerAngles();
		direction_vec = AnglesToForward( direction );
		eye = player GetEye();
		
		trace = BulletTrace( eye, eye + VectorScale( direction_vec, 10000 ), true, player );
		tracePoint = trace["position"];
		traceNormal =  trace["normal"];
		traceDist = int( Distance( eye, tracePoint ) );  // just need an int, thanks
		
		if( tracePoint != lastTracePos )
		{
			lastTracePos = tracePoint;
			
			if( !isdefined( level.weaponEngageDistValues ) )
			{
				hudobj_changecolor( hudObjArray, ( 1, 1, 1 ) );
				hudObjArray engagedist_hud_changetext( "nodata", tracedist );
			}
			else
			{
				// for convenience
				engageDistMin = level.weaponEngageDistValues.engageDistMin;
				engageDistOptimal = level.weaponEngageDistValues.engageDistOptimal;
				engageDistMulligan = level.weaponEngageDistValues.engageDistMulligan;
				engageDistMax = level.weaponEngageDistValues.engageDistMax;
						
				// if inside our engagement distance range...
				if( ( traceDist >= engageDistMin ) && ( traceDist <= engageDistMax ) )
				{
					// if in the optimal range...
					if( ( traceDist >= ( engageDistOptimal - engageDistMulligan ) )
					&& ( traceDist <= ( engageDistOptimal + engageDistMulligan ) ) )
					{
						hudObjArray engagedist_hud_changetext( "optimal", tracedist );
						hudobj_changecolor( hudObjArray, ( 0, 1, 0 ) );
					}
					else
					{
						hudObjArray engagedist_hud_changetext( "ok", tracedist );
						hudobj_changecolor( hudObjArray, ( 1, 1, 0 ) );
					}
				}
				else if( traceDist < engageDistMin )
				{
					hudobj_changecolor( hudObjArray, ( 1, 0, 0 ) );
					hudObjArray engagedist_hud_changetext( "short", tracedist );
				}
				else if( traceDist > engageDistMax )
				{
					hudobj_changecolor( hudObjArray, ( 1, 0, 0 ) );
					hudObjArray engagedist_hud_changetext( "long", tracedist );
				}
			}
		}
		
		// draw our trace spot
		// plot_circle_fortime(radius1,radius2,time,color,origin,normal)
		thread plot_circle_fortime( 1, 5, 0.05, level.debugRTEngageDistColor, tracePoint, traceNormal );
		thread plot_circle_fortime( 1, 1, 0.05, level.debugRTEngageDistColor, tracePoint, traceNormal );
		
		{wait(.05);};
	}
}

function hudobj_changecolor( hudObjArray, newcolor )
{
	for( i = 0; i < hudObjArray.size; i++ )
	{
		hudObj = hudObjArray[i];
		
		if( hudObj.color != newcolor )
		{
			hudObj.color = newcolor;
			level.debugRTEngageDistColor = newcolor;
		}
	}
}

// self = an array of hud objects
function engagedist_hud_changetext( engageDistType, units )
{
	if( !isdefined( level.lastDistType ) )
	{
		level.lastDistType = "none";
	}
	
	if( engageDistType == "optimal" )
	{
		self[1] SetValue( units );
		self[2] SetText( "units: OPTIMAL!" );
		self[3].alpha = 0;
	}
	else if( engageDistType == "ok" )
	{
		self[1] SetValue( units );
		self[2] SetText( "units: OK!" );
		self[3].alpha = 0;
	}
	else if( engageDistType == "short" )
	{
		amountUnder = level.weaponEngageDistValues.engageDistMin - units;
		self[1] SetValue( units );
		self[3] SetValue( amountUnder );
		self[3].alpha = 1;
		
		if( level.lastDistType != engageDistType )
		{
			self[2] SetText( "units: SHORT by " );
		}
	}
	else if( engageDistType == "long" )
	{
		amountOver = units - level.weaponEngageDistValues.engageDistMax;
		self[1] SetValue( units );
		self[3] SetValue( amountOver );
		self[3].alpha = 1;
		
		if( level.lastDistType != engageDistType )
		{
			self[2] SetText( "units: LONG by " );
		}
	}
	else if( engageDistType == "nodata" )
	{
		self[1] SetValue( units );
		self[2] SetText( " units: (NO CURRENT WEAPON VALUES)" );
		self[3].alpha = 0;
	}
	
	level.lastDistType = engageDistType;
}

// draws print3ds above enemy AI heads to show contact distances
function debug_ai_engage_dist()
{
	level endon( "kill_all_engage_dist_debug" );
	level endon( "kill_ai_engagement_distance_debug" );
	
	player = get_playerone();
	
	while( 1 )
	{
		axis = GetAITeamArray( "axis" );
		
		if( isdefined( axis ) && axis.size > 0 )
		{	
			playerEye = player GetEye();
		
			for( i = 0; i < axis.size; i++ )
			{
				ai = axis[i];
				aiEye = ai GetEye();
				
				if( SightTracePassed( playerEye, aiEye, false, player ) && !IsVehicle( ai ) )
				{
					dist = Distance( playerEye, aiEye );
					
					drawColor = ( 1, 1, 1 );
					drawString = "-";
					

					// for convenience
					engageDistMin = ai.engageMinDist;
					engageDistFalloffMin = ai.engageminfalloffdist;
					engageDistFalloffMax = ai.engagemaxfalloffdist;
					engageDistMax = ai.engagemaxdist;
							
					//  if enemy is inside the engagment min and max, he is in a good position
					if( ( dist >= engageDistMin ) && ( dist <= engageDistMax ) )
					{
						{
							drawColor = ( 0, 1, 0 );
							drawString = "Good";
						}
					}
					else if( dist < engageDistMin  &&  dist >= engageDistFalloffMin )
					{
						drawColor = ( 1, 1, 0 );
						drawString = "Getting Close";
					}
					else if( dist > engageDistMax  &&  dist <= engageDistFalloffMax )
					{
						drawColor = ( 1, 1, 0 );
						drawString = "Getting Far";
					}
					else if( dist > engageDistFalloffMax )
					{
						drawColor = ( 1, 0, 0 );
						drawString = "Too Far";
					}
					else if( dist < engageDistFalloffMin )
					{
						drawColor = ( 1, 0, 0 );
						drawString = "Too Close";
					}		
					
					scale = dist / 1000;
					Print3d( ai.origin + ( 0, 0, 67 ), drawString + " " + dist, drawColor, 1, scale );
				}
			}
		}
		
		{wait(.05);};
	}
}


function debug_coop_bot_test()
{
    botCount = 0;
    
    AddDebugCommand("set bot_AllowMovement 1; set bot_PressAttackBtn 1; set bot_PressMeleeBtn 1; set scr_botsAllowKillstreaks 0; set bot_AllowGrenades 1");
    
    while(true)
    {
    	if( GetDvarInt("debug_coop_bot_joinleave" ) > 0 )
    	{
		    while( GetDvarInt("debug_coop_bot_joinleave" ) > 0)
		    {    
		        if(botCount > 0 && RandomInt(100)>70)
		        {
		            AddDebugCommand("set devgui_bot remove");
		            botCount--;
		            debugMsg ("Bot is being removed.   Count=" + botCount);
		        }
		        else if(botCount < GetDvarInt("debug_coop_bot_joinleave" )  && RandomInt(100)>70)
		        {
		            AddDebugCommand("set devgui_bot add");
		            botCount++;
		            debugMsg ("Bot is being added.  Count=" + botCount);
		        }
		     
		        wait RandomIntRange(5,10);
		    }
    	}
    	else
    	{
    		//remove any bots that are left after this is turned off
    		while( botCount > 0 )
    		{
    			AddDebugCommand("set devgui_bot remove");
		        botCount--;
		        debugMsg ("Bot is being removed.   Count="+botCount);
		        
		        wait 1; // delay the disconnections
    		}
    	}
    	
    	wait 1; // occasionally check the dvar	
    }
}


function debugMsg(str_txt)
{
    /#
        iprintln(str_txt);
	    if( isdefined( level.name ) ) //not defeind for testmaps
	    {
     		println("["+level.name+"] " + str_txt);
	    }
    #/
}



// draws a circle in script
function plot_circle_fortime( radius1, radius2, time, color = ( 0, 1, 0 ), origin, normal )
{
	circleres = 6;
	circleinc = 360 / circleres;
	circleres++;
	
	plotpoints = [];

	rad = 0.00;
	
	radius = radius2;
	
	angletoplayer = VectorToAngles( normal );
	
	for ( i = 0; i < circleres; i++ )
	{
		plotpoints[ plotpoints.size ] = origin + VectorScale( AnglesToForward( ( angletoplayer + ( rad, 90, 0 ) ) ), radius );
		rad += circleinc;
	}
	
	plot_points( plotpoints, color[ 0 ], color[ 1 ], color[ 2 ], time );
}

// -- end engagement distance debug --

// -- dynamic AI spawning --
// This allows guys to be spawned in whereever. Need an enemy spawner in the map,
// or a specially designated spawner.
function dynamic_ai_spawner()
{
	if (!isdefined(level.debug_dynamic_ai_spawner))
	{
		dynamic_ai_spawner_find_spawners();
		level.debug_dynamic_ai_spawner = true;
	}

	GetPlayers()[0] thread spawn_guy_placement(); 
	
	// Cleanup hudelems, dummy models, etc.
	level waittill ("kill dynamic spawning");
	
	if (isdefined(level.dynamic_spawn_hud))
	{
		level.dynamic_spawn_hud destroy();
	}
	
	if (isdefined(level.dynamic_spawn_dummy_model))
	{
		level.dynamic_spawn_dummy_model delete();
	}

}

// We want to create a spawner here eventually, but grabbing one in the map will
// do for now.
function dynamic_ai_spawner_find_spawners()
{
	spawners = getspawnerarray();
	
	level.aitypes = [];
	level.aitype_index = 0;
	
	foreach( spawner in spawners )
	{
		old_forcespawn = spawner.script_forcespawn;
		spawner.script_forcespawn = 1;
		tempSpawn = spawner spawner::spawn();
		if ( !spawner::spawn_failed( tempSpawn ) )
		{
			type = undefined;
			s = SpawnStruct();
			if( IsVehicle( tempSpawn ) )
	{
				type = tempSpawn.vehicletype;
				s.isVehicle = true;
				s.radius = tempSpawn GetMaxs()[0] * 1.3;
				if( tempSpawn.vehicleclass == "helicopter" )
		{
					s.flying = true;
				}
		}
			else
		{
				type = tempSpawn.aitype;
				s.isVehicle = false;
				s.radius = 64;
}
			s.model = tempSpawn.model;

			level.aitypes[ type ] = s;

		tempSpawn Delete();
	}
		spawner.script_forcespawn = old_forcespawn;
	}
}


// Where to spawn the AI
function spawn_guy_placement()
{	
	level endon ("kill dynamic spawning");
	
	assert( isdefined(level.aitypes) && level.aitypes.size > 0 , "No spawners in the level!");
	
	level.dynamic_spawn_hud = NewClientHudElem(GetPlayers()[0]);
	level.dynamic_spawn_hud.alignX = "left";
	level.dynamic_spawn_hud.x = 0;
	level.dynamic_spawn_hud.y = 245;
	level.dynamic_spawn_hud.fontscale = 1.5;
		
	level.dynamic_spawn_hud settext("Press X to spawn AI");
	
	level.dynamic_spawn_dummy_model = Spawn("script_model",(0,0,0));

	wait 0.1;

	const waittime = 0.3;
	
	types = getArrayKeys( level.aitypes );
	
	for (;;)
	{
		// Trace to where the player is looking
		direction = self getPlayerAngles();
		direction_vec = anglesToForward( direction );
		eye = self getEye();

		type = types[level.aitype_index];
		
		trace_dist = 4000;
		if( isdefined( level.aitypes[ type ].flying ) )
		{
			trace_dist = 500;
		}
		// offset 2 units on the Z to fix the bug where it would drop through the ground sometimes
		trace = bullettrace( eye, eye + VectorScale( direction_vec, trace_dist ), 0, level.dynamic_spawn_dummy_model );

		dist = distance (eye, trace["position"]);		
		position = eye + VectorScale( direction_vec , (dist - level.aitypes[ type ].radius) );
			
		// debug		
		//thread _utility::draw_line_for_time( eye - (1,1,1), position, 1, 0, 0, 0.05 );
			
		origin = position;
		angles = self.angles + (0,180,0);
				
		level.dynamic_spawn_dummy_model.origin = position;
		level.dynamic_spawn_dummy_model.angles = angles;
				
		level.dynamic_spawn_hud settext("Press X to spawn AI: " + type );

		level.dynamic_spawn_dummy_model SetModel( level.aitypes[type].model );
		level.dynamic_spawn_dummy_model Show();
		level.dynamic_spawn_dummy_model NotSolid();
 
		if( self UseButtonPressed() )
{
			level.dynamic_spawn_dummy_model Hide();

			if( level.aitypes[type].isVehicle )
			{
				spawn = SpawnVehicle( types[level.aitype_index], origin, angles, "dynamic_spawn_ai" );
	}
	else
	{
				spawn = SpawnActor( types[level.aitype_index], origin, angles, "dynamic_spawn_ai", true );
			}
		
			// handle the flags
			spawn.ignoreMe = GetDvarString( "debug_dynamic_ai_ignoreMe" ) == "1";
			spawn.ignoreAll = GetDvarString( "debug_dynamic_ai_ignoreAll" ) == "1";
			spawn.pacifist = GetDvarString( "debug_dynamic_ai_pacifist" ) == "1";
		
			// let allies move around
			spawn.fixedNode = 0;
			
			wait waittime;
		}
		if( self buttonpressed("DPAD_RIGHT") )
		{
			level.dynamic_spawn_dummy_model Hide();
			level.aitype_index++;
			if( level.aitype_index >= types.size )
				level.aitype_index = 0;
			wait waittime;
		}
		if( self buttonpressed("DPAD_LEFT") )
		{
			level.dynamic_spawn_dummy_model Hide();
			level.aitype_index--;
			if( level.aitype_index < 0 )
				level.aitype_index = types.size - 1;
			wait waittime;
		}
		if( self buttonpressed("BUTTON_B") )
		{
			SetDvar( "debug_dynamic_ai_spawning", "0" );
		}
		
		{wait(.05);};
	}
}
// -- end dynamic AI spawning --

// AE 2-26-09: for the modules, globally print this to the screen
function display_module_text()
{
	
	wait(1);
	iPrintLnBold("Please open and read " + level.script + ".gsc for complete understanding");
	
}


function debug_goalradius()
{

	guys = GetAIArray();

	for( i = 0; i < guys.size; i++ )
	{
		
		if( guys[i].team == "axis" )
		{
			print3d( guys[i].origin + ( 0, 0, 70 ), (isdefined(guys[i].goalradius)?""+guys[i].goalradius:""), ( 1.0, 0.0, 0.0 ), 1, 1, 1 );	
			Record3dText( "" + guys[i].goalradius, guys[i].origin + ( 0, 0, 70 ), ( 1, 0, 0 ), "Animscript" );
		}
		else
		{
			print3d( guys[i].origin + ( 0, 0, 70 ), (isdefined(guys[i].goalradius)?""+guys[i].goalradius:""), ( 0.0, 1.0, 0.0 ), 1, 1, 1 );	
			Record3dText( "" + guys[i].goalradius, guys[i].origin + ( 0, 0, 70 ), ( 0, 1, 0 ), "Animscript" );
		}
		
	}
	
}

function debug_maxvisibledist()
{

	guys = GetAIArray();
	
	for( i = 0; i < guys.size; i++ )
	{		
		RecordEntText( (isdefined(guys[i].maxvisibledist)?""+guys[i].maxvisibledist:""), guys[i], level.debugTeamColors[ guys[i].team ], "Animscript" );		
	}
	
	RecordEntText( (isdefined(level.player.maxvisibledist)?""+level.player.maxvisibledist:""), level.player, level.debugTeamColors[ "allies" ], "Animscript" );		
	
}

function debug_health()
{

	guys = GetAIArray();

	for( i = 0; i < guys.size; i++ )
	{		
		RecordEntText( (isdefined(guys[i].health)?""+guys[i].health:""), guys[i], level.debugTeamColors[ guys[i].team ], "Animscript" );		
	}
	
	vehicles = GetVehicleArray();

	for( i = 0; i < vehicles.size; i++ )
	{		
		RecordEntText( (isdefined(vehicles[i].health)?""+vehicles[i].health:""), vehicles[i], level.debugTeamColors[ vehicles[i].team ], "Animscript" );		
	}
	
	RecordEntText( (isdefined(level.player.health)?""+level.player.health:""), level.player, level.debugTeamColors[ "allies" ], "Animscript" );		
	
}

function debug_engagedist()
{

	guys = GetAIArray();
	
	for( i = 0; i < guys.size; i++ )
	{		
		distString = guys[i].engageminfalloffdist + " - " + guys[i].engagemindist + " - " + guys[i].engagemaxdist + " - " + guys[i].engagemaxfalloffdist;
		RecordEntText( distString, guys[i], level.debugTeamColors[ guys[i].team ], "Animscript" );		
	}
		
	
}

function debug_sphere( origin, radius, color, alpha, time )
{

	if ( !isdefined(time) )
	{
		time = 1000;
	}
	if ( !isdefined(color) )
	{
		color = (1,1,1);
	}
	
	sides = Int(10 * ( 1 + Int(radius) % 100 ));
	sphere( origin, radius, color, alpha, true, sides, time );

}

//MOVED FROM UTILITY

/@
"Name: draw_arrow_time( <start> , <end> , <color> , <duration> )"
"Summary: Draws an arrow pointing at < end > in the specified color for < duration > seconds."
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <start> : starting coordinate for the arrow"
"MandatoryArg: <end> : ending coordinate for the arrow"
"MandatoryArg: <color> :( r, g, b ) color array for the arrow"
"MandatoryArg: <frames> : how many server frames to draw the arrow"
"Example: thread draw_arrow_time( lasttarg.origin, targ.origin, ( 0, 0, 1 ), 5.0 );"
"SPMP: singleplayer"
@/
function draw_arrow_time( start, end, color, frames )
{
	level endon( "newpath" );
	pts = [];
	angles = VectorToAngles( start - end );
	right = AnglesToRight( angles );
	forward = AnglesToForward( angles );
	up = AnglesToUp( angles );

	dist = Distance( start, end );
	arrow = [];
	const range = 0.1;

	arrow[ 0 ] =  start;
	arrow[ 1 ] =  start + VectorScale( right, dist * ( range ) ) + VectorScale( forward, dist * - 0.1 );
	arrow[ 2 ] =  end;
	arrow[ 3 ] =  start + VectorScale( right, dist * ( - 1 * range ) ) + VectorScale( forward, dist * - 0.1 );

	arrow[ 4 ] =  start;
	arrow[ 5 ] =  start + VectorScale( up, dist * ( range ) ) + VectorScale( forward, dist * - 0.1 );
	arrow[ 6 ] =  end;
	arrow[ 7 ] =  start + VectorScale( up, dist * ( - 1 * range ) ) + VectorScale( forward, dist * - 0.1 );
	arrow[ 8 ] =  start;

	r = color[ 0 ];
	g = color[ 1 ];
	b = color[ 2 ];

	plot_points( arrow, r, g, b, frames );
}

function draw_arrow( start, end, color )
{
	level endon( "newpath" );
	pts = [];
	angles = VectorToAngles( start - end );
	right = AnglesToRight( angles );
	forward = AnglesToForward( angles );

	dist = Distance( start, end );
	arrow = [];
	const range = 0.05;
	arrow[ 0 ] =  start;
	arrow[ 1 ] =  start + VectorScale( right, dist * ( range ) ) + VectorScale( forward, dist * - 0.2 );
	arrow[ 2 ] =  end;
	arrow[ 3 ] =  start + VectorScale( right, dist * ( - 1 * range ) ) + VectorScale( forward, dist * - 0.2 );

	for( p = 0;p < 4;p++ )
	{
		nextpoint = p + 1;
		if( nextpoint >= 4 )
		{
			nextpoint = 0;
		}
		line( arrow[ p ], arrow[ nextpoint ], color, 1.0 );
	}
}

function debugorigin()
{
	//	self endon( "killanimscript" );
	//	self endon( anim.scriptChange );
	self notify( "Debug origin" );
	self endon( "Debug origin" );
	self endon( "death" );
	for( ;; )
	{
		forward = AnglesToForward( self.angles );
		forwardFar = VectorScale( forward, 30 );
		forwardClose = VectorScale( forward, 20 );
		right = AnglesToRight( self.angles );
		left = VectorScale( right, -10 );
		right = VectorScale( right, 10 );
		line( self.origin, self.origin + forwardFar, ( 0.9, 0.7, 0.6 ), 0.9 );
		line( self.origin + forwardFar, self.origin + forwardClose + right, ( 0.9, 0.7, 0.6 ), 0.9 );
		line( self.origin + forwardFar, self.origin + forwardClose + left, ( 0.9, 0.7, 0.6 ), 0.9 );
		{wait(.05);};
	}
}

function plot_points( plotpoints, r, g, b, timer )
{
	lastpoint = plotpoints[ 0 ];
	if( !isdefined( r ) )
	{
		r = 1;
	}
	if( !isdefined( g ) )
	{
		g = 1;
	}
	if( !isdefined( b ) )
	{
		b = 1;
	}
	if( !isdefined( timer ) )
	{
		timer = 0.05;
	}
	for( i = 1;i < plotpoints.size;i++ )
	{
		thread draw_line_for_time( lastpoint, plotpoints[ i ], r, g, b, timer );
		lastpoint = plotpoints[ i ];
	}
}

/@
"Name: draw_line_for_time( <org1> , <org2> , <r> , <g> , <b> , <timer> )"
"Summary: Draws a line from < org1 > to < org2 > in the specified color for the specified duration"
"Module: Debug"
"CallOn: "
"MandatoryArg: <org1> : starting origin for the line"
"MandatoryArg: <org2> : ending origin for the line"
"MandatoryArg: <r> : red color value( 0 to 1 )"
"MandatoryArg: <g> : green color value( 0 to 1 )"
"MandatoryArg: <b> : blue color value( 0 to 1 )"
"MandatoryArg: <timer> : time in seconds the line should last"
"Example: thread draw_line_for_time( player.origin, vehicle.origin, 1, 0, 0, 10.0 );"
"SPMP: singleplayer"
@/
function draw_line_for_time( org1, org2, r, g, b, timer )
{
	timer = gettime() + ( timer * 1000 );
	while( GetTime() < timer )
	{
		line( org1, org2, ( r, g, b ), 1 );
		RecordLine( org1, org2, (1,1,1), "Script" ); 
		wait .05;
	}

}

function _get_debug_color( str_color )
{
	switch( str_color )
	{
		case "red":
			return ( 1, 0, 0 );
			break;
			
		case "green":
			return ( 0, 1, 0 );
			break;
			
		case "blue":
			return ( 0, 0, 1 );
			break;
			
		case "yellow":
			return ( 1, 1, 0 );	
			break;
			
		case "orange":
			return ( 1, .5, 0 );
			break;
			
		case "cyan":
			return ( 0, 1, 1 );
			break;
			
		case "white":
			return ( 1, 1, 1 );
			break;
			
		case "grey":
			return ( 0.75, 0.75, 0.75 );
			break;
			
		case "black":
			return ( 0, 0, 0 );
			break;
			
		default:
			PrintLn( "Debug color " + str_color + " not set in debug::_get_debug_color(). Please add this color." );
			return ( 0, 0, 0 );
			break;
	}
}

function debug_info_screen( text_array, time, fade_in_bg_time, fade_out_bg_time, fade_in_text_time, fade_out_text_time, font_size, show_black_background )
{
	if ( !IsDefined( time ) )
	{
		time = 3.0;
	}
	
	if ( !IsDefined( fade_in_bg_time ) )
	{
		fade_in_bg_time = 0.0;
	}
	
	if ( !IsDefined( fade_out_bg_time ) )
	{
		fade_out_bg_time = 2.0;
	}
	
	if ( !IsDefined( fade_in_text_time ) )
	{
		fade_in_text_time = 2.0;
	}
	
	if ( !IsDefined( fade_out_text_time ) )
	{
		fade_out_text_time = 2.0;
	}
	
	if ( !IsDefined( font_size ) )
	{
		font_size = 2.0;
	}
	
	if ( !IsDefined( show_black_background ) )
	{
		show_black_background = true;
	}
	
	if ( show_black_background )
	{
		if ( IsPlayer( self ) )
		{
			background = hud::createicon( "black", 640, 480 );
		}
		else
		{
			background = hud::createservericon( "black", 640, 480 );
		}
		background.horzAlign = "fullscreen";
		background.vertAlign = "fullscreen";
		background.foreground = true;
		background.sort = 0;
		background.x = 320;
		background.y = 0;
		
		if ( fade_in_bg_time > 0.0 )
		{
			background.alpha = 0.0;
			background FadeOverTime( fade_in_bg_time );
			background.alpha = 1.0;
			wait fade_in_bg_time;
		}
		else
		{
			background.alpha = 1.0;
		}
	}
	
	text_elems = [];
	
	spacing = int(level.fontHeight * font_size) + 2;
	
	start_y = 0;
	
	if ( IsArray( text_array ) )
	{
		start_y = 0 - ( text_array.size * spacing / 2 );
		foreach( text in text_array )
		{
			if ( IsPlayer( self ) )
			{
				text_elems[ text_elems.size ] = hud::createfontstring( "default", font_size );
			}
			else
			{
				text_elems[ text_elems.size ] = hud::createserverfontstring( "default", font_size );
			}
			text_elems[ text_elems.size - 1 ] SetText( text );
		}
	}
	else
	{
		if ( IsPlayer( self ) )
		{
			text_elems[ text_elems.size ] = hud::createfontstring( "default", font_size );
		}
		else
		{
			text_elems[ text_elems.size ] = hud::createserverfontstring( "default", font_size );
		}
		text_elems[ text_elems.size - 1 ] SetText( text );
	}
	
	text_num = 0;
	
	foreach( text_elem in text_elems )
	{
		text_elem.horzAlign = "center";
		text_elem.vertAlign = "middle";
		text_elem.x = 0;
		text_elem.y = start_y + spacing * text_num;
		text_elem.color = ( 1, 1, 1 );
		text_elem.foreground = true;
		text_elem.sort = 1;
		
		if ( fade_in_text_time > 0.0 )
		{
			text_elem.alpha = 0.0;
			text_elem FadeOverTime( fade_in_text_time );
			text_elem.alpha = 1.0;
		}
		else
		{
			text_elem.alpha = 1.0;
		}
		
		text_num++;
	}

	if ( fade_in_text_time > 0.0 )
	{
		wait fade_in_text_time;
	}
	
	wait time;
	
	if ( fade_out_text_time > 0.0 )
	{
		foreach( text_elem in text_elems )
		{
			text_elem FadeOverTime( fade_out_text_time );
			text_elem.alpha = 0.0;
		}
	
		wait fade_out_text_time;
	}
	
	if ( show_black_background )
	{
		if ( fade_out_bg_time > 0.0 )
		{
			background FadeOverTime( fade_out_bg_time );
			background.alpha = 0.0;
			wait fade_out_bg_time;
		}
		
		background Destroy();
	}
	
	foreach( text_elem in text_elems )
	{
		text_elem Destroy();
	}
}
#/
