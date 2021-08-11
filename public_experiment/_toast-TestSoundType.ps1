
$experimentToExport.function += @(
    '_toastTimer-TrySound'
)
$experimentToExport.alias += @(
    'Alarm-TrySound'
)

function _toastTimer-TrySound {
    <#
    .synopsis
        super easy to invoke timer
    .example
        gcm 'New-BTAudio' | gpi | Ft
        gcm -Module BurntToast | sort
    .notes
        see also:

            [Microsoft.Toolkit.Uwp.Notifications.ToastAudio]
            BurntToast\New-BTAudio
    .link
        BurntToast\New-BTAudio
    #>

    [alias('Alarm-TrySound')]
    [cmdletbinding()]
    param(
        [validateset('Default', 'IM', 'Mail', 'Reminder', 'SMS', 'Alarm', 'Alarm2', 'Alarm3', 'Alarm4', 'Alarm5', 'Alarm6', 'Alarm7', 'Alarm8', 'Alarm9', 'Alarm10', 'Call', 'Call2', 'Call3', 'Call4', 'Call5', 'Call6', 'Call7', 'Call8', 'Call9', 'Call10')]
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'BasicSound')]
        [string[]]$SoundName
    )


    # Specifies one of the built in Microsoft notification sounds.
    # Exact same?
    # This paramater takes the full form of the sounds, in the form of a uri. The New-BurntToastNotification function simplifies this, so be aware of the difference.
    #     [Parameter(
    #         Mandatory, Position = 0,
    #         ParameterSetName = 'SoundUri'
    #     )]
    #     [ValidateSet('ms-winsoundevent:Notification.Default',
    #         'ms-winsoundevent:Notification.IM',
    #         'ms-winsoundevent:Notification.Mail',
    #         'ms-winsoundevent:Notification.Reminder',
    #         'ms-winsoundevent:Notification.SMS',
    #         'ms-winsoundevent:Notification.Looping.Alarm',
    #         'ms-winsoundevent:Notification.Looping.Alarm2',
    #         'ms-winsoundevent:Notification.Looping.Alarm3',
    #         'ms-winsoundevent:Notification.Looping.Alarm4',
    #         'ms-winsoundevent:Notification.Looping.Alarm5',
    #         'ms-winsoundevent:Notification.Looping.Alarm6',
    #         'ms-winsoundevent:Notification.Looping.Alarm7',
    #         'ms-winsoundevent:Notification.Looping.Alarm8',
    #         'ms-winsoundevent:Notification.Looping.Alarm9',
    #         'ms-winsoundevent:Notification.Looping.Alarm10',
    #         'ms-winsoundevent:Notification.Looping.Call',
    #         'ms-winsoundevent:Notification.Looping.Call2',
    #         'ms-winsoundevent:Notification.Looping.Call3',
    #         'ms-winsoundevent:Notification.Looping.Call4',
    #         'ms-winsoundevent:Notification.Looping.Call5',
    #         'ms-winsoundevent:Notification.Looping.Call6',
    #         'ms-winsoundevent:Notification.Looping.Call7',
    #         'ms-winsoundevent:Notification.Looping.Call8',
    #         'ms-winsoundevent:Notification.Looping.Call9',
    #         'ms-winsoundevent:Notification.Looping.Call10')]
    #     [uri[]] $SoundUri
    # )
    begin {

    }
    process {
        $SoundName | ForEach-Object {
            $Cur = $_
            "Sound Name: $_"
            New-BurntToastNotification -Text "SoundName: $_" -Sound $_
            Start-Sleep -Seconds 2
        }

        # $SoundUri | ForEach-Object {
        #     $Cur = $_
        #     "Sound Uri: $_"
        #     New-BurntToastNotification -Text "Sound Uri: $_" -Sound $_
        #     Start-Sleep -Seconds 2
        # }




    }
}
