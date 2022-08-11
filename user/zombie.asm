
user/_zombie：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	29c080e7          	jalr	668(ra) # 2a4 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	296080e7          	jalr	662(ra) # 2ac <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	31c080e7          	jalr	796(ra) # 33c <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <strcpy>:



char*
strcpy(char *s, const char *t)
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e422                	sd	s0,8(sp)
  2e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  30:	87aa                	mv	a5,a0
  32:	0585                	addi	a1,a1,1
  34:	0785                	addi	a5,a5,1
  36:	fff5c703          	lbu	a4,-1(a1)
  3a:	fee78fa3          	sb	a4,-1(a5)
  3e:	fb75                	bnez	a4,32 <strcpy+0x8>
    ;
  return os;
}
  40:	6422                	ld	s0,8(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret

0000000000000046 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  46:	1141                	addi	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	cb91                	beqz	a5,64 <strcmp+0x1e>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71763          	bne	a4,a5,64 <strcmp+0x1e>
    p++, q++;
  5a:	0505                	addi	a0,a0,1
  5c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	fbe5                	bnez	a5,52 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  64:	0005c503          	lbu	a0,0(a1)
}
  68:	40a7853b          	subw	a0,a5,a0
  6c:	6422                	ld	s0,8(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  78:	00054783          	lbu	a5,0(a0)
  7c:	cf91                	beqz	a5,98 <strlen+0x26>
  7e:	0505                	addi	a0,a0,1
  80:	87aa                	mv	a5,a0
  82:	4685                	li	a3,1
  84:	9e89                	subw	a3,a3,a0
  86:	00f6853b          	addw	a0,a3,a5
  8a:	0785                	addi	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	fb7d                	bnez	a4,86 <strlen+0x14>
    ;
  return n;
}
  92:	6422                	ld	s0,8(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret
  for(n = 0; s[n]; n++)
  98:	4501                	li	a0,0
  9a:	bfe5                	j	92 <strlen+0x20>

000000000000009c <memset>:

void*
memset(void *dst, int c, uint n)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a2:	ca19                	beqz	a2,b8 <memset+0x1c>
  a4:	87aa                	mv	a5,a0
  a6:	1602                	slli	a2,a2,0x20
  a8:	9201                	srli	a2,a2,0x20
  aa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b2:	0785                	addi	a5,a5,1
  b4:	fee79de3          	bne	a5,a4,ae <memset+0x12>
  }
  return dst;
}
  b8:	6422                	ld	s0,8(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret

00000000000000be <strchr>:

char*
strchr(const char *s, char c)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e422                	sd	s0,8(sp)
  c2:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb99                	beqz	a5,de <strchr+0x20>
    if(*s == c)
  ca:	00f58763          	beq	a1,a5,d8 <strchr+0x1a>
  for(; *s; s++)
  ce:	0505                	addi	a0,a0,1
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbfd                	bnez	a5,ca <strchr+0xc>
      return (char*)s;
  return 0;
  d6:	4501                	li	a0,0
}
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
  return 0;
  de:	4501                	li	a0,0
  e0:	bfe5                	j	d8 <strchr+0x1a>

00000000000000e2 <gets>:

char*
gets(char *buf, int max)
{
  e2:	711d                	addi	sp,sp,-96
  e4:	ec86                	sd	ra,88(sp)
  e6:	e8a2                	sd	s0,80(sp)
  e8:	e4a6                	sd	s1,72(sp)
  ea:	e0ca                	sd	s2,64(sp)
  ec:	fc4e                	sd	s3,56(sp)
  ee:	f852                	sd	s4,48(sp)
  f0:	f456                	sd	s5,40(sp)
  f2:	f05a                	sd	s6,32(sp)
  f4:	ec5e                	sd	s7,24(sp)
  f6:	1080                	addi	s0,sp,96
  f8:	8baa                	mv	s7,a0
  fa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fc:	892a                	mv	s2,a0
  fe:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 100:	4aa9                	li	s5,10
 102:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 104:	89a6                	mv	s3,s1
 106:	2485                	addiw	s1,s1,1
 108:	0344d863          	bge	s1,s4,138 <gets+0x56>
    cc = read(0, &c, 1);
 10c:	4605                	li	a2,1
 10e:	faf40593          	addi	a1,s0,-81
 112:	4501                	li	a0,0
 114:	00000097          	auipc	ra,0x0
 118:	1b0080e7          	jalr	432(ra) # 2c4 <read>
    if(cc < 1)
 11c:	00a05e63          	blez	a0,138 <gets+0x56>
    buf[i++] = c;
 120:	faf44783          	lbu	a5,-81(s0)
 124:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 128:	01578763          	beq	a5,s5,136 <gets+0x54>
 12c:	0905                	addi	s2,s2,1
 12e:	fd679be3          	bne	a5,s6,104 <gets+0x22>
  for(i=0; i+1 < max; ){
 132:	89a6                	mv	s3,s1
 134:	a011                	j	138 <gets+0x56>
 136:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 138:	99de                	add	s3,s3,s7
 13a:	00098023          	sb	zero,0(s3)
  return buf;
}
 13e:	855e                	mv	a0,s7
 140:	60e6                	ld	ra,88(sp)
 142:	6446                	ld	s0,80(sp)
 144:	64a6                	ld	s1,72(sp)
 146:	6906                	ld	s2,64(sp)
 148:	79e2                	ld	s3,56(sp)
 14a:	7a42                	ld	s4,48(sp)
 14c:	7aa2                	ld	s5,40(sp)
 14e:	7b02                	ld	s6,32(sp)
 150:	6be2                	ld	s7,24(sp)
 152:	6125                	addi	sp,sp,96
 154:	8082                	ret

0000000000000156 <stat>:

int
stat(const char *n, struct stat *st)
{
 156:	1101                	addi	sp,sp,-32
 158:	ec06                	sd	ra,24(sp)
 15a:	e822                	sd	s0,16(sp)
 15c:	e426                	sd	s1,8(sp)
 15e:	e04a                	sd	s2,0(sp)
 160:	1000                	addi	s0,sp,32
 162:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 164:	4581                	li	a1,0
 166:	00000097          	auipc	ra,0x0
 16a:	186080e7          	jalr	390(ra) # 2ec <open>
  if(fd < 0)
 16e:	02054563          	bltz	a0,198 <stat+0x42>
 172:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 174:	85ca                	mv	a1,s2
 176:	00000097          	auipc	ra,0x0
 17a:	18e080e7          	jalr	398(ra) # 304 <fstat>
 17e:	892a                	mv	s2,a0
  close(fd);
 180:	8526                	mv	a0,s1
 182:	00000097          	auipc	ra,0x0
 186:	152080e7          	jalr	338(ra) # 2d4 <close>
  return r;
}
 18a:	854a                	mv	a0,s2
 18c:	60e2                	ld	ra,24(sp)
 18e:	6442                	ld	s0,16(sp)
 190:	64a2                	ld	s1,8(sp)
 192:	6902                	ld	s2,0(sp)
 194:	6105                	addi	sp,sp,32
 196:	8082                	ret
    return -1;
 198:	597d                	li	s2,-1
 19a:	bfc5                	j	18a <stat+0x34>

000000000000019c <atoi>:

int
atoi(const char *s)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a2:	00054683          	lbu	a3,0(a0)
 1a6:	fd06879b          	addiw	a5,a3,-48
 1aa:	0ff7f793          	zext.b	a5,a5
 1ae:	4625                	li	a2,9
 1b0:	02f66863          	bltu	a2,a5,1e0 <atoi+0x44>
 1b4:	872a                	mv	a4,a0
  n = 0;
 1b6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1b8:	0705                	addi	a4,a4,1
 1ba:	0025179b          	slliw	a5,a0,0x2
 1be:	9fa9                	addw	a5,a5,a0
 1c0:	0017979b          	slliw	a5,a5,0x1
 1c4:	9fb5                	addw	a5,a5,a3
 1c6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ca:	00074683          	lbu	a3,0(a4)
 1ce:	fd06879b          	addiw	a5,a3,-48
 1d2:	0ff7f793          	zext.b	a5,a5
 1d6:	fef671e3          	bgeu	a2,a5,1b8 <atoi+0x1c>
  return n;
}
 1da:	6422                	ld	s0,8(sp)
 1dc:	0141                	addi	sp,sp,16
 1de:	8082                	ret
  n = 0;
 1e0:	4501                	li	a0,0
 1e2:	bfe5                	j	1da <atoi+0x3e>

