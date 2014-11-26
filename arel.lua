function read_query( packet )
  if packet:byte() == proxy.COM_QUERY then
    -- print("Query: " .. packet:sub(2))

    -- reads the query
    local query = string.sub(packet, 2)

    -- check the pattern
    if (string.find(query, '#arel') ~= nil) then
      -- arel-it
      local command = "ruby arel-proxy.rb \"" .. query .. "\" 2>&1"
      print("Arel: " .. command .. "\n")
      local handle = io.popen(command)
      local result = handle:read("*a")
      handle:close()
      print("Rewritten SQL: " .. result)

      if (string.find(result, 'Ruby Error:') ~= nil) then
        -- send the new error message
        proxy.response.type = proxy.MYSQLD_PACKET_ERR
        proxy.response.errmsg = result
        return proxy.PROXY_SEND_RESULT
      else
        -- replace and execute the query
        proxy.queries:append(1, string.char(proxy.COM_QUERY) .. result)
        return proxy.PROXY_SEND_QUERY
      end
    end
  end
end