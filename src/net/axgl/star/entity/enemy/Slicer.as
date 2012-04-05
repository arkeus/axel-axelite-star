package net.axgl.star.entity.enemy {
	import net.axgl.star.entity.Bullet;
	import net.axgl.star.entity.Enemy;
	import net.axgl.star.util.Registry;
	import net.axgl.star.util.Resource;
	
	import org.axgl.AxU;
	
	public class Slicer extends Enemy {
		public function Slicer() {
			super(0, -30, Resource.SLICER);
			
			// Move straight down
			velocity.y = AxU.rand(20, 40) + Registry.game.level * 6;
			life = Math.ceil(Registry.game.level / 2);
		}
		
		override public function update():void {
			super.update();
		}
		
		override protected function fire():void {
			// If the game's level is > 3, shoot a bullet straight down
			if (Registry.game.level > 3) {
				Bullet.create(center.x, y + height - 2, Math.PI / 2, 200, Bullet.ENEMY, Registry.game.enemyBullets);
			}
			// Also shoot 2 bullets out at an angle, all the time.
			Bullet.create(center.x, y + height - 2, Math.PI / 2 + 0.15, 200, Bullet.ENEMY, Registry.game.enemyBullets);
			Bullet.create(center.x, y + height - 2, Math.PI / 2 - 0.15, 200, Bullet.ENEMY, Registry.game.enemyBullets);
		}
	}
}
