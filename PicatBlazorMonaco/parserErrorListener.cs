using Antlr4.Runtime;
using Antlr4.Runtime.Misc;
using System.Collections.Generic;

namespace PicatBlazorMonaco
{
    internal class parserErrorListener : IAntlrErrorListener<IToken>
    {
        private List<string> syntaxErrors = new();

        public void SyntaxError([NotNull] IRecognizer recognizer, [Nullable] IToken offendingSymbol, int line, int charPositionInLine, [NotNull] string msg, [Nullable] RecognitionException e)
        {
            string myMsg = "Parser Error at Line: " + line + " - Position: " + charPositionInLine + " - " + msg;
            syntaxErrors.Add(myMsg);
        }

        public List<string> getSyntaxErrors()
        {
            return syntaxErrors;
        }
    }
}
