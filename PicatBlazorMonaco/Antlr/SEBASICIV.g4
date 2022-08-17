grammar SEBASICIV;

prog
    : line+
    ;

line
    : linenum stmtlist? comment? NEWLINE?
    ;

linenum
    : DECIMAL
    ;

comment
    : COMMENT
    ;

COMMENT
    : (REM | APOSTROPHE) ~[\r\n]*
    ;

stmt
    : printusingstmt
    | printhashusingstmt
    | printstmt
    | printhashstmt
    | writestmt
    | writehashstmt
    | letstmt
    | ifstmt
    | forstmt
    | nextstmt
    | gotostmt
    | endstmt
    | deffnstmt
    | dimstmt
    | gosubstmt
    | whilestmt
    | wendstmt
    | openstmt
    | closestmt
    | closehashstmt
    | autostmt
    | bloadstmt
    | bsavestmt
    | callstmt
    | chainstmt
    | chdirstmt
    | clearstmt
    | contstmt
    | copystmt
    | datedlrstmt
    | defsegstmt
    | deletestmt
    | dokestmt
    | editstmt
    | erasestmt
    | errorstmt
    | fieldstmt
    | filesstmt
    | keystmt
    | killstmt
    | loadstmt
    | lockstmt
    | lsetstmt
    | mergestmt
    | mkdirstmt
    | namestmt
    | newstmt
    | noisestmt
    | oldstmt
    | onstmt
    | optionbasestmt
    | outstmt
    | palettestmt
    | pokestmt
    | presetstmt
    | renumstmt
    | resetstmt
    | resumestmt
    | returnstmt
    | rmdirstmt
    | rsetstmt
    | runstmt
    | savestmt
    | seekstmt
    | soundstmt
    | stopstmt
    | strigstmt
    | swapstmt
    | termstmt
    | timedlrstmt
    | timerstmt
    | tracestmt
    | unlockstmt
    | viewstmt
    | waitstmt
    | widthstmt
    | windowstmt
    | putstmt
    | getstmt
    | inputstmt
    | lineinputstmt
    | readstmt
    | datastmt
    | restorestmt
    | randomizestmt
    | middlrstmt
    | screenstmt
    | circlestmt
    | linestmt
    | colorstmt
    | paintstmt
    | psetstmt
    | drawstmt
    | graphicsgetstmt
    | graphicsputstmt
    | drawstrstmt
    | clsstmt
    | beepstmt
    | playstmt
    | liststmt
    | listhashstmt
    | locatestmt
    | comstmt
    | penstmt
    ;

variable
    : leafvariable
    ;

leafvariable
    : varname varsuffix? (LPAREN expr (COMMA expr)* RPAREN)?
    ;

varname
    : {_input.Lt(-1).Text != "DATA"}? VARNAME
    ;

varsuffix
    : DOLLAR | PERCENT | AT | EXCLAMATION | HASH
    ;

expr
    : (PLUS | MINUS)? func      # ExprFunc
    | (PLUS | MINUS)? number    # ExprNumber
    | (PLUS | MINUS)? variable  # ExprVariable
    | LPAREN expr RPAREN        # ExprParen
    | string                    # ExprString
    | expr EXPONENT expr        # ExprExp
    | expr (MUL|FLOAT_DIV) expr # ExprMulDiv
    | expr MOD expr             # ExprMod
    | expr (PLUS|MINUS) expr    # ExprPlusMinus
    | expr (RELEQ|RELNEQ|RELLT|RELGT|RELLE|RELGE) expr # ExprRelational
    | LOGNOT expr               # ExprLogNot
    | expr (LOGAND|LOGOR|LOGXOR) expr    # ExprLogical
    ;

