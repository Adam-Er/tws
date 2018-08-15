%{
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <DLists.h>
#include <Tokenizer.h>
#include <Trees.h>

extern TREENODE *root;
typedef struct {
    DNODE mynode;
    TREENODE *nodeptr;
} T_NODE;

%}
%union {
   TOKEN_INFO info;
   DLIST dlist;
}
%token <info>  NEQ
%token <info>  END
%token <info>  STR
%token <info>  EOFF
%token <info>  TO
%token <info>  VAR
%token <info>  IDENTIFIER
%token <info>  CHR
%token <info>  POOL
%token <info>  CHAR_NUM
%token <info>  IF
%token <info>  FUNCTION
%token <info>  READ
%token <info>  REPEAT
%token <info>  ELSE
%token <info>  RETURN
%token <info>  RANGE
%token <info>  UNTIL
%token <info>  SWAP
%token <info>  FOR
%token <info>  THEN
%token <info>  OF
%token <info>  MOD
%token <info>  GT
%token <info>  CASE
%token <info>  WHILE
%token <info>  OUTPUT
%token <info>  EXIT
%token <info>  PROCEDURE
%token <info>  CONST
%token <info>  LE
%token <info>  PRED
%token <info>  NOT
%token <info>  DO
%token <info>  BEGINX
%token <info>  ORD
%token <info>  INTEGER_NUM
%token <info>  AND
%token <info>  EXP
%token <info>  LOOP
%token <info>  SUCC
%token <info>  GE
%token <info>  TYPE
%token <info>  OR
%token <info>  LT
%token <info>  OTHERWISE
%token <info>  ASSIGNMENT
%token <info>  PROGRAM
%token <info>  DOWNTO
%type <dlist> Statement_1_1_1_1_1_1_1_1
%type <dlist> Const
%type <dlist> Statement_1_1
%type <dlist> Statement_1_1_1_1_1
%type <dlist> Params_1
%type <dlist> Lit_1
%type <dlist> Consts_1
%type <dlist> Otherwise_1_1
%type <dlist> Var
%type <dlist> Statement_1_1_1_1_1_1_1_1_1_1
%type <dlist> Vals
%type <dlist> Params_1_1_1
%type <dlist> Types_1
%type <dlist> Params
%type <dlist> Primary_1
%type <dlist> Unary
%type <dlist> Factor
%type <dlist> Statement_1_1_1
%type <dlist> Vals_1
%type <dlist> Types
%type <dlist> Tiny
%type <dlist> Statement_1
%type <dlist> Body_1
%type <dlist> Consts
%type <dlist> Statement
%type <dlist> Params_1_1
%type <dlist> Procs
%type <dlist> Term
%type <dlist> Switch
%type <dlist> Name
%type <dlist> Super
%type <dlist> Otherwise
%type <dlist> Body
%type <dlist> Dclns_1
%type <dlist> Lit
%type <dlist> Statement_1_1_1_1_1_1
%type <dlist> SubProgs_1
%type <dlist> Primary_1_1
%type <dlist> Statement_1_1_1_1
%type <dlist> Otherwise_1
%type <dlist> Type
%type <dlist> Expression
%type <dlist> Statement_1_1_1_1_1_1_1_1_1
%type <dlist> Dclns
%type <dlist> Primary
%type <dlist> Statement_1_1_1_1_1_1_1
%type <dlist> SubProgs
%type <dlist> Var_1
%%

Tiny     : PROGRAM  Name     ':'      Consts   Types    Dclns    SubProgs Body     Name     '.'      
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		while (DCount(&$4) > 0)
		    DAddTail(&r,DRemHead(&$4));

		while (DCount(&$5) > 0)
		    DAddTail(&r,DRemHead(&$5));

		while (DCount(&$6) > 0)
		    DAddTail(&r,DRemHead(&$6));

		while (DCount(&$7) > 0)
		    DAddTail(&r,DRemHead(&$7));

		while (DCount(&$8) > 0)
		    DAddTail(&r,DRemHead(&$8));

		while (DCount(&$9) > 0)
		    DAddTail(&r,DRemHead(&$9));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"program",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		t->mynode = *(DHead(&r));
		root = t->nodeptr;

             }
         ;

