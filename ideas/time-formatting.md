
# Expected behavior

## Misc datetime

// date to->format with tooltip, completer

see [Now-NewInstance](C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment\time\Now-NewInstance.ps1)





```ps1
# Some syntax
```

Command :=
    [ Yesterday | Today | Now | Tomorrow ] <args>

DateTimeCommands :=
    [ Yesterdday | Today | Tomorrow ]

TimeOnlyCmd :=
    [ formatString = 'o' ? ]
    TimeArgs ]

[ TimeArgs ] :=
    [ 
        formatstr
        | dt
        | str (default format str)
    ]

```ps1
Now
    # <Obj> now as dt

Now -as Time 
    # <Obj> now as dt

Now -as 'o'
    # <Obj.ToUniversal()> now as [dt] using 'o'
Now -as 'u'
    # <Obj.ToUniversal()> now as [dt] using 'u'

Now -minus '1.3s'
    # <Obj> - <RelativeTs>
Now -plus '3d'
    # <Obj> + <RelativeTs>

Tomorrow -as 'o'
    # <Obj.AddDays(1)> now as [dt] using 'o'
    
```

```ps1

🐒> $now.ToUniversalTime().ToString('o')

    2022-03-31T20:30:58.2194085Z

# vs: $now.ToUniversalTime() 
🐒> Now 

    Thursday, March 31, 2022 8:30:58 PM

🐒> $now.ToUniversalTime().ToString('o')

    # <output is> $now.ToUniversalTime().ToString('o')
    $now.tostring('o')

# --------===============


2022-03-31T20:30:58.2194085Z


8 of 8 /docs/Powershell/My_Github/Dev.Nin/publi
🐒> $now.ToUniversalTime() #.ToString('o')


# --------===============



Thursday, March 31, 2022 8:30:58 PM



8 of 8 /docs/Powershell/My_Github/Dev.Nin/publi
🐒> $now.ToString('o')                    


# --------===============


2022-03-31T15:30:58.2194085-05:00


8 of 8 /docs/Powershell/My_Github/Dev.Nin/publi
🐒> $now.ToString('o')                    


# --------===============


2022-03-31T15:30:58.2194085-05:00
```