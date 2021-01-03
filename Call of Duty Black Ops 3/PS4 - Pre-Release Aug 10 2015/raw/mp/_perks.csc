#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\util_shared;

                                                                                                                                                                                     	   	                                                                      	  	  	
                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\system_shared;

#namespace perks;

function autoexec __init__sytem__() {     system::register("perks",&__init__,undefined,undefined);    }










#precache( "client_fx", "player/fx_plyr_footstep_tracker_l" );
#precache( "client_fx", "player/fx_plyr_footstep_tracker_r" );
#precache( "client_fx", "player/fx_plyr_flying_tracker_l" );
#precache( "client_fx", "player/fx_plyr_flying_tracker_r" );
#precache( "client_fx", "player/fx_plyr_footstep_tracker_lf" );
#precache( "client_fx", "player/fx_plyr_footstep_tracker_rf" );
#precache( "client_fx", "player/fx_plyr_flying_tracker_lf" );
#precache( "client_fx", "player/fx_plyr_flying_tracker_rf" );


function __init__()
{
	clientfield::register( "allplayers", "flying", 1, 1, "int", &flying_callback, !true, true );
	
	callback::on_localclient_connect( &on_local_client_connect );
	callback::on_spawned( &on_player_spawned );
	
	// kill tracker FX when tracked player dies
	level.killTrackerFXEnable = true;
	level._monitor_tracker = &monitor_tracker_perk;
	
	level.sitrepscan1_enable 			= GetDvarInt( "scr_sitrepscan1_enable", 2 );
	level.sitrepscan1_setoutline 		= GetDvarInt( "scr_sitrepscan1_setoutline", 1 );
	level.sitrepscan1_setsolid 			= GetDvarInt( "scr_sitrepscan1_setsolid", 1 );
	level.sitrepscan1_setlinewidth 		= GetDvarInt( "scr_sitrepscan1_setlinewidth", 1 );
	level.sitrepscan1_setradius 		= GetDvarInt( "scr_sitrepscan1_setradius", 50000 );
	level.sitrepscan1_setfalloff 		= GetDvarFloat( "scr_sitrepscan1_setfalloff", .01 );
	level.sitrepscan1_setdesat	 		= GetDvarFloat( "scr_sitrepscan1_setdesat", .4 );
	
	level.sitrepscan2_enable 			= GetDvarInt( "scr_sitrepscan2_enable", 2 );
	level.sitrepscan2_setoutline 		= GetDvarInt( "scr_sitrepscan2_setoutline", 10 );
	level.sitrepscan2_setsolid 			= GetDvarInt( "scr_sitrepscan2_setsolid", 0 );
	level.sitrepscan2_setlinewidth 		= GetDvarInt( "scr_sitrepscan2_setlinewidth", 1 );
	level.sitrepscan2_setradius 		= GetDvarInt( "scr_sitrepscan2_setradius", 50000 );
	level.sitrepscan2_setfalloff 		= GetDvarFloat( "scr_sitrepscan2_setfalloff", .01 );
	level.sitrepscan2_setdesat 			= GetDvarFloat( "scr_sitrepscan2_setdesat", .4 );
	
	/#
	level thread updateDvars();
	#/
}

function updateSitrepScan()
{
	self endon ( "entityshutdown" );
	while(1)
	{
		self oed_sitrepscan_enable( level.sitrepscan1_enable );
		self oed_sitrepscan_setoutline( level.sitrepscan1_setoutline );
		self oed_sitrepscan_setsolid( level.sitrepscan1_setsolid );
		self oed_sitrepscan_setlinewidth( level.sitrepscan1_setlinewidth );
	    self oed_sitrepscan_setradius( level.sitrepscan1_setradius );
		self oed_sitrepscan_setfalloff( level.sitrepscan1_setfalloff );
		self oed_sitrepscan_setdesat( level.sitrepscan1_setdesat );
		
		self oed_sitrepscan_enable( level.sitrepscan2_enable, 1 );
		self oed_sitrepscan_setoutline( level.sitrepscan2_setoutline, 1 );
		self oed_sitrepscan_setsolid( level.sitrepscan2_setsolid, 1 );
		self oed_sitrepscan_setlinewidth( level.sitrepscan2_setlinewidth, 1 );
	    self oed_sitrepscan_setradius( level.sitrepscan2_setradius, 1 );
		self oed_sitrepscan_setfalloff( level.sitrepscan2_setfalloff, 1 );
		self oed_sitrepscan_setdesat( level.sitrepscan2_setdesat, 1 );
		wait(1.0);
	}
}