func
    : ABS LPAREN expr RPAREN                                # FuncAbs
    | ASC LPAREN expr RPAREN                                # FuncAsc
    | SIN LPAREN expr RPAREN                                # FuncSin
    | COS LPAREN expr RPAREN                                # FuncCos
    | TAN LPAREN expr RPAREN                                # FuncTan
    | ASIN LPAREN expr RPAREN                               # FuncASin
    | ACOS LPAREN expr RPAREN                               # FuncACos
    | ATAN LPAREN expr RPAREN                               # FuncAtn
    | SQR LPAREN expr RPAREN                                # FuncSqr
    | CHRDLR LPAREN expr RPAREN                             # FuncChrDlr
    | SPACEDLR LPAREN expr RPAREN                           # FuncSpaceDlr
    | STRDLR LPAREN expr RPAREN                             # FuncStrDlr
    | VAL LPAREN expr RPAREN                                # FuncVal
    | VALDLR LPAREN expr RPAREN                             # FuncValDlr
    | INT LPAREN expr RPAREN                                # FuncInt
    | FIX LPAREN expr RPAREN                                # FuncFix
    | LOG LPAREN expr RPAREN                                # FuncLog
    | EXP LPAREN expr RPAREN                                # FuncExp
    | LEN LPAREN expr (COMMA axis=expr)? RPAREN             # FuncLen
    | RIGHTDLR LPAREN expr COMMA expr RPAREN                # FuncRightDlr
    | LEFTDLR LPAREN expr COMMA expr RPAREN                 # FuncLeftDlr
    | MIDDLR LPAREN expr COMMA expr (COMMA expr)? RPAREN    # FuncMidDlr
    | INSTR LPAREN expr COMMA expr (COMMA expr)? RPAREN     # FuncInstr
    | RND LPAREN expr RPAREN                                # FuncRnd
    | SGN LPAREN expr RPAREN                                # FuncSgn
    | STRINGDLR LPAREN expr COMMA expr RPAREN               # FuncStringDlr
    | INPUTDLR LPAREN expr (COMMA HASH? expr)? RPAREN       # FuncInputDlr
    | INKEYDLR (HASH filenum=expr)?                         # FuncInkeyDlr
    | CSRLIN                                                # FuncCSRLin
    | DATEDLR                                               # FuncDateDlr
    | DEEK LPAREN expr RPAREN                               # FuncDeek
    | EOFI LPAREN expr RPAREN                               # FuncEof
    | ERL                                                   # FuncEol
    | ERR                                                   # FuncErr
    | FN SPACE varname varsuffix? (LPAREN (variable (COMMA variable)*)? RPAREN)?    # FuncFN
    | FRE LPAREN expr RPAREN                                # FuncFre
    | INP LPAREN expr RPAREN                                # FuncInp
    | LOC LPAREN expr RPAREN                                # FuncLoc
    | LOF LPAREN expr RPAREN                                # FuncLof
    | MOUSE LPAREN RPAREN                                   # FuncMouse
    | NMI                                                   # FuncNMI
    | PEEK LPAREN expr RPAREN                               # FuncPeek
    | PMAP LPAREN expr COMMA expr RPAREN                    # FuncPmap
    | POINT LPAREN ( expr | expr COMMA expr) RPAREN         # FuncPoint
    | POS LPAREN expr RPAREN                                # FuncPos
    | PI                                                    # FuncPi
    | SCREEN LPAREN expr COMMA expr (COMMA expr)? RPAREN    # FuncScreen
    | STICK LPAREN expr RPAREN                              # FuncStick
    | STRIG LPAREN expr RPAREN                              # FuncStrig
    | TIMEDLR                                               # FuncTimeDlr
    | TIMER                                                 # FuncTimer
    | USR                                                   # FuncUsr
    | VARPTR LPAREN (expr | HASH expr) RPAREN               # FuncVarPtr
    | VARPTRDLR LPAREN expr RPAREN                          # FuncVarPtrDlr
    | PEN LPAREN expr RPAREN                                # FuncPen
    ;

gosubstmt
    : (GOSUB | GOSUB1) linenum
    ;

printhashusingstmt
    : PRINTHASH filenum=expr COMMA printlist USING format=expr SEMICOLON printlist
    ;

printusingstmt
    : PRINT printlist USING format=expr SEMICOLON printlist
    ;

printhashstmt
    : PRINTHASH filenum=expr COMMA printlist
    ;

printstmt
    : (QUESTION | PRINT) printlist?
    ;

