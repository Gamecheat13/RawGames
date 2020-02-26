textures/sfx/sunray_sewer
{
	qer_editorimage textures/sfx/sunray_sewer
	surfaceparm nonsolid
	cull none
	nopicmip
//	nomipmaps
	{
		map textures/sfx/sunray_sewer.jpg
		tcMod scroll .05 0
		blendFunc GL_ONE GL_ONE
	}
	{
		map textures/sfx/dustmotes_sewer.jpg
		tcMod scroll -0.05 .03
		tcMod scale 2 4
		tcMod turb 0.01 0.2 0.03
		blendFunc GL_ONE GL_ONE
	}
}

textures/sfx/sunray_sewerdrkr
{
	qer_editorimage textures/sfx/sunray_sewerdrkr
	surfaceparm nonsolid
	cull none
	nopicmip
//	nomipmaps
	{
		map textures/sfx/sunray_sewerdrkr.jpg
		tcMod scroll .05 0
		blendFunc GL_ONE GL_ONE
	}
	{
		map textures/sfx/dustmotes_sewer.jpg
		tcMod scroll -0.05 .03
		tcMod scale 2 4
		tcMod turb 0.01 0.2 0.03
		blendFunc GL_ONE GL_ONE
	}
}






textures/sfx/sewercaustic
{
	qer_editorimage textures/denmark/walls/brick@sewerblue_wall1
	nopicmip

	// first two stages for cards with 2 TMUs
	{
		requires GL_MAX_TEXTURE_UNITS_ARB == 2

		depthwrite
		map textures/sfx/sewercaustic.tga
		tcMod scroll -0.07 .05
		tcMod scale 2 2
		tcMod turb 0.11 0.2 0.03
	nextbundle
		map textures/sfx/sewercaustic.jpg
		tcMod scroll 0.05 -0.05
		tcMod scale 1 1
		tcMod turb 0.10 0.2 0.20
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB == 2

		depthfunc equal
		rgbGen exactVertex
		map $lightmap
		blendFunc filter
	}

	// first stage for cards with 3 or more TMUs
	{
		requires GL_MAX_TEXTURE_UNITS_ARB >= 3

		depthwrite
		map textures/sfx/sewercaustic.tga
		tcMod scroll -0.07 .05
		tcMod scale 2 2
		tcMod turb 0.11 0.2 0.03
	nextbundle
		map textures/sfx/sewercaustic.jpg
		tcMod scroll 0.05 -0.05
		tcMod scale 1 1
		tcMod turb 0.10 0.2 0.20
	nextbundle
		map $lightmap
		blendFunc filter
	}

	// last stage for all cards
	{
		depthfunc equal
		map textures/denmark/walls/brick@sewerblue_wall1.jpg
		rgbGen vertex
		blendFunc add
	nextbundle
		map $lightmap
	}
}


