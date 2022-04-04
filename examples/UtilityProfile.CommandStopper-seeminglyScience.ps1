# UtilityProfile.CommandStopper

function EnsureCommandStopperInitialized {
    [CmdletBinding()]
    param()
    end {
        if ('UtilityProfile.CommandStopper' -as [type]) {
            return
        }

        Add-Type -TypeDefinition '
            using System;
            using System.ComponentModel;
            using System.Linq.Expressions;
            using System.Management.Automation;
            using System.Management.Automation.Internal;
            using System.Reflection;
            namespace UtilityProfile
            {
                [EditorBrowsable(EditorBrowsableState.Never)]
                [Cmdlet(VerbsLifecycle.Stop, "UpstreamCommand")]
                public class CommandStopper : PSCmdlet
                {
                    private static readonly Func<PSCmdlet, Exception> s_creator;
                    static CommandStopper()
                    {
                        ParameterExpression cmdlet = Expression.Parameter(typeof(PSCmdlet), "cmdlet");
                        s_creator = Expression.Lambda<Func<PSCmdlet, Exception>>(
                            Expression.New(
                                typeof(PSObject).Assembly
                                    .GetType("System.Management.Automation.StopUpstreamCommandsException")
                                    .GetConstructor(
                                        BindingFlags.Public | BindingFlags.Instance,
                                        null,
                                        new Type[] { typeof(InternalCommand) },
                                        null),
                                cmdlet),
                            "NewStopUpstreamCommandsException",
                            new ParameterExpression[] { cmdlet })
                            .Compile();
                    }
                    [Parameter(Position = 0, Mandatory = true)]
                    [ValidateNotNull]
                    public Exception Exception { get; set; }
                    [Hidden, EditorBrowsable(EditorBrowsableState.Never)]
                    public static void Stop(PSCmdlet cmdlet)
                    {
                        var exception = s_creator(cmdlet);
                        cmdlet.SessionState.PSVariable.Set("__exceptionToThrow", exception);
                        var variable = GetOrCreateVariable(cmdlet, "__exceptionToThrow");
                        object oldValue = variable.Value;
                        try
                        {
                            variable.Value = exception;
                            ScriptBlock.Create("& $ExecutionContext.InvokeCommand.GetCmdletByTypeName([UtilityProfile.CommandStopper]) $__exceptionToThrow")
                                .GetSteppablePipeline(CommandOrigin.Internal)
                                .Begin(false);
                        }
                        finally
                        {
                            variable.Value = oldValue;
                        }
                    }
                    private static PSVariable GetOrCreateVariable(PSCmdlet cmdlet, string name)
                    {
                        PSVariable result = cmdlet.SessionState.PSVariable.Get(name);
                        if (result != null)
                        {
                            return result;
                        }
                        result = new PSVariable(name, null);
                        cmdlet.SessionState.PSVariable.Set(result);
                        return result;
                    }
                    protected override void BeginProcessing()
                    {
                        throw Exception;
                    }
                }
            }'
    }
}