printlist
    : expr? (COMMA | SEMICOLON | SPC LPAREN expr RPAREN | TABN LPAREN expr RPAREN | expr )*
    ;

writestmt
    : WRITE (expr (COMMA expr)*)?
    ;

writehashstmt
    : WRITEHASH expr COMMA expr (COMMA expr)*
    ;

letstmt
    : LET? variable RELEQ expr
    ;

ifstmt
    : IF expr then (ELSE elsestmt)?  # IfThenElse
    ;

then
    : (THEN (linenum | stmtlist)) | (GOTO linenum)
    ;

elsestmt
    : linenum | stmtlist
    ;

stmtlist
    : stmt (COLON (stmt | comment))*
    ;

forstmt
    : FOR variable RELEQ expr TO expr (STEP expr)?
    ;

nextstmt
    : NEXT variable? (COMMA variable)*
    ;

gotostmt
    : GOTO linenum
    ;

endstmt
    : END
    ;

deffnstmt
    : (DEF1 | DEF2) varname varsuffix? (LPAREN (variable (COMMA variable)*)? RPAREN)? RELEQ expr
    ;

dimstmt
    : DIM varname varsuffix? (LPAREN | LSQUARE) expr (COMMA expr)* (RPAREN | RSQUARE)
    ;

whilestmt
    : WHILE expr
    ;

wendstmt
    : WEND
    ;

openstmt
    : OPENHASH expr COMMA STRING (COMMA expr)?
    ;

closestmt
    : CLOSE (HASH? expr (COMMA HASH? expr)*)?
    ;

closehashstmt
    : CLOSEHASH expr (COMMA HASH expr)*
    ;

autostmt
    : AUTO (expr (COMMA expr)?)?
    ;

bloadstmt
    : BLOAD expr COMMA (expr)?
    ;

bsavestmt
    : BSAVE expr COMMA (expr)?
    ;

callstmt
    : CALL expr (COMMA expr)*
    ;

chainstmt
    : CHAIN MERGE? expr (COMMA expr (COMMA expr (COMMA DELETE expr)?)?)?
    ;

chdirstmt
    : CHDIR expr
    ;

clearstmt
    : CLEAR (expr)?
    ;

contstmt
    : CONT
    ;

copystmt
    : COPY expr TO expr
    ;

datedlrstmt
    : DATEDLR RELEQ expr
    ;

defsegstmt
    : DEF1 SEG (RELEQ expr)?
    ;

deletestmt
    : DELETE (expr | DOT)? (expr | DOT)?
    ;

dokestmt
    : DOKE expr COMMA expr
    ;

editstmt
    : EDIT (expr | DOT)
    ;

erasestmt
    : ERASE expr (COMMA expr)*
    ;

errorstmt
    : ERROR expr
    ;

fieldstmt
    : FIELD HASH? expr COMMA expr AS variable (COMMA expr AS variable)*
    ;

filesstmt
    : FILES expr?
    ;

keystmt
    : KEY (expr COMMA expr | (ON | OFF))
    ;

killstmt
    : KILL expr
    ;

loadstmt
    : LOAD expr (COMMA (LETTER))?
    ;

lockstmt
    : LOCK HASH? expr (COMMA (expr | expr TO expr)?)?
    ;

lsetstmt
    : LSET expr RELEQ expr
    ;

mergestmt
    : MERGE expr
    ;

mkdirstmt
    : MKDIR expr
    ;

namestmt
    : NAME expr TO expr
    ;

newstmt
    : NEW
    ;

noisestmt
    : NOISE
    ;

oldstmt
    : OLD
    ;

onstmt
    : ON expr (GOTO | GOSUB) expr (COMMA expr)*
    ;

optionbasestmt
    : OPTION BASE DECIMAL
    ;

outstmt
    : OUT expr COMMA expr
    ;

palettestmt
    : PALETTE (expr COMMA expr)?
    ;

pokestmt
    : POKE expr COMMA expr
    ;

presetstmt
    : PRESET LPAREN expr COMMA expr RPAREN (COMMA expr)?
    ;

renumstmt
    : RENUM (expr | DOT) (COMMA (expr | DOT))? (COMMA expr)?
    ;

