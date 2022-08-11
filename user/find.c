#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char* des = 0;
void find(const char* path)
{
    //buf中存绝对路径
	char buf[512],*p;
	strcpy(buf,path);
	p = buf + strlen(path);
	*p++ = '/';
	int fd;
	
	//文件状态
	struct stat st;
	if (0 > (fd = open(path,O_RDONLY)))
	{
		fprintf(2,"cannot open %s\n",path);
		return;
	}
	if (0 > fstat(fd,&st))
	{
		fprintf(2,"cannot fstat %s\n",path);
		return;
	}
	
	struct dirent dir;
	int len = sizeof(dir);
	while (read(fd,&dir,len) == len)
	{
		if (0 == dir.inum)
			continue;
		strcpy(p,dir.name);
		if (stat(buf,&st) < 0)
		{
			fprintf(2,"cannot stat %s\n",buf);
			continue;
		}
		switch(st.type)
		{
			//是文件
			case T_FILE:
				if (!strcmp(dir.name,des))//如果文件名相同
					printf("%s\n",buf);
				break;
			
			//是目录
			case T_DIR:
				if (strcmp(".",dir.name) && strcmp("..",dir.name))
					find(buf);//递归
				break;

			default:
				break;
		}
	}
	close(fd);
}

int main(int argc,const char* argv[])
{
	if (argc <= 2)
	{
		printf("Usage: find <dir> <file> ...\n");
		exit(1);
	}
	des = (char*)argv[2];
	find(argv[1]);
	exit(0);
}


