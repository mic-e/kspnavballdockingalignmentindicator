using System;
using UnityEngine;
using KSP.IO;

[KSPAddon(KSPAddon.Startup.Flight, false)]
public class NavBallDockingAlignmentIndicator : MonoBehaviour
{
	private NavBall navBallBehaviour;
	private GameObject indicator;

	public void Start()
	{
		PluginConfiguration cfg = KSP.IO.PluginConfiguration.CreateForType<NavBallDockingAlignmentIndicator>();
		cfg.load();
		Vector3 tmp = cfg.GetValue<Vector3>("alignmentmarkercolor", new Vector3(1f, 0f, 0f)); // default: red
		Color alignmentmarkercolor = new Color(tmp.x, tmp.y, tmp.z);
		Vector2 alignmentmarkertexture = cfg.GetValue<Vector2>("alignmentmarkertexture", new Vector2(0f, 2f)); // default: prograde marker
		cfg.save();
		float texturescalefactor = 1f / 3f;

		// get navball object
		GameObject navBall = GameObject.Find("NavBall");
		Transform navBallVectorsPivotTransform = navBall.transform.FindChild("vectorsPivot");
		navBallBehaviour = navBall.GetComponent<NavBall>();

		// get indicator texture (use the prograde marker, since it has a clear 'upwards' direction)
		ManeuverGizmo maneuverGizmo = MapView.ManeuverNodePrefab.GetComponent<ManeuverGizmo>();
		ManeuverGizmoHandle maneuverGizmoHandle = maneuverGizmo.handleNormal;
		Transform transform = maneuverGizmoHandle.flag;
		Renderer renderer = transform.renderer;
		Material maneuverTexture = renderer.sharedMaterial;

		// create alignment indicator game object
		indicator = Create2DObject(
			name: "navballalignmentindicator",
			size: 0.025f, // the same size as all other markers
			col: alignmentmarkercolor,
			texture: maneuverTexture,
			textureScale: Vector2.one * texturescalefactor,
			textureOffset: alignmentmarkertexture * texturescalefactor,
			parentTransform: navBallVectorsPivotTransform,
			layer: 12 // the navball layer
		);
	}

	private GameObject Create2DObject(
		string name,
		float size,
		Color col,
		Material texture,
		Vector2 textureScale,
		Vector2 textureOffset,
		Transform parentTransform,
		int layer)
	{
		GameObject o = new GameObject(name);
		Mesh m = new Mesh();
		MeshFilter meshFilter = o.AddComponent<MeshFilter>();
		o.AddComponent<MeshRenderer>();

		const float uvize = 1f;

		Vector3 p0 = new Vector3(-size, 0, size);
		Vector3 p1 = new Vector3(size, 0, size);
		Vector3 p2 = new Vector3(-size, 0, -size);
		Vector3 p3 = new Vector3(size, 0, -size);

		m.vertices = new[]
		{
			p0, p1, p2,
			p1, p3, p2
		};

		m.triangles = new[]
		{
			0, 1, 2,
			3, 4, 5
		};

		Vector2 uv1 = new Vector2(0, 0);
		Vector2 uv2 = new Vector2(uvize, uvize);
		Vector2 uv3 = new Vector2(0, uvize);
		Vector2 uv4 = new Vector2(uvize, 0);

		m.uv = new[]{
			uv1, uv4, uv3,
			uv4, uv2, uv3
		};

		m.RecalculateNormals();
		m.RecalculateBounds();
		m.Optimize();

		meshFilter.mesh = m;

		o.layer = layer;
		o.transform.parent = parentTransform;
		o.transform.localPosition = Vector3.zero;
		o.transform.localRotation = Quaternion.Euler(90f, 180f, 0);

		o.renderer.sharedMaterial = new Material(texture);
		o.renderer.sharedMaterial.mainTextureScale = textureScale;
		o.renderer.sharedMaterial.mainTextureOffset = textureOffset;
		o.renderer.sharedMaterial.color = col;

		return o;
	}

	public void LateUpdate()
	{
		if(FlightGlobals.ready == false) {
			return;
		}

		if(FlightGlobals.fetch != null) {
			if(FlightGlobals.fetch.VesselTarget != null) {
				if(FlightGlobals.fetch.VesselTarget.GetTargetingMode() == VesselTargetModes.DirectionVelocityAndOrientation) {
					ITargetable targetPort = FlightGlobals.fetch.VesselTarget;
					Transform targetTransform = targetPort.GetTransform();
					Transform selfTransform = FlightGlobals.ActiveVessel.ReferenceTransform;

					// indicator position
					Vector3 targetPortOutVector = targetTransform.forward.normalized;
					Vector3 targetPortInVector = -targetPortOutVector;
					Vector3 rotatedTargetPortInVector = navBallBehaviour.attitudeGymbal * targetPortInVector;
					indicator.transform.localPosition = rotatedTargetPortInVector * navBallBehaviour.progradeVector.localPosition.magnitude;

					// indicator rotation
					Vector3 v1 = Vector3.Cross(selfTransform.up, -targetTransform.up);
					Vector3 v2 = Vector3.Cross(selfTransform.up, selfTransform.forward);
					float ang = Vector3.Angle(v1, v2);
					if(Vector3.Dot(selfTransform.up, Vector3.Cross(v1, v2)) < 0) {
						ang = -ang;
					}
					indicator.transform.rotation = Quaternion.Euler(90 + ang, 90, 270);

					// indicator visibility (invisible if on back half sphere)
					indicator.SetActive(indicator.transform.localPosition.z > 0.0d);

					return;
				}
			}
		}

		// no docking port is currently selected
		indicator.SetActive(false);
		return;
	}
}
