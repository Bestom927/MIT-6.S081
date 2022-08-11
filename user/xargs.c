#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"
#include "kernel/stat.h"

int main(int argc,const char* argv[])
{
	if (argc < 1)
	{
		fprintf(2,"Usage: xargs <cmd> ...\n");
		exit(1);
	}
	char ch;
	char **buf = (char**)malloc(sizeof(char*) * 64);
	for (int i = 0;i < 64;i++)
	{
		buf[i] = (char*)malloc(sizeof(char) * 64);
		memset(buf[i],0,64);
	}
    //grep指令的格式 grep filename path
    //所以第一个字符串是grep 第二个是filename
    //之后的都是path
	for (int i = 0;i < argc;i++)
		strcpy(buf[i],argv[i + 1]);
	int idx = 2,j = 0;
    //从标准输入中获取path，从标准输入获取的path都是以\n结尾的
	while (read(0,&ch,1) == 1)
	{
		if ('\n' != ch)
			buf[idx][j++] = ch;
		else
		{
			buf[idx][j] = 0;
			j = 0;
			idx++;
		}
	}
	for (int i = idx;i < 64;i++)
		buf[i] = 0;
	if (fork() == 0)
	{
		exec((char*)argv[1],(char**)buf);
		exit(0);
	}
	wait(0);
	exit(0);
}

