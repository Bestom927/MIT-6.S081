
user/_primes：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <primes>:
const int MAX = 35;
const int INDEX_READ = 0;
const int INDEX_WRITE = 1;

void primes(int prev_read)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
   a:	84aa                	mv	s1,a0
	int prime;//质数
	if (read(prev_read,&prime,sizeof(int)) <= 0)
   c:	4611                	li	a2,4
   e:	fdc40593          	addi	a1,s0,-36
  12:	00000097          	auipc	ra,0x0
  16:	3ce080e7          	jalr	974(ra) # 3e0 <read>
  1a:	04a05363          	blez	a0,60 <primes+0x60>
	{
		exit(0);
	}
	printf("prime %d\n",prime);
  1e:	fdc42583          	lw	a1,-36(s0)
  22:	00001517          	auipc	a0,0x1
  26:	8be50513          	addi	a0,a0,-1858 # 8e0 <malloc+0xe6>
  2a:	00000097          	auipc	ra,0x0
  2e:	718080e7          	jalr	1816(ra) # 742 <printf>
	int pipefd[2];
	pipe(pipefd);
  32:	fd040513          	addi	a0,s0,-48
  36:	00000097          	auipc	ra,0x0
  3a:	3a2080e7          	jalr	930(ra) # 3d8 <pipe>

	int pid =fork();
  3e:	00000097          	auipc	ra,0x0
  42:	382080e7          	jalr	898(ra) # 3c0 <fork>
	if (pid ==0)
  46:	e115                	bnez	a0,6a <primes+0x6a>
	{
        //子进程关闭写端
		close(pipefd[INDEX_WRITE]);
  48:	fd442503          	lw	a0,-44(s0)
  4c:	00000097          	auipc	ra,0x0
  50:	3a4080e7          	jalr	932(ra) # 3f0 <close>
		primes(pipefd[INDEX_READ]);
  54:	fd042503          	lw	a0,-48(s0)
  58:	00000097          	auipc	ra,0x0
  5c:	fa8080e7          	jalr	-88(ra) # 0 <primes>
		exit(0);
  60:	4501                	li	a0,0
  62:	00000097          	auipc	ra,0x0
  66:	366080e7          	jalr	870(ra) # 3c8 <exit>
	}
	else
	{
		int temp;
        //父进程关闭读端
		close(pipefd[INDEX_READ]);
  6a:	fd042503          	lw	a0,-48(s0)
  6e:	00000097          	auipc	ra,0x0
  72:	382080e7          	jalr	898(ra) # 3f0 <close>
		while (read(prev_read,&temp,sizeof(int)))
  76:	4611                	li	a2,4
  78:	fcc40593          	addi	a1,s0,-52
  7c:	8526                	mv	a0,s1
  7e:	00000097          	auipc	ra,0x0
  82:	362080e7          	jalr	866(ra) # 3e0 <read>
  86:	c115                	beqz	a0,aa <primes+0xaa>
		{
			if (temp % prime != 0)//不是当前素数的倍数的数写入管道中
  88:	fcc42783          	lw	a5,-52(s0)
  8c:	fdc42703          	lw	a4,-36(s0)
  90:	02e7e7bb          	remw	a5,a5,a4
  94:	d3ed                	beqz	a5,76 <primes+0x76>
			{
				write(pipefd[INDEX_WRITE],&temp,sizeof(int));
  96:	4611                	li	a2,4
  98:	fcc40593          	addi	a1,s0,-52
  9c:	fd442503          	lw	a0,-44(s0)
  a0:	00000097          	auipc	ra,0x0
  a4:	348080e7          	jalr	840(ra) # 3e8 <write>
  a8:	b7f9                	j	76 <primes+0x76>
			}
        }
        //父进程关闭写端
		close(pipefd[INDEX_WRITE]);
  aa:	fd442503          	lw	a0,-44(s0)
  ae:	00000097          	auipc	ra,0x0
  b2:	342080e7          	jalr	834(ra) # 3f0 <close>
		wait(0);
  b6:	4501                	li	a0,0
  b8:	00000097          	auipc	ra,0x0
  bc:	318080e7          	jalr	792(ra) # 3d0 <wait>
	}
	exit(0);
  c0:	4501                	li	a0,0
  c2:	00000097          	auipc	ra,0x0
  c6:	306080e7          	jalr	774(ra) # 3c8 <exit>