Consts   : CONST    Consts_1 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"consts",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"consts",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Consts_1 : Const    ';'      
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         | Const    ';'      Consts_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		$$ = r;

             }
         ;

Const    : Name     '='      Expression 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"const",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Types    : TYPE     Types_1  
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"types",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"types",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Types_1  : 
             {
		DLIST r;

		InitDList(&r);

		$$ = r;

             }
         | Type     ';'      Types_1  
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		$$ = r;

             }
         ;

Type     : Name     '='      Name     
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"type",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Name     '='      Lit      
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"type",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Lit      : '('      Lit_1    
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"lit",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Lit_1    : Name     ')'      
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         | Name     ','      Lit_1    
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		$$ = r;

             }
         ;

Dclns    : VAR      Dclns_1  
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"dclns",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"dclns",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Dclns_1  : 
             {
		DLIST r;

		InitDList(&r);

		$$ = r;

             }
         | Var      ';'      Dclns_1  
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		$$ = r;

             }
         ;

Var      : Var_1    
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"var",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Var_1    : Name     ':'      Name     
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		$$ = r;

             }
         | Name     ','      Var_1    
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		$$ = r;

             }
         ;

SubProgs : SubProgs_1 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"subprogs",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

SubProgs_1 : 
             {
		DLIST r;

		InitDList(&r);

		$$ = r;

             }
         | Procs    SubProgs_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		$$ = r;

             }
         ;

Procs    : FUNCTION Name     Params   ':'      Name     ';'      Consts   Types    Dclns    Body     Name     ';'      
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		while (DCount(&$5) > 0)
		    DAddTail(&r,DRemHead(&$5));

		while (DCount(&$7) > 0)
		    DAddTail(&r,DRemHead(&$7));

		while (DCount(&$8) > 0)
		    DAddTail(&r,DRemHead(&$8));

		while (DCount(&$9) > 0)
		    DAddTail(&r,DRemHead(&$9));

		while (DCount(&$10) > 0)
		    DAddTail(&r,DRemHead(&$10));

		while (DCount(&$11) > 0)
		    DAddTail(&r,DRemHead(&$11));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"fnc",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | PROCEDURE Name     Params   ';'      Consts   Types    Dclns    Body     Name     ';'      
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		while (DCount(&$5) > 0)
		    DAddTail(&r,DRemHead(&$5));

		while (DCount(&$6) > 0)
		    DAddTail(&r,DRemHead(&$6));

		while (DCount(&$7) > 0)
		    DAddTail(&r,DRemHead(&$7));

		while (DCount(&$8) > 0)
		    DAddTail(&r,DRemHead(&$8));

		while (DCount(&$9) > 0)
		    DAddTail(&r,DRemHead(&$9));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"proc",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Params   : Params_1 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"params",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Params_1 : 
             {
		DLIST r;

		InitDList(&r);

		$$ = r;

             }
         | '('      Params_1_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		$$ = r;

             }
         ;

Params_1_1 : ')'      
             {
		DLIST r;

		InitDList(&r);

		$$ = r;

             }
         | Params_1_1_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         ;

Params_1_1_1 : Var      ')'      
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         | Var      ';'      Params_1_1_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		$$ = r;

             }
         ;

Body     : BEGINX   Body_1   
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"block",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Body_1   : Statement END      
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		if ($2.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$2.string,
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		$$ = r;

             }
         | Statement ';'      Body_1   
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		$$ = r;

             }
         ;

Switch   : Vals     ':'      Statement ';'      
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"switch",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Vals     : Primary  Vals_1   
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"range",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Vals_1   : 
             {
		DLIST r;

		InitDList(&r);

		$$ = r;

             }
         | RANGE    Primary  
             {
		DLIST r;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		$$ = r;

             }
         ;

