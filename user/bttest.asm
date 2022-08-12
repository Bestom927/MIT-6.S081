
user/_bttest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  sleep(1);
   8:	4505                	li	a0,1
   a:	00000097          	auipc	ra,0x0
   e:	30e080e7          	jalr	782(ra) # 318 <sleep>
  exit(0);
  12:	4501                	li	a0,0
  14:	00000097          	auipc	ra,0x0
  18:	274080e7          	jalr	628(ra) # 288 <exit>

000000000000001c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  1c:	1141                	addi	sp,sp,-16
  1e:	e422                	sd	s0,8(sp)
  20:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  22:	87aa                	mv	a5,a0
  24:	0585                	addi	a1,a1,1
  26:	0785                	addi	a5,a5,1
  28:	fff5c703          	lbu	a4,-1(a1)
  2c:	fee78fa3          	sb	a4,-1(a5)
  30:	fb75                	bnez	a4,24 <strcpy+0x8>
    ;
  return os;
}
  32:	6422                	ld	s0,8(sp)
  34:	0141                	addi	sp,sp,16
  36:	8082                	ret

0000000000000038 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  38:	1141                	addi	sp,sp,-16
  3a:	e422                	sd	s0,8(sp)
  3c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  3e:	00054783          	lbu	a5,0(a0)
  42:	cb91                	beqz	a5,56 <strcmp+0x1e>
  44:	0005c703          	lbu	a4,0(a1)
  48:	00f71763          	bne	a4,a5,56 <strcmp+0x1e>
    p++, q++;
  4c:	0505                	addi	a0,a0,1
  4e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  50:	00054783          	lbu	a5,0(a0)
  54:	fbe5                	bnez	a5,44 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  56:	0005c503          	lbu	a0,0(a1)
}
  5a:	40a7853b          	subw	a0,a5,a0
  5e:	6422                	ld	s0,8(sp)
  60:	0141                	addi	sp,sp,16
  62:	8082                	ret

0000000000000064 <strlen>:

uint
strlen(const char *s)
{
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	cf91                	beqz	a5,8a <strlen+0x26>
  70:	0505                	addi	a0,a0,1
  72:	87aa                	mv	a5,a0
  74:	4685                	li	a3,1
  76:	9e89                	subw	a3,a3,a0
  78:	00f6853b          	addw	a0,a3,a5
  7c:	0785                	addi	a5,a5,1
  7e:	fff7c703          	lbu	a4,-1(a5)
  82:	fb7d                	bnez	a4,78 <strlen+0x14>
    ;
  return n;
}
  84:	6422                	ld	s0,8(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret
  for(n = 0; s[n]; n++)
  8a:	4501                	li	a0,0
  8c:	bfe5                	j	84 <strlen+0x20>

000000000000008e <memset>:

void*
memset(void *dst, int c, uint n)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e422                	sd	s0,8(sp)
  92:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  94:	ca19                	beqz	a2,aa <memset+0x1c>
  96:	87aa                	mv	a5,a0
  98:	1602                	slli	a2,a2,0x20
  9a:	9201                	srli	a2,a2,0x20
  9c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  a4:	0785                	addi	a5,a5,1
  a6:	fee79de3          	bne	a5,a4,a0 <memset+0x12>
  }
  return dst;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strchr>:

char*
strchr(const char *s, char c)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cb99                	beqz	a5,d0 <strchr+0x20>
    if(*s == c)
  bc:	00f58763          	beq	a1,a5,ca <strchr+0x1a>
  for(; *s; s++)
  c0:	0505                	addi	a0,a0,1
  c2:	00054783          	lbu	a5,0(a0)
  c6:	fbfd                	bnez	a5,bc <strchr+0xc>
      return (char*)s;
  return 0;
  c8:	4501                	li	a0,0
}
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret
  return 0;
  d0:	4501                	li	a0,0
  d2:	bfe5                	j	ca <strchr+0x1a>

00000000000000d4 <gets>:

