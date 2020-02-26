#include animscripts\anims;
#include animscripts\shared;
#include animscripts\utility;
#include common_scripts\utility;

#using_animtree ("generic_human");

blindfire()
{
	// check for anim
	if ( !animArrayAnyExist("blind_fire") )
	{
		/#self animscripts\debug::debugPopState( undefined, "no blind fire anim" );#/
		return false;
	}
	
	// create a list of possible blindfire modes
	blindFireModes = [];
	blindFireModes[blindFireModes.size] = "blind_fire";
	
	// handle over for cover left and right
	if( self.a.pose == "crouch" && ( self.a.script == "cover_left" || self.a.script == "cover_right" ) && !AIHasOnlyPistol() )
	{
		modes = self.coverNode GetValidCoverPeekOuts();
		
		if( is_in_array( modes, "over" ) && animArrayAnyExist("blind_over") )
			blindFireModes[blindFireModes.size] = "blind_over";
	}
		
	// select a blindfire mode
	blindFireMode = blindFireModes[RandomIntRange( 0, blindFireModes.size )];

	// check for vertical angle
	if( self.a.script == "cover_stand" || self.a.script == "cover_crouch" ) 
	{
		pitch = getShootPosPitch( self.coverNode.origin + getNodeOffset( self.coverNode ) );

		if( pitch > 10 )
		{
			/#self animscripts\debug::debugPopState( undefined, "can't blind fire at a target below" );#/

			return false;
		}
	}

	self AnimMode ( "zonly_physics" );
	self.keepClaimedNodeIfValid = true;

	blindfireAnim = animArrayPickRandom( blindFireMode );
	self setFlaggedAnimKnobAllRestart(blindFireMode, blindfireAnim, %body, 1, 0.2, 1);

	// SUMEET_TODO - Blindfire aiming additives for Pistol AI
	if( canUseBlindAiming( blindFireMode ) && !AIHasOnlyPistol() )
	{
		self thread startBlindAiming( blindfireAnim, blindFireMode );
		self thread stopBlindAiming( blindfireAnim, blindFireMode );
	}

	self maps\_dds::dds_notify( "react_cover", ( self.team == "allies" ) );	
	
	self animscripts\shared::DoNoteTracks(blindFireMode);
	self.keepClaimedNodeIfValid = false;
	
	waittillframeend;

	return true;
}

canUseBlindAiming( type )
{
	/#
		if( GetDvarint( "noBlindAim" ) == 1 )
			return false;
	#/

	return animArrayAnyExist( type + "_add_aim_up" );
}

startBlindAiming( aimAnim, type )
{
	self animscripts\shared::setAimingAnims( %blind_aim_2, %blind_aim_4, %blind_aim_6, %blind_aim_8 );
	self animscripts\shared::setAnimAimWeight( 1, 0 );

	if( AnimHasNotetrack( aimAnim, "start_aim" ) )
		self waittillmatch( type, "start_aim" );	
	
	playAdditiveAimingAnims( type + "_add", 0.2 );

	self animscripts\shared::trackLoopStart();
}

// AI_TODO: cache this info
getAnimAimLimit( aimAnim, defaultLimit )
{
	if( !IsDefined(defaultLimit) )
		defaultLimit = 20;

	aimLimit = defaultLimit;

	notetracks = GetNotetracksInDelta( aimAnim, 0, 1 );
	foreach( note in notetracks )
	{
		assert( IsDefined(note[1]) );

		if( IsSubStr(note[1], "aim_limit" ) )
		{
			tokens = strtok( note[1], " " );

			if( IsDefined(tokens) && tokens.size > 1 )
			{
				aimLimit = tokens[1];
				break;
			}
		}
	}

	return int(aimLimit);
}

stopBlindAiming( fireAnim, animName )
{
	self endon("death");
	self endon("killanimscript");

	if( AnimHasNotetrack( fireAnim, "stop_aim" ) )
		self waittillmatch( animName, "stop_aim" );
	else
		self waittillmatch( animName, "end"	);

	self animscripts\shared::stopTracking();
	self animscripts\shared::setAnimAimWeight( 0, 0 );
	self ClearAnim( %blind_aim_2, 0.2 );
	self ClearAnim( %blind_aim_4, 0.2 );
	self ClearAnim( %blind_aim_6, 0.2 );
	self ClearAnim( %blind_aim_8, 0.2 );
}

canBlindfire()
{
	if ( self.a.atConcealmentNode )
	{
		return false;
	}

	if ( !animscripts\weaponList::usingAutomaticWeapon() && !usingPistol() )
	{
		return false;
	}

	if ( weaponClass( self.weapon ) == "mg" )
	{
		return false;
	}

	if (IsDefined(self.disable_blindfire) && self.disable_blindfire == true)
	{
		return false;
	}

	if ( IsDefined( self.node ) && IsDefined(self.node.script_dontblindfire) ) 
	{
		return false;
	}

	return true;
}

