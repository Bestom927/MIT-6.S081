
user/_xargs：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"
#include "user/user.h"
#include "kernel/stat.h"

int main(int argc,const char* argv[])
{
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	0880                	addi	s0,sp,80
	if (argc < 1)
  12:	06a05663          	blez	a0,7e <main+0x7e>
  16:	8aaa                	mv	s5,a0
  18:	8a2e                	mv	s4,a1
	{
		fprintf(2,"Usage: xargs <cmd> ...\n");
		exit(1);
	}
	char ch;
	char **buf = (char**)malloc(sizeof(char*) * 64);
  1a:	20000513          	li	a0,512
  1e:	00000097          	auipc	ra,0x0
  22:	7c0080e7          	jalr	1984(ra) # 7de <malloc>
  26:	89aa                	mv	s3,a0
	for (int i = 0;i < 64;i++)
  28:	20050913          	addi	s2,a0,512
	char **buf = (char**)malloc(sizeof(char*) * 64);
  2c:	84aa                	mv	s1,a0
	{
		buf[i] = (char*)malloc(sizeof(char) * 64);
  2e:	04000513          	li	a0,64
  32:	00000097          	auipc	ra,0x0
  36:	7ac080e7          	jalr	1964(ra) # 7de <malloc>
  3a:	e088                	sd	a0,0(s1)
		memset(buf[i],0,64);
  3c:	04000613          	li	a2,64
  40:	4581                	li	a1,0
  42:	00000097          	auipc	ra,0x0
  46:	170080e7          	jalr	368(ra) # 1b2 <memset>
	for (int i = 0;i < 64;i++)
  4a:	04a1                	addi	s1,s1,8
  4c:	ff2491e3          	bne	s1,s2,2e <main+0x2e>
  50:	008a0913          	addi	s2,s4,8
  54:	020a9793          	slli	a5,s5,0x20
  58:	01d7da93          	srli	s5,a5,0x1d
  5c:	9ace                	add	s5,s5,s3
  5e:	84ce                	mv	s1,s3
	}
    //grep指令的格式 grep filename path
    //所以第一个字符串是grep 第二个是filename
    //之后的都是path
	for (int i = 0;i < argc;i++)
		strcpy(buf[i],argv[i + 1]);
  60:	00093583          	ld	a1,0(s2)
  64:	6088                	ld	a0,0(s1)
  66:	00000097          	auipc	ra,0x0
  6a:	0da080e7          	jalr	218(ra) # 140 <strcpy>
	for (int i = 0;i < argc;i++)
  6e:	04a1                	addi	s1,s1,8
  70:	0921                	addi	s2,s2,8
  72:	ff5497e3          	bne	s1,s5,60 <main+0x60>
	int idx = 2,j = 0;
  76:	4481                	li	s1,0
  78:	4909                	li	s2,2
    //从标准输入中获取path，从标准输入获取的path都是以\n结尾的
	while (read(0,&ch,1) == 1)
	{
		if ('\n' != ch)
  7a:	4aa9                	li	s5,10
  7c:	a805                	j	ac <main+0xac>
		fprintf(2,"Usage: xargs <cmd> ...\n");
  7e:	00001597          	auipc	a1,0x1
  82:	84a58593          	addi	a1,a1,-1974 # 8c8 <malloc+0xea>
  86:	4509                	li	a0,2
  88:	00000097          	auipc	ra,0x0
  8c:	670080e7          	jalr	1648(ra) # 6f8 <fprintf>
		exit(1);
  90:	4505                	li	a0,1
  92:	00000097          	auipc	ra,0x0
  96:	31a080e7          	jalr	794(ra) # 3ac <exit>
			buf[idx][j++] = ch;
		else
		{
			buf[idx][j] = 0;
  9a:	00391793          	slli	a5,s2,0x3
  9e:	97ce                	add	a5,a5,s3
  a0:	639c                	ld	a5,0(a5)
  a2:	97a6                	add	a5,a5,s1
  a4:	00078023          	sb	zero,0(a5)
			j = 0;
			idx++;
  a8:	2905                	addiw	s2,s2,1
			j = 0;
  aa:	4481                	li	s1,0
	while (read(0,&ch,1) == 1)
  ac:	4605                	li	a2,1
  ae:	fbf40593          	addi	a1,s0,-65
  b2:	4501                	li	a0,0
  b4:	00000097          	auipc	ra,0x0
  b8:	310080e7          	jalr	784(ra) # 3c4 <read>
  bc:	4785                	li	a5,1
  be:	00f51f63          	bne	a0,a5,dc <main+0xdc>
		if ('\n' != ch)
  c2:	fbf44783          	lbu	a5,-65(s0)
  c6:	fd578ae3          	beq	a5,s5,9a <main+0x9a>
			buf[idx][j++] = ch;
  ca:	00391713          	slli	a4,s2,0x3
  ce:	974e                	add	a4,a4,s3
  d0:	6318                	ld	a4,0(a4)
  d2:	9726                	add	a4,a4,s1
  d4:	00f70023          	sb	a5,0(a4)
  d8:	2485                	addiw	s1,s1,1
  da:	bfc9                	j	ac <main+0xac>
		}
	}
	for (int i = idx;i < 64;i++)
  dc:	03f00793          	li	a5,63
  e0:	0327c563          	blt	a5,s2,10a <main+0x10a>
  e4:	00391793          	slli	a5,s2,0x3
  e8:	97ce                	add	a5,a5,s3
  ea:	03f00713          	li	a4,63
  ee:	4127073b          	subw	a4,a4,s2
  f2:	1702                	slli	a4,a4,0x20
  f4:	9301                	srli	a4,a4,0x20
  f6:	974a                	add	a4,a4,s2
  f8:	070e                	slli	a4,a4,0x3
  fa:	00898693          	addi	a3,s3,8
  fe:	9736                	add	a4,a4,a3
		buf[i] = 0;
 100:	0007b023          	sd	zero,0(a5)
	for (int i = idx;i < 64;i++)
 104:	07a1                	addi	a5,a5,8
 106:	fee79de3          	bne	a5,a4,100 <main+0x100>
	if (fork() == 0)
 10a:	00000097          	auipc	ra,0x0
 10e:	29a080e7          	jalr	666(ra) # 3a4 <fork>
 112:	ed09                	bnez	a0,12c <main+0x12c>
	{
		exec((char*)argv[1],(char**)buf);
 114:	85ce                	mv	a1,s3
 116:	008a3503          	ld	a0,8(s4)
 11a:	00000097          	auipc	ra,0x0
 11e:	2ca080e7          	jalr	714(ra) # 3e4 <exec>
		exit(0);
 122:	4501                	li	a0,0
 124:	00000097          	auipc	ra,0x0
 128:	288080e7          	jalr	648(ra) # 3ac <exit>
	}
	wait(0);
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	286080e7          	jalr	646(ra) # 3b4 <wait>
	exit(0);
 136:	4501                	li	a0,0
 138:	00000097          	auipc	ra,0x0
 13c:	274080e7          	jalr	628(ra) # 3ac <exit>

0000000000000140 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 146:	87aa                	mv	a5,a0
 148:	0585                	addi	a1,a1,1
 14a:	0785                	addi	a5,a5,1
 14c:	fff5c703          	lbu	a4,-1(a1)
 150:	fee78fa3          	sb	a4,-1(a5)
 154:	fb75                	bnez	a4,148 <strcpy+0x8>
    ;
  return os;
}
 156:	6422                	ld	s0,8(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret

000000000000015c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 162:	00054783          	lbu	a5,0(a0)
 166:	cb91                	beqz	a5,17a <strcmp+0x1e>
 168:	0005c703          	lbu	a4,0(a1)
 16c:	00f71763          	bne	a4,a5,17a <strcmp+0x1e>
    p++, q++;
 170:	0505                	addi	a0,a0,1
 172:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 174:	00054783          	lbu	a5,0(a0)
 178:	fbe5                	bnez	a5,168 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 17a:	0005c503          	lbu	a0,0(a1)
}
 17e:	40a7853b          	subw	a0,a5,a0
 182:	6422                	ld	s0,8(sp)
 184:	0141                	addi	sp,sp,16
 186:	8082                	ret