resetstmt
    : RESET
    ;

resumestmt
    : RESUME (NEXT | expr)?
    ;

returnstmt
    : RETURN (expr)?
    ;

rmdirstmt
    : RMDIR expr
    ;

rsetstmt
    : RSET expr RELEQ expr
    ;

runstmt
    : RUN (expr | expr (COMMA expr)*)?
    ;

savestmt
    : SAVE expr (COMMA LETTER)?
    ;

seekstmt
    : SEEKHASH expr COMMA expr
    ;

soundstmt
    : SOUND
    ;

stopstmt
    : STOP
    ;

strigstmt
    : STRIG (ON | OFF)
    ;

swapstmt
    : SWAP variable COMMA variable
    ;

termstmt
    : TERM
    ;

timedlrstmt
    : TIMEDLR RELEQ expr
    ;

timerstmt
    : TIMER expr
    ;

tracestmt
    : TRACE (ON | OFF)
    ;

unlockstmt
    : UNLOCK HASH? expr (COMMA (expr | expr TO expr)?)?
    ;

viewstmt
    : VIEW ((SCREEN)? (LPAREN expr COMMA expr RPAREN MINUS LPAREN expr COMMA expr RPAREN (COMMA expr (COMMA expr)?)?)?)?
    ;

waitstmt
    : WAIT expr
    ;

widthstmt
    : WIDTH expr COMMA expr
    ;

windowstmt
    : WINDOW (SCREEN? LPAREN expr COMMA expr RPAREN MINUS LPAREN expr COMMA expr RPAREN)?
    ;
putstmt
    : PUT HASH? filenum=DECIMAL (COMMA expr)?
    ;

getstmt
    : GET HASH? filenum=DECIMAL (COMMA expr)?
    ;

inputstmt
    : INPUT SEMICOLON? (STRING (SEMICOLON | COMMA))? variable (COMMA variable)*
    ;

lineinputstmt
    : LINE INPUT SEMICOLON? (expr SEMICOLON)? variable
    ;

readstmt
    : READ variable (COMMA variable)*
    ;

datastmt
   : DATA datum (COMMA datum?)*
   ;

datum
   : (number | STRING)
   ;

restorestmt
    : RESTORE (linenum)?
    ;

randomizestmt
    : RANDOMIZE (expr)?
    ;

middlrstmt
    : MIDDLR LPAREN variable COMMA expr (COMMA expr)? RPAREN
    ;

screenstmt
    : SCREEN (expr (COMMA expr ( COMMA expr (COMMA expr (COMMA expr)?)?)?)?)?
    ;

circlestmt
    : CIRCLE LPAREN expr COMMA expr RPAREN COMMA expr (COMMA expr (COMMA expr COMMA expr (COMMA expr)?)?)?
    ;

linestmt
    : LINE (LPAREN expr COMMA expr RPAREN MINUS LPAREN expr COMMA expr RPAREN (COMMA expr (COMMA expr (COMMA expr)?)?)?)?
    ;

colorstmt
    : COLOR f=expr COMMA b=expr COMMA o=expr
    ;

paintstmt
    : PAINT LPAREN expr COMMA expr RPAREN (COMMA expr (COMMA expr (COMMA expr)?)?)?
    ;

psetstmt
    : PSET LPAREN expr COMMA expr RPAREN (COMMA expr COMMA expr COMMA expr)?
    ;

drawstmt
    : DRAW expr
    ;

graphicsgetstmt
    : GET LPAREN expr COMMA expr RPAREN MINUS LPAREN expr COMMA expr RPAREN COMMA expr
    ;

graphicsputstmt
    : PUT LPAREN expr COMMA expr RPAREN COMMA expr (COMMA expr)?
    ;

drawstrstmt
    : DRAWSTR expr
    ;

clsstmt
    : CLS expr?
    ;

beepstmt
    : BEEP
    ;

playstmt
    : PLAY expr
    ;

liststmt
    : LIST (expr SEMICOLON)? (expr (COMMA expr)?)?
    ;

listhashstmt
    : LIST (HASH expr SEMICOLON)? (expr (COMMA expr)?)?
    ;