00000000000000ca <main>:
}
int main(int argc,const char* argv[])
{
  ca:	7179                	addi	sp,sp,-48
  cc:	f406                	sd	ra,40(sp)
  ce:	f022                	sd	s0,32(sp)
  d0:	ec26                	sd	s1,24(sp)
  d2:	1800                	addi	s0,sp,48
	int pipefd[2];
	pipe(pipefd);
  d4:	fd840513          	addi	a0,s0,-40
  d8:	00000097          	auipc	ra,0x0
  dc:	300080e7          	jalr	768(ra) # 3d8 <pipe>
	
	int pid =fork();
  e0:	00000097          	auipc	ra,0x0
  e4:	2e0080e7          	jalr	736(ra) # 3c0 <fork>
	if (pid == 0 )
  e8:	ed09                	bnez	a0,102 <main+0x38>
	{
        //子进程关闭写端
		close(pipefd[INDEX_WRITE]);
  ea:	fdc42503          	lw	a0,-36(s0)
  ee:	00000097          	auipc	ra,0x0
  f2:	302080e7          	jalr	770(ra) # 3f0 <close>
		primes(pipefd[INDEX_READ]);
  f6:	fd842503          	lw	a0,-40(s0)
  fa:	00000097          	auipc	ra,0x0
  fe:	f06080e7          	jalr	-250(ra) # 0 <primes>
		close(pipefd[INDEX_READ]);
	}
	else
	{
        //父进程关闭读端
		close(pipefd[INDEX_READ]);
 102:	fd842503          	lw	a0,-40(s0)
 106:	00000097          	auipc	ra,0x0
 10a:	2ea080e7          	jalr	746(ra) # 3f0 <close>
		for (int i = 2;i <= MAX;i++)
 10e:	4789                	li	a5,2
 110:	fcf42a23          	sw	a5,-44(s0)
 114:	02300493          	li	s1,35
			write(pipefd[INDEX_WRITE],&i,sizeof(int));
 118:	4611                	li	a2,4
 11a:	fd440593          	addi	a1,s0,-44
 11e:	fdc42503          	lw	a0,-36(s0)
 122:	00000097          	auipc	ra,0x0
 126:	2c6080e7          	jalr	710(ra) # 3e8 <write>
		for (int i = 2;i <= MAX;i++)
 12a:	fd442783          	lw	a5,-44(s0)
 12e:	2785                	addiw	a5,a5,1
 130:	0007871b          	sext.w	a4,a5
 134:	fcf42a23          	sw	a5,-44(s0)
 138:	fee4d0e3          	bge	s1,a4,118 <main+0x4e>
        //父进程关闭写端
		close(pipefd[INDEX_WRITE]);
 13c:	fdc42503          	lw	a0,-36(s0)
 140:	00000097          	auipc	ra,0x0
 144:	2b0080e7          	jalr	688(ra) # 3f0 <close>
		wait(0);
 148:	4501                	li	a0,0
 14a:	00000097          	auipc	ra,0x0
 14e:	286080e7          	jalr	646(ra) # 3d0 <wait>
	}
	exit(0);
 152:	4501                	li	a0,0
 154:	00000097          	auipc	ra,0x0
 158:	274080e7          	jalr	628(ra) # 3c8 <exit>

000000000000015c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 162:	87aa                	mv	a5,a0
 164:	0585                	addi	a1,a1,1
 166:	0785                	addi	a5,a5,1
 168:	fff5c703          	lbu	a4,-1(a1)
 16c:	fee78fa3          	sb	a4,-1(a5)
 170:	fb75                	bnez	a4,164 <strcpy+0x8>
    ;
  return os;
}
 172:	6422                	ld	s0,8(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret

0000000000000178 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 178:	1141                	addi	sp,sp,-16
 17a:	e422                	sd	s0,8(sp)
 17c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 17e:	00054783          	lbu	a5,0(a0)
 182:	cb91                	beqz	a5,196 <strcmp+0x1e>
 184:	0005c703          	lbu	a4,0(a1)
 188:	00f71763          	bne	a4,a5,196 <strcmp+0x1e>
    p++, q++;
 18c:	0505                	addi	a0,a0,1
 18e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 190:	00054783          	lbu	a5,0(a0)
 194:	fbe5                	bnez	a5,184 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 196:	0005c503          	lbu	a0,0(a1)
}
 19a:	40a7853b          	subw	a0,a5,a0
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strlen>:

uint
strlen(const char *s)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cf91                	beqz	a5,1ca <strlen+0x26>
 1b0:	0505                	addi	a0,a0,1
 1b2:	87aa                	mv	a5,a0
 1b4:	4685                	li	a3,1
 1b6:	9e89                	subw	a3,a3,a0
 1b8:	00f6853b          	addw	a0,a3,a5
 1bc:	0785                	addi	a5,a5,1
 1be:	fff7c703          	lbu	a4,-1(a5)
 1c2:	fb7d                	bnez	a4,1b8 <strlen+0x14>
    ;
  return n;
}
 1c4:	6422                	ld	s0,8(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret
  for(n = 0; s[n]; n++)
 1ca:	4501                	li	a0,0
 1cc:	bfe5                	j	1c4 <strlen+0x20>

00000000000001ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e422                	sd	s0,8(sp)
 1d2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1d4:	ca19                	beqz	a2,1ea <memset+0x1c>
 1d6:	87aa                	mv	a5,a0
 1d8:	1602                	slli	a2,a2,0x20
 1da:	9201                	srli	a2,a2,0x20
 1dc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1e0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1e4:	0785                	addi	a5,a5,1
 1e6:	fee79de3          	bne	a5,a4,1e0 <memset+0x12>
  }
  return dst;
}
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret

00000000000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1f6:	00054783          	lbu	a5,0(a0)
 1fa:	cb99                	beqz	a5,210 <strchr+0x20>
    if(*s == c)
 1fc:	00f58763          	beq	a1,a5,20a <strchr+0x1a>
  for(; *s; s++)
 200:	0505                	addi	a0,a0,1
 202:	00054783          	lbu	a5,0(a0)
 206:	fbfd                	bnez	a5,1fc <strchr+0xc>
      return (char*)s;
  return 0;
 208:	4501                	li	a0,0
}
 20a:	6422                	ld	s0,8(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret
  return 0;
 210:	4501                	li	a0,0
 212:	bfe5                	j	20a <strchr+0x1a>

0000000000000214 <gets>:

char*
gets(char *buf, int max)
{
 214:	711d                	addi	sp,sp,-96
 216:	ec86                	sd	ra,88(sp)
 218:	e8a2                	sd	s0,80(sp)
 21a:	e4a6                	sd	s1,72(sp)
 21c:	e0ca                	sd	s2,64(sp)
 21e:	fc4e                	sd	s3,56(sp)
 220:	f852                	sd	s4,48(sp)
 222:	f456                	sd	s5,40(sp)
 224:	f05a                	sd	s6,32(sp)
 226:	ec5e                	sd	s7,24(sp)
 228:	1080                	addi	s0,sp,96
 22a:	8baa                	mv	s7,a0
 22c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22e:	892a                	mv	s2,a0
 230:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 232:	4aa9                	li	s5,10
 234:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 236:	89a6                	mv	s3,s1
 238:	2485                	addiw	s1,s1,1
 23a:	0344d863          	bge	s1,s4,26a <gets+0x56>
    cc = read(0, &c, 1);
 23e:	4605                	li	a2,1
 240:	faf40593          	addi	a1,s0,-81
 244:	4501                	li	a0,0
 246:	00000097          	auipc	ra,0x0
 24a:	19a080e7          	jalr	410(ra) # 3e0 <read>
    if(cc < 1)
 24e:	00a05e63          	blez	a0,26a <gets+0x56>
    buf[i++] = c;
 252:	faf44783          	lbu	a5,-81(s0)
 256:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 25a:	01578763          	beq	a5,s5,268 <gets+0x54>
 25e:	0905                	addi	s2,s2,1
 260:	fd679be3          	bne	a5,s6,236 <gets+0x22>
  for(i=0; i+1 < max; ){
 264:	89a6                	mv	s3,s1
 266:	a011                	j	26a <gets+0x56>
 268:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 26a:	99de                	add	s3,s3,s7
 26c:	00098023          	sb	zero,0(s3)
  return buf;
}
 270:	855e                	mv	a0,s7
 272:	60e6                	ld	ra,88(sp)
 274:	6446                	ld	s0,80(sp)
 276:	64a6                	ld	s1,72(sp)
 278:	6906                	ld	s2,64(sp)
 27a:	79e2                	ld	s3,56(sp)
 27c:	7a42                	ld	s4,48(sp)
 27e:	7aa2                	ld	s5,40(sp)
 280:	7b02                	ld	s6,32(sp)
 282:	6be2                	ld	s7,24(sp)
 284:	6125                	addi	sp,sp,96
 286:	8082                	ret

0000000000000288 <stat>:

int
stat(const char *n, struct stat *st)
{
 288:	1101                	addi	sp,sp,-32
 28a:	ec06                	sd	ra,24(sp)
 28c:	e822                	sd	s0,16(sp)
 28e:	e426                	sd	s1,8(sp)
 290:	e04a                	sd	s2,0(sp)
 292:	1000                	addi	s0,sp,32
 294:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 296:	4581                	li	a1,0
 298:	00000097          	auipc	ra,0x0
 29c:	170080e7          	jalr	368(ra) # 408 <open>
  if(fd < 0)
 2a0:	02054563          	bltz	a0,2ca <stat+0x42>
 2a4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2a6:	85ca                	mv	a1,s2
 2a8:	00000097          	auipc	ra,0x0
 2ac:	178080e7          	jalr	376(ra) # 420 <fstat>
 2b0:	892a                	mv	s2,a0
  close(fd);
 2b2:	8526                	mv	a0,s1
 2b4:	00000097          	auipc	ra,0x0
 2b8:	13c080e7          	jalr	316(ra) # 3f0 <close>
  return r;
}
 2bc:	854a                	mv	a0,s2
 2be:	60e2                	ld	ra,24(sp)
 2c0:	6442                	ld	s0,16(sp)
 2c2:	64a2                	ld	s1,8(sp)
 2c4:	6902                	ld	s2,0(sp)
 2c6:	6105                	addi	sp,sp,32
 2c8:	8082                	ret
    return -1;
 2ca:	597d                	li	s2,-1
 2cc:	bfc5                	j	2bc <stat+0x34>

00000000000002ce <atoi>:

int
atoi(const char *s)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d4:	00054683          	lbu	a3,0(a0)
 2d8:	fd06879b          	addiw	a5,a3,-48
 2dc:	0ff7f793          	zext.b	a5,a5
 2e0:	4625                	li	a2,9
 2e2:	02f66863          	bltu	a2,a5,312 <atoi+0x44>
 2e6:	872a                	mv	a4,a0
  n = 0;
 2e8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ea:	0705                	addi	a4,a4,1
 2ec:	0025179b          	slliw	a5,a0,0x2
 2f0:	9fa9                	addw	a5,a5,a0
 2f2:	0017979b          	slliw	a5,a5,0x1
 2f6:	9fb5                	addw	a5,a5,a3
 2f8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2fc:	00074683          	lbu	a3,0(a4)
 300:	fd06879b          	addiw	a5,a3,-48
 304:	0ff7f793          	zext.b	a5,a5
 308:	fef671e3          	bgeu	a2,a5,2ea <atoi+0x1c>
  return n;
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret
  n = 0;
 312:	4501                	li	a0,0
 314:	bfe5                	j	30c <atoi+0x3e>

0000000000000316 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 316:	1141                	addi	sp,sp,-16
 318:	e422                	sd	s0,8(sp)
 31a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 31c:	02b57463          	bgeu	a0,a1,344 <memmove+0x2e>
    while(n-- > 0)
 320:	00c05f63          	blez	a2,33e <memmove+0x28>
 324:	1602                	slli	a2,a2,0x20
 326:	9201                	srli	a2,a2,0x20
 328:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 32c:	872a                	mv	a4,a0
      *dst++ = *src++;
 32e:	0585                	addi	a1,a1,1
 330:	0705                	addi	a4,a4,1
 332:	fff5c683          	lbu	a3,-1(a1)
 336:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 33a:	fee79ae3          	bne	a5,a4,32e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 33e:	6422                	ld	s0,8(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret
    dst += n;
 344:	00c50733          	add	a4,a0,a2
    src += n;
 348:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 34a:	fec05ae3          	blez	a2,33e <memmove+0x28>
 34e:	fff6079b          	addiw	a5,a2,-1
 352:	1782                	slli	a5,a5,0x20
 354:	9381                	srli	a5,a5,0x20
 356:	fff7c793          	not	a5,a5
 35a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 35c:	15fd                	addi	a1,a1,-1
 35e:	177d                	addi	a4,a4,-1
 360:	0005c683          	lbu	a3,0(a1)
 364:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 368:	fee79ae3          	bne	a5,a4,35c <memmove+0x46>
 36c:	bfc9                	j	33e <memmove+0x28>

000000000000036e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 36e:	1141                	addi	sp,sp,-16
 370:	e422                	sd	s0,8(sp)
 372:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 374:	ca05                	beqz	a2,3a4 <memcmp+0x36>
 376:	fff6069b          	addiw	a3,a2,-1
 37a:	1682                	slli	a3,a3,0x20
 37c:	9281                	srli	a3,a3,0x20
 37e:	0685                	addi	a3,a3,1
 380:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 382:	00054783          	lbu	a5,0(a0)
 386:	0005c703          	lbu	a4,0(a1)
 38a:	00e79863          	bne	a5,a4,39a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 38e:	0505                	addi	a0,a0,1
    p2++;
 390:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 392:	fed518e3          	bne	a0,a3,382 <memcmp+0x14>
  }
  return 0;
 396:	4501                	li	a0,0
 398:	a019                	j	39e <memcmp+0x30>
      return *p1 - *p2;
 39a:	40e7853b          	subw	a0,a5,a4
}
 39e:	6422                	ld	s0,8(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret
  return 0;
 3a4:	4501                	li	a0,0
 3a6:	bfe5                	j	39e <memcmp+0x30>

00000000000003a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3a8:	1141                	addi	sp,sp,-16
 3aa:	e406                	sd	ra,8(sp)
 3ac:	e022                	sd	s0,0(sp)
 3ae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b0:	00000097          	auipc	ra,0x0
 3b4:	f66080e7          	jalr	-154(ra) # 316 <memmove>
}
 3b8:	60a2                	ld	ra,8(sp)
 3ba:	6402                	ld	s0,0(sp)
 3bc:	0141                	addi	sp,sp,16
 3be:	8082                	ret

00000000000003c0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c0:	4885                	li	a7,1
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c8:	4889                	li	a7,2
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d0:	488d                	li	a7,3
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d8:	4891                	li	a7,4
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <read>:
.global read
read:
 li a7, SYS_read
 3e0:	4895                	li	a7,5
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <write>:
.global write
write:
 li a7, SYS_write
 3e8:	48c1                	li	a7,16
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <close>:
.global close
close:
 li a7, SYS_close
 3f0:	48d5                	li	a7,21
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f8:	4899                	li	a7,6
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <exec>:
.global exec
exec:
 li a7, SYS_exec
 400:	489d                	li	a7,7
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <open>:
.global open
open:
 li a7, SYS_open
 408:	48bd                	li	a7,15
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 410:	48c5                	li	a7,17
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 418:	48c9                	li	a7,18
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 420:	48a1                	li	a7,8
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <link>:
.global link
link:
 li a7, SYS_link
 428:	48cd                	li	a7,19
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 430:	48d1                	li	a7,20
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 438:	48a5                	li	a7,9
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <dup>:
.global dup
dup:
 li a7, SYS_dup
 440:	48a9                	li	a7,10
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 448:	48ad                	li	a7,11
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 450:	48b1                	li	a7,12
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 458:	48b5                	li	a7,13
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 460:	48b9                	li	a7,14
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 468:	1101                	addi	sp,sp,-32
 46a:	ec06                	sd	ra,24(sp)
 46c:	e822                	sd	s0,16(sp)
 46e:	1000                	addi	s0,sp,32
 470:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 474:	4605                	li	a2,1
 476:	fef40593          	addi	a1,s0,-17
 47a:	00000097          	auipc	ra,0x0
 47e:	f6e080e7          	jalr	-146(ra) # 3e8 <write>
}
 482:	60e2                	ld	ra,24(sp)
 484:	6442                	ld	s0,16(sp)
 486:	6105                	addi	sp,sp,32
 488:	8082                	ret

