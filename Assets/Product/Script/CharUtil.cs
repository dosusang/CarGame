using UnityEngine;

public class CharUtil : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        GameMgr.Instance.GameMain.OnCollide(gameObject.GetInstanceID(), other.gameObject.GetInstanceID());
    }
}

