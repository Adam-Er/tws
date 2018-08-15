	/****************************************************************
		      Copyright (C) 1986 by Manuel E. Bermudez
		      Translated to C - 1991
	*****************************************************************/

#include <stdio.h>
#include <header/Open_File.h>
#include <header/CommandLine.h>
#include <header/Table.h>
#include <header/Text.h>
#include <header/Error.h>
#include <header/String_Input.h>
#include <header/Tree.h>
#include <header/Dcln.h>
#include <header/Constrainer.h>

#define ProgramNode    1
#define TypesNode      2
#define TypeNode       3
#define DclnsNode      4
#define VarNode        5
#define IntegerTNode   6
#define BooleanTNode   7
#define BlockNode      8
#define AssignNode     9
#define OutputNode     10
#define IfNode         11
#define WhileNode      12
#define RepeatNode     13
#define NullNode       14
#define ANDNode        15
#define ORNode         16
#define LTNode         17
#define LENode         18
#define EQNode         19
#define NEQNode        20
#define GENode         21
#define GTNode         22
#define PlusNode       23
#define MinusNode      24
#define MultNode       25
#define DivNode        26
#define ModNode        27
#define EXPNode        28
#define NotNode        29
#define ReadNode       30
#define EOFNode        31
#define IntegerNode    32
#define IdentifierNode 33
#define ForUpNode      34
#define ForDownNode    35
#define SwapNode       36
#define LoopNode       37
#define ExitNode       38
#define CaseNode       39
#define SwitchNode     40
#define RangeNode      41
#define OtherwiseNode  42
#define TrueNode       43
#define FalseNode      44
#define CharTNode      45
#define LitNode        46
#define CharNode       47
#define ConstsNode     48
#define ConstNode      49
#define SuccNode       50
#define PredNode       51
#define OrdNode        52
#define ChrNode        53
#define StringNode     54
#define FunctionNode   55
#define ProcedureNode  56
#define ParamsNode     57
#define ReturnNode     58
#define CallNode       59
#define SubProgsNode   60

#define NumberOfNodes  60

typedef TreeNode UserType;

	/****************************************************************
	 Add new node names to the end of the array, keeping in strict
	  order with the define statements above, then adjust the i loop
	  control variable in InitializeConstrainer().
	*****************************************************************/
char *node[] = { "program", "types", "type", "dclns", "var",
  "integer", "boolean", "block", "assign",
  "output", "if", "while", "repeat", "<null>",
  "and", "or", "<", "<=", "=", "<>", ">=", ">",
  "+", "-", "*", "/", "mod", "**", "not", "read",
  "eof", "<integer>", "<identifier>",
  "upfor", "downfor", "swap", "loop", "exit", "case",
  "switch", "range", "otherwise", "true", "false", "char",
  "lit", "<char>", "consts", "const", "succ", "pred", "ord",
  "chr", "<string>", "fnc", "proc", "params", "return",
  "call", "subprogs"
};


UserType TypeInteger, TypeBoolean, TypeChar;
boolean TraceSpecified;
FILE *TraceFile;
char *TraceFileName;
int NumberTreesRead, index;


void
Constrain (void)
{
  int i;
  InitializeDeclarationTable ();
  Tree_File = Open_File ("_TREE", "r");
  NumberTreesRead = Read_Trees ();
  fclose (Tree_File);
  AddIntrinsics ();

  ProcessNode (RootOfTree (1));
#if 0
  PrintDclnTable (stdout);
  PrintAllStrings (stdout);
  PrintTree (stdout, RootOfTree (1));
#endif

  Tree_File = fopen ("_TREE", "w");
  Write_Trees ();
  fclose (Tree_File);
  if (TraceSpecified)
    fclose (TraceFile);
}


void
InitializeConstrainer (int argc, char *argv[])
{
  int i, j;
  InitializeTextModule ();
  InitializeTreeModule ();
  for (i = 0, j = 1; i < NumberOfNodes; i++, j++)
    String_Array_To_String_Constant (node[i], j);
  index = System_Flag ("-trace", argc, argv);
  if (index)
    {
      TraceSpecified = true;
      TraceFileName = System_Argument ("-trace", "_TRACE", argc, argv);
      TraceFile = Open_File (TraceFileName, "w");
    }
  else
    TraceSpecified = false;
} 

