
user/_pgtbltest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
  printf("pgtbltest: %s failed: %s, pid=%d\n", testname, why, getpid());
   e:	00001917          	auipc	s2,0x1
  12:	b2a93903          	ld	s2,-1238(s2) # b38 <testname>
  16:	00000097          	auipc	ra,0x0
  1a:	4f0080e7          	jalr	1264(ra) # 506 <getpid>
  1e:	86aa                	mv	a3,a0
  20:	8626                	mv	a2,s1
  22:	85ca                	mv	a1,s2
  24:	00001517          	auipc	a0,0x1
  28:	98c50513          	addi	a0,a0,-1652 # 9b0 <malloc+0xe8>
  2c:	00000097          	auipc	ra,0x0
  30:	7e4080e7          	jalr	2020(ra) # 810 <printf>
  exit(1);
  34:	4505                	li	a0,1
  36:	00000097          	auipc	ra,0x0
  3a:	450080e7          	jalr	1104(ra) # 486 <exit>

000000000000003e <ugetpid_test>:
}

void
ugetpid_test()
{
  3e:	7179                	addi	sp,sp,-48
  40:	f406                	sd	ra,40(sp)
  42:	f022                	sd	s0,32(sp)
  44:	ec26                	sd	s1,24(sp)
  46:	1800                	addi	s0,sp,48
  int i;

  printf("ugetpid_test starting\n");
  48:	00001517          	auipc	a0,0x1
  4c:	99050513          	addi	a0,a0,-1648 # 9d8 <malloc+0x110>
  50:	00000097          	auipc	ra,0x0
  54:	7c0080e7          	jalr	1984(ra) # 810 <printf>
  testname = "ugetpid_test";
  58:	00001797          	auipc	a5,0x1
  5c:	99878793          	addi	a5,a5,-1640 # 9f0 <malloc+0x128>
  60:	00001717          	auipc	a4,0x1
  64:	acf73c23          	sd	a5,-1320(a4) # b38 <testname>
  68:	04000493          	li	s1,64

  for (i = 0; i < 64; i++) {
    int ret = fork();
  6c:	00000097          	auipc	ra,0x0
  70:	412080e7          	jalr	1042(ra) # 47e <fork>
  74:	fca42e23          	sw	a0,-36(s0)
    if (ret != 0) {
  78:	cd15                	beqz	a0,b4 <ugetpid_test+0x76>
      wait(&ret);
  7a:	fdc40513          	addi	a0,s0,-36
  7e:	00000097          	auipc	ra,0x0
  82:	410080e7          	jalr	1040(ra) # 48e <wait>
      if (ret != 0)
  86:	fdc42783          	lw	a5,-36(s0)
  8a:	e385                	bnez	a5,aa <ugetpid_test+0x6c>
  for (i = 0; i < 64; i++) {
  8c:	34fd                	addiw	s1,s1,-1
  8e:	fcf9                	bnez	s1,6c <ugetpid_test+0x2e>
    }
    if (getpid() != ugetpid())
      err("missmatched PID");
    exit(0);
  }
  printf("ugetpid_test: OK\n");
  90:	00001517          	auipc	a0,0x1
  94:	98050513          	addi	a0,a0,-1664 # a10 <malloc+0x148>
  98:	00000097          	auipc	ra,0x0
  9c:	778080e7          	jalr	1912(ra) # 810 <printf>
}
  a0:	70a2                	ld	ra,40(sp)
  a2:	7402                	ld	s0,32(sp)
  a4:	64e2                	ld	s1,24(sp)
  a6:	6145                	addi	sp,sp,48
  a8:	8082                	ret
        exit(1);
  aa:	4505                	li	a0,1
  ac:	00000097          	auipc	ra,0x0
  b0:	3da080e7          	jalr	986(ra) # 486 <exit>
    if (getpid() != ugetpid())
  b4:	00000097          	auipc	ra,0x0
  b8:	452080e7          	jalr	1106(ra) # 506 <getpid>
  bc:	84aa                	mv	s1,a0
  be:	00000097          	auipc	ra,0x0
  c2:	3aa080e7          	jalr	938(ra) # 468 <ugetpid>
  c6:	00a48a63          	beq	s1,a0,da <ugetpid_test+0x9c>
      err("missmatched PID");
  ca:	00001517          	auipc	a0,0x1
  ce:	93650513          	addi	a0,a0,-1738 # a00 <malloc+0x138>
  d2:	00000097          	auipc	ra,0x0
  d6:	f2e080e7          	jalr	-210(ra) # 0 <err>
    exit(0);
  da:	4501                	li	a0,0
  dc:	00000097          	auipc	ra,0x0
  e0:	3aa080e7          	jalr	938(ra) # 486 <exit>

00000000000000e4 <pgaccess_test>:

void
pgaccess_test()
{
  e4:	7179                	addi	sp,sp,-48
  e6:	f406                	sd	ra,40(sp)
  e8:	f022                	sd	s0,32(sp)
  ea:	ec26                	sd	s1,24(sp)
  ec:	1800                	addi	s0,sp,48
  char *buf;
  unsigned int abits;
  printf("pgaccess_test starting\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	93a50513          	addi	a0,a0,-1734 # a28 <malloc+0x160>
  f6:	00000097          	auipc	ra,0x0
  fa:	71a080e7          	jalr	1818(ra) # 810 <printf>
  testname = "pgaccess_test";
  fe:	00001797          	auipc	a5,0x1
 102:	94278793          	addi	a5,a5,-1726 # a40 <malloc+0x178>
 106:	00001717          	auipc	a4,0x1
 10a:	a2f73923          	sd	a5,-1486(a4) # b38 <testname>
  buf = malloc(32 * PGSIZE);
 10e:	00020537          	lui	a0,0x20
 112:	00000097          	auipc	ra,0x0
 116:	7b6080e7          	jalr	1974(ra) # 8c8 <malloc>
 11a:	84aa                	mv	s1,a0
  if (pgaccess(buf, 32, &abits) < 0)
 11c:	fdc40613          	addi	a2,s0,-36
 120:	02000593          	li	a1,32
 124:	00000097          	auipc	ra,0x0
 128:	40a080e7          	jalr	1034(ra) # 52e <pgaccess>
 12c:	06054b63          	bltz	a0,1a2 <pgaccess_test+0xbe>
    err("pgaccess failed");
  buf[PGSIZE * 1] += 1;
 130:	6785                	lui	a5,0x1
 132:	97a6                	add	a5,a5,s1
 134:	0007c703          	lbu	a4,0(a5) # 1000 <__BSS_END__+0x4a8>
 138:	2705                	addiw	a4,a4,1
 13a:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 2] += 1;
 13e:	6789                	lui	a5,0x2
 140:	97a6                	add	a5,a5,s1
 142:	0007c703          	lbu	a4,0(a5) # 2000 <__global_pointer$+0xccf>
 146:	2705                	addiw	a4,a4,1
 148:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 30] += 1;
 14c:	67f9                	lui	a5,0x1e
 14e:	97a6                	add	a5,a5,s1
 150:	0007c703          	lbu	a4,0(a5) # 1e000 <__global_pointer$+0x1cccf>
 154:	2705                	addiw	a4,a4,1
 156:	00e78023          	sb	a4,0(a5)
  if (pgaccess(buf, 32, &abits) < 0)
 15a:	fdc40613          	addi	a2,s0,-36
 15e:	02000593          	li	a1,32
 162:	8526                	mv	a0,s1
 164:	00000097          	auipc	ra,0x0
 168:	3ca080e7          	jalr	970(ra) # 52e <pgaccess>
 16c:	04054363          	bltz	a0,1b2 <pgaccess_test+0xce>
    err("pgaccess failed");
  if (abits != ((1 << 1) | (1 << 2) | (1 << 30)))
 170:	fdc42703          	lw	a4,-36(s0)
 174:	400007b7          	lui	a5,0x40000
 178:	0799                	addi	a5,a5,6 # 40000006 <__global_pointer$+0x3fffecd5>
 17a:	04f71463          	bne	a4,a5,1c2 <pgaccess_test+0xde>
    err("incorrect access bits set");
  free(buf);
 17e:	8526                	mv	a0,s1
 180:	00000097          	auipc	ra,0x0
 184:	6c6080e7          	jalr	1734(ra) # 846 <free>
  printf("pgaccess_test: OK\n");
 188:	00001517          	auipc	a0,0x1
 18c:	8f850513          	addi	a0,a0,-1800 # a80 <malloc+0x1b8>
 190:	00000097          	auipc	ra,0x0
 194:	680080e7          	jalr	1664(ra) # 810 <printf>
}
 198:	70a2                	ld	ra,40(sp)
 19a:	7402                	ld	s0,32(sp)
 19c:	64e2                	ld	s1,24(sp)
 19e:	6145                	addi	sp,sp,48
 1a0:	8082                	ret
    err("pgaccess failed");
 1a2:	00001517          	auipc	a0,0x1
 1a6:	8ae50513          	addi	a0,a0,-1874 # a50 <malloc+0x188>
 1aa:	00000097          	auipc	ra,0x0
 1ae:	e56080e7          	jalr	-426(ra) # 0 <err>
    err("pgaccess failed");
 1b2:	00001517          	auipc	a0,0x1
 1b6:	89e50513          	addi	a0,a0,-1890 # a50 <malloc+0x188>
 1ba:	00000097          	auipc	ra,0x0
 1be:	e46080e7          	jalr	-442(ra) # 0 <err>
    err("incorrect access bits set");
 1c2:	00001517          	auipc	a0,0x1
 1c6:	89e50513          	addi	a0,a0,-1890 # a60 <malloc+0x198>
 1ca:	00000097          	auipc	ra,0x0
 1ce:	e36080e7          	jalr	-458(ra) # 0 <err>

