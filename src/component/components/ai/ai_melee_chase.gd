class_name AIMeleeChase extends _AI

const entity_pathfinding_weight = 10.0

var fov: _BaseFov
var chase_location: Vector2i = Vector2i.MIN
var radius: int = 5

func _init(json: Dictionary = {}) -> void:
	super(json, "ai_melee_chase")

	fov = AdamMilazzoFov.new()

func perform(map: Map) -> void:
	var entity = parent_entity
	var entity_position: Position = entity.components.get("position")
	if entity_position:
		fov.compute(map, entity_position.x, entity_position.y, radius)

		var closest_enemies: Array = []
		var closest_distance: int = -1
		var entity_faction = entity.components.get("faction")
		if entity_faction:
			for actor: Actor in fov.visible_actors:
				if actor.is_alive():
					var actor_faction: Faction = actor.components.get("faction")
					if entity_faction.is_enemy_of(actor_faction):
						var actor_position = actor.components.get("position")

						if actor_position:
							var distance: int = actor_position.distance_to(entity_position)
							if closest_distance == -1 || distance < closest_distance:
								closest_enemies.clear()
								closest_enemies.push_back(actor)
								closest_distance = distance
							elif distance == closest_distance:
								closest_enemies.push_back(actor)

		var closest_enemy
		if closest_enemies.size() >= 1:
			closest_enemy = closest_enemies.pick_random()

		if closest_enemy:
			var closest_enemy_position: Position = closest_enemy.components.get("position")
			chase_location = Vector2i(closest_enemy_position.x, closest_enemy_position.y)

			if closest_distance <= 1:
				return MeleeAction.new(entity, closest_enemy_position.x - entity_position.x, closest_enemy_position.y - entity_position.y).perform(map)
		else:
			if chase_location != Vector2i.MIN && entity_position.is_at(chase_location.x, chase_location.y):
				chase_location = Vector2i.MIN

			if chase_location == Vector2i.MIN:
				return WanderAction.new(entity).perform(map)

		var pathfinder: AStarGrid2D = AStarGrid2D.new()
		var fov_width: int = fov.right - fov.left
		var fov_height: int = fov.bottom - fov.top
		pathfinder.region = Rect2i(0, 0, fov_width, fov_height)
		pathfinder.update()

		for i in range(fov.left, fov.right):
			for j in range(fov.top, fov.bottom):
				var blocks: bool = false
				var furniture_tile: MapTile = map.furniture_tiles[i][j]
				if furniture_tile:
					var tile_entity = furniture_tile.entity
					if tile_entity && tile_entity.components.has("blocks_movement"):
						var blocks_movement_component = tile_entity.components.get("blocks_movement")
						if blocks_movement_component.blocks_movement:
							blocks = true

				if !blocks:
					var ground_tile: MapTile = map.ground_tiles[i][j]
					if ground_tile:
						var tile_entity = ground_tile.entity
						if tile_entity && tile_entity.components.has("blocks_movement"):
							var blocks_movement_component = tile_entity.components.get("blocks_movement")
							if blocks_movement_component.blocks_movement:
								blocks = true

				pathfinder.set_point_solid(Vector2i(i - fov.left, j - fov.top), blocks)

		for actor in map.actors:
			if actor.components.has("position"):
				var actor_position = actor.components.get("position")
				if actor.components.has("blocks_movement"):
					var blocks_movement_component = actor.components.get("blocks_movement")
					if blocks_movement_component.blocks_movement:
						pathfinder.set_point_weight_scale(Vector2i(actor_position.x - fov.left, actor_position.y - fov.top), entity_pathfinding_weight)

		var offset_entity_location = Vector2i(entity_position.x - fov.left, entity_position.y - fov.top)
		var offset_chase_location = Vector2i(chase_location.x - fov.left, chase_location.y - fov.top)
		var path: Array = pathfinder.get_point_path(offset_entity_location, offset_chase_location)

		path.pop_front()

		if !path.is_empty():
			var destination := Vector2i(path[0])
			path.pop_front()

			var move_offset: Vector2i = destination - offset_entity_location
			return MovementAction.new(entity, move_offset.x, move_offset.y).perform(map)

		return MovementAction.new(entity, 0, 0).perform(map)
