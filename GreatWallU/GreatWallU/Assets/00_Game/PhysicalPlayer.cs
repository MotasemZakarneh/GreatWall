using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody2D))]
public class PhysicalPlayer : MonoBehaviour
{
    [SerializeField] float speed = 4;
    Vector2 input = new Vector2();

    Rigidbody2D rb2d = null;

    void Start()
    {
        rb2d = GetComponent<Rigidbody2D>();
    }
    void Update()
    {
        input.x = Input.GetAxis("Horizontal");
        input.y = Input.GetAxis("Vertical");
    }
    void FixedUpdate()
    {
        rb2d.velocity = input.normalized * speed;
    }
}