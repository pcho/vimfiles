let g:go_list_type = "quickfix"
let g:go_metalinter_command = "golangci-lint"
let g:go_autodetect_gopath = 1
let g:go_jump_to_error = 1

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

setlocal foldmarker={,}
setlocal nofoldenable

nmap <localleader>at <Plug>(go-test)
nmap <localleader>ab <Plug>(go-build)
nmap <localleader>ar <Plug>(go-run)
nmap <localleader>ai <Plug>(go-imports)
nmap <localleader>al <Plug>(go-metalinter)
