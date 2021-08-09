if($env:TERM_PROGRAM -eq 'vscode') {
    Function Prompt { 'PS \' + "$pwd".Split('\')[-1] + '> ' }
}
