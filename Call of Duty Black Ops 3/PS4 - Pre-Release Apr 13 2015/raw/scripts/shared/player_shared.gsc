    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\math_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\callbacks_shared;
#using scripts\codescripts\struct;

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

	looping = bundle.looping;
	if ( !isdefined( looping ) ) 
		looping = false;
	num_stages = ( looping ? 1 : bundle.num_stages );

	for ( stageIdx = 0 ; stageIdx < num_stages && !self.forceStopPostfxBundle ; stageIdx++ )
	{
		stagePrefix = "s";
		if ( stageIdx < 10 ) stagePrefix += "0";
		stagePrefix += stageIdx + "_";

		stageLength = GetStructField( bundle, stagePrefix + "length" );
		if ( !isdefined( stageLength ) )
		{
			finishPlayingPostfxBundle( stagePrefix + "length not defined" );
			return;
		}
		stageLength *= 1000;

		stageMaterial = GetStructField( bundle, stagePrefix + "material" );
		if ( !isdefined( stageMaterial ) )
		{
			finishPlayingPostfxBundle( stagePrefix + "material not defined" );
			return;
		}

		filter::map_material_helper( self, stageMaterial );
		self set_filter_pass_material( filterid, 0, filter::mapped_material_id( stageMaterial ) );
		self set_filter_pass_enabled( filterid, 0, true );

		accumTime = 0;
		prevTime = self GetClientTime();
		while ( ( looping || accumTime < stageLength ) && !self.forceStopPostfxBundle )
		{
			num_consts = GetStructField( bundle, stagePrefix + "num_consts" );
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
								lerpRatio = sin( 360.0 * timeRatio );
								break;

							default: // "hold"
								break;
						}

						lerpRatio = math::clamp( lerpRatio, 0, 1 );

						val = startValue[ chanIdx ] + lerpRatio * delta;
					}
					else
					{
						val = startValue[ chanIdx ];
					}

					self set_filter_pass_constant( filterid, 0, baseShaderConstIndex + chanIdx, val );
				}
			}

			// Set the time variables in scriptVector7 (all in milliseconds):
			// x: total accumulated time (since the start of the postFX bundle)
			// y: current stage accumulated time
			// z: current stage length
			scriptVector7Base = getShaderConstantIndex( "scriptvector7" );
			self set_filter_pass_constant( filterid, 0, scriptVector7Base + 0, totalAccumTime );
			self set_filter_pass_constant( filterid, 0, scriptVector7Base + 1, accumTime );
			self set_filter_pass_constant( filterid, 0, scriptVector7Base + 2, stageLength );

			{wait(.016);};
			
			currTime = self GetClientTime();
			deltaTime = currTime - prevTime;
			accumTime += deltaTime;
			totalAccumTime += deltaTime;

			prevTime = currTime;

			if ( looping )
			{
				while ( accumTime >= stageLength )
					accumTime -= stageLength;
			}
		}

		self set_filter_pass_enabled( filterid, 0, false );
	}

	finishPlayingPostfxBundle( "Finished " + playBundleName );
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

function finishPlayingPostfxBundle( msg )
{
	/#
	if ( isdefined( msg ) )
	{
		println( msg );
	}
	#/

	self.forceStopPostfxBundle = false;
	self.playingPostfxBundle = "";
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
	if ( !( isdefined( self.forceStopPostfxBundle ) && self.forceStopPostfxBundle ) && isdefined( self.playingPostfxBundle ) && self.playingPostfxBundle != "" )
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

//-----------------------------------------------------------------------------