0000000000000188 <strlen>:

uint
strlen(const char *s)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e422                	sd	s0,8(sp)
 18c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 18e:	00054783          	lbu	a5,0(a0)
 192:	cf91                	beqz	a5,1ae <strlen+0x26>
 194:	0505                	addi	a0,a0,1
 196:	87aa                	mv	a5,a0
 198:	4685                	li	a3,1
 19a:	9e89                	subw	a3,a3,a0
 19c:	00f6853b          	addw	a0,a3,a5
 1a0:	0785                	addi	a5,a5,1
 1a2:	fff7c703          	lbu	a4,-1(a5)
 1a6:	fb7d                	bnez	a4,19c <strlen+0x14>
    ;
  return n;
}
 1a8:	6422                	ld	s0,8(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret
  for(n = 0; s[n]; n++)
 1ae:	4501                	li	a0,0
 1b0:	bfe5                	j	1a8 <strlen+0x20>

00000000000001b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b8:	ca19                	beqz	a2,1ce <memset+0x1c>
 1ba:	87aa                	mv	a5,a0
 1bc:	1602                	slli	a2,a2,0x20
 1be:	9201                	srli	a2,a2,0x20
 1c0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c8:	0785                	addi	a5,a5,1
 1ca:	fee79de3          	bne	a5,a4,1c4 <memset+0x12>
  }
  return dst;
}
 1ce:	6422                	ld	s0,8(sp)
 1d0:	0141                	addi	sp,sp,16
 1d2:	8082                	ret

00000000000001d4 <strchr>:

char*
strchr(const char *s, char c)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1da:	00054783          	lbu	a5,0(a0)
 1de:	cb99                	beqz	a5,1f4 <strchr+0x20>
    if(*s == c)
 1e0:	00f58763          	beq	a1,a5,1ee <strchr+0x1a>
  for(; *s; s++)
 1e4:	0505                	addi	a0,a0,1
 1e6:	00054783          	lbu	a5,0(a0)
 1ea:	fbfd                	bnez	a5,1e0 <strchr+0xc>
      return (char*)s;
  return 0;
 1ec:	4501                	li	a0,0
}
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret
  return 0;
 1f4:	4501                	li	a0,0
 1f6:	bfe5                	j	1ee <strchr+0x1a>

