using System;
using System.Collections.Generic;
using Antlr4.Runtime;
using Antlr4.Runtime.Misc;

namespace PicatBlazorMonaco
{
    internal class lexerErrorListener : ConsoleErrorListener<int>
    {
        private List<string> syntaxErrors = new();

        public override void SyntaxError([NotNull] IRecognizer recognizer, [Nullable] int offendingSymbol, int line, int charPositionInLine, [NotNull] string msg, [Nullable] RecognitionException e)
        {
            string myMsg = "Lexer Error at Line: " + line + " - Position: " + charPositionInLine + " - " + msg;
            syntaxErrors.Add(myMsg);
        }

        public List<string> getSyntaxErrors()
        {
            return syntaxErrors;
        }
    }
}