void AddIntrinsics (void)
{
  TreeNode TempTree;
  AddTree (TypesNode, RootOfTree (1), 2); 

  TempTree = Child (RootOfTree (1), 2);
  AddTree (TypeNode, TempTree, 1); 
  
  TempTree = Child (Child (RootOfTree (1), 2), 1);
  AddTree (IdentifierNode, TempTree, 1);

  TempTree = Child(Child (Child (RootOfTree (1), 2), 1),1);
  AddTree (IntegerTNode, TempTree, 1);

  TempTree = Child (RootOfTree (1), 2);
  AddTree (TypeNode, TempTree, 2); 

  TempTree = Child(Child (RootOfTree (1), 2),2);
  AddTree (IdentifierNode, TempTree, 1);

  TempTree = Child(Child(Child(RootOfTree(1), 2), 2), 1);
  AddTree(BooleanTNode, TempTree, 1);

  TempTree = Child(Child(RootOfTree(1), 2), 2);
  AddTree(LitNode, TempTree, 2);

  TempTree = Child(Child(Child(RootOfTree(1),2),2),2);
  AddTree(IdentifierNode, TempTree, 1);

  TempTree = Child(Child(Child(Child(RootOfTree(1),2),2),2),1);
  AddTree(FalseNode, TempTree, 1);

  TempTree = Child(Child(Child(RootOfTree(1),2),2),2);
  AddTree(IdentifierNode, TempTree, 2);

  TempTree = Child(Child(Child(Child(RootOfTree(1),2),2),2),2);
  AddTree(TrueNode, TempTree, 1);

  TempTree = Child(RootOfTree(1),2);
  AddTree(TypeNode, TempTree, 3);

  TempTree = Child(Child(RootOfTree(1),2),3);
  AddTree(IdentifierNode, TempTree, 1);

  TempTree = Child(Child(Child(RootOfTree(1),2),3),1);
  AddTree(CharTNode, TempTree, 1);
  
  TypeInteger = Child(Child(RootOfTree(1),2),1);
  TypeBoolean = Child(Child(RootOfTree(1),2),2);
  TypeChar    = Child(Child(RootOfTree(1),2),3);
}

void
ErrorHeader (TreeNode T)
{
  printf ("<<< CONSTRAINER ERROR >>> AT ");
  Write_String (stdout, SourceLocation (T));
  printf (" : ");
  printf ("\n");
}

int
NKids (TreeNode T)
{
  return (Rank (T));
}

