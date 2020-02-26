textures/austria/background/truckride_lft
{
	surfaceparm foliage
	surfaceparm nomarks
	surfaceparm nolightmap

	qer_editorimage textures/austria/background/foliage@truckride_lft.tga
	{
		map clampy textures/austria/background/foliage@truckride_lft.tga
		rgbgen vertex
		alphaFunc GE128
		depthWrite
	}
}
textures/austria/background/truckride_rt
{
	surfaceparm foliage
	surfaceparm nomarks
	surfaceparm nolightmap

	qer_editorimage textures/austria/background/foliage@truckride_rt.tga
	{
		map clampy textures/austria/background/foliage@truckride_rt.tga
		rgbgen vertex
		alphaFunc GE128
		depthWrite
	}
}
textures/austria/background/truckride_cntr
{
	surfaceparm foliage
	surfaceparm nomarks
	surfaceparm nolightmap

	qer_editorimage textures/austria/background/foliage@truckride_cntr.tga
	{
		map clampy textures/austria/background/foliage@truckride_cntr.tga
		rgbgen vertex
		alphaFunc GE128
		depthWrite
	}
}

textures/austria/background/truck_single
{
	surfaceparm foliage
	surfaceparm nomarks
	surfaceparm nolightmap

	qer_editorimage textures/austria/background/foliage_clamp@truck_single.tga
	{
		map clamp textures/austria/background/foliage_clamp@truck_single.tga
		rgbgen vertex
		alphaFunc GE128
		depthWrite
		nextbundle
		map $whiteimage
	}
}

textures/sfx/truckridewaterfall
{
	surfaceparm water
	surfaceparm nomarks
	surfaceparm nolightmap
	surfaceparm noshadow
//	sort seeThrough // so that it draws after solid geometry but before the spray
	qer_editorimage textures/sfx/fallingwater.dds
	{
		map textures/sfx/fallingwater.dds
		tcMod scroll 0 -0.9
		rgbGen Vertex
		blendFunc blend
	}

}

textures/sfx/truckridewaterfall2
{
	surfaceparm water
	surfaceparm nomarks
	surfaceparm nolightmap
	surfaceparm noshadow
//	sort seeThrough // so that it draws after solid geometry but before the spray
	qer_editorimage textures/sfx/fallingwater.dds
	{
		map textures/sfx/fallingwater.dds
		tcMod scroll 0 -1.5
		rgbGen Vertex
		blendFunc blend
	}

}


