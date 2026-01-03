return {
    {
        "pmouraguedes/neodarcula.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true, -- Enable transparent background
            dim = true,         -- Dim inactive windows with a black background
        },
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "neodarcula",
        },
    },
}