/#
function updateDvars()
{
	while(1)
	{
		level.sitrepscan1_enable 			= GetDvarInt( "scr_sitrepscan1_enable", level.sitrepscan1_enable );
		level.sitrepscan1_setoutline 		= GetDvarInt( "scr_sitrepscan1_setoutline", level.sitrepscan1_setoutline );
		level.sitrepscan1_setsolid 			= GetDvarInt( "scr_sitrepscan1_setsolid", level.sitrepscan1_setsolid );
		level.sitrepscan1_setlinewidth 		= GetDvarInt( "scr_sitrepscan1_setlinewidth", level.sitrepscan1_setlinewidth );
		level.sitrepscan1_setradius 		= GetDvarInt( "scr_sitrepscan1_setradius", level.sitrepscan1_setradius );
		level.sitrepscan1_setfalloff 		= GetDvarFloat( "scr_sitrepscan1_setfalloff", level.sitrepscan1_setfalloff );
		level.sitrepscan1_setdesat 			= GetDvarFloat( "scr_sitrepscan1_setdesat", level.sitrepscan1_setdesat );
		
		level.sitrepscan2_enable 			= GetDvarInt( "scr_sitrepscan2_enable", level.sitrepscan2_enable );
		level.sitrepscan2_setoutline 		= GetDvarInt( "scr_sitrepscan2_setoutline", level.sitrepscan2_setoutline );
		level.sitrepscan2_setsolid 			= GetDvarInt( "scr_sitrepscan2_setsolid", level.sitrepscan2_setsolid );
		level.sitrepscan2_setlinewidth 		= GetDvarInt( "scr_sitrepscan2_setlinewidth", level.sitrepscan2_setlinewidth );
		level.sitrepscan2_setradius 		= GetDvarInt( "scr_sitrepscan2_setradius", level.sitrepscan2_setradius );
		level.sitrepscan2_setfalloff 		= GetDvarFloat( "scr_sitrepscan2_setfalloff", level.sitrepscan2_setfalloff );
		level.sitrepscan2_setdesat 			= GetDvarFloat( "scr_sitrepscan2_setdesat", level.sitrepscan2_setdesat );
		
		level.friendlyContentOutlines		= GetDvarInt( "friendlyContentOutlines", level.friendlyContentOutlines );
		
		wait(1.0);
	}
}
#/

function flying_callback( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self.flying = newVal;
}

function on_local_client_connect( local_client_num )
{
	RegisterRewindFX( local_client_num, "player/fx_plyr_footstep_tracker_l" );
	RegisterRewindFX( local_client_num, "player/fx_plyr_footstep_tracker_r" );
	RegisterRewindFX( local_client_num, "player/fx_plyr_flying_tracker_l" );
	RegisterRewindFX( local_client_num, "player/fx_plyr_flying_tracker_r" );
	RegisterRewindFX( local_client_num, "player/fx_plyr_footstep_tracker_lf" );
	RegisterRewindFX( local_client_num, "player/fx_plyr_footstep_tracker_rf" );
	RegisterRewindFX( local_client_num, "player/fx_plyr_flying_tracker_lf" );
	RegisterRewindFX( local_client_num, "player/fx_plyr_flying_tracker_rf" );
}

function on_player_spawned( local_client_num )
{
	/#
		self thread watch_perks_change(local_client_num);
	#/
	self notify("perks_changed");
	self thread updateSitrepScan();
	/#
	self thread updateSitrepScan();
	#/
	self thread killTrackerFX_on_death( local_client_num );
	self thread monitor_tracker_perk( local_client_num );
	self thread monitor_tracker_existing_players( local_client_num );
	if ( self islocalplayer() )
	{
		self thread monitor_tracker_perk_killcam( local_client_num );
		self thread monitor_detectnearbyenemies( local_client_num );
	}
}

