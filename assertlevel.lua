local function assertlevel(testvalue, errormsg, errorlvl)
        if not testvalue then
                error(errormsg, (errorlvl or 1)+1)
        end
        return testvalue
end
return assertlevel
