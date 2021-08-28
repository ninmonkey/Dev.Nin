$experimentToExport.function += 'Test-ConsoleSpecialFont'
# $experimentToExport.alias += 'findEnvPattern'

function Test-ConsoleSpecialFont {
    <#
    .synopsis
        Prints example special characters, to test if ie: powerline or others are working
    .description
        .
    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Abbr, print a shorter test
        [Parameter()][switch]$ShortExample
    )
    $TemplateShortParam = @'

      .= .- ..= := ::= =:= __
     == != === !== =/= =!=

<-< <<- <-- <- <-> -> --> ->> >->
<=< <<= <== <<->> <=> => ==> =>> >=>
    >>= >>- >- <~> -< -<< =<<
      <-| <=| /\ \/ |-> |=>
        <~~ <~ ~~ ~> ~~>

     <<< << <= <> >= >> >>>
       {. {| [|  |] |} .}
<:> >:< >:> <:< :>: :<: :> :< >: <:
   <||| <|| <| <|> |> ||> |||>

            <$ <$> $>
            <+ <+> +>
            <* <*> *>

      \n  \\  /* */  /// //
      </ <!--  </>  --> />
      0xF www Fl Tl Il fi fj

       ;; :: ::: !! ?? %% &&
        || .. ... ..< .? ?.
       -- --- ++ +++ ** ***

         =~ !~ ~- -~ ~@
          ^= ?= /= /==
       -| _|_ |- ||- |= ||=
        #! #= ## ### ####
      #{ #[ ]# #( #? #_ #_(

# Context-aware alignment

fii fjj
a*b a*A B*b A*B *a *A a* A*
a-b a-A B-b A-B -a -A a- A-
a+b a+A B+b A+B +a +A a+ A+
a:b a:A B:b A:B :a :A a: A:

# Powerline

      

# Stylistic sets

r 0 123456789 & && $ <$ <$> $> @ <= >=

# Unicode

≢ ẞ ᐅ ᐊ ∴ ∵ ⎈ ‖ ∧ ∨ ⊢ ⊣ ⊤ ⊥ ⊦ ⊧ ⊨ ⊩ ⊪ ⊫ ⊬ ⊭ ⊮ ⊯
⟲⟳ ⟰ ⟱ ⟴ ⟵ ⟶ ⟷ ⟸ ⟹ ⟺ ⟻ ⟼ ⟽ ⟾ ⟿
↩ ⇞ ⇟ ⇤ ⇥ ⌀ ⌃ ⌄ ⌅ ⌆ ⌘ ⌤ ⌥ ⎇ ⎋ ⏏ ✓ ☐ ☑ ☒ ▤ ▦ ▧ ▨ ▩
␆ ␈ ␇ ␣ ␢ ␘ ␍ ␐ ␡ ␥ ␔ ␑ ␓ ␒ ␙ ␃ ␄ ␗ ␅ ␛ ␜ ␌ ␝ ␉ ␊ ␕ ␤ ␀ ␞ ␏ ␎ ␠ ␁ ␂ ␚ ␦ ␖ ␟ ␋
ℂ ℍ ℕ ℙ ℚ ℝ ℤ 𝔹 ∀ ∃ ∄ ∅ ⊂ ⊃ ⊄ ⊅ ⊆ ⊇ ⊈ ⊉ ⊊ ⊋ ∈ ∉ ∊ ∋ ∌ ∍ ∪ ∩
☰ ☱ ☲ ☳ ☴ ☵ ☶ ☷ 「a」 ｢a｣

# Box drawing

╭╌╌╌╌╮ ╭┄┄┄┄╮ ╭┈┈┈┈╮
╎    ╏ ┆    ┇ ┊    ┋
╎    ╏ ┆    ┇ ┊    ┋
╰╍╍╍╍╯ ╰┅┅┅┅╯ ╰┉┉┉┉╯

┌─┬─┐ ╔╦═╗ ┏━┳┓ ╒═╤═╗ ╭─┰─╮ ○   ○ ◆ ◆
├─┼─┤ ╠╬═╣ ┣━╋┫ ├─┼─╢ ┝━╋━┥  ╲ ╱   ╳
└─┴─┘ ╚╩═╝ ┗━┻┛ ╘═╧═╝ ╰─┸─╯   ■   ◆ ◆

# Blocks

|███   | 50%

▖ ▗ ▙ ▚ ▛ ▜ ▞ ▟
'@

    if ($ShortExample) {
        return
    }

    $Source = Get-Item -ea ignore "$Env:UserProfile\Documents\2021\dotfiles_git\windowsterminal\showcases.txt"

    if ( $Source) {
        Write-Verbose "Using: '$Source'"
        Get-Content $Source
        return
    }

    if (! $Source) {
        $Url = 'https://raw.githubusercontent.com/tonsky/FiraCode/master/extras/showcases.txt'
        $resp = Invoke-WebRequest -Uri $url
        $resp.RawContent
        Write-Verbose "Downlad Address new: $url"

    }
}
