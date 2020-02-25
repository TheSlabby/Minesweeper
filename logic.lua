logic = {}


matrix = {}
size = 20
percent = .3
safeZone = 4
win = false

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

            --safezone calculations
            matrix[x][y].bomb = math.abs(startX-x) + math.abs(startY-y) > safeZone

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
    for i=-1,1 do
        for j=-1,1 do
            if squareExists(x+i,y+j) and matrix[x+i][y+j].selected == false then
                clearSquare(x+i,y+j)
            end
        end
    end
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

return logic
