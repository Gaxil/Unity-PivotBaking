// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PivotBaking/PB_VFX4"
{
	Properties
	{
		_Roughness("Roughness", Range( 0 , 1)) = 0.8315013
		_Color0("Color 0", Color) = (0.2057227,0.6509434,0.2470478,0)
		_Rotation("Rotation", Range( 0 , 0.5)) = 0.2816087
		_Zwindspeed("Z wind speed", Range( -5 , 5)) = -0.7467601
		_Xwindspeed("X wind speed", Range( -5 , 5)) = -0.14
		_Noisescale("Noise scale", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			half filler;
		};

		uniform float _Xwindspeed;
		uniform float _Zwindspeed;
		uniform float _Noisescale;
		uniform float _Rotation;
		uniform float4 _Color0;
		uniform float _Roughness;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 appendResult98 = (float2(_Xwindspeed , _Zwindspeed));
			float3 appendResult7_g7 = (float3(( v.texcoord2.xy.x * -1.0 ) , v.texcoord3.xy.x , ( v.texcoord2.xy.y * -1.0 )));
			float3 temp_output_16_0_g7 = ( 0.01 * appendResult7_g7 );
			float3 objToWorld93 = mul( unity_ObjectToWorld, float4( temp_output_16_0_g7, 1 ) ).xyz;
			float2 appendResult95 = (float2(objToWorld93.x , objToWorld93.z));
			float2 panner94 = ( 1.0 * _Time.y * appendResult98 + appendResult95);
			float simplePerlin2D92 = snoise( panner94*_Noisescale );
			simplePerlin2D92 = simplePerlin2D92*0.5 + 0.5;
			float temp_output_102_0 = ( simplePerlin2D92 - 0.5 );
			float simplePerlin2D99 = snoise( ( float2( 21.98,14.45 ) + panner94 )*_Noisescale );
			simplePerlin2D99 = simplePerlin2D99*0.5 + 0.5;
			float temp_output_103_0 = ( simplePerlin2D99 - 0.5 );
			float4 appendResult101 = (float4(temp_output_102_0 , 1.0 , temp_output_103_0 , 0.0));
			float3 worldToObjDir90 = mul( unity_WorldToObject, float4( appendResult101.xyz, 0 ) ).xyz;
			float3 appendResult9_g7 = (float3(( 1.0 - v.color.r ) , v.color.b , v.color.g));
			float3 normalizeResult110 = normalize( cross( worldToObjDir90 , ( ( appendResult9_g7 - float3(0.5,0.5,0.5) ) * 2.0 ) ) );
			float2 appendResult112 = (float2(temp_output_102_0 , temp_output_103_0));
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 RelativePos113 = ( ase_vertex3Pos - temp_output_16_0_g7 );
			float temp_output_64_0 = ( _Rotation * UNITY_PI * length( appendResult112 ) * length( RelativePos113 ) );
			float3 rotatedValue61 = RotateAroundAxis( float3( 0,0,0 ), RelativePos113, normalizeResult110, temp_output_64_0 );
			v.vertex.xyz += ( rotatedValue61 - RelativePos113 );
			v.vertex.w = 1;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 rotatedValue79 = RotateAroundAxis( float3( 0,0,0 ), ase_vertexNormal, normalizeResult110, temp_output_64_0 );
			v.normal = rotatedValue79;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Color0.rgb;
			o.Smoothness = ( 1.0 - _Roughness );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1920;0;1920;1149;3489.934;3038.973;3.083911;True;False
Node;AmplifyShaderEditor.CommentaryNode;115;-1829.362,-1445.755;Inherit;False;1602.527;562.111;Generate random X & Y direction according to pivot position (DONT use vertex position as it will deform the shape). A texture can be used instead of noise here. ;12;95;100;99;92;105;96;97;98;94;102;103;93;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;46;-2222.574,-465.209;Inherit;False;GetPivotInfo;-1;;7;b58e44ad5701a19499f0136a7117d015;0;0;4;FLOAT3;0;FLOAT3;18;FLOAT;1;FLOAT3;2
Node;AmplifyShaderEditor.TransformPositionNode;93;-1779.362,-1292.342;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;97;-1748.908,-999.644;Inherit;False;Property;_Zwindspeed;Z wind speed;3;0;Create;True;0;0;0;False;0;False;-0.7467601;0;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1749.825,-1102.419;Inherit;False;Property;_Xwindspeed;X wind speed;4;0;Create;True;0;0;0;False;0;False;-0.14;3.548162;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-1283.448,-1098.655;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;95;-1279.304,-1231.087;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;94;-1033.016,-1179.245;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;100;-790.8859,-1082.014;Inherit;False;2;2;0;FLOAT2;21.98,14.45;False;1;FLOAT2;17.34,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-1044.397,-1395.755;Inherit;False;Property;_Noisescale;Noise scale;5;0;Create;True;0;0;0;False;0;False;0;0.175;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;92;-616.5799,-1320.791;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;99;-617.9018,-1145.221;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;103;-392.8344,-1143.069;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;102;-403.5227,-1320.113;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;120;-6.508301,-1189.292;Inherit;False;1054.905;308.4987;Compute rotation axis accoring to the generated random direction;4;62;110;101;90;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;117;234.0617,-622.0281;Inherit;False;370.6834;187.0923;Rotate less if random distance is smaller;2;111;112;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-1910.992,-527.4532;Inherit;False;RelativePos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;116;93.46825,-400.2312;Inherit;False;766.2999;141.5;Relative distance of the vertex, vertices close the to pivot will move less than the one further away;2;91;121;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;101;43.4917,-1136.426;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;141.4797,-343.1382;Inherit;False;113;RelativePos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;112;284.0617,-569.9358;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TransformDirectionNode;90;233.0531,-1139.292;Inherit;False;World;Object;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;119;1471.107,-424.5119;Inherit;False;864.0295;406.4122;Rotate vertex position;3;114;61;73;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LengthOpNode;91;346.5437,-339.8169;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;658.5183,-769.7291;Inherit;False;Property;_Rotation;Rotation;2;0;Create;True;0;0;0;False;0;False;0.2816087;0.35;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;65;706.9924,-663.6354;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;111;448.7452,-572.0281;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;62;560.4766,-1015.793;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;1521.107,-141.9531;Inherit;False;113;RelativePos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;110;873.3964,-1032.166;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;118;1528.811,-1066.393;Inherit;False;593.3282;390.919;Rotate normal;2;79;78;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;1071.277,-639.6025;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;61;1814.267,-374.5119;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;78;1578.811,-858.4739;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;2627.895,-832.8642;Inherit;False;Property;_Roughness;Roughness;0;0;Create;True;0;0;0;False;0;False;0.8315013;0.723;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;2817.509,-1109.045;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0.2057227,0.6509434,0.2470478,0;0.7759625,0.8018868,0.6241099,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;32;2929.45,-827.9581;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;73;2169.137,-153.0997;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;79;1802.139,-1016.393;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3178.51,-768.2437;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;PivotBaking/PB_VFX4;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;93;0;46;0
WireConnection;98;0;96;0
WireConnection;98;1;97;0
WireConnection;95;0;93;1
WireConnection;95;1;93;3
WireConnection;94;0;95;0
WireConnection;94;2;98;0
WireConnection;100;1;94;0
WireConnection;92;0;94;0
WireConnection;92;1;105;0
WireConnection;99;0;100;0
WireConnection;99;1;105;0
WireConnection;103;0;99;0
WireConnection;102;0;92;0
WireConnection;113;0;46;18
WireConnection;101;0;102;0
WireConnection;101;2;103;0
WireConnection;112;0;102;0
WireConnection;112;1;103;0
WireConnection;90;0;101;0
WireConnection;91;0;121;0
WireConnection;111;0;112;0
WireConnection;62;0;90;0
WireConnection;62;1;46;2
WireConnection;110;0;62;0
WireConnection;64;0;87;0
WireConnection;64;1;65;0
WireConnection;64;2;111;0
WireConnection;64;3;91;0
WireConnection;61;0;110;0
WireConnection;61;1;64;0
WireConnection;61;3;114;0
WireConnection;32;0;30;0
WireConnection;73;0;61;0
WireConnection;73;1;114;0
WireConnection;79;0;110;0
WireConnection;79;1;64;0
WireConnection;79;3;78;0
WireConnection;0;0;1;0
WireConnection;0;4;32;0
WireConnection;0;11;73;0
WireConnection;0;12;79;0
ASEEND*/
//CHKSM=7DE63BA3462EEE67183B3D00A73C0C67A11A95D0