00000000000001f8 <gets>:

char*
gets(char *buf, int max)
{
 1f8:	711d                	addi	sp,sp,-96
 1fa:	ec86                	sd	ra,88(sp)
 1fc:	e8a2                	sd	s0,80(sp)
 1fe:	e4a6                	sd	s1,72(sp)
 200:	e0ca                	sd	s2,64(sp)
 202:	fc4e                	sd	s3,56(sp)
 204:	f852                	sd	s4,48(sp)
 206:	f456                	sd	s5,40(sp)
 208:	f05a                	sd	s6,32(sp)
 20a:	ec5e                	sd	s7,24(sp)
 20c:	1080                	addi	s0,sp,96
 20e:	8baa                	mv	s7,a0
 210:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 212:	892a                	mv	s2,a0
 214:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 216:	4aa9                	li	s5,10
 218:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 21a:	89a6                	mv	s3,s1
 21c:	2485                	addiw	s1,s1,1
 21e:	0344d863          	bge	s1,s4,24e <gets+0x56>
    cc = read(0, &c, 1);
 222:	4605                	li	a2,1
 224:	faf40593          	addi	a1,s0,-81
 228:	4501                	li	a0,0
 22a:	00000097          	auipc	ra,0x0
 22e:	19a080e7          	jalr	410(ra) # 3c4 <read>
    if(cc < 1)
 232:	00a05e63          	blez	a0,24e <gets+0x56>
    buf[i++] = c;
 236:	faf44783          	lbu	a5,-81(s0)
 23a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 23e:	01578763          	beq	a5,s5,24c <gets+0x54>
 242:	0905                	addi	s2,s2,1
 244:	fd679be3          	bne	a5,s6,21a <gets+0x22>
  for(i=0; i+1 < max; ){
 248:	89a6                	mv	s3,s1
 24a:	a011                	j	24e <gets+0x56>
 24c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 24e:	99de                	add	s3,s3,s7
 250:	00098023          	sb	zero,0(s3)
  return buf;
}
 254:	855e                	mv	a0,s7
 256:	60e6                	ld	ra,88(sp)
 258:	6446                	ld	s0,80(sp)
 25a:	64a6                	ld	s1,72(sp)
 25c:	6906                	ld	s2,64(sp)
 25e:	79e2                	ld	s3,56(sp)
 260:	7a42                	ld	s4,48(sp)
 262:	7aa2                	ld	s5,40(sp)
 264:	7b02                	ld	s6,32(sp)
 266:	6be2                	ld	s7,24(sp)
 268:	6125                	addi	sp,sp,96
 26a:	8082                	ret

000000000000026c <stat>:

int
stat(const char *n, struct stat *st)
{
 26c:	1101                	addi	sp,sp,-32
 26e:	ec06                	sd	ra,24(sp)
 270:	e822                	sd	s0,16(sp)
 272:	e426                	sd	s1,8(sp)
 274:	e04a                	sd	s2,0(sp)
 276:	1000                	addi	s0,sp,32
 278:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27a:	4581                	li	a1,0
 27c:	00000097          	auipc	ra,0x0
 280:	170080e7          	jalr	368(ra) # 3ec <open>
  if(fd < 0)
 284:	02054563          	bltz	a0,2ae <stat+0x42>
 288:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 28a:	85ca                	mv	a1,s2
 28c:	00000097          	auipc	ra,0x0
 290:	178080e7          	jalr	376(ra) # 404 <fstat>
 294:	892a                	mv	s2,a0
  close(fd);
 296:	8526                	mv	a0,s1
 298:	00000097          	auipc	ra,0x0
 29c:	13c080e7          	jalr	316(ra) # 3d4 <close>
  return r;
}
 2a0:	854a                	mv	a0,s2
 2a2:	60e2                	ld	ra,24(sp)
 2a4:	6442                	ld	s0,16(sp)
 2a6:	64a2                	ld	s1,8(sp)
 2a8:	6902                	ld	s2,0(sp)
 2aa:	6105                	addi	sp,sp,32
 2ac:	8082                	ret
    return -1;
 2ae:	597d                	li	s2,-1
 2b0:	bfc5                	j	2a0 <stat+0x34>

00000000000002b2 <atoi>:

int
atoi(const char *s)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b8:	00054683          	lbu	a3,0(a0)
 2bc:	fd06879b          	addiw	a5,a3,-48
 2c0:	0ff7f793          	zext.b	a5,a5
 2c4:	4625                	li	a2,9
 2c6:	02f66863          	bltu	a2,a5,2f6 <atoi+0x44>
 2ca:	872a                	mv	a4,a0
  n = 0;
 2cc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ce:	0705                	addi	a4,a4,1
 2d0:	0025179b          	slliw	a5,a0,0x2
 2d4:	9fa9                	addw	a5,a5,a0
 2d6:	0017979b          	slliw	a5,a5,0x1
 2da:	9fb5                	addw	a5,a5,a3
 2dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2e0:	00074683          	lbu	a3,0(a4)
 2e4:	fd06879b          	addiw	a5,a3,-48
 2e8:	0ff7f793          	zext.b	a5,a5
 2ec:	fef671e3          	bgeu	a2,a5,2ce <atoi+0x1c>
  return n;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
  n = 0;
 2f6:	4501                	li	a0,0
 2f8:	bfe5                	j	2f0 <atoi+0x3e>

00000000000002fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e422                	sd	s0,8(sp)
 2fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 300:	02b57463          	bgeu	a0,a1,328 <memmove+0x2e>
    while(n-- > 0)
 304:	00c05f63          	blez	a2,322 <memmove+0x28>
 308:	1602                	slli	a2,a2,0x20
 30a:	9201                	srli	a2,a2,0x20
 30c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 310:	872a                	mv	a4,a0
      *dst++ = *src++;
 312:	0585                	addi	a1,a1,1
 314:	0705                	addi	a4,a4,1
 316:	fff5c683          	lbu	a3,-1(a1)
 31a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 31e:	fee79ae3          	bne	a5,a4,312 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 322:	6422                	ld	s0,8(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret
    dst += n;
 328:	00c50733          	add	a4,a0,a2
    src += n;
 32c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 32e:	fec05ae3          	blez	a2,322 <memmove+0x28>
 332:	fff6079b          	addiw	a5,a2,-1
 336:	1782                	slli	a5,a5,0x20
 338:	9381                	srli	a5,a5,0x20
 33a:	fff7c793          	not	a5,a5
 33e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 340:	15fd                	addi	a1,a1,-1
 342:	177d                	addi	a4,a4,-1
 344:	0005c683          	lbu	a3,0(a1)
 348:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 34c:	fee79ae3          	bne	a5,a4,340 <memmove+0x46>
 350:	bfc9                	j	322 <memmove+0x28>

0000000000000352 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 352:	1141                	addi	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 358:	ca05                	beqz	a2,388 <memcmp+0x36>
 35a:	fff6069b          	addiw	a3,a2,-1
 35e:	1682                	slli	a3,a3,0x20
 360:	9281                	srli	a3,a3,0x20
 362:	0685                	addi	a3,a3,1
 364:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 366:	00054783          	lbu	a5,0(a0)
 36a:	0005c703          	lbu	a4,0(a1)
 36e:	00e79863          	bne	a5,a4,37e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 372:	0505                	addi	a0,a0,1
    p2++;
 374:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 376:	fed518e3          	bne	a0,a3,366 <memcmp+0x14>
  }
  return 0;
 37a:	4501                	li	a0,0
 37c:	a019                	j	382 <memcmp+0x30>
      return *p1 - *p2;
 37e:	40e7853b          	subw	a0,a5,a4
}
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret
  return 0;
 388:	4501                	li	a0,0
 38a:	bfe5                	j	382 <memcmp+0x30>