//textures/sfx/pegasusnight_canalwater
//{
//	qer_editorimage textures/normandy/pegasus/test_riverwater2.tga
//	surfaceparm nonsolid
//	surfaceparm water
//	surfaceparm trans
////	deformVertexes wave <div> <func> <base> <amplitude> <phase> <freq>
//	deformVertexes wave 1600 sin 2 2 0 .125
//	deformVertexes syncNormal .75
//	{
//		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
//		requires GL_ARB_texture_cube_map
//		requires GL_ARB_texture_env_combine
//		requires GL_ARB_texture_env_dot3
//
//		rgbGen identity
//
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale .0625 .0625
//		tcMod scroll .0125 .01125
//	nextbundle
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale -.0625 -.0625
//		tcMod scroll .01125 -.0125
//		texEnvCombine
//		{
//			const = ( 0.5 0.5 0.5 0.5 )
//			rgb = INTERPOLATE_ARB(Cp, Ct, Ac)
//		}
//	nextbundle
//		cubemap $renormalize
//		tcGen sunHalfAngle
//		tcMod bumpmapFrame
//		texEnvCombine
//		{
//			rgb = DOT3_RGB_ARB(Cp, Ct)
//		}
//	nextbundle
//		map $whiteimage
//		texEnvCombine
//		{
//			const = ( .32 .36 .4 ) * identityLighting
//			rgb = MODULATE(Cp, Cc)
//		}
//	}
//	{
//		requires GL_MAX_TEXTURE_UNITS_ARB == 3
//		requires GL_ARB_texture_cube_map
//		requires GL_ARB_texture_env_combine
//		requires GL_ARB_texture_env_dot3
//
//		rgbGen identity
//		alphaGen constLighting .37
//		blendFunc GL_SRC_ALPHA GL_ZERO
//		depthWrite
//
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale .0625 .0625
//		tcMod scroll .0125 .01125
//	nextbundle
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale -.0625 -.0625
//		tcMod scroll .01125 -.0125
//		texEnvCombine
//		{
//			const = ( 0.5 0.5 0.5 0.5 )
//			rgb = INTERPOLATE_ARB(Cp, Ct, Ac)
//		}
//	nextbundle
//		cubemap $renormalize
//		tcGen sunHalfAngle
//		tcMod bumpmapFrame
//		texEnvCombine
//		{
//			rgb = DOT3_RGB_ARB(Cp, Ct)
//			alpha = REPLACE(Af)
//		}
//	}
//	{
//		cubemap env/pegasusnight
//		tcgen reflection
//		alphagen const .25
//		blendFunc blend
//	}
//	{
//		map textures/normandy/pegasus/test_riverwater2.tga
//		alphagen const .4
//		blendfunc blend
//		//tcmod scroll .5 0
//		//tcmod turb 0 .02 0 .05
//	nextbundle
//		map $lightmap
//	}
//}
//
//textures/sfx/pegasusnight_pondwater
//{
//	qer_editorimage textures/normandy/pegasus/test_riverwater2.tga
//	surfaceparm nonsolid
//	surfaceparm water
//	surfaceparm trans
////	deformVertexes wave <div> <func> <base> <amplitude> <phase> <freq>
////	deformVertexes wave 1600 sin 2 2 0 .125
////	deformVertexes syncNormal .75
//	{
//		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
//		requires GL_ARB_texture_cube_map
//		requires GL_ARB_texture_env_combine
//		requires GL_ARB_texture_env_dot3
//
//		rgbGen identity
//
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale .0625 .0625
//		tcMod scroll .01125 0
//	nextbundle
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale -.0625 -.0625
//		tcMod scroll .01125 0
//		texEnvCombine
//		{
//			const = ( 0.5 0.5 0.5 0.5 )
//			rgb = INTERPOLATE_ARB(Cp, Ct, Ac)
//		}
//	nextbundle
//		cubemap $renormalize
//		tcGen sunHalfAngle
//		tcMod bumpmapFrame
//		texEnvCombine
//		{
//			rgb = DOT3_RGB_ARB(Cp, Ct)
//		}
//	nextbundle
//		map $whiteimage
//		texEnvCombine
//		{
//			const = ( .32 .36 .4 ) * identityLighting
//			rgb = MODULATE(Cp, Cc)
//		}
//	}
//	{
//		requires GL_MAX_TEXTURE_UNITS_ARB == 3
//		requires GL_ARB_texture_cube_map
//		requires GL_ARB_texture_env_combine
//		requires GL_ARB_texture_env_dot3
//
//		rgbGen identity
//		alphaGen constLighting .37
//		blendFunc GL_SRC_ALPHA GL_ZERO
//		depthWrite
//
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale .0625 .0625
//		tcMod scroll .01125 0
//	nextbundle
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale -.0625 -.0625
//		tcMod scroll .01125 0
//		texEnvCombine
//		{
//			const = ( 0.5 0.5 0.5 0.5 )
//			rgb = INTERPOLATE_ARB(Cp, Ct, Ac)
//		}
//	nextbundle
//		cubemap $renormalize
//		tcGen sunHalfAngle
//		tcMod bumpmapFrame
//		texEnvCombine
//		{
//			rgb = DOT3_RGB_ARB(Cp, Ct)
//			alpha = REPLACE(Af)
//		}
//	}
//	{
//		cubemap env/pegasusnight
//		tcgen reflection
//		alphagen const .25
//		blendFunc blend
//	}
//	{
//		map textures/normandy/pegasus/test_riverwater2.tga
//		alphagen const .4
//		blendfunc blend
//		//tcmod scroll .5 0
//		//tcmod turb 0 .02 0 .05
//	nextbundle
//		map $lightmap
//	}
//}
//
//textures/sfx/pegasusday_canalwater
//{
//	qer_editorimage textures/normandy/pegasus/test_riverwater2.tga
//	surfaceparm nonsolid
//	surfaceparm water
//	surfaceparm trans
////	deformVertexes wave <div> <func> <base> <amplitude> <phase> <freq>
//	deformVertexes wave 1600 sin 2 2 0 .125
//	deformVertexes syncNormal .75
//	{
//		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
//		requires GL_ARB_texture_cube_map
//		requires GL_ARB_texture_env_combine
//		requires GL_ARB_texture_env_dot3
//
//		rgbGen identity
//
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale .0625 .0625
//		tcMod scroll .0125 .01125
//	nextbundle
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale -.0625 -.0625
//		tcMod scroll .01125 -.0125
//		texEnvCombine
//		{
//			const = ( 0.5 0.5 0.5 0.5 )
//			rgb = INTERPOLATE_ARB(Cp, Ct, Ac)
//		}
//	nextbundle
//		cubemap $renormalize
//		tcGen sunHalfAngle
//		tcMod bumpmapFrame
//		texEnvCombine
//		{
//			rgb = DOT3_RGB_ARB(Cp, Ct)
//		}
//	nextbundle
//		map $whiteimage
//		texEnvCombine
//		{
//			const = ( .32 .36 .4 ) * identityLighting
//			rgb = MODULATE(Cp, Cc)
//		}
//	}
//	{
//		requires GL_MAX_TEXTURE_UNITS_ARB == 3
//		requires GL_ARB_texture_cube_map
//		requires GL_ARB_texture_env_combine
//		requires GL_ARB_texture_env_dot3
//
//		rgbGen identity
//		alphaGen constLighting .37
//		blendFunc GL_SRC_ALPHA GL_ZERO
//		depthWrite
//
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale .0625 .0625
//		tcMod scroll .0125 .01125
//	nextbundle
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale -.0625 -.0625
//		tcMod scroll .01125 -.0125
//		texEnvCombine
//		{
//			const = ( 0.5 0.5 0.5 0.5 )
//			rgb = INTERPOLATE_ARB(Cp, Ct, Ac)
//		}
//	nextbundle
//		cubemap $renormalize
//		tcGen sunHalfAngle
//		tcMod bumpmapFrame
//		texEnvCombine
//		{
//			rgb = DOT3_RGB_ARB(Cp, Ct)
//			alpha = REPLACE(Af)
//		}
//	}
//	{
//		cubemap env/pegasusday
//		tcgen reflection
//		alphagen const .25
//		blendFunc blend
//	}
//	{
//		map textures/normandy/pegasus/test_riverwater2.tga
//		alphagen const .4
//		blendfunc blend
//		//tcmod scroll .5 0
//		//tcmod turb 0 .02 0 .05
//	nextbundle
//		map $lightmap
//	}
//}
//
//textures/sfx/pegasusday_pondwater
//{
//	qer_editorimage textures/normandy/pegasus/test_riverwater2.tga
//	surfaceparm nonsolid
//	surfaceparm water
//	surfaceparm trans
////	deformVertexes wave <div> <func> <base> <amplitude> <phase> <freq>
////	deformVertexes wave 1600 sin 2 2 0 .125
////	deformVertexes syncNormal .75
//	{
//		requires GL_MAX_TEXTURE_UNITS_ARB >= 4
//		requires GL_ARB_texture_cube_map
//		requires GL_ARB_texture_env_combine
//		requires GL_ARB_texture_env_dot3
//
//		rgbGen identity
//
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale .0625 .0625
//		tcMod scroll .01125 0
//	nextbundle
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale -.0625 -.0625
//		tcMod scroll .01125 0
//		texEnvCombine
//		{
//			const = ( 0.5 0.5 0.5 0.5 )
//			rgb = INTERPOLATE_ARB(Cp, Ct, Ac)
//		}
//	nextbundle
//		cubemap $renormalize
//		tcGen sunHalfAngle
//		tcMod bumpmapFrame
//		texEnvCombine
//		{
//			rgb = DOT3_RGB_ARB(Cp, Ct)
//		}
//	nextbundle
//		map $whiteimage
//		texEnvCombine
//		{
//			const = ( .32 .36 .4 ) * identityLighting
//			rgb = MODULATE(Cp, Cc)
//		}
//	}
//	{
//		requires GL_MAX_TEXTURE_UNITS_ARB == 3
//		requires GL_ARB_texture_cube_map
//		requires GL_ARB_texture_env_combine
//		requires GL_ARB_texture_env_dot3
//
//		rgbGen identity
//		alphaGen constLighting .37
//		blendFunc GL_SRC_ALPHA GL_ZERO
//		depthWrite
//
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale .0625 .0625
//		tcMod scroll .01125 0
//	nextbundle
//		map heightToNormal textures/normandy/pegasus/wave_bumpmap.tga
//		tcMod scale -.0625 -.0625
//		tcMod scroll .01125 0
//		texEnvCombine
//		{
//			const = ( 0.5 0.5 0.5 0.5 )
//			rgb = INTERPOLATE_ARB(Cp, Ct, Ac)
//		}
//	nextbundle
//		cubemap $renormalize
//		tcGen sunHalfAngle
//		tcMod bumpmapFrame
//		texEnvCombine
//		{
//			rgb = DOT3_RGB_ARB(Cp, Ct)
//			alpha = REPLACE(Af)
//		}
//	}
//	{
//		cubemap env/pegasusday
//		tcgen reflection
//		alphagen const .25
//		blendFunc blend
//	}
//	{
//		map textures/normandy/pegasus/test_riverwater2.tga
//		alphagen const .4
//		blendfunc blend
//		//tcmod scroll .5 0
//		//tcmod turb 0 .02 0 .05
//	nextbundle
//		map $lightmap
//	}
//}

