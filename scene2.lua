-- Jacob Dumbacher & Bradley Fleming
-- CS 371 Project Phase 2
-- 28 November 2022
-- Scene 2 - Game Play

-- local lfs = require( "lfs" )
local composer = require( "composer" )
local scene = composer.newScene()
 
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

local speed;
local buildings_1 = {};
local buildings_2 = {};
local grounds = {};
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.

   -- lavendar background
   background = display.newRect(sceneGroup, display.contentCenterX - 50 , display.contentCenterY, display.contentWidth + 400, display.contentHeight) 
   background:setFillColor(0.65, 0.5, 1)

   building1 = display.newImage(sceneGroup, "Resources/Background/bgg.png", display.contentCenterX, display.contentCenterY * 0.6)
   building1.xScale = 4;
   building1.yScale = 4;
   table.insert(buildings_1, building1);
   building1_2 = display.newImage(sceneGroup, "Resources/Background/bgg.png", display.contentCenterX + 512, display.contentCenterY * 0.6)
   building1_2.xScale = 4;
   building1_2.yScale = 4;
   table.insert(buildings_1, building1_2);
   building1_3 = display.newImage(sceneGroup, "Resources/Background/bgg.png", display.contentCenterX - 512, display.contentCenterY * 0.6)
   building1_3.xScale = 4;
   building1_3.yScale = 4;
   table.insert(buildings_1, building1_3);

   building2 = display.newImage(sceneGroup, "Resources/Background/bgf.png", display.contentCenterX, display.contentCenterY * 0.6)
   building2.xScale = 4;
   building2.yScale = 4;
   table.insert(buildings_2, building2);
   building2_2 = display.newImage(sceneGroup, "Resources/Background/bgf.png", display.contentCenterX + 512, display.contentCenterY * 0.6)
   building2_2.xScale = 4;
   building2_2.yScale = 4;
   table.insert(buildings_2, building2_2);
   building2_3 = display.newImage(sceneGroup, "Resources/Background/bgf.png", display.contentCenterX - 512, display.contentCenterY * 0.6)
   building2_3.xScale = 4;
   building2_3.yScale = 4;
   table.insert(buildings_2, building2_3);

   ground = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX, display.contentHeight * 0.90);
   ground.xScale = 4;
   ground.yScale = 4;
   table.insert(grounds, ground);
   ground_2 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 128, display.contentHeight * 0.90);
   ground_2.xScale = 4;
   ground_2.yScale = 4;
   table.insert(grounds, ground_2);
   ground_3 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX + 128, display.contentHeight * 0.90);
   ground_3.xScale = 4;
   ground_3.yScale = 4;
   table.insert(grounds, ground_3);
   ground_4 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 256, display.contentHeight * 0.90);
   ground_4.xScale = 4;
   ground_4.yScale = 4;
   table.insert(grounds, ground_4);
   ground_5 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX + 256, display.contentHeight * 0.90);
   ground_5.xScale = 4;
   ground_5.yScale = 4;
   table.insert(grounds, ground_5);
   ground_6 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX + 384, display.contentHeight * 0.90);
   ground_6.xScale = 4;
   ground_6.yScale = 4;
   table.insert(grounds, ground_6);
   ground_7 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 384, display.contentHeight * 0.90);
   ground_7.xScale = 4;
   ground_7.yScale = 4;
   table.insert(grounds, ground_7);
   ground_8 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX + 512, display.contentHeight * 0.90);
   ground_8.xScale = 4;
   ground_8.yScale = 4;
   table.insert(grounds, ground_8);
   ground_9 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 512, display.contentHeight * 0.90);
   ground_9.xScale = 4;
   ground_9.yScale = 4;
   table.insert(grounds, ground_9);
   ground_10 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX + 640, display.contentHeight * 0.90);
   ground_10.xScale = 4;
   ground_10.yScale = 4;
   table.insert(grounds, ground_10);
   ground_11 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 640, display.contentHeight * 0.90);
   ground_11.xScale = 4;
   ground_11.yScale = 4;
   table.insert(grounds, ground_11);
   ground_12 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX + 768, display.contentHeight * 0.90);
   ground_12.xScale = 4;
   ground_12.yScale = 4;
   table.insert(grounds, ground_12);
   ground_13 = display.newImage(sceneGroup, "Resources/Background/sprite13-sheet0.png", display.contentCenterX - 768, display.contentHeight * 0.90);
   ground_13.xScale = 4;
   ground_13.yScale = 4;
   table.insert(grounds, ground_13);

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
   obstacle1.x = display.contentCenterX * 0.6;
   obstacle1.y = display.contentCenterY * 1.25 + 40;
   sceneGroup:insert(obstacle1);


   local buttonBack = display.newRect(display.contentCenterX,50,100,50);
   sceneGroup:insert(buttonBack);
   
   local options = {
      effect = "slideDown",
      time = 100
   }

   local function back (event)
      print("hello")
      runningMan:setSequence("idle");
      runningMan:play();
      composer.gotoScene("scene1", options);
   end

   -- local function moveBackground()
   --    print("running")
   --    local groundSpeed = 5;
   --    local building1Speed = 2;
   --    local building2Speed = 3;
   --    for _, building in ipairs(buildings_1) do
   --       building.x = building.x - building1Speed;
   --       if(building.x < -512) then
   --          table.remove(buildings_1, _);
   --          newBuilding = display.newImage(sceneGroup, "Resources\\Background\\bgg.png", display.contentCenterX + 512, display.contentCenterY * 0.6)
   --          newBuilding.xScale = 4;
   --          newBuilding.yScale = 4;
   --          table.insert(buildings_1, newBuilding);
   --       end
   --    end
   --    for _, building in ipairs(buildings_2) do
   --       building.x = building.x - building2Speed;
   --    end
   --    for _, ground in ipairs(grounds) do
   --       ground.x = ground.x - groundSpeed;
   --    end
   -- end

   -- timer.performWithDelay(16.777, moveBackground, 0)

   buttonBack:addEventListener("tap", back);


   function userTap(event)
      print("userTap")
      --left tap
      if(event.x < display.contentCenterX) then
         runningMan:setSequence("crouch");
      
      -- right tap
      else
         runningMan:setSequence("running");
      end

      runningMan:play()
   end
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      params = event.params
      speed = 20;
      runningMan:setSequence("idle");
      runningMan:play();
      drone:setSequence("flying");
      drone:play();
      obstacle1:setSequence("trash");
      obstacle1:play();
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
      
      Runtime:addEventListener("tap", userTap)
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
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.

      -- Runtime:removeEventListener( "tap", userTap)
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
   local sceneGroup = self.view
   sceneGroup.remove(runningMan);
 
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