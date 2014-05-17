package worldgen;

import flash.geom.Point;

/**
 * ...
 * @author Masadow
 */
class Helper
{
	public static function computeCentroid(polygon : Array<Point>) : Point
	{
		var centroid = new Point();
		var preVertice : Null<Point> = null;
		var area : Float = 0;
		for (vertice in polygon)
		{
			if (preVertice == null)
			{
				preVertice = polygon[polygon.length - 1];
			}
			var z = preVertice.x * vertice.y - vertice.x * preVertice.y;
			area += z;
			centroid.x += z * (preVertice.x + vertice.x);
			centroid.y += z * (preVertice.y + vertice.y);
			preVertice = vertice;
		}
		area *= 0.5;
		centroid.x /= 6 * area;
		centroid.y /= 6 * area;
		return centroid;
	}	
}