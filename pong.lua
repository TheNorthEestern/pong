pong = {}
function pong.load()
  -- pike_logo = love.graphics.newImage('logo.png')
  -- love.mouse.setVisible(false)
  score_font          = love.graphics.newFont(50)
  bip                 = love.audio.newSource("assets/audio/bip.ogg", "static")
  player_one_score    = 0
  player_two_score    = 0
  ball_speed_x        = 250
  ball_speed_y        = 250

  paddle_start_pos    = love.graphics.getHeight()/2

  ball                = {}
  player_goal         = {}
  player_one_goal     = {}
  player_two_goal     = {}

  ball.x              = math.random(100, 300)
  ball.y              = math.random(100, 300)

  ball.width          = 10
  ball.height         = 10

  player_goal.width   = 50
  player_goal.height  = love.graphics.getHeight()
  player_make_goal = false
  ball_reset_timer = 1

  player_one_goal.x   = 0
  player_one_goal.y   = 0

  player_one_paddle_y = love.graphics.getHeight() / 2

  paddle_width        = 10
  paddle_height       = 40

  player_two_goal.x   = love.graphics.getWidth() - player_goal.width
  player_two_goal.y   = 0
end

function pong.update(dt)
  if player_make_goal == true then
    ball_reset_timer = ball_reset_timer - dt
    if ball_reset_timer <= 0 then
      ball_speed_x = 300
      ball_speed_y = 300
      ball_reset_timer = 1
      player_make_goal = false
    end
  end

  ball.x = ball.x + ball_speed_x * dt
  ball.y = ball.y + ball_speed_y * dt

  pong.checkForScreenCollision()
  pong.checkForPaddleCollision(dt)
  pong.checkIfBallHitPlayerGoal()
end

function pong.draw()
  love.graphics.setBackgroundColor(138, 155, 15, 255)
  -- love.graphics.draw(pike_logo, love.graphics.getWidth()*.02, love.graphics.getHeight()*.85)

  love.graphics.setColor(0, 0, 0, 100)
  love.graphics.setFont(score_font)
  -- love.graphics.print(player_one_score, love.graphics.getWidth() / 2 - 60, 10)
  love.graphics.print(player_two_score, love.graphics.getWidth() / 2 + 30, 10)

  love.graphics.setColor(255, 255, 255, 0)
  -- Left detection box
  love.graphics.rectangle("fill", player_one_goal.x, player_one_goal.y, player_goal.width, player_goal.height)
  -- Right detection box
  love.graphics.rectangle("fill", player_two_goal.x, player_two_goal.y, player_goal.width, player_goal.height)

  -- Left Paddle
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle("fill", player_goal.width + 15, love.mouse.getY(), paddle_width, paddle_height)
  -- Right Paddle
  love.graphics.rectangle("fill", love.graphics.getWidth() - (player_goal.width + 25), ball.y - (paddle_height/2) , paddle_width, paddle_height)
  -- Divider
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle("fill", love.graphics.getWidth() / 2, 0, 10, love.graphics.getHeight())

  -- Ball
  love.graphics.setColor(255, 230, 230, 255)
  love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)

end

function pong.circularDist(x1, y1, x2, y2)
  return math.sqrt((x1-x2)^2 + (y1 -y2)^2)
end

function pong.boundingBoxTest(ax1, ay1, aw, ah, bx1, by1, bw, bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

function pong.checkForScreenCollision()
  if ball.x > (love.graphics.getWidth() - ball.width) or ball.x < 0 then
    love.audio.play(bip)
    ball_speed_x = -ball_speed_x
  end
  if ball.y > (love.graphics.getHeight() - ball.height) or ball.y < 0 then
    love.audio.play(bip)
    ball_speed_y = -ball_speed_y
  end
end

function pong.checkForPaddleCollision()
  -- player one paddle collision
  if pong.boundingBoxTest(player_goal.width + 15, love.mouse.getY(),paddle_width, paddle_height, ball.x, ball.y, ball.width, ball.height) then
     love.audio.play(bip)
     ball_speed_y = -ball_speed_y + (math.random(50, 100)) 
     ball_speed_x = -ball_speed_x + (math.random(1, 50))
  end
  -- player two paddle collision
  if pong.boundingBoxTest(love.graphics.getWidth() - (player_goal.width + 25), ball.y, paddle_width, paddle_height, ball.x, ball.y, ball.width, ball.height) then
     love.audio.play(bip)
     ball_speed_y = -ball_speed_y - (math.random(50, 100)) 
     ball_speed_x = -ball_speed_x - (math.random(1, 50))
  end
end

function pong.checkIfBallHitPlayerGoal()
  if pong.boundingBoxTest(player_one_goal.x, player_one_goal.y, player_goal.width, player_goal.height, ball.x, ball.y, ball.width, ball.height) then
     player_two_score = player_two_score + 1
     ball.x = player_two_goal.x - 150 
     ball.y = math.random(60, love.graphics.getHeight()-60) 
     ball_speed_x = 0
     ball_speed_y = 0
     player_make_goal = true
  end
  if pong.boundingBoxTest(player_two_goal.x, player_two_goal.y, player_goal.width, player_goal.height, ball.x, ball.y, ball.width, ball.height) then
     ball.x = player_one_goal.x + 150 
     ball.y = math.random(60, love.graphics.getHeight()-60) 
     ball_speed_x = 0
     ball_speed_y = 0
     player_make_goal = true
  end
end
