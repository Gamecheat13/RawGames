#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       




	
 // 200 * 200
	
#precache( "client_fx", "weapon/fx_prox_grenade_scan_blue" );
#precache( "client_fx", "weapon/fx_prox_grenade_wrn_grn" );
#precache( "client_fx", "weapon/fx_prox_grenade_scan_orng" );
#precache( "client_fx", "weapon/fx_prox_grenade_wrn_red" );
#precache( "client_fx", "weapon/fx_prox_grenade_impact_player_spwner" );
	
#namespace proximity_grenade;

function init_shared()
{	
	clientfield::register( "toplayer", "tazered", 1, 1, "int", undefined, !true, !true );

	level._effect["prox_grenade_friendly_default"] = "weapon/fx_prox_grenade_scan_blue";
	level._effect["prox_grenade_friendly_warning"] = "weapon/fx_prox_grenade_wrn_grn";

	level._effect["prox_grenade_enemy_default"] = "weapon/fx_prox_grenade_scan_orng";
	level._effect["prox_grenade_enemy_warning"] = "weapon/fx_prox_grenade_wrn_red";

	level._effect["prox_grenade_player_shock"] = "weapon/fx_prox_grenade_impact_player_spwner";
	
	callback::add_weapon_type( "proximity_grenade", &proximity_spawned );
	callback::on_spawned( &on_player_spawned );
	
	level thread watchForProximityExplosion();
}

function on_player_spawned( localClientNum )
{
	player_view = getlocalplayer( localClientNum );

	if ( player_view == self )
	{
		// stop shock
		self shock_indicator_clear( player_view, localClientNum );		
	}
}

function proximity_spawned( localClientNum )
{	
	if ( self isGrenadeDud() ) 
		return; 

	self.equipmentFriendFX = level._effect["prox_grenade_friendly_default"];
	self.equipmentEnemyFX = level._effect["prox_grenade_enemy_default"];
	self.equipmentTagFX = "tag_fx";
	
	self thread weaponobjects::equipmentTeamObject( localClientNum );
}

//we use watchforproximityexplosion instead of updatePlayerTazered now
function updatePlayerTazered( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		localPlayer = GetLocalPlayer( localClientNum );	
		
		
		localPlayer thread taserHUDFX( localClientNum, localPlayer.origin );
	}
}

function shock_indicator_set( player, localClientNum, imagePos, textureName )
{
	controllerModel = GetUIModelForController( localClientNum );
	
	shockImageModel = CreateUIModel( controllerModel, imagePos );
	SetUIModelValue( shockImageModel, textureName );
	
}
function shock_indicator_clear( player, localClientNum )
{
	controllerModel = GetUIModelForController( localClientNum );
	stickyImageModel = CreateUIModel( controllerModel, "hudItems.shockImageBottom" );
	
	SetUIModelValue( stickyImageModel, "blacktransparent" );
	
	stickyImageModel1 = CreateUIModel( controllerModel, "hudItems.shockImageRight" );
	SetUIModelValue( stickyImageModel1, "blacktransparent" );
	
	stickyImageModel2 = CreateUIModel( controllerModel, "hudItems.shockImageLeft" );
	SetUIModelValue( stickyImageModel2, "blacktransparent" );
	
	stickyImageModel3 = CreateUIModel( controllerModel, "hudItems.shockImageTop" );
	SetUIModelValue( stickyImageModel3, "blacktransparent" );
}

function wait_tazered_or_time()
{
	self endon( "death" );
	 
	endTime = GetTime() + 500;
	
	while( self clientfield::get_to_player( "tazered" ) != 1 && endTime > GetTime() )
	{
		wait 0.05;
	}
}

