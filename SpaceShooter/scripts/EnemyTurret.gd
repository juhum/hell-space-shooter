extends KinematicBody2D

onready var player = get_parent().get_node("Player")
var speed = 0.1
var follow = true
var ShootBullet := preload("res://scenes/BulletEnemy.tscn")
var time = 0
var maxtime = 0.2
var explode :=preload("res://scenes/enemies/EnemyExplosion.tscn")


func _physics_process(delta):
	look_at(player.global_position)
	var motion = Vector2.ZERO
	follow = true
	motion += position.direction_to(player.position)
	motion = motion * speed
	motion = move_and_slide(motion)
	rotation_degrees = rotation_degrees + 90

func _on_timeout():
	self.queue_free()


func _ready():
	if time > 0:
		return false
	time = maxtime
	return true

func _process(delta):
	
	shoot()
		
	$Node2D.look_at(player.position)
	
	
func shoot():
	var Bullet = ShootBullet.instance()
	
	get_parent().add_child(Bullet)
	Bullet.position = $Node2D/gun.global_position
	
	Bullet.velocity = player.position - Bullet.position
	
func _on_Area2D_body_entered(body):
	if body.get_name()=="Player":
		var effect = explode.instance()
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)
		queue_free()
	if "Bullet" in body.name:
		var effect = explode.instance()
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)
		queue_free()

func death():
	get_tree().reload_current_scene()

