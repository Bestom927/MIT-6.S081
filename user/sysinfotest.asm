
user/_sysinfotest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sinfo>:
#include "kernel/sysinfo.h"
#include "user/user.h"


void
sinfo(struct sysinfo *info) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if (sysinfo(info) < 0) {
   8:	00000097          	auipc	ra,0x0
   c:	64c080e7          	jalr	1612(ra) # 654 <sysinfo>
  10:	00054663          	bltz	a0,1c <sinfo+0x1c>
    printf("FAIL: sysinfo failed");
    exit(1);
  }
}
  14:	60a2                	ld	ra,8(sp)
  16:	6402                	ld	s0,0(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret
    printf("FAIL: sysinfo failed");
  1c:	00001517          	auipc	a0,0x1
  20:	abc50513          	addi	a0,a0,-1348 # ad8 <malloc+0xea>
  24:	00001097          	auipc	ra,0x1
  28:	912080e7          	jalr	-1774(ra) # 936 <printf>
    exit(1);
  2c:	4505                	li	a0,1
  2e:	00000097          	auipc	ra,0x0
  32:	57e080e7          	jalr	1406(ra) # 5ac <exit>

0000000000000036 <countfree>:
//
// use sbrk() to count how many free physical memory pages there are.
//
int
countfree()
{
  36:	7139                	addi	sp,sp,-64
  38:	fc06                	sd	ra,56(sp)
  3a:	f822                	sd	s0,48(sp)
  3c:	f426                	sd	s1,40(sp)
  3e:	f04a                	sd	s2,32(sp)
  40:	ec4e                	sd	s3,24(sp)
  42:	e852                	sd	s4,16(sp)
  44:	0080                	addi	s0,sp,64
  uint64 sz0 = (uint64)sbrk(0);
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	5ec080e7          	jalr	1516(ra) # 634 <sbrk>
  50:	8a2a                	mv	s4,a0
  struct sysinfo info;
  int n = 0;
  52:	4481                	li	s1,0

  while(1){
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  54:	597d                	li	s2,-1
      break;
    }
    n += PGSIZE;
  56:	6985                	lui	s3,0x1
  58:	a019                	j	5e <countfree+0x28>
  5a:	009984bb          	addw	s1,s3,s1
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  5e:	6505                	lui	a0,0x1
  60:	00000097          	auipc	ra,0x0
  64:	5d4080e7          	jalr	1492(ra) # 634 <sbrk>
  68:	ff2519e3          	bne	a0,s2,5a <countfree+0x24>
  }
  sinfo(&info);
  6c:	fc040513          	addi	a0,s0,-64
  70:	00000097          	auipc	ra,0x0
  74:	f90080e7          	jalr	-112(ra) # 0 <sinfo>
  if (info.freemem != 0) {
  78:	fc043583          	ld	a1,-64(s0)
  7c:	e58d                	bnez	a1,a6 <countfree+0x70>
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
      info.freemem);
    exit(1);
  }
  sbrk(-((uint64)sbrk(0) - sz0));
  7e:	4501                	li	a0,0
  80:	00000097          	auipc	ra,0x0
  84:	5b4080e7          	jalr	1460(ra) # 634 <sbrk>
  88:	40aa053b          	subw	a0,s4,a0
  8c:	00000097          	auipc	ra,0x0
  90:	5a8080e7          	jalr	1448(ra) # 634 <sbrk>
  return n;
}
  94:	8526                	mv	a0,s1
  96:	70e2                	ld	ra,56(sp)
  98:	7442                	ld	s0,48(sp)
  9a:	74a2                	ld	s1,40(sp)
  9c:	7902                	ld	s2,32(sp)
  9e:	69e2                	ld	s3,24(sp)
  a0:	6a42                	ld	s4,16(sp)
  a2:	6121                	addi	sp,sp,64
  a4:	8082                	ret
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
  a6:	00001517          	auipc	a0,0x1
  aa:	a4a50513          	addi	a0,a0,-1462 # af0 <malloc+0x102>
  ae:	00001097          	auipc	ra,0x1
  b2:	888080e7          	jalr	-1912(ra) # 936 <printf>
    exit(1);
  b6:	4505                	li	a0,1
  b8:	00000097          	auipc	ra,0x0
  bc:	4f4080e7          	jalr	1268(ra) # 5ac <exit>

00000000000000c0 <testmem>:

void
testmem() {
  c0:	7179                	addi	sp,sp,-48
  c2:	f406                	sd	ra,40(sp)
  c4:	f022                	sd	s0,32(sp)
  c6:	ec26                	sd	s1,24(sp)
  c8:	e84a                	sd	s2,16(sp)
  ca:	1800                	addi	s0,sp,48
  struct sysinfo info;
  uint64 n = countfree();
  cc:	00000097          	auipc	ra,0x0
  d0:	f6a080e7          	jalr	-150(ra) # 36 <countfree>
  d4:	84aa                	mv	s1,a0
  
  sinfo(&info);
  d6:	fd040513          	addi	a0,s0,-48
  da:	00000097          	auipc	ra,0x0
  de:	f26080e7          	jalr	-218(ra) # 0 <sinfo>

  if (info.freemem!= n) {
  e2:	fd043583          	ld	a1,-48(s0)
  e6:	04959e63          	bne	a1,s1,142 <testmem+0x82>
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
    exit(1);
  }
  
  if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  ea:	6505                	lui	a0,0x1
  ec:	00000097          	auipc	ra,0x0
  f0:	548080e7          	jalr	1352(ra) # 634 <sbrk>
  f4:	57fd                	li	a5,-1
  f6:	06f50463          	beq	a0,a5,15e <testmem+0x9e>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
  fa:	fd040513          	addi	a0,s0,-48
  fe:	00000097          	auipc	ra,0x0
 102:	f02080e7          	jalr	-254(ra) # 0 <sinfo>
    
  if (info.freemem != n-PGSIZE) {
 106:	fd043603          	ld	a2,-48(s0)
 10a:	75fd                	lui	a1,0xfffff
 10c:	95a6                	add	a1,a1,s1
 10e:	06b61563          	bne	a2,a1,178 <testmem+0xb8>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
    exit(1);
  }
  
  if((uint64)sbrk(-PGSIZE) == 0xffffffffffffffff){
 112:	757d                	lui	a0,0xfffff
 114:	00000097          	auipc	ra,0x0
 118:	520080e7          	jalr	1312(ra) # 634 <sbrk>
 11c:	57fd                	li	a5,-1
 11e:	06f50a63          	beq	a0,a5,192 <testmem+0xd2>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
 122:	fd040513          	addi	a0,s0,-48
 126:	00000097          	auipc	ra,0x0
 12a:	eda080e7          	jalr	-294(ra) # 0 <sinfo>
    
  if (info.freemem != n) {
 12e:	fd043603          	ld	a2,-48(s0)
 132:	06961d63          	bne	a2,s1,1ac <testmem+0xec>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
    exit(1);
  }
}
 136:	70a2                	ld	ra,40(sp)
 138:	7402                	ld	s0,32(sp)
 13a:	64e2                	ld	s1,24(sp)
 13c:	6942                	ld	s2,16(sp)
 13e:	6145                	addi	sp,sp,48
 140:	8082                	ret
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
 142:	8626                	mv	a2,s1
 144:	00001517          	auipc	a0,0x1
 148:	9e450513          	addi	a0,a0,-1564 # b28 <malloc+0x13a>
 14c:	00000097          	auipc	ra,0x0
 150:	7ea080e7          	jalr	2026(ra) # 936 <printf>
    exit(1);
 154:	4505                	li	a0,1
 156:	00000097          	auipc	ra,0x0
 15a:	456080e7          	jalr	1110(ra) # 5ac <exit>
    printf("sbrk failed");
 15e:	00001517          	auipc	a0,0x1
 162:	9fa50513          	addi	a0,a0,-1542 # b58 <malloc+0x16a>
 166:	00000097          	auipc	ra,0x0
 16a:	7d0080e7          	jalr	2000(ra) # 936 <printf>
    exit(1);
 16e:	4505                	li	a0,1
 170:	00000097          	auipc	ra,0x0
 174:	43c080e7          	jalr	1084(ra) # 5ac <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
 178:	00001517          	auipc	a0,0x1
 17c:	9b050513          	addi	a0,a0,-1616 # b28 <malloc+0x13a>
 180:	00000097          	auipc	ra,0x0
 184:	7b6080e7          	jalr	1974(ra) # 936 <printf>
    exit(1);
 188:	4505                	li	a0,1
 18a:	00000097          	auipc	ra,0x0
 18e:	422080e7          	jalr	1058(ra) # 5ac <exit>
    printf("sbrk failed");
 192:	00001517          	auipc	a0,0x1
 196:	9c650513          	addi	a0,a0,-1594 # b58 <malloc+0x16a>
 19a:	00000097          	auipc	ra,0x0
 19e:	79c080e7          	jalr	1948(ra) # 936 <printf>
    exit(1);
 1a2:	4505                	li	a0,1
 1a4:	00000097          	auipc	ra,0x0
 1a8:	408080e7          	jalr	1032(ra) # 5ac <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
 1ac:	85a6                	mv	a1,s1
 1ae:	00001517          	auipc	a0,0x1
 1b2:	97a50513          	addi	a0,a0,-1670 # b28 <malloc+0x13a>
 1b6:	00000097          	auipc	ra,0x0
 1ba:	780080e7          	jalr	1920(ra) # 936 <printf>
    exit(1);
 1be:	4505                	li	a0,1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	3ec080e7          	jalr	1004(ra) # 5ac <exit>

00000000000001c8 <testcall>:

void
testcall() {
 1c8:	1101                	addi	sp,sp,-32
 1ca:	ec06                	sd	ra,24(sp)
 1cc:	e822                	sd	s0,16(sp)
 1ce:	1000                	addi	s0,sp,32
  struct sysinfo info;
  
  if (sysinfo(&info) < 0) {
 1d0:	fe040513          	addi	a0,s0,-32
 1d4:	00000097          	auipc	ra,0x0
 1d8:	480080e7          	jalr	1152(ra) # 654 <sysinfo>
 1dc:	02054163          	bltz	a0,1fe <testcall+0x36>
    printf("FAIL: sysinfo failed\n");
    exit(1);
  }

  if (sysinfo((struct sysinfo *) 0xeaeb0b5b00002f5e) !=  0xffffffffffffffff) {
 1e0:	00001517          	auipc	a0,0x1
 1e4:	ac853503          	ld	a0,-1336(a0) # ca8 <__SDATA_BEGIN__>
 1e8:	00000097          	auipc	ra,0x0
 1ec:	46c080e7          	jalr	1132(ra) # 654 <sysinfo>
 1f0:	57fd                	li	a5,-1
 1f2:	02f51363          	bne	a0,a5,218 <testcall+0x50>
    printf("FAIL: sysinfo succeeded with bad argument\n");
    exit(1);
  }
}
 1f6:	60e2                	ld	ra,24(sp)
 1f8:	6442                	ld	s0,16(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
    printf("FAIL: sysinfo failed\n");
 1fe:	00001517          	auipc	a0,0x1
 202:	96a50513          	addi	a0,a0,-1686 # b68 <malloc+0x17a>
 206:	00000097          	auipc	ra,0x0
 20a:	730080e7          	jalr	1840(ra) # 936 <printf>
    exit(1);
 20e:	4505                	li	a0,1
 210:	00000097          	auipc	ra,0x0
 214:	39c080e7          	jalr	924(ra) # 5ac <exit>
    printf("FAIL: sysinfo succeeded with bad argument\n");
 218:	00001517          	auipc	a0,0x1
 21c:	96850513          	addi	a0,a0,-1688 # b80 <malloc+0x192>
 220:	00000097          	auipc	ra,0x0
 224:	716080e7          	jalr	1814(ra) # 936 <printf>
    exit(1);
 228:	4505                	li	a0,1
 22a:	00000097          	auipc	ra,0x0
 22e:	382080e7          	jalr	898(ra) # 5ac <exit>

0000000000000232 <testproc>:

void testproc() {
 232:	7139                	addi	sp,sp,-64
 234:	fc06                	sd	ra,56(sp)
 236:	f822                	sd	s0,48(sp)
 238:	f426                	sd	s1,40(sp)
 23a:	0080                	addi	s0,sp,64
  struct sysinfo info;
  uint64 nproc;
  int status;
  int pid;
  
  sinfo(&info);
 23c:	fd040513          	addi	a0,s0,-48
 240:	00000097          	auipc	ra,0x0
 244:	dc0080e7          	jalr	-576(ra) # 0 <sinfo>
  nproc = info.nproc;
 248:	fd843483          	ld	s1,-40(s0)

  pid = fork();
 24c:	00000097          	auipc	ra,0x0
 250:	358080e7          	jalr	856(ra) # 5a4 <fork>
  if(pid < 0){
 254:	02054c63          	bltz	a0,28c <testproc+0x5a>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 258:	ed21                	bnez	a0,2b0 <testproc+0x7e>
    sinfo(&info);
 25a:	fd040513          	addi	a0,s0,-48
 25e:	00000097          	auipc	ra,0x0
 262:	da2080e7          	jalr	-606(ra) # 0 <sinfo>
    if(info.nproc != nproc+1) {
 266:	fd843583          	ld	a1,-40(s0)
 26a:	00148613          	addi	a2,s1,1
 26e:	02c58c63          	beq	a1,a2,2a6 <testproc+0x74>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc+1);
 272:	00001517          	auipc	a0,0x1
 276:	95e50513          	addi	a0,a0,-1698 # bd0 <malloc+0x1e2>
 27a:	00000097          	auipc	ra,0x0
 27e:	6bc080e7          	jalr	1724(ra) # 936 <printf>
      exit(1);
 282:	4505                	li	a0,1
 284:	00000097          	auipc	ra,0x0
 288:	328080e7          	jalr	808(ra) # 5ac <exit>
    printf("sysinfotest: fork failed\n");
 28c:	00001517          	auipc	a0,0x1
 290:	92450513          	addi	a0,a0,-1756 # bb0 <malloc+0x1c2>
 294:	00000097          	auipc	ra,0x0
 298:	6a2080e7          	jalr	1698(ra) # 936 <printf>
    exit(1);
 29c:	4505                	li	a0,1
 29e:	00000097          	auipc	ra,0x0
 2a2:	30e080e7          	jalr	782(ra) # 5ac <exit>
    }
    exit(0);
 2a6:	4501                	li	a0,0
 2a8:	00000097          	auipc	ra,0x0
 2ac:	304080e7          	jalr	772(ra) # 5ac <exit>
  }
  wait(&status);
 2b0:	fcc40513          	addi	a0,s0,-52
 2b4:	00000097          	auipc	ra,0x0
 2b8:	300080e7          	jalr	768(ra) # 5b4 <wait>
  sinfo(&info);
 2bc:	fd040513          	addi	a0,s0,-48
 2c0:	00000097          	auipc	ra,0x0
 2c4:	d40080e7          	jalr	-704(ra) # 0 <sinfo>
  if(info.nproc != nproc) {
 2c8:	fd843583          	ld	a1,-40(s0)
 2cc:	00959763          	bne	a1,s1,2da <testproc+0xa8>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
      exit(1);
  }
}
 2d0:	70e2                	ld	ra,56(sp)
 2d2:	7442                	ld	s0,48(sp)
 2d4:	74a2                	ld	s1,40(sp)
 2d6:	6121                	addi	sp,sp,64
 2d8:	8082                	ret
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
 2da:	8626                	mv	a2,s1
 2dc:	00001517          	auipc	a0,0x1
 2e0:	8f450513          	addi	a0,a0,-1804 # bd0 <malloc+0x1e2>
 2e4:	00000097          	auipc	ra,0x0
 2e8:	652080e7          	jalr	1618(ra) # 936 <printf>
      exit(1);
 2ec:	4505                	li	a0,1
 2ee:	00000097          	auipc	ra,0x0
 2f2:	2be080e7          	jalr	702(ra) # 5ac <exit>

00000000000002f6 <main>:

int
main(int argc, char *argv[])
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e406                	sd	ra,8(sp)
 2fa:	e022                	sd	s0,0(sp)
 2fc:	0800                	addi	s0,sp,16
  printf("sysinfotest: start\n");
 2fe:	00001517          	auipc	a0,0x1
 302:	90250513          	addi	a0,a0,-1790 # c00 <malloc+0x212>
 306:	00000097          	auipc	ra,0x0
 30a:	630080e7          	jalr	1584(ra) # 936 <printf>
  testcall();
 30e:	00000097          	auipc	ra,0x0
 312:	eba080e7          	jalr	-326(ra) # 1c8 <testcall>
  testmem();
 316:	00000097          	auipc	ra,0x0
 31a:	daa080e7          	jalr	-598(ra) # c0 <testmem>
  testproc();
 31e:	00000097          	auipc	ra,0x0
 322:	f14080e7          	jalr	-236(ra) # 232 <testproc>
  printf("sysinfotest: OK\n");
 326:	00001517          	auipc	a0,0x1
 32a:	8f250513          	addi	a0,a0,-1806 # c18 <malloc+0x22a>
 32e:	00000097          	auipc	ra,0x0
 332:	608080e7          	jalr	1544(ra) # 936 <printf>
  exit(0);
 336:	4501                	li	a0,0
 338:	00000097          	auipc	ra,0x0
 33c:	274080e7          	jalr	628(ra) # 5ac <exit>

0000000000000340 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 340:	1141                	addi	sp,sp,-16
 342:	e422                	sd	s0,8(sp)
 344:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 346:	87aa                	mv	a5,a0
 348:	0585                	addi	a1,a1,1 # fffffffffffff001 <__global_pointer$+0xffffffffffffdb60>
 34a:	0785                	addi	a5,a5,1
 34c:	fff5c703          	lbu	a4,-1(a1)
 350:	fee78fa3          	sb	a4,-1(a5)
 354:	fb75                	bnez	a4,348 <strcpy+0x8>
    ;
  return os;
}
 356:	6422                	ld	s0,8(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret

000000000000035c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 35c:	1141                	addi	sp,sp,-16
 35e:	e422                	sd	s0,8(sp)
 360:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 362:	00054783          	lbu	a5,0(a0)
 366:	cb91                	beqz	a5,37a <strcmp+0x1e>
 368:	0005c703          	lbu	a4,0(a1)
 36c:	00f71763          	bne	a4,a5,37a <strcmp+0x1e>
    p++, q++;
 370:	0505                	addi	a0,a0,1
 372:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 374:	00054783          	lbu	a5,0(a0)
 378:	fbe5                	bnez	a5,368 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 37a:	0005c503          	lbu	a0,0(a1)
}
 37e:	40a7853b          	subw	a0,a5,a0
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret

0000000000000388 <strlen>:

uint
strlen(const char *s)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e422                	sd	s0,8(sp)
 38c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 38e:	00054783          	lbu	a5,0(a0)
 392:	cf91                	beqz	a5,3ae <strlen+0x26>
 394:	0505                	addi	a0,a0,1
 396:	87aa                	mv	a5,a0
 398:	4685                	li	a3,1
 39a:	9e89                	subw	a3,a3,a0
 39c:	00f6853b          	addw	a0,a3,a5
 3a0:	0785                	addi	a5,a5,1
 3a2:	fff7c703          	lbu	a4,-1(a5)
 3a6:	fb7d                	bnez	a4,39c <strlen+0x14>
    ;
  return n;
}
 3a8:	6422                	ld	s0,8(sp)
 3aa:	0141                	addi	sp,sp,16
 3ac:	8082                	ret
  for(n = 0; s[n]; n++)
 3ae:	4501                	li	a0,0
 3b0:	bfe5                	j	3a8 <strlen+0x20>

00000000000003b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e422                	sd	s0,8(sp)
 3b6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3b8:	ca19                	beqz	a2,3ce <memset+0x1c>
 3ba:	87aa                	mv	a5,a0
 3bc:	1602                	slli	a2,a2,0x20
 3be:	9201                	srli	a2,a2,0x20
 3c0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3c4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3c8:	0785                	addi	a5,a5,1
 3ca:	fee79de3          	bne	a5,a4,3c4 <memset+0x12>
  }
  return dst;
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret

00000000000003d4 <strchr>:

char*
strchr(const char *s, char c)
{
 3d4:	1141                	addi	sp,sp,-16
 3d6:	e422                	sd	s0,8(sp)
 3d8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3da:	00054783          	lbu	a5,0(a0)
 3de:	cb99                	beqz	a5,3f4 <strchr+0x20>
    if(*s == c)
 3e0:	00f58763          	beq	a1,a5,3ee <strchr+0x1a>
  for(; *s; s++)
 3e4:	0505                	addi	a0,a0,1
 3e6:	00054783          	lbu	a5,0(a0)
 3ea:	fbfd                	bnez	a5,3e0 <strchr+0xc>
      return (char*)s;
  return 0;
 3ec:	4501                	li	a0,0
}
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret
  return 0;
 3f4:	4501                	li	a0,0
 3f6:	bfe5                	j	3ee <strchr+0x1a>

00000000000003f8 <gets>:

char*
gets(char *buf, int max)
{
 3f8:	711d                	addi	sp,sp,-96
 3fa:	ec86                	sd	ra,88(sp)
 3fc:	e8a2                	sd	s0,80(sp)
 3fe:	e4a6                	sd	s1,72(sp)
 400:	e0ca                	sd	s2,64(sp)
 402:	fc4e                	sd	s3,56(sp)
 404:	f852                	sd	s4,48(sp)
 406:	f456                	sd	s5,40(sp)
 408:	f05a                	sd	s6,32(sp)
 40a:	ec5e                	sd	s7,24(sp)
 40c:	1080                	addi	s0,sp,96
 40e:	8baa                	mv	s7,a0
 410:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 412:	892a                	mv	s2,a0
 414:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 416:	4aa9                	li	s5,10
 418:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 41a:	89a6                	mv	s3,s1
 41c:	2485                	addiw	s1,s1,1
 41e:	0344d863          	bge	s1,s4,44e <gets+0x56>
    cc = read(0, &c, 1);
 422:	4605                	li	a2,1
 424:	faf40593          	addi	a1,s0,-81
 428:	4501                	li	a0,0
 42a:	00000097          	auipc	ra,0x0
 42e:	19a080e7          	jalr	410(ra) # 5c4 <read>
    if(cc < 1)
 432:	00a05e63          	blez	a0,44e <gets+0x56>
    buf[i++] = c;
 436:	faf44783          	lbu	a5,-81(s0)
 43a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 43e:	01578763          	beq	a5,s5,44c <gets+0x54>
 442:	0905                	addi	s2,s2,1
 444:	fd679be3          	bne	a5,s6,41a <gets+0x22>
  for(i=0; i+1 < max; ){
 448:	89a6                	mv	s3,s1
 44a:	a011                	j	44e <gets+0x56>
 44c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 44e:	99de                	add	s3,s3,s7
 450:	00098023          	sb	zero,0(s3) # 1000 <__BSS_END__+0x338>
  return buf;
}
 454:	855e                	mv	a0,s7
 456:	60e6                	ld	ra,88(sp)
 458:	6446                	ld	s0,80(sp)
 45a:	64a6                	ld	s1,72(sp)
 45c:	6906                	ld	s2,64(sp)
 45e:	79e2                	ld	s3,56(sp)
 460:	7a42                	ld	s4,48(sp)
 462:	7aa2                	ld	s5,40(sp)
 464:	7b02                	ld	s6,32(sp)
 466:	6be2                	ld	s7,24(sp)
 468:	6125                	addi	sp,sp,96
 46a:	8082                	ret

000000000000046c <stat>:

int
stat(const char *n, struct stat *st)
{
 46c:	1101                	addi	sp,sp,-32
 46e:	ec06                	sd	ra,24(sp)
 470:	e822                	sd	s0,16(sp)
 472:	e426                	sd	s1,8(sp)
 474:	e04a                	sd	s2,0(sp)
 476:	1000                	addi	s0,sp,32
 478:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 47a:	4581                	li	a1,0
 47c:	00000097          	auipc	ra,0x0
 480:	170080e7          	jalr	368(ra) # 5ec <open>
  if(fd < 0)
 484:	02054563          	bltz	a0,4ae <stat+0x42>
 488:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 48a:	85ca                	mv	a1,s2
 48c:	00000097          	auipc	ra,0x0
 490:	178080e7          	jalr	376(ra) # 604 <fstat>
 494:	892a                	mv	s2,a0
  close(fd);
 496:	8526                	mv	a0,s1
 498:	00000097          	auipc	ra,0x0
 49c:	13c080e7          	jalr	316(ra) # 5d4 <close>
  return r;
}
 4a0:	854a                	mv	a0,s2
 4a2:	60e2                	ld	ra,24(sp)
 4a4:	6442                	ld	s0,16(sp)
 4a6:	64a2                	ld	s1,8(sp)
 4a8:	6902                	ld	s2,0(sp)
 4aa:	6105                	addi	sp,sp,32
 4ac:	8082                	ret
    return -1;
 4ae:	597d                	li	s2,-1
 4b0:	bfc5                	j	4a0 <stat+0x34>

00000000000004b2 <atoi>:

int
atoi(const char *s)
{
 4b2:	1141                	addi	sp,sp,-16
 4b4:	e422                	sd	s0,8(sp)
 4b6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4b8:	00054683          	lbu	a3,0(a0)
 4bc:	fd06879b          	addiw	a5,a3,-48
 4c0:	0ff7f793          	zext.b	a5,a5
 4c4:	4625                	li	a2,9
 4c6:	02f66863          	bltu	a2,a5,4f6 <atoi+0x44>
 4ca:	872a                	mv	a4,a0
  n = 0;
 4cc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4ce:	0705                	addi	a4,a4,1
 4d0:	0025179b          	slliw	a5,a0,0x2
 4d4:	9fa9                	addw	a5,a5,a0
 4d6:	0017979b          	slliw	a5,a5,0x1
 4da:	9fb5                	addw	a5,a5,a3
 4dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4e0:	00074683          	lbu	a3,0(a4)
 4e4:	fd06879b          	addiw	a5,a3,-48
 4e8:	0ff7f793          	zext.b	a5,a5
 4ec:	fef671e3          	bgeu	a2,a5,4ce <atoi+0x1c>
  return n;
}
 4f0:	6422                	ld	s0,8(sp)
 4f2:	0141                	addi	sp,sp,16
 4f4:	8082                	ret
  n = 0;
 4f6:	4501                	li	a0,0
 4f8:	bfe5                	j	4f0 <atoi+0x3e>

00000000000004fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4fa:	1141                	addi	sp,sp,-16
 4fc:	e422                	sd	s0,8(sp)
 4fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 500:	02b57463          	bgeu	a0,a1,528 <memmove+0x2e>
    while(n-- > 0)
 504:	00c05f63          	blez	a2,522 <memmove+0x28>
 508:	1602                	slli	a2,a2,0x20
 50a:	9201                	srli	a2,a2,0x20
 50c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 510:	872a                	mv	a4,a0
      *dst++ = *src++;
 512:	0585                	addi	a1,a1,1
 514:	0705                	addi	a4,a4,1
 516:	fff5c683          	lbu	a3,-1(a1)
 51a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 51e:	fee79ae3          	bne	a5,a4,512 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 522:	6422                	ld	s0,8(sp)
 524:	0141                	addi	sp,sp,16
 526:	8082                	ret
    dst += n;
 528:	00c50733          	add	a4,a0,a2
    src += n;
 52c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 52e:	fec05ae3          	blez	a2,522 <memmove+0x28>
 532:	fff6079b          	addiw	a5,a2,-1
 536:	1782                	slli	a5,a5,0x20
 538:	9381                	srli	a5,a5,0x20
 53a:	fff7c793          	not	a5,a5
 53e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 540:	15fd                	addi	a1,a1,-1
 542:	177d                	addi	a4,a4,-1
 544:	0005c683          	lbu	a3,0(a1)
 548:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 54c:	fee79ae3          	bne	a5,a4,540 <memmove+0x46>
 550:	bfc9                	j	522 <memmove+0x28>

0000000000000552 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 552:	1141                	addi	sp,sp,-16
 554:	e422                	sd	s0,8(sp)
 556:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 558:	ca05                	beqz	a2,588 <memcmp+0x36>
 55a:	fff6069b          	addiw	a3,a2,-1
 55e:	1682                	slli	a3,a3,0x20
 560:	9281                	srli	a3,a3,0x20
 562:	0685                	addi	a3,a3,1
 564:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 566:	00054783          	lbu	a5,0(a0)
 56a:	0005c703          	lbu	a4,0(a1)
 56e:	00e79863          	bne	a5,a4,57e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 572:	0505                	addi	a0,a0,1
    p2++;
 574:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 576:	fed518e3          	bne	a0,a3,566 <memcmp+0x14>
  }
  return 0;
 57a:	4501                	li	a0,0
 57c:	a019                	j	582 <memcmp+0x30>
      return *p1 - *p2;
 57e:	40e7853b          	subw	a0,a5,a4
}
 582:	6422                	ld	s0,8(sp)
 584:	0141                	addi	sp,sp,16
 586:	8082                	ret
  return 0;
 588:	4501                	li	a0,0
 58a:	bfe5                	j	582 <memcmp+0x30>