canRambo()
{
	ramboAnimsExist = false;

	if( self.coverNode.type == "Cover Crouch" || self.coverNode.type == "Cover Stand" )
		ramboAnimsExist = animArrayAnyExist("rambo");
	else if( self.coverNode.type == "Cover Left" || self.coverNode.type == "Cover Right" )
		ramboAnimsExist = animArrayAnyExist("rambo") && animArrayAnyExist("rambo_45");
	
	/#
	if( shouldForceBehavior("rambo") )
		return ramboAnimsExist;
	#/

	if( self.team == "allies" )
		return false;

	// check if cover/level allowes rambo
	if( IsDefined( self.coverNode.script_norambo ) && self.coverNode.script_norambo || IsDefined( level.norambo ) )
		return false;
	
	if( !animscripts\weaponList::usingAutomaticWeapon() )
		return false;

	if( ramboAnimsExist )
		return true;

	return false;	
}

/#
debugRamboOutPosition( ramboOutPos ) // self = ai
{
	if( GetDvar( "ai_rambo") != "1" )
		return;

	self endon("death");

	for ( i = 0;i< 30*20 ;i++ )
	{
		RecordLine( self.origin, ramboOutPos, ( 1,1,1 ), "Animscript", self );
	}
}
#/

canSwitchSides()
{
	if ( !self.a.atPillarNode )
	{
		return false;
	}

	if( GetTime() < self.a.nextAllowedSwitchSidesTime )
	{
		return false;
	}

	// no pillar anims for pistol so cheat by using cover left and right
	if( self usingPistol() )
	{
		return false;
	}

	return true;
}

// use exposed turns to rotate into correct facing direction at node
turnToMatchNodeDirection( nodeAngleOffset )
{
	if( IsDefined( self.node ) )
	{
		node = self.node;

		absRelYaw = abs( AngleClamp180( self.angles[1] - ( node.angles[1] + nodeAngleOffset ) ) );

		if( self.a.pose == "stand" && node getHighestNodeStance() != "stand" )
		{
			if( absRelYaw > 45 && absRelYaw < 90 )
				self OrientMode( "face angle", self.angles[1] );
			else
				self OrientMode( "face current" );

			standToCrouchAnim = animArray("stand_2_crouch", "combat");

			const rate = 1.5;
			noteTime = getNotetrackTimes( standToCrouchAnim, "anim_pose = \"crouch\"" )[0];
			noteTime = min( 1, noteTime * 1.1 );
			time = noteTime * getAnimLength( standToCrouchAnim ) / rate;

			self setflaggedanimknoballrestart( "crouchanim", standToCrouchAnim, %body, 1, .2, rate );
			self DoNoteTracksForTime( time, "crouchanim" );
			self clearanim( %body, 0.2 );
		}

		self OrientMode( "face angle", self.angles[1] );

		relYaw = AngleClamp180( self.angles[1] - ( node.angles[1] + nodeAngleOffset ) );

		if( abs( relYaw ) > 45 )
		{
			self.turnThreshold = 45;
			self.turnToMatchNode = true;
			animscripts\combat::TurnToFaceRelativeYaw( relYaw );
			self.turnToMatchNode = false;
		}
	}
}

getRandomCoverMode( modes )
{
	if ( modes.size == 0 )
		return undefined;
	if ( modes.size == 1 )
		return modes[0];

	// 20% chance of attempting to repeat same corner mode
	if ( IsDefined( self.a.prevAttack ) && RandomInt( 100 ) > 20 )
	{
		foreach ( i, mode in modes )
		{
			if ( mode == self.a.prevAttack )
			{
				if ( i < modes.size - 1 )
					modes[ i ] = modes[ modes.size - 1 ];

				modes[ modes.size - 1 ] = undefined;
				break;
			}
		}
	}

	return modes[ RandomInt( modes.size ) ];
}

playAdditiveAimingAnims( prefix, transTime, defaultAimLimit )
{
	aimUpAnim	 = animArray( prefix + "_aim_up"   );
	aimDownAnim  = animArray( prefix + "_aim_down" );
	aimLeftAnim  = animArray( prefix + "_aim_left" );
	aimRightAnim = animArray( prefix + "_aim_right");

	self.rightAimLimit	= getAnimAimLimit( aimRightAnim, defaultAimLimit );
	self.leftAimLimit	= getAnimAimLimit( aimLeftAnim, defaultAimLimit ) * -1;
	self.upAimLimit		= getAnimAimLimit( aimUpAnim, defaultAimLimit );
	self.downAimLimit	= getAnimAimLimit( aimDownAnim, defaultAimLimit ) * -1;

	self SetAnimKnobLimited( aimUpAnim,	   1, transTime );
	self SetAnimKnobLimited( aimDownAnim,  1, transTime );
	self SetAnimKnobLimited( aimLeftAnim,  1, transTime );
	self SetAnimKnobLimited( aimRightAnim, 1, transTime );
}

getShootPosPitch( fromPos )
{
	shootPos = getEnemyEyePos();
	return AngleClamp180( VectorToAngles(shootPos - fromPos)[0] );
}