00000000000001d2 <main>:
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e406                	sd	ra,8(sp)
 1d6:	e022                	sd	s0,0(sp)
 1d8:	0800                	addi	s0,sp,16
  ugetpid_test();
 1da:	00000097          	auipc	ra,0x0
 1de:	e64080e7          	jalr	-412(ra) # 3e <ugetpid_test>
  pgaccess_test();
 1e2:	00000097          	auipc	ra,0x0
 1e6:	f02080e7          	jalr	-254(ra) # e4 <pgaccess_test>
  printf("pgtbltest: all tests succeeded\n");
 1ea:	00001517          	auipc	a0,0x1
 1ee:	8ae50513          	addi	a0,a0,-1874 # a98 <malloc+0x1d0>
 1f2:	00000097          	auipc	ra,0x0
 1f6:	61e080e7          	jalr	1566(ra) # 810 <printf>
  exit(0);
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	28a080e7          	jalr	650(ra) # 486 <exit>

0000000000000204 <strcpy>:



char*
strcpy(char *s, const char *t)
{
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 20a:	87aa                	mv	a5,a0
 20c:	0585                	addi	a1,a1,1
 20e:	0785                	addi	a5,a5,1
 210:	fff5c703          	lbu	a4,-1(a1)
 214:	fee78fa3          	sb	a4,-1(a5)
 218:	fb75                	bnez	a4,20c <strcpy+0x8>
    ;
  return os;
}
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret

0000000000000220 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 226:	00054783          	lbu	a5,0(a0)
 22a:	cb91                	beqz	a5,23e <strcmp+0x1e>
 22c:	0005c703          	lbu	a4,0(a1)
 230:	00f71763          	bne	a4,a5,23e <strcmp+0x1e>
    p++, q++;
 234:	0505                	addi	a0,a0,1
 236:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 238:	00054783          	lbu	a5,0(a0)
 23c:	fbe5                	bnez	a5,22c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 23e:	0005c503          	lbu	a0,0(a1)
}
 242:	40a7853b          	subw	a0,a5,a0
 246:	6422                	ld	s0,8(sp)
 248:	0141                	addi	sp,sp,16
 24a:	8082                	ret

000000000000024c <strlen>:

uint
strlen(const char *s)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 252:	00054783          	lbu	a5,0(a0)
 256:	cf91                	beqz	a5,272 <strlen+0x26>
 258:	0505                	addi	a0,a0,1
 25a:	87aa                	mv	a5,a0
 25c:	4685                	li	a3,1
 25e:	9e89                	subw	a3,a3,a0
 260:	00f6853b          	addw	a0,a3,a5
 264:	0785                	addi	a5,a5,1
 266:	fff7c703          	lbu	a4,-1(a5)
 26a:	fb7d                	bnez	a4,260 <strlen+0x14>
    ;
  return n;
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  for(n = 0; s[n]; n++)
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <strlen+0x20>

0000000000000276 <memset>:

void*
memset(void *dst, int c, uint n)
{
 276:	1141                	addi	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 27c:	ca19                	beqz	a2,292 <memset+0x1c>
 27e:	87aa                	mv	a5,a0
 280:	1602                	slli	a2,a2,0x20
 282:	9201                	srli	a2,a2,0x20
 284:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 288:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 28c:	0785                	addi	a5,a5,1
 28e:	fee79de3          	bne	a5,a4,288 <memset+0x12>
  }
  return dst;
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret

0000000000000298 <strchr>:

char*
strchr(const char *s, char c)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	cb99                	beqz	a5,2b8 <strchr+0x20>
    if(*s == c)
 2a4:	00f58763          	beq	a1,a5,2b2 <strchr+0x1a>
  for(; *s; s++)
 2a8:	0505                	addi	a0,a0,1
 2aa:	00054783          	lbu	a5,0(a0)
 2ae:	fbfd                	bnez	a5,2a4 <strchr+0xc>
      return (char*)s;
  return 0;
 2b0:	4501                	li	a0,0
}
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	bfe5                	j	2b2 <strchr+0x1a>

00000000000002bc <gets>:

char*
gets(char *buf, int max)
{
 2bc:	711d                	addi	sp,sp,-96
 2be:	ec86                	sd	ra,88(sp)
 2c0:	e8a2                	sd	s0,80(sp)
 2c2:	e4a6                	sd	s1,72(sp)
 2c4:	e0ca                	sd	s2,64(sp)
 2c6:	fc4e                	sd	s3,56(sp)
 2c8:	f852                	sd	s4,48(sp)
 2ca:	f456                	sd	s5,40(sp)
 2cc:	f05a                	sd	s6,32(sp)
 2ce:	ec5e                	sd	s7,24(sp)
 2d0:	1080                	addi	s0,sp,96
 2d2:	8baa                	mv	s7,a0
 2d4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d6:	892a                	mv	s2,a0
 2d8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2da:	4aa9                	li	s5,10
 2dc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2de:	89a6                	mv	s3,s1
 2e0:	2485                	addiw	s1,s1,1
 2e2:	0344d863          	bge	s1,s4,312 <gets+0x56>
    cc = read(0, &c, 1);
 2e6:	4605                	li	a2,1
 2e8:	faf40593          	addi	a1,s0,-81
 2ec:	4501                	li	a0,0
 2ee:	00000097          	auipc	ra,0x0
 2f2:	1b0080e7          	jalr	432(ra) # 49e <read>
    if(cc < 1)
 2f6:	00a05e63          	blez	a0,312 <gets+0x56>
    buf[i++] = c;
 2fa:	faf44783          	lbu	a5,-81(s0)
 2fe:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 302:	01578763          	beq	a5,s5,310 <gets+0x54>
 306:	0905                	addi	s2,s2,1
 308:	fd679be3          	bne	a5,s6,2de <gets+0x22>
  for(i=0; i+1 < max; ){
 30c:	89a6                	mv	s3,s1
 30e:	a011                	j	312 <gets+0x56>
 310:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 312:	99de                	add	s3,s3,s7
 314:	00098023          	sb	zero,0(s3)
  return buf;
}
 318:	855e                	mv	a0,s7
 31a:	60e6                	ld	ra,88(sp)
 31c:	6446                	ld	s0,80(sp)
 31e:	64a6                	ld	s1,72(sp)
 320:	6906                	ld	s2,64(sp)
 322:	79e2                	ld	s3,56(sp)
 324:	7a42                	ld	s4,48(sp)
 326:	7aa2                	ld	s5,40(sp)
 328:	7b02                	ld	s6,32(sp)
 32a:	6be2                	ld	s7,24(sp)
 32c:	6125                	addi	sp,sp,96
 32e:	8082                	ret

0000000000000330 <stat>:

int
stat(const char *n, struct stat *st)
{
 330:	1101                	addi	sp,sp,-32
 332:	ec06                	sd	ra,24(sp)
 334:	e822                	sd	s0,16(sp)
 336:	e426                	sd	s1,8(sp)
 338:	e04a                	sd	s2,0(sp)
 33a:	1000                	addi	s0,sp,32
 33c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33e:	4581                	li	a1,0
 340:	00000097          	auipc	ra,0x0
 344:	186080e7          	jalr	390(ra) # 4c6 <open>
  if(fd < 0)
 348:	02054563          	bltz	a0,372 <stat+0x42>
 34c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 34e:	85ca                	mv	a1,s2
 350:	00000097          	auipc	ra,0x0
 354:	18e080e7          	jalr	398(ra) # 4de <fstat>
 358:	892a                	mv	s2,a0
  close(fd);
 35a:	8526                	mv	a0,s1
 35c:	00000097          	auipc	ra,0x0
 360:	152080e7          	jalr	338(ra) # 4ae <close>
  return r;
}
 364:	854a                	mv	a0,s2
 366:	60e2                	ld	ra,24(sp)
 368:	6442                	ld	s0,16(sp)
 36a:	64a2                	ld	s1,8(sp)
 36c:	6902                	ld	s2,0(sp)
 36e:	6105                	addi	sp,sp,32
 370:	8082                	ret
    return -1;
 372:	597d                	li	s2,-1
 374:	bfc5                	j	364 <stat+0x34>

0000000000000376 <atoi>:

int
atoi(const char *s)
{
 376:	1141                	addi	sp,sp,-16
 378:	e422                	sd	s0,8(sp)
 37a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 37c:	00054683          	lbu	a3,0(a0)
 380:	fd06879b          	addiw	a5,a3,-48
 384:	0ff7f793          	zext.b	a5,a5
 388:	4625                	li	a2,9
 38a:	02f66863          	bltu	a2,a5,3ba <atoi+0x44>
 38e:	872a                	mv	a4,a0
  n = 0;
 390:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 392:	0705                	addi	a4,a4,1
 394:	0025179b          	slliw	a5,a0,0x2
 398:	9fa9                	addw	a5,a5,a0
 39a:	0017979b          	slliw	a5,a5,0x1
 39e:	9fb5                	addw	a5,a5,a3
 3a0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3a4:	00074683          	lbu	a3,0(a4)
 3a8:	fd06879b          	addiw	a5,a3,-48
 3ac:	0ff7f793          	zext.b	a5,a5
 3b0:	fef671e3          	bgeu	a2,a5,392 <atoi+0x1c>
  return n;
}
 3b4:	6422                	ld	s0,8(sp)
 3b6:	0141                	addi	sp,sp,16
 3b8:	8082                	ret
  n = 0;
 3ba:	4501                	li	a0,0
 3bc:	bfe5                	j	3b4 <atoi+0x3e>

00000000000003be <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3be:	1141                	addi	sp,sp,-16
 3c0:	e422                	sd	s0,8(sp)
 3c2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3c4:	02b57463          	bgeu	a0,a1,3ec <memmove+0x2e>
    while(n-- > 0)
 3c8:	00c05f63          	blez	a2,3e6 <memmove+0x28>
 3cc:	1602                	slli	a2,a2,0x20
 3ce:	9201                	srli	a2,a2,0x20
 3d0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3d4:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d6:	0585                	addi	a1,a1,1
 3d8:	0705                	addi	a4,a4,1
 3da:	fff5c683          	lbu	a3,-1(a1)
 3de:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3e2:	fee79ae3          	bne	a5,a4,3d6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret
    dst += n;
 3ec:	00c50733          	add	a4,a0,a2
    src += n;
 3f0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3f2:	fec05ae3          	blez	a2,3e6 <memmove+0x28>
 3f6:	fff6079b          	addiw	a5,a2,-1
 3fa:	1782                	slli	a5,a5,0x20
 3fc:	9381                	srli	a5,a5,0x20
 3fe:	fff7c793          	not	a5,a5
 402:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 404:	15fd                	addi	a1,a1,-1
 406:	177d                	addi	a4,a4,-1
 408:	0005c683          	lbu	a3,0(a1)
 40c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 410:	fee79ae3          	bne	a5,a4,404 <memmove+0x46>
 414:	bfc9                	j	3e6 <memmove+0x28>

0000000000000416 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 416:	1141                	addi	sp,sp,-16
 418:	e422                	sd	s0,8(sp)
 41a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 41c:	ca05                	beqz	a2,44c <memcmp+0x36>
 41e:	fff6069b          	addiw	a3,a2,-1
 422:	1682                	slli	a3,a3,0x20
 424:	9281                	srli	a3,a3,0x20
 426:	0685                	addi	a3,a3,1
 428:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 42a:	00054783          	lbu	a5,0(a0)
 42e:	0005c703          	lbu	a4,0(a1)
 432:	00e79863          	bne	a5,a4,442 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 436:	0505                	addi	a0,a0,1
    p2++;
 438:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 43a:	fed518e3          	bne	a0,a3,42a <memcmp+0x14>
  }
  return 0;
 43e:	4501                	li	a0,0
 440:	a019                	j	446 <memcmp+0x30>
      return *p1 - *p2;
 442:	40e7853b          	subw	a0,a5,a4
}
 446:	6422                	ld	s0,8(sp)
 448:	0141                	addi	sp,sp,16
 44a:	8082                	ret
  return 0;
 44c:	4501                	li	a0,0
 44e:	bfe5                	j	446 <memcmp+0x30>

0000000000000450 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 450:	1141                	addi	sp,sp,-16
 452:	e406                	sd	ra,8(sp)
 454:	e022                	sd	s0,0(sp)
 456:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 458:	00000097          	auipc	ra,0x0
 45c:	f66080e7          	jalr	-154(ra) # 3be <memmove>
}
 460:	60a2                	ld	ra,8(sp)
 462:	6402                	ld	s0,0(sp)
 464:	0141                	addi	sp,sp,16
 466:	8082                	ret