/#
	
function array_equal( &a, &b )
{
	if ( IsDefined(a) && IsDefined(b) && IsArray(a) && IsArray(b) && a.size==b.size )
	{
		for ( i=0; i<a.size; i++ )
		{
			if (!( a[i] === b[i] ))
				return false;
		}
		return true;
	}
	return false;
}
	
	
function watch_perks_change(local_client_num)
{
	self notify( "watch_perks_change" );
	self endon( "entityshutdown" );
	self endon( "watch_perks_change" );
	self endon( "death" );
	self endon( "disconnect" );
	self.last_perks = self GetPerks(local_client_num);
	while(IsDefined(self))
	{
		perks = self GetPerks(local_client_num);
		if ( !array_equal(perks,self.last_perks) )
		{
			self.last_perks = perks;
			self notify("perks_changed");
		}
		wait 1;		
	}
}
#/















	// keep the handle to the last 40 tracker fx
 // handle fx older than this are ignored

function get_players( local_client_num )
{
	players = [];
	entities = GetEntArray( local_client_num );
	if (IsDefined(entities))
	{
		foreach( ent in entities )
		{
			if ( ent IsPlayer() )
			{
				players[players.size] = ent;
			}
		}
	}
	return players;
}

function monitor_tracker_existing_players( local_client_num )
{
	localPlayer = GetLocalPlayer( local_client_num );
	
	if ( self == localPlayer )
	{
		players = GetPlayers( local_client_num );
		foreach( player in players )
		{
			if ( player != localPlayer )
			{
				player thread monitor_tracker_perk( local_client_num );
			}
		}
	}	
}

function monitor_tracker_perk_killcam( local_client_num )
{
	self notify( "monitor_tracker_perk_killcam" + local_client_num );
	self endon( "monitor_tracker_perk_killcam" + local_client_num );
	self endon( "entityshutdown" );	
	
	predictedLocalPlayer = getlocalplayer( local_client_num );
	if ( !isdefined( level.trackerSpecialtySelf ) )
	{
		level.trackerSpecialtySelf = [];

		level.trackerSpecialtyCounter = 0;
	}
	
	if ( !isdefined( level.trackerSpecialtySelf[local_client_num] ) )
	{
		level.trackerSpecialtySelf[local_client_num] = [];
	}
		
	if ( predictedLocalPlayer GetInKillcam( local_client_num ) )
	{
		nonPredictedLocalPlayer = GetNonPredictedLocalPlayer( local_client_num );
		if ( predictedLocalPlayer HasPerk( local_client_num, "specialty_tracker" ) )
		{
			serverTime = getServerTime( local_client_num );
			for(count = 0; count < level.trackerSpecialtySelf[local_client_num].size; count++ )
			{
				if ( level.trackerSpecialtySelf[local_client_num][count].time < serverTime && level.trackerSpecialtySelf[local_client_num][count].time > serverTime - 5000 )
				{
					positionAndRotationStruct = level.trackerSpecialtySelf[local_client_num][count];
					tracker_playFX(local_client_num, positionAndRotationStruct);
				}
			}
		}
	}
	else
	{
		for(;;)
		{
			wait 0.05;
			
			positionAndRotationStruct = self getTrackerFXPosition( local_client_num );
			if ( isdefined ( positionAndRotationStruct ) )
			{
				positionAndRotationStruct.time = getServerTime( local_client_num );
				
				level.trackerSpecialtySelf[local_client_num][level.trackerSpecialtyCounter] = positionAndRotationStruct;
				level.trackerSpecialtyCounter++;
				if ( level.trackerSpecialtyCounter > 20 )
				{
					level.trackerSpecialtyCounter = 0;
				}
			}
		}
	}
}

