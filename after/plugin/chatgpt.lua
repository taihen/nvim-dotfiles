require("chatgpt").setup({
  openai_params = {
    -- model = "gpt-4-turbo-preview",
    frequency_penalty = 0,
    presence_penalty = 0,
    -- max_tokens = 600,
    temperature = 0,
    top_p = 1,
    n = 1,
  },
  openai_edit_params = {
    -- model = "gpt-4-turbo-preview",
    frequency_penalty = 0,
    presence_penalty = 0,
    temperature = 0,
    top_p = 1,
    n = 1,
  },
})

local keymap = vim.keymap.set

keymap({ "n", "v" }, "<Leader>ac", "<cmd>ChatGPT<CR>", { desc = "ChatGPT" })
keymap(
  { "n", "v" },
  "<Leader>ae",
  "<cmd>ChatGPTEditWithInstruction<CR>",
  { desc = "Edit with instruction" }
)
keymap(
  { "n", "v" },
  "<Leader>ag",
  "<cmd>ChatGPTRun grammar_correction<CR>",
  { desc = "Grammar Correction" }
)
keymap(
  { "n", "v" },
  "<Leader>at",
  "<cmd>ChatGPTRun translate<CR>",
  { desc = "Translate" }
)
keymap(
  { "n", "v" },
  "<Leader>ak",
  "<cmd>ChatGPTRun keywords<CR>",
  { desc = "Keywords" }
)
keymap(
  { "n", "v" },
  "<Leader>ad",
  "<cmd>ChatGPTRun docstring<CR>",
  { desc = "Docstring" }
)
keymap(
  { "n", "v" },
  "<Leader>aa",
  "<cmd>ChatGPTRun add_tests<CR>",
  { desc = "Add Tests" }
)
keymap(
  { "n", "v" },
  "<Leader>ao",
  "<cmd>ChatGPTRun optimize_code<CR>",
  { desc = "Optimize Code" }
)
keymap(
  { "n", "v" },
  "<Leader>as",
  "<cmd>ChatGPTRun summarize<CR>",
  { desc = "Summarize" }
)
keymap(
  { "n", "v" },
  "<Leader>af",
  "<cmd>ChatGPTRun fix_bugs<CR>",
  { desc = "Fix Bugs" }
)
keymap(
  { "n", "v" },
  "<Leader>ax",
  "<cmd>ChatGPTRun explain_code<CR>",
  { desc = "Explain Code" }
)
keymap(
  { "n", "v" },
  "<Leader>ar",
  "<cmd>ChatGPTRun roxygen_edit<CR>",
  { desc = "Roxygen Edit" }
)
keymap(
  { "n", "v" },
  "<Leader>al",
  "<cmd>ChatGPTRun code_readability_analysis<CR>",
  { desc = "Code Readability Analysis" }
)