00000000000001e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e422                	sd	s0,8(sp)
 1e8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1ea:	02b57463          	bgeu	a0,a1,212 <memmove+0x2e>
    while(n-- > 0)
 1ee:	00c05f63          	blez	a2,20c <memmove+0x28>
 1f2:	1602                	slli	a2,a2,0x20
 1f4:	9201                	srli	a2,a2,0x20
 1f6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1fa:	872a                	mv	a4,a0
      *dst++ = *src++;
 1fc:	0585                	addi	a1,a1,1
 1fe:	0705                	addi	a4,a4,1
 200:	fff5c683          	lbu	a3,-1(a1)
 204:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 208:	fee79ae3          	bne	a5,a4,1fc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret
    dst += n;
 212:	00c50733          	add	a4,a0,a2
    src += n;
 216:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 218:	fec05ae3          	blez	a2,20c <memmove+0x28>
 21c:	fff6079b          	addiw	a5,a2,-1
 220:	1782                	slli	a5,a5,0x20
 222:	9381                	srli	a5,a5,0x20
 224:	fff7c793          	not	a5,a5
 228:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 22a:	15fd                	addi	a1,a1,-1
 22c:	177d                	addi	a4,a4,-1
 22e:	0005c683          	lbu	a3,0(a1)
 232:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 236:	fee79ae3          	bne	a5,a4,22a <memmove+0x46>
 23a:	bfc9                	j	20c <memmove+0x28>

000000000000023c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 242:	ca05                	beqz	a2,272 <memcmp+0x36>
 244:	fff6069b          	addiw	a3,a2,-1
 248:	1682                	slli	a3,a3,0x20
 24a:	9281                	srli	a3,a3,0x20
 24c:	0685                	addi	a3,a3,1
 24e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 250:	00054783          	lbu	a5,0(a0)
 254:	0005c703          	lbu	a4,0(a1)
 258:	00e79863          	bne	a5,a4,268 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 25c:	0505                	addi	a0,a0,1
    p2++;
 25e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 260:	fed518e3          	bne	a0,a3,250 <memcmp+0x14>
  }
  return 0;
 264:	4501                	li	a0,0
 266:	a019                	j	26c <memcmp+0x30>
      return *p1 - *p2;
 268:	40e7853b          	subw	a0,a5,a4
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  return 0;
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <memcmp+0x30>

0000000000000276 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 276:	1141                	addi	sp,sp,-16
 278:	e406                	sd	ra,8(sp)
 27a:	e022                	sd	s0,0(sp)
 27c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 27e:	00000097          	auipc	ra,0x0
 282:	f66080e7          	jalr	-154(ra) # 1e4 <memmove>
}
 286:	60a2                	ld	ra,8(sp)
 288:	6402                	ld	s0,0(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret

000000000000028e <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  struct usyscall* u = (struct usyscall *)USYSCALL;
  return u->pid;
 294:	040007b7          	lui	a5,0x4000
}
 298:	17f5                	addi	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffefb4>
 29a:	07b2                	slli	a5,a5,0xc
 29c:	4388                	lw	a0,0(a5)
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret

00000000000002a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a4:	4885                	li	a7,1
 ecall
 2a6:	00000073          	ecall
 ret
 2aa:	8082                	ret

00000000000002ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ac:	4889                	li	a7,2
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b4:	488d                	li	a7,3
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2bc:	4891                	li	a7,4
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <read>:
.global read
read:
 li a7, SYS_read
 2c4:	4895                	li	a7,5
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <write>:
.global write
write:
 li a7, SYS_write
 2cc:	48c1                	li	a7,16
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <close>:
.global close
close:
 li a7, SYS_close
 2d4:	48d5                	li	a7,21
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 2dc:	4899                	li	a7,6
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e4:	489d                	li	a7,7
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <open>:
.global open
open:
 li a7, SYS_open
 2ec:	48bd                	li	a7,15
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f4:	48c5                	li	a7,17
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2fc:	48c9                	li	a7,18
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 304:	48a1                	li	a7,8
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <link>:
.global link
link:
 li a7, SYS_link
 30c:	48cd                	li	a7,19
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 314:	48d1                	li	a7,20
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 31c:	48a5                	li	a7,9
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <dup>:
.global dup
dup:
 li a7, SYS_dup
 324:	48a9                	li	a7,10
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 32c:	48ad                	li	a7,11
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 334:	48b1                	li	a7,12
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 33c:	48b5                	li	a7,13
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 344:	48b9                	li	a7,14
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <connect>:
.global connect
connect:
 li a7, SYS_connect
 34c:	48f5                	li	a7,29
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 354:	48f9                	li	a7,30
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 35c:	1101                	addi	sp,sp,-32
 35e:	ec06                	sd	ra,24(sp)
 360:	e822                	sd	s0,16(sp)
 362:	1000                	addi	s0,sp,32
 364:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 368:	4605                	li	a2,1
 36a:	fef40593          	addi	a1,s0,-17
 36e:	00000097          	auipc	ra,0x0
 372:	f5e080e7          	jalr	-162(ra) # 2cc <write>
}
 376:	60e2                	ld	ra,24(sp)
 378:	6442                	ld	s0,16(sp)
 37a:	6105                	addi	sp,sp,32
 37c:	8082                	ret