0000000000000468 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 468:	1141                	addi	sp,sp,-16
 46a:	e422                	sd	s0,8(sp)
 46c:	0800                	addi	s0,sp,16
  struct usyscall* u = (struct usyscall *)USYSCALL;
  return u->pid;
 46e:	040007b7          	lui	a5,0x4000
}
 472:	17f5                	addi	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffeccc>
 474:	07b2                	slli	a5,a5,0xc
 476:	4388                	lw	a0,0(a5)
 478:	6422                	ld	s0,8(sp)
 47a:	0141                	addi	sp,sp,16
 47c:	8082                	ret

000000000000047e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 47e:	4885                	li	a7,1
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <exit>:
.global exit
exit:
 li a7, SYS_exit
 486:	4889                	li	a7,2
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <wait>:
.global wait
wait:
 li a7, SYS_wait
 48e:	488d                	li	a7,3
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 496:	4891                	li	a7,4
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <read>:
.global read
read:
 li a7, SYS_read
 49e:	4895                	li	a7,5
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <write>:
.global write
write:
 li a7, SYS_write
 4a6:	48c1                	li	a7,16
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <close>:
.global close
close:
 li a7, SYS_close
 4ae:	48d5                	li	a7,21
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4b6:	4899                	li	a7,6
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <exec>:
.global exec
exec:
 li a7, SYS_exec
 4be:	489d                	li	a7,7
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <open>:
.global open
open:
 li a7, SYS_open
 4c6:	48bd                	li	a7,15
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4ce:	48c5                	li	a7,17
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4d6:	48c9                	li	a7,18
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4de:	48a1                	li	a7,8
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <link>:
.global link
link:
 li a7, SYS_link
 4e6:	48cd                	li	a7,19
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ee:	48d1                	li	a7,20
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4f6:	48a5                	li	a7,9
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <dup>:
.global dup
dup:
 li a7, SYS_dup
 4fe:	48a9                	li	a7,10
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 506:	48ad                	li	a7,11
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 50e:	48b1                	li	a7,12
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 516:	48b5                	li	a7,13
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 51e:	48b9                	li	a7,14
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <connect>:
.global connect
connect:
 li a7, SYS_connect
 526:	48f5                	li	a7,29
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 52e:	48f9                	li	a7,30
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 536:	1101                	addi	sp,sp,-32
 538:	ec06                	sd	ra,24(sp)
 53a:	e822                	sd	s0,16(sp)
 53c:	1000                	addi	s0,sp,32
 53e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 542:	4605                	li	a2,1
 544:	fef40593          	addi	a1,s0,-17
 548:	00000097          	auipc	ra,0x0
 54c:	f5e080e7          	jalr	-162(ra) # 4a6 <write>
}
 550:	60e2                	ld	ra,24(sp)
 552:	6442                	ld	s0,16(sp)
 554:	6105                	addi	sp,sp,32
 556:	8082                	ret

0000000000000558 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 558:	7139                	addi	sp,sp,-64
 55a:	fc06                	sd	ra,56(sp)
 55c:	f822                	sd	s0,48(sp)
 55e:	f426                	sd	s1,40(sp)
 560:	f04a                	sd	s2,32(sp)
 562:	ec4e                	sd	s3,24(sp)
 564:	0080                	addi	s0,sp,64
 566:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 568:	c299                	beqz	a3,56e <printint+0x16>
 56a:	0805c963          	bltz	a1,5fc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 56e:	2581                	sext.w	a1,a1
  neg = 0;
 570:	4881                	li	a7,0
 572:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 576:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 578:	2601                	sext.w	a2,a2
 57a:	00000517          	auipc	a0,0x0
 57e:	5a650513          	addi	a0,a0,1446 # b20 <digits>
 582:	883a                	mv	a6,a4
 584:	2705                	addiw	a4,a4,1
 586:	02c5f7bb          	remuw	a5,a1,a2
 58a:	1782                	slli	a5,a5,0x20
 58c:	9381                	srli	a5,a5,0x20
 58e:	97aa                	add	a5,a5,a0
 590:	0007c783          	lbu	a5,0(a5)
 594:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 598:	0005879b          	sext.w	a5,a1
 59c:	02c5d5bb          	divuw	a1,a1,a2
 5a0:	0685                	addi	a3,a3,1
 5a2:	fec7f0e3          	bgeu	a5,a2,582 <printint+0x2a>
  if(neg)
 5a6:	00088c63          	beqz	a7,5be <printint+0x66>
    buf[i++] = '-';
 5aa:	fd070793          	addi	a5,a4,-48
 5ae:	00878733          	add	a4,a5,s0
 5b2:	02d00793          	li	a5,45
 5b6:	fef70823          	sb	a5,-16(a4)
 5ba:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5be:	02e05863          	blez	a4,5ee <printint+0x96>
 5c2:	fc040793          	addi	a5,s0,-64
 5c6:	00e78933          	add	s2,a5,a4
 5ca:	fff78993          	addi	s3,a5,-1
 5ce:	99ba                	add	s3,s3,a4
 5d0:	377d                	addiw	a4,a4,-1
 5d2:	1702                	slli	a4,a4,0x20
 5d4:	9301                	srli	a4,a4,0x20
 5d6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5da:	fff94583          	lbu	a1,-1(s2)
 5de:	8526                	mv	a0,s1
 5e0:	00000097          	auipc	ra,0x0
 5e4:	f56080e7          	jalr	-170(ra) # 536 <putc>
  while(--i >= 0)
 5e8:	197d                	addi	s2,s2,-1
 5ea:	ff3918e3          	bne	s2,s3,5da <printint+0x82>
}
 5ee:	70e2                	ld	ra,56(sp)
 5f0:	7442                	ld	s0,48(sp)
 5f2:	74a2                	ld	s1,40(sp)
 5f4:	7902                	ld	s2,32(sp)
 5f6:	69e2                	ld	s3,24(sp)
 5f8:	6121                	addi	sp,sp,64
 5fa:	8082                	ret
    x = -xx;
 5fc:	40b005bb          	negw	a1,a1
    neg = 1;
 600:	4885                	li	a7,1
    x = -xx;
 602:	bf85                	j	572 <printint+0x1a>

