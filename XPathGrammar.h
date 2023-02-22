#ifndef YY_XPATHYY_GENERATED_XPATHGRAMMAR_H_INCLUDED
# define YY_XPATHYY_GENERATED_XPATHGRAMMAR_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int xpathyydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    MULOP = 258,                   /* MULOP  */
    EQOP = 259,                    /* EQOP  */
    RELOP = 260,                   /* RELOP  */
    PLUS = 261,                    /* PLUS  */
    MINUS = 262,                   /* MINUS  */
    OR = 263,                      /* OR  */
    AND = 264,                     /* AND  */
    AXISNAME = 265,                /* AXISNAME  */
    NODETYPE = 266,                /* NODETYPE  */
    PI = 267,                      /* PI  */
    FUNCTIONNAME = 268,            /* FUNCTIONNAME  */
    LITERAL = 269,                 /* LITERAL  */
    VARIABLEREFERENCE = 270,       /* VARIABLEREFERENCE  */
    NUMBER = 271,                  /* NUMBER  */
    DOTDOT = 272,                  /* DOTDOT  */
    SLASHSLASH = 273,              /* SLASHSLASH  */
    NAMETEST = 274,                /* NAMETEST  */
    XPATH_ERROR = 275              /* XPATH_ERROR  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 58 "xml/XPathGrammar.y"

    Step::Axis axis;
    Step::NodeTest* nodeTest;
    NumericOp::Opcode numop;
    EqTestOp::Opcode eqop;
    String* str;
    Expression* expr;
    Vector<Predicate*>* predList;
    Vector<Expression*>* argList;
    Step* step;
    LocationPath* locationPath;

#line 97 "generated/XPathGrammar.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif




int xpathyyparse (WebCore::XPath::Parser* parser);


#endif /* !YY_XPATHYY_GENERATED_XPATHGRAMMAR_H_INCLUDED  */