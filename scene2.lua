-- Jacob Dumbacher & Bradley Fleming
-- CS 371 Project Phase 2
-- 28 November 2022
-- Scene 2 - Game Play

local composer = require( "composer" )
local scene = composer.newScene()
local physics = require("physics");
local widget = require( "widget" ); 

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

local buildings_1 = {};
local buildings_2 = {};
local grounds = {};
local invisibleObstacles = {};
local visibleObstacles = {};
local invisibleAlpha = 0.0;

local pauseButton;
local pauseMenu;
local resumeButton;
local quitButton;
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.

   -- lavender background
   background = display.newRect(sceneGroup, display.contentCenterX - 50 , display.contentCenterY, display.contentWidth + 400, display.contentHeight) 
   background:setFillColor(0.65, 0.5, 1)

   building1 = display.newImage(sceneGroup, "Resources/Background/bgg.png", display.contentCenterX - 500, display.contentCenterY * 0.6)
   building1.xScale = 4;
   building1.yScale = 4;
   table.insert(buildings_1, building1);
   building1_2 = display.newImage(sceneGroup, "Resources/Background/bgg.png", display.contentCenterX + 0, display.contentCenterY * 0.6)
   building1_2.xScale = 4;
   building1_2.yScale = 4;
   table.insert(buildings_1, building1_2);
   building1_3 = display.newImage(sceneGroup, "Resources/Background/bgg.png", display.contentCenterX + 500, display.contentCenterY * 0.6)
   building1_3.xScale = 4;
   building1_3.yScale = 4;
   table.insert(buildings_1, building1_3);
   building1_4 = display.newImage(sceneGroup, "Resources/Background/bgg.png", display.contentCenterX + 1000, display.contentCenterY * 0.6)
   building1_4.xScale = 4;
   building1_4.yScale = 4;
   table.insert(buildings_1, building1_4);

   building2 = display.newImage(sceneGroup, "Resources/Background/bgf.png", display.contentCenterX - 500, display.contentCenterY * 0.6)
   building2.xScale = 4;
   building2.yScale = 4;
   table.insert(buildings_2, building2);
   building2_2 = display.newImage(sceneGroup, "Resources/Background/bgf.png", display.contentCenterX + 0, display.contentCenterY * 0.6)
   building2_2.xScale = 4;
   building2_2.yScale = 4;
   table.insert(buildings_2, building2_2);
   building2_3 = display.newImage(sceneGroup, "Resources/Background/bgf.png", display.contentCenterX  + 500, display.contentCenterY * 0.6)
   building2_3.xScale = 4;
   building2_3.yScale = 4;
   table.insert(buildings_2, building2_3);
   building2_4 = display.newImage(sceneGroup, "Resources/Background/bgf.png", display.contentCenterX + 1000, display.contentCenterY * 0.6)
   building2_4.xScale = 4;
   building2_4.yScale = 4;
   table.insert(buildings_2, building2_4);

   ground = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 800, display.contentHeight * 0.90);
   ground.xScale = 4;
   ground.yScale = 4;
   table.insert(grounds, ground);
   ground_2 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 700, display.contentHeight * 0.90);
   ground_2.xScale = 4;
   ground_2.yScale = 4;
   table.insert(grounds, ground_2);
   ground_3 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 600, display.contentHeight * 0.90);
   ground_3.xScale = 4;
   ground_3.yScale = 4;
   table.insert(grounds, ground_3);
   ground_4 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 500, display.contentHeight * 0.90);
   ground_4.xScale = 4;
   ground_4.yScale = 4;
   table.insert(grounds, ground_4);
   ground_5 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 400, display.contentHeight * 0.90);
   ground_5.xScale = 4;
   ground_5.yScale = 4;
   table.insert(grounds, ground_5);
   ground_6 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 300, display.contentHeight * 0.90);
   ground_6.xScale = 4;
   ground_6.yScale = 4;
   table.insert(grounds, ground_6);
   ground_7 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 200, display.contentHeight * 0.90);
   ground_7.xScale = 4;
   ground_7.yScale = 4;
   table.insert(grounds, ground_7);
   ground_8 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 100, display.contentHeight * 0.90);
   ground_8.xScale = 4;
   ground_8.yScale = 4;
   table.insert(grounds, ground_8);
   ground_9 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX, display.contentHeight * 0.90);
   ground_9.xScale = 4;
   ground_9.yScale = 4;
   table.insert(grounds, ground_9);
   ground_10 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX + 100, display.contentHeight * 0.90);
   ground_10.xScale = 4;
   ground_10.yScale = 4;
   table.insert(grounds, ground_10);
   ground_11 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX + 200, display.contentHeight * 0.90);
   ground_11.xScale = 4;
   ground_11.yScale = 4;
   table.insert(grounds, ground_11);
   ground_12 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX + 300, display.contentHeight * 0.90);
   ground_12.xScale = 4;
   ground_12.yScale = 4;
   table.insert(grounds, ground_12);
   ground_13 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX + 400, display.contentHeight * 0.90);
   ground_13.xScale = 4;
   ground_13.yScale = 4;
   table.insert(grounds, ground_13);
   ground_14 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX + 500, display.contentHeight * 0.90);
   ground_14.xScale = 4;
   ground_14.yScale = 4;
   table.insert(grounds, ground_14);
   ground_15 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX + 600, display.contentHeight * 0.90);
   ground_15.xScale = 4;
   ground_15.yScale = 4;
   table.insert(grounds, ground_15);
   ground_16 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX + 700, display.contentHeight * 0.90);
   ground_16.xScale = 4;
   ground_16.yScale = 4;
   table.insert(grounds, ground_16);
   ground_17 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX + 800, display.contentHeight * 0.90);
   ground_17.xScale = 4;
   ground_17.yScale = 4;
   table.insert(grounds, ground_17);

   runningMan = display.newSprite(runningMan_sheet, runningMan_sequenceData)
   runningMan.xScale = 0.4;
   runningMan.yScale = 0.4;
   runningMan.x = display.contentCenterX * 0.4;
   runningMan.y = display.contentCenterY * 1.19;
   sceneGroup:insert(runningMan);

   drone = display.newSprite(drone_sheet, drone_sequenceData)
   drone.xScale = 2;
   drone.yScale = 2;
   drone.x = display.contentCenterX;
   drone.y = display.contentCenterY;
   sceneGroup:insert(drone);

   obstacle1 = display.newSprite(obstacle_sheet, obstacle_sequenceData)
   obstacle1.xScale = 3;
   obstacle1.yScale = 3;
   obstacle1.x = display.contentCenterX * 1.8;
   obstacle1.y = display.contentCenterY * 1.25 + 20;
   obstacle1.myName = "Danger";
   sceneGroup:insert(obstacle1);
   table.insert(visibleObstacles, obstacle1);

   invisibleObstacle1 = display.newRect(obstacle1.x, obstacle1.y, 80, 96);
   invisibleObstacle1:setFillColor(0.5, 0, 0);
   invisibleObstacle1.alpha = invisibleAlpha;
   invisibleObstacle1.yScale = 1;
   invisibleObstacle1.xScale = 1;
   invisibleObstacle1.myName = "Danger";
   sceneGroup:insert(invisibleObstacle1);
   table.insert(invisibleObstacles, invisibleObstacle1);

   invisibleGroundPlatform = display.newRect(display.contentCenterX, display.contentHeight * 0.90 + 20, display.contentWidth, 256);
   invisibleGroundPlatform:setFillColor(0, 0, 0.5);
   invisibleGroundPlatform.alpha = invisibleAlpha;
   invisibleGroundPlatform.yScale = 1;
   invisibleGroundPlatform.xScale = 1;
   invisibleGroundPlatform.myName = "Ground";
   sceneGroup:insert(invisibleGroundPlatform);

   invisiblePlayer = display.newRect(runningMan.x, runningMan.y, 60, 160);
   invisiblePlayer:setFillColor(0, 0.5, 0);
   invisiblePlayer.alpha = invisibleAlpha;
   invisiblePlayer.yScale = 1;
   invisiblePlayer.xScale = 1;
   invisiblePlayer.myName = "Player";
   sceneGroup:insert(invisiblePlayer);

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
               runningMan:setSequence("crouch");
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

   function onCollision(self, event)
      if ( event.phase == "began" ) then
         -- running into obstacle
         if(event.other.myName == "Danger") then
            print("DANGER")
            pauseGameMethod(true);
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
      params = event.params
      runningMan:setSequence("running");
      drone:setSequence("flying");
      
      obstacle1:setSequence("trash");
      physics.start();
      physics.setGravity (0, 9.8*2);

   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
      drone:play();
      obstacle1:play();
      -- runningMan:play();
      physics.addBody(invisiblePlayer, "dynamic", {bounce = 0});
      physics.addBody(invisibleGroundPlatform, "static", {bounce = 0});
      physics.addBody(invisibleObstacle1, "static", {bounce = 0});

      -- unpauses the game after re-entering
      pauseGameMethod(false);

      local function moveBackground()
         if(not pauseGame) then
            local groundSpeed = 10;
            local building1Speed = 2;
            local building2Speed = 6;
            for _, building in ipairs(buildings_1) do
               building.x = building.x - building1Speed;
               if(building.x < -512) then
                  building.x = 1300;
               end
            end
            for _, building in ipairs(buildings_2) do
               building.x = building.x - building2Speed;
               if(building.x < -512) then
                  building.x = 1400;
               end
            end
            for _, ground in ipairs(grounds) do
               ground.x = ground.x - groundSpeed;
               if(ground.x < -512) then
                  ground.x = 1200;
               end
            end
            for _, obstacle in ipairs(invisibleObstacles) do
               obstacle.x = obstacle.x - groundSpeed;
               if(obstacle.x < -512) then
                  obstacle.x = 1200;
               end
               visibleObstacles[_].x = obstacle.x;
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

   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
      Runtime:removeEventListener("tap", userTap)
      -- pauseGameMethod(true);
      -- invisiblePlayer:removeEventListener("collision")
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view
   -- sceneGroup.remove(runningMan);

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