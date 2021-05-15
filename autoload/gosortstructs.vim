" Copyright (c) Danish Prakash
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

let s:gosortstructs_cmd = 'gosortstructs'
if exists('g:gosortstructs_cmd')
    let s:gosortstructs_cmd = g:gosortstructs_cmd
endif

" sorts specified struct
function! gosortstructs#One() abort
    let l:line = a:firstline . ',' . a:lastline
    let l:args = printf('--line %s', l:line)

    call s:run(l:args)
endfunction

" sorts all structs in the current Go file
function! gosortstructs#All() abort
    call s:run("") " no args
endfunction

" updates the current buffer with output from `gosortstructs`
" it does the following in order:
"   - create a tmp buffer
"   - copy contents of active buffer to tmp buffer
"   - execute `gosortstructs` on the tmp buffer
"   - rename tmp buffer to the file referenced by the active buffer
function! s:run(args) abort
    if !executable(s:gosortstructs_cmd)
        call s:error('gosortstructs executable not found') " TODO: use s:gosortstructs_cmd
        return
    endif

    " save current view to restore post processing
    let l:curview = winsaveview()

    " write current file to temp buffer
    let l:tempname = tempname() . '.go'
    call writefile(s:get_lines(), l:tempname)

    call s:execute(l:tempname, a:args)
    call s:update_file(l:tempname, expand('%'))

    " restore view
    call winrestview(l:curview)
endfunction

function! s:get_cmd(file, args) abort
    let l:file = expand('%')
    return printf('%s --write --file %s ', s:gosortstructs_cmd, a:file) . a:args
endfunction

function! s:execute(target, args) abort
    let l:cmd = s:get_cmd(a:target, a:args)

    let l:out = system(l:cmd)
    let l:err = v:shell_error

    return [l:out, l:err]
endfunction

function s:get_lines() abort
    return getline(1, '$')
endfunction

function! s:update_file(source, target) abort
    call rename(a:source, a:target)

    " reload buffer silently to reflect changes
    silent edit!
endfunction
