using System;

namespace PicatBlazorMonaco
{
    [Serializable]
    public class SyntaxErr : Exception
    {
        public SyntaxErr() : base() { }
        public SyntaxErr(string message) : base(message) { }
        public SyntaxErr(string message, Exception inner) : base(message, inner) { }

        protected SyntaxErr(System.Runtime.Serialization.SerializationInfo info,
            System.Runtime.Serialization.StreamingContext context) : base(info, context) { }
    }
}

