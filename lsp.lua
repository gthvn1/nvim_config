local ocamllsp_cmd = function()
  local prefix = os.getenv("OPAM_SWITCH_PREFIX")
  if prefix then
    return { prefix .. "/bin/ocamllsp" }
  else
    return { "ocamllsp" }
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clojure_lsp = {},
        rust_analyzer = {},
        ocamllsp = {
          cmd = ocamllsp_cmd(),
        },
      },
    },
  },
}
