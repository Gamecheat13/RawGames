#include common_scripts\utility;
#include maps\mp\animscripts\shared;
#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\_utility;


main()
{
	debug_anim_print("zm_death::main()" );
	self SetAimAnimWeights( 0, 0 );

	self endon("killanimscript");
	
	if( IsDefined( self.deathFunction ) )
	{
		successful_death = self[[self.deathFunction]](); 

		if( !IsDefined( successful_death ) || successful_death )
		{
			return; 
		}
	}
	
	if ( isdefined( self.a.nodeath ) && ( self.a.nodeath == true ) )
	{
		assert( self.a.nodeath, "Nodeath needs to be set to true or undefined." );
		
		// allow death script to run for a bit so it doesn't turn to corpse and get deleted too soon during melee sequence
		wait 3;
		return;
	}

	self unlink();

	if ( isdefined( self.enemy ) && isdefined( self.enemy.syncedMeleeTarget ) && self.enemy.syncedMeleeTarget == self )
	{
		self.enemy.syncedMeleeTarget = undefined;
	}

	self thread do_gib(); 

	if ( isdefined( self.a.gib_ref ) && (self.a.gib_ref == "no_legs" || self.a.gib_ref == "right_leg" || self.a.gib_ref == "left_leg") )
	{
		self.has_legs = false;
	}

	if ( !isdefined( self.deathanim ) )
	{
		self.deathanim = "zm_death";
		self.deathanim_substate = undefined;
	}
	self.deathanim = append_missing_legs_suffix( self.deathanim );

	self animMode( "gravity" );
	self SetAnimStateFromASD( self.deathanim, self.deathanim_substate );

	if ( !self GetAnimHasNotetrackFromASD( "start_ragdoll" ) )
	{
		self thread waitForRagdoll( self GetAnimLengthFromASD() * 0.35 ); 
	}

	if ( isDefined( self.skip_death_notetracks ) && self.skip_death_notetracks )
	{
		self waittillmatch( "death_anim", "end" );
	}
	else
	{
		self maps\mp\animscripts\zm_shared::DoNoteTracks( "death_anim", self.handle_death_notetracks ); 
	}
}


waitForRagdoll( time )
{
	wait( time ); 

	do_ragdoll = true; 
	if( IsDefined( self.nodeathragdoll ) && self.nodeathragdoll )
	{
		do_ragdoll = false; 
	}

	if( IsDefined( self ) && do_ragdoll )
	{
		self StartRagDoll(); 
	}
}	


on_fire_timeout()
{
	self endon ("death");
	
	// about the length of the flame fx
	wait 12;

	if (IsDefined(self) && IsAlive(self))
	{
		self.is_on_fire = false;
		self notify ("stop_flame_damage");
	}
	
}


flame_death_fx()
{
	self endon( "death" );

	if (IsDefined(self.is_on_fire) && self.is_on_fire )
	{
		return;
	}
	
	self.is_on_fire = true;
	
	self thread on_fire_timeout();

	if( IsDefined( level._effect ) && IsDefined( level._effect["character_fire_death_torso"] ) )
	{
		if ( !self.isdog )
		{
			PlayFxOnTag( level._effect["character_fire_death_torso"], self, "J_SpineLower" ); 
		}
	}
	else
	{
/#
		println( "^3ANIMSCRIPT WARNING: You are missing level._effect[\"character_fire_death_torso\"], please set it in your levelname_fx.gsc. Use \"env/fire/fx_fire_player_torso\"" ); 
#/
	}

	if( IsDefined( level._effect ) && IsDefined( level._effect["character_fire_death_sm"] ) )
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
		if( !IsDefined( self.a.gib_ref ) || self.a.gib_ref != "no_legs" )
		{
			tagArray[2] = "J_Ankle_RI"; 
			tagArray[3] = "J_Ankle_LE"; 
		}
		tagArray = randomize_array( tagArray ); 

		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[0] ); 
		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[1] ); 
	}
	else
	{
/#
		println( "^3ANIMSCRIPT WARNING: You are missing level._effect[\"character_fire_death_sm\"], please set it in your levelname_fx.gsc. Use \"env/fire/fx_fire_player_sm\"" ); 
#/
	}	
}


// MikeD( 9/30/2007 ): Taken from maps\_utility "array_randomize:, for some reason maps\_utility is included in a animscript
// somewhere, but I can't call it within in this... So I made a new one.
randomize_array( array )
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

