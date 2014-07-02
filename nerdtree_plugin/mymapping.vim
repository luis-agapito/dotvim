call NERDTreeAddKeyMap({
       \ 'key': 'b',
       \ 'callback': 'NERDTreeEchoCurrentNode',
       \ 'quickhelpText': 'echo full path of current node' })

function! NERDTreeEchoCurrentNode()
    let n = g:NERDTreeFileNode.GetSelected()
    if n != {}
        echomsg 'Current node: ' . n.path.str()
    endif
endfunction
