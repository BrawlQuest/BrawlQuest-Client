-- This is the code that's going to run on the our thread. It should be moved
-- to its own dedicated Lua file, but for simplicity's sake we'll create it
-- here.
local threadCode = [[
-- Receive values sent via thread:start
local min, max = ...
 
for i = min, max do
    -- The Channel is used to handle communication between our main thread and
    -- this thread. On each iteration of the loop will push a message to it which
    -- we can then pop / receive in the main thread.
    love.thread.getChannel( 'info' ):push( i )
end
]]
 
local thread -- Our thread object.
local timer  -- A timer used to animate our circle.
 
function love.load()
    thread = love.thread.newThread( threadCode )
    thread:start( 99, 1000 )
end
 
function love.update( dt )
    timer = timer and timer + dt or 0
 
    -- Make sure no errors occured.
    local error = thread:getError()
    assert( not error, error )
end
 
function love.draw()
    -- Get the info channel and pop the next message from it.
    local info = love.thread.getChannel( 'info' ):pop()
    if info then
        love.graphics.print( info, 10, 10 )
    end
 
    -- We smoothly animate a circle to show that the thread isn't blocking our main thread.
    love.graphics.circle( 'line', 100 + math.sin( timer ) * 20, 100 + math.cos( timer ) * 20, 20 )
end