get_tag_for_damage_location()
{
	tag = "J_SpineLower"; 

	if( self.damagelocation == "helmet" )
	{
		tag = "j_head"; 
	}
	else if( self.damagelocation == "head" )
	{
		tag = "j_head"; 
	}
	else if( self.damagelocation == "neck" )
	{
		tag = "j_neck"; 
	}
	else if( self.damagelocation == "torso_upper" )
	{
		tag = "j_spineupper"; 
	}
	else if( self.damagelocation == "torso_lower" )
	{
		tag = "j_spinelower"; 
	}
	else if( self.damagelocation == "right_arm_upper" )
	{
		tag = "j_elbow_ri"; 
	}
	else if( self.damagelocation == "left_arm_upper" )
	{
		tag = "j_elbow_le"; 
	}
	else if( self.damagelocation == "right_arm_lower" )
	{
		tag = "j_wrist_ri"; 
	}
	else if( self.damagelocation == "left_arm_lower" )
	{
		tag = "j_wrist_le"; 
	}

	return tag; 
}


set_last_gib_time()
{
	anim notify( "stop_last_gib_time" ); 
	anim endon( "stop_last_gib_time" ); 

	wait( 0.05 ); 
	anim.lastGibTime 	 = GetTime(); 
	anim.totalGibs		 = RandomIntRange( anim.minGibs, anim.maxGibs ); 
}

