import "spriteSheetAnimationSystem"
clear

display(5).mode = 0
display(7).color = color.navy
testImage = file.loadImage("assets/img/dwarf.png")

frames = [testImage.getImage(80,28,20,28), testImage.getImage(80,0,20,28)]

testAnimation = new spriteSheetAnimationSystem.Animation
testAnimation.init frames,4

lastTimestamp = time

while not key.pressed("q")
    delta = time - globals.lastTimestamp
	globals.lastTimestamp = time
	
    testAnimation.update delta

    display(4).clear    
    sprite = new Sprite
    sprite.image = testAnimation.getFrame
    sprite.scale = 4
    sprite.x = 250
    sprite.y = 250
    display(4).sprites.push sprite

    yield
end while
clear