000000000000048a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 48a:	7139                	addi	sp,sp,-64
 48c:	fc06                	sd	ra,56(sp)
 48e:	f822                	sd	s0,48(sp)
 490:	f426                	sd	s1,40(sp)
 492:	f04a                	sd	s2,32(sp)
 494:	ec4e                	sd	s3,24(sp)
 496:	0080                	addi	s0,sp,64
 498:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 49a:	c299                	beqz	a3,4a0 <printint+0x16>
 49c:	0805c963          	bltz	a1,52e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4a0:	2581                	sext.w	a1,a1
  neg = 0;
 4a2:	4881                	li	a7,0
 4a4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4a8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4aa:	2601                	sext.w	a2,a2
 4ac:	00000517          	auipc	a0,0x0
 4b0:	4a450513          	addi	a0,a0,1188 # 950 <digits>
 4b4:	883a                	mv	a6,a4
 4b6:	2705                	addiw	a4,a4,1
 4b8:	02c5f7bb          	remuw	a5,a1,a2
 4bc:	1782                	slli	a5,a5,0x20
 4be:	9381                	srli	a5,a5,0x20
 4c0:	97aa                	add	a5,a5,a0
 4c2:	0007c783          	lbu	a5,0(a5)
 4c6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ca:	0005879b          	sext.w	a5,a1
 4ce:	02c5d5bb          	divuw	a1,a1,a2
 4d2:	0685                	addi	a3,a3,1
 4d4:	fec7f0e3          	bgeu	a5,a2,4b4 <printint+0x2a>
  if(neg)
 4d8:	00088c63          	beqz	a7,4f0 <printint+0x66>
    buf[i++] = '-';
 4dc:	fd070793          	addi	a5,a4,-48
 4e0:	00878733          	add	a4,a5,s0
 4e4:	02d00793          	li	a5,45
 4e8:	fef70823          	sb	a5,-16(a4)
 4ec:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4f0:	02e05863          	blez	a4,520 <printint+0x96>
 4f4:	fc040793          	addi	a5,s0,-64
 4f8:	00e78933          	add	s2,a5,a4
 4fc:	fff78993          	addi	s3,a5,-1
 500:	99ba                	add	s3,s3,a4
 502:	377d                	addiw	a4,a4,-1
 504:	1702                	slli	a4,a4,0x20
 506:	9301                	srli	a4,a4,0x20
 508:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 50c:	fff94583          	lbu	a1,-1(s2)
 510:	8526                	mv	a0,s1
 512:	00000097          	auipc	ra,0x0
 516:	f56080e7          	jalr	-170(ra) # 468 <putc>
  while(--i >= 0)
 51a:	197d                	addi	s2,s2,-1
 51c:	ff3918e3          	bne	s2,s3,50c <printint+0x82>
}
 520:	70e2                	ld	ra,56(sp)
 522:	7442                	ld	s0,48(sp)
 524:	74a2                	ld	s1,40(sp)
 526:	7902                	ld	s2,32(sp)
 528:	69e2                	ld	s3,24(sp)
 52a:	6121                	addi	sp,sp,64
 52c:	8082                	ret
    x = -xx;
 52e:	40b005bb          	negw	a1,a1
    neg = 1;
 532:	4885                	li	a7,1
    x = -xx;
 534:	bf85                	j	4a4 <printint+0x1a>