char*
gets(char *buf, int max)
{
  d4:	711d                	addi	sp,sp,-96
  d6:	ec86                	sd	ra,88(sp)
  d8:	e8a2                	sd	s0,80(sp)
  da:	e4a6                	sd	s1,72(sp)
  dc:	e0ca                	sd	s2,64(sp)
  de:	fc4e                	sd	s3,56(sp)
  e0:	f852                	sd	s4,48(sp)
  e2:	f456                	sd	s5,40(sp)
  e4:	f05a                	sd	s6,32(sp)
  e6:	ec5e                	sd	s7,24(sp)
  e8:	1080                	addi	s0,sp,96
  ea:	8baa                	mv	s7,a0
  ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  ee:	892a                	mv	s2,a0
  f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  f2:	4aa9                	li	s5,10
  f4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
  f6:	89a6                	mv	s3,s1
  f8:	2485                	addiw	s1,s1,1
  fa:	0344d863          	bge	s1,s4,12a <gets+0x56>
    cc = read(0, &c, 1);
  fe:	4605                	li	a2,1
 100:	faf40593          	addi	a1,s0,-81
 104:	4501                	li	a0,0
 106:	00000097          	auipc	ra,0x0
 10a:	19a080e7          	jalr	410(ra) # 2a0 <read>
    if(cc < 1)
 10e:	00a05e63          	blez	a0,12a <gets+0x56>
    buf[i++] = c;
 112:	faf44783          	lbu	a5,-81(s0)
 116:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 11a:	01578763          	beq	a5,s5,128 <gets+0x54>
 11e:	0905                	addi	s2,s2,1
 120:	fd679be3          	bne	a5,s6,f6 <gets+0x22>
  for(i=0; i+1 < max; ){
 124:	89a6                	mv	s3,s1
 126:	a011                	j	12a <gets+0x56>
 128:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 12a:	99de                	add	s3,s3,s7
 12c:	00098023          	sb	zero,0(s3)
  return buf;
}
 130:	855e                	mv	a0,s7
 132:	60e6                	ld	ra,88(sp)
 134:	6446                	ld	s0,80(sp)
 136:	64a6                	ld	s1,72(sp)
 138:	6906                	ld	s2,64(sp)
 13a:	79e2                	ld	s3,56(sp)
 13c:	7a42                	ld	s4,48(sp)
 13e:	7aa2                	ld	s5,40(sp)
 140:	7b02                	ld	s6,32(sp)
 142:	6be2                	ld	s7,24(sp)
 144:	6125                	addi	sp,sp,96
 146:	8082                	ret

0000000000000148 <stat>:

int
stat(const char *n, struct stat *st)
{
 148:	1101                	addi	sp,sp,-32
 14a:	ec06                	sd	ra,24(sp)
 14c:	e822                	sd	s0,16(sp)
 14e:	e426                	sd	s1,8(sp)
 150:	e04a                	sd	s2,0(sp)
 152:	1000                	addi	s0,sp,32
 154:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 156:	4581                	li	a1,0
 158:	00000097          	auipc	ra,0x0
 15c:	170080e7          	jalr	368(ra) # 2c8 <open>
  if(fd < 0)
 160:	02054563          	bltz	a0,18a <stat+0x42>
 164:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 166:	85ca                	mv	a1,s2
 168:	00000097          	auipc	ra,0x0
 16c:	178080e7          	jalr	376(ra) # 2e0 <fstat>
 170:	892a                	mv	s2,a0
  close(fd);
 172:	8526                	mv	a0,s1
 174:	00000097          	auipc	ra,0x0
 178:	13c080e7          	jalr	316(ra) # 2b0 <close>
  return r;
}
 17c:	854a                	mv	a0,s2
 17e:	60e2                	ld	ra,24(sp)
 180:	6442                	ld	s0,16(sp)
 182:	64a2                	ld	s1,8(sp)
 184:	6902                	ld	s2,0(sp)
 186:	6105                	addi	sp,sp,32
 188:	8082                	ret
    return -1;
 18a:	597d                	li	s2,-1
 18c:	bfc5                	j	17c <stat+0x34>

000000000000018e <atoi>:

int
atoi(const char *s)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 194:	00054683          	lbu	a3,0(a0)
 198:	fd06879b          	addiw	a5,a3,-48
 19c:	0ff7f793          	zext.b	a5,a5
 1a0:	4625                	li	a2,9
 1a2:	02f66863          	bltu	a2,a5,1d2 <atoi+0x44>
 1a6:	872a                	mv	a4,a0
  n = 0;
 1a8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1aa:	0705                	addi	a4,a4,1
 1ac:	0025179b          	slliw	a5,a0,0x2
 1b0:	9fa9                	addw	a5,a5,a0
 1b2:	0017979b          	slliw	a5,a5,0x1
 1b6:	9fb5                	addw	a5,a5,a3
 1b8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1bc:	00074683          	lbu	a3,0(a4)
 1c0:	fd06879b          	addiw	a5,a3,-48
 1c4:	0ff7f793          	zext.b	a5,a5
 1c8:	fef671e3          	bgeu	a2,a5,1aa <atoi+0x1c>
  return n;
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  n = 0;
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <atoi+0x3e>

00000000000001d6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1dc:	02b57463          	bgeu	a0,a1,204 <memmove+0x2e>
    while(n-- > 0)
 1e0:	00c05f63          	blez	a2,1fe <memmove+0x28>
 1e4:	1602                	slli	a2,a2,0x20
 1e6:	9201                	srli	a2,a2,0x20
 1e8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1ec:	872a                	mv	a4,a0
      *dst++ = *src++;
 1ee:	0585                	addi	a1,a1,1
 1f0:	0705                	addi	a4,a4,1
 1f2:	fff5c683          	lbu	a3,-1(a1)
 1f6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fa:	fee79ae3          	bne	a5,a4,1ee <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret
    dst += n;
 204:	00c50733          	add	a4,a0,a2
    src += n;
 208:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20a:	fec05ae3          	blez	a2,1fe <memmove+0x28>
 20e:	fff6079b          	addiw	a5,a2,-1
 212:	1782                	slli	a5,a5,0x20
 214:	9381                	srli	a5,a5,0x20
 216:	fff7c793          	not	a5,a5
 21a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 21c:	15fd                	addi	a1,a1,-1
 21e:	177d                	addi	a4,a4,-1
 220:	0005c683          	lbu	a3,0(a1)
 224:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 228:	fee79ae3          	bne	a5,a4,21c <memmove+0x46>
 22c:	bfc9                	j	1fe <memmove+0x28>

000000000000022e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 234:	ca05                	beqz	a2,264 <memcmp+0x36>
 236:	fff6069b          	addiw	a3,a2,-1
 23a:	1682                	slli	a3,a3,0x20
 23c:	9281                	srli	a3,a3,0x20
 23e:	0685                	addi	a3,a3,1
 240:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 242:	00054783          	lbu	a5,0(a0)
 246:	0005c703          	lbu	a4,0(a1)
 24a:	00e79863          	bne	a5,a4,25a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 24e:	0505                	addi	a0,a0,1
    p2++;
 250:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 252:	fed518e3          	bne	a0,a3,242 <memcmp+0x14>
  }
  return 0;
 256:	4501                	li	a0,0
 258:	a019                	j	25e <memcmp+0x30>
      return *p1 - *p2;
 25a:	40e7853b          	subw	a0,a5,a4
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
  return 0;
 264:	4501                	li	a0,0
 266:	bfe5                	j	25e <memcmp+0x30>

