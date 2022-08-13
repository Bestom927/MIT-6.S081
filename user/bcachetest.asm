
user/_bcachetest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <createfile>:
  exit(0);
}

void
createfile(char *file, int nblock)
{
   0:	bd010113          	addi	sp,sp,-1072
   4:	42113423          	sd	ra,1064(sp)
   8:	42813023          	sd	s0,1056(sp)
   c:	40913c23          	sd	s1,1048(sp)
  10:	41213823          	sd	s2,1040(sp)
  14:	41313423          	sd	s3,1032(sp)
  18:	41413023          	sd	s4,1024(sp)
  1c:	43010413          	addi	s0,sp,1072
  20:	8a2a                	mv	s4,a0
  22:	89ae                	mv	s3,a1
  int fd;
  char buf[BSIZE];
  int i;
  
  fd = open(file, O_CREATE | O_RDWR);
  24:	20200593          	li	a1,514
  28:	00000097          	auipc	ra,0x0
  2c:	7e2080e7          	jalr	2018(ra) # 80a <open>
  if(fd < 0){
  30:	04054a63          	bltz	a0,84 <createfile+0x84>
  34:	892a                	mv	s2,a0
    printf("createfile %s failed\n", file);
    exit(-1);
  }
  for(i = 0; i < nblock; i++) {
  36:	4481                	li	s1,0
  38:	03305263          	blez	s3,5c <createfile+0x5c>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
  3c:	40000613          	li	a2,1024
  40:	bd040593          	addi	a1,s0,-1072
  44:	854a                	mv	a0,s2
  46:	00000097          	auipc	ra,0x0
  4a:	7a4080e7          	jalr	1956(ra) # 7ea <write>
  4e:	40000793          	li	a5,1024
  52:	04f51763          	bne	a0,a5,a0 <createfile+0xa0>
  for(i = 0; i < nblock; i++) {
  56:	2485                	addiw	s1,s1,1
  58:	fe9992e3          	bne	s3,s1,3c <createfile+0x3c>
      printf("write %s failed\n", file);
      exit(-1);
    }
  }
  close(fd);
  5c:	854a                	mv	a0,s2
  5e:	00000097          	auipc	ra,0x0
  62:	794080e7          	jalr	1940(ra) # 7f2 <close>
}
  66:	42813083          	ld	ra,1064(sp)
  6a:	42013403          	ld	s0,1056(sp)
  6e:	41813483          	ld	s1,1048(sp)
  72:	41013903          	ld	s2,1040(sp)
  76:	40813983          	ld	s3,1032(sp)
  7a:	40013a03          	ld	s4,1024(sp)
  7e:	43010113          	addi	sp,sp,1072
  82:	8082                	ret
    printf("createfile %s failed\n", file);
  84:	85d2                	mv	a1,s4
  86:	00001517          	auipc	a0,0x1
  8a:	ce250513          	addi	a0,a0,-798 # d68 <statistics+0x86>
  8e:	00001097          	auipc	ra,0x1
  92:	ab6080e7          	jalr	-1354(ra) # b44 <printf>
    exit(-1);
  96:	557d                	li	a0,-1
  98:	00000097          	auipc	ra,0x0
  9c:	732080e7          	jalr	1842(ra) # 7ca <exit>
      printf("write %s failed\n", file);
  a0:	85d2                	mv	a1,s4
  a2:	00001517          	auipc	a0,0x1
  a6:	cde50513          	addi	a0,a0,-802 # d80 <statistics+0x9e>
  aa:	00001097          	auipc	ra,0x1
  ae:	a9a080e7          	jalr	-1382(ra) # b44 <printf>
      exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	716080e7          	jalr	1814(ra) # 7ca <exit>

00000000000000bc <readfile>:

