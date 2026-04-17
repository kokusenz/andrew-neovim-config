-- https://github.com/schemar/blueberry-peach/tree/main/ports/neovim
-- recommended install is to copy paste, which is what this is
-- however, there are modifications made
local color_overrides_dark = {
    mauve = "#A19DD4",
    pink = "#A19DD4",
    flamingo = "#C394C2",
    rosewater = "#C394C2",
    red = "#DF8BA0",
    maroon = "#DF8BA0",
    yellow = "#C7B96F",
    peach = "#C79A76",
    green = "#75B087",
    teal = "#5EB1AF",
    sky = "#5EB1AF",
    sapphire = "#5EB1AF",
    blue = "#7AA8CE",
    lavender = "#7AA8CE",
    text = "#A2A2A9",
    subtext1 = "#878794",
    subtext0 = "#878794",
    overlay2 = "#7D7D7D",
    overlay1 = "#808084",
    overlay0 = "#84848C",
    surface2 = "#7C7992",
    surface1 = "#37363E",
    surface0 = "#37363E",
    base = "#191724",
    mantle = "#0B0A0F",
    crust = "#0B0A0F",
}

local color_overrides_light = {
    mauve = "#6A67B4",
    pink = "#6A67B4",
    flamingo = "#A352A0",
    rosewater = "#A352A0",
    red = "#C34165",
    maroon = "#C34165",
    yellow = "#8A7400",
    peach = "#AC591C",
    green = "#288043",
    teal = "#007E7D",
    sky = "#007E7D",
    sapphire = "#007E7D",
    blue = "#1675AB",
    lavender = "#1675AB",
    text = "#706F7A",
    subtext1 = "#757480",
    subtext0 = "#757480",
    overlay2 = "#797985",
    overlay1 = "#7E7D8A",
    overlay0 = "#84828F",
    surface2 = "#9C8282",
    surface1 = "#EBDFD3",
    surface0 = "#EBDFD3",
    base = "#FAF4ED",
    mantle = "#FCF9F5",
    crust = "#FCF9F5",
}

-- this is a copy of the original mocha colorscheme, but flipped the base and mantle.
local color_overrides_dark_modified = {
	rosewater = "#f5e0dc",
	flamingo = "#f2cdcd",
	pink = "#f5c2e7",
	mauve = "#cba6f7",
	red = "#f38ba8",
	maroon = "#eba0ac",
	peach = "#fab387",
	yellow = "#f9e2af",
	green = "#a6e3a1",
	teal = "#94e2d5",
	sky = "#89dceb",
	sapphire = "#74c7ec",
	blue = "#89b4fa",
	lavender = "#b4befe",
	text = "#cdd6f4",
	subtext1 = "#bac2de",
	subtext0 = "#a6adc8",
	overlay2 = "#9399b2",
	overlay1 = "#7f849c",
	overlay0 = "#6c7086",
	surface2 = "#585b70",
	surface1 = "#45475a",
	surface0 = "#313244",
	base = "#181825",
	mantle = "#1e1e2e",
	crust = "#11111b",
}

local highlight_overrides = function(colors)
    return {
        -- surface0 and 1 is used as a background color most of the time,
        -- but also as a foreground color in some cases. This makes it
        -- impossible to ensure contrast in all cases.
        -- For this reason, we replace all surface foreground colors with
        -- other surface colors to increase contrast.
        -- (surface2 is a rare color which is exclusively used as a
        -- foreground color)
        --
        -- surface0:
        SnacksIndent = { fg = colors.surface1 },
        IblIndent = { fg = colors.surface1 },

        -- surface1:
        SignColumn = { fg = colors.surface2 }, -- column where |signs| are displayed
        SignColumnSB = { fg = colors.surface2 }, -- column where |signs| are displayed

        LineNr = { fg = colors.surface2 },   -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' o…
        TreesitterContextLineNumber = { fg = colors.surface2 },
        CursorLineNr = { fg = colors.blue }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.

        DapUIUnavailable = { fg = colors.surface2 },

        GitSignsCurrentLineBlame = { fg = colors.surface2 },

        -- More contrast menus:
        Pmenu = { bg = colors.mantle, fg = colors.overlay2 }, -- Popup menu: normal item.
        PmenuSel = { bg = colors.surface1, style = { "bold" } }, -- Popup menu: selected item.

        -- More contrast for window separator:
        WinSeparator = { fg = colors.surface2 }, -- Separator between windows.
    }
end

---@param flavor "mocha"|"macchiato"|"frappe"|"latte"
---@return table overrides to deep-merge into catppuccin config
local get_overrides = function(flavor)
    local color_overrides = color_overrides_dark_modified
    if flavor == "latte" then
        color_overrides = color_overrides_light
    end
    if flavor == "frappe" or flavor == "macchiato" then
        color_overrides = color_overrides_dark
    end
    return {
        color_overrides = {
            [flavor] = color_overrides,
        },
        highlight_overrides = {
            [flavor] = highlight_overrides,
        },
    }
end

local catppuccin_opts = ({
    transparent_background = true,
    flavour = 'mocha'
})
catppuccin_opts = vim.tbl_deep_extend('force', catppuccin_opts, get_overrides('mocha'))
catppuccin_opts = vim.tbl_deep_extend('force', catppuccin_opts, get_overrides('frappe'))
catppuccin_opts = vim.tbl_deep_extend('force', catppuccin_opts, get_overrides('macchiato'))
catppuccin_opts = vim.tbl_deep_extend('force', catppuccin_opts, get_overrides('latte'))

require("catppuccin").setup(catppuccin_opts)

require("tokyonight").setup({
    transparent = true
})

require("rose-pine").setup({
    variant = 'main',
    dark_variant = 'main',
    styles = {
        transparency = false,
        italic = false
    }
})

vim.background = 'dark'
vim.g.moonflyTransparent = true
vim.g.moonflyVirtualTextColor = true
vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_material_background = 'hard'

vim.cmd([[silent! colorscheme catppuccin]])
