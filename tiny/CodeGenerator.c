/*******************************************************************
          Copyright (C) 1986 by Manuel E. Bermudez
          Translated to C - 1991
*******************************************************************/

#include <stdio.h>
#include <header/CommandLine.h>
#include <header/Open_File.h>
#include <header/Table.h>
#include <header/Text.h>
#include <header/Error.h>
#include <header/String_Input.h>
#include <header/Tree.h>
#include <header/Code.h>
#include <header/CodeGenerator.h>
#define LeftMode 0
#define RightMode 1

    /*  ABSTRACT MACHINE OPERATIONS  */
#define    NOP          1   /* 'NOP'       */
#define    HALTOP       2   /* 'HALT'      */
#define    LITOP        3   /* 'LIT'       */
#define    LLVOP        4   /* 'LLV'       */
#define    LGVOP        5   /* 'LGV'       */
#define    SLVOP        6   /* 'SLV'       */
#define    SGVOP        7   /* 'SGV'       */
#define    LLAOP        8   /* 'LLA'       */
#define    LGAOP        9   /* 'LGA'       */
#define    UOPOP       10   /* 'UOP'       */
#define    BOPOP       11   /* 'BOP'       */
#define    POPOP       12   /* 'POP'       */
#define    DUPOP       13   /* 'DUP'       */
#define    SWAPOP      14   /* 'SWAP'      */
#define    CALLOP      15   /* 'CALL'      */
#define    RTNOP       16   /* 'RTN'       */
#define    GOTOOP      17   /* 'GOTO'      */
#define    CONDOP      18   /* 'COND'      */
#define    CODEOP      19   /* 'CODE'      */
#define    SOSOP       20   /* 'SOS'       */
#define    LIMITOP     21   /* 'LIMIT'     */

    /* ABSTRACT MACHINE OPERANDS */

         /* UNARY OPERANDS */
#define    UNOT        22   /* 'UNOT'     */
#define    UNEG        23   /* 'UNEG'     */
#define    USUCC       24   /* 'USUCC'    */
#define    UPRED       25   /* 'UPRED'    */
         /* BINARY OPERANDS */
#define    BAND        26   /* 'BAND'     */
#define    BOR         27   /* 'BOR'      */
#define    BPLUS       28   /* 'BPLUS'    */
#define    BMINUS      29   /* 'BMINUS'   */
#define    BMULT       30   /* 'BMULT'    */
#define    BDIV        31   /* 'BDIV'     */
#define    BEXP        32   /* 'BEXP'     */
#define    BMOD        33   /* 'BMOD'     */
#define    BEQ         34   /* 'BEQ'      */
#define    BNE         35   /* 'BNE'      */
#define    BLE         36   /* 'BLE'      */
#define    BGE         37   /* 'BGE'      */
#define    BLT         38   /* 'BLT'      */
#define    BGT         39   /* 'BGT'      */
         /* OS SERVICE CALL OPERANDS */
#define    TRACEX      40   /* 'TRACEX'   */
#define    DUMPMEM     41   /* 'DUMPMEM'  */
#define    OSINPUT     42   /* 'INPUT'    */
#define    OSINPUTC    43   /* 'INPUT'    */
#define    OSOUTPUT    44   /* 'OUTPUT'   */
#define    OSOUTPUTC   45   /* 'OUTPUT'   */
#define    OSOUTPUTL   46   /* 'OUTPUTL'  */
#define    OSEOF       47   /* 'EOF'      */

         /* TREE NODE NAMES */
