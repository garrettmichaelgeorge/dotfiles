local lsp_util = vim.lsp.util
local validate = vim.validate
local M = {}

local function has_value (table, check_value) 
  for _index, value in ipairs(table) do
    if value == check_value then
      return true
    end
  end

  return false
end

local function is_empty(table)
  local next = next
  return next(capabilities) == nil
end

local function current_buf_has_code_action_capabilities()
  capabilities = {}

  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.for_each_buffer_client(bufnr, function (client, _client_id, _bufnr)
    -- print(vim.inspect(client.server_capabilities))

    if not client.server_capabilities.code_action == false then
      table.insert(capabilities, client.server_capabilities)
    end
  end)

  return not is_empty(capabilties)
end

-- Show a sign when a code action is available
M.code_action_listener = function ()
  if not current_buf_has_code_action_capabilities() then
    return
  end

  local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
  local params = lsp_util.make_range_params()
  params.context = context

  vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(_err, result, _ctx, _config)
    -- do something with result - e.g. check if empty and show some indication such as a sign
    if type(result) == "table" then
      print("Code action available!")
    end

    return result
  end)
end

return M
