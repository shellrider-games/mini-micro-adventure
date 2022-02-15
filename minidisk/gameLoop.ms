lastTimestamp = time
actors = []

update = function(delta)q
	for actor in globals.actors
		actor.update delta
	end for
end function

render = function
	for actor in globals.actors
		actor.render
	end for
end function

gameLoop = function()
	delta = time - globals.lastTimestamp
	globals.lastTimestamp = time
	update delta
	render
end function

waitForFrame = function(callback)
	yield
	callback
end function

startLoop = function()
	while not key.pressed("q")
		waitForFrame @gameLoop
	end while
end function

startLoop