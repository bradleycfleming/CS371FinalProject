-- Jacob Dumbacher & Bradley Fleming
-- CS 371 Project Phase 2
-- 28 November 2022
-- Scene 1 - Welcome Page

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" );

local backgroundGroup = display.newGroup();
local foregroundGroup = display.newGroup();


-- Open Background Images for All Scenes ???
local buildings_1 = {};
local buildings_2 = {};
local grounds = {};

local runningMan_opt = {
   frames = {
       {x = 6400, y = 80, width = 800, height = 480}, -- frame idle 9
       {x = 7200, y = 80, width = 800, height = 480}, -- frame idle 10
   }
}

local runningMan_sheet = graphics.newImageSheet("Resources/Sprite/spritesheet.png", runningMan_opt)

local runningMan_sequenceData = {
   {name = "idle", frames = {1, 2}, time = 700, loopCount = 0}
}

-- Declare all objects
local background;
local building1;
local building1_2;
local building1_3;
local building2;
local building2_2;
local building2_3;
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
local runningMan;

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
 
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

   

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup1", add touch listeners, etc.
   local function handleButton1Event (event)
      composer.gotoScene("scene2", {
         effect = "slideUp",
         time = 100,
         params = {}
      });
   end

   local button1 = widget.newButton( {
      label = "button1",
      onEvent = handleButton1Event,
      emboss = false,
      shape = "roundedRect",
      width = 300,
      height = 80,
      cornerRadius = 2,
      fillColor = { default = {0, 0, 1, 0.4}, over={}},
      strokeColor = { default = {0, 0, 0, 0}, over={}},
      strokeWidth = 0,
      fontSize = 36,
      labelColor = {default = {1, 1, 1, 1}, over={}}

   });

   button1.x = display.contentCenterX + 200;
   button1.y = display.contentCenterY - 200;
   button1:setLabel( "Start Game" );
   sceneGroup:insert(button1);

   local function handleButton2Event (event)
      composer.gotoScene("scene3", {
         effect = "slideUp",
         time = 100,
         params = {
      }
      });
   end

   local button2 = widget.newButton( {
      label = "button2",
      onEvent = handleButton2Event,
      emboss = false,
      shape = "roundedRect",
      width = 300,
      height = 80,
      cornerRadius = 2,
      fillColor = { default = {0, 0, 1, 0.4}, over={}},
      strokeColor = { default = {0, 0, 0, 0}, over={}},
      strokeWidth = 0,
      fontSize = 36,
      labelColor = {default = {1, 1, 1, 1}, over={}}

   });

   button2.x = display.contentCenterX + 200;
   button2.y = display.contentCenterY - 100;
   button2:setLabel( "High Scores" );
   sceneGroup:insert(button2);

   local function handleButton3Event (event)
      local eogFlag = true;
      local score = nil;
      composer.gotoScene("scene4", {
         effect = "slideUp",
         time = 100,
         params = {eogFlag, score}
      });
   end

   local button3 = widget.newButton( {
      label = "button3",
      onEvent = handleButton3Event,
      emboss = false,
      shape = "roundedRect",
      width = 300,
      height = 80,
      cornerRadius = 2,
      fillColor = { default = {0, 0, 1, 0.4}, over={} },
      strokeColor = { default = {0, 0, 0, 0}, over={} },
      strokeWidth = 0,
      fontSize = 36,
      labelColor = { default = {1, 1, 1, 1}, over={} }
   });

   button3.x = display.contentCenterX + 200;
   button3.y = display.contentCenterY - 0;
   button3:setLabel( "Credits" );
   sceneGroup:insert(button3);

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

      -- composer.removeScene("scene2")

      -- local function handleButton1Event (event)
      --    composer.gotoScene("scene2", {
      --       effect = "slideUp",
      --       time = 100,
      --       params = {}
      --    });
      -- end

      -- local button1 = widget.newButton( {
      --    label = "button1",
      --    onEvent = handleButton1Event,
      --    emboss = false,
      --    shape = "roundedRect",
      --    width = 300,
      --    height = 80,
      --    cornerRadius = 2,
      --    fillColor = { default = {0, 0, 1, 0.4}, over={}},
      --    strokeColor = { default = {0, 0, 0, 0}, over={}},
      --    strokeWidth = 0,
      --    fontSize = 36,
      --    labelColor = {default = {1, 1, 1, 1}, over={}}

      -- });

      -- button1.x = display.contentCenterX + 200;
      -- button1.y = display.contentCenterY - 200;
      -- button1:setLabel( "Start Game" );
      -- sceneGroup:insert(button1);

   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
      -- composer.removeHidden(false);
      -- composer.removeScene("scene2")
      -- composer.loadScene("scene2");
      runningMan:play();
      local currentScene = composer.getScene( "scene1" )
      print("Current Scene = ");
      print(currentScene)


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
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
      
   end
end

-- "scene:destroy()"
function scene:destroy( event )
 
   local sceneGroup = self.view
 
   -- Called prior to the removal of scene's view ("sceneGroup1").
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