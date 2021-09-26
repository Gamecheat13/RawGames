#include "lib/globals.hlsl"
#include "lib/transform.hlsl"

struct VertexInput
{
	float4 position : POSITION;
};


struct PixelInput
{
	float4 position : POSITION;	
	float3 shadowCoord : TEXCOORD0;
};


struct PixelOutput
{
	float4 color : COLOR;
};


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel = (PixelInput)0;
	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.shadowCoord = mul( vertex.position, shadowLookupMatrix );

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;
	float4 shadowPixel;
	float clippingCoeff;

	shadowPixel = tex2D( shadowCookieSampler, pixel.shadowCoord );
	clippingCoeff = saturate( (pixel.shadowCoord.z - shadowPixel.z) * 64 + 0.5 );

	fragment.color = shadowPixel.a * shadowParms.a * clippingCoeff;
	return fragment;
}
