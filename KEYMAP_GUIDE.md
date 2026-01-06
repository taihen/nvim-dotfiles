# Neovim Keymap Style Guide

Keymap organization and conventions for Taihen Neovim configuration.

## Leader Key

- **Leader**: `<Space>`
- **LocalLeader**: `<Space>`

## Leader Group Conventions

All leader-based keymaps follow consistent grouping patterns:

### Primary Groups

| Prefix       | Category                   | Description                                        |
| ------------ | -------------------------- | -------------------------------------------------- |
| `<leader>a*` | **AI/Sidekick**            | AI-powered actions (Sidekick CLI, agents, prompts) |
| `<leader>b*` | **Buffer/Background**      | Buffer operations and theme switching              |
| `<leader>c*` | **Code**                   | Code actions (LSP)                                 |
| `<leader>d*` | **Document/Diagnostics**   | Document symbols, diagnostics                      |
| `<leader>e`  | **Error**                  | Show diagnostic error float                        |
| `<leader>f*` | **Format**                 | Code formatting operations                         |
| `<leader>g*` | **Git**                    | LazyGit UI                                         |
| `<leader>h*` | **Hunk**                   | Git hunk operations (gitsigns)                     |
| `<leader>n*` | **Noice**                  | Noice UI (message history, errors)                 |
| `<leader>q`  | **Quickfix**               | Open quickfix list                                 |
| `<leader>r*` | **Rename**                 | LSP rename operations                              |
| `<leader>s*` | **Search**                 | Telescope fuzzy finding                            |
| `<leader>t*` | **Toggle**                 | Toggle features (blame, deleted, etc.)             |
| `<leader>u*` | **Utility**                | Utility operations                                 |
| `<leader>v*` | **VSCode Diff**            | Diff viewer operations                             |
| `<leader>w*` | **Window/Workspace/Write** | Window, workspace, write operations                |
| `<leader>x*` | **Trouble**                | Trouble diagnostics                                |

### Detailed Leader Mappings

#### AI/Sidekick (`<leader>a*`)

- `<leader>aa` - Toggle Sidekick CLI
- `<leader>as` - Select CLI agent
- `<leader>ad` - Detach CLI session
- `<leader>at` - Send "this" to Sidekick
- `<leader>af` - Send file to Sidekick
- `<leader>av` - Send visual selection
- `<leader>ap` - Select prompt
- `<leader>ac` - Toggle Claude

#### Buffer (`<leader>b*`)

- `<leader>b` - Toggle background (light/dark theme)
- `<leader>bd` - Delete buffer

#### Code Actions (`<leader>c*`)

- `<leader>ca` - Code action (LSP)

#### Document/Diagnostics (`<leader>d*`)

- `<leader>ds` - Document symbols (LSP)

#### Git Hunks (`<leader>h*`)

- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hS` - Stage buffer
- `<leader>hu` - Undo stage hunk
- `<leader>hR` - Reset buffer
- `<leader>hp` - Preview hunk
- `<leader>hb` - Blame line
- `<leader>hd` - Diff this
- `<leader>hD` - Diff ~

#### Noice (`<leader>n*`)

- `<leader>nh` - Noice message history
- `<leader>nl` - Noice last message
- `<leader>ne` - Noice errors

#### Search/Telescope (`<leader>s*`)

- `<leader>sh` - Search help
- `<leader>sk` - Search keymaps
- `<leader>sf` - Search files
- `<leader>ss` - Search select (builtin)
- `<leader>sw` - Search current word
- `<leader>sg` - Search by grep
- `<leader>sd` - Search diagnostics
- `<leader>sr` - Search resume
- `<leader>s.` - Search recent files
- `<leader>sp` - Search snippets
- `<leader>sc` - Search clipboard
- `<leader>sn` - Search Neovim config files
- `<leader>s/` - Search in open files

#### Toggles (`<leader>t*`)

- `<leader>tb` - Toggle blame line
- `<leader>td` - Toggle deleted

#### VSCode Diff (`<leader>v*`)

- `<leader>vd` - VSCode diff explorer
- `<leader>vf` - Diff file vs HEAD
- `<leader>vp` - Diff file vs previous commit
- `<leader>vb` - Diff file vs branch
- `<leader>vr` - Diff file vs revision
- `<leader>vc` - Compare two files

#### Window/Workspace/Write (`<leader>w*`)

- `<leader>wf` - Write file
- `<leader>ww` - Toggle line wrapping
- `<leader>ws` - Workspace symbols (LSP)

#### Trouble (`<leader>x*`)

- `<leader>xx` - Toggle diagnostics
- `<leader>xb` - Toggle buffer diagnostics
- `<leader>xw` - Toggle workspace diagnostics
- `<leader>xs` - Toggle symbols
- `<leader>xl` - Toggle LSP references
- `<leader>xc` - Toggle location list
- `<leader>xq` - Toggle quickfix list
- `<leader>xt` - Toggle todo list

#### Other Leader Mappings

- `<leader>/` - Fuzzy search current buffer
- `<leader><leader>` - Find existing buffers
- `<leader>,` - Previous buffer
- `<leader>.` - Next buffer
- `<leader>+` - Vertical resize +5
- `<leader>-` - Vertical resize -5
- `<leader><esc>` - Clear search highlighting
- `<leader>e` - Show diagnostic error float
- `<leader>q` - Open diagnostic quickfix list
- `<leader>fm` - Format buffer
- `<leader>gg` - Open LazyGit
- `<leader>?` - Show buffer keymaps (which-key)

## Bracket Navigation

Consistent `[` and `]` prefix patterns for navigation:

| Mapping     | Action                        | Source                         |
| ----------- | ----------------------------- | ------------------------------ |
| `[b` / `]b` | Buffers                       | mini.bracketed                 |
| `[c` / `]c` | Changes/Comments/Hunks        | gitsigns, mini.bracketed       |
| `[d` / `]d` | Diagnostics                   | vim.diagnostic, mini.bracketed |
| `[f` / `]f` | Files                         | mini.bracketed                 |
| `[m` / `]m` | Functions                     | treesitter textobjects         |
| `[M` / `]M` | Function ends                 | treesitter textobjects         |
| `[[` / `]]` | Classes                       | treesitter textobjects         |
| `[]` / `][` | Class ends                    | treesitter textobjects         |
| `[q` / `]q` | Quickfix                      | mini.bracketed                 |
| `[t` / `]t` | TODO comments (ERROR/WARNING) | todo-comments                  |
| `[x` / `]x` | Conflicts                     | vscode-diff                    |
| `[i` / `]i` | Indent scope                  | mini.indentscope               |

## LSP Keymaps (Buffer-local)

Active only when LSP is attached to a buffer:

| Mapping      | Action                          |
| ------------ | ------------------------------- |
| `gd`         | Goto definition (Telescope)     |
| `gr`         | Goto references (Telescope)     |
| `gI`         | Goto implementation (Telescope) |
| `gD`         | Goto declaration                |
| `K`          | Hover documentation             |
| `<leader>D`  | Type definition (Telescope)     |
| `<leader>rn` | Rename symbol                   |
| `<leader>ca` | Code action                     |

## Completion Keymaps (Insert mode)

Active in insert mode for nvim-cmp:

| Mapping     | Action                                         |
| ----------- | ---------------------------------------------- |
| `<C-Space>` | Trigger completion                             |
| `<CR>`      | Accept completion                              |
| `<Tab>`     | Smart Tab: Sidekick NES → completion → snippet |
| `<S-Tab>`   | Previous completion item                       |
| `<C-l>`     | Snippet jump forward                           |
| `<C-h>`     | Snippet jump backward                          |
| `<C-f>`     | Scroll docs forward                            |
| `<C-b>`     | Scroll docs backward                           |

## Text Objects

### Treesitter Text Objects

- `af` / `if` - Function outer/inner
- `ac` / `ic` - Class outer/inner
- `aa` / `ia` - Parameter outer/inner
- `ab` / `ib` - Block outer/inner

### Git Text Objects

- `ih` - Inside hunk (operator/visual mode)

### Mini.ai Enhanced Text Objects

- Various enhanced text objects via mini.ai

## Window Navigation

| Mapping | Action               |
| ------- | -------------------- |
| `<C-h>` | Move to left window  |
| `<C-l>` | Move to right window |
| `<C-j>` | Move to lower window |
| `<C-k>` | Move to upper window |

## Line Movement (Normal/Visual)

| Mapping | Action                    | Mode          |
| ------- | ------------------------- | ------------- |
| `J`     | Move line/selection down  | Normal/Visual |
| `K`     | Move line/selection up    | Normal/Visual |
| `<`     | Indent left (repeatable)  | Visual        |
| `>`     | Indent right (repeatable) | Visual        |

## Scrolling (Centered)

| Mapping | Action                             |
| ------- | ---------------------------------- |
| `<C-d>` | Scroll down (centered)             |
| `<C-u>` | Scroll up (centered)               |
| `n`     | Next search (centered)             |
| `N`     | Previous search (centered)         |
| `*`     | Search word (centered)             |
| `#`     | Search backward (centered)         |
| `g*`    | Search partial word (centered)     |
| `g#`    | Search backward partial (centered) |

## Code Manipulation

### Comments

- `gc` / `gcc` - Comment (mini.comment)

### Surroundings (mini.surround)

- `sa` - Add surrounding
- `sd` - Delete surrounding
- `sr` - Replace surrounding

### Split/Join (mini.splitjoin)

- `gS` - Split/join structures

## Copilot (AI Suggestions)

| Mapping | Action              | Mode   |
| ------- | ------------------- | ------ |
| `<M-l>` | Accept suggestion   | Insert |
| `<M-]>` | Next suggestion     | Insert |
| `<M-[>` | Previous suggestion | Insert |
| `<C-]>` | Dismiss suggestion  | Insert |

## Description Format

All keymaps should follow these conventions:

1. **Use title case with bracketed letters**: `[S]earch [F]iles`
2. **Bracket first letter of important words**: Helps with discoverability
3. **Keep concise**: Under 50 characters
4. **Add context prefix for buffer-local**: `LSP:`, `Git:`, etc.

### Examples

```lua
-- Good
{ "<leader>sf", desc = "[S]earch [F]iles" }
{ "gd", desc = "LSP: [G]oto [D]efinition" }
{ "<leader>hs", desc = "[H]unk [S]tage" }

-- Avoid
{ "<leader>sf", desc = "search files" }  -- Not title case
{ "gd", desc = "Goto definition" }       -- Missing context prefix
{ "<leader>hs", desc = "Stage the current hunk" }  -- Too verbose
```

## Scope Guidelines

### Global Keymaps

- Define in `lua/keymap.lua` for general editor operations
- Use plugin `keys` field for plugin-specific operations

### Buffer-local Keymaps

- LSP: Use `LspAttach` autocmd callback
- Git: Use `on_attach` in gitsigns configuration
- Filetype-specific: Use `ft` with `keys` in plugin spec

### Example: Buffer-local LSP Keymap

```lua
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, {
                buffer = event.buf,
                desc = "LSP: " .. desc,
            })
        end

        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    end,
})
```

## Conflict Resolution

### Known Non-Conflicts

- `<c-f>` / `<c-b>`: Used by both cmp (completion docs) and noice (LSP hover)
  - **No conflict**: noice uses `expr=true` and falls through when not in LSP hover context

### Resolved Conflicts

- `<leader>/`: Now exclusively for Telescope fuzzy buffer search (buffer delete moved to `<leader>bd`)
- `<leader>sn`: Telescope search Neovim files (noice history moved to `<leader>nh`)
- `]t`: Only jumps to ERROR/WARNING TODOs (generic next todo removed)

## Discovering Keymaps

Use these commands to explore available keymaps:

```vim
:Telescope keymaps          " Search all keymaps
:WhichKey                   " Interactive keymap guide
:WhichKey <leader>          " Show all leader mappings
:WhichKey <leader>s         " Show all search mappings
:checkhealth which-key      " Verify which-key setup
```

## References

- [Neovim Key Notation](https://neovim.io/doc/user/intro.html#key-notation)
- [Lazy.nvim Keys Spec](https://lazy.folke.io/spec/lazy_loading#-lazy-key-mappings)
- [Telescope Builtin Pickers](https://github.com/nvim-telescope/telescope.nvim#pickers)
- [LSP Keymaps](https://github.com/neovim/nvim-lspconfig#keybindings-and-completion)