000000000000037e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37e:	7139                	addi	sp,sp,-64
 380:	fc06                	sd	ra,56(sp)
 382:	f822                	sd	s0,48(sp)
 384:	f426                	sd	s1,40(sp)
 386:	f04a                	sd	s2,32(sp)
 388:	ec4e                	sd	s3,24(sp)
 38a:	0080                	addi	s0,sp,64
 38c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38e:	c299                	beqz	a3,394 <printint+0x16>
 390:	0805c963          	bltz	a1,422 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 394:	2581                	sext.w	a1,a1
  neg = 0;
 396:	4881                	li	a7,0
 398:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 39c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 39e:	2601                	sext.w	a2,a2
 3a0:	00000517          	auipc	a0,0x0
 3a4:	49850513          	addi	a0,a0,1176 # 838 <digits>
 3a8:	883a                	mv	a6,a4
 3aa:	2705                	addiw	a4,a4,1
 3ac:	02c5f7bb          	remuw	a5,a1,a2
 3b0:	1782                	slli	a5,a5,0x20
 3b2:	9381                	srli	a5,a5,0x20
 3b4:	97aa                	add	a5,a5,a0
 3b6:	0007c783          	lbu	a5,0(a5)
 3ba:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3be:	0005879b          	sext.w	a5,a1
 3c2:	02c5d5bb          	divuw	a1,a1,a2
 3c6:	0685                	addi	a3,a3,1
 3c8:	fec7f0e3          	bgeu	a5,a2,3a8 <printint+0x2a>
  if(neg)
 3cc:	00088c63          	beqz	a7,3e4 <printint+0x66>
    buf[i++] = '-';
 3d0:	fd070793          	addi	a5,a4,-48
 3d4:	00878733          	add	a4,a5,s0
 3d8:	02d00793          	li	a5,45
 3dc:	fef70823          	sb	a5,-16(a4)
 3e0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3e4:	02e05863          	blez	a4,414 <printint+0x96>
 3e8:	fc040793          	addi	a5,s0,-64
 3ec:	00e78933          	add	s2,a5,a4
 3f0:	fff78993          	addi	s3,a5,-1
 3f4:	99ba                	add	s3,s3,a4
 3f6:	377d                	addiw	a4,a4,-1
 3f8:	1702                	slli	a4,a4,0x20
 3fa:	9301                	srli	a4,a4,0x20
 3fc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 400:	fff94583          	lbu	a1,-1(s2)
 404:	8526                	mv	a0,s1
 406:	00000097          	auipc	ra,0x0
 40a:	f56080e7          	jalr	-170(ra) # 35c <putc>
  while(--i >= 0)
 40e:	197d                	addi	s2,s2,-1
 410:	ff3918e3          	bne	s2,s3,400 <printint+0x82>
}
 414:	70e2                	ld	ra,56(sp)
 416:	7442                	ld	s0,48(sp)
 418:	74a2                	ld	s1,40(sp)
 41a:	7902                	ld	s2,32(sp)
 41c:	69e2                	ld	s3,24(sp)
 41e:	6121                	addi	sp,sp,64
 420:	8082                	ret
    x = -xx;
 422:	40b005bb          	negw	a1,a1
    neg = 1;
 426:	4885                	li	a7,1
    x = -xx;
 428:	bf85                	j	398 <printint+0x1a>