000000000000058c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 58c:	1141                	addi	sp,sp,-16
 58e:	e406                	sd	ra,8(sp)
 590:	e022                	sd	s0,0(sp)
 592:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 594:	00000097          	auipc	ra,0x0
 598:	f66080e7          	jalr	-154(ra) # 4fa <memmove>
}
 59c:	60a2                	ld	ra,8(sp)
 59e:	6402                	ld	s0,0(sp)
 5a0:	0141                	addi	sp,sp,16
 5a2:	8082                	ret

00000000000005a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5a4:	4885                	li	a7,1
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 5ac:	4889                	li	a7,2
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5b4:	488d                	li	a7,3
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5bc:	4891                	li	a7,4
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <read>:
.global read
read:
 li a7, SYS_read
 5c4:	4895                	li	a7,5
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <write>:
.global write
write:
 li a7, SYS_write
 5cc:	48c1                	li	a7,16
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <close>:
.global close
close:
 li a7, SYS_close
 5d4:	48d5                	li	a7,21
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 5dc:	4899                	li	a7,6
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5e4:	489d                	li	a7,7
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <open>:
.global open
open:
 li a7, SYS_open
 5ec:	48bd                	li	a7,15
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5f4:	48c5                	li	a7,17
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5fc:	48c9                	li	a7,18
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 604:	48a1                	li	a7,8
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <link>:
.global link
link:
 li a7, SYS_link
 60c:	48cd                	li	a7,19
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 614:	48d1                	li	a7,20
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 61c:	48a5                	li	a7,9
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <dup>:
.global dup
dup:
 li a7, SYS_dup
 624:	48a9                	li	a7,10
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 62c:	48ad                	li	a7,11
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 634:	48b1                	li	a7,12
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 63c:	48b5                	li	a7,13
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 644:	48b9                	li	a7,14
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <trace>:
.global trace
trace:
 li a7, SYS_trace
 64c:	48d9                	li	a7,22
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 654:	48dd                	li	a7,23
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 65c:	1101                	addi	sp,sp,-32
 65e:	ec06                	sd	ra,24(sp)
 660:	e822                	sd	s0,16(sp)
 662:	1000                	addi	s0,sp,32
 664:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 668:	4605                	li	a2,1
 66a:	fef40593          	addi	a1,s0,-17
 66e:	00000097          	auipc	ra,0x0
 672:	f5e080e7          	jalr	-162(ra) # 5cc <write>
}
 676:	60e2                	ld	ra,24(sp)
 678:	6442                	ld	s0,16(sp)
 67a:	6105                	addi	sp,sp,32
 67c:	8082                	ret

