package iron.helper;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import kha.arrays.Float32Array;
import kha.arrays.Uint32Array;
import kha.arrays.Int16Array;
import iron.data.*;
import iron.data.SceneFormat;
import trilateral.arr.ArrayPairs;
import kha.Color;
class MultiColorMesh {
    inline static var scalar =     32767;
    inline static var vert =         'painter_colored_iron.vert';
    inline static var frag =         'painter_colored_iron.frag';
    inline static var materialName = 'MultiColorMaterial';
    inline static var shaderName   = 'MultiColorShader';
    inline static var mesh_object  = 'mesh_object';
    inline static var worldMatrix  = '_worldViewProjectionMatrix';
    var meshName:   String;
    var vb:         Int16Array;
    var ib:         Uint32Array;
    var col:        Int16Array;
    var wid:        Int;
    var hi:         Int;
    var length:     Int = 0;
    var z: Float    = 0.;
    var depth: Float;
    var fractionColor: Float;
    var randomColors: Bool = false;
    public function new(  meshName_: String
                        , wid_: Int, hi_: Int
                        , depth_:         Float
                        , fractionColor_: Float
                        , randomColors_:  Bool ){
        meshName = meshName_;
        wid = wid_;
        hi = hi_;
        depth = depth_;
        fractionColor = fractionColor_;
        randomColors = randomColors_;
    }
    public function draw( triangles:     TriangleArray
                        , contours:      Array<Array<Float>>
                        , colors:        Array<Color>
                        , contourColors: Array<Int> ){
        var tri: Triangle;
        var clen = 0;
        for( i in 0...contours.length ) clen += contours[ i ].length*2*2; // x2 as reversed
        var len = length + Std.int( triangles.length );
        vb  = new Int16Array( Std.int( 8*( len*2*2*2 + clen ) ) );
        ib  = new Uint32Array(  Std.int( 3*( len*2*2*2 + clen ) ) );
        col = new Int16Array( Std.int( 8*( len*2*2*2 + clen ) ) );
        var j = 0;
        var k = 0;
        var c = 0;
        var scaleX = scalar/wid;
        var scaleY = scalar/hi;
        var offX = wid/2;
        var offY = hi/2;
        var color: Int;
        var a: Int;
        var r: Int;
        var g: Int;
        var b: Int;
        var z0 = Std.int( ( z + depth/2 )*scalar );
        var z1 = Std.int( ( z - depth/2 - 0.01 )*scalar );
        var ax: Int = 0;
        var ay: Int = 0;
        var bx: Int = 0;
        var by: Int = 0;
        var cx: Int = 0;
        var cy: Int = 0;
        var alpha = 0.9;
        var fracColor = fractionColor*scalar;
        for( i in length...len ){
            tri = triangles[ i ];
            ax = Std.int( ( tri.ax - offX ) * scaleX  );
            ay = Std.int( -( tri.ay - offY ) * scaleY );
            bx = Std.int( ( tri.bx - offX ) * scaleX );
            by = Std.int( -( tri.by - offY ) * scaleY );
            cx = Std.int( ( tri.cx - offX ) * scaleX );
            cy = Std.int( -( tri.cy - offY ) * scaleY );
            color = colors[ tri.colorID ];
            a = Std.int( scalar * alpha );
            r = Std.int( _r( color )*scalar );
            g = Std.int( _g( color )*scalar );
            b = Std.int( _b( color )*scalar );
            
            vb[ j++ ] = ax;
            vb[ j++ ] = ay;
            vb[ j++ ] = z0;
            vb[ j++ ] = 0;
            vb[ j++ ] = bx;
            vb[ j++ ] = by;
            vb[ j++ ] = z0;
            vb[ j++ ] = 0;
            vb[ j++ ] = cx;
            vb[ j++ ] = cy;
            vb[ j++ ] = z0;
            vb[ j++ ] = 0;
            
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = a;
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = a;
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = a;
            ib[ k ] = k++;
            ib[ k ] = k++;
            ib[ k ] = k++;
            
            vb[ j++ ] = bx;
            vb[ j++ ] = by;
            vb[ j++ ] = z0;
            vb[ j++ ] = 0;
            vb[ j++ ] = ax;
            vb[ j++ ] = ay;
            vb[ j++ ] = z0;
            vb[ j++ ] = 0;
            vb[ j++ ] = cx;
            vb[ j++ ] = cy;
            vb[ j++ ] = z0;
            vb[ j++ ] = 0;
            
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = a;
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = a;
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = a;
            ib[ k ] = k++;
            ib[ k ] = k++;
            ib[ k ] = k++;
            
            
            // back
            
            vb[ j++ ] = bx;
            vb[ j++ ] = by;
            vb[ j++ ] = z1;
            vb[ j++ ] = 0;            
            vb[ j++ ] = ax;
            vb[ j++ ] = ay;
            vb[ j++ ] = z1;
            vb[ j++ ] = 0;
            vb[ j++ ] = cx;
            vb[ j++ ] = cy;
            vb[ j++ ] = z1;
            vb[ j++ ] = 0;
            
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = a;
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = a;
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = a;
            ib[ k ] = k++;
            ib[ k ] = k++;
            ib[ k ] = k++;
            
            vb[ j++ ] = ax;
            vb[ j++ ] = ay;
            vb[ j++ ] = z1;
            vb[ j++ ] = 0;            
            vb[ j++ ] = bx;
            vb[ j++ ] = by;
            vb[ j++ ] = z1;
            vb[ j++ ] = 0;
            vb[ j++ ] = cx;
            vb[ j++ ] = cy;
            vb[ j++ ] = z1;
            vb[ j++ ] = 0;
            
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = a;
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = a;
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = a;
            ib[ k ] = k++;
            ib[ k ] = k++;
            ib[ k ] = k++;
            
        }
        a = Std.int( scalar * alpha );
        r = Std.int( 1. * scalar );
        g = Std.int( 1. * scalar );
        b = Std.int( 1. * scalar );
        for( contour in 0...contours.length ){
            tri = triangles[ contour ];
            if( randomColors ){} else {
                color = colors[ contourColors[ contour ] ];
                a = Std.int( scalar * alpha );
                r = Std.int( _r( color )*fracColor );
                g = Std.int( _g( color )*fracColor );
                b = Std.int( _b( color )*fracColor );
            }
            var pairs = new ArrayPairs( contours[ contour ] );
            var p0: { x: Float, y: Float };
            var p1: { x: Float, y: Float };
            var count = triangles.length;
            for( i in 0...pairs.length-1 ){
                p0 = pairs[ i ];
                p1 = pairs[ i + 1 ];
                ax = Std.int( ( p0.x - offX ) * scaleX );
                ay = Std.int( -( p0.y - offY ) * scaleY );
                bx = Std.int( ( p1.x - offX ) * scaleX );
                by = Std.int( -( p1.y - offY ) * scaleY );
                if( randomColors ){
                    color = colors[ randomValue( colors.length ) ];
                    a = Std.int( scalar * alpha );
                    r = Std.int( _r( color )*fracColor );
                    g = Std.int( _g( color )*fracColor );
                    b = Std.int( _b( color )*fracColor );
                }
                vb[ j++ ] = ax;
                vb[ j++ ] = ay;
                vb[ j++ ] = z0;
                vb[ j++ ] = 0;
                vb[ j++ ] = bx;
                vb[ j++ ] = by;
                vb[ j++ ] = z0;
                vb[ j++ ] = 0;
                vb[ j++ ] = ax;
                vb[ j++ ] = ay;
                vb[ j++ ] = z1;
                vb[ j++ ] = 0;
                col[ c++ ] = r;
                col[ c++ ] = g;
                col[ c++ ] = b;
                col[ c++ ] = a;
                col[ c++ ] = r;
                col[ c++ ] = g;
                col[ c++ ] = b;
                col[ c++ ] = a;
                col[ c++ ] = r;
                col[ c++ ] = g;
                col[ c++ ] = b;
                col[ c++ ] = a;
                ib[ k ] = k++;
                ib[ k ] = k++;
                ib[ k ] = k++;
                // reversed                
                vb[ j++ ] = bx;
                vb[ j++ ] = by;
                vb[ j++ ] = z0;
                vb[ j++ ] = 0;
                vb[ j++ ] = ax;
                vb[ j++ ] = ay;
                vb[ j++ ] = z0;
                vb[ j++ ] = 0;
                vb[ j++ ] = ax;
                vb[ j++ ] = ay;
                vb[ j++ ] = z1;
                vb[ j++ ] = 0;
                col[ c++ ] = r;
                col[ c++ ] = g;
                col[ c++ ] = b;
                col[ c++ ] = a;
                col[ c++ ] = r;
                col[ c++ ] = g;
                col[ c++ ] = b;
                col[ c++ ] = a;
                col[ c++ ] = r;
                col[ c++ ] = g;
                col[ c++ ] = b;
                col[ c++ ] = a;
                ib[ k ] = k++;
                ib[ k ] = k++;
                ib[ k ] = k++;
                // Second triangle for contour
                if( randomColors ){
                    color = colors[ randomValue( colors.length ) ];
                    a = Std.int( scalar * alpha );
                    r = Std.int( _r( color )*fracColor );
                    g = Std.int( _g( color )*fracColor );
                    b = Std.int( _b( color )*fracColor );
                } 
                vb[ j++ ] = bx;
                vb[ j++ ] = by;
                vb[ j++ ] = z0;
                vb[ j++ ] = 0;                
                vb[ j++ ] = bx;
                vb[ j++ ] = by;
                vb[ j++ ] = z1;
                vb[ j++ ] = 0;
                vb[ j++ ] = ax;
                vb[ j++ ] = ay;
                vb[ j++ ] = z1;
                vb[ j++ ] = 0;
                col[ c++ ] = r;
                col[ c++ ] = g;
                col[ c++ ] = b;
                col[ c++ ] = a;
                col[ c++ ] = r;
                col[ c++ ] = g;
                col[ c++ ] = b;
                col[ c++ ] = a;
                col[ c++ ] = r;
                col[ c++ ] = g;
                col[ c++ ] = b;
                col[ c++ ] = a;
                ib[ k ] = k++;
                ib[ k ] = k++;
                ib[ k ] = k++;
                // reversed 
                vb[ j++ ] = bx;
                vb[ j++ ] = by;
                vb[ j++ ] = z1;
                vb[ j++ ] = 0;
                vb[ j++ ] = bx;
                vb[ j++ ] = by;
                vb[ j++ ] = z0;
                vb[ j++ ] = 0;
                vb[ j++ ] = ax;
                vb[ j++ ] = ay;
                vb[ j++ ] = z1;
                vb[ j++ ] = 0;
                col[ c++ ] = r;
                col[ c++ ] = g;
                col[ c++ ] = b;
                col[ c++ ] = a;
                col[ c++ ] = r;
                col[ c++ ] = g;
                col[ c++ ] = b;
                col[ c++ ] = a;
                col[ c++ ] = r;
                col[ c++ ] = g;
                col[ c++ ] = b;
                col[ c++ ] = a;
                ib[ k ] = k++;
                ib[ k ] = k++;
                ib[ k ] = k++;
                
            }
        }
    }
    public inline function randomValue( len: Float ): Int{
        return Std.int( Math.round( Math.random()*(len-1) ) );
    }
    public function triangleMeshCreate(): TMeshData{
        return {  name: meshName
               ,  vertex_arrays: [   { attrib: "pos", values: vb }
                                   , { attrib: "col", values: col }
                                   ]
               ,  index_arrays: [ { material: 0, values: ib } ] };
    }
    public function materialDataCreate(): TMaterialData {
        return { name:     materialName, shader: shaderName
               , contexts: [{ name: meshName, bind_constants: [] }] };
    }
    public function shaderDataCreate(): TShaderData {
        return { name: shaderName,
                 contexts: [{  name:              meshName
                             , vertex_shader:     vert
                             , fragment_shader:   frag
                             , compare_mode:      "less"
                             , cull_mode:         "clockwise"
                             , depth_write:       true
                         	 , blend_source:             "blend_one"
                         	 , blend_destination:        "inverse_source_alpha"
                             , alpha_blend_source:       "blend_one" //"source_alpha"
                             , alpha_blend_destination:  "inverse_source_alpha"
                         	//, blend_operation:          "blendEnabled"
                         	 //, alpha_blend_operation:    "blendEnabled"
                             , constants: [ {   "link": worldMatrix
                                            ,   "name": "WVP"
                                            ,   "type": "mat4" } ]   
                             , vertex_elements: [  { name: "pos", data: "short4norm" }
                                                 , { name: "col", data: "short4norm" } ]   
                             }] };
    }
    public function meshObjectCreate( objName: String = 'Triangles' ): TObj {
        return { name:          objName
               , type:          mesh_object
               , data_ref:      meshName
               , material_refs: [ materialName ]
               , transform:     null
               };
    }
    public static inline function _r( int: Int ) : Float
        return ((int >> 16) & 255) / 255;
    public static inline function _g( int: Int ) : Float
        return ((int >> 8) & 255) / 255;
    public static inline function _b( int: Int ) : Float
        return (int & 255) / 255;
}