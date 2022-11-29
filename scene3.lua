-- Jacob Dumbacher & Bradley Fleming
-- CS 371 Project Phase 2
-- 28 November 2022
-- Scene 3 - High Scores

local csv = require("csv")
local composer = require( "composer" )
local scene = composer.newScene()
local csvFile = "";
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view

   background = display.newRect(display.contentCenterX - 50 , display.contentCenterY, display.contentWidth + 400, display.contentHeight) 
   background:setFillColor(0.65, 0.5, 1, 1);
   sceneGroup:insert(background);

   local buttonBack = display.newRect(display.contentCenterX,50,100,50);
   sceneGroup:insert(buttonBack);
   
   local options = {
      effect = "slideDown",
      time = 100
   }

   local function back (event)
      print("Back button pressed - going to scene 1");
      composer.gotoScene("scene1", options);
   end

   buttonBack:addEventListener("tap", back);

   -- Create Leaderboard File
   
   csvFile = csv.open(system.pathForFile("leaderboard.csv"), {separator = ",", header = false});
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).

   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
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
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
   local sceneGroup = self.view
 
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