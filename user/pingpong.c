#include "kernel/types.h"
#include "user/user.h"
#include "kernel/stat.h"

const int BUFFER_SIZE= 16;
const int INDEX_READ=0;
const int INDEX_WRITE= 1;

int main(int argc, char *argv[])
{
    int fds_pc[2]; //父到子
    int fds_cp[2]; //子到父

    //创建管道
    pipe(fds_cp);
    pipe(fds_pc);

    int pid;
    pid = fork(); //fork子进程
    //子进程部分
    if (pid == 0)
    {
        //通信方向：子到父，子不需要读
        close(fds_cp[INDEX_READ]);
        //通信方向：父到子，子不需要写
        close(fds_pc[INDEX_WRITE]);

        //2：子进程收到ping指令，打印
        char buf[BUFFER_SIZE];
        if (read(fds_pc[INDEX_READ], buf, 1) == 1)
        {
            printf("%d: received ping\n", getpid());
        }

        //3: 子进程继续向父进程发出信号
        write(fds_cp[INDEX_WRITE], "f", 1);

        exit(0);
    }
    //父进程部分
    else
    {
        //通信方向：子到父，父不需要写
        close(fds_cp[INDEX_WRITE]);
        //通信方向：父到子，父不需要读
        close(fds_pc[INDEX_READ]);

        //1: 父进程给子进程发ping
        write(fds_pc[INDEX_WRITE], "f", 1);

        //4：父进程读取子进程发出的ping
        char buf[BUFFER_SIZE];
        if (read(fds_cp[INDEX_READ], buf, 1) == 1)
        {
            printf("%d: received pong\n", getpid());
        }
    }

    //父进程结束
    exit(0);
}

