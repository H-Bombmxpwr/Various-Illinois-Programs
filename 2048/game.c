#include "game.h"

/*                                                                 =-= INTRO PARAGRAPH =-=
 *                                        by Hunter Baisden, netID = basiden2 || PARTNERS netIDs = sof2, alfarj3
 *
 * The first function that was needed for this program was the make_game() function. This function was rather trivial to make, simplfy taking the pointer mygame and 
 * use it to assign all of the starting values to the program, the passed in cols and rows, as well as every cell to -1. It also sets the score to 0. The second
 * function uses the exact same algorithm but instead of making a pointer mygame, we are given a pointer to an existing game that we want to reset. This follows
 * the same idea but we just have to dereference the passed in pointer once to make sure the function works correctly. Next is the get_cell() funciton. This function 
 * returns a pointer to a given cell on the board. In order to accomplish this I simply defined a pointer, and then made sure that the given (row, col) combination 
 * worked and then found a pointer to it using the '&' operator. Next were the move functions. They all operated on the principle. They first iterate oover all of the
 * columns and rows and use a temp  variable tarpoint to determine where the max distance they can 'slide' to. The next part is the merge function that merges the two 
 * cells together, combining their values. It finally iterates one more time through to clean up what was left behind and slide all not merging tiles. This is done 
 * in very similiar ways between w,a,s, and d. The only differences are the directions of the itertations of the for loops, and weather i+- 1 or j+-1 is in the merge
 * section of the code. Finally there is the check_legal() fucntion that makes a copy of the given game and stores it into dup. If you can make any legal moves in any 
 * of the 4 move functions then it will return 1, or if( move_w(dup) || move_a(dup) || move_d(dup) || move_s(dup) ) {return 1;}. It used a duplicate of the game as 
 * the move functions do modify the game, and when we are checking we do not want to modify the game. Finally, the move_letter() functions also increment the score 
 * by whatever the value of the merged tile was.  
 */

game * make_game(int rows, int cols)
/*! Create an instance of a game structure with the given number of rows
    and columns, initializing elements to -1 and return a pointer
    to it. (See game.h for the specification for the game data structure) 
    The needed memory should be dynamically allocated with the malloc family
    of functions.
*/
{
    //Dynamically allocate memory for game and cells (DO NOT modify this)
    game * mygame = malloc(sizeof(game));
    mygame->cells = malloc(rows*cols*sizeof(cell));

    //YOUR CODE STARTS HERE:  Initialize all other variables in game struct

	mygame->rows = rows;
	mygame->cols = cols;
	mygame->score = 0;
	int v;

	for(v = 0; v < rows*cols; v++) {

		mygame-> cells[v] = -1;
	}

    return mygame;
}

void remake_game(game ** _cur_game_ptr,int new_rows,int new_cols)
/*! Given a game structure that is passed by reference, change the
	game structure to have the given number of rows and columns. Initialize
	the score and all elements in the cells to -1. Make sure that any 
	memory previously allocated is not lost in this function.	
*/
{
	/*Frees dynamically allocated memory used by cells in previous game,
	 then dynamically allocates memory for cells in new game.  DO NOT MODIFY.*/
	free((*_cur_game_ptr)->cells);
	(*_cur_game_ptr)->cells = malloc(new_rows*new_cols*sizeof(cell));

	 //YOUR CODE STARTS HERE:  Re-initialize all other variables in game struct

	(*_cur_game_ptr)->rows = new_rows;
	(*_cur_game_ptr)->cols = new_cols;
	(*_cur_game_ptr)->score = 0;
	int v;

	for(v = 0; v < new_rows*new_cols; v++) {

		(*_cur_game_ptr)-> cells[v] = -1;
	}



	return;	
}

void destroy_game(game * cur_game)
/*! Deallocate any memory acquired with malloc associated with the given game instance.
    This includes any substructures the game data structure contains. Do not modify this function.*/
{
    free(cur_game->cells);
    free(cur_game);
    cur_game = NULL;
    return;
}

cell * get_cell(game * cur_game, int row, int col)
/*! Given a game, a row, and a column, return a pointer to the corresponding
    cell on the game. (See game.h for game data structure specification)
    This function should be handy for accessing game cells. Return NULL
	if the row and col coordinates do not exist.
*/
{
    //YOUR CODE STARTS HERE


int *pointer;

	if((cur_game->rows > row) && (cur_game->cols > col)) {
		 pointer = &cur_game->cells[row * (cur_game->cols) + col];
		 return pointer;
	}

	else{
  		return NULL;
	}
	

}