000000000000067e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 67e:	7139                	addi	sp,sp,-64
 680:	fc06                	sd	ra,56(sp)
 682:	f822                	sd	s0,48(sp)
 684:	f426                	sd	s1,40(sp)
 686:	f04a                	sd	s2,32(sp)
 688:	ec4e                	sd	s3,24(sp)
 68a:	0080                	addi	s0,sp,64
 68c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 68e:	c299                	beqz	a3,694 <printint+0x16>
 690:	0805c963          	bltz	a1,722 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 694:	2581                	sext.w	a1,a1
  neg = 0;
 696:	4881                	li	a7,0
 698:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 69c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 69e:	2601                	sext.w	a2,a2
 6a0:	00000517          	auipc	a0,0x0
 6a4:	5f050513          	addi	a0,a0,1520 # c90 <digits>
 6a8:	883a                	mv	a6,a4
 6aa:	2705                	addiw	a4,a4,1
 6ac:	02c5f7bb          	remuw	a5,a1,a2
 6b0:	1782                	slli	a5,a5,0x20
 6b2:	9381                	srli	a5,a5,0x20
 6b4:	97aa                	add	a5,a5,a0
 6b6:	0007c783          	lbu	a5,0(a5)
 6ba:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6be:	0005879b          	sext.w	a5,a1
 6c2:	02c5d5bb          	divuw	a1,a1,a2
 6c6:	0685                	addi	a3,a3,1
 6c8:	fec7f0e3          	bgeu	a5,a2,6a8 <printint+0x2a>
  if(neg)
 6cc:	00088c63          	beqz	a7,6e4 <printint+0x66>
    buf[i++] = '-';
 6d0:	fd070793          	addi	a5,a4,-48
 6d4:	00878733          	add	a4,a5,s0
 6d8:	02d00793          	li	a5,45
 6dc:	fef70823          	sb	a5,-16(a4)
 6e0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6e4:	02e05863          	blez	a4,714 <printint+0x96>
 6e8:	fc040793          	addi	a5,s0,-64
 6ec:	00e78933          	add	s2,a5,a4
 6f0:	fff78993          	addi	s3,a5,-1
 6f4:	99ba                	add	s3,s3,a4
 6f6:	377d                	addiw	a4,a4,-1
 6f8:	1702                	slli	a4,a4,0x20
 6fa:	9301                	srli	a4,a4,0x20
 6fc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 700:	fff94583          	lbu	a1,-1(s2)
 704:	8526                	mv	a0,s1
 706:	00000097          	auipc	ra,0x0
 70a:	f56080e7          	jalr	-170(ra) # 65c <putc>
  while(--i >= 0)
 70e:	197d                	addi	s2,s2,-1
 710:	ff3918e3          	bne	s2,s3,700 <printint+0x82>
}
 714:	70e2                	ld	ra,56(sp)
 716:	7442                	ld	s0,48(sp)
 718:	74a2                	ld	s1,40(sp)
 71a:	7902                	ld	s2,32(sp)
 71c:	69e2                	ld	s3,24(sp)
 71e:	6121                	addi	sp,sp,64
 720:	8082                	ret
    x = -xx;
 722:	40b005bb          	negw	a1,a1
    neg = 1;
 726:	4885                	li	a7,1
    x = -xx;
 728:	bf85                	j	698 <printint+0x1a>