function monitor_tracker_perk( local_client_num )
{
	self notify( "monitor_tracker_perk" );
	self endon( "monitor_tracker_perk" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "entityshutdown" );	
	
	self.flying = false;
	self.tracker_flying = false;
	self.tracker_last_pos = self.origin;

	offset = ( 0,0,GetDvarFloat( "perk_tracker_fx_foot_height", 0 ) );
	dist2 = ( 32 * 32 );
	
	while(IsDefined(self))
	{
		wait 0.05;
		
		watcher = GetLocalPlayer( local_client_num );

		if ( self == watcher )
			return; // no need to monitor the watcher
	
		if ( IsDefined( watcher ) && watcher HasPerk( local_client_num, "specialty_tracker" ) )
		{
			friend = self isFriendly( local_client_num, true );
			
			camoOff = true;
			if( !isDefined( self._isClone ) || !self._isClone )
			{
				camo_val = self clientfield::get( "camo_shader" );
				if( camo_val != 0 )
				{
					camoOff = false;
				}
			}

			if ( !friend && IsAlive(self) && camoOff )
			{
				positionAndRotationStruct = self getTrackerFXPosition( local_client_num );
				if ( isdefined( positionAndRotationStruct ) )
				{
					self tracker_playFX(local_client_num, positionAndRotationStruct);
				}
			}
			else
			{
				self.tracker_flying = false;
			}
		}
	}
}

function tracker_playFX( local_client_num, positionAndRotationStruct )
{
	handle = playFX( local_client_num, positionAndRotationStruct.fx, positionAndRotationStruct.pos, positionAndRotationStruct.fwd, positionAndRotationStruct.up );		
	
	self killTrackerFX_track( local_client_num, handle );
}

function killTrackerFX_track( local_client_num, handle )
{
	if ( handle && isdefined( self.killTrackerFX ) )
	{
		serverTime = getServerTime( local_client_num );
		
		killFXStruct = SpawnStruct();
		killFXStruct.time = serverTime;
		killFXStruct.handle = handle;
		
		index = self.killTrackerFX.index;
		
		if ( index >= 40 )
		{
			index = 0;
		}
			
		self.killTrackerFX.array[index] = killFXStruct;
		self.killTrackerFX.index = index + 1;
	}
}

function killTrackerFX_on_death( local_client_num )
{
	self endon( "disconnect" );
	
	if ( !( isdefined( level.killTrackerFXEnable ) && level.killTrackerFXEnable ) )
	{
		return;
	}
	
	predictedLocalPlayer = getlocalplayer( local_client_num );
	
	if ( predictedLocalPlayer == self )
	{
		return;
	}
	
	if ( isdefined( self.killTrackerFX ) )
	{
		self.killTrackerFX.array = [];
		self.killTrackerFX.index = 0;
		self.killTrackerFX = undefined;
	}	
	
	killTrackerFX = SpawnStruct();
	killTrackerFX.array = [];
	killTrackerFX.index = 0;		
	
	self.killTrackerFX = killTrackerFX;
	
	self waittill( "entityshutdown" );
	
	serverTime = getServerTime( local_client_num );
	
	foreach( killFXStruct in killTrackerFX.array )
	{		
		if ( isdefined( killFXStruct ) && killFXStruct.time + 5000 > serverTime )
		{
			KillFX( local_client_num, killFXStruct.handle );
		}
	}
	
	killTrackerFX.array = [];
	killTrackerFX.index = 0;
	killTrackerFX = undefined;
}

