local function init()
    require 'kirre.vim'.init()
    require 'kirre.lazy'.init()
    require 'kirre.floaterm'.init()
end

return {
    init = init,
}
