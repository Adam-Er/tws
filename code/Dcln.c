/******************************************************************

        D E C L A R A T I O N  T A B L E   M O D U L E

*******************************************************************

AN EXAMPLE:

begin                  OpenScope
      Dx               DTEnter (x,1).  The 1 means tree location 1.
      Dy               DTEnter (y,2).  This is tree location 2.
      begin            OpenScope.
            Dx         DTEnter (x,3).  This is tree location 3.
            Ux         Lookup (x) should return 3.
            begin      OpenScope.
                  Dx   DTEnter (x,4).  This is tree location 4.
                  Dz   DTEnter (z,5).  This is tree location 5.
                  Dx   DTEnter (x,6).  This should be an ERROR!
                  Ux   Lookup (x) should return 4.
                  Uy   Lookup (y) should return 2.
            end        CloseScope.
            Ux         Lookup (x) should return 3.
      end              CloseScope.
      Ux               Lookup (x) should return 1.
end                    CloseScope.
     

    Current_Dcln         Name   Prior   Dcln
  -----------------    -----------------------
                     1    0
  -----------------    -----------------------
y        3           2    x       0      1
  -----------------    -----------------------
x        7           3    y       0      2
  -----------------    -----------------------
                     4            1            LastDeclaration: 8
  -----------------    -----------------------
w                    5    x       2      3     CurrentScope: 6
  -----------------    -----------------------
                     6            4
  -----------------    -----------------------
z        8           7    x       5      4
  -----------------    -----------------------
                     8    z       0      5
  -----------------    -----------------------
                        
----------------------------------------------------------





	Visible portions of the module:

	struct DclnStorage {
	   Stack CurrentDcln;
	   Stack Name;
	   Stack Prior;
	   Stack Dcln;
	 }*DclnTable;

	extern int CurrentScope, LastDeclaration;

	extern InitializeDeclarationTable();
                - Initializes the Declaration Table.

	extern DTEnter();
                - Enter name S into the current scope, with tree node T.
                  The constrainer uses this procedure to enter
                  declarations as it encounters them.  The tree node is
                  that in which the declaration occurred.

	extern TreeNode Lookup();
            -  Returns the tree node in which the current declaration
                  of S occurred.

	extern OpenScope();
                -  Opens a declaration scope.

	extern CloseScope();
                -  Closes the current scope.


	extern boolean IsLocal();
                - Returns true only if S has been declared in
                  the current scope.

****************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <header/CommandLine.h>
#include <header/Table.h>
#include <header/Text.h>
#include <header/Error.h>
#include <header/String_Input.h>
#include <header/Tree.h>
#include <header/Dcln.h>

int CurrentScope, LastDeclaration;


void InitializeDeclarationTable(void)
{
   DclnTable = (struct DclnStorage *)
                   malloc(sizeof(struct DclnStorage));

   if(DclnTable == NULL) 
   {
      printf("Not enough Memory !!! \n");
      exit(1);
   }

   DclnTable->CurrentDcln = AllocateStack(500);
   DclnTable->Name = AllocateStack(500);
   DclnTable->Prior = AllocateStack(500);
   DclnTable->Dcln = AllocateStack(500);

   CurrentScope = NullScope;
   LastDeclaration = NullDeclaration;
} 
     

void DTEnter(String S, TreeNode T, TreeNode Source)
{
   if(Element(DclnTable->CurrentDcln,S) > CurrentScope) 
   {
      printf("<<< CONSTRAINER ERROR >>> AT ");
      WriteString(stdout, SourceLocation(Source));
      printf(" : ");
      WriteString(stdout, S); 
      printf("ALREADY DECLARED IN THIS BLOCK !!\n");
   }

   else 
   {
      LastDeclaration ++ ; 
      Assign(DclnTable->Name, LastDeclaration, S);
      Assign(DclnTable->Prior, LastDeclaration, 
	      Element(DclnTable->CurrentDcln,S));
      Assign(DclnTable->Dcln, LastDeclaration, T);
      Assign(DclnTable->CurrentDcln, S, LastDeclaration);
   }
}


TreeNode Lookup(String S, TreeNode Source)
{
   TreeNode Temp;

   if(Element(DclnTable->CurrentDcln, S) == NullDeclaration)
   { 
      printf("<<< CONSTRAINER ERROR >>> AT ");
      WriteString ( stdout, SourceLocation (Source));
      printf(" : <identifier> ");
      WriteString ( stdout, S );
      printf ( " NOT DECLARED.\n");
      Temp = NullDeclaration;
   }

   else 
      Temp = Element(DclnTable->Dcln,
	             Element(DclnTable->CurrentDcln, S));

   return Temp;
}


void OpenScope(void)
{
   LastDeclaration ++; 
   Assign ( DclnTable->Prior, LastDeclaration, CurrentScope );
   CurrentScope = LastDeclaration;
}


void CloseScope(void)
{
   int i;

   if(CurrentScope == NullScope) 
   { 
      printf("<<< ERROR >>>: ");
      printf("  TRIED TO CLOSE TOO MANY SCOPES ");
   }

   for(i=CurrentScope+1; i<= LastDeclaration; i++)
   {
      Assign(DclnTable->CurrentDcln, 
	     Element(DclnTable->Name, i),
             Element(DclnTable->Prior,i));
   }

   LastDeclaration =  CurrentScope - 1; 
   CurrentScope = Element(DclnTable->Prior, CurrentScope);
}

boolean IsLocal(String S)
{
  return (Element(DclnTable->CurrentDcln, S) > CurrentScope);
}
  
void PrintDclnTable(FILE *file)
{
   int i,k,largest;
   fprintf(file,"DCLN TABLE:\n");
   fprintf(file,"LastDeclaraton: %d\n", LastDeclaration);
   fprintf(file,"CurrentScope:   %d\n", CurrentScope);
   fprintf(file,"\tCurDcl\tName\tPrior\tDcln\n");
   fprintf(file,"------------------------------------\n");
   largest=0;
   for (i=1; i <= LastDeclaration; i++)
   {
      k= Element(DclnTable->Name,i);
      if (k > largest) largest = k;
   }
   k=largest>LastDeclaration?largest:LastDeclaration;
   
   for (i=1; i <= k; i++)
   {
      fprintf(file,"%2d:\t",i);
      if (i<=largest)
      if (Element(DclnTable->CurrentDcln,i)==NullDeclaration)
         fprintf(file,"\t");
      else 
         fprintf(file,"%2d\t",Element(DclnTable->CurrentDcln,i));
      else 
         fprintf(file,"\t");
      if (i<=LastDeclaration)
      {
         fprintf(file,"%2d\t", Element(DclnTable->Name,i));
         fprintf(file,"%2d\t", Element(DclnTable->Prior,i));
         fprintf(file,"%2d\n", Element(DclnTable->Dcln,i));
      }
      else fprintf(file,"\n");
      if (i==LastDeclaration)
         fprintf(file,"               ---------------------\n");
   }
   fprintf(file,"END DCLN TABLE\n------------------------------------\n");

}
