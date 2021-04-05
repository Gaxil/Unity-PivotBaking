// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PivotBaking/PB_VFX6"
{
	Properties
	{
		_Roughness("Roughness", Range( 0 , 1)) = 0.5909025
		_Color0("Color 0", Color) = (0.5127714,0.5207428,0.6509434,0)
		_Disappeardistance("Disappear distance", Range( -25 , 25)) = 0
		_Smoothness("Smoothness", Range( 0.01 , 10)) = 0
		_Floatingintensity("Floating intensity", Range( 0 , 1)) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
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

		uniform float3 HeroPosition;
		uniform sampler2D _TextureSample0;
		uniform float3 HeroCamMinPosition;
		uniform float3 HeroCamMaxPosition;
		uniform float _Floatingintensity;
		uniform float _Smoothness;
		uniform float _Disappeardistance;
		uniform float4 _Color0;
		uniform float _Roughness;


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
			float3 appendResult7_g7 = (float3(( v.texcoord2.xy.x * -1.0 ) , v.texcoord3.xy.x , ( v.texcoord2.xy.y * -1.0 )));
			float3 temp_output_16_0_g7 = ( 0.01 * appendResult7_g7 );
			float3 PivotAbsolutePosition103 = temp_output_16_0_g7;
			float3 objToWorld47 = mul( unity_ObjectToWorld, float4( PivotAbsolutePosition103, 1 ) ).xyz;
			float3 appendResult9_g7 = (float3(( 1.0 - v.color.r ) , v.color.b , v.color.g));
			float3 ForwardDirection111 = ( ( appendResult9_g7 - float3(0.5,0.5,0.5) ) * 2.0 );
			float3 normalizeResult77 = normalize( cross( ( objToWorld47 - HeroPosition ) , ForwardDirection111 ) );
			float3 objToWorld94 = mul( unity_ObjectToWorld, float4( PivotAbsolutePosition103, 1 ) ).xyz;
			float3 break89 = objToWorld94;
			float2 appendResult93 = (float2((0.0 + (break89.x - HeroCamMinPosition.x) * (1.0 - 0.0) / (HeroCamMaxPosition.x - HeroCamMinPosition.x)) , (0.0 + (break89.z - HeroCamMinPosition.z) * (1.0 - 0.0) / (HeroCamMaxPosition.z - HeroCamMinPosition.z))));
			float EffectIntensity116 = pow( saturate( ( ( ( tex2Dlod( _TextureSample0, float4( appendResult93, 0, 0.0) ).g - 0.1 ) * 1.2 ) + (0.0 + (( _SinTime.w * _Floatingintensity ) - -1.0) * (0.1 - 0.0) / (1.0 - -1.0)) ) ) , _Smoothness );
			float RandomValue109 = v.texcoord3.xy.y;
			float temp_output_64_0 = ( EffectIntensity116 * ( 4.0 * UNITY_PI ) * RandomValue109 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 PivotRelativePosition106 = ( ase_vertex3Pos - temp_output_16_0_g7 );
			float3 temp_output_74_0 = ( PivotRelativePosition106 * ( 1.0 - EffectIntensity116 ) );
			float3 rotatedValue61 = RotateAroundAxis( float3( 0,0,0 ), temp_output_74_0, normalizeResult77, temp_output_64_0 );
			v.vertex.xyz += ( ( rotatedValue61 - temp_output_74_0 ) + ( PivotRelativePosition106 * float3( -1,-1,-1 ) * EffectIntensity116 ) + ( ForwardDirection111 * EffectIntensity116 * _Disappeardistance ) );
			v.vertex.w = 1;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 rotatedValue79 = RotateAroundAxis( float3( 0,0,0 ), ase_vertexNormal, normalizeResult77, temp_output_64_0 );
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
1920;0;1920;1149;2141.592;738.6443;1.745816;True;False
Node;AmplifyShaderEditor.FunctionNode;46;-2841.495,-177.1906;Inherit;False;GetPivotInfo;-1;;7;b58e44ad5701a19499f0136a7117d015;0;0;4;FLOAT3;0;FLOAT3;18;FLOAT;1;FLOAT3;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;-2501.438,-365.8219;Inherit;False;PivotAbsolutePosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;121;-1919.515,-314.6263;Inherit;False;1784.417;652.8467;Access render texture where the initial mask is defined;9;91;90;88;92;93;87;89;104;94;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-1869.515,102.0242;Inherit;False;103;PivotAbsolutePosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformPositionNode;94;-1612.593,106.0063;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;90;-1325.526,-264.6263;Inherit;False;Global;HeroCamMinPosition;HeroCamMinPosition;8;0;Create;True;0;0;0;False;0;False;0,0,0;-6.31,-12.8,-20.2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;91;-1324.526,-101.6262;Inherit;False;Global;HeroCamMaxPosition;HeroCamMaxPosition;8;0;Create;True;0;0;0;False;0;False;0,0,0;33.69,27.2,19.8;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;89;-1377.183,100.5699;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TFHCRemapNode;92;-953.527,93.37379;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;88;-946.527,-101.6262;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;93;-684.5269,135.3735;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;122;-632.1823,362.7477;Inherit;False;1846.974;443.9651;Compute effect intensity and randomize it;11;86;82;85;99;97;101;100;102;81;80;116;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-582.1823,690.7129;Inherit;False;Property;_Floatingintensity;Floating intensity;4;0;Create;True;0;0;0;False;0;False;0;0.8965662;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;82;-527.3919,477.6255;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;87;-455.0974,108.2204;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;None;1aac20ed2e0a1884896b055f37a68224;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-203.5601,547.7286;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;102;-32.97425,412.7477;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;159.0697,414.2601;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;99;-24.63225,550.2543;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;418.0257,510.7477;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;474.8663,644.6075;Inherit;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;0;False;0;False;0;1.41;0.01;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;114;-316.0196,-1068.985;Inherit;False;1298.641;430.0683;Compute rotation axis (perpendicular to hero direction and sub object forward direction);7;105;47;48;76;77;112;62;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;97;604.0992,511.5398;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;80;801.7911,511.8447;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-266.0196,-1000.179;Inherit;False;103;PivotAbsolutePosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;990.7919,577.4366;Inherit;False;EffectIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;-2521.397,-20.16431;Inherit;False;ForwardDirection;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;125;1185.693,-768.8572;Inherit;False;1111.98;514.557;Vertex rotation;6;73;61;74;107;75;119;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;48;47.94246,-845.7009;Inherit;False;Global;HeroPosition;HeroPosition;1;0;Create;True;0;0;0;False;0;False;0,0,0;13.69,0.49,-0.2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;47;10.80185,-1018.985;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;119;1235.693,-370.3003;Inherit;False;116;EffectIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;126;602.3936,-616.7007;Inherit;False;513.2424;332.5364;Rotation angle;4;64;120;110;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-2482.438,-266.8219;Inherit;False;PivotRelativePosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;265.7713,-754.917;Inherit;False;111;ForwardDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;76;276.4945,-925.806;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-2505.397,-157.1643;Inherit;False;RandomValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;1377.061,-477.9215;Inherit;False;106;PivotRelativePosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;75;1441.075,-384.6195;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;665.6025,-400.1643;Inherit;False;109;RandomValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;65;671.0308,-481.4622;Inherit;False;1;0;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;62;566.3306,-831.4813;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;652.3936,-566.7007;Inherit;False;116;EffectIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;77;807.6218,-811.3126;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;124;1622.603,-231.1643;Inherit;False;476.2896;246.4637;Scaling;3;108;57;118;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;123;1618.318,34.83569;Inherit;False;532.184;324.7183;Translation;4;7;113;55;117;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;1619.044,-460.5294;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;953.636,-537.0399;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;61;1753.803,-718.8572;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;1706.394,-100.7006;Inherit;False;116;EffectIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;1672.603,-181.1643;Inherit;False;106;PivotRelativePosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;1735.394,165.2994;Inherit;False;116;EffectIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;1668.318,243.554;Inherit;False;Property;_Disappeardistance;Disappear distance;2;0;Create;True;0;0;0;False;0;False;0;-0.8;-25;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;1734.603,84.83569;Inherit;False;111;ForwardDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;115;1153.773,-1178.903;Inherit;False;708.197;358.9645;Rotate normal;2;79;78;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;73;2131.672,-465.4451;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;1988.502,135.5283;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;30;2460.899,-702.584;Inherit;False;Property;_Roughness;Roughness;0;0;Create;True;0;0;0;False;0;False;0.5909025;0.379;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;1936.892,-174.3485;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;-1,-1,-1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;78;1203.773,-1128.903;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;56;2460.46,-255.5891;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;32;2754.495,-665.4829;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;2726.759,-962.515;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0.5127714,0.5207428,0.6509434,0;0.7058823,0.361851,0.2823529,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotateAboutAxisNode;79;1541.97,-1002.938;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2990.663,-679.9268;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;PivotBaking/PB_VFX6;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;103;0;46;0
WireConnection;94;0;104;0
WireConnection;89;0;94;0
WireConnection;92;0;89;2
WireConnection;92;1;90;3
WireConnection;92;2;91;3
WireConnection;88;0;89;0
WireConnection;88;1;90;1
WireConnection;88;2;91;1
WireConnection;93;0;88;0
WireConnection;93;1;92;0
WireConnection;87;1;93;0
WireConnection;85;0;82;4
WireConnection;85;1;86;0
WireConnection;102;0;87;2
WireConnection;100;0;102;0
WireConnection;99;0;85;0
WireConnection;101;0;100;0
WireConnection;101;1;99;0
WireConnection;97;0;101;0
WireConnection;80;0;97;0
WireConnection;80;1;81;0
WireConnection;116;0;80;0
WireConnection;111;0;46;2
WireConnection;47;0;105;0
WireConnection;106;0;46;18
WireConnection;76;0;47;0
WireConnection;76;1;48;0
WireConnection;109;0;46;1
WireConnection;75;0;119;0
WireConnection;62;0;76;0
WireConnection;62;1;112;0
WireConnection;77;0;62;0
WireConnection;74;0;107;0
WireConnection;74;1;75;0
WireConnection;64;0;120;0
WireConnection;64;1;65;0
WireConnection;64;2;110;0
WireConnection;61;0;77;0
WireConnection;61;1;64;0
WireConnection;61;3;74;0
WireConnection;73;0;61;0
WireConnection;73;1;74;0
WireConnection;7;0;113;0
WireConnection;7;1;117;0
WireConnection;7;2;55;0
WireConnection;57;0;108;0
WireConnection;57;2;118;0
WireConnection;56;0;73;0
WireConnection;56;1;57;0
WireConnection;56;2;7;0
WireConnection;32;0;30;0
WireConnection;79;0;77;0
WireConnection;79;1;64;0
WireConnection;79;3;78;0
WireConnection;0;0;1;0
WireConnection;0;4;32;0
WireConnection;0;11;56;0
WireConnection;0;12;79;0
ASEEND*/
//CHKSM=98279A98207055D45294F7F6FE9FFF58F780E947