Statement : Name     ASSIGNMENT Expression 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		if ($2.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$2.string,
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"assign",
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | OUTPUT   '('      Statement_1 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"output",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | IF       Expression THEN     Statement Statement_1_1 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		if ($3.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$3.string,
		                                TREETAG_LINE,$3.line,
		                                TREETAG_COLUMN,$3.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$4) > 0)
		    DAddTail(&r,DRemHead(&$4));

		while (DCount(&$5) > 0)
		    DAddTail(&r,DRemHead(&$5));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"if",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | WHILE    Expression DO       Statement 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		if ($3.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$3.string,
		                                TREETAG_LINE,$3.line,
		                                TREETAG_COLUMN,$3.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$4) > 0)
		    DAddTail(&r,DRemHead(&$4));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"while",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | FOR      Name     ASSIGNMENT Expression TO       Expression DO       Statement 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		if ($3.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$3.string,
		                                TREETAG_LINE,$3.line,
		                                TREETAG_COLUMN,$3.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$4) > 0)
		    DAddTail(&r,DRemHead(&$4));

		if ($5.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$5.string,
		                                TREETAG_LINE,$5.line,
		                                TREETAG_COLUMN,$5.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$6) > 0)
		    DAddTail(&r,DRemHead(&$6));

		if ($7.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$7.string,
		                                TREETAG_LINE,$7.line,
		                                TREETAG_COLUMN,$7.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$8) > 0)
		    DAddTail(&r,DRemHead(&$8));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"upfor",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | FOR      Name     ASSIGNMENT Expression DOWNTO   Expression DO       Statement 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		if ($3.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$3.string,
		                                TREETAG_LINE,$3.line,
		                                TREETAG_COLUMN,$3.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$4) > 0)
		    DAddTail(&r,DRemHead(&$4));

		if ($5.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$5.string,
		                                TREETAG_LINE,$5.line,
		                                TREETAG_COLUMN,$5.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$6) > 0)
		    DAddTail(&r,DRemHead(&$6));

		if ($7.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$7.string,
		                                TREETAG_LINE,$7.line,
		                                TREETAG_COLUMN,$7.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$8) > 0)
		    DAddTail(&r,DRemHead(&$8));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"downfor",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | REPEAT   Statement Statement_1_1_1 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"repeat",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | LOOP     Statement_1_1_1_1 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"loop",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | CASE     Expression OF       Statement_1_1_1_1_1 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		if ($3.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$3.string,
		                                TREETAG_LINE,$3.line,
		                                TREETAG_COLUMN,$3.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$4) > 0)
		    DAddTail(&r,DRemHead(&$4));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"case",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Primary  SWAP     Primary  
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		if ($2.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$2.string,
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"swap",
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | EXIT     
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"exit",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | READ     '('      Statement_1_1_1_1_1_1 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"read",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Body     
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         | Switch   
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         | Name     '('      Statement_1_1_1_1_1_1_1 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"call",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | RETURN   Statement_1_1_1_1_1_1_1_1 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"return",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"<null>",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Statement_1_1_1_1_1_1_1_1 : 
             {
		DLIST r;

		InitDList(&r);

		$$ = r;

             }
         | Expression 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         ;

Statement_1_1_1_1_1_1_1 : ')'      
             {
		DLIST r;

		InitDList(&r);

		$$ = r;

             }
         | Statement_1_1_1_1_1_1_1_1_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         ;

Statement_1_1_1_1_1_1_1_1_1 : Expression ')'      
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         | Expression ','      Statement_1_1_1_1_1_1_1_1_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		$$ = r;

             }
         ;

Statement_1_1_1_1_1_1 : Name     ')'      
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         | Name     ','      Statement_1_1_1_1_1_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		$$ = r;

             }
         ;

Statement_1_1_1_1_1 : Statement_1_1_1_1_1_1_1_1_1_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         | Switch   Statement_1_1_1_1_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		$$ = r;

             }
         ;

Statement_1_1_1_1_1_1_1_1_1_1 : END      
             {
		DLIST r;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		$$ = r;

             }
         | Otherwise END      
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		if ($2.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$2.string,
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		$$ = r;

             }
         ;

Statement_1_1_1_1 : Statement POOL     
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		if ($2.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$2.string,
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		$$ = r;

             }
         | Statement ';'      Statement_1_1_1_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		$$ = r;

             }
         ;

Statement_1_1_1 : UNTIL    Expression 
             {
		DLIST r;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		$$ = r;

             }
         | ';'      Statement Statement_1_1_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		$$ = r;

             }
         ;

