extends TileMapLayer

# ====== LINK KE LAYER BOARD (LOCKED PIECES) ======
@export var board: TileMapLayer
@onready var on_line: AudioStreamPlayer2D = $"../On_Line"

# ====== TETROMINOES ======
var i_0 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]
var i_90 := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)]
var i_180 := [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)]
var i_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)]
var i := [i_0, i_90, i_180, i_270]
# ... (variable bentuk lain sama seperti sebelumnya, disingkat biar rapi)
var t := [[Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)], [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)], [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)], [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]]
var o := [[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)], [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)], [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)], [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]]
var z := [[Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)], [Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)], [Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)], [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 2)]]
var s := [[Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1)], [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)], [Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2), Vector2i(1, 2)], [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]]
var l := [[Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)], [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)], [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2)], [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)]]
var j := [[Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)], [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(1, 2)], [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)], [Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 2), Vector2i(1, 2)]]

var shapes := [i, t, o, z, s, l, j]
var shapes_full := shapes.duplicate()

# ====== GRID ======
const COLS: int = 10
const ROWS: int = 20
const BOARD_MIN := Vector2i(1, 1)
const BOARD_MAX := Vector2i(COLS, ROWS)

# ====== MOVEMENT ======
const directions := [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN]
var steps: Array = []
const steps_req: int = 50
const start_pos := Vector2i(5, 1)
var cur_pos: Vector2i
var speed: float
const ACCEL: float = 0.25

# ====== PIECE STATE ======
var piece_type: Array
var next_piece_type: Array
var rotation_index: int = 0
var active_piece: Array = []

# ====== GAME STATE ======
var score: int
const REWARD: int = 100
var game_running: bool

# ====== TILE SETUP ======
@export var source_id: int = 0 
var piece_atlas: Vector2i
var next_piece_atlas: Vector2i


func _ready() -> void:
	if board == null:
		push_error("Board TileMapLayer belum di-assign!")
		return

	if tile_set:
		board.tile_set = tile_set
	
	new_game()
	if has_node("HUD/StartButton"):
		$HUD/StartButton.pressed.connect(new_game)


func new_game() -> void:
	score = 0
	speed = 1.0
	game_running = true
	rotation_index = 0
	steps = [0, 0, 0]
	Engine.time_scale = 1.0 # Pastikan kecepatan normal saat mulai

	if has_node("HUD/GameOverLabel"):
		$HUD/GameOverLabel.hide()
	
	if has_node("HUD/ScoreLabel"):
		$HUD/ScoreLabel.text = "SCORE: 0"
		
	if has_node("HUD/StartButton"):
		$HUD/StartButton.hide() 

	clear_piece()
	clear_board()
	clear_panel()

	piece_type = pick_piece()
	piece_atlas = Vector2i(shapes_full.find(piece_type), 0)

	next_piece_type = pick_piece()
	next_piece_atlas = Vector2i(shapes_full.find(next_piece_type), 0)

	create_piece()


func _process(_delta: float) -> void:
	if not game_running:
		return

	if Input.is_action_pressed("ui_left"):
		steps[0] += 10
	elif Input.is_action_pressed("ui_right"):
		steps[1] += 10
	elif Input.is_action_pressed("ui_down"):
		steps[2] += 10
	elif Input.is_action_just_pressed("ui_up"):
		rotate_piece()

	steps[2] += speed

	for idx in range(steps.size()):
		if steps[idx] > steps_req:
			move_piece(directions[idx])
			steps[idx] = 0


func pick_piece() -> Array:
	var piece: Array
	if not shapes.is_empty():
		shapes.shuffle()
		piece = shapes.pop_front()
	else:
		shapes = shapes_full.duplicate()
		shapes.shuffle()
		piece = shapes.pop_front()
	return piece


func create_piece() -> void:
	steps = [0, 0, 0]
	cur_pos = start_pos
	rotation_index = 0

	active_piece = piece_type[rotation_index]
	
	for cell in active_piece:
		if not is_free(cur_pos + cell):
			game_running = false
			if has_node("HUD/GameOverLabel"):
				$HUD/GameOverLabel.show()
			if has_node("HUD/StartButton"):
				$HUD/StartButton.show()
			return

	draw_piece(active_piece, cur_pos, piece_atlas)
	draw_piece(next_piece_type[0], Vector2i(15, 6), next_piece_atlas)


func clear_piece() -> void:
	if active_piece.is_empty():
		return
	for cell in active_piece:
		erase_cell(cur_pos + cell)


func draw_piece(piece: Array, pos: Vector2i, atlas: Vector2i) -> void:
	for cell in piece:
		set_cell(pos + cell, source_id, atlas)


func rotate_piece() -> void:
	if can_rotate():
		clear_piece()
		rotation_index = (rotation_index + 1) % 4
		active_piece = piece_type[rotation_index]
		draw_piece(active_piece, cur_pos, piece_atlas)


