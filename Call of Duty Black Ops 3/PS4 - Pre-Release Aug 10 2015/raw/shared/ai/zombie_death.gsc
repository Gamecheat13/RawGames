#using scripts\codescripts\struct;
#using scripts\shared\util_shared;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\systems\gib;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

//#precache( "fx", "zombie/fx_blood_torso_explo_zmb" );
//#precache( "fx", "_t6/trail/fx_trail_blood_streak" );
//#precache( "fx", "_t6/impacts/fx_flesh_hit_neck_fatal" );

function on_fire_timeout()
{
	self endon ("death");
	
	// about the length of the flame fx
	wait 12;

	if (isdefined(self) && IsAlive(self))
	{
		self.is_on_fire = false;
		self notify ("stop_flame_damage");
	}
	
}


function flame_death_fx()
{
	self endon( "death" );

	if (isdefined(self.is_on_fire) && self.is_on_fire )
	{
		return;
	}
	
	self.is_on_fire = true;
	
	self thread on_fire_timeout();

	if( isdefined( level._effect ) && isdefined( level._effect["character_fire_death_torso"] ) )
	{
		fire_tag = "j_spinelower";
		
		if( !isDefined( self GetTagOrigin( fire_tag)))  //allows effect to play on parasite and insanity elementals
		{
			fire_tag = "tag_origin";
		}
		
		if ( !isDefined( self.isdog) || !self.isdog )
		{
			PlayFxOnTag( level._effect["character_fire_death_torso"], self, fire_tag );
		}
	}
	else
	{
/#
		println( "^3ANIMSCRIPT WARNING: You are missing level._effect[\"character_fire_death_torso\"], please set it in your levelname_fx.gsc. Use \"env/fire/fx_fire_player_torso\"" ); 
#/
	}

	if( isdefined( level._effect ) && isdefined( level._effect["character_fire_death_sm"] ) )
	{
		if( self.archetype !== "parasite" && self.archetype !== "raps" )
		{
			wait 1;
	
			tagArray = []; 
			tagArray[0] = "J_Elbow_LE"; 
			tagArray[1] = "J_Elbow_RI"; 
			tagArray[2] = "J_Knee_RI"; 
			tagArray[3] = "J_Knee_LE"; 
			tagArray = randomize_array( tagArray ); 
	
			PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[0] ); 
	
			wait 1;
	
			tagArray[0] = "J_Wrist_RI"; 
			tagArray[1] = "J_Wrist_LE"; 
			if( !isdefined( self.a.gib_ref ) || self.a.gib_ref != "no_legs" )
			{
				tagArray[2] = "J_Ankle_RI"; 
				tagArray[3] = "J_Ankle_LE"; 
			}
			tagArray = randomize_array( tagArray ); 
	
			PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[0] ); 
			PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[1] );
		}
	}
	else
	{
/#
		println( "^3ANIMSCRIPT WARNING: You are missing level._effect[\"character_fire_death_sm\"], please set it in your levelname_fx.gsc. Use \"env/fire/fx_fire_zombie_md\"" ); 
#/
	}	
}


// MikeD( 9/30/2007 ): Taken from maps\_utility "array_randomize:, for some reason maps\_utility is included in a animscript
// somewhere, but I can't call it within in this... So I made a new one.
function randomize_array( array )
{
    for( i = 0; i < array.size; i++ )
    {
        j = RandomInt( array.size ); 
        temp = array[i]; 
        array[i] = array[j]; 
        array[j] = temp; 
    }
    return array; 
}

function set_last_gib_time()
{
	anim notify( "stop_last_gib_time" ); 
	anim endon( "stop_last_gib_time" ); 

	{wait(.05);}; 
	anim.lastGibTime 	 = GetTime(); 
	anim.totalGibs		 = RandomIntRange( anim.minGibs, anim.maxGibs ); 
}

