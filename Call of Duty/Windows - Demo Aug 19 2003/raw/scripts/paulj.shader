textures/sfx/sewercausticdecal_wall
{

	qer_editorimage textures/textures/sfx/sewercausticdecal_wall.tga
	surfaceparm trans
	nopicmip
	polygonoffset
	sort additive
	{
		map textures/sfx/sewercaustic.jpg
//		tcGen vector ( 0 0.0078125 0 ) ( 0 0 0.0078125 )
		tcGen vector ( 0.0078125 0.0078125 0 ) ( 0 0 0.0078125 )
		tcMod scroll 0.05 -0.05
		rgbGen vertex
		alphaGen vertex
		blendFunc GL_SRC_ALPHA GL_ONE
	nextbundle
		map textures/sfx/sewercaustic.jpg
//		tcGen vector ( 0 0.0078125 0 ) ( 0 0 0.0078125 )
		tcGen vector ( 0.0078125 0.0078125 0 ) ( 0 0 0.0078125 )
		tcMod scale -0.95 0.95
		tcMod scroll 0.05 -0.05
	}
}

textures/sfx/sewercausticdecal_ceiling
{

	qer_editorimage textures/textures/sfx/sewercausticdecal_ceiling.tga
	surfaceparm trans
	nopicmip
	polygonoffset
	sort additive
	{
		map textures/sfx/sewercaustic.jpg
		tcGen vector ( 0.0078125 0 0 ) ( 0 0.0078125 0)
//		tcGen vector ( 0.0078125 0.0078125 0 ) ( 0 0.0078125 0)
		tcMod scroll 0.05 -0.05
		rgbGen vertex
		alphaGen vertex
		blendFunc GL_SRC_ALPHA GL_ONE
	nextbundle
		map textures/sfx/sewercaustic.jpg
		tcGen vector ( 0.0078125 0 0 ) ( 0 0.0078125 0)
//		tcGen vector ( 0.0078125 0.0078125 0 ) ( 0 0.0078125 0)
		tcMod scale -0.95 0.95
		tcMod scroll 0.05 -0.05
	}
}

