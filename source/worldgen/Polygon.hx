package worldgen;

import flash.geom.Point;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;

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
	
	public function draw(sprite : FlxSprite, tinfo : ITile)
	{
		var flxVertices = new Array<FlxPoint>();
		for (vertice in vertices)
		{
			flxVertices.push(FlxPoint.weak(vertice.x, vertice.y));
		}
		var color = FlxColor.BLACK;
		if (kind == tinfo.deepOcean())
			color = FlxColor.BLUE;
		else if (kind == tinfo.grass())
			color = FlxColor.FOREST_GREEN;
		else if (kind == tinfo.mountain())
			color = FlxColor.GRAY;
		FlxSpriteUtil.drawPolygon(sprite, flxVertices, color, {color:color, thickness: 1});
	}
}