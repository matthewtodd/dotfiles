local T = MiniTest.new_set()

T['works'] = function()
  MiniTest.expect.equality(1, 1)
end

return T

-- vim:et:sw=2:ts=2
