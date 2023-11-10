-- If startup without any options, try to open some file and NeoTree

local M = {}

local function recent()
    local current_dir = vim.fn.expand('%:p:h') .. '/'
    vim.cmd("rshada")
    for _, file in ipairs(vim.v.oldfiles) do
        -- most recent file
        if string.sub(file, 1, string.len(current_dir)) == current_dir and
            not string.find(file, '%[')
        then
            return file
        end
    end
    return ""
end

local function predefined()
    local files = {
        "main.go",   -- go
        "init.lua",  -- lua
        "README.md", -- normal
        "readme.md", -- normal
    }
    for _, file in pairs(files) do
        if vim.fn.findfile(file) ~= "" then
            return file
        end
    end
    return ""
end

M.setup = function()
    if #vim.v.argv > 2 then
        return
    end

    local open_file = recent()

    if open_file == "" then
        open_file = predefined()
    end

    if open_file ~= "" then
        vim.cmd("edit " .. open_file)
        vim.cmd("NeoTreeShow")
        vim.cmd("bp")
    end

    -- fix https://github.com/neovim/neovim/issues/21856
    vim.api.nvim_create_autocmd({ "VimLeave" }, {
        callback = function()
            vim.fn.jobstart("", { detach = true })
        end,
    })
end

return M