int move_w(game * cur_game)
/*!Slides all of the tiles in cur_game upwards. If a tile matches with the 
   one above it, the tiles are merged by adding their values together. When
   tiles merge, increase the score by the value of the new tile. A tile can 
   not merge twice in one turn. If sliding the tiles up does not cause any 
   cell to change value, w is an invalid move and return 0. Otherwise, return 1. 
*/
{
    //YOUR CODE STARTS HERE


// the 4 move commands are very similair, so I will mainly comment this one and they carry over to all 4
int i;
int j;
int tarpoint;   //temp variable/pointer that is the "target" row or coloumn depending on where we are shifting
int numc = cur_game->cols;  // storing the number of cols for the current game to save typing

int can_merge = 0;

for( j = 0; j < numc; j++) {
	
	for(i = 0; i < cur_game->rows; i++) {
		
		if(cur_game->cells[i*numc + j] !=  -1){  // checking to make sure the value in the cell is not -1

			for(tarpoint = 0; tarpoint < i; tarpoint++) {
	
				if(cur_game->cells[tarpoint*numc + j] == -1) { // shifting the values to the availible space in that was found above
	
					cur_game->cells[tarpoint*numc + j] = cur_game->cells[i*numc + j];
					cur_game->cells[i*numc + j] = -1;
					can_merge = 1; // can merge is true,
					break;
				}
			}
		}
	}
}


//this is the merging function
for( i = 0; i < cur_game->rows; i++) {
	
	for(j = 0; j < numc; j++) {
		
		 if(cur_game->cells[i * numc + j] == cur_game->cells[(i+1) * numc + j] && cur_game->cells[i * numc + j] != -1) {
	
			cur_game->cells[i*numc + j] = 2*(cur_game->cells[i*numc + j]); //sets the tile that was contacted to 2 times or merging the tiles
			cur_game->score = cur_game->cells[i*numc + j] + cur_game->score;  // incrementing the score
			cur_game->cells[(i+1)*numc + j ] = -1; // fixing the tile left behind to -1
			can_merge = 1;
		}
	}
}

// running the shift again after the tiles have been merged, the only difference is a can_merge value is not set, as it has already been set to 1 if the cells can merge. 
for( j = 0; j < numc; j++) {
	
	for(i = 0; i < cur_game->rows; i++) {
		
		if(cur_game->cells[i*numc + j] !=  -1){  

			for(tarpoint = 0; tarpoint < i; tarpoint++) {
	
				if(cur_game->cells[tarpoint*numc + j] == -1) {
	
					cur_game->cells[tarpoint*numc + j] = cur_game->cells[i*numc + j];
					cur_game->cells[i*numc + j] = -1;
					break;
				}
			}
		}
	}
}


return can_merge;


};

int move_s(game * cur_game) //slide down
{
    //YOUR CODE STARTS HERE

int i;
int j;
int tarpoint;
int numc = cur_game->cols;

int can_merge = 0;

for( j = 0; j < numc; j++) {
	
	for(i = cur_game->rows - 1; i >= 0; i--) {
		
		if(cur_game->cells[i*numc + j] != -1){  

			for(tarpoint = (cur_game->rows) - 1; tarpoint > i; tarpoint--) {
	
				if(cur_game->cells[tarpoint*numc + j] == -1) {
	
					cur_game->cells[tarpoint*numc + j] = cur_game->cells[i*numc + j];
					cur_game->cells[i*numc + j] = -1;
					can_merge = 1;
					break;
				}
			}
		}
	}
}



for( j = 0; j < numc; j++) {
	
	for(i = cur_game->rows - 1; i >= 0; i--) {
		
		 if(cur_game->cells[i * numc + j] == cur_game->cells[(i-1) * numc + j] && cur_game->cells[i * numc + j] != -1) {
	
			cur_game->cells[i*numc + j] = 2*(cur_game->cells[i*numc + j]);
			cur_game->score = cur_game->cells[i*numc + j] + cur_game->score;
			cur_game->cells[(i-1)*numc + j] = -1;
			can_merge = 1;
		}
	}
}


for( j = 0; j < numc; j++) {
	
	for(i = cur_game->rows - 1; i >= 0; i--) {
		
		if(cur_game->cells[i*numc + j] != -1){  

			for(tarpoint = (cur_game->rows) - 1; tarpoint > i; tarpoint--) {
	
				if(cur_game->cells[tarpoint*numc + j] == -1) {
	
					cur_game->cells[tarpoint*numc + j] = cur_game->cells[i*numc + j];
					cur_game->cells[i*numc + j] = -1;
					break;
				}
			}
		}
	}
}

return can_merge;

};

