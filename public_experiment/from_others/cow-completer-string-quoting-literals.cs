/*
original context: <https://discord.com/channels/180528040881815552/447476117629304853/911006818455679017>
*/



using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;

public class Program
{
    public enum StringConstantType
    {
        BareWord = 4,
        DoubleQuoted = 2,
        DoubleQuotedHereString = 3,
        SingleQuoted = 0,
        SingleQuotedHereString = 1
    }

	private readonly static IReadOnlyDictionary<char, char> escapeLookup = new Dictionary<char, char>()
    {
        { '\0', '0' },
        { '\a', 'a' },
        { '\b', 'b' },
        { '\f', 'f' },
        { '\t', 't' },
        { '\v', 'v' },
        { '\n', 'n' },
        { '\r', 'r' },
    };

    private readonly static IReadOnlyDictionary<StringConstantType, char[]> charsToEscape = new Dictionary<StringConstantType, char[]>()
    {
        { StringConstantType.BareWord,      new char[] { '$', '`', ' ', '"', '\'', '{', '}', '\0', '\a', '\b', '\f', '\t', '\v', '\n', '\r' } },
        { StringConstantType.DoubleQuoted,  new char[] { '$', '`', '"',                      '\0', '\a', '\b', '\f', '\t', '\v', '\n', '\r' } },
        { StringConstantType.DoubleQuotedHereString,  new char[] { '$', '`',                 '\0', '\a', '\b', '\f', '\t', '\v', '\n', '\r' } },
        { StringConstantType.SingleQuoted,  new char[] { '\'' } }
    };

    private readonly static IReadOnlyDictionary<StringConstantType, char?> escapeChar = new Dictionary<StringConstantType, char?>()
    {
        { StringConstantType.BareWord,                  '`' },
        { StringConstantType.DoubleQuoted,              '`' },
        { StringConstantType.DoubleQuotedHereString,    '`' },
        { StringConstantType.SingleQuoted,              '\'' }
    };

    private readonly static IReadOnlyDictionary<StringConstantType, string[]> unsupportedStrings = new Dictionary<StringConstantType, string[]>()
    {
        { StringConstantType.SingleQuotedHereString, new string[] { "\n'@", "\r\n'@" } }
    };

    internal static string Escape(StringConstantType type, string value)
    {
        var charsToEscape = Program.charsToEscape.GetValueOrDefault(type);
        var escapeChar = Program.escapeChar.GetValueOrDefault(type);
        var unsupportedStrings = Program.unsupportedStrings.GetValueOrDefault(type);
        if (unsupportedStrings != null)
        {
            var unsupportedString = unsupportedStrings.FirstOrDefault(unsupportedString => value.Contains(unsupportedString));
            if (unsupportedString != null)
            {
                throw new InvalidOperationException($"Can't escape string of type {type} containing {unsupportedString}");
            }
        }
        if (escapeChar != null && charsToEscape != null)
        {
            var numberOfMatches = charsToEscape.Count(c => charsToEscape.Contains(c));
            if (numberOfMatches != 0)
            {
                var builder = new StringBuilder(value.Length + numberOfMatches);
                for (int i = 0; i < value.Length; i++)
                {
                    var c = value[i];
                    if (charsToEscape.Contains(c))
                    {
                        builder.Append(escapeChar);
                    }
                    if (escapeLookup.ContainsKey(c))
                    {
                        builder.Append(escapeLookup[c]);
                    }
                    else
                    {
                        builder.Append(c);
                    }
                }
                return builder.ToString();
            }
        }
        return value;
    }

	public static void Main()
	{
		Console.WriteLine(Escape(StringConstantType.BareWord, "$Hello World'\""));
		Console.WriteLine(Escape(StringConstantType.DoubleQuoted, "$Hello World'\""));
		Console.WriteLine(Escape(StringConstantType.SingleQuoted, "$Hello World'\""));
	}
}