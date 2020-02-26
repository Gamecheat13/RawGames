textures/sfx/stalingradwater_pj
{
	qer_editorimage textures/sfx/wave_bump
	tessSize 256
	deformVertexes wave 100 sin 2 2 0 .25
	deformVertexes syncNormal 0.25

	//-------------------------------------------------------------------------
	// first stage for 4-texture cards (ie, GeForce3+, Radeon 9700+)
	// sun highlights on ripples are yellowish
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		rgbGen identity

		map heightToNormal textures/sfx/wave_bump
		tcMod scale .03125 .03125
		tcMod scroll .0025 .00125
	nextbundle
		map heightToNormal textures/sfx/wave_bump
		tcMod scale -.03125 -.03125
		tcMod scroll .00125 -.0025
		texEnvCombine
		{
			const = ( 0.5 0.5 0.5 0.5 )
			rgb = INTERPOLATE_ARB(Cp, Ct, Ac)
		}
	nextbundle
		cubemap $renormalize
		tcGen sunHalfAngle
		tcMod bumpmapFrame
		texEnvCombine
		{
			rgb = DOT3_RGB_ARB(Cp, Ct)
		}
	nextbundle
		map $whiteimage
		texEnvCombine
		{
			const = ( .32 .36 .4 ) * identityLighting
			rgb = MODULATE(Cp, Cc)
		}
	}

	//-------------------------------------------------------------------------
	// first stage for 3-texture cards (ie, Radeon up to 8500)
	// sun highlights on ripples are white
	{
		requires GL_MAX_TEXTURE_UNITS_ARB == 3
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		rgbGen identity
		alphaGen constLighting .37
		blendFunc GL_SRC_ALPHA GL_ZERO
		depthWrite

		map heightToNormal textures/sfx/wave_bump
		tcMod scale .03125 .03125
		tcMod scroll .00025 .00125
	nextbundle
		map heightToNormal textures/sfx/wave_bump
		tcMod scale -.03125 -.03125
		tcMod scroll .00025 -.00125
		texEnvCombine
		{
			const = ( 0.5 0.5 0.5 0.5 )
			rgb = INTERPOLATE_ARB(Cp, Ct, Ac)
		}
	nextbundle
		cubemap $renormalize
		tcGen sunHalfAngle
		tcMod bumpmapFrame
		texEnvCombine
		{
			rgb = DOT3_RGB_ARB(Cp, Ct)
			alpha = REPLACE(Af)
		}
	}

	//-------------------------------------------------------------------------
	// last stage for 3-or-more texture cards (ie, GeForce3+, all Radeon)
	// sun reflection and baseline water color combine to .6, with reflection being half as important
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 3
		requires GL_ARB_texture_cube_map
		requires GL_ARB_texture_env_combine
		requires GL_ARB_texture_env_dot3

		map textures/sfx/stalinriver.jpg
		rgbGen identity
		alphaGen constLighting .3
		blendFunc GL_SRC_ALPHA GL_ONE
		tcMod scale .25 .25
		tcMod scroll -.0375 .0375
	nextbundle
		map textures/sfx/stalinriver.jpg
		tcMod scale .25 .25
		tcMod scroll 0 -.051
	nextbundle
		cubemap env/stalingrad
		tcGen reflection
		texEnvCombine
		{
			const = ( 1 1 1 .5 )
			rgb = INTERPOLATE_ARB(Ct, Cp, Ac)
			alpha = REPLACE(Af)
		}
	}

	//-------------------------------------------------------------------------
	// two stage fallback effect for 2-texture cards (ie, GeForce1 & 2 and GeForce4 MX)
	// also used if the other extensions needed are missing
	{
		requires GL_MAX_TEXTURE_UNITS_ARB == 2 || ! GL_ARB_texture_env_combine || ! GL_ARB_texture_env_dot3 || ! GL_ARB_texture_cube_map

		map textures/sfx/stalinriver.jpg
		rgbGen constLighting ( .5 .5 .5 )
		tcMod scale .25 .25
		tcMod scroll -.0375 .0375
	nextbundle
		map textures/sfx/stalinriver.jpg
		tcMod scale .25 .25
		tcMod scroll 0 -.051
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB == 2 || ! GL_ARB_texture_env_combine || ! GL_ARB_texture_env_dot3
		requires GL_ARB_texture_cube_map

		cubemap env/stalingrad
		rgbGen constLighting ( .32 .36 .4 )
		blendFunc add
		tcGen reflection
	}
}
