# KiriSplat

KiriSplat is a decals system for Godot 3.2.

## Installation

Clone, extract, or move the addon into the "addons" directory in your
Godot project.

Example:

    cd PATH_TO_YOUR_PROJECT
    mkdir -p addons
    cd addons
    git clone https://github.com/ExpiredPopsicle/KiriSplat.git

Open your project settings in the editor. Go to *Project->Project
Settings*, switch to the *Plugins* tab, and make sure the *status*
column for *KiriSplat* shows *Active*. If it does not, click the
*Inactive* text, and switch it to *Active* in the drop-down menu.

## Use

Instantiate a new KiriSplatInstance in the scene. You will initially
see nothing.

Add a simple mesh object to the scene to render the splat on. This
could be a CSG object, MeshInstance, or other.

Add the new mesh object to the "splattable" group. Under the *Node*
tab, enter the *Groups* tab. Type "splattable" in the text field next
to the *Add* button and then click the *Add* button.

Move the splat object so that its bounding box covers the mesh. The
splat should appear on the mesh.

## Splat mesh updates

Note that splats only update when they move, so if a "splattable"
object moves into it, it will not show up with the splat until the
splat itself moves. Manually calling **rescan_all_nodes()** can force
a splat to update with new geometry.

## "splattable" and "not_splattable" groups

All objects in the "splattable" group *and their children* will be
scanned for usable mesh data.

If you want to add a mesh as a child of a "splattable" object and
*not* have it receive splats, simply use the "not_splattable" group.
By setting this group, the object and its children will not be
considered for splat geometry generation.

## Changing the material

The *material* variable on the splat object can be set to an arbitrary
material, either through the editor or through a script (use
**set_material()**).

Check out the **KiriSplat_defaultMaterial** and
**KiriSplat_defaultMaterialShader** for an example of a shader
material that fades as the splat away the further it moves from the
center plane. The example shader also manually clamps the edges of the
splat, and shifts the vertices slightly towards the camera so it
consistently renders in front of the source geometry.