0000000000000268 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 270:	00000097          	auipc	ra,0x0
 274:	f66080e7          	jalr	-154(ra) # 1d6 <memmove>
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret

0000000000000280 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 280:	4885                	li	a7,1
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <exit>:
.global exit
exit:
 li a7, SYS_exit
 288:	4889                	li	a7,2
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <wait>:
.global wait
wait:
 li a7, SYS_wait
 290:	488d                	li	a7,3
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 298:	4891                	li	a7,4
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <read>:
.global read
read:
 li a7, SYS_read
 2a0:	4895                	li	a7,5
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <write>:
.global write
write:
 li a7, SYS_write
 2a8:	48c1                	li	a7,16
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <close>:
.global close
close:
 li a7, SYS_close
 2b0:	48d5                	li	a7,21
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2b8:	4899                	li	a7,6
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c0:	489d                	li	a7,7
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <open>:
.global open
open:
 li a7, SYS_open
 2c8:	48bd                	li	a7,15
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d0:	48c5                	li	a7,17
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2d8:	48c9                	li	a7,18
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e0:	48a1                	li	a7,8
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <link>:
.global link
link:
 li a7, SYS_link
 2e8:	48cd                	li	a7,19
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f0:	48d1                	li	a7,20
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2f8:	48a5                	li	a7,9
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <dup>:
.global dup
dup:
 li a7, SYS_dup
 300:	48a9                	li	a7,10
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 308:	48ad                	li	a7,11
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 310:	48b1                	li	a7,12
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 318:	48b5                	li	a7,13
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 320:	48b9                	li	a7,14
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 328:	48d9                	li	a7,22
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 330:	48dd                	li	a7,23
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 338:	1101                	addi	sp,sp,-32
 33a:	ec06                	sd	ra,24(sp)
 33c:	e822                	sd	s0,16(sp)
 33e:	1000                	addi	s0,sp,32
 340:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 344:	4605                	li	a2,1
 346:	fef40593          	addi	a1,s0,-17
 34a:	00000097          	auipc	ra,0x0
 34e:	f5e080e7          	jalr	-162(ra) # 2a8 <write>
}
 352:	60e2                	ld	ra,24(sp)
 354:	6442                	ld	s0,16(sp)
 356:	6105                	addi	sp,sp,32
 358:	8082                	ret