UserType
Expression (TreeNode T)
{
  UserType Type1, Type2;
  TreeNode Declaration, Temp1, Temp2;
  int NodeCount, i, j;
  if (TraceSpecified)
    {
      fprintf (TraceFile, "<<< CONSTRAINER >>> : Expn Processor Node ");
      Write_String (TraceFile, NodeName (T));
      fprintf (TraceFile, "\n");
    }

  switch (NodeName (T))
    {
    case ANDNode:
    case ORNode:
      Type1 = Expression (Child(T, 1));
      Type2 = Expression (Child(T, 2));
      if (Type1 != Type2 || Type1 != TypeBoolean) {
        ErrorHeader (T);
        printf("ARGUMENTS FOR AND/OR REQUIRE BOOLEAN TYPES\n\n");
      }
     return (TypeBoolean);
    case LTNode:
    case LENode:
    case EQNode:
    case NEQNode:
    case GENode:
    case GTNode:
      Type1 = Expression (Child (T, 1));
      Type2 = Expression (Child (T, 2));
      if (Type1 != Type2)
	{
	  ErrorHeader (Child (T, 1));
	  printf ("ARGUMENTS FOR COMPARISONS MUST BE TYPE INTEGER\n");
	  printf ("\n");
	}
      return (TypeBoolean);

    case PlusNode:
    case MinusNode:
      Type1 = Expression (Child (T, 1));
      if (Rank (T) == 1)
	Type2 = TypeInteger;
      else
        Type2 = Expression (Child(T, 2));
      if (Type1 != TypeInteger || Type2 != TypeInteger)
	{
	  ErrorHeader (Child (T, 1));
	  printf ("ARGUMENTS OF '+', '-'");
	  printf ("MUST BE TYPE INTEGER\n");
	  printf ("\n");
	}
      
      return (TypeInteger);
    case MultNode:
    case DivNode:
    case ModNode:
    case EXPNode:
      Type1 = Expression (Child (T, 1));
      Type2 = Expression (Child (T, 2));
      if (Type1 != TypeInteger || Type2 != TypeInteger)
	{
	  ErrorHeader (Child (T, 1));
	  printf ("ARGUMENTS OF '+', '-', '*', '/', 'mod'");
	  printf ("MUST BE TYPE INTEGER\n");
	  printf ("\n");
	}
      return (TypeInteger);

    case NotNode:
      Type1 = Expression (Child (T, 1));
      if (Type1 != TypeBoolean)
	{
	  ErrorHeader (Child (T, 1));
	  printf ("`ARGUMENTS OF 'not'");
	  printf ("MUST BE TYPE BOOLEAN\n");
	  printf ("\n");
	}
      return (TypeBoolean);

    case EOFNode:
      return (TypeBoolean);

    case SuccNode :
    case PredNode :
    case OrdNode  :
      Type1 = Expression(Child(T,1));
      if (NodeName(T) == OrdNode)
        Decorate(T, TypeInteger);
      else
        Decorate(T, Type1);
      return Decoration(T);
    
    case ChrNode:
      Type1 = Expression(Child(T,1));
      Decorate(T, TypeChar);
      if (Type1 != TypeInteger) {
        ErrorHeader(T);
        printf("ARGUMENTS OF CHR MUST BE TYPE INTEGER\n\n");
      }
      return TypeChar;

    case IntegerNode:
      return (TypeInteger);

    case CharNode:
      return (TypeChar);

    case CallNode:
      Type1 = Expression(Child(T,1));
      Type2 = Decoration(Child(Decoration(Child(T,1)),1));
      if (NodeName(Type2) != FunctionNode && NodeName(Type2) != ProcedureNode) {
        ErrorHeader(T);
        printf("CAN ONLY CALL PROCEDURES AND FUNCTIONS!\n\n");
      }
      Type2 = Child(Type2, 2);
      NodeCount = 1;
      for (i = 1; i <= Rank(Type2); i++) {
        for (j = 1; j <= Rank(Child(Type2, i))-1; j++) {
          if (NodeCount > Rank(T)-1) {
            ErrorHeader(T);
            printf("THERE ARE MORE PARAMETERS LISTED IN DEFINITION THAN USED IN CALL!\n\n");
          } else if (Decoration(Decoration(Child(Child(Type2, i), j))) != Expression(Child(T, NodeCount+1))) {
            ErrorHeader(Child(T, NodeCount + 1));
	    printf("PARAMETER TYPE MISMATCH IN CALL!\n\n");
          
          }
          NodeCount++;
        }
      }
      if (NodeCount-1 < Rank(T)-1) {
        ErrorHeader(T);
        printf("THERE ARE FEWER PARAMETERS LISTED IN DEFINITION THAN USED IN CALL!\n\n");
      }
      return (Type1);
     

    case IdentifierNode:
      Declaration = Lookup (NodeName (Child (T, 1)), T);
      if (Declaration != NullDeclaration)
	{         
	  Decorate (T, Declaration);
          Temp1 = Decoration(Child(Decoration(T),1));
          if (NodeName(Temp1) == VarNode) {
             return Decoration(Decoration(Declaration));
          } else if (NodeName(Temp1) == LitNode) {
             return Decoration(Declaration);
          }
          return Decoration(Decoration(T));
	}
      else
	return (TypeInteger); 


    default:
      ErrorHeader (T);
      printf ("UNKNOWN NODE NAME ");
      Write_String (stdout, NodeName (T));
      printf ("\n");

    }				/* end switch */
}				/* end Expression */

