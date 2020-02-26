textures/belgium/foliage/winter_fir1
{
	surfaceparm foliage
	surfaceparm nomarks
	surfaceparm nolightmap

	qer_editorimage textures/belgium/foliage/foliage@winter_fir1.tga
	{
		map textures/belgium/foliage/foliage@winter_fir1.tga
		rgbgen vertex
		alphaFunc GE128
		depthWrite
		nextbundle
		map $whiteimage
	}
}

textures/belgium/foliage/copse1

{
	surfaceparm foliage
	surfaceparm nomarks
	surfaceparm nolightmap

	qer_editorimage textures/belgium/foliage/foliage_snow@copse1.tga
	{
		map textures/belgium/foliage/foliage_snow@copse1.tga
		rgbgen vertex
		alphaFunc GE128
		depthWrite
		nextbundle
		map $whiteimage
	}
}
textures/belgium/foliage/wintertreeline_c

{
	surfaceparm foliage
	surfaceparm nomarks
	surfaceparm nolightmap

	qer_editorimage textures/belgium/foliage/foliage_snow@wintertreeline_c.tga
	{
		map textures/belgium/foliage/foliage_snow@wintertreeline_c.tga
		rgbgen vertex
		alphaFunc GE128
		depthWrite
		nextbundle
		map $whiteimage
	}
}



textures/belgium/foliage/wintertreeline_l
{
	surfaceparm foliage
	surfaceparm nomarks
	surfaceparm nolightmap

	qer_editorimage textures/belgium/foliage/foliage_snow@wintertreeline_l.tga

	{
		map textures/belgium/foliage/foliage_snow@wintertreeline_l.tga
		rgbgen vertex
		alphaFunc GE128
		depthWrite
		nextbundle
		map $whiteimage
	}
}


textures/belgium/foliage/wintertreeline_r
{
	surfaceparm foliage
	surfaceparm nomarks
	surfaceparm nolightmap

	qer_editorimage textures/belgium/foliage/foliage_snow@wintertreeline_r.tga
	{
		map textures/belgium/foliage/foliage_snow@wintertreeline_r.tga
		rgbgen vertex
		alphaFunc GE128
		depthWrite
		nextbundle
		map $whiteimage
	}
}
textures/belgium/foliage/copse2
{
	surfaceparm foliage
	surfaceparm nomarks
	surfaceparm nolightmap

	qer_editorimage textures/belgium/foliage/foliage_snow@copse2.tga
	{
		map textures/belgium/foliage/foliage_snow@copse2.tga
		rgbgen vertex
		alphaFunc GE128
		depthWrite
		nextbundle
		map $whiteimage
	}
}
textures/belgium/foliage/singletree1
{
	surfaceparm foliage
	surfaceparm nomarks
	surfaceparm nolightmap

	qer_editorimage textures/belgium/foliage/foliage_snow@singletree1.tga
	{
		map textures/belgium/foliage/foliage_snow@singletree1
		rgbgen vertex
		alphaFunc GE128
		depthWrite
		nextbundle
		map $whiteimage
	}
}

textures/belgium/ground/snowycreekbed
{
	qer_trans .5
//	q3map_globaltexture
	surfaceparm ice
	{
		map textures/belgium/ground/rock@snowycreekbed
		rgbGen exactVertex
	}
	{
		map $lightmap
		blendFunc filter
	}
}