000000000000035a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 35a:	7139                	addi	sp,sp,-64
 35c:	fc06                	sd	ra,56(sp)
 35e:	f822                	sd	s0,48(sp)
 360:	f426                	sd	s1,40(sp)
 362:	f04a                	sd	s2,32(sp)
 364:	ec4e                	sd	s3,24(sp)
 366:	0080                	addi	s0,sp,64
 368:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36a:	c299                	beqz	a3,370 <printint+0x16>
 36c:	0805c963          	bltz	a1,3fe <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 370:	2581                	sext.w	a1,a1
  neg = 0;
 372:	4881                	li	a7,0
 374:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 378:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 37a:	2601                	sext.w	a2,a2
 37c:	00000517          	auipc	a0,0x0
 380:	49450513          	addi	a0,a0,1172 # 810 <digits>
 384:	883a                	mv	a6,a4
 386:	2705                	addiw	a4,a4,1
 388:	02c5f7bb          	remuw	a5,a1,a2
 38c:	1782                	slli	a5,a5,0x20
 38e:	9381                	srli	a5,a5,0x20
 390:	97aa                	add	a5,a5,a0
 392:	0007c783          	lbu	a5,0(a5)
 396:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 39a:	0005879b          	sext.w	a5,a1
 39e:	02c5d5bb          	divuw	a1,a1,a2
 3a2:	0685                	addi	a3,a3,1
 3a4:	fec7f0e3          	bgeu	a5,a2,384 <printint+0x2a>
  if(neg)
 3a8:	00088c63          	beqz	a7,3c0 <printint+0x66>
    buf[i++] = '-';
 3ac:	fd070793          	addi	a5,a4,-48
 3b0:	00878733          	add	a4,a5,s0
 3b4:	02d00793          	li	a5,45
 3b8:	fef70823          	sb	a5,-16(a4)
 3bc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3c0:	02e05863          	blez	a4,3f0 <printint+0x96>
 3c4:	fc040793          	addi	a5,s0,-64
 3c8:	00e78933          	add	s2,a5,a4
 3cc:	fff78993          	addi	s3,a5,-1
 3d0:	99ba                	add	s3,s3,a4
 3d2:	377d                	addiw	a4,a4,-1
 3d4:	1702                	slli	a4,a4,0x20
 3d6:	9301                	srli	a4,a4,0x20
 3d8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3dc:	fff94583          	lbu	a1,-1(s2)
 3e0:	8526                	mv	a0,s1
 3e2:	00000097          	auipc	ra,0x0
 3e6:	f56080e7          	jalr	-170(ra) # 338 <putc>
  while(--i >= 0)
 3ea:	197d                	addi	s2,s2,-1
 3ec:	ff3918e3          	bne	s2,s3,3dc <printint+0x82>
}
 3f0:	70e2                	ld	ra,56(sp)
 3f2:	7442                	ld	s0,48(sp)
 3f4:	74a2                	ld	s1,40(sp)
 3f6:	7902                	ld	s2,32(sp)
 3f8:	69e2                	ld	s3,24(sp)
 3fa:	6121                	addi	sp,sp,64
 3fc:	8082                	ret
    x = -xx;
 3fe:	40b005bb          	negw	a1,a1
    neg = 1;
 402:	4885                	li	a7,1
    x = -xx;
 404:	bf85                	j	374 <printint+0x1a>