textures/sfx/facade1
{
	{
		map clamp textures/sfx/facade1
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade2
{
	{
		map clamp textures/sfx/facade2
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade3
{
	{
		map clamp textures/sfx/facade3
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_ruins1
{
	{
		map clamp textures/sfx/facade_ruins1
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_ruins2
{
	{
		map clamp textures/sfx/facade_ruins2
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_noper1
{
	{
		map clamp textures/sfx/facade_noper1
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_noper2
{
	{
		map clamp textures/sfx/facade_noper2
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_noper3
{
	{
		map clamp textures/sfx/facade_noper3
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_noper4
{
	{
		map clamp textures/sfx/facade_noper4
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_noper5
{
	{
		map clamp textures/sfx/facade_noper5
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_noper6
{
	{
		map clamp textures/sfx/facade_noper6
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_tiler1
{
	{
		map clamp textures/sfx/facade_tiler1
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_tiler1top
{
	{
		map clamp textures/sfx/facade_tiler1top
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_tiler2
{
	{
		map clamp textures/sfx/facade_tiler2
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_tiler2top
{
	{
		map clamp textures/sfx/facade_tiler2top
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_core1
{
	{
		map textures/sfx/facade_core1
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_rubble1
{
	{
		map clampy textures/sfx/facade_rubble1
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/facade_floor1
{
	{
		map textures/sfx/facade_floor1
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/russia/background/facade_damagedbarge1
{
	{
		map textures/russia/background/facade_damagedbarge1
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/russia/background/facade_damagedbarge2
{
	{
		map textures/russia/background/facade_damagedbarge2
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/russia/background/facade_damagedtug1
{
	{
		map textures/russia/background/facade_damagedtug1
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/russia/background/facade_tug
{
	{
		map textures/russia/background/facade_tug
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/russia/background/facade_bargeside
{
	{
		map textures/russia/background/facade_bargeside
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/training/net
{
	cull disable
	{
		map textures/training/net
		rgbGen exactVertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/normandy/foliage/treeline2_cntr#0
{
	surfaceparm foliage
	{
		map clamp textures/normandy/foliage/treeline2_cntr#0
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/normandy/foliage/treeline2_left#0
{
	surfaceparm foliage
	{
		map clamp textures/normandy/foliage/treeline2_left#0
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/normandy/foliage/treeline2_right#0
{
	surfaceparm foliage
	{
		map clamp textures/normandy/foliage/treeline2_right#0
		rgbGen vertex
		alphaGen vertex
		alphaFunc GE128
		depthWrite
	nextbundle
		map $lightmap
	}
}

textures/sfx/envwindow_night
{
	qer_editorimage textures/sfx/envwindow_nightei
	surfaceparm noshadow
	surfaceparm glass
	surfaceparm trans
//	surfaceparm noimpact
//	surfaceparm nomarks
//	surfaceparm nonsolid
	surfaceparm playerclip
	surfaceparm monsterclip
	{
		map textures/sfx/environmap_1night.jpg
		tcGen environment
		rgbGen exactVertex
		alphaGen const .2
		blendFunc blend
	}
}

textures/sfx/envwindow_day
{
	qer_editorimage textures/sfx/envwindow_dayei
	surfaceparm noshadow
	surfaceparm glass
	surfaceparm trans
//	surfaceparm noimpact
//	surfaceparm nomarks
//	surfaceparm nonsolid
	surfaceparm playerclip
	surfaceparm monsterclip
	{
		map textures/sfx/environmap_1day.jpg
		tcGen environment
		rgbGen exactVertex
		alphaGen const .1
		blendFunc blend
	nextbundle
		map $dlight
	}
}

////////////////////////////////////////////////////////
//  TEMPORARY TEST AREA  :  CAUTION                   //
////////////////////////////////////////////////////////

textures/sfx/shoreline_ripple
{
    	sort    additive
	polygonoffset
        surfaceparm nonsolid
	surfaceparm trans
	surfaceparm noshadow
    {
	map textures/sfx/shoreline_ripple
	blendFunc GL_SRC_ALPHA GL_ONE
	rgbGen exactvertex
	tcMod scroll 0.00 -0.05
    }
    {
	map textures/sfx/shoreline_ripple
	blendFunc GL_SRC_ALPHA GL_ONE
	rgbGen exactvertex
	tcMod scroll 0.03 -0.06
    }
}

textures/sfx/fallingwater
{
	surfaceparm water
	surfaceparm nomarks
	surfaceparm nolightmap
	surfaceparm noshadow
	sort seeThrough // so that it draws after solid geometry but before the spray
	qer_editorimage textures/sfx/fallingwater.dds
	{
		map textures/sfx/fallingwater.dds
		tcMod scroll 0 -0.9
		rgbGen Vertex
		blendFunc blend
	}
	{
		map textures/sfx/fallingwater.dds
		tcMod scroll 0 -0.7
		rgbGen Vertex
		blendFunc blend
	}

}
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
//  The following are the burning embers shaders                  //
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

textures/sfx/charred_embers
{

	qer_editorimage textures/sfx/charred_ember_ei
	surfaceparm trans
	nopicmip
	polygonoffset
	{
		requires GL_MAX_TEXTURE_UNITS_ARB == 2 || ! GL_ARB_texture_env_add

		map textures/sfx/emberglow
		tcMod scroll 0.05 -0.05
		rgbGen identitylighting
		alphaGen vertex
		blendFunc blend
	nextbundle
		map textures/sfx/charred_ember
		blendFunc blend
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB > 2
		requires GL_ARB_texture_env_add

		map textures/sfx/emberglow
		tcMod scroll 0.05 -0.05
		rgbGen identitylighting
		alphaGen vertex
		blendFunc blend
	nextbundle
		map textures/sfx/emberglow
		tcMod scroll -0.05 0.05
		blendFunc add
	nextbundle
		map textures/sfx/charred_ember
		blendFunc blend
	}
}


textures/sfx/ash_embers
{

	qer_editorimage textures/sfx/ash_embers_ei
	surfaceparm trans
	nopicmip
	polygonoffset
	{
		requires GL_MAX_TEXTURE_UNITS_ARB == 2 || ! GL_ARB_texture_env_add

		map textures/sfx/emberglow
		tcMod scroll 0.02 -0.02
		rgbGen identitylighting
		alphaGen vertex
		blendFunc blend
	nextbundle
		map textures/sfx/ash_embers
		blendFunc blend
	}
	{
		requires GL_MAX_TEXTURE_UNITS_ARB > 2
		requires GL_ARB_texture_env_add

		map textures/sfx/emberglow
		tcMod scroll 0.02 -0.02
		rgbGen identitylighting
		alphaGen vertex
		blendFunc blend
	nextbundle
		map textures/sfx/emberglow
		tcMod scroll -0.01 0.01
		blendFunc add
	nextbundle
		map textures/sfx/ash_embers
		blendFunc blend
	}
}
