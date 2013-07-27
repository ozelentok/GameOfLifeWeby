GE = {}
class GE.Sim

	Const =
		width: 600
		squares: 100
		FrameRate: 1000 / 20
	Const.height = Const.width
	Const.squareLen = Const.width / Const.squares
	LevelToColor = ['#FFF', '#05F']
	constructor: ($canvas) ->
		@canvas = $canvas[0]
		@ctx = @canvas.getContext '2d'
		@setSizes()
		@setEvents()
		@buildGrid()
		setInterval @tick.bind(this), Const.FrameRate

	buildGrid: ->
		@grid = []
		@nextGrid = []
		for i in [1..Const.squares]
			@grid.push (0 for j in [1..Const.squares])
			@nextGrid.push (0 for j in [1..Const.squares])
		return

	drawGrid: ->
		for i in [0...Const.squares]
			for j in [0...Const.squares]
				if(@grid[i][j] == 1)
					@drawCell i*Const.squareLen, j*Const.squareLen, LevelToColor[@grid[i][j]]
		return

	drawCell: (x, y, color) ->
		@ctx.fillRect(x, y, Const.squareLen, Const.squareLen)
		#@ctx.strokeRect(x, y, Const.squareLen, Const.squareLen)
		return

	advanceGerms: ->
		count = 0
		for x in [0...Const.squares]
			for y in [0...Const.squares]
				count = @countNeighbours(x, y)
				if(@grid[x][y] == 1)
					if(count <= 1 || count >= 4)
						@nextGrid[x][y] = 0
					else
						@nextGrid[x][y] = 1
				else
					if(count == 3)
						@nextGrid[x][y] = 1
					else
						@nextGrid[x][y] = @grid[x][y]
		temp = @grid
		@grid = @nextGrid
		@nextGrid = temp
		return

	countNeighbours: (x, y) ->
		left = if (x - 1) >= 0 then (x - 1) else Const.squares - 1
		right = if (x + 1) < Const.squares then (x + 1) else 0
		top = if (y - 1) >= 0 then (y - 1) else Const.squares - 1
		bottom = if (y + 1) < Const.squares then (y + 1) else 0
		count = 0
		count += @grid[left][y]
		count += @grid[left][top]
		count += @grid[left][bottom]
		count += @grid[right][y]
		count += @grid[right][top]
		count += @grid[right][bottom]
		count += @grid[x][top]
		count += @grid[x][bottom]
		return count

	tick: ->
		@ctx.clearRect(0, 0, Const.width, Const.height)
		@advanceGerms()
		@drawGrid()
		#requestAnimFrame(@tick.bind(this))
		return

	setSizes: ->
		#$canvas.css('width', Const.width + 'px')
		#$canvas.css('height', Const.height + 'px')
		@canvas.width = Math.min $(window).width() - 40, Const.width
		@canvas.height = Math.min $(window).width() - 40, Const.height
		Const.squareLen = @canvas.width / Const.squares
		@ctx.fillStyle = '#0F0'
		return

	setEvents: ->
		$(@canvas).bind 'mousedown', =>
			$(@canvas).bind 'mousemove', (e) =>
				i = Math.floor((e.pageX - @canvas.offsetLeft)/Const.squareLen)
				j = Math.floor((e.pageY - @canvas.offsetTop)/Const.squareLen)
				@grid[i][j] = 1
				return
			return
		$(@canvas).bind 'mouseleave mouseup', (e) =>
			$(@canvas).unbind 'mousemove'
			return
		$(window).resize =>
			@setSizes()
			return
		return


	window.requestAnimFrame =
			window.requestAnimationFrame    ||
			window.webkitRequestAnimationFrame ||
			window.mozRequestAnimationFrame    ||
			window.oRequestAnimationFrame      ||
			window.msRequestAnimationFrame     ||
			(callback) ->
				window.setTimeout(callback, Const.FrameRate)
				return
	
#GE.LevelToColor = ['#FFF', '#FEE', '#FDD', '#FCC', '#FBB', '#FAA',
#	'#F99', '#F88', '#F77', '#F66', '#F55', '#F44', '#F33', '#F22', '#F11', '#F00']

germSim = new GE.Sim($('#simview'))
