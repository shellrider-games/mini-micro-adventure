import "json"

loadLevel = function(path)
    data = json.parse(file.open(path).read)
    tileSetPicture = file.loadImage("assets/" + data["tilesets"][0]["image"])
    display(6).tileSet = tileSetPicture
    display(6).tileSetTileSize = data["tilesets"][0]["tilewidth"]
    display(6).cellSize = data["tilewidth"]*4
    display(6).extent = [data["width"],data["height"]]
    for i in range(0, data["layers"][0]["data"].len-1)
        display(6).setCell(i % data["width"], data["height"]-floor(i/data["width"])-1,data["layers"][0]["data"][i]-1)
    end for
end function

runUnitTests = function ()
    display(6).mode = displayMode.tile
    display(6).clear
    display(5).mode = displayMode.off
    loadLevel "assets/testLevel.tmj"
end function

if globals == locals then runUnitTests