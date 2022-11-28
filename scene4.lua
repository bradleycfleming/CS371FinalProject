-- Jacob Dumbacher & Bradley Fleming
-- CS 371 Project Phase 2
-- 28 November 2022
-- Scene 4 - Credits

local composer = require( "composer" );
local scene = composer.newScene();
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view

   -- background = display.newRect(sceneGroup, display.contentCenterX - 50 , display.contentCenterY, display.contentWidth + 400, display.contentHeight) 
   -- background:setFillColor(1, 1, 1, 1);
   -- -- sceneGroup:insert(background);

   background = display.newRect(display.contentCenterX - 50 , display.contentCenterY, display.contentWidth + 400, display.contentHeight) 
   background:setFillColor(0.65, 0.5, 1, 1);
   sceneGroup:insert(background);

   -- local buttonBack = display.newRect(display.contentCenterX,50,100,50);
   -- sceneGroup:insert(buttonBack);
   
   -- local options = {
   --    effect = "slideDown",
   --    time = 100
   -- }

   -- local function back (event)
   --    print("Back button pressed - going to scene 1")
   --    composer.gotoScene("scene1", options);
   -- end

   -- buttonBack:addEventListener("tap", back);


   local function handleButton1Event (event)
      composer.gotoScene("scene1", {
         effect = "slideDown",
         time = 100,
         params = {}
      });
   end

   local button1 = widget.newButton( {
      label = "button1",
      onEvent = handleButton1Event,
      emboss = false,
      shape = "roundedRect",
      width = 500,
      height = 80,
      cornerRadius = 2,
      fillColor = { default = {0, 0, 1, 0.4}, over={}},
      strokeColor = { default = {0, 0, 0, 0}, over={}},
      strokeWidth = 0,
      fontSize = 36,
      labelColor = {default = {1, 1, 1, 1}, over={}}

   });

   button1.x = display.contentCenterX;
   button1.y = display.contentCenterY + 200;
   button1:setLabel( "Return to Main Menu" );
   sceneGroup:insert(button1);

   local function handleButton2Event (event)
      composer.gotoScene("scene3", {
         effect = "slideUp",
         time = 100,
         params = {
      }
      });
   end

   local titleText = display.newText("City Runner", display.contentCenterX, display.contentCenterY - 200, native.systemFontBold,36);
   sceneGroup:insert(titleText);

   local creatorText = display.newText("Created by Jacob Dumbacher and Bradley Fleming for CS 371", display.contentCenterX, display.contentCenterY - 30, native.systemFont,24);
   sceneGroup:insert(creatorText);

   local creditsText = display.newText("Open Source Credits Available Here: https://raw.githubusercontent.com/bradleycfleming/CS371FinalProject/main/OpenSourceAcknowledgements.md", display.contentCenterX, display.contentCenterY + 20, native.systemFont, 16)
   sceneGroup:insert(creditsText);

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      
      


      print("Show Scene 4");
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
      -- sceneGroup:removeSelf( );
      -- sceneGroup = nil;

      print("Hide Scene 4");
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