0000000000000604 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 604:	7119                	addi	sp,sp,-128
 606:	fc86                	sd	ra,120(sp)
 608:	f8a2                	sd	s0,112(sp)
 60a:	f4a6                	sd	s1,104(sp)
 60c:	f0ca                	sd	s2,96(sp)
 60e:	ecce                	sd	s3,88(sp)
 610:	e8d2                	sd	s4,80(sp)
 612:	e4d6                	sd	s5,72(sp)
 614:	e0da                	sd	s6,64(sp)
 616:	fc5e                	sd	s7,56(sp)
 618:	f862                	sd	s8,48(sp)
 61a:	f466                	sd	s9,40(sp)
 61c:	f06a                	sd	s10,32(sp)
 61e:	ec6e                	sd	s11,24(sp)
 620:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 622:	0005c903          	lbu	s2,0(a1)
 626:	18090f63          	beqz	s2,7c4 <vprintf+0x1c0>
 62a:	8aaa                	mv	s5,a0
 62c:	8b32                	mv	s6,a2
 62e:	00158493          	addi	s1,a1,1
  state = 0;
 632:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 634:	02500a13          	li	s4,37
 638:	4c55                	li	s8,21
 63a:	00000c97          	auipc	s9,0x0
 63e:	48ec8c93          	addi	s9,s9,1166 # ac8 <malloc+0x200>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 642:	02800d93          	li	s11,40
  putc(fd, 'x');
 646:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 648:	00000b97          	auipc	s7,0x0
 64c:	4d8b8b93          	addi	s7,s7,1240 # b20 <digits>
 650:	a839                	j	66e <vprintf+0x6a>
        putc(fd, c);
 652:	85ca                	mv	a1,s2
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	ee0080e7          	jalr	-288(ra) # 536 <putc>
 65e:	a019                	j	664 <vprintf+0x60>
    } else if(state == '%'){
 660:	01498d63          	beq	s3,s4,67a <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 664:	0485                	addi	s1,s1,1
 666:	fff4c903          	lbu	s2,-1(s1)
 66a:	14090d63          	beqz	s2,7c4 <vprintf+0x1c0>
    if(state == 0){
 66e:	fe0999e3          	bnez	s3,660 <vprintf+0x5c>
      if(c == '%'){
 672:	ff4910e3          	bne	s2,s4,652 <vprintf+0x4e>
        state = '%';
 676:	89d2                	mv	s3,s4
 678:	b7f5                	j	664 <vprintf+0x60>
      if(c == 'd'){
 67a:	11490c63          	beq	s2,s4,792 <vprintf+0x18e>
 67e:	f9d9079b          	addiw	a5,s2,-99
 682:	0ff7f793          	zext.b	a5,a5
 686:	10fc6e63          	bltu	s8,a5,7a2 <vprintf+0x19e>
 68a:	f9d9079b          	addiw	a5,s2,-99
 68e:	0ff7f713          	zext.b	a4,a5
 692:	10ec6863          	bltu	s8,a4,7a2 <vprintf+0x19e>
 696:	00271793          	slli	a5,a4,0x2
 69a:	97e6                	add	a5,a5,s9
 69c:	439c                	lw	a5,0(a5)
 69e:	97e6                	add	a5,a5,s9
 6a0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6a2:	008b0913          	addi	s2,s6,8
 6a6:	4685                	li	a3,1
 6a8:	4629                	li	a2,10
 6aa:	000b2583          	lw	a1,0(s6)
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	ea8080e7          	jalr	-344(ra) # 558 <printint>
 6b8:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	b765                	j	664 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6be:	008b0913          	addi	s2,s6,8
 6c2:	4681                	li	a3,0
 6c4:	4629                	li	a2,10
 6c6:	000b2583          	lw	a1,0(s6)
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	e8c080e7          	jalr	-372(ra) # 558 <printint>
 6d4:	8b4a                	mv	s6,s2
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	b771                	j	664 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6da:	008b0913          	addi	s2,s6,8
 6de:	4681                	li	a3,0
 6e0:	866a                	mv	a2,s10
 6e2:	000b2583          	lw	a1,0(s6)
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e70080e7          	jalr	-400(ra) # 558 <printint>
 6f0:	8b4a                	mv	s6,s2
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	bf85                	j	664 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6f6:	008b0793          	addi	a5,s6,8
 6fa:	f8f43423          	sd	a5,-120(s0)
 6fe:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 702:	03000593          	li	a1,48
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	e2e080e7          	jalr	-466(ra) # 536 <putc>
  putc(fd, 'x');
 710:	07800593          	li	a1,120
 714:	8556                	mv	a0,s5
 716:	00000097          	auipc	ra,0x0
 71a:	e20080e7          	jalr	-480(ra) # 536 <putc>
 71e:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 720:	03c9d793          	srli	a5,s3,0x3c
 724:	97de                	add	a5,a5,s7
 726:	0007c583          	lbu	a1,0(a5)
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	e0a080e7          	jalr	-502(ra) # 536 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 734:	0992                	slli	s3,s3,0x4
 736:	397d                	addiw	s2,s2,-1
 738:	fe0914e3          	bnez	s2,720 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 73c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 740:	4981                	li	s3,0
 742:	b70d                	j	664 <vprintf+0x60>
        s = va_arg(ap, char*);
 744:	008b0913          	addi	s2,s6,8
 748:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 74c:	02098163          	beqz	s3,76e <vprintf+0x16a>
        while(*s != 0){
 750:	0009c583          	lbu	a1,0(s3)
 754:	c5ad                	beqz	a1,7be <vprintf+0x1ba>
          putc(fd, *s);
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	dde080e7          	jalr	-546(ra) # 536 <putc>
          s++;
 760:	0985                	addi	s3,s3,1
        while(*s != 0){
 762:	0009c583          	lbu	a1,0(s3)
 766:	f9e5                	bnez	a1,756 <vprintf+0x152>
        s = va_arg(ap, char*);
 768:	8b4a                	mv	s6,s2
      state = 0;
 76a:	4981                	li	s3,0
 76c:	bde5                	j	664 <vprintf+0x60>
          s = "(null)";
 76e:	00000997          	auipc	s3,0x0
 772:	35298993          	addi	s3,s3,850 # ac0 <malloc+0x1f8>
        while(*s != 0){
 776:	85ee                	mv	a1,s11
 778:	bff9                	j	756 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 77a:	008b0913          	addi	s2,s6,8
 77e:	000b4583          	lbu	a1,0(s6)
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	db2080e7          	jalr	-590(ra) # 536 <putc>
 78c:	8b4a                	mv	s6,s2
      state = 0;
 78e:	4981                	li	s3,0
 790:	bdd1                	j	664 <vprintf+0x60>
        putc(fd, c);
 792:	85d2                	mv	a1,s4
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	da0080e7          	jalr	-608(ra) # 536 <putc>
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	b5d1                	j	664 <vprintf+0x60>
        putc(fd, '%');
 7a2:	85d2                	mv	a1,s4
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	d90080e7          	jalr	-624(ra) # 536 <putc>
        putc(fd, c);
 7ae:	85ca                	mv	a1,s2
 7b0:	8556                	mv	a0,s5
 7b2:	00000097          	auipc	ra,0x0
 7b6:	d84080e7          	jalr	-636(ra) # 536 <putc>
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	b565                	j	664 <vprintf+0x60>
        s = va_arg(ap, char*);
 7be:	8b4a                	mv	s6,s2
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b54d                	j	664 <vprintf+0x60>
    }
  }
}
 7c4:	70e6                	ld	ra,120(sp)
 7c6:	7446                	ld	s0,112(sp)
 7c8:	74a6                	ld	s1,104(sp)
 7ca:	7906                	ld	s2,96(sp)
 7cc:	69e6                	ld	s3,88(sp)
 7ce:	6a46                	ld	s4,80(sp)
 7d0:	6aa6                	ld	s5,72(sp)
 7d2:	6b06                	ld	s6,64(sp)
 7d4:	7be2                	ld	s7,56(sp)
 7d6:	7c42                	ld	s8,48(sp)
 7d8:	7ca2                	ld	s9,40(sp)
 7da:	7d02                	ld	s10,32(sp)
 7dc:	6de2                	ld	s11,24(sp)
 7de:	6109                	addi	sp,sp,128
 7e0:	8082                	ret

00000000000007e2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7e2:	715d                	addi	sp,sp,-80
 7e4:	ec06                	sd	ra,24(sp)
 7e6:	e822                	sd	s0,16(sp)
 7e8:	1000                	addi	s0,sp,32
 7ea:	e010                	sd	a2,0(s0)
 7ec:	e414                	sd	a3,8(s0)
 7ee:	e818                	sd	a4,16(s0)
 7f0:	ec1c                	sd	a5,24(s0)
 7f2:	03043023          	sd	a6,32(s0)
 7f6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7fa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7fe:	8622                	mv	a2,s0
 800:	00000097          	auipc	ra,0x0
 804:	e04080e7          	jalr	-508(ra) # 604 <vprintf>
}
 808:	60e2                	ld	ra,24(sp)
 80a:	6442                	ld	s0,16(sp)
 80c:	6161                	addi	sp,sp,80
 80e:	8082                	ret

0000000000000810 <printf>:

void
printf(const char *fmt, ...)
{
 810:	711d                	addi	sp,sp,-96
 812:	ec06                	sd	ra,24(sp)
 814:	e822                	sd	s0,16(sp)
 816:	1000                	addi	s0,sp,32
 818:	e40c                	sd	a1,8(s0)
 81a:	e810                	sd	a2,16(s0)
 81c:	ec14                	sd	a3,24(s0)
 81e:	f018                	sd	a4,32(s0)
 820:	f41c                	sd	a5,40(s0)
 822:	03043823          	sd	a6,48(s0)
 826:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 82a:	00840613          	addi	a2,s0,8
 82e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 832:	85aa                	mv	a1,a0
 834:	4505                	li	a0,1
 836:	00000097          	auipc	ra,0x0
 83a:	dce080e7          	jalr	-562(ra) # 604 <vprintf>
}
 83e:	60e2                	ld	ra,24(sp)
 840:	6442                	ld	s0,16(sp)
 842:	6125                	addi	sp,sp,96
 844:	8082                	ret

0000000000000846 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 846:	1141                	addi	sp,sp,-16
 848:	e422                	sd	s0,8(sp)
 84a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 84c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 850:	00000797          	auipc	a5,0x0
 854:	2f07b783          	ld	a5,752(a5) # b40 <freep>
 858:	a02d                	j	882 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 85a:	4618                	lw	a4,8(a2)
 85c:	9f2d                	addw	a4,a4,a1
 85e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 862:	6398                	ld	a4,0(a5)
 864:	6310                	ld	a2,0(a4)
 866:	a83d                	j	8a4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 868:	ff852703          	lw	a4,-8(a0)
 86c:	9f31                	addw	a4,a4,a2
 86e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 870:	ff053683          	ld	a3,-16(a0)
 874:	a091                	j	8b8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 876:	6398                	ld	a4,0(a5)
 878:	00e7e463          	bltu	a5,a4,880 <free+0x3a>
 87c:	00e6ea63          	bltu	a3,a4,890 <free+0x4a>
{
 880:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 882:	fed7fae3          	bgeu	a5,a3,876 <free+0x30>
 886:	6398                	ld	a4,0(a5)
 888:	00e6e463          	bltu	a3,a4,890 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88c:	fee7eae3          	bltu	a5,a4,880 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 890:	ff852583          	lw	a1,-8(a0)
 894:	6390                	ld	a2,0(a5)
 896:	02059813          	slli	a6,a1,0x20
 89a:	01c85713          	srli	a4,a6,0x1c
 89e:	9736                	add	a4,a4,a3
 8a0:	fae60de3          	beq	a2,a4,85a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8a4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8a8:	4790                	lw	a2,8(a5)
 8aa:	02061593          	slli	a1,a2,0x20
 8ae:	01c5d713          	srli	a4,a1,0x1c
 8b2:	973e                	add	a4,a4,a5
 8b4:	fae68ae3          	beq	a3,a4,868 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8b8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ba:	00000717          	auipc	a4,0x0
 8be:	28f73323          	sd	a5,646(a4) # b40 <freep>
}
 8c2:	6422                	ld	s0,8(sp)
 8c4:	0141                	addi	sp,sp,16
 8c6:	8082                	ret

00000000000008c8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c8:	7139                	addi	sp,sp,-64
 8ca:	fc06                	sd	ra,56(sp)
 8cc:	f822                	sd	s0,48(sp)
 8ce:	f426                	sd	s1,40(sp)
 8d0:	f04a                	sd	s2,32(sp)
 8d2:	ec4e                	sd	s3,24(sp)
 8d4:	e852                	sd	s4,16(sp)
 8d6:	e456                	sd	s5,8(sp)
 8d8:	e05a                	sd	s6,0(sp)
 8da:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8dc:	02051493          	slli	s1,a0,0x20
 8e0:	9081                	srli	s1,s1,0x20
 8e2:	04bd                	addi	s1,s1,15
 8e4:	8091                	srli	s1,s1,0x4
 8e6:	0014899b          	addiw	s3,s1,1
 8ea:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8ec:	00000517          	auipc	a0,0x0
 8f0:	25453503          	ld	a0,596(a0) # b40 <freep>
 8f4:	c515                	beqz	a0,920 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f8:	4798                	lw	a4,8(a5)
 8fa:	02977f63          	bgeu	a4,s1,938 <malloc+0x70>
 8fe:	8a4e                	mv	s4,s3
 900:	0009871b          	sext.w	a4,s3
 904:	6685                	lui	a3,0x1
 906:	00d77363          	bgeu	a4,a3,90c <malloc+0x44>
 90a:	6a05                	lui	s4,0x1
 90c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 910:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 914:	00000917          	auipc	s2,0x0
 918:	22c90913          	addi	s2,s2,556 # b40 <freep>
  if(p == (char*)-1)
 91c:	5afd                	li	s5,-1
 91e:	a895                	j	992 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 920:	00000797          	auipc	a5,0x0
 924:	22878793          	addi	a5,a5,552 # b48 <base>
 928:	00000717          	auipc	a4,0x0
 92c:	20f73c23          	sd	a5,536(a4) # b40 <freep>
 930:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 932:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 936:	b7e1                	j	8fe <malloc+0x36>
      if(p->s.size == nunits)
 938:	02e48c63          	beq	s1,a4,970 <malloc+0xa8>
        p->s.size -= nunits;
 93c:	4137073b          	subw	a4,a4,s3
 940:	c798                	sw	a4,8(a5)
        p += p->s.size;
 942:	02071693          	slli	a3,a4,0x20
 946:	01c6d713          	srli	a4,a3,0x1c
 94a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 94c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 950:	00000717          	auipc	a4,0x0
 954:	1ea73823          	sd	a0,496(a4) # b40 <freep>
      return (void*)(p + 1);
 958:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 95c:	70e2                	ld	ra,56(sp)
 95e:	7442                	ld	s0,48(sp)
 960:	74a2                	ld	s1,40(sp)
 962:	7902                	ld	s2,32(sp)
 964:	69e2                	ld	s3,24(sp)
 966:	6a42                	ld	s4,16(sp)
 968:	6aa2                	ld	s5,8(sp)
 96a:	6b02                	ld	s6,0(sp)
 96c:	6121                	addi	sp,sp,64
 96e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 970:	6398                	ld	a4,0(a5)
 972:	e118                	sd	a4,0(a0)
 974:	bff1                	j	950 <malloc+0x88>
  hp->s.size = nu;
 976:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 97a:	0541                	addi	a0,a0,16
 97c:	00000097          	auipc	ra,0x0
 980:	eca080e7          	jalr	-310(ra) # 846 <free>
  return freep;
 984:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 988:	d971                	beqz	a0,95c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98c:	4798                	lw	a4,8(a5)
 98e:	fa9775e3          	bgeu	a4,s1,938 <malloc+0x70>
    if(p == freep)
 992:	00093703          	ld	a4,0(s2)
 996:	853e                	mv	a0,a5
 998:	fef719e3          	bne	a4,a5,98a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 99c:	8552                	mv	a0,s4
 99e:	00000097          	auipc	ra,0x0
 9a2:	b70080e7          	jalr	-1168(ra) # 50e <sbrk>
  if(p == (char*)-1)
 9a6:	fd5518e3          	bne	a0,s5,976 <malloc+0xae>
        return 0;
 9aa:	4501                	li	a0,0
 9ac:	bf45                	j	95c <malloc+0x94>