#define    ProgramNode  48   /* 'program'  */
#define    TypesNode    49   /* 'types'    */
#define    TypeNode     50   /* 'type'     */
#define    DclnsNode    51   /* 'dclns'    */
#define    VarNode      52   /* 'var'      */
#define    IntegerTNode 53   /* 'integer'  */
#define    BooleanTNode 54   /* 'boolean'  */
#define    BlockNode    55   /* 'block'    */
#define    AssignNode   56   /* 'assign'   */
#define    OutputNode   57   /* 'output'   */ 
#define    IfNode       58   /* 'if'       */
#define    WhileNode    59   /* 'while'    */
#define    RepeatNode   60   /* 'repeat'   */
#define    NullNode     61   /* '<null>'   */
#define    ANDNode      62   /* 'and'      */
#define    ORNode       63   /* 'or'       */
#define    LTNode       64   /* '<'        */
#define    LENode       65   /* '<='       */
#define    EQNode       66   /* '='        */
#define    NEQNode      67   /* '<>'       */
#define    GENode       68   /* '>='       */
#define    GTNode       69   /* '>'        */
#define    PlusNode     70   /* '+'        */
#define    MinusNode    71   /* '-'        */
#define    MultNode     72   /* '*'        */
#define    DivNode      73   /* '/'        */
#define    ModNode      74   /* 'mod'      */
#define    EXPNode      75   /* '**'       */
#define    NotNode      76   /* 'not'      */
#define    ReadNode     77   /* 'read'     */
#define    EOFNode      78   /* 'eof'      */
#define    IntegerNode  79   /* '<integer>'*/
#define    BooleanNode  80   /* '<boolean>'*/
#define    IdentifierNode 81 /* '<identifier>'*/
#define    ForUpNode      82 /* 'upfor'    */
#define    ForDownNode    83 /* 'downfor'  */ 
#define    SwapNode       84 /* 'swap'     */
#define    LoopNode       85 /* 'loop'     */
#define    ExitNode       86 /* 'exit'     */
#define    CaseNode       87 /* 'case'     */
#define    SwitchNode     88 /* 'switch'   */
#define    RangeNode      89 /* 'range'    */
#define    OtherwiseNode  90 /* 'otherwise'*/
#define    CharNode       91 /* '<char>'   */
#define    StringNode     92 /* '<string>' */
#define    SuccNode       93 /* 'succ'     */
#define    PredNode       94 /* 'pred'     */
#define    OrdNode        95 /* 'ord'      */
#define    ChrNode        96 /* 'chr'      */
#define    ConstsNode     97 /* 'consts'   */
#define    ConstNode      98 /* 'const'    */
#define    LitNode        99 /* 'lit'      */
#define    CharTNode     100 /* 'char'     */
#define    FunctionNode  101 /* 'fnc'      */
#define    ProcedureNode 102 /* 'proc'     */
#define    CallNode      103 /* 'call'     */
#define    ReturnNode    104 /* 'return'   */
#define    SubProgsNode  105 /* 'subprogs' */
#define    ParamsNode    106 /* 'params'   */

#define    NumberOfNodes 106 /* '<identifier>'*/
typedef int Mode;

FILE *CodeFile;
char *CodeFileName;
Clabel HaltLabel;

char *mach_op[] = 
    {"NOP","HALT","LIT","LLV","LGV","SLV","SGV","LLA","LGA",
     "UOP","BOP","POP","DUP","SWAP","CALL","RTN","GOTO","COND",
     "CODE","SOS","LIMIT","UNOT","UNEG","USUCC","UPRED","BAND",
     "BOR","BPLUS","BMINUS","BMULT","BDIV","BEXP","BMOD","BEQ",
     "BNE","BLE","BGE","BLT","BGT","TRACEX","DUMPMEM","INPUT",
     "INPUTC","OUTPUT","OUTPUTC","OUTPUTL","EOF"};

/****************************************************************** 
   add new node names to the end of the array, keeping in strict order
   as defined above, then adjust the j loop control variable in
   InitializeNodeNames(). 
*******************************************************************/
char *node_name[] =
    {"program","types","type","dclns","var","integer",
     "boolean","block","assign","output","if","while","repeat",
     "<null>","and","or","<","<=","=","<>",">=",">","+",
     "-","*","/","mod","**","not","read","eof","<integer>","<boolean>",
     "<identifier>","upfor","downfor","swap","loop","exit","case","switch",
     "range", "otherwise", "<char>", "<string>", "succ", "pred", "ord", "chr",
     "consts", "const", "lit", "char", "fnc", "proc", "call", "return", "subprogs", "params"  };


