-- Jacob Dumbacher & Bradley Fleming
-- CS 371 Project Phase 2
-- 28 November 2022
-- Scene 2 - Game Play

local composer = require( "composer" )
local scene = composer.newScene()
local physics = require("physics");
local widget = require( "widget" ); 


local background;
local building1;
local building1_2;
local building1_3;
local building1_4;
local building2;
local building2_2;
local building2_3;
local building2_4;
local ground;
local ground_2;
local ground_3;
local ground_4;
local ground_5;
local ground_6;
local ground_7;
local ground_8;
local ground_9;
local ground_10;
local ground_11;
local ground_12;
local ground_13;
local ground_14;
local ground_15;
local ground_16;
local ground_17;
local drone;
local obstacle1;
local invisibleObstacle1;
local invisibleGroundPlatform;
local invisiblePlayer;

local buildings_1 = {};
local buildings_2 = {};
local grounds = {};
local invisibleObstacles = {};
local visibleObstacles = {};

local buildingGroup1; 
local buildingGroup2;
local groundGroup;
local obstacleGroup;
local invisibleObstacleGroup;

local runningMan;

local score;

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
-- local forward references should go here
local runningMan_opt = {
   frames = {
       {x = 0, y = 0, width = 800, height = 480}, -- frame running 1
       {x = 800, y = 0, width = 800, height = 480}, -- frame running 2
       {x = 1600, y = 0, width = 800, height = 480}, -- frame running 3
       {x = 2400, y = 0, width = 800, height = 480}, -- frame running 4
       {x = 3200, y = 0, width = 800, height = 480}, -- frame running 5
       {x = 4000, y = 0, width = 800, height = 480}, -- frame running 6
       {x = 4800, y = 0, width = 800, height = 480}, -- frame running 7
       {x = 5600, y = 0, width = 800, height = 480}, -- frame running 8
       {x = 6400, y = 80, width = 800, height = 480}, -- frame idle 9
       {x = 7200, y = 80, width = 800, height = 480}, -- frame idle 10
       {x = 8000, y = 80, width = 800, height = 480}, -- frame crouch 11
   }
}

local drone_opt = {
   frames = {
       {x = 0, y = 0, width = 52, height = 33}, -- frame running 1
       {x = 52, y = 0, width = 52, height = 33}, -- frame running 2
   }
}

local obstacle_opt = {
   frames = {
       {x = 0, y = 1, width = 32, height = 32}, -- trash 1 
       {x = 0, y = 33, width = 32, height = 32}, -- cone 2
       {x = 64, y = 33, width = 32, height = 32}, -- mail box 3
       {x = 96, y = 33, width = 32, height = 32}, -- fire hydrant 4
       {x = 128, y = 33, width = 32, height = 32}, -- pillar 5
       {x = 0, y = 65, width = 32, height = 64}, -- traffic light 6
       {x = 32, y = 65, width = 32, height = 64}, -- stop sign 7
       {x = 0, y = 129, width = 32, height = 32}, -- tire 8
       {x = 64, y = 129, width = 32, height = 32}, -- fence 9
   }
}

-- Setup File Path to Resources
-- local docs_path = system.pathForFile( "", system.ResourceDirectory)


local runningMan_sheet = graphics.newImageSheet("Resources/Sprite/spritesheet.png", runningMan_opt)

local drone_sheet = graphics.newImageSheet("Resources/Obstacles/Drone.png", drone_opt)

local obstacle_sheet = graphics.newImageSheet("Resources/Obstacles/Obstacles.png", obstacle_opt)


local runningMan_sequenceData = {
   {name = "idle", frames = {9, 10}, time = 700, loopCount = 0},
   {name = "running", frames = {1, 2, 3, 4, 5, 6, 7, 8}, time = 700, loopCount = 0},
   {name = "crouch", frames = {11}, time = 700, loopCount = 0},
   {name = "jump", frames = {2}, time = 700, loopCount = 0}
}

local drone_sequenceData = {
   {name = "flying", frames = {1, 2}, time = 300, loopCount = 0},
}

