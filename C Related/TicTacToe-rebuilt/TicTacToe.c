#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include <Windows.h>

#define true 1
#define false 0

char playfield[9];
int screenWidth;
int tabbing = 15;


void menu();
void writeCenter(char *string);
void putFormat(char *string);
char checkForInput();

void initBoard(){
	int i;
	for(i = 0; i < 9; i++){
		playfield[i] = 49+i;
	}
}

void showSplash(char *title){
	writeCenter("###################");
	writeCenter("");
	writeCenter(title);
	writeCenter("");
	writeCenter("###################");
	writeCenter("\n");
}

void writeCenter(char *string){
	int spaces,i;
	spaces = screenWidth - strlen(string);
	for(i=0;i<spaces/2;i++){
		printf(" ");
	}
	printf("%s\n",string);
}
void spmenu(){
	char input;
	system("cls");
	putFormat("");
	putFormat("");
	putFormat("");
	putFormat("1 - Play Singleplayer - 1 V 1");
	putFormat("2 - Play Singleplayer - CPU");
	putFormat("");
	putFormat("0 - Return");
	input = checkForInput();
	switch(input){
		case '1': startGame();break;
		case '2': startGameCPU();break;

		case '0': menu();break;
		default: printf("Accessable: 0-2");sleep(1);break;
	}
}
void menu(){
	char input;
	system("cls");
	showSplash("TicTacToe");
	putFormat("1 - Play Singleplayer");
	putFormat("2 - Play Multiplayer");
	putFormat("0 - Exit game");
	input = checkForInput();
	switch(input){
		case '1': spmenu();break;
		case '0': exit(0);break;
		default: putFormat("Accessable: 1-0");sleep(1);menu();break;
	}
}

void putFormat(char *string){
	int i;
	for(i=0;i<tabbing;i++){
		printf(" ");
	}
	printf("%s\n",string);
}

void drawPlayField(){
	system("cls");
	printf("\n");
	int i,spaces,f;
	spaces = screenWidth - strlen("[X] ");
	for(i = 1;i < 4 ;i++){
		int d;
		printf("\n");
		printf("\n");
		for(f=0;f<spaces/2;f++){
			printf(" ");
		}
		for(d=1;d < 4;d++){
			printf("[%c] ",playfield[d*i-1]);
		}
		
	}
	printf("\n");
	printf("\n");
	printf("\n");
	printf("\n");
}

char checkForInput(){
	int result = getch();
	printf("%c\n", result);
	return (char)result;
}

int checkForWin(char turn){
	// X-Wise Winner detection
	if(playfield[0] == turn && playfield[3] == turn && playfield[6] == turn){
		return turn;
	}else if(playfield[1] == turn && playfield[4] == turn && playfield[7] == turn){
		return turn;
	}else if(playfield[2] == turn && playfield[5] == turn && playfield[8] == turn){
		return turn;

	// Diagonal Winner Detection
	}else if(playfield[0] == turn && playfield[4] == turn && playfield[8] == turn){
		return turn;
	}else if(playfield[2] == turn && playfield[4] == turn && playfield[6] == turn){
		return turn;

	// Y-Wise Winner detection
	}else if(playfield[0] == turn && playfield[1] == turn && playfield[2] == turn){
		return turn;
	}else if(playfield[3] == turn && playfield[4] == turn && playfield[5] == turn){
		return turn;
	}else if(playfield[6] == turn && playfield[7] == turn && playfield[8] == turn){
		return turn;
	}else{
		return '0';
	}
}

int checkAlreadyExisting(int field){
	if(playfield[field] == 'X' || playfield[field] == 'O'){
		return true;
	}else{
		return false;
	}
}

int startGame(){
	int input,i,max_rounds;
	char winner,turn;
	initBoard();
	max_rounds = 9;
	for(i = 0;i<max_rounds;i++){
		turn = turn == 'X' ? 'O' : 'X';
		drawPlayField();
		putFormat("Which field do you want to occupy?");
		input = checkForInput();
		while(checkAlreadyExisting(input-1)){
			drawPlayField();
			putFormat("You cannot overwrite!");
			putFormat("Which field do you want to occupy?");
			input = checkForInput();
		}
		playfield[input-1] = turn;
		winner = checkForWin(turn);
		if(winner == '0'){
		}else{
			drawPlayField();
			printf("Winner: %c\n",winner);
			sleep(2);
			break;
		}
		drawPlayField();
	}
	if(winner == '0'){
		printf("Tie! Nobody won!\n");
	}
	menu();
}

int startGameCPU(){
	int input,i,max_rounds,cputurn;
	char winner,turn;
	initBoard();
	turn = 'X';
	max_rounds = 5;
	for(i = 0;i<max_rounds;i++){
		drawPlayField();
		printf("Which field do you want to occupy?\n");
		scanf("%d",&input);
		while(checkAlreadyExisting(input-1)){
			drawPlayField();
			printf("You cannot overwrite!\n");
			printf("Which field do you want to occupy?\n");
			scanf("%d",&input);
		}
		playfield[input-1] = turn;
		winner = checkForWin(turn);
		if(winner != '0'){
			drawPlayField();
			printf("Winner: %c\n",winner);
			sleep(2);
			break;
		}
		drawPlayField();
		cputurn = rand() % 8;
		while(checkAlreadyExisting(cputurn)){
			cputurn = rand() % 8;
		}
		playfield[cputurn] = 'O';
		winner = checkForWin('O');
		if(winner != '0'){
			drawPlayField();
			printf("Winner: %c\n",winner);
			sleep(2);
			break;
		}
		drawPlayField();
	}
	if(winner == '0'){
		printf("Tie! Nobody won!\n");
	}
	menu();
}


int main(int argc, char *argv[]){
	CONSOLE_SCREEN_BUFFER_INFO csbi;
    GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);
    screenWidth = csbi.srWindow.Right - csbi.srWindow.Left + 1;

	menu();
	return 0;
}