
return function(G)
	return function (orig, mtbase)
		--[[
		mtbase.__ipairs = function(_self, ...)
				local mt = G.getmetatable(orig)
				if mt and G.type(mt.__ipairs)=="function" then
					return mt.__ipairs(orig, ...)
				end
				--return ipairs(orig, ...)
				return nil
		end
		]]--

		mtbase.__pairs = function(_t)
			G.assert(_t ~= orig) -- or return nil ?
		--	if orig.next==nil then
		--		--return nil
		--		error("missing orig:next() implementation")
		--	end
		--	local _next = _t["next"] -- TODO: use the private table to access _G.next
		--	return _next, _t, nil
		--	-- here return a special iterator
		--	--	lookup key into the orig table
		--	-- for k in pairs(orig) do
		--	--	ignore deleted key, if value exist return the __index(_self, k) value ?
			local _next = function(t0, k0)
				local pubenv = _t -- orig._pubenv ? -- FIXME: we supposed _t is the proxy table (but it is probably unsafe ?)
				if t0==pubenv then
					local k1,v1 = k0,nil
 					while v1 == nil do
					k1 = G.next(orig, k1)
						if k1 == nil then return nil,nil end
						v1 = _t[k1]		-- will use __index and return the proxy ?
					end
	 				return k1,v1
				else
					return G.next(t0, k0)
				end
			end
			return _next, _t, nil
		end
		-- mtbase.__metatable ?

		return G.setmetatable(mtbase, {
			__index=function(_t, k) -- #### any other meta field will be supported ####
				if type(k)=="string" then
					local mt = G.getmetatable(orig)
					if mt and G.type(mt["__"..k])=="function" then -- FIXME: only function ? if table return the mt[__*][k] ?
						return mt["__"..k](orig, k)
					end
				end
				return nil
			end,
		})
	end
end
