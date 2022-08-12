
user/_alarmtest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <periodic>:

volatile static int count;

void
periodic()
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  count = count + 1;
   8:	00001797          	auipc	a5,0x1
   c:	d687a783          	lw	a5,-664(a5) # d70 <count>
  10:	2785                	addiw	a5,a5,1
  12:	00001717          	auipc	a4,0x1
  16:	d4f72f23          	sw	a5,-674(a4) # d70 <count>
  printf("alarm!\n");
  1a:	00001517          	auipc	a0,0x1
  1e:	b4650513          	addi	a0,a0,-1210 # b60 <malloc+0xec>
  22:	00001097          	auipc	ra,0x1
  26:	99a080e7          	jalr	-1638(ra) # 9bc <printf>
  sigreturn();
  2a:	00000097          	auipc	ra,0x0
  2e:	6b0080e7          	jalr	1712(ra) # 6da <sigreturn>
}
  32:	60a2                	ld	ra,8(sp)
  34:	6402                	ld	s0,0(sp)
  36:	0141                	addi	sp,sp,16
  38:	8082                	ret

000000000000003a <slow_handler>:
  }
}

void
slow_handler()
{
  3a:	1101                	addi	sp,sp,-32
  3c:	ec06                	sd	ra,24(sp)
  3e:	e822                	sd	s0,16(sp)
  40:	e426                	sd	s1,8(sp)
  42:	1000                	addi	s0,sp,32
  count++;
  44:	00001497          	auipc	s1,0x1
  48:	d2c48493          	addi	s1,s1,-724 # d70 <count>
  4c:	00001797          	auipc	a5,0x1
  50:	d247a783          	lw	a5,-732(a5) # d70 <count>
  54:	2785                	addiw	a5,a5,1
  56:	c09c                	sw	a5,0(s1)
  printf("alarm!\n");
  58:	00001517          	auipc	a0,0x1
  5c:	b0850513          	addi	a0,a0,-1272 # b60 <malloc+0xec>
  60:	00001097          	auipc	ra,0x1
  64:	95c080e7          	jalr	-1700(ra) # 9bc <printf>
  if (count > 1) {
  68:	4098                	lw	a4,0(s1)
  6a:	2701                	sext.w	a4,a4
  6c:	4685                	li	a3,1
  6e:	1dcd67b7          	lui	a5,0x1dcd6
  72:	50078793          	addi	a5,a5,1280 # 1dcd6500 <__global_pointer$+0x1dcd4f97>
  76:	02e6c463          	blt	a3,a4,9e <slow_handler+0x64>
    printf("test2 failed: alarm handler called more than once\n");
    exit(1);
  }
  for (int i = 0; i < 1000*500000; i++) {
    asm volatile("nop"); // avoid compiler optimizing away loop
  7a:	0001                	nop
  for (int i = 0; i < 1000*500000; i++) {
  7c:	37fd                	addiw	a5,a5,-1
  7e:	fff5                	bnez	a5,7a <slow_handler+0x40>
  }
  sigalarm(0, 0);
  80:	4581                	li	a1,0
  82:	4501                	li	a0,0
  84:	00000097          	auipc	ra,0x0
  88:	64e080e7          	jalr	1614(ra) # 6d2 <sigalarm>
  sigreturn();
  8c:	00000097          	auipc	ra,0x0
  90:	64e080e7          	jalr	1614(ra) # 6da <sigreturn>
}
  94:	60e2                	ld	ra,24(sp)
  96:	6442                	ld	s0,16(sp)
  98:	64a2                	ld	s1,8(sp)
  9a:	6105                	addi	sp,sp,32
  9c:	8082                	ret
    printf("test2 failed: alarm handler called more than once\n");
  9e:	00001517          	auipc	a0,0x1
  a2:	aca50513          	addi	a0,a0,-1334 # b68 <malloc+0xf4>
  a6:	00001097          	auipc	ra,0x1
  aa:	916080e7          	jalr	-1770(ra) # 9bc <printf>
    exit(1);
  ae:	4505                	li	a0,1
  b0:	00000097          	auipc	ra,0x0
  b4:	582080e7          	jalr	1410(ra) # 632 <exit>

00000000000000b8 <test0>:
{
  b8:	7139                	addi	sp,sp,-64
  ba:	fc06                	sd	ra,56(sp)
  bc:	f822                	sd	s0,48(sp)
  be:	f426                	sd	s1,40(sp)
  c0:	f04a                	sd	s2,32(sp)
  c2:	ec4e                	sd	s3,24(sp)
  c4:	e852                	sd	s4,16(sp)
  c6:	e456                	sd	s5,8(sp)
  c8:	0080                	addi	s0,sp,64
  printf("test0 start\n");
  ca:	00001517          	auipc	a0,0x1
  ce:	ad650513          	addi	a0,a0,-1322 # ba0 <malloc+0x12c>
  d2:	00001097          	auipc	ra,0x1
  d6:	8ea080e7          	jalr	-1814(ra) # 9bc <printf>
  count = 0;
  da:	00001797          	auipc	a5,0x1
  de:	c807ab23          	sw	zero,-874(a5) # d70 <count>
  sigalarm(2, periodic);
  e2:	00000597          	auipc	a1,0x0
  e6:	f1e58593          	addi	a1,a1,-226 # 0 <periodic>
  ea:	4509                	li	a0,2
  ec:	00000097          	auipc	ra,0x0
  f0:	5e6080e7          	jalr	1510(ra) # 6d2 <sigalarm>
  for(i = 0; i < 1000*500000; i++){
  f4:	4481                	li	s1,0
    if((i % 1000000) == 0)
  f6:	000f4937          	lui	s2,0xf4
  fa:	2409091b          	addiw	s2,s2,576 # f4240 <__global_pointer$+0xf2cd7>
      write(2, ".", 1);
  fe:	00001a97          	auipc	s5,0x1
 102:	ab2a8a93          	addi	s5,s5,-1358 # bb0 <malloc+0x13c>
    if(count > 0)
 106:	00001a17          	auipc	s4,0x1
 10a:	c6aa0a13          	addi	s4,s4,-918 # d70 <count>
  for(i = 0; i < 1000*500000; i++){
 10e:	1dcd69b7          	lui	s3,0x1dcd6
 112:	50098993          	addi	s3,s3,1280 # 1dcd6500 <__global_pointer$+0x1dcd4f97>
 116:	a809                	j	128 <test0+0x70>
    if(count > 0)
 118:	000a2783          	lw	a5,0(s4)
 11c:	2781                	sext.w	a5,a5
 11e:	02f04063          	bgtz	a5,13e <test0+0x86>
  for(i = 0; i < 1000*500000; i++){
 122:	2485                	addiw	s1,s1,1
 124:	01348d63          	beq	s1,s3,13e <test0+0x86>
    if((i % 1000000) == 0)
 128:	0324e7bb          	remw	a5,s1,s2
 12c:	f7f5                	bnez	a5,118 <test0+0x60>
      write(2, ".", 1);
 12e:	4605                	li	a2,1
 130:	85d6                	mv	a1,s5
 132:	4509                	li	a0,2
 134:	00000097          	auipc	ra,0x0
 138:	51e080e7          	jalr	1310(ra) # 652 <write>
 13c:	bff1                	j	118 <test0+0x60>
  sigalarm(0, 0);
 13e:	4581                	li	a1,0
 140:	4501                	li	a0,0
 142:	00000097          	auipc	ra,0x0
 146:	590080e7          	jalr	1424(ra) # 6d2 <sigalarm>
  if(count > 0){
 14a:	00001797          	auipc	a5,0x1
 14e:	c267a783          	lw	a5,-986(a5) # d70 <count>
 152:	02f05363          	blez	a5,178 <test0+0xc0>
    printf("test0 passed\n");
 156:	00001517          	auipc	a0,0x1
 15a:	a6250513          	addi	a0,a0,-1438 # bb8 <malloc+0x144>
 15e:	00001097          	auipc	ra,0x1
 162:	85e080e7          	jalr	-1954(ra) # 9bc <printf>
}
 166:	70e2                	ld	ra,56(sp)
 168:	7442                	ld	s0,48(sp)
 16a:	74a2                	ld	s1,40(sp)
 16c:	7902                	ld	s2,32(sp)
 16e:	69e2                	ld	s3,24(sp)
 170:	6a42                	ld	s4,16(sp)
 172:	6aa2                	ld	s5,8(sp)
 174:	6121                	addi	sp,sp,64
 176:	8082                	ret
    printf("\ntest0 failed: the kernel never called the alarm handler\n");
 178:	00001517          	auipc	a0,0x1
 17c:	a5050513          	addi	a0,a0,-1456 # bc8 <malloc+0x154>
 180:	00001097          	auipc	ra,0x1
 184:	83c080e7          	jalr	-1988(ra) # 9bc <printf>
}
 188:	bff9                	j	166 <test0+0xae>

000000000000018a <foo>:
void __attribute__ ((noinline)) foo(int i, int *j) {
 18a:	1101                	addi	sp,sp,-32
 18c:	ec06                	sd	ra,24(sp)
 18e:	e822                	sd	s0,16(sp)
 190:	e426                	sd	s1,8(sp)
 192:	1000                	addi	s0,sp,32
 194:	84ae                	mv	s1,a1
  if((i % 2500000) == 0) {
 196:	002627b7          	lui	a5,0x262
 19a:	5a07879b          	addiw	a5,a5,1440 # 2625a0 <__global_pointer$+0x261037>
 19e:	02f5653b          	remw	a0,a0,a5
 1a2:	c909                	beqz	a0,1b4 <foo+0x2a>
  *j += 1;
 1a4:	409c                	lw	a5,0(s1)
 1a6:	2785                	addiw	a5,a5,1
 1a8:	c09c                	sw	a5,0(s1)
}
 1aa:	60e2                	ld	ra,24(sp)
 1ac:	6442                	ld	s0,16(sp)
 1ae:	64a2                	ld	s1,8(sp)
 1b0:	6105                	addi	sp,sp,32
 1b2:	8082                	ret
    write(2, ".", 1);
 1b4:	4605                	li	a2,1
 1b6:	00001597          	auipc	a1,0x1
 1ba:	9fa58593          	addi	a1,a1,-1542 # bb0 <malloc+0x13c>
 1be:	4509                	li	a0,2
 1c0:	00000097          	auipc	ra,0x0
 1c4:	492080e7          	jalr	1170(ra) # 652 <write>
 1c8:	bff1                	j	1a4 <foo+0x1a>

00000000000001ca <test1>:
{
 1ca:	7139                	addi	sp,sp,-64
 1cc:	fc06                	sd	ra,56(sp)
 1ce:	f822                	sd	s0,48(sp)
 1d0:	f426                	sd	s1,40(sp)
 1d2:	f04a                	sd	s2,32(sp)
 1d4:	ec4e                	sd	s3,24(sp)
 1d6:	e852                	sd	s4,16(sp)
 1d8:	0080                	addi	s0,sp,64
  printf("test1 start\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	a2e50513          	addi	a0,a0,-1490 # c08 <malloc+0x194>
 1e2:	00000097          	auipc	ra,0x0
 1e6:	7da080e7          	jalr	2010(ra) # 9bc <printf>
  count = 0;
 1ea:	00001797          	auipc	a5,0x1
 1ee:	b807a323          	sw	zero,-1146(a5) # d70 <count>
  j = 0;
 1f2:	fc042623          	sw	zero,-52(s0)
  sigalarm(2, periodic);
 1f6:	00000597          	auipc	a1,0x0
 1fa:	e0a58593          	addi	a1,a1,-502 # 0 <periodic>
 1fe:	4509                	li	a0,2
 200:	00000097          	auipc	ra,0x0
 204:	4d2080e7          	jalr	1234(ra) # 6d2 <sigalarm>
  for(i = 0; i < 500000000; i++){
 208:	4481                	li	s1,0
    if(count >= 10)
 20a:	00001a17          	auipc	s4,0x1
 20e:	b66a0a13          	addi	s4,s4,-1178 # d70 <count>
 212:	49a5                	li	s3,9
  for(i = 0; i < 500000000; i++){
 214:	1dcd6937          	lui	s2,0x1dcd6
 218:	50090913          	addi	s2,s2,1280 # 1dcd6500 <__global_pointer$+0x1dcd4f97>
    if(count >= 10)
 21c:	000a2783          	lw	a5,0(s4)
 220:	2781                	sext.w	a5,a5
 222:	00f9cc63          	blt	s3,a5,23a <test1+0x70>
    foo(i, &j);
 226:	fcc40593          	addi	a1,s0,-52
 22a:	8526                	mv	a0,s1
 22c:	00000097          	auipc	ra,0x0
 230:	f5e080e7          	jalr	-162(ra) # 18a <foo>
  for(i = 0; i < 500000000; i++){
 234:	2485                	addiw	s1,s1,1
 236:	ff2493e3          	bne	s1,s2,21c <test1+0x52>
  if(count < 10){
 23a:	00001717          	auipc	a4,0x1
 23e:	b3672703          	lw	a4,-1226(a4) # d70 <count>
 242:	47a5                	li	a5,9
 244:	02e7d663          	bge	a5,a4,270 <test1+0xa6>
  } else if(i != j){
 248:	fcc42783          	lw	a5,-52(s0)
 24c:	02978b63          	beq	a5,s1,282 <test1+0xb8>
    printf("\ntest1 failed: foo() executed fewer times than it was called\n");
 250:	00001517          	auipc	a0,0x1
 254:	9f850513          	addi	a0,a0,-1544 # c48 <malloc+0x1d4>
 258:	00000097          	auipc	ra,0x0
 25c:	764080e7          	jalr	1892(ra) # 9bc <printf>
}
 260:	70e2                	ld	ra,56(sp)
 262:	7442                	ld	s0,48(sp)
 264:	74a2                	ld	s1,40(sp)
 266:	7902                	ld	s2,32(sp)
 268:	69e2                	ld	s3,24(sp)
 26a:	6a42                	ld	s4,16(sp)
 26c:	6121                	addi	sp,sp,64
 26e:	8082                	ret
    printf("\ntest1 failed: too few calls to the handler\n");
 270:	00001517          	auipc	a0,0x1
 274:	9a850513          	addi	a0,a0,-1624 # c18 <malloc+0x1a4>
 278:	00000097          	auipc	ra,0x0
 27c:	744080e7          	jalr	1860(ra) # 9bc <printf>
 280:	b7c5                	j	260 <test1+0x96>
    printf("test1 passed\n");
 282:	00001517          	auipc	a0,0x1
 286:	a0650513          	addi	a0,a0,-1530 # c88 <malloc+0x214>
 28a:	00000097          	auipc	ra,0x0
 28e:	732080e7          	jalr	1842(ra) # 9bc <printf>
}
 292:	b7f9                	j	260 <test1+0x96>

0000000000000294 <test2>:
{
 294:	715d                	addi	sp,sp,-80
 296:	e486                	sd	ra,72(sp)
 298:	e0a2                	sd	s0,64(sp)
 29a:	fc26                	sd	s1,56(sp)
 29c:	f84a                	sd	s2,48(sp)
 29e:	f44e                	sd	s3,40(sp)
 2a0:	f052                	sd	s4,32(sp)
 2a2:	ec56                	sd	s5,24(sp)
 2a4:	0880                	addi	s0,sp,80
  printf("test2 start\n");
 2a6:	00001517          	auipc	a0,0x1
 2aa:	9f250513          	addi	a0,a0,-1550 # c98 <malloc+0x224>
 2ae:	00000097          	auipc	ra,0x0
 2b2:	70e080e7          	jalr	1806(ra) # 9bc <printf>
  if ((pid = fork()) < 0) {
 2b6:	00000097          	auipc	ra,0x0
 2ba:	374080e7          	jalr	884(ra) # 62a <fork>
 2be:	04054263          	bltz	a0,302 <test2+0x6e>
 2c2:	84aa                	mv	s1,a0
  if (pid == 0) {
 2c4:	e539                	bnez	a0,312 <test2+0x7e>
    count = 0;
 2c6:	00001797          	auipc	a5,0x1
 2ca:	aa07a523          	sw	zero,-1366(a5) # d70 <count>
    sigalarm(2, slow_handler);
 2ce:	00000597          	auipc	a1,0x0
 2d2:	d6c58593          	addi	a1,a1,-660 # 3a <slow_handler>
 2d6:	4509                	li	a0,2
 2d8:	00000097          	auipc	ra,0x0
 2dc:	3fa080e7          	jalr	1018(ra) # 6d2 <sigalarm>
      if((i % 1000000) == 0)
 2e0:	000f4937          	lui	s2,0xf4
 2e4:	2409091b          	addiw	s2,s2,576 # f4240 <__global_pointer$+0xf2cd7>
        write(2, ".", 1);
 2e8:	00001a97          	auipc	s5,0x1
 2ec:	8c8a8a93          	addi	s5,s5,-1848 # bb0 <malloc+0x13c>
      if(count > 0)
 2f0:	00001a17          	auipc	s4,0x1
 2f4:	a80a0a13          	addi	s4,s4,-1408 # d70 <count>
    for(i = 0; i < 1000*500000; i++){
 2f8:	1dcd69b7          	lui	s3,0x1dcd6
 2fc:	50098993          	addi	s3,s3,1280 # 1dcd6500 <__global_pointer$+0x1dcd4f97>
 300:	a099                	j	346 <test2+0xb2>
    printf("test2: fork failed\n");
 302:	00001517          	auipc	a0,0x1
 306:	9a650513          	addi	a0,a0,-1626 # ca8 <malloc+0x234>
 30a:	00000097          	auipc	ra,0x0
 30e:	6b2080e7          	jalr	1714(ra) # 9bc <printf>
  wait(&status);
 312:	fbc40513          	addi	a0,s0,-68
 316:	00000097          	auipc	ra,0x0
 31a:	324080e7          	jalr	804(ra) # 63a <wait>
  if (status == 0) {
 31e:	fbc42783          	lw	a5,-68(s0)
 322:	c7a5                	beqz	a5,38a <test2+0xf6>
}
 324:	60a6                	ld	ra,72(sp)
 326:	6406                	ld	s0,64(sp)
 328:	74e2                	ld	s1,56(sp)
 32a:	7942                	ld	s2,48(sp)
 32c:	79a2                	ld	s3,40(sp)
 32e:	7a02                	ld	s4,32(sp)
 330:	6ae2                	ld	s5,24(sp)
 332:	6161                	addi	sp,sp,80
 334:	8082                	ret
      if(count > 0)
 336:	000a2783          	lw	a5,0(s4)
 33a:	2781                	sext.w	a5,a5
 33c:	02f04063          	bgtz	a5,35c <test2+0xc8>
    for(i = 0; i < 1000*500000; i++){
 340:	2485                	addiw	s1,s1,1
 342:	01348d63          	beq	s1,s3,35c <test2+0xc8>
      if((i % 1000000) == 0)
 346:	0324e7bb          	remw	a5,s1,s2
 34a:	f7f5                	bnez	a5,336 <test2+0xa2>
        write(2, ".", 1);
 34c:	4605                	li	a2,1
 34e:	85d6                	mv	a1,s5
 350:	4509                	li	a0,2
 352:	00000097          	auipc	ra,0x0
 356:	300080e7          	jalr	768(ra) # 652 <write>
 35a:	bff1                	j	336 <test2+0xa2>
    if (count == 0) {
 35c:	00001797          	auipc	a5,0x1
 360:	a147a783          	lw	a5,-1516(a5) # d70 <count>
 364:	ef91                	bnez	a5,380 <test2+0xec>
      printf("\ntest2 failed: alarm not called\n");
 366:	00001517          	auipc	a0,0x1
 36a:	95a50513          	addi	a0,a0,-1702 # cc0 <malloc+0x24c>
 36e:	00000097          	auipc	ra,0x0
 372:	64e080e7          	jalr	1614(ra) # 9bc <printf>
      exit(1);
 376:	4505                	li	a0,1
 378:	00000097          	auipc	ra,0x0
 37c:	2ba080e7          	jalr	698(ra) # 632 <exit>
    exit(0);
 380:	4501                	li	a0,0
 382:	00000097          	auipc	ra,0x0
 386:	2b0080e7          	jalr	688(ra) # 632 <exit>
    printf("test2 passed\n");
 38a:	00001517          	auipc	a0,0x1
 38e:	95e50513          	addi	a0,a0,-1698 # ce8 <malloc+0x274>
 392:	00000097          	auipc	ra,0x0
 396:	62a080e7          	jalr	1578(ra) # 9bc <printf>
}
 39a:	b769                	j	324 <test2+0x90>

000000000000039c <main>:
{
 39c:	1141                	addi	sp,sp,-16
 39e:	e406                	sd	ra,8(sp)
 3a0:	e022                	sd	s0,0(sp)
 3a2:	0800                	addi	s0,sp,16
  test0();
 3a4:	00000097          	auipc	ra,0x0
 3a8:	d14080e7          	jalr	-748(ra) # b8 <test0>
  test1();
 3ac:	00000097          	auipc	ra,0x0
 3b0:	e1e080e7          	jalr	-482(ra) # 1ca <test1>
  test2();
 3b4:	00000097          	auipc	ra,0x0
 3b8:	ee0080e7          	jalr	-288(ra) # 294 <test2>
  exit(0);
 3bc:	4501                	li	a0,0
 3be:	00000097          	auipc	ra,0x0
 3c2:	274080e7          	jalr	628(ra) # 632 <exit>

00000000000003c6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e422                	sd	s0,8(sp)
 3ca:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3cc:	87aa                	mv	a5,a0
 3ce:	0585                	addi	a1,a1,1
 3d0:	0785                	addi	a5,a5,1
 3d2:	fff5c703          	lbu	a4,-1(a1)
 3d6:	fee78fa3          	sb	a4,-1(a5)
 3da:	fb75                	bnez	a4,3ce <strcpy+0x8>
    ;
  return os;
}
 3dc:	6422                	ld	s0,8(sp)
 3de:	0141                	addi	sp,sp,16
 3e0:	8082                	ret

00000000000003e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3e2:	1141                	addi	sp,sp,-16
 3e4:	e422                	sd	s0,8(sp)
 3e6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3e8:	00054783          	lbu	a5,0(a0)
 3ec:	cb91                	beqz	a5,400 <strcmp+0x1e>
 3ee:	0005c703          	lbu	a4,0(a1)
 3f2:	00f71763          	bne	a4,a5,400 <strcmp+0x1e>
    p++, q++;
 3f6:	0505                	addi	a0,a0,1
 3f8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3fa:	00054783          	lbu	a5,0(a0)
 3fe:	fbe5                	bnez	a5,3ee <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 400:	0005c503          	lbu	a0,0(a1)
}
 404:	40a7853b          	subw	a0,a5,a0
 408:	6422                	ld	s0,8(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret

000000000000040e <strlen>:

uint
strlen(const char *s)
{
 40e:	1141                	addi	sp,sp,-16
 410:	e422                	sd	s0,8(sp)
 412:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 414:	00054783          	lbu	a5,0(a0)
 418:	cf91                	beqz	a5,434 <strlen+0x26>
 41a:	0505                	addi	a0,a0,1
 41c:	87aa                	mv	a5,a0
 41e:	4685                	li	a3,1
 420:	9e89                	subw	a3,a3,a0
 422:	00f6853b          	addw	a0,a3,a5
 426:	0785                	addi	a5,a5,1
 428:	fff7c703          	lbu	a4,-1(a5)
 42c:	fb7d                	bnez	a4,422 <strlen+0x14>
    ;
  return n;
}
 42e:	6422                	ld	s0,8(sp)
 430:	0141                	addi	sp,sp,16
 432:	8082                	ret
  for(n = 0; s[n]; n++)
 434:	4501                	li	a0,0
 436:	bfe5                	j	42e <strlen+0x20>

0000000000000438 <memset>:

void*
memset(void *dst, int c, uint n)
{
 438:	1141                	addi	sp,sp,-16
 43a:	e422                	sd	s0,8(sp)
 43c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 43e:	ca19                	beqz	a2,454 <memset+0x1c>
 440:	87aa                	mv	a5,a0
 442:	1602                	slli	a2,a2,0x20
 444:	9201                	srli	a2,a2,0x20
 446:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 44a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 44e:	0785                	addi	a5,a5,1
 450:	fee79de3          	bne	a5,a4,44a <memset+0x12>
  }
  return dst;
}
 454:	6422                	ld	s0,8(sp)
 456:	0141                	addi	sp,sp,16
 458:	8082                	ret

000000000000045a <strchr>:

char*
strchr(const char *s, char c)
{
 45a:	1141                	addi	sp,sp,-16
 45c:	e422                	sd	s0,8(sp)
 45e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 460:	00054783          	lbu	a5,0(a0)
 464:	cb99                	beqz	a5,47a <strchr+0x20>
    if(*s == c)
 466:	00f58763          	beq	a1,a5,474 <strchr+0x1a>
  for(; *s; s++)
 46a:	0505                	addi	a0,a0,1
 46c:	00054783          	lbu	a5,0(a0)
 470:	fbfd                	bnez	a5,466 <strchr+0xc>
      return (char*)s;
  return 0;
 472:	4501                	li	a0,0
}
 474:	6422                	ld	s0,8(sp)
 476:	0141                	addi	sp,sp,16
 478:	8082                	ret
  return 0;
 47a:	4501                	li	a0,0
 47c:	bfe5                	j	474 <strchr+0x1a>

000000000000047e <gets>:

char*
gets(char *buf, int max)
{
 47e:	711d                	addi	sp,sp,-96
 480:	ec86                	sd	ra,88(sp)
 482:	e8a2                	sd	s0,80(sp)
 484:	e4a6                	sd	s1,72(sp)
 486:	e0ca                	sd	s2,64(sp)
 488:	fc4e                	sd	s3,56(sp)
 48a:	f852                	sd	s4,48(sp)
 48c:	f456                	sd	s5,40(sp)
 48e:	f05a                	sd	s6,32(sp)
 490:	ec5e                	sd	s7,24(sp)
 492:	1080                	addi	s0,sp,96
 494:	8baa                	mv	s7,a0
 496:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 498:	892a                	mv	s2,a0
 49a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 49c:	4aa9                	li	s5,10
 49e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4a0:	89a6                	mv	s3,s1
 4a2:	2485                	addiw	s1,s1,1
 4a4:	0344d863          	bge	s1,s4,4d4 <gets+0x56>
    cc = read(0, &c, 1);
 4a8:	4605                	li	a2,1
 4aa:	faf40593          	addi	a1,s0,-81
 4ae:	4501                	li	a0,0
 4b0:	00000097          	auipc	ra,0x0
 4b4:	19a080e7          	jalr	410(ra) # 64a <read>
    if(cc < 1)
 4b8:	00a05e63          	blez	a0,4d4 <gets+0x56>
    buf[i++] = c;
 4bc:	faf44783          	lbu	a5,-81(s0)
 4c0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4c4:	01578763          	beq	a5,s5,4d2 <gets+0x54>
 4c8:	0905                	addi	s2,s2,1
 4ca:	fd679be3          	bne	a5,s6,4a0 <gets+0x22>
  for(i=0; i+1 < max; ){
 4ce:	89a6                	mv	s3,s1
 4d0:	a011                	j	4d4 <gets+0x56>
 4d2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4d4:	99de                	add	s3,s3,s7
 4d6:	00098023          	sb	zero,0(s3)
  return buf;
}
 4da:	855e                	mv	a0,s7
 4dc:	60e6                	ld	ra,88(sp)
 4de:	6446                	ld	s0,80(sp)
 4e0:	64a6                	ld	s1,72(sp)
 4e2:	6906                	ld	s2,64(sp)
 4e4:	79e2                	ld	s3,56(sp)
 4e6:	7a42                	ld	s4,48(sp)
 4e8:	7aa2                	ld	s5,40(sp)
 4ea:	7b02                	ld	s6,32(sp)
 4ec:	6be2                	ld	s7,24(sp)
 4ee:	6125                	addi	sp,sp,96
 4f0:	8082                	ret

00000000000004f2 <stat>:

int
stat(const char *n, struct stat *st)
{
 4f2:	1101                	addi	sp,sp,-32
 4f4:	ec06                	sd	ra,24(sp)
 4f6:	e822                	sd	s0,16(sp)
 4f8:	e426                	sd	s1,8(sp)
 4fa:	e04a                	sd	s2,0(sp)
 4fc:	1000                	addi	s0,sp,32
 4fe:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 500:	4581                	li	a1,0
 502:	00000097          	auipc	ra,0x0
 506:	170080e7          	jalr	368(ra) # 672 <open>
  if(fd < 0)
 50a:	02054563          	bltz	a0,534 <stat+0x42>
 50e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 510:	85ca                	mv	a1,s2
 512:	00000097          	auipc	ra,0x0
 516:	178080e7          	jalr	376(ra) # 68a <fstat>
 51a:	892a                	mv	s2,a0
  close(fd);
 51c:	8526                	mv	a0,s1
 51e:	00000097          	auipc	ra,0x0
 522:	13c080e7          	jalr	316(ra) # 65a <close>
  return r;
}
 526:	854a                	mv	a0,s2
 528:	60e2                	ld	ra,24(sp)
 52a:	6442                	ld	s0,16(sp)
 52c:	64a2                	ld	s1,8(sp)
 52e:	6902                	ld	s2,0(sp)
 530:	6105                	addi	sp,sp,32
 532:	8082                	ret
    return -1;
 534:	597d                	li	s2,-1
 536:	bfc5                	j	526 <stat+0x34>

0000000000000538 <atoi>:

int
atoi(const char *s)
{
 538:	1141                	addi	sp,sp,-16
 53a:	e422                	sd	s0,8(sp)
 53c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 53e:	00054683          	lbu	a3,0(a0)
 542:	fd06879b          	addiw	a5,a3,-48
 546:	0ff7f793          	zext.b	a5,a5
 54a:	4625                	li	a2,9
 54c:	02f66863          	bltu	a2,a5,57c <atoi+0x44>
 550:	872a                	mv	a4,a0
  n = 0;
 552:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 554:	0705                	addi	a4,a4,1
 556:	0025179b          	slliw	a5,a0,0x2
 55a:	9fa9                	addw	a5,a5,a0
 55c:	0017979b          	slliw	a5,a5,0x1
 560:	9fb5                	addw	a5,a5,a3
 562:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 566:	00074683          	lbu	a3,0(a4)
 56a:	fd06879b          	addiw	a5,a3,-48
 56e:	0ff7f793          	zext.b	a5,a5
 572:	fef671e3          	bgeu	a2,a5,554 <atoi+0x1c>
  return n;
}
 576:	6422                	ld	s0,8(sp)
 578:	0141                	addi	sp,sp,16
 57a:	8082                	ret
  n = 0;
 57c:	4501                	li	a0,0
 57e:	bfe5                	j	576 <atoi+0x3e>

0000000000000580 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 580:	1141                	addi	sp,sp,-16
 582:	e422                	sd	s0,8(sp)
 584:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 586:	02b57463          	bgeu	a0,a1,5ae <memmove+0x2e>
    while(n-- > 0)
 58a:	00c05f63          	blez	a2,5a8 <memmove+0x28>
 58e:	1602                	slli	a2,a2,0x20
 590:	9201                	srli	a2,a2,0x20
 592:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 596:	872a                	mv	a4,a0
      *dst++ = *src++;
 598:	0585                	addi	a1,a1,1
 59a:	0705                	addi	a4,a4,1
 59c:	fff5c683          	lbu	a3,-1(a1)
 5a0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5a4:	fee79ae3          	bne	a5,a4,598 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5a8:	6422                	ld	s0,8(sp)
 5aa:	0141                	addi	sp,sp,16
 5ac:	8082                	ret
    dst += n;
 5ae:	00c50733          	add	a4,a0,a2
    src += n;
 5b2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5b4:	fec05ae3          	blez	a2,5a8 <memmove+0x28>
 5b8:	fff6079b          	addiw	a5,a2,-1
 5bc:	1782                	slli	a5,a5,0x20
 5be:	9381                	srli	a5,a5,0x20
 5c0:	fff7c793          	not	a5,a5
 5c4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5c6:	15fd                	addi	a1,a1,-1
 5c8:	177d                	addi	a4,a4,-1
 5ca:	0005c683          	lbu	a3,0(a1)
 5ce:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5d2:	fee79ae3          	bne	a5,a4,5c6 <memmove+0x46>
 5d6:	bfc9                	j	5a8 <memmove+0x28>

00000000000005d8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5d8:	1141                	addi	sp,sp,-16
 5da:	e422                	sd	s0,8(sp)
 5dc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5de:	ca05                	beqz	a2,60e <memcmp+0x36>
 5e0:	fff6069b          	addiw	a3,a2,-1
 5e4:	1682                	slli	a3,a3,0x20
 5e6:	9281                	srli	a3,a3,0x20
 5e8:	0685                	addi	a3,a3,1
 5ea:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5ec:	00054783          	lbu	a5,0(a0)
 5f0:	0005c703          	lbu	a4,0(a1)
 5f4:	00e79863          	bne	a5,a4,604 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5f8:	0505                	addi	a0,a0,1
    p2++;
 5fa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5fc:	fed518e3          	bne	a0,a3,5ec <memcmp+0x14>
  }
  return 0;
 600:	4501                	li	a0,0
 602:	a019                	j	608 <memcmp+0x30>
      return *p1 - *p2;
 604:	40e7853b          	subw	a0,a5,a4
}
 608:	6422                	ld	s0,8(sp)
 60a:	0141                	addi	sp,sp,16
 60c:	8082                	ret
  return 0;
 60e:	4501                	li	a0,0
 610:	bfe5                	j	608 <memcmp+0x30>

0000000000000612 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 612:	1141                	addi	sp,sp,-16
 614:	e406                	sd	ra,8(sp)
 616:	e022                	sd	s0,0(sp)
 618:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 61a:	00000097          	auipc	ra,0x0
 61e:	f66080e7          	jalr	-154(ra) # 580 <memmove>
}
 622:	60a2                	ld	ra,8(sp)
 624:	6402                	ld	s0,0(sp)
 626:	0141                	addi	sp,sp,16
 628:	8082                	ret

000000000000062a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 62a:	4885                	li	a7,1
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <exit>:
.global exit
exit:
 li a7, SYS_exit
 632:	4889                	li	a7,2
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <wait>:
.global wait
wait:
 li a7, SYS_wait
 63a:	488d                	li	a7,3
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 642:	4891                	li	a7,4
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <read>:
.global read
read:
 li a7, SYS_read
 64a:	4895                	li	a7,5
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <write>:
.global write
write:
 li a7, SYS_write
 652:	48c1                	li	a7,16
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <close>:
.global close
close:
 li a7, SYS_close
 65a:	48d5                	li	a7,21
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <kill>:
.global kill
kill:
 li a7, SYS_kill
 662:	4899                	li	a7,6
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <exec>:
.global exec
exec:
 li a7, SYS_exec
 66a:	489d                	li	a7,7
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <open>:
.global open
open:
 li a7, SYS_open
 672:	48bd                	li	a7,15
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 67a:	48c5                	li	a7,17
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 682:	48c9                	li	a7,18
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 68a:	48a1                	li	a7,8
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <link>:
.global link
link:
 li a7, SYS_link
 692:	48cd                	li	a7,19
 ecall
 694:	00000073          	ecall
 ret
 698:	8082                	ret

000000000000069a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 69a:	48d1                	li	a7,20
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	8082                	ret

00000000000006a2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6a2:	48a5                	li	a7,9
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <dup>:
.global dup
dup:
 li a7, SYS_dup
 6aa:	48a9                	li	a7,10
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6b2:	48ad                	li	a7,11
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6ba:	48b1                	li	a7,12
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6c2:	48b5                	li	a7,13
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6ca:	48b9                	li	a7,14
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 6d2:	48d9                	li	a7,22
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 6da:	48dd                	li	a7,23
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6e2:	1101                	addi	sp,sp,-32
 6e4:	ec06                	sd	ra,24(sp)
 6e6:	e822                	sd	s0,16(sp)
 6e8:	1000                	addi	s0,sp,32
 6ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6ee:	4605                	li	a2,1
 6f0:	fef40593          	addi	a1,s0,-17
 6f4:	00000097          	auipc	ra,0x0
 6f8:	f5e080e7          	jalr	-162(ra) # 652 <write>
}
 6fc:	60e2                	ld	ra,24(sp)
 6fe:	6442                	ld	s0,16(sp)
 700:	6105                	addi	sp,sp,32
 702:	8082                	ret

0000000000000704 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 704:	7139                	addi	sp,sp,-64
 706:	fc06                	sd	ra,56(sp)
 708:	f822                	sd	s0,48(sp)
 70a:	f426                	sd	s1,40(sp)
 70c:	f04a                	sd	s2,32(sp)
 70e:	ec4e                	sd	s3,24(sp)
 710:	0080                	addi	s0,sp,64
 712:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 714:	c299                	beqz	a3,71a <printint+0x16>
 716:	0805c963          	bltz	a1,7a8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 71a:	2581                	sext.w	a1,a1
  neg = 0;
 71c:	4881                	li	a7,0
 71e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 722:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 724:	2601                	sext.w	a2,a2
 726:	00000517          	auipc	a0,0x0
 72a:	63250513          	addi	a0,a0,1586 # d58 <digits>
 72e:	883a                	mv	a6,a4
 730:	2705                	addiw	a4,a4,1
 732:	02c5f7bb          	remuw	a5,a1,a2
 736:	1782                	slli	a5,a5,0x20
 738:	9381                	srli	a5,a5,0x20
 73a:	97aa                	add	a5,a5,a0
 73c:	0007c783          	lbu	a5,0(a5)
 740:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 744:	0005879b          	sext.w	a5,a1
 748:	02c5d5bb          	divuw	a1,a1,a2
 74c:	0685                	addi	a3,a3,1
 74e:	fec7f0e3          	bgeu	a5,a2,72e <printint+0x2a>
  if(neg)
 752:	00088c63          	beqz	a7,76a <printint+0x66>
    buf[i++] = '-';
 756:	fd070793          	addi	a5,a4,-48
 75a:	00878733          	add	a4,a5,s0
 75e:	02d00793          	li	a5,45
 762:	fef70823          	sb	a5,-16(a4)
 766:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 76a:	02e05863          	blez	a4,79a <printint+0x96>
 76e:	fc040793          	addi	a5,s0,-64
 772:	00e78933          	add	s2,a5,a4
 776:	fff78993          	addi	s3,a5,-1
 77a:	99ba                	add	s3,s3,a4
 77c:	377d                	addiw	a4,a4,-1
 77e:	1702                	slli	a4,a4,0x20
 780:	9301                	srli	a4,a4,0x20
 782:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 786:	fff94583          	lbu	a1,-1(s2)
 78a:	8526                	mv	a0,s1
 78c:	00000097          	auipc	ra,0x0
 790:	f56080e7          	jalr	-170(ra) # 6e2 <putc>
  while(--i >= 0)
 794:	197d                	addi	s2,s2,-1
 796:	ff3918e3          	bne	s2,s3,786 <printint+0x82>
}
 79a:	70e2                	ld	ra,56(sp)
 79c:	7442                	ld	s0,48(sp)
 79e:	74a2                	ld	s1,40(sp)
 7a0:	7902                	ld	s2,32(sp)
 7a2:	69e2                	ld	s3,24(sp)
 7a4:	6121                	addi	sp,sp,64
 7a6:	8082                	ret
    x = -xx;
 7a8:	40b005bb          	negw	a1,a1
    neg = 1;
 7ac:	4885                	li	a7,1
    x = -xx;
 7ae:	bf85                	j	71e <printint+0x1a>

00000000000007b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7b0:	7119                	addi	sp,sp,-128
 7b2:	fc86                	sd	ra,120(sp)
 7b4:	f8a2                	sd	s0,112(sp)
 7b6:	f4a6                	sd	s1,104(sp)
 7b8:	f0ca                	sd	s2,96(sp)
 7ba:	ecce                	sd	s3,88(sp)
 7bc:	e8d2                	sd	s4,80(sp)
 7be:	e4d6                	sd	s5,72(sp)
 7c0:	e0da                	sd	s6,64(sp)
 7c2:	fc5e                	sd	s7,56(sp)
 7c4:	f862                	sd	s8,48(sp)
 7c6:	f466                	sd	s9,40(sp)
 7c8:	f06a                	sd	s10,32(sp)
 7ca:	ec6e                	sd	s11,24(sp)
 7cc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7ce:	0005c903          	lbu	s2,0(a1)
 7d2:	18090f63          	beqz	s2,970 <vprintf+0x1c0>
 7d6:	8aaa                	mv	s5,a0
 7d8:	8b32                	mv	s6,a2
 7da:	00158493          	addi	s1,a1,1
  state = 0;
 7de:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7e0:	02500a13          	li	s4,37
 7e4:	4c55                	li	s8,21
 7e6:	00000c97          	auipc	s9,0x0
 7ea:	51ac8c93          	addi	s9,s9,1306 # d00 <malloc+0x28c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7ee:	02800d93          	li	s11,40
  putc(fd, 'x');
 7f2:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7f4:	00000b97          	auipc	s7,0x0
 7f8:	564b8b93          	addi	s7,s7,1380 # d58 <digits>
 7fc:	a839                	j	81a <vprintf+0x6a>
        putc(fd, c);
 7fe:	85ca                	mv	a1,s2
 800:	8556                	mv	a0,s5
 802:	00000097          	auipc	ra,0x0
 806:	ee0080e7          	jalr	-288(ra) # 6e2 <putc>
 80a:	a019                	j	810 <vprintf+0x60>
    } else if(state == '%'){
 80c:	01498d63          	beq	s3,s4,826 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 810:	0485                	addi	s1,s1,1
 812:	fff4c903          	lbu	s2,-1(s1)
 816:	14090d63          	beqz	s2,970 <vprintf+0x1c0>
    if(state == 0){
 81a:	fe0999e3          	bnez	s3,80c <vprintf+0x5c>
      if(c == '%'){
 81e:	ff4910e3          	bne	s2,s4,7fe <vprintf+0x4e>
        state = '%';
 822:	89d2                	mv	s3,s4
 824:	b7f5                	j	810 <vprintf+0x60>
      if(c == 'd'){
 826:	11490c63          	beq	s2,s4,93e <vprintf+0x18e>
 82a:	f9d9079b          	addiw	a5,s2,-99
 82e:	0ff7f793          	zext.b	a5,a5
 832:	10fc6e63          	bltu	s8,a5,94e <vprintf+0x19e>
 836:	f9d9079b          	addiw	a5,s2,-99
 83a:	0ff7f713          	zext.b	a4,a5
 83e:	10ec6863          	bltu	s8,a4,94e <vprintf+0x19e>
 842:	00271793          	slli	a5,a4,0x2
 846:	97e6                	add	a5,a5,s9
 848:	439c                	lw	a5,0(a5)
 84a:	97e6                	add	a5,a5,s9
 84c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 84e:	008b0913          	addi	s2,s6,8
 852:	4685                	li	a3,1
 854:	4629                	li	a2,10
 856:	000b2583          	lw	a1,0(s6)
 85a:	8556                	mv	a0,s5
 85c:	00000097          	auipc	ra,0x0
 860:	ea8080e7          	jalr	-344(ra) # 704 <printint>
 864:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 866:	4981                	li	s3,0
 868:	b765                	j	810 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 86a:	008b0913          	addi	s2,s6,8
 86e:	4681                	li	a3,0
 870:	4629                	li	a2,10
 872:	000b2583          	lw	a1,0(s6)
 876:	8556                	mv	a0,s5
 878:	00000097          	auipc	ra,0x0
 87c:	e8c080e7          	jalr	-372(ra) # 704 <printint>
 880:	8b4a                	mv	s6,s2
      state = 0;
 882:	4981                	li	s3,0
 884:	b771                	j	810 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 886:	008b0913          	addi	s2,s6,8
 88a:	4681                	li	a3,0
 88c:	866a                	mv	a2,s10
 88e:	000b2583          	lw	a1,0(s6)
 892:	8556                	mv	a0,s5
 894:	00000097          	auipc	ra,0x0
 898:	e70080e7          	jalr	-400(ra) # 704 <printint>
 89c:	8b4a                	mv	s6,s2
      state = 0;
 89e:	4981                	li	s3,0
 8a0:	bf85                	j	810 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8a2:	008b0793          	addi	a5,s6,8
 8a6:	f8f43423          	sd	a5,-120(s0)
 8aa:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8ae:	03000593          	li	a1,48
 8b2:	8556                	mv	a0,s5
 8b4:	00000097          	auipc	ra,0x0
 8b8:	e2e080e7          	jalr	-466(ra) # 6e2 <putc>
  putc(fd, 'x');
 8bc:	07800593          	li	a1,120
 8c0:	8556                	mv	a0,s5
 8c2:	00000097          	auipc	ra,0x0
 8c6:	e20080e7          	jalr	-480(ra) # 6e2 <putc>
 8ca:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8cc:	03c9d793          	srli	a5,s3,0x3c
 8d0:	97de                	add	a5,a5,s7
 8d2:	0007c583          	lbu	a1,0(a5)
 8d6:	8556                	mv	a0,s5
 8d8:	00000097          	auipc	ra,0x0
 8dc:	e0a080e7          	jalr	-502(ra) # 6e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8e0:	0992                	slli	s3,s3,0x4
 8e2:	397d                	addiw	s2,s2,-1
 8e4:	fe0914e3          	bnez	s2,8cc <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 8e8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 8ec:	4981                	li	s3,0
 8ee:	b70d                	j	810 <vprintf+0x60>
        s = va_arg(ap, char*);
 8f0:	008b0913          	addi	s2,s6,8
 8f4:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 8f8:	02098163          	beqz	s3,91a <vprintf+0x16a>
        while(*s != 0){
 8fc:	0009c583          	lbu	a1,0(s3)
 900:	c5ad                	beqz	a1,96a <vprintf+0x1ba>
          putc(fd, *s);
 902:	8556                	mv	a0,s5
 904:	00000097          	auipc	ra,0x0
 908:	dde080e7          	jalr	-546(ra) # 6e2 <putc>
          s++;
 90c:	0985                	addi	s3,s3,1
        while(*s != 0){
 90e:	0009c583          	lbu	a1,0(s3)
 912:	f9e5                	bnez	a1,902 <vprintf+0x152>
        s = va_arg(ap, char*);
 914:	8b4a                	mv	s6,s2
      state = 0;
 916:	4981                	li	s3,0
 918:	bde5                	j	810 <vprintf+0x60>
          s = "(null)";
 91a:	00000997          	auipc	s3,0x0
 91e:	3de98993          	addi	s3,s3,990 # cf8 <malloc+0x284>
        while(*s != 0){
 922:	85ee                	mv	a1,s11
 924:	bff9                	j	902 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 926:	008b0913          	addi	s2,s6,8
 92a:	000b4583          	lbu	a1,0(s6)
 92e:	8556                	mv	a0,s5
 930:	00000097          	auipc	ra,0x0
 934:	db2080e7          	jalr	-590(ra) # 6e2 <putc>
 938:	8b4a                	mv	s6,s2
      state = 0;
 93a:	4981                	li	s3,0
 93c:	bdd1                	j	810 <vprintf+0x60>
        putc(fd, c);
 93e:	85d2                	mv	a1,s4
 940:	8556                	mv	a0,s5
 942:	00000097          	auipc	ra,0x0
 946:	da0080e7          	jalr	-608(ra) # 6e2 <putc>
      state = 0;
 94a:	4981                	li	s3,0
 94c:	b5d1                	j	810 <vprintf+0x60>
        putc(fd, '%');
 94e:	85d2                	mv	a1,s4
 950:	8556                	mv	a0,s5
 952:	00000097          	auipc	ra,0x0
 956:	d90080e7          	jalr	-624(ra) # 6e2 <putc>
        putc(fd, c);
 95a:	85ca                	mv	a1,s2
 95c:	8556                	mv	a0,s5
 95e:	00000097          	auipc	ra,0x0
 962:	d84080e7          	jalr	-636(ra) # 6e2 <putc>
      state = 0;
 966:	4981                	li	s3,0
 968:	b565                	j	810 <vprintf+0x60>
        s = va_arg(ap, char*);
 96a:	8b4a                	mv	s6,s2
      state = 0;
 96c:	4981                	li	s3,0
 96e:	b54d                	j	810 <vprintf+0x60>
    }
  }
}
 970:	70e6                	ld	ra,120(sp)
 972:	7446                	ld	s0,112(sp)
 974:	74a6                	ld	s1,104(sp)
 976:	7906                	ld	s2,96(sp)
 978:	69e6                	ld	s3,88(sp)
 97a:	6a46                	ld	s4,80(sp)
 97c:	6aa6                	ld	s5,72(sp)
 97e:	6b06                	ld	s6,64(sp)
 980:	7be2                	ld	s7,56(sp)
 982:	7c42                	ld	s8,48(sp)
 984:	7ca2                	ld	s9,40(sp)
 986:	7d02                	ld	s10,32(sp)
 988:	6de2                	ld	s11,24(sp)
 98a:	6109                	addi	sp,sp,128
 98c:	8082                	ret

000000000000098e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 98e:	715d                	addi	sp,sp,-80
 990:	ec06                	sd	ra,24(sp)
 992:	e822                	sd	s0,16(sp)
 994:	1000                	addi	s0,sp,32
 996:	e010                	sd	a2,0(s0)
 998:	e414                	sd	a3,8(s0)
 99a:	e818                	sd	a4,16(s0)
 99c:	ec1c                	sd	a5,24(s0)
 99e:	03043023          	sd	a6,32(s0)
 9a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9aa:	8622                	mv	a2,s0
 9ac:	00000097          	auipc	ra,0x0
 9b0:	e04080e7          	jalr	-508(ra) # 7b0 <vprintf>
}
 9b4:	60e2                	ld	ra,24(sp)
 9b6:	6442                	ld	s0,16(sp)
 9b8:	6161                	addi	sp,sp,80
 9ba:	8082                	ret

00000000000009bc <printf>:

void
printf(const char *fmt, ...)
{
 9bc:	711d                	addi	sp,sp,-96
 9be:	ec06                	sd	ra,24(sp)
 9c0:	e822                	sd	s0,16(sp)
 9c2:	1000                	addi	s0,sp,32
 9c4:	e40c                	sd	a1,8(s0)
 9c6:	e810                	sd	a2,16(s0)
 9c8:	ec14                	sd	a3,24(s0)
 9ca:	f018                	sd	a4,32(s0)
 9cc:	f41c                	sd	a5,40(s0)
 9ce:	03043823          	sd	a6,48(s0)
 9d2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9d6:	00840613          	addi	a2,s0,8
 9da:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9de:	85aa                	mv	a1,a0
 9e0:	4505                	li	a0,1
 9e2:	00000097          	auipc	ra,0x0
 9e6:	dce080e7          	jalr	-562(ra) # 7b0 <vprintf>
}
 9ea:	60e2                	ld	ra,24(sp)
 9ec:	6442                	ld	s0,16(sp)
 9ee:	6125                	addi	sp,sp,96
 9f0:	8082                	ret

00000000000009f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9f2:	1141                	addi	sp,sp,-16
 9f4:	e422                	sd	s0,8(sp)
 9f6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9f8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9fc:	00000797          	auipc	a5,0x0
 a00:	37c7b783          	ld	a5,892(a5) # d78 <freep>
 a04:	a02d                	j	a2e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a06:	4618                	lw	a4,8(a2)
 a08:	9f2d                	addw	a4,a4,a1
 a0a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a0e:	6398                	ld	a4,0(a5)
 a10:	6310                	ld	a2,0(a4)
 a12:	a83d                	j	a50 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a14:	ff852703          	lw	a4,-8(a0)
 a18:	9f31                	addw	a4,a4,a2
 a1a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a1c:	ff053683          	ld	a3,-16(a0)
 a20:	a091                	j	a64 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a22:	6398                	ld	a4,0(a5)
 a24:	00e7e463          	bltu	a5,a4,a2c <free+0x3a>
 a28:	00e6ea63          	bltu	a3,a4,a3c <free+0x4a>
{
 a2c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a2e:	fed7fae3          	bgeu	a5,a3,a22 <free+0x30>
 a32:	6398                	ld	a4,0(a5)
 a34:	00e6e463          	bltu	a3,a4,a3c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a38:	fee7eae3          	bltu	a5,a4,a2c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a3c:	ff852583          	lw	a1,-8(a0)
 a40:	6390                	ld	a2,0(a5)
 a42:	02059813          	slli	a6,a1,0x20
 a46:	01c85713          	srli	a4,a6,0x1c
 a4a:	9736                	add	a4,a4,a3
 a4c:	fae60de3          	beq	a2,a4,a06 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a50:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a54:	4790                	lw	a2,8(a5)
 a56:	02061593          	slli	a1,a2,0x20
 a5a:	01c5d713          	srli	a4,a1,0x1c
 a5e:	973e                	add	a4,a4,a5
 a60:	fae68ae3          	beq	a3,a4,a14 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a64:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a66:	00000717          	auipc	a4,0x0
 a6a:	30f73923          	sd	a5,786(a4) # d78 <freep>
}
 a6e:	6422                	ld	s0,8(sp)
 a70:	0141                	addi	sp,sp,16
 a72:	8082                	ret

0000000000000a74 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a74:	7139                	addi	sp,sp,-64
 a76:	fc06                	sd	ra,56(sp)
 a78:	f822                	sd	s0,48(sp)
 a7a:	f426                	sd	s1,40(sp)
 a7c:	f04a                	sd	s2,32(sp)
 a7e:	ec4e                	sd	s3,24(sp)
 a80:	e852                	sd	s4,16(sp)
 a82:	e456                	sd	s5,8(sp)
 a84:	e05a                	sd	s6,0(sp)
 a86:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a88:	02051493          	slli	s1,a0,0x20
 a8c:	9081                	srli	s1,s1,0x20
 a8e:	04bd                	addi	s1,s1,15
 a90:	8091                	srli	s1,s1,0x4
 a92:	0014899b          	addiw	s3,s1,1
 a96:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a98:	00000517          	auipc	a0,0x0
 a9c:	2e053503          	ld	a0,736(a0) # d78 <freep>
 aa0:	c515                	beqz	a0,acc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa4:	4798                	lw	a4,8(a5)
 aa6:	02977f63          	bgeu	a4,s1,ae4 <malloc+0x70>
 aaa:	8a4e                	mv	s4,s3
 aac:	0009871b          	sext.w	a4,s3
 ab0:	6685                	lui	a3,0x1
 ab2:	00d77363          	bgeu	a4,a3,ab8 <malloc+0x44>
 ab6:	6a05                	lui	s4,0x1
 ab8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 abc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ac0:	00000917          	auipc	s2,0x0
 ac4:	2b890913          	addi	s2,s2,696 # d78 <freep>
  if(p == (char*)-1)
 ac8:	5afd                	li	s5,-1
 aca:	a895                	j	b3e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 acc:	00000797          	auipc	a5,0x0
 ad0:	2b478793          	addi	a5,a5,692 # d80 <base>
 ad4:	00000717          	auipc	a4,0x0
 ad8:	2af73223          	sd	a5,676(a4) # d78 <freep>
 adc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ade:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ae2:	b7e1                	j	aaa <malloc+0x36>
      if(p->s.size == nunits)
 ae4:	02e48c63          	beq	s1,a4,b1c <malloc+0xa8>
        p->s.size -= nunits;
 ae8:	4137073b          	subw	a4,a4,s3
 aec:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aee:	02071693          	slli	a3,a4,0x20
 af2:	01c6d713          	srli	a4,a3,0x1c
 af6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 af8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 afc:	00000717          	auipc	a4,0x0
 b00:	26a73e23          	sd	a0,636(a4) # d78 <freep>
      return (void*)(p + 1);
 b04:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b08:	70e2                	ld	ra,56(sp)
 b0a:	7442                	ld	s0,48(sp)
 b0c:	74a2                	ld	s1,40(sp)
 b0e:	7902                	ld	s2,32(sp)
 b10:	69e2                	ld	s3,24(sp)
 b12:	6a42                	ld	s4,16(sp)
 b14:	6aa2                	ld	s5,8(sp)
 b16:	6b02                	ld	s6,0(sp)
 b18:	6121                	addi	sp,sp,64
 b1a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b1c:	6398                	ld	a4,0(a5)
 b1e:	e118                	sd	a4,0(a0)
 b20:	bff1                	j	afc <malloc+0x88>
  hp->s.size = nu;
 b22:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b26:	0541                	addi	a0,a0,16
 b28:	00000097          	auipc	ra,0x0
 b2c:	eca080e7          	jalr	-310(ra) # 9f2 <free>
  return freep;
 b30:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b34:	d971                	beqz	a0,b08 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b36:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b38:	4798                	lw	a4,8(a5)
 b3a:	fa9775e3          	bgeu	a4,s1,ae4 <malloc+0x70>
    if(p == freep)
 b3e:	00093703          	ld	a4,0(s2)
 b42:	853e                	mv	a0,a5
 b44:	fef719e3          	bne	a4,a5,b36 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 b48:	8552                	mv	a0,s4
 b4a:	00000097          	auipc	ra,0x0
 b4e:	b70080e7          	jalr	-1168(ra) # 6ba <sbrk>
  if(p == (char*)-1)
 b52:	fd5518e3          	bne	a0,s5,b22 <malloc+0xae>
        return 0;
 b56:	4501                	li	a0,0
 b58:	bf45                	j	b08 <malloc+0x94>