function get_gib_ref( direction )
{
	// If already set, then use it. Useful for canned gib deaths.
	if( isdefined( self.a.gib_ref ) )
	{
		return; 
	}

	// Don't gib if we haven't taken enough damage by the explosive
	// Grenade damage usually range from 160 - 250, so we go above teh minimum
	// so if the splash damage is near it's lowest, don't gib.
	if( self.damageTaken < 165 )
	{
		return; 
	}

	if( GetTime() > anim.lastGibTime + anim.gibDelay && anim.totalGibs > 0 )
	{
		anim.totalGibs--; 

		// MikeD( 5/5/2008 ): Allows multiple guys to GIB at once.
		anim thread set_last_gib_time(); 

		refs = []; 
		switch( direction )
		{
			case "right":
				refs[refs.size] = "left_arm"; 
				refs[refs.size] = "left_leg"; 

				gib_ref = get_random( refs ); 				
				break; 

			case "left":
				refs[refs.size] = "right_arm"; 
				refs[refs.size] = "right_leg"; 

				gib_ref = get_random( refs ); 				
				break; 

			case "forward":
				refs[refs.size] = "right_arm"; 
				refs[refs.size] = "left_arm"; 
				refs[refs.size] = "right_leg"; 
				refs[refs.size] = "left_leg"; 
				refs[refs.size] = "guts"; 
				refs[refs.size] = "no_legs"; 

				gib_ref = get_random( refs ); 				
				break; 

			case "back":
				refs[refs.size] = "right_arm"; 
				refs[refs.size] = "left_arm"; 
				refs[refs.size] = "right_leg"; 
				refs[refs.size] = "left_leg"; 
				refs[refs.size] = "no_legs"; 

				gib_ref = get_random( refs ); 				
				break; 

			default: // "up"
				refs[refs.size] = "right_arm"; 
				refs[refs.size] = "left_arm"; 
				refs[refs.size] = "right_leg"; 
				refs[refs.size] = "left_leg"; 
				refs[refs.size] = "no_legs"; 
				refs[refs.size] = "guts"; 

				gib_ref = get_random( refs ); 
				break; 
		}


		self.a.gib_ref = gib_ref; 
	}
	else
	{
		self.a.gib_ref = undefined; 
	}
}


function get_random( array )
{
	return array[RandomInt( array.size )]; 
}


function do_gib()
{
	if( !util::is_mature() )
	{
		return; 
	}

	if( util::is_german_build() )  //germans cannot gib;  Japanese can gib in zombiemode which is why language specific check is here.
	{
		return; 
	}

	if( !isdefined( self.a.gib_ref ) )
	{
		return; 
	}

	if (isdefined(self.is_on_fire) && self.is_on_fire)
	{
		return;
	}

	switch ( self.a.gib_ref )
	{
		case "right_arm":
			GibServerUtils::GibRightArm( self );
			break;
		case "left_arm":
			GibServerUtils::GibLeftArm( self );
			break;
		case "right_leg":
			GibServerUtils::GibRightLeg( self );
			break;
		case "left_leg":
			GibServerUtils::GibLeftLeg( self );
			break;
		case "no_legs":
			GibServerUtils::GibLegs( self );
			break;
		case "head":
			GibServerUtils::GibHead( self );
			break;
		case "guts":
			// TODO(David Young 9-17-14): Currently no characters have gut torso models, unsupported.
			break;
		default:
			AssertMsg( "Unknown gib_ref \"" + self.a.gib_ref + "\", unable to gib entity." );
			break;
	}
}

function precache_gib_fx()
{
	anim._effect["animscript_gib_fx"] 		 = "zombie/fx_blood_torso_explo_zmb"; 
	anim._effect["animscript_gibtrail_fx"] 	 = "_t6/trail/fx_trail_blood_streak"; 
	
	// Not gib; split out into another function before this gets out of hand.
	anim._effect["death_neckgrab_spurt"] = "_t6/impacts/fx_flesh_hit_neck_fatal"; 
}
