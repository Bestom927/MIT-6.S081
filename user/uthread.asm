
user/_uthread：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread *current_thread;
extern void thread_switch(uint64, uint64);
              
void 
thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	d9278793          	addi	a5,a5,-622 # d98 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	d6f73d23          	sd	a5,-646(a4) # d88 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	d8f72023          	sw	a5,-640(a4) # 2d98 <__global_pointer$+0x182f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:

void 
thread_schedule(void)
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  2e:	00001317          	auipc	t1,0x1
  32:	d5a33303          	ld	t1,-678(t1) # d88 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	04058593          	addi	a1,a1,64 # 2040 <__global_pointer$+0xad7>
  3c:	959a                	add	a1,a1,t1
  3e:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  40:	00009817          	auipc	a6,0x9
  44:	e5880813          	addi	a6,a6,-424 # 8e98 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  48:	6689                	lui	a3,0x2
  4a:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  4c:	04068893          	addi	a7,a3,64 # 2040 <__global_pointer$+0xad7>
  50:	a809                	j	62 <thread_schedule+0x3c>
    if(t->state == RUNNABLE) {
  52:	00d58733          	add	a4,a1,a3
  56:	4318                	lw	a4,0(a4)
  58:	02c70963          	beq	a4,a2,8a <thread_schedule+0x64>
    t = t + 1;
  5c:	95c6                	add	a1,a1,a7
  for(int i = 0; i < MAX_THREAD; i++){
  5e:	37fd                	addiw	a5,a5,-1
  60:	cb81                	beqz	a5,70 <thread_schedule+0x4a>
    if(t >= all_thread + MAX_THREAD)
  62:	ff05e8e3          	bltu	a1,a6,52 <thread_schedule+0x2c>
      t = all_thread;
  66:	00001597          	auipc	a1,0x1
  6a:	d3258593          	addi	a1,a1,-718 # d98 <all_thread>
  6e:	b7d5                	j	52 <thread_schedule+0x2c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  70:	00001517          	auipc	a0,0x1
  74:	b8850513          	addi	a0,a0,-1144 # bf8 <malloc+0xea>
  78:	00001097          	auipc	ra,0x1
  7c:	9de080e7          	jalr	-1570(ra) # a56 <printf>
    exit(-1);
  80:	557d                	li	a0,-1
  82:	00000097          	auipc	ra,0x0
  86:	65a080e7          	jalr	1626(ra) # 6dc <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  8a:	02b30263          	beq	t1,a1,ae <thread_schedule+0x88>
    next_thread->state = RUNNING;
  8e:	6509                	lui	a0,0x2
  90:	00a587b3          	add	a5,a1,a0
  94:	4705                	li	a4,1
  96:	c398                	sw	a4,0(a5)
    t = current_thread;
    current_thread = next_thread;
  98:	00001797          	auipc	a5,0x1
  9c:	ceb7b823          	sd	a1,-784(a5) # d88 <current_thread>
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
     thread_switch((uint64)&t->context, (uint64)&current_thread->context);
  a0:	0521                	addi	a0,a0,8 # 2008 <__global_pointer$+0xa9f>
  a2:	95aa                	add	a1,a1,a0
  a4:	951a                	add	a0,a0,t1
  a6:	00000097          	auipc	ra,0x0
  aa:	360080e7          	jalr	864(ra) # 406 <thread_switch>
  } else
    next_thread = 0;
}
  ae:	60a2                	ld	ra,8(sp)
  b0:	6402                	ld	s0,0(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <thread_create>:

void 
thread_create(void (*func)())
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  bc:	00001797          	auipc	a5,0x1
  c0:	cdc78793          	addi	a5,a5,-804 # d98 <all_thread>
    if (t->state == FREE) break;
  c4:	6689                	lui	a3,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c6:	04068593          	addi	a1,a3,64 # 2040 <__global_pointer$+0xad7>
  ca:	00009617          	auipc	a2,0x9
  ce:	dce60613          	addi	a2,a2,-562 # 8e98 <base>
    if (t->state == FREE) break;
  d2:	00d78733          	add	a4,a5,a3
  d6:	4318                	lw	a4,0(a4)
  d8:	c701                	beqz	a4,e0 <thread_create+0x2a>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  da:	97ae                	add	a5,a5,a1
  dc:	fec79be3          	bne	a5,a2,d2 <thread_create+0x1c>
  }
  t->state = RUNNABLE;
  e0:	6709                	lui	a4,0x2
  e2:	00e786b3          	add	a3,a5,a4
  e6:	4609                	li	a2,2
  e8:	c290                	sw	a2,0(a3)
  // YOUR CODE HERE
  t->context.ra = (uint64)func;
  ea:	e688                	sd	a0,8(a3)
  t->context.sp = (uint64)t->stack + 4096 * 2 - 1;
  ec:	177d                	addi	a4,a4,-1 # 1fff <__global_pointer$+0xa96>
  ee:	97ba                	add	a5,a5,a4
  f0:	ea9c                	sd	a5,16(a3)
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret

00000000000000f8 <thread_yield>:

void 
thread_yield(void)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
 100:	00001797          	auipc	a5,0x1
 104:	c887b783          	ld	a5,-888(a5) # d88 <current_thread>
 108:	6709                	lui	a4,0x2
 10a:	97ba                	add	a5,a5,a4
 10c:	4709                	li	a4,2
 10e:	c398                	sw	a4,0(a5)
  thread_schedule();
 110:	00000097          	auipc	ra,0x0
 114:	f16080e7          	jalr	-234(ra) # 26 <thread_schedule>
}
 118:	60a2                	ld	ra,8(sp)
 11a:	6402                	ld	s0,0(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret

0000000000000120 <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 120:	7179                	addi	sp,sp,-48
 122:	f406                	sd	ra,40(sp)
 124:	f022                	sd	s0,32(sp)
 126:	ec26                	sd	s1,24(sp)
 128:	e84a                	sd	s2,16(sp)
 12a:	e44e                	sd	s3,8(sp)
 12c:	e052                	sd	s4,0(sp)
 12e:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 130:	00001517          	auipc	a0,0x1
 134:	af050513          	addi	a0,a0,-1296 # c20 <malloc+0x112>
 138:	00001097          	auipc	ra,0x1
 13c:	91e080e7          	jalr	-1762(ra) # a56 <printf>
  a_started = 1;
 140:	4785                	li	a5,1
 142:	00001717          	auipc	a4,0x1
 146:	c4f72123          	sw	a5,-958(a4) # d84 <a_started>
  while(b_started == 0 || c_started == 0)
 14a:	00001497          	auipc	s1,0x1
 14e:	c3648493          	addi	s1,s1,-970 # d80 <b_started>
 152:	00001917          	auipc	s2,0x1
 156:	c2a90913          	addi	s2,s2,-982 # d7c <c_started>
 15a:	a029                	j	164 <thread_a+0x44>
    thread_yield();
 15c:	00000097          	auipc	ra,0x0
 160:	f9c080e7          	jalr	-100(ra) # f8 <thread_yield>
  while(b_started == 0 || c_started == 0)
 164:	409c                	lw	a5,0(s1)
 166:	2781                	sext.w	a5,a5
 168:	dbf5                	beqz	a5,15c <thread_a+0x3c>
 16a:	00092783          	lw	a5,0(s2)
 16e:	2781                	sext.w	a5,a5
 170:	d7f5                	beqz	a5,15c <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 172:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 174:	00001a17          	auipc	s4,0x1
 178:	ac4a0a13          	addi	s4,s4,-1340 # c38 <malloc+0x12a>
    a_n += 1;
 17c:	00001917          	auipc	s2,0x1
 180:	bfc90913          	addi	s2,s2,-1028 # d78 <a_n>
  for (i = 0; i < 100; i++) {
 184:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 188:	85a6                	mv	a1,s1
 18a:	8552                	mv	a0,s4
 18c:	00001097          	auipc	ra,0x1
 190:	8ca080e7          	jalr	-1846(ra) # a56 <printf>
    a_n += 1;
 194:	00092783          	lw	a5,0(s2)
 198:	2785                	addiw	a5,a5,1
 19a:	00f92023          	sw	a5,0(s2)
    thread_yield();
 19e:	00000097          	auipc	ra,0x0
 1a2:	f5a080e7          	jalr	-166(ra) # f8 <thread_yield>
  for (i = 0; i < 100; i++) {
 1a6:	2485                	addiw	s1,s1,1
 1a8:	ff3490e3          	bne	s1,s3,188 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 1ac:	00001597          	auipc	a1,0x1
 1b0:	bcc5a583          	lw	a1,-1076(a1) # d78 <a_n>
 1b4:	00001517          	auipc	a0,0x1
 1b8:	a9450513          	addi	a0,a0,-1388 # c48 <malloc+0x13a>
 1bc:	00001097          	auipc	ra,0x1
 1c0:	89a080e7          	jalr	-1894(ra) # a56 <printf>

  current_thread->state = FREE;
 1c4:	00001797          	auipc	a5,0x1
 1c8:	bc47b783          	ld	a5,-1084(a5) # d88 <current_thread>
 1cc:	6709                	lui	a4,0x2
 1ce:	97ba                	add	a5,a5,a4
 1d0:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1d4:	00000097          	auipc	ra,0x0
 1d8:	e52080e7          	jalr	-430(ra) # 26 <thread_schedule>
}
 1dc:	70a2                	ld	ra,40(sp)
 1de:	7402                	ld	s0,32(sp)
 1e0:	64e2                	ld	s1,24(sp)
 1e2:	6942                	ld	s2,16(sp)
 1e4:	69a2                	ld	s3,8(sp)
 1e6:	6a02                	ld	s4,0(sp)
 1e8:	6145                	addi	sp,sp,48
 1ea:	8082                	ret

00000000000001ec <thread_b>:

void 
thread_b(void)
{
 1ec:	7179                	addi	sp,sp,-48
 1ee:	f406                	sd	ra,40(sp)
 1f0:	f022                	sd	s0,32(sp)
 1f2:	ec26                	sd	s1,24(sp)
 1f4:	e84a                	sd	s2,16(sp)
 1f6:	e44e                	sd	s3,8(sp)
 1f8:	e052                	sd	s4,0(sp)
 1fa:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 1fc:	00001517          	auipc	a0,0x1
 200:	a6c50513          	addi	a0,a0,-1428 # c68 <malloc+0x15a>
 204:	00001097          	auipc	ra,0x1
 208:	852080e7          	jalr	-1966(ra) # a56 <printf>
  b_started = 1;
 20c:	4785                	li	a5,1
 20e:	00001717          	auipc	a4,0x1
 212:	b6f72923          	sw	a5,-1166(a4) # d80 <b_started>
  while(a_started == 0 || c_started == 0)
 216:	00001497          	auipc	s1,0x1
 21a:	b6e48493          	addi	s1,s1,-1170 # d84 <a_started>
 21e:	00001917          	auipc	s2,0x1
 222:	b5e90913          	addi	s2,s2,-1186 # d7c <c_started>
 226:	a029                	j	230 <thread_b+0x44>
    thread_yield();
 228:	00000097          	auipc	ra,0x0
 22c:	ed0080e7          	jalr	-304(ra) # f8 <thread_yield>
  while(a_started == 0 || c_started == 0)
 230:	409c                	lw	a5,0(s1)
 232:	2781                	sext.w	a5,a5
 234:	dbf5                	beqz	a5,228 <thread_b+0x3c>
 236:	00092783          	lw	a5,0(s2)
 23a:	2781                	sext.w	a5,a5
 23c:	d7f5                	beqz	a5,228 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 23e:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 240:	00001a17          	auipc	s4,0x1
 244:	a40a0a13          	addi	s4,s4,-1472 # c80 <malloc+0x172>
    b_n += 1;
 248:	00001917          	auipc	s2,0x1
 24c:	b2c90913          	addi	s2,s2,-1236 # d74 <b_n>
  for (i = 0; i < 100; i++) {
 250:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 254:	85a6                	mv	a1,s1
 256:	8552                	mv	a0,s4
 258:	00000097          	auipc	ra,0x0
 25c:	7fe080e7          	jalr	2046(ra) # a56 <printf>
    b_n += 1;
 260:	00092783          	lw	a5,0(s2)
 264:	2785                	addiw	a5,a5,1
 266:	00f92023          	sw	a5,0(s2)
    thread_yield();
 26a:	00000097          	auipc	ra,0x0
 26e:	e8e080e7          	jalr	-370(ra) # f8 <thread_yield>
  for (i = 0; i < 100; i++) {
 272:	2485                	addiw	s1,s1,1
 274:	ff3490e3          	bne	s1,s3,254 <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 278:	00001597          	auipc	a1,0x1
 27c:	afc5a583          	lw	a1,-1284(a1) # d74 <b_n>
 280:	00001517          	auipc	a0,0x1
 284:	a1050513          	addi	a0,a0,-1520 # c90 <malloc+0x182>
 288:	00000097          	auipc	ra,0x0
 28c:	7ce080e7          	jalr	1998(ra) # a56 <printf>

  current_thread->state = FREE;
 290:	00001797          	auipc	a5,0x1
 294:	af87b783          	ld	a5,-1288(a5) # d88 <current_thread>
 298:	6709                	lui	a4,0x2
 29a:	97ba                	add	a5,a5,a4
 29c:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 2a0:	00000097          	auipc	ra,0x0
 2a4:	d86080e7          	jalr	-634(ra) # 26 <thread_schedule>
}
 2a8:	70a2                	ld	ra,40(sp)
 2aa:	7402                	ld	s0,32(sp)
 2ac:	64e2                	ld	s1,24(sp)
 2ae:	6942                	ld	s2,16(sp)
 2b0:	69a2                	ld	s3,8(sp)
 2b2:	6a02                	ld	s4,0(sp)
 2b4:	6145                	addi	sp,sp,48
 2b6:	8082                	ret

00000000000002b8 <thread_c>:

void 
thread_c(void)
{
 2b8:	7179                	addi	sp,sp,-48
 2ba:	f406                	sd	ra,40(sp)
 2bc:	f022                	sd	s0,32(sp)
 2be:	ec26                	sd	s1,24(sp)
 2c0:	e84a                	sd	s2,16(sp)
 2c2:	e44e                	sd	s3,8(sp)
 2c4:	e052                	sd	s4,0(sp)
 2c6:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 2c8:	00001517          	auipc	a0,0x1
 2cc:	9e850513          	addi	a0,a0,-1560 # cb0 <malloc+0x1a2>
 2d0:	00000097          	auipc	ra,0x0
 2d4:	786080e7          	jalr	1926(ra) # a56 <printf>
  c_started = 1;
 2d8:	4785                	li	a5,1
 2da:	00001717          	auipc	a4,0x1
 2de:	aaf72123          	sw	a5,-1374(a4) # d7c <c_started>
  while(a_started == 0 || b_started == 0)
 2e2:	00001497          	auipc	s1,0x1
 2e6:	aa248493          	addi	s1,s1,-1374 # d84 <a_started>
 2ea:	00001917          	auipc	s2,0x1
 2ee:	a9690913          	addi	s2,s2,-1386 # d80 <b_started>
 2f2:	a029                	j	2fc <thread_c+0x44>
    thread_yield();
 2f4:	00000097          	auipc	ra,0x0
 2f8:	e04080e7          	jalr	-508(ra) # f8 <thread_yield>
  while(a_started == 0 || b_started == 0)
 2fc:	409c                	lw	a5,0(s1)
 2fe:	2781                	sext.w	a5,a5
 300:	dbf5                	beqz	a5,2f4 <thread_c+0x3c>
 302:	00092783          	lw	a5,0(s2)
 306:	2781                	sext.w	a5,a5
 308:	d7f5                	beqz	a5,2f4 <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 30a:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 30c:	00001a17          	auipc	s4,0x1
 310:	9bca0a13          	addi	s4,s4,-1604 # cc8 <malloc+0x1ba>
    c_n += 1;
 314:	00001917          	auipc	s2,0x1
 318:	a5c90913          	addi	s2,s2,-1444 # d70 <c_n>
  for (i = 0; i < 100; i++) {
 31c:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 320:	85a6                	mv	a1,s1
 322:	8552                	mv	a0,s4
 324:	00000097          	auipc	ra,0x0
 328:	732080e7          	jalr	1842(ra) # a56 <printf>
    c_n += 1;
 32c:	00092783          	lw	a5,0(s2)
 330:	2785                	addiw	a5,a5,1
 332:	00f92023          	sw	a5,0(s2)
    thread_yield();
 336:	00000097          	auipc	ra,0x0
 33a:	dc2080e7          	jalr	-574(ra) # f8 <thread_yield>
  for (i = 0; i < 100; i++) {
 33e:	2485                	addiw	s1,s1,1
 340:	ff3490e3          	bne	s1,s3,320 <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 344:	00001597          	auipc	a1,0x1
 348:	a2c5a583          	lw	a1,-1492(a1) # d70 <c_n>
 34c:	00001517          	auipc	a0,0x1
 350:	98c50513          	addi	a0,a0,-1652 # cd8 <malloc+0x1ca>
 354:	00000097          	auipc	ra,0x0
 358:	702080e7          	jalr	1794(ra) # a56 <printf>

  current_thread->state = FREE;
 35c:	00001797          	auipc	a5,0x1
 360:	a2c7b783          	ld	a5,-1492(a5) # d88 <current_thread>
 364:	6709                	lui	a4,0x2
 366:	97ba                	add	a5,a5,a4
 368:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 36c:	00000097          	auipc	ra,0x0
 370:	cba080e7          	jalr	-838(ra) # 26 <thread_schedule>
}
 374:	70a2                	ld	ra,40(sp)
 376:	7402                	ld	s0,32(sp)
 378:	64e2                	ld	s1,24(sp)
 37a:	6942                	ld	s2,16(sp)
 37c:	69a2                	ld	s3,8(sp)
 37e:	6a02                	ld	s4,0(sp)
 380:	6145                	addi	sp,sp,48
 382:	8082                	ret

0000000000000384 <main>:

int 
main(int argc, char *argv[]) 
{
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 38c:	00001797          	auipc	a5,0x1
 390:	9e07a823          	sw	zero,-1552(a5) # d7c <c_started>
 394:	00001797          	auipc	a5,0x1
 398:	9e07a623          	sw	zero,-1556(a5) # d80 <b_started>
 39c:	00001797          	auipc	a5,0x1
 3a0:	9e07a423          	sw	zero,-1560(a5) # d84 <a_started>
  a_n = b_n = c_n = 0;
 3a4:	00001797          	auipc	a5,0x1
 3a8:	9c07a623          	sw	zero,-1588(a5) # d70 <c_n>
 3ac:	00001797          	auipc	a5,0x1
 3b0:	9c07a423          	sw	zero,-1592(a5) # d74 <b_n>
 3b4:	00001797          	auipc	a5,0x1
 3b8:	9c07a223          	sw	zero,-1596(a5) # d78 <a_n>
  thread_init();
 3bc:	00000097          	auipc	ra,0x0
 3c0:	c44080e7          	jalr	-956(ra) # 0 <thread_init>
  thread_create(thread_a);
 3c4:	00000517          	auipc	a0,0x0
 3c8:	d5c50513          	addi	a0,a0,-676 # 120 <thread_a>
 3cc:	00000097          	auipc	ra,0x0
 3d0:	cea080e7          	jalr	-790(ra) # b6 <thread_create>
  thread_create(thread_b);
 3d4:	00000517          	auipc	a0,0x0
 3d8:	e1850513          	addi	a0,a0,-488 # 1ec <thread_b>
 3dc:	00000097          	auipc	ra,0x0
 3e0:	cda080e7          	jalr	-806(ra) # b6 <thread_create>
  thread_create(thread_c);
 3e4:	00000517          	auipc	a0,0x0
 3e8:	ed450513          	addi	a0,a0,-300 # 2b8 <thread_c>
 3ec:	00000097          	auipc	ra,0x0
 3f0:	cca080e7          	jalr	-822(ra) # b6 <thread_create>
  thread_schedule();
 3f4:	00000097          	auipc	ra,0x0
 3f8:	c32080e7          	jalr	-974(ra) # 26 <thread_schedule>
  exit(0);
 3fc:	4501                	li	a0,0
 3fe:	00000097          	auipc	ra,0x0
 402:	2de080e7          	jalr	734(ra) # 6dc <exit>

0000000000000406 <thread_switch>:


	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
    sd ra, 0(a0)
 406:	00153023          	sd	ra,0(a0)
    sd sp, 8(a0)
 40a:	00253423          	sd	sp,8(a0)
    sd s0, 16(a0)
 40e:	e900                	sd	s0,16(a0)
    sd s1, 24(a0)
 410:	ed04                	sd	s1,24(a0)
    sd s2, 32(a0)
 412:	03253023          	sd	s2,32(a0)
    sd s3, 40(a0)
 416:	03353423          	sd	s3,40(a0)
    sd s4, 48(a0)
 41a:	03453823          	sd	s4,48(a0)
    sd s5, 56(a0)
 41e:	03553c23          	sd	s5,56(a0)
    sd s6, 64(a0)
 422:	05653023          	sd	s6,64(a0)
    sd s7, 72(a0)
 426:	05753423          	sd	s7,72(a0)
    sd s8, 80(a0)
 42a:	05853823          	sd	s8,80(a0)
    sd s9, 88(a0)
 42e:	05953c23          	sd	s9,88(a0)
    sd s10, 96(a0)
 432:	07a53023          	sd	s10,96(a0)
    sd s11, 104(a0)
 436:	07b53423          	sd	s11,104(a0)
    
    ld ra, 0(a1)
 43a:	0005b083          	ld	ra,0(a1)
    ld sp, 8(a1)
 43e:	0085b103          	ld	sp,8(a1)
    ld s0, 16(a1)
 442:	6980                	ld	s0,16(a1)
    ld s1, 24(a1)
 444:	6d84                	ld	s1,24(a1)
    ld s2, 32(a1)
 446:	0205b903          	ld	s2,32(a1)
    ld s3, 40(a1)
 44a:	0285b983          	ld	s3,40(a1)
    ld s4, 48(a1)
 44e:	0305ba03          	ld	s4,48(a1)
    ld s5, 56(a1)
 452:	0385ba83          	ld	s5,56(a1)
    ld s6, 64(a1)
 456:	0405bb03          	ld	s6,64(a1)
    ld s7, 72(a1)
 45a:	0485bb83          	ld	s7,72(a1)
    ld s8, 80(a1)
 45e:	0505bc03          	ld	s8,80(a1)
    ld s9, 88(a1)
 462:	0585bc83          	ld	s9,88(a1)
    ld s10, 96(a1)
 466:	0605bd03          	ld	s10,96(a1)
    ld s11, 104(a1)
 46a:	0685bd83          	ld	s11,104(a1)

	ret    /* return to ra */
 46e:	8082                	ret

0000000000000470 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 470:	1141                	addi	sp,sp,-16
 472:	e422                	sd	s0,8(sp)
 474:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 476:	87aa                	mv	a5,a0
 478:	0585                	addi	a1,a1,1
 47a:	0785                	addi	a5,a5,1
 47c:	fff5c703          	lbu	a4,-1(a1)
 480:	fee78fa3          	sb	a4,-1(a5)
 484:	fb75                	bnez	a4,478 <strcpy+0x8>
    ;
  return os;
}
 486:	6422                	ld	s0,8(sp)
 488:	0141                	addi	sp,sp,16
 48a:	8082                	ret

000000000000048c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 48c:	1141                	addi	sp,sp,-16
 48e:	e422                	sd	s0,8(sp)
 490:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 492:	00054783          	lbu	a5,0(a0)
 496:	cb91                	beqz	a5,4aa <strcmp+0x1e>
 498:	0005c703          	lbu	a4,0(a1)
 49c:	00f71763          	bne	a4,a5,4aa <strcmp+0x1e>
    p++, q++;
 4a0:	0505                	addi	a0,a0,1
 4a2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4a4:	00054783          	lbu	a5,0(a0)
 4a8:	fbe5                	bnez	a5,498 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4aa:	0005c503          	lbu	a0,0(a1)
}
 4ae:	40a7853b          	subw	a0,a5,a0
 4b2:	6422                	ld	s0,8(sp)
 4b4:	0141                	addi	sp,sp,16
 4b6:	8082                	ret

00000000000004b8 <strlen>:

uint
strlen(const char *s)
{
 4b8:	1141                	addi	sp,sp,-16
 4ba:	e422                	sd	s0,8(sp)
 4bc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4be:	00054783          	lbu	a5,0(a0)
 4c2:	cf91                	beqz	a5,4de <strlen+0x26>
 4c4:	0505                	addi	a0,a0,1
 4c6:	87aa                	mv	a5,a0
 4c8:	4685                	li	a3,1
 4ca:	9e89                	subw	a3,a3,a0
 4cc:	00f6853b          	addw	a0,a3,a5
 4d0:	0785                	addi	a5,a5,1
 4d2:	fff7c703          	lbu	a4,-1(a5)
 4d6:	fb7d                	bnez	a4,4cc <strlen+0x14>
    ;
  return n;
}
 4d8:	6422                	ld	s0,8(sp)
 4da:	0141                	addi	sp,sp,16
 4dc:	8082                	ret
  for(n = 0; s[n]; n++)
 4de:	4501                	li	a0,0
 4e0:	bfe5                	j	4d8 <strlen+0x20>

00000000000004e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4e2:	1141                	addi	sp,sp,-16
 4e4:	e422                	sd	s0,8(sp)
 4e6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4e8:	ca19                	beqz	a2,4fe <memset+0x1c>
 4ea:	87aa                	mv	a5,a0
 4ec:	1602                	slli	a2,a2,0x20
 4ee:	9201                	srli	a2,a2,0x20
 4f0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4f4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4f8:	0785                	addi	a5,a5,1
 4fa:	fee79de3          	bne	a5,a4,4f4 <memset+0x12>
  }
  return dst;
}
 4fe:	6422                	ld	s0,8(sp)
 500:	0141                	addi	sp,sp,16
 502:	8082                	ret

0000000000000504 <strchr>:

char*
strchr(const char *s, char c)
{
 504:	1141                	addi	sp,sp,-16
 506:	e422                	sd	s0,8(sp)
 508:	0800                	addi	s0,sp,16
  for(; *s; s++)
 50a:	00054783          	lbu	a5,0(a0)
 50e:	cb99                	beqz	a5,524 <strchr+0x20>
    if(*s == c)
 510:	00f58763          	beq	a1,a5,51e <strchr+0x1a>
  for(; *s; s++)
 514:	0505                	addi	a0,a0,1
 516:	00054783          	lbu	a5,0(a0)
 51a:	fbfd                	bnez	a5,510 <strchr+0xc>
      return (char*)s;
  return 0;
 51c:	4501                	li	a0,0
}
 51e:	6422                	ld	s0,8(sp)
 520:	0141                	addi	sp,sp,16
 522:	8082                	ret
  return 0;
 524:	4501                	li	a0,0
 526:	bfe5                	j	51e <strchr+0x1a>

0000000000000528 <gets>:

char*
gets(char *buf, int max)
{
 528:	711d                	addi	sp,sp,-96
 52a:	ec86                	sd	ra,88(sp)
 52c:	e8a2                	sd	s0,80(sp)
 52e:	e4a6                	sd	s1,72(sp)
 530:	e0ca                	sd	s2,64(sp)
 532:	fc4e                	sd	s3,56(sp)
 534:	f852                	sd	s4,48(sp)
 536:	f456                	sd	s5,40(sp)
 538:	f05a                	sd	s6,32(sp)
 53a:	ec5e                	sd	s7,24(sp)
 53c:	1080                	addi	s0,sp,96
 53e:	8baa                	mv	s7,a0
 540:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 542:	892a                	mv	s2,a0
 544:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 546:	4aa9                	li	s5,10
 548:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 54a:	89a6                	mv	s3,s1
 54c:	2485                	addiw	s1,s1,1
 54e:	0344d863          	bge	s1,s4,57e <gets+0x56>
    cc = read(0, &c, 1);
 552:	4605                	li	a2,1
 554:	faf40593          	addi	a1,s0,-81
 558:	4501                	li	a0,0
 55a:	00000097          	auipc	ra,0x0
 55e:	19a080e7          	jalr	410(ra) # 6f4 <read>
    if(cc < 1)
 562:	00a05e63          	blez	a0,57e <gets+0x56>
    buf[i++] = c;
 566:	faf44783          	lbu	a5,-81(s0)
 56a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 56e:	01578763          	beq	a5,s5,57c <gets+0x54>
 572:	0905                	addi	s2,s2,1
 574:	fd679be3          	bne	a5,s6,54a <gets+0x22>
  for(i=0; i+1 < max; ){
 578:	89a6                	mv	s3,s1
 57a:	a011                	j	57e <gets+0x56>
 57c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 57e:	99de                	add	s3,s3,s7
 580:	00098023          	sb	zero,0(s3)
  return buf;
}
 584:	855e                	mv	a0,s7
 586:	60e6                	ld	ra,88(sp)
 588:	6446                	ld	s0,80(sp)
 58a:	64a6                	ld	s1,72(sp)
 58c:	6906                	ld	s2,64(sp)
 58e:	79e2                	ld	s3,56(sp)
 590:	7a42                	ld	s4,48(sp)
 592:	7aa2                	ld	s5,40(sp)
 594:	7b02                	ld	s6,32(sp)
 596:	6be2                	ld	s7,24(sp)
 598:	6125                	addi	sp,sp,96
 59a:	8082                	ret

000000000000059c <stat>:

int
stat(const char *n, struct stat *st)
{
 59c:	1101                	addi	sp,sp,-32
 59e:	ec06                	sd	ra,24(sp)
 5a0:	e822                	sd	s0,16(sp)
 5a2:	e426                	sd	s1,8(sp)
 5a4:	e04a                	sd	s2,0(sp)
 5a6:	1000                	addi	s0,sp,32
 5a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5aa:	4581                	li	a1,0
 5ac:	00000097          	auipc	ra,0x0
 5b0:	170080e7          	jalr	368(ra) # 71c <open>
  if(fd < 0)
 5b4:	02054563          	bltz	a0,5de <stat+0x42>
 5b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5ba:	85ca                	mv	a1,s2
 5bc:	00000097          	auipc	ra,0x0
 5c0:	178080e7          	jalr	376(ra) # 734 <fstat>
 5c4:	892a                	mv	s2,a0
  close(fd);
 5c6:	8526                	mv	a0,s1
 5c8:	00000097          	auipc	ra,0x0
 5cc:	13c080e7          	jalr	316(ra) # 704 <close>
  return r;
}
 5d0:	854a                	mv	a0,s2
 5d2:	60e2                	ld	ra,24(sp)
 5d4:	6442                	ld	s0,16(sp)
 5d6:	64a2                	ld	s1,8(sp)
 5d8:	6902                	ld	s2,0(sp)
 5da:	6105                	addi	sp,sp,32
 5dc:	8082                	ret
    return -1;
 5de:	597d                	li	s2,-1
 5e0:	bfc5                	j	5d0 <stat+0x34>

00000000000005e2 <atoi>:

int
atoi(const char *s)
{
 5e2:	1141                	addi	sp,sp,-16
 5e4:	e422                	sd	s0,8(sp)
 5e6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5e8:	00054683          	lbu	a3,0(a0)
 5ec:	fd06879b          	addiw	a5,a3,-48
 5f0:	0ff7f793          	zext.b	a5,a5
 5f4:	4625                	li	a2,9
 5f6:	02f66863          	bltu	a2,a5,626 <atoi+0x44>
 5fa:	872a                	mv	a4,a0
  n = 0;
 5fc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5fe:	0705                	addi	a4,a4,1 # 2001 <__global_pointer$+0xa98>
 600:	0025179b          	slliw	a5,a0,0x2
 604:	9fa9                	addw	a5,a5,a0
 606:	0017979b          	slliw	a5,a5,0x1
 60a:	9fb5                	addw	a5,a5,a3
 60c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 610:	00074683          	lbu	a3,0(a4)
 614:	fd06879b          	addiw	a5,a3,-48
 618:	0ff7f793          	zext.b	a5,a5
 61c:	fef671e3          	bgeu	a2,a5,5fe <atoi+0x1c>
  return n;
}
 620:	6422                	ld	s0,8(sp)
 622:	0141                	addi	sp,sp,16
 624:	8082                	ret
  n = 0;
 626:	4501                	li	a0,0
 628:	bfe5                	j	620 <atoi+0x3e>

000000000000062a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 62a:	1141                	addi	sp,sp,-16
 62c:	e422                	sd	s0,8(sp)
 62e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 630:	02b57463          	bgeu	a0,a1,658 <memmove+0x2e>
    while(n-- > 0)
 634:	00c05f63          	blez	a2,652 <memmove+0x28>
 638:	1602                	slli	a2,a2,0x20
 63a:	9201                	srli	a2,a2,0x20
 63c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 640:	872a                	mv	a4,a0
      *dst++ = *src++;
 642:	0585                	addi	a1,a1,1
 644:	0705                	addi	a4,a4,1
 646:	fff5c683          	lbu	a3,-1(a1)
 64a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 64e:	fee79ae3          	bne	a5,a4,642 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 652:	6422                	ld	s0,8(sp)
 654:	0141                	addi	sp,sp,16
 656:	8082                	ret
    dst += n;
 658:	00c50733          	add	a4,a0,a2
    src += n;
 65c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 65e:	fec05ae3          	blez	a2,652 <memmove+0x28>
 662:	fff6079b          	addiw	a5,a2,-1
 666:	1782                	slli	a5,a5,0x20
 668:	9381                	srli	a5,a5,0x20
 66a:	fff7c793          	not	a5,a5
 66e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 670:	15fd                	addi	a1,a1,-1
 672:	177d                	addi	a4,a4,-1
 674:	0005c683          	lbu	a3,0(a1)
 678:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 67c:	fee79ae3          	bne	a5,a4,670 <memmove+0x46>
 680:	bfc9                	j	652 <memmove+0x28>

0000000000000682 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 682:	1141                	addi	sp,sp,-16
 684:	e422                	sd	s0,8(sp)
 686:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 688:	ca05                	beqz	a2,6b8 <memcmp+0x36>
 68a:	fff6069b          	addiw	a3,a2,-1
 68e:	1682                	slli	a3,a3,0x20
 690:	9281                	srli	a3,a3,0x20
 692:	0685                	addi	a3,a3,1
 694:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 696:	00054783          	lbu	a5,0(a0)
 69a:	0005c703          	lbu	a4,0(a1)
 69e:	00e79863          	bne	a5,a4,6ae <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6a2:	0505                	addi	a0,a0,1
    p2++;
 6a4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6a6:	fed518e3          	bne	a0,a3,696 <memcmp+0x14>
  }
  return 0;
 6aa:	4501                	li	a0,0
 6ac:	a019                	j	6b2 <memcmp+0x30>
      return *p1 - *p2;
 6ae:	40e7853b          	subw	a0,a5,a4
}
 6b2:	6422                	ld	s0,8(sp)
 6b4:	0141                	addi	sp,sp,16
 6b6:	8082                	ret
  return 0;
 6b8:	4501                	li	a0,0
 6ba:	bfe5                	j	6b2 <memcmp+0x30>

00000000000006bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6bc:	1141                	addi	sp,sp,-16
 6be:	e406                	sd	ra,8(sp)
 6c0:	e022                	sd	s0,0(sp)
 6c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6c4:	00000097          	auipc	ra,0x0
 6c8:	f66080e7          	jalr	-154(ra) # 62a <memmove>
}
 6cc:	60a2                	ld	ra,8(sp)
 6ce:	6402                	ld	s0,0(sp)
 6d0:	0141                	addi	sp,sp,16
 6d2:	8082                	ret

00000000000006d4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6d4:	4885                	li	a7,1
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <exit>:
.global exit
exit:
 li a7, SYS_exit
 6dc:	4889                	li	a7,2
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6e4:	488d                	li	a7,3
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6ec:	4891                	li	a7,4
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <read>:
.global read
read:
 li a7, SYS_read
 6f4:	4895                	li	a7,5
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <write>:
.global write
write:
 li a7, SYS_write
 6fc:	48c1                	li	a7,16
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <close>:
.global close
close:
 li a7, SYS_close
 704:	48d5                	li	a7,21
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <kill>:
.global kill
kill:
 li a7, SYS_kill
 70c:	4899                	li	a7,6
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <exec>:
.global exec
exec:
 li a7, SYS_exec
 714:	489d                	li	a7,7
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <open>:
.global open
open:
 li a7, SYS_open
 71c:	48bd                	li	a7,15
 ecall
 71e:	00000073          	ecall
 ret
 722:	8082                	ret

0000000000000724 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 724:	48c5                	li	a7,17
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 72c:	48c9                	li	a7,18
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 734:	48a1                	li	a7,8
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <link>:
.global link
link:
 li a7, SYS_link
 73c:	48cd                	li	a7,19
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 744:	48d1                	li	a7,20
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 74c:	48a5                	li	a7,9
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <dup>:
.global dup
dup:
 li a7, SYS_dup
 754:	48a9                	li	a7,10
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 75c:	48ad                	li	a7,11
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 764:	48b1                	li	a7,12
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 76c:	48b5                	li	a7,13
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 774:	48b9                	li	a7,14
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 77c:	1101                	addi	sp,sp,-32
 77e:	ec06                	sd	ra,24(sp)
 780:	e822                	sd	s0,16(sp)
 782:	1000                	addi	s0,sp,32
 784:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 788:	4605                	li	a2,1
 78a:	fef40593          	addi	a1,s0,-17
 78e:	00000097          	auipc	ra,0x0
 792:	f6e080e7          	jalr	-146(ra) # 6fc <write>
}
 796:	60e2                	ld	ra,24(sp)
 798:	6442                	ld	s0,16(sp)
 79a:	6105                	addi	sp,sp,32
 79c:	8082                	ret

