matrix = {}
size = 10
percent = .1

width, height = love.graphics.getDimensions()
scale = math.floor(math.min(width, height) / size)

debounce = false
function isClicked()
  if not love.mouse.isDown(1) then debounce = false end
  if not debounce and love.mouse.isDown(1) then
    debounce = true
    return true
  else
    return false
  end
end

function generateMatrix()
  --generate bombs
  for x=0, size do
    matrix[x] = {}
    for y=0, size do
      bomb = false
      if math.random() < percent then bomb = true end
      matrix[x][y] = {}
      matrix[x][y].selected = false
      matrix[x][y].bomb = bomb
    end
  end
end

function renderSquare(x,y,count)
  if count == nil then
    love.graphics.setColor(.5,.5,.5)
    love.graphics.rectangle('fill',x*scale+1,y*scale+1,scale-2,scale-2)
  else
    love.graphics.setColor(1,1,1) --change this
    love.graphics.rectangle('fill',x*scale+1,y*scale+1,scale-2,scale-2)
    --render text
    love.graphics.setColor(0,0,0)
    love.graphics.print(tostring(count),x*scale,y*scale,0, 5,5)
  end
end

function love.load()
  generateMatrix()
end

function love.update(dt)
  local x, y = love.mouse.getPosition()
  print(isClicked())
end

function love.draw()
  for x=0, size do
    for y=0, size do
      item = matrix[x][y]
      if item.selected then
        renderSquare(x,y)
        --get surroudning bombs
      else
        renderSquare(x,y,5)
      end
    end
  end
end
