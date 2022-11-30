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
function doesFileExist( fname, path )
 
    local results = false
 
    -- Path for the file
    local filePath = system.pathForFile( fname, path )
 
    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" )
 
        if not file then
            -- Error occurred; output the cause
            print( "File error: " .. errorString )
        else
            -- File exists!
            print( "File found: " .. fname )
            results = true
            -- Close the file handle
            file:close()
        end
    end
 
    return results
end

function copyFile( srcName, srcPath, dstName, dstPath, overwrite )
 
    local results = false
 
    local fileExists = doesFileExist( srcName, srcPath )
    if ( fileExists == false ) then
        return nil  -- nil = Source file not found
    end
 
    -- Check to see if destination file already exists
    if not ( overwrite ) then
         local destfileExists = doesFileExist( dstName, dstPath )
        if ( destfileExists == true ) then
            return 1  -- 1 = File already exists (don't overwrite)
        end
    end
 
    -- Copy the source file to the destination file
    local rFilePath = system.pathForFile( srcName, srcPath )
    local wFilePath = system.pathForFile( dstName, dstPath )
 
    local rfh = io.open( rFilePath, "rb" )
    local wfh, errorString = io.open( wFilePath, "wb" )
 
    if not ( wfh ) then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Read the file and write to the destination directory
        local data = rfh:read( "*a" )
        if not ( data ) then
            print( "Read error!" )
            return false
        else
            if not ( wfh:write( data ) ) then
                print( "Write error!" )
                return false
            end
        end
    end
 
    results = 2  -- 2 = File copied successfully!
 
    -- Close file handles
    rfh:close()
    wfh:close()
 
    return results
end



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
      print("Back button pressed - going to scene 1")
      composer.gotoScene("scene1", options);
   end

   buttonBack:addEventListener("tap", back);

   -- Create Leaderboard File
   copyFile("leaderboard.csv", nil, "leaderboard.csv", system.DocumentsDirectory, false);
   csvFilePath = system.pathForFile("leaderboard.csv", system.DocumentsDirectory);
   csvFile = csv.open(csvFilePath, {separator = ",", header = true});
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase

   -- local csvData = {};
   --    local function displayScore()
   --       local yOffset = 0;
   --       -- if csvData ~= nil then
   --       --    for i in csvData do
   --       --       local currentRecord = "test val"--record.name .. "   =   " .. record.score;
   --       --       local scoreEntry = display.newText(currentRecord, display.contentCenterX, display.contentCenterY + yOffset, system.nativeFont, 24)
   --       --       sceneGroup:insert(scoreEntry);
   --       --       yOffset = yOffset + 30;
   --       --    end
   --       -- end
   --    end
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      params = event.params;

      -- for record in csvFile:lines( ) do
      --    print("Record = ");
      --    print(record.name .. record.score);
      --    -- table.insert(csvData, currentRecord);
      -- end

      -- Print Stats to Screen
      -- if (params.eogFlag == false) then
      --    print("Attempt to call displayScore() function")
      --    displayScore()
      -- end



   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
      params = event.params;
      -- print("Scene 3 On Screen: eogFlag = ")
      -- print(params.eogFlag)
      -- print("Score = " .. params.finalScore)

      local yOffset = 0;
      local maxScore = 0;
      local usernameField;
      for record in csvFile:lines( ) do
         print(record.name)
         print(record.score)
         local currentScore = tonumber(record.score);
         if currentScore > maxScore then
            maxScore = currentScore;
         end
      
         local currentRecord = record.name .. "   =   " .. record.score;
         local scoreEntry = display.newText(currentRecord, display.contentCenterX, display.contentCenterY + yOffset, system.nativeFont, 24)
         sceneGroup:insert(scoreEntry);
         yOffset = yOffset + 30;
      end

      local file = io.open(csvFilePath, "a");
      local textBoxGroup = display.newGroup( );

      local function onUsername( event )
         if ( "began" == event.phase ) then
              -- This is the "keyboard appearing" event.
              -- In some cases you may want to adjust the interface while the keyboard is open.
              -- native.setKeyboardFocus(usernameField);

              -- print("Textbox Ready");
         elseif ( "submitted" == event.phase ) then
            -- params.eogFlag = false;
            
            file:write("\n" .. usernameField.text .. ", " .. params.finalScore)
            print("Text Submitted");
            print(usernameField.text);
            native.setKeyboardFocus(nil)
            sceneGroup:remove( usernameField )
            -- usernameField:removeSelf( );

            file:close();
            params.eogFlag = false;
            composer.gotoScene("scene3", {
               effect = "slideUp",
               time = 100,
               params = {eogFlag = false, finalScore = 0}
            });
          end

         if params.eogFlag == false then 
            usernameField:removeSelf( );
         end

         --  composer.gotoScene("scene3", {
         --    effect = "slideUp",
         --    time = 100,
         --    params = {eogFlag = false, finalScore = 0}
         -- });
      end

      if params.eogFlag == true then
         print("EOG Flag True")
         local finalScore = tonumber( params.finalScore )
         if finalScore > maxScore then
            print("New High Score")
            usernameField = native.newTextField( display.contentCenterX, display.contentCenterY -100, 220, 36 )
            native.setKeyboardFocus(usernameField);
            usernameField.font = native.newFont( native.systemFontBold, 24 )
            usernameField.text = ""
            usernameField:setTextColor( 0.4, 0.4, 0.8 )
            usernameField:addEventListener( "userInput", onUsername )
            -- textBoxGroup:insert(usernameField);
            sceneGroup:insert( usernameField );
         end
      end


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
   csvFile:close("leaderboard.csv");
 
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