#include "lib/globals.hlsl"

float4	debugWeights;


struct VertexInput
{
	float4 position : POSITION;
	float2 texCoords : TEXCOORD0;
	float3 tangent : TEXCOORD1;
	float3 binormal : TEXCOORD2;
	float3 normal : NORMAL;
};


struct PixelInput
{
	float4 position : POSITION;
	float2 texCoords : TEXCOORD0;
	float3 tangent : TEXCOORD1;
	float3 binormal : TEXCOORD2;
	float3 normal : TEXCOORD3;
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "lib/transform.hlsl"
#include "lib/normalmap.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput	pixel;
	float3x3	tangentSpaceMatrix;

	pixel = (PixelInput)0;
	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.texCoords = vertex.texCoords;
	Normal_VertexSetup( vertex, worldMatrix, pixel );

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput	fragment;

	half3		outVector;
	half3		worldNormal;
	half3		tangentBasis;
	half3		binormalBasis;
	half3		normalBasis;

	tangentBasis = pixel.tangent * 0.5;
	binormalBasis = pixel.binormal * 0.5;
	normalBasis = pixel.normal + tangentBasis + binormalBasis;
	worldNormal = Normal_GetWorldSpace( pixel );

	outVector = tangentBasis * debugWeights[0];
	outVector += binormalBasis * debugWeights[1];
	outVector += normalBasis * debugWeights[2];
	outVector += worldNormal * debugWeights[3];

	fragment.color = float4( (outVector + 1) * 0.5, 1 );

	return fragment;
}
