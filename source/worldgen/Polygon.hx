package worldgen;

import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;

/**
 * ...
 * @author Masadow
 */
class Polygon
{
	private var vertices : Array<Point>;
	private var centroid : Point;
	public var kind : Int;
	public var x(get, never) : Int;
	public var y(get, never) : Int;
	
	public function get_x() : Int
	{
		return Std.int(centroid.x);
	}
	
	public function get_y() : Int
	{
		return Std.int(centroid.y);
	}

	public function new(vertices : Array<Point>, kind : Int)
	{
		this.vertices = vertices;
		this.kind = kind;
		
		centroid = Helper.computeCentroid(vertices);
	}
	
	public function draw(sprite : FlxSprite, tinfo : ITile, realColors : Bool = true)
	{
		var flxVertices = new Array<FlxPoint>();
		for (vertice in vertices)
		{
			flxVertices.push(FlxPoint.weak(vertice.x, vertice.y));
		}
        var color = FlxColor.BLACK | kind;
        if (realColors) {
            color = FlxColor.BLACK;
            if (kind == tinfo.deepOcean())
                color = FlxColor.BLUE;
            else if (kind == tinfo.coast())
                color = 0xFF8080FF; //Light blue
            else if (kind == tinfo.grass())
                color = FlxColor.GREEN;
            else if (kind == tinfo.mountain())
                color = FlxColor.GRAY;
        }
		FlxSpriteUtil.drawPolygon(sprite, flxVertices, color, {color:color, thickness: 1});
	}
}