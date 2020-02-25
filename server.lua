logic = require('logic')

function listen()
    local socket = require("socket")
    -- create a TCP socket and bind it to the local host, at any port
    local server = assert(socket.bind("*", 4545))
    -- find out which port the OS chose for us
    local ip, port = server:getsockname()
    -- print a message informing what's up
    print("Please telnet to localhost on port " .. port)
    print("After connecting, you have 10s to enter a line to be echoed")
    -- loop forever waiting for clients
    while 1 do
        -- wait for a connection from any client
        local client = server:accept()
        -- make sure we don't block waiting for this client's line
        client:settimeout(0)
        -- receive the line
        while 1 do
            local line, err = client:receive()
            -- if there was no error, send it back to the client
            if not err then client:send(line .. "\n") end
        end
        -- done with client, close the object
        --client:close()
    end
end
listen()