int move_a(game * cur_game) //slide left
{
    //YOUR CODE STARTS HERE


int i;
int j;
int tarpoint;
int numc = cur_game->cols;

int can_merge = 0;

for( i = 0; i < cur_game->rows; i++) {
	
	for(j = 0; j < numc; j++) {
		
		if(cur_game->cells[i*numc + j] !=  -1){  

			for(tarpoint = 0; tarpoint < j; tarpoint++) {
	
				if(cur_game->cells[i*numc + tarpoint] == -1) {
	
					cur_game->cells[i*numc + tarpoint] = cur_game->cells[i*numc + j];
					cur_game->cells[i*numc + j] = -1;
					can_merge = 1;
					break;
				}
			}
		}
	}
}



for( i = 0; i < cur_game->rows; i++) {
	
	for(j = 0; j < numc; j++) {
		
		 if(cur_game->cells[i * numc + j] == cur_game->cells[i * numc + j + 1] && cur_game->cells[i * numc + j] != -1) {
	
			cur_game->cells[i*numc + j] = 2*(cur_game->cells[i*numc + j]);
			cur_game->score = cur_game->cells[i*numc + j] + cur_game->score;
			cur_game->cells[i*numc + j + 1] = -1;
			can_merge = 1;
		}
	}
}


for( i = 0; i < cur_game->rows; i++) {
	
	for(j = 0; j < numc; j++) {
		
		if(cur_game->cells[i*numc + j] !=  -1){  

			for(tarpoint = 0; tarpoint < j; tarpoint++) {
	
				if(cur_game->cells[i*numc + tarpoint] == -1) {
	
					cur_game->cells[i*numc + tarpoint] = cur_game->cells[i*numc + j];
					cur_game->cells[i*numc + j] = -1;
					break;
				}
			}
		}
	}
}

return can_merge;


};

int move_d(game * cur_game){ //slide to the right
    //YOUR CODE STARTS HERE


int i;
int j;
int tarpoint;
int numc = cur_game->cols;

int can_merge = 0;

for( i = 0; i < cur_game->rows; i++) {
	
	for(j = numc - 1; j>=0; j--) {
		
		if(cur_game->cells[i*numc + j] != -1){  

			for(tarpoint = numc - 1; tarpoint > j; tarpoint--) {
	
				if(cur_game->cells[i*numc + tarpoint] == -1) {
	
					cur_game->cells[i*numc + tarpoint] = cur_game->cells[i*numc + j];
					cur_game->cells[i*numc + j] = -1;
					can_merge = 1;
					break;
				}
			}
		}
	}
}



for( i = 0; i < cur_game->rows; i++) {
	
	for(j = numc - 1; j >= 0; j--) {
		
		 if(cur_game->cells[i * numc + j] == cur_game->cells[i * numc + j - 1] && cur_game->cells[i * numc + j] != -1) {
	
			cur_game->cells[i*numc + j] = 2*(cur_game->cells[i*numc + j]);
			cur_game->score = cur_game->cells[i*numc + j] + cur_game->score;
			cur_game->cells[i*numc + j - 1] = -1;
			can_merge = 1;
		}
	}
}


for( i = 0; i < cur_game->rows; i++) {
	
	for(j = numc - 1; j>=0; j--) {
		
		if(cur_game->cells[i*numc + j] != -1){  

			for(tarpoint = numc - 1; tarpoint > j; tarpoint--) {
	
				if(cur_game->cells[i*numc + tarpoint] == -1) {
	
					cur_game->cells[i*numc + tarpoint] = cur_game->cells[i*numc + j];
					cur_game->cells[i*numc + j] = -1;
					break;
				}
			}
		}
	}
}


return can_merge;

};

int legal_move_check(game * cur_game)
/*! Given the current game check if there are any legal moves on the board. There are
    no legal moves if sliding in any direction will not cause the game to change.
	Return 1 if there are possible legal moves, 0 if there are none.
 */
{
    //YOUR CODE STARTS HERE

game *dup = malloc(sizeof(game));

int i;
int j;


dup->rows = cur_game->rows;
dup->cols = cur_game->cols;
dup->score = cur_game->score;
dup->cells = malloc((cur_game->cols) * (cur_game->rows) * sizeof(cell));


for( i  = 0; i < cur_game->rows; i++) {

	for ( j = 0; j < cur_game->cols; j++) {

		dup->cells[i * (cur_game->cols) + j] = cur_game->cells[i * (cur_game->cols) + j];
	}
}


if( move_w(dup) || move_a(dup) || move_d(dup) || move_s(dup) ) {

	free(dup->cells);
	free(dup);
	return 1;

}


free(dup->cells);
free(dup);

return 0;

}


/*! code below is provided and should not be changed */

