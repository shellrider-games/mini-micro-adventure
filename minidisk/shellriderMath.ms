normaliseVector2 = function(vector)
    abs = sqrt(vector.x * vector.x + vector.y * vector.y)
    if abs != 0 then return {"x" : vector.x / abs,"y": vector.y /abs}
    return {"x": 0, "y": 0}
end function