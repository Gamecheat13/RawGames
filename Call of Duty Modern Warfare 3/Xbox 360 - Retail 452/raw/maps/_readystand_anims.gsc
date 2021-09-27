#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;

#using_animtree( "generic_human" );
initReadyStand()
{
	anim.readystand_anims_inited = true;

	level.scr_anim[ "generic" ][ "readystand_idle" ][0]			= %readystand_idle;
	level.scr_anim[ "generic" ][ "readystand_idle" ][1]			= %readystand_idle_twitch_1;
	level.scr_anim[ "generic" ][ "readystand_idle" ][2]			= %readystand_idle_twitch_2;
	level.scr_anim[ "generic" ][ "readystand_idle" ][3]			= %readystand_idle_twitch_3;
	level.scr_anim[ "generic" ][ "readystand_idle" ][4]			= %readystand_idle_twitch_4;

	level.scr_anim[ "generic" ][ "readystand_trans_2_cqb_1" ]			= %readystand_trans_2_cqb_1;
	level.scr_anim[ "generic" ][ "readystand_trans_2_cqb_2" ]			= %readystand_trans_2_cqb_2;
	level.scr_anim[ "generic" ][ "readystand_trans_2_cqb_3" ]			= %readystand_trans_2_cqb_3;
	level.scr_anim[ "generic" ][ "readystand_trans_2_cqb_4" ]			= %readystand_trans_2_cqb_4;
	level.scr_anim[ "generic" ][ "readystand_trans_2_cqb_6" ]			= %readystand_trans_2_cqb_6;
	level.scr_anim[ "generic" ][ "readystand_trans_2_cqb_7" ]			= %readystand_trans_2_cqb_7;
	level.scr_anim[ "generic" ][ "readystand_trans_2_cqb_8" ]			= %readystand_trans_2_cqb_8;
	level.scr_anim[ "generic" ][ "readystand_trans_2_cqb_9" ]			= %readystand_trans_2_cqb_9;

	level.scr_anim[ "generic" ][ "readystand_trans_2_run_1" ]			= %readystand_trans_2_run_1;
	level.scr_anim[ "generic" ][ "readystand_trans_2_run_2" ]			= %readystand_trans_2_run_2;
	level.scr_anim[ "generic" ][ "readystand_trans_2_run_3" ]			= %readystand_trans_2_run_3;
	level.scr_anim[ "generic" ][ "readystand_trans_2_run_4" ]			= %readystand_trans_2_run_4;
	level.scr_anim[ "generic" ][ "readystand_trans_2_run_6" ]			= %readystand_trans_2_run_6;
	level.scr_anim[ "generic" ][ "readystand_trans_2_run_7" ]			= %readystand_trans_2_run_7;
	level.scr_anim[ "generic" ][ "readystand_trans_2_run_8" ]			= %readystand_trans_2_run_8;
	level.scr_anim[ "generic" ][ "readystand_trans_2_run_9" ]			= %readystand_trans_2_run_9;	


	anim.readyAnimArray		[ "stand" ][ 0 ][ 0 ] = %readystand_idle;
	anim.readyAnimArray		[ "stand" ][ 0 ][ 1 ] = %readystand_idle_twitch_1;
	anim.readyAnimArray		[ "stand" ][ 0 ][ 2 ] = %readystand_idle_twitch_2;
	anim.readyAnimArray		[ "stand" ][ 0 ][ 3 ] = %readystand_idle_twitch_3;
	anim.readyAnimArray		[ "stand" ][ 0 ][ 4 ] = %readystand_idle_twitch_4;
	anim.readyAnimWeights	[ "stand" ][ 0 ][ 0 ] = 10;
	anim.readyAnimWeights	[ "stand" ][ 0 ][ 1 ] = 3;
	anim.readyAnimWeights	[ "stand" ][ 0 ][ 2 ] = 3;
	anim.readyAnimWeights	[ "stand" ][ 0 ][ 3 ] = 1;
	anim.readyAnimWeights	[ "stand" ][ 0 ][ 4 ] = 1;

	anim.coverTrans[ "exposed_ready_cqb" ] = [];
	anim.coverTrans[ "exposed_ready_cqb" ][ 1 ] = %cqb_trans_2_readystand_1;
	anim.coverTrans[ "exposed_ready_cqb" ][ 2 ] = %cqb_trans_2_readystand_2;
	anim.coverTrans[ "exposed_ready_cqb" ][ 3 ] = %cqb_trans_2_readystand_3;
	anim.coverTrans[ "exposed_ready_cqb" ][ 4 ] = %cqb_trans_2_readystand_4;
	anim.coverTrans[ "exposed_ready_cqb" ][ 6 ] = %cqb_trans_2_readystand_6;
	anim.coverTrans[ "exposed_ready_cqb" ][ 7 ] = %cqb_trans_2_readystand_7;
	anim.coverTrans[ "exposed_ready_cqb" ][ 8 ] = %cqb_trans_2_readystand_8;
	anim.coverTrans[ "exposed_ready_cqb" ][ 9 ] = %cqb_trans_2_readystand_9;
	
	anim.coverTrans[ "exposed_ready" ] = [];
	anim.coverTrans[ "exposed_ready" ][ 1 ] = %run_trans_2_readystand_1;
	anim.coverTrans[ "exposed_ready" ][ 2 ] = %run_trans_2_readystand_2;
	anim.coverTrans[ "exposed_ready" ][ 3 ] = %run_trans_2_readystand_3;
	anim.coverTrans[ "exposed_ready" ][ 4 ] = %run_trans_2_readystand_4;
	anim.coverTrans[ "exposed_ready" ][ 6 ] = %run_trans_2_readystand_6;
	anim.coverTrans[ "exposed_ready" ][ 7 ] = %run_trans_2_readystand_7;
	anim.coverTrans[ "exposed_ready" ][ 8 ] = %run_trans_2_readystand_8;
	anim.coverTrans[ "exposed_ready" ][ 9 ] = %run_trans_2_readystand_9;

	anim.coverExit[ "exposed_ready_cqb" ] = [];
	anim.coverExit[ "exposed_ready_cqb" ][ 1 ] = %readystand_trans_2_cqb_1;
	anim.coverExit[ "exposed_ready_cqb" ][ 2 ] = %readystand_trans_2_cqb_2;
	anim.coverExit[ "exposed_ready_cqb" ][ 3 ] = %readystand_trans_2_cqb_3;
	anim.coverExit[ "exposed_ready_cqb" ][ 4 ] = %readystand_trans_2_cqb_4;
	anim.coverExit[ "exposed_ready_cqb" ][ 6 ] = %readystand_trans_2_cqb_6;
	anim.coverExit[ "exposed_ready_cqb" ][ 7 ] = %readystand_trans_2_cqb_7;
	anim.coverExit[ "exposed_ready_cqb" ][ 8 ] = %readystand_trans_2_cqb_8;
	anim.coverExit[ "exposed_ready_cqb" ][ 9 ] = %readystand_trans_2_cqb_9;
	
	anim.coverExit[ "exposed_ready" ] = [];
	anim.coverExit[ "exposed_ready" ][ 1 ] = %readystand_trans_2_run_1;
	anim.coverExit[ "exposed_ready" ][ 2 ] = %readystand_trans_2_run_2;
	anim.coverExit[ "exposed_ready" ][ 3 ] = %readystand_trans_2_run_3;
	anim.coverExit[ "exposed_ready" ][ 4 ] = %readystand_trans_2_run_4;
	anim.coverExit[ "exposed_ready" ][ 6 ] = %readystand_trans_2_run_6;
	anim.coverExit[ "exposed_ready" ][ 7 ] = %readystand_trans_2_run_7;
	anim.coverExit[ "exposed_ready" ][ 8 ] = %readystand_trans_2_run_8;
	anim.coverExit[ "exposed_ready" ][ 9 ] = %readystand_trans_2_run_9;

	transTypes = [];
	transTypes[ 0 ] = "exposed_ready";
	transTypes[ 1 ] = "exposed_ready_cqb";

	// yoinked right out of init_move_transitions.
	for ( i = 1; i <= 6; i++ )
	{
		if ( i == 5 )
			continue;

		for ( j = 0; j < transTypes.size; j++ )
		{
			trans = transTypes[ j ];

			if ( isdefined( anim.coverTrans[ trans ] ) && isdefined( anim.coverTrans[ trans ][ i ] ) )
			{
				anim.coverTransDist  [ trans ][ i ] = getMoveDelta( anim.coverTrans[ trans ][ i ], 0, 1 );
				anim.coverTransAngles[ trans ][ i ] = getAngleDelta( anim.coverTrans[ trans ][ i ], 0, 1 );
			}

			if ( isdefined( anim.coverExit [ trans ] ) && isdefined( anim.coverExit [ trans ][ i ] ) )
			{
				// get exit dist only to code_move
				if ( animHasNotetrack( anim.coverExit[ trans ][ i ], "code_move" ) )
					codeMoveTime = getNotetrackTimes( anim.coverExit[ trans ][ i ], "code_move" )[ 0 ];
				else
					codeMoveTime = 1;

				anim.coverExitDist   [ trans ][ i ] = getMoveDelta( anim.coverExit [ trans ][ i ], 0, codeMoveTime );
				anim.coverExitAngles [ trans ][ i ] = getAngleDelta( anim.coverExit [ trans ][ i ], 0, 1 );
			}
		}
	}
	
	for ( j = 0; j < transTypes.size; j++ )
	{
		trans = transTypes[ j ];
		
		anim.coverTransLongestDist[ trans ] = 0;

		for ( i = 1; i <= 6; i++ )
		{
			if ( i == 5 || !isdefined( anim.coverTrans[ trans ]) || !isdefined( anim.coverTrans[ trans ][ i ] ) )
				continue;
		
			lengthSq = lengthSquared( anim.coverTransDist[ trans ][ i ] );
			if ( anim.coverTransLongestDist[ trans ] < lengthSq )
				anim.coverTransLongestDist[ trans ] = lengthSq;
		}

		anim.coverTransLongestDist[ trans ] = sqrt( anim.coverTransLongestDist[ trans ] );
	}

	if ( !isdefined( anim.longestExposedApproachDist ) )
		anim.longestExposedApproachDist = 0;

	for ( j = 0; j < transTypes.size; j++ )
	{
		trans = transTypes[j];
		for ( i = 7; i <= 9; i++ )
		{
			if ( isdefined( anim.coverTrans[ trans ]) && isdefined( anim.coverTrans[ trans ][ i ] ) )
			{
				anim.coverTransDist  [ trans ][ i ] = getMoveDelta( anim.coverTrans[ trans ][ i ], 0, 1 );
				anim.coverTransAngles[ trans ][ i ] = getAngleDelta( anim.coverTrans[ trans ][ i ], 0, 1 );
			}

			if ( isdefined( anim.coverExit[ trans ]) && isdefined( anim.coverExit [ trans ][ i ] ) )
			{
				// get exit dist only to code_move
				assert( animHasNotetrack( anim.coverExit[ trans ][ i ], "code_move" ) );
				codeMoveTime = getNotetrackTimes( anim.coverExit[ trans ][ i ], "code_move" )[ 0 ];

				anim.coverExitDist   [ trans ][ i ] = getMoveDelta( anim.coverExit [ trans ][ i ], 0, codeMoveTime );
				anim.coverExitAngles [ trans ][ i ] = getAngleDelta( anim.coverExit [ trans ][ i ], 0, 1 );
			}
		}

		for ( i = 1; i <= 9; i++ )
		{
			if ( !isdefined( anim.coverTrans[ trans ]) || !isdefined( anim.coverTrans[ trans ][ i ] ) )
				continue;

			len = length( anim.coverTransDist[ trans ][ i ] );
			if ( len > anim.longestExposedApproachDist )
				anim.longestExposedApproachDist = len;
		}
	}
}