void
ProcessNode (TreeNode T)
{
  int Kid, N;
  String Name1, Name2;
  TreeNode Type1, Type2, Type3;
  if (TraceSpecified)
    {
      fprintf (TraceFile, "<<< CONSTRAINER >>> : Stmt Processor Node ");
      Write_String (TraceFile, NodeName (T));
      fprintf (TraceFile, "\n");
    }
  switch (NodeName (T))
    {
    case ProgramNode:
      DTEnter ("<subprog_ctxt>", T, T);
      OpenScope();
      DTEnter ("<loop_ctxt>", T, T);
      DTEnter ("<for_ctxt>", T, T);
      Name1 = NodeName (Child (Child (T, 1), 1));
      Name2 = NodeName (Child (Child (T, NKids (T)), 1));
      if (Name1 != Name2)
	{
	  ErrorHeader (T);
	  printf ("PROGRAM NAMES DO NOT MATCH\n");
	  printf ("\n");
	}
     
      for (Kid = 2; Kid <= NKids (T) - 1; Kid++)
	ProcessNode (Child (T, Kid));
      CloseScope();
      break;

    case ConstNode:
      if (NodeName(Child(Child(T,2),1)) == IntegerTNode) {
        ErrorHeader(T);
        printf("CANNOT ASSIGN INTEGER TYPE TO CONSTANT!\n\n");
      } else if (NodeName(Child(Child(T,2),1)) == CharTNode) {
        ErrorHeader(T);
        printf("CANNOT ASSIGN CHAR TYPE TO CONSTANT!\n\n");
      } else if (NodeName(Child(Child(T,2),1)) == BooleanTNode) {
        ErrorHeader(T);
        printf("CANNOT ASSIGN BOOLEAN TYPE TO CONSTANT!\n\n");
      }
      Type1 = Expression(Child(T,2));
      DTEnter (NodeName(Child(Child(T,1),1)), Child(T,1), T);
      Decorate (Child(T,1), Type1);
      Decorate (Child(Child(T,1),1), T);    
      break;

    case TypeNode:
      DTEnter (NodeName (Child(Child (T, 1),1)), Child(T,1), T);
      Decorate(Child(T,1), T);
      Decorate(Child(Child(T,1),1), T);
      if (Rank(T) == 2) {
        if (NodeName(Child(T,2)) == LitNode) {
          for (Kid = 1; Kid <= Rank(Child(T,2)); Kid++) {
            DTEnter(NodeName(Child(Child(Child(T,2),Kid),1)),Child(Child(T,2),Kid));
            Decorate(Child(Child(T,2),Kid), T);
            Decorate(Child(Child(Child(T,2),Kid),1), Child(T,2));
          }
        }
      }  
    break;
    case SubProgsNode:
    case ParamsNode:
    case ConstsNode:
    case TypesNode:
    case DclnsNode:
      for (Kid = 1; Kid <= NKids (T); Kid++)
	ProcessNode (Child (T, Kid));
      break;

    case FunctionNode:
      if (NodeName(Child(Child(T,1),1)) != NodeName(Child(Child(T, Rank(T)), 1))) {
        ErrorHeader(T);
        printf("FUNCTION NAMES DO NOT MATCH!\n\n");
      }
      DTEnter(NodeName(Child(Child(T,1),1)), Child(T,1), T);
      OpenScope ();
      DTEnter("<subprog_ctxt>", T, T);
      Type1 = Lookup(NodeName(Child(Child(T,3),1)), Child(Child(T,3),1));
      Decorate(Child(T,1), Decoration(Type1));
      Decorate(Child(Child(T,1),1), T);
      ProcessNode(Child(T,2));
      for (Kid = 4; Kid <= 7; Kid++)
        ProcessNode(Child(T,Kid));
      CloseScope ();
      break;

    case ProcedureNode:
      if (NodeName(Child(Child(T,1),1)) != NodeName(Child(Child(T,Rank(T)), 1))) {
        ErrorHeader(T);
        printf("PROCEDURE NAMES DO NOT MATCH!\n\n");
      }
      DTEnter(NodeName(Child(Child(T,1),1)), Child(T,1), T);
      OpenScope ();
      DTEnter("<subprog_ctxt>", T, T);
      Decorate(Child(Child(T,1),1), T);
      ProcessNode(Child(T,2));
      for (Kid = 3; Kid <= 6; Kid++) {
        ProcessNode(Child(T,Kid));
      }
      CloseScope ();
      break;

    case ReturnNode:
      Type2 = Lookup("<subprog_ctxt>", T);
      if (NodeName(Type2) != FunctionNode) {
        ErrorHeader(T);
        printf("RETURN CAN ONLY BE USED IN FUNCTION!\n\n");
      } else if (Rank(T) > 0) {
        Type1 = Expression(Child(T,1));
        if (Decoration(Child(Type2, 1)) != Type1) {
          ErrorHeader(T);
          printf("RETURN TYPES DO NOT MATCH!\n\n");
        }
      }
      break;

    case CallNode:
       
      Type1 = Expression(Child(T,1));
      Type2 = Decoration(Child(Decoration(Child(T,1)),1));
      if (NodeName(Type2) == FunctionNode) {
        ErrorHeader(T);
        printf("FUNCTION CALLED AS PROCEDURE!\n\n");
      }
      Expression(T);
      break;

    case VarNode:
      Name1 = NodeName (Child(Child (T, NKids (T)),1));
      Type1 = Lookup (Name1, T);
      if (NodeName(Decoration(Child(Type1,1))) != TypeNode) {
         ErrorHeader(T);
         printf("PLEASE DEFINE TYPE NOT VALUE FOR DECLARATION!\n\n");
      }
      Decorate(Child(T,Rank(T)), Type1);
      for (Kid = 1; Kid < NKids (T); Kid++)
	{
	  DTEnter (NodeName (Child (Child (T, Kid), 1)), Child (T, Kid), T);
	  Decorate (Child (T, Kid), Type1);
          Decorate (Child(Child(T,Kid),1), T);
	}
      break;

    case BlockNode:
      for (Kid = 1; Kid <= NKids (T); Kid++)
	{
	  ProcessNode (Child (T, Kid));
	}

      break;

    case AssignNode:
    
      Type1 = Expression(Child(T,1));
      Type2 = Expression(Child(T,2));
      Type3 = Lookup("<subprog_ctxt>", T);
      if (NodeName(Child(T,2)) == IdentifierNode && NodeName(Decoration(Child(Lookup(NodeName(Child(Child(T,2),1)),T),1))) == TypeNode) {

        ErrorHeader(T);
        printf("CANNOT ASSIGN TYPE TO VARIABLE!\n\n");
      }
      if (NodeName(Decoration(Child(Lookup(NodeName(Child(Child(T,1),1)),T), 1))) == ConstNode) {
        ErrorHeader(T);
        printf("CANNOT ASSIGN VALUE TO CONSTANT!\n\n");
      } else if (!(NodeName(Decoration(Child(Decoration(Child(T,1)), 1))) == FunctionNode && NodeName(Lookup("<subprog_ctxt>", T)) == FunctionNode) && NodeName(Decoration(Child(Lookup(NodeName(Child(Child(T,1),1)),T), 1))) != VarNode) {
        ErrorHeader(T);
        printf("CANNOT ASSIGN VALUE TO NON-VARIABLE!\n\n");
      }
      if (NodeName(Decoration(Child(Decoration(Child(Child(T,2),1)),1))) == ProcedureNode) {
	ErrorHeader(T);
        printf("CANNOT ASSIGN WITH PROCEDURES! USE FUNCTIONS!\n\n");
      } else if (Type1 != Type2)
	{
	  ErrorHeader (T);
	  printf ("ASSIGNMENT TYPES DO NOT MATCH\n");
	  printf ("\n");
	}
      Type1 = Lookup ("<for_ctxt>", T);
      while (NodeName (Type1) != ProgramNode)
	{
	  if (NodeName (Child (Child (Type1, 1), 1)) ==
	      NodeName (Child (Child (T, 1), 1)))
	    {
	      ErrorHeader (T);
	      printf
		("Cannot assign to loop control variable of enclosing loop!\n\n");
	    }
	  Type1 = Decoration (Type1);
	}
      break;

    case SwapNode:
      Type1 = Expression(Child(T,1));
      Type2 = Expression(Child(T,2));
      if (NodeName (Child (T, 1)) != IdentifierNode
	       || NodeName (Child (T, 2)) != IdentifierNode)
	{
	  ErrorHeader (T);
	  printf ("Cannot swap with non-variables\n\n");
	} else if (NodeName(Decoration(Child(Decoration(Child(T,1)),1))) == ConstNode || NodeName(Decoration(Child(Decoration(Child(T,2)),1))) == ConstNode) {
          ErrorHeader (T);
          printf("CANNOT SWAP WITH CONSTANTS!\n\n");
        } else if (NodeName(Decoration(Child(Decoration(Child(T,1)),1))) == LitNode || NodeName(Decoration(Child(Decoration(Child(T,2)),1))) == LitNode) {
          ErrorHeader(T);
          printf("CANNOT SWAP WITH LITERALS!");
        } else if (Type1 != Type2) {
          ErrorHeader(T);
          printf("CANNOT SWAP WITH DIFFERENT TYPES\n\n");
        }
      Type1 = Lookup ("<for_ctxt>", T);
      while (NodeName (Type1) != ProgramNode)
	{
	  if (NodeName (Child (Child (Type1, 1), 1)) ==
	      NodeName (Child (Child (T, 1), 1))
	      || NodeName (Child (Child (Type1, 1), 1)) ==
	      NodeName (Child (Child (T, 2), 1)))
	    {
	      ErrorHeader (T);
	      printf ("Cannot swap with loop control variable!\n\n");
	    }
	  Type1 = Decoration (Type1);
	}
      break;

    case ReadNode:
      for (Kid = 1; Kid <= Rank(T); Kid++) {
        Type1 = Expression(Child(T,Kid));
        Type2 = Lookup("<for_ctxt>", T);
        while (NodeName(Type2) != ProgramNode) {
          if (NodeName(Child(Child(Type2,1),1)) == NodeName(Child(Child(T, Kid), 1))) {
            ErrorHeader (Child(T,Kid));
            printf ("CANNOT READ TO A LOOP CONTROL VARIABLE!\n\n");
          }
          Type2 = Decoration(Type2);
        }
        if (Type1 != TypeInteger && Type1 != TypeChar) {
          ErrorHeader(Child(T,Kid));
          printf ("READ TAKES TYPE INTEGER AND TYPE CHARACTER ARGUMENTS!\n\n");
        }
      }
      break;

    case OutputNode:
      for (Kid = 1; Kid <= NKids (T); Kid++) {
        if (NodeName(Child(T,Kid)) != StringNode)
          Type1 = Expression(Child(T,Kid));
        if (NodeName(Child(T,Kid)) == IdentifierNode) {
          Type2 = Decoration(Child(Decoration(Child(T,Kid)), 1));
          Type2 = Child(Type2, Rank(Type2));
          Type2 = Decoration(Decoration(Type2));
        }
        if (NodeName(Child(T,Kid)) == IdentifierNode && NodeName(Decoration(Child(Lookup(NodeName(Child(Child(T,Kid),1)),T),1))) == LitNode) {
          ErrorHeader(Child(T,Kid));
          printf("CANNOT OUTPUT LITERALS!\n\n");
        } else if (NodeName(Child(T,Kid)) == IdentifierNode && NodeName(Type2) == TypeNode && Type1 != TypeInteger && Type1 != TypeChar ) {
          ErrorHeader(Child(T,Kid));
          printf("CANNOT OUTPUT ENUMERATED TYPES\n\n");
        } else if (Type1 != TypeInteger && Type1 != TypeChar && NodeName(Child(T,Kid)) != StringNode) {
	    ErrorHeader (T);
	    printf ("OUTPUT EXPRESSION MUST BE TYPE INTEGER, CHAR, OR STRING!\n");
	    printf ("\n");
        }
      }
      break;

    case IfNode:
      if (Expression (Child (T, 1)) != TypeBoolean)
	{
	  ErrorHeader (T);
	  printf ("CONTROL EXPRESSION OF 'IF' STMT");
	  printf (" IS NOT TYPE BOOLEAN\n");
	  printf ("\n");
	}
      ProcessNode (Child (T, 2));
      if (Rank (T) == 3)
	{
	  ProcessNode (Child (T, 3));
	}
      break;

    case WhileNode:
      if (Expression (Child (T, 1)) != TypeBoolean)
	{
	  ErrorHeader (T);
	  printf ("WHILE EXPRESSION NOT OF TYPE BOOLEAN\n");
	  printf ("\n");
	}
      ProcessNode (Child (T, 2));
      break;

    case ForDownNode:
    case ForUpNode:
      Type1 = Lookup ("<for_ctxt>", T);
      Decorate (T, Type1);
      OpenScope ();
      DTEnter ("<for_ctxt>", T, T);
      DTEnter ("<loop_ctxt>", T, T);
      if (Expression (Child (T, 1)) != Expression (Child (T, 2)))
	{
	  ErrorHeader (T);
	  printf
	    ("For loop control variable doesn't match start condition!\n\n");
	}
      Expression (Child (T, 3));
      ProcessNode (Child (T, 4));
      while (NodeName (Type1) != ProgramNode)
	{
	  if (NodeName (Child (Child (Type1, 1), 1)) ==
	      NodeName (Child (Child (T, 1), 1)))
	    {
	      ErrorHeader (T);
	      printf
		("Please use different control variables for nested loops.\n\n");
	    }
	  Type1 = Decoration (Type1);
	}
      CloseScope ();
      break;

    case LoopNode:
      OpenScope ();
      DTEnter ("<loop_ctxt>", T, T);
      for (Kid = 1; Kid <= Rank (T); Kid++)
	{
	  ProcessNode (Child (T, Kid));
	}
      if (NodeName (Decoration (T)) == 0)
	{
	  printf ("Warning: No exit statement in loop!\n\n");
	}
      CloseScope ();
      break;

    case RepeatNode:
      if (Expression (Child (T, Rank (T))) != TypeBoolean)
	{
	  ErrorHeader (T);
	  printf ("REPEAT EXPRESSION NOT OF TYPE BOOLEAN\n");
	  printf ("\n");
	}
      for (Kid = 1; Kid < Rank (T); Kid++)
	{
	  ProcessNode (Child (T, Kid));
	}
      break;

    case ExitNode:
      Type1 = Lookup ("<loop_ctxt>", T);
      if (NodeName (Type1) == ForUpNode || NodeName (Type1) == ForDownNode)
	{
	  ErrorHeader (T);
	  printf ("Cannot exit from a for loop!\n\n");
	}
      else if (NodeName (Type1) != LoopNode)
	{
	  ErrorHeader (T);
	  printf ("No pool-loop detected for exit statement!\n\n");
	}
      Decorate (Type1, T);
      Decorate (T, Type1);
      break;

    case CaseNode:
      if (NodeName (Child (T, 1)) == StringNode)
	{
	  ErrorHeader (T);
	  printf ("CASE STATEMENT DOES NOT SUPPORT STRINGS TO BOOLEANS\n\n");
	}
      Type1 = Expression (Child(T,1));
      for (Kid = 2; Kid <= Rank (T); Kid++)
	{
          if (NodeName(Child(T,Kid)) == SwitchNode && Type1 != Expression(Child(Child(Child(T,Kid),1),1))) {
            ErrorHeader (T);
            printf("CASE LABEL DOES NOT MATCH SWITCH EXPRESSION TYPE!\n\n");
          }
	  ProcessNode (Child (T, Kid));
	}
      break;

    case SwitchNode:
      ProcessNode (Child (T, 1));
      ProcessNode (Child (T, 2));
      break;

    case RangeNode:
      Kid = Decoration(Child(Decoration(Child(T,1)), 1));
      N = T;
      if (NodeName(Child(T,1)) == IdentifierNode)
        Kid = Lookup(NodeName(Child(Child(T,1),1)), T);
      if (NodeName(Decoration(Child(Kid,1))) == ConstNode || NodeName(Decoration(Child(Kid,1))) == LitNode)
        Decorate(Child(T,1), Kid);
      if (Rank(T) == 2 && NodeName(Child(T,2)) == IdentifierNode) {
        N = Lookup(NodeName(Child(Child(T,2),1)), T);
        if (NodeName(Decoration(Child(N,1))) == ConstNode || NodeName(Decoration(Child(N,1))) == LitNode)
          Decorate(Child(T,2), N);
      }
      Type1 = Expression(Child(T,1));
      if (Rank(T) == 2)
        Type2 = Expression(Child(T,2));
      else 
        Type2 = Type1;
      if ( (Rank(T) == 2 && NodeName(Decoration(Child(N,1))) == VarNode) || NodeName(Decoration(Child(Kid,1))) == VarNode ) {
        ErrorHeader(T);
        printf("RANGE MUST BE LITERALS OR CONSTANTS\n\n");
      }
  
      if (Type1 != Type2) {
        ErrorHeader(T);
        printf("RANGE TYPES DO NOT MATCH!\n\n");
      } 
      break;
    case OtherwiseNode:
      if (Rank(T) > 0 && NodeName(Child(T,1)) != NullNode)
        ProcessNode (Child (T, 1));
      break;
    case NullNode:
      break;

    default:
      ErrorHeader (T);
      printf ("UNKNOWN NODE NAME ");
      Write_String (stdout, NodeName (T));
      printf ("\n");

    }				/* end switch */
}				/* end ProcessNode */
