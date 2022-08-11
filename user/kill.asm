
user/_kill：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7dd63          	bge	a5,a0,48 <main+0x48>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1ae080e7          	jalr	430(ra) # 1d6 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	2e6080e7          	jalr	742(ra) # 316 <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2a6080e7          	jalr	678(ra) # 2e6 <exit>
    fprintf(2, "usage: kill pid...\n");
  48:	00000597          	auipc	a1,0x0
  4c:	7c858593          	addi	a1,a1,1992 # 810 <malloc+0xe8>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	5f0080e7          	jalr	1520(ra) # 642 <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	28a080e7          	jalr	650(ra) # 2e6 <exit>

0000000000000064 <strcpy>:



char*
strcpy(char *s, const char *t)
{
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6a:	87aa                	mv	a5,a0
  6c:	0585                	addi	a1,a1,1
  6e:	0785                	addi	a5,a5,1
  70:	fff5c703          	lbu	a4,-1(a1)
  74:	fee78fa3          	sb	a4,-1(a5)
  78:	fb75                	bnez	a4,6c <strcpy+0x8>
    ;
  return os;
}
  7a:	6422                	ld	s0,8(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	1141                	addi	sp,sp,-16
  82:	e422                	sd	s0,8(sp)
  84:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x1e>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x1e>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	6422                	ld	s0,8(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strlen>:

uint
strlen(const char *s)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e422                	sd	s0,8(sp)
  b0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	cf91                	beqz	a5,d2 <strlen+0x26>
  b8:	0505                	addi	a0,a0,1
  ba:	87aa                	mv	a5,a0
  bc:	4685                	li	a3,1
  be:	9e89                	subw	a3,a3,a0
  c0:	00f6853b          	addw	a0,a3,a5
  c4:	0785                	addi	a5,a5,1
  c6:	fff7c703          	lbu	a4,-1(a5)
  ca:	fb7d                	bnez	a4,c0 <strlen+0x14>
    ;
  return n;
}
  cc:	6422                	ld	s0,8(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret
  for(n = 0; s[n]; n++)
  d2:	4501                	li	a0,0
  d4:	bfe5                	j	cc <strlen+0x20>

00000000000000d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  dc:	ca19                	beqz	a2,f2 <memset+0x1c>
  de:	87aa                	mv	a5,a0
  e0:	1602                	slli	a2,a2,0x20
  e2:	9201                	srli	a2,a2,0x20
  e4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ec:	0785                	addi	a5,a5,1
  ee:	fee79de3          	bne	a5,a4,e8 <memset+0x12>
  }
  return dst;
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret

00000000000000f8 <strchr>:

char*
strchr(const char *s, char c)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  fe:	00054783          	lbu	a5,0(a0)
 102:	cb99                	beqz	a5,118 <strchr+0x20>
    if(*s == c)
 104:	00f58763          	beq	a1,a5,112 <strchr+0x1a>
  for(; *s; s++)
 108:	0505                	addi	a0,a0,1
 10a:	00054783          	lbu	a5,0(a0)
 10e:	fbfd                	bnez	a5,104 <strchr+0xc>
      return (char*)s;
  return 0;
 110:	4501                	li	a0,0
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret
  return 0;
 118:	4501                	li	a0,0
 11a:	bfe5                	j	112 <strchr+0x1a>

000000000000011c <gets>:

char*
gets(char *buf, int max)
{
 11c:	711d                	addi	sp,sp,-96
 11e:	ec86                	sd	ra,88(sp)
 120:	e8a2                	sd	s0,80(sp)
 122:	e4a6                	sd	s1,72(sp)
 124:	e0ca                	sd	s2,64(sp)
 126:	fc4e                	sd	s3,56(sp)
 128:	f852                	sd	s4,48(sp)
 12a:	f456                	sd	s5,40(sp)
 12c:	f05a                	sd	s6,32(sp)
 12e:	ec5e                	sd	s7,24(sp)
 130:	1080                	addi	s0,sp,96
 132:	8baa                	mv	s7,a0
 134:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 136:	892a                	mv	s2,a0
 138:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13a:	4aa9                	li	s5,10
 13c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13e:	89a6                	mv	s3,s1
 140:	2485                	addiw	s1,s1,1
 142:	0344d863          	bge	s1,s4,172 <gets+0x56>
    cc = read(0, &c, 1);
 146:	4605                	li	a2,1
 148:	faf40593          	addi	a1,s0,-81
 14c:	4501                	li	a0,0
 14e:	00000097          	auipc	ra,0x0
 152:	1b0080e7          	jalr	432(ra) # 2fe <read>
    if(cc < 1)
 156:	00a05e63          	blez	a0,172 <gets+0x56>
    buf[i++] = c;
 15a:	faf44783          	lbu	a5,-81(s0)
 15e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 162:	01578763          	beq	a5,s5,170 <gets+0x54>
 166:	0905                	addi	s2,s2,1
 168:	fd679be3          	bne	a5,s6,13e <gets+0x22>
  for(i=0; i+1 < max; ){
 16c:	89a6                	mv	s3,s1
 16e:	a011                	j	172 <gets+0x56>
 170:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 172:	99de                	add	s3,s3,s7
 174:	00098023          	sb	zero,0(s3)
  return buf;
}
 178:	855e                	mv	a0,s7
 17a:	60e6                	ld	ra,88(sp)
 17c:	6446                	ld	s0,80(sp)
 17e:	64a6                	ld	s1,72(sp)
 180:	6906                	ld	s2,64(sp)
 182:	79e2                	ld	s3,56(sp)
 184:	7a42                	ld	s4,48(sp)
 186:	7aa2                	ld	s5,40(sp)
 188:	7b02                	ld	s6,32(sp)
 18a:	6be2                	ld	s7,24(sp)
 18c:	6125                	addi	sp,sp,96
 18e:	8082                	ret

0000000000000190 <stat>:

int
stat(const char *n, struct stat *st)
{
 190:	1101                	addi	sp,sp,-32
 192:	ec06                	sd	ra,24(sp)
 194:	e822                	sd	s0,16(sp)
 196:	e426                	sd	s1,8(sp)
 198:	e04a                	sd	s2,0(sp)
 19a:	1000                	addi	s0,sp,32
 19c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19e:	4581                	li	a1,0
 1a0:	00000097          	auipc	ra,0x0
 1a4:	186080e7          	jalr	390(ra) # 326 <open>
  if(fd < 0)
 1a8:	02054563          	bltz	a0,1d2 <stat+0x42>
 1ac:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ae:	85ca                	mv	a1,s2
 1b0:	00000097          	auipc	ra,0x0
 1b4:	18e080e7          	jalr	398(ra) # 33e <fstat>
 1b8:	892a                	mv	s2,a0
  close(fd);
 1ba:	8526                	mv	a0,s1
 1bc:	00000097          	auipc	ra,0x0
 1c0:	152080e7          	jalr	338(ra) # 30e <close>
  return r;
}
 1c4:	854a                	mv	a0,s2
 1c6:	60e2                	ld	ra,24(sp)
 1c8:	6442                	ld	s0,16(sp)
 1ca:	64a2                	ld	s1,8(sp)
 1cc:	6902                	ld	s2,0(sp)
 1ce:	6105                	addi	sp,sp,32
 1d0:	8082                	ret
    return -1;
 1d2:	597d                	li	s2,-1
 1d4:	bfc5                	j	1c4 <stat+0x34>

00000000000001d6 <atoi>:

int
atoi(const char *s)
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1dc:	00054683          	lbu	a3,0(a0)
 1e0:	fd06879b          	addiw	a5,a3,-48
 1e4:	0ff7f793          	zext.b	a5,a5
 1e8:	4625                	li	a2,9
 1ea:	02f66863          	bltu	a2,a5,21a <atoi+0x44>
 1ee:	872a                	mv	a4,a0
  n = 0;
 1f0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f2:	0705                	addi	a4,a4,1
 1f4:	0025179b          	slliw	a5,a0,0x2
 1f8:	9fa9                	addw	a5,a5,a0
 1fa:	0017979b          	slliw	a5,a5,0x1
 1fe:	9fb5                	addw	a5,a5,a3
 200:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 204:	00074683          	lbu	a3,0(a4)
 208:	fd06879b          	addiw	a5,a3,-48
 20c:	0ff7f793          	zext.b	a5,a5
 210:	fef671e3          	bgeu	a2,a5,1f2 <atoi+0x1c>
  return n;
}
 214:	6422                	ld	s0,8(sp)
 216:	0141                	addi	sp,sp,16
 218:	8082                	ret
  n = 0;
 21a:	4501                	li	a0,0
 21c:	bfe5                	j	214 <atoi+0x3e>

000000000000021e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 224:	02b57463          	bgeu	a0,a1,24c <memmove+0x2e>
    while(n-- > 0)
 228:	00c05f63          	blez	a2,246 <memmove+0x28>
 22c:	1602                	slli	a2,a2,0x20
 22e:	9201                	srli	a2,a2,0x20
 230:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 234:	872a                	mv	a4,a0
      *dst++ = *src++;
 236:	0585                	addi	a1,a1,1
 238:	0705                	addi	a4,a4,1
 23a:	fff5c683          	lbu	a3,-1(a1)
 23e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 242:	fee79ae3          	bne	a5,a4,236 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 246:	6422                	ld	s0,8(sp)
 248:	0141                	addi	sp,sp,16
 24a:	8082                	ret
    dst += n;
 24c:	00c50733          	add	a4,a0,a2
    src += n;
 250:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 252:	fec05ae3          	blez	a2,246 <memmove+0x28>
 256:	fff6079b          	addiw	a5,a2,-1
 25a:	1782                	slli	a5,a5,0x20
 25c:	9381                	srli	a5,a5,0x20
 25e:	fff7c793          	not	a5,a5
 262:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 264:	15fd                	addi	a1,a1,-1
 266:	177d                	addi	a4,a4,-1
 268:	0005c683          	lbu	a3,0(a1)
 26c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 270:	fee79ae3          	bne	a5,a4,264 <memmove+0x46>
 274:	bfc9                	j	246 <memmove+0x28>

0000000000000276 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 276:	1141                	addi	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 27c:	ca05                	beqz	a2,2ac <memcmp+0x36>
 27e:	fff6069b          	addiw	a3,a2,-1
 282:	1682                	slli	a3,a3,0x20
 284:	9281                	srli	a3,a3,0x20
 286:	0685                	addi	a3,a3,1
 288:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 28a:	00054783          	lbu	a5,0(a0)
 28e:	0005c703          	lbu	a4,0(a1)
 292:	00e79863          	bne	a5,a4,2a2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 296:	0505                	addi	a0,a0,1
    p2++;
 298:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 29a:	fed518e3          	bne	a0,a3,28a <memcmp+0x14>
  }
  return 0;
 29e:	4501                	li	a0,0
 2a0:	a019                	j	2a6 <memcmp+0x30>
      return *p1 - *p2;
 2a2:	40e7853b          	subw	a0,a5,a4
}
 2a6:	6422                	ld	s0,8(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret
  return 0;
 2ac:	4501                	li	a0,0
 2ae:	bfe5                	j	2a6 <memcmp+0x30>

00000000000002b0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2b8:	00000097          	auipc	ra,0x0
 2bc:	f66080e7          	jalr	-154(ra) # 21e <memmove>
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret

00000000000002c8 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
  struct usyscall* u = (struct usyscall *)USYSCALL;
  return u->pid;
 2ce:	040007b7          	lui	a5,0x4000
}
 2d2:	17f5                	addi	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffef64>
 2d4:	07b2                	slli	a5,a5,0xc
 2d6:	4388                	lw	a0,0(a5)
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2de:	4885                	li	a7,1
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e6:	4889                	li	a7,2
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ee:	488d                	li	a7,3
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f6:	4891                	li	a7,4
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <read>:
.global read
read:
 li a7, SYS_read
 2fe:	4895                	li	a7,5
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <write>:
.global write
write:
 li a7, SYS_write
 306:	48c1                	li	a7,16
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <close>:
.global close
close:
 li a7, SYS_close
 30e:	48d5                	li	a7,21
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <kill>:
.global kill
kill:
 li a7, SYS_kill
 316:	4899                	li	a7,6
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <exec>:
.global exec
exec:
 li a7, SYS_exec
 31e:	489d                	li	a7,7
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <open>:
.global open
open:
 li a7, SYS_open
 326:	48bd                	li	a7,15
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 32e:	48c5                	li	a7,17
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 336:	48c9                	li	a7,18
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 33e:	48a1                	li	a7,8
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <link>:
.global link
link:
 li a7, SYS_link
 346:	48cd                	li	a7,19
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 34e:	48d1                	li	a7,20
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 356:	48a5                	li	a7,9
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <dup>:
.global dup
dup:
 li a7, SYS_dup
 35e:	48a9                	li	a7,10
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 366:	48ad                	li	a7,11
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 36e:	48b1                	li	a7,12
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 376:	48b5                	li	a7,13
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 37e:	48b9                	li	a7,14
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <connect>:
.global connect
connect:
 li a7, SYS_connect
 386:	48f5                	li	a7,29
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 38e:	48f9                	li	a7,30
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 396:	1101                	addi	sp,sp,-32
 398:	ec06                	sd	ra,24(sp)
 39a:	e822                	sd	s0,16(sp)
 39c:	1000                	addi	s0,sp,32
 39e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a2:	4605                	li	a2,1
 3a4:	fef40593          	addi	a1,s0,-17
 3a8:	00000097          	auipc	ra,0x0
 3ac:	f5e080e7          	jalr	-162(ra) # 306 <write>
}
 3b0:	60e2                	ld	ra,24(sp)
 3b2:	6442                	ld	s0,16(sp)
 3b4:	6105                	addi	sp,sp,32
 3b6:	8082                	ret

