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

    //Based on the Bresenham's circle Algorithm but implementation might be wrong
    //http://stackoverflow.com/questions/14034628/algorithm-to-access-the-tiles-in-a-matrix-game-map-that-are-in-a-disc
    public static function checkTilesInCircle(center_x : Int, center_y : Int, radius : Int, callback : Int -> Int -> Bool) {
        // Bresenham's Circle Algorithm
        var x : Int, y : Int, d : Int, deltaE : Int, deltaSE: Int;

        x = 0;
        y = radius;
        d = 1 - radius;
        deltaE = 3;
        // -2 * radius + 5
        deltaSE = -(radius << 1) + 5;

        while(y > x) {
            if(d < 0) {
                d += deltaE;
                deltaE  += 2;
                deltaSE += 2;
            } else {
                d += deltaSE;
                deltaE  += 2;
                deltaSE += 4;
                y--;
            }
            if (!checkTiles(x++, y, center_x, center_y, callback))
                return false;
        }
        return true;
    }

    private static function checkTiles(x : Int, y : Int, center_x : Int, center_y : Int, callback : Int -> Int -> Bool) {
        // here, you iterate tiles up-to-down from ( x + center_x, -y + center_y) to (x + center_x, y + center_y) 
        // in one straigh line using a for loop
        for (j in -y + center_y ... y + center_y) 
            if (!callback(x + center_x, j))
                return false;

        // Iterate tiles up-to-down from ( y + center_x, -x + center_y) to ( y + center_x,  x + center_y)
        for (j in -x + center_y ... x + center_y) 
            if (!callback(y + center_x, j))
                return false;

        // Iterate tiles up-to-down from (-x + center_x, -y + center_y) to (-x + center_x,  y + center_y)
        for (j in -y + center_y ... y + center_y) 
            if (!callback( -x + center_x, j))
                return false;

        // here, you iterate tiles up-to-down from (-y + center_x, -x + center_y) to (-y + center_x, x + center_y)
        for (j in -x + center_y ... x + center_y) 
            if (!callback( -y + center_x, j))
                return false;

        return true;
    }
}