local obstacle_sequenceData = {
   {name = "trash", frames = {1}, loopCount = 1},
   {name = "cone", frames = {2}, loopCount = 1},
   {name = "mailBox", frames = {3}, loopCount = 1},
   {name = "fireHydrant", frames = {4}, loopCount = 1},
   {name = "pillar", frames = {5}, loopCount = 1},
   {name = "trafficLight", frames = {6}, loopCount = 1},
   {name = "stopSign", frames = {7}, loopCount = 1},
   {name = "tire", frames = {8}, loopCount = 1},
   {name = "fence", frames = {9}, loopCount = 1},
}

-- local sheet = runningMan_sheet;
-- local sequenceData = runningMan_sequenceData;

-- local buildings_1 = {};
-- local buildings_2 = {};
-- local grounds = {};
-- local invisibleObstacles = {};
-- local visibleObstacles = {};
local invisibleAlpha = 0.0;

local pauseButton;
local pauseMenu;
local resumeButton;
local quitButton;
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
   print("Scene 2 Create called")
   print(display.contentCenterX)
 
   local sceneGroup = self.view

   buildingGroup1 = display.newGroup( );
   buildingGroup2 = display.newGroup( );
   groundGroup = display.newGroup( );
   obstacleGroup = display.newGroup( );
   invisibleObstacleGroup = display.newGroup( );
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.

   -- lavender background
   background = display.newRect(  display.contentCenterX - 50 , display.contentCenterY, display.contentWidth + 400, display.contentHeight) 
   background:setFillColor(0.65, 0.5, 1)
   sceneGroup:insert(background);

   local xOffset = -500;
   for i = 1,4 do
      local building = display.newImage(  "Resources/Background/bgg.png", display.contentCenterX + xOffset, display.contentCenterY * 0.6)
      building:setFillColor(0.65, 0.5, 1)
      -- sceneGroup:insert(building);
      building.x = display.contentCenterX + xOffset;
      building.y = display.contentCenterY * 0.6;
      building.xScale = 4;
      building.yScale = 4;
      buildingGroup1:insert(building);
      -- table.insert(buildings_1, building);
      xOffset = xOffset + 500;
   end
   sceneGroup:insert(buildingGroup1);

   xOffset = -500;
   for i = 1,4 do
      local building = display.newImage(  "Resources/Background/bgf.png", display.contentCenterX + xOffset, display.contentCenterY * 0.6)
      building:setFillColor(0.65, 0.5, 1)
      building.x = display.contentCenterX + xOffset;
      building.y = display.contentCenterY * 0.6;
      building.xScale = 4;
      building.yScale = 4;
      -- sceneGroup:insert(building);
      buildingGroup2:insert(building);
      -- table.insert(buildings_2, building);
      xOffset = xOffset + 500;
   end
   sceneGroup:insert(buildingGroup2);

   xOffset = -800;
   for i = 1,17 do
      local ground = display.newImage( "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 800, display.contentHeight * 0.90);
      -- sceneGroup:insert(building);
      ground.x = display.contentCenterX + xOffset;
      ground.xScale = 4;
      ground.yScale = 4;
      groundGroup:insert(ground);
      -- table.insert(grounds, ground);
      xOffset = xOffset + 100;
   end
   sceneGroup:insert(groundGroup);

   runningMan = display.newSprite(runningMan_sheet, runningMan_sequenceData)
   runningMan.xScale = 0.4;
   runningMan.yScale = 0.4;
   runningMan.x = display.contentCenterX * 0.4;
   runningMan.y = display.contentCenterY * 1.19;
   sceneGroup:insert(runningMan);

   invisiblePlayer = display.newRect(runningMan.x, runningMan.y, 60, 160);
   invisiblePlayer:setFillColor(0, 0.5, 0);
   invisiblePlayer.alpha = invisibleAlpha;
   invisiblePlayer.yScale = 1;
   invisiblePlayer.xScale = 1;
   invisiblePlayer.myName = "Player";
   sceneGroup:insert(invisiblePlayer);

   -- drone = display.newSprite(drone_sheet, drone_sequenceData)
   -- drone.xScale = 2;
   -- drone.yScale = 2;
   -- drone.x = display.contentCenterX;
   -- drone.y = display.contentCenterY;
   -- sceneGroup:insert(drone);

   xOffset = 1200
   for i = 1, 1 do
      local obstacle = display.newSprite(obstacle_sheet, obstacle_sequenceData)
      obstacle.xScale = 3;
      obstacle.yScale = 3;
      obstacle.x = display.contentCenterX + xOffset;
      obstacle.y = display.contentCenterY * 1.25 + 20;
      obstacle:setSequence( "trash" )
      obstacle.myName = "Danger";
      obstacleGroup:insert( obstacle );

      invisibleObstacle = display.newRect(obstacle.x, obstacle.y, 80, 96);
      invisibleObstacle:setFillColor(0.5, 0, 0);
      invisibleObstacle.alpha = invisibleAlpha;
      invisibleObstacle.yScale = 1;
      invisibleObstacle.xScale = 1;
      invisibleObstacle.myName = "Danger";
      invisibleObstacleGroup:insert( invisibleObstacle )
         
      -- xOffset = xOffset + 100;
   end
   sceneGroup:insert(obstacleGroup);
   sceneGroup:insert(invisibleObstacleGroup);

   -- obstacle1 = display.newSprite(obstacle_sheet, obstacle_sequenceData)
   -- obstacle1.xScale = 3;
   -- obstacle1.yScale = 3;
   -- obstacle1.x = display.contentCenterX * 1.8;
   -- obstacle1.y = display.contentCenterY * 1.25 + 20;
   -- obstacle1.myName = "Danger";
   -- sceneGroup:insert(obstacle1);
   -- table.insert(visibleObstacles, obstacle1);

   -- invisibleObstacle1 = display.newRect(obstacle1.x, obstacle1.y, 80, 96);
   -- invisibleObstacle1:setFillColor(0.5, 0, 0);
   -- invisibleObstacle1.alpha = invisibleAlpha;
   -- invisibleObstacle1.yScale = 1;
   -- invisibleObstacle1.xScale = 1;
   -- invisibleObstacle1.myName = "Danger";
   -- sceneGroup:insert(invisibleObstacle1);
   -- table.insert(invisibleObstacles, invisibleObstacle1);

   invisibleGroundPlatform = display.newRect(display.contentCenterX, display.contentHeight * 0.90 + 20, display.contentWidth, 256);
   invisibleGroundPlatform:setFillColor(0, 0, 0.5);
   invisibleGroundPlatform.alpha = invisibleAlpha;
   invisibleGroundPlatform.yScale = 1;
   invisibleGroundPlatform.xScale = 1;
   invisibleGroundPlatform.myName = "Ground";
   sceneGroup:insert(invisibleGroundPlatform);

   -- invisiblePlayer = display.newRect(runningMan.x, runningMan.y, 60, 160);
   -- invisiblePlayer:setFillColor(0, 0.5, 0);
   -- invisiblePlayer.alpha = invisibleAlpha;
   -- invisiblePlayer.yScale = 1;
   -- invisiblePlayer.xScale = 1;
   -- invisiblePlayer.myName = "Player";
   -- sceneGroup:insert(invisiblePlayer);

   scoreText = display.newText("0", 15, 30, native.systemFont, 40); 
   scoreText:setFillColor(1, 1, 1);
   scoreText.anchorX = 0;
   sceneGroup:insert(scoreText);



   currentJump = false;
   pauseGame = false;
   score = 0;

   local options = {
      effect = "slideDown",
      time = 100
   }

   local function back (event)
      composer.gotoScene("scene1", {
         effect = "slideUp",
         time = 100,
         params = {}
      });
      composer.removeScene("scene2", true);
   end


   local function pause (event)
      print("hello")
      -- composer.gotoScene("scene1", options);
      if(event.phase == "began") then
         pauseGameMethod(not pauseGame);
         if(pauseGame) then

            -- create game paused menu
            pauseMenu = display.newRect(display.contentCenterX, display.contentCenterY * 0.8, display.contentWidth/3, display.contentHeight/2);
            pauseMenu:setFillColor(0, 0, 1)
            pauseMenu.alpha = 0.4;
            sceneGroup:insert(pauseMenu);

             resumeButton = widget.newButton( {
               label = "button2",
               onEvent = pause,
               emboss = false,
               shape = "roundedRect",
               width = 300,
               height = 80,
               cornerRadius = 2,
               fillColor = { default = {1, 1, 1, 0.8}, over={}},
               strokeColor = { default = {0, 0, 0, 0}, over={}},
               strokeWidth = 0,
               fontSize = 20,
               labelColor = {default = {0, 0, 0, 1}, over={}}
            });
            resumeButton.x = display.contentCenterX;
            resumeButton.y = display.contentCenterY * 0.8 - 50;
            resumeButton:setLabel( "RESUME" );
            sceneGroup:insert(resumeButton);

            quitButton = widget.newButton( {
               label = "button3",
               onEvent = back,
               emboss = false,
               shape = "roundedRect",
               width = 300,
               height = 80,
               cornerRadius = 2,
               fillColor = { default = {1, 1, 1, 0.8}, over={}},
               strokeColor = { default = {0, 0, 0, 0}, over={}},
               strokeWidth = 0,
               fontSize = 20,
               labelColor = {default = {0, 0, 0, 1}, over={}}
         
            });
            quitButton.x = display.contentCenterX;
            quitButton.y = display.contentCenterY * 0.8 + 50;
            quitButton:setLabel("QUIT");
            sceneGroup:insert(quitButton);
         else
            display.remove(pauseMenu);
            resumeButton:removeSelf();
            quitButton:removeSelf();
         end
      end
   end


   pauseButton = widget.newButton( {
      label = "button1",
      onEvent = pause,
      emboss = false,
      shape = "roundedRect",
      width = 100,
      height = 50,
      cornerRadius = 2,
      fillColor = { default = {0, 0, 1, 0.4}, over={}},
      strokeColor = { default = {0, 0, 0, 0}, over={}},
      strokeWidth = 0,
      fontSize = 20,
      labelColor = {default = {1, 1, 1, 1}, over={}}

   });

   pauseButton.x = display.contentCenterX;
   pauseButton.y = 50;
   pauseButton:setLabel( "PAUSE" );
   sceneGroup:insert(pauseButton);

   function userTap(event)
      if(event.x < 630 and event.x > 510 and event.y < 570) then
         return
      end 
      if(event.phase == "began") then
         if(not pauseGame) then
            --left tap
            if(event.x < display.contentCenterX) then
               if(currentJump == false) then
                  runningMan:setSequence("crouch");
               end
            -- right tap
            else
               if(currentJump == false) then
                  runningMan:setSequence("jump");
                  invisiblePlayer:applyLinearImpulse(0, -2, invisiblePlayer.x, invisiblePlayer.y);
                  currentJump = true;
               end
            end
            runningMan:play()
         end
      elseif(event.phase == "ended" and event.x < display.contentCenterX) then
         if(currentJump == false and not pauseGame) then
            runningMan:setSequence("running");
            runningMan:play();
         end
      end
   end

   function pauseGameMethod(pauseBool)
      pauseGame = pauseBool;
      if(pauseBool) then      
         runningMan:pause();
         physics.pause();
      else
         runningMan:play();
         physics.start();
      end
   end

   local function gameOverListener(event) 
      local eogFlag = true;
      composer.gotoScene("scene3", {
         effect = "slideUp",
         time = 100,
         params = {eogFlag = true, finalScore = score}
      });
      composer.removeScene("scene2", true);
      -- timerGameOver:pause( );
   end

   function onCollision(self, event)
      if ( event.phase == "began" ) then
         -- running into obstacle
         if(event.other.myName == "Danger") then
            print("DANGER")
            pauseGameMethod(true);

            local gameOver = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight);
            gameOver:setFillColor(0, 0, 0, 0.225)
            gameOver.alpha = 0.4;
            sceneGroup:insert(gameOver);

            local gameOverText = display.newText("Game Over", display.contentCenterX, display.contentCenterY, native.systemFontBold, 44)
            sceneGroup:insert(gameOverText);

            timerGameOver = timer.performWithDelay( 2000, gameOverListener)

         -- landing from a jump
         elseif(event.other.myName == "Ground") then
            currentJump = false;
            runningMan:setSequence("running");
            runningMan:play();
            print("running")
         end
      elseif ( event.phase == "ended" ) then
         print("ended")
      end

   end