000000000000038c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 38c:	1141                	addi	sp,sp,-16
 38e:	e406                	sd	ra,8(sp)
 390:	e022                	sd	s0,0(sp)
 392:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 394:	00000097          	auipc	ra,0x0
 398:	f66080e7          	jalr	-154(ra) # 2fa <memmove>
}
 39c:	60a2                	ld	ra,8(sp)
 39e:	6402                	ld	s0,0(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret

00000000000003a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a4:	4885                	li	a7,1
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ac:	4889                	li	a7,2
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b4:	488d                	li	a7,3
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3bc:	4891                	li	a7,4
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <read>:
.global read
read:
 li a7, SYS_read
 3c4:	4895                	li	a7,5
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <write>:
.global write
write:
 li a7, SYS_write
 3cc:	48c1                	li	a7,16
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <close>:
.global close
close:
 li a7, SYS_close
 3d4:	48d5                	li	a7,21
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3dc:	4899                	li	a7,6
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e4:	489d                	li	a7,7
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <open>:
.global open
open:
 li a7, SYS_open
 3ec:	48bd                	li	a7,15
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f4:	48c5                	li	a7,17
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fc:	48c9                	li	a7,18
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 404:	48a1                	li	a7,8
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <link>:
.global link
link:
 li a7, SYS_link
 40c:	48cd                	li	a7,19
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 414:	48d1                	li	a7,20
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41c:	48a5                	li	a7,9
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <dup>:
.global dup
dup:
 li a7, SYS_dup
 424:	48a9                	li	a7,10
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42c:	48ad                	li	a7,11
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 434:	48b1                	li	a7,12
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 43c:	48b5                	li	a7,13
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 444:	48b9                	li	a7,14
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 44c:	1101                	addi	sp,sp,-32
 44e:	ec06                	sd	ra,24(sp)
 450:	e822                	sd	s0,16(sp)
 452:	1000                	addi	s0,sp,32
 454:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 458:	4605                	li	a2,1
 45a:	fef40593          	addi	a1,s0,-17
 45e:	00000097          	auipc	ra,0x0
 462:	f6e080e7          	jalr	-146(ra) # 3cc <write>
}
 466:	60e2                	ld	ra,24(sp)
 468:	6442                	ld	s0,16(sp)
 46a:	6105                	addi	sp,sp,32
 46c:	8082                	ret

