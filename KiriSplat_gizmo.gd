extends EditorSpatialGizmoPlugin

var handles
var editor_interface = null

# Called when the node enters the scene tree for the first time.
func _ready():
	print("GIZMO READY")

func _init():
	print("GIZMO INIT")
	create_material("main", Color(0.5, 0.5, 1.0))
	create_handle_material("handles")

func get_name():
	return "KiriSplatInstance"

func has_gizmo(spatial):
	print("HAS GIZMO")
	#if not (spatial in editor_interface.get_selection()):
	#	return false
	return spatial is KiriSplatInstance

func redraw(gizmo):
	gizmo.clear()
	
	print("REDRAW")
	
	var node = gizmo.get_spatial_node()
	
	#if not node in editor_interface.get_selection():
	#	return
	
	var lines = PoolVector3Array()
	
	var left   = -node.width / 2.0
	var right  = node.width / 2.0
	var bottom = -node.height / 2.0
	var top    = node.height / 2.0
	var front  = -node.depth / 2.0
	var back   = node.depth / 2.0

	# Top
	lines.push_back(Vector3(left, top, back))
	lines.push_back(Vector3(left, top, front))

	lines.push_back(Vector3(right, top, back))
	lines.push_back(Vector3(right, top, front))

	lines.push_back(Vector3(left, top, back))
	lines.push_back(Vector3(right, top, back))

	lines.push_back(Vector3(left, top, front))
	lines.push_back(Vector3(right, top, front))

	# Bottom
	lines.push_back(Vector3(left, bottom, back))
	lines.push_back(Vector3(left, bottom, front))

	lines.push_back(Vector3(right, bottom, back))
	lines.push_back(Vector3(right, bottom, front))

	lines.push_back(Vector3(left, bottom, back))
	lines.push_back(Vector3(right, bottom, back))

	lines.push_back(Vector3(left, bottom, front))
	lines.push_back(Vector3(right, bottom, front))

	# Vertical lines
	lines.push_back(Vector3(left, top, back))
	lines.push_back(Vector3(left, bottom, back))

	lines.push_back(Vector3(right, top, back))
	lines.push_back(Vector3(right, bottom, back))

	lines.push_back(Vector3(left, top, front))
	lines.push_back(Vector3(left, bottom, front))

	lines.push_back(Vector3(right, top, front))
	lines.push_back(Vector3(right, bottom, front))


	gizmo.add_lines(lines, get_material("main", gizmo), false)
	
	
	
	handles = PoolVector3Array()
	handles.push_back(Vector3(left, 0.0, 0.0))
	handles.push_back(Vector3(right, 0.0, 0.0))
	handles.push_back(Vector3(0.0, top, 0.0))
	handles.push_back(Vector3(0.0, bottom, 0.0))
	handles.push_back(Vector3(0.0, 0.0, front))
	handles.push_back(Vector3(0.0, 0.0, back))
	
	gizmo.add_handles(handles, get_material("handles", gizmo), false)
	
	print("GIZMO REDRAW")

func commit_handle(gizmo, index, restore, cancel = false):
	print("COMMIT_HANDLE: ", index, " ", get_handle_value(gizmo, index))

#func set_handle(gizmo, index, camera, point):
#	print("SET_HANDLE: ", index, " ", get_handle_value(gizmo, index), " ", point)

func set_handle(gizmo, index, camera, point):

	print("SET_HANDLE: ", index, " ", point)
	
	var worldPos = \
		gizmo.get_spatial_node().get_global_transform() * handles[index]

	print("Original world pos:  ",
		worldPos)

	var unprojected = camera.unproject_position(worldPos)
	var cameraSpace = camera.get_camera_transform().affine_inverse() * worldPos

	print("Original screen pos: ",
		unprojected)

	print("New screen pos:      ",
		point)

	var newWorldPos = camera.project_position(
		#Vector2(unprojected.x, unprojected.y),
		point,
		-cameraSpace.z)
	print("New world pos:       ", newWorldPos)

	print("Obj space (old): ", handles[index])
	var newObjSpace = gizmo.get_spatial_node().get_global_transform().affine_inverse() * newWorldPos
	print("Obj space (new): ", newObjSpace)

	if index == 0 || index == 1:
		print("New width: ", abs(newObjSpace.x) * 2.0)
		gizmo.get_spatial_node().set_width(abs(newObjSpace.x) * 2.0)
	if index == 2 || index == 3:
		print("New height: ", abs(newObjSpace.y) * 2.0)
		gizmo.get_spatial_node().set_height(abs(newObjSpace.y) * 2.0)
	if index == 4 || index == 5:
		print("New depth: ", abs(newObjSpace.z) * 2.0)
		gizmo.get_spatial_node().set_depth(abs(newObjSpace.z) * 2.0)

	

	#camera.project_position(point, )
	
