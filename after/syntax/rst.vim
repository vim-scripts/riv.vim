"=============================================
"    Name: rst.vim
"    File: after/syntax/rst.vim
"  Author: Rykka G.Forest
" Summary: syntax file with options.
"  Update: 2012-06-12
"=============================================
let s:cpo_save = &cpo
set cpo-=C

let s:s = g:_riv_s

syn sync match rstHighlight groupthere NONE #^\_s\@!#

" Lists in rst file
syn match rstDefinitionList `\v^(\s*)\h[^:]*\ze%(\s:\s.*)*\n\1\s+\S`
syn match rstBulletList `\v^\s*[-*+]\ze\s+`
syn match rstEnumeratedList `\v\c^\s*%(\d+|[#a-z]|[imlcxvd]+)[.)]\ze\s+`
syn match rstEnumeratedList `\v\c^\s*\(%(\d+|[#a-z]|[imlcxvd]+)\)\ze\s+`
syn match rstOptionList `\v^\s*%(-\w%( \w+)=|--[[:alnum:]_-]+%(\=\w+)=|/\u)%(, %(-\w%( \w+)=|--[[:alnum:]_.-]+%(\=\w+)=|/\u))*%(  |\t)\ze\s*\S`
syn match rstFieldList `\v^\s*:[^:[:space:]][^:]+:\_s`
syn match rstBibliographicField `\v^\s*:(Author|Authors|Organization|Contact|Address|Version|Status|Date|Copyright|Dedication|Abstract):\_s`

syn match rstBlockQuoteAttr  `\v%(\_^\s*\n)@<=\s+---=\s.*`

syn match   rstCommentTitle '\v(^\s+|(^\.\.\s+)@<=):=\u\w*(\s+\u\w*)*:' contained 
syn cluster rstCommentGroup contains=rstCommentTitle,rstTodo


" Local File: "{{{1
syn cluster rstCruft add=rstStandaloneHyperlink
syn cluster rstCommentGroup add=@rstLinkGroup

if g:riv_file_link_style != 0
    exe 'syn match rstFileLink `'.s:s.rstFileLink.'`'
    syn cluster rstCruft add=rstFileLink
endif


" Code Highlight: "{{{1
for code in g:_riv_t.highlight_code
    " for performance , use $VIMRUNTIME and first in &rtp
    let path = join([$VIMRUNTIME, split(&rtp,',')[0]],',')
    let s:{code}path= fnameescape(split(globpath(path, "syntax/".code.".vim"),'\n')[0])
    if filereadable(s:{code}path)
        unlet! b:current_syntax
        exe "syn include @rst_".code." ".s:{code}path
        exe 'syn region rstDirective_'.code.' matchgroup=rstDirective fold '
            \.'start=#\%(sourcecode\|code\%(-block\)\=\)::\s\+'.code.'\_s*# '
            \.'skip=#^$# '
            \.'end=#^\s\@!# contains=@rst_'.code
        exe 'syn cluster rstDirectives add=rstDirective_'.code
    endif
    unlet s:{code}path
endfor
let b:current_syntax = "rst"

" Todo Group: "{{{1
syn cluster rstTodoGroup contains=rstTodoItem,rstTodoPrior,rstTodoTmBgn,rstTodoTmsEnd

exe 'syn match rstTodoRegion `' . s:s.rstTodoRegion .'` transparent contains=@rstTodoGroup'

exe 'syn match rstTodoItem `'.s:s.rstTodoItem.'` contained nextgroup=rstTodoPrior'
exe 'syn match rstTodoPrior `'.s:s.rstTodoPrior.'` contained nextgroup=rstTodoTmBgn'
exe 'syn match rstTodoTmBgn `'.s:s.rstTodoTmBgn.'` contained nextgroup=rstTodoTmEnd'
exe 'syn match rstTodoTmEnd `'.s:s.rstTodoTmEnd.'` contained'

exe 'syn match rstDoneRegion `' . s:s.rstDoneRegion .'`'

" Highlights: "{{{1
if &background == 'light'
    hi def rstFileLink    guifg=#437727  gui=underline ctermfg=28 cterm=underline
else
    hi def rstFileLink    guifg=#58A261  gui=underline ctermfg=77 cterm=underline
endif

hi def link rstTodoItem     Include
hi def link rstTodoPrior    Include
hi def link rstTodoTmBgn    Number
hi def link rstTodoTmEnd    Number
hi def link rstDoneRegion   Comment

hi link rstStandaloneHyperlink          Underlined
hi link rstFootnoteReference            Underlined
hi link rstCitationReference            Underlined
hi link rstHyperLinkReference           Underlined

hi def link rstBulletList                   Function
hi def link rstEnumeratedList               Function
hi def link rstDefinitionList               Statement
hi def link rstFieldList                    Function
hi def link rstBibliographicField           Constant
hi def link rstOptionList                   Statement

hi def link rstBlockQuoteAttr               Exception
hi def link rstCommentTitle                 SpecialComment

let &cpo = s:cpo_save
unlet s:cpo_save
