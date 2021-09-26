#include "lib/globals.hlsl"


struct VertexInput
{
	float4 position : POSITION;
	float3 normal : NORMAL;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
};


struct PixelInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
};


#include "lib/transform.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;
	float lighting;

	pixel.position = Transform_ObjectToClip( vertex.position );

	lighting = saturate( dot( normalize( eyePosition.xyz - vertex.position.xyz ), vertex.normal ) );

	pixel.color.rgb = vertex.color.rgb * lighting + 0.43;
	pixel.color.a = vertex.color.a;
	pixel.texCoords = vertex.texCoords;

	return pixel;
}
