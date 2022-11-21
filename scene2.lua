-- Jacob Dumbacher & Bradley Fleming
-- CS 371 Project Phase 2
-- 28 November 2022

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

local runningMan_sheet = graphics.newImageSheet("Resources\\Sprite\\spritesheet.png", runningMan_opt)

local drone_sheet = graphics.newImageSheet("Resources\\Obstacles\\Drone.png", drone_opt)

local obstacle_sheet = graphics.newImageSheet("Resources\\Obstacles\\Obstacles.png", obstacle_opt)

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
 
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.

   runningMan = display.newSprite(runningMan_sheet, runningMan_sequenceData)
   runningMan.xScale = 0.4;
   runningMan.yScale = 0.4;
   runningMan.x = display.contentCenterX / 4;
   runningMan.y = display.contentCenterY * 1.25;
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
   obstacle1.x = display.contentCenterX * 0.5;
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