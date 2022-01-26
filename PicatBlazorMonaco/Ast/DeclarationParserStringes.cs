﻿using SoftCircuits.Parsing.Helper;
using Stringes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace PicatBlazorMonaco.Ast
{
    public class DeclarationParserStringes
    {
        // Lexer
        private static readonly Lexer<M> _lexer = new Lexer<M>
        {
            // Constant rules
            { "-->", M.OpArrow1},
            { "=>", M.OpArrow2},
            {":-", M.Arrow},
            {".", M.Dot},
            {"-", M.Minus},
            {"+", M.Plus},
            {",", M.Comma},
            {">", M.GreaterThan},
            {"<", M.LessThan},
            {"/", M.Slash},
            {"\\", M.Backslash},
            {"(", M.ParenOpen},
            {")", M.ParenClose},
            {"[", M.BracketOpen},
            {"]", M.BracketClose},
            {"{", M.BraceOpen},
            {"}", M.BraceClose},
            {"?", M.Question},
            {"=", M.Equals},
            {"%", M.LineComment},
            { "/*", M.MulitLineCommentOpen},
            { "*/", M.MulitLineCommentClose},

            // Function rule
            {
                reader =>
                {
                    return reader.EatWhile(Char.IsDigit);
                },
                M.Number
            },

            {
                reader =>
                {
                    // TODO current position in reader, current list of tokens
                    // TODO: return from this method
                    char c = (char)reader.PeekChar();
                    if (char.IsLetter(c) || c == '_')
                    {
                        return reader.EatWhile(x => Char.IsLetterOrDigit(x) || x == '_');
                    }

                    return false;
                },
                M.Identifier
            },

            // Regex rule
            {new Regex(@"\s"), M.Whitespace}
        }
        .Ignore(M.Whitespace)
        .AddEndToken(M.EOF);

        // Token types
        enum M
        {
            Arrow,
            Dot,
            Minus,
            Plus,
            GreaterThan,
            LessThan,
            Comma,
            Slash,
            Backslash,
            ParenOpen,
            ParenClose,
            BracketOpen,
            BracketClose,
            BraceOpen,
            BraceClose,
            Question,
            Equals,
            LineComment,
            MulitLineCommentOpen,
            MulitLineCommentClose,
            Number,
            Identifier,
            Whitespace,
            OpArrow1,
            OpArrow2,
            EOF
        }

        public class Declaration
        {
            public string Comment { get; set; }
            public int NameOffset { get; set; }
            public string Name { get; set; }
            public List<string> Args { get; set; } = new List<string>();
            public string Operator { get; set; }
            public string Body { get; set; }
        }

        public class Reference
        {
            public Declaration FirstMatch { get; set; }
            public int NameOffset { get; set; }
        }

        public static List<Declaration> ParseDeclarations(string input)
        {
            List<Token<M>> tokens = _lexer.Tokenize(input).ToList();

            List<Declaration> res = new List<Declaration>();
            ParsingHelper helper = new ParsingHelper(input);
            Declaration nextDeclaration = new Declaration();
            int prevIndex = -1;
            start:
            helper.SkipWhiteSpace();
            if (helper.EndOfText)
            {
                return res;
            }

            if (helper == prevIndex)
            {
                throw new InvalidOperationException("Progress staled at " + helper.Text.Insert(prevIndex, "^"));
            }

            prevIndex = helper.Index;

            if (helper.Peek() == '%')
            {
                nextDeclaration.Comment += helper.ParseToNextLine().Substring(1).TrimStart();
                goto start;
            }
            else if (helper.Peek() == '/' && helper.Peek(1) == '*')
            {
                nextDeclaration.Comment = helper.ParseTo("*/", true);
                goto start;
            }

            int lastPos = helper.Index;
            Declaration current = nextDeclaration;
            nextDeclaration = new Declaration();
            current.Name = helper.ParseTo(':', '.', '(', '?', '-', '=', ' ', '\r', '\n', '\t').Trim();
            current.NameOffset = lastPos;
            if (current.Name == "")
            {
                helper++;
                goto start;
            }

            if (char.IsWhiteSpace(helper.Peek()) || helper.Peek() == '(')
            {
                if (current.Name == "module"
                || current.Name == "import")
                {
                    helper.SkipToNextLine();
                    goto start;
                }

                if (current.Name == "private"
                    || current.Name == "index"
                    || current.Name == "table")
                {
                    helper.SkipToNextLine();
                    goto start;
                }
            }

            res.Add(current);

            helper.SkipWhiteSpace();

            if (helper.Peek() == '(')
            {
                current.Args = ExtractArguments(helper);
            }

            helper.SkipWhiteSpace();

            current.Operator = helper.Parse(':', '-', '=', '?', '>').Trim();

            current.Body = helper.ParseWhile(x =>
            {
                return !(x == '.' && helper.Peek(-1) != '.' && (char.IsWhiteSpace(helper.Peek(1)) || helper.Remaining == 1));
            }).Trim();

            helper++;

            goto start;
        }

        private static List<string> ExtractArguments(ParsingHelper helper)
        {
            int lastPos;
            helper++;
            lastPos = helper.Index;
            int nesting = 1;
            List<string> args = new List<string>();
            int prevIndex = -1;
            while (helper.Remaining > 0 && nesting > 0)
            {
                if (helper == prevIndex)
                {
                    throw new InvalidOperationException("Progress staled at " + helper.Text.Insert(prevIndex, "^"));
                }

                prevIndex = helper.Index;

                char cc = helper.Get();
                if (cc == '.' && char.IsWhiteSpace(helper.Peek(1)))
                {
                    helper--;
                    return args;
                }

                if (cc == ')' || cc == ']' || cc == '}')
                {
                    nesting--;
                }
                else if (cc == '(' || cc == '[' || cc == '{')
                {
                    nesting++;
                }

                if (nesting == 0 || (nesting == 1 && cc == ','))
                {
                    string arg = helper.Extract(lastPos, helper.Index - 1).Trim();
                    if (arg != string.Empty)
                    {
                        args.Add(arg);
                        lastPos = helper.Index;
                    }
                }
            }

            return args;
        }

        public static List<Reference> ParseReferences(string input, List<Declaration> declarations)
        {
            List<Reference> res = new List<Reference>();
            IEnumerable<IGrouping<string, Declaration>> byName = declarations.GroupBy(x => x.Name);
            HashSet<int> declarationOffsets = declarations.Select(x => x.NameOffset).ToHashSet();

            ParsingHelper helper = new ParsingHelper(input);
            foreach (IGrouping<string, Declaration> name in byName)
            {
                helper.Index = 0;
                int prevIndex = -1;
                while (!helper.EndOfText)
                {
                    if (helper == prevIndex)
                    {
                        throw new InvalidOperationException("Progress staled at " + helper.Text.Insert(prevIndex, "^"));
                    }

                    prevIndex = helper.Index;

                    if (helper.SkipTo(name.Key))
                    {
                        int offset = helper.Index;
                        if (char.IsLetterOrDigit(helper.Peek(-1)))
                        {
                            helper.ParseCharacters(name.Key.Length);
                            continue;
                        }

                        helper.ParseCharacters(name.Key.Length);

                        if (char.IsLetterOrDigit(helper.Peek()))
                        {
                            continue;
                        }

                        if (declarationOffsets.Contains(offset))
                        {
                            continue;
                        }

                        helper.SkipWhiteSpace();

                        int argsCount = 0;
                        if (helper.Peek() == '(')
                        {
                            argsCount = ExtractArguments(helper).Count;
                        }

                        Declaration target = name.FirstOrDefault(x => x.Args.Count == argsCount);
                        if (target != null)
                        {
                            res.Add(new Reference() { FirstMatch = target, NameOffset = offset });
                        }
                    }
                }
            }

            return res;
        }

        public static Declaration ParseBuiltinDeclaration(string builtin)
        {
            ParsingHelper helper = new ParsingHelper(builtin);

            string name = helper.ParseTo(' ', '(', '=', ':');

            helper.SkipWhiteSpace();

            List<string> args = new List<string>();
            if (helper.Peek() == '(')
            {
                args = ExtractArguments(helper);
            }

            return new Declaration() { NameOffset = -1, Name = name, Args = args };
        }
    }
}
