package net.axgl.star.state {
	import net.axgl.star.display.Starfield;
	import net.axgl.star.entity.Bullet;
	import net.axgl.star.entity.Enemy;
	import net.axgl.star.entity.Player;
	import net.axgl.star.entity.Powerup;
	import net.axgl.star.entity.enemy.Butterfly;
	import net.axgl.star.entity.enemy.Meteor;
	import net.axgl.star.entity.enemy.Slicer;
	import net.axgl.star.entity.enemy.Turret;
	import net.axgl.star.util.Particle;
	import net.axgl.star.util.Registry;
	import net.axgl.star.util.Resource;
	import net.axgl.star.util.UI;
	
	import org.axgl.Ax;
	import org.axgl.AxEntity;
	import org.axgl.AxGroup;
	import org.axgl.AxState;
	import org.axgl.AxU;
	import org.axgl.collision.AxCollisionGroup;
	import org.axgl.collision.AxGrid;
	import org.axgl.input.AxKey;
	import org.axgl.particle.AxParticleSystem;
	import org.axgl.util.AxRange;

	/**
	 * Our main game state.
	 */
	public class GameState extends AxState {
		/** The pre-allocated collision grid */
		private static const COLLISION_GRID:AxCollisionGroup = new AxGrid(400, 600, 10, 15);
		/** The current "level", used to increase difficulty as you progress */
		public var level:Number = 0;
		/** The player you control */
		public var player:Player;

		/** Powerups group */
		public var powerups:AxGroup = new AxGroup;
		/** Player bullets group */
		public var playerBullets:AxGroup = new AxGroup;
		/** Enemy bullets group */
		public var enemyBullets:AxGroup = new AxGroup;
		/** Enemies group */
		public var enemies:AxGroup = new AxGroup;
		/** Helper group for colliding against multiple other groups */
		public var colliders:AxGroup = new AxGroup;
		/** Particles group */
		public var particles:AxGroup = new AxGroup;

		/** The base amount of time it takes for an enemy to spawn, in seconds */
		private static const BASE_SPAWN:Number = 2;
		/** The amount of time the spawn decreases per "level" */
		private static const SPAWN_DECREASE:Number = 0.1;
		/** Timer to help us spawn enemies at a given rate */
		private var spawnTimer:Number = BASE_SPAWN;

		/** How long between when we "clean" our enemies group */
		private static const GARBAGE_COLLECT_DELAY:Number = 5;
		private var garbageCollectTimer:Number = GARBAGE_COLLECT_DELAY;

		/**
		 * Initialize the game objects.
		 */
		override public function create():void {
			// Set the registry state to this for easy access from any class
			Registry.game = this;

			// Add the background scrolling starfields
			this.add(new Starfield(Resource.STARFIELD_A, 180, 0.5));
			this.add(new Starfield(Resource.STARFIELD_B, 140, 0.4));
			this.add(new Starfield(Resource.STARFIELD_C, 100, 0.3));
			this.add(new Starfield(Resource.STARFIELD_D, 60, 0.15));

			// Add our particles group and initialize the particle effects
			this.add(particles);
			Particle.initialize();

			// Add enemies, enemy bullets, and powers to the collides group, which we collide with the player
			colliders.add(enemies).add(enemyBullets).add(powerups);
			this.add(colliders);

			// Add player bullets group, which we will collide with the enemies group
			this.add(playerBullets);

			// Add our player
			this.add(player = new Player(190, 500));
			
			// Set the registry player to our player for easy access from any class
			Registry.player = player;

			// Add our UI to the screen
			this.add(new UI);
		}

		/**
		 * Our main game logic
		 */
		override public function update():void {
			// Spawn enemies at a semi-random rate, based on BASE_SPAWN, SPAWN_DECREASE, and the current level
			spawnTimer -= Ax.dt;
			if (spawnTimer <= 0) {
				spawn();
				spawnTimer = new AxRange(BASE_SPAWN * 0.5, BASE_SPAWN).randomNumber() - level * SPAWN_DECREASE;
			}

			// Level goes up by 1 every 15 seconds, caps out at 10
			level += Ax.dt / 15;
			if (level > 10) {
				level = 10;
			}

			// Overlap the player with enemies, enemy bullets, and powerups
			Ax.overlap(player, colliders, onPlayerHit, COLLISION_GRID);
			// Overlap the player bullets with enemies
			Ax.overlap(playerBullets, enemies, onBulletHitEnemy, COLLISION_GRID);

			// Garbage collect every GARBAGE_COLLECT_DELAY. This is just cleaning up the enemies group to keep performance snappy
			garbageCollectTimer -= Ax.dt;
			if (garbageCollectTimer <= 0) {
				garbageCollectTimer = GARBAGE_COLLECT_DELAY;
				garbageCollect();
			}

			super.update();
		}

		/**
		 * Callback function when overlapping the player with enemies, bullets, and powerups.
		 * 
		 * @param player Our player
		 * @param target The object our player collided with
		 */
		private function onPlayerHit(player:Player, target:AxEntity):void {
			if (target is Powerup) {
				// If we collided with a power, collect it
				(target as Powerup).collect();
			} else if (target is Bullet) {
				// If we collided with a bullet, destroy the bullet and show the player-hit particle effect
				AxParticleSystem.emit("player-hit", target.center.x, target.center.y);
				target.destroy();
			}
		}

		/**
		 * Callback function when overlapping the enemies with player bullets.
		 * 
		 * @param bullet The bullet that hit the enemy.
		 * @param target The enemy the bullet hit.
		 */
		private function onBulletHitEnemy(bullet:AxEntity, target:AxEntity):void {
			AxParticleSystem.emit("enemy-hit", bullet.center.x, bullet.center.y);
			(target as Enemy).damage();
			bullet.destroy();
		}

		/**
		 * Spawns a random enemy.
		 */
		private function spawn():void {
			switch (AxU.rand(0, 3)) {
				case 0:
					enemies.add(new Butterfly);
					break;
				case 1:
					enemies.add(new Slicer);
					break;
				case 2:
					enemies.add(new Meteor);
					break;
				case 3:
					enemies.add(new Turret);
					break;
			}
		}

		/**
		 * Clean up the enemy group. This rebuilds the group, throwing away all the non-existent objects (anything that destroy() was
		 * called on). This is an alternative to recycling. Note that recycling is better when it makes sense, because it avoids
		 * having to create new objects, which is an expensive operation, and it avoids having to garbage collect the old objects.
		 */
		private function garbageCollect():void {
			enemies.cleanup();
		}
	}
}
