using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
public class HeroPosition : MonoBehaviour
{
    public float HeroSpeed = 1.0f;

    void Update()
    {
        Vector3 pos = transform.position;

        float multiplier = Input.GetKey(KeyCode.LeftShift)?0.2f:1.0f;

        pos.z += Input.GetAxis("Horizontal") * HeroSpeed * multiplier * Time.deltaTime;
        pos.x -= Input.GetAxis("Vertical") * HeroSpeed * multiplier * Time.deltaTime;
        transform.position = pos;

        Shader.SetGlobalVector("HeroPosition", transform.position);
    }
}
