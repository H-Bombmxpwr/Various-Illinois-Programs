#include "sudoku.h"
#include <stdio.h>

//-------------------------------------------------------------------------------------------------
// Start here to work on your MP7
//-------------------------------------------------------------------------------------------------

// You are free to declare any private functions if needed.


/*
 *                               					   INTRODUCTION PARAGRAPH
 *  			   					By: Hunter Baisden, baisden2    PARTNER sof2
 *
 * The firtst step of this program was to make 3 different check functions to check if a value could be placed in a given row/column/3x3 grid. The first 2, the row and
 * column were rather simple, just a simple for loop to iterate over the give row or column and check to see if the sent in value showed up anywhere else in the code. 
 * The 3x3 grid function was a bit mroe tricky, because the first thing you have to do is figure out what grid is being sent in. To do this I declared 2 variables,
 * istart and jstart that served as pointers to where the grid started. Then to actuall check the grid I used the function sudoku[istart + (f%3)][jstart + (f/3)] == val
 * where f is the iterating variable in the for loop. f%3 will always be in between 0 and 2, which when added to the istart, will give the row of the grid. f/3 will be
 * either 0,1,2, which when added to the jstart value, will give the current column of the grid. I then called these three functions in the is_val_valid() function to
 * see if a value could be fit inside of the given space. Then it was off to the solve_sudoku() function. I first started with the end contition, if all of the values 
 * are filled. To check this I iterated over every value and checked to see if it was greater than 0. If it was I added 1 to a counter. If at the end the counter was 
 * equal to 81, I know that every value has been filled and I return 1. However, if not every value is filled the program then finds the cell coordinates of the cell 
 * with 0 in it closest to the bottom right. It then tests the values 1-9 in that cell using the is_val_valid() function to see if it will fit. If it does, it sets the 
 * working value as sudoku[i][j]. It then calls itself to move on to the next value. If the puzzle is unsolveable, it will return 0 at the very end. That is about it 
 * as far as the code is concerned in this mp. 
 */



// Function: is_val_in_row
// Return true if "val" already existed in ith row of array sudoku.
int is_val_in_row(const int val, const int i, const int sudoku[9][9]) {

  assert(i>=0 && i<9);

  // BEG TODO
  // iterates over every value in the row comparing it to val 
for( int f  = 0; f < 9; f++) {

	if( sudoku[i][f] == val ) {
		return 1;
	}

}
return 0;

}
  // END TODO


// Function: is_val_in_col
// Return true if "val" already existed in jth column of array sudoku.
int is_val_in_col(const int val, const int j, const int sudoku[9][9]) {

  assert(j>=0 && j<9);

  // BEG TODO
 // iterates over every value in the column comparing it to val 
for( int f  = 0; f < 9; f++) {

	if( sudoku[f][j] == val ) {
		return 1;
	}


}
  return 0;
}
  // END TODO


// Function: is_val_in_3x3_zone
// Return true if val already existed in the 3x3 zone corresponding to (i, j)
int is_val_in_3x3_zone(const int val, const int i, const int j, const int sudoku[9][9]) {
   
  assert(i>=0 && i<9);
  // iterates over every value in the grid comparing it to val 
  // BEG TODO
  
int istart = (i/3) * 3;
int jstart = (j/3) * 3; 

for( int f  = 0; f < 9; f++) {

	if( sudoku[istart + (f%3)][jstart + (f/3)] == val ) {
		return 1;
	}


}
  return 0;




  // END TODO
}

// Function: is_val_valid
// Return true if the val is can be filled in the given entry.
int is_val_valid(const int val, const int i, const int j, const int sudoku[9][9]) {

  assert(i>=0 && i<9 && j>=0 && j<9);

  // BEG TODO
 // calls the previous 3 functions to check if a value is valid or not
if( is_val_in_col(val,j,sudoku) == 0 && is_val_in_row(val,i,sudoku) == 0 && is_val_in_3x3_zone(val,i,j,sudoku) == 0) {
	return 1;
}



  // END TODO
}

// Procedure: solve_sudoku
// Solve the given sudoku instance.
int solve_sudoku(int sudoku[9][9]) {

  // BEG TODO.

int i = 0;
int j = 0;
int count = 0;

for( i = 0; i < 9; i++) {

	for( j = 0; j < 9; j++) {

		if( sudoku[i][j] >= 1 ) {
			count++; 
		}
	}
}

if( count == 81) {
	return 1;
}

// above was checking if the puzzle is full or not
// below is now finding a the i,j of a value that is currently 0 in the program
int celli;
int cellj;

for( i = 0; i < 9; i++) {

	for( j = 0; j < 9; j++) {
		if( sudoku[i][j] == 0 ) {
			celli = i;
			cellj = j;
			
		}
	}
}

// This is putting a value from 1 through 9 and checking if it is correct
for( int num = 1; num <= 9; num++) {

	if( is_val_valid(num, celli, cellj, sudoku) == 1) {
		sudoku[celli][cellj] = num;
		
		if(solve_sudoku(sudoku)) {
			return 1;
		}
		
		sudoku[celli][cellj] = 0;
	}
}

		


  return 0;
  // END TODO.
}

// Procedure: print_sudoku
void print_sudoku(int sudoku[9][9])
{
  int i, j;
  for(i=0; i<9; i++) {
    for(j=0; j<9; j++) {
      printf("%2d", sudoku[i][j]);
    }
    printf("\n");
  }
}

// Procedure: parse_sudoku
void parse_sudoku(const char fpath[], int sudoku[9][9]) {
  FILE *reader = fopen(fpath, "r");
  assert(reader != NULL);
  int i, j;
  for(i=0; i<9; i++) {
    for(j=0; j<9; j++) {
      fscanf(reader, "%d", &sudoku[i][j]);
    }
  }
  fclose(reader);
}





