Using namespace system.text
# using namespace globalization

$experimentToExport.function += @(
    'Get-UnicodeCategoryHelp'
)
$experimentToExport.alias += @(
   'Help-UnicodeCategories'
)

function Get-UnicodeCategoryHelp {
    <#
    .synopsis
        Get the meaning of the different groups

    .notes
        The enum itself:

        Name                    Value Hex  Bits
        ----                    ----- ---  ----
        UppercaseLetter             0 0x0  0000.0000
        LowercaseLetter             1 0x1  0000.0001
        TitlecaseLetter             2 0x2  0000.0010
        ModifierLetter              3 0x3  0000.0011
        OtherLetter                 4 0x4  0000.0100
        NonSpacingMark              5 0x5  0000.0101
        SpacingCombiningMark        6 0x6  0000.0110
        EnclosingMark               7 0x7  0000.0111
        DecimalDigitNumber          8 0x8  0000.1000
        LetterNumber                9 0x9  0000.1001
        OtherNumber                10 0xa  0000.1010
        SpaceSeparator             11 0xb  0000.1011
        LineSeparator              12 0xc  0000.1100
        ParagraphSeparator         13 0xd  0000.1101
        Control                    14 0xe  0000.1110
        Format                     15 0xf  0000.1111
        Surrogate                  16 0x10 0001.0000
        PrivateUse                 17 0x11 0001.0001
        ConnectorPunctuation       18 0x12 0001.0010
        DashPunctuation            19 0x13 0001.0011
        OpenPunctuation            20 0x14 0001.0100
        ClosePunctuation           21 0x15 0001.0101
        InitialQuotePunctuation    22 0x16 0001.0110
        FinalQuotePunctuation      23 0x17 0001.0111
        OtherPunctuation           24 0x18 0001.1000
        MathSymbol                 25 0x19 0001.1001
        CurrencySymbol             26 0x1a 0001.1010
        ModifierSymbol             27 0x1b 0001.1011
        OtherSymbol                28 0x1c 0001.1100
        OtherNotAssigned           29 0x1d 0001.1101
    #>
    # [System.Globalization.UnicodeCategory] | Get-EnumInfo
    <#
    scraped from <https://docs.microsoft.com/en-us/dotnet/api/system.globalization.unicodecategory?view=net-5.0#fields>
    [Globalization.UnicodeCategory] maappin
#>
    [Alias('Help-UnicodeCategories')]
    [cmdletbinding()]
    param()
    $_GI_UniCatMapping = @(
        , @('ClosePunctuation', '21' 	, 'Closing character of one of the paired punctuation marks, such as parentheses, square brackets, and braces. Signified by the Unicode designation "Pe" (punctuation, close). The value is 21.')
        , @('ConnectorPunctuation', '18' 	, 'Connector punctuation character that connects two characters. Signified by the Unicode designation "Pc" (punctuation, connector). The value is 18.')
        , @('Control', '14' 	, 'Control code character, with a Unicode value of U+007F or in the range U+0000 through U+001F or U+0080 through U+009F. Signified by the Unicode designation "Cc" (other, control). The value is 14.')
        , @('CurrencySymbol', '26' 	, 'Currency symbol character. Signified by the Unicode designation "Sc" (symbol, currency). The value is 26.')
        , @('DashPunctuation', '19' 	, 'Dash or hyphen character. Signified by the Unicode designation "Pd" (punctuation, dash). The value is 19.')
        , @('DecimalDigitNumber', '8' 	, 'Decimal digit character, that is, a character in the range 0 through 9. Signified by the Unicode designation "Nd" (number, decimal digit). The value is 8.')
        , @('EnclosingMark', '7' 	, 'Enclosing mark character, which is a nonspacing combining character that surrounds all previous characters up to and including a base character. Signified by the Unicode designation "Me" (mark, enclosing). The value is 7.')
        , @('FinalQuotePunctuation', '23' 	, 'Closing or final quotation mark character. Signified by the Unicode designation "Pf" (punctuation, final quote). The value is 23.')
        , @('Format', '15' 	, 'Format character that affects the layout of text or the operation of text processes, but is not normally rendered. Signified by the Unicode designation "Cf" (other, format). The value is 15.')
        , @('InitialQuotePunctuation', '22' 	, 'Opening or initial quotation mark character. Signified by the Unicode designation "Pi" (punctuation, initial quote). The value is 22.')
        , @('LetterNumber', '9' 	, 'Number represented by a letter, instead of a decimal digit, for example, the Roman numeral for five, which is "V". The indicator is signified by the Unicode designation "Nl" (number, letter). The value is 9.')
        , @('LineSeparator', '12' 	, 'Character that is used to separate lines of text. Signified by the Unicode designation "Zl" (separator, line). The value is 12.')
        , @('LowercaseLetter', '1' 	, 'Lowercase letter. Signified by the Unicode designation "Ll" (letter, lowercase). The value is 1.')
        , @('MathSymbol', '25' 	, 'Mathematical symbol character, such as "+" or "= ". Signified by the Unicode designation "Sm" (symbol, math). The value is 25.')
        , @('ModifierLetter', '3' 	, 'Modifier letter character, which is free-standing spacing character that indicates modifications of a preceding letter. Signified by the Unicode designation "Lm" (letter, modifier). The value is 3.')
        , @('ModifierSymbol', '27' 	, 'Modifier symbol character, which indicates modifications of surrounding characters. For example, the fraction slash indicates that the number to the left is the numerator and the number to the right is the denominator. The indicator is signified by the Unicode designation "Sk" (symbol, modifier). The value is 27.')
        , @('NonSpacingMark', '5' 	, 'Nonspacing character that indicates modifications of a base character. Signified by the Unicode designation "Mn" (mark, nonspacing). The value is 5.')
        , @('OpenPunctuation', '20' 	, 'Opening character of one of the paired punctuation marks, such as parentheses, square brackets, and braces. Signified by the Unicode designation "Ps" (punctuation, open). The value is 20.')
        , @('OtherLetter', '4' 	, 'Letter that is not an uppercase letter, a lowercase letter, a titlecase  etter, or a modifier letter. Signified by the Unicode designation "Lo" (letter, other). The value is 4.')
        , @('OtherNotAssigned', '29' 	, 'Character that is not assigned to any Unicode category. Signified by the Unicode designation "Cn" (other, not assigned). The value is 29.')
        , @('OtherNumber', '10' 	, 'Number that is neither a decimal digit nor a letter number, for example, the fraction 1/2. The indicator is signified by the Unicode designation "No" (number, other). The value is 10.')
        , @('OtherPunctuation', '24' 	, 'Punctuation character that is not a connector, a dash, open punctuation, close punctuation, an initial quote, or a final quote. Signified by the Unicode designation "Po" (punctuation, other). The value is 24.')
        , @('OtherSymbol', '28' 	, 'Symbol character that is not a mathematical symbol, a currency symbol or a modifier symbol. Signified by the Unicode designation "So" (symbol, other). The value is 28.')
        , @('ParagraphSeparator', '13' 	, 'Character used to separate paragraphs. Signified by the Unicode designation "Zp" (separator, paragraph). The value is 13.')
        , @('PrivateUse', '17' 	, 'Private-use character, with a Unicode value in the range U+E000 through U+F8FF. Signified by the Unicode designation "Co" (other, private use). The value is 17.')
        , @('SpaceSeparator', '11' 	, 'Space character, which has no glyph but is not a control or format character. Signified by the Unicode designation "Zs" (separator, space). The value is 11.')
        , @('SpacingCombiningMark', '6' 	, 'Spacing character that indicates modifications of a base character and affects the width of the glyph for that base character. Signified by the Unicode designation "Mc" (mark, spacing combining). The value is 6.')
        , @('Surrogate', '16' 	, 'High surrogate or a low surrogate character. Surrogate code values are in the range U+D800 through U+DFFF. Signified by the Unicode designation "Cs" (other, surrogate). The value is 16.')
        , @('TitlecaseLetter', '2' 	, 'Titlecase letter. Signified by the Unicode designation "Lt" (letter, titlecase). The value is 2.')
        , @('UppercaseLetter', '0' 	, 'Uppercase letter. Signified by the Unicode designation "Lu" (letter, uppercase). The value is 0.')
    ) | ForEach-Object {
        [pscustomobject]@{
            Name        = $_[0]
            Value       = $_[1] -as 'int'
            Designation = if ($_[2] -match 'designation\s+(?<Designation>".*?\))') { $Matches.Designation }
            Description = $_[2]
        }
    } | Sort-Object Value, Name

    $_GI_UniCatMapping
}
