package;

import iron.App;
import iron.Scene;
import iron.RenderPath;
import iron.data.*;
import iron.data.SceneFormat;
import iron.object.Object;
import trilateral.tri.*;
import trilateral.geom.*;
import trilateral.path.*;
import trilateral.justPath.*;
import trilateral.angle.*;
import trilateral.polys.*;
import trilateral.angle.*;
import trilateral.tri.Triangle;
import trilateral.path.Fine;
import trilateral.tri.TriangleArray;
import trilateral.parsing.svg.Svg;
import trilateral.tri.TriangleGradient;
import trilateralXtra.parsing.FillDrawTess2;
import trilateral.parsing.FillDraw;
import trilateral.nodule.*;
import iron.helper.IronHelper;
import iron.helper.MultiColorMesh;
import iron.helper.MaterialMeshHelper;
import trilateralXtra.color.AppColors;
import trilateral.justPath.transform.ScaleContext;
import trilateral.justPath.transform.ScaleTranslateContext;
import trilateral.justPath.transform.TranslationContext;
import iron.math.Vec4;
import iron.math.Mat4;
import kha.Color;
import kha.Assets;
import htmlHelper.tools.AnimateTimer;
typedef DrawData = {
    var triangles:  TriangleArray;
    var edges:      Array<Array<Float>>;
}
class Main {
    public static var wid     = 800;
    public static var hi      = 600;
    public static var bgColor = 0xff6495ED;
    // controls the depth of the logo
    public static var depth   = 0.3;
    // controls the reduction in brightness of color channels.
    public static var fractionColor = 1/2.2;
    // turn random colors on off.
    public static var randomColors = true ;
    var ironHelper:     IronHelper;
    var fillDraw:       FillDraw;
    var colorMesh:      MultiColorMesh;
    var sceneName       = "Scene";
    var cameraName      = 'MyCamera';
    var cameraDataName  = 'MyCameraData';
    var stageRadius     = 600.;
    var appColors:      Array<AppColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
                                           , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
                                           , BlueAlpha, GreenAlpha, RedAlpha ];
    public static function main() {
        kha.System.init( { title: "Iron with Trilateral"
                         , width: wid, height: hi
                         , samplesPerPixel: 4 }, function(){
            new Main();
        });
    }
    public function new(){
        fillDraw = new FillDrawTess2( wid, hi );
        Assets.loadEverything( loadAll );
    }
    function loadAll(){
        ironHelper       = new IronHelper( sceneName
                                         , cameraName
                                         , cameraDataName
                                         , [ 'svgMesh' ]
                                         , bgColor );
        ironHelper.ready = sceneReady;
        ironHelper.create();
    }
    function sceneReady( scene: Object ) {
        svgToTriangles( Assets.blobs.salsaLogo_svg.toString() );
        meshCreate();
    }
    function svgToTriangles( svgStr: String ): FillDraw {
        var nodule: Nodule  = ReadXML.toNodule( svgStr );
        var svg: Svg        = new Svg( nodule );
        // randomColors controls if the face is rendered with random colors.
        svg.render( fillDraw, randomColors );
        return fillDraw;
    }
    function meshCreate( ){
        objCount = 1;
        createObj( 'svg', 'svgMesh'
                 , fillDraw.triangles, fillDraw.contours
                 , 0.3, fillDraw.colors, fillDraw.contourColors );               
    }
    public
    function createObj( nom: String, meshNom: String
                      , triangles_: TriangleArray, edges_: Array<Array<Float>>
                      , depth: Float
                      , colors_: Array<Color>, contourColors_:Array<Color> ){
        var mesh             = new MultiColorMesh( meshNom, wid, hi, depth, fractionColor, randomColors );
        var mm = new MaterialMeshHelper( ironHelper.raw
                                       , cast mesh
                                       , triangles_
                                       , edges_
                                       , colors_
                                       , contourColors_
                                       , nom );
        mm.ready = adjustPositions;
        mm.create();
    }
    function findColorID( col: AppColors ){
        return appColors.indexOf( col );
    }
    var ready = 0;
    var objCount = 0;
    function adjustPositions( o: Object ){
        ready++;
        if( ready < objCount ) return;
        trace( 'ready' );
        AnimateTimer.create();
        AnimateTimer.onFrame = render;
    }
    var theta = Math.PI/4;
    var rot   = new Vec4( -Math.PI/6, Math.PI/4, Math.PI/7 );
    function render( t:Int ):Void{
        var svg = Scene.active.getChild( 'svg' );
        svg.transform.rotate( rot, 0.05 );
        var v   = new Vec4( Math.sin( theta+=0.01 )
                          , Math.cos( theta+=0.01 )
                          , Math.sin( theta+=0.01 ) );
        svg.transform.move( v, 0.003 );
    }
}
