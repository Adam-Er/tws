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
#define DclnNode       5
#define IntegerTNode   6
#define BooleanTNode   7
#define BlockNode      8
#define AssignNode     9
#define OutputNode     10
#define IfNode         11
#define WhileNode      12
#define NullNode       13
#define ANDNode        14
#define ORNode         15
#define LTNode         16
#define LENode         17
#define EQNode         18
#define NEQNode        19
#define GENode         20
#define GTNode         21
#define PlusNode       22
#define MinusNode      23
#define MultNode       24
#define DivNode        25
#define ModNode        26
#define EXPNode        27
#define NotNode        28
#define ReadNode       29
#define EOFNode        30
#define IntegerNode    31
#define BooleanNode    32
#define IdentifierNode 33

#define NumberOfNodes  33

typedef TreeNode UserType;

/****************************************************************
 Add new node names to the end of the array, keeping in strict
  order with the define statements above, then adjust the i loop
  control variable in InitializeConstrainer().
*****************************************************************/
char *node[] = { "program", "types", "type", "dclns",
                 "dcln", "integer", "boolean", "block",
                 "assign", "output", "if", "while", 
                 "<null>", "and", "or", "<", "<=", "=",
                 "<>", ">=", ">", "+", "-", "*", "/",
                 "mod", "**", "not", "read", "eof", "<integer>", "<boolean>", "<identifier>" 
                };


UserType TypeInteger, TypeBoolean;
boolean TraceSpecified;
FILE *TraceFile;
char *TraceFileName;
int NumberTreesRead, index;


void Constrain(void)    
{
   int i;
   InitializeDeclarationTable();
   Tree_File = Open_File("_TREE", "r"); 
   NumberTreesRead = Read_Trees();
   fclose (Tree_File);                     
   AddIntrinsics();

   ProcessNode(RootOfTree(1)); 

#if 0
   PrintDclnTable(stdout);
   PrintAllStrings(stdout);
   PrintTree(stdout,RootOfTree(1));
#endif
    
   Tree_File = fopen("_TREE", "w");  
   Write_Trees();
   fclose (Tree_File);                   
   if (TraceSpecified) fclose(TraceFile);    
}


void InitializeConstrainer (int argc, char *argv[])
{          
   int i, j;
   InitializeTextModule();
   InitializeTreeModule();
   for (i=0, j=1; i<NumberOfNodes; i++, j++)
      String_Array_To_String_Constant (node[i], j); 
   index = System_Flag ("-trace", argc, argv);
   if (index)                                       
   {
      TraceSpecified = true; 
      TraceFileName = System_Argument ("-trace", "_TRACE", argc, argv);
      TraceFile = Open_File(TraceFileName, "w");
   }
   else
      TraceSpecified = false;          
}                        

void AddIntrinsics (void)
{
   TreeNode TempTree;

   AddTree (TypesNode, RootOfTree(1), 2);

   TempTree = Child (RootOfTree(1), 2);
   AddTree (TypeNode, TempTree, 1);

   TempTree = Child (RootOfTree(1), 2);
   AddTree (TypeNode, TempTree, 1);

   TempTree = Child (Child (RootOfTree(1), 2), 1);
   AddTree (BooleanTNode, TempTree, 1);
 
   TempTree = Child (Child (RootOfTree(1), 2), 2);
   AddTree (IntegerTNode, TempTree, 1);

   TempTree = Child (RootOfTree(1), 2);
   TypeBoolean = Child(TempTree,1);
   TypeInteger = Child(TempTree,2);
}

void ErrorHeader (TreeNode T)
{ 
   printf ("<<< CONSTRAINER ERROR >>> AT ");
   Write_String (stdout,SourceLocation(T));
   printf (" : ");
   printf ("\n");
}

int NKids (TreeNode T)
{
   return (Rank(T));
}

