package net.axgl.star.entity.enemy {
	import net.axgl.star.entity.Bullet;
	import net.axgl.star.entity.Enemy;
	import net.axgl.star.util.Registry;
	import net.axgl.star.util.Resource;
	
	import org.axgl.AxU;
	
	public class Turret extends Enemy {
		public function Turret() {
			super(0, -30, Resource.TURRET);
			
			// Move at an angle towards where the player was when this enemy spawned
			var angle:Number = AxU.getAngle(x, y, Registry.player.x, Registry.player.y);
			var speed:Number = 25;
			velocity.x = Math.cos(angle) * speed;
			velocity.y = Math.sin(angle) * speed;
			life = Math.ceil(Registry.game.level / 2);
		}
		
		override public function update():void {
			super.update();
		}
		
		override protected function fire():void {
			// Shoot towards the player
			Bullet.create(center.x, y + height - 2, AxU.getAngle(center.x, center.y, Registry.player.x, Registry.player.y), 150, Bullet.ENEMY, Registry.game.enemyBullets);
		}
	}
}
