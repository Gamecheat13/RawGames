textures/germany/liquids/damwaterfall
{
	surfaceparm nonsolid
	surfaceparm noimpact
	surfaceparm nodlight
	surfaceparm water
	sort seeThrough // so that it draws after solid geometry but before the spray
	{
		map textures/germany/liquids/damwaterfall.tga
		tcMod scroll 0 -1.75
		rgbGen identity
		blendFunc blend
	nextbundle
		map $lightmap
	}
}

textures/germany/liquids/damlake
{
//	surfaceparm water
//	surfaceparm trans
//	surfaceparm nonsolid
//	{
//		map textures/sfx/environmap_2night.jpg
//		tcGen environment
//	}
	{
		map textures/germany/liquids/damlake.tga
		tcMod scale 3 3
		tcMod scroll -.5 -1
		//rgbGen identity
		blendFunc blend
		depthWrite
	}
	{
		map textures/germany/liquids/damlake.tga
		tcMod scroll -.1 0
		rgbGen identity
		blendFunc blend
	nextbundle
		map $lightmap
	}
}

//textures/germany/liquids/damlake
//{
//	surfaceparm water
//	//surfaceparm trans
//	//surfaceparm nonsolid
//	{	// Reflection environment map
//		map textures/sfx/environmap_2night.jpg
//		tcGen environment
//		alphaGen const .1
//		blendFunc blend
//	}
//	{	// Water texture with transparency
//		map textures/germany/liquids/damlake.tga
//		//alphaFunc GE128
//	nextbundle
//		map $lightmap
//	}
//}

textures/germany/foliage/treespritetest
{
	//nomipmaps
	//nopicmip
	surfaceparm trans	
	surfaceparm nomarks	
	surfaceparm nomarks	
	surfaceparm nolightmap
	DeformVertexes autosprite2
	{
	        map textures/germany/foliage/treespritetest.tga
	        rgbGen lightingDiffuse
        	alphaFunc GE128
        	depthWrite
	}
}

textures/germany/floors/generatortop
{
	surfaceparm nonsolid
	polygonOffset
	{
		map clamp textures/germany/floors/generatortop.tga
		rgbGen exactVertex
		blendFunc blend
	nextbundle
		map $lightmap
	}
}
