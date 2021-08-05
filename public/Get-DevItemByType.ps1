function Get-DevItemByType {
    [Alias('Get-ItemByType')]
    param ()
    Write-Warning 'NYI()

# compare with

🐒> gcm get-itemtype, dev-*newest*item*, find-*item*
>> | ft CommandType, Name, Source -AutoSize

CommandType Name              Source
----------- ----              ------
      Alias Find-Item         Dev.Nin
   Function Dev-GetNewestItem Dev.Nin
   Function Find-DevItem      Dev.Nin
   Function Get-ItemType      Ninmonkey.Powershell
    '
}
