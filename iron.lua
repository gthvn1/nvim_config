return {
  {
    "Vigemus/iron.nvim",
    config = function()
      local iron = require("iron.core")

      iron.setup({
        config = {
          -- tell iron how to start utop for OCaml
          repl_definition = {
            ocaml = {
              command = { "utop" },
            },
          },
          --repl_open_cmd = "vsplit", -- open REPL in vertical split
          repl_open_cmd = require("iron.view").split.vertical.botright(0.4),
        },
        keymaps = {
          --send_motion = "<leader>sc", -- send selected code
          --visual_send = "<leader>sc", -- send in visual mode
          --send_line = "<leader>sl", -- send current line
          --send_file = "<leader>sf", -- send whole file
          --cr = "<leader>s<cr>", -- send and go to REPL
          --clear = "<leader>cl",
          --exit = "<leader>sq",
          --interrupt = "<leader>si",
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      })

      local function send_with_semicolon()
        local line = vim.fn.getline(".")
        vim.cmd("IronSend " .. line .. " ;;") -- Use the IronSend command
      end

      -- Function to send the entire file with ";;" appended
      --local function send_file_with_semicolon()
      --  local file_content = vim.fn.getline(1, "$") -- Get all lines in the file
      --  if type(file_content) == "table" and #file_content > 0 then
      --    local content_with_semicolon = table.concat(file_content, "\n") .. ";;"
      --    vim.cmd("IronSend " .. content_with_semicolon)
      --  else
      --    print("File is empty, nothing to send.")
      --  end
      --end

      local function send_file_with_use()
        local file = vim.fn.expand("%:p")
        vim.cmd("IronSend " .. '#use "' .. file .. '";;')
      end

      -- Send visual selection with ;; at the end
      local function send_visual_with_semicolon()
        -- marks '< and '>
        local start_pos = vim.fn.getpos("'<")
        local end_pos = vim.fn.getpos("'>")

        local start_line = start_pos[2]
        local start_col = start_pos[3]
        local end_line = end_pos[2]
        local end_col = end_pos[3]

        -- fetch lines in the visual range
        local lines = vim.fn.getline(start_line, end_line)
        if #lines == 0 then
          return
        end

        if type(lines) == "string" then
          lines = { lines }
        end

        -- trim first and last line to match columns
        if #lines == 1 then
          lines[1] = string.sub(lines[1], start_col, end_col)
        else
          lines[1] = string.sub(lines[1], start_col)
          lines[#lines] = string.sub(lines[#lines], 1, end_col)
        end

        local text = table.concat(lines, "\n") .. ";;"
        print("Sending block: " .. text)

        -- Send to Iron
        --iron.repl_for(vim.bo.filetype) -- ensure a repl exists for this ft
        iron.send(nil, { text })
      end

      vim.keymap.set("n", "<leader>sl", send_with_semicolon, { desc = "Send current line to utop" })
      vim.keymap.set("n", "<leader>sf", send_file_with_use, { desc = "Send entire file to utop" })
      vim.keymap.set("v", "<leader>sv", send_visual_with_semicolon, { desc = "Send visual block to utop" })

      -- optional: keymap to toggle REPL manually
      vim.keymap.set("n", "<leader>sr", "<cmd>IronRepl<cr>", { desc = "Start REPL" })
      vim.keymap.set("n", "<leader>sq", "<cmd>IronClose<cr>", { desc = "Close REPL" })
    end,
  },
}
