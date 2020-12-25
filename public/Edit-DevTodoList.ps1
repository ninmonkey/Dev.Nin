function Edit-DevTodoList {
    [Alias('Edit-TodoList')]
    [CmdletBinding()]
    param(
    )
    Write-Warning 'Edit-DevTodoList: hard-coded'
    $Paths = @{
        TodoList = Get-Item -ea Stop "$Env:UserProfile\Documents\2020\todo\todo ⇽ 2020-12.md"
    }

    code $Paths.TodoList
}