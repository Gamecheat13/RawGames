#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace postfx;



//-----------------------------------------------------------------------------
function autoexec __init__sytem__() {     system::register("postfx_bundle",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_spawned( &postfx_bundle_init );
}

function postfx_bundle_init( localClientNum )
{
	if( self isLocalPlayer() )
	{
		init_postfx_bundles();
	}	
}

//-----------------------------------------------------------------------------
function init_postfx_bundles()
{
	if ( isdefined( self.postfxBundelsInited ) )
		return;

	self.postfxBundelsInited = true;
	self.playingPostfxBundle = "";
	self.forceStopPostfxBundle = false;
	self.exitPostfxBundle = false;

	/#
	self thread postfxBundleDebugListen();
	#/
}

//-----------------------------------------------------------------------------
// debug - start a postfx bundle by setting the bundle name in a dvar: "scr_play_postfx_bundle"

/#
function postfxBundleDebugListen()
{
	self endon("entityshutdown");
	
	SetDvar( "scr_play_postfx_bundle", "" );
	SetDvar( "scr_stop_postfx_bundle", "" );
	SetDvar( "scr_exit_postfx_bundle", "" );

	while ( 1 )
	{
		playBundleName = GetDvarString( "scr_play_postfx_bundle" );
		if ( playBundleName != "" )
		{
			self thread playPostfxBundle( playBundleName );
			SetDvar( "scr_play_postfx_bundle", "" );
		}

		stopBundleName = GetDvarString( "scr_stop_postfx_bundle" );
		if ( stopBundleName != "" )
		{
			self thread stopPostfxBundle();
			SetDvar( "scr_stop_postfx_bundle", "" );
		}

		// For looping bundles
		stopBundleName = GetDvarString( "scr_exit_postfx_bundle" );
		if ( stopBundleName != "" )
		{
			self thread exitPostfxBundle();
			SetDvar( "scr_exit_postfx_bundle", "" );
		}

		wait( 0.5 );
	}
}
#/

//-----------------------------------------------------------------------------

function playPostfxBundle( playBundleName )
{
	self endon("entityshutdown");

	init_postfx_bundles();

	stopPlayingPostfxBundle();

	bundle = struct::get_script_bundle( "postfxbundle", playBundleName );
	if ( !isdefined( bundle ) )
	{
		/#
		println( "ERROR: postfx bundle '" + playBundleName + "' not found" );
		#/
		return;
	}

	filterid = 0;
	totalAccumTime = 0;

	filter::init_filter_indices();

	self.playingPostfxBundle = playBundleName;
	
	localClientNum = self.localClientNum;

	looping = false;
	enterStage = false;
	exitStage = false;
	finishLoopOnExit = false;

	if ( isdefined( bundle.looping) ) { looping = bundle.looping; };
	if ( isdefined( bundle.enterStage) ) { enterStage = bundle.enterStage; };
	if ( isdefined( bundle.exitStage) ) { exitStage = bundle.exitStage; };
	if ( isdefined( bundle.finishLoopOnExit) ) { finishLoopOnExit = bundle.finishLoopOnExit; };

	if ( looping )
	{
		num_stages = 1;
		if ( enterStage )
			num_stages++;
		if ( exitStage )
			num_stages++;
	}
	else
	{
		num_stages = bundle.num_stages;
	}

	captureImageName = undefined;
	if ( isDefined( bundle.screenCapture ) && bundle.screenCapture )
	{
		captureImageName = playBundleName;
		CreateSceneCodeImage( localClientNum, captureImageName );
		CaptureFrame( localClientNum, captureImageName );
		setFilterPassCodeTexture( localClientNum, filterid, 0, 0, captureImageName );
	}

	self thread watchEntityShutdown( localClientNum, filterid, captureImageName );
	for ( stageIdx = 0 ; stageIdx < num_stages && !self.forceStopPostfxBundle ; stageIdx++ )
	{
		stagePrefix = "s";
		if ( stageIdx < 10 ) stagePrefix += "0";
		stagePrefix += stageIdx + "_";

		stageLength = GetStructField( bundle, stagePrefix + "length" );
		if ( !isdefined( stageLength ) )
		{
			finishPlayingPostfxBundle( localClientNum, stagePrefix + "length not defined", filterid, captureImageName );
			return;
		}
		stageLength *= 1000;

		stageMaterial = GetStructField( bundle, stagePrefix + "material" );
		if ( !isdefined( stageMaterial ) )
		{
			finishPlayingPostfxBundle( localClientNum, stagePrefix + "material not defined", filterid, captureImageName );
			return;
		}

		filter::map_material_helper( self, stageMaterial );
		setFilterPassMaterial( localClientNum, filterid, 0, filter::mapped_material_id( stageMaterial ) );
		setFilterPassEnabled( localClientNum, filterid, 0, true );

		stageCapture = GetStructField( bundle, stagePrefix + "screenCapture" );
		if ( isDefined( stageCapture ) && stageCapture )
		{
			if ( isDefined( captureImageName ) )
			{
				FreeCodeImage( localClientNum, captureImageName );
				setFilterPassCodeTexture( localClientNum, filterid, 0, 0, "" );
			}

			captureImageName = stagePrefix + playBundleName;
			CreateSceneCodeImage( localClientNum, captureImageName );
			captureFrame( localClientNum, captureImageName );
			setFilterPassCodeTexture( localClientNum, filterid, 0, 0, captureImageName );
		}

		stageSprite = GetStructField( bundle, stagePrefix + "spriteFilter" );
		if ( isDefined( stageSprite ) && stageSprite )
		{
			setfilterpassquads( localClientNum, filterid, 0, 2048 );
		}
		else
		{
			setfilterpassquads( localClientNum, filterid, 0, 0 );
		}

		thermal = GetStructField( bundle, stagePrefix + "thermal" );
		EnableThermalDraw( localClientNum, isDefined( thermal ) && thermal );

		loopingStage = looping && ( !enterStage && stageIdx == 0 || enterStage && stageIdx == 1 );

		accumTime = 0;
		prevTime = self GetClientTime();
		while ( ( loopingStage || accumTime < stageLength ) && !self.forceStopPostfxBundle )
		{
//			/#
//				PrintTopRightln( playBundleName + ": Stage: " + ( stageIdx + 1 ) + " " + accumTime + "/" + stageLength, ( 1, 1, 1 ), 1 );
//			#/
			num_consts = GetStructFieldOrZero( bundle, stagePrefix + "num_consts" );
			for ( constIdx = 0 ; constIdx < num_consts ; constIdx++ )
			{
				constPrefix = stagePrefix + "c";
				if ( constIdx < 10 ) constPrefix += "0";
				constPrefix += constIdx + "_";

				startValue = getShaderConstantValue( bundle, constPrefix, "start", false );
				endValue   = getShaderConstantValue( bundle, constPrefix, "end", false );
				delays     = getShaderConstantValue( bundle, constPrefix, "delay", true );

				baseShaderConstIndex = getShaderConstantIndex( GetStructField( bundle, constPrefix + "name" ) );

				channels = GetStructField( bundle, constPrefix + "channels" );
				isColor = IsString( channels ) && ( channels == "color" || channels == "color+alpha" );

				animName = GetStructField( bundle, constPrefix + "anm" );

//				/#
//					channelString = "Const " + ( constIdx + 1 ) + ": " + animName + " ";
//				#/

				// Ease in/out: http://gizma.com/easing/
				for ( chanIdx = 0 ; chanIdx < startValue.size ; chanIdx++ )
				{
					delayTime = delays[ ( isColor ? 0 : chanIdx ) ] * 1000;

					if ( accumTime > delayTime && stageLength > delayTime )
					{
						timeRatio = ( accumTime - delayTime ) / ( stageLength - delayTime );
						timeRatio = math::clamp( timeRatio, 0, 1 );

						lerpRatio = 0.0;
						delta = endValue[ chanIdx ] - startValue[ chanIdx ];

						switch ( animName )
						{
							case "linear":
								lerpRatio = timeRatio;
								break;

							case "step":
								lerpRatio = 1;
								break;

							case "ease in":
								// quadratic ease in
								lerpRatio = timeRatio * timeRatio;
								break;

							case "ease out":
								// quadratic ease out
								lerpRatio = -timeRatio * ( timeRatio - 2 );
								break;

							case "ease inout":
								// quadratic easing in/out
								timeRatio *= 2;
								if ( timeRatio < 1 )
								{
									lerpRatio = 0.5 * lerpRatio * lerpRatio;
								}
								else
								{
									timeRatio -= 1;
									lerpRatio = -0.5 * ( lerpRatio * ( lerpRatio - 2 ) - 1 );
								}
								break;

							case "linear repeat":
								lerpRatio = timeRatio;
								break;

							case "linear mirror":
								if ( timeRatio > 0.5 )
									lerpRatio = 1.0 - timeRatio;
								else
									lerpRatio = timeRatio;
								break;

							case "sin":
								lerpRatio = 0.5 - 0.5*cos( 360.0 * timeRatio );
								break;

							default: // "hold"
								break;
						}

						lerpRatio = math::clamp( lerpRatio, 0, 1 );

						val = startValue[ chanIdx ] + lerpRatio * delta;

//						/#
//							channelString += lerpRatio + " ";
//						#/
					}
					else
					{
						val = startValue[ chanIdx ];
					}

					setFilterPassConstant( localClientNum, filterid, 0, baseShaderConstIndex + chanIdx, val );
				}

//				/#
//					PrintTopRightln( channelString, ( 1, 1, 1 ), 1 );
//				#/
			}

			// Set the time variables in scriptVector7 (all in milliseconds):
			// x: total accumulated time (since the start of the postFX bundle)
			// y: current stage accumulated time
			// z: current stage length
			scriptVector7Base = getShaderConstantIndex( "scriptvector7" );
			setFilterPassConstant( localClientNum, filterid, 0, scriptVector7Base + 0, totalAccumTime );
			setFilterPassConstant( localClientNum, filterid, 0, scriptVector7Base + 1, accumTime );
			setFilterPassConstant( localClientNum, filterid, 0, scriptVector7Base + 2, stageLength );

			{wait(.016);};
			
			currTime = self GetClientTime();
			deltaTime = currTime - prevTime;
			accumTime += deltaTime;
			totalAccumTime += deltaTime;

			prevTime = currTime;

			if ( loopingStage )
			{
				while ( accumTime >= stageLength )
					accumTime -= stageLength;

				if ( self.exitPostfxBundle )
				{
					loopingStage = false;
					if ( !finishLoopOnExit )
						break;
				}
			}
		}

		setFilterPassEnabled( localClientNum, filterid, 0, false );
	}

	finishPlayingPostfxBundle( localClientNum, "Finished " + playBundleName, filterid, captureImageName );
}

function watchEntityShutdown( localClientNum, filterid, captureImageName )
{
	self util::waittill_any( "entityshutdown", "death" );
	
	finishPlayingPostfxBundle( localClientNum, "Entity Shutdown", filterid, captureImageName );
}

function GetStructFieldOrZero( bundle, field )
{
	ret = GetStructField( bundle, field );
	if ( !isdefined( ret ) )
		ret = 0;

	return ret;
}

function getShaderConstantValue( bundle, constPrefix, constName, delay )
{
	channels = GetStructField( bundle, constPrefix + "channels" );

	// Color has only single delay value
	if ( delay && IsString( channels ) && ( channels == "color" || channels == "color+alpha" ) )
		channels = "1";

	vals = [];

	switch ( channels )
	{
		case 1:
		case "1":
			vals[0] = GetStructFieldOrZero( bundle, constPrefix + constName + "_x" );
			break;

		case 2:
		case "2":
			vals[0] = GetStructFieldOrZero( bundle, constPrefix + constName + "_x" );
			vals[1] = GetStructFieldOrZero( bundle, constPrefix + constName + "_y" );
			break;

		case 3:
		case "3":
			vals[0] = GetStructFieldOrZero( bundle, constPrefix + constName + "_x" );
			vals[1] = GetStructFieldOrZero( bundle, constPrefix + constName + "_y" );
			vals[2] = GetStructFieldOrZero( bundle, constPrefix + constName + "_z" );
			break;

		case 4:
		case "4":
			vals[0] = GetStructFieldOrZero( bundle, constPrefix + constName + "_x" );
			vals[1] = GetStructFieldOrZero( bundle, constPrefix + constName + "_y" );
			vals[2] = GetStructFieldOrZero( bundle, constPrefix + constName + "_z" );
			vals[3] = GetStructFieldOrZero( bundle, constPrefix + constName + "_w" );
			break;

		case "color":
			vals[0] = GetStructFieldOrZero( bundle, constPrefix + constName + "_clr_r" );
			vals[1] = GetStructFieldOrZero( bundle, constPrefix + constName + "_clr_g" );
			vals[2] = GetStructFieldOrZero( bundle, constPrefix + constName + "_clr_b" );
			break;

		case "color+alpha":
			vals[0] = GetStructFieldOrZero( bundle, constPrefix + constName + "_clr_r" );
			vals[1] = GetStructFieldOrZero( bundle, constPrefix + constName + "_clr_g" );
			vals[2] = GetStructFieldOrZero( bundle, constPrefix + constName + "_clr_b" );
			vals[3] = GetStructFieldOrZero( bundle, constPrefix + constName + "_clr_a" );
			break;
	}

	return vals;
}

// Should be done in code:
function getShaderConstantIndex( codeConstName )
{
	switch ( codeConstName )
	{
		case "scriptvector0": return  0;
		case "scriptvector1": return  4;
		case "scriptvector2": return  8;
		case "scriptvector3": return 12;
		case "scriptvector4": return 16;
		case "scriptvector5": return 20;
		case "scriptvector6": return 24;
		case "scriptvector7": return 28;
	}

	return -1;
}

//-----------------------------------------------------------------------------

function finishPlayingPostfxBundle( localClientNum, msg, filterid, captureImageName )
{
	/#
	if ( isdefined( msg ) )
	{
		println( msg );
	}
	#/

	if( isDefined( self ) )
	{
		self.forceStopPostfxBundle = false;
		self.exitPostfxBundle = false;
		self.playingPostfxBundle = "";
	}

	setFilterPassQuads( localClientNum, filterid, 0, 0 );
	EnableThermalDraw( localClientNum, false );

	if ( isDefined( captureImageName ) )
	{
		setFilterPassCodeTexture( localClientNum, filterid, 0, 0, "" );
		FreeCodeImage( localClientNum, captureImageName );
	}
}

//-----------------------------------------------------------------------------

function stopPlayingPostfxBundle()
{
	if ( self.playingPostfxBundle != "" )
	{
		stopPostfxBundle();
	}
}

function stopPostfxBundle()
{
	self notify( "stopPostfxBundle_singleton" );
	self endon( "stopPostfxBundle_singleton" );
	
	if ( isdefined( self.playingPostfxBundle ) && self.playingPostfxBundle != "" )
	{
		self.forceStopPostfxBundle = true;

		while ( self.playingPostfxBundle != "" )
		{
			{wait(.016);};
			
			if ( !isdefined( self ) )
			{
				return;
			}
		}
	}
}

function exitPostfxBundle()
{
	if ( !( isdefined( self.exitPostfxBundle ) && self.exitPostfxBundle ) && isdefined( self.playingPostfxBundle ) && self.playingPostfxBundle != "" )
	{
		self.exitPostfxBundle = true;
	}
}