000000000000046e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46e:	7139                	addi	sp,sp,-64
 470:	fc06                	sd	ra,56(sp)
 472:	f822                	sd	s0,48(sp)
 474:	f426                	sd	s1,40(sp)
 476:	f04a                	sd	s2,32(sp)
 478:	ec4e                	sd	s3,24(sp)
 47a:	0080                	addi	s0,sp,64
 47c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 47e:	c299                	beqz	a3,484 <printint+0x16>
 480:	0805c963          	bltz	a1,512 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 484:	2581                	sext.w	a1,a1
  neg = 0;
 486:	4881                	li	a7,0
 488:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 48c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 48e:	2601                	sext.w	a2,a2
 490:	00000517          	auipc	a0,0x0
 494:	4b050513          	addi	a0,a0,1200 # 940 <digits>
 498:	883a                	mv	a6,a4
 49a:	2705                	addiw	a4,a4,1
 49c:	02c5f7bb          	remuw	a5,a1,a2
 4a0:	1782                	slli	a5,a5,0x20
 4a2:	9381                	srli	a5,a5,0x20
 4a4:	97aa                	add	a5,a5,a0
 4a6:	0007c783          	lbu	a5,0(a5)
 4aa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ae:	0005879b          	sext.w	a5,a1
 4b2:	02c5d5bb          	divuw	a1,a1,a2
 4b6:	0685                	addi	a3,a3,1
 4b8:	fec7f0e3          	bgeu	a5,a2,498 <printint+0x2a>
  if(neg)
 4bc:	00088c63          	beqz	a7,4d4 <printint+0x66>
    buf[i++] = '-';
 4c0:	fd070793          	addi	a5,a4,-48
 4c4:	00878733          	add	a4,a5,s0
 4c8:	02d00793          	li	a5,45
 4cc:	fef70823          	sb	a5,-16(a4)
 4d0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4d4:	02e05863          	blez	a4,504 <printint+0x96>
 4d8:	fc040793          	addi	a5,s0,-64
 4dc:	00e78933          	add	s2,a5,a4
 4e0:	fff78993          	addi	s3,a5,-1
 4e4:	99ba                	add	s3,s3,a4
 4e6:	377d                	addiw	a4,a4,-1
 4e8:	1702                	slli	a4,a4,0x20
 4ea:	9301                	srli	a4,a4,0x20
 4ec:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f0:	fff94583          	lbu	a1,-1(s2)
 4f4:	8526                	mv	a0,s1
 4f6:	00000097          	auipc	ra,0x0
 4fa:	f56080e7          	jalr	-170(ra) # 44c <putc>
  while(--i >= 0)
 4fe:	197d                	addi	s2,s2,-1
 500:	ff3918e3          	bne	s2,s3,4f0 <printint+0x82>
}
 504:	70e2                	ld	ra,56(sp)
 506:	7442                	ld	s0,48(sp)
 508:	74a2                	ld	s1,40(sp)
 50a:	7902                	ld	s2,32(sp)
 50c:	69e2                	ld	s3,24(sp)
 50e:	6121                	addi	sp,sp,64
 510:	8082                	ret
    x = -xx;
 512:	40b005bb          	negw	a1,a1
    neg = 1;
 516:	4885                	li	a7,1
    x = -xx;
 518:	bf85                	j	488 <printint+0x1a>

