package net.axgl.star.entity {
	import net.axgl.star.state.GameState;
	import net.axgl.star.util.Registry;
	import net.axgl.star.util.Resource;
	
	import org.axgl.Ax;
	import org.axgl.AxU;
	import org.axgl.particle.AxParticleSystem;

	/**
	 * A powerup.
	 */
	public class Powerup extends Entity {
		/* Flags representing the possible powerups */
		public static const SPREAD:uint = 0;
		public static const SPEED:uint = 1;
		public static const FIRE:uint = 2;
		public static const EXPLODE:uint = 3;
		public static const NUM_POWERUPS:uint = 4;
	
		/** The type of powerup this is */
		private var type:uint;

		/**
		 * Creates a new powerup of the specified type
		 */
		public function Powerup(x:Number, y:Number, type:uint) {
			super(x, y, null);
			this.type = type;

			load(Resource.POWERUP, 25, 25);
			show(type);
			velocity.y = 100;
		}

		/**
		 * Called when the player hits this powerup.
		 */
		public function collect():void {
			// Get the player
			var player:Player = Registry.player;

			// Increment the specific level
			switch (type) {
				case SPREAD:
					player.spreadLevel++;
					player.spreadLevel = AxU.clamp(player.spreadLevel, 0, 5);
					break;
				case SPEED:
					player.speedLevel++;
					player.speedLevel = AxU.clamp(player.speedLevel, 0, 10);
					break;
				case FIRE:
					player.fireLevel++;
					player.fireLevel = AxU.clamp(player.fireLevel, 0, 10);
					break;
				case EXPLODE:
					player.explode();
					break;
			}

			// Emit the powerup particles
			AxParticleSystem.emit("powerup", x, y);
			
			// Destroy this powerup
			destroy();
		}
	}
}
