#include common_scripts\utility;
#include animscripts\utility;
#include maps\_utility_code;
#include maps\_utility;
#include maps\_anim;
#include maps\_hud_util;


/*
	Texture processing
		Take Displacement channel.
		Scale to 16x16
		Export as raw with 0 header
		Convert to gsc
		Copy to shared\raw\maps (ensure it's added to P4)
		make a 48x48 texture with the 16x16 tiled 3x3
		Ensure you flatten the image in photoshop
		Bilinear upscale to 768x768
		Cut out the center 256x256 8 bit map
		Paste as the displacement channel in the normal map
		
*/

setup_ocean_params( params, _uscale, _vscale, _amplitude, _uvscrollrate )
{
	uscale[0] = 3;
	vscale[0] = 3;
	amplitude[0] = 30;
	uvscrollrate[0] = 4;
	uvscrollangle[0] = 0;
	
	uscale[1] = 8;
	vscale[1] = 8;
	amplitude[1] = 10;
	uvscrollrate[1] = 1.75;
	uvscrollangle[1] = 45;

	uscale[2] = 2;
	vscale[2] = 2;
	amplitude[2] = 0;
	uvscrollrate[2] = 2;
	uvscrollangle[2] = 315;
	
	maps\ocean_perlin::setup_ocean_perlin(params);
	for (i=0; i<3; i++)
	{
		params.uscale[i] = 0.0001 * _uscale * uscale[i];
		params.vscale[i] = 0.0001 * _vscale * vscale[i];
		params.amplitude[i] = _amplitude * amplitude[i];
		params.uscrollrate[i] = cos(uvscrollangle[i]) * _uvscrollrate * uvscrollrate[i];
		params.vscrollrate[i] = sin(uvscrollangle[i]) * _uvscrollrate * uvscrollrate[i];
	}
	params.uoff = -0.5;
	params.voff = -0.5;
	params.gameTimeOffset = 0.0;
	params.displacement_uvscale = 1.0;
}

setup_ocean()
{
	// copied from ny_harbor_ocean mtl
	_uscale = 1;
	_vscale = 1;
	_amplitude = 1;
	_uvscrollrate = 0.025;
	
	level.oceantextures["water_patch"] = spawnstruct();
	setup_ocean_params( level.oceantextures["water_patch"], _uscale, _vscale, _amplitude, _uvscrollrate );
	level.oceantextures["water_patch_med"] = spawnstruct();
	setup_ocean_params( level.oceantextures["water_patch_med"], _uscale, _vscale, 0.5*_amplitude, _uvscrollrate );
	level.oceantextures["water_patch_calm"] = spawnstruct();
	setup_ocean_params( level.oceantextures["water_patch_calm"], _uscale, _vscale, 0, _uvscrollrate );
}


GetTransformedUV( texture, coord, index, scale )
{
	gameTime = getTime();	// get water shader time in seconds
	gameTime = gameTime/(60*60*12.0*1000.0);	// replicate the wrap used in code for the shaders
	gameTime = gameTime - int(gameTime);
	gameTime *= (60*60*12.0);
	gameTime += texture.gameTimeOffset;	// offset to compensate for server frames
	uv = (coord[0] * texture.uscale[index] * scale, coord[1] * texture.vscale[index] * scale, 0);
	uv = uv + (gameTime * texture.uscrollrate[index]*scale, gameTime * texture.vscrollrate[index]*scale, 0);
	
	return uv;
}

GetTextureSampleFromInt( texture, uvint )
{
	u = safemod(uvint[0], texture.width);
	v = safemod(uvint[1], texture.height);
	s = texture.image[ v ][ u ];

	s = s/255.0;
	return s;
}

GetInterpolatedTextureSample( texture, uv )
{
	// first, translate so all are positive on the tile border (which is 1.0 at this point)
	u = uv[0] - floor(uv[0]);
	v = uv[1] - floor(uv[1]);
	// now get uv in texture space
	uvt = (u * texture.width, v * texture.height, 0);
	uv = (uvt[0] + texture.uoff, uvt[1] + texture.voff, 0);
	uvint = ( floor(uv[0]), floor(uv[1]), 0);	// get floor, since that is the basis for the interp
	uvfrac = uv - uvint;
	// ensure we start in valid range
	u = safemod(uvint[0], texture.width);
	v = safemod(uvint[1], texture.height);
	uvtex = ( u, v, 0);
	s[0][0] = GetTextureSampleFromInt( texture, uvtex );
	s[0][1] = GetTextureSampleFromInt( texture, uvtex + (0,1,0) );
	s[1][0] = GetTextureSampleFromInt( texture, uvtex + (1,0,0) );
	s[1][1] = GetTextureSampleFromInt( texture, uvtex + (1,1,0) );
	sample  = (s[0][0]*(1.0-uvfrac[0]) + s[1][0]*uvfrac[0])*(1.0-uvfrac[1]);
	sample += (s[0][1]*(1.0-uvfrac[0]) + s[1][1]*uvfrac[0])*uvfrac[1];
	return sample;
}

GetPerlinTextureSample( texture, uv )
{
	// first, translate so all are positive on the tile border (which is 1.0 at this point)
	u = uv[0] - floor(uv[0]);
	v = uv[1] - floor(uv[1]);
	// now get uv in texture space
	uvt = (u * texture.width, v * texture.height, 0);
	uv = (uvt[0] + texture.uoff, uvt[1] + texture.voff, 0);
	sample = maps\_perlin_noise::GetPerlinNoiseSample( texture, uv[0], uv[1] )/255.0;
	return sample;
}

GetDisplacementForVertex( texture, coord )
{
	displacement = 0;
	for ( i = 0; i < 3; i++ )
	{
		if (texture.amplitude[i] > 0)
		{
			uv = GetTransformedUV( texture, coord, i, texture.displacement_uvscale );
			sample = GetPerlinTextureSample( texture, uv );
			//sample = GetInterpolatedTextureSample( texture, uv );
			displacement += ( sample * 2.0 - 1.0 ) * texture.amplitude[i];
		}
	}
	return displacement;
}

