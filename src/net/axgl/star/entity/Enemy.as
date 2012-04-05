package net.axgl.star.entity {
	import net.axgl.star.util.Registry;
	
	import org.axgl.Ax;
	import org.axgl.AxU;
	import org.axgl.particle.AxParticleSystem;

	/**
	 * Our enemy base class, representing all the enemies in the game. Specific enemies extend this class.
	 */
	public class Enemy extends Entity {
		/**
		 * General world padding so enemies don't go to the very edge.
		 */
		protected static const PADDING:uint = 20;

		/**
		 * The delay between shots.
		 */
		protected var fireDelay:Number = 2;
		/**
		 * Timer to only fire once per fireDelay.
		 */
		protected var fireTimer:Number = 0.5;
		/**
		 * The amount of HP this unit has.
		 */
		public var life:uint = 1;

		/**
		 * Creates a new enemy.
		 */
		public function Enemy(x:Number, y:Number, graphic:Class) {
			super(x, y, graphic);

			this.x = AxU.rand(PADDING, Ax.width - width - PADDING);
		}

		override public function update():void {
			// Logic to fire once per fireDelay
			fireTimer -= Ax.dt;
			if (fireTimer <= 0) {
				fire();
				fireTimer = fireDelay;
			}
		}

		/**
		 * Fires bullet(s). Override to give each enemy specific shooting logic.
		 */
		protected function fire():void {
			// Override per enemy
		}

		/**
		 * Called when this unit is hit by a bullet.
		 */
		public function damage():void {
			if (--life <= 0) {
				destroy();
			}
		}

		/**
		 * Destroys this enemy
		 */
		override public function destroy():void {
			// 30% chance to create a random powerup
			if (AxU.rand(0, 100) < 30) {
				var powerup:Powerup = new Powerup(center.x - 12, center.y - 12, AxU.rand(0, Powerup.NUM_POWERUPS - 1));
				Registry.game.powerups.add(powerup);
			}

			// Emit explosion particles
			AxParticleSystem.emit("diamond", center.x, center.y);
			
			// Destroy
			super.destroy();
		}
	}
}