000000000000079e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 79e:	7139                	addi	sp,sp,-64
 7a0:	fc06                	sd	ra,56(sp)
 7a2:	f822                	sd	s0,48(sp)
 7a4:	f426                	sd	s1,40(sp)
 7a6:	f04a                	sd	s2,32(sp)
 7a8:	ec4e                	sd	s3,24(sp)
 7aa:	0080                	addi	s0,sp,64
 7ac:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7ae:	c299                	beqz	a3,7b4 <printint+0x16>
 7b0:	0805c963          	bltz	a1,842 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7b4:	2581                	sext.w	a1,a1
  neg = 0;
 7b6:	4881                	li	a7,0
 7b8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7bc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7be:	2601                	sext.w	a2,a2
 7c0:	00000517          	auipc	a0,0x0
 7c4:	59850513          	addi	a0,a0,1432 # d58 <digits>
 7c8:	883a                	mv	a6,a4
 7ca:	2705                	addiw	a4,a4,1
 7cc:	02c5f7bb          	remuw	a5,a1,a2
 7d0:	1782                	slli	a5,a5,0x20
 7d2:	9381                	srli	a5,a5,0x20
 7d4:	97aa                	add	a5,a5,a0
 7d6:	0007c783          	lbu	a5,0(a5)
 7da:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7de:	0005879b          	sext.w	a5,a1
 7e2:	02c5d5bb          	divuw	a1,a1,a2
 7e6:	0685                	addi	a3,a3,1
 7e8:	fec7f0e3          	bgeu	a5,a2,7c8 <printint+0x2a>
  if(neg)
 7ec:	00088c63          	beqz	a7,804 <printint+0x66>
    buf[i++] = '-';
 7f0:	fd070793          	addi	a5,a4,-48
 7f4:	00878733          	add	a4,a5,s0
 7f8:	02d00793          	li	a5,45
 7fc:	fef70823          	sb	a5,-16(a4)
 800:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 804:	02e05863          	blez	a4,834 <printint+0x96>
 808:	fc040793          	addi	a5,s0,-64
 80c:	00e78933          	add	s2,a5,a4
 810:	fff78993          	addi	s3,a5,-1
 814:	99ba                	add	s3,s3,a4
 816:	377d                	addiw	a4,a4,-1
 818:	1702                	slli	a4,a4,0x20
 81a:	9301                	srli	a4,a4,0x20
 81c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 820:	fff94583          	lbu	a1,-1(s2)
 824:	8526                	mv	a0,s1
 826:	00000097          	auipc	ra,0x0
 82a:	f56080e7          	jalr	-170(ra) # 77c <putc>
  while(--i >= 0)
 82e:	197d                	addi	s2,s2,-1
 830:	ff3918e3          	bne	s2,s3,820 <printint+0x82>
}
 834:	70e2                	ld	ra,56(sp)
 836:	7442                	ld	s0,48(sp)
 838:	74a2                	ld	s1,40(sp)
 83a:	7902                	ld	s2,32(sp)
 83c:	69e2                	ld	s3,24(sp)
 83e:	6121                	addi	sp,sp,64
 840:	8082                	ret
    x = -xx;
 842:	40b005bb          	negw	a1,a1
    neg = 1;
 846:	4885                	li	a7,1
    x = -xx;
 848:	bf85                	j	7b8 <printint+0x1a>

