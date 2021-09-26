float2 TexScroll( float2 texCoord )
{
#ifdef TEX_SCROLL
	texCoord.y -= gameTime.z;
#endif
	return texCoord;
}
