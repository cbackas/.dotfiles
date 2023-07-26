-- add your own keymapping
lvim.leader = "space"
-- Normal Mode Keybindings
-- remap navigation
lvim.keys.normal_mode["l"] = "h"
lvim.keys.normal_mode[";"] = "l"
lvim.keys.normal_mode["h"] = ";"

-- cmd + s to save
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- cycle through buffers
lvim.keys.normal_mode["<Tab>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-Tab>"] = ":BufferLineCyclePrev<CR>"

-- toggle undotree
lvim.keys.normal_mode["<F5>"] = ":UndotreeToggle<CR>"

-- Visual Mode Keybindings
-- remap navigation
lvim.keys.visual_mode["l"] = "h"
lvim.keys.visual_mode[";"] = "l"
lvim.keys.visual_mode["h"] = ";"

-- -- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

lvim.lsp.buffer_mappings.normal_mode['H'] = { vim.lsp.buf.hover, "Show documentation" }