000000000000084a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 84a:	7119                	addi	sp,sp,-128
 84c:	fc86                	sd	ra,120(sp)
 84e:	f8a2                	sd	s0,112(sp)
 850:	f4a6                	sd	s1,104(sp)
 852:	f0ca                	sd	s2,96(sp)
 854:	ecce                	sd	s3,88(sp)
 856:	e8d2                	sd	s4,80(sp)
 858:	e4d6                	sd	s5,72(sp)
 85a:	e0da                	sd	s6,64(sp)
 85c:	fc5e                	sd	s7,56(sp)
 85e:	f862                	sd	s8,48(sp)
 860:	f466                	sd	s9,40(sp)
 862:	f06a                	sd	s10,32(sp)
 864:	ec6e                	sd	s11,24(sp)
 866:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 868:	0005c903          	lbu	s2,0(a1)
 86c:	18090f63          	beqz	s2,a0a <vprintf+0x1c0>
 870:	8aaa                	mv	s5,a0
 872:	8b32                	mv	s6,a2
 874:	00158493          	addi	s1,a1,1
  state = 0;
 878:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 87a:	02500a13          	li	s4,37
 87e:	4c55                	li	s8,21
 880:	00000c97          	auipc	s9,0x0
 884:	480c8c93          	addi	s9,s9,1152 # d00 <malloc+0x1f2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 888:	02800d93          	li	s11,40
  putc(fd, 'x');
 88c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 88e:	00000b97          	auipc	s7,0x0
 892:	4cab8b93          	addi	s7,s7,1226 # d58 <digits>
 896:	a839                	j	8b4 <vprintf+0x6a>
        putc(fd, c);
 898:	85ca                	mv	a1,s2
 89a:	8556                	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	ee0080e7          	jalr	-288(ra) # 77c <putc>
 8a4:	a019                	j	8aa <vprintf+0x60>
    } else if(state == '%'){
 8a6:	01498d63          	beq	s3,s4,8c0 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 8aa:	0485                	addi	s1,s1,1
 8ac:	fff4c903          	lbu	s2,-1(s1)
 8b0:	14090d63          	beqz	s2,a0a <vprintf+0x1c0>
    if(state == 0){
 8b4:	fe0999e3          	bnez	s3,8a6 <vprintf+0x5c>
      if(c == '%'){
 8b8:	ff4910e3          	bne	s2,s4,898 <vprintf+0x4e>
        state = '%';
 8bc:	89d2                	mv	s3,s4
 8be:	b7f5                	j	8aa <vprintf+0x60>
      if(c == 'd'){
 8c0:	11490c63          	beq	s2,s4,9d8 <vprintf+0x18e>
 8c4:	f9d9079b          	addiw	a5,s2,-99
 8c8:	0ff7f793          	zext.b	a5,a5
 8cc:	10fc6e63          	bltu	s8,a5,9e8 <vprintf+0x19e>
 8d0:	f9d9079b          	addiw	a5,s2,-99
 8d4:	0ff7f713          	zext.b	a4,a5
 8d8:	10ec6863          	bltu	s8,a4,9e8 <vprintf+0x19e>
 8dc:	00271793          	slli	a5,a4,0x2
 8e0:	97e6                	add	a5,a5,s9
 8e2:	439c                	lw	a5,0(a5)
 8e4:	97e6                	add	a5,a5,s9
 8e6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 8e8:	008b0913          	addi	s2,s6,8
 8ec:	4685                	li	a3,1
 8ee:	4629                	li	a2,10
 8f0:	000b2583          	lw	a1,0(s6)
 8f4:	8556                	mv	a0,s5
 8f6:	00000097          	auipc	ra,0x0
 8fa:	ea8080e7          	jalr	-344(ra) # 79e <printint>
 8fe:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 900:	4981                	li	s3,0
 902:	b765                	j	8aa <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 904:	008b0913          	addi	s2,s6,8
 908:	4681                	li	a3,0
 90a:	4629                	li	a2,10
 90c:	000b2583          	lw	a1,0(s6)
 910:	8556                	mv	a0,s5
 912:	00000097          	auipc	ra,0x0
 916:	e8c080e7          	jalr	-372(ra) # 79e <printint>
 91a:	8b4a                	mv	s6,s2
      state = 0;
 91c:	4981                	li	s3,0
 91e:	b771                	j	8aa <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 920:	008b0913          	addi	s2,s6,8
 924:	4681                	li	a3,0
 926:	866a                	mv	a2,s10
 928:	000b2583          	lw	a1,0(s6)
 92c:	8556                	mv	a0,s5
 92e:	00000097          	auipc	ra,0x0
 932:	e70080e7          	jalr	-400(ra) # 79e <printint>
 936:	8b4a                	mv	s6,s2
      state = 0;
 938:	4981                	li	s3,0
 93a:	bf85                	j	8aa <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 93c:	008b0793          	addi	a5,s6,8
 940:	f8f43423          	sd	a5,-120(s0)
 944:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 948:	03000593          	li	a1,48
 94c:	8556                	mv	a0,s5
 94e:	00000097          	auipc	ra,0x0
 952:	e2e080e7          	jalr	-466(ra) # 77c <putc>
  putc(fd, 'x');
 956:	07800593          	li	a1,120
 95a:	8556                	mv	a0,s5
 95c:	00000097          	auipc	ra,0x0
 960:	e20080e7          	jalr	-480(ra) # 77c <putc>
 964:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 966:	03c9d793          	srli	a5,s3,0x3c
 96a:	97de                	add	a5,a5,s7
 96c:	0007c583          	lbu	a1,0(a5)
 970:	8556                	mv	a0,s5
 972:	00000097          	auipc	ra,0x0
 976:	e0a080e7          	jalr	-502(ra) # 77c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 97a:	0992                	slli	s3,s3,0x4
 97c:	397d                	addiw	s2,s2,-1
 97e:	fe0914e3          	bnez	s2,966 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 982:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 986:	4981                	li	s3,0
 988:	b70d                	j	8aa <vprintf+0x60>
        s = va_arg(ap, char*);
 98a:	008b0913          	addi	s2,s6,8
 98e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 992:	02098163          	beqz	s3,9b4 <vprintf+0x16a>
        while(*s != 0){
 996:	0009c583          	lbu	a1,0(s3)
 99a:	c5ad                	beqz	a1,a04 <vprintf+0x1ba>
          putc(fd, *s);
 99c:	8556                	mv	a0,s5
 99e:	00000097          	auipc	ra,0x0
 9a2:	dde080e7          	jalr	-546(ra) # 77c <putc>
          s++;
 9a6:	0985                	addi	s3,s3,1
        while(*s != 0){
 9a8:	0009c583          	lbu	a1,0(s3)
 9ac:	f9e5                	bnez	a1,99c <vprintf+0x152>
        s = va_arg(ap, char*);
 9ae:	8b4a                	mv	s6,s2
      state = 0;
 9b0:	4981                	li	s3,0
 9b2:	bde5                	j	8aa <vprintf+0x60>
          s = "(null)";
 9b4:	00000997          	auipc	s3,0x0
 9b8:	34498993          	addi	s3,s3,836 # cf8 <malloc+0x1ea>
        while(*s != 0){
 9bc:	85ee                	mv	a1,s11
 9be:	bff9                	j	99c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 9c0:	008b0913          	addi	s2,s6,8
 9c4:	000b4583          	lbu	a1,0(s6)
 9c8:	8556                	mv	a0,s5
 9ca:	00000097          	auipc	ra,0x0
 9ce:	db2080e7          	jalr	-590(ra) # 77c <putc>
 9d2:	8b4a                	mv	s6,s2
      state = 0;
 9d4:	4981                	li	s3,0
 9d6:	bdd1                	j	8aa <vprintf+0x60>
        putc(fd, c);
 9d8:	85d2                	mv	a1,s4
 9da:	8556                	mv	a0,s5
 9dc:	00000097          	auipc	ra,0x0
 9e0:	da0080e7          	jalr	-608(ra) # 77c <putc>
      state = 0;
 9e4:	4981                	li	s3,0
 9e6:	b5d1                	j	8aa <vprintf+0x60>
        putc(fd, '%');
 9e8:	85d2                	mv	a1,s4
 9ea:	8556                	mv	a0,s5
 9ec:	00000097          	auipc	ra,0x0
 9f0:	d90080e7          	jalr	-624(ra) # 77c <putc>
        putc(fd, c);
 9f4:	85ca                	mv	a1,s2
 9f6:	8556                	mv	a0,s5
 9f8:	00000097          	auipc	ra,0x0
 9fc:	d84080e7          	jalr	-636(ra) # 77c <putc>
      state = 0;
 a00:	4981                	li	s3,0
 a02:	b565                	j	8aa <vprintf+0x60>
        s = va_arg(ap, char*);
 a04:	8b4a                	mv	s6,s2
      state = 0;
 a06:	4981                	li	s3,0
 a08:	b54d                	j	8aa <vprintf+0x60>
    }
  }
}
 a0a:	70e6                	ld	ra,120(sp)
 a0c:	7446                	ld	s0,112(sp)
 a0e:	74a6                	ld	s1,104(sp)
 a10:	7906                	ld	s2,96(sp)
 a12:	69e6                	ld	s3,88(sp)
 a14:	6a46                	ld	s4,80(sp)
 a16:	6aa6                	ld	s5,72(sp)
 a18:	6b06                	ld	s6,64(sp)
 a1a:	7be2                	ld	s7,56(sp)
 a1c:	7c42                	ld	s8,48(sp)
 a1e:	7ca2                	ld	s9,40(sp)
 a20:	7d02                	ld	s10,32(sp)
 a22:	6de2                	ld	s11,24(sp)
 a24:	6109                	addi	sp,sp,128
 a26:	8082                	ret

0000000000000a28 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a28:	715d                	addi	sp,sp,-80
 a2a:	ec06                	sd	ra,24(sp)
 a2c:	e822                	sd	s0,16(sp)
 a2e:	1000                	addi	s0,sp,32
 a30:	e010                	sd	a2,0(s0)
 a32:	e414                	sd	a3,8(s0)
 a34:	e818                	sd	a4,16(s0)
 a36:	ec1c                	sd	a5,24(s0)
 a38:	03043023          	sd	a6,32(s0)
 a3c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a40:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a44:	8622                	mv	a2,s0
 a46:	00000097          	auipc	ra,0x0
 a4a:	e04080e7          	jalr	-508(ra) # 84a <vprintf>
}
 a4e:	60e2                	ld	ra,24(sp)
 a50:	6442                	ld	s0,16(sp)
 a52:	6161                	addi	sp,sp,80
 a54:	8082                	ret

0000000000000a56 <printf>:

void
printf(const char *fmt, ...)
{
 a56:	711d                	addi	sp,sp,-96
 a58:	ec06                	sd	ra,24(sp)
 a5a:	e822                	sd	s0,16(sp)
 a5c:	1000                	addi	s0,sp,32
 a5e:	e40c                	sd	a1,8(s0)
 a60:	e810                	sd	a2,16(s0)
 a62:	ec14                	sd	a3,24(s0)
 a64:	f018                	sd	a4,32(s0)
 a66:	f41c                	sd	a5,40(s0)
 a68:	03043823          	sd	a6,48(s0)
 a6c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a70:	00840613          	addi	a2,s0,8
 a74:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a78:	85aa                	mv	a1,a0
 a7a:	4505                	li	a0,1
 a7c:	00000097          	auipc	ra,0x0
 a80:	dce080e7          	jalr	-562(ra) # 84a <vprintf>
}
 a84:	60e2                	ld	ra,24(sp)
 a86:	6442                	ld	s0,16(sp)
 a88:	6125                	addi	sp,sp,96
 a8a:	8082                	ret

0000000000000a8c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a8c:	1141                	addi	sp,sp,-16
 a8e:	e422                	sd	s0,8(sp)
 a90:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a92:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a96:	00000797          	auipc	a5,0x0
 a9a:	2fa7b783          	ld	a5,762(a5) # d90 <freep>
 a9e:	a02d                	j	ac8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 aa0:	4618                	lw	a4,8(a2)
 aa2:	9f2d                	addw	a4,a4,a1
 aa4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 aa8:	6398                	ld	a4,0(a5)
 aaa:	6310                	ld	a2,0(a4)
 aac:	a83d                	j	aea <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 aae:	ff852703          	lw	a4,-8(a0)
 ab2:	9f31                	addw	a4,a4,a2
 ab4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ab6:	ff053683          	ld	a3,-16(a0)
 aba:	a091                	j	afe <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 abc:	6398                	ld	a4,0(a5)
 abe:	00e7e463          	bltu	a5,a4,ac6 <free+0x3a>
 ac2:	00e6ea63          	bltu	a3,a4,ad6 <free+0x4a>
{
 ac6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac8:	fed7fae3          	bgeu	a5,a3,abc <free+0x30>
 acc:	6398                	ld	a4,0(a5)
 ace:	00e6e463          	bltu	a3,a4,ad6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad2:	fee7eae3          	bltu	a5,a4,ac6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 ad6:	ff852583          	lw	a1,-8(a0)
 ada:	6390                	ld	a2,0(a5)
 adc:	02059813          	slli	a6,a1,0x20
 ae0:	01c85713          	srli	a4,a6,0x1c
 ae4:	9736                	add	a4,a4,a3
 ae6:	fae60de3          	beq	a2,a4,aa0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 aea:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 aee:	4790                	lw	a2,8(a5)
 af0:	02061593          	slli	a1,a2,0x20
 af4:	01c5d713          	srli	a4,a1,0x1c
 af8:	973e                	add	a4,a4,a5
 afa:	fae68ae3          	beq	a3,a4,aae <free+0x22>
    p->s.ptr = bp->s.ptr;
 afe:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b00:	00000717          	auipc	a4,0x0
 b04:	28f73823          	sd	a5,656(a4) # d90 <freep>
}
 b08:	6422                	ld	s0,8(sp)
 b0a:	0141                	addi	sp,sp,16
 b0c:	8082                	ret

0000000000000b0e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b0e:	7139                	addi	sp,sp,-64
 b10:	fc06                	sd	ra,56(sp)
 b12:	f822                	sd	s0,48(sp)
 b14:	f426                	sd	s1,40(sp)
 b16:	f04a                	sd	s2,32(sp)
 b18:	ec4e                	sd	s3,24(sp)
 b1a:	e852                	sd	s4,16(sp)
 b1c:	e456                	sd	s5,8(sp)
 b1e:	e05a                	sd	s6,0(sp)
 b20:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b22:	02051493          	slli	s1,a0,0x20
 b26:	9081                	srli	s1,s1,0x20
 b28:	04bd                	addi	s1,s1,15
 b2a:	8091                	srli	s1,s1,0x4
 b2c:	0014899b          	addiw	s3,s1,1
 b30:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b32:	00000517          	auipc	a0,0x0
 b36:	25e53503          	ld	a0,606(a0) # d90 <freep>
 b3a:	c515                	beqz	a0,b66 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b3c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b3e:	4798                	lw	a4,8(a5)
 b40:	02977f63          	bgeu	a4,s1,b7e <malloc+0x70>
 b44:	8a4e                	mv	s4,s3
 b46:	0009871b          	sext.w	a4,s3
 b4a:	6685                	lui	a3,0x1
 b4c:	00d77363          	bgeu	a4,a3,b52 <malloc+0x44>
 b50:	6a05                	lui	s4,0x1
 b52:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b56:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b5a:	00000917          	auipc	s2,0x0
 b5e:	23690913          	addi	s2,s2,566 # d90 <freep>
  if(p == (char*)-1)
 b62:	5afd                	li	s5,-1
 b64:	a895                	j	bd8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 b66:	00008797          	auipc	a5,0x8
 b6a:	33278793          	addi	a5,a5,818 # 8e98 <base>
 b6e:	00000717          	auipc	a4,0x0
 b72:	22f73123          	sd	a5,546(a4) # d90 <freep>
 b76:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b78:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b7c:	b7e1                	j	b44 <malloc+0x36>
      if(p->s.size == nunits)
 b7e:	02e48c63          	beq	s1,a4,bb6 <malloc+0xa8>
        p->s.size -= nunits;
 b82:	4137073b          	subw	a4,a4,s3
 b86:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b88:	02071693          	slli	a3,a4,0x20
 b8c:	01c6d713          	srli	a4,a3,0x1c
 b90:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b92:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b96:	00000717          	auipc	a4,0x0
 b9a:	1ea73d23          	sd	a0,506(a4) # d90 <freep>
      return (void*)(p + 1);
 b9e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ba2:	70e2                	ld	ra,56(sp)
 ba4:	7442                	ld	s0,48(sp)
 ba6:	74a2                	ld	s1,40(sp)
 ba8:	7902                	ld	s2,32(sp)
 baa:	69e2                	ld	s3,24(sp)
 bac:	6a42                	ld	s4,16(sp)
 bae:	6aa2                	ld	s5,8(sp)
 bb0:	6b02                	ld	s6,0(sp)
 bb2:	6121                	addi	sp,sp,64
 bb4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bb6:	6398                	ld	a4,0(a5)
 bb8:	e118                	sd	a4,0(a0)
 bba:	bff1                	j	b96 <malloc+0x88>
  hp->s.size = nu;
 bbc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bc0:	0541                	addi	a0,a0,16
 bc2:	00000097          	auipc	ra,0x0
 bc6:	eca080e7          	jalr	-310(ra) # a8c <free>
  return freep;
 bca:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bce:	d971                	beqz	a0,ba2 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bd2:	4798                	lw	a4,8(a5)
 bd4:	fa9775e3          	bgeu	a4,s1,b7e <malloc+0x70>
    if(p == freep)
 bd8:	00093703          	ld	a4,0(s2)
 bdc:	853e                	mv	a0,a5
 bde:	fef719e3          	bne	a4,a5,bd0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 be2:	8552                	mv	a0,s4
 be4:	00000097          	auipc	ra,0x0
 be8:	b80080e7          	jalr	-1152(ra) # 764 <sbrk>
  if(p == (char*)-1)
 bec:	fd5518e3          	bne	a0,s5,bbc <malloc+0xae>
        return 0;
 bf0:	4501                	li	a0,0
 bf2:	bf45                	j	ba2 <malloc+0x94>
