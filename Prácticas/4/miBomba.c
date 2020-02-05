// gcc -O2 bomba.c -o bomba -no-pie

#include <stdio.h>	// para printf(), fgets(), scanf()
#include <stdlib.h>	// para exit()
#include <string.h>	// para strncmp()
#include <sys/time.h>	// para gettimeofday(), struct timeval

#define SIZE 100
#define TLIM 60

char password[]="bbbcccbbb\n";	// contraseña
int  passcode = 1238;			// pin

void boom(void){
	printf(	"\n"
		"***************\n"
		"*** BOOM!!! ***\n"
		"***************\n"
		"\n");
	exit(-1);
}

void defused(void){
	printf(	"\n"
		"·························\n"
		"··· bomba desactivada ···\n"
		"·························\n"
		"\n");
	exit(0);
}

void caesarROT1(char* cadena)
{
	for (int i=0; cadena[i] != '\n' && cadena[i] != '\0'; i++)
		cadena[i] = cadena[i] + 1;
}

int main(){
	char pw[SIZE];
	int  pc, n;

	struct timeval tv1,tv2;	// gettimeofday() secs-usecs
	gettimeofday(&tv1,NULL);

	do	printf("\nIntroduce la contraseña: ");
	while (	fgets(pw, SIZE, stdin) == NULL );
	caesarROT1(pw);
	if    (	strncmp(pw,password,sizeof(password)) )
	    boom();

	gettimeofday(&tv2,NULL);
	if    ( tv2.tv_sec - tv1.tv_sec > TLIM )
	    boom();
    
    
	printf("\nIntroduce el pin: ");

    do{
        if ((n=scanf("%d",&pc))==0)
            scanf("%*s")==1;
    } while ( n!=1 );
	
    pc+=4;
	if (pc != passcode)
			boom();

	gettimeofday(&tv1,NULL);
	if    ( tv1.tv_sec - tv2.tv_sec > TLIM )
	    boom();

	defused();
}
