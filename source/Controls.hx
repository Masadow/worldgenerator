package ;
import worldgen.noise.PerlinNoise;
import worldgen.World;
import worldgen.Config;

/**
 * ...
 * @author Masadow
 */
class Controls
{
	public static var world : World;
	public static var perlin : PerlinNoise;
	
	public static function changeNode(dir : Int) : String
	{
		if (dir > 0)
			world.config.node += 25;
		else if (dir < 0)
			world.config.node -= 25;
		return world.config.node + "";
	}	

	public static function changeLloyd(dir : Int) : String
	{
		if (dir > 0)
			world.config.lloydIteration += 1;
		else if (dir < 0)
			world.config.lloydIteration -= 1;
		return world.config.lloydIteration + "";
	}
	
	public static function changeRandomness(dir : Int) : String
	{
		if (dir != 0)
			world.config.randomness = world.config.randomness == PSEUDORANDOM ? QUASIRANDOM : PSEUDORANDOM;
		return world.config.randomness == PSEUDORANDOM ? "Pseudorandom" : "Quasirandom";
	}
	
	public static function changePersistance(dir : Int) : String
	{
		if (dir > 0)
			perlin.persistance += 0.05;
		else if (dir < 0)
			perlin.persistance -= 0.05;
		perlin.persistance = Math.fround(perlin.persistance * 100) / 100;
		return perlin.persistance + "";
	}

	public static function changeOctave(dir : Int) : String
	{
		if (dir > 0)
			perlin.octave += 1;
		else if (dir < 0)
			perlin.octave -= 1;
		return perlin.octave + "";
	}

	public static function changeAmplitude(dir : Int) : String
	{
		if (dir > 0)
			perlin.amplitude += 0.5;
		else if (dir < 0)
			perlin.amplitude -= 0.5;
		perlin.amplitude = Math.fround(perlin.amplitude * 10) / 10;
		return perlin.amplitude + "";
	}

	public static function changeInterpolation(dir : Int) : String
	{
		if (dir != 0)
			perlin.interpolation = perlin.interpolation == LINEAR ? CUBIC : LINEAR;
		return perlin.interpolation == LINEAR ? "Linear" : "Cubic";
	}

	public static function changeWaterLevel(dir : Int) : String
	{
		if (dir > 0)
			world.config.waterLevel += 0.02;
		else if (dir < 0)
			world.config.waterLevel -= 0.02;
		world.config.waterLevel = Math.fround(world.config.waterLevel * 100) / 100;
		return world.config.waterLevel + "";
	}

	public static function changeDeepWaterLevel(dir : Int) : String
	{
		if (dir > 0)
			world.config.deepWaterLevel += 0.02;
		else if (dir < 0)
			world.config.deepWaterLevel -= 0.02;
		world.config.deepWaterLevel = Math.fround(world.config.deepWaterLevel * 100) / 100;
		return world.config.deepWaterLevel + "";
	}
    
	public static function changeMountainLevel(dir : Int) : String
	{
		if (dir > 0)
			world.config.mountainLevel += 0.02;
		else if (dir < 0)
			world.config.mountainLevel -= 0.02;
		world.config.mountainLevel = Math.fround(world.config.mountainLevel * 100) / 100;
		return world.config.mountainLevel + "";
	}

	public static function changeSpawnRate(dir : Int) : String
	{
		if (dir > 0)
			world.config.villages.spawnRate += 0.005;
		else if (dir < 0)
			world.config.villages.spawnRate -= 0.005;
		world.config.villages.spawnRate = Math.fround(world.config.villages.spawnRate * 1000) / 1000;
		return world.config.villages.spawnRate + "";
	}

	public static function changeMinDistance(dir : Int) : String
	{
		if (dir > 0)
			world.config.villages.minDistance += 1;
		else if (dir < 0)
			world.config.villages.minDistance -= 1;
		return world.config.villages.minDistance + "";
	}

	public static function changeMinSize(dir : Int) : String
	{
		if (dir > 0)
			world.config.villages.minSize += 1;
		else if (dir < 0)
			world.config.villages.minSize -= 1;
		return world.config.villages.minSize + "";
	}

	public static function changeMaxSize(dir : Int) : String
	{
		if (dir > 0)
			world.config.villages.maxSize += 1;
		else if (dir < 0)
			world.config.villages.maxSize -= 1;
		return world.config.villages.maxSize + "";
	}

	public static function changeShape(dir : Int) : String
	{
        var values = [RANDOM, REALISTIC, SQUARE, ROUND];
        var strings = ["Random", "Realistic", "Square", "Round"];
        var idx = 0;
        for (v in values) {
            if (v == world.config.villages.shape)
                break;
            idx++;
        }
		if (dir > 0 && ++idx == values.length)
            idx = 0;
        if (dir < 0 && --idx == -1)
            idx = values.length - 1;
        world.config.villages.shape = values[idx];
		return strings[idx];
	}

}
