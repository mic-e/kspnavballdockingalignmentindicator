### How to install

Like pretty much every mod, copy the content of GameData to GameData in your KSP folder.

### How to use

Select a docking port as target.
An additional red marker will appear, indicating the direction your docking port needs to face to be parallel to the target docking port.

This mod is basically a light-weight version of NavyFish's Docking Port Alignment Indicator mod, using only a single marker on the navball instead of a whole new window.

### How to configure

After the first start, there will be a text file at KSP_DIR/GameData/NavBallDockingAlignmentIndicator/PluginData/NavBallDockingAlignmentIndicator/config.xml, which you can edit to adjust the marker color and texture (the color is a vector3 of rgb, the texture is a vector2 of x, y subtexture position on [this texture](https://github.com/kitoban/EnhancedNavBall/blob/master/materialRef.JPG)).

The default values are (1, 0, 0) (red) and (0, 2) (the prograde marker).

### How to manually build

Use the included Makefile (or an development environment, if you wish to)

### Changelog

v0, 2013-10-20, KSP 0.22:

Initial release

v1, 2013-12-18, KSP 0.23:

Updated for KSP 0.23, changed ZIP folder structure

v2, 2013-12-18, KSP 0.23:

Made marker color and texture manually configurable

v3, 2014-05-10, KSP 0.23.5:

Instead of just docking ports, all parts that provide targeting information
are now supported. This is mostly relevant for other mods.

v4, 2014-07-18, KSP 0.24:

Updated for KSP 0.24, changed readme file

v5, 2014-10-17, KSP 0.25:

Updated for KSP 0.25

v6, 2014-12-19, KSP 0.90:

Updated for KSP 0.90, changed ZIP folder structure

v7, 2015-05-24, KSP 1.02:

Re-built for KSP 1.02 to fix issues some people reported

### URLs

- [Github](https://github.com/mic-e/kspnavballdockingalignmentindicator)
- [Forum](http://forum.kerbalspaceprogram.com/threads/54303)

### Credits

- NavyFish, creator of [Docking Alignment Indicator](http://kerbalspaceport.com/dock-align-indicator/)
- kitoban, creator of [Enhanced Navball](http://kerbalspaceport.com/enhancednavball/)
- taniwha, for the v2->v3 update

### License

This code is licensed under the GNU General Public License version 3, or, at your choice, any higher version.
