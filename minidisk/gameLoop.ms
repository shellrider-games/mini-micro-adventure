import "playerCharacter"



lastTimestamp = time
actors = []

update = function(delta)
	for actor in globals.actors
		actor.update delta
	end for
end function

render = function
	display(4).clear
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
	clear
end function

init = function()
	display(5).mode = 0
	display(7).color = color.navy

	player = new playerCharacter.PlayerCharacter
	player.position.x = 250
	player.position.y = 250
	player.init
	actors.push player
end function

clear
init
startLoop