textures/effects/smokecolumn
{
//	qer_editorimage textures/sfx/smokecolumn_editorimage.jpg
	sort	seethrough
    {
	animMap 17 
        map clamp gfx/effects/animated/smokecolumn1
	map clamp gfx/effects/animated/smokecolumn2
	map clamp gfx/effects/animated/smokecolumn3
	map clamp gfx/effects/animated/smokecolumn4
	map clamp gfx/effects/animated/smokecolumn5
	map clamp gfx/effects/animated/smokecolumn6
	map clamp gfx/effects/animated/smokecolumn7
	map clamp gfx/effects/animated/smokecolumn8
	map clamp gfx/effects/animated/smokecolumn9
	map clamp gfx/effects/animated/smokecolumn10
	map clamp gfx/effects/animated/smokecolumn11
	map clamp gfx/effects/animated/smokecolumn12
	map clamp gfx/effects/animated/smokecolumn13
	map clamp gfx/effects/animated/smokecolumn14
	map clamp gfx/effects/animated/smokecolumn15
	map clamp gfx/effects/animated/smokecolumn16
	map clamp gfx/effects/animated/smokecolumn17
	map clamp gfx/effects/animated/smokecolumn18
	map clamp gfx/effects/animated/smokecolumn19
	map clamp gfx/effects/animated/smokecolumn20
	map clamp gfx/effects/animated/smokecolumn21
	map clamp gfx/effects/animated/smokecolumn22
	map clamp gfx/effects/animated/smokecolumn23
	map clamp gfx/effects/animated/smokecolumn24
	map clamp gfx/effects/animated/smokecolumn25
	//map clamp gfx/effects/animated/smokecolumn26
	//map clamp gfx/effects/animated/smokecolumn27
	//map clamp gfx/effects/animated/smokecolumn28
	//map clamp gfx/effects/animated/smokecolumn29
	//map clamp gfx/effects/animated/smokecolumn30
	//map clamp gfx/effects/animated/smokecolumn31
	//map clamp gfx/effects/animated/smokecolumn32
	//map clamp gfx/effects/animated/smokecolumn33
	//map clamp gfx/effects/animated/smokecolumn34
	//map clamp gfx/effects/animated/smokecolumn35
	//map clamp gfx/effects/animated/smokecolumn36
	//map clamp gfx/effects/animated/smokecolumn37
	//map clamp gfx/effects/animated/smokecolumn38
	//map clamp gfx/effects/animated/smokecolumn39
	//map clamp gfx/effects/animated/smokecolumn40
	//map clamp gfx/effects/animated/smokecolumn41
	//map clamp gfx/effects/animated/smokecolumn42
	//map clamp gfx/effects/animated/smokecolumn43
	//map clamp gfx/effects/animated/smokecolumn44
	//map clamp gfx/effects/animated/smokecolumn45
	//map clamp gfx/effects/animated/smokecolumn46
	//map clamp gfx/effects/animated/smokecolumn47
	//map clamp gfx/effects/animated/smokecolumn48
	//map clamp gfx/effects/animated/smokecolumn49
	//map clamp gfx/effects/animated/smokecolumn50
        blendFunc multiply
        rgbGen vertex
    }
}

