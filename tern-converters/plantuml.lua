function concat_with_space(...)
    return table.concat({ ... }, " ")
end

function remove_filename_from_path(path)
    path = path:gsub("\\", "/")
    return string.match(path, "^(.*)/[^/]*$") or path
end

--- @param input string: The source file/directory
--- @param output string: The destination directory
--- @param options table: A table of strings like {"-tsvg", "-v"}
function convert(input, output, options)
    -- $(realpath %s) is needed bc plantuml is a smartass
    local command = string.format(
        'plantuml %s -o "$(realpath %s)" %s',
        options[1] or "-tsvg",
        remove_filename_from_path(output),
        input
    )
    return os.execute(command)
end

return convert
