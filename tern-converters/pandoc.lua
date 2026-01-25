function concat_with_space(...)
    return table.concat({ ... }, " ")
end

function remove_filename_from_path(path)
    path = path:gsub("\\", "/")
    return string.match(path, "^(.*)/[^/]*$") or path
end

function get_filename(path)
    path = path:gsub("\\", "/")
    local filename = string.match(path, "([^/]+)$")
    if filename then
        return filename:match("^(.-)%.") or filename
    end
    return nil
end

local function run_replacements(input_path, replace_str)
    local tmp_path = os.tmpname()
    local perl_script = ""

    -- Parse replacement pairs
    local args = {}
    for word in replace_str:gmatch("%S+") do
        table.insert(args, word)
    end

    for i = 1, #args, 2 do
        local pattern = args[i]
        local replacement = args[i + 1] or ""
        perl_script = perl_script .. string.format("s/%s/%s/g;", pattern, replacement)
    end

    -- Create command: perl -pe 's/foo/bar/g;...' input > tmpfile
    local command = string.format("perl -pe '%s' \"%s\" > \"%s\"", perl_script, input_path, tmp_path)
    local ok = os.execute(command)
    if ok then
        return tmp_path
    else
        return nil
    end
end

function convert(input, output, options)
    local processed_input = input

    if options[2] and options[2]:match("%S") then
        local replaced = run_replacements(input, options[2])
        if replaced then
            processed_input = replaced
        else
            error("Failed to process replacements")
        end
    end

    local command = concat_with_space(
        "pandoc", options[1],
        "--resource-path", remove_filename_from_path(input),
        "--metadata", "pagetitle=" .. get_filename(input),
        processed_input, "-o", output
    )

    local ok = os.execute(command)

    -- Clean up temp file if one was created
    if processed_input ~= input then
        os.remove(processed_input)
    end

    return ok
end

return convert
