using System;
using System.Collections.Generic;

namespace PicatBlazorMonaco.Ast
{
    public class BuiltIns
    {
        public static List<(string, string, string)> Operators_basic = new()
        {
            ("^", "Arithmetic", "Power"),
            ("+", "Arithmetic", @"Addition
    STRING - x$ + y$ - Concatenation - The contents of x$ followed by the contents of y$"),
            ("-", "Arithmetic", "Subtraction"),
            ("*", "Arithmetic", @"Multiplication
    STRING - x$ * y - Repetition - The contents of x$ is repeated y times.
    If y is negative, the result is mirrored."),
            ("/", "Arithmetic", "Division"),
            ("\\", "Arithmetic", "Integer division, truncated"),
            ("MOD", "Arithmetic", "Modulo, same as x - FLOOR(x DIV y ) * y"),
            ("AND", "Arithmetic", @"p AND q: BITWISE - Bitwise Conjunction.
    STRING - x$ AND y - Selection - If y is zero, the result is an empty string, otherwise x$"),
            ("A.", "Arithmetic", @"p AND q: BITWISE - Bitwise Conjunction.
    STRING - x$ AND y - Selection - If y is zero, the result is an empty string, otherwise x$"),
            ("&", "Arithmetic", "p & q: BITWISE - Bitwise Conjunction."),
            ("NOT", "Arithmetic", "Bitwise Complement"),
            ("~", "Arithmetic", "Bitwise Complement"),
            ("OR", "Arithmetic", "Bitwise Disjunction"),
            ("|", "Arithmetic", "Bitwise Disjunction"),
            ("XOR", "Arithmetic", "Bitwise Exclusive Or"),
            ("X.", "Arithmetic", "Bitwise Exclusive Or"),
            ("=", "Basic", "Equal\tTrue if a equals b, false otherwise."),
            ("<>", "Basic", "Not equal\tFalse if a equals b, true otherwise."),
            ("<", "Basic", "Less than\tTrue if a is less than b, false otherwise."),
            (">", "Basic", "Greater than\tTrue if a is greater than b, false otherwise."),
            ("<=", "Basic", "Less than or equal\tFalse if a is greater than b, true otherwise."),
            (">=", "Basic", "Greater than or equal\tFalse if a is less than b, true otherwise.")
        };

        public static List<(string, string, string)> FunctionsBasic = new(100);

        public static List<DeclarationParser.Declaration> BuiltinsDeclarationsBasic = new(100);

        public static void InitializeFunctions(string data)
        {
            FunctionsBasic.Clear();
            BuiltinsDeclarationsBasic.Clear();

            string[] lines = data.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
            string module = null;
            string entry = string.Empty;

            foreach (string line in lines)
            {
                if (module != null && entry != string.Empty && line[0] != ' ')
                {
                    string name = entry;
                    int colonIndex = entry.IndexOf(':');

                    if (colonIndex > 0)
                    {
                        name = name[..colonIndex];
                        entry = entry.Insert(colonIndex + 2, "\r\n");
                    }

                    FunctionsBasic.Add((name, module, entry));
                    entry = string.Empty;
                }

                if (line == "-----")
                {
                    module = null;
                }
                else if (module == null)
                {
                    module = line.Trim();
                }
                else
                {
                    if (line[0] == ' ')
                    {
                        entry += "\r\n";
                    }

                    entry += line;
                }
            }

            BuiltinsDeclarationsBasic.Clear();

            foreach ((string, string, string) o in BuiltIns.FunctionsBasic)
            {
                try
                {
                    string decl = o.Item1.Trim();
                    DeclarationParser.Declaration declaration = DeclarationParser.ParseBuiltinDeclaration(decl);
                    declaration.Comment = "[" + o.Item2 + "] " + o.Item3;
                    BuiltinsDeclarationsBasic.Add(declaration);
                }
                catch
                {
                    // NOP
                }
            }
        }
    }
}