function getTrackerFXPosition( local_client_num )
{
	positionAndRotation = undefined;
	player = self;
	if( ( isdefined( self._isClone ) && self._isClone ) )
	{
		player = self.owner;
	}
	playFastFX = player hasperk( local_client_num, "specialty_trackerjammer" );
	if ( ( isdefined( self.flying ) && self.flying ) )
	{
		offset = ( 0,0,GetDvarFloat( "perk_tracker_fx_fly_height", 0 ) );
		dist2 = ( 32 * 32 );
		if ( ( isdefined( self.trailRightFoot ) && self.trailRightFoot ) )
		{
			if ( playFastFX )
			{
				fx = "player/fx_plyr_flying_tracker_rf";
			}
			else
			{
				fx = "player/fx_plyr_flying_tracker_r";
			}
		}
		else 
		{
			if ( playFastFX )
			{
				fx = "player/fx_plyr_flying_tracker_lf";
			}
			else
			{
				fx = "player/fx_plyr_flying_tracker_l";
			}
		}
	}
	else
	{
		offset = ( 0,0,GetDvarFloat( "perk_tracker_fx_foot_height", 0 ) );
		dist2 = ( 32 * 32 );
		if ( ( isdefined( self.trailRightFoot ) && self.trailRightFoot ) )
		{
			if ( playFastFX )
			{
				fx = "player/fx_plyr_footstep_tracker_rf";
			}
			else
			{
				fx = "player/fx_plyr_footstep_tracker_r";
			}
		}
		else 
		{
			if ( playFastFX )
			{
				fx = "player/fx_plyr_footstep_tracker_lf";
			}
			else
			{
				fx = "player/fx_plyr_footstep_tracker_l";
			}
		}
	}

	pos = self.origin + offset;
	fwd = AnglesToForward( self.angles );
	right = AnglesToRight( self.angles );
	up = AnglesToUp( self.angles );

	vel = self getvelocity(); 
	if (LengthSquared(vel) > ( 1 * 1 ))
	{
		up = VectorCross(vel,right);
		if ( LengthSquared( up ) < 0.0001 )
		{
			up = VectorCross(fwd, vel);
		}
		fwd = vel;
	}
	
	if( self isplayer() && self isplayerwallrunning() )
	{
		if( self isplayerwallrunningright() )
		{
			up = VectorCross( up, fwd );
		}
		else
		{
			up = VectorCross( fwd, up );
		}
	}

	if ( !self.tracker_flying )
	{
		self.tracker_flying = true;
		self.tracker_last_pos = self.origin;
	}
	else
	{
		if ( DistanceSquared( self.tracker_last_pos, pos ) > dist2 )
		{
			positionAndRotation = SpawnStruct();
			positionAndRotation.fx = fx;
			positionAndRotation.pos = pos;
			positionAndRotation.fwd = fwd;
			positionAndRotation.up = up;
			
			self.tracker_last_pos = self.origin;
			
			if ( ( isdefined( self.trailRightFoot ) && self.trailRightFoot ) )
			{
				self.trailRightFoot = false;
			}
			else
			{
				self.trailRightFoot = true;
			}
		}
	}
	
	return positionAndRotation;
}









	
	






