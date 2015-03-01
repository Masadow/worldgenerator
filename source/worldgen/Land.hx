package worldgen;
import com.nodename.delaunay.Voronoi;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author Masadow
 */
class Land
{
	private var polygons : Array<Polygon>;
	private var tinfo : ITile;
    public var mapData(default, null) : Array<Int>;

	public function new(polygons : Array<Polygon>, voronoi : Voronoi, config : Config, tinfo : ITile, widthInTiles : Int, heightInTiles : Int)
	{
		this.polygons = polygons;
		this.tinfo = tinfo;

		var noise : Array<Array<Float>> = config.noise.compute(config);

        var s = new FlxSprite();
        s.makeGraphic(Std.int(config.layerBounds.width), Std.int(config.layerBounds.height));
		for (polygon in polygons)
		{
			if (noise[Std.int(polygon.x)][Std.int(polygon.y)] > config.mountainLevel)
				polygon.kind = tinfo.mountain();
			else if (noise[Std.int(polygon.x)][Std.int(polygon.y)] > config.waterLevel)
				polygon.kind = tinfo.grass();
			else if (noise[Std.int(polygon.x)][Std.int(polygon.y)] > config.deepWaterLevel)
				polygon.kind = tinfo.coast();
            polygon.draw(s, tinfo, false);
		}

        //Need improvement !
        //Actually write the voronoi to a bitmap so we can check which region pixels belongs to
        mapData = new Array<Int>();
        var widthScale : Int = Std.int(config.layerBounds.width / widthInTiles);
        var heightScale : Int = Std.int(config.layerBounds.height / heightInTiles);
        for (tj in 0... heightInTiles) { //for each tiles
            for (ti in 0... widthInTiles) {
                var counters = new Map<Int, Int>();
                for (j in 0...heightScale) {//for pixels in tile
                    for (i in 0...widthScale) {
                        var x : Int = Std.int(ti * (config.layerBounds.width / widthInTiles) + i);
                        var y : Int = Std.int(tj * (config.layerBounds.height / heightInTiles) + j);
                        var pixel = s.pixels.getPixel(x, y);
                        if (counters.exists(pixel)) {
                            counters.set(pixel, counters.get(pixel) + 1);
                        }
                        else {
                            counters.set(pixel, 1);
                        }
                    }
                }
                //Most averaged value will constitute the tile value
                var bestKey = counters.keys().next();
                var bestValue = counters[bestKey];
                for (key in counters.keys()) {
                    if (bestValue < counters[key]) {
                        bestKey = key;
                        bestValue = counters[key];
                    }
                }
                mapData.push(bestKey);
            }
        }
	}

	public function draw(sprite : FlxSprite)
	{
		for (polygon in polygons)
		{
			polygon.draw(sprite, tinfo);
		}
	}
}