UserType Expression (TreeNode T)
{
   UserType Type1, Type2;
   TreeNode Declaration, Temp1, Temp2;
   int NodeCount;
   if (TraceSpecified)
   {
      fprintf (TraceFile, "<<< CONSTRAINER >>> : Expn Processor Node ");
      Write_String (TraceFile, NodeName(T));
      fprintf (TraceFile, "\n");
   }
     
   switch (NodeName(T))
   {
      case ANDNode :
      case ORNode  :
      case LTNode  :
      case LENode  :
      case EQNode  :
      case NEQNode :
      case GENode  :
      case GTNode  :
         Type1 = Expression (Child(T,1));
         Type2 = Expression (Child(T,2));
         if (Type1 != Type2)
         {
            ErrorHeader(Child(T,1));
            printf ("ARGUMENTS FOR COMPARISONS MUST BE TYPE INTEGER\n");
            printf ("\n");
         }
         return (TypeBoolean);

      case PlusNode :
      case MinusNode :
         Type1 = Expression (Child(T,1));
         if (Rank(T) == 1)
            Type2 = TypeInteger;
         else
            Type2 = Expression (Child(T,2));
         if (Type1 != TypeInteger || Type2 != TypeInteger)
         {
            ErrorHeader(Child(T,1));
            printf ("ARGUMENTS OF '+', '-'");
            printf ("MUST BE TYPE INTEGER\n");
            printf ("\n");
         }
         return (TypeInteger);
      case MultNode :
      case DivNode : 
      case ModNode :
      case EXPNode :
         Type1 = Expression (Child(T,1));
         Type2 = Expression (Child(T,2));
         if (Type1 != TypeInteger || Type2 != TypeInteger)
         {
            ErrorHeader(Child(T,1));
            printf ("ARGUMENTS OF '+', '-', '*', '/', 'mod'");
            printf ("MUST BE TYPE INTEGER\n");
            printf ("\n");
         }
         return (TypeInteger);
  
      case NotNode :
         Type1 = Expression(Child(T,1));
         if (Type1 != TypeBoolean)
         {
            ErrorHeader(Child(T,1));
            printf("ARGUMENTS OF 'not'");
            printf("MUST BE TYPE BOOLEAN\n");
            printf("\n");
         }
         return (TypeBoolean);
         
      case ReadNode :
         return (TypeInteger);

      case EOFNode :
         return (TypeBoolean);

      case IntegerNode : 
         return (TypeInteger);
    
      case BooleanNode :
         return (TypeBoolean);  

      case IdentifierNode :
         Declaration = Lookup (NodeName(Child(T,1)), T);
         if (Declaration != NullDeclaration)
         {
            Decorate (T, Declaration);
            return (Decoration(Declaration));
         }
         else
            return (TypeInteger);

      default :
         ErrorHeader(T);
         printf ( "UNKNOWN NODE NAME ");
         Write_String (stdout,NodeName(T));
         printf ("\n");

   }  /* end switch */
}  /* end Expression */


void ProcessNode (TreeNode T) 
{
   int Kid, N;
   String Name1, Name2;
   TreeNode Type1, Type2, Type3;
   if (TraceSpecified)
   {
      fprintf (TraceFile,
               "<<< CONSTRAINER >>> : Stmt Processor Node ");
      Write_String (TraceFile, NodeName(T));
      fprintf (TraceFile, "\n");
   }

   switch (NodeName(T))
   {
      case ProgramNode : 
         Name1 = NodeName(Child(Child(T,1),1));
         Name2 = NodeName(Child(Child(T,NKids(T)),1));
         if (Name1 != Name2)
         {
           ErrorHeader(T);
           printf ("PROGRAM NAMES DO NOT MATCH\n");
           printf ("\n");
         }
         for (Kid = 2; Kid <= NKids(T)-1; Kid++)
            ProcessNode (Child(T,Kid));
         break;

      case TypesNode :  
         for (Kid = 1; Kid <= NKids(T); Kid++)
            ProcessNode (Child(T,Kid));
         break;

      case TypeNode :
         DTEnter (NodeName(Child(T,1)),T,T);
         break;

      case DclnsNode :
         for (Kid = 1; Kid <= NKids(T); Kid++)
            ProcessNode (Child(T,Kid));
         break;

      case DclnNode :

	 Name1 = NodeName (Child(T, NKids(T)));
         Type1 = Lookup (Name1,T);
         for (Kid  = 1; Kid < NKids(T); Kid++)
         {
            DTEnter (NodeName(Child(Child(T,Kid),1)), Child(T,Kid), T);
            Decorate (Child(T,Kid), Type1);
         }
         break;

      case BlockNode :
         for (Kid = 1; Kid <= NKids(T); Kid++)
            ProcessNode (Child(T,Kid));
         break;

      case AssignNode :
         Type1 = Expression (Child(T,1));
         Type2 = Expression (Child(T,2));
         if (Type1 != Type2)
         {
            ErrorHeader(T);
            printf ("ASSIGNMENT TYPES DO NOT MATCH\n");
            printf ("\n");
         }
         break;

      case OutputNode :
         for (Kid = 1; Kid <= NKids(T); Kid++)
            if (Expression (Child(T,Kid)) != TypeInteger)
            {
               ErrorHeader(T);
               printf ("OUTPUT EXPRESSION MUST BE TYPE INTEGER\n");
               printf ("\n");
            }
         break;

      case IfNode :
         if (Expression (Child(T,1)) != TypeBoolean)
         {
            ErrorHeader(T);
            printf ("CONTROL EXPRESSION OF 'IF' STMT");
            printf (" IS NOT TYPE BOOLEAN\n");
            printf ("\n");
         } 
         ProcessNode (Child(T,2));
         if (Rank(T) == 3)
            ProcessNode (Child(T,3));
         break;

      case WhileNode :
         if (Expression (Child(T,1)) != TypeBoolean)
         {
            ErrorHeader(T);
            printf ("WHILE EXPRESSION NOT OF TYPE BOOLEAN\n");
            printf ("\n");
         }
         ProcessNode (Child(T,2));
         break;

      case NullNode : 
         break;

      default :
         ErrorHeader(T);
         printf ("UNKNOWN NODE NAME ");
         Write_String (stdout,NodeName(T));
         printf ("\n");

   }  /* end switch */
}  /* end ProcessNode */