function monitor_detectnearbyenemies( local_client_num )
{
	self endon( "entityshutdown" );
	
	controllerModel = GetUIModelForController( local_client_num );
	sixthsenseModel = CreateUIModel( controllerModel, "hudItems.sixthsense" );
	
	enemyNearbyTime = 0.0;
	enemyLostTime = 0.0;
	previousEnemyDetectedBitField = 0;
	
	SetUIModelValue( sixthsenseModel, 0 );

	while(1) 
	{
		localPlayer = GetLocalPlayer( local_client_num );
		
		if ( !( localPlayer IsPlayer() ) ||
		    ( localPlayer HasPerk( local_client_num, "specialty_detectnearbyenemies" ) == false ) ||
			( localPlayer GetInKillcam( local_client_num ) == true || IsAlive( localPlayer ) == false ) )
		{
 			SetUIModelValue( sixthsenseModel, 0 );
 			previousEnemyDetectedBitField = 0;
 			self util::waittill_any( "death", "spawned", "perks_changed" );
 			continue;
		}
 		
		enemyNearbyFront = false;
		enemyNearbyBack = false;
		enemyNearbyLeft = false;
		enemyNearbyRight = false;
		enemyDetectedBitField = 0;
		
		team = localPlayer.team;
		innerDetect = getdvarint( "specialty_detectnearbyenemies_inner", 1 );
		outerDetect = getdvarint( "specialty_detectnearbyenemies_outer", 1 );
		
		localPlayerAnglesToForward = anglesToForward( localPlayer.Angles );
	
		players = getplayers( local_client_num );
		clones = getclones( local_client_num );
		sixthSenseEnts = arraycombine( players, clones, false, false );
		foreach( sixthSenseEnt in sixthSenseEnts )
		{
			if ( sixthSenseEnt isfriendly( local_client_num, true ) )
				continue;
			
			if( !isAlive( sixthSenseEnt ) )
				continue;
			
			distanceScalarNearSq = 1;
			distanceScalarFarSq = 1;
			
			player = sixthSenseEnt;
			if( ( isdefined( sixthSenseEnt._isClone ) && sixthSenseEnt._isClone ) )
			{
				player = sixthSenseEnt.owner;
			}
			
			if ( player isplayer() && player HasPerk( local_client_num, "specialty_sixthsensejammer" ) )
			{
				distanceScalarNearSq = GetDvarFloat( "specialty_sixthsensejammer_distance_near_scalar", 0.1 );
				distanceScalarFarSq = GetDvarFloat( "specialty_sixthsensejammer_distance_far_scalar", 0.1 );
			}
				
			if ( previousEnemyDetectedBitField == 0 ) 
			{
				distanceSq = 300 * 300 * distanceScalarFarSq;
			}
			else
			{
				distanceSq = 350 * 350 * distanceScalarFarSq;
			}
			
			distCurrentSq = DistanceSquared( sixthSenseEnt.origin, localPlayer.origin );
			if ( distCurrentSq < distanceSq ) 
			{
				if ( outerDetect ) 
				{
					distanceMask = 1;
				}
				else
				{
					distanceMask = 0;
				}
				
				if ( previousEnemyDetectedBitField > 16 )
				{
					distanceNearbyCheck = 350 * 350 * distanceScalarNearSq;
				}
				else
				{
					distanceNearbyCheck = 300 * 300 * distanceScalarNearSq;
				}
				
				if ( distCurrentSq < distanceNearbyCheck && innerDetect )
				{
					distanceMask = distanceMask | 16;
				}
				
				vector = sixthSenseEnt.origin - localPlayer.origin;
				vector = ( vector[0], vector[1], 0 );
				vectorFlat = vectorNormalize( vector );
				cosAngle = VectorDot( vectorFlat, localPlayerAnglesToForward );
				
				if ( cosAngle > 0.7071 )
				{
					enemyDetectedBitField = enemyDetectedBitField | ( ( 1 << 0 ) * distanceMask );
					
				}
				else if ( cosAngle < -0.7071 )
				{
					enemyDetectedBitField = enemyDetectedBitField | ( ( 1 << 1 ) * distanceMask );
				}
				else
				{
					localPlayerAnglesToRight = anglesToRight( localPlayer.Angles );
					cosAngle = VectorDot( vectorFlat, localPlayerAnglesToRight );
					if ( cosAngle < 0 )
					{
						enemyDetectedBitField = enemyDetectedBitField | ( ( 1 << 2 ) * distanceMask );
					}
					else
					{
						enemyDetectedBitField = enemyDetectedBitField | ( ( 1 << 3 ) * distanceMask );
					}
				}
			}
		}

		if ( enemyDetectedBitField )
		{
			enemyLostTime = 0;
			if ( previousEnemyDetectedBitField != enemyDetectedBitField && enemyNearbyTime >= 0.05 )
			{
				SetUIModelValue( sixthsenseModel, enemyDetectedBitField );
				enemyNearbyTime = 0;
				
				diff = enemyDetectedBitField ^ previousEnemyDetectedBitField;
				if ( diff & enemyDetectedBitField )
				{
					// SOUND DEPT
					// player has entered area
					self playsound (0, "uin_sixth_sense_ping_on");
				}
				if ( diff & previousEnemyDetectedBitField )
				{
					// SOUND DEPT
					// player has left area
					//self playsound (0, "uin_sixth_sense_off");
				}
				
				previousEnemyDetectedBitField = enemyDetectedBitField;
			}
			enemyNearbyTime += 0.05;
		}
		else
		{
			enemyNearbyTime = 0;
			if ( previousEnemyDetectedBitField != 0 && enemyLostTime >= 0.05 )
			{
				SetUIModelValue( sixthsenseModel, 0 );
				previousEnemyDetectedBitField = 0;
			}
			enemyLostTime += 0.05;
		}
		
		wait( 0.05 );
	}
	SetUIModelValue( sixthsenseModel, 0 );
}