end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      -- local currentScene = composer.getScene( "scene2" )
      -- print("Current Scene = ");
      -- print(currentScene)
      -- composer.gotoScene( "scene2" );
      params = event.params
      runningMan:setSequence("running");
      -- drone:setSequence("flying");
      
      -- obstacle1:setSequence("trash");
      physics.start();
      physics.setGravity (0, 9.8*2);

   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
      -- drone:play();
      -- obstacle1:play();
      -- runningMan:play();
      physics.addBody(invisiblePlayer, "dynamic", {bounce = 0});
      physics.addBody(invisibleGroundPlatform, "static", {bounce = 0});
      
      for i = 1, invisibleObstacleGroup.numChildren do 
         local child = invisibleObstacleGroup[i];
         physics.addBody(child, "static", {bounce = 0});
      end

      -- unpauses the game after re-entering
      pauseGameMethod(false);

      local function moveBackground()
         if(not pauseGame) then
            local groundSpeed = 10;
            local building1Speed = 2;
            local building2Speed = 6;

            for i = 1, buildingGroup1.numChildren do
               local child = buildingGroup1[i]
               child.x = child.x - building1Speed;
               if(child.x < -512) then
                  child.x = 1300;
               end
            end

            for i = 1,buildingGroup2.numChildren do
               local child = buildingGroup2[i]
               child.x = child.x - building2Speed;
               if(child.x < -512) then
                  child.x = 1400;
               end
            end

            for i = 1, groundGroup.numChildren do
               local child = groundGroup[i]
               child.x = child.x - groundSpeed;
               if(child.x < -512) then
                  child.x = 1200;
               end
            end

            if score > 3 then
               for i = 1,obstacleGroup.numChildren do
                  local child = obstacleGroup[i];
                  local invisbleChild = invisibleObstacleGroup[i];
                  child.x = child.x - groundSpeed;
                  invisbleChild.x = invisbleChild.x - groundSpeed;
                  if(child.x < -512) then
                     child.x = math.random(1200, 1700);
                     invisbleChild.x = child.x;

                     local obstacleSelection = math.random(1 ,  9);
                     if obstacleSelection == 1 then
                        child:setSequence("trash");
                     elseif obstacleSelection == 2 then 
                        child:setSequence("cone");
                     elseif obstacleSelection == 3 then 
                        child:setSequence("mailBox");
                     elseif obstacleSelection == 4 then 
                        child:setSequence("fireHydrant");
                     elseif obstacleSelection == 5 then 
                        child:setSequence("pillar");
                     elseif obstacleSelection == 6 then 
                        child:setSequence("trafficLight");
                     elseif obstacleSelection == 7 then 
                        child:setSequence("stopSign");
                     elseif obstacleSelection == 8 then 
                        child:setSequence("tire");
                     elseif obstacleSelection == 9 then 
                        child:setSequence("fence");
                     end
                  end
               end
            end

            runningMan.y = invisiblePlayer.y - 12;

         end
      end

      local function increaseScore()
         if(not pauseGame) then
            score = score + 1;
            scoreText.text = score
         end
         print(score)
      end

      -- if statement prevents the game from performing moveBackground multiple times after opening scene2 multiple times
      if(timer1 == nil) then
         timer1 = timer.performWithDelay(33.333, moveBackground, 0)
         timer2 = timer.performWithDelay(1000, increaseScore, 0);
      end
      
      Runtime:addEventListener("touch", userTap)
      invisiblePlayer.collision = onCollision
      invisiblePlayer:addEventListener("collision")
   end
end
 
-- "scene:hide()"
function scene:hide( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
      runningMan:pause();
      pauseGameMethod(true);
      -- timer.pause(timer1);
      -- timer.pause(timer2);

   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
      
      Runtime:removeEventListener("touch", userTap)
      -- invisiblePlayer:removeEventListener("collision")
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
   sceneGroup = self.view

      timer.pause(timer1);
      timer.pause(timer2);

      buildingGroup1:removeSelf();
      buildingGroup1 = nil;

      buildingGroup2:removeSelf();
      buildingGroup2 = nil;

      groundGroup:removeSelf();
      groundGroup = nil;

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------
 
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


---------------------------------------------------------------------------------
 
return scene