get_gib_ref( direction )
{
	// If already set, then use it. Useful for canned gib deaths.
	if( IsDefined( self.a.gib_ref ) )
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


get_random( array )
{
	return array[RandomInt( array.size )]; 
}


do_gib()
{
	if( !is_mature() )
	{
		return; 
	}

	if( is_german_build() )  //germans cannot gib;  Japanese can gib in zombiemode which is why language specific check is here.
	{
		return; 
	}

	if( !IsDefined( self.a.gib_ref ) )
	{
		return; 
	}

	if (IsDefined(self.is_on_fire) && self.is_on_fire)
	{
		return;
	}

	// CODER_MOD: Austin( 7/21/08 ): added to prevent zombies from gibbing more than once
	if( self is_zombie_gibbed() )
	{
		return; 
	}

	self set_zombie_gibbed(); 

	gib_ref = self.a.gib_ref; 

	limb_data = get_limb_data( gib_ref ); 

	if( !IsDefined( limb_data ) )
	{
/#
		println( "^3animscripts\zm_death.gsc - limb_data is not setup for gib_ref on model: " + self.model + " and gib_ref of: " + self.a.gib_ref ); 
#/

		return; 
	}

	self thread throw_gib( limb_data["spawn_tags_array"] ); 

	// we can't swap the torso on the head gibs, since they could already be gibbed, instead we detach the head
	// and attach torsoDmg5, which is just a small neck nub to fill the neckhole
	if ( gib_ref == "head" )
	{
		size = self GetAttachSize(); 
		for( i = 0; i < size; i++ )
		{
			model = self GetAttachModelName( i ); 
			if( IsSubStr( model, "head" ) )
			{
				// SRS 9/2/2008: wet em up
//				self thread headshot_blood_fx();
				if(isdefined(self.hatmodel))
				{
					self detach( self.hatModel, "" ); 
				}

//				self play_sound_on_ent( "zombie_head_gib" );

				self Detach( model, "" ); 
				if ( isDefined(self.torsoDmg5) )
				{
					self Attach( self.torsoDmg5, "", true ); 
				}
				break; 
			}
		}
	}
	else
	{
		// Set the upperbody model
		self SetModel( limb_data["body_model"] ); 

		// Attach the legs
		self Attach( limb_data["legs_model"] ); 
	}
}

precache_gib_fx()
{
	anim._effect["animscript_gib_fx"] 		 = LoadFx( "weapon/bullet/fx_flesh_gib_fatal_01" ); 
	anim._effect["animscript_gibtrail_fx"] 	 = LoadFx( "trail/fx_trail_blood_streak" ); 
	
	// Not gib; split out into another function before this gets out of hand.
	anim._effect["death_neckgrab_spurt"] = LoadFx( "impacts/fx_flesh_hit_neck_fatal" ); 
}

get_limb_data( gib_ref )
{
	temp_array = []; 

// Right arm is getting blown off! /////////////////////////////////////////////////////	
	if( "right_arm" == gib_ref && IsDefined( self.torsoDmg2 ) && IsDefined( self.legDmg1 ) && IsDefined( self.gibSpawn1 ) && IsDefined( self.gibSpawnTag1 ) )
	{
		temp_array["right_arm"]["body_model"] 		 = self.torsoDmg2; 
		temp_array["right_arm"]["legs_model"] 		 = self.legDmg1; 

		temp_array["right_arm"]["spawn_tags_array"] = [];
		temp_array["right_arm"]["spawn_tags_array"][0] = level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM;
	}

// Left arm is getting blown off! //////////////////////////////////////////////////////	
	if( "left_arm" == gib_ref && IsDefined( self.torsoDmg3 ) && IsDefined( self.legDmg1 ) && IsDefined( self.gibSpawn2 ) && IsDefined( self.gibSpawnTag2 ) )
	{
		temp_array["left_arm"]["body_model"] 		 = self.torsoDmg3; 
		temp_array["left_arm"]["legs_model"] 		 = self.legDmg1; 

		temp_array["left_arm"]["spawn_tags_array"] = [];
		temp_array["left_arm"]["spawn_tags_array"][0] = level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM;
	}

// Right leg is getting blown off! ////////////////////////////////////////////////////
	if( "right_leg" == gib_ref && IsDefined( self.torsoDmg1 ) && IsDefined( self.legDmg2 ) && IsDefined( self.gibSpawn3 ) && IsDefined( self.gibSpawnTag3 ) )
	{
		temp_array["right_leg"]["body_model"] 		 = self.torsoDmg1; 
		temp_array["right_leg"]["legs_model"] 		 = self.legDmg2; 

		temp_array["right_leg"]["spawn_tags_array"] = [];
		temp_array["right_leg"]["spawn_tags_array"][0] = level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG;
	}

// Left leg is getting blown off! /////////////////////////////////////////////////////
	if( "left_leg" == gib_ref && IsDefined( self.torsoDmg1 ) && IsDefined( self.legDmg3 ) && IsDefined( self.gibSpawn4 ) && IsDefined( self.gibSpawnTag4 ) )
	{
		temp_array["left_leg"]["body_model"] 		 = self.torsoDmg1; 
		temp_array["left_leg"]["legs_model"] 		 = self.legDmg3; 

		temp_array["left_leg"]["spawn_tags_array"] = [];
		temp_array["left_leg"]["spawn_tags_array"][0] = level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG;
	}

// No legs! ///////////////////////////////////////////////////////////////////////////
	if( "no_legs" == gib_ref && IsDefined( self.torsoDmg1 ) && IsDefined( self.legDmg4 ) && IsDefined( self.gibSpawn4 ) && IsDefined( self.gibSpawn3 ) && IsDefined( self.gibSpawnTag3 ) && IsDefined( self.gibSpawnTag4 ) )
	{
		temp_array["no_legs"]["body_model"] 		 = self.torsoDmg1; 
		temp_array["no_legs"]["legs_model"] 		 = self.legDmg4; 

		temp_array["no_legs"]["spawn_tags_array"] = [];
		temp_array["no_legs"]["spawn_tags_array"][0] = level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG;
		temp_array["no_legs"]["spawn_tags_array"][1] = level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG;
	}

// Guts! //////////////////////////////////////////////////////////////////////////////
	if( "guts" == gib_ref && IsDefined( self.torsoDmg4 ) && IsDefined( self.legDmg1 ) )
	{
		temp_array["guts"]["body_model"] 			 = self.torsoDmg4; 
		temp_array["guts"]["legs_model"] 			 = self.legDmg1; 

		temp_array["guts"]["spawn_tags_array"] = [];
		temp_array["guts"]["spawn_tags_array"][0] = level._ZOMBIE_GIB_PIECE_INDEX_GUTS;

		// our guts torso is missing left arm
		if ( IsDefined( self.gibSpawn2 ) && IsDefined( self.gibSpawnTag2 ) )
		{
			temp_array["guts"]["spawn_tags_array"][1] = level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM;
		}
	}

// Head! //////////////////////////////////////////////////////////////////////////////
	if( "head" == gib_ref && IsDefined( self.torsoDmg5 ) && IsDefined( self.legDmg1 ) )
	{
		temp_array["head"]["body_model"] 			 = self.torsoDmg5; 
		temp_array["head"]["legs_model"] 			 = self.legDmg1; 

		temp_array["head"]["spawn_tags_array"] = [];
		temp_array["head"]["spawn_tags_array"][0] = level._ZOMBIE_GIB_PIECE_INDEX_HEAD;
	}

	if( IsDefined( temp_array[gib_ref] ) )
	{
		return temp_array[gib_ref]; 
	}
	else
	{
		return undefined; 
	}
}

throw_gib( limb_tags_array )
{
	if(IsDefined(limb_tags_array))
	{
		if(IsDefined(self.launch_gib_up))
		{
			self gib("up", limb_tags_array );			
		}
		else
		{
			self gib("normal", limb_tags_array );
		}
	}
}