function taserHUDFX( localClientNum, position ) // self == localPlayer
{
	self endon( "entityshutdown" );

	//No need to do anything if we're remote controlling a killstreak
	if( self IsRemoteControlling( localClientNum ) )
		return;
	
	// got to wait before checking clientfield::get_to_player( "tazered" )
	self wait_tazered_or_time();

	if ( self clientfield::get_to_player( "tazered" ) != 1 )
	{
		return;
	}

	{
		if ( self HasPerk(localClientNum, "specialty_proximityprotection" ) )
		{
			self thread reducedShock(localClientNum, position);
		}
		else
		{
			self thread flickerVisionSet( localClientNum, 0.03, (0.25 * 5), 0.0 );
			cycles = 3;			
			
			player = GetLocalPlayer( localClientNum );
			for( i=0; i<2; i++ )
			{
				zap_wait = 0.25;

				for ( j=0; j<cycles; j++ )
				{					
					if ( self clientfield::get_to_player( "tazered" ) == 1 )
					{											
						forwardVec = VectorNormalize( AnglesToForward( self.angles ) );
						rightVec = VectorNormalize( AnglesToRight( self.angles ) );
						explosionVec = VectorNormalize( position - self.origin );
					
						fDot = VectorDot( explosionVec, forwardVec );
						rDot = VectorDot( explosionVec, rightVec );

						if ( abs(fDot) > abs(rDot) )
						{
							if ( fDot > 0 )
							{
								shock_indicator_set( player, localClientNum, "hudItems.shockImageTop", "fullscreen_proximity_vertical"+j );
							}
							else
							{
								shock_indicator_set( player, localClientNum, "hudItems.shockImageBottom", "fullscreen_proximity_vertical"+j );
							}
						}
						else
						{
							if ( rDot > 0 )
							{
								shock_indicator_set( player, localClientNum, "hudItems.shockImageRight", "fullscreen_proximity_horizontal"+j );
							}
							else
							{
								shock_indicator_set( player, localClientNum, "hudItems.shockImageLeft", "fullscreen_proximity_horizontal"+j );
							}
						}

					}
					else
					{
						// stop shock
						self shock_indicator_clear( player, localClientNum );
						return;
					}

					wait zap_wait;
					//zap_wait /= 2;
				}

				wait .2;
				cycles--;
			}		
			
			// stop shock
			self shock_indicator_clear( player, localClientNum );
		}
	}
}

function reducedShock(localClientNum, position)
{
	self endon("entityshutdown");

	menuname = "fullscreen_proximity";
	
	self thread flickerVisionSet( localClientNum, .03, .15, 0.0 );
	
	//Eckert - Playing reduced shock sound
	self playsound (0, "wpn_taser_mine_tacmask");
	
	player = GetLocalPlayer( localClientNum );
	
	forwardVec = VectorNormalize( AnglesToForward( self.angles ) );
	rightVec = VectorNormalize( AnglesToRight( self.angles ) );
	explosionVec = VectorNormalize( position - self.origin );
	fDot = VectorDot( explosionVec, forwardVec );
	rDot = VectorDot( explosionVec, rightVec );

	if ( abs(fDot) > abs(rDot) )
	{
		if ( fDot > 0 )
		{
			shock_indicator_set( player, localClientNum, "hudItems.shockImageTop", "fullscreen_proximity_vertical0" );
		}
		else
		{
			shock_indicator_set( player, localClientNum, "hudItems.shockImageBottom", "fullscreen_proximity_vertical0" );
		}
	}
	else
	{
		if ( rDot > 0 )
		{
			shock_indicator_set( player, localClientNum, "hudItems.shockImageRight", "fullscreen_proximity_horizontal0" );
		}
		else
		{
			shock_indicator_set( player, localClientNum, "hudItems.shockImageLeft", "fullscreen_proximity_horizontal0" );
		}
	}
	
	wait(0.25); //wait enough for one loop of the shock flicker
	
	// stop shock
	self shock_indicator_clear( player, localClientNum );
}


function flickerVisionSet( localClientNum, period, duration_seconds, transition )
{
	self endon("entityshutdown");
	
	flicker_start_time = GetRealTime();
	saved_vision = GetVisionSetNaked( localClientNum );
	toggle = true;

	duration_ms = duration_seconds * 1000;
	wait .1;

	while( true )
	{
		if ( GetRealTime() > ( flicker_start_time + duration_ms ))
		{
			break;
		}
		
		if ( self clientfield::get_to_player( "tazered" ) != 1 )
		{
			break;			
		}

		if ( toggle )
		{
			visionsetnaked( localClientNum, "taser_mine_shock", transition );
		}
		else
		{
			visionsetnaked( localClientNum, saved_vision, transition );
		}
		toggle = !toggle;

		wait period;
	}

	visionSetNaked( localClientNum, saved_vision, transition );
}

function watchForProximityExplosion()
{
	if ( GetActiveLocalClients() > 1 )
		return;

	weapon_proximity = GetWeapon( "proximity_grenade" );

	while ( true )
	{
		level waittill( "explode", localClientNum, position, mod, weapon, owner_cent );
		
		if ( weapon.rootWeapon != weapon_proximity )
		{
			continue;
		}
		
		localPlayer = GetLocalPlayer( localClientNum );

		if ( ( !localPlayer util::is_player_view_linked_to_entity( localClientNum ) ) )
		{
			
			explosionRadius = weapon.explosionRadius;
				
			if ( DistanceSquared( localPlayer.origin, position ) < explosionRadius * explosionRadius )
			{
				if ( isdefined( owner_cent ) )
				{
					if ( ( owner_cent == localPlayer ) || !( owner_cent util::friend_not_foe( localClientNum, true ) ) )
					{
						localPlayer thread taserHUDFX( localClientNum, position );
					}
				}
			}
			
		}
	}
}