000000000000051a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51a:	7119                	addi	sp,sp,-128
 51c:	fc86                	sd	ra,120(sp)
 51e:	f8a2                	sd	s0,112(sp)
 520:	f4a6                	sd	s1,104(sp)
 522:	f0ca                	sd	s2,96(sp)
 524:	ecce                	sd	s3,88(sp)
 526:	e8d2                	sd	s4,80(sp)
 528:	e4d6                	sd	s5,72(sp)
 52a:	e0da                	sd	s6,64(sp)
 52c:	fc5e                	sd	s7,56(sp)
 52e:	f862                	sd	s8,48(sp)
 530:	f466                	sd	s9,40(sp)
 532:	f06a                	sd	s10,32(sp)
 534:	ec6e                	sd	s11,24(sp)
 536:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 538:	0005c903          	lbu	s2,0(a1)
 53c:	18090f63          	beqz	s2,6da <vprintf+0x1c0>
 540:	8aaa                	mv	s5,a0
 542:	8b32                	mv	s6,a2
 544:	00158493          	addi	s1,a1,1
  state = 0;
 548:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 54a:	02500a13          	li	s4,37
 54e:	4c55                	li	s8,21
 550:	00000c97          	auipc	s9,0x0
 554:	398c8c93          	addi	s9,s9,920 # 8e8 <malloc+0x10a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 558:	02800d93          	li	s11,40
  putc(fd, 'x');
 55c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 55e:	00000b97          	auipc	s7,0x0
 562:	3e2b8b93          	addi	s7,s7,994 # 940 <digits>
 566:	a839                	j	584 <vprintf+0x6a>
        putc(fd, c);
 568:	85ca                	mv	a1,s2
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	ee0080e7          	jalr	-288(ra) # 44c <putc>
 574:	a019                	j	57a <vprintf+0x60>
    } else if(state == '%'){
 576:	01498d63          	beq	s3,s4,590 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 57a:	0485                	addi	s1,s1,1
 57c:	fff4c903          	lbu	s2,-1(s1)
 580:	14090d63          	beqz	s2,6da <vprintf+0x1c0>
    if(state == 0){
 584:	fe0999e3          	bnez	s3,576 <vprintf+0x5c>
      if(c == '%'){
 588:	ff4910e3          	bne	s2,s4,568 <vprintf+0x4e>
        state = '%';
 58c:	89d2                	mv	s3,s4
 58e:	b7f5                	j	57a <vprintf+0x60>
      if(c == 'd'){
 590:	11490c63          	beq	s2,s4,6a8 <vprintf+0x18e>
 594:	f9d9079b          	addiw	a5,s2,-99
 598:	0ff7f793          	zext.b	a5,a5
 59c:	10fc6e63          	bltu	s8,a5,6b8 <vprintf+0x19e>
 5a0:	f9d9079b          	addiw	a5,s2,-99
 5a4:	0ff7f713          	zext.b	a4,a5
 5a8:	10ec6863          	bltu	s8,a4,6b8 <vprintf+0x19e>
 5ac:	00271793          	slli	a5,a4,0x2
 5b0:	97e6                	add	a5,a5,s9
 5b2:	439c                	lw	a5,0(a5)
 5b4:	97e6                	add	a5,a5,s9
 5b6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5b8:	008b0913          	addi	s2,s6,8
 5bc:	4685                	li	a3,1
 5be:	4629                	li	a2,10
 5c0:	000b2583          	lw	a1,0(s6)
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	ea8080e7          	jalr	-344(ra) # 46e <printint>
 5ce:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b765                	j	57a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d4:	008b0913          	addi	s2,s6,8
 5d8:	4681                	li	a3,0
 5da:	4629                	li	a2,10
 5dc:	000b2583          	lw	a1,0(s6)
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	e8c080e7          	jalr	-372(ra) # 46e <printint>
 5ea:	8b4a                	mv	s6,s2
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b771                	j	57a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5f0:	008b0913          	addi	s2,s6,8
 5f4:	4681                	li	a3,0
 5f6:	866a                	mv	a2,s10
 5f8:	000b2583          	lw	a1,0(s6)
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e70080e7          	jalr	-400(ra) # 46e <printint>
 606:	8b4a                	mv	s6,s2
      state = 0;
 608:	4981                	li	s3,0
 60a:	bf85                	j	57a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 60c:	008b0793          	addi	a5,s6,8
 610:	f8f43423          	sd	a5,-120(s0)
 614:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 618:	03000593          	li	a1,48
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	e2e080e7          	jalr	-466(ra) # 44c <putc>
  putc(fd, 'x');
 626:	07800593          	li	a1,120
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	e20080e7          	jalr	-480(ra) # 44c <putc>
 634:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 636:	03c9d793          	srli	a5,s3,0x3c
 63a:	97de                	add	a5,a5,s7
 63c:	0007c583          	lbu	a1,0(a5)
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	e0a080e7          	jalr	-502(ra) # 44c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 64a:	0992                	slli	s3,s3,0x4
 64c:	397d                	addiw	s2,s2,-1
 64e:	fe0914e3          	bnez	s2,636 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 652:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 656:	4981                	li	s3,0
 658:	b70d                	j	57a <vprintf+0x60>
        s = va_arg(ap, char*);
 65a:	008b0913          	addi	s2,s6,8
 65e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 662:	02098163          	beqz	s3,684 <vprintf+0x16a>
        while(*s != 0){
 666:	0009c583          	lbu	a1,0(s3)
 66a:	c5ad                	beqz	a1,6d4 <vprintf+0x1ba>
          putc(fd, *s);
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	dde080e7          	jalr	-546(ra) # 44c <putc>
          s++;
 676:	0985                	addi	s3,s3,1
        while(*s != 0){
 678:	0009c583          	lbu	a1,0(s3)
 67c:	f9e5                	bnez	a1,66c <vprintf+0x152>
        s = va_arg(ap, char*);
 67e:	8b4a                	mv	s6,s2
      state = 0;
 680:	4981                	li	s3,0
 682:	bde5                	j	57a <vprintf+0x60>
          s = "(null)";
 684:	00000997          	auipc	s3,0x0
 688:	25c98993          	addi	s3,s3,604 # 8e0 <malloc+0x102>
        while(*s != 0){
 68c:	85ee                	mv	a1,s11
 68e:	bff9                	j	66c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 690:	008b0913          	addi	s2,s6,8
 694:	000b4583          	lbu	a1,0(s6)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	db2080e7          	jalr	-590(ra) # 44c <putc>
 6a2:	8b4a                	mv	s6,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bdd1                	j	57a <vprintf+0x60>
        putc(fd, c);
 6a8:	85d2                	mv	a1,s4
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	da0080e7          	jalr	-608(ra) # 44c <putc>
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b5d1                	j	57a <vprintf+0x60>
        putc(fd, '%');
 6b8:	85d2                	mv	a1,s4
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	d90080e7          	jalr	-624(ra) # 44c <putc>
        putc(fd, c);
 6c4:	85ca                	mv	a1,s2
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	d84080e7          	jalr	-636(ra) # 44c <putc>
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b565                	j	57a <vprintf+0x60>
        s = va_arg(ap, char*);
 6d4:	8b4a                	mv	s6,s2
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	b54d                	j	57a <vprintf+0x60>
    }
  }
}
 6da:	70e6                	ld	ra,120(sp)
 6dc:	7446                	ld	s0,112(sp)
 6de:	74a6                	ld	s1,104(sp)
 6e0:	7906                	ld	s2,96(sp)
 6e2:	69e6                	ld	s3,88(sp)
 6e4:	6a46                	ld	s4,80(sp)
 6e6:	6aa6                	ld	s5,72(sp)
 6e8:	6b06                	ld	s6,64(sp)
 6ea:	7be2                	ld	s7,56(sp)
 6ec:	7c42                	ld	s8,48(sp)
 6ee:	7ca2                	ld	s9,40(sp)
 6f0:	7d02                	ld	s10,32(sp)
 6f2:	6de2                	ld	s11,24(sp)
 6f4:	6109                	addi	sp,sp,128
 6f6:	8082                	ret

00000000000006f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f8:	715d                	addi	sp,sp,-80
 6fa:	ec06                	sd	ra,24(sp)
 6fc:	e822                	sd	s0,16(sp)
 6fe:	1000                	addi	s0,sp,32
 700:	e010                	sd	a2,0(s0)
 702:	e414                	sd	a3,8(s0)
 704:	e818                	sd	a4,16(s0)
 706:	ec1c                	sd	a5,24(s0)
 708:	03043023          	sd	a6,32(s0)
 70c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 710:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 714:	8622                	mv	a2,s0
 716:	00000097          	auipc	ra,0x0
 71a:	e04080e7          	jalr	-508(ra) # 51a <vprintf>
}
 71e:	60e2                	ld	ra,24(sp)
 720:	6442                	ld	s0,16(sp)
 722:	6161                	addi	sp,sp,80
 724:	8082                	ret

0000000000000726 <printf>:

void
printf(const char *fmt, ...)
{
 726:	711d                	addi	sp,sp,-96
 728:	ec06                	sd	ra,24(sp)
 72a:	e822                	sd	s0,16(sp)
 72c:	1000                	addi	s0,sp,32
 72e:	e40c                	sd	a1,8(s0)
 730:	e810                	sd	a2,16(s0)
 732:	ec14                	sd	a3,24(s0)
 734:	f018                	sd	a4,32(s0)
 736:	f41c                	sd	a5,40(s0)
 738:	03043823          	sd	a6,48(s0)
 73c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 740:	00840613          	addi	a2,s0,8
 744:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 748:	85aa                	mv	a1,a0
 74a:	4505                	li	a0,1
 74c:	00000097          	auipc	ra,0x0
 750:	dce080e7          	jalr	-562(ra) # 51a <vprintf>
}
 754:	60e2                	ld	ra,24(sp)
 756:	6442                	ld	s0,16(sp)
 758:	6125                	addi	sp,sp,96
 75a:	8082                	ret

000000000000075c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75c:	1141                	addi	sp,sp,-16
 75e:	e422                	sd	s0,8(sp)
 760:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 762:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 766:	00000797          	auipc	a5,0x0
 76a:	1f27b783          	ld	a5,498(a5) # 958 <freep>
 76e:	a02d                	j	798 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 770:	4618                	lw	a4,8(a2)
 772:	9f2d                	addw	a4,a4,a1
 774:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 778:	6398                	ld	a4,0(a5)
 77a:	6310                	ld	a2,0(a4)
 77c:	a83d                	j	7ba <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 77e:	ff852703          	lw	a4,-8(a0)
 782:	9f31                	addw	a4,a4,a2
 784:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 786:	ff053683          	ld	a3,-16(a0)
 78a:	a091                	j	7ce <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78c:	6398                	ld	a4,0(a5)
 78e:	00e7e463          	bltu	a5,a4,796 <free+0x3a>
 792:	00e6ea63          	bltu	a3,a4,7a6 <free+0x4a>
{
 796:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 798:	fed7fae3          	bgeu	a5,a3,78c <free+0x30>
 79c:	6398                	ld	a4,0(a5)
 79e:	00e6e463          	bltu	a3,a4,7a6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a2:	fee7eae3          	bltu	a5,a4,796 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7a6:	ff852583          	lw	a1,-8(a0)
 7aa:	6390                	ld	a2,0(a5)
 7ac:	02059813          	slli	a6,a1,0x20
 7b0:	01c85713          	srli	a4,a6,0x1c
 7b4:	9736                	add	a4,a4,a3
 7b6:	fae60de3          	beq	a2,a4,770 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7ba:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7be:	4790                	lw	a2,8(a5)
 7c0:	02061593          	slli	a1,a2,0x20
 7c4:	01c5d713          	srli	a4,a1,0x1c
 7c8:	973e                	add	a4,a4,a5
 7ca:	fae68ae3          	beq	a3,a4,77e <free+0x22>
    p->s.ptr = bp->s.ptr;
 7ce:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d0:	00000717          	auipc	a4,0x0
 7d4:	18f73423          	sd	a5,392(a4) # 958 <freep>
}
 7d8:	6422                	ld	s0,8(sp)
 7da:	0141                	addi	sp,sp,16
 7dc:	8082                	ret

00000000000007de <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7de:	7139                	addi	sp,sp,-64
 7e0:	fc06                	sd	ra,56(sp)
 7e2:	f822                	sd	s0,48(sp)
 7e4:	f426                	sd	s1,40(sp)
 7e6:	f04a                	sd	s2,32(sp)
 7e8:	ec4e                	sd	s3,24(sp)
 7ea:	e852                	sd	s4,16(sp)
 7ec:	e456                	sd	s5,8(sp)
 7ee:	e05a                	sd	s6,0(sp)
 7f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f2:	02051493          	slli	s1,a0,0x20
 7f6:	9081                	srli	s1,s1,0x20
 7f8:	04bd                	addi	s1,s1,15
 7fa:	8091                	srli	s1,s1,0x4
 7fc:	0014899b          	addiw	s3,s1,1
 800:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 802:	00000517          	auipc	a0,0x0
 806:	15653503          	ld	a0,342(a0) # 958 <freep>
 80a:	c515                	beqz	a0,836 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80e:	4798                	lw	a4,8(a5)
 810:	02977f63          	bgeu	a4,s1,84e <malloc+0x70>
 814:	8a4e                	mv	s4,s3
 816:	0009871b          	sext.w	a4,s3
 81a:	6685                	lui	a3,0x1
 81c:	00d77363          	bgeu	a4,a3,822 <malloc+0x44>
 820:	6a05                	lui	s4,0x1
 822:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 826:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 82a:	00000917          	auipc	s2,0x0
 82e:	12e90913          	addi	s2,s2,302 # 958 <freep>
  if(p == (char*)-1)
 832:	5afd                	li	s5,-1
 834:	a895                	j	8a8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 836:	00000797          	auipc	a5,0x0
 83a:	12a78793          	addi	a5,a5,298 # 960 <base>
 83e:	00000717          	auipc	a4,0x0
 842:	10f73d23          	sd	a5,282(a4) # 958 <freep>
 846:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 848:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 84c:	b7e1                	j	814 <malloc+0x36>
      if(p->s.size == nunits)
 84e:	02e48c63          	beq	s1,a4,886 <malloc+0xa8>
        p->s.size -= nunits;
 852:	4137073b          	subw	a4,a4,s3
 856:	c798                	sw	a4,8(a5)
        p += p->s.size;
 858:	02071693          	slli	a3,a4,0x20
 85c:	01c6d713          	srli	a4,a3,0x1c
 860:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 862:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 866:	00000717          	auipc	a4,0x0
 86a:	0ea73923          	sd	a0,242(a4) # 958 <freep>
      return (void*)(p + 1);
 86e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 872:	70e2                	ld	ra,56(sp)
 874:	7442                	ld	s0,48(sp)
 876:	74a2                	ld	s1,40(sp)
 878:	7902                	ld	s2,32(sp)
 87a:	69e2                	ld	s3,24(sp)
 87c:	6a42                	ld	s4,16(sp)
 87e:	6aa2                	ld	s5,8(sp)
 880:	6b02                	ld	s6,0(sp)
 882:	6121                	addi	sp,sp,64
 884:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 886:	6398                	ld	a4,0(a5)
 888:	e118                	sd	a4,0(a0)
 88a:	bff1                	j	866 <malloc+0x88>
  hp->s.size = nu;
 88c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 890:	0541                	addi	a0,a0,16
 892:	00000097          	auipc	ra,0x0
 896:	eca080e7          	jalr	-310(ra) # 75c <free>
  return freep;
 89a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 89e:	d971                	beqz	a0,872 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a2:	4798                	lw	a4,8(a5)
 8a4:	fa9775e3          	bgeu	a4,s1,84e <malloc+0x70>
    if(p == freep)
 8a8:	00093703          	ld	a4,0(s2)
 8ac:	853e                	mv	a0,a5
 8ae:	fef719e3          	bne	a4,a5,8a0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8b2:	8552                	mv	a0,s4
 8b4:	00000097          	auipc	ra,0x0
 8b8:	b80080e7          	jalr	-1152(ra) # 434 <sbrk>
  if(p == (char*)-1)
 8bc:	fd5518e3          	bne	a0,s5,88c <malloc+0xae>
        return 0;
 8c0:	4501                	li	a0,0
 8c2:	bf45                	j	872 <malloc+0x94>