0000000000000536 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 536:	7119                	addi	sp,sp,-128
 538:	fc86                	sd	ra,120(sp)
 53a:	f8a2                	sd	s0,112(sp)
 53c:	f4a6                	sd	s1,104(sp)
 53e:	f0ca                	sd	s2,96(sp)
 540:	ecce                	sd	s3,88(sp)
 542:	e8d2                	sd	s4,80(sp)
 544:	e4d6                	sd	s5,72(sp)
 546:	e0da                	sd	s6,64(sp)
 548:	fc5e                	sd	s7,56(sp)
 54a:	f862                	sd	s8,48(sp)
 54c:	f466                	sd	s9,40(sp)
 54e:	f06a                	sd	s10,32(sp)
 550:	ec6e                	sd	s11,24(sp)
 552:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 554:	0005c903          	lbu	s2,0(a1)
 558:	18090f63          	beqz	s2,6f6 <vprintf+0x1c0>
 55c:	8aaa                	mv	s5,a0
 55e:	8b32                	mv	s6,a2
 560:	00158493          	addi	s1,a1,1
  state = 0;
 564:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 566:	02500a13          	li	s4,37
 56a:	4c55                	li	s8,21
 56c:	00000c97          	auipc	s9,0x0
 570:	38cc8c93          	addi	s9,s9,908 # 8f8 <malloc+0xfe>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 574:	02800d93          	li	s11,40
  putc(fd, 'x');
 578:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 57a:	00000b97          	auipc	s7,0x0
 57e:	3d6b8b93          	addi	s7,s7,982 # 950 <digits>
 582:	a839                	j	5a0 <vprintf+0x6a>
        putc(fd, c);
 584:	85ca                	mv	a1,s2
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	ee0080e7          	jalr	-288(ra) # 468 <putc>
 590:	a019                	j	596 <vprintf+0x60>
    } else if(state == '%'){
 592:	01498d63          	beq	s3,s4,5ac <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 596:	0485                	addi	s1,s1,1
 598:	fff4c903          	lbu	s2,-1(s1)
 59c:	14090d63          	beqz	s2,6f6 <vprintf+0x1c0>
    if(state == 0){
 5a0:	fe0999e3          	bnez	s3,592 <vprintf+0x5c>
      if(c == '%'){
 5a4:	ff4910e3          	bne	s2,s4,584 <vprintf+0x4e>
        state = '%';
 5a8:	89d2                	mv	s3,s4
 5aa:	b7f5                	j	596 <vprintf+0x60>
      if(c == 'd'){
 5ac:	11490c63          	beq	s2,s4,6c4 <vprintf+0x18e>
 5b0:	f9d9079b          	addiw	a5,s2,-99
 5b4:	0ff7f793          	zext.b	a5,a5
 5b8:	10fc6e63          	bltu	s8,a5,6d4 <vprintf+0x19e>
 5bc:	f9d9079b          	addiw	a5,s2,-99
 5c0:	0ff7f713          	zext.b	a4,a5
 5c4:	10ec6863          	bltu	s8,a4,6d4 <vprintf+0x19e>
 5c8:	00271793          	slli	a5,a4,0x2
 5cc:	97e6                	add	a5,a5,s9
 5ce:	439c                	lw	a5,0(a5)
 5d0:	97e6                	add	a5,a5,s9
 5d2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5d4:	008b0913          	addi	s2,s6,8
 5d8:	4685                	li	a3,1
 5da:	4629                	li	a2,10
 5dc:	000b2583          	lw	a1,0(s6)
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	ea8080e7          	jalr	-344(ra) # 48a <printint>
 5ea:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b765                	j	596 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f0:	008b0913          	addi	s2,s6,8
 5f4:	4681                	li	a3,0
 5f6:	4629                	li	a2,10
 5f8:	000b2583          	lw	a1,0(s6)
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e8c080e7          	jalr	-372(ra) # 48a <printint>
 606:	8b4a                	mv	s6,s2
      state = 0;
 608:	4981                	li	s3,0
 60a:	b771                	j	596 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 60c:	008b0913          	addi	s2,s6,8
 610:	4681                	li	a3,0
 612:	866a                	mv	a2,s10
 614:	000b2583          	lw	a1,0(s6)
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	e70080e7          	jalr	-400(ra) # 48a <printint>
 622:	8b4a                	mv	s6,s2
      state = 0;
 624:	4981                	li	s3,0
 626:	bf85                	j	596 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 628:	008b0793          	addi	a5,s6,8
 62c:	f8f43423          	sd	a5,-120(s0)
 630:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 634:	03000593          	li	a1,48
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	e2e080e7          	jalr	-466(ra) # 468 <putc>
  putc(fd, 'x');
 642:	07800593          	li	a1,120
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	e20080e7          	jalr	-480(ra) # 468 <putc>
 650:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 652:	03c9d793          	srli	a5,s3,0x3c
 656:	97de                	add	a5,a5,s7
 658:	0007c583          	lbu	a1,0(a5)
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	e0a080e7          	jalr	-502(ra) # 468 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 666:	0992                	slli	s3,s3,0x4
 668:	397d                	addiw	s2,s2,-1
 66a:	fe0914e3          	bnez	s2,652 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 66e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 672:	4981                	li	s3,0
 674:	b70d                	j	596 <vprintf+0x60>
        s = va_arg(ap, char*);
 676:	008b0913          	addi	s2,s6,8
 67a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 67e:	02098163          	beqz	s3,6a0 <vprintf+0x16a>
        while(*s != 0){
 682:	0009c583          	lbu	a1,0(s3)
 686:	c5ad                	beqz	a1,6f0 <vprintf+0x1ba>
          putc(fd, *s);
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	dde080e7          	jalr	-546(ra) # 468 <putc>
          s++;
 692:	0985                	addi	s3,s3,1
        while(*s != 0){
 694:	0009c583          	lbu	a1,0(s3)
 698:	f9e5                	bnez	a1,688 <vprintf+0x152>
        s = va_arg(ap, char*);
 69a:	8b4a                	mv	s6,s2
      state = 0;
 69c:	4981                	li	s3,0
 69e:	bde5                	j	596 <vprintf+0x60>
          s = "(null)";
 6a0:	00000997          	auipc	s3,0x0
 6a4:	25098993          	addi	s3,s3,592 # 8f0 <malloc+0xf6>
        while(*s != 0){
 6a8:	85ee                	mv	a1,s11
 6aa:	bff9                	j	688 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 6ac:	008b0913          	addi	s2,s6,8
 6b0:	000b4583          	lbu	a1,0(s6)
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	db2080e7          	jalr	-590(ra) # 468 <putc>
 6be:	8b4a                	mv	s6,s2
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	bdd1                	j	596 <vprintf+0x60>
        putc(fd, c);
 6c4:	85d2                	mv	a1,s4
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	da0080e7          	jalr	-608(ra) # 468 <putc>
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b5d1                	j	596 <vprintf+0x60>
        putc(fd, '%');
 6d4:	85d2                	mv	a1,s4
 6d6:	8556                	mv	a0,s5
 6d8:	00000097          	auipc	ra,0x0
 6dc:	d90080e7          	jalr	-624(ra) # 468 <putc>
        putc(fd, c);
 6e0:	85ca                	mv	a1,s2
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	d84080e7          	jalr	-636(ra) # 468 <putc>
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	b565                	j	596 <vprintf+0x60>
        s = va_arg(ap, char*);
 6f0:	8b4a                	mv	s6,s2
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	b54d                	j	596 <vprintf+0x60>
    }
  }
}
 6f6:	70e6                	ld	ra,120(sp)
 6f8:	7446                	ld	s0,112(sp)
 6fa:	74a6                	ld	s1,104(sp)
 6fc:	7906                	ld	s2,96(sp)
 6fe:	69e6                	ld	s3,88(sp)
 700:	6a46                	ld	s4,80(sp)
 702:	6aa6                	ld	s5,72(sp)
 704:	6b06                	ld	s6,64(sp)
 706:	7be2                	ld	s7,56(sp)
 708:	7c42                	ld	s8,48(sp)
 70a:	7ca2                	ld	s9,40(sp)
 70c:	7d02                	ld	s10,32(sp)
 70e:	6de2                	ld	s11,24(sp)
 710:	6109                	addi	sp,sp,128
 712:	8082                	ret

0000000000000714 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 714:	715d                	addi	sp,sp,-80
 716:	ec06                	sd	ra,24(sp)
 718:	e822                	sd	s0,16(sp)
 71a:	1000                	addi	s0,sp,32
 71c:	e010                	sd	a2,0(s0)
 71e:	e414                	sd	a3,8(s0)
 720:	e818                	sd	a4,16(s0)
 722:	ec1c                	sd	a5,24(s0)
 724:	03043023          	sd	a6,32(s0)
 728:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 72c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 730:	8622                	mv	a2,s0
 732:	00000097          	auipc	ra,0x0
 736:	e04080e7          	jalr	-508(ra) # 536 <vprintf>
}
 73a:	60e2                	ld	ra,24(sp)
 73c:	6442                	ld	s0,16(sp)
 73e:	6161                	addi	sp,sp,80
 740:	8082                	ret

0000000000000742 <printf>:

void
printf(const char *fmt, ...)
{
 742:	711d                	addi	sp,sp,-96
 744:	ec06                	sd	ra,24(sp)
 746:	e822                	sd	s0,16(sp)
 748:	1000                	addi	s0,sp,32
 74a:	e40c                	sd	a1,8(s0)
 74c:	e810                	sd	a2,16(s0)
 74e:	ec14                	sd	a3,24(s0)
 750:	f018                	sd	a4,32(s0)
 752:	f41c                	sd	a5,40(s0)
 754:	03043823          	sd	a6,48(s0)
 758:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 75c:	00840613          	addi	a2,s0,8
 760:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 764:	85aa                	mv	a1,a0
 766:	4505                	li	a0,1
 768:	00000097          	auipc	ra,0x0
 76c:	dce080e7          	jalr	-562(ra) # 536 <vprintf>
}
 770:	60e2                	ld	ra,24(sp)
 772:	6442                	ld	s0,16(sp)
 774:	6125                	addi	sp,sp,96
 776:	8082                	ret

0000000000000778 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 778:	1141                	addi	sp,sp,-16
 77a:	e422                	sd	s0,8(sp)
 77c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 782:	00000797          	auipc	a5,0x0
 786:	1ee7b783          	ld	a5,494(a5) # 970 <freep>
 78a:	a02d                	j	7b4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 78c:	4618                	lw	a4,8(a2)
 78e:	9f2d                	addw	a4,a4,a1
 790:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 794:	6398                	ld	a4,0(a5)
 796:	6310                	ld	a2,0(a4)
 798:	a83d                	j	7d6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 79a:	ff852703          	lw	a4,-8(a0)
 79e:	9f31                	addw	a4,a4,a2
 7a0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7a2:	ff053683          	ld	a3,-16(a0)
 7a6:	a091                	j	7ea <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	6398                	ld	a4,0(a5)
 7aa:	00e7e463          	bltu	a5,a4,7b2 <free+0x3a>
 7ae:	00e6ea63          	bltu	a3,a4,7c2 <free+0x4a>
{
 7b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b4:	fed7fae3          	bgeu	a5,a3,7a8 <free+0x30>
 7b8:	6398                	ld	a4,0(a5)
 7ba:	00e6e463          	bltu	a3,a4,7c2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7be:	fee7eae3          	bltu	a5,a4,7b2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7c2:	ff852583          	lw	a1,-8(a0)
 7c6:	6390                	ld	a2,0(a5)
 7c8:	02059813          	slli	a6,a1,0x20
 7cc:	01c85713          	srli	a4,a6,0x1c
 7d0:	9736                	add	a4,a4,a3
 7d2:	fae60de3          	beq	a2,a4,78c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7da:	4790                	lw	a2,8(a5)
 7dc:	02061593          	slli	a1,a2,0x20
 7e0:	01c5d713          	srli	a4,a1,0x1c
 7e4:	973e                	add	a4,a4,a5
 7e6:	fae68ae3          	beq	a3,a4,79a <free+0x22>
    p->s.ptr = bp->s.ptr;
 7ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ec:	00000717          	auipc	a4,0x0
 7f0:	18f73223          	sd	a5,388(a4) # 970 <freep>
}
 7f4:	6422                	ld	s0,8(sp)
 7f6:	0141                	addi	sp,sp,16
 7f8:	8082                	ret

00000000000007fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7fa:	7139                	addi	sp,sp,-64
 7fc:	fc06                	sd	ra,56(sp)
 7fe:	f822                	sd	s0,48(sp)
 800:	f426                	sd	s1,40(sp)
 802:	f04a                	sd	s2,32(sp)
 804:	ec4e                	sd	s3,24(sp)
 806:	e852                	sd	s4,16(sp)
 808:	e456                	sd	s5,8(sp)
 80a:	e05a                	sd	s6,0(sp)
 80c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80e:	02051493          	slli	s1,a0,0x20
 812:	9081                	srli	s1,s1,0x20
 814:	04bd                	addi	s1,s1,15
 816:	8091                	srli	s1,s1,0x4
 818:	0014899b          	addiw	s3,s1,1
 81c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 81e:	00000517          	auipc	a0,0x0
 822:	15253503          	ld	a0,338(a0) # 970 <freep>
 826:	c515                	beqz	a0,852 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82a:	4798                	lw	a4,8(a5)
 82c:	02977f63          	bgeu	a4,s1,86a <malloc+0x70>
 830:	8a4e                	mv	s4,s3
 832:	0009871b          	sext.w	a4,s3
 836:	6685                	lui	a3,0x1
 838:	00d77363          	bgeu	a4,a3,83e <malloc+0x44>
 83c:	6a05                	lui	s4,0x1
 83e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 842:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 846:	00000917          	auipc	s2,0x0
 84a:	12a90913          	addi	s2,s2,298 # 970 <freep>
  if(p == (char*)-1)
 84e:	5afd                	li	s5,-1
 850:	a895                	j	8c4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 852:	00000797          	auipc	a5,0x0
 856:	12678793          	addi	a5,a5,294 # 978 <base>
 85a:	00000717          	auipc	a4,0x0
 85e:	10f73b23          	sd	a5,278(a4) # 970 <freep>
 862:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 864:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 868:	b7e1                	j	830 <malloc+0x36>
      if(p->s.size == nunits)
 86a:	02e48c63          	beq	s1,a4,8a2 <malloc+0xa8>
        p->s.size -= nunits;
 86e:	4137073b          	subw	a4,a4,s3
 872:	c798                	sw	a4,8(a5)
        p += p->s.size;
 874:	02071693          	slli	a3,a4,0x20
 878:	01c6d713          	srli	a4,a3,0x1c
 87c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 87e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 882:	00000717          	auipc	a4,0x0
 886:	0ea73723          	sd	a0,238(a4) # 970 <freep>
      return (void*)(p + 1);
 88a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 88e:	70e2                	ld	ra,56(sp)
 890:	7442                	ld	s0,48(sp)
 892:	74a2                	ld	s1,40(sp)
 894:	7902                	ld	s2,32(sp)
 896:	69e2                	ld	s3,24(sp)
 898:	6a42                	ld	s4,16(sp)
 89a:	6aa2                	ld	s5,8(sp)
 89c:	6b02                	ld	s6,0(sp)
 89e:	6121                	addi	sp,sp,64
 8a0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8a2:	6398                	ld	a4,0(a5)
 8a4:	e118                	sd	a4,0(a0)
 8a6:	bff1                	j	882 <malloc+0x88>
  hp->s.size = nu;
 8a8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ac:	0541                	addi	a0,a0,16
 8ae:	00000097          	auipc	ra,0x0
 8b2:	eca080e7          	jalr	-310(ra) # 778 <free>
  return freep;
 8b6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8ba:	d971                	beqz	a0,88e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8be:	4798                	lw	a4,8(a5)
 8c0:	fa9775e3          	bgeu	a4,s1,86a <malloc+0x70>
    if(p == freep)
 8c4:	00093703          	ld	a4,0(s2)
 8c8:	853e                	mv	a0,a5
 8ca:	fef719e3          	bne	a4,a5,8bc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8ce:	8552                	mv	a0,s4
 8d0:	00000097          	auipc	ra,0x0
 8d4:	b80080e7          	jalr	-1152(ra) # 450 <sbrk>
  if(p == (char*)-1)
 8d8:	fd5518e3          	bne	a0,s5,8a8 <malloc+0xae>
        return 0;
 8dc:	4501                	li	a0,0
 8de:	bf45                	j	88e <malloc+0x94>