00000000000003b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b8:	7139                	addi	sp,sp,-64
 3ba:	fc06                	sd	ra,56(sp)
 3bc:	f822                	sd	s0,48(sp)
 3be:	f426                	sd	s1,40(sp)
 3c0:	f04a                	sd	s2,32(sp)
 3c2:	ec4e                	sd	s3,24(sp)
 3c4:	0080                	addi	s0,sp,64
 3c6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c8:	c299                	beqz	a3,3ce <printint+0x16>
 3ca:	0805c963          	bltz	a1,45c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ce:	2581                	sext.w	a1,a1
  neg = 0;
 3d0:	4881                	li	a7,0
 3d2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3d6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d8:	2601                	sext.w	a2,a2
 3da:	00000517          	auipc	a0,0x0
 3de:	4ae50513          	addi	a0,a0,1198 # 888 <digits>
 3e2:	883a                	mv	a6,a4
 3e4:	2705                	addiw	a4,a4,1
 3e6:	02c5f7bb          	remuw	a5,a1,a2
 3ea:	1782                	slli	a5,a5,0x20
 3ec:	9381                	srli	a5,a5,0x20
 3ee:	97aa                	add	a5,a5,a0
 3f0:	0007c783          	lbu	a5,0(a5)
 3f4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f8:	0005879b          	sext.w	a5,a1
 3fc:	02c5d5bb          	divuw	a1,a1,a2
 400:	0685                	addi	a3,a3,1
 402:	fec7f0e3          	bgeu	a5,a2,3e2 <printint+0x2a>
  if(neg)
 406:	00088c63          	beqz	a7,41e <printint+0x66>
    buf[i++] = '-';
 40a:	fd070793          	addi	a5,a4,-48
 40e:	00878733          	add	a4,a5,s0
 412:	02d00793          	li	a5,45
 416:	fef70823          	sb	a5,-16(a4)
 41a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 41e:	02e05863          	blez	a4,44e <printint+0x96>
 422:	fc040793          	addi	a5,s0,-64
 426:	00e78933          	add	s2,a5,a4
 42a:	fff78993          	addi	s3,a5,-1
 42e:	99ba                	add	s3,s3,a4
 430:	377d                	addiw	a4,a4,-1
 432:	1702                	slli	a4,a4,0x20
 434:	9301                	srli	a4,a4,0x20
 436:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 43a:	fff94583          	lbu	a1,-1(s2)
 43e:	8526                	mv	a0,s1
 440:	00000097          	auipc	ra,0x0
 444:	f56080e7          	jalr	-170(ra) # 396 <putc>
  while(--i >= 0)
 448:	197d                	addi	s2,s2,-1
 44a:	ff3918e3          	bne	s2,s3,43a <printint+0x82>
}
 44e:	70e2                	ld	ra,56(sp)
 450:	7442                	ld	s0,48(sp)
 452:	74a2                	ld	s1,40(sp)
 454:	7902                	ld	s2,32(sp)
 456:	69e2                	ld	s3,24(sp)
 458:	6121                	addi	sp,sp,64
 45a:	8082                	ret
    x = -xx;
 45c:	40b005bb          	negw	a1,a1
    neg = 1;
 460:	4885                	li	a7,1
    x = -xx;
 462:	bf85                	j	3d2 <printint+0x1a>

