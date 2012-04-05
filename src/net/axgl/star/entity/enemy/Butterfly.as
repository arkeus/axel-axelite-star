package net.axgl.star.entity.enemy {
	import net.axgl.star.entity.Bullet;
	import net.axgl.star.entity.Enemy;
	import net.axgl.star.util.Registry;
	import net.axgl.star.util.Resource;
	
	import org.axgl.Ax;
	import org.axgl.AxU;

	public class Butterfly extends Enemy {
		private var sineTimer:Number;

		public function Butterfly() {
			super(0, -30, Resource.BUTTERFLY);

			velocity.y = AxU.rand(10, 30) + Registry.game.level * 6;
			sineTimer = Math.random() * Math.PI * 2;
			life = Math.ceil(Registry.game.level / 2);
		}

		override public function update():void {
			sineTimer += Ax.dt / 2.5;

			var range:Number = Ax.width - PADDING * 2;
			// Move the Butterfly back and forth along a sine wave
			x = Math.sin(sineTimer) * (range / 2) + range / 2 - width / 2 + PADDING;

			super.update();
		}

		override protected function fire():void {
			// Simply shoot a bullet straight down
			Bullet.create(center.x, y + height + 3, Math.PI / 2, 200, Bullet.ENEMY, Registry.game.enemyBullets);
		}
	}
}
