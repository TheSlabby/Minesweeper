matrix = {}
size = 8
percent = .3
safeZone = 4
win = false


width, height = love.graphics.getDimensions()
scale = math.floor(math.min(width, height) / size)

debounce = {}
function isClicked(button)
    if not love.mouse.isDown(button) then debounce[button] = false end
        if not debounce[button] and love.mouse.isDown(button) then
            debounce[button] = true
        return true
    else
        return false
    end
end

function generateMatrix(startX,startY)
    print('generating new matrix at ',startX,startY)
    --init values
    win = false
    squaresCleared = 0
    bombCount = 0
    --generate bombs
    for x=0, size-1 do
        matrix[x] = {}
        for y=0, size - 1 do
            bomb = false
            if math.random() < percent then bomb = true end
            matrix[x][y] = {}
            matrix[x][y].selected = false
            matrix[x][y].flagged = false
            if not startX then startX = x end
            if not startY then startY = y end
            matrix[x][y].bomb = not (math.abs(startX-x) < safeZone and math.abs(startY-y) < safeZone)
            if matrix[x][y].bomb then
                --probability
                matrix[x][y].bomb = math.random() < percent
                if matrix[x][y].bomb then bombCount = bombCount + 1 end
            end
        end
    end
end

function squareExists(x,y)
    return matrix[x] and matrix[x][y]
end


function clearSquare(x,y)
    if squareExists(x,y) and not matrix[x][y].flagged then
        if squaresCleared == 0 then
            generateMatrix(x,y)
        end
        matrix[x][y].selected = true

        squaresCleared = squaresCleared + 1
        --clear surrounding squares
        if getSurroundingSquares(x,y) == 0 then
            clearSurroundingSquares(x,y)
        end
    end
end

function clearSurroundingSquares(x,y)
    --used for the clear squares
    print('clearing squares')
    for i=-1,1 do
        for j=-1,1 do
            if squareExists(x+i,y+j) and matrix[x+i][y+j].selected == false then
                clearSquare(x+i,y+j)
            end
        end
    end
end

function renderSquare(x,y,count)
    if count == nil then
        love.graphics.setColor(.5,.5,.5)
        love.graphics.rectangle('fill',x*scale+1,y*scale+1,scale-2,scale-2)
    elseif count == -1 then --bomb
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle('fill',x*scale+1,y*scale+1,scale-2,scale-2)
    elseif count == -2 then --flagged
        love.graphics.setColor(0,0,1)
        love.graphics.rectangle('fill',x*scale+1,y*scale+1,scale-2,scale-2)
    elseif count == -3 then --won
        love.graphics.setColor(0,1,0)
        love.graphics.rectangle('fill',x*scale+1,y*scale+1,scale-2,scale-2)
    else
        love.graphics.setColor(1,1,1) --change this
        love.graphics.rectangle('fill',x*scale+1,y*scale+1,scale-2,scale-2)
        --render text
        if count > 0 then
            love.graphics.setColor(0,0,0)
            love.graphics.print(tostring(count),x*scale,y*scale,0, scale/15,scale/15)
        end
    end
end

function getSquare(x,y)
  x = math.floor(x / scale)
  y = math.floor(y / scale)
  return x,y
end

function flagSquare(x,y)
  if squareExists(x,y) and matrix[x][y].selected == false then
    matrix[x][y].flagged = not matrix[x][y].flagged
  end
end

function getSurroundingSquares(x,y)
  local count = 0
  for i=-1, 1 do
    for j=-1,1 do
      if matrix[x+i] and matrix[x+i][y+j] then
        if matrix[x+i][y+j].bomb then
          count = count + 1
        end
      end
    end
  end
  return count
end

function checkFinished()

    local selectedBombs = 0
    local flagged = 0
    local unselected = 0
    for x=0, size-1 do
        for y=0, size-1 do
            if not matrix[x][y].selected and not matrix[x][y].bomb then unselected = unselected + 1 end
            if matrix[x][y].flagged then flagged = flagged + 1 end
            if matrix[x][y].selected and matrix[x][y].bomb then selectedBombs = selectedBombs + 1 end
        end
    end

    print('flagged:',flagged,'unselected:',unselected,'bombs:',bombCount)
    if selectedBombs > 0 then
        generateMatrix()
        return
    end
    if flagged == bombCount and unselected == 0 then
        print('you win!')
        win = true
    end
end

function love.load()
  generateMatrix()
  love.window.setTitle("Minesweeper by TheSlab Plays")
end

function love.update(dt)
    checkFinished()
    local x, y = love.mouse.getPosition()
    local gridX, gridY = getSquare(x,y)
    if isClicked(1) then
      clearSquare(gridX,gridY)
    end
    if isClicked(2) then
      flagSquare(gridX,gridY)
    end
end

function love.draw()
    for x=0, size-1 do
      for y=0, size-1 do
        item = matrix[x][y]
        if win then
            renderSquare(x,y,-3)
        elseif item.bomb and item.selected then
          renderSquare(x,y,-1)
        elseif item.selected then
          --get surroudning bombs
            local count = getSurroundingSquares(x,y)
            renderSquare(x,y,count)
        elseif item.flagged then
          renderSquare(x,y,-2)
        else
          renderSquare(x,y)
        end
        end
    end
end
