package worldgen.noise;
import worldgen.Config;

enum Interpolation
{
	LINEAR;
	CUBIC;
}

/**
 * ...
 * @author Masadow
 */
class PerlinNoise implements INoise
{
	public var persistance : Float;
	public var amplitude : Float;
	public var octave : Int;
	public var interpolation : Interpolation;
	
	public function new() 
	{
		persistance = 0.5;
		amplitude = 2;
		octave = 8;
		interpolation = LINEAR;
	}

	private function baseNoise(width : Int, height : Int)
	{
		var noise = new Array<Array<Float>>();
		for (i in 0...width)
		{
			noise.push(new Array<Float>());
			for (j in 0...height)
			{
				noise[i].push(Math.random());
			}
		}
		return noise;
	}
	
	private function interpolate(x0 : Float, x1 : Float, alpha : Float) : Float
	{
		switch (interpolation)
		{
			case LINEAR:
				return x0 * (1 - alpha) + alpha * x1;
			case CUBIC: //unsure
				var ralpha = 1 - alpha;
				return x0 * (3 * ralpha * ralpha - 2 * ralpha * ralpha * ralpha)
					+  x1 * (3 * alpha * alpha - 2 * alpha * alpha * alpha);
		}
	}
	
	private function smoothNoise(baseNoise : Array<Array<Float>>, octave : Int, width : Int, height : Int) : Array<Array<Float>>
	{
		var noise = new Array<Array<Float>>();
		var samplePeriod : Int = 1 << octave;
		var sampleFreq : Float = 1. / samplePeriod;
		for (i in 0...width)
		{
			noise.push(new Array<Float>());
			//horizontal sampling indice
			var sample_i0 : Int = Math.floor(i / samplePeriod) * samplePeriod;
			var sample_i1 : Int = (sample_i0 + samplePeriod) % width;
			var horiz_blend : Float = (i - sample_i0) * sampleFreq;
			for (j in 0...height)
			{
				//vertical sampling indice
				var sample_j0 : Int = Math.floor(j / samplePeriod) * samplePeriod;
				var sample_j1 : Int = (sample_j0 + samplePeriod) % height;
				var vert_blend : Float = (j - sample_j0) * sampleFreq;
				
				//blend the top two corners
				var top : Float = interpolate(baseNoise[sample_i0][sample_j0],
											baseNoise[sample_i1][sample_j0], horiz_blend);
											
				//blend the bottom two corners
				var bottom : Float = interpolate(baseNoise[sample_i0][sample_j1],
											baseNoise[sample_i1][sample_j1], horiz_blend);
											
				//final blend
				noise[i].push(interpolate(top, bottom, vert_blend));
			}
		}
		return noise;		
	}
	
	private function perlinNoise(smoothNoise : Array<Array<Array<Float>>>, width : Int, height : Int) : Array<Array<Float>>
	{
		var noise = new Array<Array<Float>>();
		var totalAmplitude : Float = 0;
		var amplitude = this.amplitude;

		//blending
		for (oct in 0...octave)
		{
			var r_octave = octave - oct - 1;
			amplitude *= persistance;
			totalAmplitude += amplitude;
			for (i in 0...width)
			{
				if (i >= noise.length)
					noise.push(new Array<Float>());
				for (j in 0...height)
				{
					if (j >= noise[i].length)
						noise[i].push(0);
					noise[i][j] += smoothNoise[r_octave][i][j] * amplitude;
				}
			}
		}
		
		//normalisation
		for (i in 0...width)
		{
			for (j in 0...height)
			{
				noise[i][j] /= totalAmplitude;
			}
		}
		
		return noise;
	}

	public function compute(config : Config) : Array<Array<Float>>
	{
		var noise = baseNoise(Std.int(config.layerBounds.width), Std.int(config.layerBounds.height));
		var smoothNoises = new Array<Array<Array<Float>>>();
		for (i in 0...octave)
		{
			smoothNoises.push(smoothNoise(noise, i, Std.int(config.layerBounds.width), Std.int(config.layerBounds.height)));
		}
		return perlinNoise(smoothNoises, Std.int(config.layerBounds.width), Std.int(config.layerBounds.height));
	}
}