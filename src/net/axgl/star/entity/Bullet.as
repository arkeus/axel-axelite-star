package net.axgl.star.entity {
	import net.axgl.star.util.Resource;
	
	import org.axgl.Ax;
	import org.axgl.AxGroup;
	import org.axgl.AxSprite;

	/**
	 * Represents both the player and enemy bullets in the world.
	 */
	public class Bullet extends AxSprite {
		/**
		 * Flag indicating this is a player bullet
		 */
		public static const PLAYER:uint = 0;
		/**
		 * Flag indiciating this is an enemy bullet
		 */
		public static const ENEMY:uint = 1;

		/**
		 * Marker of whether this is a player or enemy bullet. 
		 */
		public var faction:uint;

		/**
		 * Creates a new bullet of the specified faction.
		 */
		public function Bullet(faction:uint) {
			super(x, y, faction == PLAYER ? Resource.PLAYER_BULLET : Resource.ENEMY_BULLET);
			this.faction = faction;
		}

		/**
		 * Initializes a bullet to a given position, angle, and speed.
		 */
		public function initialize(x:Number, y:Number, angle:Number, speed:Number):void {
			this.x = x - width / 2;
			this.y = y - height / 2;
			velocity.x = speed * Math.cos(angle);
			velocity.y = speed * Math.sin(angle);
		}

		override public function update():void {
			// The only updating we want is to destroy the bullet if it goes off the screen so we can recycle it
			if (x < -width || x > Ax.width || y < -height || y > Ax.height) {
				destroy();
			}
		}

		/**
		 * Create a bullet, recycling a dead one if there are any available to recycle. Takes in a group that you want
		 * to recycle from/add to, in addition to the required parameters to initialize a bullet. 
		 */
		public static function create(x:Number, y:Number, angle:Number, speed:Number, faction:uint, group:AxGroup):Bullet {
			// Try to recycle a bullet from the passed group
			var bullet:Bullet = group.recycle() as Bullet;
			// If there were none to recycle, create a new one and add it
			if (bullet == null) {
				bullet = new Bullet(faction);
				group.add(bullet);
			}
			// Initialize the bullet, regardless of whether it was recycled or a new one
			bullet.initialize(x, y, angle, speed);
			return bullet;
		}
	}
}
