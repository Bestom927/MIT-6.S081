
user/_kalloctest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <ntas>:
  test2();
  exit(0);
}

int ntas(int print)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
   e:	6585                	lui	a1,0x1
  10:	00001517          	auipc	a0,0x1
  14:	ce850513          	addi	a0,a0,-792 # cf8 <buf>
  18:	00001097          	auipc	ra,0x1
  1c:	a8c080e7          	jalr	-1396(ra) # aa4 <statistics>
  20:	02a05b63          	blez	a0,56 <ntas+0x56>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
  24:	03d00593          	li	a1,61
  28:	00001517          	auipc	a0,0x1
  2c:	cd050513          	addi	a0,a0,-816 # cf8 <buf>
  30:	00000097          	auipc	ra,0x0
  34:	384080e7          	jalr	900(ra) # 3b4 <strchr>
  n = atoi(c+2);
  38:	0509                	addi	a0,a0,2
  3a:	00000097          	auipc	ra,0x0
  3e:	458080e7          	jalr	1112(ra) # 492 <atoi>
  42:	84aa                	mv	s1,a0
  if(print)
  44:	02091363          	bnez	s2,6a <ntas+0x6a>
    printf("%s", buf);
  return n;
}
  48:	8526                	mv	a0,s1
  4a:	60e2                	ld	ra,24(sp)
  4c:	6442                	ld	s0,16(sp)
  4e:	64a2                	ld	s1,8(sp)
  50:	6902                	ld	s2,0(sp)
  52:	6105                	addi	sp,sp,32
  54:	8082                	ret
    fprintf(2, "ntas: no stats\n");
  56:	00001597          	auipc	a1,0x1
  5a:	ada58593          	addi	a1,a1,-1318 # b30 <statistics+0x8c>
  5e:	4509                	li	a0,2
  60:	00001097          	auipc	ra,0x1
  64:	878080e7          	jalr	-1928(ra) # 8d8 <fprintf>
  68:	bf75                	j	24 <ntas+0x24>
    printf("%s", buf);
  6a:	00001597          	auipc	a1,0x1
  6e:	c8e58593          	addi	a1,a1,-882 # cf8 <buf>
  72:	00001517          	auipc	a0,0x1
  76:	ace50513          	addi	a0,a0,-1330 # b40 <statistics+0x9c>
  7a:	00001097          	auipc	ra,0x1
  7e:	88c080e7          	jalr	-1908(ra) # 906 <printf>
  82:	b7d9                	j	48 <ntas+0x48>

0000000000000084 <test1>:

