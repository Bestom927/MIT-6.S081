
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	94013103          	ld	sp,-1728(sp) # 80008940 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	541050ef          	jal	ra,80005d56 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
  struct run *r;
  int c;    // cpuid - lab8-1

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	03451793          	slli	a5,a0,0x34
    80000032:	e3c9                	bnez	a5,800000b4 <kfree+0x98>
    80000034:	84aa                	mv	s1,a0
    80000036:	0002b797          	auipc	a5,0x2b
    8000003a:	21278793          	addi	a5,a5,530 # 8002b248 <end>
    8000003e:	06f56b63          	bltu	a0,a5,800000b4 <kfree+0x98>
    80000042:	47c5                	li	a5,17
    80000044:	07ee                	slli	a5,a5,0x1b
    80000046:	06f57763          	bgeu	a0,a5,800000b4 <kfree+0x98>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	00000097          	auipc	ra,0x0
    80000052:	2c4080e7          	jalr	708(ra) # 80000312 <memset>

  r = (struct run*)pa;

  // get the current core number - lab8-1
  push_off();
    80000056:	00006097          	auipc	ra,0x6
    8000005a:	684080e7          	jalr	1668(ra) # 800066da <push_off>
  c = cpuid();
    8000005e:	00001097          	auipc	ra,0x1
    80000062:	f62080e7          	jalr	-158(ra) # 80000fc0 <cpuid>
    80000066:	8a2a                	mv	s4,a0
  pop_off();
    80000068:	00006097          	auipc	ra,0x6
    8000006c:	72e080e7          	jalr	1838(ra) # 80006796 <pop_off>
  // free the page to the current cpu's freelist - lab8-1
  acquire(&kmems[c].lock);
    80000070:	00009a97          	auipc	s5,0x9
    80000074:	fc0a8a93          	addi	s5,s5,-64 # 80009030 <kmems>
    80000078:	001a1993          	slli	s3,s4,0x1
    8000007c:	01498933          	add	s2,s3,s4
    80000080:	0912                	slli	s2,s2,0x4
    80000082:	9956                	add	s2,s2,s5
    80000084:	854a                	mv	a0,s2
    80000086:	00006097          	auipc	ra,0x6
    8000008a:	6a0080e7          	jalr	1696(ra) # 80006726 <acquire>
  r->next = kmems[c].freelist;
    8000008e:	02093783          	ld	a5,32(s2)
    80000092:	e09c                	sd	a5,0(s1)
  kmems[c].freelist = r;
    80000094:	02993023          	sd	s1,32(s2)
  release(&kmems[c].lock);
    80000098:	854a                	mv	a0,s2
    8000009a:	00006097          	auipc	ra,0x6
    8000009e:	75c080e7          	jalr	1884(ra) # 800067f6 <release>
}
    800000a2:	70e2                	ld	ra,56(sp)
    800000a4:	7442                	ld	s0,48(sp)
    800000a6:	74a2                	ld	s1,40(sp)
    800000a8:	7902                	ld	s2,32(sp)
    800000aa:	69e2                	ld	s3,24(sp)
    800000ac:	6a42                	ld	s4,16(sp)
    800000ae:	6aa2                	ld	s5,8(sp)
    800000b0:	6121                	addi	sp,sp,64
    800000b2:	8082                	ret
    panic("kfree");
    800000b4:	00008517          	auipc	a0,0x8
    800000b8:	f5c50513          	addi	a0,a0,-164 # 80008010 <etext+0x10>
    800000bc:	00006097          	auipc	ra,0x6
    800000c0:	148080e7          	jalr	328(ra) # 80006204 <panic>

00000000800000c4 <freerange>:
{
    800000c4:	7179                	addi	sp,sp,-48
    800000c6:	f406                	sd	ra,40(sp)
    800000c8:	f022                	sd	s0,32(sp)
    800000ca:	ec26                	sd	s1,24(sp)
    800000cc:	e84a                	sd	s2,16(sp)
    800000ce:	e44e                	sd	s3,8(sp)
    800000d0:	e052                	sd	s4,0(sp)
    800000d2:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000d4:	6785                	lui	a5,0x1
    800000d6:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000da:	00e504b3          	add	s1,a0,a4
    800000de:	777d                	lui	a4,0xfffff
    800000e0:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000e2:	94be                	add	s1,s1,a5
    800000e4:	0095ee63          	bltu	a1,s1,80000100 <freerange+0x3c>
    800000e8:	892e                	mv	s2,a1
    kfree(p);
    800000ea:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ec:	6985                	lui	s3,0x1
    kfree(p);
    800000ee:	01448533          	add	a0,s1,s4
    800000f2:	00000097          	auipc	ra,0x0
    800000f6:	f2a080e7          	jalr	-214(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000fa:	94ce                	add	s1,s1,s3
    800000fc:	fe9979e3          	bgeu	s2,s1,800000ee <freerange+0x2a>
}
    80000100:	70a2                	ld	ra,40(sp)
    80000102:	7402                	ld	s0,32(sp)
    80000104:	64e2                	ld	s1,24(sp)
    80000106:	6942                	ld	s2,16(sp)
    80000108:	69a2                	ld	s3,8(sp)
    8000010a:	6a02                	ld	s4,0(sp)
    8000010c:	6145                	addi	sp,sp,48
    8000010e:	8082                	ret

0000000080000110 <kinit>:
{
    80000110:	7179                	addi	sp,sp,-48
    80000112:	f406                	sd	ra,40(sp)
    80000114:	f022                	sd	s0,32(sp)
    80000116:	ec26                	sd	s1,24(sp)
    80000118:	e84a                	sd	s2,16(sp)
    8000011a:	e44e                	sd	s3,8(sp)
    8000011c:	e052                	sd	s4,0(sp)
    8000011e:	1800                	addi	s0,sp,48
  for (i = 0; i < NCPU; ++i) {
    80000120:	00009917          	auipc	s2,0x9
    80000124:	f1090913          	addi	s2,s2,-240 # 80009030 <kmems>
    80000128:	4481                	li	s1,0
    snprintf(kmems[i].lockname, 8, "kmem_%d", i);    // the name of the lock
    8000012a:	00008a17          	auipc	s4,0x8
    8000012e:	eeea0a13          	addi	s4,s4,-274 # 80008018 <etext+0x18>
    80000132:	02890993          	addi	s3,s2,40
    80000136:	86a6                	mv	a3,s1
    80000138:	8652                	mv	a2,s4
    8000013a:	45a1                	li	a1,8
    8000013c:	854e                	mv	a0,s3
    8000013e:	00006097          	auipc	ra,0x6
    80000142:	a32080e7          	jalr	-1486(ra) # 80005b70 <snprintf>
    initlock(&kmems[i].lock, kmems[i].lockname);
    80000146:	85ce                	mv	a1,s3
    80000148:	854a                	mv	a0,s2
    8000014a:	00006097          	auipc	ra,0x6
    8000014e:	758080e7          	jalr	1880(ra) # 800068a2 <initlock>
  for (i = 0; i < NCPU; ++i) {
    80000152:	2485                	addiw	s1,s1,1
    80000154:	03090913          	addi	s2,s2,48
    80000158:	47a1                	li	a5,8
    8000015a:	fcf49ce3          	bne	s1,a5,80000132 <kinit+0x22>
  freerange(end, (void*)PHYSTOP);
    8000015e:	45c5                	li	a1,17
    80000160:	05ee                	slli	a1,a1,0x1b
    80000162:	0002b517          	auipc	a0,0x2b
    80000166:	0e650513          	addi	a0,a0,230 # 8002b248 <end>
    8000016a:	00000097          	auipc	ra,0x0
    8000016e:	f5a080e7          	jalr	-166(ra) # 800000c4 <freerange>
}
    80000172:	70a2                	ld	ra,40(sp)
    80000174:	7402                	ld	s0,32(sp)
    80000176:	64e2                	ld	s1,24(sp)
    80000178:	6942                	ld	s2,16(sp)
    8000017a:	69a2                	ld	s3,8(sp)
    8000017c:	6a02                	ld	s4,0(sp)
    8000017e:	6145                	addi	sp,sp,48
    80000180:	8082                	ret

0000000080000182 <steal>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
// steal half page from other cpu's freelist - lab8-1
struct run *steal(int cpu_id) {
    80000182:	715d                	addi	sp,sp,-80
    80000184:	e486                	sd	ra,72(sp)
    80000186:	e0a2                	sd	s0,64(sp)
    80000188:	fc26                	sd	s1,56(sp)
    8000018a:	f84a                	sd	s2,48(sp)
    8000018c:	f44e                	sd	s3,40(sp)
    8000018e:	f052                	sd	s4,32(sp)
    80000190:	ec56                	sd	s5,24(sp)
    80000192:	e85a                	sd	s6,16(sp)
    80000194:	e45e                	sd	s7,8(sp)
    80000196:	0880                	addi	s0,sp,80
    80000198:	892a                	mv	s2,a0
    int i;
    int c = cpu_id;
    struct run *fast, *slow, *head;
    // 若传递的cpuid和实际运行的cpuid出现不一致,则引发panic
    // 加入该判断以检查在kalloc()调用steal时CPU不会被切换
    if(cpu_id != cpuid()) {
    8000019a:	00001097          	auipc	ra,0x1
    8000019e:	e26080e7          	jalr	-474(ra) # 80000fc0 <cpuid>
    800001a2:	01251a63          	bne	a0,s2,800001b6 <steal+0x34>
    800001a6:	499d                	li	s3,7
      panic("steal");
    }    
    // 遍历其他NCPU-1个CPU的空闲物理页链表 
    for (i = 1; i < NCPU; ++i) {
        if (++c == NCPU) {
    800001a8:	4b21                	li	s6,8
            c = 0;
    800001aa:	4b81                	li	s7,0
        }
        acquire(&kmems[c].lock);
    800001ac:	00009a97          	auipc	s5,0x9
    800001b0:	e84a8a93          	addi	s5,s5,-380 # 80009030 <kmems>
    800001b4:	a83d                	j	800001f2 <steal+0x70>
      panic("steal");
    800001b6:	00008517          	auipc	a0,0x8
    800001ba:	e6a50513          	addi	a0,a0,-406 # 80008020 <etext+0x20>
    800001be:	00006097          	auipc	ra,0x6
    800001c2:	046080e7          	jalr	70(ra) # 80006204 <panic>
        acquire(&kmems[c].lock);
    800001c6:	00191493          	slli	s1,s2,0x1
    800001ca:	94ca                	add	s1,s1,s2
    800001cc:	0492                	slli	s1,s1,0x4
    800001ce:	94d6                	add	s1,s1,s5
    800001d0:	8526                	mv	a0,s1
    800001d2:	00006097          	auipc	ra,0x6
    800001d6:	554080e7          	jalr	1364(ra) # 80006726 <acquire>
        // 若链表不为空
        if (kmems[c].freelist) {
    800001da:	0204ba03          	ld	s4,32(s1)
    800001de:	000a1f63          	bnez	s4,800001fc <steal+0x7a>
            // 前半部分的链表结尾清空,由于该部分链表与其他链表不再关联,因此无需加锁
            slow->next = 0;
            // 返回前半部分的链表头
            return head;
        }
        release(&kmems[c].lock);
    800001e2:	8526                	mv	a0,s1
    800001e4:	00006097          	auipc	ra,0x6
    800001e8:	612080e7          	jalr	1554(ra) # 800067f6 <release>
    for (i = 1; i < NCPU; ++i) {
    800001ec:	39fd                	addiw	s3,s3,-1 # fff <_entry-0x7ffff001>
    800001ee:	04098463          	beqz	s3,80000236 <steal+0xb4>
        if (++c == NCPU) {
    800001f2:	2905                	addiw	s2,s2,1
    800001f4:	fd6919e3          	bne	s2,s6,800001c6 <steal+0x44>
            c = 0;
    800001f8:	895e                	mv	s2,s7
    800001fa:	b7f1                	j	800001c6 <steal+0x44>
            fast = slow->next;
    800001fc:	000a3783          	ld	a5,0(s4)
        if (kmems[c].freelist) {
    80000200:	89d2                	mv	s3,s4
            while (fast) {
    80000202:	c799                	beqz	a5,80000210 <steal+0x8e>
                fast = fast->next;
    80000204:	639c                	ld	a5,0(a5)
                if (fast) {
    80000206:	dff5                	beqz	a5,80000202 <steal+0x80>
                    slow = slow->next;
    80000208:	0009b983          	ld	s3,0(s3)
                    fast = fast->next;
    8000020c:	639c                	ld	a5,0(a5)
    8000020e:	bfd5                	j	80000202 <steal+0x80>
            kmems[c].freelist = slow->next;
    80000210:	0009b683          	ld	a3,0(s3)
    80000214:	00191793          	slli	a5,s2,0x1
    80000218:	97ca                	add	a5,a5,s2
    8000021a:	0792                	slli	a5,a5,0x4
    8000021c:	00009717          	auipc	a4,0x9
    80000220:	e1470713          	addi	a4,a4,-492 # 80009030 <kmems>
    80000224:	97ba                	add	a5,a5,a4
    80000226:	f394                	sd	a3,32(a5)
            release(&kmems[c].lock);
    80000228:	8526                	mv	a0,s1
    8000022a:	00006097          	auipc	ra,0x6
    8000022e:	5cc080e7          	jalr	1484(ra) # 800067f6 <release>
            slow->next = 0;
    80000232:	0009b023          	sd	zero,0(s3)
    }
    // 若其他CPU物理页均为空则返回空指针
    return 0;
}
    80000236:	8552                	mv	a0,s4
    80000238:	60a6                	ld	ra,72(sp)
    8000023a:	6406                	ld	s0,64(sp)
    8000023c:	74e2                	ld	s1,56(sp)
    8000023e:	7942                	ld	s2,48(sp)
    80000240:	79a2                	ld	s3,40(sp)
    80000242:	7a02                	ld	s4,32(sp)
    80000244:	6ae2                	ld	s5,24(sp)
    80000246:	6b42                	ld	s6,16(sp)
    80000248:	6ba2                	ld	s7,8(sp)
    8000024a:	6161                	addi	sp,sp,80
    8000024c:	8082                	ret

000000008000024e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000024e:	7179                	addi	sp,sp,-48
    80000250:	f406                	sd	ra,40(sp)
    80000252:	f022                	sd	s0,32(sp)
    80000254:	ec26                	sd	s1,24(sp)
    80000256:	e84a                	sd	s2,16(sp)
    80000258:	e44e                	sd	s3,8(sp)
    8000025a:	1800                	addi	s0,sp,48
  struct run *r;
  // lab8-1
  int c;
  push_off();
    8000025c:	00006097          	auipc	ra,0x6
    80000260:	47e080e7          	jalr	1150(ra) # 800066da <push_off>
  c = cpuid();
    80000264:	00001097          	auipc	ra,0x1
    80000268:	d5c080e7          	jalr	-676(ra) # 80000fc0 <cpuid>
    8000026c:	84aa                	mv	s1,a0
  pop_off();
    8000026e:	00006097          	auipc	ra,0x6
    80000272:	528080e7          	jalr	1320(ra) # 80006796 <pop_off>
  // get the page from the current cpu's freelist
  acquire(&kmems[c].lock);
    80000276:	00149793          	slli	a5,s1,0x1
    8000027a:	97a6                	add	a5,a5,s1
    8000027c:	0792                	slli	a5,a5,0x4
    8000027e:	00009517          	auipc	a0,0x9
    80000282:	db250513          	addi	a0,a0,-590 # 80009030 <kmems>
    80000286:	00f50933          	add	s2,a0,a5
    8000028a:	854a                	mv	a0,s2
    8000028c:	00006097          	auipc	ra,0x6
    80000290:	49a080e7          	jalr	1178(ra) # 80006726 <acquire>
  r = kmems[c].freelist;
    80000294:	02093983          	ld	s3,32(s2)
  if(r)
    80000298:	02098a63          	beqz	s3,800002cc <kalloc+0x7e>
    kmems[c].freelist = r->next;
    8000029c:	0009b683          	ld	a3,0(s3)
    800002a0:	02d93023          	sd	a3,32(s2)
  release(&kmems[c].lock);
    800002a4:	854a                	mv	a0,s2
    800002a6:	00006097          	auipc	ra,0x6
    800002aa:	550080e7          	jalr	1360(ra) # 800067f6 <release>
    kmems[c].freelist = r->next;
    release(&kmems[c].lock);
  }

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800002ae:	6605                	lui	a2,0x1
    800002b0:	4595                	li	a1,5
    800002b2:	854e                	mv	a0,s3
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	05e080e7          	jalr	94(ra) # 80000312 <memset>
  return (void*)r;
}
    800002bc:	854e                	mv	a0,s3
    800002be:	70a2                	ld	ra,40(sp)
    800002c0:	7402                	ld	s0,32(sp)
    800002c2:	64e2                	ld	s1,24(sp)
    800002c4:	6942                	ld	s2,16(sp)
    800002c6:	69a2                	ld	s3,8(sp)
    800002c8:	6145                	addi	sp,sp,48
    800002ca:	8082                	ret
  release(&kmems[c].lock);
    800002cc:	854a                	mv	a0,s2
    800002ce:	00006097          	auipc	ra,0x6
    800002d2:	528080e7          	jalr	1320(ra) # 800067f6 <release>
  if(!r && (r = steal(c))) {
    800002d6:	8526                	mv	a0,s1
    800002d8:	00000097          	auipc	ra,0x0
    800002dc:	eaa080e7          	jalr	-342(ra) # 80000182 <steal>
    800002e0:	89aa                	mv	s3,a0
    800002e2:	dd69                	beqz	a0,800002bc <kalloc+0x6e>
    acquire(&kmems[c].lock);
    800002e4:	854a                	mv	a0,s2
    800002e6:	00006097          	auipc	ra,0x6
    800002ea:	440080e7          	jalr	1088(ra) # 80006726 <acquire>
    kmems[c].freelist = r->next;
    800002ee:	0009b683          	ld	a3,0(s3)
    800002f2:	00149793          	slli	a5,s1,0x1
    800002f6:	97a6                	add	a5,a5,s1
    800002f8:	0792                	slli	a5,a5,0x4
    800002fa:	00009717          	auipc	a4,0x9
    800002fe:	d3670713          	addi	a4,a4,-714 # 80009030 <kmems>
    80000302:	97ba                	add	a5,a5,a4
    80000304:	f394                	sd	a3,32(a5)
    release(&kmems[c].lock);
    80000306:	854a                	mv	a0,s2
    80000308:	00006097          	auipc	ra,0x6
    8000030c:	4ee080e7          	jalr	1262(ra) # 800067f6 <release>
    80000310:	bf79                	j	800002ae <kalloc+0x60>

0000000080000312 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000312:	1141                	addi	sp,sp,-16
    80000314:	e422                	sd	s0,8(sp)
    80000316:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000318:	ca19                	beqz	a2,8000032e <memset+0x1c>
    8000031a:	87aa                	mv	a5,a0
    8000031c:	1602                	slli	a2,a2,0x20
    8000031e:	9201                	srli	a2,a2,0x20
    80000320:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000324:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000328:	0785                	addi	a5,a5,1
    8000032a:	fee79de3          	bne	a5,a4,80000324 <memset+0x12>
  }
  return dst;
}
    8000032e:	6422                	ld	s0,8(sp)
    80000330:	0141                	addi	sp,sp,16
    80000332:	8082                	ret

0000000080000334 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000334:	1141                	addi	sp,sp,-16
    80000336:	e422                	sd	s0,8(sp)
    80000338:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000033a:	ca05                	beqz	a2,8000036a <memcmp+0x36>
    8000033c:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000340:	1682                	slli	a3,a3,0x20
    80000342:	9281                	srli	a3,a3,0x20
    80000344:	0685                	addi	a3,a3,1
    80000346:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000348:	00054783          	lbu	a5,0(a0)
    8000034c:	0005c703          	lbu	a4,0(a1)
    80000350:	00e79863          	bne	a5,a4,80000360 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000354:	0505                	addi	a0,a0,1
    80000356:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000358:	fed518e3          	bne	a0,a3,80000348 <memcmp+0x14>
  }

  return 0;
    8000035c:	4501                	li	a0,0
    8000035e:	a019                	j	80000364 <memcmp+0x30>
      return *s1 - *s2;
    80000360:	40e7853b          	subw	a0,a5,a4
}
    80000364:	6422                	ld	s0,8(sp)
    80000366:	0141                	addi	sp,sp,16
    80000368:	8082                	ret
  return 0;
    8000036a:	4501                	li	a0,0
    8000036c:	bfe5                	j	80000364 <memcmp+0x30>

000000008000036e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000036e:	1141                	addi	sp,sp,-16
    80000370:	e422                	sd	s0,8(sp)
    80000372:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000374:	c205                	beqz	a2,80000394 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000376:	02a5e263          	bltu	a1,a0,8000039a <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000037a:	1602                	slli	a2,a2,0x20
    8000037c:	9201                	srli	a2,a2,0x20
    8000037e:	00c587b3          	add	a5,a1,a2
{
    80000382:	872a                	mv	a4,a0
      *d++ = *s++;
    80000384:	0585                	addi	a1,a1,1
    80000386:	0705                	addi	a4,a4,1
    80000388:	fff5c683          	lbu	a3,-1(a1)
    8000038c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000390:	fef59ae3          	bne	a1,a5,80000384 <memmove+0x16>

  return dst;
}
    80000394:	6422                	ld	s0,8(sp)
    80000396:	0141                	addi	sp,sp,16
    80000398:	8082                	ret
  if(s < d && s + n > d){
    8000039a:	02061693          	slli	a3,a2,0x20
    8000039e:	9281                	srli	a3,a3,0x20
    800003a0:	00d58733          	add	a4,a1,a3
    800003a4:	fce57be3          	bgeu	a0,a4,8000037a <memmove+0xc>
    d += n;
    800003a8:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800003aa:	fff6079b          	addiw	a5,a2,-1
    800003ae:	1782                	slli	a5,a5,0x20
    800003b0:	9381                	srli	a5,a5,0x20
    800003b2:	fff7c793          	not	a5,a5
    800003b6:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800003b8:	177d                	addi	a4,a4,-1
    800003ba:	16fd                	addi	a3,a3,-1
    800003bc:	00074603          	lbu	a2,0(a4)
    800003c0:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800003c4:	fee79ae3          	bne	a5,a4,800003b8 <memmove+0x4a>
    800003c8:	b7f1                	j	80000394 <memmove+0x26>

00000000800003ca <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800003ca:	1141                	addi	sp,sp,-16
    800003cc:	e406                	sd	ra,8(sp)
    800003ce:	e022                	sd	s0,0(sp)
    800003d0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800003d2:	00000097          	auipc	ra,0x0
    800003d6:	f9c080e7          	jalr	-100(ra) # 8000036e <memmove>
}
    800003da:	60a2                	ld	ra,8(sp)
    800003dc:	6402                	ld	s0,0(sp)
    800003de:	0141                	addi	sp,sp,16
    800003e0:	8082                	ret

00000000800003e2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800003e2:	1141                	addi	sp,sp,-16
    800003e4:	e422                	sd	s0,8(sp)
    800003e6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800003e8:	ce11                	beqz	a2,80000404 <strncmp+0x22>
    800003ea:	00054783          	lbu	a5,0(a0)
    800003ee:	cf89                	beqz	a5,80000408 <strncmp+0x26>
    800003f0:	0005c703          	lbu	a4,0(a1)
    800003f4:	00f71a63          	bne	a4,a5,80000408 <strncmp+0x26>
    n--, p++, q++;
    800003f8:	367d                	addiw	a2,a2,-1
    800003fa:	0505                	addi	a0,a0,1
    800003fc:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800003fe:	f675                	bnez	a2,800003ea <strncmp+0x8>
  if(n == 0)
    return 0;
    80000400:	4501                	li	a0,0
    80000402:	a809                	j	80000414 <strncmp+0x32>
    80000404:	4501                	li	a0,0
    80000406:	a039                	j	80000414 <strncmp+0x32>
  if(n == 0)
    80000408:	ca09                	beqz	a2,8000041a <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000040a:	00054503          	lbu	a0,0(a0)
    8000040e:	0005c783          	lbu	a5,0(a1)
    80000412:	9d1d                	subw	a0,a0,a5
}
    80000414:	6422                	ld	s0,8(sp)
    80000416:	0141                	addi	sp,sp,16
    80000418:	8082                	ret
    return 0;
    8000041a:	4501                	li	a0,0
    8000041c:	bfe5                	j	80000414 <strncmp+0x32>

000000008000041e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000041e:	1141                	addi	sp,sp,-16
    80000420:	e422                	sd	s0,8(sp)
    80000422:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000424:	872a                	mv	a4,a0
    80000426:	8832                	mv	a6,a2
    80000428:	367d                	addiw	a2,a2,-1
    8000042a:	01005963          	blez	a6,8000043c <strncpy+0x1e>
    8000042e:	0705                	addi	a4,a4,1
    80000430:	0005c783          	lbu	a5,0(a1)
    80000434:	fef70fa3          	sb	a5,-1(a4)
    80000438:	0585                	addi	a1,a1,1
    8000043a:	f7f5                	bnez	a5,80000426 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000043c:	86ba                	mv	a3,a4
    8000043e:	00c05c63          	blez	a2,80000456 <strncpy+0x38>
    *s++ = 0;
    80000442:	0685                	addi	a3,a3,1
    80000444:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000448:	40d707bb          	subw	a5,a4,a3
    8000044c:	37fd                	addiw	a5,a5,-1
    8000044e:	010787bb          	addw	a5,a5,a6
    80000452:	fef048e3          	bgtz	a5,80000442 <strncpy+0x24>
  return os;
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	addi	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000045c:	1141                	addi	sp,sp,-16
    8000045e:	e422                	sd	s0,8(sp)
    80000460:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000462:	02c05363          	blez	a2,80000488 <safestrcpy+0x2c>
    80000466:	fff6069b          	addiw	a3,a2,-1
    8000046a:	1682                	slli	a3,a3,0x20
    8000046c:	9281                	srli	a3,a3,0x20
    8000046e:	96ae                	add	a3,a3,a1
    80000470:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000472:	00d58963          	beq	a1,a3,80000484 <safestrcpy+0x28>
    80000476:	0585                	addi	a1,a1,1
    80000478:	0785                	addi	a5,a5,1
    8000047a:	fff5c703          	lbu	a4,-1(a1)
    8000047e:	fee78fa3          	sb	a4,-1(a5)
    80000482:	fb65                	bnez	a4,80000472 <safestrcpy+0x16>
    ;
  *s = 0;
    80000484:	00078023          	sb	zero,0(a5)
  return os;
}
    80000488:	6422                	ld	s0,8(sp)
    8000048a:	0141                	addi	sp,sp,16
    8000048c:	8082                	ret

000000008000048e <strlen>:

int
strlen(const char *s)
{
    8000048e:	1141                	addi	sp,sp,-16
    80000490:	e422                	sd	s0,8(sp)
    80000492:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000494:	00054783          	lbu	a5,0(a0)
    80000498:	cf91                	beqz	a5,800004b4 <strlen+0x26>
    8000049a:	0505                	addi	a0,a0,1
    8000049c:	87aa                	mv	a5,a0
    8000049e:	4685                	li	a3,1
    800004a0:	9e89                	subw	a3,a3,a0
    800004a2:	00f6853b          	addw	a0,a3,a5
    800004a6:	0785                	addi	a5,a5,1
    800004a8:	fff7c703          	lbu	a4,-1(a5)
    800004ac:	fb7d                	bnez	a4,800004a2 <strlen+0x14>
    ;
  return n;
}
    800004ae:	6422                	ld	s0,8(sp)
    800004b0:	0141                	addi	sp,sp,16
    800004b2:	8082                	ret
  for(n = 0; s[n]; n++)
    800004b4:	4501                	li	a0,0
    800004b6:	bfe5                	j	800004ae <strlen+0x20>

00000000800004b8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800004b8:	1101                	addi	sp,sp,-32
    800004ba:	ec06                	sd	ra,24(sp)
    800004bc:	e822                	sd	s0,16(sp)
    800004be:	e426                	sd	s1,8(sp)
    800004c0:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800004c2:	00001097          	auipc	ra,0x1
    800004c6:	afe080e7          	jalr	-1282(ra) # 80000fc0 <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    800004ca:	00009497          	auipc	s1,0x9
    800004ce:	b3648493          	addi	s1,s1,-1226 # 80009000 <started>
  if(cpuid() == 0){
    800004d2:	c531                	beqz	a0,8000051e <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    800004d4:	8526                	mv	a0,s1
    800004d6:	00006097          	auipc	ra,0x6
    800004da:	462080e7          	jalr	1122(ra) # 80006938 <lockfree_read4>
    800004de:	d97d                	beqz	a0,800004d4 <main+0x1c>
      ;
    __sync_synchronize();
    800004e0:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800004e4:	00001097          	auipc	ra,0x1
    800004e8:	adc080e7          	jalr	-1316(ra) # 80000fc0 <cpuid>
    800004ec:	85aa                	mv	a1,a0
    800004ee:	00008517          	auipc	a0,0x8
    800004f2:	b5250513          	addi	a0,a0,-1198 # 80008040 <etext+0x40>
    800004f6:	00006097          	auipc	ra,0x6
    800004fa:	d58080e7          	jalr	-680(ra) # 8000624e <printf>
    kvminithart();    // turn on paging
    800004fe:	00000097          	auipc	ra,0x0
    80000502:	0e0080e7          	jalr	224(ra) # 800005de <kvminithart>
    trapinithart();   // install kernel trap vector
    80000506:	00001097          	auipc	ra,0x1
    8000050a:	73c080e7          	jalr	1852(ra) # 80001c42 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000050e:	00005097          	auipc	ra,0x5
    80000512:	ef2080e7          	jalr	-270(ra) # 80005400 <plicinithart>
  }

  scheduler();        
    80000516:	00001097          	auipc	ra,0x1
    8000051a:	fe8080e7          	jalr	-24(ra) # 800014fe <scheduler>
    consoleinit();
    8000051e:	00006097          	auipc	ra,0x6
    80000522:	bf6080e7          	jalr	-1034(ra) # 80006114 <consoleinit>
    statsinit();
    80000526:	00005097          	auipc	ra,0x5
    8000052a:	56c080e7          	jalr	1388(ra) # 80005a92 <statsinit>
    printfinit();
    8000052e:	00006097          	auipc	ra,0x6
    80000532:	f00080e7          	jalr	-256(ra) # 8000642e <printfinit>
    printf("\n");
    80000536:	00008517          	auipc	a0,0x8
    8000053a:	35a50513          	addi	a0,a0,858 # 80008890 <digits+0x88>
    8000053e:	00006097          	auipc	ra,0x6
    80000542:	d10080e7          	jalr	-752(ra) # 8000624e <printf>
    printf("xv6 kernel is booting\n");
    80000546:	00008517          	auipc	a0,0x8
    8000054a:	ae250513          	addi	a0,a0,-1310 # 80008028 <etext+0x28>
    8000054e:	00006097          	auipc	ra,0x6
    80000552:	d00080e7          	jalr	-768(ra) # 8000624e <printf>
    printf("\n");
    80000556:	00008517          	auipc	a0,0x8
    8000055a:	33a50513          	addi	a0,a0,826 # 80008890 <digits+0x88>
    8000055e:	00006097          	auipc	ra,0x6
    80000562:	cf0080e7          	jalr	-784(ra) # 8000624e <printf>
    kinit();         // physical page allocator
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	baa080e7          	jalr	-1110(ra) # 80000110 <kinit>
    kvminit();       // create kernel page table
    8000056e:	00000097          	auipc	ra,0x0
    80000572:	322080e7          	jalr	802(ra) # 80000890 <kvminit>
    kvminithart();   // turn on paging
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	068080e7          	jalr	104(ra) # 800005de <kvminithart>
    procinit();      // process table
    8000057e:	00001097          	auipc	ra,0x1
    80000582:	992080e7          	jalr	-1646(ra) # 80000f10 <procinit>
    trapinit();      // trap vectors
    80000586:	00001097          	auipc	ra,0x1
    8000058a:	694080e7          	jalr	1684(ra) # 80001c1a <trapinit>
    trapinithart();  // install kernel trap vector
    8000058e:	00001097          	auipc	ra,0x1
    80000592:	6b4080e7          	jalr	1716(ra) # 80001c42 <trapinithart>
    plicinit();      // set up interrupt controller
    80000596:	00005097          	auipc	ra,0x5
    8000059a:	e54080e7          	jalr	-428(ra) # 800053ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000059e:	00005097          	auipc	ra,0x5
    800005a2:	e62080e7          	jalr	-414(ra) # 80005400 <plicinithart>
    binit();         // buffer cache
    800005a6:	00002097          	auipc	ra,0x2
    800005aa:	dde080e7          	jalr	-546(ra) # 80002384 <binit>
    iinit();         // inode table
    800005ae:	00002097          	auipc	ra,0x2
    800005b2:	6ae080e7          	jalr	1710(ra) # 80002c5c <iinit>
    fileinit();      // file table
    800005b6:	00003097          	auipc	ra,0x3
    800005ba:	660080e7          	jalr	1632(ra) # 80003c16 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800005be:	00005097          	auipc	ra,0x5
    800005c2:	f62080e7          	jalr	-158(ra) # 80005520 <virtio_disk_init>
    userinit();      // first user process
    800005c6:	00001097          	auipc	ra,0x1
    800005ca:	cfe080e7          	jalr	-770(ra) # 800012c4 <userinit>
    __sync_synchronize();
    800005ce:	0ff0000f          	fence
    started = 1;
    800005d2:	4785                	li	a5,1
    800005d4:	00009717          	auipc	a4,0x9
    800005d8:	a2f72623          	sw	a5,-1492(a4) # 80009000 <started>
    800005dc:	bf2d                	j	80000516 <main+0x5e>

00000000800005de <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800005de:	1141                	addi	sp,sp,-16
    800005e0:	e422                	sd	s0,8(sp)
    800005e2:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800005e4:	00009797          	auipc	a5,0x9
    800005e8:	a247b783          	ld	a5,-1500(a5) # 80009008 <kernel_pagetable>
    800005ec:	83b1                	srli	a5,a5,0xc
    800005ee:	577d                	li	a4,-1
    800005f0:	177e                	slli	a4,a4,0x3f
    800005f2:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    800005f4:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800005f8:	12000073          	sfence.vma
  sfence_vma();
}
    800005fc:	6422                	ld	s0,8(sp)
    800005fe:	0141                	addi	sp,sp,16
    80000600:	8082                	ret

0000000080000602 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000602:	7139                	addi	sp,sp,-64
    80000604:	fc06                	sd	ra,56(sp)
    80000606:	f822                	sd	s0,48(sp)
    80000608:	f426                	sd	s1,40(sp)
    8000060a:	f04a                	sd	s2,32(sp)
    8000060c:	ec4e                	sd	s3,24(sp)
    8000060e:	e852                	sd	s4,16(sp)
    80000610:	e456                	sd	s5,8(sp)
    80000612:	e05a                	sd	s6,0(sp)
    80000614:	0080                	addi	s0,sp,64
    80000616:	84aa                	mv	s1,a0
    80000618:	89ae                	mv	s3,a1
    8000061a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000061c:	57fd                	li	a5,-1
    8000061e:	83e9                	srli	a5,a5,0x1a
    80000620:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000622:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000624:	04b7f263          	bgeu	a5,a1,80000668 <walk+0x66>
    panic("walk");
    80000628:	00008517          	auipc	a0,0x8
    8000062c:	a3050513          	addi	a0,a0,-1488 # 80008058 <etext+0x58>
    80000630:	00006097          	auipc	ra,0x6
    80000634:	bd4080e7          	jalr	-1068(ra) # 80006204 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000638:	060a8663          	beqz	s5,800006a4 <walk+0xa2>
    8000063c:	00000097          	auipc	ra,0x0
    80000640:	c12080e7          	jalr	-1006(ra) # 8000024e <kalloc>
    80000644:	84aa                	mv	s1,a0
    80000646:	c529                	beqz	a0,80000690 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000648:	6605                	lui	a2,0x1
    8000064a:	4581                	li	a1,0
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	cc6080e7          	jalr	-826(ra) # 80000312 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000654:	00c4d793          	srli	a5,s1,0xc
    80000658:	07aa                	slli	a5,a5,0xa
    8000065a:	0017e793          	ori	a5,a5,1
    8000065e:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000662:	3a5d                	addiw	s4,s4,-9
    80000664:	036a0063          	beq	s4,s6,80000684 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000668:	0149d933          	srl	s2,s3,s4
    8000066c:	1ff97913          	andi	s2,s2,511
    80000670:	090e                	slli	s2,s2,0x3
    80000672:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000674:	00093483          	ld	s1,0(s2)
    80000678:	0014f793          	andi	a5,s1,1
    8000067c:	dfd5                	beqz	a5,80000638 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000067e:	80a9                	srli	s1,s1,0xa
    80000680:	04b2                	slli	s1,s1,0xc
    80000682:	b7c5                	j	80000662 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000684:	00c9d513          	srli	a0,s3,0xc
    80000688:	1ff57513          	andi	a0,a0,511
    8000068c:	050e                	slli	a0,a0,0x3
    8000068e:	9526                	add	a0,a0,s1
}
    80000690:	70e2                	ld	ra,56(sp)
    80000692:	7442                	ld	s0,48(sp)
    80000694:	74a2                	ld	s1,40(sp)
    80000696:	7902                	ld	s2,32(sp)
    80000698:	69e2                	ld	s3,24(sp)
    8000069a:	6a42                	ld	s4,16(sp)
    8000069c:	6aa2                	ld	s5,8(sp)
    8000069e:	6b02                	ld	s6,0(sp)
    800006a0:	6121                	addi	sp,sp,64
    800006a2:	8082                	ret
        return 0;
    800006a4:	4501                	li	a0,0
    800006a6:	b7ed                	j	80000690 <walk+0x8e>

00000000800006a8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800006a8:	57fd                	li	a5,-1
    800006aa:	83e9                	srli	a5,a5,0x1a
    800006ac:	00b7f463          	bgeu	a5,a1,800006b4 <walkaddr+0xc>
    return 0;
    800006b0:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800006b2:	8082                	ret
{
    800006b4:	1141                	addi	sp,sp,-16
    800006b6:	e406                	sd	ra,8(sp)
    800006b8:	e022                	sd	s0,0(sp)
    800006ba:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800006bc:	4601                	li	a2,0
    800006be:	00000097          	auipc	ra,0x0
    800006c2:	f44080e7          	jalr	-188(ra) # 80000602 <walk>
  if(pte == 0)
    800006c6:	c105                	beqz	a0,800006e6 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800006c8:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800006ca:	0117f693          	andi	a3,a5,17
    800006ce:	4745                	li	a4,17
    return 0;
    800006d0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800006d2:	00e68663          	beq	a3,a4,800006de <walkaddr+0x36>
}
    800006d6:	60a2                	ld	ra,8(sp)
    800006d8:	6402                	ld	s0,0(sp)
    800006da:	0141                	addi	sp,sp,16
    800006dc:	8082                	ret
  pa = PTE2PA(*pte);
    800006de:	83a9                	srli	a5,a5,0xa
    800006e0:	00c79513          	slli	a0,a5,0xc
  return pa;
    800006e4:	bfcd                	j	800006d6 <walkaddr+0x2e>
    return 0;
    800006e6:	4501                	li	a0,0
    800006e8:	b7fd                	j	800006d6 <walkaddr+0x2e>

00000000800006ea <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800006ea:	715d                	addi	sp,sp,-80
    800006ec:	e486                	sd	ra,72(sp)
    800006ee:	e0a2                	sd	s0,64(sp)
    800006f0:	fc26                	sd	s1,56(sp)
    800006f2:	f84a                	sd	s2,48(sp)
    800006f4:	f44e                	sd	s3,40(sp)
    800006f6:	f052                	sd	s4,32(sp)
    800006f8:	ec56                	sd	s5,24(sp)
    800006fa:	e85a                	sd	s6,16(sp)
    800006fc:	e45e                	sd	s7,8(sp)
    800006fe:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000700:	c639                	beqz	a2,8000074e <mappages+0x64>
    80000702:	8aaa                	mv	s5,a0
    80000704:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000706:	777d                	lui	a4,0xfffff
    80000708:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000070c:	fff58993          	addi	s3,a1,-1
    80000710:	99b2                	add	s3,s3,a2
    80000712:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000716:	893e                	mv	s2,a5
    80000718:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000071c:	6b85                	lui	s7,0x1
    8000071e:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000722:	4605                	li	a2,1
    80000724:	85ca                	mv	a1,s2
    80000726:	8556                	mv	a0,s5
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	eda080e7          	jalr	-294(ra) # 80000602 <walk>
    80000730:	cd1d                	beqz	a0,8000076e <mappages+0x84>
    if(*pte & PTE_V)
    80000732:	611c                	ld	a5,0(a0)
    80000734:	8b85                	andi	a5,a5,1
    80000736:	e785                	bnez	a5,8000075e <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000738:	80b1                	srli	s1,s1,0xc
    8000073a:	04aa                	slli	s1,s1,0xa
    8000073c:	0164e4b3          	or	s1,s1,s6
    80000740:	0014e493          	ori	s1,s1,1
    80000744:	e104                	sd	s1,0(a0)
    if(a == last)
    80000746:	05390063          	beq	s2,s3,80000786 <mappages+0x9c>
    a += PGSIZE;
    8000074a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000074c:	bfc9                	j	8000071e <mappages+0x34>
    panic("mappages: size");
    8000074e:	00008517          	auipc	a0,0x8
    80000752:	91250513          	addi	a0,a0,-1774 # 80008060 <etext+0x60>
    80000756:	00006097          	auipc	ra,0x6
    8000075a:	aae080e7          	jalr	-1362(ra) # 80006204 <panic>
      panic("mappages: remap");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	91250513          	addi	a0,a0,-1774 # 80008070 <etext+0x70>
    80000766:	00006097          	auipc	ra,0x6
    8000076a:	a9e080e7          	jalr	-1378(ra) # 80006204 <panic>
      return -1;
    8000076e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000770:	60a6                	ld	ra,72(sp)
    80000772:	6406                	ld	s0,64(sp)
    80000774:	74e2                	ld	s1,56(sp)
    80000776:	7942                	ld	s2,48(sp)
    80000778:	79a2                	ld	s3,40(sp)
    8000077a:	7a02                	ld	s4,32(sp)
    8000077c:	6ae2                	ld	s5,24(sp)
    8000077e:	6b42                	ld	s6,16(sp)
    80000780:	6ba2                	ld	s7,8(sp)
    80000782:	6161                	addi	sp,sp,80
    80000784:	8082                	ret
  return 0;
    80000786:	4501                	li	a0,0
    80000788:	b7e5                	j	80000770 <mappages+0x86>

000000008000078a <kvmmap>:
{
    8000078a:	1141                	addi	sp,sp,-16
    8000078c:	e406                	sd	ra,8(sp)
    8000078e:	e022                	sd	s0,0(sp)
    80000790:	0800                	addi	s0,sp,16
    80000792:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000794:	86b2                	mv	a3,a2
    80000796:	863e                	mv	a2,a5
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	f52080e7          	jalr	-174(ra) # 800006ea <mappages>
    800007a0:	e509                	bnez	a0,800007aa <kvmmap+0x20>
}
    800007a2:	60a2                	ld	ra,8(sp)
    800007a4:	6402                	ld	s0,0(sp)
    800007a6:	0141                	addi	sp,sp,16
    800007a8:	8082                	ret
    panic("kvmmap");
    800007aa:	00008517          	auipc	a0,0x8
    800007ae:	8d650513          	addi	a0,a0,-1834 # 80008080 <etext+0x80>
    800007b2:	00006097          	auipc	ra,0x6
    800007b6:	a52080e7          	jalr	-1454(ra) # 80006204 <panic>

00000000800007ba <kvmmake>:
{
    800007ba:	1101                	addi	sp,sp,-32
    800007bc:	ec06                	sd	ra,24(sp)
    800007be:	e822                	sd	s0,16(sp)
    800007c0:	e426                	sd	s1,8(sp)
    800007c2:	e04a                	sd	s2,0(sp)
    800007c4:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	a88080e7          	jalr	-1400(ra) # 8000024e <kalloc>
    800007ce:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800007d0:	6605                	lui	a2,0x1
    800007d2:	4581                	li	a1,0
    800007d4:	00000097          	auipc	ra,0x0
    800007d8:	b3e080e7          	jalr	-1218(ra) # 80000312 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800007dc:	4719                	li	a4,6
    800007de:	6685                	lui	a3,0x1
    800007e0:	10000637          	lui	a2,0x10000
    800007e4:	100005b7          	lui	a1,0x10000
    800007e8:	8526                	mv	a0,s1
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	fa0080e7          	jalr	-96(ra) # 8000078a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800007f2:	4719                	li	a4,6
    800007f4:	6685                	lui	a3,0x1
    800007f6:	10001637          	lui	a2,0x10001
    800007fa:	100015b7          	lui	a1,0x10001
    800007fe:	8526                	mv	a0,s1
    80000800:	00000097          	auipc	ra,0x0
    80000804:	f8a080e7          	jalr	-118(ra) # 8000078a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000808:	4719                	li	a4,6
    8000080a:	004006b7          	lui	a3,0x400
    8000080e:	0c000637          	lui	a2,0xc000
    80000812:	0c0005b7          	lui	a1,0xc000
    80000816:	8526                	mv	a0,s1
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	f72080e7          	jalr	-142(ra) # 8000078a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000820:	00007917          	auipc	s2,0x7
    80000824:	7e090913          	addi	s2,s2,2016 # 80008000 <etext>
    80000828:	4729                	li	a4,10
    8000082a:	80007697          	auipc	a3,0x80007
    8000082e:	7d668693          	addi	a3,a3,2006 # 8000 <_entry-0x7fff8000>
    80000832:	4605                	li	a2,1
    80000834:	067e                	slli	a2,a2,0x1f
    80000836:	85b2                	mv	a1,a2
    80000838:	8526                	mv	a0,s1
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	f50080e7          	jalr	-176(ra) # 8000078a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000842:	4719                	li	a4,6
    80000844:	46c5                	li	a3,17
    80000846:	06ee                	slli	a3,a3,0x1b
    80000848:	412686b3          	sub	a3,a3,s2
    8000084c:	864a                	mv	a2,s2
    8000084e:	85ca                	mv	a1,s2
    80000850:	8526                	mv	a0,s1
    80000852:	00000097          	auipc	ra,0x0
    80000856:	f38080e7          	jalr	-200(ra) # 8000078a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000085a:	4729                	li	a4,10
    8000085c:	6685                	lui	a3,0x1
    8000085e:	00006617          	auipc	a2,0x6
    80000862:	7a260613          	addi	a2,a2,1954 # 80007000 <_trampoline>
    80000866:	040005b7          	lui	a1,0x4000
    8000086a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000086c:	05b2                	slli	a1,a1,0xc
    8000086e:	8526                	mv	a0,s1
    80000870:	00000097          	auipc	ra,0x0
    80000874:	f1a080e7          	jalr	-230(ra) # 8000078a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000878:	8526                	mv	a0,s1
    8000087a:	00000097          	auipc	ra,0x0
    8000087e:	600080e7          	jalr	1536(ra) # 80000e7a <proc_mapstacks>
}
    80000882:	8526                	mv	a0,s1
    80000884:	60e2                	ld	ra,24(sp)
    80000886:	6442                	ld	s0,16(sp)
    80000888:	64a2                	ld	s1,8(sp)
    8000088a:	6902                	ld	s2,0(sp)
    8000088c:	6105                	addi	sp,sp,32
    8000088e:	8082                	ret

0000000080000890 <kvminit>:
{
    80000890:	1141                	addi	sp,sp,-16
    80000892:	e406                	sd	ra,8(sp)
    80000894:	e022                	sd	s0,0(sp)
    80000896:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000898:	00000097          	auipc	ra,0x0
    8000089c:	f22080e7          	jalr	-222(ra) # 800007ba <kvmmake>
    800008a0:	00008797          	auipc	a5,0x8
    800008a4:	76a7b423          	sd	a0,1896(a5) # 80009008 <kernel_pagetable>
}
    800008a8:	60a2                	ld	ra,8(sp)
    800008aa:	6402                	ld	s0,0(sp)
    800008ac:	0141                	addi	sp,sp,16
    800008ae:	8082                	ret

00000000800008b0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800008b0:	715d                	addi	sp,sp,-80
    800008b2:	e486                	sd	ra,72(sp)
    800008b4:	e0a2                	sd	s0,64(sp)
    800008b6:	fc26                	sd	s1,56(sp)
    800008b8:	f84a                	sd	s2,48(sp)
    800008ba:	f44e                	sd	s3,40(sp)
    800008bc:	f052                	sd	s4,32(sp)
    800008be:	ec56                	sd	s5,24(sp)
    800008c0:	e85a                	sd	s6,16(sp)
    800008c2:	e45e                	sd	s7,8(sp)
    800008c4:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800008c6:	03459793          	slli	a5,a1,0x34
    800008ca:	e795                	bnez	a5,800008f6 <uvmunmap+0x46>
    800008cc:	8a2a                	mv	s4,a0
    800008ce:	892e                	mv	s2,a1
    800008d0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008d2:	0632                	slli	a2,a2,0xc
    800008d4:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800008d8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008da:	6b05                	lui	s6,0x1
    800008dc:	0735e263          	bltu	a1,s3,80000940 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800008e0:	60a6                	ld	ra,72(sp)
    800008e2:	6406                	ld	s0,64(sp)
    800008e4:	74e2                	ld	s1,56(sp)
    800008e6:	7942                	ld	s2,48(sp)
    800008e8:	79a2                	ld	s3,40(sp)
    800008ea:	7a02                	ld	s4,32(sp)
    800008ec:	6ae2                	ld	s5,24(sp)
    800008ee:	6b42                	ld	s6,16(sp)
    800008f0:	6ba2                	ld	s7,8(sp)
    800008f2:	6161                	addi	sp,sp,80
    800008f4:	8082                	ret
    panic("uvmunmap: not aligned");
    800008f6:	00007517          	auipc	a0,0x7
    800008fa:	79250513          	addi	a0,a0,1938 # 80008088 <etext+0x88>
    800008fe:	00006097          	auipc	ra,0x6
    80000902:	906080e7          	jalr	-1786(ra) # 80006204 <panic>
      panic("uvmunmap: walk");
    80000906:	00007517          	auipc	a0,0x7
    8000090a:	79a50513          	addi	a0,a0,1946 # 800080a0 <etext+0xa0>
    8000090e:	00006097          	auipc	ra,0x6
    80000912:	8f6080e7          	jalr	-1802(ra) # 80006204 <panic>
      panic("uvmunmap: not mapped");
    80000916:	00007517          	auipc	a0,0x7
    8000091a:	79a50513          	addi	a0,a0,1946 # 800080b0 <etext+0xb0>
    8000091e:	00006097          	auipc	ra,0x6
    80000922:	8e6080e7          	jalr	-1818(ra) # 80006204 <panic>
      panic("uvmunmap: not a leaf");
    80000926:	00007517          	auipc	a0,0x7
    8000092a:	7a250513          	addi	a0,a0,1954 # 800080c8 <etext+0xc8>
    8000092e:	00006097          	auipc	ra,0x6
    80000932:	8d6080e7          	jalr	-1834(ra) # 80006204 <panic>
    *pte = 0;
    80000936:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000093a:	995a                	add	s2,s2,s6
    8000093c:	fb3972e3          	bgeu	s2,s3,800008e0 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000940:	4601                	li	a2,0
    80000942:	85ca                	mv	a1,s2
    80000944:	8552                	mv	a0,s4
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	cbc080e7          	jalr	-836(ra) # 80000602 <walk>
    8000094e:	84aa                	mv	s1,a0
    80000950:	d95d                	beqz	a0,80000906 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80000952:	6108                	ld	a0,0(a0)
    80000954:	00157793          	andi	a5,a0,1
    80000958:	dfdd                	beqz	a5,80000916 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000095a:	3ff57793          	andi	a5,a0,1023
    8000095e:	fd7784e3          	beq	a5,s7,80000926 <uvmunmap+0x76>
    if(do_free){
    80000962:	fc0a8ae3          	beqz	s5,80000936 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80000966:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000968:	0532                	slli	a0,a0,0xc
    8000096a:	fffff097          	auipc	ra,0xfffff
    8000096e:	6b2080e7          	jalr	1714(ra) # 8000001c <kfree>
    80000972:	b7d1                	j	80000936 <uvmunmap+0x86>

0000000080000974 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000974:	1101                	addi	sp,sp,-32
    80000976:	ec06                	sd	ra,24(sp)
    80000978:	e822                	sd	s0,16(sp)
    8000097a:	e426                	sd	s1,8(sp)
    8000097c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000097e:	00000097          	auipc	ra,0x0
    80000982:	8d0080e7          	jalr	-1840(ra) # 8000024e <kalloc>
    80000986:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000988:	c519                	beqz	a0,80000996 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000098a:	6605                	lui	a2,0x1
    8000098c:	4581                	li	a1,0
    8000098e:	00000097          	auipc	ra,0x0
    80000992:	984080e7          	jalr	-1660(ra) # 80000312 <memset>
  return pagetable;
}
    80000996:	8526                	mv	a0,s1
    80000998:	60e2                	ld	ra,24(sp)
    8000099a:	6442                	ld	s0,16(sp)
    8000099c:	64a2                	ld	s1,8(sp)
    8000099e:	6105                	addi	sp,sp,32
    800009a0:	8082                	ret

00000000800009a2 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800009a2:	7179                	addi	sp,sp,-48
    800009a4:	f406                	sd	ra,40(sp)
    800009a6:	f022                	sd	s0,32(sp)
    800009a8:	ec26                	sd	s1,24(sp)
    800009aa:	e84a                	sd	s2,16(sp)
    800009ac:	e44e                	sd	s3,8(sp)
    800009ae:	e052                	sd	s4,0(sp)
    800009b0:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800009b2:	6785                	lui	a5,0x1
    800009b4:	04f67863          	bgeu	a2,a5,80000a04 <uvminit+0x62>
    800009b8:	8a2a                	mv	s4,a0
    800009ba:	89ae                	mv	s3,a1
    800009bc:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	890080e7          	jalr	-1904(ra) # 8000024e <kalloc>
    800009c6:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800009c8:	6605                	lui	a2,0x1
    800009ca:	4581                	li	a1,0
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	946080e7          	jalr	-1722(ra) # 80000312 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800009d4:	4779                	li	a4,30
    800009d6:	86ca                	mv	a3,s2
    800009d8:	6605                	lui	a2,0x1
    800009da:	4581                	li	a1,0
    800009dc:	8552                	mv	a0,s4
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	d0c080e7          	jalr	-756(ra) # 800006ea <mappages>
  memmove(mem, src, sz);
    800009e6:	8626                	mv	a2,s1
    800009e8:	85ce                	mv	a1,s3
    800009ea:	854a                	mv	a0,s2
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	982080e7          	jalr	-1662(ra) # 8000036e <memmove>
}
    800009f4:	70a2                	ld	ra,40(sp)
    800009f6:	7402                	ld	s0,32(sp)
    800009f8:	64e2                	ld	s1,24(sp)
    800009fa:	6942                	ld	s2,16(sp)
    800009fc:	69a2                	ld	s3,8(sp)
    800009fe:	6a02                	ld	s4,0(sp)
    80000a00:	6145                	addi	sp,sp,48
    80000a02:	8082                	ret
    panic("inituvm: more than a page");
    80000a04:	00007517          	auipc	a0,0x7
    80000a08:	6dc50513          	addi	a0,a0,1756 # 800080e0 <etext+0xe0>
    80000a0c:	00005097          	auipc	ra,0x5
    80000a10:	7f8080e7          	jalr	2040(ra) # 80006204 <panic>

0000000080000a14 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000a14:	1101                	addi	sp,sp,-32
    80000a16:	ec06                	sd	ra,24(sp)
    80000a18:	e822                	sd	s0,16(sp)
    80000a1a:	e426                	sd	s1,8(sp)
    80000a1c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000a1e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000a20:	00b67d63          	bgeu	a2,a1,80000a3a <uvmdealloc+0x26>
    80000a24:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000a26:	6785                	lui	a5,0x1
    80000a28:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a2a:	00f60733          	add	a4,a2,a5
    80000a2e:	76fd                	lui	a3,0xfffff
    80000a30:	8f75                	and	a4,a4,a3
    80000a32:	97ae                	add	a5,a5,a1
    80000a34:	8ff5                	and	a5,a5,a3
    80000a36:	00f76863          	bltu	a4,a5,80000a46 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000a3a:	8526                	mv	a0,s1
    80000a3c:	60e2                	ld	ra,24(sp)
    80000a3e:	6442                	ld	s0,16(sp)
    80000a40:	64a2                	ld	s1,8(sp)
    80000a42:	6105                	addi	sp,sp,32
    80000a44:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000a46:	8f99                	sub	a5,a5,a4
    80000a48:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a4a:	4685                	li	a3,1
    80000a4c:	0007861b          	sext.w	a2,a5
    80000a50:	85ba                	mv	a1,a4
    80000a52:	00000097          	auipc	ra,0x0
    80000a56:	e5e080e7          	jalr	-418(ra) # 800008b0 <uvmunmap>
    80000a5a:	b7c5                	j	80000a3a <uvmdealloc+0x26>

0000000080000a5c <uvmalloc>:
  if(newsz < oldsz)
    80000a5c:	0ab66163          	bltu	a2,a1,80000afe <uvmalloc+0xa2>
{
    80000a60:	7139                	addi	sp,sp,-64
    80000a62:	fc06                	sd	ra,56(sp)
    80000a64:	f822                	sd	s0,48(sp)
    80000a66:	f426                	sd	s1,40(sp)
    80000a68:	f04a                	sd	s2,32(sp)
    80000a6a:	ec4e                	sd	s3,24(sp)
    80000a6c:	e852                	sd	s4,16(sp)
    80000a6e:	e456                	sd	s5,8(sp)
    80000a70:	0080                	addi	s0,sp,64
    80000a72:	8aaa                	mv	s5,a0
    80000a74:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000a76:	6785                	lui	a5,0x1
    80000a78:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a7a:	95be                	add	a1,a1,a5
    80000a7c:	77fd                	lui	a5,0xfffff
    80000a7e:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a82:	08c9f063          	bgeu	s3,a2,80000b02 <uvmalloc+0xa6>
    80000a86:	894e                	mv	s2,s3
    mem = kalloc();
    80000a88:	fffff097          	auipc	ra,0xfffff
    80000a8c:	7c6080e7          	jalr	1990(ra) # 8000024e <kalloc>
    80000a90:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a92:	c51d                	beqz	a0,80000ac0 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000a94:	6605                	lui	a2,0x1
    80000a96:	4581                	li	a1,0
    80000a98:	00000097          	auipc	ra,0x0
    80000a9c:	87a080e7          	jalr	-1926(ra) # 80000312 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000aa0:	4779                	li	a4,30
    80000aa2:	86a6                	mv	a3,s1
    80000aa4:	6605                	lui	a2,0x1
    80000aa6:	85ca                	mv	a1,s2
    80000aa8:	8556                	mv	a0,s5
    80000aaa:	00000097          	auipc	ra,0x0
    80000aae:	c40080e7          	jalr	-960(ra) # 800006ea <mappages>
    80000ab2:	e905                	bnez	a0,80000ae2 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000ab4:	6785                	lui	a5,0x1
    80000ab6:	993e                	add	s2,s2,a5
    80000ab8:	fd4968e3          	bltu	s2,s4,80000a88 <uvmalloc+0x2c>
  return newsz;
    80000abc:	8552                	mv	a0,s4
    80000abe:	a809                	j	80000ad0 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000ac0:	864e                	mv	a2,s3
    80000ac2:	85ca                	mv	a1,s2
    80000ac4:	8556                	mv	a0,s5
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	f4e080e7          	jalr	-178(ra) # 80000a14 <uvmdealloc>
      return 0;
    80000ace:	4501                	li	a0,0
}
    80000ad0:	70e2                	ld	ra,56(sp)
    80000ad2:	7442                	ld	s0,48(sp)
    80000ad4:	74a2                	ld	s1,40(sp)
    80000ad6:	7902                	ld	s2,32(sp)
    80000ad8:	69e2                	ld	s3,24(sp)
    80000ada:	6a42                	ld	s4,16(sp)
    80000adc:	6aa2                	ld	s5,8(sp)
    80000ade:	6121                	addi	sp,sp,64
    80000ae0:	8082                	ret
      kfree(mem);
    80000ae2:	8526                	mv	a0,s1
    80000ae4:	fffff097          	auipc	ra,0xfffff
    80000ae8:	538080e7          	jalr	1336(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000aec:	864e                	mv	a2,s3
    80000aee:	85ca                	mv	a1,s2
    80000af0:	8556                	mv	a0,s5
    80000af2:	00000097          	auipc	ra,0x0
    80000af6:	f22080e7          	jalr	-222(ra) # 80000a14 <uvmdealloc>
      return 0;
    80000afa:	4501                	li	a0,0
    80000afc:	bfd1                	j	80000ad0 <uvmalloc+0x74>
    return oldsz;
    80000afe:	852e                	mv	a0,a1
}
    80000b00:	8082                	ret
  return newsz;
    80000b02:	8532                	mv	a0,a2
    80000b04:	b7f1                	j	80000ad0 <uvmalloc+0x74>

0000000080000b06 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000b06:	7179                	addi	sp,sp,-48
    80000b08:	f406                	sd	ra,40(sp)
    80000b0a:	f022                	sd	s0,32(sp)
    80000b0c:	ec26                	sd	s1,24(sp)
    80000b0e:	e84a                	sd	s2,16(sp)
    80000b10:	e44e                	sd	s3,8(sp)
    80000b12:	e052                	sd	s4,0(sp)
    80000b14:	1800                	addi	s0,sp,48
    80000b16:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000b18:	84aa                	mv	s1,a0
    80000b1a:	6905                	lui	s2,0x1
    80000b1c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b1e:	4985                	li	s3,1
    80000b20:	a829                	j	80000b3a <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000b22:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000b24:	00c79513          	slli	a0,a5,0xc
    80000b28:	00000097          	auipc	ra,0x0
    80000b2c:	fde080e7          	jalr	-34(ra) # 80000b06 <freewalk>
      pagetable[i] = 0;
    80000b30:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000b34:	04a1                	addi	s1,s1,8
    80000b36:	03248163          	beq	s1,s2,80000b58 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000b3a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b3c:	00f7f713          	andi	a4,a5,15
    80000b40:	ff3701e3          	beq	a4,s3,80000b22 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000b44:	8b85                	andi	a5,a5,1
    80000b46:	d7fd                	beqz	a5,80000b34 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000b48:	00007517          	auipc	a0,0x7
    80000b4c:	5b850513          	addi	a0,a0,1464 # 80008100 <etext+0x100>
    80000b50:	00005097          	auipc	ra,0x5
    80000b54:	6b4080e7          	jalr	1716(ra) # 80006204 <panic>
    }
  }
  kfree((void*)pagetable);
    80000b58:	8552                	mv	a0,s4
    80000b5a:	fffff097          	auipc	ra,0xfffff
    80000b5e:	4c2080e7          	jalr	1218(ra) # 8000001c <kfree>
}
    80000b62:	70a2                	ld	ra,40(sp)
    80000b64:	7402                	ld	s0,32(sp)
    80000b66:	64e2                	ld	s1,24(sp)
    80000b68:	6942                	ld	s2,16(sp)
    80000b6a:	69a2                	ld	s3,8(sp)
    80000b6c:	6a02                	ld	s4,0(sp)
    80000b6e:	6145                	addi	sp,sp,48
    80000b70:	8082                	ret

0000000080000b72 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b72:	1101                	addi	sp,sp,-32
    80000b74:	ec06                	sd	ra,24(sp)
    80000b76:	e822                	sd	s0,16(sp)
    80000b78:	e426                	sd	s1,8(sp)
    80000b7a:	1000                	addi	s0,sp,32
    80000b7c:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b7e:	e999                	bnez	a1,80000b94 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b80:	8526                	mv	a0,s1
    80000b82:	00000097          	auipc	ra,0x0
    80000b86:	f84080e7          	jalr	-124(ra) # 80000b06 <freewalk>
}
    80000b8a:	60e2                	ld	ra,24(sp)
    80000b8c:	6442                	ld	s0,16(sp)
    80000b8e:	64a2                	ld	s1,8(sp)
    80000b90:	6105                	addi	sp,sp,32
    80000b92:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b94:	6785                	lui	a5,0x1
    80000b96:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b98:	95be                	add	a1,a1,a5
    80000b9a:	4685                	li	a3,1
    80000b9c:	00c5d613          	srli	a2,a1,0xc
    80000ba0:	4581                	li	a1,0
    80000ba2:	00000097          	auipc	ra,0x0
    80000ba6:	d0e080e7          	jalr	-754(ra) # 800008b0 <uvmunmap>
    80000baa:	bfd9                	j	80000b80 <uvmfree+0xe>

0000000080000bac <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000bac:	c679                	beqz	a2,80000c7a <uvmcopy+0xce>
{
    80000bae:	715d                	addi	sp,sp,-80
    80000bb0:	e486                	sd	ra,72(sp)
    80000bb2:	e0a2                	sd	s0,64(sp)
    80000bb4:	fc26                	sd	s1,56(sp)
    80000bb6:	f84a                	sd	s2,48(sp)
    80000bb8:	f44e                	sd	s3,40(sp)
    80000bba:	f052                	sd	s4,32(sp)
    80000bbc:	ec56                	sd	s5,24(sp)
    80000bbe:	e85a                	sd	s6,16(sp)
    80000bc0:	e45e                	sd	s7,8(sp)
    80000bc2:	0880                	addi	s0,sp,80
    80000bc4:	8b2a                	mv	s6,a0
    80000bc6:	8aae                	mv	s5,a1
    80000bc8:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000bca:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000bcc:	4601                	li	a2,0
    80000bce:	85ce                	mv	a1,s3
    80000bd0:	855a                	mv	a0,s6
    80000bd2:	00000097          	auipc	ra,0x0
    80000bd6:	a30080e7          	jalr	-1488(ra) # 80000602 <walk>
    80000bda:	c531                	beqz	a0,80000c26 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000bdc:	6118                	ld	a4,0(a0)
    80000bde:	00177793          	andi	a5,a4,1
    80000be2:	cbb1                	beqz	a5,80000c36 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000be4:	00a75593          	srli	a1,a4,0xa
    80000be8:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000bec:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000bf0:	fffff097          	auipc	ra,0xfffff
    80000bf4:	65e080e7          	jalr	1630(ra) # 8000024e <kalloc>
    80000bf8:	892a                	mv	s2,a0
    80000bfa:	c939                	beqz	a0,80000c50 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000bfc:	6605                	lui	a2,0x1
    80000bfe:	85de                	mv	a1,s7
    80000c00:	fffff097          	auipc	ra,0xfffff
    80000c04:	76e080e7          	jalr	1902(ra) # 8000036e <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000c08:	8726                	mv	a4,s1
    80000c0a:	86ca                	mv	a3,s2
    80000c0c:	6605                	lui	a2,0x1
    80000c0e:	85ce                	mv	a1,s3
    80000c10:	8556                	mv	a0,s5
    80000c12:	00000097          	auipc	ra,0x0
    80000c16:	ad8080e7          	jalr	-1320(ra) # 800006ea <mappages>
    80000c1a:	e515                	bnez	a0,80000c46 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000c1c:	6785                	lui	a5,0x1
    80000c1e:	99be                	add	s3,s3,a5
    80000c20:	fb49e6e3          	bltu	s3,s4,80000bcc <uvmcopy+0x20>
    80000c24:	a081                	j	80000c64 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000c26:	00007517          	auipc	a0,0x7
    80000c2a:	4ea50513          	addi	a0,a0,1258 # 80008110 <etext+0x110>
    80000c2e:	00005097          	auipc	ra,0x5
    80000c32:	5d6080e7          	jalr	1494(ra) # 80006204 <panic>
      panic("uvmcopy: page not present");
    80000c36:	00007517          	auipc	a0,0x7
    80000c3a:	4fa50513          	addi	a0,a0,1274 # 80008130 <etext+0x130>
    80000c3e:	00005097          	auipc	ra,0x5
    80000c42:	5c6080e7          	jalr	1478(ra) # 80006204 <panic>
      kfree(mem);
    80000c46:	854a                	mv	a0,s2
    80000c48:	fffff097          	auipc	ra,0xfffff
    80000c4c:	3d4080e7          	jalr	980(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c50:	4685                	li	a3,1
    80000c52:	00c9d613          	srli	a2,s3,0xc
    80000c56:	4581                	li	a1,0
    80000c58:	8556                	mv	a0,s5
    80000c5a:	00000097          	auipc	ra,0x0
    80000c5e:	c56080e7          	jalr	-938(ra) # 800008b0 <uvmunmap>
  return -1;
    80000c62:	557d                	li	a0,-1
}
    80000c64:	60a6                	ld	ra,72(sp)
    80000c66:	6406                	ld	s0,64(sp)
    80000c68:	74e2                	ld	s1,56(sp)
    80000c6a:	7942                	ld	s2,48(sp)
    80000c6c:	79a2                	ld	s3,40(sp)
    80000c6e:	7a02                	ld	s4,32(sp)
    80000c70:	6ae2                	ld	s5,24(sp)
    80000c72:	6b42                	ld	s6,16(sp)
    80000c74:	6ba2                	ld	s7,8(sp)
    80000c76:	6161                	addi	sp,sp,80
    80000c78:	8082                	ret
  return 0;
    80000c7a:	4501                	li	a0,0
}
    80000c7c:	8082                	ret

0000000080000c7e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c7e:	1141                	addi	sp,sp,-16
    80000c80:	e406                	sd	ra,8(sp)
    80000c82:	e022                	sd	s0,0(sp)
    80000c84:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c86:	4601                	li	a2,0
    80000c88:	00000097          	auipc	ra,0x0
    80000c8c:	97a080e7          	jalr	-1670(ra) # 80000602 <walk>
  if(pte == 0)
    80000c90:	c901                	beqz	a0,80000ca0 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c92:	611c                	ld	a5,0(a0)
    80000c94:	9bbd                	andi	a5,a5,-17
    80000c96:	e11c                	sd	a5,0(a0)
}
    80000c98:	60a2                	ld	ra,8(sp)
    80000c9a:	6402                	ld	s0,0(sp)
    80000c9c:	0141                	addi	sp,sp,16
    80000c9e:	8082                	ret
    panic("uvmclear");
    80000ca0:	00007517          	auipc	a0,0x7
    80000ca4:	4b050513          	addi	a0,a0,1200 # 80008150 <etext+0x150>
    80000ca8:	00005097          	auipc	ra,0x5
    80000cac:	55c080e7          	jalr	1372(ra) # 80006204 <panic>

0000000080000cb0 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000cb0:	c6bd                	beqz	a3,80000d1e <copyout+0x6e>
{
    80000cb2:	715d                	addi	sp,sp,-80
    80000cb4:	e486                	sd	ra,72(sp)
    80000cb6:	e0a2                	sd	s0,64(sp)
    80000cb8:	fc26                	sd	s1,56(sp)
    80000cba:	f84a                	sd	s2,48(sp)
    80000cbc:	f44e                	sd	s3,40(sp)
    80000cbe:	f052                	sd	s4,32(sp)
    80000cc0:	ec56                	sd	s5,24(sp)
    80000cc2:	e85a                	sd	s6,16(sp)
    80000cc4:	e45e                	sd	s7,8(sp)
    80000cc6:	e062                	sd	s8,0(sp)
    80000cc8:	0880                	addi	s0,sp,80
    80000cca:	8b2a                	mv	s6,a0
    80000ccc:	8c2e                	mv	s8,a1
    80000cce:	8a32                	mv	s4,a2
    80000cd0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000cd2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000cd4:	6a85                	lui	s5,0x1
    80000cd6:	a015                	j	80000cfa <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000cd8:	9562                	add	a0,a0,s8
    80000cda:	0004861b          	sext.w	a2,s1
    80000cde:	85d2                	mv	a1,s4
    80000ce0:	41250533          	sub	a0,a0,s2
    80000ce4:	fffff097          	auipc	ra,0xfffff
    80000ce8:	68a080e7          	jalr	1674(ra) # 8000036e <memmove>

    len -= n;
    80000cec:	409989b3          	sub	s3,s3,s1
    src += n;
    80000cf0:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000cf2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cf6:	02098263          	beqz	s3,80000d1a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000cfa:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cfe:	85ca                	mv	a1,s2
    80000d00:	855a                	mv	a0,s6
    80000d02:	00000097          	auipc	ra,0x0
    80000d06:	9a6080e7          	jalr	-1626(ra) # 800006a8 <walkaddr>
    if(pa0 == 0)
    80000d0a:	cd01                	beqz	a0,80000d22 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000d0c:	418904b3          	sub	s1,s2,s8
    80000d10:	94d6                	add	s1,s1,s5
    80000d12:	fc99f3e3          	bgeu	s3,s1,80000cd8 <copyout+0x28>
    80000d16:	84ce                	mv	s1,s3
    80000d18:	b7c1                	j	80000cd8 <copyout+0x28>
  }
  return 0;
    80000d1a:	4501                	li	a0,0
    80000d1c:	a021                	j	80000d24 <copyout+0x74>
    80000d1e:	4501                	li	a0,0
}
    80000d20:	8082                	ret
      return -1;
    80000d22:	557d                	li	a0,-1
}
    80000d24:	60a6                	ld	ra,72(sp)
    80000d26:	6406                	ld	s0,64(sp)
    80000d28:	74e2                	ld	s1,56(sp)
    80000d2a:	7942                	ld	s2,48(sp)
    80000d2c:	79a2                	ld	s3,40(sp)
    80000d2e:	7a02                	ld	s4,32(sp)
    80000d30:	6ae2                	ld	s5,24(sp)
    80000d32:	6b42                	ld	s6,16(sp)
    80000d34:	6ba2                	ld	s7,8(sp)
    80000d36:	6c02                	ld	s8,0(sp)
    80000d38:	6161                	addi	sp,sp,80
    80000d3a:	8082                	ret

0000000080000d3c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000d3c:	caa5                	beqz	a3,80000dac <copyin+0x70>
{
    80000d3e:	715d                	addi	sp,sp,-80
    80000d40:	e486                	sd	ra,72(sp)
    80000d42:	e0a2                	sd	s0,64(sp)
    80000d44:	fc26                	sd	s1,56(sp)
    80000d46:	f84a                	sd	s2,48(sp)
    80000d48:	f44e                	sd	s3,40(sp)
    80000d4a:	f052                	sd	s4,32(sp)
    80000d4c:	ec56                	sd	s5,24(sp)
    80000d4e:	e85a                	sd	s6,16(sp)
    80000d50:	e45e                	sd	s7,8(sp)
    80000d52:	e062                	sd	s8,0(sp)
    80000d54:	0880                	addi	s0,sp,80
    80000d56:	8b2a                	mv	s6,a0
    80000d58:	8a2e                	mv	s4,a1
    80000d5a:	8c32                	mv	s8,a2
    80000d5c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d5e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d60:	6a85                	lui	s5,0x1
    80000d62:	a01d                	j	80000d88 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d64:	018505b3          	add	a1,a0,s8
    80000d68:	0004861b          	sext.w	a2,s1
    80000d6c:	412585b3          	sub	a1,a1,s2
    80000d70:	8552                	mv	a0,s4
    80000d72:	fffff097          	auipc	ra,0xfffff
    80000d76:	5fc080e7          	jalr	1532(ra) # 8000036e <memmove>

    len -= n;
    80000d7a:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d7e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d80:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d84:	02098263          	beqz	s3,80000da8 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000d88:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d8c:	85ca                	mv	a1,s2
    80000d8e:	855a                	mv	a0,s6
    80000d90:	00000097          	auipc	ra,0x0
    80000d94:	918080e7          	jalr	-1768(ra) # 800006a8 <walkaddr>
    if(pa0 == 0)
    80000d98:	cd01                	beqz	a0,80000db0 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d9a:	418904b3          	sub	s1,s2,s8
    80000d9e:	94d6                	add	s1,s1,s5
    80000da0:	fc99f2e3          	bgeu	s3,s1,80000d64 <copyin+0x28>
    80000da4:	84ce                	mv	s1,s3
    80000da6:	bf7d                	j	80000d64 <copyin+0x28>
  }
  return 0;
    80000da8:	4501                	li	a0,0
    80000daa:	a021                	j	80000db2 <copyin+0x76>
    80000dac:	4501                	li	a0,0
}
    80000dae:	8082                	ret
      return -1;
    80000db0:	557d                	li	a0,-1
}
    80000db2:	60a6                	ld	ra,72(sp)
    80000db4:	6406                	ld	s0,64(sp)
    80000db6:	74e2                	ld	s1,56(sp)
    80000db8:	7942                	ld	s2,48(sp)
    80000dba:	79a2                	ld	s3,40(sp)
    80000dbc:	7a02                	ld	s4,32(sp)
    80000dbe:	6ae2                	ld	s5,24(sp)
    80000dc0:	6b42                	ld	s6,16(sp)
    80000dc2:	6ba2                	ld	s7,8(sp)
    80000dc4:	6c02                	ld	s8,0(sp)
    80000dc6:	6161                	addi	sp,sp,80
    80000dc8:	8082                	ret

0000000080000dca <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000dca:	c2dd                	beqz	a3,80000e70 <copyinstr+0xa6>
{
    80000dcc:	715d                	addi	sp,sp,-80
    80000dce:	e486                	sd	ra,72(sp)
    80000dd0:	e0a2                	sd	s0,64(sp)
    80000dd2:	fc26                	sd	s1,56(sp)
    80000dd4:	f84a                	sd	s2,48(sp)
    80000dd6:	f44e                	sd	s3,40(sp)
    80000dd8:	f052                	sd	s4,32(sp)
    80000dda:	ec56                	sd	s5,24(sp)
    80000ddc:	e85a                	sd	s6,16(sp)
    80000dde:	e45e                	sd	s7,8(sp)
    80000de0:	0880                	addi	s0,sp,80
    80000de2:	8a2a                	mv	s4,a0
    80000de4:	8b2e                	mv	s6,a1
    80000de6:	8bb2                	mv	s7,a2
    80000de8:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000dea:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000dec:	6985                	lui	s3,0x1
    80000dee:	a02d                	j	80000e18 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000df0:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000df4:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000df6:	37fd                	addiw	a5,a5,-1
    80000df8:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000dfc:	60a6                	ld	ra,72(sp)
    80000dfe:	6406                	ld	s0,64(sp)
    80000e00:	74e2                	ld	s1,56(sp)
    80000e02:	7942                	ld	s2,48(sp)
    80000e04:	79a2                	ld	s3,40(sp)
    80000e06:	7a02                	ld	s4,32(sp)
    80000e08:	6ae2                	ld	s5,24(sp)
    80000e0a:	6b42                	ld	s6,16(sp)
    80000e0c:	6ba2                	ld	s7,8(sp)
    80000e0e:	6161                	addi	sp,sp,80
    80000e10:	8082                	ret
    srcva = va0 + PGSIZE;
    80000e12:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000e16:	c8a9                	beqz	s1,80000e68 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000e18:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000e1c:	85ca                	mv	a1,s2
    80000e1e:	8552                	mv	a0,s4
    80000e20:	00000097          	auipc	ra,0x0
    80000e24:	888080e7          	jalr	-1912(ra) # 800006a8 <walkaddr>
    if(pa0 == 0)
    80000e28:	c131                	beqz	a0,80000e6c <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000e2a:	417906b3          	sub	a3,s2,s7
    80000e2e:	96ce                	add	a3,a3,s3
    80000e30:	00d4f363          	bgeu	s1,a3,80000e36 <copyinstr+0x6c>
    80000e34:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000e36:	955e                	add	a0,a0,s7
    80000e38:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000e3c:	daf9                	beqz	a3,80000e12 <copyinstr+0x48>
    80000e3e:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000e40:	41650633          	sub	a2,a0,s6
    80000e44:	fff48593          	addi	a1,s1,-1
    80000e48:	95da                	add	a1,a1,s6
    while(n > 0){
    80000e4a:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000e4c:	00f60733          	add	a4,a2,a5
    80000e50:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd3db8>
    80000e54:	df51                	beqz	a4,80000df0 <copyinstr+0x26>
        *dst = *p;
    80000e56:	00e78023          	sb	a4,0(a5)
      --max;
    80000e5a:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000e5e:	0785                	addi	a5,a5,1
    while(n > 0){
    80000e60:	fed796e3          	bne	a5,a3,80000e4c <copyinstr+0x82>
      dst++;
    80000e64:	8b3e                	mv	s6,a5
    80000e66:	b775                	j	80000e12 <copyinstr+0x48>
    80000e68:	4781                	li	a5,0
    80000e6a:	b771                	j	80000df6 <copyinstr+0x2c>
      return -1;
    80000e6c:	557d                	li	a0,-1
    80000e6e:	b779                	j	80000dfc <copyinstr+0x32>
  int got_null = 0;
    80000e70:	4781                	li	a5,0
  if(got_null){
    80000e72:	37fd                	addiw	a5,a5,-1
    80000e74:	0007851b          	sext.w	a0,a5
}
    80000e78:	8082                	ret

0000000080000e7a <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e7a:	7139                	addi	sp,sp,-64
    80000e7c:	fc06                	sd	ra,56(sp)
    80000e7e:	f822                	sd	s0,48(sp)
    80000e80:	f426                	sd	s1,40(sp)
    80000e82:	f04a                	sd	s2,32(sp)
    80000e84:	ec4e                	sd	s3,24(sp)
    80000e86:	e852                	sd	s4,16(sp)
    80000e88:	e456                	sd	s5,8(sp)
    80000e8a:	e05a                	sd	s6,0(sp)
    80000e8c:	0080                	addi	s0,sp,64
    80000e8e:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e90:	00008497          	auipc	s1,0x8
    80000e94:	76048493          	addi	s1,s1,1888 # 800095f0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e98:	8b26                	mv	s6,s1
    80000e9a:	00007a97          	auipc	s5,0x7
    80000e9e:	166a8a93          	addi	s5,s5,358 # 80008000 <etext>
    80000ea2:	04000937          	lui	s2,0x4000
    80000ea6:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000ea8:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eaa:	0000ea17          	auipc	s4,0xe
    80000eae:	346a0a13          	addi	s4,s4,838 # 8000f1f0 <tickslock>
    char *pa = kalloc();
    80000eb2:	fffff097          	auipc	ra,0xfffff
    80000eb6:	39c080e7          	jalr	924(ra) # 8000024e <kalloc>
    80000eba:	862a                	mv	a2,a0
    if(pa == 0)
    80000ebc:	c131                	beqz	a0,80000f00 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000ebe:	416485b3          	sub	a1,s1,s6
    80000ec2:	8591                	srai	a1,a1,0x4
    80000ec4:	000ab783          	ld	a5,0(s5)
    80000ec8:	02f585b3          	mul	a1,a1,a5
    80000ecc:	2585                	addiw	a1,a1,1
    80000ece:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000ed2:	4719                	li	a4,6
    80000ed4:	6685                	lui	a3,0x1
    80000ed6:	40b905b3          	sub	a1,s2,a1
    80000eda:	854e                	mv	a0,s3
    80000edc:	00000097          	auipc	ra,0x0
    80000ee0:	8ae080e7          	jalr	-1874(ra) # 8000078a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee4:	17048493          	addi	s1,s1,368
    80000ee8:	fd4495e3          	bne	s1,s4,80000eb2 <proc_mapstacks+0x38>
  }
}
    80000eec:	70e2                	ld	ra,56(sp)
    80000eee:	7442                	ld	s0,48(sp)
    80000ef0:	74a2                	ld	s1,40(sp)
    80000ef2:	7902                	ld	s2,32(sp)
    80000ef4:	69e2                	ld	s3,24(sp)
    80000ef6:	6a42                	ld	s4,16(sp)
    80000ef8:	6aa2                	ld	s5,8(sp)
    80000efa:	6b02                	ld	s6,0(sp)
    80000efc:	6121                	addi	sp,sp,64
    80000efe:	8082                	ret
      panic("kalloc");
    80000f00:	00007517          	auipc	a0,0x7
    80000f04:	26050513          	addi	a0,a0,608 # 80008160 <etext+0x160>
    80000f08:	00005097          	auipc	ra,0x5
    80000f0c:	2fc080e7          	jalr	764(ra) # 80006204 <panic>

0000000080000f10 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000f10:	7139                	addi	sp,sp,-64
    80000f12:	fc06                	sd	ra,56(sp)
    80000f14:	f822                	sd	s0,48(sp)
    80000f16:	f426                	sd	s1,40(sp)
    80000f18:	f04a                	sd	s2,32(sp)
    80000f1a:	ec4e                	sd	s3,24(sp)
    80000f1c:	e852                	sd	s4,16(sp)
    80000f1e:	e456                	sd	s5,8(sp)
    80000f20:	e05a                	sd	s6,0(sp)
    80000f22:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f24:	00007597          	auipc	a1,0x7
    80000f28:	24458593          	addi	a1,a1,580 # 80008168 <etext+0x168>
    80000f2c:	00008517          	auipc	a0,0x8
    80000f30:	28450513          	addi	a0,a0,644 # 800091b0 <pid_lock>
    80000f34:	00006097          	auipc	ra,0x6
    80000f38:	96e080e7          	jalr	-1682(ra) # 800068a2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f3c:	00007597          	auipc	a1,0x7
    80000f40:	23458593          	addi	a1,a1,564 # 80008170 <etext+0x170>
    80000f44:	00008517          	auipc	a0,0x8
    80000f48:	28c50513          	addi	a0,a0,652 # 800091d0 <wait_lock>
    80000f4c:	00006097          	auipc	ra,0x6
    80000f50:	956080e7          	jalr	-1706(ra) # 800068a2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f54:	00008497          	auipc	s1,0x8
    80000f58:	69c48493          	addi	s1,s1,1692 # 800095f0 <proc>
      initlock(&p->lock, "proc");
    80000f5c:	00007b17          	auipc	s6,0x7
    80000f60:	224b0b13          	addi	s6,s6,548 # 80008180 <etext+0x180>
      p->kstack = KSTACK((int) (p - proc));
    80000f64:	8aa6                	mv	s5,s1
    80000f66:	00007a17          	auipc	s4,0x7
    80000f6a:	09aa0a13          	addi	s4,s4,154 # 80008000 <etext>
    80000f6e:	04000937          	lui	s2,0x4000
    80000f72:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000f74:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f76:	0000e997          	auipc	s3,0xe
    80000f7a:	27a98993          	addi	s3,s3,634 # 8000f1f0 <tickslock>
      initlock(&p->lock, "proc");
    80000f7e:	85da                	mv	a1,s6
    80000f80:	8526                	mv	a0,s1
    80000f82:	00006097          	auipc	ra,0x6
    80000f86:	920080e7          	jalr	-1760(ra) # 800068a2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f8a:	415487b3          	sub	a5,s1,s5
    80000f8e:	8791                	srai	a5,a5,0x4
    80000f90:	000a3703          	ld	a4,0(s4)
    80000f94:	02e787b3          	mul	a5,a5,a4
    80000f98:	2785                	addiw	a5,a5,1
    80000f9a:	00d7979b          	slliw	a5,a5,0xd
    80000f9e:	40f907b3          	sub	a5,s2,a5
    80000fa2:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fa4:	17048493          	addi	s1,s1,368
    80000fa8:	fd349be3          	bne	s1,s3,80000f7e <procinit+0x6e>
  }
}
    80000fac:	70e2                	ld	ra,56(sp)
    80000fae:	7442                	ld	s0,48(sp)
    80000fb0:	74a2                	ld	s1,40(sp)
    80000fb2:	7902                	ld	s2,32(sp)
    80000fb4:	69e2                	ld	s3,24(sp)
    80000fb6:	6a42                	ld	s4,16(sp)
    80000fb8:	6aa2                	ld	s5,8(sp)
    80000fba:	6b02                	ld	s6,0(sp)
    80000fbc:	6121                	addi	sp,sp,64
    80000fbe:	8082                	ret

0000000080000fc0 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000fc0:	1141                	addi	sp,sp,-16
    80000fc2:	e422                	sd	s0,8(sp)
    80000fc4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fc6:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000fc8:	2501                	sext.w	a0,a0
    80000fca:	6422                	ld	s0,8(sp)
    80000fcc:	0141                	addi	sp,sp,16
    80000fce:	8082                	ret

0000000080000fd0 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000fd0:	1141                	addi	sp,sp,-16
    80000fd2:	e422                	sd	s0,8(sp)
    80000fd4:	0800                	addi	s0,sp,16
    80000fd6:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000fd8:	2781                	sext.w	a5,a5
    80000fda:	079e                	slli	a5,a5,0x7
  return c;
}
    80000fdc:	00008517          	auipc	a0,0x8
    80000fe0:	21450513          	addi	a0,a0,532 # 800091f0 <cpus>
    80000fe4:	953e                	add	a0,a0,a5
    80000fe6:	6422                	ld	s0,8(sp)
    80000fe8:	0141                	addi	sp,sp,16
    80000fea:	8082                	ret

0000000080000fec <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000fec:	1101                	addi	sp,sp,-32
    80000fee:	ec06                	sd	ra,24(sp)
    80000ff0:	e822                	sd	s0,16(sp)
    80000ff2:	e426                	sd	s1,8(sp)
    80000ff4:	1000                	addi	s0,sp,32
  push_off();
    80000ff6:	00005097          	auipc	ra,0x5
    80000ffa:	6e4080e7          	jalr	1764(ra) # 800066da <push_off>
    80000ffe:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001000:	2781                	sext.w	a5,a5
    80001002:	079e                	slli	a5,a5,0x7
    80001004:	00008717          	auipc	a4,0x8
    80001008:	1ac70713          	addi	a4,a4,428 # 800091b0 <pid_lock>
    8000100c:	97ba                	add	a5,a5,a4
    8000100e:	63a4                	ld	s1,64(a5)
  pop_off();
    80001010:	00005097          	auipc	ra,0x5
    80001014:	786080e7          	jalr	1926(ra) # 80006796 <pop_off>
  return p;
}
    80001018:	8526                	mv	a0,s1
    8000101a:	60e2                	ld	ra,24(sp)
    8000101c:	6442                	ld	s0,16(sp)
    8000101e:	64a2                	ld	s1,8(sp)
    80001020:	6105                	addi	sp,sp,32
    80001022:	8082                	ret

0000000080001024 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001024:	1141                	addi	sp,sp,-16
    80001026:	e406                	sd	ra,8(sp)
    80001028:	e022                	sd	s0,0(sp)
    8000102a:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000102c:	00000097          	auipc	ra,0x0
    80001030:	fc0080e7          	jalr	-64(ra) # 80000fec <myproc>
    80001034:	00005097          	auipc	ra,0x5
    80001038:	7c2080e7          	jalr	1986(ra) # 800067f6 <release>

  if (first) {
    8000103c:	00008797          	auipc	a5,0x8
    80001040:	8b47a783          	lw	a5,-1868(a5) # 800088f0 <first.1>
    80001044:	eb89                	bnez	a5,80001056 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001046:	00001097          	auipc	ra,0x1
    8000104a:	c14080e7          	jalr	-1004(ra) # 80001c5a <usertrapret>
}
    8000104e:	60a2                	ld	ra,8(sp)
    80001050:	6402                	ld	s0,0(sp)
    80001052:	0141                	addi	sp,sp,16
    80001054:	8082                	ret
    first = 0;
    80001056:	00008797          	auipc	a5,0x8
    8000105a:	8807ad23          	sw	zero,-1894(a5) # 800088f0 <first.1>
    fsinit(ROOTDEV);
    8000105e:	4505                	li	a0,1
    80001060:	00002097          	auipc	ra,0x2
    80001064:	b7c080e7          	jalr	-1156(ra) # 80002bdc <fsinit>
    80001068:	bff9                	j	80001046 <forkret+0x22>

000000008000106a <allocpid>:
allocpid() {
    8000106a:	1101                	addi	sp,sp,-32
    8000106c:	ec06                	sd	ra,24(sp)
    8000106e:	e822                	sd	s0,16(sp)
    80001070:	e426                	sd	s1,8(sp)
    80001072:	e04a                	sd	s2,0(sp)
    80001074:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001076:	00008917          	auipc	s2,0x8
    8000107a:	13a90913          	addi	s2,s2,314 # 800091b0 <pid_lock>
    8000107e:	854a                	mv	a0,s2
    80001080:	00005097          	auipc	ra,0x5
    80001084:	6a6080e7          	jalr	1702(ra) # 80006726 <acquire>
  pid = nextpid;
    80001088:	00008797          	auipc	a5,0x8
    8000108c:	86c78793          	addi	a5,a5,-1940 # 800088f4 <nextpid>
    80001090:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001092:	0014871b          	addiw	a4,s1,1
    80001096:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001098:	854a                	mv	a0,s2
    8000109a:	00005097          	auipc	ra,0x5
    8000109e:	75c080e7          	jalr	1884(ra) # 800067f6 <release>
}
    800010a2:	8526                	mv	a0,s1
    800010a4:	60e2                	ld	ra,24(sp)
    800010a6:	6442                	ld	s0,16(sp)
    800010a8:	64a2                	ld	s1,8(sp)
    800010aa:	6902                	ld	s2,0(sp)
    800010ac:	6105                	addi	sp,sp,32
    800010ae:	8082                	ret

00000000800010b0 <proc_pagetable>:
{
    800010b0:	1101                	addi	sp,sp,-32
    800010b2:	ec06                	sd	ra,24(sp)
    800010b4:	e822                	sd	s0,16(sp)
    800010b6:	e426                	sd	s1,8(sp)
    800010b8:	e04a                	sd	s2,0(sp)
    800010ba:	1000                	addi	s0,sp,32
    800010bc:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010be:	00000097          	auipc	ra,0x0
    800010c2:	8b6080e7          	jalr	-1866(ra) # 80000974 <uvmcreate>
    800010c6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800010c8:	c121                	beqz	a0,80001108 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010ca:	4729                	li	a4,10
    800010cc:	00006697          	auipc	a3,0x6
    800010d0:	f3468693          	addi	a3,a3,-204 # 80007000 <_trampoline>
    800010d4:	6605                	lui	a2,0x1
    800010d6:	040005b7          	lui	a1,0x4000
    800010da:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010dc:	05b2                	slli	a1,a1,0xc
    800010de:	fffff097          	auipc	ra,0xfffff
    800010e2:	60c080e7          	jalr	1548(ra) # 800006ea <mappages>
    800010e6:	02054863          	bltz	a0,80001116 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800010ea:	4719                	li	a4,6
    800010ec:	06093683          	ld	a3,96(s2)
    800010f0:	6605                	lui	a2,0x1
    800010f2:	020005b7          	lui	a1,0x2000
    800010f6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010f8:	05b6                	slli	a1,a1,0xd
    800010fa:	8526                	mv	a0,s1
    800010fc:	fffff097          	auipc	ra,0xfffff
    80001100:	5ee080e7          	jalr	1518(ra) # 800006ea <mappages>
    80001104:	02054163          	bltz	a0,80001126 <proc_pagetable+0x76>
}
    80001108:	8526                	mv	a0,s1
    8000110a:	60e2                	ld	ra,24(sp)
    8000110c:	6442                	ld	s0,16(sp)
    8000110e:	64a2                	ld	s1,8(sp)
    80001110:	6902                	ld	s2,0(sp)
    80001112:	6105                	addi	sp,sp,32
    80001114:	8082                	ret
    uvmfree(pagetable, 0);
    80001116:	4581                	li	a1,0
    80001118:	8526                	mv	a0,s1
    8000111a:	00000097          	auipc	ra,0x0
    8000111e:	a58080e7          	jalr	-1448(ra) # 80000b72 <uvmfree>
    return 0;
    80001122:	4481                	li	s1,0
    80001124:	b7d5                	j	80001108 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001126:	4681                	li	a3,0
    80001128:	4605                	li	a2,1
    8000112a:	040005b7          	lui	a1,0x4000
    8000112e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001130:	05b2                	slli	a1,a1,0xc
    80001132:	8526                	mv	a0,s1
    80001134:	fffff097          	auipc	ra,0xfffff
    80001138:	77c080e7          	jalr	1916(ra) # 800008b0 <uvmunmap>
    uvmfree(pagetable, 0);
    8000113c:	4581                	li	a1,0
    8000113e:	8526                	mv	a0,s1
    80001140:	00000097          	auipc	ra,0x0
    80001144:	a32080e7          	jalr	-1486(ra) # 80000b72 <uvmfree>
    return 0;
    80001148:	4481                	li	s1,0
    8000114a:	bf7d                	j	80001108 <proc_pagetable+0x58>

000000008000114c <proc_freepagetable>:
{
    8000114c:	1101                	addi	sp,sp,-32
    8000114e:	ec06                	sd	ra,24(sp)
    80001150:	e822                	sd	s0,16(sp)
    80001152:	e426                	sd	s1,8(sp)
    80001154:	e04a                	sd	s2,0(sp)
    80001156:	1000                	addi	s0,sp,32
    80001158:	84aa                	mv	s1,a0
    8000115a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000115c:	4681                	li	a3,0
    8000115e:	4605                	li	a2,1
    80001160:	040005b7          	lui	a1,0x4000
    80001164:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001166:	05b2                	slli	a1,a1,0xc
    80001168:	fffff097          	auipc	ra,0xfffff
    8000116c:	748080e7          	jalr	1864(ra) # 800008b0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001170:	4681                	li	a3,0
    80001172:	4605                	li	a2,1
    80001174:	020005b7          	lui	a1,0x2000
    80001178:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000117a:	05b6                	slli	a1,a1,0xd
    8000117c:	8526                	mv	a0,s1
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	732080e7          	jalr	1842(ra) # 800008b0 <uvmunmap>
  uvmfree(pagetable, sz);
    80001186:	85ca                	mv	a1,s2
    80001188:	8526                	mv	a0,s1
    8000118a:	00000097          	auipc	ra,0x0
    8000118e:	9e8080e7          	jalr	-1560(ra) # 80000b72 <uvmfree>
}
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6902                	ld	s2,0(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <freeproc>:
{
    8000119e:	1101                	addi	sp,sp,-32
    800011a0:	ec06                	sd	ra,24(sp)
    800011a2:	e822                	sd	s0,16(sp)
    800011a4:	e426                	sd	s1,8(sp)
    800011a6:	1000                	addi	s0,sp,32
    800011a8:	84aa                	mv	s1,a0
  if(p->trapframe)
    800011aa:	7128                	ld	a0,96(a0)
    800011ac:	c509                	beqz	a0,800011b6 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011ae:	fffff097          	auipc	ra,0xfffff
    800011b2:	e6e080e7          	jalr	-402(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011b6:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800011ba:	6ca8                	ld	a0,88(s1)
    800011bc:	c511                	beqz	a0,800011c8 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800011be:	68ac                	ld	a1,80(s1)
    800011c0:	00000097          	auipc	ra,0x0
    800011c4:	f8c080e7          	jalr	-116(ra) # 8000114c <proc_freepagetable>
  p->pagetable = 0;
    800011c8:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    800011cc:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    800011d0:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    800011d4:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    800011d8:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800011dc:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    800011e0:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    800011e4:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    800011e8:	0204a023          	sw	zero,32(s1)
}
    800011ec:	60e2                	ld	ra,24(sp)
    800011ee:	6442                	ld	s0,16(sp)
    800011f0:	64a2                	ld	s1,8(sp)
    800011f2:	6105                	addi	sp,sp,32
    800011f4:	8082                	ret

00000000800011f6 <allocproc>:
{
    800011f6:	1101                	addi	sp,sp,-32
    800011f8:	ec06                	sd	ra,24(sp)
    800011fa:	e822                	sd	s0,16(sp)
    800011fc:	e426                	sd	s1,8(sp)
    800011fe:	e04a                	sd	s2,0(sp)
    80001200:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001202:	00008497          	auipc	s1,0x8
    80001206:	3ee48493          	addi	s1,s1,1006 # 800095f0 <proc>
    8000120a:	0000e917          	auipc	s2,0xe
    8000120e:	fe690913          	addi	s2,s2,-26 # 8000f1f0 <tickslock>
    acquire(&p->lock);
    80001212:	8526                	mv	a0,s1
    80001214:	00005097          	auipc	ra,0x5
    80001218:	512080e7          	jalr	1298(ra) # 80006726 <acquire>
    if(p->state == UNUSED) {
    8000121c:	509c                	lw	a5,32(s1)
    8000121e:	cf81                	beqz	a5,80001236 <allocproc+0x40>
      release(&p->lock);
    80001220:	8526                	mv	a0,s1
    80001222:	00005097          	auipc	ra,0x5
    80001226:	5d4080e7          	jalr	1492(ra) # 800067f6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000122a:	17048493          	addi	s1,s1,368
    8000122e:	ff2492e3          	bne	s1,s2,80001212 <allocproc+0x1c>
  return 0;
    80001232:	4481                	li	s1,0
    80001234:	a889                	j	80001286 <allocproc+0x90>
  p->pid = allocpid();
    80001236:	00000097          	auipc	ra,0x0
    8000123a:	e34080e7          	jalr	-460(ra) # 8000106a <allocpid>
    8000123e:	dc88                	sw	a0,56(s1)
  p->state = USED;
    80001240:	4785                	li	a5,1
    80001242:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001244:	fffff097          	auipc	ra,0xfffff
    80001248:	00a080e7          	jalr	10(ra) # 8000024e <kalloc>
    8000124c:	892a                	mv	s2,a0
    8000124e:	f0a8                	sd	a0,96(s1)
    80001250:	c131                	beqz	a0,80001294 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001252:	8526                	mv	a0,s1
    80001254:	00000097          	auipc	ra,0x0
    80001258:	e5c080e7          	jalr	-420(ra) # 800010b0 <proc_pagetable>
    8000125c:	892a                	mv	s2,a0
    8000125e:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001260:	c531                	beqz	a0,800012ac <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001262:	07000613          	li	a2,112
    80001266:	4581                	li	a1,0
    80001268:	06848513          	addi	a0,s1,104
    8000126c:	fffff097          	auipc	ra,0xfffff
    80001270:	0a6080e7          	jalr	166(ra) # 80000312 <memset>
  p->context.ra = (uint64)forkret;
    80001274:	00000797          	auipc	a5,0x0
    80001278:	db078793          	addi	a5,a5,-592 # 80001024 <forkret>
    8000127c:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000127e:	64bc                	ld	a5,72(s1)
    80001280:	6705                	lui	a4,0x1
    80001282:	97ba                	add	a5,a5,a4
    80001284:	f8bc                	sd	a5,112(s1)
}
    80001286:	8526                	mv	a0,s1
    80001288:	60e2                	ld	ra,24(sp)
    8000128a:	6442                	ld	s0,16(sp)
    8000128c:	64a2                	ld	s1,8(sp)
    8000128e:	6902                	ld	s2,0(sp)
    80001290:	6105                	addi	sp,sp,32
    80001292:	8082                	ret
    freeproc(p);
    80001294:	8526                	mv	a0,s1
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	f08080e7          	jalr	-248(ra) # 8000119e <freeproc>
    release(&p->lock);
    8000129e:	8526                	mv	a0,s1
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	556080e7          	jalr	1366(ra) # 800067f6 <release>
    return 0;
    800012a8:	84ca                	mv	s1,s2
    800012aa:	bff1                	j	80001286 <allocproc+0x90>
    freeproc(p);
    800012ac:	8526                	mv	a0,s1
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	ef0080e7          	jalr	-272(ra) # 8000119e <freeproc>
    release(&p->lock);
    800012b6:	8526                	mv	a0,s1
    800012b8:	00005097          	auipc	ra,0x5
    800012bc:	53e080e7          	jalr	1342(ra) # 800067f6 <release>
    return 0;
    800012c0:	84ca                	mv	s1,s2
    800012c2:	b7d1                	j	80001286 <allocproc+0x90>

00000000800012c4 <userinit>:
{
    800012c4:	1101                	addi	sp,sp,-32
    800012c6:	ec06                	sd	ra,24(sp)
    800012c8:	e822                	sd	s0,16(sp)
    800012ca:	e426                	sd	s1,8(sp)
    800012cc:	1000                	addi	s0,sp,32
  p = allocproc();
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	f28080e7          	jalr	-216(ra) # 800011f6 <allocproc>
    800012d6:	84aa                	mv	s1,a0
  initproc = p;
    800012d8:	00008797          	auipc	a5,0x8
    800012dc:	d2a7bc23          	sd	a0,-712(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012e0:	03400613          	li	a2,52
    800012e4:	00007597          	auipc	a1,0x7
    800012e8:	61c58593          	addi	a1,a1,1564 # 80008900 <initcode>
    800012ec:	6d28                	ld	a0,88(a0)
    800012ee:	fffff097          	auipc	ra,0xfffff
    800012f2:	6b4080e7          	jalr	1716(ra) # 800009a2 <uvminit>
  p->sz = PGSIZE;
    800012f6:	6785                	lui	a5,0x1
    800012f8:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    800012fa:	70b8                	ld	a4,96(s1)
    800012fc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001300:	70b8                	ld	a4,96(s1)
    80001302:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001304:	4641                	li	a2,16
    80001306:	00007597          	auipc	a1,0x7
    8000130a:	e8258593          	addi	a1,a1,-382 # 80008188 <etext+0x188>
    8000130e:	16048513          	addi	a0,s1,352
    80001312:	fffff097          	auipc	ra,0xfffff
    80001316:	14a080e7          	jalr	330(ra) # 8000045c <safestrcpy>
  p->cwd = namei("/");
    8000131a:	00007517          	auipc	a0,0x7
    8000131e:	e7e50513          	addi	a0,a0,-386 # 80008198 <etext+0x198>
    80001322:	00002097          	auipc	ra,0x2
    80001326:	2f0080e7          	jalr	752(ra) # 80003612 <namei>
    8000132a:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    8000132e:	478d                	li	a5,3
    80001330:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001332:	8526                	mv	a0,s1
    80001334:	00005097          	auipc	ra,0x5
    80001338:	4c2080e7          	jalr	1218(ra) # 800067f6 <release>
}
    8000133c:	60e2                	ld	ra,24(sp)
    8000133e:	6442                	ld	s0,16(sp)
    80001340:	64a2                	ld	s1,8(sp)
    80001342:	6105                	addi	sp,sp,32
    80001344:	8082                	ret

0000000080001346 <growproc>:
{
    80001346:	1101                	addi	sp,sp,-32
    80001348:	ec06                	sd	ra,24(sp)
    8000134a:	e822                	sd	s0,16(sp)
    8000134c:	e426                	sd	s1,8(sp)
    8000134e:	e04a                	sd	s2,0(sp)
    80001350:	1000                	addi	s0,sp,32
    80001352:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001354:	00000097          	auipc	ra,0x0
    80001358:	c98080e7          	jalr	-872(ra) # 80000fec <myproc>
    8000135c:	892a                	mv	s2,a0
  sz = p->sz;
    8000135e:	692c                	ld	a1,80(a0)
    80001360:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001364:	00904f63          	bgtz	s1,80001382 <growproc+0x3c>
  } else if(n < 0){
    80001368:	0204cd63          	bltz	s1,800013a2 <growproc+0x5c>
  p->sz = sz;
    8000136c:	1782                	slli	a5,a5,0x20
    8000136e:	9381                	srli	a5,a5,0x20
    80001370:	04f93823          	sd	a5,80(s2)
  return 0;
    80001374:	4501                	li	a0,0
}
    80001376:	60e2                	ld	ra,24(sp)
    80001378:	6442                	ld	s0,16(sp)
    8000137a:	64a2                	ld	s1,8(sp)
    8000137c:	6902                	ld	s2,0(sp)
    8000137e:	6105                	addi	sp,sp,32
    80001380:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001382:	00f4863b          	addw	a2,s1,a5
    80001386:	1602                	slli	a2,a2,0x20
    80001388:	9201                	srli	a2,a2,0x20
    8000138a:	1582                	slli	a1,a1,0x20
    8000138c:	9181                	srli	a1,a1,0x20
    8000138e:	6d28                	ld	a0,88(a0)
    80001390:	fffff097          	auipc	ra,0xfffff
    80001394:	6cc080e7          	jalr	1740(ra) # 80000a5c <uvmalloc>
    80001398:	0005079b          	sext.w	a5,a0
    8000139c:	fbe1                	bnez	a5,8000136c <growproc+0x26>
      return -1;
    8000139e:	557d                	li	a0,-1
    800013a0:	bfd9                	j	80001376 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013a2:	00f4863b          	addw	a2,s1,a5
    800013a6:	1602                	slli	a2,a2,0x20
    800013a8:	9201                	srli	a2,a2,0x20
    800013aa:	1582                	slli	a1,a1,0x20
    800013ac:	9181                	srli	a1,a1,0x20
    800013ae:	6d28                	ld	a0,88(a0)
    800013b0:	fffff097          	auipc	ra,0xfffff
    800013b4:	664080e7          	jalr	1636(ra) # 80000a14 <uvmdealloc>
    800013b8:	0005079b          	sext.w	a5,a0
    800013bc:	bf45                	j	8000136c <growproc+0x26>

00000000800013be <fork>:
{
    800013be:	7139                	addi	sp,sp,-64
    800013c0:	fc06                	sd	ra,56(sp)
    800013c2:	f822                	sd	s0,48(sp)
    800013c4:	f426                	sd	s1,40(sp)
    800013c6:	f04a                	sd	s2,32(sp)
    800013c8:	ec4e                	sd	s3,24(sp)
    800013ca:	e852                	sd	s4,16(sp)
    800013cc:	e456                	sd	s5,8(sp)
    800013ce:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800013d0:	00000097          	auipc	ra,0x0
    800013d4:	c1c080e7          	jalr	-996(ra) # 80000fec <myproc>
    800013d8:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800013da:	00000097          	auipc	ra,0x0
    800013de:	e1c080e7          	jalr	-484(ra) # 800011f6 <allocproc>
    800013e2:	10050c63          	beqz	a0,800014fa <fork+0x13c>
    800013e6:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013e8:	050ab603          	ld	a2,80(s5)
    800013ec:	6d2c                	ld	a1,88(a0)
    800013ee:	058ab503          	ld	a0,88(s5)
    800013f2:	fffff097          	auipc	ra,0xfffff
    800013f6:	7ba080e7          	jalr	1978(ra) # 80000bac <uvmcopy>
    800013fa:	04054863          	bltz	a0,8000144a <fork+0x8c>
  np->sz = p->sz;
    800013fe:	050ab783          	ld	a5,80(s5)
    80001402:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    80001406:	060ab683          	ld	a3,96(s5)
    8000140a:	87b6                	mv	a5,a3
    8000140c:	060a3703          	ld	a4,96(s4)
    80001410:	12068693          	addi	a3,a3,288
    80001414:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001418:	6788                	ld	a0,8(a5)
    8000141a:	6b8c                	ld	a1,16(a5)
    8000141c:	6f90                	ld	a2,24(a5)
    8000141e:	01073023          	sd	a6,0(a4)
    80001422:	e708                	sd	a0,8(a4)
    80001424:	eb0c                	sd	a1,16(a4)
    80001426:	ef10                	sd	a2,24(a4)
    80001428:	02078793          	addi	a5,a5,32
    8000142c:	02070713          	addi	a4,a4,32
    80001430:	fed792e3          	bne	a5,a3,80001414 <fork+0x56>
  np->trapframe->a0 = 0;
    80001434:	060a3783          	ld	a5,96(s4)
    80001438:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000143c:	0d8a8493          	addi	s1,s5,216
    80001440:	0d8a0913          	addi	s2,s4,216
    80001444:	158a8993          	addi	s3,s5,344
    80001448:	a00d                	j	8000146a <fork+0xac>
    freeproc(np);
    8000144a:	8552                	mv	a0,s4
    8000144c:	00000097          	auipc	ra,0x0
    80001450:	d52080e7          	jalr	-686(ra) # 8000119e <freeproc>
    release(&np->lock);
    80001454:	8552                	mv	a0,s4
    80001456:	00005097          	auipc	ra,0x5
    8000145a:	3a0080e7          	jalr	928(ra) # 800067f6 <release>
    return -1;
    8000145e:	597d                	li	s2,-1
    80001460:	a059                	j	800014e6 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001462:	04a1                	addi	s1,s1,8
    80001464:	0921                	addi	s2,s2,8
    80001466:	01348b63          	beq	s1,s3,8000147c <fork+0xbe>
    if(p->ofile[i])
    8000146a:	6088                	ld	a0,0(s1)
    8000146c:	d97d                	beqz	a0,80001462 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    8000146e:	00003097          	auipc	ra,0x3
    80001472:	83a080e7          	jalr	-1990(ra) # 80003ca8 <filedup>
    80001476:	00a93023          	sd	a0,0(s2)
    8000147a:	b7e5                	j	80001462 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000147c:	158ab503          	ld	a0,344(s5)
    80001480:	00002097          	auipc	ra,0x2
    80001484:	998080e7          	jalr	-1640(ra) # 80002e18 <idup>
    80001488:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000148c:	4641                	li	a2,16
    8000148e:	160a8593          	addi	a1,s5,352
    80001492:	160a0513          	addi	a0,s4,352
    80001496:	fffff097          	auipc	ra,0xfffff
    8000149a:	fc6080e7          	jalr	-58(ra) # 8000045c <safestrcpy>
  pid = np->pid;
    8000149e:	038a2903          	lw	s2,56(s4)
  release(&np->lock);
    800014a2:	8552                	mv	a0,s4
    800014a4:	00005097          	auipc	ra,0x5
    800014a8:	352080e7          	jalr	850(ra) # 800067f6 <release>
  acquire(&wait_lock);
    800014ac:	00008497          	auipc	s1,0x8
    800014b0:	d2448493          	addi	s1,s1,-732 # 800091d0 <wait_lock>
    800014b4:	8526                	mv	a0,s1
    800014b6:	00005097          	auipc	ra,0x5
    800014ba:	270080e7          	jalr	624(ra) # 80006726 <acquire>
  np->parent = p;
    800014be:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    800014c2:	8526                	mv	a0,s1
    800014c4:	00005097          	auipc	ra,0x5
    800014c8:	332080e7          	jalr	818(ra) # 800067f6 <release>
  acquire(&np->lock);
    800014cc:	8552                	mv	a0,s4
    800014ce:	00005097          	auipc	ra,0x5
    800014d2:	258080e7          	jalr	600(ra) # 80006726 <acquire>
  np->state = RUNNABLE;
    800014d6:	478d                	li	a5,3
    800014d8:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    800014dc:	8552                	mv	a0,s4
    800014de:	00005097          	auipc	ra,0x5
    800014e2:	318080e7          	jalr	792(ra) # 800067f6 <release>
}
    800014e6:	854a                	mv	a0,s2
    800014e8:	70e2                	ld	ra,56(sp)
    800014ea:	7442                	ld	s0,48(sp)
    800014ec:	74a2                	ld	s1,40(sp)
    800014ee:	7902                	ld	s2,32(sp)
    800014f0:	69e2                	ld	s3,24(sp)
    800014f2:	6a42                	ld	s4,16(sp)
    800014f4:	6aa2                	ld	s5,8(sp)
    800014f6:	6121                	addi	sp,sp,64
    800014f8:	8082                	ret
    return -1;
    800014fa:	597d                	li	s2,-1
    800014fc:	b7ed                	j	800014e6 <fork+0x128>

00000000800014fe <scheduler>:
{
    800014fe:	7139                	addi	sp,sp,-64
    80001500:	fc06                	sd	ra,56(sp)
    80001502:	f822                	sd	s0,48(sp)
    80001504:	f426                	sd	s1,40(sp)
    80001506:	f04a                	sd	s2,32(sp)
    80001508:	ec4e                	sd	s3,24(sp)
    8000150a:	e852                	sd	s4,16(sp)
    8000150c:	e456                	sd	s5,8(sp)
    8000150e:	e05a                	sd	s6,0(sp)
    80001510:	0080                	addi	s0,sp,64
    80001512:	8792                	mv	a5,tp
  int id = r_tp();
    80001514:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001516:	00779a93          	slli	s5,a5,0x7
    8000151a:	00008717          	auipc	a4,0x8
    8000151e:	c9670713          	addi	a4,a4,-874 # 800091b0 <pid_lock>
    80001522:	9756                	add	a4,a4,s5
    80001524:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    80001528:	00008717          	auipc	a4,0x8
    8000152c:	cd070713          	addi	a4,a4,-816 # 800091f8 <cpus+0x8>
    80001530:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001532:	498d                	li	s3,3
        p->state = RUNNING;
    80001534:	4b11                	li	s6,4
        c->proc = p;
    80001536:	079e                	slli	a5,a5,0x7
    80001538:	00008a17          	auipc	s4,0x8
    8000153c:	c78a0a13          	addi	s4,s4,-904 # 800091b0 <pid_lock>
    80001540:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001542:	0000e917          	auipc	s2,0xe
    80001546:	cae90913          	addi	s2,s2,-850 # 8000f1f0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000154a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000154e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001552:	10079073          	csrw	sstatus,a5
    80001556:	00008497          	auipc	s1,0x8
    8000155a:	09a48493          	addi	s1,s1,154 # 800095f0 <proc>
    8000155e:	a811                	j	80001572 <scheduler+0x74>
      release(&p->lock);
    80001560:	8526                	mv	a0,s1
    80001562:	00005097          	auipc	ra,0x5
    80001566:	294080e7          	jalr	660(ra) # 800067f6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000156a:	17048493          	addi	s1,s1,368
    8000156e:	fd248ee3          	beq	s1,s2,8000154a <scheduler+0x4c>
      acquire(&p->lock);
    80001572:	8526                	mv	a0,s1
    80001574:	00005097          	auipc	ra,0x5
    80001578:	1b2080e7          	jalr	434(ra) # 80006726 <acquire>
      if(p->state == RUNNABLE) {
    8000157c:	509c                	lw	a5,32(s1)
    8000157e:	ff3791e3          	bne	a5,s3,80001560 <scheduler+0x62>
        p->state = RUNNING;
    80001582:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    80001586:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    8000158a:	06848593          	addi	a1,s1,104
    8000158e:	8556                	mv	a0,s5
    80001590:	00000097          	auipc	ra,0x0
    80001594:	620080e7          	jalr	1568(ra) # 80001bb0 <swtch>
        c->proc = 0;
    80001598:	040a3023          	sd	zero,64(s4)
    8000159c:	b7d1                	j	80001560 <scheduler+0x62>

000000008000159e <sched>:
{
    8000159e:	7179                	addi	sp,sp,-48
    800015a0:	f406                	sd	ra,40(sp)
    800015a2:	f022                	sd	s0,32(sp)
    800015a4:	ec26                	sd	s1,24(sp)
    800015a6:	e84a                	sd	s2,16(sp)
    800015a8:	e44e                	sd	s3,8(sp)
    800015aa:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015ac:	00000097          	auipc	ra,0x0
    800015b0:	a40080e7          	jalr	-1472(ra) # 80000fec <myproc>
    800015b4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015b6:	00005097          	auipc	ra,0x5
    800015ba:	0f6080e7          	jalr	246(ra) # 800066ac <holding>
    800015be:	c93d                	beqz	a0,80001634 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015c0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015c2:	2781                	sext.w	a5,a5
    800015c4:	079e                	slli	a5,a5,0x7
    800015c6:	00008717          	auipc	a4,0x8
    800015ca:	bea70713          	addi	a4,a4,-1046 # 800091b0 <pid_lock>
    800015ce:	97ba                	add	a5,a5,a4
    800015d0:	0b87a703          	lw	a4,184(a5)
    800015d4:	4785                	li	a5,1
    800015d6:	06f71763          	bne	a4,a5,80001644 <sched+0xa6>
  if(p->state == RUNNING)
    800015da:	5098                	lw	a4,32(s1)
    800015dc:	4791                	li	a5,4
    800015de:	06f70b63          	beq	a4,a5,80001654 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015e2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015e6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015e8:	efb5                	bnez	a5,80001664 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015ea:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015ec:	00008917          	auipc	s2,0x8
    800015f0:	bc490913          	addi	s2,s2,-1084 # 800091b0 <pid_lock>
    800015f4:	2781                	sext.w	a5,a5
    800015f6:	079e                	slli	a5,a5,0x7
    800015f8:	97ca                	add	a5,a5,s2
    800015fa:	0bc7a983          	lw	s3,188(a5)
    800015fe:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001600:	2781                	sext.w	a5,a5
    80001602:	079e                	slli	a5,a5,0x7
    80001604:	00008597          	auipc	a1,0x8
    80001608:	bf458593          	addi	a1,a1,-1036 # 800091f8 <cpus+0x8>
    8000160c:	95be                	add	a1,a1,a5
    8000160e:	06848513          	addi	a0,s1,104
    80001612:	00000097          	auipc	ra,0x0
    80001616:	59e080e7          	jalr	1438(ra) # 80001bb0 <swtch>
    8000161a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000161c:	2781                	sext.w	a5,a5
    8000161e:	079e                	slli	a5,a5,0x7
    80001620:	993e                	add	s2,s2,a5
    80001622:	0b392e23          	sw	s3,188(s2)
}
    80001626:	70a2                	ld	ra,40(sp)
    80001628:	7402                	ld	s0,32(sp)
    8000162a:	64e2                	ld	s1,24(sp)
    8000162c:	6942                	ld	s2,16(sp)
    8000162e:	69a2                	ld	s3,8(sp)
    80001630:	6145                	addi	sp,sp,48
    80001632:	8082                	ret
    panic("sched p->lock");
    80001634:	00007517          	auipc	a0,0x7
    80001638:	b6c50513          	addi	a0,a0,-1172 # 800081a0 <etext+0x1a0>
    8000163c:	00005097          	auipc	ra,0x5
    80001640:	bc8080e7          	jalr	-1080(ra) # 80006204 <panic>
    panic("sched locks");
    80001644:	00007517          	auipc	a0,0x7
    80001648:	b6c50513          	addi	a0,a0,-1172 # 800081b0 <etext+0x1b0>
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	bb8080e7          	jalr	-1096(ra) # 80006204 <panic>
    panic("sched running");
    80001654:	00007517          	auipc	a0,0x7
    80001658:	b6c50513          	addi	a0,a0,-1172 # 800081c0 <etext+0x1c0>
    8000165c:	00005097          	auipc	ra,0x5
    80001660:	ba8080e7          	jalr	-1112(ra) # 80006204 <panic>
    panic("sched interruptible");
    80001664:	00007517          	auipc	a0,0x7
    80001668:	b6c50513          	addi	a0,a0,-1172 # 800081d0 <etext+0x1d0>
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	b98080e7          	jalr	-1128(ra) # 80006204 <panic>

0000000080001674 <yield>:
{
    80001674:	1101                	addi	sp,sp,-32
    80001676:	ec06                	sd	ra,24(sp)
    80001678:	e822                	sd	s0,16(sp)
    8000167a:	e426                	sd	s1,8(sp)
    8000167c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000167e:	00000097          	auipc	ra,0x0
    80001682:	96e080e7          	jalr	-1682(ra) # 80000fec <myproc>
    80001686:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001688:	00005097          	auipc	ra,0x5
    8000168c:	09e080e7          	jalr	158(ra) # 80006726 <acquire>
  p->state = RUNNABLE;
    80001690:	478d                	li	a5,3
    80001692:	d09c                	sw	a5,32(s1)
  sched();
    80001694:	00000097          	auipc	ra,0x0
    80001698:	f0a080e7          	jalr	-246(ra) # 8000159e <sched>
  release(&p->lock);
    8000169c:	8526                	mv	a0,s1
    8000169e:	00005097          	auipc	ra,0x5
    800016a2:	158080e7          	jalr	344(ra) # 800067f6 <release>
}
    800016a6:	60e2                	ld	ra,24(sp)
    800016a8:	6442                	ld	s0,16(sp)
    800016aa:	64a2                	ld	s1,8(sp)
    800016ac:	6105                	addi	sp,sp,32
    800016ae:	8082                	ret

00000000800016b0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016b0:	7179                	addi	sp,sp,-48
    800016b2:	f406                	sd	ra,40(sp)
    800016b4:	f022                	sd	s0,32(sp)
    800016b6:	ec26                	sd	s1,24(sp)
    800016b8:	e84a                	sd	s2,16(sp)
    800016ba:	e44e                	sd	s3,8(sp)
    800016bc:	1800                	addi	s0,sp,48
    800016be:	89aa                	mv	s3,a0
    800016c0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016c2:	00000097          	auipc	ra,0x0
    800016c6:	92a080e7          	jalr	-1750(ra) # 80000fec <myproc>
    800016ca:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016cc:	00005097          	auipc	ra,0x5
    800016d0:	05a080e7          	jalr	90(ra) # 80006726 <acquire>
  release(lk);
    800016d4:	854a                	mv	a0,s2
    800016d6:	00005097          	auipc	ra,0x5
    800016da:	120080e7          	jalr	288(ra) # 800067f6 <release>

  // Go to sleep.
  p->chan = chan;
    800016de:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800016e2:	4789                	li	a5,2
    800016e4:	d09c                	sw	a5,32(s1)

  sched();
    800016e6:	00000097          	auipc	ra,0x0
    800016ea:	eb8080e7          	jalr	-328(ra) # 8000159e <sched>

  // Tidy up.
  p->chan = 0;
    800016ee:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016f2:	8526                	mv	a0,s1
    800016f4:	00005097          	auipc	ra,0x5
    800016f8:	102080e7          	jalr	258(ra) # 800067f6 <release>
  acquire(lk);
    800016fc:	854a                	mv	a0,s2
    800016fe:	00005097          	auipc	ra,0x5
    80001702:	028080e7          	jalr	40(ra) # 80006726 <acquire>
}
    80001706:	70a2                	ld	ra,40(sp)
    80001708:	7402                	ld	s0,32(sp)
    8000170a:	64e2                	ld	s1,24(sp)
    8000170c:	6942                	ld	s2,16(sp)
    8000170e:	69a2                	ld	s3,8(sp)
    80001710:	6145                	addi	sp,sp,48
    80001712:	8082                	ret

0000000080001714 <wait>:
{
    80001714:	715d                	addi	sp,sp,-80
    80001716:	e486                	sd	ra,72(sp)
    80001718:	e0a2                	sd	s0,64(sp)
    8000171a:	fc26                	sd	s1,56(sp)
    8000171c:	f84a                	sd	s2,48(sp)
    8000171e:	f44e                	sd	s3,40(sp)
    80001720:	f052                	sd	s4,32(sp)
    80001722:	ec56                	sd	s5,24(sp)
    80001724:	e85a                	sd	s6,16(sp)
    80001726:	e45e                	sd	s7,8(sp)
    80001728:	e062                	sd	s8,0(sp)
    8000172a:	0880                	addi	s0,sp,80
    8000172c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000172e:	00000097          	auipc	ra,0x0
    80001732:	8be080e7          	jalr	-1858(ra) # 80000fec <myproc>
    80001736:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001738:	00008517          	auipc	a0,0x8
    8000173c:	a9850513          	addi	a0,a0,-1384 # 800091d0 <wait_lock>
    80001740:	00005097          	auipc	ra,0x5
    80001744:	fe6080e7          	jalr	-26(ra) # 80006726 <acquire>
    havekids = 0;
    80001748:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000174a:	4a15                	li	s4,5
        havekids = 1;
    8000174c:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000174e:	0000e997          	auipc	s3,0xe
    80001752:	aa298993          	addi	s3,s3,-1374 # 8000f1f0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001756:	00008c17          	auipc	s8,0x8
    8000175a:	a7ac0c13          	addi	s8,s8,-1414 # 800091d0 <wait_lock>
    havekids = 0;
    8000175e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001760:	00008497          	auipc	s1,0x8
    80001764:	e9048493          	addi	s1,s1,-368 # 800095f0 <proc>
    80001768:	a0bd                	j	800017d6 <wait+0xc2>
          pid = np->pid;
    8000176a:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000176e:	000b0e63          	beqz	s6,8000178a <wait+0x76>
    80001772:	4691                	li	a3,4
    80001774:	03448613          	addi	a2,s1,52
    80001778:	85da                	mv	a1,s6
    8000177a:	05893503          	ld	a0,88(s2)
    8000177e:	fffff097          	auipc	ra,0xfffff
    80001782:	532080e7          	jalr	1330(ra) # 80000cb0 <copyout>
    80001786:	02054563          	bltz	a0,800017b0 <wait+0x9c>
          freeproc(np);
    8000178a:	8526                	mv	a0,s1
    8000178c:	00000097          	auipc	ra,0x0
    80001790:	a12080e7          	jalr	-1518(ra) # 8000119e <freeproc>
          release(&np->lock);
    80001794:	8526                	mv	a0,s1
    80001796:	00005097          	auipc	ra,0x5
    8000179a:	060080e7          	jalr	96(ra) # 800067f6 <release>
          release(&wait_lock);
    8000179e:	00008517          	auipc	a0,0x8
    800017a2:	a3250513          	addi	a0,a0,-1486 # 800091d0 <wait_lock>
    800017a6:	00005097          	auipc	ra,0x5
    800017aa:	050080e7          	jalr	80(ra) # 800067f6 <release>
          return pid;
    800017ae:	a09d                	j	80001814 <wait+0x100>
            release(&np->lock);
    800017b0:	8526                	mv	a0,s1
    800017b2:	00005097          	auipc	ra,0x5
    800017b6:	044080e7          	jalr	68(ra) # 800067f6 <release>
            release(&wait_lock);
    800017ba:	00008517          	auipc	a0,0x8
    800017be:	a1650513          	addi	a0,a0,-1514 # 800091d0 <wait_lock>
    800017c2:	00005097          	auipc	ra,0x5
    800017c6:	034080e7          	jalr	52(ra) # 800067f6 <release>
            return -1;
    800017ca:	59fd                	li	s3,-1
    800017cc:	a0a1                	j	80001814 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017ce:	17048493          	addi	s1,s1,368
    800017d2:	03348463          	beq	s1,s3,800017fa <wait+0xe6>
      if(np->parent == p){
    800017d6:	60bc                	ld	a5,64(s1)
    800017d8:	ff279be3          	bne	a5,s2,800017ce <wait+0xba>
        acquire(&np->lock);
    800017dc:	8526                	mv	a0,s1
    800017de:	00005097          	auipc	ra,0x5
    800017e2:	f48080e7          	jalr	-184(ra) # 80006726 <acquire>
        if(np->state == ZOMBIE){
    800017e6:	509c                	lw	a5,32(s1)
    800017e8:	f94781e3          	beq	a5,s4,8000176a <wait+0x56>
        release(&np->lock);
    800017ec:	8526                	mv	a0,s1
    800017ee:	00005097          	auipc	ra,0x5
    800017f2:	008080e7          	jalr	8(ra) # 800067f6 <release>
        havekids = 1;
    800017f6:	8756                	mv	a4,s5
    800017f8:	bfd9                	j	800017ce <wait+0xba>
    if(!havekids || p->killed){
    800017fa:	c701                	beqz	a4,80001802 <wait+0xee>
    800017fc:	03092783          	lw	a5,48(s2)
    80001800:	c79d                	beqz	a5,8000182e <wait+0x11a>
      release(&wait_lock);
    80001802:	00008517          	auipc	a0,0x8
    80001806:	9ce50513          	addi	a0,a0,-1586 # 800091d0 <wait_lock>
    8000180a:	00005097          	auipc	ra,0x5
    8000180e:	fec080e7          	jalr	-20(ra) # 800067f6 <release>
      return -1;
    80001812:	59fd                	li	s3,-1
}
    80001814:	854e                	mv	a0,s3
    80001816:	60a6                	ld	ra,72(sp)
    80001818:	6406                	ld	s0,64(sp)
    8000181a:	74e2                	ld	s1,56(sp)
    8000181c:	7942                	ld	s2,48(sp)
    8000181e:	79a2                	ld	s3,40(sp)
    80001820:	7a02                	ld	s4,32(sp)
    80001822:	6ae2                	ld	s5,24(sp)
    80001824:	6b42                	ld	s6,16(sp)
    80001826:	6ba2                	ld	s7,8(sp)
    80001828:	6c02                	ld	s8,0(sp)
    8000182a:	6161                	addi	sp,sp,80
    8000182c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000182e:	85e2                	mv	a1,s8
    80001830:	854a                	mv	a0,s2
    80001832:	00000097          	auipc	ra,0x0
    80001836:	e7e080e7          	jalr	-386(ra) # 800016b0 <sleep>
    havekids = 0;
    8000183a:	b715                	j	8000175e <wait+0x4a>

000000008000183c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000183c:	7139                	addi	sp,sp,-64
    8000183e:	fc06                	sd	ra,56(sp)
    80001840:	f822                	sd	s0,48(sp)
    80001842:	f426                	sd	s1,40(sp)
    80001844:	f04a                	sd	s2,32(sp)
    80001846:	ec4e                	sd	s3,24(sp)
    80001848:	e852                	sd	s4,16(sp)
    8000184a:	e456                	sd	s5,8(sp)
    8000184c:	0080                	addi	s0,sp,64
    8000184e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001850:	00008497          	auipc	s1,0x8
    80001854:	da048493          	addi	s1,s1,-608 # 800095f0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001858:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000185a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000185c:	0000e917          	auipc	s2,0xe
    80001860:	99490913          	addi	s2,s2,-1644 # 8000f1f0 <tickslock>
    80001864:	a811                	j	80001878 <wakeup+0x3c>
      }
      release(&p->lock);
    80001866:	8526                	mv	a0,s1
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	f8e080e7          	jalr	-114(ra) # 800067f6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001870:	17048493          	addi	s1,s1,368
    80001874:	03248663          	beq	s1,s2,800018a0 <wakeup+0x64>
    if(p != myproc()){
    80001878:	fffff097          	auipc	ra,0xfffff
    8000187c:	774080e7          	jalr	1908(ra) # 80000fec <myproc>
    80001880:	fea488e3          	beq	s1,a0,80001870 <wakeup+0x34>
      acquire(&p->lock);
    80001884:	8526                	mv	a0,s1
    80001886:	00005097          	auipc	ra,0x5
    8000188a:	ea0080e7          	jalr	-352(ra) # 80006726 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000188e:	509c                	lw	a5,32(s1)
    80001890:	fd379be3          	bne	a5,s3,80001866 <wakeup+0x2a>
    80001894:	749c                	ld	a5,40(s1)
    80001896:	fd4798e3          	bne	a5,s4,80001866 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000189a:	0354a023          	sw	s5,32(s1)
    8000189e:	b7e1                	j	80001866 <wakeup+0x2a>
    }
  }
}
    800018a0:	70e2                	ld	ra,56(sp)
    800018a2:	7442                	ld	s0,48(sp)
    800018a4:	74a2                	ld	s1,40(sp)
    800018a6:	7902                	ld	s2,32(sp)
    800018a8:	69e2                	ld	s3,24(sp)
    800018aa:	6a42                	ld	s4,16(sp)
    800018ac:	6aa2                	ld	s5,8(sp)
    800018ae:	6121                	addi	sp,sp,64
    800018b0:	8082                	ret

00000000800018b2 <reparent>:
{
    800018b2:	7179                	addi	sp,sp,-48
    800018b4:	f406                	sd	ra,40(sp)
    800018b6:	f022                	sd	s0,32(sp)
    800018b8:	ec26                	sd	s1,24(sp)
    800018ba:	e84a                	sd	s2,16(sp)
    800018bc:	e44e                	sd	s3,8(sp)
    800018be:	e052                	sd	s4,0(sp)
    800018c0:	1800                	addi	s0,sp,48
    800018c2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018c4:	00008497          	auipc	s1,0x8
    800018c8:	d2c48493          	addi	s1,s1,-724 # 800095f0 <proc>
      pp->parent = initproc;
    800018cc:	00007a17          	auipc	s4,0x7
    800018d0:	744a0a13          	addi	s4,s4,1860 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018d4:	0000e997          	auipc	s3,0xe
    800018d8:	91c98993          	addi	s3,s3,-1764 # 8000f1f0 <tickslock>
    800018dc:	a029                	j	800018e6 <reparent+0x34>
    800018de:	17048493          	addi	s1,s1,368
    800018e2:	01348d63          	beq	s1,s3,800018fc <reparent+0x4a>
    if(pp->parent == p){
    800018e6:	60bc                	ld	a5,64(s1)
    800018e8:	ff279be3          	bne	a5,s2,800018de <reparent+0x2c>
      pp->parent = initproc;
    800018ec:	000a3503          	ld	a0,0(s4)
    800018f0:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    800018f2:	00000097          	auipc	ra,0x0
    800018f6:	f4a080e7          	jalr	-182(ra) # 8000183c <wakeup>
    800018fa:	b7d5                	j	800018de <reparent+0x2c>
}
    800018fc:	70a2                	ld	ra,40(sp)
    800018fe:	7402                	ld	s0,32(sp)
    80001900:	64e2                	ld	s1,24(sp)
    80001902:	6942                	ld	s2,16(sp)
    80001904:	69a2                	ld	s3,8(sp)
    80001906:	6a02                	ld	s4,0(sp)
    80001908:	6145                	addi	sp,sp,48
    8000190a:	8082                	ret

000000008000190c <exit>:
{
    8000190c:	7179                	addi	sp,sp,-48
    8000190e:	f406                	sd	ra,40(sp)
    80001910:	f022                	sd	s0,32(sp)
    80001912:	ec26                	sd	s1,24(sp)
    80001914:	e84a                	sd	s2,16(sp)
    80001916:	e44e                	sd	s3,8(sp)
    80001918:	e052                	sd	s4,0(sp)
    8000191a:	1800                	addi	s0,sp,48
    8000191c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000191e:	fffff097          	auipc	ra,0xfffff
    80001922:	6ce080e7          	jalr	1742(ra) # 80000fec <myproc>
    80001926:	89aa                	mv	s3,a0
  if(p == initproc)
    80001928:	00007797          	auipc	a5,0x7
    8000192c:	6e87b783          	ld	a5,1768(a5) # 80009010 <initproc>
    80001930:	0d850493          	addi	s1,a0,216
    80001934:	15850913          	addi	s2,a0,344
    80001938:	02a79363          	bne	a5,a0,8000195e <exit+0x52>
    panic("init exiting");
    8000193c:	00007517          	auipc	a0,0x7
    80001940:	8ac50513          	addi	a0,a0,-1876 # 800081e8 <etext+0x1e8>
    80001944:	00005097          	auipc	ra,0x5
    80001948:	8c0080e7          	jalr	-1856(ra) # 80006204 <panic>
      fileclose(f);
    8000194c:	00002097          	auipc	ra,0x2
    80001950:	3ae080e7          	jalr	942(ra) # 80003cfa <fileclose>
      p->ofile[fd] = 0;
    80001954:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001958:	04a1                	addi	s1,s1,8
    8000195a:	01248563          	beq	s1,s2,80001964 <exit+0x58>
    if(p->ofile[fd]){
    8000195e:	6088                	ld	a0,0(s1)
    80001960:	f575                	bnez	a0,8000194c <exit+0x40>
    80001962:	bfdd                	j	80001958 <exit+0x4c>
  begin_op();
    80001964:	00002097          	auipc	ra,0x2
    80001968:	ece080e7          	jalr	-306(ra) # 80003832 <begin_op>
  iput(p->cwd);
    8000196c:	1589b503          	ld	a0,344(s3)
    80001970:	00001097          	auipc	ra,0x1
    80001974:	6a0080e7          	jalr	1696(ra) # 80003010 <iput>
  end_op();
    80001978:	00002097          	auipc	ra,0x2
    8000197c:	f38080e7          	jalr	-200(ra) # 800038b0 <end_op>
  p->cwd = 0;
    80001980:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001984:	00008497          	auipc	s1,0x8
    80001988:	84c48493          	addi	s1,s1,-1972 # 800091d0 <wait_lock>
    8000198c:	8526                	mv	a0,s1
    8000198e:	00005097          	auipc	ra,0x5
    80001992:	d98080e7          	jalr	-616(ra) # 80006726 <acquire>
  reparent(p);
    80001996:	854e                	mv	a0,s3
    80001998:	00000097          	auipc	ra,0x0
    8000199c:	f1a080e7          	jalr	-230(ra) # 800018b2 <reparent>
  wakeup(p->parent);
    800019a0:	0409b503          	ld	a0,64(s3)
    800019a4:	00000097          	auipc	ra,0x0
    800019a8:	e98080e7          	jalr	-360(ra) # 8000183c <wakeup>
  acquire(&p->lock);
    800019ac:	854e                	mv	a0,s3
    800019ae:	00005097          	auipc	ra,0x5
    800019b2:	d78080e7          	jalr	-648(ra) # 80006726 <acquire>
  p->xstate = status;
    800019b6:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800019ba:	4795                	li	a5,5
    800019bc:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    800019c0:	8526                	mv	a0,s1
    800019c2:	00005097          	auipc	ra,0x5
    800019c6:	e34080e7          	jalr	-460(ra) # 800067f6 <release>
  sched();
    800019ca:	00000097          	auipc	ra,0x0
    800019ce:	bd4080e7          	jalr	-1068(ra) # 8000159e <sched>
  panic("zombie exit");
    800019d2:	00007517          	auipc	a0,0x7
    800019d6:	82650513          	addi	a0,a0,-2010 # 800081f8 <etext+0x1f8>
    800019da:	00005097          	auipc	ra,0x5
    800019de:	82a080e7          	jalr	-2006(ra) # 80006204 <panic>

00000000800019e2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019e2:	7179                	addi	sp,sp,-48
    800019e4:	f406                	sd	ra,40(sp)
    800019e6:	f022                	sd	s0,32(sp)
    800019e8:	ec26                	sd	s1,24(sp)
    800019ea:	e84a                	sd	s2,16(sp)
    800019ec:	e44e                	sd	s3,8(sp)
    800019ee:	1800                	addi	s0,sp,48
    800019f0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019f2:	00008497          	auipc	s1,0x8
    800019f6:	bfe48493          	addi	s1,s1,-1026 # 800095f0 <proc>
    800019fa:	0000d997          	auipc	s3,0xd
    800019fe:	7f698993          	addi	s3,s3,2038 # 8000f1f0 <tickslock>
    acquire(&p->lock);
    80001a02:	8526                	mv	a0,s1
    80001a04:	00005097          	auipc	ra,0x5
    80001a08:	d22080e7          	jalr	-734(ra) # 80006726 <acquire>
    if(p->pid == pid){
    80001a0c:	5c9c                	lw	a5,56(s1)
    80001a0e:	01278d63          	beq	a5,s2,80001a28 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a12:	8526                	mv	a0,s1
    80001a14:	00005097          	auipc	ra,0x5
    80001a18:	de2080e7          	jalr	-542(ra) # 800067f6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a1c:	17048493          	addi	s1,s1,368
    80001a20:	ff3491e3          	bne	s1,s3,80001a02 <kill+0x20>
  }
  return -1;
    80001a24:	557d                	li	a0,-1
    80001a26:	a829                	j	80001a40 <kill+0x5e>
      p->killed = 1;
    80001a28:	4785                	li	a5,1
    80001a2a:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80001a2c:	5098                	lw	a4,32(s1)
    80001a2e:	4789                	li	a5,2
    80001a30:	00f70f63          	beq	a4,a5,80001a4e <kill+0x6c>
      release(&p->lock);
    80001a34:	8526                	mv	a0,s1
    80001a36:	00005097          	auipc	ra,0x5
    80001a3a:	dc0080e7          	jalr	-576(ra) # 800067f6 <release>
      return 0;
    80001a3e:	4501                	li	a0,0
}
    80001a40:	70a2                	ld	ra,40(sp)
    80001a42:	7402                	ld	s0,32(sp)
    80001a44:	64e2                	ld	s1,24(sp)
    80001a46:	6942                	ld	s2,16(sp)
    80001a48:	69a2                	ld	s3,8(sp)
    80001a4a:	6145                	addi	sp,sp,48
    80001a4c:	8082                	ret
        p->state = RUNNABLE;
    80001a4e:	478d                	li	a5,3
    80001a50:	d09c                	sw	a5,32(s1)
    80001a52:	b7cd                	j	80001a34 <kill+0x52>

0000000080001a54 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a54:	7179                	addi	sp,sp,-48
    80001a56:	f406                	sd	ra,40(sp)
    80001a58:	f022                	sd	s0,32(sp)
    80001a5a:	ec26                	sd	s1,24(sp)
    80001a5c:	e84a                	sd	s2,16(sp)
    80001a5e:	e44e                	sd	s3,8(sp)
    80001a60:	e052                	sd	s4,0(sp)
    80001a62:	1800                	addi	s0,sp,48
    80001a64:	84aa                	mv	s1,a0
    80001a66:	892e                	mv	s2,a1
    80001a68:	89b2                	mv	s3,a2
    80001a6a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a6c:	fffff097          	auipc	ra,0xfffff
    80001a70:	580080e7          	jalr	1408(ra) # 80000fec <myproc>
  if(user_dst){
    80001a74:	c08d                	beqz	s1,80001a96 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a76:	86d2                	mv	a3,s4
    80001a78:	864e                	mv	a2,s3
    80001a7a:	85ca                	mv	a1,s2
    80001a7c:	6d28                	ld	a0,88(a0)
    80001a7e:	fffff097          	auipc	ra,0xfffff
    80001a82:	232080e7          	jalr	562(ra) # 80000cb0 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a86:	70a2                	ld	ra,40(sp)
    80001a88:	7402                	ld	s0,32(sp)
    80001a8a:	64e2                	ld	s1,24(sp)
    80001a8c:	6942                	ld	s2,16(sp)
    80001a8e:	69a2                	ld	s3,8(sp)
    80001a90:	6a02                	ld	s4,0(sp)
    80001a92:	6145                	addi	sp,sp,48
    80001a94:	8082                	ret
    memmove((char *)dst, src, len);
    80001a96:	000a061b          	sext.w	a2,s4
    80001a9a:	85ce                	mv	a1,s3
    80001a9c:	854a                	mv	a0,s2
    80001a9e:	fffff097          	auipc	ra,0xfffff
    80001aa2:	8d0080e7          	jalr	-1840(ra) # 8000036e <memmove>
    return 0;
    80001aa6:	8526                	mv	a0,s1
    80001aa8:	bff9                	j	80001a86 <either_copyout+0x32>

0000000080001aaa <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001aaa:	7179                	addi	sp,sp,-48
    80001aac:	f406                	sd	ra,40(sp)
    80001aae:	f022                	sd	s0,32(sp)
    80001ab0:	ec26                	sd	s1,24(sp)
    80001ab2:	e84a                	sd	s2,16(sp)
    80001ab4:	e44e                	sd	s3,8(sp)
    80001ab6:	e052                	sd	s4,0(sp)
    80001ab8:	1800                	addi	s0,sp,48
    80001aba:	892a                	mv	s2,a0
    80001abc:	84ae                	mv	s1,a1
    80001abe:	89b2                	mv	s3,a2
    80001ac0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ac2:	fffff097          	auipc	ra,0xfffff
    80001ac6:	52a080e7          	jalr	1322(ra) # 80000fec <myproc>
  if(user_src){
    80001aca:	c08d                	beqz	s1,80001aec <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001acc:	86d2                	mv	a3,s4
    80001ace:	864e                	mv	a2,s3
    80001ad0:	85ca                	mv	a1,s2
    80001ad2:	6d28                	ld	a0,88(a0)
    80001ad4:	fffff097          	auipc	ra,0xfffff
    80001ad8:	268080e7          	jalr	616(ra) # 80000d3c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001adc:	70a2                	ld	ra,40(sp)
    80001ade:	7402                	ld	s0,32(sp)
    80001ae0:	64e2                	ld	s1,24(sp)
    80001ae2:	6942                	ld	s2,16(sp)
    80001ae4:	69a2                	ld	s3,8(sp)
    80001ae6:	6a02                	ld	s4,0(sp)
    80001ae8:	6145                	addi	sp,sp,48
    80001aea:	8082                	ret
    memmove(dst, (char*)src, len);
    80001aec:	000a061b          	sext.w	a2,s4
    80001af0:	85ce                	mv	a1,s3
    80001af2:	854a                	mv	a0,s2
    80001af4:	fffff097          	auipc	ra,0xfffff
    80001af8:	87a080e7          	jalr	-1926(ra) # 8000036e <memmove>
    return 0;
    80001afc:	8526                	mv	a0,s1
    80001afe:	bff9                	j	80001adc <either_copyin+0x32>

0000000080001b00 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b00:	715d                	addi	sp,sp,-80
    80001b02:	e486                	sd	ra,72(sp)
    80001b04:	e0a2                	sd	s0,64(sp)
    80001b06:	fc26                	sd	s1,56(sp)
    80001b08:	f84a                	sd	s2,48(sp)
    80001b0a:	f44e                	sd	s3,40(sp)
    80001b0c:	f052                	sd	s4,32(sp)
    80001b0e:	ec56                	sd	s5,24(sp)
    80001b10:	e85a                	sd	s6,16(sp)
    80001b12:	e45e                	sd	s7,8(sp)
    80001b14:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b16:	00007517          	auipc	a0,0x7
    80001b1a:	d7a50513          	addi	a0,a0,-646 # 80008890 <digits+0x88>
    80001b1e:	00004097          	auipc	ra,0x4
    80001b22:	730080e7          	jalr	1840(ra) # 8000624e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b26:	00008497          	auipc	s1,0x8
    80001b2a:	c2a48493          	addi	s1,s1,-982 # 80009750 <proc+0x160>
    80001b2e:	0000e917          	auipc	s2,0xe
    80001b32:	82290913          	addi	s2,s2,-2014 # 8000f350 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b36:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b38:	00006997          	auipc	s3,0x6
    80001b3c:	6d098993          	addi	s3,s3,1744 # 80008208 <etext+0x208>
    printf("%d %s %s", p->pid, state, p->name);
    80001b40:	00006a97          	auipc	s5,0x6
    80001b44:	6d0a8a93          	addi	s5,s5,1744 # 80008210 <etext+0x210>
    printf("\n");
    80001b48:	00007a17          	auipc	s4,0x7
    80001b4c:	d48a0a13          	addi	s4,s4,-696 # 80008890 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b50:	00006b97          	auipc	s7,0x6
    80001b54:	6f8b8b93          	addi	s7,s7,1784 # 80008248 <states.0>
    80001b58:	a00d                	j	80001b7a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b5a:	ed86a583          	lw	a1,-296(a3)
    80001b5e:	8556                	mv	a0,s5
    80001b60:	00004097          	auipc	ra,0x4
    80001b64:	6ee080e7          	jalr	1774(ra) # 8000624e <printf>
    printf("\n");
    80001b68:	8552                	mv	a0,s4
    80001b6a:	00004097          	auipc	ra,0x4
    80001b6e:	6e4080e7          	jalr	1764(ra) # 8000624e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b72:	17048493          	addi	s1,s1,368
    80001b76:	03248263          	beq	s1,s2,80001b9a <procdump+0x9a>
    if(p->state == UNUSED)
    80001b7a:	86a6                	mv	a3,s1
    80001b7c:	ec04a783          	lw	a5,-320(s1)
    80001b80:	dbed                	beqz	a5,80001b72 <procdump+0x72>
      state = "???";
    80001b82:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b84:	fcfb6be3          	bltu	s6,a5,80001b5a <procdump+0x5a>
    80001b88:	02079713          	slli	a4,a5,0x20
    80001b8c:	01d75793          	srli	a5,a4,0x1d
    80001b90:	97de                	add	a5,a5,s7
    80001b92:	6390                	ld	a2,0(a5)
    80001b94:	f279                	bnez	a2,80001b5a <procdump+0x5a>
      state = "???";
    80001b96:	864e                	mv	a2,s3
    80001b98:	b7c9                	j	80001b5a <procdump+0x5a>
  }
}
    80001b9a:	60a6                	ld	ra,72(sp)
    80001b9c:	6406                	ld	s0,64(sp)
    80001b9e:	74e2                	ld	s1,56(sp)
    80001ba0:	7942                	ld	s2,48(sp)
    80001ba2:	79a2                	ld	s3,40(sp)
    80001ba4:	7a02                	ld	s4,32(sp)
    80001ba6:	6ae2                	ld	s5,24(sp)
    80001ba8:	6b42                	ld	s6,16(sp)
    80001baa:	6ba2                	ld	s7,8(sp)
    80001bac:	6161                	addi	sp,sp,80
    80001bae:	8082                	ret

0000000080001bb0 <swtch>:
    80001bb0:	00153023          	sd	ra,0(a0)
    80001bb4:	00253423          	sd	sp,8(a0)
    80001bb8:	e900                	sd	s0,16(a0)
    80001bba:	ed04                	sd	s1,24(a0)
    80001bbc:	03253023          	sd	s2,32(a0)
    80001bc0:	03353423          	sd	s3,40(a0)
    80001bc4:	03453823          	sd	s4,48(a0)
    80001bc8:	03553c23          	sd	s5,56(a0)
    80001bcc:	05653023          	sd	s6,64(a0)
    80001bd0:	05753423          	sd	s7,72(a0)
    80001bd4:	05853823          	sd	s8,80(a0)
    80001bd8:	05953c23          	sd	s9,88(a0)
    80001bdc:	07a53023          	sd	s10,96(a0)
    80001be0:	07b53423          	sd	s11,104(a0)
    80001be4:	0005b083          	ld	ra,0(a1)
    80001be8:	0085b103          	ld	sp,8(a1)
    80001bec:	6980                	ld	s0,16(a1)
    80001bee:	6d84                	ld	s1,24(a1)
    80001bf0:	0205b903          	ld	s2,32(a1)
    80001bf4:	0285b983          	ld	s3,40(a1)
    80001bf8:	0305ba03          	ld	s4,48(a1)
    80001bfc:	0385ba83          	ld	s5,56(a1)
    80001c00:	0405bb03          	ld	s6,64(a1)
    80001c04:	0485bb83          	ld	s7,72(a1)
    80001c08:	0505bc03          	ld	s8,80(a1)
    80001c0c:	0585bc83          	ld	s9,88(a1)
    80001c10:	0605bd03          	ld	s10,96(a1)
    80001c14:	0685bd83          	ld	s11,104(a1)
    80001c18:	8082                	ret

0000000080001c1a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c1a:	1141                	addi	sp,sp,-16
    80001c1c:	e406                	sd	ra,8(sp)
    80001c1e:	e022                	sd	s0,0(sp)
    80001c20:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c22:	00006597          	auipc	a1,0x6
    80001c26:	65658593          	addi	a1,a1,1622 # 80008278 <states.0+0x30>
    80001c2a:	0000d517          	auipc	a0,0xd
    80001c2e:	5c650513          	addi	a0,a0,1478 # 8000f1f0 <tickslock>
    80001c32:	00005097          	auipc	ra,0x5
    80001c36:	c70080e7          	jalr	-912(ra) # 800068a2 <initlock>
}
    80001c3a:	60a2                	ld	ra,8(sp)
    80001c3c:	6402                	ld	s0,0(sp)
    80001c3e:	0141                	addi	sp,sp,16
    80001c40:	8082                	ret

0000000080001c42 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c42:	1141                	addi	sp,sp,-16
    80001c44:	e422                	sd	s0,8(sp)
    80001c46:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c48:	00003797          	auipc	a5,0x3
    80001c4c:	6e878793          	addi	a5,a5,1768 # 80005330 <kernelvec>
    80001c50:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c54:	6422                	ld	s0,8(sp)
    80001c56:	0141                	addi	sp,sp,16
    80001c58:	8082                	ret

0000000080001c5a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c5a:	1141                	addi	sp,sp,-16
    80001c5c:	e406                	sd	ra,8(sp)
    80001c5e:	e022                	sd	s0,0(sp)
    80001c60:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c62:	fffff097          	auipc	ra,0xfffff
    80001c66:	38a080e7          	jalr	906(ra) # 80000fec <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c6a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c6e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c70:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c74:	00005697          	auipc	a3,0x5
    80001c78:	38c68693          	addi	a3,a3,908 # 80007000 <_trampoline>
    80001c7c:	00005717          	auipc	a4,0x5
    80001c80:	38470713          	addi	a4,a4,900 # 80007000 <_trampoline>
    80001c84:	8f15                	sub	a4,a4,a3
    80001c86:	040007b7          	lui	a5,0x4000
    80001c8a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c8c:	07b2                	slli	a5,a5,0xc
    80001c8e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c90:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c94:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c96:	18002673          	csrr	a2,satp
    80001c9a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c9c:	7130                	ld	a2,96(a0)
    80001c9e:	6538                	ld	a4,72(a0)
    80001ca0:	6585                	lui	a1,0x1
    80001ca2:	972e                	add	a4,a4,a1
    80001ca4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001ca6:	7138                	ld	a4,96(a0)
    80001ca8:	00000617          	auipc	a2,0x0
    80001cac:	13860613          	addi	a2,a2,312 # 80001de0 <usertrap>
    80001cb0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cb2:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cb4:	8612                	mv	a2,tp
    80001cb6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cb8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cbc:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cc0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cc4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cc8:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cca:	6f18                	ld	a4,24(a4)
    80001ccc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cd0:	6d2c                	ld	a1,88(a0)
    80001cd2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cd4:	00005717          	auipc	a4,0x5
    80001cd8:	3bc70713          	addi	a4,a4,956 # 80007090 <userret>
    80001cdc:	8f15                	sub	a4,a4,a3
    80001cde:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001ce0:	577d                	li	a4,-1
    80001ce2:	177e                	slli	a4,a4,0x3f
    80001ce4:	8dd9                	or	a1,a1,a4
    80001ce6:	02000537          	lui	a0,0x2000
    80001cea:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001cec:	0536                	slli	a0,a0,0xd
    80001cee:	9782                	jalr	a5
}
    80001cf0:	60a2                	ld	ra,8(sp)
    80001cf2:	6402                	ld	s0,0(sp)
    80001cf4:	0141                	addi	sp,sp,16
    80001cf6:	8082                	ret

0000000080001cf8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001cf8:	1101                	addi	sp,sp,-32
    80001cfa:	ec06                	sd	ra,24(sp)
    80001cfc:	e822                	sd	s0,16(sp)
    80001cfe:	e426                	sd	s1,8(sp)
    80001d00:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d02:	0000d497          	auipc	s1,0xd
    80001d06:	4ee48493          	addi	s1,s1,1262 # 8000f1f0 <tickslock>
    80001d0a:	8526                	mv	a0,s1
    80001d0c:	00005097          	auipc	ra,0x5
    80001d10:	a1a080e7          	jalr	-1510(ra) # 80006726 <acquire>
  ticks++;
    80001d14:	00007517          	auipc	a0,0x7
    80001d18:	30450513          	addi	a0,a0,772 # 80009018 <ticks>
    80001d1c:	411c                	lw	a5,0(a0)
    80001d1e:	2785                	addiw	a5,a5,1
    80001d20:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	b1a080e7          	jalr	-1254(ra) # 8000183c <wakeup>
  release(&tickslock);
    80001d2a:	8526                	mv	a0,s1
    80001d2c:	00005097          	auipc	ra,0x5
    80001d30:	aca080e7          	jalr	-1334(ra) # 800067f6 <release>
}
    80001d34:	60e2                	ld	ra,24(sp)
    80001d36:	6442                	ld	s0,16(sp)
    80001d38:	64a2                	ld	s1,8(sp)
    80001d3a:	6105                	addi	sp,sp,32
    80001d3c:	8082                	ret

0000000080001d3e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d3e:	1101                	addi	sp,sp,-32
    80001d40:	ec06                	sd	ra,24(sp)
    80001d42:	e822                	sd	s0,16(sp)
    80001d44:	e426                	sd	s1,8(sp)
    80001d46:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d48:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d4c:	00074d63          	bltz	a4,80001d66 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d50:	57fd                	li	a5,-1
    80001d52:	17fe                	slli	a5,a5,0x3f
    80001d54:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d56:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d58:	06f70363          	beq	a4,a5,80001dbe <devintr+0x80>
  }
}
    80001d5c:	60e2                	ld	ra,24(sp)
    80001d5e:	6442                	ld	s0,16(sp)
    80001d60:	64a2                	ld	s1,8(sp)
    80001d62:	6105                	addi	sp,sp,32
    80001d64:	8082                	ret
     (scause & 0xff) == 9){
    80001d66:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001d6a:	46a5                	li	a3,9
    80001d6c:	fed792e3          	bne	a5,a3,80001d50 <devintr+0x12>
    int irq = plic_claim();
    80001d70:	00003097          	auipc	ra,0x3
    80001d74:	6c8080e7          	jalr	1736(ra) # 80005438 <plic_claim>
    80001d78:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d7a:	47a9                	li	a5,10
    80001d7c:	02f50763          	beq	a0,a5,80001daa <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d80:	4785                	li	a5,1
    80001d82:	02f50963          	beq	a0,a5,80001db4 <devintr+0x76>
    return 1;
    80001d86:	4505                	li	a0,1
    } else if(irq){
    80001d88:	d8f1                	beqz	s1,80001d5c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d8a:	85a6                	mv	a1,s1
    80001d8c:	00006517          	auipc	a0,0x6
    80001d90:	4f450513          	addi	a0,a0,1268 # 80008280 <states.0+0x38>
    80001d94:	00004097          	auipc	ra,0x4
    80001d98:	4ba080e7          	jalr	1210(ra) # 8000624e <printf>
      plic_complete(irq);
    80001d9c:	8526                	mv	a0,s1
    80001d9e:	00003097          	auipc	ra,0x3
    80001da2:	6be080e7          	jalr	1726(ra) # 8000545c <plic_complete>
    return 1;
    80001da6:	4505                	li	a0,1
    80001da8:	bf55                	j	80001d5c <devintr+0x1e>
      uartintr();
    80001daa:	00005097          	auipc	ra,0x5
    80001dae:	8b2080e7          	jalr	-1870(ra) # 8000665c <uartintr>
    80001db2:	b7ed                	j	80001d9c <devintr+0x5e>
      virtio_disk_intr();
    80001db4:	00004097          	auipc	ra,0x4
    80001db8:	b34080e7          	jalr	-1228(ra) # 800058e8 <virtio_disk_intr>
    80001dbc:	b7c5                	j	80001d9c <devintr+0x5e>
    if(cpuid() == 0){
    80001dbe:	fffff097          	auipc	ra,0xfffff
    80001dc2:	202080e7          	jalr	514(ra) # 80000fc0 <cpuid>
    80001dc6:	c901                	beqz	a0,80001dd6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dc8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001dcc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001dce:	14479073          	csrw	sip,a5
    return 2;
    80001dd2:	4509                	li	a0,2
    80001dd4:	b761                	j	80001d5c <devintr+0x1e>
      clockintr();
    80001dd6:	00000097          	auipc	ra,0x0
    80001dda:	f22080e7          	jalr	-222(ra) # 80001cf8 <clockintr>
    80001dde:	b7ed                	j	80001dc8 <devintr+0x8a>

0000000080001de0 <usertrap>:
{
    80001de0:	1101                	addi	sp,sp,-32
    80001de2:	ec06                	sd	ra,24(sp)
    80001de4:	e822                	sd	s0,16(sp)
    80001de6:	e426                	sd	s1,8(sp)
    80001de8:	e04a                	sd	s2,0(sp)
    80001dea:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dec:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001df0:	1007f793          	andi	a5,a5,256
    80001df4:	e3ad                	bnez	a5,80001e56 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001df6:	00003797          	auipc	a5,0x3
    80001dfa:	53a78793          	addi	a5,a5,1338 # 80005330 <kernelvec>
    80001dfe:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e02:	fffff097          	auipc	ra,0xfffff
    80001e06:	1ea080e7          	jalr	490(ra) # 80000fec <myproc>
    80001e0a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e0c:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e0e:	14102773          	csrr	a4,sepc
    80001e12:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e14:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e18:	47a1                	li	a5,8
    80001e1a:	04f71c63          	bne	a4,a5,80001e72 <usertrap+0x92>
    if(p->killed)
    80001e1e:	591c                	lw	a5,48(a0)
    80001e20:	e3b9                	bnez	a5,80001e66 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e22:	70b8                	ld	a4,96(s1)
    80001e24:	6f1c                	ld	a5,24(a4)
    80001e26:	0791                	addi	a5,a5,4
    80001e28:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e2a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e2e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e32:	10079073          	csrw	sstatus,a5
    syscall();
    80001e36:	00000097          	auipc	ra,0x0
    80001e3a:	2e0080e7          	jalr	736(ra) # 80002116 <syscall>
  if(p->killed)
    80001e3e:	589c                	lw	a5,48(s1)
    80001e40:	ebc1                	bnez	a5,80001ed0 <usertrap+0xf0>
  usertrapret();
    80001e42:	00000097          	auipc	ra,0x0
    80001e46:	e18080e7          	jalr	-488(ra) # 80001c5a <usertrapret>
}
    80001e4a:	60e2                	ld	ra,24(sp)
    80001e4c:	6442                	ld	s0,16(sp)
    80001e4e:	64a2                	ld	s1,8(sp)
    80001e50:	6902                	ld	s2,0(sp)
    80001e52:	6105                	addi	sp,sp,32
    80001e54:	8082                	ret
    panic("usertrap: not from user mode");
    80001e56:	00006517          	auipc	a0,0x6
    80001e5a:	44a50513          	addi	a0,a0,1098 # 800082a0 <states.0+0x58>
    80001e5e:	00004097          	auipc	ra,0x4
    80001e62:	3a6080e7          	jalr	934(ra) # 80006204 <panic>
      exit(-1);
    80001e66:	557d                	li	a0,-1
    80001e68:	00000097          	auipc	ra,0x0
    80001e6c:	aa4080e7          	jalr	-1372(ra) # 8000190c <exit>
    80001e70:	bf4d                	j	80001e22 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e72:	00000097          	auipc	ra,0x0
    80001e76:	ecc080e7          	jalr	-308(ra) # 80001d3e <devintr>
    80001e7a:	892a                	mv	s2,a0
    80001e7c:	c501                	beqz	a0,80001e84 <usertrap+0xa4>
  if(p->killed)
    80001e7e:	589c                	lw	a5,48(s1)
    80001e80:	c3a1                	beqz	a5,80001ec0 <usertrap+0xe0>
    80001e82:	a815                	j	80001eb6 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e84:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e88:	5c90                	lw	a2,56(s1)
    80001e8a:	00006517          	auipc	a0,0x6
    80001e8e:	43650513          	addi	a0,a0,1078 # 800082c0 <states.0+0x78>
    80001e92:	00004097          	auipc	ra,0x4
    80001e96:	3bc080e7          	jalr	956(ra) # 8000624e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e9a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e9e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ea2:	00006517          	auipc	a0,0x6
    80001ea6:	44e50513          	addi	a0,a0,1102 # 800082f0 <states.0+0xa8>
    80001eaa:	00004097          	auipc	ra,0x4
    80001eae:	3a4080e7          	jalr	932(ra) # 8000624e <printf>
    p->killed = 1;
    80001eb2:	4785                	li	a5,1
    80001eb4:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001eb6:	557d                	li	a0,-1
    80001eb8:	00000097          	auipc	ra,0x0
    80001ebc:	a54080e7          	jalr	-1452(ra) # 8000190c <exit>
  if(which_dev == 2)
    80001ec0:	4789                	li	a5,2
    80001ec2:	f8f910e3          	bne	s2,a5,80001e42 <usertrap+0x62>
    yield();
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	7ae080e7          	jalr	1966(ra) # 80001674 <yield>
    80001ece:	bf95                	j	80001e42 <usertrap+0x62>
  int which_dev = 0;
    80001ed0:	4901                	li	s2,0
    80001ed2:	b7d5                	j	80001eb6 <usertrap+0xd6>

0000000080001ed4 <kerneltrap>:
{
    80001ed4:	7179                	addi	sp,sp,-48
    80001ed6:	f406                	sd	ra,40(sp)
    80001ed8:	f022                	sd	s0,32(sp)
    80001eda:	ec26                	sd	s1,24(sp)
    80001edc:	e84a                	sd	s2,16(sp)
    80001ede:	e44e                	sd	s3,8(sp)
    80001ee0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ee2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ee6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eea:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001eee:	1004f793          	andi	a5,s1,256
    80001ef2:	cb85                	beqz	a5,80001f22 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ef4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ef8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001efa:	ef85                	bnez	a5,80001f32 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001efc:	00000097          	auipc	ra,0x0
    80001f00:	e42080e7          	jalr	-446(ra) # 80001d3e <devintr>
    80001f04:	cd1d                	beqz	a0,80001f42 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f06:	4789                	li	a5,2
    80001f08:	06f50a63          	beq	a0,a5,80001f7c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f0c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f10:	10049073          	csrw	sstatus,s1
}
    80001f14:	70a2                	ld	ra,40(sp)
    80001f16:	7402                	ld	s0,32(sp)
    80001f18:	64e2                	ld	s1,24(sp)
    80001f1a:	6942                	ld	s2,16(sp)
    80001f1c:	69a2                	ld	s3,8(sp)
    80001f1e:	6145                	addi	sp,sp,48
    80001f20:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f22:	00006517          	auipc	a0,0x6
    80001f26:	3ee50513          	addi	a0,a0,1006 # 80008310 <states.0+0xc8>
    80001f2a:	00004097          	auipc	ra,0x4
    80001f2e:	2da080e7          	jalr	730(ra) # 80006204 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f32:	00006517          	auipc	a0,0x6
    80001f36:	40650513          	addi	a0,a0,1030 # 80008338 <states.0+0xf0>
    80001f3a:	00004097          	auipc	ra,0x4
    80001f3e:	2ca080e7          	jalr	714(ra) # 80006204 <panic>
    printf("scause %p\n", scause);
    80001f42:	85ce                	mv	a1,s3
    80001f44:	00006517          	auipc	a0,0x6
    80001f48:	41450513          	addi	a0,a0,1044 # 80008358 <states.0+0x110>
    80001f4c:	00004097          	auipc	ra,0x4
    80001f50:	302080e7          	jalr	770(ra) # 8000624e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f54:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f58:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f5c:	00006517          	auipc	a0,0x6
    80001f60:	40c50513          	addi	a0,a0,1036 # 80008368 <states.0+0x120>
    80001f64:	00004097          	auipc	ra,0x4
    80001f68:	2ea080e7          	jalr	746(ra) # 8000624e <printf>
    panic("kerneltrap");
    80001f6c:	00006517          	auipc	a0,0x6
    80001f70:	41450513          	addi	a0,a0,1044 # 80008380 <states.0+0x138>
    80001f74:	00004097          	auipc	ra,0x4
    80001f78:	290080e7          	jalr	656(ra) # 80006204 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f7c:	fffff097          	auipc	ra,0xfffff
    80001f80:	070080e7          	jalr	112(ra) # 80000fec <myproc>
    80001f84:	d541                	beqz	a0,80001f0c <kerneltrap+0x38>
    80001f86:	fffff097          	auipc	ra,0xfffff
    80001f8a:	066080e7          	jalr	102(ra) # 80000fec <myproc>
    80001f8e:	5118                	lw	a4,32(a0)
    80001f90:	4791                	li	a5,4
    80001f92:	f6f71de3          	bne	a4,a5,80001f0c <kerneltrap+0x38>
    yield();
    80001f96:	fffff097          	auipc	ra,0xfffff
    80001f9a:	6de080e7          	jalr	1758(ra) # 80001674 <yield>
    80001f9e:	b7bd                	j	80001f0c <kerneltrap+0x38>

0000000080001fa0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fa0:	1101                	addi	sp,sp,-32
    80001fa2:	ec06                	sd	ra,24(sp)
    80001fa4:	e822                	sd	s0,16(sp)
    80001fa6:	e426                	sd	s1,8(sp)
    80001fa8:	1000                	addi	s0,sp,32
    80001faa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	040080e7          	jalr	64(ra) # 80000fec <myproc>
  switch (n) {
    80001fb4:	4795                	li	a5,5
    80001fb6:	0497e163          	bltu	a5,s1,80001ff8 <argraw+0x58>
    80001fba:	048a                	slli	s1,s1,0x2
    80001fbc:	00006717          	auipc	a4,0x6
    80001fc0:	3fc70713          	addi	a4,a4,1020 # 800083b8 <states.0+0x170>
    80001fc4:	94ba                	add	s1,s1,a4
    80001fc6:	409c                	lw	a5,0(s1)
    80001fc8:	97ba                	add	a5,a5,a4
    80001fca:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fcc:	713c                	ld	a5,96(a0)
    80001fce:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fd0:	60e2                	ld	ra,24(sp)
    80001fd2:	6442                	ld	s0,16(sp)
    80001fd4:	64a2                	ld	s1,8(sp)
    80001fd6:	6105                	addi	sp,sp,32
    80001fd8:	8082                	ret
    return p->trapframe->a1;
    80001fda:	713c                	ld	a5,96(a0)
    80001fdc:	7fa8                	ld	a0,120(a5)
    80001fde:	bfcd                	j	80001fd0 <argraw+0x30>
    return p->trapframe->a2;
    80001fe0:	713c                	ld	a5,96(a0)
    80001fe2:	63c8                	ld	a0,128(a5)
    80001fe4:	b7f5                	j	80001fd0 <argraw+0x30>
    return p->trapframe->a3;
    80001fe6:	713c                	ld	a5,96(a0)
    80001fe8:	67c8                	ld	a0,136(a5)
    80001fea:	b7dd                	j	80001fd0 <argraw+0x30>
    return p->trapframe->a4;
    80001fec:	713c                	ld	a5,96(a0)
    80001fee:	6bc8                	ld	a0,144(a5)
    80001ff0:	b7c5                	j	80001fd0 <argraw+0x30>
    return p->trapframe->a5;
    80001ff2:	713c                	ld	a5,96(a0)
    80001ff4:	6fc8                	ld	a0,152(a5)
    80001ff6:	bfe9                	j	80001fd0 <argraw+0x30>
  panic("argraw");
    80001ff8:	00006517          	auipc	a0,0x6
    80001ffc:	39850513          	addi	a0,a0,920 # 80008390 <states.0+0x148>
    80002000:	00004097          	auipc	ra,0x4
    80002004:	204080e7          	jalr	516(ra) # 80006204 <panic>

0000000080002008 <fetchaddr>:
{
    80002008:	1101                	addi	sp,sp,-32
    8000200a:	ec06                	sd	ra,24(sp)
    8000200c:	e822                	sd	s0,16(sp)
    8000200e:	e426                	sd	s1,8(sp)
    80002010:	e04a                	sd	s2,0(sp)
    80002012:	1000                	addi	s0,sp,32
    80002014:	84aa                	mv	s1,a0
    80002016:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	fd4080e7          	jalr	-44(ra) # 80000fec <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002020:	693c                	ld	a5,80(a0)
    80002022:	02f4f863          	bgeu	s1,a5,80002052 <fetchaddr+0x4a>
    80002026:	00848713          	addi	a4,s1,8
    8000202a:	02e7e663          	bltu	a5,a4,80002056 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000202e:	46a1                	li	a3,8
    80002030:	8626                	mv	a2,s1
    80002032:	85ca                	mv	a1,s2
    80002034:	6d28                	ld	a0,88(a0)
    80002036:	fffff097          	auipc	ra,0xfffff
    8000203a:	d06080e7          	jalr	-762(ra) # 80000d3c <copyin>
    8000203e:	00a03533          	snez	a0,a0
    80002042:	40a00533          	neg	a0,a0
}
    80002046:	60e2                	ld	ra,24(sp)
    80002048:	6442                	ld	s0,16(sp)
    8000204a:	64a2                	ld	s1,8(sp)
    8000204c:	6902                	ld	s2,0(sp)
    8000204e:	6105                	addi	sp,sp,32
    80002050:	8082                	ret
    return -1;
    80002052:	557d                	li	a0,-1
    80002054:	bfcd                	j	80002046 <fetchaddr+0x3e>
    80002056:	557d                	li	a0,-1
    80002058:	b7fd                	j	80002046 <fetchaddr+0x3e>

000000008000205a <fetchstr>:
{
    8000205a:	7179                	addi	sp,sp,-48
    8000205c:	f406                	sd	ra,40(sp)
    8000205e:	f022                	sd	s0,32(sp)
    80002060:	ec26                	sd	s1,24(sp)
    80002062:	e84a                	sd	s2,16(sp)
    80002064:	e44e                	sd	s3,8(sp)
    80002066:	1800                	addi	s0,sp,48
    80002068:	892a                	mv	s2,a0
    8000206a:	84ae                	mv	s1,a1
    8000206c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000206e:	fffff097          	auipc	ra,0xfffff
    80002072:	f7e080e7          	jalr	-130(ra) # 80000fec <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002076:	86ce                	mv	a3,s3
    80002078:	864a                	mv	a2,s2
    8000207a:	85a6                	mv	a1,s1
    8000207c:	6d28                	ld	a0,88(a0)
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	d4c080e7          	jalr	-692(ra) # 80000dca <copyinstr>
  if(err < 0)
    80002086:	00054763          	bltz	a0,80002094 <fetchstr+0x3a>
  return strlen(buf);
    8000208a:	8526                	mv	a0,s1
    8000208c:	ffffe097          	auipc	ra,0xffffe
    80002090:	402080e7          	jalr	1026(ra) # 8000048e <strlen>
}
    80002094:	70a2                	ld	ra,40(sp)
    80002096:	7402                	ld	s0,32(sp)
    80002098:	64e2                	ld	s1,24(sp)
    8000209a:	6942                	ld	s2,16(sp)
    8000209c:	69a2                	ld	s3,8(sp)
    8000209e:	6145                	addi	sp,sp,48
    800020a0:	8082                	ret

00000000800020a2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800020a2:	1101                	addi	sp,sp,-32
    800020a4:	ec06                	sd	ra,24(sp)
    800020a6:	e822                	sd	s0,16(sp)
    800020a8:	e426                	sd	s1,8(sp)
    800020aa:	1000                	addi	s0,sp,32
    800020ac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020ae:	00000097          	auipc	ra,0x0
    800020b2:	ef2080e7          	jalr	-270(ra) # 80001fa0 <argraw>
    800020b6:	c088                	sw	a0,0(s1)
  return 0;
}
    800020b8:	4501                	li	a0,0
    800020ba:	60e2                	ld	ra,24(sp)
    800020bc:	6442                	ld	s0,16(sp)
    800020be:	64a2                	ld	s1,8(sp)
    800020c0:	6105                	addi	sp,sp,32
    800020c2:	8082                	ret

00000000800020c4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020c4:	1101                	addi	sp,sp,-32
    800020c6:	ec06                	sd	ra,24(sp)
    800020c8:	e822                	sd	s0,16(sp)
    800020ca:	e426                	sd	s1,8(sp)
    800020cc:	1000                	addi	s0,sp,32
    800020ce:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020d0:	00000097          	auipc	ra,0x0
    800020d4:	ed0080e7          	jalr	-304(ra) # 80001fa0 <argraw>
    800020d8:	e088                	sd	a0,0(s1)
  return 0;
}
    800020da:	4501                	li	a0,0
    800020dc:	60e2                	ld	ra,24(sp)
    800020de:	6442                	ld	s0,16(sp)
    800020e0:	64a2                	ld	s1,8(sp)
    800020e2:	6105                	addi	sp,sp,32
    800020e4:	8082                	ret

00000000800020e6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020e6:	1101                	addi	sp,sp,-32
    800020e8:	ec06                	sd	ra,24(sp)
    800020ea:	e822                	sd	s0,16(sp)
    800020ec:	e426                	sd	s1,8(sp)
    800020ee:	e04a                	sd	s2,0(sp)
    800020f0:	1000                	addi	s0,sp,32
    800020f2:	84ae                	mv	s1,a1
    800020f4:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020f6:	00000097          	auipc	ra,0x0
    800020fa:	eaa080e7          	jalr	-342(ra) # 80001fa0 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020fe:	864a                	mv	a2,s2
    80002100:	85a6                	mv	a1,s1
    80002102:	00000097          	auipc	ra,0x0
    80002106:	f58080e7          	jalr	-168(ra) # 8000205a <fetchstr>
}
    8000210a:	60e2                	ld	ra,24(sp)
    8000210c:	6442                	ld	s0,16(sp)
    8000210e:	64a2                	ld	s1,8(sp)
    80002110:	6902                	ld	s2,0(sp)
    80002112:	6105                	addi	sp,sp,32
    80002114:	8082                	ret

0000000080002116 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002116:	1101                	addi	sp,sp,-32
    80002118:	ec06                	sd	ra,24(sp)
    8000211a:	e822                	sd	s0,16(sp)
    8000211c:	e426                	sd	s1,8(sp)
    8000211e:	e04a                	sd	s2,0(sp)
    80002120:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	eca080e7          	jalr	-310(ra) # 80000fec <myproc>
    8000212a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000212c:	06053903          	ld	s2,96(a0)
    80002130:	0a893783          	ld	a5,168(s2)
    80002134:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002138:	37fd                	addiw	a5,a5,-1
    8000213a:	4751                	li	a4,20
    8000213c:	00f76f63          	bltu	a4,a5,8000215a <syscall+0x44>
    80002140:	00369713          	slli	a4,a3,0x3
    80002144:	00006797          	auipc	a5,0x6
    80002148:	28c78793          	addi	a5,a5,652 # 800083d0 <syscalls>
    8000214c:	97ba                	add	a5,a5,a4
    8000214e:	639c                	ld	a5,0(a5)
    80002150:	c789                	beqz	a5,8000215a <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002152:	9782                	jalr	a5
    80002154:	06a93823          	sd	a0,112(s2)
    80002158:	a839                	j	80002176 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000215a:	16048613          	addi	a2,s1,352
    8000215e:	5c8c                	lw	a1,56(s1)
    80002160:	00006517          	auipc	a0,0x6
    80002164:	23850513          	addi	a0,a0,568 # 80008398 <states.0+0x150>
    80002168:	00004097          	auipc	ra,0x4
    8000216c:	0e6080e7          	jalr	230(ra) # 8000624e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002170:	70bc                	ld	a5,96(s1)
    80002172:	577d                	li	a4,-1
    80002174:	fbb8                	sd	a4,112(a5)
  }
}
    80002176:	60e2                	ld	ra,24(sp)
    80002178:	6442                	ld	s0,16(sp)
    8000217a:	64a2                	ld	s1,8(sp)
    8000217c:	6902                	ld	s2,0(sp)
    8000217e:	6105                	addi	sp,sp,32
    80002180:	8082                	ret

0000000080002182 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002182:	1101                	addi	sp,sp,-32
    80002184:	ec06                	sd	ra,24(sp)
    80002186:	e822                	sd	s0,16(sp)
    80002188:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000218a:	fec40593          	addi	a1,s0,-20
    8000218e:	4501                	li	a0,0
    80002190:	00000097          	auipc	ra,0x0
    80002194:	f12080e7          	jalr	-238(ra) # 800020a2 <argint>
    return -1;
    80002198:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000219a:	00054963          	bltz	a0,800021ac <sys_exit+0x2a>
  exit(n);
    8000219e:	fec42503          	lw	a0,-20(s0)
    800021a2:	fffff097          	auipc	ra,0xfffff
    800021a6:	76a080e7          	jalr	1898(ra) # 8000190c <exit>
  return 0;  // not reached
    800021aa:	4781                	li	a5,0
}
    800021ac:	853e                	mv	a0,a5
    800021ae:	60e2                	ld	ra,24(sp)
    800021b0:	6442                	ld	s0,16(sp)
    800021b2:	6105                	addi	sp,sp,32
    800021b4:	8082                	ret

00000000800021b6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021b6:	1141                	addi	sp,sp,-16
    800021b8:	e406                	sd	ra,8(sp)
    800021ba:	e022                	sd	s0,0(sp)
    800021bc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	e2e080e7          	jalr	-466(ra) # 80000fec <myproc>
}
    800021c6:	5d08                	lw	a0,56(a0)
    800021c8:	60a2                	ld	ra,8(sp)
    800021ca:	6402                	ld	s0,0(sp)
    800021cc:	0141                	addi	sp,sp,16
    800021ce:	8082                	ret

00000000800021d0 <sys_fork>:

uint64
sys_fork(void)
{
    800021d0:	1141                	addi	sp,sp,-16
    800021d2:	e406                	sd	ra,8(sp)
    800021d4:	e022                	sd	s0,0(sp)
    800021d6:	0800                	addi	s0,sp,16
  return fork();
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	1e6080e7          	jalr	486(ra) # 800013be <fork>
}
    800021e0:	60a2                	ld	ra,8(sp)
    800021e2:	6402                	ld	s0,0(sp)
    800021e4:	0141                	addi	sp,sp,16
    800021e6:	8082                	ret

00000000800021e8 <sys_wait>:

uint64
sys_wait(void)
{
    800021e8:	1101                	addi	sp,sp,-32
    800021ea:	ec06                	sd	ra,24(sp)
    800021ec:	e822                	sd	s0,16(sp)
    800021ee:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800021f0:	fe840593          	addi	a1,s0,-24
    800021f4:	4501                	li	a0,0
    800021f6:	00000097          	auipc	ra,0x0
    800021fa:	ece080e7          	jalr	-306(ra) # 800020c4 <argaddr>
    800021fe:	87aa                	mv	a5,a0
    return -1;
    80002200:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002202:	0007c863          	bltz	a5,80002212 <sys_wait+0x2a>
  return wait(p);
    80002206:	fe843503          	ld	a0,-24(s0)
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	50a080e7          	jalr	1290(ra) # 80001714 <wait>
}
    80002212:	60e2                	ld	ra,24(sp)
    80002214:	6442                	ld	s0,16(sp)
    80002216:	6105                	addi	sp,sp,32
    80002218:	8082                	ret

000000008000221a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000221a:	7179                	addi	sp,sp,-48
    8000221c:	f406                	sd	ra,40(sp)
    8000221e:	f022                	sd	s0,32(sp)
    80002220:	ec26                	sd	s1,24(sp)
    80002222:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002224:	fdc40593          	addi	a1,s0,-36
    80002228:	4501                	li	a0,0
    8000222a:	00000097          	auipc	ra,0x0
    8000222e:	e78080e7          	jalr	-392(ra) # 800020a2 <argint>
    80002232:	87aa                	mv	a5,a0
    return -1;
    80002234:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002236:	0207c063          	bltz	a5,80002256 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	db2080e7          	jalr	-590(ra) # 80000fec <myproc>
    80002242:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    80002244:	fdc42503          	lw	a0,-36(s0)
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	0fe080e7          	jalr	254(ra) # 80001346 <growproc>
    80002250:	00054863          	bltz	a0,80002260 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002254:	8526                	mv	a0,s1
}
    80002256:	70a2                	ld	ra,40(sp)
    80002258:	7402                	ld	s0,32(sp)
    8000225a:	64e2                	ld	s1,24(sp)
    8000225c:	6145                	addi	sp,sp,48
    8000225e:	8082                	ret
    return -1;
    80002260:	557d                	li	a0,-1
    80002262:	bfd5                	j	80002256 <sys_sbrk+0x3c>

0000000080002264 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002264:	7139                	addi	sp,sp,-64
    80002266:	fc06                	sd	ra,56(sp)
    80002268:	f822                	sd	s0,48(sp)
    8000226a:	f426                	sd	s1,40(sp)
    8000226c:	f04a                	sd	s2,32(sp)
    8000226e:	ec4e                	sd	s3,24(sp)
    80002270:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002272:	fcc40593          	addi	a1,s0,-52
    80002276:	4501                	li	a0,0
    80002278:	00000097          	auipc	ra,0x0
    8000227c:	e2a080e7          	jalr	-470(ra) # 800020a2 <argint>
    return -1;
    80002280:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002282:	06054563          	bltz	a0,800022ec <sys_sleep+0x88>
  acquire(&tickslock);
    80002286:	0000d517          	auipc	a0,0xd
    8000228a:	f6a50513          	addi	a0,a0,-150 # 8000f1f0 <tickslock>
    8000228e:	00004097          	auipc	ra,0x4
    80002292:	498080e7          	jalr	1176(ra) # 80006726 <acquire>
  ticks0 = ticks;
    80002296:	00007917          	auipc	s2,0x7
    8000229a:	d8292903          	lw	s2,-638(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000229e:	fcc42783          	lw	a5,-52(s0)
    800022a2:	cf85                	beqz	a5,800022da <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022a4:	0000d997          	auipc	s3,0xd
    800022a8:	f4c98993          	addi	s3,s3,-180 # 8000f1f0 <tickslock>
    800022ac:	00007497          	auipc	s1,0x7
    800022b0:	d6c48493          	addi	s1,s1,-660 # 80009018 <ticks>
    if(myproc()->killed){
    800022b4:	fffff097          	auipc	ra,0xfffff
    800022b8:	d38080e7          	jalr	-712(ra) # 80000fec <myproc>
    800022bc:	591c                	lw	a5,48(a0)
    800022be:	ef9d                	bnez	a5,800022fc <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022c0:	85ce                	mv	a1,s3
    800022c2:	8526                	mv	a0,s1
    800022c4:	fffff097          	auipc	ra,0xfffff
    800022c8:	3ec080e7          	jalr	1004(ra) # 800016b0 <sleep>
  while(ticks - ticks0 < n){
    800022cc:	409c                	lw	a5,0(s1)
    800022ce:	412787bb          	subw	a5,a5,s2
    800022d2:	fcc42703          	lw	a4,-52(s0)
    800022d6:	fce7efe3          	bltu	a5,a4,800022b4 <sys_sleep+0x50>
  }
  release(&tickslock);
    800022da:	0000d517          	auipc	a0,0xd
    800022de:	f1650513          	addi	a0,a0,-234 # 8000f1f0 <tickslock>
    800022e2:	00004097          	auipc	ra,0x4
    800022e6:	514080e7          	jalr	1300(ra) # 800067f6 <release>
  return 0;
    800022ea:	4781                	li	a5,0
}
    800022ec:	853e                	mv	a0,a5
    800022ee:	70e2                	ld	ra,56(sp)
    800022f0:	7442                	ld	s0,48(sp)
    800022f2:	74a2                	ld	s1,40(sp)
    800022f4:	7902                	ld	s2,32(sp)
    800022f6:	69e2                	ld	s3,24(sp)
    800022f8:	6121                	addi	sp,sp,64
    800022fa:	8082                	ret
      release(&tickslock);
    800022fc:	0000d517          	auipc	a0,0xd
    80002300:	ef450513          	addi	a0,a0,-268 # 8000f1f0 <tickslock>
    80002304:	00004097          	auipc	ra,0x4
    80002308:	4f2080e7          	jalr	1266(ra) # 800067f6 <release>
      return -1;
    8000230c:	57fd                	li	a5,-1
    8000230e:	bff9                	j	800022ec <sys_sleep+0x88>

0000000080002310 <sys_kill>:

uint64
sys_kill(void)
{
    80002310:	1101                	addi	sp,sp,-32
    80002312:	ec06                	sd	ra,24(sp)
    80002314:	e822                	sd	s0,16(sp)
    80002316:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002318:	fec40593          	addi	a1,s0,-20
    8000231c:	4501                	li	a0,0
    8000231e:	00000097          	auipc	ra,0x0
    80002322:	d84080e7          	jalr	-636(ra) # 800020a2 <argint>
    80002326:	87aa                	mv	a5,a0
    return -1;
    80002328:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000232a:	0007c863          	bltz	a5,8000233a <sys_kill+0x2a>
  return kill(pid);
    8000232e:	fec42503          	lw	a0,-20(s0)
    80002332:	fffff097          	auipc	ra,0xfffff
    80002336:	6b0080e7          	jalr	1712(ra) # 800019e2 <kill>
}
    8000233a:	60e2                	ld	ra,24(sp)
    8000233c:	6442                	ld	s0,16(sp)
    8000233e:	6105                	addi	sp,sp,32
    80002340:	8082                	ret

0000000080002342 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002342:	1101                	addi	sp,sp,-32
    80002344:	ec06                	sd	ra,24(sp)
    80002346:	e822                	sd	s0,16(sp)
    80002348:	e426                	sd	s1,8(sp)
    8000234a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000234c:	0000d517          	auipc	a0,0xd
    80002350:	ea450513          	addi	a0,a0,-348 # 8000f1f0 <tickslock>
    80002354:	00004097          	auipc	ra,0x4
    80002358:	3d2080e7          	jalr	978(ra) # 80006726 <acquire>
  xticks = ticks;
    8000235c:	00007497          	auipc	s1,0x7
    80002360:	cbc4a483          	lw	s1,-836(s1) # 80009018 <ticks>
  release(&tickslock);
    80002364:	0000d517          	auipc	a0,0xd
    80002368:	e8c50513          	addi	a0,a0,-372 # 8000f1f0 <tickslock>
    8000236c:	00004097          	auipc	ra,0x4
    80002370:	48a080e7          	jalr	1162(ra) # 800067f6 <release>
  return xticks;
}
    80002374:	02049513          	slli	a0,s1,0x20
    80002378:	9101                	srli	a0,a0,0x20
    8000237a:	60e2                	ld	ra,24(sp)
    8000237c:	6442                	ld	s0,16(sp)
    8000237e:	64a2                	ld	s1,8(sp)
    80002380:	6105                	addi	sp,sp,32
    80002382:	8082                	ret

0000000080002384 <binit>:
} bcache;


void
binit(void)
{
    80002384:	7179                	addi	sp,sp,-48
    80002386:	f406                	sd	ra,40(sp)
    80002388:	f022                	sd	s0,32(sp)
    8000238a:	ec26                	sd	s1,24(sp)
    8000238c:	e84a                	sd	s2,16(sp)
    8000238e:	e44e                	sd	s3,8(sp)
    80002390:	e052                	sd	s4,0(sp)
    80002392:	1800                	addi	s0,sp,48
  int i;
  struct buf *b;

  bcache.size = 0;  // lab8-2
    80002394:	0000d917          	auipc	s2,0xd
    80002398:	e7c90913          	addi	s2,s2,-388 # 8000f210 <bcache>
    8000239c:	00015797          	auipc	a5,0x15
    800023a0:	1c07aa23          	sw	zero,468(a5) # 80017570 <bcache+0x8360>
  initlock(&bcache.lock, "bcache");
    800023a4:	00006597          	auipc	a1,0x6
    800023a8:	0dc58593          	addi	a1,a1,220 # 80008480 <syscalls+0xb0>
    800023ac:	854a                	mv	a0,s2
    800023ae:	00004097          	auipc	ra,0x4
    800023b2:	4f4080e7          	jalr	1268(ra) # 800068a2 <initlock>
  initlock(&bcache.hashlock, "bcache_hash");    // init hash lock - lab8-2
    800023b6:	00006597          	auipc	a1,0x6
    800023ba:	0d258593          	addi	a1,a1,210 # 80008488 <syscalls+0xb8>
    800023be:	00019517          	auipc	a0,0x19
    800023c2:	c3a50513          	addi	a0,a0,-966 # 8001aff8 <bcache+0xbde8>
    800023c6:	00004097          	auipc	ra,0x4
    800023ca:	4dc080e7          	jalr	1244(ra) # 800068a2 <initlock>
  // init all buckets' locks  - lab8-2
  for(i = 0; i < NBUCKET; ++i) {
    800023ce:	00019497          	auipc	s1,0x19
    800023d2:	a8a48493          	addi	s1,s1,-1398 # 8001ae58 <bcache+0xbc48>
    800023d6:	00019a17          	auipc	s4,0x19
    800023da:	c22a0a13          	addi	s4,s4,-990 # 8001aff8 <bcache+0xbde8>
    initlock(&bcache.locks[i], "bcache_bucket");
    800023de:	00006997          	auipc	s3,0x6
    800023e2:	0ba98993          	addi	s3,s3,186 # 80008498 <syscalls+0xc8>
    800023e6:	85ce                	mv	a1,s3
    800023e8:	8526                	mv	a0,s1
    800023ea:	00004097          	auipc	ra,0x4
    800023ee:	4b8080e7          	jalr	1208(ra) # 800068a2 <initlock>
  for(i = 0; i < NBUCKET; ++i) {
    800023f2:	02048493          	addi	s1,s1,32
    800023f6:	ff4498e3          	bne	s1,s4,800023e6 <binit+0x62>
    800023fa:	0000d497          	auipc	s1,0xd
    800023fe:	e4648493          	addi	s1,s1,-442 # 8000f240 <bcache+0x30>
    80002402:	67a1                	lui	a5,0x8
    80002404:	37078793          	addi	a5,a5,880 # 8370 <_entry-0x7fff7c90>
    80002408:	993e                	add	s2,s2,a5
//  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
// lab8-2
//    b->next = bcache.head.next;
//    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    8000240a:	00006997          	auipc	s3,0x6
    8000240e:	09e98993          	addi	s3,s3,158 # 800084a8 <syscalls+0xd8>
    80002412:	85ce                	mv	a1,s3
    80002414:	8526                	mv	a0,s1
    80002416:	00001097          	auipc	ra,0x1
    8000241a:	6d6080e7          	jalr	1750(ra) # 80003aec <initsleeplock>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000241e:	46048493          	addi	s1,s1,1120
    80002422:	ff2498e3          	bne	s1,s2,80002412 <binit+0x8e>
//    bcache.head.next->prev = b;
//    bcache.head.next = b;
  }
}
    80002426:	70a2                	ld	ra,40(sp)
    80002428:	7402                	ld	s0,32(sp)
    8000242a:	64e2                	ld	s1,24(sp)
    8000242c:	6942                	ld	s2,16(sp)
    8000242e:	69a2                	ld	s3,8(sp)
    80002430:	6a02                	ld	s4,0(sp)
    80002432:	6145                	addi	sp,sp,48
    80002434:	8082                	ret

0000000080002436 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002436:	7175                	addi	sp,sp,-144
    80002438:	e506                	sd	ra,136(sp)
    8000243a:	e122                	sd	s0,128(sp)
    8000243c:	fca6                	sd	s1,120(sp)
    8000243e:	f8ca                	sd	s2,112(sp)
    80002440:	f4ce                	sd	s3,104(sp)
    80002442:	f0d2                	sd	s4,96(sp)
    80002444:	ecd6                	sd	s5,88(sp)
    80002446:	e8da                	sd	s6,80(sp)
    80002448:	e4de                	sd	s7,72(sp)
    8000244a:	e0e2                	sd	s8,64(sp)
    8000244c:	fc66                	sd	s9,56(sp)
    8000244e:	f86a                	sd	s10,48(sp)
    80002450:	f46e                	sd	s11,40(sp)
    80002452:	0900                	addi	s0,sp,144
    80002454:	89aa                	mv	s3,a0
    80002456:	8bae                	mv	s7,a1
  int idx = HASH(blockno);
    80002458:	47b5                	li	a5,13
    8000245a:	02f5f7bb          	remuw	a5,a1,a5
    8000245e:	0007891b          	sext.w	s2,a5
    80002462:	f7243c23          	sd	s2,-136(s0)
  acquire(&bcache.locks[idx]);  // lab8-2
    80002466:	5e278b1b          	addiw	s6,a5,1506
    8000246a:	0b16                	slli	s6,s6,0x5
    8000246c:	0b21                	addi	s6,s6,8
    8000246e:	0000d497          	auipc	s1,0xd
    80002472:	da248493          	addi	s1,s1,-606 # 8000f210 <bcache>
    80002476:	009b07b3          	add	a5,s6,s1
    8000247a:	f8f43023          	sd	a5,-128(s0)
    8000247e:	853e                	mv	a0,a5
    80002480:	00004097          	auipc	ra,0x4
    80002484:	2a6080e7          	jalr	678(ra) # 80006726 <acquire>
  for(b = bcache.buckets[idx].next; b; b = b->next){
    80002488:	46000793          	li	a5,1120
    8000248c:	02f907b3          	mul	a5,s2,a5
    80002490:	94be                	add	s1,s1,a5
    80002492:	67a1                	lui	a5,0x8
    80002494:	97a6                	add	a5,a5,s1
    80002496:	3b87b483          	ld	s1,952(a5) # 83b8 <_entry-0x7fff7c48>
    8000249a:	e4ad                	bnez	s1,80002504 <bread+0xce>
  acquire(&bcache.lock);
    8000249c:	0000d517          	auipc	a0,0xd
    800024a0:	d7450513          	addi	a0,a0,-652 # 8000f210 <bcache>
    800024a4:	00004097          	auipc	ra,0x4
    800024a8:	282080e7          	jalr	642(ra) # 80006726 <acquire>
  if(bcache.size < NBUF) {
    800024ac:	00015797          	auipc	a5,0x15
    800024b0:	0c47a783          	lw	a5,196(a5) # 80017570 <bcache+0x8360>
    800024b4:	4775                	li	a4,29
    800024b6:	06f75d63          	bge	a4,a5,80002530 <bread+0xfa>
  release(&bcache.lock);
    800024ba:	0000d517          	auipc	a0,0xd
    800024be:	d5650513          	addi	a0,a0,-682 # 8000f210 <bcache>
    800024c2:	00004097          	auipc	ra,0x4
    800024c6:	334080e7          	jalr	820(ra) # 800067f6 <release>
  release(&bcache.locks[idx]);
    800024ca:	f8043503          	ld	a0,-128(s0)
    800024ce:	00004097          	auipc	ra,0x4
    800024d2:	328080e7          	jalr	808(ra) # 800067f6 <release>
  acquire(&bcache.hashlock);
    800024d6:	00019517          	auipc	a0,0x19
    800024da:	b2250513          	addi	a0,a0,-1246 # 8001aff8 <bcache+0xbde8>
    800024de:	00004097          	auipc	ra,0x4
    800024e2:	248080e7          	jalr	584(ra) # 80006726 <acquire>
  int idx = HASH(blockno);
    800024e6:	f7843a83          	ld	s5,-136(s0)
  acquire(&bcache.hashlock);
    800024ea:	4cb5                	li	s9,13
      acquire(&bcache.locks[idx]);
    800024ec:	0000dc17          	auipc	s8,0xd
    800024f0:	d24c0c13          	addi	s8,s8,-732 # 8000f210 <bcache>
      for(pre = &bcache.buckets[idx], b = pre->next; b; pre = b, b = b->next) {
    800024f4:	46000d93          	li	s11,1120
    800024f8:	6d21                	lui	s10,0x8
    800024fa:	368d0b13          	addi	s6,s10,872 # 8368 <_entry-0x7fff7c98>
    800024fe:	a291                	j	80002642 <bread+0x20c>
  for(b = bcache.buckets[idx].next; b; b = b->next){
    80002500:	68a4                	ld	s1,80(s1)
    80002502:	dcc9                	beqz	s1,8000249c <bread+0x66>
    if(b->dev == dev && b->blockno == blockno){
    80002504:	449c                	lw	a5,8(s1)
    80002506:	ff379de3          	bne	a5,s3,80002500 <bread+0xca>
    8000250a:	44dc                	lw	a5,12(s1)
    8000250c:	ff779ae3          	bne	a5,s7,80002500 <bread+0xca>
      b->refcnt++;
    80002510:	44bc                	lw	a5,72(s1)
    80002512:	2785                	addiw	a5,a5,1
    80002514:	c4bc                	sw	a5,72(s1)
      release(&bcache.locks[idx]);  // lab8-2
    80002516:	f8043503          	ld	a0,-128(s0)
    8000251a:	00004097          	auipc	ra,0x4
    8000251e:	2dc080e7          	jalr	732(ra) # 800067f6 <release>
      acquiresleep(&b->lock);
    80002522:	01048513          	addi	a0,s1,16
    80002526:	00001097          	auipc	ra,0x1
    8000252a:	600080e7          	jalr	1536(ra) # 80003b26 <acquiresleep>
      return b;
    8000252e:	a895                	j	800025a2 <bread+0x16c>
    b = &bcache.buf[bcache.size++];
    80002530:	0000da97          	auipc	s5,0xd
    80002534:	ce0a8a93          	addi	s5,s5,-800 # 8000f210 <bcache>
    80002538:	0017871b          	addiw	a4,a5,1
    8000253c:	00015697          	auipc	a3,0x15
    80002540:	02e6aa23          	sw	a4,52(a3) # 80017570 <bcache+0x8360>
    80002544:	46000a13          	li	s4,1120
    80002548:	03478933          	mul	s2,a5,s4
    8000254c:	02090493          	addi	s1,s2,32
    80002550:	94d6                	add	s1,s1,s5
    release(&bcache.lock);
    80002552:	8556                	mv	a0,s5
    80002554:	00004097          	auipc	ra,0x4
    80002558:	2a2080e7          	jalr	674(ra) # 800067f6 <release>
    b->dev = dev;
    8000255c:	012a8733          	add	a4,s5,s2
    80002560:	03372423          	sw	s3,40(a4)
    b->blockno = blockno;
    80002564:	03772623          	sw	s7,44(a4)
    b->valid = 0;
    80002568:	02072023          	sw	zero,32(a4)
    b->refcnt = 1;
    8000256c:	4785                	li	a5,1
    8000256e:	d73c                	sw	a5,104(a4)
    b->next = bcache.buckets[idx].next;
    80002570:	f7843783          	ld	a5,-136(s0)
    80002574:	034787b3          	mul	a5,a5,s4
    80002578:	97d6                	add	a5,a5,s5
    8000257a:	66a1                	lui	a3,0x8
    8000257c:	97b6                	add	a5,a5,a3
    8000257e:	3b87b683          	ld	a3,952(a5)
    80002582:	fb34                	sd	a3,112(a4)
    bcache.buckets[idx].next = b;
    80002584:	3a97bc23          	sd	s1,952(a5)
    release(&bcache.locks[idx]);
    80002588:	f8043503          	ld	a0,-128(s0)
    8000258c:	00004097          	auipc	ra,0x4
    80002590:	26a080e7          	jalr	618(ra) # 800067f6 <release>
    acquiresleep(&b->lock);
    80002594:	03090513          	addi	a0,s2,48
    80002598:	9556                	add	a0,a0,s5
    8000259a:	00001097          	auipc	ra,0x1
    8000259e:	58c080e7          	jalr	1420(ra) # 80003b26 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025a2:	409c                	lw	a5,0(s1)
    800025a4:	16078c63          	beqz	a5,8000271c <bread+0x2e6>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025a8:	8526                	mv	a0,s1
    800025aa:	60aa                	ld	ra,136(sp)
    800025ac:	640a                	ld	s0,128(sp)
    800025ae:	74e6                	ld	s1,120(sp)
    800025b0:	7946                	ld	s2,112(sp)
    800025b2:	79a6                	ld	s3,104(sp)
    800025b4:	7a06                	ld	s4,96(sp)
    800025b6:	6ae6                	ld	s5,88(sp)
    800025b8:	6b46                	ld	s6,80(sp)
    800025ba:	6ba6                	ld	s7,72(sp)
    800025bc:	6c06                	ld	s8,64(sp)
    800025be:	7ce2                	ld	s9,56(sp)
    800025c0:	7d42                	ld	s10,48(sp)
    800025c2:	7da2                	ld	s11,40(sp)
    800025c4:	6149                	addi	sp,sp,144
    800025c6:	8082                	ret
          if(idx == HASH(blockno) && b->dev == dev && b->blockno == blockno){
    800025c8:	449c                	lw	a5,8(s1)
    800025ca:	05379263          	bne	a5,s3,8000260e <bread+0x1d8>
    800025ce:	44dc                	lw	a5,12(s1)
    800025d0:	03779f63          	bne	a5,s7,8000260e <bread+0x1d8>
              b->refcnt++;
    800025d4:	44bc                	lw	a5,72(s1)
    800025d6:	2785                	addiw	a5,a5,1
    800025d8:	c4bc                	sw	a5,72(s1)
              release(&bcache.locks[idx]);
    800025da:	8552                	mv	a0,s4
    800025dc:	00004097          	auipc	ra,0x4
    800025e0:	21a080e7          	jalr	538(ra) # 800067f6 <release>
              release(&bcache.hashlock);
    800025e4:	00019517          	auipc	a0,0x19
    800025e8:	a1450513          	addi	a0,a0,-1516 # 8001aff8 <bcache+0xbde8>
    800025ec:	00004097          	auipc	ra,0x4
    800025f0:	20a080e7          	jalr	522(ra) # 800067f6 <release>
              acquiresleep(&b->lock);
    800025f4:	01048513          	addi	a0,s1,16
    800025f8:	00001097          	auipc	ra,0x1
    800025fc:	52e080e7          	jalr	1326(ra) # 80003b26 <acquiresleep>
              return b;
    80002600:	b74d                	j	800025a2 <bread+0x16c>
      for(pre = &bcache.buckets[idx], b = pre->next; b; pre = b, b = b->next) {
    80002602:	68bc                	ld	a5,80(s1)
    80002604:	c395                	beqz	a5,80002628 <bread+0x1f2>
  acquire(&bcache.hashlock);
    80002606:	8726                	mv	a4,s1
    80002608:	84be                	mv	s1,a5
          if(idx == HASH(blockno) && b->dev == dev && b->blockno == blockno){
    8000260a:	fac90fe3          	beq	s2,a2,800025c8 <bread+0x192>
          if(b->refcnt == 0 && b->timestamp < mintimestamp) {
    8000260e:	44bc                	lw	a5,72(s1)
    80002610:	fbed                	bnez	a5,80002602 <bread+0x1cc>
    80002612:	4584a683          	lw	a3,1112(s1)
    80002616:	feb6f6e3          	bgeu	a3,a1,80002602 <bread+0x1cc>
      for(pre = &bcache.buckets[idx], b = pre->next; b; pre = b, b = b->next) {
    8000261a:	68bc                	ld	a5,80(s1)
    8000261c:	cfb9                	beqz	a5,8000267a <bread+0x244>
              mintimestamp = b->timestamp;
    8000261e:	85b6                	mv	a1,a3
      for(pre = &bcache.buckets[idx], b = pre->next; b; pre = b, b = b->next) {
    80002620:	f8e43423          	sd	a4,-120(s0)
    80002624:	8526                	mv	a0,s1
    80002626:	b7c5                	j	80002606 <bread+0x1d0>
      if(minb) {
    80002628:	e531                	bnez	a0,80002674 <bread+0x23e>
      release(&bcache.locks[idx]);
    8000262a:	8552                	mv	a0,s4
    8000262c:	00004097          	auipc	ra,0x4
    80002630:	1ca080e7          	jalr	458(ra) # 800067f6 <release>
      if(++idx == NBUCKET) {
    80002634:	2a85                	addiw	s5,s5,1
    80002636:	47b5                	li	a5,13
    80002638:	0cfa8863          	beq	s5,a5,80002708 <bread+0x2d2>
  for(i = 0; i < NBUCKET; ++i) {
    8000263c:	3cfd                	addiw	s9,s9,-1
    8000263e:	0c0c8763          	beqz	s9,8000270c <bread+0x2d6>
      acquire(&bcache.locks[idx]);
    80002642:	5e2a8a13          	addi	s4,s5,1506
    80002646:	0a16                	slli	s4,s4,0x5
    80002648:	0a21                	addi	s4,s4,8
    8000264a:	9a62                	add	s4,s4,s8
    8000264c:	8552                	mv	a0,s4
    8000264e:	00004097          	auipc	ra,0x4
    80002652:	0d8080e7          	jalr	216(ra) # 80006726 <acquire>
      for(pre = &bcache.buckets[idx], b = pre->next; b; pre = b, b = b->next) {
    80002656:	03ba87b3          	mul	a5,s5,s11
    8000265a:	01678733          	add	a4,a5,s6
    8000265e:	9762                	add	a4,a4,s8
    80002660:	97e2                	add	a5,a5,s8
    80002662:	97ea                	add	a5,a5,s10
    80002664:	3b87b483          	ld	s1,952(a5)
    80002668:	d0e9                	beqz	s1,8000262a <bread+0x1f4>
    8000266a:	4501                	li	a0,0
      mintimestamp = -1;
    8000266c:	55fd                	li	a1,-1
          if(idx == HASH(blockno) && b->dev == dev && b->blockno == blockno){
    8000266e:	000a861b          	sext.w	a2,s5
    80002672:	bf61                	j	8000260a <bread+0x1d4>
    80002674:	f8843703          	ld	a4,-120(s0)
    80002678:	84aa                	mv	s1,a0
          minb->dev = dev;
    8000267a:	0134a423          	sw	s3,8(s1)
          minb->blockno = blockno;
    8000267e:	0174a623          	sw	s7,12(s1)
          minb->valid = 0;
    80002682:	0004a023          	sw	zero,0(s1)
          minb->refcnt = 1;
    80002686:	4785                	li	a5,1
    80002688:	c4bc                	sw	a5,72(s1)
          if(idx != HASH(blockno)) {
    8000268a:	000a879b          	sext.w	a5,s5
    8000268e:	02f91d63          	bne	s2,a5,800026c8 <bread+0x292>
          release(&bcache.locks[idx]);
    80002692:	5e2a8793          	addi	a5,s5,1506
    80002696:	0796                	slli	a5,a5,0x5
    80002698:	0000d517          	auipc	a0,0xd
    8000269c:	b8050513          	addi	a0,a0,-1152 # 8000f218 <bcache+0x8>
    800026a0:	953e                	add	a0,a0,a5
    800026a2:	00004097          	auipc	ra,0x4
    800026a6:	154080e7          	jalr	340(ra) # 800067f6 <release>
          release(&bcache.hashlock);
    800026aa:	00019517          	auipc	a0,0x19
    800026ae:	94e50513          	addi	a0,a0,-1714 # 8001aff8 <bcache+0xbde8>
    800026b2:	00004097          	auipc	ra,0x4
    800026b6:	144080e7          	jalr	324(ra) # 800067f6 <release>
          acquiresleep(&minb->lock);
    800026ba:	01048513          	addi	a0,s1,16
    800026be:	00001097          	auipc	ra,0x1
    800026c2:	468080e7          	jalr	1128(ra) # 80003b26 <acquiresleep>
          return minb;
    800026c6:	bdf1                	j	800025a2 <bread+0x16c>
              minpre->next = minb->next;    // remove block
    800026c8:	68bc                	ld	a5,80(s1)
    800026ca:	eb3c                	sd	a5,80(a4)
              release(&bcache.locks[idx]);
    800026cc:	8552                	mv	a0,s4
    800026ce:	00004097          	auipc	ra,0x4
    800026d2:	128080e7          	jalr	296(ra) # 800067f6 <release>
              acquire(&bcache.locks[idx]);
    800026d6:	f8043503          	ld	a0,-128(s0)
    800026da:	00004097          	auipc	ra,0x4
    800026de:	04c080e7          	jalr	76(ra) # 80006726 <acquire>
              minb->next = bcache.buckets[idx].next;    // move block to correct bucket
    800026e2:	46000793          	li	a5,1120
    800026e6:	f7843a83          	ld	s5,-136(s0)
    800026ea:	02fa87b3          	mul	a5,s5,a5
    800026ee:	0000d717          	auipc	a4,0xd
    800026f2:	b2270713          	addi	a4,a4,-1246 # 8000f210 <bcache>
    800026f6:	973e                	add	a4,a4,a5
    800026f8:	67a1                	lui	a5,0x8
    800026fa:	97ba                	add	a5,a5,a4
    800026fc:	3b87b703          	ld	a4,952(a5) # 83b8 <_entry-0x7fff7c48>
    80002700:	e8b8                	sd	a4,80(s1)
              bcache.buckets[idx].next = minb;
    80002702:	3a97bc23          	sd	s1,952(a5)
    80002706:	b771                	j	80002692 <bread+0x25c>
          idx = 0;
    80002708:	4a81                	li	s5,0
    8000270a:	bf0d                	j	8000263c <bread+0x206>
  panic("bget: no buffers");
    8000270c:	00006517          	auipc	a0,0x6
    80002710:	da450513          	addi	a0,a0,-604 # 800084b0 <syscalls+0xe0>
    80002714:	00004097          	auipc	ra,0x4
    80002718:	af0080e7          	jalr	-1296(ra) # 80006204 <panic>
    virtio_disk_rw(b, 0);
    8000271c:	4581                	li	a1,0
    8000271e:	8526                	mv	a0,s1
    80002720:	00003097          	auipc	ra,0x3
    80002724:	f42080e7          	jalr	-190(ra) # 80005662 <virtio_disk_rw>
    b->valid = 1;
    80002728:	4785                	li	a5,1
    8000272a:	c09c                	sw	a5,0(s1)
  return b;
    8000272c:	bdb5                	j	800025a8 <bread+0x172>

000000008000272e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000272e:	1101                	addi	sp,sp,-32
    80002730:	ec06                	sd	ra,24(sp)
    80002732:	e822                	sd	s0,16(sp)
    80002734:	e426                	sd	s1,8(sp)
    80002736:	1000                	addi	s0,sp,32
    80002738:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000273a:	0541                	addi	a0,a0,16
    8000273c:	00001097          	auipc	ra,0x1
    80002740:	484080e7          	jalr	1156(ra) # 80003bc0 <holdingsleep>
    80002744:	cd01                	beqz	a0,8000275c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002746:	4585                	li	a1,1
    80002748:	8526                	mv	a0,s1
    8000274a:	00003097          	auipc	ra,0x3
    8000274e:	f18080e7          	jalr	-232(ra) # 80005662 <virtio_disk_rw>
}
    80002752:	60e2                	ld	ra,24(sp)
    80002754:	6442                	ld	s0,16(sp)
    80002756:	64a2                	ld	s1,8(sp)
    80002758:	6105                	addi	sp,sp,32
    8000275a:	8082                	ret
    panic("bwrite");
    8000275c:	00006517          	auipc	a0,0x6
    80002760:	d6c50513          	addi	a0,a0,-660 # 800084c8 <syscalls+0xf8>
    80002764:	00004097          	auipc	ra,0x4
    80002768:	aa0080e7          	jalr	-1376(ra) # 80006204 <panic>

000000008000276c <brelse>:
// Move to the head of the most-recently-used list.
extern uint ticks;  // lab8-2

void
brelse(struct buf *b)
{
    8000276c:	1101                	addi	sp,sp,-32
    8000276e:	ec06                	sd	ra,24(sp)
    80002770:	e822                	sd	s0,16(sp)
    80002772:	e426                	sd	s1,8(sp)
    80002774:	e04a                	sd	s2,0(sp)
    80002776:	1000                	addi	s0,sp,32
    80002778:	892a                	mv	s2,a0
  int idx;
  if(!holdingsleep(&b->lock))
    8000277a:	01050493          	addi	s1,a0,16
    8000277e:	8526                	mv	a0,s1
    80002780:	00001097          	auipc	ra,0x1
    80002784:	440080e7          	jalr	1088(ra) # 80003bc0 <holdingsleep>
    80002788:	c12d                	beqz	a0,800027ea <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    8000278a:	8526                	mv	a0,s1
    8000278c:	00001097          	auipc	ra,0x1
    80002790:	3f0080e7          	jalr	1008(ra) # 80003b7c <releasesleep>

  // change the lock - lab8-2
  idx = HASH(b->blockno);
    80002794:	00c92483          	lw	s1,12(s2)
    80002798:	47b5                	li	a5,13
    8000279a:	02f4f4bb          	remuw	s1,s1,a5
  acquire(&bcache.locks[idx]);
    8000279e:	5e24849b          	addiw	s1,s1,1506
    800027a2:	0496                	slli	s1,s1,0x5
    800027a4:	0000d797          	auipc	a5,0xd
    800027a8:	a7478793          	addi	a5,a5,-1420 # 8000f218 <bcache+0x8>
    800027ac:	94be                	add	s1,s1,a5
    800027ae:	8526                	mv	a0,s1
    800027b0:	00004097          	auipc	ra,0x4
    800027b4:	f76080e7          	jalr	-138(ra) # 80006726 <acquire>
  b->refcnt--;
    800027b8:	04892783          	lw	a5,72(s2)
    800027bc:	37fd                	addiw	a5,a5,-1
    800027be:	0007871b          	sext.w	a4,a5
    800027c2:	04f92423          	sw	a5,72(s2)
  if (b->refcnt == 0) {
    800027c6:	e719                	bnez	a4,800027d4 <brelse+0x68>
//    b->prev->next = b->next;
//    b->next = bcache.head.next;
//    b->prev = &bcache.head;
//    bcache.head.next->prev = b;
//    bcache.head.next = b;
    b->timestamp = ticks;
    800027c8:	00007797          	auipc	a5,0x7
    800027cc:	8507a783          	lw	a5,-1968(a5) # 80009018 <ticks>
    800027d0:	44f92c23          	sw	a5,1112(s2)
  }
  
  release(&bcache.locks[idx]);
    800027d4:	8526                	mv	a0,s1
    800027d6:	00004097          	auipc	ra,0x4
    800027da:	020080e7          	jalr	32(ra) # 800067f6 <release>
}
    800027de:	60e2                	ld	ra,24(sp)
    800027e0:	6442                	ld	s0,16(sp)
    800027e2:	64a2                	ld	s1,8(sp)
    800027e4:	6902                	ld	s2,0(sp)
    800027e6:	6105                	addi	sp,sp,32
    800027e8:	8082                	ret
    panic("brelse");
    800027ea:	00006517          	auipc	a0,0x6
    800027ee:	ce650513          	addi	a0,a0,-794 # 800084d0 <syscalls+0x100>
    800027f2:	00004097          	auipc	ra,0x4
    800027f6:	a12080e7          	jalr	-1518(ra) # 80006204 <panic>

00000000800027fa <bpin>:


void
bpin(struct buf *b) {
    800027fa:	1101                	addi	sp,sp,-32
    800027fc:	ec06                	sd	ra,24(sp)
    800027fe:	e822                	sd	s0,16(sp)
    80002800:	e426                	sd	s1,8(sp)
    80002802:	e04a                	sd	s2,0(sp)
    80002804:	1000                	addi	s0,sp,32
    80002806:	892a                	mv	s2,a0
  // change the lock - lab8-2
  int idx = HASH(b->blockno);
    80002808:	4544                	lw	s1,12(a0)
    8000280a:	47b5                	li	a5,13
    8000280c:	02f4f4bb          	remuw	s1,s1,a5
  acquire(&bcache.locks[idx]);
    80002810:	5e24849b          	addiw	s1,s1,1506
    80002814:	0496                	slli	s1,s1,0x5
    80002816:	0000d797          	auipc	a5,0xd
    8000281a:	a0278793          	addi	a5,a5,-1534 # 8000f218 <bcache+0x8>
    8000281e:	94be                	add	s1,s1,a5
    80002820:	8526                	mv	a0,s1
    80002822:	00004097          	auipc	ra,0x4
    80002826:	f04080e7          	jalr	-252(ra) # 80006726 <acquire>
  b->refcnt++;
    8000282a:	04892783          	lw	a5,72(s2)
    8000282e:	2785                	addiw	a5,a5,1
    80002830:	04f92423          	sw	a5,72(s2)
  release(&bcache.locks[idx]);
    80002834:	8526                	mv	a0,s1
    80002836:	00004097          	auipc	ra,0x4
    8000283a:	fc0080e7          	jalr	-64(ra) # 800067f6 <release>
}
    8000283e:	60e2                	ld	ra,24(sp)
    80002840:	6442                	ld	s0,16(sp)
    80002842:	64a2                	ld	s1,8(sp)
    80002844:	6902                	ld	s2,0(sp)
    80002846:	6105                	addi	sp,sp,32
    80002848:	8082                	ret

000000008000284a <bunpin>:

void
bunpin(struct buf *b) {
    8000284a:	1101                	addi	sp,sp,-32
    8000284c:	ec06                	sd	ra,24(sp)
    8000284e:	e822                	sd	s0,16(sp)
    80002850:	e426                	sd	s1,8(sp)
    80002852:	e04a                	sd	s2,0(sp)
    80002854:	1000                	addi	s0,sp,32
    80002856:	892a                	mv	s2,a0
  // change the lock - lab8-2
  int idx = HASH(b->blockno);
    80002858:	4544                	lw	s1,12(a0)
    8000285a:	47b5                	li	a5,13
    8000285c:	02f4f4bb          	remuw	s1,s1,a5
  acquire(&bcache.locks[idx]);
    80002860:	5e24849b          	addiw	s1,s1,1506
    80002864:	0496                	slli	s1,s1,0x5
    80002866:	0000d797          	auipc	a5,0xd
    8000286a:	9b278793          	addi	a5,a5,-1614 # 8000f218 <bcache+0x8>
    8000286e:	94be                	add	s1,s1,a5
    80002870:	8526                	mv	a0,s1
    80002872:	00004097          	auipc	ra,0x4
    80002876:	eb4080e7          	jalr	-332(ra) # 80006726 <acquire>
  b->refcnt--;
    8000287a:	04892783          	lw	a5,72(s2)
    8000287e:	37fd                	addiw	a5,a5,-1
    80002880:	04f92423          	sw	a5,72(s2)
  release(&bcache.locks[idx]);
    80002884:	8526                	mv	a0,s1
    80002886:	00004097          	auipc	ra,0x4
    8000288a:	f70080e7          	jalr	-144(ra) # 800067f6 <release>
}
    8000288e:	60e2                	ld	ra,24(sp)
    80002890:	6442                	ld	s0,16(sp)
    80002892:	64a2                	ld	s1,8(sp)
    80002894:	6902                	ld	s2,0(sp)
    80002896:	6105                	addi	sp,sp,32
    80002898:	8082                	ret

000000008000289a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000289a:	1101                	addi	sp,sp,-32
    8000289c:	ec06                	sd	ra,24(sp)
    8000289e:	e822                	sd	s0,16(sp)
    800028a0:	e426                	sd	s1,8(sp)
    800028a2:	e04a                	sd	s2,0(sp)
    800028a4:	1000                	addi	s0,sp,32
    800028a6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800028a8:	00d5d59b          	srliw	a1,a1,0xd
    800028ac:	00018797          	auipc	a5,0x18
    800028b0:	7887a783          	lw	a5,1928(a5) # 8001b034 <sb+0x1c>
    800028b4:	9dbd                	addw	a1,a1,a5
    800028b6:	00000097          	auipc	ra,0x0
    800028ba:	b80080e7          	jalr	-1152(ra) # 80002436 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800028be:	0074f713          	andi	a4,s1,7
    800028c2:	4785                	li	a5,1
    800028c4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800028c8:	14ce                	slli	s1,s1,0x33
    800028ca:	90d9                	srli	s1,s1,0x36
    800028cc:	00950733          	add	a4,a0,s1
    800028d0:	05874703          	lbu	a4,88(a4)
    800028d4:	00e7f6b3          	and	a3,a5,a4
    800028d8:	c69d                	beqz	a3,80002906 <bfree+0x6c>
    800028da:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800028dc:	94aa                	add	s1,s1,a0
    800028de:	fff7c793          	not	a5,a5
    800028e2:	8f7d                	and	a4,a4,a5
    800028e4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800028e8:	00001097          	auipc	ra,0x1
    800028ec:	120080e7          	jalr	288(ra) # 80003a08 <log_write>
  brelse(bp);
    800028f0:	854a                	mv	a0,s2
    800028f2:	00000097          	auipc	ra,0x0
    800028f6:	e7a080e7          	jalr	-390(ra) # 8000276c <brelse>
}
    800028fa:	60e2                	ld	ra,24(sp)
    800028fc:	6442                	ld	s0,16(sp)
    800028fe:	64a2                	ld	s1,8(sp)
    80002900:	6902                	ld	s2,0(sp)
    80002902:	6105                	addi	sp,sp,32
    80002904:	8082                	ret
    panic("freeing free block");
    80002906:	00006517          	auipc	a0,0x6
    8000290a:	bd250513          	addi	a0,a0,-1070 # 800084d8 <syscalls+0x108>
    8000290e:	00004097          	auipc	ra,0x4
    80002912:	8f6080e7          	jalr	-1802(ra) # 80006204 <panic>

0000000080002916 <balloc>:
{
    80002916:	711d                	addi	sp,sp,-96
    80002918:	ec86                	sd	ra,88(sp)
    8000291a:	e8a2                	sd	s0,80(sp)
    8000291c:	e4a6                	sd	s1,72(sp)
    8000291e:	e0ca                	sd	s2,64(sp)
    80002920:	fc4e                	sd	s3,56(sp)
    80002922:	f852                	sd	s4,48(sp)
    80002924:	f456                	sd	s5,40(sp)
    80002926:	f05a                	sd	s6,32(sp)
    80002928:	ec5e                	sd	s7,24(sp)
    8000292a:	e862                	sd	s8,16(sp)
    8000292c:	e466                	sd	s9,8(sp)
    8000292e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002930:	00018797          	auipc	a5,0x18
    80002934:	6ec7a783          	lw	a5,1772(a5) # 8001b01c <sb+0x4>
    80002938:	cbc1                	beqz	a5,800029c8 <balloc+0xb2>
    8000293a:	8baa                	mv	s7,a0
    8000293c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000293e:	00018b17          	auipc	s6,0x18
    80002942:	6dab0b13          	addi	s6,s6,1754 # 8001b018 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002946:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002948:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000294a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000294c:	6c89                	lui	s9,0x2
    8000294e:	a831                	j	8000296a <balloc+0x54>
    brelse(bp);
    80002950:	854a                	mv	a0,s2
    80002952:	00000097          	auipc	ra,0x0
    80002956:	e1a080e7          	jalr	-486(ra) # 8000276c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000295a:	015c87bb          	addw	a5,s9,s5
    8000295e:	00078a9b          	sext.w	s5,a5
    80002962:	004b2703          	lw	a4,4(s6)
    80002966:	06eaf163          	bgeu	s5,a4,800029c8 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000296a:	41fad79b          	sraiw	a5,s5,0x1f
    8000296e:	0137d79b          	srliw	a5,a5,0x13
    80002972:	015787bb          	addw	a5,a5,s5
    80002976:	40d7d79b          	sraiw	a5,a5,0xd
    8000297a:	01cb2583          	lw	a1,28(s6)
    8000297e:	9dbd                	addw	a1,a1,a5
    80002980:	855e                	mv	a0,s7
    80002982:	00000097          	auipc	ra,0x0
    80002986:	ab4080e7          	jalr	-1356(ra) # 80002436 <bread>
    8000298a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000298c:	004b2503          	lw	a0,4(s6)
    80002990:	000a849b          	sext.w	s1,s5
    80002994:	8762                	mv	a4,s8
    80002996:	faa4fde3          	bgeu	s1,a0,80002950 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000299a:	00777693          	andi	a3,a4,7
    8000299e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800029a2:	41f7579b          	sraiw	a5,a4,0x1f
    800029a6:	01d7d79b          	srliw	a5,a5,0x1d
    800029aa:	9fb9                	addw	a5,a5,a4
    800029ac:	4037d79b          	sraiw	a5,a5,0x3
    800029b0:	00f90633          	add	a2,s2,a5
    800029b4:	05864603          	lbu	a2,88(a2)
    800029b8:	00c6f5b3          	and	a1,a3,a2
    800029bc:	cd91                	beqz	a1,800029d8 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029be:	2705                	addiw	a4,a4,1
    800029c0:	2485                	addiw	s1,s1,1
    800029c2:	fd471ae3          	bne	a4,s4,80002996 <balloc+0x80>
    800029c6:	b769                	j	80002950 <balloc+0x3a>
  panic("balloc: out of blocks");
    800029c8:	00006517          	auipc	a0,0x6
    800029cc:	b2850513          	addi	a0,a0,-1240 # 800084f0 <syscalls+0x120>
    800029d0:	00004097          	auipc	ra,0x4
    800029d4:	834080e7          	jalr	-1996(ra) # 80006204 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800029d8:	97ca                	add	a5,a5,s2
    800029da:	8e55                	or	a2,a2,a3
    800029dc:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800029e0:	854a                	mv	a0,s2
    800029e2:	00001097          	auipc	ra,0x1
    800029e6:	026080e7          	jalr	38(ra) # 80003a08 <log_write>
        brelse(bp);
    800029ea:	854a                	mv	a0,s2
    800029ec:	00000097          	auipc	ra,0x0
    800029f0:	d80080e7          	jalr	-640(ra) # 8000276c <brelse>
  bp = bread(dev, bno);
    800029f4:	85a6                	mv	a1,s1
    800029f6:	855e                	mv	a0,s7
    800029f8:	00000097          	auipc	ra,0x0
    800029fc:	a3e080e7          	jalr	-1474(ra) # 80002436 <bread>
    80002a00:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002a02:	40000613          	li	a2,1024
    80002a06:	4581                	li	a1,0
    80002a08:	05850513          	addi	a0,a0,88
    80002a0c:	ffffe097          	auipc	ra,0xffffe
    80002a10:	906080e7          	jalr	-1786(ra) # 80000312 <memset>
  log_write(bp);
    80002a14:	854a                	mv	a0,s2
    80002a16:	00001097          	auipc	ra,0x1
    80002a1a:	ff2080e7          	jalr	-14(ra) # 80003a08 <log_write>
  brelse(bp);
    80002a1e:	854a                	mv	a0,s2
    80002a20:	00000097          	auipc	ra,0x0
    80002a24:	d4c080e7          	jalr	-692(ra) # 8000276c <brelse>
}
    80002a28:	8526                	mv	a0,s1
    80002a2a:	60e6                	ld	ra,88(sp)
    80002a2c:	6446                	ld	s0,80(sp)
    80002a2e:	64a6                	ld	s1,72(sp)
    80002a30:	6906                	ld	s2,64(sp)
    80002a32:	79e2                	ld	s3,56(sp)
    80002a34:	7a42                	ld	s4,48(sp)
    80002a36:	7aa2                	ld	s5,40(sp)
    80002a38:	7b02                	ld	s6,32(sp)
    80002a3a:	6be2                	ld	s7,24(sp)
    80002a3c:	6c42                	ld	s8,16(sp)
    80002a3e:	6ca2                	ld	s9,8(sp)
    80002a40:	6125                	addi	sp,sp,96
    80002a42:	8082                	ret

0000000080002a44 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002a44:	7179                	addi	sp,sp,-48
    80002a46:	f406                	sd	ra,40(sp)
    80002a48:	f022                	sd	s0,32(sp)
    80002a4a:	ec26                	sd	s1,24(sp)
    80002a4c:	e84a                	sd	s2,16(sp)
    80002a4e:	e44e                	sd	s3,8(sp)
    80002a50:	e052                	sd	s4,0(sp)
    80002a52:	1800                	addi	s0,sp,48
    80002a54:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002a56:	47ad                	li	a5,11
    80002a58:	04b7fe63          	bgeu	a5,a1,80002ab4 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002a5c:	ff45849b          	addiw	s1,a1,-12
    80002a60:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a64:	0ff00793          	li	a5,255
    80002a68:	0ae7e463          	bltu	a5,a4,80002b10 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002a6c:	08852583          	lw	a1,136(a0)
    80002a70:	c5b5                	beqz	a1,80002adc <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002a72:	00092503          	lw	a0,0(s2)
    80002a76:	00000097          	auipc	ra,0x0
    80002a7a:	9c0080e7          	jalr	-1600(ra) # 80002436 <bread>
    80002a7e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a80:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a84:	02049713          	slli	a4,s1,0x20
    80002a88:	01e75593          	srli	a1,a4,0x1e
    80002a8c:	00b784b3          	add	s1,a5,a1
    80002a90:	0004a983          	lw	s3,0(s1)
    80002a94:	04098e63          	beqz	s3,80002af0 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002a98:	8552                	mv	a0,s4
    80002a9a:	00000097          	auipc	ra,0x0
    80002a9e:	cd2080e7          	jalr	-814(ra) # 8000276c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002aa2:	854e                	mv	a0,s3
    80002aa4:	70a2                	ld	ra,40(sp)
    80002aa6:	7402                	ld	s0,32(sp)
    80002aa8:	64e2                	ld	s1,24(sp)
    80002aaa:	6942                	ld	s2,16(sp)
    80002aac:	69a2                	ld	s3,8(sp)
    80002aae:	6a02                	ld	s4,0(sp)
    80002ab0:	6145                	addi	sp,sp,48
    80002ab2:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002ab4:	02059793          	slli	a5,a1,0x20
    80002ab8:	01e7d593          	srli	a1,a5,0x1e
    80002abc:	00b504b3          	add	s1,a0,a1
    80002ac0:	0584a983          	lw	s3,88(s1)
    80002ac4:	fc099fe3          	bnez	s3,80002aa2 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002ac8:	4108                	lw	a0,0(a0)
    80002aca:	00000097          	auipc	ra,0x0
    80002ace:	e4c080e7          	jalr	-436(ra) # 80002916 <balloc>
    80002ad2:	0005099b          	sext.w	s3,a0
    80002ad6:	0534ac23          	sw	s3,88(s1)
    80002ada:	b7e1                	j	80002aa2 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002adc:	4108                	lw	a0,0(a0)
    80002ade:	00000097          	auipc	ra,0x0
    80002ae2:	e38080e7          	jalr	-456(ra) # 80002916 <balloc>
    80002ae6:	0005059b          	sext.w	a1,a0
    80002aea:	08b92423          	sw	a1,136(s2)
    80002aee:	b751                	j	80002a72 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002af0:	00092503          	lw	a0,0(s2)
    80002af4:	00000097          	auipc	ra,0x0
    80002af8:	e22080e7          	jalr	-478(ra) # 80002916 <balloc>
    80002afc:	0005099b          	sext.w	s3,a0
    80002b00:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002b04:	8552                	mv	a0,s4
    80002b06:	00001097          	auipc	ra,0x1
    80002b0a:	f02080e7          	jalr	-254(ra) # 80003a08 <log_write>
    80002b0e:	b769                	j	80002a98 <bmap+0x54>
  panic("bmap: out of range");
    80002b10:	00006517          	auipc	a0,0x6
    80002b14:	9f850513          	addi	a0,a0,-1544 # 80008508 <syscalls+0x138>
    80002b18:	00003097          	auipc	ra,0x3
    80002b1c:	6ec080e7          	jalr	1772(ra) # 80006204 <panic>

0000000080002b20 <iget>:
{
    80002b20:	7179                	addi	sp,sp,-48
    80002b22:	f406                	sd	ra,40(sp)
    80002b24:	f022                	sd	s0,32(sp)
    80002b26:	ec26                	sd	s1,24(sp)
    80002b28:	e84a                	sd	s2,16(sp)
    80002b2a:	e44e                	sd	s3,8(sp)
    80002b2c:	e052                	sd	s4,0(sp)
    80002b2e:	1800                	addi	s0,sp,48
    80002b30:	89aa                	mv	s3,a0
    80002b32:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b34:	00018517          	auipc	a0,0x18
    80002b38:	50450513          	addi	a0,a0,1284 # 8001b038 <itable>
    80002b3c:	00004097          	auipc	ra,0x4
    80002b40:	bea080e7          	jalr	-1046(ra) # 80006726 <acquire>
  empty = 0;
    80002b44:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b46:	00018497          	auipc	s1,0x18
    80002b4a:	51248493          	addi	s1,s1,1298 # 8001b058 <itable+0x20>
    80002b4e:	0001a697          	auipc	a3,0x1a
    80002b52:	12a68693          	addi	a3,a3,298 # 8001cc78 <log>
    80002b56:	a039                	j	80002b64 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b58:	02090b63          	beqz	s2,80002b8e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b5c:	09048493          	addi	s1,s1,144
    80002b60:	02d48a63          	beq	s1,a3,80002b94 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b64:	449c                	lw	a5,8(s1)
    80002b66:	fef059e3          	blez	a5,80002b58 <iget+0x38>
    80002b6a:	4098                	lw	a4,0(s1)
    80002b6c:	ff3716e3          	bne	a4,s3,80002b58 <iget+0x38>
    80002b70:	40d8                	lw	a4,4(s1)
    80002b72:	ff4713e3          	bne	a4,s4,80002b58 <iget+0x38>
      ip->ref++;
    80002b76:	2785                	addiw	a5,a5,1
    80002b78:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b7a:	00018517          	auipc	a0,0x18
    80002b7e:	4be50513          	addi	a0,a0,1214 # 8001b038 <itable>
    80002b82:	00004097          	auipc	ra,0x4
    80002b86:	c74080e7          	jalr	-908(ra) # 800067f6 <release>
      return ip;
    80002b8a:	8926                	mv	s2,s1
    80002b8c:	a03d                	j	80002bba <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b8e:	f7f9                	bnez	a5,80002b5c <iget+0x3c>
    80002b90:	8926                	mv	s2,s1
    80002b92:	b7e9                	j	80002b5c <iget+0x3c>
  if(empty == 0)
    80002b94:	02090c63          	beqz	s2,80002bcc <iget+0xac>
  ip->dev = dev;
    80002b98:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b9c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ba0:	4785                	li	a5,1
    80002ba2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002ba6:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002baa:	00018517          	auipc	a0,0x18
    80002bae:	48e50513          	addi	a0,a0,1166 # 8001b038 <itable>
    80002bb2:	00004097          	auipc	ra,0x4
    80002bb6:	c44080e7          	jalr	-956(ra) # 800067f6 <release>
}
    80002bba:	854a                	mv	a0,s2
    80002bbc:	70a2                	ld	ra,40(sp)
    80002bbe:	7402                	ld	s0,32(sp)
    80002bc0:	64e2                	ld	s1,24(sp)
    80002bc2:	6942                	ld	s2,16(sp)
    80002bc4:	69a2                	ld	s3,8(sp)
    80002bc6:	6a02                	ld	s4,0(sp)
    80002bc8:	6145                	addi	sp,sp,48
    80002bca:	8082                	ret
    panic("iget: no inodes");
    80002bcc:	00006517          	auipc	a0,0x6
    80002bd0:	95450513          	addi	a0,a0,-1708 # 80008520 <syscalls+0x150>
    80002bd4:	00003097          	auipc	ra,0x3
    80002bd8:	630080e7          	jalr	1584(ra) # 80006204 <panic>

0000000080002bdc <fsinit>:
fsinit(int dev) {
    80002bdc:	7179                	addi	sp,sp,-48
    80002bde:	f406                	sd	ra,40(sp)
    80002be0:	f022                	sd	s0,32(sp)
    80002be2:	ec26                	sd	s1,24(sp)
    80002be4:	e84a                	sd	s2,16(sp)
    80002be6:	e44e                	sd	s3,8(sp)
    80002be8:	1800                	addi	s0,sp,48
    80002bea:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002bec:	4585                	li	a1,1
    80002bee:	00000097          	auipc	ra,0x0
    80002bf2:	848080e7          	jalr	-1976(ra) # 80002436 <bread>
    80002bf6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002bf8:	00018997          	auipc	s3,0x18
    80002bfc:	42098993          	addi	s3,s3,1056 # 8001b018 <sb>
    80002c00:	02000613          	li	a2,32
    80002c04:	05850593          	addi	a1,a0,88
    80002c08:	854e                	mv	a0,s3
    80002c0a:	ffffd097          	auipc	ra,0xffffd
    80002c0e:	764080e7          	jalr	1892(ra) # 8000036e <memmove>
  brelse(bp);
    80002c12:	8526                	mv	a0,s1
    80002c14:	00000097          	auipc	ra,0x0
    80002c18:	b58080e7          	jalr	-1192(ra) # 8000276c <brelse>
  if(sb.magic != FSMAGIC)
    80002c1c:	0009a703          	lw	a4,0(s3)
    80002c20:	102037b7          	lui	a5,0x10203
    80002c24:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c28:	02f71263          	bne	a4,a5,80002c4c <fsinit+0x70>
  initlog(dev, &sb);
    80002c2c:	00018597          	auipc	a1,0x18
    80002c30:	3ec58593          	addi	a1,a1,1004 # 8001b018 <sb>
    80002c34:	854a                	mv	a0,s2
    80002c36:	00001097          	auipc	ra,0x1
    80002c3a:	b56080e7          	jalr	-1194(ra) # 8000378c <initlog>
}
    80002c3e:	70a2                	ld	ra,40(sp)
    80002c40:	7402                	ld	s0,32(sp)
    80002c42:	64e2                	ld	s1,24(sp)
    80002c44:	6942                	ld	s2,16(sp)
    80002c46:	69a2                	ld	s3,8(sp)
    80002c48:	6145                	addi	sp,sp,48
    80002c4a:	8082                	ret
    panic("invalid file system");
    80002c4c:	00006517          	auipc	a0,0x6
    80002c50:	8e450513          	addi	a0,a0,-1820 # 80008530 <syscalls+0x160>
    80002c54:	00003097          	auipc	ra,0x3
    80002c58:	5b0080e7          	jalr	1456(ra) # 80006204 <panic>

0000000080002c5c <iinit>:
{
    80002c5c:	7179                	addi	sp,sp,-48
    80002c5e:	f406                	sd	ra,40(sp)
    80002c60:	f022                	sd	s0,32(sp)
    80002c62:	ec26                	sd	s1,24(sp)
    80002c64:	e84a                	sd	s2,16(sp)
    80002c66:	e44e                	sd	s3,8(sp)
    80002c68:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c6a:	00006597          	auipc	a1,0x6
    80002c6e:	8de58593          	addi	a1,a1,-1826 # 80008548 <syscalls+0x178>
    80002c72:	00018517          	auipc	a0,0x18
    80002c76:	3c650513          	addi	a0,a0,966 # 8001b038 <itable>
    80002c7a:	00004097          	auipc	ra,0x4
    80002c7e:	c28080e7          	jalr	-984(ra) # 800068a2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c82:	00018497          	auipc	s1,0x18
    80002c86:	3e648493          	addi	s1,s1,998 # 8001b068 <itable+0x30>
    80002c8a:	0001a997          	auipc	s3,0x1a
    80002c8e:	ffe98993          	addi	s3,s3,-2 # 8001cc88 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c92:	00006917          	auipc	s2,0x6
    80002c96:	8be90913          	addi	s2,s2,-1858 # 80008550 <syscalls+0x180>
    80002c9a:	85ca                	mv	a1,s2
    80002c9c:	8526                	mv	a0,s1
    80002c9e:	00001097          	auipc	ra,0x1
    80002ca2:	e4e080e7          	jalr	-434(ra) # 80003aec <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ca6:	09048493          	addi	s1,s1,144
    80002caa:	ff3498e3          	bne	s1,s3,80002c9a <iinit+0x3e>
}
    80002cae:	70a2                	ld	ra,40(sp)
    80002cb0:	7402                	ld	s0,32(sp)
    80002cb2:	64e2                	ld	s1,24(sp)
    80002cb4:	6942                	ld	s2,16(sp)
    80002cb6:	69a2                	ld	s3,8(sp)
    80002cb8:	6145                	addi	sp,sp,48
    80002cba:	8082                	ret

0000000080002cbc <ialloc>:
{
    80002cbc:	715d                	addi	sp,sp,-80
    80002cbe:	e486                	sd	ra,72(sp)
    80002cc0:	e0a2                	sd	s0,64(sp)
    80002cc2:	fc26                	sd	s1,56(sp)
    80002cc4:	f84a                	sd	s2,48(sp)
    80002cc6:	f44e                	sd	s3,40(sp)
    80002cc8:	f052                	sd	s4,32(sp)
    80002cca:	ec56                	sd	s5,24(sp)
    80002ccc:	e85a                	sd	s6,16(sp)
    80002cce:	e45e                	sd	s7,8(sp)
    80002cd0:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002cd2:	00018717          	auipc	a4,0x18
    80002cd6:	35272703          	lw	a4,850(a4) # 8001b024 <sb+0xc>
    80002cda:	4785                	li	a5,1
    80002cdc:	04e7fa63          	bgeu	a5,a4,80002d30 <ialloc+0x74>
    80002ce0:	8aaa                	mv	s5,a0
    80002ce2:	8bae                	mv	s7,a1
    80002ce4:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ce6:	00018a17          	auipc	s4,0x18
    80002cea:	332a0a13          	addi	s4,s4,818 # 8001b018 <sb>
    80002cee:	00048b1b          	sext.w	s6,s1
    80002cf2:	0044d593          	srli	a1,s1,0x4
    80002cf6:	018a2783          	lw	a5,24(s4)
    80002cfa:	9dbd                	addw	a1,a1,a5
    80002cfc:	8556                	mv	a0,s5
    80002cfe:	fffff097          	auipc	ra,0xfffff
    80002d02:	738080e7          	jalr	1848(ra) # 80002436 <bread>
    80002d06:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002d08:	05850993          	addi	s3,a0,88
    80002d0c:	00f4f793          	andi	a5,s1,15
    80002d10:	079a                	slli	a5,a5,0x6
    80002d12:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002d14:	00099783          	lh	a5,0(s3)
    80002d18:	c785                	beqz	a5,80002d40 <ialloc+0x84>
    brelse(bp);
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	a52080e7          	jalr	-1454(ra) # 8000276c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d22:	0485                	addi	s1,s1,1
    80002d24:	00ca2703          	lw	a4,12(s4)
    80002d28:	0004879b          	sext.w	a5,s1
    80002d2c:	fce7e1e3          	bltu	a5,a4,80002cee <ialloc+0x32>
  panic("ialloc: no inodes");
    80002d30:	00006517          	auipc	a0,0x6
    80002d34:	82850513          	addi	a0,a0,-2008 # 80008558 <syscalls+0x188>
    80002d38:	00003097          	auipc	ra,0x3
    80002d3c:	4cc080e7          	jalr	1228(ra) # 80006204 <panic>
      memset(dip, 0, sizeof(*dip));
    80002d40:	04000613          	li	a2,64
    80002d44:	4581                	li	a1,0
    80002d46:	854e                	mv	a0,s3
    80002d48:	ffffd097          	auipc	ra,0xffffd
    80002d4c:	5ca080e7          	jalr	1482(ra) # 80000312 <memset>
      dip->type = type;
    80002d50:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002d54:	854a                	mv	a0,s2
    80002d56:	00001097          	auipc	ra,0x1
    80002d5a:	cb2080e7          	jalr	-846(ra) # 80003a08 <log_write>
      brelse(bp);
    80002d5e:	854a                	mv	a0,s2
    80002d60:	00000097          	auipc	ra,0x0
    80002d64:	a0c080e7          	jalr	-1524(ra) # 8000276c <brelse>
      return iget(dev, inum);
    80002d68:	85da                	mv	a1,s6
    80002d6a:	8556                	mv	a0,s5
    80002d6c:	00000097          	auipc	ra,0x0
    80002d70:	db4080e7          	jalr	-588(ra) # 80002b20 <iget>
}
    80002d74:	60a6                	ld	ra,72(sp)
    80002d76:	6406                	ld	s0,64(sp)
    80002d78:	74e2                	ld	s1,56(sp)
    80002d7a:	7942                	ld	s2,48(sp)
    80002d7c:	79a2                	ld	s3,40(sp)
    80002d7e:	7a02                	ld	s4,32(sp)
    80002d80:	6ae2                	ld	s5,24(sp)
    80002d82:	6b42                	ld	s6,16(sp)
    80002d84:	6ba2                	ld	s7,8(sp)
    80002d86:	6161                	addi	sp,sp,80
    80002d88:	8082                	ret

0000000080002d8a <iupdate>:
{
    80002d8a:	1101                	addi	sp,sp,-32
    80002d8c:	ec06                	sd	ra,24(sp)
    80002d8e:	e822                	sd	s0,16(sp)
    80002d90:	e426                	sd	s1,8(sp)
    80002d92:	e04a                	sd	s2,0(sp)
    80002d94:	1000                	addi	s0,sp,32
    80002d96:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d98:	415c                	lw	a5,4(a0)
    80002d9a:	0047d79b          	srliw	a5,a5,0x4
    80002d9e:	00018597          	auipc	a1,0x18
    80002da2:	2925a583          	lw	a1,658(a1) # 8001b030 <sb+0x18>
    80002da6:	9dbd                	addw	a1,a1,a5
    80002da8:	4108                	lw	a0,0(a0)
    80002daa:	fffff097          	auipc	ra,0xfffff
    80002dae:	68c080e7          	jalr	1676(ra) # 80002436 <bread>
    80002db2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002db4:	05850793          	addi	a5,a0,88
    80002db8:	40d8                	lw	a4,4(s1)
    80002dba:	8b3d                	andi	a4,a4,15
    80002dbc:	071a                	slli	a4,a4,0x6
    80002dbe:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002dc0:	04c49703          	lh	a4,76(s1)
    80002dc4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002dc8:	04e49703          	lh	a4,78(s1)
    80002dcc:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002dd0:	05049703          	lh	a4,80(s1)
    80002dd4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002dd8:	05249703          	lh	a4,82(s1)
    80002ddc:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002de0:	48f8                	lw	a4,84(s1)
    80002de2:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002de4:	03400613          	li	a2,52
    80002de8:	05848593          	addi	a1,s1,88
    80002dec:	00c78513          	addi	a0,a5,12
    80002df0:	ffffd097          	auipc	ra,0xffffd
    80002df4:	57e080e7          	jalr	1406(ra) # 8000036e <memmove>
  log_write(bp);
    80002df8:	854a                	mv	a0,s2
    80002dfa:	00001097          	auipc	ra,0x1
    80002dfe:	c0e080e7          	jalr	-1010(ra) # 80003a08 <log_write>
  brelse(bp);
    80002e02:	854a                	mv	a0,s2
    80002e04:	00000097          	auipc	ra,0x0
    80002e08:	968080e7          	jalr	-1688(ra) # 8000276c <brelse>
}
    80002e0c:	60e2                	ld	ra,24(sp)
    80002e0e:	6442                	ld	s0,16(sp)
    80002e10:	64a2                	ld	s1,8(sp)
    80002e12:	6902                	ld	s2,0(sp)
    80002e14:	6105                	addi	sp,sp,32
    80002e16:	8082                	ret

0000000080002e18 <idup>:
{
    80002e18:	1101                	addi	sp,sp,-32
    80002e1a:	ec06                	sd	ra,24(sp)
    80002e1c:	e822                	sd	s0,16(sp)
    80002e1e:	e426                	sd	s1,8(sp)
    80002e20:	1000                	addi	s0,sp,32
    80002e22:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e24:	00018517          	auipc	a0,0x18
    80002e28:	21450513          	addi	a0,a0,532 # 8001b038 <itable>
    80002e2c:	00004097          	auipc	ra,0x4
    80002e30:	8fa080e7          	jalr	-1798(ra) # 80006726 <acquire>
  ip->ref++;
    80002e34:	449c                	lw	a5,8(s1)
    80002e36:	2785                	addiw	a5,a5,1
    80002e38:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e3a:	00018517          	auipc	a0,0x18
    80002e3e:	1fe50513          	addi	a0,a0,510 # 8001b038 <itable>
    80002e42:	00004097          	auipc	ra,0x4
    80002e46:	9b4080e7          	jalr	-1612(ra) # 800067f6 <release>
}
    80002e4a:	8526                	mv	a0,s1
    80002e4c:	60e2                	ld	ra,24(sp)
    80002e4e:	6442                	ld	s0,16(sp)
    80002e50:	64a2                	ld	s1,8(sp)
    80002e52:	6105                	addi	sp,sp,32
    80002e54:	8082                	ret

0000000080002e56 <ilock>:
{
    80002e56:	1101                	addi	sp,sp,-32
    80002e58:	ec06                	sd	ra,24(sp)
    80002e5a:	e822                	sd	s0,16(sp)
    80002e5c:	e426                	sd	s1,8(sp)
    80002e5e:	e04a                	sd	s2,0(sp)
    80002e60:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002e62:	c115                	beqz	a0,80002e86 <ilock+0x30>
    80002e64:	84aa                	mv	s1,a0
    80002e66:	451c                	lw	a5,8(a0)
    80002e68:	00f05f63          	blez	a5,80002e86 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002e6c:	0541                	addi	a0,a0,16
    80002e6e:	00001097          	auipc	ra,0x1
    80002e72:	cb8080e7          	jalr	-840(ra) # 80003b26 <acquiresleep>
  if(ip->valid == 0){
    80002e76:	44bc                	lw	a5,72(s1)
    80002e78:	cf99                	beqz	a5,80002e96 <ilock+0x40>
}
    80002e7a:	60e2                	ld	ra,24(sp)
    80002e7c:	6442                	ld	s0,16(sp)
    80002e7e:	64a2                	ld	s1,8(sp)
    80002e80:	6902                	ld	s2,0(sp)
    80002e82:	6105                	addi	sp,sp,32
    80002e84:	8082                	ret
    panic("ilock");
    80002e86:	00005517          	auipc	a0,0x5
    80002e8a:	6ea50513          	addi	a0,a0,1770 # 80008570 <syscalls+0x1a0>
    80002e8e:	00003097          	auipc	ra,0x3
    80002e92:	376080e7          	jalr	886(ra) # 80006204 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e96:	40dc                	lw	a5,4(s1)
    80002e98:	0047d79b          	srliw	a5,a5,0x4
    80002e9c:	00018597          	auipc	a1,0x18
    80002ea0:	1945a583          	lw	a1,404(a1) # 8001b030 <sb+0x18>
    80002ea4:	9dbd                	addw	a1,a1,a5
    80002ea6:	4088                	lw	a0,0(s1)
    80002ea8:	fffff097          	auipc	ra,0xfffff
    80002eac:	58e080e7          	jalr	1422(ra) # 80002436 <bread>
    80002eb0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002eb2:	05850593          	addi	a1,a0,88
    80002eb6:	40dc                	lw	a5,4(s1)
    80002eb8:	8bbd                	andi	a5,a5,15
    80002eba:	079a                	slli	a5,a5,0x6
    80002ebc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ebe:	00059783          	lh	a5,0(a1)
    80002ec2:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002ec6:	00259783          	lh	a5,2(a1)
    80002eca:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002ece:	00459783          	lh	a5,4(a1)
    80002ed2:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002ed6:	00659783          	lh	a5,6(a1)
    80002eda:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002ede:	459c                	lw	a5,8(a1)
    80002ee0:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002ee2:	03400613          	li	a2,52
    80002ee6:	05b1                	addi	a1,a1,12
    80002ee8:	05848513          	addi	a0,s1,88
    80002eec:	ffffd097          	auipc	ra,0xffffd
    80002ef0:	482080e7          	jalr	1154(ra) # 8000036e <memmove>
    brelse(bp);
    80002ef4:	854a                	mv	a0,s2
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	876080e7          	jalr	-1930(ra) # 8000276c <brelse>
    ip->valid = 1;
    80002efe:	4785                	li	a5,1
    80002f00:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002f02:	04c49783          	lh	a5,76(s1)
    80002f06:	fbb5                	bnez	a5,80002e7a <ilock+0x24>
      panic("ilock: no type");
    80002f08:	00005517          	auipc	a0,0x5
    80002f0c:	67050513          	addi	a0,a0,1648 # 80008578 <syscalls+0x1a8>
    80002f10:	00003097          	auipc	ra,0x3
    80002f14:	2f4080e7          	jalr	756(ra) # 80006204 <panic>

0000000080002f18 <iunlock>:
{
    80002f18:	1101                	addi	sp,sp,-32
    80002f1a:	ec06                	sd	ra,24(sp)
    80002f1c:	e822                	sd	s0,16(sp)
    80002f1e:	e426                	sd	s1,8(sp)
    80002f20:	e04a                	sd	s2,0(sp)
    80002f22:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002f24:	c905                	beqz	a0,80002f54 <iunlock+0x3c>
    80002f26:	84aa                	mv	s1,a0
    80002f28:	01050913          	addi	s2,a0,16
    80002f2c:	854a                	mv	a0,s2
    80002f2e:	00001097          	auipc	ra,0x1
    80002f32:	c92080e7          	jalr	-878(ra) # 80003bc0 <holdingsleep>
    80002f36:	cd19                	beqz	a0,80002f54 <iunlock+0x3c>
    80002f38:	449c                	lw	a5,8(s1)
    80002f3a:	00f05d63          	blez	a5,80002f54 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f3e:	854a                	mv	a0,s2
    80002f40:	00001097          	auipc	ra,0x1
    80002f44:	c3c080e7          	jalr	-964(ra) # 80003b7c <releasesleep>
}
    80002f48:	60e2                	ld	ra,24(sp)
    80002f4a:	6442                	ld	s0,16(sp)
    80002f4c:	64a2                	ld	s1,8(sp)
    80002f4e:	6902                	ld	s2,0(sp)
    80002f50:	6105                	addi	sp,sp,32
    80002f52:	8082                	ret
    panic("iunlock");
    80002f54:	00005517          	auipc	a0,0x5
    80002f58:	63450513          	addi	a0,a0,1588 # 80008588 <syscalls+0x1b8>
    80002f5c:	00003097          	auipc	ra,0x3
    80002f60:	2a8080e7          	jalr	680(ra) # 80006204 <panic>

0000000080002f64 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002f64:	7179                	addi	sp,sp,-48
    80002f66:	f406                	sd	ra,40(sp)
    80002f68:	f022                	sd	s0,32(sp)
    80002f6a:	ec26                	sd	s1,24(sp)
    80002f6c:	e84a                	sd	s2,16(sp)
    80002f6e:	e44e                	sd	s3,8(sp)
    80002f70:	e052                	sd	s4,0(sp)
    80002f72:	1800                	addi	s0,sp,48
    80002f74:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f76:	05850493          	addi	s1,a0,88
    80002f7a:	08850913          	addi	s2,a0,136
    80002f7e:	a021                	j	80002f86 <itrunc+0x22>
    80002f80:	0491                	addi	s1,s1,4
    80002f82:	01248d63          	beq	s1,s2,80002f9c <itrunc+0x38>
    if(ip->addrs[i]){
    80002f86:	408c                	lw	a1,0(s1)
    80002f88:	dde5                	beqz	a1,80002f80 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002f8a:	0009a503          	lw	a0,0(s3)
    80002f8e:	00000097          	auipc	ra,0x0
    80002f92:	90c080e7          	jalr	-1780(ra) # 8000289a <bfree>
      ip->addrs[i] = 0;
    80002f96:	0004a023          	sw	zero,0(s1)
    80002f9a:	b7dd                	j	80002f80 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f9c:	0889a583          	lw	a1,136(s3)
    80002fa0:	e185                	bnez	a1,80002fc0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002fa2:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002fa6:	854e                	mv	a0,s3
    80002fa8:	00000097          	auipc	ra,0x0
    80002fac:	de2080e7          	jalr	-542(ra) # 80002d8a <iupdate>
}
    80002fb0:	70a2                	ld	ra,40(sp)
    80002fb2:	7402                	ld	s0,32(sp)
    80002fb4:	64e2                	ld	s1,24(sp)
    80002fb6:	6942                	ld	s2,16(sp)
    80002fb8:	69a2                	ld	s3,8(sp)
    80002fba:	6a02                	ld	s4,0(sp)
    80002fbc:	6145                	addi	sp,sp,48
    80002fbe:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002fc0:	0009a503          	lw	a0,0(s3)
    80002fc4:	fffff097          	auipc	ra,0xfffff
    80002fc8:	472080e7          	jalr	1138(ra) # 80002436 <bread>
    80002fcc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002fce:	05850493          	addi	s1,a0,88
    80002fd2:	45850913          	addi	s2,a0,1112
    80002fd6:	a021                	j	80002fde <itrunc+0x7a>
    80002fd8:	0491                	addi	s1,s1,4
    80002fda:	01248b63          	beq	s1,s2,80002ff0 <itrunc+0x8c>
      if(a[j])
    80002fde:	408c                	lw	a1,0(s1)
    80002fe0:	dde5                	beqz	a1,80002fd8 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002fe2:	0009a503          	lw	a0,0(s3)
    80002fe6:	00000097          	auipc	ra,0x0
    80002fea:	8b4080e7          	jalr	-1868(ra) # 8000289a <bfree>
    80002fee:	b7ed                	j	80002fd8 <itrunc+0x74>
    brelse(bp);
    80002ff0:	8552                	mv	a0,s4
    80002ff2:	fffff097          	auipc	ra,0xfffff
    80002ff6:	77a080e7          	jalr	1914(ra) # 8000276c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ffa:	0889a583          	lw	a1,136(s3)
    80002ffe:	0009a503          	lw	a0,0(s3)
    80003002:	00000097          	auipc	ra,0x0
    80003006:	898080e7          	jalr	-1896(ra) # 8000289a <bfree>
    ip->addrs[NDIRECT] = 0;
    8000300a:	0809a423          	sw	zero,136(s3)
    8000300e:	bf51                	j	80002fa2 <itrunc+0x3e>

0000000080003010 <iput>:
{
    80003010:	1101                	addi	sp,sp,-32
    80003012:	ec06                	sd	ra,24(sp)
    80003014:	e822                	sd	s0,16(sp)
    80003016:	e426                	sd	s1,8(sp)
    80003018:	e04a                	sd	s2,0(sp)
    8000301a:	1000                	addi	s0,sp,32
    8000301c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000301e:	00018517          	auipc	a0,0x18
    80003022:	01a50513          	addi	a0,a0,26 # 8001b038 <itable>
    80003026:	00003097          	auipc	ra,0x3
    8000302a:	700080e7          	jalr	1792(ra) # 80006726 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000302e:	4498                	lw	a4,8(s1)
    80003030:	4785                	li	a5,1
    80003032:	02f70363          	beq	a4,a5,80003058 <iput+0x48>
  ip->ref--;
    80003036:	449c                	lw	a5,8(s1)
    80003038:	37fd                	addiw	a5,a5,-1
    8000303a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000303c:	00018517          	auipc	a0,0x18
    80003040:	ffc50513          	addi	a0,a0,-4 # 8001b038 <itable>
    80003044:	00003097          	auipc	ra,0x3
    80003048:	7b2080e7          	jalr	1970(ra) # 800067f6 <release>
}
    8000304c:	60e2                	ld	ra,24(sp)
    8000304e:	6442                	ld	s0,16(sp)
    80003050:	64a2                	ld	s1,8(sp)
    80003052:	6902                	ld	s2,0(sp)
    80003054:	6105                	addi	sp,sp,32
    80003056:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003058:	44bc                	lw	a5,72(s1)
    8000305a:	dff1                	beqz	a5,80003036 <iput+0x26>
    8000305c:	05249783          	lh	a5,82(s1)
    80003060:	fbf9                	bnez	a5,80003036 <iput+0x26>
    acquiresleep(&ip->lock);
    80003062:	01048913          	addi	s2,s1,16
    80003066:	854a                	mv	a0,s2
    80003068:	00001097          	auipc	ra,0x1
    8000306c:	abe080e7          	jalr	-1346(ra) # 80003b26 <acquiresleep>
    release(&itable.lock);
    80003070:	00018517          	auipc	a0,0x18
    80003074:	fc850513          	addi	a0,a0,-56 # 8001b038 <itable>
    80003078:	00003097          	auipc	ra,0x3
    8000307c:	77e080e7          	jalr	1918(ra) # 800067f6 <release>
    itrunc(ip);
    80003080:	8526                	mv	a0,s1
    80003082:	00000097          	auipc	ra,0x0
    80003086:	ee2080e7          	jalr	-286(ra) # 80002f64 <itrunc>
    ip->type = 0;
    8000308a:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    8000308e:	8526                	mv	a0,s1
    80003090:	00000097          	auipc	ra,0x0
    80003094:	cfa080e7          	jalr	-774(ra) # 80002d8a <iupdate>
    ip->valid = 0;
    80003098:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    8000309c:	854a                	mv	a0,s2
    8000309e:	00001097          	auipc	ra,0x1
    800030a2:	ade080e7          	jalr	-1314(ra) # 80003b7c <releasesleep>
    acquire(&itable.lock);
    800030a6:	00018517          	auipc	a0,0x18
    800030aa:	f9250513          	addi	a0,a0,-110 # 8001b038 <itable>
    800030ae:	00003097          	auipc	ra,0x3
    800030b2:	678080e7          	jalr	1656(ra) # 80006726 <acquire>
    800030b6:	b741                	j	80003036 <iput+0x26>

00000000800030b8 <iunlockput>:
{
    800030b8:	1101                	addi	sp,sp,-32
    800030ba:	ec06                	sd	ra,24(sp)
    800030bc:	e822                	sd	s0,16(sp)
    800030be:	e426                	sd	s1,8(sp)
    800030c0:	1000                	addi	s0,sp,32
    800030c2:	84aa                	mv	s1,a0
  iunlock(ip);
    800030c4:	00000097          	auipc	ra,0x0
    800030c8:	e54080e7          	jalr	-428(ra) # 80002f18 <iunlock>
  iput(ip);
    800030cc:	8526                	mv	a0,s1
    800030ce:	00000097          	auipc	ra,0x0
    800030d2:	f42080e7          	jalr	-190(ra) # 80003010 <iput>
}
    800030d6:	60e2                	ld	ra,24(sp)
    800030d8:	6442                	ld	s0,16(sp)
    800030da:	64a2                	ld	s1,8(sp)
    800030dc:	6105                	addi	sp,sp,32
    800030de:	8082                	ret

00000000800030e0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800030e0:	1141                	addi	sp,sp,-16
    800030e2:	e422                	sd	s0,8(sp)
    800030e4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800030e6:	411c                	lw	a5,0(a0)
    800030e8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800030ea:	415c                	lw	a5,4(a0)
    800030ec:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800030ee:	04c51783          	lh	a5,76(a0)
    800030f2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800030f6:	05251783          	lh	a5,82(a0)
    800030fa:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800030fe:	05456783          	lwu	a5,84(a0)
    80003102:	e99c                	sd	a5,16(a1)
}
    80003104:	6422                	ld	s0,8(sp)
    80003106:	0141                	addi	sp,sp,16
    80003108:	8082                	ret

000000008000310a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000310a:	497c                	lw	a5,84(a0)
    8000310c:	0ed7e963          	bltu	a5,a3,800031fe <readi+0xf4>
{
    80003110:	7159                	addi	sp,sp,-112
    80003112:	f486                	sd	ra,104(sp)
    80003114:	f0a2                	sd	s0,96(sp)
    80003116:	eca6                	sd	s1,88(sp)
    80003118:	e8ca                	sd	s2,80(sp)
    8000311a:	e4ce                	sd	s3,72(sp)
    8000311c:	e0d2                	sd	s4,64(sp)
    8000311e:	fc56                	sd	s5,56(sp)
    80003120:	f85a                	sd	s6,48(sp)
    80003122:	f45e                	sd	s7,40(sp)
    80003124:	f062                	sd	s8,32(sp)
    80003126:	ec66                	sd	s9,24(sp)
    80003128:	e86a                	sd	s10,16(sp)
    8000312a:	e46e                	sd	s11,8(sp)
    8000312c:	1880                	addi	s0,sp,112
    8000312e:	8baa                	mv	s7,a0
    80003130:	8c2e                	mv	s8,a1
    80003132:	8ab2                	mv	s5,a2
    80003134:	84b6                	mv	s1,a3
    80003136:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003138:	9f35                	addw	a4,a4,a3
    return 0;
    8000313a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000313c:	0ad76063          	bltu	a4,a3,800031dc <readi+0xd2>
  if(off + n > ip->size)
    80003140:	00e7f463          	bgeu	a5,a4,80003148 <readi+0x3e>
    n = ip->size - off;
    80003144:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003148:	0a0b0963          	beqz	s6,800031fa <readi+0xf0>
    8000314c:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000314e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003152:	5cfd                	li	s9,-1
    80003154:	a82d                	j	8000318e <readi+0x84>
    80003156:	020a1d93          	slli	s11,s4,0x20
    8000315a:	020ddd93          	srli	s11,s11,0x20
    8000315e:	05890613          	addi	a2,s2,88
    80003162:	86ee                	mv	a3,s11
    80003164:	963a                	add	a2,a2,a4
    80003166:	85d6                	mv	a1,s5
    80003168:	8562                	mv	a0,s8
    8000316a:	fffff097          	auipc	ra,0xfffff
    8000316e:	8ea080e7          	jalr	-1814(ra) # 80001a54 <either_copyout>
    80003172:	05950d63          	beq	a0,s9,800031cc <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003176:	854a                	mv	a0,s2
    80003178:	fffff097          	auipc	ra,0xfffff
    8000317c:	5f4080e7          	jalr	1524(ra) # 8000276c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003180:	013a09bb          	addw	s3,s4,s3
    80003184:	009a04bb          	addw	s1,s4,s1
    80003188:	9aee                	add	s5,s5,s11
    8000318a:	0569f763          	bgeu	s3,s6,800031d8 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000318e:	000ba903          	lw	s2,0(s7)
    80003192:	00a4d59b          	srliw	a1,s1,0xa
    80003196:	855e                	mv	a0,s7
    80003198:	00000097          	auipc	ra,0x0
    8000319c:	8ac080e7          	jalr	-1876(ra) # 80002a44 <bmap>
    800031a0:	0005059b          	sext.w	a1,a0
    800031a4:	854a                	mv	a0,s2
    800031a6:	fffff097          	auipc	ra,0xfffff
    800031aa:	290080e7          	jalr	656(ra) # 80002436 <bread>
    800031ae:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031b0:	3ff4f713          	andi	a4,s1,1023
    800031b4:	40ed07bb          	subw	a5,s10,a4
    800031b8:	413b06bb          	subw	a3,s6,s3
    800031bc:	8a3e                	mv	s4,a5
    800031be:	2781                	sext.w	a5,a5
    800031c0:	0006861b          	sext.w	a2,a3
    800031c4:	f8f679e3          	bgeu	a2,a5,80003156 <readi+0x4c>
    800031c8:	8a36                	mv	s4,a3
    800031ca:	b771                	j	80003156 <readi+0x4c>
      brelse(bp);
    800031cc:	854a                	mv	a0,s2
    800031ce:	fffff097          	auipc	ra,0xfffff
    800031d2:	59e080e7          	jalr	1438(ra) # 8000276c <brelse>
      tot = -1;
    800031d6:	59fd                	li	s3,-1
  }
  return tot;
    800031d8:	0009851b          	sext.w	a0,s3
}
    800031dc:	70a6                	ld	ra,104(sp)
    800031de:	7406                	ld	s0,96(sp)
    800031e0:	64e6                	ld	s1,88(sp)
    800031e2:	6946                	ld	s2,80(sp)
    800031e4:	69a6                	ld	s3,72(sp)
    800031e6:	6a06                	ld	s4,64(sp)
    800031e8:	7ae2                	ld	s5,56(sp)
    800031ea:	7b42                	ld	s6,48(sp)
    800031ec:	7ba2                	ld	s7,40(sp)
    800031ee:	7c02                	ld	s8,32(sp)
    800031f0:	6ce2                	ld	s9,24(sp)
    800031f2:	6d42                	ld	s10,16(sp)
    800031f4:	6da2                	ld	s11,8(sp)
    800031f6:	6165                	addi	sp,sp,112
    800031f8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031fa:	89da                	mv	s3,s6
    800031fc:	bff1                	j	800031d8 <readi+0xce>
    return 0;
    800031fe:	4501                	li	a0,0
}
    80003200:	8082                	ret

0000000080003202 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003202:	497c                	lw	a5,84(a0)
    80003204:	10d7e863          	bltu	a5,a3,80003314 <writei+0x112>
{
    80003208:	7159                	addi	sp,sp,-112
    8000320a:	f486                	sd	ra,104(sp)
    8000320c:	f0a2                	sd	s0,96(sp)
    8000320e:	eca6                	sd	s1,88(sp)
    80003210:	e8ca                	sd	s2,80(sp)
    80003212:	e4ce                	sd	s3,72(sp)
    80003214:	e0d2                	sd	s4,64(sp)
    80003216:	fc56                	sd	s5,56(sp)
    80003218:	f85a                	sd	s6,48(sp)
    8000321a:	f45e                	sd	s7,40(sp)
    8000321c:	f062                	sd	s8,32(sp)
    8000321e:	ec66                	sd	s9,24(sp)
    80003220:	e86a                	sd	s10,16(sp)
    80003222:	e46e                	sd	s11,8(sp)
    80003224:	1880                	addi	s0,sp,112
    80003226:	8b2a                	mv	s6,a0
    80003228:	8c2e                	mv	s8,a1
    8000322a:	8ab2                	mv	s5,a2
    8000322c:	8936                	mv	s2,a3
    8000322e:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003230:	00e687bb          	addw	a5,a3,a4
    80003234:	0ed7e263          	bltu	a5,a3,80003318 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003238:	00043737          	lui	a4,0x43
    8000323c:	0ef76063          	bltu	a4,a5,8000331c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003240:	0c0b8863          	beqz	s7,80003310 <writei+0x10e>
    80003244:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003246:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000324a:	5cfd                	li	s9,-1
    8000324c:	a091                	j	80003290 <writei+0x8e>
    8000324e:	02099d93          	slli	s11,s3,0x20
    80003252:	020ddd93          	srli	s11,s11,0x20
    80003256:	05848513          	addi	a0,s1,88
    8000325a:	86ee                	mv	a3,s11
    8000325c:	8656                	mv	a2,s5
    8000325e:	85e2                	mv	a1,s8
    80003260:	953a                	add	a0,a0,a4
    80003262:	fffff097          	auipc	ra,0xfffff
    80003266:	848080e7          	jalr	-1976(ra) # 80001aaa <either_copyin>
    8000326a:	07950263          	beq	a0,s9,800032ce <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000326e:	8526                	mv	a0,s1
    80003270:	00000097          	auipc	ra,0x0
    80003274:	798080e7          	jalr	1944(ra) # 80003a08 <log_write>
    brelse(bp);
    80003278:	8526                	mv	a0,s1
    8000327a:	fffff097          	auipc	ra,0xfffff
    8000327e:	4f2080e7          	jalr	1266(ra) # 8000276c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003282:	01498a3b          	addw	s4,s3,s4
    80003286:	0129893b          	addw	s2,s3,s2
    8000328a:	9aee                	add	s5,s5,s11
    8000328c:	057a7663          	bgeu	s4,s7,800032d8 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003290:	000b2483          	lw	s1,0(s6)
    80003294:	00a9559b          	srliw	a1,s2,0xa
    80003298:	855a                	mv	a0,s6
    8000329a:	fffff097          	auipc	ra,0xfffff
    8000329e:	7aa080e7          	jalr	1962(ra) # 80002a44 <bmap>
    800032a2:	0005059b          	sext.w	a1,a0
    800032a6:	8526                	mv	a0,s1
    800032a8:	fffff097          	auipc	ra,0xfffff
    800032ac:	18e080e7          	jalr	398(ra) # 80002436 <bread>
    800032b0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800032b2:	3ff97713          	andi	a4,s2,1023
    800032b6:	40ed07bb          	subw	a5,s10,a4
    800032ba:	414b86bb          	subw	a3,s7,s4
    800032be:	89be                	mv	s3,a5
    800032c0:	2781                	sext.w	a5,a5
    800032c2:	0006861b          	sext.w	a2,a3
    800032c6:	f8f674e3          	bgeu	a2,a5,8000324e <writei+0x4c>
    800032ca:	89b6                	mv	s3,a3
    800032cc:	b749                	j	8000324e <writei+0x4c>
      brelse(bp);
    800032ce:	8526                	mv	a0,s1
    800032d0:	fffff097          	auipc	ra,0xfffff
    800032d4:	49c080e7          	jalr	1180(ra) # 8000276c <brelse>
  }

  if(off > ip->size)
    800032d8:	054b2783          	lw	a5,84(s6)
    800032dc:	0127f463          	bgeu	a5,s2,800032e4 <writei+0xe2>
    ip->size = off;
    800032e0:	052b2a23          	sw	s2,84(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800032e4:	855a                	mv	a0,s6
    800032e6:	00000097          	auipc	ra,0x0
    800032ea:	aa4080e7          	jalr	-1372(ra) # 80002d8a <iupdate>

  return tot;
    800032ee:	000a051b          	sext.w	a0,s4
}
    800032f2:	70a6                	ld	ra,104(sp)
    800032f4:	7406                	ld	s0,96(sp)
    800032f6:	64e6                	ld	s1,88(sp)
    800032f8:	6946                	ld	s2,80(sp)
    800032fa:	69a6                	ld	s3,72(sp)
    800032fc:	6a06                	ld	s4,64(sp)
    800032fe:	7ae2                	ld	s5,56(sp)
    80003300:	7b42                	ld	s6,48(sp)
    80003302:	7ba2                	ld	s7,40(sp)
    80003304:	7c02                	ld	s8,32(sp)
    80003306:	6ce2                	ld	s9,24(sp)
    80003308:	6d42                	ld	s10,16(sp)
    8000330a:	6da2                	ld	s11,8(sp)
    8000330c:	6165                	addi	sp,sp,112
    8000330e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003310:	8a5e                	mv	s4,s7
    80003312:	bfc9                	j	800032e4 <writei+0xe2>
    return -1;
    80003314:	557d                	li	a0,-1
}
    80003316:	8082                	ret
    return -1;
    80003318:	557d                	li	a0,-1
    8000331a:	bfe1                	j	800032f2 <writei+0xf0>
    return -1;
    8000331c:	557d                	li	a0,-1
    8000331e:	bfd1                	j	800032f2 <writei+0xf0>

0000000080003320 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003320:	1141                	addi	sp,sp,-16
    80003322:	e406                	sd	ra,8(sp)
    80003324:	e022                	sd	s0,0(sp)
    80003326:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003328:	4639                	li	a2,14
    8000332a:	ffffd097          	auipc	ra,0xffffd
    8000332e:	0b8080e7          	jalr	184(ra) # 800003e2 <strncmp>
}
    80003332:	60a2                	ld	ra,8(sp)
    80003334:	6402                	ld	s0,0(sp)
    80003336:	0141                	addi	sp,sp,16
    80003338:	8082                	ret

000000008000333a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000333a:	7139                	addi	sp,sp,-64
    8000333c:	fc06                	sd	ra,56(sp)
    8000333e:	f822                	sd	s0,48(sp)
    80003340:	f426                	sd	s1,40(sp)
    80003342:	f04a                	sd	s2,32(sp)
    80003344:	ec4e                	sd	s3,24(sp)
    80003346:	e852                	sd	s4,16(sp)
    80003348:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000334a:	04c51703          	lh	a4,76(a0)
    8000334e:	4785                	li	a5,1
    80003350:	00f71a63          	bne	a4,a5,80003364 <dirlookup+0x2a>
    80003354:	892a                	mv	s2,a0
    80003356:	89ae                	mv	s3,a1
    80003358:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000335a:	497c                	lw	a5,84(a0)
    8000335c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000335e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003360:	e79d                	bnez	a5,8000338e <dirlookup+0x54>
    80003362:	a8a5                	j	800033da <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003364:	00005517          	auipc	a0,0x5
    80003368:	22c50513          	addi	a0,a0,556 # 80008590 <syscalls+0x1c0>
    8000336c:	00003097          	auipc	ra,0x3
    80003370:	e98080e7          	jalr	-360(ra) # 80006204 <panic>
      panic("dirlookup read");
    80003374:	00005517          	auipc	a0,0x5
    80003378:	23450513          	addi	a0,a0,564 # 800085a8 <syscalls+0x1d8>
    8000337c:	00003097          	auipc	ra,0x3
    80003380:	e88080e7          	jalr	-376(ra) # 80006204 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003384:	24c1                	addiw	s1,s1,16
    80003386:	05492783          	lw	a5,84(s2)
    8000338a:	04f4f763          	bgeu	s1,a5,800033d8 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000338e:	4741                	li	a4,16
    80003390:	86a6                	mv	a3,s1
    80003392:	fc040613          	addi	a2,s0,-64
    80003396:	4581                	li	a1,0
    80003398:	854a                	mv	a0,s2
    8000339a:	00000097          	auipc	ra,0x0
    8000339e:	d70080e7          	jalr	-656(ra) # 8000310a <readi>
    800033a2:	47c1                	li	a5,16
    800033a4:	fcf518e3          	bne	a0,a5,80003374 <dirlookup+0x3a>
    if(de.inum == 0)
    800033a8:	fc045783          	lhu	a5,-64(s0)
    800033ac:	dfe1                	beqz	a5,80003384 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800033ae:	fc240593          	addi	a1,s0,-62
    800033b2:	854e                	mv	a0,s3
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	f6c080e7          	jalr	-148(ra) # 80003320 <namecmp>
    800033bc:	f561                	bnez	a0,80003384 <dirlookup+0x4a>
      if(poff)
    800033be:	000a0463          	beqz	s4,800033c6 <dirlookup+0x8c>
        *poff = off;
    800033c2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800033c6:	fc045583          	lhu	a1,-64(s0)
    800033ca:	00092503          	lw	a0,0(s2)
    800033ce:	fffff097          	auipc	ra,0xfffff
    800033d2:	752080e7          	jalr	1874(ra) # 80002b20 <iget>
    800033d6:	a011                	j	800033da <dirlookup+0xa0>
  return 0;
    800033d8:	4501                	li	a0,0
}
    800033da:	70e2                	ld	ra,56(sp)
    800033dc:	7442                	ld	s0,48(sp)
    800033de:	74a2                	ld	s1,40(sp)
    800033e0:	7902                	ld	s2,32(sp)
    800033e2:	69e2                	ld	s3,24(sp)
    800033e4:	6a42                	ld	s4,16(sp)
    800033e6:	6121                	addi	sp,sp,64
    800033e8:	8082                	ret

00000000800033ea <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800033ea:	711d                	addi	sp,sp,-96
    800033ec:	ec86                	sd	ra,88(sp)
    800033ee:	e8a2                	sd	s0,80(sp)
    800033f0:	e4a6                	sd	s1,72(sp)
    800033f2:	e0ca                	sd	s2,64(sp)
    800033f4:	fc4e                	sd	s3,56(sp)
    800033f6:	f852                	sd	s4,48(sp)
    800033f8:	f456                	sd	s5,40(sp)
    800033fa:	f05a                	sd	s6,32(sp)
    800033fc:	ec5e                	sd	s7,24(sp)
    800033fe:	e862                	sd	s8,16(sp)
    80003400:	e466                	sd	s9,8(sp)
    80003402:	e06a                	sd	s10,0(sp)
    80003404:	1080                	addi	s0,sp,96
    80003406:	84aa                	mv	s1,a0
    80003408:	8b2e                	mv	s6,a1
    8000340a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000340c:	00054703          	lbu	a4,0(a0)
    80003410:	02f00793          	li	a5,47
    80003414:	02f70363          	beq	a4,a5,8000343a <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003418:	ffffe097          	auipc	ra,0xffffe
    8000341c:	bd4080e7          	jalr	-1068(ra) # 80000fec <myproc>
    80003420:	15853503          	ld	a0,344(a0)
    80003424:	00000097          	auipc	ra,0x0
    80003428:	9f4080e7          	jalr	-1548(ra) # 80002e18 <idup>
    8000342c:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000342e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003432:	4cb5                	li	s9,13
  len = path - s;
    80003434:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003436:	4c05                	li	s8,1
    80003438:	a87d                	j	800034f6 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000343a:	4585                	li	a1,1
    8000343c:	4505                	li	a0,1
    8000343e:	fffff097          	auipc	ra,0xfffff
    80003442:	6e2080e7          	jalr	1762(ra) # 80002b20 <iget>
    80003446:	8a2a                	mv	s4,a0
    80003448:	b7dd                	j	8000342e <namex+0x44>
      iunlockput(ip);
    8000344a:	8552                	mv	a0,s4
    8000344c:	00000097          	auipc	ra,0x0
    80003450:	c6c080e7          	jalr	-916(ra) # 800030b8 <iunlockput>
      return 0;
    80003454:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003456:	8552                	mv	a0,s4
    80003458:	60e6                	ld	ra,88(sp)
    8000345a:	6446                	ld	s0,80(sp)
    8000345c:	64a6                	ld	s1,72(sp)
    8000345e:	6906                	ld	s2,64(sp)
    80003460:	79e2                	ld	s3,56(sp)
    80003462:	7a42                	ld	s4,48(sp)
    80003464:	7aa2                	ld	s5,40(sp)
    80003466:	7b02                	ld	s6,32(sp)
    80003468:	6be2                	ld	s7,24(sp)
    8000346a:	6c42                	ld	s8,16(sp)
    8000346c:	6ca2                	ld	s9,8(sp)
    8000346e:	6d02                	ld	s10,0(sp)
    80003470:	6125                	addi	sp,sp,96
    80003472:	8082                	ret
      iunlock(ip);
    80003474:	8552                	mv	a0,s4
    80003476:	00000097          	auipc	ra,0x0
    8000347a:	aa2080e7          	jalr	-1374(ra) # 80002f18 <iunlock>
      return ip;
    8000347e:	bfe1                	j	80003456 <namex+0x6c>
      iunlockput(ip);
    80003480:	8552                	mv	a0,s4
    80003482:	00000097          	auipc	ra,0x0
    80003486:	c36080e7          	jalr	-970(ra) # 800030b8 <iunlockput>
      return 0;
    8000348a:	8a4e                	mv	s4,s3
    8000348c:	b7e9                	j	80003456 <namex+0x6c>
  len = path - s;
    8000348e:	40998633          	sub	a2,s3,s1
    80003492:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003496:	09acd863          	bge	s9,s10,80003526 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    8000349a:	4639                	li	a2,14
    8000349c:	85a6                	mv	a1,s1
    8000349e:	8556                	mv	a0,s5
    800034a0:	ffffd097          	auipc	ra,0xffffd
    800034a4:	ece080e7          	jalr	-306(ra) # 8000036e <memmove>
    800034a8:	84ce                	mv	s1,s3
  while(*path == '/')
    800034aa:	0004c783          	lbu	a5,0(s1)
    800034ae:	01279763          	bne	a5,s2,800034bc <namex+0xd2>
    path++;
    800034b2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800034b4:	0004c783          	lbu	a5,0(s1)
    800034b8:	ff278de3          	beq	a5,s2,800034b2 <namex+0xc8>
    ilock(ip);
    800034bc:	8552                	mv	a0,s4
    800034be:	00000097          	auipc	ra,0x0
    800034c2:	998080e7          	jalr	-1640(ra) # 80002e56 <ilock>
    if(ip->type != T_DIR){
    800034c6:	04ca1783          	lh	a5,76(s4)
    800034ca:	f98790e3          	bne	a5,s8,8000344a <namex+0x60>
    if(nameiparent && *path == '\0'){
    800034ce:	000b0563          	beqz	s6,800034d8 <namex+0xee>
    800034d2:	0004c783          	lbu	a5,0(s1)
    800034d6:	dfd9                	beqz	a5,80003474 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800034d8:	865e                	mv	a2,s7
    800034da:	85d6                	mv	a1,s5
    800034dc:	8552                	mv	a0,s4
    800034de:	00000097          	auipc	ra,0x0
    800034e2:	e5c080e7          	jalr	-420(ra) # 8000333a <dirlookup>
    800034e6:	89aa                	mv	s3,a0
    800034e8:	dd41                	beqz	a0,80003480 <namex+0x96>
    iunlockput(ip);
    800034ea:	8552                	mv	a0,s4
    800034ec:	00000097          	auipc	ra,0x0
    800034f0:	bcc080e7          	jalr	-1076(ra) # 800030b8 <iunlockput>
    ip = next;
    800034f4:	8a4e                	mv	s4,s3
  while(*path == '/')
    800034f6:	0004c783          	lbu	a5,0(s1)
    800034fa:	01279763          	bne	a5,s2,80003508 <namex+0x11e>
    path++;
    800034fe:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003500:	0004c783          	lbu	a5,0(s1)
    80003504:	ff278de3          	beq	a5,s2,800034fe <namex+0x114>
  if(*path == 0)
    80003508:	cb9d                	beqz	a5,8000353e <namex+0x154>
  while(*path != '/' && *path != 0)
    8000350a:	0004c783          	lbu	a5,0(s1)
    8000350e:	89a6                	mv	s3,s1
  len = path - s;
    80003510:	8d5e                	mv	s10,s7
    80003512:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003514:	01278963          	beq	a5,s2,80003526 <namex+0x13c>
    80003518:	dbbd                	beqz	a5,8000348e <namex+0xa4>
    path++;
    8000351a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000351c:	0009c783          	lbu	a5,0(s3)
    80003520:	ff279ce3          	bne	a5,s2,80003518 <namex+0x12e>
    80003524:	b7ad                	j	8000348e <namex+0xa4>
    memmove(name, s, len);
    80003526:	2601                	sext.w	a2,a2
    80003528:	85a6                	mv	a1,s1
    8000352a:	8556                	mv	a0,s5
    8000352c:	ffffd097          	auipc	ra,0xffffd
    80003530:	e42080e7          	jalr	-446(ra) # 8000036e <memmove>
    name[len] = 0;
    80003534:	9d56                	add	s10,s10,s5
    80003536:	000d0023          	sb	zero,0(s10)
    8000353a:	84ce                	mv	s1,s3
    8000353c:	b7bd                	j	800034aa <namex+0xc0>
  if(nameiparent){
    8000353e:	f00b0ce3          	beqz	s6,80003456 <namex+0x6c>
    iput(ip);
    80003542:	8552                	mv	a0,s4
    80003544:	00000097          	auipc	ra,0x0
    80003548:	acc080e7          	jalr	-1332(ra) # 80003010 <iput>
    return 0;
    8000354c:	4a01                	li	s4,0
    8000354e:	b721                	j	80003456 <namex+0x6c>

0000000080003550 <dirlink>:
{
    80003550:	7139                	addi	sp,sp,-64
    80003552:	fc06                	sd	ra,56(sp)
    80003554:	f822                	sd	s0,48(sp)
    80003556:	f426                	sd	s1,40(sp)
    80003558:	f04a                	sd	s2,32(sp)
    8000355a:	ec4e                	sd	s3,24(sp)
    8000355c:	e852                	sd	s4,16(sp)
    8000355e:	0080                	addi	s0,sp,64
    80003560:	892a                	mv	s2,a0
    80003562:	8a2e                	mv	s4,a1
    80003564:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003566:	4601                	li	a2,0
    80003568:	00000097          	auipc	ra,0x0
    8000356c:	dd2080e7          	jalr	-558(ra) # 8000333a <dirlookup>
    80003570:	e93d                	bnez	a0,800035e6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003572:	05492483          	lw	s1,84(s2)
    80003576:	c49d                	beqz	s1,800035a4 <dirlink+0x54>
    80003578:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000357a:	4741                	li	a4,16
    8000357c:	86a6                	mv	a3,s1
    8000357e:	fc040613          	addi	a2,s0,-64
    80003582:	4581                	li	a1,0
    80003584:	854a                	mv	a0,s2
    80003586:	00000097          	auipc	ra,0x0
    8000358a:	b84080e7          	jalr	-1148(ra) # 8000310a <readi>
    8000358e:	47c1                	li	a5,16
    80003590:	06f51163          	bne	a0,a5,800035f2 <dirlink+0xa2>
    if(de.inum == 0)
    80003594:	fc045783          	lhu	a5,-64(s0)
    80003598:	c791                	beqz	a5,800035a4 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000359a:	24c1                	addiw	s1,s1,16
    8000359c:	05492783          	lw	a5,84(s2)
    800035a0:	fcf4ede3          	bltu	s1,a5,8000357a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800035a4:	4639                	li	a2,14
    800035a6:	85d2                	mv	a1,s4
    800035a8:	fc240513          	addi	a0,s0,-62
    800035ac:	ffffd097          	auipc	ra,0xffffd
    800035b0:	e72080e7          	jalr	-398(ra) # 8000041e <strncpy>
  de.inum = inum;
    800035b4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035b8:	4741                	li	a4,16
    800035ba:	86a6                	mv	a3,s1
    800035bc:	fc040613          	addi	a2,s0,-64
    800035c0:	4581                	li	a1,0
    800035c2:	854a                	mv	a0,s2
    800035c4:	00000097          	auipc	ra,0x0
    800035c8:	c3e080e7          	jalr	-962(ra) # 80003202 <writei>
    800035cc:	872a                	mv	a4,a0
    800035ce:	47c1                	li	a5,16
  return 0;
    800035d0:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035d2:	02f71863          	bne	a4,a5,80003602 <dirlink+0xb2>
}
    800035d6:	70e2                	ld	ra,56(sp)
    800035d8:	7442                	ld	s0,48(sp)
    800035da:	74a2                	ld	s1,40(sp)
    800035dc:	7902                	ld	s2,32(sp)
    800035de:	69e2                	ld	s3,24(sp)
    800035e0:	6a42                	ld	s4,16(sp)
    800035e2:	6121                	addi	sp,sp,64
    800035e4:	8082                	ret
    iput(ip);
    800035e6:	00000097          	auipc	ra,0x0
    800035ea:	a2a080e7          	jalr	-1494(ra) # 80003010 <iput>
    return -1;
    800035ee:	557d                	li	a0,-1
    800035f0:	b7dd                	j	800035d6 <dirlink+0x86>
      panic("dirlink read");
    800035f2:	00005517          	auipc	a0,0x5
    800035f6:	fc650513          	addi	a0,a0,-58 # 800085b8 <syscalls+0x1e8>
    800035fa:	00003097          	auipc	ra,0x3
    800035fe:	c0a080e7          	jalr	-1014(ra) # 80006204 <panic>
    panic("dirlink");
    80003602:	00005517          	auipc	a0,0x5
    80003606:	0c650513          	addi	a0,a0,198 # 800086c8 <syscalls+0x2f8>
    8000360a:	00003097          	auipc	ra,0x3
    8000360e:	bfa080e7          	jalr	-1030(ra) # 80006204 <panic>

0000000080003612 <namei>:

struct inode*
namei(char *path)
{
    80003612:	1101                	addi	sp,sp,-32
    80003614:	ec06                	sd	ra,24(sp)
    80003616:	e822                	sd	s0,16(sp)
    80003618:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000361a:	fe040613          	addi	a2,s0,-32
    8000361e:	4581                	li	a1,0
    80003620:	00000097          	auipc	ra,0x0
    80003624:	dca080e7          	jalr	-566(ra) # 800033ea <namex>
}
    80003628:	60e2                	ld	ra,24(sp)
    8000362a:	6442                	ld	s0,16(sp)
    8000362c:	6105                	addi	sp,sp,32
    8000362e:	8082                	ret

0000000080003630 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003630:	1141                	addi	sp,sp,-16
    80003632:	e406                	sd	ra,8(sp)
    80003634:	e022                	sd	s0,0(sp)
    80003636:	0800                	addi	s0,sp,16
    80003638:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000363a:	4585                	li	a1,1
    8000363c:	00000097          	auipc	ra,0x0
    80003640:	dae080e7          	jalr	-594(ra) # 800033ea <namex>
}
    80003644:	60a2                	ld	ra,8(sp)
    80003646:	6402                	ld	s0,0(sp)
    80003648:	0141                	addi	sp,sp,16
    8000364a:	8082                	ret

000000008000364c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000364c:	1101                	addi	sp,sp,-32
    8000364e:	ec06                	sd	ra,24(sp)
    80003650:	e822                	sd	s0,16(sp)
    80003652:	e426                	sd	s1,8(sp)
    80003654:	e04a                	sd	s2,0(sp)
    80003656:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003658:	00019917          	auipc	s2,0x19
    8000365c:	62090913          	addi	s2,s2,1568 # 8001cc78 <log>
    80003660:	02092583          	lw	a1,32(s2)
    80003664:	03092503          	lw	a0,48(s2)
    80003668:	fffff097          	auipc	ra,0xfffff
    8000366c:	dce080e7          	jalr	-562(ra) # 80002436 <bread>
    80003670:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003672:	03492683          	lw	a3,52(s2)
    80003676:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003678:	02d05863          	blez	a3,800036a8 <write_head+0x5c>
    8000367c:	00019797          	auipc	a5,0x19
    80003680:	63478793          	addi	a5,a5,1588 # 8001ccb0 <log+0x38>
    80003684:	05c50713          	addi	a4,a0,92
    80003688:	36fd                	addiw	a3,a3,-1
    8000368a:	02069613          	slli	a2,a3,0x20
    8000368e:	01e65693          	srli	a3,a2,0x1e
    80003692:	00019617          	auipc	a2,0x19
    80003696:	62260613          	addi	a2,a2,1570 # 8001ccb4 <log+0x3c>
    8000369a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000369c:	4390                	lw	a2,0(a5)
    8000369e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036a0:	0791                	addi	a5,a5,4
    800036a2:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800036a4:	fed79ce3          	bne	a5,a3,8000369c <write_head+0x50>
  }
  bwrite(buf);
    800036a8:	8526                	mv	a0,s1
    800036aa:	fffff097          	auipc	ra,0xfffff
    800036ae:	084080e7          	jalr	132(ra) # 8000272e <bwrite>
  brelse(buf);
    800036b2:	8526                	mv	a0,s1
    800036b4:	fffff097          	auipc	ra,0xfffff
    800036b8:	0b8080e7          	jalr	184(ra) # 8000276c <brelse>
}
    800036bc:	60e2                	ld	ra,24(sp)
    800036be:	6442                	ld	s0,16(sp)
    800036c0:	64a2                	ld	s1,8(sp)
    800036c2:	6902                	ld	s2,0(sp)
    800036c4:	6105                	addi	sp,sp,32
    800036c6:	8082                	ret

00000000800036c8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800036c8:	00019797          	auipc	a5,0x19
    800036cc:	5e47a783          	lw	a5,1508(a5) # 8001ccac <log+0x34>
    800036d0:	0af05d63          	blez	a5,8000378a <install_trans+0xc2>
{
    800036d4:	7139                	addi	sp,sp,-64
    800036d6:	fc06                	sd	ra,56(sp)
    800036d8:	f822                	sd	s0,48(sp)
    800036da:	f426                	sd	s1,40(sp)
    800036dc:	f04a                	sd	s2,32(sp)
    800036de:	ec4e                	sd	s3,24(sp)
    800036e0:	e852                	sd	s4,16(sp)
    800036e2:	e456                	sd	s5,8(sp)
    800036e4:	e05a                	sd	s6,0(sp)
    800036e6:	0080                	addi	s0,sp,64
    800036e8:	8b2a                	mv	s6,a0
    800036ea:	00019a97          	auipc	s5,0x19
    800036ee:	5c6a8a93          	addi	s5,s5,1478 # 8001ccb0 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036f2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036f4:	00019997          	auipc	s3,0x19
    800036f8:	58498993          	addi	s3,s3,1412 # 8001cc78 <log>
    800036fc:	a00d                	j	8000371e <install_trans+0x56>
    brelse(lbuf);
    800036fe:	854a                	mv	a0,s2
    80003700:	fffff097          	auipc	ra,0xfffff
    80003704:	06c080e7          	jalr	108(ra) # 8000276c <brelse>
    brelse(dbuf);
    80003708:	8526                	mv	a0,s1
    8000370a:	fffff097          	auipc	ra,0xfffff
    8000370e:	062080e7          	jalr	98(ra) # 8000276c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003712:	2a05                	addiw	s4,s4,1
    80003714:	0a91                	addi	s5,s5,4
    80003716:	0349a783          	lw	a5,52(s3)
    8000371a:	04fa5e63          	bge	s4,a5,80003776 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000371e:	0209a583          	lw	a1,32(s3)
    80003722:	014585bb          	addw	a1,a1,s4
    80003726:	2585                	addiw	a1,a1,1
    80003728:	0309a503          	lw	a0,48(s3)
    8000372c:	fffff097          	auipc	ra,0xfffff
    80003730:	d0a080e7          	jalr	-758(ra) # 80002436 <bread>
    80003734:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003736:	000aa583          	lw	a1,0(s5)
    8000373a:	0309a503          	lw	a0,48(s3)
    8000373e:	fffff097          	auipc	ra,0xfffff
    80003742:	cf8080e7          	jalr	-776(ra) # 80002436 <bread>
    80003746:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003748:	40000613          	li	a2,1024
    8000374c:	05890593          	addi	a1,s2,88
    80003750:	05850513          	addi	a0,a0,88
    80003754:	ffffd097          	auipc	ra,0xffffd
    80003758:	c1a080e7          	jalr	-998(ra) # 8000036e <memmove>
    bwrite(dbuf);  // write dst to disk
    8000375c:	8526                	mv	a0,s1
    8000375e:	fffff097          	auipc	ra,0xfffff
    80003762:	fd0080e7          	jalr	-48(ra) # 8000272e <bwrite>
    if(recovering == 0)
    80003766:	f80b1ce3          	bnez	s6,800036fe <install_trans+0x36>
      bunpin(dbuf);
    8000376a:	8526                	mv	a0,s1
    8000376c:	fffff097          	auipc	ra,0xfffff
    80003770:	0de080e7          	jalr	222(ra) # 8000284a <bunpin>
    80003774:	b769                	j	800036fe <install_trans+0x36>
}
    80003776:	70e2                	ld	ra,56(sp)
    80003778:	7442                	ld	s0,48(sp)
    8000377a:	74a2                	ld	s1,40(sp)
    8000377c:	7902                	ld	s2,32(sp)
    8000377e:	69e2                	ld	s3,24(sp)
    80003780:	6a42                	ld	s4,16(sp)
    80003782:	6aa2                	ld	s5,8(sp)
    80003784:	6b02                	ld	s6,0(sp)
    80003786:	6121                	addi	sp,sp,64
    80003788:	8082                	ret
    8000378a:	8082                	ret

000000008000378c <initlog>:
{
    8000378c:	7179                	addi	sp,sp,-48
    8000378e:	f406                	sd	ra,40(sp)
    80003790:	f022                	sd	s0,32(sp)
    80003792:	ec26                	sd	s1,24(sp)
    80003794:	e84a                	sd	s2,16(sp)
    80003796:	e44e                	sd	s3,8(sp)
    80003798:	1800                	addi	s0,sp,48
    8000379a:	892a                	mv	s2,a0
    8000379c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000379e:	00019497          	auipc	s1,0x19
    800037a2:	4da48493          	addi	s1,s1,1242 # 8001cc78 <log>
    800037a6:	00005597          	auipc	a1,0x5
    800037aa:	e2258593          	addi	a1,a1,-478 # 800085c8 <syscalls+0x1f8>
    800037ae:	8526                	mv	a0,s1
    800037b0:	00003097          	auipc	ra,0x3
    800037b4:	0f2080e7          	jalr	242(ra) # 800068a2 <initlock>
  log.start = sb->logstart;
    800037b8:	0149a583          	lw	a1,20(s3)
    800037bc:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    800037be:	0109a783          	lw	a5,16(s3)
    800037c2:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    800037c4:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    800037c8:	854a                	mv	a0,s2
    800037ca:	fffff097          	auipc	ra,0xfffff
    800037ce:	c6c080e7          	jalr	-916(ra) # 80002436 <bread>
  log.lh.n = lh->n;
    800037d2:	4d34                	lw	a3,88(a0)
    800037d4:	d8d4                	sw	a3,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    800037d6:	02d05663          	blez	a3,80003802 <initlog+0x76>
    800037da:	05c50793          	addi	a5,a0,92
    800037de:	00019717          	auipc	a4,0x19
    800037e2:	4d270713          	addi	a4,a4,1234 # 8001ccb0 <log+0x38>
    800037e6:	36fd                	addiw	a3,a3,-1
    800037e8:	02069613          	slli	a2,a3,0x20
    800037ec:	01e65693          	srli	a3,a2,0x1e
    800037f0:	06050613          	addi	a2,a0,96
    800037f4:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800037f6:	4390                	lw	a2,0(a5)
    800037f8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800037fa:	0791                	addi	a5,a5,4
    800037fc:	0711                	addi	a4,a4,4
    800037fe:	fed79ce3          	bne	a5,a3,800037f6 <initlog+0x6a>
  brelse(buf);
    80003802:	fffff097          	auipc	ra,0xfffff
    80003806:	f6a080e7          	jalr	-150(ra) # 8000276c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000380a:	4505                	li	a0,1
    8000380c:	00000097          	auipc	ra,0x0
    80003810:	ebc080e7          	jalr	-324(ra) # 800036c8 <install_trans>
  log.lh.n = 0;
    80003814:	00019797          	auipc	a5,0x19
    80003818:	4807ac23          	sw	zero,1176(a5) # 8001ccac <log+0x34>
  write_head(); // clear the log
    8000381c:	00000097          	auipc	ra,0x0
    80003820:	e30080e7          	jalr	-464(ra) # 8000364c <write_head>
}
    80003824:	70a2                	ld	ra,40(sp)
    80003826:	7402                	ld	s0,32(sp)
    80003828:	64e2                	ld	s1,24(sp)
    8000382a:	6942                	ld	s2,16(sp)
    8000382c:	69a2                	ld	s3,8(sp)
    8000382e:	6145                	addi	sp,sp,48
    80003830:	8082                	ret

0000000080003832 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003832:	1101                	addi	sp,sp,-32
    80003834:	ec06                	sd	ra,24(sp)
    80003836:	e822                	sd	s0,16(sp)
    80003838:	e426                	sd	s1,8(sp)
    8000383a:	e04a                	sd	s2,0(sp)
    8000383c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000383e:	00019517          	auipc	a0,0x19
    80003842:	43a50513          	addi	a0,a0,1082 # 8001cc78 <log>
    80003846:	00003097          	auipc	ra,0x3
    8000384a:	ee0080e7          	jalr	-288(ra) # 80006726 <acquire>
  while(1){
    if(log.committing){
    8000384e:	00019497          	auipc	s1,0x19
    80003852:	42a48493          	addi	s1,s1,1066 # 8001cc78 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003856:	4979                	li	s2,30
    80003858:	a039                	j	80003866 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000385a:	85a6                	mv	a1,s1
    8000385c:	8526                	mv	a0,s1
    8000385e:	ffffe097          	auipc	ra,0xffffe
    80003862:	e52080e7          	jalr	-430(ra) # 800016b0 <sleep>
    if(log.committing){
    80003866:	54dc                	lw	a5,44(s1)
    80003868:	fbed                	bnez	a5,8000385a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000386a:	5498                	lw	a4,40(s1)
    8000386c:	2705                	addiw	a4,a4,1
    8000386e:	0007069b          	sext.w	a3,a4
    80003872:	0027179b          	slliw	a5,a4,0x2
    80003876:	9fb9                	addw	a5,a5,a4
    80003878:	0017979b          	slliw	a5,a5,0x1
    8000387c:	58d8                	lw	a4,52(s1)
    8000387e:	9fb9                	addw	a5,a5,a4
    80003880:	00f95963          	bge	s2,a5,80003892 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003884:	85a6                	mv	a1,s1
    80003886:	8526                	mv	a0,s1
    80003888:	ffffe097          	auipc	ra,0xffffe
    8000388c:	e28080e7          	jalr	-472(ra) # 800016b0 <sleep>
    80003890:	bfd9                	j	80003866 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003892:	00019517          	auipc	a0,0x19
    80003896:	3e650513          	addi	a0,a0,998 # 8001cc78 <log>
    8000389a:	d514                	sw	a3,40(a0)
      release(&log.lock);
    8000389c:	00003097          	auipc	ra,0x3
    800038a0:	f5a080e7          	jalr	-166(ra) # 800067f6 <release>
      break;
    }
  }
}
    800038a4:	60e2                	ld	ra,24(sp)
    800038a6:	6442                	ld	s0,16(sp)
    800038a8:	64a2                	ld	s1,8(sp)
    800038aa:	6902                	ld	s2,0(sp)
    800038ac:	6105                	addi	sp,sp,32
    800038ae:	8082                	ret

00000000800038b0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800038b0:	7139                	addi	sp,sp,-64
    800038b2:	fc06                	sd	ra,56(sp)
    800038b4:	f822                	sd	s0,48(sp)
    800038b6:	f426                	sd	s1,40(sp)
    800038b8:	f04a                	sd	s2,32(sp)
    800038ba:	ec4e                	sd	s3,24(sp)
    800038bc:	e852                	sd	s4,16(sp)
    800038be:	e456                	sd	s5,8(sp)
    800038c0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800038c2:	00019497          	auipc	s1,0x19
    800038c6:	3b648493          	addi	s1,s1,950 # 8001cc78 <log>
    800038ca:	8526                	mv	a0,s1
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	e5a080e7          	jalr	-422(ra) # 80006726 <acquire>
  log.outstanding -= 1;
    800038d4:	549c                	lw	a5,40(s1)
    800038d6:	37fd                	addiw	a5,a5,-1
    800038d8:	0007891b          	sext.w	s2,a5
    800038dc:	d49c                	sw	a5,40(s1)
  if(log.committing)
    800038de:	54dc                	lw	a5,44(s1)
    800038e0:	e7b9                	bnez	a5,8000392e <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800038e2:	04091e63          	bnez	s2,8000393e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800038e6:	00019497          	auipc	s1,0x19
    800038ea:	39248493          	addi	s1,s1,914 # 8001cc78 <log>
    800038ee:	4785                	li	a5,1
    800038f0:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800038f2:	8526                	mv	a0,s1
    800038f4:	00003097          	auipc	ra,0x3
    800038f8:	f02080e7          	jalr	-254(ra) # 800067f6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800038fc:	58dc                	lw	a5,52(s1)
    800038fe:	06f04763          	bgtz	a5,8000396c <end_op+0xbc>
    acquire(&log.lock);
    80003902:	00019497          	auipc	s1,0x19
    80003906:	37648493          	addi	s1,s1,886 # 8001cc78 <log>
    8000390a:	8526                	mv	a0,s1
    8000390c:	00003097          	auipc	ra,0x3
    80003910:	e1a080e7          	jalr	-486(ra) # 80006726 <acquire>
    log.committing = 0;
    80003914:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    80003918:	8526                	mv	a0,s1
    8000391a:	ffffe097          	auipc	ra,0xffffe
    8000391e:	f22080e7          	jalr	-222(ra) # 8000183c <wakeup>
    release(&log.lock);
    80003922:	8526                	mv	a0,s1
    80003924:	00003097          	auipc	ra,0x3
    80003928:	ed2080e7          	jalr	-302(ra) # 800067f6 <release>
}
    8000392c:	a03d                	j	8000395a <end_op+0xaa>
    panic("log.committing");
    8000392e:	00005517          	auipc	a0,0x5
    80003932:	ca250513          	addi	a0,a0,-862 # 800085d0 <syscalls+0x200>
    80003936:	00003097          	auipc	ra,0x3
    8000393a:	8ce080e7          	jalr	-1842(ra) # 80006204 <panic>
    wakeup(&log);
    8000393e:	00019497          	auipc	s1,0x19
    80003942:	33a48493          	addi	s1,s1,826 # 8001cc78 <log>
    80003946:	8526                	mv	a0,s1
    80003948:	ffffe097          	auipc	ra,0xffffe
    8000394c:	ef4080e7          	jalr	-268(ra) # 8000183c <wakeup>
  release(&log.lock);
    80003950:	8526                	mv	a0,s1
    80003952:	00003097          	auipc	ra,0x3
    80003956:	ea4080e7          	jalr	-348(ra) # 800067f6 <release>
}
    8000395a:	70e2                	ld	ra,56(sp)
    8000395c:	7442                	ld	s0,48(sp)
    8000395e:	74a2                	ld	s1,40(sp)
    80003960:	7902                	ld	s2,32(sp)
    80003962:	69e2                	ld	s3,24(sp)
    80003964:	6a42                	ld	s4,16(sp)
    80003966:	6aa2                	ld	s5,8(sp)
    80003968:	6121                	addi	sp,sp,64
    8000396a:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000396c:	00019a97          	auipc	s5,0x19
    80003970:	344a8a93          	addi	s5,s5,836 # 8001ccb0 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003974:	00019a17          	auipc	s4,0x19
    80003978:	304a0a13          	addi	s4,s4,772 # 8001cc78 <log>
    8000397c:	020a2583          	lw	a1,32(s4)
    80003980:	012585bb          	addw	a1,a1,s2
    80003984:	2585                	addiw	a1,a1,1
    80003986:	030a2503          	lw	a0,48(s4)
    8000398a:	fffff097          	auipc	ra,0xfffff
    8000398e:	aac080e7          	jalr	-1364(ra) # 80002436 <bread>
    80003992:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003994:	000aa583          	lw	a1,0(s5)
    80003998:	030a2503          	lw	a0,48(s4)
    8000399c:	fffff097          	auipc	ra,0xfffff
    800039a0:	a9a080e7          	jalr	-1382(ra) # 80002436 <bread>
    800039a4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800039a6:	40000613          	li	a2,1024
    800039aa:	05850593          	addi	a1,a0,88
    800039ae:	05848513          	addi	a0,s1,88
    800039b2:	ffffd097          	auipc	ra,0xffffd
    800039b6:	9bc080e7          	jalr	-1604(ra) # 8000036e <memmove>
    bwrite(to);  // write the log
    800039ba:	8526                	mv	a0,s1
    800039bc:	fffff097          	auipc	ra,0xfffff
    800039c0:	d72080e7          	jalr	-654(ra) # 8000272e <bwrite>
    brelse(from);
    800039c4:	854e                	mv	a0,s3
    800039c6:	fffff097          	auipc	ra,0xfffff
    800039ca:	da6080e7          	jalr	-602(ra) # 8000276c <brelse>
    brelse(to);
    800039ce:	8526                	mv	a0,s1
    800039d0:	fffff097          	auipc	ra,0xfffff
    800039d4:	d9c080e7          	jalr	-612(ra) # 8000276c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039d8:	2905                	addiw	s2,s2,1
    800039da:	0a91                	addi	s5,s5,4
    800039dc:	034a2783          	lw	a5,52(s4)
    800039e0:	f8f94ee3          	blt	s2,a5,8000397c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800039e4:	00000097          	auipc	ra,0x0
    800039e8:	c68080e7          	jalr	-920(ra) # 8000364c <write_head>
    install_trans(0); // Now install writes to home locations
    800039ec:	4501                	li	a0,0
    800039ee:	00000097          	auipc	ra,0x0
    800039f2:	cda080e7          	jalr	-806(ra) # 800036c8 <install_trans>
    log.lh.n = 0;
    800039f6:	00019797          	auipc	a5,0x19
    800039fa:	2a07ab23          	sw	zero,694(a5) # 8001ccac <log+0x34>
    write_head();    // Erase the transaction from the log
    800039fe:	00000097          	auipc	ra,0x0
    80003a02:	c4e080e7          	jalr	-946(ra) # 8000364c <write_head>
    80003a06:	bdf5                	j	80003902 <end_op+0x52>

0000000080003a08 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003a08:	1101                	addi	sp,sp,-32
    80003a0a:	ec06                	sd	ra,24(sp)
    80003a0c:	e822                	sd	s0,16(sp)
    80003a0e:	e426                	sd	s1,8(sp)
    80003a10:	e04a                	sd	s2,0(sp)
    80003a12:	1000                	addi	s0,sp,32
    80003a14:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003a16:	00019917          	auipc	s2,0x19
    80003a1a:	26290913          	addi	s2,s2,610 # 8001cc78 <log>
    80003a1e:	854a                	mv	a0,s2
    80003a20:	00003097          	auipc	ra,0x3
    80003a24:	d06080e7          	jalr	-762(ra) # 80006726 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003a28:	03492603          	lw	a2,52(s2)
    80003a2c:	47f5                	li	a5,29
    80003a2e:	06c7c563          	blt	a5,a2,80003a98 <log_write+0x90>
    80003a32:	00019797          	auipc	a5,0x19
    80003a36:	26a7a783          	lw	a5,618(a5) # 8001cc9c <log+0x24>
    80003a3a:	37fd                	addiw	a5,a5,-1
    80003a3c:	04f65e63          	bge	a2,a5,80003a98 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003a40:	00019797          	auipc	a5,0x19
    80003a44:	2607a783          	lw	a5,608(a5) # 8001cca0 <log+0x28>
    80003a48:	06f05063          	blez	a5,80003aa8 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003a4c:	4781                	li	a5,0
    80003a4e:	06c05563          	blez	a2,80003ab8 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a52:	44cc                	lw	a1,12(s1)
    80003a54:	00019717          	auipc	a4,0x19
    80003a58:	25c70713          	addi	a4,a4,604 # 8001ccb0 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    80003a5c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a5e:	4314                	lw	a3,0(a4)
    80003a60:	04b68c63          	beq	a3,a1,80003ab8 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a64:	2785                	addiw	a5,a5,1
    80003a66:	0711                	addi	a4,a4,4
    80003a68:	fef61be3          	bne	a2,a5,80003a5e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a6c:	0631                	addi	a2,a2,12
    80003a6e:	060a                	slli	a2,a2,0x2
    80003a70:	00019797          	auipc	a5,0x19
    80003a74:	20878793          	addi	a5,a5,520 # 8001cc78 <log>
    80003a78:	97b2                	add	a5,a5,a2
    80003a7a:	44d8                	lw	a4,12(s1)
    80003a7c:	c798                	sw	a4,8(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a7e:	8526                	mv	a0,s1
    80003a80:	fffff097          	auipc	ra,0xfffff
    80003a84:	d7a080e7          	jalr	-646(ra) # 800027fa <bpin>
    log.lh.n++;
    80003a88:	00019717          	auipc	a4,0x19
    80003a8c:	1f070713          	addi	a4,a4,496 # 8001cc78 <log>
    80003a90:	5b5c                	lw	a5,52(a4)
    80003a92:	2785                	addiw	a5,a5,1
    80003a94:	db5c                	sw	a5,52(a4)
    80003a96:	a82d                	j	80003ad0 <log_write+0xc8>
    panic("too big a transaction");
    80003a98:	00005517          	auipc	a0,0x5
    80003a9c:	b4850513          	addi	a0,a0,-1208 # 800085e0 <syscalls+0x210>
    80003aa0:	00002097          	auipc	ra,0x2
    80003aa4:	764080e7          	jalr	1892(ra) # 80006204 <panic>
    panic("log_write outside of trans");
    80003aa8:	00005517          	auipc	a0,0x5
    80003aac:	b5050513          	addi	a0,a0,-1200 # 800085f8 <syscalls+0x228>
    80003ab0:	00002097          	auipc	ra,0x2
    80003ab4:	754080e7          	jalr	1876(ra) # 80006204 <panic>
  log.lh.block[i] = b->blockno;
    80003ab8:	00c78693          	addi	a3,a5,12
    80003abc:	068a                	slli	a3,a3,0x2
    80003abe:	00019717          	auipc	a4,0x19
    80003ac2:	1ba70713          	addi	a4,a4,442 # 8001cc78 <log>
    80003ac6:	9736                	add	a4,a4,a3
    80003ac8:	44d4                	lw	a3,12(s1)
    80003aca:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003acc:	faf609e3          	beq	a2,a5,80003a7e <log_write+0x76>
  }
  release(&log.lock);
    80003ad0:	00019517          	auipc	a0,0x19
    80003ad4:	1a850513          	addi	a0,a0,424 # 8001cc78 <log>
    80003ad8:	00003097          	auipc	ra,0x3
    80003adc:	d1e080e7          	jalr	-738(ra) # 800067f6 <release>
}
    80003ae0:	60e2                	ld	ra,24(sp)
    80003ae2:	6442                	ld	s0,16(sp)
    80003ae4:	64a2                	ld	s1,8(sp)
    80003ae6:	6902                	ld	s2,0(sp)
    80003ae8:	6105                	addi	sp,sp,32
    80003aea:	8082                	ret

0000000080003aec <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003aec:	1101                	addi	sp,sp,-32
    80003aee:	ec06                	sd	ra,24(sp)
    80003af0:	e822                	sd	s0,16(sp)
    80003af2:	e426                	sd	s1,8(sp)
    80003af4:	e04a                	sd	s2,0(sp)
    80003af6:	1000                	addi	s0,sp,32
    80003af8:	84aa                	mv	s1,a0
    80003afa:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003afc:	00005597          	auipc	a1,0x5
    80003b00:	b1c58593          	addi	a1,a1,-1252 # 80008618 <syscalls+0x248>
    80003b04:	0521                	addi	a0,a0,8
    80003b06:	00003097          	auipc	ra,0x3
    80003b0a:	d9c080e7          	jalr	-612(ra) # 800068a2 <initlock>
  lk->name = name;
    80003b0e:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80003b12:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b16:	0204a823          	sw	zero,48(s1)
}
    80003b1a:	60e2                	ld	ra,24(sp)
    80003b1c:	6442                	ld	s0,16(sp)
    80003b1e:	64a2                	ld	s1,8(sp)
    80003b20:	6902                	ld	s2,0(sp)
    80003b22:	6105                	addi	sp,sp,32
    80003b24:	8082                	ret

0000000080003b26 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003b26:	1101                	addi	sp,sp,-32
    80003b28:	ec06                	sd	ra,24(sp)
    80003b2a:	e822                	sd	s0,16(sp)
    80003b2c:	e426                	sd	s1,8(sp)
    80003b2e:	e04a                	sd	s2,0(sp)
    80003b30:	1000                	addi	s0,sp,32
    80003b32:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b34:	00850913          	addi	s2,a0,8
    80003b38:	854a                	mv	a0,s2
    80003b3a:	00003097          	auipc	ra,0x3
    80003b3e:	bec080e7          	jalr	-1044(ra) # 80006726 <acquire>
  while (lk->locked) {
    80003b42:	409c                	lw	a5,0(s1)
    80003b44:	cb89                	beqz	a5,80003b56 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003b46:	85ca                	mv	a1,s2
    80003b48:	8526                	mv	a0,s1
    80003b4a:	ffffe097          	auipc	ra,0xffffe
    80003b4e:	b66080e7          	jalr	-1178(ra) # 800016b0 <sleep>
  while (lk->locked) {
    80003b52:	409c                	lw	a5,0(s1)
    80003b54:	fbed                	bnez	a5,80003b46 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b56:	4785                	li	a5,1
    80003b58:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b5a:	ffffd097          	auipc	ra,0xffffd
    80003b5e:	492080e7          	jalr	1170(ra) # 80000fec <myproc>
    80003b62:	5d1c                	lw	a5,56(a0)
    80003b64:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003b66:	854a                	mv	a0,s2
    80003b68:	00003097          	auipc	ra,0x3
    80003b6c:	c8e080e7          	jalr	-882(ra) # 800067f6 <release>
}
    80003b70:	60e2                	ld	ra,24(sp)
    80003b72:	6442                	ld	s0,16(sp)
    80003b74:	64a2                	ld	s1,8(sp)
    80003b76:	6902                	ld	s2,0(sp)
    80003b78:	6105                	addi	sp,sp,32
    80003b7a:	8082                	ret

0000000080003b7c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b7c:	1101                	addi	sp,sp,-32
    80003b7e:	ec06                	sd	ra,24(sp)
    80003b80:	e822                	sd	s0,16(sp)
    80003b82:	e426                	sd	s1,8(sp)
    80003b84:	e04a                	sd	s2,0(sp)
    80003b86:	1000                	addi	s0,sp,32
    80003b88:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b8a:	00850913          	addi	s2,a0,8
    80003b8e:	854a                	mv	a0,s2
    80003b90:	00003097          	auipc	ra,0x3
    80003b94:	b96080e7          	jalr	-1130(ra) # 80006726 <acquire>
  lk->locked = 0;
    80003b98:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b9c:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003ba0:	8526                	mv	a0,s1
    80003ba2:	ffffe097          	auipc	ra,0xffffe
    80003ba6:	c9a080e7          	jalr	-870(ra) # 8000183c <wakeup>
  release(&lk->lk);
    80003baa:	854a                	mv	a0,s2
    80003bac:	00003097          	auipc	ra,0x3
    80003bb0:	c4a080e7          	jalr	-950(ra) # 800067f6 <release>
}
    80003bb4:	60e2                	ld	ra,24(sp)
    80003bb6:	6442                	ld	s0,16(sp)
    80003bb8:	64a2                	ld	s1,8(sp)
    80003bba:	6902                	ld	s2,0(sp)
    80003bbc:	6105                	addi	sp,sp,32
    80003bbe:	8082                	ret

0000000080003bc0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003bc0:	7179                	addi	sp,sp,-48
    80003bc2:	f406                	sd	ra,40(sp)
    80003bc4:	f022                	sd	s0,32(sp)
    80003bc6:	ec26                	sd	s1,24(sp)
    80003bc8:	e84a                	sd	s2,16(sp)
    80003bca:	e44e                	sd	s3,8(sp)
    80003bcc:	1800                	addi	s0,sp,48
    80003bce:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003bd0:	00850913          	addi	s2,a0,8
    80003bd4:	854a                	mv	a0,s2
    80003bd6:	00003097          	auipc	ra,0x3
    80003bda:	b50080e7          	jalr	-1200(ra) # 80006726 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bde:	409c                	lw	a5,0(s1)
    80003be0:	ef99                	bnez	a5,80003bfe <holdingsleep+0x3e>
    80003be2:	4481                	li	s1,0
  release(&lk->lk);
    80003be4:	854a                	mv	a0,s2
    80003be6:	00003097          	auipc	ra,0x3
    80003bea:	c10080e7          	jalr	-1008(ra) # 800067f6 <release>
  return r;
}
    80003bee:	8526                	mv	a0,s1
    80003bf0:	70a2                	ld	ra,40(sp)
    80003bf2:	7402                	ld	s0,32(sp)
    80003bf4:	64e2                	ld	s1,24(sp)
    80003bf6:	6942                	ld	s2,16(sp)
    80003bf8:	69a2                	ld	s3,8(sp)
    80003bfa:	6145                	addi	sp,sp,48
    80003bfc:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bfe:	0304a983          	lw	s3,48(s1)
    80003c02:	ffffd097          	auipc	ra,0xffffd
    80003c06:	3ea080e7          	jalr	1002(ra) # 80000fec <myproc>
    80003c0a:	5d04                	lw	s1,56(a0)
    80003c0c:	413484b3          	sub	s1,s1,s3
    80003c10:	0014b493          	seqz	s1,s1
    80003c14:	bfc1                	j	80003be4 <holdingsleep+0x24>

0000000080003c16 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003c16:	1141                	addi	sp,sp,-16
    80003c18:	e406                	sd	ra,8(sp)
    80003c1a:	e022                	sd	s0,0(sp)
    80003c1c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003c1e:	00005597          	auipc	a1,0x5
    80003c22:	a0a58593          	addi	a1,a1,-1526 # 80008628 <syscalls+0x258>
    80003c26:	00019517          	auipc	a0,0x19
    80003c2a:	1a250513          	addi	a0,a0,418 # 8001cdc8 <ftable>
    80003c2e:	00003097          	auipc	ra,0x3
    80003c32:	c74080e7          	jalr	-908(ra) # 800068a2 <initlock>
}
    80003c36:	60a2                	ld	ra,8(sp)
    80003c38:	6402                	ld	s0,0(sp)
    80003c3a:	0141                	addi	sp,sp,16
    80003c3c:	8082                	ret

0000000080003c3e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003c3e:	1101                	addi	sp,sp,-32
    80003c40:	ec06                	sd	ra,24(sp)
    80003c42:	e822                	sd	s0,16(sp)
    80003c44:	e426                	sd	s1,8(sp)
    80003c46:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c48:	00019517          	auipc	a0,0x19
    80003c4c:	18050513          	addi	a0,a0,384 # 8001cdc8 <ftable>
    80003c50:	00003097          	auipc	ra,0x3
    80003c54:	ad6080e7          	jalr	-1322(ra) # 80006726 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c58:	00019497          	auipc	s1,0x19
    80003c5c:	19048493          	addi	s1,s1,400 # 8001cde8 <ftable+0x20>
    80003c60:	0001a717          	auipc	a4,0x1a
    80003c64:	12870713          	addi	a4,a4,296 # 8001dd88 <ftable+0xfc0>
    if(f->ref == 0){
    80003c68:	40dc                	lw	a5,4(s1)
    80003c6a:	cf99                	beqz	a5,80003c88 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c6c:	02848493          	addi	s1,s1,40
    80003c70:	fee49ce3          	bne	s1,a4,80003c68 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c74:	00019517          	auipc	a0,0x19
    80003c78:	15450513          	addi	a0,a0,340 # 8001cdc8 <ftable>
    80003c7c:	00003097          	auipc	ra,0x3
    80003c80:	b7a080e7          	jalr	-1158(ra) # 800067f6 <release>
  return 0;
    80003c84:	4481                	li	s1,0
    80003c86:	a819                	j	80003c9c <filealloc+0x5e>
      f->ref = 1;
    80003c88:	4785                	li	a5,1
    80003c8a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c8c:	00019517          	auipc	a0,0x19
    80003c90:	13c50513          	addi	a0,a0,316 # 8001cdc8 <ftable>
    80003c94:	00003097          	auipc	ra,0x3
    80003c98:	b62080e7          	jalr	-1182(ra) # 800067f6 <release>
}
    80003c9c:	8526                	mv	a0,s1
    80003c9e:	60e2                	ld	ra,24(sp)
    80003ca0:	6442                	ld	s0,16(sp)
    80003ca2:	64a2                	ld	s1,8(sp)
    80003ca4:	6105                	addi	sp,sp,32
    80003ca6:	8082                	ret

0000000080003ca8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ca8:	1101                	addi	sp,sp,-32
    80003caa:	ec06                	sd	ra,24(sp)
    80003cac:	e822                	sd	s0,16(sp)
    80003cae:	e426                	sd	s1,8(sp)
    80003cb0:	1000                	addi	s0,sp,32
    80003cb2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003cb4:	00019517          	auipc	a0,0x19
    80003cb8:	11450513          	addi	a0,a0,276 # 8001cdc8 <ftable>
    80003cbc:	00003097          	auipc	ra,0x3
    80003cc0:	a6a080e7          	jalr	-1430(ra) # 80006726 <acquire>
  if(f->ref < 1)
    80003cc4:	40dc                	lw	a5,4(s1)
    80003cc6:	02f05263          	blez	a5,80003cea <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003cca:	2785                	addiw	a5,a5,1
    80003ccc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003cce:	00019517          	auipc	a0,0x19
    80003cd2:	0fa50513          	addi	a0,a0,250 # 8001cdc8 <ftable>
    80003cd6:	00003097          	auipc	ra,0x3
    80003cda:	b20080e7          	jalr	-1248(ra) # 800067f6 <release>
  return f;
}
    80003cde:	8526                	mv	a0,s1
    80003ce0:	60e2                	ld	ra,24(sp)
    80003ce2:	6442                	ld	s0,16(sp)
    80003ce4:	64a2                	ld	s1,8(sp)
    80003ce6:	6105                	addi	sp,sp,32
    80003ce8:	8082                	ret
    panic("filedup");
    80003cea:	00005517          	auipc	a0,0x5
    80003cee:	94650513          	addi	a0,a0,-1722 # 80008630 <syscalls+0x260>
    80003cf2:	00002097          	auipc	ra,0x2
    80003cf6:	512080e7          	jalr	1298(ra) # 80006204 <panic>

0000000080003cfa <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003cfa:	7139                	addi	sp,sp,-64
    80003cfc:	fc06                	sd	ra,56(sp)
    80003cfe:	f822                	sd	s0,48(sp)
    80003d00:	f426                	sd	s1,40(sp)
    80003d02:	f04a                	sd	s2,32(sp)
    80003d04:	ec4e                	sd	s3,24(sp)
    80003d06:	e852                	sd	s4,16(sp)
    80003d08:	e456                	sd	s5,8(sp)
    80003d0a:	0080                	addi	s0,sp,64
    80003d0c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003d0e:	00019517          	auipc	a0,0x19
    80003d12:	0ba50513          	addi	a0,a0,186 # 8001cdc8 <ftable>
    80003d16:	00003097          	auipc	ra,0x3
    80003d1a:	a10080e7          	jalr	-1520(ra) # 80006726 <acquire>
  if(f->ref < 1)
    80003d1e:	40dc                	lw	a5,4(s1)
    80003d20:	06f05163          	blez	a5,80003d82 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003d24:	37fd                	addiw	a5,a5,-1
    80003d26:	0007871b          	sext.w	a4,a5
    80003d2a:	c0dc                	sw	a5,4(s1)
    80003d2c:	06e04363          	bgtz	a4,80003d92 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003d30:	0004a903          	lw	s2,0(s1)
    80003d34:	0094ca83          	lbu	s5,9(s1)
    80003d38:	0104ba03          	ld	s4,16(s1)
    80003d3c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d40:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d44:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d48:	00019517          	auipc	a0,0x19
    80003d4c:	08050513          	addi	a0,a0,128 # 8001cdc8 <ftable>
    80003d50:	00003097          	auipc	ra,0x3
    80003d54:	aa6080e7          	jalr	-1370(ra) # 800067f6 <release>

  if(ff.type == FD_PIPE){
    80003d58:	4785                	li	a5,1
    80003d5a:	04f90d63          	beq	s2,a5,80003db4 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003d5e:	3979                	addiw	s2,s2,-2
    80003d60:	4785                	li	a5,1
    80003d62:	0527e063          	bltu	a5,s2,80003da2 <fileclose+0xa8>
    begin_op();
    80003d66:	00000097          	auipc	ra,0x0
    80003d6a:	acc080e7          	jalr	-1332(ra) # 80003832 <begin_op>
    iput(ff.ip);
    80003d6e:	854e                	mv	a0,s3
    80003d70:	fffff097          	auipc	ra,0xfffff
    80003d74:	2a0080e7          	jalr	672(ra) # 80003010 <iput>
    end_op();
    80003d78:	00000097          	auipc	ra,0x0
    80003d7c:	b38080e7          	jalr	-1224(ra) # 800038b0 <end_op>
    80003d80:	a00d                	j	80003da2 <fileclose+0xa8>
    panic("fileclose");
    80003d82:	00005517          	auipc	a0,0x5
    80003d86:	8b650513          	addi	a0,a0,-1866 # 80008638 <syscalls+0x268>
    80003d8a:	00002097          	auipc	ra,0x2
    80003d8e:	47a080e7          	jalr	1146(ra) # 80006204 <panic>
    release(&ftable.lock);
    80003d92:	00019517          	auipc	a0,0x19
    80003d96:	03650513          	addi	a0,a0,54 # 8001cdc8 <ftable>
    80003d9a:	00003097          	auipc	ra,0x3
    80003d9e:	a5c080e7          	jalr	-1444(ra) # 800067f6 <release>
  }
}
    80003da2:	70e2                	ld	ra,56(sp)
    80003da4:	7442                	ld	s0,48(sp)
    80003da6:	74a2                	ld	s1,40(sp)
    80003da8:	7902                	ld	s2,32(sp)
    80003daa:	69e2                	ld	s3,24(sp)
    80003dac:	6a42                	ld	s4,16(sp)
    80003dae:	6aa2                	ld	s5,8(sp)
    80003db0:	6121                	addi	sp,sp,64
    80003db2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003db4:	85d6                	mv	a1,s5
    80003db6:	8552                	mv	a0,s4
    80003db8:	00000097          	auipc	ra,0x0
    80003dbc:	34c080e7          	jalr	844(ra) # 80004104 <pipeclose>
    80003dc0:	b7cd                	j	80003da2 <fileclose+0xa8>

0000000080003dc2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003dc2:	715d                	addi	sp,sp,-80
    80003dc4:	e486                	sd	ra,72(sp)
    80003dc6:	e0a2                	sd	s0,64(sp)
    80003dc8:	fc26                	sd	s1,56(sp)
    80003dca:	f84a                	sd	s2,48(sp)
    80003dcc:	f44e                	sd	s3,40(sp)
    80003dce:	0880                	addi	s0,sp,80
    80003dd0:	84aa                	mv	s1,a0
    80003dd2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003dd4:	ffffd097          	auipc	ra,0xffffd
    80003dd8:	218080e7          	jalr	536(ra) # 80000fec <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ddc:	409c                	lw	a5,0(s1)
    80003dde:	37f9                	addiw	a5,a5,-2
    80003de0:	4705                	li	a4,1
    80003de2:	04f76763          	bltu	a4,a5,80003e30 <filestat+0x6e>
    80003de6:	892a                	mv	s2,a0
    ilock(f->ip);
    80003de8:	6c88                	ld	a0,24(s1)
    80003dea:	fffff097          	auipc	ra,0xfffff
    80003dee:	06c080e7          	jalr	108(ra) # 80002e56 <ilock>
    stati(f->ip, &st);
    80003df2:	fb840593          	addi	a1,s0,-72
    80003df6:	6c88                	ld	a0,24(s1)
    80003df8:	fffff097          	auipc	ra,0xfffff
    80003dfc:	2e8080e7          	jalr	744(ra) # 800030e0 <stati>
    iunlock(f->ip);
    80003e00:	6c88                	ld	a0,24(s1)
    80003e02:	fffff097          	auipc	ra,0xfffff
    80003e06:	116080e7          	jalr	278(ra) # 80002f18 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003e0a:	46e1                	li	a3,24
    80003e0c:	fb840613          	addi	a2,s0,-72
    80003e10:	85ce                	mv	a1,s3
    80003e12:	05893503          	ld	a0,88(s2)
    80003e16:	ffffd097          	auipc	ra,0xffffd
    80003e1a:	e9a080e7          	jalr	-358(ra) # 80000cb0 <copyout>
    80003e1e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003e22:	60a6                	ld	ra,72(sp)
    80003e24:	6406                	ld	s0,64(sp)
    80003e26:	74e2                	ld	s1,56(sp)
    80003e28:	7942                	ld	s2,48(sp)
    80003e2a:	79a2                	ld	s3,40(sp)
    80003e2c:	6161                	addi	sp,sp,80
    80003e2e:	8082                	ret
  return -1;
    80003e30:	557d                	li	a0,-1
    80003e32:	bfc5                	j	80003e22 <filestat+0x60>

0000000080003e34 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e34:	7179                	addi	sp,sp,-48
    80003e36:	f406                	sd	ra,40(sp)
    80003e38:	f022                	sd	s0,32(sp)
    80003e3a:	ec26                	sd	s1,24(sp)
    80003e3c:	e84a                	sd	s2,16(sp)
    80003e3e:	e44e                	sd	s3,8(sp)
    80003e40:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003e42:	00854783          	lbu	a5,8(a0)
    80003e46:	c3d5                	beqz	a5,80003eea <fileread+0xb6>
    80003e48:	84aa                	mv	s1,a0
    80003e4a:	89ae                	mv	s3,a1
    80003e4c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e4e:	411c                	lw	a5,0(a0)
    80003e50:	4705                	li	a4,1
    80003e52:	04e78963          	beq	a5,a4,80003ea4 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e56:	470d                	li	a4,3
    80003e58:	04e78d63          	beq	a5,a4,80003eb2 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e5c:	4709                	li	a4,2
    80003e5e:	06e79e63          	bne	a5,a4,80003eda <fileread+0xa6>
    ilock(f->ip);
    80003e62:	6d08                	ld	a0,24(a0)
    80003e64:	fffff097          	auipc	ra,0xfffff
    80003e68:	ff2080e7          	jalr	-14(ra) # 80002e56 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e6c:	874a                	mv	a4,s2
    80003e6e:	5094                	lw	a3,32(s1)
    80003e70:	864e                	mv	a2,s3
    80003e72:	4585                	li	a1,1
    80003e74:	6c88                	ld	a0,24(s1)
    80003e76:	fffff097          	auipc	ra,0xfffff
    80003e7a:	294080e7          	jalr	660(ra) # 8000310a <readi>
    80003e7e:	892a                	mv	s2,a0
    80003e80:	00a05563          	blez	a0,80003e8a <fileread+0x56>
      f->off += r;
    80003e84:	509c                	lw	a5,32(s1)
    80003e86:	9fa9                	addw	a5,a5,a0
    80003e88:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e8a:	6c88                	ld	a0,24(s1)
    80003e8c:	fffff097          	auipc	ra,0xfffff
    80003e90:	08c080e7          	jalr	140(ra) # 80002f18 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e94:	854a                	mv	a0,s2
    80003e96:	70a2                	ld	ra,40(sp)
    80003e98:	7402                	ld	s0,32(sp)
    80003e9a:	64e2                	ld	s1,24(sp)
    80003e9c:	6942                	ld	s2,16(sp)
    80003e9e:	69a2                	ld	s3,8(sp)
    80003ea0:	6145                	addi	sp,sp,48
    80003ea2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ea4:	6908                	ld	a0,16(a0)
    80003ea6:	00000097          	auipc	ra,0x0
    80003eaa:	3ca080e7          	jalr	970(ra) # 80004270 <piperead>
    80003eae:	892a                	mv	s2,a0
    80003eb0:	b7d5                	j	80003e94 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003eb2:	02451783          	lh	a5,36(a0)
    80003eb6:	03079693          	slli	a3,a5,0x30
    80003eba:	92c1                	srli	a3,a3,0x30
    80003ebc:	4725                	li	a4,9
    80003ebe:	02d76863          	bltu	a4,a3,80003eee <fileread+0xba>
    80003ec2:	0792                	slli	a5,a5,0x4
    80003ec4:	00019717          	auipc	a4,0x19
    80003ec8:	e6470713          	addi	a4,a4,-412 # 8001cd28 <devsw>
    80003ecc:	97ba                	add	a5,a5,a4
    80003ece:	639c                	ld	a5,0(a5)
    80003ed0:	c38d                	beqz	a5,80003ef2 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ed2:	4505                	li	a0,1
    80003ed4:	9782                	jalr	a5
    80003ed6:	892a                	mv	s2,a0
    80003ed8:	bf75                	j	80003e94 <fileread+0x60>
    panic("fileread");
    80003eda:	00004517          	auipc	a0,0x4
    80003ede:	76e50513          	addi	a0,a0,1902 # 80008648 <syscalls+0x278>
    80003ee2:	00002097          	auipc	ra,0x2
    80003ee6:	322080e7          	jalr	802(ra) # 80006204 <panic>
    return -1;
    80003eea:	597d                	li	s2,-1
    80003eec:	b765                	j	80003e94 <fileread+0x60>
      return -1;
    80003eee:	597d                	li	s2,-1
    80003ef0:	b755                	j	80003e94 <fileread+0x60>
    80003ef2:	597d                	li	s2,-1
    80003ef4:	b745                	j	80003e94 <fileread+0x60>

0000000080003ef6 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003ef6:	715d                	addi	sp,sp,-80
    80003ef8:	e486                	sd	ra,72(sp)
    80003efa:	e0a2                	sd	s0,64(sp)
    80003efc:	fc26                	sd	s1,56(sp)
    80003efe:	f84a                	sd	s2,48(sp)
    80003f00:	f44e                	sd	s3,40(sp)
    80003f02:	f052                	sd	s4,32(sp)
    80003f04:	ec56                	sd	s5,24(sp)
    80003f06:	e85a                	sd	s6,16(sp)
    80003f08:	e45e                	sd	s7,8(sp)
    80003f0a:	e062                	sd	s8,0(sp)
    80003f0c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003f0e:	00954783          	lbu	a5,9(a0)
    80003f12:	10078663          	beqz	a5,8000401e <filewrite+0x128>
    80003f16:	892a                	mv	s2,a0
    80003f18:	8b2e                	mv	s6,a1
    80003f1a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f1c:	411c                	lw	a5,0(a0)
    80003f1e:	4705                	li	a4,1
    80003f20:	02e78263          	beq	a5,a4,80003f44 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f24:	470d                	li	a4,3
    80003f26:	02e78663          	beq	a5,a4,80003f52 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f2a:	4709                	li	a4,2
    80003f2c:	0ee79163          	bne	a5,a4,8000400e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f30:	0ac05d63          	blez	a2,80003fea <filewrite+0xf4>
    int i = 0;
    80003f34:	4981                	li	s3,0
    80003f36:	6b85                	lui	s7,0x1
    80003f38:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f3c:	6c05                	lui	s8,0x1
    80003f3e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f42:	a861                	j	80003fda <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003f44:	6908                	ld	a0,16(a0)
    80003f46:	00000097          	auipc	ra,0x0
    80003f4a:	238080e7          	jalr	568(ra) # 8000417e <pipewrite>
    80003f4e:	8a2a                	mv	s4,a0
    80003f50:	a045                	j	80003ff0 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003f52:	02451783          	lh	a5,36(a0)
    80003f56:	03079693          	slli	a3,a5,0x30
    80003f5a:	92c1                	srli	a3,a3,0x30
    80003f5c:	4725                	li	a4,9
    80003f5e:	0cd76263          	bltu	a4,a3,80004022 <filewrite+0x12c>
    80003f62:	0792                	slli	a5,a5,0x4
    80003f64:	00019717          	auipc	a4,0x19
    80003f68:	dc470713          	addi	a4,a4,-572 # 8001cd28 <devsw>
    80003f6c:	97ba                	add	a5,a5,a4
    80003f6e:	679c                	ld	a5,8(a5)
    80003f70:	cbdd                	beqz	a5,80004026 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003f72:	4505                	li	a0,1
    80003f74:	9782                	jalr	a5
    80003f76:	8a2a                	mv	s4,a0
    80003f78:	a8a5                	j	80003ff0 <filewrite+0xfa>
    80003f7a:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003f7e:	00000097          	auipc	ra,0x0
    80003f82:	8b4080e7          	jalr	-1868(ra) # 80003832 <begin_op>
      ilock(f->ip);
    80003f86:	01893503          	ld	a0,24(s2)
    80003f8a:	fffff097          	auipc	ra,0xfffff
    80003f8e:	ecc080e7          	jalr	-308(ra) # 80002e56 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f92:	8756                	mv	a4,s5
    80003f94:	02092683          	lw	a3,32(s2)
    80003f98:	01698633          	add	a2,s3,s6
    80003f9c:	4585                	li	a1,1
    80003f9e:	01893503          	ld	a0,24(s2)
    80003fa2:	fffff097          	auipc	ra,0xfffff
    80003fa6:	260080e7          	jalr	608(ra) # 80003202 <writei>
    80003faa:	84aa                	mv	s1,a0
    80003fac:	00a05763          	blez	a0,80003fba <filewrite+0xc4>
        f->off += r;
    80003fb0:	02092783          	lw	a5,32(s2)
    80003fb4:	9fa9                	addw	a5,a5,a0
    80003fb6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003fba:	01893503          	ld	a0,24(s2)
    80003fbe:	fffff097          	auipc	ra,0xfffff
    80003fc2:	f5a080e7          	jalr	-166(ra) # 80002f18 <iunlock>
      end_op();
    80003fc6:	00000097          	auipc	ra,0x0
    80003fca:	8ea080e7          	jalr	-1814(ra) # 800038b0 <end_op>

      if(r != n1){
    80003fce:	009a9f63          	bne	s5,s1,80003fec <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003fd2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003fd6:	0149db63          	bge	s3,s4,80003fec <filewrite+0xf6>
      int n1 = n - i;
    80003fda:	413a04bb          	subw	s1,s4,s3
    80003fde:	0004879b          	sext.w	a5,s1
    80003fe2:	f8fbdce3          	bge	s7,a5,80003f7a <filewrite+0x84>
    80003fe6:	84e2                	mv	s1,s8
    80003fe8:	bf49                	j	80003f7a <filewrite+0x84>
    int i = 0;
    80003fea:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003fec:	013a1f63          	bne	s4,s3,8000400a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ff0:	8552                	mv	a0,s4
    80003ff2:	60a6                	ld	ra,72(sp)
    80003ff4:	6406                	ld	s0,64(sp)
    80003ff6:	74e2                	ld	s1,56(sp)
    80003ff8:	7942                	ld	s2,48(sp)
    80003ffa:	79a2                	ld	s3,40(sp)
    80003ffc:	7a02                	ld	s4,32(sp)
    80003ffe:	6ae2                	ld	s5,24(sp)
    80004000:	6b42                	ld	s6,16(sp)
    80004002:	6ba2                	ld	s7,8(sp)
    80004004:	6c02                	ld	s8,0(sp)
    80004006:	6161                	addi	sp,sp,80
    80004008:	8082                	ret
    ret = (i == n ? n : -1);
    8000400a:	5a7d                	li	s4,-1
    8000400c:	b7d5                	j	80003ff0 <filewrite+0xfa>
    panic("filewrite");
    8000400e:	00004517          	auipc	a0,0x4
    80004012:	64a50513          	addi	a0,a0,1610 # 80008658 <syscalls+0x288>
    80004016:	00002097          	auipc	ra,0x2
    8000401a:	1ee080e7          	jalr	494(ra) # 80006204 <panic>
    return -1;
    8000401e:	5a7d                	li	s4,-1
    80004020:	bfc1                	j	80003ff0 <filewrite+0xfa>
      return -1;
    80004022:	5a7d                	li	s4,-1
    80004024:	b7f1                	j	80003ff0 <filewrite+0xfa>
    80004026:	5a7d                	li	s4,-1
    80004028:	b7e1                	j	80003ff0 <filewrite+0xfa>

000000008000402a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000402a:	7179                	addi	sp,sp,-48
    8000402c:	f406                	sd	ra,40(sp)
    8000402e:	f022                	sd	s0,32(sp)
    80004030:	ec26                	sd	s1,24(sp)
    80004032:	e84a                	sd	s2,16(sp)
    80004034:	e44e                	sd	s3,8(sp)
    80004036:	e052                	sd	s4,0(sp)
    80004038:	1800                	addi	s0,sp,48
    8000403a:	84aa                	mv	s1,a0
    8000403c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000403e:	0005b023          	sd	zero,0(a1)
    80004042:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004046:	00000097          	auipc	ra,0x0
    8000404a:	bf8080e7          	jalr	-1032(ra) # 80003c3e <filealloc>
    8000404e:	e088                	sd	a0,0(s1)
    80004050:	c551                	beqz	a0,800040dc <pipealloc+0xb2>
    80004052:	00000097          	auipc	ra,0x0
    80004056:	bec080e7          	jalr	-1044(ra) # 80003c3e <filealloc>
    8000405a:	00aa3023          	sd	a0,0(s4)
    8000405e:	c92d                	beqz	a0,800040d0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004060:	ffffc097          	auipc	ra,0xffffc
    80004064:	1ee080e7          	jalr	494(ra) # 8000024e <kalloc>
    80004068:	892a                	mv	s2,a0
    8000406a:	c125                	beqz	a0,800040ca <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000406c:	4985                	li	s3,1
    8000406e:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80004072:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80004076:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    8000407a:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    8000407e:	00004597          	auipc	a1,0x4
    80004082:	5ea58593          	addi	a1,a1,1514 # 80008668 <syscalls+0x298>
    80004086:	00003097          	auipc	ra,0x3
    8000408a:	81c080e7          	jalr	-2020(ra) # 800068a2 <initlock>
  (*f0)->type = FD_PIPE;
    8000408e:	609c                	ld	a5,0(s1)
    80004090:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004094:	609c                	ld	a5,0(s1)
    80004096:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000409a:	609c                	ld	a5,0(s1)
    8000409c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800040a0:	609c                	ld	a5,0(s1)
    800040a2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040a6:	000a3783          	ld	a5,0(s4)
    800040aa:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800040ae:	000a3783          	ld	a5,0(s4)
    800040b2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800040b6:	000a3783          	ld	a5,0(s4)
    800040ba:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800040be:	000a3783          	ld	a5,0(s4)
    800040c2:	0127b823          	sd	s2,16(a5)
  return 0;
    800040c6:	4501                	li	a0,0
    800040c8:	a025                	j	800040f0 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800040ca:	6088                	ld	a0,0(s1)
    800040cc:	e501                	bnez	a0,800040d4 <pipealloc+0xaa>
    800040ce:	a039                	j	800040dc <pipealloc+0xb2>
    800040d0:	6088                	ld	a0,0(s1)
    800040d2:	c51d                	beqz	a0,80004100 <pipealloc+0xd6>
    fileclose(*f0);
    800040d4:	00000097          	auipc	ra,0x0
    800040d8:	c26080e7          	jalr	-986(ra) # 80003cfa <fileclose>
  if(*f1)
    800040dc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800040e0:	557d                	li	a0,-1
  if(*f1)
    800040e2:	c799                	beqz	a5,800040f0 <pipealloc+0xc6>
    fileclose(*f1);
    800040e4:	853e                	mv	a0,a5
    800040e6:	00000097          	auipc	ra,0x0
    800040ea:	c14080e7          	jalr	-1004(ra) # 80003cfa <fileclose>
  return -1;
    800040ee:	557d                	li	a0,-1
}
    800040f0:	70a2                	ld	ra,40(sp)
    800040f2:	7402                	ld	s0,32(sp)
    800040f4:	64e2                	ld	s1,24(sp)
    800040f6:	6942                	ld	s2,16(sp)
    800040f8:	69a2                	ld	s3,8(sp)
    800040fa:	6a02                	ld	s4,0(sp)
    800040fc:	6145                	addi	sp,sp,48
    800040fe:	8082                	ret
  return -1;
    80004100:	557d                	li	a0,-1
    80004102:	b7fd                	j	800040f0 <pipealloc+0xc6>

0000000080004104 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004104:	1101                	addi	sp,sp,-32
    80004106:	ec06                	sd	ra,24(sp)
    80004108:	e822                	sd	s0,16(sp)
    8000410a:	e426                	sd	s1,8(sp)
    8000410c:	e04a                	sd	s2,0(sp)
    8000410e:	1000                	addi	s0,sp,32
    80004110:	84aa                	mv	s1,a0
    80004112:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004114:	00002097          	auipc	ra,0x2
    80004118:	612080e7          	jalr	1554(ra) # 80006726 <acquire>
  if(writable){
    8000411c:	04090263          	beqz	s2,80004160 <pipeclose+0x5c>
    pi->writeopen = 0;
    80004120:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    80004124:	22048513          	addi	a0,s1,544
    80004128:	ffffd097          	auipc	ra,0xffffd
    8000412c:	714080e7          	jalr	1812(ra) # 8000183c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004130:	2284b783          	ld	a5,552(s1)
    80004134:	ef9d                	bnez	a5,80004172 <pipeclose+0x6e>
    release(&pi->lock);
    80004136:	8526                	mv	a0,s1
    80004138:	00002097          	auipc	ra,0x2
    8000413c:	6be080e7          	jalr	1726(ra) # 800067f6 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    80004140:	8526                	mv	a0,s1
    80004142:	00002097          	auipc	ra,0x2
    80004146:	6fc080e7          	jalr	1788(ra) # 8000683e <freelock>
#endif    
    kfree((char*)pi);
    8000414a:	8526                	mv	a0,s1
    8000414c:	ffffc097          	auipc	ra,0xffffc
    80004150:	ed0080e7          	jalr	-304(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004154:	60e2                	ld	ra,24(sp)
    80004156:	6442                	ld	s0,16(sp)
    80004158:	64a2                	ld	s1,8(sp)
    8000415a:	6902                	ld	s2,0(sp)
    8000415c:	6105                	addi	sp,sp,32
    8000415e:	8082                	ret
    pi->readopen = 0;
    80004160:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    80004164:	22448513          	addi	a0,s1,548
    80004168:	ffffd097          	auipc	ra,0xffffd
    8000416c:	6d4080e7          	jalr	1748(ra) # 8000183c <wakeup>
    80004170:	b7c1                	j	80004130 <pipeclose+0x2c>
    release(&pi->lock);
    80004172:	8526                	mv	a0,s1
    80004174:	00002097          	auipc	ra,0x2
    80004178:	682080e7          	jalr	1666(ra) # 800067f6 <release>
}
    8000417c:	bfe1                	j	80004154 <pipeclose+0x50>

000000008000417e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000417e:	711d                	addi	sp,sp,-96
    80004180:	ec86                	sd	ra,88(sp)
    80004182:	e8a2                	sd	s0,80(sp)
    80004184:	e4a6                	sd	s1,72(sp)
    80004186:	e0ca                	sd	s2,64(sp)
    80004188:	fc4e                	sd	s3,56(sp)
    8000418a:	f852                	sd	s4,48(sp)
    8000418c:	f456                	sd	s5,40(sp)
    8000418e:	f05a                	sd	s6,32(sp)
    80004190:	ec5e                	sd	s7,24(sp)
    80004192:	e862                	sd	s8,16(sp)
    80004194:	1080                	addi	s0,sp,96
    80004196:	84aa                	mv	s1,a0
    80004198:	8aae                	mv	s5,a1
    8000419a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000419c:	ffffd097          	auipc	ra,0xffffd
    800041a0:	e50080e7          	jalr	-432(ra) # 80000fec <myproc>
    800041a4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800041a6:	8526                	mv	a0,s1
    800041a8:	00002097          	auipc	ra,0x2
    800041ac:	57e080e7          	jalr	1406(ra) # 80006726 <acquire>
  while(i < n){
    800041b0:	0b405363          	blez	s4,80004256 <pipewrite+0xd8>
  int i = 0;
    800041b4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041b6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800041b8:	22048c13          	addi	s8,s1,544
      sleep(&pi->nwrite, &pi->lock);
    800041bc:	22448b93          	addi	s7,s1,548
    800041c0:	a089                	j	80004202 <pipewrite+0x84>
      release(&pi->lock);
    800041c2:	8526                	mv	a0,s1
    800041c4:	00002097          	auipc	ra,0x2
    800041c8:	632080e7          	jalr	1586(ra) # 800067f6 <release>
      return -1;
    800041cc:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800041ce:	854a                	mv	a0,s2
    800041d0:	60e6                	ld	ra,88(sp)
    800041d2:	6446                	ld	s0,80(sp)
    800041d4:	64a6                	ld	s1,72(sp)
    800041d6:	6906                	ld	s2,64(sp)
    800041d8:	79e2                	ld	s3,56(sp)
    800041da:	7a42                	ld	s4,48(sp)
    800041dc:	7aa2                	ld	s5,40(sp)
    800041de:	7b02                	ld	s6,32(sp)
    800041e0:	6be2                	ld	s7,24(sp)
    800041e2:	6c42                	ld	s8,16(sp)
    800041e4:	6125                	addi	sp,sp,96
    800041e6:	8082                	ret
      wakeup(&pi->nread);
    800041e8:	8562                	mv	a0,s8
    800041ea:	ffffd097          	auipc	ra,0xffffd
    800041ee:	652080e7          	jalr	1618(ra) # 8000183c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800041f2:	85a6                	mv	a1,s1
    800041f4:	855e                	mv	a0,s7
    800041f6:	ffffd097          	auipc	ra,0xffffd
    800041fa:	4ba080e7          	jalr	1210(ra) # 800016b0 <sleep>
  while(i < n){
    800041fe:	05495d63          	bge	s2,s4,80004258 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004202:	2284a783          	lw	a5,552(s1)
    80004206:	dfd5                	beqz	a5,800041c2 <pipewrite+0x44>
    80004208:	0309a783          	lw	a5,48(s3)
    8000420c:	fbdd                	bnez	a5,800041c2 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000420e:	2204a783          	lw	a5,544(s1)
    80004212:	2244a703          	lw	a4,548(s1)
    80004216:	2007879b          	addiw	a5,a5,512
    8000421a:	fcf707e3          	beq	a4,a5,800041e8 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000421e:	4685                	li	a3,1
    80004220:	01590633          	add	a2,s2,s5
    80004224:	faf40593          	addi	a1,s0,-81
    80004228:	0589b503          	ld	a0,88(s3)
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	b10080e7          	jalr	-1264(ra) # 80000d3c <copyin>
    80004234:	03650263          	beq	a0,s6,80004258 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004238:	2244a783          	lw	a5,548(s1)
    8000423c:	0017871b          	addiw	a4,a5,1
    80004240:	22e4a223          	sw	a4,548(s1)
    80004244:	1ff7f793          	andi	a5,a5,511
    80004248:	97a6                	add	a5,a5,s1
    8000424a:	faf44703          	lbu	a4,-81(s0)
    8000424e:	02e78023          	sb	a4,32(a5)
      i++;
    80004252:	2905                	addiw	s2,s2,1
    80004254:	b76d                	j	800041fe <pipewrite+0x80>
  int i = 0;
    80004256:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004258:	22048513          	addi	a0,s1,544
    8000425c:	ffffd097          	auipc	ra,0xffffd
    80004260:	5e0080e7          	jalr	1504(ra) # 8000183c <wakeup>
  release(&pi->lock);
    80004264:	8526                	mv	a0,s1
    80004266:	00002097          	auipc	ra,0x2
    8000426a:	590080e7          	jalr	1424(ra) # 800067f6 <release>
  return i;
    8000426e:	b785                	j	800041ce <pipewrite+0x50>

0000000080004270 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004270:	715d                	addi	sp,sp,-80
    80004272:	e486                	sd	ra,72(sp)
    80004274:	e0a2                	sd	s0,64(sp)
    80004276:	fc26                	sd	s1,56(sp)
    80004278:	f84a                	sd	s2,48(sp)
    8000427a:	f44e                	sd	s3,40(sp)
    8000427c:	f052                	sd	s4,32(sp)
    8000427e:	ec56                	sd	s5,24(sp)
    80004280:	e85a                	sd	s6,16(sp)
    80004282:	0880                	addi	s0,sp,80
    80004284:	84aa                	mv	s1,a0
    80004286:	892e                	mv	s2,a1
    80004288:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000428a:	ffffd097          	auipc	ra,0xffffd
    8000428e:	d62080e7          	jalr	-670(ra) # 80000fec <myproc>
    80004292:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004294:	8526                	mv	a0,s1
    80004296:	00002097          	auipc	ra,0x2
    8000429a:	490080e7          	jalr	1168(ra) # 80006726 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000429e:	2204a703          	lw	a4,544(s1)
    800042a2:	2244a783          	lw	a5,548(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042a6:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042aa:	02f71463          	bne	a4,a5,800042d2 <piperead+0x62>
    800042ae:	22c4a783          	lw	a5,556(s1)
    800042b2:	c385                	beqz	a5,800042d2 <piperead+0x62>
    if(pr->killed){
    800042b4:	030a2783          	lw	a5,48(s4)
    800042b8:	ebc9                	bnez	a5,8000434a <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042ba:	85a6                	mv	a1,s1
    800042bc:	854e                	mv	a0,s3
    800042be:	ffffd097          	auipc	ra,0xffffd
    800042c2:	3f2080e7          	jalr	1010(ra) # 800016b0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042c6:	2204a703          	lw	a4,544(s1)
    800042ca:	2244a783          	lw	a5,548(s1)
    800042ce:	fef700e3          	beq	a4,a5,800042ae <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042d2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042d4:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042d6:	05505463          	blez	s5,8000431e <piperead+0xae>
    if(pi->nread == pi->nwrite)
    800042da:	2204a783          	lw	a5,544(s1)
    800042de:	2244a703          	lw	a4,548(s1)
    800042e2:	02f70e63          	beq	a4,a5,8000431e <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800042e6:	0017871b          	addiw	a4,a5,1
    800042ea:	22e4a023          	sw	a4,544(s1)
    800042ee:	1ff7f793          	andi	a5,a5,511
    800042f2:	97a6                	add	a5,a5,s1
    800042f4:	0207c783          	lbu	a5,32(a5)
    800042f8:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042fc:	4685                	li	a3,1
    800042fe:	fbf40613          	addi	a2,s0,-65
    80004302:	85ca                	mv	a1,s2
    80004304:	058a3503          	ld	a0,88(s4)
    80004308:	ffffd097          	auipc	ra,0xffffd
    8000430c:	9a8080e7          	jalr	-1624(ra) # 80000cb0 <copyout>
    80004310:	01650763          	beq	a0,s6,8000431e <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004314:	2985                	addiw	s3,s3,1
    80004316:	0905                	addi	s2,s2,1
    80004318:	fd3a91e3          	bne	s5,s3,800042da <piperead+0x6a>
    8000431c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000431e:	22448513          	addi	a0,s1,548
    80004322:	ffffd097          	auipc	ra,0xffffd
    80004326:	51a080e7          	jalr	1306(ra) # 8000183c <wakeup>
  release(&pi->lock);
    8000432a:	8526                	mv	a0,s1
    8000432c:	00002097          	auipc	ra,0x2
    80004330:	4ca080e7          	jalr	1226(ra) # 800067f6 <release>
  return i;
}
    80004334:	854e                	mv	a0,s3
    80004336:	60a6                	ld	ra,72(sp)
    80004338:	6406                	ld	s0,64(sp)
    8000433a:	74e2                	ld	s1,56(sp)
    8000433c:	7942                	ld	s2,48(sp)
    8000433e:	79a2                	ld	s3,40(sp)
    80004340:	7a02                	ld	s4,32(sp)
    80004342:	6ae2                	ld	s5,24(sp)
    80004344:	6b42                	ld	s6,16(sp)
    80004346:	6161                	addi	sp,sp,80
    80004348:	8082                	ret
      release(&pi->lock);
    8000434a:	8526                	mv	a0,s1
    8000434c:	00002097          	auipc	ra,0x2
    80004350:	4aa080e7          	jalr	1194(ra) # 800067f6 <release>
      return -1;
    80004354:	59fd                	li	s3,-1
    80004356:	bff9                	j	80004334 <piperead+0xc4>

0000000080004358 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004358:	de010113          	addi	sp,sp,-544
    8000435c:	20113c23          	sd	ra,536(sp)
    80004360:	20813823          	sd	s0,528(sp)
    80004364:	20913423          	sd	s1,520(sp)
    80004368:	21213023          	sd	s2,512(sp)
    8000436c:	ffce                	sd	s3,504(sp)
    8000436e:	fbd2                	sd	s4,496(sp)
    80004370:	f7d6                	sd	s5,488(sp)
    80004372:	f3da                	sd	s6,480(sp)
    80004374:	efde                	sd	s7,472(sp)
    80004376:	ebe2                	sd	s8,464(sp)
    80004378:	e7e6                	sd	s9,456(sp)
    8000437a:	e3ea                	sd	s10,448(sp)
    8000437c:	ff6e                	sd	s11,440(sp)
    8000437e:	1400                	addi	s0,sp,544
    80004380:	892a                	mv	s2,a0
    80004382:	dea43423          	sd	a0,-536(s0)
    80004386:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000438a:	ffffd097          	auipc	ra,0xffffd
    8000438e:	c62080e7          	jalr	-926(ra) # 80000fec <myproc>
    80004392:	84aa                	mv	s1,a0

  begin_op();
    80004394:	fffff097          	auipc	ra,0xfffff
    80004398:	49e080e7          	jalr	1182(ra) # 80003832 <begin_op>

  if((ip = namei(path)) == 0){
    8000439c:	854a                	mv	a0,s2
    8000439e:	fffff097          	auipc	ra,0xfffff
    800043a2:	274080e7          	jalr	628(ra) # 80003612 <namei>
    800043a6:	c93d                	beqz	a0,8000441c <exec+0xc4>
    800043a8:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800043aa:	fffff097          	auipc	ra,0xfffff
    800043ae:	aac080e7          	jalr	-1364(ra) # 80002e56 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800043b2:	04000713          	li	a4,64
    800043b6:	4681                	li	a3,0
    800043b8:	e5040613          	addi	a2,s0,-432
    800043bc:	4581                	li	a1,0
    800043be:	8556                	mv	a0,s5
    800043c0:	fffff097          	auipc	ra,0xfffff
    800043c4:	d4a080e7          	jalr	-694(ra) # 8000310a <readi>
    800043c8:	04000793          	li	a5,64
    800043cc:	00f51a63          	bne	a0,a5,800043e0 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800043d0:	e5042703          	lw	a4,-432(s0)
    800043d4:	464c47b7          	lui	a5,0x464c4
    800043d8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800043dc:	04f70663          	beq	a4,a5,80004428 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800043e0:	8556                	mv	a0,s5
    800043e2:	fffff097          	auipc	ra,0xfffff
    800043e6:	cd6080e7          	jalr	-810(ra) # 800030b8 <iunlockput>
    end_op();
    800043ea:	fffff097          	auipc	ra,0xfffff
    800043ee:	4c6080e7          	jalr	1222(ra) # 800038b0 <end_op>
  }
  return -1;
    800043f2:	557d                	li	a0,-1
}
    800043f4:	21813083          	ld	ra,536(sp)
    800043f8:	21013403          	ld	s0,528(sp)
    800043fc:	20813483          	ld	s1,520(sp)
    80004400:	20013903          	ld	s2,512(sp)
    80004404:	79fe                	ld	s3,504(sp)
    80004406:	7a5e                	ld	s4,496(sp)
    80004408:	7abe                	ld	s5,488(sp)
    8000440a:	7b1e                	ld	s6,480(sp)
    8000440c:	6bfe                	ld	s7,472(sp)
    8000440e:	6c5e                	ld	s8,464(sp)
    80004410:	6cbe                	ld	s9,456(sp)
    80004412:	6d1e                	ld	s10,448(sp)
    80004414:	7dfa                	ld	s11,440(sp)
    80004416:	22010113          	addi	sp,sp,544
    8000441a:	8082                	ret
    end_op();
    8000441c:	fffff097          	auipc	ra,0xfffff
    80004420:	494080e7          	jalr	1172(ra) # 800038b0 <end_op>
    return -1;
    80004424:	557d                	li	a0,-1
    80004426:	b7f9                	j	800043f4 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004428:	8526                	mv	a0,s1
    8000442a:	ffffd097          	auipc	ra,0xffffd
    8000442e:	c86080e7          	jalr	-890(ra) # 800010b0 <proc_pagetable>
    80004432:	8b2a                	mv	s6,a0
    80004434:	d555                	beqz	a0,800043e0 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004436:	e7042783          	lw	a5,-400(s0)
    8000443a:	e8845703          	lhu	a4,-376(s0)
    8000443e:	c735                	beqz	a4,800044aa <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004440:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004442:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    80004446:	6a05                	lui	s4,0x1
    80004448:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000444c:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004450:	6d85                	lui	s11,0x1
    80004452:	7d7d                	lui	s10,0xfffff
    80004454:	ac1d                	j	8000468a <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004456:	00004517          	auipc	a0,0x4
    8000445a:	21a50513          	addi	a0,a0,538 # 80008670 <syscalls+0x2a0>
    8000445e:	00002097          	auipc	ra,0x2
    80004462:	da6080e7          	jalr	-602(ra) # 80006204 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004466:	874a                	mv	a4,s2
    80004468:	009c86bb          	addw	a3,s9,s1
    8000446c:	4581                	li	a1,0
    8000446e:	8556                	mv	a0,s5
    80004470:	fffff097          	auipc	ra,0xfffff
    80004474:	c9a080e7          	jalr	-870(ra) # 8000310a <readi>
    80004478:	2501                	sext.w	a0,a0
    8000447a:	1aa91863          	bne	s2,a0,8000462a <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    8000447e:	009d84bb          	addw	s1,s11,s1
    80004482:	013d09bb          	addw	s3,s10,s3
    80004486:	1f74f263          	bgeu	s1,s7,8000466a <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    8000448a:	02049593          	slli	a1,s1,0x20
    8000448e:	9181                	srli	a1,a1,0x20
    80004490:	95e2                	add	a1,a1,s8
    80004492:	855a                	mv	a0,s6
    80004494:	ffffc097          	auipc	ra,0xffffc
    80004498:	214080e7          	jalr	532(ra) # 800006a8 <walkaddr>
    8000449c:	862a                	mv	a2,a0
    if(pa == 0)
    8000449e:	dd45                	beqz	a0,80004456 <exec+0xfe>
      n = PGSIZE;
    800044a0:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800044a2:	fd49f2e3          	bgeu	s3,s4,80004466 <exec+0x10e>
      n = sz - i;
    800044a6:	894e                	mv	s2,s3
    800044a8:	bf7d                	j	80004466 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044aa:	4481                	li	s1,0
  iunlockput(ip);
    800044ac:	8556                	mv	a0,s5
    800044ae:	fffff097          	auipc	ra,0xfffff
    800044b2:	c0a080e7          	jalr	-1014(ra) # 800030b8 <iunlockput>
  end_op();
    800044b6:	fffff097          	auipc	ra,0xfffff
    800044ba:	3fa080e7          	jalr	1018(ra) # 800038b0 <end_op>
  p = myproc();
    800044be:	ffffd097          	auipc	ra,0xffffd
    800044c2:	b2e080e7          	jalr	-1234(ra) # 80000fec <myproc>
    800044c6:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800044c8:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    800044cc:	6785                	lui	a5,0x1
    800044ce:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800044d0:	97a6                	add	a5,a5,s1
    800044d2:	777d                	lui	a4,0xfffff
    800044d4:	8ff9                	and	a5,a5,a4
    800044d6:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800044da:	6609                	lui	a2,0x2
    800044dc:	963e                	add	a2,a2,a5
    800044de:	85be                	mv	a1,a5
    800044e0:	855a                	mv	a0,s6
    800044e2:	ffffc097          	auipc	ra,0xffffc
    800044e6:	57a080e7          	jalr	1402(ra) # 80000a5c <uvmalloc>
    800044ea:	8c2a                	mv	s8,a0
  ip = 0;
    800044ec:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800044ee:	12050e63          	beqz	a0,8000462a <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    800044f2:	75f9                	lui	a1,0xffffe
    800044f4:	95aa                	add	a1,a1,a0
    800044f6:	855a                	mv	a0,s6
    800044f8:	ffffc097          	auipc	ra,0xffffc
    800044fc:	786080e7          	jalr	1926(ra) # 80000c7e <uvmclear>
  stackbase = sp - PGSIZE;
    80004500:	7afd                	lui	s5,0xfffff
    80004502:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004504:	df043783          	ld	a5,-528(s0)
    80004508:	6388                	ld	a0,0(a5)
    8000450a:	c925                	beqz	a0,8000457a <exec+0x222>
    8000450c:	e9040993          	addi	s3,s0,-368
    80004510:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004514:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004516:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004518:	ffffc097          	auipc	ra,0xffffc
    8000451c:	f76080e7          	jalr	-138(ra) # 8000048e <strlen>
    80004520:	0015079b          	addiw	a5,a0,1
    80004524:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004528:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000452c:	13596363          	bltu	s2,s5,80004652 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004530:	df043d83          	ld	s11,-528(s0)
    80004534:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004538:	8552                	mv	a0,s4
    8000453a:	ffffc097          	auipc	ra,0xffffc
    8000453e:	f54080e7          	jalr	-172(ra) # 8000048e <strlen>
    80004542:	0015069b          	addiw	a3,a0,1
    80004546:	8652                	mv	a2,s4
    80004548:	85ca                	mv	a1,s2
    8000454a:	855a                	mv	a0,s6
    8000454c:	ffffc097          	auipc	ra,0xffffc
    80004550:	764080e7          	jalr	1892(ra) # 80000cb0 <copyout>
    80004554:	10054363          	bltz	a0,8000465a <exec+0x302>
    ustack[argc] = sp;
    80004558:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000455c:	0485                	addi	s1,s1,1
    8000455e:	008d8793          	addi	a5,s11,8
    80004562:	def43823          	sd	a5,-528(s0)
    80004566:	008db503          	ld	a0,8(s11)
    8000456a:	c911                	beqz	a0,8000457e <exec+0x226>
    if(argc >= MAXARG)
    8000456c:	09a1                	addi	s3,s3,8
    8000456e:	fb3c95e3          	bne	s9,s3,80004518 <exec+0x1c0>
  sz = sz1;
    80004572:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004576:	4a81                	li	s5,0
    80004578:	a84d                	j	8000462a <exec+0x2d2>
  sp = sz;
    8000457a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000457c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000457e:	00349793          	slli	a5,s1,0x3
    80004582:	f9078793          	addi	a5,a5,-112
    80004586:	97a2                	add	a5,a5,s0
    80004588:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000458c:	00148693          	addi	a3,s1,1
    80004590:	068e                	slli	a3,a3,0x3
    80004592:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004596:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000459a:	01597663          	bgeu	s2,s5,800045a6 <exec+0x24e>
  sz = sz1;
    8000459e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045a2:	4a81                	li	s5,0
    800045a4:	a059                	j	8000462a <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800045a6:	e9040613          	addi	a2,s0,-368
    800045aa:	85ca                	mv	a1,s2
    800045ac:	855a                	mv	a0,s6
    800045ae:	ffffc097          	auipc	ra,0xffffc
    800045b2:	702080e7          	jalr	1794(ra) # 80000cb0 <copyout>
    800045b6:	0a054663          	bltz	a0,80004662 <exec+0x30a>
  p->trapframe->a1 = sp;
    800045ba:	060bb783          	ld	a5,96(s7)
    800045be:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800045c2:	de843783          	ld	a5,-536(s0)
    800045c6:	0007c703          	lbu	a4,0(a5)
    800045ca:	cf11                	beqz	a4,800045e6 <exec+0x28e>
    800045cc:	0785                	addi	a5,a5,1
    if(*s == '/')
    800045ce:	02f00693          	li	a3,47
    800045d2:	a039                	j	800045e0 <exec+0x288>
      last = s+1;
    800045d4:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800045d8:	0785                	addi	a5,a5,1
    800045da:	fff7c703          	lbu	a4,-1(a5)
    800045de:	c701                	beqz	a4,800045e6 <exec+0x28e>
    if(*s == '/')
    800045e0:	fed71ce3          	bne	a4,a3,800045d8 <exec+0x280>
    800045e4:	bfc5                	j	800045d4 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800045e6:	4641                	li	a2,16
    800045e8:	de843583          	ld	a1,-536(s0)
    800045ec:	160b8513          	addi	a0,s7,352
    800045f0:	ffffc097          	auipc	ra,0xffffc
    800045f4:	e6c080e7          	jalr	-404(ra) # 8000045c <safestrcpy>
  oldpagetable = p->pagetable;
    800045f8:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    800045fc:	056bbc23          	sd	s6,88(s7)
  p->sz = sz;
    80004600:	058bb823          	sd	s8,80(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004604:	060bb783          	ld	a5,96(s7)
    80004608:	e6843703          	ld	a4,-408(s0)
    8000460c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000460e:	060bb783          	ld	a5,96(s7)
    80004612:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004616:	85ea                	mv	a1,s10
    80004618:	ffffd097          	auipc	ra,0xffffd
    8000461c:	b34080e7          	jalr	-1228(ra) # 8000114c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004620:	0004851b          	sext.w	a0,s1
    80004624:	bbc1                	j	800043f4 <exec+0x9c>
    80004626:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000462a:	df843583          	ld	a1,-520(s0)
    8000462e:	855a                	mv	a0,s6
    80004630:	ffffd097          	auipc	ra,0xffffd
    80004634:	b1c080e7          	jalr	-1252(ra) # 8000114c <proc_freepagetable>
  if(ip){
    80004638:	da0a94e3          	bnez	s5,800043e0 <exec+0x88>
  return -1;
    8000463c:	557d                	li	a0,-1
    8000463e:	bb5d                	j	800043f4 <exec+0x9c>
    80004640:	de943c23          	sd	s1,-520(s0)
    80004644:	b7dd                	j	8000462a <exec+0x2d2>
    80004646:	de943c23          	sd	s1,-520(s0)
    8000464a:	b7c5                	j	8000462a <exec+0x2d2>
    8000464c:	de943c23          	sd	s1,-520(s0)
    80004650:	bfe9                	j	8000462a <exec+0x2d2>
  sz = sz1;
    80004652:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004656:	4a81                	li	s5,0
    80004658:	bfc9                	j	8000462a <exec+0x2d2>
  sz = sz1;
    8000465a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000465e:	4a81                	li	s5,0
    80004660:	b7e9                	j	8000462a <exec+0x2d2>
  sz = sz1;
    80004662:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004666:	4a81                	li	s5,0
    80004668:	b7c9                	j	8000462a <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000466a:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000466e:	e0843783          	ld	a5,-504(s0)
    80004672:	0017869b          	addiw	a3,a5,1
    80004676:	e0d43423          	sd	a3,-504(s0)
    8000467a:	e0043783          	ld	a5,-512(s0)
    8000467e:	0387879b          	addiw	a5,a5,56
    80004682:	e8845703          	lhu	a4,-376(s0)
    80004686:	e2e6d3e3          	bge	a3,a4,800044ac <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000468a:	2781                	sext.w	a5,a5
    8000468c:	e0f43023          	sd	a5,-512(s0)
    80004690:	03800713          	li	a4,56
    80004694:	86be                	mv	a3,a5
    80004696:	e1840613          	addi	a2,s0,-488
    8000469a:	4581                	li	a1,0
    8000469c:	8556                	mv	a0,s5
    8000469e:	fffff097          	auipc	ra,0xfffff
    800046a2:	a6c080e7          	jalr	-1428(ra) # 8000310a <readi>
    800046a6:	03800793          	li	a5,56
    800046aa:	f6f51ee3          	bne	a0,a5,80004626 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    800046ae:	e1842783          	lw	a5,-488(s0)
    800046b2:	4705                	li	a4,1
    800046b4:	fae79de3          	bne	a5,a4,8000466e <exec+0x316>
    if(ph.memsz < ph.filesz)
    800046b8:	e4043603          	ld	a2,-448(s0)
    800046bc:	e3843783          	ld	a5,-456(s0)
    800046c0:	f8f660e3          	bltu	a2,a5,80004640 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800046c4:	e2843783          	ld	a5,-472(s0)
    800046c8:	963e                	add	a2,a2,a5
    800046ca:	f6f66ee3          	bltu	a2,a5,80004646 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800046ce:	85a6                	mv	a1,s1
    800046d0:	855a                	mv	a0,s6
    800046d2:	ffffc097          	auipc	ra,0xffffc
    800046d6:	38a080e7          	jalr	906(ra) # 80000a5c <uvmalloc>
    800046da:	dea43c23          	sd	a0,-520(s0)
    800046de:	d53d                	beqz	a0,8000464c <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    800046e0:	e2843c03          	ld	s8,-472(s0)
    800046e4:	de043783          	ld	a5,-544(s0)
    800046e8:	00fc77b3          	and	a5,s8,a5
    800046ec:	ff9d                	bnez	a5,8000462a <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800046ee:	e2042c83          	lw	s9,-480(s0)
    800046f2:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800046f6:	f60b8ae3          	beqz	s7,8000466a <exec+0x312>
    800046fa:	89de                	mv	s3,s7
    800046fc:	4481                	li	s1,0
    800046fe:	b371                	j	8000448a <exec+0x132>

0000000080004700 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004700:	7179                	addi	sp,sp,-48
    80004702:	f406                	sd	ra,40(sp)
    80004704:	f022                	sd	s0,32(sp)
    80004706:	ec26                	sd	s1,24(sp)
    80004708:	e84a                	sd	s2,16(sp)
    8000470a:	1800                	addi	s0,sp,48
    8000470c:	892e                	mv	s2,a1
    8000470e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004710:	fdc40593          	addi	a1,s0,-36
    80004714:	ffffe097          	auipc	ra,0xffffe
    80004718:	98e080e7          	jalr	-1650(ra) # 800020a2 <argint>
    8000471c:	04054063          	bltz	a0,8000475c <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004720:	fdc42703          	lw	a4,-36(s0)
    80004724:	47bd                	li	a5,15
    80004726:	02e7ed63          	bltu	a5,a4,80004760 <argfd+0x60>
    8000472a:	ffffd097          	auipc	ra,0xffffd
    8000472e:	8c2080e7          	jalr	-1854(ra) # 80000fec <myproc>
    80004732:	fdc42703          	lw	a4,-36(s0)
    80004736:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd3dd2>
    8000473a:	078e                	slli	a5,a5,0x3
    8000473c:	953e                	add	a0,a0,a5
    8000473e:	651c                	ld	a5,8(a0)
    80004740:	c395                	beqz	a5,80004764 <argfd+0x64>
    return -1;
  if(pfd)
    80004742:	00090463          	beqz	s2,8000474a <argfd+0x4a>
    *pfd = fd;
    80004746:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000474a:	4501                	li	a0,0
  if(pf)
    8000474c:	c091                	beqz	s1,80004750 <argfd+0x50>
    *pf = f;
    8000474e:	e09c                	sd	a5,0(s1)
}
    80004750:	70a2                	ld	ra,40(sp)
    80004752:	7402                	ld	s0,32(sp)
    80004754:	64e2                	ld	s1,24(sp)
    80004756:	6942                	ld	s2,16(sp)
    80004758:	6145                	addi	sp,sp,48
    8000475a:	8082                	ret
    return -1;
    8000475c:	557d                	li	a0,-1
    8000475e:	bfcd                	j	80004750 <argfd+0x50>
    return -1;
    80004760:	557d                	li	a0,-1
    80004762:	b7fd                	j	80004750 <argfd+0x50>
    80004764:	557d                	li	a0,-1
    80004766:	b7ed                	j	80004750 <argfd+0x50>

0000000080004768 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004768:	1101                	addi	sp,sp,-32
    8000476a:	ec06                	sd	ra,24(sp)
    8000476c:	e822                	sd	s0,16(sp)
    8000476e:	e426                	sd	s1,8(sp)
    80004770:	1000                	addi	s0,sp,32
    80004772:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004774:	ffffd097          	auipc	ra,0xffffd
    80004778:	878080e7          	jalr	-1928(ra) # 80000fec <myproc>
    8000477c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000477e:	0d850793          	addi	a5,a0,216
    80004782:	4501                	li	a0,0
    80004784:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004786:	6398                	ld	a4,0(a5)
    80004788:	cb19                	beqz	a4,8000479e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000478a:	2505                	addiw	a0,a0,1
    8000478c:	07a1                	addi	a5,a5,8
    8000478e:	fed51ce3          	bne	a0,a3,80004786 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004792:	557d                	li	a0,-1
}
    80004794:	60e2                	ld	ra,24(sp)
    80004796:	6442                	ld	s0,16(sp)
    80004798:	64a2                	ld	s1,8(sp)
    8000479a:	6105                	addi	sp,sp,32
    8000479c:	8082                	ret
      p->ofile[fd] = f;
    8000479e:	01a50793          	addi	a5,a0,26
    800047a2:	078e                	slli	a5,a5,0x3
    800047a4:	963e                	add	a2,a2,a5
    800047a6:	e604                	sd	s1,8(a2)
      return fd;
    800047a8:	b7f5                	j	80004794 <fdalloc+0x2c>

00000000800047aa <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800047aa:	715d                	addi	sp,sp,-80
    800047ac:	e486                	sd	ra,72(sp)
    800047ae:	e0a2                	sd	s0,64(sp)
    800047b0:	fc26                	sd	s1,56(sp)
    800047b2:	f84a                	sd	s2,48(sp)
    800047b4:	f44e                	sd	s3,40(sp)
    800047b6:	f052                	sd	s4,32(sp)
    800047b8:	ec56                	sd	s5,24(sp)
    800047ba:	0880                	addi	s0,sp,80
    800047bc:	89ae                	mv	s3,a1
    800047be:	8ab2                	mv	s5,a2
    800047c0:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800047c2:	fb040593          	addi	a1,s0,-80
    800047c6:	fffff097          	auipc	ra,0xfffff
    800047ca:	e6a080e7          	jalr	-406(ra) # 80003630 <nameiparent>
    800047ce:	892a                	mv	s2,a0
    800047d0:	12050e63          	beqz	a0,8000490c <create+0x162>
    return 0;

  ilock(dp);
    800047d4:	ffffe097          	auipc	ra,0xffffe
    800047d8:	682080e7          	jalr	1666(ra) # 80002e56 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800047dc:	4601                	li	a2,0
    800047de:	fb040593          	addi	a1,s0,-80
    800047e2:	854a                	mv	a0,s2
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	b56080e7          	jalr	-1194(ra) # 8000333a <dirlookup>
    800047ec:	84aa                	mv	s1,a0
    800047ee:	c921                	beqz	a0,8000483e <create+0x94>
    iunlockput(dp);
    800047f0:	854a                	mv	a0,s2
    800047f2:	fffff097          	auipc	ra,0xfffff
    800047f6:	8c6080e7          	jalr	-1850(ra) # 800030b8 <iunlockput>
    ilock(ip);
    800047fa:	8526                	mv	a0,s1
    800047fc:	ffffe097          	auipc	ra,0xffffe
    80004800:	65a080e7          	jalr	1626(ra) # 80002e56 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004804:	2981                	sext.w	s3,s3
    80004806:	4789                	li	a5,2
    80004808:	02f99463          	bne	s3,a5,80004830 <create+0x86>
    8000480c:	04c4d783          	lhu	a5,76(s1)
    80004810:	37f9                	addiw	a5,a5,-2
    80004812:	17c2                	slli	a5,a5,0x30
    80004814:	93c1                	srli	a5,a5,0x30
    80004816:	4705                	li	a4,1
    80004818:	00f76c63          	bltu	a4,a5,80004830 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000481c:	8526                	mv	a0,s1
    8000481e:	60a6                	ld	ra,72(sp)
    80004820:	6406                	ld	s0,64(sp)
    80004822:	74e2                	ld	s1,56(sp)
    80004824:	7942                	ld	s2,48(sp)
    80004826:	79a2                	ld	s3,40(sp)
    80004828:	7a02                	ld	s4,32(sp)
    8000482a:	6ae2                	ld	s5,24(sp)
    8000482c:	6161                	addi	sp,sp,80
    8000482e:	8082                	ret
    iunlockput(ip);
    80004830:	8526                	mv	a0,s1
    80004832:	fffff097          	auipc	ra,0xfffff
    80004836:	886080e7          	jalr	-1914(ra) # 800030b8 <iunlockput>
    return 0;
    8000483a:	4481                	li	s1,0
    8000483c:	b7c5                	j	8000481c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000483e:	85ce                	mv	a1,s3
    80004840:	00092503          	lw	a0,0(s2)
    80004844:	ffffe097          	auipc	ra,0xffffe
    80004848:	478080e7          	jalr	1144(ra) # 80002cbc <ialloc>
    8000484c:	84aa                	mv	s1,a0
    8000484e:	c521                	beqz	a0,80004896 <create+0xec>
  ilock(ip);
    80004850:	ffffe097          	auipc	ra,0xffffe
    80004854:	606080e7          	jalr	1542(ra) # 80002e56 <ilock>
  ip->major = major;
    80004858:	05549723          	sh	s5,78(s1)
  ip->minor = minor;
    8000485c:	05449823          	sh	s4,80(s1)
  ip->nlink = 1;
    80004860:	4a05                	li	s4,1
    80004862:	05449923          	sh	s4,82(s1)
  iupdate(ip);
    80004866:	8526                	mv	a0,s1
    80004868:	ffffe097          	auipc	ra,0xffffe
    8000486c:	522080e7          	jalr	1314(ra) # 80002d8a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004870:	2981                	sext.w	s3,s3
    80004872:	03498a63          	beq	s3,s4,800048a6 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004876:	40d0                	lw	a2,4(s1)
    80004878:	fb040593          	addi	a1,s0,-80
    8000487c:	854a                	mv	a0,s2
    8000487e:	fffff097          	auipc	ra,0xfffff
    80004882:	cd2080e7          	jalr	-814(ra) # 80003550 <dirlink>
    80004886:	06054b63          	bltz	a0,800048fc <create+0x152>
  iunlockput(dp);
    8000488a:	854a                	mv	a0,s2
    8000488c:	fffff097          	auipc	ra,0xfffff
    80004890:	82c080e7          	jalr	-2004(ra) # 800030b8 <iunlockput>
  return ip;
    80004894:	b761                	j	8000481c <create+0x72>
    panic("create: ialloc");
    80004896:	00004517          	auipc	a0,0x4
    8000489a:	dfa50513          	addi	a0,a0,-518 # 80008690 <syscalls+0x2c0>
    8000489e:	00002097          	auipc	ra,0x2
    800048a2:	966080e7          	jalr	-1690(ra) # 80006204 <panic>
    dp->nlink++;  // for ".."
    800048a6:	05295783          	lhu	a5,82(s2)
    800048aa:	2785                	addiw	a5,a5,1
    800048ac:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    800048b0:	854a                	mv	a0,s2
    800048b2:	ffffe097          	auipc	ra,0xffffe
    800048b6:	4d8080e7          	jalr	1240(ra) # 80002d8a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800048ba:	40d0                	lw	a2,4(s1)
    800048bc:	00004597          	auipc	a1,0x4
    800048c0:	de458593          	addi	a1,a1,-540 # 800086a0 <syscalls+0x2d0>
    800048c4:	8526                	mv	a0,s1
    800048c6:	fffff097          	auipc	ra,0xfffff
    800048ca:	c8a080e7          	jalr	-886(ra) # 80003550 <dirlink>
    800048ce:	00054f63          	bltz	a0,800048ec <create+0x142>
    800048d2:	00492603          	lw	a2,4(s2)
    800048d6:	00004597          	auipc	a1,0x4
    800048da:	dd258593          	addi	a1,a1,-558 # 800086a8 <syscalls+0x2d8>
    800048de:	8526                	mv	a0,s1
    800048e0:	fffff097          	auipc	ra,0xfffff
    800048e4:	c70080e7          	jalr	-912(ra) # 80003550 <dirlink>
    800048e8:	f80557e3          	bgez	a0,80004876 <create+0xcc>
      panic("create dots");
    800048ec:	00004517          	auipc	a0,0x4
    800048f0:	dc450513          	addi	a0,a0,-572 # 800086b0 <syscalls+0x2e0>
    800048f4:	00002097          	auipc	ra,0x2
    800048f8:	910080e7          	jalr	-1776(ra) # 80006204 <panic>
    panic("create: dirlink");
    800048fc:	00004517          	auipc	a0,0x4
    80004900:	dc450513          	addi	a0,a0,-572 # 800086c0 <syscalls+0x2f0>
    80004904:	00002097          	auipc	ra,0x2
    80004908:	900080e7          	jalr	-1792(ra) # 80006204 <panic>
    return 0;
    8000490c:	84aa                	mv	s1,a0
    8000490e:	b739                	j	8000481c <create+0x72>

0000000080004910 <sys_dup>:
{
    80004910:	7179                	addi	sp,sp,-48
    80004912:	f406                	sd	ra,40(sp)
    80004914:	f022                	sd	s0,32(sp)
    80004916:	ec26                	sd	s1,24(sp)
    80004918:	e84a                	sd	s2,16(sp)
    8000491a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000491c:	fd840613          	addi	a2,s0,-40
    80004920:	4581                	li	a1,0
    80004922:	4501                	li	a0,0
    80004924:	00000097          	auipc	ra,0x0
    80004928:	ddc080e7          	jalr	-548(ra) # 80004700 <argfd>
    return -1;
    8000492c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000492e:	02054363          	bltz	a0,80004954 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004932:	fd843903          	ld	s2,-40(s0)
    80004936:	854a                	mv	a0,s2
    80004938:	00000097          	auipc	ra,0x0
    8000493c:	e30080e7          	jalr	-464(ra) # 80004768 <fdalloc>
    80004940:	84aa                	mv	s1,a0
    return -1;
    80004942:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004944:	00054863          	bltz	a0,80004954 <sys_dup+0x44>
  filedup(f);
    80004948:	854a                	mv	a0,s2
    8000494a:	fffff097          	auipc	ra,0xfffff
    8000494e:	35e080e7          	jalr	862(ra) # 80003ca8 <filedup>
  return fd;
    80004952:	87a6                	mv	a5,s1
}
    80004954:	853e                	mv	a0,a5
    80004956:	70a2                	ld	ra,40(sp)
    80004958:	7402                	ld	s0,32(sp)
    8000495a:	64e2                	ld	s1,24(sp)
    8000495c:	6942                	ld	s2,16(sp)
    8000495e:	6145                	addi	sp,sp,48
    80004960:	8082                	ret

0000000080004962 <sys_read>:
{
    80004962:	7179                	addi	sp,sp,-48
    80004964:	f406                	sd	ra,40(sp)
    80004966:	f022                	sd	s0,32(sp)
    80004968:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000496a:	fe840613          	addi	a2,s0,-24
    8000496e:	4581                	li	a1,0
    80004970:	4501                	li	a0,0
    80004972:	00000097          	auipc	ra,0x0
    80004976:	d8e080e7          	jalr	-626(ra) # 80004700 <argfd>
    return -1;
    8000497a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000497c:	04054163          	bltz	a0,800049be <sys_read+0x5c>
    80004980:	fe440593          	addi	a1,s0,-28
    80004984:	4509                	li	a0,2
    80004986:	ffffd097          	auipc	ra,0xffffd
    8000498a:	71c080e7          	jalr	1820(ra) # 800020a2 <argint>
    return -1;
    8000498e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004990:	02054763          	bltz	a0,800049be <sys_read+0x5c>
    80004994:	fd840593          	addi	a1,s0,-40
    80004998:	4505                	li	a0,1
    8000499a:	ffffd097          	auipc	ra,0xffffd
    8000499e:	72a080e7          	jalr	1834(ra) # 800020c4 <argaddr>
    return -1;
    800049a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049a4:	00054d63          	bltz	a0,800049be <sys_read+0x5c>
  return fileread(f, p, n);
    800049a8:	fe442603          	lw	a2,-28(s0)
    800049ac:	fd843583          	ld	a1,-40(s0)
    800049b0:	fe843503          	ld	a0,-24(s0)
    800049b4:	fffff097          	auipc	ra,0xfffff
    800049b8:	480080e7          	jalr	1152(ra) # 80003e34 <fileread>
    800049bc:	87aa                	mv	a5,a0
}
    800049be:	853e                	mv	a0,a5
    800049c0:	70a2                	ld	ra,40(sp)
    800049c2:	7402                	ld	s0,32(sp)
    800049c4:	6145                	addi	sp,sp,48
    800049c6:	8082                	ret

00000000800049c8 <sys_write>:
{
    800049c8:	7179                	addi	sp,sp,-48
    800049ca:	f406                	sd	ra,40(sp)
    800049cc:	f022                	sd	s0,32(sp)
    800049ce:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049d0:	fe840613          	addi	a2,s0,-24
    800049d4:	4581                	li	a1,0
    800049d6:	4501                	li	a0,0
    800049d8:	00000097          	auipc	ra,0x0
    800049dc:	d28080e7          	jalr	-728(ra) # 80004700 <argfd>
    return -1;
    800049e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049e2:	04054163          	bltz	a0,80004a24 <sys_write+0x5c>
    800049e6:	fe440593          	addi	a1,s0,-28
    800049ea:	4509                	li	a0,2
    800049ec:	ffffd097          	auipc	ra,0xffffd
    800049f0:	6b6080e7          	jalr	1718(ra) # 800020a2 <argint>
    return -1;
    800049f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049f6:	02054763          	bltz	a0,80004a24 <sys_write+0x5c>
    800049fa:	fd840593          	addi	a1,s0,-40
    800049fe:	4505                	li	a0,1
    80004a00:	ffffd097          	auipc	ra,0xffffd
    80004a04:	6c4080e7          	jalr	1732(ra) # 800020c4 <argaddr>
    return -1;
    80004a08:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a0a:	00054d63          	bltz	a0,80004a24 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004a0e:	fe442603          	lw	a2,-28(s0)
    80004a12:	fd843583          	ld	a1,-40(s0)
    80004a16:	fe843503          	ld	a0,-24(s0)
    80004a1a:	fffff097          	auipc	ra,0xfffff
    80004a1e:	4dc080e7          	jalr	1244(ra) # 80003ef6 <filewrite>
    80004a22:	87aa                	mv	a5,a0
}
    80004a24:	853e                	mv	a0,a5
    80004a26:	70a2                	ld	ra,40(sp)
    80004a28:	7402                	ld	s0,32(sp)
    80004a2a:	6145                	addi	sp,sp,48
    80004a2c:	8082                	ret

0000000080004a2e <sys_close>:
{
    80004a2e:	1101                	addi	sp,sp,-32
    80004a30:	ec06                	sd	ra,24(sp)
    80004a32:	e822                	sd	s0,16(sp)
    80004a34:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004a36:	fe040613          	addi	a2,s0,-32
    80004a3a:	fec40593          	addi	a1,s0,-20
    80004a3e:	4501                	li	a0,0
    80004a40:	00000097          	auipc	ra,0x0
    80004a44:	cc0080e7          	jalr	-832(ra) # 80004700 <argfd>
    return -1;
    80004a48:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004a4a:	02054463          	bltz	a0,80004a72 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004a4e:	ffffc097          	auipc	ra,0xffffc
    80004a52:	59e080e7          	jalr	1438(ra) # 80000fec <myproc>
    80004a56:	fec42783          	lw	a5,-20(s0)
    80004a5a:	07e9                	addi	a5,a5,26
    80004a5c:	078e                	slli	a5,a5,0x3
    80004a5e:	953e                	add	a0,a0,a5
    80004a60:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004a64:	fe043503          	ld	a0,-32(s0)
    80004a68:	fffff097          	auipc	ra,0xfffff
    80004a6c:	292080e7          	jalr	658(ra) # 80003cfa <fileclose>
  return 0;
    80004a70:	4781                	li	a5,0
}
    80004a72:	853e                	mv	a0,a5
    80004a74:	60e2                	ld	ra,24(sp)
    80004a76:	6442                	ld	s0,16(sp)
    80004a78:	6105                	addi	sp,sp,32
    80004a7a:	8082                	ret

0000000080004a7c <sys_fstat>:
{
    80004a7c:	1101                	addi	sp,sp,-32
    80004a7e:	ec06                	sd	ra,24(sp)
    80004a80:	e822                	sd	s0,16(sp)
    80004a82:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a84:	fe840613          	addi	a2,s0,-24
    80004a88:	4581                	li	a1,0
    80004a8a:	4501                	li	a0,0
    80004a8c:	00000097          	auipc	ra,0x0
    80004a90:	c74080e7          	jalr	-908(ra) # 80004700 <argfd>
    return -1;
    80004a94:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a96:	02054563          	bltz	a0,80004ac0 <sys_fstat+0x44>
    80004a9a:	fe040593          	addi	a1,s0,-32
    80004a9e:	4505                	li	a0,1
    80004aa0:	ffffd097          	auipc	ra,0xffffd
    80004aa4:	624080e7          	jalr	1572(ra) # 800020c4 <argaddr>
    return -1;
    80004aa8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004aaa:	00054b63          	bltz	a0,80004ac0 <sys_fstat+0x44>
  return filestat(f, st);
    80004aae:	fe043583          	ld	a1,-32(s0)
    80004ab2:	fe843503          	ld	a0,-24(s0)
    80004ab6:	fffff097          	auipc	ra,0xfffff
    80004aba:	30c080e7          	jalr	780(ra) # 80003dc2 <filestat>
    80004abe:	87aa                	mv	a5,a0
}
    80004ac0:	853e                	mv	a0,a5
    80004ac2:	60e2                	ld	ra,24(sp)
    80004ac4:	6442                	ld	s0,16(sp)
    80004ac6:	6105                	addi	sp,sp,32
    80004ac8:	8082                	ret

0000000080004aca <sys_link>:
{
    80004aca:	7169                	addi	sp,sp,-304
    80004acc:	f606                	sd	ra,296(sp)
    80004ace:	f222                	sd	s0,288(sp)
    80004ad0:	ee26                	sd	s1,280(sp)
    80004ad2:	ea4a                	sd	s2,272(sp)
    80004ad4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ad6:	08000613          	li	a2,128
    80004ada:	ed040593          	addi	a1,s0,-304
    80004ade:	4501                	li	a0,0
    80004ae0:	ffffd097          	auipc	ra,0xffffd
    80004ae4:	606080e7          	jalr	1542(ra) # 800020e6 <argstr>
    return -1;
    80004ae8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004aea:	10054e63          	bltz	a0,80004c06 <sys_link+0x13c>
    80004aee:	08000613          	li	a2,128
    80004af2:	f5040593          	addi	a1,s0,-176
    80004af6:	4505                	li	a0,1
    80004af8:	ffffd097          	auipc	ra,0xffffd
    80004afc:	5ee080e7          	jalr	1518(ra) # 800020e6 <argstr>
    return -1;
    80004b00:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b02:	10054263          	bltz	a0,80004c06 <sys_link+0x13c>
  begin_op();
    80004b06:	fffff097          	auipc	ra,0xfffff
    80004b0a:	d2c080e7          	jalr	-724(ra) # 80003832 <begin_op>
  if((ip = namei(old)) == 0){
    80004b0e:	ed040513          	addi	a0,s0,-304
    80004b12:	fffff097          	auipc	ra,0xfffff
    80004b16:	b00080e7          	jalr	-1280(ra) # 80003612 <namei>
    80004b1a:	84aa                	mv	s1,a0
    80004b1c:	c551                	beqz	a0,80004ba8 <sys_link+0xde>
  ilock(ip);
    80004b1e:	ffffe097          	auipc	ra,0xffffe
    80004b22:	338080e7          	jalr	824(ra) # 80002e56 <ilock>
  if(ip->type == T_DIR){
    80004b26:	04c49703          	lh	a4,76(s1)
    80004b2a:	4785                	li	a5,1
    80004b2c:	08f70463          	beq	a4,a5,80004bb4 <sys_link+0xea>
  ip->nlink++;
    80004b30:	0524d783          	lhu	a5,82(s1)
    80004b34:	2785                	addiw	a5,a5,1
    80004b36:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004b3a:	8526                	mv	a0,s1
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	24e080e7          	jalr	590(ra) # 80002d8a <iupdate>
  iunlock(ip);
    80004b44:	8526                	mv	a0,s1
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	3d2080e7          	jalr	978(ra) # 80002f18 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004b4e:	fd040593          	addi	a1,s0,-48
    80004b52:	f5040513          	addi	a0,s0,-176
    80004b56:	fffff097          	auipc	ra,0xfffff
    80004b5a:	ada080e7          	jalr	-1318(ra) # 80003630 <nameiparent>
    80004b5e:	892a                	mv	s2,a0
    80004b60:	c935                	beqz	a0,80004bd4 <sys_link+0x10a>
  ilock(dp);
    80004b62:	ffffe097          	auipc	ra,0xffffe
    80004b66:	2f4080e7          	jalr	756(ra) # 80002e56 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b6a:	00092703          	lw	a4,0(s2)
    80004b6e:	409c                	lw	a5,0(s1)
    80004b70:	04f71d63          	bne	a4,a5,80004bca <sys_link+0x100>
    80004b74:	40d0                	lw	a2,4(s1)
    80004b76:	fd040593          	addi	a1,s0,-48
    80004b7a:	854a                	mv	a0,s2
    80004b7c:	fffff097          	auipc	ra,0xfffff
    80004b80:	9d4080e7          	jalr	-1580(ra) # 80003550 <dirlink>
    80004b84:	04054363          	bltz	a0,80004bca <sys_link+0x100>
  iunlockput(dp);
    80004b88:	854a                	mv	a0,s2
    80004b8a:	ffffe097          	auipc	ra,0xffffe
    80004b8e:	52e080e7          	jalr	1326(ra) # 800030b8 <iunlockput>
  iput(ip);
    80004b92:	8526                	mv	a0,s1
    80004b94:	ffffe097          	auipc	ra,0xffffe
    80004b98:	47c080e7          	jalr	1148(ra) # 80003010 <iput>
  end_op();
    80004b9c:	fffff097          	auipc	ra,0xfffff
    80004ba0:	d14080e7          	jalr	-748(ra) # 800038b0 <end_op>
  return 0;
    80004ba4:	4781                	li	a5,0
    80004ba6:	a085                	j	80004c06 <sys_link+0x13c>
    end_op();
    80004ba8:	fffff097          	auipc	ra,0xfffff
    80004bac:	d08080e7          	jalr	-760(ra) # 800038b0 <end_op>
    return -1;
    80004bb0:	57fd                	li	a5,-1
    80004bb2:	a891                	j	80004c06 <sys_link+0x13c>
    iunlockput(ip);
    80004bb4:	8526                	mv	a0,s1
    80004bb6:	ffffe097          	auipc	ra,0xffffe
    80004bba:	502080e7          	jalr	1282(ra) # 800030b8 <iunlockput>
    end_op();
    80004bbe:	fffff097          	auipc	ra,0xfffff
    80004bc2:	cf2080e7          	jalr	-782(ra) # 800038b0 <end_op>
    return -1;
    80004bc6:	57fd                	li	a5,-1
    80004bc8:	a83d                	j	80004c06 <sys_link+0x13c>
    iunlockput(dp);
    80004bca:	854a                	mv	a0,s2
    80004bcc:	ffffe097          	auipc	ra,0xffffe
    80004bd0:	4ec080e7          	jalr	1260(ra) # 800030b8 <iunlockput>
  ilock(ip);
    80004bd4:	8526                	mv	a0,s1
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	280080e7          	jalr	640(ra) # 80002e56 <ilock>
  ip->nlink--;
    80004bde:	0524d783          	lhu	a5,82(s1)
    80004be2:	37fd                	addiw	a5,a5,-1
    80004be4:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004be8:	8526                	mv	a0,s1
    80004bea:	ffffe097          	auipc	ra,0xffffe
    80004bee:	1a0080e7          	jalr	416(ra) # 80002d8a <iupdate>
  iunlockput(ip);
    80004bf2:	8526                	mv	a0,s1
    80004bf4:	ffffe097          	auipc	ra,0xffffe
    80004bf8:	4c4080e7          	jalr	1220(ra) # 800030b8 <iunlockput>
  end_op();
    80004bfc:	fffff097          	auipc	ra,0xfffff
    80004c00:	cb4080e7          	jalr	-844(ra) # 800038b0 <end_op>
  return -1;
    80004c04:	57fd                	li	a5,-1
}
    80004c06:	853e                	mv	a0,a5
    80004c08:	70b2                	ld	ra,296(sp)
    80004c0a:	7412                	ld	s0,288(sp)
    80004c0c:	64f2                	ld	s1,280(sp)
    80004c0e:	6952                	ld	s2,272(sp)
    80004c10:	6155                	addi	sp,sp,304
    80004c12:	8082                	ret

0000000080004c14 <sys_unlink>:
{
    80004c14:	7151                	addi	sp,sp,-240
    80004c16:	f586                	sd	ra,232(sp)
    80004c18:	f1a2                	sd	s0,224(sp)
    80004c1a:	eda6                	sd	s1,216(sp)
    80004c1c:	e9ca                	sd	s2,208(sp)
    80004c1e:	e5ce                	sd	s3,200(sp)
    80004c20:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c22:	08000613          	li	a2,128
    80004c26:	f3040593          	addi	a1,s0,-208
    80004c2a:	4501                	li	a0,0
    80004c2c:	ffffd097          	auipc	ra,0xffffd
    80004c30:	4ba080e7          	jalr	1210(ra) # 800020e6 <argstr>
    80004c34:	18054163          	bltz	a0,80004db6 <sys_unlink+0x1a2>
  begin_op();
    80004c38:	fffff097          	auipc	ra,0xfffff
    80004c3c:	bfa080e7          	jalr	-1030(ra) # 80003832 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c40:	fb040593          	addi	a1,s0,-80
    80004c44:	f3040513          	addi	a0,s0,-208
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	9e8080e7          	jalr	-1560(ra) # 80003630 <nameiparent>
    80004c50:	84aa                	mv	s1,a0
    80004c52:	c979                	beqz	a0,80004d28 <sys_unlink+0x114>
  ilock(dp);
    80004c54:	ffffe097          	auipc	ra,0xffffe
    80004c58:	202080e7          	jalr	514(ra) # 80002e56 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c5c:	00004597          	auipc	a1,0x4
    80004c60:	a4458593          	addi	a1,a1,-1468 # 800086a0 <syscalls+0x2d0>
    80004c64:	fb040513          	addi	a0,s0,-80
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	6b8080e7          	jalr	1720(ra) # 80003320 <namecmp>
    80004c70:	14050a63          	beqz	a0,80004dc4 <sys_unlink+0x1b0>
    80004c74:	00004597          	auipc	a1,0x4
    80004c78:	a3458593          	addi	a1,a1,-1484 # 800086a8 <syscalls+0x2d8>
    80004c7c:	fb040513          	addi	a0,s0,-80
    80004c80:	ffffe097          	auipc	ra,0xffffe
    80004c84:	6a0080e7          	jalr	1696(ra) # 80003320 <namecmp>
    80004c88:	12050e63          	beqz	a0,80004dc4 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c8c:	f2c40613          	addi	a2,s0,-212
    80004c90:	fb040593          	addi	a1,s0,-80
    80004c94:	8526                	mv	a0,s1
    80004c96:	ffffe097          	auipc	ra,0xffffe
    80004c9a:	6a4080e7          	jalr	1700(ra) # 8000333a <dirlookup>
    80004c9e:	892a                	mv	s2,a0
    80004ca0:	12050263          	beqz	a0,80004dc4 <sys_unlink+0x1b0>
  ilock(ip);
    80004ca4:	ffffe097          	auipc	ra,0xffffe
    80004ca8:	1b2080e7          	jalr	434(ra) # 80002e56 <ilock>
  if(ip->nlink < 1)
    80004cac:	05291783          	lh	a5,82(s2)
    80004cb0:	08f05263          	blez	a5,80004d34 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004cb4:	04c91703          	lh	a4,76(s2)
    80004cb8:	4785                	li	a5,1
    80004cba:	08f70563          	beq	a4,a5,80004d44 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004cbe:	4641                	li	a2,16
    80004cc0:	4581                	li	a1,0
    80004cc2:	fc040513          	addi	a0,s0,-64
    80004cc6:	ffffb097          	auipc	ra,0xffffb
    80004cca:	64c080e7          	jalr	1612(ra) # 80000312 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cce:	4741                	li	a4,16
    80004cd0:	f2c42683          	lw	a3,-212(s0)
    80004cd4:	fc040613          	addi	a2,s0,-64
    80004cd8:	4581                	li	a1,0
    80004cda:	8526                	mv	a0,s1
    80004cdc:	ffffe097          	auipc	ra,0xffffe
    80004ce0:	526080e7          	jalr	1318(ra) # 80003202 <writei>
    80004ce4:	47c1                	li	a5,16
    80004ce6:	0af51563          	bne	a0,a5,80004d90 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004cea:	04c91703          	lh	a4,76(s2)
    80004cee:	4785                	li	a5,1
    80004cf0:	0af70863          	beq	a4,a5,80004da0 <sys_unlink+0x18c>
  iunlockput(dp);
    80004cf4:	8526                	mv	a0,s1
    80004cf6:	ffffe097          	auipc	ra,0xffffe
    80004cfa:	3c2080e7          	jalr	962(ra) # 800030b8 <iunlockput>
  ip->nlink--;
    80004cfe:	05295783          	lhu	a5,82(s2)
    80004d02:	37fd                	addiw	a5,a5,-1
    80004d04:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004d08:	854a                	mv	a0,s2
    80004d0a:	ffffe097          	auipc	ra,0xffffe
    80004d0e:	080080e7          	jalr	128(ra) # 80002d8a <iupdate>
  iunlockput(ip);
    80004d12:	854a                	mv	a0,s2
    80004d14:	ffffe097          	auipc	ra,0xffffe
    80004d18:	3a4080e7          	jalr	932(ra) # 800030b8 <iunlockput>
  end_op();
    80004d1c:	fffff097          	auipc	ra,0xfffff
    80004d20:	b94080e7          	jalr	-1132(ra) # 800038b0 <end_op>
  return 0;
    80004d24:	4501                	li	a0,0
    80004d26:	a84d                	j	80004dd8 <sys_unlink+0x1c4>
    end_op();
    80004d28:	fffff097          	auipc	ra,0xfffff
    80004d2c:	b88080e7          	jalr	-1144(ra) # 800038b0 <end_op>
    return -1;
    80004d30:	557d                	li	a0,-1
    80004d32:	a05d                	j	80004dd8 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004d34:	00004517          	auipc	a0,0x4
    80004d38:	99c50513          	addi	a0,a0,-1636 # 800086d0 <syscalls+0x300>
    80004d3c:	00001097          	auipc	ra,0x1
    80004d40:	4c8080e7          	jalr	1224(ra) # 80006204 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d44:	05492703          	lw	a4,84(s2)
    80004d48:	02000793          	li	a5,32
    80004d4c:	f6e7f9e3          	bgeu	a5,a4,80004cbe <sys_unlink+0xaa>
    80004d50:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d54:	4741                	li	a4,16
    80004d56:	86ce                	mv	a3,s3
    80004d58:	f1840613          	addi	a2,s0,-232
    80004d5c:	4581                	li	a1,0
    80004d5e:	854a                	mv	a0,s2
    80004d60:	ffffe097          	auipc	ra,0xffffe
    80004d64:	3aa080e7          	jalr	938(ra) # 8000310a <readi>
    80004d68:	47c1                	li	a5,16
    80004d6a:	00f51b63          	bne	a0,a5,80004d80 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004d6e:	f1845783          	lhu	a5,-232(s0)
    80004d72:	e7a1                	bnez	a5,80004dba <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d74:	29c1                	addiw	s3,s3,16
    80004d76:	05492783          	lw	a5,84(s2)
    80004d7a:	fcf9ede3          	bltu	s3,a5,80004d54 <sys_unlink+0x140>
    80004d7e:	b781                	j	80004cbe <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004d80:	00004517          	auipc	a0,0x4
    80004d84:	96850513          	addi	a0,a0,-1688 # 800086e8 <syscalls+0x318>
    80004d88:	00001097          	auipc	ra,0x1
    80004d8c:	47c080e7          	jalr	1148(ra) # 80006204 <panic>
    panic("unlink: writei");
    80004d90:	00004517          	auipc	a0,0x4
    80004d94:	97050513          	addi	a0,a0,-1680 # 80008700 <syscalls+0x330>
    80004d98:	00001097          	auipc	ra,0x1
    80004d9c:	46c080e7          	jalr	1132(ra) # 80006204 <panic>
    dp->nlink--;
    80004da0:	0524d783          	lhu	a5,82(s1)
    80004da4:	37fd                	addiw	a5,a5,-1
    80004da6:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004daa:	8526                	mv	a0,s1
    80004dac:	ffffe097          	auipc	ra,0xffffe
    80004db0:	fde080e7          	jalr	-34(ra) # 80002d8a <iupdate>
    80004db4:	b781                	j	80004cf4 <sys_unlink+0xe0>
    return -1;
    80004db6:	557d                	li	a0,-1
    80004db8:	a005                	j	80004dd8 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004dba:	854a                	mv	a0,s2
    80004dbc:	ffffe097          	auipc	ra,0xffffe
    80004dc0:	2fc080e7          	jalr	764(ra) # 800030b8 <iunlockput>
  iunlockput(dp);
    80004dc4:	8526                	mv	a0,s1
    80004dc6:	ffffe097          	auipc	ra,0xffffe
    80004dca:	2f2080e7          	jalr	754(ra) # 800030b8 <iunlockput>
  end_op();
    80004dce:	fffff097          	auipc	ra,0xfffff
    80004dd2:	ae2080e7          	jalr	-1310(ra) # 800038b0 <end_op>
  return -1;
    80004dd6:	557d                	li	a0,-1
}
    80004dd8:	70ae                	ld	ra,232(sp)
    80004dda:	740e                	ld	s0,224(sp)
    80004ddc:	64ee                	ld	s1,216(sp)
    80004dde:	694e                	ld	s2,208(sp)
    80004de0:	69ae                	ld	s3,200(sp)
    80004de2:	616d                	addi	sp,sp,240
    80004de4:	8082                	ret

0000000080004de6 <sys_open>:

uint64
sys_open(void)
{
    80004de6:	7131                	addi	sp,sp,-192
    80004de8:	fd06                	sd	ra,184(sp)
    80004dea:	f922                	sd	s0,176(sp)
    80004dec:	f526                	sd	s1,168(sp)
    80004dee:	f14a                	sd	s2,160(sp)
    80004df0:	ed4e                	sd	s3,152(sp)
    80004df2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004df4:	08000613          	li	a2,128
    80004df8:	f5040593          	addi	a1,s0,-176
    80004dfc:	4501                	li	a0,0
    80004dfe:	ffffd097          	auipc	ra,0xffffd
    80004e02:	2e8080e7          	jalr	744(ra) # 800020e6 <argstr>
    return -1;
    80004e06:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004e08:	0c054163          	bltz	a0,80004eca <sys_open+0xe4>
    80004e0c:	f4c40593          	addi	a1,s0,-180
    80004e10:	4505                	li	a0,1
    80004e12:	ffffd097          	auipc	ra,0xffffd
    80004e16:	290080e7          	jalr	656(ra) # 800020a2 <argint>
    80004e1a:	0a054863          	bltz	a0,80004eca <sys_open+0xe4>

  begin_op();
    80004e1e:	fffff097          	auipc	ra,0xfffff
    80004e22:	a14080e7          	jalr	-1516(ra) # 80003832 <begin_op>

  if(omode & O_CREATE){
    80004e26:	f4c42783          	lw	a5,-180(s0)
    80004e2a:	2007f793          	andi	a5,a5,512
    80004e2e:	cbdd                	beqz	a5,80004ee4 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004e30:	4681                	li	a3,0
    80004e32:	4601                	li	a2,0
    80004e34:	4589                	li	a1,2
    80004e36:	f5040513          	addi	a0,s0,-176
    80004e3a:	00000097          	auipc	ra,0x0
    80004e3e:	970080e7          	jalr	-1680(ra) # 800047aa <create>
    80004e42:	892a                	mv	s2,a0
    if(ip == 0){
    80004e44:	c959                	beqz	a0,80004eda <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004e46:	04c91703          	lh	a4,76(s2)
    80004e4a:	478d                	li	a5,3
    80004e4c:	00f71763          	bne	a4,a5,80004e5a <sys_open+0x74>
    80004e50:	04e95703          	lhu	a4,78(s2)
    80004e54:	47a5                	li	a5,9
    80004e56:	0ce7ec63          	bltu	a5,a4,80004f2e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	de4080e7          	jalr	-540(ra) # 80003c3e <filealloc>
    80004e62:	89aa                	mv	s3,a0
    80004e64:	10050263          	beqz	a0,80004f68 <sys_open+0x182>
    80004e68:	00000097          	auipc	ra,0x0
    80004e6c:	900080e7          	jalr	-1792(ra) # 80004768 <fdalloc>
    80004e70:	84aa                	mv	s1,a0
    80004e72:	0e054663          	bltz	a0,80004f5e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e76:	04c91703          	lh	a4,76(s2)
    80004e7a:	478d                	li	a5,3
    80004e7c:	0cf70463          	beq	a4,a5,80004f44 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e80:	4789                	li	a5,2
    80004e82:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e86:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e8a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e8e:	f4c42783          	lw	a5,-180(s0)
    80004e92:	0017c713          	xori	a4,a5,1
    80004e96:	8b05                	andi	a4,a4,1
    80004e98:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e9c:	0037f713          	andi	a4,a5,3
    80004ea0:	00e03733          	snez	a4,a4
    80004ea4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004ea8:	4007f793          	andi	a5,a5,1024
    80004eac:	c791                	beqz	a5,80004eb8 <sys_open+0xd2>
    80004eae:	04c91703          	lh	a4,76(s2)
    80004eb2:	4789                	li	a5,2
    80004eb4:	08f70f63          	beq	a4,a5,80004f52 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004eb8:	854a                	mv	a0,s2
    80004eba:	ffffe097          	auipc	ra,0xffffe
    80004ebe:	05e080e7          	jalr	94(ra) # 80002f18 <iunlock>
  end_op();
    80004ec2:	fffff097          	auipc	ra,0xfffff
    80004ec6:	9ee080e7          	jalr	-1554(ra) # 800038b0 <end_op>

  return fd;
}
    80004eca:	8526                	mv	a0,s1
    80004ecc:	70ea                	ld	ra,184(sp)
    80004ece:	744a                	ld	s0,176(sp)
    80004ed0:	74aa                	ld	s1,168(sp)
    80004ed2:	790a                	ld	s2,160(sp)
    80004ed4:	69ea                	ld	s3,152(sp)
    80004ed6:	6129                	addi	sp,sp,192
    80004ed8:	8082                	ret
      end_op();
    80004eda:	fffff097          	auipc	ra,0xfffff
    80004ede:	9d6080e7          	jalr	-1578(ra) # 800038b0 <end_op>
      return -1;
    80004ee2:	b7e5                	j	80004eca <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004ee4:	f5040513          	addi	a0,s0,-176
    80004ee8:	ffffe097          	auipc	ra,0xffffe
    80004eec:	72a080e7          	jalr	1834(ra) # 80003612 <namei>
    80004ef0:	892a                	mv	s2,a0
    80004ef2:	c905                	beqz	a0,80004f22 <sys_open+0x13c>
    ilock(ip);
    80004ef4:	ffffe097          	auipc	ra,0xffffe
    80004ef8:	f62080e7          	jalr	-158(ra) # 80002e56 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004efc:	04c91703          	lh	a4,76(s2)
    80004f00:	4785                	li	a5,1
    80004f02:	f4f712e3          	bne	a4,a5,80004e46 <sys_open+0x60>
    80004f06:	f4c42783          	lw	a5,-180(s0)
    80004f0a:	dba1                	beqz	a5,80004e5a <sys_open+0x74>
      iunlockput(ip);
    80004f0c:	854a                	mv	a0,s2
    80004f0e:	ffffe097          	auipc	ra,0xffffe
    80004f12:	1aa080e7          	jalr	426(ra) # 800030b8 <iunlockput>
      end_op();
    80004f16:	fffff097          	auipc	ra,0xfffff
    80004f1a:	99a080e7          	jalr	-1638(ra) # 800038b0 <end_op>
      return -1;
    80004f1e:	54fd                	li	s1,-1
    80004f20:	b76d                	j	80004eca <sys_open+0xe4>
      end_op();
    80004f22:	fffff097          	auipc	ra,0xfffff
    80004f26:	98e080e7          	jalr	-1650(ra) # 800038b0 <end_op>
      return -1;
    80004f2a:	54fd                	li	s1,-1
    80004f2c:	bf79                	j	80004eca <sys_open+0xe4>
    iunlockput(ip);
    80004f2e:	854a                	mv	a0,s2
    80004f30:	ffffe097          	auipc	ra,0xffffe
    80004f34:	188080e7          	jalr	392(ra) # 800030b8 <iunlockput>
    end_op();
    80004f38:	fffff097          	auipc	ra,0xfffff
    80004f3c:	978080e7          	jalr	-1672(ra) # 800038b0 <end_op>
    return -1;
    80004f40:	54fd                	li	s1,-1
    80004f42:	b761                	j	80004eca <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004f44:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004f48:	04e91783          	lh	a5,78(s2)
    80004f4c:	02f99223          	sh	a5,36(s3)
    80004f50:	bf2d                	j	80004e8a <sys_open+0xa4>
    itrunc(ip);
    80004f52:	854a                	mv	a0,s2
    80004f54:	ffffe097          	auipc	ra,0xffffe
    80004f58:	010080e7          	jalr	16(ra) # 80002f64 <itrunc>
    80004f5c:	bfb1                	j	80004eb8 <sys_open+0xd2>
      fileclose(f);
    80004f5e:	854e                	mv	a0,s3
    80004f60:	fffff097          	auipc	ra,0xfffff
    80004f64:	d9a080e7          	jalr	-614(ra) # 80003cfa <fileclose>
    iunlockput(ip);
    80004f68:	854a                	mv	a0,s2
    80004f6a:	ffffe097          	auipc	ra,0xffffe
    80004f6e:	14e080e7          	jalr	334(ra) # 800030b8 <iunlockput>
    end_op();
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	93e080e7          	jalr	-1730(ra) # 800038b0 <end_op>
    return -1;
    80004f7a:	54fd                	li	s1,-1
    80004f7c:	b7b9                	j	80004eca <sys_open+0xe4>

0000000080004f7e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f7e:	7175                	addi	sp,sp,-144
    80004f80:	e506                	sd	ra,136(sp)
    80004f82:	e122                	sd	s0,128(sp)
    80004f84:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f86:	fffff097          	auipc	ra,0xfffff
    80004f8a:	8ac080e7          	jalr	-1876(ra) # 80003832 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f8e:	08000613          	li	a2,128
    80004f92:	f7040593          	addi	a1,s0,-144
    80004f96:	4501                	li	a0,0
    80004f98:	ffffd097          	auipc	ra,0xffffd
    80004f9c:	14e080e7          	jalr	334(ra) # 800020e6 <argstr>
    80004fa0:	02054963          	bltz	a0,80004fd2 <sys_mkdir+0x54>
    80004fa4:	4681                	li	a3,0
    80004fa6:	4601                	li	a2,0
    80004fa8:	4585                	li	a1,1
    80004faa:	f7040513          	addi	a0,s0,-144
    80004fae:	fffff097          	auipc	ra,0xfffff
    80004fb2:	7fc080e7          	jalr	2044(ra) # 800047aa <create>
    80004fb6:	cd11                	beqz	a0,80004fd2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fb8:	ffffe097          	auipc	ra,0xffffe
    80004fbc:	100080e7          	jalr	256(ra) # 800030b8 <iunlockput>
  end_op();
    80004fc0:	fffff097          	auipc	ra,0xfffff
    80004fc4:	8f0080e7          	jalr	-1808(ra) # 800038b0 <end_op>
  return 0;
    80004fc8:	4501                	li	a0,0
}
    80004fca:	60aa                	ld	ra,136(sp)
    80004fcc:	640a                	ld	s0,128(sp)
    80004fce:	6149                	addi	sp,sp,144
    80004fd0:	8082                	ret
    end_op();
    80004fd2:	fffff097          	auipc	ra,0xfffff
    80004fd6:	8de080e7          	jalr	-1826(ra) # 800038b0 <end_op>
    return -1;
    80004fda:	557d                	li	a0,-1
    80004fdc:	b7fd                	j	80004fca <sys_mkdir+0x4c>

0000000080004fde <sys_mknod>:

uint64
sys_mknod(void)
{
    80004fde:	7135                	addi	sp,sp,-160
    80004fe0:	ed06                	sd	ra,152(sp)
    80004fe2:	e922                	sd	s0,144(sp)
    80004fe4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004fe6:	fffff097          	auipc	ra,0xfffff
    80004fea:	84c080e7          	jalr	-1972(ra) # 80003832 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fee:	08000613          	li	a2,128
    80004ff2:	f7040593          	addi	a1,s0,-144
    80004ff6:	4501                	li	a0,0
    80004ff8:	ffffd097          	auipc	ra,0xffffd
    80004ffc:	0ee080e7          	jalr	238(ra) # 800020e6 <argstr>
    80005000:	04054a63          	bltz	a0,80005054 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005004:	f6c40593          	addi	a1,s0,-148
    80005008:	4505                	li	a0,1
    8000500a:	ffffd097          	auipc	ra,0xffffd
    8000500e:	098080e7          	jalr	152(ra) # 800020a2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005012:	04054163          	bltz	a0,80005054 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005016:	f6840593          	addi	a1,s0,-152
    8000501a:	4509                	li	a0,2
    8000501c:	ffffd097          	auipc	ra,0xffffd
    80005020:	086080e7          	jalr	134(ra) # 800020a2 <argint>
     argint(1, &major) < 0 ||
    80005024:	02054863          	bltz	a0,80005054 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005028:	f6841683          	lh	a3,-152(s0)
    8000502c:	f6c41603          	lh	a2,-148(s0)
    80005030:	458d                	li	a1,3
    80005032:	f7040513          	addi	a0,s0,-144
    80005036:	fffff097          	auipc	ra,0xfffff
    8000503a:	774080e7          	jalr	1908(ra) # 800047aa <create>
     argint(2, &minor) < 0 ||
    8000503e:	c919                	beqz	a0,80005054 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005040:	ffffe097          	auipc	ra,0xffffe
    80005044:	078080e7          	jalr	120(ra) # 800030b8 <iunlockput>
  end_op();
    80005048:	fffff097          	auipc	ra,0xfffff
    8000504c:	868080e7          	jalr	-1944(ra) # 800038b0 <end_op>
  return 0;
    80005050:	4501                	li	a0,0
    80005052:	a031                	j	8000505e <sys_mknod+0x80>
    end_op();
    80005054:	fffff097          	auipc	ra,0xfffff
    80005058:	85c080e7          	jalr	-1956(ra) # 800038b0 <end_op>
    return -1;
    8000505c:	557d                	li	a0,-1
}
    8000505e:	60ea                	ld	ra,152(sp)
    80005060:	644a                	ld	s0,144(sp)
    80005062:	610d                	addi	sp,sp,160
    80005064:	8082                	ret

0000000080005066 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005066:	7135                	addi	sp,sp,-160
    80005068:	ed06                	sd	ra,152(sp)
    8000506a:	e922                	sd	s0,144(sp)
    8000506c:	e526                	sd	s1,136(sp)
    8000506e:	e14a                	sd	s2,128(sp)
    80005070:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005072:	ffffc097          	auipc	ra,0xffffc
    80005076:	f7a080e7          	jalr	-134(ra) # 80000fec <myproc>
    8000507a:	892a                	mv	s2,a0
  
  begin_op();
    8000507c:	ffffe097          	auipc	ra,0xffffe
    80005080:	7b6080e7          	jalr	1974(ra) # 80003832 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005084:	08000613          	li	a2,128
    80005088:	f6040593          	addi	a1,s0,-160
    8000508c:	4501                	li	a0,0
    8000508e:	ffffd097          	auipc	ra,0xffffd
    80005092:	058080e7          	jalr	88(ra) # 800020e6 <argstr>
    80005096:	04054b63          	bltz	a0,800050ec <sys_chdir+0x86>
    8000509a:	f6040513          	addi	a0,s0,-160
    8000509e:	ffffe097          	auipc	ra,0xffffe
    800050a2:	574080e7          	jalr	1396(ra) # 80003612 <namei>
    800050a6:	84aa                	mv	s1,a0
    800050a8:	c131                	beqz	a0,800050ec <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800050aa:	ffffe097          	auipc	ra,0xffffe
    800050ae:	dac080e7          	jalr	-596(ra) # 80002e56 <ilock>
  if(ip->type != T_DIR){
    800050b2:	04c49703          	lh	a4,76(s1)
    800050b6:	4785                	li	a5,1
    800050b8:	04f71063          	bne	a4,a5,800050f8 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800050bc:	8526                	mv	a0,s1
    800050be:	ffffe097          	auipc	ra,0xffffe
    800050c2:	e5a080e7          	jalr	-422(ra) # 80002f18 <iunlock>
  iput(p->cwd);
    800050c6:	15893503          	ld	a0,344(s2)
    800050ca:	ffffe097          	auipc	ra,0xffffe
    800050ce:	f46080e7          	jalr	-186(ra) # 80003010 <iput>
  end_op();
    800050d2:	ffffe097          	auipc	ra,0xffffe
    800050d6:	7de080e7          	jalr	2014(ra) # 800038b0 <end_op>
  p->cwd = ip;
    800050da:	14993c23          	sd	s1,344(s2)
  return 0;
    800050de:	4501                	li	a0,0
}
    800050e0:	60ea                	ld	ra,152(sp)
    800050e2:	644a                	ld	s0,144(sp)
    800050e4:	64aa                	ld	s1,136(sp)
    800050e6:	690a                	ld	s2,128(sp)
    800050e8:	610d                	addi	sp,sp,160
    800050ea:	8082                	ret
    end_op();
    800050ec:	ffffe097          	auipc	ra,0xffffe
    800050f0:	7c4080e7          	jalr	1988(ra) # 800038b0 <end_op>
    return -1;
    800050f4:	557d                	li	a0,-1
    800050f6:	b7ed                	j	800050e0 <sys_chdir+0x7a>
    iunlockput(ip);
    800050f8:	8526                	mv	a0,s1
    800050fa:	ffffe097          	auipc	ra,0xffffe
    800050fe:	fbe080e7          	jalr	-66(ra) # 800030b8 <iunlockput>
    end_op();
    80005102:	ffffe097          	auipc	ra,0xffffe
    80005106:	7ae080e7          	jalr	1966(ra) # 800038b0 <end_op>
    return -1;
    8000510a:	557d                	li	a0,-1
    8000510c:	bfd1                	j	800050e0 <sys_chdir+0x7a>

000000008000510e <sys_exec>:

uint64
sys_exec(void)
{
    8000510e:	7145                	addi	sp,sp,-464
    80005110:	e786                	sd	ra,456(sp)
    80005112:	e3a2                	sd	s0,448(sp)
    80005114:	ff26                	sd	s1,440(sp)
    80005116:	fb4a                	sd	s2,432(sp)
    80005118:	f74e                	sd	s3,424(sp)
    8000511a:	f352                	sd	s4,416(sp)
    8000511c:	ef56                	sd	s5,408(sp)
    8000511e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005120:	08000613          	li	a2,128
    80005124:	f4040593          	addi	a1,s0,-192
    80005128:	4501                	li	a0,0
    8000512a:	ffffd097          	auipc	ra,0xffffd
    8000512e:	fbc080e7          	jalr	-68(ra) # 800020e6 <argstr>
    return -1;
    80005132:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005134:	0c054b63          	bltz	a0,8000520a <sys_exec+0xfc>
    80005138:	e3840593          	addi	a1,s0,-456
    8000513c:	4505                	li	a0,1
    8000513e:	ffffd097          	auipc	ra,0xffffd
    80005142:	f86080e7          	jalr	-122(ra) # 800020c4 <argaddr>
    80005146:	0c054263          	bltz	a0,8000520a <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    8000514a:	10000613          	li	a2,256
    8000514e:	4581                	li	a1,0
    80005150:	e4040513          	addi	a0,s0,-448
    80005154:	ffffb097          	auipc	ra,0xffffb
    80005158:	1be080e7          	jalr	446(ra) # 80000312 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000515c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005160:	89a6                	mv	s3,s1
    80005162:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005164:	02000a13          	li	s4,32
    80005168:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000516c:	00391513          	slli	a0,s2,0x3
    80005170:	e3040593          	addi	a1,s0,-464
    80005174:	e3843783          	ld	a5,-456(s0)
    80005178:	953e                	add	a0,a0,a5
    8000517a:	ffffd097          	auipc	ra,0xffffd
    8000517e:	e8e080e7          	jalr	-370(ra) # 80002008 <fetchaddr>
    80005182:	02054a63          	bltz	a0,800051b6 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005186:	e3043783          	ld	a5,-464(s0)
    8000518a:	c3b9                	beqz	a5,800051d0 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000518c:	ffffb097          	auipc	ra,0xffffb
    80005190:	0c2080e7          	jalr	194(ra) # 8000024e <kalloc>
    80005194:	85aa                	mv	a1,a0
    80005196:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000519a:	cd11                	beqz	a0,800051b6 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000519c:	6605                	lui	a2,0x1
    8000519e:	e3043503          	ld	a0,-464(s0)
    800051a2:	ffffd097          	auipc	ra,0xffffd
    800051a6:	eb8080e7          	jalr	-328(ra) # 8000205a <fetchstr>
    800051aa:	00054663          	bltz	a0,800051b6 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    800051ae:	0905                	addi	s2,s2,1
    800051b0:	09a1                	addi	s3,s3,8
    800051b2:	fb491be3          	bne	s2,s4,80005168 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051b6:	f4040913          	addi	s2,s0,-192
    800051ba:	6088                	ld	a0,0(s1)
    800051bc:	c531                	beqz	a0,80005208 <sys_exec+0xfa>
    kfree(argv[i]);
    800051be:	ffffb097          	auipc	ra,0xffffb
    800051c2:	e5e080e7          	jalr	-418(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051c6:	04a1                	addi	s1,s1,8
    800051c8:	ff2499e3          	bne	s1,s2,800051ba <sys_exec+0xac>
  return -1;
    800051cc:	597d                	li	s2,-1
    800051ce:	a835                	j	8000520a <sys_exec+0xfc>
      argv[i] = 0;
    800051d0:	0a8e                	slli	s5,s5,0x3
    800051d2:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd3d78>
    800051d6:	00878ab3          	add	s5,a5,s0
    800051da:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800051de:	e4040593          	addi	a1,s0,-448
    800051e2:	f4040513          	addi	a0,s0,-192
    800051e6:	fffff097          	auipc	ra,0xfffff
    800051ea:	172080e7          	jalr	370(ra) # 80004358 <exec>
    800051ee:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051f0:	f4040993          	addi	s3,s0,-192
    800051f4:	6088                	ld	a0,0(s1)
    800051f6:	c911                	beqz	a0,8000520a <sys_exec+0xfc>
    kfree(argv[i]);
    800051f8:	ffffb097          	auipc	ra,0xffffb
    800051fc:	e24080e7          	jalr	-476(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005200:	04a1                	addi	s1,s1,8
    80005202:	ff3499e3          	bne	s1,s3,800051f4 <sys_exec+0xe6>
    80005206:	a011                	j	8000520a <sys_exec+0xfc>
  return -1;
    80005208:	597d                	li	s2,-1
}
    8000520a:	854a                	mv	a0,s2
    8000520c:	60be                	ld	ra,456(sp)
    8000520e:	641e                	ld	s0,448(sp)
    80005210:	74fa                	ld	s1,440(sp)
    80005212:	795a                	ld	s2,432(sp)
    80005214:	79ba                	ld	s3,424(sp)
    80005216:	7a1a                	ld	s4,416(sp)
    80005218:	6afa                	ld	s5,408(sp)
    8000521a:	6179                	addi	sp,sp,464
    8000521c:	8082                	ret

000000008000521e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000521e:	7139                	addi	sp,sp,-64
    80005220:	fc06                	sd	ra,56(sp)
    80005222:	f822                	sd	s0,48(sp)
    80005224:	f426                	sd	s1,40(sp)
    80005226:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005228:	ffffc097          	auipc	ra,0xffffc
    8000522c:	dc4080e7          	jalr	-572(ra) # 80000fec <myproc>
    80005230:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005232:	fd840593          	addi	a1,s0,-40
    80005236:	4501                	li	a0,0
    80005238:	ffffd097          	auipc	ra,0xffffd
    8000523c:	e8c080e7          	jalr	-372(ra) # 800020c4 <argaddr>
    return -1;
    80005240:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005242:	0e054063          	bltz	a0,80005322 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005246:	fc840593          	addi	a1,s0,-56
    8000524a:	fd040513          	addi	a0,s0,-48
    8000524e:	fffff097          	auipc	ra,0xfffff
    80005252:	ddc080e7          	jalr	-548(ra) # 8000402a <pipealloc>
    return -1;
    80005256:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005258:	0c054563          	bltz	a0,80005322 <sys_pipe+0x104>
  fd0 = -1;
    8000525c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005260:	fd043503          	ld	a0,-48(s0)
    80005264:	fffff097          	auipc	ra,0xfffff
    80005268:	504080e7          	jalr	1284(ra) # 80004768 <fdalloc>
    8000526c:	fca42223          	sw	a0,-60(s0)
    80005270:	08054c63          	bltz	a0,80005308 <sys_pipe+0xea>
    80005274:	fc843503          	ld	a0,-56(s0)
    80005278:	fffff097          	auipc	ra,0xfffff
    8000527c:	4f0080e7          	jalr	1264(ra) # 80004768 <fdalloc>
    80005280:	fca42023          	sw	a0,-64(s0)
    80005284:	06054963          	bltz	a0,800052f6 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005288:	4691                	li	a3,4
    8000528a:	fc440613          	addi	a2,s0,-60
    8000528e:	fd843583          	ld	a1,-40(s0)
    80005292:	6ca8                	ld	a0,88(s1)
    80005294:	ffffc097          	auipc	ra,0xffffc
    80005298:	a1c080e7          	jalr	-1508(ra) # 80000cb0 <copyout>
    8000529c:	02054063          	bltz	a0,800052bc <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800052a0:	4691                	li	a3,4
    800052a2:	fc040613          	addi	a2,s0,-64
    800052a6:	fd843583          	ld	a1,-40(s0)
    800052aa:	0591                	addi	a1,a1,4
    800052ac:	6ca8                	ld	a0,88(s1)
    800052ae:	ffffc097          	auipc	ra,0xffffc
    800052b2:	a02080e7          	jalr	-1534(ra) # 80000cb0 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800052b6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052b8:	06055563          	bgez	a0,80005322 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800052bc:	fc442783          	lw	a5,-60(s0)
    800052c0:	07e9                	addi	a5,a5,26
    800052c2:	078e                	slli	a5,a5,0x3
    800052c4:	97a6                	add	a5,a5,s1
    800052c6:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800052ca:	fc042783          	lw	a5,-64(s0)
    800052ce:	07e9                	addi	a5,a5,26
    800052d0:	078e                	slli	a5,a5,0x3
    800052d2:	00f48533          	add	a0,s1,a5
    800052d6:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800052da:	fd043503          	ld	a0,-48(s0)
    800052de:	fffff097          	auipc	ra,0xfffff
    800052e2:	a1c080e7          	jalr	-1508(ra) # 80003cfa <fileclose>
    fileclose(wf);
    800052e6:	fc843503          	ld	a0,-56(s0)
    800052ea:	fffff097          	auipc	ra,0xfffff
    800052ee:	a10080e7          	jalr	-1520(ra) # 80003cfa <fileclose>
    return -1;
    800052f2:	57fd                	li	a5,-1
    800052f4:	a03d                	j	80005322 <sys_pipe+0x104>
    if(fd0 >= 0)
    800052f6:	fc442783          	lw	a5,-60(s0)
    800052fa:	0007c763          	bltz	a5,80005308 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800052fe:	07e9                	addi	a5,a5,26
    80005300:	078e                	slli	a5,a5,0x3
    80005302:	97a6                	add	a5,a5,s1
    80005304:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005308:	fd043503          	ld	a0,-48(s0)
    8000530c:	fffff097          	auipc	ra,0xfffff
    80005310:	9ee080e7          	jalr	-1554(ra) # 80003cfa <fileclose>
    fileclose(wf);
    80005314:	fc843503          	ld	a0,-56(s0)
    80005318:	fffff097          	auipc	ra,0xfffff
    8000531c:	9e2080e7          	jalr	-1566(ra) # 80003cfa <fileclose>
    return -1;
    80005320:	57fd                	li	a5,-1
}
    80005322:	853e                	mv	a0,a5
    80005324:	70e2                	ld	ra,56(sp)
    80005326:	7442                	ld	s0,48(sp)
    80005328:	74a2                	ld	s1,40(sp)
    8000532a:	6121                	addi	sp,sp,64
    8000532c:	8082                	ret
	...

0000000080005330 <kernelvec>:
    80005330:	7111                	addi	sp,sp,-256
    80005332:	e006                	sd	ra,0(sp)
    80005334:	e40a                	sd	sp,8(sp)
    80005336:	e80e                	sd	gp,16(sp)
    80005338:	ec12                	sd	tp,24(sp)
    8000533a:	f016                	sd	t0,32(sp)
    8000533c:	f41a                	sd	t1,40(sp)
    8000533e:	f81e                	sd	t2,48(sp)
    80005340:	fc22                	sd	s0,56(sp)
    80005342:	e0a6                	sd	s1,64(sp)
    80005344:	e4aa                	sd	a0,72(sp)
    80005346:	e8ae                	sd	a1,80(sp)
    80005348:	ecb2                	sd	a2,88(sp)
    8000534a:	f0b6                	sd	a3,96(sp)
    8000534c:	f4ba                	sd	a4,104(sp)
    8000534e:	f8be                	sd	a5,112(sp)
    80005350:	fcc2                	sd	a6,120(sp)
    80005352:	e146                	sd	a7,128(sp)
    80005354:	e54a                	sd	s2,136(sp)
    80005356:	e94e                	sd	s3,144(sp)
    80005358:	ed52                	sd	s4,152(sp)
    8000535a:	f156                	sd	s5,160(sp)
    8000535c:	f55a                	sd	s6,168(sp)
    8000535e:	f95e                	sd	s7,176(sp)
    80005360:	fd62                	sd	s8,184(sp)
    80005362:	e1e6                	sd	s9,192(sp)
    80005364:	e5ea                	sd	s10,200(sp)
    80005366:	e9ee                	sd	s11,208(sp)
    80005368:	edf2                	sd	t3,216(sp)
    8000536a:	f1f6                	sd	t4,224(sp)
    8000536c:	f5fa                	sd	t5,232(sp)
    8000536e:	f9fe                	sd	t6,240(sp)
    80005370:	b65fc0ef          	jal	ra,80001ed4 <kerneltrap>
    80005374:	6082                	ld	ra,0(sp)
    80005376:	6122                	ld	sp,8(sp)
    80005378:	61c2                	ld	gp,16(sp)
    8000537a:	7282                	ld	t0,32(sp)
    8000537c:	7322                	ld	t1,40(sp)
    8000537e:	73c2                	ld	t2,48(sp)
    80005380:	7462                	ld	s0,56(sp)
    80005382:	6486                	ld	s1,64(sp)
    80005384:	6526                	ld	a0,72(sp)
    80005386:	65c6                	ld	a1,80(sp)
    80005388:	6666                	ld	a2,88(sp)
    8000538a:	7686                	ld	a3,96(sp)
    8000538c:	7726                	ld	a4,104(sp)
    8000538e:	77c6                	ld	a5,112(sp)
    80005390:	7866                	ld	a6,120(sp)
    80005392:	688a                	ld	a7,128(sp)
    80005394:	692a                	ld	s2,136(sp)
    80005396:	69ca                	ld	s3,144(sp)
    80005398:	6a6a                	ld	s4,152(sp)
    8000539a:	7a8a                	ld	s5,160(sp)
    8000539c:	7b2a                	ld	s6,168(sp)
    8000539e:	7bca                	ld	s7,176(sp)
    800053a0:	7c6a                	ld	s8,184(sp)
    800053a2:	6c8e                	ld	s9,192(sp)
    800053a4:	6d2e                	ld	s10,200(sp)
    800053a6:	6dce                	ld	s11,208(sp)
    800053a8:	6e6e                	ld	t3,216(sp)
    800053aa:	7e8e                	ld	t4,224(sp)
    800053ac:	7f2e                	ld	t5,232(sp)
    800053ae:	7fce                	ld	t6,240(sp)
    800053b0:	6111                	addi	sp,sp,256
    800053b2:	10200073          	sret
    800053b6:	00000013          	nop
    800053ba:	00000013          	nop
    800053be:	0001                	nop

00000000800053c0 <timervec>:
    800053c0:	34051573          	csrrw	a0,mscratch,a0
    800053c4:	e10c                	sd	a1,0(a0)
    800053c6:	e510                	sd	a2,8(a0)
    800053c8:	e914                	sd	a3,16(a0)
    800053ca:	6d0c                	ld	a1,24(a0)
    800053cc:	7110                	ld	a2,32(a0)
    800053ce:	6194                	ld	a3,0(a1)
    800053d0:	96b2                	add	a3,a3,a2
    800053d2:	e194                	sd	a3,0(a1)
    800053d4:	4589                	li	a1,2
    800053d6:	14459073          	csrw	sip,a1
    800053da:	6914                	ld	a3,16(a0)
    800053dc:	6510                	ld	a2,8(a0)
    800053de:	610c                	ld	a1,0(a0)
    800053e0:	34051573          	csrrw	a0,mscratch,a0
    800053e4:	30200073          	mret
	...

00000000800053ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800053ea:	1141                	addi	sp,sp,-16
    800053ec:	e422                	sd	s0,8(sp)
    800053ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800053f0:	0c0007b7          	lui	a5,0xc000
    800053f4:	4705                	li	a4,1
    800053f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800053f8:	c3d8                	sw	a4,4(a5)
}
    800053fa:	6422                	ld	s0,8(sp)
    800053fc:	0141                	addi	sp,sp,16
    800053fe:	8082                	ret

0000000080005400 <plicinithart>:

void
plicinithart(void)
{
    80005400:	1141                	addi	sp,sp,-16
    80005402:	e406                	sd	ra,8(sp)
    80005404:	e022                	sd	s0,0(sp)
    80005406:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005408:	ffffc097          	auipc	ra,0xffffc
    8000540c:	bb8080e7          	jalr	-1096(ra) # 80000fc0 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005410:	0085171b          	slliw	a4,a0,0x8
    80005414:	0c0027b7          	lui	a5,0xc002
    80005418:	97ba                	add	a5,a5,a4
    8000541a:	40200713          	li	a4,1026
    8000541e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005422:	00d5151b          	slliw	a0,a0,0xd
    80005426:	0c2017b7          	lui	a5,0xc201
    8000542a:	97aa                	add	a5,a5,a0
    8000542c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005430:	60a2                	ld	ra,8(sp)
    80005432:	6402                	ld	s0,0(sp)
    80005434:	0141                	addi	sp,sp,16
    80005436:	8082                	ret

0000000080005438 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005438:	1141                	addi	sp,sp,-16
    8000543a:	e406                	sd	ra,8(sp)
    8000543c:	e022                	sd	s0,0(sp)
    8000543e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005440:	ffffc097          	auipc	ra,0xffffc
    80005444:	b80080e7          	jalr	-1152(ra) # 80000fc0 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005448:	00d5151b          	slliw	a0,a0,0xd
    8000544c:	0c2017b7          	lui	a5,0xc201
    80005450:	97aa                	add	a5,a5,a0
  return irq;
}
    80005452:	43c8                	lw	a0,4(a5)
    80005454:	60a2                	ld	ra,8(sp)
    80005456:	6402                	ld	s0,0(sp)
    80005458:	0141                	addi	sp,sp,16
    8000545a:	8082                	ret

000000008000545c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000545c:	1101                	addi	sp,sp,-32
    8000545e:	ec06                	sd	ra,24(sp)
    80005460:	e822                	sd	s0,16(sp)
    80005462:	e426                	sd	s1,8(sp)
    80005464:	1000                	addi	s0,sp,32
    80005466:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005468:	ffffc097          	auipc	ra,0xffffc
    8000546c:	b58080e7          	jalr	-1192(ra) # 80000fc0 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005470:	00d5151b          	slliw	a0,a0,0xd
    80005474:	0c2017b7          	lui	a5,0xc201
    80005478:	97aa                	add	a5,a5,a0
    8000547a:	c3c4                	sw	s1,4(a5)
}
    8000547c:	60e2                	ld	ra,24(sp)
    8000547e:	6442                	ld	s0,16(sp)
    80005480:	64a2                	ld	s1,8(sp)
    80005482:	6105                	addi	sp,sp,32
    80005484:	8082                	ret

0000000080005486 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005486:	1141                	addi	sp,sp,-16
    80005488:	e406                	sd	ra,8(sp)
    8000548a:	e022                	sd	s0,0(sp)
    8000548c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000548e:	479d                	li	a5,7
    80005490:	06a7c863          	blt	a5,a0,80005500 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005494:	00019717          	auipc	a4,0x19
    80005498:	b6c70713          	addi	a4,a4,-1172 # 8001e000 <disk>
    8000549c:	972a                	add	a4,a4,a0
    8000549e:	6789                	lui	a5,0x2
    800054a0:	97ba                	add	a5,a5,a4
    800054a2:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800054a6:	e7ad                	bnez	a5,80005510 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800054a8:	00451793          	slli	a5,a0,0x4
    800054ac:	0001b717          	auipc	a4,0x1b
    800054b0:	b5470713          	addi	a4,a4,-1196 # 80020000 <disk+0x2000>
    800054b4:	6314                	ld	a3,0(a4)
    800054b6:	96be                	add	a3,a3,a5
    800054b8:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800054bc:	6314                	ld	a3,0(a4)
    800054be:	96be                	add	a3,a3,a5
    800054c0:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800054c4:	6314                	ld	a3,0(a4)
    800054c6:	96be                	add	a3,a3,a5
    800054c8:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800054cc:	6318                	ld	a4,0(a4)
    800054ce:	97ba                	add	a5,a5,a4
    800054d0:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800054d4:	00019717          	auipc	a4,0x19
    800054d8:	b2c70713          	addi	a4,a4,-1236 # 8001e000 <disk>
    800054dc:	972a                	add	a4,a4,a0
    800054de:	6789                	lui	a5,0x2
    800054e0:	97ba                	add	a5,a5,a4
    800054e2:	4705                	li	a4,1
    800054e4:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800054e8:	0001b517          	auipc	a0,0x1b
    800054ec:	b3050513          	addi	a0,a0,-1232 # 80020018 <disk+0x2018>
    800054f0:	ffffc097          	auipc	ra,0xffffc
    800054f4:	34c080e7          	jalr	844(ra) # 8000183c <wakeup>
}
    800054f8:	60a2                	ld	ra,8(sp)
    800054fa:	6402                	ld	s0,0(sp)
    800054fc:	0141                	addi	sp,sp,16
    800054fe:	8082                	ret
    panic("free_desc 1");
    80005500:	00003517          	auipc	a0,0x3
    80005504:	21050513          	addi	a0,a0,528 # 80008710 <syscalls+0x340>
    80005508:	00001097          	auipc	ra,0x1
    8000550c:	cfc080e7          	jalr	-772(ra) # 80006204 <panic>
    panic("free_desc 2");
    80005510:	00003517          	auipc	a0,0x3
    80005514:	21050513          	addi	a0,a0,528 # 80008720 <syscalls+0x350>
    80005518:	00001097          	auipc	ra,0x1
    8000551c:	cec080e7          	jalr	-788(ra) # 80006204 <panic>

0000000080005520 <virtio_disk_init>:
{
    80005520:	1101                	addi	sp,sp,-32
    80005522:	ec06                	sd	ra,24(sp)
    80005524:	e822                	sd	s0,16(sp)
    80005526:	e426                	sd	s1,8(sp)
    80005528:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000552a:	00003597          	auipc	a1,0x3
    8000552e:	20658593          	addi	a1,a1,518 # 80008730 <syscalls+0x360>
    80005532:	0001b517          	auipc	a0,0x1b
    80005536:	bf650513          	addi	a0,a0,-1034 # 80020128 <disk+0x2128>
    8000553a:	00001097          	auipc	ra,0x1
    8000553e:	368080e7          	jalr	872(ra) # 800068a2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005542:	100017b7          	lui	a5,0x10001
    80005546:	4398                	lw	a4,0(a5)
    80005548:	2701                	sext.w	a4,a4
    8000554a:	747277b7          	lui	a5,0x74727
    8000554e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005552:	0ef71063          	bne	a4,a5,80005632 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005556:	100017b7          	lui	a5,0x10001
    8000555a:	43dc                	lw	a5,4(a5)
    8000555c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000555e:	4705                	li	a4,1
    80005560:	0ce79963          	bne	a5,a4,80005632 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005564:	100017b7          	lui	a5,0x10001
    80005568:	479c                	lw	a5,8(a5)
    8000556a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000556c:	4709                	li	a4,2
    8000556e:	0ce79263          	bne	a5,a4,80005632 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005572:	100017b7          	lui	a5,0x10001
    80005576:	47d8                	lw	a4,12(a5)
    80005578:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000557a:	554d47b7          	lui	a5,0x554d4
    8000557e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005582:	0af71863          	bne	a4,a5,80005632 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005586:	100017b7          	lui	a5,0x10001
    8000558a:	4705                	li	a4,1
    8000558c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000558e:	470d                	li	a4,3
    80005590:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005592:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005594:	c7ffe6b7          	lui	a3,0xc7ffe
    80005598:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd3517>
    8000559c:	8f75                	and	a4,a4,a3
    8000559e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055a0:	472d                	li	a4,11
    800055a2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055a4:	473d                	li	a4,15
    800055a6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800055a8:	6705                	lui	a4,0x1
    800055aa:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800055ac:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800055b0:	5bdc                	lw	a5,52(a5)
    800055b2:	2781                	sext.w	a5,a5
  if(max == 0)
    800055b4:	c7d9                	beqz	a5,80005642 <virtio_disk_init+0x122>
  if(max < NUM)
    800055b6:	471d                	li	a4,7
    800055b8:	08f77d63          	bgeu	a4,a5,80005652 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055bc:	100014b7          	lui	s1,0x10001
    800055c0:	47a1                	li	a5,8
    800055c2:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800055c4:	6609                	lui	a2,0x2
    800055c6:	4581                	li	a1,0
    800055c8:	00019517          	auipc	a0,0x19
    800055cc:	a3850513          	addi	a0,a0,-1480 # 8001e000 <disk>
    800055d0:	ffffb097          	auipc	ra,0xffffb
    800055d4:	d42080e7          	jalr	-702(ra) # 80000312 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800055d8:	00019717          	auipc	a4,0x19
    800055dc:	a2870713          	addi	a4,a4,-1496 # 8001e000 <disk>
    800055e0:	00c75793          	srli	a5,a4,0xc
    800055e4:	2781                	sext.w	a5,a5
    800055e6:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800055e8:	0001b797          	auipc	a5,0x1b
    800055ec:	a1878793          	addi	a5,a5,-1512 # 80020000 <disk+0x2000>
    800055f0:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800055f2:	00019717          	auipc	a4,0x19
    800055f6:	a8e70713          	addi	a4,a4,-1394 # 8001e080 <disk+0x80>
    800055fa:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800055fc:	0001a717          	auipc	a4,0x1a
    80005600:	a0470713          	addi	a4,a4,-1532 # 8001f000 <disk+0x1000>
    80005604:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005606:	4705                	li	a4,1
    80005608:	00e78c23          	sb	a4,24(a5)
    8000560c:	00e78ca3          	sb	a4,25(a5)
    80005610:	00e78d23          	sb	a4,26(a5)
    80005614:	00e78da3          	sb	a4,27(a5)
    80005618:	00e78e23          	sb	a4,28(a5)
    8000561c:	00e78ea3          	sb	a4,29(a5)
    80005620:	00e78f23          	sb	a4,30(a5)
    80005624:	00e78fa3          	sb	a4,31(a5)
}
    80005628:	60e2                	ld	ra,24(sp)
    8000562a:	6442                	ld	s0,16(sp)
    8000562c:	64a2                	ld	s1,8(sp)
    8000562e:	6105                	addi	sp,sp,32
    80005630:	8082                	ret
    panic("could not find virtio disk");
    80005632:	00003517          	auipc	a0,0x3
    80005636:	10e50513          	addi	a0,a0,270 # 80008740 <syscalls+0x370>
    8000563a:	00001097          	auipc	ra,0x1
    8000563e:	bca080e7          	jalr	-1078(ra) # 80006204 <panic>
    panic("virtio disk has no queue 0");
    80005642:	00003517          	auipc	a0,0x3
    80005646:	11e50513          	addi	a0,a0,286 # 80008760 <syscalls+0x390>
    8000564a:	00001097          	auipc	ra,0x1
    8000564e:	bba080e7          	jalr	-1094(ra) # 80006204 <panic>
    panic("virtio disk max queue too short");
    80005652:	00003517          	auipc	a0,0x3
    80005656:	12e50513          	addi	a0,a0,302 # 80008780 <syscalls+0x3b0>
    8000565a:	00001097          	auipc	ra,0x1
    8000565e:	baa080e7          	jalr	-1110(ra) # 80006204 <panic>

0000000080005662 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005662:	7119                	addi	sp,sp,-128
    80005664:	fc86                	sd	ra,120(sp)
    80005666:	f8a2                	sd	s0,112(sp)
    80005668:	f4a6                	sd	s1,104(sp)
    8000566a:	f0ca                	sd	s2,96(sp)
    8000566c:	ecce                	sd	s3,88(sp)
    8000566e:	e8d2                	sd	s4,80(sp)
    80005670:	e4d6                	sd	s5,72(sp)
    80005672:	e0da                	sd	s6,64(sp)
    80005674:	fc5e                	sd	s7,56(sp)
    80005676:	f862                	sd	s8,48(sp)
    80005678:	f466                	sd	s9,40(sp)
    8000567a:	f06a                	sd	s10,32(sp)
    8000567c:	ec6e                	sd	s11,24(sp)
    8000567e:	0100                	addi	s0,sp,128
    80005680:	8aaa                	mv	s5,a0
    80005682:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005684:	00c52c83          	lw	s9,12(a0)
    80005688:	001c9c9b          	slliw	s9,s9,0x1
    8000568c:	1c82                	slli	s9,s9,0x20
    8000568e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005692:	0001b517          	auipc	a0,0x1b
    80005696:	a9650513          	addi	a0,a0,-1386 # 80020128 <disk+0x2128>
    8000569a:	00001097          	auipc	ra,0x1
    8000569e:	08c080e7          	jalr	140(ra) # 80006726 <acquire>
  for(int i = 0; i < 3; i++){
    800056a2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800056a4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800056a6:	00019c17          	auipc	s8,0x19
    800056aa:	95ac0c13          	addi	s8,s8,-1702 # 8001e000 <disk>
    800056ae:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800056b0:	4b0d                	li	s6,3
    800056b2:	a0ad                	j	8000571c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800056b4:	00fc0733          	add	a4,s8,a5
    800056b8:	975e                	add	a4,a4,s7
    800056ba:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800056be:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800056c0:	0207c563          	bltz	a5,800056ea <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800056c4:	2905                	addiw	s2,s2,1
    800056c6:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800056c8:	19690c63          	beq	s2,s6,80005860 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    800056cc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056ce:	0001b717          	auipc	a4,0x1b
    800056d2:	94a70713          	addi	a4,a4,-1718 # 80020018 <disk+0x2018>
    800056d6:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800056d8:	00074683          	lbu	a3,0(a4)
    800056dc:	fee1                	bnez	a3,800056b4 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800056de:	2785                	addiw	a5,a5,1
    800056e0:	0705                	addi	a4,a4,1
    800056e2:	fe979be3          	bne	a5,s1,800056d8 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800056e6:	57fd                	li	a5,-1
    800056e8:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056ea:	01205d63          	blez	s2,80005704 <virtio_disk_rw+0xa2>
    800056ee:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800056f0:	000a2503          	lw	a0,0(s4)
    800056f4:	00000097          	auipc	ra,0x0
    800056f8:	d92080e7          	jalr	-622(ra) # 80005486 <free_desc>
      for(int j = 0; j < i; j++)
    800056fc:	2d85                	addiw	s11,s11,1
    800056fe:	0a11                	addi	s4,s4,4
    80005700:	ff2d98e3          	bne	s11,s2,800056f0 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005704:	0001b597          	auipc	a1,0x1b
    80005708:	a2458593          	addi	a1,a1,-1500 # 80020128 <disk+0x2128>
    8000570c:	0001b517          	auipc	a0,0x1b
    80005710:	90c50513          	addi	a0,a0,-1780 # 80020018 <disk+0x2018>
    80005714:	ffffc097          	auipc	ra,0xffffc
    80005718:	f9c080e7          	jalr	-100(ra) # 800016b0 <sleep>
  for(int i = 0; i < 3; i++){
    8000571c:	f8040a13          	addi	s4,s0,-128
{
    80005720:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005722:	894e                	mv	s2,s3
    80005724:	b765                	j	800056cc <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005726:	0001b697          	auipc	a3,0x1b
    8000572a:	8da6b683          	ld	a3,-1830(a3) # 80020000 <disk+0x2000>
    8000572e:	96ba                	add	a3,a3,a4
    80005730:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005734:	00019817          	auipc	a6,0x19
    80005738:	8cc80813          	addi	a6,a6,-1844 # 8001e000 <disk>
    8000573c:	0001b697          	auipc	a3,0x1b
    80005740:	8c468693          	addi	a3,a3,-1852 # 80020000 <disk+0x2000>
    80005744:	6290                	ld	a2,0(a3)
    80005746:	963a                	add	a2,a2,a4
    80005748:	00c65583          	lhu	a1,12(a2)
    8000574c:	0015e593          	ori	a1,a1,1
    80005750:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005754:	f8842603          	lw	a2,-120(s0)
    80005758:	628c                	ld	a1,0(a3)
    8000575a:	972e                	add	a4,a4,a1
    8000575c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005760:	20050593          	addi	a1,a0,512
    80005764:	0592                	slli	a1,a1,0x4
    80005766:	95c2                	add	a1,a1,a6
    80005768:	577d                	li	a4,-1
    8000576a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000576e:	00461713          	slli	a4,a2,0x4
    80005772:	6290                	ld	a2,0(a3)
    80005774:	963a                	add	a2,a2,a4
    80005776:	03078793          	addi	a5,a5,48
    8000577a:	97c2                	add	a5,a5,a6
    8000577c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000577e:	629c                	ld	a5,0(a3)
    80005780:	97ba                	add	a5,a5,a4
    80005782:	4605                	li	a2,1
    80005784:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005786:	629c                	ld	a5,0(a3)
    80005788:	97ba                	add	a5,a5,a4
    8000578a:	4809                	li	a6,2
    8000578c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005790:	629c                	ld	a5,0(a3)
    80005792:	97ba                	add	a5,a5,a4
    80005794:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005798:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000579c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057a0:	6698                	ld	a4,8(a3)
    800057a2:	00275783          	lhu	a5,2(a4)
    800057a6:	8b9d                	andi	a5,a5,7
    800057a8:	0786                	slli	a5,a5,0x1
    800057aa:	973e                	add	a4,a4,a5
    800057ac:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    800057b0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057b4:	6698                	ld	a4,8(a3)
    800057b6:	00275783          	lhu	a5,2(a4)
    800057ba:	2785                	addiw	a5,a5,1
    800057bc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057c0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057c4:	100017b7          	lui	a5,0x10001
    800057c8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057cc:	004aa783          	lw	a5,4(s5)
    800057d0:	02c79163          	bne	a5,a2,800057f2 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800057d4:	0001b917          	auipc	s2,0x1b
    800057d8:	95490913          	addi	s2,s2,-1708 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    800057dc:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057de:	85ca                	mv	a1,s2
    800057e0:	8556                	mv	a0,s5
    800057e2:	ffffc097          	auipc	ra,0xffffc
    800057e6:	ece080e7          	jalr	-306(ra) # 800016b0 <sleep>
  while(b->disk == 1) {
    800057ea:	004aa783          	lw	a5,4(s5)
    800057ee:	fe9788e3          	beq	a5,s1,800057de <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800057f2:	f8042903          	lw	s2,-128(s0)
    800057f6:	20090713          	addi	a4,s2,512
    800057fa:	0712                	slli	a4,a4,0x4
    800057fc:	00019797          	auipc	a5,0x19
    80005800:	80478793          	addi	a5,a5,-2044 # 8001e000 <disk>
    80005804:	97ba                	add	a5,a5,a4
    80005806:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000580a:	0001a997          	auipc	s3,0x1a
    8000580e:	7f698993          	addi	s3,s3,2038 # 80020000 <disk+0x2000>
    80005812:	00491713          	slli	a4,s2,0x4
    80005816:	0009b783          	ld	a5,0(s3)
    8000581a:	97ba                	add	a5,a5,a4
    8000581c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005820:	854a                	mv	a0,s2
    80005822:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005826:	00000097          	auipc	ra,0x0
    8000582a:	c60080e7          	jalr	-928(ra) # 80005486 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000582e:	8885                	andi	s1,s1,1
    80005830:	f0ed                	bnez	s1,80005812 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005832:	0001b517          	auipc	a0,0x1b
    80005836:	8f650513          	addi	a0,a0,-1802 # 80020128 <disk+0x2128>
    8000583a:	00001097          	auipc	ra,0x1
    8000583e:	fbc080e7          	jalr	-68(ra) # 800067f6 <release>
}
    80005842:	70e6                	ld	ra,120(sp)
    80005844:	7446                	ld	s0,112(sp)
    80005846:	74a6                	ld	s1,104(sp)
    80005848:	7906                	ld	s2,96(sp)
    8000584a:	69e6                	ld	s3,88(sp)
    8000584c:	6a46                	ld	s4,80(sp)
    8000584e:	6aa6                	ld	s5,72(sp)
    80005850:	6b06                	ld	s6,64(sp)
    80005852:	7be2                	ld	s7,56(sp)
    80005854:	7c42                	ld	s8,48(sp)
    80005856:	7ca2                	ld	s9,40(sp)
    80005858:	7d02                	ld	s10,32(sp)
    8000585a:	6de2                	ld	s11,24(sp)
    8000585c:	6109                	addi	sp,sp,128
    8000585e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005860:	f8042503          	lw	a0,-128(s0)
    80005864:	20050793          	addi	a5,a0,512
    80005868:	0792                	slli	a5,a5,0x4
  if(write)
    8000586a:	00018817          	auipc	a6,0x18
    8000586e:	79680813          	addi	a6,a6,1942 # 8001e000 <disk>
    80005872:	00f80733          	add	a4,a6,a5
    80005876:	01a036b3          	snez	a3,s10
    8000587a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000587e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005882:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005886:	7679                	lui	a2,0xffffe
    80005888:	963e                	add	a2,a2,a5
    8000588a:	0001a697          	auipc	a3,0x1a
    8000588e:	77668693          	addi	a3,a3,1910 # 80020000 <disk+0x2000>
    80005892:	6298                	ld	a4,0(a3)
    80005894:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005896:	0a878593          	addi	a1,a5,168
    8000589a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000589c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000589e:	6298                	ld	a4,0(a3)
    800058a0:	9732                	add	a4,a4,a2
    800058a2:	45c1                	li	a1,16
    800058a4:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058a6:	6298                	ld	a4,0(a3)
    800058a8:	9732                	add	a4,a4,a2
    800058aa:	4585                	li	a1,1
    800058ac:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800058b0:	f8442703          	lw	a4,-124(s0)
    800058b4:	628c                	ld	a1,0(a3)
    800058b6:	962e                	add	a2,a2,a1
    800058b8:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd2dc6>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800058bc:	0712                	slli	a4,a4,0x4
    800058be:	6290                	ld	a2,0(a3)
    800058c0:	963a                	add	a2,a2,a4
    800058c2:	058a8593          	addi	a1,s5,88
    800058c6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800058c8:	6294                	ld	a3,0(a3)
    800058ca:	96ba                	add	a3,a3,a4
    800058cc:	40000613          	li	a2,1024
    800058d0:	c690                	sw	a2,8(a3)
  if(write)
    800058d2:	e40d1ae3          	bnez	s10,80005726 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800058d6:	0001a697          	auipc	a3,0x1a
    800058da:	72a6b683          	ld	a3,1834(a3) # 80020000 <disk+0x2000>
    800058de:	96ba                	add	a3,a3,a4
    800058e0:	4609                	li	a2,2
    800058e2:	00c69623          	sh	a2,12(a3)
    800058e6:	b5b9                	j	80005734 <virtio_disk_rw+0xd2>

00000000800058e8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058e8:	1101                	addi	sp,sp,-32
    800058ea:	ec06                	sd	ra,24(sp)
    800058ec:	e822                	sd	s0,16(sp)
    800058ee:	e426                	sd	s1,8(sp)
    800058f0:	e04a                	sd	s2,0(sp)
    800058f2:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058f4:	0001b517          	auipc	a0,0x1b
    800058f8:	83450513          	addi	a0,a0,-1996 # 80020128 <disk+0x2128>
    800058fc:	00001097          	auipc	ra,0x1
    80005900:	e2a080e7          	jalr	-470(ra) # 80006726 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005904:	10001737          	lui	a4,0x10001
    80005908:	533c                	lw	a5,96(a4)
    8000590a:	8b8d                	andi	a5,a5,3
    8000590c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000590e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005912:	0001a797          	auipc	a5,0x1a
    80005916:	6ee78793          	addi	a5,a5,1774 # 80020000 <disk+0x2000>
    8000591a:	6b94                	ld	a3,16(a5)
    8000591c:	0207d703          	lhu	a4,32(a5)
    80005920:	0026d783          	lhu	a5,2(a3)
    80005924:	06f70163          	beq	a4,a5,80005986 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005928:	00018917          	auipc	s2,0x18
    8000592c:	6d890913          	addi	s2,s2,1752 # 8001e000 <disk>
    80005930:	0001a497          	auipc	s1,0x1a
    80005934:	6d048493          	addi	s1,s1,1744 # 80020000 <disk+0x2000>
    __sync_synchronize();
    80005938:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000593c:	6898                	ld	a4,16(s1)
    8000593e:	0204d783          	lhu	a5,32(s1)
    80005942:	8b9d                	andi	a5,a5,7
    80005944:	078e                	slli	a5,a5,0x3
    80005946:	97ba                	add	a5,a5,a4
    80005948:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000594a:	20078713          	addi	a4,a5,512
    8000594e:	0712                	slli	a4,a4,0x4
    80005950:	974a                	add	a4,a4,s2
    80005952:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005956:	e731                	bnez	a4,800059a2 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005958:	20078793          	addi	a5,a5,512
    8000595c:	0792                	slli	a5,a5,0x4
    8000595e:	97ca                	add	a5,a5,s2
    80005960:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005962:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005966:	ffffc097          	auipc	ra,0xffffc
    8000596a:	ed6080e7          	jalr	-298(ra) # 8000183c <wakeup>

    disk.used_idx += 1;
    8000596e:	0204d783          	lhu	a5,32(s1)
    80005972:	2785                	addiw	a5,a5,1
    80005974:	17c2                	slli	a5,a5,0x30
    80005976:	93c1                	srli	a5,a5,0x30
    80005978:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000597c:	6898                	ld	a4,16(s1)
    8000597e:	00275703          	lhu	a4,2(a4)
    80005982:	faf71be3          	bne	a4,a5,80005938 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005986:	0001a517          	auipc	a0,0x1a
    8000598a:	7a250513          	addi	a0,a0,1954 # 80020128 <disk+0x2128>
    8000598e:	00001097          	auipc	ra,0x1
    80005992:	e68080e7          	jalr	-408(ra) # 800067f6 <release>
}
    80005996:	60e2                	ld	ra,24(sp)
    80005998:	6442                	ld	s0,16(sp)
    8000599a:	64a2                	ld	s1,8(sp)
    8000599c:	6902                	ld	s2,0(sp)
    8000599e:	6105                	addi	sp,sp,32
    800059a0:	8082                	ret
      panic("virtio_disk_intr status");
    800059a2:	00003517          	auipc	a0,0x3
    800059a6:	dfe50513          	addi	a0,a0,-514 # 800087a0 <syscalls+0x3d0>
    800059aa:	00001097          	auipc	ra,0x1
    800059ae:	85a080e7          	jalr	-1958(ra) # 80006204 <panic>

00000000800059b2 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    800059b2:	1141                	addi	sp,sp,-16
    800059b4:	e422                	sd	s0,8(sp)
    800059b6:	0800                	addi	s0,sp,16
  return -1;
}
    800059b8:	557d                	li	a0,-1
    800059ba:	6422                	ld	s0,8(sp)
    800059bc:	0141                	addi	sp,sp,16
    800059be:	8082                	ret

00000000800059c0 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    800059c0:	7179                	addi	sp,sp,-48
    800059c2:	f406                	sd	ra,40(sp)
    800059c4:	f022                	sd	s0,32(sp)
    800059c6:	ec26                	sd	s1,24(sp)
    800059c8:	e84a                	sd	s2,16(sp)
    800059ca:	e44e                	sd	s3,8(sp)
    800059cc:	e052                	sd	s4,0(sp)
    800059ce:	1800                	addi	s0,sp,48
    800059d0:	892a                	mv	s2,a0
    800059d2:	89ae                	mv	s3,a1
    800059d4:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    800059d6:	0001b517          	auipc	a0,0x1b
    800059da:	62a50513          	addi	a0,a0,1578 # 80021000 <stats>
    800059de:	00001097          	auipc	ra,0x1
    800059e2:	d48080e7          	jalr	-696(ra) # 80006726 <acquire>

  if(stats.sz == 0) {
    800059e6:	0001c797          	auipc	a5,0x1c
    800059ea:	63a7a783          	lw	a5,1594(a5) # 80022020 <stats+0x1020>
    800059ee:	cbb5                	beqz	a5,80005a62 <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    800059f0:	0001c797          	auipc	a5,0x1c
    800059f4:	61078793          	addi	a5,a5,1552 # 80022000 <stats+0x1000>
    800059f8:	53d8                	lw	a4,36(a5)
    800059fa:	539c                	lw	a5,32(a5)
    800059fc:	9f99                	subw	a5,a5,a4
    800059fe:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    80005a02:	06d05e63          	blez	a3,80005a7e <statsread+0xbe>
    if(m > n)
    80005a06:	8a3e                	mv	s4,a5
    80005a08:	00d4d363          	bge	s1,a3,80005a0e <statsread+0x4e>
    80005a0c:	8a26                	mv	s4,s1
    80005a0e:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    80005a12:	86a6                	mv	a3,s1
    80005a14:	0001b617          	auipc	a2,0x1b
    80005a18:	60c60613          	addi	a2,a2,1548 # 80021020 <stats+0x20>
    80005a1c:	963a                	add	a2,a2,a4
    80005a1e:	85ce                	mv	a1,s3
    80005a20:	854a                	mv	a0,s2
    80005a22:	ffffc097          	auipc	ra,0xffffc
    80005a26:	032080e7          	jalr	50(ra) # 80001a54 <either_copyout>
    80005a2a:	57fd                	li	a5,-1
    80005a2c:	00f50a63          	beq	a0,a5,80005a40 <statsread+0x80>
      stats.off += m;
    80005a30:	0001c717          	auipc	a4,0x1c
    80005a34:	5d070713          	addi	a4,a4,1488 # 80022000 <stats+0x1000>
    80005a38:	535c                	lw	a5,36(a4)
    80005a3a:	00fa07bb          	addw	a5,s4,a5
    80005a3e:	d35c                	sw	a5,36(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    80005a40:	0001b517          	auipc	a0,0x1b
    80005a44:	5c050513          	addi	a0,a0,1472 # 80021000 <stats>
    80005a48:	00001097          	auipc	ra,0x1
    80005a4c:	dae080e7          	jalr	-594(ra) # 800067f6 <release>
  return m;
}
    80005a50:	8526                	mv	a0,s1
    80005a52:	70a2                	ld	ra,40(sp)
    80005a54:	7402                	ld	s0,32(sp)
    80005a56:	64e2                	ld	s1,24(sp)
    80005a58:	6942                	ld	s2,16(sp)
    80005a5a:	69a2                	ld	s3,8(sp)
    80005a5c:	6a02                	ld	s4,0(sp)
    80005a5e:	6145                	addi	sp,sp,48
    80005a60:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    80005a62:	6585                	lui	a1,0x1
    80005a64:	0001b517          	auipc	a0,0x1b
    80005a68:	5bc50513          	addi	a0,a0,1468 # 80021020 <stats+0x20>
    80005a6c:	00001097          	auipc	ra,0x1
    80005a70:	f10080e7          	jalr	-240(ra) # 8000697c <statslock>
    80005a74:	0001c797          	auipc	a5,0x1c
    80005a78:	5aa7a623          	sw	a0,1452(a5) # 80022020 <stats+0x1020>
    80005a7c:	bf95                	j	800059f0 <statsread+0x30>
    stats.sz = 0;
    80005a7e:	0001c797          	auipc	a5,0x1c
    80005a82:	58278793          	addi	a5,a5,1410 # 80022000 <stats+0x1000>
    80005a86:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    80005a8a:	0207a223          	sw	zero,36(a5)
    m = -1;
    80005a8e:	54fd                	li	s1,-1
    80005a90:	bf45                	j	80005a40 <statsread+0x80>

0000000080005a92 <statsinit>:

void
statsinit(void)
{
    80005a92:	1141                	addi	sp,sp,-16
    80005a94:	e406                	sd	ra,8(sp)
    80005a96:	e022                	sd	s0,0(sp)
    80005a98:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    80005a9a:	00003597          	auipc	a1,0x3
    80005a9e:	d1e58593          	addi	a1,a1,-738 # 800087b8 <syscalls+0x3e8>
    80005aa2:	0001b517          	auipc	a0,0x1b
    80005aa6:	55e50513          	addi	a0,a0,1374 # 80021000 <stats>
    80005aaa:	00001097          	auipc	ra,0x1
    80005aae:	df8080e7          	jalr	-520(ra) # 800068a2 <initlock>

  devsw[STATS].read = statsread;
    80005ab2:	00017797          	auipc	a5,0x17
    80005ab6:	27678793          	addi	a5,a5,630 # 8001cd28 <devsw>
    80005aba:	00000717          	auipc	a4,0x0
    80005abe:	f0670713          	addi	a4,a4,-250 # 800059c0 <statsread>
    80005ac2:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80005ac4:	00000717          	auipc	a4,0x0
    80005ac8:	eee70713          	addi	a4,a4,-274 # 800059b2 <statswrite>
    80005acc:	f798                	sd	a4,40(a5)
}
    80005ace:	60a2                	ld	ra,8(sp)
    80005ad0:	6402                	ld	s0,0(sp)
    80005ad2:	0141                	addi	sp,sp,16
    80005ad4:	8082                	ret

0000000080005ad6 <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80005ad6:	1101                	addi	sp,sp,-32
    80005ad8:	ec22                	sd	s0,24(sp)
    80005ada:	1000                	addi	s0,sp,32
    80005adc:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005ade:	c299                	beqz	a3,80005ae4 <sprintint+0xe>
    80005ae0:	0805c263          	bltz	a1,80005b64 <sprintint+0x8e>
    x = -xx;
  else
    x = xx;
    80005ae4:	2581                	sext.w	a1,a1
    80005ae6:	4301                	li	t1,0

  i = 0;
    80005ae8:	fe040713          	addi	a4,s0,-32
    80005aec:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005aee:	2601                	sext.w	a2,a2
    80005af0:	00003697          	auipc	a3,0x3
    80005af4:	ce868693          	addi	a3,a3,-792 # 800087d8 <digits>
    80005af8:	88aa                	mv	a7,a0
    80005afa:	2505                	addiw	a0,a0,1
    80005afc:	02c5f7bb          	remuw	a5,a1,a2
    80005b00:	1782                	slli	a5,a5,0x20
    80005b02:	9381                	srli	a5,a5,0x20
    80005b04:	97b6                	add	a5,a5,a3
    80005b06:	0007c783          	lbu	a5,0(a5)
    80005b0a:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005b0e:	0005879b          	sext.w	a5,a1
    80005b12:	02c5d5bb          	divuw	a1,a1,a2
    80005b16:	0705                	addi	a4,a4,1
    80005b18:	fec7f0e3          	bgeu	a5,a2,80005af8 <sprintint+0x22>

  if(sign)
    80005b1c:	00030b63          	beqz	t1,80005b32 <sprintint+0x5c>
    buf[i++] = '-';
    80005b20:	ff050793          	addi	a5,a0,-16
    80005b24:	97a2                	add	a5,a5,s0
    80005b26:	02d00713          	li	a4,45
    80005b2a:	fee78823          	sb	a4,-16(a5)
    80005b2e:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80005b32:	02a05d63          	blez	a0,80005b6c <sprintint+0x96>
    80005b36:	fe040793          	addi	a5,s0,-32
    80005b3a:	00a78733          	add	a4,a5,a0
    80005b3e:	87c2                	mv	a5,a6
    80005b40:	00180613          	addi	a2,a6,1
    80005b44:	fff5069b          	addiw	a3,a0,-1
    80005b48:	1682                	slli	a3,a3,0x20
    80005b4a:	9281                	srli	a3,a3,0x20
    80005b4c:	9636                	add	a2,a2,a3
  *s = c;
    80005b4e:	fff74683          	lbu	a3,-1(a4)
    80005b52:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    80005b56:	177d                	addi	a4,a4,-1
    80005b58:	0785                	addi	a5,a5,1
    80005b5a:	fec79ae3          	bne	a5,a2,80005b4e <sprintint+0x78>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005b5e:	6462                	ld	s0,24(sp)
    80005b60:	6105                	addi	sp,sp,32
    80005b62:	8082                	ret
    x = -xx;
    80005b64:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005b68:	4305                	li	t1,1
    x = -xx;
    80005b6a:	bfbd                	j	80005ae8 <sprintint+0x12>
  while(--i >= 0)
    80005b6c:	4501                	li	a0,0
    80005b6e:	bfc5                	j	80005b5e <sprintint+0x88>

0000000080005b70 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005b70:	7135                	addi	sp,sp,-160
    80005b72:	f486                	sd	ra,104(sp)
    80005b74:	f0a2                	sd	s0,96(sp)
    80005b76:	eca6                	sd	s1,88(sp)
    80005b78:	e8ca                	sd	s2,80(sp)
    80005b7a:	e4ce                	sd	s3,72(sp)
    80005b7c:	e0d2                	sd	s4,64(sp)
    80005b7e:	fc56                	sd	s5,56(sp)
    80005b80:	f85a                	sd	s6,48(sp)
    80005b82:	f45e                	sd	s7,40(sp)
    80005b84:	f062                	sd	s8,32(sp)
    80005b86:	ec66                	sd	s9,24(sp)
    80005b88:	e86a                	sd	s10,16(sp)
    80005b8a:	1880                	addi	s0,sp,112
    80005b8c:	e414                	sd	a3,8(s0)
    80005b8e:	e818                	sd	a4,16(s0)
    80005b90:	ec1c                	sd	a5,24(s0)
    80005b92:	03043023          	sd	a6,32(s0)
    80005b96:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005b9a:	c61d                	beqz	a2,80005bc8 <snprintf+0x58>
    80005b9c:	8baa                	mv	s7,a0
    80005b9e:	89ae                	mv	s3,a1
    80005ba0:	8a32                	mv	s4,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005ba2:	00840793          	addi	a5,s0,8
    80005ba6:	f8f43c23          	sd	a5,-104(s0)
  int off = 0;
    80005baa:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005bac:	4901                	li	s2,0
    80005bae:	02b05563          	blez	a1,80005bd8 <snprintf+0x68>
    if(c != '%'){
    80005bb2:	02500a93          	li	s5,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005bb6:	07300b13          	li	s6,115
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s && off < sz; s++)
    80005bba:	02800d13          	li	s10,40
    switch(c){
    80005bbe:	07800c93          	li	s9,120
    80005bc2:	06400c13          	li	s8,100
    80005bc6:	a01d                	j	80005bec <snprintf+0x7c>
    panic("null fmt");
    80005bc8:	00003517          	auipc	a0,0x3
    80005bcc:	c0050513          	addi	a0,a0,-1024 # 800087c8 <syscalls+0x3f8>
    80005bd0:	00000097          	auipc	ra,0x0
    80005bd4:	634080e7          	jalr	1588(ra) # 80006204 <panic>
  int off = 0;
    80005bd8:	4481                	li	s1,0
    80005bda:	a875                	j	80005c96 <snprintf+0x126>
  *s = c;
    80005bdc:	009b8733          	add	a4,s7,s1
    80005be0:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005be4:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005be6:	2905                	addiw	s2,s2,1
    80005be8:	0b34d763          	bge	s1,s3,80005c96 <snprintf+0x126>
    80005bec:	012a07b3          	add	a5,s4,s2
    80005bf0:	0007c783          	lbu	a5,0(a5)
    80005bf4:	0007871b          	sext.w	a4,a5
    80005bf8:	cfd9                	beqz	a5,80005c96 <snprintf+0x126>
    if(c != '%'){
    80005bfa:	ff5711e3          	bne	a4,s5,80005bdc <snprintf+0x6c>
    c = fmt[++i] & 0xff;
    80005bfe:	2905                	addiw	s2,s2,1
    80005c00:	012a07b3          	add	a5,s4,s2
    80005c04:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005c08:	c7d9                	beqz	a5,80005c96 <snprintf+0x126>
    switch(c){
    80005c0a:	05678c63          	beq	a5,s6,80005c62 <snprintf+0xf2>
    80005c0e:	02fb6763          	bltu	s6,a5,80005c3c <snprintf+0xcc>
    80005c12:	0b578763          	beq	a5,s5,80005cc0 <snprintf+0x150>
    80005c16:	0b879b63          	bne	a5,s8,80005ccc <snprintf+0x15c>
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005c1a:	f9843783          	ld	a5,-104(s0)
    80005c1e:	00878713          	addi	a4,a5,8
    80005c22:	f8e43c23          	sd	a4,-104(s0)
    80005c26:	4685                	li	a3,1
    80005c28:	4629                	li	a2,10
    80005c2a:	438c                	lw	a1,0(a5)
    80005c2c:	009b8533          	add	a0,s7,s1
    80005c30:	00000097          	auipc	ra,0x0
    80005c34:	ea6080e7          	jalr	-346(ra) # 80005ad6 <sprintint>
    80005c38:	9ca9                	addw	s1,s1,a0
      break;
    80005c3a:	b775                	j	80005be6 <snprintf+0x76>
    switch(c){
    80005c3c:	09979863          	bne	a5,s9,80005ccc <snprintf+0x15c>
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005c40:	f9843783          	ld	a5,-104(s0)
    80005c44:	00878713          	addi	a4,a5,8
    80005c48:	f8e43c23          	sd	a4,-104(s0)
    80005c4c:	4685                	li	a3,1
    80005c4e:	4641                	li	a2,16
    80005c50:	438c                	lw	a1,0(a5)
    80005c52:	009b8533          	add	a0,s7,s1
    80005c56:	00000097          	auipc	ra,0x0
    80005c5a:	e80080e7          	jalr	-384(ra) # 80005ad6 <sprintint>
    80005c5e:	9ca9                	addw	s1,s1,a0
      break;
    80005c60:	b759                	j	80005be6 <snprintf+0x76>
      if((s = va_arg(ap, char*)) == 0)
    80005c62:	f9843783          	ld	a5,-104(s0)
    80005c66:	00878713          	addi	a4,a5,8
    80005c6a:	f8e43c23          	sd	a4,-104(s0)
    80005c6e:	639c                	ld	a5,0(a5)
    80005c70:	c3b1                	beqz	a5,80005cb4 <snprintf+0x144>
      for(; *s && off < sz; s++)
    80005c72:	0007c703          	lbu	a4,0(a5)
    80005c76:	db25                	beqz	a4,80005be6 <snprintf+0x76>
    80005c78:	0734d563          	bge	s1,s3,80005ce2 <snprintf+0x172>
    80005c7c:	009b86b3          	add	a3,s7,s1
  *s = c;
    80005c80:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005c84:	2485                	addiw	s1,s1,1
      for(; *s && off < sz; s++)
    80005c86:	0785                	addi	a5,a5,1
    80005c88:	0007c703          	lbu	a4,0(a5)
    80005c8c:	df29                	beqz	a4,80005be6 <snprintf+0x76>
    80005c8e:	0685                	addi	a3,a3,1
    80005c90:	fe9998e3          	bne	s3,s1,80005c80 <snprintf+0x110>
  int off = 0;
    80005c94:	84ce                	mv	s1,s3
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005c96:	8526                	mv	a0,s1
    80005c98:	70a6                	ld	ra,104(sp)
    80005c9a:	7406                	ld	s0,96(sp)
    80005c9c:	64e6                	ld	s1,88(sp)
    80005c9e:	6946                	ld	s2,80(sp)
    80005ca0:	69a6                	ld	s3,72(sp)
    80005ca2:	6a06                	ld	s4,64(sp)
    80005ca4:	7ae2                	ld	s5,56(sp)
    80005ca6:	7b42                	ld	s6,48(sp)
    80005ca8:	7ba2                	ld	s7,40(sp)
    80005caa:	7c02                	ld	s8,32(sp)
    80005cac:	6ce2                	ld	s9,24(sp)
    80005cae:	6d42                	ld	s10,16(sp)
    80005cb0:	610d                	addi	sp,sp,160
    80005cb2:	8082                	ret
        s = "(null)";
    80005cb4:	00003797          	auipc	a5,0x3
    80005cb8:	b0c78793          	addi	a5,a5,-1268 # 800087c0 <syscalls+0x3f0>
      for(; *s && off < sz; s++)
    80005cbc:	876a                	mv	a4,s10
    80005cbe:	bf6d                	j	80005c78 <snprintf+0x108>
  *s = c;
    80005cc0:	009b87b3          	add	a5,s7,s1
    80005cc4:	01578023          	sb	s5,0(a5)
      off += sputc(buf+off, '%');
    80005cc8:	2485                	addiw	s1,s1,1
      break;
    80005cca:	bf31                	j	80005be6 <snprintf+0x76>
  *s = c;
    80005ccc:	009b8733          	add	a4,s7,s1
    80005cd0:	01570023          	sb	s5,0(a4)
      off += sputc(buf+off, c);
    80005cd4:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005cd8:	975e                	add	a4,a4,s7
    80005cda:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005cde:	2489                	addiw	s1,s1,2
      break;
    80005ce0:	b719                	j	80005be6 <snprintf+0x76>
      for(; *s && off < sz; s++)
    80005ce2:	89a6                	mv	s3,s1
    80005ce4:	bf45                	j	80005c94 <snprintf+0x124>

0000000080005ce6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005ce6:	1141                	addi	sp,sp,-16
    80005ce8:	e422                	sd	s0,8(sp)
    80005cea:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005cec:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005cf0:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005cf4:	0037979b          	slliw	a5,a5,0x3
    80005cf8:	02004737          	lui	a4,0x2004
    80005cfc:	97ba                	add	a5,a5,a4
    80005cfe:	0200c737          	lui	a4,0x200c
    80005d02:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005d06:	000f4637          	lui	a2,0xf4
    80005d0a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005d0e:	9732                	add	a4,a4,a2
    80005d10:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005d12:	00259693          	slli	a3,a1,0x2
    80005d16:	96ae                	add	a3,a3,a1
    80005d18:	068e                	slli	a3,a3,0x3
    80005d1a:	0001c717          	auipc	a4,0x1c
    80005d1e:	31670713          	addi	a4,a4,790 # 80022030 <timer_scratch>
    80005d22:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005d24:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005d26:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005d28:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005d2c:	fffff797          	auipc	a5,0xfffff
    80005d30:	69478793          	addi	a5,a5,1684 # 800053c0 <timervec>
    80005d34:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005d38:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005d3c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005d40:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005d44:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005d48:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005d4c:	30479073          	csrw	mie,a5
}
    80005d50:	6422                	ld	s0,8(sp)
    80005d52:	0141                	addi	sp,sp,16
    80005d54:	8082                	ret

0000000080005d56 <start>:
{
    80005d56:	1141                	addi	sp,sp,-16
    80005d58:	e406                	sd	ra,8(sp)
    80005d5a:	e022                	sd	s0,0(sp)
    80005d5c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005d5e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005d62:	7779                	lui	a4,0xffffe
    80005d64:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd35b7>
    80005d68:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005d6a:	6705                	lui	a4,0x1
    80005d6c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005d70:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005d72:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005d76:	ffffa797          	auipc	a5,0xffffa
    80005d7a:	74278793          	addi	a5,a5,1858 # 800004b8 <main>
    80005d7e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005d82:	4781                	li	a5,0
    80005d84:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005d88:	67c1                	lui	a5,0x10
    80005d8a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005d8c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005d90:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005d94:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005d98:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005d9c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005da0:	57fd                	li	a5,-1
    80005da2:	83a9                	srli	a5,a5,0xa
    80005da4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005da8:	47bd                	li	a5,15
    80005daa:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	f38080e7          	jalr	-200(ra) # 80005ce6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005db6:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005dba:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005dbc:	823e                	mv	tp,a5
  asm volatile("mret");
    80005dbe:	30200073          	mret
}
    80005dc2:	60a2                	ld	ra,8(sp)
    80005dc4:	6402                	ld	s0,0(sp)
    80005dc6:	0141                	addi	sp,sp,16
    80005dc8:	8082                	ret

0000000080005dca <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005dca:	715d                	addi	sp,sp,-80
    80005dcc:	e486                	sd	ra,72(sp)
    80005dce:	e0a2                	sd	s0,64(sp)
    80005dd0:	fc26                	sd	s1,56(sp)
    80005dd2:	f84a                	sd	s2,48(sp)
    80005dd4:	f44e                	sd	s3,40(sp)
    80005dd6:	f052                	sd	s4,32(sp)
    80005dd8:	ec56                	sd	s5,24(sp)
    80005dda:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005ddc:	04c05763          	blez	a2,80005e2a <consolewrite+0x60>
    80005de0:	8a2a                	mv	s4,a0
    80005de2:	84ae                	mv	s1,a1
    80005de4:	89b2                	mv	s3,a2
    80005de6:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005de8:	5afd                	li	s5,-1
    80005dea:	4685                	li	a3,1
    80005dec:	8626                	mv	a2,s1
    80005dee:	85d2                	mv	a1,s4
    80005df0:	fbf40513          	addi	a0,s0,-65
    80005df4:	ffffc097          	auipc	ra,0xffffc
    80005df8:	cb6080e7          	jalr	-842(ra) # 80001aaa <either_copyin>
    80005dfc:	01550d63          	beq	a0,s5,80005e16 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005e00:	fbf44503          	lbu	a0,-65(s0)
    80005e04:	00000097          	auipc	ra,0x0
    80005e08:	77e080e7          	jalr	1918(ra) # 80006582 <uartputc>
  for(i = 0; i < n; i++){
    80005e0c:	2905                	addiw	s2,s2,1
    80005e0e:	0485                	addi	s1,s1,1
    80005e10:	fd299de3          	bne	s3,s2,80005dea <consolewrite+0x20>
    80005e14:	894e                	mv	s2,s3
  }

  return i;
}
    80005e16:	854a                	mv	a0,s2
    80005e18:	60a6                	ld	ra,72(sp)
    80005e1a:	6406                	ld	s0,64(sp)
    80005e1c:	74e2                	ld	s1,56(sp)
    80005e1e:	7942                	ld	s2,48(sp)
    80005e20:	79a2                	ld	s3,40(sp)
    80005e22:	7a02                	ld	s4,32(sp)
    80005e24:	6ae2                	ld	s5,24(sp)
    80005e26:	6161                	addi	sp,sp,80
    80005e28:	8082                	ret
  for(i = 0; i < n; i++){
    80005e2a:	4901                	li	s2,0
    80005e2c:	b7ed                	j	80005e16 <consolewrite+0x4c>

0000000080005e2e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005e2e:	7159                	addi	sp,sp,-112
    80005e30:	f486                	sd	ra,104(sp)
    80005e32:	f0a2                	sd	s0,96(sp)
    80005e34:	eca6                	sd	s1,88(sp)
    80005e36:	e8ca                	sd	s2,80(sp)
    80005e38:	e4ce                	sd	s3,72(sp)
    80005e3a:	e0d2                	sd	s4,64(sp)
    80005e3c:	fc56                	sd	s5,56(sp)
    80005e3e:	f85a                	sd	s6,48(sp)
    80005e40:	f45e                	sd	s7,40(sp)
    80005e42:	f062                	sd	s8,32(sp)
    80005e44:	ec66                	sd	s9,24(sp)
    80005e46:	e86a                	sd	s10,16(sp)
    80005e48:	1880                	addi	s0,sp,112
    80005e4a:	8aaa                	mv	s5,a0
    80005e4c:	8a2e                	mv	s4,a1
    80005e4e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005e50:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005e54:	00024517          	auipc	a0,0x24
    80005e58:	31c50513          	addi	a0,a0,796 # 8002a170 <cons>
    80005e5c:	00001097          	auipc	ra,0x1
    80005e60:	8ca080e7          	jalr	-1846(ra) # 80006726 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005e64:	00024497          	auipc	s1,0x24
    80005e68:	30c48493          	addi	s1,s1,780 # 8002a170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005e6c:	00024917          	auipc	s2,0x24
    80005e70:	3a490913          	addi	s2,s2,932 # 8002a210 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005e74:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005e76:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005e78:	4ca9                	li	s9,10
  while(n > 0){
    80005e7a:	07305863          	blez	s3,80005eea <consoleread+0xbc>
    while(cons.r == cons.w){
    80005e7e:	0a04a783          	lw	a5,160(s1)
    80005e82:	0a44a703          	lw	a4,164(s1)
    80005e86:	02f71463          	bne	a4,a5,80005eae <consoleread+0x80>
      if(myproc()->killed){
    80005e8a:	ffffb097          	auipc	ra,0xffffb
    80005e8e:	162080e7          	jalr	354(ra) # 80000fec <myproc>
    80005e92:	591c                	lw	a5,48(a0)
    80005e94:	e7b5                	bnez	a5,80005f00 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005e96:	85a6                	mv	a1,s1
    80005e98:	854a                	mv	a0,s2
    80005e9a:	ffffc097          	auipc	ra,0xffffc
    80005e9e:	816080e7          	jalr	-2026(ra) # 800016b0 <sleep>
    while(cons.r == cons.w){
    80005ea2:	0a04a783          	lw	a5,160(s1)
    80005ea6:	0a44a703          	lw	a4,164(s1)
    80005eaa:	fef700e3          	beq	a4,a5,80005e8a <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005eae:	0017871b          	addiw	a4,a5,1
    80005eb2:	0ae4a023          	sw	a4,160(s1)
    80005eb6:	07f7f713          	andi	a4,a5,127
    80005eba:	9726                	add	a4,a4,s1
    80005ebc:	02074703          	lbu	a4,32(a4)
    80005ec0:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005ec4:	077d0563          	beq	s10,s7,80005f2e <consoleread+0x100>
    cbuf = c;
    80005ec8:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005ecc:	4685                	li	a3,1
    80005ece:	f9f40613          	addi	a2,s0,-97
    80005ed2:	85d2                	mv	a1,s4
    80005ed4:	8556                	mv	a0,s5
    80005ed6:	ffffc097          	auipc	ra,0xffffc
    80005eda:	b7e080e7          	jalr	-1154(ra) # 80001a54 <either_copyout>
    80005ede:	01850663          	beq	a0,s8,80005eea <consoleread+0xbc>
    dst++;
    80005ee2:	0a05                	addi	s4,s4,1
    --n;
    80005ee4:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005ee6:	f99d1ae3          	bne	s10,s9,80005e7a <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005eea:	00024517          	auipc	a0,0x24
    80005eee:	28650513          	addi	a0,a0,646 # 8002a170 <cons>
    80005ef2:	00001097          	auipc	ra,0x1
    80005ef6:	904080e7          	jalr	-1788(ra) # 800067f6 <release>

  return target - n;
    80005efa:	413b053b          	subw	a0,s6,s3
    80005efe:	a811                	j	80005f12 <consoleread+0xe4>
        release(&cons.lock);
    80005f00:	00024517          	auipc	a0,0x24
    80005f04:	27050513          	addi	a0,a0,624 # 8002a170 <cons>
    80005f08:	00001097          	auipc	ra,0x1
    80005f0c:	8ee080e7          	jalr	-1810(ra) # 800067f6 <release>
        return -1;
    80005f10:	557d                	li	a0,-1
}
    80005f12:	70a6                	ld	ra,104(sp)
    80005f14:	7406                	ld	s0,96(sp)
    80005f16:	64e6                	ld	s1,88(sp)
    80005f18:	6946                	ld	s2,80(sp)
    80005f1a:	69a6                	ld	s3,72(sp)
    80005f1c:	6a06                	ld	s4,64(sp)
    80005f1e:	7ae2                	ld	s5,56(sp)
    80005f20:	7b42                	ld	s6,48(sp)
    80005f22:	7ba2                	ld	s7,40(sp)
    80005f24:	7c02                	ld	s8,32(sp)
    80005f26:	6ce2                	ld	s9,24(sp)
    80005f28:	6d42                	ld	s10,16(sp)
    80005f2a:	6165                	addi	sp,sp,112
    80005f2c:	8082                	ret
      if(n < target){
    80005f2e:	0009871b          	sext.w	a4,s3
    80005f32:	fb677ce3          	bgeu	a4,s6,80005eea <consoleread+0xbc>
        cons.r--;
    80005f36:	00024717          	auipc	a4,0x24
    80005f3a:	2cf72d23          	sw	a5,730(a4) # 8002a210 <cons+0xa0>
    80005f3e:	b775                	j	80005eea <consoleread+0xbc>

0000000080005f40 <consputc>:
{
    80005f40:	1141                	addi	sp,sp,-16
    80005f42:	e406                	sd	ra,8(sp)
    80005f44:	e022                	sd	s0,0(sp)
    80005f46:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005f48:	10000793          	li	a5,256
    80005f4c:	00f50a63          	beq	a0,a5,80005f60 <consputc+0x20>
    uartputc_sync(c);
    80005f50:	00000097          	auipc	ra,0x0
    80005f54:	560080e7          	jalr	1376(ra) # 800064b0 <uartputc_sync>
}
    80005f58:	60a2                	ld	ra,8(sp)
    80005f5a:	6402                	ld	s0,0(sp)
    80005f5c:	0141                	addi	sp,sp,16
    80005f5e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005f60:	4521                	li	a0,8
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	54e080e7          	jalr	1358(ra) # 800064b0 <uartputc_sync>
    80005f6a:	02000513          	li	a0,32
    80005f6e:	00000097          	auipc	ra,0x0
    80005f72:	542080e7          	jalr	1346(ra) # 800064b0 <uartputc_sync>
    80005f76:	4521                	li	a0,8
    80005f78:	00000097          	auipc	ra,0x0
    80005f7c:	538080e7          	jalr	1336(ra) # 800064b0 <uartputc_sync>
    80005f80:	bfe1                	j	80005f58 <consputc+0x18>

0000000080005f82 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005f82:	1101                	addi	sp,sp,-32
    80005f84:	ec06                	sd	ra,24(sp)
    80005f86:	e822                	sd	s0,16(sp)
    80005f88:	e426                	sd	s1,8(sp)
    80005f8a:	e04a                	sd	s2,0(sp)
    80005f8c:	1000                	addi	s0,sp,32
    80005f8e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005f90:	00024517          	auipc	a0,0x24
    80005f94:	1e050513          	addi	a0,a0,480 # 8002a170 <cons>
    80005f98:	00000097          	auipc	ra,0x0
    80005f9c:	78e080e7          	jalr	1934(ra) # 80006726 <acquire>

  switch(c){
    80005fa0:	47d5                	li	a5,21
    80005fa2:	0af48663          	beq	s1,a5,8000604e <consoleintr+0xcc>
    80005fa6:	0297ca63          	blt	a5,s1,80005fda <consoleintr+0x58>
    80005faa:	47a1                	li	a5,8
    80005fac:	0ef48763          	beq	s1,a5,8000609a <consoleintr+0x118>
    80005fb0:	47c1                	li	a5,16
    80005fb2:	10f49a63          	bne	s1,a5,800060c6 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005fb6:	ffffc097          	auipc	ra,0xffffc
    80005fba:	b4a080e7          	jalr	-1206(ra) # 80001b00 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005fbe:	00024517          	auipc	a0,0x24
    80005fc2:	1b250513          	addi	a0,a0,434 # 8002a170 <cons>
    80005fc6:	00001097          	auipc	ra,0x1
    80005fca:	830080e7          	jalr	-2000(ra) # 800067f6 <release>
}
    80005fce:	60e2                	ld	ra,24(sp)
    80005fd0:	6442                	ld	s0,16(sp)
    80005fd2:	64a2                	ld	s1,8(sp)
    80005fd4:	6902                	ld	s2,0(sp)
    80005fd6:	6105                	addi	sp,sp,32
    80005fd8:	8082                	ret
  switch(c){
    80005fda:	07f00793          	li	a5,127
    80005fde:	0af48e63          	beq	s1,a5,8000609a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005fe2:	00024717          	auipc	a4,0x24
    80005fe6:	18e70713          	addi	a4,a4,398 # 8002a170 <cons>
    80005fea:	0a872783          	lw	a5,168(a4)
    80005fee:	0a072703          	lw	a4,160(a4)
    80005ff2:	9f99                	subw	a5,a5,a4
    80005ff4:	07f00713          	li	a4,127
    80005ff8:	fcf763e3          	bltu	a4,a5,80005fbe <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005ffc:	47b5                	li	a5,13
    80005ffe:	0cf48763          	beq	s1,a5,800060cc <consoleintr+0x14a>
      consputc(c);
    80006002:	8526                	mv	a0,s1
    80006004:	00000097          	auipc	ra,0x0
    80006008:	f3c080e7          	jalr	-196(ra) # 80005f40 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000600c:	00024797          	auipc	a5,0x24
    80006010:	16478793          	addi	a5,a5,356 # 8002a170 <cons>
    80006014:	0a87a703          	lw	a4,168(a5)
    80006018:	0017069b          	addiw	a3,a4,1
    8000601c:	0006861b          	sext.w	a2,a3
    80006020:	0ad7a423          	sw	a3,168(a5)
    80006024:	07f77713          	andi	a4,a4,127
    80006028:	97ba                	add	a5,a5,a4
    8000602a:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000602e:	47a9                	li	a5,10
    80006030:	0cf48563          	beq	s1,a5,800060fa <consoleintr+0x178>
    80006034:	4791                	li	a5,4
    80006036:	0cf48263          	beq	s1,a5,800060fa <consoleintr+0x178>
    8000603a:	00024797          	auipc	a5,0x24
    8000603e:	1d67a783          	lw	a5,470(a5) # 8002a210 <cons+0xa0>
    80006042:	0807879b          	addiw	a5,a5,128
    80006046:	f6f61ce3          	bne	a2,a5,80005fbe <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000604a:	863e                	mv	a2,a5
    8000604c:	a07d                	j	800060fa <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000604e:	00024717          	auipc	a4,0x24
    80006052:	12270713          	addi	a4,a4,290 # 8002a170 <cons>
    80006056:	0a872783          	lw	a5,168(a4)
    8000605a:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    8000605e:	00024497          	auipc	s1,0x24
    80006062:	11248493          	addi	s1,s1,274 # 8002a170 <cons>
    while(cons.e != cons.w &&
    80006066:	4929                	li	s2,10
    80006068:	f4f70be3          	beq	a4,a5,80005fbe <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    8000606c:	37fd                	addiw	a5,a5,-1
    8000606e:	07f7f713          	andi	a4,a5,127
    80006072:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80006074:	02074703          	lbu	a4,32(a4)
    80006078:	f52703e3          	beq	a4,s2,80005fbe <consoleintr+0x3c>
      cons.e--;
    8000607c:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    80006080:	10000513          	li	a0,256
    80006084:	00000097          	auipc	ra,0x0
    80006088:	ebc080e7          	jalr	-324(ra) # 80005f40 <consputc>
    while(cons.e != cons.w &&
    8000608c:	0a84a783          	lw	a5,168(s1)
    80006090:	0a44a703          	lw	a4,164(s1)
    80006094:	fcf71ce3          	bne	a4,a5,8000606c <consoleintr+0xea>
    80006098:	b71d                	j	80005fbe <consoleintr+0x3c>
    if(cons.e != cons.w){
    8000609a:	00024717          	auipc	a4,0x24
    8000609e:	0d670713          	addi	a4,a4,214 # 8002a170 <cons>
    800060a2:	0a872783          	lw	a5,168(a4)
    800060a6:	0a472703          	lw	a4,164(a4)
    800060aa:	f0f70ae3          	beq	a4,a5,80005fbe <consoleintr+0x3c>
      cons.e--;
    800060ae:	37fd                	addiw	a5,a5,-1
    800060b0:	00024717          	auipc	a4,0x24
    800060b4:	16f72423          	sw	a5,360(a4) # 8002a218 <cons+0xa8>
      consputc(BACKSPACE);
    800060b8:	10000513          	li	a0,256
    800060bc:	00000097          	auipc	ra,0x0
    800060c0:	e84080e7          	jalr	-380(ra) # 80005f40 <consputc>
    800060c4:	bded                	j	80005fbe <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800060c6:	ee048ce3          	beqz	s1,80005fbe <consoleintr+0x3c>
    800060ca:	bf21                	j	80005fe2 <consoleintr+0x60>
      consputc(c);
    800060cc:	4529                	li	a0,10
    800060ce:	00000097          	auipc	ra,0x0
    800060d2:	e72080e7          	jalr	-398(ra) # 80005f40 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800060d6:	00024797          	auipc	a5,0x24
    800060da:	09a78793          	addi	a5,a5,154 # 8002a170 <cons>
    800060de:	0a87a703          	lw	a4,168(a5)
    800060e2:	0017069b          	addiw	a3,a4,1
    800060e6:	0006861b          	sext.w	a2,a3
    800060ea:	0ad7a423          	sw	a3,168(a5)
    800060ee:	07f77713          	andi	a4,a4,127
    800060f2:	97ba                	add	a5,a5,a4
    800060f4:	4729                	li	a4,10
    800060f6:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    800060fa:	00024797          	auipc	a5,0x24
    800060fe:	10c7ad23          	sw	a2,282(a5) # 8002a214 <cons+0xa4>
        wakeup(&cons.r);
    80006102:	00024517          	auipc	a0,0x24
    80006106:	10e50513          	addi	a0,a0,270 # 8002a210 <cons+0xa0>
    8000610a:	ffffb097          	auipc	ra,0xffffb
    8000610e:	732080e7          	jalr	1842(ra) # 8000183c <wakeup>
    80006112:	b575                	j	80005fbe <consoleintr+0x3c>

0000000080006114 <consoleinit>:

void
consoleinit(void)
{
    80006114:	1141                	addi	sp,sp,-16
    80006116:	e406                	sd	ra,8(sp)
    80006118:	e022                	sd	s0,0(sp)
    8000611a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000611c:	00002597          	auipc	a1,0x2
    80006120:	6d458593          	addi	a1,a1,1748 # 800087f0 <digits+0x18>
    80006124:	00024517          	auipc	a0,0x24
    80006128:	04c50513          	addi	a0,a0,76 # 8002a170 <cons>
    8000612c:	00000097          	auipc	ra,0x0
    80006130:	776080e7          	jalr	1910(ra) # 800068a2 <initlock>

  uartinit();
    80006134:	00000097          	auipc	ra,0x0
    80006138:	32c080e7          	jalr	812(ra) # 80006460 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000613c:	00017797          	auipc	a5,0x17
    80006140:	bec78793          	addi	a5,a5,-1044 # 8001cd28 <devsw>
    80006144:	00000717          	auipc	a4,0x0
    80006148:	cea70713          	addi	a4,a4,-790 # 80005e2e <consoleread>
    8000614c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000614e:	00000717          	auipc	a4,0x0
    80006152:	c7c70713          	addi	a4,a4,-900 # 80005dca <consolewrite>
    80006156:	ef98                	sd	a4,24(a5)
}
    80006158:	60a2                	ld	ra,8(sp)
    8000615a:	6402                	ld	s0,0(sp)
    8000615c:	0141                	addi	sp,sp,16
    8000615e:	8082                	ret

0000000080006160 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006160:	7179                	addi	sp,sp,-48
    80006162:	f406                	sd	ra,40(sp)
    80006164:	f022                	sd	s0,32(sp)
    80006166:	ec26                	sd	s1,24(sp)
    80006168:	e84a                	sd	s2,16(sp)
    8000616a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    8000616c:	c219                	beqz	a2,80006172 <printint+0x12>
    8000616e:	08054763          	bltz	a0,800061fc <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80006172:	2501                	sext.w	a0,a0
    80006174:	4881                	li	a7,0
    80006176:	fd040693          	addi	a3,s0,-48

  i = 0;
    8000617a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000617c:	2581                	sext.w	a1,a1
    8000617e:	00002617          	auipc	a2,0x2
    80006182:	68a60613          	addi	a2,a2,1674 # 80008808 <digits>
    80006186:	883a                	mv	a6,a4
    80006188:	2705                	addiw	a4,a4,1
    8000618a:	02b577bb          	remuw	a5,a0,a1
    8000618e:	1782                	slli	a5,a5,0x20
    80006190:	9381                	srli	a5,a5,0x20
    80006192:	97b2                	add	a5,a5,a2
    80006194:	0007c783          	lbu	a5,0(a5)
    80006198:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000619c:	0005079b          	sext.w	a5,a0
    800061a0:	02b5553b          	divuw	a0,a0,a1
    800061a4:	0685                	addi	a3,a3,1
    800061a6:	feb7f0e3          	bgeu	a5,a1,80006186 <printint+0x26>

  if(sign)
    800061aa:	00088c63          	beqz	a7,800061c2 <printint+0x62>
    buf[i++] = '-';
    800061ae:	fe070793          	addi	a5,a4,-32
    800061b2:	00878733          	add	a4,a5,s0
    800061b6:	02d00793          	li	a5,45
    800061ba:	fef70823          	sb	a5,-16(a4)
    800061be:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800061c2:	02e05763          	blez	a4,800061f0 <printint+0x90>
    800061c6:	fd040793          	addi	a5,s0,-48
    800061ca:	00e784b3          	add	s1,a5,a4
    800061ce:	fff78913          	addi	s2,a5,-1
    800061d2:	993a                	add	s2,s2,a4
    800061d4:	377d                	addiw	a4,a4,-1
    800061d6:	1702                	slli	a4,a4,0x20
    800061d8:	9301                	srli	a4,a4,0x20
    800061da:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800061de:	fff4c503          	lbu	a0,-1(s1)
    800061e2:	00000097          	auipc	ra,0x0
    800061e6:	d5e080e7          	jalr	-674(ra) # 80005f40 <consputc>
  while(--i >= 0)
    800061ea:	14fd                	addi	s1,s1,-1
    800061ec:	ff2499e3          	bne	s1,s2,800061de <printint+0x7e>
}
    800061f0:	70a2                	ld	ra,40(sp)
    800061f2:	7402                	ld	s0,32(sp)
    800061f4:	64e2                	ld	s1,24(sp)
    800061f6:	6942                	ld	s2,16(sp)
    800061f8:	6145                	addi	sp,sp,48
    800061fa:	8082                	ret
    x = -xx;
    800061fc:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006200:	4885                	li	a7,1
    x = -xx;
    80006202:	bf95                	j	80006176 <printint+0x16>

0000000080006204 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006204:	1101                	addi	sp,sp,-32
    80006206:	ec06                	sd	ra,24(sp)
    80006208:	e822                	sd	s0,16(sp)
    8000620a:	e426                	sd	s1,8(sp)
    8000620c:	1000                	addi	s0,sp,32
    8000620e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006210:	00024797          	auipc	a5,0x24
    80006214:	0207a823          	sw	zero,48(a5) # 8002a240 <pr+0x20>
  printf("panic: ");
    80006218:	00002517          	auipc	a0,0x2
    8000621c:	5e050513          	addi	a0,a0,1504 # 800087f8 <digits+0x20>
    80006220:	00000097          	auipc	ra,0x0
    80006224:	02e080e7          	jalr	46(ra) # 8000624e <printf>
  printf(s);
    80006228:	8526                	mv	a0,s1
    8000622a:	00000097          	auipc	ra,0x0
    8000622e:	024080e7          	jalr	36(ra) # 8000624e <printf>
  printf("\n");
    80006232:	00002517          	auipc	a0,0x2
    80006236:	65e50513          	addi	a0,a0,1630 # 80008890 <digits+0x88>
    8000623a:	00000097          	auipc	ra,0x0
    8000623e:	014080e7          	jalr	20(ra) # 8000624e <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006242:	4785                	li	a5,1
    80006244:	00003717          	auipc	a4,0x3
    80006248:	dcf72c23          	sw	a5,-552(a4) # 8000901c <panicked>
  for(;;)
    8000624c:	a001                	j	8000624c <panic+0x48>

000000008000624e <printf>:
{
    8000624e:	7131                	addi	sp,sp,-192
    80006250:	fc86                	sd	ra,120(sp)
    80006252:	f8a2                	sd	s0,112(sp)
    80006254:	f4a6                	sd	s1,104(sp)
    80006256:	f0ca                	sd	s2,96(sp)
    80006258:	ecce                	sd	s3,88(sp)
    8000625a:	e8d2                	sd	s4,80(sp)
    8000625c:	e4d6                	sd	s5,72(sp)
    8000625e:	e0da                	sd	s6,64(sp)
    80006260:	fc5e                	sd	s7,56(sp)
    80006262:	f862                	sd	s8,48(sp)
    80006264:	f466                	sd	s9,40(sp)
    80006266:	f06a                	sd	s10,32(sp)
    80006268:	ec6e                	sd	s11,24(sp)
    8000626a:	0100                	addi	s0,sp,128
    8000626c:	8a2a                	mv	s4,a0
    8000626e:	e40c                	sd	a1,8(s0)
    80006270:	e810                	sd	a2,16(s0)
    80006272:	ec14                	sd	a3,24(s0)
    80006274:	f018                	sd	a4,32(s0)
    80006276:	f41c                	sd	a5,40(s0)
    80006278:	03043823          	sd	a6,48(s0)
    8000627c:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006280:	00024d97          	auipc	s11,0x24
    80006284:	fc0dad83          	lw	s11,-64(s11) # 8002a240 <pr+0x20>
  if(locking)
    80006288:	020d9b63          	bnez	s11,800062be <printf+0x70>
  if (fmt == 0)
    8000628c:	040a0263          	beqz	s4,800062d0 <printf+0x82>
  va_start(ap, fmt);
    80006290:	00840793          	addi	a5,s0,8
    80006294:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006298:	000a4503          	lbu	a0,0(s4)
    8000629c:	14050f63          	beqz	a0,800063fa <printf+0x1ac>
    800062a0:	4981                	li	s3,0
    if(c != '%'){
    800062a2:	02500a93          	li	s5,37
    switch(c){
    800062a6:	07000b93          	li	s7,112
  consputc('x');
    800062aa:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800062ac:	00002b17          	auipc	s6,0x2
    800062b0:	55cb0b13          	addi	s6,s6,1372 # 80008808 <digits>
    switch(c){
    800062b4:	07300c93          	li	s9,115
    800062b8:	06400c13          	li	s8,100
    800062bc:	a82d                	j	800062f6 <printf+0xa8>
    acquire(&pr.lock);
    800062be:	00024517          	auipc	a0,0x24
    800062c2:	f6250513          	addi	a0,a0,-158 # 8002a220 <pr>
    800062c6:	00000097          	auipc	ra,0x0
    800062ca:	460080e7          	jalr	1120(ra) # 80006726 <acquire>
    800062ce:	bf7d                	j	8000628c <printf+0x3e>
    panic("null fmt");
    800062d0:	00002517          	auipc	a0,0x2
    800062d4:	4f850513          	addi	a0,a0,1272 # 800087c8 <syscalls+0x3f8>
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	f2c080e7          	jalr	-212(ra) # 80006204 <panic>
      consputc(c);
    800062e0:	00000097          	auipc	ra,0x0
    800062e4:	c60080e7          	jalr	-928(ra) # 80005f40 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800062e8:	2985                	addiw	s3,s3,1
    800062ea:	013a07b3          	add	a5,s4,s3
    800062ee:	0007c503          	lbu	a0,0(a5)
    800062f2:	10050463          	beqz	a0,800063fa <printf+0x1ac>
    if(c != '%'){
    800062f6:	ff5515e3          	bne	a0,s5,800062e0 <printf+0x92>
    c = fmt[++i] & 0xff;
    800062fa:	2985                	addiw	s3,s3,1
    800062fc:	013a07b3          	add	a5,s4,s3
    80006300:	0007c783          	lbu	a5,0(a5)
    80006304:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006308:	cbed                	beqz	a5,800063fa <printf+0x1ac>
    switch(c){
    8000630a:	05778a63          	beq	a5,s7,8000635e <printf+0x110>
    8000630e:	02fbf663          	bgeu	s7,a5,8000633a <printf+0xec>
    80006312:	09978863          	beq	a5,s9,800063a2 <printf+0x154>
    80006316:	07800713          	li	a4,120
    8000631a:	0ce79563          	bne	a5,a4,800063e4 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000631e:	f8843783          	ld	a5,-120(s0)
    80006322:	00878713          	addi	a4,a5,8
    80006326:	f8e43423          	sd	a4,-120(s0)
    8000632a:	4605                	li	a2,1
    8000632c:	85ea                	mv	a1,s10
    8000632e:	4388                	lw	a0,0(a5)
    80006330:	00000097          	auipc	ra,0x0
    80006334:	e30080e7          	jalr	-464(ra) # 80006160 <printint>
      break;
    80006338:	bf45                	j	800062e8 <printf+0x9a>
    switch(c){
    8000633a:	09578f63          	beq	a5,s5,800063d8 <printf+0x18a>
    8000633e:	0b879363          	bne	a5,s8,800063e4 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80006342:	f8843783          	ld	a5,-120(s0)
    80006346:	00878713          	addi	a4,a5,8
    8000634a:	f8e43423          	sd	a4,-120(s0)
    8000634e:	4605                	li	a2,1
    80006350:	45a9                	li	a1,10
    80006352:	4388                	lw	a0,0(a5)
    80006354:	00000097          	auipc	ra,0x0
    80006358:	e0c080e7          	jalr	-500(ra) # 80006160 <printint>
      break;
    8000635c:	b771                	j	800062e8 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000635e:	f8843783          	ld	a5,-120(s0)
    80006362:	00878713          	addi	a4,a5,8
    80006366:	f8e43423          	sd	a4,-120(s0)
    8000636a:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000636e:	03000513          	li	a0,48
    80006372:	00000097          	auipc	ra,0x0
    80006376:	bce080e7          	jalr	-1074(ra) # 80005f40 <consputc>
  consputc('x');
    8000637a:	07800513          	li	a0,120
    8000637e:	00000097          	auipc	ra,0x0
    80006382:	bc2080e7          	jalr	-1086(ra) # 80005f40 <consputc>
    80006386:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006388:	03c95793          	srli	a5,s2,0x3c
    8000638c:	97da                	add	a5,a5,s6
    8000638e:	0007c503          	lbu	a0,0(a5)
    80006392:	00000097          	auipc	ra,0x0
    80006396:	bae080e7          	jalr	-1106(ra) # 80005f40 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000639a:	0912                	slli	s2,s2,0x4
    8000639c:	34fd                	addiw	s1,s1,-1
    8000639e:	f4ed                	bnez	s1,80006388 <printf+0x13a>
    800063a0:	b7a1                	j	800062e8 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800063a2:	f8843783          	ld	a5,-120(s0)
    800063a6:	00878713          	addi	a4,a5,8
    800063aa:	f8e43423          	sd	a4,-120(s0)
    800063ae:	6384                	ld	s1,0(a5)
    800063b0:	cc89                	beqz	s1,800063ca <printf+0x17c>
      for(; *s; s++)
    800063b2:	0004c503          	lbu	a0,0(s1)
    800063b6:	d90d                	beqz	a0,800062e8 <printf+0x9a>
        consputc(*s);
    800063b8:	00000097          	auipc	ra,0x0
    800063bc:	b88080e7          	jalr	-1144(ra) # 80005f40 <consputc>
      for(; *s; s++)
    800063c0:	0485                	addi	s1,s1,1
    800063c2:	0004c503          	lbu	a0,0(s1)
    800063c6:	f96d                	bnez	a0,800063b8 <printf+0x16a>
    800063c8:	b705                	j	800062e8 <printf+0x9a>
        s = "(null)";
    800063ca:	00002497          	auipc	s1,0x2
    800063ce:	3f648493          	addi	s1,s1,1014 # 800087c0 <syscalls+0x3f0>
      for(; *s; s++)
    800063d2:	02800513          	li	a0,40
    800063d6:	b7cd                	j	800063b8 <printf+0x16a>
      consputc('%');
    800063d8:	8556                	mv	a0,s5
    800063da:	00000097          	auipc	ra,0x0
    800063de:	b66080e7          	jalr	-1178(ra) # 80005f40 <consputc>
      break;
    800063e2:	b719                	j	800062e8 <printf+0x9a>
      consputc('%');
    800063e4:	8556                	mv	a0,s5
    800063e6:	00000097          	auipc	ra,0x0
    800063ea:	b5a080e7          	jalr	-1190(ra) # 80005f40 <consputc>
      consputc(c);
    800063ee:	8526                	mv	a0,s1
    800063f0:	00000097          	auipc	ra,0x0
    800063f4:	b50080e7          	jalr	-1200(ra) # 80005f40 <consputc>
      break;
    800063f8:	bdc5                	j	800062e8 <printf+0x9a>
  if(locking)
    800063fa:	020d9163          	bnez	s11,8000641c <printf+0x1ce>
}
    800063fe:	70e6                	ld	ra,120(sp)
    80006400:	7446                	ld	s0,112(sp)
    80006402:	74a6                	ld	s1,104(sp)
    80006404:	7906                	ld	s2,96(sp)
    80006406:	69e6                	ld	s3,88(sp)
    80006408:	6a46                	ld	s4,80(sp)
    8000640a:	6aa6                	ld	s5,72(sp)
    8000640c:	6b06                	ld	s6,64(sp)
    8000640e:	7be2                	ld	s7,56(sp)
    80006410:	7c42                	ld	s8,48(sp)
    80006412:	7ca2                	ld	s9,40(sp)
    80006414:	7d02                	ld	s10,32(sp)
    80006416:	6de2                	ld	s11,24(sp)
    80006418:	6129                	addi	sp,sp,192
    8000641a:	8082                	ret
    release(&pr.lock);
    8000641c:	00024517          	auipc	a0,0x24
    80006420:	e0450513          	addi	a0,a0,-508 # 8002a220 <pr>
    80006424:	00000097          	auipc	ra,0x0
    80006428:	3d2080e7          	jalr	978(ra) # 800067f6 <release>
}
    8000642c:	bfc9                	j	800063fe <printf+0x1b0>

000000008000642e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000642e:	1101                	addi	sp,sp,-32
    80006430:	ec06                	sd	ra,24(sp)
    80006432:	e822                	sd	s0,16(sp)
    80006434:	e426                	sd	s1,8(sp)
    80006436:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006438:	00024497          	auipc	s1,0x24
    8000643c:	de848493          	addi	s1,s1,-536 # 8002a220 <pr>
    80006440:	00002597          	auipc	a1,0x2
    80006444:	3c058593          	addi	a1,a1,960 # 80008800 <digits+0x28>
    80006448:	8526                	mv	a0,s1
    8000644a:	00000097          	auipc	ra,0x0
    8000644e:	458080e7          	jalr	1112(ra) # 800068a2 <initlock>
  pr.locking = 1;
    80006452:	4785                	li	a5,1
    80006454:	d09c                	sw	a5,32(s1)
}
    80006456:	60e2                	ld	ra,24(sp)
    80006458:	6442                	ld	s0,16(sp)
    8000645a:	64a2                	ld	s1,8(sp)
    8000645c:	6105                	addi	sp,sp,32
    8000645e:	8082                	ret

0000000080006460 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006460:	1141                	addi	sp,sp,-16
    80006462:	e406                	sd	ra,8(sp)
    80006464:	e022                	sd	s0,0(sp)
    80006466:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006468:	100007b7          	lui	a5,0x10000
    8000646c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006470:	f8000713          	li	a4,-128
    80006474:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006478:	470d                	li	a4,3
    8000647a:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000647e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006482:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006486:	469d                	li	a3,7
    80006488:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000648c:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006490:	00002597          	auipc	a1,0x2
    80006494:	39058593          	addi	a1,a1,912 # 80008820 <digits+0x18>
    80006498:	00024517          	auipc	a0,0x24
    8000649c:	db050513          	addi	a0,a0,-592 # 8002a248 <uart_tx_lock>
    800064a0:	00000097          	auipc	ra,0x0
    800064a4:	402080e7          	jalr	1026(ra) # 800068a2 <initlock>
}
    800064a8:	60a2                	ld	ra,8(sp)
    800064aa:	6402                	ld	s0,0(sp)
    800064ac:	0141                	addi	sp,sp,16
    800064ae:	8082                	ret

00000000800064b0 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800064b0:	1101                	addi	sp,sp,-32
    800064b2:	ec06                	sd	ra,24(sp)
    800064b4:	e822                	sd	s0,16(sp)
    800064b6:	e426                	sd	s1,8(sp)
    800064b8:	1000                	addi	s0,sp,32
    800064ba:	84aa                	mv	s1,a0
  push_off();
    800064bc:	00000097          	auipc	ra,0x0
    800064c0:	21e080e7          	jalr	542(ra) # 800066da <push_off>

  if(panicked){
    800064c4:	00003797          	auipc	a5,0x3
    800064c8:	b587a783          	lw	a5,-1192(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800064cc:	10000737          	lui	a4,0x10000
  if(panicked){
    800064d0:	c391                	beqz	a5,800064d4 <uartputc_sync+0x24>
    for(;;)
    800064d2:	a001                	j	800064d2 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800064d4:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800064d8:	0207f793          	andi	a5,a5,32
    800064dc:	dfe5                	beqz	a5,800064d4 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800064de:	0ff4f513          	zext.b	a0,s1
    800064e2:	100007b7          	lui	a5,0x10000
    800064e6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800064ea:	00000097          	auipc	ra,0x0
    800064ee:	2ac080e7          	jalr	684(ra) # 80006796 <pop_off>
}
    800064f2:	60e2                	ld	ra,24(sp)
    800064f4:	6442                	ld	s0,16(sp)
    800064f6:	64a2                	ld	s1,8(sp)
    800064f8:	6105                	addi	sp,sp,32
    800064fa:	8082                	ret

00000000800064fc <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800064fc:	00003797          	auipc	a5,0x3
    80006500:	b247b783          	ld	a5,-1244(a5) # 80009020 <uart_tx_r>
    80006504:	00003717          	auipc	a4,0x3
    80006508:	b2473703          	ld	a4,-1244(a4) # 80009028 <uart_tx_w>
    8000650c:	06f70a63          	beq	a4,a5,80006580 <uartstart+0x84>
{
    80006510:	7139                	addi	sp,sp,-64
    80006512:	fc06                	sd	ra,56(sp)
    80006514:	f822                	sd	s0,48(sp)
    80006516:	f426                	sd	s1,40(sp)
    80006518:	f04a                	sd	s2,32(sp)
    8000651a:	ec4e                	sd	s3,24(sp)
    8000651c:	e852                	sd	s4,16(sp)
    8000651e:	e456                	sd	s5,8(sp)
    80006520:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006522:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006526:	00024a17          	auipc	s4,0x24
    8000652a:	d22a0a13          	addi	s4,s4,-734 # 8002a248 <uart_tx_lock>
    uart_tx_r += 1;
    8000652e:	00003497          	auipc	s1,0x3
    80006532:	af248493          	addi	s1,s1,-1294 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006536:	00003997          	auipc	s3,0x3
    8000653a:	af298993          	addi	s3,s3,-1294 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000653e:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006542:	02077713          	andi	a4,a4,32
    80006546:	c705                	beqz	a4,8000656e <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006548:	01f7f713          	andi	a4,a5,31
    8000654c:	9752                	add	a4,a4,s4
    8000654e:	02074a83          	lbu	s5,32(a4)
    uart_tx_r += 1;
    80006552:	0785                	addi	a5,a5,1
    80006554:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006556:	8526                	mv	a0,s1
    80006558:	ffffb097          	auipc	ra,0xffffb
    8000655c:	2e4080e7          	jalr	740(ra) # 8000183c <wakeup>
    
    WriteReg(THR, c);
    80006560:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006564:	609c                	ld	a5,0(s1)
    80006566:	0009b703          	ld	a4,0(s3)
    8000656a:	fcf71ae3          	bne	a4,a5,8000653e <uartstart+0x42>
  }
}
    8000656e:	70e2                	ld	ra,56(sp)
    80006570:	7442                	ld	s0,48(sp)
    80006572:	74a2                	ld	s1,40(sp)
    80006574:	7902                	ld	s2,32(sp)
    80006576:	69e2                	ld	s3,24(sp)
    80006578:	6a42                	ld	s4,16(sp)
    8000657a:	6aa2                	ld	s5,8(sp)
    8000657c:	6121                	addi	sp,sp,64
    8000657e:	8082                	ret
    80006580:	8082                	ret

0000000080006582 <uartputc>:
{
    80006582:	7179                	addi	sp,sp,-48
    80006584:	f406                	sd	ra,40(sp)
    80006586:	f022                	sd	s0,32(sp)
    80006588:	ec26                	sd	s1,24(sp)
    8000658a:	e84a                	sd	s2,16(sp)
    8000658c:	e44e                	sd	s3,8(sp)
    8000658e:	e052                	sd	s4,0(sp)
    80006590:	1800                	addi	s0,sp,48
    80006592:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006594:	00024517          	auipc	a0,0x24
    80006598:	cb450513          	addi	a0,a0,-844 # 8002a248 <uart_tx_lock>
    8000659c:	00000097          	auipc	ra,0x0
    800065a0:	18a080e7          	jalr	394(ra) # 80006726 <acquire>
  if(panicked){
    800065a4:	00003797          	auipc	a5,0x3
    800065a8:	a787a783          	lw	a5,-1416(a5) # 8000901c <panicked>
    800065ac:	c391                	beqz	a5,800065b0 <uartputc+0x2e>
    for(;;)
    800065ae:	a001                	j	800065ae <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800065b0:	00003717          	auipc	a4,0x3
    800065b4:	a7873703          	ld	a4,-1416(a4) # 80009028 <uart_tx_w>
    800065b8:	00003797          	auipc	a5,0x3
    800065bc:	a687b783          	ld	a5,-1432(a5) # 80009020 <uart_tx_r>
    800065c0:	02078793          	addi	a5,a5,32
    800065c4:	02e79b63          	bne	a5,a4,800065fa <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800065c8:	00024997          	auipc	s3,0x24
    800065cc:	c8098993          	addi	s3,s3,-896 # 8002a248 <uart_tx_lock>
    800065d0:	00003497          	auipc	s1,0x3
    800065d4:	a5048493          	addi	s1,s1,-1456 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800065d8:	00003917          	auipc	s2,0x3
    800065dc:	a5090913          	addi	s2,s2,-1456 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800065e0:	85ce                	mv	a1,s3
    800065e2:	8526                	mv	a0,s1
    800065e4:	ffffb097          	auipc	ra,0xffffb
    800065e8:	0cc080e7          	jalr	204(ra) # 800016b0 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800065ec:	00093703          	ld	a4,0(s2)
    800065f0:	609c                	ld	a5,0(s1)
    800065f2:	02078793          	addi	a5,a5,32
    800065f6:	fee785e3          	beq	a5,a4,800065e0 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800065fa:	00024497          	auipc	s1,0x24
    800065fe:	c4e48493          	addi	s1,s1,-946 # 8002a248 <uart_tx_lock>
    80006602:	01f77793          	andi	a5,a4,31
    80006606:	97a6                	add	a5,a5,s1
    80006608:	03478023          	sb	s4,32(a5)
      uart_tx_w += 1;
    8000660c:	0705                	addi	a4,a4,1
    8000660e:	00003797          	auipc	a5,0x3
    80006612:	a0e7bd23          	sd	a4,-1510(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006616:	00000097          	auipc	ra,0x0
    8000661a:	ee6080e7          	jalr	-282(ra) # 800064fc <uartstart>
      release(&uart_tx_lock);
    8000661e:	8526                	mv	a0,s1
    80006620:	00000097          	auipc	ra,0x0
    80006624:	1d6080e7          	jalr	470(ra) # 800067f6 <release>
}
    80006628:	70a2                	ld	ra,40(sp)
    8000662a:	7402                	ld	s0,32(sp)
    8000662c:	64e2                	ld	s1,24(sp)
    8000662e:	6942                	ld	s2,16(sp)
    80006630:	69a2                	ld	s3,8(sp)
    80006632:	6a02                	ld	s4,0(sp)
    80006634:	6145                	addi	sp,sp,48
    80006636:	8082                	ret

0000000080006638 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006638:	1141                	addi	sp,sp,-16
    8000663a:	e422                	sd	s0,8(sp)
    8000663c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000663e:	100007b7          	lui	a5,0x10000
    80006642:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006646:	8b85                	andi	a5,a5,1
    80006648:	cb81                	beqz	a5,80006658 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    8000664a:	100007b7          	lui	a5,0x10000
    8000664e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006652:	6422                	ld	s0,8(sp)
    80006654:	0141                	addi	sp,sp,16
    80006656:	8082                	ret
    return -1;
    80006658:	557d                	li	a0,-1
    8000665a:	bfe5                	j	80006652 <uartgetc+0x1a>

000000008000665c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    8000665c:	1101                	addi	sp,sp,-32
    8000665e:	ec06                	sd	ra,24(sp)
    80006660:	e822                	sd	s0,16(sp)
    80006662:	e426                	sd	s1,8(sp)
    80006664:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006666:	54fd                	li	s1,-1
    80006668:	a029                	j	80006672 <uartintr+0x16>
      break;
    consoleintr(c);
    8000666a:	00000097          	auipc	ra,0x0
    8000666e:	918080e7          	jalr	-1768(ra) # 80005f82 <consoleintr>
    int c = uartgetc();
    80006672:	00000097          	auipc	ra,0x0
    80006676:	fc6080e7          	jalr	-58(ra) # 80006638 <uartgetc>
    if(c == -1)
    8000667a:	fe9518e3          	bne	a0,s1,8000666a <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000667e:	00024497          	auipc	s1,0x24
    80006682:	bca48493          	addi	s1,s1,-1078 # 8002a248 <uart_tx_lock>
    80006686:	8526                	mv	a0,s1
    80006688:	00000097          	auipc	ra,0x0
    8000668c:	09e080e7          	jalr	158(ra) # 80006726 <acquire>
  uartstart();
    80006690:	00000097          	auipc	ra,0x0
    80006694:	e6c080e7          	jalr	-404(ra) # 800064fc <uartstart>
  release(&uart_tx_lock);
    80006698:	8526                	mv	a0,s1
    8000669a:	00000097          	auipc	ra,0x0
    8000669e:	15c080e7          	jalr	348(ra) # 800067f6 <release>
}
    800066a2:	60e2                	ld	ra,24(sp)
    800066a4:	6442                	ld	s0,16(sp)
    800066a6:	64a2                	ld	s1,8(sp)
    800066a8:	6105                	addi	sp,sp,32
    800066aa:	8082                	ret

00000000800066ac <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800066ac:	411c                	lw	a5,0(a0)
    800066ae:	e399                	bnez	a5,800066b4 <holding+0x8>
    800066b0:	4501                	li	a0,0
  return r;
}
    800066b2:	8082                	ret
{
    800066b4:	1101                	addi	sp,sp,-32
    800066b6:	ec06                	sd	ra,24(sp)
    800066b8:	e822                	sd	s0,16(sp)
    800066ba:	e426                	sd	s1,8(sp)
    800066bc:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800066be:	6904                	ld	s1,16(a0)
    800066c0:	ffffb097          	auipc	ra,0xffffb
    800066c4:	910080e7          	jalr	-1776(ra) # 80000fd0 <mycpu>
    800066c8:	40a48533          	sub	a0,s1,a0
    800066cc:	00153513          	seqz	a0,a0
}
    800066d0:	60e2                	ld	ra,24(sp)
    800066d2:	6442                	ld	s0,16(sp)
    800066d4:	64a2                	ld	s1,8(sp)
    800066d6:	6105                	addi	sp,sp,32
    800066d8:	8082                	ret

00000000800066da <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800066da:	1101                	addi	sp,sp,-32
    800066dc:	ec06                	sd	ra,24(sp)
    800066de:	e822                	sd	s0,16(sp)
    800066e0:	e426                	sd	s1,8(sp)
    800066e2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066e4:	100024f3          	csrr	s1,sstatus
    800066e8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800066ec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800066ee:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800066f2:	ffffb097          	auipc	ra,0xffffb
    800066f6:	8de080e7          	jalr	-1826(ra) # 80000fd0 <mycpu>
    800066fa:	5d3c                	lw	a5,120(a0)
    800066fc:	cf89                	beqz	a5,80006716 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800066fe:	ffffb097          	auipc	ra,0xffffb
    80006702:	8d2080e7          	jalr	-1838(ra) # 80000fd0 <mycpu>
    80006706:	5d3c                	lw	a5,120(a0)
    80006708:	2785                	addiw	a5,a5,1
    8000670a:	dd3c                	sw	a5,120(a0)
}
    8000670c:	60e2                	ld	ra,24(sp)
    8000670e:	6442                	ld	s0,16(sp)
    80006710:	64a2                	ld	s1,8(sp)
    80006712:	6105                	addi	sp,sp,32
    80006714:	8082                	ret
    mycpu()->intena = old;
    80006716:	ffffb097          	auipc	ra,0xffffb
    8000671a:	8ba080e7          	jalr	-1862(ra) # 80000fd0 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000671e:	8085                	srli	s1,s1,0x1
    80006720:	8885                	andi	s1,s1,1
    80006722:	dd64                	sw	s1,124(a0)
    80006724:	bfe9                	j	800066fe <push_off+0x24>

0000000080006726 <acquire>:
{
    80006726:	1101                	addi	sp,sp,-32
    80006728:	ec06                	sd	ra,24(sp)
    8000672a:	e822                	sd	s0,16(sp)
    8000672c:	e426                	sd	s1,8(sp)
    8000672e:	1000                	addi	s0,sp,32
    80006730:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006732:	00000097          	auipc	ra,0x0
    80006736:	fa8080e7          	jalr	-88(ra) # 800066da <push_off>
  if(holding(lk))
    8000673a:	8526                	mv	a0,s1
    8000673c:	00000097          	auipc	ra,0x0
    80006740:	f70080e7          	jalr	-144(ra) # 800066ac <holding>
    80006744:	e911                	bnez	a0,80006758 <acquire+0x32>
    __sync_fetch_and_add(&(lk->n), 1);
    80006746:	4785                	li	a5,1
    80006748:	01c48713          	addi	a4,s1,28
    8000674c:	0f50000f          	fence	iorw,ow
    80006750:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006754:	4705                	li	a4,1
    80006756:	a839                	j	80006774 <acquire+0x4e>
    panic("acquire");
    80006758:	00002517          	auipc	a0,0x2
    8000675c:	0d050513          	addi	a0,a0,208 # 80008828 <digits+0x20>
    80006760:	00000097          	auipc	ra,0x0
    80006764:	aa4080e7          	jalr	-1372(ra) # 80006204 <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    80006768:	01848793          	addi	a5,s1,24
    8000676c:	0f50000f          	fence	iorw,ow
    80006770:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006774:	87ba                	mv	a5,a4
    80006776:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000677a:	2781                	sext.w	a5,a5
    8000677c:	f7f5                	bnez	a5,80006768 <acquire+0x42>
  __sync_synchronize();
    8000677e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006782:	ffffb097          	auipc	ra,0xffffb
    80006786:	84e080e7          	jalr	-1970(ra) # 80000fd0 <mycpu>
    8000678a:	e888                	sd	a0,16(s1)
}
    8000678c:	60e2                	ld	ra,24(sp)
    8000678e:	6442                	ld	s0,16(sp)
    80006790:	64a2                	ld	s1,8(sp)
    80006792:	6105                	addi	sp,sp,32
    80006794:	8082                	ret

0000000080006796 <pop_off>:

void
pop_off(void)
{
    80006796:	1141                	addi	sp,sp,-16
    80006798:	e406                	sd	ra,8(sp)
    8000679a:	e022                	sd	s0,0(sp)
    8000679c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000679e:	ffffb097          	auipc	ra,0xffffb
    800067a2:	832080e7          	jalr	-1998(ra) # 80000fd0 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800067a6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800067aa:	8b89                	andi	a5,a5,2
  if(intr_get())
    800067ac:	e78d                	bnez	a5,800067d6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800067ae:	5d3c                	lw	a5,120(a0)
    800067b0:	02f05b63          	blez	a5,800067e6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800067b4:	37fd                	addiw	a5,a5,-1
    800067b6:	0007871b          	sext.w	a4,a5
    800067ba:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800067bc:	eb09                	bnez	a4,800067ce <pop_off+0x38>
    800067be:	5d7c                	lw	a5,124(a0)
    800067c0:	c799                	beqz	a5,800067ce <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800067c2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800067c6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800067ca:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800067ce:	60a2                	ld	ra,8(sp)
    800067d0:	6402                	ld	s0,0(sp)
    800067d2:	0141                	addi	sp,sp,16
    800067d4:	8082                	ret
    panic("pop_off - interruptible");
    800067d6:	00002517          	auipc	a0,0x2
    800067da:	05a50513          	addi	a0,a0,90 # 80008830 <digits+0x28>
    800067de:	00000097          	auipc	ra,0x0
    800067e2:	a26080e7          	jalr	-1498(ra) # 80006204 <panic>
    panic("pop_off");
    800067e6:	00002517          	auipc	a0,0x2
    800067ea:	06250513          	addi	a0,a0,98 # 80008848 <digits+0x40>
    800067ee:	00000097          	auipc	ra,0x0
    800067f2:	a16080e7          	jalr	-1514(ra) # 80006204 <panic>

00000000800067f6 <release>:
{
    800067f6:	1101                	addi	sp,sp,-32
    800067f8:	ec06                	sd	ra,24(sp)
    800067fa:	e822                	sd	s0,16(sp)
    800067fc:	e426                	sd	s1,8(sp)
    800067fe:	1000                	addi	s0,sp,32
    80006800:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006802:	00000097          	auipc	ra,0x0
    80006806:	eaa080e7          	jalr	-342(ra) # 800066ac <holding>
    8000680a:	c115                	beqz	a0,8000682e <release+0x38>
  lk->cpu = 0;
    8000680c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006810:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006814:	0f50000f          	fence	iorw,ow
    80006818:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000681c:	00000097          	auipc	ra,0x0
    80006820:	f7a080e7          	jalr	-134(ra) # 80006796 <pop_off>
}
    80006824:	60e2                	ld	ra,24(sp)
    80006826:	6442                	ld	s0,16(sp)
    80006828:	64a2                	ld	s1,8(sp)
    8000682a:	6105                	addi	sp,sp,32
    8000682c:	8082                	ret
    panic("release");
    8000682e:	00002517          	auipc	a0,0x2
    80006832:	02250513          	addi	a0,a0,34 # 80008850 <digits+0x48>
    80006836:	00000097          	auipc	ra,0x0
    8000683a:	9ce080e7          	jalr	-1586(ra) # 80006204 <panic>

000000008000683e <freelock>:
{
    8000683e:	1101                	addi	sp,sp,-32
    80006840:	ec06                	sd	ra,24(sp)
    80006842:	e822                	sd	s0,16(sp)
    80006844:	e426                	sd	s1,8(sp)
    80006846:	1000                	addi	s0,sp,32
    80006848:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    8000684a:	00024517          	auipc	a0,0x24
    8000684e:	a3e50513          	addi	a0,a0,-1474 # 8002a288 <lock_locks>
    80006852:	00000097          	auipc	ra,0x0
    80006856:	ed4080e7          	jalr	-300(ra) # 80006726 <acquire>
  for (i = 0; i < NLOCK; i++) {
    8000685a:	00024717          	auipc	a4,0x24
    8000685e:	a4e70713          	addi	a4,a4,-1458 # 8002a2a8 <locks>
    80006862:	4781                	li	a5,0
    80006864:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    80006868:	6314                	ld	a3,0(a4)
    8000686a:	00968763          	beq	a3,s1,80006878 <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    8000686e:	2785                	addiw	a5,a5,1
    80006870:	0721                	addi	a4,a4,8
    80006872:	fec79be3          	bne	a5,a2,80006868 <freelock+0x2a>
    80006876:	a809                	j	80006888 <freelock+0x4a>
      locks[i] = 0;
    80006878:	078e                	slli	a5,a5,0x3
    8000687a:	00024717          	auipc	a4,0x24
    8000687e:	a2e70713          	addi	a4,a4,-1490 # 8002a2a8 <locks>
    80006882:	97ba                	add	a5,a5,a4
    80006884:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    80006888:	00024517          	auipc	a0,0x24
    8000688c:	a0050513          	addi	a0,a0,-1536 # 8002a288 <lock_locks>
    80006890:	00000097          	auipc	ra,0x0
    80006894:	f66080e7          	jalr	-154(ra) # 800067f6 <release>
}
    80006898:	60e2                	ld	ra,24(sp)
    8000689a:	6442                	ld	s0,16(sp)
    8000689c:	64a2                	ld	s1,8(sp)
    8000689e:	6105                	addi	sp,sp,32
    800068a0:	8082                	ret

00000000800068a2 <initlock>:
{
    800068a2:	1101                	addi	sp,sp,-32
    800068a4:	ec06                	sd	ra,24(sp)
    800068a6:	e822                	sd	s0,16(sp)
    800068a8:	e426                	sd	s1,8(sp)
    800068aa:	1000                	addi	s0,sp,32
    800068ac:	84aa                	mv	s1,a0
  lk->name = name;
    800068ae:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800068b0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800068b4:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    800068b8:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    800068bc:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    800068c0:	00024517          	auipc	a0,0x24
    800068c4:	9c850513          	addi	a0,a0,-1592 # 8002a288 <lock_locks>
    800068c8:	00000097          	auipc	ra,0x0
    800068cc:	e5e080e7          	jalr	-418(ra) # 80006726 <acquire>
  for (i = 0; i < NLOCK; i++) {
    800068d0:	00024717          	auipc	a4,0x24
    800068d4:	9d870713          	addi	a4,a4,-1576 # 8002a2a8 <locks>
    800068d8:	4781                	li	a5,0
    800068da:	1f400613          	li	a2,500
    if(locks[i] == 0) {
    800068de:	6314                	ld	a3,0(a4)
    800068e0:	ce89                	beqz	a3,800068fa <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    800068e2:	2785                	addiw	a5,a5,1
    800068e4:	0721                	addi	a4,a4,8
    800068e6:	fec79ce3          	bne	a5,a2,800068de <initlock+0x3c>
  panic("findslot");
    800068ea:	00002517          	auipc	a0,0x2
    800068ee:	f6e50513          	addi	a0,a0,-146 # 80008858 <digits+0x50>
    800068f2:	00000097          	auipc	ra,0x0
    800068f6:	912080e7          	jalr	-1774(ra) # 80006204 <panic>
      locks[i] = lk;
    800068fa:	078e                	slli	a5,a5,0x3
    800068fc:	00024717          	auipc	a4,0x24
    80006900:	9ac70713          	addi	a4,a4,-1620 # 8002a2a8 <locks>
    80006904:	97ba                	add	a5,a5,a4
    80006906:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    80006908:	00024517          	auipc	a0,0x24
    8000690c:	98050513          	addi	a0,a0,-1664 # 8002a288 <lock_locks>
    80006910:	00000097          	auipc	ra,0x0
    80006914:	ee6080e7          	jalr	-282(ra) # 800067f6 <release>
}
    80006918:	60e2                	ld	ra,24(sp)
    8000691a:	6442                	ld	s0,16(sp)
    8000691c:	64a2                	ld	s1,8(sp)
    8000691e:	6105                	addi	sp,sp,32
    80006920:	8082                	ret

0000000080006922 <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    80006922:	1141                	addi	sp,sp,-16
    80006924:	e422                	sd	s0,8(sp)
    80006926:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006928:	0ff0000f          	fence
    8000692c:	6108                	ld	a0,0(a0)
    8000692e:	0ff0000f          	fence
  return val;
}
    80006932:	6422                	ld	s0,8(sp)
    80006934:	0141                	addi	sp,sp,16
    80006936:	8082                	ret

0000000080006938 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    80006938:	1141                	addi	sp,sp,-16
    8000693a:	e422                	sd	s0,8(sp)
    8000693c:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    8000693e:	0ff0000f          	fence
    80006942:	4108                	lw	a0,0(a0)
    80006944:	0ff0000f          	fence
  return val;
}
    80006948:	6422                	ld	s0,8(sp)
    8000694a:	0141                	addi	sp,sp,16
    8000694c:	8082                	ret

000000008000694e <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    8000694e:	4e5c                	lw	a5,28(a2)
    80006950:	00f04463          	bgtz	a5,80006958 <snprint_lock+0xa>
  int n = 0;
    80006954:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    80006956:	8082                	ret
{
    80006958:	1141                	addi	sp,sp,-16
    8000695a:	e406                	sd	ra,8(sp)
    8000695c:	e022                	sd	s0,0(sp)
    8000695e:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    80006960:	4e18                	lw	a4,24(a2)
    80006962:	6614                	ld	a3,8(a2)
    80006964:	00002617          	auipc	a2,0x2
    80006968:	f0460613          	addi	a2,a2,-252 # 80008868 <digits+0x60>
    8000696c:	fffff097          	auipc	ra,0xfffff
    80006970:	204080e7          	jalr	516(ra) # 80005b70 <snprintf>
}
    80006974:	60a2                	ld	ra,8(sp)
    80006976:	6402                	ld	s0,0(sp)
    80006978:	0141                	addi	sp,sp,16
    8000697a:	8082                	ret

000000008000697c <statslock>:

int
statslock(char *buf, int sz) {
    8000697c:	7159                	addi	sp,sp,-112
    8000697e:	f486                	sd	ra,104(sp)
    80006980:	f0a2                	sd	s0,96(sp)
    80006982:	eca6                	sd	s1,88(sp)
    80006984:	e8ca                	sd	s2,80(sp)
    80006986:	e4ce                	sd	s3,72(sp)
    80006988:	e0d2                	sd	s4,64(sp)
    8000698a:	fc56                	sd	s5,56(sp)
    8000698c:	f85a                	sd	s6,48(sp)
    8000698e:	f45e                	sd	s7,40(sp)
    80006990:	f062                	sd	s8,32(sp)
    80006992:	ec66                	sd	s9,24(sp)
    80006994:	e86a                	sd	s10,16(sp)
    80006996:	e46e                	sd	s11,8(sp)
    80006998:	1880                	addi	s0,sp,112
    8000699a:	8aaa                	mv	s5,a0
    8000699c:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    8000699e:	00024517          	auipc	a0,0x24
    800069a2:	8ea50513          	addi	a0,a0,-1814 # 8002a288 <lock_locks>
    800069a6:	00000097          	auipc	ra,0x0
    800069aa:	d80080e7          	jalr	-640(ra) # 80006726 <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    800069ae:	00002617          	auipc	a2,0x2
    800069b2:	eea60613          	addi	a2,a2,-278 # 80008898 <digits+0x90>
    800069b6:	85da                	mv	a1,s6
    800069b8:	8556                	mv	a0,s5
    800069ba:	fffff097          	auipc	ra,0xfffff
    800069be:	1b6080e7          	jalr	438(ra) # 80005b70 <snprintf>
    800069c2:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    800069c4:	00024c97          	auipc	s9,0x24
    800069c8:	8e4c8c93          	addi	s9,s9,-1820 # 8002a2a8 <locks>
    800069cc:	00025c17          	auipc	s8,0x25
    800069d0:	87cc0c13          	addi	s8,s8,-1924 # 8002b248 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    800069d4:	84e6                	mv	s1,s9
  int tot = 0;
    800069d6:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    800069d8:	00002b97          	auipc	s7,0x2
    800069dc:	aa8b8b93          	addi	s7,s7,-1368 # 80008480 <syscalls+0xb0>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    800069e0:	00002d17          	auipc	s10,0x2
    800069e4:	ed8d0d13          	addi	s10,s10,-296 # 800088b8 <digits+0xb0>
    800069e8:	a01d                	j	80006a0e <statslock+0x92>
      tot += locks[i]->nts;
    800069ea:	0009b603          	ld	a2,0(s3)
    800069ee:	4e1c                	lw	a5,24(a2)
    800069f0:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    800069f4:	412b05bb          	subw	a1,s6,s2
    800069f8:	012a8533          	add	a0,s5,s2
    800069fc:	00000097          	auipc	ra,0x0
    80006a00:	f52080e7          	jalr	-174(ra) # 8000694e <snprint_lock>
    80006a04:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    80006a08:	04a1                	addi	s1,s1,8
    80006a0a:	05848763          	beq	s1,s8,80006a58 <statslock+0xdc>
    if(locks[i] == 0)
    80006a0e:	89a6                	mv	s3,s1
    80006a10:	609c                	ld	a5,0(s1)
    80006a12:	c3b9                	beqz	a5,80006a58 <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006a14:	0087bd83          	ld	s11,8(a5)
    80006a18:	855e                	mv	a0,s7
    80006a1a:	ffffa097          	auipc	ra,0xffffa
    80006a1e:	a74080e7          	jalr	-1420(ra) # 8000048e <strlen>
    80006a22:	0005061b          	sext.w	a2,a0
    80006a26:	85de                	mv	a1,s7
    80006a28:	856e                	mv	a0,s11
    80006a2a:	ffffa097          	auipc	ra,0xffffa
    80006a2e:	9b8080e7          	jalr	-1608(ra) # 800003e2 <strncmp>
    80006a32:	dd45                	beqz	a0,800069ea <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006a34:	609c                	ld	a5,0(s1)
    80006a36:	0087bd83          	ld	s11,8(a5)
    80006a3a:	856a                	mv	a0,s10
    80006a3c:	ffffa097          	auipc	ra,0xffffa
    80006a40:	a52080e7          	jalr	-1454(ra) # 8000048e <strlen>
    80006a44:	0005061b          	sext.w	a2,a0
    80006a48:	85ea                	mv	a1,s10
    80006a4a:	856e                	mv	a0,s11
    80006a4c:	ffffa097          	auipc	ra,0xffffa
    80006a50:	996080e7          	jalr	-1642(ra) # 800003e2 <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006a54:	f955                	bnez	a0,80006a08 <statslock+0x8c>
    80006a56:	bf51                	j	800069ea <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    80006a58:	00002617          	auipc	a2,0x2
    80006a5c:	e6860613          	addi	a2,a2,-408 # 800088c0 <digits+0xb8>
    80006a60:	412b05bb          	subw	a1,s6,s2
    80006a64:	012a8533          	add	a0,s5,s2
    80006a68:	fffff097          	auipc	ra,0xfffff
    80006a6c:	108080e7          	jalr	264(ra) # 80005b70 <snprintf>
    80006a70:	012509bb          	addw	s3,a0,s2
    80006a74:	4b95                	li	s7,5
  int last = 100000000;
    80006a76:	05f5e537          	lui	a0,0x5f5e
    80006a7a:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    80006a7e:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006a80:	00024497          	auipc	s1,0x24
    80006a84:	82848493          	addi	s1,s1,-2008 # 8002a2a8 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80006a88:	1f400913          	li	s2,500
    80006a8c:	a881                	j	80006adc <statslock+0x160>
    80006a8e:	2705                	addiw	a4,a4,1
    80006a90:	06a1                	addi	a3,a3,8
    80006a92:	03270063          	beq	a4,s2,80006ab2 <statslock+0x136>
      if(locks[i] == 0)
    80006a96:	629c                	ld	a5,0(a3)
    80006a98:	cf89                	beqz	a5,80006ab2 <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006a9a:	4f90                	lw	a2,24(a5)
    80006a9c:	00359793          	slli	a5,a1,0x3
    80006aa0:	97a6                	add	a5,a5,s1
    80006aa2:	639c                	ld	a5,0(a5)
    80006aa4:	4f9c                	lw	a5,24(a5)
    80006aa6:	fec7d4e3          	bge	a5,a2,80006a8e <statslock+0x112>
    80006aaa:	fea652e3          	bge	a2,a0,80006a8e <statslock+0x112>
    80006aae:	85ba                	mv	a1,a4
    80006ab0:	bff9                	j	80006a8e <statslock+0x112>
        top = i;
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    80006ab2:	058e                	slli	a1,a1,0x3
    80006ab4:	00b48d33          	add	s10,s1,a1
    80006ab8:	000d3603          	ld	a2,0(s10)
    80006abc:	413b05bb          	subw	a1,s6,s3
    80006ac0:	013a8533          	add	a0,s5,s3
    80006ac4:	00000097          	auipc	ra,0x0
    80006ac8:	e8a080e7          	jalr	-374(ra) # 8000694e <snprint_lock>
    80006acc:	013509bb          	addw	s3,a0,s3
    last = locks[top]->nts;
    80006ad0:	000d3783          	ld	a5,0(s10)
    80006ad4:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    80006ad6:	3bfd                	addiw	s7,s7,-1
    80006ad8:	000b8663          	beqz	s7,80006ae4 <statslock+0x168>
  int tot = 0;
    80006adc:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    80006ade:	8762                	mv	a4,s8
    int top = 0;
    80006ae0:	85e2                	mv	a1,s8
    80006ae2:	bf55                	j	80006a96 <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    80006ae4:	86d2                	mv	a3,s4
    80006ae6:	00002617          	auipc	a2,0x2
    80006aea:	dfa60613          	addi	a2,a2,-518 # 800088e0 <digits+0xd8>
    80006aee:	413b05bb          	subw	a1,s6,s3
    80006af2:	013a8533          	add	a0,s5,s3
    80006af6:	fffff097          	auipc	ra,0xfffff
    80006afa:	07a080e7          	jalr	122(ra) # 80005b70 <snprintf>
    80006afe:	013509bb          	addw	s3,a0,s3
  release(&lock_locks);  
    80006b02:	00023517          	auipc	a0,0x23
    80006b06:	78650513          	addi	a0,a0,1926 # 8002a288 <lock_locks>
    80006b0a:	00000097          	auipc	ra,0x0
    80006b0e:	cec080e7          	jalr	-788(ra) # 800067f6 <release>
  return n;
}
    80006b12:	854e                	mv	a0,s3
    80006b14:	70a6                	ld	ra,104(sp)
    80006b16:	7406                	ld	s0,96(sp)
    80006b18:	64e6                	ld	s1,88(sp)
    80006b1a:	6946                	ld	s2,80(sp)
    80006b1c:	69a6                	ld	s3,72(sp)
    80006b1e:	6a06                	ld	s4,64(sp)
    80006b20:	7ae2                	ld	s5,56(sp)
    80006b22:	7b42                	ld	s6,48(sp)
    80006b24:	7ba2                	ld	s7,40(sp)
    80006b26:	7c02                	ld	s8,32(sp)
    80006b28:	6ce2                	ld	s9,24(sp)
    80006b2a:	6d42                	ld	s10,16(sp)
    80006b2c:	6da2                	ld	s11,8(sp)
    80006b2e:	6165                	addi	sp,sp,112
    80006b30:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
