let s:gosortstructs_cmd = 'gosortstructs'
if exists('g:gosortstructs_cmd')
    let s:gosortstructs_cmd = g:gosortstructs_cmd
endif

function! gosortstructs#Run() abort
    if !executable(s:gosortstructs_cmd)
        call s:error('gosortstructs executable not found') " TODO: use s:gosortstructs_cmd
        return
    endif

    " get cursor (line number)
    " to pass to gosortstructs
    "

    " save current view to restore post processing
    let l:curview = winsaveview()

    " write current file to temp buffer
    " let l:tempname = tempname() . '.go'
    let l:tempname = '/tmp/testtt.go'
    call writefile(s:get_lines(), l:tempname)

    let l:line = a:firstline . ',' . a:lastline

    " save current column
    let l:current_col = col('.')
    let [l:out, l:err] = s:execute_cmd(l:tempname, l:line)
    let line_offset = len(readfile(l:tempname)) - line('$')
    let l:orig_line = getline('.')

    call s:update_file(l:tempname, expand('%'))

    " restore view
    call winrestview(l:curview)

    " TODO: restore the exact cursor line using line_offset
endfunction

function! s:get_cmd(file, line) abort
    let l:file = expand('%')
    return printf('%s --reverse --write --file %s --line %s', s:gosortstructs_cmd, a:file, a:line)
endfunction

function! s:execute_cmd(target, line) abort
    let l:cmd = s:get_cmd(a:target, a:line)
    let l:out = system(l:cmd)
    let l:err = v:shell_error

    return [l:out, l:err]
endfunction

function s:get_lines() abort
    return getline(1, '$')
endfunction

function! s:update_file(source, target) abort
    " let old_fileformat = &fileformat
    call rename(a:source, a:target)

    " reload buffer silently to reflect changes
    silent edit!

    " let &fileformat = l:old_fileformat
endfunction

function! s:get_position(mode) abort
    if a:mode ==# 'v'
        return printf('#L%d-L%d', line("'<"), line("'>"))
    else
        return printf('#L%d', line('.'))
    endif
endfunction
