using UnityEngine;

public class CharUtil : MonoBehaviour
{
    private Rigidbody rb;
    private void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    private void Update()
    {
        rb.velocity = Vector3.zero;
    }

    private void OnTriggerEnter(Collider other)
    {
        GameMgr.Instance.GameMain.OnCollide(gameObject.GetInstanceID(), other.gameObject.GetInstanceID());
    }
}