locatestmt
    : LOCATE (expr (COMMA expr (COMMA expr (COMMA expr (COMMA expr)?)?)?)?)?
    ;

comstmt
    : COM LPAREN expr RPAREN (ON | OFF | STOP)
    ;

penstmt
    : PEN (ON | OFF | STOP)
    ;

LIST
    : (L I S T | L I DOT)
    ;

EQGT
    : '=' '>'
    ;

DEFAULT
    : D E F A U L T
    ;

LETTERRANGE
    : LETTER MINUS LETTER
    ;

LET
    : L E T
    ;

PRINT
    : (P R I N T | P DOT)
    ;

PRINTHASH
    : P R I N T HASH
    ;

USING
    : (U S I N G | U S I DOT)
    ;

IF
    : I F
    ;

THEN
    : (T H E N | T H DOT)
    ;

ELSE
    : (E L S E | E L DOT)
    ;

GOTO
    : (G O T O | G DOT)
    ;

FOR
    : (F O R | F DOT)
    ;

NEXT
    : N E X T
    ;

TO
    : T O
    ;

STEP
    : S T E P
    ;

REM
    : (R E M | R DOT)
    ;

FUNCTION
    : F U N C T I O N
    ;

FN
    : F N
    ;

SIN
    : S I N
    ;

COS
    : C O S
    ;

TAN
    : T A N
    ;

ATAN
    : (A T A N | A T DOT)
    ;

SQR
    : S Q R
    ;

ABS
    : A B S
    ;

ASC
    : A S C
    ;

SEG
    : S E G
    ;

DEF1
    : ('DEF FN' | D E F DOT)
    ;

DEF2
    : ('DEF FN ' | 'DEF. ')
    ;

DIM
    : D I M
    ;

GOSUB
    : (G O S U B | G O S DOT)
    ;

GOSUB1
    : G O SPACE S U B
    ;

CHRDLR
    : C H R DOLLAR
    ;

WHILE
    : (W H I L E | W DOT)
    ;

WEND
    : (W END | W E DOT)
    ;

END
    : E N D
    ;

SPACEDLR
    : S P A C E DOLLAR
    ;

STRDLR
    : S T R DOLLAR
    ;

VALDLR
    : (V A L DOLLAR | V DOT)
    ;

VAL
    : V A L
    ;

INT
    : I N T
    ;

FIX
    : F I X
    ;

LOG
    : L O G
    ;

LEN
    : L E N
    ;

RIGHTDLR
    : (R I G H T DOLLAR | R I DOT)
    ;

LEFTDLR
    : (L E F T DOLLAR | L E F DOT)
    ;

MIDDLR
    : (M I D DOLLAR | M I DOT)
    ;

INSTR
    : (I N S T R | I N S DOT)
    ;
RND
    : R N D
    ;

SGN
    : S G N
    ;

STRINGDLR
    : (S T R I N G DOLLAR | S T R DOT)
    ;

OPENHASH
    : (O P E N HASH | O P DOT)
    ;

LOCATE
    : (L O C A T E | L DOT)
    ;

COM
    : C O M
    ;

PEN
    : P E N
    ;

CLOSE
    : C L O S E
    ;

CLOSEHASH
    : (CLOSE HASH | C L O DOT)
    ;

AUTO
    : A U T O
    ;

BLOAD
    : (B L O A D | B L DOT)
    ;

BSAVE
    : (B S A V E | B DOT)
    ;

CALL
    : (C A L L | C A DOT)
    ;

CHAIN
    : C H A I N
    ;

CHDIR
    : (C H D I R | C H DOT)
    ;

CLEAR
    : (C L E A R | C L E DOT)
    ;

CONT
    : C O N T
    ;

ON
    : O N
    ;

OFF
    : O F F
    ;

COPY
    : (C O P Y | C DOT)
    ;

CSRLIN
    : C S R L I N
    ;

DATEDLR
    : D A T E DOLLAR
    ;

DELETE
    : (D E L E T E | D E DOT)
    ;

DOKE
    : (D O K E | D DOT)
    ;

EDIT
    : (E D I T | E D DOT)
    ;