void CodeGenerate(int argc, char *argv[])
{
   int NumberTrees;

   InitializeCodeGenerator(argc,argv);
   Tree_File = Open_File("_TREE", "r"); 
   NumberTrees = Read_Trees();
   fclose (Tree_File);                     

   HaltLabel = ProcessNode (RootOfTree(1), NoLabel);
   CodeGen0 (HALTOP, HaltLabel); 

#if 0
  PrintAllStrings(stdout);
   PrintTree(stdout,RootOfTree(1));
#endif

   CodeFile = Open_File (CodeFileName, "w");
   DumpCode (CodeFile);
   fclose(CodeFile); 

   if (TraceSpecified)
      fclose (TraceFile);

/****************************************************************** 
  enable this code to write out the tree after the code generator
  has run.  It will show the new decorations made with MakeAddress().
*******************************************************************/


   Tree_File = fopen("_TREE", "w");  
   Write_Trees();
   fclose (Tree_File);                   
}


void InitializeCodeGenerator(int argc,char *argv[])
{
   InitializeMachineOperations();
   InitializeNodeNames();
   FrameSize = 0;
   CurrentProcLevel = 0;
   LabelCount = 0;
   CodeFileName = System_Argument("-code", "_CODE", argc, argv); 
}


void InitializeMachineOperations(void)
{
  int i,j;

   for (i=0, j=1; i < 47; i++, j++)
      String_Array_To_String_Constant (mach_op[i],j);
}



void InitializeNodeNames(void)
{
   int i,j;

   for (i=0, j=48; j <= NumberOfNodes; i++, j++)
      String_Array_To_String_Constant (node_name[i],j);
}



String MakeStringOf(int Number)
{
   Stack Temp;

   Temp = AllocateStack (50);
   ResetBufferInTextTable();
   if (Number == 0)
      AdvanceOnCharacter ('0');
   else
   {
      while (Number > 0)
      {
         Push (Temp,(Number % 10) + 48);
         Number /= 10;
      }

      while ( !(IsEmpty (Temp)))
         AdvanceOnCharacter ((char)(Pop(Temp)));
   }   
   return (ConvertStringInBuffer()); 
}  



void Reference(TreeNode T, Mode M, Clabel L)
{
   int Addr,OFFSET, Mode;
   String  Op;
   Addr = Decoration(Decoration(T));
   OFFSET = FrameDisplacement (Addr) ;
   Mode = Decoration(Child(Decoration(T),1));
   switch (M)
   {
      case LeftMode  :  DecrementFrameSize();
                        if (ProcLevel (Addr) == 0) 
                           Op = SGVOP;
                        else
                           Op = SLVOP;
	                break;
      case RightMode :  IncrementFrameSize();
                        if (NodeName(Mode) == ConstNode || NodeName(Mode) == LitNode)
                           Op = LITOP; 
                        else if (ProcLevel (Addr) == 0) 
                           Op = LGVOP;
          	        else
                           Op = LLVOP;
                        break;
   }
   if (M == RightMode && NodeName(Mode) == ConstNode) {
     CodeGen1(Op, OFFSET, L);
   } else {
     CodeGen1 (Op,MakeStringOf(OFFSET),L);
   }
  
}



int NKids (TreeNode T)
{
   return (Rank(T));
}


