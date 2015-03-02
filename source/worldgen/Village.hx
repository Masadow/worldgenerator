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
                })) {
                    world.villages.add(new Village(world, new FlxPoint(x, y)));
                }
            }
        }
    }
   
    //World coordinates of the village
    public var worldPos(default, null) : FlxPoint;
    private var text : FlxText;
    private var world : World;
    public var name : String;
    public var tiles : Array<FlxPoint>;

    public function new(world : World, coords : FlxPoint)
    {
        super();
        this.world = world;
        worldPos = coords;
        tiles = [coords];

        //Pick a name from bank
        if (nameLeft.length == 0) {
            nameLeft = world.config.villages.nameBank.copy();
        }
        name = world.random.getObject(nameLeft);
        nameLeft.fastSplice(name);
        
        add((text = new FlxText(0, 0, 0, name)));

        world.tilemap.setTile(Std.int(coords.x), Std.int(coords.y), world.tinfo.village());
        
        extend(world.random.int(world.config.villages.minSize, world.config.villages.maxSize) - 1);
        
        rescale();
    }
    
    public function rescale() {
        text.x = world.tilemap.x + world.tinfo.width() * worldPos.x * world.tilemap.scale.x - text.width * 0.5;
        text.y = world.tilemap.y + world.tinfo.height() * worldPos.y * world.tilemap.scale.y;
    }
    
    public function extend(size : Int) {
        var current = worldPos;
        switch (world.config.villages.shape) {
            case RANDOM:
                //Problems not handled
                //  * Not enough space remaining
                //  * Touching villages
                //Pick a non village neighboor tile
                while (size > 0) {
                    var exclude : Array<Int> = [];
                    if (current.x == 0 || !isBuildable(world.tilemap.getTile(Std.int(current.x - 1), Std.int(current.y)), world.tinfo))
                        exclude.push(0); //LEFT
                    if (current.y == 0 || !isBuildable(world.tilemap.getTile(Std.int(current.x), Std.int(current.y - 1)), world.tinfo))
                        exclude.push(1); //TOP
                    if (current.x == world.tilemap.widthInTiles - 1 || !isBuildable(world.tilemap.getTile(Std.int(current.x) + 1, Std.int(current.y)), world.tinfo))
                        exclude.push(2); //RIGHT
                    if (current.y == world.tilemap.heightInTiles - 1 || !isBuildable(world.tilemap.getTile(Std.int(current.x), Std.int(current.y) + 1), world.tinfo))
                        exclude.push(3); //BOTTOM
                    if (exclude.length == 4) { // We are stuck, we move and ignore this turn
                        exclude = [];
                        //Still exclude non valid coordinates
                        if (current.x == 0)
                            exclude.push(0); //LEFT
                        if (current.y == 0)
                            exclude.push(1); //TOP
                        if (current.x == world.tilemap.widthInTiles - 1)
                            exclude.push(2); //RIGHT
                        if (current.y == world.tilemap.heightInTiles - 1)
                            exclude.push(3); //BOTTOM
                        size++;
                    }
                    var dest = world.random.int(0, 3, exclude);
                    if (dest == 0)
                        current.x--;
                    if (dest == 1)
                        current.y--;
                    else if (dest == 2)
                        current.x++;
                    else if (dest == 3)
                        current.y++;
                    size--;
                    reclaim(current);
                }
            case REALISTIC:
            case SQUARE:
            case ROUND:
        }
    }
    
    public function reclaim(pos : FlxPoint) {
        tiles.push(pos);
        world.tilemap.setTile(Std.int(pos.x), Std.int(pos.y), world.tinfo.village());
    }
    
}