" ARM GNU assembler uses @ for line comments. Keep # available for immediates
" and C preprocessor directives in .S files.
syntax clear asmComment

syntax keyword asmTodo contained TODO FIXME XXX NOTE
syntax region asmComment start="/\*" end="\*/" contains=asmTodo,@Spell
syntax region asmComment start="//" end="$" keepend contains=asmTodo,@Spell
syntax match asmComment "@.*" contains=asmTodo,@Spell

highlight default link asmComment Comment
highlight default link asmTodo Todo
