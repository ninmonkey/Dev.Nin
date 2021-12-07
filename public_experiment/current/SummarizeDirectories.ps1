<#
    box runes: ├ ─ └
    more: https://www.unicode.org/charts/PDF/U2500.pdf
#>

h1 'example output'

@'
gh root
    ├─ gist
    ├─ isssue
    ├─ pr
    ├─ release
    └─ repo


gist
    ├─ gist
    ├─ isssue
    ├─ pr
    ├─ release
    └─ repo
gist
    |-
'@

h1 @'
Todo: Declare trees using markdown notation, script generates it? like:

gh: gist, issue, pr, release, repo

'@