0000000000000464 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 464:	7119                	addi	sp,sp,-128
 466:	fc86                	sd	ra,120(sp)
 468:	f8a2                	sd	s0,112(sp)
 46a:	f4a6                	sd	s1,104(sp)
 46c:	f0ca                	sd	s2,96(sp)
 46e:	ecce                	sd	s3,88(sp)
 470:	e8d2                	sd	s4,80(sp)
 472:	e4d6                	sd	s5,72(sp)
 474:	e0da                	sd	s6,64(sp)
 476:	fc5e                	sd	s7,56(sp)
 478:	f862                	sd	s8,48(sp)
 47a:	f466                	sd	s9,40(sp)
 47c:	f06a                	sd	s10,32(sp)
 47e:	ec6e                	sd	s11,24(sp)
 480:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 482:	0005c903          	lbu	s2,0(a1)
 486:	18090f63          	beqz	s2,624 <vprintf+0x1c0>
 48a:	8aaa                	mv	s5,a0
 48c:	8b32                	mv	s6,a2
 48e:	00158493          	addi	s1,a1,1
  state = 0;
 492:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 494:	02500a13          	li	s4,37
 498:	4c55                	li	s8,21
 49a:	00000c97          	auipc	s9,0x0
 49e:	396c8c93          	addi	s9,s9,918 # 830 <malloc+0x108>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4a2:	02800d93          	li	s11,40
  putc(fd, 'x');
 4a6:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4a8:	00000b97          	auipc	s7,0x0
 4ac:	3e0b8b93          	addi	s7,s7,992 # 888 <digits>
 4b0:	a839                	j	4ce <vprintf+0x6a>
        putc(fd, c);
 4b2:	85ca                	mv	a1,s2
 4b4:	8556                	mv	a0,s5
 4b6:	00000097          	auipc	ra,0x0
 4ba:	ee0080e7          	jalr	-288(ra) # 396 <putc>
 4be:	a019                	j	4c4 <vprintf+0x60>
    } else if(state == '%'){
 4c0:	01498d63          	beq	s3,s4,4da <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4c4:	0485                	addi	s1,s1,1
 4c6:	fff4c903          	lbu	s2,-1(s1)
 4ca:	14090d63          	beqz	s2,624 <vprintf+0x1c0>
    if(state == 0){
 4ce:	fe0999e3          	bnez	s3,4c0 <vprintf+0x5c>
      if(c == '%'){
 4d2:	ff4910e3          	bne	s2,s4,4b2 <vprintf+0x4e>
        state = '%';
 4d6:	89d2                	mv	s3,s4
 4d8:	b7f5                	j	4c4 <vprintf+0x60>
      if(c == 'd'){
 4da:	11490c63          	beq	s2,s4,5f2 <vprintf+0x18e>
 4de:	f9d9079b          	addiw	a5,s2,-99
 4e2:	0ff7f793          	zext.b	a5,a5
 4e6:	10fc6e63          	bltu	s8,a5,602 <vprintf+0x19e>
 4ea:	f9d9079b          	addiw	a5,s2,-99
 4ee:	0ff7f713          	zext.b	a4,a5
 4f2:	10ec6863          	bltu	s8,a4,602 <vprintf+0x19e>
 4f6:	00271793          	slli	a5,a4,0x2
 4fa:	97e6                	add	a5,a5,s9
 4fc:	439c                	lw	a5,0(a5)
 4fe:	97e6                	add	a5,a5,s9
 500:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 502:	008b0913          	addi	s2,s6,8
 506:	4685                	li	a3,1
 508:	4629                	li	a2,10
 50a:	000b2583          	lw	a1,0(s6)
 50e:	8556                	mv	a0,s5
 510:	00000097          	auipc	ra,0x0
 514:	ea8080e7          	jalr	-344(ra) # 3b8 <printint>
 518:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 51a:	4981                	li	s3,0
 51c:	b765                	j	4c4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 51e:	008b0913          	addi	s2,s6,8
 522:	4681                	li	a3,0
 524:	4629                	li	a2,10
 526:	000b2583          	lw	a1,0(s6)
 52a:	8556                	mv	a0,s5
 52c:	00000097          	auipc	ra,0x0
 530:	e8c080e7          	jalr	-372(ra) # 3b8 <printint>
 534:	8b4a                	mv	s6,s2
      state = 0;
 536:	4981                	li	s3,0
 538:	b771                	j	4c4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 53a:	008b0913          	addi	s2,s6,8
 53e:	4681                	li	a3,0
 540:	866a                	mv	a2,s10
 542:	000b2583          	lw	a1,0(s6)
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	e70080e7          	jalr	-400(ra) # 3b8 <printint>
 550:	8b4a                	mv	s6,s2
      state = 0;
 552:	4981                	li	s3,0
 554:	bf85                	j	4c4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 556:	008b0793          	addi	a5,s6,8
 55a:	f8f43423          	sd	a5,-120(s0)
 55e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 562:	03000593          	li	a1,48
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	e2e080e7          	jalr	-466(ra) # 396 <putc>
  putc(fd, 'x');
 570:	07800593          	li	a1,120
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	e20080e7          	jalr	-480(ra) # 396 <putc>
 57e:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 580:	03c9d793          	srli	a5,s3,0x3c
 584:	97de                	add	a5,a5,s7
 586:	0007c583          	lbu	a1,0(a5)
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	e0a080e7          	jalr	-502(ra) # 396 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 594:	0992                	slli	s3,s3,0x4
 596:	397d                	addiw	s2,s2,-1
 598:	fe0914e3          	bnez	s2,580 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 59c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	b70d                	j	4c4 <vprintf+0x60>
        s = va_arg(ap, char*);
 5a4:	008b0913          	addi	s2,s6,8
 5a8:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5ac:	02098163          	beqz	s3,5ce <vprintf+0x16a>
        while(*s != 0){
 5b0:	0009c583          	lbu	a1,0(s3)
 5b4:	c5ad                	beqz	a1,61e <vprintf+0x1ba>
          putc(fd, *s);
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	dde080e7          	jalr	-546(ra) # 396 <putc>
          s++;
 5c0:	0985                	addi	s3,s3,1
        while(*s != 0){
 5c2:	0009c583          	lbu	a1,0(s3)
 5c6:	f9e5                	bnez	a1,5b6 <vprintf+0x152>
        s = va_arg(ap, char*);
 5c8:	8b4a                	mv	s6,s2
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	bde5                	j	4c4 <vprintf+0x60>
          s = "(null)";
 5ce:	00000997          	auipc	s3,0x0
 5d2:	25a98993          	addi	s3,s3,602 # 828 <malloc+0x100>
        while(*s != 0){
 5d6:	85ee                	mv	a1,s11
 5d8:	bff9                	j	5b6 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5da:	008b0913          	addi	s2,s6,8
 5de:	000b4583          	lbu	a1,0(s6)
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	db2080e7          	jalr	-590(ra) # 396 <putc>
 5ec:	8b4a                	mv	s6,s2
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bdd1                	j	4c4 <vprintf+0x60>
        putc(fd, c);
 5f2:	85d2                	mv	a1,s4
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	da0080e7          	jalr	-608(ra) # 396 <putc>
      state = 0;
 5fe:	4981                	li	s3,0
 600:	b5d1                	j	4c4 <vprintf+0x60>
        putc(fd, '%');
 602:	85d2                	mv	a1,s4
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	d90080e7          	jalr	-624(ra) # 396 <putc>
        putc(fd, c);
 60e:	85ca                	mv	a1,s2
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	d84080e7          	jalr	-636(ra) # 396 <putc>
      state = 0;
 61a:	4981                	li	s3,0
 61c:	b565                	j	4c4 <vprintf+0x60>
        s = va_arg(ap, char*);
 61e:	8b4a                	mv	s6,s2
      state = 0;
 620:	4981                	li	s3,0
 622:	b54d                	j	4c4 <vprintf+0x60>
    }
  }
}
 624:	70e6                	ld	ra,120(sp)
 626:	7446                	ld	s0,112(sp)
 628:	74a6                	ld	s1,104(sp)
 62a:	7906                	ld	s2,96(sp)
 62c:	69e6                	ld	s3,88(sp)
 62e:	6a46                	ld	s4,80(sp)
 630:	6aa6                	ld	s5,72(sp)
 632:	6b06                	ld	s6,64(sp)
 634:	7be2                	ld	s7,56(sp)
 636:	7c42                	ld	s8,48(sp)
 638:	7ca2                	ld	s9,40(sp)
 63a:	7d02                	ld	s10,32(sp)
 63c:	6de2                	ld	s11,24(sp)
 63e:	6109                	addi	sp,sp,128
 640:	8082                	ret

0000000000000642 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 642:	715d                	addi	sp,sp,-80
 644:	ec06                	sd	ra,24(sp)
 646:	e822                	sd	s0,16(sp)
 648:	1000                	addi	s0,sp,32
 64a:	e010                	sd	a2,0(s0)
 64c:	e414                	sd	a3,8(s0)
 64e:	e818                	sd	a4,16(s0)
 650:	ec1c                	sd	a5,24(s0)
 652:	03043023          	sd	a6,32(s0)
 656:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 65a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 65e:	8622                	mv	a2,s0
 660:	00000097          	auipc	ra,0x0
 664:	e04080e7          	jalr	-508(ra) # 464 <vprintf>
}
 668:	60e2                	ld	ra,24(sp)
 66a:	6442                	ld	s0,16(sp)
 66c:	6161                	addi	sp,sp,80
 66e:	8082                	ret

0000000000000670 <printf>:

void
printf(const char *fmt, ...)
{
 670:	711d                	addi	sp,sp,-96
 672:	ec06                	sd	ra,24(sp)
 674:	e822                	sd	s0,16(sp)
 676:	1000                	addi	s0,sp,32
 678:	e40c                	sd	a1,8(s0)
 67a:	e810                	sd	a2,16(s0)
 67c:	ec14                	sd	a3,24(s0)
 67e:	f018                	sd	a4,32(s0)
 680:	f41c                	sd	a5,40(s0)
 682:	03043823          	sd	a6,48(s0)
 686:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 68a:	00840613          	addi	a2,s0,8
 68e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 692:	85aa                	mv	a1,a0
 694:	4505                	li	a0,1
 696:	00000097          	auipc	ra,0x0
 69a:	dce080e7          	jalr	-562(ra) # 464 <vprintf>
}
 69e:	60e2                	ld	ra,24(sp)
 6a0:	6442                	ld	s0,16(sp)
 6a2:	6125                	addi	sp,sp,96
 6a4:	8082                	ret

00000000000006a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a6:	1141                	addi	sp,sp,-16
 6a8:	e422                	sd	s0,8(sp)
 6aa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ac:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b0:	00000797          	auipc	a5,0x0
 6b4:	1f07b783          	ld	a5,496(a5) # 8a0 <freep>
 6b8:	a02d                	j	6e2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ba:	4618                	lw	a4,8(a2)
 6bc:	9f2d                	addw	a4,a4,a1
 6be:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c2:	6398                	ld	a4,0(a5)
 6c4:	6310                	ld	a2,0(a4)
 6c6:	a83d                	j	704 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c8:	ff852703          	lw	a4,-8(a0)
 6cc:	9f31                	addw	a4,a4,a2
 6ce:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6d0:	ff053683          	ld	a3,-16(a0)
 6d4:	a091                	j	718 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d6:	6398                	ld	a4,0(a5)
 6d8:	00e7e463          	bltu	a5,a4,6e0 <free+0x3a>
 6dc:	00e6ea63          	bltu	a3,a4,6f0 <free+0x4a>
{
 6e0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e2:	fed7fae3          	bgeu	a5,a3,6d6 <free+0x30>
 6e6:	6398                	ld	a4,0(a5)
 6e8:	00e6e463          	bltu	a3,a4,6f0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ec:	fee7eae3          	bltu	a5,a4,6e0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6f0:	ff852583          	lw	a1,-8(a0)
 6f4:	6390                	ld	a2,0(a5)
 6f6:	02059813          	slli	a6,a1,0x20
 6fa:	01c85713          	srli	a4,a6,0x1c
 6fe:	9736                	add	a4,a4,a3
 700:	fae60de3          	beq	a2,a4,6ba <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 704:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 708:	4790                	lw	a2,8(a5)
 70a:	02061593          	slli	a1,a2,0x20
 70e:	01c5d713          	srli	a4,a1,0x1c
 712:	973e                	add	a4,a4,a5
 714:	fae68ae3          	beq	a3,a4,6c8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 718:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 71a:	00000717          	auipc	a4,0x0
 71e:	18f73323          	sd	a5,390(a4) # 8a0 <freep>
}
 722:	6422                	ld	s0,8(sp)
 724:	0141                	addi	sp,sp,16
 726:	8082                	ret

0000000000000728 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 728:	7139                	addi	sp,sp,-64
 72a:	fc06                	sd	ra,56(sp)
 72c:	f822                	sd	s0,48(sp)
 72e:	f426                	sd	s1,40(sp)
 730:	f04a                	sd	s2,32(sp)
 732:	ec4e                	sd	s3,24(sp)
 734:	e852                	sd	s4,16(sp)
 736:	e456                	sd	s5,8(sp)
 738:	e05a                	sd	s6,0(sp)
 73a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 73c:	02051493          	slli	s1,a0,0x20
 740:	9081                	srli	s1,s1,0x20
 742:	04bd                	addi	s1,s1,15
 744:	8091                	srli	s1,s1,0x4
 746:	0014899b          	addiw	s3,s1,1
 74a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 74c:	00000517          	auipc	a0,0x0
 750:	15453503          	ld	a0,340(a0) # 8a0 <freep>
 754:	c515                	beqz	a0,780 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 756:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 758:	4798                	lw	a4,8(a5)
 75a:	02977f63          	bgeu	a4,s1,798 <malloc+0x70>
 75e:	8a4e                	mv	s4,s3
 760:	0009871b          	sext.w	a4,s3
 764:	6685                	lui	a3,0x1
 766:	00d77363          	bgeu	a4,a3,76c <malloc+0x44>
 76a:	6a05                	lui	s4,0x1
 76c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 770:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 774:	00000917          	auipc	s2,0x0
 778:	12c90913          	addi	s2,s2,300 # 8a0 <freep>
  if(p == (char*)-1)
 77c:	5afd                	li	s5,-1
 77e:	a895                	j	7f2 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 780:	00000797          	auipc	a5,0x0
 784:	12878793          	addi	a5,a5,296 # 8a8 <base>
 788:	00000717          	auipc	a4,0x0
 78c:	10f73c23          	sd	a5,280(a4) # 8a0 <freep>
 790:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 792:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 796:	b7e1                	j	75e <malloc+0x36>
      if(p->s.size == nunits)
 798:	02e48c63          	beq	s1,a4,7d0 <malloc+0xa8>
        p->s.size -= nunits;
 79c:	4137073b          	subw	a4,a4,s3
 7a0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7a2:	02071693          	slli	a3,a4,0x20
 7a6:	01c6d713          	srli	a4,a3,0x1c
 7aa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7ac:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7b0:	00000717          	auipc	a4,0x0
 7b4:	0ea73823          	sd	a0,240(a4) # 8a0 <freep>
      return (void*)(p + 1);
 7b8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7bc:	70e2                	ld	ra,56(sp)
 7be:	7442                	ld	s0,48(sp)
 7c0:	74a2                	ld	s1,40(sp)
 7c2:	7902                	ld	s2,32(sp)
 7c4:	69e2                	ld	s3,24(sp)
 7c6:	6a42                	ld	s4,16(sp)
 7c8:	6aa2                	ld	s5,8(sp)
 7ca:	6b02                	ld	s6,0(sp)
 7cc:	6121                	addi	sp,sp,64
 7ce:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7d0:	6398                	ld	a4,0(a5)
 7d2:	e118                	sd	a4,0(a0)
 7d4:	bff1                	j	7b0 <malloc+0x88>
  hp->s.size = nu;
 7d6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7da:	0541                	addi	a0,a0,16
 7dc:	00000097          	auipc	ra,0x0
 7e0:	eca080e7          	jalr	-310(ra) # 6a6 <free>
  return freep;
 7e4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7e8:	d971                	beqz	a0,7bc <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ec:	4798                	lw	a4,8(a5)
 7ee:	fa9775e3          	bgeu	a4,s1,798 <malloc+0x70>
    if(p == freep)
 7f2:	00093703          	ld	a4,0(s2)
 7f6:	853e                	mv	a0,a5
 7f8:	fef719e3          	bne	a4,a5,7ea <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7fc:	8552                	mv	a0,s4
 7fe:	00000097          	auipc	ra,0x0
 802:	b70080e7          	jalr	-1168(ra) # 36e <sbrk>
  if(p == (char*)-1)
 806:	fd5518e3          	bne	a0,s5,7d6 <malloc+0xae>
        return 0;
 80a:	4501                	li	a0,0
 80c:	bf45                	j	7bc <malloc+0x94>
