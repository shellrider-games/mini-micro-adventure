import "playerCharacter"
import "levelMap"


lastTimestamp = time
actors = []

update = function(delta)
	for actor in globals.actors
		actor.update delta
	end for
end function

render = function
	storeScroll = {"x": display(4).scrollX, "y": display(4).scrollY}
	display(4).clear	
	display(4).scrollX = storeScroll.x
	display(4).scrollY = storeScroll.y
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
	display(6).clear
	display(4).clear
	clear
end function

init = function()
	display(5).mode = displayMode.off
	display(6).mode = displayMode.tile
	display(7).color = color.black

	levelMap.loadLevel "assets/testLevel.tmj"
end function

clear
init
startLoop