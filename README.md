<h2 align="center">vim-gosortstructs</h2>
<p align="center">vim plugin for gosortstructs</p>
<p align="center">
<img src="https://i.imgur.com/G30G4Xf.gif" height="570" width="720">
</p>

### What?
Vim plugin for [gosortstructs](https://github.com/danishprakash/gosortstructs). Helps with sorting structs in a Go source if you're into that. Read [this](https://github.com/danishprakash/gosortstructs/README.md') for more info.

### Default commands
```text
GoSortStruct
    Sorts the struct under the cursor, if any.
    Draws struct boundary implicitly, optionally accepts a range

GoSortStructs
    Sorts all the structs in the active buffer. Doesn't accept range.
```

### Installation
Using [vim-zen](https://github.com/danishprakash/vim-zen):
```vim
Plugin 'danishprakash/vim-gosortstructs'
```

### License
MIT License

Copyright (c) [Danish Prakash](https://github.com/danishprakash)
