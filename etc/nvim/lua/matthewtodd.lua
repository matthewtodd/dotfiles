local matthewtodd = {}

matthewtodd.latest_command_type = ''
matthewtodd.latest_command = nil

local function on_lsp_attach(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)

  if (client.server_capabilities.codeLensProvider) then
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      buffer = bufnr,
      callback = function(ev)
        vim.lsp.codelens.refresh()
      end
    })
  end

  if client:supports_method('textDocument/completion') then
    vim.lsp.completion.enable(true, client.id, ev.buf)
  end

  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = bufnr,
    callback = function(ev)
      vim.lsp.buf.format {
        async = false,
        filter = function(client)
          return client.name ~= 'sorbet'
        end
      }
    end
  })
end

local function rerun_latest_codelens()
  local latest_handler = vim.lsp.commands[matthewtodd.latest_command_type]

  if latest_handler then
    latest_handler(matthewtodd.latest_command, {})
  else
    vim.lsp.codelens.run()
  end
end

local function register_codelens_run(command_type, command)
  matthewtodd.latest_command_type = command_type
  matthewtodd.latest_command = command
end

matthewtodd.on_lsp_attach = on_lsp_attach
matthewtodd.rerun_latest_codelens = rerun_latest_codelens
matthewtodd.register_codelens_run = register_codelens_run

return matthewtodd
