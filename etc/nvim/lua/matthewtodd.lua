local matthewtodd = {}

latest_command_type = ''
latest_command = nil

local function rerun_latest_codelens()
  local latest_handler = vim.lsp.commands[latest_command_type]

  if latest_handler then
    latest_handler(latest_command)
  else
    run_nearest_codelens()
  end
end

local function run_nearest_codelens()
  local current_line = vim.fn.line('.') - 1
  local nearest_codelens_line = current_line
  local height = math.huge

  for _, codelens in pairs(vim.lsp.codelens.get()) do
    local start_line = codelens.command.arguments[4].start_line
    local end_line = codelens.command.arguments[4].end_line

    if start_line <= current_line and current_line <= end_line then
      local my_height = end_line - start_line
      if my_height < height then
        nearest_codelens_line = start_line + 1
        height = my_height
      end
    end
  end

  -- I would like to just pass a line number to vim.api.codelens.run, but it
  -- doesn't work that way, and I don't want to recreate it, so let's just move
  -- the cursor up.
  vim.api.nvim_win_set_cursor(0, {nearest_codelens_line, 0})
  vim.lsp.codelens.run()
end

local function register_codelens_run(command_type, command)
  latest_command_type = command_type
  latest_command = command
end

matthewtodd.rerun_latest_codelens = rerun_latest_codelens
matthewtodd.run_nearest_codelens = run_nearest_codelens
matthewtodd.register_codelens_run = register_codelens_run

return matthewtodd
