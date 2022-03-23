#include <cstdlib>
#include <cstddef>
#include <cstring>
#include <cstdio>
#include <ostream>
#include <iostream>

extern int bfs(int argc, char* argv[]);
extern int sssp(int argc, char* argv[]);
extern int pr(int argc, char* argv[]);
extern int cc(int argc, char* argv[]);
extern int bc(int argc, char* argv[]);
extern int tc(int argc, char* argv[]);

char one[] = "./gapbs";
char two[] = "-g";
char three[] = "25";
char four[] = "-n";
char five[] = "1";

char *myarr[5];

int main(int argc, char* argv[]){
	myarr[0] = (char *) &one;
	myarr[1] = (char *) &two;
	myarr[2] = (char *) &three;
	myarr[3] = (char *) &four;
	myarr[4] = (char *) &five;

	argc = 5;
	argv = myarr;
	
	std::cout << "\n*****************************************************************" << std::endl;
	std::cout << "******************************B F S******************************" << std::endl;
	std::cout << "*****************************************************************" << std::endl;
	bfs(argc, argv);
	std::cout << "\n*****************************************************************" << std::endl;
	std::cout << "*****************************S S S P*****************************" << std::endl;
	std::cout << "*****************************************************************" << std::endl;
	sssp(argc, argv);
	std::cout << "\n*****************************************************************" << std::endl;
	std::cout << "*******************************P R*******************************" << std::endl;
	std::cout << "*****************************************************************" << std::endl;
	pr(argc, argv);
	std::cout << "\n*****************************************************************" << std::endl;
	std::cout << "*******************************C C*******************************" << std::endl;
	std::cout << "*****************************************************************" << std::endl;
	cc(argc, argv);
	std::cout << "\n*****************************************************************" << std::endl;
	std::cout << "*******************************B C*******************************" << std::endl;
	std::cout << "*****************************************************************" << std::endl;
	bc(argc, argv);
	std::cout << "\n*****************************************************************" << std::endl;
	std::cout << "*******************************T C*******************************" << std::endl;
	std::cout << "*****************************************************************" << std::endl;
	tc(argc, argv);
	return 0;
}