000000000000042a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 42a:	7119                	addi	sp,sp,-128
 42c:	fc86                	sd	ra,120(sp)
 42e:	f8a2                	sd	s0,112(sp)
 430:	f4a6                	sd	s1,104(sp)
 432:	f0ca                	sd	s2,96(sp)
 434:	ecce                	sd	s3,88(sp)
 436:	e8d2                	sd	s4,80(sp)
 438:	e4d6                	sd	s5,72(sp)
 43a:	e0da                	sd	s6,64(sp)
 43c:	fc5e                	sd	s7,56(sp)
 43e:	f862                	sd	s8,48(sp)
 440:	f466                	sd	s9,40(sp)
 442:	f06a                	sd	s10,32(sp)
 444:	ec6e                	sd	s11,24(sp)
 446:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 448:	0005c903          	lbu	s2,0(a1)
 44c:	18090f63          	beqz	s2,5ea <vprintf+0x1c0>
 450:	8aaa                	mv	s5,a0
 452:	8b32                	mv	s6,a2
 454:	00158493          	addi	s1,a1,1
  state = 0;
 458:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 45a:	02500a13          	li	s4,37
 45e:	4c55                	li	s8,21
 460:	00000c97          	auipc	s9,0x0
 464:	380c8c93          	addi	s9,s9,896 # 7e0 <malloc+0xf2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 468:	02800d93          	li	s11,40
  putc(fd, 'x');
 46c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 46e:	00000b97          	auipc	s7,0x0
 472:	3cab8b93          	addi	s7,s7,970 # 838 <digits>
 476:	a839                	j	494 <vprintf+0x6a>
        putc(fd, c);
 478:	85ca                	mv	a1,s2
 47a:	8556                	mv	a0,s5
 47c:	00000097          	auipc	ra,0x0
 480:	ee0080e7          	jalr	-288(ra) # 35c <putc>
 484:	a019                	j	48a <vprintf+0x60>
    } else if(state == '%'){
 486:	01498d63          	beq	s3,s4,4a0 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 48a:	0485                	addi	s1,s1,1
 48c:	fff4c903          	lbu	s2,-1(s1)
 490:	14090d63          	beqz	s2,5ea <vprintf+0x1c0>
    if(state == 0){
 494:	fe0999e3          	bnez	s3,486 <vprintf+0x5c>
      if(c == '%'){
 498:	ff4910e3          	bne	s2,s4,478 <vprintf+0x4e>
        state = '%';
 49c:	89d2                	mv	s3,s4
 49e:	b7f5                	j	48a <vprintf+0x60>
      if(c == 'd'){
 4a0:	11490c63          	beq	s2,s4,5b8 <vprintf+0x18e>
 4a4:	f9d9079b          	addiw	a5,s2,-99
 4a8:	0ff7f793          	zext.b	a5,a5
 4ac:	10fc6e63          	bltu	s8,a5,5c8 <vprintf+0x19e>
 4b0:	f9d9079b          	addiw	a5,s2,-99
 4b4:	0ff7f713          	zext.b	a4,a5
 4b8:	10ec6863          	bltu	s8,a4,5c8 <vprintf+0x19e>
 4bc:	00271793          	slli	a5,a4,0x2
 4c0:	97e6                	add	a5,a5,s9
 4c2:	439c                	lw	a5,0(a5)
 4c4:	97e6                	add	a5,a5,s9
 4c6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4c8:	008b0913          	addi	s2,s6,8
 4cc:	4685                	li	a3,1
 4ce:	4629                	li	a2,10
 4d0:	000b2583          	lw	a1,0(s6)
 4d4:	8556                	mv	a0,s5
 4d6:	00000097          	auipc	ra,0x0
 4da:	ea8080e7          	jalr	-344(ra) # 37e <printint>
 4de:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e0:	4981                	li	s3,0
 4e2:	b765                	j	48a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4e4:	008b0913          	addi	s2,s6,8
 4e8:	4681                	li	a3,0
 4ea:	4629                	li	a2,10
 4ec:	000b2583          	lw	a1,0(s6)
 4f0:	8556                	mv	a0,s5
 4f2:	00000097          	auipc	ra,0x0
 4f6:	e8c080e7          	jalr	-372(ra) # 37e <printint>
 4fa:	8b4a                	mv	s6,s2
      state = 0;
 4fc:	4981                	li	s3,0
 4fe:	b771                	j	48a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 500:	008b0913          	addi	s2,s6,8
 504:	4681                	li	a3,0
 506:	866a                	mv	a2,s10
 508:	000b2583          	lw	a1,0(s6)
 50c:	8556                	mv	a0,s5
 50e:	00000097          	auipc	ra,0x0
 512:	e70080e7          	jalr	-400(ra) # 37e <printint>
 516:	8b4a                	mv	s6,s2
      state = 0;
 518:	4981                	li	s3,0
 51a:	bf85                	j	48a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 51c:	008b0793          	addi	a5,s6,8
 520:	f8f43423          	sd	a5,-120(s0)
 524:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 528:	03000593          	li	a1,48
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	e2e080e7          	jalr	-466(ra) # 35c <putc>
  putc(fd, 'x');
 536:	07800593          	li	a1,120
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	e20080e7          	jalr	-480(ra) # 35c <putc>
 544:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 546:	03c9d793          	srli	a5,s3,0x3c
 54a:	97de                	add	a5,a5,s7
 54c:	0007c583          	lbu	a1,0(a5)
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	e0a080e7          	jalr	-502(ra) # 35c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 55a:	0992                	slli	s3,s3,0x4
 55c:	397d                	addiw	s2,s2,-1
 55e:	fe0914e3          	bnez	s2,546 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 562:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 566:	4981                	li	s3,0
 568:	b70d                	j	48a <vprintf+0x60>
        s = va_arg(ap, char*);
 56a:	008b0913          	addi	s2,s6,8
 56e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 572:	02098163          	beqz	s3,594 <vprintf+0x16a>
        while(*s != 0){
 576:	0009c583          	lbu	a1,0(s3)
 57a:	c5ad                	beqz	a1,5e4 <vprintf+0x1ba>
          putc(fd, *s);
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	dde080e7          	jalr	-546(ra) # 35c <putc>
          s++;
 586:	0985                	addi	s3,s3,1
        while(*s != 0){
 588:	0009c583          	lbu	a1,0(s3)
 58c:	f9e5                	bnez	a1,57c <vprintf+0x152>
        s = va_arg(ap, char*);
 58e:	8b4a                	mv	s6,s2
      state = 0;
 590:	4981                	li	s3,0
 592:	bde5                	j	48a <vprintf+0x60>
          s = "(null)";
 594:	00000997          	auipc	s3,0x0
 598:	24498993          	addi	s3,s3,580 # 7d8 <malloc+0xea>
        while(*s != 0){
 59c:	85ee                	mv	a1,s11
 59e:	bff9                	j	57c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5a0:	008b0913          	addi	s2,s6,8
 5a4:	000b4583          	lbu	a1,0(s6)
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	db2080e7          	jalr	-590(ra) # 35c <putc>
 5b2:	8b4a                	mv	s6,s2
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	bdd1                	j	48a <vprintf+0x60>
        putc(fd, c);
 5b8:	85d2                	mv	a1,s4
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	da0080e7          	jalr	-608(ra) # 35c <putc>
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b5d1                	j	48a <vprintf+0x60>
        putc(fd, '%');
 5c8:	85d2                	mv	a1,s4
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	d90080e7          	jalr	-624(ra) # 35c <putc>
        putc(fd, c);
 5d4:	85ca                	mv	a1,s2
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	d84080e7          	jalr	-636(ra) # 35c <putc>
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b565                	j	48a <vprintf+0x60>
        s = va_arg(ap, char*);
 5e4:	8b4a                	mv	s6,s2
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	b54d                	j	48a <vprintf+0x60>
    }
  }
}
 5ea:	70e6                	ld	ra,120(sp)
 5ec:	7446                	ld	s0,112(sp)
 5ee:	74a6                	ld	s1,104(sp)
 5f0:	7906                	ld	s2,96(sp)
 5f2:	69e6                	ld	s3,88(sp)
 5f4:	6a46                	ld	s4,80(sp)
 5f6:	6aa6                	ld	s5,72(sp)
 5f8:	6b06                	ld	s6,64(sp)
 5fa:	7be2                	ld	s7,56(sp)
 5fc:	7c42                	ld	s8,48(sp)
 5fe:	7ca2                	ld	s9,40(sp)
 600:	7d02                	ld	s10,32(sp)
 602:	6de2                	ld	s11,24(sp)
 604:	6109                	addi	sp,sp,128
 606:	8082                	ret

0000000000000608 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 608:	715d                	addi	sp,sp,-80
 60a:	ec06                	sd	ra,24(sp)
 60c:	e822                	sd	s0,16(sp)
 60e:	1000                	addi	s0,sp,32
 610:	e010                	sd	a2,0(s0)
 612:	e414                	sd	a3,8(s0)
 614:	e818                	sd	a4,16(s0)
 616:	ec1c                	sd	a5,24(s0)
 618:	03043023          	sd	a6,32(s0)
 61c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 620:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 624:	8622                	mv	a2,s0
 626:	00000097          	auipc	ra,0x0
 62a:	e04080e7          	jalr	-508(ra) # 42a <vprintf>
}
 62e:	60e2                	ld	ra,24(sp)
 630:	6442                	ld	s0,16(sp)
 632:	6161                	addi	sp,sp,80
 634:	8082                	ret

0000000000000636 <printf>:

void
printf(const char *fmt, ...)
{
 636:	711d                	addi	sp,sp,-96
 638:	ec06                	sd	ra,24(sp)
 63a:	e822                	sd	s0,16(sp)
 63c:	1000                	addi	s0,sp,32
 63e:	e40c                	sd	a1,8(s0)
 640:	e810                	sd	a2,16(s0)
 642:	ec14                	sd	a3,24(s0)
 644:	f018                	sd	a4,32(s0)
 646:	f41c                	sd	a5,40(s0)
 648:	03043823          	sd	a6,48(s0)
 64c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 650:	00840613          	addi	a2,s0,8
 654:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 658:	85aa                	mv	a1,a0
 65a:	4505                	li	a0,1
 65c:	00000097          	auipc	ra,0x0
 660:	dce080e7          	jalr	-562(ra) # 42a <vprintf>
}
 664:	60e2                	ld	ra,24(sp)
 666:	6442                	ld	s0,16(sp)
 668:	6125                	addi	sp,sp,96
 66a:	8082                	ret

000000000000066c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 66c:	1141                	addi	sp,sp,-16
 66e:	e422                	sd	s0,8(sp)
 670:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 672:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 676:	00000797          	auipc	a5,0x0
 67a:	1da7b783          	ld	a5,474(a5) # 850 <freep>
 67e:	a02d                	j	6a8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 680:	4618                	lw	a4,8(a2)
 682:	9f2d                	addw	a4,a4,a1
 684:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 688:	6398                	ld	a4,0(a5)
 68a:	6310                	ld	a2,0(a4)
 68c:	a83d                	j	6ca <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 68e:	ff852703          	lw	a4,-8(a0)
 692:	9f31                	addw	a4,a4,a2
 694:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 696:	ff053683          	ld	a3,-16(a0)
 69a:	a091                	j	6de <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69c:	6398                	ld	a4,0(a5)
 69e:	00e7e463          	bltu	a5,a4,6a6 <free+0x3a>
 6a2:	00e6ea63          	bltu	a3,a4,6b6 <free+0x4a>
{
 6a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a8:	fed7fae3          	bgeu	a5,a3,69c <free+0x30>
 6ac:	6398                	ld	a4,0(a5)
 6ae:	00e6e463          	bltu	a3,a4,6b6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b2:	fee7eae3          	bltu	a5,a4,6a6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6b6:	ff852583          	lw	a1,-8(a0)
 6ba:	6390                	ld	a2,0(a5)
 6bc:	02059813          	slli	a6,a1,0x20
 6c0:	01c85713          	srli	a4,a6,0x1c
 6c4:	9736                	add	a4,a4,a3
 6c6:	fae60de3          	beq	a2,a4,680 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6ce:	4790                	lw	a2,8(a5)
 6d0:	02061593          	slli	a1,a2,0x20
 6d4:	01c5d713          	srli	a4,a1,0x1c
 6d8:	973e                	add	a4,a4,a5
 6da:	fae68ae3          	beq	a3,a4,68e <free+0x22>
    p->s.ptr = bp->s.ptr;
 6de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6e0:	00000717          	auipc	a4,0x0
 6e4:	16f73823          	sd	a5,368(a4) # 850 <freep>
}
 6e8:	6422                	ld	s0,8(sp)
 6ea:	0141                	addi	sp,sp,16
 6ec:	8082                	ret

00000000000006ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6ee:	7139                	addi	sp,sp,-64
 6f0:	fc06                	sd	ra,56(sp)
 6f2:	f822                	sd	s0,48(sp)
 6f4:	f426                	sd	s1,40(sp)
 6f6:	f04a                	sd	s2,32(sp)
 6f8:	ec4e                	sd	s3,24(sp)
 6fa:	e852                	sd	s4,16(sp)
 6fc:	e456                	sd	s5,8(sp)
 6fe:	e05a                	sd	s6,0(sp)
 700:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 702:	02051493          	slli	s1,a0,0x20
 706:	9081                	srli	s1,s1,0x20
 708:	04bd                	addi	s1,s1,15
 70a:	8091                	srli	s1,s1,0x4
 70c:	0014899b          	addiw	s3,s1,1
 710:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 712:	00000517          	auipc	a0,0x0
 716:	13e53503          	ld	a0,318(a0) # 850 <freep>
 71a:	c515                	beqz	a0,746 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 71c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 71e:	4798                	lw	a4,8(a5)
 720:	02977f63          	bgeu	a4,s1,75e <malloc+0x70>
 724:	8a4e                	mv	s4,s3
 726:	0009871b          	sext.w	a4,s3
 72a:	6685                	lui	a3,0x1
 72c:	00d77363          	bgeu	a4,a3,732 <malloc+0x44>
 730:	6a05                	lui	s4,0x1
 732:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 736:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 73a:	00000917          	auipc	s2,0x0
 73e:	11690913          	addi	s2,s2,278 # 850 <freep>
  if(p == (char*)-1)
 742:	5afd                	li	s5,-1
 744:	a895                	j	7b8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 746:	00000797          	auipc	a5,0x0
 74a:	11278793          	addi	a5,a5,274 # 858 <base>
 74e:	00000717          	auipc	a4,0x0
 752:	10f73123          	sd	a5,258(a4) # 850 <freep>
 756:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 758:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 75c:	b7e1                	j	724 <malloc+0x36>
      if(p->s.size == nunits)
 75e:	02e48c63          	beq	s1,a4,796 <malloc+0xa8>
        p->s.size -= nunits;
 762:	4137073b          	subw	a4,a4,s3
 766:	c798                	sw	a4,8(a5)
        p += p->s.size;
 768:	02071693          	slli	a3,a4,0x20
 76c:	01c6d713          	srli	a4,a3,0x1c
 770:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 772:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 776:	00000717          	auipc	a4,0x0
 77a:	0ca73d23          	sd	a0,218(a4) # 850 <freep>
      return (void*)(p + 1);
 77e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 782:	70e2                	ld	ra,56(sp)
 784:	7442                	ld	s0,48(sp)
 786:	74a2                	ld	s1,40(sp)
 788:	7902                	ld	s2,32(sp)
 78a:	69e2                	ld	s3,24(sp)
 78c:	6a42                	ld	s4,16(sp)
 78e:	6aa2                	ld	s5,8(sp)
 790:	6b02                	ld	s6,0(sp)
 792:	6121                	addi	sp,sp,64
 794:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 796:	6398                	ld	a4,0(a5)
 798:	e118                	sd	a4,0(a0)
 79a:	bff1                	j	776 <malloc+0x88>
  hp->s.size = nu;
 79c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7a0:	0541                	addi	a0,a0,16
 7a2:	00000097          	auipc	ra,0x0
 7a6:	eca080e7          	jalr	-310(ra) # 66c <free>
  return freep;
 7aa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7ae:	d971                	beqz	a0,782 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b2:	4798                	lw	a4,8(a5)
 7b4:	fa9775e3          	bgeu	a4,s1,75e <malloc+0x70>
    if(p == freep)
 7b8:	00093703          	ld	a4,0(s2)
 7bc:	853e                	mv	a0,a5
 7be:	fef719e3          	bne	a4,a5,7b0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7c2:	8552                	mv	a0,s4
 7c4:	00000097          	auipc	ra,0x0
 7c8:	b70080e7          	jalr	-1168(ra) # 334 <sbrk>
  if(p == (char*)-1)
 7cc:	fd5518e3          	bne	a0,s5,79c <malloc+0xae>
        return 0;
 7d0:	4501                	li	a0,0
 7d2:	bf45                	j	782 <malloc+0x94>