ERASE
    : E R A S E
    ;

ERR
    : E R R
    ;

ERROR
    : (ERR O R | E DOT)
    ;

FIELD
    : F I E L D
    ;

FILES
    : (F I L E S | F I DOT)
    ;

KEY
    : K E Y
    ;

KILL
    : (K I L L | K DOT)
    ;

LOAD
    : L O A D
    ;

LOCK
    : L O C K
    ;

LOC
    : L O C
    ;

LSET
    : L S E T
    ;

MERGE
    : (M E R G E | M E DOT)
    ;

MKDIR
    : (M K D I R | M DOT)
    ;

NAME
    : (N A M E | N AT)
    ;

NEW
    : (N E W | N DOT)
    ;

NOISE
    : N O I S E
    ;

OLD
    : O L D
    ;

OPTION
    : O P T I O N
    ;

BASE
    : B A S E
    ;

PALETTE
    : (P A L E T T E | P A DOT)
    ;

POKE
    : (P O K E | P O DOT)
    ;

RESET
    : R E S E T
    ;

PRESET
    : P R E S E T
    ;

RENUM
    : (R E N U M | R E DOT)
    ;

RESUME
    : R E S U M E
    ;

RETURN
    : (R E T U R N | R E T DOT)
    ;

RMDIR
    : (R M D I R | R M DOT)
    ;

RSET
    : R S E T
    ;

RUN
    : R U N
    ;

SAVE
    : (S A V E | S A DOT)
    ;

SEEKHASH
    : (S E E K HASH | S E DOT)
    ;

SOUND
    : (S O U N D | S O DOT)
    ;

STOP
    : (S T O P | S DOT)
    ;

STRIG
    : S T R I G
    ;

SWAP
    : S W A P
    ;

TERM
    : T E R M
    ;

TIMEDLR
    : T I M E DOLLAR
    ;

TIMER
    : T I M E R
    ;

TRACE
    : (T R A C E | T DOT)
    ;

UNLOCK
    : U N L O C K
    ;

VARPTR
    : V A R P T R
    ;

VARPTRDLR
    : VARPTR DOLLAR
    ;

VIEW
    : V I E W
    ;

WAIT
    : (W A I T | W A DOT)
    ;

WIDTH
    : W I D T H
    ;

WINDOW
    : W I N D O W
    ;

AS
    : A S
    ;

LINE
    : L I N E
    ;

INPUT
    : (I N P U T | I DOT)
    ;

INPUTDLR
    : I N P U T DOLLAR
    ;

INP
    : I N P
    ;

OUTPUT
    : O U T P U T
    ;

OUT
    : (O U T | O DOT)
    ;

APPEND
    : A P P E N D
    ;

RANDOM
    : R A N D O M
    ;

RANDOMIZE
    : (R A N D O M I Z E | R A DOT)
    ;

READ
    : R E A D
    ;

WRITE
    : W R I T E
    ;

WRITEHASH
    : W R I T E HASH
    ;

SHARED
    : S H A R E D
    ;

PUT
    : P U T
    ;

GET
    : G E T
    ;

DATA
    : (D A T A | D A DOT)
    ;

RESTORE
    : (R E S T O R E | R E S DOT)
    ;

SCREEN
    : (S C R E E N | S C DOT)
    ;

CIRCLE
    : C I R C L E
    ;

COLOR
    : (C O L O R | C O L DOT)
    ;

INKEYDLR
    : (I N K E Y DOLLAR | I N K DOT)
    ;

DEEK
    : D E E K
    ;

EOFI
    : (E O F | E O DOT)
    ;

ERL
    : E R L
    ;

FRE
    : F R E
    ;

LOF
    : L O F
    ;

MOUSE
    : M O U S E
    ;

NMI
    : N M I
    ;

USR
    : (U S R | U DOT)
    ;

PEEK
    : (P E E K | P E DOT)
    ;

PI
    : P I
    ;

PMAP
    : P M A P
    ;

POINT
    : P O I N T
    ;

POS
    : P O S
    ;

STICK
    : S T I C K
    ;

PAINT
    : P A I N T
    ;

