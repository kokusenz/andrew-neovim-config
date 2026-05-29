local cmp = {} -- statusline components

--- Global function to retrieve and call statusline component functions
--- Used in statusline format strings via %{%v:lua._statusline_component("name")%}
--- @param name string The component name to retrieve from the cmp table
--- @return string The result of calling the component function
function _G._statusline_component(name)
    return cmp[name]()
end

local hi_pattern = '%%#%s#%s%%*'

--- Display diagnostic status for the current buffer
--- Shows error count, warning count, or OK indicator with appropriate highlighting
--- @return string Formatted diagnostic status string with highlight groups
function cmp.diagnostic_status()
    local mode = vim.api.nvim_get_mode().mode

    if mode == 'c' then
        return hi_pattern:format('', '  ')
    end
    if mode == 't' then
        return hi_pattern:format('', '  ')
    end

    local levels = vim.diagnostic.severity
    local errors = #vim.diagnostic.get(0, {severity = levels.ERROR})
    if errors > 0 then
        return hi_pattern:format('DiagnosticError', '  ')
    end

    local warnings = #vim.diagnostic.get(0, {severity = levels.WARN})
    if warnings > 0 then
        return hi_pattern:format('DiagnosticWarn', '  ')
    end

    return hi_pattern:format('DiagnosticOk', '  ')
end

--- Display current line and column position
--- @return string Formatted position string with Search highlight group
function cmp.line_position()
    return hi_pattern:format('', '%3l:%-3c')
end

-- do %t for "tail end of file" (eg. file name), but %f if file path matters (eg. duplicate file names because bad repositories lol)
local statusline = {
    '%t',
    '%r',
    '%m',
    '%=',
    '%{%v:lua._statusline_component("line_position")%}',
    '%{%v:lua._statusline_component("diagnostic_status")%} '
}

vim.o.statusline = table.concat(statusline, '')
