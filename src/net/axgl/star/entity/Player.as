package net.axgl.star.entity {
	import net.axgl.star.util.Registry;
	import net.axgl.star.util.Resource;
	
	import org.axgl.Ax;
	import org.axgl.AxRect;
	import org.axgl.AxU;
	import org.axgl.input.AxKey;
	import org.axgl.input.AxMouseButton;
	import org.axgl.particle.AxParticleSystem;

	/**
	 * Our player spaceship that you control via the mouse
	 */
	public class Player extends Entity {
		/**
		 * The base speed without powerups
		 */
		private static const BASE_SPEED:Number = 140;
		/**
		 * Speed increase per powerup 
		 */
		private static const SPEED_INCREASE:Number = 30;
		/**
		 * Base fire delay without powerups 
		 */
		private static const BASE_FIRE:Number = 0.6;
		/**
		 * Fire speed increase per powerup 
		 */
		private static const FIRE_INCREASE:Number = 0.05;
		/**
		 * Base number of bullets without powerups
		 */
		private static const BASE_SPREAD:Number = 1;
		/**
		 * Distance between each separate bullet
		 */
		private static const SPREAD_DISTANCE:uint = 10;

		/**
		 * Number of spread powerups obtained
		 */
		public var spreadLevel:uint = 0;
		/**
		 * Number of speed powerups obtained
		 */
		public var speedLevel:uint = 0;
		/**
		 * Number of fire rate powerups obtained
		 */
		public var fireLevel:uint = 0;

		/**
		 * Timer to keep track of how often to fire a bullet
		 */
		public var fireDelay:Number = 0;

		/**
		 * Creates our player.
		 */
		public function Player(x:uint, y:uint) {
			super(x, y, Resource.PLAYER);

			// Sets the offset and size of our player sprite. Our width is 1 and height is 2 so that
			// bullets must hit the center of your ship to harm you, in true bullet hell style
			bounds(1, 2, 18, 15);
			worldBounds = new AxRect(0, 0, Ax.width, Ax.height - 40);
		}

		override public function update():void {
			if (AxU.distanceToMouse(x, y) > speed * Ax.dt) {
				var angle:Number = AxU.getAngleToMouse(x, y);
				velocity.x = speed * Math.cos(angle);
				velocity.y = speed * Math.sin(angle);
			} else {
				velocity.x = velocity.y = 0;
				x = Ax.mouse.x - width / 2;
				y = Ax.mouse.y - height / 2;
			}

			if (Ax.mouse.down(AxMouseButton.LEFT) && fireDelay <= 0) {
				shoot();
				fireDelay = fire;
			}

			fireDelay -= Ax.dt;
		}

		/**
		 * Shoots 1 bullet, plus one for each spread powerup you've obtained
		 */
		private function shoot():void {
			for (var i:uint = 0; i < spreadLevel + 1; i++) {
				Bullet.create(x - 3 + i * SPREAD_DISTANCE - ((spreadLevel - 1) * SPREAD_DISTANCE) / 2, y - 10, -Math.PI / 2, 500, Bullet.PLAYER, Registry.game.playerBullets);
			}

			// Show the shoot particles
			AxParticleSystem.emit("circle", x - 3, y - 16);
		}

		/**
		 * Explodes with a frontal semicircle of bullets when you collect an explosion powerup
		 */
		public function explode():void {
			for (var i:uint = 0; i < 16; i++) {
				Bullet.create(x - 3, y - 10, -Math.PI / 16 * i, 500, Bullet.PLAYER, Registry.game.playerBullets);
			}
		}

		/**
		 * Calculates your current speed based on base speed and powerups 
		 */
		public function get speed():Number {
			return BASE_SPEED + SPEED_INCREASE * speedLevel;
		}

		/**
		 * Calculates your current fire rate based on base fire rate and powerups
		 */
		public function get fire():Number {
			return BASE_FIRE - FIRE_INCREASE * fireLevel;
		}

		/**
		 * Calculates your current spread based on base spread and powerups
		 */
		public function get spread():Number {
			return BASE_SPREAD + spreadLevel;
		}
	}
}