000000000000072a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 72a:	7119                	addi	sp,sp,-128
 72c:	fc86                	sd	ra,120(sp)
 72e:	f8a2                	sd	s0,112(sp)
 730:	f4a6                	sd	s1,104(sp)
 732:	f0ca                	sd	s2,96(sp)
 734:	ecce                	sd	s3,88(sp)
 736:	e8d2                	sd	s4,80(sp)
 738:	e4d6                	sd	s5,72(sp)
 73a:	e0da                	sd	s6,64(sp)
 73c:	fc5e                	sd	s7,56(sp)
 73e:	f862                	sd	s8,48(sp)
 740:	f466                	sd	s9,40(sp)
 742:	f06a                	sd	s10,32(sp)
 744:	ec6e                	sd	s11,24(sp)
 746:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 748:	0005c903          	lbu	s2,0(a1)
 74c:	18090f63          	beqz	s2,8ea <vprintf+0x1c0>
 750:	8aaa                	mv	s5,a0
 752:	8b32                	mv	s6,a2
 754:	00158493          	addi	s1,a1,1
  state = 0;
 758:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 75a:	02500a13          	li	s4,37
 75e:	4c55                	li	s8,21
 760:	00000c97          	auipc	s9,0x0
 764:	4d8c8c93          	addi	s9,s9,1240 # c38 <malloc+0x24a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 768:	02800d93          	li	s11,40
  putc(fd, 'x');
 76c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 76e:	00000b97          	auipc	s7,0x0
 772:	522b8b93          	addi	s7,s7,1314 # c90 <digits>
 776:	a839                	j	794 <vprintf+0x6a>
        putc(fd, c);
 778:	85ca                	mv	a1,s2
 77a:	8556                	mv	a0,s5
 77c:	00000097          	auipc	ra,0x0
 780:	ee0080e7          	jalr	-288(ra) # 65c <putc>
 784:	a019                	j	78a <vprintf+0x60>
    } else if(state == '%'){
 786:	01498d63          	beq	s3,s4,7a0 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 78a:	0485                	addi	s1,s1,1
 78c:	fff4c903          	lbu	s2,-1(s1)
 790:	14090d63          	beqz	s2,8ea <vprintf+0x1c0>
    if(state == 0){
 794:	fe0999e3          	bnez	s3,786 <vprintf+0x5c>
      if(c == '%'){
 798:	ff4910e3          	bne	s2,s4,778 <vprintf+0x4e>
        state = '%';
 79c:	89d2                	mv	s3,s4
 79e:	b7f5                	j	78a <vprintf+0x60>
      if(c == 'd'){
 7a0:	11490c63          	beq	s2,s4,8b8 <vprintf+0x18e>
 7a4:	f9d9079b          	addiw	a5,s2,-99
 7a8:	0ff7f793          	zext.b	a5,a5
 7ac:	10fc6e63          	bltu	s8,a5,8c8 <vprintf+0x19e>
 7b0:	f9d9079b          	addiw	a5,s2,-99
 7b4:	0ff7f713          	zext.b	a4,a5
 7b8:	10ec6863          	bltu	s8,a4,8c8 <vprintf+0x19e>
 7bc:	00271793          	slli	a5,a4,0x2
 7c0:	97e6                	add	a5,a5,s9
 7c2:	439c                	lw	a5,0(a5)
 7c4:	97e6                	add	a5,a5,s9
 7c6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7c8:	008b0913          	addi	s2,s6,8
 7cc:	4685                	li	a3,1
 7ce:	4629                	li	a2,10
 7d0:	000b2583          	lw	a1,0(s6)
 7d4:	8556                	mv	a0,s5
 7d6:	00000097          	auipc	ra,0x0
 7da:	ea8080e7          	jalr	-344(ra) # 67e <printint>
 7de:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	b765                	j	78a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e4:	008b0913          	addi	s2,s6,8
 7e8:	4681                	li	a3,0
 7ea:	4629                	li	a2,10
 7ec:	000b2583          	lw	a1,0(s6)
 7f0:	8556                	mv	a0,s5
 7f2:	00000097          	auipc	ra,0x0
 7f6:	e8c080e7          	jalr	-372(ra) # 67e <printint>
 7fa:	8b4a                	mv	s6,s2
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	b771                	j	78a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 800:	008b0913          	addi	s2,s6,8
 804:	4681                	li	a3,0
 806:	866a                	mv	a2,s10
 808:	000b2583          	lw	a1,0(s6)
 80c:	8556                	mv	a0,s5
 80e:	00000097          	auipc	ra,0x0
 812:	e70080e7          	jalr	-400(ra) # 67e <printint>
 816:	8b4a                	mv	s6,s2
      state = 0;
 818:	4981                	li	s3,0
 81a:	bf85                	j	78a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 81c:	008b0793          	addi	a5,s6,8
 820:	f8f43423          	sd	a5,-120(s0)
 824:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 828:	03000593          	li	a1,48
 82c:	8556                	mv	a0,s5
 82e:	00000097          	auipc	ra,0x0
 832:	e2e080e7          	jalr	-466(ra) # 65c <putc>
  putc(fd, 'x');
 836:	07800593          	li	a1,120
 83a:	8556                	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	e20080e7          	jalr	-480(ra) # 65c <putc>
 844:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 846:	03c9d793          	srli	a5,s3,0x3c
 84a:	97de                	add	a5,a5,s7
 84c:	0007c583          	lbu	a1,0(a5)
 850:	8556                	mv	a0,s5
 852:	00000097          	auipc	ra,0x0
 856:	e0a080e7          	jalr	-502(ra) # 65c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 85a:	0992                	slli	s3,s3,0x4
 85c:	397d                	addiw	s2,s2,-1
 85e:	fe0914e3          	bnez	s2,846 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 862:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 866:	4981                	li	s3,0
 868:	b70d                	j	78a <vprintf+0x60>
        s = va_arg(ap, char*);
 86a:	008b0913          	addi	s2,s6,8
 86e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 872:	02098163          	beqz	s3,894 <vprintf+0x16a>
        while(*s != 0){
 876:	0009c583          	lbu	a1,0(s3)
 87a:	c5ad                	beqz	a1,8e4 <vprintf+0x1ba>
          putc(fd, *s);
 87c:	8556                	mv	a0,s5
 87e:	00000097          	auipc	ra,0x0
 882:	dde080e7          	jalr	-546(ra) # 65c <putc>
          s++;
 886:	0985                	addi	s3,s3,1
        while(*s != 0){
 888:	0009c583          	lbu	a1,0(s3)
 88c:	f9e5                	bnez	a1,87c <vprintf+0x152>
        s = va_arg(ap, char*);
 88e:	8b4a                	mv	s6,s2
      state = 0;
 890:	4981                	li	s3,0
 892:	bde5                	j	78a <vprintf+0x60>
          s = "(null)";
 894:	00000997          	auipc	s3,0x0
 898:	39c98993          	addi	s3,s3,924 # c30 <malloc+0x242>
        while(*s != 0){
 89c:	85ee                	mv	a1,s11
 89e:	bff9                	j	87c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 8a0:	008b0913          	addi	s2,s6,8
 8a4:	000b4583          	lbu	a1,0(s6)
 8a8:	8556                	mv	a0,s5
 8aa:	00000097          	auipc	ra,0x0
 8ae:	db2080e7          	jalr	-590(ra) # 65c <putc>
 8b2:	8b4a                	mv	s6,s2
      state = 0;
 8b4:	4981                	li	s3,0
 8b6:	bdd1                	j	78a <vprintf+0x60>
        putc(fd, c);
 8b8:	85d2                	mv	a1,s4
 8ba:	8556                	mv	a0,s5
 8bc:	00000097          	auipc	ra,0x0
 8c0:	da0080e7          	jalr	-608(ra) # 65c <putc>
      state = 0;
 8c4:	4981                	li	s3,0
 8c6:	b5d1                	j	78a <vprintf+0x60>
        putc(fd, '%');
 8c8:	85d2                	mv	a1,s4
 8ca:	8556                	mv	a0,s5
 8cc:	00000097          	auipc	ra,0x0
 8d0:	d90080e7          	jalr	-624(ra) # 65c <putc>
        putc(fd, c);
 8d4:	85ca                	mv	a1,s2
 8d6:	8556                	mv	a0,s5
 8d8:	00000097          	auipc	ra,0x0
 8dc:	d84080e7          	jalr	-636(ra) # 65c <putc>
      state = 0;
 8e0:	4981                	li	s3,0
 8e2:	b565                	j	78a <vprintf+0x60>
        s = va_arg(ap, char*);
 8e4:	8b4a                	mv	s6,s2
      state = 0;
 8e6:	4981                	li	s3,0
 8e8:	b54d                	j	78a <vprintf+0x60>
    }
  }
}
 8ea:	70e6                	ld	ra,120(sp)
 8ec:	7446                	ld	s0,112(sp)
 8ee:	74a6                	ld	s1,104(sp)
 8f0:	7906                	ld	s2,96(sp)
 8f2:	69e6                	ld	s3,88(sp)
 8f4:	6a46                	ld	s4,80(sp)
 8f6:	6aa6                	ld	s5,72(sp)
 8f8:	6b06                	ld	s6,64(sp)
 8fa:	7be2                	ld	s7,56(sp)
 8fc:	7c42                	ld	s8,48(sp)
 8fe:	7ca2                	ld	s9,40(sp)
 900:	7d02                	ld	s10,32(sp)
 902:	6de2                	ld	s11,24(sp)
 904:	6109                	addi	sp,sp,128
 906:	8082                	ret

0000000000000908 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 908:	715d                	addi	sp,sp,-80
 90a:	ec06                	sd	ra,24(sp)
 90c:	e822                	sd	s0,16(sp)
 90e:	1000                	addi	s0,sp,32
 910:	e010                	sd	a2,0(s0)
 912:	e414                	sd	a3,8(s0)
 914:	e818                	sd	a4,16(s0)
 916:	ec1c                	sd	a5,24(s0)
 918:	03043023          	sd	a6,32(s0)
 91c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 920:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 924:	8622                	mv	a2,s0
 926:	00000097          	auipc	ra,0x0
 92a:	e04080e7          	jalr	-508(ra) # 72a <vprintf>
}
 92e:	60e2                	ld	ra,24(sp)
 930:	6442                	ld	s0,16(sp)
 932:	6161                	addi	sp,sp,80
 934:	8082                	ret

0000000000000936 <printf>:

void
printf(const char *fmt, ...)
{
 936:	711d                	addi	sp,sp,-96
 938:	ec06                	sd	ra,24(sp)
 93a:	e822                	sd	s0,16(sp)
 93c:	1000                	addi	s0,sp,32
 93e:	e40c                	sd	a1,8(s0)
 940:	e810                	sd	a2,16(s0)
 942:	ec14                	sd	a3,24(s0)
 944:	f018                	sd	a4,32(s0)
 946:	f41c                	sd	a5,40(s0)
 948:	03043823          	sd	a6,48(s0)
 94c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 950:	00840613          	addi	a2,s0,8
 954:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 958:	85aa                	mv	a1,a0
 95a:	4505                	li	a0,1
 95c:	00000097          	auipc	ra,0x0
 960:	dce080e7          	jalr	-562(ra) # 72a <vprintf>
}
 964:	60e2                	ld	ra,24(sp)
 966:	6442                	ld	s0,16(sp)
 968:	6125                	addi	sp,sp,96
 96a:	8082                	ret

000000000000096c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 96c:	1141                	addi	sp,sp,-16
 96e:	e422                	sd	s0,8(sp)
 970:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 972:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 976:	00000797          	auipc	a5,0x0
 97a:	33a7b783          	ld	a5,826(a5) # cb0 <freep>
 97e:	a02d                	j	9a8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 980:	4618                	lw	a4,8(a2)
 982:	9f2d                	addw	a4,a4,a1
 984:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 988:	6398                	ld	a4,0(a5)
 98a:	6310                	ld	a2,0(a4)
 98c:	a83d                	j	9ca <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 98e:	ff852703          	lw	a4,-8(a0)
 992:	9f31                	addw	a4,a4,a2
 994:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 996:	ff053683          	ld	a3,-16(a0)
 99a:	a091                	j	9de <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99c:	6398                	ld	a4,0(a5)
 99e:	00e7e463          	bltu	a5,a4,9a6 <free+0x3a>
 9a2:	00e6ea63          	bltu	a3,a4,9b6 <free+0x4a>
{
 9a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a8:	fed7fae3          	bgeu	a5,a3,99c <free+0x30>
 9ac:	6398                	ld	a4,0(a5)
 9ae:	00e6e463          	bltu	a3,a4,9b6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b2:	fee7eae3          	bltu	a5,a4,9a6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9b6:	ff852583          	lw	a1,-8(a0)
 9ba:	6390                	ld	a2,0(a5)
 9bc:	02059813          	slli	a6,a1,0x20
 9c0:	01c85713          	srli	a4,a6,0x1c
 9c4:	9736                	add	a4,a4,a3
 9c6:	fae60de3          	beq	a2,a4,980 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ce:	4790                	lw	a2,8(a5)
 9d0:	02061593          	slli	a1,a2,0x20
 9d4:	01c5d713          	srli	a4,a1,0x1c
 9d8:	973e                	add	a4,a4,a5
 9da:	fae68ae3          	beq	a3,a4,98e <free+0x22>
    p->s.ptr = bp->s.ptr;
 9de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9e0:	00000717          	auipc	a4,0x0
 9e4:	2cf73823          	sd	a5,720(a4) # cb0 <freep>
}
 9e8:	6422                	ld	s0,8(sp)
 9ea:	0141                	addi	sp,sp,16
 9ec:	8082                	ret

00000000000009ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ee:	7139                	addi	sp,sp,-64
 9f0:	fc06                	sd	ra,56(sp)
 9f2:	f822                	sd	s0,48(sp)
 9f4:	f426                	sd	s1,40(sp)
 9f6:	f04a                	sd	s2,32(sp)
 9f8:	ec4e                	sd	s3,24(sp)
 9fa:	e852                	sd	s4,16(sp)
 9fc:	e456                	sd	s5,8(sp)
 9fe:	e05a                	sd	s6,0(sp)
 a00:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a02:	02051493          	slli	s1,a0,0x20
 a06:	9081                	srli	s1,s1,0x20
 a08:	04bd                	addi	s1,s1,15
 a0a:	8091                	srli	s1,s1,0x4
 a0c:	0014899b          	addiw	s3,s1,1
 a10:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a12:	00000517          	auipc	a0,0x0
 a16:	29e53503          	ld	a0,670(a0) # cb0 <freep>
 a1a:	c515                	beqz	a0,a46 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a1c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a1e:	4798                	lw	a4,8(a5)
 a20:	02977f63          	bgeu	a4,s1,a5e <malloc+0x70>
 a24:	8a4e                	mv	s4,s3
 a26:	0009871b          	sext.w	a4,s3
 a2a:	6685                	lui	a3,0x1
 a2c:	00d77363          	bgeu	a4,a3,a32 <malloc+0x44>
 a30:	6a05                	lui	s4,0x1
 a32:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a36:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a3a:	00000917          	auipc	s2,0x0
 a3e:	27690913          	addi	s2,s2,630 # cb0 <freep>
  if(p == (char*)-1)
 a42:	5afd                	li	s5,-1
 a44:	a895                	j	ab8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a46:	00000797          	auipc	a5,0x0
 a4a:	27278793          	addi	a5,a5,626 # cb8 <base>
 a4e:	00000717          	auipc	a4,0x0
 a52:	26f73123          	sd	a5,610(a4) # cb0 <freep>
 a56:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a58:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a5c:	b7e1                	j	a24 <malloc+0x36>
      if(p->s.size == nunits)
 a5e:	02e48c63          	beq	s1,a4,a96 <malloc+0xa8>
        p->s.size -= nunits;
 a62:	4137073b          	subw	a4,a4,s3
 a66:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a68:	02071693          	slli	a3,a4,0x20
 a6c:	01c6d713          	srli	a4,a3,0x1c
 a70:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a72:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a76:	00000717          	auipc	a4,0x0
 a7a:	22a73d23          	sd	a0,570(a4) # cb0 <freep>
      return (void*)(p + 1);
 a7e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a82:	70e2                	ld	ra,56(sp)
 a84:	7442                	ld	s0,48(sp)
 a86:	74a2                	ld	s1,40(sp)
 a88:	7902                	ld	s2,32(sp)
 a8a:	69e2                	ld	s3,24(sp)
 a8c:	6a42                	ld	s4,16(sp)
 a8e:	6aa2                	ld	s5,8(sp)
 a90:	6b02                	ld	s6,0(sp)
 a92:	6121                	addi	sp,sp,64
 a94:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a96:	6398                	ld	a4,0(a5)
 a98:	e118                	sd	a4,0(a0)
 a9a:	bff1                	j	a76 <malloc+0x88>
  hp->s.size = nu;
 a9c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 aa0:	0541                	addi	a0,a0,16
 aa2:	00000097          	auipc	ra,0x0
 aa6:	eca080e7          	jalr	-310(ra) # 96c <free>
  return freep;
 aaa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 aae:	d971                	beqz	a0,a82 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ab2:	4798                	lw	a4,8(a5)
 ab4:	fa9775e3          	bgeu	a4,s1,a5e <malloc+0x70>
    if(p == freep)
 ab8:	00093703          	ld	a4,0(s2)
 abc:	853e                	mv	a0,a5
 abe:	fef719e3          	bne	a4,a5,ab0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 ac2:	8552                	mv	a0,s4
 ac4:	00000097          	auipc	ra,0x0
 ac8:	b70080e7          	jalr	-1168(ra) # 634 <sbrk>
  if(p == (char*)-1)
 acc:	fd5518e3          	bne	a0,s5,a9c <malloc+0xae>
        return 0;
 ad0:	4501                	li	a0,0
 ad2:	bf45                	j	a82 <malloc+0x94>
