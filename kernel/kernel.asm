
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	85013103          	ld	sp,-1968(sp) # 80008850 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1dd050ef          	jal	ra,800059f2 <start>

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
    80000030:	00034797          	auipc	a5,0x34
    80000034:	21078793          	addi	a5,a5,528 # 80034240 <end>
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
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	37e080e7          	jalr	894(ra) # 800063d8 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	41e080e7          	jalr	1054(ra) # 8000648c <release>
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
    8000008e:	e16080e7          	jalr	-490(ra) # 80005ea0 <panic>

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
    800000fa:	252080e7          	jalr	594(ra) # 80006348 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00034517          	auipc	a0,0x34
    80000106:	13e50513          	addi	a0,a0,318 # 80034240 <end>
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
    80000132:	2aa080e7          	jalr	682(ra) # 800063d8 <acquire>
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
    8000014a:	346080e7          	jalr	838(ra) # 8000648c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
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
    80000174:	31c080e7          	jalr	796(ra) # 8000648c <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffcadc1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    *s++ = 0;
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int
strlen(const char *s)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	ad6080e7          	jalr	-1322(ra) # 80000dfe <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00009717          	auipc	a4,0x9
    80000334:	cd070713          	addi	a4,a4,-816 # 80009000 <started>
  if(cpuid() == 0){
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while(started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	aba080e7          	jalr	-1350(ra) # 80000dfe <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	b94080e7          	jalr	-1132(ra) # 80005eea <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	71a080e7          	jalr	1818(ra) # 80001a80 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	062080e7          	jalr	98(ra) # 800053d0 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	fc6080e7          	jalr	-58(ra) # 8000133c <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	a32080e7          	jalr	-1486(ra) # 80005db0 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	d44080e7          	jalr	-700(ra) # 800060ca <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	b54080e7          	jalr	-1196(ra) # 80005eea <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	b44080e7          	jalr	-1212(ra) # 80005eea <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	b34080e7          	jalr	-1228(ra) # 80005eea <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	322080e7          	jalr	802(ra) # 800006e8 <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	978080e7          	jalr	-1672(ra) # 80000d4e <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	67a080e7          	jalr	1658(ra) # 80001a58 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	69a080e7          	jalr	1690(ra) # 80001a80 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	fcc080e7          	jalr	-52(ra) # 800053ba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	fda080e7          	jalr	-38(ra) # 800053d0 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	f86080e7          	jalr	-122(ra) # 80002384 <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	614080e7          	jalr	1556(ra) # 80002a1a <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	5c6080e7          	jalr	1478(ra) # 800039d4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	0da080e7          	jalr	218(ra) # 800054f0 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	ce4080e7          	jalr	-796(ra) # 80001102 <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00009717          	auipc	a4,0x9
    80000430:	bcf72a23          	sw	a5,-1068(a4) # 80009000 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000043c:	00009797          	auipc	a5,0x9
    80000440:	bcc7b783          	ld	a5,-1076(a5) # 80009008 <kernel_pagetable>
    80000444:	83b1                	srli	a5,a5,0xc
    80000446:	577d                	li	a4,-1
    80000448:	177e                	slli	a4,a4,0x3f
    8000044a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000450:	12000073          	sfence.vma
  sfence_vma();
}
    80000454:	6422                	ld	s0,8(sp)
    80000456:	0141                	addi	sp,sp,16
    80000458:	8082                	ret

000000008000045a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045a:	7139                	addi	sp,sp,-64
    8000045c:	fc06                	sd	ra,56(sp)
    8000045e:	f822                	sd	s0,48(sp)
    80000460:	f426                	sd	s1,40(sp)
    80000462:	f04a                	sd	s2,32(sp)
    80000464:	ec4e                	sd	s3,24(sp)
    80000466:	e852                	sd	s4,16(sp)
    80000468:	e456                	sd	s5,8(sp)
    8000046a:	e05a                	sd	s6,0(sp)
    8000046c:	0080                	addi	s0,sp,64
    8000046e:	84aa                	mv	s1,a0
    80000470:	89ae                	mv	s3,a1
    80000472:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000474:	57fd                	li	a5,-1
    80000476:	83e9                	srli	a5,a5,0x1a
    80000478:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047c:	04b7f263          	bgeu	a5,a1,800004c0 <walk+0x66>
    panic("walk");
    80000480:	00008517          	auipc	a0,0x8
    80000484:	bd050513          	addi	a0,a0,-1072 # 80008050 <etext+0x50>
    80000488:	00006097          	auipc	ra,0x6
    8000048c:	a18080e7          	jalr	-1512(ra) # 80005ea0 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000490:	060a8663          	beqz	s5,800004fc <walk+0xa2>
    80000494:	00000097          	auipc	ra,0x0
    80000498:	c86080e7          	jalr	-890(ra) # 8000011a <kalloc>
    8000049c:	84aa                	mv	s1,a0
    8000049e:	c529                	beqz	a0,800004e8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a0:	6605                	lui	a2,0x1
    800004a2:	4581                	li	a1,0
    800004a4:	00000097          	auipc	ra,0x0
    800004a8:	cd6080e7          	jalr	-810(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ac:	00c4d793          	srli	a5,s1,0xc
    800004b0:	07aa                	slli	a5,a5,0xa
    800004b2:	0017e793          	ori	a5,a5,1
    800004b6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004ba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffcadb7>
    800004bc:	036a0063          	beq	s4,s6,800004dc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c0:	0149d933          	srl	s2,s3,s4
    800004c4:	1ff97913          	andi	s2,s2,511
    800004c8:	090e                	slli	s2,s2,0x3
    800004ca:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004cc:	00093483          	ld	s1,0(s2)
    800004d0:	0014f793          	andi	a5,s1,1
    800004d4:	dfd5                	beqz	a5,80000490 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d6:	80a9                	srli	s1,s1,0xa
    800004d8:	04b2                	slli	s1,s1,0xc
    800004da:	b7c5                	j	800004ba <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004dc:	00c9d513          	srli	a0,s3,0xc
    800004e0:	1ff57513          	andi	a0,a0,511
    800004e4:	050e                	slli	a0,a0,0x3
    800004e6:	9526                	add	a0,a0,s1
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	74a2                	ld	s1,40(sp)
    800004ee:	7902                	ld	s2,32(sp)
    800004f0:	69e2                	ld	s3,24(sp)
    800004f2:	6a42                	ld	s4,16(sp)
    800004f4:	6aa2                	ld	s5,8(sp)
    800004f6:	6b02                	ld	s6,0(sp)
    800004f8:	6121                	addi	sp,sp,64
    800004fa:	8082                	ret
        return 0;
    800004fc:	4501                	li	a0,0
    800004fe:	b7ed                	j	800004e8 <walk+0x8e>

0000000080000500 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000500:	57fd                	li	a5,-1
    80000502:	83e9                	srli	a5,a5,0x1a
    80000504:	00b7f463          	bgeu	a5,a1,8000050c <walkaddr+0xc>
    return 0;
    80000508:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050a:	8082                	ret
{
    8000050c:	1141                	addi	sp,sp,-16
    8000050e:	e406                	sd	ra,8(sp)
    80000510:	e022                	sd	s0,0(sp)
    80000512:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000514:	4601                	li	a2,0
    80000516:	00000097          	auipc	ra,0x0
    8000051a:	f44080e7          	jalr	-188(ra) # 8000045a <walk>
  if(pte == 0)
    8000051e:	c105                	beqz	a0,8000053e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000520:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000522:	0117f693          	andi	a3,a5,17
    80000526:	4745                	li	a4,17
    return 0;
    80000528:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052a:	00e68663          	beq	a3,a4,80000536 <walkaddr+0x36>
}
    8000052e:	60a2                	ld	ra,8(sp)
    80000530:	6402                	ld	s0,0(sp)
    80000532:	0141                	addi	sp,sp,16
    80000534:	8082                	ret
  pa = PTE2PA(*pte);
    80000536:	83a9                	srli	a5,a5,0xa
    80000538:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053c:	bfcd                	j	8000052e <walkaddr+0x2e>
    return 0;
    8000053e:	4501                	li	a0,0
    80000540:	b7fd                	j	8000052e <walkaddr+0x2e>

0000000080000542 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000542:	715d                	addi	sp,sp,-80
    80000544:	e486                	sd	ra,72(sp)
    80000546:	e0a2                	sd	s0,64(sp)
    80000548:	fc26                	sd	s1,56(sp)
    8000054a:	f84a                	sd	s2,48(sp)
    8000054c:	f44e                	sd	s3,40(sp)
    8000054e:	f052                	sd	s4,32(sp)
    80000550:	ec56                	sd	s5,24(sp)
    80000552:	e85a                	sd	s6,16(sp)
    80000554:	e45e                	sd	s7,8(sp)
    80000556:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000558:	c639                	beqz	a2,800005a6 <mappages+0x64>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000055e:	777d                	lui	a4,0xfffff
    80000560:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000564:	fff58993          	addi	s3,a1,-1
    80000568:	99b2                	add	s3,s3,a2
    8000056a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000056e:	893e                	mv	s2,a5
    80000570:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	eda080e7          	jalr	-294(ra) # 8000045a <walk>
    80000588:	cd1d                	beqz	a0,800005c6 <mappages+0x84>
    if(*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e785                	bnez	a5,800005b6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059e:	05390063          	beq	s2,s3,800005de <mappages+0x9c>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x34>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	8f2080e7          	jalr	-1806(ra) # 80005ea0 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	8e2080e7          	jalr	-1822(ra) # 80005ea0 <panic>
      return -1;
    800005c6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c8:	60a6                	ld	ra,72(sp)
    800005ca:	6406                	ld	s0,64(sp)
    800005cc:	74e2                	ld	s1,56(sp)
    800005ce:	7942                	ld	s2,48(sp)
    800005d0:	79a2                	ld	s3,40(sp)
    800005d2:	7a02                	ld	s4,32(sp)
    800005d4:	6ae2                	ld	s5,24(sp)
    800005d6:	6b42                	ld	s6,16(sp)
    800005d8:	6ba2                	ld	s7,8(sp)
    800005da:	6161                	addi	sp,sp,80
    800005dc:	8082                	ret
  return 0;
    800005de:	4501                	li	a0,0
    800005e0:	b7e5                	j	800005c8 <mappages+0x86>

00000000800005e2 <kvmmap>:
{
    800005e2:	1141                	addi	sp,sp,-16
    800005e4:	e406                	sd	ra,8(sp)
    800005e6:	e022                	sd	s0,0(sp)
    800005e8:	0800                	addi	s0,sp,16
    800005ea:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ec:	86b2                	mv	a3,a2
    800005ee:	863e                	mv	a2,a5
    800005f0:	00000097          	auipc	ra,0x0
    800005f4:	f52080e7          	jalr	-174(ra) # 80000542 <mappages>
    800005f8:	e509                	bnez	a0,80000602 <kvmmap+0x20>
}
    800005fa:	60a2                	ld	ra,8(sp)
    800005fc:	6402                	ld	s0,0(sp)
    800005fe:	0141                	addi	sp,sp,16
    80000600:	8082                	ret
    panic("kvmmap");
    80000602:	00008517          	auipc	a0,0x8
    80000606:	a7650513          	addi	a0,a0,-1418 # 80008078 <etext+0x78>
    8000060a:	00006097          	auipc	ra,0x6
    8000060e:	896080e7          	jalr	-1898(ra) # 80005ea0 <panic>

0000000080000612 <kvmmake>:
{
    80000612:	1101                	addi	sp,sp,-32
    80000614:	ec06                	sd	ra,24(sp)
    80000616:	e822                	sd	s0,16(sp)
    80000618:	e426                	sd	s1,8(sp)
    8000061a:	e04a                	sd	s2,0(sp)
    8000061c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	afc080e7          	jalr	-1284(ra) # 8000011a <kalloc>
    80000626:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000628:	6605                	lui	a2,0x1
    8000062a:	4581                	li	a1,0
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	b4e080e7          	jalr	-1202(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000634:	4719                	li	a4,6
    80000636:	6685                	lui	a3,0x1
    80000638:	10000637          	lui	a2,0x10000
    8000063c:	100005b7          	lui	a1,0x10000
    80000640:	8526                	mv	a0,s1
    80000642:	00000097          	auipc	ra,0x0
    80000646:	fa0080e7          	jalr	-96(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064a:	4719                	li	a4,6
    8000064c:	6685                	lui	a3,0x1
    8000064e:	10001637          	lui	a2,0x10001
    80000652:	100015b7          	lui	a1,0x10001
    80000656:	8526                	mv	a0,s1
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	f8a080e7          	jalr	-118(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000660:	4719                	li	a4,6
    80000662:	004006b7          	lui	a3,0x400
    80000666:	0c000637          	lui	a2,0xc000
    8000066a:	0c0005b7          	lui	a1,0xc000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	f72080e7          	jalr	-142(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000678:	00008917          	auipc	s2,0x8
    8000067c:	98890913          	addi	s2,s2,-1656 # 80008000 <etext>
    80000680:	4729                	li	a4,10
    80000682:	80008697          	auipc	a3,0x80008
    80000686:	97e68693          	addi	a3,a3,-1666 # 8000 <_entry-0x7fff8000>
    8000068a:	4605                	li	a2,1
    8000068c:	067e                	slli	a2,a2,0x1f
    8000068e:	85b2                	mv	a1,a2
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	f50080e7          	jalr	-176(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	46c5                	li	a3,17
    8000069e:	06ee                	slli	a3,a3,0x1b
    800006a0:	412686b3          	sub	a3,a3,s2
    800006a4:	864a                	mv	a2,s2
    800006a6:	85ca                	mv	a1,s2
    800006a8:	8526                	mv	a0,s1
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	f38080e7          	jalr	-200(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b2:	4729                	li	a4,10
    800006b4:	6685                	lui	a3,0x1
    800006b6:	00007617          	auipc	a2,0x7
    800006ba:	94a60613          	addi	a2,a2,-1718 # 80007000 <_trampoline>
    800006be:	040005b7          	lui	a1,0x4000
    800006c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c4:	05b2                	slli	a1,a1,0xc
    800006c6:	8526                	mv	a0,s1
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	f1a080e7          	jalr	-230(ra) # 800005e2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	5e6080e7          	jalr	1510(ra) # 80000cb8 <proc_mapstacks>
}
    800006da:	8526                	mv	a0,s1
    800006dc:	60e2                	ld	ra,24(sp)
    800006de:	6442                	ld	s0,16(sp)
    800006e0:	64a2                	ld	s1,8(sp)
    800006e2:	6902                	ld	s2,0(sp)
    800006e4:	6105                	addi	sp,sp,32
    800006e6:	8082                	ret

00000000800006e8 <kvminit>:
{
    800006e8:	1141                	addi	sp,sp,-16
    800006ea:	e406                	sd	ra,8(sp)
    800006ec:	e022                	sd	s0,0(sp)
    800006ee:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	f22080e7          	jalr	-222(ra) # 80000612 <kvmmake>
    800006f8:	00009797          	auipc	a5,0x9
    800006fc:	90a7b823          	sd	a0,-1776(a5) # 80009008 <kernel_pagetable>
}
    80000700:	60a2                	ld	ra,8(sp)
    80000702:	6402                	ld	s0,0(sp)
    80000704:	0141                	addi	sp,sp,16
    80000706:	8082                	ret

0000000080000708 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000708:	715d                	addi	sp,sp,-80
    8000070a:	e486                	sd	ra,72(sp)
    8000070c:	e0a2                	sd	s0,64(sp)
    8000070e:	fc26                	sd	s1,56(sp)
    80000710:	f84a                	sd	s2,48(sp)
    80000712:	f44e                	sd	s3,40(sp)
    80000714:	f052                	sd	s4,32(sp)
    80000716:	ec56                	sd	s5,24(sp)
    80000718:	e85a                	sd	s6,16(sp)
    8000071a:	e45e                	sd	s7,8(sp)
    8000071c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000071e:	03459793          	slli	a5,a1,0x34
    80000722:	e795                	bnez	a5,8000074e <uvmunmap+0x46>
    80000724:	8a2a                	mv	s4,a0
    80000726:	892e                	mv	s2,a1
    80000728:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072a:	0632                	slli	a2,a2,0xc
    8000072c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      continue;
      //panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000730:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000732:	6a85                	lui	s5,0x1
    80000734:	0535ea63          	bltu	a1,s3,80000788 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000738:	60a6                	ld	ra,72(sp)
    8000073a:	6406                	ld	s0,64(sp)
    8000073c:	74e2                	ld	s1,56(sp)
    8000073e:	7942                	ld	s2,48(sp)
    80000740:	79a2                	ld	s3,40(sp)
    80000742:	7a02                	ld	s4,32(sp)
    80000744:	6ae2                	ld	s5,24(sp)
    80000746:	6b42                	ld	s6,16(sp)
    80000748:	6ba2                	ld	s7,8(sp)
    8000074a:	6161                	addi	sp,sp,80
    8000074c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000074e:	00008517          	auipc	a0,0x8
    80000752:	93250513          	addi	a0,a0,-1742 # 80008080 <etext+0x80>
    80000756:	00005097          	auipc	ra,0x5
    8000075a:	74a080e7          	jalr	1866(ra) # 80005ea0 <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00005097          	auipc	ra,0x5
    8000076a:	73a080e7          	jalr	1850(ra) # 80005ea0 <panic>
      panic("uvmunmap: not a leaf");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00005097          	auipc	ra,0x5
    8000077a:	72a080e7          	jalr	1834(ra) # 80005ea0 <panic>
    *pte = 0;
    8000077e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000782:	9956                	add	s2,s2,s5
    80000784:	fb397ae3          	bgeu	s2,s3,80000738 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000788:	4601                	li	a2,0
    8000078a:	85ca                	mv	a1,s2
    8000078c:	8552                	mv	a0,s4
    8000078e:	00000097          	auipc	ra,0x0
    80000792:	ccc080e7          	jalr	-820(ra) # 8000045a <walk>
    80000796:	84aa                	mv	s1,a0
    80000798:	d179                	beqz	a0,8000075e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000079a:	611c                	ld	a5,0(a0)
    8000079c:	0017f713          	andi	a4,a5,1
    800007a0:	d36d                	beqz	a4,80000782 <uvmunmap+0x7a>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007a2:	3ff7f713          	andi	a4,a5,1023
    800007a6:	fd7704e3          	beq	a4,s7,8000076e <uvmunmap+0x66>
    if(do_free){
    800007aa:	fc0b0ae3          	beqz	s6,8000077e <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    800007ae:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800007b0:	00c79513          	slli	a0,a5,0xc
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	868080e7          	jalr	-1944(ra) # 8000001c <kfree>
    800007bc:	b7c9                	j	8000077e <uvmunmap+0x76>

00000000800007be <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007be:	1101                	addi	sp,sp,-32
    800007c0:	ec06                	sd	ra,24(sp)
    800007c2:	e822                	sd	s0,16(sp)
    800007c4:	e426                	sd	s1,8(sp)
    800007c6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007c8:	00000097          	auipc	ra,0x0
    800007cc:	952080e7          	jalr	-1710(ra) # 8000011a <kalloc>
    800007d0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007d2:	c519                	beqz	a0,800007e0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007d4:	6605                	lui	a2,0x1
    800007d6:	4581                	li	a1,0
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	9a2080e7          	jalr	-1630(ra) # 8000017a <memset>
  return pagetable;
}
    800007e0:	8526                	mv	a0,s1
    800007e2:	60e2                	ld	ra,24(sp)
    800007e4:	6442                	ld	s0,16(sp)
    800007e6:	64a2                	ld	s1,8(sp)
    800007e8:	6105                	addi	sp,sp,32
    800007ea:	8082                	ret

00000000800007ec <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007ec:	7179                	addi	sp,sp,-48
    800007ee:	f406                	sd	ra,40(sp)
    800007f0:	f022                	sd	s0,32(sp)
    800007f2:	ec26                	sd	s1,24(sp)
    800007f4:	e84a                	sd	s2,16(sp)
    800007f6:	e44e                	sd	s3,8(sp)
    800007f8:	e052                	sd	s4,0(sp)
    800007fa:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800007fc:	6785                	lui	a5,0x1
    800007fe:	04f67863          	bgeu	a2,a5,8000084e <uvminit+0x62>
    80000802:	8a2a                	mv	s4,a0
    80000804:	89ae                	mv	s3,a1
    80000806:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000808:	00000097          	auipc	ra,0x0
    8000080c:	912080e7          	jalr	-1774(ra) # 8000011a <kalloc>
    80000810:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000812:	6605                	lui	a2,0x1
    80000814:	4581                	li	a1,0
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	964080e7          	jalr	-1692(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000081e:	4779                	li	a4,30
    80000820:	86ca                	mv	a3,s2
    80000822:	6605                	lui	a2,0x1
    80000824:	4581                	li	a1,0
    80000826:	8552                	mv	a0,s4
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	d1a080e7          	jalr	-742(ra) # 80000542 <mappages>
  memmove(mem, src, sz);
    80000830:	8626                	mv	a2,s1
    80000832:	85ce                	mv	a1,s3
    80000834:	854a                	mv	a0,s2
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	9a0080e7          	jalr	-1632(ra) # 800001d6 <memmove>
}
    8000083e:	70a2                	ld	ra,40(sp)
    80000840:	7402                	ld	s0,32(sp)
    80000842:	64e2                	ld	s1,24(sp)
    80000844:	6942                	ld	s2,16(sp)
    80000846:	69a2                	ld	s3,8(sp)
    80000848:	6a02                	ld	s4,0(sp)
    8000084a:	6145                	addi	sp,sp,48
    8000084c:	8082                	ret
    panic("inituvm: more than a page");
    8000084e:	00008517          	auipc	a0,0x8
    80000852:	87250513          	addi	a0,a0,-1934 # 800080c0 <etext+0xc0>
    80000856:	00005097          	auipc	ra,0x5
    8000085a:	64a080e7          	jalr	1610(ra) # 80005ea0 <panic>

000000008000085e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000085e:	1101                	addi	sp,sp,-32
    80000860:	ec06                	sd	ra,24(sp)
    80000862:	e822                	sd	s0,16(sp)
    80000864:	e426                	sd	s1,8(sp)
    80000866:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000868:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000086a:	00b67d63          	bgeu	a2,a1,80000884 <uvmdealloc+0x26>
    8000086e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000870:	6785                	lui	a5,0x1
    80000872:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000874:	00f60733          	add	a4,a2,a5
    80000878:	76fd                	lui	a3,0xfffff
    8000087a:	8f75                	and	a4,a4,a3
    8000087c:	97ae                	add	a5,a5,a1
    8000087e:	8ff5                	and	a5,a5,a3
    80000880:	00f76863          	bltu	a4,a5,80000890 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000884:	8526                	mv	a0,s1
    80000886:	60e2                	ld	ra,24(sp)
    80000888:	6442                	ld	s0,16(sp)
    8000088a:	64a2                	ld	s1,8(sp)
    8000088c:	6105                	addi	sp,sp,32
    8000088e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000890:	8f99                	sub	a5,a5,a4
    80000892:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000894:	4685                	li	a3,1
    80000896:	0007861b          	sext.w	a2,a5
    8000089a:	85ba                	mv	a1,a4
    8000089c:	00000097          	auipc	ra,0x0
    800008a0:	e6c080e7          	jalr	-404(ra) # 80000708 <uvmunmap>
    800008a4:	b7c5                	j	80000884 <uvmdealloc+0x26>

00000000800008a6 <uvmalloc>:
  if(newsz < oldsz)
    800008a6:	0ab66163          	bltu	a2,a1,80000948 <uvmalloc+0xa2>
{
    800008aa:	7139                	addi	sp,sp,-64
    800008ac:	fc06                	sd	ra,56(sp)
    800008ae:	f822                	sd	s0,48(sp)
    800008b0:	f426                	sd	s1,40(sp)
    800008b2:	f04a                	sd	s2,32(sp)
    800008b4:	ec4e                	sd	s3,24(sp)
    800008b6:	e852                	sd	s4,16(sp)
    800008b8:	e456                	sd	s5,8(sp)
    800008ba:	0080                	addi	s0,sp,64
    800008bc:	8aaa                	mv	s5,a0
    800008be:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008c0:	6785                	lui	a5,0x1
    800008c2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008c4:	95be                	add	a1,a1,a5
    800008c6:	77fd                	lui	a5,0xfffff
    800008c8:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008cc:	08c9f063          	bgeu	s3,a2,8000094c <uvmalloc+0xa6>
    800008d0:	894e                	mv	s2,s3
    mem = kalloc();
    800008d2:	00000097          	auipc	ra,0x0
    800008d6:	848080e7          	jalr	-1976(ra) # 8000011a <kalloc>
    800008da:	84aa                	mv	s1,a0
    if(mem == 0){
    800008dc:	c51d                	beqz	a0,8000090a <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008de:	6605                	lui	a2,0x1
    800008e0:	4581                	li	a1,0
    800008e2:	00000097          	auipc	ra,0x0
    800008e6:	898080e7          	jalr	-1896(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008ea:	4779                	li	a4,30
    800008ec:	86a6                	mv	a3,s1
    800008ee:	6605                	lui	a2,0x1
    800008f0:	85ca                	mv	a1,s2
    800008f2:	8556                	mv	a0,s5
    800008f4:	00000097          	auipc	ra,0x0
    800008f8:	c4e080e7          	jalr	-946(ra) # 80000542 <mappages>
    800008fc:	e905                	bnez	a0,8000092c <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008fe:	6785                	lui	a5,0x1
    80000900:	993e                	add	s2,s2,a5
    80000902:	fd4968e3          	bltu	s2,s4,800008d2 <uvmalloc+0x2c>
  return newsz;
    80000906:	8552                	mv	a0,s4
    80000908:	a809                	j	8000091a <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000090a:	864e                	mv	a2,s3
    8000090c:	85ca                	mv	a1,s2
    8000090e:	8556                	mv	a0,s5
    80000910:	00000097          	auipc	ra,0x0
    80000914:	f4e080e7          	jalr	-178(ra) # 8000085e <uvmdealloc>
      return 0;
    80000918:	4501                	li	a0,0
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6121                	addi	sp,sp,64
    8000092a:	8082                	ret
      kfree(mem);
    8000092c:	8526                	mv	a0,s1
    8000092e:	fffff097          	auipc	ra,0xfffff
    80000932:	6ee080e7          	jalr	1774(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000936:	864e                	mv	a2,s3
    80000938:	85ca                	mv	a1,s2
    8000093a:	8556                	mv	a0,s5
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	f22080e7          	jalr	-222(ra) # 8000085e <uvmdealloc>
      return 0;
    80000944:	4501                	li	a0,0
    80000946:	bfd1                	j	8000091a <uvmalloc+0x74>
    return oldsz;
    80000948:	852e                	mv	a0,a1
}
    8000094a:	8082                	ret
  return newsz;
    8000094c:	8532                	mv	a0,a2
    8000094e:	b7f1                	j	8000091a <uvmalloc+0x74>

0000000080000950 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000950:	7179                	addi	sp,sp,-48
    80000952:	f406                	sd	ra,40(sp)
    80000954:	f022                	sd	s0,32(sp)
    80000956:	ec26                	sd	s1,24(sp)
    80000958:	e84a                	sd	s2,16(sp)
    8000095a:	e44e                	sd	s3,8(sp)
    8000095c:	e052                	sd	s4,0(sp)
    8000095e:	1800                	addi	s0,sp,48
    80000960:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000962:	84aa                	mv	s1,a0
    80000964:	6905                	lui	s2,0x1
    80000966:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000968:	4985                	li	s3,1
    8000096a:	a829                	j	80000984 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000096c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000096e:	00c79513          	slli	a0,a5,0xc
    80000972:	00000097          	auipc	ra,0x0
    80000976:	fde080e7          	jalr	-34(ra) # 80000950 <freewalk>
      pagetable[i] = 0;
    8000097a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000097e:	04a1                	addi	s1,s1,8
    80000980:	03248163          	beq	s1,s2,800009a2 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000984:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000986:	00f7f713          	andi	a4,a5,15
    8000098a:	ff3701e3          	beq	a4,s3,8000096c <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000098e:	8b85                	andi	a5,a5,1
    80000990:	d7fd                	beqz	a5,8000097e <freewalk+0x2e>
      panic("freewalk: leaf");
    80000992:	00007517          	auipc	a0,0x7
    80000996:	74e50513          	addi	a0,a0,1870 # 800080e0 <etext+0xe0>
    8000099a:	00005097          	auipc	ra,0x5
    8000099e:	506080e7          	jalr	1286(ra) # 80005ea0 <panic>
    }
  }
  kfree((void*)pagetable);
    800009a2:	8552                	mv	a0,s4
    800009a4:	fffff097          	auipc	ra,0xfffff
    800009a8:	678080e7          	jalr	1656(ra) # 8000001c <kfree>
}
    800009ac:	70a2                	ld	ra,40(sp)
    800009ae:	7402                	ld	s0,32(sp)
    800009b0:	64e2                	ld	s1,24(sp)
    800009b2:	6942                	ld	s2,16(sp)
    800009b4:	69a2                	ld	s3,8(sp)
    800009b6:	6a02                	ld	s4,0(sp)
    800009b8:	6145                	addi	sp,sp,48
    800009ba:	8082                	ret

00000000800009bc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009bc:	1101                	addi	sp,sp,-32
    800009be:	ec06                	sd	ra,24(sp)
    800009c0:	e822                	sd	s0,16(sp)
    800009c2:	e426                	sd	s1,8(sp)
    800009c4:	1000                	addi	s0,sp,32
    800009c6:	84aa                	mv	s1,a0
  if(sz > 0)
    800009c8:	e999                	bnez	a1,800009de <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009ca:	8526                	mv	a0,s1
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	f84080e7          	jalr	-124(ra) # 80000950 <freewalk>
}
    800009d4:	60e2                	ld	ra,24(sp)
    800009d6:	6442                	ld	s0,16(sp)
    800009d8:	64a2                	ld	s1,8(sp)
    800009da:	6105                	addi	sp,sp,32
    800009dc:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009de:	6785                	lui	a5,0x1
    800009e0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009e2:	95be                	add	a1,a1,a5
    800009e4:	4685                	li	a3,1
    800009e6:	00c5d613          	srli	a2,a1,0xc
    800009ea:	4581                	li	a1,0
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	d1c080e7          	jalr	-740(ra) # 80000708 <uvmunmap>
    800009f4:	bfd9                	j	800009ca <uvmfree+0xe>

00000000800009f6 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800009f6:	c269                	beqz	a2,80000ab8 <uvmcopy+0xc2>
{
    800009f8:	715d                	addi	sp,sp,-80
    800009fa:	e486                	sd	ra,72(sp)
    800009fc:	e0a2                	sd	s0,64(sp)
    800009fe:	fc26                	sd	s1,56(sp)
    80000a00:	f84a                	sd	s2,48(sp)
    80000a02:	f44e                	sd	s3,40(sp)
    80000a04:	f052                	sd	s4,32(sp)
    80000a06:	ec56                	sd	s5,24(sp)
    80000a08:	e85a                	sd	s6,16(sp)
    80000a0a:	e45e                	sd	s7,8(sp)
    80000a0c:	0880                	addi	s0,sp,80
    80000a0e:	8aaa                	mv	s5,a0
    80000a10:	8b2e                	mv	s6,a1
    80000a12:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a14:	4481                	li	s1,0
    80000a16:	a829                	j	80000a30 <uvmcopy+0x3a>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000a18:	00007517          	auipc	a0,0x7
    80000a1c:	6d850513          	addi	a0,a0,1752 # 800080f0 <etext+0xf0>
    80000a20:	00005097          	auipc	ra,0x5
    80000a24:	480080e7          	jalr	1152(ra) # 80005ea0 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    80000a28:	6785                	lui	a5,0x1
    80000a2a:	94be                	add	s1,s1,a5
    80000a2c:	0944f463          	bgeu	s1,s4,80000ab4 <uvmcopy+0xbe>
    if((pte = walk(old, i, 0)) == 0)
    80000a30:	4601                	li	a2,0
    80000a32:	85a6                	mv	a1,s1
    80000a34:	8556                	mv	a0,s5
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	a24080e7          	jalr	-1500(ra) # 8000045a <walk>
    80000a3e:	dd69                	beqz	a0,80000a18 <uvmcopy+0x22>
    if((*pte & PTE_V) == 0)
    80000a40:	6118                	ld	a4,0(a0)
    80000a42:	00177793          	andi	a5,a4,1
    80000a46:	d3ed                	beqz	a5,80000a28 <uvmcopy+0x32>
      //panic("uvmcopy: page not present");
      continue;
    pa = PTE2PA(*pte);
    80000a48:	00a75593          	srli	a1,a4,0xa
    80000a4c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a50:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    80000a54:	fffff097          	auipc	ra,0xfffff
    80000a58:	6c6080e7          	jalr	1734(ra) # 8000011a <kalloc>
    80000a5c:	89aa                	mv	s3,a0
    80000a5e:	c515                	beqz	a0,80000a8a <uvmcopy+0x94>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a60:	6605                	lui	a2,0x1
    80000a62:	85de                	mv	a1,s7
    80000a64:	fffff097          	auipc	ra,0xfffff
    80000a68:	772080e7          	jalr	1906(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6c:	874a                	mv	a4,s2
    80000a6e:	86ce                	mv	a3,s3
    80000a70:	6605                	lui	a2,0x1
    80000a72:	85a6                	mv	a1,s1
    80000a74:	855a                	mv	a0,s6
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	acc080e7          	jalr	-1332(ra) # 80000542 <mappages>
    80000a7e:	d54d                	beqz	a0,80000a28 <uvmcopy+0x32>
      kfree(mem);
    80000a80:	854e                	mv	a0,s3
    80000a82:	fffff097          	auipc	ra,0xfffff
    80000a86:	59a080e7          	jalr	1434(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a8a:	4685                	li	a3,1
    80000a8c:	00c4d613          	srli	a2,s1,0xc
    80000a90:	4581                	li	a1,0
    80000a92:	855a                	mv	a0,s6
    80000a94:	00000097          	auipc	ra,0x0
    80000a98:	c74080e7          	jalr	-908(ra) # 80000708 <uvmunmap>
  return -1;
    80000a9c:	557d                	li	a0,-1
}
    80000a9e:	60a6                	ld	ra,72(sp)
    80000aa0:	6406                	ld	s0,64(sp)
    80000aa2:	74e2                	ld	s1,56(sp)
    80000aa4:	7942                	ld	s2,48(sp)
    80000aa6:	79a2                	ld	s3,40(sp)
    80000aa8:	7a02                	ld	s4,32(sp)
    80000aaa:	6ae2                	ld	s5,24(sp)
    80000aac:	6b42                	ld	s6,16(sp)
    80000aae:	6ba2                	ld	s7,8(sp)
    80000ab0:	6161                	addi	sp,sp,80
    80000ab2:	8082                	ret
  return 0;
    80000ab4:	4501                	li	a0,0
    80000ab6:	b7e5                	j	80000a9e <uvmcopy+0xa8>
    80000ab8:	4501                	li	a0,0
}
    80000aba:	8082                	ret

0000000080000abc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000abc:	1141                	addi	sp,sp,-16
    80000abe:	e406                	sd	ra,8(sp)
    80000ac0:	e022                	sd	s0,0(sp)
    80000ac2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ac4:	4601                	li	a2,0
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	994080e7          	jalr	-1644(ra) # 8000045a <walk>
  if(pte == 0)
    80000ace:	c901                	beqz	a0,80000ade <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ad0:	611c                	ld	a5,0(a0)
    80000ad2:	9bbd                	andi	a5,a5,-17
    80000ad4:	e11c                	sd	a5,0(a0)
}
    80000ad6:	60a2                	ld	ra,8(sp)
    80000ad8:	6402                	ld	s0,0(sp)
    80000ada:	0141                	addi	sp,sp,16
    80000adc:	8082                	ret
    panic("uvmclear");
    80000ade:	00007517          	auipc	a0,0x7
    80000ae2:	63250513          	addi	a0,a0,1586 # 80008110 <etext+0x110>
    80000ae6:	00005097          	auipc	ra,0x5
    80000aea:	3ba080e7          	jalr	954(ra) # 80005ea0 <panic>

0000000080000aee <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000aee:	c6bd                	beqz	a3,80000b5c <copyout+0x6e>
{
    80000af0:	715d                	addi	sp,sp,-80
    80000af2:	e486                	sd	ra,72(sp)
    80000af4:	e0a2                	sd	s0,64(sp)
    80000af6:	fc26                	sd	s1,56(sp)
    80000af8:	f84a                	sd	s2,48(sp)
    80000afa:	f44e                	sd	s3,40(sp)
    80000afc:	f052                	sd	s4,32(sp)
    80000afe:	ec56                	sd	s5,24(sp)
    80000b00:	e85a                	sd	s6,16(sp)
    80000b02:	e45e                	sd	s7,8(sp)
    80000b04:	e062                	sd	s8,0(sp)
    80000b06:	0880                	addi	s0,sp,80
    80000b08:	8b2a                	mv	s6,a0
    80000b0a:	8c2e                	mv	s8,a1
    80000b0c:	8a32                	mv	s4,a2
    80000b0e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b10:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b12:	6a85                	lui	s5,0x1
    80000b14:	a015                	j	80000b38 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b16:	9562                	add	a0,a0,s8
    80000b18:	0004861b          	sext.w	a2,s1
    80000b1c:	85d2                	mv	a1,s4
    80000b1e:	41250533          	sub	a0,a0,s2
    80000b22:	fffff097          	auipc	ra,0xfffff
    80000b26:	6b4080e7          	jalr	1716(ra) # 800001d6 <memmove>

    len -= n;
    80000b2a:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b2e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b30:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b34:	02098263          	beqz	s3,80000b58 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b38:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b3c:	85ca                	mv	a1,s2
    80000b3e:	855a                	mv	a0,s6
    80000b40:	00000097          	auipc	ra,0x0
    80000b44:	9c0080e7          	jalr	-1600(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000b48:	cd01                	beqz	a0,80000b60 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b4a:	418904b3          	sub	s1,s2,s8
    80000b4e:	94d6                	add	s1,s1,s5
    80000b50:	fc99f3e3          	bgeu	s3,s1,80000b16 <copyout+0x28>
    80000b54:	84ce                	mv	s1,s3
    80000b56:	b7c1                	j	80000b16 <copyout+0x28>
  }
  return 0;
    80000b58:	4501                	li	a0,0
    80000b5a:	a021                	j	80000b62 <copyout+0x74>
    80000b5c:	4501                	li	a0,0
}
    80000b5e:	8082                	ret
      return -1;
    80000b60:	557d                	li	a0,-1
}
    80000b62:	60a6                	ld	ra,72(sp)
    80000b64:	6406                	ld	s0,64(sp)
    80000b66:	74e2                	ld	s1,56(sp)
    80000b68:	7942                	ld	s2,48(sp)
    80000b6a:	79a2                	ld	s3,40(sp)
    80000b6c:	7a02                	ld	s4,32(sp)
    80000b6e:	6ae2                	ld	s5,24(sp)
    80000b70:	6b42                	ld	s6,16(sp)
    80000b72:	6ba2                	ld	s7,8(sp)
    80000b74:	6c02                	ld	s8,0(sp)
    80000b76:	6161                	addi	sp,sp,80
    80000b78:	8082                	ret

0000000080000b7a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b7a:	caa5                	beqz	a3,80000bea <copyin+0x70>
{
    80000b7c:	715d                	addi	sp,sp,-80
    80000b7e:	e486                	sd	ra,72(sp)
    80000b80:	e0a2                	sd	s0,64(sp)
    80000b82:	fc26                	sd	s1,56(sp)
    80000b84:	f84a                	sd	s2,48(sp)
    80000b86:	f44e                	sd	s3,40(sp)
    80000b88:	f052                	sd	s4,32(sp)
    80000b8a:	ec56                	sd	s5,24(sp)
    80000b8c:	e85a                	sd	s6,16(sp)
    80000b8e:	e45e                	sd	s7,8(sp)
    80000b90:	e062                	sd	s8,0(sp)
    80000b92:	0880                	addi	s0,sp,80
    80000b94:	8b2a                	mv	s6,a0
    80000b96:	8a2e                	mv	s4,a1
    80000b98:	8c32                	mv	s8,a2
    80000b9a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b9c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b9e:	6a85                	lui	s5,0x1
    80000ba0:	a01d                	j	80000bc6 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ba2:	018505b3          	add	a1,a0,s8
    80000ba6:	0004861b          	sext.w	a2,s1
    80000baa:	412585b3          	sub	a1,a1,s2
    80000bae:	8552                	mv	a0,s4
    80000bb0:	fffff097          	auipc	ra,0xfffff
    80000bb4:	626080e7          	jalr	1574(ra) # 800001d6 <memmove>

    len -= n;
    80000bb8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bbc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bbe:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bc2:	02098263          	beqz	s3,80000be6 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bc6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bca:	85ca                	mv	a1,s2
    80000bcc:	855a                	mv	a0,s6
    80000bce:	00000097          	auipc	ra,0x0
    80000bd2:	932080e7          	jalr	-1742(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000bd6:	cd01                	beqz	a0,80000bee <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bd8:	418904b3          	sub	s1,s2,s8
    80000bdc:	94d6                	add	s1,s1,s5
    80000bde:	fc99f2e3          	bgeu	s3,s1,80000ba2 <copyin+0x28>
    80000be2:	84ce                	mv	s1,s3
    80000be4:	bf7d                	j	80000ba2 <copyin+0x28>
  }
  return 0;
    80000be6:	4501                	li	a0,0
    80000be8:	a021                	j	80000bf0 <copyin+0x76>
    80000bea:	4501                	li	a0,0
}
    80000bec:	8082                	ret
      return -1;
    80000bee:	557d                	li	a0,-1
}
    80000bf0:	60a6                	ld	ra,72(sp)
    80000bf2:	6406                	ld	s0,64(sp)
    80000bf4:	74e2                	ld	s1,56(sp)
    80000bf6:	7942                	ld	s2,48(sp)
    80000bf8:	79a2                	ld	s3,40(sp)
    80000bfa:	7a02                	ld	s4,32(sp)
    80000bfc:	6ae2                	ld	s5,24(sp)
    80000bfe:	6b42                	ld	s6,16(sp)
    80000c00:	6ba2                	ld	s7,8(sp)
    80000c02:	6c02                	ld	s8,0(sp)
    80000c04:	6161                	addi	sp,sp,80
    80000c06:	8082                	ret

0000000080000c08 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c08:	c2dd                	beqz	a3,80000cae <copyinstr+0xa6>
{
    80000c0a:	715d                	addi	sp,sp,-80
    80000c0c:	e486                	sd	ra,72(sp)
    80000c0e:	e0a2                	sd	s0,64(sp)
    80000c10:	fc26                	sd	s1,56(sp)
    80000c12:	f84a                	sd	s2,48(sp)
    80000c14:	f44e                	sd	s3,40(sp)
    80000c16:	f052                	sd	s4,32(sp)
    80000c18:	ec56                	sd	s5,24(sp)
    80000c1a:	e85a                	sd	s6,16(sp)
    80000c1c:	e45e                	sd	s7,8(sp)
    80000c1e:	0880                	addi	s0,sp,80
    80000c20:	8a2a                	mv	s4,a0
    80000c22:	8b2e                	mv	s6,a1
    80000c24:	8bb2                	mv	s7,a2
    80000c26:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c28:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c2a:	6985                	lui	s3,0x1
    80000c2c:	a02d                	j	80000c56 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c2e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c32:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c34:	37fd                	addiw	a5,a5,-1
    80000c36:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c3a:	60a6                	ld	ra,72(sp)
    80000c3c:	6406                	ld	s0,64(sp)
    80000c3e:	74e2                	ld	s1,56(sp)
    80000c40:	7942                	ld	s2,48(sp)
    80000c42:	79a2                	ld	s3,40(sp)
    80000c44:	7a02                	ld	s4,32(sp)
    80000c46:	6ae2                	ld	s5,24(sp)
    80000c48:	6b42                	ld	s6,16(sp)
    80000c4a:	6ba2                	ld	s7,8(sp)
    80000c4c:	6161                	addi	sp,sp,80
    80000c4e:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c50:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c54:	c8a9                	beqz	s1,80000ca6 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c56:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c5a:	85ca                	mv	a1,s2
    80000c5c:	8552                	mv	a0,s4
    80000c5e:	00000097          	auipc	ra,0x0
    80000c62:	8a2080e7          	jalr	-1886(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000c66:	c131                	beqz	a0,80000caa <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c68:	417906b3          	sub	a3,s2,s7
    80000c6c:	96ce                	add	a3,a3,s3
    80000c6e:	00d4f363          	bgeu	s1,a3,80000c74 <copyinstr+0x6c>
    80000c72:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c74:	955e                	add	a0,a0,s7
    80000c76:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c7a:	daf9                	beqz	a3,80000c50 <copyinstr+0x48>
    80000c7c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c7e:	41650633          	sub	a2,a0,s6
    80000c82:	fff48593          	addi	a1,s1,-1
    80000c86:	95da                	add	a1,a1,s6
    while(n > 0){
    80000c88:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000c8a:	00f60733          	add	a4,a2,a5
    80000c8e:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffcadc0>
    80000c92:	df51                	beqz	a4,80000c2e <copyinstr+0x26>
        *dst = *p;
    80000c94:	00e78023          	sb	a4,0(a5)
      --max;
    80000c98:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000c9c:	0785                	addi	a5,a5,1
    while(n > 0){
    80000c9e:	fed796e3          	bne	a5,a3,80000c8a <copyinstr+0x82>
      dst++;
    80000ca2:	8b3e                	mv	s6,a5
    80000ca4:	b775                	j	80000c50 <copyinstr+0x48>
    80000ca6:	4781                	li	a5,0
    80000ca8:	b771                	j	80000c34 <copyinstr+0x2c>
      return -1;
    80000caa:	557d                	li	a0,-1
    80000cac:	b779                	j	80000c3a <copyinstr+0x32>
  int got_null = 0;
    80000cae:	4781                	li	a5,0
  if(got_null){
    80000cb0:	37fd                	addiw	a5,a5,-1
    80000cb2:	0007851b          	sext.w	a0,a5
}
    80000cb6:	8082                	ret

0000000080000cb8 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cb8:	7139                	addi	sp,sp,-64
    80000cba:	fc06                	sd	ra,56(sp)
    80000cbc:	f822                	sd	s0,48(sp)
    80000cbe:	f426                	sd	s1,40(sp)
    80000cc0:	f04a                	sd	s2,32(sp)
    80000cc2:	ec4e                	sd	s3,24(sp)
    80000cc4:	e852                	sd	s4,16(sp)
    80000cc6:	e456                	sd	s5,8(sp)
    80000cc8:	e05a                	sd	s6,0(sp)
    80000cca:	0080                	addi	s0,sp,64
    80000ccc:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cce:	00008497          	auipc	s1,0x8
    80000cd2:	7b248493          	addi	s1,s1,1970 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cd6:	8b26                	mv	s6,s1
    80000cd8:	00007a97          	auipc	s5,0x7
    80000cdc:	328a8a93          	addi	s5,s5,808 # 80008000 <etext>
    80000ce0:	04000937          	lui	s2,0x4000
    80000ce4:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000ce6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce8:	0001ca17          	auipc	s4,0x1c
    80000cec:	198a0a13          	addi	s4,s4,408 # 8001ce80 <tickslock>
    char *pa = kalloc();
    80000cf0:	fffff097          	auipc	ra,0xfffff
    80000cf4:	42a080e7          	jalr	1066(ra) # 8000011a <kalloc>
    80000cf8:	862a                	mv	a2,a0
    if(pa == 0)
    80000cfa:	c131                	beqz	a0,80000d3e <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000cfc:	416485b3          	sub	a1,s1,s6
    80000d00:	858d                	srai	a1,a1,0x3
    80000d02:	000ab783          	ld	a5,0(s5)
    80000d06:	02f585b3          	mul	a1,a1,a5
    80000d0a:	2585                	addiw	a1,a1,1
    80000d0c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d10:	4719                	li	a4,6
    80000d12:	6685                	lui	a3,0x1
    80000d14:	40b905b3          	sub	a1,s2,a1
    80000d18:	854e                	mv	a0,s3
    80000d1a:	00000097          	auipc	ra,0x0
    80000d1e:	8c8080e7          	jalr	-1848(ra) # 800005e2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d22:	4e848493          	addi	s1,s1,1256
    80000d26:	fd4495e3          	bne	s1,s4,80000cf0 <proc_mapstacks+0x38>
  }
}
    80000d2a:	70e2                	ld	ra,56(sp)
    80000d2c:	7442                	ld	s0,48(sp)
    80000d2e:	74a2                	ld	s1,40(sp)
    80000d30:	7902                	ld	s2,32(sp)
    80000d32:	69e2                	ld	s3,24(sp)
    80000d34:	6a42                	ld	s4,16(sp)
    80000d36:	6aa2                	ld	s5,8(sp)
    80000d38:	6b02                	ld	s6,0(sp)
    80000d3a:	6121                	addi	sp,sp,64
    80000d3c:	8082                	ret
      panic("kalloc");
    80000d3e:	00007517          	auipc	a0,0x7
    80000d42:	3e250513          	addi	a0,a0,994 # 80008120 <etext+0x120>
    80000d46:	00005097          	auipc	ra,0x5
    80000d4a:	15a080e7          	jalr	346(ra) # 80005ea0 <panic>

0000000080000d4e <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d4e:	7139                	addi	sp,sp,-64
    80000d50:	fc06                	sd	ra,56(sp)
    80000d52:	f822                	sd	s0,48(sp)
    80000d54:	f426                	sd	s1,40(sp)
    80000d56:	f04a                	sd	s2,32(sp)
    80000d58:	ec4e                	sd	s3,24(sp)
    80000d5a:	e852                	sd	s4,16(sp)
    80000d5c:	e456                	sd	s5,8(sp)
    80000d5e:	e05a                	sd	s6,0(sp)
    80000d60:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d62:	00007597          	auipc	a1,0x7
    80000d66:	3c658593          	addi	a1,a1,966 # 80008128 <etext+0x128>
    80000d6a:	00008517          	auipc	a0,0x8
    80000d6e:	2e650513          	addi	a0,a0,742 # 80009050 <pid_lock>
    80000d72:	00005097          	auipc	ra,0x5
    80000d76:	5d6080e7          	jalr	1494(ra) # 80006348 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d7a:	00007597          	auipc	a1,0x7
    80000d7e:	3b658593          	addi	a1,a1,950 # 80008130 <etext+0x130>
    80000d82:	00008517          	auipc	a0,0x8
    80000d86:	2e650513          	addi	a0,a0,742 # 80009068 <wait_lock>
    80000d8a:	00005097          	auipc	ra,0x5
    80000d8e:	5be080e7          	jalr	1470(ra) # 80006348 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d92:	00008497          	auipc	s1,0x8
    80000d96:	6ee48493          	addi	s1,s1,1774 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000d9a:	00007b17          	auipc	s6,0x7
    80000d9e:	3a6b0b13          	addi	s6,s6,934 # 80008140 <etext+0x140>
      p->kstack = KSTACK((int) (p - proc));
    80000da2:	8aa6                	mv	s5,s1
    80000da4:	00007a17          	auipc	s4,0x7
    80000da8:	25ca0a13          	addi	s4,s4,604 # 80008000 <etext>
    80000dac:	04000937          	lui	s2,0x4000
    80000db0:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000db2:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db4:	0001c997          	auipc	s3,0x1c
    80000db8:	0cc98993          	addi	s3,s3,204 # 8001ce80 <tickslock>
      initlock(&p->lock, "proc");
    80000dbc:	85da                	mv	a1,s6
    80000dbe:	8526                	mv	a0,s1
    80000dc0:	00005097          	auipc	ra,0x5
    80000dc4:	588080e7          	jalr	1416(ra) # 80006348 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000dc8:	415487b3          	sub	a5,s1,s5
    80000dcc:	878d                	srai	a5,a5,0x3
    80000dce:	000a3703          	ld	a4,0(s4)
    80000dd2:	02e787b3          	mul	a5,a5,a4
    80000dd6:	2785                	addiw	a5,a5,1
    80000dd8:	00d7979b          	slliw	a5,a5,0xd
    80000ddc:	40f907b3          	sub	a5,s2,a5
    80000de0:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de2:	4e848493          	addi	s1,s1,1256
    80000de6:	fd349be3          	bne	s1,s3,80000dbc <procinit+0x6e>
  }
}
    80000dea:	70e2                	ld	ra,56(sp)
    80000dec:	7442                	ld	s0,48(sp)
    80000dee:	74a2                	ld	s1,40(sp)
    80000df0:	7902                	ld	s2,32(sp)
    80000df2:	69e2                	ld	s3,24(sp)
    80000df4:	6a42                	ld	s4,16(sp)
    80000df6:	6aa2                	ld	s5,8(sp)
    80000df8:	6b02                	ld	s6,0(sp)
    80000dfa:	6121                	addi	sp,sp,64
    80000dfc:	8082                	ret

0000000080000dfe <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000dfe:	1141                	addi	sp,sp,-16
    80000e00:	e422                	sd	s0,8(sp)
    80000e02:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e04:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e06:	2501                	sext.w	a0,a0
    80000e08:	6422                	ld	s0,8(sp)
    80000e0a:	0141                	addi	sp,sp,16
    80000e0c:	8082                	ret

0000000080000e0e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e0e:	1141                	addi	sp,sp,-16
    80000e10:	e422                	sd	s0,8(sp)
    80000e12:	0800                	addi	s0,sp,16
    80000e14:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e16:	2781                	sext.w	a5,a5
    80000e18:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e1a:	00008517          	auipc	a0,0x8
    80000e1e:	26650513          	addi	a0,a0,614 # 80009080 <cpus>
    80000e22:	953e                	add	a0,a0,a5
    80000e24:	6422                	ld	s0,8(sp)
    80000e26:	0141                	addi	sp,sp,16
    80000e28:	8082                	ret

0000000080000e2a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e2a:	1101                	addi	sp,sp,-32
    80000e2c:	ec06                	sd	ra,24(sp)
    80000e2e:	e822                	sd	s0,16(sp)
    80000e30:	e426                	sd	s1,8(sp)
    80000e32:	1000                	addi	s0,sp,32
  push_off();
    80000e34:	00005097          	auipc	ra,0x5
    80000e38:	558080e7          	jalr	1368(ra) # 8000638c <push_off>
    80000e3c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e3e:	2781                	sext.w	a5,a5
    80000e40:	079e                	slli	a5,a5,0x7
    80000e42:	00008717          	auipc	a4,0x8
    80000e46:	20e70713          	addi	a4,a4,526 # 80009050 <pid_lock>
    80000e4a:	97ba                	add	a5,a5,a4
    80000e4c:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e4e:	00005097          	auipc	ra,0x5
    80000e52:	5de080e7          	jalr	1502(ra) # 8000642c <pop_off>
  return p;
}
    80000e56:	8526                	mv	a0,s1
    80000e58:	60e2                	ld	ra,24(sp)
    80000e5a:	6442                	ld	s0,16(sp)
    80000e5c:	64a2                	ld	s1,8(sp)
    80000e5e:	6105                	addi	sp,sp,32
    80000e60:	8082                	ret

0000000080000e62 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e406                	sd	ra,8(sp)
    80000e66:	e022                	sd	s0,0(sp)
    80000e68:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e6a:	00000097          	auipc	ra,0x0
    80000e6e:	fc0080e7          	jalr	-64(ra) # 80000e2a <myproc>
    80000e72:	00005097          	auipc	ra,0x5
    80000e76:	61a080e7          	jalr	1562(ra) # 8000648c <release>

  if (first) {
    80000e7a:	00008797          	auipc	a5,0x8
    80000e7e:	9867a783          	lw	a5,-1658(a5) # 80008800 <first.1>
    80000e82:	eb89                	bnez	a5,80000e94 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e84:	00001097          	auipc	ra,0x1
    80000e88:	cfc080e7          	jalr	-772(ra) # 80001b80 <usertrapret>
}
    80000e8c:	60a2                	ld	ra,8(sp)
    80000e8e:	6402                	ld	s0,0(sp)
    80000e90:	0141                	addi	sp,sp,16
    80000e92:	8082                	ret
    first = 0;
    80000e94:	00008797          	auipc	a5,0x8
    80000e98:	9607a623          	sw	zero,-1684(a5) # 80008800 <first.1>
    fsinit(ROOTDEV);
    80000e9c:	4505                	li	a0,1
    80000e9e:	00002097          	auipc	ra,0x2
    80000ea2:	afc080e7          	jalr	-1284(ra) # 8000299a <fsinit>
    80000ea6:	bff9                	j	80000e84 <forkret+0x22>

0000000080000ea8 <allocpid>:
allocpid() {
    80000ea8:	1101                	addi	sp,sp,-32
    80000eaa:	ec06                	sd	ra,24(sp)
    80000eac:	e822                	sd	s0,16(sp)
    80000eae:	e426                	sd	s1,8(sp)
    80000eb0:	e04a                	sd	s2,0(sp)
    80000eb2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000eb4:	00008917          	auipc	s2,0x8
    80000eb8:	19c90913          	addi	s2,s2,412 # 80009050 <pid_lock>
    80000ebc:	854a                	mv	a0,s2
    80000ebe:	00005097          	auipc	ra,0x5
    80000ec2:	51a080e7          	jalr	1306(ra) # 800063d8 <acquire>
  pid = nextpid;
    80000ec6:	00008797          	auipc	a5,0x8
    80000eca:	93e78793          	addi	a5,a5,-1730 # 80008804 <nextpid>
    80000ece:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ed0:	0014871b          	addiw	a4,s1,1
    80000ed4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ed6:	854a                	mv	a0,s2
    80000ed8:	00005097          	auipc	ra,0x5
    80000edc:	5b4080e7          	jalr	1460(ra) # 8000648c <release>
}
    80000ee0:	8526                	mv	a0,s1
    80000ee2:	60e2                	ld	ra,24(sp)
    80000ee4:	6442                	ld	s0,16(sp)
    80000ee6:	64a2                	ld	s1,8(sp)
    80000ee8:	6902                	ld	s2,0(sp)
    80000eea:	6105                	addi	sp,sp,32
    80000eec:	8082                	ret

0000000080000eee <proc_pagetable>:
{
    80000eee:	1101                	addi	sp,sp,-32
    80000ef0:	ec06                	sd	ra,24(sp)
    80000ef2:	e822                	sd	s0,16(sp)
    80000ef4:	e426                	sd	s1,8(sp)
    80000ef6:	e04a                	sd	s2,0(sp)
    80000ef8:	1000                	addi	s0,sp,32
    80000efa:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000efc:	00000097          	auipc	ra,0x0
    80000f00:	8c2080e7          	jalr	-1854(ra) # 800007be <uvmcreate>
    80000f04:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f06:	c121                	beqz	a0,80000f46 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f08:	4729                	li	a4,10
    80000f0a:	00006697          	auipc	a3,0x6
    80000f0e:	0f668693          	addi	a3,a3,246 # 80007000 <_trampoline>
    80000f12:	6605                	lui	a2,0x1
    80000f14:	040005b7          	lui	a1,0x4000
    80000f18:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f1a:	05b2                	slli	a1,a1,0xc
    80000f1c:	fffff097          	auipc	ra,0xfffff
    80000f20:	626080e7          	jalr	1574(ra) # 80000542 <mappages>
    80000f24:	02054863          	bltz	a0,80000f54 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f28:	4719                	li	a4,6
    80000f2a:	05893683          	ld	a3,88(s2)
    80000f2e:	6605                	lui	a2,0x1
    80000f30:	020005b7          	lui	a1,0x2000
    80000f34:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f36:	05b6                	slli	a1,a1,0xd
    80000f38:	8526                	mv	a0,s1
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	608080e7          	jalr	1544(ra) # 80000542 <mappages>
    80000f42:	02054163          	bltz	a0,80000f64 <proc_pagetable+0x76>
}
    80000f46:	8526                	mv	a0,s1
    80000f48:	60e2                	ld	ra,24(sp)
    80000f4a:	6442                	ld	s0,16(sp)
    80000f4c:	64a2                	ld	s1,8(sp)
    80000f4e:	6902                	ld	s2,0(sp)
    80000f50:	6105                	addi	sp,sp,32
    80000f52:	8082                	ret
    uvmfree(pagetable, 0);
    80000f54:	4581                	li	a1,0
    80000f56:	8526                	mv	a0,s1
    80000f58:	00000097          	auipc	ra,0x0
    80000f5c:	a64080e7          	jalr	-1436(ra) # 800009bc <uvmfree>
    return 0;
    80000f60:	4481                	li	s1,0
    80000f62:	b7d5                	j	80000f46 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f64:	4681                	li	a3,0
    80000f66:	4605                	li	a2,1
    80000f68:	040005b7          	lui	a1,0x4000
    80000f6c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f6e:	05b2                	slli	a1,a1,0xc
    80000f70:	8526                	mv	a0,s1
    80000f72:	fffff097          	auipc	ra,0xfffff
    80000f76:	796080e7          	jalr	1942(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f7a:	4581                	li	a1,0
    80000f7c:	8526                	mv	a0,s1
    80000f7e:	00000097          	auipc	ra,0x0
    80000f82:	a3e080e7          	jalr	-1474(ra) # 800009bc <uvmfree>
    return 0;
    80000f86:	4481                	li	s1,0
    80000f88:	bf7d                	j	80000f46 <proc_pagetable+0x58>

0000000080000f8a <proc_freepagetable>:
{
    80000f8a:	1101                	addi	sp,sp,-32
    80000f8c:	ec06                	sd	ra,24(sp)
    80000f8e:	e822                	sd	s0,16(sp)
    80000f90:	e426                	sd	s1,8(sp)
    80000f92:	e04a                	sd	s2,0(sp)
    80000f94:	1000                	addi	s0,sp,32
    80000f96:	84aa                	mv	s1,a0
    80000f98:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f9a:	4681                	li	a3,0
    80000f9c:	4605                	li	a2,1
    80000f9e:	040005b7          	lui	a1,0x4000
    80000fa2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fa4:	05b2                	slli	a1,a1,0xc
    80000fa6:	fffff097          	auipc	ra,0xfffff
    80000faa:	762080e7          	jalr	1890(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fae:	4681                	li	a3,0
    80000fb0:	4605                	li	a2,1
    80000fb2:	020005b7          	lui	a1,0x2000
    80000fb6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fb8:	05b6                	slli	a1,a1,0xd
    80000fba:	8526                	mv	a0,s1
    80000fbc:	fffff097          	auipc	ra,0xfffff
    80000fc0:	74c080e7          	jalr	1868(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fc4:	85ca                	mv	a1,s2
    80000fc6:	8526                	mv	a0,s1
    80000fc8:	00000097          	auipc	ra,0x0
    80000fcc:	9f4080e7          	jalr	-1548(ra) # 800009bc <uvmfree>
}
    80000fd0:	60e2                	ld	ra,24(sp)
    80000fd2:	6442                	ld	s0,16(sp)
    80000fd4:	64a2                	ld	s1,8(sp)
    80000fd6:	6902                	ld	s2,0(sp)
    80000fd8:	6105                	addi	sp,sp,32
    80000fda:	8082                	ret

0000000080000fdc <freeproc>:
{
    80000fdc:	1101                	addi	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	1000                	addi	s0,sp,32
    80000fe6:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000fe8:	6d28                	ld	a0,88(a0)
    80000fea:	c509                	beqz	a0,80000ff4 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80000fec:	fffff097          	auipc	ra,0xfffff
    80000ff0:	030080e7          	jalr	48(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80000ff4:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ff8:	68a8                	ld	a0,80(s1)
    80000ffa:	c511                	beqz	a0,80001006 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80000ffc:	64ac                	ld	a1,72(s1)
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	f8c080e7          	jalr	-116(ra) # 80000f8a <proc_freepagetable>
  p->pagetable = 0;
    80001006:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000100a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000100e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001012:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001016:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000101a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000101e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001022:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001026:	0004ac23          	sw	zero,24(s1)
}
    8000102a:	60e2                	ld	ra,24(sp)
    8000102c:	6442                	ld	s0,16(sp)
    8000102e:	64a2                	ld	s1,8(sp)
    80001030:	6105                	addi	sp,sp,32
    80001032:	8082                	ret

0000000080001034 <allocproc>:
{
    80001034:	1101                	addi	sp,sp,-32
    80001036:	ec06                	sd	ra,24(sp)
    80001038:	e822                	sd	s0,16(sp)
    8000103a:	e426                	sd	s1,8(sp)
    8000103c:	e04a                	sd	s2,0(sp)
    8000103e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001040:	00008497          	auipc	s1,0x8
    80001044:	44048493          	addi	s1,s1,1088 # 80009480 <proc>
    80001048:	0001c917          	auipc	s2,0x1c
    8000104c:	e3890913          	addi	s2,s2,-456 # 8001ce80 <tickslock>
    acquire(&p->lock);
    80001050:	8526                	mv	a0,s1
    80001052:	00005097          	auipc	ra,0x5
    80001056:	386080e7          	jalr	902(ra) # 800063d8 <acquire>
    if(p->state == UNUSED) {
    8000105a:	4c9c                	lw	a5,24(s1)
    8000105c:	cf81                	beqz	a5,80001074 <allocproc+0x40>
      release(&p->lock);
    8000105e:	8526                	mv	a0,s1
    80001060:	00005097          	auipc	ra,0x5
    80001064:	42c080e7          	jalr	1068(ra) # 8000648c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001068:	4e848493          	addi	s1,s1,1256
    8000106c:	ff2492e3          	bne	s1,s2,80001050 <allocproc+0x1c>
  return 0;
    80001070:	4481                	li	s1,0
    80001072:	a889                	j	800010c4 <allocproc+0x90>
  p->pid = allocpid();
    80001074:	00000097          	auipc	ra,0x0
    80001078:	e34080e7          	jalr	-460(ra) # 80000ea8 <allocpid>
    8000107c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000107e:	4785                	li	a5,1
    80001080:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001082:	fffff097          	auipc	ra,0xfffff
    80001086:	098080e7          	jalr	152(ra) # 8000011a <kalloc>
    8000108a:	892a                	mv	s2,a0
    8000108c:	eca8                	sd	a0,88(s1)
    8000108e:	c131                	beqz	a0,800010d2 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001090:	8526                	mv	a0,s1
    80001092:	00000097          	auipc	ra,0x0
    80001096:	e5c080e7          	jalr	-420(ra) # 80000eee <proc_pagetable>
    8000109a:	892a                	mv	s2,a0
    8000109c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000109e:	c531                	beqz	a0,800010ea <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010a0:	07000613          	li	a2,112
    800010a4:	4581                	li	a1,0
    800010a6:	06048513          	addi	a0,s1,96
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	0d0080e7          	jalr	208(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010b2:	00000797          	auipc	a5,0x0
    800010b6:	db078793          	addi	a5,a5,-592 # 80000e62 <forkret>
    800010ba:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010bc:	60bc                	ld	a5,64(s1)
    800010be:	6705                	lui	a4,0x1
    800010c0:	97ba                	add	a5,a5,a4
    800010c2:	f4bc                	sd	a5,104(s1)
}
    800010c4:	8526                	mv	a0,s1
    800010c6:	60e2                	ld	ra,24(sp)
    800010c8:	6442                	ld	s0,16(sp)
    800010ca:	64a2                	ld	s1,8(sp)
    800010cc:	6902                	ld	s2,0(sp)
    800010ce:	6105                	addi	sp,sp,32
    800010d0:	8082                	ret
    freeproc(p);
    800010d2:	8526                	mv	a0,s1
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	f08080e7          	jalr	-248(ra) # 80000fdc <freeproc>
    release(&p->lock);
    800010dc:	8526                	mv	a0,s1
    800010de:	00005097          	auipc	ra,0x5
    800010e2:	3ae080e7          	jalr	942(ra) # 8000648c <release>
    return 0;
    800010e6:	84ca                	mv	s1,s2
    800010e8:	bff1                	j	800010c4 <allocproc+0x90>
    freeproc(p);
    800010ea:	8526                	mv	a0,s1
    800010ec:	00000097          	auipc	ra,0x0
    800010f0:	ef0080e7          	jalr	-272(ra) # 80000fdc <freeproc>
    release(&p->lock);
    800010f4:	8526                	mv	a0,s1
    800010f6:	00005097          	auipc	ra,0x5
    800010fa:	396080e7          	jalr	918(ra) # 8000648c <release>
    return 0;
    800010fe:	84ca                	mv	s1,s2
    80001100:	b7d1                	j	800010c4 <allocproc+0x90>

0000000080001102 <userinit>:
{
    80001102:	1101                	addi	sp,sp,-32
    80001104:	ec06                	sd	ra,24(sp)
    80001106:	e822                	sd	s0,16(sp)
    80001108:	e426                	sd	s1,8(sp)
    8000110a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	f28080e7          	jalr	-216(ra) # 80001034 <allocproc>
    80001114:	84aa                	mv	s1,a0
  initproc = p;
    80001116:	00008797          	auipc	a5,0x8
    8000111a:	eea7bd23          	sd	a0,-262(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000111e:	03400613          	li	a2,52
    80001122:	00007597          	auipc	a1,0x7
    80001126:	6ee58593          	addi	a1,a1,1774 # 80008810 <initcode>
    8000112a:	6928                	ld	a0,80(a0)
    8000112c:	fffff097          	auipc	ra,0xfffff
    80001130:	6c0080e7          	jalr	1728(ra) # 800007ec <uvminit>
  p->sz = PGSIZE;
    80001134:	6785                	lui	a5,0x1
    80001136:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001138:	6cb8                	ld	a4,88(s1)
    8000113a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000113e:	6cb8                	ld	a4,88(s1)
    80001140:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001142:	4641                	li	a2,16
    80001144:	00007597          	auipc	a1,0x7
    80001148:	00458593          	addi	a1,a1,4 # 80008148 <etext+0x148>
    8000114c:	15848513          	addi	a0,s1,344
    80001150:	fffff097          	auipc	ra,0xfffff
    80001154:	174080e7          	jalr	372(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    80001158:	00007517          	auipc	a0,0x7
    8000115c:	00050513          	mv	a0,a0
    80001160:	00002097          	auipc	ra,0x2
    80001164:	270080e7          	jalr	624(ra) # 800033d0 <namei>
    80001168:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000116c:	478d                	li	a5,3
    8000116e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001170:	8526                	mv	a0,s1
    80001172:	00005097          	auipc	ra,0x5
    80001176:	31a080e7          	jalr	794(ra) # 8000648c <release>
}
    8000117a:	60e2                	ld	ra,24(sp)
    8000117c:	6442                	ld	s0,16(sp)
    8000117e:	64a2                	ld	s1,8(sp)
    80001180:	6105                	addi	sp,sp,32
    80001182:	8082                	ret

0000000080001184 <growproc>:
{
    80001184:	1101                	addi	sp,sp,-32
    80001186:	ec06                	sd	ra,24(sp)
    80001188:	e822                	sd	s0,16(sp)
    8000118a:	e426                	sd	s1,8(sp)
    8000118c:	e04a                	sd	s2,0(sp)
    8000118e:	1000                	addi	s0,sp,32
    80001190:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001192:	00000097          	auipc	ra,0x0
    80001196:	c98080e7          	jalr	-872(ra) # 80000e2a <myproc>
    8000119a:	892a                	mv	s2,a0
  sz = p->sz;
    8000119c:	652c                	ld	a1,72(a0)
    8000119e:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011a2:	00904f63          	bgtz	s1,800011c0 <growproc+0x3c>
  } else if(n < 0){
    800011a6:	0204cd63          	bltz	s1,800011e0 <growproc+0x5c>
  p->sz = sz;
    800011aa:	1782                	slli	a5,a5,0x20
    800011ac:	9381                	srli	a5,a5,0x20
    800011ae:	04f93423          	sd	a5,72(s2)
  return 0;
    800011b2:	4501                	li	a0,0
}
    800011b4:	60e2                	ld	ra,24(sp)
    800011b6:	6442                	ld	s0,16(sp)
    800011b8:	64a2                	ld	s1,8(sp)
    800011ba:	6902                	ld	s2,0(sp)
    800011bc:	6105                	addi	sp,sp,32
    800011be:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011c0:	00f4863b          	addw	a2,s1,a5
    800011c4:	1602                	slli	a2,a2,0x20
    800011c6:	9201                	srli	a2,a2,0x20
    800011c8:	1582                	slli	a1,a1,0x20
    800011ca:	9181                	srli	a1,a1,0x20
    800011cc:	6928                	ld	a0,80(a0)
    800011ce:	fffff097          	auipc	ra,0xfffff
    800011d2:	6d8080e7          	jalr	1752(ra) # 800008a6 <uvmalloc>
    800011d6:	0005079b          	sext.w	a5,a0
    800011da:	fbe1                	bnez	a5,800011aa <growproc+0x26>
      return -1;
    800011dc:	557d                	li	a0,-1
    800011de:	bfd9                	j	800011b4 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011e0:	00f4863b          	addw	a2,s1,a5
    800011e4:	1602                	slli	a2,a2,0x20
    800011e6:	9201                	srli	a2,a2,0x20
    800011e8:	1582                	slli	a1,a1,0x20
    800011ea:	9181                	srli	a1,a1,0x20
    800011ec:	6928                	ld	a0,80(a0)
    800011ee:	fffff097          	auipc	ra,0xfffff
    800011f2:	670080e7          	jalr	1648(ra) # 8000085e <uvmdealloc>
    800011f6:	0005079b          	sext.w	a5,a0
    800011fa:	bf45                	j	800011aa <growproc+0x26>

00000000800011fc <fork>:
{
    800011fc:	7139                	addi	sp,sp,-64
    800011fe:	fc06                	sd	ra,56(sp)
    80001200:	f822                	sd	s0,48(sp)
    80001202:	f426                	sd	s1,40(sp)
    80001204:	f04a                	sd	s2,32(sp)
    80001206:	ec4e                	sd	s3,24(sp)
    80001208:	e852                	sd	s4,16(sp)
    8000120a:	e456                	sd	s5,8(sp)
    8000120c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	c1c080e7          	jalr	-996(ra) # 80000e2a <myproc>
    80001216:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001218:	00000097          	auipc	ra,0x0
    8000121c:	e1c080e7          	jalr	-484(ra) # 80001034 <allocproc>
    80001220:	10050c63          	beqz	a0,80001338 <fork+0x13c>
    80001224:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001226:	048ab603          	ld	a2,72(s5)
    8000122a:	692c                	ld	a1,80(a0)
    8000122c:	050ab503          	ld	a0,80(s5)
    80001230:	fffff097          	auipc	ra,0xfffff
    80001234:	7c6080e7          	jalr	1990(ra) # 800009f6 <uvmcopy>
    80001238:	04054863          	bltz	a0,80001288 <fork+0x8c>
  np->sz = p->sz;
    8000123c:	048ab783          	ld	a5,72(s5)
    80001240:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001244:	058ab683          	ld	a3,88(s5)
    80001248:	87b6                	mv	a5,a3
    8000124a:	058a3703          	ld	a4,88(s4)
    8000124e:	12068693          	addi	a3,a3,288
    80001252:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001256:	6788                	ld	a0,8(a5)
    80001258:	6b8c                	ld	a1,16(a5)
    8000125a:	6f90                	ld	a2,24(a5)
    8000125c:	01073023          	sd	a6,0(a4)
    80001260:	e708                	sd	a0,8(a4)
    80001262:	eb0c                	sd	a1,16(a4)
    80001264:	ef10                	sd	a2,24(a4)
    80001266:	02078793          	addi	a5,a5,32
    8000126a:	02070713          	addi	a4,a4,32
    8000126e:	fed792e3          	bne	a5,a3,80001252 <fork+0x56>
  np->trapframe->a0 = 0;
    80001272:	058a3783          	ld	a5,88(s4)
    80001276:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000127a:	0d0a8493          	addi	s1,s5,208
    8000127e:	0d0a0913          	addi	s2,s4,208
    80001282:	150a8993          	addi	s3,s5,336
    80001286:	a00d                	j	800012a8 <fork+0xac>
    freeproc(np);
    80001288:	8552                	mv	a0,s4
    8000128a:	00000097          	auipc	ra,0x0
    8000128e:	d52080e7          	jalr	-686(ra) # 80000fdc <freeproc>
    release(&np->lock);
    80001292:	8552                	mv	a0,s4
    80001294:	00005097          	auipc	ra,0x5
    80001298:	1f8080e7          	jalr	504(ra) # 8000648c <release>
    return -1;
    8000129c:	597d                	li	s2,-1
    8000129e:	a059                	j	80001324 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012a0:	04a1                	addi	s1,s1,8
    800012a2:	0921                	addi	s2,s2,8
    800012a4:	01348b63          	beq	s1,s3,800012ba <fork+0xbe>
    if(p->ofile[i])
    800012a8:	6088                	ld	a0,0(s1)
    800012aa:	d97d                	beqz	a0,800012a0 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012ac:	00002097          	auipc	ra,0x2
    800012b0:	7ba080e7          	jalr	1978(ra) # 80003a66 <filedup>
    800012b4:	00a93023          	sd	a0,0(s2)
    800012b8:	b7e5                	j	800012a0 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012ba:	150ab503          	ld	a0,336(s5)
    800012be:	00002097          	auipc	ra,0x2
    800012c2:	918080e7          	jalr	-1768(ra) # 80002bd6 <idup>
    800012c6:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012ca:	4641                	li	a2,16
    800012cc:	158a8593          	addi	a1,s5,344
    800012d0:	158a0513          	addi	a0,s4,344
    800012d4:	fffff097          	auipc	ra,0xfffff
    800012d8:	ff0080e7          	jalr	-16(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    800012dc:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012e0:	8552                	mv	a0,s4
    800012e2:	00005097          	auipc	ra,0x5
    800012e6:	1aa080e7          	jalr	426(ra) # 8000648c <release>
  acquire(&wait_lock);
    800012ea:	00008497          	auipc	s1,0x8
    800012ee:	d7e48493          	addi	s1,s1,-642 # 80009068 <wait_lock>
    800012f2:	8526                	mv	a0,s1
    800012f4:	00005097          	auipc	ra,0x5
    800012f8:	0e4080e7          	jalr	228(ra) # 800063d8 <acquire>
  np->parent = p;
    800012fc:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001300:	8526                	mv	a0,s1
    80001302:	00005097          	auipc	ra,0x5
    80001306:	18a080e7          	jalr	394(ra) # 8000648c <release>
  acquire(&np->lock);
    8000130a:	8552                	mv	a0,s4
    8000130c:	00005097          	auipc	ra,0x5
    80001310:	0cc080e7          	jalr	204(ra) # 800063d8 <acquire>
  np->state = RUNNABLE;
    80001314:	478d                	li	a5,3
    80001316:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000131a:	8552                	mv	a0,s4
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	170080e7          	jalr	368(ra) # 8000648c <release>
}
    80001324:	854a                	mv	a0,s2
    80001326:	70e2                	ld	ra,56(sp)
    80001328:	7442                	ld	s0,48(sp)
    8000132a:	74a2                	ld	s1,40(sp)
    8000132c:	7902                	ld	s2,32(sp)
    8000132e:	69e2                	ld	s3,24(sp)
    80001330:	6a42                	ld	s4,16(sp)
    80001332:	6aa2                	ld	s5,8(sp)
    80001334:	6121                	addi	sp,sp,64
    80001336:	8082                	ret
    return -1;
    80001338:	597d                	li	s2,-1
    8000133a:	b7ed                	j	80001324 <fork+0x128>

000000008000133c <scheduler>:
{
    8000133c:	7139                	addi	sp,sp,-64
    8000133e:	fc06                	sd	ra,56(sp)
    80001340:	f822                	sd	s0,48(sp)
    80001342:	f426                	sd	s1,40(sp)
    80001344:	f04a                	sd	s2,32(sp)
    80001346:	ec4e                	sd	s3,24(sp)
    80001348:	e852                	sd	s4,16(sp)
    8000134a:	e456                	sd	s5,8(sp)
    8000134c:	e05a                	sd	s6,0(sp)
    8000134e:	0080                	addi	s0,sp,64
    80001350:	8792                	mv	a5,tp
  int id = r_tp();
    80001352:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001354:	00779a93          	slli	s5,a5,0x7
    80001358:	00008717          	auipc	a4,0x8
    8000135c:	cf870713          	addi	a4,a4,-776 # 80009050 <pid_lock>
    80001360:	9756                	add	a4,a4,s5
    80001362:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001366:	00008717          	auipc	a4,0x8
    8000136a:	d2270713          	addi	a4,a4,-734 # 80009088 <cpus+0x8>
    8000136e:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001370:	498d                	li	s3,3
        p->state = RUNNING;
    80001372:	4b11                	li	s6,4
        c->proc = p;
    80001374:	079e                	slli	a5,a5,0x7
    80001376:	00008a17          	auipc	s4,0x8
    8000137a:	cdaa0a13          	addi	s4,s4,-806 # 80009050 <pid_lock>
    8000137e:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001380:	0001c917          	auipc	s2,0x1c
    80001384:	b0090913          	addi	s2,s2,-1280 # 8001ce80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001388:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000138c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001390:	10079073          	csrw	sstatus,a5
    80001394:	00008497          	auipc	s1,0x8
    80001398:	0ec48493          	addi	s1,s1,236 # 80009480 <proc>
    8000139c:	a811                	j	800013b0 <scheduler+0x74>
      release(&p->lock);
    8000139e:	8526                	mv	a0,s1
    800013a0:	00005097          	auipc	ra,0x5
    800013a4:	0ec080e7          	jalr	236(ra) # 8000648c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013a8:	4e848493          	addi	s1,s1,1256
    800013ac:	fd248ee3          	beq	s1,s2,80001388 <scheduler+0x4c>
      acquire(&p->lock);
    800013b0:	8526                	mv	a0,s1
    800013b2:	00005097          	auipc	ra,0x5
    800013b6:	026080e7          	jalr	38(ra) # 800063d8 <acquire>
      if(p->state == RUNNABLE) {
    800013ba:	4c9c                	lw	a5,24(s1)
    800013bc:	ff3791e3          	bne	a5,s3,8000139e <scheduler+0x62>
        p->state = RUNNING;
    800013c0:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013c4:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013c8:	06048593          	addi	a1,s1,96
    800013cc:	8556                	mv	a0,s5
    800013ce:	00000097          	auipc	ra,0x0
    800013d2:	620080e7          	jalr	1568(ra) # 800019ee <swtch>
        c->proc = 0;
    800013d6:	020a3823          	sd	zero,48(s4)
    800013da:	b7d1                	j	8000139e <scheduler+0x62>

00000000800013dc <sched>:
{
    800013dc:	7179                	addi	sp,sp,-48
    800013de:	f406                	sd	ra,40(sp)
    800013e0:	f022                	sd	s0,32(sp)
    800013e2:	ec26                	sd	s1,24(sp)
    800013e4:	e84a                	sd	s2,16(sp)
    800013e6:	e44e                	sd	s3,8(sp)
    800013e8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	a40080e7          	jalr	-1472(ra) # 80000e2a <myproc>
    800013f2:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800013f4:	00005097          	auipc	ra,0x5
    800013f8:	f6a080e7          	jalr	-150(ra) # 8000635e <holding>
    800013fc:	c93d                	beqz	a0,80001472 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800013fe:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001400:	2781                	sext.w	a5,a5
    80001402:	079e                	slli	a5,a5,0x7
    80001404:	00008717          	auipc	a4,0x8
    80001408:	c4c70713          	addi	a4,a4,-948 # 80009050 <pid_lock>
    8000140c:	97ba                	add	a5,a5,a4
    8000140e:	0a87a703          	lw	a4,168(a5)
    80001412:	4785                	li	a5,1
    80001414:	06f71763          	bne	a4,a5,80001482 <sched+0xa6>
  if(p->state == RUNNING)
    80001418:	4c98                	lw	a4,24(s1)
    8000141a:	4791                	li	a5,4
    8000141c:	06f70b63          	beq	a4,a5,80001492 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001420:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001424:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001426:	efb5                	bnez	a5,800014a2 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001428:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000142a:	00008917          	auipc	s2,0x8
    8000142e:	c2690913          	addi	s2,s2,-986 # 80009050 <pid_lock>
    80001432:	2781                	sext.w	a5,a5
    80001434:	079e                	slli	a5,a5,0x7
    80001436:	97ca                	add	a5,a5,s2
    80001438:	0ac7a983          	lw	s3,172(a5)
    8000143c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000143e:	2781                	sext.w	a5,a5
    80001440:	079e                	slli	a5,a5,0x7
    80001442:	00008597          	auipc	a1,0x8
    80001446:	c4658593          	addi	a1,a1,-954 # 80009088 <cpus+0x8>
    8000144a:	95be                	add	a1,a1,a5
    8000144c:	06048513          	addi	a0,s1,96
    80001450:	00000097          	auipc	ra,0x0
    80001454:	59e080e7          	jalr	1438(ra) # 800019ee <swtch>
    80001458:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000145a:	2781                	sext.w	a5,a5
    8000145c:	079e                	slli	a5,a5,0x7
    8000145e:	993e                	add	s2,s2,a5
    80001460:	0b392623          	sw	s3,172(s2)
}
    80001464:	70a2                	ld	ra,40(sp)
    80001466:	7402                	ld	s0,32(sp)
    80001468:	64e2                	ld	s1,24(sp)
    8000146a:	6942                	ld	s2,16(sp)
    8000146c:	69a2                	ld	s3,8(sp)
    8000146e:	6145                	addi	sp,sp,48
    80001470:	8082                	ret
    panic("sched p->lock");
    80001472:	00007517          	auipc	a0,0x7
    80001476:	cee50513          	addi	a0,a0,-786 # 80008160 <etext+0x160>
    8000147a:	00005097          	auipc	ra,0x5
    8000147e:	a26080e7          	jalr	-1498(ra) # 80005ea0 <panic>
    panic("sched locks");
    80001482:	00007517          	auipc	a0,0x7
    80001486:	cee50513          	addi	a0,a0,-786 # 80008170 <etext+0x170>
    8000148a:	00005097          	auipc	ra,0x5
    8000148e:	a16080e7          	jalr	-1514(ra) # 80005ea0 <panic>
    panic("sched running");
    80001492:	00007517          	auipc	a0,0x7
    80001496:	cee50513          	addi	a0,a0,-786 # 80008180 <etext+0x180>
    8000149a:	00005097          	auipc	ra,0x5
    8000149e:	a06080e7          	jalr	-1530(ra) # 80005ea0 <panic>
    panic("sched interruptible");
    800014a2:	00007517          	auipc	a0,0x7
    800014a6:	cee50513          	addi	a0,a0,-786 # 80008190 <etext+0x190>
    800014aa:	00005097          	auipc	ra,0x5
    800014ae:	9f6080e7          	jalr	-1546(ra) # 80005ea0 <panic>

00000000800014b2 <yield>:
{
    800014b2:	1101                	addi	sp,sp,-32
    800014b4:	ec06                	sd	ra,24(sp)
    800014b6:	e822                	sd	s0,16(sp)
    800014b8:	e426                	sd	s1,8(sp)
    800014ba:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014bc:	00000097          	auipc	ra,0x0
    800014c0:	96e080e7          	jalr	-1682(ra) # 80000e2a <myproc>
    800014c4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014c6:	00005097          	auipc	ra,0x5
    800014ca:	f12080e7          	jalr	-238(ra) # 800063d8 <acquire>
  p->state = RUNNABLE;
    800014ce:	478d                	li	a5,3
    800014d0:	cc9c                	sw	a5,24(s1)
  sched();
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	f0a080e7          	jalr	-246(ra) # 800013dc <sched>
  release(&p->lock);
    800014da:	8526                	mv	a0,s1
    800014dc:	00005097          	auipc	ra,0x5
    800014e0:	fb0080e7          	jalr	-80(ra) # 8000648c <release>
}
    800014e4:	60e2                	ld	ra,24(sp)
    800014e6:	6442                	ld	s0,16(sp)
    800014e8:	64a2                	ld	s1,8(sp)
    800014ea:	6105                	addi	sp,sp,32
    800014ec:	8082                	ret

00000000800014ee <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800014ee:	7179                	addi	sp,sp,-48
    800014f0:	f406                	sd	ra,40(sp)
    800014f2:	f022                	sd	s0,32(sp)
    800014f4:	ec26                	sd	s1,24(sp)
    800014f6:	e84a                	sd	s2,16(sp)
    800014f8:	e44e                	sd	s3,8(sp)
    800014fa:	1800                	addi	s0,sp,48
    800014fc:	89aa                	mv	s3,a0
    800014fe:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001500:	00000097          	auipc	ra,0x0
    80001504:	92a080e7          	jalr	-1750(ra) # 80000e2a <myproc>
    80001508:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000150a:	00005097          	auipc	ra,0x5
    8000150e:	ece080e7          	jalr	-306(ra) # 800063d8 <acquire>
  release(lk);
    80001512:	854a                	mv	a0,s2
    80001514:	00005097          	auipc	ra,0x5
    80001518:	f78080e7          	jalr	-136(ra) # 8000648c <release>

  // Go to sleep.
  p->chan = chan;
    8000151c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001520:	4789                	li	a5,2
    80001522:	cc9c                	sw	a5,24(s1)

  sched();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	eb8080e7          	jalr	-328(ra) # 800013dc <sched>

  // Tidy up.
  p->chan = 0;
    8000152c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001530:	8526                	mv	a0,s1
    80001532:	00005097          	auipc	ra,0x5
    80001536:	f5a080e7          	jalr	-166(ra) # 8000648c <release>
  acquire(lk);
    8000153a:	854a                	mv	a0,s2
    8000153c:	00005097          	auipc	ra,0x5
    80001540:	e9c080e7          	jalr	-356(ra) # 800063d8 <acquire>
}
    80001544:	70a2                	ld	ra,40(sp)
    80001546:	7402                	ld	s0,32(sp)
    80001548:	64e2                	ld	s1,24(sp)
    8000154a:	6942                	ld	s2,16(sp)
    8000154c:	69a2                	ld	s3,8(sp)
    8000154e:	6145                	addi	sp,sp,48
    80001550:	8082                	ret

0000000080001552 <wait>:
{
    80001552:	715d                	addi	sp,sp,-80
    80001554:	e486                	sd	ra,72(sp)
    80001556:	e0a2                	sd	s0,64(sp)
    80001558:	fc26                	sd	s1,56(sp)
    8000155a:	f84a                	sd	s2,48(sp)
    8000155c:	f44e                	sd	s3,40(sp)
    8000155e:	f052                	sd	s4,32(sp)
    80001560:	ec56                	sd	s5,24(sp)
    80001562:	e85a                	sd	s6,16(sp)
    80001564:	e45e                	sd	s7,8(sp)
    80001566:	e062                	sd	s8,0(sp)
    80001568:	0880                	addi	s0,sp,80
    8000156a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000156c:	00000097          	auipc	ra,0x0
    80001570:	8be080e7          	jalr	-1858(ra) # 80000e2a <myproc>
    80001574:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001576:	00008517          	auipc	a0,0x8
    8000157a:	af250513          	addi	a0,a0,-1294 # 80009068 <wait_lock>
    8000157e:	00005097          	auipc	ra,0x5
    80001582:	e5a080e7          	jalr	-422(ra) # 800063d8 <acquire>
    havekids = 0;
    80001586:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001588:	4a15                	li	s4,5
        havekids = 1;
    8000158a:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000158c:	0001c997          	auipc	s3,0x1c
    80001590:	8f498993          	addi	s3,s3,-1804 # 8001ce80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001594:	00008c17          	auipc	s8,0x8
    80001598:	ad4c0c13          	addi	s8,s8,-1324 # 80009068 <wait_lock>
    havekids = 0;
    8000159c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000159e:	00008497          	auipc	s1,0x8
    800015a2:	ee248493          	addi	s1,s1,-286 # 80009480 <proc>
    800015a6:	a0bd                	j	80001614 <wait+0xc2>
          pid = np->pid;
    800015a8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015ac:	000b0e63          	beqz	s6,800015c8 <wait+0x76>
    800015b0:	4691                	li	a3,4
    800015b2:	02c48613          	addi	a2,s1,44
    800015b6:	85da                	mv	a1,s6
    800015b8:	05093503          	ld	a0,80(s2)
    800015bc:	fffff097          	auipc	ra,0xfffff
    800015c0:	532080e7          	jalr	1330(ra) # 80000aee <copyout>
    800015c4:	02054563          	bltz	a0,800015ee <wait+0x9c>
          freeproc(np);
    800015c8:	8526                	mv	a0,s1
    800015ca:	00000097          	auipc	ra,0x0
    800015ce:	a12080e7          	jalr	-1518(ra) # 80000fdc <freeproc>
          release(&np->lock);
    800015d2:	8526                	mv	a0,s1
    800015d4:	00005097          	auipc	ra,0x5
    800015d8:	eb8080e7          	jalr	-328(ra) # 8000648c <release>
          release(&wait_lock);
    800015dc:	00008517          	auipc	a0,0x8
    800015e0:	a8c50513          	addi	a0,a0,-1396 # 80009068 <wait_lock>
    800015e4:	00005097          	auipc	ra,0x5
    800015e8:	ea8080e7          	jalr	-344(ra) # 8000648c <release>
          return pid;
    800015ec:	a09d                	j	80001652 <wait+0x100>
            release(&np->lock);
    800015ee:	8526                	mv	a0,s1
    800015f0:	00005097          	auipc	ra,0x5
    800015f4:	e9c080e7          	jalr	-356(ra) # 8000648c <release>
            release(&wait_lock);
    800015f8:	00008517          	auipc	a0,0x8
    800015fc:	a7050513          	addi	a0,a0,-1424 # 80009068 <wait_lock>
    80001600:	00005097          	auipc	ra,0x5
    80001604:	e8c080e7          	jalr	-372(ra) # 8000648c <release>
            return -1;
    80001608:	59fd                	li	s3,-1
    8000160a:	a0a1                	j	80001652 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000160c:	4e848493          	addi	s1,s1,1256
    80001610:	03348463          	beq	s1,s3,80001638 <wait+0xe6>
      if(np->parent == p){
    80001614:	7c9c                	ld	a5,56(s1)
    80001616:	ff279be3          	bne	a5,s2,8000160c <wait+0xba>
        acquire(&np->lock);
    8000161a:	8526                	mv	a0,s1
    8000161c:	00005097          	auipc	ra,0x5
    80001620:	dbc080e7          	jalr	-580(ra) # 800063d8 <acquire>
        if(np->state == ZOMBIE){
    80001624:	4c9c                	lw	a5,24(s1)
    80001626:	f94781e3          	beq	a5,s4,800015a8 <wait+0x56>
        release(&np->lock);
    8000162a:	8526                	mv	a0,s1
    8000162c:	00005097          	auipc	ra,0x5
    80001630:	e60080e7          	jalr	-416(ra) # 8000648c <release>
        havekids = 1;
    80001634:	8756                	mv	a4,s5
    80001636:	bfd9                	j	8000160c <wait+0xba>
    if(!havekids || p->killed){
    80001638:	c701                	beqz	a4,80001640 <wait+0xee>
    8000163a:	02892783          	lw	a5,40(s2)
    8000163e:	c79d                	beqz	a5,8000166c <wait+0x11a>
      release(&wait_lock);
    80001640:	00008517          	auipc	a0,0x8
    80001644:	a2850513          	addi	a0,a0,-1496 # 80009068 <wait_lock>
    80001648:	00005097          	auipc	ra,0x5
    8000164c:	e44080e7          	jalr	-444(ra) # 8000648c <release>
      return -1;
    80001650:	59fd                	li	s3,-1
}
    80001652:	854e                	mv	a0,s3
    80001654:	60a6                	ld	ra,72(sp)
    80001656:	6406                	ld	s0,64(sp)
    80001658:	74e2                	ld	s1,56(sp)
    8000165a:	7942                	ld	s2,48(sp)
    8000165c:	79a2                	ld	s3,40(sp)
    8000165e:	7a02                	ld	s4,32(sp)
    80001660:	6ae2                	ld	s5,24(sp)
    80001662:	6b42                	ld	s6,16(sp)
    80001664:	6ba2                	ld	s7,8(sp)
    80001666:	6c02                	ld	s8,0(sp)
    80001668:	6161                	addi	sp,sp,80
    8000166a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000166c:	85e2                	mv	a1,s8
    8000166e:	854a                	mv	a0,s2
    80001670:	00000097          	auipc	ra,0x0
    80001674:	e7e080e7          	jalr	-386(ra) # 800014ee <sleep>
    havekids = 0;
    80001678:	b715                	j	8000159c <wait+0x4a>

000000008000167a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000167a:	7139                	addi	sp,sp,-64
    8000167c:	fc06                	sd	ra,56(sp)
    8000167e:	f822                	sd	s0,48(sp)
    80001680:	f426                	sd	s1,40(sp)
    80001682:	f04a                	sd	s2,32(sp)
    80001684:	ec4e                	sd	s3,24(sp)
    80001686:	e852                	sd	s4,16(sp)
    80001688:	e456                	sd	s5,8(sp)
    8000168a:	0080                	addi	s0,sp,64
    8000168c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000168e:	00008497          	auipc	s1,0x8
    80001692:	df248493          	addi	s1,s1,-526 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001696:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001698:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000169a:	0001b917          	auipc	s2,0x1b
    8000169e:	7e690913          	addi	s2,s2,2022 # 8001ce80 <tickslock>
    800016a2:	a811                	j	800016b6 <wakeup+0x3c>
      }
      release(&p->lock);
    800016a4:	8526                	mv	a0,s1
    800016a6:	00005097          	auipc	ra,0x5
    800016aa:	de6080e7          	jalr	-538(ra) # 8000648c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ae:	4e848493          	addi	s1,s1,1256
    800016b2:	03248663          	beq	s1,s2,800016de <wakeup+0x64>
    if(p != myproc()){
    800016b6:	fffff097          	auipc	ra,0xfffff
    800016ba:	774080e7          	jalr	1908(ra) # 80000e2a <myproc>
    800016be:	fea488e3          	beq	s1,a0,800016ae <wakeup+0x34>
      acquire(&p->lock);
    800016c2:	8526                	mv	a0,s1
    800016c4:	00005097          	auipc	ra,0x5
    800016c8:	d14080e7          	jalr	-748(ra) # 800063d8 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016cc:	4c9c                	lw	a5,24(s1)
    800016ce:	fd379be3          	bne	a5,s3,800016a4 <wakeup+0x2a>
    800016d2:	709c                	ld	a5,32(s1)
    800016d4:	fd4798e3          	bne	a5,s4,800016a4 <wakeup+0x2a>
        p->state = RUNNABLE;
    800016d8:	0154ac23          	sw	s5,24(s1)
    800016dc:	b7e1                	j	800016a4 <wakeup+0x2a>
    }
  }
}
    800016de:	70e2                	ld	ra,56(sp)
    800016e0:	7442                	ld	s0,48(sp)
    800016e2:	74a2                	ld	s1,40(sp)
    800016e4:	7902                	ld	s2,32(sp)
    800016e6:	69e2                	ld	s3,24(sp)
    800016e8:	6a42                	ld	s4,16(sp)
    800016ea:	6aa2                	ld	s5,8(sp)
    800016ec:	6121                	addi	sp,sp,64
    800016ee:	8082                	ret

00000000800016f0 <reparent>:
{
    800016f0:	7179                	addi	sp,sp,-48
    800016f2:	f406                	sd	ra,40(sp)
    800016f4:	f022                	sd	s0,32(sp)
    800016f6:	ec26                	sd	s1,24(sp)
    800016f8:	e84a                	sd	s2,16(sp)
    800016fa:	e44e                	sd	s3,8(sp)
    800016fc:	e052                	sd	s4,0(sp)
    800016fe:	1800                	addi	s0,sp,48
    80001700:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001702:	00008497          	auipc	s1,0x8
    80001706:	d7e48493          	addi	s1,s1,-642 # 80009480 <proc>
      pp->parent = initproc;
    8000170a:	00008a17          	auipc	s4,0x8
    8000170e:	906a0a13          	addi	s4,s4,-1786 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001712:	0001b997          	auipc	s3,0x1b
    80001716:	76e98993          	addi	s3,s3,1902 # 8001ce80 <tickslock>
    8000171a:	a029                	j	80001724 <reparent+0x34>
    8000171c:	4e848493          	addi	s1,s1,1256
    80001720:	01348d63          	beq	s1,s3,8000173a <reparent+0x4a>
    if(pp->parent == p){
    80001724:	7c9c                	ld	a5,56(s1)
    80001726:	ff279be3          	bne	a5,s2,8000171c <reparent+0x2c>
      pp->parent = initproc;
    8000172a:	000a3503          	ld	a0,0(s4)
    8000172e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001730:	00000097          	auipc	ra,0x0
    80001734:	f4a080e7          	jalr	-182(ra) # 8000167a <wakeup>
    80001738:	b7d5                	j	8000171c <reparent+0x2c>
}
    8000173a:	70a2                	ld	ra,40(sp)
    8000173c:	7402                	ld	s0,32(sp)
    8000173e:	64e2                	ld	s1,24(sp)
    80001740:	6942                	ld	s2,16(sp)
    80001742:	69a2                	ld	s3,8(sp)
    80001744:	6a02                	ld	s4,0(sp)
    80001746:	6145                	addi	sp,sp,48
    80001748:	8082                	ret

000000008000174a <exit>:
{
    8000174a:	7179                	addi	sp,sp,-48
    8000174c:	f406                	sd	ra,40(sp)
    8000174e:	f022                	sd	s0,32(sp)
    80001750:	ec26                	sd	s1,24(sp)
    80001752:	e84a                	sd	s2,16(sp)
    80001754:	e44e                	sd	s3,8(sp)
    80001756:	e052                	sd	s4,0(sp)
    80001758:	1800                	addi	s0,sp,48
    8000175a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000175c:	fffff097          	auipc	ra,0xfffff
    80001760:	6ce080e7          	jalr	1742(ra) # 80000e2a <myproc>
    80001764:	89aa                	mv	s3,a0
  if(p == initproc)
    80001766:	00008797          	auipc	a5,0x8
    8000176a:	8aa7b783          	ld	a5,-1878(a5) # 80009010 <initproc>
    8000176e:	0d050493          	addi	s1,a0,208
    80001772:	15050913          	addi	s2,a0,336
    80001776:	02a79363          	bne	a5,a0,8000179c <exit+0x52>
    panic("init exiting");
    8000177a:	00007517          	auipc	a0,0x7
    8000177e:	a2e50513          	addi	a0,a0,-1490 # 800081a8 <etext+0x1a8>
    80001782:	00004097          	auipc	ra,0x4
    80001786:	71e080e7          	jalr	1822(ra) # 80005ea0 <panic>
      fileclose(f);
    8000178a:	00002097          	auipc	ra,0x2
    8000178e:	32e080e7          	jalr	814(ra) # 80003ab8 <fileclose>
      p->ofile[fd] = 0;
    80001792:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001796:	04a1                	addi	s1,s1,8
    80001798:	01248563          	beq	s1,s2,800017a2 <exit+0x58>
    if(p->ofile[fd]){
    8000179c:	6088                	ld	a0,0(s1)
    8000179e:	f575                	bnez	a0,8000178a <exit+0x40>
    800017a0:	bfdd                	j	80001796 <exit+0x4c>
  begin_op();
    800017a2:	00002097          	auipc	ra,0x2
    800017a6:	e4e080e7          	jalr	-434(ra) # 800035f0 <begin_op>
  iput(p->cwd);
    800017aa:	1509b503          	ld	a0,336(s3)
    800017ae:	00001097          	auipc	ra,0x1
    800017b2:	620080e7          	jalr	1568(ra) # 80002dce <iput>
  end_op();
    800017b6:	00002097          	auipc	ra,0x2
    800017ba:	eb8080e7          	jalr	-328(ra) # 8000366e <end_op>
  p->cwd = 0;
    800017be:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017c2:	00008497          	auipc	s1,0x8
    800017c6:	8a648493          	addi	s1,s1,-1882 # 80009068 <wait_lock>
    800017ca:	8526                	mv	a0,s1
    800017cc:	00005097          	auipc	ra,0x5
    800017d0:	c0c080e7          	jalr	-1012(ra) # 800063d8 <acquire>
  reparent(p);
    800017d4:	854e                	mv	a0,s3
    800017d6:	00000097          	auipc	ra,0x0
    800017da:	f1a080e7          	jalr	-230(ra) # 800016f0 <reparent>
  wakeup(p->parent);
    800017de:	0389b503          	ld	a0,56(s3)
    800017e2:	00000097          	auipc	ra,0x0
    800017e6:	e98080e7          	jalr	-360(ra) # 8000167a <wakeup>
  acquire(&p->lock);
    800017ea:	854e                	mv	a0,s3
    800017ec:	00005097          	auipc	ra,0x5
    800017f0:	bec080e7          	jalr	-1044(ra) # 800063d8 <acquire>
  p->xstate = status;
    800017f4:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800017f8:	4795                	li	a5,5
    800017fa:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800017fe:	8526                	mv	a0,s1
    80001800:	00005097          	auipc	ra,0x5
    80001804:	c8c080e7          	jalr	-884(ra) # 8000648c <release>
  sched();
    80001808:	00000097          	auipc	ra,0x0
    8000180c:	bd4080e7          	jalr	-1068(ra) # 800013dc <sched>
  panic("zombie exit");
    80001810:	00007517          	auipc	a0,0x7
    80001814:	9a850513          	addi	a0,a0,-1624 # 800081b8 <etext+0x1b8>
    80001818:	00004097          	auipc	ra,0x4
    8000181c:	688080e7          	jalr	1672(ra) # 80005ea0 <panic>

0000000080001820 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001820:	7179                	addi	sp,sp,-48
    80001822:	f406                	sd	ra,40(sp)
    80001824:	f022                	sd	s0,32(sp)
    80001826:	ec26                	sd	s1,24(sp)
    80001828:	e84a                	sd	s2,16(sp)
    8000182a:	e44e                	sd	s3,8(sp)
    8000182c:	1800                	addi	s0,sp,48
    8000182e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001830:	00008497          	auipc	s1,0x8
    80001834:	c5048493          	addi	s1,s1,-944 # 80009480 <proc>
    80001838:	0001b997          	auipc	s3,0x1b
    8000183c:	64898993          	addi	s3,s3,1608 # 8001ce80 <tickslock>
    acquire(&p->lock);
    80001840:	8526                	mv	a0,s1
    80001842:	00005097          	auipc	ra,0x5
    80001846:	b96080e7          	jalr	-1130(ra) # 800063d8 <acquire>
    if(p->pid == pid){
    8000184a:	589c                	lw	a5,48(s1)
    8000184c:	01278d63          	beq	a5,s2,80001866 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001850:	8526                	mv	a0,s1
    80001852:	00005097          	auipc	ra,0x5
    80001856:	c3a080e7          	jalr	-966(ra) # 8000648c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000185a:	4e848493          	addi	s1,s1,1256
    8000185e:	ff3491e3          	bne	s1,s3,80001840 <kill+0x20>
  }
  return -1;
    80001862:	557d                	li	a0,-1
    80001864:	a829                	j	8000187e <kill+0x5e>
      p->killed = 1;
    80001866:	4785                	li	a5,1
    80001868:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000186a:	4c98                	lw	a4,24(s1)
    8000186c:	4789                	li	a5,2
    8000186e:	00f70f63          	beq	a4,a5,8000188c <kill+0x6c>
      release(&p->lock);
    80001872:	8526                	mv	a0,s1
    80001874:	00005097          	auipc	ra,0x5
    80001878:	c18080e7          	jalr	-1000(ra) # 8000648c <release>
      return 0;
    8000187c:	4501                	li	a0,0
}
    8000187e:	70a2                	ld	ra,40(sp)
    80001880:	7402                	ld	s0,32(sp)
    80001882:	64e2                	ld	s1,24(sp)
    80001884:	6942                	ld	s2,16(sp)
    80001886:	69a2                	ld	s3,8(sp)
    80001888:	6145                	addi	sp,sp,48
    8000188a:	8082                	ret
        p->state = RUNNABLE;
    8000188c:	478d                	li	a5,3
    8000188e:	cc9c                	sw	a5,24(s1)
    80001890:	b7cd                	j	80001872 <kill+0x52>

0000000080001892 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001892:	7179                	addi	sp,sp,-48
    80001894:	f406                	sd	ra,40(sp)
    80001896:	f022                	sd	s0,32(sp)
    80001898:	ec26                	sd	s1,24(sp)
    8000189a:	e84a                	sd	s2,16(sp)
    8000189c:	e44e                	sd	s3,8(sp)
    8000189e:	e052                	sd	s4,0(sp)
    800018a0:	1800                	addi	s0,sp,48
    800018a2:	84aa                	mv	s1,a0
    800018a4:	892e                	mv	s2,a1
    800018a6:	89b2                	mv	s3,a2
    800018a8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018aa:	fffff097          	auipc	ra,0xfffff
    800018ae:	580080e7          	jalr	1408(ra) # 80000e2a <myproc>
  if(user_dst){
    800018b2:	c08d                	beqz	s1,800018d4 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018b4:	86d2                	mv	a3,s4
    800018b6:	864e                	mv	a2,s3
    800018b8:	85ca                	mv	a1,s2
    800018ba:	6928                	ld	a0,80(a0)
    800018bc:	fffff097          	auipc	ra,0xfffff
    800018c0:	232080e7          	jalr	562(ra) # 80000aee <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018c4:	70a2                	ld	ra,40(sp)
    800018c6:	7402                	ld	s0,32(sp)
    800018c8:	64e2                	ld	s1,24(sp)
    800018ca:	6942                	ld	s2,16(sp)
    800018cc:	69a2                	ld	s3,8(sp)
    800018ce:	6a02                	ld	s4,0(sp)
    800018d0:	6145                	addi	sp,sp,48
    800018d2:	8082                	ret
    memmove((char *)dst, src, len);
    800018d4:	000a061b          	sext.w	a2,s4
    800018d8:	85ce                	mv	a1,s3
    800018da:	854a                	mv	a0,s2
    800018dc:	fffff097          	auipc	ra,0xfffff
    800018e0:	8fa080e7          	jalr	-1798(ra) # 800001d6 <memmove>
    return 0;
    800018e4:	8526                	mv	a0,s1
    800018e6:	bff9                	j	800018c4 <either_copyout+0x32>

00000000800018e8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800018e8:	7179                	addi	sp,sp,-48
    800018ea:	f406                	sd	ra,40(sp)
    800018ec:	f022                	sd	s0,32(sp)
    800018ee:	ec26                	sd	s1,24(sp)
    800018f0:	e84a                	sd	s2,16(sp)
    800018f2:	e44e                	sd	s3,8(sp)
    800018f4:	e052                	sd	s4,0(sp)
    800018f6:	1800                	addi	s0,sp,48
    800018f8:	892a                	mv	s2,a0
    800018fa:	84ae                	mv	s1,a1
    800018fc:	89b2                	mv	s3,a2
    800018fe:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001900:	fffff097          	auipc	ra,0xfffff
    80001904:	52a080e7          	jalr	1322(ra) # 80000e2a <myproc>
  if(user_src){
    80001908:	c08d                	beqz	s1,8000192a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000190a:	86d2                	mv	a3,s4
    8000190c:	864e                	mv	a2,s3
    8000190e:	85ca                	mv	a1,s2
    80001910:	6928                	ld	a0,80(a0)
    80001912:	fffff097          	auipc	ra,0xfffff
    80001916:	268080e7          	jalr	616(ra) # 80000b7a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000191a:	70a2                	ld	ra,40(sp)
    8000191c:	7402                	ld	s0,32(sp)
    8000191e:	64e2                	ld	s1,24(sp)
    80001920:	6942                	ld	s2,16(sp)
    80001922:	69a2                	ld	s3,8(sp)
    80001924:	6a02                	ld	s4,0(sp)
    80001926:	6145                	addi	sp,sp,48
    80001928:	8082                	ret
    memmove(dst, (char*)src, len);
    8000192a:	000a061b          	sext.w	a2,s4
    8000192e:	85ce                	mv	a1,s3
    80001930:	854a                	mv	a0,s2
    80001932:	fffff097          	auipc	ra,0xfffff
    80001936:	8a4080e7          	jalr	-1884(ra) # 800001d6 <memmove>
    return 0;
    8000193a:	8526                	mv	a0,s1
    8000193c:	bff9                	j	8000191a <either_copyin+0x32>

000000008000193e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000193e:	715d                	addi	sp,sp,-80
    80001940:	e486                	sd	ra,72(sp)
    80001942:	e0a2                	sd	s0,64(sp)
    80001944:	fc26                	sd	s1,56(sp)
    80001946:	f84a                	sd	s2,48(sp)
    80001948:	f44e                	sd	s3,40(sp)
    8000194a:	f052                	sd	s4,32(sp)
    8000194c:	ec56                	sd	s5,24(sp)
    8000194e:	e85a                	sd	s6,16(sp)
    80001950:	e45e                	sd	s7,8(sp)
    80001952:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001954:	00006517          	auipc	a0,0x6
    80001958:	6f450513          	addi	a0,a0,1780 # 80008048 <etext+0x48>
    8000195c:	00004097          	auipc	ra,0x4
    80001960:	58e080e7          	jalr	1422(ra) # 80005eea <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001964:	00008497          	auipc	s1,0x8
    80001968:	c7448493          	addi	s1,s1,-908 # 800095d8 <proc+0x158>
    8000196c:	0001b917          	auipc	s2,0x1b
    80001970:	66c90913          	addi	s2,s2,1644 # 8001cfd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001974:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001976:	00007997          	auipc	s3,0x7
    8000197a:	85298993          	addi	s3,s3,-1966 # 800081c8 <etext+0x1c8>
    printf("%d %s %s", p->pid, state, p->name);
    8000197e:	00007a97          	auipc	s5,0x7
    80001982:	852a8a93          	addi	s5,s5,-1966 # 800081d0 <etext+0x1d0>
    printf("\n");
    80001986:	00006a17          	auipc	s4,0x6
    8000198a:	6c2a0a13          	addi	s4,s4,1730 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000198e:	00007b97          	auipc	s7,0x7
    80001992:	87ab8b93          	addi	s7,s7,-1926 # 80008208 <states.0>
    80001996:	a00d                	j	800019b8 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001998:	ed86a583          	lw	a1,-296(a3)
    8000199c:	8556                	mv	a0,s5
    8000199e:	00004097          	auipc	ra,0x4
    800019a2:	54c080e7          	jalr	1356(ra) # 80005eea <printf>
    printf("\n");
    800019a6:	8552                	mv	a0,s4
    800019a8:	00004097          	auipc	ra,0x4
    800019ac:	542080e7          	jalr	1346(ra) # 80005eea <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019b0:	4e848493          	addi	s1,s1,1256
    800019b4:	03248263          	beq	s1,s2,800019d8 <procdump+0x9a>
    if(p->state == UNUSED)
    800019b8:	86a6                	mv	a3,s1
    800019ba:	ec04a783          	lw	a5,-320(s1)
    800019be:	dbed                	beqz	a5,800019b0 <procdump+0x72>
      state = "???";
    800019c0:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019c2:	fcfb6be3          	bltu	s6,a5,80001998 <procdump+0x5a>
    800019c6:	02079713          	slli	a4,a5,0x20
    800019ca:	01d75793          	srli	a5,a4,0x1d
    800019ce:	97de                	add	a5,a5,s7
    800019d0:	6390                	ld	a2,0(a5)
    800019d2:	f279                	bnez	a2,80001998 <procdump+0x5a>
      state = "???";
    800019d4:	864e                	mv	a2,s3
    800019d6:	b7c9                	j	80001998 <procdump+0x5a>
  }
}
    800019d8:	60a6                	ld	ra,72(sp)
    800019da:	6406                	ld	s0,64(sp)
    800019dc:	74e2                	ld	s1,56(sp)
    800019de:	7942                	ld	s2,48(sp)
    800019e0:	79a2                	ld	s3,40(sp)
    800019e2:	7a02                	ld	s4,32(sp)
    800019e4:	6ae2                	ld	s5,24(sp)
    800019e6:	6b42                	ld	s6,16(sp)
    800019e8:	6ba2                	ld	s7,8(sp)
    800019ea:	6161                	addi	sp,sp,80
    800019ec:	8082                	ret

00000000800019ee <swtch>:
    800019ee:	00153023          	sd	ra,0(a0)
    800019f2:	00253423          	sd	sp,8(a0)
    800019f6:	e900                	sd	s0,16(a0)
    800019f8:	ed04                	sd	s1,24(a0)
    800019fa:	03253023          	sd	s2,32(a0)
    800019fe:	03353423          	sd	s3,40(a0)
    80001a02:	03453823          	sd	s4,48(a0)
    80001a06:	03553c23          	sd	s5,56(a0)
    80001a0a:	05653023          	sd	s6,64(a0)
    80001a0e:	05753423          	sd	s7,72(a0)
    80001a12:	05853823          	sd	s8,80(a0)
    80001a16:	05953c23          	sd	s9,88(a0)
    80001a1a:	07a53023          	sd	s10,96(a0)
    80001a1e:	07b53423          	sd	s11,104(a0)
    80001a22:	0005b083          	ld	ra,0(a1)
    80001a26:	0085b103          	ld	sp,8(a1)
    80001a2a:	6980                	ld	s0,16(a1)
    80001a2c:	6d84                	ld	s1,24(a1)
    80001a2e:	0205b903          	ld	s2,32(a1)
    80001a32:	0285b983          	ld	s3,40(a1)
    80001a36:	0305ba03          	ld	s4,48(a1)
    80001a3a:	0385ba83          	ld	s5,56(a1)
    80001a3e:	0405bb03          	ld	s6,64(a1)
    80001a42:	0485bb83          	ld	s7,72(a1)
    80001a46:	0505bc03          	ld	s8,80(a1)
    80001a4a:	0585bc83          	ld	s9,88(a1)
    80001a4e:	0605bd03          	ld	s10,96(a1)
    80001a52:	0685bd83          	ld	s11,104(a1)
    80001a56:	8082                	ret

0000000080001a58 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a58:	1141                	addi	sp,sp,-16
    80001a5a:	e406                	sd	ra,8(sp)
    80001a5c:	e022                	sd	s0,0(sp)
    80001a5e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a60:	00006597          	auipc	a1,0x6
    80001a64:	7d858593          	addi	a1,a1,2008 # 80008238 <states.0+0x30>
    80001a68:	0001b517          	auipc	a0,0x1b
    80001a6c:	41850513          	addi	a0,a0,1048 # 8001ce80 <tickslock>
    80001a70:	00005097          	auipc	ra,0x5
    80001a74:	8d8080e7          	jalr	-1832(ra) # 80006348 <initlock>
}
    80001a78:	60a2                	ld	ra,8(sp)
    80001a7a:	6402                	ld	s0,0(sp)
    80001a7c:	0141                	addi	sp,sp,16
    80001a7e:	8082                	ret

0000000080001a80 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a80:	1141                	addi	sp,sp,-16
    80001a82:	e422                	sd	s0,8(sp)
    80001a84:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a86:	00004797          	auipc	a5,0x4
    80001a8a:	87a78793          	addi	a5,a5,-1926 # 80005300 <kernelvec>
    80001a8e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001a92:	6422                	ld	s0,8(sp)
    80001a94:	0141                	addi	sp,sp,16
    80001a96:	8082                	ret

0000000080001a98 <findmap1>:

int findmap1(uint64 addr)
{
    80001a98:	1101                	addi	sp,sp,-32
    80001a9a:	ec06                	sd	ra,24(sp)
    80001a9c:	e822                	sd	s0,16(sp)
    80001a9e:	e426                	sd	s1,8(sp)
    80001aa0:	1000                	addi	s0,sp,32
    80001aa2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001aa4:	fffff097          	auipc	ra,0xfffff
    80001aa8:	386080e7          	jalr	902(ra) # 80000e2a <myproc>
  int i;
  for(i=0;i<16;i++)
    80001aac:	17850793          	addi	a5,a0,376
    80001ab0:	4501                	li	a0,0
    80001ab2:	46c1                	li	a3,16
    80001ab4:	a031                	j	80001ac0 <findmap1+0x28>
    80001ab6:	2505                	addiw	a0,a0,1
    80001ab8:	03878793          	addi	a5,a5,56
    80001abc:	00d50963          	beq	a0,a3,80001ace <findmap1+0x36>
  {
    uint64 a=p->map_region[i].mmapaddr;
    uint64 b=p->map_region[i].mmapend;
    if(addr>=a && addr<b){
    80001ac0:	6398                	ld	a4,0(a5)
    80001ac2:	fee4eae3          	bltu	s1,a4,80001ab6 <findmap1+0x1e>
    80001ac6:	6798                	ld	a4,8(a5)
    80001ac8:	fee4f7e3          	bgeu	s1,a4,80001ab6 <findmap1+0x1e>
    80001acc:	a011                	j	80001ad0 <findmap1+0x38>
      return i;
    }   
  }
  return -1;
    80001ace:	557d                	li	a0,-1
}
    80001ad0:	60e2                	ld	ra,24(sp)
    80001ad2:	6442                	ld	s0,16(sp)
    80001ad4:	64a2                	ld	s1,8(sp)
    80001ad6:	6105                	addi	sp,sp,32
    80001ad8:	8082                	ret

0000000080001ada <mmapalloc>:
uint64
mmapalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int prot)
{
    80001ada:	7139                	addi	sp,sp,-64
    80001adc:	fc06                	sd	ra,56(sp)
    80001ade:	f822                	sd	s0,48(sp)
    80001ae0:	f426                	sd	s1,40(sp)
    80001ae2:	f04a                	sd	s2,32(sp)
    80001ae4:	ec4e                	sd	s3,24(sp)
    80001ae6:	e852                	sd	s4,16(sp)
    80001ae8:	e456                	sd	s5,8(sp)
    80001aea:	e05a                	sd	s6,0(sp)
    80001aec:	0080                	addi	s0,sp,64
    80001aee:	8b2e                	mv	s6,a1
  char *mem;
  uint64 a;

  if(newsz < oldsz)
    80001af0:	06b66b63          	bltu	a2,a1,80001b66 <mmapalloc+0x8c>
    80001af4:	8a2a                	mv	s4,a0
    80001af6:	89b2                	mv	s3,a2
    80001af8:	8ab6                	mv	s5,a3
    return oldsz;

  //oldsz = PGROUNDUP(oldsz);
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001afa:	08c5f163          	bgeu	a1,a2,80001b7c <mmapalloc+0xa2>
    80001afe:	892e                	mv	s2,a1
    //printf("maphere\n");
    mem = kalloc();
    80001b00:	ffffe097          	auipc	ra,0xffffe
    80001b04:	61a080e7          	jalr	1562(ra) # 8000011a <kalloc>
    80001b08:	84aa                	mv	s1,a0
    if(mem == 0){
    80001b0a:	c51d                	beqz	a0,80001b38 <mmapalloc+0x5e>
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    80001b0c:	6605                	lui	a2,0x1
    80001b0e:	4581                	li	a1,0
    80001b10:	ffffe097          	auipc	ra,0xffffe
    80001b14:	66a080e7          	jalr	1642(ra) # 8000017a <memset>

    if(mappages(pagetable, a, PGSIZE, (uint64)mem, prot) != 0){
    80001b18:	8756                	mv	a4,s5
    80001b1a:	86a6                	mv	a3,s1
    80001b1c:	6605                	lui	a2,0x1
    80001b1e:	85ca                	mv	a1,s2
    80001b20:	8552                	mv	a0,s4
    80001b22:	fffff097          	auipc	ra,0xfffff
    80001b26:	a20080e7          	jalr	-1504(ra) # 80000542 <mappages>
    80001b2a:	e105                	bnez	a0,80001b4a <mmapalloc+0x70>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001b2c:	6785                	lui	a5,0x1
    80001b2e:	993e                	add	s2,s2,a5
    80001b30:	fd3968e3          	bltu	s2,s3,80001b00 <mmapalloc+0x26>
      kfree(mem);
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
  }
  return newsz;
    80001b34:	854e                	mv	a0,s3
    80001b36:	a80d                	j	80001b68 <mmapalloc+0x8e>
      uvmdealloc(pagetable, a, oldsz);
    80001b38:	865a                	mv	a2,s6
    80001b3a:	85ca                	mv	a1,s2
    80001b3c:	8552                	mv	a0,s4
    80001b3e:	fffff097          	auipc	ra,0xfffff
    80001b42:	d20080e7          	jalr	-736(ra) # 8000085e <uvmdealloc>
      return 0;
    80001b46:	4501                	li	a0,0
    80001b48:	a005                	j	80001b68 <mmapalloc+0x8e>
      kfree(mem);
    80001b4a:	8526                	mv	a0,s1
    80001b4c:	ffffe097          	auipc	ra,0xffffe
    80001b50:	4d0080e7          	jalr	1232(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001b54:	865a                	mv	a2,s6
    80001b56:	85ca                	mv	a1,s2
    80001b58:	8552                	mv	a0,s4
    80001b5a:	fffff097          	auipc	ra,0xfffff
    80001b5e:	d04080e7          	jalr	-764(ra) # 8000085e <uvmdealloc>
      return 0;
    80001b62:	4501                	li	a0,0
    80001b64:	a011                	j	80001b68 <mmapalloc+0x8e>
    return oldsz;
    80001b66:	852e                	mv	a0,a1
}
    80001b68:	70e2                	ld	ra,56(sp)
    80001b6a:	7442                	ld	s0,48(sp)
    80001b6c:	74a2                	ld	s1,40(sp)
    80001b6e:	7902                	ld	s2,32(sp)
    80001b70:	69e2                	ld	s3,24(sp)
    80001b72:	6a42                	ld	s4,16(sp)
    80001b74:	6aa2                	ld	s5,8(sp)
    80001b76:	6b02                	ld	s6,0(sp)
    80001b78:	6121                	addi	sp,sp,64
    80001b7a:	8082                	ret
  return newsz;
    80001b7c:	8532                	mv	a0,a2
    80001b7e:	b7ed                	j	80001b68 <mmapalloc+0x8e>

0000000080001b80 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b80:	1141                	addi	sp,sp,-16
    80001b82:	e406                	sd	ra,8(sp)
    80001b84:	e022                	sd	s0,0(sp)
    80001b86:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b88:	fffff097          	auipc	ra,0xfffff
    80001b8c:	2a2080e7          	jalr	674(ra) # 80000e2a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b94:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b96:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b9a:	00005697          	auipc	a3,0x5
    80001b9e:	46668693          	addi	a3,a3,1126 # 80007000 <_trampoline>
    80001ba2:	00005717          	auipc	a4,0x5
    80001ba6:	45e70713          	addi	a4,a4,1118 # 80007000 <_trampoline>
    80001baa:	8f15                	sub	a4,a4,a3
    80001bac:	040007b7          	lui	a5,0x4000
    80001bb0:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bb2:	07b2                	slli	a5,a5,0xc
    80001bb4:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bb6:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bba:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bbc:	18002673          	csrr	a2,satp
    80001bc0:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bc2:	6d30                	ld	a2,88(a0)
    80001bc4:	6138                	ld	a4,64(a0)
    80001bc6:	6585                	lui	a1,0x1
    80001bc8:	972e                	add	a4,a4,a1
    80001bca:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bcc:	6d38                	ld	a4,88(a0)
    80001bce:	00000617          	auipc	a2,0x0
    80001bd2:	13860613          	addi	a2,a2,312 # 80001d06 <usertrap>
    80001bd6:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bd8:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bda:	8612                	mv	a2,tp
    80001bdc:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bde:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001be2:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001be6:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bea:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bee:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bf0:	6f18                	ld	a4,24(a4)
    80001bf2:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bf6:	692c                	ld	a1,80(a0)
    80001bf8:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bfa:	00005717          	auipc	a4,0x5
    80001bfe:	49670713          	addi	a4,a4,1174 # 80007090 <userret>
    80001c02:	8f15                	sub	a4,a4,a3
    80001c04:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c06:	577d                	li	a4,-1
    80001c08:	177e                	slli	a4,a4,0x3f
    80001c0a:	8dd9                	or	a1,a1,a4
    80001c0c:	02000537          	lui	a0,0x2000
    80001c10:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c12:	0536                	slli	a0,a0,0xd
    80001c14:	9782                	jalr	a5
}
    80001c16:	60a2                	ld	ra,8(sp)
    80001c18:	6402                	ld	s0,0(sp)
    80001c1a:	0141                	addi	sp,sp,16
    80001c1c:	8082                	ret

0000000080001c1e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c1e:	1101                	addi	sp,sp,-32
    80001c20:	ec06                	sd	ra,24(sp)
    80001c22:	e822                	sd	s0,16(sp)
    80001c24:	e426                	sd	s1,8(sp)
    80001c26:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c28:	0001b497          	auipc	s1,0x1b
    80001c2c:	25848493          	addi	s1,s1,600 # 8001ce80 <tickslock>
    80001c30:	8526                	mv	a0,s1
    80001c32:	00004097          	auipc	ra,0x4
    80001c36:	7a6080e7          	jalr	1958(ra) # 800063d8 <acquire>
  ticks++;
    80001c3a:	00007517          	auipc	a0,0x7
    80001c3e:	3de50513          	addi	a0,a0,990 # 80009018 <ticks>
    80001c42:	411c                	lw	a5,0(a0)
    80001c44:	2785                	addiw	a5,a5,1
    80001c46:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c48:	00000097          	auipc	ra,0x0
    80001c4c:	a32080e7          	jalr	-1486(ra) # 8000167a <wakeup>
  release(&tickslock);
    80001c50:	8526                	mv	a0,s1
    80001c52:	00005097          	auipc	ra,0x5
    80001c56:	83a080e7          	jalr	-1990(ra) # 8000648c <release>
}
    80001c5a:	60e2                	ld	ra,24(sp)
    80001c5c:	6442                	ld	s0,16(sp)
    80001c5e:	64a2                	ld	s1,8(sp)
    80001c60:	6105                	addi	sp,sp,32
    80001c62:	8082                	ret

0000000080001c64 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c64:	1101                	addi	sp,sp,-32
    80001c66:	ec06                	sd	ra,24(sp)
    80001c68:	e822                	sd	s0,16(sp)
    80001c6a:	e426                	sd	s1,8(sp)
    80001c6c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c6e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c72:	00074d63          	bltz	a4,80001c8c <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c76:	57fd                	li	a5,-1
    80001c78:	17fe                	slli	a5,a5,0x3f
    80001c7a:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c7c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c7e:	06f70363          	beq	a4,a5,80001ce4 <devintr+0x80>
  }
}
    80001c82:	60e2                	ld	ra,24(sp)
    80001c84:	6442                	ld	s0,16(sp)
    80001c86:	64a2                	ld	s1,8(sp)
    80001c88:	6105                	addi	sp,sp,32
    80001c8a:	8082                	ret
     (scause & 0xff) == 9){
    80001c8c:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001c90:	46a5                	li	a3,9
    80001c92:	fed792e3          	bne	a5,a3,80001c76 <devintr+0x12>
    int irq = plic_claim();
    80001c96:	00003097          	auipc	ra,0x3
    80001c9a:	772080e7          	jalr	1906(ra) # 80005408 <plic_claim>
    80001c9e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001ca0:	47a9                	li	a5,10
    80001ca2:	02f50763          	beq	a0,a5,80001cd0 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001ca6:	4785                	li	a5,1
    80001ca8:	02f50963          	beq	a0,a5,80001cda <devintr+0x76>
    return 1;
    80001cac:	4505                	li	a0,1
    } else if(irq){
    80001cae:	d8f1                	beqz	s1,80001c82 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cb0:	85a6                	mv	a1,s1
    80001cb2:	00006517          	auipc	a0,0x6
    80001cb6:	58e50513          	addi	a0,a0,1422 # 80008240 <states.0+0x38>
    80001cba:	00004097          	auipc	ra,0x4
    80001cbe:	230080e7          	jalr	560(ra) # 80005eea <printf>
      plic_complete(irq);
    80001cc2:	8526                	mv	a0,s1
    80001cc4:	00003097          	auipc	ra,0x3
    80001cc8:	768080e7          	jalr	1896(ra) # 8000542c <plic_complete>
    return 1;
    80001ccc:	4505                	li	a0,1
    80001cce:	bf55                	j	80001c82 <devintr+0x1e>
      uartintr();
    80001cd0:	00004097          	auipc	ra,0x4
    80001cd4:	628080e7          	jalr	1576(ra) # 800062f8 <uartintr>
    80001cd8:	b7ed                	j	80001cc2 <devintr+0x5e>
      virtio_disk_intr();
    80001cda:	00004097          	auipc	ra,0x4
    80001cde:	bde080e7          	jalr	-1058(ra) # 800058b8 <virtio_disk_intr>
    80001ce2:	b7c5                	j	80001cc2 <devintr+0x5e>
    if(cpuid() == 0){
    80001ce4:	fffff097          	auipc	ra,0xfffff
    80001ce8:	11a080e7          	jalr	282(ra) # 80000dfe <cpuid>
    80001cec:	c901                	beqz	a0,80001cfc <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cee:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cf2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cf4:	14479073          	csrw	sip,a5
    return 2;
    80001cf8:	4509                	li	a0,2
    80001cfa:	b761                	j	80001c82 <devintr+0x1e>
      clockintr();
    80001cfc:	00000097          	auipc	ra,0x0
    80001d00:	f22080e7          	jalr	-222(ra) # 80001c1e <clockintr>
    80001d04:	b7ed                	j	80001cee <devintr+0x8a>

0000000080001d06 <usertrap>:
{
    80001d06:	7139                	addi	sp,sp,-64
    80001d08:	fc06                	sd	ra,56(sp)
    80001d0a:	f822                	sd	s0,48(sp)
    80001d0c:	f426                	sd	s1,40(sp)
    80001d0e:	f04a                	sd	s2,32(sp)
    80001d10:	ec4e                	sd	s3,24(sp)
    80001d12:	e852                	sd	s4,16(sp)
    80001d14:	e456                	sd	s5,8(sp)
    80001d16:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d18:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d1c:	1007f793          	andi	a5,a5,256
    80001d20:	e7ad                	bnez	a5,80001d8a <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d22:	00003797          	auipc	a5,0x3
    80001d26:	5de78793          	addi	a5,a5,1502 # 80005300 <kernelvec>
    80001d2a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d2e:	fffff097          	auipc	ra,0xfffff
    80001d32:	0fc080e7          	jalr	252(ra) # 80000e2a <myproc>
    80001d36:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d38:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d3a:	14102773          	csrr	a4,sepc
    80001d3e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d40:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d44:	47a1                	li	a5,8
    80001d46:	06f71063          	bne	a4,a5,80001da6 <usertrap+0xa0>
    if(p->killed)
    80001d4a:	551c                	lw	a5,40(a0)
    80001d4c:	e7b9                	bnez	a5,80001d9a <usertrap+0x94>
    p->trapframe->epc += 4;
    80001d4e:	6cb8                	ld	a4,88(s1)
    80001d50:	6f1c                	ld	a5,24(a4)
    80001d52:	0791                	addi	a5,a5,4
    80001d54:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d56:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d5a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d5e:	10079073          	csrw	sstatus,a5
    syscall();
    80001d62:	00000097          	auipc	ra,0x0
    80001d66:	3b4080e7          	jalr	948(ra) # 80002116 <syscall>
  if(p->killed)
    80001d6a:	549c                	lw	a5,40(s1)
    80001d6c:	16079263          	bnez	a5,80001ed0 <usertrap+0x1ca>
  usertrapret();
    80001d70:	00000097          	auipc	ra,0x0
    80001d74:	e10080e7          	jalr	-496(ra) # 80001b80 <usertrapret>
}
    80001d78:	70e2                	ld	ra,56(sp)
    80001d7a:	7442                	ld	s0,48(sp)
    80001d7c:	74a2                	ld	s1,40(sp)
    80001d7e:	7902                	ld	s2,32(sp)
    80001d80:	69e2                	ld	s3,24(sp)
    80001d82:	6a42                	ld	s4,16(sp)
    80001d84:	6aa2                	ld	s5,8(sp)
    80001d86:	6121                	addi	sp,sp,64
    80001d88:	8082                	ret
    panic("usertrap: not from user mode");
    80001d8a:	00006517          	auipc	a0,0x6
    80001d8e:	4d650513          	addi	a0,a0,1238 # 80008260 <states.0+0x58>
    80001d92:	00004097          	auipc	ra,0x4
    80001d96:	10e080e7          	jalr	270(ra) # 80005ea0 <panic>
      exit(-1);
    80001d9a:	557d                	li	a0,-1
    80001d9c:	00000097          	auipc	ra,0x0
    80001da0:	9ae080e7          	jalr	-1618(ra) # 8000174a <exit>
    80001da4:	b76d                	j	80001d4e <usertrap+0x48>
  } else if((which_dev = devintr()) != 0){
    80001da6:	00000097          	auipc	ra,0x0
    80001daa:	ebe080e7          	jalr	-322(ra) # 80001c64 <devintr>
    80001dae:	892a                	mv	s2,a0
    80001db0:	10051d63          	bnez	a0,80001eca <usertrap+0x1c4>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db4:	14202773          	csrr	a4,scause
  else if(r_scause()==13||r_scause()==15)
    80001db8:	47b5                	li	a5,13
    80001dba:	00f70763          	beq	a4,a5,80001dc8 <usertrap+0xc2>
    80001dbe:	14202773          	csrr	a4,scause
    80001dc2:	47bd                	li	a5,15
    80001dc4:	0af71d63          	bne	a4,a5,80001e7e <usertrap+0x178>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dc8:	14302573          	csrr	a0,stval
    int idx=findmap1(stval);
    80001dcc:	00000097          	auipc	ra,0x0
    80001dd0:	ccc080e7          	jalr	-820(ra) # 80001a98 <findmap1>
    80001dd4:	89aa                	mv	s3,a0
    if(idx>=0)
    80001dd6:	0c054b63          	bltz	a0,80001eac <usertrap+0x1a6>
      int prot=(p->map_region[idx]).mmprot;
    80001dda:	00351793          	slli	a5,a0,0x3
    80001dde:	8f89                	sub	a5,a5,a0
    80001de0:	078e                	slli	a5,a5,0x3
    80001de2:	97a6                	add	a5,a5,s1
    80001de4:	1907a703          	lw	a4,400(a5)
      uint64 length=(p->map_region[idx]).mmlength;
    80001de8:	1887ba03          	ld	s4,392(a5)
      if(prot&PROT_READ)
    80001dec:	00177793          	andi	a5,a4,1
      int PTEword=PTE_U;
    80001df0:	46c1                	li	a3,16
      if(prot&PROT_READ)
    80001df2:	c391                	beqz	a5,80001df6 <usertrap+0xf0>
        PTEword|=PTE_R;
    80001df4:	46c9                	li	a3,18
      if(prot&PROT_WRITE)
    80001df6:	00277793          	andi	a5,a4,2
    80001dfa:	c399                	beqz	a5,80001e00 <usertrap+0xfa>
        PTEword|=PTE_W;      
    80001dfc:	0046e693          	ori	a3,a3,4
      if(prot&PROT_EXEC)
    80001e00:	8b11                	andi	a4,a4,4
    80001e02:	c319                	beqz	a4,80001e08 <usertrap+0x102>
        PTEword|=PTE_X;      
    80001e04:	0086e693          	ori	a3,a3,8
      uint64 newsz=(p->map_region[idx]).mmapend;
    80001e08:	00399793          	slli	a5,s3,0x3
    80001e0c:	413787b3          	sub	a5,a5,s3
    80001e10:	078e                	slli	a5,a5,0x3
    80001e12:	97a6                	add	a5,a5,s1
      if((newsz=mmapalloc(p->pagetable, sz, newsz,PTEword))==0){
    80001e14:	1807b603          	ld	a2,384(a5)
    80001e18:	1787b583          	ld	a1,376(a5)
    80001e1c:	68a8                	ld	a0,80(s1)
    80001e1e:	00000097          	auipc	ra,0x0
    80001e22:	cbc080e7          	jalr	-836(ra) # 80001ada <mmapalloc>
    80001e26:	c139                	beqz	a0,80001e6c <usertrap+0x166>
      struct inode* ip=p->map_region[idx].ip;
    80001e28:	00399913          	slli	s2,s3,0x3
    80001e2c:	413907b3          	sub	a5,s2,s3
    80001e30:	078e                	slli	a5,a5,0x3
    80001e32:	97a6                	add	a5,a5,s1
    80001e34:	1707ba83          	ld	s5,368(a5)
      ilock(ip);
    80001e38:	8556                	mv	a0,s5
    80001e3a:	00001097          	auipc	ra,0x1
    80001e3e:	dda080e7          	jalr	-550(ra) # 80002c14 <ilock>
      readi(ip,1,(p->map_region[idx]).mmapaddr,0,length);
    80001e42:	41390933          	sub	s2,s2,s3
    80001e46:	090e                	slli	s2,s2,0x3
    80001e48:	9926                	add	s2,s2,s1
    80001e4a:	000a071b          	sext.w	a4,s4
    80001e4e:	4681                	li	a3,0
    80001e50:	17893603          	ld	a2,376(s2)
    80001e54:	4585                	li	a1,1
    80001e56:	8556                	mv	a0,s5
    80001e58:	00001097          	auipc	ra,0x1
    80001e5c:	070080e7          	jalr	112(ra) # 80002ec8 <readi>
      iunlock(ip);
    80001e60:	8556                	mv	a0,s5
    80001e62:	00001097          	auipc	ra,0x1
    80001e66:	e74080e7          	jalr	-396(ra) # 80002cd6 <iunlock>
    80001e6a:	b701                	j	80001d6a <usertrap+0x64>
        printf("allocate error");
    80001e6c:	00006517          	auipc	a0,0x6
    80001e70:	41450513          	addi	a0,a0,1044 # 80008280 <states.0+0x78>
    80001e74:	00004097          	auipc	ra,0x4
    80001e78:	076080e7          	jalr	118(ra) # 80005eea <printf>
    80001e7c:	b775                	j	80001e28 <usertrap+0x122>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e7e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e82:	5890                	lw	a2,48(s1)
    80001e84:	00006517          	auipc	a0,0x6
    80001e88:	40c50513          	addi	a0,a0,1036 # 80008290 <states.0+0x88>
    80001e8c:	00004097          	auipc	ra,0x4
    80001e90:	05e080e7          	jalr	94(ra) # 80005eea <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e94:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e98:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e9c:	00006517          	auipc	a0,0x6
    80001ea0:	42450513          	addi	a0,a0,1060 # 800082c0 <states.0+0xb8>
    80001ea4:	00004097          	auipc	ra,0x4
    80001ea8:	046080e7          	jalr	70(ra) # 80005eea <printf>
    p->killed = 1;
    80001eac:	4785                	li	a5,1
    80001eae:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001eb0:	557d                	li	a0,-1
    80001eb2:	00000097          	auipc	ra,0x0
    80001eb6:	898080e7          	jalr	-1896(ra) # 8000174a <exit>
  if(which_dev == 2)
    80001eba:	4789                	li	a5,2
    80001ebc:	eaf91ae3          	bne	s2,a5,80001d70 <usertrap+0x6a>
    yield();
    80001ec0:	fffff097          	auipc	ra,0xfffff
    80001ec4:	5f2080e7          	jalr	1522(ra) # 800014b2 <yield>
    80001ec8:	b565                	j	80001d70 <usertrap+0x6a>
  if(p->killed)
    80001eca:	549c                	lw	a5,40(s1)
    80001ecc:	d7fd                	beqz	a5,80001eba <usertrap+0x1b4>
    80001ece:	b7cd                	j	80001eb0 <usertrap+0x1aa>
    80001ed0:	4901                	li	s2,0
    80001ed2:	bff9                	j	80001eb0 <usertrap+0x1aa>

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
    80001f00:	d68080e7          	jalr	-664(ra) # 80001c64 <devintr>
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
    80001f26:	3be50513          	addi	a0,a0,958 # 800082e0 <states.0+0xd8>
    80001f2a:	00004097          	auipc	ra,0x4
    80001f2e:	f76080e7          	jalr	-138(ra) # 80005ea0 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f32:	00006517          	auipc	a0,0x6
    80001f36:	3d650513          	addi	a0,a0,982 # 80008308 <states.0+0x100>
    80001f3a:	00004097          	auipc	ra,0x4
    80001f3e:	f66080e7          	jalr	-154(ra) # 80005ea0 <panic>
    printf("scause %p\n", scause);
    80001f42:	85ce                	mv	a1,s3
    80001f44:	00006517          	auipc	a0,0x6
    80001f48:	3e450513          	addi	a0,a0,996 # 80008328 <states.0+0x120>
    80001f4c:	00004097          	auipc	ra,0x4
    80001f50:	f9e080e7          	jalr	-98(ra) # 80005eea <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f54:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f58:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f5c:	00006517          	auipc	a0,0x6
    80001f60:	3dc50513          	addi	a0,a0,988 # 80008338 <states.0+0x130>
    80001f64:	00004097          	auipc	ra,0x4
    80001f68:	f86080e7          	jalr	-122(ra) # 80005eea <printf>
    panic("kerneltrap");
    80001f6c:	00006517          	auipc	a0,0x6
    80001f70:	3e450513          	addi	a0,a0,996 # 80008350 <states.0+0x148>
    80001f74:	00004097          	auipc	ra,0x4
    80001f78:	f2c080e7          	jalr	-212(ra) # 80005ea0 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f7c:	fffff097          	auipc	ra,0xfffff
    80001f80:	eae080e7          	jalr	-338(ra) # 80000e2a <myproc>
    80001f84:	d541                	beqz	a0,80001f0c <kerneltrap+0x38>
    80001f86:	fffff097          	auipc	ra,0xfffff
    80001f8a:	ea4080e7          	jalr	-348(ra) # 80000e2a <myproc>
    80001f8e:	4d18                	lw	a4,24(a0)
    80001f90:	4791                	li	a5,4
    80001f92:	f6f71de3          	bne	a4,a5,80001f0c <kerneltrap+0x38>
    yield();
    80001f96:	fffff097          	auipc	ra,0xfffff
    80001f9a:	51c080e7          	jalr	1308(ra) # 800014b2 <yield>
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
    80001fb0:	e7e080e7          	jalr	-386(ra) # 80000e2a <myproc>
  switch (n) {
    80001fb4:	4795                	li	a5,5
    80001fb6:	0497e163          	bltu	a5,s1,80001ff8 <argraw+0x58>
    80001fba:	048a                	slli	s1,s1,0x2
    80001fbc:	00006717          	auipc	a4,0x6
    80001fc0:	3cc70713          	addi	a4,a4,972 # 80008388 <states.0+0x180>
    80001fc4:	94ba                	add	s1,s1,a4
    80001fc6:	409c                	lw	a5,0(s1)
    80001fc8:	97ba                	add	a5,a5,a4
    80001fca:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fcc:	6d3c                	ld	a5,88(a0)
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
    80001fda:	6d3c                	ld	a5,88(a0)
    80001fdc:	7fa8                	ld	a0,120(a5)
    80001fde:	bfcd                	j	80001fd0 <argraw+0x30>
    return p->trapframe->a2;
    80001fe0:	6d3c                	ld	a5,88(a0)
    80001fe2:	63c8                	ld	a0,128(a5)
    80001fe4:	b7f5                	j	80001fd0 <argraw+0x30>
    return p->trapframe->a3;
    80001fe6:	6d3c                	ld	a5,88(a0)
    80001fe8:	67c8                	ld	a0,136(a5)
    80001fea:	b7dd                	j	80001fd0 <argraw+0x30>
    return p->trapframe->a4;
    80001fec:	6d3c                	ld	a5,88(a0)
    80001fee:	6bc8                	ld	a0,144(a5)
    80001ff0:	b7c5                	j	80001fd0 <argraw+0x30>
    return p->trapframe->a5;
    80001ff2:	6d3c                	ld	a5,88(a0)
    80001ff4:	6fc8                	ld	a0,152(a5)
    80001ff6:	bfe9                	j	80001fd0 <argraw+0x30>
  panic("argraw");
    80001ff8:	00006517          	auipc	a0,0x6
    80001ffc:	36850513          	addi	a0,a0,872 # 80008360 <states.0+0x158>
    80002000:	00004097          	auipc	ra,0x4
    80002004:	ea0080e7          	jalr	-352(ra) # 80005ea0 <panic>

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
    8000201c:	e12080e7          	jalr	-494(ra) # 80000e2a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002020:	653c                	ld	a5,72(a0)
    80002022:	02f4f863          	bgeu	s1,a5,80002052 <fetchaddr+0x4a>
    80002026:	00848713          	addi	a4,s1,8
    8000202a:	02e7e663          	bltu	a5,a4,80002056 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000202e:	46a1                	li	a3,8
    80002030:	8626                	mv	a2,s1
    80002032:	85ca                	mv	a1,s2
    80002034:	6928                	ld	a0,80(a0)
    80002036:	fffff097          	auipc	ra,0xfffff
    8000203a:	b44080e7          	jalr	-1212(ra) # 80000b7a <copyin>
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
    80002072:	dbc080e7          	jalr	-580(ra) # 80000e2a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002076:	86ce                	mv	a3,s3
    80002078:	864a                	mv	a2,s2
    8000207a:	85a6                	mv	a1,s1
    8000207c:	6928                	ld	a0,80(a0)
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	b8a080e7          	jalr	-1142(ra) # 80000c08 <copyinstr>
  if(err < 0)
    80002086:	00054763          	bltz	a0,80002094 <fetchstr+0x3a>
  return strlen(buf);
    8000208a:	8526                	mv	a0,s1
    8000208c:	ffffe097          	auipc	ra,0xffffe
    80002090:	26a080e7          	jalr	618(ra) # 800002f6 <strlen>
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
    80002126:	d08080e7          	jalr	-760(ra) # 80000e2a <myproc>
    8000212a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000212c:	05853903          	ld	s2,88(a0)
    80002130:	0a893783          	ld	a5,168(s2)
    80002134:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002138:	37fd                	addiw	a5,a5,-1
    8000213a:	4759                	li	a4,22
    8000213c:	00f76f63          	bltu	a4,a5,8000215a <syscall+0x44>
    80002140:	00369713          	slli	a4,a3,0x3
    80002144:	00006797          	auipc	a5,0x6
    80002148:	25c78793          	addi	a5,a5,604 # 800083a0 <syscalls>
    8000214c:	97ba                	add	a5,a5,a4
    8000214e:	639c                	ld	a5,0(a5)
    80002150:	c789                	beqz	a5,8000215a <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002152:	9782                	jalr	a5
    80002154:	06a93823          	sd	a0,112(s2)
    80002158:	a839                	j	80002176 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000215a:	15848613          	addi	a2,s1,344
    8000215e:	588c                	lw	a1,48(s1)
    80002160:	00006517          	auipc	a0,0x6
    80002164:	20850513          	addi	a0,a0,520 # 80008368 <states.0+0x160>
    80002168:	00004097          	auipc	ra,0x4
    8000216c:	d82080e7          	jalr	-638(ra) # 80005eea <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002170:	6cbc                	ld	a5,88(s1)
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
    800021a6:	5a8080e7          	jalr	1448(ra) # 8000174a <exit>
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
    800021c2:	c6c080e7          	jalr	-916(ra) # 80000e2a <myproc>
}
    800021c6:	5908                	lw	a0,48(a0)
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
    800021dc:	024080e7          	jalr	36(ra) # 800011fc <fork>
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
    8000220e:	348080e7          	jalr	840(ra) # 80001552 <wait>
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
    8000223e:	bf0080e7          	jalr	-1040(ra) # 80000e2a <myproc>
    80002242:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002244:	fdc42503          	lw	a0,-36(s0)
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	f3c080e7          	jalr	-196(ra) # 80001184 <growproc>
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
    80002286:	0001b517          	auipc	a0,0x1b
    8000228a:	bfa50513          	addi	a0,a0,-1030 # 8001ce80 <tickslock>
    8000228e:	00004097          	auipc	ra,0x4
    80002292:	14a080e7          	jalr	330(ra) # 800063d8 <acquire>
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
    800022a4:	0001b997          	auipc	s3,0x1b
    800022a8:	bdc98993          	addi	s3,s3,-1060 # 8001ce80 <tickslock>
    800022ac:	00007497          	auipc	s1,0x7
    800022b0:	d6c48493          	addi	s1,s1,-660 # 80009018 <ticks>
    if(myproc()->killed){
    800022b4:	fffff097          	auipc	ra,0xfffff
    800022b8:	b76080e7          	jalr	-1162(ra) # 80000e2a <myproc>
    800022bc:	551c                	lw	a5,40(a0)
    800022be:	ef9d                	bnez	a5,800022fc <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022c0:	85ce                	mv	a1,s3
    800022c2:	8526                	mv	a0,s1
    800022c4:	fffff097          	auipc	ra,0xfffff
    800022c8:	22a080e7          	jalr	554(ra) # 800014ee <sleep>
  while(ticks - ticks0 < n){
    800022cc:	409c                	lw	a5,0(s1)
    800022ce:	412787bb          	subw	a5,a5,s2
    800022d2:	fcc42703          	lw	a4,-52(s0)
    800022d6:	fce7efe3          	bltu	a5,a4,800022b4 <sys_sleep+0x50>
  }
  release(&tickslock);
    800022da:	0001b517          	auipc	a0,0x1b
    800022de:	ba650513          	addi	a0,a0,-1114 # 8001ce80 <tickslock>
    800022e2:	00004097          	auipc	ra,0x4
    800022e6:	1aa080e7          	jalr	426(ra) # 8000648c <release>
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
    800022fc:	0001b517          	auipc	a0,0x1b
    80002300:	b8450513          	addi	a0,a0,-1148 # 8001ce80 <tickslock>
    80002304:	00004097          	auipc	ra,0x4
    80002308:	188080e7          	jalr	392(ra) # 8000648c <release>
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
    80002336:	4ee080e7          	jalr	1262(ra) # 80001820 <kill>
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
    8000234c:	0001b517          	auipc	a0,0x1b
    80002350:	b3450513          	addi	a0,a0,-1228 # 8001ce80 <tickslock>
    80002354:	00004097          	auipc	ra,0x4
    80002358:	084080e7          	jalr	132(ra) # 800063d8 <acquire>
  xticks = ticks;
    8000235c:	00007497          	auipc	s1,0x7
    80002360:	cbc4a483          	lw	s1,-836(s1) # 80009018 <ticks>
  release(&tickslock);
    80002364:	0001b517          	auipc	a0,0x1b
    80002368:	b1c50513          	addi	a0,a0,-1252 # 8001ce80 <tickslock>
    8000236c:	00004097          	auipc	ra,0x4
    80002370:	120080e7          	jalr	288(ra) # 8000648c <release>
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
  struct buf head;
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
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002394:	00006597          	auipc	a1,0x6
    80002398:	0cc58593          	addi	a1,a1,204 # 80008460 <syscalls+0xc0>
    8000239c:	0001b517          	auipc	a0,0x1b
    800023a0:	afc50513          	addi	a0,a0,-1284 # 8001ce98 <bcache>
    800023a4:	00004097          	auipc	ra,0x4
    800023a8:	fa4080e7          	jalr	-92(ra) # 80006348 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023ac:	00023797          	auipc	a5,0x23
    800023b0:	aec78793          	addi	a5,a5,-1300 # 80024e98 <bcache+0x8000>
    800023b4:	00023717          	auipc	a4,0x23
    800023b8:	d4c70713          	addi	a4,a4,-692 # 80025100 <bcache+0x8268>
    800023bc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023c0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023c4:	0001b497          	auipc	s1,0x1b
    800023c8:	aec48493          	addi	s1,s1,-1300 # 8001ceb0 <bcache+0x18>
    b->next = bcache.head.next;
    800023cc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023ce:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023d0:	00006a17          	auipc	s4,0x6
    800023d4:	098a0a13          	addi	s4,s4,152 # 80008468 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023d8:	2b893783          	ld	a5,696(s2)
    800023dc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023de:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023e2:	85d2                	mv	a1,s4
    800023e4:	01048513          	addi	a0,s1,16
    800023e8:	00001097          	auipc	ra,0x1
    800023ec:	4c2080e7          	jalr	1218(ra) # 800038aa <initsleeplock>
    bcache.head.next->prev = b;
    800023f0:	2b893783          	ld	a5,696(s2)
    800023f4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023f6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023fa:	45848493          	addi	s1,s1,1112
    800023fe:	fd349de3          	bne	s1,s3,800023d8 <binit+0x54>
  }
}
    80002402:	70a2                	ld	ra,40(sp)
    80002404:	7402                	ld	s0,32(sp)
    80002406:	64e2                	ld	s1,24(sp)
    80002408:	6942                	ld	s2,16(sp)
    8000240a:	69a2                	ld	s3,8(sp)
    8000240c:	6a02                	ld	s4,0(sp)
    8000240e:	6145                	addi	sp,sp,48
    80002410:	8082                	ret

0000000080002412 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002412:	7179                	addi	sp,sp,-48
    80002414:	f406                	sd	ra,40(sp)
    80002416:	f022                	sd	s0,32(sp)
    80002418:	ec26                	sd	s1,24(sp)
    8000241a:	e84a                	sd	s2,16(sp)
    8000241c:	e44e                	sd	s3,8(sp)
    8000241e:	1800                	addi	s0,sp,48
    80002420:	892a                	mv	s2,a0
    80002422:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002424:	0001b517          	auipc	a0,0x1b
    80002428:	a7450513          	addi	a0,a0,-1420 # 8001ce98 <bcache>
    8000242c:	00004097          	auipc	ra,0x4
    80002430:	fac080e7          	jalr	-84(ra) # 800063d8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002434:	00023497          	auipc	s1,0x23
    80002438:	d1c4b483          	ld	s1,-740(s1) # 80025150 <bcache+0x82b8>
    8000243c:	00023797          	auipc	a5,0x23
    80002440:	cc478793          	addi	a5,a5,-828 # 80025100 <bcache+0x8268>
    80002444:	02f48f63          	beq	s1,a5,80002482 <bread+0x70>
    80002448:	873e                	mv	a4,a5
    8000244a:	a021                	j	80002452 <bread+0x40>
    8000244c:	68a4                	ld	s1,80(s1)
    8000244e:	02e48a63          	beq	s1,a4,80002482 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002452:	449c                	lw	a5,8(s1)
    80002454:	ff279ce3          	bne	a5,s2,8000244c <bread+0x3a>
    80002458:	44dc                	lw	a5,12(s1)
    8000245a:	ff3799e3          	bne	a5,s3,8000244c <bread+0x3a>
      b->refcnt++;
    8000245e:	40bc                	lw	a5,64(s1)
    80002460:	2785                	addiw	a5,a5,1
    80002462:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002464:	0001b517          	auipc	a0,0x1b
    80002468:	a3450513          	addi	a0,a0,-1484 # 8001ce98 <bcache>
    8000246c:	00004097          	auipc	ra,0x4
    80002470:	020080e7          	jalr	32(ra) # 8000648c <release>
      acquiresleep(&b->lock);
    80002474:	01048513          	addi	a0,s1,16
    80002478:	00001097          	auipc	ra,0x1
    8000247c:	46c080e7          	jalr	1132(ra) # 800038e4 <acquiresleep>
      return b;
    80002480:	a8b9                	j	800024de <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002482:	00023497          	auipc	s1,0x23
    80002486:	cc64b483          	ld	s1,-826(s1) # 80025148 <bcache+0x82b0>
    8000248a:	00023797          	auipc	a5,0x23
    8000248e:	c7678793          	addi	a5,a5,-906 # 80025100 <bcache+0x8268>
    80002492:	00f48863          	beq	s1,a5,800024a2 <bread+0x90>
    80002496:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002498:	40bc                	lw	a5,64(s1)
    8000249a:	cf81                	beqz	a5,800024b2 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000249c:	64a4                	ld	s1,72(s1)
    8000249e:	fee49de3          	bne	s1,a4,80002498 <bread+0x86>
  panic("bget: no buffers");
    800024a2:	00006517          	auipc	a0,0x6
    800024a6:	fce50513          	addi	a0,a0,-50 # 80008470 <syscalls+0xd0>
    800024aa:	00004097          	auipc	ra,0x4
    800024ae:	9f6080e7          	jalr	-1546(ra) # 80005ea0 <panic>
      b->dev = dev;
    800024b2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024b6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024ba:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024be:	4785                	li	a5,1
    800024c0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024c2:	0001b517          	auipc	a0,0x1b
    800024c6:	9d650513          	addi	a0,a0,-1578 # 8001ce98 <bcache>
    800024ca:	00004097          	auipc	ra,0x4
    800024ce:	fc2080e7          	jalr	-62(ra) # 8000648c <release>
      acquiresleep(&b->lock);
    800024d2:	01048513          	addi	a0,s1,16
    800024d6:	00001097          	auipc	ra,0x1
    800024da:	40e080e7          	jalr	1038(ra) # 800038e4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024de:	409c                	lw	a5,0(s1)
    800024e0:	cb89                	beqz	a5,800024f2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024e2:	8526                	mv	a0,s1
    800024e4:	70a2                	ld	ra,40(sp)
    800024e6:	7402                	ld	s0,32(sp)
    800024e8:	64e2                	ld	s1,24(sp)
    800024ea:	6942                	ld	s2,16(sp)
    800024ec:	69a2                	ld	s3,8(sp)
    800024ee:	6145                	addi	sp,sp,48
    800024f0:	8082                	ret
    virtio_disk_rw(b, 0);
    800024f2:	4581                	li	a1,0
    800024f4:	8526                	mv	a0,s1
    800024f6:	00003097          	auipc	ra,0x3
    800024fa:	13c080e7          	jalr	316(ra) # 80005632 <virtio_disk_rw>
    b->valid = 1;
    800024fe:	4785                	li	a5,1
    80002500:	c09c                	sw	a5,0(s1)
  return b;
    80002502:	b7c5                	j	800024e2 <bread+0xd0>

0000000080002504 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002504:	1101                	addi	sp,sp,-32
    80002506:	ec06                	sd	ra,24(sp)
    80002508:	e822                	sd	s0,16(sp)
    8000250a:	e426                	sd	s1,8(sp)
    8000250c:	1000                	addi	s0,sp,32
    8000250e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002510:	0541                	addi	a0,a0,16
    80002512:	00001097          	auipc	ra,0x1
    80002516:	46c080e7          	jalr	1132(ra) # 8000397e <holdingsleep>
    8000251a:	cd01                	beqz	a0,80002532 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000251c:	4585                	li	a1,1
    8000251e:	8526                	mv	a0,s1
    80002520:	00003097          	auipc	ra,0x3
    80002524:	112080e7          	jalr	274(ra) # 80005632 <virtio_disk_rw>
}
    80002528:	60e2                	ld	ra,24(sp)
    8000252a:	6442                	ld	s0,16(sp)
    8000252c:	64a2                	ld	s1,8(sp)
    8000252e:	6105                	addi	sp,sp,32
    80002530:	8082                	ret
    panic("bwrite");
    80002532:	00006517          	auipc	a0,0x6
    80002536:	f5650513          	addi	a0,a0,-170 # 80008488 <syscalls+0xe8>
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	966080e7          	jalr	-1690(ra) # 80005ea0 <panic>

0000000080002542 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002542:	1101                	addi	sp,sp,-32
    80002544:	ec06                	sd	ra,24(sp)
    80002546:	e822                	sd	s0,16(sp)
    80002548:	e426                	sd	s1,8(sp)
    8000254a:	e04a                	sd	s2,0(sp)
    8000254c:	1000                	addi	s0,sp,32
    8000254e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002550:	01050913          	addi	s2,a0,16
    80002554:	854a                	mv	a0,s2
    80002556:	00001097          	auipc	ra,0x1
    8000255a:	428080e7          	jalr	1064(ra) # 8000397e <holdingsleep>
    8000255e:	c92d                	beqz	a0,800025d0 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002560:	854a                	mv	a0,s2
    80002562:	00001097          	auipc	ra,0x1
    80002566:	3d8080e7          	jalr	984(ra) # 8000393a <releasesleep>

  acquire(&bcache.lock);
    8000256a:	0001b517          	auipc	a0,0x1b
    8000256e:	92e50513          	addi	a0,a0,-1746 # 8001ce98 <bcache>
    80002572:	00004097          	auipc	ra,0x4
    80002576:	e66080e7          	jalr	-410(ra) # 800063d8 <acquire>
  b->refcnt--;
    8000257a:	40bc                	lw	a5,64(s1)
    8000257c:	37fd                	addiw	a5,a5,-1
    8000257e:	0007871b          	sext.w	a4,a5
    80002582:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002584:	eb05                	bnez	a4,800025b4 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002586:	68bc                	ld	a5,80(s1)
    80002588:	64b8                	ld	a4,72(s1)
    8000258a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000258c:	64bc                	ld	a5,72(s1)
    8000258e:	68b8                	ld	a4,80(s1)
    80002590:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002592:	00023797          	auipc	a5,0x23
    80002596:	90678793          	addi	a5,a5,-1786 # 80024e98 <bcache+0x8000>
    8000259a:	2b87b703          	ld	a4,696(a5)
    8000259e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025a0:	00023717          	auipc	a4,0x23
    800025a4:	b6070713          	addi	a4,a4,-1184 # 80025100 <bcache+0x8268>
    800025a8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025aa:	2b87b703          	ld	a4,696(a5)
    800025ae:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025b0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025b4:	0001b517          	auipc	a0,0x1b
    800025b8:	8e450513          	addi	a0,a0,-1820 # 8001ce98 <bcache>
    800025bc:	00004097          	auipc	ra,0x4
    800025c0:	ed0080e7          	jalr	-304(ra) # 8000648c <release>
}
    800025c4:	60e2                	ld	ra,24(sp)
    800025c6:	6442                	ld	s0,16(sp)
    800025c8:	64a2                	ld	s1,8(sp)
    800025ca:	6902                	ld	s2,0(sp)
    800025cc:	6105                	addi	sp,sp,32
    800025ce:	8082                	ret
    panic("brelse");
    800025d0:	00006517          	auipc	a0,0x6
    800025d4:	ec050513          	addi	a0,a0,-320 # 80008490 <syscalls+0xf0>
    800025d8:	00004097          	auipc	ra,0x4
    800025dc:	8c8080e7          	jalr	-1848(ra) # 80005ea0 <panic>

00000000800025e0 <bpin>:

void
bpin(struct buf *b) {
    800025e0:	1101                	addi	sp,sp,-32
    800025e2:	ec06                	sd	ra,24(sp)
    800025e4:	e822                	sd	s0,16(sp)
    800025e6:	e426                	sd	s1,8(sp)
    800025e8:	1000                	addi	s0,sp,32
    800025ea:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025ec:	0001b517          	auipc	a0,0x1b
    800025f0:	8ac50513          	addi	a0,a0,-1876 # 8001ce98 <bcache>
    800025f4:	00004097          	auipc	ra,0x4
    800025f8:	de4080e7          	jalr	-540(ra) # 800063d8 <acquire>
  b->refcnt++;
    800025fc:	40bc                	lw	a5,64(s1)
    800025fe:	2785                	addiw	a5,a5,1
    80002600:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002602:	0001b517          	auipc	a0,0x1b
    80002606:	89650513          	addi	a0,a0,-1898 # 8001ce98 <bcache>
    8000260a:	00004097          	auipc	ra,0x4
    8000260e:	e82080e7          	jalr	-382(ra) # 8000648c <release>
}
    80002612:	60e2                	ld	ra,24(sp)
    80002614:	6442                	ld	s0,16(sp)
    80002616:	64a2                	ld	s1,8(sp)
    80002618:	6105                	addi	sp,sp,32
    8000261a:	8082                	ret

000000008000261c <bunpin>:

void
bunpin(struct buf *b) {
    8000261c:	1101                	addi	sp,sp,-32
    8000261e:	ec06                	sd	ra,24(sp)
    80002620:	e822                	sd	s0,16(sp)
    80002622:	e426                	sd	s1,8(sp)
    80002624:	1000                	addi	s0,sp,32
    80002626:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002628:	0001b517          	auipc	a0,0x1b
    8000262c:	87050513          	addi	a0,a0,-1936 # 8001ce98 <bcache>
    80002630:	00004097          	auipc	ra,0x4
    80002634:	da8080e7          	jalr	-600(ra) # 800063d8 <acquire>
  b->refcnt--;
    80002638:	40bc                	lw	a5,64(s1)
    8000263a:	37fd                	addiw	a5,a5,-1
    8000263c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000263e:	0001b517          	auipc	a0,0x1b
    80002642:	85a50513          	addi	a0,a0,-1958 # 8001ce98 <bcache>
    80002646:	00004097          	auipc	ra,0x4
    8000264a:	e46080e7          	jalr	-442(ra) # 8000648c <release>
}
    8000264e:	60e2                	ld	ra,24(sp)
    80002650:	6442                	ld	s0,16(sp)
    80002652:	64a2                	ld	s1,8(sp)
    80002654:	6105                	addi	sp,sp,32
    80002656:	8082                	ret

0000000080002658 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002658:	1101                	addi	sp,sp,-32
    8000265a:	ec06                	sd	ra,24(sp)
    8000265c:	e822                	sd	s0,16(sp)
    8000265e:	e426                	sd	s1,8(sp)
    80002660:	e04a                	sd	s2,0(sp)
    80002662:	1000                	addi	s0,sp,32
    80002664:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002666:	00d5d59b          	srliw	a1,a1,0xd
    8000266a:	00023797          	auipc	a5,0x23
    8000266e:	f0a7a783          	lw	a5,-246(a5) # 80025574 <sb+0x1c>
    80002672:	9dbd                	addw	a1,a1,a5
    80002674:	00000097          	auipc	ra,0x0
    80002678:	d9e080e7          	jalr	-610(ra) # 80002412 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000267c:	0074f713          	andi	a4,s1,7
    80002680:	4785                	li	a5,1
    80002682:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002686:	14ce                	slli	s1,s1,0x33
    80002688:	90d9                	srli	s1,s1,0x36
    8000268a:	00950733          	add	a4,a0,s1
    8000268e:	05874703          	lbu	a4,88(a4)
    80002692:	00e7f6b3          	and	a3,a5,a4
    80002696:	c69d                	beqz	a3,800026c4 <bfree+0x6c>
    80002698:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000269a:	94aa                	add	s1,s1,a0
    8000269c:	fff7c793          	not	a5,a5
    800026a0:	8f7d                	and	a4,a4,a5
    800026a2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800026a6:	00001097          	auipc	ra,0x1
    800026aa:	120080e7          	jalr	288(ra) # 800037c6 <log_write>
  brelse(bp);
    800026ae:	854a                	mv	a0,s2
    800026b0:	00000097          	auipc	ra,0x0
    800026b4:	e92080e7          	jalr	-366(ra) # 80002542 <brelse>
}
    800026b8:	60e2                	ld	ra,24(sp)
    800026ba:	6442                	ld	s0,16(sp)
    800026bc:	64a2                	ld	s1,8(sp)
    800026be:	6902                	ld	s2,0(sp)
    800026c0:	6105                	addi	sp,sp,32
    800026c2:	8082                	ret
    panic("freeing free block");
    800026c4:	00006517          	auipc	a0,0x6
    800026c8:	dd450513          	addi	a0,a0,-556 # 80008498 <syscalls+0xf8>
    800026cc:	00003097          	auipc	ra,0x3
    800026d0:	7d4080e7          	jalr	2004(ra) # 80005ea0 <panic>

00000000800026d4 <balloc>:
{
    800026d4:	711d                	addi	sp,sp,-96
    800026d6:	ec86                	sd	ra,88(sp)
    800026d8:	e8a2                	sd	s0,80(sp)
    800026da:	e4a6                	sd	s1,72(sp)
    800026dc:	e0ca                	sd	s2,64(sp)
    800026de:	fc4e                	sd	s3,56(sp)
    800026e0:	f852                	sd	s4,48(sp)
    800026e2:	f456                	sd	s5,40(sp)
    800026e4:	f05a                	sd	s6,32(sp)
    800026e6:	ec5e                	sd	s7,24(sp)
    800026e8:	e862                	sd	s8,16(sp)
    800026ea:	e466                	sd	s9,8(sp)
    800026ec:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026ee:	00023797          	auipc	a5,0x23
    800026f2:	e6e7a783          	lw	a5,-402(a5) # 8002555c <sb+0x4>
    800026f6:	cbc1                	beqz	a5,80002786 <balloc+0xb2>
    800026f8:	8baa                	mv	s7,a0
    800026fa:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026fc:	00023b17          	auipc	s6,0x23
    80002700:	e5cb0b13          	addi	s6,s6,-420 # 80025558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002704:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002706:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002708:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000270a:	6c89                	lui	s9,0x2
    8000270c:	a831                	j	80002728 <balloc+0x54>
    brelse(bp);
    8000270e:	854a                	mv	a0,s2
    80002710:	00000097          	auipc	ra,0x0
    80002714:	e32080e7          	jalr	-462(ra) # 80002542 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002718:	015c87bb          	addw	a5,s9,s5
    8000271c:	00078a9b          	sext.w	s5,a5
    80002720:	004b2703          	lw	a4,4(s6)
    80002724:	06eaf163          	bgeu	s5,a4,80002786 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002728:	41fad79b          	sraiw	a5,s5,0x1f
    8000272c:	0137d79b          	srliw	a5,a5,0x13
    80002730:	015787bb          	addw	a5,a5,s5
    80002734:	40d7d79b          	sraiw	a5,a5,0xd
    80002738:	01cb2583          	lw	a1,28(s6)
    8000273c:	9dbd                	addw	a1,a1,a5
    8000273e:	855e                	mv	a0,s7
    80002740:	00000097          	auipc	ra,0x0
    80002744:	cd2080e7          	jalr	-814(ra) # 80002412 <bread>
    80002748:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000274a:	004b2503          	lw	a0,4(s6)
    8000274e:	000a849b          	sext.w	s1,s5
    80002752:	8762                	mv	a4,s8
    80002754:	faa4fde3          	bgeu	s1,a0,8000270e <balloc+0x3a>
      m = 1 << (bi % 8);
    80002758:	00777693          	andi	a3,a4,7
    8000275c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002760:	41f7579b          	sraiw	a5,a4,0x1f
    80002764:	01d7d79b          	srliw	a5,a5,0x1d
    80002768:	9fb9                	addw	a5,a5,a4
    8000276a:	4037d79b          	sraiw	a5,a5,0x3
    8000276e:	00f90633          	add	a2,s2,a5
    80002772:	05864603          	lbu	a2,88(a2)
    80002776:	00c6f5b3          	and	a1,a3,a2
    8000277a:	cd91                	beqz	a1,80002796 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000277c:	2705                	addiw	a4,a4,1
    8000277e:	2485                	addiw	s1,s1,1
    80002780:	fd471ae3          	bne	a4,s4,80002754 <balloc+0x80>
    80002784:	b769                	j	8000270e <balloc+0x3a>
  panic("balloc: out of blocks");
    80002786:	00006517          	auipc	a0,0x6
    8000278a:	d2a50513          	addi	a0,a0,-726 # 800084b0 <syscalls+0x110>
    8000278e:	00003097          	auipc	ra,0x3
    80002792:	712080e7          	jalr	1810(ra) # 80005ea0 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002796:	97ca                	add	a5,a5,s2
    80002798:	8e55                	or	a2,a2,a3
    8000279a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000279e:	854a                	mv	a0,s2
    800027a0:	00001097          	auipc	ra,0x1
    800027a4:	026080e7          	jalr	38(ra) # 800037c6 <log_write>
        brelse(bp);
    800027a8:	854a                	mv	a0,s2
    800027aa:	00000097          	auipc	ra,0x0
    800027ae:	d98080e7          	jalr	-616(ra) # 80002542 <brelse>
  bp = bread(dev, bno);
    800027b2:	85a6                	mv	a1,s1
    800027b4:	855e                	mv	a0,s7
    800027b6:	00000097          	auipc	ra,0x0
    800027ba:	c5c080e7          	jalr	-932(ra) # 80002412 <bread>
    800027be:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027c0:	40000613          	li	a2,1024
    800027c4:	4581                	li	a1,0
    800027c6:	05850513          	addi	a0,a0,88
    800027ca:	ffffe097          	auipc	ra,0xffffe
    800027ce:	9b0080e7          	jalr	-1616(ra) # 8000017a <memset>
  log_write(bp);
    800027d2:	854a                	mv	a0,s2
    800027d4:	00001097          	auipc	ra,0x1
    800027d8:	ff2080e7          	jalr	-14(ra) # 800037c6 <log_write>
  brelse(bp);
    800027dc:	854a                	mv	a0,s2
    800027de:	00000097          	auipc	ra,0x0
    800027e2:	d64080e7          	jalr	-668(ra) # 80002542 <brelse>
}
    800027e6:	8526                	mv	a0,s1
    800027e8:	60e6                	ld	ra,88(sp)
    800027ea:	6446                	ld	s0,80(sp)
    800027ec:	64a6                	ld	s1,72(sp)
    800027ee:	6906                	ld	s2,64(sp)
    800027f0:	79e2                	ld	s3,56(sp)
    800027f2:	7a42                	ld	s4,48(sp)
    800027f4:	7aa2                	ld	s5,40(sp)
    800027f6:	7b02                	ld	s6,32(sp)
    800027f8:	6be2                	ld	s7,24(sp)
    800027fa:	6c42                	ld	s8,16(sp)
    800027fc:	6ca2                	ld	s9,8(sp)
    800027fe:	6125                	addi	sp,sp,96
    80002800:	8082                	ret

0000000080002802 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002802:	7179                	addi	sp,sp,-48
    80002804:	f406                	sd	ra,40(sp)
    80002806:	f022                	sd	s0,32(sp)
    80002808:	ec26                	sd	s1,24(sp)
    8000280a:	e84a                	sd	s2,16(sp)
    8000280c:	e44e                	sd	s3,8(sp)
    8000280e:	e052                	sd	s4,0(sp)
    80002810:	1800                	addi	s0,sp,48
    80002812:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002814:	47ad                	li	a5,11
    80002816:	04b7fe63          	bgeu	a5,a1,80002872 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000281a:	ff45849b          	addiw	s1,a1,-12
    8000281e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002822:	0ff00793          	li	a5,255
    80002826:	0ae7e463          	bltu	a5,a4,800028ce <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000282a:	08052583          	lw	a1,128(a0)
    8000282e:	c5b5                	beqz	a1,8000289a <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002830:	00092503          	lw	a0,0(s2)
    80002834:	00000097          	auipc	ra,0x0
    80002838:	bde080e7          	jalr	-1058(ra) # 80002412 <bread>
    8000283c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000283e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002842:	02049713          	slli	a4,s1,0x20
    80002846:	01e75593          	srli	a1,a4,0x1e
    8000284a:	00b784b3          	add	s1,a5,a1
    8000284e:	0004a983          	lw	s3,0(s1)
    80002852:	04098e63          	beqz	s3,800028ae <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002856:	8552                	mv	a0,s4
    80002858:	00000097          	auipc	ra,0x0
    8000285c:	cea080e7          	jalr	-790(ra) # 80002542 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002860:	854e                	mv	a0,s3
    80002862:	70a2                	ld	ra,40(sp)
    80002864:	7402                	ld	s0,32(sp)
    80002866:	64e2                	ld	s1,24(sp)
    80002868:	6942                	ld	s2,16(sp)
    8000286a:	69a2                	ld	s3,8(sp)
    8000286c:	6a02                	ld	s4,0(sp)
    8000286e:	6145                	addi	sp,sp,48
    80002870:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002872:	02059793          	slli	a5,a1,0x20
    80002876:	01e7d593          	srli	a1,a5,0x1e
    8000287a:	00b504b3          	add	s1,a0,a1
    8000287e:	0504a983          	lw	s3,80(s1)
    80002882:	fc099fe3          	bnez	s3,80002860 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002886:	4108                	lw	a0,0(a0)
    80002888:	00000097          	auipc	ra,0x0
    8000288c:	e4c080e7          	jalr	-436(ra) # 800026d4 <balloc>
    80002890:	0005099b          	sext.w	s3,a0
    80002894:	0534a823          	sw	s3,80(s1)
    80002898:	b7e1                	j	80002860 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000289a:	4108                	lw	a0,0(a0)
    8000289c:	00000097          	auipc	ra,0x0
    800028a0:	e38080e7          	jalr	-456(ra) # 800026d4 <balloc>
    800028a4:	0005059b          	sext.w	a1,a0
    800028a8:	08b92023          	sw	a1,128(s2)
    800028ac:	b751                	j	80002830 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800028ae:	00092503          	lw	a0,0(s2)
    800028b2:	00000097          	auipc	ra,0x0
    800028b6:	e22080e7          	jalr	-478(ra) # 800026d4 <balloc>
    800028ba:	0005099b          	sext.w	s3,a0
    800028be:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800028c2:	8552                	mv	a0,s4
    800028c4:	00001097          	auipc	ra,0x1
    800028c8:	f02080e7          	jalr	-254(ra) # 800037c6 <log_write>
    800028cc:	b769                	j	80002856 <bmap+0x54>
  panic("bmap: out of range");
    800028ce:	00006517          	auipc	a0,0x6
    800028d2:	bfa50513          	addi	a0,a0,-1030 # 800084c8 <syscalls+0x128>
    800028d6:	00003097          	auipc	ra,0x3
    800028da:	5ca080e7          	jalr	1482(ra) # 80005ea0 <panic>

00000000800028de <iget>:
{
    800028de:	7179                	addi	sp,sp,-48
    800028e0:	f406                	sd	ra,40(sp)
    800028e2:	f022                	sd	s0,32(sp)
    800028e4:	ec26                	sd	s1,24(sp)
    800028e6:	e84a                	sd	s2,16(sp)
    800028e8:	e44e                	sd	s3,8(sp)
    800028ea:	e052                	sd	s4,0(sp)
    800028ec:	1800                	addi	s0,sp,48
    800028ee:	89aa                	mv	s3,a0
    800028f0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028f2:	00023517          	auipc	a0,0x23
    800028f6:	c8650513          	addi	a0,a0,-890 # 80025578 <itable>
    800028fa:	00004097          	auipc	ra,0x4
    800028fe:	ade080e7          	jalr	-1314(ra) # 800063d8 <acquire>
  empty = 0;
    80002902:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002904:	00023497          	auipc	s1,0x23
    80002908:	c8c48493          	addi	s1,s1,-884 # 80025590 <itable+0x18>
    8000290c:	00024697          	auipc	a3,0x24
    80002910:	71468693          	addi	a3,a3,1812 # 80027020 <log>
    80002914:	a039                	j	80002922 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002916:	02090b63          	beqz	s2,8000294c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000291a:	08848493          	addi	s1,s1,136
    8000291e:	02d48a63          	beq	s1,a3,80002952 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002922:	449c                	lw	a5,8(s1)
    80002924:	fef059e3          	blez	a5,80002916 <iget+0x38>
    80002928:	4098                	lw	a4,0(s1)
    8000292a:	ff3716e3          	bne	a4,s3,80002916 <iget+0x38>
    8000292e:	40d8                	lw	a4,4(s1)
    80002930:	ff4713e3          	bne	a4,s4,80002916 <iget+0x38>
      ip->ref++;
    80002934:	2785                	addiw	a5,a5,1
    80002936:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002938:	00023517          	auipc	a0,0x23
    8000293c:	c4050513          	addi	a0,a0,-960 # 80025578 <itable>
    80002940:	00004097          	auipc	ra,0x4
    80002944:	b4c080e7          	jalr	-1204(ra) # 8000648c <release>
      return ip;
    80002948:	8926                	mv	s2,s1
    8000294a:	a03d                	j	80002978 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000294c:	f7f9                	bnez	a5,8000291a <iget+0x3c>
    8000294e:	8926                	mv	s2,s1
    80002950:	b7e9                	j	8000291a <iget+0x3c>
  if(empty == 0)
    80002952:	02090c63          	beqz	s2,8000298a <iget+0xac>
  ip->dev = dev;
    80002956:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000295a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000295e:	4785                	li	a5,1
    80002960:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002964:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002968:	00023517          	auipc	a0,0x23
    8000296c:	c1050513          	addi	a0,a0,-1008 # 80025578 <itable>
    80002970:	00004097          	auipc	ra,0x4
    80002974:	b1c080e7          	jalr	-1252(ra) # 8000648c <release>
}
    80002978:	854a                	mv	a0,s2
    8000297a:	70a2                	ld	ra,40(sp)
    8000297c:	7402                	ld	s0,32(sp)
    8000297e:	64e2                	ld	s1,24(sp)
    80002980:	6942                	ld	s2,16(sp)
    80002982:	69a2                	ld	s3,8(sp)
    80002984:	6a02                	ld	s4,0(sp)
    80002986:	6145                	addi	sp,sp,48
    80002988:	8082                	ret
    panic("iget: no inodes");
    8000298a:	00006517          	auipc	a0,0x6
    8000298e:	b5650513          	addi	a0,a0,-1194 # 800084e0 <syscalls+0x140>
    80002992:	00003097          	auipc	ra,0x3
    80002996:	50e080e7          	jalr	1294(ra) # 80005ea0 <panic>

000000008000299a <fsinit>:
fsinit(int dev) {
    8000299a:	7179                	addi	sp,sp,-48
    8000299c:	f406                	sd	ra,40(sp)
    8000299e:	f022                	sd	s0,32(sp)
    800029a0:	ec26                	sd	s1,24(sp)
    800029a2:	e84a                	sd	s2,16(sp)
    800029a4:	e44e                	sd	s3,8(sp)
    800029a6:	1800                	addi	s0,sp,48
    800029a8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029aa:	4585                	li	a1,1
    800029ac:	00000097          	auipc	ra,0x0
    800029b0:	a66080e7          	jalr	-1434(ra) # 80002412 <bread>
    800029b4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029b6:	00023997          	auipc	s3,0x23
    800029ba:	ba298993          	addi	s3,s3,-1118 # 80025558 <sb>
    800029be:	02000613          	li	a2,32
    800029c2:	05850593          	addi	a1,a0,88
    800029c6:	854e                	mv	a0,s3
    800029c8:	ffffe097          	auipc	ra,0xffffe
    800029cc:	80e080e7          	jalr	-2034(ra) # 800001d6 <memmove>
  brelse(bp);
    800029d0:	8526                	mv	a0,s1
    800029d2:	00000097          	auipc	ra,0x0
    800029d6:	b70080e7          	jalr	-1168(ra) # 80002542 <brelse>
  if(sb.magic != FSMAGIC)
    800029da:	0009a703          	lw	a4,0(s3)
    800029de:	102037b7          	lui	a5,0x10203
    800029e2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029e6:	02f71263          	bne	a4,a5,80002a0a <fsinit+0x70>
  initlog(dev, &sb);
    800029ea:	00023597          	auipc	a1,0x23
    800029ee:	b6e58593          	addi	a1,a1,-1170 # 80025558 <sb>
    800029f2:	854a                	mv	a0,s2
    800029f4:	00001097          	auipc	ra,0x1
    800029f8:	b56080e7          	jalr	-1194(ra) # 8000354a <initlog>
}
    800029fc:	70a2                	ld	ra,40(sp)
    800029fe:	7402                	ld	s0,32(sp)
    80002a00:	64e2                	ld	s1,24(sp)
    80002a02:	6942                	ld	s2,16(sp)
    80002a04:	69a2                	ld	s3,8(sp)
    80002a06:	6145                	addi	sp,sp,48
    80002a08:	8082                	ret
    panic("invalid file system");
    80002a0a:	00006517          	auipc	a0,0x6
    80002a0e:	ae650513          	addi	a0,a0,-1306 # 800084f0 <syscalls+0x150>
    80002a12:	00003097          	auipc	ra,0x3
    80002a16:	48e080e7          	jalr	1166(ra) # 80005ea0 <panic>

0000000080002a1a <iinit>:
{
    80002a1a:	7179                	addi	sp,sp,-48
    80002a1c:	f406                	sd	ra,40(sp)
    80002a1e:	f022                	sd	s0,32(sp)
    80002a20:	ec26                	sd	s1,24(sp)
    80002a22:	e84a                	sd	s2,16(sp)
    80002a24:	e44e                	sd	s3,8(sp)
    80002a26:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a28:	00006597          	auipc	a1,0x6
    80002a2c:	ae058593          	addi	a1,a1,-1312 # 80008508 <syscalls+0x168>
    80002a30:	00023517          	auipc	a0,0x23
    80002a34:	b4850513          	addi	a0,a0,-1208 # 80025578 <itable>
    80002a38:	00004097          	auipc	ra,0x4
    80002a3c:	910080e7          	jalr	-1776(ra) # 80006348 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a40:	00023497          	auipc	s1,0x23
    80002a44:	b6048493          	addi	s1,s1,-1184 # 800255a0 <itable+0x28>
    80002a48:	00024997          	auipc	s3,0x24
    80002a4c:	5e898993          	addi	s3,s3,1512 # 80027030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a50:	00006917          	auipc	s2,0x6
    80002a54:	ac090913          	addi	s2,s2,-1344 # 80008510 <syscalls+0x170>
    80002a58:	85ca                	mv	a1,s2
    80002a5a:	8526                	mv	a0,s1
    80002a5c:	00001097          	auipc	ra,0x1
    80002a60:	e4e080e7          	jalr	-434(ra) # 800038aa <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a64:	08848493          	addi	s1,s1,136
    80002a68:	ff3498e3          	bne	s1,s3,80002a58 <iinit+0x3e>
}
    80002a6c:	70a2                	ld	ra,40(sp)
    80002a6e:	7402                	ld	s0,32(sp)
    80002a70:	64e2                	ld	s1,24(sp)
    80002a72:	6942                	ld	s2,16(sp)
    80002a74:	69a2                	ld	s3,8(sp)
    80002a76:	6145                	addi	sp,sp,48
    80002a78:	8082                	ret

0000000080002a7a <ialloc>:
{
    80002a7a:	715d                	addi	sp,sp,-80
    80002a7c:	e486                	sd	ra,72(sp)
    80002a7e:	e0a2                	sd	s0,64(sp)
    80002a80:	fc26                	sd	s1,56(sp)
    80002a82:	f84a                	sd	s2,48(sp)
    80002a84:	f44e                	sd	s3,40(sp)
    80002a86:	f052                	sd	s4,32(sp)
    80002a88:	ec56                	sd	s5,24(sp)
    80002a8a:	e85a                	sd	s6,16(sp)
    80002a8c:	e45e                	sd	s7,8(sp)
    80002a8e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a90:	00023717          	auipc	a4,0x23
    80002a94:	ad472703          	lw	a4,-1324(a4) # 80025564 <sb+0xc>
    80002a98:	4785                	li	a5,1
    80002a9a:	04e7fa63          	bgeu	a5,a4,80002aee <ialloc+0x74>
    80002a9e:	8aaa                	mv	s5,a0
    80002aa0:	8bae                	mv	s7,a1
    80002aa2:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002aa4:	00023a17          	auipc	s4,0x23
    80002aa8:	ab4a0a13          	addi	s4,s4,-1356 # 80025558 <sb>
    80002aac:	00048b1b          	sext.w	s6,s1
    80002ab0:	0044d593          	srli	a1,s1,0x4
    80002ab4:	018a2783          	lw	a5,24(s4)
    80002ab8:	9dbd                	addw	a1,a1,a5
    80002aba:	8556                	mv	a0,s5
    80002abc:	00000097          	auipc	ra,0x0
    80002ac0:	956080e7          	jalr	-1706(ra) # 80002412 <bread>
    80002ac4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ac6:	05850993          	addi	s3,a0,88
    80002aca:	00f4f793          	andi	a5,s1,15
    80002ace:	079a                	slli	a5,a5,0x6
    80002ad0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ad2:	00099783          	lh	a5,0(s3)
    80002ad6:	c785                	beqz	a5,80002afe <ialloc+0x84>
    brelse(bp);
    80002ad8:	00000097          	auipc	ra,0x0
    80002adc:	a6a080e7          	jalr	-1430(ra) # 80002542 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ae0:	0485                	addi	s1,s1,1
    80002ae2:	00ca2703          	lw	a4,12(s4)
    80002ae6:	0004879b          	sext.w	a5,s1
    80002aea:	fce7e1e3          	bltu	a5,a4,80002aac <ialloc+0x32>
  panic("ialloc: no inodes");
    80002aee:	00006517          	auipc	a0,0x6
    80002af2:	a2a50513          	addi	a0,a0,-1494 # 80008518 <syscalls+0x178>
    80002af6:	00003097          	auipc	ra,0x3
    80002afa:	3aa080e7          	jalr	938(ra) # 80005ea0 <panic>
      memset(dip, 0, sizeof(*dip));
    80002afe:	04000613          	li	a2,64
    80002b02:	4581                	li	a1,0
    80002b04:	854e                	mv	a0,s3
    80002b06:	ffffd097          	auipc	ra,0xffffd
    80002b0a:	674080e7          	jalr	1652(ra) # 8000017a <memset>
      dip->type = type;
    80002b0e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b12:	854a                	mv	a0,s2
    80002b14:	00001097          	auipc	ra,0x1
    80002b18:	cb2080e7          	jalr	-846(ra) # 800037c6 <log_write>
      brelse(bp);
    80002b1c:	854a                	mv	a0,s2
    80002b1e:	00000097          	auipc	ra,0x0
    80002b22:	a24080e7          	jalr	-1500(ra) # 80002542 <brelse>
      return iget(dev, inum);
    80002b26:	85da                	mv	a1,s6
    80002b28:	8556                	mv	a0,s5
    80002b2a:	00000097          	auipc	ra,0x0
    80002b2e:	db4080e7          	jalr	-588(ra) # 800028de <iget>
}
    80002b32:	60a6                	ld	ra,72(sp)
    80002b34:	6406                	ld	s0,64(sp)
    80002b36:	74e2                	ld	s1,56(sp)
    80002b38:	7942                	ld	s2,48(sp)
    80002b3a:	79a2                	ld	s3,40(sp)
    80002b3c:	7a02                	ld	s4,32(sp)
    80002b3e:	6ae2                	ld	s5,24(sp)
    80002b40:	6b42                	ld	s6,16(sp)
    80002b42:	6ba2                	ld	s7,8(sp)
    80002b44:	6161                	addi	sp,sp,80
    80002b46:	8082                	ret

0000000080002b48 <iupdate>:
{
    80002b48:	1101                	addi	sp,sp,-32
    80002b4a:	ec06                	sd	ra,24(sp)
    80002b4c:	e822                	sd	s0,16(sp)
    80002b4e:	e426                	sd	s1,8(sp)
    80002b50:	e04a                	sd	s2,0(sp)
    80002b52:	1000                	addi	s0,sp,32
    80002b54:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b56:	415c                	lw	a5,4(a0)
    80002b58:	0047d79b          	srliw	a5,a5,0x4
    80002b5c:	00023597          	auipc	a1,0x23
    80002b60:	a145a583          	lw	a1,-1516(a1) # 80025570 <sb+0x18>
    80002b64:	9dbd                	addw	a1,a1,a5
    80002b66:	4108                	lw	a0,0(a0)
    80002b68:	00000097          	auipc	ra,0x0
    80002b6c:	8aa080e7          	jalr	-1878(ra) # 80002412 <bread>
    80002b70:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b72:	05850793          	addi	a5,a0,88
    80002b76:	40d8                	lw	a4,4(s1)
    80002b78:	8b3d                	andi	a4,a4,15
    80002b7a:	071a                	slli	a4,a4,0x6
    80002b7c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b7e:	04449703          	lh	a4,68(s1)
    80002b82:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b86:	04649703          	lh	a4,70(s1)
    80002b8a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b8e:	04849703          	lh	a4,72(s1)
    80002b92:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b96:	04a49703          	lh	a4,74(s1)
    80002b9a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b9e:	44f8                	lw	a4,76(s1)
    80002ba0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ba2:	03400613          	li	a2,52
    80002ba6:	05048593          	addi	a1,s1,80
    80002baa:	00c78513          	addi	a0,a5,12
    80002bae:	ffffd097          	auipc	ra,0xffffd
    80002bb2:	628080e7          	jalr	1576(ra) # 800001d6 <memmove>
  log_write(bp);
    80002bb6:	854a                	mv	a0,s2
    80002bb8:	00001097          	auipc	ra,0x1
    80002bbc:	c0e080e7          	jalr	-1010(ra) # 800037c6 <log_write>
  brelse(bp);
    80002bc0:	854a                	mv	a0,s2
    80002bc2:	00000097          	auipc	ra,0x0
    80002bc6:	980080e7          	jalr	-1664(ra) # 80002542 <brelse>
}
    80002bca:	60e2                	ld	ra,24(sp)
    80002bcc:	6442                	ld	s0,16(sp)
    80002bce:	64a2                	ld	s1,8(sp)
    80002bd0:	6902                	ld	s2,0(sp)
    80002bd2:	6105                	addi	sp,sp,32
    80002bd4:	8082                	ret

0000000080002bd6 <idup>:
{
    80002bd6:	1101                	addi	sp,sp,-32
    80002bd8:	ec06                	sd	ra,24(sp)
    80002bda:	e822                	sd	s0,16(sp)
    80002bdc:	e426                	sd	s1,8(sp)
    80002bde:	1000                	addi	s0,sp,32
    80002be0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002be2:	00023517          	auipc	a0,0x23
    80002be6:	99650513          	addi	a0,a0,-1642 # 80025578 <itable>
    80002bea:	00003097          	auipc	ra,0x3
    80002bee:	7ee080e7          	jalr	2030(ra) # 800063d8 <acquire>
  ip->ref++;
    80002bf2:	449c                	lw	a5,8(s1)
    80002bf4:	2785                	addiw	a5,a5,1
    80002bf6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bf8:	00023517          	auipc	a0,0x23
    80002bfc:	98050513          	addi	a0,a0,-1664 # 80025578 <itable>
    80002c00:	00004097          	auipc	ra,0x4
    80002c04:	88c080e7          	jalr	-1908(ra) # 8000648c <release>
}
    80002c08:	8526                	mv	a0,s1
    80002c0a:	60e2                	ld	ra,24(sp)
    80002c0c:	6442                	ld	s0,16(sp)
    80002c0e:	64a2                	ld	s1,8(sp)
    80002c10:	6105                	addi	sp,sp,32
    80002c12:	8082                	ret

0000000080002c14 <ilock>:
{
    80002c14:	1101                	addi	sp,sp,-32
    80002c16:	ec06                	sd	ra,24(sp)
    80002c18:	e822                	sd	s0,16(sp)
    80002c1a:	e426                	sd	s1,8(sp)
    80002c1c:	e04a                	sd	s2,0(sp)
    80002c1e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c20:	c115                	beqz	a0,80002c44 <ilock+0x30>
    80002c22:	84aa                	mv	s1,a0
    80002c24:	451c                	lw	a5,8(a0)
    80002c26:	00f05f63          	blez	a5,80002c44 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c2a:	0541                	addi	a0,a0,16
    80002c2c:	00001097          	auipc	ra,0x1
    80002c30:	cb8080e7          	jalr	-840(ra) # 800038e4 <acquiresleep>
  if(ip->valid == 0){
    80002c34:	40bc                	lw	a5,64(s1)
    80002c36:	cf99                	beqz	a5,80002c54 <ilock+0x40>
}
    80002c38:	60e2                	ld	ra,24(sp)
    80002c3a:	6442                	ld	s0,16(sp)
    80002c3c:	64a2                	ld	s1,8(sp)
    80002c3e:	6902                	ld	s2,0(sp)
    80002c40:	6105                	addi	sp,sp,32
    80002c42:	8082                	ret
    panic("ilock");
    80002c44:	00006517          	auipc	a0,0x6
    80002c48:	8ec50513          	addi	a0,a0,-1812 # 80008530 <syscalls+0x190>
    80002c4c:	00003097          	auipc	ra,0x3
    80002c50:	254080e7          	jalr	596(ra) # 80005ea0 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c54:	40dc                	lw	a5,4(s1)
    80002c56:	0047d79b          	srliw	a5,a5,0x4
    80002c5a:	00023597          	auipc	a1,0x23
    80002c5e:	9165a583          	lw	a1,-1770(a1) # 80025570 <sb+0x18>
    80002c62:	9dbd                	addw	a1,a1,a5
    80002c64:	4088                	lw	a0,0(s1)
    80002c66:	fffff097          	auipc	ra,0xfffff
    80002c6a:	7ac080e7          	jalr	1964(ra) # 80002412 <bread>
    80002c6e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c70:	05850593          	addi	a1,a0,88
    80002c74:	40dc                	lw	a5,4(s1)
    80002c76:	8bbd                	andi	a5,a5,15
    80002c78:	079a                	slli	a5,a5,0x6
    80002c7a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c7c:	00059783          	lh	a5,0(a1)
    80002c80:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c84:	00259783          	lh	a5,2(a1)
    80002c88:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c8c:	00459783          	lh	a5,4(a1)
    80002c90:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c94:	00659783          	lh	a5,6(a1)
    80002c98:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c9c:	459c                	lw	a5,8(a1)
    80002c9e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002ca0:	03400613          	li	a2,52
    80002ca4:	05b1                	addi	a1,a1,12
    80002ca6:	05048513          	addi	a0,s1,80
    80002caa:	ffffd097          	auipc	ra,0xffffd
    80002cae:	52c080e7          	jalr	1324(ra) # 800001d6 <memmove>
    brelse(bp);
    80002cb2:	854a                	mv	a0,s2
    80002cb4:	00000097          	auipc	ra,0x0
    80002cb8:	88e080e7          	jalr	-1906(ra) # 80002542 <brelse>
    ip->valid = 1;
    80002cbc:	4785                	li	a5,1
    80002cbe:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cc0:	04449783          	lh	a5,68(s1)
    80002cc4:	fbb5                	bnez	a5,80002c38 <ilock+0x24>
      panic("ilock: no type");
    80002cc6:	00006517          	auipc	a0,0x6
    80002cca:	87250513          	addi	a0,a0,-1934 # 80008538 <syscalls+0x198>
    80002cce:	00003097          	auipc	ra,0x3
    80002cd2:	1d2080e7          	jalr	466(ra) # 80005ea0 <panic>

0000000080002cd6 <iunlock>:
{
    80002cd6:	1101                	addi	sp,sp,-32
    80002cd8:	ec06                	sd	ra,24(sp)
    80002cda:	e822                	sd	s0,16(sp)
    80002cdc:	e426                	sd	s1,8(sp)
    80002cde:	e04a                	sd	s2,0(sp)
    80002ce0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ce2:	c905                	beqz	a0,80002d12 <iunlock+0x3c>
    80002ce4:	84aa                	mv	s1,a0
    80002ce6:	01050913          	addi	s2,a0,16
    80002cea:	854a                	mv	a0,s2
    80002cec:	00001097          	auipc	ra,0x1
    80002cf0:	c92080e7          	jalr	-878(ra) # 8000397e <holdingsleep>
    80002cf4:	cd19                	beqz	a0,80002d12 <iunlock+0x3c>
    80002cf6:	449c                	lw	a5,8(s1)
    80002cf8:	00f05d63          	blez	a5,80002d12 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cfc:	854a                	mv	a0,s2
    80002cfe:	00001097          	auipc	ra,0x1
    80002d02:	c3c080e7          	jalr	-964(ra) # 8000393a <releasesleep>
}
    80002d06:	60e2                	ld	ra,24(sp)
    80002d08:	6442                	ld	s0,16(sp)
    80002d0a:	64a2                	ld	s1,8(sp)
    80002d0c:	6902                	ld	s2,0(sp)
    80002d0e:	6105                	addi	sp,sp,32
    80002d10:	8082                	ret
    panic("iunlock");
    80002d12:	00006517          	auipc	a0,0x6
    80002d16:	83650513          	addi	a0,a0,-1994 # 80008548 <syscalls+0x1a8>
    80002d1a:	00003097          	auipc	ra,0x3
    80002d1e:	186080e7          	jalr	390(ra) # 80005ea0 <panic>

0000000080002d22 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d22:	7179                	addi	sp,sp,-48
    80002d24:	f406                	sd	ra,40(sp)
    80002d26:	f022                	sd	s0,32(sp)
    80002d28:	ec26                	sd	s1,24(sp)
    80002d2a:	e84a                	sd	s2,16(sp)
    80002d2c:	e44e                	sd	s3,8(sp)
    80002d2e:	e052                	sd	s4,0(sp)
    80002d30:	1800                	addi	s0,sp,48
    80002d32:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d34:	05050493          	addi	s1,a0,80
    80002d38:	08050913          	addi	s2,a0,128
    80002d3c:	a021                	j	80002d44 <itrunc+0x22>
    80002d3e:	0491                	addi	s1,s1,4
    80002d40:	01248d63          	beq	s1,s2,80002d5a <itrunc+0x38>
    if(ip->addrs[i]){
    80002d44:	408c                	lw	a1,0(s1)
    80002d46:	dde5                	beqz	a1,80002d3e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d48:	0009a503          	lw	a0,0(s3)
    80002d4c:	00000097          	auipc	ra,0x0
    80002d50:	90c080e7          	jalr	-1780(ra) # 80002658 <bfree>
      ip->addrs[i] = 0;
    80002d54:	0004a023          	sw	zero,0(s1)
    80002d58:	b7dd                	j	80002d3e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d5a:	0809a583          	lw	a1,128(s3)
    80002d5e:	e185                	bnez	a1,80002d7e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d60:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d64:	854e                	mv	a0,s3
    80002d66:	00000097          	auipc	ra,0x0
    80002d6a:	de2080e7          	jalr	-542(ra) # 80002b48 <iupdate>
}
    80002d6e:	70a2                	ld	ra,40(sp)
    80002d70:	7402                	ld	s0,32(sp)
    80002d72:	64e2                	ld	s1,24(sp)
    80002d74:	6942                	ld	s2,16(sp)
    80002d76:	69a2                	ld	s3,8(sp)
    80002d78:	6a02                	ld	s4,0(sp)
    80002d7a:	6145                	addi	sp,sp,48
    80002d7c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d7e:	0009a503          	lw	a0,0(s3)
    80002d82:	fffff097          	auipc	ra,0xfffff
    80002d86:	690080e7          	jalr	1680(ra) # 80002412 <bread>
    80002d8a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d8c:	05850493          	addi	s1,a0,88
    80002d90:	45850913          	addi	s2,a0,1112
    80002d94:	a021                	j	80002d9c <itrunc+0x7a>
    80002d96:	0491                	addi	s1,s1,4
    80002d98:	01248b63          	beq	s1,s2,80002dae <itrunc+0x8c>
      if(a[j])
    80002d9c:	408c                	lw	a1,0(s1)
    80002d9e:	dde5                	beqz	a1,80002d96 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002da0:	0009a503          	lw	a0,0(s3)
    80002da4:	00000097          	auipc	ra,0x0
    80002da8:	8b4080e7          	jalr	-1868(ra) # 80002658 <bfree>
    80002dac:	b7ed                	j	80002d96 <itrunc+0x74>
    brelse(bp);
    80002dae:	8552                	mv	a0,s4
    80002db0:	fffff097          	auipc	ra,0xfffff
    80002db4:	792080e7          	jalr	1938(ra) # 80002542 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002db8:	0809a583          	lw	a1,128(s3)
    80002dbc:	0009a503          	lw	a0,0(s3)
    80002dc0:	00000097          	auipc	ra,0x0
    80002dc4:	898080e7          	jalr	-1896(ra) # 80002658 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dc8:	0809a023          	sw	zero,128(s3)
    80002dcc:	bf51                	j	80002d60 <itrunc+0x3e>

0000000080002dce <iput>:
{
    80002dce:	1101                	addi	sp,sp,-32
    80002dd0:	ec06                	sd	ra,24(sp)
    80002dd2:	e822                	sd	s0,16(sp)
    80002dd4:	e426                	sd	s1,8(sp)
    80002dd6:	e04a                	sd	s2,0(sp)
    80002dd8:	1000                	addi	s0,sp,32
    80002dda:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ddc:	00022517          	auipc	a0,0x22
    80002de0:	79c50513          	addi	a0,a0,1948 # 80025578 <itable>
    80002de4:	00003097          	auipc	ra,0x3
    80002de8:	5f4080e7          	jalr	1524(ra) # 800063d8 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dec:	4498                	lw	a4,8(s1)
    80002dee:	4785                	li	a5,1
    80002df0:	02f70363          	beq	a4,a5,80002e16 <iput+0x48>
  ip->ref--;
    80002df4:	449c                	lw	a5,8(s1)
    80002df6:	37fd                	addiw	a5,a5,-1
    80002df8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dfa:	00022517          	auipc	a0,0x22
    80002dfe:	77e50513          	addi	a0,a0,1918 # 80025578 <itable>
    80002e02:	00003097          	auipc	ra,0x3
    80002e06:	68a080e7          	jalr	1674(ra) # 8000648c <release>
}
    80002e0a:	60e2                	ld	ra,24(sp)
    80002e0c:	6442                	ld	s0,16(sp)
    80002e0e:	64a2                	ld	s1,8(sp)
    80002e10:	6902                	ld	s2,0(sp)
    80002e12:	6105                	addi	sp,sp,32
    80002e14:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e16:	40bc                	lw	a5,64(s1)
    80002e18:	dff1                	beqz	a5,80002df4 <iput+0x26>
    80002e1a:	04a49783          	lh	a5,74(s1)
    80002e1e:	fbf9                	bnez	a5,80002df4 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e20:	01048913          	addi	s2,s1,16
    80002e24:	854a                	mv	a0,s2
    80002e26:	00001097          	auipc	ra,0x1
    80002e2a:	abe080e7          	jalr	-1346(ra) # 800038e4 <acquiresleep>
    release(&itable.lock);
    80002e2e:	00022517          	auipc	a0,0x22
    80002e32:	74a50513          	addi	a0,a0,1866 # 80025578 <itable>
    80002e36:	00003097          	auipc	ra,0x3
    80002e3a:	656080e7          	jalr	1622(ra) # 8000648c <release>
    itrunc(ip);
    80002e3e:	8526                	mv	a0,s1
    80002e40:	00000097          	auipc	ra,0x0
    80002e44:	ee2080e7          	jalr	-286(ra) # 80002d22 <itrunc>
    ip->type = 0;
    80002e48:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e4c:	8526                	mv	a0,s1
    80002e4e:	00000097          	auipc	ra,0x0
    80002e52:	cfa080e7          	jalr	-774(ra) # 80002b48 <iupdate>
    ip->valid = 0;
    80002e56:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e5a:	854a                	mv	a0,s2
    80002e5c:	00001097          	auipc	ra,0x1
    80002e60:	ade080e7          	jalr	-1314(ra) # 8000393a <releasesleep>
    acquire(&itable.lock);
    80002e64:	00022517          	auipc	a0,0x22
    80002e68:	71450513          	addi	a0,a0,1812 # 80025578 <itable>
    80002e6c:	00003097          	auipc	ra,0x3
    80002e70:	56c080e7          	jalr	1388(ra) # 800063d8 <acquire>
    80002e74:	b741                	j	80002df4 <iput+0x26>

0000000080002e76 <iunlockput>:
{
    80002e76:	1101                	addi	sp,sp,-32
    80002e78:	ec06                	sd	ra,24(sp)
    80002e7a:	e822                	sd	s0,16(sp)
    80002e7c:	e426                	sd	s1,8(sp)
    80002e7e:	1000                	addi	s0,sp,32
    80002e80:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e82:	00000097          	auipc	ra,0x0
    80002e86:	e54080e7          	jalr	-428(ra) # 80002cd6 <iunlock>
  iput(ip);
    80002e8a:	8526                	mv	a0,s1
    80002e8c:	00000097          	auipc	ra,0x0
    80002e90:	f42080e7          	jalr	-190(ra) # 80002dce <iput>
}
    80002e94:	60e2                	ld	ra,24(sp)
    80002e96:	6442                	ld	s0,16(sp)
    80002e98:	64a2                	ld	s1,8(sp)
    80002e9a:	6105                	addi	sp,sp,32
    80002e9c:	8082                	ret

0000000080002e9e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e9e:	1141                	addi	sp,sp,-16
    80002ea0:	e422                	sd	s0,8(sp)
    80002ea2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ea4:	411c                	lw	a5,0(a0)
    80002ea6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ea8:	415c                	lw	a5,4(a0)
    80002eaa:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002eac:	04451783          	lh	a5,68(a0)
    80002eb0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002eb4:	04a51783          	lh	a5,74(a0)
    80002eb8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ebc:	04c56783          	lwu	a5,76(a0)
    80002ec0:	e99c                	sd	a5,16(a1)
}
    80002ec2:	6422                	ld	s0,8(sp)
    80002ec4:	0141                	addi	sp,sp,16
    80002ec6:	8082                	ret

0000000080002ec8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ec8:	457c                	lw	a5,76(a0)
    80002eca:	0ed7e963          	bltu	a5,a3,80002fbc <readi+0xf4>
{
    80002ece:	7159                	addi	sp,sp,-112
    80002ed0:	f486                	sd	ra,104(sp)
    80002ed2:	f0a2                	sd	s0,96(sp)
    80002ed4:	eca6                	sd	s1,88(sp)
    80002ed6:	e8ca                	sd	s2,80(sp)
    80002ed8:	e4ce                	sd	s3,72(sp)
    80002eda:	e0d2                	sd	s4,64(sp)
    80002edc:	fc56                	sd	s5,56(sp)
    80002ede:	f85a                	sd	s6,48(sp)
    80002ee0:	f45e                	sd	s7,40(sp)
    80002ee2:	f062                	sd	s8,32(sp)
    80002ee4:	ec66                	sd	s9,24(sp)
    80002ee6:	e86a                	sd	s10,16(sp)
    80002ee8:	e46e                	sd	s11,8(sp)
    80002eea:	1880                	addi	s0,sp,112
    80002eec:	8baa                	mv	s7,a0
    80002eee:	8c2e                	mv	s8,a1
    80002ef0:	8ab2                	mv	s5,a2
    80002ef2:	84b6                	mv	s1,a3
    80002ef4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ef6:	9f35                	addw	a4,a4,a3
    return 0;
    80002ef8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002efa:	0ad76063          	bltu	a4,a3,80002f9a <readi+0xd2>
  if(off + n > ip->size)
    80002efe:	00e7f463          	bgeu	a5,a4,80002f06 <readi+0x3e>
    n = ip->size - off;
    80002f02:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f06:	0a0b0963          	beqz	s6,80002fb8 <readi+0xf0>
    80002f0a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f0c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f10:	5cfd                	li	s9,-1
    80002f12:	a82d                	j	80002f4c <readi+0x84>
    80002f14:	020a1d93          	slli	s11,s4,0x20
    80002f18:	020ddd93          	srli	s11,s11,0x20
    80002f1c:	05890613          	addi	a2,s2,88
    80002f20:	86ee                	mv	a3,s11
    80002f22:	963a                	add	a2,a2,a4
    80002f24:	85d6                	mv	a1,s5
    80002f26:	8562                	mv	a0,s8
    80002f28:	fffff097          	auipc	ra,0xfffff
    80002f2c:	96a080e7          	jalr	-1686(ra) # 80001892 <either_copyout>
    80002f30:	05950d63          	beq	a0,s9,80002f8a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f34:	854a                	mv	a0,s2
    80002f36:	fffff097          	auipc	ra,0xfffff
    80002f3a:	60c080e7          	jalr	1548(ra) # 80002542 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f3e:	013a09bb          	addw	s3,s4,s3
    80002f42:	009a04bb          	addw	s1,s4,s1
    80002f46:	9aee                	add	s5,s5,s11
    80002f48:	0569f763          	bgeu	s3,s6,80002f96 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f4c:	000ba903          	lw	s2,0(s7)
    80002f50:	00a4d59b          	srliw	a1,s1,0xa
    80002f54:	855e                	mv	a0,s7
    80002f56:	00000097          	auipc	ra,0x0
    80002f5a:	8ac080e7          	jalr	-1876(ra) # 80002802 <bmap>
    80002f5e:	0005059b          	sext.w	a1,a0
    80002f62:	854a                	mv	a0,s2
    80002f64:	fffff097          	auipc	ra,0xfffff
    80002f68:	4ae080e7          	jalr	1198(ra) # 80002412 <bread>
    80002f6c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f6e:	3ff4f713          	andi	a4,s1,1023
    80002f72:	40ed07bb          	subw	a5,s10,a4
    80002f76:	413b06bb          	subw	a3,s6,s3
    80002f7a:	8a3e                	mv	s4,a5
    80002f7c:	2781                	sext.w	a5,a5
    80002f7e:	0006861b          	sext.w	a2,a3
    80002f82:	f8f679e3          	bgeu	a2,a5,80002f14 <readi+0x4c>
    80002f86:	8a36                	mv	s4,a3
    80002f88:	b771                	j	80002f14 <readi+0x4c>
      brelse(bp);
    80002f8a:	854a                	mv	a0,s2
    80002f8c:	fffff097          	auipc	ra,0xfffff
    80002f90:	5b6080e7          	jalr	1462(ra) # 80002542 <brelse>
      tot = -1;
    80002f94:	59fd                	li	s3,-1
  }
  return tot;
    80002f96:	0009851b          	sext.w	a0,s3
}
    80002f9a:	70a6                	ld	ra,104(sp)
    80002f9c:	7406                	ld	s0,96(sp)
    80002f9e:	64e6                	ld	s1,88(sp)
    80002fa0:	6946                	ld	s2,80(sp)
    80002fa2:	69a6                	ld	s3,72(sp)
    80002fa4:	6a06                	ld	s4,64(sp)
    80002fa6:	7ae2                	ld	s5,56(sp)
    80002fa8:	7b42                	ld	s6,48(sp)
    80002faa:	7ba2                	ld	s7,40(sp)
    80002fac:	7c02                	ld	s8,32(sp)
    80002fae:	6ce2                	ld	s9,24(sp)
    80002fb0:	6d42                	ld	s10,16(sp)
    80002fb2:	6da2                	ld	s11,8(sp)
    80002fb4:	6165                	addi	sp,sp,112
    80002fb6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fb8:	89da                	mv	s3,s6
    80002fba:	bff1                	j	80002f96 <readi+0xce>
    return 0;
    80002fbc:	4501                	li	a0,0
}
    80002fbe:	8082                	ret

0000000080002fc0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fc0:	457c                	lw	a5,76(a0)
    80002fc2:	10d7e863          	bltu	a5,a3,800030d2 <writei+0x112>
{
    80002fc6:	7159                	addi	sp,sp,-112
    80002fc8:	f486                	sd	ra,104(sp)
    80002fca:	f0a2                	sd	s0,96(sp)
    80002fcc:	eca6                	sd	s1,88(sp)
    80002fce:	e8ca                	sd	s2,80(sp)
    80002fd0:	e4ce                	sd	s3,72(sp)
    80002fd2:	e0d2                	sd	s4,64(sp)
    80002fd4:	fc56                	sd	s5,56(sp)
    80002fd6:	f85a                	sd	s6,48(sp)
    80002fd8:	f45e                	sd	s7,40(sp)
    80002fda:	f062                	sd	s8,32(sp)
    80002fdc:	ec66                	sd	s9,24(sp)
    80002fde:	e86a                	sd	s10,16(sp)
    80002fe0:	e46e                	sd	s11,8(sp)
    80002fe2:	1880                	addi	s0,sp,112
    80002fe4:	8b2a                	mv	s6,a0
    80002fe6:	8c2e                	mv	s8,a1
    80002fe8:	8ab2                	mv	s5,a2
    80002fea:	8936                	mv	s2,a3
    80002fec:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fee:	00e687bb          	addw	a5,a3,a4
    80002ff2:	0ed7e263          	bltu	a5,a3,800030d6 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ff6:	00043737          	lui	a4,0x43
    80002ffa:	0ef76063          	bltu	a4,a5,800030da <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ffe:	0c0b8863          	beqz	s7,800030ce <writei+0x10e>
    80003002:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003004:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003008:	5cfd                	li	s9,-1
    8000300a:	a091                	j	8000304e <writei+0x8e>
    8000300c:	02099d93          	slli	s11,s3,0x20
    80003010:	020ddd93          	srli	s11,s11,0x20
    80003014:	05848513          	addi	a0,s1,88
    80003018:	86ee                	mv	a3,s11
    8000301a:	8656                	mv	a2,s5
    8000301c:	85e2                	mv	a1,s8
    8000301e:	953a                	add	a0,a0,a4
    80003020:	fffff097          	auipc	ra,0xfffff
    80003024:	8c8080e7          	jalr	-1848(ra) # 800018e8 <either_copyin>
    80003028:	07950263          	beq	a0,s9,8000308c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000302c:	8526                	mv	a0,s1
    8000302e:	00000097          	auipc	ra,0x0
    80003032:	798080e7          	jalr	1944(ra) # 800037c6 <log_write>
    brelse(bp);
    80003036:	8526                	mv	a0,s1
    80003038:	fffff097          	auipc	ra,0xfffff
    8000303c:	50a080e7          	jalr	1290(ra) # 80002542 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003040:	01498a3b          	addw	s4,s3,s4
    80003044:	0129893b          	addw	s2,s3,s2
    80003048:	9aee                	add	s5,s5,s11
    8000304a:	057a7663          	bgeu	s4,s7,80003096 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000304e:	000b2483          	lw	s1,0(s6)
    80003052:	00a9559b          	srliw	a1,s2,0xa
    80003056:	855a                	mv	a0,s6
    80003058:	fffff097          	auipc	ra,0xfffff
    8000305c:	7aa080e7          	jalr	1962(ra) # 80002802 <bmap>
    80003060:	0005059b          	sext.w	a1,a0
    80003064:	8526                	mv	a0,s1
    80003066:	fffff097          	auipc	ra,0xfffff
    8000306a:	3ac080e7          	jalr	940(ra) # 80002412 <bread>
    8000306e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003070:	3ff97713          	andi	a4,s2,1023
    80003074:	40ed07bb          	subw	a5,s10,a4
    80003078:	414b86bb          	subw	a3,s7,s4
    8000307c:	89be                	mv	s3,a5
    8000307e:	2781                	sext.w	a5,a5
    80003080:	0006861b          	sext.w	a2,a3
    80003084:	f8f674e3          	bgeu	a2,a5,8000300c <writei+0x4c>
    80003088:	89b6                	mv	s3,a3
    8000308a:	b749                	j	8000300c <writei+0x4c>
      brelse(bp);
    8000308c:	8526                	mv	a0,s1
    8000308e:	fffff097          	auipc	ra,0xfffff
    80003092:	4b4080e7          	jalr	1204(ra) # 80002542 <brelse>
  }

  if(off > ip->size)
    80003096:	04cb2783          	lw	a5,76(s6)
    8000309a:	0127f463          	bgeu	a5,s2,800030a2 <writei+0xe2>
    ip->size = off;
    8000309e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030a2:	855a                	mv	a0,s6
    800030a4:	00000097          	auipc	ra,0x0
    800030a8:	aa4080e7          	jalr	-1372(ra) # 80002b48 <iupdate>

  return tot;
    800030ac:	000a051b          	sext.w	a0,s4
}
    800030b0:	70a6                	ld	ra,104(sp)
    800030b2:	7406                	ld	s0,96(sp)
    800030b4:	64e6                	ld	s1,88(sp)
    800030b6:	6946                	ld	s2,80(sp)
    800030b8:	69a6                	ld	s3,72(sp)
    800030ba:	6a06                	ld	s4,64(sp)
    800030bc:	7ae2                	ld	s5,56(sp)
    800030be:	7b42                	ld	s6,48(sp)
    800030c0:	7ba2                	ld	s7,40(sp)
    800030c2:	7c02                	ld	s8,32(sp)
    800030c4:	6ce2                	ld	s9,24(sp)
    800030c6:	6d42                	ld	s10,16(sp)
    800030c8:	6da2                	ld	s11,8(sp)
    800030ca:	6165                	addi	sp,sp,112
    800030cc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ce:	8a5e                	mv	s4,s7
    800030d0:	bfc9                	j	800030a2 <writei+0xe2>
    return -1;
    800030d2:	557d                	li	a0,-1
}
    800030d4:	8082                	ret
    return -1;
    800030d6:	557d                	li	a0,-1
    800030d8:	bfe1                	j	800030b0 <writei+0xf0>
    return -1;
    800030da:	557d                	li	a0,-1
    800030dc:	bfd1                	j	800030b0 <writei+0xf0>

00000000800030de <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030de:	1141                	addi	sp,sp,-16
    800030e0:	e406                	sd	ra,8(sp)
    800030e2:	e022                	sd	s0,0(sp)
    800030e4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030e6:	4639                	li	a2,14
    800030e8:	ffffd097          	auipc	ra,0xffffd
    800030ec:	162080e7          	jalr	354(ra) # 8000024a <strncmp>
}
    800030f0:	60a2                	ld	ra,8(sp)
    800030f2:	6402                	ld	s0,0(sp)
    800030f4:	0141                	addi	sp,sp,16
    800030f6:	8082                	ret

00000000800030f8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030f8:	7139                	addi	sp,sp,-64
    800030fa:	fc06                	sd	ra,56(sp)
    800030fc:	f822                	sd	s0,48(sp)
    800030fe:	f426                	sd	s1,40(sp)
    80003100:	f04a                	sd	s2,32(sp)
    80003102:	ec4e                	sd	s3,24(sp)
    80003104:	e852                	sd	s4,16(sp)
    80003106:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003108:	04451703          	lh	a4,68(a0)
    8000310c:	4785                	li	a5,1
    8000310e:	00f71a63          	bne	a4,a5,80003122 <dirlookup+0x2a>
    80003112:	892a                	mv	s2,a0
    80003114:	89ae                	mv	s3,a1
    80003116:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003118:	457c                	lw	a5,76(a0)
    8000311a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000311c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000311e:	e79d                	bnez	a5,8000314c <dirlookup+0x54>
    80003120:	a8a5                	j	80003198 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003122:	00005517          	auipc	a0,0x5
    80003126:	42e50513          	addi	a0,a0,1070 # 80008550 <syscalls+0x1b0>
    8000312a:	00003097          	auipc	ra,0x3
    8000312e:	d76080e7          	jalr	-650(ra) # 80005ea0 <panic>
      panic("dirlookup read");
    80003132:	00005517          	auipc	a0,0x5
    80003136:	43650513          	addi	a0,a0,1078 # 80008568 <syscalls+0x1c8>
    8000313a:	00003097          	auipc	ra,0x3
    8000313e:	d66080e7          	jalr	-666(ra) # 80005ea0 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003142:	24c1                	addiw	s1,s1,16
    80003144:	04c92783          	lw	a5,76(s2)
    80003148:	04f4f763          	bgeu	s1,a5,80003196 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000314c:	4741                	li	a4,16
    8000314e:	86a6                	mv	a3,s1
    80003150:	fc040613          	addi	a2,s0,-64
    80003154:	4581                	li	a1,0
    80003156:	854a                	mv	a0,s2
    80003158:	00000097          	auipc	ra,0x0
    8000315c:	d70080e7          	jalr	-656(ra) # 80002ec8 <readi>
    80003160:	47c1                	li	a5,16
    80003162:	fcf518e3          	bne	a0,a5,80003132 <dirlookup+0x3a>
    if(de.inum == 0)
    80003166:	fc045783          	lhu	a5,-64(s0)
    8000316a:	dfe1                	beqz	a5,80003142 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000316c:	fc240593          	addi	a1,s0,-62
    80003170:	854e                	mv	a0,s3
    80003172:	00000097          	auipc	ra,0x0
    80003176:	f6c080e7          	jalr	-148(ra) # 800030de <namecmp>
    8000317a:	f561                	bnez	a0,80003142 <dirlookup+0x4a>
      if(poff)
    8000317c:	000a0463          	beqz	s4,80003184 <dirlookup+0x8c>
        *poff = off;
    80003180:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003184:	fc045583          	lhu	a1,-64(s0)
    80003188:	00092503          	lw	a0,0(s2)
    8000318c:	fffff097          	auipc	ra,0xfffff
    80003190:	752080e7          	jalr	1874(ra) # 800028de <iget>
    80003194:	a011                	j	80003198 <dirlookup+0xa0>
  return 0;
    80003196:	4501                	li	a0,0
}
    80003198:	70e2                	ld	ra,56(sp)
    8000319a:	7442                	ld	s0,48(sp)
    8000319c:	74a2                	ld	s1,40(sp)
    8000319e:	7902                	ld	s2,32(sp)
    800031a0:	69e2                	ld	s3,24(sp)
    800031a2:	6a42                	ld	s4,16(sp)
    800031a4:	6121                	addi	sp,sp,64
    800031a6:	8082                	ret

00000000800031a8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031a8:	711d                	addi	sp,sp,-96
    800031aa:	ec86                	sd	ra,88(sp)
    800031ac:	e8a2                	sd	s0,80(sp)
    800031ae:	e4a6                	sd	s1,72(sp)
    800031b0:	e0ca                	sd	s2,64(sp)
    800031b2:	fc4e                	sd	s3,56(sp)
    800031b4:	f852                	sd	s4,48(sp)
    800031b6:	f456                	sd	s5,40(sp)
    800031b8:	f05a                	sd	s6,32(sp)
    800031ba:	ec5e                	sd	s7,24(sp)
    800031bc:	e862                	sd	s8,16(sp)
    800031be:	e466                	sd	s9,8(sp)
    800031c0:	e06a                	sd	s10,0(sp)
    800031c2:	1080                	addi	s0,sp,96
    800031c4:	84aa                	mv	s1,a0
    800031c6:	8b2e                	mv	s6,a1
    800031c8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031ca:	00054703          	lbu	a4,0(a0)
    800031ce:	02f00793          	li	a5,47
    800031d2:	02f70363          	beq	a4,a5,800031f8 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031d6:	ffffe097          	auipc	ra,0xffffe
    800031da:	c54080e7          	jalr	-940(ra) # 80000e2a <myproc>
    800031de:	15053503          	ld	a0,336(a0)
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	9f4080e7          	jalr	-1548(ra) # 80002bd6 <idup>
    800031ea:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031ec:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031f0:	4cb5                	li	s9,13
  len = path - s;
    800031f2:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031f4:	4c05                	li	s8,1
    800031f6:	a87d                	j	800032b4 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800031f8:	4585                	li	a1,1
    800031fa:	4505                	li	a0,1
    800031fc:	fffff097          	auipc	ra,0xfffff
    80003200:	6e2080e7          	jalr	1762(ra) # 800028de <iget>
    80003204:	8a2a                	mv	s4,a0
    80003206:	b7dd                	j	800031ec <namex+0x44>
      iunlockput(ip);
    80003208:	8552                	mv	a0,s4
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	c6c080e7          	jalr	-916(ra) # 80002e76 <iunlockput>
      return 0;
    80003212:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003214:	8552                	mv	a0,s4
    80003216:	60e6                	ld	ra,88(sp)
    80003218:	6446                	ld	s0,80(sp)
    8000321a:	64a6                	ld	s1,72(sp)
    8000321c:	6906                	ld	s2,64(sp)
    8000321e:	79e2                	ld	s3,56(sp)
    80003220:	7a42                	ld	s4,48(sp)
    80003222:	7aa2                	ld	s5,40(sp)
    80003224:	7b02                	ld	s6,32(sp)
    80003226:	6be2                	ld	s7,24(sp)
    80003228:	6c42                	ld	s8,16(sp)
    8000322a:	6ca2                	ld	s9,8(sp)
    8000322c:	6d02                	ld	s10,0(sp)
    8000322e:	6125                	addi	sp,sp,96
    80003230:	8082                	ret
      iunlock(ip);
    80003232:	8552                	mv	a0,s4
    80003234:	00000097          	auipc	ra,0x0
    80003238:	aa2080e7          	jalr	-1374(ra) # 80002cd6 <iunlock>
      return ip;
    8000323c:	bfe1                	j	80003214 <namex+0x6c>
      iunlockput(ip);
    8000323e:	8552                	mv	a0,s4
    80003240:	00000097          	auipc	ra,0x0
    80003244:	c36080e7          	jalr	-970(ra) # 80002e76 <iunlockput>
      return 0;
    80003248:	8a4e                	mv	s4,s3
    8000324a:	b7e9                	j	80003214 <namex+0x6c>
  len = path - s;
    8000324c:	40998633          	sub	a2,s3,s1
    80003250:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003254:	09acd863          	bge	s9,s10,800032e4 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003258:	4639                	li	a2,14
    8000325a:	85a6                	mv	a1,s1
    8000325c:	8556                	mv	a0,s5
    8000325e:	ffffd097          	auipc	ra,0xffffd
    80003262:	f78080e7          	jalr	-136(ra) # 800001d6 <memmove>
    80003266:	84ce                	mv	s1,s3
  while(*path == '/')
    80003268:	0004c783          	lbu	a5,0(s1)
    8000326c:	01279763          	bne	a5,s2,8000327a <namex+0xd2>
    path++;
    80003270:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003272:	0004c783          	lbu	a5,0(s1)
    80003276:	ff278de3          	beq	a5,s2,80003270 <namex+0xc8>
    ilock(ip);
    8000327a:	8552                	mv	a0,s4
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	998080e7          	jalr	-1640(ra) # 80002c14 <ilock>
    if(ip->type != T_DIR){
    80003284:	044a1783          	lh	a5,68(s4)
    80003288:	f98790e3          	bne	a5,s8,80003208 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000328c:	000b0563          	beqz	s6,80003296 <namex+0xee>
    80003290:	0004c783          	lbu	a5,0(s1)
    80003294:	dfd9                	beqz	a5,80003232 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003296:	865e                	mv	a2,s7
    80003298:	85d6                	mv	a1,s5
    8000329a:	8552                	mv	a0,s4
    8000329c:	00000097          	auipc	ra,0x0
    800032a0:	e5c080e7          	jalr	-420(ra) # 800030f8 <dirlookup>
    800032a4:	89aa                	mv	s3,a0
    800032a6:	dd41                	beqz	a0,8000323e <namex+0x96>
    iunlockput(ip);
    800032a8:	8552                	mv	a0,s4
    800032aa:	00000097          	auipc	ra,0x0
    800032ae:	bcc080e7          	jalr	-1076(ra) # 80002e76 <iunlockput>
    ip = next;
    800032b2:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032b4:	0004c783          	lbu	a5,0(s1)
    800032b8:	01279763          	bne	a5,s2,800032c6 <namex+0x11e>
    path++;
    800032bc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032be:	0004c783          	lbu	a5,0(s1)
    800032c2:	ff278de3          	beq	a5,s2,800032bc <namex+0x114>
  if(*path == 0)
    800032c6:	cb9d                	beqz	a5,800032fc <namex+0x154>
  while(*path != '/' && *path != 0)
    800032c8:	0004c783          	lbu	a5,0(s1)
    800032cc:	89a6                	mv	s3,s1
  len = path - s;
    800032ce:	8d5e                	mv	s10,s7
    800032d0:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032d2:	01278963          	beq	a5,s2,800032e4 <namex+0x13c>
    800032d6:	dbbd                	beqz	a5,8000324c <namex+0xa4>
    path++;
    800032d8:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800032da:	0009c783          	lbu	a5,0(s3)
    800032de:	ff279ce3          	bne	a5,s2,800032d6 <namex+0x12e>
    800032e2:	b7ad                	j	8000324c <namex+0xa4>
    memmove(name, s, len);
    800032e4:	2601                	sext.w	a2,a2
    800032e6:	85a6                	mv	a1,s1
    800032e8:	8556                	mv	a0,s5
    800032ea:	ffffd097          	auipc	ra,0xffffd
    800032ee:	eec080e7          	jalr	-276(ra) # 800001d6 <memmove>
    name[len] = 0;
    800032f2:	9d56                	add	s10,s10,s5
    800032f4:	000d0023          	sb	zero,0(s10)
    800032f8:	84ce                	mv	s1,s3
    800032fa:	b7bd                	j	80003268 <namex+0xc0>
  if(nameiparent){
    800032fc:	f00b0ce3          	beqz	s6,80003214 <namex+0x6c>
    iput(ip);
    80003300:	8552                	mv	a0,s4
    80003302:	00000097          	auipc	ra,0x0
    80003306:	acc080e7          	jalr	-1332(ra) # 80002dce <iput>
    return 0;
    8000330a:	4a01                	li	s4,0
    8000330c:	b721                	j	80003214 <namex+0x6c>

000000008000330e <dirlink>:
{
    8000330e:	7139                	addi	sp,sp,-64
    80003310:	fc06                	sd	ra,56(sp)
    80003312:	f822                	sd	s0,48(sp)
    80003314:	f426                	sd	s1,40(sp)
    80003316:	f04a                	sd	s2,32(sp)
    80003318:	ec4e                	sd	s3,24(sp)
    8000331a:	e852                	sd	s4,16(sp)
    8000331c:	0080                	addi	s0,sp,64
    8000331e:	892a                	mv	s2,a0
    80003320:	8a2e                	mv	s4,a1
    80003322:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003324:	4601                	li	a2,0
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	dd2080e7          	jalr	-558(ra) # 800030f8 <dirlookup>
    8000332e:	e93d                	bnez	a0,800033a4 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003330:	04c92483          	lw	s1,76(s2)
    80003334:	c49d                	beqz	s1,80003362 <dirlink+0x54>
    80003336:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003338:	4741                	li	a4,16
    8000333a:	86a6                	mv	a3,s1
    8000333c:	fc040613          	addi	a2,s0,-64
    80003340:	4581                	li	a1,0
    80003342:	854a                	mv	a0,s2
    80003344:	00000097          	auipc	ra,0x0
    80003348:	b84080e7          	jalr	-1148(ra) # 80002ec8 <readi>
    8000334c:	47c1                	li	a5,16
    8000334e:	06f51163          	bne	a0,a5,800033b0 <dirlink+0xa2>
    if(de.inum == 0)
    80003352:	fc045783          	lhu	a5,-64(s0)
    80003356:	c791                	beqz	a5,80003362 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003358:	24c1                	addiw	s1,s1,16
    8000335a:	04c92783          	lw	a5,76(s2)
    8000335e:	fcf4ede3          	bltu	s1,a5,80003338 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003362:	4639                	li	a2,14
    80003364:	85d2                	mv	a1,s4
    80003366:	fc240513          	addi	a0,s0,-62
    8000336a:	ffffd097          	auipc	ra,0xffffd
    8000336e:	f1c080e7          	jalr	-228(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003372:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003376:	4741                	li	a4,16
    80003378:	86a6                	mv	a3,s1
    8000337a:	fc040613          	addi	a2,s0,-64
    8000337e:	4581                	li	a1,0
    80003380:	854a                	mv	a0,s2
    80003382:	00000097          	auipc	ra,0x0
    80003386:	c3e080e7          	jalr	-962(ra) # 80002fc0 <writei>
    8000338a:	872a                	mv	a4,a0
    8000338c:	47c1                	li	a5,16
  return 0;
    8000338e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003390:	02f71863          	bne	a4,a5,800033c0 <dirlink+0xb2>
}
    80003394:	70e2                	ld	ra,56(sp)
    80003396:	7442                	ld	s0,48(sp)
    80003398:	74a2                	ld	s1,40(sp)
    8000339a:	7902                	ld	s2,32(sp)
    8000339c:	69e2                	ld	s3,24(sp)
    8000339e:	6a42                	ld	s4,16(sp)
    800033a0:	6121                	addi	sp,sp,64
    800033a2:	8082                	ret
    iput(ip);
    800033a4:	00000097          	auipc	ra,0x0
    800033a8:	a2a080e7          	jalr	-1494(ra) # 80002dce <iput>
    return -1;
    800033ac:	557d                	li	a0,-1
    800033ae:	b7dd                	j	80003394 <dirlink+0x86>
      panic("dirlink read");
    800033b0:	00005517          	auipc	a0,0x5
    800033b4:	1c850513          	addi	a0,a0,456 # 80008578 <syscalls+0x1d8>
    800033b8:	00003097          	auipc	ra,0x3
    800033bc:	ae8080e7          	jalr	-1304(ra) # 80005ea0 <panic>
    panic("dirlink");
    800033c0:	00005517          	auipc	a0,0x5
    800033c4:	2c850513          	addi	a0,a0,712 # 80008688 <syscalls+0x2e8>
    800033c8:	00003097          	auipc	ra,0x3
    800033cc:	ad8080e7          	jalr	-1320(ra) # 80005ea0 <panic>

00000000800033d0 <namei>:

struct inode*
namei(char *path)
{
    800033d0:	1101                	addi	sp,sp,-32
    800033d2:	ec06                	sd	ra,24(sp)
    800033d4:	e822                	sd	s0,16(sp)
    800033d6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033d8:	fe040613          	addi	a2,s0,-32
    800033dc:	4581                	li	a1,0
    800033de:	00000097          	auipc	ra,0x0
    800033e2:	dca080e7          	jalr	-566(ra) # 800031a8 <namex>
}
    800033e6:	60e2                	ld	ra,24(sp)
    800033e8:	6442                	ld	s0,16(sp)
    800033ea:	6105                	addi	sp,sp,32
    800033ec:	8082                	ret

00000000800033ee <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033ee:	1141                	addi	sp,sp,-16
    800033f0:	e406                	sd	ra,8(sp)
    800033f2:	e022                	sd	s0,0(sp)
    800033f4:	0800                	addi	s0,sp,16
    800033f6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033f8:	4585                	li	a1,1
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	dae080e7          	jalr	-594(ra) # 800031a8 <namex>
}
    80003402:	60a2                	ld	ra,8(sp)
    80003404:	6402                	ld	s0,0(sp)
    80003406:	0141                	addi	sp,sp,16
    80003408:	8082                	ret

000000008000340a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000340a:	1101                	addi	sp,sp,-32
    8000340c:	ec06                	sd	ra,24(sp)
    8000340e:	e822                	sd	s0,16(sp)
    80003410:	e426                	sd	s1,8(sp)
    80003412:	e04a                	sd	s2,0(sp)
    80003414:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003416:	00024917          	auipc	s2,0x24
    8000341a:	c0a90913          	addi	s2,s2,-1014 # 80027020 <log>
    8000341e:	01892583          	lw	a1,24(s2)
    80003422:	02892503          	lw	a0,40(s2)
    80003426:	fffff097          	auipc	ra,0xfffff
    8000342a:	fec080e7          	jalr	-20(ra) # 80002412 <bread>
    8000342e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003430:	02c92683          	lw	a3,44(s2)
    80003434:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003436:	02d05863          	blez	a3,80003466 <write_head+0x5c>
    8000343a:	00024797          	auipc	a5,0x24
    8000343e:	c1678793          	addi	a5,a5,-1002 # 80027050 <log+0x30>
    80003442:	05c50713          	addi	a4,a0,92
    80003446:	36fd                	addiw	a3,a3,-1
    80003448:	02069613          	slli	a2,a3,0x20
    8000344c:	01e65693          	srli	a3,a2,0x1e
    80003450:	00024617          	auipc	a2,0x24
    80003454:	c0460613          	addi	a2,a2,-1020 # 80027054 <log+0x34>
    80003458:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000345a:	4390                	lw	a2,0(a5)
    8000345c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000345e:	0791                	addi	a5,a5,4
    80003460:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003462:	fed79ce3          	bne	a5,a3,8000345a <write_head+0x50>
  }
  bwrite(buf);
    80003466:	8526                	mv	a0,s1
    80003468:	fffff097          	auipc	ra,0xfffff
    8000346c:	09c080e7          	jalr	156(ra) # 80002504 <bwrite>
  brelse(buf);
    80003470:	8526                	mv	a0,s1
    80003472:	fffff097          	auipc	ra,0xfffff
    80003476:	0d0080e7          	jalr	208(ra) # 80002542 <brelse>
}
    8000347a:	60e2                	ld	ra,24(sp)
    8000347c:	6442                	ld	s0,16(sp)
    8000347e:	64a2                	ld	s1,8(sp)
    80003480:	6902                	ld	s2,0(sp)
    80003482:	6105                	addi	sp,sp,32
    80003484:	8082                	ret

0000000080003486 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003486:	00024797          	auipc	a5,0x24
    8000348a:	bc67a783          	lw	a5,-1082(a5) # 8002704c <log+0x2c>
    8000348e:	0af05d63          	blez	a5,80003548 <install_trans+0xc2>
{
    80003492:	7139                	addi	sp,sp,-64
    80003494:	fc06                	sd	ra,56(sp)
    80003496:	f822                	sd	s0,48(sp)
    80003498:	f426                	sd	s1,40(sp)
    8000349a:	f04a                	sd	s2,32(sp)
    8000349c:	ec4e                	sd	s3,24(sp)
    8000349e:	e852                	sd	s4,16(sp)
    800034a0:	e456                	sd	s5,8(sp)
    800034a2:	e05a                	sd	s6,0(sp)
    800034a4:	0080                	addi	s0,sp,64
    800034a6:	8b2a                	mv	s6,a0
    800034a8:	00024a97          	auipc	s5,0x24
    800034ac:	ba8a8a93          	addi	s5,s5,-1112 # 80027050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034b0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034b2:	00024997          	auipc	s3,0x24
    800034b6:	b6e98993          	addi	s3,s3,-1170 # 80027020 <log>
    800034ba:	a00d                	j	800034dc <install_trans+0x56>
    brelse(lbuf);
    800034bc:	854a                	mv	a0,s2
    800034be:	fffff097          	auipc	ra,0xfffff
    800034c2:	084080e7          	jalr	132(ra) # 80002542 <brelse>
    brelse(dbuf);
    800034c6:	8526                	mv	a0,s1
    800034c8:	fffff097          	auipc	ra,0xfffff
    800034cc:	07a080e7          	jalr	122(ra) # 80002542 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034d0:	2a05                	addiw	s4,s4,1
    800034d2:	0a91                	addi	s5,s5,4
    800034d4:	02c9a783          	lw	a5,44(s3)
    800034d8:	04fa5e63          	bge	s4,a5,80003534 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034dc:	0189a583          	lw	a1,24(s3)
    800034e0:	014585bb          	addw	a1,a1,s4
    800034e4:	2585                	addiw	a1,a1,1
    800034e6:	0289a503          	lw	a0,40(s3)
    800034ea:	fffff097          	auipc	ra,0xfffff
    800034ee:	f28080e7          	jalr	-216(ra) # 80002412 <bread>
    800034f2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034f4:	000aa583          	lw	a1,0(s5)
    800034f8:	0289a503          	lw	a0,40(s3)
    800034fc:	fffff097          	auipc	ra,0xfffff
    80003500:	f16080e7          	jalr	-234(ra) # 80002412 <bread>
    80003504:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003506:	40000613          	li	a2,1024
    8000350a:	05890593          	addi	a1,s2,88
    8000350e:	05850513          	addi	a0,a0,88
    80003512:	ffffd097          	auipc	ra,0xffffd
    80003516:	cc4080e7          	jalr	-828(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000351a:	8526                	mv	a0,s1
    8000351c:	fffff097          	auipc	ra,0xfffff
    80003520:	fe8080e7          	jalr	-24(ra) # 80002504 <bwrite>
    if(recovering == 0)
    80003524:	f80b1ce3          	bnez	s6,800034bc <install_trans+0x36>
      bunpin(dbuf);
    80003528:	8526                	mv	a0,s1
    8000352a:	fffff097          	auipc	ra,0xfffff
    8000352e:	0f2080e7          	jalr	242(ra) # 8000261c <bunpin>
    80003532:	b769                	j	800034bc <install_trans+0x36>
}
    80003534:	70e2                	ld	ra,56(sp)
    80003536:	7442                	ld	s0,48(sp)
    80003538:	74a2                	ld	s1,40(sp)
    8000353a:	7902                	ld	s2,32(sp)
    8000353c:	69e2                	ld	s3,24(sp)
    8000353e:	6a42                	ld	s4,16(sp)
    80003540:	6aa2                	ld	s5,8(sp)
    80003542:	6b02                	ld	s6,0(sp)
    80003544:	6121                	addi	sp,sp,64
    80003546:	8082                	ret
    80003548:	8082                	ret

000000008000354a <initlog>:
{
    8000354a:	7179                	addi	sp,sp,-48
    8000354c:	f406                	sd	ra,40(sp)
    8000354e:	f022                	sd	s0,32(sp)
    80003550:	ec26                	sd	s1,24(sp)
    80003552:	e84a                	sd	s2,16(sp)
    80003554:	e44e                	sd	s3,8(sp)
    80003556:	1800                	addi	s0,sp,48
    80003558:	892a                	mv	s2,a0
    8000355a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000355c:	00024497          	auipc	s1,0x24
    80003560:	ac448493          	addi	s1,s1,-1340 # 80027020 <log>
    80003564:	00005597          	auipc	a1,0x5
    80003568:	02458593          	addi	a1,a1,36 # 80008588 <syscalls+0x1e8>
    8000356c:	8526                	mv	a0,s1
    8000356e:	00003097          	auipc	ra,0x3
    80003572:	dda080e7          	jalr	-550(ra) # 80006348 <initlock>
  log.start = sb->logstart;
    80003576:	0149a583          	lw	a1,20(s3)
    8000357a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000357c:	0109a783          	lw	a5,16(s3)
    80003580:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003582:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003586:	854a                	mv	a0,s2
    80003588:	fffff097          	auipc	ra,0xfffff
    8000358c:	e8a080e7          	jalr	-374(ra) # 80002412 <bread>
  log.lh.n = lh->n;
    80003590:	4d34                	lw	a3,88(a0)
    80003592:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003594:	02d05663          	blez	a3,800035c0 <initlog+0x76>
    80003598:	05c50793          	addi	a5,a0,92
    8000359c:	00024717          	auipc	a4,0x24
    800035a0:	ab470713          	addi	a4,a4,-1356 # 80027050 <log+0x30>
    800035a4:	36fd                	addiw	a3,a3,-1
    800035a6:	02069613          	slli	a2,a3,0x20
    800035aa:	01e65693          	srli	a3,a2,0x1e
    800035ae:	06050613          	addi	a2,a0,96
    800035b2:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800035b4:	4390                	lw	a2,0(a5)
    800035b6:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035b8:	0791                	addi	a5,a5,4
    800035ba:	0711                	addi	a4,a4,4
    800035bc:	fed79ce3          	bne	a5,a3,800035b4 <initlog+0x6a>
  brelse(buf);
    800035c0:	fffff097          	auipc	ra,0xfffff
    800035c4:	f82080e7          	jalr	-126(ra) # 80002542 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035c8:	4505                	li	a0,1
    800035ca:	00000097          	auipc	ra,0x0
    800035ce:	ebc080e7          	jalr	-324(ra) # 80003486 <install_trans>
  log.lh.n = 0;
    800035d2:	00024797          	auipc	a5,0x24
    800035d6:	a607ad23          	sw	zero,-1414(a5) # 8002704c <log+0x2c>
  write_head(); // clear the log
    800035da:	00000097          	auipc	ra,0x0
    800035de:	e30080e7          	jalr	-464(ra) # 8000340a <write_head>
}
    800035e2:	70a2                	ld	ra,40(sp)
    800035e4:	7402                	ld	s0,32(sp)
    800035e6:	64e2                	ld	s1,24(sp)
    800035e8:	6942                	ld	s2,16(sp)
    800035ea:	69a2                	ld	s3,8(sp)
    800035ec:	6145                	addi	sp,sp,48
    800035ee:	8082                	ret

00000000800035f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035f0:	1101                	addi	sp,sp,-32
    800035f2:	ec06                	sd	ra,24(sp)
    800035f4:	e822                	sd	s0,16(sp)
    800035f6:	e426                	sd	s1,8(sp)
    800035f8:	e04a                	sd	s2,0(sp)
    800035fa:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035fc:	00024517          	auipc	a0,0x24
    80003600:	a2450513          	addi	a0,a0,-1500 # 80027020 <log>
    80003604:	00003097          	auipc	ra,0x3
    80003608:	dd4080e7          	jalr	-556(ra) # 800063d8 <acquire>
  while(1){
    if(log.committing){
    8000360c:	00024497          	auipc	s1,0x24
    80003610:	a1448493          	addi	s1,s1,-1516 # 80027020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003614:	4979                	li	s2,30
    80003616:	a039                	j	80003624 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003618:	85a6                	mv	a1,s1
    8000361a:	8526                	mv	a0,s1
    8000361c:	ffffe097          	auipc	ra,0xffffe
    80003620:	ed2080e7          	jalr	-302(ra) # 800014ee <sleep>
    if(log.committing){
    80003624:	50dc                	lw	a5,36(s1)
    80003626:	fbed                	bnez	a5,80003618 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003628:	5098                	lw	a4,32(s1)
    8000362a:	2705                	addiw	a4,a4,1
    8000362c:	0007069b          	sext.w	a3,a4
    80003630:	0027179b          	slliw	a5,a4,0x2
    80003634:	9fb9                	addw	a5,a5,a4
    80003636:	0017979b          	slliw	a5,a5,0x1
    8000363a:	54d8                	lw	a4,44(s1)
    8000363c:	9fb9                	addw	a5,a5,a4
    8000363e:	00f95963          	bge	s2,a5,80003650 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003642:	85a6                	mv	a1,s1
    80003644:	8526                	mv	a0,s1
    80003646:	ffffe097          	auipc	ra,0xffffe
    8000364a:	ea8080e7          	jalr	-344(ra) # 800014ee <sleep>
    8000364e:	bfd9                	j	80003624 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003650:	00024517          	auipc	a0,0x24
    80003654:	9d050513          	addi	a0,a0,-1584 # 80027020 <log>
    80003658:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000365a:	00003097          	auipc	ra,0x3
    8000365e:	e32080e7          	jalr	-462(ra) # 8000648c <release>
      break;
    }
  }
}
    80003662:	60e2                	ld	ra,24(sp)
    80003664:	6442                	ld	s0,16(sp)
    80003666:	64a2                	ld	s1,8(sp)
    80003668:	6902                	ld	s2,0(sp)
    8000366a:	6105                	addi	sp,sp,32
    8000366c:	8082                	ret

000000008000366e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000366e:	7139                	addi	sp,sp,-64
    80003670:	fc06                	sd	ra,56(sp)
    80003672:	f822                	sd	s0,48(sp)
    80003674:	f426                	sd	s1,40(sp)
    80003676:	f04a                	sd	s2,32(sp)
    80003678:	ec4e                	sd	s3,24(sp)
    8000367a:	e852                	sd	s4,16(sp)
    8000367c:	e456                	sd	s5,8(sp)
    8000367e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003680:	00024497          	auipc	s1,0x24
    80003684:	9a048493          	addi	s1,s1,-1632 # 80027020 <log>
    80003688:	8526                	mv	a0,s1
    8000368a:	00003097          	auipc	ra,0x3
    8000368e:	d4e080e7          	jalr	-690(ra) # 800063d8 <acquire>
  log.outstanding -= 1;
    80003692:	509c                	lw	a5,32(s1)
    80003694:	37fd                	addiw	a5,a5,-1
    80003696:	0007891b          	sext.w	s2,a5
    8000369a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000369c:	50dc                	lw	a5,36(s1)
    8000369e:	e7b9                	bnez	a5,800036ec <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036a0:	04091e63          	bnez	s2,800036fc <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036a4:	00024497          	auipc	s1,0x24
    800036a8:	97c48493          	addi	s1,s1,-1668 # 80027020 <log>
    800036ac:	4785                	li	a5,1
    800036ae:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036b0:	8526                	mv	a0,s1
    800036b2:	00003097          	auipc	ra,0x3
    800036b6:	dda080e7          	jalr	-550(ra) # 8000648c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036ba:	54dc                	lw	a5,44(s1)
    800036bc:	06f04763          	bgtz	a5,8000372a <end_op+0xbc>
    acquire(&log.lock);
    800036c0:	00024497          	auipc	s1,0x24
    800036c4:	96048493          	addi	s1,s1,-1696 # 80027020 <log>
    800036c8:	8526                	mv	a0,s1
    800036ca:	00003097          	auipc	ra,0x3
    800036ce:	d0e080e7          	jalr	-754(ra) # 800063d8 <acquire>
    log.committing = 0;
    800036d2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036d6:	8526                	mv	a0,s1
    800036d8:	ffffe097          	auipc	ra,0xffffe
    800036dc:	fa2080e7          	jalr	-94(ra) # 8000167a <wakeup>
    release(&log.lock);
    800036e0:	8526                	mv	a0,s1
    800036e2:	00003097          	auipc	ra,0x3
    800036e6:	daa080e7          	jalr	-598(ra) # 8000648c <release>
}
    800036ea:	a03d                	j	80003718 <end_op+0xaa>
    panic("log.committing");
    800036ec:	00005517          	auipc	a0,0x5
    800036f0:	ea450513          	addi	a0,a0,-348 # 80008590 <syscalls+0x1f0>
    800036f4:	00002097          	auipc	ra,0x2
    800036f8:	7ac080e7          	jalr	1964(ra) # 80005ea0 <panic>
    wakeup(&log);
    800036fc:	00024497          	auipc	s1,0x24
    80003700:	92448493          	addi	s1,s1,-1756 # 80027020 <log>
    80003704:	8526                	mv	a0,s1
    80003706:	ffffe097          	auipc	ra,0xffffe
    8000370a:	f74080e7          	jalr	-140(ra) # 8000167a <wakeup>
  release(&log.lock);
    8000370e:	8526                	mv	a0,s1
    80003710:	00003097          	auipc	ra,0x3
    80003714:	d7c080e7          	jalr	-644(ra) # 8000648c <release>
}
    80003718:	70e2                	ld	ra,56(sp)
    8000371a:	7442                	ld	s0,48(sp)
    8000371c:	74a2                	ld	s1,40(sp)
    8000371e:	7902                	ld	s2,32(sp)
    80003720:	69e2                	ld	s3,24(sp)
    80003722:	6a42                	ld	s4,16(sp)
    80003724:	6aa2                	ld	s5,8(sp)
    80003726:	6121                	addi	sp,sp,64
    80003728:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000372a:	00024a97          	auipc	s5,0x24
    8000372e:	926a8a93          	addi	s5,s5,-1754 # 80027050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003732:	00024a17          	auipc	s4,0x24
    80003736:	8eea0a13          	addi	s4,s4,-1810 # 80027020 <log>
    8000373a:	018a2583          	lw	a1,24(s4)
    8000373e:	012585bb          	addw	a1,a1,s2
    80003742:	2585                	addiw	a1,a1,1
    80003744:	028a2503          	lw	a0,40(s4)
    80003748:	fffff097          	auipc	ra,0xfffff
    8000374c:	cca080e7          	jalr	-822(ra) # 80002412 <bread>
    80003750:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003752:	000aa583          	lw	a1,0(s5)
    80003756:	028a2503          	lw	a0,40(s4)
    8000375a:	fffff097          	auipc	ra,0xfffff
    8000375e:	cb8080e7          	jalr	-840(ra) # 80002412 <bread>
    80003762:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003764:	40000613          	li	a2,1024
    80003768:	05850593          	addi	a1,a0,88
    8000376c:	05848513          	addi	a0,s1,88
    80003770:	ffffd097          	auipc	ra,0xffffd
    80003774:	a66080e7          	jalr	-1434(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003778:	8526                	mv	a0,s1
    8000377a:	fffff097          	auipc	ra,0xfffff
    8000377e:	d8a080e7          	jalr	-630(ra) # 80002504 <bwrite>
    brelse(from);
    80003782:	854e                	mv	a0,s3
    80003784:	fffff097          	auipc	ra,0xfffff
    80003788:	dbe080e7          	jalr	-578(ra) # 80002542 <brelse>
    brelse(to);
    8000378c:	8526                	mv	a0,s1
    8000378e:	fffff097          	auipc	ra,0xfffff
    80003792:	db4080e7          	jalr	-588(ra) # 80002542 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003796:	2905                	addiw	s2,s2,1
    80003798:	0a91                	addi	s5,s5,4
    8000379a:	02ca2783          	lw	a5,44(s4)
    8000379e:	f8f94ee3          	blt	s2,a5,8000373a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037a2:	00000097          	auipc	ra,0x0
    800037a6:	c68080e7          	jalr	-920(ra) # 8000340a <write_head>
    install_trans(0); // Now install writes to home locations
    800037aa:	4501                	li	a0,0
    800037ac:	00000097          	auipc	ra,0x0
    800037b0:	cda080e7          	jalr	-806(ra) # 80003486 <install_trans>
    log.lh.n = 0;
    800037b4:	00024797          	auipc	a5,0x24
    800037b8:	8807ac23          	sw	zero,-1896(a5) # 8002704c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037bc:	00000097          	auipc	ra,0x0
    800037c0:	c4e080e7          	jalr	-946(ra) # 8000340a <write_head>
    800037c4:	bdf5                	j	800036c0 <end_op+0x52>

00000000800037c6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037c6:	1101                	addi	sp,sp,-32
    800037c8:	ec06                	sd	ra,24(sp)
    800037ca:	e822                	sd	s0,16(sp)
    800037cc:	e426                	sd	s1,8(sp)
    800037ce:	e04a                	sd	s2,0(sp)
    800037d0:	1000                	addi	s0,sp,32
    800037d2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037d4:	00024917          	auipc	s2,0x24
    800037d8:	84c90913          	addi	s2,s2,-1972 # 80027020 <log>
    800037dc:	854a                	mv	a0,s2
    800037de:	00003097          	auipc	ra,0x3
    800037e2:	bfa080e7          	jalr	-1030(ra) # 800063d8 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037e6:	02c92603          	lw	a2,44(s2)
    800037ea:	47f5                	li	a5,29
    800037ec:	06c7c563          	blt	a5,a2,80003856 <log_write+0x90>
    800037f0:	00024797          	auipc	a5,0x24
    800037f4:	84c7a783          	lw	a5,-1972(a5) # 8002703c <log+0x1c>
    800037f8:	37fd                	addiw	a5,a5,-1
    800037fa:	04f65e63          	bge	a2,a5,80003856 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037fe:	00024797          	auipc	a5,0x24
    80003802:	8427a783          	lw	a5,-1982(a5) # 80027040 <log+0x20>
    80003806:	06f05063          	blez	a5,80003866 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000380a:	4781                	li	a5,0
    8000380c:	06c05563          	blez	a2,80003876 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003810:	44cc                	lw	a1,12(s1)
    80003812:	00024717          	auipc	a4,0x24
    80003816:	83e70713          	addi	a4,a4,-1986 # 80027050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000381a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000381c:	4314                	lw	a3,0(a4)
    8000381e:	04b68c63          	beq	a3,a1,80003876 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003822:	2785                	addiw	a5,a5,1
    80003824:	0711                	addi	a4,a4,4
    80003826:	fef61be3          	bne	a2,a5,8000381c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000382a:	0621                	addi	a2,a2,8
    8000382c:	060a                	slli	a2,a2,0x2
    8000382e:	00023797          	auipc	a5,0x23
    80003832:	7f278793          	addi	a5,a5,2034 # 80027020 <log>
    80003836:	97b2                	add	a5,a5,a2
    80003838:	44d8                	lw	a4,12(s1)
    8000383a:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000383c:	8526                	mv	a0,s1
    8000383e:	fffff097          	auipc	ra,0xfffff
    80003842:	da2080e7          	jalr	-606(ra) # 800025e0 <bpin>
    log.lh.n++;
    80003846:	00023717          	auipc	a4,0x23
    8000384a:	7da70713          	addi	a4,a4,2010 # 80027020 <log>
    8000384e:	575c                	lw	a5,44(a4)
    80003850:	2785                	addiw	a5,a5,1
    80003852:	d75c                	sw	a5,44(a4)
    80003854:	a82d                	j	8000388e <log_write+0xc8>
    panic("too big a transaction");
    80003856:	00005517          	auipc	a0,0x5
    8000385a:	d4a50513          	addi	a0,a0,-694 # 800085a0 <syscalls+0x200>
    8000385e:	00002097          	auipc	ra,0x2
    80003862:	642080e7          	jalr	1602(ra) # 80005ea0 <panic>
    panic("log_write outside of trans");
    80003866:	00005517          	auipc	a0,0x5
    8000386a:	d5250513          	addi	a0,a0,-686 # 800085b8 <syscalls+0x218>
    8000386e:	00002097          	auipc	ra,0x2
    80003872:	632080e7          	jalr	1586(ra) # 80005ea0 <panic>
  log.lh.block[i] = b->blockno;
    80003876:	00878693          	addi	a3,a5,8
    8000387a:	068a                	slli	a3,a3,0x2
    8000387c:	00023717          	auipc	a4,0x23
    80003880:	7a470713          	addi	a4,a4,1956 # 80027020 <log>
    80003884:	9736                	add	a4,a4,a3
    80003886:	44d4                	lw	a3,12(s1)
    80003888:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000388a:	faf609e3          	beq	a2,a5,8000383c <log_write+0x76>
  }
  release(&log.lock);
    8000388e:	00023517          	auipc	a0,0x23
    80003892:	79250513          	addi	a0,a0,1938 # 80027020 <log>
    80003896:	00003097          	auipc	ra,0x3
    8000389a:	bf6080e7          	jalr	-1034(ra) # 8000648c <release>
}
    8000389e:	60e2                	ld	ra,24(sp)
    800038a0:	6442                	ld	s0,16(sp)
    800038a2:	64a2                	ld	s1,8(sp)
    800038a4:	6902                	ld	s2,0(sp)
    800038a6:	6105                	addi	sp,sp,32
    800038a8:	8082                	ret

00000000800038aa <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038aa:	1101                	addi	sp,sp,-32
    800038ac:	ec06                	sd	ra,24(sp)
    800038ae:	e822                	sd	s0,16(sp)
    800038b0:	e426                	sd	s1,8(sp)
    800038b2:	e04a                	sd	s2,0(sp)
    800038b4:	1000                	addi	s0,sp,32
    800038b6:	84aa                	mv	s1,a0
    800038b8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038ba:	00005597          	auipc	a1,0x5
    800038be:	d1e58593          	addi	a1,a1,-738 # 800085d8 <syscalls+0x238>
    800038c2:	0521                	addi	a0,a0,8
    800038c4:	00003097          	auipc	ra,0x3
    800038c8:	a84080e7          	jalr	-1404(ra) # 80006348 <initlock>
  lk->name = name;
    800038cc:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038d0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038d4:	0204a423          	sw	zero,40(s1)
}
    800038d8:	60e2                	ld	ra,24(sp)
    800038da:	6442                	ld	s0,16(sp)
    800038dc:	64a2                	ld	s1,8(sp)
    800038de:	6902                	ld	s2,0(sp)
    800038e0:	6105                	addi	sp,sp,32
    800038e2:	8082                	ret

00000000800038e4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
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
    800038fc:	ae0080e7          	jalr	-1312(ra) # 800063d8 <acquire>
  while (lk->locked) {
    80003900:	409c                	lw	a5,0(s1)
    80003902:	cb89                	beqz	a5,80003914 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003904:	85ca                	mv	a1,s2
    80003906:	8526                	mv	a0,s1
    80003908:	ffffe097          	auipc	ra,0xffffe
    8000390c:	be6080e7          	jalr	-1050(ra) # 800014ee <sleep>
  while (lk->locked) {
    80003910:	409c                	lw	a5,0(s1)
    80003912:	fbed                	bnez	a5,80003904 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003914:	4785                	li	a5,1
    80003916:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003918:	ffffd097          	auipc	ra,0xffffd
    8000391c:	512080e7          	jalr	1298(ra) # 80000e2a <myproc>
    80003920:	591c                	lw	a5,48(a0)
    80003922:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003924:	854a                	mv	a0,s2
    80003926:	00003097          	auipc	ra,0x3
    8000392a:	b66080e7          	jalr	-1178(ra) # 8000648c <release>
}
    8000392e:	60e2                	ld	ra,24(sp)
    80003930:	6442                	ld	s0,16(sp)
    80003932:	64a2                	ld	s1,8(sp)
    80003934:	6902                	ld	s2,0(sp)
    80003936:	6105                	addi	sp,sp,32
    80003938:	8082                	ret

000000008000393a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000393a:	1101                	addi	sp,sp,-32
    8000393c:	ec06                	sd	ra,24(sp)
    8000393e:	e822                	sd	s0,16(sp)
    80003940:	e426                	sd	s1,8(sp)
    80003942:	e04a                	sd	s2,0(sp)
    80003944:	1000                	addi	s0,sp,32
    80003946:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003948:	00850913          	addi	s2,a0,8
    8000394c:	854a                	mv	a0,s2
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	a8a080e7          	jalr	-1398(ra) # 800063d8 <acquire>
  lk->locked = 0;
    80003956:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000395a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000395e:	8526                	mv	a0,s1
    80003960:	ffffe097          	auipc	ra,0xffffe
    80003964:	d1a080e7          	jalr	-742(ra) # 8000167a <wakeup>
  release(&lk->lk);
    80003968:	854a                	mv	a0,s2
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	b22080e7          	jalr	-1246(ra) # 8000648c <release>
}
    80003972:	60e2                	ld	ra,24(sp)
    80003974:	6442                	ld	s0,16(sp)
    80003976:	64a2                	ld	s1,8(sp)
    80003978:	6902                	ld	s2,0(sp)
    8000397a:	6105                	addi	sp,sp,32
    8000397c:	8082                	ret

000000008000397e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000397e:	7179                	addi	sp,sp,-48
    80003980:	f406                	sd	ra,40(sp)
    80003982:	f022                	sd	s0,32(sp)
    80003984:	ec26                	sd	s1,24(sp)
    80003986:	e84a                	sd	s2,16(sp)
    80003988:	e44e                	sd	s3,8(sp)
    8000398a:	1800                	addi	s0,sp,48
    8000398c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000398e:	00850913          	addi	s2,a0,8
    80003992:	854a                	mv	a0,s2
    80003994:	00003097          	auipc	ra,0x3
    80003998:	a44080e7          	jalr	-1468(ra) # 800063d8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000399c:	409c                	lw	a5,0(s1)
    8000399e:	ef99                	bnez	a5,800039bc <holdingsleep+0x3e>
    800039a0:	4481                	li	s1,0
  release(&lk->lk);
    800039a2:	854a                	mv	a0,s2
    800039a4:	00003097          	auipc	ra,0x3
    800039a8:	ae8080e7          	jalr	-1304(ra) # 8000648c <release>
  return r;
}
    800039ac:	8526                	mv	a0,s1
    800039ae:	70a2                	ld	ra,40(sp)
    800039b0:	7402                	ld	s0,32(sp)
    800039b2:	64e2                	ld	s1,24(sp)
    800039b4:	6942                	ld	s2,16(sp)
    800039b6:	69a2                	ld	s3,8(sp)
    800039b8:	6145                	addi	sp,sp,48
    800039ba:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039bc:	0284a983          	lw	s3,40(s1)
    800039c0:	ffffd097          	auipc	ra,0xffffd
    800039c4:	46a080e7          	jalr	1130(ra) # 80000e2a <myproc>
    800039c8:	5904                	lw	s1,48(a0)
    800039ca:	413484b3          	sub	s1,s1,s3
    800039ce:	0014b493          	seqz	s1,s1
    800039d2:	bfc1                	j	800039a2 <holdingsleep+0x24>

00000000800039d4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039d4:	1141                	addi	sp,sp,-16
    800039d6:	e406                	sd	ra,8(sp)
    800039d8:	e022                	sd	s0,0(sp)
    800039da:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039dc:	00005597          	auipc	a1,0x5
    800039e0:	c0c58593          	addi	a1,a1,-1012 # 800085e8 <syscalls+0x248>
    800039e4:	00023517          	auipc	a0,0x23
    800039e8:	78450513          	addi	a0,a0,1924 # 80027168 <ftable>
    800039ec:	00003097          	auipc	ra,0x3
    800039f0:	95c080e7          	jalr	-1700(ra) # 80006348 <initlock>
}
    800039f4:	60a2                	ld	ra,8(sp)
    800039f6:	6402                	ld	s0,0(sp)
    800039f8:	0141                	addi	sp,sp,16
    800039fa:	8082                	ret

00000000800039fc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039fc:	1101                	addi	sp,sp,-32
    800039fe:	ec06                	sd	ra,24(sp)
    80003a00:	e822                	sd	s0,16(sp)
    80003a02:	e426                	sd	s1,8(sp)
    80003a04:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a06:	00023517          	auipc	a0,0x23
    80003a0a:	76250513          	addi	a0,a0,1890 # 80027168 <ftable>
    80003a0e:	00003097          	auipc	ra,0x3
    80003a12:	9ca080e7          	jalr	-1590(ra) # 800063d8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a16:	00023497          	auipc	s1,0x23
    80003a1a:	76a48493          	addi	s1,s1,1898 # 80027180 <ftable+0x18>
    80003a1e:	00024717          	auipc	a4,0x24
    80003a22:	70270713          	addi	a4,a4,1794 # 80028120 <ftable+0xfb8>
    if(f->ref == 0){
    80003a26:	40dc                	lw	a5,4(s1)
    80003a28:	cf99                	beqz	a5,80003a46 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a2a:	02848493          	addi	s1,s1,40
    80003a2e:	fee49ce3          	bne	s1,a4,80003a26 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a32:	00023517          	auipc	a0,0x23
    80003a36:	73650513          	addi	a0,a0,1846 # 80027168 <ftable>
    80003a3a:	00003097          	auipc	ra,0x3
    80003a3e:	a52080e7          	jalr	-1454(ra) # 8000648c <release>
  return 0;
    80003a42:	4481                	li	s1,0
    80003a44:	a819                	j	80003a5a <filealloc+0x5e>
      f->ref = 1;
    80003a46:	4785                	li	a5,1
    80003a48:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a4a:	00023517          	auipc	a0,0x23
    80003a4e:	71e50513          	addi	a0,a0,1822 # 80027168 <ftable>
    80003a52:	00003097          	auipc	ra,0x3
    80003a56:	a3a080e7          	jalr	-1478(ra) # 8000648c <release>
}
    80003a5a:	8526                	mv	a0,s1
    80003a5c:	60e2                	ld	ra,24(sp)
    80003a5e:	6442                	ld	s0,16(sp)
    80003a60:	64a2                	ld	s1,8(sp)
    80003a62:	6105                	addi	sp,sp,32
    80003a64:	8082                	ret

0000000080003a66 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a66:	1101                	addi	sp,sp,-32
    80003a68:	ec06                	sd	ra,24(sp)
    80003a6a:	e822                	sd	s0,16(sp)
    80003a6c:	e426                	sd	s1,8(sp)
    80003a6e:	1000                	addi	s0,sp,32
    80003a70:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a72:	00023517          	auipc	a0,0x23
    80003a76:	6f650513          	addi	a0,a0,1782 # 80027168 <ftable>
    80003a7a:	00003097          	auipc	ra,0x3
    80003a7e:	95e080e7          	jalr	-1698(ra) # 800063d8 <acquire>
  if(f->ref < 1)
    80003a82:	40dc                	lw	a5,4(s1)
    80003a84:	02f05263          	blez	a5,80003aa8 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a88:	2785                	addiw	a5,a5,1
    80003a8a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a8c:	00023517          	auipc	a0,0x23
    80003a90:	6dc50513          	addi	a0,a0,1756 # 80027168 <ftable>
    80003a94:	00003097          	auipc	ra,0x3
    80003a98:	9f8080e7          	jalr	-1544(ra) # 8000648c <release>
  return f;
}
    80003a9c:	8526                	mv	a0,s1
    80003a9e:	60e2                	ld	ra,24(sp)
    80003aa0:	6442                	ld	s0,16(sp)
    80003aa2:	64a2                	ld	s1,8(sp)
    80003aa4:	6105                	addi	sp,sp,32
    80003aa6:	8082                	ret
    panic("filedup");
    80003aa8:	00005517          	auipc	a0,0x5
    80003aac:	b4850513          	addi	a0,a0,-1208 # 800085f0 <syscalls+0x250>
    80003ab0:	00002097          	auipc	ra,0x2
    80003ab4:	3f0080e7          	jalr	1008(ra) # 80005ea0 <panic>

0000000080003ab8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ab8:	7139                	addi	sp,sp,-64
    80003aba:	fc06                	sd	ra,56(sp)
    80003abc:	f822                	sd	s0,48(sp)
    80003abe:	f426                	sd	s1,40(sp)
    80003ac0:	f04a                	sd	s2,32(sp)
    80003ac2:	ec4e                	sd	s3,24(sp)
    80003ac4:	e852                	sd	s4,16(sp)
    80003ac6:	e456                	sd	s5,8(sp)
    80003ac8:	0080                	addi	s0,sp,64
    80003aca:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003acc:	00023517          	auipc	a0,0x23
    80003ad0:	69c50513          	addi	a0,a0,1692 # 80027168 <ftable>
    80003ad4:	00003097          	auipc	ra,0x3
    80003ad8:	904080e7          	jalr	-1788(ra) # 800063d8 <acquire>
  if(f->ref < 1)
    80003adc:	40dc                	lw	a5,4(s1)
    80003ade:	06f05163          	blez	a5,80003b40 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ae2:	37fd                	addiw	a5,a5,-1
    80003ae4:	0007871b          	sext.w	a4,a5
    80003ae8:	c0dc                	sw	a5,4(s1)
    80003aea:	06e04363          	bgtz	a4,80003b50 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003aee:	0004a903          	lw	s2,0(s1)
    80003af2:	0094ca83          	lbu	s5,9(s1)
    80003af6:	0104ba03          	ld	s4,16(s1)
    80003afa:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003afe:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b02:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b06:	00023517          	auipc	a0,0x23
    80003b0a:	66250513          	addi	a0,a0,1634 # 80027168 <ftable>
    80003b0e:	00003097          	auipc	ra,0x3
    80003b12:	97e080e7          	jalr	-1666(ra) # 8000648c <release>

  if(ff.type == FD_PIPE){
    80003b16:	4785                	li	a5,1
    80003b18:	04f90d63          	beq	s2,a5,80003b72 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b1c:	3979                	addiw	s2,s2,-2
    80003b1e:	4785                	li	a5,1
    80003b20:	0527e063          	bltu	a5,s2,80003b60 <fileclose+0xa8>
    begin_op();
    80003b24:	00000097          	auipc	ra,0x0
    80003b28:	acc080e7          	jalr	-1332(ra) # 800035f0 <begin_op>
    iput(ff.ip);
    80003b2c:	854e                	mv	a0,s3
    80003b2e:	fffff097          	auipc	ra,0xfffff
    80003b32:	2a0080e7          	jalr	672(ra) # 80002dce <iput>
    end_op();
    80003b36:	00000097          	auipc	ra,0x0
    80003b3a:	b38080e7          	jalr	-1224(ra) # 8000366e <end_op>
    80003b3e:	a00d                	j	80003b60 <fileclose+0xa8>
    panic("fileclose");
    80003b40:	00005517          	auipc	a0,0x5
    80003b44:	ab850513          	addi	a0,a0,-1352 # 800085f8 <syscalls+0x258>
    80003b48:	00002097          	auipc	ra,0x2
    80003b4c:	358080e7          	jalr	856(ra) # 80005ea0 <panic>
    release(&ftable.lock);
    80003b50:	00023517          	auipc	a0,0x23
    80003b54:	61850513          	addi	a0,a0,1560 # 80027168 <ftable>
    80003b58:	00003097          	auipc	ra,0x3
    80003b5c:	934080e7          	jalr	-1740(ra) # 8000648c <release>
  }
}
    80003b60:	70e2                	ld	ra,56(sp)
    80003b62:	7442                	ld	s0,48(sp)
    80003b64:	74a2                	ld	s1,40(sp)
    80003b66:	7902                	ld	s2,32(sp)
    80003b68:	69e2                	ld	s3,24(sp)
    80003b6a:	6a42                	ld	s4,16(sp)
    80003b6c:	6aa2                	ld	s5,8(sp)
    80003b6e:	6121                	addi	sp,sp,64
    80003b70:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b72:	85d6                	mv	a1,s5
    80003b74:	8552                	mv	a0,s4
    80003b76:	00000097          	auipc	ra,0x0
    80003b7a:	34c080e7          	jalr	844(ra) # 80003ec2 <pipeclose>
    80003b7e:	b7cd                	j	80003b60 <fileclose+0xa8>

0000000080003b80 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b80:	715d                	addi	sp,sp,-80
    80003b82:	e486                	sd	ra,72(sp)
    80003b84:	e0a2                	sd	s0,64(sp)
    80003b86:	fc26                	sd	s1,56(sp)
    80003b88:	f84a                	sd	s2,48(sp)
    80003b8a:	f44e                	sd	s3,40(sp)
    80003b8c:	0880                	addi	s0,sp,80
    80003b8e:	84aa                	mv	s1,a0
    80003b90:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b92:	ffffd097          	auipc	ra,0xffffd
    80003b96:	298080e7          	jalr	664(ra) # 80000e2a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b9a:	409c                	lw	a5,0(s1)
    80003b9c:	37f9                	addiw	a5,a5,-2
    80003b9e:	4705                	li	a4,1
    80003ba0:	04f76763          	bltu	a4,a5,80003bee <filestat+0x6e>
    80003ba4:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ba6:	6c88                	ld	a0,24(s1)
    80003ba8:	fffff097          	auipc	ra,0xfffff
    80003bac:	06c080e7          	jalr	108(ra) # 80002c14 <ilock>
    stati(f->ip, &st);
    80003bb0:	fb840593          	addi	a1,s0,-72
    80003bb4:	6c88                	ld	a0,24(s1)
    80003bb6:	fffff097          	auipc	ra,0xfffff
    80003bba:	2e8080e7          	jalr	744(ra) # 80002e9e <stati>
    iunlock(f->ip);
    80003bbe:	6c88                	ld	a0,24(s1)
    80003bc0:	fffff097          	auipc	ra,0xfffff
    80003bc4:	116080e7          	jalr	278(ra) # 80002cd6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bc8:	46e1                	li	a3,24
    80003bca:	fb840613          	addi	a2,s0,-72
    80003bce:	85ce                	mv	a1,s3
    80003bd0:	05093503          	ld	a0,80(s2)
    80003bd4:	ffffd097          	auipc	ra,0xffffd
    80003bd8:	f1a080e7          	jalr	-230(ra) # 80000aee <copyout>
    80003bdc:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003be0:	60a6                	ld	ra,72(sp)
    80003be2:	6406                	ld	s0,64(sp)
    80003be4:	74e2                	ld	s1,56(sp)
    80003be6:	7942                	ld	s2,48(sp)
    80003be8:	79a2                	ld	s3,40(sp)
    80003bea:	6161                	addi	sp,sp,80
    80003bec:	8082                	ret
  return -1;
    80003bee:	557d                	li	a0,-1
    80003bf0:	bfc5                	j	80003be0 <filestat+0x60>

0000000080003bf2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bf2:	7179                	addi	sp,sp,-48
    80003bf4:	f406                	sd	ra,40(sp)
    80003bf6:	f022                	sd	s0,32(sp)
    80003bf8:	ec26                	sd	s1,24(sp)
    80003bfa:	e84a                	sd	s2,16(sp)
    80003bfc:	e44e                	sd	s3,8(sp)
    80003bfe:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c00:	00854783          	lbu	a5,8(a0)
    80003c04:	c3d5                	beqz	a5,80003ca8 <fileread+0xb6>
    80003c06:	84aa                	mv	s1,a0
    80003c08:	89ae                	mv	s3,a1
    80003c0a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c0c:	411c                	lw	a5,0(a0)
    80003c0e:	4705                	li	a4,1
    80003c10:	04e78963          	beq	a5,a4,80003c62 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c14:	470d                	li	a4,3
    80003c16:	04e78d63          	beq	a5,a4,80003c70 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c1a:	4709                	li	a4,2
    80003c1c:	06e79e63          	bne	a5,a4,80003c98 <fileread+0xa6>
    ilock(f->ip);
    80003c20:	6d08                	ld	a0,24(a0)
    80003c22:	fffff097          	auipc	ra,0xfffff
    80003c26:	ff2080e7          	jalr	-14(ra) # 80002c14 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c2a:	874a                	mv	a4,s2
    80003c2c:	5094                	lw	a3,32(s1)
    80003c2e:	864e                	mv	a2,s3
    80003c30:	4585                	li	a1,1
    80003c32:	6c88                	ld	a0,24(s1)
    80003c34:	fffff097          	auipc	ra,0xfffff
    80003c38:	294080e7          	jalr	660(ra) # 80002ec8 <readi>
    80003c3c:	892a                	mv	s2,a0
    80003c3e:	00a05563          	blez	a0,80003c48 <fileread+0x56>
      f->off += r;
    80003c42:	509c                	lw	a5,32(s1)
    80003c44:	9fa9                	addw	a5,a5,a0
    80003c46:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c48:	6c88                	ld	a0,24(s1)
    80003c4a:	fffff097          	auipc	ra,0xfffff
    80003c4e:	08c080e7          	jalr	140(ra) # 80002cd6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c52:	854a                	mv	a0,s2
    80003c54:	70a2                	ld	ra,40(sp)
    80003c56:	7402                	ld	s0,32(sp)
    80003c58:	64e2                	ld	s1,24(sp)
    80003c5a:	6942                	ld	s2,16(sp)
    80003c5c:	69a2                	ld	s3,8(sp)
    80003c5e:	6145                	addi	sp,sp,48
    80003c60:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c62:	6908                	ld	a0,16(a0)
    80003c64:	00000097          	auipc	ra,0x0
    80003c68:	3c0080e7          	jalr	960(ra) # 80004024 <piperead>
    80003c6c:	892a                	mv	s2,a0
    80003c6e:	b7d5                	j	80003c52 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c70:	02451783          	lh	a5,36(a0)
    80003c74:	03079693          	slli	a3,a5,0x30
    80003c78:	92c1                	srli	a3,a3,0x30
    80003c7a:	4725                	li	a4,9
    80003c7c:	02d76863          	bltu	a4,a3,80003cac <fileread+0xba>
    80003c80:	0792                	slli	a5,a5,0x4
    80003c82:	00023717          	auipc	a4,0x23
    80003c86:	44670713          	addi	a4,a4,1094 # 800270c8 <devsw>
    80003c8a:	97ba                	add	a5,a5,a4
    80003c8c:	639c                	ld	a5,0(a5)
    80003c8e:	c38d                	beqz	a5,80003cb0 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c90:	4505                	li	a0,1
    80003c92:	9782                	jalr	a5
    80003c94:	892a                	mv	s2,a0
    80003c96:	bf75                	j	80003c52 <fileread+0x60>
    panic("fileread");
    80003c98:	00005517          	auipc	a0,0x5
    80003c9c:	97050513          	addi	a0,a0,-1680 # 80008608 <syscalls+0x268>
    80003ca0:	00002097          	auipc	ra,0x2
    80003ca4:	200080e7          	jalr	512(ra) # 80005ea0 <panic>
    return -1;
    80003ca8:	597d                	li	s2,-1
    80003caa:	b765                	j	80003c52 <fileread+0x60>
      return -1;
    80003cac:	597d                	li	s2,-1
    80003cae:	b755                	j	80003c52 <fileread+0x60>
    80003cb0:	597d                	li	s2,-1
    80003cb2:	b745                	j	80003c52 <fileread+0x60>

0000000080003cb4 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003cb4:	715d                	addi	sp,sp,-80
    80003cb6:	e486                	sd	ra,72(sp)
    80003cb8:	e0a2                	sd	s0,64(sp)
    80003cba:	fc26                	sd	s1,56(sp)
    80003cbc:	f84a                	sd	s2,48(sp)
    80003cbe:	f44e                	sd	s3,40(sp)
    80003cc0:	f052                	sd	s4,32(sp)
    80003cc2:	ec56                	sd	s5,24(sp)
    80003cc4:	e85a                	sd	s6,16(sp)
    80003cc6:	e45e                	sd	s7,8(sp)
    80003cc8:	e062                	sd	s8,0(sp)
    80003cca:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003ccc:	00954783          	lbu	a5,9(a0)
    80003cd0:	10078663          	beqz	a5,80003ddc <filewrite+0x128>
    80003cd4:	892a                	mv	s2,a0
    80003cd6:	8b2e                	mv	s6,a1
    80003cd8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cda:	411c                	lw	a5,0(a0)
    80003cdc:	4705                	li	a4,1
    80003cde:	02e78263          	beq	a5,a4,80003d02 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ce2:	470d                	li	a4,3
    80003ce4:	02e78663          	beq	a5,a4,80003d10 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ce8:	4709                	li	a4,2
    80003cea:	0ee79163          	bne	a5,a4,80003dcc <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cee:	0ac05d63          	blez	a2,80003da8 <filewrite+0xf4>
    int i = 0;
    80003cf2:	4981                	li	s3,0
    80003cf4:	6b85                	lui	s7,0x1
    80003cf6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cfa:	6c05                	lui	s8,0x1
    80003cfc:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d00:	a861                	j	80003d98 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d02:	6908                	ld	a0,16(a0)
    80003d04:	00000097          	auipc	ra,0x0
    80003d08:	22e080e7          	jalr	558(ra) # 80003f32 <pipewrite>
    80003d0c:	8a2a                	mv	s4,a0
    80003d0e:	a045                	j	80003dae <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d10:	02451783          	lh	a5,36(a0)
    80003d14:	03079693          	slli	a3,a5,0x30
    80003d18:	92c1                	srli	a3,a3,0x30
    80003d1a:	4725                	li	a4,9
    80003d1c:	0cd76263          	bltu	a4,a3,80003de0 <filewrite+0x12c>
    80003d20:	0792                	slli	a5,a5,0x4
    80003d22:	00023717          	auipc	a4,0x23
    80003d26:	3a670713          	addi	a4,a4,934 # 800270c8 <devsw>
    80003d2a:	97ba                	add	a5,a5,a4
    80003d2c:	679c                	ld	a5,8(a5)
    80003d2e:	cbdd                	beqz	a5,80003de4 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d30:	4505                	li	a0,1
    80003d32:	9782                	jalr	a5
    80003d34:	8a2a                	mv	s4,a0
    80003d36:	a8a5                	j	80003dae <filewrite+0xfa>
    80003d38:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d3c:	00000097          	auipc	ra,0x0
    80003d40:	8b4080e7          	jalr	-1868(ra) # 800035f0 <begin_op>
      ilock(f->ip);
    80003d44:	01893503          	ld	a0,24(s2)
    80003d48:	fffff097          	auipc	ra,0xfffff
    80003d4c:	ecc080e7          	jalr	-308(ra) # 80002c14 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d50:	8756                	mv	a4,s5
    80003d52:	02092683          	lw	a3,32(s2)
    80003d56:	01698633          	add	a2,s3,s6
    80003d5a:	4585                	li	a1,1
    80003d5c:	01893503          	ld	a0,24(s2)
    80003d60:	fffff097          	auipc	ra,0xfffff
    80003d64:	260080e7          	jalr	608(ra) # 80002fc0 <writei>
    80003d68:	84aa                	mv	s1,a0
    80003d6a:	00a05763          	blez	a0,80003d78 <filewrite+0xc4>
        f->off += r;
    80003d6e:	02092783          	lw	a5,32(s2)
    80003d72:	9fa9                	addw	a5,a5,a0
    80003d74:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d78:	01893503          	ld	a0,24(s2)
    80003d7c:	fffff097          	auipc	ra,0xfffff
    80003d80:	f5a080e7          	jalr	-166(ra) # 80002cd6 <iunlock>
      end_op();
    80003d84:	00000097          	auipc	ra,0x0
    80003d88:	8ea080e7          	jalr	-1814(ra) # 8000366e <end_op>

      if(r != n1){
    80003d8c:	009a9f63          	bne	s5,s1,80003daa <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d90:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d94:	0149db63          	bge	s3,s4,80003daa <filewrite+0xf6>
      int n1 = n - i;
    80003d98:	413a04bb          	subw	s1,s4,s3
    80003d9c:	0004879b          	sext.w	a5,s1
    80003da0:	f8fbdce3          	bge	s7,a5,80003d38 <filewrite+0x84>
    80003da4:	84e2                	mv	s1,s8
    80003da6:	bf49                	j	80003d38 <filewrite+0x84>
    int i = 0;
    80003da8:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003daa:	013a1f63          	bne	s4,s3,80003dc8 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dae:	8552                	mv	a0,s4
    80003db0:	60a6                	ld	ra,72(sp)
    80003db2:	6406                	ld	s0,64(sp)
    80003db4:	74e2                	ld	s1,56(sp)
    80003db6:	7942                	ld	s2,48(sp)
    80003db8:	79a2                	ld	s3,40(sp)
    80003dba:	7a02                	ld	s4,32(sp)
    80003dbc:	6ae2                	ld	s5,24(sp)
    80003dbe:	6b42                	ld	s6,16(sp)
    80003dc0:	6ba2                	ld	s7,8(sp)
    80003dc2:	6c02                	ld	s8,0(sp)
    80003dc4:	6161                	addi	sp,sp,80
    80003dc6:	8082                	ret
    ret = (i == n ? n : -1);
    80003dc8:	5a7d                	li	s4,-1
    80003dca:	b7d5                	j	80003dae <filewrite+0xfa>
    panic("filewrite");
    80003dcc:	00005517          	auipc	a0,0x5
    80003dd0:	84c50513          	addi	a0,a0,-1972 # 80008618 <syscalls+0x278>
    80003dd4:	00002097          	auipc	ra,0x2
    80003dd8:	0cc080e7          	jalr	204(ra) # 80005ea0 <panic>
    return -1;
    80003ddc:	5a7d                	li	s4,-1
    80003dde:	bfc1                	j	80003dae <filewrite+0xfa>
      return -1;
    80003de0:	5a7d                	li	s4,-1
    80003de2:	b7f1                	j	80003dae <filewrite+0xfa>
    80003de4:	5a7d                	li	s4,-1
    80003de6:	b7e1                	j	80003dae <filewrite+0xfa>

0000000080003de8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003de8:	7179                	addi	sp,sp,-48
    80003dea:	f406                	sd	ra,40(sp)
    80003dec:	f022                	sd	s0,32(sp)
    80003dee:	ec26                	sd	s1,24(sp)
    80003df0:	e84a                	sd	s2,16(sp)
    80003df2:	e44e                	sd	s3,8(sp)
    80003df4:	e052                	sd	s4,0(sp)
    80003df6:	1800                	addi	s0,sp,48
    80003df8:	84aa                	mv	s1,a0
    80003dfa:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dfc:	0005b023          	sd	zero,0(a1)
    80003e00:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e04:	00000097          	auipc	ra,0x0
    80003e08:	bf8080e7          	jalr	-1032(ra) # 800039fc <filealloc>
    80003e0c:	e088                	sd	a0,0(s1)
    80003e0e:	c551                	beqz	a0,80003e9a <pipealloc+0xb2>
    80003e10:	00000097          	auipc	ra,0x0
    80003e14:	bec080e7          	jalr	-1044(ra) # 800039fc <filealloc>
    80003e18:	00aa3023          	sd	a0,0(s4)
    80003e1c:	c92d                	beqz	a0,80003e8e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e1e:	ffffc097          	auipc	ra,0xffffc
    80003e22:	2fc080e7          	jalr	764(ra) # 8000011a <kalloc>
    80003e26:	892a                	mv	s2,a0
    80003e28:	c125                	beqz	a0,80003e88 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e2a:	4985                	li	s3,1
    80003e2c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e30:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e34:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e38:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e3c:	00004597          	auipc	a1,0x4
    80003e40:	7ec58593          	addi	a1,a1,2028 # 80008628 <syscalls+0x288>
    80003e44:	00002097          	auipc	ra,0x2
    80003e48:	504080e7          	jalr	1284(ra) # 80006348 <initlock>
  (*f0)->type = FD_PIPE;
    80003e4c:	609c                	ld	a5,0(s1)
    80003e4e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e52:	609c                	ld	a5,0(s1)
    80003e54:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e58:	609c                	ld	a5,0(s1)
    80003e5a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e5e:	609c                	ld	a5,0(s1)
    80003e60:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e64:	000a3783          	ld	a5,0(s4)
    80003e68:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e6c:	000a3783          	ld	a5,0(s4)
    80003e70:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e74:	000a3783          	ld	a5,0(s4)
    80003e78:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e7c:	000a3783          	ld	a5,0(s4)
    80003e80:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e84:	4501                	li	a0,0
    80003e86:	a025                	j	80003eae <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e88:	6088                	ld	a0,0(s1)
    80003e8a:	e501                	bnez	a0,80003e92 <pipealloc+0xaa>
    80003e8c:	a039                	j	80003e9a <pipealloc+0xb2>
    80003e8e:	6088                	ld	a0,0(s1)
    80003e90:	c51d                	beqz	a0,80003ebe <pipealloc+0xd6>
    fileclose(*f0);
    80003e92:	00000097          	auipc	ra,0x0
    80003e96:	c26080e7          	jalr	-986(ra) # 80003ab8 <fileclose>
  if(*f1)
    80003e9a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e9e:	557d                	li	a0,-1
  if(*f1)
    80003ea0:	c799                	beqz	a5,80003eae <pipealloc+0xc6>
    fileclose(*f1);
    80003ea2:	853e                	mv	a0,a5
    80003ea4:	00000097          	auipc	ra,0x0
    80003ea8:	c14080e7          	jalr	-1004(ra) # 80003ab8 <fileclose>
  return -1;
    80003eac:	557d                	li	a0,-1
}
    80003eae:	70a2                	ld	ra,40(sp)
    80003eb0:	7402                	ld	s0,32(sp)
    80003eb2:	64e2                	ld	s1,24(sp)
    80003eb4:	6942                	ld	s2,16(sp)
    80003eb6:	69a2                	ld	s3,8(sp)
    80003eb8:	6a02                	ld	s4,0(sp)
    80003eba:	6145                	addi	sp,sp,48
    80003ebc:	8082                	ret
  return -1;
    80003ebe:	557d                	li	a0,-1
    80003ec0:	b7fd                	j	80003eae <pipealloc+0xc6>

0000000080003ec2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ec2:	1101                	addi	sp,sp,-32
    80003ec4:	ec06                	sd	ra,24(sp)
    80003ec6:	e822                	sd	s0,16(sp)
    80003ec8:	e426                	sd	s1,8(sp)
    80003eca:	e04a                	sd	s2,0(sp)
    80003ecc:	1000                	addi	s0,sp,32
    80003ece:	84aa                	mv	s1,a0
    80003ed0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ed2:	00002097          	auipc	ra,0x2
    80003ed6:	506080e7          	jalr	1286(ra) # 800063d8 <acquire>
  if(writable){
    80003eda:	02090d63          	beqz	s2,80003f14 <pipeclose+0x52>
    pi->writeopen = 0;
    80003ede:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ee2:	21848513          	addi	a0,s1,536
    80003ee6:	ffffd097          	auipc	ra,0xffffd
    80003eea:	794080e7          	jalr	1940(ra) # 8000167a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003eee:	2204b783          	ld	a5,544(s1)
    80003ef2:	eb95                	bnez	a5,80003f26 <pipeclose+0x64>
    release(&pi->lock);
    80003ef4:	8526                	mv	a0,s1
    80003ef6:	00002097          	auipc	ra,0x2
    80003efa:	596080e7          	jalr	1430(ra) # 8000648c <release>
    kfree((char*)pi);
    80003efe:	8526                	mv	a0,s1
    80003f00:	ffffc097          	auipc	ra,0xffffc
    80003f04:	11c080e7          	jalr	284(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f08:	60e2                	ld	ra,24(sp)
    80003f0a:	6442                	ld	s0,16(sp)
    80003f0c:	64a2                	ld	s1,8(sp)
    80003f0e:	6902                	ld	s2,0(sp)
    80003f10:	6105                	addi	sp,sp,32
    80003f12:	8082                	ret
    pi->readopen = 0;
    80003f14:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f18:	21c48513          	addi	a0,s1,540
    80003f1c:	ffffd097          	auipc	ra,0xffffd
    80003f20:	75e080e7          	jalr	1886(ra) # 8000167a <wakeup>
    80003f24:	b7e9                	j	80003eee <pipeclose+0x2c>
    release(&pi->lock);
    80003f26:	8526                	mv	a0,s1
    80003f28:	00002097          	auipc	ra,0x2
    80003f2c:	564080e7          	jalr	1380(ra) # 8000648c <release>
}
    80003f30:	bfe1                	j	80003f08 <pipeclose+0x46>

0000000080003f32 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f32:	711d                	addi	sp,sp,-96
    80003f34:	ec86                	sd	ra,88(sp)
    80003f36:	e8a2                	sd	s0,80(sp)
    80003f38:	e4a6                	sd	s1,72(sp)
    80003f3a:	e0ca                	sd	s2,64(sp)
    80003f3c:	fc4e                	sd	s3,56(sp)
    80003f3e:	f852                	sd	s4,48(sp)
    80003f40:	f456                	sd	s5,40(sp)
    80003f42:	f05a                	sd	s6,32(sp)
    80003f44:	ec5e                	sd	s7,24(sp)
    80003f46:	e862                	sd	s8,16(sp)
    80003f48:	1080                	addi	s0,sp,96
    80003f4a:	84aa                	mv	s1,a0
    80003f4c:	8aae                	mv	s5,a1
    80003f4e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f50:	ffffd097          	auipc	ra,0xffffd
    80003f54:	eda080e7          	jalr	-294(ra) # 80000e2a <myproc>
    80003f58:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f5a:	8526                	mv	a0,s1
    80003f5c:	00002097          	auipc	ra,0x2
    80003f60:	47c080e7          	jalr	1148(ra) # 800063d8 <acquire>
  while(i < n){
    80003f64:	0b405363          	blez	s4,8000400a <pipewrite+0xd8>
  int i = 0;
    80003f68:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f6a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f6c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f70:	21c48b93          	addi	s7,s1,540
    80003f74:	a089                	j	80003fb6 <pipewrite+0x84>
      release(&pi->lock);
    80003f76:	8526                	mv	a0,s1
    80003f78:	00002097          	auipc	ra,0x2
    80003f7c:	514080e7          	jalr	1300(ra) # 8000648c <release>
      return -1;
    80003f80:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f82:	854a                	mv	a0,s2
    80003f84:	60e6                	ld	ra,88(sp)
    80003f86:	6446                	ld	s0,80(sp)
    80003f88:	64a6                	ld	s1,72(sp)
    80003f8a:	6906                	ld	s2,64(sp)
    80003f8c:	79e2                	ld	s3,56(sp)
    80003f8e:	7a42                	ld	s4,48(sp)
    80003f90:	7aa2                	ld	s5,40(sp)
    80003f92:	7b02                	ld	s6,32(sp)
    80003f94:	6be2                	ld	s7,24(sp)
    80003f96:	6c42                	ld	s8,16(sp)
    80003f98:	6125                	addi	sp,sp,96
    80003f9a:	8082                	ret
      wakeup(&pi->nread);
    80003f9c:	8562                	mv	a0,s8
    80003f9e:	ffffd097          	auipc	ra,0xffffd
    80003fa2:	6dc080e7          	jalr	1756(ra) # 8000167a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fa6:	85a6                	mv	a1,s1
    80003fa8:	855e                	mv	a0,s7
    80003faa:	ffffd097          	auipc	ra,0xffffd
    80003fae:	544080e7          	jalr	1348(ra) # 800014ee <sleep>
  while(i < n){
    80003fb2:	05495d63          	bge	s2,s4,8000400c <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003fb6:	2204a783          	lw	a5,544(s1)
    80003fba:	dfd5                	beqz	a5,80003f76 <pipewrite+0x44>
    80003fbc:	0289a783          	lw	a5,40(s3)
    80003fc0:	fbdd                	bnez	a5,80003f76 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fc2:	2184a783          	lw	a5,536(s1)
    80003fc6:	21c4a703          	lw	a4,540(s1)
    80003fca:	2007879b          	addiw	a5,a5,512
    80003fce:	fcf707e3          	beq	a4,a5,80003f9c <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fd2:	4685                	li	a3,1
    80003fd4:	01590633          	add	a2,s2,s5
    80003fd8:	faf40593          	addi	a1,s0,-81
    80003fdc:	0509b503          	ld	a0,80(s3)
    80003fe0:	ffffd097          	auipc	ra,0xffffd
    80003fe4:	b9a080e7          	jalr	-1126(ra) # 80000b7a <copyin>
    80003fe8:	03650263          	beq	a0,s6,8000400c <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fec:	21c4a783          	lw	a5,540(s1)
    80003ff0:	0017871b          	addiw	a4,a5,1
    80003ff4:	20e4ae23          	sw	a4,540(s1)
    80003ff8:	1ff7f793          	andi	a5,a5,511
    80003ffc:	97a6                	add	a5,a5,s1
    80003ffe:	faf44703          	lbu	a4,-81(s0)
    80004002:	00e78c23          	sb	a4,24(a5)
      i++;
    80004006:	2905                	addiw	s2,s2,1
    80004008:	b76d                	j	80003fb2 <pipewrite+0x80>
  int i = 0;
    8000400a:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000400c:	21848513          	addi	a0,s1,536
    80004010:	ffffd097          	auipc	ra,0xffffd
    80004014:	66a080e7          	jalr	1642(ra) # 8000167a <wakeup>
  release(&pi->lock);
    80004018:	8526                	mv	a0,s1
    8000401a:	00002097          	auipc	ra,0x2
    8000401e:	472080e7          	jalr	1138(ra) # 8000648c <release>
  return i;
    80004022:	b785                	j	80003f82 <pipewrite+0x50>

0000000080004024 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004024:	715d                	addi	sp,sp,-80
    80004026:	e486                	sd	ra,72(sp)
    80004028:	e0a2                	sd	s0,64(sp)
    8000402a:	fc26                	sd	s1,56(sp)
    8000402c:	f84a                	sd	s2,48(sp)
    8000402e:	f44e                	sd	s3,40(sp)
    80004030:	f052                	sd	s4,32(sp)
    80004032:	ec56                	sd	s5,24(sp)
    80004034:	e85a                	sd	s6,16(sp)
    80004036:	0880                	addi	s0,sp,80
    80004038:	84aa                	mv	s1,a0
    8000403a:	892e                	mv	s2,a1
    8000403c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000403e:	ffffd097          	auipc	ra,0xffffd
    80004042:	dec080e7          	jalr	-532(ra) # 80000e2a <myproc>
    80004046:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004048:	8526                	mv	a0,s1
    8000404a:	00002097          	auipc	ra,0x2
    8000404e:	38e080e7          	jalr	910(ra) # 800063d8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004052:	2184a703          	lw	a4,536(s1)
    80004056:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000405a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000405e:	02f71463          	bne	a4,a5,80004086 <piperead+0x62>
    80004062:	2244a783          	lw	a5,548(s1)
    80004066:	c385                	beqz	a5,80004086 <piperead+0x62>
    if(pr->killed){
    80004068:	028a2783          	lw	a5,40(s4)
    8000406c:	ebc9                	bnez	a5,800040fe <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000406e:	85a6                	mv	a1,s1
    80004070:	854e                	mv	a0,s3
    80004072:	ffffd097          	auipc	ra,0xffffd
    80004076:	47c080e7          	jalr	1148(ra) # 800014ee <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000407a:	2184a703          	lw	a4,536(s1)
    8000407e:	21c4a783          	lw	a5,540(s1)
    80004082:	fef700e3          	beq	a4,a5,80004062 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004086:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004088:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000408a:	05505463          	blez	s5,800040d2 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    8000408e:	2184a783          	lw	a5,536(s1)
    80004092:	21c4a703          	lw	a4,540(s1)
    80004096:	02f70e63          	beq	a4,a5,800040d2 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000409a:	0017871b          	addiw	a4,a5,1
    8000409e:	20e4ac23          	sw	a4,536(s1)
    800040a2:	1ff7f793          	andi	a5,a5,511
    800040a6:	97a6                	add	a5,a5,s1
    800040a8:	0187c783          	lbu	a5,24(a5)
    800040ac:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040b0:	4685                	li	a3,1
    800040b2:	fbf40613          	addi	a2,s0,-65
    800040b6:	85ca                	mv	a1,s2
    800040b8:	050a3503          	ld	a0,80(s4)
    800040bc:	ffffd097          	auipc	ra,0xffffd
    800040c0:	a32080e7          	jalr	-1486(ra) # 80000aee <copyout>
    800040c4:	01650763          	beq	a0,s6,800040d2 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040c8:	2985                	addiw	s3,s3,1
    800040ca:	0905                	addi	s2,s2,1
    800040cc:	fd3a91e3          	bne	s5,s3,8000408e <piperead+0x6a>
    800040d0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040d2:	21c48513          	addi	a0,s1,540
    800040d6:	ffffd097          	auipc	ra,0xffffd
    800040da:	5a4080e7          	jalr	1444(ra) # 8000167a <wakeup>
  release(&pi->lock);
    800040de:	8526                	mv	a0,s1
    800040e0:	00002097          	auipc	ra,0x2
    800040e4:	3ac080e7          	jalr	940(ra) # 8000648c <release>
  return i;
}
    800040e8:	854e                	mv	a0,s3
    800040ea:	60a6                	ld	ra,72(sp)
    800040ec:	6406                	ld	s0,64(sp)
    800040ee:	74e2                	ld	s1,56(sp)
    800040f0:	7942                	ld	s2,48(sp)
    800040f2:	79a2                	ld	s3,40(sp)
    800040f4:	7a02                	ld	s4,32(sp)
    800040f6:	6ae2                	ld	s5,24(sp)
    800040f8:	6b42                	ld	s6,16(sp)
    800040fa:	6161                	addi	sp,sp,80
    800040fc:	8082                	ret
      release(&pi->lock);
    800040fe:	8526                	mv	a0,s1
    80004100:	00002097          	auipc	ra,0x2
    80004104:	38c080e7          	jalr	908(ra) # 8000648c <release>
      return -1;
    80004108:	59fd                	li	s3,-1
    8000410a:	bff9                	j	800040e8 <piperead+0xc4>

000000008000410c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000410c:	de010113          	addi	sp,sp,-544
    80004110:	20113c23          	sd	ra,536(sp)
    80004114:	20813823          	sd	s0,528(sp)
    80004118:	20913423          	sd	s1,520(sp)
    8000411c:	21213023          	sd	s2,512(sp)
    80004120:	ffce                	sd	s3,504(sp)
    80004122:	fbd2                	sd	s4,496(sp)
    80004124:	f7d6                	sd	s5,488(sp)
    80004126:	f3da                	sd	s6,480(sp)
    80004128:	efde                	sd	s7,472(sp)
    8000412a:	ebe2                	sd	s8,464(sp)
    8000412c:	e7e6                	sd	s9,456(sp)
    8000412e:	e3ea                	sd	s10,448(sp)
    80004130:	ff6e                	sd	s11,440(sp)
    80004132:	1400                	addi	s0,sp,544
    80004134:	892a                	mv	s2,a0
    80004136:	dea43423          	sd	a0,-536(s0)
    8000413a:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000413e:	ffffd097          	auipc	ra,0xffffd
    80004142:	cec080e7          	jalr	-788(ra) # 80000e2a <myproc>
    80004146:	84aa                	mv	s1,a0

  begin_op();
    80004148:	fffff097          	auipc	ra,0xfffff
    8000414c:	4a8080e7          	jalr	1192(ra) # 800035f0 <begin_op>

  if((ip = namei(path)) == 0){
    80004150:	854a                	mv	a0,s2
    80004152:	fffff097          	auipc	ra,0xfffff
    80004156:	27e080e7          	jalr	638(ra) # 800033d0 <namei>
    8000415a:	c93d                	beqz	a0,800041d0 <exec+0xc4>
    8000415c:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000415e:	fffff097          	auipc	ra,0xfffff
    80004162:	ab6080e7          	jalr	-1354(ra) # 80002c14 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004166:	04000713          	li	a4,64
    8000416a:	4681                	li	a3,0
    8000416c:	e5040613          	addi	a2,s0,-432
    80004170:	4581                	li	a1,0
    80004172:	8556                	mv	a0,s5
    80004174:	fffff097          	auipc	ra,0xfffff
    80004178:	d54080e7          	jalr	-684(ra) # 80002ec8 <readi>
    8000417c:	04000793          	li	a5,64
    80004180:	00f51a63          	bne	a0,a5,80004194 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004184:	e5042703          	lw	a4,-432(s0)
    80004188:	464c47b7          	lui	a5,0x464c4
    8000418c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004190:	04f70663          	beq	a4,a5,800041dc <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004194:	8556                	mv	a0,s5
    80004196:	fffff097          	auipc	ra,0xfffff
    8000419a:	ce0080e7          	jalr	-800(ra) # 80002e76 <iunlockput>
    end_op();
    8000419e:	fffff097          	auipc	ra,0xfffff
    800041a2:	4d0080e7          	jalr	1232(ra) # 8000366e <end_op>
  }
  return -1;
    800041a6:	557d                	li	a0,-1
}
    800041a8:	21813083          	ld	ra,536(sp)
    800041ac:	21013403          	ld	s0,528(sp)
    800041b0:	20813483          	ld	s1,520(sp)
    800041b4:	20013903          	ld	s2,512(sp)
    800041b8:	79fe                	ld	s3,504(sp)
    800041ba:	7a5e                	ld	s4,496(sp)
    800041bc:	7abe                	ld	s5,488(sp)
    800041be:	7b1e                	ld	s6,480(sp)
    800041c0:	6bfe                	ld	s7,472(sp)
    800041c2:	6c5e                	ld	s8,464(sp)
    800041c4:	6cbe                	ld	s9,456(sp)
    800041c6:	6d1e                	ld	s10,448(sp)
    800041c8:	7dfa                	ld	s11,440(sp)
    800041ca:	22010113          	addi	sp,sp,544
    800041ce:	8082                	ret
    end_op();
    800041d0:	fffff097          	auipc	ra,0xfffff
    800041d4:	49e080e7          	jalr	1182(ra) # 8000366e <end_op>
    return -1;
    800041d8:	557d                	li	a0,-1
    800041da:	b7f9                	j	800041a8 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800041dc:	8526                	mv	a0,s1
    800041de:	ffffd097          	auipc	ra,0xffffd
    800041e2:	d10080e7          	jalr	-752(ra) # 80000eee <proc_pagetable>
    800041e6:	8b2a                	mv	s6,a0
    800041e8:	d555                	beqz	a0,80004194 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041ea:	e7042783          	lw	a5,-400(s0)
    800041ee:	e8845703          	lhu	a4,-376(s0)
    800041f2:	c735                	beqz	a4,8000425e <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041f4:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041f6:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800041fa:	6a05                	lui	s4,0x1
    800041fc:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004200:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004204:	6d85                	lui	s11,0x1
    80004206:	7d7d                	lui	s10,0xfffff
    80004208:	ac1d                	j	8000443e <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000420a:	00004517          	auipc	a0,0x4
    8000420e:	42650513          	addi	a0,a0,1062 # 80008630 <syscalls+0x290>
    80004212:	00002097          	auipc	ra,0x2
    80004216:	c8e080e7          	jalr	-882(ra) # 80005ea0 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000421a:	874a                	mv	a4,s2
    8000421c:	009c86bb          	addw	a3,s9,s1
    80004220:	4581                	li	a1,0
    80004222:	8556                	mv	a0,s5
    80004224:	fffff097          	auipc	ra,0xfffff
    80004228:	ca4080e7          	jalr	-860(ra) # 80002ec8 <readi>
    8000422c:	2501                	sext.w	a0,a0
    8000422e:	1aa91863          	bne	s2,a0,800043de <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004232:	009d84bb          	addw	s1,s11,s1
    80004236:	013d09bb          	addw	s3,s10,s3
    8000423a:	1f74f263          	bgeu	s1,s7,8000441e <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    8000423e:	02049593          	slli	a1,s1,0x20
    80004242:	9181                	srli	a1,a1,0x20
    80004244:	95e2                	add	a1,a1,s8
    80004246:	855a                	mv	a0,s6
    80004248:	ffffc097          	auipc	ra,0xffffc
    8000424c:	2b8080e7          	jalr	696(ra) # 80000500 <walkaddr>
    80004250:	862a                	mv	a2,a0
    if(pa == 0)
    80004252:	dd45                	beqz	a0,8000420a <exec+0xfe>
      n = PGSIZE;
    80004254:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004256:	fd49f2e3          	bgeu	s3,s4,8000421a <exec+0x10e>
      n = sz - i;
    8000425a:	894e                	mv	s2,s3
    8000425c:	bf7d                	j	8000421a <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000425e:	4481                	li	s1,0
  iunlockput(ip);
    80004260:	8556                	mv	a0,s5
    80004262:	fffff097          	auipc	ra,0xfffff
    80004266:	c14080e7          	jalr	-1004(ra) # 80002e76 <iunlockput>
  end_op();
    8000426a:	fffff097          	auipc	ra,0xfffff
    8000426e:	404080e7          	jalr	1028(ra) # 8000366e <end_op>
  p = myproc();
    80004272:	ffffd097          	auipc	ra,0xffffd
    80004276:	bb8080e7          	jalr	-1096(ra) # 80000e2a <myproc>
    8000427a:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000427c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004280:	6785                	lui	a5,0x1
    80004282:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004284:	97a6                	add	a5,a5,s1
    80004286:	777d                	lui	a4,0xfffff
    80004288:	8ff9                	and	a5,a5,a4
    8000428a:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000428e:	6609                	lui	a2,0x2
    80004290:	963e                	add	a2,a2,a5
    80004292:	85be                	mv	a1,a5
    80004294:	855a                	mv	a0,s6
    80004296:	ffffc097          	auipc	ra,0xffffc
    8000429a:	610080e7          	jalr	1552(ra) # 800008a6 <uvmalloc>
    8000429e:	8c2a                	mv	s8,a0
  ip = 0;
    800042a0:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042a2:	12050e63          	beqz	a0,800043de <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042a6:	75f9                	lui	a1,0xffffe
    800042a8:	95aa                	add	a1,a1,a0
    800042aa:	855a                	mv	a0,s6
    800042ac:	ffffd097          	auipc	ra,0xffffd
    800042b0:	810080e7          	jalr	-2032(ra) # 80000abc <uvmclear>
  stackbase = sp - PGSIZE;
    800042b4:	7afd                	lui	s5,0xfffff
    800042b6:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800042b8:	df043783          	ld	a5,-528(s0)
    800042bc:	6388                	ld	a0,0(a5)
    800042be:	c925                	beqz	a0,8000432e <exec+0x222>
    800042c0:	e9040993          	addi	s3,s0,-368
    800042c4:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042c8:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042ca:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042cc:	ffffc097          	auipc	ra,0xffffc
    800042d0:	02a080e7          	jalr	42(ra) # 800002f6 <strlen>
    800042d4:	0015079b          	addiw	a5,a0,1
    800042d8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042dc:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800042e0:	13596363          	bltu	s2,s5,80004406 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042e4:	df043d83          	ld	s11,-528(s0)
    800042e8:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800042ec:	8552                	mv	a0,s4
    800042ee:	ffffc097          	auipc	ra,0xffffc
    800042f2:	008080e7          	jalr	8(ra) # 800002f6 <strlen>
    800042f6:	0015069b          	addiw	a3,a0,1
    800042fa:	8652                	mv	a2,s4
    800042fc:	85ca                	mv	a1,s2
    800042fe:	855a                	mv	a0,s6
    80004300:	ffffc097          	auipc	ra,0xffffc
    80004304:	7ee080e7          	jalr	2030(ra) # 80000aee <copyout>
    80004308:	10054363          	bltz	a0,8000440e <exec+0x302>
    ustack[argc] = sp;
    8000430c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004310:	0485                	addi	s1,s1,1
    80004312:	008d8793          	addi	a5,s11,8
    80004316:	def43823          	sd	a5,-528(s0)
    8000431a:	008db503          	ld	a0,8(s11)
    8000431e:	c911                	beqz	a0,80004332 <exec+0x226>
    if(argc >= MAXARG)
    80004320:	09a1                	addi	s3,s3,8
    80004322:	fb3c95e3          	bne	s9,s3,800042cc <exec+0x1c0>
  sz = sz1;
    80004326:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000432a:	4a81                	li	s5,0
    8000432c:	a84d                	j	800043de <exec+0x2d2>
  sp = sz;
    8000432e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004330:	4481                	li	s1,0
  ustack[argc] = 0;
    80004332:	00349793          	slli	a5,s1,0x3
    80004336:	f9078793          	addi	a5,a5,-112
    8000433a:	97a2                	add	a5,a5,s0
    8000433c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004340:	00148693          	addi	a3,s1,1
    80004344:	068e                	slli	a3,a3,0x3
    80004346:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000434a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000434e:	01597663          	bgeu	s2,s5,8000435a <exec+0x24e>
  sz = sz1;
    80004352:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004356:	4a81                	li	s5,0
    80004358:	a059                	j	800043de <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000435a:	e9040613          	addi	a2,s0,-368
    8000435e:	85ca                	mv	a1,s2
    80004360:	855a                	mv	a0,s6
    80004362:	ffffc097          	auipc	ra,0xffffc
    80004366:	78c080e7          	jalr	1932(ra) # 80000aee <copyout>
    8000436a:	0a054663          	bltz	a0,80004416 <exec+0x30a>
  p->trapframe->a1 = sp;
    8000436e:	058bb783          	ld	a5,88(s7)
    80004372:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004376:	de843783          	ld	a5,-536(s0)
    8000437a:	0007c703          	lbu	a4,0(a5)
    8000437e:	cf11                	beqz	a4,8000439a <exec+0x28e>
    80004380:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004382:	02f00693          	li	a3,47
    80004386:	a039                	j	80004394 <exec+0x288>
      last = s+1;
    80004388:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000438c:	0785                	addi	a5,a5,1
    8000438e:	fff7c703          	lbu	a4,-1(a5)
    80004392:	c701                	beqz	a4,8000439a <exec+0x28e>
    if(*s == '/')
    80004394:	fed71ce3          	bne	a4,a3,8000438c <exec+0x280>
    80004398:	bfc5                	j	80004388 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000439a:	4641                	li	a2,16
    8000439c:	de843583          	ld	a1,-536(s0)
    800043a0:	158b8513          	addi	a0,s7,344
    800043a4:	ffffc097          	auipc	ra,0xffffc
    800043a8:	f20080e7          	jalr	-224(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    800043ac:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800043b0:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800043b4:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043b8:	058bb783          	ld	a5,88(s7)
    800043bc:	e6843703          	ld	a4,-408(s0)
    800043c0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043c2:	058bb783          	ld	a5,88(s7)
    800043c6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043ca:	85ea                	mv	a1,s10
    800043cc:	ffffd097          	auipc	ra,0xffffd
    800043d0:	bbe080e7          	jalr	-1090(ra) # 80000f8a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043d4:	0004851b          	sext.w	a0,s1
    800043d8:	bbc1                	j	800041a8 <exec+0x9c>
    800043da:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800043de:	df843583          	ld	a1,-520(s0)
    800043e2:	855a                	mv	a0,s6
    800043e4:	ffffd097          	auipc	ra,0xffffd
    800043e8:	ba6080e7          	jalr	-1114(ra) # 80000f8a <proc_freepagetable>
  if(ip){
    800043ec:	da0a94e3          	bnez	s5,80004194 <exec+0x88>
  return -1;
    800043f0:	557d                	li	a0,-1
    800043f2:	bb5d                	j	800041a8 <exec+0x9c>
    800043f4:	de943c23          	sd	s1,-520(s0)
    800043f8:	b7dd                	j	800043de <exec+0x2d2>
    800043fa:	de943c23          	sd	s1,-520(s0)
    800043fe:	b7c5                	j	800043de <exec+0x2d2>
    80004400:	de943c23          	sd	s1,-520(s0)
    80004404:	bfe9                	j	800043de <exec+0x2d2>
  sz = sz1;
    80004406:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000440a:	4a81                	li	s5,0
    8000440c:	bfc9                	j	800043de <exec+0x2d2>
  sz = sz1;
    8000440e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004412:	4a81                	li	s5,0
    80004414:	b7e9                	j	800043de <exec+0x2d2>
  sz = sz1;
    80004416:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000441a:	4a81                	li	s5,0
    8000441c:	b7c9                	j	800043de <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000441e:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004422:	e0843783          	ld	a5,-504(s0)
    80004426:	0017869b          	addiw	a3,a5,1
    8000442a:	e0d43423          	sd	a3,-504(s0)
    8000442e:	e0043783          	ld	a5,-512(s0)
    80004432:	0387879b          	addiw	a5,a5,56
    80004436:	e8845703          	lhu	a4,-376(s0)
    8000443a:	e2e6d3e3          	bge	a3,a4,80004260 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000443e:	2781                	sext.w	a5,a5
    80004440:	e0f43023          	sd	a5,-512(s0)
    80004444:	03800713          	li	a4,56
    80004448:	86be                	mv	a3,a5
    8000444a:	e1840613          	addi	a2,s0,-488
    8000444e:	4581                	li	a1,0
    80004450:	8556                	mv	a0,s5
    80004452:	fffff097          	auipc	ra,0xfffff
    80004456:	a76080e7          	jalr	-1418(ra) # 80002ec8 <readi>
    8000445a:	03800793          	li	a5,56
    8000445e:	f6f51ee3          	bne	a0,a5,800043da <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004462:	e1842783          	lw	a5,-488(s0)
    80004466:	4705                	li	a4,1
    80004468:	fae79de3          	bne	a5,a4,80004422 <exec+0x316>
    if(ph.memsz < ph.filesz)
    8000446c:	e4043603          	ld	a2,-448(s0)
    80004470:	e3843783          	ld	a5,-456(s0)
    80004474:	f8f660e3          	bltu	a2,a5,800043f4 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004478:	e2843783          	ld	a5,-472(s0)
    8000447c:	963e                	add	a2,a2,a5
    8000447e:	f6f66ee3          	bltu	a2,a5,800043fa <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004482:	85a6                	mv	a1,s1
    80004484:	855a                	mv	a0,s6
    80004486:	ffffc097          	auipc	ra,0xffffc
    8000448a:	420080e7          	jalr	1056(ra) # 800008a6 <uvmalloc>
    8000448e:	dea43c23          	sd	a0,-520(s0)
    80004492:	d53d                	beqz	a0,80004400 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    80004494:	e2843c03          	ld	s8,-472(s0)
    80004498:	de043783          	ld	a5,-544(s0)
    8000449c:	00fc77b3          	and	a5,s8,a5
    800044a0:	ff9d                	bnez	a5,800043de <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044a2:	e2042c83          	lw	s9,-480(s0)
    800044a6:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044aa:	f60b8ae3          	beqz	s7,8000441e <exec+0x312>
    800044ae:	89de                	mv	s3,s7
    800044b0:	4481                	li	s1,0
    800044b2:	b371                	j	8000423e <exec+0x132>

00000000800044b4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044b4:	7179                	addi	sp,sp,-48
    800044b6:	f406                	sd	ra,40(sp)
    800044b8:	f022                	sd	s0,32(sp)
    800044ba:	ec26                	sd	s1,24(sp)
    800044bc:	e84a                	sd	s2,16(sp)
    800044be:	1800                	addi	s0,sp,48
    800044c0:	892e                	mv	s2,a1
    800044c2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800044c4:	fdc40593          	addi	a1,s0,-36
    800044c8:	ffffe097          	auipc	ra,0xffffe
    800044cc:	bda080e7          	jalr	-1062(ra) # 800020a2 <argint>
    800044d0:	04054063          	bltz	a0,80004510 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044d4:	fdc42703          	lw	a4,-36(s0)
    800044d8:	47bd                	li	a5,15
    800044da:	02e7ed63          	bltu	a5,a4,80004514 <argfd+0x60>
    800044de:	ffffd097          	auipc	ra,0xffffd
    800044e2:	94c080e7          	jalr	-1716(ra) # 80000e2a <myproc>
    800044e6:	fdc42703          	lw	a4,-36(s0)
    800044ea:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffcadda>
    800044ee:	078e                	slli	a5,a5,0x3
    800044f0:	953e                	add	a0,a0,a5
    800044f2:	611c                	ld	a5,0(a0)
    800044f4:	c395                	beqz	a5,80004518 <argfd+0x64>
    return -1;
  if(pfd)
    800044f6:	00090463          	beqz	s2,800044fe <argfd+0x4a>
    *pfd = fd;
    800044fa:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044fe:	4501                	li	a0,0
  if(pf)
    80004500:	c091                	beqz	s1,80004504 <argfd+0x50>
    *pf = f;
    80004502:	e09c                	sd	a5,0(s1)
}
    80004504:	70a2                	ld	ra,40(sp)
    80004506:	7402                	ld	s0,32(sp)
    80004508:	64e2                	ld	s1,24(sp)
    8000450a:	6942                	ld	s2,16(sp)
    8000450c:	6145                	addi	sp,sp,48
    8000450e:	8082                	ret
    return -1;
    80004510:	557d                	li	a0,-1
    80004512:	bfcd                	j	80004504 <argfd+0x50>
    return -1;
    80004514:	557d                	li	a0,-1
    80004516:	b7fd                	j	80004504 <argfd+0x50>
    80004518:	557d                	li	a0,-1
    8000451a:	b7ed                	j	80004504 <argfd+0x50>

000000008000451c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000451c:	1101                	addi	sp,sp,-32
    8000451e:	ec06                	sd	ra,24(sp)
    80004520:	e822                	sd	s0,16(sp)
    80004522:	e426                	sd	s1,8(sp)
    80004524:	1000                	addi	s0,sp,32
    80004526:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004528:	ffffd097          	auipc	ra,0xffffd
    8000452c:	902080e7          	jalr	-1790(ra) # 80000e2a <myproc>
    80004530:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004532:	0d050793          	addi	a5,a0,208
    80004536:	4501                	li	a0,0
    80004538:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000453a:	6398                	ld	a4,0(a5)
    8000453c:	cb19                	beqz	a4,80004552 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000453e:	2505                	addiw	a0,a0,1
    80004540:	07a1                	addi	a5,a5,8
    80004542:	fed51ce3          	bne	a0,a3,8000453a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004546:	557d                	li	a0,-1
}
    80004548:	60e2                	ld	ra,24(sp)
    8000454a:	6442                	ld	s0,16(sp)
    8000454c:	64a2                	ld	s1,8(sp)
    8000454e:	6105                	addi	sp,sp,32
    80004550:	8082                	ret
      p->ofile[fd] = f;
    80004552:	01a50793          	addi	a5,a0,26
    80004556:	078e                	slli	a5,a5,0x3
    80004558:	963e                	add	a2,a2,a5
    8000455a:	e204                	sd	s1,0(a2)
      return fd;
    8000455c:	b7f5                	j	80004548 <fdalloc+0x2c>

000000008000455e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000455e:	715d                	addi	sp,sp,-80
    80004560:	e486                	sd	ra,72(sp)
    80004562:	e0a2                	sd	s0,64(sp)
    80004564:	fc26                	sd	s1,56(sp)
    80004566:	f84a                	sd	s2,48(sp)
    80004568:	f44e                	sd	s3,40(sp)
    8000456a:	f052                	sd	s4,32(sp)
    8000456c:	ec56                	sd	s5,24(sp)
    8000456e:	0880                	addi	s0,sp,80
    80004570:	89ae                	mv	s3,a1
    80004572:	8ab2                	mv	s5,a2
    80004574:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004576:	fb040593          	addi	a1,s0,-80
    8000457a:	fffff097          	auipc	ra,0xfffff
    8000457e:	e74080e7          	jalr	-396(ra) # 800033ee <nameiparent>
    80004582:	892a                	mv	s2,a0
    80004584:	12050e63          	beqz	a0,800046c0 <create+0x162>
    return 0;

  ilock(dp);
    80004588:	ffffe097          	auipc	ra,0xffffe
    8000458c:	68c080e7          	jalr	1676(ra) # 80002c14 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004590:	4601                	li	a2,0
    80004592:	fb040593          	addi	a1,s0,-80
    80004596:	854a                	mv	a0,s2
    80004598:	fffff097          	auipc	ra,0xfffff
    8000459c:	b60080e7          	jalr	-1184(ra) # 800030f8 <dirlookup>
    800045a0:	84aa                	mv	s1,a0
    800045a2:	c921                	beqz	a0,800045f2 <create+0x94>
    iunlockput(dp);
    800045a4:	854a                	mv	a0,s2
    800045a6:	fffff097          	auipc	ra,0xfffff
    800045aa:	8d0080e7          	jalr	-1840(ra) # 80002e76 <iunlockput>
    ilock(ip);
    800045ae:	8526                	mv	a0,s1
    800045b0:	ffffe097          	auipc	ra,0xffffe
    800045b4:	664080e7          	jalr	1636(ra) # 80002c14 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045b8:	2981                	sext.w	s3,s3
    800045ba:	4789                	li	a5,2
    800045bc:	02f99463          	bne	s3,a5,800045e4 <create+0x86>
    800045c0:	0444d783          	lhu	a5,68(s1)
    800045c4:	37f9                	addiw	a5,a5,-2
    800045c6:	17c2                	slli	a5,a5,0x30
    800045c8:	93c1                	srli	a5,a5,0x30
    800045ca:	4705                	li	a4,1
    800045cc:	00f76c63          	bltu	a4,a5,800045e4 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800045d0:	8526                	mv	a0,s1
    800045d2:	60a6                	ld	ra,72(sp)
    800045d4:	6406                	ld	s0,64(sp)
    800045d6:	74e2                	ld	s1,56(sp)
    800045d8:	7942                	ld	s2,48(sp)
    800045da:	79a2                	ld	s3,40(sp)
    800045dc:	7a02                	ld	s4,32(sp)
    800045de:	6ae2                	ld	s5,24(sp)
    800045e0:	6161                	addi	sp,sp,80
    800045e2:	8082                	ret
    iunlockput(ip);
    800045e4:	8526                	mv	a0,s1
    800045e6:	fffff097          	auipc	ra,0xfffff
    800045ea:	890080e7          	jalr	-1904(ra) # 80002e76 <iunlockput>
    return 0;
    800045ee:	4481                	li	s1,0
    800045f0:	b7c5                	j	800045d0 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045f2:	85ce                	mv	a1,s3
    800045f4:	00092503          	lw	a0,0(s2)
    800045f8:	ffffe097          	auipc	ra,0xffffe
    800045fc:	482080e7          	jalr	1154(ra) # 80002a7a <ialloc>
    80004600:	84aa                	mv	s1,a0
    80004602:	c521                	beqz	a0,8000464a <create+0xec>
  ilock(ip);
    80004604:	ffffe097          	auipc	ra,0xffffe
    80004608:	610080e7          	jalr	1552(ra) # 80002c14 <ilock>
  ip->major = major;
    8000460c:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004610:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004614:	4a05                	li	s4,1
    80004616:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000461a:	8526                	mv	a0,s1
    8000461c:	ffffe097          	auipc	ra,0xffffe
    80004620:	52c080e7          	jalr	1324(ra) # 80002b48 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004624:	2981                	sext.w	s3,s3
    80004626:	03498a63          	beq	s3,s4,8000465a <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000462a:	40d0                	lw	a2,4(s1)
    8000462c:	fb040593          	addi	a1,s0,-80
    80004630:	854a                	mv	a0,s2
    80004632:	fffff097          	auipc	ra,0xfffff
    80004636:	cdc080e7          	jalr	-804(ra) # 8000330e <dirlink>
    8000463a:	06054b63          	bltz	a0,800046b0 <create+0x152>
  iunlockput(dp);
    8000463e:	854a                	mv	a0,s2
    80004640:	fffff097          	auipc	ra,0xfffff
    80004644:	836080e7          	jalr	-1994(ra) # 80002e76 <iunlockput>
  return ip;
    80004648:	b761                	j	800045d0 <create+0x72>
    panic("create: ialloc");
    8000464a:	00004517          	auipc	a0,0x4
    8000464e:	00650513          	addi	a0,a0,6 # 80008650 <syscalls+0x2b0>
    80004652:	00002097          	auipc	ra,0x2
    80004656:	84e080e7          	jalr	-1970(ra) # 80005ea0 <panic>
    dp->nlink++;  // for ".."
    8000465a:	04a95783          	lhu	a5,74(s2)
    8000465e:	2785                	addiw	a5,a5,1
    80004660:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004664:	854a                	mv	a0,s2
    80004666:	ffffe097          	auipc	ra,0xffffe
    8000466a:	4e2080e7          	jalr	1250(ra) # 80002b48 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000466e:	40d0                	lw	a2,4(s1)
    80004670:	00004597          	auipc	a1,0x4
    80004674:	ff058593          	addi	a1,a1,-16 # 80008660 <syscalls+0x2c0>
    80004678:	8526                	mv	a0,s1
    8000467a:	fffff097          	auipc	ra,0xfffff
    8000467e:	c94080e7          	jalr	-876(ra) # 8000330e <dirlink>
    80004682:	00054f63          	bltz	a0,800046a0 <create+0x142>
    80004686:	00492603          	lw	a2,4(s2)
    8000468a:	00004597          	auipc	a1,0x4
    8000468e:	fde58593          	addi	a1,a1,-34 # 80008668 <syscalls+0x2c8>
    80004692:	8526                	mv	a0,s1
    80004694:	fffff097          	auipc	ra,0xfffff
    80004698:	c7a080e7          	jalr	-902(ra) # 8000330e <dirlink>
    8000469c:	f80557e3          	bgez	a0,8000462a <create+0xcc>
      panic("create dots");
    800046a0:	00004517          	auipc	a0,0x4
    800046a4:	fd050513          	addi	a0,a0,-48 # 80008670 <syscalls+0x2d0>
    800046a8:	00001097          	auipc	ra,0x1
    800046ac:	7f8080e7          	jalr	2040(ra) # 80005ea0 <panic>
    panic("create: dirlink");
    800046b0:	00004517          	auipc	a0,0x4
    800046b4:	fd050513          	addi	a0,a0,-48 # 80008680 <syscalls+0x2e0>
    800046b8:	00001097          	auipc	ra,0x1
    800046bc:	7e8080e7          	jalr	2024(ra) # 80005ea0 <panic>
    return 0;
    800046c0:	84aa                	mv	s1,a0
    800046c2:	b739                	j	800045d0 <create+0x72>

00000000800046c4 <sys_dup>:
{
    800046c4:	7179                	addi	sp,sp,-48
    800046c6:	f406                	sd	ra,40(sp)
    800046c8:	f022                	sd	s0,32(sp)
    800046ca:	ec26                	sd	s1,24(sp)
    800046cc:	e84a                	sd	s2,16(sp)
    800046ce:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046d0:	fd840613          	addi	a2,s0,-40
    800046d4:	4581                	li	a1,0
    800046d6:	4501                	li	a0,0
    800046d8:	00000097          	auipc	ra,0x0
    800046dc:	ddc080e7          	jalr	-548(ra) # 800044b4 <argfd>
    return -1;
    800046e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046e2:	02054363          	bltz	a0,80004708 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800046e6:	fd843903          	ld	s2,-40(s0)
    800046ea:	854a                	mv	a0,s2
    800046ec:	00000097          	auipc	ra,0x0
    800046f0:	e30080e7          	jalr	-464(ra) # 8000451c <fdalloc>
    800046f4:	84aa                	mv	s1,a0
    return -1;
    800046f6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046f8:	00054863          	bltz	a0,80004708 <sys_dup+0x44>
  filedup(f);
    800046fc:	854a                	mv	a0,s2
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	368080e7          	jalr	872(ra) # 80003a66 <filedup>
  return fd;
    80004706:	87a6                	mv	a5,s1
}
    80004708:	853e                	mv	a0,a5
    8000470a:	70a2                	ld	ra,40(sp)
    8000470c:	7402                	ld	s0,32(sp)
    8000470e:	64e2                	ld	s1,24(sp)
    80004710:	6942                	ld	s2,16(sp)
    80004712:	6145                	addi	sp,sp,48
    80004714:	8082                	ret

0000000080004716 <sys_read>:
{
    80004716:	7179                	addi	sp,sp,-48
    80004718:	f406                	sd	ra,40(sp)
    8000471a:	f022                	sd	s0,32(sp)
    8000471c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000471e:	fe840613          	addi	a2,s0,-24
    80004722:	4581                	li	a1,0
    80004724:	4501                	li	a0,0
    80004726:	00000097          	auipc	ra,0x0
    8000472a:	d8e080e7          	jalr	-626(ra) # 800044b4 <argfd>
    return -1;
    8000472e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004730:	04054163          	bltz	a0,80004772 <sys_read+0x5c>
    80004734:	fe440593          	addi	a1,s0,-28
    80004738:	4509                	li	a0,2
    8000473a:	ffffe097          	auipc	ra,0xffffe
    8000473e:	968080e7          	jalr	-1688(ra) # 800020a2 <argint>
    return -1;
    80004742:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004744:	02054763          	bltz	a0,80004772 <sys_read+0x5c>
    80004748:	fd840593          	addi	a1,s0,-40
    8000474c:	4505                	li	a0,1
    8000474e:	ffffe097          	auipc	ra,0xffffe
    80004752:	976080e7          	jalr	-1674(ra) # 800020c4 <argaddr>
    return -1;
    80004756:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004758:	00054d63          	bltz	a0,80004772 <sys_read+0x5c>
  return fileread(f, p, n);
    8000475c:	fe442603          	lw	a2,-28(s0)
    80004760:	fd843583          	ld	a1,-40(s0)
    80004764:	fe843503          	ld	a0,-24(s0)
    80004768:	fffff097          	auipc	ra,0xfffff
    8000476c:	48a080e7          	jalr	1162(ra) # 80003bf2 <fileread>
    80004770:	87aa                	mv	a5,a0
}
    80004772:	853e                	mv	a0,a5
    80004774:	70a2                	ld	ra,40(sp)
    80004776:	7402                	ld	s0,32(sp)
    80004778:	6145                	addi	sp,sp,48
    8000477a:	8082                	ret

000000008000477c <sys_write>:
{
    8000477c:	7179                	addi	sp,sp,-48
    8000477e:	f406                	sd	ra,40(sp)
    80004780:	f022                	sd	s0,32(sp)
    80004782:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004784:	fe840613          	addi	a2,s0,-24
    80004788:	4581                	li	a1,0
    8000478a:	4501                	li	a0,0
    8000478c:	00000097          	auipc	ra,0x0
    80004790:	d28080e7          	jalr	-728(ra) # 800044b4 <argfd>
    return -1;
    80004794:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004796:	04054163          	bltz	a0,800047d8 <sys_write+0x5c>
    8000479a:	fe440593          	addi	a1,s0,-28
    8000479e:	4509                	li	a0,2
    800047a0:	ffffe097          	auipc	ra,0xffffe
    800047a4:	902080e7          	jalr	-1790(ra) # 800020a2 <argint>
    return -1;
    800047a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047aa:	02054763          	bltz	a0,800047d8 <sys_write+0x5c>
    800047ae:	fd840593          	addi	a1,s0,-40
    800047b2:	4505                	li	a0,1
    800047b4:	ffffe097          	auipc	ra,0xffffe
    800047b8:	910080e7          	jalr	-1776(ra) # 800020c4 <argaddr>
    return -1;
    800047bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047be:	00054d63          	bltz	a0,800047d8 <sys_write+0x5c>
  return filewrite(f, p, n);
    800047c2:	fe442603          	lw	a2,-28(s0)
    800047c6:	fd843583          	ld	a1,-40(s0)
    800047ca:	fe843503          	ld	a0,-24(s0)
    800047ce:	fffff097          	auipc	ra,0xfffff
    800047d2:	4e6080e7          	jalr	1254(ra) # 80003cb4 <filewrite>
    800047d6:	87aa                	mv	a5,a0
}
    800047d8:	853e                	mv	a0,a5
    800047da:	70a2                	ld	ra,40(sp)
    800047dc:	7402                	ld	s0,32(sp)
    800047de:	6145                	addi	sp,sp,48
    800047e0:	8082                	ret

00000000800047e2 <sys_close>:
{
    800047e2:	1101                	addi	sp,sp,-32
    800047e4:	ec06                	sd	ra,24(sp)
    800047e6:	e822                	sd	s0,16(sp)
    800047e8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047ea:	fe040613          	addi	a2,s0,-32
    800047ee:	fec40593          	addi	a1,s0,-20
    800047f2:	4501                	li	a0,0
    800047f4:	00000097          	auipc	ra,0x0
    800047f8:	cc0080e7          	jalr	-832(ra) # 800044b4 <argfd>
    return -1;
    800047fc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047fe:	02054463          	bltz	a0,80004826 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004802:	ffffc097          	auipc	ra,0xffffc
    80004806:	628080e7          	jalr	1576(ra) # 80000e2a <myproc>
    8000480a:	fec42783          	lw	a5,-20(s0)
    8000480e:	07e9                	addi	a5,a5,26
    80004810:	078e                	slli	a5,a5,0x3
    80004812:	953e                	add	a0,a0,a5
    80004814:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004818:	fe043503          	ld	a0,-32(s0)
    8000481c:	fffff097          	auipc	ra,0xfffff
    80004820:	29c080e7          	jalr	668(ra) # 80003ab8 <fileclose>
  return 0;
    80004824:	4781                	li	a5,0
}
    80004826:	853e                	mv	a0,a5
    80004828:	60e2                	ld	ra,24(sp)
    8000482a:	6442                	ld	s0,16(sp)
    8000482c:	6105                	addi	sp,sp,32
    8000482e:	8082                	ret

0000000080004830 <sys_fstat>:
{
    80004830:	1101                	addi	sp,sp,-32
    80004832:	ec06                	sd	ra,24(sp)
    80004834:	e822                	sd	s0,16(sp)
    80004836:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004838:	fe840613          	addi	a2,s0,-24
    8000483c:	4581                	li	a1,0
    8000483e:	4501                	li	a0,0
    80004840:	00000097          	auipc	ra,0x0
    80004844:	c74080e7          	jalr	-908(ra) # 800044b4 <argfd>
    return -1;
    80004848:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000484a:	02054563          	bltz	a0,80004874 <sys_fstat+0x44>
    8000484e:	fe040593          	addi	a1,s0,-32
    80004852:	4505                	li	a0,1
    80004854:	ffffe097          	auipc	ra,0xffffe
    80004858:	870080e7          	jalr	-1936(ra) # 800020c4 <argaddr>
    return -1;
    8000485c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000485e:	00054b63          	bltz	a0,80004874 <sys_fstat+0x44>
  return filestat(f, st);
    80004862:	fe043583          	ld	a1,-32(s0)
    80004866:	fe843503          	ld	a0,-24(s0)
    8000486a:	fffff097          	auipc	ra,0xfffff
    8000486e:	316080e7          	jalr	790(ra) # 80003b80 <filestat>
    80004872:	87aa                	mv	a5,a0
}
    80004874:	853e                	mv	a0,a5
    80004876:	60e2                	ld	ra,24(sp)
    80004878:	6442                	ld	s0,16(sp)
    8000487a:	6105                	addi	sp,sp,32
    8000487c:	8082                	ret

000000008000487e <sys_link>:
{
    8000487e:	7169                	addi	sp,sp,-304
    80004880:	f606                	sd	ra,296(sp)
    80004882:	f222                	sd	s0,288(sp)
    80004884:	ee26                	sd	s1,280(sp)
    80004886:	ea4a                	sd	s2,272(sp)
    80004888:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000488a:	08000613          	li	a2,128
    8000488e:	ed040593          	addi	a1,s0,-304
    80004892:	4501                	li	a0,0
    80004894:	ffffe097          	auipc	ra,0xffffe
    80004898:	852080e7          	jalr	-1966(ra) # 800020e6 <argstr>
    return -1;
    8000489c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000489e:	10054e63          	bltz	a0,800049ba <sys_link+0x13c>
    800048a2:	08000613          	li	a2,128
    800048a6:	f5040593          	addi	a1,s0,-176
    800048aa:	4505                	li	a0,1
    800048ac:	ffffe097          	auipc	ra,0xffffe
    800048b0:	83a080e7          	jalr	-1990(ra) # 800020e6 <argstr>
    return -1;
    800048b4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048b6:	10054263          	bltz	a0,800049ba <sys_link+0x13c>
  begin_op();
    800048ba:	fffff097          	auipc	ra,0xfffff
    800048be:	d36080e7          	jalr	-714(ra) # 800035f0 <begin_op>
  if((ip = namei(old)) == 0){
    800048c2:	ed040513          	addi	a0,s0,-304
    800048c6:	fffff097          	auipc	ra,0xfffff
    800048ca:	b0a080e7          	jalr	-1270(ra) # 800033d0 <namei>
    800048ce:	84aa                	mv	s1,a0
    800048d0:	c551                	beqz	a0,8000495c <sys_link+0xde>
  ilock(ip);
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	342080e7          	jalr	834(ra) # 80002c14 <ilock>
  if(ip->type == T_DIR){
    800048da:	04449703          	lh	a4,68(s1)
    800048de:	4785                	li	a5,1
    800048e0:	08f70463          	beq	a4,a5,80004968 <sys_link+0xea>
  ip->nlink++;
    800048e4:	04a4d783          	lhu	a5,74(s1)
    800048e8:	2785                	addiw	a5,a5,1
    800048ea:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048ee:	8526                	mv	a0,s1
    800048f0:	ffffe097          	auipc	ra,0xffffe
    800048f4:	258080e7          	jalr	600(ra) # 80002b48 <iupdate>
  iunlock(ip);
    800048f8:	8526                	mv	a0,s1
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	3dc080e7          	jalr	988(ra) # 80002cd6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004902:	fd040593          	addi	a1,s0,-48
    80004906:	f5040513          	addi	a0,s0,-176
    8000490a:	fffff097          	auipc	ra,0xfffff
    8000490e:	ae4080e7          	jalr	-1308(ra) # 800033ee <nameiparent>
    80004912:	892a                	mv	s2,a0
    80004914:	c935                	beqz	a0,80004988 <sys_link+0x10a>
  ilock(dp);
    80004916:	ffffe097          	auipc	ra,0xffffe
    8000491a:	2fe080e7          	jalr	766(ra) # 80002c14 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000491e:	00092703          	lw	a4,0(s2)
    80004922:	409c                	lw	a5,0(s1)
    80004924:	04f71d63          	bne	a4,a5,8000497e <sys_link+0x100>
    80004928:	40d0                	lw	a2,4(s1)
    8000492a:	fd040593          	addi	a1,s0,-48
    8000492e:	854a                	mv	a0,s2
    80004930:	fffff097          	auipc	ra,0xfffff
    80004934:	9de080e7          	jalr	-1570(ra) # 8000330e <dirlink>
    80004938:	04054363          	bltz	a0,8000497e <sys_link+0x100>
  iunlockput(dp);
    8000493c:	854a                	mv	a0,s2
    8000493e:	ffffe097          	auipc	ra,0xffffe
    80004942:	538080e7          	jalr	1336(ra) # 80002e76 <iunlockput>
  iput(ip);
    80004946:	8526                	mv	a0,s1
    80004948:	ffffe097          	auipc	ra,0xffffe
    8000494c:	486080e7          	jalr	1158(ra) # 80002dce <iput>
  end_op();
    80004950:	fffff097          	auipc	ra,0xfffff
    80004954:	d1e080e7          	jalr	-738(ra) # 8000366e <end_op>
  return 0;
    80004958:	4781                	li	a5,0
    8000495a:	a085                	j	800049ba <sys_link+0x13c>
    end_op();
    8000495c:	fffff097          	auipc	ra,0xfffff
    80004960:	d12080e7          	jalr	-750(ra) # 8000366e <end_op>
    return -1;
    80004964:	57fd                	li	a5,-1
    80004966:	a891                	j	800049ba <sys_link+0x13c>
    iunlockput(ip);
    80004968:	8526                	mv	a0,s1
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	50c080e7          	jalr	1292(ra) # 80002e76 <iunlockput>
    end_op();
    80004972:	fffff097          	auipc	ra,0xfffff
    80004976:	cfc080e7          	jalr	-772(ra) # 8000366e <end_op>
    return -1;
    8000497a:	57fd                	li	a5,-1
    8000497c:	a83d                	j	800049ba <sys_link+0x13c>
    iunlockput(dp);
    8000497e:	854a                	mv	a0,s2
    80004980:	ffffe097          	auipc	ra,0xffffe
    80004984:	4f6080e7          	jalr	1270(ra) # 80002e76 <iunlockput>
  ilock(ip);
    80004988:	8526                	mv	a0,s1
    8000498a:	ffffe097          	auipc	ra,0xffffe
    8000498e:	28a080e7          	jalr	650(ra) # 80002c14 <ilock>
  ip->nlink--;
    80004992:	04a4d783          	lhu	a5,74(s1)
    80004996:	37fd                	addiw	a5,a5,-1
    80004998:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000499c:	8526                	mv	a0,s1
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	1aa080e7          	jalr	426(ra) # 80002b48 <iupdate>
  iunlockput(ip);
    800049a6:	8526                	mv	a0,s1
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	4ce080e7          	jalr	1230(ra) # 80002e76 <iunlockput>
  end_op();
    800049b0:	fffff097          	auipc	ra,0xfffff
    800049b4:	cbe080e7          	jalr	-834(ra) # 8000366e <end_op>
  return -1;
    800049b8:	57fd                	li	a5,-1
}
    800049ba:	853e                	mv	a0,a5
    800049bc:	70b2                	ld	ra,296(sp)
    800049be:	7412                	ld	s0,288(sp)
    800049c0:	64f2                	ld	s1,280(sp)
    800049c2:	6952                	ld	s2,272(sp)
    800049c4:	6155                	addi	sp,sp,304
    800049c6:	8082                	ret

00000000800049c8 <sys_unlink>:
{
    800049c8:	7151                	addi	sp,sp,-240
    800049ca:	f586                	sd	ra,232(sp)
    800049cc:	f1a2                	sd	s0,224(sp)
    800049ce:	eda6                	sd	s1,216(sp)
    800049d0:	e9ca                	sd	s2,208(sp)
    800049d2:	e5ce                	sd	s3,200(sp)
    800049d4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049d6:	08000613          	li	a2,128
    800049da:	f3040593          	addi	a1,s0,-208
    800049de:	4501                	li	a0,0
    800049e0:	ffffd097          	auipc	ra,0xffffd
    800049e4:	706080e7          	jalr	1798(ra) # 800020e6 <argstr>
    800049e8:	18054163          	bltz	a0,80004b6a <sys_unlink+0x1a2>
  begin_op();
    800049ec:	fffff097          	auipc	ra,0xfffff
    800049f0:	c04080e7          	jalr	-1020(ra) # 800035f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049f4:	fb040593          	addi	a1,s0,-80
    800049f8:	f3040513          	addi	a0,s0,-208
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	9f2080e7          	jalr	-1550(ra) # 800033ee <nameiparent>
    80004a04:	84aa                	mv	s1,a0
    80004a06:	c979                	beqz	a0,80004adc <sys_unlink+0x114>
  ilock(dp);
    80004a08:	ffffe097          	auipc	ra,0xffffe
    80004a0c:	20c080e7          	jalr	524(ra) # 80002c14 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a10:	00004597          	auipc	a1,0x4
    80004a14:	c5058593          	addi	a1,a1,-944 # 80008660 <syscalls+0x2c0>
    80004a18:	fb040513          	addi	a0,s0,-80
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	6c2080e7          	jalr	1730(ra) # 800030de <namecmp>
    80004a24:	14050a63          	beqz	a0,80004b78 <sys_unlink+0x1b0>
    80004a28:	00004597          	auipc	a1,0x4
    80004a2c:	c4058593          	addi	a1,a1,-960 # 80008668 <syscalls+0x2c8>
    80004a30:	fb040513          	addi	a0,s0,-80
    80004a34:	ffffe097          	auipc	ra,0xffffe
    80004a38:	6aa080e7          	jalr	1706(ra) # 800030de <namecmp>
    80004a3c:	12050e63          	beqz	a0,80004b78 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a40:	f2c40613          	addi	a2,s0,-212
    80004a44:	fb040593          	addi	a1,s0,-80
    80004a48:	8526                	mv	a0,s1
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	6ae080e7          	jalr	1710(ra) # 800030f8 <dirlookup>
    80004a52:	892a                	mv	s2,a0
    80004a54:	12050263          	beqz	a0,80004b78 <sys_unlink+0x1b0>
  ilock(ip);
    80004a58:	ffffe097          	auipc	ra,0xffffe
    80004a5c:	1bc080e7          	jalr	444(ra) # 80002c14 <ilock>
  if(ip->nlink < 1)
    80004a60:	04a91783          	lh	a5,74(s2)
    80004a64:	08f05263          	blez	a5,80004ae8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a68:	04491703          	lh	a4,68(s2)
    80004a6c:	4785                	li	a5,1
    80004a6e:	08f70563          	beq	a4,a5,80004af8 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a72:	4641                	li	a2,16
    80004a74:	4581                	li	a1,0
    80004a76:	fc040513          	addi	a0,s0,-64
    80004a7a:	ffffb097          	auipc	ra,0xffffb
    80004a7e:	700080e7          	jalr	1792(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a82:	4741                	li	a4,16
    80004a84:	f2c42683          	lw	a3,-212(s0)
    80004a88:	fc040613          	addi	a2,s0,-64
    80004a8c:	4581                	li	a1,0
    80004a8e:	8526                	mv	a0,s1
    80004a90:	ffffe097          	auipc	ra,0xffffe
    80004a94:	530080e7          	jalr	1328(ra) # 80002fc0 <writei>
    80004a98:	47c1                	li	a5,16
    80004a9a:	0af51563          	bne	a0,a5,80004b44 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a9e:	04491703          	lh	a4,68(s2)
    80004aa2:	4785                	li	a5,1
    80004aa4:	0af70863          	beq	a4,a5,80004b54 <sys_unlink+0x18c>
  iunlockput(dp);
    80004aa8:	8526                	mv	a0,s1
    80004aaa:	ffffe097          	auipc	ra,0xffffe
    80004aae:	3cc080e7          	jalr	972(ra) # 80002e76 <iunlockput>
  ip->nlink--;
    80004ab2:	04a95783          	lhu	a5,74(s2)
    80004ab6:	37fd                	addiw	a5,a5,-1
    80004ab8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004abc:	854a                	mv	a0,s2
    80004abe:	ffffe097          	auipc	ra,0xffffe
    80004ac2:	08a080e7          	jalr	138(ra) # 80002b48 <iupdate>
  iunlockput(ip);
    80004ac6:	854a                	mv	a0,s2
    80004ac8:	ffffe097          	auipc	ra,0xffffe
    80004acc:	3ae080e7          	jalr	942(ra) # 80002e76 <iunlockput>
  end_op();
    80004ad0:	fffff097          	auipc	ra,0xfffff
    80004ad4:	b9e080e7          	jalr	-1122(ra) # 8000366e <end_op>
  return 0;
    80004ad8:	4501                	li	a0,0
    80004ada:	a84d                	j	80004b8c <sys_unlink+0x1c4>
    end_op();
    80004adc:	fffff097          	auipc	ra,0xfffff
    80004ae0:	b92080e7          	jalr	-1134(ra) # 8000366e <end_op>
    return -1;
    80004ae4:	557d                	li	a0,-1
    80004ae6:	a05d                	j	80004b8c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ae8:	00004517          	auipc	a0,0x4
    80004aec:	ba850513          	addi	a0,a0,-1112 # 80008690 <syscalls+0x2f0>
    80004af0:	00001097          	auipc	ra,0x1
    80004af4:	3b0080e7          	jalr	944(ra) # 80005ea0 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004af8:	04c92703          	lw	a4,76(s2)
    80004afc:	02000793          	li	a5,32
    80004b00:	f6e7f9e3          	bgeu	a5,a4,80004a72 <sys_unlink+0xaa>
    80004b04:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b08:	4741                	li	a4,16
    80004b0a:	86ce                	mv	a3,s3
    80004b0c:	f1840613          	addi	a2,s0,-232
    80004b10:	4581                	li	a1,0
    80004b12:	854a                	mv	a0,s2
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	3b4080e7          	jalr	948(ra) # 80002ec8 <readi>
    80004b1c:	47c1                	li	a5,16
    80004b1e:	00f51b63          	bne	a0,a5,80004b34 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b22:	f1845783          	lhu	a5,-232(s0)
    80004b26:	e7a1                	bnez	a5,80004b6e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b28:	29c1                	addiw	s3,s3,16
    80004b2a:	04c92783          	lw	a5,76(s2)
    80004b2e:	fcf9ede3          	bltu	s3,a5,80004b08 <sys_unlink+0x140>
    80004b32:	b781                	j	80004a72 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b34:	00004517          	auipc	a0,0x4
    80004b38:	b7450513          	addi	a0,a0,-1164 # 800086a8 <syscalls+0x308>
    80004b3c:	00001097          	auipc	ra,0x1
    80004b40:	364080e7          	jalr	868(ra) # 80005ea0 <panic>
    panic("unlink: writei");
    80004b44:	00004517          	auipc	a0,0x4
    80004b48:	b7c50513          	addi	a0,a0,-1156 # 800086c0 <syscalls+0x320>
    80004b4c:	00001097          	auipc	ra,0x1
    80004b50:	354080e7          	jalr	852(ra) # 80005ea0 <panic>
    dp->nlink--;
    80004b54:	04a4d783          	lhu	a5,74(s1)
    80004b58:	37fd                	addiw	a5,a5,-1
    80004b5a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b5e:	8526                	mv	a0,s1
    80004b60:	ffffe097          	auipc	ra,0xffffe
    80004b64:	fe8080e7          	jalr	-24(ra) # 80002b48 <iupdate>
    80004b68:	b781                	j	80004aa8 <sys_unlink+0xe0>
    return -1;
    80004b6a:	557d                	li	a0,-1
    80004b6c:	a005                	j	80004b8c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b6e:	854a                	mv	a0,s2
    80004b70:	ffffe097          	auipc	ra,0xffffe
    80004b74:	306080e7          	jalr	774(ra) # 80002e76 <iunlockput>
  iunlockput(dp);
    80004b78:	8526                	mv	a0,s1
    80004b7a:	ffffe097          	auipc	ra,0xffffe
    80004b7e:	2fc080e7          	jalr	764(ra) # 80002e76 <iunlockput>
  end_op();
    80004b82:	fffff097          	auipc	ra,0xfffff
    80004b86:	aec080e7          	jalr	-1300(ra) # 8000366e <end_op>
  return -1;
    80004b8a:	557d                	li	a0,-1
}
    80004b8c:	70ae                	ld	ra,232(sp)
    80004b8e:	740e                	ld	s0,224(sp)
    80004b90:	64ee                	ld	s1,216(sp)
    80004b92:	694e                	ld	s2,208(sp)
    80004b94:	69ae                	ld	s3,200(sp)
    80004b96:	616d                	addi	sp,sp,240
    80004b98:	8082                	ret

0000000080004b9a <sys_open>:

uint64
sys_open(void)
{
    80004b9a:	7131                	addi	sp,sp,-192
    80004b9c:	fd06                	sd	ra,184(sp)
    80004b9e:	f922                	sd	s0,176(sp)
    80004ba0:	f526                	sd	s1,168(sp)
    80004ba2:	f14a                	sd	s2,160(sp)
    80004ba4:	ed4e                	sd	s3,152(sp)
    80004ba6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ba8:	08000613          	li	a2,128
    80004bac:	f5040593          	addi	a1,s0,-176
    80004bb0:	4501                	li	a0,0
    80004bb2:	ffffd097          	auipc	ra,0xffffd
    80004bb6:	534080e7          	jalr	1332(ra) # 800020e6 <argstr>
    return -1;
    80004bba:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004bbc:	0c054163          	bltz	a0,80004c7e <sys_open+0xe4>
    80004bc0:	f4c40593          	addi	a1,s0,-180
    80004bc4:	4505                	li	a0,1
    80004bc6:	ffffd097          	auipc	ra,0xffffd
    80004bca:	4dc080e7          	jalr	1244(ra) # 800020a2 <argint>
    80004bce:	0a054863          	bltz	a0,80004c7e <sys_open+0xe4>

  begin_op();
    80004bd2:	fffff097          	auipc	ra,0xfffff
    80004bd6:	a1e080e7          	jalr	-1506(ra) # 800035f0 <begin_op>

  if(omode & O_CREATE){
    80004bda:	f4c42783          	lw	a5,-180(s0)
    80004bde:	2007f793          	andi	a5,a5,512
    80004be2:	cbdd                	beqz	a5,80004c98 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004be4:	4681                	li	a3,0
    80004be6:	4601                	li	a2,0
    80004be8:	4589                	li	a1,2
    80004bea:	f5040513          	addi	a0,s0,-176
    80004bee:	00000097          	auipc	ra,0x0
    80004bf2:	970080e7          	jalr	-1680(ra) # 8000455e <create>
    80004bf6:	892a                	mv	s2,a0
    if(ip == 0){
    80004bf8:	c959                	beqz	a0,80004c8e <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bfa:	04491703          	lh	a4,68(s2)
    80004bfe:	478d                	li	a5,3
    80004c00:	00f71763          	bne	a4,a5,80004c0e <sys_open+0x74>
    80004c04:	04695703          	lhu	a4,70(s2)
    80004c08:	47a5                	li	a5,9
    80004c0a:	0ce7ec63          	bltu	a5,a4,80004ce2 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c0e:	fffff097          	auipc	ra,0xfffff
    80004c12:	dee080e7          	jalr	-530(ra) # 800039fc <filealloc>
    80004c16:	89aa                	mv	s3,a0
    80004c18:	10050263          	beqz	a0,80004d1c <sys_open+0x182>
    80004c1c:	00000097          	auipc	ra,0x0
    80004c20:	900080e7          	jalr	-1792(ra) # 8000451c <fdalloc>
    80004c24:	84aa                	mv	s1,a0
    80004c26:	0e054663          	bltz	a0,80004d12 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c2a:	04491703          	lh	a4,68(s2)
    80004c2e:	478d                	li	a5,3
    80004c30:	0cf70463          	beq	a4,a5,80004cf8 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c34:	4789                	li	a5,2
    80004c36:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c3a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c3e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c42:	f4c42783          	lw	a5,-180(s0)
    80004c46:	0017c713          	xori	a4,a5,1
    80004c4a:	8b05                	andi	a4,a4,1
    80004c4c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c50:	0037f713          	andi	a4,a5,3
    80004c54:	00e03733          	snez	a4,a4
    80004c58:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c5c:	4007f793          	andi	a5,a5,1024
    80004c60:	c791                	beqz	a5,80004c6c <sys_open+0xd2>
    80004c62:	04491703          	lh	a4,68(s2)
    80004c66:	4789                	li	a5,2
    80004c68:	08f70f63          	beq	a4,a5,80004d06 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c6c:	854a                	mv	a0,s2
    80004c6e:	ffffe097          	auipc	ra,0xffffe
    80004c72:	068080e7          	jalr	104(ra) # 80002cd6 <iunlock>
  end_op();
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	9f8080e7          	jalr	-1544(ra) # 8000366e <end_op>

  return fd;
}
    80004c7e:	8526                	mv	a0,s1
    80004c80:	70ea                	ld	ra,184(sp)
    80004c82:	744a                	ld	s0,176(sp)
    80004c84:	74aa                	ld	s1,168(sp)
    80004c86:	790a                	ld	s2,160(sp)
    80004c88:	69ea                	ld	s3,152(sp)
    80004c8a:	6129                	addi	sp,sp,192
    80004c8c:	8082                	ret
      end_op();
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	9e0080e7          	jalr	-1568(ra) # 8000366e <end_op>
      return -1;
    80004c96:	b7e5                	j	80004c7e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c98:	f5040513          	addi	a0,s0,-176
    80004c9c:	ffffe097          	auipc	ra,0xffffe
    80004ca0:	734080e7          	jalr	1844(ra) # 800033d0 <namei>
    80004ca4:	892a                	mv	s2,a0
    80004ca6:	c905                	beqz	a0,80004cd6 <sys_open+0x13c>
    ilock(ip);
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	f6c080e7          	jalr	-148(ra) # 80002c14 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004cb0:	04491703          	lh	a4,68(s2)
    80004cb4:	4785                	li	a5,1
    80004cb6:	f4f712e3          	bne	a4,a5,80004bfa <sys_open+0x60>
    80004cba:	f4c42783          	lw	a5,-180(s0)
    80004cbe:	dba1                	beqz	a5,80004c0e <sys_open+0x74>
      iunlockput(ip);
    80004cc0:	854a                	mv	a0,s2
    80004cc2:	ffffe097          	auipc	ra,0xffffe
    80004cc6:	1b4080e7          	jalr	436(ra) # 80002e76 <iunlockput>
      end_op();
    80004cca:	fffff097          	auipc	ra,0xfffff
    80004cce:	9a4080e7          	jalr	-1628(ra) # 8000366e <end_op>
      return -1;
    80004cd2:	54fd                	li	s1,-1
    80004cd4:	b76d                	j	80004c7e <sys_open+0xe4>
      end_op();
    80004cd6:	fffff097          	auipc	ra,0xfffff
    80004cda:	998080e7          	jalr	-1640(ra) # 8000366e <end_op>
      return -1;
    80004cde:	54fd                	li	s1,-1
    80004ce0:	bf79                	j	80004c7e <sys_open+0xe4>
    iunlockput(ip);
    80004ce2:	854a                	mv	a0,s2
    80004ce4:	ffffe097          	auipc	ra,0xffffe
    80004ce8:	192080e7          	jalr	402(ra) # 80002e76 <iunlockput>
    end_op();
    80004cec:	fffff097          	auipc	ra,0xfffff
    80004cf0:	982080e7          	jalr	-1662(ra) # 8000366e <end_op>
    return -1;
    80004cf4:	54fd                	li	s1,-1
    80004cf6:	b761                	j	80004c7e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cf8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cfc:	04691783          	lh	a5,70(s2)
    80004d00:	02f99223          	sh	a5,36(s3)
    80004d04:	bf2d                	j	80004c3e <sys_open+0xa4>
    itrunc(ip);
    80004d06:	854a                	mv	a0,s2
    80004d08:	ffffe097          	auipc	ra,0xffffe
    80004d0c:	01a080e7          	jalr	26(ra) # 80002d22 <itrunc>
    80004d10:	bfb1                	j	80004c6c <sys_open+0xd2>
      fileclose(f);
    80004d12:	854e                	mv	a0,s3
    80004d14:	fffff097          	auipc	ra,0xfffff
    80004d18:	da4080e7          	jalr	-604(ra) # 80003ab8 <fileclose>
    iunlockput(ip);
    80004d1c:	854a                	mv	a0,s2
    80004d1e:	ffffe097          	auipc	ra,0xffffe
    80004d22:	158080e7          	jalr	344(ra) # 80002e76 <iunlockput>
    end_op();
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	948080e7          	jalr	-1720(ra) # 8000366e <end_op>
    return -1;
    80004d2e:	54fd                	li	s1,-1
    80004d30:	b7b9                	j	80004c7e <sys_open+0xe4>

0000000080004d32 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d32:	7175                	addi	sp,sp,-144
    80004d34:	e506                	sd	ra,136(sp)
    80004d36:	e122                	sd	s0,128(sp)
    80004d38:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d3a:	fffff097          	auipc	ra,0xfffff
    80004d3e:	8b6080e7          	jalr	-1866(ra) # 800035f0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d42:	08000613          	li	a2,128
    80004d46:	f7040593          	addi	a1,s0,-144
    80004d4a:	4501                	li	a0,0
    80004d4c:	ffffd097          	auipc	ra,0xffffd
    80004d50:	39a080e7          	jalr	922(ra) # 800020e6 <argstr>
    80004d54:	02054963          	bltz	a0,80004d86 <sys_mkdir+0x54>
    80004d58:	4681                	li	a3,0
    80004d5a:	4601                	li	a2,0
    80004d5c:	4585                	li	a1,1
    80004d5e:	f7040513          	addi	a0,s0,-144
    80004d62:	fffff097          	auipc	ra,0xfffff
    80004d66:	7fc080e7          	jalr	2044(ra) # 8000455e <create>
    80004d6a:	cd11                	beqz	a0,80004d86 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d6c:	ffffe097          	auipc	ra,0xffffe
    80004d70:	10a080e7          	jalr	266(ra) # 80002e76 <iunlockput>
  end_op();
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	8fa080e7          	jalr	-1798(ra) # 8000366e <end_op>
  return 0;
    80004d7c:	4501                	li	a0,0
}
    80004d7e:	60aa                	ld	ra,136(sp)
    80004d80:	640a                	ld	s0,128(sp)
    80004d82:	6149                	addi	sp,sp,144
    80004d84:	8082                	ret
    end_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	8e8080e7          	jalr	-1816(ra) # 8000366e <end_op>
    return -1;
    80004d8e:	557d                	li	a0,-1
    80004d90:	b7fd                	j	80004d7e <sys_mkdir+0x4c>

0000000080004d92 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d92:	7135                	addi	sp,sp,-160
    80004d94:	ed06                	sd	ra,152(sp)
    80004d96:	e922                	sd	s0,144(sp)
    80004d98:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d9a:	fffff097          	auipc	ra,0xfffff
    80004d9e:	856080e7          	jalr	-1962(ra) # 800035f0 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004da2:	08000613          	li	a2,128
    80004da6:	f7040593          	addi	a1,s0,-144
    80004daa:	4501                	li	a0,0
    80004dac:	ffffd097          	auipc	ra,0xffffd
    80004db0:	33a080e7          	jalr	826(ra) # 800020e6 <argstr>
    80004db4:	04054a63          	bltz	a0,80004e08 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004db8:	f6c40593          	addi	a1,s0,-148
    80004dbc:	4505                	li	a0,1
    80004dbe:	ffffd097          	auipc	ra,0xffffd
    80004dc2:	2e4080e7          	jalr	740(ra) # 800020a2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dc6:	04054163          	bltz	a0,80004e08 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004dca:	f6840593          	addi	a1,s0,-152
    80004dce:	4509                	li	a0,2
    80004dd0:	ffffd097          	auipc	ra,0xffffd
    80004dd4:	2d2080e7          	jalr	722(ra) # 800020a2 <argint>
     argint(1, &major) < 0 ||
    80004dd8:	02054863          	bltz	a0,80004e08 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ddc:	f6841683          	lh	a3,-152(s0)
    80004de0:	f6c41603          	lh	a2,-148(s0)
    80004de4:	458d                	li	a1,3
    80004de6:	f7040513          	addi	a0,s0,-144
    80004dea:	fffff097          	auipc	ra,0xfffff
    80004dee:	774080e7          	jalr	1908(ra) # 8000455e <create>
     argint(2, &minor) < 0 ||
    80004df2:	c919                	beqz	a0,80004e08 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	082080e7          	jalr	130(ra) # 80002e76 <iunlockput>
  end_op();
    80004dfc:	fffff097          	auipc	ra,0xfffff
    80004e00:	872080e7          	jalr	-1934(ra) # 8000366e <end_op>
  return 0;
    80004e04:	4501                	li	a0,0
    80004e06:	a031                	j	80004e12 <sys_mknod+0x80>
    end_op();
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	866080e7          	jalr	-1946(ra) # 8000366e <end_op>
    return -1;
    80004e10:	557d                	li	a0,-1
}
    80004e12:	60ea                	ld	ra,152(sp)
    80004e14:	644a                	ld	s0,144(sp)
    80004e16:	610d                	addi	sp,sp,160
    80004e18:	8082                	ret

0000000080004e1a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e1a:	7135                	addi	sp,sp,-160
    80004e1c:	ed06                	sd	ra,152(sp)
    80004e1e:	e922                	sd	s0,144(sp)
    80004e20:	e526                	sd	s1,136(sp)
    80004e22:	e14a                	sd	s2,128(sp)
    80004e24:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e26:	ffffc097          	auipc	ra,0xffffc
    80004e2a:	004080e7          	jalr	4(ra) # 80000e2a <myproc>
    80004e2e:	892a                	mv	s2,a0
  
  begin_op();
    80004e30:	ffffe097          	auipc	ra,0xffffe
    80004e34:	7c0080e7          	jalr	1984(ra) # 800035f0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e38:	08000613          	li	a2,128
    80004e3c:	f6040593          	addi	a1,s0,-160
    80004e40:	4501                	li	a0,0
    80004e42:	ffffd097          	auipc	ra,0xffffd
    80004e46:	2a4080e7          	jalr	676(ra) # 800020e6 <argstr>
    80004e4a:	04054b63          	bltz	a0,80004ea0 <sys_chdir+0x86>
    80004e4e:	f6040513          	addi	a0,s0,-160
    80004e52:	ffffe097          	auipc	ra,0xffffe
    80004e56:	57e080e7          	jalr	1406(ra) # 800033d0 <namei>
    80004e5a:	84aa                	mv	s1,a0
    80004e5c:	c131                	beqz	a0,80004ea0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e5e:	ffffe097          	auipc	ra,0xffffe
    80004e62:	db6080e7          	jalr	-586(ra) # 80002c14 <ilock>
  if(ip->type != T_DIR){
    80004e66:	04449703          	lh	a4,68(s1)
    80004e6a:	4785                	li	a5,1
    80004e6c:	04f71063          	bne	a4,a5,80004eac <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e70:	8526                	mv	a0,s1
    80004e72:	ffffe097          	auipc	ra,0xffffe
    80004e76:	e64080e7          	jalr	-412(ra) # 80002cd6 <iunlock>
  iput(p->cwd);
    80004e7a:	15093503          	ld	a0,336(s2)
    80004e7e:	ffffe097          	auipc	ra,0xffffe
    80004e82:	f50080e7          	jalr	-176(ra) # 80002dce <iput>
  end_op();
    80004e86:	ffffe097          	auipc	ra,0xffffe
    80004e8a:	7e8080e7          	jalr	2024(ra) # 8000366e <end_op>
  p->cwd = ip;
    80004e8e:	14993823          	sd	s1,336(s2)
  return 0;
    80004e92:	4501                	li	a0,0
}
    80004e94:	60ea                	ld	ra,152(sp)
    80004e96:	644a                	ld	s0,144(sp)
    80004e98:	64aa                	ld	s1,136(sp)
    80004e9a:	690a                	ld	s2,128(sp)
    80004e9c:	610d                	addi	sp,sp,160
    80004e9e:	8082                	ret
    end_op();
    80004ea0:	ffffe097          	auipc	ra,0xffffe
    80004ea4:	7ce080e7          	jalr	1998(ra) # 8000366e <end_op>
    return -1;
    80004ea8:	557d                	li	a0,-1
    80004eaa:	b7ed                	j	80004e94 <sys_chdir+0x7a>
    iunlockput(ip);
    80004eac:	8526                	mv	a0,s1
    80004eae:	ffffe097          	auipc	ra,0xffffe
    80004eb2:	fc8080e7          	jalr	-56(ra) # 80002e76 <iunlockput>
    end_op();
    80004eb6:	ffffe097          	auipc	ra,0xffffe
    80004eba:	7b8080e7          	jalr	1976(ra) # 8000366e <end_op>
    return -1;
    80004ebe:	557d                	li	a0,-1
    80004ec0:	bfd1                	j	80004e94 <sys_chdir+0x7a>

0000000080004ec2 <sys_exec>:

uint64
sys_exec(void)
{
    80004ec2:	7145                	addi	sp,sp,-464
    80004ec4:	e786                	sd	ra,456(sp)
    80004ec6:	e3a2                	sd	s0,448(sp)
    80004ec8:	ff26                	sd	s1,440(sp)
    80004eca:	fb4a                	sd	s2,432(sp)
    80004ecc:	f74e                	sd	s3,424(sp)
    80004ece:	f352                	sd	s4,416(sp)
    80004ed0:	ef56                	sd	s5,408(sp)
    80004ed2:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ed4:	08000613          	li	a2,128
    80004ed8:	f4040593          	addi	a1,s0,-192
    80004edc:	4501                	li	a0,0
    80004ede:	ffffd097          	auipc	ra,0xffffd
    80004ee2:	208080e7          	jalr	520(ra) # 800020e6 <argstr>
    return -1;
    80004ee6:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ee8:	0c054b63          	bltz	a0,80004fbe <sys_exec+0xfc>
    80004eec:	e3840593          	addi	a1,s0,-456
    80004ef0:	4505                	li	a0,1
    80004ef2:	ffffd097          	auipc	ra,0xffffd
    80004ef6:	1d2080e7          	jalr	466(ra) # 800020c4 <argaddr>
    80004efa:	0c054263          	bltz	a0,80004fbe <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004efe:	10000613          	li	a2,256
    80004f02:	4581                	li	a1,0
    80004f04:	e4040513          	addi	a0,s0,-448
    80004f08:	ffffb097          	auipc	ra,0xffffb
    80004f0c:	272080e7          	jalr	626(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f10:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f14:	89a6                	mv	s3,s1
    80004f16:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f18:	02000a13          	li	s4,32
    80004f1c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f20:	00391513          	slli	a0,s2,0x3
    80004f24:	e3040593          	addi	a1,s0,-464
    80004f28:	e3843783          	ld	a5,-456(s0)
    80004f2c:	953e                	add	a0,a0,a5
    80004f2e:	ffffd097          	auipc	ra,0xffffd
    80004f32:	0da080e7          	jalr	218(ra) # 80002008 <fetchaddr>
    80004f36:	02054a63          	bltz	a0,80004f6a <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004f3a:	e3043783          	ld	a5,-464(s0)
    80004f3e:	c3b9                	beqz	a5,80004f84 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f40:	ffffb097          	auipc	ra,0xffffb
    80004f44:	1da080e7          	jalr	474(ra) # 8000011a <kalloc>
    80004f48:	85aa                	mv	a1,a0
    80004f4a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f4e:	cd11                	beqz	a0,80004f6a <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f50:	6605                	lui	a2,0x1
    80004f52:	e3043503          	ld	a0,-464(s0)
    80004f56:	ffffd097          	auipc	ra,0xffffd
    80004f5a:	104080e7          	jalr	260(ra) # 8000205a <fetchstr>
    80004f5e:	00054663          	bltz	a0,80004f6a <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f62:	0905                	addi	s2,s2,1
    80004f64:	09a1                	addi	s3,s3,8
    80004f66:	fb491be3          	bne	s2,s4,80004f1c <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f6a:	f4040913          	addi	s2,s0,-192
    80004f6e:	6088                	ld	a0,0(s1)
    80004f70:	c531                	beqz	a0,80004fbc <sys_exec+0xfa>
    kfree(argv[i]);
    80004f72:	ffffb097          	auipc	ra,0xffffb
    80004f76:	0aa080e7          	jalr	170(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f7a:	04a1                	addi	s1,s1,8
    80004f7c:	ff2499e3          	bne	s1,s2,80004f6e <sys_exec+0xac>
  return -1;
    80004f80:	597d                	li	s2,-1
    80004f82:	a835                	j	80004fbe <sys_exec+0xfc>
      argv[i] = 0;
    80004f84:	0a8e                	slli	s5,s5,0x3
    80004f86:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffcad80>
    80004f8a:	00878ab3          	add	s5,a5,s0
    80004f8e:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f92:	e4040593          	addi	a1,s0,-448
    80004f96:	f4040513          	addi	a0,s0,-192
    80004f9a:	fffff097          	auipc	ra,0xfffff
    80004f9e:	172080e7          	jalr	370(ra) # 8000410c <exec>
    80004fa2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fa4:	f4040993          	addi	s3,s0,-192
    80004fa8:	6088                	ld	a0,0(s1)
    80004faa:	c911                	beqz	a0,80004fbe <sys_exec+0xfc>
    kfree(argv[i]);
    80004fac:	ffffb097          	auipc	ra,0xffffb
    80004fb0:	070080e7          	jalr	112(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fb4:	04a1                	addi	s1,s1,8
    80004fb6:	ff3499e3          	bne	s1,s3,80004fa8 <sys_exec+0xe6>
    80004fba:	a011                	j	80004fbe <sys_exec+0xfc>
  return -1;
    80004fbc:	597d                	li	s2,-1
}
    80004fbe:	854a                	mv	a0,s2
    80004fc0:	60be                	ld	ra,456(sp)
    80004fc2:	641e                	ld	s0,448(sp)
    80004fc4:	74fa                	ld	s1,440(sp)
    80004fc6:	795a                	ld	s2,432(sp)
    80004fc8:	79ba                	ld	s3,424(sp)
    80004fca:	7a1a                	ld	s4,416(sp)
    80004fcc:	6afa                	ld	s5,408(sp)
    80004fce:	6179                	addi	sp,sp,464
    80004fd0:	8082                	ret

0000000080004fd2 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fd2:	7139                	addi	sp,sp,-64
    80004fd4:	fc06                	sd	ra,56(sp)
    80004fd6:	f822                	sd	s0,48(sp)
    80004fd8:	f426                	sd	s1,40(sp)
    80004fda:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fdc:	ffffc097          	auipc	ra,0xffffc
    80004fe0:	e4e080e7          	jalr	-434(ra) # 80000e2a <myproc>
    80004fe4:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004fe6:	fd840593          	addi	a1,s0,-40
    80004fea:	4501                	li	a0,0
    80004fec:	ffffd097          	auipc	ra,0xffffd
    80004ff0:	0d8080e7          	jalr	216(ra) # 800020c4 <argaddr>
    return -1;
    80004ff4:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004ff6:	0e054063          	bltz	a0,800050d6 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004ffa:	fc840593          	addi	a1,s0,-56
    80004ffe:	fd040513          	addi	a0,s0,-48
    80005002:	fffff097          	auipc	ra,0xfffff
    80005006:	de6080e7          	jalr	-538(ra) # 80003de8 <pipealloc>
    return -1;
    8000500a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000500c:	0c054563          	bltz	a0,800050d6 <sys_pipe+0x104>
  fd0 = -1;
    80005010:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005014:	fd043503          	ld	a0,-48(s0)
    80005018:	fffff097          	auipc	ra,0xfffff
    8000501c:	504080e7          	jalr	1284(ra) # 8000451c <fdalloc>
    80005020:	fca42223          	sw	a0,-60(s0)
    80005024:	08054c63          	bltz	a0,800050bc <sys_pipe+0xea>
    80005028:	fc843503          	ld	a0,-56(s0)
    8000502c:	fffff097          	auipc	ra,0xfffff
    80005030:	4f0080e7          	jalr	1264(ra) # 8000451c <fdalloc>
    80005034:	fca42023          	sw	a0,-64(s0)
    80005038:	06054963          	bltz	a0,800050aa <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000503c:	4691                	li	a3,4
    8000503e:	fc440613          	addi	a2,s0,-60
    80005042:	fd843583          	ld	a1,-40(s0)
    80005046:	68a8                	ld	a0,80(s1)
    80005048:	ffffc097          	auipc	ra,0xffffc
    8000504c:	aa6080e7          	jalr	-1370(ra) # 80000aee <copyout>
    80005050:	02054063          	bltz	a0,80005070 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005054:	4691                	li	a3,4
    80005056:	fc040613          	addi	a2,s0,-64
    8000505a:	fd843583          	ld	a1,-40(s0)
    8000505e:	0591                	addi	a1,a1,4
    80005060:	68a8                	ld	a0,80(s1)
    80005062:	ffffc097          	auipc	ra,0xffffc
    80005066:	a8c080e7          	jalr	-1396(ra) # 80000aee <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000506a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000506c:	06055563          	bgez	a0,800050d6 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005070:	fc442783          	lw	a5,-60(s0)
    80005074:	07e9                	addi	a5,a5,26
    80005076:	078e                	slli	a5,a5,0x3
    80005078:	97a6                	add	a5,a5,s1
    8000507a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000507e:	fc042783          	lw	a5,-64(s0)
    80005082:	07e9                	addi	a5,a5,26
    80005084:	078e                	slli	a5,a5,0x3
    80005086:	00f48533          	add	a0,s1,a5
    8000508a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000508e:	fd043503          	ld	a0,-48(s0)
    80005092:	fffff097          	auipc	ra,0xfffff
    80005096:	a26080e7          	jalr	-1498(ra) # 80003ab8 <fileclose>
    fileclose(wf);
    8000509a:	fc843503          	ld	a0,-56(s0)
    8000509e:	fffff097          	auipc	ra,0xfffff
    800050a2:	a1a080e7          	jalr	-1510(ra) # 80003ab8 <fileclose>
    return -1;
    800050a6:	57fd                	li	a5,-1
    800050a8:	a03d                	j	800050d6 <sys_pipe+0x104>
    if(fd0 >= 0)
    800050aa:	fc442783          	lw	a5,-60(s0)
    800050ae:	0007c763          	bltz	a5,800050bc <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800050b2:	07e9                	addi	a5,a5,26
    800050b4:	078e                	slli	a5,a5,0x3
    800050b6:	97a6                	add	a5,a5,s1
    800050b8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800050bc:	fd043503          	ld	a0,-48(s0)
    800050c0:	fffff097          	auipc	ra,0xfffff
    800050c4:	9f8080e7          	jalr	-1544(ra) # 80003ab8 <fileclose>
    fileclose(wf);
    800050c8:	fc843503          	ld	a0,-56(s0)
    800050cc:	fffff097          	auipc	ra,0xfffff
    800050d0:	9ec080e7          	jalr	-1556(ra) # 80003ab8 <fileclose>
    return -1;
    800050d4:	57fd                	li	a5,-1
}
    800050d6:	853e                	mv	a0,a5
    800050d8:	70e2                	ld	ra,56(sp)
    800050da:	7442                	ld	s0,48(sp)
    800050dc:	74a2                	ld	s1,40(sp)
    800050de:	6121                	addi	sp,sp,64
    800050e0:	8082                	ret

00000000800050e2 <findmap>:
    }
  }
  return -1;
}
int findmap(uint64 addr)
{
    800050e2:	1101                	addi	sp,sp,-32
    800050e4:	ec06                	sd	ra,24(sp)
    800050e6:	e822                	sd	s0,16(sp)
    800050e8:	e426                	sd	s1,8(sp)
    800050ea:	1000                	addi	s0,sp,32
    800050ec:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800050ee:	ffffc097          	auipc	ra,0xffffc
    800050f2:	d3c080e7          	jalr	-708(ra) # 80000e2a <myproc>
  int i;
  for(i=0;i<16;i++)
    800050f6:	17850793          	addi	a5,a0,376
    800050fa:	4501                	li	a0,0
    800050fc:	46c1                	li	a3,16
    800050fe:	a031                	j	8000510a <findmap+0x28>
    80005100:	2505                	addiw	a0,a0,1
    80005102:	03878793          	addi	a5,a5,56
    80005106:	00d50963          	beq	a0,a3,80005118 <findmap+0x36>
  {
    uint64 a=p->map_region[i].mmapaddr;
    uint64 b=p->map_region[i].mmapend;
    if(addr>=a && addr<b){
    8000510a:	6398                	ld	a4,0(a5)
    8000510c:	fee4eae3          	bltu	s1,a4,80005100 <findmap+0x1e>
    80005110:	6798                	ld	a4,8(a5)
    80005112:	fee4f7e3          	bgeu	s1,a4,80005100 <findmap+0x1e>
    80005116:	a011                	j	8000511a <findmap+0x38>
      return i;
    }   
  }
  return -1;
    80005118:	557d                	li	a0,-1
}
    8000511a:	60e2                	ld	ra,24(sp)
    8000511c:	6442                	ld	s0,16(sp)
    8000511e:	64a2                	ld	s1,8(sp)
    80005120:	6105                	addi	sp,sp,32
    80005122:	8082                	ret

0000000080005124 <sys_mmap>:

uint64 sys_mmap(void)
{
    80005124:	715d                	addi	sp,sp,-80
    80005126:	e486                	sd	ra,72(sp)
    80005128:	e0a2                	sd	s0,64(sp)
    8000512a:	fc26                	sd	s1,56(sp)
    8000512c:	f84a                	sd	s2,48(sp)
    8000512e:	f44e                	sd	s3,40(sp)
    80005130:	f052                	sd	s4,32(sp)
    80005132:	ec56                	sd	s5,24(sp)
    80005134:	e85a                	sd	s6,16(sp)
    80005136:	e45e                	sd	s7,8(sp)
    80005138:	e062                	sd	s8,0(sp)
    8000513a:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    8000513c:	ffffc097          	auipc	ra,0xffffc
    80005140:	cee080e7          	jalr	-786(ra) # 80000e2a <myproc>
    80005144:	892a                	mv	s2,a0
  //传入参数
  uint64 fail=(uint64)((char*)-1);
  uint64 addr;
  uint64 length=p->trapframe->a1;
    80005146:	6d3c                	ld	a5,88(a0)
    80005148:	0787ba03          	ld	s4,120(a5)
  int prot=p->trapframe->a2;
    8000514c:	0807ac03          	lw	s8,128(a5)
  int flags=p->trapframe->a3;
    80005150:	0887ab83          	lw	s7,136(a5)
  int fd=p->trapframe->a4;

  //检查打开的文件。如果是read-only文件开启了MAP_SHARED，则必须返回错误
  if((p->ofile[fd]->writable)==0 && (flags&MAP_SHARED)&&(prot&PROT_WRITE)){
    80005154:	0907aa83          	lw	s5,144(a5)
    80005158:	0a8e                	slli	s5,s5,0x3
    8000515a:	9aaa                	add	s5,s5,a0
    8000515c:	0d0ab783          	ld	a5,208(s5)
    80005160:	0097c783          	lbu	a5,9(a5)
    80005164:	eb81                	bnez	a5,80005174 <sys_mmap+0x50>
    80005166:	001bf793          	andi	a5,s7,1
    8000516a:	c789                	beqz	a5,80005174 <sys_mmap+0x50>
    8000516c:	002c7793          	andi	a5,s8,2
    return fail;
    80005170:	557d                	li	a0,-1
  if((p->ofile[fd]->writable)==0 && (flags&MAP_SHARED)&&(prot&PROT_WRITE)){
    80005172:	ebbd                	bnez	a5,800051e8 <sys_mmap+0xc4>
  struct proc *p = myproc();
    80005174:	ffffc097          	auipc	ra,0xffffc
    80005178:	cb6080e7          	jalr	-842(ra) # 80000e2a <myproc>
  for(i = 0; i < NOFILE; i++){
    8000517c:	19850793          	addi	a5,a0,408
    80005180:	4481                	li	s1,0
    80005182:	46c1                	li	a3,16
    if(p->map_region[i].valid == 0){
    80005184:	4398                	lw	a4,0(a5)
    80005186:	cf2d                	beqz	a4,80005200 <sys_mmap+0xdc>
  for(i = 0; i < NOFILE; i++){
    80005188:	2485                	addiw	s1,s1,1
    8000518a:	03878793          	addi	a5,a5,56
    8000518e:	fed49be3          	bne	s1,a3,80005184 <sys_mmap+0x60>
  return -1;
    80005192:	54fd                	li	s1,-1

  //在map_region里面找到一个空位
  int idx=mapalloc();
  //printf("%d idx\n",idx);
  //初始化
  p->map_region[idx].mmlength=length;
    80005194:	00349b13          	slli	s6,s1,0x3
    80005198:	409b09b3          	sub	s3,s6,s1
    8000519c:	098e                	slli	s3,s3,0x3
    8000519e:	99ca                	add	s3,s3,s2
    800051a0:	1949b423          	sd	s4,392(s3)
  p->map_region[idx].mmprot=prot;
    800051a4:	1989a823          	sw	s8,400(s3)
  p->map_region[idx].mmflag=flags;
    800051a8:	1979aa23          	sw	s7,404(s3)
  p->map_region[idx].mmapfile=p->ofile[fd];
    800051ac:	0d0ab503          	ld	a0,208(s5)
    800051b0:	16a9b423          	sd	a0,360(s3)
  p->map_region[idx].ip=p->ofile[fd]->ip;
    800051b4:	6d1c                	ld	a5,24(a0)
    800051b6:	16f9b823          	sd	a5,368(s3)
  //file ref++
  filedup(p->ofile[fd]);
    800051ba:	fffff097          	auipc	ra,0xfffff
    800051be:	8ac080e7          	jalr	-1876(ra) # 80003a66 <filedup>

  //寻找一个地址
  addr=PGROUNDUP(p->sz);
    800051c2:	04893783          	ld	a5,72(s2)
    800051c6:	6705                	lui	a4,0x1
    800051c8:	177d                	addi	a4,a4,-1 # fff <_entry-0x7ffff001>
    800051ca:	00e78533          	add	a0,a5,a4
    800051ce:	76fd                	lui	a3,0xfffff
    800051d0:	8d75                	and	a0,a0,a3
  p->sz+=PGROUNDUP(length);
    800051d2:	9a3a                	add	s4,s4,a4
    800051d4:	00da7a33          	and	s4,s4,a3
    800051d8:	97d2                	add	a5,a5,s4
    800051da:	04f93423          	sd	a5,72(s2)
  //p确定mmap的范围
  p->map_region[idx].mmapaddr=addr;
    800051de:	16a9bc23          	sd	a0,376(s3)
  p->map_region[idx].mmapend=addr+PGROUNDUP(length);
    800051e2:	9a2a                	add	s4,s4,a0
    800051e4:	1949b023          	sd	s4,384(s3)
  //printf("mmap range %p---%p\n",p->map_region[idx].mmapaddr,p->map_region[idx].mmapend);
  return addr;
}
    800051e8:	60a6                	ld	ra,72(sp)
    800051ea:	6406                	ld	s0,64(sp)
    800051ec:	74e2                	ld	s1,56(sp)
    800051ee:	7942                	ld	s2,48(sp)
    800051f0:	79a2                	ld	s3,40(sp)
    800051f2:	7a02                	ld	s4,32(sp)
    800051f4:	6ae2                	ld	s5,24(sp)
    800051f6:	6b42                	ld	s6,16(sp)
    800051f8:	6ba2                	ld	s7,8(sp)
    800051fa:	6c02                	ld	s8,0(sp)
    800051fc:	6161                	addi	sp,sp,80
    800051fe:	8082                	ret
      p->map_region[i].valid=1;
    80005200:	00349793          	slli	a5,s1,0x3
    80005204:	8f85                	sub	a5,a5,s1
    80005206:	078e                	slli	a5,a5,0x3
    80005208:	953e                	add	a0,a0,a5
    8000520a:	4785                	li	a5,1
    8000520c:	18f52c23          	sw	a5,408(a0)
      return i;
    80005210:	b751                	j	80005194 <sys_mmap+0x70>

0000000080005212 <sys_munmap>:

uint64 sys_munmap(void)
{
    80005212:	7139                	addi	sp,sp,-64
    80005214:	fc06                	sd	ra,56(sp)
    80005216:	f822                	sd	s0,48(sp)
    80005218:	f426                	sd	s1,40(sp)
    8000521a:	f04a                	sd	s2,32(sp)
    8000521c:	ec4e                	sd	s3,24(sp)
    8000521e:	e852                	sd	s4,16(sp)
    80005220:	e456                	sd	s5,8(sp)
    80005222:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80005224:	ffffc097          	auipc	ra,0xffffc
    80005228:	c06080e7          	jalr	-1018(ra) # 80000e2a <myproc>
    8000522c:	89aa                	mv	s3,a0
  uint64 addr=p->trapframe->a0;
    8000522e:	6d3c                	ld	a5,88(a0)
    80005230:	0707ba83          	ld	s5,112(a5)
  uint64 length=p->trapframe->a1;
    80005234:	0787ba03          	ld	s4,120(a5)
  //printf("unmap %p:addr %p:length\n",addr,length);
  int idx=findmap(addr);
    80005238:	8556                	mv	a0,s5
    8000523a:	00000097          	auipc	ra,0x0
    8000523e:	ea8080e7          	jalr	-344(ra) # 800050e2 <findmap>
  if(idx<0)
    80005242:	0a054c63          	bltz	a0,800052fa <sys_munmap+0xe8>
    80005246:	84aa                	mv	s1,a0
  {
    return -1;
  }
  int npages=PGROUNDUP(length)/PGSIZE;
    80005248:	6905                	lui	s2,0x1
    8000524a:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    8000524c:	9952                	add	s2,s2,s4
    8000524e:	00c95913          	srli	s2,s2,0xc
    80005252:	2901                	sext.w	s2,s2
  //如果设置了MAP_SHARED
  if(p->map_region[idx].mmflag & MAP_SHARED)
    80005254:	00351793          	slli	a5,a0,0x3
    80005258:	8f89                	sub	a5,a5,a0
    8000525a:	078e                	slli	a5,a5,0x3
    8000525c:	97ce                	add	a5,a5,s3
    8000525e:	1947a783          	lw	a5,404(a5)
    80005262:	8b85                	andi	a5,a5,1
    80005264:	e3b1                	bnez	a5,800052a8 <sys_munmap+0x96>
  {
    //printf("reach here1\n");
    filewrite(p->map_region[idx].mmapfile, addr, length);
  }
  //printf("reach here2\n");
  uvmunmap(p->pagetable,addr,npages,1);
    80005266:	4685                	li	a3,1
    80005268:	864a                	mv	a2,s2
    8000526a:	85d6                	mv	a1,s5
    8000526c:	0509b503          	ld	a0,80(s3)
    80005270:	ffffb097          	auipc	ra,0xffffb
    80005274:	498080e7          	jalr	1176(ra) # 80000708 <uvmunmap>

  p->map_region[idx].mmlength-=length;
    80005278:	00349793          	slli	a5,s1,0x3
    8000527c:	8f85                	sub	a5,a5,s1
    8000527e:	078e                	slli	a5,a5,0x3
    80005280:	97ce                	add	a5,a5,s3
    80005282:	1887b903          	ld	s2,392(a5)
    80005286:	41490933          	sub	s2,s2,s4
    8000528a:	1927b423          	sd	s2,392(a5)
  if(p->map_region[idx].mmlength==0)
    8000528e:	02090c63          	beqz	s2,800052c6 <sys_munmap+0xb4>
    fileclose(p->map_region[idx].mmapfile);
  //清除表项
    memset((void*)&p->map_region[idx],0,sizeof(vma));
  }

  return 0;
    80005292:	4901                	li	s2,0
}
    80005294:	854a                	mv	a0,s2
    80005296:	70e2                	ld	ra,56(sp)
    80005298:	7442                	ld	s0,48(sp)
    8000529a:	74a2                	ld	s1,40(sp)
    8000529c:	7902                	ld	s2,32(sp)
    8000529e:	69e2                	ld	s3,24(sp)
    800052a0:	6a42                	ld	s4,16(sp)
    800052a2:	6aa2                	ld	s5,8(sp)
    800052a4:	6121                	addi	sp,sp,64
    800052a6:	8082                	ret
    filewrite(p->map_region[idx].mmapfile, addr, length);
    800052a8:	00351793          	slli	a5,a0,0x3
    800052ac:	8f89                	sub	a5,a5,a0
    800052ae:	078e                	slli	a5,a5,0x3
    800052b0:	97ce                	add	a5,a5,s3
    800052b2:	000a061b          	sext.w	a2,s4
    800052b6:	85d6                	mv	a1,s5
    800052b8:	1687b503          	ld	a0,360(a5)
    800052bc:	fffff097          	auipc	ra,0xfffff
    800052c0:	9f8080e7          	jalr	-1544(ra) # 80003cb4 <filewrite>
    800052c4:	b74d                	j	80005266 <sys_munmap+0x54>
    fileclose(p->map_region[idx].mmapfile);
    800052c6:	00349a13          	slli	s4,s1,0x3
    800052ca:	409a07b3          	sub	a5,s4,s1
    800052ce:	078e                	slli	a5,a5,0x3
    800052d0:	97ce                	add	a5,a5,s3
    800052d2:	1687b503          	ld	a0,360(a5)
    800052d6:	ffffe097          	auipc	ra,0xffffe
    800052da:	7e2080e7          	jalr	2018(ra) # 80003ab8 <fileclose>
    memset((void*)&p->map_region[idx],0,sizeof(vma));
    800052de:	409a0533          	sub	a0,s4,s1
    800052e2:	050e                	slli	a0,a0,0x3
    800052e4:	16850513          	addi	a0,a0,360
    800052e8:	03800613          	li	a2,56
    800052ec:	4581                	li	a1,0
    800052ee:	954e                	add	a0,a0,s3
    800052f0:	ffffb097          	auipc	ra,0xffffb
    800052f4:	e8a080e7          	jalr	-374(ra) # 8000017a <memset>
    800052f8:	bf71                	j	80005294 <sys_munmap+0x82>
    return -1;
    800052fa:	597d                	li	s2,-1
    800052fc:	bf61                	j	80005294 <sys_munmap+0x82>
	...

0000000080005300 <kernelvec>:
    80005300:	7111                	addi	sp,sp,-256
    80005302:	e006                	sd	ra,0(sp)
    80005304:	e40a                	sd	sp,8(sp)
    80005306:	e80e                	sd	gp,16(sp)
    80005308:	ec12                	sd	tp,24(sp)
    8000530a:	f016                	sd	t0,32(sp)
    8000530c:	f41a                	sd	t1,40(sp)
    8000530e:	f81e                	sd	t2,48(sp)
    80005310:	fc22                	sd	s0,56(sp)
    80005312:	e0a6                	sd	s1,64(sp)
    80005314:	e4aa                	sd	a0,72(sp)
    80005316:	e8ae                	sd	a1,80(sp)
    80005318:	ecb2                	sd	a2,88(sp)
    8000531a:	f0b6                	sd	a3,96(sp)
    8000531c:	f4ba                	sd	a4,104(sp)
    8000531e:	f8be                	sd	a5,112(sp)
    80005320:	fcc2                	sd	a6,120(sp)
    80005322:	e146                	sd	a7,128(sp)
    80005324:	e54a                	sd	s2,136(sp)
    80005326:	e94e                	sd	s3,144(sp)
    80005328:	ed52                	sd	s4,152(sp)
    8000532a:	f156                	sd	s5,160(sp)
    8000532c:	f55a                	sd	s6,168(sp)
    8000532e:	f95e                	sd	s7,176(sp)
    80005330:	fd62                	sd	s8,184(sp)
    80005332:	e1e6                	sd	s9,192(sp)
    80005334:	e5ea                	sd	s10,200(sp)
    80005336:	e9ee                	sd	s11,208(sp)
    80005338:	edf2                	sd	t3,216(sp)
    8000533a:	f1f6                	sd	t4,224(sp)
    8000533c:	f5fa                	sd	t5,232(sp)
    8000533e:	f9fe                	sd	t6,240(sp)
    80005340:	b95fc0ef          	jal	ra,80001ed4 <kerneltrap>
    80005344:	6082                	ld	ra,0(sp)
    80005346:	6122                	ld	sp,8(sp)
    80005348:	61c2                	ld	gp,16(sp)
    8000534a:	7282                	ld	t0,32(sp)
    8000534c:	7322                	ld	t1,40(sp)
    8000534e:	73c2                	ld	t2,48(sp)
    80005350:	7462                	ld	s0,56(sp)
    80005352:	6486                	ld	s1,64(sp)
    80005354:	6526                	ld	a0,72(sp)
    80005356:	65c6                	ld	a1,80(sp)
    80005358:	6666                	ld	a2,88(sp)
    8000535a:	7686                	ld	a3,96(sp)
    8000535c:	7726                	ld	a4,104(sp)
    8000535e:	77c6                	ld	a5,112(sp)
    80005360:	7866                	ld	a6,120(sp)
    80005362:	688a                	ld	a7,128(sp)
    80005364:	692a                	ld	s2,136(sp)
    80005366:	69ca                	ld	s3,144(sp)
    80005368:	6a6a                	ld	s4,152(sp)
    8000536a:	7a8a                	ld	s5,160(sp)
    8000536c:	7b2a                	ld	s6,168(sp)
    8000536e:	7bca                	ld	s7,176(sp)
    80005370:	7c6a                	ld	s8,184(sp)
    80005372:	6c8e                	ld	s9,192(sp)
    80005374:	6d2e                	ld	s10,200(sp)
    80005376:	6dce                	ld	s11,208(sp)
    80005378:	6e6e                	ld	t3,216(sp)
    8000537a:	7e8e                	ld	t4,224(sp)
    8000537c:	7f2e                	ld	t5,232(sp)
    8000537e:	7fce                	ld	t6,240(sp)
    80005380:	6111                	addi	sp,sp,256
    80005382:	10200073          	sret
    80005386:	00000013          	nop
    8000538a:	00000013          	nop
    8000538e:	0001                	nop

0000000080005390 <timervec>:
    80005390:	34051573          	csrrw	a0,mscratch,a0
    80005394:	e10c                	sd	a1,0(a0)
    80005396:	e510                	sd	a2,8(a0)
    80005398:	e914                	sd	a3,16(a0)
    8000539a:	6d0c                	ld	a1,24(a0)
    8000539c:	7110                	ld	a2,32(a0)
    8000539e:	6194                	ld	a3,0(a1)
    800053a0:	96b2                	add	a3,a3,a2
    800053a2:	e194                	sd	a3,0(a1)
    800053a4:	4589                	li	a1,2
    800053a6:	14459073          	csrw	sip,a1
    800053aa:	6914                	ld	a3,16(a0)
    800053ac:	6510                	ld	a2,8(a0)
    800053ae:	610c                	ld	a1,0(a0)
    800053b0:	34051573          	csrrw	a0,mscratch,a0
    800053b4:	30200073          	mret
	...

00000000800053ba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800053ba:	1141                	addi	sp,sp,-16
    800053bc:	e422                	sd	s0,8(sp)
    800053be:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800053c0:	0c0007b7          	lui	a5,0xc000
    800053c4:	4705                	li	a4,1
    800053c6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800053c8:	c3d8                	sw	a4,4(a5)
}
    800053ca:	6422                	ld	s0,8(sp)
    800053cc:	0141                	addi	sp,sp,16
    800053ce:	8082                	ret

00000000800053d0 <plicinithart>:

void
plicinithart(void)
{
    800053d0:	1141                	addi	sp,sp,-16
    800053d2:	e406                	sd	ra,8(sp)
    800053d4:	e022                	sd	s0,0(sp)
    800053d6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053d8:	ffffc097          	auipc	ra,0xffffc
    800053dc:	a26080e7          	jalr	-1498(ra) # 80000dfe <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053e0:	0085171b          	slliw	a4,a0,0x8
    800053e4:	0c0027b7          	lui	a5,0xc002
    800053e8:	97ba                	add	a5,a5,a4
    800053ea:	40200713          	li	a4,1026
    800053ee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053f2:	00d5151b          	slliw	a0,a0,0xd
    800053f6:	0c2017b7          	lui	a5,0xc201
    800053fa:	97aa                	add	a5,a5,a0
    800053fc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005400:	60a2                	ld	ra,8(sp)
    80005402:	6402                	ld	s0,0(sp)
    80005404:	0141                	addi	sp,sp,16
    80005406:	8082                	ret

0000000080005408 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005408:	1141                	addi	sp,sp,-16
    8000540a:	e406                	sd	ra,8(sp)
    8000540c:	e022                	sd	s0,0(sp)
    8000540e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005410:	ffffc097          	auipc	ra,0xffffc
    80005414:	9ee080e7          	jalr	-1554(ra) # 80000dfe <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005418:	00d5151b          	slliw	a0,a0,0xd
    8000541c:	0c2017b7          	lui	a5,0xc201
    80005420:	97aa                	add	a5,a5,a0
  return irq;
}
    80005422:	43c8                	lw	a0,4(a5)
    80005424:	60a2                	ld	ra,8(sp)
    80005426:	6402                	ld	s0,0(sp)
    80005428:	0141                	addi	sp,sp,16
    8000542a:	8082                	ret

000000008000542c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000542c:	1101                	addi	sp,sp,-32
    8000542e:	ec06                	sd	ra,24(sp)
    80005430:	e822                	sd	s0,16(sp)
    80005432:	e426                	sd	s1,8(sp)
    80005434:	1000                	addi	s0,sp,32
    80005436:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005438:	ffffc097          	auipc	ra,0xffffc
    8000543c:	9c6080e7          	jalr	-1594(ra) # 80000dfe <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005440:	00d5151b          	slliw	a0,a0,0xd
    80005444:	0c2017b7          	lui	a5,0xc201
    80005448:	97aa                	add	a5,a5,a0
    8000544a:	c3c4                	sw	s1,4(a5)
}
    8000544c:	60e2                	ld	ra,24(sp)
    8000544e:	6442                	ld	s0,16(sp)
    80005450:	64a2                	ld	s1,8(sp)
    80005452:	6105                	addi	sp,sp,32
    80005454:	8082                	ret

0000000080005456 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005456:	1141                	addi	sp,sp,-16
    80005458:	e406                	sd	ra,8(sp)
    8000545a:	e022                	sd	s0,0(sp)
    8000545c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000545e:	479d                	li	a5,7
    80005460:	06a7c863          	blt	a5,a0,800054d0 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005464:	00024717          	auipc	a4,0x24
    80005468:	b9c70713          	addi	a4,a4,-1124 # 80029000 <disk>
    8000546c:	972a                	add	a4,a4,a0
    8000546e:	6789                	lui	a5,0x2
    80005470:	97ba                	add	a5,a5,a4
    80005472:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005476:	e7ad                	bnez	a5,800054e0 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005478:	00451793          	slli	a5,a0,0x4
    8000547c:	00026717          	auipc	a4,0x26
    80005480:	b8470713          	addi	a4,a4,-1148 # 8002b000 <disk+0x2000>
    80005484:	6314                	ld	a3,0(a4)
    80005486:	96be                	add	a3,a3,a5
    80005488:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffcadc0>
  disk.desc[i].len = 0;
    8000548c:	6314                	ld	a3,0(a4)
    8000548e:	96be                	add	a3,a3,a5
    80005490:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005494:	6314                	ld	a3,0(a4)
    80005496:	96be                	add	a3,a3,a5
    80005498:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000549c:	6318                	ld	a4,0(a4)
    8000549e:	97ba                	add	a5,a5,a4
    800054a0:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800054a4:	00024717          	auipc	a4,0x24
    800054a8:	b5c70713          	addi	a4,a4,-1188 # 80029000 <disk>
    800054ac:	972a                	add	a4,a4,a0
    800054ae:	6789                	lui	a5,0x2
    800054b0:	97ba                	add	a5,a5,a4
    800054b2:	4705                	li	a4,1
    800054b4:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800054b8:	00026517          	auipc	a0,0x26
    800054bc:	b6050513          	addi	a0,a0,-1184 # 8002b018 <disk+0x2018>
    800054c0:	ffffc097          	auipc	ra,0xffffc
    800054c4:	1ba080e7          	jalr	442(ra) # 8000167a <wakeup>
}
    800054c8:	60a2                	ld	ra,8(sp)
    800054ca:	6402                	ld	s0,0(sp)
    800054cc:	0141                	addi	sp,sp,16
    800054ce:	8082                	ret
    panic("free_desc 1");
    800054d0:	00003517          	auipc	a0,0x3
    800054d4:	20050513          	addi	a0,a0,512 # 800086d0 <syscalls+0x330>
    800054d8:	00001097          	auipc	ra,0x1
    800054dc:	9c8080e7          	jalr	-1592(ra) # 80005ea0 <panic>
    panic("free_desc 2");
    800054e0:	00003517          	auipc	a0,0x3
    800054e4:	20050513          	addi	a0,a0,512 # 800086e0 <syscalls+0x340>
    800054e8:	00001097          	auipc	ra,0x1
    800054ec:	9b8080e7          	jalr	-1608(ra) # 80005ea0 <panic>

00000000800054f0 <virtio_disk_init>:
{
    800054f0:	1101                	addi	sp,sp,-32
    800054f2:	ec06                	sd	ra,24(sp)
    800054f4:	e822                	sd	s0,16(sp)
    800054f6:	e426                	sd	s1,8(sp)
    800054f8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054fa:	00003597          	auipc	a1,0x3
    800054fe:	1f658593          	addi	a1,a1,502 # 800086f0 <syscalls+0x350>
    80005502:	00026517          	auipc	a0,0x26
    80005506:	c2650513          	addi	a0,a0,-986 # 8002b128 <disk+0x2128>
    8000550a:	00001097          	auipc	ra,0x1
    8000550e:	e3e080e7          	jalr	-450(ra) # 80006348 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005512:	100017b7          	lui	a5,0x10001
    80005516:	4398                	lw	a4,0(a5)
    80005518:	2701                	sext.w	a4,a4
    8000551a:	747277b7          	lui	a5,0x74727
    8000551e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005522:	0ef71063          	bne	a4,a5,80005602 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005526:	100017b7          	lui	a5,0x10001
    8000552a:	43dc                	lw	a5,4(a5)
    8000552c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000552e:	4705                	li	a4,1
    80005530:	0ce79963          	bne	a5,a4,80005602 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005534:	100017b7          	lui	a5,0x10001
    80005538:	479c                	lw	a5,8(a5)
    8000553a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000553c:	4709                	li	a4,2
    8000553e:	0ce79263          	bne	a5,a4,80005602 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005542:	100017b7          	lui	a5,0x10001
    80005546:	47d8                	lw	a4,12(a5)
    80005548:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000554a:	554d47b7          	lui	a5,0x554d4
    8000554e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005552:	0af71863          	bne	a4,a5,80005602 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005556:	100017b7          	lui	a5,0x10001
    8000555a:	4705                	li	a4,1
    8000555c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000555e:	470d                	li	a4,3
    80005560:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005562:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005564:	c7ffe6b7          	lui	a3,0xc7ffe
    80005568:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fca51f>
    8000556c:	8f75                	and	a4,a4,a3
    8000556e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005570:	472d                	li	a4,11
    80005572:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005574:	473d                	li	a4,15
    80005576:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005578:	6705                	lui	a4,0x1
    8000557a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000557c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005580:	5bdc                	lw	a5,52(a5)
    80005582:	2781                	sext.w	a5,a5
  if(max == 0)
    80005584:	c7d9                	beqz	a5,80005612 <virtio_disk_init+0x122>
  if(max < NUM)
    80005586:	471d                	li	a4,7
    80005588:	08f77d63          	bgeu	a4,a5,80005622 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000558c:	100014b7          	lui	s1,0x10001
    80005590:	47a1                	li	a5,8
    80005592:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005594:	6609                	lui	a2,0x2
    80005596:	4581                	li	a1,0
    80005598:	00024517          	auipc	a0,0x24
    8000559c:	a6850513          	addi	a0,a0,-1432 # 80029000 <disk>
    800055a0:	ffffb097          	auipc	ra,0xffffb
    800055a4:	bda080e7          	jalr	-1062(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800055a8:	00024717          	auipc	a4,0x24
    800055ac:	a5870713          	addi	a4,a4,-1448 # 80029000 <disk>
    800055b0:	00c75793          	srli	a5,a4,0xc
    800055b4:	2781                	sext.w	a5,a5
    800055b6:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800055b8:	00026797          	auipc	a5,0x26
    800055bc:	a4878793          	addi	a5,a5,-1464 # 8002b000 <disk+0x2000>
    800055c0:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800055c2:	00024717          	auipc	a4,0x24
    800055c6:	abe70713          	addi	a4,a4,-1346 # 80029080 <disk+0x80>
    800055ca:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800055cc:	00025717          	auipc	a4,0x25
    800055d0:	a3470713          	addi	a4,a4,-1484 # 8002a000 <disk+0x1000>
    800055d4:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800055d6:	4705                	li	a4,1
    800055d8:	00e78c23          	sb	a4,24(a5)
    800055dc:	00e78ca3          	sb	a4,25(a5)
    800055e0:	00e78d23          	sb	a4,26(a5)
    800055e4:	00e78da3          	sb	a4,27(a5)
    800055e8:	00e78e23          	sb	a4,28(a5)
    800055ec:	00e78ea3          	sb	a4,29(a5)
    800055f0:	00e78f23          	sb	a4,30(a5)
    800055f4:	00e78fa3          	sb	a4,31(a5)
}
    800055f8:	60e2                	ld	ra,24(sp)
    800055fa:	6442                	ld	s0,16(sp)
    800055fc:	64a2                	ld	s1,8(sp)
    800055fe:	6105                	addi	sp,sp,32
    80005600:	8082                	ret
    panic("could not find virtio disk");
    80005602:	00003517          	auipc	a0,0x3
    80005606:	0fe50513          	addi	a0,a0,254 # 80008700 <syscalls+0x360>
    8000560a:	00001097          	auipc	ra,0x1
    8000560e:	896080e7          	jalr	-1898(ra) # 80005ea0 <panic>
    panic("virtio disk has no queue 0");
    80005612:	00003517          	auipc	a0,0x3
    80005616:	10e50513          	addi	a0,a0,270 # 80008720 <syscalls+0x380>
    8000561a:	00001097          	auipc	ra,0x1
    8000561e:	886080e7          	jalr	-1914(ra) # 80005ea0 <panic>
    panic("virtio disk max queue too short");
    80005622:	00003517          	auipc	a0,0x3
    80005626:	11e50513          	addi	a0,a0,286 # 80008740 <syscalls+0x3a0>
    8000562a:	00001097          	auipc	ra,0x1
    8000562e:	876080e7          	jalr	-1930(ra) # 80005ea0 <panic>

0000000080005632 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005632:	7119                	addi	sp,sp,-128
    80005634:	fc86                	sd	ra,120(sp)
    80005636:	f8a2                	sd	s0,112(sp)
    80005638:	f4a6                	sd	s1,104(sp)
    8000563a:	f0ca                	sd	s2,96(sp)
    8000563c:	ecce                	sd	s3,88(sp)
    8000563e:	e8d2                	sd	s4,80(sp)
    80005640:	e4d6                	sd	s5,72(sp)
    80005642:	e0da                	sd	s6,64(sp)
    80005644:	fc5e                	sd	s7,56(sp)
    80005646:	f862                	sd	s8,48(sp)
    80005648:	f466                	sd	s9,40(sp)
    8000564a:	f06a                	sd	s10,32(sp)
    8000564c:	ec6e                	sd	s11,24(sp)
    8000564e:	0100                	addi	s0,sp,128
    80005650:	8aaa                	mv	s5,a0
    80005652:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005654:	00c52c83          	lw	s9,12(a0)
    80005658:	001c9c9b          	slliw	s9,s9,0x1
    8000565c:	1c82                	slli	s9,s9,0x20
    8000565e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005662:	00026517          	auipc	a0,0x26
    80005666:	ac650513          	addi	a0,a0,-1338 # 8002b128 <disk+0x2128>
    8000566a:	00001097          	auipc	ra,0x1
    8000566e:	d6e080e7          	jalr	-658(ra) # 800063d8 <acquire>
  for(int i = 0; i < 3; i++){
    80005672:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005674:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005676:	00024c17          	auipc	s8,0x24
    8000567a:	98ac0c13          	addi	s8,s8,-1654 # 80029000 <disk>
    8000567e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005680:	4b0d                	li	s6,3
    80005682:	a0ad                	j	800056ec <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005684:	00fc0733          	add	a4,s8,a5
    80005688:	975e                	add	a4,a4,s7
    8000568a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000568e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005690:	0207c563          	bltz	a5,800056ba <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005694:	2905                	addiw	s2,s2,1
    80005696:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005698:	19690c63          	beq	s2,s6,80005830 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000569c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000569e:	00026717          	auipc	a4,0x26
    800056a2:	97a70713          	addi	a4,a4,-1670 # 8002b018 <disk+0x2018>
    800056a6:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800056a8:	00074683          	lbu	a3,0(a4)
    800056ac:	fee1                	bnez	a3,80005684 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800056ae:	2785                	addiw	a5,a5,1
    800056b0:	0705                	addi	a4,a4,1
    800056b2:	fe979be3          	bne	a5,s1,800056a8 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800056b6:	57fd                	li	a5,-1
    800056b8:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056ba:	01205d63          	blez	s2,800056d4 <virtio_disk_rw+0xa2>
    800056be:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800056c0:	000a2503          	lw	a0,0(s4)
    800056c4:	00000097          	auipc	ra,0x0
    800056c8:	d92080e7          	jalr	-622(ra) # 80005456 <free_desc>
      for(int j = 0; j < i; j++)
    800056cc:	2d85                	addiw	s11,s11,1
    800056ce:	0a11                	addi	s4,s4,4
    800056d0:	ff2d98e3          	bne	s11,s2,800056c0 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056d4:	00026597          	auipc	a1,0x26
    800056d8:	a5458593          	addi	a1,a1,-1452 # 8002b128 <disk+0x2128>
    800056dc:	00026517          	auipc	a0,0x26
    800056e0:	93c50513          	addi	a0,a0,-1732 # 8002b018 <disk+0x2018>
    800056e4:	ffffc097          	auipc	ra,0xffffc
    800056e8:	e0a080e7          	jalr	-502(ra) # 800014ee <sleep>
  for(int i = 0; i < 3; i++){
    800056ec:	f8040a13          	addi	s4,s0,-128
{
    800056f0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800056f2:	894e                	mv	s2,s3
    800056f4:	b765                	j	8000569c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056f6:	00026697          	auipc	a3,0x26
    800056fa:	90a6b683          	ld	a3,-1782(a3) # 8002b000 <disk+0x2000>
    800056fe:	96ba                	add	a3,a3,a4
    80005700:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005704:	00024817          	auipc	a6,0x24
    80005708:	8fc80813          	addi	a6,a6,-1796 # 80029000 <disk>
    8000570c:	00026697          	auipc	a3,0x26
    80005710:	8f468693          	addi	a3,a3,-1804 # 8002b000 <disk+0x2000>
    80005714:	6290                	ld	a2,0(a3)
    80005716:	963a                	add	a2,a2,a4
    80005718:	00c65583          	lhu	a1,12(a2)
    8000571c:	0015e593          	ori	a1,a1,1
    80005720:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005724:	f8842603          	lw	a2,-120(s0)
    80005728:	628c                	ld	a1,0(a3)
    8000572a:	972e                	add	a4,a4,a1
    8000572c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005730:	20050593          	addi	a1,a0,512
    80005734:	0592                	slli	a1,a1,0x4
    80005736:	95c2                	add	a1,a1,a6
    80005738:	577d                	li	a4,-1
    8000573a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000573e:	00461713          	slli	a4,a2,0x4
    80005742:	6290                	ld	a2,0(a3)
    80005744:	963a                	add	a2,a2,a4
    80005746:	03078793          	addi	a5,a5,48
    8000574a:	97c2                	add	a5,a5,a6
    8000574c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000574e:	629c                	ld	a5,0(a3)
    80005750:	97ba                	add	a5,a5,a4
    80005752:	4605                	li	a2,1
    80005754:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005756:	629c                	ld	a5,0(a3)
    80005758:	97ba                	add	a5,a5,a4
    8000575a:	4809                	li	a6,2
    8000575c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005760:	629c                	ld	a5,0(a3)
    80005762:	97ba                	add	a5,a5,a4
    80005764:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005768:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000576c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005770:	6698                	ld	a4,8(a3)
    80005772:	00275783          	lhu	a5,2(a4)
    80005776:	8b9d                	andi	a5,a5,7
    80005778:	0786                	slli	a5,a5,0x1
    8000577a:	973e                	add	a4,a4,a5
    8000577c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005780:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005784:	6698                	ld	a4,8(a3)
    80005786:	00275783          	lhu	a5,2(a4)
    8000578a:	2785                	addiw	a5,a5,1
    8000578c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005790:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005794:	100017b7          	lui	a5,0x10001
    80005798:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000579c:	004aa783          	lw	a5,4(s5)
    800057a0:	02c79163          	bne	a5,a2,800057c2 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800057a4:	00026917          	auipc	s2,0x26
    800057a8:	98490913          	addi	s2,s2,-1660 # 8002b128 <disk+0x2128>
  while(b->disk == 1) {
    800057ac:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057ae:	85ca                	mv	a1,s2
    800057b0:	8556                	mv	a0,s5
    800057b2:	ffffc097          	auipc	ra,0xffffc
    800057b6:	d3c080e7          	jalr	-708(ra) # 800014ee <sleep>
  while(b->disk == 1) {
    800057ba:	004aa783          	lw	a5,4(s5)
    800057be:	fe9788e3          	beq	a5,s1,800057ae <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800057c2:	f8042903          	lw	s2,-128(s0)
    800057c6:	20090713          	addi	a4,s2,512
    800057ca:	0712                	slli	a4,a4,0x4
    800057cc:	00024797          	auipc	a5,0x24
    800057d0:	83478793          	addi	a5,a5,-1996 # 80029000 <disk>
    800057d4:	97ba                	add	a5,a5,a4
    800057d6:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800057da:	00026997          	auipc	s3,0x26
    800057de:	82698993          	addi	s3,s3,-2010 # 8002b000 <disk+0x2000>
    800057e2:	00491713          	slli	a4,s2,0x4
    800057e6:	0009b783          	ld	a5,0(s3)
    800057ea:	97ba                	add	a5,a5,a4
    800057ec:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057f0:	854a                	mv	a0,s2
    800057f2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057f6:	00000097          	auipc	ra,0x0
    800057fa:	c60080e7          	jalr	-928(ra) # 80005456 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057fe:	8885                	andi	s1,s1,1
    80005800:	f0ed                	bnez	s1,800057e2 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005802:	00026517          	auipc	a0,0x26
    80005806:	92650513          	addi	a0,a0,-1754 # 8002b128 <disk+0x2128>
    8000580a:	00001097          	auipc	ra,0x1
    8000580e:	c82080e7          	jalr	-894(ra) # 8000648c <release>
}
    80005812:	70e6                	ld	ra,120(sp)
    80005814:	7446                	ld	s0,112(sp)
    80005816:	74a6                	ld	s1,104(sp)
    80005818:	7906                	ld	s2,96(sp)
    8000581a:	69e6                	ld	s3,88(sp)
    8000581c:	6a46                	ld	s4,80(sp)
    8000581e:	6aa6                	ld	s5,72(sp)
    80005820:	6b06                	ld	s6,64(sp)
    80005822:	7be2                	ld	s7,56(sp)
    80005824:	7c42                	ld	s8,48(sp)
    80005826:	7ca2                	ld	s9,40(sp)
    80005828:	7d02                	ld	s10,32(sp)
    8000582a:	6de2                	ld	s11,24(sp)
    8000582c:	6109                	addi	sp,sp,128
    8000582e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005830:	f8042503          	lw	a0,-128(s0)
    80005834:	20050793          	addi	a5,a0,512
    80005838:	0792                	slli	a5,a5,0x4
  if(write)
    8000583a:	00023817          	auipc	a6,0x23
    8000583e:	7c680813          	addi	a6,a6,1990 # 80029000 <disk>
    80005842:	00f80733          	add	a4,a6,a5
    80005846:	01a036b3          	snez	a3,s10
    8000584a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000584e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005852:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005856:	7679                	lui	a2,0xffffe
    80005858:	963e                	add	a2,a2,a5
    8000585a:	00025697          	auipc	a3,0x25
    8000585e:	7a668693          	addi	a3,a3,1958 # 8002b000 <disk+0x2000>
    80005862:	6298                	ld	a4,0(a3)
    80005864:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005866:	0a878593          	addi	a1,a5,168
    8000586a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000586c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000586e:	6298                	ld	a4,0(a3)
    80005870:	9732                	add	a4,a4,a2
    80005872:	45c1                	li	a1,16
    80005874:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005876:	6298                	ld	a4,0(a3)
    80005878:	9732                	add	a4,a4,a2
    8000587a:	4585                	li	a1,1
    8000587c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005880:	f8442703          	lw	a4,-124(s0)
    80005884:	628c                	ld	a1,0(a3)
    80005886:	962e                	add	a2,a2,a1
    80005888:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffc9dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000588c:	0712                	slli	a4,a4,0x4
    8000588e:	6290                	ld	a2,0(a3)
    80005890:	963a                	add	a2,a2,a4
    80005892:	058a8593          	addi	a1,s5,88
    80005896:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005898:	6294                	ld	a3,0(a3)
    8000589a:	96ba                	add	a3,a3,a4
    8000589c:	40000613          	li	a2,1024
    800058a0:	c690                	sw	a2,8(a3)
  if(write)
    800058a2:	e40d1ae3          	bnez	s10,800056f6 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800058a6:	00025697          	auipc	a3,0x25
    800058aa:	75a6b683          	ld	a3,1882(a3) # 8002b000 <disk+0x2000>
    800058ae:	96ba                	add	a3,a3,a4
    800058b0:	4609                	li	a2,2
    800058b2:	00c69623          	sh	a2,12(a3)
    800058b6:	b5b9                	j	80005704 <virtio_disk_rw+0xd2>

00000000800058b8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058b8:	1101                	addi	sp,sp,-32
    800058ba:	ec06                	sd	ra,24(sp)
    800058bc:	e822                	sd	s0,16(sp)
    800058be:	e426                	sd	s1,8(sp)
    800058c0:	e04a                	sd	s2,0(sp)
    800058c2:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058c4:	00026517          	auipc	a0,0x26
    800058c8:	86450513          	addi	a0,a0,-1948 # 8002b128 <disk+0x2128>
    800058cc:	00001097          	auipc	ra,0x1
    800058d0:	b0c080e7          	jalr	-1268(ra) # 800063d8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058d4:	10001737          	lui	a4,0x10001
    800058d8:	533c                	lw	a5,96(a4)
    800058da:	8b8d                	andi	a5,a5,3
    800058dc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058de:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058e2:	00025797          	auipc	a5,0x25
    800058e6:	71e78793          	addi	a5,a5,1822 # 8002b000 <disk+0x2000>
    800058ea:	6b94                	ld	a3,16(a5)
    800058ec:	0207d703          	lhu	a4,32(a5)
    800058f0:	0026d783          	lhu	a5,2(a3)
    800058f4:	06f70163          	beq	a4,a5,80005956 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058f8:	00023917          	auipc	s2,0x23
    800058fc:	70890913          	addi	s2,s2,1800 # 80029000 <disk>
    80005900:	00025497          	auipc	s1,0x25
    80005904:	70048493          	addi	s1,s1,1792 # 8002b000 <disk+0x2000>
    __sync_synchronize();
    80005908:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000590c:	6898                	ld	a4,16(s1)
    8000590e:	0204d783          	lhu	a5,32(s1)
    80005912:	8b9d                	andi	a5,a5,7
    80005914:	078e                	slli	a5,a5,0x3
    80005916:	97ba                	add	a5,a5,a4
    80005918:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000591a:	20078713          	addi	a4,a5,512
    8000591e:	0712                	slli	a4,a4,0x4
    80005920:	974a                	add	a4,a4,s2
    80005922:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005926:	e731                	bnez	a4,80005972 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005928:	20078793          	addi	a5,a5,512
    8000592c:	0792                	slli	a5,a5,0x4
    8000592e:	97ca                	add	a5,a5,s2
    80005930:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005932:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005936:	ffffc097          	auipc	ra,0xffffc
    8000593a:	d44080e7          	jalr	-700(ra) # 8000167a <wakeup>

    disk.used_idx += 1;
    8000593e:	0204d783          	lhu	a5,32(s1)
    80005942:	2785                	addiw	a5,a5,1
    80005944:	17c2                	slli	a5,a5,0x30
    80005946:	93c1                	srli	a5,a5,0x30
    80005948:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000594c:	6898                	ld	a4,16(s1)
    8000594e:	00275703          	lhu	a4,2(a4)
    80005952:	faf71be3          	bne	a4,a5,80005908 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005956:	00025517          	auipc	a0,0x25
    8000595a:	7d250513          	addi	a0,a0,2002 # 8002b128 <disk+0x2128>
    8000595e:	00001097          	auipc	ra,0x1
    80005962:	b2e080e7          	jalr	-1234(ra) # 8000648c <release>
}
    80005966:	60e2                	ld	ra,24(sp)
    80005968:	6442                	ld	s0,16(sp)
    8000596a:	64a2                	ld	s1,8(sp)
    8000596c:	6902                	ld	s2,0(sp)
    8000596e:	6105                	addi	sp,sp,32
    80005970:	8082                	ret
      panic("virtio_disk_intr status");
    80005972:	00003517          	auipc	a0,0x3
    80005976:	dee50513          	addi	a0,a0,-530 # 80008760 <syscalls+0x3c0>
    8000597a:	00000097          	auipc	ra,0x0
    8000597e:	526080e7          	jalr	1318(ra) # 80005ea0 <panic>

0000000080005982 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005982:	1141                	addi	sp,sp,-16
    80005984:	e422                	sd	s0,8(sp)
    80005986:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005988:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000598c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005990:	0037979b          	slliw	a5,a5,0x3
    80005994:	02004737          	lui	a4,0x2004
    80005998:	97ba                	add	a5,a5,a4
    8000599a:	0200c737          	lui	a4,0x200c
    8000599e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800059a2:	000f4637          	lui	a2,0xf4
    800059a6:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800059aa:	9732                	add	a4,a4,a2
    800059ac:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800059ae:	00259693          	slli	a3,a1,0x2
    800059b2:	96ae                	add	a3,a3,a1
    800059b4:	068e                	slli	a3,a3,0x3
    800059b6:	00026717          	auipc	a4,0x26
    800059ba:	64a70713          	addi	a4,a4,1610 # 8002c000 <timer_scratch>
    800059be:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059c0:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059c2:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800059c4:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800059c8:	00000797          	auipc	a5,0x0
    800059cc:	9c878793          	addi	a5,a5,-1592 # 80005390 <timervec>
    800059d0:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059d4:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059d8:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059dc:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800059e0:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059e4:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800059e8:	30479073          	csrw	mie,a5
}
    800059ec:	6422                	ld	s0,8(sp)
    800059ee:	0141                	addi	sp,sp,16
    800059f0:	8082                	ret

00000000800059f2 <start>:
{
    800059f2:	1141                	addi	sp,sp,-16
    800059f4:	e406                	sd	ra,8(sp)
    800059f6:	e022                	sd	s0,0(sp)
    800059f8:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059fa:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059fe:	7779                	lui	a4,0xffffe
    80005a00:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffca5bf>
    80005a04:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a06:	6705                	lui	a4,0x1
    80005a08:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a0c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a0e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a12:	ffffb797          	auipc	a5,0xffffb
    80005a16:	90e78793          	addi	a5,a5,-1778 # 80000320 <main>
    80005a1a:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a1e:	4781                	li	a5,0
    80005a20:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a24:	67c1                	lui	a5,0x10
    80005a26:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a28:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a2c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a30:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a34:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a38:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a3c:	57fd                	li	a5,-1
    80005a3e:	83a9                	srli	a5,a5,0xa
    80005a40:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a44:	47bd                	li	a5,15
    80005a46:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a4a:	00000097          	auipc	ra,0x0
    80005a4e:	f38080e7          	jalr	-200(ra) # 80005982 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a52:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a56:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a58:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a5a:	30200073          	mret
}
    80005a5e:	60a2                	ld	ra,8(sp)
    80005a60:	6402                	ld	s0,0(sp)
    80005a62:	0141                	addi	sp,sp,16
    80005a64:	8082                	ret

0000000080005a66 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a66:	715d                	addi	sp,sp,-80
    80005a68:	e486                	sd	ra,72(sp)
    80005a6a:	e0a2                	sd	s0,64(sp)
    80005a6c:	fc26                	sd	s1,56(sp)
    80005a6e:	f84a                	sd	s2,48(sp)
    80005a70:	f44e                	sd	s3,40(sp)
    80005a72:	f052                	sd	s4,32(sp)
    80005a74:	ec56                	sd	s5,24(sp)
    80005a76:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a78:	04c05763          	blez	a2,80005ac6 <consolewrite+0x60>
    80005a7c:	8a2a                	mv	s4,a0
    80005a7e:	84ae                	mv	s1,a1
    80005a80:	89b2                	mv	s3,a2
    80005a82:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a84:	5afd                	li	s5,-1
    80005a86:	4685                	li	a3,1
    80005a88:	8626                	mv	a2,s1
    80005a8a:	85d2                	mv	a1,s4
    80005a8c:	fbf40513          	addi	a0,s0,-65
    80005a90:	ffffc097          	auipc	ra,0xffffc
    80005a94:	e58080e7          	jalr	-424(ra) # 800018e8 <either_copyin>
    80005a98:	01550d63          	beq	a0,s5,80005ab2 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005a9c:	fbf44503          	lbu	a0,-65(s0)
    80005aa0:	00000097          	auipc	ra,0x0
    80005aa4:	77e080e7          	jalr	1918(ra) # 8000621e <uartputc>
  for(i = 0; i < n; i++){
    80005aa8:	2905                	addiw	s2,s2,1
    80005aaa:	0485                	addi	s1,s1,1
    80005aac:	fd299de3          	bne	s3,s2,80005a86 <consolewrite+0x20>
    80005ab0:	894e                	mv	s2,s3
  }

  return i;
}
    80005ab2:	854a                	mv	a0,s2
    80005ab4:	60a6                	ld	ra,72(sp)
    80005ab6:	6406                	ld	s0,64(sp)
    80005ab8:	74e2                	ld	s1,56(sp)
    80005aba:	7942                	ld	s2,48(sp)
    80005abc:	79a2                	ld	s3,40(sp)
    80005abe:	7a02                	ld	s4,32(sp)
    80005ac0:	6ae2                	ld	s5,24(sp)
    80005ac2:	6161                	addi	sp,sp,80
    80005ac4:	8082                	ret
  for(i = 0; i < n; i++){
    80005ac6:	4901                	li	s2,0
    80005ac8:	b7ed                	j	80005ab2 <consolewrite+0x4c>

0000000080005aca <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005aca:	7159                	addi	sp,sp,-112
    80005acc:	f486                	sd	ra,104(sp)
    80005ace:	f0a2                	sd	s0,96(sp)
    80005ad0:	eca6                	sd	s1,88(sp)
    80005ad2:	e8ca                	sd	s2,80(sp)
    80005ad4:	e4ce                	sd	s3,72(sp)
    80005ad6:	e0d2                	sd	s4,64(sp)
    80005ad8:	fc56                	sd	s5,56(sp)
    80005ada:	f85a                	sd	s6,48(sp)
    80005adc:	f45e                	sd	s7,40(sp)
    80005ade:	f062                	sd	s8,32(sp)
    80005ae0:	ec66                	sd	s9,24(sp)
    80005ae2:	e86a                	sd	s10,16(sp)
    80005ae4:	1880                	addi	s0,sp,112
    80005ae6:	8aaa                	mv	s5,a0
    80005ae8:	8a2e                	mv	s4,a1
    80005aea:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005aec:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005af0:	0002e517          	auipc	a0,0x2e
    80005af4:	65050513          	addi	a0,a0,1616 # 80034140 <cons>
    80005af8:	00001097          	auipc	ra,0x1
    80005afc:	8e0080e7          	jalr	-1824(ra) # 800063d8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005b00:	0002e497          	auipc	s1,0x2e
    80005b04:	64048493          	addi	s1,s1,1600 # 80034140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b08:	0002e917          	auipc	s2,0x2e
    80005b0c:	6d090913          	addi	s2,s2,1744 # 800341d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005b10:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b12:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005b14:	4ca9                	li	s9,10
  while(n > 0){
    80005b16:	07305863          	blez	s3,80005b86 <consoleread+0xbc>
    while(cons.r == cons.w){
    80005b1a:	0984a783          	lw	a5,152(s1)
    80005b1e:	09c4a703          	lw	a4,156(s1)
    80005b22:	02f71463          	bne	a4,a5,80005b4a <consoleread+0x80>
      if(myproc()->killed){
    80005b26:	ffffb097          	auipc	ra,0xffffb
    80005b2a:	304080e7          	jalr	772(ra) # 80000e2a <myproc>
    80005b2e:	551c                	lw	a5,40(a0)
    80005b30:	e7b5                	bnez	a5,80005b9c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005b32:	85a6                	mv	a1,s1
    80005b34:	854a                	mv	a0,s2
    80005b36:	ffffc097          	auipc	ra,0xffffc
    80005b3a:	9b8080e7          	jalr	-1608(ra) # 800014ee <sleep>
    while(cons.r == cons.w){
    80005b3e:	0984a783          	lw	a5,152(s1)
    80005b42:	09c4a703          	lw	a4,156(s1)
    80005b46:	fef700e3          	beq	a4,a5,80005b26 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005b4a:	0017871b          	addiw	a4,a5,1
    80005b4e:	08e4ac23          	sw	a4,152(s1)
    80005b52:	07f7f713          	andi	a4,a5,127
    80005b56:	9726                	add	a4,a4,s1
    80005b58:	01874703          	lbu	a4,24(a4)
    80005b5c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005b60:	077d0563          	beq	s10,s7,80005bca <consoleread+0x100>
    cbuf = c;
    80005b64:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b68:	4685                	li	a3,1
    80005b6a:	f9f40613          	addi	a2,s0,-97
    80005b6e:	85d2                	mv	a1,s4
    80005b70:	8556                	mv	a0,s5
    80005b72:	ffffc097          	auipc	ra,0xffffc
    80005b76:	d20080e7          	jalr	-736(ra) # 80001892 <either_copyout>
    80005b7a:	01850663          	beq	a0,s8,80005b86 <consoleread+0xbc>
    dst++;
    80005b7e:	0a05                	addi	s4,s4,1
    --n;
    80005b80:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005b82:	f99d1ae3          	bne	s10,s9,80005b16 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b86:	0002e517          	auipc	a0,0x2e
    80005b8a:	5ba50513          	addi	a0,a0,1466 # 80034140 <cons>
    80005b8e:	00001097          	auipc	ra,0x1
    80005b92:	8fe080e7          	jalr	-1794(ra) # 8000648c <release>

  return target - n;
    80005b96:	413b053b          	subw	a0,s6,s3
    80005b9a:	a811                	j	80005bae <consoleread+0xe4>
        release(&cons.lock);
    80005b9c:	0002e517          	auipc	a0,0x2e
    80005ba0:	5a450513          	addi	a0,a0,1444 # 80034140 <cons>
    80005ba4:	00001097          	auipc	ra,0x1
    80005ba8:	8e8080e7          	jalr	-1816(ra) # 8000648c <release>
        return -1;
    80005bac:	557d                	li	a0,-1
}
    80005bae:	70a6                	ld	ra,104(sp)
    80005bb0:	7406                	ld	s0,96(sp)
    80005bb2:	64e6                	ld	s1,88(sp)
    80005bb4:	6946                	ld	s2,80(sp)
    80005bb6:	69a6                	ld	s3,72(sp)
    80005bb8:	6a06                	ld	s4,64(sp)
    80005bba:	7ae2                	ld	s5,56(sp)
    80005bbc:	7b42                	ld	s6,48(sp)
    80005bbe:	7ba2                	ld	s7,40(sp)
    80005bc0:	7c02                	ld	s8,32(sp)
    80005bc2:	6ce2                	ld	s9,24(sp)
    80005bc4:	6d42                	ld	s10,16(sp)
    80005bc6:	6165                	addi	sp,sp,112
    80005bc8:	8082                	ret
      if(n < target){
    80005bca:	0009871b          	sext.w	a4,s3
    80005bce:	fb677ce3          	bgeu	a4,s6,80005b86 <consoleread+0xbc>
        cons.r--;
    80005bd2:	0002e717          	auipc	a4,0x2e
    80005bd6:	60f72323          	sw	a5,1542(a4) # 800341d8 <cons+0x98>
    80005bda:	b775                	j	80005b86 <consoleread+0xbc>

0000000080005bdc <consputc>:
{
    80005bdc:	1141                	addi	sp,sp,-16
    80005bde:	e406                	sd	ra,8(sp)
    80005be0:	e022                	sd	s0,0(sp)
    80005be2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005be4:	10000793          	li	a5,256
    80005be8:	00f50a63          	beq	a0,a5,80005bfc <consputc+0x20>
    uartputc_sync(c);
    80005bec:	00000097          	auipc	ra,0x0
    80005bf0:	560080e7          	jalr	1376(ra) # 8000614c <uartputc_sync>
}
    80005bf4:	60a2                	ld	ra,8(sp)
    80005bf6:	6402                	ld	s0,0(sp)
    80005bf8:	0141                	addi	sp,sp,16
    80005bfa:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005bfc:	4521                	li	a0,8
    80005bfe:	00000097          	auipc	ra,0x0
    80005c02:	54e080e7          	jalr	1358(ra) # 8000614c <uartputc_sync>
    80005c06:	02000513          	li	a0,32
    80005c0a:	00000097          	auipc	ra,0x0
    80005c0e:	542080e7          	jalr	1346(ra) # 8000614c <uartputc_sync>
    80005c12:	4521                	li	a0,8
    80005c14:	00000097          	auipc	ra,0x0
    80005c18:	538080e7          	jalr	1336(ra) # 8000614c <uartputc_sync>
    80005c1c:	bfe1                	j	80005bf4 <consputc+0x18>

0000000080005c1e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c1e:	1101                	addi	sp,sp,-32
    80005c20:	ec06                	sd	ra,24(sp)
    80005c22:	e822                	sd	s0,16(sp)
    80005c24:	e426                	sd	s1,8(sp)
    80005c26:	e04a                	sd	s2,0(sp)
    80005c28:	1000                	addi	s0,sp,32
    80005c2a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c2c:	0002e517          	auipc	a0,0x2e
    80005c30:	51450513          	addi	a0,a0,1300 # 80034140 <cons>
    80005c34:	00000097          	auipc	ra,0x0
    80005c38:	7a4080e7          	jalr	1956(ra) # 800063d8 <acquire>

  switch(c){
    80005c3c:	47d5                	li	a5,21
    80005c3e:	0af48663          	beq	s1,a5,80005cea <consoleintr+0xcc>
    80005c42:	0297ca63          	blt	a5,s1,80005c76 <consoleintr+0x58>
    80005c46:	47a1                	li	a5,8
    80005c48:	0ef48763          	beq	s1,a5,80005d36 <consoleintr+0x118>
    80005c4c:	47c1                	li	a5,16
    80005c4e:	10f49a63          	bne	s1,a5,80005d62 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c52:	ffffc097          	auipc	ra,0xffffc
    80005c56:	cec080e7          	jalr	-788(ra) # 8000193e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c5a:	0002e517          	auipc	a0,0x2e
    80005c5e:	4e650513          	addi	a0,a0,1254 # 80034140 <cons>
    80005c62:	00001097          	auipc	ra,0x1
    80005c66:	82a080e7          	jalr	-2006(ra) # 8000648c <release>
}
    80005c6a:	60e2                	ld	ra,24(sp)
    80005c6c:	6442                	ld	s0,16(sp)
    80005c6e:	64a2                	ld	s1,8(sp)
    80005c70:	6902                	ld	s2,0(sp)
    80005c72:	6105                	addi	sp,sp,32
    80005c74:	8082                	ret
  switch(c){
    80005c76:	07f00793          	li	a5,127
    80005c7a:	0af48e63          	beq	s1,a5,80005d36 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c7e:	0002e717          	auipc	a4,0x2e
    80005c82:	4c270713          	addi	a4,a4,1218 # 80034140 <cons>
    80005c86:	0a072783          	lw	a5,160(a4)
    80005c8a:	09872703          	lw	a4,152(a4)
    80005c8e:	9f99                	subw	a5,a5,a4
    80005c90:	07f00713          	li	a4,127
    80005c94:	fcf763e3          	bltu	a4,a5,80005c5a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c98:	47b5                	li	a5,13
    80005c9a:	0cf48763          	beq	s1,a5,80005d68 <consoleintr+0x14a>
      consputc(c);
    80005c9e:	8526                	mv	a0,s1
    80005ca0:	00000097          	auipc	ra,0x0
    80005ca4:	f3c080e7          	jalr	-196(ra) # 80005bdc <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ca8:	0002e797          	auipc	a5,0x2e
    80005cac:	49878793          	addi	a5,a5,1176 # 80034140 <cons>
    80005cb0:	0a07a703          	lw	a4,160(a5)
    80005cb4:	0017069b          	addiw	a3,a4,1
    80005cb8:	0006861b          	sext.w	a2,a3
    80005cbc:	0ad7a023          	sw	a3,160(a5)
    80005cc0:	07f77713          	andi	a4,a4,127
    80005cc4:	97ba                	add	a5,a5,a4
    80005cc6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005cca:	47a9                	li	a5,10
    80005ccc:	0cf48563          	beq	s1,a5,80005d96 <consoleintr+0x178>
    80005cd0:	4791                	li	a5,4
    80005cd2:	0cf48263          	beq	s1,a5,80005d96 <consoleintr+0x178>
    80005cd6:	0002e797          	auipc	a5,0x2e
    80005cda:	5027a783          	lw	a5,1282(a5) # 800341d8 <cons+0x98>
    80005cde:	0807879b          	addiw	a5,a5,128
    80005ce2:	f6f61ce3          	bne	a2,a5,80005c5a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ce6:	863e                	mv	a2,a5
    80005ce8:	a07d                	j	80005d96 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005cea:	0002e717          	auipc	a4,0x2e
    80005cee:	45670713          	addi	a4,a4,1110 # 80034140 <cons>
    80005cf2:	0a072783          	lw	a5,160(a4)
    80005cf6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005cfa:	0002e497          	auipc	s1,0x2e
    80005cfe:	44648493          	addi	s1,s1,1094 # 80034140 <cons>
    while(cons.e != cons.w &&
    80005d02:	4929                	li	s2,10
    80005d04:	f4f70be3          	beq	a4,a5,80005c5a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d08:	37fd                	addiw	a5,a5,-1
    80005d0a:	07f7f713          	andi	a4,a5,127
    80005d0e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d10:	01874703          	lbu	a4,24(a4)
    80005d14:	f52703e3          	beq	a4,s2,80005c5a <consoleintr+0x3c>
      cons.e--;
    80005d18:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d1c:	10000513          	li	a0,256
    80005d20:	00000097          	auipc	ra,0x0
    80005d24:	ebc080e7          	jalr	-324(ra) # 80005bdc <consputc>
    while(cons.e != cons.w &&
    80005d28:	0a04a783          	lw	a5,160(s1)
    80005d2c:	09c4a703          	lw	a4,156(s1)
    80005d30:	fcf71ce3          	bne	a4,a5,80005d08 <consoleintr+0xea>
    80005d34:	b71d                	j	80005c5a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005d36:	0002e717          	auipc	a4,0x2e
    80005d3a:	40a70713          	addi	a4,a4,1034 # 80034140 <cons>
    80005d3e:	0a072783          	lw	a5,160(a4)
    80005d42:	09c72703          	lw	a4,156(a4)
    80005d46:	f0f70ae3          	beq	a4,a5,80005c5a <consoleintr+0x3c>
      cons.e--;
    80005d4a:	37fd                	addiw	a5,a5,-1
    80005d4c:	0002e717          	auipc	a4,0x2e
    80005d50:	48f72a23          	sw	a5,1172(a4) # 800341e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005d54:	10000513          	li	a0,256
    80005d58:	00000097          	auipc	ra,0x0
    80005d5c:	e84080e7          	jalr	-380(ra) # 80005bdc <consputc>
    80005d60:	bded                	j	80005c5a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005d62:	ee048ce3          	beqz	s1,80005c5a <consoleintr+0x3c>
    80005d66:	bf21                	j	80005c7e <consoleintr+0x60>
      consputc(c);
    80005d68:	4529                	li	a0,10
    80005d6a:	00000097          	auipc	ra,0x0
    80005d6e:	e72080e7          	jalr	-398(ra) # 80005bdc <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d72:	0002e797          	auipc	a5,0x2e
    80005d76:	3ce78793          	addi	a5,a5,974 # 80034140 <cons>
    80005d7a:	0a07a703          	lw	a4,160(a5)
    80005d7e:	0017069b          	addiw	a3,a4,1
    80005d82:	0006861b          	sext.w	a2,a3
    80005d86:	0ad7a023          	sw	a3,160(a5)
    80005d8a:	07f77713          	andi	a4,a4,127
    80005d8e:	97ba                	add	a5,a5,a4
    80005d90:	4729                	li	a4,10
    80005d92:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d96:	0002e797          	auipc	a5,0x2e
    80005d9a:	44c7a323          	sw	a2,1094(a5) # 800341dc <cons+0x9c>
        wakeup(&cons.r);
    80005d9e:	0002e517          	auipc	a0,0x2e
    80005da2:	43a50513          	addi	a0,a0,1082 # 800341d8 <cons+0x98>
    80005da6:	ffffc097          	auipc	ra,0xffffc
    80005daa:	8d4080e7          	jalr	-1836(ra) # 8000167a <wakeup>
    80005dae:	b575                	j	80005c5a <consoleintr+0x3c>

0000000080005db0 <consoleinit>:

void
consoleinit(void)
{
    80005db0:	1141                	addi	sp,sp,-16
    80005db2:	e406                	sd	ra,8(sp)
    80005db4:	e022                	sd	s0,0(sp)
    80005db6:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005db8:	00003597          	auipc	a1,0x3
    80005dbc:	9c058593          	addi	a1,a1,-1600 # 80008778 <syscalls+0x3d8>
    80005dc0:	0002e517          	auipc	a0,0x2e
    80005dc4:	38050513          	addi	a0,a0,896 # 80034140 <cons>
    80005dc8:	00000097          	auipc	ra,0x0
    80005dcc:	580080e7          	jalr	1408(ra) # 80006348 <initlock>

  uartinit();
    80005dd0:	00000097          	auipc	ra,0x0
    80005dd4:	32c080e7          	jalr	812(ra) # 800060fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005dd8:	00021797          	auipc	a5,0x21
    80005ddc:	2f078793          	addi	a5,a5,752 # 800270c8 <devsw>
    80005de0:	00000717          	auipc	a4,0x0
    80005de4:	cea70713          	addi	a4,a4,-790 # 80005aca <consoleread>
    80005de8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005dea:	00000717          	auipc	a4,0x0
    80005dee:	c7c70713          	addi	a4,a4,-900 # 80005a66 <consolewrite>
    80005df2:	ef98                	sd	a4,24(a5)
}
    80005df4:	60a2                	ld	ra,8(sp)
    80005df6:	6402                	ld	s0,0(sp)
    80005df8:	0141                	addi	sp,sp,16
    80005dfa:	8082                	ret

0000000080005dfc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005dfc:	7179                	addi	sp,sp,-48
    80005dfe:	f406                	sd	ra,40(sp)
    80005e00:	f022                	sd	s0,32(sp)
    80005e02:	ec26                	sd	s1,24(sp)
    80005e04:	e84a                	sd	s2,16(sp)
    80005e06:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e08:	c219                	beqz	a2,80005e0e <printint+0x12>
    80005e0a:	08054763          	bltz	a0,80005e98 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005e0e:	2501                	sext.w	a0,a0
    80005e10:	4881                	li	a7,0
    80005e12:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e16:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e18:	2581                	sext.w	a1,a1
    80005e1a:	00003617          	auipc	a2,0x3
    80005e1e:	98e60613          	addi	a2,a2,-1650 # 800087a8 <digits>
    80005e22:	883a                	mv	a6,a4
    80005e24:	2705                	addiw	a4,a4,1
    80005e26:	02b577bb          	remuw	a5,a0,a1
    80005e2a:	1782                	slli	a5,a5,0x20
    80005e2c:	9381                	srli	a5,a5,0x20
    80005e2e:	97b2                	add	a5,a5,a2
    80005e30:	0007c783          	lbu	a5,0(a5)
    80005e34:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e38:	0005079b          	sext.w	a5,a0
    80005e3c:	02b5553b          	divuw	a0,a0,a1
    80005e40:	0685                	addi	a3,a3,1
    80005e42:	feb7f0e3          	bgeu	a5,a1,80005e22 <printint+0x26>

  if(sign)
    80005e46:	00088c63          	beqz	a7,80005e5e <printint+0x62>
    buf[i++] = '-';
    80005e4a:	fe070793          	addi	a5,a4,-32
    80005e4e:	00878733          	add	a4,a5,s0
    80005e52:	02d00793          	li	a5,45
    80005e56:	fef70823          	sb	a5,-16(a4)
    80005e5a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e5e:	02e05763          	blez	a4,80005e8c <printint+0x90>
    80005e62:	fd040793          	addi	a5,s0,-48
    80005e66:	00e784b3          	add	s1,a5,a4
    80005e6a:	fff78913          	addi	s2,a5,-1
    80005e6e:	993a                	add	s2,s2,a4
    80005e70:	377d                	addiw	a4,a4,-1
    80005e72:	1702                	slli	a4,a4,0x20
    80005e74:	9301                	srli	a4,a4,0x20
    80005e76:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e7a:	fff4c503          	lbu	a0,-1(s1)
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	d5e080e7          	jalr	-674(ra) # 80005bdc <consputc>
  while(--i >= 0)
    80005e86:	14fd                	addi	s1,s1,-1
    80005e88:	ff2499e3          	bne	s1,s2,80005e7a <printint+0x7e>
}
    80005e8c:	70a2                	ld	ra,40(sp)
    80005e8e:	7402                	ld	s0,32(sp)
    80005e90:	64e2                	ld	s1,24(sp)
    80005e92:	6942                	ld	s2,16(sp)
    80005e94:	6145                	addi	sp,sp,48
    80005e96:	8082                	ret
    x = -xx;
    80005e98:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e9c:	4885                	li	a7,1
    x = -xx;
    80005e9e:	bf95                	j	80005e12 <printint+0x16>

0000000080005ea0 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ea0:	1101                	addi	sp,sp,-32
    80005ea2:	ec06                	sd	ra,24(sp)
    80005ea4:	e822                	sd	s0,16(sp)
    80005ea6:	e426                	sd	s1,8(sp)
    80005ea8:	1000                	addi	s0,sp,32
    80005eaa:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005eac:	0002e797          	auipc	a5,0x2e
    80005eb0:	3407aa23          	sw	zero,852(a5) # 80034200 <pr+0x18>
  printf("panic: ");
    80005eb4:	00003517          	auipc	a0,0x3
    80005eb8:	8cc50513          	addi	a0,a0,-1844 # 80008780 <syscalls+0x3e0>
    80005ebc:	00000097          	auipc	ra,0x0
    80005ec0:	02e080e7          	jalr	46(ra) # 80005eea <printf>
  printf(s);
    80005ec4:	8526                	mv	a0,s1
    80005ec6:	00000097          	auipc	ra,0x0
    80005eca:	024080e7          	jalr	36(ra) # 80005eea <printf>
  printf("\n");
    80005ece:	00002517          	auipc	a0,0x2
    80005ed2:	17a50513          	addi	a0,a0,378 # 80008048 <etext+0x48>
    80005ed6:	00000097          	auipc	ra,0x0
    80005eda:	014080e7          	jalr	20(ra) # 80005eea <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ede:	4785                	li	a5,1
    80005ee0:	00003717          	auipc	a4,0x3
    80005ee4:	12f72e23          	sw	a5,316(a4) # 8000901c <panicked>
  for(;;)
    80005ee8:	a001                	j	80005ee8 <panic+0x48>

0000000080005eea <printf>:
{
    80005eea:	7131                	addi	sp,sp,-192
    80005eec:	fc86                	sd	ra,120(sp)
    80005eee:	f8a2                	sd	s0,112(sp)
    80005ef0:	f4a6                	sd	s1,104(sp)
    80005ef2:	f0ca                	sd	s2,96(sp)
    80005ef4:	ecce                	sd	s3,88(sp)
    80005ef6:	e8d2                	sd	s4,80(sp)
    80005ef8:	e4d6                	sd	s5,72(sp)
    80005efa:	e0da                	sd	s6,64(sp)
    80005efc:	fc5e                	sd	s7,56(sp)
    80005efe:	f862                	sd	s8,48(sp)
    80005f00:	f466                	sd	s9,40(sp)
    80005f02:	f06a                	sd	s10,32(sp)
    80005f04:	ec6e                	sd	s11,24(sp)
    80005f06:	0100                	addi	s0,sp,128
    80005f08:	8a2a                	mv	s4,a0
    80005f0a:	e40c                	sd	a1,8(s0)
    80005f0c:	e810                	sd	a2,16(s0)
    80005f0e:	ec14                	sd	a3,24(s0)
    80005f10:	f018                	sd	a4,32(s0)
    80005f12:	f41c                	sd	a5,40(s0)
    80005f14:	03043823          	sd	a6,48(s0)
    80005f18:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f1c:	0002ed97          	auipc	s11,0x2e
    80005f20:	2e4dad83          	lw	s11,740(s11) # 80034200 <pr+0x18>
  if(locking)
    80005f24:	020d9b63          	bnez	s11,80005f5a <printf+0x70>
  if (fmt == 0)
    80005f28:	040a0263          	beqz	s4,80005f6c <printf+0x82>
  va_start(ap, fmt);
    80005f2c:	00840793          	addi	a5,s0,8
    80005f30:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f34:	000a4503          	lbu	a0,0(s4)
    80005f38:	14050f63          	beqz	a0,80006096 <printf+0x1ac>
    80005f3c:	4981                	li	s3,0
    if(c != '%'){
    80005f3e:	02500a93          	li	s5,37
    switch(c){
    80005f42:	07000b93          	li	s7,112
  consputc('x');
    80005f46:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f48:	00003b17          	auipc	s6,0x3
    80005f4c:	860b0b13          	addi	s6,s6,-1952 # 800087a8 <digits>
    switch(c){
    80005f50:	07300c93          	li	s9,115
    80005f54:	06400c13          	li	s8,100
    80005f58:	a82d                	j	80005f92 <printf+0xa8>
    acquire(&pr.lock);
    80005f5a:	0002e517          	auipc	a0,0x2e
    80005f5e:	28e50513          	addi	a0,a0,654 # 800341e8 <pr>
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	476080e7          	jalr	1142(ra) # 800063d8 <acquire>
    80005f6a:	bf7d                	j	80005f28 <printf+0x3e>
    panic("null fmt");
    80005f6c:	00003517          	auipc	a0,0x3
    80005f70:	82450513          	addi	a0,a0,-2012 # 80008790 <syscalls+0x3f0>
    80005f74:	00000097          	auipc	ra,0x0
    80005f78:	f2c080e7          	jalr	-212(ra) # 80005ea0 <panic>
      consputc(c);
    80005f7c:	00000097          	auipc	ra,0x0
    80005f80:	c60080e7          	jalr	-928(ra) # 80005bdc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f84:	2985                	addiw	s3,s3,1
    80005f86:	013a07b3          	add	a5,s4,s3
    80005f8a:	0007c503          	lbu	a0,0(a5)
    80005f8e:	10050463          	beqz	a0,80006096 <printf+0x1ac>
    if(c != '%'){
    80005f92:	ff5515e3          	bne	a0,s5,80005f7c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f96:	2985                	addiw	s3,s3,1
    80005f98:	013a07b3          	add	a5,s4,s3
    80005f9c:	0007c783          	lbu	a5,0(a5)
    80005fa0:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005fa4:	cbed                	beqz	a5,80006096 <printf+0x1ac>
    switch(c){
    80005fa6:	05778a63          	beq	a5,s7,80005ffa <printf+0x110>
    80005faa:	02fbf663          	bgeu	s7,a5,80005fd6 <printf+0xec>
    80005fae:	09978863          	beq	a5,s9,8000603e <printf+0x154>
    80005fb2:	07800713          	li	a4,120
    80005fb6:	0ce79563          	bne	a5,a4,80006080 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005fba:	f8843783          	ld	a5,-120(s0)
    80005fbe:	00878713          	addi	a4,a5,8
    80005fc2:	f8e43423          	sd	a4,-120(s0)
    80005fc6:	4605                	li	a2,1
    80005fc8:	85ea                	mv	a1,s10
    80005fca:	4388                	lw	a0,0(a5)
    80005fcc:	00000097          	auipc	ra,0x0
    80005fd0:	e30080e7          	jalr	-464(ra) # 80005dfc <printint>
      break;
    80005fd4:	bf45                	j	80005f84 <printf+0x9a>
    switch(c){
    80005fd6:	09578f63          	beq	a5,s5,80006074 <printf+0x18a>
    80005fda:	0b879363          	bne	a5,s8,80006080 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005fde:	f8843783          	ld	a5,-120(s0)
    80005fe2:	00878713          	addi	a4,a5,8
    80005fe6:	f8e43423          	sd	a4,-120(s0)
    80005fea:	4605                	li	a2,1
    80005fec:	45a9                	li	a1,10
    80005fee:	4388                	lw	a0,0(a5)
    80005ff0:	00000097          	auipc	ra,0x0
    80005ff4:	e0c080e7          	jalr	-500(ra) # 80005dfc <printint>
      break;
    80005ff8:	b771                	j	80005f84 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ffa:	f8843783          	ld	a5,-120(s0)
    80005ffe:	00878713          	addi	a4,a5,8
    80006002:	f8e43423          	sd	a4,-120(s0)
    80006006:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000600a:	03000513          	li	a0,48
    8000600e:	00000097          	auipc	ra,0x0
    80006012:	bce080e7          	jalr	-1074(ra) # 80005bdc <consputc>
  consputc('x');
    80006016:	07800513          	li	a0,120
    8000601a:	00000097          	auipc	ra,0x0
    8000601e:	bc2080e7          	jalr	-1086(ra) # 80005bdc <consputc>
    80006022:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006024:	03c95793          	srli	a5,s2,0x3c
    80006028:	97da                	add	a5,a5,s6
    8000602a:	0007c503          	lbu	a0,0(a5)
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	bae080e7          	jalr	-1106(ra) # 80005bdc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006036:	0912                	slli	s2,s2,0x4
    80006038:	34fd                	addiw	s1,s1,-1
    8000603a:	f4ed                	bnez	s1,80006024 <printf+0x13a>
    8000603c:	b7a1                	j	80005f84 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    8000603e:	f8843783          	ld	a5,-120(s0)
    80006042:	00878713          	addi	a4,a5,8
    80006046:	f8e43423          	sd	a4,-120(s0)
    8000604a:	6384                	ld	s1,0(a5)
    8000604c:	cc89                	beqz	s1,80006066 <printf+0x17c>
      for(; *s; s++)
    8000604e:	0004c503          	lbu	a0,0(s1)
    80006052:	d90d                	beqz	a0,80005f84 <printf+0x9a>
        consputc(*s);
    80006054:	00000097          	auipc	ra,0x0
    80006058:	b88080e7          	jalr	-1144(ra) # 80005bdc <consputc>
      for(; *s; s++)
    8000605c:	0485                	addi	s1,s1,1
    8000605e:	0004c503          	lbu	a0,0(s1)
    80006062:	f96d                	bnez	a0,80006054 <printf+0x16a>
    80006064:	b705                	j	80005f84 <printf+0x9a>
        s = "(null)";
    80006066:	00002497          	auipc	s1,0x2
    8000606a:	72248493          	addi	s1,s1,1826 # 80008788 <syscalls+0x3e8>
      for(; *s; s++)
    8000606e:	02800513          	li	a0,40
    80006072:	b7cd                	j	80006054 <printf+0x16a>
      consputc('%');
    80006074:	8556                	mv	a0,s5
    80006076:	00000097          	auipc	ra,0x0
    8000607a:	b66080e7          	jalr	-1178(ra) # 80005bdc <consputc>
      break;
    8000607e:	b719                	j	80005f84 <printf+0x9a>
      consputc('%');
    80006080:	8556                	mv	a0,s5
    80006082:	00000097          	auipc	ra,0x0
    80006086:	b5a080e7          	jalr	-1190(ra) # 80005bdc <consputc>
      consputc(c);
    8000608a:	8526                	mv	a0,s1
    8000608c:	00000097          	auipc	ra,0x0
    80006090:	b50080e7          	jalr	-1200(ra) # 80005bdc <consputc>
      break;
    80006094:	bdc5                	j	80005f84 <printf+0x9a>
  if(locking)
    80006096:	020d9163          	bnez	s11,800060b8 <printf+0x1ce>
}
    8000609a:	70e6                	ld	ra,120(sp)
    8000609c:	7446                	ld	s0,112(sp)
    8000609e:	74a6                	ld	s1,104(sp)
    800060a0:	7906                	ld	s2,96(sp)
    800060a2:	69e6                	ld	s3,88(sp)
    800060a4:	6a46                	ld	s4,80(sp)
    800060a6:	6aa6                	ld	s5,72(sp)
    800060a8:	6b06                	ld	s6,64(sp)
    800060aa:	7be2                	ld	s7,56(sp)
    800060ac:	7c42                	ld	s8,48(sp)
    800060ae:	7ca2                	ld	s9,40(sp)
    800060b0:	7d02                	ld	s10,32(sp)
    800060b2:	6de2                	ld	s11,24(sp)
    800060b4:	6129                	addi	sp,sp,192
    800060b6:	8082                	ret
    release(&pr.lock);
    800060b8:	0002e517          	auipc	a0,0x2e
    800060bc:	13050513          	addi	a0,a0,304 # 800341e8 <pr>
    800060c0:	00000097          	auipc	ra,0x0
    800060c4:	3cc080e7          	jalr	972(ra) # 8000648c <release>
}
    800060c8:	bfc9                	j	8000609a <printf+0x1b0>

00000000800060ca <printfinit>:
    ;
}

void
printfinit(void)
{
    800060ca:	1101                	addi	sp,sp,-32
    800060cc:	ec06                	sd	ra,24(sp)
    800060ce:	e822                	sd	s0,16(sp)
    800060d0:	e426                	sd	s1,8(sp)
    800060d2:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800060d4:	0002e497          	auipc	s1,0x2e
    800060d8:	11448493          	addi	s1,s1,276 # 800341e8 <pr>
    800060dc:	00002597          	auipc	a1,0x2
    800060e0:	6c458593          	addi	a1,a1,1732 # 800087a0 <syscalls+0x400>
    800060e4:	8526                	mv	a0,s1
    800060e6:	00000097          	auipc	ra,0x0
    800060ea:	262080e7          	jalr	610(ra) # 80006348 <initlock>
  pr.locking = 1;
    800060ee:	4785                	li	a5,1
    800060f0:	cc9c                	sw	a5,24(s1)
}
    800060f2:	60e2                	ld	ra,24(sp)
    800060f4:	6442                	ld	s0,16(sp)
    800060f6:	64a2                	ld	s1,8(sp)
    800060f8:	6105                	addi	sp,sp,32
    800060fa:	8082                	ret

00000000800060fc <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060fc:	1141                	addi	sp,sp,-16
    800060fe:	e406                	sd	ra,8(sp)
    80006100:	e022                	sd	s0,0(sp)
    80006102:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006104:	100007b7          	lui	a5,0x10000
    80006108:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000610c:	f8000713          	li	a4,-128
    80006110:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006114:	470d                	li	a4,3
    80006116:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000611a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000611e:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006122:	469d                	li	a3,7
    80006124:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006128:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000612c:	00002597          	auipc	a1,0x2
    80006130:	69458593          	addi	a1,a1,1684 # 800087c0 <digits+0x18>
    80006134:	0002e517          	auipc	a0,0x2e
    80006138:	0d450513          	addi	a0,a0,212 # 80034208 <uart_tx_lock>
    8000613c:	00000097          	auipc	ra,0x0
    80006140:	20c080e7          	jalr	524(ra) # 80006348 <initlock>
}
    80006144:	60a2                	ld	ra,8(sp)
    80006146:	6402                	ld	s0,0(sp)
    80006148:	0141                	addi	sp,sp,16
    8000614a:	8082                	ret

000000008000614c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000614c:	1101                	addi	sp,sp,-32
    8000614e:	ec06                	sd	ra,24(sp)
    80006150:	e822                	sd	s0,16(sp)
    80006152:	e426                	sd	s1,8(sp)
    80006154:	1000                	addi	s0,sp,32
    80006156:	84aa                	mv	s1,a0
  push_off();
    80006158:	00000097          	auipc	ra,0x0
    8000615c:	234080e7          	jalr	564(ra) # 8000638c <push_off>

  if(panicked){
    80006160:	00003797          	auipc	a5,0x3
    80006164:	ebc7a783          	lw	a5,-324(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006168:	10000737          	lui	a4,0x10000
  if(panicked){
    8000616c:	c391                	beqz	a5,80006170 <uartputc_sync+0x24>
    for(;;)
    8000616e:	a001                	j	8000616e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006170:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006174:	0207f793          	andi	a5,a5,32
    80006178:	dfe5                	beqz	a5,80006170 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000617a:	0ff4f513          	zext.b	a0,s1
    8000617e:	100007b7          	lui	a5,0x10000
    80006182:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006186:	00000097          	auipc	ra,0x0
    8000618a:	2a6080e7          	jalr	678(ra) # 8000642c <pop_off>
}
    8000618e:	60e2                	ld	ra,24(sp)
    80006190:	6442                	ld	s0,16(sp)
    80006192:	64a2                	ld	s1,8(sp)
    80006194:	6105                	addi	sp,sp,32
    80006196:	8082                	ret

0000000080006198 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006198:	00003797          	auipc	a5,0x3
    8000619c:	e887b783          	ld	a5,-376(a5) # 80009020 <uart_tx_r>
    800061a0:	00003717          	auipc	a4,0x3
    800061a4:	e8873703          	ld	a4,-376(a4) # 80009028 <uart_tx_w>
    800061a8:	06f70a63          	beq	a4,a5,8000621c <uartstart+0x84>
{
    800061ac:	7139                	addi	sp,sp,-64
    800061ae:	fc06                	sd	ra,56(sp)
    800061b0:	f822                	sd	s0,48(sp)
    800061b2:	f426                	sd	s1,40(sp)
    800061b4:	f04a                	sd	s2,32(sp)
    800061b6:	ec4e                	sd	s3,24(sp)
    800061b8:	e852                	sd	s4,16(sp)
    800061ba:	e456                	sd	s5,8(sp)
    800061bc:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061be:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061c2:	0002ea17          	auipc	s4,0x2e
    800061c6:	046a0a13          	addi	s4,s4,70 # 80034208 <uart_tx_lock>
    uart_tx_r += 1;
    800061ca:	00003497          	auipc	s1,0x3
    800061ce:	e5648493          	addi	s1,s1,-426 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800061d2:	00003997          	auipc	s3,0x3
    800061d6:	e5698993          	addi	s3,s3,-426 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061da:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800061de:	02077713          	andi	a4,a4,32
    800061e2:	c705                	beqz	a4,8000620a <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061e4:	01f7f713          	andi	a4,a5,31
    800061e8:	9752                	add	a4,a4,s4
    800061ea:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800061ee:	0785                	addi	a5,a5,1
    800061f0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061f2:	8526                	mv	a0,s1
    800061f4:	ffffb097          	auipc	ra,0xffffb
    800061f8:	486080e7          	jalr	1158(ra) # 8000167a <wakeup>
    
    WriteReg(THR, c);
    800061fc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006200:	609c                	ld	a5,0(s1)
    80006202:	0009b703          	ld	a4,0(s3)
    80006206:	fcf71ae3          	bne	a4,a5,800061da <uartstart+0x42>
  }
}
    8000620a:	70e2                	ld	ra,56(sp)
    8000620c:	7442                	ld	s0,48(sp)
    8000620e:	74a2                	ld	s1,40(sp)
    80006210:	7902                	ld	s2,32(sp)
    80006212:	69e2                	ld	s3,24(sp)
    80006214:	6a42                	ld	s4,16(sp)
    80006216:	6aa2                	ld	s5,8(sp)
    80006218:	6121                	addi	sp,sp,64
    8000621a:	8082                	ret
    8000621c:	8082                	ret

000000008000621e <uartputc>:
{
    8000621e:	7179                	addi	sp,sp,-48
    80006220:	f406                	sd	ra,40(sp)
    80006222:	f022                	sd	s0,32(sp)
    80006224:	ec26                	sd	s1,24(sp)
    80006226:	e84a                	sd	s2,16(sp)
    80006228:	e44e                	sd	s3,8(sp)
    8000622a:	e052                	sd	s4,0(sp)
    8000622c:	1800                	addi	s0,sp,48
    8000622e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006230:	0002e517          	auipc	a0,0x2e
    80006234:	fd850513          	addi	a0,a0,-40 # 80034208 <uart_tx_lock>
    80006238:	00000097          	auipc	ra,0x0
    8000623c:	1a0080e7          	jalr	416(ra) # 800063d8 <acquire>
  if(panicked){
    80006240:	00003797          	auipc	a5,0x3
    80006244:	ddc7a783          	lw	a5,-548(a5) # 8000901c <panicked>
    80006248:	c391                	beqz	a5,8000624c <uartputc+0x2e>
    for(;;)
    8000624a:	a001                	j	8000624a <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000624c:	00003717          	auipc	a4,0x3
    80006250:	ddc73703          	ld	a4,-548(a4) # 80009028 <uart_tx_w>
    80006254:	00003797          	auipc	a5,0x3
    80006258:	dcc7b783          	ld	a5,-564(a5) # 80009020 <uart_tx_r>
    8000625c:	02078793          	addi	a5,a5,32
    80006260:	02e79b63          	bne	a5,a4,80006296 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006264:	0002e997          	auipc	s3,0x2e
    80006268:	fa498993          	addi	s3,s3,-92 # 80034208 <uart_tx_lock>
    8000626c:	00003497          	auipc	s1,0x3
    80006270:	db448493          	addi	s1,s1,-588 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006274:	00003917          	auipc	s2,0x3
    80006278:	db490913          	addi	s2,s2,-588 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000627c:	85ce                	mv	a1,s3
    8000627e:	8526                	mv	a0,s1
    80006280:	ffffb097          	auipc	ra,0xffffb
    80006284:	26e080e7          	jalr	622(ra) # 800014ee <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006288:	00093703          	ld	a4,0(s2)
    8000628c:	609c                	ld	a5,0(s1)
    8000628e:	02078793          	addi	a5,a5,32
    80006292:	fee785e3          	beq	a5,a4,8000627c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006296:	0002e497          	auipc	s1,0x2e
    8000629a:	f7248493          	addi	s1,s1,-142 # 80034208 <uart_tx_lock>
    8000629e:	01f77793          	andi	a5,a4,31
    800062a2:	97a6                	add	a5,a5,s1
    800062a4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800062a8:	0705                	addi	a4,a4,1
    800062aa:	00003797          	auipc	a5,0x3
    800062ae:	d6e7bf23          	sd	a4,-642(a5) # 80009028 <uart_tx_w>
      uartstart();
    800062b2:	00000097          	auipc	ra,0x0
    800062b6:	ee6080e7          	jalr	-282(ra) # 80006198 <uartstart>
      release(&uart_tx_lock);
    800062ba:	8526                	mv	a0,s1
    800062bc:	00000097          	auipc	ra,0x0
    800062c0:	1d0080e7          	jalr	464(ra) # 8000648c <release>
}
    800062c4:	70a2                	ld	ra,40(sp)
    800062c6:	7402                	ld	s0,32(sp)
    800062c8:	64e2                	ld	s1,24(sp)
    800062ca:	6942                	ld	s2,16(sp)
    800062cc:	69a2                	ld	s3,8(sp)
    800062ce:	6a02                	ld	s4,0(sp)
    800062d0:	6145                	addi	sp,sp,48
    800062d2:	8082                	ret

00000000800062d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062d4:	1141                	addi	sp,sp,-16
    800062d6:	e422                	sd	s0,8(sp)
    800062d8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062da:	100007b7          	lui	a5,0x10000
    800062de:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800062e2:	8b85                	andi	a5,a5,1
    800062e4:	cb81                	beqz	a5,800062f4 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800062e6:	100007b7          	lui	a5,0x10000
    800062ea:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800062ee:	6422                	ld	s0,8(sp)
    800062f0:	0141                	addi	sp,sp,16
    800062f2:	8082                	ret
    return -1;
    800062f4:	557d                	li	a0,-1
    800062f6:	bfe5                	j	800062ee <uartgetc+0x1a>

00000000800062f8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800062f8:	1101                	addi	sp,sp,-32
    800062fa:	ec06                	sd	ra,24(sp)
    800062fc:	e822                	sd	s0,16(sp)
    800062fe:	e426                	sd	s1,8(sp)
    80006300:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006302:	54fd                	li	s1,-1
    80006304:	a029                	j	8000630e <uartintr+0x16>
      break;
    consoleintr(c);
    80006306:	00000097          	auipc	ra,0x0
    8000630a:	918080e7          	jalr	-1768(ra) # 80005c1e <consoleintr>
    int c = uartgetc();
    8000630e:	00000097          	auipc	ra,0x0
    80006312:	fc6080e7          	jalr	-58(ra) # 800062d4 <uartgetc>
    if(c == -1)
    80006316:	fe9518e3          	bne	a0,s1,80006306 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000631a:	0002e497          	auipc	s1,0x2e
    8000631e:	eee48493          	addi	s1,s1,-274 # 80034208 <uart_tx_lock>
    80006322:	8526                	mv	a0,s1
    80006324:	00000097          	auipc	ra,0x0
    80006328:	0b4080e7          	jalr	180(ra) # 800063d8 <acquire>
  uartstart();
    8000632c:	00000097          	auipc	ra,0x0
    80006330:	e6c080e7          	jalr	-404(ra) # 80006198 <uartstart>
  release(&uart_tx_lock);
    80006334:	8526                	mv	a0,s1
    80006336:	00000097          	auipc	ra,0x0
    8000633a:	156080e7          	jalr	342(ra) # 8000648c <release>
}
    8000633e:	60e2                	ld	ra,24(sp)
    80006340:	6442                	ld	s0,16(sp)
    80006342:	64a2                	ld	s1,8(sp)
    80006344:	6105                	addi	sp,sp,32
    80006346:	8082                	ret

0000000080006348 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006348:	1141                	addi	sp,sp,-16
    8000634a:	e422                	sd	s0,8(sp)
    8000634c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000634e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006350:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006354:	00053823          	sd	zero,16(a0)
}
    80006358:	6422                	ld	s0,8(sp)
    8000635a:	0141                	addi	sp,sp,16
    8000635c:	8082                	ret

000000008000635e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000635e:	411c                	lw	a5,0(a0)
    80006360:	e399                	bnez	a5,80006366 <holding+0x8>
    80006362:	4501                	li	a0,0
  return r;
}
    80006364:	8082                	ret
{
    80006366:	1101                	addi	sp,sp,-32
    80006368:	ec06                	sd	ra,24(sp)
    8000636a:	e822                	sd	s0,16(sp)
    8000636c:	e426                	sd	s1,8(sp)
    8000636e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006370:	6904                	ld	s1,16(a0)
    80006372:	ffffb097          	auipc	ra,0xffffb
    80006376:	a9c080e7          	jalr	-1380(ra) # 80000e0e <mycpu>
    8000637a:	40a48533          	sub	a0,s1,a0
    8000637e:	00153513          	seqz	a0,a0
}
    80006382:	60e2                	ld	ra,24(sp)
    80006384:	6442                	ld	s0,16(sp)
    80006386:	64a2                	ld	s1,8(sp)
    80006388:	6105                	addi	sp,sp,32
    8000638a:	8082                	ret

000000008000638c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000638c:	1101                	addi	sp,sp,-32
    8000638e:	ec06                	sd	ra,24(sp)
    80006390:	e822                	sd	s0,16(sp)
    80006392:	e426                	sd	s1,8(sp)
    80006394:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006396:	100024f3          	csrr	s1,sstatus
    8000639a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000639e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063a0:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800063a4:	ffffb097          	auipc	ra,0xffffb
    800063a8:	a6a080e7          	jalr	-1430(ra) # 80000e0e <mycpu>
    800063ac:	5d3c                	lw	a5,120(a0)
    800063ae:	cf89                	beqz	a5,800063c8 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800063b0:	ffffb097          	auipc	ra,0xffffb
    800063b4:	a5e080e7          	jalr	-1442(ra) # 80000e0e <mycpu>
    800063b8:	5d3c                	lw	a5,120(a0)
    800063ba:	2785                	addiw	a5,a5,1
    800063bc:	dd3c                	sw	a5,120(a0)
}
    800063be:	60e2                	ld	ra,24(sp)
    800063c0:	6442                	ld	s0,16(sp)
    800063c2:	64a2                	ld	s1,8(sp)
    800063c4:	6105                	addi	sp,sp,32
    800063c6:	8082                	ret
    mycpu()->intena = old;
    800063c8:	ffffb097          	auipc	ra,0xffffb
    800063cc:	a46080e7          	jalr	-1466(ra) # 80000e0e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063d0:	8085                	srli	s1,s1,0x1
    800063d2:	8885                	andi	s1,s1,1
    800063d4:	dd64                	sw	s1,124(a0)
    800063d6:	bfe9                	j	800063b0 <push_off+0x24>

00000000800063d8 <acquire>:
{
    800063d8:	1101                	addi	sp,sp,-32
    800063da:	ec06                	sd	ra,24(sp)
    800063dc:	e822                	sd	s0,16(sp)
    800063de:	e426                	sd	s1,8(sp)
    800063e0:	1000                	addi	s0,sp,32
    800063e2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063e4:	00000097          	auipc	ra,0x0
    800063e8:	fa8080e7          	jalr	-88(ra) # 8000638c <push_off>
  if(holding(lk))
    800063ec:	8526                	mv	a0,s1
    800063ee:	00000097          	auipc	ra,0x0
    800063f2:	f70080e7          	jalr	-144(ra) # 8000635e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063f6:	4705                	li	a4,1
  if(holding(lk))
    800063f8:	e115                	bnez	a0,8000641c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063fa:	87ba                	mv	a5,a4
    800063fc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006400:	2781                	sext.w	a5,a5
    80006402:	ffe5                	bnez	a5,800063fa <acquire+0x22>
  __sync_synchronize();
    80006404:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006408:	ffffb097          	auipc	ra,0xffffb
    8000640c:	a06080e7          	jalr	-1530(ra) # 80000e0e <mycpu>
    80006410:	e888                	sd	a0,16(s1)
}
    80006412:	60e2                	ld	ra,24(sp)
    80006414:	6442                	ld	s0,16(sp)
    80006416:	64a2                	ld	s1,8(sp)
    80006418:	6105                	addi	sp,sp,32
    8000641a:	8082                	ret
    panic("acquire");
    8000641c:	00002517          	auipc	a0,0x2
    80006420:	3ac50513          	addi	a0,a0,940 # 800087c8 <digits+0x20>
    80006424:	00000097          	auipc	ra,0x0
    80006428:	a7c080e7          	jalr	-1412(ra) # 80005ea0 <panic>

000000008000642c <pop_off>:

void
pop_off(void)
{
    8000642c:	1141                	addi	sp,sp,-16
    8000642e:	e406                	sd	ra,8(sp)
    80006430:	e022                	sd	s0,0(sp)
    80006432:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006434:	ffffb097          	auipc	ra,0xffffb
    80006438:	9da080e7          	jalr	-1574(ra) # 80000e0e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000643c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006440:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006442:	e78d                	bnez	a5,8000646c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006444:	5d3c                	lw	a5,120(a0)
    80006446:	02f05b63          	blez	a5,8000647c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000644a:	37fd                	addiw	a5,a5,-1
    8000644c:	0007871b          	sext.w	a4,a5
    80006450:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006452:	eb09                	bnez	a4,80006464 <pop_off+0x38>
    80006454:	5d7c                	lw	a5,124(a0)
    80006456:	c799                	beqz	a5,80006464 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006458:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000645c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006460:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006464:	60a2                	ld	ra,8(sp)
    80006466:	6402                	ld	s0,0(sp)
    80006468:	0141                	addi	sp,sp,16
    8000646a:	8082                	ret
    panic("pop_off - interruptible");
    8000646c:	00002517          	auipc	a0,0x2
    80006470:	36450513          	addi	a0,a0,868 # 800087d0 <digits+0x28>
    80006474:	00000097          	auipc	ra,0x0
    80006478:	a2c080e7          	jalr	-1492(ra) # 80005ea0 <panic>
    panic("pop_off");
    8000647c:	00002517          	auipc	a0,0x2
    80006480:	36c50513          	addi	a0,a0,876 # 800087e8 <digits+0x40>
    80006484:	00000097          	auipc	ra,0x0
    80006488:	a1c080e7          	jalr	-1508(ra) # 80005ea0 <panic>

000000008000648c <release>:
{
    8000648c:	1101                	addi	sp,sp,-32
    8000648e:	ec06                	sd	ra,24(sp)
    80006490:	e822                	sd	s0,16(sp)
    80006492:	e426                	sd	s1,8(sp)
    80006494:	1000                	addi	s0,sp,32
    80006496:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006498:	00000097          	auipc	ra,0x0
    8000649c:	ec6080e7          	jalr	-314(ra) # 8000635e <holding>
    800064a0:	c115                	beqz	a0,800064c4 <release+0x38>
  lk->cpu = 0;
    800064a2:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800064a6:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800064aa:	0f50000f          	fence	iorw,ow
    800064ae:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800064b2:	00000097          	auipc	ra,0x0
    800064b6:	f7a080e7          	jalr	-134(ra) # 8000642c <pop_off>
}
    800064ba:	60e2                	ld	ra,24(sp)
    800064bc:	6442                	ld	s0,16(sp)
    800064be:	64a2                	ld	s1,8(sp)
    800064c0:	6105                	addi	sp,sp,32
    800064c2:	8082                	ret
    panic("release");
    800064c4:	00002517          	auipc	a0,0x2
    800064c8:	32c50513          	addi	a0,a0,812 # 800087f0 <digits+0x48>
    800064cc:	00000097          	auipc	ra,0x0
    800064d0:	9d4080e7          	jalr	-1580(ra) # 80005ea0 <panic>
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
