#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>

#define true 1
#define false 0

char playfield[9];

void initBoard(){
	int i;
	for(i = 0; i < 9; i++){
		playfield[i] = 49+i;
	}
}

void menu(){
	int input;
	system("cls");
	printf("Welcome to TicTacToe, my Test Programm!\n");
	printf("1 - Play Singleplayer - 1 V 1\n");
	printf("2 - Play Singleplayer - CPU\n");
	printf("\n");
	printf("0 - Exit game\n");
	scanf("%d",&input);
	switch(input){
		case 1: startGame();break;
		case 2: startGameCPU();break;
		case 0: exit(0);break;
		default: printf("Accessable: 1-0");sleep(1);menu();break;
	}
}

void drawPlayField(){
	system("cls");
	printf("\n");
	int i;
	for(i = 1;i < 10 ;i++){
		printf("[%c] ",playfield[i-1]);
		if(i%3==0){
			printf("\n");
			printf("\n");
		}
	}
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


int main(){
	menu();

	return 0;
}