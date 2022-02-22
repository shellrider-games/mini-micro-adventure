DIRECTIONS = {}
DIRECTIONS.DOWN = 0
DIRECTIONS.LEFT = 1
DIRECTIONS.UP = 2
DIRECTIONS.RIGHT = 3

PlayerCharacter = {}
PlayerCharacter.facing = DIRECTIONS.DOWN
PlayerCharacter.position = {"x": 0, "y" :0}
PlayerCharacter.speed = 150

PlayerCharacter.image = file.loadImage("assets/img/dwarf.png")
PlayerCharacter.spriteDimensions = {"w":20, "h": 28}

PlayerCharacter.update = function(delta)
    inputVector = {"x": key.pressed("right") - key.pressed("left"), "y" : key.pressed("up") - key.pressed("down")}
    if inputVector.y != 0 then 
        if inputVector.y > 0 then 
            self.facing = DIRECTIONS.UP
        else
            self.facing = DIRECTIONS.DOWN
        end if
    else
        if inputVector.x != 0 then
            if inputVector.x > 0 then
                self.facing = DIRECTIONS.RIGHT
            else
                self.facing = DIRECTIONS.LEFT
            end if
        end if
    end if
    self.position.x = self.position.x + inputVector.x * self.speed * delta
    self.position.y = self.position.y + inputVector.y * self.speed * delta
end function

PlayerCharacter.render = function()
    frame = self.image.getImage(self.facing * self.spriteDimensions.w,0, self.spriteDimensions.w, self.spriteDimensions.h)
    sprite = new Sprite
    sprite.image = frame
    sprite.scale = 4
    sprite.x = self.position.x
    sprite.y = self.position.y
    display(4).sprites.push sprite
end function