0000000000000406 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 406:	7119                	addi	sp,sp,-128
 408:	fc86                	sd	ra,120(sp)
 40a:	f8a2                	sd	s0,112(sp)
 40c:	f4a6                	sd	s1,104(sp)
 40e:	f0ca                	sd	s2,96(sp)
 410:	ecce                	sd	s3,88(sp)
 412:	e8d2                	sd	s4,80(sp)
 414:	e4d6                	sd	s5,72(sp)
 416:	e0da                	sd	s6,64(sp)
 418:	fc5e                	sd	s7,56(sp)
 41a:	f862                	sd	s8,48(sp)
 41c:	f466                	sd	s9,40(sp)
 41e:	f06a                	sd	s10,32(sp)
 420:	ec6e                	sd	s11,24(sp)
 422:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 424:	0005c903          	lbu	s2,0(a1)
 428:	18090f63          	beqz	s2,5c6 <vprintf+0x1c0>
 42c:	8aaa                	mv	s5,a0
 42e:	8b32                	mv	s6,a2
 430:	00158493          	addi	s1,a1,1
  state = 0;
 434:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 436:	02500a13          	li	s4,37
 43a:	4c55                	li	s8,21
 43c:	00000c97          	auipc	s9,0x0
 440:	37cc8c93          	addi	s9,s9,892 # 7b8 <malloc+0xee>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 444:	02800d93          	li	s11,40
  putc(fd, 'x');
 448:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 44a:	00000b97          	auipc	s7,0x0
 44e:	3c6b8b93          	addi	s7,s7,966 # 810 <digits>
 452:	a839                	j	470 <vprintf+0x6a>
        putc(fd, c);
 454:	85ca                	mv	a1,s2
 456:	8556                	mv	a0,s5
 458:	00000097          	auipc	ra,0x0
 45c:	ee0080e7          	jalr	-288(ra) # 338 <putc>
 460:	a019                	j	466 <vprintf+0x60>
    } else if(state == '%'){
 462:	01498d63          	beq	s3,s4,47c <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 466:	0485                	addi	s1,s1,1
 468:	fff4c903          	lbu	s2,-1(s1)
 46c:	14090d63          	beqz	s2,5c6 <vprintf+0x1c0>
    if(state == 0){
 470:	fe0999e3          	bnez	s3,462 <vprintf+0x5c>
      if(c == '%'){
 474:	ff4910e3          	bne	s2,s4,454 <vprintf+0x4e>
        state = '%';
 478:	89d2                	mv	s3,s4
 47a:	b7f5                	j	466 <vprintf+0x60>
      if(c == 'd'){
 47c:	11490c63          	beq	s2,s4,594 <vprintf+0x18e>
 480:	f9d9079b          	addiw	a5,s2,-99
 484:	0ff7f793          	zext.b	a5,a5
 488:	10fc6e63          	bltu	s8,a5,5a4 <vprintf+0x19e>
 48c:	f9d9079b          	addiw	a5,s2,-99
 490:	0ff7f713          	zext.b	a4,a5
 494:	10ec6863          	bltu	s8,a4,5a4 <vprintf+0x19e>
 498:	00271793          	slli	a5,a4,0x2
 49c:	97e6                	add	a5,a5,s9
 49e:	439c                	lw	a5,0(a5)
 4a0:	97e6                	add	a5,a5,s9
 4a2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4a4:	008b0913          	addi	s2,s6,8
 4a8:	4685                	li	a3,1
 4aa:	4629                	li	a2,10
 4ac:	000b2583          	lw	a1,0(s6)
 4b0:	8556                	mv	a0,s5
 4b2:	00000097          	auipc	ra,0x0
 4b6:	ea8080e7          	jalr	-344(ra) # 35a <printint>
 4ba:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4bc:	4981                	li	s3,0
 4be:	b765                	j	466 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4c0:	008b0913          	addi	s2,s6,8
 4c4:	4681                	li	a3,0
 4c6:	4629                	li	a2,10
 4c8:	000b2583          	lw	a1,0(s6)
 4cc:	8556                	mv	a0,s5
 4ce:	00000097          	auipc	ra,0x0
 4d2:	e8c080e7          	jalr	-372(ra) # 35a <printint>
 4d6:	8b4a                	mv	s6,s2
      state = 0;
 4d8:	4981                	li	s3,0
 4da:	b771                	j	466 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4dc:	008b0913          	addi	s2,s6,8
 4e0:	4681                	li	a3,0
 4e2:	866a                	mv	a2,s10
 4e4:	000b2583          	lw	a1,0(s6)
 4e8:	8556                	mv	a0,s5
 4ea:	00000097          	auipc	ra,0x0
 4ee:	e70080e7          	jalr	-400(ra) # 35a <printint>
 4f2:	8b4a                	mv	s6,s2
      state = 0;
 4f4:	4981                	li	s3,0
 4f6:	bf85                	j	466 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4f8:	008b0793          	addi	a5,s6,8
 4fc:	f8f43423          	sd	a5,-120(s0)
 500:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 504:	03000593          	li	a1,48
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	e2e080e7          	jalr	-466(ra) # 338 <putc>
  putc(fd, 'x');
 512:	07800593          	li	a1,120
 516:	8556                	mv	a0,s5
 518:	00000097          	auipc	ra,0x0
 51c:	e20080e7          	jalr	-480(ra) # 338 <putc>
 520:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 522:	03c9d793          	srli	a5,s3,0x3c
 526:	97de                	add	a5,a5,s7
 528:	0007c583          	lbu	a1,0(a5)
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	e0a080e7          	jalr	-502(ra) # 338 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 536:	0992                	slli	s3,s3,0x4
 538:	397d                	addiw	s2,s2,-1
 53a:	fe0914e3          	bnez	s2,522 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 53e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 542:	4981                	li	s3,0
 544:	b70d                	j	466 <vprintf+0x60>
        s = va_arg(ap, char*);
 546:	008b0913          	addi	s2,s6,8
 54a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 54e:	02098163          	beqz	s3,570 <vprintf+0x16a>
        while(*s != 0){
 552:	0009c583          	lbu	a1,0(s3)
 556:	c5ad                	beqz	a1,5c0 <vprintf+0x1ba>
          putc(fd, *s);
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	dde080e7          	jalr	-546(ra) # 338 <putc>
          s++;
 562:	0985                	addi	s3,s3,1
        while(*s != 0){
 564:	0009c583          	lbu	a1,0(s3)
 568:	f9e5                	bnez	a1,558 <vprintf+0x152>
        s = va_arg(ap, char*);
 56a:	8b4a                	mv	s6,s2
      state = 0;
 56c:	4981                	li	s3,0
 56e:	bde5                	j	466 <vprintf+0x60>
          s = "(null)";
 570:	00000997          	auipc	s3,0x0
 574:	24098993          	addi	s3,s3,576 # 7b0 <malloc+0xe6>
        while(*s != 0){
 578:	85ee                	mv	a1,s11
 57a:	bff9                	j	558 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 57c:	008b0913          	addi	s2,s6,8
 580:	000b4583          	lbu	a1,0(s6)
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	db2080e7          	jalr	-590(ra) # 338 <putc>
 58e:	8b4a                	mv	s6,s2
      state = 0;
 590:	4981                	li	s3,0
 592:	bdd1                	j	466 <vprintf+0x60>
        putc(fd, c);
 594:	85d2                	mv	a1,s4
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	da0080e7          	jalr	-608(ra) # 338 <putc>
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	b5d1                	j	466 <vprintf+0x60>
        putc(fd, '%');
 5a4:	85d2                	mv	a1,s4
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	d90080e7          	jalr	-624(ra) # 338 <putc>
        putc(fd, c);
 5b0:	85ca                	mv	a1,s2
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	d84080e7          	jalr	-636(ra) # 338 <putc>
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	b565                	j	466 <vprintf+0x60>
        s = va_arg(ap, char*);
 5c0:	8b4a                	mv	s6,s2
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b54d                	j	466 <vprintf+0x60>
    }
  }
}
 5c6:	70e6                	ld	ra,120(sp)
 5c8:	7446                	ld	s0,112(sp)
 5ca:	74a6                	ld	s1,104(sp)
 5cc:	7906                	ld	s2,96(sp)
 5ce:	69e6                	ld	s3,88(sp)
 5d0:	6a46                	ld	s4,80(sp)
 5d2:	6aa6                	ld	s5,72(sp)
 5d4:	6b06                	ld	s6,64(sp)
 5d6:	7be2                	ld	s7,56(sp)
 5d8:	7c42                	ld	s8,48(sp)
 5da:	7ca2                	ld	s9,40(sp)
 5dc:	7d02                	ld	s10,32(sp)
 5de:	6de2                	ld	s11,24(sp)
 5e0:	6109                	addi	sp,sp,128
 5e2:	8082                	ret

00000000000005e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5e4:	715d                	addi	sp,sp,-80
 5e6:	ec06                	sd	ra,24(sp)
 5e8:	e822                	sd	s0,16(sp)
 5ea:	1000                	addi	s0,sp,32
 5ec:	e010                	sd	a2,0(s0)
 5ee:	e414                	sd	a3,8(s0)
 5f0:	e818                	sd	a4,16(s0)
 5f2:	ec1c                	sd	a5,24(s0)
 5f4:	03043023          	sd	a6,32(s0)
 5f8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 600:	8622                	mv	a2,s0
 602:	00000097          	auipc	ra,0x0
 606:	e04080e7          	jalr	-508(ra) # 406 <vprintf>
}
 60a:	60e2                	ld	ra,24(sp)
 60c:	6442                	ld	s0,16(sp)
 60e:	6161                	addi	sp,sp,80
 610:	8082                	ret

0000000000000612 <printf>:

void
printf(const char *fmt, ...)
{
 612:	711d                	addi	sp,sp,-96
 614:	ec06                	sd	ra,24(sp)
 616:	e822                	sd	s0,16(sp)
 618:	1000                	addi	s0,sp,32
 61a:	e40c                	sd	a1,8(s0)
 61c:	e810                	sd	a2,16(s0)
 61e:	ec14                	sd	a3,24(s0)
 620:	f018                	sd	a4,32(s0)
 622:	f41c                	sd	a5,40(s0)
 624:	03043823          	sd	a6,48(s0)
 628:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 62c:	00840613          	addi	a2,s0,8
 630:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 634:	85aa                	mv	a1,a0
 636:	4505                	li	a0,1
 638:	00000097          	auipc	ra,0x0
 63c:	dce080e7          	jalr	-562(ra) # 406 <vprintf>
}
 640:	60e2                	ld	ra,24(sp)
 642:	6442                	ld	s0,16(sp)
 644:	6125                	addi	sp,sp,96
 646:	8082                	ret

0000000000000648 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 648:	1141                	addi	sp,sp,-16
 64a:	e422                	sd	s0,8(sp)
 64c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 64e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 652:	00000797          	auipc	a5,0x0
 656:	1d67b783          	ld	a5,470(a5) # 828 <freep>
 65a:	a02d                	j	684 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 65c:	4618                	lw	a4,8(a2)
 65e:	9f2d                	addw	a4,a4,a1
 660:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 664:	6398                	ld	a4,0(a5)
 666:	6310                	ld	a2,0(a4)
 668:	a83d                	j	6a6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 66a:	ff852703          	lw	a4,-8(a0)
 66e:	9f31                	addw	a4,a4,a2
 670:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 672:	ff053683          	ld	a3,-16(a0)
 676:	a091                	j	6ba <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 678:	6398                	ld	a4,0(a5)
 67a:	00e7e463          	bltu	a5,a4,682 <free+0x3a>
 67e:	00e6ea63          	bltu	a3,a4,692 <free+0x4a>
{
 682:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 684:	fed7fae3          	bgeu	a5,a3,678 <free+0x30>
 688:	6398                	ld	a4,0(a5)
 68a:	00e6e463          	bltu	a3,a4,692 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68e:	fee7eae3          	bltu	a5,a4,682 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 692:	ff852583          	lw	a1,-8(a0)
 696:	6390                	ld	a2,0(a5)
 698:	02059813          	slli	a6,a1,0x20
 69c:	01c85713          	srli	a4,a6,0x1c
 6a0:	9736                	add	a4,a4,a3
 6a2:	fae60de3          	beq	a2,a4,65c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6a6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6aa:	4790                	lw	a2,8(a5)
 6ac:	02061593          	slli	a1,a2,0x20
 6b0:	01c5d713          	srli	a4,a1,0x1c
 6b4:	973e                	add	a4,a4,a5
 6b6:	fae68ae3          	beq	a3,a4,66a <free+0x22>
    p->s.ptr = bp->s.ptr;
 6ba:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6bc:	00000717          	auipc	a4,0x0
 6c0:	16f73623          	sd	a5,364(a4) # 828 <freep>
}
 6c4:	6422                	ld	s0,8(sp)
 6c6:	0141                	addi	sp,sp,16
 6c8:	8082                	ret

00000000000006ca <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6ca:	7139                	addi	sp,sp,-64
 6cc:	fc06                	sd	ra,56(sp)
 6ce:	f822                	sd	s0,48(sp)
 6d0:	f426                	sd	s1,40(sp)
 6d2:	f04a                	sd	s2,32(sp)
 6d4:	ec4e                	sd	s3,24(sp)
 6d6:	e852                	sd	s4,16(sp)
 6d8:	e456                	sd	s5,8(sp)
 6da:	e05a                	sd	s6,0(sp)
 6dc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6de:	02051493          	slli	s1,a0,0x20
 6e2:	9081                	srli	s1,s1,0x20
 6e4:	04bd                	addi	s1,s1,15
 6e6:	8091                	srli	s1,s1,0x4
 6e8:	0014899b          	addiw	s3,s1,1
 6ec:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6ee:	00000517          	auipc	a0,0x0
 6f2:	13a53503          	ld	a0,314(a0) # 828 <freep>
 6f6:	c515                	beqz	a0,722 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6fa:	4798                	lw	a4,8(a5)
 6fc:	02977f63          	bgeu	a4,s1,73a <malloc+0x70>
 700:	8a4e                	mv	s4,s3
 702:	0009871b          	sext.w	a4,s3
 706:	6685                	lui	a3,0x1
 708:	00d77363          	bgeu	a4,a3,70e <malloc+0x44>
 70c:	6a05                	lui	s4,0x1
 70e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 712:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 716:	00000917          	auipc	s2,0x0
 71a:	11290913          	addi	s2,s2,274 # 828 <freep>
  if(p == (char*)-1)
 71e:	5afd                	li	s5,-1
 720:	a895                	j	794 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 722:	00000797          	auipc	a5,0x0
 726:	10e78793          	addi	a5,a5,270 # 830 <base>
 72a:	00000717          	auipc	a4,0x0
 72e:	0ef73f23          	sd	a5,254(a4) # 828 <freep>
 732:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 734:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 738:	b7e1                	j	700 <malloc+0x36>
      if(p->s.size == nunits)
 73a:	02e48c63          	beq	s1,a4,772 <malloc+0xa8>
        p->s.size -= nunits;
 73e:	4137073b          	subw	a4,a4,s3
 742:	c798                	sw	a4,8(a5)
        p += p->s.size;
 744:	02071693          	slli	a3,a4,0x20
 748:	01c6d713          	srli	a4,a3,0x1c
 74c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 74e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 752:	00000717          	auipc	a4,0x0
 756:	0ca73b23          	sd	a0,214(a4) # 828 <freep>
      return (void*)(p + 1);
 75a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 75e:	70e2                	ld	ra,56(sp)
 760:	7442                	ld	s0,48(sp)
 762:	74a2                	ld	s1,40(sp)
 764:	7902                	ld	s2,32(sp)
 766:	69e2                	ld	s3,24(sp)
 768:	6a42                	ld	s4,16(sp)
 76a:	6aa2                	ld	s5,8(sp)
 76c:	6b02                	ld	s6,0(sp)
 76e:	6121                	addi	sp,sp,64
 770:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 772:	6398                	ld	a4,0(a5)
 774:	e118                	sd	a4,0(a0)
 776:	bff1                	j	752 <malloc+0x88>
  hp->s.size = nu;
 778:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 77c:	0541                	addi	a0,a0,16
 77e:	00000097          	auipc	ra,0x0
 782:	eca080e7          	jalr	-310(ra) # 648 <free>
  return freep;
 786:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 78a:	d971                	beqz	a0,75e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78e:	4798                	lw	a4,8(a5)
 790:	fa9775e3          	bgeu	a4,s1,73a <malloc+0x70>
    if(p == freep)
 794:	00093703          	ld	a4,0(s2)
 798:	853e                	mv	a0,a5
 79a:	fef719e3          	bne	a4,a5,78c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 79e:	8552                	mv	a0,s4
 7a0:	00000097          	auipc	ra,0x0
 7a4:	b70080e7          	jalr	-1168(ra) # 310 <sbrk>
  if(p == (char*)-1)
 7a8:	fd5518e3          	bne	a0,s5,778 <malloc+0xae>
        return 0;
 7ac:	4501                	li	a0,0
 7ae:	bf45                	j	75e <malloc+0x94>