PSET
    : P S E T
    ;

DRAW
    : D R A W
    ;

DRAWSTR
    : D R A W S T R
    ;

PLAY
    : P L A Y
    ;

CLS
    : C L S
    ;

BEEP
    : B E E P
    ;

ASIN
    : (A S I N | A S DOT)
    ;

ACOS
    : (A C O S | A C DOT)
    ;

EXP
    : E X P
    ;

string
    : STRING
    ;

STRING
    : '"' ~["\r\n]* '"'
    ;

COMMA
    : ','
    ;

SEMICOLON
    : ';'
    ;

COLON
    : ':'
    ;

QUESTION
    : '?'
    ;

AT
    : '@'
    ;

DOLLAR
    : '$'
    ;

PERCENT
    : '%'
    ;

EXCLAMATION
    : '!'
    ;

HASH
    : '#'
    ;

APOSTROPHE
    : '\''
    ;

QUOTE
    : '"'
    ;

TILDE
    : '~'
    ;

AMPERSAND
    : '&'
    ;

PIPE
    : '|'
    ;

EXPONENT
    : '^'
    ;

FLOAT_DIV
    : '/'
    ;

MUL
    : '*'
    ;

LPAREN
    : '('
    ;

RPAREN
    : ')'
    ;

LBRACE
    : '{'
    ;

RBRACE
    : '}'
    ;

LSQUARE
    : '['
    ;

RSQUARE
    : ']'
    ;

MOD
    : M O D
    ;

RELEQ
    : '='
    ;

RELNEQ
    : '<>'
    ;

RELGT
    : '>'
    ;

RELGE
    : '>='
    ;

RELLT
    : '<'
    ;

RELLE
    : '<='
    ;

LOGAND
    : (A N D | AMPERSAND | A DOT)
    ;

LOGOR
    : (O R | PIPE)
    ;

LOGNOT
    : (N O T | TILDE)
    ;

LOGXOR
    : (X O R | X DOT)
    ;

SPC
    : S P C
    ;

TABN
    : T A B
    ;

VARNAME
    : LETTER (LETTER | DECIMAL)*
    ;

LETTER
    : [A-Z]
    ;

number
    : (ENUMBER  | FLOAT | integer)
    ;

integer
    : (DOLLAR | AT | PERCENT)? (DECIMAL | HEXADECIMAL | OCTAL | BINARY)
    ;

PLUS
    : '+'
    ;

MINUS
    : '-'
    ;

DECIMAL
    : DIGIT+
    ;

HEXADECIMAL
    : DOLLAR DECIMAL
    ;

OCTAL
    : AT DECIMAL
    ;

BINARY
    : PERCENT DECIMAL
    ;

ENUMBER
    : PLUSMINUS? (DIGIT | FLOAT) ('E') PLUSMINUS? (DIGIT | FLOAT)+
    ;

FLOAT
   : (DIGIT* DOT DIGIT* | DIGIT* DOT DIGIT*)
   ;

PLUSMINUS
    : (PLUS | MINUS)
    ;

DOT
    : '.'
    ;

fragment DIGIT : [0-9] ;

fragment A : 'A' ;
fragment B : 'B' ;
fragment C : 'C' ;
fragment D : 'D' ;
fragment E : 'E' ;
fragment F : 'F' ;
fragment G : 'G' ;
fragment H : 'H' ;
fragment I : 'I' ;
fragment J : 'J' ;
fragment K : 'K' ;
fragment L : 'L' ;
fragment M : 'M' ;
fragment N : 'N' ;
fragment O : 'O' ;
fragment P : 'P' ;
fragment Q : 'Q' ;
fragment R : 'R' ;
fragment S : 'S' ;
fragment T : 'T' ;
fragment U : 'U' ;
fragment V : 'V' ;
fragment W : 'W' ;
fragment X : 'X' ;
fragment Y : 'Y' ;
fragment Z : 'Z' ;

NEWLINE
    : '\r'? '\n'
    ;

WS
    : (SPACE | TAB)+ -> channel(HIDDEN);

SPACE
    : ' '
    ;

TAB
    : '\t'
    ;
