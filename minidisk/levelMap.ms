import "json"

loadLevel = function(path)
    data = json.parse(file.open(path).read)
    tileSetPicture = file.loadImage("assets/" + data["tilesets"][0]["image"])
    display(6).tileSet = tileSetPicture
    display(6).tileSetTileSize = data["tilesets"][0]["tilewidth"]
    display(6).cellSize = data["tilewidth"]*4
    display(6).extent = [data["width"],data["height"]]
    display(6).scrollX = 0
    display(6).scrollY = 0
    for i in range(0, data["layers"][0]["data"].len-1)
        display(6).setCell(i % data["width"], data["height"]-floor(i/data["width"])-1,data["layers"][0]["data"][i]-1)
    end for

    playerSpawn = [0,0]

	player = new playerCharacter.PlayerCharacter

    for obj in data["layers"][1]["objects"]
        if obj["name"] == "playerSpawn" then 
            playerSpawn[0] = obj["x"]*4
            playerSpawn[1] = data["height"]*data["tilewidth"]*4-obj["y"]*4
        end if
    end for
    
    pprint playerSpawn

    player.move playerSpawn[0],playerSpawn[1]
	player.init

	globals.actors.push player

end function

runUnitTests = function ()
    display(6).mode = displayMode.tile
    display(6).clear
    display(5).mode = displayMode.off
    loadLevel "assets/testLevel.tmj"
end function

if globals == locals then runUnitTests