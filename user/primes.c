#include "kernel/types.h"
#include "user/user.h"
#include "kernel/stat.h"

const int MAX = 35;
const int INDEX_READ = 0;
const int INDEX_WRITE = 1;

void primes(int prev_read)
{
	int prime;//质数
	if (read(prev_read,&prime,sizeof(int)) <= 0)
	{
		exit(0);
	}
	printf("prime %d\n",prime);
	int pipefd[2];
	pipe(pipefd);

	int pid =fork();
	if (pid ==0)
	{
        //子进程关闭写端
		close(pipefd[INDEX_WRITE]);
		primes(pipefd[INDEX_READ]);
        //子进程关闭读端
		close(pipefd[INDEX_READ]);
	}
	else
	{
		int temp;
        //父进程关闭读端
		close(pipefd[INDEX_READ]);
		while (read(prev_read,&temp,sizeof(int)))
		{
			if (temp % prime != 0)//不是当前素数的倍数的数写入管道中
			{
				write(pipefd[INDEX_WRITE],&temp,sizeof(int));
			}
        }
        //父进程关闭写端
		close(pipefd[INDEX_WRITE]);
		wait(0);
	}
	exit(0);
}
int main(int argc,const char* argv[])
{
	int pipefd[2];
	pipe(pipefd);
	
	int pid =fork();
	if (pid == 0 )
	{
        //子进程关闭写端
		close(pipefd[INDEX_WRITE]);
		primes(pipefd[INDEX_READ]);
        //子进程关闭读端
		close(pipefd[INDEX_READ]);
	}
	else
	{
        //父进程关闭读端
		close(pipefd[INDEX_READ]);
		for (int i = 2;i <= MAX;i++)
			write(pipefd[INDEX_WRITE],&i,sizeof(int));
        //父进程关闭写端
		close(pipefd[INDEX_WRITE]);
		wait(0);
	}
	exit(0);
}
