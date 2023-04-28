
// # neat
internal class PrivilegeCompletor : IArgumentCompleter
{
    public IEnumerable<CompletionResult> CompleteArgument(string commandName, string parameterName,
        string wordToComplete, CommandAst commandAst, IDictionary fakeBoundParameters)
    {
        string[] privileges = new string[]
        {
            'SeAssignPrimaryTokenPrivilege',
            'SeAuditPrivilege',
            'SeBackupPrivilege',
            'SeChangeNotifyPrivilege',
            'SeCreateGlobalPrivilege',
            'SeCreatePagefilePrivilege',
            'SeCreatePermanentPrivilege',
            'SeCreateSymbolicLinkPrivilege',
            'SeCreateTokenPrivilege',
            'SeDebugPrivilege',
            'SeEnableDelegationPrivilege',
            'SeImpersonatePrivilege',
            'SeIncreaseBasePriorityPrivilege',
            'SeIncreaseQuotaPrivilege',
            'SeIncreaseWorkingSetPrivilege',
            'SeLoadDriverPrivilege',
            'SeLockMemoryPrivilege',
            'SeMachineAccountPrivilege',
            'SeManageVolumePrivilege',
            'SeProfileSingleProcessPrivilege',
            'SeRelabelPrivilege',
            'SeRemoteShutdownPrivilege',
            'SeRestorePrivilege',
            'SeSecurityPrivilege',
            'SeShutdownPrivilege',
            'SeSyncAgentPrivilege',
            'SeSystemEnvironmentPrivilege',
            'SeSystemProfilePrivilege',
            'SeSystemtimePrivilege',
            'SeTakeOwnershipPrivilege',
            'SeTcbPrivilege',
            'SeTrustedCredManAccessPrivilege',
            'SeTrustedCredManAccessPrivilege',
            'SeUndockPrivilege',
        };

        return privileges
        .Where(p => p.StartsWith(wordToComplete, true, CultureInfo.InvariantCulture))
        .Select(p => ProcessPrivilege(p));
    }

    private CompletionResult ProcessPrivilege(string privilege)
    {
        return new CompletionResult(privilege, 'todo name', CompletionResultType.ParameterValue, 'todo description');
    }
}

