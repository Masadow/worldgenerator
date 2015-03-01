package worldgen;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.text.FlxText;

using flixel.util.FlxArrayUtil;

/**
 * ...
 * @author Masadow
 */
class Village extends FlxGroup
{
    private static var nameLeft : Array<String> = new Array<String>();
    
    public static function isBuildable(tile : Int, tinfo : ITile) {
        return tile == tinfo.grass();
    }
    
    public static function spawn(world : World) {
        var mapData = world.tilemap.getData();
        for (i in 0...mapData.length) {
            if (isBuildable(mapData[i], world.tinfo) && Math.random() < world.config.villages.spawnRate) {
                var x = i % world.tilemap.widthInTiles;
                var y = Math.floor(i / world.tilemap.widthInTiles);
                if (Helper.checkTilesInCircle(x, y, world.config.villages.minDistance, function (x, y) {
                    return world.tilemap.getTile(x, y) != world.tinfo.village();
                }))
                    world.villages.add(new Village(world, new FlxPoint(x, y)));
            }
        }
    }
   
    //World coordinates of the village
    public var worldPos(default, null) : FlxPoint;
    private var text : FlxText;
    private var world : World;
    public var name : String;

    public function new(world : World, coords : FlxPoint)
    {
        super();
        this.world = world;
        worldPos = coords;

        //Pick a name from bank
        if (nameLeft.length == 0) {
            nameLeft = world.config.villages.nameBank.copy();
        }
        name = world.random.getObject(nameLeft);
        nameLeft.fastSplice(name);
        
        add((text = new FlxText(0, 0, 0, name)));
        text.borderColor = 0xFFFF0000;
        text.autoSize = true;

        world.tilemap.setTile(Std.int(coords.x), Std.int(coords.y), world.tinfo.village());
    }
    
    override public function draw() {
        text.x = world.tilemap.x + world.tinfo.width() * worldPos.x * world.tilemap.scale.x - text.width * 0.5;
        text.y = world.tilemap.y + world.tinfo.height() * worldPos.y * world.tilemap.scale.y;
        super.draw();
    }
    
}