void Expression (TreeNode T, Clabel CurrLabel)
{
   int Kid;
   Clabel Label1;

   if (TraceSpecified)
   {
      fprintf (TraceFile, "<<< CODE GENERATOR >>> Processing Node ");
      Write_String (TraceFile, NodeName (T) );
      fprintf (TraceFile, " , Label is  ");
      Write_String (TraceFile, CurrLabel);
      fprintf (TraceFile, "\n");
   }

   switch (NodeName(T))
   {
      case ANDNode :
         Expression ( Child(T,1) , CurrLabel);
         Expression ( Child(T,2) , NoLabel);
         CodeGen1 (BOPOP, BAND, NoLabel);
         DecrementFrameSize();
         break;
      case ORNode :
         Expression ( Child(T,1) , CurrLabel);
         Expression ( Child(T,2) , NoLabel);
         CodeGen1 (BOPOP, BOR, NoLabel);
         DecrementFrameSize();
         break;
      case LTNode :
         Expression ( Child(T,1) , CurrLabel);
         Expression ( Child(T,2) , NoLabel);
         CodeGen1 (BOPOP, BLT, NoLabel);
         DecrementFrameSize();
         break;
      case LENode :
         Expression ( Child(T,1) , CurrLabel);
         Expression ( Child(T,2) , NoLabel);
         CodeGen1 (BOPOP, BLE, NoLabel);
         DecrementFrameSize();
         break;
      case EQNode :
         Expression ( Child(T,1) , CurrLabel);
         Expression ( Child(T,2) , NoLabel); 
         CodeGen1 (BOPOP, BEQ, NoLabel);
         DecrementFrameSize();
         break;
      case NEQNode :
         Expression ( Child(T,1) , CurrLabel);
         Expression ( Child(T,2) , NoLabel);
         CodeGen1 (BOPOP, BNE, NoLabel);
         DecrementFrameSize();
         break;
      case GENode :
         Expression ( Child(T,1) , CurrLabel);
         Expression ( Child(T,2) , NoLabel);
         CodeGen1 (BOPOP, BGE, NoLabel);
         DecrementFrameSize();
         break;
      case GTNode :
         Expression ( Child(T,1) , CurrLabel);
         Expression ( Child(T,2) , NoLabel);
         CodeGen1 (BOPOP, BGT, NoLabel);
         DecrementFrameSize();
         break;
      case PlusNode :
         Expression ( Child(T,1) , CurrLabel);
         if (Rank(T) == 2)
         {
            Expression ( Child(T,2) , NoLabel);
            CodeGen1 (BOPOP, BPLUS, NoLabel);
            DecrementFrameSize();
         }
         else
            CodeGen0 (NOP, NoLabel);
         break;

      case MinusNode :
         Expression ( Child(T,1) , CurrLabel);
         if (Rank(T) == 2)
         {
            Expression ( Child(T,2) , NoLabel);
            CodeGen1 (BOPOP, BMINUS, NoLabel);
            DecrementFrameSize();
         }
         else
            CodeGen1 (UOPOP, UNEG, NoLabel);
         break;

      case MultNode :
         Expression ( Child(T,1) , CurrLabel);
         Expression ( Child(T,2) , NoLabel);
         CodeGen1 (BOPOP, BMULT, NoLabel);
         DecrementFrameSize();
         break;
         
      case DivNode  :
         Expression ( Child(T,1) , CurrLabel);
         Expression ( Child(T,2) , NoLabel);
         CodeGen1 (BOPOP, BDIV, NoLabel);
         DecrementFrameSize();
         break;

      case ModNode  :
         Expression ( Child(T,1) , CurrLabel);
         Expression ( Child(T,2) , NoLabel);
         CodeGen1 (BOPOP, BMOD, NoLabel);
         DecrementFrameSize();
         break;

      case EXPNode  :
         Expression ( Child(T,1) , CurrLabel);
         Expression ( Child(T,2) , NoLabel);
         CodeGen1 (BOPOP, BEXP, NoLabel);
         DecrementFrameSize();
         break;

      case NotNode  :
         Expression ( Child(T,1) , CurrLabel);
         CodeGen1 (UOPOP, UNOT, NoLabel);
         break;

      case EOFNode :
         CodeGen1 (SOSOP, OSEOF, CurrLabel);
         IncrementFrameSize();
         break;

      case IntegerNode :
         CodeGen1 (LITOP, NodeName (Child(T,1)), CurrLabel);
         IncrementFrameSize();
         break;


      case BooleanNode : 
         CodeGen1 (LITOP, MakeStringOf(Character(NodeName(Child(T,1)),1) == 't'), CurrLabel);
	 IncrementFrameSize();
	 break;
      
      case IdentifierNode :
         Reference (T,RightMode,CurrLabel);
         break;

      case CharNode :
          CodeGen1 (LITOP, MakeStringOf(Character(NodeName(Child(T,1)), 2)), CurrLabel);
          IncrementFrameSize();
        break;

      case SuccNode :
      case PredNode :
        Expression(Child(T,1), CurrLabel);
        if (NodeName(T) == SuccNode)
          CodeGen1(UOPOP, USUCC, NoLabel);
        else
          CodeGen1(UOPOP, UPRED, NoLabel);
        if (NodeName(Decoration(T)) == TypeNode && Rank(Decoration(T)) == 2 && NodeName(Child(Decoration(T),2)) == LitNode) {
          Kid = Child(Decoration(T),2);
          CodeGen1(LITOP, MakeStringOf(0), NoLabel);
          CodeGen1(LITOP, MakeStringOf(Decoration(Child(Kid, Rank(Kid)))), NoLabel);
          CodeGen0(LIMITOP, NoLabel);
        }
        break;

      case OrdNode :
      case ChrNode :
        Expression(Child(T,1), CurrLabel);
        break;
     
      case CallNode :
        CodeGen1(LITOP, MakeStringOf(0), CurrLabel);
        IncrementFrameSize();
        Label1 = Decoration(Decoration(Child(Decoration(Child(T,1)), 1)));
        for (Kid = 2; Kid <= Rank(T); Kid++) 
          Expression(Child(T, Kid), NoLabel);
        CodeGen1(CODEOP, Label1, NoLabel);
        for (Kid = 2; Kid <= Rank(T); Kid++)
          DecrementFrameSize();
        CodeGen1(CALLOP, MakeStringOf(FrameSize-1), NoLabel);
        break;

      default :
         ReportTreeErrorAt(T);
         printf ("<<< CODE GENERATOR >>k> : UNKNOWN NODE NAME ");
         Write_String (stdout,NodeName(T));
         printf ("\n");

   } /* end switch */
} /* end Expression */



