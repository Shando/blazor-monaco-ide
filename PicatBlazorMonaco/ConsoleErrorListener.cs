﻿using Antlr4.Runtime;

namespace PicatBlazorMonaco
{
    /// <author>Sam Harwell</author>
    public class ConsoleErrorListener<Symbol> : IAntlrErrorListener<Symbol>
    {
        /// <summary>
        /// Provides a default instance of
        /// <see cref="ConsoleErrorListener{Symbol}"/>
        /// .
        /// </summary>
        public static readonly ConsoleErrorListener<Symbol> Instance = new();

        /// <summary>
        /// <inheritDoc/>
        /// <p>
        /// This implementation prints messages to
        /// <see cref="System.Console.Error"/>
        /// containing the
        /// values of
        /// <paramref name="line"/>
        /// ,
        /// <paramref name="charPositionInLine"/>
        /// , and
        /// <paramref name="msg"/>
        /// using
        /// the following format.</p>
        /// <pre>
        /// line <em>line</em>:<em>charPositionInLine</em> <em>msg</em>
        /// </pre>
        /// </summary>
        public virtual void SyntaxError(IRecognizer recognizer, Symbol offendingSymbol, int line, int charPositionInLine, string msg, RecognitionException e)
        {
            System.Console.Error.WriteLine("line " + line + ":" + charPositionInLine + " " + msg);
        }
    }
}