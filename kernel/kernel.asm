
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9e013103          	ld	sp,-1568(sp) # 800089e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	76c050ef          	jal	ra,80005782 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	156080e7          	jalr	342(ra) # 8000019e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	10e080e7          	jalr	270(ra) # 80006168 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1ae080e7          	jalr	430(ra) # 8000621c <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	ba6080e7          	jalr	-1114(ra) # 80005c30 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	addi	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	fe2080e7          	jalr	-30(ra) # 800060d8 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00026517          	auipc	a0,0x26
    80000106:	13e50513          	addi	a0,a0,318 # 80026240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	addi	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	03a080e7          	jalr	58(ra) # 80006168 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	addi	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	0d6080e7          	jalr	214(ra) # 8000621c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	04a080e7          	jalr	74(ra) # 8000019e <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	addi	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	0ac080e7          	jalr	172(ra) # 8000621c <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <freemem>:

uint64 freemem(void)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
    uint64 cnt = 0;
    for (struct run* p = kmem.freelist; p; p = p->next)
    80000180:	00009797          	auipc	a5,0x9
    80000184:	ec87b783          	ld	a5,-312(a5) # 80009048 <kmem+0x18>
    80000188:	cb89                	beqz	a5,8000019a <freemem+0x20>
    uint64 cnt = 0;
    8000018a:	4501                	li	a0,0
        cnt++;
    8000018c:	0505                	addi	a0,a0,1
    for (struct run* p = kmem.freelist; p; p = p->next)
    8000018e:	639c                	ld	a5,0(a5)
    80000190:	fff5                	bnez	a5,8000018c <freemem+0x12>
    return cnt * PGSIZE;
}
    80000192:	0532                	slli	a0,a0,0xc
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret
    uint64 cnt = 0;
    8000019a:	4501                	li	a0,0
    8000019c:	bfdd                	j	80000192 <freemem+0x18>

000000008000019e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001a4:	ca19                	beqz	a2,800001ba <memset+0x1c>
    800001a6:	87aa                	mv	a5,a0
    800001a8:	1602                	slli	a2,a2,0x20
    800001aa:	9201                	srli	a2,a2,0x20
    800001ac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001b0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001b4:	0785                	addi	a5,a5,1
    800001b6:	fee79de3          	bne	a5,a4,800001b0 <memset+0x12>
  }
  return dst;
}
    800001ba:	6422                	ld	s0,8(sp)
    800001bc:	0141                	addi	sp,sp,16
    800001be:	8082                	ret

00000000800001c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001c0:	1141                	addi	sp,sp,-16
    800001c2:	e422                	sd	s0,8(sp)
    800001c4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001c6:	ca05                	beqz	a2,800001f6 <memcmp+0x36>
    800001c8:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001cc:	1682                	slli	a3,a3,0x20
    800001ce:	9281                	srli	a3,a3,0x20
    800001d0:	0685                	addi	a3,a3,1
    800001d2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001d4:	00054783          	lbu	a5,0(a0)
    800001d8:	0005c703          	lbu	a4,0(a1)
    800001dc:	00e79863          	bne	a5,a4,800001ec <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001e0:	0505                	addi	a0,a0,1
    800001e2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001e4:	fed518e3          	bne	a0,a3,800001d4 <memcmp+0x14>
  }

  return 0;
    800001e8:	4501                	li	a0,0
    800001ea:	a019                	j	800001f0 <memcmp+0x30>
      return *s1 - *s2;
    800001ec:	40e7853b          	subw	a0,a5,a4
}
    800001f0:	6422                	ld	s0,8(sp)
    800001f2:	0141                	addi	sp,sp,16
    800001f4:	8082                	ret
  return 0;
    800001f6:	4501                	li	a0,0
    800001f8:	bfe5                	j	800001f0 <memcmp+0x30>

00000000800001fa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001fa:	1141                	addi	sp,sp,-16
    800001fc:	e422                	sd	s0,8(sp)
    800001fe:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000200:	c205                	beqz	a2,80000220 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000202:	02a5e263          	bltu	a1,a0,80000226 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000206:	1602                	slli	a2,a2,0x20
    80000208:	9201                	srli	a2,a2,0x20
    8000020a:	00c587b3          	add	a5,a1,a2
{
    8000020e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000210:	0585                	addi	a1,a1,1
    80000212:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    80000214:	fff5c683          	lbu	a3,-1(a1)
    80000218:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000021c:	fef59ae3          	bne	a1,a5,80000210 <memmove+0x16>

  return dst;
}
    80000220:	6422                	ld	s0,8(sp)
    80000222:	0141                	addi	sp,sp,16
    80000224:	8082                	ret
  if(s < d && s + n > d){
    80000226:	02061693          	slli	a3,a2,0x20
    8000022a:	9281                	srli	a3,a3,0x20
    8000022c:	00d58733          	add	a4,a1,a3
    80000230:	fce57be3          	bgeu	a0,a4,80000206 <memmove+0xc>
    d += n;
    80000234:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000236:	fff6079b          	addiw	a5,a2,-1
    8000023a:	1782                	slli	a5,a5,0x20
    8000023c:	9381                	srli	a5,a5,0x20
    8000023e:	fff7c793          	not	a5,a5
    80000242:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000244:	177d                	addi	a4,a4,-1
    80000246:	16fd                	addi	a3,a3,-1
    80000248:	00074603          	lbu	a2,0(a4)
    8000024c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000250:	fee79ae3          	bne	a5,a4,80000244 <memmove+0x4a>
    80000254:	b7f1                	j	80000220 <memmove+0x26>

0000000080000256 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000256:	1141                	addi	sp,sp,-16
    80000258:	e406                	sd	ra,8(sp)
    8000025a:	e022                	sd	s0,0(sp)
    8000025c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000025e:	00000097          	auipc	ra,0x0
    80000262:	f9c080e7          	jalr	-100(ra) # 800001fa <memmove>
}
    80000266:	60a2                	ld	ra,8(sp)
    80000268:	6402                	ld	s0,0(sp)
    8000026a:	0141                	addi	sp,sp,16
    8000026c:	8082                	ret

000000008000026e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000026e:	1141                	addi	sp,sp,-16
    80000270:	e422                	sd	s0,8(sp)
    80000272:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000274:	ce11                	beqz	a2,80000290 <strncmp+0x22>
    80000276:	00054783          	lbu	a5,0(a0)
    8000027a:	cf89                	beqz	a5,80000294 <strncmp+0x26>
    8000027c:	0005c703          	lbu	a4,0(a1)
    80000280:	00f71a63          	bne	a4,a5,80000294 <strncmp+0x26>
    n--, p++, q++;
    80000284:	367d                	addiw	a2,a2,-1
    80000286:	0505                	addi	a0,a0,1
    80000288:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000028a:	f675                	bnez	a2,80000276 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000028c:	4501                	li	a0,0
    8000028e:	a809                	j	800002a0 <strncmp+0x32>
    80000290:	4501                	li	a0,0
    80000292:	a039                	j	800002a0 <strncmp+0x32>
  if(n == 0)
    80000294:	ca09                	beqz	a2,800002a6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000296:	00054503          	lbu	a0,0(a0)
    8000029a:	0005c783          	lbu	a5,0(a1)
    8000029e:	9d1d                	subw	a0,a0,a5
}
    800002a0:	6422                	ld	s0,8(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    return 0;
    800002a6:	4501                	li	a0,0
    800002a8:	bfe5                	j	800002a0 <strncmp+0x32>

00000000800002aa <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002aa:	1141                	addi	sp,sp,-16
    800002ac:	e422                	sd	s0,8(sp)
    800002ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002b0:	872a                	mv	a4,a0
    800002b2:	8832                	mv	a6,a2
    800002b4:	367d                	addiw	a2,a2,-1
    800002b6:	01005963          	blez	a6,800002c8 <strncpy+0x1e>
    800002ba:	0705                	addi	a4,a4,1
    800002bc:	0005c783          	lbu	a5,0(a1)
    800002c0:	fef70fa3          	sb	a5,-1(a4)
    800002c4:	0585                	addi	a1,a1,1
    800002c6:	f7f5                	bnez	a5,800002b2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002c8:	86ba                	mv	a3,a4
    800002ca:	00c05c63          	blez	a2,800002e2 <strncpy+0x38>
    *s++ = 0;
    800002ce:	0685                	addi	a3,a3,1
    800002d0:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002d4:	40d707bb          	subw	a5,a4,a3
    800002d8:	37fd                	addiw	a5,a5,-1
    800002da:	010787bb          	addw	a5,a5,a6
    800002de:	fef048e3          	bgtz	a5,800002ce <strncpy+0x24>
  return os;
}
    800002e2:	6422                	ld	s0,8(sp)
    800002e4:	0141                	addi	sp,sp,16
    800002e6:	8082                	ret

00000000800002e8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e422                	sd	s0,8(sp)
    800002ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ee:	02c05363          	blez	a2,80000314 <safestrcpy+0x2c>
    800002f2:	fff6069b          	addiw	a3,a2,-1
    800002f6:	1682                	slli	a3,a3,0x20
    800002f8:	9281                	srli	a3,a3,0x20
    800002fa:	96ae                	add	a3,a3,a1
    800002fc:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002fe:	00d58963          	beq	a1,a3,80000310 <safestrcpy+0x28>
    80000302:	0585                	addi	a1,a1,1
    80000304:	0785                	addi	a5,a5,1
    80000306:	fff5c703          	lbu	a4,-1(a1)
    8000030a:	fee78fa3          	sb	a4,-1(a5)
    8000030e:	fb65                	bnez	a4,800002fe <safestrcpy+0x16>
    ;
  *s = 0;
    80000310:	00078023          	sb	zero,0(a5)
  return os;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret

000000008000031a <strlen>:

int
strlen(const char *s)
{
    8000031a:	1141                	addi	sp,sp,-16
    8000031c:	e422                	sd	s0,8(sp)
    8000031e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000320:	00054783          	lbu	a5,0(a0)
    80000324:	cf91                	beqz	a5,80000340 <strlen+0x26>
    80000326:	0505                	addi	a0,a0,1
    80000328:	87aa                	mv	a5,a0
    8000032a:	4685                	li	a3,1
    8000032c:	9e89                	subw	a3,a3,a0
    8000032e:	00f6853b          	addw	a0,a3,a5
    80000332:	0785                	addi	a5,a5,1
    80000334:	fff7c703          	lbu	a4,-1(a5)
    80000338:	fb7d                	bnez	a4,8000032e <strlen+0x14>
    ;
  return n;
}
    8000033a:	6422                	ld	s0,8(sp)
    8000033c:	0141                	addi	sp,sp,16
    8000033e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000340:	4501                	li	a0,0
    80000342:	bfe5                	j	8000033a <strlen+0x20>

0000000080000344 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000344:	1141                	addi	sp,sp,-16
    80000346:	e406                	sd	ra,8(sp)
    80000348:	e022                	sd	s0,0(sp)
    8000034a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000034c:	00001097          	auipc	ra,0x1
    80000350:	af0080e7          	jalr	-1296(ra) # 80000e3c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000354:	00009717          	auipc	a4,0x9
    80000358:	cac70713          	addi	a4,a4,-852 # 80009000 <started>
  if(cpuid() == 0){
    8000035c:	c139                	beqz	a0,800003a2 <main+0x5e>
    while(started == 0)
    8000035e:	431c                	lw	a5,0(a4)
    80000360:	2781                	sext.w	a5,a5
    80000362:	dff5                	beqz	a5,8000035e <main+0x1a>
      ;
    __sync_synchronize();
    80000364:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000368:	00001097          	auipc	ra,0x1
    8000036c:	ad4080e7          	jalr	-1324(ra) # 80000e3c <cpuid>
    80000370:	85aa                	mv	a1,a0
    80000372:	00008517          	auipc	a0,0x8
    80000376:	cc650513          	addi	a0,a0,-826 # 80008038 <etext+0x38>
    8000037a:	00006097          	auipc	ra,0x6
    8000037e:	900080e7          	jalr	-1792(ra) # 80005c7a <printf>
    kvminithart();    // turn on paging
    80000382:	00000097          	auipc	ra,0x0
    80000386:	0d8080e7          	jalr	216(ra) # 8000045a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000038a:	00001097          	auipc	ra,0x1
    8000038e:	792080e7          	jalr	1938(ra) # 80001b1c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000392:	00005097          	auipc	ra,0x5
    80000396:	dce080e7          	jalr	-562(ra) # 80005160 <plicinithart>
  }

  scheduler();        
    8000039a:	00001097          	auipc	ra,0x1
    8000039e:	fe8080e7          	jalr	-24(ra) # 80001382 <scheduler>
    consoleinit();
    800003a2:	00005097          	auipc	ra,0x5
    800003a6:	79e080e7          	jalr	1950(ra) # 80005b40 <consoleinit>
    printfinit();
    800003aa:	00006097          	auipc	ra,0x6
    800003ae:	ab0080e7          	jalr	-1360(ra) # 80005e5a <printfinit>
    printf("\n");
    800003b2:	00008517          	auipc	a0,0x8
    800003b6:	c9650513          	addi	a0,a0,-874 # 80008048 <etext+0x48>
    800003ba:	00006097          	auipc	ra,0x6
    800003be:	8c0080e7          	jalr	-1856(ra) # 80005c7a <printf>
    printf("xv6 kernel is booting\n");
    800003c2:	00008517          	auipc	a0,0x8
    800003c6:	c5e50513          	addi	a0,a0,-930 # 80008020 <etext+0x20>
    800003ca:	00006097          	auipc	ra,0x6
    800003ce:	8b0080e7          	jalr	-1872(ra) # 80005c7a <printf>
    printf("\n");
    800003d2:	00008517          	auipc	a0,0x8
    800003d6:	c7650513          	addi	a0,a0,-906 # 80008048 <etext+0x48>
    800003da:	00006097          	auipc	ra,0x6
    800003de:	8a0080e7          	jalr	-1888(ra) # 80005c7a <printf>
    kinit();         // physical page allocator
    800003e2:	00000097          	auipc	ra,0x0
    800003e6:	cfc080e7          	jalr	-772(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003ea:	00000097          	auipc	ra,0x0
    800003ee:	322080e7          	jalr	802(ra) # 8000070c <kvminit>
    kvminithart();   // turn on paging
    800003f2:	00000097          	auipc	ra,0x0
    800003f6:	068080e7          	jalr	104(ra) # 8000045a <kvminithart>
    procinit();      // process table
    800003fa:	00001097          	auipc	ra,0x1
    800003fe:	992080e7          	jalr	-1646(ra) # 80000d8c <procinit>
    trapinit();      // trap vectors
    80000402:	00001097          	auipc	ra,0x1
    80000406:	6f2080e7          	jalr	1778(ra) # 80001af4 <trapinit>
    trapinithart();  // install kernel trap vector
    8000040a:	00001097          	auipc	ra,0x1
    8000040e:	712080e7          	jalr	1810(ra) # 80001b1c <trapinithart>
    plicinit();      // set up interrupt controller
    80000412:	00005097          	auipc	ra,0x5
    80000416:	d38080e7          	jalr	-712(ra) # 8000514a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000041a:	00005097          	auipc	ra,0x5
    8000041e:	d46080e7          	jalr	-698(ra) # 80005160 <plicinithart>
    binit();         // buffer cache
    80000422:	00002097          	auipc	ra,0x2
    80000426:	f0c080e7          	jalr	-244(ra) # 8000232e <binit>
    iinit();         // inode table
    8000042a:	00002097          	auipc	ra,0x2
    8000042e:	59a080e7          	jalr	1434(ra) # 800029c4 <iinit>
    fileinit();      // file table
    80000432:	00003097          	auipc	ra,0x3
    80000436:	54c080e7          	jalr	1356(ra) # 8000397e <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000043a:	00005097          	auipc	ra,0x5
    8000043e:	e46080e7          	jalr	-442(ra) # 80005280 <virtio_disk_init>
    userinit();      // first user process
    80000442:	00001097          	auipc	ra,0x1
    80000446:	cfe080e7          	jalr	-770(ra) # 80001140 <userinit>
    __sync_synchronize();
    8000044a:	0ff0000f          	fence
    started = 1;
    8000044e:	4785                	li	a5,1
    80000450:	00009717          	auipc	a4,0x9
    80000454:	baf72823          	sw	a5,-1104(a4) # 80009000 <started>
    80000458:	b789                	j	8000039a <main+0x56>

000000008000045a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000045a:	1141                	addi	sp,sp,-16
    8000045c:	e422                	sd	s0,8(sp)
    8000045e:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000460:	00009797          	auipc	a5,0x9
    80000464:	ba87b783          	ld	a5,-1112(a5) # 80009008 <kernel_pagetable>
    80000468:	83b1                	srli	a5,a5,0xc
    8000046a:	577d                	li	a4,-1
    8000046c:	177e                	slli	a4,a4,0x3f
    8000046e:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000470:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000474:	12000073          	sfence.vma
  sfence_vma();
}
    80000478:	6422                	ld	s0,8(sp)
    8000047a:	0141                	addi	sp,sp,16
    8000047c:	8082                	ret

000000008000047e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000047e:	7139                	addi	sp,sp,-64
    80000480:	fc06                	sd	ra,56(sp)
    80000482:	f822                	sd	s0,48(sp)
    80000484:	f426                	sd	s1,40(sp)
    80000486:	f04a                	sd	s2,32(sp)
    80000488:	ec4e                	sd	s3,24(sp)
    8000048a:	e852                	sd	s4,16(sp)
    8000048c:	e456                	sd	s5,8(sp)
    8000048e:	e05a                	sd	s6,0(sp)
    80000490:	0080                	addi	s0,sp,64
    80000492:	84aa                	mv	s1,a0
    80000494:	89ae                	mv	s3,a1
    80000496:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000498:	57fd                	li	a5,-1
    8000049a:	83e9                	srli	a5,a5,0x1a
    8000049c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000049e:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004a0:	04b7f263          	bgeu	a5,a1,800004e4 <walk+0x66>
    panic("walk");
    800004a4:	00008517          	auipc	a0,0x8
    800004a8:	bac50513          	addi	a0,a0,-1108 # 80008050 <etext+0x50>
    800004ac:	00005097          	auipc	ra,0x5
    800004b0:	784080e7          	jalr	1924(ra) # 80005c30 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004b4:	060a8663          	beqz	s5,80000520 <walk+0xa2>
    800004b8:	00000097          	auipc	ra,0x0
    800004bc:	c62080e7          	jalr	-926(ra) # 8000011a <kalloc>
    800004c0:	84aa                	mv	s1,a0
    800004c2:	c529                	beqz	a0,8000050c <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004c4:	6605                	lui	a2,0x1
    800004c6:	4581                	li	a1,0
    800004c8:	00000097          	auipc	ra,0x0
    800004cc:	cd6080e7          	jalr	-810(ra) # 8000019e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004d0:	00c4d793          	srli	a5,s1,0xc
    800004d4:	07aa                	slli	a5,a5,0xa
    800004d6:	0017e793          	ori	a5,a5,1
    800004da:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004de:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    800004e0:	036a0063          	beq	s4,s6,80000500 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004e4:	0149d933          	srl	s2,s3,s4
    800004e8:	1ff97913          	andi	s2,s2,511
    800004ec:	090e                	slli	s2,s2,0x3
    800004ee:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004f0:	00093483          	ld	s1,0(s2)
    800004f4:	0014f793          	andi	a5,s1,1
    800004f8:	dfd5                	beqz	a5,800004b4 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004fa:	80a9                	srli	s1,s1,0xa
    800004fc:	04b2                	slli	s1,s1,0xc
    800004fe:	b7c5                	j	800004de <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000500:	00c9d513          	srli	a0,s3,0xc
    80000504:	1ff57513          	andi	a0,a0,511
    80000508:	050e                	slli	a0,a0,0x3
    8000050a:	9526                	add	a0,a0,s1
}
    8000050c:	70e2                	ld	ra,56(sp)
    8000050e:	7442                	ld	s0,48(sp)
    80000510:	74a2                	ld	s1,40(sp)
    80000512:	7902                	ld	s2,32(sp)
    80000514:	69e2                	ld	s3,24(sp)
    80000516:	6a42                	ld	s4,16(sp)
    80000518:	6aa2                	ld	s5,8(sp)
    8000051a:	6b02                	ld	s6,0(sp)
    8000051c:	6121                	addi	sp,sp,64
    8000051e:	8082                	ret
        return 0;
    80000520:	4501                	li	a0,0
    80000522:	b7ed                	j	8000050c <walk+0x8e>

0000000080000524 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000524:	57fd                	li	a5,-1
    80000526:	83e9                	srli	a5,a5,0x1a
    80000528:	00b7f463          	bgeu	a5,a1,80000530 <walkaddr+0xc>
    return 0;
    8000052c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000052e:	8082                	ret
{
    80000530:	1141                	addi	sp,sp,-16
    80000532:	e406                	sd	ra,8(sp)
    80000534:	e022                	sd	s0,0(sp)
    80000536:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000538:	4601                	li	a2,0
    8000053a:	00000097          	auipc	ra,0x0
    8000053e:	f44080e7          	jalr	-188(ra) # 8000047e <walk>
  if(pte == 0)
    80000542:	c105                	beqz	a0,80000562 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000544:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000546:	0117f693          	andi	a3,a5,17
    8000054a:	4745                	li	a4,17
    return 0;
    8000054c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000054e:	00e68663          	beq	a3,a4,8000055a <walkaddr+0x36>
}
    80000552:	60a2                	ld	ra,8(sp)
    80000554:	6402                	ld	s0,0(sp)
    80000556:	0141                	addi	sp,sp,16
    80000558:	8082                	ret
  pa = PTE2PA(*pte);
    8000055a:	83a9                	srli	a5,a5,0xa
    8000055c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000560:	bfcd                	j	80000552 <walkaddr+0x2e>
    return 0;
    80000562:	4501                	li	a0,0
    80000564:	b7fd                	j	80000552 <walkaddr+0x2e>

0000000080000566 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000566:	715d                	addi	sp,sp,-80
    80000568:	e486                	sd	ra,72(sp)
    8000056a:	e0a2                	sd	s0,64(sp)
    8000056c:	fc26                	sd	s1,56(sp)
    8000056e:	f84a                	sd	s2,48(sp)
    80000570:	f44e                	sd	s3,40(sp)
    80000572:	f052                	sd	s4,32(sp)
    80000574:	ec56                	sd	s5,24(sp)
    80000576:	e85a                	sd	s6,16(sp)
    80000578:	e45e                	sd	s7,8(sp)
    8000057a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000057c:	c639                	beqz	a2,800005ca <mappages+0x64>
    8000057e:	8aaa                	mv	s5,a0
    80000580:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000582:	777d                	lui	a4,0xfffff
    80000584:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000588:	fff58993          	addi	s3,a1,-1
    8000058c:	99b2                	add	s3,s3,a2
    8000058e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000592:	893e                	mv	s2,a5
    80000594:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000598:	6b85                	lui	s7,0x1
    8000059a:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000059e:	4605                	li	a2,1
    800005a0:	85ca                	mv	a1,s2
    800005a2:	8556                	mv	a0,s5
    800005a4:	00000097          	auipc	ra,0x0
    800005a8:	eda080e7          	jalr	-294(ra) # 8000047e <walk>
    800005ac:	cd1d                	beqz	a0,800005ea <mappages+0x84>
    if(*pte & PTE_V)
    800005ae:	611c                	ld	a5,0(a0)
    800005b0:	8b85                	andi	a5,a5,1
    800005b2:	e785                	bnez	a5,800005da <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005b4:	80b1                	srli	s1,s1,0xc
    800005b6:	04aa                	slli	s1,s1,0xa
    800005b8:	0164e4b3          	or	s1,s1,s6
    800005bc:	0014e493          	ori	s1,s1,1
    800005c0:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c2:	05390063          	beq	s2,s3,80000602 <mappages+0x9c>
    a += PGSIZE;
    800005c6:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c8:	bfc9                	j	8000059a <mappages+0x34>
    panic("mappages: size");
    800005ca:	00008517          	auipc	a0,0x8
    800005ce:	a8e50513          	addi	a0,a0,-1394 # 80008058 <etext+0x58>
    800005d2:	00005097          	auipc	ra,0x5
    800005d6:	65e080e7          	jalr	1630(ra) # 80005c30 <panic>
      panic("mappages: remap");
    800005da:	00008517          	auipc	a0,0x8
    800005de:	a8e50513          	addi	a0,a0,-1394 # 80008068 <etext+0x68>
    800005e2:	00005097          	auipc	ra,0x5
    800005e6:	64e080e7          	jalr	1614(ra) # 80005c30 <panic>
      return -1;
    800005ea:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ec:	60a6                	ld	ra,72(sp)
    800005ee:	6406                	ld	s0,64(sp)
    800005f0:	74e2                	ld	s1,56(sp)
    800005f2:	7942                	ld	s2,48(sp)
    800005f4:	79a2                	ld	s3,40(sp)
    800005f6:	7a02                	ld	s4,32(sp)
    800005f8:	6ae2                	ld	s5,24(sp)
    800005fa:	6b42                	ld	s6,16(sp)
    800005fc:	6ba2                	ld	s7,8(sp)
    800005fe:	6161                	addi	sp,sp,80
    80000600:	8082                	ret
  return 0;
    80000602:	4501                	li	a0,0
    80000604:	b7e5                	j	800005ec <mappages+0x86>

0000000080000606 <kvmmap>:
{
    80000606:	1141                	addi	sp,sp,-16
    80000608:	e406                	sd	ra,8(sp)
    8000060a:	e022                	sd	s0,0(sp)
    8000060c:	0800                	addi	s0,sp,16
    8000060e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000610:	86b2                	mv	a3,a2
    80000612:	863e                	mv	a2,a5
    80000614:	00000097          	auipc	ra,0x0
    80000618:	f52080e7          	jalr	-174(ra) # 80000566 <mappages>
    8000061c:	e509                	bnez	a0,80000626 <kvmmap+0x20>
}
    8000061e:	60a2                	ld	ra,8(sp)
    80000620:	6402                	ld	s0,0(sp)
    80000622:	0141                	addi	sp,sp,16
    80000624:	8082                	ret
    panic("kvmmap");
    80000626:	00008517          	auipc	a0,0x8
    8000062a:	a5250513          	addi	a0,a0,-1454 # 80008078 <etext+0x78>
    8000062e:	00005097          	auipc	ra,0x5
    80000632:	602080e7          	jalr	1538(ra) # 80005c30 <panic>

0000000080000636 <kvmmake>:
{
    80000636:	1101                	addi	sp,sp,-32
    80000638:	ec06                	sd	ra,24(sp)
    8000063a:	e822                	sd	s0,16(sp)
    8000063c:	e426                	sd	s1,8(sp)
    8000063e:	e04a                	sd	s2,0(sp)
    80000640:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000642:	00000097          	auipc	ra,0x0
    80000646:	ad8080e7          	jalr	-1320(ra) # 8000011a <kalloc>
    8000064a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000064c:	6605                	lui	a2,0x1
    8000064e:	4581                	li	a1,0
    80000650:	00000097          	auipc	ra,0x0
    80000654:	b4e080e7          	jalr	-1202(ra) # 8000019e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000658:	4719                	li	a4,6
    8000065a:	6685                	lui	a3,0x1
    8000065c:	10000637          	lui	a2,0x10000
    80000660:	100005b7          	lui	a1,0x10000
    80000664:	8526                	mv	a0,s1
    80000666:	00000097          	auipc	ra,0x0
    8000066a:	fa0080e7          	jalr	-96(ra) # 80000606 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000066e:	4719                	li	a4,6
    80000670:	6685                	lui	a3,0x1
    80000672:	10001637          	lui	a2,0x10001
    80000676:	100015b7          	lui	a1,0x10001
    8000067a:	8526                	mv	a0,s1
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	f8a080e7          	jalr	-118(ra) # 80000606 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000684:	4719                	li	a4,6
    80000686:	004006b7          	lui	a3,0x400
    8000068a:	0c000637          	lui	a2,0xc000
    8000068e:	0c0005b7          	lui	a1,0xc000
    80000692:	8526                	mv	a0,s1
    80000694:	00000097          	auipc	ra,0x0
    80000698:	f72080e7          	jalr	-142(ra) # 80000606 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000069c:	00008917          	auipc	s2,0x8
    800006a0:	96490913          	addi	s2,s2,-1692 # 80008000 <etext>
    800006a4:	4729                	li	a4,10
    800006a6:	80008697          	auipc	a3,0x80008
    800006aa:	95a68693          	addi	a3,a3,-1702 # 8000 <_entry-0x7fff8000>
    800006ae:	4605                	li	a2,1
    800006b0:	067e                	slli	a2,a2,0x1f
    800006b2:	85b2                	mv	a1,a2
    800006b4:	8526                	mv	a0,s1
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	f50080e7          	jalr	-176(ra) # 80000606 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006be:	4719                	li	a4,6
    800006c0:	46c5                	li	a3,17
    800006c2:	06ee                	slli	a3,a3,0x1b
    800006c4:	412686b3          	sub	a3,a3,s2
    800006c8:	864a                	mv	a2,s2
    800006ca:	85ca                	mv	a1,s2
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f38080e7          	jalr	-200(ra) # 80000606 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006d6:	4729                	li	a4,10
    800006d8:	6685                	lui	a3,0x1
    800006da:	00007617          	auipc	a2,0x7
    800006de:	92660613          	addi	a2,a2,-1754 # 80007000 <_trampoline>
    800006e2:	040005b7          	lui	a1,0x4000
    800006e6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006e8:	05b2                	slli	a1,a1,0xc
    800006ea:	8526                	mv	a0,s1
    800006ec:	00000097          	auipc	ra,0x0
    800006f0:	f1a080e7          	jalr	-230(ra) # 80000606 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006f4:	8526                	mv	a0,s1
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	600080e7          	jalr	1536(ra) # 80000cf6 <proc_mapstacks>
}
    800006fe:	8526                	mv	a0,s1
    80000700:	60e2                	ld	ra,24(sp)
    80000702:	6442                	ld	s0,16(sp)
    80000704:	64a2                	ld	s1,8(sp)
    80000706:	6902                	ld	s2,0(sp)
    80000708:	6105                	addi	sp,sp,32
    8000070a:	8082                	ret

000000008000070c <kvminit>:
{
    8000070c:	1141                	addi	sp,sp,-16
    8000070e:	e406                	sd	ra,8(sp)
    80000710:	e022                	sd	s0,0(sp)
    80000712:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000714:	00000097          	auipc	ra,0x0
    80000718:	f22080e7          	jalr	-222(ra) # 80000636 <kvmmake>
    8000071c:	00009797          	auipc	a5,0x9
    80000720:	8ea7b623          	sd	a0,-1812(a5) # 80009008 <kernel_pagetable>
}
    80000724:	60a2                	ld	ra,8(sp)
    80000726:	6402                	ld	s0,0(sp)
    80000728:	0141                	addi	sp,sp,16
    8000072a:	8082                	ret

000000008000072c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000072c:	715d                	addi	sp,sp,-80
    8000072e:	e486                	sd	ra,72(sp)
    80000730:	e0a2                	sd	s0,64(sp)
    80000732:	fc26                	sd	s1,56(sp)
    80000734:	f84a                	sd	s2,48(sp)
    80000736:	f44e                	sd	s3,40(sp)
    80000738:	f052                	sd	s4,32(sp)
    8000073a:	ec56                	sd	s5,24(sp)
    8000073c:	e85a                	sd	s6,16(sp)
    8000073e:	e45e                	sd	s7,8(sp)
    80000740:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000742:	03459793          	slli	a5,a1,0x34
    80000746:	e795                	bnez	a5,80000772 <uvmunmap+0x46>
    80000748:	8a2a                	mv	s4,a0
    8000074a:	892e                	mv	s2,a1
    8000074c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000074e:	0632                	slli	a2,a2,0xc
    80000750:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000754:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000756:	6b05                	lui	s6,0x1
    80000758:	0735e263          	bltu	a1,s3,800007bc <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000075c:	60a6                	ld	ra,72(sp)
    8000075e:	6406                	ld	s0,64(sp)
    80000760:	74e2                	ld	s1,56(sp)
    80000762:	7942                	ld	s2,48(sp)
    80000764:	79a2                	ld	s3,40(sp)
    80000766:	7a02                	ld	s4,32(sp)
    80000768:	6ae2                	ld	s5,24(sp)
    8000076a:	6b42                	ld	s6,16(sp)
    8000076c:	6ba2                	ld	s7,8(sp)
    8000076e:	6161                	addi	sp,sp,80
    80000770:	8082                	ret
    panic("uvmunmap: not aligned");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	90e50513          	addi	a0,a0,-1778 # 80008080 <etext+0x80>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	4b6080e7          	jalr	1206(ra) # 80005c30 <panic>
      panic("uvmunmap: walk");
    80000782:	00008517          	auipc	a0,0x8
    80000786:	91650513          	addi	a0,a0,-1770 # 80008098 <etext+0x98>
    8000078a:	00005097          	auipc	ra,0x5
    8000078e:	4a6080e7          	jalr	1190(ra) # 80005c30 <panic>
      panic("uvmunmap: not mapped");
    80000792:	00008517          	auipc	a0,0x8
    80000796:	91650513          	addi	a0,a0,-1770 # 800080a8 <etext+0xa8>
    8000079a:	00005097          	auipc	ra,0x5
    8000079e:	496080e7          	jalr	1174(ra) # 80005c30 <panic>
      panic("uvmunmap: not a leaf");
    800007a2:	00008517          	auipc	a0,0x8
    800007a6:	91e50513          	addi	a0,a0,-1762 # 800080c0 <etext+0xc0>
    800007aa:	00005097          	auipc	ra,0x5
    800007ae:	486080e7          	jalr	1158(ra) # 80005c30 <panic>
    *pte = 0;
    800007b2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007b6:	995a                	add	s2,s2,s6
    800007b8:	fb3972e3          	bgeu	s2,s3,8000075c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007bc:	4601                	li	a2,0
    800007be:	85ca                	mv	a1,s2
    800007c0:	8552                	mv	a0,s4
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	cbc080e7          	jalr	-836(ra) # 8000047e <walk>
    800007ca:	84aa                	mv	s1,a0
    800007cc:	d95d                	beqz	a0,80000782 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ce:	6108                	ld	a0,0(a0)
    800007d0:	00157793          	andi	a5,a0,1
    800007d4:	dfdd                	beqz	a5,80000792 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007d6:	3ff57793          	andi	a5,a0,1023
    800007da:	fd7784e3          	beq	a5,s7,800007a2 <uvmunmap+0x76>
    if(do_free){
    800007de:	fc0a8ae3          	beqz	s5,800007b2 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007e2:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e4:	0532                	slli	a0,a0,0xc
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	836080e7          	jalr	-1994(ra) # 8000001c <kfree>
    800007ee:	b7d1                	j	800007b2 <uvmunmap+0x86>

00000000800007f0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007f0:	1101                	addi	sp,sp,-32
    800007f2:	ec06                	sd	ra,24(sp)
    800007f4:	e822                	sd	s0,16(sp)
    800007f6:	e426                	sd	s1,8(sp)
    800007f8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	920080e7          	jalr	-1760(ra) # 8000011a <kalloc>
    80000802:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000804:	c519                	beqz	a0,80000812 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000806:	6605                	lui	a2,0x1
    80000808:	4581                	li	a1,0
    8000080a:	00000097          	auipc	ra,0x0
    8000080e:	994080e7          	jalr	-1644(ra) # 8000019e <memset>
  return pagetable;
}
    80000812:	8526                	mv	a0,s1
    80000814:	60e2                	ld	ra,24(sp)
    80000816:	6442                	ld	s0,16(sp)
    80000818:	64a2                	ld	s1,8(sp)
    8000081a:	6105                	addi	sp,sp,32
    8000081c:	8082                	ret

000000008000081e <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000081e:	7179                	addi	sp,sp,-48
    80000820:	f406                	sd	ra,40(sp)
    80000822:	f022                	sd	s0,32(sp)
    80000824:	ec26                	sd	s1,24(sp)
    80000826:	e84a                	sd	s2,16(sp)
    80000828:	e44e                	sd	s3,8(sp)
    8000082a:	e052                	sd	s4,0(sp)
    8000082c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000082e:	6785                	lui	a5,0x1
    80000830:	04f67863          	bgeu	a2,a5,80000880 <uvminit+0x62>
    80000834:	8a2a                	mv	s4,a0
    80000836:	89ae                	mv	s3,a1
    80000838:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	8e0080e7          	jalr	-1824(ra) # 8000011a <kalloc>
    80000842:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000844:	6605                	lui	a2,0x1
    80000846:	4581                	li	a1,0
    80000848:	00000097          	auipc	ra,0x0
    8000084c:	956080e7          	jalr	-1706(ra) # 8000019e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000850:	4779                	li	a4,30
    80000852:	86ca                	mv	a3,s2
    80000854:	6605                	lui	a2,0x1
    80000856:	4581                	li	a1,0
    80000858:	8552                	mv	a0,s4
    8000085a:	00000097          	auipc	ra,0x0
    8000085e:	d0c080e7          	jalr	-756(ra) # 80000566 <mappages>
  memmove(mem, src, sz);
    80000862:	8626                	mv	a2,s1
    80000864:	85ce                	mv	a1,s3
    80000866:	854a                	mv	a0,s2
    80000868:	00000097          	auipc	ra,0x0
    8000086c:	992080e7          	jalr	-1646(ra) # 800001fa <memmove>
}
    80000870:	70a2                	ld	ra,40(sp)
    80000872:	7402                	ld	s0,32(sp)
    80000874:	64e2                	ld	s1,24(sp)
    80000876:	6942                	ld	s2,16(sp)
    80000878:	69a2                	ld	s3,8(sp)
    8000087a:	6a02                	ld	s4,0(sp)
    8000087c:	6145                	addi	sp,sp,48
    8000087e:	8082                	ret
    panic("inituvm: more than a page");
    80000880:	00008517          	auipc	a0,0x8
    80000884:	85850513          	addi	a0,a0,-1960 # 800080d8 <etext+0xd8>
    80000888:	00005097          	auipc	ra,0x5
    8000088c:	3a8080e7          	jalr	936(ra) # 80005c30 <panic>

0000000080000890 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000890:	1101                	addi	sp,sp,-32
    80000892:	ec06                	sd	ra,24(sp)
    80000894:	e822                	sd	s0,16(sp)
    80000896:	e426                	sd	s1,8(sp)
    80000898:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000089a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000089c:	00b67d63          	bgeu	a2,a1,800008b6 <uvmdealloc+0x26>
    800008a0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008a2:	6785                	lui	a5,0x1
    800008a4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008a6:	00f60733          	add	a4,a2,a5
    800008aa:	76fd                	lui	a3,0xfffff
    800008ac:	8f75                	and	a4,a4,a3
    800008ae:	97ae                	add	a5,a5,a1
    800008b0:	8ff5                	and	a5,a5,a3
    800008b2:	00f76863          	bltu	a4,a5,800008c2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008b6:	8526                	mv	a0,s1
    800008b8:	60e2                	ld	ra,24(sp)
    800008ba:	6442                	ld	s0,16(sp)
    800008bc:	64a2                	ld	s1,8(sp)
    800008be:	6105                	addi	sp,sp,32
    800008c0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008c2:	8f99                	sub	a5,a5,a4
    800008c4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008c6:	4685                	li	a3,1
    800008c8:	0007861b          	sext.w	a2,a5
    800008cc:	85ba                	mv	a1,a4
    800008ce:	00000097          	auipc	ra,0x0
    800008d2:	e5e080e7          	jalr	-418(ra) # 8000072c <uvmunmap>
    800008d6:	b7c5                	j	800008b6 <uvmdealloc+0x26>

00000000800008d8 <uvmalloc>:
  if(newsz < oldsz)
    800008d8:	0ab66163          	bltu	a2,a1,8000097a <uvmalloc+0xa2>
{
    800008dc:	7139                	addi	sp,sp,-64
    800008de:	fc06                	sd	ra,56(sp)
    800008e0:	f822                	sd	s0,48(sp)
    800008e2:	f426                	sd	s1,40(sp)
    800008e4:	f04a                	sd	s2,32(sp)
    800008e6:	ec4e                	sd	s3,24(sp)
    800008e8:	e852                	sd	s4,16(sp)
    800008ea:	e456                	sd	s5,8(sp)
    800008ec:	0080                	addi	s0,sp,64
    800008ee:	8aaa                	mv	s5,a0
    800008f0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008f2:	6785                	lui	a5,0x1
    800008f4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008f6:	95be                	add	a1,a1,a5
    800008f8:	77fd                	lui	a5,0xfffff
    800008fa:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008fe:	08c9f063          	bgeu	s3,a2,8000097e <uvmalloc+0xa6>
    80000902:	894e                	mv	s2,s3
    mem = kalloc();
    80000904:	00000097          	auipc	ra,0x0
    80000908:	816080e7          	jalr	-2026(ra) # 8000011a <kalloc>
    8000090c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000090e:	c51d                	beqz	a0,8000093c <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000910:	6605                	lui	a2,0x1
    80000912:	4581                	li	a1,0
    80000914:	00000097          	auipc	ra,0x0
    80000918:	88a080e7          	jalr	-1910(ra) # 8000019e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000091c:	4779                	li	a4,30
    8000091e:	86a6                	mv	a3,s1
    80000920:	6605                	lui	a2,0x1
    80000922:	85ca                	mv	a1,s2
    80000924:	8556                	mv	a0,s5
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	c40080e7          	jalr	-960(ra) # 80000566 <mappages>
    8000092e:	e905                	bnez	a0,8000095e <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000930:	6785                	lui	a5,0x1
    80000932:	993e                	add	s2,s2,a5
    80000934:	fd4968e3          	bltu	s2,s4,80000904 <uvmalloc+0x2c>
  return newsz;
    80000938:	8552                	mv	a0,s4
    8000093a:	a809                	j	8000094c <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000093c:	864e                	mv	a2,s3
    8000093e:	85ca                	mv	a1,s2
    80000940:	8556                	mv	a0,s5
    80000942:	00000097          	auipc	ra,0x0
    80000946:	f4e080e7          	jalr	-178(ra) # 80000890 <uvmdealloc>
      return 0;
    8000094a:	4501                	li	a0,0
}
    8000094c:	70e2                	ld	ra,56(sp)
    8000094e:	7442                	ld	s0,48(sp)
    80000950:	74a2                	ld	s1,40(sp)
    80000952:	7902                	ld	s2,32(sp)
    80000954:	69e2                	ld	s3,24(sp)
    80000956:	6a42                	ld	s4,16(sp)
    80000958:	6aa2                	ld	s5,8(sp)
    8000095a:	6121                	addi	sp,sp,64
    8000095c:	8082                	ret
      kfree(mem);
    8000095e:	8526                	mv	a0,s1
    80000960:	fffff097          	auipc	ra,0xfffff
    80000964:	6bc080e7          	jalr	1724(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000968:	864e                	mv	a2,s3
    8000096a:	85ca                	mv	a1,s2
    8000096c:	8556                	mv	a0,s5
    8000096e:	00000097          	auipc	ra,0x0
    80000972:	f22080e7          	jalr	-222(ra) # 80000890 <uvmdealloc>
      return 0;
    80000976:	4501                	li	a0,0
    80000978:	bfd1                	j	8000094c <uvmalloc+0x74>
    return oldsz;
    8000097a:	852e                	mv	a0,a1
}
    8000097c:	8082                	ret
  return newsz;
    8000097e:	8532                	mv	a0,a2
    80000980:	b7f1                	j	8000094c <uvmalloc+0x74>

0000000080000982 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000982:	7179                	addi	sp,sp,-48
    80000984:	f406                	sd	ra,40(sp)
    80000986:	f022                	sd	s0,32(sp)
    80000988:	ec26                	sd	s1,24(sp)
    8000098a:	e84a                	sd	s2,16(sp)
    8000098c:	e44e                	sd	s3,8(sp)
    8000098e:	e052                	sd	s4,0(sp)
    80000990:	1800                	addi	s0,sp,48
    80000992:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000994:	84aa                	mv	s1,a0
    80000996:	6905                	lui	s2,0x1
    80000998:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000099a:	4985                	li	s3,1
    8000099c:	a829                	j	800009b6 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000099e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009a0:	00c79513          	slli	a0,a5,0xc
    800009a4:	00000097          	auipc	ra,0x0
    800009a8:	fde080e7          	jalr	-34(ra) # 80000982 <freewalk>
      pagetable[i] = 0;
    800009ac:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009b0:	04a1                	addi	s1,s1,8
    800009b2:	03248163          	beq	s1,s2,800009d4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009b6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009b8:	00f7f713          	andi	a4,a5,15
    800009bc:	ff3701e3          	beq	a4,s3,8000099e <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009c0:	8b85                	andi	a5,a5,1
    800009c2:	d7fd                	beqz	a5,800009b0 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009c4:	00007517          	auipc	a0,0x7
    800009c8:	73450513          	addi	a0,a0,1844 # 800080f8 <etext+0xf8>
    800009cc:	00005097          	auipc	ra,0x5
    800009d0:	264080e7          	jalr	612(ra) # 80005c30 <panic>
    }
  }
  kfree((void*)pagetable);
    800009d4:	8552                	mv	a0,s4
    800009d6:	fffff097          	auipc	ra,0xfffff
    800009da:	646080e7          	jalr	1606(ra) # 8000001c <kfree>
}
    800009de:	70a2                	ld	ra,40(sp)
    800009e0:	7402                	ld	s0,32(sp)
    800009e2:	64e2                	ld	s1,24(sp)
    800009e4:	6942                	ld	s2,16(sp)
    800009e6:	69a2                	ld	s3,8(sp)
    800009e8:	6a02                	ld	s4,0(sp)
    800009ea:	6145                	addi	sp,sp,48
    800009ec:	8082                	ret

00000000800009ee <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ee:	1101                	addi	sp,sp,-32
    800009f0:	ec06                	sd	ra,24(sp)
    800009f2:	e822                	sd	s0,16(sp)
    800009f4:	e426                	sd	s1,8(sp)
    800009f6:	1000                	addi	s0,sp,32
    800009f8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009fa:	e999                	bnez	a1,80000a10 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009fc:	8526                	mv	a0,s1
    800009fe:	00000097          	auipc	ra,0x0
    80000a02:	f84080e7          	jalr	-124(ra) # 80000982 <freewalk>
}
    80000a06:	60e2                	ld	ra,24(sp)
    80000a08:	6442                	ld	s0,16(sp)
    80000a0a:	64a2                	ld	s1,8(sp)
    80000a0c:	6105                	addi	sp,sp,32
    80000a0e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a10:	6785                	lui	a5,0x1
    80000a12:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a14:	95be                	add	a1,a1,a5
    80000a16:	4685                	li	a3,1
    80000a18:	00c5d613          	srli	a2,a1,0xc
    80000a1c:	4581                	li	a1,0
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	d0e080e7          	jalr	-754(ra) # 8000072c <uvmunmap>
    80000a26:	bfd9                	j	800009fc <uvmfree+0xe>

0000000080000a28 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a28:	c679                	beqz	a2,80000af6 <uvmcopy+0xce>
{
    80000a2a:	715d                	addi	sp,sp,-80
    80000a2c:	e486                	sd	ra,72(sp)
    80000a2e:	e0a2                	sd	s0,64(sp)
    80000a30:	fc26                	sd	s1,56(sp)
    80000a32:	f84a                	sd	s2,48(sp)
    80000a34:	f44e                	sd	s3,40(sp)
    80000a36:	f052                	sd	s4,32(sp)
    80000a38:	ec56                	sd	s5,24(sp)
    80000a3a:	e85a                	sd	s6,16(sp)
    80000a3c:	e45e                	sd	s7,8(sp)
    80000a3e:	0880                	addi	s0,sp,80
    80000a40:	8b2a                	mv	s6,a0
    80000a42:	8aae                	mv	s5,a1
    80000a44:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a46:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a48:	4601                	li	a2,0
    80000a4a:	85ce                	mv	a1,s3
    80000a4c:	855a                	mv	a0,s6
    80000a4e:	00000097          	auipc	ra,0x0
    80000a52:	a30080e7          	jalr	-1488(ra) # 8000047e <walk>
    80000a56:	c531                	beqz	a0,80000aa2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a58:	6118                	ld	a4,0(a0)
    80000a5a:	00177793          	andi	a5,a4,1
    80000a5e:	cbb1                	beqz	a5,80000ab2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a60:	00a75593          	srli	a1,a4,0xa
    80000a64:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a68:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a6c:	fffff097          	auipc	ra,0xfffff
    80000a70:	6ae080e7          	jalr	1710(ra) # 8000011a <kalloc>
    80000a74:	892a                	mv	s2,a0
    80000a76:	c939                	beqz	a0,80000acc <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a78:	6605                	lui	a2,0x1
    80000a7a:	85de                	mv	a1,s7
    80000a7c:	fffff097          	auipc	ra,0xfffff
    80000a80:	77e080e7          	jalr	1918(ra) # 800001fa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a84:	8726                	mv	a4,s1
    80000a86:	86ca                	mv	a3,s2
    80000a88:	6605                	lui	a2,0x1
    80000a8a:	85ce                	mv	a1,s3
    80000a8c:	8556                	mv	a0,s5
    80000a8e:	00000097          	auipc	ra,0x0
    80000a92:	ad8080e7          	jalr	-1320(ra) # 80000566 <mappages>
    80000a96:	e515                	bnez	a0,80000ac2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a98:	6785                	lui	a5,0x1
    80000a9a:	99be                	add	s3,s3,a5
    80000a9c:	fb49e6e3          	bltu	s3,s4,80000a48 <uvmcopy+0x20>
    80000aa0:	a081                	j	80000ae0 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aa2:	00007517          	auipc	a0,0x7
    80000aa6:	66650513          	addi	a0,a0,1638 # 80008108 <etext+0x108>
    80000aaa:	00005097          	auipc	ra,0x5
    80000aae:	186080e7          	jalr	390(ra) # 80005c30 <panic>
      panic("uvmcopy: page not present");
    80000ab2:	00007517          	auipc	a0,0x7
    80000ab6:	67650513          	addi	a0,a0,1654 # 80008128 <etext+0x128>
    80000aba:	00005097          	auipc	ra,0x5
    80000abe:	176080e7          	jalr	374(ra) # 80005c30 <panic>
      kfree(mem);
    80000ac2:	854a                	mv	a0,s2
    80000ac4:	fffff097          	auipc	ra,0xfffff
    80000ac8:	558080e7          	jalr	1368(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000acc:	4685                	li	a3,1
    80000ace:	00c9d613          	srli	a2,s3,0xc
    80000ad2:	4581                	li	a1,0
    80000ad4:	8556                	mv	a0,s5
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	c56080e7          	jalr	-938(ra) # 8000072c <uvmunmap>
  return -1;
    80000ade:	557d                	li	a0,-1
}
    80000ae0:	60a6                	ld	ra,72(sp)
    80000ae2:	6406                	ld	s0,64(sp)
    80000ae4:	74e2                	ld	s1,56(sp)
    80000ae6:	7942                	ld	s2,48(sp)
    80000ae8:	79a2                	ld	s3,40(sp)
    80000aea:	7a02                	ld	s4,32(sp)
    80000aec:	6ae2                	ld	s5,24(sp)
    80000aee:	6b42                	ld	s6,16(sp)
    80000af0:	6ba2                	ld	s7,8(sp)
    80000af2:	6161                	addi	sp,sp,80
    80000af4:	8082                	ret
  return 0;
    80000af6:	4501                	li	a0,0
}
    80000af8:	8082                	ret

0000000080000afa <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000afa:	1141                	addi	sp,sp,-16
    80000afc:	e406                	sd	ra,8(sp)
    80000afe:	e022                	sd	s0,0(sp)
    80000b00:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b02:	4601                	li	a2,0
    80000b04:	00000097          	auipc	ra,0x0
    80000b08:	97a080e7          	jalr	-1670(ra) # 8000047e <walk>
  if(pte == 0)
    80000b0c:	c901                	beqz	a0,80000b1c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b0e:	611c                	ld	a5,0(a0)
    80000b10:	9bbd                	andi	a5,a5,-17
    80000b12:	e11c                	sd	a5,0(a0)
}
    80000b14:	60a2                	ld	ra,8(sp)
    80000b16:	6402                	ld	s0,0(sp)
    80000b18:	0141                	addi	sp,sp,16
    80000b1a:	8082                	ret
    panic("uvmclear");
    80000b1c:	00007517          	auipc	a0,0x7
    80000b20:	62c50513          	addi	a0,a0,1580 # 80008148 <etext+0x148>
    80000b24:	00005097          	auipc	ra,0x5
    80000b28:	10c080e7          	jalr	268(ra) # 80005c30 <panic>

0000000080000b2c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b2c:	c6bd                	beqz	a3,80000b9a <copyout+0x6e>
{
    80000b2e:	715d                	addi	sp,sp,-80
    80000b30:	e486                	sd	ra,72(sp)
    80000b32:	e0a2                	sd	s0,64(sp)
    80000b34:	fc26                	sd	s1,56(sp)
    80000b36:	f84a                	sd	s2,48(sp)
    80000b38:	f44e                	sd	s3,40(sp)
    80000b3a:	f052                	sd	s4,32(sp)
    80000b3c:	ec56                	sd	s5,24(sp)
    80000b3e:	e85a                	sd	s6,16(sp)
    80000b40:	e45e                	sd	s7,8(sp)
    80000b42:	e062                	sd	s8,0(sp)
    80000b44:	0880                	addi	s0,sp,80
    80000b46:	8b2a                	mv	s6,a0
    80000b48:	8c2e                	mv	s8,a1
    80000b4a:	8a32                	mv	s4,a2
    80000b4c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b4e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b50:	6a85                	lui	s5,0x1
    80000b52:	a015                	j	80000b76 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b54:	9562                	add	a0,a0,s8
    80000b56:	0004861b          	sext.w	a2,s1
    80000b5a:	85d2                	mv	a1,s4
    80000b5c:	41250533          	sub	a0,a0,s2
    80000b60:	fffff097          	auipc	ra,0xfffff
    80000b64:	69a080e7          	jalr	1690(ra) # 800001fa <memmove>

    len -= n;
    80000b68:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b6c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b6e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b72:	02098263          	beqz	s3,80000b96 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b76:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b7a:	85ca                	mv	a1,s2
    80000b7c:	855a                	mv	a0,s6
    80000b7e:	00000097          	auipc	ra,0x0
    80000b82:	9a6080e7          	jalr	-1626(ra) # 80000524 <walkaddr>
    if(pa0 == 0)
    80000b86:	cd01                	beqz	a0,80000b9e <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b88:	418904b3          	sub	s1,s2,s8
    80000b8c:	94d6                	add	s1,s1,s5
    80000b8e:	fc99f3e3          	bgeu	s3,s1,80000b54 <copyout+0x28>
    80000b92:	84ce                	mv	s1,s3
    80000b94:	b7c1                	j	80000b54 <copyout+0x28>
  }
  return 0;
    80000b96:	4501                	li	a0,0
    80000b98:	a021                	j	80000ba0 <copyout+0x74>
    80000b9a:	4501                	li	a0,0
}
    80000b9c:	8082                	ret
      return -1;
    80000b9e:	557d                	li	a0,-1
}
    80000ba0:	60a6                	ld	ra,72(sp)
    80000ba2:	6406                	ld	s0,64(sp)
    80000ba4:	74e2                	ld	s1,56(sp)
    80000ba6:	7942                	ld	s2,48(sp)
    80000ba8:	79a2                	ld	s3,40(sp)
    80000baa:	7a02                	ld	s4,32(sp)
    80000bac:	6ae2                	ld	s5,24(sp)
    80000bae:	6b42                	ld	s6,16(sp)
    80000bb0:	6ba2                	ld	s7,8(sp)
    80000bb2:	6c02                	ld	s8,0(sp)
    80000bb4:	6161                	addi	sp,sp,80
    80000bb6:	8082                	ret

0000000080000bb8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bb8:	caa5                	beqz	a3,80000c28 <copyin+0x70>
{
    80000bba:	715d                	addi	sp,sp,-80
    80000bbc:	e486                	sd	ra,72(sp)
    80000bbe:	e0a2                	sd	s0,64(sp)
    80000bc0:	fc26                	sd	s1,56(sp)
    80000bc2:	f84a                	sd	s2,48(sp)
    80000bc4:	f44e                	sd	s3,40(sp)
    80000bc6:	f052                	sd	s4,32(sp)
    80000bc8:	ec56                	sd	s5,24(sp)
    80000bca:	e85a                	sd	s6,16(sp)
    80000bcc:	e45e                	sd	s7,8(sp)
    80000bce:	e062                	sd	s8,0(sp)
    80000bd0:	0880                	addi	s0,sp,80
    80000bd2:	8b2a                	mv	s6,a0
    80000bd4:	8a2e                	mv	s4,a1
    80000bd6:	8c32                	mv	s8,a2
    80000bd8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bda:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bdc:	6a85                	lui	s5,0x1
    80000bde:	a01d                	j	80000c04 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000be0:	018505b3          	add	a1,a0,s8
    80000be4:	0004861b          	sext.w	a2,s1
    80000be8:	412585b3          	sub	a1,a1,s2
    80000bec:	8552                	mv	a0,s4
    80000bee:	fffff097          	auipc	ra,0xfffff
    80000bf2:	60c080e7          	jalr	1548(ra) # 800001fa <memmove>

    len -= n;
    80000bf6:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bfa:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bfc:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c00:	02098263          	beqz	s3,80000c24 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c04:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c08:	85ca                	mv	a1,s2
    80000c0a:	855a                	mv	a0,s6
    80000c0c:	00000097          	auipc	ra,0x0
    80000c10:	918080e7          	jalr	-1768(ra) # 80000524 <walkaddr>
    if(pa0 == 0)
    80000c14:	cd01                	beqz	a0,80000c2c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c16:	418904b3          	sub	s1,s2,s8
    80000c1a:	94d6                	add	s1,s1,s5
    80000c1c:	fc99f2e3          	bgeu	s3,s1,80000be0 <copyin+0x28>
    80000c20:	84ce                	mv	s1,s3
    80000c22:	bf7d                	j	80000be0 <copyin+0x28>
  }
  return 0;
    80000c24:	4501                	li	a0,0
    80000c26:	a021                	j	80000c2e <copyin+0x76>
    80000c28:	4501                	li	a0,0
}
    80000c2a:	8082                	ret
      return -1;
    80000c2c:	557d                	li	a0,-1
}
    80000c2e:	60a6                	ld	ra,72(sp)
    80000c30:	6406                	ld	s0,64(sp)
    80000c32:	74e2                	ld	s1,56(sp)
    80000c34:	7942                	ld	s2,48(sp)
    80000c36:	79a2                	ld	s3,40(sp)
    80000c38:	7a02                	ld	s4,32(sp)
    80000c3a:	6ae2                	ld	s5,24(sp)
    80000c3c:	6b42                	ld	s6,16(sp)
    80000c3e:	6ba2                	ld	s7,8(sp)
    80000c40:	6c02                	ld	s8,0(sp)
    80000c42:	6161                	addi	sp,sp,80
    80000c44:	8082                	ret

0000000080000c46 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c46:	c2dd                	beqz	a3,80000cec <copyinstr+0xa6>
{
    80000c48:	715d                	addi	sp,sp,-80
    80000c4a:	e486                	sd	ra,72(sp)
    80000c4c:	e0a2                	sd	s0,64(sp)
    80000c4e:	fc26                	sd	s1,56(sp)
    80000c50:	f84a                	sd	s2,48(sp)
    80000c52:	f44e                	sd	s3,40(sp)
    80000c54:	f052                	sd	s4,32(sp)
    80000c56:	ec56                	sd	s5,24(sp)
    80000c58:	e85a                	sd	s6,16(sp)
    80000c5a:	e45e                	sd	s7,8(sp)
    80000c5c:	0880                	addi	s0,sp,80
    80000c5e:	8a2a                	mv	s4,a0
    80000c60:	8b2e                	mv	s6,a1
    80000c62:	8bb2                	mv	s7,a2
    80000c64:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c66:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c68:	6985                	lui	s3,0x1
    80000c6a:	a02d                	j	80000c94 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c6c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c70:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c72:	37fd                	addiw	a5,a5,-1
    80000c74:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c78:	60a6                	ld	ra,72(sp)
    80000c7a:	6406                	ld	s0,64(sp)
    80000c7c:	74e2                	ld	s1,56(sp)
    80000c7e:	7942                	ld	s2,48(sp)
    80000c80:	79a2                	ld	s3,40(sp)
    80000c82:	7a02                	ld	s4,32(sp)
    80000c84:	6ae2                	ld	s5,24(sp)
    80000c86:	6b42                	ld	s6,16(sp)
    80000c88:	6ba2                	ld	s7,8(sp)
    80000c8a:	6161                	addi	sp,sp,80
    80000c8c:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c8e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c92:	c8a9                	beqz	s1,80000ce4 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c94:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c98:	85ca                	mv	a1,s2
    80000c9a:	8552                	mv	a0,s4
    80000c9c:	00000097          	auipc	ra,0x0
    80000ca0:	888080e7          	jalr	-1912(ra) # 80000524 <walkaddr>
    if(pa0 == 0)
    80000ca4:	c131                	beqz	a0,80000ce8 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000ca6:	417906b3          	sub	a3,s2,s7
    80000caa:	96ce                	add	a3,a3,s3
    80000cac:	00d4f363          	bgeu	s1,a3,80000cb2 <copyinstr+0x6c>
    80000cb0:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cb2:	955e                	add	a0,a0,s7
    80000cb4:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cb8:	daf9                	beqz	a3,80000c8e <copyinstr+0x48>
    80000cba:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cbc:	41650633          	sub	a2,a0,s6
    80000cc0:	fff48593          	addi	a1,s1,-1
    80000cc4:	95da                	add	a1,a1,s6
    while(n > 0){
    80000cc6:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000cc8:	00f60733          	add	a4,a2,a5
    80000ccc:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cd0:	df51                	beqz	a4,80000c6c <copyinstr+0x26>
        *dst = *p;
    80000cd2:	00e78023          	sb	a4,0(a5)
      --max;
    80000cd6:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cda:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cdc:	fed796e3          	bne	a5,a3,80000cc8 <copyinstr+0x82>
      dst++;
    80000ce0:	8b3e                	mv	s6,a5
    80000ce2:	b775                	j	80000c8e <copyinstr+0x48>
    80000ce4:	4781                	li	a5,0
    80000ce6:	b771                	j	80000c72 <copyinstr+0x2c>
      return -1;
    80000ce8:	557d                	li	a0,-1
    80000cea:	b779                	j	80000c78 <copyinstr+0x32>
  int got_null = 0;
    80000cec:	4781                	li	a5,0
  if(got_null){
    80000cee:	37fd                	addiw	a5,a5,-1
    80000cf0:	0007851b          	sext.w	a0,a5
}
    80000cf4:	8082                	ret

0000000080000cf6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cf6:	7139                	addi	sp,sp,-64
    80000cf8:	fc06                	sd	ra,56(sp)
    80000cfa:	f822                	sd	s0,48(sp)
    80000cfc:	f426                	sd	s1,40(sp)
    80000cfe:	f04a                	sd	s2,32(sp)
    80000d00:	ec4e                	sd	s3,24(sp)
    80000d02:	e852                	sd	s4,16(sp)
    80000d04:	e456                	sd	s5,8(sp)
    80000d06:	e05a                	sd	s6,0(sp)
    80000d08:	0080                	addi	s0,sp,64
    80000d0a:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	00008497          	auipc	s1,0x8
    80000d10:	77448493          	addi	s1,s1,1908 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d14:	8b26                	mv	s6,s1
    80000d16:	00007a97          	auipc	s5,0x7
    80000d1a:	2eaa8a93          	addi	s5,s5,746 # 80008000 <etext>
    80000d1e:	04000937          	lui	s2,0x4000
    80000d22:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d24:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d26:	0000ea17          	auipc	s4,0xe
    80000d2a:	35aa0a13          	addi	s4,s4,858 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000d2e:	fffff097          	auipc	ra,0xfffff
    80000d32:	3ec080e7          	jalr	1004(ra) # 8000011a <kalloc>
    80000d36:	862a                	mv	a2,a0
    if(pa == 0)
    80000d38:	c131                	beqz	a0,80000d7c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d3a:	416485b3          	sub	a1,s1,s6
    80000d3e:	8591                	srai	a1,a1,0x4
    80000d40:	000ab783          	ld	a5,0(s5)
    80000d44:	02f585b3          	mul	a1,a1,a5
    80000d48:	2585                	addiw	a1,a1,1
    80000d4a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d4e:	4719                	li	a4,6
    80000d50:	6685                	lui	a3,0x1
    80000d52:	40b905b3          	sub	a1,s2,a1
    80000d56:	854e                	mv	a0,s3
    80000d58:	00000097          	auipc	ra,0x0
    80000d5c:	8ae080e7          	jalr	-1874(ra) # 80000606 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d60:	17048493          	addi	s1,s1,368
    80000d64:	fd4495e3          	bne	s1,s4,80000d2e <proc_mapstacks+0x38>
  }
}
    80000d68:	70e2                	ld	ra,56(sp)
    80000d6a:	7442                	ld	s0,48(sp)
    80000d6c:	74a2                	ld	s1,40(sp)
    80000d6e:	7902                	ld	s2,32(sp)
    80000d70:	69e2                	ld	s3,24(sp)
    80000d72:	6a42                	ld	s4,16(sp)
    80000d74:	6aa2                	ld	s5,8(sp)
    80000d76:	6b02                	ld	s6,0(sp)
    80000d78:	6121                	addi	sp,sp,64
    80000d7a:	8082                	ret
      panic("kalloc");
    80000d7c:	00007517          	auipc	a0,0x7
    80000d80:	3dc50513          	addi	a0,a0,988 # 80008158 <etext+0x158>
    80000d84:	00005097          	auipc	ra,0x5
    80000d88:	eac080e7          	jalr	-340(ra) # 80005c30 <panic>

0000000080000d8c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d8c:	7139                	addi	sp,sp,-64
    80000d8e:	fc06                	sd	ra,56(sp)
    80000d90:	f822                	sd	s0,48(sp)
    80000d92:	f426                	sd	s1,40(sp)
    80000d94:	f04a                	sd	s2,32(sp)
    80000d96:	ec4e                	sd	s3,24(sp)
    80000d98:	e852                	sd	s4,16(sp)
    80000d9a:	e456                	sd	s5,8(sp)
    80000d9c:	e05a                	sd	s6,0(sp)
    80000d9e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000da0:	00007597          	auipc	a1,0x7
    80000da4:	3c058593          	addi	a1,a1,960 # 80008160 <etext+0x160>
    80000da8:	00008517          	auipc	a0,0x8
    80000dac:	2a850513          	addi	a0,a0,680 # 80009050 <pid_lock>
    80000db0:	00005097          	auipc	ra,0x5
    80000db4:	328080e7          	jalr	808(ra) # 800060d8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000db8:	00007597          	auipc	a1,0x7
    80000dbc:	3b058593          	addi	a1,a1,944 # 80008168 <etext+0x168>
    80000dc0:	00008517          	auipc	a0,0x8
    80000dc4:	2a850513          	addi	a0,a0,680 # 80009068 <wait_lock>
    80000dc8:	00005097          	auipc	ra,0x5
    80000dcc:	310080e7          	jalr	784(ra) # 800060d8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd0:	00008497          	auipc	s1,0x8
    80000dd4:	6b048493          	addi	s1,s1,1712 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dd8:	00007b17          	auipc	s6,0x7
    80000ddc:	3a0b0b13          	addi	s6,s6,928 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000de0:	8aa6                	mv	s5,s1
    80000de2:	00007a17          	auipc	s4,0x7
    80000de6:	21ea0a13          	addi	s4,s4,542 # 80008000 <etext>
    80000dea:	04000937          	lui	s2,0x4000
    80000dee:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000df0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df2:	0000e997          	auipc	s3,0xe
    80000df6:	28e98993          	addi	s3,s3,654 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000dfa:	85da                	mv	a1,s6
    80000dfc:	8526                	mv	a0,s1
    80000dfe:	00005097          	auipc	ra,0x5
    80000e02:	2da080e7          	jalr	730(ra) # 800060d8 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e06:	415487b3          	sub	a5,s1,s5
    80000e0a:	8791                	srai	a5,a5,0x4
    80000e0c:	000a3703          	ld	a4,0(s4)
    80000e10:	02e787b3          	mul	a5,a5,a4
    80000e14:	2785                	addiw	a5,a5,1
    80000e16:	00d7979b          	slliw	a5,a5,0xd
    80000e1a:	40f907b3          	sub	a5,s2,a5
    80000e1e:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e20:	17048493          	addi	s1,s1,368
    80000e24:	fd349be3          	bne	s1,s3,80000dfa <procinit+0x6e>
  }
}
    80000e28:	70e2                	ld	ra,56(sp)
    80000e2a:	7442                	ld	s0,48(sp)
    80000e2c:	74a2                	ld	s1,40(sp)
    80000e2e:	7902                	ld	s2,32(sp)
    80000e30:	69e2                	ld	s3,24(sp)
    80000e32:	6a42                	ld	s4,16(sp)
    80000e34:	6aa2                	ld	s5,8(sp)
    80000e36:	6b02                	ld	s6,0(sp)
    80000e38:	6121                	addi	sp,sp,64
    80000e3a:	8082                	ret

0000000080000e3c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e3c:	1141                	addi	sp,sp,-16
    80000e3e:	e422                	sd	s0,8(sp)
    80000e40:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e42:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e44:	2501                	sext.w	a0,a0
    80000e46:	6422                	ld	s0,8(sp)
    80000e48:	0141                	addi	sp,sp,16
    80000e4a:	8082                	ret

0000000080000e4c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e4c:	1141                	addi	sp,sp,-16
    80000e4e:	e422                	sd	s0,8(sp)
    80000e50:	0800                	addi	s0,sp,16
    80000e52:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e54:	2781                	sext.w	a5,a5
    80000e56:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e58:	00008517          	auipc	a0,0x8
    80000e5c:	22850513          	addi	a0,a0,552 # 80009080 <cpus>
    80000e60:	953e                	add	a0,a0,a5
    80000e62:	6422                	ld	s0,8(sp)
    80000e64:	0141                	addi	sp,sp,16
    80000e66:	8082                	ret

0000000080000e68 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e68:	1101                	addi	sp,sp,-32
    80000e6a:	ec06                	sd	ra,24(sp)
    80000e6c:	e822                	sd	s0,16(sp)
    80000e6e:	e426                	sd	s1,8(sp)
    80000e70:	1000                	addi	s0,sp,32
  push_off();
    80000e72:	00005097          	auipc	ra,0x5
    80000e76:	2aa080e7          	jalr	682(ra) # 8000611c <push_off>
    80000e7a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e7c:	2781                	sext.w	a5,a5
    80000e7e:	079e                	slli	a5,a5,0x7
    80000e80:	00008717          	auipc	a4,0x8
    80000e84:	1d070713          	addi	a4,a4,464 # 80009050 <pid_lock>
    80000e88:	97ba                	add	a5,a5,a4
    80000e8a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e8c:	00005097          	auipc	ra,0x5
    80000e90:	330080e7          	jalr	816(ra) # 800061bc <pop_off>
  return p;
}
    80000e94:	8526                	mv	a0,s1
    80000e96:	60e2                	ld	ra,24(sp)
    80000e98:	6442                	ld	s0,16(sp)
    80000e9a:	64a2                	ld	s1,8(sp)
    80000e9c:	6105                	addi	sp,sp,32
    80000e9e:	8082                	ret

0000000080000ea0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ea0:	1141                	addi	sp,sp,-16
    80000ea2:	e406                	sd	ra,8(sp)
    80000ea4:	e022                	sd	s0,0(sp)
    80000ea6:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ea8:	00000097          	auipc	ra,0x0
    80000eac:	fc0080e7          	jalr	-64(ra) # 80000e68 <myproc>
    80000eb0:	00005097          	auipc	ra,0x5
    80000eb4:	36c080e7          	jalr	876(ra) # 8000621c <release>

  if (first) {
    80000eb8:	00008797          	auipc	a5,0x8
    80000ebc:	ad87a783          	lw	a5,-1320(a5) # 80008990 <first.1>
    80000ec0:	eb89                	bnez	a5,80000ed2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ec2:	00001097          	auipc	ra,0x1
    80000ec6:	c72080e7          	jalr	-910(ra) # 80001b34 <usertrapret>
}
    80000eca:	60a2                	ld	ra,8(sp)
    80000ecc:	6402                	ld	s0,0(sp)
    80000ece:	0141                	addi	sp,sp,16
    80000ed0:	8082                	ret
    first = 0;
    80000ed2:	00008797          	auipc	a5,0x8
    80000ed6:	aa07af23          	sw	zero,-1346(a5) # 80008990 <first.1>
    fsinit(ROOTDEV);
    80000eda:	4505                	li	a0,1
    80000edc:	00002097          	auipc	ra,0x2
    80000ee0:	a68080e7          	jalr	-1432(ra) # 80002944 <fsinit>
    80000ee4:	bff9                	j	80000ec2 <forkret+0x22>

0000000080000ee6 <allocpid>:
allocpid() {
    80000ee6:	1101                	addi	sp,sp,-32
    80000ee8:	ec06                	sd	ra,24(sp)
    80000eea:	e822                	sd	s0,16(sp)
    80000eec:	e426                	sd	s1,8(sp)
    80000eee:	e04a                	sd	s2,0(sp)
    80000ef0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ef2:	00008917          	auipc	s2,0x8
    80000ef6:	15e90913          	addi	s2,s2,350 # 80009050 <pid_lock>
    80000efa:	854a                	mv	a0,s2
    80000efc:	00005097          	auipc	ra,0x5
    80000f00:	26c080e7          	jalr	620(ra) # 80006168 <acquire>
  pid = nextpid;
    80000f04:	00008797          	auipc	a5,0x8
    80000f08:	a9078793          	addi	a5,a5,-1392 # 80008994 <nextpid>
    80000f0c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f0e:	0014871b          	addiw	a4,s1,1
    80000f12:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f14:	854a                	mv	a0,s2
    80000f16:	00005097          	auipc	ra,0x5
    80000f1a:	306080e7          	jalr	774(ra) # 8000621c <release>
}
    80000f1e:	8526                	mv	a0,s1
    80000f20:	60e2                	ld	ra,24(sp)
    80000f22:	6442                	ld	s0,16(sp)
    80000f24:	64a2                	ld	s1,8(sp)
    80000f26:	6902                	ld	s2,0(sp)
    80000f28:	6105                	addi	sp,sp,32
    80000f2a:	8082                	ret

0000000080000f2c <proc_pagetable>:
{
    80000f2c:	1101                	addi	sp,sp,-32
    80000f2e:	ec06                	sd	ra,24(sp)
    80000f30:	e822                	sd	s0,16(sp)
    80000f32:	e426                	sd	s1,8(sp)
    80000f34:	e04a                	sd	s2,0(sp)
    80000f36:	1000                	addi	s0,sp,32
    80000f38:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f3a:	00000097          	auipc	ra,0x0
    80000f3e:	8b6080e7          	jalr	-1866(ra) # 800007f0 <uvmcreate>
    80000f42:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f44:	c121                	beqz	a0,80000f84 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f46:	4729                	li	a4,10
    80000f48:	00006697          	auipc	a3,0x6
    80000f4c:	0b868693          	addi	a3,a3,184 # 80007000 <_trampoline>
    80000f50:	6605                	lui	a2,0x1
    80000f52:	040005b7          	lui	a1,0x4000
    80000f56:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f58:	05b2                	slli	a1,a1,0xc
    80000f5a:	fffff097          	auipc	ra,0xfffff
    80000f5e:	60c080e7          	jalr	1548(ra) # 80000566 <mappages>
    80000f62:	02054863          	bltz	a0,80000f92 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f66:	4719                	li	a4,6
    80000f68:	06093683          	ld	a3,96(s2)
    80000f6c:	6605                	lui	a2,0x1
    80000f6e:	020005b7          	lui	a1,0x2000
    80000f72:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f74:	05b6                	slli	a1,a1,0xd
    80000f76:	8526                	mv	a0,s1
    80000f78:	fffff097          	auipc	ra,0xfffff
    80000f7c:	5ee080e7          	jalr	1518(ra) # 80000566 <mappages>
    80000f80:	02054163          	bltz	a0,80000fa2 <proc_pagetable+0x76>
}
    80000f84:	8526                	mv	a0,s1
    80000f86:	60e2                	ld	ra,24(sp)
    80000f88:	6442                	ld	s0,16(sp)
    80000f8a:	64a2                	ld	s1,8(sp)
    80000f8c:	6902                	ld	s2,0(sp)
    80000f8e:	6105                	addi	sp,sp,32
    80000f90:	8082                	ret
    uvmfree(pagetable, 0);
    80000f92:	4581                	li	a1,0
    80000f94:	8526                	mv	a0,s1
    80000f96:	00000097          	auipc	ra,0x0
    80000f9a:	a58080e7          	jalr	-1448(ra) # 800009ee <uvmfree>
    return 0;
    80000f9e:	4481                	li	s1,0
    80000fa0:	b7d5                	j	80000f84 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fa2:	4681                	li	a3,0
    80000fa4:	4605                	li	a2,1
    80000fa6:	040005b7          	lui	a1,0x4000
    80000faa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fac:	05b2                	slli	a1,a1,0xc
    80000fae:	8526                	mv	a0,s1
    80000fb0:	fffff097          	auipc	ra,0xfffff
    80000fb4:	77c080e7          	jalr	1916(ra) # 8000072c <uvmunmap>
    uvmfree(pagetable, 0);
    80000fb8:	4581                	li	a1,0
    80000fba:	8526                	mv	a0,s1
    80000fbc:	00000097          	auipc	ra,0x0
    80000fc0:	a32080e7          	jalr	-1486(ra) # 800009ee <uvmfree>
    return 0;
    80000fc4:	4481                	li	s1,0
    80000fc6:	bf7d                	j	80000f84 <proc_pagetable+0x58>

0000000080000fc8 <proc_freepagetable>:
{
    80000fc8:	1101                	addi	sp,sp,-32
    80000fca:	ec06                	sd	ra,24(sp)
    80000fcc:	e822                	sd	s0,16(sp)
    80000fce:	e426                	sd	s1,8(sp)
    80000fd0:	e04a                	sd	s2,0(sp)
    80000fd2:	1000                	addi	s0,sp,32
    80000fd4:	84aa                	mv	s1,a0
    80000fd6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fd8:	4681                	li	a3,0
    80000fda:	4605                	li	a2,1
    80000fdc:	040005b7          	lui	a1,0x4000
    80000fe0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fe2:	05b2                	slli	a1,a1,0xc
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	748080e7          	jalr	1864(ra) # 8000072c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fec:	4681                	li	a3,0
    80000fee:	4605                	li	a2,1
    80000ff0:	020005b7          	lui	a1,0x2000
    80000ff4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ff6:	05b6                	slli	a1,a1,0xd
    80000ff8:	8526                	mv	a0,s1
    80000ffa:	fffff097          	auipc	ra,0xfffff
    80000ffe:	732080e7          	jalr	1842(ra) # 8000072c <uvmunmap>
  uvmfree(pagetable, sz);
    80001002:	85ca                	mv	a1,s2
    80001004:	8526                	mv	a0,s1
    80001006:	00000097          	auipc	ra,0x0
    8000100a:	9e8080e7          	jalr	-1560(ra) # 800009ee <uvmfree>
}
    8000100e:	60e2                	ld	ra,24(sp)
    80001010:	6442                	ld	s0,16(sp)
    80001012:	64a2                	ld	s1,8(sp)
    80001014:	6902                	ld	s2,0(sp)
    80001016:	6105                	addi	sp,sp,32
    80001018:	8082                	ret

000000008000101a <freeproc>:
{
    8000101a:	1101                	addi	sp,sp,-32
    8000101c:	ec06                	sd	ra,24(sp)
    8000101e:	e822                	sd	s0,16(sp)
    80001020:	e426                	sd	s1,8(sp)
    80001022:	1000                	addi	s0,sp,32
    80001024:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001026:	7128                	ld	a0,96(a0)
    80001028:	c509                	beqz	a0,80001032 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000102a:	fffff097          	auipc	ra,0xfffff
    8000102e:	ff2080e7          	jalr	-14(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001032:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001036:	6ca8                	ld	a0,88(s1)
    80001038:	c511                	beqz	a0,80001044 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000103a:	68ac                	ld	a1,80(s1)
    8000103c:	00000097          	auipc	ra,0x0
    80001040:	f8c080e7          	jalr	-116(ra) # 80000fc8 <proc_freepagetable>
  p->pagetable = 0;
    80001044:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001048:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    8000104c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001050:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001054:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001058:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000105c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001060:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001064:	0004ac23          	sw	zero,24(s1)
}
    80001068:	60e2                	ld	ra,24(sp)
    8000106a:	6442                	ld	s0,16(sp)
    8000106c:	64a2                	ld	s1,8(sp)
    8000106e:	6105                	addi	sp,sp,32
    80001070:	8082                	ret

0000000080001072 <allocproc>:
{
    80001072:	1101                	addi	sp,sp,-32
    80001074:	ec06                	sd	ra,24(sp)
    80001076:	e822                	sd	s0,16(sp)
    80001078:	e426                	sd	s1,8(sp)
    8000107a:	e04a                	sd	s2,0(sp)
    8000107c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000107e:	00008497          	auipc	s1,0x8
    80001082:	40248493          	addi	s1,s1,1026 # 80009480 <proc>
    80001086:	0000e917          	auipc	s2,0xe
    8000108a:	ffa90913          	addi	s2,s2,-6 # 8000f080 <tickslock>
    acquire(&p->lock);
    8000108e:	8526                	mv	a0,s1
    80001090:	00005097          	auipc	ra,0x5
    80001094:	0d8080e7          	jalr	216(ra) # 80006168 <acquire>
    if(p->state == UNUSED) {
    80001098:	4c9c                	lw	a5,24(s1)
    8000109a:	cf81                	beqz	a5,800010b2 <allocproc+0x40>
      release(&p->lock);
    8000109c:	8526                	mv	a0,s1
    8000109e:	00005097          	auipc	ra,0x5
    800010a2:	17e080e7          	jalr	382(ra) # 8000621c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a6:	17048493          	addi	s1,s1,368
    800010aa:	ff2492e3          	bne	s1,s2,8000108e <allocproc+0x1c>
  return 0;
    800010ae:	4481                	li	s1,0
    800010b0:	a889                	j	80001102 <allocproc+0x90>
  p->pid = allocpid();
    800010b2:	00000097          	auipc	ra,0x0
    800010b6:	e34080e7          	jalr	-460(ra) # 80000ee6 <allocpid>
    800010ba:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010bc:	4785                	li	a5,1
    800010be:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010c0:	fffff097          	auipc	ra,0xfffff
    800010c4:	05a080e7          	jalr	90(ra) # 8000011a <kalloc>
    800010c8:	892a                	mv	s2,a0
    800010ca:	f0a8                	sd	a0,96(s1)
    800010cc:	c131                	beqz	a0,80001110 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ce:	8526                	mv	a0,s1
    800010d0:	00000097          	auipc	ra,0x0
    800010d4:	e5c080e7          	jalr	-420(ra) # 80000f2c <proc_pagetable>
    800010d8:	892a                	mv	s2,a0
    800010da:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    800010dc:	c531                	beqz	a0,80001128 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010de:	07000613          	li	a2,112
    800010e2:	4581                	li	a1,0
    800010e4:	06848513          	addi	a0,s1,104
    800010e8:	fffff097          	auipc	ra,0xfffff
    800010ec:	0b6080e7          	jalr	182(ra) # 8000019e <memset>
  p->context.ra = (uint64)forkret;
    800010f0:	00000797          	auipc	a5,0x0
    800010f4:	db078793          	addi	a5,a5,-592 # 80000ea0 <forkret>
    800010f8:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010fa:	64bc                	ld	a5,72(s1)
    800010fc:	6705                	lui	a4,0x1
    800010fe:	97ba                	add	a5,a5,a4
    80001100:	f8bc                	sd	a5,112(s1)
}
    80001102:	8526                	mv	a0,s1
    80001104:	60e2                	ld	ra,24(sp)
    80001106:	6442                	ld	s0,16(sp)
    80001108:	64a2                	ld	s1,8(sp)
    8000110a:	6902                	ld	s2,0(sp)
    8000110c:	6105                	addi	sp,sp,32
    8000110e:	8082                	ret
    freeproc(p);
    80001110:	8526                	mv	a0,s1
    80001112:	00000097          	auipc	ra,0x0
    80001116:	f08080e7          	jalr	-248(ra) # 8000101a <freeproc>
    release(&p->lock);
    8000111a:	8526                	mv	a0,s1
    8000111c:	00005097          	auipc	ra,0x5
    80001120:	100080e7          	jalr	256(ra) # 8000621c <release>
    return 0;
    80001124:	84ca                	mv	s1,s2
    80001126:	bff1                	j	80001102 <allocproc+0x90>
    freeproc(p);
    80001128:	8526                	mv	a0,s1
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	ef0080e7          	jalr	-272(ra) # 8000101a <freeproc>
    release(&p->lock);
    80001132:	8526                	mv	a0,s1
    80001134:	00005097          	auipc	ra,0x5
    80001138:	0e8080e7          	jalr	232(ra) # 8000621c <release>
    return 0;
    8000113c:	84ca                	mv	s1,s2
    8000113e:	b7d1                	j	80001102 <allocproc+0x90>

0000000080001140 <userinit>:
{
    80001140:	1101                	addi	sp,sp,-32
    80001142:	ec06                	sd	ra,24(sp)
    80001144:	e822                	sd	s0,16(sp)
    80001146:	e426                	sd	s1,8(sp)
    80001148:	1000                	addi	s0,sp,32
  p = allocproc();
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	f28080e7          	jalr	-216(ra) # 80001072 <allocproc>
    80001152:	84aa                	mv	s1,a0
  initproc = p;
    80001154:	00008797          	auipc	a5,0x8
    80001158:	eaa7be23          	sd	a0,-324(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000115c:	03400613          	li	a2,52
    80001160:	00008597          	auipc	a1,0x8
    80001164:	84058593          	addi	a1,a1,-1984 # 800089a0 <initcode>
    80001168:	6d28                	ld	a0,88(a0)
    8000116a:	fffff097          	auipc	ra,0xfffff
    8000116e:	6b4080e7          	jalr	1716(ra) # 8000081e <uvminit>
  p->sz = PGSIZE;
    80001172:	6785                	lui	a5,0x1
    80001174:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001176:	70b8                	ld	a4,96(s1)
    80001178:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000117c:	70b8                	ld	a4,96(s1)
    8000117e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001180:	4641                	li	a2,16
    80001182:	00007597          	auipc	a1,0x7
    80001186:	ffe58593          	addi	a1,a1,-2 # 80008180 <etext+0x180>
    8000118a:	16048513          	addi	a0,s1,352
    8000118e:	fffff097          	auipc	ra,0xfffff
    80001192:	15a080e7          	jalr	346(ra) # 800002e8 <safestrcpy>
  p->cwd = namei("/");
    80001196:	00007517          	auipc	a0,0x7
    8000119a:	ffa50513          	addi	a0,a0,-6 # 80008190 <etext+0x190>
    8000119e:	00002097          	auipc	ra,0x2
    800011a2:	1dc080e7          	jalr	476(ra) # 8000337a <namei>
    800011a6:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800011aa:	478d                	li	a5,3
    800011ac:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011ae:	8526                	mv	a0,s1
    800011b0:	00005097          	auipc	ra,0x5
    800011b4:	06c080e7          	jalr	108(ra) # 8000621c <release>
}
    800011b8:	60e2                	ld	ra,24(sp)
    800011ba:	6442                	ld	s0,16(sp)
    800011bc:	64a2                	ld	s1,8(sp)
    800011be:	6105                	addi	sp,sp,32
    800011c0:	8082                	ret

00000000800011c2 <growproc>:
{
    800011c2:	1101                	addi	sp,sp,-32
    800011c4:	ec06                	sd	ra,24(sp)
    800011c6:	e822                	sd	s0,16(sp)
    800011c8:	e426                	sd	s1,8(sp)
    800011ca:	e04a                	sd	s2,0(sp)
    800011cc:	1000                	addi	s0,sp,32
    800011ce:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011d0:	00000097          	auipc	ra,0x0
    800011d4:	c98080e7          	jalr	-872(ra) # 80000e68 <myproc>
    800011d8:	892a                	mv	s2,a0
  sz = p->sz;
    800011da:	692c                	ld	a1,80(a0)
    800011dc:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011e0:	00904f63          	bgtz	s1,800011fe <growproc+0x3c>
  } else if(n < 0){
    800011e4:	0204cd63          	bltz	s1,8000121e <growproc+0x5c>
  p->sz = sz;
    800011e8:	1782                	slli	a5,a5,0x20
    800011ea:	9381                	srli	a5,a5,0x20
    800011ec:	04f93823          	sd	a5,80(s2)
  return 0;
    800011f0:	4501                	li	a0,0
}
    800011f2:	60e2                	ld	ra,24(sp)
    800011f4:	6442                	ld	s0,16(sp)
    800011f6:	64a2                	ld	s1,8(sp)
    800011f8:	6902                	ld	s2,0(sp)
    800011fa:	6105                	addi	sp,sp,32
    800011fc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011fe:	00f4863b          	addw	a2,s1,a5
    80001202:	1602                	slli	a2,a2,0x20
    80001204:	9201                	srli	a2,a2,0x20
    80001206:	1582                	slli	a1,a1,0x20
    80001208:	9181                	srli	a1,a1,0x20
    8000120a:	6d28                	ld	a0,88(a0)
    8000120c:	fffff097          	auipc	ra,0xfffff
    80001210:	6cc080e7          	jalr	1740(ra) # 800008d8 <uvmalloc>
    80001214:	0005079b          	sext.w	a5,a0
    80001218:	fbe1                	bnez	a5,800011e8 <growproc+0x26>
      return -1;
    8000121a:	557d                	li	a0,-1
    8000121c:	bfd9                	j	800011f2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000121e:	00f4863b          	addw	a2,s1,a5
    80001222:	1602                	slli	a2,a2,0x20
    80001224:	9201                	srli	a2,a2,0x20
    80001226:	1582                	slli	a1,a1,0x20
    80001228:	9181                	srli	a1,a1,0x20
    8000122a:	6d28                	ld	a0,88(a0)
    8000122c:	fffff097          	auipc	ra,0xfffff
    80001230:	664080e7          	jalr	1636(ra) # 80000890 <uvmdealloc>
    80001234:	0005079b          	sext.w	a5,a0
    80001238:	bf45                	j	800011e8 <growproc+0x26>

000000008000123a <fork>:
{
    8000123a:	7139                	addi	sp,sp,-64
    8000123c:	fc06                	sd	ra,56(sp)
    8000123e:	f822                	sd	s0,48(sp)
    80001240:	f426                	sd	s1,40(sp)
    80001242:	f04a                	sd	s2,32(sp)
    80001244:	ec4e                	sd	s3,24(sp)
    80001246:	e852                	sd	s4,16(sp)
    80001248:	e456                	sd	s5,8(sp)
    8000124a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	c1c080e7          	jalr	-996(ra) # 80000e68 <myproc>
    80001254:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001256:	00000097          	auipc	ra,0x0
    8000125a:	e1c080e7          	jalr	-484(ra) # 80001072 <allocproc>
    8000125e:	12050063          	beqz	a0,8000137e <fork+0x144>
    80001262:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001264:	050ab603          	ld	a2,80(s5)
    80001268:	6d2c                	ld	a1,88(a0)
    8000126a:	058ab503          	ld	a0,88(s5)
    8000126e:	fffff097          	auipc	ra,0xfffff
    80001272:	7ba080e7          	jalr	1978(ra) # 80000a28 <uvmcopy>
    80001276:	04054863          	bltz	a0,800012c6 <fork+0x8c>
  np->sz = p->sz;
    8000127a:	050ab783          	ld	a5,80(s5)
    8000127e:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    80001282:	060ab683          	ld	a3,96(s5)
    80001286:	87b6                	mv	a5,a3
    80001288:	0609b703          	ld	a4,96(s3)
    8000128c:	12068693          	addi	a3,a3,288
    80001290:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001294:	6788                	ld	a0,8(a5)
    80001296:	6b8c                	ld	a1,16(a5)
    80001298:	6f90                	ld	a2,24(a5)
    8000129a:	01073023          	sd	a6,0(a4)
    8000129e:	e708                	sd	a0,8(a4)
    800012a0:	eb0c                	sd	a1,16(a4)
    800012a2:	ef10                	sd	a2,24(a4)
    800012a4:	02078793          	addi	a5,a5,32
    800012a8:	02070713          	addi	a4,a4,32
    800012ac:	fed792e3          	bne	a5,a3,80001290 <fork+0x56>
  np->trapframe->a0 = 0;
    800012b0:	0609b783          	ld	a5,96(s3)
    800012b4:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012b8:	0d8a8493          	addi	s1,s5,216
    800012bc:	0d898913          	addi	s2,s3,216
    800012c0:	158a8a13          	addi	s4,s5,344
    800012c4:	a00d                	j	800012e6 <fork+0xac>
    freeproc(np);
    800012c6:	854e                	mv	a0,s3
    800012c8:	00000097          	auipc	ra,0x0
    800012cc:	d52080e7          	jalr	-686(ra) # 8000101a <freeproc>
    release(&np->lock);
    800012d0:	854e                	mv	a0,s3
    800012d2:	00005097          	auipc	ra,0x5
    800012d6:	f4a080e7          	jalr	-182(ra) # 8000621c <release>
    return -1;
    800012da:	597d                	li	s2,-1
    800012dc:	a079                	j	8000136a <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800012de:	04a1                	addi	s1,s1,8
    800012e0:	0921                	addi	s2,s2,8
    800012e2:	01448b63          	beq	s1,s4,800012f8 <fork+0xbe>
    if(p->ofile[i])
    800012e6:	6088                	ld	a0,0(s1)
    800012e8:	d97d                	beqz	a0,800012de <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012ea:	00002097          	auipc	ra,0x2
    800012ee:	726080e7          	jalr	1830(ra) # 80003a10 <filedup>
    800012f2:	00a93023          	sd	a0,0(s2)
    800012f6:	b7e5                	j	800012de <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012f8:	158ab503          	ld	a0,344(s5)
    800012fc:	00002097          	auipc	ra,0x2
    80001300:	884080e7          	jalr	-1916(ra) # 80002b80 <idup>
    80001304:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001308:	4641                	li	a2,16
    8000130a:	160a8593          	addi	a1,s5,352
    8000130e:	16098513          	addi	a0,s3,352
    80001312:	fffff097          	auipc	ra,0xfffff
    80001316:	fd6080e7          	jalr	-42(ra) # 800002e8 <safestrcpy>
  pid = np->pid;
    8000131a:	0309a903          	lw	s2,48(s3)
  np->mask = p->mask;//mask进行传值
    8000131e:	040aa783          	lw	a5,64(s5)
    80001322:	04f9a023          	sw	a5,64(s3)
  release(&np->lock);
    80001326:	854e                	mv	a0,s3
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	ef4080e7          	jalr	-268(ra) # 8000621c <release>
  acquire(&wait_lock);
    80001330:	00008497          	auipc	s1,0x8
    80001334:	d3848493          	addi	s1,s1,-712 # 80009068 <wait_lock>
    80001338:	8526                	mv	a0,s1
    8000133a:	00005097          	auipc	ra,0x5
    8000133e:	e2e080e7          	jalr	-466(ra) # 80006168 <acquire>
  np->parent = p;
    80001342:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001346:	8526                	mv	a0,s1
    80001348:	00005097          	auipc	ra,0x5
    8000134c:	ed4080e7          	jalr	-300(ra) # 8000621c <release>
  acquire(&np->lock);
    80001350:	854e                	mv	a0,s3
    80001352:	00005097          	auipc	ra,0x5
    80001356:	e16080e7          	jalr	-490(ra) # 80006168 <acquire>
  np->state = RUNNABLE;
    8000135a:	478d                	li	a5,3
    8000135c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001360:	854e                	mv	a0,s3
    80001362:	00005097          	auipc	ra,0x5
    80001366:	eba080e7          	jalr	-326(ra) # 8000621c <release>
}
    8000136a:	854a                	mv	a0,s2
    8000136c:	70e2                	ld	ra,56(sp)
    8000136e:	7442                	ld	s0,48(sp)
    80001370:	74a2                	ld	s1,40(sp)
    80001372:	7902                	ld	s2,32(sp)
    80001374:	69e2                	ld	s3,24(sp)
    80001376:	6a42                	ld	s4,16(sp)
    80001378:	6aa2                	ld	s5,8(sp)
    8000137a:	6121                	addi	sp,sp,64
    8000137c:	8082                	ret
    return -1;
    8000137e:	597d                	li	s2,-1
    80001380:	b7ed                	j	8000136a <fork+0x130>

0000000080001382 <scheduler>:
{
    80001382:	7139                	addi	sp,sp,-64
    80001384:	fc06                	sd	ra,56(sp)
    80001386:	f822                	sd	s0,48(sp)
    80001388:	f426                	sd	s1,40(sp)
    8000138a:	f04a                	sd	s2,32(sp)
    8000138c:	ec4e                	sd	s3,24(sp)
    8000138e:	e852                	sd	s4,16(sp)
    80001390:	e456                	sd	s5,8(sp)
    80001392:	e05a                	sd	s6,0(sp)
    80001394:	0080                	addi	s0,sp,64
    80001396:	8792                	mv	a5,tp
  int id = r_tp();
    80001398:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000139a:	00779a93          	slli	s5,a5,0x7
    8000139e:	00008717          	auipc	a4,0x8
    800013a2:	cb270713          	addi	a4,a4,-846 # 80009050 <pid_lock>
    800013a6:	9756                	add	a4,a4,s5
    800013a8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ac:	00008717          	auipc	a4,0x8
    800013b0:	cdc70713          	addi	a4,a4,-804 # 80009088 <cpus+0x8>
    800013b4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013b6:	498d                	li	s3,3
        p->state = RUNNING;
    800013b8:	4b11                	li	s6,4
        c->proc = p;
    800013ba:	079e                	slli	a5,a5,0x7
    800013bc:	00008a17          	auipc	s4,0x8
    800013c0:	c94a0a13          	addi	s4,s4,-876 # 80009050 <pid_lock>
    800013c4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013c6:	0000e917          	auipc	s2,0xe
    800013ca:	cba90913          	addi	s2,s2,-838 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013d2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013d6:	10079073          	csrw	sstatus,a5
    800013da:	00008497          	auipc	s1,0x8
    800013de:	0a648493          	addi	s1,s1,166 # 80009480 <proc>
    800013e2:	a811                	j	800013f6 <scheduler+0x74>
      release(&p->lock);
    800013e4:	8526                	mv	a0,s1
    800013e6:	00005097          	auipc	ra,0x5
    800013ea:	e36080e7          	jalr	-458(ra) # 8000621c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ee:	17048493          	addi	s1,s1,368
    800013f2:	fd248ee3          	beq	s1,s2,800013ce <scheduler+0x4c>
      acquire(&p->lock);
    800013f6:	8526                	mv	a0,s1
    800013f8:	00005097          	auipc	ra,0x5
    800013fc:	d70080e7          	jalr	-656(ra) # 80006168 <acquire>
      if(p->state == RUNNABLE) {
    80001400:	4c9c                	lw	a5,24(s1)
    80001402:	ff3791e3          	bne	a5,s3,800013e4 <scheduler+0x62>
        p->state = RUNNING;
    80001406:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000140a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000140e:	06848593          	addi	a1,s1,104
    80001412:	8556                	mv	a0,s5
    80001414:	00000097          	auipc	ra,0x0
    80001418:	676080e7          	jalr	1654(ra) # 80001a8a <swtch>
        c->proc = 0;
    8000141c:	020a3823          	sd	zero,48(s4)
    80001420:	b7d1                	j	800013e4 <scheduler+0x62>

0000000080001422 <sched>:
{
    80001422:	7179                	addi	sp,sp,-48
    80001424:	f406                	sd	ra,40(sp)
    80001426:	f022                	sd	s0,32(sp)
    80001428:	ec26                	sd	s1,24(sp)
    8000142a:	e84a                	sd	s2,16(sp)
    8000142c:	e44e                	sd	s3,8(sp)
    8000142e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001430:	00000097          	auipc	ra,0x0
    80001434:	a38080e7          	jalr	-1480(ra) # 80000e68 <myproc>
    80001438:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000143a:	00005097          	auipc	ra,0x5
    8000143e:	cb4080e7          	jalr	-844(ra) # 800060ee <holding>
    80001442:	c93d                	beqz	a0,800014b8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001444:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001446:	2781                	sext.w	a5,a5
    80001448:	079e                	slli	a5,a5,0x7
    8000144a:	00008717          	auipc	a4,0x8
    8000144e:	c0670713          	addi	a4,a4,-1018 # 80009050 <pid_lock>
    80001452:	97ba                	add	a5,a5,a4
    80001454:	0a87a703          	lw	a4,168(a5)
    80001458:	4785                	li	a5,1
    8000145a:	06f71763          	bne	a4,a5,800014c8 <sched+0xa6>
  if(p->state == RUNNING)
    8000145e:	4c98                	lw	a4,24(s1)
    80001460:	4791                	li	a5,4
    80001462:	06f70b63          	beq	a4,a5,800014d8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001466:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000146a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000146c:	efb5                	bnez	a5,800014e8 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000146e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001470:	00008917          	auipc	s2,0x8
    80001474:	be090913          	addi	s2,s2,-1056 # 80009050 <pid_lock>
    80001478:	2781                	sext.w	a5,a5
    8000147a:	079e                	slli	a5,a5,0x7
    8000147c:	97ca                	add	a5,a5,s2
    8000147e:	0ac7a983          	lw	s3,172(a5)
    80001482:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001484:	2781                	sext.w	a5,a5
    80001486:	079e                	slli	a5,a5,0x7
    80001488:	00008597          	auipc	a1,0x8
    8000148c:	c0058593          	addi	a1,a1,-1024 # 80009088 <cpus+0x8>
    80001490:	95be                	add	a1,a1,a5
    80001492:	06848513          	addi	a0,s1,104
    80001496:	00000097          	auipc	ra,0x0
    8000149a:	5f4080e7          	jalr	1524(ra) # 80001a8a <swtch>
    8000149e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014a0:	2781                	sext.w	a5,a5
    800014a2:	079e                	slli	a5,a5,0x7
    800014a4:	993e                	add	s2,s2,a5
    800014a6:	0b392623          	sw	s3,172(s2)
}
    800014aa:	70a2                	ld	ra,40(sp)
    800014ac:	7402                	ld	s0,32(sp)
    800014ae:	64e2                	ld	s1,24(sp)
    800014b0:	6942                	ld	s2,16(sp)
    800014b2:	69a2                	ld	s3,8(sp)
    800014b4:	6145                	addi	sp,sp,48
    800014b6:	8082                	ret
    panic("sched p->lock");
    800014b8:	00007517          	auipc	a0,0x7
    800014bc:	ce050513          	addi	a0,a0,-800 # 80008198 <etext+0x198>
    800014c0:	00004097          	auipc	ra,0x4
    800014c4:	770080e7          	jalr	1904(ra) # 80005c30 <panic>
    panic("sched locks");
    800014c8:	00007517          	auipc	a0,0x7
    800014cc:	ce050513          	addi	a0,a0,-800 # 800081a8 <etext+0x1a8>
    800014d0:	00004097          	auipc	ra,0x4
    800014d4:	760080e7          	jalr	1888(ra) # 80005c30 <panic>
    panic("sched running");
    800014d8:	00007517          	auipc	a0,0x7
    800014dc:	ce050513          	addi	a0,a0,-800 # 800081b8 <etext+0x1b8>
    800014e0:	00004097          	auipc	ra,0x4
    800014e4:	750080e7          	jalr	1872(ra) # 80005c30 <panic>
    panic("sched interruptible");
    800014e8:	00007517          	auipc	a0,0x7
    800014ec:	ce050513          	addi	a0,a0,-800 # 800081c8 <etext+0x1c8>
    800014f0:	00004097          	auipc	ra,0x4
    800014f4:	740080e7          	jalr	1856(ra) # 80005c30 <panic>

00000000800014f8 <yield>:
{
    800014f8:	1101                	addi	sp,sp,-32
    800014fa:	ec06                	sd	ra,24(sp)
    800014fc:	e822                	sd	s0,16(sp)
    800014fe:	e426                	sd	s1,8(sp)
    80001500:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001502:	00000097          	auipc	ra,0x0
    80001506:	966080e7          	jalr	-1690(ra) # 80000e68 <myproc>
    8000150a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000150c:	00005097          	auipc	ra,0x5
    80001510:	c5c080e7          	jalr	-932(ra) # 80006168 <acquire>
  p->state = RUNNABLE;
    80001514:	478d                	li	a5,3
    80001516:	cc9c                	sw	a5,24(s1)
  sched();
    80001518:	00000097          	auipc	ra,0x0
    8000151c:	f0a080e7          	jalr	-246(ra) # 80001422 <sched>
  release(&p->lock);
    80001520:	8526                	mv	a0,s1
    80001522:	00005097          	auipc	ra,0x5
    80001526:	cfa080e7          	jalr	-774(ra) # 8000621c <release>
}
    8000152a:	60e2                	ld	ra,24(sp)
    8000152c:	6442                	ld	s0,16(sp)
    8000152e:	64a2                	ld	s1,8(sp)
    80001530:	6105                	addi	sp,sp,32
    80001532:	8082                	ret

0000000080001534 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001534:	7179                	addi	sp,sp,-48
    80001536:	f406                	sd	ra,40(sp)
    80001538:	f022                	sd	s0,32(sp)
    8000153a:	ec26                	sd	s1,24(sp)
    8000153c:	e84a                	sd	s2,16(sp)
    8000153e:	e44e                	sd	s3,8(sp)
    80001540:	1800                	addi	s0,sp,48
    80001542:	89aa                	mv	s3,a0
    80001544:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001546:	00000097          	auipc	ra,0x0
    8000154a:	922080e7          	jalr	-1758(ra) # 80000e68 <myproc>
    8000154e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001550:	00005097          	auipc	ra,0x5
    80001554:	c18080e7          	jalr	-1000(ra) # 80006168 <acquire>
  release(lk);
    80001558:	854a                	mv	a0,s2
    8000155a:	00005097          	auipc	ra,0x5
    8000155e:	cc2080e7          	jalr	-830(ra) # 8000621c <release>

  // Go to sleep.
  p->chan = chan;
    80001562:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001566:	4789                	li	a5,2
    80001568:	cc9c                	sw	a5,24(s1)

  sched();
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	eb8080e7          	jalr	-328(ra) # 80001422 <sched>

  // Tidy up.
  p->chan = 0;
    80001572:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001576:	8526                	mv	a0,s1
    80001578:	00005097          	auipc	ra,0x5
    8000157c:	ca4080e7          	jalr	-860(ra) # 8000621c <release>
  acquire(lk);
    80001580:	854a                	mv	a0,s2
    80001582:	00005097          	auipc	ra,0x5
    80001586:	be6080e7          	jalr	-1050(ra) # 80006168 <acquire>
}
    8000158a:	70a2                	ld	ra,40(sp)
    8000158c:	7402                	ld	s0,32(sp)
    8000158e:	64e2                	ld	s1,24(sp)
    80001590:	6942                	ld	s2,16(sp)
    80001592:	69a2                	ld	s3,8(sp)
    80001594:	6145                	addi	sp,sp,48
    80001596:	8082                	ret

0000000080001598 <wait>:
{
    80001598:	715d                	addi	sp,sp,-80
    8000159a:	e486                	sd	ra,72(sp)
    8000159c:	e0a2                	sd	s0,64(sp)
    8000159e:	fc26                	sd	s1,56(sp)
    800015a0:	f84a                	sd	s2,48(sp)
    800015a2:	f44e                	sd	s3,40(sp)
    800015a4:	f052                	sd	s4,32(sp)
    800015a6:	ec56                	sd	s5,24(sp)
    800015a8:	e85a                	sd	s6,16(sp)
    800015aa:	e45e                	sd	s7,8(sp)
    800015ac:	e062                	sd	s8,0(sp)
    800015ae:	0880                	addi	s0,sp,80
    800015b0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015b2:	00000097          	auipc	ra,0x0
    800015b6:	8b6080e7          	jalr	-1866(ra) # 80000e68 <myproc>
    800015ba:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015bc:	00008517          	auipc	a0,0x8
    800015c0:	aac50513          	addi	a0,a0,-1364 # 80009068 <wait_lock>
    800015c4:	00005097          	auipc	ra,0x5
    800015c8:	ba4080e7          	jalr	-1116(ra) # 80006168 <acquire>
    havekids = 0;
    800015cc:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015ce:	4a15                	li	s4,5
        havekids = 1;
    800015d0:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015d2:	0000e997          	auipc	s3,0xe
    800015d6:	aae98993          	addi	s3,s3,-1362 # 8000f080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015da:	00008c17          	auipc	s8,0x8
    800015de:	a8ec0c13          	addi	s8,s8,-1394 # 80009068 <wait_lock>
    havekids = 0;
    800015e2:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015e4:	00008497          	auipc	s1,0x8
    800015e8:	e9c48493          	addi	s1,s1,-356 # 80009480 <proc>
    800015ec:	a0bd                	j	8000165a <wait+0xc2>
          pid = np->pid;
    800015ee:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015f2:	000b0e63          	beqz	s6,8000160e <wait+0x76>
    800015f6:	4691                	li	a3,4
    800015f8:	02c48613          	addi	a2,s1,44
    800015fc:	85da                	mv	a1,s6
    800015fe:	05893503          	ld	a0,88(s2)
    80001602:	fffff097          	auipc	ra,0xfffff
    80001606:	52a080e7          	jalr	1322(ra) # 80000b2c <copyout>
    8000160a:	02054563          	bltz	a0,80001634 <wait+0x9c>
          freeproc(np);
    8000160e:	8526                	mv	a0,s1
    80001610:	00000097          	auipc	ra,0x0
    80001614:	a0a080e7          	jalr	-1526(ra) # 8000101a <freeproc>
          release(&np->lock);
    80001618:	8526                	mv	a0,s1
    8000161a:	00005097          	auipc	ra,0x5
    8000161e:	c02080e7          	jalr	-1022(ra) # 8000621c <release>
          release(&wait_lock);
    80001622:	00008517          	auipc	a0,0x8
    80001626:	a4650513          	addi	a0,a0,-1466 # 80009068 <wait_lock>
    8000162a:	00005097          	auipc	ra,0x5
    8000162e:	bf2080e7          	jalr	-1038(ra) # 8000621c <release>
          return pid;
    80001632:	a09d                	j	80001698 <wait+0x100>
            release(&np->lock);
    80001634:	8526                	mv	a0,s1
    80001636:	00005097          	auipc	ra,0x5
    8000163a:	be6080e7          	jalr	-1050(ra) # 8000621c <release>
            release(&wait_lock);
    8000163e:	00008517          	auipc	a0,0x8
    80001642:	a2a50513          	addi	a0,a0,-1494 # 80009068 <wait_lock>
    80001646:	00005097          	auipc	ra,0x5
    8000164a:	bd6080e7          	jalr	-1066(ra) # 8000621c <release>
            return -1;
    8000164e:	59fd                	li	s3,-1
    80001650:	a0a1                	j	80001698 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001652:	17048493          	addi	s1,s1,368
    80001656:	03348463          	beq	s1,s3,8000167e <wait+0xe6>
      if(np->parent == p){
    8000165a:	7c9c                	ld	a5,56(s1)
    8000165c:	ff279be3          	bne	a5,s2,80001652 <wait+0xba>
        acquire(&np->lock);
    80001660:	8526                	mv	a0,s1
    80001662:	00005097          	auipc	ra,0x5
    80001666:	b06080e7          	jalr	-1274(ra) # 80006168 <acquire>
        if(np->state == ZOMBIE){
    8000166a:	4c9c                	lw	a5,24(s1)
    8000166c:	f94781e3          	beq	a5,s4,800015ee <wait+0x56>
        release(&np->lock);
    80001670:	8526                	mv	a0,s1
    80001672:	00005097          	auipc	ra,0x5
    80001676:	baa080e7          	jalr	-1110(ra) # 8000621c <release>
        havekids = 1;
    8000167a:	8756                	mv	a4,s5
    8000167c:	bfd9                	j	80001652 <wait+0xba>
    if(!havekids || p->killed){
    8000167e:	c701                	beqz	a4,80001686 <wait+0xee>
    80001680:	02892783          	lw	a5,40(s2)
    80001684:	c79d                	beqz	a5,800016b2 <wait+0x11a>
      release(&wait_lock);
    80001686:	00008517          	auipc	a0,0x8
    8000168a:	9e250513          	addi	a0,a0,-1566 # 80009068 <wait_lock>
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	b8e080e7          	jalr	-1138(ra) # 8000621c <release>
      return -1;
    80001696:	59fd                	li	s3,-1
}
    80001698:	854e                	mv	a0,s3
    8000169a:	60a6                	ld	ra,72(sp)
    8000169c:	6406                	ld	s0,64(sp)
    8000169e:	74e2                	ld	s1,56(sp)
    800016a0:	7942                	ld	s2,48(sp)
    800016a2:	79a2                	ld	s3,40(sp)
    800016a4:	7a02                	ld	s4,32(sp)
    800016a6:	6ae2                	ld	s5,24(sp)
    800016a8:	6b42                	ld	s6,16(sp)
    800016aa:	6ba2                	ld	s7,8(sp)
    800016ac:	6c02                	ld	s8,0(sp)
    800016ae:	6161                	addi	sp,sp,80
    800016b0:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016b2:	85e2                	mv	a1,s8
    800016b4:	854a                	mv	a0,s2
    800016b6:	00000097          	auipc	ra,0x0
    800016ba:	e7e080e7          	jalr	-386(ra) # 80001534 <sleep>
    havekids = 0;
    800016be:	b715                	j	800015e2 <wait+0x4a>

00000000800016c0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016c0:	7139                	addi	sp,sp,-64
    800016c2:	fc06                	sd	ra,56(sp)
    800016c4:	f822                	sd	s0,48(sp)
    800016c6:	f426                	sd	s1,40(sp)
    800016c8:	f04a                	sd	s2,32(sp)
    800016ca:	ec4e                	sd	s3,24(sp)
    800016cc:	e852                	sd	s4,16(sp)
    800016ce:	e456                	sd	s5,8(sp)
    800016d0:	0080                	addi	s0,sp,64
    800016d2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016d4:	00008497          	auipc	s1,0x8
    800016d8:	dac48493          	addi	s1,s1,-596 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016dc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016de:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016e0:	0000e917          	auipc	s2,0xe
    800016e4:	9a090913          	addi	s2,s2,-1632 # 8000f080 <tickslock>
    800016e8:	a811                	j	800016fc <wakeup+0x3c>
      }
      release(&p->lock);
    800016ea:	8526                	mv	a0,s1
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	b30080e7          	jalr	-1232(ra) # 8000621c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016f4:	17048493          	addi	s1,s1,368
    800016f8:	03248663          	beq	s1,s2,80001724 <wakeup+0x64>
    if(p != myproc()){
    800016fc:	fffff097          	auipc	ra,0xfffff
    80001700:	76c080e7          	jalr	1900(ra) # 80000e68 <myproc>
    80001704:	fea488e3          	beq	s1,a0,800016f4 <wakeup+0x34>
      acquire(&p->lock);
    80001708:	8526                	mv	a0,s1
    8000170a:	00005097          	auipc	ra,0x5
    8000170e:	a5e080e7          	jalr	-1442(ra) # 80006168 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001712:	4c9c                	lw	a5,24(s1)
    80001714:	fd379be3          	bne	a5,s3,800016ea <wakeup+0x2a>
    80001718:	709c                	ld	a5,32(s1)
    8000171a:	fd4798e3          	bne	a5,s4,800016ea <wakeup+0x2a>
        p->state = RUNNABLE;
    8000171e:	0154ac23          	sw	s5,24(s1)
    80001722:	b7e1                	j	800016ea <wakeup+0x2a>
    }
  }
}
    80001724:	70e2                	ld	ra,56(sp)
    80001726:	7442                	ld	s0,48(sp)
    80001728:	74a2                	ld	s1,40(sp)
    8000172a:	7902                	ld	s2,32(sp)
    8000172c:	69e2                	ld	s3,24(sp)
    8000172e:	6a42                	ld	s4,16(sp)
    80001730:	6aa2                	ld	s5,8(sp)
    80001732:	6121                	addi	sp,sp,64
    80001734:	8082                	ret

0000000080001736 <reparent>:
{
    80001736:	7179                	addi	sp,sp,-48
    80001738:	f406                	sd	ra,40(sp)
    8000173a:	f022                	sd	s0,32(sp)
    8000173c:	ec26                	sd	s1,24(sp)
    8000173e:	e84a                	sd	s2,16(sp)
    80001740:	e44e                	sd	s3,8(sp)
    80001742:	e052                	sd	s4,0(sp)
    80001744:	1800                	addi	s0,sp,48
    80001746:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001748:	00008497          	auipc	s1,0x8
    8000174c:	d3848493          	addi	s1,s1,-712 # 80009480 <proc>
      pp->parent = initproc;
    80001750:	00008a17          	auipc	s4,0x8
    80001754:	8c0a0a13          	addi	s4,s4,-1856 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001758:	0000e997          	auipc	s3,0xe
    8000175c:	92898993          	addi	s3,s3,-1752 # 8000f080 <tickslock>
    80001760:	a029                	j	8000176a <reparent+0x34>
    80001762:	17048493          	addi	s1,s1,368
    80001766:	01348d63          	beq	s1,s3,80001780 <reparent+0x4a>
    if(pp->parent == p){
    8000176a:	7c9c                	ld	a5,56(s1)
    8000176c:	ff279be3          	bne	a5,s2,80001762 <reparent+0x2c>
      pp->parent = initproc;
    80001770:	000a3503          	ld	a0,0(s4)
    80001774:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001776:	00000097          	auipc	ra,0x0
    8000177a:	f4a080e7          	jalr	-182(ra) # 800016c0 <wakeup>
    8000177e:	b7d5                	j	80001762 <reparent+0x2c>
}
    80001780:	70a2                	ld	ra,40(sp)
    80001782:	7402                	ld	s0,32(sp)
    80001784:	64e2                	ld	s1,24(sp)
    80001786:	6942                	ld	s2,16(sp)
    80001788:	69a2                	ld	s3,8(sp)
    8000178a:	6a02                	ld	s4,0(sp)
    8000178c:	6145                	addi	sp,sp,48
    8000178e:	8082                	ret

0000000080001790 <exit>:
{
    80001790:	7179                	addi	sp,sp,-48
    80001792:	f406                	sd	ra,40(sp)
    80001794:	f022                	sd	s0,32(sp)
    80001796:	ec26                	sd	s1,24(sp)
    80001798:	e84a                	sd	s2,16(sp)
    8000179a:	e44e                	sd	s3,8(sp)
    8000179c:	e052                	sd	s4,0(sp)
    8000179e:	1800                	addi	s0,sp,48
    800017a0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017a2:	fffff097          	auipc	ra,0xfffff
    800017a6:	6c6080e7          	jalr	1734(ra) # 80000e68 <myproc>
    800017aa:	89aa                	mv	s3,a0
  if(p == initproc)
    800017ac:	00008797          	auipc	a5,0x8
    800017b0:	8647b783          	ld	a5,-1948(a5) # 80009010 <initproc>
    800017b4:	0d850493          	addi	s1,a0,216
    800017b8:	15850913          	addi	s2,a0,344
    800017bc:	02a79363          	bne	a5,a0,800017e2 <exit+0x52>
    panic("init exiting");
    800017c0:	00007517          	auipc	a0,0x7
    800017c4:	a2050513          	addi	a0,a0,-1504 # 800081e0 <etext+0x1e0>
    800017c8:	00004097          	auipc	ra,0x4
    800017cc:	468080e7          	jalr	1128(ra) # 80005c30 <panic>
      fileclose(f);
    800017d0:	00002097          	auipc	ra,0x2
    800017d4:	292080e7          	jalr	658(ra) # 80003a62 <fileclose>
      p->ofile[fd] = 0;
    800017d8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017dc:	04a1                	addi	s1,s1,8
    800017de:	01248563          	beq	s1,s2,800017e8 <exit+0x58>
    if(p->ofile[fd]){
    800017e2:	6088                	ld	a0,0(s1)
    800017e4:	f575                	bnez	a0,800017d0 <exit+0x40>
    800017e6:	bfdd                	j	800017dc <exit+0x4c>
  begin_op();
    800017e8:	00002097          	auipc	ra,0x2
    800017ec:	db2080e7          	jalr	-590(ra) # 8000359a <begin_op>
  iput(p->cwd);
    800017f0:	1589b503          	ld	a0,344(s3)
    800017f4:	00001097          	auipc	ra,0x1
    800017f8:	584080e7          	jalr	1412(ra) # 80002d78 <iput>
  end_op();
    800017fc:	00002097          	auipc	ra,0x2
    80001800:	e1c080e7          	jalr	-484(ra) # 80003618 <end_op>
  p->cwd = 0;
    80001804:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001808:	00008497          	auipc	s1,0x8
    8000180c:	86048493          	addi	s1,s1,-1952 # 80009068 <wait_lock>
    80001810:	8526                	mv	a0,s1
    80001812:	00005097          	auipc	ra,0x5
    80001816:	956080e7          	jalr	-1706(ra) # 80006168 <acquire>
  reparent(p);
    8000181a:	854e                	mv	a0,s3
    8000181c:	00000097          	auipc	ra,0x0
    80001820:	f1a080e7          	jalr	-230(ra) # 80001736 <reparent>
  wakeup(p->parent);
    80001824:	0389b503          	ld	a0,56(s3)
    80001828:	00000097          	auipc	ra,0x0
    8000182c:	e98080e7          	jalr	-360(ra) # 800016c0 <wakeup>
  acquire(&p->lock);
    80001830:	854e                	mv	a0,s3
    80001832:	00005097          	auipc	ra,0x5
    80001836:	936080e7          	jalr	-1738(ra) # 80006168 <acquire>
  p->xstate = status;
    8000183a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000183e:	4795                	li	a5,5
    80001840:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001844:	8526                	mv	a0,s1
    80001846:	00005097          	auipc	ra,0x5
    8000184a:	9d6080e7          	jalr	-1578(ra) # 8000621c <release>
  sched();
    8000184e:	00000097          	auipc	ra,0x0
    80001852:	bd4080e7          	jalr	-1068(ra) # 80001422 <sched>
  panic("zombie exit");
    80001856:	00007517          	auipc	a0,0x7
    8000185a:	99a50513          	addi	a0,a0,-1638 # 800081f0 <etext+0x1f0>
    8000185e:	00004097          	auipc	ra,0x4
    80001862:	3d2080e7          	jalr	978(ra) # 80005c30 <panic>

0000000080001866 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001866:	7179                	addi	sp,sp,-48
    80001868:	f406                	sd	ra,40(sp)
    8000186a:	f022                	sd	s0,32(sp)
    8000186c:	ec26                	sd	s1,24(sp)
    8000186e:	e84a                	sd	s2,16(sp)
    80001870:	e44e                	sd	s3,8(sp)
    80001872:	1800                	addi	s0,sp,48
    80001874:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001876:	00008497          	auipc	s1,0x8
    8000187a:	c0a48493          	addi	s1,s1,-1014 # 80009480 <proc>
    8000187e:	0000e997          	auipc	s3,0xe
    80001882:	80298993          	addi	s3,s3,-2046 # 8000f080 <tickslock>
    acquire(&p->lock);
    80001886:	8526                	mv	a0,s1
    80001888:	00005097          	auipc	ra,0x5
    8000188c:	8e0080e7          	jalr	-1824(ra) # 80006168 <acquire>
    if(p->pid == pid){
    80001890:	589c                	lw	a5,48(s1)
    80001892:	01278d63          	beq	a5,s2,800018ac <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001896:	8526                	mv	a0,s1
    80001898:	00005097          	auipc	ra,0x5
    8000189c:	984080e7          	jalr	-1660(ra) # 8000621c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018a0:	17048493          	addi	s1,s1,368
    800018a4:	ff3491e3          	bne	s1,s3,80001886 <kill+0x20>
  }
  return -1;
    800018a8:	557d                	li	a0,-1
    800018aa:	a829                	j	800018c4 <kill+0x5e>
      p->killed = 1;
    800018ac:	4785                	li	a5,1
    800018ae:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018b0:	4c98                	lw	a4,24(s1)
    800018b2:	4789                	li	a5,2
    800018b4:	00f70f63          	beq	a4,a5,800018d2 <kill+0x6c>
      release(&p->lock);
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	962080e7          	jalr	-1694(ra) # 8000621c <release>
      return 0;
    800018c2:	4501                	li	a0,0
}
    800018c4:	70a2                	ld	ra,40(sp)
    800018c6:	7402                	ld	s0,32(sp)
    800018c8:	64e2                	ld	s1,24(sp)
    800018ca:	6942                	ld	s2,16(sp)
    800018cc:	69a2                	ld	s3,8(sp)
    800018ce:	6145                	addi	sp,sp,48
    800018d0:	8082                	ret
        p->state = RUNNABLE;
    800018d2:	478d                	li	a5,3
    800018d4:	cc9c                	sw	a5,24(s1)
    800018d6:	b7cd                	j	800018b8 <kill+0x52>

00000000800018d8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018d8:	7179                	addi	sp,sp,-48
    800018da:	f406                	sd	ra,40(sp)
    800018dc:	f022                	sd	s0,32(sp)
    800018de:	ec26                	sd	s1,24(sp)
    800018e0:	e84a                	sd	s2,16(sp)
    800018e2:	e44e                	sd	s3,8(sp)
    800018e4:	e052                	sd	s4,0(sp)
    800018e6:	1800                	addi	s0,sp,48
    800018e8:	84aa                	mv	s1,a0
    800018ea:	892e                	mv	s2,a1
    800018ec:	89b2                	mv	s3,a2
    800018ee:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	578080e7          	jalr	1400(ra) # 80000e68 <myproc>
  if(user_dst){
    800018f8:	c08d                	beqz	s1,8000191a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018fa:	86d2                	mv	a3,s4
    800018fc:	864e                	mv	a2,s3
    800018fe:	85ca                	mv	a1,s2
    80001900:	6d28                	ld	a0,88(a0)
    80001902:	fffff097          	auipc	ra,0xfffff
    80001906:	22a080e7          	jalr	554(ra) # 80000b2c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000190a:	70a2                	ld	ra,40(sp)
    8000190c:	7402                	ld	s0,32(sp)
    8000190e:	64e2                	ld	s1,24(sp)
    80001910:	6942                	ld	s2,16(sp)
    80001912:	69a2                	ld	s3,8(sp)
    80001914:	6a02                	ld	s4,0(sp)
    80001916:	6145                	addi	sp,sp,48
    80001918:	8082                	ret
    memmove((char *)dst, src, len);
    8000191a:	000a061b          	sext.w	a2,s4
    8000191e:	85ce                	mv	a1,s3
    80001920:	854a                	mv	a0,s2
    80001922:	fffff097          	auipc	ra,0xfffff
    80001926:	8d8080e7          	jalr	-1832(ra) # 800001fa <memmove>
    return 0;
    8000192a:	8526                	mv	a0,s1
    8000192c:	bff9                	j	8000190a <either_copyout+0x32>

000000008000192e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000192e:	7179                	addi	sp,sp,-48
    80001930:	f406                	sd	ra,40(sp)
    80001932:	f022                	sd	s0,32(sp)
    80001934:	ec26                	sd	s1,24(sp)
    80001936:	e84a                	sd	s2,16(sp)
    80001938:	e44e                	sd	s3,8(sp)
    8000193a:	e052                	sd	s4,0(sp)
    8000193c:	1800                	addi	s0,sp,48
    8000193e:	892a                	mv	s2,a0
    80001940:	84ae                	mv	s1,a1
    80001942:	89b2                	mv	s3,a2
    80001944:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	522080e7          	jalr	1314(ra) # 80000e68 <myproc>
  if(user_src){
    8000194e:	c08d                	beqz	s1,80001970 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001950:	86d2                	mv	a3,s4
    80001952:	864e                	mv	a2,s3
    80001954:	85ca                	mv	a1,s2
    80001956:	6d28                	ld	a0,88(a0)
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	260080e7          	jalr	608(ra) # 80000bb8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001960:	70a2                	ld	ra,40(sp)
    80001962:	7402                	ld	s0,32(sp)
    80001964:	64e2                	ld	s1,24(sp)
    80001966:	6942                	ld	s2,16(sp)
    80001968:	69a2                	ld	s3,8(sp)
    8000196a:	6a02                	ld	s4,0(sp)
    8000196c:	6145                	addi	sp,sp,48
    8000196e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001970:	000a061b          	sext.w	a2,s4
    80001974:	85ce                	mv	a1,s3
    80001976:	854a                	mv	a0,s2
    80001978:	fffff097          	auipc	ra,0xfffff
    8000197c:	882080e7          	jalr	-1918(ra) # 800001fa <memmove>
    return 0;
    80001980:	8526                	mv	a0,s1
    80001982:	bff9                	j	80001960 <either_copyin+0x32>

0000000080001984 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001984:	715d                	addi	sp,sp,-80
    80001986:	e486                	sd	ra,72(sp)
    80001988:	e0a2                	sd	s0,64(sp)
    8000198a:	fc26                	sd	s1,56(sp)
    8000198c:	f84a                	sd	s2,48(sp)
    8000198e:	f44e                	sd	s3,40(sp)
    80001990:	f052                	sd	s4,32(sp)
    80001992:	ec56                	sd	s5,24(sp)
    80001994:	e85a                	sd	s6,16(sp)
    80001996:	e45e                	sd	s7,8(sp)
    80001998:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000199a:	00006517          	auipc	a0,0x6
    8000199e:	6ae50513          	addi	a0,a0,1710 # 80008048 <etext+0x48>
    800019a2:	00004097          	auipc	ra,0x4
    800019a6:	2d8080e7          	jalr	728(ra) # 80005c7a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019aa:	00008497          	auipc	s1,0x8
    800019ae:	c3648493          	addi	s1,s1,-970 # 800095e0 <proc+0x160>
    800019b2:	0000e917          	auipc	s2,0xe
    800019b6:	82e90913          	addi	s2,s2,-2002 # 8000f1e0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ba:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019bc:	00007997          	auipc	s3,0x7
    800019c0:	84498993          	addi	s3,s3,-1980 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019c4:	00007a97          	auipc	s5,0x7
    800019c8:	844a8a93          	addi	s5,s5,-1980 # 80008208 <etext+0x208>
    printf("\n");
    800019cc:	00006a17          	auipc	s4,0x6
    800019d0:	67ca0a13          	addi	s4,s4,1660 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019d4:	00007b97          	auipc	s7,0x7
    800019d8:	86cb8b93          	addi	s7,s7,-1940 # 80008240 <states.0>
    800019dc:	a00d                	j	800019fe <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019de:	ed06a583          	lw	a1,-304(a3)
    800019e2:	8556                	mv	a0,s5
    800019e4:	00004097          	auipc	ra,0x4
    800019e8:	296080e7          	jalr	662(ra) # 80005c7a <printf>
    printf("\n");
    800019ec:	8552                	mv	a0,s4
    800019ee:	00004097          	auipc	ra,0x4
    800019f2:	28c080e7          	jalr	652(ra) # 80005c7a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019f6:	17048493          	addi	s1,s1,368
    800019fa:	03248263          	beq	s1,s2,80001a1e <procdump+0x9a>
    if(p->state == UNUSED)
    800019fe:	86a6                	mv	a3,s1
    80001a00:	eb84a783          	lw	a5,-328(s1)
    80001a04:	dbed                	beqz	a5,800019f6 <procdump+0x72>
      state = "???";
    80001a06:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a08:	fcfb6be3          	bltu	s6,a5,800019de <procdump+0x5a>
    80001a0c:	02079713          	slli	a4,a5,0x20
    80001a10:	01d75793          	srli	a5,a4,0x1d
    80001a14:	97de                	add	a5,a5,s7
    80001a16:	6390                	ld	a2,0(a5)
    80001a18:	f279                	bnez	a2,800019de <procdump+0x5a>
      state = "???";
    80001a1a:	864e                	mv	a2,s3
    80001a1c:	b7c9                	j	800019de <procdump+0x5a>
  }
}
    80001a1e:	60a6                	ld	ra,72(sp)
    80001a20:	6406                	ld	s0,64(sp)
    80001a22:	74e2                	ld	s1,56(sp)
    80001a24:	7942                	ld	s2,48(sp)
    80001a26:	79a2                	ld	s3,40(sp)
    80001a28:	7a02                	ld	s4,32(sp)
    80001a2a:	6ae2                	ld	s5,24(sp)
    80001a2c:	6b42                	ld	s6,16(sp)
    80001a2e:	6ba2                	ld	s7,8(sp)
    80001a30:	6161                	addi	sp,sp,80
    80001a32:	8082                	ret

0000000080001a34 <nop>:

int nop(void)
{
    80001a34:	7179                	addi	sp,sp,-48
    80001a36:	f406                	sd	ra,40(sp)
    80001a38:	f022                	sd	s0,32(sp)
    80001a3a:	ec26                	sd	s1,24(sp)
    80001a3c:	e84a                	sd	s2,16(sp)
    80001a3e:	e44e                	sd	s3,8(sp)
    80001a40:	1800                	addi	s0,sp,48
    int cnt = 0;
    for (struct proc* p = proc; p < &proc[NPROC];p++)
    80001a42:	00008497          	auipc	s1,0x8
    80001a46:	a3e48493          	addi	s1,s1,-1474 # 80009480 <proc>
    int cnt = 0;
    80001a4a:	4901                	li	s2,0
    for (struct proc* p = proc; p < &proc[NPROC];p++)
    80001a4c:	0000d997          	auipc	s3,0xd
    80001a50:	63498993          	addi	s3,s3,1588 # 8000f080 <tickslock>
    80001a54:	a811                	j	80001a68 <nop+0x34>
    {
        acquire(&p->lock);
        if (UNUSED != p->state)
            cnt++;
        release(&p->lock);
    80001a56:	8526                	mv	a0,s1
    80001a58:	00004097          	auipc	ra,0x4
    80001a5c:	7c4080e7          	jalr	1988(ra) # 8000621c <release>
    for (struct proc* p = proc; p < &proc[NPROC];p++)
    80001a60:	17048493          	addi	s1,s1,368
    80001a64:	01348b63          	beq	s1,s3,80001a7a <nop+0x46>
        acquire(&p->lock);
    80001a68:	8526                	mv	a0,s1
    80001a6a:	00004097          	auipc	ra,0x4
    80001a6e:	6fe080e7          	jalr	1790(ra) # 80006168 <acquire>
        if (UNUSED != p->state)
    80001a72:	4c9c                	lw	a5,24(s1)
    80001a74:	d3ed                	beqz	a5,80001a56 <nop+0x22>
            cnt++;
    80001a76:	2905                	addiw	s2,s2,1
    80001a78:	bff9                	j	80001a56 <nop+0x22>
    }
    return cnt;
}
    80001a7a:	854a                	mv	a0,s2
    80001a7c:	70a2                	ld	ra,40(sp)
    80001a7e:	7402                	ld	s0,32(sp)
    80001a80:	64e2                	ld	s1,24(sp)
    80001a82:	6942                	ld	s2,16(sp)
    80001a84:	69a2                	ld	s3,8(sp)
    80001a86:	6145                	addi	sp,sp,48
    80001a88:	8082                	ret

0000000080001a8a <swtch>:
    80001a8a:	00153023          	sd	ra,0(a0)
    80001a8e:	00253423          	sd	sp,8(a0)
    80001a92:	e900                	sd	s0,16(a0)
    80001a94:	ed04                	sd	s1,24(a0)
    80001a96:	03253023          	sd	s2,32(a0)
    80001a9a:	03353423          	sd	s3,40(a0)
    80001a9e:	03453823          	sd	s4,48(a0)
    80001aa2:	03553c23          	sd	s5,56(a0)
    80001aa6:	05653023          	sd	s6,64(a0)
    80001aaa:	05753423          	sd	s7,72(a0)
    80001aae:	05853823          	sd	s8,80(a0)
    80001ab2:	05953c23          	sd	s9,88(a0)
    80001ab6:	07a53023          	sd	s10,96(a0)
    80001aba:	07b53423          	sd	s11,104(a0)
    80001abe:	0005b083          	ld	ra,0(a1)
    80001ac2:	0085b103          	ld	sp,8(a1)
    80001ac6:	6980                	ld	s0,16(a1)
    80001ac8:	6d84                	ld	s1,24(a1)
    80001aca:	0205b903          	ld	s2,32(a1)
    80001ace:	0285b983          	ld	s3,40(a1)
    80001ad2:	0305ba03          	ld	s4,48(a1)
    80001ad6:	0385ba83          	ld	s5,56(a1)
    80001ada:	0405bb03          	ld	s6,64(a1)
    80001ade:	0485bb83          	ld	s7,72(a1)
    80001ae2:	0505bc03          	ld	s8,80(a1)
    80001ae6:	0585bc83          	ld	s9,88(a1)
    80001aea:	0605bd03          	ld	s10,96(a1)
    80001aee:	0685bd83          	ld	s11,104(a1)
    80001af2:	8082                	ret

0000000080001af4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001af4:	1141                	addi	sp,sp,-16
    80001af6:	e406                	sd	ra,8(sp)
    80001af8:	e022                	sd	s0,0(sp)
    80001afa:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001afc:	00006597          	auipc	a1,0x6
    80001b00:	77458593          	addi	a1,a1,1908 # 80008270 <states.0+0x30>
    80001b04:	0000d517          	auipc	a0,0xd
    80001b08:	57c50513          	addi	a0,a0,1404 # 8000f080 <tickslock>
    80001b0c:	00004097          	auipc	ra,0x4
    80001b10:	5cc080e7          	jalr	1484(ra) # 800060d8 <initlock>
}
    80001b14:	60a2                	ld	ra,8(sp)
    80001b16:	6402                	ld	s0,0(sp)
    80001b18:	0141                	addi	sp,sp,16
    80001b1a:	8082                	ret

0000000080001b1c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b1c:	1141                	addi	sp,sp,-16
    80001b1e:	e422                	sd	s0,8(sp)
    80001b20:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b22:	00003797          	auipc	a5,0x3
    80001b26:	56e78793          	addi	a5,a5,1390 # 80005090 <kernelvec>
    80001b2a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b2e:	6422                	ld	s0,8(sp)
    80001b30:	0141                	addi	sp,sp,16
    80001b32:	8082                	ret

0000000080001b34 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b34:	1141                	addi	sp,sp,-16
    80001b36:	e406                	sd	ra,8(sp)
    80001b38:	e022                	sd	s0,0(sp)
    80001b3a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b3c:	fffff097          	auipc	ra,0xfffff
    80001b40:	32c080e7          	jalr	812(ra) # 80000e68 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b44:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b48:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b4a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b4e:	00005697          	auipc	a3,0x5
    80001b52:	4b268693          	addi	a3,a3,1202 # 80007000 <_trampoline>
    80001b56:	00005717          	auipc	a4,0x5
    80001b5a:	4aa70713          	addi	a4,a4,1194 # 80007000 <_trampoline>
    80001b5e:	8f15                	sub	a4,a4,a3
    80001b60:	040007b7          	lui	a5,0x4000
    80001b64:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b66:	07b2                	slli	a5,a5,0xc
    80001b68:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b6a:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b6e:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b70:	18002673          	csrr	a2,satp
    80001b74:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b76:	7130                	ld	a2,96(a0)
    80001b78:	6538                	ld	a4,72(a0)
    80001b7a:	6585                	lui	a1,0x1
    80001b7c:	972e                	add	a4,a4,a1
    80001b7e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b80:	7138                	ld	a4,96(a0)
    80001b82:	00000617          	auipc	a2,0x0
    80001b86:	13860613          	addi	a2,a2,312 # 80001cba <usertrap>
    80001b8a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b8c:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b8e:	8612                	mv	a2,tp
    80001b90:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b92:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b96:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b9a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b9e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ba2:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ba4:	6f18                	ld	a4,24(a4)
    80001ba6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001baa:	6d2c                	ld	a1,88(a0)
    80001bac:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bae:	00005717          	auipc	a4,0x5
    80001bb2:	4e270713          	addi	a4,a4,1250 # 80007090 <userret>
    80001bb6:	8f15                	sub	a4,a4,a3
    80001bb8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bba:	577d                	li	a4,-1
    80001bbc:	177e                	slli	a4,a4,0x3f
    80001bbe:	8dd9                	or	a1,a1,a4
    80001bc0:	02000537          	lui	a0,0x2000
    80001bc4:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001bc6:	0536                	slli	a0,a0,0xd
    80001bc8:	9782                	jalr	a5
}
    80001bca:	60a2                	ld	ra,8(sp)
    80001bcc:	6402                	ld	s0,0(sp)
    80001bce:	0141                	addi	sp,sp,16
    80001bd0:	8082                	ret

0000000080001bd2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bd2:	1101                	addi	sp,sp,-32
    80001bd4:	ec06                	sd	ra,24(sp)
    80001bd6:	e822                	sd	s0,16(sp)
    80001bd8:	e426                	sd	s1,8(sp)
    80001bda:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bdc:	0000d497          	auipc	s1,0xd
    80001be0:	4a448493          	addi	s1,s1,1188 # 8000f080 <tickslock>
    80001be4:	8526                	mv	a0,s1
    80001be6:	00004097          	auipc	ra,0x4
    80001bea:	582080e7          	jalr	1410(ra) # 80006168 <acquire>
  ticks++;
    80001bee:	00007517          	auipc	a0,0x7
    80001bf2:	42a50513          	addi	a0,a0,1066 # 80009018 <ticks>
    80001bf6:	411c                	lw	a5,0(a0)
    80001bf8:	2785                	addiw	a5,a5,1
    80001bfa:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bfc:	00000097          	auipc	ra,0x0
    80001c00:	ac4080e7          	jalr	-1340(ra) # 800016c0 <wakeup>
  release(&tickslock);
    80001c04:	8526                	mv	a0,s1
    80001c06:	00004097          	auipc	ra,0x4
    80001c0a:	616080e7          	jalr	1558(ra) # 8000621c <release>
}
    80001c0e:	60e2                	ld	ra,24(sp)
    80001c10:	6442                	ld	s0,16(sp)
    80001c12:	64a2                	ld	s1,8(sp)
    80001c14:	6105                	addi	sp,sp,32
    80001c16:	8082                	ret

0000000080001c18 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c18:	1101                	addi	sp,sp,-32
    80001c1a:	ec06                	sd	ra,24(sp)
    80001c1c:	e822                	sd	s0,16(sp)
    80001c1e:	e426                	sd	s1,8(sp)
    80001c20:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c22:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c26:	00074d63          	bltz	a4,80001c40 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c2a:	57fd                	li	a5,-1
    80001c2c:	17fe                	slli	a5,a5,0x3f
    80001c2e:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c30:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c32:	06f70363          	beq	a4,a5,80001c98 <devintr+0x80>
  }
}
    80001c36:	60e2                	ld	ra,24(sp)
    80001c38:	6442                	ld	s0,16(sp)
    80001c3a:	64a2                	ld	s1,8(sp)
    80001c3c:	6105                	addi	sp,sp,32
    80001c3e:	8082                	ret
     (scause & 0xff) == 9){
    80001c40:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001c44:	46a5                	li	a3,9
    80001c46:	fed792e3          	bne	a5,a3,80001c2a <devintr+0x12>
    int irq = plic_claim();
    80001c4a:	00003097          	auipc	ra,0x3
    80001c4e:	54e080e7          	jalr	1358(ra) # 80005198 <plic_claim>
    80001c52:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c54:	47a9                	li	a5,10
    80001c56:	02f50763          	beq	a0,a5,80001c84 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c5a:	4785                	li	a5,1
    80001c5c:	02f50963          	beq	a0,a5,80001c8e <devintr+0x76>
    return 1;
    80001c60:	4505                	li	a0,1
    } else if(irq){
    80001c62:	d8f1                	beqz	s1,80001c36 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c64:	85a6                	mv	a1,s1
    80001c66:	00006517          	auipc	a0,0x6
    80001c6a:	61250513          	addi	a0,a0,1554 # 80008278 <states.0+0x38>
    80001c6e:	00004097          	auipc	ra,0x4
    80001c72:	00c080e7          	jalr	12(ra) # 80005c7a <printf>
      plic_complete(irq);
    80001c76:	8526                	mv	a0,s1
    80001c78:	00003097          	auipc	ra,0x3
    80001c7c:	544080e7          	jalr	1348(ra) # 800051bc <plic_complete>
    return 1;
    80001c80:	4505                	li	a0,1
    80001c82:	bf55                	j	80001c36 <devintr+0x1e>
      uartintr();
    80001c84:	00004097          	auipc	ra,0x4
    80001c88:	404080e7          	jalr	1028(ra) # 80006088 <uartintr>
    80001c8c:	b7ed                	j	80001c76 <devintr+0x5e>
      virtio_disk_intr();
    80001c8e:	00004097          	auipc	ra,0x4
    80001c92:	9ba080e7          	jalr	-1606(ra) # 80005648 <virtio_disk_intr>
    80001c96:	b7c5                	j	80001c76 <devintr+0x5e>
    if(cpuid() == 0){
    80001c98:	fffff097          	auipc	ra,0xfffff
    80001c9c:	1a4080e7          	jalr	420(ra) # 80000e3c <cpuid>
    80001ca0:	c901                	beqz	a0,80001cb0 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ca2:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ca6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ca8:	14479073          	csrw	sip,a5
    return 2;
    80001cac:	4509                	li	a0,2
    80001cae:	b761                	j	80001c36 <devintr+0x1e>
      clockintr();
    80001cb0:	00000097          	auipc	ra,0x0
    80001cb4:	f22080e7          	jalr	-222(ra) # 80001bd2 <clockintr>
    80001cb8:	b7ed                	j	80001ca2 <devintr+0x8a>

0000000080001cba <usertrap>:
{
    80001cba:	1101                	addi	sp,sp,-32
    80001cbc:	ec06                	sd	ra,24(sp)
    80001cbe:	e822                	sd	s0,16(sp)
    80001cc0:	e426                	sd	s1,8(sp)
    80001cc2:	e04a                	sd	s2,0(sp)
    80001cc4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cc6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cca:	1007f793          	andi	a5,a5,256
    80001cce:	e3ad                	bnez	a5,80001d30 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cd0:	00003797          	auipc	a5,0x3
    80001cd4:	3c078793          	addi	a5,a5,960 # 80005090 <kernelvec>
    80001cd8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cdc:	fffff097          	auipc	ra,0xfffff
    80001ce0:	18c080e7          	jalr	396(ra) # 80000e68 <myproc>
    80001ce4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ce6:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ce8:	14102773          	csrr	a4,sepc
    80001cec:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cee:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cf2:	47a1                	li	a5,8
    80001cf4:	04f71c63          	bne	a4,a5,80001d4c <usertrap+0x92>
    if(p->killed)
    80001cf8:	551c                	lw	a5,40(a0)
    80001cfa:	e3b9                	bnez	a5,80001d40 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cfc:	70b8                	ld	a4,96(s1)
    80001cfe:	6f1c                	ld	a5,24(a4)
    80001d00:	0791                	addi	a5,a5,4
    80001d02:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d04:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d08:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d0c:	10079073          	csrw	sstatus,a5
    syscall();
    80001d10:	00000097          	auipc	ra,0x0
    80001d14:	2e0080e7          	jalr	736(ra) # 80001ff0 <syscall>
  if(p->killed)
    80001d18:	549c                	lw	a5,40(s1)
    80001d1a:	ebc1                	bnez	a5,80001daa <usertrap+0xf0>
  usertrapret();
    80001d1c:	00000097          	auipc	ra,0x0
    80001d20:	e18080e7          	jalr	-488(ra) # 80001b34 <usertrapret>
}
    80001d24:	60e2                	ld	ra,24(sp)
    80001d26:	6442                	ld	s0,16(sp)
    80001d28:	64a2                	ld	s1,8(sp)
    80001d2a:	6902                	ld	s2,0(sp)
    80001d2c:	6105                	addi	sp,sp,32
    80001d2e:	8082                	ret
    panic("usertrap: not from user mode");
    80001d30:	00006517          	auipc	a0,0x6
    80001d34:	56850513          	addi	a0,a0,1384 # 80008298 <states.0+0x58>
    80001d38:	00004097          	auipc	ra,0x4
    80001d3c:	ef8080e7          	jalr	-264(ra) # 80005c30 <panic>
      exit(-1);
    80001d40:	557d                	li	a0,-1
    80001d42:	00000097          	auipc	ra,0x0
    80001d46:	a4e080e7          	jalr	-1458(ra) # 80001790 <exit>
    80001d4a:	bf4d                	j	80001cfc <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d4c:	00000097          	auipc	ra,0x0
    80001d50:	ecc080e7          	jalr	-308(ra) # 80001c18 <devintr>
    80001d54:	892a                	mv	s2,a0
    80001d56:	c501                	beqz	a0,80001d5e <usertrap+0xa4>
  if(p->killed)
    80001d58:	549c                	lw	a5,40(s1)
    80001d5a:	c3a1                	beqz	a5,80001d9a <usertrap+0xe0>
    80001d5c:	a815                	j	80001d90 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d5e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d62:	5890                	lw	a2,48(s1)
    80001d64:	00006517          	auipc	a0,0x6
    80001d68:	55450513          	addi	a0,a0,1364 # 800082b8 <states.0+0x78>
    80001d6c:	00004097          	auipc	ra,0x4
    80001d70:	f0e080e7          	jalr	-242(ra) # 80005c7a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d74:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d78:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d7c:	00006517          	auipc	a0,0x6
    80001d80:	56c50513          	addi	a0,a0,1388 # 800082e8 <states.0+0xa8>
    80001d84:	00004097          	auipc	ra,0x4
    80001d88:	ef6080e7          	jalr	-266(ra) # 80005c7a <printf>
    p->killed = 1;
    80001d8c:	4785                	li	a5,1
    80001d8e:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d90:	557d                	li	a0,-1
    80001d92:	00000097          	auipc	ra,0x0
    80001d96:	9fe080e7          	jalr	-1538(ra) # 80001790 <exit>
  if(which_dev == 2)
    80001d9a:	4789                	li	a5,2
    80001d9c:	f8f910e3          	bne	s2,a5,80001d1c <usertrap+0x62>
    yield();
    80001da0:	fffff097          	auipc	ra,0xfffff
    80001da4:	758080e7          	jalr	1880(ra) # 800014f8 <yield>
    80001da8:	bf95                	j	80001d1c <usertrap+0x62>
  int which_dev = 0;
    80001daa:	4901                	li	s2,0
    80001dac:	b7d5                	j	80001d90 <usertrap+0xd6>

0000000080001dae <kerneltrap>:
{
    80001dae:	7179                	addi	sp,sp,-48
    80001db0:	f406                	sd	ra,40(sp)
    80001db2:	f022                	sd	s0,32(sp)
    80001db4:	ec26                	sd	s1,24(sp)
    80001db6:	e84a                	sd	s2,16(sp)
    80001db8:	e44e                	sd	s3,8(sp)
    80001dba:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dbc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dc4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dc8:	1004f793          	andi	a5,s1,256
    80001dcc:	cb85                	beqz	a5,80001dfc <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dce:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dd2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dd4:	ef85                	bnez	a5,80001e0c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dd6:	00000097          	auipc	ra,0x0
    80001dda:	e42080e7          	jalr	-446(ra) # 80001c18 <devintr>
    80001dde:	cd1d                	beqz	a0,80001e1c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001de0:	4789                	li	a5,2
    80001de2:	06f50a63          	beq	a0,a5,80001e56 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001de6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dea:	10049073          	csrw	sstatus,s1
}
    80001dee:	70a2                	ld	ra,40(sp)
    80001df0:	7402                	ld	s0,32(sp)
    80001df2:	64e2                	ld	s1,24(sp)
    80001df4:	6942                	ld	s2,16(sp)
    80001df6:	69a2                	ld	s3,8(sp)
    80001df8:	6145                	addi	sp,sp,48
    80001dfa:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dfc:	00006517          	auipc	a0,0x6
    80001e00:	50c50513          	addi	a0,a0,1292 # 80008308 <states.0+0xc8>
    80001e04:	00004097          	auipc	ra,0x4
    80001e08:	e2c080e7          	jalr	-468(ra) # 80005c30 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e0c:	00006517          	auipc	a0,0x6
    80001e10:	52450513          	addi	a0,a0,1316 # 80008330 <states.0+0xf0>
    80001e14:	00004097          	auipc	ra,0x4
    80001e18:	e1c080e7          	jalr	-484(ra) # 80005c30 <panic>
    printf("scause %p\n", scause);
    80001e1c:	85ce                	mv	a1,s3
    80001e1e:	00006517          	auipc	a0,0x6
    80001e22:	53250513          	addi	a0,a0,1330 # 80008350 <states.0+0x110>
    80001e26:	00004097          	auipc	ra,0x4
    80001e2a:	e54080e7          	jalr	-428(ra) # 80005c7a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e32:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e36:	00006517          	auipc	a0,0x6
    80001e3a:	52a50513          	addi	a0,a0,1322 # 80008360 <states.0+0x120>
    80001e3e:	00004097          	auipc	ra,0x4
    80001e42:	e3c080e7          	jalr	-452(ra) # 80005c7a <printf>
    panic("kerneltrap");
    80001e46:	00006517          	auipc	a0,0x6
    80001e4a:	53250513          	addi	a0,a0,1330 # 80008378 <states.0+0x138>
    80001e4e:	00004097          	auipc	ra,0x4
    80001e52:	de2080e7          	jalr	-542(ra) # 80005c30 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e56:	fffff097          	auipc	ra,0xfffff
    80001e5a:	012080e7          	jalr	18(ra) # 80000e68 <myproc>
    80001e5e:	d541                	beqz	a0,80001de6 <kerneltrap+0x38>
    80001e60:	fffff097          	auipc	ra,0xfffff
    80001e64:	008080e7          	jalr	8(ra) # 80000e68 <myproc>
    80001e68:	4d18                	lw	a4,24(a0)
    80001e6a:	4791                	li	a5,4
    80001e6c:	f6f71de3          	bne	a4,a5,80001de6 <kerneltrap+0x38>
    yield();
    80001e70:	fffff097          	auipc	ra,0xfffff
    80001e74:	688080e7          	jalr	1672(ra) # 800014f8 <yield>
    80001e78:	b7bd                	j	80001de6 <kerneltrap+0x38>

0000000080001e7a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e7a:	1101                	addi	sp,sp,-32
    80001e7c:	ec06                	sd	ra,24(sp)
    80001e7e:	e822                	sd	s0,16(sp)
    80001e80:	e426                	sd	s1,8(sp)
    80001e82:	1000                	addi	s0,sp,32
    80001e84:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	fe2080e7          	jalr	-30(ra) # 80000e68 <myproc>
  switch (n) {
    80001e8e:	4795                	li	a5,5
    80001e90:	0497e163          	bltu	a5,s1,80001ed2 <argraw+0x58>
    80001e94:	048a                	slli	s1,s1,0x2
    80001e96:	00006717          	auipc	a4,0x6
    80001e9a:	5da70713          	addi	a4,a4,1498 # 80008470 <states.0+0x230>
    80001e9e:	94ba                	add	s1,s1,a4
    80001ea0:	409c                	lw	a5,0(s1)
    80001ea2:	97ba                	add	a5,a5,a4
    80001ea4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ea6:	713c                	ld	a5,96(a0)
    80001ea8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eaa:	60e2                	ld	ra,24(sp)
    80001eac:	6442                	ld	s0,16(sp)
    80001eae:	64a2                	ld	s1,8(sp)
    80001eb0:	6105                	addi	sp,sp,32
    80001eb2:	8082                	ret
    return p->trapframe->a1;
    80001eb4:	713c                	ld	a5,96(a0)
    80001eb6:	7fa8                	ld	a0,120(a5)
    80001eb8:	bfcd                	j	80001eaa <argraw+0x30>
    return p->trapframe->a2;
    80001eba:	713c                	ld	a5,96(a0)
    80001ebc:	63c8                	ld	a0,128(a5)
    80001ebe:	b7f5                	j	80001eaa <argraw+0x30>
    return p->trapframe->a3;
    80001ec0:	713c                	ld	a5,96(a0)
    80001ec2:	67c8                	ld	a0,136(a5)
    80001ec4:	b7dd                	j	80001eaa <argraw+0x30>
    return p->trapframe->a4;
    80001ec6:	713c                	ld	a5,96(a0)
    80001ec8:	6bc8                	ld	a0,144(a5)
    80001eca:	b7c5                	j	80001eaa <argraw+0x30>
    return p->trapframe->a5;
    80001ecc:	713c                	ld	a5,96(a0)
    80001ece:	6fc8                	ld	a0,152(a5)
    80001ed0:	bfe9                	j	80001eaa <argraw+0x30>
  panic("argraw");
    80001ed2:	00006517          	auipc	a0,0x6
    80001ed6:	4b650513          	addi	a0,a0,1206 # 80008388 <states.0+0x148>
    80001eda:	00004097          	auipc	ra,0x4
    80001ede:	d56080e7          	jalr	-682(ra) # 80005c30 <panic>

0000000080001ee2 <fetchaddr>:
{
    80001ee2:	1101                	addi	sp,sp,-32
    80001ee4:	ec06                	sd	ra,24(sp)
    80001ee6:	e822                	sd	s0,16(sp)
    80001ee8:	e426                	sd	s1,8(sp)
    80001eea:	e04a                	sd	s2,0(sp)
    80001eec:	1000                	addi	s0,sp,32
    80001eee:	84aa                	mv	s1,a0
    80001ef0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ef2:	fffff097          	auipc	ra,0xfffff
    80001ef6:	f76080e7          	jalr	-138(ra) # 80000e68 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001efa:	693c                	ld	a5,80(a0)
    80001efc:	02f4f863          	bgeu	s1,a5,80001f2c <fetchaddr+0x4a>
    80001f00:	00848713          	addi	a4,s1,8
    80001f04:	02e7e663          	bltu	a5,a4,80001f30 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f08:	46a1                	li	a3,8
    80001f0a:	8626                	mv	a2,s1
    80001f0c:	85ca                	mv	a1,s2
    80001f0e:	6d28                	ld	a0,88(a0)
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	ca8080e7          	jalr	-856(ra) # 80000bb8 <copyin>
    80001f18:	00a03533          	snez	a0,a0
    80001f1c:	40a00533          	neg	a0,a0
}
    80001f20:	60e2                	ld	ra,24(sp)
    80001f22:	6442                	ld	s0,16(sp)
    80001f24:	64a2                	ld	s1,8(sp)
    80001f26:	6902                	ld	s2,0(sp)
    80001f28:	6105                	addi	sp,sp,32
    80001f2a:	8082                	ret
    return -1;
    80001f2c:	557d                	li	a0,-1
    80001f2e:	bfcd                	j	80001f20 <fetchaddr+0x3e>
    80001f30:	557d                	li	a0,-1
    80001f32:	b7fd                	j	80001f20 <fetchaddr+0x3e>

0000000080001f34 <fetchstr>:
{
    80001f34:	7179                	addi	sp,sp,-48
    80001f36:	f406                	sd	ra,40(sp)
    80001f38:	f022                	sd	s0,32(sp)
    80001f3a:	ec26                	sd	s1,24(sp)
    80001f3c:	e84a                	sd	s2,16(sp)
    80001f3e:	e44e                	sd	s3,8(sp)
    80001f40:	1800                	addi	s0,sp,48
    80001f42:	892a                	mv	s2,a0
    80001f44:	84ae                	mv	s1,a1
    80001f46:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f48:	fffff097          	auipc	ra,0xfffff
    80001f4c:	f20080e7          	jalr	-224(ra) # 80000e68 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f50:	86ce                	mv	a3,s3
    80001f52:	864a                	mv	a2,s2
    80001f54:	85a6                	mv	a1,s1
    80001f56:	6d28                	ld	a0,88(a0)
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	cee080e7          	jalr	-786(ra) # 80000c46 <copyinstr>
  if(err < 0)
    80001f60:	00054763          	bltz	a0,80001f6e <fetchstr+0x3a>
  return strlen(buf);
    80001f64:	8526                	mv	a0,s1
    80001f66:	ffffe097          	auipc	ra,0xffffe
    80001f6a:	3b4080e7          	jalr	948(ra) # 8000031a <strlen>
}
    80001f6e:	70a2                	ld	ra,40(sp)
    80001f70:	7402                	ld	s0,32(sp)
    80001f72:	64e2                	ld	s1,24(sp)
    80001f74:	6942                	ld	s2,16(sp)
    80001f76:	69a2                	ld	s3,8(sp)
    80001f78:	6145                	addi	sp,sp,48
    80001f7a:	8082                	ret

0000000080001f7c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f7c:	1101                	addi	sp,sp,-32
    80001f7e:	ec06                	sd	ra,24(sp)
    80001f80:	e822                	sd	s0,16(sp)
    80001f82:	e426                	sd	s1,8(sp)
    80001f84:	1000                	addi	s0,sp,32
    80001f86:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f88:	00000097          	auipc	ra,0x0
    80001f8c:	ef2080e7          	jalr	-270(ra) # 80001e7a <argraw>
    80001f90:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f92:	4501                	li	a0,0
    80001f94:	60e2                	ld	ra,24(sp)
    80001f96:	6442                	ld	s0,16(sp)
    80001f98:	64a2                	ld	s1,8(sp)
    80001f9a:	6105                	addi	sp,sp,32
    80001f9c:	8082                	ret

0000000080001f9e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f9e:	1101                	addi	sp,sp,-32
    80001fa0:	ec06                	sd	ra,24(sp)
    80001fa2:	e822                	sd	s0,16(sp)
    80001fa4:	e426                	sd	s1,8(sp)
    80001fa6:	1000                	addi	s0,sp,32
    80001fa8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001faa:	00000097          	auipc	ra,0x0
    80001fae:	ed0080e7          	jalr	-304(ra) # 80001e7a <argraw>
    80001fb2:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fb4:	4501                	li	a0,0
    80001fb6:	60e2                	ld	ra,24(sp)
    80001fb8:	6442                	ld	s0,16(sp)
    80001fba:	64a2                	ld	s1,8(sp)
    80001fbc:	6105                	addi	sp,sp,32
    80001fbe:	8082                	ret

0000000080001fc0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fc0:	1101                	addi	sp,sp,-32
    80001fc2:	ec06                	sd	ra,24(sp)
    80001fc4:	e822                	sd	s0,16(sp)
    80001fc6:	e426                	sd	s1,8(sp)
    80001fc8:	e04a                	sd	s2,0(sp)
    80001fca:	1000                	addi	s0,sp,32
    80001fcc:	84ae                	mv	s1,a1
    80001fce:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fd0:	00000097          	auipc	ra,0x0
    80001fd4:	eaa080e7          	jalr	-342(ra) # 80001e7a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fd8:	864a                	mv	a2,s2
    80001fda:	85a6                	mv	a1,s1
    80001fdc:	00000097          	auipc	ra,0x0
    80001fe0:	f58080e7          	jalr	-168(ra) # 80001f34 <fetchstr>
}
    80001fe4:	60e2                	ld	ra,24(sp)
    80001fe6:	6442                	ld	s0,16(sp)
    80001fe8:	64a2                	ld	s1,8(sp)
    80001fea:	6902                	ld	s2,0(sp)
    80001fec:	6105                	addi	sp,sp,32
    80001fee:	8082                	ret

0000000080001ff0 <syscall>:
[SYS_sysinfo] sys_sysinfo,
};

void
syscall(void)
{
    80001ff0:	7179                	addi	sp,sp,-48
    80001ff2:	f406                	sd	ra,40(sp)
    80001ff4:	f022                	sd	s0,32(sp)
    80001ff6:	ec26                	sd	s1,24(sp)
    80001ff8:	e84a                	sd	s2,16(sp)
    80001ffa:	e44e                	sd	s3,8(sp)
    80001ffc:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001ffe:	fffff097          	auipc	ra,0xfffff
    80002002:	e6a080e7          	jalr	-406(ra) # 80000e68 <myproc>
    80002006:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002008:	06053983          	ld	s3,96(a0)
    8000200c:	0a89b783          	ld	a5,168(s3)
    80002010:	0007891b          	sext.w	s2,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002014:	37fd                	addiw	a5,a5,-1
    80002016:	4759                	li	a4,22
    80002018:	00f76f63          	bltu	a4,a5,80002036 <syscall+0x46>
    8000201c:	00391713          	slli	a4,s2,0x3
    80002020:	00006797          	auipc	a5,0x6
    80002024:	46878793          	addi	a5,a5,1128 # 80008488 <syscalls>
    80002028:	97ba                	add	a5,a5,a4
    8000202a:	639c                	ld	a5,0(a5)
    8000202c:	c789                	beqz	a5,80002036 <syscall+0x46>
    p->trapframe->a0 = syscalls[num]();
    8000202e:	9782                	jalr	a5
    80002030:	06a9b823          	sd	a0,112(s3)
    80002034:	a005                	j	80002054 <syscall+0x64>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002036:	86ca                	mv	a3,s2
    80002038:	16048613          	addi	a2,s1,352
    8000203c:	588c                	lw	a1,48(s1)
    8000203e:	00006517          	auipc	a0,0x6
    80002042:	35250513          	addi	a0,a0,850 # 80008390 <states.0+0x150>
    80002046:	00004097          	auipc	ra,0x4
    8000204a:	c34080e7          	jalr	-972(ra) # 80005c7a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000204e:	70bc                	ld	a5,96(s1)
    80002050:	577d                	li	a4,-1
    80002052:	fbb8                	sd	a4,112(a5)
  }
  
  if ((1 << num) & p->mask)
    80002054:	4705                	li	a4,1
    80002056:	0127173b          	sllw	a4,a4,s2
    8000205a:	40bc                	lw	a5,64(s1)
    8000205c:	8ff9                	and	a5,a5,a4
    8000205e:	2781                	sext.w	a5,a5
    80002060:	eb81                	bnez	a5,80002070 <syscall+0x80>
	printf("%d: syscall %s -> %d\n",p->pid,sysname[num],p->trapframe->a0);

}
    80002062:	70a2                	ld	ra,40(sp)
    80002064:	7402                	ld	s0,32(sp)
    80002066:	64e2                	ld	s1,24(sp)
    80002068:	6942                	ld	s2,16(sp)
    8000206a:	69a2                	ld	s3,8(sp)
    8000206c:	6145                	addi	sp,sp,48
    8000206e:	8082                	ret
	printf("%d: syscall %s -> %d\n",p->pid,sysname[num],p->trapframe->a0);
    80002070:	70b8                	ld	a4,96(s1)
    80002072:	090e                	slli	s2,s2,0x3
    80002074:	00006797          	auipc	a5,0x6
    80002078:	41478793          	addi	a5,a5,1044 # 80008488 <syscalls>
    8000207c:	97ca                	add	a5,a5,s2
    8000207e:	7b34                	ld	a3,112(a4)
    80002080:	63f0                	ld	a2,192(a5)
    80002082:	588c                	lw	a1,48(s1)
    80002084:	00006517          	auipc	a0,0x6
    80002088:	32c50513          	addi	a0,a0,812 # 800083b0 <states.0+0x170>
    8000208c:	00004097          	auipc	ra,0x4
    80002090:	bee080e7          	jalr	-1042(ra) # 80005c7a <printf>
}
    80002094:	b7f9                	j	80002062 <syscall+0x72>

0000000080002096 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80002096:	1101                	addi	sp,sp,-32
    80002098:	ec06                	sd	ra,24(sp)
    8000209a:	e822                	sd	s0,16(sp)
    8000209c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000209e:	fec40593          	addi	a1,s0,-20
    800020a2:	4501                	li	a0,0
    800020a4:	00000097          	auipc	ra,0x0
    800020a8:	ed8080e7          	jalr	-296(ra) # 80001f7c <argint>
    return -1;
    800020ac:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020ae:	00054963          	bltz	a0,800020c0 <sys_exit+0x2a>
  exit(n);
    800020b2:	fec42503          	lw	a0,-20(s0)
    800020b6:	fffff097          	auipc	ra,0xfffff
    800020ba:	6da080e7          	jalr	1754(ra) # 80001790 <exit>
  return 0;  // not reached
    800020be:	4781                	li	a5,0
}
    800020c0:	853e                	mv	a0,a5
    800020c2:	60e2                	ld	ra,24(sp)
    800020c4:	6442                	ld	s0,16(sp)
    800020c6:	6105                	addi	sp,sp,32
    800020c8:	8082                	ret

00000000800020ca <sys_getpid>:

uint64
sys_getpid(void)
{
    800020ca:	1141                	addi	sp,sp,-16
    800020cc:	e406                	sd	ra,8(sp)
    800020ce:	e022                	sd	s0,0(sp)
    800020d0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020d2:	fffff097          	auipc	ra,0xfffff
    800020d6:	d96080e7          	jalr	-618(ra) # 80000e68 <myproc>
}
    800020da:	5908                	lw	a0,48(a0)
    800020dc:	60a2                	ld	ra,8(sp)
    800020de:	6402                	ld	s0,0(sp)
    800020e0:	0141                	addi	sp,sp,16
    800020e2:	8082                	ret

00000000800020e4 <sys_fork>:

uint64
sys_fork(void)
{
    800020e4:	1141                	addi	sp,sp,-16
    800020e6:	e406                	sd	ra,8(sp)
    800020e8:	e022                	sd	s0,0(sp)
    800020ea:	0800                	addi	s0,sp,16
  return fork();
    800020ec:	fffff097          	auipc	ra,0xfffff
    800020f0:	14e080e7          	jalr	334(ra) # 8000123a <fork>
}
    800020f4:	60a2                	ld	ra,8(sp)
    800020f6:	6402                	ld	s0,0(sp)
    800020f8:	0141                	addi	sp,sp,16
    800020fa:	8082                	ret

00000000800020fc <sys_wait>:

uint64
sys_wait(void)
{
    800020fc:	1101                	addi	sp,sp,-32
    800020fe:	ec06                	sd	ra,24(sp)
    80002100:	e822                	sd	s0,16(sp)
    80002102:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002104:	fe840593          	addi	a1,s0,-24
    80002108:	4501                	li	a0,0
    8000210a:	00000097          	auipc	ra,0x0
    8000210e:	e94080e7          	jalr	-364(ra) # 80001f9e <argaddr>
    80002112:	87aa                	mv	a5,a0
    return -1;
    80002114:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002116:	0007c863          	bltz	a5,80002126 <sys_wait+0x2a>
  return wait(p);
    8000211a:	fe843503          	ld	a0,-24(s0)
    8000211e:	fffff097          	auipc	ra,0xfffff
    80002122:	47a080e7          	jalr	1146(ra) # 80001598 <wait>
}
    80002126:	60e2                	ld	ra,24(sp)
    80002128:	6442                	ld	s0,16(sp)
    8000212a:	6105                	addi	sp,sp,32
    8000212c:	8082                	ret

000000008000212e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000212e:	7179                	addi	sp,sp,-48
    80002130:	f406                	sd	ra,40(sp)
    80002132:	f022                	sd	s0,32(sp)
    80002134:	ec26                	sd	s1,24(sp)
    80002136:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002138:	fdc40593          	addi	a1,s0,-36
    8000213c:	4501                	li	a0,0
    8000213e:	00000097          	auipc	ra,0x0
    80002142:	e3e080e7          	jalr	-450(ra) # 80001f7c <argint>
    80002146:	87aa                	mv	a5,a0
    return -1;
    80002148:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000214a:	0207c063          	bltz	a5,8000216a <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	d1a080e7          	jalr	-742(ra) # 80000e68 <myproc>
    80002156:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    80002158:	fdc42503          	lw	a0,-36(s0)
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	066080e7          	jalr	102(ra) # 800011c2 <growproc>
    80002164:	00054863          	bltz	a0,80002174 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002168:	8526                	mv	a0,s1
}
    8000216a:	70a2                	ld	ra,40(sp)
    8000216c:	7402                	ld	s0,32(sp)
    8000216e:	64e2                	ld	s1,24(sp)
    80002170:	6145                	addi	sp,sp,48
    80002172:	8082                	ret
    return -1;
    80002174:	557d                	li	a0,-1
    80002176:	bfd5                	j	8000216a <sys_sbrk+0x3c>

0000000080002178 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002178:	7139                	addi	sp,sp,-64
    8000217a:	fc06                	sd	ra,56(sp)
    8000217c:	f822                	sd	s0,48(sp)
    8000217e:	f426                	sd	s1,40(sp)
    80002180:	f04a                	sd	s2,32(sp)
    80002182:	ec4e                	sd	s3,24(sp)
    80002184:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002186:	fcc40593          	addi	a1,s0,-52
    8000218a:	4501                	li	a0,0
    8000218c:	00000097          	auipc	ra,0x0
    80002190:	df0080e7          	jalr	-528(ra) # 80001f7c <argint>
    return -1;
    80002194:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002196:	06054563          	bltz	a0,80002200 <sys_sleep+0x88>
  acquire(&tickslock);
    8000219a:	0000d517          	auipc	a0,0xd
    8000219e:	ee650513          	addi	a0,a0,-282 # 8000f080 <tickslock>
    800021a2:	00004097          	auipc	ra,0x4
    800021a6:	fc6080e7          	jalr	-58(ra) # 80006168 <acquire>
  ticks0 = ticks;
    800021aa:	00007917          	auipc	s2,0x7
    800021ae:	e6e92903          	lw	s2,-402(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021b2:	fcc42783          	lw	a5,-52(s0)
    800021b6:	cf85                	beqz	a5,800021ee <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021b8:	0000d997          	auipc	s3,0xd
    800021bc:	ec898993          	addi	s3,s3,-312 # 8000f080 <tickslock>
    800021c0:	00007497          	auipc	s1,0x7
    800021c4:	e5848493          	addi	s1,s1,-424 # 80009018 <ticks>
    if(myproc()->killed){
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	ca0080e7          	jalr	-864(ra) # 80000e68 <myproc>
    800021d0:	551c                	lw	a5,40(a0)
    800021d2:	ef9d                	bnez	a5,80002210 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021d4:	85ce                	mv	a1,s3
    800021d6:	8526                	mv	a0,s1
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	35c080e7          	jalr	860(ra) # 80001534 <sleep>
  while(ticks - ticks0 < n){
    800021e0:	409c                	lw	a5,0(s1)
    800021e2:	412787bb          	subw	a5,a5,s2
    800021e6:	fcc42703          	lw	a4,-52(s0)
    800021ea:	fce7efe3          	bltu	a5,a4,800021c8 <sys_sleep+0x50>
  }
  release(&tickslock);
    800021ee:	0000d517          	auipc	a0,0xd
    800021f2:	e9250513          	addi	a0,a0,-366 # 8000f080 <tickslock>
    800021f6:	00004097          	auipc	ra,0x4
    800021fa:	026080e7          	jalr	38(ra) # 8000621c <release>
  return 0;
    800021fe:	4781                	li	a5,0
}
    80002200:	853e                	mv	a0,a5
    80002202:	70e2                	ld	ra,56(sp)
    80002204:	7442                	ld	s0,48(sp)
    80002206:	74a2                	ld	s1,40(sp)
    80002208:	7902                	ld	s2,32(sp)
    8000220a:	69e2                	ld	s3,24(sp)
    8000220c:	6121                	addi	sp,sp,64
    8000220e:	8082                	ret
      release(&tickslock);
    80002210:	0000d517          	auipc	a0,0xd
    80002214:	e7050513          	addi	a0,a0,-400 # 8000f080 <tickslock>
    80002218:	00004097          	auipc	ra,0x4
    8000221c:	004080e7          	jalr	4(ra) # 8000621c <release>
      return -1;
    80002220:	57fd                	li	a5,-1
    80002222:	bff9                	j	80002200 <sys_sleep+0x88>

0000000080002224 <sys_kill>:

uint64
sys_kill(void)
{
    80002224:	1101                	addi	sp,sp,-32
    80002226:	ec06                	sd	ra,24(sp)
    80002228:	e822                	sd	s0,16(sp)
    8000222a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000222c:	fec40593          	addi	a1,s0,-20
    80002230:	4501                	li	a0,0
    80002232:	00000097          	auipc	ra,0x0
    80002236:	d4a080e7          	jalr	-694(ra) # 80001f7c <argint>
    8000223a:	87aa                	mv	a5,a0
    return -1;
    8000223c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000223e:	0007c863          	bltz	a5,8000224e <sys_kill+0x2a>
  return kill(pid);
    80002242:	fec42503          	lw	a0,-20(s0)
    80002246:	fffff097          	auipc	ra,0xfffff
    8000224a:	620080e7          	jalr	1568(ra) # 80001866 <kill>
}
    8000224e:	60e2                	ld	ra,24(sp)
    80002250:	6442                	ld	s0,16(sp)
    80002252:	6105                	addi	sp,sp,32
    80002254:	8082                	ret

0000000080002256 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002256:	1101                	addi	sp,sp,-32
    80002258:	ec06                	sd	ra,24(sp)
    8000225a:	e822                	sd	s0,16(sp)
    8000225c:	e426                	sd	s1,8(sp)
    8000225e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002260:	0000d517          	auipc	a0,0xd
    80002264:	e2050513          	addi	a0,a0,-480 # 8000f080 <tickslock>
    80002268:	00004097          	auipc	ra,0x4
    8000226c:	f00080e7          	jalr	-256(ra) # 80006168 <acquire>
  xticks = ticks;
    80002270:	00007497          	auipc	s1,0x7
    80002274:	da84a483          	lw	s1,-600(s1) # 80009018 <ticks>
  release(&tickslock);
    80002278:	0000d517          	auipc	a0,0xd
    8000227c:	e0850513          	addi	a0,a0,-504 # 8000f080 <tickslock>
    80002280:	00004097          	auipc	ra,0x4
    80002284:	f9c080e7          	jalr	-100(ra) # 8000621c <release>
  return xticks;
}
    80002288:	02049513          	slli	a0,s1,0x20
    8000228c:	9101                	srli	a0,a0,0x20
    8000228e:	60e2                	ld	ra,24(sp)
    80002290:	6442                	ld	s0,16(sp)
    80002292:	64a2                	ld	s1,8(sp)
    80002294:	6105                	addi	sp,sp,32
    80002296:	8082                	ret

0000000080002298 <sys_trace>:

uint64 sys_trace(void)
{
    80002298:	7179                	addi	sp,sp,-48
    8000229a:	f406                	sd	ra,40(sp)
    8000229c:	f022                	sd	s0,32(sp)
    8000229e:	ec26                	sd	s1,24(sp)
    800022a0:	1800                	addi	s0,sp,48
    int mask;
    if (argint(0,&mask) < 0)
    800022a2:	fdc40593          	addi	a1,s0,-36
    800022a6:	4501                	li	a0,0
    800022a8:	00000097          	auipc	ra,0x0
    800022ac:	cd4080e7          	jalr	-812(ra) # 80001f7c <argint>
        return -1;
    800022b0:	57fd                	li	a5,-1
    if (argint(0,&mask) < 0)
    800022b2:	00054a63          	bltz	a0,800022c6 <sys_trace+0x2e>
    myproc()->mask = mask;
    800022b6:	fdc42483          	lw	s1,-36(s0)
    800022ba:	fffff097          	auipc	ra,0xfffff
    800022be:	bae080e7          	jalr	-1106(ra) # 80000e68 <myproc>
    800022c2:	c124                	sw	s1,64(a0)
    return 0;
    800022c4:	4781                	li	a5,0
}
    800022c6:	853e                	mv	a0,a5
    800022c8:	70a2                	ld	ra,40(sp)
    800022ca:	7402                	ld	s0,32(sp)
    800022cc:	64e2                	ld	s1,24(sp)
    800022ce:	6145                	addi	sp,sp,48
    800022d0:	8082                	ret

00000000800022d2 <sys_sysinfo>:
uint64 sys_sysinfo(void)
{
    800022d2:	7179                	addi	sp,sp,-48
    800022d4:	f406                	sd	ra,40(sp)
    800022d6:	f022                	sd	s0,32(sp)
    800022d8:	1800                	addi	s0,sp,48
	uint64 addr;
	if (argaddr(0,&addr) < 0)
    800022da:	fe840593          	addi	a1,s0,-24
    800022de:	4501                	li	a0,0
    800022e0:	00000097          	auipc	ra,0x0
    800022e4:	cbe080e7          	jalr	-834(ra) # 80001f9e <argaddr>
    800022e8:	87aa                	mv	a5,a0
		return -1;
    800022ea:	557d                	li	a0,-1
	if (argaddr(0,&addr) < 0)
    800022ec:	0207cd63          	bltz	a5,80002326 <sys_sysinfo+0x54>
	struct sysinfo sf;
	sf.nproc = nop();//nop 后面加
    800022f0:	fffff097          	auipc	ra,0xfffff
    800022f4:	744080e7          	jalr	1860(ra) # 80001a34 <nop>
    800022f8:	fea43023          	sd	a0,-32(s0)
	sf.freemem = freemem();// 后面加
    800022fc:	ffffe097          	auipc	ra,0xffffe
    80002300:	e7e080e7          	jalr	-386(ra) # 8000017a <freemem>
    80002304:	fca43c23          	sd	a0,-40(s0)
	if (copyout(myproc()->pagetable,addr,(char*)&sf,sizeof(sf)) < 0)
    80002308:	fffff097          	auipc	ra,0xfffff
    8000230c:	b60080e7          	jalr	-1184(ra) # 80000e68 <myproc>
    80002310:	46c1                	li	a3,16
    80002312:	fd840613          	addi	a2,s0,-40
    80002316:	fe843583          	ld	a1,-24(s0)
    8000231a:	6d28                	ld	a0,88(a0)
    8000231c:	fffff097          	auipc	ra,0xfffff
    80002320:	810080e7          	jalr	-2032(ra) # 80000b2c <copyout>
    80002324:	957d                	srai	a0,a0,0x3f
		return -1;
	return 0;
}
    80002326:	70a2                	ld	ra,40(sp)
    80002328:	7402                	ld	s0,32(sp)
    8000232a:	6145                	addi	sp,sp,48
    8000232c:	8082                	ret

000000008000232e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000232e:	7179                	addi	sp,sp,-48
    80002330:	f406                	sd	ra,40(sp)
    80002332:	f022                	sd	s0,32(sp)
    80002334:	ec26                	sd	s1,24(sp)
    80002336:	e84a                	sd	s2,16(sp)
    80002338:	e44e                	sd	s3,8(sp)
    8000233a:	e052                	sd	s4,0(sp)
    8000233c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000233e:	00006597          	auipc	a1,0x6
    80002342:	2c258593          	addi	a1,a1,706 # 80008600 <sysname+0xb8>
    80002346:	0000d517          	auipc	a0,0xd
    8000234a:	d5250513          	addi	a0,a0,-686 # 8000f098 <bcache>
    8000234e:	00004097          	auipc	ra,0x4
    80002352:	d8a080e7          	jalr	-630(ra) # 800060d8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002356:	00015797          	auipc	a5,0x15
    8000235a:	d4278793          	addi	a5,a5,-702 # 80017098 <bcache+0x8000>
    8000235e:	00015717          	auipc	a4,0x15
    80002362:	fa270713          	addi	a4,a4,-94 # 80017300 <bcache+0x8268>
    80002366:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000236a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000236e:	0000d497          	auipc	s1,0xd
    80002372:	d4248493          	addi	s1,s1,-702 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002376:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002378:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000237a:	00006a17          	auipc	s4,0x6
    8000237e:	28ea0a13          	addi	s4,s4,654 # 80008608 <sysname+0xc0>
    b->next = bcache.head.next;
    80002382:	2b893783          	ld	a5,696(s2)
    80002386:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002388:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000238c:	85d2                	mv	a1,s4
    8000238e:	01048513          	addi	a0,s1,16
    80002392:	00001097          	auipc	ra,0x1
    80002396:	4c2080e7          	jalr	1218(ra) # 80003854 <initsleeplock>
    bcache.head.next->prev = b;
    8000239a:	2b893783          	ld	a5,696(s2)
    8000239e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023a0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023a4:	45848493          	addi	s1,s1,1112
    800023a8:	fd349de3          	bne	s1,s3,80002382 <binit+0x54>
  }
}
    800023ac:	70a2                	ld	ra,40(sp)
    800023ae:	7402                	ld	s0,32(sp)
    800023b0:	64e2                	ld	s1,24(sp)
    800023b2:	6942                	ld	s2,16(sp)
    800023b4:	69a2                	ld	s3,8(sp)
    800023b6:	6a02                	ld	s4,0(sp)
    800023b8:	6145                	addi	sp,sp,48
    800023ba:	8082                	ret

00000000800023bc <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023bc:	7179                	addi	sp,sp,-48
    800023be:	f406                	sd	ra,40(sp)
    800023c0:	f022                	sd	s0,32(sp)
    800023c2:	ec26                	sd	s1,24(sp)
    800023c4:	e84a                	sd	s2,16(sp)
    800023c6:	e44e                	sd	s3,8(sp)
    800023c8:	1800                	addi	s0,sp,48
    800023ca:	892a                	mv	s2,a0
    800023cc:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023ce:	0000d517          	auipc	a0,0xd
    800023d2:	cca50513          	addi	a0,a0,-822 # 8000f098 <bcache>
    800023d6:	00004097          	auipc	ra,0x4
    800023da:	d92080e7          	jalr	-622(ra) # 80006168 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023de:	00015497          	auipc	s1,0x15
    800023e2:	f724b483          	ld	s1,-142(s1) # 80017350 <bcache+0x82b8>
    800023e6:	00015797          	auipc	a5,0x15
    800023ea:	f1a78793          	addi	a5,a5,-230 # 80017300 <bcache+0x8268>
    800023ee:	02f48f63          	beq	s1,a5,8000242c <bread+0x70>
    800023f2:	873e                	mv	a4,a5
    800023f4:	a021                	j	800023fc <bread+0x40>
    800023f6:	68a4                	ld	s1,80(s1)
    800023f8:	02e48a63          	beq	s1,a4,8000242c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023fc:	449c                	lw	a5,8(s1)
    800023fe:	ff279ce3          	bne	a5,s2,800023f6 <bread+0x3a>
    80002402:	44dc                	lw	a5,12(s1)
    80002404:	ff3799e3          	bne	a5,s3,800023f6 <bread+0x3a>
      b->refcnt++;
    80002408:	40bc                	lw	a5,64(s1)
    8000240a:	2785                	addiw	a5,a5,1
    8000240c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000240e:	0000d517          	auipc	a0,0xd
    80002412:	c8a50513          	addi	a0,a0,-886 # 8000f098 <bcache>
    80002416:	00004097          	auipc	ra,0x4
    8000241a:	e06080e7          	jalr	-506(ra) # 8000621c <release>
      acquiresleep(&b->lock);
    8000241e:	01048513          	addi	a0,s1,16
    80002422:	00001097          	auipc	ra,0x1
    80002426:	46c080e7          	jalr	1132(ra) # 8000388e <acquiresleep>
      return b;
    8000242a:	a8b9                	j	80002488 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000242c:	00015497          	auipc	s1,0x15
    80002430:	f1c4b483          	ld	s1,-228(s1) # 80017348 <bcache+0x82b0>
    80002434:	00015797          	auipc	a5,0x15
    80002438:	ecc78793          	addi	a5,a5,-308 # 80017300 <bcache+0x8268>
    8000243c:	00f48863          	beq	s1,a5,8000244c <bread+0x90>
    80002440:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002442:	40bc                	lw	a5,64(s1)
    80002444:	cf81                	beqz	a5,8000245c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002446:	64a4                	ld	s1,72(s1)
    80002448:	fee49de3          	bne	s1,a4,80002442 <bread+0x86>
  panic("bget: no buffers");
    8000244c:	00006517          	auipc	a0,0x6
    80002450:	1c450513          	addi	a0,a0,452 # 80008610 <sysname+0xc8>
    80002454:	00003097          	auipc	ra,0x3
    80002458:	7dc080e7          	jalr	2012(ra) # 80005c30 <panic>
      b->dev = dev;
    8000245c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002460:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002464:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002468:	4785                	li	a5,1
    8000246a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000246c:	0000d517          	auipc	a0,0xd
    80002470:	c2c50513          	addi	a0,a0,-980 # 8000f098 <bcache>
    80002474:	00004097          	auipc	ra,0x4
    80002478:	da8080e7          	jalr	-600(ra) # 8000621c <release>
      acquiresleep(&b->lock);
    8000247c:	01048513          	addi	a0,s1,16
    80002480:	00001097          	auipc	ra,0x1
    80002484:	40e080e7          	jalr	1038(ra) # 8000388e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002488:	409c                	lw	a5,0(s1)
    8000248a:	cb89                	beqz	a5,8000249c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000248c:	8526                	mv	a0,s1
    8000248e:	70a2                	ld	ra,40(sp)
    80002490:	7402                	ld	s0,32(sp)
    80002492:	64e2                	ld	s1,24(sp)
    80002494:	6942                	ld	s2,16(sp)
    80002496:	69a2                	ld	s3,8(sp)
    80002498:	6145                	addi	sp,sp,48
    8000249a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000249c:	4581                	li	a1,0
    8000249e:	8526                	mv	a0,s1
    800024a0:	00003097          	auipc	ra,0x3
    800024a4:	f22080e7          	jalr	-222(ra) # 800053c2 <virtio_disk_rw>
    b->valid = 1;
    800024a8:	4785                	li	a5,1
    800024aa:	c09c                	sw	a5,0(s1)
  return b;
    800024ac:	b7c5                	j	8000248c <bread+0xd0>

00000000800024ae <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024ae:	1101                	addi	sp,sp,-32
    800024b0:	ec06                	sd	ra,24(sp)
    800024b2:	e822                	sd	s0,16(sp)
    800024b4:	e426                	sd	s1,8(sp)
    800024b6:	1000                	addi	s0,sp,32
    800024b8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ba:	0541                	addi	a0,a0,16
    800024bc:	00001097          	auipc	ra,0x1
    800024c0:	46c080e7          	jalr	1132(ra) # 80003928 <holdingsleep>
    800024c4:	cd01                	beqz	a0,800024dc <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024c6:	4585                	li	a1,1
    800024c8:	8526                	mv	a0,s1
    800024ca:	00003097          	auipc	ra,0x3
    800024ce:	ef8080e7          	jalr	-264(ra) # 800053c2 <virtio_disk_rw>
}
    800024d2:	60e2                	ld	ra,24(sp)
    800024d4:	6442                	ld	s0,16(sp)
    800024d6:	64a2                	ld	s1,8(sp)
    800024d8:	6105                	addi	sp,sp,32
    800024da:	8082                	ret
    panic("bwrite");
    800024dc:	00006517          	auipc	a0,0x6
    800024e0:	14c50513          	addi	a0,a0,332 # 80008628 <sysname+0xe0>
    800024e4:	00003097          	auipc	ra,0x3
    800024e8:	74c080e7          	jalr	1868(ra) # 80005c30 <panic>

00000000800024ec <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024ec:	1101                	addi	sp,sp,-32
    800024ee:	ec06                	sd	ra,24(sp)
    800024f0:	e822                	sd	s0,16(sp)
    800024f2:	e426                	sd	s1,8(sp)
    800024f4:	e04a                	sd	s2,0(sp)
    800024f6:	1000                	addi	s0,sp,32
    800024f8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024fa:	01050913          	addi	s2,a0,16
    800024fe:	854a                	mv	a0,s2
    80002500:	00001097          	auipc	ra,0x1
    80002504:	428080e7          	jalr	1064(ra) # 80003928 <holdingsleep>
    80002508:	c92d                	beqz	a0,8000257a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000250a:	854a                	mv	a0,s2
    8000250c:	00001097          	auipc	ra,0x1
    80002510:	3d8080e7          	jalr	984(ra) # 800038e4 <releasesleep>

  acquire(&bcache.lock);
    80002514:	0000d517          	auipc	a0,0xd
    80002518:	b8450513          	addi	a0,a0,-1148 # 8000f098 <bcache>
    8000251c:	00004097          	auipc	ra,0x4
    80002520:	c4c080e7          	jalr	-948(ra) # 80006168 <acquire>
  b->refcnt--;
    80002524:	40bc                	lw	a5,64(s1)
    80002526:	37fd                	addiw	a5,a5,-1
    80002528:	0007871b          	sext.w	a4,a5
    8000252c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000252e:	eb05                	bnez	a4,8000255e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002530:	68bc                	ld	a5,80(s1)
    80002532:	64b8                	ld	a4,72(s1)
    80002534:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002536:	64bc                	ld	a5,72(s1)
    80002538:	68b8                	ld	a4,80(s1)
    8000253a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000253c:	00015797          	auipc	a5,0x15
    80002540:	b5c78793          	addi	a5,a5,-1188 # 80017098 <bcache+0x8000>
    80002544:	2b87b703          	ld	a4,696(a5)
    80002548:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000254a:	00015717          	auipc	a4,0x15
    8000254e:	db670713          	addi	a4,a4,-586 # 80017300 <bcache+0x8268>
    80002552:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002554:	2b87b703          	ld	a4,696(a5)
    80002558:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000255a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000255e:	0000d517          	auipc	a0,0xd
    80002562:	b3a50513          	addi	a0,a0,-1222 # 8000f098 <bcache>
    80002566:	00004097          	auipc	ra,0x4
    8000256a:	cb6080e7          	jalr	-842(ra) # 8000621c <release>
}
    8000256e:	60e2                	ld	ra,24(sp)
    80002570:	6442                	ld	s0,16(sp)
    80002572:	64a2                	ld	s1,8(sp)
    80002574:	6902                	ld	s2,0(sp)
    80002576:	6105                	addi	sp,sp,32
    80002578:	8082                	ret
    panic("brelse");
    8000257a:	00006517          	auipc	a0,0x6
    8000257e:	0b650513          	addi	a0,a0,182 # 80008630 <sysname+0xe8>
    80002582:	00003097          	auipc	ra,0x3
    80002586:	6ae080e7          	jalr	1710(ra) # 80005c30 <panic>

000000008000258a <bpin>:

void
bpin(struct buf *b) {
    8000258a:	1101                	addi	sp,sp,-32
    8000258c:	ec06                	sd	ra,24(sp)
    8000258e:	e822                	sd	s0,16(sp)
    80002590:	e426                	sd	s1,8(sp)
    80002592:	1000                	addi	s0,sp,32
    80002594:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002596:	0000d517          	auipc	a0,0xd
    8000259a:	b0250513          	addi	a0,a0,-1278 # 8000f098 <bcache>
    8000259e:	00004097          	auipc	ra,0x4
    800025a2:	bca080e7          	jalr	-1078(ra) # 80006168 <acquire>
  b->refcnt++;
    800025a6:	40bc                	lw	a5,64(s1)
    800025a8:	2785                	addiw	a5,a5,1
    800025aa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ac:	0000d517          	auipc	a0,0xd
    800025b0:	aec50513          	addi	a0,a0,-1300 # 8000f098 <bcache>
    800025b4:	00004097          	auipc	ra,0x4
    800025b8:	c68080e7          	jalr	-920(ra) # 8000621c <release>
}
    800025bc:	60e2                	ld	ra,24(sp)
    800025be:	6442                	ld	s0,16(sp)
    800025c0:	64a2                	ld	s1,8(sp)
    800025c2:	6105                	addi	sp,sp,32
    800025c4:	8082                	ret

00000000800025c6 <bunpin>:

void
bunpin(struct buf *b) {
    800025c6:	1101                	addi	sp,sp,-32
    800025c8:	ec06                	sd	ra,24(sp)
    800025ca:	e822                	sd	s0,16(sp)
    800025cc:	e426                	sd	s1,8(sp)
    800025ce:	1000                	addi	s0,sp,32
    800025d0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025d2:	0000d517          	auipc	a0,0xd
    800025d6:	ac650513          	addi	a0,a0,-1338 # 8000f098 <bcache>
    800025da:	00004097          	auipc	ra,0x4
    800025de:	b8e080e7          	jalr	-1138(ra) # 80006168 <acquire>
  b->refcnt--;
    800025e2:	40bc                	lw	a5,64(s1)
    800025e4:	37fd                	addiw	a5,a5,-1
    800025e6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025e8:	0000d517          	auipc	a0,0xd
    800025ec:	ab050513          	addi	a0,a0,-1360 # 8000f098 <bcache>
    800025f0:	00004097          	auipc	ra,0x4
    800025f4:	c2c080e7          	jalr	-980(ra) # 8000621c <release>
}
    800025f8:	60e2                	ld	ra,24(sp)
    800025fa:	6442                	ld	s0,16(sp)
    800025fc:	64a2                	ld	s1,8(sp)
    800025fe:	6105                	addi	sp,sp,32
    80002600:	8082                	ret

0000000080002602 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002602:	1101                	addi	sp,sp,-32
    80002604:	ec06                	sd	ra,24(sp)
    80002606:	e822                	sd	s0,16(sp)
    80002608:	e426                	sd	s1,8(sp)
    8000260a:	e04a                	sd	s2,0(sp)
    8000260c:	1000                	addi	s0,sp,32
    8000260e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002610:	00d5d59b          	srliw	a1,a1,0xd
    80002614:	00015797          	auipc	a5,0x15
    80002618:	1607a783          	lw	a5,352(a5) # 80017774 <sb+0x1c>
    8000261c:	9dbd                	addw	a1,a1,a5
    8000261e:	00000097          	auipc	ra,0x0
    80002622:	d9e080e7          	jalr	-610(ra) # 800023bc <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002626:	0074f713          	andi	a4,s1,7
    8000262a:	4785                	li	a5,1
    8000262c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002630:	14ce                	slli	s1,s1,0x33
    80002632:	90d9                	srli	s1,s1,0x36
    80002634:	00950733          	add	a4,a0,s1
    80002638:	05874703          	lbu	a4,88(a4)
    8000263c:	00e7f6b3          	and	a3,a5,a4
    80002640:	c69d                	beqz	a3,8000266e <bfree+0x6c>
    80002642:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002644:	94aa                	add	s1,s1,a0
    80002646:	fff7c793          	not	a5,a5
    8000264a:	8f7d                	and	a4,a4,a5
    8000264c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002650:	00001097          	auipc	ra,0x1
    80002654:	120080e7          	jalr	288(ra) # 80003770 <log_write>
  brelse(bp);
    80002658:	854a                	mv	a0,s2
    8000265a:	00000097          	auipc	ra,0x0
    8000265e:	e92080e7          	jalr	-366(ra) # 800024ec <brelse>
}
    80002662:	60e2                	ld	ra,24(sp)
    80002664:	6442                	ld	s0,16(sp)
    80002666:	64a2                	ld	s1,8(sp)
    80002668:	6902                	ld	s2,0(sp)
    8000266a:	6105                	addi	sp,sp,32
    8000266c:	8082                	ret
    panic("freeing free block");
    8000266e:	00006517          	auipc	a0,0x6
    80002672:	fca50513          	addi	a0,a0,-54 # 80008638 <sysname+0xf0>
    80002676:	00003097          	auipc	ra,0x3
    8000267a:	5ba080e7          	jalr	1466(ra) # 80005c30 <panic>

000000008000267e <balloc>:
{
    8000267e:	711d                	addi	sp,sp,-96
    80002680:	ec86                	sd	ra,88(sp)
    80002682:	e8a2                	sd	s0,80(sp)
    80002684:	e4a6                	sd	s1,72(sp)
    80002686:	e0ca                	sd	s2,64(sp)
    80002688:	fc4e                	sd	s3,56(sp)
    8000268a:	f852                	sd	s4,48(sp)
    8000268c:	f456                	sd	s5,40(sp)
    8000268e:	f05a                	sd	s6,32(sp)
    80002690:	ec5e                	sd	s7,24(sp)
    80002692:	e862                	sd	s8,16(sp)
    80002694:	e466                	sd	s9,8(sp)
    80002696:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002698:	00015797          	auipc	a5,0x15
    8000269c:	0c47a783          	lw	a5,196(a5) # 8001775c <sb+0x4>
    800026a0:	cbc1                	beqz	a5,80002730 <balloc+0xb2>
    800026a2:	8baa                	mv	s7,a0
    800026a4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026a6:	00015b17          	auipc	s6,0x15
    800026aa:	0b2b0b13          	addi	s6,s6,178 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ae:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026b0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026b2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026b4:	6c89                	lui	s9,0x2
    800026b6:	a831                	j	800026d2 <balloc+0x54>
    brelse(bp);
    800026b8:	854a                	mv	a0,s2
    800026ba:	00000097          	auipc	ra,0x0
    800026be:	e32080e7          	jalr	-462(ra) # 800024ec <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026c2:	015c87bb          	addw	a5,s9,s5
    800026c6:	00078a9b          	sext.w	s5,a5
    800026ca:	004b2703          	lw	a4,4(s6)
    800026ce:	06eaf163          	bgeu	s5,a4,80002730 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800026d2:	41fad79b          	sraiw	a5,s5,0x1f
    800026d6:	0137d79b          	srliw	a5,a5,0x13
    800026da:	015787bb          	addw	a5,a5,s5
    800026de:	40d7d79b          	sraiw	a5,a5,0xd
    800026e2:	01cb2583          	lw	a1,28(s6)
    800026e6:	9dbd                	addw	a1,a1,a5
    800026e8:	855e                	mv	a0,s7
    800026ea:	00000097          	auipc	ra,0x0
    800026ee:	cd2080e7          	jalr	-814(ra) # 800023bc <bread>
    800026f2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026f4:	004b2503          	lw	a0,4(s6)
    800026f8:	000a849b          	sext.w	s1,s5
    800026fc:	8762                	mv	a4,s8
    800026fe:	faa4fde3          	bgeu	s1,a0,800026b8 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002702:	00777693          	andi	a3,a4,7
    80002706:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000270a:	41f7579b          	sraiw	a5,a4,0x1f
    8000270e:	01d7d79b          	srliw	a5,a5,0x1d
    80002712:	9fb9                	addw	a5,a5,a4
    80002714:	4037d79b          	sraiw	a5,a5,0x3
    80002718:	00f90633          	add	a2,s2,a5
    8000271c:	05864603          	lbu	a2,88(a2)
    80002720:	00c6f5b3          	and	a1,a3,a2
    80002724:	cd91                	beqz	a1,80002740 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002726:	2705                	addiw	a4,a4,1
    80002728:	2485                	addiw	s1,s1,1
    8000272a:	fd471ae3          	bne	a4,s4,800026fe <balloc+0x80>
    8000272e:	b769                	j	800026b8 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002730:	00006517          	auipc	a0,0x6
    80002734:	f2050513          	addi	a0,a0,-224 # 80008650 <sysname+0x108>
    80002738:	00003097          	auipc	ra,0x3
    8000273c:	4f8080e7          	jalr	1272(ra) # 80005c30 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002740:	97ca                	add	a5,a5,s2
    80002742:	8e55                	or	a2,a2,a3
    80002744:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002748:	854a                	mv	a0,s2
    8000274a:	00001097          	auipc	ra,0x1
    8000274e:	026080e7          	jalr	38(ra) # 80003770 <log_write>
        brelse(bp);
    80002752:	854a                	mv	a0,s2
    80002754:	00000097          	auipc	ra,0x0
    80002758:	d98080e7          	jalr	-616(ra) # 800024ec <brelse>
  bp = bread(dev, bno);
    8000275c:	85a6                	mv	a1,s1
    8000275e:	855e                	mv	a0,s7
    80002760:	00000097          	auipc	ra,0x0
    80002764:	c5c080e7          	jalr	-932(ra) # 800023bc <bread>
    80002768:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000276a:	40000613          	li	a2,1024
    8000276e:	4581                	li	a1,0
    80002770:	05850513          	addi	a0,a0,88
    80002774:	ffffe097          	auipc	ra,0xffffe
    80002778:	a2a080e7          	jalr	-1494(ra) # 8000019e <memset>
  log_write(bp);
    8000277c:	854a                	mv	a0,s2
    8000277e:	00001097          	auipc	ra,0x1
    80002782:	ff2080e7          	jalr	-14(ra) # 80003770 <log_write>
  brelse(bp);
    80002786:	854a                	mv	a0,s2
    80002788:	00000097          	auipc	ra,0x0
    8000278c:	d64080e7          	jalr	-668(ra) # 800024ec <brelse>
}
    80002790:	8526                	mv	a0,s1
    80002792:	60e6                	ld	ra,88(sp)
    80002794:	6446                	ld	s0,80(sp)
    80002796:	64a6                	ld	s1,72(sp)
    80002798:	6906                	ld	s2,64(sp)
    8000279a:	79e2                	ld	s3,56(sp)
    8000279c:	7a42                	ld	s4,48(sp)
    8000279e:	7aa2                	ld	s5,40(sp)
    800027a0:	7b02                	ld	s6,32(sp)
    800027a2:	6be2                	ld	s7,24(sp)
    800027a4:	6c42                	ld	s8,16(sp)
    800027a6:	6ca2                	ld	s9,8(sp)
    800027a8:	6125                	addi	sp,sp,96
    800027aa:	8082                	ret

00000000800027ac <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027ac:	7179                	addi	sp,sp,-48
    800027ae:	f406                	sd	ra,40(sp)
    800027b0:	f022                	sd	s0,32(sp)
    800027b2:	ec26                	sd	s1,24(sp)
    800027b4:	e84a                	sd	s2,16(sp)
    800027b6:	e44e                	sd	s3,8(sp)
    800027b8:	e052                	sd	s4,0(sp)
    800027ba:	1800                	addi	s0,sp,48
    800027bc:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027be:	47ad                	li	a5,11
    800027c0:	04b7fe63          	bgeu	a5,a1,8000281c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027c4:	ff45849b          	addiw	s1,a1,-12
    800027c8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027cc:	0ff00793          	li	a5,255
    800027d0:	0ae7e463          	bltu	a5,a4,80002878 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027d4:	08052583          	lw	a1,128(a0)
    800027d8:	c5b5                	beqz	a1,80002844 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027da:	00092503          	lw	a0,0(s2)
    800027de:	00000097          	auipc	ra,0x0
    800027e2:	bde080e7          	jalr	-1058(ra) # 800023bc <bread>
    800027e6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027e8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027ec:	02049713          	slli	a4,s1,0x20
    800027f0:	01e75593          	srli	a1,a4,0x1e
    800027f4:	00b784b3          	add	s1,a5,a1
    800027f8:	0004a983          	lw	s3,0(s1)
    800027fc:	04098e63          	beqz	s3,80002858 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002800:	8552                	mv	a0,s4
    80002802:	00000097          	auipc	ra,0x0
    80002806:	cea080e7          	jalr	-790(ra) # 800024ec <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000280a:	854e                	mv	a0,s3
    8000280c:	70a2                	ld	ra,40(sp)
    8000280e:	7402                	ld	s0,32(sp)
    80002810:	64e2                	ld	s1,24(sp)
    80002812:	6942                	ld	s2,16(sp)
    80002814:	69a2                	ld	s3,8(sp)
    80002816:	6a02                	ld	s4,0(sp)
    80002818:	6145                	addi	sp,sp,48
    8000281a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000281c:	02059793          	slli	a5,a1,0x20
    80002820:	01e7d593          	srli	a1,a5,0x1e
    80002824:	00b504b3          	add	s1,a0,a1
    80002828:	0504a983          	lw	s3,80(s1)
    8000282c:	fc099fe3          	bnez	s3,8000280a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002830:	4108                	lw	a0,0(a0)
    80002832:	00000097          	auipc	ra,0x0
    80002836:	e4c080e7          	jalr	-436(ra) # 8000267e <balloc>
    8000283a:	0005099b          	sext.w	s3,a0
    8000283e:	0534a823          	sw	s3,80(s1)
    80002842:	b7e1                	j	8000280a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002844:	4108                	lw	a0,0(a0)
    80002846:	00000097          	auipc	ra,0x0
    8000284a:	e38080e7          	jalr	-456(ra) # 8000267e <balloc>
    8000284e:	0005059b          	sext.w	a1,a0
    80002852:	08b92023          	sw	a1,128(s2)
    80002856:	b751                	j	800027da <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002858:	00092503          	lw	a0,0(s2)
    8000285c:	00000097          	auipc	ra,0x0
    80002860:	e22080e7          	jalr	-478(ra) # 8000267e <balloc>
    80002864:	0005099b          	sext.w	s3,a0
    80002868:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000286c:	8552                	mv	a0,s4
    8000286e:	00001097          	auipc	ra,0x1
    80002872:	f02080e7          	jalr	-254(ra) # 80003770 <log_write>
    80002876:	b769                	j	80002800 <bmap+0x54>
  panic("bmap: out of range");
    80002878:	00006517          	auipc	a0,0x6
    8000287c:	df050513          	addi	a0,a0,-528 # 80008668 <sysname+0x120>
    80002880:	00003097          	auipc	ra,0x3
    80002884:	3b0080e7          	jalr	944(ra) # 80005c30 <panic>

0000000080002888 <iget>:
{
    80002888:	7179                	addi	sp,sp,-48
    8000288a:	f406                	sd	ra,40(sp)
    8000288c:	f022                	sd	s0,32(sp)
    8000288e:	ec26                	sd	s1,24(sp)
    80002890:	e84a                	sd	s2,16(sp)
    80002892:	e44e                	sd	s3,8(sp)
    80002894:	e052                	sd	s4,0(sp)
    80002896:	1800                	addi	s0,sp,48
    80002898:	89aa                	mv	s3,a0
    8000289a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000289c:	00015517          	auipc	a0,0x15
    800028a0:	edc50513          	addi	a0,a0,-292 # 80017778 <itable>
    800028a4:	00004097          	auipc	ra,0x4
    800028a8:	8c4080e7          	jalr	-1852(ra) # 80006168 <acquire>
  empty = 0;
    800028ac:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ae:	00015497          	auipc	s1,0x15
    800028b2:	ee248493          	addi	s1,s1,-286 # 80017790 <itable+0x18>
    800028b6:	00017697          	auipc	a3,0x17
    800028ba:	96a68693          	addi	a3,a3,-1686 # 80019220 <log>
    800028be:	a039                	j	800028cc <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028c0:	02090b63          	beqz	s2,800028f6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028c4:	08848493          	addi	s1,s1,136
    800028c8:	02d48a63          	beq	s1,a3,800028fc <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028cc:	449c                	lw	a5,8(s1)
    800028ce:	fef059e3          	blez	a5,800028c0 <iget+0x38>
    800028d2:	4098                	lw	a4,0(s1)
    800028d4:	ff3716e3          	bne	a4,s3,800028c0 <iget+0x38>
    800028d8:	40d8                	lw	a4,4(s1)
    800028da:	ff4713e3          	bne	a4,s4,800028c0 <iget+0x38>
      ip->ref++;
    800028de:	2785                	addiw	a5,a5,1
    800028e0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028e2:	00015517          	auipc	a0,0x15
    800028e6:	e9650513          	addi	a0,a0,-362 # 80017778 <itable>
    800028ea:	00004097          	auipc	ra,0x4
    800028ee:	932080e7          	jalr	-1742(ra) # 8000621c <release>
      return ip;
    800028f2:	8926                	mv	s2,s1
    800028f4:	a03d                	j	80002922 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028f6:	f7f9                	bnez	a5,800028c4 <iget+0x3c>
    800028f8:	8926                	mv	s2,s1
    800028fa:	b7e9                	j	800028c4 <iget+0x3c>
  if(empty == 0)
    800028fc:	02090c63          	beqz	s2,80002934 <iget+0xac>
  ip->dev = dev;
    80002900:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002904:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002908:	4785                	li	a5,1
    8000290a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000290e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002912:	00015517          	auipc	a0,0x15
    80002916:	e6650513          	addi	a0,a0,-410 # 80017778 <itable>
    8000291a:	00004097          	auipc	ra,0x4
    8000291e:	902080e7          	jalr	-1790(ra) # 8000621c <release>
}
    80002922:	854a                	mv	a0,s2
    80002924:	70a2                	ld	ra,40(sp)
    80002926:	7402                	ld	s0,32(sp)
    80002928:	64e2                	ld	s1,24(sp)
    8000292a:	6942                	ld	s2,16(sp)
    8000292c:	69a2                	ld	s3,8(sp)
    8000292e:	6a02                	ld	s4,0(sp)
    80002930:	6145                	addi	sp,sp,48
    80002932:	8082                	ret
    panic("iget: no inodes");
    80002934:	00006517          	auipc	a0,0x6
    80002938:	d4c50513          	addi	a0,a0,-692 # 80008680 <sysname+0x138>
    8000293c:	00003097          	auipc	ra,0x3
    80002940:	2f4080e7          	jalr	756(ra) # 80005c30 <panic>

0000000080002944 <fsinit>:
fsinit(int dev) {
    80002944:	7179                	addi	sp,sp,-48
    80002946:	f406                	sd	ra,40(sp)
    80002948:	f022                	sd	s0,32(sp)
    8000294a:	ec26                	sd	s1,24(sp)
    8000294c:	e84a                	sd	s2,16(sp)
    8000294e:	e44e                	sd	s3,8(sp)
    80002950:	1800                	addi	s0,sp,48
    80002952:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002954:	4585                	li	a1,1
    80002956:	00000097          	auipc	ra,0x0
    8000295a:	a66080e7          	jalr	-1434(ra) # 800023bc <bread>
    8000295e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002960:	00015997          	auipc	s3,0x15
    80002964:	df898993          	addi	s3,s3,-520 # 80017758 <sb>
    80002968:	02000613          	li	a2,32
    8000296c:	05850593          	addi	a1,a0,88
    80002970:	854e                	mv	a0,s3
    80002972:	ffffe097          	auipc	ra,0xffffe
    80002976:	888080e7          	jalr	-1912(ra) # 800001fa <memmove>
  brelse(bp);
    8000297a:	8526                	mv	a0,s1
    8000297c:	00000097          	auipc	ra,0x0
    80002980:	b70080e7          	jalr	-1168(ra) # 800024ec <brelse>
  if(sb.magic != FSMAGIC)
    80002984:	0009a703          	lw	a4,0(s3)
    80002988:	102037b7          	lui	a5,0x10203
    8000298c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002990:	02f71263          	bne	a4,a5,800029b4 <fsinit+0x70>
  initlog(dev, &sb);
    80002994:	00015597          	auipc	a1,0x15
    80002998:	dc458593          	addi	a1,a1,-572 # 80017758 <sb>
    8000299c:	854a                	mv	a0,s2
    8000299e:	00001097          	auipc	ra,0x1
    800029a2:	b56080e7          	jalr	-1194(ra) # 800034f4 <initlog>
}
    800029a6:	70a2                	ld	ra,40(sp)
    800029a8:	7402                	ld	s0,32(sp)
    800029aa:	64e2                	ld	s1,24(sp)
    800029ac:	6942                	ld	s2,16(sp)
    800029ae:	69a2                	ld	s3,8(sp)
    800029b0:	6145                	addi	sp,sp,48
    800029b2:	8082                	ret
    panic("invalid file system");
    800029b4:	00006517          	auipc	a0,0x6
    800029b8:	cdc50513          	addi	a0,a0,-804 # 80008690 <sysname+0x148>
    800029bc:	00003097          	auipc	ra,0x3
    800029c0:	274080e7          	jalr	628(ra) # 80005c30 <panic>

00000000800029c4 <iinit>:
{
    800029c4:	7179                	addi	sp,sp,-48
    800029c6:	f406                	sd	ra,40(sp)
    800029c8:	f022                	sd	s0,32(sp)
    800029ca:	ec26                	sd	s1,24(sp)
    800029cc:	e84a                	sd	s2,16(sp)
    800029ce:	e44e                	sd	s3,8(sp)
    800029d0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029d2:	00006597          	auipc	a1,0x6
    800029d6:	cd658593          	addi	a1,a1,-810 # 800086a8 <sysname+0x160>
    800029da:	00015517          	auipc	a0,0x15
    800029de:	d9e50513          	addi	a0,a0,-610 # 80017778 <itable>
    800029e2:	00003097          	auipc	ra,0x3
    800029e6:	6f6080e7          	jalr	1782(ra) # 800060d8 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029ea:	00015497          	auipc	s1,0x15
    800029ee:	db648493          	addi	s1,s1,-586 # 800177a0 <itable+0x28>
    800029f2:	00017997          	auipc	s3,0x17
    800029f6:	83e98993          	addi	s3,s3,-1986 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029fa:	00006917          	auipc	s2,0x6
    800029fe:	cb690913          	addi	s2,s2,-842 # 800086b0 <sysname+0x168>
    80002a02:	85ca                	mv	a1,s2
    80002a04:	8526                	mv	a0,s1
    80002a06:	00001097          	auipc	ra,0x1
    80002a0a:	e4e080e7          	jalr	-434(ra) # 80003854 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a0e:	08848493          	addi	s1,s1,136
    80002a12:	ff3498e3          	bne	s1,s3,80002a02 <iinit+0x3e>
}
    80002a16:	70a2                	ld	ra,40(sp)
    80002a18:	7402                	ld	s0,32(sp)
    80002a1a:	64e2                	ld	s1,24(sp)
    80002a1c:	6942                	ld	s2,16(sp)
    80002a1e:	69a2                	ld	s3,8(sp)
    80002a20:	6145                	addi	sp,sp,48
    80002a22:	8082                	ret

0000000080002a24 <ialloc>:
{
    80002a24:	715d                	addi	sp,sp,-80
    80002a26:	e486                	sd	ra,72(sp)
    80002a28:	e0a2                	sd	s0,64(sp)
    80002a2a:	fc26                	sd	s1,56(sp)
    80002a2c:	f84a                	sd	s2,48(sp)
    80002a2e:	f44e                	sd	s3,40(sp)
    80002a30:	f052                	sd	s4,32(sp)
    80002a32:	ec56                	sd	s5,24(sp)
    80002a34:	e85a                	sd	s6,16(sp)
    80002a36:	e45e                	sd	s7,8(sp)
    80002a38:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a3a:	00015717          	auipc	a4,0x15
    80002a3e:	d2a72703          	lw	a4,-726(a4) # 80017764 <sb+0xc>
    80002a42:	4785                	li	a5,1
    80002a44:	04e7fa63          	bgeu	a5,a4,80002a98 <ialloc+0x74>
    80002a48:	8aaa                	mv	s5,a0
    80002a4a:	8bae                	mv	s7,a1
    80002a4c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a4e:	00015a17          	auipc	s4,0x15
    80002a52:	d0aa0a13          	addi	s4,s4,-758 # 80017758 <sb>
    80002a56:	00048b1b          	sext.w	s6,s1
    80002a5a:	0044d593          	srli	a1,s1,0x4
    80002a5e:	018a2783          	lw	a5,24(s4)
    80002a62:	9dbd                	addw	a1,a1,a5
    80002a64:	8556                	mv	a0,s5
    80002a66:	00000097          	auipc	ra,0x0
    80002a6a:	956080e7          	jalr	-1706(ra) # 800023bc <bread>
    80002a6e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a70:	05850993          	addi	s3,a0,88
    80002a74:	00f4f793          	andi	a5,s1,15
    80002a78:	079a                	slli	a5,a5,0x6
    80002a7a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a7c:	00099783          	lh	a5,0(s3)
    80002a80:	c785                	beqz	a5,80002aa8 <ialloc+0x84>
    brelse(bp);
    80002a82:	00000097          	auipc	ra,0x0
    80002a86:	a6a080e7          	jalr	-1430(ra) # 800024ec <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a8a:	0485                	addi	s1,s1,1
    80002a8c:	00ca2703          	lw	a4,12(s4)
    80002a90:	0004879b          	sext.w	a5,s1
    80002a94:	fce7e1e3          	bltu	a5,a4,80002a56 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a98:	00006517          	auipc	a0,0x6
    80002a9c:	c2050513          	addi	a0,a0,-992 # 800086b8 <sysname+0x170>
    80002aa0:	00003097          	auipc	ra,0x3
    80002aa4:	190080e7          	jalr	400(ra) # 80005c30 <panic>
      memset(dip, 0, sizeof(*dip));
    80002aa8:	04000613          	li	a2,64
    80002aac:	4581                	li	a1,0
    80002aae:	854e                	mv	a0,s3
    80002ab0:	ffffd097          	auipc	ra,0xffffd
    80002ab4:	6ee080e7          	jalr	1774(ra) # 8000019e <memset>
      dip->type = type;
    80002ab8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002abc:	854a                	mv	a0,s2
    80002abe:	00001097          	auipc	ra,0x1
    80002ac2:	cb2080e7          	jalr	-846(ra) # 80003770 <log_write>
      brelse(bp);
    80002ac6:	854a                	mv	a0,s2
    80002ac8:	00000097          	auipc	ra,0x0
    80002acc:	a24080e7          	jalr	-1500(ra) # 800024ec <brelse>
      return iget(dev, inum);
    80002ad0:	85da                	mv	a1,s6
    80002ad2:	8556                	mv	a0,s5
    80002ad4:	00000097          	auipc	ra,0x0
    80002ad8:	db4080e7          	jalr	-588(ra) # 80002888 <iget>
}
    80002adc:	60a6                	ld	ra,72(sp)
    80002ade:	6406                	ld	s0,64(sp)
    80002ae0:	74e2                	ld	s1,56(sp)
    80002ae2:	7942                	ld	s2,48(sp)
    80002ae4:	79a2                	ld	s3,40(sp)
    80002ae6:	7a02                	ld	s4,32(sp)
    80002ae8:	6ae2                	ld	s5,24(sp)
    80002aea:	6b42                	ld	s6,16(sp)
    80002aec:	6ba2                	ld	s7,8(sp)
    80002aee:	6161                	addi	sp,sp,80
    80002af0:	8082                	ret

0000000080002af2 <iupdate>:
{
    80002af2:	1101                	addi	sp,sp,-32
    80002af4:	ec06                	sd	ra,24(sp)
    80002af6:	e822                	sd	s0,16(sp)
    80002af8:	e426                	sd	s1,8(sp)
    80002afa:	e04a                	sd	s2,0(sp)
    80002afc:	1000                	addi	s0,sp,32
    80002afe:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b00:	415c                	lw	a5,4(a0)
    80002b02:	0047d79b          	srliw	a5,a5,0x4
    80002b06:	00015597          	auipc	a1,0x15
    80002b0a:	c6a5a583          	lw	a1,-918(a1) # 80017770 <sb+0x18>
    80002b0e:	9dbd                	addw	a1,a1,a5
    80002b10:	4108                	lw	a0,0(a0)
    80002b12:	00000097          	auipc	ra,0x0
    80002b16:	8aa080e7          	jalr	-1878(ra) # 800023bc <bread>
    80002b1a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b1c:	05850793          	addi	a5,a0,88
    80002b20:	40d8                	lw	a4,4(s1)
    80002b22:	8b3d                	andi	a4,a4,15
    80002b24:	071a                	slli	a4,a4,0x6
    80002b26:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b28:	04449703          	lh	a4,68(s1)
    80002b2c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b30:	04649703          	lh	a4,70(s1)
    80002b34:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b38:	04849703          	lh	a4,72(s1)
    80002b3c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b40:	04a49703          	lh	a4,74(s1)
    80002b44:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b48:	44f8                	lw	a4,76(s1)
    80002b4a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b4c:	03400613          	li	a2,52
    80002b50:	05048593          	addi	a1,s1,80
    80002b54:	00c78513          	addi	a0,a5,12
    80002b58:	ffffd097          	auipc	ra,0xffffd
    80002b5c:	6a2080e7          	jalr	1698(ra) # 800001fa <memmove>
  log_write(bp);
    80002b60:	854a                	mv	a0,s2
    80002b62:	00001097          	auipc	ra,0x1
    80002b66:	c0e080e7          	jalr	-1010(ra) # 80003770 <log_write>
  brelse(bp);
    80002b6a:	854a                	mv	a0,s2
    80002b6c:	00000097          	auipc	ra,0x0
    80002b70:	980080e7          	jalr	-1664(ra) # 800024ec <brelse>
}
    80002b74:	60e2                	ld	ra,24(sp)
    80002b76:	6442                	ld	s0,16(sp)
    80002b78:	64a2                	ld	s1,8(sp)
    80002b7a:	6902                	ld	s2,0(sp)
    80002b7c:	6105                	addi	sp,sp,32
    80002b7e:	8082                	ret

0000000080002b80 <idup>:
{
    80002b80:	1101                	addi	sp,sp,-32
    80002b82:	ec06                	sd	ra,24(sp)
    80002b84:	e822                	sd	s0,16(sp)
    80002b86:	e426                	sd	s1,8(sp)
    80002b88:	1000                	addi	s0,sp,32
    80002b8a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b8c:	00015517          	auipc	a0,0x15
    80002b90:	bec50513          	addi	a0,a0,-1044 # 80017778 <itable>
    80002b94:	00003097          	auipc	ra,0x3
    80002b98:	5d4080e7          	jalr	1492(ra) # 80006168 <acquire>
  ip->ref++;
    80002b9c:	449c                	lw	a5,8(s1)
    80002b9e:	2785                	addiw	a5,a5,1
    80002ba0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ba2:	00015517          	auipc	a0,0x15
    80002ba6:	bd650513          	addi	a0,a0,-1066 # 80017778 <itable>
    80002baa:	00003097          	auipc	ra,0x3
    80002bae:	672080e7          	jalr	1650(ra) # 8000621c <release>
}
    80002bb2:	8526                	mv	a0,s1
    80002bb4:	60e2                	ld	ra,24(sp)
    80002bb6:	6442                	ld	s0,16(sp)
    80002bb8:	64a2                	ld	s1,8(sp)
    80002bba:	6105                	addi	sp,sp,32
    80002bbc:	8082                	ret

0000000080002bbe <ilock>:
{
    80002bbe:	1101                	addi	sp,sp,-32
    80002bc0:	ec06                	sd	ra,24(sp)
    80002bc2:	e822                	sd	s0,16(sp)
    80002bc4:	e426                	sd	s1,8(sp)
    80002bc6:	e04a                	sd	s2,0(sp)
    80002bc8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bca:	c115                	beqz	a0,80002bee <ilock+0x30>
    80002bcc:	84aa                	mv	s1,a0
    80002bce:	451c                	lw	a5,8(a0)
    80002bd0:	00f05f63          	blez	a5,80002bee <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bd4:	0541                	addi	a0,a0,16
    80002bd6:	00001097          	auipc	ra,0x1
    80002bda:	cb8080e7          	jalr	-840(ra) # 8000388e <acquiresleep>
  if(ip->valid == 0){
    80002bde:	40bc                	lw	a5,64(s1)
    80002be0:	cf99                	beqz	a5,80002bfe <ilock+0x40>
}
    80002be2:	60e2                	ld	ra,24(sp)
    80002be4:	6442                	ld	s0,16(sp)
    80002be6:	64a2                	ld	s1,8(sp)
    80002be8:	6902                	ld	s2,0(sp)
    80002bea:	6105                	addi	sp,sp,32
    80002bec:	8082                	ret
    panic("ilock");
    80002bee:	00006517          	auipc	a0,0x6
    80002bf2:	ae250513          	addi	a0,a0,-1310 # 800086d0 <sysname+0x188>
    80002bf6:	00003097          	auipc	ra,0x3
    80002bfa:	03a080e7          	jalr	58(ra) # 80005c30 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bfe:	40dc                	lw	a5,4(s1)
    80002c00:	0047d79b          	srliw	a5,a5,0x4
    80002c04:	00015597          	auipc	a1,0x15
    80002c08:	b6c5a583          	lw	a1,-1172(a1) # 80017770 <sb+0x18>
    80002c0c:	9dbd                	addw	a1,a1,a5
    80002c0e:	4088                	lw	a0,0(s1)
    80002c10:	fffff097          	auipc	ra,0xfffff
    80002c14:	7ac080e7          	jalr	1964(ra) # 800023bc <bread>
    80002c18:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c1a:	05850593          	addi	a1,a0,88
    80002c1e:	40dc                	lw	a5,4(s1)
    80002c20:	8bbd                	andi	a5,a5,15
    80002c22:	079a                	slli	a5,a5,0x6
    80002c24:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c26:	00059783          	lh	a5,0(a1)
    80002c2a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c2e:	00259783          	lh	a5,2(a1)
    80002c32:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c36:	00459783          	lh	a5,4(a1)
    80002c3a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c3e:	00659783          	lh	a5,6(a1)
    80002c42:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c46:	459c                	lw	a5,8(a1)
    80002c48:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c4a:	03400613          	li	a2,52
    80002c4e:	05b1                	addi	a1,a1,12
    80002c50:	05048513          	addi	a0,s1,80
    80002c54:	ffffd097          	auipc	ra,0xffffd
    80002c58:	5a6080e7          	jalr	1446(ra) # 800001fa <memmove>
    brelse(bp);
    80002c5c:	854a                	mv	a0,s2
    80002c5e:	00000097          	auipc	ra,0x0
    80002c62:	88e080e7          	jalr	-1906(ra) # 800024ec <brelse>
    ip->valid = 1;
    80002c66:	4785                	li	a5,1
    80002c68:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c6a:	04449783          	lh	a5,68(s1)
    80002c6e:	fbb5                	bnez	a5,80002be2 <ilock+0x24>
      panic("ilock: no type");
    80002c70:	00006517          	auipc	a0,0x6
    80002c74:	a6850513          	addi	a0,a0,-1432 # 800086d8 <sysname+0x190>
    80002c78:	00003097          	auipc	ra,0x3
    80002c7c:	fb8080e7          	jalr	-72(ra) # 80005c30 <panic>

0000000080002c80 <iunlock>:
{
    80002c80:	1101                	addi	sp,sp,-32
    80002c82:	ec06                	sd	ra,24(sp)
    80002c84:	e822                	sd	s0,16(sp)
    80002c86:	e426                	sd	s1,8(sp)
    80002c88:	e04a                	sd	s2,0(sp)
    80002c8a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c8c:	c905                	beqz	a0,80002cbc <iunlock+0x3c>
    80002c8e:	84aa                	mv	s1,a0
    80002c90:	01050913          	addi	s2,a0,16
    80002c94:	854a                	mv	a0,s2
    80002c96:	00001097          	auipc	ra,0x1
    80002c9a:	c92080e7          	jalr	-878(ra) # 80003928 <holdingsleep>
    80002c9e:	cd19                	beqz	a0,80002cbc <iunlock+0x3c>
    80002ca0:	449c                	lw	a5,8(s1)
    80002ca2:	00f05d63          	blez	a5,80002cbc <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ca6:	854a                	mv	a0,s2
    80002ca8:	00001097          	auipc	ra,0x1
    80002cac:	c3c080e7          	jalr	-964(ra) # 800038e4 <releasesleep>
}
    80002cb0:	60e2                	ld	ra,24(sp)
    80002cb2:	6442                	ld	s0,16(sp)
    80002cb4:	64a2                	ld	s1,8(sp)
    80002cb6:	6902                	ld	s2,0(sp)
    80002cb8:	6105                	addi	sp,sp,32
    80002cba:	8082                	ret
    panic("iunlock");
    80002cbc:	00006517          	auipc	a0,0x6
    80002cc0:	a2c50513          	addi	a0,a0,-1492 # 800086e8 <sysname+0x1a0>
    80002cc4:	00003097          	auipc	ra,0x3
    80002cc8:	f6c080e7          	jalr	-148(ra) # 80005c30 <panic>

0000000080002ccc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ccc:	7179                	addi	sp,sp,-48
    80002cce:	f406                	sd	ra,40(sp)
    80002cd0:	f022                	sd	s0,32(sp)
    80002cd2:	ec26                	sd	s1,24(sp)
    80002cd4:	e84a                	sd	s2,16(sp)
    80002cd6:	e44e                	sd	s3,8(sp)
    80002cd8:	e052                	sd	s4,0(sp)
    80002cda:	1800                	addi	s0,sp,48
    80002cdc:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cde:	05050493          	addi	s1,a0,80
    80002ce2:	08050913          	addi	s2,a0,128
    80002ce6:	a021                	j	80002cee <itrunc+0x22>
    80002ce8:	0491                	addi	s1,s1,4
    80002cea:	01248d63          	beq	s1,s2,80002d04 <itrunc+0x38>
    if(ip->addrs[i]){
    80002cee:	408c                	lw	a1,0(s1)
    80002cf0:	dde5                	beqz	a1,80002ce8 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cf2:	0009a503          	lw	a0,0(s3)
    80002cf6:	00000097          	auipc	ra,0x0
    80002cfa:	90c080e7          	jalr	-1780(ra) # 80002602 <bfree>
      ip->addrs[i] = 0;
    80002cfe:	0004a023          	sw	zero,0(s1)
    80002d02:	b7dd                	j	80002ce8 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d04:	0809a583          	lw	a1,128(s3)
    80002d08:	e185                	bnez	a1,80002d28 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d0a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d0e:	854e                	mv	a0,s3
    80002d10:	00000097          	auipc	ra,0x0
    80002d14:	de2080e7          	jalr	-542(ra) # 80002af2 <iupdate>
}
    80002d18:	70a2                	ld	ra,40(sp)
    80002d1a:	7402                	ld	s0,32(sp)
    80002d1c:	64e2                	ld	s1,24(sp)
    80002d1e:	6942                	ld	s2,16(sp)
    80002d20:	69a2                	ld	s3,8(sp)
    80002d22:	6a02                	ld	s4,0(sp)
    80002d24:	6145                	addi	sp,sp,48
    80002d26:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d28:	0009a503          	lw	a0,0(s3)
    80002d2c:	fffff097          	auipc	ra,0xfffff
    80002d30:	690080e7          	jalr	1680(ra) # 800023bc <bread>
    80002d34:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d36:	05850493          	addi	s1,a0,88
    80002d3a:	45850913          	addi	s2,a0,1112
    80002d3e:	a021                	j	80002d46 <itrunc+0x7a>
    80002d40:	0491                	addi	s1,s1,4
    80002d42:	01248b63          	beq	s1,s2,80002d58 <itrunc+0x8c>
      if(a[j])
    80002d46:	408c                	lw	a1,0(s1)
    80002d48:	dde5                	beqz	a1,80002d40 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d4a:	0009a503          	lw	a0,0(s3)
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	8b4080e7          	jalr	-1868(ra) # 80002602 <bfree>
    80002d56:	b7ed                	j	80002d40 <itrunc+0x74>
    brelse(bp);
    80002d58:	8552                	mv	a0,s4
    80002d5a:	fffff097          	auipc	ra,0xfffff
    80002d5e:	792080e7          	jalr	1938(ra) # 800024ec <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d62:	0809a583          	lw	a1,128(s3)
    80002d66:	0009a503          	lw	a0,0(s3)
    80002d6a:	00000097          	auipc	ra,0x0
    80002d6e:	898080e7          	jalr	-1896(ra) # 80002602 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d72:	0809a023          	sw	zero,128(s3)
    80002d76:	bf51                	j	80002d0a <itrunc+0x3e>

0000000080002d78 <iput>:
{
    80002d78:	1101                	addi	sp,sp,-32
    80002d7a:	ec06                	sd	ra,24(sp)
    80002d7c:	e822                	sd	s0,16(sp)
    80002d7e:	e426                	sd	s1,8(sp)
    80002d80:	e04a                	sd	s2,0(sp)
    80002d82:	1000                	addi	s0,sp,32
    80002d84:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d86:	00015517          	auipc	a0,0x15
    80002d8a:	9f250513          	addi	a0,a0,-1550 # 80017778 <itable>
    80002d8e:	00003097          	auipc	ra,0x3
    80002d92:	3da080e7          	jalr	986(ra) # 80006168 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d96:	4498                	lw	a4,8(s1)
    80002d98:	4785                	li	a5,1
    80002d9a:	02f70363          	beq	a4,a5,80002dc0 <iput+0x48>
  ip->ref--;
    80002d9e:	449c                	lw	a5,8(s1)
    80002da0:	37fd                	addiw	a5,a5,-1
    80002da2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002da4:	00015517          	auipc	a0,0x15
    80002da8:	9d450513          	addi	a0,a0,-1580 # 80017778 <itable>
    80002dac:	00003097          	auipc	ra,0x3
    80002db0:	470080e7          	jalr	1136(ra) # 8000621c <release>
}
    80002db4:	60e2                	ld	ra,24(sp)
    80002db6:	6442                	ld	s0,16(sp)
    80002db8:	64a2                	ld	s1,8(sp)
    80002dba:	6902                	ld	s2,0(sp)
    80002dbc:	6105                	addi	sp,sp,32
    80002dbe:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dc0:	40bc                	lw	a5,64(s1)
    80002dc2:	dff1                	beqz	a5,80002d9e <iput+0x26>
    80002dc4:	04a49783          	lh	a5,74(s1)
    80002dc8:	fbf9                	bnez	a5,80002d9e <iput+0x26>
    acquiresleep(&ip->lock);
    80002dca:	01048913          	addi	s2,s1,16
    80002dce:	854a                	mv	a0,s2
    80002dd0:	00001097          	auipc	ra,0x1
    80002dd4:	abe080e7          	jalr	-1346(ra) # 8000388e <acquiresleep>
    release(&itable.lock);
    80002dd8:	00015517          	auipc	a0,0x15
    80002ddc:	9a050513          	addi	a0,a0,-1632 # 80017778 <itable>
    80002de0:	00003097          	auipc	ra,0x3
    80002de4:	43c080e7          	jalr	1084(ra) # 8000621c <release>
    itrunc(ip);
    80002de8:	8526                	mv	a0,s1
    80002dea:	00000097          	auipc	ra,0x0
    80002dee:	ee2080e7          	jalr	-286(ra) # 80002ccc <itrunc>
    ip->type = 0;
    80002df2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002df6:	8526                	mv	a0,s1
    80002df8:	00000097          	auipc	ra,0x0
    80002dfc:	cfa080e7          	jalr	-774(ra) # 80002af2 <iupdate>
    ip->valid = 0;
    80002e00:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e04:	854a                	mv	a0,s2
    80002e06:	00001097          	auipc	ra,0x1
    80002e0a:	ade080e7          	jalr	-1314(ra) # 800038e4 <releasesleep>
    acquire(&itable.lock);
    80002e0e:	00015517          	auipc	a0,0x15
    80002e12:	96a50513          	addi	a0,a0,-1686 # 80017778 <itable>
    80002e16:	00003097          	auipc	ra,0x3
    80002e1a:	352080e7          	jalr	850(ra) # 80006168 <acquire>
    80002e1e:	b741                	j	80002d9e <iput+0x26>

0000000080002e20 <iunlockput>:
{
    80002e20:	1101                	addi	sp,sp,-32
    80002e22:	ec06                	sd	ra,24(sp)
    80002e24:	e822                	sd	s0,16(sp)
    80002e26:	e426                	sd	s1,8(sp)
    80002e28:	1000                	addi	s0,sp,32
    80002e2a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	e54080e7          	jalr	-428(ra) # 80002c80 <iunlock>
  iput(ip);
    80002e34:	8526                	mv	a0,s1
    80002e36:	00000097          	auipc	ra,0x0
    80002e3a:	f42080e7          	jalr	-190(ra) # 80002d78 <iput>
}
    80002e3e:	60e2                	ld	ra,24(sp)
    80002e40:	6442                	ld	s0,16(sp)
    80002e42:	64a2                	ld	s1,8(sp)
    80002e44:	6105                	addi	sp,sp,32
    80002e46:	8082                	ret

0000000080002e48 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e48:	1141                	addi	sp,sp,-16
    80002e4a:	e422                	sd	s0,8(sp)
    80002e4c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e4e:	411c                	lw	a5,0(a0)
    80002e50:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e52:	415c                	lw	a5,4(a0)
    80002e54:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e56:	04451783          	lh	a5,68(a0)
    80002e5a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e5e:	04a51783          	lh	a5,74(a0)
    80002e62:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e66:	04c56783          	lwu	a5,76(a0)
    80002e6a:	e99c                	sd	a5,16(a1)
}
    80002e6c:	6422                	ld	s0,8(sp)
    80002e6e:	0141                	addi	sp,sp,16
    80002e70:	8082                	ret

0000000080002e72 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e72:	457c                	lw	a5,76(a0)
    80002e74:	0ed7e963          	bltu	a5,a3,80002f66 <readi+0xf4>
{
    80002e78:	7159                	addi	sp,sp,-112
    80002e7a:	f486                	sd	ra,104(sp)
    80002e7c:	f0a2                	sd	s0,96(sp)
    80002e7e:	eca6                	sd	s1,88(sp)
    80002e80:	e8ca                	sd	s2,80(sp)
    80002e82:	e4ce                	sd	s3,72(sp)
    80002e84:	e0d2                	sd	s4,64(sp)
    80002e86:	fc56                	sd	s5,56(sp)
    80002e88:	f85a                	sd	s6,48(sp)
    80002e8a:	f45e                	sd	s7,40(sp)
    80002e8c:	f062                	sd	s8,32(sp)
    80002e8e:	ec66                	sd	s9,24(sp)
    80002e90:	e86a                	sd	s10,16(sp)
    80002e92:	e46e                	sd	s11,8(sp)
    80002e94:	1880                	addi	s0,sp,112
    80002e96:	8baa                	mv	s7,a0
    80002e98:	8c2e                	mv	s8,a1
    80002e9a:	8ab2                	mv	s5,a2
    80002e9c:	84b6                	mv	s1,a3
    80002e9e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ea0:	9f35                	addw	a4,a4,a3
    return 0;
    80002ea2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ea4:	0ad76063          	bltu	a4,a3,80002f44 <readi+0xd2>
  if(off + n > ip->size)
    80002ea8:	00e7f463          	bgeu	a5,a4,80002eb0 <readi+0x3e>
    n = ip->size - off;
    80002eac:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eb0:	0a0b0963          	beqz	s6,80002f62 <readi+0xf0>
    80002eb4:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eb6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002eba:	5cfd                	li	s9,-1
    80002ebc:	a82d                	j	80002ef6 <readi+0x84>
    80002ebe:	020a1d93          	slli	s11,s4,0x20
    80002ec2:	020ddd93          	srli	s11,s11,0x20
    80002ec6:	05890613          	addi	a2,s2,88
    80002eca:	86ee                	mv	a3,s11
    80002ecc:	963a                	add	a2,a2,a4
    80002ece:	85d6                	mv	a1,s5
    80002ed0:	8562                	mv	a0,s8
    80002ed2:	fffff097          	auipc	ra,0xfffff
    80002ed6:	a06080e7          	jalr	-1530(ra) # 800018d8 <either_copyout>
    80002eda:	05950d63          	beq	a0,s9,80002f34 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ede:	854a                	mv	a0,s2
    80002ee0:	fffff097          	auipc	ra,0xfffff
    80002ee4:	60c080e7          	jalr	1548(ra) # 800024ec <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ee8:	013a09bb          	addw	s3,s4,s3
    80002eec:	009a04bb          	addw	s1,s4,s1
    80002ef0:	9aee                	add	s5,s5,s11
    80002ef2:	0569f763          	bgeu	s3,s6,80002f40 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ef6:	000ba903          	lw	s2,0(s7)
    80002efa:	00a4d59b          	srliw	a1,s1,0xa
    80002efe:	855e                	mv	a0,s7
    80002f00:	00000097          	auipc	ra,0x0
    80002f04:	8ac080e7          	jalr	-1876(ra) # 800027ac <bmap>
    80002f08:	0005059b          	sext.w	a1,a0
    80002f0c:	854a                	mv	a0,s2
    80002f0e:	fffff097          	auipc	ra,0xfffff
    80002f12:	4ae080e7          	jalr	1198(ra) # 800023bc <bread>
    80002f16:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f18:	3ff4f713          	andi	a4,s1,1023
    80002f1c:	40ed07bb          	subw	a5,s10,a4
    80002f20:	413b06bb          	subw	a3,s6,s3
    80002f24:	8a3e                	mv	s4,a5
    80002f26:	2781                	sext.w	a5,a5
    80002f28:	0006861b          	sext.w	a2,a3
    80002f2c:	f8f679e3          	bgeu	a2,a5,80002ebe <readi+0x4c>
    80002f30:	8a36                	mv	s4,a3
    80002f32:	b771                	j	80002ebe <readi+0x4c>
      brelse(bp);
    80002f34:	854a                	mv	a0,s2
    80002f36:	fffff097          	auipc	ra,0xfffff
    80002f3a:	5b6080e7          	jalr	1462(ra) # 800024ec <brelse>
      tot = -1;
    80002f3e:	59fd                	li	s3,-1
  }
  return tot;
    80002f40:	0009851b          	sext.w	a0,s3
}
    80002f44:	70a6                	ld	ra,104(sp)
    80002f46:	7406                	ld	s0,96(sp)
    80002f48:	64e6                	ld	s1,88(sp)
    80002f4a:	6946                	ld	s2,80(sp)
    80002f4c:	69a6                	ld	s3,72(sp)
    80002f4e:	6a06                	ld	s4,64(sp)
    80002f50:	7ae2                	ld	s5,56(sp)
    80002f52:	7b42                	ld	s6,48(sp)
    80002f54:	7ba2                	ld	s7,40(sp)
    80002f56:	7c02                	ld	s8,32(sp)
    80002f58:	6ce2                	ld	s9,24(sp)
    80002f5a:	6d42                	ld	s10,16(sp)
    80002f5c:	6da2                	ld	s11,8(sp)
    80002f5e:	6165                	addi	sp,sp,112
    80002f60:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f62:	89da                	mv	s3,s6
    80002f64:	bff1                	j	80002f40 <readi+0xce>
    return 0;
    80002f66:	4501                	li	a0,0
}
    80002f68:	8082                	ret

0000000080002f6a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f6a:	457c                	lw	a5,76(a0)
    80002f6c:	10d7e863          	bltu	a5,a3,8000307c <writei+0x112>
{
    80002f70:	7159                	addi	sp,sp,-112
    80002f72:	f486                	sd	ra,104(sp)
    80002f74:	f0a2                	sd	s0,96(sp)
    80002f76:	eca6                	sd	s1,88(sp)
    80002f78:	e8ca                	sd	s2,80(sp)
    80002f7a:	e4ce                	sd	s3,72(sp)
    80002f7c:	e0d2                	sd	s4,64(sp)
    80002f7e:	fc56                	sd	s5,56(sp)
    80002f80:	f85a                	sd	s6,48(sp)
    80002f82:	f45e                	sd	s7,40(sp)
    80002f84:	f062                	sd	s8,32(sp)
    80002f86:	ec66                	sd	s9,24(sp)
    80002f88:	e86a                	sd	s10,16(sp)
    80002f8a:	e46e                	sd	s11,8(sp)
    80002f8c:	1880                	addi	s0,sp,112
    80002f8e:	8b2a                	mv	s6,a0
    80002f90:	8c2e                	mv	s8,a1
    80002f92:	8ab2                	mv	s5,a2
    80002f94:	8936                	mv	s2,a3
    80002f96:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f98:	00e687bb          	addw	a5,a3,a4
    80002f9c:	0ed7e263          	bltu	a5,a3,80003080 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fa0:	00043737          	lui	a4,0x43
    80002fa4:	0ef76063          	bltu	a4,a5,80003084 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fa8:	0c0b8863          	beqz	s7,80003078 <writei+0x10e>
    80002fac:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fae:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fb2:	5cfd                	li	s9,-1
    80002fb4:	a091                	j	80002ff8 <writei+0x8e>
    80002fb6:	02099d93          	slli	s11,s3,0x20
    80002fba:	020ddd93          	srli	s11,s11,0x20
    80002fbe:	05848513          	addi	a0,s1,88
    80002fc2:	86ee                	mv	a3,s11
    80002fc4:	8656                	mv	a2,s5
    80002fc6:	85e2                	mv	a1,s8
    80002fc8:	953a                	add	a0,a0,a4
    80002fca:	fffff097          	auipc	ra,0xfffff
    80002fce:	964080e7          	jalr	-1692(ra) # 8000192e <either_copyin>
    80002fd2:	07950263          	beq	a0,s9,80003036 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fd6:	8526                	mv	a0,s1
    80002fd8:	00000097          	auipc	ra,0x0
    80002fdc:	798080e7          	jalr	1944(ra) # 80003770 <log_write>
    brelse(bp);
    80002fe0:	8526                	mv	a0,s1
    80002fe2:	fffff097          	auipc	ra,0xfffff
    80002fe6:	50a080e7          	jalr	1290(ra) # 800024ec <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fea:	01498a3b          	addw	s4,s3,s4
    80002fee:	0129893b          	addw	s2,s3,s2
    80002ff2:	9aee                	add	s5,s5,s11
    80002ff4:	057a7663          	bgeu	s4,s7,80003040 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ff8:	000b2483          	lw	s1,0(s6)
    80002ffc:	00a9559b          	srliw	a1,s2,0xa
    80003000:	855a                	mv	a0,s6
    80003002:	fffff097          	auipc	ra,0xfffff
    80003006:	7aa080e7          	jalr	1962(ra) # 800027ac <bmap>
    8000300a:	0005059b          	sext.w	a1,a0
    8000300e:	8526                	mv	a0,s1
    80003010:	fffff097          	auipc	ra,0xfffff
    80003014:	3ac080e7          	jalr	940(ra) # 800023bc <bread>
    80003018:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000301a:	3ff97713          	andi	a4,s2,1023
    8000301e:	40ed07bb          	subw	a5,s10,a4
    80003022:	414b86bb          	subw	a3,s7,s4
    80003026:	89be                	mv	s3,a5
    80003028:	2781                	sext.w	a5,a5
    8000302a:	0006861b          	sext.w	a2,a3
    8000302e:	f8f674e3          	bgeu	a2,a5,80002fb6 <writei+0x4c>
    80003032:	89b6                	mv	s3,a3
    80003034:	b749                	j	80002fb6 <writei+0x4c>
      brelse(bp);
    80003036:	8526                	mv	a0,s1
    80003038:	fffff097          	auipc	ra,0xfffff
    8000303c:	4b4080e7          	jalr	1204(ra) # 800024ec <brelse>
  }

  if(off > ip->size)
    80003040:	04cb2783          	lw	a5,76(s6)
    80003044:	0127f463          	bgeu	a5,s2,8000304c <writei+0xe2>
    ip->size = off;
    80003048:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000304c:	855a                	mv	a0,s6
    8000304e:	00000097          	auipc	ra,0x0
    80003052:	aa4080e7          	jalr	-1372(ra) # 80002af2 <iupdate>

  return tot;
    80003056:	000a051b          	sext.w	a0,s4
}
    8000305a:	70a6                	ld	ra,104(sp)
    8000305c:	7406                	ld	s0,96(sp)
    8000305e:	64e6                	ld	s1,88(sp)
    80003060:	6946                	ld	s2,80(sp)
    80003062:	69a6                	ld	s3,72(sp)
    80003064:	6a06                	ld	s4,64(sp)
    80003066:	7ae2                	ld	s5,56(sp)
    80003068:	7b42                	ld	s6,48(sp)
    8000306a:	7ba2                	ld	s7,40(sp)
    8000306c:	7c02                	ld	s8,32(sp)
    8000306e:	6ce2                	ld	s9,24(sp)
    80003070:	6d42                	ld	s10,16(sp)
    80003072:	6da2                	ld	s11,8(sp)
    80003074:	6165                	addi	sp,sp,112
    80003076:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003078:	8a5e                	mv	s4,s7
    8000307a:	bfc9                	j	8000304c <writei+0xe2>
    return -1;
    8000307c:	557d                	li	a0,-1
}
    8000307e:	8082                	ret
    return -1;
    80003080:	557d                	li	a0,-1
    80003082:	bfe1                	j	8000305a <writei+0xf0>
    return -1;
    80003084:	557d                	li	a0,-1
    80003086:	bfd1                	j	8000305a <writei+0xf0>

0000000080003088 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003088:	1141                	addi	sp,sp,-16
    8000308a:	e406                	sd	ra,8(sp)
    8000308c:	e022                	sd	s0,0(sp)
    8000308e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003090:	4639                	li	a2,14
    80003092:	ffffd097          	auipc	ra,0xffffd
    80003096:	1dc080e7          	jalr	476(ra) # 8000026e <strncmp>
}
    8000309a:	60a2                	ld	ra,8(sp)
    8000309c:	6402                	ld	s0,0(sp)
    8000309e:	0141                	addi	sp,sp,16
    800030a0:	8082                	ret

00000000800030a2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030a2:	7139                	addi	sp,sp,-64
    800030a4:	fc06                	sd	ra,56(sp)
    800030a6:	f822                	sd	s0,48(sp)
    800030a8:	f426                	sd	s1,40(sp)
    800030aa:	f04a                	sd	s2,32(sp)
    800030ac:	ec4e                	sd	s3,24(sp)
    800030ae:	e852                	sd	s4,16(sp)
    800030b0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030b2:	04451703          	lh	a4,68(a0)
    800030b6:	4785                	li	a5,1
    800030b8:	00f71a63          	bne	a4,a5,800030cc <dirlookup+0x2a>
    800030bc:	892a                	mv	s2,a0
    800030be:	89ae                	mv	s3,a1
    800030c0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030c2:	457c                	lw	a5,76(a0)
    800030c4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030c6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030c8:	e79d                	bnez	a5,800030f6 <dirlookup+0x54>
    800030ca:	a8a5                	j	80003142 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030cc:	00005517          	auipc	a0,0x5
    800030d0:	62450513          	addi	a0,a0,1572 # 800086f0 <sysname+0x1a8>
    800030d4:	00003097          	auipc	ra,0x3
    800030d8:	b5c080e7          	jalr	-1188(ra) # 80005c30 <panic>
      panic("dirlookup read");
    800030dc:	00005517          	auipc	a0,0x5
    800030e0:	62c50513          	addi	a0,a0,1580 # 80008708 <sysname+0x1c0>
    800030e4:	00003097          	auipc	ra,0x3
    800030e8:	b4c080e7          	jalr	-1204(ra) # 80005c30 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ec:	24c1                	addiw	s1,s1,16
    800030ee:	04c92783          	lw	a5,76(s2)
    800030f2:	04f4f763          	bgeu	s1,a5,80003140 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030f6:	4741                	li	a4,16
    800030f8:	86a6                	mv	a3,s1
    800030fa:	fc040613          	addi	a2,s0,-64
    800030fe:	4581                	li	a1,0
    80003100:	854a                	mv	a0,s2
    80003102:	00000097          	auipc	ra,0x0
    80003106:	d70080e7          	jalr	-656(ra) # 80002e72 <readi>
    8000310a:	47c1                	li	a5,16
    8000310c:	fcf518e3          	bne	a0,a5,800030dc <dirlookup+0x3a>
    if(de.inum == 0)
    80003110:	fc045783          	lhu	a5,-64(s0)
    80003114:	dfe1                	beqz	a5,800030ec <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003116:	fc240593          	addi	a1,s0,-62
    8000311a:	854e                	mv	a0,s3
    8000311c:	00000097          	auipc	ra,0x0
    80003120:	f6c080e7          	jalr	-148(ra) # 80003088 <namecmp>
    80003124:	f561                	bnez	a0,800030ec <dirlookup+0x4a>
      if(poff)
    80003126:	000a0463          	beqz	s4,8000312e <dirlookup+0x8c>
        *poff = off;
    8000312a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000312e:	fc045583          	lhu	a1,-64(s0)
    80003132:	00092503          	lw	a0,0(s2)
    80003136:	fffff097          	auipc	ra,0xfffff
    8000313a:	752080e7          	jalr	1874(ra) # 80002888 <iget>
    8000313e:	a011                	j	80003142 <dirlookup+0xa0>
  return 0;
    80003140:	4501                	li	a0,0
}
    80003142:	70e2                	ld	ra,56(sp)
    80003144:	7442                	ld	s0,48(sp)
    80003146:	74a2                	ld	s1,40(sp)
    80003148:	7902                	ld	s2,32(sp)
    8000314a:	69e2                	ld	s3,24(sp)
    8000314c:	6a42                	ld	s4,16(sp)
    8000314e:	6121                	addi	sp,sp,64
    80003150:	8082                	ret

0000000080003152 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003152:	711d                	addi	sp,sp,-96
    80003154:	ec86                	sd	ra,88(sp)
    80003156:	e8a2                	sd	s0,80(sp)
    80003158:	e4a6                	sd	s1,72(sp)
    8000315a:	e0ca                	sd	s2,64(sp)
    8000315c:	fc4e                	sd	s3,56(sp)
    8000315e:	f852                	sd	s4,48(sp)
    80003160:	f456                	sd	s5,40(sp)
    80003162:	f05a                	sd	s6,32(sp)
    80003164:	ec5e                	sd	s7,24(sp)
    80003166:	e862                	sd	s8,16(sp)
    80003168:	e466                	sd	s9,8(sp)
    8000316a:	e06a                	sd	s10,0(sp)
    8000316c:	1080                	addi	s0,sp,96
    8000316e:	84aa                	mv	s1,a0
    80003170:	8b2e                	mv	s6,a1
    80003172:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003174:	00054703          	lbu	a4,0(a0)
    80003178:	02f00793          	li	a5,47
    8000317c:	02f70363          	beq	a4,a5,800031a2 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003180:	ffffe097          	auipc	ra,0xffffe
    80003184:	ce8080e7          	jalr	-792(ra) # 80000e68 <myproc>
    80003188:	15853503          	ld	a0,344(a0)
    8000318c:	00000097          	auipc	ra,0x0
    80003190:	9f4080e7          	jalr	-1548(ra) # 80002b80 <idup>
    80003194:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003196:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000319a:	4cb5                	li	s9,13
  len = path - s;
    8000319c:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000319e:	4c05                	li	s8,1
    800031a0:	a87d                	j	8000325e <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800031a2:	4585                	li	a1,1
    800031a4:	4505                	li	a0,1
    800031a6:	fffff097          	auipc	ra,0xfffff
    800031aa:	6e2080e7          	jalr	1762(ra) # 80002888 <iget>
    800031ae:	8a2a                	mv	s4,a0
    800031b0:	b7dd                	j	80003196 <namex+0x44>
      iunlockput(ip);
    800031b2:	8552                	mv	a0,s4
    800031b4:	00000097          	auipc	ra,0x0
    800031b8:	c6c080e7          	jalr	-916(ra) # 80002e20 <iunlockput>
      return 0;
    800031bc:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031be:	8552                	mv	a0,s4
    800031c0:	60e6                	ld	ra,88(sp)
    800031c2:	6446                	ld	s0,80(sp)
    800031c4:	64a6                	ld	s1,72(sp)
    800031c6:	6906                	ld	s2,64(sp)
    800031c8:	79e2                	ld	s3,56(sp)
    800031ca:	7a42                	ld	s4,48(sp)
    800031cc:	7aa2                	ld	s5,40(sp)
    800031ce:	7b02                	ld	s6,32(sp)
    800031d0:	6be2                	ld	s7,24(sp)
    800031d2:	6c42                	ld	s8,16(sp)
    800031d4:	6ca2                	ld	s9,8(sp)
    800031d6:	6d02                	ld	s10,0(sp)
    800031d8:	6125                	addi	sp,sp,96
    800031da:	8082                	ret
      iunlock(ip);
    800031dc:	8552                	mv	a0,s4
    800031de:	00000097          	auipc	ra,0x0
    800031e2:	aa2080e7          	jalr	-1374(ra) # 80002c80 <iunlock>
      return ip;
    800031e6:	bfe1                	j	800031be <namex+0x6c>
      iunlockput(ip);
    800031e8:	8552                	mv	a0,s4
    800031ea:	00000097          	auipc	ra,0x0
    800031ee:	c36080e7          	jalr	-970(ra) # 80002e20 <iunlockput>
      return 0;
    800031f2:	8a4e                	mv	s4,s3
    800031f4:	b7e9                	j	800031be <namex+0x6c>
  len = path - s;
    800031f6:	40998633          	sub	a2,s3,s1
    800031fa:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800031fe:	09acd863          	bge	s9,s10,8000328e <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003202:	4639                	li	a2,14
    80003204:	85a6                	mv	a1,s1
    80003206:	8556                	mv	a0,s5
    80003208:	ffffd097          	auipc	ra,0xffffd
    8000320c:	ff2080e7          	jalr	-14(ra) # 800001fa <memmove>
    80003210:	84ce                	mv	s1,s3
  while(*path == '/')
    80003212:	0004c783          	lbu	a5,0(s1)
    80003216:	01279763          	bne	a5,s2,80003224 <namex+0xd2>
    path++;
    8000321a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000321c:	0004c783          	lbu	a5,0(s1)
    80003220:	ff278de3          	beq	a5,s2,8000321a <namex+0xc8>
    ilock(ip);
    80003224:	8552                	mv	a0,s4
    80003226:	00000097          	auipc	ra,0x0
    8000322a:	998080e7          	jalr	-1640(ra) # 80002bbe <ilock>
    if(ip->type != T_DIR){
    8000322e:	044a1783          	lh	a5,68(s4)
    80003232:	f98790e3          	bne	a5,s8,800031b2 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003236:	000b0563          	beqz	s6,80003240 <namex+0xee>
    8000323a:	0004c783          	lbu	a5,0(s1)
    8000323e:	dfd9                	beqz	a5,800031dc <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003240:	865e                	mv	a2,s7
    80003242:	85d6                	mv	a1,s5
    80003244:	8552                	mv	a0,s4
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	e5c080e7          	jalr	-420(ra) # 800030a2 <dirlookup>
    8000324e:	89aa                	mv	s3,a0
    80003250:	dd41                	beqz	a0,800031e8 <namex+0x96>
    iunlockput(ip);
    80003252:	8552                	mv	a0,s4
    80003254:	00000097          	auipc	ra,0x0
    80003258:	bcc080e7          	jalr	-1076(ra) # 80002e20 <iunlockput>
    ip = next;
    8000325c:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000325e:	0004c783          	lbu	a5,0(s1)
    80003262:	01279763          	bne	a5,s2,80003270 <namex+0x11e>
    path++;
    80003266:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003268:	0004c783          	lbu	a5,0(s1)
    8000326c:	ff278de3          	beq	a5,s2,80003266 <namex+0x114>
  if(*path == 0)
    80003270:	cb9d                	beqz	a5,800032a6 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003272:	0004c783          	lbu	a5,0(s1)
    80003276:	89a6                	mv	s3,s1
  len = path - s;
    80003278:	8d5e                	mv	s10,s7
    8000327a:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000327c:	01278963          	beq	a5,s2,8000328e <namex+0x13c>
    80003280:	dbbd                	beqz	a5,800031f6 <namex+0xa4>
    path++;
    80003282:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003284:	0009c783          	lbu	a5,0(s3)
    80003288:	ff279ce3          	bne	a5,s2,80003280 <namex+0x12e>
    8000328c:	b7ad                	j	800031f6 <namex+0xa4>
    memmove(name, s, len);
    8000328e:	2601                	sext.w	a2,a2
    80003290:	85a6                	mv	a1,s1
    80003292:	8556                	mv	a0,s5
    80003294:	ffffd097          	auipc	ra,0xffffd
    80003298:	f66080e7          	jalr	-154(ra) # 800001fa <memmove>
    name[len] = 0;
    8000329c:	9d56                	add	s10,s10,s5
    8000329e:	000d0023          	sb	zero,0(s10)
    800032a2:	84ce                	mv	s1,s3
    800032a4:	b7bd                	j	80003212 <namex+0xc0>
  if(nameiparent){
    800032a6:	f00b0ce3          	beqz	s6,800031be <namex+0x6c>
    iput(ip);
    800032aa:	8552                	mv	a0,s4
    800032ac:	00000097          	auipc	ra,0x0
    800032b0:	acc080e7          	jalr	-1332(ra) # 80002d78 <iput>
    return 0;
    800032b4:	4a01                	li	s4,0
    800032b6:	b721                	j	800031be <namex+0x6c>

00000000800032b8 <dirlink>:
{
    800032b8:	7139                	addi	sp,sp,-64
    800032ba:	fc06                	sd	ra,56(sp)
    800032bc:	f822                	sd	s0,48(sp)
    800032be:	f426                	sd	s1,40(sp)
    800032c0:	f04a                	sd	s2,32(sp)
    800032c2:	ec4e                	sd	s3,24(sp)
    800032c4:	e852                	sd	s4,16(sp)
    800032c6:	0080                	addi	s0,sp,64
    800032c8:	892a                	mv	s2,a0
    800032ca:	8a2e                	mv	s4,a1
    800032cc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032ce:	4601                	li	a2,0
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	dd2080e7          	jalr	-558(ra) # 800030a2 <dirlookup>
    800032d8:	e93d                	bnez	a0,8000334e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032da:	04c92483          	lw	s1,76(s2)
    800032de:	c49d                	beqz	s1,8000330c <dirlink+0x54>
    800032e0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032e2:	4741                	li	a4,16
    800032e4:	86a6                	mv	a3,s1
    800032e6:	fc040613          	addi	a2,s0,-64
    800032ea:	4581                	li	a1,0
    800032ec:	854a                	mv	a0,s2
    800032ee:	00000097          	auipc	ra,0x0
    800032f2:	b84080e7          	jalr	-1148(ra) # 80002e72 <readi>
    800032f6:	47c1                	li	a5,16
    800032f8:	06f51163          	bne	a0,a5,8000335a <dirlink+0xa2>
    if(de.inum == 0)
    800032fc:	fc045783          	lhu	a5,-64(s0)
    80003300:	c791                	beqz	a5,8000330c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003302:	24c1                	addiw	s1,s1,16
    80003304:	04c92783          	lw	a5,76(s2)
    80003308:	fcf4ede3          	bltu	s1,a5,800032e2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000330c:	4639                	li	a2,14
    8000330e:	85d2                	mv	a1,s4
    80003310:	fc240513          	addi	a0,s0,-62
    80003314:	ffffd097          	auipc	ra,0xffffd
    80003318:	f96080e7          	jalr	-106(ra) # 800002aa <strncpy>
  de.inum = inum;
    8000331c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003320:	4741                	li	a4,16
    80003322:	86a6                	mv	a3,s1
    80003324:	fc040613          	addi	a2,s0,-64
    80003328:	4581                	li	a1,0
    8000332a:	854a                	mv	a0,s2
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	c3e080e7          	jalr	-962(ra) # 80002f6a <writei>
    80003334:	872a                	mv	a4,a0
    80003336:	47c1                	li	a5,16
  return 0;
    80003338:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000333a:	02f71863          	bne	a4,a5,8000336a <dirlink+0xb2>
}
    8000333e:	70e2                	ld	ra,56(sp)
    80003340:	7442                	ld	s0,48(sp)
    80003342:	74a2                	ld	s1,40(sp)
    80003344:	7902                	ld	s2,32(sp)
    80003346:	69e2                	ld	s3,24(sp)
    80003348:	6a42                	ld	s4,16(sp)
    8000334a:	6121                	addi	sp,sp,64
    8000334c:	8082                	ret
    iput(ip);
    8000334e:	00000097          	auipc	ra,0x0
    80003352:	a2a080e7          	jalr	-1494(ra) # 80002d78 <iput>
    return -1;
    80003356:	557d                	li	a0,-1
    80003358:	b7dd                	j	8000333e <dirlink+0x86>
      panic("dirlink read");
    8000335a:	00005517          	auipc	a0,0x5
    8000335e:	3be50513          	addi	a0,a0,958 # 80008718 <sysname+0x1d0>
    80003362:	00003097          	auipc	ra,0x3
    80003366:	8ce080e7          	jalr	-1842(ra) # 80005c30 <panic>
    panic("dirlink");
    8000336a:	00005517          	auipc	a0,0x5
    8000336e:	4b650513          	addi	a0,a0,1206 # 80008820 <sysname+0x2d8>
    80003372:	00003097          	auipc	ra,0x3
    80003376:	8be080e7          	jalr	-1858(ra) # 80005c30 <panic>

000000008000337a <namei>:

struct inode*
namei(char *path)
{
    8000337a:	1101                	addi	sp,sp,-32
    8000337c:	ec06                	sd	ra,24(sp)
    8000337e:	e822                	sd	s0,16(sp)
    80003380:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003382:	fe040613          	addi	a2,s0,-32
    80003386:	4581                	li	a1,0
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	dca080e7          	jalr	-566(ra) # 80003152 <namex>
}
    80003390:	60e2                	ld	ra,24(sp)
    80003392:	6442                	ld	s0,16(sp)
    80003394:	6105                	addi	sp,sp,32
    80003396:	8082                	ret

0000000080003398 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003398:	1141                	addi	sp,sp,-16
    8000339a:	e406                	sd	ra,8(sp)
    8000339c:	e022                	sd	s0,0(sp)
    8000339e:	0800                	addi	s0,sp,16
    800033a0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033a2:	4585                	li	a1,1
    800033a4:	00000097          	auipc	ra,0x0
    800033a8:	dae080e7          	jalr	-594(ra) # 80003152 <namex>
}
    800033ac:	60a2                	ld	ra,8(sp)
    800033ae:	6402                	ld	s0,0(sp)
    800033b0:	0141                	addi	sp,sp,16
    800033b2:	8082                	ret

00000000800033b4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033b4:	1101                	addi	sp,sp,-32
    800033b6:	ec06                	sd	ra,24(sp)
    800033b8:	e822                	sd	s0,16(sp)
    800033ba:	e426                	sd	s1,8(sp)
    800033bc:	e04a                	sd	s2,0(sp)
    800033be:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033c0:	00016917          	auipc	s2,0x16
    800033c4:	e6090913          	addi	s2,s2,-416 # 80019220 <log>
    800033c8:	01892583          	lw	a1,24(s2)
    800033cc:	02892503          	lw	a0,40(s2)
    800033d0:	fffff097          	auipc	ra,0xfffff
    800033d4:	fec080e7          	jalr	-20(ra) # 800023bc <bread>
    800033d8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033da:	02c92683          	lw	a3,44(s2)
    800033de:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033e0:	02d05863          	blez	a3,80003410 <write_head+0x5c>
    800033e4:	00016797          	auipc	a5,0x16
    800033e8:	e6c78793          	addi	a5,a5,-404 # 80019250 <log+0x30>
    800033ec:	05c50713          	addi	a4,a0,92
    800033f0:	36fd                	addiw	a3,a3,-1
    800033f2:	02069613          	slli	a2,a3,0x20
    800033f6:	01e65693          	srli	a3,a2,0x1e
    800033fa:	00016617          	auipc	a2,0x16
    800033fe:	e5a60613          	addi	a2,a2,-422 # 80019254 <log+0x34>
    80003402:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003404:	4390                	lw	a2,0(a5)
    80003406:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003408:	0791                	addi	a5,a5,4
    8000340a:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000340c:	fed79ce3          	bne	a5,a3,80003404 <write_head+0x50>
  }
  bwrite(buf);
    80003410:	8526                	mv	a0,s1
    80003412:	fffff097          	auipc	ra,0xfffff
    80003416:	09c080e7          	jalr	156(ra) # 800024ae <bwrite>
  brelse(buf);
    8000341a:	8526                	mv	a0,s1
    8000341c:	fffff097          	auipc	ra,0xfffff
    80003420:	0d0080e7          	jalr	208(ra) # 800024ec <brelse>
}
    80003424:	60e2                	ld	ra,24(sp)
    80003426:	6442                	ld	s0,16(sp)
    80003428:	64a2                	ld	s1,8(sp)
    8000342a:	6902                	ld	s2,0(sp)
    8000342c:	6105                	addi	sp,sp,32
    8000342e:	8082                	ret

0000000080003430 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003430:	00016797          	auipc	a5,0x16
    80003434:	e1c7a783          	lw	a5,-484(a5) # 8001924c <log+0x2c>
    80003438:	0af05d63          	blez	a5,800034f2 <install_trans+0xc2>
{
    8000343c:	7139                	addi	sp,sp,-64
    8000343e:	fc06                	sd	ra,56(sp)
    80003440:	f822                	sd	s0,48(sp)
    80003442:	f426                	sd	s1,40(sp)
    80003444:	f04a                	sd	s2,32(sp)
    80003446:	ec4e                	sd	s3,24(sp)
    80003448:	e852                	sd	s4,16(sp)
    8000344a:	e456                	sd	s5,8(sp)
    8000344c:	e05a                	sd	s6,0(sp)
    8000344e:	0080                	addi	s0,sp,64
    80003450:	8b2a                	mv	s6,a0
    80003452:	00016a97          	auipc	s5,0x16
    80003456:	dfea8a93          	addi	s5,s5,-514 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000345a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000345c:	00016997          	auipc	s3,0x16
    80003460:	dc498993          	addi	s3,s3,-572 # 80019220 <log>
    80003464:	a00d                	j	80003486 <install_trans+0x56>
    brelse(lbuf);
    80003466:	854a                	mv	a0,s2
    80003468:	fffff097          	auipc	ra,0xfffff
    8000346c:	084080e7          	jalr	132(ra) # 800024ec <brelse>
    brelse(dbuf);
    80003470:	8526                	mv	a0,s1
    80003472:	fffff097          	auipc	ra,0xfffff
    80003476:	07a080e7          	jalr	122(ra) # 800024ec <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000347a:	2a05                	addiw	s4,s4,1
    8000347c:	0a91                	addi	s5,s5,4
    8000347e:	02c9a783          	lw	a5,44(s3)
    80003482:	04fa5e63          	bge	s4,a5,800034de <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003486:	0189a583          	lw	a1,24(s3)
    8000348a:	014585bb          	addw	a1,a1,s4
    8000348e:	2585                	addiw	a1,a1,1
    80003490:	0289a503          	lw	a0,40(s3)
    80003494:	fffff097          	auipc	ra,0xfffff
    80003498:	f28080e7          	jalr	-216(ra) # 800023bc <bread>
    8000349c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000349e:	000aa583          	lw	a1,0(s5)
    800034a2:	0289a503          	lw	a0,40(s3)
    800034a6:	fffff097          	auipc	ra,0xfffff
    800034aa:	f16080e7          	jalr	-234(ra) # 800023bc <bread>
    800034ae:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034b0:	40000613          	li	a2,1024
    800034b4:	05890593          	addi	a1,s2,88
    800034b8:	05850513          	addi	a0,a0,88
    800034bc:	ffffd097          	auipc	ra,0xffffd
    800034c0:	d3e080e7          	jalr	-706(ra) # 800001fa <memmove>
    bwrite(dbuf);  // write dst to disk
    800034c4:	8526                	mv	a0,s1
    800034c6:	fffff097          	auipc	ra,0xfffff
    800034ca:	fe8080e7          	jalr	-24(ra) # 800024ae <bwrite>
    if(recovering == 0)
    800034ce:	f80b1ce3          	bnez	s6,80003466 <install_trans+0x36>
      bunpin(dbuf);
    800034d2:	8526                	mv	a0,s1
    800034d4:	fffff097          	auipc	ra,0xfffff
    800034d8:	0f2080e7          	jalr	242(ra) # 800025c6 <bunpin>
    800034dc:	b769                	j	80003466 <install_trans+0x36>
}
    800034de:	70e2                	ld	ra,56(sp)
    800034e0:	7442                	ld	s0,48(sp)
    800034e2:	74a2                	ld	s1,40(sp)
    800034e4:	7902                	ld	s2,32(sp)
    800034e6:	69e2                	ld	s3,24(sp)
    800034e8:	6a42                	ld	s4,16(sp)
    800034ea:	6aa2                	ld	s5,8(sp)
    800034ec:	6b02                	ld	s6,0(sp)
    800034ee:	6121                	addi	sp,sp,64
    800034f0:	8082                	ret
    800034f2:	8082                	ret

00000000800034f4 <initlog>:
{
    800034f4:	7179                	addi	sp,sp,-48
    800034f6:	f406                	sd	ra,40(sp)
    800034f8:	f022                	sd	s0,32(sp)
    800034fa:	ec26                	sd	s1,24(sp)
    800034fc:	e84a                	sd	s2,16(sp)
    800034fe:	e44e                	sd	s3,8(sp)
    80003500:	1800                	addi	s0,sp,48
    80003502:	892a                	mv	s2,a0
    80003504:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003506:	00016497          	auipc	s1,0x16
    8000350a:	d1a48493          	addi	s1,s1,-742 # 80019220 <log>
    8000350e:	00005597          	auipc	a1,0x5
    80003512:	21a58593          	addi	a1,a1,538 # 80008728 <sysname+0x1e0>
    80003516:	8526                	mv	a0,s1
    80003518:	00003097          	auipc	ra,0x3
    8000351c:	bc0080e7          	jalr	-1088(ra) # 800060d8 <initlock>
  log.start = sb->logstart;
    80003520:	0149a583          	lw	a1,20(s3)
    80003524:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003526:	0109a783          	lw	a5,16(s3)
    8000352a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000352c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003530:	854a                	mv	a0,s2
    80003532:	fffff097          	auipc	ra,0xfffff
    80003536:	e8a080e7          	jalr	-374(ra) # 800023bc <bread>
  log.lh.n = lh->n;
    8000353a:	4d34                	lw	a3,88(a0)
    8000353c:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000353e:	02d05663          	blez	a3,8000356a <initlog+0x76>
    80003542:	05c50793          	addi	a5,a0,92
    80003546:	00016717          	auipc	a4,0x16
    8000354a:	d0a70713          	addi	a4,a4,-758 # 80019250 <log+0x30>
    8000354e:	36fd                	addiw	a3,a3,-1
    80003550:	02069613          	slli	a2,a3,0x20
    80003554:	01e65693          	srli	a3,a2,0x1e
    80003558:	06050613          	addi	a2,a0,96
    8000355c:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000355e:	4390                	lw	a2,0(a5)
    80003560:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003562:	0791                	addi	a5,a5,4
    80003564:	0711                	addi	a4,a4,4
    80003566:	fed79ce3          	bne	a5,a3,8000355e <initlog+0x6a>
  brelse(buf);
    8000356a:	fffff097          	auipc	ra,0xfffff
    8000356e:	f82080e7          	jalr	-126(ra) # 800024ec <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003572:	4505                	li	a0,1
    80003574:	00000097          	auipc	ra,0x0
    80003578:	ebc080e7          	jalr	-324(ra) # 80003430 <install_trans>
  log.lh.n = 0;
    8000357c:	00016797          	auipc	a5,0x16
    80003580:	cc07a823          	sw	zero,-816(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    80003584:	00000097          	auipc	ra,0x0
    80003588:	e30080e7          	jalr	-464(ra) # 800033b4 <write_head>
}
    8000358c:	70a2                	ld	ra,40(sp)
    8000358e:	7402                	ld	s0,32(sp)
    80003590:	64e2                	ld	s1,24(sp)
    80003592:	6942                	ld	s2,16(sp)
    80003594:	69a2                	ld	s3,8(sp)
    80003596:	6145                	addi	sp,sp,48
    80003598:	8082                	ret

000000008000359a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000359a:	1101                	addi	sp,sp,-32
    8000359c:	ec06                	sd	ra,24(sp)
    8000359e:	e822                	sd	s0,16(sp)
    800035a0:	e426                	sd	s1,8(sp)
    800035a2:	e04a                	sd	s2,0(sp)
    800035a4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035a6:	00016517          	auipc	a0,0x16
    800035aa:	c7a50513          	addi	a0,a0,-902 # 80019220 <log>
    800035ae:	00003097          	auipc	ra,0x3
    800035b2:	bba080e7          	jalr	-1094(ra) # 80006168 <acquire>
  while(1){
    if(log.committing){
    800035b6:	00016497          	auipc	s1,0x16
    800035ba:	c6a48493          	addi	s1,s1,-918 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035be:	4979                	li	s2,30
    800035c0:	a039                	j	800035ce <begin_op+0x34>
      sleep(&log, &log.lock);
    800035c2:	85a6                	mv	a1,s1
    800035c4:	8526                	mv	a0,s1
    800035c6:	ffffe097          	auipc	ra,0xffffe
    800035ca:	f6e080e7          	jalr	-146(ra) # 80001534 <sleep>
    if(log.committing){
    800035ce:	50dc                	lw	a5,36(s1)
    800035d0:	fbed                	bnez	a5,800035c2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035d2:	5098                	lw	a4,32(s1)
    800035d4:	2705                	addiw	a4,a4,1
    800035d6:	0007069b          	sext.w	a3,a4
    800035da:	0027179b          	slliw	a5,a4,0x2
    800035de:	9fb9                	addw	a5,a5,a4
    800035e0:	0017979b          	slliw	a5,a5,0x1
    800035e4:	54d8                	lw	a4,44(s1)
    800035e6:	9fb9                	addw	a5,a5,a4
    800035e8:	00f95963          	bge	s2,a5,800035fa <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035ec:	85a6                	mv	a1,s1
    800035ee:	8526                	mv	a0,s1
    800035f0:	ffffe097          	auipc	ra,0xffffe
    800035f4:	f44080e7          	jalr	-188(ra) # 80001534 <sleep>
    800035f8:	bfd9                	j	800035ce <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035fa:	00016517          	auipc	a0,0x16
    800035fe:	c2650513          	addi	a0,a0,-986 # 80019220 <log>
    80003602:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003604:	00003097          	auipc	ra,0x3
    80003608:	c18080e7          	jalr	-1000(ra) # 8000621c <release>
      break;
    }
  }
}
    8000360c:	60e2                	ld	ra,24(sp)
    8000360e:	6442                	ld	s0,16(sp)
    80003610:	64a2                	ld	s1,8(sp)
    80003612:	6902                	ld	s2,0(sp)
    80003614:	6105                	addi	sp,sp,32
    80003616:	8082                	ret

0000000080003618 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003618:	7139                	addi	sp,sp,-64
    8000361a:	fc06                	sd	ra,56(sp)
    8000361c:	f822                	sd	s0,48(sp)
    8000361e:	f426                	sd	s1,40(sp)
    80003620:	f04a                	sd	s2,32(sp)
    80003622:	ec4e                	sd	s3,24(sp)
    80003624:	e852                	sd	s4,16(sp)
    80003626:	e456                	sd	s5,8(sp)
    80003628:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000362a:	00016497          	auipc	s1,0x16
    8000362e:	bf648493          	addi	s1,s1,-1034 # 80019220 <log>
    80003632:	8526                	mv	a0,s1
    80003634:	00003097          	auipc	ra,0x3
    80003638:	b34080e7          	jalr	-1228(ra) # 80006168 <acquire>
  log.outstanding -= 1;
    8000363c:	509c                	lw	a5,32(s1)
    8000363e:	37fd                	addiw	a5,a5,-1
    80003640:	0007891b          	sext.w	s2,a5
    80003644:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003646:	50dc                	lw	a5,36(s1)
    80003648:	e7b9                	bnez	a5,80003696 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000364a:	04091e63          	bnez	s2,800036a6 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000364e:	00016497          	auipc	s1,0x16
    80003652:	bd248493          	addi	s1,s1,-1070 # 80019220 <log>
    80003656:	4785                	li	a5,1
    80003658:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000365a:	8526                	mv	a0,s1
    8000365c:	00003097          	auipc	ra,0x3
    80003660:	bc0080e7          	jalr	-1088(ra) # 8000621c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003664:	54dc                	lw	a5,44(s1)
    80003666:	06f04763          	bgtz	a5,800036d4 <end_op+0xbc>
    acquire(&log.lock);
    8000366a:	00016497          	auipc	s1,0x16
    8000366e:	bb648493          	addi	s1,s1,-1098 # 80019220 <log>
    80003672:	8526                	mv	a0,s1
    80003674:	00003097          	auipc	ra,0x3
    80003678:	af4080e7          	jalr	-1292(ra) # 80006168 <acquire>
    log.committing = 0;
    8000367c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003680:	8526                	mv	a0,s1
    80003682:	ffffe097          	auipc	ra,0xffffe
    80003686:	03e080e7          	jalr	62(ra) # 800016c0 <wakeup>
    release(&log.lock);
    8000368a:	8526                	mv	a0,s1
    8000368c:	00003097          	auipc	ra,0x3
    80003690:	b90080e7          	jalr	-1136(ra) # 8000621c <release>
}
    80003694:	a03d                	j	800036c2 <end_op+0xaa>
    panic("log.committing");
    80003696:	00005517          	auipc	a0,0x5
    8000369a:	09a50513          	addi	a0,a0,154 # 80008730 <sysname+0x1e8>
    8000369e:	00002097          	auipc	ra,0x2
    800036a2:	592080e7          	jalr	1426(ra) # 80005c30 <panic>
    wakeup(&log);
    800036a6:	00016497          	auipc	s1,0x16
    800036aa:	b7a48493          	addi	s1,s1,-1158 # 80019220 <log>
    800036ae:	8526                	mv	a0,s1
    800036b0:	ffffe097          	auipc	ra,0xffffe
    800036b4:	010080e7          	jalr	16(ra) # 800016c0 <wakeup>
  release(&log.lock);
    800036b8:	8526                	mv	a0,s1
    800036ba:	00003097          	auipc	ra,0x3
    800036be:	b62080e7          	jalr	-1182(ra) # 8000621c <release>
}
    800036c2:	70e2                	ld	ra,56(sp)
    800036c4:	7442                	ld	s0,48(sp)
    800036c6:	74a2                	ld	s1,40(sp)
    800036c8:	7902                	ld	s2,32(sp)
    800036ca:	69e2                	ld	s3,24(sp)
    800036cc:	6a42                	ld	s4,16(sp)
    800036ce:	6aa2                	ld	s5,8(sp)
    800036d0:	6121                	addi	sp,sp,64
    800036d2:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036d4:	00016a97          	auipc	s5,0x16
    800036d8:	b7ca8a93          	addi	s5,s5,-1156 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036dc:	00016a17          	auipc	s4,0x16
    800036e0:	b44a0a13          	addi	s4,s4,-1212 # 80019220 <log>
    800036e4:	018a2583          	lw	a1,24(s4)
    800036e8:	012585bb          	addw	a1,a1,s2
    800036ec:	2585                	addiw	a1,a1,1
    800036ee:	028a2503          	lw	a0,40(s4)
    800036f2:	fffff097          	auipc	ra,0xfffff
    800036f6:	cca080e7          	jalr	-822(ra) # 800023bc <bread>
    800036fa:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036fc:	000aa583          	lw	a1,0(s5)
    80003700:	028a2503          	lw	a0,40(s4)
    80003704:	fffff097          	auipc	ra,0xfffff
    80003708:	cb8080e7          	jalr	-840(ra) # 800023bc <bread>
    8000370c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000370e:	40000613          	li	a2,1024
    80003712:	05850593          	addi	a1,a0,88
    80003716:	05848513          	addi	a0,s1,88
    8000371a:	ffffd097          	auipc	ra,0xffffd
    8000371e:	ae0080e7          	jalr	-1312(ra) # 800001fa <memmove>
    bwrite(to);  // write the log
    80003722:	8526                	mv	a0,s1
    80003724:	fffff097          	auipc	ra,0xfffff
    80003728:	d8a080e7          	jalr	-630(ra) # 800024ae <bwrite>
    brelse(from);
    8000372c:	854e                	mv	a0,s3
    8000372e:	fffff097          	auipc	ra,0xfffff
    80003732:	dbe080e7          	jalr	-578(ra) # 800024ec <brelse>
    brelse(to);
    80003736:	8526                	mv	a0,s1
    80003738:	fffff097          	auipc	ra,0xfffff
    8000373c:	db4080e7          	jalr	-588(ra) # 800024ec <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003740:	2905                	addiw	s2,s2,1
    80003742:	0a91                	addi	s5,s5,4
    80003744:	02ca2783          	lw	a5,44(s4)
    80003748:	f8f94ee3          	blt	s2,a5,800036e4 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000374c:	00000097          	auipc	ra,0x0
    80003750:	c68080e7          	jalr	-920(ra) # 800033b4 <write_head>
    install_trans(0); // Now install writes to home locations
    80003754:	4501                	li	a0,0
    80003756:	00000097          	auipc	ra,0x0
    8000375a:	cda080e7          	jalr	-806(ra) # 80003430 <install_trans>
    log.lh.n = 0;
    8000375e:	00016797          	auipc	a5,0x16
    80003762:	ae07a723          	sw	zero,-1298(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003766:	00000097          	auipc	ra,0x0
    8000376a:	c4e080e7          	jalr	-946(ra) # 800033b4 <write_head>
    8000376e:	bdf5                	j	8000366a <end_op+0x52>

0000000080003770 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003770:	1101                	addi	sp,sp,-32
    80003772:	ec06                	sd	ra,24(sp)
    80003774:	e822                	sd	s0,16(sp)
    80003776:	e426                	sd	s1,8(sp)
    80003778:	e04a                	sd	s2,0(sp)
    8000377a:	1000                	addi	s0,sp,32
    8000377c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000377e:	00016917          	auipc	s2,0x16
    80003782:	aa290913          	addi	s2,s2,-1374 # 80019220 <log>
    80003786:	854a                	mv	a0,s2
    80003788:	00003097          	auipc	ra,0x3
    8000378c:	9e0080e7          	jalr	-1568(ra) # 80006168 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003790:	02c92603          	lw	a2,44(s2)
    80003794:	47f5                	li	a5,29
    80003796:	06c7c563          	blt	a5,a2,80003800 <log_write+0x90>
    8000379a:	00016797          	auipc	a5,0x16
    8000379e:	aa27a783          	lw	a5,-1374(a5) # 8001923c <log+0x1c>
    800037a2:	37fd                	addiw	a5,a5,-1
    800037a4:	04f65e63          	bge	a2,a5,80003800 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037a8:	00016797          	auipc	a5,0x16
    800037ac:	a987a783          	lw	a5,-1384(a5) # 80019240 <log+0x20>
    800037b0:	06f05063          	blez	a5,80003810 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037b4:	4781                	li	a5,0
    800037b6:	06c05563          	blez	a2,80003820 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ba:	44cc                	lw	a1,12(s1)
    800037bc:	00016717          	auipc	a4,0x16
    800037c0:	a9470713          	addi	a4,a4,-1388 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037c4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037c6:	4314                	lw	a3,0(a4)
    800037c8:	04b68c63          	beq	a3,a1,80003820 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037cc:	2785                	addiw	a5,a5,1
    800037ce:	0711                	addi	a4,a4,4
    800037d0:	fef61be3          	bne	a2,a5,800037c6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037d4:	0621                	addi	a2,a2,8
    800037d6:	060a                	slli	a2,a2,0x2
    800037d8:	00016797          	auipc	a5,0x16
    800037dc:	a4878793          	addi	a5,a5,-1464 # 80019220 <log>
    800037e0:	97b2                	add	a5,a5,a2
    800037e2:	44d8                	lw	a4,12(s1)
    800037e4:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037e6:	8526                	mv	a0,s1
    800037e8:	fffff097          	auipc	ra,0xfffff
    800037ec:	da2080e7          	jalr	-606(ra) # 8000258a <bpin>
    log.lh.n++;
    800037f0:	00016717          	auipc	a4,0x16
    800037f4:	a3070713          	addi	a4,a4,-1488 # 80019220 <log>
    800037f8:	575c                	lw	a5,44(a4)
    800037fa:	2785                	addiw	a5,a5,1
    800037fc:	d75c                	sw	a5,44(a4)
    800037fe:	a82d                	j	80003838 <log_write+0xc8>
    panic("too big a transaction");
    80003800:	00005517          	auipc	a0,0x5
    80003804:	f4050513          	addi	a0,a0,-192 # 80008740 <sysname+0x1f8>
    80003808:	00002097          	auipc	ra,0x2
    8000380c:	428080e7          	jalr	1064(ra) # 80005c30 <panic>
    panic("log_write outside of trans");
    80003810:	00005517          	auipc	a0,0x5
    80003814:	f4850513          	addi	a0,a0,-184 # 80008758 <sysname+0x210>
    80003818:	00002097          	auipc	ra,0x2
    8000381c:	418080e7          	jalr	1048(ra) # 80005c30 <panic>
  log.lh.block[i] = b->blockno;
    80003820:	00878693          	addi	a3,a5,8
    80003824:	068a                	slli	a3,a3,0x2
    80003826:	00016717          	auipc	a4,0x16
    8000382a:	9fa70713          	addi	a4,a4,-1542 # 80019220 <log>
    8000382e:	9736                	add	a4,a4,a3
    80003830:	44d4                	lw	a3,12(s1)
    80003832:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003834:	faf609e3          	beq	a2,a5,800037e6 <log_write+0x76>
  }
  release(&log.lock);
    80003838:	00016517          	auipc	a0,0x16
    8000383c:	9e850513          	addi	a0,a0,-1560 # 80019220 <log>
    80003840:	00003097          	auipc	ra,0x3
    80003844:	9dc080e7          	jalr	-1572(ra) # 8000621c <release>
}
    80003848:	60e2                	ld	ra,24(sp)
    8000384a:	6442                	ld	s0,16(sp)
    8000384c:	64a2                	ld	s1,8(sp)
    8000384e:	6902                	ld	s2,0(sp)
    80003850:	6105                	addi	sp,sp,32
    80003852:	8082                	ret

0000000080003854 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003854:	1101                	addi	sp,sp,-32
    80003856:	ec06                	sd	ra,24(sp)
    80003858:	e822                	sd	s0,16(sp)
    8000385a:	e426                	sd	s1,8(sp)
    8000385c:	e04a                	sd	s2,0(sp)
    8000385e:	1000                	addi	s0,sp,32
    80003860:	84aa                	mv	s1,a0
    80003862:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003864:	00005597          	auipc	a1,0x5
    80003868:	f1458593          	addi	a1,a1,-236 # 80008778 <sysname+0x230>
    8000386c:	0521                	addi	a0,a0,8
    8000386e:	00003097          	auipc	ra,0x3
    80003872:	86a080e7          	jalr	-1942(ra) # 800060d8 <initlock>
  lk->name = name;
    80003876:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000387a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000387e:	0204a423          	sw	zero,40(s1)
}
    80003882:	60e2                	ld	ra,24(sp)
    80003884:	6442                	ld	s0,16(sp)
    80003886:	64a2                	ld	s1,8(sp)
    80003888:	6902                	ld	s2,0(sp)
    8000388a:	6105                	addi	sp,sp,32
    8000388c:	8082                	ret

000000008000388e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000388e:	1101                	addi	sp,sp,-32
    80003890:	ec06                	sd	ra,24(sp)
    80003892:	e822                	sd	s0,16(sp)
    80003894:	e426                	sd	s1,8(sp)
    80003896:	e04a                	sd	s2,0(sp)
    80003898:	1000                	addi	s0,sp,32
    8000389a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000389c:	00850913          	addi	s2,a0,8
    800038a0:	854a                	mv	a0,s2
    800038a2:	00003097          	auipc	ra,0x3
    800038a6:	8c6080e7          	jalr	-1850(ra) # 80006168 <acquire>
  while (lk->locked) {
    800038aa:	409c                	lw	a5,0(s1)
    800038ac:	cb89                	beqz	a5,800038be <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038ae:	85ca                	mv	a1,s2
    800038b0:	8526                	mv	a0,s1
    800038b2:	ffffe097          	auipc	ra,0xffffe
    800038b6:	c82080e7          	jalr	-894(ra) # 80001534 <sleep>
  while (lk->locked) {
    800038ba:	409c                	lw	a5,0(s1)
    800038bc:	fbed                	bnez	a5,800038ae <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038be:	4785                	li	a5,1
    800038c0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038c2:	ffffd097          	auipc	ra,0xffffd
    800038c6:	5a6080e7          	jalr	1446(ra) # 80000e68 <myproc>
    800038ca:	591c                	lw	a5,48(a0)
    800038cc:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038ce:	854a                	mv	a0,s2
    800038d0:	00003097          	auipc	ra,0x3
    800038d4:	94c080e7          	jalr	-1716(ra) # 8000621c <release>
}
    800038d8:	60e2                	ld	ra,24(sp)
    800038da:	6442                	ld	s0,16(sp)
    800038dc:	64a2                	ld	s1,8(sp)
    800038de:	6902                	ld	s2,0(sp)
    800038e0:	6105                	addi	sp,sp,32
    800038e2:	8082                	ret

00000000800038e4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038e4:	1101                	addi	sp,sp,-32
    800038e6:	ec06                	sd	ra,24(sp)
    800038e8:	e822                	sd	s0,16(sp)
    800038ea:	e426                	sd	s1,8(sp)
    800038ec:	e04a                	sd	s2,0(sp)
    800038ee:	1000                	addi	s0,sp,32
    800038f0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038f2:	00850913          	addi	s2,a0,8
    800038f6:	854a                	mv	a0,s2
    800038f8:	00003097          	auipc	ra,0x3
    800038fc:	870080e7          	jalr	-1936(ra) # 80006168 <acquire>
  lk->locked = 0;
    80003900:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003904:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003908:	8526                	mv	a0,s1
    8000390a:	ffffe097          	auipc	ra,0xffffe
    8000390e:	db6080e7          	jalr	-586(ra) # 800016c0 <wakeup>
  release(&lk->lk);
    80003912:	854a                	mv	a0,s2
    80003914:	00003097          	auipc	ra,0x3
    80003918:	908080e7          	jalr	-1784(ra) # 8000621c <release>
}
    8000391c:	60e2                	ld	ra,24(sp)
    8000391e:	6442                	ld	s0,16(sp)
    80003920:	64a2                	ld	s1,8(sp)
    80003922:	6902                	ld	s2,0(sp)
    80003924:	6105                	addi	sp,sp,32
    80003926:	8082                	ret

0000000080003928 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003928:	7179                	addi	sp,sp,-48
    8000392a:	f406                	sd	ra,40(sp)
    8000392c:	f022                	sd	s0,32(sp)
    8000392e:	ec26                	sd	s1,24(sp)
    80003930:	e84a                	sd	s2,16(sp)
    80003932:	e44e                	sd	s3,8(sp)
    80003934:	1800                	addi	s0,sp,48
    80003936:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003938:	00850913          	addi	s2,a0,8
    8000393c:	854a                	mv	a0,s2
    8000393e:	00003097          	auipc	ra,0x3
    80003942:	82a080e7          	jalr	-2006(ra) # 80006168 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003946:	409c                	lw	a5,0(s1)
    80003948:	ef99                	bnez	a5,80003966 <holdingsleep+0x3e>
    8000394a:	4481                	li	s1,0
  release(&lk->lk);
    8000394c:	854a                	mv	a0,s2
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	8ce080e7          	jalr	-1842(ra) # 8000621c <release>
  return r;
}
    80003956:	8526                	mv	a0,s1
    80003958:	70a2                	ld	ra,40(sp)
    8000395a:	7402                	ld	s0,32(sp)
    8000395c:	64e2                	ld	s1,24(sp)
    8000395e:	6942                	ld	s2,16(sp)
    80003960:	69a2                	ld	s3,8(sp)
    80003962:	6145                	addi	sp,sp,48
    80003964:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003966:	0284a983          	lw	s3,40(s1)
    8000396a:	ffffd097          	auipc	ra,0xffffd
    8000396e:	4fe080e7          	jalr	1278(ra) # 80000e68 <myproc>
    80003972:	5904                	lw	s1,48(a0)
    80003974:	413484b3          	sub	s1,s1,s3
    80003978:	0014b493          	seqz	s1,s1
    8000397c:	bfc1                	j	8000394c <holdingsleep+0x24>

000000008000397e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000397e:	1141                	addi	sp,sp,-16
    80003980:	e406                	sd	ra,8(sp)
    80003982:	e022                	sd	s0,0(sp)
    80003984:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003986:	00005597          	auipc	a1,0x5
    8000398a:	e0258593          	addi	a1,a1,-510 # 80008788 <sysname+0x240>
    8000398e:	00016517          	auipc	a0,0x16
    80003992:	9da50513          	addi	a0,a0,-1574 # 80019368 <ftable>
    80003996:	00002097          	auipc	ra,0x2
    8000399a:	742080e7          	jalr	1858(ra) # 800060d8 <initlock>
}
    8000399e:	60a2                	ld	ra,8(sp)
    800039a0:	6402                	ld	s0,0(sp)
    800039a2:	0141                	addi	sp,sp,16
    800039a4:	8082                	ret

00000000800039a6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039a6:	1101                	addi	sp,sp,-32
    800039a8:	ec06                	sd	ra,24(sp)
    800039aa:	e822                	sd	s0,16(sp)
    800039ac:	e426                	sd	s1,8(sp)
    800039ae:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039b0:	00016517          	auipc	a0,0x16
    800039b4:	9b850513          	addi	a0,a0,-1608 # 80019368 <ftable>
    800039b8:	00002097          	auipc	ra,0x2
    800039bc:	7b0080e7          	jalr	1968(ra) # 80006168 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039c0:	00016497          	auipc	s1,0x16
    800039c4:	9c048493          	addi	s1,s1,-1600 # 80019380 <ftable+0x18>
    800039c8:	00017717          	auipc	a4,0x17
    800039cc:	95870713          	addi	a4,a4,-1704 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    800039d0:	40dc                	lw	a5,4(s1)
    800039d2:	cf99                	beqz	a5,800039f0 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039d4:	02848493          	addi	s1,s1,40
    800039d8:	fee49ce3          	bne	s1,a4,800039d0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039dc:	00016517          	auipc	a0,0x16
    800039e0:	98c50513          	addi	a0,a0,-1652 # 80019368 <ftable>
    800039e4:	00003097          	auipc	ra,0x3
    800039e8:	838080e7          	jalr	-1992(ra) # 8000621c <release>
  return 0;
    800039ec:	4481                	li	s1,0
    800039ee:	a819                	j	80003a04 <filealloc+0x5e>
      f->ref = 1;
    800039f0:	4785                	li	a5,1
    800039f2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039f4:	00016517          	auipc	a0,0x16
    800039f8:	97450513          	addi	a0,a0,-1676 # 80019368 <ftable>
    800039fc:	00003097          	auipc	ra,0x3
    80003a00:	820080e7          	jalr	-2016(ra) # 8000621c <release>
}
    80003a04:	8526                	mv	a0,s1
    80003a06:	60e2                	ld	ra,24(sp)
    80003a08:	6442                	ld	s0,16(sp)
    80003a0a:	64a2                	ld	s1,8(sp)
    80003a0c:	6105                	addi	sp,sp,32
    80003a0e:	8082                	ret

0000000080003a10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a10:	1101                	addi	sp,sp,-32
    80003a12:	ec06                	sd	ra,24(sp)
    80003a14:	e822                	sd	s0,16(sp)
    80003a16:	e426                	sd	s1,8(sp)
    80003a18:	1000                	addi	s0,sp,32
    80003a1a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a1c:	00016517          	auipc	a0,0x16
    80003a20:	94c50513          	addi	a0,a0,-1716 # 80019368 <ftable>
    80003a24:	00002097          	auipc	ra,0x2
    80003a28:	744080e7          	jalr	1860(ra) # 80006168 <acquire>
  if(f->ref < 1)
    80003a2c:	40dc                	lw	a5,4(s1)
    80003a2e:	02f05263          	blez	a5,80003a52 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a32:	2785                	addiw	a5,a5,1
    80003a34:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a36:	00016517          	auipc	a0,0x16
    80003a3a:	93250513          	addi	a0,a0,-1742 # 80019368 <ftable>
    80003a3e:	00002097          	auipc	ra,0x2
    80003a42:	7de080e7          	jalr	2014(ra) # 8000621c <release>
  return f;
}
    80003a46:	8526                	mv	a0,s1
    80003a48:	60e2                	ld	ra,24(sp)
    80003a4a:	6442                	ld	s0,16(sp)
    80003a4c:	64a2                	ld	s1,8(sp)
    80003a4e:	6105                	addi	sp,sp,32
    80003a50:	8082                	ret
    panic("filedup");
    80003a52:	00005517          	auipc	a0,0x5
    80003a56:	d3e50513          	addi	a0,a0,-706 # 80008790 <sysname+0x248>
    80003a5a:	00002097          	auipc	ra,0x2
    80003a5e:	1d6080e7          	jalr	470(ra) # 80005c30 <panic>

0000000080003a62 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a62:	7139                	addi	sp,sp,-64
    80003a64:	fc06                	sd	ra,56(sp)
    80003a66:	f822                	sd	s0,48(sp)
    80003a68:	f426                	sd	s1,40(sp)
    80003a6a:	f04a                	sd	s2,32(sp)
    80003a6c:	ec4e                	sd	s3,24(sp)
    80003a6e:	e852                	sd	s4,16(sp)
    80003a70:	e456                	sd	s5,8(sp)
    80003a72:	0080                	addi	s0,sp,64
    80003a74:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a76:	00016517          	auipc	a0,0x16
    80003a7a:	8f250513          	addi	a0,a0,-1806 # 80019368 <ftable>
    80003a7e:	00002097          	auipc	ra,0x2
    80003a82:	6ea080e7          	jalr	1770(ra) # 80006168 <acquire>
  if(f->ref < 1)
    80003a86:	40dc                	lw	a5,4(s1)
    80003a88:	06f05163          	blez	a5,80003aea <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a8c:	37fd                	addiw	a5,a5,-1
    80003a8e:	0007871b          	sext.w	a4,a5
    80003a92:	c0dc                	sw	a5,4(s1)
    80003a94:	06e04363          	bgtz	a4,80003afa <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a98:	0004a903          	lw	s2,0(s1)
    80003a9c:	0094ca83          	lbu	s5,9(s1)
    80003aa0:	0104ba03          	ld	s4,16(s1)
    80003aa4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003aa8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003aac:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ab0:	00016517          	auipc	a0,0x16
    80003ab4:	8b850513          	addi	a0,a0,-1864 # 80019368 <ftable>
    80003ab8:	00002097          	auipc	ra,0x2
    80003abc:	764080e7          	jalr	1892(ra) # 8000621c <release>

  if(ff.type == FD_PIPE){
    80003ac0:	4785                	li	a5,1
    80003ac2:	04f90d63          	beq	s2,a5,80003b1c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ac6:	3979                	addiw	s2,s2,-2
    80003ac8:	4785                	li	a5,1
    80003aca:	0527e063          	bltu	a5,s2,80003b0a <fileclose+0xa8>
    begin_op();
    80003ace:	00000097          	auipc	ra,0x0
    80003ad2:	acc080e7          	jalr	-1332(ra) # 8000359a <begin_op>
    iput(ff.ip);
    80003ad6:	854e                	mv	a0,s3
    80003ad8:	fffff097          	auipc	ra,0xfffff
    80003adc:	2a0080e7          	jalr	672(ra) # 80002d78 <iput>
    end_op();
    80003ae0:	00000097          	auipc	ra,0x0
    80003ae4:	b38080e7          	jalr	-1224(ra) # 80003618 <end_op>
    80003ae8:	a00d                	j	80003b0a <fileclose+0xa8>
    panic("fileclose");
    80003aea:	00005517          	auipc	a0,0x5
    80003aee:	cae50513          	addi	a0,a0,-850 # 80008798 <sysname+0x250>
    80003af2:	00002097          	auipc	ra,0x2
    80003af6:	13e080e7          	jalr	318(ra) # 80005c30 <panic>
    release(&ftable.lock);
    80003afa:	00016517          	auipc	a0,0x16
    80003afe:	86e50513          	addi	a0,a0,-1938 # 80019368 <ftable>
    80003b02:	00002097          	auipc	ra,0x2
    80003b06:	71a080e7          	jalr	1818(ra) # 8000621c <release>
  }
}
    80003b0a:	70e2                	ld	ra,56(sp)
    80003b0c:	7442                	ld	s0,48(sp)
    80003b0e:	74a2                	ld	s1,40(sp)
    80003b10:	7902                	ld	s2,32(sp)
    80003b12:	69e2                	ld	s3,24(sp)
    80003b14:	6a42                	ld	s4,16(sp)
    80003b16:	6aa2                	ld	s5,8(sp)
    80003b18:	6121                	addi	sp,sp,64
    80003b1a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b1c:	85d6                	mv	a1,s5
    80003b1e:	8552                	mv	a0,s4
    80003b20:	00000097          	auipc	ra,0x0
    80003b24:	34c080e7          	jalr	844(ra) # 80003e6c <pipeclose>
    80003b28:	b7cd                	j	80003b0a <fileclose+0xa8>

0000000080003b2a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b2a:	715d                	addi	sp,sp,-80
    80003b2c:	e486                	sd	ra,72(sp)
    80003b2e:	e0a2                	sd	s0,64(sp)
    80003b30:	fc26                	sd	s1,56(sp)
    80003b32:	f84a                	sd	s2,48(sp)
    80003b34:	f44e                	sd	s3,40(sp)
    80003b36:	0880                	addi	s0,sp,80
    80003b38:	84aa                	mv	s1,a0
    80003b3a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b3c:	ffffd097          	auipc	ra,0xffffd
    80003b40:	32c080e7          	jalr	812(ra) # 80000e68 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b44:	409c                	lw	a5,0(s1)
    80003b46:	37f9                	addiw	a5,a5,-2
    80003b48:	4705                	li	a4,1
    80003b4a:	04f76763          	bltu	a4,a5,80003b98 <filestat+0x6e>
    80003b4e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b50:	6c88                	ld	a0,24(s1)
    80003b52:	fffff097          	auipc	ra,0xfffff
    80003b56:	06c080e7          	jalr	108(ra) # 80002bbe <ilock>
    stati(f->ip, &st);
    80003b5a:	fb840593          	addi	a1,s0,-72
    80003b5e:	6c88                	ld	a0,24(s1)
    80003b60:	fffff097          	auipc	ra,0xfffff
    80003b64:	2e8080e7          	jalr	744(ra) # 80002e48 <stati>
    iunlock(f->ip);
    80003b68:	6c88                	ld	a0,24(s1)
    80003b6a:	fffff097          	auipc	ra,0xfffff
    80003b6e:	116080e7          	jalr	278(ra) # 80002c80 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b72:	46e1                	li	a3,24
    80003b74:	fb840613          	addi	a2,s0,-72
    80003b78:	85ce                	mv	a1,s3
    80003b7a:	05893503          	ld	a0,88(s2)
    80003b7e:	ffffd097          	auipc	ra,0xffffd
    80003b82:	fae080e7          	jalr	-82(ra) # 80000b2c <copyout>
    80003b86:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b8a:	60a6                	ld	ra,72(sp)
    80003b8c:	6406                	ld	s0,64(sp)
    80003b8e:	74e2                	ld	s1,56(sp)
    80003b90:	7942                	ld	s2,48(sp)
    80003b92:	79a2                	ld	s3,40(sp)
    80003b94:	6161                	addi	sp,sp,80
    80003b96:	8082                	ret
  return -1;
    80003b98:	557d                	li	a0,-1
    80003b9a:	bfc5                	j	80003b8a <filestat+0x60>

0000000080003b9c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b9c:	7179                	addi	sp,sp,-48
    80003b9e:	f406                	sd	ra,40(sp)
    80003ba0:	f022                	sd	s0,32(sp)
    80003ba2:	ec26                	sd	s1,24(sp)
    80003ba4:	e84a                	sd	s2,16(sp)
    80003ba6:	e44e                	sd	s3,8(sp)
    80003ba8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003baa:	00854783          	lbu	a5,8(a0)
    80003bae:	c3d5                	beqz	a5,80003c52 <fileread+0xb6>
    80003bb0:	84aa                	mv	s1,a0
    80003bb2:	89ae                	mv	s3,a1
    80003bb4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bb6:	411c                	lw	a5,0(a0)
    80003bb8:	4705                	li	a4,1
    80003bba:	04e78963          	beq	a5,a4,80003c0c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bbe:	470d                	li	a4,3
    80003bc0:	04e78d63          	beq	a5,a4,80003c1a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bc4:	4709                	li	a4,2
    80003bc6:	06e79e63          	bne	a5,a4,80003c42 <fileread+0xa6>
    ilock(f->ip);
    80003bca:	6d08                	ld	a0,24(a0)
    80003bcc:	fffff097          	auipc	ra,0xfffff
    80003bd0:	ff2080e7          	jalr	-14(ra) # 80002bbe <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bd4:	874a                	mv	a4,s2
    80003bd6:	5094                	lw	a3,32(s1)
    80003bd8:	864e                	mv	a2,s3
    80003bda:	4585                	li	a1,1
    80003bdc:	6c88                	ld	a0,24(s1)
    80003bde:	fffff097          	auipc	ra,0xfffff
    80003be2:	294080e7          	jalr	660(ra) # 80002e72 <readi>
    80003be6:	892a                	mv	s2,a0
    80003be8:	00a05563          	blez	a0,80003bf2 <fileread+0x56>
      f->off += r;
    80003bec:	509c                	lw	a5,32(s1)
    80003bee:	9fa9                	addw	a5,a5,a0
    80003bf0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bf2:	6c88                	ld	a0,24(s1)
    80003bf4:	fffff097          	auipc	ra,0xfffff
    80003bf8:	08c080e7          	jalr	140(ra) # 80002c80 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bfc:	854a                	mv	a0,s2
    80003bfe:	70a2                	ld	ra,40(sp)
    80003c00:	7402                	ld	s0,32(sp)
    80003c02:	64e2                	ld	s1,24(sp)
    80003c04:	6942                	ld	s2,16(sp)
    80003c06:	69a2                	ld	s3,8(sp)
    80003c08:	6145                	addi	sp,sp,48
    80003c0a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c0c:	6908                	ld	a0,16(a0)
    80003c0e:	00000097          	auipc	ra,0x0
    80003c12:	3c0080e7          	jalr	960(ra) # 80003fce <piperead>
    80003c16:	892a                	mv	s2,a0
    80003c18:	b7d5                	j	80003bfc <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c1a:	02451783          	lh	a5,36(a0)
    80003c1e:	03079693          	slli	a3,a5,0x30
    80003c22:	92c1                	srli	a3,a3,0x30
    80003c24:	4725                	li	a4,9
    80003c26:	02d76863          	bltu	a4,a3,80003c56 <fileread+0xba>
    80003c2a:	0792                	slli	a5,a5,0x4
    80003c2c:	00015717          	auipc	a4,0x15
    80003c30:	69c70713          	addi	a4,a4,1692 # 800192c8 <devsw>
    80003c34:	97ba                	add	a5,a5,a4
    80003c36:	639c                	ld	a5,0(a5)
    80003c38:	c38d                	beqz	a5,80003c5a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c3a:	4505                	li	a0,1
    80003c3c:	9782                	jalr	a5
    80003c3e:	892a                	mv	s2,a0
    80003c40:	bf75                	j	80003bfc <fileread+0x60>
    panic("fileread");
    80003c42:	00005517          	auipc	a0,0x5
    80003c46:	b6650513          	addi	a0,a0,-1178 # 800087a8 <sysname+0x260>
    80003c4a:	00002097          	auipc	ra,0x2
    80003c4e:	fe6080e7          	jalr	-26(ra) # 80005c30 <panic>
    return -1;
    80003c52:	597d                	li	s2,-1
    80003c54:	b765                	j	80003bfc <fileread+0x60>
      return -1;
    80003c56:	597d                	li	s2,-1
    80003c58:	b755                	j	80003bfc <fileread+0x60>
    80003c5a:	597d                	li	s2,-1
    80003c5c:	b745                	j	80003bfc <fileread+0x60>

0000000080003c5e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c5e:	715d                	addi	sp,sp,-80
    80003c60:	e486                	sd	ra,72(sp)
    80003c62:	e0a2                	sd	s0,64(sp)
    80003c64:	fc26                	sd	s1,56(sp)
    80003c66:	f84a                	sd	s2,48(sp)
    80003c68:	f44e                	sd	s3,40(sp)
    80003c6a:	f052                	sd	s4,32(sp)
    80003c6c:	ec56                	sd	s5,24(sp)
    80003c6e:	e85a                	sd	s6,16(sp)
    80003c70:	e45e                	sd	s7,8(sp)
    80003c72:	e062                	sd	s8,0(sp)
    80003c74:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c76:	00954783          	lbu	a5,9(a0)
    80003c7a:	10078663          	beqz	a5,80003d86 <filewrite+0x128>
    80003c7e:	892a                	mv	s2,a0
    80003c80:	8b2e                	mv	s6,a1
    80003c82:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c84:	411c                	lw	a5,0(a0)
    80003c86:	4705                	li	a4,1
    80003c88:	02e78263          	beq	a5,a4,80003cac <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c8c:	470d                	li	a4,3
    80003c8e:	02e78663          	beq	a5,a4,80003cba <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c92:	4709                	li	a4,2
    80003c94:	0ee79163          	bne	a5,a4,80003d76 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c98:	0ac05d63          	blez	a2,80003d52 <filewrite+0xf4>
    int i = 0;
    80003c9c:	4981                	li	s3,0
    80003c9e:	6b85                	lui	s7,0x1
    80003ca0:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003ca4:	6c05                	lui	s8,0x1
    80003ca6:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003caa:	a861                	j	80003d42 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cac:	6908                	ld	a0,16(a0)
    80003cae:	00000097          	auipc	ra,0x0
    80003cb2:	22e080e7          	jalr	558(ra) # 80003edc <pipewrite>
    80003cb6:	8a2a                	mv	s4,a0
    80003cb8:	a045                	j	80003d58 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cba:	02451783          	lh	a5,36(a0)
    80003cbe:	03079693          	slli	a3,a5,0x30
    80003cc2:	92c1                	srli	a3,a3,0x30
    80003cc4:	4725                	li	a4,9
    80003cc6:	0cd76263          	bltu	a4,a3,80003d8a <filewrite+0x12c>
    80003cca:	0792                	slli	a5,a5,0x4
    80003ccc:	00015717          	auipc	a4,0x15
    80003cd0:	5fc70713          	addi	a4,a4,1532 # 800192c8 <devsw>
    80003cd4:	97ba                	add	a5,a5,a4
    80003cd6:	679c                	ld	a5,8(a5)
    80003cd8:	cbdd                	beqz	a5,80003d8e <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cda:	4505                	li	a0,1
    80003cdc:	9782                	jalr	a5
    80003cde:	8a2a                	mv	s4,a0
    80003ce0:	a8a5                	j	80003d58 <filewrite+0xfa>
    80003ce2:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003ce6:	00000097          	auipc	ra,0x0
    80003cea:	8b4080e7          	jalr	-1868(ra) # 8000359a <begin_op>
      ilock(f->ip);
    80003cee:	01893503          	ld	a0,24(s2)
    80003cf2:	fffff097          	auipc	ra,0xfffff
    80003cf6:	ecc080e7          	jalr	-308(ra) # 80002bbe <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cfa:	8756                	mv	a4,s5
    80003cfc:	02092683          	lw	a3,32(s2)
    80003d00:	01698633          	add	a2,s3,s6
    80003d04:	4585                	li	a1,1
    80003d06:	01893503          	ld	a0,24(s2)
    80003d0a:	fffff097          	auipc	ra,0xfffff
    80003d0e:	260080e7          	jalr	608(ra) # 80002f6a <writei>
    80003d12:	84aa                	mv	s1,a0
    80003d14:	00a05763          	blez	a0,80003d22 <filewrite+0xc4>
        f->off += r;
    80003d18:	02092783          	lw	a5,32(s2)
    80003d1c:	9fa9                	addw	a5,a5,a0
    80003d1e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d22:	01893503          	ld	a0,24(s2)
    80003d26:	fffff097          	auipc	ra,0xfffff
    80003d2a:	f5a080e7          	jalr	-166(ra) # 80002c80 <iunlock>
      end_op();
    80003d2e:	00000097          	auipc	ra,0x0
    80003d32:	8ea080e7          	jalr	-1814(ra) # 80003618 <end_op>

      if(r != n1){
    80003d36:	009a9f63          	bne	s5,s1,80003d54 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d3a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d3e:	0149db63          	bge	s3,s4,80003d54 <filewrite+0xf6>
      int n1 = n - i;
    80003d42:	413a04bb          	subw	s1,s4,s3
    80003d46:	0004879b          	sext.w	a5,s1
    80003d4a:	f8fbdce3          	bge	s7,a5,80003ce2 <filewrite+0x84>
    80003d4e:	84e2                	mv	s1,s8
    80003d50:	bf49                	j	80003ce2 <filewrite+0x84>
    int i = 0;
    80003d52:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d54:	013a1f63          	bne	s4,s3,80003d72 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d58:	8552                	mv	a0,s4
    80003d5a:	60a6                	ld	ra,72(sp)
    80003d5c:	6406                	ld	s0,64(sp)
    80003d5e:	74e2                	ld	s1,56(sp)
    80003d60:	7942                	ld	s2,48(sp)
    80003d62:	79a2                	ld	s3,40(sp)
    80003d64:	7a02                	ld	s4,32(sp)
    80003d66:	6ae2                	ld	s5,24(sp)
    80003d68:	6b42                	ld	s6,16(sp)
    80003d6a:	6ba2                	ld	s7,8(sp)
    80003d6c:	6c02                	ld	s8,0(sp)
    80003d6e:	6161                	addi	sp,sp,80
    80003d70:	8082                	ret
    ret = (i == n ? n : -1);
    80003d72:	5a7d                	li	s4,-1
    80003d74:	b7d5                	j	80003d58 <filewrite+0xfa>
    panic("filewrite");
    80003d76:	00005517          	auipc	a0,0x5
    80003d7a:	a4250513          	addi	a0,a0,-1470 # 800087b8 <sysname+0x270>
    80003d7e:	00002097          	auipc	ra,0x2
    80003d82:	eb2080e7          	jalr	-334(ra) # 80005c30 <panic>
    return -1;
    80003d86:	5a7d                	li	s4,-1
    80003d88:	bfc1                	j	80003d58 <filewrite+0xfa>
      return -1;
    80003d8a:	5a7d                	li	s4,-1
    80003d8c:	b7f1                	j	80003d58 <filewrite+0xfa>
    80003d8e:	5a7d                	li	s4,-1
    80003d90:	b7e1                	j	80003d58 <filewrite+0xfa>

0000000080003d92 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d92:	7179                	addi	sp,sp,-48
    80003d94:	f406                	sd	ra,40(sp)
    80003d96:	f022                	sd	s0,32(sp)
    80003d98:	ec26                	sd	s1,24(sp)
    80003d9a:	e84a                	sd	s2,16(sp)
    80003d9c:	e44e                	sd	s3,8(sp)
    80003d9e:	e052                	sd	s4,0(sp)
    80003da0:	1800                	addi	s0,sp,48
    80003da2:	84aa                	mv	s1,a0
    80003da4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003da6:	0005b023          	sd	zero,0(a1)
    80003daa:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dae:	00000097          	auipc	ra,0x0
    80003db2:	bf8080e7          	jalr	-1032(ra) # 800039a6 <filealloc>
    80003db6:	e088                	sd	a0,0(s1)
    80003db8:	c551                	beqz	a0,80003e44 <pipealloc+0xb2>
    80003dba:	00000097          	auipc	ra,0x0
    80003dbe:	bec080e7          	jalr	-1044(ra) # 800039a6 <filealloc>
    80003dc2:	00aa3023          	sd	a0,0(s4)
    80003dc6:	c92d                	beqz	a0,80003e38 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dc8:	ffffc097          	auipc	ra,0xffffc
    80003dcc:	352080e7          	jalr	850(ra) # 8000011a <kalloc>
    80003dd0:	892a                	mv	s2,a0
    80003dd2:	c125                	beqz	a0,80003e32 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dd4:	4985                	li	s3,1
    80003dd6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dda:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dde:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003de2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003de6:	00004597          	auipc	a1,0x4
    80003dea:	5fa58593          	addi	a1,a1,1530 # 800083e0 <states.0+0x1a0>
    80003dee:	00002097          	auipc	ra,0x2
    80003df2:	2ea080e7          	jalr	746(ra) # 800060d8 <initlock>
  (*f0)->type = FD_PIPE;
    80003df6:	609c                	ld	a5,0(s1)
    80003df8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dfc:	609c                	ld	a5,0(s1)
    80003dfe:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e02:	609c                	ld	a5,0(s1)
    80003e04:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e08:	609c                	ld	a5,0(s1)
    80003e0a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e0e:	000a3783          	ld	a5,0(s4)
    80003e12:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e16:	000a3783          	ld	a5,0(s4)
    80003e1a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e1e:	000a3783          	ld	a5,0(s4)
    80003e22:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e26:	000a3783          	ld	a5,0(s4)
    80003e2a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e2e:	4501                	li	a0,0
    80003e30:	a025                	j	80003e58 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e32:	6088                	ld	a0,0(s1)
    80003e34:	e501                	bnez	a0,80003e3c <pipealloc+0xaa>
    80003e36:	a039                	j	80003e44 <pipealloc+0xb2>
    80003e38:	6088                	ld	a0,0(s1)
    80003e3a:	c51d                	beqz	a0,80003e68 <pipealloc+0xd6>
    fileclose(*f0);
    80003e3c:	00000097          	auipc	ra,0x0
    80003e40:	c26080e7          	jalr	-986(ra) # 80003a62 <fileclose>
  if(*f1)
    80003e44:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e48:	557d                	li	a0,-1
  if(*f1)
    80003e4a:	c799                	beqz	a5,80003e58 <pipealloc+0xc6>
    fileclose(*f1);
    80003e4c:	853e                	mv	a0,a5
    80003e4e:	00000097          	auipc	ra,0x0
    80003e52:	c14080e7          	jalr	-1004(ra) # 80003a62 <fileclose>
  return -1;
    80003e56:	557d                	li	a0,-1
}
    80003e58:	70a2                	ld	ra,40(sp)
    80003e5a:	7402                	ld	s0,32(sp)
    80003e5c:	64e2                	ld	s1,24(sp)
    80003e5e:	6942                	ld	s2,16(sp)
    80003e60:	69a2                	ld	s3,8(sp)
    80003e62:	6a02                	ld	s4,0(sp)
    80003e64:	6145                	addi	sp,sp,48
    80003e66:	8082                	ret
  return -1;
    80003e68:	557d                	li	a0,-1
    80003e6a:	b7fd                	j	80003e58 <pipealloc+0xc6>

0000000080003e6c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e6c:	1101                	addi	sp,sp,-32
    80003e6e:	ec06                	sd	ra,24(sp)
    80003e70:	e822                	sd	s0,16(sp)
    80003e72:	e426                	sd	s1,8(sp)
    80003e74:	e04a                	sd	s2,0(sp)
    80003e76:	1000                	addi	s0,sp,32
    80003e78:	84aa                	mv	s1,a0
    80003e7a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e7c:	00002097          	auipc	ra,0x2
    80003e80:	2ec080e7          	jalr	748(ra) # 80006168 <acquire>
  if(writable){
    80003e84:	02090d63          	beqz	s2,80003ebe <pipeclose+0x52>
    pi->writeopen = 0;
    80003e88:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e8c:	21848513          	addi	a0,s1,536
    80003e90:	ffffe097          	auipc	ra,0xffffe
    80003e94:	830080e7          	jalr	-2000(ra) # 800016c0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e98:	2204b783          	ld	a5,544(s1)
    80003e9c:	eb95                	bnez	a5,80003ed0 <pipeclose+0x64>
    release(&pi->lock);
    80003e9e:	8526                	mv	a0,s1
    80003ea0:	00002097          	auipc	ra,0x2
    80003ea4:	37c080e7          	jalr	892(ra) # 8000621c <release>
    kfree((char*)pi);
    80003ea8:	8526                	mv	a0,s1
    80003eaa:	ffffc097          	auipc	ra,0xffffc
    80003eae:	172080e7          	jalr	370(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eb2:	60e2                	ld	ra,24(sp)
    80003eb4:	6442                	ld	s0,16(sp)
    80003eb6:	64a2                	ld	s1,8(sp)
    80003eb8:	6902                	ld	s2,0(sp)
    80003eba:	6105                	addi	sp,sp,32
    80003ebc:	8082                	ret
    pi->readopen = 0;
    80003ebe:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ec2:	21c48513          	addi	a0,s1,540
    80003ec6:	ffffd097          	auipc	ra,0xffffd
    80003eca:	7fa080e7          	jalr	2042(ra) # 800016c0 <wakeup>
    80003ece:	b7e9                	j	80003e98 <pipeclose+0x2c>
    release(&pi->lock);
    80003ed0:	8526                	mv	a0,s1
    80003ed2:	00002097          	auipc	ra,0x2
    80003ed6:	34a080e7          	jalr	842(ra) # 8000621c <release>
}
    80003eda:	bfe1                	j	80003eb2 <pipeclose+0x46>

0000000080003edc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003edc:	711d                	addi	sp,sp,-96
    80003ede:	ec86                	sd	ra,88(sp)
    80003ee0:	e8a2                	sd	s0,80(sp)
    80003ee2:	e4a6                	sd	s1,72(sp)
    80003ee4:	e0ca                	sd	s2,64(sp)
    80003ee6:	fc4e                	sd	s3,56(sp)
    80003ee8:	f852                	sd	s4,48(sp)
    80003eea:	f456                	sd	s5,40(sp)
    80003eec:	f05a                	sd	s6,32(sp)
    80003eee:	ec5e                	sd	s7,24(sp)
    80003ef0:	e862                	sd	s8,16(sp)
    80003ef2:	1080                	addi	s0,sp,96
    80003ef4:	84aa                	mv	s1,a0
    80003ef6:	8aae                	mv	s5,a1
    80003ef8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003efa:	ffffd097          	auipc	ra,0xffffd
    80003efe:	f6e080e7          	jalr	-146(ra) # 80000e68 <myproc>
    80003f02:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f04:	8526                	mv	a0,s1
    80003f06:	00002097          	auipc	ra,0x2
    80003f0a:	262080e7          	jalr	610(ra) # 80006168 <acquire>
  while(i < n){
    80003f0e:	0b405363          	blez	s4,80003fb4 <pipewrite+0xd8>
  int i = 0;
    80003f12:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f14:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f16:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f1a:	21c48b93          	addi	s7,s1,540
    80003f1e:	a089                	j	80003f60 <pipewrite+0x84>
      release(&pi->lock);
    80003f20:	8526                	mv	a0,s1
    80003f22:	00002097          	auipc	ra,0x2
    80003f26:	2fa080e7          	jalr	762(ra) # 8000621c <release>
      return -1;
    80003f2a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f2c:	854a                	mv	a0,s2
    80003f2e:	60e6                	ld	ra,88(sp)
    80003f30:	6446                	ld	s0,80(sp)
    80003f32:	64a6                	ld	s1,72(sp)
    80003f34:	6906                	ld	s2,64(sp)
    80003f36:	79e2                	ld	s3,56(sp)
    80003f38:	7a42                	ld	s4,48(sp)
    80003f3a:	7aa2                	ld	s5,40(sp)
    80003f3c:	7b02                	ld	s6,32(sp)
    80003f3e:	6be2                	ld	s7,24(sp)
    80003f40:	6c42                	ld	s8,16(sp)
    80003f42:	6125                	addi	sp,sp,96
    80003f44:	8082                	ret
      wakeup(&pi->nread);
    80003f46:	8562                	mv	a0,s8
    80003f48:	ffffd097          	auipc	ra,0xffffd
    80003f4c:	778080e7          	jalr	1912(ra) # 800016c0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f50:	85a6                	mv	a1,s1
    80003f52:	855e                	mv	a0,s7
    80003f54:	ffffd097          	auipc	ra,0xffffd
    80003f58:	5e0080e7          	jalr	1504(ra) # 80001534 <sleep>
  while(i < n){
    80003f5c:	05495d63          	bge	s2,s4,80003fb6 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f60:	2204a783          	lw	a5,544(s1)
    80003f64:	dfd5                	beqz	a5,80003f20 <pipewrite+0x44>
    80003f66:	0289a783          	lw	a5,40(s3)
    80003f6a:	fbdd                	bnez	a5,80003f20 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f6c:	2184a783          	lw	a5,536(s1)
    80003f70:	21c4a703          	lw	a4,540(s1)
    80003f74:	2007879b          	addiw	a5,a5,512
    80003f78:	fcf707e3          	beq	a4,a5,80003f46 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f7c:	4685                	li	a3,1
    80003f7e:	01590633          	add	a2,s2,s5
    80003f82:	faf40593          	addi	a1,s0,-81
    80003f86:	0589b503          	ld	a0,88(s3)
    80003f8a:	ffffd097          	auipc	ra,0xffffd
    80003f8e:	c2e080e7          	jalr	-978(ra) # 80000bb8 <copyin>
    80003f92:	03650263          	beq	a0,s6,80003fb6 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f96:	21c4a783          	lw	a5,540(s1)
    80003f9a:	0017871b          	addiw	a4,a5,1
    80003f9e:	20e4ae23          	sw	a4,540(s1)
    80003fa2:	1ff7f793          	andi	a5,a5,511
    80003fa6:	97a6                	add	a5,a5,s1
    80003fa8:	faf44703          	lbu	a4,-81(s0)
    80003fac:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fb0:	2905                	addiw	s2,s2,1
    80003fb2:	b76d                	j	80003f5c <pipewrite+0x80>
  int i = 0;
    80003fb4:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fb6:	21848513          	addi	a0,s1,536
    80003fba:	ffffd097          	auipc	ra,0xffffd
    80003fbe:	706080e7          	jalr	1798(ra) # 800016c0 <wakeup>
  release(&pi->lock);
    80003fc2:	8526                	mv	a0,s1
    80003fc4:	00002097          	auipc	ra,0x2
    80003fc8:	258080e7          	jalr	600(ra) # 8000621c <release>
  return i;
    80003fcc:	b785                	j	80003f2c <pipewrite+0x50>

0000000080003fce <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fce:	715d                	addi	sp,sp,-80
    80003fd0:	e486                	sd	ra,72(sp)
    80003fd2:	e0a2                	sd	s0,64(sp)
    80003fd4:	fc26                	sd	s1,56(sp)
    80003fd6:	f84a                	sd	s2,48(sp)
    80003fd8:	f44e                	sd	s3,40(sp)
    80003fda:	f052                	sd	s4,32(sp)
    80003fdc:	ec56                	sd	s5,24(sp)
    80003fde:	e85a                	sd	s6,16(sp)
    80003fe0:	0880                	addi	s0,sp,80
    80003fe2:	84aa                	mv	s1,a0
    80003fe4:	892e                	mv	s2,a1
    80003fe6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fe8:	ffffd097          	auipc	ra,0xffffd
    80003fec:	e80080e7          	jalr	-384(ra) # 80000e68 <myproc>
    80003ff0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ff2:	8526                	mv	a0,s1
    80003ff4:	00002097          	auipc	ra,0x2
    80003ff8:	174080e7          	jalr	372(ra) # 80006168 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ffc:	2184a703          	lw	a4,536(s1)
    80004000:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004004:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004008:	02f71463          	bne	a4,a5,80004030 <piperead+0x62>
    8000400c:	2244a783          	lw	a5,548(s1)
    80004010:	c385                	beqz	a5,80004030 <piperead+0x62>
    if(pr->killed){
    80004012:	028a2783          	lw	a5,40(s4)
    80004016:	ebc9                	bnez	a5,800040a8 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004018:	85a6                	mv	a1,s1
    8000401a:	854e                	mv	a0,s3
    8000401c:	ffffd097          	auipc	ra,0xffffd
    80004020:	518080e7          	jalr	1304(ra) # 80001534 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004024:	2184a703          	lw	a4,536(s1)
    80004028:	21c4a783          	lw	a5,540(s1)
    8000402c:	fef700e3          	beq	a4,a5,8000400c <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004030:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004032:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004034:	05505463          	blez	s5,8000407c <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004038:	2184a783          	lw	a5,536(s1)
    8000403c:	21c4a703          	lw	a4,540(s1)
    80004040:	02f70e63          	beq	a4,a5,8000407c <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004044:	0017871b          	addiw	a4,a5,1
    80004048:	20e4ac23          	sw	a4,536(s1)
    8000404c:	1ff7f793          	andi	a5,a5,511
    80004050:	97a6                	add	a5,a5,s1
    80004052:	0187c783          	lbu	a5,24(a5)
    80004056:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000405a:	4685                	li	a3,1
    8000405c:	fbf40613          	addi	a2,s0,-65
    80004060:	85ca                	mv	a1,s2
    80004062:	058a3503          	ld	a0,88(s4)
    80004066:	ffffd097          	auipc	ra,0xffffd
    8000406a:	ac6080e7          	jalr	-1338(ra) # 80000b2c <copyout>
    8000406e:	01650763          	beq	a0,s6,8000407c <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004072:	2985                	addiw	s3,s3,1
    80004074:	0905                	addi	s2,s2,1
    80004076:	fd3a91e3          	bne	s5,s3,80004038 <piperead+0x6a>
    8000407a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000407c:	21c48513          	addi	a0,s1,540
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	640080e7          	jalr	1600(ra) # 800016c0 <wakeup>
  release(&pi->lock);
    80004088:	8526                	mv	a0,s1
    8000408a:	00002097          	auipc	ra,0x2
    8000408e:	192080e7          	jalr	402(ra) # 8000621c <release>
  return i;
}
    80004092:	854e                	mv	a0,s3
    80004094:	60a6                	ld	ra,72(sp)
    80004096:	6406                	ld	s0,64(sp)
    80004098:	74e2                	ld	s1,56(sp)
    8000409a:	7942                	ld	s2,48(sp)
    8000409c:	79a2                	ld	s3,40(sp)
    8000409e:	7a02                	ld	s4,32(sp)
    800040a0:	6ae2                	ld	s5,24(sp)
    800040a2:	6b42                	ld	s6,16(sp)
    800040a4:	6161                	addi	sp,sp,80
    800040a6:	8082                	ret
      release(&pi->lock);
    800040a8:	8526                	mv	a0,s1
    800040aa:	00002097          	auipc	ra,0x2
    800040ae:	172080e7          	jalr	370(ra) # 8000621c <release>
      return -1;
    800040b2:	59fd                	li	s3,-1
    800040b4:	bff9                	j	80004092 <piperead+0xc4>

00000000800040b6 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040b6:	de010113          	addi	sp,sp,-544
    800040ba:	20113c23          	sd	ra,536(sp)
    800040be:	20813823          	sd	s0,528(sp)
    800040c2:	20913423          	sd	s1,520(sp)
    800040c6:	21213023          	sd	s2,512(sp)
    800040ca:	ffce                	sd	s3,504(sp)
    800040cc:	fbd2                	sd	s4,496(sp)
    800040ce:	f7d6                	sd	s5,488(sp)
    800040d0:	f3da                	sd	s6,480(sp)
    800040d2:	efde                	sd	s7,472(sp)
    800040d4:	ebe2                	sd	s8,464(sp)
    800040d6:	e7e6                	sd	s9,456(sp)
    800040d8:	e3ea                	sd	s10,448(sp)
    800040da:	ff6e                	sd	s11,440(sp)
    800040dc:	1400                	addi	s0,sp,544
    800040de:	892a                	mv	s2,a0
    800040e0:	dea43423          	sd	a0,-536(s0)
    800040e4:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040e8:	ffffd097          	auipc	ra,0xffffd
    800040ec:	d80080e7          	jalr	-640(ra) # 80000e68 <myproc>
    800040f0:	84aa                	mv	s1,a0

  begin_op();
    800040f2:	fffff097          	auipc	ra,0xfffff
    800040f6:	4a8080e7          	jalr	1192(ra) # 8000359a <begin_op>

  if((ip = namei(path)) == 0){
    800040fa:	854a                	mv	a0,s2
    800040fc:	fffff097          	auipc	ra,0xfffff
    80004100:	27e080e7          	jalr	638(ra) # 8000337a <namei>
    80004104:	c93d                	beqz	a0,8000417a <exec+0xc4>
    80004106:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004108:	fffff097          	auipc	ra,0xfffff
    8000410c:	ab6080e7          	jalr	-1354(ra) # 80002bbe <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004110:	04000713          	li	a4,64
    80004114:	4681                	li	a3,0
    80004116:	e5040613          	addi	a2,s0,-432
    8000411a:	4581                	li	a1,0
    8000411c:	8556                	mv	a0,s5
    8000411e:	fffff097          	auipc	ra,0xfffff
    80004122:	d54080e7          	jalr	-684(ra) # 80002e72 <readi>
    80004126:	04000793          	li	a5,64
    8000412a:	00f51a63          	bne	a0,a5,8000413e <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000412e:	e5042703          	lw	a4,-432(s0)
    80004132:	464c47b7          	lui	a5,0x464c4
    80004136:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000413a:	04f70663          	beq	a4,a5,80004186 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000413e:	8556                	mv	a0,s5
    80004140:	fffff097          	auipc	ra,0xfffff
    80004144:	ce0080e7          	jalr	-800(ra) # 80002e20 <iunlockput>
    end_op();
    80004148:	fffff097          	auipc	ra,0xfffff
    8000414c:	4d0080e7          	jalr	1232(ra) # 80003618 <end_op>
  }
  return -1;
    80004150:	557d                	li	a0,-1
}
    80004152:	21813083          	ld	ra,536(sp)
    80004156:	21013403          	ld	s0,528(sp)
    8000415a:	20813483          	ld	s1,520(sp)
    8000415e:	20013903          	ld	s2,512(sp)
    80004162:	79fe                	ld	s3,504(sp)
    80004164:	7a5e                	ld	s4,496(sp)
    80004166:	7abe                	ld	s5,488(sp)
    80004168:	7b1e                	ld	s6,480(sp)
    8000416a:	6bfe                	ld	s7,472(sp)
    8000416c:	6c5e                	ld	s8,464(sp)
    8000416e:	6cbe                	ld	s9,456(sp)
    80004170:	6d1e                	ld	s10,448(sp)
    80004172:	7dfa                	ld	s11,440(sp)
    80004174:	22010113          	addi	sp,sp,544
    80004178:	8082                	ret
    end_op();
    8000417a:	fffff097          	auipc	ra,0xfffff
    8000417e:	49e080e7          	jalr	1182(ra) # 80003618 <end_op>
    return -1;
    80004182:	557d                	li	a0,-1
    80004184:	b7f9                	j	80004152 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004186:	8526                	mv	a0,s1
    80004188:	ffffd097          	auipc	ra,0xffffd
    8000418c:	da4080e7          	jalr	-604(ra) # 80000f2c <proc_pagetable>
    80004190:	8b2a                	mv	s6,a0
    80004192:	d555                	beqz	a0,8000413e <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004194:	e7042783          	lw	a5,-400(s0)
    80004198:	e8845703          	lhu	a4,-376(s0)
    8000419c:	c735                	beqz	a4,80004208 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000419e:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041a0:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800041a4:	6a05                	lui	s4,0x1
    800041a6:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041aa:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041ae:	6d85                	lui	s11,0x1
    800041b0:	7d7d                	lui	s10,0xfffff
    800041b2:	ac1d                	j	800043e8 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041b4:	00004517          	auipc	a0,0x4
    800041b8:	61450513          	addi	a0,a0,1556 # 800087c8 <sysname+0x280>
    800041bc:	00002097          	auipc	ra,0x2
    800041c0:	a74080e7          	jalr	-1420(ra) # 80005c30 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041c4:	874a                	mv	a4,s2
    800041c6:	009c86bb          	addw	a3,s9,s1
    800041ca:	4581                	li	a1,0
    800041cc:	8556                	mv	a0,s5
    800041ce:	fffff097          	auipc	ra,0xfffff
    800041d2:	ca4080e7          	jalr	-860(ra) # 80002e72 <readi>
    800041d6:	2501                	sext.w	a0,a0
    800041d8:	1aa91863          	bne	s2,a0,80004388 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800041dc:	009d84bb          	addw	s1,s11,s1
    800041e0:	013d09bb          	addw	s3,s10,s3
    800041e4:	1f74f263          	bgeu	s1,s7,800043c8 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    800041e8:	02049593          	slli	a1,s1,0x20
    800041ec:	9181                	srli	a1,a1,0x20
    800041ee:	95e2                	add	a1,a1,s8
    800041f0:	855a                	mv	a0,s6
    800041f2:	ffffc097          	auipc	ra,0xffffc
    800041f6:	332080e7          	jalr	818(ra) # 80000524 <walkaddr>
    800041fa:	862a                	mv	a2,a0
    if(pa == 0)
    800041fc:	dd45                	beqz	a0,800041b4 <exec+0xfe>
      n = PGSIZE;
    800041fe:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004200:	fd49f2e3          	bgeu	s3,s4,800041c4 <exec+0x10e>
      n = sz - i;
    80004204:	894e                	mv	s2,s3
    80004206:	bf7d                	j	800041c4 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004208:	4481                	li	s1,0
  iunlockput(ip);
    8000420a:	8556                	mv	a0,s5
    8000420c:	fffff097          	auipc	ra,0xfffff
    80004210:	c14080e7          	jalr	-1004(ra) # 80002e20 <iunlockput>
  end_op();
    80004214:	fffff097          	auipc	ra,0xfffff
    80004218:	404080e7          	jalr	1028(ra) # 80003618 <end_op>
  p = myproc();
    8000421c:	ffffd097          	auipc	ra,0xffffd
    80004220:	c4c080e7          	jalr	-948(ra) # 80000e68 <myproc>
    80004224:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004226:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    8000422a:	6785                	lui	a5,0x1
    8000422c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000422e:	97a6                	add	a5,a5,s1
    80004230:	777d                	lui	a4,0xfffff
    80004232:	8ff9                	and	a5,a5,a4
    80004234:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004238:	6609                	lui	a2,0x2
    8000423a:	963e                	add	a2,a2,a5
    8000423c:	85be                	mv	a1,a5
    8000423e:	855a                	mv	a0,s6
    80004240:	ffffc097          	auipc	ra,0xffffc
    80004244:	698080e7          	jalr	1688(ra) # 800008d8 <uvmalloc>
    80004248:	8c2a                	mv	s8,a0
  ip = 0;
    8000424a:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000424c:	12050e63          	beqz	a0,80004388 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004250:	75f9                	lui	a1,0xffffe
    80004252:	95aa                	add	a1,a1,a0
    80004254:	855a                	mv	a0,s6
    80004256:	ffffd097          	auipc	ra,0xffffd
    8000425a:	8a4080e7          	jalr	-1884(ra) # 80000afa <uvmclear>
  stackbase = sp - PGSIZE;
    8000425e:	7afd                	lui	s5,0xfffff
    80004260:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004262:	df043783          	ld	a5,-528(s0)
    80004266:	6388                	ld	a0,0(a5)
    80004268:	c925                	beqz	a0,800042d8 <exec+0x222>
    8000426a:	e9040993          	addi	s3,s0,-368
    8000426e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004272:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004274:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004276:	ffffc097          	auipc	ra,0xffffc
    8000427a:	0a4080e7          	jalr	164(ra) # 8000031a <strlen>
    8000427e:	0015079b          	addiw	a5,a0,1
    80004282:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004286:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000428a:	13596363          	bltu	s2,s5,800043b0 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000428e:	df043d83          	ld	s11,-528(s0)
    80004292:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004296:	8552                	mv	a0,s4
    80004298:	ffffc097          	auipc	ra,0xffffc
    8000429c:	082080e7          	jalr	130(ra) # 8000031a <strlen>
    800042a0:	0015069b          	addiw	a3,a0,1
    800042a4:	8652                	mv	a2,s4
    800042a6:	85ca                	mv	a1,s2
    800042a8:	855a                	mv	a0,s6
    800042aa:	ffffd097          	auipc	ra,0xffffd
    800042ae:	882080e7          	jalr	-1918(ra) # 80000b2c <copyout>
    800042b2:	10054363          	bltz	a0,800043b8 <exec+0x302>
    ustack[argc] = sp;
    800042b6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042ba:	0485                	addi	s1,s1,1
    800042bc:	008d8793          	addi	a5,s11,8
    800042c0:	def43823          	sd	a5,-528(s0)
    800042c4:	008db503          	ld	a0,8(s11)
    800042c8:	c911                	beqz	a0,800042dc <exec+0x226>
    if(argc >= MAXARG)
    800042ca:	09a1                	addi	s3,s3,8
    800042cc:	fb3c95e3          	bne	s9,s3,80004276 <exec+0x1c0>
  sz = sz1;
    800042d0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042d4:	4a81                	li	s5,0
    800042d6:	a84d                	j	80004388 <exec+0x2d2>
  sp = sz;
    800042d8:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042da:	4481                	li	s1,0
  ustack[argc] = 0;
    800042dc:	00349793          	slli	a5,s1,0x3
    800042e0:	f9078793          	addi	a5,a5,-112
    800042e4:	97a2                	add	a5,a5,s0
    800042e6:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800042ea:	00148693          	addi	a3,s1,1
    800042ee:	068e                	slli	a3,a3,0x3
    800042f0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042f4:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042f8:	01597663          	bgeu	s2,s5,80004304 <exec+0x24e>
  sz = sz1;
    800042fc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004300:	4a81                	li	s5,0
    80004302:	a059                	j	80004388 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004304:	e9040613          	addi	a2,s0,-368
    80004308:	85ca                	mv	a1,s2
    8000430a:	855a                	mv	a0,s6
    8000430c:	ffffd097          	auipc	ra,0xffffd
    80004310:	820080e7          	jalr	-2016(ra) # 80000b2c <copyout>
    80004314:	0a054663          	bltz	a0,800043c0 <exec+0x30a>
  p->trapframe->a1 = sp;
    80004318:	060bb783          	ld	a5,96(s7)
    8000431c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004320:	de843783          	ld	a5,-536(s0)
    80004324:	0007c703          	lbu	a4,0(a5)
    80004328:	cf11                	beqz	a4,80004344 <exec+0x28e>
    8000432a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000432c:	02f00693          	li	a3,47
    80004330:	a039                	j	8000433e <exec+0x288>
      last = s+1;
    80004332:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004336:	0785                	addi	a5,a5,1
    80004338:	fff7c703          	lbu	a4,-1(a5)
    8000433c:	c701                	beqz	a4,80004344 <exec+0x28e>
    if(*s == '/')
    8000433e:	fed71ce3          	bne	a4,a3,80004336 <exec+0x280>
    80004342:	bfc5                	j	80004332 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004344:	4641                	li	a2,16
    80004346:	de843583          	ld	a1,-536(s0)
    8000434a:	160b8513          	addi	a0,s7,352
    8000434e:	ffffc097          	auipc	ra,0xffffc
    80004352:	f9a080e7          	jalr	-102(ra) # 800002e8 <safestrcpy>
  oldpagetable = p->pagetable;
    80004356:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    8000435a:	056bbc23          	sd	s6,88(s7)
  p->sz = sz;
    8000435e:	058bb823          	sd	s8,80(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004362:	060bb783          	ld	a5,96(s7)
    80004366:	e6843703          	ld	a4,-408(s0)
    8000436a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000436c:	060bb783          	ld	a5,96(s7)
    80004370:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004374:	85ea                	mv	a1,s10
    80004376:	ffffd097          	auipc	ra,0xffffd
    8000437a:	c52080e7          	jalr	-942(ra) # 80000fc8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000437e:	0004851b          	sext.w	a0,s1
    80004382:	bbc1                	j	80004152 <exec+0x9c>
    80004384:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004388:	df843583          	ld	a1,-520(s0)
    8000438c:	855a                	mv	a0,s6
    8000438e:	ffffd097          	auipc	ra,0xffffd
    80004392:	c3a080e7          	jalr	-966(ra) # 80000fc8 <proc_freepagetable>
  if(ip){
    80004396:	da0a94e3          	bnez	s5,8000413e <exec+0x88>
  return -1;
    8000439a:	557d                	li	a0,-1
    8000439c:	bb5d                	j	80004152 <exec+0x9c>
    8000439e:	de943c23          	sd	s1,-520(s0)
    800043a2:	b7dd                	j	80004388 <exec+0x2d2>
    800043a4:	de943c23          	sd	s1,-520(s0)
    800043a8:	b7c5                	j	80004388 <exec+0x2d2>
    800043aa:	de943c23          	sd	s1,-520(s0)
    800043ae:	bfe9                	j	80004388 <exec+0x2d2>
  sz = sz1;
    800043b0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043b4:	4a81                	li	s5,0
    800043b6:	bfc9                	j	80004388 <exec+0x2d2>
  sz = sz1;
    800043b8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043bc:	4a81                	li	s5,0
    800043be:	b7e9                	j	80004388 <exec+0x2d2>
  sz = sz1;
    800043c0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043c4:	4a81                	li	s5,0
    800043c6:	b7c9                	j	80004388 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043c8:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043cc:	e0843783          	ld	a5,-504(s0)
    800043d0:	0017869b          	addiw	a3,a5,1
    800043d4:	e0d43423          	sd	a3,-504(s0)
    800043d8:	e0043783          	ld	a5,-512(s0)
    800043dc:	0387879b          	addiw	a5,a5,56
    800043e0:	e8845703          	lhu	a4,-376(s0)
    800043e4:	e2e6d3e3          	bge	a3,a4,8000420a <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043e8:	2781                	sext.w	a5,a5
    800043ea:	e0f43023          	sd	a5,-512(s0)
    800043ee:	03800713          	li	a4,56
    800043f2:	86be                	mv	a3,a5
    800043f4:	e1840613          	addi	a2,s0,-488
    800043f8:	4581                	li	a1,0
    800043fa:	8556                	mv	a0,s5
    800043fc:	fffff097          	auipc	ra,0xfffff
    80004400:	a76080e7          	jalr	-1418(ra) # 80002e72 <readi>
    80004404:	03800793          	li	a5,56
    80004408:	f6f51ee3          	bne	a0,a5,80004384 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    8000440c:	e1842783          	lw	a5,-488(s0)
    80004410:	4705                	li	a4,1
    80004412:	fae79de3          	bne	a5,a4,800043cc <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004416:	e4043603          	ld	a2,-448(s0)
    8000441a:	e3843783          	ld	a5,-456(s0)
    8000441e:	f8f660e3          	bltu	a2,a5,8000439e <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004422:	e2843783          	ld	a5,-472(s0)
    80004426:	963e                	add	a2,a2,a5
    80004428:	f6f66ee3          	bltu	a2,a5,800043a4 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000442c:	85a6                	mv	a1,s1
    8000442e:	855a                	mv	a0,s6
    80004430:	ffffc097          	auipc	ra,0xffffc
    80004434:	4a8080e7          	jalr	1192(ra) # 800008d8 <uvmalloc>
    80004438:	dea43c23          	sd	a0,-520(s0)
    8000443c:	d53d                	beqz	a0,800043aa <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    8000443e:	e2843c03          	ld	s8,-472(s0)
    80004442:	de043783          	ld	a5,-544(s0)
    80004446:	00fc77b3          	and	a5,s8,a5
    8000444a:	ff9d                	bnez	a5,80004388 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000444c:	e2042c83          	lw	s9,-480(s0)
    80004450:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004454:	f60b8ae3          	beqz	s7,800043c8 <exec+0x312>
    80004458:	89de                	mv	s3,s7
    8000445a:	4481                	li	s1,0
    8000445c:	b371                	j	800041e8 <exec+0x132>

000000008000445e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000445e:	7179                	addi	sp,sp,-48
    80004460:	f406                	sd	ra,40(sp)
    80004462:	f022                	sd	s0,32(sp)
    80004464:	ec26                	sd	s1,24(sp)
    80004466:	e84a                	sd	s2,16(sp)
    80004468:	1800                	addi	s0,sp,48
    8000446a:	892e                	mv	s2,a1
    8000446c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000446e:	fdc40593          	addi	a1,s0,-36
    80004472:	ffffe097          	auipc	ra,0xffffe
    80004476:	b0a080e7          	jalr	-1270(ra) # 80001f7c <argint>
    8000447a:	04054063          	bltz	a0,800044ba <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000447e:	fdc42703          	lw	a4,-36(s0)
    80004482:	47bd                	li	a5,15
    80004484:	02e7ed63          	bltu	a5,a4,800044be <argfd+0x60>
    80004488:	ffffd097          	auipc	ra,0xffffd
    8000448c:	9e0080e7          	jalr	-1568(ra) # 80000e68 <myproc>
    80004490:	fdc42703          	lw	a4,-36(s0)
    80004494:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    80004498:	078e                	slli	a5,a5,0x3
    8000449a:	953e                	add	a0,a0,a5
    8000449c:	651c                	ld	a5,8(a0)
    8000449e:	c395                	beqz	a5,800044c2 <argfd+0x64>
    return -1;
  if(pfd)
    800044a0:	00090463          	beqz	s2,800044a8 <argfd+0x4a>
    *pfd = fd;
    800044a4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044a8:	4501                	li	a0,0
  if(pf)
    800044aa:	c091                	beqz	s1,800044ae <argfd+0x50>
    *pf = f;
    800044ac:	e09c                	sd	a5,0(s1)
}
    800044ae:	70a2                	ld	ra,40(sp)
    800044b0:	7402                	ld	s0,32(sp)
    800044b2:	64e2                	ld	s1,24(sp)
    800044b4:	6942                	ld	s2,16(sp)
    800044b6:	6145                	addi	sp,sp,48
    800044b8:	8082                	ret
    return -1;
    800044ba:	557d                	li	a0,-1
    800044bc:	bfcd                	j	800044ae <argfd+0x50>
    return -1;
    800044be:	557d                	li	a0,-1
    800044c0:	b7fd                	j	800044ae <argfd+0x50>
    800044c2:	557d                	li	a0,-1
    800044c4:	b7ed                	j	800044ae <argfd+0x50>

00000000800044c6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044c6:	1101                	addi	sp,sp,-32
    800044c8:	ec06                	sd	ra,24(sp)
    800044ca:	e822                	sd	s0,16(sp)
    800044cc:	e426                	sd	s1,8(sp)
    800044ce:	1000                	addi	s0,sp,32
    800044d0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044d2:	ffffd097          	auipc	ra,0xffffd
    800044d6:	996080e7          	jalr	-1642(ra) # 80000e68 <myproc>
    800044da:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044dc:	0d850793          	addi	a5,a0,216
    800044e0:	4501                	li	a0,0
    800044e2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044e4:	6398                	ld	a4,0(a5)
    800044e6:	cb19                	beqz	a4,800044fc <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044e8:	2505                	addiw	a0,a0,1
    800044ea:	07a1                	addi	a5,a5,8
    800044ec:	fed51ce3          	bne	a0,a3,800044e4 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044f0:	557d                	li	a0,-1
}
    800044f2:	60e2                	ld	ra,24(sp)
    800044f4:	6442                	ld	s0,16(sp)
    800044f6:	64a2                	ld	s1,8(sp)
    800044f8:	6105                	addi	sp,sp,32
    800044fa:	8082                	ret
      p->ofile[fd] = f;
    800044fc:	01a50793          	addi	a5,a0,26
    80004500:	078e                	slli	a5,a5,0x3
    80004502:	963e                	add	a2,a2,a5
    80004504:	e604                	sd	s1,8(a2)
      return fd;
    80004506:	b7f5                	j	800044f2 <fdalloc+0x2c>

0000000080004508 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004508:	715d                	addi	sp,sp,-80
    8000450a:	e486                	sd	ra,72(sp)
    8000450c:	e0a2                	sd	s0,64(sp)
    8000450e:	fc26                	sd	s1,56(sp)
    80004510:	f84a                	sd	s2,48(sp)
    80004512:	f44e                	sd	s3,40(sp)
    80004514:	f052                	sd	s4,32(sp)
    80004516:	ec56                	sd	s5,24(sp)
    80004518:	0880                	addi	s0,sp,80
    8000451a:	89ae                	mv	s3,a1
    8000451c:	8ab2                	mv	s5,a2
    8000451e:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004520:	fb040593          	addi	a1,s0,-80
    80004524:	fffff097          	auipc	ra,0xfffff
    80004528:	e74080e7          	jalr	-396(ra) # 80003398 <nameiparent>
    8000452c:	892a                	mv	s2,a0
    8000452e:	12050e63          	beqz	a0,8000466a <create+0x162>
    return 0;

  ilock(dp);
    80004532:	ffffe097          	auipc	ra,0xffffe
    80004536:	68c080e7          	jalr	1676(ra) # 80002bbe <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000453a:	4601                	li	a2,0
    8000453c:	fb040593          	addi	a1,s0,-80
    80004540:	854a                	mv	a0,s2
    80004542:	fffff097          	auipc	ra,0xfffff
    80004546:	b60080e7          	jalr	-1184(ra) # 800030a2 <dirlookup>
    8000454a:	84aa                	mv	s1,a0
    8000454c:	c921                	beqz	a0,8000459c <create+0x94>
    iunlockput(dp);
    8000454e:	854a                	mv	a0,s2
    80004550:	fffff097          	auipc	ra,0xfffff
    80004554:	8d0080e7          	jalr	-1840(ra) # 80002e20 <iunlockput>
    ilock(ip);
    80004558:	8526                	mv	a0,s1
    8000455a:	ffffe097          	auipc	ra,0xffffe
    8000455e:	664080e7          	jalr	1636(ra) # 80002bbe <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004562:	2981                	sext.w	s3,s3
    80004564:	4789                	li	a5,2
    80004566:	02f99463          	bne	s3,a5,8000458e <create+0x86>
    8000456a:	0444d783          	lhu	a5,68(s1)
    8000456e:	37f9                	addiw	a5,a5,-2
    80004570:	17c2                	slli	a5,a5,0x30
    80004572:	93c1                	srli	a5,a5,0x30
    80004574:	4705                	li	a4,1
    80004576:	00f76c63          	bltu	a4,a5,8000458e <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000457a:	8526                	mv	a0,s1
    8000457c:	60a6                	ld	ra,72(sp)
    8000457e:	6406                	ld	s0,64(sp)
    80004580:	74e2                	ld	s1,56(sp)
    80004582:	7942                	ld	s2,48(sp)
    80004584:	79a2                	ld	s3,40(sp)
    80004586:	7a02                	ld	s4,32(sp)
    80004588:	6ae2                	ld	s5,24(sp)
    8000458a:	6161                	addi	sp,sp,80
    8000458c:	8082                	ret
    iunlockput(ip);
    8000458e:	8526                	mv	a0,s1
    80004590:	fffff097          	auipc	ra,0xfffff
    80004594:	890080e7          	jalr	-1904(ra) # 80002e20 <iunlockput>
    return 0;
    80004598:	4481                	li	s1,0
    8000459a:	b7c5                	j	8000457a <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000459c:	85ce                	mv	a1,s3
    8000459e:	00092503          	lw	a0,0(s2)
    800045a2:	ffffe097          	auipc	ra,0xffffe
    800045a6:	482080e7          	jalr	1154(ra) # 80002a24 <ialloc>
    800045aa:	84aa                	mv	s1,a0
    800045ac:	c521                	beqz	a0,800045f4 <create+0xec>
  ilock(ip);
    800045ae:	ffffe097          	auipc	ra,0xffffe
    800045b2:	610080e7          	jalr	1552(ra) # 80002bbe <ilock>
  ip->major = major;
    800045b6:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045ba:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045be:	4a05                	li	s4,1
    800045c0:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800045c4:	8526                	mv	a0,s1
    800045c6:	ffffe097          	auipc	ra,0xffffe
    800045ca:	52c080e7          	jalr	1324(ra) # 80002af2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045ce:	2981                	sext.w	s3,s3
    800045d0:	03498a63          	beq	s3,s4,80004604 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800045d4:	40d0                	lw	a2,4(s1)
    800045d6:	fb040593          	addi	a1,s0,-80
    800045da:	854a                	mv	a0,s2
    800045dc:	fffff097          	auipc	ra,0xfffff
    800045e0:	cdc080e7          	jalr	-804(ra) # 800032b8 <dirlink>
    800045e4:	06054b63          	bltz	a0,8000465a <create+0x152>
  iunlockput(dp);
    800045e8:	854a                	mv	a0,s2
    800045ea:	fffff097          	auipc	ra,0xfffff
    800045ee:	836080e7          	jalr	-1994(ra) # 80002e20 <iunlockput>
  return ip;
    800045f2:	b761                	j	8000457a <create+0x72>
    panic("create: ialloc");
    800045f4:	00004517          	auipc	a0,0x4
    800045f8:	1f450513          	addi	a0,a0,500 # 800087e8 <sysname+0x2a0>
    800045fc:	00001097          	auipc	ra,0x1
    80004600:	634080e7          	jalr	1588(ra) # 80005c30 <panic>
    dp->nlink++;  // for ".."
    80004604:	04a95783          	lhu	a5,74(s2)
    80004608:	2785                	addiw	a5,a5,1
    8000460a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000460e:	854a                	mv	a0,s2
    80004610:	ffffe097          	auipc	ra,0xffffe
    80004614:	4e2080e7          	jalr	1250(ra) # 80002af2 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004618:	40d0                	lw	a2,4(s1)
    8000461a:	00004597          	auipc	a1,0x4
    8000461e:	1de58593          	addi	a1,a1,478 # 800087f8 <sysname+0x2b0>
    80004622:	8526                	mv	a0,s1
    80004624:	fffff097          	auipc	ra,0xfffff
    80004628:	c94080e7          	jalr	-876(ra) # 800032b8 <dirlink>
    8000462c:	00054f63          	bltz	a0,8000464a <create+0x142>
    80004630:	00492603          	lw	a2,4(s2)
    80004634:	00004597          	auipc	a1,0x4
    80004638:	1cc58593          	addi	a1,a1,460 # 80008800 <sysname+0x2b8>
    8000463c:	8526                	mv	a0,s1
    8000463e:	fffff097          	auipc	ra,0xfffff
    80004642:	c7a080e7          	jalr	-902(ra) # 800032b8 <dirlink>
    80004646:	f80557e3          	bgez	a0,800045d4 <create+0xcc>
      panic("create dots");
    8000464a:	00004517          	auipc	a0,0x4
    8000464e:	1be50513          	addi	a0,a0,446 # 80008808 <sysname+0x2c0>
    80004652:	00001097          	auipc	ra,0x1
    80004656:	5de080e7          	jalr	1502(ra) # 80005c30 <panic>
    panic("create: dirlink");
    8000465a:	00004517          	auipc	a0,0x4
    8000465e:	1be50513          	addi	a0,a0,446 # 80008818 <sysname+0x2d0>
    80004662:	00001097          	auipc	ra,0x1
    80004666:	5ce080e7          	jalr	1486(ra) # 80005c30 <panic>
    return 0;
    8000466a:	84aa                	mv	s1,a0
    8000466c:	b739                	j	8000457a <create+0x72>

000000008000466e <sys_dup>:
{
    8000466e:	7179                	addi	sp,sp,-48
    80004670:	f406                	sd	ra,40(sp)
    80004672:	f022                	sd	s0,32(sp)
    80004674:	ec26                	sd	s1,24(sp)
    80004676:	e84a                	sd	s2,16(sp)
    80004678:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000467a:	fd840613          	addi	a2,s0,-40
    8000467e:	4581                	li	a1,0
    80004680:	4501                	li	a0,0
    80004682:	00000097          	auipc	ra,0x0
    80004686:	ddc080e7          	jalr	-548(ra) # 8000445e <argfd>
    return -1;
    8000468a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000468c:	02054363          	bltz	a0,800046b2 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004690:	fd843903          	ld	s2,-40(s0)
    80004694:	854a                	mv	a0,s2
    80004696:	00000097          	auipc	ra,0x0
    8000469a:	e30080e7          	jalr	-464(ra) # 800044c6 <fdalloc>
    8000469e:	84aa                	mv	s1,a0
    return -1;
    800046a0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046a2:	00054863          	bltz	a0,800046b2 <sys_dup+0x44>
  filedup(f);
    800046a6:	854a                	mv	a0,s2
    800046a8:	fffff097          	auipc	ra,0xfffff
    800046ac:	368080e7          	jalr	872(ra) # 80003a10 <filedup>
  return fd;
    800046b0:	87a6                	mv	a5,s1
}
    800046b2:	853e                	mv	a0,a5
    800046b4:	70a2                	ld	ra,40(sp)
    800046b6:	7402                	ld	s0,32(sp)
    800046b8:	64e2                	ld	s1,24(sp)
    800046ba:	6942                	ld	s2,16(sp)
    800046bc:	6145                	addi	sp,sp,48
    800046be:	8082                	ret

00000000800046c0 <sys_read>:
{
    800046c0:	7179                	addi	sp,sp,-48
    800046c2:	f406                	sd	ra,40(sp)
    800046c4:	f022                	sd	s0,32(sp)
    800046c6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046c8:	fe840613          	addi	a2,s0,-24
    800046cc:	4581                	li	a1,0
    800046ce:	4501                	li	a0,0
    800046d0:	00000097          	auipc	ra,0x0
    800046d4:	d8e080e7          	jalr	-626(ra) # 8000445e <argfd>
    return -1;
    800046d8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046da:	04054163          	bltz	a0,8000471c <sys_read+0x5c>
    800046de:	fe440593          	addi	a1,s0,-28
    800046e2:	4509                	li	a0,2
    800046e4:	ffffe097          	auipc	ra,0xffffe
    800046e8:	898080e7          	jalr	-1896(ra) # 80001f7c <argint>
    return -1;
    800046ec:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ee:	02054763          	bltz	a0,8000471c <sys_read+0x5c>
    800046f2:	fd840593          	addi	a1,s0,-40
    800046f6:	4505                	li	a0,1
    800046f8:	ffffe097          	auipc	ra,0xffffe
    800046fc:	8a6080e7          	jalr	-1882(ra) # 80001f9e <argaddr>
    return -1;
    80004700:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004702:	00054d63          	bltz	a0,8000471c <sys_read+0x5c>
  return fileread(f, p, n);
    80004706:	fe442603          	lw	a2,-28(s0)
    8000470a:	fd843583          	ld	a1,-40(s0)
    8000470e:	fe843503          	ld	a0,-24(s0)
    80004712:	fffff097          	auipc	ra,0xfffff
    80004716:	48a080e7          	jalr	1162(ra) # 80003b9c <fileread>
    8000471a:	87aa                	mv	a5,a0
}
    8000471c:	853e                	mv	a0,a5
    8000471e:	70a2                	ld	ra,40(sp)
    80004720:	7402                	ld	s0,32(sp)
    80004722:	6145                	addi	sp,sp,48
    80004724:	8082                	ret

0000000080004726 <sys_write>:
{
    80004726:	7179                	addi	sp,sp,-48
    80004728:	f406                	sd	ra,40(sp)
    8000472a:	f022                	sd	s0,32(sp)
    8000472c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000472e:	fe840613          	addi	a2,s0,-24
    80004732:	4581                	li	a1,0
    80004734:	4501                	li	a0,0
    80004736:	00000097          	auipc	ra,0x0
    8000473a:	d28080e7          	jalr	-728(ra) # 8000445e <argfd>
    return -1;
    8000473e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004740:	04054163          	bltz	a0,80004782 <sys_write+0x5c>
    80004744:	fe440593          	addi	a1,s0,-28
    80004748:	4509                	li	a0,2
    8000474a:	ffffe097          	auipc	ra,0xffffe
    8000474e:	832080e7          	jalr	-1998(ra) # 80001f7c <argint>
    return -1;
    80004752:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004754:	02054763          	bltz	a0,80004782 <sys_write+0x5c>
    80004758:	fd840593          	addi	a1,s0,-40
    8000475c:	4505                	li	a0,1
    8000475e:	ffffe097          	auipc	ra,0xffffe
    80004762:	840080e7          	jalr	-1984(ra) # 80001f9e <argaddr>
    return -1;
    80004766:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004768:	00054d63          	bltz	a0,80004782 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000476c:	fe442603          	lw	a2,-28(s0)
    80004770:	fd843583          	ld	a1,-40(s0)
    80004774:	fe843503          	ld	a0,-24(s0)
    80004778:	fffff097          	auipc	ra,0xfffff
    8000477c:	4e6080e7          	jalr	1254(ra) # 80003c5e <filewrite>
    80004780:	87aa                	mv	a5,a0
}
    80004782:	853e                	mv	a0,a5
    80004784:	70a2                	ld	ra,40(sp)
    80004786:	7402                	ld	s0,32(sp)
    80004788:	6145                	addi	sp,sp,48
    8000478a:	8082                	ret

000000008000478c <sys_close>:
{
    8000478c:	1101                	addi	sp,sp,-32
    8000478e:	ec06                	sd	ra,24(sp)
    80004790:	e822                	sd	s0,16(sp)
    80004792:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004794:	fe040613          	addi	a2,s0,-32
    80004798:	fec40593          	addi	a1,s0,-20
    8000479c:	4501                	li	a0,0
    8000479e:	00000097          	auipc	ra,0x0
    800047a2:	cc0080e7          	jalr	-832(ra) # 8000445e <argfd>
    return -1;
    800047a6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047a8:	02054463          	bltz	a0,800047d0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047ac:	ffffc097          	auipc	ra,0xffffc
    800047b0:	6bc080e7          	jalr	1724(ra) # 80000e68 <myproc>
    800047b4:	fec42783          	lw	a5,-20(s0)
    800047b8:	07e9                	addi	a5,a5,26
    800047ba:	078e                	slli	a5,a5,0x3
    800047bc:	953e                	add	a0,a0,a5
    800047be:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800047c2:	fe043503          	ld	a0,-32(s0)
    800047c6:	fffff097          	auipc	ra,0xfffff
    800047ca:	29c080e7          	jalr	668(ra) # 80003a62 <fileclose>
  return 0;
    800047ce:	4781                	li	a5,0
}
    800047d0:	853e                	mv	a0,a5
    800047d2:	60e2                	ld	ra,24(sp)
    800047d4:	6442                	ld	s0,16(sp)
    800047d6:	6105                	addi	sp,sp,32
    800047d8:	8082                	ret

00000000800047da <sys_fstat>:
{
    800047da:	1101                	addi	sp,sp,-32
    800047dc:	ec06                	sd	ra,24(sp)
    800047de:	e822                	sd	s0,16(sp)
    800047e0:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047e2:	fe840613          	addi	a2,s0,-24
    800047e6:	4581                	li	a1,0
    800047e8:	4501                	li	a0,0
    800047ea:	00000097          	auipc	ra,0x0
    800047ee:	c74080e7          	jalr	-908(ra) # 8000445e <argfd>
    return -1;
    800047f2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047f4:	02054563          	bltz	a0,8000481e <sys_fstat+0x44>
    800047f8:	fe040593          	addi	a1,s0,-32
    800047fc:	4505                	li	a0,1
    800047fe:	ffffd097          	auipc	ra,0xffffd
    80004802:	7a0080e7          	jalr	1952(ra) # 80001f9e <argaddr>
    return -1;
    80004806:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004808:	00054b63          	bltz	a0,8000481e <sys_fstat+0x44>
  return filestat(f, st);
    8000480c:	fe043583          	ld	a1,-32(s0)
    80004810:	fe843503          	ld	a0,-24(s0)
    80004814:	fffff097          	auipc	ra,0xfffff
    80004818:	316080e7          	jalr	790(ra) # 80003b2a <filestat>
    8000481c:	87aa                	mv	a5,a0
}
    8000481e:	853e                	mv	a0,a5
    80004820:	60e2                	ld	ra,24(sp)
    80004822:	6442                	ld	s0,16(sp)
    80004824:	6105                	addi	sp,sp,32
    80004826:	8082                	ret

0000000080004828 <sys_link>:
{
    80004828:	7169                	addi	sp,sp,-304
    8000482a:	f606                	sd	ra,296(sp)
    8000482c:	f222                	sd	s0,288(sp)
    8000482e:	ee26                	sd	s1,280(sp)
    80004830:	ea4a                	sd	s2,272(sp)
    80004832:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004834:	08000613          	li	a2,128
    80004838:	ed040593          	addi	a1,s0,-304
    8000483c:	4501                	li	a0,0
    8000483e:	ffffd097          	auipc	ra,0xffffd
    80004842:	782080e7          	jalr	1922(ra) # 80001fc0 <argstr>
    return -1;
    80004846:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004848:	10054e63          	bltz	a0,80004964 <sys_link+0x13c>
    8000484c:	08000613          	li	a2,128
    80004850:	f5040593          	addi	a1,s0,-176
    80004854:	4505                	li	a0,1
    80004856:	ffffd097          	auipc	ra,0xffffd
    8000485a:	76a080e7          	jalr	1898(ra) # 80001fc0 <argstr>
    return -1;
    8000485e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004860:	10054263          	bltz	a0,80004964 <sys_link+0x13c>
  begin_op();
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	d36080e7          	jalr	-714(ra) # 8000359a <begin_op>
  if((ip = namei(old)) == 0){
    8000486c:	ed040513          	addi	a0,s0,-304
    80004870:	fffff097          	auipc	ra,0xfffff
    80004874:	b0a080e7          	jalr	-1270(ra) # 8000337a <namei>
    80004878:	84aa                	mv	s1,a0
    8000487a:	c551                	beqz	a0,80004906 <sys_link+0xde>
  ilock(ip);
    8000487c:	ffffe097          	auipc	ra,0xffffe
    80004880:	342080e7          	jalr	834(ra) # 80002bbe <ilock>
  if(ip->type == T_DIR){
    80004884:	04449703          	lh	a4,68(s1)
    80004888:	4785                	li	a5,1
    8000488a:	08f70463          	beq	a4,a5,80004912 <sys_link+0xea>
  ip->nlink++;
    8000488e:	04a4d783          	lhu	a5,74(s1)
    80004892:	2785                	addiw	a5,a5,1
    80004894:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004898:	8526                	mv	a0,s1
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	258080e7          	jalr	600(ra) # 80002af2 <iupdate>
  iunlock(ip);
    800048a2:	8526                	mv	a0,s1
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	3dc080e7          	jalr	988(ra) # 80002c80 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048ac:	fd040593          	addi	a1,s0,-48
    800048b0:	f5040513          	addi	a0,s0,-176
    800048b4:	fffff097          	auipc	ra,0xfffff
    800048b8:	ae4080e7          	jalr	-1308(ra) # 80003398 <nameiparent>
    800048bc:	892a                	mv	s2,a0
    800048be:	c935                	beqz	a0,80004932 <sys_link+0x10a>
  ilock(dp);
    800048c0:	ffffe097          	auipc	ra,0xffffe
    800048c4:	2fe080e7          	jalr	766(ra) # 80002bbe <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048c8:	00092703          	lw	a4,0(s2)
    800048cc:	409c                	lw	a5,0(s1)
    800048ce:	04f71d63          	bne	a4,a5,80004928 <sys_link+0x100>
    800048d2:	40d0                	lw	a2,4(s1)
    800048d4:	fd040593          	addi	a1,s0,-48
    800048d8:	854a                	mv	a0,s2
    800048da:	fffff097          	auipc	ra,0xfffff
    800048de:	9de080e7          	jalr	-1570(ra) # 800032b8 <dirlink>
    800048e2:	04054363          	bltz	a0,80004928 <sys_link+0x100>
  iunlockput(dp);
    800048e6:	854a                	mv	a0,s2
    800048e8:	ffffe097          	auipc	ra,0xffffe
    800048ec:	538080e7          	jalr	1336(ra) # 80002e20 <iunlockput>
  iput(ip);
    800048f0:	8526                	mv	a0,s1
    800048f2:	ffffe097          	auipc	ra,0xffffe
    800048f6:	486080e7          	jalr	1158(ra) # 80002d78 <iput>
  end_op();
    800048fa:	fffff097          	auipc	ra,0xfffff
    800048fe:	d1e080e7          	jalr	-738(ra) # 80003618 <end_op>
  return 0;
    80004902:	4781                	li	a5,0
    80004904:	a085                	j	80004964 <sys_link+0x13c>
    end_op();
    80004906:	fffff097          	auipc	ra,0xfffff
    8000490a:	d12080e7          	jalr	-750(ra) # 80003618 <end_op>
    return -1;
    8000490e:	57fd                	li	a5,-1
    80004910:	a891                	j	80004964 <sys_link+0x13c>
    iunlockput(ip);
    80004912:	8526                	mv	a0,s1
    80004914:	ffffe097          	auipc	ra,0xffffe
    80004918:	50c080e7          	jalr	1292(ra) # 80002e20 <iunlockput>
    end_op();
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	cfc080e7          	jalr	-772(ra) # 80003618 <end_op>
    return -1;
    80004924:	57fd                	li	a5,-1
    80004926:	a83d                	j	80004964 <sys_link+0x13c>
    iunlockput(dp);
    80004928:	854a                	mv	a0,s2
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	4f6080e7          	jalr	1270(ra) # 80002e20 <iunlockput>
  ilock(ip);
    80004932:	8526                	mv	a0,s1
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	28a080e7          	jalr	650(ra) # 80002bbe <ilock>
  ip->nlink--;
    8000493c:	04a4d783          	lhu	a5,74(s1)
    80004940:	37fd                	addiw	a5,a5,-1
    80004942:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004946:	8526                	mv	a0,s1
    80004948:	ffffe097          	auipc	ra,0xffffe
    8000494c:	1aa080e7          	jalr	426(ra) # 80002af2 <iupdate>
  iunlockput(ip);
    80004950:	8526                	mv	a0,s1
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	4ce080e7          	jalr	1230(ra) # 80002e20 <iunlockput>
  end_op();
    8000495a:	fffff097          	auipc	ra,0xfffff
    8000495e:	cbe080e7          	jalr	-834(ra) # 80003618 <end_op>
  return -1;
    80004962:	57fd                	li	a5,-1
}
    80004964:	853e                	mv	a0,a5
    80004966:	70b2                	ld	ra,296(sp)
    80004968:	7412                	ld	s0,288(sp)
    8000496a:	64f2                	ld	s1,280(sp)
    8000496c:	6952                	ld	s2,272(sp)
    8000496e:	6155                	addi	sp,sp,304
    80004970:	8082                	ret

0000000080004972 <sys_unlink>:
{
    80004972:	7151                	addi	sp,sp,-240
    80004974:	f586                	sd	ra,232(sp)
    80004976:	f1a2                	sd	s0,224(sp)
    80004978:	eda6                	sd	s1,216(sp)
    8000497a:	e9ca                	sd	s2,208(sp)
    8000497c:	e5ce                	sd	s3,200(sp)
    8000497e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004980:	08000613          	li	a2,128
    80004984:	f3040593          	addi	a1,s0,-208
    80004988:	4501                	li	a0,0
    8000498a:	ffffd097          	auipc	ra,0xffffd
    8000498e:	636080e7          	jalr	1590(ra) # 80001fc0 <argstr>
    80004992:	18054163          	bltz	a0,80004b14 <sys_unlink+0x1a2>
  begin_op();
    80004996:	fffff097          	auipc	ra,0xfffff
    8000499a:	c04080e7          	jalr	-1020(ra) # 8000359a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000499e:	fb040593          	addi	a1,s0,-80
    800049a2:	f3040513          	addi	a0,s0,-208
    800049a6:	fffff097          	auipc	ra,0xfffff
    800049aa:	9f2080e7          	jalr	-1550(ra) # 80003398 <nameiparent>
    800049ae:	84aa                	mv	s1,a0
    800049b0:	c979                	beqz	a0,80004a86 <sys_unlink+0x114>
  ilock(dp);
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	20c080e7          	jalr	524(ra) # 80002bbe <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049ba:	00004597          	auipc	a1,0x4
    800049be:	e3e58593          	addi	a1,a1,-450 # 800087f8 <sysname+0x2b0>
    800049c2:	fb040513          	addi	a0,s0,-80
    800049c6:	ffffe097          	auipc	ra,0xffffe
    800049ca:	6c2080e7          	jalr	1730(ra) # 80003088 <namecmp>
    800049ce:	14050a63          	beqz	a0,80004b22 <sys_unlink+0x1b0>
    800049d2:	00004597          	auipc	a1,0x4
    800049d6:	e2e58593          	addi	a1,a1,-466 # 80008800 <sysname+0x2b8>
    800049da:	fb040513          	addi	a0,s0,-80
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	6aa080e7          	jalr	1706(ra) # 80003088 <namecmp>
    800049e6:	12050e63          	beqz	a0,80004b22 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049ea:	f2c40613          	addi	a2,s0,-212
    800049ee:	fb040593          	addi	a1,s0,-80
    800049f2:	8526                	mv	a0,s1
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	6ae080e7          	jalr	1710(ra) # 800030a2 <dirlookup>
    800049fc:	892a                	mv	s2,a0
    800049fe:	12050263          	beqz	a0,80004b22 <sys_unlink+0x1b0>
  ilock(ip);
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	1bc080e7          	jalr	444(ra) # 80002bbe <ilock>
  if(ip->nlink < 1)
    80004a0a:	04a91783          	lh	a5,74(s2)
    80004a0e:	08f05263          	blez	a5,80004a92 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a12:	04491703          	lh	a4,68(s2)
    80004a16:	4785                	li	a5,1
    80004a18:	08f70563          	beq	a4,a5,80004aa2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a1c:	4641                	li	a2,16
    80004a1e:	4581                	li	a1,0
    80004a20:	fc040513          	addi	a0,s0,-64
    80004a24:	ffffb097          	auipc	ra,0xffffb
    80004a28:	77a080e7          	jalr	1914(ra) # 8000019e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a2c:	4741                	li	a4,16
    80004a2e:	f2c42683          	lw	a3,-212(s0)
    80004a32:	fc040613          	addi	a2,s0,-64
    80004a36:	4581                	li	a1,0
    80004a38:	8526                	mv	a0,s1
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	530080e7          	jalr	1328(ra) # 80002f6a <writei>
    80004a42:	47c1                	li	a5,16
    80004a44:	0af51563          	bne	a0,a5,80004aee <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a48:	04491703          	lh	a4,68(s2)
    80004a4c:	4785                	li	a5,1
    80004a4e:	0af70863          	beq	a4,a5,80004afe <sys_unlink+0x18c>
  iunlockput(dp);
    80004a52:	8526                	mv	a0,s1
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	3cc080e7          	jalr	972(ra) # 80002e20 <iunlockput>
  ip->nlink--;
    80004a5c:	04a95783          	lhu	a5,74(s2)
    80004a60:	37fd                	addiw	a5,a5,-1
    80004a62:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a66:	854a                	mv	a0,s2
    80004a68:	ffffe097          	auipc	ra,0xffffe
    80004a6c:	08a080e7          	jalr	138(ra) # 80002af2 <iupdate>
  iunlockput(ip);
    80004a70:	854a                	mv	a0,s2
    80004a72:	ffffe097          	auipc	ra,0xffffe
    80004a76:	3ae080e7          	jalr	942(ra) # 80002e20 <iunlockput>
  end_op();
    80004a7a:	fffff097          	auipc	ra,0xfffff
    80004a7e:	b9e080e7          	jalr	-1122(ra) # 80003618 <end_op>
  return 0;
    80004a82:	4501                	li	a0,0
    80004a84:	a84d                	j	80004b36 <sys_unlink+0x1c4>
    end_op();
    80004a86:	fffff097          	auipc	ra,0xfffff
    80004a8a:	b92080e7          	jalr	-1134(ra) # 80003618 <end_op>
    return -1;
    80004a8e:	557d                	li	a0,-1
    80004a90:	a05d                	j	80004b36 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a92:	00004517          	auipc	a0,0x4
    80004a96:	d9650513          	addi	a0,a0,-618 # 80008828 <sysname+0x2e0>
    80004a9a:	00001097          	auipc	ra,0x1
    80004a9e:	196080e7          	jalr	406(ra) # 80005c30 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aa2:	04c92703          	lw	a4,76(s2)
    80004aa6:	02000793          	li	a5,32
    80004aaa:	f6e7f9e3          	bgeu	a5,a4,80004a1c <sys_unlink+0xaa>
    80004aae:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ab2:	4741                	li	a4,16
    80004ab4:	86ce                	mv	a3,s3
    80004ab6:	f1840613          	addi	a2,s0,-232
    80004aba:	4581                	li	a1,0
    80004abc:	854a                	mv	a0,s2
    80004abe:	ffffe097          	auipc	ra,0xffffe
    80004ac2:	3b4080e7          	jalr	948(ra) # 80002e72 <readi>
    80004ac6:	47c1                	li	a5,16
    80004ac8:	00f51b63          	bne	a0,a5,80004ade <sys_unlink+0x16c>
    if(de.inum != 0)
    80004acc:	f1845783          	lhu	a5,-232(s0)
    80004ad0:	e7a1                	bnez	a5,80004b18 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ad2:	29c1                	addiw	s3,s3,16
    80004ad4:	04c92783          	lw	a5,76(s2)
    80004ad8:	fcf9ede3          	bltu	s3,a5,80004ab2 <sys_unlink+0x140>
    80004adc:	b781                	j	80004a1c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ade:	00004517          	auipc	a0,0x4
    80004ae2:	d6250513          	addi	a0,a0,-670 # 80008840 <sysname+0x2f8>
    80004ae6:	00001097          	auipc	ra,0x1
    80004aea:	14a080e7          	jalr	330(ra) # 80005c30 <panic>
    panic("unlink: writei");
    80004aee:	00004517          	auipc	a0,0x4
    80004af2:	d6a50513          	addi	a0,a0,-662 # 80008858 <sysname+0x310>
    80004af6:	00001097          	auipc	ra,0x1
    80004afa:	13a080e7          	jalr	314(ra) # 80005c30 <panic>
    dp->nlink--;
    80004afe:	04a4d783          	lhu	a5,74(s1)
    80004b02:	37fd                	addiw	a5,a5,-1
    80004b04:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b08:	8526                	mv	a0,s1
    80004b0a:	ffffe097          	auipc	ra,0xffffe
    80004b0e:	fe8080e7          	jalr	-24(ra) # 80002af2 <iupdate>
    80004b12:	b781                	j	80004a52 <sys_unlink+0xe0>
    return -1;
    80004b14:	557d                	li	a0,-1
    80004b16:	a005                	j	80004b36 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b18:	854a                	mv	a0,s2
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	306080e7          	jalr	774(ra) # 80002e20 <iunlockput>
  iunlockput(dp);
    80004b22:	8526                	mv	a0,s1
    80004b24:	ffffe097          	auipc	ra,0xffffe
    80004b28:	2fc080e7          	jalr	764(ra) # 80002e20 <iunlockput>
  end_op();
    80004b2c:	fffff097          	auipc	ra,0xfffff
    80004b30:	aec080e7          	jalr	-1300(ra) # 80003618 <end_op>
  return -1;
    80004b34:	557d                	li	a0,-1
}
    80004b36:	70ae                	ld	ra,232(sp)
    80004b38:	740e                	ld	s0,224(sp)
    80004b3a:	64ee                	ld	s1,216(sp)
    80004b3c:	694e                	ld	s2,208(sp)
    80004b3e:	69ae                	ld	s3,200(sp)
    80004b40:	616d                	addi	sp,sp,240
    80004b42:	8082                	ret

0000000080004b44 <sys_open>:

uint64
sys_open(void)
{
    80004b44:	7131                	addi	sp,sp,-192
    80004b46:	fd06                	sd	ra,184(sp)
    80004b48:	f922                	sd	s0,176(sp)
    80004b4a:	f526                	sd	s1,168(sp)
    80004b4c:	f14a                	sd	s2,160(sp)
    80004b4e:	ed4e                	sd	s3,152(sp)
    80004b50:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b52:	08000613          	li	a2,128
    80004b56:	f5040593          	addi	a1,s0,-176
    80004b5a:	4501                	li	a0,0
    80004b5c:	ffffd097          	auipc	ra,0xffffd
    80004b60:	464080e7          	jalr	1124(ra) # 80001fc0 <argstr>
    return -1;
    80004b64:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b66:	0c054163          	bltz	a0,80004c28 <sys_open+0xe4>
    80004b6a:	f4c40593          	addi	a1,s0,-180
    80004b6e:	4505                	li	a0,1
    80004b70:	ffffd097          	auipc	ra,0xffffd
    80004b74:	40c080e7          	jalr	1036(ra) # 80001f7c <argint>
    80004b78:	0a054863          	bltz	a0,80004c28 <sys_open+0xe4>

  begin_op();
    80004b7c:	fffff097          	auipc	ra,0xfffff
    80004b80:	a1e080e7          	jalr	-1506(ra) # 8000359a <begin_op>

  if(omode & O_CREATE){
    80004b84:	f4c42783          	lw	a5,-180(s0)
    80004b88:	2007f793          	andi	a5,a5,512
    80004b8c:	cbdd                	beqz	a5,80004c42 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b8e:	4681                	li	a3,0
    80004b90:	4601                	li	a2,0
    80004b92:	4589                	li	a1,2
    80004b94:	f5040513          	addi	a0,s0,-176
    80004b98:	00000097          	auipc	ra,0x0
    80004b9c:	970080e7          	jalr	-1680(ra) # 80004508 <create>
    80004ba0:	892a                	mv	s2,a0
    if(ip == 0){
    80004ba2:	c959                	beqz	a0,80004c38 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ba4:	04491703          	lh	a4,68(s2)
    80004ba8:	478d                	li	a5,3
    80004baa:	00f71763          	bne	a4,a5,80004bb8 <sys_open+0x74>
    80004bae:	04695703          	lhu	a4,70(s2)
    80004bb2:	47a5                	li	a5,9
    80004bb4:	0ce7ec63          	bltu	a5,a4,80004c8c <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bb8:	fffff097          	auipc	ra,0xfffff
    80004bbc:	dee080e7          	jalr	-530(ra) # 800039a6 <filealloc>
    80004bc0:	89aa                	mv	s3,a0
    80004bc2:	10050263          	beqz	a0,80004cc6 <sys_open+0x182>
    80004bc6:	00000097          	auipc	ra,0x0
    80004bca:	900080e7          	jalr	-1792(ra) # 800044c6 <fdalloc>
    80004bce:	84aa                	mv	s1,a0
    80004bd0:	0e054663          	bltz	a0,80004cbc <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bd4:	04491703          	lh	a4,68(s2)
    80004bd8:	478d                	li	a5,3
    80004bda:	0cf70463          	beq	a4,a5,80004ca2 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bde:	4789                	li	a5,2
    80004be0:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004be4:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004be8:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bec:	f4c42783          	lw	a5,-180(s0)
    80004bf0:	0017c713          	xori	a4,a5,1
    80004bf4:	8b05                	andi	a4,a4,1
    80004bf6:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bfa:	0037f713          	andi	a4,a5,3
    80004bfe:	00e03733          	snez	a4,a4
    80004c02:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c06:	4007f793          	andi	a5,a5,1024
    80004c0a:	c791                	beqz	a5,80004c16 <sys_open+0xd2>
    80004c0c:	04491703          	lh	a4,68(s2)
    80004c10:	4789                	li	a5,2
    80004c12:	08f70f63          	beq	a4,a5,80004cb0 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c16:	854a                	mv	a0,s2
    80004c18:	ffffe097          	auipc	ra,0xffffe
    80004c1c:	068080e7          	jalr	104(ra) # 80002c80 <iunlock>
  end_op();
    80004c20:	fffff097          	auipc	ra,0xfffff
    80004c24:	9f8080e7          	jalr	-1544(ra) # 80003618 <end_op>

  return fd;
}
    80004c28:	8526                	mv	a0,s1
    80004c2a:	70ea                	ld	ra,184(sp)
    80004c2c:	744a                	ld	s0,176(sp)
    80004c2e:	74aa                	ld	s1,168(sp)
    80004c30:	790a                	ld	s2,160(sp)
    80004c32:	69ea                	ld	s3,152(sp)
    80004c34:	6129                	addi	sp,sp,192
    80004c36:	8082                	ret
      end_op();
    80004c38:	fffff097          	auipc	ra,0xfffff
    80004c3c:	9e0080e7          	jalr	-1568(ra) # 80003618 <end_op>
      return -1;
    80004c40:	b7e5                	j	80004c28 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c42:	f5040513          	addi	a0,s0,-176
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	734080e7          	jalr	1844(ra) # 8000337a <namei>
    80004c4e:	892a                	mv	s2,a0
    80004c50:	c905                	beqz	a0,80004c80 <sys_open+0x13c>
    ilock(ip);
    80004c52:	ffffe097          	auipc	ra,0xffffe
    80004c56:	f6c080e7          	jalr	-148(ra) # 80002bbe <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c5a:	04491703          	lh	a4,68(s2)
    80004c5e:	4785                	li	a5,1
    80004c60:	f4f712e3          	bne	a4,a5,80004ba4 <sys_open+0x60>
    80004c64:	f4c42783          	lw	a5,-180(s0)
    80004c68:	dba1                	beqz	a5,80004bb8 <sys_open+0x74>
      iunlockput(ip);
    80004c6a:	854a                	mv	a0,s2
    80004c6c:	ffffe097          	auipc	ra,0xffffe
    80004c70:	1b4080e7          	jalr	436(ra) # 80002e20 <iunlockput>
      end_op();
    80004c74:	fffff097          	auipc	ra,0xfffff
    80004c78:	9a4080e7          	jalr	-1628(ra) # 80003618 <end_op>
      return -1;
    80004c7c:	54fd                	li	s1,-1
    80004c7e:	b76d                	j	80004c28 <sys_open+0xe4>
      end_op();
    80004c80:	fffff097          	auipc	ra,0xfffff
    80004c84:	998080e7          	jalr	-1640(ra) # 80003618 <end_op>
      return -1;
    80004c88:	54fd                	li	s1,-1
    80004c8a:	bf79                	j	80004c28 <sys_open+0xe4>
    iunlockput(ip);
    80004c8c:	854a                	mv	a0,s2
    80004c8e:	ffffe097          	auipc	ra,0xffffe
    80004c92:	192080e7          	jalr	402(ra) # 80002e20 <iunlockput>
    end_op();
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	982080e7          	jalr	-1662(ra) # 80003618 <end_op>
    return -1;
    80004c9e:	54fd                	li	s1,-1
    80004ca0:	b761                	j	80004c28 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004ca2:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ca6:	04691783          	lh	a5,70(s2)
    80004caa:	02f99223          	sh	a5,36(s3)
    80004cae:	bf2d                	j	80004be8 <sys_open+0xa4>
    itrunc(ip);
    80004cb0:	854a                	mv	a0,s2
    80004cb2:	ffffe097          	auipc	ra,0xffffe
    80004cb6:	01a080e7          	jalr	26(ra) # 80002ccc <itrunc>
    80004cba:	bfb1                	j	80004c16 <sys_open+0xd2>
      fileclose(f);
    80004cbc:	854e                	mv	a0,s3
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	da4080e7          	jalr	-604(ra) # 80003a62 <fileclose>
    iunlockput(ip);
    80004cc6:	854a                	mv	a0,s2
    80004cc8:	ffffe097          	auipc	ra,0xffffe
    80004ccc:	158080e7          	jalr	344(ra) # 80002e20 <iunlockput>
    end_op();
    80004cd0:	fffff097          	auipc	ra,0xfffff
    80004cd4:	948080e7          	jalr	-1720(ra) # 80003618 <end_op>
    return -1;
    80004cd8:	54fd                	li	s1,-1
    80004cda:	b7b9                	j	80004c28 <sys_open+0xe4>

0000000080004cdc <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cdc:	7175                	addi	sp,sp,-144
    80004cde:	e506                	sd	ra,136(sp)
    80004ce0:	e122                	sd	s0,128(sp)
    80004ce2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ce4:	fffff097          	auipc	ra,0xfffff
    80004ce8:	8b6080e7          	jalr	-1866(ra) # 8000359a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cec:	08000613          	li	a2,128
    80004cf0:	f7040593          	addi	a1,s0,-144
    80004cf4:	4501                	li	a0,0
    80004cf6:	ffffd097          	auipc	ra,0xffffd
    80004cfa:	2ca080e7          	jalr	714(ra) # 80001fc0 <argstr>
    80004cfe:	02054963          	bltz	a0,80004d30 <sys_mkdir+0x54>
    80004d02:	4681                	li	a3,0
    80004d04:	4601                	li	a2,0
    80004d06:	4585                	li	a1,1
    80004d08:	f7040513          	addi	a0,s0,-144
    80004d0c:	fffff097          	auipc	ra,0xfffff
    80004d10:	7fc080e7          	jalr	2044(ra) # 80004508 <create>
    80004d14:	cd11                	beqz	a0,80004d30 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d16:	ffffe097          	auipc	ra,0xffffe
    80004d1a:	10a080e7          	jalr	266(ra) # 80002e20 <iunlockput>
  end_op();
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	8fa080e7          	jalr	-1798(ra) # 80003618 <end_op>
  return 0;
    80004d26:	4501                	li	a0,0
}
    80004d28:	60aa                	ld	ra,136(sp)
    80004d2a:	640a                	ld	s0,128(sp)
    80004d2c:	6149                	addi	sp,sp,144
    80004d2e:	8082                	ret
    end_op();
    80004d30:	fffff097          	auipc	ra,0xfffff
    80004d34:	8e8080e7          	jalr	-1816(ra) # 80003618 <end_op>
    return -1;
    80004d38:	557d                	li	a0,-1
    80004d3a:	b7fd                	j	80004d28 <sys_mkdir+0x4c>

0000000080004d3c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d3c:	7135                	addi	sp,sp,-160
    80004d3e:	ed06                	sd	ra,152(sp)
    80004d40:	e922                	sd	s0,144(sp)
    80004d42:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d44:	fffff097          	auipc	ra,0xfffff
    80004d48:	856080e7          	jalr	-1962(ra) # 8000359a <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d4c:	08000613          	li	a2,128
    80004d50:	f7040593          	addi	a1,s0,-144
    80004d54:	4501                	li	a0,0
    80004d56:	ffffd097          	auipc	ra,0xffffd
    80004d5a:	26a080e7          	jalr	618(ra) # 80001fc0 <argstr>
    80004d5e:	04054a63          	bltz	a0,80004db2 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d62:	f6c40593          	addi	a1,s0,-148
    80004d66:	4505                	li	a0,1
    80004d68:	ffffd097          	auipc	ra,0xffffd
    80004d6c:	214080e7          	jalr	532(ra) # 80001f7c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d70:	04054163          	bltz	a0,80004db2 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d74:	f6840593          	addi	a1,s0,-152
    80004d78:	4509                	li	a0,2
    80004d7a:	ffffd097          	auipc	ra,0xffffd
    80004d7e:	202080e7          	jalr	514(ra) # 80001f7c <argint>
     argint(1, &major) < 0 ||
    80004d82:	02054863          	bltz	a0,80004db2 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d86:	f6841683          	lh	a3,-152(s0)
    80004d8a:	f6c41603          	lh	a2,-148(s0)
    80004d8e:	458d                	li	a1,3
    80004d90:	f7040513          	addi	a0,s0,-144
    80004d94:	fffff097          	auipc	ra,0xfffff
    80004d98:	774080e7          	jalr	1908(ra) # 80004508 <create>
     argint(2, &minor) < 0 ||
    80004d9c:	c919                	beqz	a0,80004db2 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d9e:	ffffe097          	auipc	ra,0xffffe
    80004da2:	082080e7          	jalr	130(ra) # 80002e20 <iunlockput>
  end_op();
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	872080e7          	jalr	-1934(ra) # 80003618 <end_op>
  return 0;
    80004dae:	4501                	li	a0,0
    80004db0:	a031                	j	80004dbc <sys_mknod+0x80>
    end_op();
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	866080e7          	jalr	-1946(ra) # 80003618 <end_op>
    return -1;
    80004dba:	557d                	li	a0,-1
}
    80004dbc:	60ea                	ld	ra,152(sp)
    80004dbe:	644a                	ld	s0,144(sp)
    80004dc0:	610d                	addi	sp,sp,160
    80004dc2:	8082                	ret

0000000080004dc4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dc4:	7135                	addi	sp,sp,-160
    80004dc6:	ed06                	sd	ra,152(sp)
    80004dc8:	e922                	sd	s0,144(sp)
    80004dca:	e526                	sd	s1,136(sp)
    80004dcc:	e14a                	sd	s2,128(sp)
    80004dce:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dd0:	ffffc097          	auipc	ra,0xffffc
    80004dd4:	098080e7          	jalr	152(ra) # 80000e68 <myproc>
    80004dd8:	892a                	mv	s2,a0
  
  begin_op();
    80004dda:	ffffe097          	auipc	ra,0xffffe
    80004dde:	7c0080e7          	jalr	1984(ra) # 8000359a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004de2:	08000613          	li	a2,128
    80004de6:	f6040593          	addi	a1,s0,-160
    80004dea:	4501                	li	a0,0
    80004dec:	ffffd097          	auipc	ra,0xffffd
    80004df0:	1d4080e7          	jalr	468(ra) # 80001fc0 <argstr>
    80004df4:	04054b63          	bltz	a0,80004e4a <sys_chdir+0x86>
    80004df8:	f6040513          	addi	a0,s0,-160
    80004dfc:	ffffe097          	auipc	ra,0xffffe
    80004e00:	57e080e7          	jalr	1406(ra) # 8000337a <namei>
    80004e04:	84aa                	mv	s1,a0
    80004e06:	c131                	beqz	a0,80004e4a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e08:	ffffe097          	auipc	ra,0xffffe
    80004e0c:	db6080e7          	jalr	-586(ra) # 80002bbe <ilock>
  if(ip->type != T_DIR){
    80004e10:	04449703          	lh	a4,68(s1)
    80004e14:	4785                	li	a5,1
    80004e16:	04f71063          	bne	a4,a5,80004e56 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e1a:	8526                	mv	a0,s1
    80004e1c:	ffffe097          	auipc	ra,0xffffe
    80004e20:	e64080e7          	jalr	-412(ra) # 80002c80 <iunlock>
  iput(p->cwd);
    80004e24:	15893503          	ld	a0,344(s2)
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	f50080e7          	jalr	-176(ra) # 80002d78 <iput>
  end_op();
    80004e30:	ffffe097          	auipc	ra,0xffffe
    80004e34:	7e8080e7          	jalr	2024(ra) # 80003618 <end_op>
  p->cwd = ip;
    80004e38:	14993c23          	sd	s1,344(s2)
  return 0;
    80004e3c:	4501                	li	a0,0
}
    80004e3e:	60ea                	ld	ra,152(sp)
    80004e40:	644a                	ld	s0,144(sp)
    80004e42:	64aa                	ld	s1,136(sp)
    80004e44:	690a                	ld	s2,128(sp)
    80004e46:	610d                	addi	sp,sp,160
    80004e48:	8082                	ret
    end_op();
    80004e4a:	ffffe097          	auipc	ra,0xffffe
    80004e4e:	7ce080e7          	jalr	1998(ra) # 80003618 <end_op>
    return -1;
    80004e52:	557d                	li	a0,-1
    80004e54:	b7ed                	j	80004e3e <sys_chdir+0x7a>
    iunlockput(ip);
    80004e56:	8526                	mv	a0,s1
    80004e58:	ffffe097          	auipc	ra,0xffffe
    80004e5c:	fc8080e7          	jalr	-56(ra) # 80002e20 <iunlockput>
    end_op();
    80004e60:	ffffe097          	auipc	ra,0xffffe
    80004e64:	7b8080e7          	jalr	1976(ra) # 80003618 <end_op>
    return -1;
    80004e68:	557d                	li	a0,-1
    80004e6a:	bfd1                	j	80004e3e <sys_chdir+0x7a>

0000000080004e6c <sys_exec>:

uint64
sys_exec(void)
{
    80004e6c:	7145                	addi	sp,sp,-464
    80004e6e:	e786                	sd	ra,456(sp)
    80004e70:	e3a2                	sd	s0,448(sp)
    80004e72:	ff26                	sd	s1,440(sp)
    80004e74:	fb4a                	sd	s2,432(sp)
    80004e76:	f74e                	sd	s3,424(sp)
    80004e78:	f352                	sd	s4,416(sp)
    80004e7a:	ef56                	sd	s5,408(sp)
    80004e7c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e7e:	08000613          	li	a2,128
    80004e82:	f4040593          	addi	a1,s0,-192
    80004e86:	4501                	li	a0,0
    80004e88:	ffffd097          	auipc	ra,0xffffd
    80004e8c:	138080e7          	jalr	312(ra) # 80001fc0 <argstr>
    return -1;
    80004e90:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e92:	0c054b63          	bltz	a0,80004f68 <sys_exec+0xfc>
    80004e96:	e3840593          	addi	a1,s0,-456
    80004e9a:	4505                	li	a0,1
    80004e9c:	ffffd097          	auipc	ra,0xffffd
    80004ea0:	102080e7          	jalr	258(ra) # 80001f9e <argaddr>
    80004ea4:	0c054263          	bltz	a0,80004f68 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004ea8:	10000613          	li	a2,256
    80004eac:	4581                	li	a1,0
    80004eae:	e4040513          	addi	a0,s0,-448
    80004eb2:	ffffb097          	auipc	ra,0xffffb
    80004eb6:	2ec080e7          	jalr	748(ra) # 8000019e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004eba:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ebe:	89a6                	mv	s3,s1
    80004ec0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ec2:	02000a13          	li	s4,32
    80004ec6:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004eca:	00391513          	slli	a0,s2,0x3
    80004ece:	e3040593          	addi	a1,s0,-464
    80004ed2:	e3843783          	ld	a5,-456(s0)
    80004ed6:	953e                	add	a0,a0,a5
    80004ed8:	ffffd097          	auipc	ra,0xffffd
    80004edc:	00a080e7          	jalr	10(ra) # 80001ee2 <fetchaddr>
    80004ee0:	02054a63          	bltz	a0,80004f14 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004ee4:	e3043783          	ld	a5,-464(s0)
    80004ee8:	c3b9                	beqz	a5,80004f2e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004eea:	ffffb097          	auipc	ra,0xffffb
    80004eee:	230080e7          	jalr	560(ra) # 8000011a <kalloc>
    80004ef2:	85aa                	mv	a1,a0
    80004ef4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ef8:	cd11                	beqz	a0,80004f14 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004efa:	6605                	lui	a2,0x1
    80004efc:	e3043503          	ld	a0,-464(s0)
    80004f00:	ffffd097          	auipc	ra,0xffffd
    80004f04:	034080e7          	jalr	52(ra) # 80001f34 <fetchstr>
    80004f08:	00054663          	bltz	a0,80004f14 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f0c:	0905                	addi	s2,s2,1
    80004f0e:	09a1                	addi	s3,s3,8
    80004f10:	fb491be3          	bne	s2,s4,80004ec6 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f14:	f4040913          	addi	s2,s0,-192
    80004f18:	6088                	ld	a0,0(s1)
    80004f1a:	c531                	beqz	a0,80004f66 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f1c:	ffffb097          	auipc	ra,0xffffb
    80004f20:	100080e7          	jalr	256(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f24:	04a1                	addi	s1,s1,8
    80004f26:	ff2499e3          	bne	s1,s2,80004f18 <sys_exec+0xac>
  return -1;
    80004f2a:	597d                	li	s2,-1
    80004f2c:	a835                	j	80004f68 <sys_exec+0xfc>
      argv[i] = 0;
    80004f2e:	0a8e                	slli	s5,s5,0x3
    80004f30:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    80004f34:	00878ab3          	add	s5,a5,s0
    80004f38:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f3c:	e4040593          	addi	a1,s0,-448
    80004f40:	f4040513          	addi	a0,s0,-192
    80004f44:	fffff097          	auipc	ra,0xfffff
    80004f48:	172080e7          	jalr	370(ra) # 800040b6 <exec>
    80004f4c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f4e:	f4040993          	addi	s3,s0,-192
    80004f52:	6088                	ld	a0,0(s1)
    80004f54:	c911                	beqz	a0,80004f68 <sys_exec+0xfc>
    kfree(argv[i]);
    80004f56:	ffffb097          	auipc	ra,0xffffb
    80004f5a:	0c6080e7          	jalr	198(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f5e:	04a1                	addi	s1,s1,8
    80004f60:	ff3499e3          	bne	s1,s3,80004f52 <sys_exec+0xe6>
    80004f64:	a011                	j	80004f68 <sys_exec+0xfc>
  return -1;
    80004f66:	597d                	li	s2,-1
}
    80004f68:	854a                	mv	a0,s2
    80004f6a:	60be                	ld	ra,456(sp)
    80004f6c:	641e                	ld	s0,448(sp)
    80004f6e:	74fa                	ld	s1,440(sp)
    80004f70:	795a                	ld	s2,432(sp)
    80004f72:	79ba                	ld	s3,424(sp)
    80004f74:	7a1a                	ld	s4,416(sp)
    80004f76:	6afa                	ld	s5,408(sp)
    80004f78:	6179                	addi	sp,sp,464
    80004f7a:	8082                	ret

0000000080004f7c <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f7c:	7139                	addi	sp,sp,-64
    80004f7e:	fc06                	sd	ra,56(sp)
    80004f80:	f822                	sd	s0,48(sp)
    80004f82:	f426                	sd	s1,40(sp)
    80004f84:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f86:	ffffc097          	auipc	ra,0xffffc
    80004f8a:	ee2080e7          	jalr	-286(ra) # 80000e68 <myproc>
    80004f8e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f90:	fd840593          	addi	a1,s0,-40
    80004f94:	4501                	li	a0,0
    80004f96:	ffffd097          	auipc	ra,0xffffd
    80004f9a:	008080e7          	jalr	8(ra) # 80001f9e <argaddr>
    return -1;
    80004f9e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fa0:	0e054063          	bltz	a0,80005080 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fa4:	fc840593          	addi	a1,s0,-56
    80004fa8:	fd040513          	addi	a0,s0,-48
    80004fac:	fffff097          	auipc	ra,0xfffff
    80004fb0:	de6080e7          	jalr	-538(ra) # 80003d92 <pipealloc>
    return -1;
    80004fb4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fb6:	0c054563          	bltz	a0,80005080 <sys_pipe+0x104>
  fd0 = -1;
    80004fba:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fbe:	fd043503          	ld	a0,-48(s0)
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	504080e7          	jalr	1284(ra) # 800044c6 <fdalloc>
    80004fca:	fca42223          	sw	a0,-60(s0)
    80004fce:	08054c63          	bltz	a0,80005066 <sys_pipe+0xea>
    80004fd2:	fc843503          	ld	a0,-56(s0)
    80004fd6:	fffff097          	auipc	ra,0xfffff
    80004fda:	4f0080e7          	jalr	1264(ra) # 800044c6 <fdalloc>
    80004fde:	fca42023          	sw	a0,-64(s0)
    80004fe2:	06054963          	bltz	a0,80005054 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fe6:	4691                	li	a3,4
    80004fe8:	fc440613          	addi	a2,s0,-60
    80004fec:	fd843583          	ld	a1,-40(s0)
    80004ff0:	6ca8                	ld	a0,88(s1)
    80004ff2:	ffffc097          	auipc	ra,0xffffc
    80004ff6:	b3a080e7          	jalr	-1222(ra) # 80000b2c <copyout>
    80004ffa:	02054063          	bltz	a0,8000501a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004ffe:	4691                	li	a3,4
    80005000:	fc040613          	addi	a2,s0,-64
    80005004:	fd843583          	ld	a1,-40(s0)
    80005008:	0591                	addi	a1,a1,4
    8000500a:	6ca8                	ld	a0,88(s1)
    8000500c:	ffffc097          	auipc	ra,0xffffc
    80005010:	b20080e7          	jalr	-1248(ra) # 80000b2c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005014:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005016:	06055563          	bgez	a0,80005080 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000501a:	fc442783          	lw	a5,-60(s0)
    8000501e:	07e9                	addi	a5,a5,26
    80005020:	078e                	slli	a5,a5,0x3
    80005022:	97a6                	add	a5,a5,s1
    80005024:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005028:	fc042783          	lw	a5,-64(s0)
    8000502c:	07e9                	addi	a5,a5,26
    8000502e:	078e                	slli	a5,a5,0x3
    80005030:	00f48533          	add	a0,s1,a5
    80005034:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005038:	fd043503          	ld	a0,-48(s0)
    8000503c:	fffff097          	auipc	ra,0xfffff
    80005040:	a26080e7          	jalr	-1498(ra) # 80003a62 <fileclose>
    fileclose(wf);
    80005044:	fc843503          	ld	a0,-56(s0)
    80005048:	fffff097          	auipc	ra,0xfffff
    8000504c:	a1a080e7          	jalr	-1510(ra) # 80003a62 <fileclose>
    return -1;
    80005050:	57fd                	li	a5,-1
    80005052:	a03d                	j	80005080 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005054:	fc442783          	lw	a5,-60(s0)
    80005058:	0007c763          	bltz	a5,80005066 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000505c:	07e9                	addi	a5,a5,26
    8000505e:	078e                	slli	a5,a5,0x3
    80005060:	97a6                	add	a5,a5,s1
    80005062:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005066:	fd043503          	ld	a0,-48(s0)
    8000506a:	fffff097          	auipc	ra,0xfffff
    8000506e:	9f8080e7          	jalr	-1544(ra) # 80003a62 <fileclose>
    fileclose(wf);
    80005072:	fc843503          	ld	a0,-56(s0)
    80005076:	fffff097          	auipc	ra,0xfffff
    8000507a:	9ec080e7          	jalr	-1556(ra) # 80003a62 <fileclose>
    return -1;
    8000507e:	57fd                	li	a5,-1
}
    80005080:	853e                	mv	a0,a5
    80005082:	70e2                	ld	ra,56(sp)
    80005084:	7442                	ld	s0,48(sp)
    80005086:	74a2                	ld	s1,40(sp)
    80005088:	6121                	addi	sp,sp,64
    8000508a:	8082                	ret
    8000508c:	0000                	unimp
	...

0000000080005090 <kernelvec>:
    80005090:	7111                	addi	sp,sp,-256
    80005092:	e006                	sd	ra,0(sp)
    80005094:	e40a                	sd	sp,8(sp)
    80005096:	e80e                	sd	gp,16(sp)
    80005098:	ec12                	sd	tp,24(sp)
    8000509a:	f016                	sd	t0,32(sp)
    8000509c:	f41a                	sd	t1,40(sp)
    8000509e:	f81e                	sd	t2,48(sp)
    800050a0:	fc22                	sd	s0,56(sp)
    800050a2:	e0a6                	sd	s1,64(sp)
    800050a4:	e4aa                	sd	a0,72(sp)
    800050a6:	e8ae                	sd	a1,80(sp)
    800050a8:	ecb2                	sd	a2,88(sp)
    800050aa:	f0b6                	sd	a3,96(sp)
    800050ac:	f4ba                	sd	a4,104(sp)
    800050ae:	f8be                	sd	a5,112(sp)
    800050b0:	fcc2                	sd	a6,120(sp)
    800050b2:	e146                	sd	a7,128(sp)
    800050b4:	e54a                	sd	s2,136(sp)
    800050b6:	e94e                	sd	s3,144(sp)
    800050b8:	ed52                	sd	s4,152(sp)
    800050ba:	f156                	sd	s5,160(sp)
    800050bc:	f55a                	sd	s6,168(sp)
    800050be:	f95e                	sd	s7,176(sp)
    800050c0:	fd62                	sd	s8,184(sp)
    800050c2:	e1e6                	sd	s9,192(sp)
    800050c4:	e5ea                	sd	s10,200(sp)
    800050c6:	e9ee                	sd	s11,208(sp)
    800050c8:	edf2                	sd	t3,216(sp)
    800050ca:	f1f6                	sd	t4,224(sp)
    800050cc:	f5fa                	sd	t5,232(sp)
    800050ce:	f9fe                	sd	t6,240(sp)
    800050d0:	cdffc0ef          	jal	ra,80001dae <kerneltrap>
    800050d4:	6082                	ld	ra,0(sp)
    800050d6:	6122                	ld	sp,8(sp)
    800050d8:	61c2                	ld	gp,16(sp)
    800050da:	7282                	ld	t0,32(sp)
    800050dc:	7322                	ld	t1,40(sp)
    800050de:	73c2                	ld	t2,48(sp)
    800050e0:	7462                	ld	s0,56(sp)
    800050e2:	6486                	ld	s1,64(sp)
    800050e4:	6526                	ld	a0,72(sp)
    800050e6:	65c6                	ld	a1,80(sp)
    800050e8:	6666                	ld	a2,88(sp)
    800050ea:	7686                	ld	a3,96(sp)
    800050ec:	7726                	ld	a4,104(sp)
    800050ee:	77c6                	ld	a5,112(sp)
    800050f0:	7866                	ld	a6,120(sp)
    800050f2:	688a                	ld	a7,128(sp)
    800050f4:	692a                	ld	s2,136(sp)
    800050f6:	69ca                	ld	s3,144(sp)
    800050f8:	6a6a                	ld	s4,152(sp)
    800050fa:	7a8a                	ld	s5,160(sp)
    800050fc:	7b2a                	ld	s6,168(sp)
    800050fe:	7bca                	ld	s7,176(sp)
    80005100:	7c6a                	ld	s8,184(sp)
    80005102:	6c8e                	ld	s9,192(sp)
    80005104:	6d2e                	ld	s10,200(sp)
    80005106:	6dce                	ld	s11,208(sp)
    80005108:	6e6e                	ld	t3,216(sp)
    8000510a:	7e8e                	ld	t4,224(sp)
    8000510c:	7f2e                	ld	t5,232(sp)
    8000510e:	7fce                	ld	t6,240(sp)
    80005110:	6111                	addi	sp,sp,256
    80005112:	10200073          	sret
    80005116:	00000013          	nop
    8000511a:	00000013          	nop
    8000511e:	0001                	nop

0000000080005120 <timervec>:
    80005120:	34051573          	csrrw	a0,mscratch,a0
    80005124:	e10c                	sd	a1,0(a0)
    80005126:	e510                	sd	a2,8(a0)
    80005128:	e914                	sd	a3,16(a0)
    8000512a:	6d0c                	ld	a1,24(a0)
    8000512c:	7110                	ld	a2,32(a0)
    8000512e:	6194                	ld	a3,0(a1)
    80005130:	96b2                	add	a3,a3,a2
    80005132:	e194                	sd	a3,0(a1)
    80005134:	4589                	li	a1,2
    80005136:	14459073          	csrw	sip,a1
    8000513a:	6914                	ld	a3,16(a0)
    8000513c:	6510                	ld	a2,8(a0)
    8000513e:	610c                	ld	a1,0(a0)
    80005140:	34051573          	csrrw	a0,mscratch,a0
    80005144:	30200073          	mret
	...

000000008000514a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000514a:	1141                	addi	sp,sp,-16
    8000514c:	e422                	sd	s0,8(sp)
    8000514e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005150:	0c0007b7          	lui	a5,0xc000
    80005154:	4705                	li	a4,1
    80005156:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005158:	c3d8                	sw	a4,4(a5)
}
    8000515a:	6422                	ld	s0,8(sp)
    8000515c:	0141                	addi	sp,sp,16
    8000515e:	8082                	ret

0000000080005160 <plicinithart>:

void
plicinithart(void)
{
    80005160:	1141                	addi	sp,sp,-16
    80005162:	e406                	sd	ra,8(sp)
    80005164:	e022                	sd	s0,0(sp)
    80005166:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	cd4080e7          	jalr	-812(ra) # 80000e3c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005170:	0085171b          	slliw	a4,a0,0x8
    80005174:	0c0027b7          	lui	a5,0xc002
    80005178:	97ba                	add	a5,a5,a4
    8000517a:	40200713          	li	a4,1026
    8000517e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005182:	00d5151b          	slliw	a0,a0,0xd
    80005186:	0c2017b7          	lui	a5,0xc201
    8000518a:	97aa                	add	a5,a5,a0
    8000518c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005190:	60a2                	ld	ra,8(sp)
    80005192:	6402                	ld	s0,0(sp)
    80005194:	0141                	addi	sp,sp,16
    80005196:	8082                	ret

0000000080005198 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005198:	1141                	addi	sp,sp,-16
    8000519a:	e406                	sd	ra,8(sp)
    8000519c:	e022                	sd	s0,0(sp)
    8000519e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051a0:	ffffc097          	auipc	ra,0xffffc
    800051a4:	c9c080e7          	jalr	-868(ra) # 80000e3c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051a8:	00d5151b          	slliw	a0,a0,0xd
    800051ac:	0c2017b7          	lui	a5,0xc201
    800051b0:	97aa                	add	a5,a5,a0
  return irq;
}
    800051b2:	43c8                	lw	a0,4(a5)
    800051b4:	60a2                	ld	ra,8(sp)
    800051b6:	6402                	ld	s0,0(sp)
    800051b8:	0141                	addi	sp,sp,16
    800051ba:	8082                	ret

00000000800051bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051bc:	1101                	addi	sp,sp,-32
    800051be:	ec06                	sd	ra,24(sp)
    800051c0:	e822                	sd	s0,16(sp)
    800051c2:	e426                	sd	s1,8(sp)
    800051c4:	1000                	addi	s0,sp,32
    800051c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051c8:	ffffc097          	auipc	ra,0xffffc
    800051cc:	c74080e7          	jalr	-908(ra) # 80000e3c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051d0:	00d5151b          	slliw	a0,a0,0xd
    800051d4:	0c2017b7          	lui	a5,0xc201
    800051d8:	97aa                	add	a5,a5,a0
    800051da:	c3c4                	sw	s1,4(a5)
}
    800051dc:	60e2                	ld	ra,24(sp)
    800051de:	6442                	ld	s0,16(sp)
    800051e0:	64a2                	ld	s1,8(sp)
    800051e2:	6105                	addi	sp,sp,32
    800051e4:	8082                	ret

00000000800051e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051e6:	1141                	addi	sp,sp,-16
    800051e8:	e406                	sd	ra,8(sp)
    800051ea:	e022                	sd	s0,0(sp)
    800051ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051ee:	479d                	li	a5,7
    800051f0:	06a7c863          	blt	a5,a0,80005260 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800051f4:	00016717          	auipc	a4,0x16
    800051f8:	e0c70713          	addi	a4,a4,-500 # 8001b000 <disk>
    800051fc:	972a                	add	a4,a4,a0
    800051fe:	6789                	lui	a5,0x2
    80005200:	97ba                	add	a5,a5,a4
    80005202:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005206:	e7ad                	bnez	a5,80005270 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005208:	00451793          	slli	a5,a0,0x4
    8000520c:	00018717          	auipc	a4,0x18
    80005210:	df470713          	addi	a4,a4,-524 # 8001d000 <disk+0x2000>
    80005214:	6314                	ld	a3,0(a4)
    80005216:	96be                	add	a3,a3,a5
    80005218:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000521c:	6314                	ld	a3,0(a4)
    8000521e:	96be                	add	a3,a3,a5
    80005220:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005224:	6314                	ld	a3,0(a4)
    80005226:	96be                	add	a3,a3,a5
    80005228:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000522c:	6318                	ld	a4,0(a4)
    8000522e:	97ba                	add	a5,a5,a4
    80005230:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005234:	00016717          	auipc	a4,0x16
    80005238:	dcc70713          	addi	a4,a4,-564 # 8001b000 <disk>
    8000523c:	972a                	add	a4,a4,a0
    8000523e:	6789                	lui	a5,0x2
    80005240:	97ba                	add	a5,a5,a4
    80005242:	4705                	li	a4,1
    80005244:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005248:	00018517          	auipc	a0,0x18
    8000524c:	dd050513          	addi	a0,a0,-560 # 8001d018 <disk+0x2018>
    80005250:	ffffc097          	auipc	ra,0xffffc
    80005254:	470080e7          	jalr	1136(ra) # 800016c0 <wakeup>
}
    80005258:	60a2                	ld	ra,8(sp)
    8000525a:	6402                	ld	s0,0(sp)
    8000525c:	0141                	addi	sp,sp,16
    8000525e:	8082                	ret
    panic("free_desc 1");
    80005260:	00003517          	auipc	a0,0x3
    80005264:	60850513          	addi	a0,a0,1544 # 80008868 <sysname+0x320>
    80005268:	00001097          	auipc	ra,0x1
    8000526c:	9c8080e7          	jalr	-1592(ra) # 80005c30 <panic>
    panic("free_desc 2");
    80005270:	00003517          	auipc	a0,0x3
    80005274:	60850513          	addi	a0,a0,1544 # 80008878 <sysname+0x330>
    80005278:	00001097          	auipc	ra,0x1
    8000527c:	9b8080e7          	jalr	-1608(ra) # 80005c30 <panic>

0000000080005280 <virtio_disk_init>:
{
    80005280:	1101                	addi	sp,sp,-32
    80005282:	ec06                	sd	ra,24(sp)
    80005284:	e822                	sd	s0,16(sp)
    80005286:	e426                	sd	s1,8(sp)
    80005288:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000528a:	00003597          	auipc	a1,0x3
    8000528e:	5fe58593          	addi	a1,a1,1534 # 80008888 <sysname+0x340>
    80005292:	00018517          	auipc	a0,0x18
    80005296:	e9650513          	addi	a0,a0,-362 # 8001d128 <disk+0x2128>
    8000529a:	00001097          	auipc	ra,0x1
    8000529e:	e3e080e7          	jalr	-450(ra) # 800060d8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052a2:	100017b7          	lui	a5,0x10001
    800052a6:	4398                	lw	a4,0(a5)
    800052a8:	2701                	sext.w	a4,a4
    800052aa:	747277b7          	lui	a5,0x74727
    800052ae:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052b2:	0ef71063          	bne	a4,a5,80005392 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052b6:	100017b7          	lui	a5,0x10001
    800052ba:	43dc                	lw	a5,4(a5)
    800052bc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052be:	4705                	li	a4,1
    800052c0:	0ce79963          	bne	a5,a4,80005392 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052c4:	100017b7          	lui	a5,0x10001
    800052c8:	479c                	lw	a5,8(a5)
    800052ca:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052cc:	4709                	li	a4,2
    800052ce:	0ce79263          	bne	a5,a4,80005392 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052d2:	100017b7          	lui	a5,0x10001
    800052d6:	47d8                	lw	a4,12(a5)
    800052d8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052da:	554d47b7          	lui	a5,0x554d4
    800052de:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052e2:	0af71863          	bne	a4,a5,80005392 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e6:	100017b7          	lui	a5,0x10001
    800052ea:	4705                	li	a4,1
    800052ec:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ee:	470d                	li	a4,3
    800052f0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052f2:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052f4:	c7ffe6b7          	lui	a3,0xc7ffe
    800052f8:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052fc:	8f75                	and	a4,a4,a3
    800052fe:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005300:	472d                	li	a4,11
    80005302:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005304:	473d                	li	a4,15
    80005306:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005308:	6705                	lui	a4,0x1
    8000530a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000530c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005310:	5bdc                	lw	a5,52(a5)
    80005312:	2781                	sext.w	a5,a5
  if(max == 0)
    80005314:	c7d9                	beqz	a5,800053a2 <virtio_disk_init+0x122>
  if(max < NUM)
    80005316:	471d                	li	a4,7
    80005318:	08f77d63          	bgeu	a4,a5,800053b2 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000531c:	100014b7          	lui	s1,0x10001
    80005320:	47a1                	li	a5,8
    80005322:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005324:	6609                	lui	a2,0x2
    80005326:	4581                	li	a1,0
    80005328:	00016517          	auipc	a0,0x16
    8000532c:	cd850513          	addi	a0,a0,-808 # 8001b000 <disk>
    80005330:	ffffb097          	auipc	ra,0xffffb
    80005334:	e6e080e7          	jalr	-402(ra) # 8000019e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005338:	00016717          	auipc	a4,0x16
    8000533c:	cc870713          	addi	a4,a4,-824 # 8001b000 <disk>
    80005340:	00c75793          	srli	a5,a4,0xc
    80005344:	2781                	sext.w	a5,a5
    80005346:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005348:	00018797          	auipc	a5,0x18
    8000534c:	cb878793          	addi	a5,a5,-840 # 8001d000 <disk+0x2000>
    80005350:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005352:	00016717          	auipc	a4,0x16
    80005356:	d2e70713          	addi	a4,a4,-722 # 8001b080 <disk+0x80>
    8000535a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000535c:	00017717          	auipc	a4,0x17
    80005360:	ca470713          	addi	a4,a4,-860 # 8001c000 <disk+0x1000>
    80005364:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005366:	4705                	li	a4,1
    80005368:	00e78c23          	sb	a4,24(a5)
    8000536c:	00e78ca3          	sb	a4,25(a5)
    80005370:	00e78d23          	sb	a4,26(a5)
    80005374:	00e78da3          	sb	a4,27(a5)
    80005378:	00e78e23          	sb	a4,28(a5)
    8000537c:	00e78ea3          	sb	a4,29(a5)
    80005380:	00e78f23          	sb	a4,30(a5)
    80005384:	00e78fa3          	sb	a4,31(a5)
}
    80005388:	60e2                	ld	ra,24(sp)
    8000538a:	6442                	ld	s0,16(sp)
    8000538c:	64a2                	ld	s1,8(sp)
    8000538e:	6105                	addi	sp,sp,32
    80005390:	8082                	ret
    panic("could not find virtio disk");
    80005392:	00003517          	auipc	a0,0x3
    80005396:	50650513          	addi	a0,a0,1286 # 80008898 <sysname+0x350>
    8000539a:	00001097          	auipc	ra,0x1
    8000539e:	896080e7          	jalr	-1898(ra) # 80005c30 <panic>
    panic("virtio disk has no queue 0");
    800053a2:	00003517          	auipc	a0,0x3
    800053a6:	51650513          	addi	a0,a0,1302 # 800088b8 <sysname+0x370>
    800053aa:	00001097          	auipc	ra,0x1
    800053ae:	886080e7          	jalr	-1914(ra) # 80005c30 <panic>
    panic("virtio disk max queue too short");
    800053b2:	00003517          	auipc	a0,0x3
    800053b6:	52650513          	addi	a0,a0,1318 # 800088d8 <sysname+0x390>
    800053ba:	00001097          	auipc	ra,0x1
    800053be:	876080e7          	jalr	-1930(ra) # 80005c30 <panic>

00000000800053c2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053c2:	7119                	addi	sp,sp,-128
    800053c4:	fc86                	sd	ra,120(sp)
    800053c6:	f8a2                	sd	s0,112(sp)
    800053c8:	f4a6                	sd	s1,104(sp)
    800053ca:	f0ca                	sd	s2,96(sp)
    800053cc:	ecce                	sd	s3,88(sp)
    800053ce:	e8d2                	sd	s4,80(sp)
    800053d0:	e4d6                	sd	s5,72(sp)
    800053d2:	e0da                	sd	s6,64(sp)
    800053d4:	fc5e                	sd	s7,56(sp)
    800053d6:	f862                	sd	s8,48(sp)
    800053d8:	f466                	sd	s9,40(sp)
    800053da:	f06a                	sd	s10,32(sp)
    800053dc:	ec6e                	sd	s11,24(sp)
    800053de:	0100                	addi	s0,sp,128
    800053e0:	8aaa                	mv	s5,a0
    800053e2:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053e4:	00c52c83          	lw	s9,12(a0)
    800053e8:	001c9c9b          	slliw	s9,s9,0x1
    800053ec:	1c82                	slli	s9,s9,0x20
    800053ee:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053f2:	00018517          	auipc	a0,0x18
    800053f6:	d3650513          	addi	a0,a0,-714 # 8001d128 <disk+0x2128>
    800053fa:	00001097          	auipc	ra,0x1
    800053fe:	d6e080e7          	jalr	-658(ra) # 80006168 <acquire>
  for(int i = 0; i < 3; i++){
    80005402:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005404:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005406:	00016c17          	auipc	s8,0x16
    8000540a:	bfac0c13          	addi	s8,s8,-1030 # 8001b000 <disk>
    8000540e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005410:	4b0d                	li	s6,3
    80005412:	a0ad                	j	8000547c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005414:	00fc0733          	add	a4,s8,a5
    80005418:	975e                	add	a4,a4,s7
    8000541a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000541e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005420:	0207c563          	bltz	a5,8000544a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005424:	2905                	addiw	s2,s2,1
    80005426:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005428:	19690c63          	beq	s2,s6,800055c0 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000542c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000542e:	00018717          	auipc	a4,0x18
    80005432:	bea70713          	addi	a4,a4,-1046 # 8001d018 <disk+0x2018>
    80005436:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005438:	00074683          	lbu	a3,0(a4)
    8000543c:	fee1                	bnez	a3,80005414 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000543e:	2785                	addiw	a5,a5,1
    80005440:	0705                	addi	a4,a4,1
    80005442:	fe979be3          	bne	a5,s1,80005438 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005446:	57fd                	li	a5,-1
    80005448:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000544a:	01205d63          	blez	s2,80005464 <virtio_disk_rw+0xa2>
    8000544e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005450:	000a2503          	lw	a0,0(s4)
    80005454:	00000097          	auipc	ra,0x0
    80005458:	d92080e7          	jalr	-622(ra) # 800051e6 <free_desc>
      for(int j = 0; j < i; j++)
    8000545c:	2d85                	addiw	s11,s11,1
    8000545e:	0a11                	addi	s4,s4,4
    80005460:	ff2d98e3          	bne	s11,s2,80005450 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005464:	00018597          	auipc	a1,0x18
    80005468:	cc458593          	addi	a1,a1,-828 # 8001d128 <disk+0x2128>
    8000546c:	00018517          	auipc	a0,0x18
    80005470:	bac50513          	addi	a0,a0,-1108 # 8001d018 <disk+0x2018>
    80005474:	ffffc097          	auipc	ra,0xffffc
    80005478:	0c0080e7          	jalr	192(ra) # 80001534 <sleep>
  for(int i = 0; i < 3; i++){
    8000547c:	f8040a13          	addi	s4,s0,-128
{
    80005480:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005482:	894e                	mv	s2,s3
    80005484:	b765                	j	8000542c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005486:	00018697          	auipc	a3,0x18
    8000548a:	b7a6b683          	ld	a3,-1158(a3) # 8001d000 <disk+0x2000>
    8000548e:	96ba                	add	a3,a3,a4
    80005490:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005494:	00016817          	auipc	a6,0x16
    80005498:	b6c80813          	addi	a6,a6,-1172 # 8001b000 <disk>
    8000549c:	00018697          	auipc	a3,0x18
    800054a0:	b6468693          	addi	a3,a3,-1180 # 8001d000 <disk+0x2000>
    800054a4:	6290                	ld	a2,0(a3)
    800054a6:	963a                	add	a2,a2,a4
    800054a8:	00c65583          	lhu	a1,12(a2)
    800054ac:	0015e593          	ori	a1,a1,1
    800054b0:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800054b4:	f8842603          	lw	a2,-120(s0)
    800054b8:	628c                	ld	a1,0(a3)
    800054ba:	972e                	add	a4,a4,a1
    800054bc:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054c0:	20050593          	addi	a1,a0,512
    800054c4:	0592                	slli	a1,a1,0x4
    800054c6:	95c2                	add	a1,a1,a6
    800054c8:	577d                	li	a4,-1
    800054ca:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054ce:	00461713          	slli	a4,a2,0x4
    800054d2:	6290                	ld	a2,0(a3)
    800054d4:	963a                	add	a2,a2,a4
    800054d6:	03078793          	addi	a5,a5,48
    800054da:	97c2                	add	a5,a5,a6
    800054dc:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800054de:	629c                	ld	a5,0(a3)
    800054e0:	97ba                	add	a5,a5,a4
    800054e2:	4605                	li	a2,1
    800054e4:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054e6:	629c                	ld	a5,0(a3)
    800054e8:	97ba                	add	a5,a5,a4
    800054ea:	4809                	li	a6,2
    800054ec:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800054f0:	629c                	ld	a5,0(a3)
    800054f2:	97ba                	add	a5,a5,a4
    800054f4:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054f8:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800054fc:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005500:	6698                	ld	a4,8(a3)
    80005502:	00275783          	lhu	a5,2(a4)
    80005506:	8b9d                	andi	a5,a5,7
    80005508:	0786                	slli	a5,a5,0x1
    8000550a:	973e                	add	a4,a4,a5
    8000550c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005510:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005514:	6698                	ld	a4,8(a3)
    80005516:	00275783          	lhu	a5,2(a4)
    8000551a:	2785                	addiw	a5,a5,1
    8000551c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005520:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005524:	100017b7          	lui	a5,0x10001
    80005528:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000552c:	004aa783          	lw	a5,4(s5)
    80005530:	02c79163          	bne	a5,a2,80005552 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005534:	00018917          	auipc	s2,0x18
    80005538:	bf490913          	addi	s2,s2,-1036 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    8000553c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000553e:	85ca                	mv	a1,s2
    80005540:	8556                	mv	a0,s5
    80005542:	ffffc097          	auipc	ra,0xffffc
    80005546:	ff2080e7          	jalr	-14(ra) # 80001534 <sleep>
  while(b->disk == 1) {
    8000554a:	004aa783          	lw	a5,4(s5)
    8000554e:	fe9788e3          	beq	a5,s1,8000553e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005552:	f8042903          	lw	s2,-128(s0)
    80005556:	20090713          	addi	a4,s2,512
    8000555a:	0712                	slli	a4,a4,0x4
    8000555c:	00016797          	auipc	a5,0x16
    80005560:	aa478793          	addi	a5,a5,-1372 # 8001b000 <disk>
    80005564:	97ba                	add	a5,a5,a4
    80005566:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000556a:	00018997          	auipc	s3,0x18
    8000556e:	a9698993          	addi	s3,s3,-1386 # 8001d000 <disk+0x2000>
    80005572:	00491713          	slli	a4,s2,0x4
    80005576:	0009b783          	ld	a5,0(s3)
    8000557a:	97ba                	add	a5,a5,a4
    8000557c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005580:	854a                	mv	a0,s2
    80005582:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005586:	00000097          	auipc	ra,0x0
    8000558a:	c60080e7          	jalr	-928(ra) # 800051e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000558e:	8885                	andi	s1,s1,1
    80005590:	f0ed                	bnez	s1,80005572 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005592:	00018517          	auipc	a0,0x18
    80005596:	b9650513          	addi	a0,a0,-1130 # 8001d128 <disk+0x2128>
    8000559a:	00001097          	auipc	ra,0x1
    8000559e:	c82080e7          	jalr	-894(ra) # 8000621c <release>
}
    800055a2:	70e6                	ld	ra,120(sp)
    800055a4:	7446                	ld	s0,112(sp)
    800055a6:	74a6                	ld	s1,104(sp)
    800055a8:	7906                	ld	s2,96(sp)
    800055aa:	69e6                	ld	s3,88(sp)
    800055ac:	6a46                	ld	s4,80(sp)
    800055ae:	6aa6                	ld	s5,72(sp)
    800055b0:	6b06                	ld	s6,64(sp)
    800055b2:	7be2                	ld	s7,56(sp)
    800055b4:	7c42                	ld	s8,48(sp)
    800055b6:	7ca2                	ld	s9,40(sp)
    800055b8:	7d02                	ld	s10,32(sp)
    800055ba:	6de2                	ld	s11,24(sp)
    800055bc:	6109                	addi	sp,sp,128
    800055be:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055c0:	f8042503          	lw	a0,-128(s0)
    800055c4:	20050793          	addi	a5,a0,512
    800055c8:	0792                	slli	a5,a5,0x4
  if(write)
    800055ca:	00016817          	auipc	a6,0x16
    800055ce:	a3680813          	addi	a6,a6,-1482 # 8001b000 <disk>
    800055d2:	00f80733          	add	a4,a6,a5
    800055d6:	01a036b3          	snez	a3,s10
    800055da:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800055de:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055e2:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055e6:	7679                	lui	a2,0xffffe
    800055e8:	963e                	add	a2,a2,a5
    800055ea:	00018697          	auipc	a3,0x18
    800055ee:	a1668693          	addi	a3,a3,-1514 # 8001d000 <disk+0x2000>
    800055f2:	6298                	ld	a4,0(a3)
    800055f4:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055f6:	0a878593          	addi	a1,a5,168
    800055fa:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055fc:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055fe:	6298                	ld	a4,0(a3)
    80005600:	9732                	add	a4,a4,a2
    80005602:	45c1                	li	a1,16
    80005604:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005606:	6298                	ld	a4,0(a3)
    80005608:	9732                	add	a4,a4,a2
    8000560a:	4585                	li	a1,1
    8000560c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005610:	f8442703          	lw	a4,-124(s0)
    80005614:	628c                	ld	a1,0(a3)
    80005616:	962e                	add	a2,a2,a1
    80005618:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000561c:	0712                	slli	a4,a4,0x4
    8000561e:	6290                	ld	a2,0(a3)
    80005620:	963a                	add	a2,a2,a4
    80005622:	058a8593          	addi	a1,s5,88
    80005626:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005628:	6294                	ld	a3,0(a3)
    8000562a:	96ba                	add	a3,a3,a4
    8000562c:	40000613          	li	a2,1024
    80005630:	c690                	sw	a2,8(a3)
  if(write)
    80005632:	e40d1ae3          	bnez	s10,80005486 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005636:	00018697          	auipc	a3,0x18
    8000563a:	9ca6b683          	ld	a3,-1590(a3) # 8001d000 <disk+0x2000>
    8000563e:	96ba                	add	a3,a3,a4
    80005640:	4609                	li	a2,2
    80005642:	00c69623          	sh	a2,12(a3)
    80005646:	b5b9                	j	80005494 <virtio_disk_rw+0xd2>

0000000080005648 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005648:	1101                	addi	sp,sp,-32
    8000564a:	ec06                	sd	ra,24(sp)
    8000564c:	e822                	sd	s0,16(sp)
    8000564e:	e426                	sd	s1,8(sp)
    80005650:	e04a                	sd	s2,0(sp)
    80005652:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005654:	00018517          	auipc	a0,0x18
    80005658:	ad450513          	addi	a0,a0,-1324 # 8001d128 <disk+0x2128>
    8000565c:	00001097          	auipc	ra,0x1
    80005660:	b0c080e7          	jalr	-1268(ra) # 80006168 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005664:	10001737          	lui	a4,0x10001
    80005668:	533c                	lw	a5,96(a4)
    8000566a:	8b8d                	andi	a5,a5,3
    8000566c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000566e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005672:	00018797          	auipc	a5,0x18
    80005676:	98e78793          	addi	a5,a5,-1650 # 8001d000 <disk+0x2000>
    8000567a:	6b94                	ld	a3,16(a5)
    8000567c:	0207d703          	lhu	a4,32(a5)
    80005680:	0026d783          	lhu	a5,2(a3)
    80005684:	06f70163          	beq	a4,a5,800056e6 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005688:	00016917          	auipc	s2,0x16
    8000568c:	97890913          	addi	s2,s2,-1672 # 8001b000 <disk>
    80005690:	00018497          	auipc	s1,0x18
    80005694:	97048493          	addi	s1,s1,-1680 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005698:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000569c:	6898                	ld	a4,16(s1)
    8000569e:	0204d783          	lhu	a5,32(s1)
    800056a2:	8b9d                	andi	a5,a5,7
    800056a4:	078e                	slli	a5,a5,0x3
    800056a6:	97ba                	add	a5,a5,a4
    800056a8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056aa:	20078713          	addi	a4,a5,512
    800056ae:	0712                	slli	a4,a4,0x4
    800056b0:	974a                	add	a4,a4,s2
    800056b2:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056b6:	e731                	bnez	a4,80005702 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056b8:	20078793          	addi	a5,a5,512
    800056bc:	0792                	slli	a5,a5,0x4
    800056be:	97ca                	add	a5,a5,s2
    800056c0:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056c2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056c6:	ffffc097          	auipc	ra,0xffffc
    800056ca:	ffa080e7          	jalr	-6(ra) # 800016c0 <wakeup>

    disk.used_idx += 1;
    800056ce:	0204d783          	lhu	a5,32(s1)
    800056d2:	2785                	addiw	a5,a5,1
    800056d4:	17c2                	slli	a5,a5,0x30
    800056d6:	93c1                	srli	a5,a5,0x30
    800056d8:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056dc:	6898                	ld	a4,16(s1)
    800056de:	00275703          	lhu	a4,2(a4)
    800056e2:	faf71be3          	bne	a4,a5,80005698 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800056e6:	00018517          	auipc	a0,0x18
    800056ea:	a4250513          	addi	a0,a0,-1470 # 8001d128 <disk+0x2128>
    800056ee:	00001097          	auipc	ra,0x1
    800056f2:	b2e080e7          	jalr	-1234(ra) # 8000621c <release>
}
    800056f6:	60e2                	ld	ra,24(sp)
    800056f8:	6442                	ld	s0,16(sp)
    800056fa:	64a2                	ld	s1,8(sp)
    800056fc:	6902                	ld	s2,0(sp)
    800056fe:	6105                	addi	sp,sp,32
    80005700:	8082                	ret
      panic("virtio_disk_intr status");
    80005702:	00003517          	auipc	a0,0x3
    80005706:	1f650513          	addi	a0,a0,502 # 800088f8 <sysname+0x3b0>
    8000570a:	00000097          	auipc	ra,0x0
    8000570e:	526080e7          	jalr	1318(ra) # 80005c30 <panic>

0000000080005712 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005712:	1141                	addi	sp,sp,-16
    80005714:	e422                	sd	s0,8(sp)
    80005716:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005718:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000571c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005720:	0037979b          	slliw	a5,a5,0x3
    80005724:	02004737          	lui	a4,0x2004
    80005728:	97ba                	add	a5,a5,a4
    8000572a:	0200c737          	lui	a4,0x200c
    8000572e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005732:	000f4637          	lui	a2,0xf4
    80005736:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000573a:	9732                	add	a4,a4,a2
    8000573c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000573e:	00259693          	slli	a3,a1,0x2
    80005742:	96ae                	add	a3,a3,a1
    80005744:	068e                	slli	a3,a3,0x3
    80005746:	00019717          	auipc	a4,0x19
    8000574a:	8ba70713          	addi	a4,a4,-1862 # 8001e000 <timer_scratch>
    8000574e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005750:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005752:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005754:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005758:	00000797          	auipc	a5,0x0
    8000575c:	9c878793          	addi	a5,a5,-1592 # 80005120 <timervec>
    80005760:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005764:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005768:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000576c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005770:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005774:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005778:	30479073          	csrw	mie,a5
}
    8000577c:	6422                	ld	s0,8(sp)
    8000577e:	0141                	addi	sp,sp,16
    80005780:	8082                	ret

0000000080005782 <start>:
{
    80005782:	1141                	addi	sp,sp,-16
    80005784:	e406                	sd	ra,8(sp)
    80005786:	e022                	sd	s0,0(sp)
    80005788:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000578a:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000578e:	7779                	lui	a4,0xffffe
    80005790:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005794:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005796:	6705                	lui	a4,0x1
    80005798:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000579c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000579e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057a2:	ffffb797          	auipc	a5,0xffffb
    800057a6:	ba278793          	addi	a5,a5,-1118 # 80000344 <main>
    800057aa:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057ae:	4781                	li	a5,0
    800057b0:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057b4:	67c1                	lui	a5,0x10
    800057b6:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800057b8:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057bc:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057c0:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057c4:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057c8:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057cc:	57fd                	li	a5,-1
    800057ce:	83a9                	srli	a5,a5,0xa
    800057d0:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057d4:	47bd                	li	a5,15
    800057d6:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057da:	00000097          	auipc	ra,0x0
    800057de:	f38080e7          	jalr	-200(ra) # 80005712 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057e2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057e6:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057e8:	823e                	mv	tp,a5
  asm volatile("mret");
    800057ea:	30200073          	mret
}
    800057ee:	60a2                	ld	ra,8(sp)
    800057f0:	6402                	ld	s0,0(sp)
    800057f2:	0141                	addi	sp,sp,16
    800057f4:	8082                	ret

00000000800057f6 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057f6:	715d                	addi	sp,sp,-80
    800057f8:	e486                	sd	ra,72(sp)
    800057fa:	e0a2                	sd	s0,64(sp)
    800057fc:	fc26                	sd	s1,56(sp)
    800057fe:	f84a                	sd	s2,48(sp)
    80005800:	f44e                	sd	s3,40(sp)
    80005802:	f052                	sd	s4,32(sp)
    80005804:	ec56                	sd	s5,24(sp)
    80005806:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005808:	04c05763          	blez	a2,80005856 <consolewrite+0x60>
    8000580c:	8a2a                	mv	s4,a0
    8000580e:	84ae                	mv	s1,a1
    80005810:	89b2                	mv	s3,a2
    80005812:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005814:	5afd                	li	s5,-1
    80005816:	4685                	li	a3,1
    80005818:	8626                	mv	a2,s1
    8000581a:	85d2                	mv	a1,s4
    8000581c:	fbf40513          	addi	a0,s0,-65
    80005820:	ffffc097          	auipc	ra,0xffffc
    80005824:	10e080e7          	jalr	270(ra) # 8000192e <either_copyin>
    80005828:	01550d63          	beq	a0,s5,80005842 <consolewrite+0x4c>
      break;
    uartputc(c);
    8000582c:	fbf44503          	lbu	a0,-65(s0)
    80005830:	00000097          	auipc	ra,0x0
    80005834:	77e080e7          	jalr	1918(ra) # 80005fae <uartputc>
  for(i = 0; i < n; i++){
    80005838:	2905                	addiw	s2,s2,1
    8000583a:	0485                	addi	s1,s1,1
    8000583c:	fd299de3          	bne	s3,s2,80005816 <consolewrite+0x20>
    80005840:	894e                	mv	s2,s3
  }

  return i;
}
    80005842:	854a                	mv	a0,s2
    80005844:	60a6                	ld	ra,72(sp)
    80005846:	6406                	ld	s0,64(sp)
    80005848:	74e2                	ld	s1,56(sp)
    8000584a:	7942                	ld	s2,48(sp)
    8000584c:	79a2                	ld	s3,40(sp)
    8000584e:	7a02                	ld	s4,32(sp)
    80005850:	6ae2                	ld	s5,24(sp)
    80005852:	6161                	addi	sp,sp,80
    80005854:	8082                	ret
  for(i = 0; i < n; i++){
    80005856:	4901                	li	s2,0
    80005858:	b7ed                	j	80005842 <consolewrite+0x4c>

000000008000585a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000585a:	7159                	addi	sp,sp,-112
    8000585c:	f486                	sd	ra,104(sp)
    8000585e:	f0a2                	sd	s0,96(sp)
    80005860:	eca6                	sd	s1,88(sp)
    80005862:	e8ca                	sd	s2,80(sp)
    80005864:	e4ce                	sd	s3,72(sp)
    80005866:	e0d2                	sd	s4,64(sp)
    80005868:	fc56                	sd	s5,56(sp)
    8000586a:	f85a                	sd	s6,48(sp)
    8000586c:	f45e                	sd	s7,40(sp)
    8000586e:	f062                	sd	s8,32(sp)
    80005870:	ec66                	sd	s9,24(sp)
    80005872:	e86a                	sd	s10,16(sp)
    80005874:	1880                	addi	s0,sp,112
    80005876:	8aaa                	mv	s5,a0
    80005878:	8a2e                	mv	s4,a1
    8000587a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000587c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005880:	00021517          	auipc	a0,0x21
    80005884:	8c050513          	addi	a0,a0,-1856 # 80026140 <cons>
    80005888:	00001097          	auipc	ra,0x1
    8000588c:	8e0080e7          	jalr	-1824(ra) # 80006168 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005890:	00021497          	auipc	s1,0x21
    80005894:	8b048493          	addi	s1,s1,-1872 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005898:	00021917          	auipc	s2,0x21
    8000589c:	94090913          	addi	s2,s2,-1728 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058a0:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058a2:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058a4:	4ca9                	li	s9,10
  while(n > 0){
    800058a6:	07305863          	blez	s3,80005916 <consoleread+0xbc>
    while(cons.r == cons.w){
    800058aa:	0984a783          	lw	a5,152(s1)
    800058ae:	09c4a703          	lw	a4,156(s1)
    800058b2:	02f71463          	bne	a4,a5,800058da <consoleread+0x80>
      if(myproc()->killed){
    800058b6:	ffffb097          	auipc	ra,0xffffb
    800058ba:	5b2080e7          	jalr	1458(ra) # 80000e68 <myproc>
    800058be:	551c                	lw	a5,40(a0)
    800058c0:	e7b5                	bnez	a5,8000592c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800058c2:	85a6                	mv	a1,s1
    800058c4:	854a                	mv	a0,s2
    800058c6:	ffffc097          	auipc	ra,0xffffc
    800058ca:	c6e080e7          	jalr	-914(ra) # 80001534 <sleep>
    while(cons.r == cons.w){
    800058ce:	0984a783          	lw	a5,152(s1)
    800058d2:	09c4a703          	lw	a4,156(s1)
    800058d6:	fef700e3          	beq	a4,a5,800058b6 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800058da:	0017871b          	addiw	a4,a5,1
    800058de:	08e4ac23          	sw	a4,152(s1)
    800058e2:	07f7f713          	andi	a4,a5,127
    800058e6:	9726                	add	a4,a4,s1
    800058e8:	01874703          	lbu	a4,24(a4)
    800058ec:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800058f0:	077d0563          	beq	s10,s7,8000595a <consoleread+0x100>
    cbuf = c;
    800058f4:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058f8:	4685                	li	a3,1
    800058fa:	f9f40613          	addi	a2,s0,-97
    800058fe:	85d2                	mv	a1,s4
    80005900:	8556                	mv	a0,s5
    80005902:	ffffc097          	auipc	ra,0xffffc
    80005906:	fd6080e7          	jalr	-42(ra) # 800018d8 <either_copyout>
    8000590a:	01850663          	beq	a0,s8,80005916 <consoleread+0xbc>
    dst++;
    8000590e:	0a05                	addi	s4,s4,1
    --n;
    80005910:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005912:	f99d1ae3          	bne	s10,s9,800058a6 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005916:	00021517          	auipc	a0,0x21
    8000591a:	82a50513          	addi	a0,a0,-2006 # 80026140 <cons>
    8000591e:	00001097          	auipc	ra,0x1
    80005922:	8fe080e7          	jalr	-1794(ra) # 8000621c <release>

  return target - n;
    80005926:	413b053b          	subw	a0,s6,s3
    8000592a:	a811                	j	8000593e <consoleread+0xe4>
        release(&cons.lock);
    8000592c:	00021517          	auipc	a0,0x21
    80005930:	81450513          	addi	a0,a0,-2028 # 80026140 <cons>
    80005934:	00001097          	auipc	ra,0x1
    80005938:	8e8080e7          	jalr	-1816(ra) # 8000621c <release>
        return -1;
    8000593c:	557d                	li	a0,-1
}
    8000593e:	70a6                	ld	ra,104(sp)
    80005940:	7406                	ld	s0,96(sp)
    80005942:	64e6                	ld	s1,88(sp)
    80005944:	6946                	ld	s2,80(sp)
    80005946:	69a6                	ld	s3,72(sp)
    80005948:	6a06                	ld	s4,64(sp)
    8000594a:	7ae2                	ld	s5,56(sp)
    8000594c:	7b42                	ld	s6,48(sp)
    8000594e:	7ba2                	ld	s7,40(sp)
    80005950:	7c02                	ld	s8,32(sp)
    80005952:	6ce2                	ld	s9,24(sp)
    80005954:	6d42                	ld	s10,16(sp)
    80005956:	6165                	addi	sp,sp,112
    80005958:	8082                	ret
      if(n < target){
    8000595a:	0009871b          	sext.w	a4,s3
    8000595e:	fb677ce3          	bgeu	a4,s6,80005916 <consoleread+0xbc>
        cons.r--;
    80005962:	00021717          	auipc	a4,0x21
    80005966:	86f72b23          	sw	a5,-1930(a4) # 800261d8 <cons+0x98>
    8000596a:	b775                	j	80005916 <consoleread+0xbc>

000000008000596c <consputc>:
{
    8000596c:	1141                	addi	sp,sp,-16
    8000596e:	e406                	sd	ra,8(sp)
    80005970:	e022                	sd	s0,0(sp)
    80005972:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005974:	10000793          	li	a5,256
    80005978:	00f50a63          	beq	a0,a5,8000598c <consputc+0x20>
    uartputc_sync(c);
    8000597c:	00000097          	auipc	ra,0x0
    80005980:	560080e7          	jalr	1376(ra) # 80005edc <uartputc_sync>
}
    80005984:	60a2                	ld	ra,8(sp)
    80005986:	6402                	ld	s0,0(sp)
    80005988:	0141                	addi	sp,sp,16
    8000598a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000598c:	4521                	li	a0,8
    8000598e:	00000097          	auipc	ra,0x0
    80005992:	54e080e7          	jalr	1358(ra) # 80005edc <uartputc_sync>
    80005996:	02000513          	li	a0,32
    8000599a:	00000097          	auipc	ra,0x0
    8000599e:	542080e7          	jalr	1346(ra) # 80005edc <uartputc_sync>
    800059a2:	4521                	li	a0,8
    800059a4:	00000097          	auipc	ra,0x0
    800059a8:	538080e7          	jalr	1336(ra) # 80005edc <uartputc_sync>
    800059ac:	bfe1                	j	80005984 <consputc+0x18>

00000000800059ae <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059ae:	1101                	addi	sp,sp,-32
    800059b0:	ec06                	sd	ra,24(sp)
    800059b2:	e822                	sd	s0,16(sp)
    800059b4:	e426                	sd	s1,8(sp)
    800059b6:	e04a                	sd	s2,0(sp)
    800059b8:	1000                	addi	s0,sp,32
    800059ba:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059bc:	00020517          	auipc	a0,0x20
    800059c0:	78450513          	addi	a0,a0,1924 # 80026140 <cons>
    800059c4:	00000097          	auipc	ra,0x0
    800059c8:	7a4080e7          	jalr	1956(ra) # 80006168 <acquire>

  switch(c){
    800059cc:	47d5                	li	a5,21
    800059ce:	0af48663          	beq	s1,a5,80005a7a <consoleintr+0xcc>
    800059d2:	0297ca63          	blt	a5,s1,80005a06 <consoleintr+0x58>
    800059d6:	47a1                	li	a5,8
    800059d8:	0ef48763          	beq	s1,a5,80005ac6 <consoleintr+0x118>
    800059dc:	47c1                	li	a5,16
    800059de:	10f49a63          	bne	s1,a5,80005af2 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059e2:	ffffc097          	auipc	ra,0xffffc
    800059e6:	fa2080e7          	jalr	-94(ra) # 80001984 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059ea:	00020517          	auipc	a0,0x20
    800059ee:	75650513          	addi	a0,a0,1878 # 80026140 <cons>
    800059f2:	00001097          	auipc	ra,0x1
    800059f6:	82a080e7          	jalr	-2006(ra) # 8000621c <release>
}
    800059fa:	60e2                	ld	ra,24(sp)
    800059fc:	6442                	ld	s0,16(sp)
    800059fe:	64a2                	ld	s1,8(sp)
    80005a00:	6902                	ld	s2,0(sp)
    80005a02:	6105                	addi	sp,sp,32
    80005a04:	8082                	ret
  switch(c){
    80005a06:	07f00793          	li	a5,127
    80005a0a:	0af48e63          	beq	s1,a5,80005ac6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a0e:	00020717          	auipc	a4,0x20
    80005a12:	73270713          	addi	a4,a4,1842 # 80026140 <cons>
    80005a16:	0a072783          	lw	a5,160(a4)
    80005a1a:	09872703          	lw	a4,152(a4)
    80005a1e:	9f99                	subw	a5,a5,a4
    80005a20:	07f00713          	li	a4,127
    80005a24:	fcf763e3          	bltu	a4,a5,800059ea <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a28:	47b5                	li	a5,13
    80005a2a:	0cf48763          	beq	s1,a5,80005af8 <consoleintr+0x14a>
      consputc(c);
    80005a2e:	8526                	mv	a0,s1
    80005a30:	00000097          	auipc	ra,0x0
    80005a34:	f3c080e7          	jalr	-196(ra) # 8000596c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a38:	00020797          	auipc	a5,0x20
    80005a3c:	70878793          	addi	a5,a5,1800 # 80026140 <cons>
    80005a40:	0a07a703          	lw	a4,160(a5)
    80005a44:	0017069b          	addiw	a3,a4,1
    80005a48:	0006861b          	sext.w	a2,a3
    80005a4c:	0ad7a023          	sw	a3,160(a5)
    80005a50:	07f77713          	andi	a4,a4,127
    80005a54:	97ba                	add	a5,a5,a4
    80005a56:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a5a:	47a9                	li	a5,10
    80005a5c:	0cf48563          	beq	s1,a5,80005b26 <consoleintr+0x178>
    80005a60:	4791                	li	a5,4
    80005a62:	0cf48263          	beq	s1,a5,80005b26 <consoleintr+0x178>
    80005a66:	00020797          	auipc	a5,0x20
    80005a6a:	7727a783          	lw	a5,1906(a5) # 800261d8 <cons+0x98>
    80005a6e:	0807879b          	addiw	a5,a5,128
    80005a72:	f6f61ce3          	bne	a2,a5,800059ea <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a76:	863e                	mv	a2,a5
    80005a78:	a07d                	j	80005b26 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a7a:	00020717          	auipc	a4,0x20
    80005a7e:	6c670713          	addi	a4,a4,1734 # 80026140 <cons>
    80005a82:	0a072783          	lw	a5,160(a4)
    80005a86:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a8a:	00020497          	auipc	s1,0x20
    80005a8e:	6b648493          	addi	s1,s1,1718 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005a92:	4929                	li	s2,10
    80005a94:	f4f70be3          	beq	a4,a5,800059ea <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a98:	37fd                	addiw	a5,a5,-1
    80005a9a:	07f7f713          	andi	a4,a5,127
    80005a9e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005aa0:	01874703          	lbu	a4,24(a4)
    80005aa4:	f52703e3          	beq	a4,s2,800059ea <consoleintr+0x3c>
      cons.e--;
    80005aa8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005aac:	10000513          	li	a0,256
    80005ab0:	00000097          	auipc	ra,0x0
    80005ab4:	ebc080e7          	jalr	-324(ra) # 8000596c <consputc>
    while(cons.e != cons.w &&
    80005ab8:	0a04a783          	lw	a5,160(s1)
    80005abc:	09c4a703          	lw	a4,156(s1)
    80005ac0:	fcf71ce3          	bne	a4,a5,80005a98 <consoleintr+0xea>
    80005ac4:	b71d                	j	800059ea <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005ac6:	00020717          	auipc	a4,0x20
    80005aca:	67a70713          	addi	a4,a4,1658 # 80026140 <cons>
    80005ace:	0a072783          	lw	a5,160(a4)
    80005ad2:	09c72703          	lw	a4,156(a4)
    80005ad6:	f0f70ae3          	beq	a4,a5,800059ea <consoleintr+0x3c>
      cons.e--;
    80005ada:	37fd                	addiw	a5,a5,-1
    80005adc:	00020717          	auipc	a4,0x20
    80005ae0:	70f72223          	sw	a5,1796(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005ae4:	10000513          	li	a0,256
    80005ae8:	00000097          	auipc	ra,0x0
    80005aec:	e84080e7          	jalr	-380(ra) # 8000596c <consputc>
    80005af0:	bded                	j	800059ea <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005af2:	ee048ce3          	beqz	s1,800059ea <consoleintr+0x3c>
    80005af6:	bf21                	j	80005a0e <consoleintr+0x60>
      consputc(c);
    80005af8:	4529                	li	a0,10
    80005afa:	00000097          	auipc	ra,0x0
    80005afe:	e72080e7          	jalr	-398(ra) # 8000596c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b02:	00020797          	auipc	a5,0x20
    80005b06:	63e78793          	addi	a5,a5,1598 # 80026140 <cons>
    80005b0a:	0a07a703          	lw	a4,160(a5)
    80005b0e:	0017069b          	addiw	a3,a4,1
    80005b12:	0006861b          	sext.w	a2,a3
    80005b16:	0ad7a023          	sw	a3,160(a5)
    80005b1a:	07f77713          	andi	a4,a4,127
    80005b1e:	97ba                	add	a5,a5,a4
    80005b20:	4729                	li	a4,10
    80005b22:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b26:	00020797          	auipc	a5,0x20
    80005b2a:	6ac7ab23          	sw	a2,1718(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b2e:	00020517          	auipc	a0,0x20
    80005b32:	6aa50513          	addi	a0,a0,1706 # 800261d8 <cons+0x98>
    80005b36:	ffffc097          	auipc	ra,0xffffc
    80005b3a:	b8a080e7          	jalr	-1142(ra) # 800016c0 <wakeup>
    80005b3e:	b575                	j	800059ea <consoleintr+0x3c>

0000000080005b40 <consoleinit>:

void
consoleinit(void)
{
    80005b40:	1141                	addi	sp,sp,-16
    80005b42:	e406                	sd	ra,8(sp)
    80005b44:	e022                	sd	s0,0(sp)
    80005b46:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b48:	00003597          	auipc	a1,0x3
    80005b4c:	dc858593          	addi	a1,a1,-568 # 80008910 <sysname+0x3c8>
    80005b50:	00020517          	auipc	a0,0x20
    80005b54:	5f050513          	addi	a0,a0,1520 # 80026140 <cons>
    80005b58:	00000097          	auipc	ra,0x0
    80005b5c:	580080e7          	jalr	1408(ra) # 800060d8 <initlock>

  uartinit();
    80005b60:	00000097          	auipc	ra,0x0
    80005b64:	32c080e7          	jalr	812(ra) # 80005e8c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b68:	00013797          	auipc	a5,0x13
    80005b6c:	76078793          	addi	a5,a5,1888 # 800192c8 <devsw>
    80005b70:	00000717          	auipc	a4,0x0
    80005b74:	cea70713          	addi	a4,a4,-790 # 8000585a <consoleread>
    80005b78:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b7a:	00000717          	auipc	a4,0x0
    80005b7e:	c7c70713          	addi	a4,a4,-900 # 800057f6 <consolewrite>
    80005b82:	ef98                	sd	a4,24(a5)
}
    80005b84:	60a2                	ld	ra,8(sp)
    80005b86:	6402                	ld	s0,0(sp)
    80005b88:	0141                	addi	sp,sp,16
    80005b8a:	8082                	ret

0000000080005b8c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b8c:	7179                	addi	sp,sp,-48
    80005b8e:	f406                	sd	ra,40(sp)
    80005b90:	f022                	sd	s0,32(sp)
    80005b92:	ec26                	sd	s1,24(sp)
    80005b94:	e84a                	sd	s2,16(sp)
    80005b96:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b98:	c219                	beqz	a2,80005b9e <printint+0x12>
    80005b9a:	08054763          	bltz	a0,80005c28 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005b9e:	2501                	sext.w	a0,a0
    80005ba0:	4881                	li	a7,0
    80005ba2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005ba6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ba8:	2581                	sext.w	a1,a1
    80005baa:	00003617          	auipc	a2,0x3
    80005bae:	d9660613          	addi	a2,a2,-618 # 80008940 <digits>
    80005bb2:	883a                	mv	a6,a4
    80005bb4:	2705                	addiw	a4,a4,1
    80005bb6:	02b577bb          	remuw	a5,a0,a1
    80005bba:	1782                	slli	a5,a5,0x20
    80005bbc:	9381                	srli	a5,a5,0x20
    80005bbe:	97b2                	add	a5,a5,a2
    80005bc0:	0007c783          	lbu	a5,0(a5)
    80005bc4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bc8:	0005079b          	sext.w	a5,a0
    80005bcc:	02b5553b          	divuw	a0,a0,a1
    80005bd0:	0685                	addi	a3,a3,1
    80005bd2:	feb7f0e3          	bgeu	a5,a1,80005bb2 <printint+0x26>

  if(sign)
    80005bd6:	00088c63          	beqz	a7,80005bee <printint+0x62>
    buf[i++] = '-';
    80005bda:	fe070793          	addi	a5,a4,-32
    80005bde:	00878733          	add	a4,a5,s0
    80005be2:	02d00793          	li	a5,45
    80005be6:	fef70823          	sb	a5,-16(a4)
    80005bea:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005bee:	02e05763          	blez	a4,80005c1c <printint+0x90>
    80005bf2:	fd040793          	addi	a5,s0,-48
    80005bf6:	00e784b3          	add	s1,a5,a4
    80005bfa:	fff78913          	addi	s2,a5,-1
    80005bfe:	993a                	add	s2,s2,a4
    80005c00:	377d                	addiw	a4,a4,-1
    80005c02:	1702                	slli	a4,a4,0x20
    80005c04:	9301                	srli	a4,a4,0x20
    80005c06:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c0a:	fff4c503          	lbu	a0,-1(s1)
    80005c0e:	00000097          	auipc	ra,0x0
    80005c12:	d5e080e7          	jalr	-674(ra) # 8000596c <consputc>
  while(--i >= 0)
    80005c16:	14fd                	addi	s1,s1,-1
    80005c18:	ff2499e3          	bne	s1,s2,80005c0a <printint+0x7e>
}
    80005c1c:	70a2                	ld	ra,40(sp)
    80005c1e:	7402                	ld	s0,32(sp)
    80005c20:	64e2                	ld	s1,24(sp)
    80005c22:	6942                	ld	s2,16(sp)
    80005c24:	6145                	addi	sp,sp,48
    80005c26:	8082                	ret
    x = -xx;
    80005c28:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c2c:	4885                	li	a7,1
    x = -xx;
    80005c2e:	bf95                	j	80005ba2 <printint+0x16>

0000000080005c30 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c30:	1101                	addi	sp,sp,-32
    80005c32:	ec06                	sd	ra,24(sp)
    80005c34:	e822                	sd	s0,16(sp)
    80005c36:	e426                	sd	s1,8(sp)
    80005c38:	1000                	addi	s0,sp,32
    80005c3a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c3c:	00020797          	auipc	a5,0x20
    80005c40:	5c07a223          	sw	zero,1476(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c44:	00003517          	auipc	a0,0x3
    80005c48:	cd450513          	addi	a0,a0,-812 # 80008918 <sysname+0x3d0>
    80005c4c:	00000097          	auipc	ra,0x0
    80005c50:	02e080e7          	jalr	46(ra) # 80005c7a <printf>
  printf(s);
    80005c54:	8526                	mv	a0,s1
    80005c56:	00000097          	auipc	ra,0x0
    80005c5a:	024080e7          	jalr	36(ra) # 80005c7a <printf>
  printf("\n");
    80005c5e:	00002517          	auipc	a0,0x2
    80005c62:	3ea50513          	addi	a0,a0,1002 # 80008048 <etext+0x48>
    80005c66:	00000097          	auipc	ra,0x0
    80005c6a:	014080e7          	jalr	20(ra) # 80005c7a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c6e:	4785                	li	a5,1
    80005c70:	00003717          	auipc	a4,0x3
    80005c74:	3af72623          	sw	a5,940(a4) # 8000901c <panicked>
  for(;;)
    80005c78:	a001                	j	80005c78 <panic+0x48>

0000000080005c7a <printf>:
{
    80005c7a:	7131                	addi	sp,sp,-192
    80005c7c:	fc86                	sd	ra,120(sp)
    80005c7e:	f8a2                	sd	s0,112(sp)
    80005c80:	f4a6                	sd	s1,104(sp)
    80005c82:	f0ca                	sd	s2,96(sp)
    80005c84:	ecce                	sd	s3,88(sp)
    80005c86:	e8d2                	sd	s4,80(sp)
    80005c88:	e4d6                	sd	s5,72(sp)
    80005c8a:	e0da                	sd	s6,64(sp)
    80005c8c:	fc5e                	sd	s7,56(sp)
    80005c8e:	f862                	sd	s8,48(sp)
    80005c90:	f466                	sd	s9,40(sp)
    80005c92:	f06a                	sd	s10,32(sp)
    80005c94:	ec6e                	sd	s11,24(sp)
    80005c96:	0100                	addi	s0,sp,128
    80005c98:	8a2a                	mv	s4,a0
    80005c9a:	e40c                	sd	a1,8(s0)
    80005c9c:	e810                	sd	a2,16(s0)
    80005c9e:	ec14                	sd	a3,24(s0)
    80005ca0:	f018                	sd	a4,32(s0)
    80005ca2:	f41c                	sd	a5,40(s0)
    80005ca4:	03043823          	sd	a6,48(s0)
    80005ca8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cac:	00020d97          	auipc	s11,0x20
    80005cb0:	554dad83          	lw	s11,1364(s11) # 80026200 <pr+0x18>
  if(locking)
    80005cb4:	020d9b63          	bnez	s11,80005cea <printf+0x70>
  if (fmt == 0)
    80005cb8:	040a0263          	beqz	s4,80005cfc <printf+0x82>
  va_start(ap, fmt);
    80005cbc:	00840793          	addi	a5,s0,8
    80005cc0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cc4:	000a4503          	lbu	a0,0(s4)
    80005cc8:	14050f63          	beqz	a0,80005e26 <printf+0x1ac>
    80005ccc:	4981                	li	s3,0
    if(c != '%'){
    80005cce:	02500a93          	li	s5,37
    switch(c){
    80005cd2:	07000b93          	li	s7,112
  consputc('x');
    80005cd6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cd8:	00003b17          	auipc	s6,0x3
    80005cdc:	c68b0b13          	addi	s6,s6,-920 # 80008940 <digits>
    switch(c){
    80005ce0:	07300c93          	li	s9,115
    80005ce4:	06400c13          	li	s8,100
    80005ce8:	a82d                	j	80005d22 <printf+0xa8>
    acquire(&pr.lock);
    80005cea:	00020517          	auipc	a0,0x20
    80005cee:	4fe50513          	addi	a0,a0,1278 # 800261e8 <pr>
    80005cf2:	00000097          	auipc	ra,0x0
    80005cf6:	476080e7          	jalr	1142(ra) # 80006168 <acquire>
    80005cfa:	bf7d                	j	80005cb8 <printf+0x3e>
    panic("null fmt");
    80005cfc:	00003517          	auipc	a0,0x3
    80005d00:	c2c50513          	addi	a0,a0,-980 # 80008928 <sysname+0x3e0>
    80005d04:	00000097          	auipc	ra,0x0
    80005d08:	f2c080e7          	jalr	-212(ra) # 80005c30 <panic>
      consputc(c);
    80005d0c:	00000097          	auipc	ra,0x0
    80005d10:	c60080e7          	jalr	-928(ra) # 8000596c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d14:	2985                	addiw	s3,s3,1
    80005d16:	013a07b3          	add	a5,s4,s3
    80005d1a:	0007c503          	lbu	a0,0(a5)
    80005d1e:	10050463          	beqz	a0,80005e26 <printf+0x1ac>
    if(c != '%'){
    80005d22:	ff5515e3          	bne	a0,s5,80005d0c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d26:	2985                	addiw	s3,s3,1
    80005d28:	013a07b3          	add	a5,s4,s3
    80005d2c:	0007c783          	lbu	a5,0(a5)
    80005d30:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d34:	cbed                	beqz	a5,80005e26 <printf+0x1ac>
    switch(c){
    80005d36:	05778a63          	beq	a5,s7,80005d8a <printf+0x110>
    80005d3a:	02fbf663          	bgeu	s7,a5,80005d66 <printf+0xec>
    80005d3e:	09978863          	beq	a5,s9,80005dce <printf+0x154>
    80005d42:	07800713          	li	a4,120
    80005d46:	0ce79563          	bne	a5,a4,80005e10 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d4a:	f8843783          	ld	a5,-120(s0)
    80005d4e:	00878713          	addi	a4,a5,8
    80005d52:	f8e43423          	sd	a4,-120(s0)
    80005d56:	4605                	li	a2,1
    80005d58:	85ea                	mv	a1,s10
    80005d5a:	4388                	lw	a0,0(a5)
    80005d5c:	00000097          	auipc	ra,0x0
    80005d60:	e30080e7          	jalr	-464(ra) # 80005b8c <printint>
      break;
    80005d64:	bf45                	j	80005d14 <printf+0x9a>
    switch(c){
    80005d66:	09578f63          	beq	a5,s5,80005e04 <printf+0x18a>
    80005d6a:	0b879363          	bne	a5,s8,80005e10 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005d6e:	f8843783          	ld	a5,-120(s0)
    80005d72:	00878713          	addi	a4,a5,8
    80005d76:	f8e43423          	sd	a4,-120(s0)
    80005d7a:	4605                	li	a2,1
    80005d7c:	45a9                	li	a1,10
    80005d7e:	4388                	lw	a0,0(a5)
    80005d80:	00000097          	auipc	ra,0x0
    80005d84:	e0c080e7          	jalr	-500(ra) # 80005b8c <printint>
      break;
    80005d88:	b771                	j	80005d14 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d8a:	f8843783          	ld	a5,-120(s0)
    80005d8e:	00878713          	addi	a4,a5,8
    80005d92:	f8e43423          	sd	a4,-120(s0)
    80005d96:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005d9a:	03000513          	li	a0,48
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	bce080e7          	jalr	-1074(ra) # 8000596c <consputc>
  consputc('x');
    80005da6:	07800513          	li	a0,120
    80005daa:	00000097          	auipc	ra,0x0
    80005dae:	bc2080e7          	jalr	-1086(ra) # 8000596c <consputc>
    80005db2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005db4:	03c95793          	srli	a5,s2,0x3c
    80005db8:	97da                	add	a5,a5,s6
    80005dba:	0007c503          	lbu	a0,0(a5)
    80005dbe:	00000097          	auipc	ra,0x0
    80005dc2:	bae080e7          	jalr	-1106(ra) # 8000596c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dc6:	0912                	slli	s2,s2,0x4
    80005dc8:	34fd                	addiw	s1,s1,-1
    80005dca:	f4ed                	bnez	s1,80005db4 <printf+0x13a>
    80005dcc:	b7a1                	j	80005d14 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005dce:	f8843783          	ld	a5,-120(s0)
    80005dd2:	00878713          	addi	a4,a5,8
    80005dd6:	f8e43423          	sd	a4,-120(s0)
    80005dda:	6384                	ld	s1,0(a5)
    80005ddc:	cc89                	beqz	s1,80005df6 <printf+0x17c>
      for(; *s; s++)
    80005dde:	0004c503          	lbu	a0,0(s1)
    80005de2:	d90d                	beqz	a0,80005d14 <printf+0x9a>
        consputc(*s);
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	b88080e7          	jalr	-1144(ra) # 8000596c <consputc>
      for(; *s; s++)
    80005dec:	0485                	addi	s1,s1,1
    80005dee:	0004c503          	lbu	a0,0(s1)
    80005df2:	f96d                	bnez	a0,80005de4 <printf+0x16a>
    80005df4:	b705                	j	80005d14 <printf+0x9a>
        s = "(null)";
    80005df6:	00003497          	auipc	s1,0x3
    80005dfa:	b2a48493          	addi	s1,s1,-1238 # 80008920 <sysname+0x3d8>
      for(; *s; s++)
    80005dfe:	02800513          	li	a0,40
    80005e02:	b7cd                	j	80005de4 <printf+0x16a>
      consputc('%');
    80005e04:	8556                	mv	a0,s5
    80005e06:	00000097          	auipc	ra,0x0
    80005e0a:	b66080e7          	jalr	-1178(ra) # 8000596c <consputc>
      break;
    80005e0e:	b719                	j	80005d14 <printf+0x9a>
      consputc('%');
    80005e10:	8556                	mv	a0,s5
    80005e12:	00000097          	auipc	ra,0x0
    80005e16:	b5a080e7          	jalr	-1190(ra) # 8000596c <consputc>
      consputc(c);
    80005e1a:	8526                	mv	a0,s1
    80005e1c:	00000097          	auipc	ra,0x0
    80005e20:	b50080e7          	jalr	-1200(ra) # 8000596c <consputc>
      break;
    80005e24:	bdc5                	j	80005d14 <printf+0x9a>
  if(locking)
    80005e26:	020d9163          	bnez	s11,80005e48 <printf+0x1ce>
}
    80005e2a:	70e6                	ld	ra,120(sp)
    80005e2c:	7446                	ld	s0,112(sp)
    80005e2e:	74a6                	ld	s1,104(sp)
    80005e30:	7906                	ld	s2,96(sp)
    80005e32:	69e6                	ld	s3,88(sp)
    80005e34:	6a46                	ld	s4,80(sp)
    80005e36:	6aa6                	ld	s5,72(sp)
    80005e38:	6b06                	ld	s6,64(sp)
    80005e3a:	7be2                	ld	s7,56(sp)
    80005e3c:	7c42                	ld	s8,48(sp)
    80005e3e:	7ca2                	ld	s9,40(sp)
    80005e40:	7d02                	ld	s10,32(sp)
    80005e42:	6de2                	ld	s11,24(sp)
    80005e44:	6129                	addi	sp,sp,192
    80005e46:	8082                	ret
    release(&pr.lock);
    80005e48:	00020517          	auipc	a0,0x20
    80005e4c:	3a050513          	addi	a0,a0,928 # 800261e8 <pr>
    80005e50:	00000097          	auipc	ra,0x0
    80005e54:	3cc080e7          	jalr	972(ra) # 8000621c <release>
}
    80005e58:	bfc9                	j	80005e2a <printf+0x1b0>

0000000080005e5a <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e5a:	1101                	addi	sp,sp,-32
    80005e5c:	ec06                	sd	ra,24(sp)
    80005e5e:	e822                	sd	s0,16(sp)
    80005e60:	e426                	sd	s1,8(sp)
    80005e62:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e64:	00020497          	auipc	s1,0x20
    80005e68:	38448493          	addi	s1,s1,900 # 800261e8 <pr>
    80005e6c:	00003597          	auipc	a1,0x3
    80005e70:	acc58593          	addi	a1,a1,-1332 # 80008938 <sysname+0x3f0>
    80005e74:	8526                	mv	a0,s1
    80005e76:	00000097          	auipc	ra,0x0
    80005e7a:	262080e7          	jalr	610(ra) # 800060d8 <initlock>
  pr.locking = 1;
    80005e7e:	4785                	li	a5,1
    80005e80:	cc9c                	sw	a5,24(s1)
}
    80005e82:	60e2                	ld	ra,24(sp)
    80005e84:	6442                	ld	s0,16(sp)
    80005e86:	64a2                	ld	s1,8(sp)
    80005e88:	6105                	addi	sp,sp,32
    80005e8a:	8082                	ret

0000000080005e8c <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005e8c:	1141                	addi	sp,sp,-16
    80005e8e:	e406                	sd	ra,8(sp)
    80005e90:	e022                	sd	s0,0(sp)
    80005e92:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005e94:	100007b7          	lui	a5,0x10000
    80005e98:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e9c:	f8000713          	li	a4,-128
    80005ea0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ea4:	470d                	li	a4,3
    80005ea6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005eaa:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005eae:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005eb2:	469d                	li	a3,7
    80005eb4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005eb8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ebc:	00003597          	auipc	a1,0x3
    80005ec0:	a9c58593          	addi	a1,a1,-1380 # 80008958 <digits+0x18>
    80005ec4:	00020517          	auipc	a0,0x20
    80005ec8:	34450513          	addi	a0,a0,836 # 80026208 <uart_tx_lock>
    80005ecc:	00000097          	auipc	ra,0x0
    80005ed0:	20c080e7          	jalr	524(ra) # 800060d8 <initlock>
}
    80005ed4:	60a2                	ld	ra,8(sp)
    80005ed6:	6402                	ld	s0,0(sp)
    80005ed8:	0141                	addi	sp,sp,16
    80005eda:	8082                	ret

0000000080005edc <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005edc:	1101                	addi	sp,sp,-32
    80005ede:	ec06                	sd	ra,24(sp)
    80005ee0:	e822                	sd	s0,16(sp)
    80005ee2:	e426                	sd	s1,8(sp)
    80005ee4:	1000                	addi	s0,sp,32
    80005ee6:	84aa                	mv	s1,a0
  push_off();
    80005ee8:	00000097          	auipc	ra,0x0
    80005eec:	234080e7          	jalr	564(ra) # 8000611c <push_off>

  if(panicked){
    80005ef0:	00003797          	auipc	a5,0x3
    80005ef4:	12c7a783          	lw	a5,300(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005ef8:	10000737          	lui	a4,0x10000
  if(panicked){
    80005efc:	c391                	beqz	a5,80005f00 <uartputc_sync+0x24>
    for(;;)
    80005efe:	a001                	j	80005efe <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f00:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f04:	0207f793          	andi	a5,a5,32
    80005f08:	dfe5                	beqz	a5,80005f00 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f0a:	0ff4f513          	zext.b	a0,s1
    80005f0e:	100007b7          	lui	a5,0x10000
    80005f12:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f16:	00000097          	auipc	ra,0x0
    80005f1a:	2a6080e7          	jalr	678(ra) # 800061bc <pop_off>
}
    80005f1e:	60e2                	ld	ra,24(sp)
    80005f20:	6442                	ld	s0,16(sp)
    80005f22:	64a2                	ld	s1,8(sp)
    80005f24:	6105                	addi	sp,sp,32
    80005f26:	8082                	ret

0000000080005f28 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f28:	00003797          	auipc	a5,0x3
    80005f2c:	0f87b783          	ld	a5,248(a5) # 80009020 <uart_tx_r>
    80005f30:	00003717          	auipc	a4,0x3
    80005f34:	0f873703          	ld	a4,248(a4) # 80009028 <uart_tx_w>
    80005f38:	06f70a63          	beq	a4,a5,80005fac <uartstart+0x84>
{
    80005f3c:	7139                	addi	sp,sp,-64
    80005f3e:	fc06                	sd	ra,56(sp)
    80005f40:	f822                	sd	s0,48(sp)
    80005f42:	f426                	sd	s1,40(sp)
    80005f44:	f04a                	sd	s2,32(sp)
    80005f46:	ec4e                	sd	s3,24(sp)
    80005f48:	e852                	sd	s4,16(sp)
    80005f4a:	e456                	sd	s5,8(sp)
    80005f4c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f4e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f52:	00020a17          	auipc	s4,0x20
    80005f56:	2b6a0a13          	addi	s4,s4,694 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f5a:	00003497          	auipc	s1,0x3
    80005f5e:	0c648493          	addi	s1,s1,198 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f62:	00003997          	auipc	s3,0x3
    80005f66:	0c698993          	addi	s3,s3,198 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f6a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f6e:	02077713          	andi	a4,a4,32
    80005f72:	c705                	beqz	a4,80005f9a <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f74:	01f7f713          	andi	a4,a5,31
    80005f78:	9752                	add	a4,a4,s4
    80005f7a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005f7e:	0785                	addi	a5,a5,1
    80005f80:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005f82:	8526                	mv	a0,s1
    80005f84:	ffffb097          	auipc	ra,0xffffb
    80005f88:	73c080e7          	jalr	1852(ra) # 800016c0 <wakeup>
    
    WriteReg(THR, c);
    80005f8c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005f90:	609c                	ld	a5,0(s1)
    80005f92:	0009b703          	ld	a4,0(s3)
    80005f96:	fcf71ae3          	bne	a4,a5,80005f6a <uartstart+0x42>
  }
}
    80005f9a:	70e2                	ld	ra,56(sp)
    80005f9c:	7442                	ld	s0,48(sp)
    80005f9e:	74a2                	ld	s1,40(sp)
    80005fa0:	7902                	ld	s2,32(sp)
    80005fa2:	69e2                	ld	s3,24(sp)
    80005fa4:	6a42                	ld	s4,16(sp)
    80005fa6:	6aa2                	ld	s5,8(sp)
    80005fa8:	6121                	addi	sp,sp,64
    80005faa:	8082                	ret
    80005fac:	8082                	ret

0000000080005fae <uartputc>:
{
    80005fae:	7179                	addi	sp,sp,-48
    80005fb0:	f406                	sd	ra,40(sp)
    80005fb2:	f022                	sd	s0,32(sp)
    80005fb4:	ec26                	sd	s1,24(sp)
    80005fb6:	e84a                	sd	s2,16(sp)
    80005fb8:	e44e                	sd	s3,8(sp)
    80005fba:	e052                	sd	s4,0(sp)
    80005fbc:	1800                	addi	s0,sp,48
    80005fbe:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005fc0:	00020517          	auipc	a0,0x20
    80005fc4:	24850513          	addi	a0,a0,584 # 80026208 <uart_tx_lock>
    80005fc8:	00000097          	auipc	ra,0x0
    80005fcc:	1a0080e7          	jalr	416(ra) # 80006168 <acquire>
  if(panicked){
    80005fd0:	00003797          	auipc	a5,0x3
    80005fd4:	04c7a783          	lw	a5,76(a5) # 8000901c <panicked>
    80005fd8:	c391                	beqz	a5,80005fdc <uartputc+0x2e>
    for(;;)
    80005fda:	a001                	j	80005fda <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fdc:	00003717          	auipc	a4,0x3
    80005fe0:	04c73703          	ld	a4,76(a4) # 80009028 <uart_tx_w>
    80005fe4:	00003797          	auipc	a5,0x3
    80005fe8:	03c7b783          	ld	a5,60(a5) # 80009020 <uart_tx_r>
    80005fec:	02078793          	addi	a5,a5,32
    80005ff0:	02e79b63          	bne	a5,a4,80006026 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005ff4:	00020997          	auipc	s3,0x20
    80005ff8:	21498993          	addi	s3,s3,532 # 80026208 <uart_tx_lock>
    80005ffc:	00003497          	auipc	s1,0x3
    80006000:	02448493          	addi	s1,s1,36 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006004:	00003917          	auipc	s2,0x3
    80006008:	02490913          	addi	s2,s2,36 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000600c:	85ce                	mv	a1,s3
    8000600e:	8526                	mv	a0,s1
    80006010:	ffffb097          	auipc	ra,0xffffb
    80006014:	524080e7          	jalr	1316(ra) # 80001534 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006018:	00093703          	ld	a4,0(s2)
    8000601c:	609c                	ld	a5,0(s1)
    8000601e:	02078793          	addi	a5,a5,32
    80006022:	fee785e3          	beq	a5,a4,8000600c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006026:	00020497          	auipc	s1,0x20
    8000602a:	1e248493          	addi	s1,s1,482 # 80026208 <uart_tx_lock>
    8000602e:	01f77793          	andi	a5,a4,31
    80006032:	97a6                	add	a5,a5,s1
    80006034:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006038:	0705                	addi	a4,a4,1
    8000603a:	00003797          	auipc	a5,0x3
    8000603e:	fee7b723          	sd	a4,-18(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006042:	00000097          	auipc	ra,0x0
    80006046:	ee6080e7          	jalr	-282(ra) # 80005f28 <uartstart>
      release(&uart_tx_lock);
    8000604a:	8526                	mv	a0,s1
    8000604c:	00000097          	auipc	ra,0x0
    80006050:	1d0080e7          	jalr	464(ra) # 8000621c <release>
}
    80006054:	70a2                	ld	ra,40(sp)
    80006056:	7402                	ld	s0,32(sp)
    80006058:	64e2                	ld	s1,24(sp)
    8000605a:	6942                	ld	s2,16(sp)
    8000605c:	69a2                	ld	s3,8(sp)
    8000605e:	6a02                	ld	s4,0(sp)
    80006060:	6145                	addi	sp,sp,48
    80006062:	8082                	ret

0000000080006064 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006064:	1141                	addi	sp,sp,-16
    80006066:	e422                	sd	s0,8(sp)
    80006068:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000606a:	100007b7          	lui	a5,0x10000
    8000606e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006072:	8b85                	andi	a5,a5,1
    80006074:	cb81                	beqz	a5,80006084 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006076:	100007b7          	lui	a5,0x10000
    8000607a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000607e:	6422                	ld	s0,8(sp)
    80006080:	0141                	addi	sp,sp,16
    80006082:	8082                	ret
    return -1;
    80006084:	557d                	li	a0,-1
    80006086:	bfe5                	j	8000607e <uartgetc+0x1a>

0000000080006088 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006088:	1101                	addi	sp,sp,-32
    8000608a:	ec06                	sd	ra,24(sp)
    8000608c:	e822                	sd	s0,16(sp)
    8000608e:	e426                	sd	s1,8(sp)
    80006090:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006092:	54fd                	li	s1,-1
    80006094:	a029                	j	8000609e <uartintr+0x16>
      break;
    consoleintr(c);
    80006096:	00000097          	auipc	ra,0x0
    8000609a:	918080e7          	jalr	-1768(ra) # 800059ae <consoleintr>
    int c = uartgetc();
    8000609e:	00000097          	auipc	ra,0x0
    800060a2:	fc6080e7          	jalr	-58(ra) # 80006064 <uartgetc>
    if(c == -1)
    800060a6:	fe9518e3          	bne	a0,s1,80006096 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060aa:	00020497          	auipc	s1,0x20
    800060ae:	15e48493          	addi	s1,s1,350 # 80026208 <uart_tx_lock>
    800060b2:	8526                	mv	a0,s1
    800060b4:	00000097          	auipc	ra,0x0
    800060b8:	0b4080e7          	jalr	180(ra) # 80006168 <acquire>
  uartstart();
    800060bc:	00000097          	auipc	ra,0x0
    800060c0:	e6c080e7          	jalr	-404(ra) # 80005f28 <uartstart>
  release(&uart_tx_lock);
    800060c4:	8526                	mv	a0,s1
    800060c6:	00000097          	auipc	ra,0x0
    800060ca:	156080e7          	jalr	342(ra) # 8000621c <release>
}
    800060ce:	60e2                	ld	ra,24(sp)
    800060d0:	6442                	ld	s0,16(sp)
    800060d2:	64a2                	ld	s1,8(sp)
    800060d4:	6105                	addi	sp,sp,32
    800060d6:	8082                	ret

00000000800060d8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800060d8:	1141                	addi	sp,sp,-16
    800060da:	e422                	sd	s0,8(sp)
    800060dc:	0800                	addi	s0,sp,16
  lk->name = name;
    800060de:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800060e0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800060e4:	00053823          	sd	zero,16(a0)
}
    800060e8:	6422                	ld	s0,8(sp)
    800060ea:	0141                	addi	sp,sp,16
    800060ec:	8082                	ret

00000000800060ee <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800060ee:	411c                	lw	a5,0(a0)
    800060f0:	e399                	bnez	a5,800060f6 <holding+0x8>
    800060f2:	4501                	li	a0,0
  return r;
}
    800060f4:	8082                	ret
{
    800060f6:	1101                	addi	sp,sp,-32
    800060f8:	ec06                	sd	ra,24(sp)
    800060fa:	e822                	sd	s0,16(sp)
    800060fc:	e426                	sd	s1,8(sp)
    800060fe:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006100:	6904                	ld	s1,16(a0)
    80006102:	ffffb097          	auipc	ra,0xffffb
    80006106:	d4a080e7          	jalr	-694(ra) # 80000e4c <mycpu>
    8000610a:	40a48533          	sub	a0,s1,a0
    8000610e:	00153513          	seqz	a0,a0
}
    80006112:	60e2                	ld	ra,24(sp)
    80006114:	6442                	ld	s0,16(sp)
    80006116:	64a2                	ld	s1,8(sp)
    80006118:	6105                	addi	sp,sp,32
    8000611a:	8082                	ret

000000008000611c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000611c:	1101                	addi	sp,sp,-32
    8000611e:	ec06                	sd	ra,24(sp)
    80006120:	e822                	sd	s0,16(sp)
    80006122:	e426                	sd	s1,8(sp)
    80006124:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006126:	100024f3          	csrr	s1,sstatus
    8000612a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000612e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006130:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006134:	ffffb097          	auipc	ra,0xffffb
    80006138:	d18080e7          	jalr	-744(ra) # 80000e4c <mycpu>
    8000613c:	5d3c                	lw	a5,120(a0)
    8000613e:	cf89                	beqz	a5,80006158 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006140:	ffffb097          	auipc	ra,0xffffb
    80006144:	d0c080e7          	jalr	-756(ra) # 80000e4c <mycpu>
    80006148:	5d3c                	lw	a5,120(a0)
    8000614a:	2785                	addiw	a5,a5,1
    8000614c:	dd3c                	sw	a5,120(a0)
}
    8000614e:	60e2                	ld	ra,24(sp)
    80006150:	6442                	ld	s0,16(sp)
    80006152:	64a2                	ld	s1,8(sp)
    80006154:	6105                	addi	sp,sp,32
    80006156:	8082                	ret
    mycpu()->intena = old;
    80006158:	ffffb097          	auipc	ra,0xffffb
    8000615c:	cf4080e7          	jalr	-780(ra) # 80000e4c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006160:	8085                	srli	s1,s1,0x1
    80006162:	8885                	andi	s1,s1,1
    80006164:	dd64                	sw	s1,124(a0)
    80006166:	bfe9                	j	80006140 <push_off+0x24>

0000000080006168 <acquire>:
{
    80006168:	1101                	addi	sp,sp,-32
    8000616a:	ec06                	sd	ra,24(sp)
    8000616c:	e822                	sd	s0,16(sp)
    8000616e:	e426                	sd	s1,8(sp)
    80006170:	1000                	addi	s0,sp,32
    80006172:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006174:	00000097          	auipc	ra,0x0
    80006178:	fa8080e7          	jalr	-88(ra) # 8000611c <push_off>
  if(holding(lk))
    8000617c:	8526                	mv	a0,s1
    8000617e:	00000097          	auipc	ra,0x0
    80006182:	f70080e7          	jalr	-144(ra) # 800060ee <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006186:	4705                	li	a4,1
  if(holding(lk))
    80006188:	e115                	bnez	a0,800061ac <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000618a:	87ba                	mv	a5,a4
    8000618c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006190:	2781                	sext.w	a5,a5
    80006192:	ffe5                	bnez	a5,8000618a <acquire+0x22>
  __sync_synchronize();
    80006194:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006198:	ffffb097          	auipc	ra,0xffffb
    8000619c:	cb4080e7          	jalr	-844(ra) # 80000e4c <mycpu>
    800061a0:	e888                	sd	a0,16(s1)
}
    800061a2:	60e2                	ld	ra,24(sp)
    800061a4:	6442                	ld	s0,16(sp)
    800061a6:	64a2                	ld	s1,8(sp)
    800061a8:	6105                	addi	sp,sp,32
    800061aa:	8082                	ret
    panic("acquire");
    800061ac:	00002517          	auipc	a0,0x2
    800061b0:	7b450513          	addi	a0,a0,1972 # 80008960 <digits+0x20>
    800061b4:	00000097          	auipc	ra,0x0
    800061b8:	a7c080e7          	jalr	-1412(ra) # 80005c30 <panic>

00000000800061bc <pop_off>:

void
pop_off(void)
{
    800061bc:	1141                	addi	sp,sp,-16
    800061be:	e406                	sd	ra,8(sp)
    800061c0:	e022                	sd	s0,0(sp)
    800061c2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061c4:	ffffb097          	auipc	ra,0xffffb
    800061c8:	c88080e7          	jalr	-888(ra) # 80000e4c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061cc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800061d0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800061d2:	e78d                	bnez	a5,800061fc <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800061d4:	5d3c                	lw	a5,120(a0)
    800061d6:	02f05b63          	blez	a5,8000620c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800061da:	37fd                	addiw	a5,a5,-1
    800061dc:	0007871b          	sext.w	a4,a5
    800061e0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800061e2:	eb09                	bnez	a4,800061f4 <pop_off+0x38>
    800061e4:	5d7c                	lw	a5,124(a0)
    800061e6:	c799                	beqz	a5,800061f4 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061e8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800061ec:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061f0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800061f4:	60a2                	ld	ra,8(sp)
    800061f6:	6402                	ld	s0,0(sp)
    800061f8:	0141                	addi	sp,sp,16
    800061fa:	8082                	ret
    panic("pop_off - interruptible");
    800061fc:	00002517          	auipc	a0,0x2
    80006200:	76c50513          	addi	a0,a0,1900 # 80008968 <digits+0x28>
    80006204:	00000097          	auipc	ra,0x0
    80006208:	a2c080e7          	jalr	-1492(ra) # 80005c30 <panic>
    panic("pop_off");
    8000620c:	00002517          	auipc	a0,0x2
    80006210:	77450513          	addi	a0,a0,1908 # 80008980 <digits+0x40>
    80006214:	00000097          	auipc	ra,0x0
    80006218:	a1c080e7          	jalr	-1508(ra) # 80005c30 <panic>

000000008000621c <release>:
{
    8000621c:	1101                	addi	sp,sp,-32
    8000621e:	ec06                	sd	ra,24(sp)
    80006220:	e822                	sd	s0,16(sp)
    80006222:	e426                	sd	s1,8(sp)
    80006224:	1000                	addi	s0,sp,32
    80006226:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006228:	00000097          	auipc	ra,0x0
    8000622c:	ec6080e7          	jalr	-314(ra) # 800060ee <holding>
    80006230:	c115                	beqz	a0,80006254 <release+0x38>
  lk->cpu = 0;
    80006232:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006236:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000623a:	0f50000f          	fence	iorw,ow
    8000623e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006242:	00000097          	auipc	ra,0x0
    80006246:	f7a080e7          	jalr	-134(ra) # 800061bc <pop_off>
}
    8000624a:	60e2                	ld	ra,24(sp)
    8000624c:	6442                	ld	s0,16(sp)
    8000624e:	64a2                	ld	s1,8(sp)
    80006250:	6105                	addi	sp,sp,32
    80006252:	8082                	ret
    panic("release");
    80006254:	00002517          	auipc	a0,0x2
    80006258:	73450513          	addi	a0,a0,1844 # 80008988 <digits+0x48>
    8000625c:	00000097          	auipc	ra,0x0
    80006260:	9d4080e7          	jalr	-1580(ra) # 80005c30 <panic>
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