void test1(void)
{
  84:	7179                	addi	sp,sp,-48
  86:	f406                	sd	ra,40(sp)
  88:	f022                	sd	s0,32(sp)
  8a:	ec26                	sd	s1,24(sp)
  8c:	e84a                	sd	s2,16(sp)
  8e:	e44e                	sd	s3,8(sp)
  90:	1800                	addi	s0,sp,48
  void *a, *a1;
  int n, m;
  printf("start test1\n");  
  92:	00001517          	auipc	a0,0x1
  96:	ab650513          	addi	a0,a0,-1354 # b48 <statistics+0xa4>
  9a:	00001097          	auipc	ra,0x1
  9e:	86c080e7          	jalr	-1940(ra) # 906 <printf>
  m = ntas(0);
  a2:	4501                	li	a0,0
  a4:	00000097          	auipc	ra,0x0
  a8:	f5c080e7          	jalr	-164(ra) # 0 <ntas>
  ac:	84aa                	mv	s1,a0
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  ae:	00000097          	auipc	ra,0x0
  b2:	4d6080e7          	jalr	1238(ra) # 584 <fork>
    if(pid < 0){
  b6:	06054463          	bltz	a0,11e <test1+0x9a>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  ba:	cd3d                	beqz	a0,138 <test1+0xb4>
    int pid = fork();
  bc:	00000097          	auipc	ra,0x0
  c0:	4c8080e7          	jalr	1224(ra) # 584 <fork>
    if(pid < 0){
  c4:	04054d63          	bltz	a0,11e <test1+0x9a>
    if(pid == 0){
  c8:	c925                	beqz	a0,138 <test1+0xb4>
      exit(-1);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
  ca:	4501                	li	a0,0
  cc:	00000097          	auipc	ra,0x0
  d0:	4c8080e7          	jalr	1224(ra) # 594 <wait>
  d4:	4501                	li	a0,0
  d6:	00000097          	auipc	ra,0x0
  da:	4be080e7          	jalr	1214(ra) # 594 <wait>
  }
  printf("test1 results:\n");
  de:	00001517          	auipc	a0,0x1
  e2:	a9a50513          	addi	a0,a0,-1382 # b78 <statistics+0xd4>
  e6:	00001097          	auipc	ra,0x1
  ea:	820080e7          	jalr	-2016(ra) # 906 <printf>
  n = ntas(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <ntas>
  if(n-m < 10) 
  f8:	9d05                	subw	a0,a0,s1
  fa:	47a5                	li	a5,9
  fc:	08a7c863          	blt	a5,a0,18c <test1+0x108>
    printf("test1 OK\n");
 100:	00001517          	auipc	a0,0x1
 104:	a8850513          	addi	a0,a0,-1400 # b88 <statistics+0xe4>
 108:	00000097          	auipc	ra,0x0
 10c:	7fe080e7          	jalr	2046(ra) # 906 <printf>
  else
    printf("test1 FAIL\n");
}
 110:	70a2                	ld	ra,40(sp)
 112:	7402                	ld	s0,32(sp)
 114:	64e2                	ld	s1,24(sp)
 116:	6942                	ld	s2,16(sp)
 118:	69a2                	ld	s3,8(sp)
 11a:	6145                	addi	sp,sp,48
 11c:	8082                	ret
      printf("fork failed");
 11e:	00001517          	auipc	a0,0x1
 122:	a3a50513          	addi	a0,a0,-1478 # b58 <statistics+0xb4>
 126:	00000097          	auipc	ra,0x0
 12a:	7e0080e7          	jalr	2016(ra) # 906 <printf>
      exit(-1);
 12e:	557d                	li	a0,-1
 130:	00000097          	auipc	ra,0x0
 134:	45c080e7          	jalr	1116(ra) # 58c <exit>
{
 138:	6961                	lui	s2,0x18
 13a:	6a090913          	addi	s2,s2,1696 # 186a0 <__BSS_END__+0x16998>
        *(int *)(a+4) = 1;
 13e:	4985                	li	s3,1
        a = sbrk(4096);
 140:	6505                	lui	a0,0x1
 142:	00000097          	auipc	ra,0x0
 146:	4d2080e7          	jalr	1234(ra) # 614 <sbrk>
 14a:	84aa                	mv	s1,a0
        *(int *)(a+4) = 1;
 14c:	01352223          	sw	s3,4(a0) # 1004 <buf+0x30c>
        a1 = sbrk(-4096);
 150:	757d                	lui	a0,0xfffff
 152:	00000097          	auipc	ra,0x0
 156:	4c2080e7          	jalr	1218(ra) # 614 <sbrk>
        if (a1 != a + 4096) {
 15a:	6785                	lui	a5,0x1
 15c:	94be                	add	s1,s1,a5
 15e:	00951a63          	bne	a0,s1,172 <test1+0xee>
      for(i = 0; i < N; i++) {
 162:	397d                	addiw	s2,s2,-1
 164:	fc091ee3          	bnez	s2,140 <test1+0xbc>
      exit(-1);
 168:	557d                	li	a0,-1
 16a:	00000097          	auipc	ra,0x0
 16e:	422080e7          	jalr	1058(ra) # 58c <exit>
          printf("wrong sbrk\n");
 172:	00001517          	auipc	a0,0x1
 176:	9f650513          	addi	a0,a0,-1546 # b68 <statistics+0xc4>
 17a:	00000097          	auipc	ra,0x0
 17e:	78c080e7          	jalr	1932(ra) # 906 <printf>
          exit(-1);
 182:	557d                	li	a0,-1
 184:	00000097          	auipc	ra,0x0
 188:	408080e7          	jalr	1032(ra) # 58c <exit>
    printf("test1 FAIL\n");
 18c:	00001517          	auipc	a0,0x1
 190:	a0c50513          	addi	a0,a0,-1524 # b98 <statistics+0xf4>
 194:	00000097          	auipc	ra,0x0
 198:	772080e7          	jalr	1906(ra) # 906 <printf>
}
 19c:	bf95                	j	110 <test1+0x8c>

000000000000019e <countfree>:
//
// countfree() from usertests.c
//
int
countfree()
{
 19e:	7179                	addi	sp,sp,-48
 1a0:	f406                	sd	ra,40(sp)
 1a2:	f022                	sd	s0,32(sp)
 1a4:	ec26                	sd	s1,24(sp)
 1a6:	e84a                	sd	s2,16(sp)
 1a8:	e44e                	sd	s3,8(sp)
 1aa:	e052                	sd	s4,0(sp)
 1ac:	1800                	addi	s0,sp,48
  uint64 sz0 = (uint64)sbrk(0);
 1ae:	4501                	li	a0,0
 1b0:	00000097          	auipc	ra,0x0
 1b4:	464080e7          	jalr	1124(ra) # 614 <sbrk>
 1b8:	8a2a                	mv	s4,a0
  int n = 0;
 1ba:	4481                	li	s1,0

  while(1){
    uint64 a = (uint64) sbrk(4096);
    if(a == 0xffffffffffffffff){
 1bc:	597d                	li	s2,-1
      break;
    }
    // modify the memory to make sure it's really allocated.
    *(char *)(a + 4096 - 1) = 1;
 1be:	4985                	li	s3,1
 1c0:	a031                	j	1cc <countfree+0x2e>
 1c2:	6785                	lui	a5,0x1
 1c4:	97aa                	add	a5,a5,a0
 1c6:	ff378fa3          	sb	s3,-1(a5) # fff <buf+0x307>
    n += 1;
 1ca:	2485                	addiw	s1,s1,1
    uint64 a = (uint64) sbrk(4096);
 1cc:	6505                	lui	a0,0x1
 1ce:	00000097          	auipc	ra,0x0
 1d2:	446080e7          	jalr	1094(ra) # 614 <sbrk>
    if(a == 0xffffffffffffffff){
 1d6:	ff2516e3          	bne	a0,s2,1c2 <countfree+0x24>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
 1da:	4501                	li	a0,0
 1dc:	00000097          	auipc	ra,0x0
 1e0:	438080e7          	jalr	1080(ra) # 614 <sbrk>
 1e4:	40aa053b          	subw	a0,s4,a0
 1e8:	00000097          	auipc	ra,0x0
 1ec:	42c080e7          	jalr	1068(ra) # 614 <sbrk>
  return n;
}
 1f0:	8526                	mv	a0,s1
 1f2:	70a2                	ld	ra,40(sp)
 1f4:	7402                	ld	s0,32(sp)
 1f6:	64e2                	ld	s1,24(sp)
 1f8:	6942                	ld	s2,16(sp)
 1fa:	69a2                	ld	s3,8(sp)
 1fc:	6a02                	ld	s4,0(sp)
 1fe:	6145                	addi	sp,sp,48
 200:	8082                	ret

0000000000000202 <test2>:

void test2() {
 202:	715d                	addi	sp,sp,-80
 204:	e486                	sd	ra,72(sp)
 206:	e0a2                	sd	s0,64(sp)
 208:	fc26                	sd	s1,56(sp)
 20a:	f84a                	sd	s2,48(sp)
 20c:	f44e                	sd	s3,40(sp)
 20e:	f052                	sd	s4,32(sp)
 210:	ec56                	sd	s5,24(sp)
 212:	e85a                	sd	s6,16(sp)
 214:	e45e                	sd	s7,8(sp)
 216:	e062                	sd	s8,0(sp)
 218:	0880                	addi	s0,sp,80
  int free0 = countfree();
 21a:	00000097          	auipc	ra,0x0
 21e:	f84080e7          	jalr	-124(ra) # 19e <countfree>
 222:	8a2a                	mv	s4,a0
  int free1;
  int n = (PHYSTOP-KERNBASE)/PGSIZE;
  printf("start test2\n");  
 224:	00001517          	auipc	a0,0x1
 228:	98450513          	addi	a0,a0,-1660 # ba8 <statistics+0x104>
 22c:	00000097          	auipc	ra,0x0
 230:	6da080e7          	jalr	1754(ra) # 906 <printf>
  printf("total free number of pages: %d (out of %d)\n", free0, n);
 234:	6621                	lui	a2,0x8
 236:	85d2                	mv	a1,s4
 238:	00001517          	auipc	a0,0x1
 23c:	98050513          	addi	a0,a0,-1664 # bb8 <statistics+0x114>
 240:	00000097          	auipc	ra,0x0
 244:	6c6080e7          	jalr	1734(ra) # 906 <printf>
  if(n - free0 > 1000) {
 248:	67a1                	lui	a5,0x8
 24a:	414787bb          	subw	a5,a5,s4
 24e:	3e800713          	li	a4,1000
 252:	02f74163          	blt	a4,a5,274 <test2+0x72>
    printf("test2 FAILED: cannot allocate enough memory");
    exit(-1);
  }
  for (int i = 0; i < 50; i++) {
    free1 = countfree();
 256:	00000097          	auipc	ra,0x0
 25a:	f48080e7          	jalr	-184(ra) # 19e <countfree>
 25e:	892a                	mv	s2,a0
  for (int i = 0; i < 50; i++) {
 260:	4981                	li	s3,0
 262:	03200a93          	li	s5,50
    if(i % 10 == 9)
 266:	4ba9                	li	s7,10
 268:	4b25                	li	s6,9
      printf(".");
 26a:	00001c17          	auipc	s8,0x1
 26e:	9aec0c13          	addi	s8,s8,-1618 # c18 <statistics+0x174>
 272:	a01d                	j	298 <test2+0x96>
    printf("test2 FAILED: cannot allocate enough memory");
 274:	00001517          	auipc	a0,0x1
 278:	97450513          	addi	a0,a0,-1676 # be8 <statistics+0x144>
 27c:	00000097          	auipc	ra,0x0
 280:	68a080e7          	jalr	1674(ra) # 906 <printf>
    exit(-1);
 284:	557d                	li	a0,-1
 286:	00000097          	auipc	ra,0x0
 28a:	306080e7          	jalr	774(ra) # 58c <exit>
      printf(".");
 28e:	8562                	mv	a0,s8
 290:	00000097          	auipc	ra,0x0
 294:	676080e7          	jalr	1654(ra) # 906 <printf>
    if(free1 != free0) {
 298:	032a1263          	bne	s4,s2,2bc <test2+0xba>
  for (int i = 0; i < 50; i++) {
 29c:	0019849b          	addiw	s1,s3,1
 2a0:	0004899b          	sext.w	s3,s1
 2a4:	03598963          	beq	s3,s5,2d6 <test2+0xd4>
    free1 = countfree();
 2a8:	00000097          	auipc	ra,0x0
 2ac:	ef6080e7          	jalr	-266(ra) # 19e <countfree>
 2b0:	892a                	mv	s2,a0
    if(i % 10 == 9)
 2b2:	0374e4bb          	remw	s1,s1,s7
 2b6:	ff6491e3          	bne	s1,s6,298 <test2+0x96>
 2ba:	bfd1                	j	28e <test2+0x8c>
      printf("test2 FAIL: losing pages\n");
 2bc:	00001517          	auipc	a0,0x1
 2c0:	96450513          	addi	a0,a0,-1692 # c20 <statistics+0x17c>
 2c4:	00000097          	auipc	ra,0x0
 2c8:	642080e7          	jalr	1602(ra) # 906 <printf>
      exit(-1);
 2cc:	557d                	li	a0,-1
 2ce:	00000097          	auipc	ra,0x0
 2d2:	2be080e7          	jalr	702(ra) # 58c <exit>
    }
  }
  printf("\ntest2 OK\n");  
 2d6:	00001517          	auipc	a0,0x1
 2da:	96a50513          	addi	a0,a0,-1686 # c40 <statistics+0x19c>
 2de:	00000097          	auipc	ra,0x0
 2e2:	628080e7          	jalr	1576(ra) # 906 <printf>
}
 2e6:	60a6                	ld	ra,72(sp)
 2e8:	6406                	ld	s0,64(sp)
 2ea:	74e2                	ld	s1,56(sp)
 2ec:	7942                	ld	s2,48(sp)
 2ee:	79a2                	ld	s3,40(sp)
 2f0:	7a02                	ld	s4,32(sp)
 2f2:	6ae2                	ld	s5,24(sp)
 2f4:	6b42                	ld	s6,16(sp)
 2f6:	6ba2                	ld	s7,8(sp)
 2f8:	6c02                	ld	s8,0(sp)
 2fa:	6161                	addi	sp,sp,80
 2fc:	8082                	ret

00000000000002fe <main>:
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  test1();
 306:	00000097          	auipc	ra,0x0
 30a:	d7e080e7          	jalr	-642(ra) # 84 <test1>
  test2();
 30e:	00000097          	auipc	ra,0x0
 312:	ef4080e7          	jalr	-268(ra) # 202 <test2>
  exit(0);
 316:	4501                	li	a0,0
 318:	00000097          	auipc	ra,0x0
 31c:	274080e7          	jalr	628(ra) # 58c <exit>

0000000000000320 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 326:	87aa                	mv	a5,a0
 328:	0585                	addi	a1,a1,1
 32a:	0785                	addi	a5,a5,1 # 8001 <__BSS_END__+0x62f9>
 32c:	fff5c703          	lbu	a4,-1(a1)
 330:	fee78fa3          	sb	a4,-1(a5)
 334:	fb75                	bnez	a4,328 <strcpy+0x8>
    ;
  return os;
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret

000000000000033c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e422                	sd	s0,8(sp)
 340:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 342:	00054783          	lbu	a5,0(a0)
 346:	cb91                	beqz	a5,35a <strcmp+0x1e>
 348:	0005c703          	lbu	a4,0(a1)
 34c:	00f71763          	bne	a4,a5,35a <strcmp+0x1e>
    p++, q++;
 350:	0505                	addi	a0,a0,1
 352:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 354:	00054783          	lbu	a5,0(a0)
 358:	fbe5                	bnez	a5,348 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 35a:	0005c503          	lbu	a0,0(a1)
}
 35e:	40a7853b          	subw	a0,a5,a0
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret

0000000000000368 <strlen>:

uint
strlen(const char *s)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 36e:	00054783          	lbu	a5,0(a0)
 372:	cf91                	beqz	a5,38e <strlen+0x26>
 374:	0505                	addi	a0,a0,1
 376:	87aa                	mv	a5,a0
 378:	4685                	li	a3,1
 37a:	9e89                	subw	a3,a3,a0
 37c:	00f6853b          	addw	a0,a3,a5
 380:	0785                	addi	a5,a5,1
 382:	fff7c703          	lbu	a4,-1(a5)
 386:	fb7d                	bnez	a4,37c <strlen+0x14>
    ;
  return n;
}
 388:	6422                	ld	s0,8(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret
  for(n = 0; s[n]; n++)
 38e:	4501                	li	a0,0
 390:	bfe5                	j	388 <strlen+0x20>

0000000000000392 <memset>:

void*
memset(void *dst, int c, uint n)
{
 392:	1141                	addi	sp,sp,-16
 394:	e422                	sd	s0,8(sp)
 396:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 398:	ca19                	beqz	a2,3ae <memset+0x1c>
 39a:	87aa                	mv	a5,a0
 39c:	1602                	slli	a2,a2,0x20
 39e:	9201                	srli	a2,a2,0x20
 3a0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3a4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3a8:	0785                	addi	a5,a5,1
 3aa:	fee79de3          	bne	a5,a4,3a4 <memset+0x12>
  }
  return dst;
}
 3ae:	6422                	ld	s0,8(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret

00000000000003b4 <strchr>:

char*
strchr(const char *s, char c)
{
 3b4:	1141                	addi	sp,sp,-16
 3b6:	e422                	sd	s0,8(sp)
 3b8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3ba:	00054783          	lbu	a5,0(a0)
 3be:	cb99                	beqz	a5,3d4 <strchr+0x20>
    if(*s == c)
 3c0:	00f58763          	beq	a1,a5,3ce <strchr+0x1a>
  for(; *s; s++)
 3c4:	0505                	addi	a0,a0,1
 3c6:	00054783          	lbu	a5,0(a0)
 3ca:	fbfd                	bnez	a5,3c0 <strchr+0xc>
      return (char*)s;
  return 0;
 3cc:	4501                	li	a0,0
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret
  return 0;
 3d4:	4501                	li	a0,0
 3d6:	bfe5                	j	3ce <strchr+0x1a>

00000000000003d8 <gets>:

char*
gets(char *buf, int max)
{
 3d8:	711d                	addi	sp,sp,-96
 3da:	ec86                	sd	ra,88(sp)
 3dc:	e8a2                	sd	s0,80(sp)
 3de:	e4a6                	sd	s1,72(sp)
 3e0:	e0ca                	sd	s2,64(sp)
 3e2:	fc4e                	sd	s3,56(sp)
 3e4:	f852                	sd	s4,48(sp)
 3e6:	f456                	sd	s5,40(sp)
 3e8:	f05a                	sd	s6,32(sp)
 3ea:	ec5e                	sd	s7,24(sp)
 3ec:	1080                	addi	s0,sp,96
 3ee:	8baa                	mv	s7,a0
 3f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f2:	892a                	mv	s2,a0
 3f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3f6:	4aa9                	li	s5,10
 3f8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3fa:	89a6                	mv	s3,s1
 3fc:	2485                	addiw	s1,s1,1
 3fe:	0344d863          	bge	s1,s4,42e <gets+0x56>
    cc = read(0, &c, 1);
 402:	4605                	li	a2,1
 404:	faf40593          	addi	a1,s0,-81
 408:	4501                	li	a0,0
 40a:	00000097          	auipc	ra,0x0
 40e:	19a080e7          	jalr	410(ra) # 5a4 <read>
    if(cc < 1)
 412:	00a05e63          	blez	a0,42e <gets+0x56>
    buf[i++] = c;
 416:	faf44783          	lbu	a5,-81(s0)
 41a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 41e:	01578763          	beq	a5,s5,42c <gets+0x54>
 422:	0905                	addi	s2,s2,1
 424:	fd679be3          	bne	a5,s6,3fa <gets+0x22>
  for(i=0; i+1 < max; ){
 428:	89a6                	mv	s3,s1
 42a:	a011                	j	42e <gets+0x56>
 42c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 42e:	99de                	add	s3,s3,s7
 430:	00098023          	sb	zero,0(s3)
  return buf;
}
 434:	855e                	mv	a0,s7
 436:	60e6                	ld	ra,88(sp)
 438:	6446                	ld	s0,80(sp)
 43a:	64a6                	ld	s1,72(sp)
 43c:	6906                	ld	s2,64(sp)
 43e:	79e2                	ld	s3,56(sp)
 440:	7a42                	ld	s4,48(sp)
 442:	7aa2                	ld	s5,40(sp)
 444:	7b02                	ld	s6,32(sp)
 446:	6be2                	ld	s7,24(sp)
 448:	6125                	addi	sp,sp,96
 44a:	8082                	ret

000000000000044c <stat>:

int
stat(const char *n, struct stat *st)
{
 44c:	1101                	addi	sp,sp,-32
 44e:	ec06                	sd	ra,24(sp)
 450:	e822                	sd	s0,16(sp)
 452:	e426                	sd	s1,8(sp)
 454:	e04a                	sd	s2,0(sp)
 456:	1000                	addi	s0,sp,32
 458:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 45a:	4581                	li	a1,0
 45c:	00000097          	auipc	ra,0x0
 460:	170080e7          	jalr	368(ra) # 5cc <open>
  if(fd < 0)
 464:	02054563          	bltz	a0,48e <stat+0x42>
 468:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 46a:	85ca                	mv	a1,s2
 46c:	00000097          	auipc	ra,0x0
 470:	178080e7          	jalr	376(ra) # 5e4 <fstat>
 474:	892a                	mv	s2,a0
  close(fd);
 476:	8526                	mv	a0,s1
 478:	00000097          	auipc	ra,0x0
 47c:	13c080e7          	jalr	316(ra) # 5b4 <close>
  return r;
}
 480:	854a                	mv	a0,s2
 482:	60e2                	ld	ra,24(sp)
 484:	6442                	ld	s0,16(sp)
 486:	64a2                	ld	s1,8(sp)
 488:	6902                	ld	s2,0(sp)
 48a:	6105                	addi	sp,sp,32
 48c:	8082                	ret
    return -1;
 48e:	597d                	li	s2,-1
 490:	bfc5                	j	480 <stat+0x34>

0000000000000492 <atoi>:

int
atoi(const char *s)
{
 492:	1141                	addi	sp,sp,-16
 494:	e422                	sd	s0,8(sp)
 496:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 498:	00054683          	lbu	a3,0(a0)
 49c:	fd06879b          	addiw	a5,a3,-48
 4a0:	0ff7f793          	zext.b	a5,a5
 4a4:	4625                	li	a2,9
 4a6:	02f66863          	bltu	a2,a5,4d6 <atoi+0x44>
 4aa:	872a                	mv	a4,a0
  n = 0;
 4ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4ae:	0705                	addi	a4,a4,1
 4b0:	0025179b          	slliw	a5,a0,0x2
 4b4:	9fa9                	addw	a5,a5,a0
 4b6:	0017979b          	slliw	a5,a5,0x1
 4ba:	9fb5                	addw	a5,a5,a3
 4bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4c0:	00074683          	lbu	a3,0(a4)
 4c4:	fd06879b          	addiw	a5,a3,-48
 4c8:	0ff7f793          	zext.b	a5,a5
 4cc:	fef671e3          	bgeu	a2,a5,4ae <atoi+0x1c>
  return n;
}
 4d0:	6422                	ld	s0,8(sp)
 4d2:	0141                	addi	sp,sp,16
 4d4:	8082                	ret
  n = 0;
 4d6:	4501                	li	a0,0
 4d8:	bfe5                	j	4d0 <atoi+0x3e>

00000000000004da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4da:	1141                	addi	sp,sp,-16
 4dc:	e422                	sd	s0,8(sp)
 4de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4e0:	02b57463          	bgeu	a0,a1,508 <memmove+0x2e>
    while(n-- > 0)
 4e4:	00c05f63          	blez	a2,502 <memmove+0x28>
 4e8:	1602                	slli	a2,a2,0x20
 4ea:	9201                	srli	a2,a2,0x20
 4ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 4f2:	0585                	addi	a1,a1,1
 4f4:	0705                	addi	a4,a4,1
 4f6:	fff5c683          	lbu	a3,-1(a1)
 4fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4fe:	fee79ae3          	bne	a5,a4,4f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 502:	6422                	ld	s0,8(sp)
 504:	0141                	addi	sp,sp,16
 506:	8082                	ret
    dst += n;
 508:	00c50733          	add	a4,a0,a2
    src += n;
 50c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 50e:	fec05ae3          	blez	a2,502 <memmove+0x28>
 512:	fff6079b          	addiw	a5,a2,-1 # 7fff <__BSS_END__+0x62f7>
 516:	1782                	slli	a5,a5,0x20
 518:	9381                	srli	a5,a5,0x20
 51a:	fff7c793          	not	a5,a5
 51e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 520:	15fd                	addi	a1,a1,-1
 522:	177d                	addi	a4,a4,-1
 524:	0005c683          	lbu	a3,0(a1)
 528:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 52c:	fee79ae3          	bne	a5,a4,520 <memmove+0x46>
 530:	bfc9                	j	502 <memmove+0x28>

0000000000000532 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 532:	1141                	addi	sp,sp,-16
 534:	e422                	sd	s0,8(sp)
 536:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 538:	ca05                	beqz	a2,568 <memcmp+0x36>
 53a:	fff6069b          	addiw	a3,a2,-1
 53e:	1682                	slli	a3,a3,0x20
 540:	9281                	srli	a3,a3,0x20
 542:	0685                	addi	a3,a3,1
 544:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 546:	00054783          	lbu	a5,0(a0)
 54a:	0005c703          	lbu	a4,0(a1)
 54e:	00e79863          	bne	a5,a4,55e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 552:	0505                	addi	a0,a0,1
    p2++;
 554:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 556:	fed518e3          	bne	a0,a3,546 <memcmp+0x14>
  }
  return 0;
 55a:	4501                	li	a0,0
 55c:	a019                	j	562 <memcmp+0x30>
      return *p1 - *p2;
 55e:	40e7853b          	subw	a0,a5,a4
}
 562:	6422                	ld	s0,8(sp)
 564:	0141                	addi	sp,sp,16
 566:	8082                	ret
  return 0;
 568:	4501                	li	a0,0
 56a:	bfe5                	j	562 <memcmp+0x30>

000000000000056c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 56c:	1141                	addi	sp,sp,-16
 56e:	e406                	sd	ra,8(sp)
 570:	e022                	sd	s0,0(sp)
 572:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 574:	00000097          	auipc	ra,0x0
 578:	f66080e7          	jalr	-154(ra) # 4da <memmove>
}
 57c:	60a2                	ld	ra,8(sp)
 57e:	6402                	ld	s0,0(sp)
 580:	0141                	addi	sp,sp,16
 582:	8082                	ret

0000000000000584 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 584:	4885                	li	a7,1
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <exit>:
.global exit
exit:
 li a7, SYS_exit
 58c:	4889                	li	a7,2
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <wait>:
.global wait
wait:
 li a7, SYS_wait
 594:	488d                	li	a7,3
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 59c:	4891                	li	a7,4
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <read>:
.global read
read:
 li a7, SYS_read
 5a4:	4895                	li	a7,5
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <write>:
.global write
write:
 li a7, SYS_write
 5ac:	48c1                	li	a7,16
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <close>:
.global close
close:
 li a7, SYS_close
 5b4:	48d5                	li	a7,21
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <kill>:
.global kill
kill:
 li a7, SYS_kill
 5bc:	4899                	li	a7,6
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5c4:	489d                	li	a7,7
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <open>:
.global open
open:
 li a7, SYS_open
 5cc:	48bd                	li	a7,15
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5d4:	48c5                	li	a7,17
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5dc:	48c9                	li	a7,18
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5e4:	48a1                	li	a7,8
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <link>:
.global link
link:
 li a7, SYS_link
 5ec:	48cd                	li	a7,19
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5f4:	48d1                	li	a7,20
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5fc:	48a5                	li	a7,9
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <dup>:
.global dup
dup:
 li a7, SYS_dup
 604:	48a9                	li	a7,10
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 60c:	48ad                	li	a7,11
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 614:	48b1                	li	a7,12
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 61c:	48b5                	li	a7,13
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 624:	48b9                	li	a7,14
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 62c:	1101                	addi	sp,sp,-32
 62e:	ec06                	sd	ra,24(sp)
 630:	e822                	sd	s0,16(sp)
 632:	1000                	addi	s0,sp,32
 634:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 638:	4605                	li	a2,1
 63a:	fef40593          	addi	a1,s0,-17
 63e:	00000097          	auipc	ra,0x0
 642:	f6e080e7          	jalr	-146(ra) # 5ac <write>
}
 646:	60e2                	ld	ra,24(sp)
 648:	6442                	ld	s0,16(sp)
 64a:	6105                	addi	sp,sp,32
 64c:	8082                	ret

000000000000064e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 64e:	7139                	addi	sp,sp,-64
 650:	fc06                	sd	ra,56(sp)
 652:	f822                	sd	s0,48(sp)
 654:	f426                	sd	s1,40(sp)
 656:	f04a                	sd	s2,32(sp)
 658:	ec4e                	sd	s3,24(sp)
 65a:	0080                	addi	s0,sp,64
 65c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 65e:	c299                	beqz	a3,664 <printint+0x16>
 660:	0805c963          	bltz	a1,6f2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 664:	2581                	sext.w	a1,a1
  neg = 0;
 666:	4881                	li	a7,0
 668:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 66c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 66e:	2601                	sext.w	a2,a2
 670:	00000517          	auipc	a0,0x0
 674:	64050513          	addi	a0,a0,1600 # cb0 <digits>
 678:	883a                	mv	a6,a4
 67a:	2705                	addiw	a4,a4,1
 67c:	02c5f7bb          	remuw	a5,a1,a2
 680:	1782                	slli	a5,a5,0x20
 682:	9381                	srli	a5,a5,0x20
 684:	97aa                	add	a5,a5,a0
 686:	0007c783          	lbu	a5,0(a5)
 68a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 68e:	0005879b          	sext.w	a5,a1
 692:	02c5d5bb          	divuw	a1,a1,a2
 696:	0685                	addi	a3,a3,1
 698:	fec7f0e3          	bgeu	a5,a2,678 <printint+0x2a>
  if(neg)
 69c:	00088c63          	beqz	a7,6b4 <printint+0x66>
    buf[i++] = '-';
 6a0:	fd070793          	addi	a5,a4,-48
 6a4:	00878733          	add	a4,a5,s0
 6a8:	02d00793          	li	a5,45
 6ac:	fef70823          	sb	a5,-16(a4)
 6b0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6b4:	02e05863          	blez	a4,6e4 <printint+0x96>
 6b8:	fc040793          	addi	a5,s0,-64
 6bc:	00e78933          	add	s2,a5,a4
 6c0:	fff78993          	addi	s3,a5,-1
 6c4:	99ba                	add	s3,s3,a4
 6c6:	377d                	addiw	a4,a4,-1
 6c8:	1702                	slli	a4,a4,0x20
 6ca:	9301                	srli	a4,a4,0x20
 6cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6d0:	fff94583          	lbu	a1,-1(s2)
 6d4:	8526                	mv	a0,s1
 6d6:	00000097          	auipc	ra,0x0
 6da:	f56080e7          	jalr	-170(ra) # 62c <putc>
  while(--i >= 0)
 6de:	197d                	addi	s2,s2,-1
 6e0:	ff3918e3          	bne	s2,s3,6d0 <printint+0x82>
}
 6e4:	70e2                	ld	ra,56(sp)
 6e6:	7442                	ld	s0,48(sp)
 6e8:	74a2                	ld	s1,40(sp)
 6ea:	7902                	ld	s2,32(sp)
 6ec:	69e2                	ld	s3,24(sp)
 6ee:	6121                	addi	sp,sp,64
 6f0:	8082                	ret
    x = -xx;
 6f2:	40b005bb          	negw	a1,a1
    neg = 1;
 6f6:	4885                	li	a7,1
    x = -xx;
 6f8:	bf85                	j	668 <printint+0x1a>

00000000000006fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6fa:	7119                	addi	sp,sp,-128
 6fc:	fc86                	sd	ra,120(sp)
 6fe:	f8a2                	sd	s0,112(sp)
 700:	f4a6                	sd	s1,104(sp)
 702:	f0ca                	sd	s2,96(sp)
 704:	ecce                	sd	s3,88(sp)
 706:	e8d2                	sd	s4,80(sp)
 708:	e4d6                	sd	s5,72(sp)
 70a:	e0da                	sd	s6,64(sp)
 70c:	fc5e                	sd	s7,56(sp)
 70e:	f862                	sd	s8,48(sp)
 710:	f466                	sd	s9,40(sp)
 712:	f06a                	sd	s10,32(sp)
 714:	ec6e                	sd	s11,24(sp)
 716:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 718:	0005c903          	lbu	s2,0(a1)
 71c:	18090f63          	beqz	s2,8ba <vprintf+0x1c0>
 720:	8aaa                	mv	s5,a0
 722:	8b32                	mv	s6,a2
 724:	00158493          	addi	s1,a1,1
  state = 0;
 728:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 72a:	02500a13          	li	s4,37
 72e:	4c55                	li	s8,21
 730:	00000c97          	auipc	s9,0x0
 734:	528c8c93          	addi	s9,s9,1320 # c58 <statistics+0x1b4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 738:	02800d93          	li	s11,40
  putc(fd, 'x');
 73c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73e:	00000b97          	auipc	s7,0x0
 742:	572b8b93          	addi	s7,s7,1394 # cb0 <digits>
 746:	a839                	j	764 <vprintf+0x6a>
        putc(fd, c);
 748:	85ca                	mv	a1,s2
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	ee0080e7          	jalr	-288(ra) # 62c <putc>
 754:	a019                	j	75a <vprintf+0x60>
    } else if(state == '%'){
 756:	01498d63          	beq	s3,s4,770 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 75a:	0485                	addi	s1,s1,1
 75c:	fff4c903          	lbu	s2,-1(s1)
 760:	14090d63          	beqz	s2,8ba <vprintf+0x1c0>
    if(state == 0){
 764:	fe0999e3          	bnez	s3,756 <vprintf+0x5c>
      if(c == '%'){
 768:	ff4910e3          	bne	s2,s4,748 <vprintf+0x4e>
        state = '%';
 76c:	89d2                	mv	s3,s4
 76e:	b7f5                	j	75a <vprintf+0x60>
      if(c == 'd'){
 770:	11490c63          	beq	s2,s4,888 <vprintf+0x18e>
 774:	f9d9079b          	addiw	a5,s2,-99
 778:	0ff7f793          	zext.b	a5,a5
 77c:	10fc6e63          	bltu	s8,a5,898 <vprintf+0x19e>
 780:	f9d9079b          	addiw	a5,s2,-99
 784:	0ff7f713          	zext.b	a4,a5
 788:	10ec6863          	bltu	s8,a4,898 <vprintf+0x19e>
 78c:	00271793          	slli	a5,a4,0x2
 790:	97e6                	add	a5,a5,s9
 792:	439c                	lw	a5,0(a5)
 794:	97e6                	add	a5,a5,s9
 796:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 798:	008b0913          	addi	s2,s6,8
 79c:	4685                	li	a3,1
 79e:	4629                	li	a2,10
 7a0:	000b2583          	lw	a1,0(s6)
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	ea8080e7          	jalr	-344(ra) # 64e <printint>
 7ae:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b765                	j	75a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b4:	008b0913          	addi	s2,s6,8
 7b8:	4681                	li	a3,0
 7ba:	4629                	li	a2,10
 7bc:	000b2583          	lw	a1,0(s6)
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e8c080e7          	jalr	-372(ra) # 64e <printint>
 7ca:	8b4a                	mv	s6,s2
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	b771                	j	75a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7d0:	008b0913          	addi	s2,s6,8
 7d4:	4681                	li	a3,0
 7d6:	866a                	mv	a2,s10
 7d8:	000b2583          	lw	a1,0(s6)
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	e70080e7          	jalr	-400(ra) # 64e <printint>
 7e6:	8b4a                	mv	s6,s2
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	bf85                	j	75a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7ec:	008b0793          	addi	a5,s6,8
 7f0:	f8f43423          	sd	a5,-120(s0)
 7f4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7f8:	03000593          	li	a1,48
 7fc:	8556                	mv	a0,s5
 7fe:	00000097          	auipc	ra,0x0
 802:	e2e080e7          	jalr	-466(ra) # 62c <putc>
  putc(fd, 'x');
 806:	07800593          	li	a1,120
 80a:	8556                	mv	a0,s5
 80c:	00000097          	auipc	ra,0x0
 810:	e20080e7          	jalr	-480(ra) # 62c <putc>
 814:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 816:	03c9d793          	srli	a5,s3,0x3c
 81a:	97de                	add	a5,a5,s7
 81c:	0007c583          	lbu	a1,0(a5)
 820:	8556                	mv	a0,s5
 822:	00000097          	auipc	ra,0x0
 826:	e0a080e7          	jalr	-502(ra) # 62c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 82a:	0992                	slli	s3,s3,0x4
 82c:	397d                	addiw	s2,s2,-1
 82e:	fe0914e3          	bnez	s2,816 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 832:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 836:	4981                	li	s3,0
 838:	b70d                	j	75a <vprintf+0x60>
        s = va_arg(ap, char*);
 83a:	008b0913          	addi	s2,s6,8
 83e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 842:	02098163          	beqz	s3,864 <vprintf+0x16a>
        while(*s != 0){
 846:	0009c583          	lbu	a1,0(s3)
 84a:	c5ad                	beqz	a1,8b4 <vprintf+0x1ba>
          putc(fd, *s);
 84c:	8556                	mv	a0,s5
 84e:	00000097          	auipc	ra,0x0
 852:	dde080e7          	jalr	-546(ra) # 62c <putc>
          s++;
 856:	0985                	addi	s3,s3,1
        while(*s != 0){
 858:	0009c583          	lbu	a1,0(s3)
 85c:	f9e5                	bnez	a1,84c <vprintf+0x152>
        s = va_arg(ap, char*);
 85e:	8b4a                	mv	s6,s2
      state = 0;
 860:	4981                	li	s3,0
 862:	bde5                	j	75a <vprintf+0x60>
          s = "(null)";
 864:	00000997          	auipc	s3,0x0
 868:	3ec98993          	addi	s3,s3,1004 # c50 <statistics+0x1ac>
        while(*s != 0){
 86c:	85ee                	mv	a1,s11
 86e:	bff9                	j	84c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 870:	008b0913          	addi	s2,s6,8
 874:	000b4583          	lbu	a1,0(s6)
 878:	8556                	mv	a0,s5
 87a:	00000097          	auipc	ra,0x0
 87e:	db2080e7          	jalr	-590(ra) # 62c <putc>
 882:	8b4a                	mv	s6,s2
      state = 0;
 884:	4981                	li	s3,0
 886:	bdd1                	j	75a <vprintf+0x60>
        putc(fd, c);
 888:	85d2                	mv	a1,s4
 88a:	8556                	mv	a0,s5
 88c:	00000097          	auipc	ra,0x0
 890:	da0080e7          	jalr	-608(ra) # 62c <putc>
      state = 0;
 894:	4981                	li	s3,0
 896:	b5d1                	j	75a <vprintf+0x60>
        putc(fd, '%');
 898:	85d2                	mv	a1,s4
 89a:	8556                	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	d90080e7          	jalr	-624(ra) # 62c <putc>
        putc(fd, c);
 8a4:	85ca                	mv	a1,s2
 8a6:	8556                	mv	a0,s5
 8a8:	00000097          	auipc	ra,0x0
 8ac:	d84080e7          	jalr	-636(ra) # 62c <putc>
      state = 0;
 8b0:	4981                	li	s3,0
 8b2:	b565                	j	75a <vprintf+0x60>
        s = va_arg(ap, char*);
 8b4:	8b4a                	mv	s6,s2
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	b54d                	j	75a <vprintf+0x60>
    }
  }
}
 8ba:	70e6                	ld	ra,120(sp)
 8bc:	7446                	ld	s0,112(sp)
 8be:	74a6                	ld	s1,104(sp)
 8c0:	7906                	ld	s2,96(sp)
 8c2:	69e6                	ld	s3,88(sp)
 8c4:	6a46                	ld	s4,80(sp)
 8c6:	6aa6                	ld	s5,72(sp)
 8c8:	6b06                	ld	s6,64(sp)
 8ca:	7be2                	ld	s7,56(sp)
 8cc:	7c42                	ld	s8,48(sp)
 8ce:	7ca2                	ld	s9,40(sp)
 8d0:	7d02                	ld	s10,32(sp)
 8d2:	6de2                	ld	s11,24(sp)
 8d4:	6109                	addi	sp,sp,128
 8d6:	8082                	ret

00000000000008d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d8:	715d                	addi	sp,sp,-80
 8da:	ec06                	sd	ra,24(sp)
 8dc:	e822                	sd	s0,16(sp)
 8de:	1000                	addi	s0,sp,32
 8e0:	e010                	sd	a2,0(s0)
 8e2:	e414                	sd	a3,8(s0)
 8e4:	e818                	sd	a4,16(s0)
 8e6:	ec1c                	sd	a5,24(s0)
 8e8:	03043023          	sd	a6,32(s0)
 8ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8f0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8f4:	8622                	mv	a2,s0
 8f6:	00000097          	auipc	ra,0x0
 8fa:	e04080e7          	jalr	-508(ra) # 6fa <vprintf>
}
 8fe:	60e2                	ld	ra,24(sp)
 900:	6442                	ld	s0,16(sp)
 902:	6161                	addi	sp,sp,80
 904:	8082                	ret

0000000000000906 <printf>:

void
printf(const char *fmt, ...)
{
 906:	711d                	addi	sp,sp,-96
 908:	ec06                	sd	ra,24(sp)
 90a:	e822                	sd	s0,16(sp)
 90c:	1000                	addi	s0,sp,32
 90e:	e40c                	sd	a1,8(s0)
 910:	e810                	sd	a2,16(s0)
 912:	ec14                	sd	a3,24(s0)
 914:	f018                	sd	a4,32(s0)
 916:	f41c                	sd	a5,40(s0)
 918:	03043823          	sd	a6,48(s0)
 91c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 920:	00840613          	addi	a2,s0,8
 924:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 928:	85aa                	mv	a1,a0
 92a:	4505                	li	a0,1
 92c:	00000097          	auipc	ra,0x0
 930:	dce080e7          	jalr	-562(ra) # 6fa <vprintf>
}
 934:	60e2                	ld	ra,24(sp)
 936:	6442                	ld	s0,16(sp)
 938:	6125                	addi	sp,sp,96
 93a:	8082                	ret

000000000000093c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 93c:	1141                	addi	sp,sp,-16
 93e:	e422                	sd	s0,8(sp)
 940:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 942:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 946:	00000797          	auipc	a5,0x0
 94a:	3aa7b783          	ld	a5,938(a5) # cf0 <freep>
 94e:	a02d                	j	978 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 950:	4618                	lw	a4,8(a2)
 952:	9f2d                	addw	a4,a4,a1
 954:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 958:	6398                	ld	a4,0(a5)
 95a:	6310                	ld	a2,0(a4)
 95c:	a83d                	j	99a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 95e:	ff852703          	lw	a4,-8(a0)
 962:	9f31                	addw	a4,a4,a2
 964:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 966:	ff053683          	ld	a3,-16(a0)
 96a:	a091                	j	9ae <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 96c:	6398                	ld	a4,0(a5)
 96e:	00e7e463          	bltu	a5,a4,976 <free+0x3a>
 972:	00e6ea63          	bltu	a3,a4,986 <free+0x4a>
{
 976:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 978:	fed7fae3          	bgeu	a5,a3,96c <free+0x30>
 97c:	6398                	ld	a4,0(a5)
 97e:	00e6e463          	bltu	a3,a4,986 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 982:	fee7eae3          	bltu	a5,a4,976 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 986:	ff852583          	lw	a1,-8(a0)
 98a:	6390                	ld	a2,0(a5)
 98c:	02059813          	slli	a6,a1,0x20
 990:	01c85713          	srli	a4,a6,0x1c
 994:	9736                	add	a4,a4,a3
 996:	fae60de3          	beq	a2,a4,950 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 99a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 99e:	4790                	lw	a2,8(a5)
 9a0:	02061593          	slli	a1,a2,0x20
 9a4:	01c5d713          	srli	a4,a1,0x1c
 9a8:	973e                	add	a4,a4,a5
 9aa:	fae68ae3          	beq	a3,a4,95e <free+0x22>
    p->s.ptr = bp->s.ptr;
 9ae:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9b0:	00000717          	auipc	a4,0x0
 9b4:	34f73023          	sd	a5,832(a4) # cf0 <freep>
}
 9b8:	6422                	ld	s0,8(sp)
 9ba:	0141                	addi	sp,sp,16
 9bc:	8082                	ret

00000000000009be <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9be:	7139                	addi	sp,sp,-64
 9c0:	fc06                	sd	ra,56(sp)
 9c2:	f822                	sd	s0,48(sp)
 9c4:	f426                	sd	s1,40(sp)
 9c6:	f04a                	sd	s2,32(sp)
 9c8:	ec4e                	sd	s3,24(sp)
 9ca:	e852                	sd	s4,16(sp)
 9cc:	e456                	sd	s5,8(sp)
 9ce:	e05a                	sd	s6,0(sp)
 9d0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d2:	02051493          	slli	s1,a0,0x20
 9d6:	9081                	srli	s1,s1,0x20
 9d8:	04bd                	addi	s1,s1,15
 9da:	8091                	srli	s1,s1,0x4
 9dc:	0014899b          	addiw	s3,s1,1
 9e0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9e2:	00000517          	auipc	a0,0x0
 9e6:	30e53503          	ld	a0,782(a0) # cf0 <freep>
 9ea:	c515                	beqz	a0,a16 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ee:	4798                	lw	a4,8(a5)
 9f0:	02977f63          	bgeu	a4,s1,a2e <malloc+0x70>
 9f4:	8a4e                	mv	s4,s3
 9f6:	0009871b          	sext.w	a4,s3
 9fa:	6685                	lui	a3,0x1
 9fc:	00d77363          	bgeu	a4,a3,a02 <malloc+0x44>
 a00:	6a05                	lui	s4,0x1
 a02:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a06:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a0a:	00000917          	auipc	s2,0x0
 a0e:	2e690913          	addi	s2,s2,742 # cf0 <freep>
  if(p == (char*)-1)
 a12:	5afd                	li	s5,-1
 a14:	a895                	j	a88 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a16:	00001797          	auipc	a5,0x1
 a1a:	2e278793          	addi	a5,a5,738 # 1cf8 <base>
 a1e:	00000717          	auipc	a4,0x0
 a22:	2cf73923          	sd	a5,722(a4) # cf0 <freep>
 a26:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a28:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a2c:	b7e1                	j	9f4 <malloc+0x36>
      if(p->s.size == nunits)
 a2e:	02e48c63          	beq	s1,a4,a66 <malloc+0xa8>
        p->s.size -= nunits;
 a32:	4137073b          	subw	a4,a4,s3
 a36:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a38:	02071693          	slli	a3,a4,0x20
 a3c:	01c6d713          	srli	a4,a3,0x1c
 a40:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a42:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a46:	00000717          	auipc	a4,0x0
 a4a:	2aa73523          	sd	a0,682(a4) # cf0 <freep>
      return (void*)(p + 1);
 a4e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a52:	70e2                	ld	ra,56(sp)
 a54:	7442                	ld	s0,48(sp)
 a56:	74a2                	ld	s1,40(sp)
 a58:	7902                	ld	s2,32(sp)
 a5a:	69e2                	ld	s3,24(sp)
 a5c:	6a42                	ld	s4,16(sp)
 a5e:	6aa2                	ld	s5,8(sp)
 a60:	6b02                	ld	s6,0(sp)
 a62:	6121                	addi	sp,sp,64
 a64:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a66:	6398                	ld	a4,0(a5)
 a68:	e118                	sd	a4,0(a0)
 a6a:	bff1                	j	a46 <malloc+0x88>
  hp->s.size = nu;
 a6c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a70:	0541                	addi	a0,a0,16
 a72:	00000097          	auipc	ra,0x0
 a76:	eca080e7          	jalr	-310(ra) # 93c <free>
  return freep;
 a7a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a7e:	d971                	beqz	a0,a52 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a80:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a82:	4798                	lw	a4,8(a5)
 a84:	fa9775e3          	bgeu	a4,s1,a2e <malloc+0x70>
    if(p == freep)
 a88:	00093703          	ld	a4,0(s2)
 a8c:	853e                	mv	a0,a5
 a8e:	fef719e3          	bne	a4,a5,a80 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a92:	8552                	mv	a0,s4
 a94:	00000097          	auipc	ra,0x0
 a98:	b80080e7          	jalr	-1152(ra) # 614 <sbrk>
  if(p == (char*)-1)
 a9c:	fd5518e3          	bne	a0,s5,a6c <malloc+0xae>
        return 0;
 aa0:	4501                	li	a0,0
 aa2:	bf45                	j	a52 <malloc+0x94>

0000000000000aa4 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 aa4:	7179                	addi	sp,sp,-48
 aa6:	f406                	sd	ra,40(sp)
 aa8:	f022                	sd	s0,32(sp)
 aaa:	ec26                	sd	s1,24(sp)
 aac:	e84a                	sd	s2,16(sp)
 aae:	e44e                	sd	s3,8(sp)
 ab0:	e052                	sd	s4,0(sp)
 ab2:	1800                	addi	s0,sp,48
 ab4:	8a2a                	mv	s4,a0
 ab6:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 ab8:	4581                	li	a1,0
 aba:	00000517          	auipc	a0,0x0
 abe:	20e50513          	addi	a0,a0,526 # cc8 <digits+0x18>
 ac2:	00000097          	auipc	ra,0x0
 ac6:	b0a080e7          	jalr	-1270(ra) # 5cc <open>
  if(fd < 0) {
 aca:	04054263          	bltz	a0,b0e <statistics+0x6a>
 ace:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 ad0:	4481                	li	s1,0
 ad2:	03205063          	blez	s2,af2 <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 ad6:	4099063b          	subw	a2,s2,s1
 ada:	009a05b3          	add	a1,s4,s1
 ade:	854e                	mv	a0,s3
 ae0:	00000097          	auipc	ra,0x0
 ae4:	ac4080e7          	jalr	-1340(ra) # 5a4 <read>
 ae8:	00054563          	bltz	a0,af2 <statistics+0x4e>
      break;
    }
    i += n;
 aec:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 aee:	ff24c4e3          	blt	s1,s2,ad6 <statistics+0x32>
  }
  close(fd);
 af2:	854e                	mv	a0,s3
 af4:	00000097          	auipc	ra,0x0
 af8:	ac0080e7          	jalr	-1344(ra) # 5b4 <close>
  return i;
}
 afc:	8526                	mv	a0,s1
 afe:	70a2                	ld	ra,40(sp)
 b00:	7402                	ld	s0,32(sp)
 b02:	64e2                	ld	s1,24(sp)
 b04:	6942                	ld	s2,16(sp)
 b06:	69a2                	ld	s3,8(sp)
 b08:	6a02                	ld	s4,0(sp)
 b0a:	6145                	addi	sp,sp,48
 b0c:	8082                	ret
      fprintf(2, "stats: open failed\n");
 b0e:	00000597          	auipc	a1,0x0
 b12:	1ca58593          	addi	a1,a1,458 # cd8 <digits+0x28>
 b16:	4509                	li	a0,2
 b18:	00000097          	auipc	ra,0x0
 b1c:	dc0080e7          	jalr	-576(ra) # 8d8 <fprintf>
      exit(1);
 b20:	4505                	li	a0,1
 b22:	00000097          	auipc	ra,0x0
 b26:	a6a080e7          	jalr	-1430(ra) # 58c <exit>