func move_piece(dir: Vector2i) -> void:
	if can_move(dir):
		clear_piece()
		cur_pos += dir
		draw_piece(active_piece, cur_pos, piece_atlas)
	else:
		if dir == Vector2i.DOWN:
			land_piece()
			# Await animasi dan jeda selesai sebelum spawn baru
			await check_rows() 

			piece_type = next_piece_type
			piece_atlas = next_piece_atlas

			next_piece_type = pick_piece()
			next_piece_atlas = Vector2i(shapes_full.find(next_piece_type), 0)

			clear_panel()
			create_piece()
			check_game_over()


func can_move(dir: Vector2i) -> bool:
	for cell in active_piece:
		if not is_free(cur_pos + cell + dir):
			return false
	return true


func can_rotate() -> bool:
	var next_rot := (rotation_index + 1) % 4
	for cell in piece_type[next_rot]:
		if not is_free(cur_pos + cell):
			return false
	return true


func is_inside_board(pos: Vector2i) -> bool:
	return pos.x >= BOARD_MIN.x and pos.x <= BOARD_MAX.x and pos.y >= BOARD_MIN.y and pos.y <= BOARD_MAX.y


func is_free(pos: Vector2i) -> bool:
	if not is_inside_board(pos):
		return false
	return board.get_cell_source_id(pos) == -1


func land_piece() -> void:
	for cell in active_piece:
		erase_cell(cur_pos + cell)
		board.set_cell(cur_pos + cell, source_id, piece_atlas)


func clear_panel() -> void:
	for x in range(14, 19):
		for y in range(5, 9):
			erase_cell(Vector2i(x, y))

func check_rows() -> void:
	var row := ROWS
	while row > 0:
		var count := 0
		for x in range(COLS):
			if board.get_cell_source_id(Vector2i(x + 1, row)) != -1:
				count += 1

		if count == COLS:
			# Matikan logic game
			game_running = false 
			
			if on_line:
				on_line.play()
			
			# === JALANKAN EFEK SLOW MO & PUTIH ===
			await animate_clear_row(row)
			
			# Hapus baris setelah animasi selesai
			shift_rows(row)
			
			score += REWARD
			if has_node("HUD/ScoreLabel"):
				$HUD/ScoreLabel.text = "SCORE: " + str(score)
			speed += ACCEL
			
			# Nyalakan logic game lagi
			game_running = true
		else:
			row -= 1

# === FUNGSI EFEK (DIPERBAIKI) ===
func animate_clear_row(row: int) -> void:
	# 1. SLOW MOTION (Waktu jadi 0.1x kecepatan normal)
	Engine.time_scale = 0.1 
	
	# 2. Buat Kotak Putih
	var flash = ColorRect.new()
	flash.color = Color.WHITE
	flash.color.a = 0.9 
	add_child(flash)
	
	# === FIX PENTING: Z-INDEX ===
	# Angka 100 memastikan putih ini digambar PALING DEPAN (di atas tilemap)
	flash.z_index = 100 

	# 3. Posisi & Ukuran
	var tile_size = board.tile_set.tile_size 
	var start_pos = board.map_to_local(Vector2i(1, row)) - (Vector2(tile_size) / 2)
	flash.size = Vector2(COLS * tile_size.x, tile_size.y)
	flash.position = start_pos

	# 4. TUNGGU (Durasi efek slow motion)
	# create_timer(0.05) pada time_scale 0.1 berarti real timenya 0.5 detik
	# Parameter 'true' terakhir artinya: abaikan time_scale? Tidak, kita mau dia ikut melambat
	# Tapi untuk durasi "rasa" pemain, kita pakai timer real-time
	await get_tree().create_timer(0.5, true, false, true).timeout
	
	# 5. KEMBALIKAN WAKTU NORMAL
	Engine.time_scale = 1.0
	
	# 6. Hapus flash
	flash.queue_free()


func shift_rows(row: int) -> void:
	for y in range(row, 1, -1):
		for x in range(COLS):
			var from_pos := Vector2i(x + 1, y - 1)
			var to_pos := Vector2i(x + 1, y)

			var from_source := board.get_cell_source_id(from_pos)
			if from_source == -1:
				board.erase_cell(to_pos)
			else:
				var from_atlas := board.get_cell_atlas_coords(from_pos)
				board.set_cell(to_pos, from_source, from_atlas)

	for x in range(COLS):
		board.erase_cell(Vector2i(x + 1, 1))


func clear_board() -> void:
	for y in range(ROWS):
		for x in range(COLS):
			board.erase_cell(Vector2i(x + 1, y + 1))


func check_game_over() -> void:
	for cell in active_piece:
		if not is_free(cur_pos + cell):
			land_piece()
			if has_node("HUD/GameOverLabel"):
				$HUD/GameOverLabel.show()
			
			game_running = false
			
			if has_node("HUD/StartButton"):
				$HUD/StartButton.show() 
			
			return 