Clabel ProcessNode (TreeNode T, Clabel CurrLabel)
{
   int Kid, Num, Kid2, i;
   Clabel Label1, Label2, Label3, LabelTemp;

   if (TraceSpecified)
   {
      fprintf (TraceFile, "<<< CODE GENERATOR >>> Processing Node ");
      Write_String (TraceFile, NodeName (T) );
      fprintf (TraceFile, " , Label is  ");
      Write_String (TraceFile, CurrLabel);
      fprintf (TraceFile, "\n");
   }
   switch (NodeName(T))
   {
      case ProgramNode :
         for (Kid = 2; Kid <= 5; Kid++)
           CurrLabel = ProcessNode (Child(T,Kid),CurrLabel);
         Label1 = MakeLabel();
         CodeGen1(GOTOOP, Label1, CurrLabel);
         ProcessNode(Child(T,6), NoLabel);
         CurrLabel = ProcessNode(Child(T,7), Label1);
         return (CurrLabel);

      case ConstsNode :
      case DclnsNode :
         for (Kid = 1; Kid <= NKids(T); Kid++)
            CurrLabel = ProcessNode (Child(T,Kid), CurrLabel);
         if (NKids(T) > 0)
            return (NoLabel);
         else
            return (CurrLabel);

      case ConstNode :
        Kid = Decoration(Child(Decoration(Child(T,2)),1));
        if (NodeName(Child(T,2)) == IntegerNode) 
          Decorate(Child(T,1), NodeName(Child(Child(T,2),1)));
        else if (NodeName(Child(T,2)) == CharNode) 
          Decorate(Child(T,1), MakeStringOf(Character(NodeName(Child(Child(T,2),1)), 2)));
         else if (NodeName(Kid) == LitNode)
          Decorate(Child(T,1), MakeStringOf(Decoration(Decoration(Child(T,2)))));
        else if (NodeName(Kid) == ConstNode)
          Decorate(Child(T,1), Decoration(Decoration(Child(T,2))));
        
        return (CurrLabel);


      case FunctionNode:
       OpenFrame();
       Decorate(Child(T,1), MakeAddress());
       IncrementFrameSize();
       Label1 = MakeLabel();
       Decorate(T, Label1);
       ProcessNode(Child(T,2), CurrLabel);
       for (Kid = 4; Kid <= 7; Kid++) {
         if (Kid == 6)
           CurrLabel = ProcessNode(Child(T,Kid), Label1);
         else
           CurrLabel = ProcessNode(Child(T,Kid), CurrLabel);
       }
       CodeGen1(LLVOP, MakeStringOf(0), CurrLabel);
       CodeGen1(RTNOP, MakeStringOf(1), NoLabel);
       
       CloseFrame();
       return (NoLabel);
      case ProcedureNode:
        OpenFrame();
        Decorate(Child(T,1), MakeAddress());
        IncrementFrameSize();
        Label1 = MakeLabel();
        Decorate(T, Label1);

        ProcessNode(Child(T,2), CurrLabel);
        
        for (Kid = 3; Kid <= 6; Kid++) {
          if (Kid == 5)
            CurrLabel = ProcessNode(Child(T, Kid), Label1);
          else
            CurrLabel = ProcessNode(Child(T, Kid), CurrLabel);
        }
        CodeGen1(LLVOP, MakeStringOf(0), CurrLabel);
        CodeGen1(RTNOP, MakeStringOf(0), NoLabel);
        CloseFrame();
	return (NoLabel);
      case ReturnNode:
        if (Rank(T) > 0) 
          Expression(Child(T,1), CurrLabel);
        else
          CodeGen0(NOP, CurrLabel);
        CodeGen1(RTNOP, MakeStringOf(1), NoLabel);
        DecrementFrameSize();       
        return (NoLabel);

      case CallNode :
        Expression(T, CurrLabel);
        DecrementFrameSize();
        return (NoLabel);

      case VarNode :
         for (Kid = 1; Kid < NKids(T); Kid++)
         {
            if (Kid != 1)
               CodeGen1 (LITOP,MakeStringOf(0),NoLabel);
            else
               CodeGen1 (LITOP,MakeStringOf(0),CurrLabel);
            Num = MakeAddress();
            Decorate ( Child(T,Kid), Num);
            IncrementFrameSize();
         }
         return (NoLabel);

      case TypeNode :
        if (Rank(T) == 2 && NodeName(Child(T,2)) == LitNode) {
          for (Kid = 1; Kid <= Rank(Child(T,2)); Kid++) {
            Decorate(Child(Child(T,2),Kid), Kid-1);
          }
        }
        return (CurrLabel);
      

      case SubProgsNode :
      case ParamsNode :
      case TypesNode :
      case BlockNode :
         for (Kid = 1; Kid <= NKids(T); Kid++)
            CurrLabel = ProcessNode (Child(T,Kid), CurrLabel);
         return (CurrLabel);



      case AssignNode :
         Expression (Child(T,2), CurrLabel);
         Reference (Child(T,1), LeftMode, NoLabel);
         return (NoLabel);

      case SwapNode :
         Reference (Child(T,1), RightMode, CurrLabel);
         Reference (Child(T,2), RightMode, NoLabel);
         Reference (Child(T,1), LeftMode, NoLabel);
	 Reference (Child(T,2), LeftMode, NoLabel);
         return (NoLabel);


      case OutputNode :
         for (Kid = 1; Kid <= NKids(T); Kid++)
         {
              Kid2 = Decoration(Child(Decoration(Child(T,Kid)), 1));
              if (NodeName(Kid2) == VarNode || NodeName(Kid2) == ConstNode)
                Kid2 = Child(Kid2, Rank(Kid2));
              else if (NodeName(Child(T,Kid)) == OrdNode || NodeName(Child(T,Kid)) == SuccNode || NodeName(Child(T,Kid)) == PredNode || NodeName(Child(T,Kid)) == ChrNode) {
                Kid2 = Child(Decoration(Child(T,Kid)), 1); 
              } else
                Kid2 = Child(T,Kid); 
            if (NodeName(Child(T,Kid)) == StringNode) {
              Num = 2;
              while (Character(NodeName(Child(Child(T,Kid),1)), Num) != '\"') {
                Kid2 = Character(NodeName(Child(Child(T,Kid),1)), Num);
                if (Kid2 == '\\' && (Character(NodeName(Child(Child(T,Kid),1)), Num+1) == 't')) {
                  for (i = 0; i < 8; i++) {
                    CodeGen1 (LITOP, MakeStringOf(' '), CurrLabel);
                    IncrementFrameSize();
                    CurrLabel = NoLabel;
                    CodeGen1 (SOSOP, OSOUTPUTC, NoLabel);
                    DecrementFrameSize();
                  }
                  Num++;
                } else {
                  CodeGen1 (LITOP, MakeStringOf(Character(NodeName(Child(Child(T,Kid),1)), Num)), CurrLabel);
                  CurrLabel = NoLabel;
                  IncrementFrameSize();
                  CodeGen1 (SOSOP, OSOUTPUTC, NoLabel);
                  DecrementFrameSize();
                }
                Num++;
              }
            } else if (NodeName(Kid2) == CharNode || NodeName(Child(Kid2,1)) == CharTNode) {  
              Expression (Child(T,Kid), CurrLabel);
              CurrLabel = NoLabel;
              CodeGen1 (SOSOP, OSOUTPUTC, NoLabel);
             /* CodeGen1 (LITOP, MakeStringOf(' '), NoLabel);
              CodeGen1 (SOSOP, OSOUTPUTC, NoLabel);*/
              DecrementFrameSize();
            } else { 
              Expression (Child(T,Kid), CurrLabel);
              CurrLabel = NoLabel;
              CodeGen1 (SOSOP, OSOUTPUT, NoLabel);
              DecrementFrameSize();
            }
         }
         CodeGen1 (SOSOP, OSOUTPUTL, NoLabel);
         return (NoLabel);

      case ReadNode :
         for (Kid = 1; Kid <= Rank(T); Kid++) {
           Num = Child(Child(Decoration(Child(Decoration(Child(T,Kid)), 1)), Rank(Decoration(Child(Decoration(Child(T,Kid)), 1)))), 1);
           if ( NodeName(Num) == IntegerTNode)
             CodeGen1(SOSOP, OSINPUT, CurrLabel);
           else 
             CodeGen1(SOSOP, OSINPUTC, CurrLabel);
           
           CurrLabel = NoLabel;
           Reference (Child(T,Kid), LeftMode, NoLabel);
           
         }
         IncrementFrameSize();
         return (NoLabel);

      case IfNode :
         Expression (Child(T,1), CurrLabel);
         Label1 = MakeLabel();
         Label2 = MakeLabel();
         Label3 = MakeLabel();
         CodeGen2 (CONDOP,Label1,Label2, NoLabel);
         DecrementFrameSize();
         CodeGen1 (GOTOOP, Label3, ProcessNode (Child(T,2), Label1) );
         if (Rank(T) == 3)
            CodeGen0 (NOP, ProcessNode (Child(T,3),Label2));
         else
            CodeGen0 (NOP, Label2);
         CodeGen0 (NOP, Label3);
         return (NoLabel);   

       case WhileNode :
          if (CurrLabel == NoLabel) 
             Label1 = MakeLabel();
          else 
             Label1 = CurrLabel;
	 Label2 = MakeLabel();
         Label3 = MakeLabel();
         Expression (Child(T,1), Label1);
         CodeGen2 (CONDOP, Label2, Label3, NoLabel);
         DecrementFrameSize();
         CodeGen1 (GOTOOP, Label1, ProcessNode (Child(T,2), Label2) );
         return (Label3);

       case ForDownNode :
       case ForUpNode :
	 Expression(Child(T,2), CurrLabel);
         Reference(Child(T,1), LeftMode, NoLabel);
	 Label1 = MakeLabel();
	 Label2 = MakeLabel();
	 Label3 = MakeLabel();
	 Expression (Child(T,3), Label1);
	 Expression (Child(T,1),  NoLabel);
         if (NodeName(T) == ForUpNode)
	    CodeGen1 (BOPOP, BGE, NoLabel);
         else
            CodeGen1 (BOPOP, BLE, NoLabel);
	 DecrementFrameSize();
	 CodeGen2 (CONDOP, Label2, Label3, NoLabel);
	 DecrementFrameSize();
	 CurrLabel = ProcessNode(Child(T, 4), Label2);
 
 	 Expression (Child(T,1), CurrLabel);
         if (NodeName(T) == ForUpNode)
	    CodeGen1(UOPOP, USUCC, NoLabel);
         else 
            CodeGen1(UOPOP, UPRED, NoLabel);
	 Reference (Child(T,1), LeftMode, NoLabel);
	 CodeGen1(GOTOOP, Label1, NoLabel);
	 CodeGen1(LITOP, MakeStringOf(0), Label3);
	 Reference (Child(T,1), LeftMode, NoLabel);
       return (NoLabel);

       case RepeatNode :
          if (CurrLabel == NoLabel)
             Label1 = MakeLabel();
          else
             Label1 = CurrLabel;
          Label2 = ProcessNode(Child(T,1), Label1);
          for (Kid = 2; Kid < Rank(T); Kid++) {
             Label2 = ProcessNode(Child(T,Kid), Label2);
          }
	  Expression(Child(T,Rank(T)), Label2);
          Label2 = MakeLabel();
          CodeGen2 (CONDOP, Label2, Label1, NoLabel); 
	  DecrementFrameSize();
          return (Label2);
        
       case LoopNode :
          Label1 = (CurrLabel == NoLabel) ? MakeLabel() : CurrLabel;
          Label3 = MakeLabel();
          Decorate (T, Label3);
          Label2 =  ProcessNode(Child(T,1), Label1);
	  for (Kid = 2; Kid <= Rank(T); Kid++) {
	    Label2 = ProcessNode(Child(T,Kid), Label2);
	  }
	  CodeGen1 (GOTOOP, Label1, Label2);
          CodeGen1 (GOTOOP, Label3, NoLabel);
          return (Label3);
 
       case ExitNode :
	  Label1 = Decoration(Decoration(T));
          CodeGen1 (GOTOOP, Label1, CurrLabel);
          return NoLabel;     

       case CaseNode :
          Label2 = CurrLabel;
          Label3 = MakeLabel();
             
          for (Kid = 2; Kid <= Rank(T); Kid++) { 
              if (NodeName(Child(T,Kid)) == SwitchNode) {
                 Expression(Child(T,1), Label2);
                 Expression (Child(Child(Child(T,Kid), 1),1), NoLabel);
                 if (Rank(Child(Child(T,Kid),1)) == 1) {
                    CodeGen1(BOPOP, BEQ, NoLabel);
                    DecrementFrameSize();
                 } else  {
                    Expression (Child(T,1), NoLabel);
                    CodeGen1(BOPOP, BLE, NoLabel);
                    DecrementFrameSize();
                    CodeGen0(SWAPOP, NoLabel);
                    Expression(Child(Child(Child(T,Kid),1),2), NoLabel);
                    CodeGen1(BOPOP, BLE, NoLabel);
                    DecrementFrameSize();
                    CodeGen1(BOPOP, BAND, NoLabel);
                    DecrementFrameSize();
                 }
                 Label1 = MakeLabel();
                 Label2 = Rank(T) == Kid ? Label3:MakeLabel();
                 
                 CodeGen2(CONDOP, Label1, Label2, NoLabel);
                 DecrementFrameSize();
                 CurrLabel = ProcessNode(Child(Child(T,Kid),2), Label1);
                 CodeGen1(GOTOOP, Label3, CurrLabel); 
                 
              } else if (NodeName(Child(T,Kid)) == OtherwiseNode) {
                 if (NodeName(Child(Child(T,Kid),1)) != NullNode)
                   Label2 = ProcessNode(Child(Child(T,Kid), 1), Label2);
                 else {
                   CodeGen0(NOP, Label2);
                 }
              }
          }
          return (Label3);

       case NullNode : return(CurrLabel);
           
      default :
              ReportTreeErrorAt(T);
              printf ("<<< CODE GENERATOR >>> : UNKNOWN NODE NAME ");
              Write_String (stdout,NodeName(T));
              printf ("\n");

   } /* end switch */
}   /* end ProcessNode */