void
readfile(char *file, int nbytes, int inc)
{
  bc:	bc010113          	addi	sp,sp,-1088
  c0:	42113c23          	sd	ra,1080(sp)
  c4:	42813823          	sd	s0,1072(sp)
  c8:	42913423          	sd	s1,1064(sp)
  cc:	43213023          	sd	s2,1056(sp)
  d0:	41313c23          	sd	s3,1048(sp)
  d4:	41413823          	sd	s4,1040(sp)
  d8:	41513423          	sd	s5,1032(sp)
  dc:	44010413          	addi	s0,sp,1088
  char buf[BSIZE];
  int fd;
  int i;

  if(inc > BSIZE) {
  e0:	40000793          	li	a5,1024
  e4:	06c7c463          	blt	a5,a2,14c <readfile+0x90>
  e8:	8aaa                	mv	s5,a0
  ea:	8a2e                	mv	s4,a1
  ec:	84b2                	mv	s1,a2
    printf("readfile: inc too large\n");
    exit(-1);
  }
  if ((fd = open(file, O_RDONLY)) < 0) {
  ee:	4581                	li	a1,0
  f0:	00000097          	auipc	ra,0x0
  f4:	71a080e7          	jalr	1818(ra) # 80a <open>
  f8:	89aa                	mv	s3,a0
  fa:	06054663          	bltz	a0,166 <readfile+0xaa>
    printf("readfile open %s failed\n", file);
    exit(-1);
  }
  for (i = 0; i < nbytes; i += inc) {
  fe:	4901                	li	s2,0
 100:	03405063          	blez	s4,120 <readfile+0x64>
    if(read(fd, buf, inc) != inc) {
 104:	8626                	mv	a2,s1
 106:	bc040593          	addi	a1,s0,-1088
 10a:	854e                	mv	a0,s3
 10c:	00000097          	auipc	ra,0x0
 110:	6d6080e7          	jalr	1750(ra) # 7e2 <read>
 114:	06951763          	bne	a0,s1,182 <readfile+0xc6>
  for (i = 0; i < nbytes; i += inc) {
 118:	0124893b          	addw	s2,s1,s2
 11c:	ff4944e3          	blt	s2,s4,104 <readfile+0x48>
      printf("read %s failed for block %d (%d)\n", file, i, nbytes);
      exit(-1);
    }
  }
  close(fd);
 120:	854e                	mv	a0,s3
 122:	00000097          	auipc	ra,0x0
 126:	6d0080e7          	jalr	1744(ra) # 7f2 <close>
}
 12a:	43813083          	ld	ra,1080(sp)
 12e:	43013403          	ld	s0,1072(sp)
 132:	42813483          	ld	s1,1064(sp)
 136:	42013903          	ld	s2,1056(sp)
 13a:	41813983          	ld	s3,1048(sp)
 13e:	41013a03          	ld	s4,1040(sp)
 142:	40813a83          	ld	s5,1032(sp)
 146:	44010113          	addi	sp,sp,1088
 14a:	8082                	ret
    printf("readfile: inc too large\n");
 14c:	00001517          	auipc	a0,0x1
 150:	c4c50513          	addi	a0,a0,-948 # d98 <statistics+0xb6>
 154:	00001097          	auipc	ra,0x1
 158:	9f0080e7          	jalr	-1552(ra) # b44 <printf>
    exit(-1);
 15c:	557d                	li	a0,-1
 15e:	00000097          	auipc	ra,0x0
 162:	66c080e7          	jalr	1644(ra) # 7ca <exit>
    printf("readfile open %s failed\n", file);
 166:	85d6                	mv	a1,s5
 168:	00001517          	auipc	a0,0x1
 16c:	c5050513          	addi	a0,a0,-944 # db8 <statistics+0xd6>
 170:	00001097          	auipc	ra,0x1
 174:	9d4080e7          	jalr	-1580(ra) # b44 <printf>
    exit(-1);
 178:	557d                	li	a0,-1
 17a:	00000097          	auipc	ra,0x0
 17e:	650080e7          	jalr	1616(ra) # 7ca <exit>
      printf("read %s failed for block %d (%d)\n", file, i, nbytes);
 182:	86d2                	mv	a3,s4
 184:	864a                	mv	a2,s2
 186:	85d6                	mv	a1,s5
 188:	00001517          	auipc	a0,0x1
 18c:	c5050513          	addi	a0,a0,-944 # dd8 <statistics+0xf6>
 190:	00001097          	auipc	ra,0x1
 194:	9b4080e7          	jalr	-1612(ra) # b44 <printf>
      exit(-1);
 198:	557d                	li	a0,-1
 19a:	00000097          	auipc	ra,0x0
 19e:	630080e7          	jalr	1584(ra) # 7ca <exit>

00000000000001a2 <ntas>:

int ntas(int print)
{
 1a2:	1101                	addi	sp,sp,-32
 1a4:	ec06                	sd	ra,24(sp)
 1a6:	e822                	sd	s0,16(sp)
 1a8:	e426                	sd	s1,8(sp)
 1aa:	e04a                	sd	s2,0(sp)
 1ac:	1000                	addi	s0,sp,32
 1ae:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
 1b0:	6585                	lui	a1,0x1
 1b2:	00001517          	auipc	a0,0x1
 1b6:	d9650513          	addi	a0,a0,-618 # f48 <buf>
 1ba:	00001097          	auipc	ra,0x1
 1be:	b28080e7          	jalr	-1240(ra) # ce2 <statistics>
 1c2:	02a05b63          	blez	a0,1f8 <ntas+0x56>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
 1c6:	03d00593          	li	a1,61
 1ca:	00001517          	auipc	a0,0x1
 1ce:	d7e50513          	addi	a0,a0,-642 # f48 <buf>
 1d2:	00000097          	auipc	ra,0x0
 1d6:	420080e7          	jalr	1056(ra) # 5f2 <strchr>
  n = atoi(c+2);
 1da:	0509                	addi	a0,a0,2
 1dc:	00000097          	auipc	ra,0x0
 1e0:	4f4080e7          	jalr	1268(ra) # 6d0 <atoi>
 1e4:	84aa                	mv	s1,a0
  if(print)
 1e6:	02091363          	bnez	s2,20c <ntas+0x6a>
    printf("%s", buf);
  return n;
}
 1ea:	8526                	mv	a0,s1
 1ec:	60e2                	ld	ra,24(sp)
 1ee:	6442                	ld	s0,16(sp)
 1f0:	64a2                	ld	s1,8(sp)
 1f2:	6902                	ld	s2,0(sp)
 1f4:	6105                	addi	sp,sp,32
 1f6:	8082                	ret
    fprintf(2, "ntas: no stats\n");
 1f8:	00001597          	auipc	a1,0x1
 1fc:	c0858593          	addi	a1,a1,-1016 # e00 <statistics+0x11e>
 200:	4509                	li	a0,2
 202:	00001097          	auipc	ra,0x1
 206:	914080e7          	jalr	-1772(ra) # b16 <fprintf>
 20a:	bf75                	j	1c6 <ntas+0x24>
    printf("%s", buf);
 20c:	00001597          	auipc	a1,0x1
 210:	d3c58593          	addi	a1,a1,-708 # f48 <buf>
 214:	00001517          	auipc	a0,0x1
 218:	bfc50513          	addi	a0,a0,-1028 # e10 <statistics+0x12e>
 21c:	00001097          	auipc	ra,0x1
 220:	928080e7          	jalr	-1752(ra) # b44 <printf>
 224:	b7d9                	j	1ea <ntas+0x48>

0000000000000226 <test0>:

void
test0()
{
 226:	7139                	addi	sp,sp,-64
 228:	fc06                	sd	ra,56(sp)
 22a:	f822                	sd	s0,48(sp)
 22c:	f426                	sd	s1,40(sp)
 22e:	f04a                	sd	s2,32(sp)
 230:	ec4e                	sd	s3,24(sp)
 232:	0080                	addi	s0,sp,64
  char file[2];
  char dir[2];
  enum { N = 10, NCHILD = 3 };
  int m, n;

  dir[0] = '0';
 234:	03000793          	li	a5,48
 238:	fcf40023          	sb	a5,-64(s0)
  dir[1] = '\0';
 23c:	fc0400a3          	sb	zero,-63(s0)
  file[0] = 'F';
 240:	04600793          	li	a5,70
 244:	fcf40423          	sb	a5,-56(s0)
  file[1] = '\0';
 248:	fc0404a3          	sb	zero,-55(s0)

  printf("start test0\n");
 24c:	00001517          	auipc	a0,0x1
 250:	bcc50513          	addi	a0,a0,-1076 # e18 <statistics+0x136>
 254:	00001097          	auipc	ra,0x1
 258:	8f0080e7          	jalr	-1808(ra) # b44 <printf>
 25c:	03000493          	li	s1,48
      printf("chdir failed\n");
      exit(1);
    }
    unlink(file);
    createfile(file, N);
    if (chdir("..") < 0) {
 260:	00001997          	auipc	s3,0x1
 264:	bd898993          	addi	s3,s3,-1064 # e38 <statistics+0x156>
  for(int i = 0; i < NCHILD; i++){
 268:	03300913          	li	s2,51
    dir[0] = '0' + i;
 26c:	fc940023          	sb	s1,-64(s0)
    mkdir(dir);
 270:	fc040513          	addi	a0,s0,-64
 274:	00000097          	auipc	ra,0x0
 278:	5be080e7          	jalr	1470(ra) # 832 <mkdir>
    if (chdir(dir) < 0) {
 27c:	fc040513          	addi	a0,s0,-64
 280:	00000097          	auipc	ra,0x0
 284:	5ba080e7          	jalr	1466(ra) # 83a <chdir>
 288:	0c054463          	bltz	a0,350 <test0+0x12a>
    unlink(file);
 28c:	fc840513          	addi	a0,s0,-56
 290:	00000097          	auipc	ra,0x0
 294:	58a080e7          	jalr	1418(ra) # 81a <unlink>
    createfile(file, N);
 298:	45a9                	li	a1,10
 29a:	fc840513          	addi	a0,s0,-56
 29e:	00000097          	auipc	ra,0x0
 2a2:	d62080e7          	jalr	-670(ra) # 0 <createfile>
    if (chdir("..") < 0) {
 2a6:	854e                	mv	a0,s3
 2a8:	00000097          	auipc	ra,0x0
 2ac:	592080e7          	jalr	1426(ra) # 83a <chdir>
 2b0:	0a054d63          	bltz	a0,36a <test0+0x144>
  for(int i = 0; i < NCHILD; i++){
 2b4:	2485                	addiw	s1,s1,1
 2b6:	0ff4f493          	zext.b	s1,s1
 2ba:	fb2499e3          	bne	s1,s2,26c <test0+0x46>
      printf("chdir failed\n");
      exit(1);
    }
  }
  m = ntas(0);
 2be:	4501                	li	a0,0
 2c0:	00000097          	auipc	ra,0x0
 2c4:	ee2080e7          	jalr	-286(ra) # 1a2 <ntas>
 2c8:	892a                	mv	s2,a0
 2ca:	03000493          	li	s1,48
  for(int i = 0; i < NCHILD; i++){
 2ce:	03300993          	li	s3,51
    dir[0] = '0' + i;
 2d2:	fc940023          	sb	s1,-64(s0)
    int pid = fork();
 2d6:	00000097          	auipc	ra,0x0
 2da:	4ec080e7          	jalr	1260(ra) # 7c2 <fork>
    if(pid < 0){
 2de:	0a054363          	bltz	a0,384 <test0+0x15e>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 2e2:	cd55                	beqz	a0,39e <test0+0x178>
  for(int i = 0; i < NCHILD; i++){
 2e4:	2485                	addiw	s1,s1,1
 2e6:	0ff4f493          	zext.b	s1,s1
 2ea:	ff3494e3          	bne	s1,s3,2d2 <test0+0xac>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 2ee:	4501                	li	a0,0
 2f0:	00000097          	auipc	ra,0x0
 2f4:	4e2080e7          	jalr	1250(ra) # 7d2 <wait>
 2f8:	4501                	li	a0,0
 2fa:	00000097          	auipc	ra,0x0
 2fe:	4d8080e7          	jalr	1240(ra) # 7d2 <wait>
 302:	4501                	li	a0,0
 304:	00000097          	auipc	ra,0x0
 308:	4ce080e7          	jalr	1230(ra) # 7d2 <wait>
  }
  printf("test0 results:\n");
 30c:	00001517          	auipc	a0,0x1
 310:	b4450513          	addi	a0,a0,-1212 # e50 <statistics+0x16e>
 314:	00001097          	auipc	ra,0x1
 318:	830080e7          	jalr	-2000(ra) # b44 <printf>
  n = ntas(1);
 31c:	4505                	li	a0,1
 31e:	00000097          	auipc	ra,0x0
 322:	e84080e7          	jalr	-380(ra) # 1a2 <ntas>
  if (n-m < 500)
 326:	4125053b          	subw	a0,a0,s2
 32a:	1f300793          	li	a5,499
 32e:	0aa7cc63          	blt	a5,a0,3e6 <test0+0x1c0>
    printf("test0: OK\n");
 332:	00001517          	auipc	a0,0x1
 336:	b2e50513          	addi	a0,a0,-1234 # e60 <statistics+0x17e>
 33a:	00001097          	auipc	ra,0x1
 33e:	80a080e7          	jalr	-2038(ra) # b44 <printf>
  else
    printf("test0: FAIL\n");
}
 342:	70e2                	ld	ra,56(sp)
 344:	7442                	ld	s0,48(sp)
 346:	74a2                	ld	s1,40(sp)
 348:	7902                	ld	s2,32(sp)
 34a:	69e2                	ld	s3,24(sp)
 34c:	6121                	addi	sp,sp,64
 34e:	8082                	ret
      printf("chdir failed\n");
 350:	00001517          	auipc	a0,0x1
 354:	ad850513          	addi	a0,a0,-1320 # e28 <statistics+0x146>
 358:	00000097          	auipc	ra,0x0
 35c:	7ec080e7          	jalr	2028(ra) # b44 <printf>
      exit(1);
 360:	4505                	li	a0,1
 362:	00000097          	auipc	ra,0x0
 366:	468080e7          	jalr	1128(ra) # 7ca <exit>
      printf("chdir failed\n");
 36a:	00001517          	auipc	a0,0x1
 36e:	abe50513          	addi	a0,a0,-1346 # e28 <statistics+0x146>
 372:	00000097          	auipc	ra,0x0
 376:	7d2080e7          	jalr	2002(ra) # b44 <printf>
      exit(1);
 37a:	4505                	li	a0,1
 37c:	00000097          	auipc	ra,0x0
 380:	44e080e7          	jalr	1102(ra) # 7ca <exit>
      printf("fork failed");
 384:	00001517          	auipc	a0,0x1
 388:	abc50513          	addi	a0,a0,-1348 # e40 <statistics+0x15e>
 38c:	00000097          	auipc	ra,0x0
 390:	7b8080e7          	jalr	1976(ra) # b44 <printf>
      exit(-1);
 394:	557d                	li	a0,-1
 396:	00000097          	auipc	ra,0x0
 39a:	434080e7          	jalr	1076(ra) # 7ca <exit>
      if (chdir(dir) < 0) {
 39e:	fc040513          	addi	a0,s0,-64
 3a2:	00000097          	auipc	ra,0x0
 3a6:	498080e7          	jalr	1176(ra) # 83a <chdir>
 3aa:	02054163          	bltz	a0,3cc <test0+0x1a6>
      readfile(file, N*BSIZE, 1);
 3ae:	4605                	li	a2,1
 3b0:	658d                	lui	a1,0x3
 3b2:	80058593          	addi	a1,a1,-2048 # 2800 <__BSS_END__+0x8a8>
 3b6:	fc840513          	addi	a0,s0,-56
 3ba:	00000097          	auipc	ra,0x0
 3be:	d02080e7          	jalr	-766(ra) # bc <readfile>
      exit(0);
 3c2:	4501                	li	a0,0
 3c4:	00000097          	auipc	ra,0x0
 3c8:	406080e7          	jalr	1030(ra) # 7ca <exit>
        printf("chdir failed\n");
 3cc:	00001517          	auipc	a0,0x1
 3d0:	a5c50513          	addi	a0,a0,-1444 # e28 <statistics+0x146>
 3d4:	00000097          	auipc	ra,0x0
 3d8:	770080e7          	jalr	1904(ra) # b44 <printf>
        exit(1);
 3dc:	4505                	li	a0,1
 3de:	00000097          	auipc	ra,0x0
 3e2:	3ec080e7          	jalr	1004(ra) # 7ca <exit>
    printf("test0: FAIL\n");
 3e6:	00001517          	auipc	a0,0x1
 3ea:	a8a50513          	addi	a0,a0,-1398 # e70 <statistics+0x18e>
 3ee:	00000097          	auipc	ra,0x0
 3f2:	756080e7          	jalr	1878(ra) # b44 <printf>
}
 3f6:	b7b1                	j	342 <test0+0x11c>

00000000000003f8 <test1>:

void test1()
{
 3f8:	7179                	addi	sp,sp,-48
 3fa:	f406                	sd	ra,40(sp)
 3fc:	f022                	sd	s0,32(sp)
 3fe:	ec26                	sd	s1,24(sp)
 400:	e84a                	sd	s2,16(sp)
 402:	1800                	addi	s0,sp,48
  char file[3];
  enum { N = 100, BIG=100, NCHILD=2 };
  
  printf("start test1\n");
 404:	00001517          	auipc	a0,0x1
 408:	a7c50513          	addi	a0,a0,-1412 # e80 <statistics+0x19e>
 40c:	00000097          	auipc	ra,0x0
 410:	738080e7          	jalr	1848(ra) # b44 <printf>
  file[0] = 'B';
 414:	04200793          	li	a5,66
 418:	fcf40c23          	sb	a5,-40(s0)
  file[2] = '\0';
 41c:	fc040d23          	sb	zero,-38(s0)
 420:	4485                	li	s1,1
  for(int i = 0; i < NCHILD; i++){
    file[1] = '0' + i;
    unlink(file);
    if (i == 0) {
 422:	4905                	li	s2,1
 424:	a811                	j	438 <test1+0x40>
      createfile(file, BIG);
 426:	06400593          	li	a1,100
 42a:	fd840513          	addi	a0,s0,-40
 42e:	00000097          	auipc	ra,0x0
 432:	bd2080e7          	jalr	-1070(ra) # 0 <createfile>
  for(int i = 0; i < NCHILD; i++){
 436:	2485                	addiw	s1,s1,1
    file[1] = '0' + i;
 438:	02f4879b          	addiw	a5,s1,47
 43c:	fcf40ca3          	sb	a5,-39(s0)
    unlink(file);
 440:	fd840513          	addi	a0,s0,-40
 444:	00000097          	auipc	ra,0x0
 448:	3d6080e7          	jalr	982(ra) # 81a <unlink>
    if (i == 0) {
 44c:	fd248de3          	beq	s1,s2,426 <test1+0x2e>
    } else {
      createfile(file, 1);
 450:	85ca                	mv	a1,s2
 452:	fd840513          	addi	a0,s0,-40
 456:	00000097          	auipc	ra,0x0
 45a:	baa080e7          	jalr	-1110(ra) # 0 <createfile>
  for(int i = 0; i < NCHILD; i++){
 45e:	0004879b          	sext.w	a5,s1
 462:	fcf95ae3          	bge	s2,a5,436 <test1+0x3e>
    }
  }
  for(int i = 0; i < NCHILD; i++){
    file[1] = '0' + i;
 466:	03000793          	li	a5,48
 46a:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
 46e:	00000097          	auipc	ra,0x0
 472:	354080e7          	jalr	852(ra) # 7c2 <fork>
    if(pid < 0){
 476:	04054663          	bltz	a0,4c2 <test1+0xca>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 47a:	c12d                	beqz	a0,4dc <test1+0xe4>
    file[1] = '0' + i;
 47c:	03100793          	li	a5,49
 480:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
 484:	00000097          	auipc	ra,0x0
 488:	33e080e7          	jalr	830(ra) # 7c2 <fork>
    if(pid < 0){
 48c:	02054b63          	bltz	a0,4c2 <test1+0xca>
    if(pid == 0){
 490:	cd35                	beqz	a0,50c <test1+0x114>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 492:	4501                	li	a0,0
 494:	00000097          	auipc	ra,0x0
 498:	33e080e7          	jalr	830(ra) # 7d2 <wait>
 49c:	4501                	li	a0,0
 49e:	00000097          	auipc	ra,0x0
 4a2:	334080e7          	jalr	820(ra) # 7d2 <wait>
  }
  printf("test1 OK\n");
 4a6:	00001517          	auipc	a0,0x1
 4aa:	9ea50513          	addi	a0,a0,-1558 # e90 <statistics+0x1ae>
 4ae:	00000097          	auipc	ra,0x0
 4b2:	696080e7          	jalr	1686(ra) # b44 <printf>
}
 4b6:	70a2                	ld	ra,40(sp)
 4b8:	7402                	ld	s0,32(sp)
 4ba:	64e2                	ld	s1,24(sp)
 4bc:	6942                	ld	s2,16(sp)
 4be:	6145                	addi	sp,sp,48
 4c0:	8082                	ret
      printf("fork failed");
 4c2:	00001517          	auipc	a0,0x1
 4c6:	97e50513          	addi	a0,a0,-1666 # e40 <statistics+0x15e>
 4ca:	00000097          	auipc	ra,0x0
 4ce:	67a080e7          	jalr	1658(ra) # b44 <printf>
      exit(-1);
 4d2:	557d                	li	a0,-1
 4d4:	00000097          	auipc	ra,0x0
 4d8:	2f6080e7          	jalr	758(ra) # 7ca <exit>
    if(pid == 0){
 4dc:	06400493          	li	s1,100
          readfile(file, BIG*BSIZE, BSIZE);
 4e0:	40000613          	li	a2,1024
 4e4:	65e5                	lui	a1,0x19
 4e6:	fd840513          	addi	a0,s0,-40
 4ea:	00000097          	auipc	ra,0x0
 4ee:	bd2080e7          	jalr	-1070(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
 4f2:	34fd                	addiw	s1,s1,-1
 4f4:	f4f5                	bnez	s1,4e0 <test1+0xe8>
        unlink(file);
 4f6:	fd840513          	addi	a0,s0,-40
 4fa:	00000097          	auipc	ra,0x0
 4fe:	320080e7          	jalr	800(ra) # 81a <unlink>
        exit(0);
 502:	4501                	li	a0,0
 504:	00000097          	auipc	ra,0x0
 508:	2c6080e7          	jalr	710(ra) # 7ca <exit>
 50c:	06400493          	li	s1,100
          readfile(file, 1, BSIZE);
 510:	40000613          	li	a2,1024
 514:	4585                	li	a1,1
 516:	fd840513          	addi	a0,s0,-40
 51a:	00000097          	auipc	ra,0x0
 51e:	ba2080e7          	jalr	-1118(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
 522:	34fd                	addiw	s1,s1,-1
 524:	f4f5                	bnez	s1,510 <test1+0x118>
        unlink(file);
 526:	fd840513          	addi	a0,s0,-40
 52a:	00000097          	auipc	ra,0x0
 52e:	2f0080e7          	jalr	752(ra) # 81a <unlink>
      exit(0);
 532:	4501                	li	a0,0
 534:	00000097          	auipc	ra,0x0
 538:	296080e7          	jalr	662(ra) # 7ca <exit>

000000000000053c <main>:
{
 53c:	1141                	addi	sp,sp,-16
 53e:	e406                	sd	ra,8(sp)
 540:	e022                	sd	s0,0(sp)
 542:	0800                	addi	s0,sp,16
  test0();
 544:	00000097          	auipc	ra,0x0
 548:	ce2080e7          	jalr	-798(ra) # 226 <test0>
  test1();
 54c:	00000097          	auipc	ra,0x0
 550:	eac080e7          	jalr	-340(ra) # 3f8 <test1>
  exit(0);
 554:	4501                	li	a0,0
 556:	00000097          	auipc	ra,0x0
 55a:	274080e7          	jalr	628(ra) # 7ca <exit>

000000000000055e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 55e:	1141                	addi	sp,sp,-16
 560:	e422                	sd	s0,8(sp)
 562:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 564:	87aa                	mv	a5,a0
 566:	0585                	addi	a1,a1,1 # 19001 <__BSS_END__+0x170a9>
 568:	0785                	addi	a5,a5,1
 56a:	fff5c703          	lbu	a4,-1(a1)
 56e:	fee78fa3          	sb	a4,-1(a5)
 572:	fb75                	bnez	a4,566 <strcpy+0x8>
    ;
  return os;
}
 574:	6422                	ld	s0,8(sp)
 576:	0141                	addi	sp,sp,16
 578:	8082                	ret

000000000000057a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 57a:	1141                	addi	sp,sp,-16
 57c:	e422                	sd	s0,8(sp)
 57e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 580:	00054783          	lbu	a5,0(a0)
 584:	cb91                	beqz	a5,598 <strcmp+0x1e>
 586:	0005c703          	lbu	a4,0(a1)
 58a:	00f71763          	bne	a4,a5,598 <strcmp+0x1e>
    p++, q++;
 58e:	0505                	addi	a0,a0,1
 590:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 592:	00054783          	lbu	a5,0(a0)
 596:	fbe5                	bnez	a5,586 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 598:	0005c503          	lbu	a0,0(a1)
}
 59c:	40a7853b          	subw	a0,a5,a0
 5a0:	6422                	ld	s0,8(sp)
 5a2:	0141                	addi	sp,sp,16
 5a4:	8082                	ret

00000000000005a6 <strlen>:

uint
strlen(const char *s)
{
 5a6:	1141                	addi	sp,sp,-16
 5a8:	e422                	sd	s0,8(sp)
 5aa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 5ac:	00054783          	lbu	a5,0(a0)
 5b0:	cf91                	beqz	a5,5cc <strlen+0x26>
 5b2:	0505                	addi	a0,a0,1
 5b4:	87aa                	mv	a5,a0
 5b6:	4685                	li	a3,1
 5b8:	9e89                	subw	a3,a3,a0
 5ba:	00f6853b          	addw	a0,a3,a5
 5be:	0785                	addi	a5,a5,1
 5c0:	fff7c703          	lbu	a4,-1(a5)
 5c4:	fb7d                	bnez	a4,5ba <strlen+0x14>
    ;
  return n;
}
 5c6:	6422                	ld	s0,8(sp)
 5c8:	0141                	addi	sp,sp,16
 5ca:	8082                	ret
  for(n = 0; s[n]; n++)
 5cc:	4501                	li	a0,0
 5ce:	bfe5                	j	5c6 <strlen+0x20>

00000000000005d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5d0:	1141                	addi	sp,sp,-16
 5d2:	e422                	sd	s0,8(sp)
 5d4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5d6:	ca19                	beqz	a2,5ec <memset+0x1c>
 5d8:	87aa                	mv	a5,a0
 5da:	1602                	slli	a2,a2,0x20
 5dc:	9201                	srli	a2,a2,0x20
 5de:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5e2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5e6:	0785                	addi	a5,a5,1
 5e8:	fee79de3          	bne	a5,a4,5e2 <memset+0x12>
  }
  return dst;
}
 5ec:	6422                	ld	s0,8(sp)
 5ee:	0141                	addi	sp,sp,16
 5f0:	8082                	ret

00000000000005f2 <strchr>:

char*
strchr(const char *s, char c)
{
 5f2:	1141                	addi	sp,sp,-16
 5f4:	e422                	sd	s0,8(sp)
 5f6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 5f8:	00054783          	lbu	a5,0(a0)
 5fc:	cb99                	beqz	a5,612 <strchr+0x20>
    if(*s == c)
 5fe:	00f58763          	beq	a1,a5,60c <strchr+0x1a>
  for(; *s; s++)
 602:	0505                	addi	a0,a0,1
 604:	00054783          	lbu	a5,0(a0)
 608:	fbfd                	bnez	a5,5fe <strchr+0xc>
      return (char*)s;
  return 0;
 60a:	4501                	li	a0,0
}
 60c:	6422                	ld	s0,8(sp)
 60e:	0141                	addi	sp,sp,16
 610:	8082                	ret
  return 0;
 612:	4501                	li	a0,0
 614:	bfe5                	j	60c <strchr+0x1a>

0000000000000616 <gets>:

char*
gets(char *buf, int max)
{
 616:	711d                	addi	sp,sp,-96
 618:	ec86                	sd	ra,88(sp)
 61a:	e8a2                	sd	s0,80(sp)
 61c:	e4a6                	sd	s1,72(sp)
 61e:	e0ca                	sd	s2,64(sp)
 620:	fc4e                	sd	s3,56(sp)
 622:	f852                	sd	s4,48(sp)
 624:	f456                	sd	s5,40(sp)
 626:	f05a                	sd	s6,32(sp)
 628:	ec5e                	sd	s7,24(sp)
 62a:	1080                	addi	s0,sp,96
 62c:	8baa                	mv	s7,a0
 62e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 630:	892a                	mv	s2,a0
 632:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 634:	4aa9                	li	s5,10
 636:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 638:	89a6                	mv	s3,s1
 63a:	2485                	addiw	s1,s1,1
 63c:	0344d863          	bge	s1,s4,66c <gets+0x56>
    cc = read(0, &c, 1);
 640:	4605                	li	a2,1
 642:	faf40593          	addi	a1,s0,-81
 646:	4501                	li	a0,0
 648:	00000097          	auipc	ra,0x0
 64c:	19a080e7          	jalr	410(ra) # 7e2 <read>
    if(cc < 1)
 650:	00a05e63          	blez	a0,66c <gets+0x56>
    buf[i++] = c;
 654:	faf44783          	lbu	a5,-81(s0)
 658:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 65c:	01578763          	beq	a5,s5,66a <gets+0x54>
 660:	0905                	addi	s2,s2,1
 662:	fd679be3          	bne	a5,s6,638 <gets+0x22>
  for(i=0; i+1 < max; ){
 666:	89a6                	mv	s3,s1
 668:	a011                	j	66c <gets+0x56>
 66a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 66c:	99de                	add	s3,s3,s7
 66e:	00098023          	sb	zero,0(s3)
  return buf;
}
 672:	855e                	mv	a0,s7
 674:	60e6                	ld	ra,88(sp)
 676:	6446                	ld	s0,80(sp)
 678:	64a6                	ld	s1,72(sp)
 67a:	6906                	ld	s2,64(sp)
 67c:	79e2                	ld	s3,56(sp)
 67e:	7a42                	ld	s4,48(sp)
 680:	7aa2                	ld	s5,40(sp)
 682:	7b02                	ld	s6,32(sp)
 684:	6be2                	ld	s7,24(sp)
 686:	6125                	addi	sp,sp,96
 688:	8082                	ret

000000000000068a <stat>:

int
stat(const char *n, struct stat *st)
{
 68a:	1101                	addi	sp,sp,-32
 68c:	ec06                	sd	ra,24(sp)
 68e:	e822                	sd	s0,16(sp)
 690:	e426                	sd	s1,8(sp)
 692:	e04a                	sd	s2,0(sp)
 694:	1000                	addi	s0,sp,32
 696:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 698:	4581                	li	a1,0
 69a:	00000097          	auipc	ra,0x0
 69e:	170080e7          	jalr	368(ra) # 80a <open>
  if(fd < 0)
 6a2:	02054563          	bltz	a0,6cc <stat+0x42>
 6a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 6a8:	85ca                	mv	a1,s2
 6aa:	00000097          	auipc	ra,0x0
 6ae:	178080e7          	jalr	376(ra) # 822 <fstat>
 6b2:	892a                	mv	s2,a0
  close(fd);
 6b4:	8526                	mv	a0,s1
 6b6:	00000097          	auipc	ra,0x0
 6ba:	13c080e7          	jalr	316(ra) # 7f2 <close>
  return r;
}
 6be:	854a                	mv	a0,s2
 6c0:	60e2                	ld	ra,24(sp)
 6c2:	6442                	ld	s0,16(sp)
 6c4:	64a2                	ld	s1,8(sp)
 6c6:	6902                	ld	s2,0(sp)
 6c8:	6105                	addi	sp,sp,32
 6ca:	8082                	ret
    return -1;
 6cc:	597d                	li	s2,-1
 6ce:	bfc5                	j	6be <stat+0x34>

00000000000006d0 <atoi>:

int
atoi(const char *s)
{
 6d0:	1141                	addi	sp,sp,-16
 6d2:	e422                	sd	s0,8(sp)
 6d4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6d6:	00054683          	lbu	a3,0(a0)
 6da:	fd06879b          	addiw	a5,a3,-48
 6de:	0ff7f793          	zext.b	a5,a5
 6e2:	4625                	li	a2,9
 6e4:	02f66863          	bltu	a2,a5,714 <atoi+0x44>
 6e8:	872a                	mv	a4,a0
  n = 0;
 6ea:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 6ec:	0705                	addi	a4,a4,1
 6ee:	0025179b          	slliw	a5,a0,0x2
 6f2:	9fa9                	addw	a5,a5,a0
 6f4:	0017979b          	slliw	a5,a5,0x1
 6f8:	9fb5                	addw	a5,a5,a3
 6fa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6fe:	00074683          	lbu	a3,0(a4)
 702:	fd06879b          	addiw	a5,a3,-48
 706:	0ff7f793          	zext.b	a5,a5
 70a:	fef671e3          	bgeu	a2,a5,6ec <atoi+0x1c>
  return n;
}
 70e:	6422                	ld	s0,8(sp)
 710:	0141                	addi	sp,sp,16
 712:	8082                	ret
  n = 0;
 714:	4501                	li	a0,0
 716:	bfe5                	j	70e <atoi+0x3e>

0000000000000718 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 718:	1141                	addi	sp,sp,-16
 71a:	e422                	sd	s0,8(sp)
 71c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 71e:	02b57463          	bgeu	a0,a1,746 <memmove+0x2e>
    while(n-- > 0)
 722:	00c05f63          	blez	a2,740 <memmove+0x28>
 726:	1602                	slli	a2,a2,0x20
 728:	9201                	srli	a2,a2,0x20
 72a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 72e:	872a                	mv	a4,a0
      *dst++ = *src++;
 730:	0585                	addi	a1,a1,1
 732:	0705                	addi	a4,a4,1
 734:	fff5c683          	lbu	a3,-1(a1)
 738:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 73c:	fee79ae3          	bne	a5,a4,730 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 740:	6422                	ld	s0,8(sp)
 742:	0141                	addi	sp,sp,16
 744:	8082                	ret
    dst += n;
 746:	00c50733          	add	a4,a0,a2
    src += n;
 74a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 74c:	fec05ae3          	blez	a2,740 <memmove+0x28>
 750:	fff6079b          	addiw	a5,a2,-1
 754:	1782                	slli	a5,a5,0x20
 756:	9381                	srli	a5,a5,0x20
 758:	fff7c793          	not	a5,a5
 75c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 75e:	15fd                	addi	a1,a1,-1
 760:	177d                	addi	a4,a4,-1
 762:	0005c683          	lbu	a3,0(a1)
 766:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 76a:	fee79ae3          	bne	a5,a4,75e <memmove+0x46>
 76e:	bfc9                	j	740 <memmove+0x28>

0000000000000770 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 770:	1141                	addi	sp,sp,-16
 772:	e422                	sd	s0,8(sp)
 774:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 776:	ca05                	beqz	a2,7a6 <memcmp+0x36>
 778:	fff6069b          	addiw	a3,a2,-1
 77c:	1682                	slli	a3,a3,0x20
 77e:	9281                	srli	a3,a3,0x20
 780:	0685                	addi	a3,a3,1
 782:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 784:	00054783          	lbu	a5,0(a0)
 788:	0005c703          	lbu	a4,0(a1)
 78c:	00e79863          	bne	a5,a4,79c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 790:	0505                	addi	a0,a0,1
    p2++;
 792:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 794:	fed518e3          	bne	a0,a3,784 <memcmp+0x14>
  }
  return 0;
 798:	4501                	li	a0,0
 79a:	a019                	j	7a0 <memcmp+0x30>
      return *p1 - *p2;
 79c:	40e7853b          	subw	a0,a5,a4
}
 7a0:	6422                	ld	s0,8(sp)
 7a2:	0141                	addi	sp,sp,16
 7a4:	8082                	ret
  return 0;
 7a6:	4501                	li	a0,0
 7a8:	bfe5                	j	7a0 <memcmp+0x30>

00000000000007aa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 7aa:	1141                	addi	sp,sp,-16
 7ac:	e406                	sd	ra,8(sp)
 7ae:	e022                	sd	s0,0(sp)
 7b0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 7b2:	00000097          	auipc	ra,0x0
 7b6:	f66080e7          	jalr	-154(ra) # 718 <memmove>
}
 7ba:	60a2                	ld	ra,8(sp)
 7bc:	6402                	ld	s0,0(sp)
 7be:	0141                	addi	sp,sp,16
 7c0:	8082                	ret

00000000000007c2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7c2:	4885                	li	a7,1
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <exit>:
.global exit
exit:
 li a7, SYS_exit
 7ca:	4889                	li	a7,2
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 7d2:	488d                	li	a7,3
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	8082                	ret

00000000000007da <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7da:	4891                	li	a7,4
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <read>:
.global read
read:
 li a7, SYS_read
 7e2:	4895                	li	a7,5
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <write>:
.global write
write:
 li a7, SYS_write
 7ea:	48c1                	li	a7,16
 ecall
 7ec:	00000073          	ecall
 ret
 7f0:	8082                	ret

00000000000007f2 <close>:
.global close
close:
 li a7, SYS_close
 7f2:	48d5                	li	a7,21
 ecall
 7f4:	00000073          	ecall
 ret
 7f8:	8082                	ret

00000000000007fa <kill>:
.global kill
kill:
 li a7, SYS_kill
 7fa:	4899                	li	a7,6
 ecall
 7fc:	00000073          	ecall
 ret
 800:	8082                	ret

0000000000000802 <exec>:
.global exec
exec:
 li a7, SYS_exec
 802:	489d                	li	a7,7
 ecall
 804:	00000073          	ecall
 ret
 808:	8082                	ret

000000000000080a <open>:
.global open
open:
 li a7, SYS_open
 80a:	48bd                	li	a7,15
 ecall
 80c:	00000073          	ecall
 ret
 810:	8082                	ret

0000000000000812 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 812:	48c5                	li	a7,17
 ecall
 814:	00000073          	ecall
 ret
 818:	8082                	ret

000000000000081a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 81a:	48c9                	li	a7,18
 ecall
 81c:	00000073          	ecall
 ret
 820:	8082                	ret

0000000000000822 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 822:	48a1                	li	a7,8
 ecall
 824:	00000073          	ecall
 ret
 828:	8082                	ret

000000000000082a <link>:
.global link
link:
 li a7, SYS_link
 82a:	48cd                	li	a7,19
 ecall
 82c:	00000073          	ecall
 ret
 830:	8082                	ret

0000000000000832 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 832:	48d1                	li	a7,20
 ecall
 834:	00000073          	ecall
 ret
 838:	8082                	ret

000000000000083a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 83a:	48a5                	li	a7,9
 ecall
 83c:	00000073          	ecall
 ret
 840:	8082                	ret

0000000000000842 <dup>:
.global dup
dup:
 li a7, SYS_dup
 842:	48a9                	li	a7,10
 ecall
 844:	00000073          	ecall
 ret
 848:	8082                	ret

000000000000084a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 84a:	48ad                	li	a7,11
 ecall
 84c:	00000073          	ecall
 ret
 850:	8082                	ret

0000000000000852 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 852:	48b1                	li	a7,12
 ecall
 854:	00000073          	ecall
 ret
 858:	8082                	ret

000000000000085a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 85a:	48b5                	li	a7,13
 ecall
 85c:	00000073          	ecall
 ret
 860:	8082                	ret

0000000000000862 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 862:	48b9                	li	a7,14
 ecall
 864:	00000073          	ecall
 ret
 868:	8082                	ret

000000000000086a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 86a:	1101                	addi	sp,sp,-32
 86c:	ec06                	sd	ra,24(sp)
 86e:	e822                	sd	s0,16(sp)
 870:	1000                	addi	s0,sp,32
 872:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 876:	4605                	li	a2,1
 878:	fef40593          	addi	a1,s0,-17
 87c:	00000097          	auipc	ra,0x0
 880:	f6e080e7          	jalr	-146(ra) # 7ea <write>
}
 884:	60e2                	ld	ra,24(sp)
 886:	6442                	ld	s0,16(sp)
 888:	6105                	addi	sp,sp,32
 88a:	8082                	ret

000000000000088c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 88c:	7139                	addi	sp,sp,-64
 88e:	fc06                	sd	ra,56(sp)
 890:	f822                	sd	s0,48(sp)
 892:	f426                	sd	s1,40(sp)
 894:	f04a                	sd	s2,32(sp)
 896:	ec4e                	sd	s3,24(sp)
 898:	0080                	addi	s0,sp,64
 89a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 89c:	c299                	beqz	a3,8a2 <printint+0x16>
 89e:	0805c963          	bltz	a1,930 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 8a2:	2581                	sext.w	a1,a1
  neg = 0;
 8a4:	4881                	li	a7,0
 8a6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 8aa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8ac:	2601                	sext.w	a2,a2
 8ae:	00000517          	auipc	a0,0x0
 8b2:	65250513          	addi	a0,a0,1618 # f00 <digits>
 8b6:	883a                	mv	a6,a4
 8b8:	2705                	addiw	a4,a4,1
 8ba:	02c5f7bb          	remuw	a5,a1,a2
 8be:	1782                	slli	a5,a5,0x20
 8c0:	9381                	srli	a5,a5,0x20
 8c2:	97aa                	add	a5,a5,a0
 8c4:	0007c783          	lbu	a5,0(a5)
 8c8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8cc:	0005879b          	sext.w	a5,a1
 8d0:	02c5d5bb          	divuw	a1,a1,a2
 8d4:	0685                	addi	a3,a3,1
 8d6:	fec7f0e3          	bgeu	a5,a2,8b6 <printint+0x2a>
  if(neg)
 8da:	00088c63          	beqz	a7,8f2 <printint+0x66>
    buf[i++] = '-';
 8de:	fd070793          	addi	a5,a4,-48
 8e2:	00878733          	add	a4,a5,s0
 8e6:	02d00793          	li	a5,45
 8ea:	fef70823          	sb	a5,-16(a4)
 8ee:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 8f2:	02e05863          	blez	a4,922 <printint+0x96>
 8f6:	fc040793          	addi	a5,s0,-64
 8fa:	00e78933          	add	s2,a5,a4
 8fe:	fff78993          	addi	s3,a5,-1
 902:	99ba                	add	s3,s3,a4
 904:	377d                	addiw	a4,a4,-1
 906:	1702                	slli	a4,a4,0x20
 908:	9301                	srli	a4,a4,0x20
 90a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 90e:	fff94583          	lbu	a1,-1(s2)
 912:	8526                	mv	a0,s1
 914:	00000097          	auipc	ra,0x0
 918:	f56080e7          	jalr	-170(ra) # 86a <putc>
  while(--i >= 0)
 91c:	197d                	addi	s2,s2,-1
 91e:	ff3918e3          	bne	s2,s3,90e <printint+0x82>
}
 922:	70e2                	ld	ra,56(sp)
 924:	7442                	ld	s0,48(sp)
 926:	74a2                	ld	s1,40(sp)
 928:	7902                	ld	s2,32(sp)
 92a:	69e2                	ld	s3,24(sp)
 92c:	6121                	addi	sp,sp,64
 92e:	8082                	ret
    x = -xx;
 930:	40b005bb          	negw	a1,a1
    neg = 1;
 934:	4885                	li	a7,1
    x = -xx;
 936:	bf85                	j	8a6 <printint+0x1a>

0000000000000938 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 938:	7119                	addi	sp,sp,-128
 93a:	fc86                	sd	ra,120(sp)
 93c:	f8a2                	sd	s0,112(sp)
 93e:	f4a6                	sd	s1,104(sp)
 940:	f0ca                	sd	s2,96(sp)
 942:	ecce                	sd	s3,88(sp)
 944:	e8d2                	sd	s4,80(sp)
 946:	e4d6                	sd	s5,72(sp)
 948:	e0da                	sd	s6,64(sp)
 94a:	fc5e                	sd	s7,56(sp)
 94c:	f862                	sd	s8,48(sp)
 94e:	f466                	sd	s9,40(sp)
 950:	f06a                	sd	s10,32(sp)
 952:	ec6e                	sd	s11,24(sp)
 954:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 956:	0005c903          	lbu	s2,0(a1)
 95a:	18090f63          	beqz	s2,af8 <vprintf+0x1c0>
 95e:	8aaa                	mv	s5,a0
 960:	8b32                	mv	s6,a2
 962:	00158493          	addi	s1,a1,1
  state = 0;
 966:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 968:	02500a13          	li	s4,37
 96c:	4c55                	li	s8,21
 96e:	00000c97          	auipc	s9,0x0
 972:	53ac8c93          	addi	s9,s9,1338 # ea8 <statistics+0x1c6>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 976:	02800d93          	li	s11,40
  putc(fd, 'x');
 97a:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 97c:	00000b97          	auipc	s7,0x0
 980:	584b8b93          	addi	s7,s7,1412 # f00 <digits>
 984:	a839                	j	9a2 <vprintf+0x6a>
        putc(fd, c);
 986:	85ca                	mv	a1,s2
 988:	8556                	mv	a0,s5
 98a:	00000097          	auipc	ra,0x0
 98e:	ee0080e7          	jalr	-288(ra) # 86a <putc>
 992:	a019                	j	998 <vprintf+0x60>
    } else if(state == '%'){
 994:	01498d63          	beq	s3,s4,9ae <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 998:	0485                	addi	s1,s1,1
 99a:	fff4c903          	lbu	s2,-1(s1)
 99e:	14090d63          	beqz	s2,af8 <vprintf+0x1c0>
    if(state == 0){
 9a2:	fe0999e3          	bnez	s3,994 <vprintf+0x5c>
      if(c == '%'){
 9a6:	ff4910e3          	bne	s2,s4,986 <vprintf+0x4e>
        state = '%';
 9aa:	89d2                	mv	s3,s4
 9ac:	b7f5                	j	998 <vprintf+0x60>
      if(c == 'd'){
 9ae:	11490c63          	beq	s2,s4,ac6 <vprintf+0x18e>
 9b2:	f9d9079b          	addiw	a5,s2,-99
 9b6:	0ff7f793          	zext.b	a5,a5
 9ba:	10fc6e63          	bltu	s8,a5,ad6 <vprintf+0x19e>
 9be:	f9d9079b          	addiw	a5,s2,-99
 9c2:	0ff7f713          	zext.b	a4,a5
 9c6:	10ec6863          	bltu	s8,a4,ad6 <vprintf+0x19e>
 9ca:	00271793          	slli	a5,a4,0x2
 9ce:	97e6                	add	a5,a5,s9
 9d0:	439c                	lw	a5,0(a5)
 9d2:	97e6                	add	a5,a5,s9
 9d4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 9d6:	008b0913          	addi	s2,s6,8
 9da:	4685                	li	a3,1
 9dc:	4629                	li	a2,10
 9de:	000b2583          	lw	a1,0(s6)
 9e2:	8556                	mv	a0,s5
 9e4:	00000097          	auipc	ra,0x0
 9e8:	ea8080e7          	jalr	-344(ra) # 88c <printint>
 9ec:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 9ee:	4981                	li	s3,0
 9f0:	b765                	j	998 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9f2:	008b0913          	addi	s2,s6,8
 9f6:	4681                	li	a3,0
 9f8:	4629                	li	a2,10
 9fa:	000b2583          	lw	a1,0(s6)
 9fe:	8556                	mv	a0,s5
 a00:	00000097          	auipc	ra,0x0
 a04:	e8c080e7          	jalr	-372(ra) # 88c <printint>
 a08:	8b4a                	mv	s6,s2
      state = 0;
 a0a:	4981                	li	s3,0
 a0c:	b771                	j	998 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 a0e:	008b0913          	addi	s2,s6,8
 a12:	4681                	li	a3,0
 a14:	866a                	mv	a2,s10
 a16:	000b2583          	lw	a1,0(s6)
 a1a:	8556                	mv	a0,s5
 a1c:	00000097          	auipc	ra,0x0
 a20:	e70080e7          	jalr	-400(ra) # 88c <printint>
 a24:	8b4a                	mv	s6,s2
      state = 0;
 a26:	4981                	li	s3,0
 a28:	bf85                	j	998 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 a2a:	008b0793          	addi	a5,s6,8
 a2e:	f8f43423          	sd	a5,-120(s0)
 a32:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 a36:	03000593          	li	a1,48
 a3a:	8556                	mv	a0,s5
 a3c:	00000097          	auipc	ra,0x0
 a40:	e2e080e7          	jalr	-466(ra) # 86a <putc>
  putc(fd, 'x');
 a44:	07800593          	li	a1,120
 a48:	8556                	mv	a0,s5
 a4a:	00000097          	auipc	ra,0x0
 a4e:	e20080e7          	jalr	-480(ra) # 86a <putc>
 a52:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a54:	03c9d793          	srli	a5,s3,0x3c
 a58:	97de                	add	a5,a5,s7
 a5a:	0007c583          	lbu	a1,0(a5)
 a5e:	8556                	mv	a0,s5
 a60:	00000097          	auipc	ra,0x0
 a64:	e0a080e7          	jalr	-502(ra) # 86a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a68:	0992                	slli	s3,s3,0x4
 a6a:	397d                	addiw	s2,s2,-1
 a6c:	fe0914e3          	bnez	s2,a54 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 a70:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 a74:	4981                	li	s3,0
 a76:	b70d                	j	998 <vprintf+0x60>
        s = va_arg(ap, char*);
 a78:	008b0913          	addi	s2,s6,8
 a7c:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 a80:	02098163          	beqz	s3,aa2 <vprintf+0x16a>
        while(*s != 0){
 a84:	0009c583          	lbu	a1,0(s3)
 a88:	c5ad                	beqz	a1,af2 <vprintf+0x1ba>
          putc(fd, *s);
 a8a:	8556                	mv	a0,s5
 a8c:	00000097          	auipc	ra,0x0
 a90:	dde080e7          	jalr	-546(ra) # 86a <putc>
          s++;
 a94:	0985                	addi	s3,s3,1
        while(*s != 0){
 a96:	0009c583          	lbu	a1,0(s3)
 a9a:	f9e5                	bnez	a1,a8a <vprintf+0x152>
        s = va_arg(ap, char*);
 a9c:	8b4a                	mv	s6,s2
      state = 0;
 a9e:	4981                	li	s3,0
 aa0:	bde5                	j	998 <vprintf+0x60>
          s = "(null)";
 aa2:	00000997          	auipc	s3,0x0
 aa6:	3fe98993          	addi	s3,s3,1022 # ea0 <statistics+0x1be>
        while(*s != 0){
 aaa:	85ee                	mv	a1,s11
 aac:	bff9                	j	a8a <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 aae:	008b0913          	addi	s2,s6,8
 ab2:	000b4583          	lbu	a1,0(s6)
 ab6:	8556                	mv	a0,s5
 ab8:	00000097          	auipc	ra,0x0
 abc:	db2080e7          	jalr	-590(ra) # 86a <putc>
 ac0:	8b4a                	mv	s6,s2
      state = 0;
 ac2:	4981                	li	s3,0
 ac4:	bdd1                	j	998 <vprintf+0x60>
        putc(fd, c);
 ac6:	85d2                	mv	a1,s4
 ac8:	8556                	mv	a0,s5
 aca:	00000097          	auipc	ra,0x0
 ace:	da0080e7          	jalr	-608(ra) # 86a <putc>
      state = 0;
 ad2:	4981                	li	s3,0
 ad4:	b5d1                	j	998 <vprintf+0x60>
        putc(fd, '%');
 ad6:	85d2                	mv	a1,s4
 ad8:	8556                	mv	a0,s5
 ada:	00000097          	auipc	ra,0x0
 ade:	d90080e7          	jalr	-624(ra) # 86a <putc>
        putc(fd, c);
 ae2:	85ca                	mv	a1,s2
 ae4:	8556                	mv	a0,s5
 ae6:	00000097          	auipc	ra,0x0
 aea:	d84080e7          	jalr	-636(ra) # 86a <putc>
      state = 0;
 aee:	4981                	li	s3,0
 af0:	b565                	j	998 <vprintf+0x60>
        s = va_arg(ap, char*);
 af2:	8b4a                	mv	s6,s2
      state = 0;
 af4:	4981                	li	s3,0
 af6:	b54d                	j	998 <vprintf+0x60>
    }
  }
}
 af8:	70e6                	ld	ra,120(sp)
 afa:	7446                	ld	s0,112(sp)
 afc:	74a6                	ld	s1,104(sp)
 afe:	7906                	ld	s2,96(sp)
 b00:	69e6                	ld	s3,88(sp)
 b02:	6a46                	ld	s4,80(sp)
 b04:	6aa6                	ld	s5,72(sp)
 b06:	6b06                	ld	s6,64(sp)
 b08:	7be2                	ld	s7,56(sp)
 b0a:	7c42                	ld	s8,48(sp)
 b0c:	7ca2                	ld	s9,40(sp)
 b0e:	7d02                	ld	s10,32(sp)
 b10:	6de2                	ld	s11,24(sp)
 b12:	6109                	addi	sp,sp,128
 b14:	8082                	ret

0000000000000b16 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b16:	715d                	addi	sp,sp,-80
 b18:	ec06                	sd	ra,24(sp)
 b1a:	e822                	sd	s0,16(sp)
 b1c:	1000                	addi	s0,sp,32
 b1e:	e010                	sd	a2,0(s0)
 b20:	e414                	sd	a3,8(s0)
 b22:	e818                	sd	a4,16(s0)
 b24:	ec1c                	sd	a5,24(s0)
 b26:	03043023          	sd	a6,32(s0)
 b2a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b2e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b32:	8622                	mv	a2,s0
 b34:	00000097          	auipc	ra,0x0
 b38:	e04080e7          	jalr	-508(ra) # 938 <vprintf>
}
 b3c:	60e2                	ld	ra,24(sp)
 b3e:	6442                	ld	s0,16(sp)
 b40:	6161                	addi	sp,sp,80
 b42:	8082                	ret

0000000000000b44 <printf>:

void
printf(const char *fmt, ...)
{
 b44:	711d                	addi	sp,sp,-96
 b46:	ec06                	sd	ra,24(sp)
 b48:	e822                	sd	s0,16(sp)
 b4a:	1000                	addi	s0,sp,32
 b4c:	e40c                	sd	a1,8(s0)
 b4e:	e810                	sd	a2,16(s0)
 b50:	ec14                	sd	a3,24(s0)
 b52:	f018                	sd	a4,32(s0)
 b54:	f41c                	sd	a5,40(s0)
 b56:	03043823          	sd	a6,48(s0)
 b5a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b5e:	00840613          	addi	a2,s0,8
 b62:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b66:	85aa                	mv	a1,a0
 b68:	4505                	li	a0,1
 b6a:	00000097          	auipc	ra,0x0
 b6e:	dce080e7          	jalr	-562(ra) # 938 <vprintf>
}
 b72:	60e2                	ld	ra,24(sp)
 b74:	6442                	ld	s0,16(sp)
 b76:	6125                	addi	sp,sp,96
 b78:	8082                	ret

0000000000000b7a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b7a:	1141                	addi	sp,sp,-16
 b7c:	e422                	sd	s0,8(sp)
 b7e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b80:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b84:	00000797          	auipc	a5,0x0
 b88:	3bc7b783          	ld	a5,956(a5) # f40 <freep>
 b8c:	a02d                	j	bb6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b8e:	4618                	lw	a4,8(a2)
 b90:	9f2d                	addw	a4,a4,a1
 b92:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b96:	6398                	ld	a4,0(a5)
 b98:	6310                	ld	a2,0(a4)
 b9a:	a83d                	j	bd8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b9c:	ff852703          	lw	a4,-8(a0)
 ba0:	9f31                	addw	a4,a4,a2
 ba2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ba4:	ff053683          	ld	a3,-16(a0)
 ba8:	a091                	j	bec <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 baa:	6398                	ld	a4,0(a5)
 bac:	00e7e463          	bltu	a5,a4,bb4 <free+0x3a>
 bb0:	00e6ea63          	bltu	a3,a4,bc4 <free+0x4a>
{
 bb4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bb6:	fed7fae3          	bgeu	a5,a3,baa <free+0x30>
 bba:	6398                	ld	a4,0(a5)
 bbc:	00e6e463          	bltu	a3,a4,bc4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bc0:	fee7eae3          	bltu	a5,a4,bb4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 bc4:	ff852583          	lw	a1,-8(a0)
 bc8:	6390                	ld	a2,0(a5)
 bca:	02059813          	slli	a6,a1,0x20
 bce:	01c85713          	srli	a4,a6,0x1c
 bd2:	9736                	add	a4,a4,a3
 bd4:	fae60de3          	beq	a2,a4,b8e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bd8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bdc:	4790                	lw	a2,8(a5)
 bde:	02061593          	slli	a1,a2,0x20
 be2:	01c5d713          	srli	a4,a1,0x1c
 be6:	973e                	add	a4,a4,a5
 be8:	fae68ae3          	beq	a3,a4,b9c <free+0x22>
    p->s.ptr = bp->s.ptr;
 bec:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bee:	00000717          	auipc	a4,0x0
 bf2:	34f73923          	sd	a5,850(a4) # f40 <freep>
}
 bf6:	6422                	ld	s0,8(sp)
 bf8:	0141                	addi	sp,sp,16
 bfa:	8082                	ret

0000000000000bfc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 bfc:	7139                	addi	sp,sp,-64
 bfe:	fc06                	sd	ra,56(sp)
 c00:	f822                	sd	s0,48(sp)
 c02:	f426                	sd	s1,40(sp)
 c04:	f04a                	sd	s2,32(sp)
 c06:	ec4e                	sd	s3,24(sp)
 c08:	e852                	sd	s4,16(sp)
 c0a:	e456                	sd	s5,8(sp)
 c0c:	e05a                	sd	s6,0(sp)
 c0e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c10:	02051493          	slli	s1,a0,0x20
 c14:	9081                	srli	s1,s1,0x20
 c16:	04bd                	addi	s1,s1,15
 c18:	8091                	srli	s1,s1,0x4
 c1a:	0014899b          	addiw	s3,s1,1
 c1e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 c20:	00000517          	auipc	a0,0x0
 c24:	32053503          	ld	a0,800(a0) # f40 <freep>
 c28:	c515                	beqz	a0,c54 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c2a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c2c:	4798                	lw	a4,8(a5)
 c2e:	02977f63          	bgeu	a4,s1,c6c <malloc+0x70>
 c32:	8a4e                	mv	s4,s3
 c34:	0009871b          	sext.w	a4,s3
 c38:	6685                	lui	a3,0x1
 c3a:	00d77363          	bgeu	a4,a3,c40 <malloc+0x44>
 c3e:	6a05                	lui	s4,0x1
 c40:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c44:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c48:	00000917          	auipc	s2,0x0
 c4c:	2f890913          	addi	s2,s2,760 # f40 <freep>
  if(p == (char*)-1)
 c50:	5afd                	li	s5,-1
 c52:	a895                	j	cc6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 c54:	00001797          	auipc	a5,0x1
 c58:	2f478793          	addi	a5,a5,756 # 1f48 <base>
 c5c:	00000717          	auipc	a4,0x0
 c60:	2ef73223          	sd	a5,740(a4) # f40 <freep>
 c64:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c66:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c6a:	b7e1                	j	c32 <malloc+0x36>
      if(p->s.size == nunits)
 c6c:	02e48c63          	beq	s1,a4,ca4 <malloc+0xa8>
        p->s.size -= nunits;
 c70:	4137073b          	subw	a4,a4,s3
 c74:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c76:	02071693          	slli	a3,a4,0x20
 c7a:	01c6d713          	srli	a4,a3,0x1c
 c7e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c80:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c84:	00000717          	auipc	a4,0x0
 c88:	2aa73e23          	sd	a0,700(a4) # f40 <freep>
      return (void*)(p + 1);
 c8c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c90:	70e2                	ld	ra,56(sp)
 c92:	7442                	ld	s0,48(sp)
 c94:	74a2                	ld	s1,40(sp)
 c96:	7902                	ld	s2,32(sp)
 c98:	69e2                	ld	s3,24(sp)
 c9a:	6a42                	ld	s4,16(sp)
 c9c:	6aa2                	ld	s5,8(sp)
 c9e:	6b02                	ld	s6,0(sp)
 ca0:	6121                	addi	sp,sp,64
 ca2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 ca4:	6398                	ld	a4,0(a5)
 ca6:	e118                	sd	a4,0(a0)
 ca8:	bff1                	j	c84 <malloc+0x88>
  hp->s.size = nu;
 caa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cae:	0541                	addi	a0,a0,16
 cb0:	00000097          	auipc	ra,0x0
 cb4:	eca080e7          	jalr	-310(ra) # b7a <free>
  return freep;
 cb8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cbc:	d971                	beqz	a0,c90 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cbe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cc0:	4798                	lw	a4,8(a5)
 cc2:	fa9775e3          	bgeu	a4,s1,c6c <malloc+0x70>
    if(p == freep)
 cc6:	00093703          	ld	a4,0(s2)
 cca:	853e                	mv	a0,a5
 ccc:	fef719e3          	bne	a4,a5,cbe <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 cd0:	8552                	mv	a0,s4
 cd2:	00000097          	auipc	ra,0x0
 cd6:	b80080e7          	jalr	-1152(ra) # 852 <sbrk>
  if(p == (char*)-1)
 cda:	fd5518e3          	bne	a0,s5,caa <malloc+0xae>
        return 0;
 cde:	4501                	li	a0,0
 ce0:	bf45                	j	c90 <malloc+0x94>

0000000000000ce2 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 ce2:	7179                	addi	sp,sp,-48
 ce4:	f406                	sd	ra,40(sp)
 ce6:	f022                	sd	s0,32(sp)
 ce8:	ec26                	sd	s1,24(sp)
 cea:	e84a                	sd	s2,16(sp)
 cec:	e44e                	sd	s3,8(sp)
 cee:	e052                	sd	s4,0(sp)
 cf0:	1800                	addi	s0,sp,48
 cf2:	8a2a                	mv	s4,a0
 cf4:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 cf6:	4581                	li	a1,0
 cf8:	00000517          	auipc	a0,0x0
 cfc:	22050513          	addi	a0,a0,544 # f18 <digits+0x18>
 d00:	00000097          	auipc	ra,0x0
 d04:	b0a080e7          	jalr	-1270(ra) # 80a <open>
  if(fd < 0) {
 d08:	04054263          	bltz	a0,d4c <statistics+0x6a>
 d0c:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 d0e:	4481                	li	s1,0
 d10:	03205063          	blez	s2,d30 <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 d14:	4099063b          	subw	a2,s2,s1
 d18:	009a05b3          	add	a1,s4,s1
 d1c:	854e                	mv	a0,s3
 d1e:	00000097          	auipc	ra,0x0
 d22:	ac4080e7          	jalr	-1340(ra) # 7e2 <read>
 d26:	00054563          	bltz	a0,d30 <statistics+0x4e>
      break;
    }
    i += n;
 d2a:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 d2c:	ff24c4e3          	blt	s1,s2,d14 <statistics+0x32>
  }
  close(fd);
 d30:	854e                	mv	a0,s3
 d32:	00000097          	auipc	ra,0x0
 d36:	ac0080e7          	jalr	-1344(ra) # 7f2 <close>
  return i;
}
 d3a:	8526                	mv	a0,s1
 d3c:	70a2                	ld	ra,40(sp)
 d3e:	7402                	ld	s0,32(sp)
 d40:	64e2                	ld	s1,24(sp)
 d42:	6942                	ld	s2,16(sp)
 d44:	69a2                	ld	s3,8(sp)
 d46:	6a02                	ld	s4,0(sp)
 d48:	6145                	addi	sp,sp,48
 d4a:	8082                	ret
      fprintf(2, "stats: open failed\n");
 d4c:	00000597          	auipc	a1,0x0
 d50:	1dc58593          	addi	a1,a1,476 # f28 <digits+0x28>
 d54:	4509                	li	a0,2
 d56:	00000097          	auipc	ra,0x0
 d5a:	dc0080e7          	jalr	-576(ra) # b16 <fprintf>
      exit(1);
 d5e:	4505                	li	a0,1
 d60:	00000097          	auipc	ra,0x0
 d64:	a6a080e7          	jalr	-1430(ra) # 7ca <exit>
