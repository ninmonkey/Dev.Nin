function Get-RegexHelp {
    $urls = @(
        @{
            Uri  = 'https://docs.microsoft.com/en-us/dotnet/standard/base-types/substitutions-in-regular-expressions'
            Name = 'Replacement and Substitutions reference'
            Tags = 'reference', 'replacement', 'docs'
        },
        @{
            Uri  = 'https://docs.microsoft.com/en-us/dotnet/standard/base-types/regular-expression-language-quick-reference'
            Name = 'Dotnet TOC reference'
            Tags = 'reference', 'toc', 'docs'
        },
        @{
            Uri  = 'https://regex101.com/'
            Name = 'Regex Editor regex101.com'
            Tags = 'web app', 'editor'
        },
        @{
            Uri  = 'https://docs.microsoft.com/en-us/dotnet/standard/base-types/regular-expression-language-quick-reference'
            Name = 'Best Practices | Dotnet'
            Tags = 'docs', 'best practice', 'dotnet'
        },
        @{
            Uri  = 'https://docs.microsoft.com/en-us/dotnet/standard/base-types/details-of-regular-expression-behavior'
            Name = 'Dotnet Regex engine'
            Tags = 'docs', 'engine'
        }
        # @{
        #     Uri  = 'https://docs.microsoft.com/en-us/dotnet/standard/base-types/regular-expression-language-quick-reference'
        #     Name = 'Replacement and Substitutions reference'
        #     Tags = 'reference', 'toc', 'docs'
        # },
    )
    $urls
}