void rand_new_tile(game * cur_game)
/*! insert a new tile into a random empty cell. First call rand()%(rows*cols) to get a random value between 0 and (rows*cols)-1.
*/
{
	
	cell * cell_ptr;
    cell_ptr = 	cur_game->cells;
	
    if (cell_ptr == NULL){ 	
        printf("Bad Cell Pointer.\n");
        exit(0);
    }
	
	
	//check for an empty cell
	int emptycheck = 0;
	int i;
	
	for(i = 0; i < ((cur_game->rows)*(cur_game->cols)); i++){
		if ((*cell_ptr) == -1){
				emptycheck = 1;
				break;
		}		
        cell_ptr += 1;
	}
	if (emptycheck == 0){
		printf("Error: Trying to insert into no a board with no empty cell. The function rand_new_tile() should only be called after tiles have succesfully moved, meaning there should be at least 1 open spot.\n");
		exit(0);
	}
	
    int ind,row,col;
	int num;
    do{
		ind = rand()%((cur_game->rows)*(cur_game->cols));
		col = ind%(cur_game->cols);
		row = ind/cur_game->cols;
    } while ( *get_cell(cur_game, row, col) != -1);
        //*get_cell(cur_game, row, col) = 2;
	num = rand()%20;
	if(num <= 1){
		*get_cell(cur_game, row, col) = 4; // 1/10th chance
	}
	else{
		*get_cell(cur_game, row, col) = 2;// 9/10th chance
	}
}

int print_game(game * cur_game) 
{
    cell * cell_ptr;
    cell_ptr = 	cur_game->cells;

    int rows = cur_game->rows;
    int cols = cur_game->cols;
    int i,j;
	
	printf("\n\n\nscore:%d\n",cur_game->score); 
	
	
	printf("\u2554"); // topleft box char
	for(i = 0; i < cols*5;i++)
		printf("\u2550"); // top box char
	printf("\u2557\n"); //top right char 
	
	
    for(i = 0; i < rows; i++){
		printf("\u2551"); // side box char
        for(j = 0; j < cols; j++){
            if ((*cell_ptr) == -1 ) { //print asterisks
                printf(" **  "); 
            }
            else {
                switch( *cell_ptr ){ //print colored text
                    case 2:
                        printf("\x1b[1;31m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 4:
                        printf("\x1b[1;32m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 8:
                        printf("\x1b[1;33m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 16:
                        printf("\x1b[1;34m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 32:
                        printf("\x1b[1;35m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 64:
                        printf("\x1b[1;36m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 128:
                        printf("\x1b[31m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 256:
                        printf("\x1b[32m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 512:
                        printf("\x1b[33m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 1024:
                        printf("\x1b[34m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 2048:
                        printf("\x1b[35m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 4096:
                        printf("\x1b[36m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 8192:
                        printf("\x1b[31m%04d\x1b[0m ",(*cell_ptr));
                        break;
					default:
						printf("  X  ");

                }

            }
            cell_ptr++;
        }
	printf("\u2551\n"); //print right wall and newline
    }
	
	printf("\u255A"); // print bottom left char
	for(i = 0; i < cols*5;i++)
		printf("\u2550"); // bottom char
	printf("\u255D\n"); //bottom right char
	
    return 0;
}

int process_turn(const char input_char, game* cur_game) //returns 1 if legal move is possible after input is processed
{ 
	int rows,cols;
	char buf[200];
	char garbage[2];
    int move_success = 0;
	
    switch ( input_char ) {
    case 'w':
        move_success = move_w(cur_game);
        break;
    case 'a':
        move_success = move_a(cur_game);
        break;
    case 's':
        move_success = move_s(cur_game);
        break;
    case 'd':
        move_success = move_d(cur_game);
        break;
    case 'q':
        destroy_game(cur_game);
        printf("\nQuitting..\n");
        return 0;
        break;
	case 'n':
		//get row and col input for new game
		dim_prompt: printf("NEW GAME: Enter dimensions (rows columns):");
		while (NULL == fgets(buf,200,stdin)) {
			printf("\nProgram Terminated.\n");
			return 0;
		}
		
		if (2 != sscanf(buf,"%d%d%1s",&rows,&cols,garbage) ||
		rows < 0 || cols < 0){
			printf("Invalid dimensions.\n");
			goto dim_prompt;
		} 
		
		remake_game(&cur_game,rows,cols);
		
		move_success = 1;
		
    default: //any other input
        printf("Invalid Input. Valid inputs are: w, a, s, d, q, n.\n");
    }

	
	
	
    if(move_success == 1){ //if movement happened, insert new tile and print the game.
         rand_new_tile(cur_game); 
		 print_game(cur_game);
    } 

    if( legal_move_check(cur_game) == 0){  //check if the newly spawned tile results in game over.
        printf("Game Over!\n");
        return 0;
    }
    return 1;
}
