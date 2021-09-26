void Normal_VertexSetup( const VertexInput vertex, const float4x4 transformMatrix, inout PixelInput pixel)
{
	pixel.tangent = mul( vertex.tangent, transformMatrix );
	pixel.binormal = mul( vertex.binormal, transformMatrix );
	pixel.normal = mul( vertex.normal, transformMatrix );
	pixel.normal -= pixel.tangent + pixel.binormal;
	pixel.tangent *= 2;
	pixel.binormal *= 2;
}


half3 Normal_DecodeDenormalizedWorldSpace( const PixelInput pixel, const half2 normalSample )
{
	return pixel.normal + normalSample.x * pixel.tangent + normalSample.y * pixel.binormal;
}


half3 Normal_DecodeNormalizedWorldSpace( const PixelInput pixel, const half2 normalSample )
{
	return normalize( Normal_DecodeDenormalizedWorldSpace( pixel, normalSample ) );
}


half2 Normal_GetSample( const half2 texCoords )
{
	return tex2D( normalMapSampler, texCoords ).NORMAL_MAP_CHANNELS;
}


half3 Normal_GetWorldSpace( const PixelInput pixel )
{
	return Normal_DecodeNormalizedWorldSpace( pixel, Normal_GetSample( pixel.texCoords ) );
}