Statement_1_1 : 
             {
		DLIST r;

		InitDList(&r);

		$$ = r;

             }
         | ELSE     Statement 
             {
		DLIST r;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		$$ = r;

             }
         ;

Statement_1 : Expression ')'      
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         | Expression ','      Statement_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		$$ = r;

             }
         ;

Otherwise : OTHERWISE Otherwise_1 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"otherwise",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Otherwise_1 : 
             {
		DLIST r;

		InitDList(&r);

		$$ = r;

             }
         | Statement Otherwise_1_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		$$ = r;

             }
         ;

Otherwise_1_1 : 
             {
		DLIST r;

		InitDList(&r);

		$$ = r;

             }
         | ';'      
             {
		DLIST r;

		InitDList(&r);

		$$ = r;

             }
         ;

Expression : Term     
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         | Term     LT       Term     
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		if ($2.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$2.string,
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"<",
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Term     LE       Term     
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		if ($2.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$2.string,
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"<=",
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Term     '='      Term     
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"=",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Term     NEQ      Term     
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		if ($2.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$2.string,
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"<>",
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Term     GE       Term     
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		if ($2.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$2.string,
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,">=",
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Term     GT       Term     
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		if ($2.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$2.string,
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,">",
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Term     : Factor   
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         | Term     '+'      Factor   
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"+",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Term     '-'      Factor   
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"-",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Term     OR       Factor   
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		if ($2.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$2.string,
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"or",
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

Factor   : Factor   '*'      Unary    
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"*",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Factor   '/'      Unary    
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"/",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Factor   MOD      Unary    
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		if ($2.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$2.string,
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"mod",
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Factor   AND      Unary    
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		if ($2.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$2.string,
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"and",
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Unary    
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         ;

Unary    : '-'      Unary    
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"-",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | '+'      Unary    
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"+",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | NOT      Unary    
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"not",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Super    
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         ;

Super    : Primary  EXP      Super    
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		if ($2.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$2.string,
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"**",
		                                TREETAG_LINE,$2.line,
		                                TREETAG_COLUMN,$2.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Primary  
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         ;

Primary  : EOFF     
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"eof",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | INTEGER_NUM 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"<integer>",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | CHAR_NUM 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"<char>",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | STR      
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"<string>",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | SUCC     '('      Expression ')'      
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"succ",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | PRED     '('      Expression ')'      
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"pred",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | ORD      '('      Expression ')'      
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"ord",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | CHR      '('      Expression ')'      
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"chr",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Name     '('      Primary_1 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"call",
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         | Name     
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         | '('      Expression ')'      
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$2) > 0)
		    DAddTail(&r,DRemHead(&$2));

		$$ = r;

             }
         ;

Primary_1 : ')'      
             {
		DLIST r;

		InitDList(&r);

		$$ = r;

             }
         | Primary_1_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         ;

Primary_1_1 : Expression ')'      
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		$$ = r;

             }
         | Expression ','      Primary_1_1 
             {
		DLIST r;

		InitDList(&r);

		while (DCount(&$1) > 0)
		    DAddTail(&r,DRemHead(&$1));

		while (DCount(&$3) > 0)
		    DAddTail(&r,DRemHead(&$3));

		$$ = r;

             }
         ;

Name     : IDENTIFIER 
             {
		DLIST r;
		T_NODE *t;

		InitDList(&r);

		if ($1.makenode) {
		    T_NODE *t2;
		    t2 = (T_NODE *)malloc(sizeof(T_NODE));
		    assert(t2);
		    t2->nodeptr = AllocTreeNode(TREETAG_STRING,$1.string,
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                                TREETAG_DONE);
		    DAddTail(&r,&t2->mynode);
		}

		t = (T_NODE *)malloc(sizeof(T_NODE));
		assert(t);
		t->nodeptr = AllocTreeNode(TREETAG_STRING,"<identifier>",
		                                TREETAG_LINE,$1.line,
		                                TREETAG_COLUMN,$1.column,
		                           TREETAG_DONE);
		while (DCount(&r) > 0) {
		    T_NODE *t3 = DRemHead(&r);
		    AddChild(t->nodeptr,t3->nodeptr);
		    free(t3);
		}
		DAddTail(&r,&t->mynode);
		$$ = r;

             }
         ;

