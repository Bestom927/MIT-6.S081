
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	86013103          	ld	sp,-1952(sp) # 80008860 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	61c050ef          	jal	ra,80005632 <start>

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
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	fbe080e7          	jalr	-66(ra) # 80006018 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	05e080e7          	jalr	94(ra) # 800060cc <release>
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
    8000008e:	a56080e7          	jalr	-1450(ra) # 80005ae0 <panic>

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
    800000fa:	e92080e7          	jalr	-366(ra) # 80005f88 <initlock>
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
    80000132:	eea080e7          	jalr	-278(ra) # 80006018 <acquire>
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
    8000014a:	f86080e7          	jalr	-122(ra) # 800060cc <release>

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
    80000174:	f5c080e7          	jalr	-164(ra) # 800060cc <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
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
    8000032c:	af0080e7          	jalr	-1296(ra) # 80000e18 <cpuid>
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
    80000348:	ad4080e7          	jalr	-1324(ra) # 80000e18 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00005097          	auipc	ra,0x5
    8000035a:	7d4080e7          	jalr	2004(ra) # 80005b2a <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	734080e7          	jalr	1844(ra) # 80001a9a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	ca2080e7          	jalr	-862(ra) # 80005010 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	fe0080e7          	jalr	-32(ra) # 80001356 <scheduler>
    consoleinit();
    8000037e:	00005097          	auipc	ra,0x5
    80000382:	672080e7          	jalr	1650(ra) # 800059f0 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	984080e7          	jalr	-1660(ra) # 80005d0a <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00005097          	auipc	ra,0x5
    8000039a:	794080e7          	jalr	1940(ra) # 80005b2a <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00005097          	auipc	ra,0x5
    800003aa:	784080e7          	jalr	1924(ra) # 80005b2a <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00005097          	auipc	ra,0x5
    800003ba:	774080e7          	jalr	1908(ra) # 80005b2a <printf>
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
    800003da:	992080e7          	jalr	-1646(ra) # 80000d68 <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	694080e7          	jalr	1684(ra) # 80001a72 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	6b4080e7          	jalr	1716(ra) # 80001a9a <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	c0c080e7          	jalr	-1012(ra) # 80004ffa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	c1a080e7          	jalr	-998(ra) # 80005010 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	dde080e7          	jalr	-546(ra) # 800021dc <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	46c080e7          	jalr	1132(ra) # 80002872 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	41e080e7          	jalr	1054(ra) # 8000382c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	d1a080e7          	jalr	-742(ra) # 80005130 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	cfe080e7          	jalr	-770(ra) # 8000111c <userinit>
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
    80000488:	00005097          	auipc	ra,0x5
    8000048c:	658080e7          	jalr	1624(ra) # 80005ae0 <panic>
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
    800004ba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
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
    800005ae:	00005097          	auipc	ra,0x5
    800005b2:	532080e7          	jalr	1330(ra) # 80005ae0 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00005097          	auipc	ra,0x5
    800005c2:	522080e7          	jalr	1314(ra) # 80005ae0 <panic>
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
    8000060a:	00005097          	auipc	ra,0x5
    8000060e:	4d6080e7          	jalr	1238(ra) # 80005ae0 <panic>

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
    800006d6:	600080e7          	jalr	1536(ra) # 80000cd2 <proc_mapstacks>
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
    80000728:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072a:	0632                	slli	a2,a2,0xc
    8000072c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000730:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000732:	6b05                	lui	s6,0x1
    80000734:	0735e263          	bltu	a1,s3,80000798 <uvmunmap+0x90>
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
    8000075a:	38a080e7          	jalr	906(ra) # 80005ae0 <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00005097          	auipc	ra,0x5
    8000076a:	37a080e7          	jalr	890(ra) # 80005ae0 <panic>
      panic("uvmunmap: not mapped");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00005097          	auipc	ra,0x5
    8000077a:	36a080e7          	jalr	874(ra) # 80005ae0 <panic>
      panic("uvmunmap: not a leaf");
    8000077e:	00008517          	auipc	a0,0x8
    80000782:	94250513          	addi	a0,a0,-1726 # 800080c0 <etext+0xc0>
    80000786:	00005097          	auipc	ra,0x5
    8000078a:	35a080e7          	jalr	858(ra) # 80005ae0 <panic>
    *pte = 0;
    8000078e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000792:	995a                	add	s2,s2,s6
    80000794:	fb3972e3          	bgeu	s2,s3,80000738 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000798:	4601                	li	a2,0
    8000079a:	85ca                	mv	a1,s2
    8000079c:	8552                	mv	a0,s4
    8000079e:	00000097          	auipc	ra,0x0
    800007a2:	cbc080e7          	jalr	-836(ra) # 8000045a <walk>
    800007a6:	84aa                	mv	s1,a0
    800007a8:	d95d                	beqz	a0,8000075e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007aa:	6108                	ld	a0,0(a0)
    800007ac:	00157793          	andi	a5,a0,1
    800007b0:	dfdd                	beqz	a5,8000076e <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b2:	3ff57793          	andi	a5,a0,1023
    800007b6:	fd7784e3          	beq	a5,s7,8000077e <uvmunmap+0x76>
    if(do_free){
    800007ba:	fc0a8ae3          	beqz	s5,8000078e <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007be:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c0:	0532                	slli	a0,a0,0xc
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	85a080e7          	jalr	-1958(ra) # 8000001c <kfree>
    800007ca:	b7d1                	j	8000078e <uvmunmap+0x86>

00000000800007cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007cc:	1101                	addi	sp,sp,-32
    800007ce:	ec06                	sd	ra,24(sp)
    800007d0:	e822                	sd	s0,16(sp)
    800007d2:	e426                	sd	s1,8(sp)
    800007d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	944080e7          	jalr	-1724(ra) # 8000011a <kalloc>
    800007de:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e0:	c519                	beqz	a0,800007ee <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e2:	6605                	lui	a2,0x1
    800007e4:	4581                	li	a1,0
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	994080e7          	jalr	-1644(ra) # 8000017a <memset>
  return pagetable;
}
    800007ee:	8526                	mv	a0,s1
    800007f0:	60e2                	ld	ra,24(sp)
    800007f2:	6442                	ld	s0,16(sp)
    800007f4:	64a2                	ld	s1,8(sp)
    800007f6:	6105                	addi	sp,sp,32
    800007f8:	8082                	ret

00000000800007fa <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fa:	7179                	addi	sp,sp,-48
    800007fc:	f406                	sd	ra,40(sp)
    800007fe:	f022                	sd	s0,32(sp)
    80000800:	ec26                	sd	s1,24(sp)
    80000802:	e84a                	sd	s2,16(sp)
    80000804:	e44e                	sd	s3,8(sp)
    80000806:	e052                	sd	s4,0(sp)
    80000808:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080a:	6785                	lui	a5,0x1
    8000080c:	04f67863          	bgeu	a2,a5,8000085c <uvminit+0x62>
    80000810:	8a2a                	mv	s4,a0
    80000812:	89ae                	mv	s3,a1
    80000814:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	904080e7          	jalr	-1788(ra) # 8000011a <kalloc>
    8000081e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000820:	6605                	lui	a2,0x1
    80000822:	4581                	li	a1,0
    80000824:	00000097          	auipc	ra,0x0
    80000828:	956080e7          	jalr	-1706(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082c:	4779                	li	a4,30
    8000082e:	86ca                	mv	a3,s2
    80000830:	6605                	lui	a2,0x1
    80000832:	4581                	li	a1,0
    80000834:	8552                	mv	a0,s4
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	d0c080e7          	jalr	-756(ra) # 80000542 <mappages>
  memmove(mem, src, sz);
    8000083e:	8626                	mv	a2,s1
    80000840:	85ce                	mv	a1,s3
    80000842:	854a                	mv	a0,s2
    80000844:	00000097          	auipc	ra,0x0
    80000848:	992080e7          	jalr	-1646(ra) # 800001d6 <memmove>
}
    8000084c:	70a2                	ld	ra,40(sp)
    8000084e:	7402                	ld	s0,32(sp)
    80000850:	64e2                	ld	s1,24(sp)
    80000852:	6942                	ld	s2,16(sp)
    80000854:	69a2                	ld	s3,8(sp)
    80000856:	6a02                	ld	s4,0(sp)
    80000858:	6145                	addi	sp,sp,48
    8000085a:	8082                	ret
    panic("inituvm: more than a page");
    8000085c:	00008517          	auipc	a0,0x8
    80000860:	87c50513          	addi	a0,a0,-1924 # 800080d8 <etext+0xd8>
    80000864:	00005097          	auipc	ra,0x5
    80000868:	27c080e7          	jalr	636(ra) # 80005ae0 <panic>

000000008000086c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086c:	1101                	addi	sp,sp,-32
    8000086e:	ec06                	sd	ra,24(sp)
    80000870:	e822                	sd	s0,16(sp)
    80000872:	e426                	sd	s1,8(sp)
    80000874:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000876:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000878:	00b67d63          	bgeu	a2,a1,80000892 <uvmdealloc+0x26>
    8000087c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087e:	6785                	lui	a5,0x1
    80000880:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000882:	00f60733          	add	a4,a2,a5
    80000886:	76fd                	lui	a3,0xfffff
    80000888:	8f75                	and	a4,a4,a3
    8000088a:	97ae                	add	a5,a5,a1
    8000088c:	8ff5                	and	a5,a5,a3
    8000088e:	00f76863          	bltu	a4,a5,8000089e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000892:	8526                	mv	a0,s1
    80000894:	60e2                	ld	ra,24(sp)
    80000896:	6442                	ld	s0,16(sp)
    80000898:	64a2                	ld	s1,8(sp)
    8000089a:	6105                	addi	sp,sp,32
    8000089c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089e:	8f99                	sub	a5,a5,a4
    800008a0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a2:	4685                	li	a3,1
    800008a4:	0007861b          	sext.w	a2,a5
    800008a8:	85ba                	mv	a1,a4
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	e5e080e7          	jalr	-418(ra) # 80000708 <uvmunmap>
    800008b2:	b7c5                	j	80000892 <uvmdealloc+0x26>

00000000800008b4 <uvmalloc>:
  if(newsz < oldsz)
    800008b4:	0ab66163          	bltu	a2,a1,80000956 <uvmalloc+0xa2>
{
    800008b8:	7139                	addi	sp,sp,-64
    800008ba:	fc06                	sd	ra,56(sp)
    800008bc:	f822                	sd	s0,48(sp)
    800008be:	f426                	sd	s1,40(sp)
    800008c0:	f04a                	sd	s2,32(sp)
    800008c2:	ec4e                	sd	s3,24(sp)
    800008c4:	e852                	sd	s4,16(sp)
    800008c6:	e456                	sd	s5,8(sp)
    800008c8:	0080                	addi	s0,sp,64
    800008ca:	8aaa                	mv	s5,a0
    800008cc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d2:	95be                	add	a1,a1,a5
    800008d4:	77fd                	lui	a5,0xfffff
    800008d6:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008da:	08c9f063          	bgeu	s3,a2,8000095a <uvmalloc+0xa6>
    800008de:	894e                	mv	s2,s3
    mem = kalloc();
    800008e0:	00000097          	auipc	ra,0x0
    800008e4:	83a080e7          	jalr	-1990(ra) # 8000011a <kalloc>
    800008e8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008ea:	c51d                	beqz	a0,80000918 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008ec:	6605                	lui	a2,0x1
    800008ee:	4581                	li	a1,0
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	88a080e7          	jalr	-1910(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f8:	4779                	li	a4,30
    800008fa:	86a6                	mv	a3,s1
    800008fc:	6605                	lui	a2,0x1
    800008fe:	85ca                	mv	a1,s2
    80000900:	8556                	mv	a0,s5
    80000902:	00000097          	auipc	ra,0x0
    80000906:	c40080e7          	jalr	-960(ra) # 80000542 <mappages>
    8000090a:	e905                	bnez	a0,8000093a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090c:	6785                	lui	a5,0x1
    8000090e:	993e                	add	s2,s2,a5
    80000910:	fd4968e3          	bltu	s2,s4,800008e0 <uvmalloc+0x2c>
  return newsz;
    80000914:	8552                	mv	a0,s4
    80000916:	a809                	j	80000928 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000918:	864e                	mv	a2,s3
    8000091a:	85ca                	mv	a1,s2
    8000091c:	8556                	mv	a0,s5
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	f4e080e7          	jalr	-178(ra) # 8000086c <uvmdealloc>
      return 0;
    80000926:	4501                	li	a0,0
}
    80000928:	70e2                	ld	ra,56(sp)
    8000092a:	7442                	ld	s0,48(sp)
    8000092c:	74a2                	ld	s1,40(sp)
    8000092e:	7902                	ld	s2,32(sp)
    80000930:	69e2                	ld	s3,24(sp)
    80000932:	6a42                	ld	s4,16(sp)
    80000934:	6aa2                	ld	s5,8(sp)
    80000936:	6121                	addi	sp,sp,64
    80000938:	8082                	ret
      kfree(mem);
    8000093a:	8526                	mv	a0,s1
    8000093c:	fffff097          	auipc	ra,0xfffff
    80000940:	6e0080e7          	jalr	1760(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000944:	864e                	mv	a2,s3
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	f22080e7          	jalr	-222(ra) # 8000086c <uvmdealloc>
      return 0;
    80000952:	4501                	li	a0,0
    80000954:	bfd1                	j	80000928 <uvmalloc+0x74>
    return oldsz;
    80000956:	852e                	mv	a0,a1
}
    80000958:	8082                	ret
  return newsz;
    8000095a:	8532                	mv	a0,a2
    8000095c:	b7f1                	j	80000928 <uvmalloc+0x74>

000000008000095e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095e:	7179                	addi	sp,sp,-48
    80000960:	f406                	sd	ra,40(sp)
    80000962:	f022                	sd	s0,32(sp)
    80000964:	ec26                	sd	s1,24(sp)
    80000966:	e84a                	sd	s2,16(sp)
    80000968:	e44e                	sd	s3,8(sp)
    8000096a:	e052                	sd	s4,0(sp)
    8000096c:	1800                	addi	s0,sp,48
    8000096e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000970:	84aa                	mv	s1,a0
    80000972:	6905                	lui	s2,0x1
    80000974:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000976:	4985                	li	s3,1
    80000978:	a829                	j	80000992 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000097a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000097c:	00c79513          	slli	a0,a5,0xc
    80000980:	00000097          	auipc	ra,0x0
    80000984:	fde080e7          	jalr	-34(ra) # 8000095e <freewalk>
      pagetable[i] = 0;
    80000988:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000098c:	04a1                	addi	s1,s1,8
    8000098e:	03248163          	beq	s1,s2,800009b0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000992:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000994:	00f7f713          	andi	a4,a5,15
    80000998:	ff3701e3          	beq	a4,s3,8000097a <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000099c:	8b85                	andi	a5,a5,1
    8000099e:	d7fd                	beqz	a5,8000098c <freewalk+0x2e>
      panic("freewalk: leaf");
    800009a0:	00007517          	auipc	a0,0x7
    800009a4:	75850513          	addi	a0,a0,1880 # 800080f8 <etext+0xf8>
    800009a8:	00005097          	auipc	ra,0x5
    800009ac:	138080e7          	jalr	312(ra) # 80005ae0 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b0:	8552                	mv	a0,s4
    800009b2:	fffff097          	auipc	ra,0xfffff
    800009b6:	66a080e7          	jalr	1642(ra) # 8000001c <kfree>
}
    800009ba:	70a2                	ld	ra,40(sp)
    800009bc:	7402                	ld	s0,32(sp)
    800009be:	64e2                	ld	s1,24(sp)
    800009c0:	6942                	ld	s2,16(sp)
    800009c2:	69a2                	ld	s3,8(sp)
    800009c4:	6a02                	ld	s4,0(sp)
    800009c6:	6145                	addi	sp,sp,48
    800009c8:	8082                	ret

00000000800009ca <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ca:	1101                	addi	sp,sp,-32
    800009cc:	ec06                	sd	ra,24(sp)
    800009ce:	e822                	sd	s0,16(sp)
    800009d0:	e426                	sd	s1,8(sp)
    800009d2:	1000                	addi	s0,sp,32
    800009d4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d6:	e999                	bnez	a1,800009ec <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d8:	8526                	mv	a0,s1
    800009da:	00000097          	auipc	ra,0x0
    800009de:	f84080e7          	jalr	-124(ra) # 8000095e <freewalk>
}
    800009e2:	60e2                	ld	ra,24(sp)
    800009e4:	6442                	ld	s0,16(sp)
    800009e6:	64a2                	ld	s1,8(sp)
    800009e8:	6105                	addi	sp,sp,32
    800009ea:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009ec:	6785                	lui	a5,0x1
    800009ee:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009f0:	95be                	add	a1,a1,a5
    800009f2:	4685                	li	a3,1
    800009f4:	00c5d613          	srli	a2,a1,0xc
    800009f8:	4581                	li	a1,0
    800009fa:	00000097          	auipc	ra,0x0
    800009fe:	d0e080e7          	jalr	-754(ra) # 80000708 <uvmunmap>
    80000a02:	bfd9                	j	800009d8 <uvmfree+0xe>

0000000080000a04 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a04:	c679                	beqz	a2,80000ad2 <uvmcopy+0xce>
{
    80000a06:	715d                	addi	sp,sp,-80
    80000a08:	e486                	sd	ra,72(sp)
    80000a0a:	e0a2                	sd	s0,64(sp)
    80000a0c:	fc26                	sd	s1,56(sp)
    80000a0e:	f84a                	sd	s2,48(sp)
    80000a10:	f44e                	sd	s3,40(sp)
    80000a12:	f052                	sd	s4,32(sp)
    80000a14:	ec56                	sd	s5,24(sp)
    80000a16:	e85a                	sd	s6,16(sp)
    80000a18:	e45e                	sd	s7,8(sp)
    80000a1a:	0880                	addi	s0,sp,80
    80000a1c:	8b2a                	mv	s6,a0
    80000a1e:	8aae                	mv	s5,a1
    80000a20:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a22:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a24:	4601                	li	a2,0
    80000a26:	85ce                	mv	a1,s3
    80000a28:	855a                	mv	a0,s6
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	a30080e7          	jalr	-1488(ra) # 8000045a <walk>
    80000a32:	c531                	beqz	a0,80000a7e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a34:	6118                	ld	a4,0(a0)
    80000a36:	00177793          	andi	a5,a4,1
    80000a3a:	cbb1                	beqz	a5,80000a8e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3c:	00a75593          	srli	a1,a4,0xa
    80000a40:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a44:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a48:	fffff097          	auipc	ra,0xfffff
    80000a4c:	6d2080e7          	jalr	1746(ra) # 8000011a <kalloc>
    80000a50:	892a                	mv	s2,a0
    80000a52:	c939                	beqz	a0,80000aa8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a54:	6605                	lui	a2,0x1
    80000a56:	85de                	mv	a1,s7
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	77e080e7          	jalr	1918(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a60:	8726                	mv	a4,s1
    80000a62:	86ca                	mv	a3,s2
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85ce                	mv	a1,s3
    80000a68:	8556                	mv	a0,s5
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	ad8080e7          	jalr	-1320(ra) # 80000542 <mappages>
    80000a72:	e515                	bnez	a0,80000a9e <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a74:	6785                	lui	a5,0x1
    80000a76:	99be                	add	s3,s3,a5
    80000a78:	fb49e6e3          	bltu	s3,s4,80000a24 <uvmcopy+0x20>
    80000a7c:	a081                	j	80000abc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a7e:	00007517          	auipc	a0,0x7
    80000a82:	68a50513          	addi	a0,a0,1674 # 80008108 <etext+0x108>
    80000a86:	00005097          	auipc	ra,0x5
    80000a8a:	05a080e7          	jalr	90(ra) # 80005ae0 <panic>
      panic("uvmcopy: page not present");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	69a50513          	addi	a0,a0,1690 # 80008128 <etext+0x128>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	04a080e7          	jalr	74(ra) # 80005ae0 <panic>
      kfree(mem);
    80000a9e:	854a                	mv	a0,s2
    80000aa0:	fffff097          	auipc	ra,0xfffff
    80000aa4:	57c080e7          	jalr	1404(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aa8:	4685                	li	a3,1
    80000aaa:	00c9d613          	srli	a2,s3,0xc
    80000aae:	4581                	li	a1,0
    80000ab0:	8556                	mv	a0,s5
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	c56080e7          	jalr	-938(ra) # 80000708 <uvmunmap>
  return -1;
    80000aba:	557d                	li	a0,-1
}
    80000abc:	60a6                	ld	ra,72(sp)
    80000abe:	6406                	ld	s0,64(sp)
    80000ac0:	74e2                	ld	s1,56(sp)
    80000ac2:	7942                	ld	s2,48(sp)
    80000ac4:	79a2                	ld	s3,40(sp)
    80000ac6:	7a02                	ld	s4,32(sp)
    80000ac8:	6ae2                	ld	s5,24(sp)
    80000aca:	6b42                	ld	s6,16(sp)
    80000acc:	6ba2                	ld	s7,8(sp)
    80000ace:	6161                	addi	sp,sp,80
    80000ad0:	8082                	ret
  return 0;
    80000ad2:	4501                	li	a0,0
}
    80000ad4:	8082                	ret

0000000080000ad6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad6:	1141                	addi	sp,sp,-16
    80000ad8:	e406                	sd	ra,8(sp)
    80000ada:	e022                	sd	s0,0(sp)
    80000adc:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ade:	4601                	li	a2,0
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	97a080e7          	jalr	-1670(ra) # 8000045a <walk>
  if(pte == 0)
    80000ae8:	c901                	beqz	a0,80000af8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aea:	611c                	ld	a5,0(a0)
    80000aec:	9bbd                	andi	a5,a5,-17
    80000aee:	e11c                	sd	a5,0(a0)
}
    80000af0:	60a2                	ld	ra,8(sp)
    80000af2:	6402                	ld	s0,0(sp)
    80000af4:	0141                	addi	sp,sp,16
    80000af6:	8082                	ret
    panic("uvmclear");
    80000af8:	00007517          	auipc	a0,0x7
    80000afc:	65050513          	addi	a0,a0,1616 # 80008148 <etext+0x148>
    80000b00:	00005097          	auipc	ra,0x5
    80000b04:	fe0080e7          	jalr	-32(ra) # 80005ae0 <panic>

0000000080000b08 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b08:	c6bd                	beqz	a3,80000b76 <copyout+0x6e>
{
    80000b0a:	715d                	addi	sp,sp,-80
    80000b0c:	e486                	sd	ra,72(sp)
    80000b0e:	e0a2                	sd	s0,64(sp)
    80000b10:	fc26                	sd	s1,56(sp)
    80000b12:	f84a                	sd	s2,48(sp)
    80000b14:	f44e                	sd	s3,40(sp)
    80000b16:	f052                	sd	s4,32(sp)
    80000b18:	ec56                	sd	s5,24(sp)
    80000b1a:	e85a                	sd	s6,16(sp)
    80000b1c:	e45e                	sd	s7,8(sp)
    80000b1e:	e062                	sd	s8,0(sp)
    80000b20:	0880                	addi	s0,sp,80
    80000b22:	8b2a                	mv	s6,a0
    80000b24:	8c2e                	mv	s8,a1
    80000b26:	8a32                	mv	s4,a2
    80000b28:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2c:	6a85                	lui	s5,0x1
    80000b2e:	a015                	j	80000b52 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b30:	9562                	add	a0,a0,s8
    80000b32:	0004861b          	sext.w	a2,s1
    80000b36:	85d2                	mv	a1,s4
    80000b38:	41250533          	sub	a0,a0,s2
    80000b3c:	fffff097          	auipc	ra,0xfffff
    80000b40:	69a080e7          	jalr	1690(ra) # 800001d6 <memmove>

    len -= n;
    80000b44:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b48:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b4e:	02098263          	beqz	s3,80000b72 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b52:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b56:	85ca                	mv	a1,s2
    80000b58:	855a                	mv	a0,s6
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	9a6080e7          	jalr	-1626(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000b62:	cd01                	beqz	a0,80000b7a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b64:	418904b3          	sub	s1,s2,s8
    80000b68:	94d6                	add	s1,s1,s5
    80000b6a:	fc99f3e3          	bgeu	s3,s1,80000b30 <copyout+0x28>
    80000b6e:	84ce                	mv	s1,s3
    80000b70:	b7c1                	j	80000b30 <copyout+0x28>
  }
  return 0;
    80000b72:	4501                	li	a0,0
    80000b74:	a021                	j	80000b7c <copyout+0x74>
    80000b76:	4501                	li	a0,0
}
    80000b78:	8082                	ret
      return -1;
    80000b7a:	557d                	li	a0,-1
}
    80000b7c:	60a6                	ld	ra,72(sp)
    80000b7e:	6406                	ld	s0,64(sp)
    80000b80:	74e2                	ld	s1,56(sp)
    80000b82:	7942                	ld	s2,48(sp)
    80000b84:	79a2                	ld	s3,40(sp)
    80000b86:	7a02                	ld	s4,32(sp)
    80000b88:	6ae2                	ld	s5,24(sp)
    80000b8a:	6b42                	ld	s6,16(sp)
    80000b8c:	6ba2                	ld	s7,8(sp)
    80000b8e:	6c02                	ld	s8,0(sp)
    80000b90:	6161                	addi	sp,sp,80
    80000b92:	8082                	ret

0000000080000b94 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b94:	caa5                	beqz	a3,80000c04 <copyin+0x70>
{
    80000b96:	715d                	addi	sp,sp,-80
    80000b98:	e486                	sd	ra,72(sp)
    80000b9a:	e0a2                	sd	s0,64(sp)
    80000b9c:	fc26                	sd	s1,56(sp)
    80000b9e:	f84a                	sd	s2,48(sp)
    80000ba0:	f44e                	sd	s3,40(sp)
    80000ba2:	f052                	sd	s4,32(sp)
    80000ba4:	ec56                	sd	s5,24(sp)
    80000ba6:	e85a                	sd	s6,16(sp)
    80000ba8:	e45e                	sd	s7,8(sp)
    80000baa:	e062                	sd	s8,0(sp)
    80000bac:	0880                	addi	s0,sp,80
    80000bae:	8b2a                	mv	s6,a0
    80000bb0:	8a2e                	mv	s4,a1
    80000bb2:	8c32                	mv	s8,a2
    80000bb4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bb8:	6a85                	lui	s5,0x1
    80000bba:	a01d                	j	80000be0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbc:	018505b3          	add	a1,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412585b3          	sub	a1,a1,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60c080e7          	jalr	1548(ra) # 800001d6 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	918080e7          	jalr	-1768(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    80000bf8:	fc99f2e3          	bgeu	s3,s1,80000bbc <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	bf7d                	j	80000bbc <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x76>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c2dd                	beqz	a3,80000cc8 <copyinstr+0xa6>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a02d                	j	80000c70 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	37fd                	addiw	a5,a5,-1
    80000c50:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6161                	addi	sp,sp,80
    80000c68:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c6e:	c8a9                	beqz	s1,80000cc0 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c70:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c74:	85ca                	mv	a1,s2
    80000c76:	8552                	mv	a0,s4
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	888080e7          	jalr	-1912(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000c80:	c131                	beqz	a0,80000cc4 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c82:	417906b3          	sub	a3,s2,s7
    80000c86:	96ce                	add	a3,a3,s3
    80000c88:	00d4f363          	bgeu	s1,a3,80000c8e <copyinstr+0x6c>
    80000c8c:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c8e:	955e                	add	a0,a0,s7
    80000c90:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c94:	daf9                	beqz	a3,80000c6a <copyinstr+0x48>
    80000c96:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c98:	41650633          	sub	a2,a0,s6
    80000c9c:	fff48593          	addi	a1,s1,-1
    80000ca0:	95da                	add	a1,a1,s6
    while(n > 0){
    80000ca2:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000ca4:	00f60733          	add	a4,a2,a5
    80000ca8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cac:	df51                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cae:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb2:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cb6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb8:	fed796e3          	bne	a5,a3,80000ca4 <copyinstr+0x82>
      dst++;
    80000cbc:	8b3e                	mv	s6,a5
    80000cbe:	b775                	j	80000c6a <copyinstr+0x48>
    80000cc0:	4781                	li	a5,0
    80000cc2:	b771                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc4:	557d                	li	a0,-1
    80000cc6:	b779                	j	80000c54 <copyinstr+0x32>
  int got_null = 0;
    80000cc8:	4781                	li	a5,0
  if(got_null){
    80000cca:	37fd                	addiw	a5,a5,-1
    80000ccc:	0007851b          	sext.w	a0,a5
}
    80000cd0:	8082                	ret

0000000080000cd2 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd2:	7139                	addi	sp,sp,-64
    80000cd4:	fc06                	sd	ra,56(sp)
    80000cd6:	f822                	sd	s0,48(sp)
    80000cd8:	f426                	sd	s1,40(sp)
    80000cda:	f04a                	sd	s2,32(sp)
    80000cdc:	ec4e                	sd	s3,24(sp)
    80000cde:	e852                	sd	s4,16(sp)
    80000ce0:	e456                	sd	s5,8(sp)
    80000ce2:	e05a                	sd	s6,0(sp)
    80000ce4:	0080                	addi	s0,sp,64
    80000ce6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce8:	00008497          	auipc	s1,0x8
    80000cec:	79848493          	addi	s1,s1,1944 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf0:	8b26                	mv	s6,s1
    80000cf2:	00007a97          	auipc	s5,0x7
    80000cf6:	30ea8a93          	addi	s5,s5,782 # 80008000 <etext>
    80000cfa:	04000937          	lui	s2,0x4000
    80000cfe:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d00:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d02:	0000ea17          	auipc	s4,0xe
    80000d06:	17ea0a13          	addi	s4,s4,382 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d0a:	fffff097          	auipc	ra,0xfffff
    80000d0e:	410080e7          	jalr	1040(ra) # 8000011a <kalloc>
    80000d12:	862a                	mv	a2,a0
    if(pa == 0)
    80000d14:	c131                	beqz	a0,80000d58 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d16:	416485b3          	sub	a1,s1,s6
    80000d1a:	858d                	srai	a1,a1,0x3
    80000d1c:	000ab783          	ld	a5,0(s5)
    80000d20:	02f585b3          	mul	a1,a1,a5
    80000d24:	2585                	addiw	a1,a1,1
    80000d26:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2a:	4719                	li	a4,6
    80000d2c:	6685                	lui	a3,0x1
    80000d2e:	40b905b3          	sub	a1,s2,a1
    80000d32:	854e                	mv	a0,s3
    80000d34:	00000097          	auipc	ra,0x0
    80000d38:	8ae080e7          	jalr	-1874(ra) # 800005e2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3c:	16848493          	addi	s1,s1,360
    80000d40:	fd4495e3          	bne	s1,s4,80000d0a <proc_mapstacks+0x38>
  }
}
    80000d44:	70e2                	ld	ra,56(sp)
    80000d46:	7442                	ld	s0,48(sp)
    80000d48:	74a2                	ld	s1,40(sp)
    80000d4a:	7902                	ld	s2,32(sp)
    80000d4c:	69e2                	ld	s3,24(sp)
    80000d4e:	6a42                	ld	s4,16(sp)
    80000d50:	6aa2                	ld	s5,8(sp)
    80000d52:	6b02                	ld	s6,0(sp)
    80000d54:	6121                	addi	sp,sp,64
    80000d56:	8082                	ret
      panic("kalloc");
    80000d58:	00007517          	auipc	a0,0x7
    80000d5c:	40050513          	addi	a0,a0,1024 # 80008158 <etext+0x158>
    80000d60:	00005097          	auipc	ra,0x5
    80000d64:	d80080e7          	jalr	-640(ra) # 80005ae0 <panic>

0000000080000d68 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d68:	7139                	addi	sp,sp,-64
    80000d6a:	fc06                	sd	ra,56(sp)
    80000d6c:	f822                	sd	s0,48(sp)
    80000d6e:	f426                	sd	s1,40(sp)
    80000d70:	f04a                	sd	s2,32(sp)
    80000d72:	ec4e                	sd	s3,24(sp)
    80000d74:	e852                	sd	s4,16(sp)
    80000d76:	e456                	sd	s5,8(sp)
    80000d78:	e05a                	sd	s6,0(sp)
    80000d7a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d7c:	00007597          	auipc	a1,0x7
    80000d80:	3e458593          	addi	a1,a1,996 # 80008160 <etext+0x160>
    80000d84:	00008517          	auipc	a0,0x8
    80000d88:	2cc50513          	addi	a0,a0,716 # 80009050 <pid_lock>
    80000d8c:	00005097          	auipc	ra,0x5
    80000d90:	1fc080e7          	jalr	508(ra) # 80005f88 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d94:	00007597          	auipc	a1,0x7
    80000d98:	3d458593          	addi	a1,a1,980 # 80008168 <etext+0x168>
    80000d9c:	00008517          	auipc	a0,0x8
    80000da0:	2cc50513          	addi	a0,a0,716 # 80009068 <wait_lock>
    80000da4:	00005097          	auipc	ra,0x5
    80000da8:	1e4080e7          	jalr	484(ra) # 80005f88 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dac:	00008497          	auipc	s1,0x8
    80000db0:	6d448493          	addi	s1,s1,1748 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db4:	00007b17          	auipc	s6,0x7
    80000db8:	3c4b0b13          	addi	s6,s6,964 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dbc:	8aa6                	mv	s5,s1
    80000dbe:	00007a17          	auipc	s4,0x7
    80000dc2:	242a0a13          	addi	s4,s4,578 # 80008000 <etext>
    80000dc6:	04000937          	lui	s2,0x4000
    80000dca:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dcc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dce:	0000e997          	auipc	s3,0xe
    80000dd2:	0b298993          	addi	s3,s3,178 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000dd6:	85da                	mv	a1,s6
    80000dd8:	8526                	mv	a0,s1
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	1ae080e7          	jalr	430(ra) # 80005f88 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de2:	415487b3          	sub	a5,s1,s5
    80000de6:	878d                	srai	a5,a5,0x3
    80000de8:	000a3703          	ld	a4,0(s4)
    80000dec:	02e787b3          	mul	a5,a5,a4
    80000df0:	2785                	addiw	a5,a5,1
    80000df2:	00d7979b          	slliw	a5,a5,0xd
    80000df6:	40f907b3          	sub	a5,s2,a5
    80000dfa:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfc:	16848493          	addi	s1,s1,360
    80000e00:	fd349be3          	bne	s1,s3,80000dd6 <procinit+0x6e>
  }
}
    80000e04:	70e2                	ld	ra,56(sp)
    80000e06:	7442                	ld	s0,48(sp)
    80000e08:	74a2                	ld	s1,40(sp)
    80000e0a:	7902                	ld	s2,32(sp)
    80000e0c:	69e2                	ld	s3,24(sp)
    80000e0e:	6a42                	ld	s4,16(sp)
    80000e10:	6aa2                	ld	s5,8(sp)
    80000e12:	6b02                	ld	s6,0(sp)
    80000e14:	6121                	addi	sp,sp,64
    80000e16:	8082                	ret

0000000080000e18 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e18:	1141                	addi	sp,sp,-16
    80000e1a:	e422                	sd	s0,8(sp)
    80000e1c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e1e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e20:	2501                	sext.w	a0,a0
    80000e22:	6422                	ld	s0,8(sp)
    80000e24:	0141                	addi	sp,sp,16
    80000e26:	8082                	ret

0000000080000e28 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e28:	1141                	addi	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	addi	s0,sp,16
    80000e2e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e30:	2781                	sext.w	a5,a5
    80000e32:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e34:	00008517          	auipc	a0,0x8
    80000e38:	24c50513          	addi	a0,a0,588 # 80009080 <cpus>
    80000e3c:	953e                	add	a0,a0,a5
    80000e3e:	6422                	ld	s0,8(sp)
    80000e40:	0141                	addi	sp,sp,16
    80000e42:	8082                	ret

0000000080000e44 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e44:	1101                	addi	sp,sp,-32
    80000e46:	ec06                	sd	ra,24(sp)
    80000e48:	e822                	sd	s0,16(sp)
    80000e4a:	e426                	sd	s1,8(sp)
    80000e4c:	1000                	addi	s0,sp,32
  push_off();
    80000e4e:	00005097          	auipc	ra,0x5
    80000e52:	17e080e7          	jalr	382(ra) # 80005fcc <push_off>
    80000e56:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e58:	2781                	sext.w	a5,a5
    80000e5a:	079e                	slli	a5,a5,0x7
    80000e5c:	00008717          	auipc	a4,0x8
    80000e60:	1f470713          	addi	a4,a4,500 # 80009050 <pid_lock>
    80000e64:	97ba                	add	a5,a5,a4
    80000e66:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e68:	00005097          	auipc	ra,0x5
    80000e6c:	204080e7          	jalr	516(ra) # 8000606c <pop_off>
  return p;
}
    80000e70:	8526                	mv	a0,s1
    80000e72:	60e2                	ld	ra,24(sp)
    80000e74:	6442                	ld	s0,16(sp)
    80000e76:	64a2                	ld	s1,8(sp)
    80000e78:	6105                	addi	sp,sp,32
    80000e7a:	8082                	ret

0000000080000e7c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e7c:	1141                	addi	sp,sp,-16
    80000e7e:	e406                	sd	ra,8(sp)
    80000e80:	e022                	sd	s0,0(sp)
    80000e82:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e84:	00000097          	auipc	ra,0x0
    80000e88:	fc0080e7          	jalr	-64(ra) # 80000e44 <myproc>
    80000e8c:	00005097          	auipc	ra,0x5
    80000e90:	240080e7          	jalr	576(ra) # 800060cc <release>

  if (first) {
    80000e94:	00008797          	auipc	a5,0x8
    80000e98:	97c7a783          	lw	a5,-1668(a5) # 80008810 <first.1>
    80000e9c:	eb89                	bnez	a5,80000eae <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e9e:	00001097          	auipc	ra,0x1
    80000ea2:	c14080e7          	jalr	-1004(ra) # 80001ab2 <usertrapret>
}
    80000ea6:	60a2                	ld	ra,8(sp)
    80000ea8:	6402                	ld	s0,0(sp)
    80000eaa:	0141                	addi	sp,sp,16
    80000eac:	8082                	ret
    first = 0;
    80000eae:	00008797          	auipc	a5,0x8
    80000eb2:	9607a123          	sw	zero,-1694(a5) # 80008810 <first.1>
    fsinit(ROOTDEV);
    80000eb6:	4505                	li	a0,1
    80000eb8:	00002097          	auipc	ra,0x2
    80000ebc:	93a080e7          	jalr	-1734(ra) # 800027f2 <fsinit>
    80000ec0:	bff9                	j	80000e9e <forkret+0x22>

0000000080000ec2 <allocpid>:
allocpid() {
    80000ec2:	1101                	addi	sp,sp,-32
    80000ec4:	ec06                	sd	ra,24(sp)
    80000ec6:	e822                	sd	s0,16(sp)
    80000ec8:	e426                	sd	s1,8(sp)
    80000eca:	e04a                	sd	s2,0(sp)
    80000ecc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ece:	00008917          	auipc	s2,0x8
    80000ed2:	18290913          	addi	s2,s2,386 # 80009050 <pid_lock>
    80000ed6:	854a                	mv	a0,s2
    80000ed8:	00005097          	auipc	ra,0x5
    80000edc:	140080e7          	jalr	320(ra) # 80006018 <acquire>
  pid = nextpid;
    80000ee0:	00008797          	auipc	a5,0x8
    80000ee4:	93478793          	addi	a5,a5,-1740 # 80008814 <nextpid>
    80000ee8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eea:	0014871b          	addiw	a4,s1,1
    80000eee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef0:	854a                	mv	a0,s2
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	1da080e7          	jalr	474(ra) # 800060cc <release>
}
    80000efa:	8526                	mv	a0,s1
    80000efc:	60e2                	ld	ra,24(sp)
    80000efe:	6442                	ld	s0,16(sp)
    80000f00:	64a2                	ld	s1,8(sp)
    80000f02:	6902                	ld	s2,0(sp)
    80000f04:	6105                	addi	sp,sp,32
    80000f06:	8082                	ret

0000000080000f08 <proc_pagetable>:
{
    80000f08:	1101                	addi	sp,sp,-32
    80000f0a:	ec06                	sd	ra,24(sp)
    80000f0c:	e822                	sd	s0,16(sp)
    80000f0e:	e426                	sd	s1,8(sp)
    80000f10:	e04a                	sd	s2,0(sp)
    80000f12:	1000                	addi	s0,sp,32
    80000f14:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	8b6080e7          	jalr	-1866(ra) # 800007cc <uvmcreate>
    80000f1e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f20:	c121                	beqz	a0,80000f60 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f22:	4729                	li	a4,10
    80000f24:	00006697          	auipc	a3,0x6
    80000f28:	0dc68693          	addi	a3,a3,220 # 80007000 <_trampoline>
    80000f2c:	6605                	lui	a2,0x1
    80000f2e:	040005b7          	lui	a1,0x4000
    80000f32:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f34:	05b2                	slli	a1,a1,0xc
    80000f36:	fffff097          	auipc	ra,0xfffff
    80000f3a:	60c080e7          	jalr	1548(ra) # 80000542 <mappages>
    80000f3e:	02054863          	bltz	a0,80000f6e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f42:	4719                	li	a4,6
    80000f44:	05893683          	ld	a3,88(s2)
    80000f48:	6605                	lui	a2,0x1
    80000f4a:	020005b7          	lui	a1,0x2000
    80000f4e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f50:	05b6                	slli	a1,a1,0xd
    80000f52:	8526                	mv	a0,s1
    80000f54:	fffff097          	auipc	ra,0xfffff
    80000f58:	5ee080e7          	jalr	1518(ra) # 80000542 <mappages>
    80000f5c:	02054163          	bltz	a0,80000f7e <proc_pagetable+0x76>
}
    80000f60:	8526                	mv	a0,s1
    80000f62:	60e2                	ld	ra,24(sp)
    80000f64:	6442                	ld	s0,16(sp)
    80000f66:	64a2                	ld	s1,8(sp)
    80000f68:	6902                	ld	s2,0(sp)
    80000f6a:	6105                	addi	sp,sp,32
    80000f6c:	8082                	ret
    uvmfree(pagetable, 0);
    80000f6e:	4581                	li	a1,0
    80000f70:	8526                	mv	a0,s1
    80000f72:	00000097          	auipc	ra,0x0
    80000f76:	a58080e7          	jalr	-1448(ra) # 800009ca <uvmfree>
    return 0;
    80000f7a:	4481                	li	s1,0
    80000f7c:	b7d5                	j	80000f60 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f7e:	4681                	li	a3,0
    80000f80:	4605                	li	a2,1
    80000f82:	040005b7          	lui	a1,0x4000
    80000f86:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f88:	05b2                	slli	a1,a1,0xc
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	77c080e7          	jalr	1916(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f94:	4581                	li	a1,0
    80000f96:	8526                	mv	a0,s1
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	a32080e7          	jalr	-1486(ra) # 800009ca <uvmfree>
    return 0;
    80000fa0:	4481                	li	s1,0
    80000fa2:	bf7d                	j	80000f60 <proc_pagetable+0x58>

0000000080000fa4 <proc_freepagetable>:
{
    80000fa4:	1101                	addi	sp,sp,-32
    80000fa6:	ec06                	sd	ra,24(sp)
    80000fa8:	e822                	sd	s0,16(sp)
    80000faa:	e426                	sd	s1,8(sp)
    80000fac:	e04a                	sd	s2,0(sp)
    80000fae:	1000                	addi	s0,sp,32
    80000fb0:	84aa                	mv	s1,a0
    80000fb2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb4:	4681                	li	a3,0
    80000fb6:	4605                	li	a2,1
    80000fb8:	040005b7          	lui	a1,0x4000
    80000fbc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fbe:	05b2                	slli	a1,a1,0xc
    80000fc0:	fffff097          	auipc	ra,0xfffff
    80000fc4:	748080e7          	jalr	1864(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fc8:	4681                	li	a3,0
    80000fca:	4605                	li	a2,1
    80000fcc:	020005b7          	lui	a1,0x2000
    80000fd0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fd2:	05b6                	slli	a1,a1,0xd
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	732080e7          	jalr	1842(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fde:	85ca                	mv	a1,s2
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	00000097          	auipc	ra,0x0
    80000fe6:	9e8080e7          	jalr	-1560(ra) # 800009ca <uvmfree>
}
    80000fea:	60e2                	ld	ra,24(sp)
    80000fec:	6442                	ld	s0,16(sp)
    80000fee:	64a2                	ld	s1,8(sp)
    80000ff0:	6902                	ld	s2,0(sp)
    80000ff2:	6105                	addi	sp,sp,32
    80000ff4:	8082                	ret

0000000080000ff6 <freeproc>:
{
    80000ff6:	1101                	addi	sp,sp,-32
    80000ff8:	ec06                	sd	ra,24(sp)
    80000ffa:	e822                	sd	s0,16(sp)
    80000ffc:	e426                	sd	s1,8(sp)
    80000ffe:	1000                	addi	s0,sp,32
    80001000:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001002:	6d28                	ld	a0,88(a0)
    80001004:	c509                	beqz	a0,8000100e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001006:	fffff097          	auipc	ra,0xfffff
    8000100a:	016080e7          	jalr	22(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000100e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001012:	68a8                	ld	a0,80(s1)
    80001014:	c511                	beqz	a0,80001020 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001016:	64ac                	ld	a1,72(s1)
    80001018:	00000097          	auipc	ra,0x0
    8000101c:	f8c080e7          	jalr	-116(ra) # 80000fa4 <proc_freepagetable>
  p->pagetable = 0;
    80001020:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001024:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001028:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000102c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001030:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001034:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001038:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000103c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001040:	0004ac23          	sw	zero,24(s1)
}
    80001044:	60e2                	ld	ra,24(sp)
    80001046:	6442                	ld	s0,16(sp)
    80001048:	64a2                	ld	s1,8(sp)
    8000104a:	6105                	addi	sp,sp,32
    8000104c:	8082                	ret

000000008000104e <allocproc>:
{
    8000104e:	1101                	addi	sp,sp,-32
    80001050:	ec06                	sd	ra,24(sp)
    80001052:	e822                	sd	s0,16(sp)
    80001054:	e426                	sd	s1,8(sp)
    80001056:	e04a                	sd	s2,0(sp)
    80001058:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105a:	00008497          	auipc	s1,0x8
    8000105e:	42648493          	addi	s1,s1,1062 # 80009480 <proc>
    80001062:	0000e917          	auipc	s2,0xe
    80001066:	e1e90913          	addi	s2,s2,-482 # 8000ee80 <tickslock>
    acquire(&p->lock);
    8000106a:	8526                	mv	a0,s1
    8000106c:	00005097          	auipc	ra,0x5
    80001070:	fac080e7          	jalr	-84(ra) # 80006018 <acquire>
    if(p->state == UNUSED) {
    80001074:	4c9c                	lw	a5,24(s1)
    80001076:	cf81                	beqz	a5,8000108e <allocproc+0x40>
      release(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	052080e7          	jalr	82(ra) # 800060cc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001082:	16848493          	addi	s1,s1,360
    80001086:	ff2492e3          	bne	s1,s2,8000106a <allocproc+0x1c>
  return 0;
    8000108a:	4481                	li	s1,0
    8000108c:	a889                	j	800010de <allocproc+0x90>
  p->pid = allocpid();
    8000108e:	00000097          	auipc	ra,0x0
    80001092:	e34080e7          	jalr	-460(ra) # 80000ec2 <allocpid>
    80001096:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001098:	4785                	li	a5,1
    8000109a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	07e080e7          	jalr	126(ra) # 8000011a <kalloc>
    800010a4:	892a                	mv	s2,a0
    800010a6:	eca8                	sd	a0,88(s1)
    800010a8:	c131                	beqz	a0,800010ec <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010aa:	8526                	mv	a0,s1
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	e5c080e7          	jalr	-420(ra) # 80000f08 <proc_pagetable>
    800010b4:	892a                	mv	s2,a0
    800010b6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010b8:	c531                	beqz	a0,80001104 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ba:	07000613          	li	a2,112
    800010be:	4581                	li	a1,0
    800010c0:	06048513          	addi	a0,s1,96
    800010c4:	fffff097          	auipc	ra,0xfffff
    800010c8:	0b6080e7          	jalr	182(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010cc:	00000797          	auipc	a5,0x0
    800010d0:	db078793          	addi	a5,a5,-592 # 80000e7c <forkret>
    800010d4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010d6:	60bc                	ld	a5,64(s1)
    800010d8:	6705                	lui	a4,0x1
    800010da:	97ba                	add	a5,a5,a4
    800010dc:	f4bc                	sd	a5,104(s1)
}
    800010de:	8526                	mv	a0,s1
    800010e0:	60e2                	ld	ra,24(sp)
    800010e2:	6442                	ld	s0,16(sp)
    800010e4:	64a2                	ld	s1,8(sp)
    800010e6:	6902                	ld	s2,0(sp)
    800010e8:	6105                	addi	sp,sp,32
    800010ea:	8082                	ret
    freeproc(p);
    800010ec:	8526                	mv	a0,s1
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	f08080e7          	jalr	-248(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    800010f6:	8526                	mv	a0,s1
    800010f8:	00005097          	auipc	ra,0x5
    800010fc:	fd4080e7          	jalr	-44(ra) # 800060cc <release>
    return 0;
    80001100:	84ca                	mv	s1,s2
    80001102:	bff1                	j	800010de <allocproc+0x90>
    freeproc(p);
    80001104:	8526                	mv	a0,s1
    80001106:	00000097          	auipc	ra,0x0
    8000110a:	ef0080e7          	jalr	-272(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    8000110e:	8526                	mv	a0,s1
    80001110:	00005097          	auipc	ra,0x5
    80001114:	fbc080e7          	jalr	-68(ra) # 800060cc <release>
    return 0;
    80001118:	84ca                	mv	s1,s2
    8000111a:	b7d1                	j	800010de <allocproc+0x90>

000000008000111c <userinit>:
{
    8000111c:	1101                	addi	sp,sp,-32
    8000111e:	ec06                	sd	ra,24(sp)
    80001120:	e822                	sd	s0,16(sp)
    80001122:	e426                	sd	s1,8(sp)
    80001124:	1000                	addi	s0,sp,32
  p = allocproc();
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	f28080e7          	jalr	-216(ra) # 8000104e <allocproc>
    8000112e:	84aa                	mv	s1,a0
  initproc = p;
    80001130:	00008797          	auipc	a5,0x8
    80001134:	eea7b023          	sd	a0,-288(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001138:	03400613          	li	a2,52
    8000113c:	00007597          	auipc	a1,0x7
    80001140:	6e458593          	addi	a1,a1,1764 # 80008820 <initcode>
    80001144:	6928                	ld	a0,80(a0)
    80001146:	fffff097          	auipc	ra,0xfffff
    8000114a:	6b4080e7          	jalr	1716(ra) # 800007fa <uvminit>
  p->sz = PGSIZE;
    8000114e:	6785                	lui	a5,0x1
    80001150:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001152:	6cb8                	ld	a4,88(s1)
    80001154:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001158:	6cb8                	ld	a4,88(s1)
    8000115a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000115c:	4641                	li	a2,16
    8000115e:	00007597          	auipc	a1,0x7
    80001162:	02258593          	addi	a1,a1,34 # 80008180 <etext+0x180>
    80001166:	15848513          	addi	a0,s1,344
    8000116a:	fffff097          	auipc	ra,0xfffff
    8000116e:	15a080e7          	jalr	346(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    80001172:	00007517          	auipc	a0,0x7
    80001176:	01e50513          	addi	a0,a0,30 # 80008190 <etext+0x190>
    8000117a:	00002097          	auipc	ra,0x2
    8000117e:	0ae080e7          	jalr	174(ra) # 80003228 <namei>
    80001182:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001186:	478d                	li	a5,3
    80001188:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000118a:	8526                	mv	a0,s1
    8000118c:	00005097          	auipc	ra,0x5
    80001190:	f40080e7          	jalr	-192(ra) # 800060cc <release>
}
    80001194:	60e2                	ld	ra,24(sp)
    80001196:	6442                	ld	s0,16(sp)
    80001198:	64a2                	ld	s1,8(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <growproc>:
{
    8000119e:	1101                	addi	sp,sp,-32
    800011a0:	ec06                	sd	ra,24(sp)
    800011a2:	e822                	sd	s0,16(sp)
    800011a4:	e426                	sd	s1,8(sp)
    800011a6:	e04a                	sd	s2,0(sp)
    800011a8:	1000                	addi	s0,sp,32
    800011aa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011ac:	00000097          	auipc	ra,0x0
    800011b0:	c98080e7          	jalr	-872(ra) # 80000e44 <myproc>
    800011b4:	892a                	mv	s2,a0
  sz = p->sz;
    800011b6:	652c                	ld	a1,72(a0)
    800011b8:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011bc:	00904f63          	bgtz	s1,800011da <growproc+0x3c>
  } else if(n < 0){
    800011c0:	0204cd63          	bltz	s1,800011fa <growproc+0x5c>
  p->sz = sz;
    800011c4:	1782                	slli	a5,a5,0x20
    800011c6:	9381                	srli	a5,a5,0x20
    800011c8:	04f93423          	sd	a5,72(s2)
  return 0;
    800011cc:	4501                	li	a0,0
}
    800011ce:	60e2                	ld	ra,24(sp)
    800011d0:	6442                	ld	s0,16(sp)
    800011d2:	64a2                	ld	s1,8(sp)
    800011d4:	6902                	ld	s2,0(sp)
    800011d6:	6105                	addi	sp,sp,32
    800011d8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011da:	00f4863b          	addw	a2,s1,a5
    800011de:	1602                	slli	a2,a2,0x20
    800011e0:	9201                	srli	a2,a2,0x20
    800011e2:	1582                	slli	a1,a1,0x20
    800011e4:	9181                	srli	a1,a1,0x20
    800011e6:	6928                	ld	a0,80(a0)
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	6cc080e7          	jalr	1740(ra) # 800008b4 <uvmalloc>
    800011f0:	0005079b          	sext.w	a5,a0
    800011f4:	fbe1                	bnez	a5,800011c4 <growproc+0x26>
      return -1;
    800011f6:	557d                	li	a0,-1
    800011f8:	bfd9                	j	800011ce <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011fa:	00f4863b          	addw	a2,s1,a5
    800011fe:	1602                	slli	a2,a2,0x20
    80001200:	9201                	srli	a2,a2,0x20
    80001202:	1582                	slli	a1,a1,0x20
    80001204:	9181                	srli	a1,a1,0x20
    80001206:	6928                	ld	a0,80(a0)
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	664080e7          	jalr	1636(ra) # 8000086c <uvmdealloc>
    80001210:	0005079b          	sext.w	a5,a0
    80001214:	bf45                	j	800011c4 <growproc+0x26>

0000000080001216 <fork>:
{
    80001216:	7139                	addi	sp,sp,-64
    80001218:	fc06                	sd	ra,56(sp)
    8000121a:	f822                	sd	s0,48(sp)
    8000121c:	f426                	sd	s1,40(sp)
    8000121e:	f04a                	sd	s2,32(sp)
    80001220:	ec4e                	sd	s3,24(sp)
    80001222:	e852                	sd	s4,16(sp)
    80001224:	e456                	sd	s5,8(sp)
    80001226:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	c1c080e7          	jalr	-996(ra) # 80000e44 <myproc>
    80001230:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001232:	00000097          	auipc	ra,0x0
    80001236:	e1c080e7          	jalr	-484(ra) # 8000104e <allocproc>
    8000123a:	10050c63          	beqz	a0,80001352 <fork+0x13c>
    8000123e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001240:	048ab603          	ld	a2,72(s5)
    80001244:	692c                	ld	a1,80(a0)
    80001246:	050ab503          	ld	a0,80(s5)
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	7ba080e7          	jalr	1978(ra) # 80000a04 <uvmcopy>
    80001252:	04054863          	bltz	a0,800012a2 <fork+0x8c>
  np->sz = p->sz;
    80001256:	048ab783          	ld	a5,72(s5)
    8000125a:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000125e:	058ab683          	ld	a3,88(s5)
    80001262:	87b6                	mv	a5,a3
    80001264:	058a3703          	ld	a4,88(s4)
    80001268:	12068693          	addi	a3,a3,288
    8000126c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001270:	6788                	ld	a0,8(a5)
    80001272:	6b8c                	ld	a1,16(a5)
    80001274:	6f90                	ld	a2,24(a5)
    80001276:	01073023          	sd	a6,0(a4)
    8000127a:	e708                	sd	a0,8(a4)
    8000127c:	eb0c                	sd	a1,16(a4)
    8000127e:	ef10                	sd	a2,24(a4)
    80001280:	02078793          	addi	a5,a5,32
    80001284:	02070713          	addi	a4,a4,32
    80001288:	fed792e3          	bne	a5,a3,8000126c <fork+0x56>
  np->trapframe->a0 = 0;
    8000128c:	058a3783          	ld	a5,88(s4)
    80001290:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001294:	0d0a8493          	addi	s1,s5,208
    80001298:	0d0a0913          	addi	s2,s4,208
    8000129c:	150a8993          	addi	s3,s5,336
    800012a0:	a00d                	j	800012c2 <fork+0xac>
    freeproc(np);
    800012a2:	8552                	mv	a0,s4
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	d52080e7          	jalr	-686(ra) # 80000ff6 <freeproc>
    release(&np->lock);
    800012ac:	8552                	mv	a0,s4
    800012ae:	00005097          	auipc	ra,0x5
    800012b2:	e1e080e7          	jalr	-482(ra) # 800060cc <release>
    return -1;
    800012b6:	597d                	li	s2,-1
    800012b8:	a059                	j	8000133e <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012ba:	04a1                	addi	s1,s1,8
    800012bc:	0921                	addi	s2,s2,8
    800012be:	01348b63          	beq	s1,s3,800012d4 <fork+0xbe>
    if(p->ofile[i])
    800012c2:	6088                	ld	a0,0(s1)
    800012c4:	d97d                	beqz	a0,800012ba <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012c6:	00002097          	auipc	ra,0x2
    800012ca:	5f8080e7          	jalr	1528(ra) # 800038be <filedup>
    800012ce:	00a93023          	sd	a0,0(s2)
    800012d2:	b7e5                	j	800012ba <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012d4:	150ab503          	ld	a0,336(s5)
    800012d8:	00001097          	auipc	ra,0x1
    800012dc:	756080e7          	jalr	1878(ra) # 80002a2e <idup>
    800012e0:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012e4:	4641                	li	a2,16
    800012e6:	158a8593          	addi	a1,s5,344
    800012ea:	158a0513          	addi	a0,s4,344
    800012ee:	fffff097          	auipc	ra,0xfffff
    800012f2:	fd6080e7          	jalr	-42(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    800012f6:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012fa:	8552                	mv	a0,s4
    800012fc:	00005097          	auipc	ra,0x5
    80001300:	dd0080e7          	jalr	-560(ra) # 800060cc <release>
  acquire(&wait_lock);
    80001304:	00008497          	auipc	s1,0x8
    80001308:	d6448493          	addi	s1,s1,-668 # 80009068 <wait_lock>
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	d0a080e7          	jalr	-758(ra) # 80006018 <acquire>
  np->parent = p;
    80001316:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000131a:	8526                	mv	a0,s1
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	db0080e7          	jalr	-592(ra) # 800060cc <release>
  acquire(&np->lock);
    80001324:	8552                	mv	a0,s4
    80001326:	00005097          	auipc	ra,0x5
    8000132a:	cf2080e7          	jalr	-782(ra) # 80006018 <acquire>
  np->state = RUNNABLE;
    8000132e:	478d                	li	a5,3
    80001330:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001334:	8552                	mv	a0,s4
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	d96080e7          	jalr	-618(ra) # 800060cc <release>
}
    8000133e:	854a                	mv	a0,s2
    80001340:	70e2                	ld	ra,56(sp)
    80001342:	7442                	ld	s0,48(sp)
    80001344:	74a2                	ld	s1,40(sp)
    80001346:	7902                	ld	s2,32(sp)
    80001348:	69e2                	ld	s3,24(sp)
    8000134a:	6a42                	ld	s4,16(sp)
    8000134c:	6aa2                	ld	s5,8(sp)
    8000134e:	6121                	addi	sp,sp,64
    80001350:	8082                	ret
    return -1;
    80001352:	597d                	li	s2,-1
    80001354:	b7ed                	j	8000133e <fork+0x128>

0000000080001356 <scheduler>:
{
    80001356:	7139                	addi	sp,sp,-64
    80001358:	fc06                	sd	ra,56(sp)
    8000135a:	f822                	sd	s0,48(sp)
    8000135c:	f426                	sd	s1,40(sp)
    8000135e:	f04a                	sd	s2,32(sp)
    80001360:	ec4e                	sd	s3,24(sp)
    80001362:	e852                	sd	s4,16(sp)
    80001364:	e456                	sd	s5,8(sp)
    80001366:	e05a                	sd	s6,0(sp)
    80001368:	0080                	addi	s0,sp,64
    8000136a:	8792                	mv	a5,tp
  int id = r_tp();
    8000136c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000136e:	00779a93          	slli	s5,a5,0x7
    80001372:	00008717          	auipc	a4,0x8
    80001376:	cde70713          	addi	a4,a4,-802 # 80009050 <pid_lock>
    8000137a:	9756                	add	a4,a4,s5
    8000137c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001380:	00008717          	auipc	a4,0x8
    80001384:	d0870713          	addi	a4,a4,-760 # 80009088 <cpus+0x8>
    80001388:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000138a:	498d                	li	s3,3
        p->state = RUNNING;
    8000138c:	4b11                	li	s6,4
        c->proc = p;
    8000138e:	079e                	slli	a5,a5,0x7
    80001390:	00008a17          	auipc	s4,0x8
    80001394:	cc0a0a13          	addi	s4,s4,-832 # 80009050 <pid_lock>
    80001398:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000139a:	0000e917          	auipc	s2,0xe
    8000139e:	ae690913          	addi	s2,s2,-1306 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013a2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013aa:	10079073          	csrw	sstatus,a5
    800013ae:	00008497          	auipc	s1,0x8
    800013b2:	0d248493          	addi	s1,s1,210 # 80009480 <proc>
    800013b6:	a811                	j	800013ca <scheduler+0x74>
      release(&p->lock);
    800013b8:	8526                	mv	a0,s1
    800013ba:	00005097          	auipc	ra,0x5
    800013be:	d12080e7          	jalr	-750(ra) # 800060cc <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013c2:	16848493          	addi	s1,s1,360
    800013c6:	fd248ee3          	beq	s1,s2,800013a2 <scheduler+0x4c>
      acquire(&p->lock);
    800013ca:	8526                	mv	a0,s1
    800013cc:	00005097          	auipc	ra,0x5
    800013d0:	c4c080e7          	jalr	-948(ra) # 80006018 <acquire>
      if(p->state == RUNNABLE) {
    800013d4:	4c9c                	lw	a5,24(s1)
    800013d6:	ff3791e3          	bne	a5,s3,800013b8 <scheduler+0x62>
        p->state = RUNNING;
    800013da:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013de:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013e2:	06048593          	addi	a1,s1,96
    800013e6:	8556                	mv	a0,s5
    800013e8:	00000097          	auipc	ra,0x0
    800013ec:	620080e7          	jalr	1568(ra) # 80001a08 <swtch>
        c->proc = 0;
    800013f0:	020a3823          	sd	zero,48(s4)
    800013f4:	b7d1                	j	800013b8 <scheduler+0x62>

00000000800013f6 <sched>:
{
    800013f6:	7179                	addi	sp,sp,-48
    800013f8:	f406                	sd	ra,40(sp)
    800013fa:	f022                	sd	s0,32(sp)
    800013fc:	ec26                	sd	s1,24(sp)
    800013fe:	e84a                	sd	s2,16(sp)
    80001400:	e44e                	sd	s3,8(sp)
    80001402:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001404:	00000097          	auipc	ra,0x0
    80001408:	a40080e7          	jalr	-1472(ra) # 80000e44 <myproc>
    8000140c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000140e:	00005097          	auipc	ra,0x5
    80001412:	b90080e7          	jalr	-1136(ra) # 80005f9e <holding>
    80001416:	c93d                	beqz	a0,8000148c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001418:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000141a:	2781                	sext.w	a5,a5
    8000141c:	079e                	slli	a5,a5,0x7
    8000141e:	00008717          	auipc	a4,0x8
    80001422:	c3270713          	addi	a4,a4,-974 # 80009050 <pid_lock>
    80001426:	97ba                	add	a5,a5,a4
    80001428:	0a87a703          	lw	a4,168(a5)
    8000142c:	4785                	li	a5,1
    8000142e:	06f71763          	bne	a4,a5,8000149c <sched+0xa6>
  if(p->state == RUNNING)
    80001432:	4c98                	lw	a4,24(s1)
    80001434:	4791                	li	a5,4
    80001436:	06f70b63          	beq	a4,a5,800014ac <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000143a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000143e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001440:	efb5                	bnez	a5,800014bc <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001442:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001444:	00008917          	auipc	s2,0x8
    80001448:	c0c90913          	addi	s2,s2,-1012 # 80009050 <pid_lock>
    8000144c:	2781                	sext.w	a5,a5
    8000144e:	079e                	slli	a5,a5,0x7
    80001450:	97ca                	add	a5,a5,s2
    80001452:	0ac7a983          	lw	s3,172(a5)
    80001456:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001458:	2781                	sext.w	a5,a5
    8000145a:	079e                	slli	a5,a5,0x7
    8000145c:	00008597          	auipc	a1,0x8
    80001460:	c2c58593          	addi	a1,a1,-980 # 80009088 <cpus+0x8>
    80001464:	95be                	add	a1,a1,a5
    80001466:	06048513          	addi	a0,s1,96
    8000146a:	00000097          	auipc	ra,0x0
    8000146e:	59e080e7          	jalr	1438(ra) # 80001a08 <swtch>
    80001472:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001474:	2781                	sext.w	a5,a5
    80001476:	079e                	slli	a5,a5,0x7
    80001478:	993e                	add	s2,s2,a5
    8000147a:	0b392623          	sw	s3,172(s2)
}
    8000147e:	70a2                	ld	ra,40(sp)
    80001480:	7402                	ld	s0,32(sp)
    80001482:	64e2                	ld	s1,24(sp)
    80001484:	6942                	ld	s2,16(sp)
    80001486:	69a2                	ld	s3,8(sp)
    80001488:	6145                	addi	sp,sp,48
    8000148a:	8082                	ret
    panic("sched p->lock");
    8000148c:	00007517          	auipc	a0,0x7
    80001490:	d0c50513          	addi	a0,a0,-756 # 80008198 <etext+0x198>
    80001494:	00004097          	auipc	ra,0x4
    80001498:	64c080e7          	jalr	1612(ra) # 80005ae0 <panic>
    panic("sched locks");
    8000149c:	00007517          	auipc	a0,0x7
    800014a0:	d0c50513          	addi	a0,a0,-756 # 800081a8 <etext+0x1a8>
    800014a4:	00004097          	auipc	ra,0x4
    800014a8:	63c080e7          	jalr	1596(ra) # 80005ae0 <panic>
    panic("sched running");
    800014ac:	00007517          	auipc	a0,0x7
    800014b0:	d0c50513          	addi	a0,a0,-756 # 800081b8 <etext+0x1b8>
    800014b4:	00004097          	auipc	ra,0x4
    800014b8:	62c080e7          	jalr	1580(ra) # 80005ae0 <panic>
    panic("sched interruptible");
    800014bc:	00007517          	auipc	a0,0x7
    800014c0:	d0c50513          	addi	a0,a0,-756 # 800081c8 <etext+0x1c8>
    800014c4:	00004097          	auipc	ra,0x4
    800014c8:	61c080e7          	jalr	1564(ra) # 80005ae0 <panic>

00000000800014cc <yield>:
{
    800014cc:	1101                	addi	sp,sp,-32
    800014ce:	ec06                	sd	ra,24(sp)
    800014d0:	e822                	sd	s0,16(sp)
    800014d2:	e426                	sd	s1,8(sp)
    800014d4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014d6:	00000097          	auipc	ra,0x0
    800014da:	96e080e7          	jalr	-1682(ra) # 80000e44 <myproc>
    800014de:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014e0:	00005097          	auipc	ra,0x5
    800014e4:	b38080e7          	jalr	-1224(ra) # 80006018 <acquire>
  p->state = RUNNABLE;
    800014e8:	478d                	li	a5,3
    800014ea:	cc9c                	sw	a5,24(s1)
  sched();
    800014ec:	00000097          	auipc	ra,0x0
    800014f0:	f0a080e7          	jalr	-246(ra) # 800013f6 <sched>
  release(&p->lock);
    800014f4:	8526                	mv	a0,s1
    800014f6:	00005097          	auipc	ra,0x5
    800014fa:	bd6080e7          	jalr	-1066(ra) # 800060cc <release>
}
    800014fe:	60e2                	ld	ra,24(sp)
    80001500:	6442                	ld	s0,16(sp)
    80001502:	64a2                	ld	s1,8(sp)
    80001504:	6105                	addi	sp,sp,32
    80001506:	8082                	ret

0000000080001508 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001508:	7179                	addi	sp,sp,-48
    8000150a:	f406                	sd	ra,40(sp)
    8000150c:	f022                	sd	s0,32(sp)
    8000150e:	ec26                	sd	s1,24(sp)
    80001510:	e84a                	sd	s2,16(sp)
    80001512:	e44e                	sd	s3,8(sp)
    80001514:	1800                	addi	s0,sp,48
    80001516:	89aa                	mv	s3,a0
    80001518:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000151a:	00000097          	auipc	ra,0x0
    8000151e:	92a080e7          	jalr	-1750(ra) # 80000e44 <myproc>
    80001522:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001524:	00005097          	auipc	ra,0x5
    80001528:	af4080e7          	jalr	-1292(ra) # 80006018 <acquire>
  release(lk);
    8000152c:	854a                	mv	a0,s2
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	b9e080e7          	jalr	-1122(ra) # 800060cc <release>

  // Go to sleep.
  p->chan = chan;
    80001536:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000153a:	4789                	li	a5,2
    8000153c:	cc9c                	sw	a5,24(s1)

  sched();
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	eb8080e7          	jalr	-328(ra) # 800013f6 <sched>

  // Tidy up.
  p->chan = 0;
    80001546:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000154a:	8526                	mv	a0,s1
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	b80080e7          	jalr	-1152(ra) # 800060cc <release>
  acquire(lk);
    80001554:	854a                	mv	a0,s2
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	ac2080e7          	jalr	-1342(ra) # 80006018 <acquire>
}
    8000155e:	70a2                	ld	ra,40(sp)
    80001560:	7402                	ld	s0,32(sp)
    80001562:	64e2                	ld	s1,24(sp)
    80001564:	6942                	ld	s2,16(sp)
    80001566:	69a2                	ld	s3,8(sp)
    80001568:	6145                	addi	sp,sp,48
    8000156a:	8082                	ret

000000008000156c <wait>:
{
    8000156c:	715d                	addi	sp,sp,-80
    8000156e:	e486                	sd	ra,72(sp)
    80001570:	e0a2                	sd	s0,64(sp)
    80001572:	fc26                	sd	s1,56(sp)
    80001574:	f84a                	sd	s2,48(sp)
    80001576:	f44e                	sd	s3,40(sp)
    80001578:	f052                	sd	s4,32(sp)
    8000157a:	ec56                	sd	s5,24(sp)
    8000157c:	e85a                	sd	s6,16(sp)
    8000157e:	e45e                	sd	s7,8(sp)
    80001580:	e062                	sd	s8,0(sp)
    80001582:	0880                	addi	s0,sp,80
    80001584:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001586:	00000097          	auipc	ra,0x0
    8000158a:	8be080e7          	jalr	-1858(ra) # 80000e44 <myproc>
    8000158e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001590:	00008517          	auipc	a0,0x8
    80001594:	ad850513          	addi	a0,a0,-1320 # 80009068 <wait_lock>
    80001598:	00005097          	auipc	ra,0x5
    8000159c:	a80080e7          	jalr	-1408(ra) # 80006018 <acquire>
    havekids = 0;
    800015a0:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015a2:	4a15                	li	s4,5
        havekids = 1;
    800015a4:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015a6:	0000e997          	auipc	s3,0xe
    800015aa:	8da98993          	addi	s3,s3,-1830 # 8000ee80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015ae:	00008c17          	auipc	s8,0x8
    800015b2:	abac0c13          	addi	s8,s8,-1350 # 80009068 <wait_lock>
    havekids = 0;
    800015b6:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015b8:	00008497          	auipc	s1,0x8
    800015bc:	ec848493          	addi	s1,s1,-312 # 80009480 <proc>
    800015c0:	a0bd                	j	8000162e <wait+0xc2>
          pid = np->pid;
    800015c2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015c6:	000b0e63          	beqz	s6,800015e2 <wait+0x76>
    800015ca:	4691                	li	a3,4
    800015cc:	02c48613          	addi	a2,s1,44
    800015d0:	85da                	mv	a1,s6
    800015d2:	05093503          	ld	a0,80(s2)
    800015d6:	fffff097          	auipc	ra,0xfffff
    800015da:	532080e7          	jalr	1330(ra) # 80000b08 <copyout>
    800015de:	02054563          	bltz	a0,80001608 <wait+0x9c>
          freeproc(np);
    800015e2:	8526                	mv	a0,s1
    800015e4:	00000097          	auipc	ra,0x0
    800015e8:	a12080e7          	jalr	-1518(ra) # 80000ff6 <freeproc>
          release(&np->lock);
    800015ec:	8526                	mv	a0,s1
    800015ee:	00005097          	auipc	ra,0x5
    800015f2:	ade080e7          	jalr	-1314(ra) # 800060cc <release>
          release(&wait_lock);
    800015f6:	00008517          	auipc	a0,0x8
    800015fa:	a7250513          	addi	a0,a0,-1422 # 80009068 <wait_lock>
    800015fe:	00005097          	auipc	ra,0x5
    80001602:	ace080e7          	jalr	-1330(ra) # 800060cc <release>
          return pid;
    80001606:	a09d                	j	8000166c <wait+0x100>
            release(&np->lock);
    80001608:	8526                	mv	a0,s1
    8000160a:	00005097          	auipc	ra,0x5
    8000160e:	ac2080e7          	jalr	-1342(ra) # 800060cc <release>
            release(&wait_lock);
    80001612:	00008517          	auipc	a0,0x8
    80001616:	a5650513          	addi	a0,a0,-1450 # 80009068 <wait_lock>
    8000161a:	00005097          	auipc	ra,0x5
    8000161e:	ab2080e7          	jalr	-1358(ra) # 800060cc <release>
            return -1;
    80001622:	59fd                	li	s3,-1
    80001624:	a0a1                	j	8000166c <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001626:	16848493          	addi	s1,s1,360
    8000162a:	03348463          	beq	s1,s3,80001652 <wait+0xe6>
      if(np->parent == p){
    8000162e:	7c9c                	ld	a5,56(s1)
    80001630:	ff279be3          	bne	a5,s2,80001626 <wait+0xba>
        acquire(&np->lock);
    80001634:	8526                	mv	a0,s1
    80001636:	00005097          	auipc	ra,0x5
    8000163a:	9e2080e7          	jalr	-1566(ra) # 80006018 <acquire>
        if(np->state == ZOMBIE){
    8000163e:	4c9c                	lw	a5,24(s1)
    80001640:	f94781e3          	beq	a5,s4,800015c2 <wait+0x56>
        release(&np->lock);
    80001644:	8526                	mv	a0,s1
    80001646:	00005097          	auipc	ra,0x5
    8000164a:	a86080e7          	jalr	-1402(ra) # 800060cc <release>
        havekids = 1;
    8000164e:	8756                	mv	a4,s5
    80001650:	bfd9                	j	80001626 <wait+0xba>
    if(!havekids || p->killed){
    80001652:	c701                	beqz	a4,8000165a <wait+0xee>
    80001654:	02892783          	lw	a5,40(s2)
    80001658:	c79d                	beqz	a5,80001686 <wait+0x11a>
      release(&wait_lock);
    8000165a:	00008517          	auipc	a0,0x8
    8000165e:	a0e50513          	addi	a0,a0,-1522 # 80009068 <wait_lock>
    80001662:	00005097          	auipc	ra,0x5
    80001666:	a6a080e7          	jalr	-1430(ra) # 800060cc <release>
      return -1;
    8000166a:	59fd                	li	s3,-1
}
    8000166c:	854e                	mv	a0,s3
    8000166e:	60a6                	ld	ra,72(sp)
    80001670:	6406                	ld	s0,64(sp)
    80001672:	74e2                	ld	s1,56(sp)
    80001674:	7942                	ld	s2,48(sp)
    80001676:	79a2                	ld	s3,40(sp)
    80001678:	7a02                	ld	s4,32(sp)
    8000167a:	6ae2                	ld	s5,24(sp)
    8000167c:	6b42                	ld	s6,16(sp)
    8000167e:	6ba2                	ld	s7,8(sp)
    80001680:	6c02                	ld	s8,0(sp)
    80001682:	6161                	addi	sp,sp,80
    80001684:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001686:	85e2                	mv	a1,s8
    80001688:	854a                	mv	a0,s2
    8000168a:	00000097          	auipc	ra,0x0
    8000168e:	e7e080e7          	jalr	-386(ra) # 80001508 <sleep>
    havekids = 0;
    80001692:	b715                	j	800015b6 <wait+0x4a>

0000000080001694 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001694:	7139                	addi	sp,sp,-64
    80001696:	fc06                	sd	ra,56(sp)
    80001698:	f822                	sd	s0,48(sp)
    8000169a:	f426                	sd	s1,40(sp)
    8000169c:	f04a                	sd	s2,32(sp)
    8000169e:	ec4e                	sd	s3,24(sp)
    800016a0:	e852                	sd	s4,16(sp)
    800016a2:	e456                	sd	s5,8(sp)
    800016a4:	0080                	addi	s0,sp,64
    800016a6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016a8:	00008497          	auipc	s1,0x8
    800016ac:	dd848493          	addi	s1,s1,-552 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016b0:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016b2:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016b4:	0000d917          	auipc	s2,0xd
    800016b8:	7cc90913          	addi	s2,s2,1996 # 8000ee80 <tickslock>
    800016bc:	a811                	j	800016d0 <wakeup+0x3c>
      }
      release(&p->lock);
    800016be:	8526                	mv	a0,s1
    800016c0:	00005097          	auipc	ra,0x5
    800016c4:	a0c080e7          	jalr	-1524(ra) # 800060cc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016c8:	16848493          	addi	s1,s1,360
    800016cc:	03248663          	beq	s1,s2,800016f8 <wakeup+0x64>
    if(p != myproc()){
    800016d0:	fffff097          	auipc	ra,0xfffff
    800016d4:	774080e7          	jalr	1908(ra) # 80000e44 <myproc>
    800016d8:	fea488e3          	beq	s1,a0,800016c8 <wakeup+0x34>
      acquire(&p->lock);
    800016dc:	8526                	mv	a0,s1
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	93a080e7          	jalr	-1734(ra) # 80006018 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016e6:	4c9c                	lw	a5,24(s1)
    800016e8:	fd379be3          	bne	a5,s3,800016be <wakeup+0x2a>
    800016ec:	709c                	ld	a5,32(s1)
    800016ee:	fd4798e3          	bne	a5,s4,800016be <wakeup+0x2a>
        p->state = RUNNABLE;
    800016f2:	0154ac23          	sw	s5,24(s1)
    800016f6:	b7e1                	j	800016be <wakeup+0x2a>
    }
  }
}
    800016f8:	70e2                	ld	ra,56(sp)
    800016fa:	7442                	ld	s0,48(sp)
    800016fc:	74a2                	ld	s1,40(sp)
    800016fe:	7902                	ld	s2,32(sp)
    80001700:	69e2                	ld	s3,24(sp)
    80001702:	6a42                	ld	s4,16(sp)
    80001704:	6aa2                	ld	s5,8(sp)
    80001706:	6121                	addi	sp,sp,64
    80001708:	8082                	ret

000000008000170a <reparent>:
{
    8000170a:	7179                	addi	sp,sp,-48
    8000170c:	f406                	sd	ra,40(sp)
    8000170e:	f022                	sd	s0,32(sp)
    80001710:	ec26                	sd	s1,24(sp)
    80001712:	e84a                	sd	s2,16(sp)
    80001714:	e44e                	sd	s3,8(sp)
    80001716:	e052                	sd	s4,0(sp)
    80001718:	1800                	addi	s0,sp,48
    8000171a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000171c:	00008497          	auipc	s1,0x8
    80001720:	d6448493          	addi	s1,s1,-668 # 80009480 <proc>
      pp->parent = initproc;
    80001724:	00008a17          	auipc	s4,0x8
    80001728:	8eca0a13          	addi	s4,s4,-1812 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000172c:	0000d997          	auipc	s3,0xd
    80001730:	75498993          	addi	s3,s3,1876 # 8000ee80 <tickslock>
    80001734:	a029                	j	8000173e <reparent+0x34>
    80001736:	16848493          	addi	s1,s1,360
    8000173a:	01348d63          	beq	s1,s3,80001754 <reparent+0x4a>
    if(pp->parent == p){
    8000173e:	7c9c                	ld	a5,56(s1)
    80001740:	ff279be3          	bne	a5,s2,80001736 <reparent+0x2c>
      pp->parent = initproc;
    80001744:	000a3503          	ld	a0,0(s4)
    80001748:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000174a:	00000097          	auipc	ra,0x0
    8000174e:	f4a080e7          	jalr	-182(ra) # 80001694 <wakeup>
    80001752:	b7d5                	j	80001736 <reparent+0x2c>
}
    80001754:	70a2                	ld	ra,40(sp)
    80001756:	7402                	ld	s0,32(sp)
    80001758:	64e2                	ld	s1,24(sp)
    8000175a:	6942                	ld	s2,16(sp)
    8000175c:	69a2                	ld	s3,8(sp)
    8000175e:	6a02                	ld	s4,0(sp)
    80001760:	6145                	addi	sp,sp,48
    80001762:	8082                	ret

0000000080001764 <exit>:
{
    80001764:	7179                	addi	sp,sp,-48
    80001766:	f406                	sd	ra,40(sp)
    80001768:	f022                	sd	s0,32(sp)
    8000176a:	ec26                	sd	s1,24(sp)
    8000176c:	e84a                	sd	s2,16(sp)
    8000176e:	e44e                	sd	s3,8(sp)
    80001770:	e052                	sd	s4,0(sp)
    80001772:	1800                	addi	s0,sp,48
    80001774:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001776:	fffff097          	auipc	ra,0xfffff
    8000177a:	6ce080e7          	jalr	1742(ra) # 80000e44 <myproc>
    8000177e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001780:	00008797          	auipc	a5,0x8
    80001784:	8907b783          	ld	a5,-1904(a5) # 80009010 <initproc>
    80001788:	0d050493          	addi	s1,a0,208
    8000178c:	15050913          	addi	s2,a0,336
    80001790:	02a79363          	bne	a5,a0,800017b6 <exit+0x52>
    panic("init exiting");
    80001794:	00007517          	auipc	a0,0x7
    80001798:	a4c50513          	addi	a0,a0,-1460 # 800081e0 <etext+0x1e0>
    8000179c:	00004097          	auipc	ra,0x4
    800017a0:	344080e7          	jalr	836(ra) # 80005ae0 <panic>
      fileclose(f);
    800017a4:	00002097          	auipc	ra,0x2
    800017a8:	16c080e7          	jalr	364(ra) # 80003910 <fileclose>
      p->ofile[fd] = 0;
    800017ac:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017b0:	04a1                	addi	s1,s1,8
    800017b2:	01248563          	beq	s1,s2,800017bc <exit+0x58>
    if(p->ofile[fd]){
    800017b6:	6088                	ld	a0,0(s1)
    800017b8:	f575                	bnez	a0,800017a4 <exit+0x40>
    800017ba:	bfdd                	j	800017b0 <exit+0x4c>
  begin_op();
    800017bc:	00002097          	auipc	ra,0x2
    800017c0:	c8c080e7          	jalr	-884(ra) # 80003448 <begin_op>
  iput(p->cwd);
    800017c4:	1509b503          	ld	a0,336(s3)
    800017c8:	00001097          	auipc	ra,0x1
    800017cc:	45e080e7          	jalr	1118(ra) # 80002c26 <iput>
  end_op();
    800017d0:	00002097          	auipc	ra,0x2
    800017d4:	cf6080e7          	jalr	-778(ra) # 800034c6 <end_op>
  p->cwd = 0;
    800017d8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017dc:	00008497          	auipc	s1,0x8
    800017e0:	88c48493          	addi	s1,s1,-1908 # 80009068 <wait_lock>
    800017e4:	8526                	mv	a0,s1
    800017e6:	00005097          	auipc	ra,0x5
    800017ea:	832080e7          	jalr	-1998(ra) # 80006018 <acquire>
  reparent(p);
    800017ee:	854e                	mv	a0,s3
    800017f0:	00000097          	auipc	ra,0x0
    800017f4:	f1a080e7          	jalr	-230(ra) # 8000170a <reparent>
  wakeup(p->parent);
    800017f8:	0389b503          	ld	a0,56(s3)
    800017fc:	00000097          	auipc	ra,0x0
    80001800:	e98080e7          	jalr	-360(ra) # 80001694 <wakeup>
  acquire(&p->lock);
    80001804:	854e                	mv	a0,s3
    80001806:	00005097          	auipc	ra,0x5
    8000180a:	812080e7          	jalr	-2030(ra) # 80006018 <acquire>
  p->xstate = status;
    8000180e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001812:	4795                	li	a5,5
    80001814:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	8b2080e7          	jalr	-1870(ra) # 800060cc <release>
  sched();
    80001822:	00000097          	auipc	ra,0x0
    80001826:	bd4080e7          	jalr	-1068(ra) # 800013f6 <sched>
  panic("zombie exit");
    8000182a:	00007517          	auipc	a0,0x7
    8000182e:	9c650513          	addi	a0,a0,-1594 # 800081f0 <etext+0x1f0>
    80001832:	00004097          	auipc	ra,0x4
    80001836:	2ae080e7          	jalr	686(ra) # 80005ae0 <panic>

000000008000183a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000183a:	7179                	addi	sp,sp,-48
    8000183c:	f406                	sd	ra,40(sp)
    8000183e:	f022                	sd	s0,32(sp)
    80001840:	ec26                	sd	s1,24(sp)
    80001842:	e84a                	sd	s2,16(sp)
    80001844:	e44e                	sd	s3,8(sp)
    80001846:	1800                	addi	s0,sp,48
    80001848:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000184a:	00008497          	auipc	s1,0x8
    8000184e:	c3648493          	addi	s1,s1,-970 # 80009480 <proc>
    80001852:	0000d997          	auipc	s3,0xd
    80001856:	62e98993          	addi	s3,s3,1582 # 8000ee80 <tickslock>
    acquire(&p->lock);
    8000185a:	8526                	mv	a0,s1
    8000185c:	00004097          	auipc	ra,0x4
    80001860:	7bc080e7          	jalr	1980(ra) # 80006018 <acquire>
    if(p->pid == pid){
    80001864:	589c                	lw	a5,48(s1)
    80001866:	01278d63          	beq	a5,s2,80001880 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000186a:	8526                	mv	a0,s1
    8000186c:	00005097          	auipc	ra,0x5
    80001870:	860080e7          	jalr	-1952(ra) # 800060cc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001874:	16848493          	addi	s1,s1,360
    80001878:	ff3491e3          	bne	s1,s3,8000185a <kill+0x20>
  }
  return -1;
    8000187c:	557d                	li	a0,-1
    8000187e:	a829                	j	80001898 <kill+0x5e>
      p->killed = 1;
    80001880:	4785                	li	a5,1
    80001882:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001884:	4c98                	lw	a4,24(s1)
    80001886:	4789                	li	a5,2
    80001888:	00f70f63          	beq	a4,a5,800018a6 <kill+0x6c>
      release(&p->lock);
    8000188c:	8526                	mv	a0,s1
    8000188e:	00005097          	auipc	ra,0x5
    80001892:	83e080e7          	jalr	-1986(ra) # 800060cc <release>
      return 0;
    80001896:	4501                	li	a0,0
}
    80001898:	70a2                	ld	ra,40(sp)
    8000189a:	7402                	ld	s0,32(sp)
    8000189c:	64e2                	ld	s1,24(sp)
    8000189e:	6942                	ld	s2,16(sp)
    800018a0:	69a2                	ld	s3,8(sp)
    800018a2:	6145                	addi	sp,sp,48
    800018a4:	8082                	ret
        p->state = RUNNABLE;
    800018a6:	478d                	li	a5,3
    800018a8:	cc9c                	sw	a5,24(s1)
    800018aa:	b7cd                	j	8000188c <kill+0x52>

00000000800018ac <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018ac:	7179                	addi	sp,sp,-48
    800018ae:	f406                	sd	ra,40(sp)
    800018b0:	f022                	sd	s0,32(sp)
    800018b2:	ec26                	sd	s1,24(sp)
    800018b4:	e84a                	sd	s2,16(sp)
    800018b6:	e44e                	sd	s3,8(sp)
    800018b8:	e052                	sd	s4,0(sp)
    800018ba:	1800                	addi	s0,sp,48
    800018bc:	84aa                	mv	s1,a0
    800018be:	892e                	mv	s2,a1
    800018c0:	89b2                	mv	s3,a2
    800018c2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018c4:	fffff097          	auipc	ra,0xfffff
    800018c8:	580080e7          	jalr	1408(ra) # 80000e44 <myproc>
  if(user_dst){
    800018cc:	c08d                	beqz	s1,800018ee <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018ce:	86d2                	mv	a3,s4
    800018d0:	864e                	mv	a2,s3
    800018d2:	85ca                	mv	a1,s2
    800018d4:	6928                	ld	a0,80(a0)
    800018d6:	fffff097          	auipc	ra,0xfffff
    800018da:	232080e7          	jalr	562(ra) # 80000b08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018de:	70a2                	ld	ra,40(sp)
    800018e0:	7402                	ld	s0,32(sp)
    800018e2:	64e2                	ld	s1,24(sp)
    800018e4:	6942                	ld	s2,16(sp)
    800018e6:	69a2                	ld	s3,8(sp)
    800018e8:	6a02                	ld	s4,0(sp)
    800018ea:	6145                	addi	sp,sp,48
    800018ec:	8082                	ret
    memmove((char *)dst, src, len);
    800018ee:	000a061b          	sext.w	a2,s4
    800018f2:	85ce                	mv	a1,s3
    800018f4:	854a                	mv	a0,s2
    800018f6:	fffff097          	auipc	ra,0xfffff
    800018fa:	8e0080e7          	jalr	-1824(ra) # 800001d6 <memmove>
    return 0;
    800018fe:	8526                	mv	a0,s1
    80001900:	bff9                	j	800018de <either_copyout+0x32>

0000000080001902 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001902:	7179                	addi	sp,sp,-48
    80001904:	f406                	sd	ra,40(sp)
    80001906:	f022                	sd	s0,32(sp)
    80001908:	ec26                	sd	s1,24(sp)
    8000190a:	e84a                	sd	s2,16(sp)
    8000190c:	e44e                	sd	s3,8(sp)
    8000190e:	e052                	sd	s4,0(sp)
    80001910:	1800                	addi	s0,sp,48
    80001912:	892a                	mv	s2,a0
    80001914:	84ae                	mv	s1,a1
    80001916:	89b2                	mv	s3,a2
    80001918:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191a:	fffff097          	auipc	ra,0xfffff
    8000191e:	52a080e7          	jalr	1322(ra) # 80000e44 <myproc>
  if(user_src){
    80001922:	c08d                	beqz	s1,80001944 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001924:	86d2                	mv	a3,s4
    80001926:	864e                	mv	a2,s3
    80001928:	85ca                	mv	a1,s2
    8000192a:	6928                	ld	a0,80(a0)
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	268080e7          	jalr	616(ra) # 80000b94 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001934:	70a2                	ld	ra,40(sp)
    80001936:	7402                	ld	s0,32(sp)
    80001938:	64e2                	ld	s1,24(sp)
    8000193a:	6942                	ld	s2,16(sp)
    8000193c:	69a2                	ld	s3,8(sp)
    8000193e:	6a02                	ld	s4,0(sp)
    80001940:	6145                	addi	sp,sp,48
    80001942:	8082                	ret
    memmove(dst, (char*)src, len);
    80001944:	000a061b          	sext.w	a2,s4
    80001948:	85ce                	mv	a1,s3
    8000194a:	854a                	mv	a0,s2
    8000194c:	fffff097          	auipc	ra,0xfffff
    80001950:	88a080e7          	jalr	-1910(ra) # 800001d6 <memmove>
    return 0;
    80001954:	8526                	mv	a0,s1
    80001956:	bff9                	j	80001934 <either_copyin+0x32>

0000000080001958 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001958:	715d                	addi	sp,sp,-80
    8000195a:	e486                	sd	ra,72(sp)
    8000195c:	e0a2                	sd	s0,64(sp)
    8000195e:	fc26                	sd	s1,56(sp)
    80001960:	f84a                	sd	s2,48(sp)
    80001962:	f44e                	sd	s3,40(sp)
    80001964:	f052                	sd	s4,32(sp)
    80001966:	ec56                	sd	s5,24(sp)
    80001968:	e85a                	sd	s6,16(sp)
    8000196a:	e45e                	sd	s7,8(sp)
    8000196c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000196e:	00006517          	auipc	a0,0x6
    80001972:	6da50513          	addi	a0,a0,1754 # 80008048 <etext+0x48>
    80001976:	00004097          	auipc	ra,0x4
    8000197a:	1b4080e7          	jalr	436(ra) # 80005b2a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000197e:	00008497          	auipc	s1,0x8
    80001982:	c5a48493          	addi	s1,s1,-934 # 800095d8 <proc+0x158>
    80001986:	0000d917          	auipc	s2,0xd
    8000198a:	65290913          	addi	s2,s2,1618 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000198e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001990:	00007997          	auipc	s3,0x7
    80001994:	87098993          	addi	s3,s3,-1936 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001998:	00007a97          	auipc	s5,0x7
    8000199c:	870a8a93          	addi	s5,s5,-1936 # 80008208 <etext+0x208>
    printf("\n");
    800019a0:	00006a17          	auipc	s4,0x6
    800019a4:	6a8a0a13          	addi	s4,s4,1704 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019a8:	00007b97          	auipc	s7,0x7
    800019ac:	898b8b93          	addi	s7,s7,-1896 # 80008240 <states.0>
    800019b0:	a00d                	j	800019d2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019b2:	ed86a583          	lw	a1,-296(a3)
    800019b6:	8556                	mv	a0,s5
    800019b8:	00004097          	auipc	ra,0x4
    800019bc:	172080e7          	jalr	370(ra) # 80005b2a <printf>
    printf("\n");
    800019c0:	8552                	mv	a0,s4
    800019c2:	00004097          	auipc	ra,0x4
    800019c6:	168080e7          	jalr	360(ra) # 80005b2a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ca:	16848493          	addi	s1,s1,360
    800019ce:	03248263          	beq	s1,s2,800019f2 <procdump+0x9a>
    if(p->state == UNUSED)
    800019d2:	86a6                	mv	a3,s1
    800019d4:	ec04a783          	lw	a5,-320(s1)
    800019d8:	dbed                	beqz	a5,800019ca <procdump+0x72>
      state = "???";
    800019da:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019dc:	fcfb6be3          	bltu	s6,a5,800019b2 <procdump+0x5a>
    800019e0:	02079713          	slli	a4,a5,0x20
    800019e4:	01d75793          	srli	a5,a4,0x1d
    800019e8:	97de                	add	a5,a5,s7
    800019ea:	6390                	ld	a2,0(a5)
    800019ec:	f279                	bnez	a2,800019b2 <procdump+0x5a>
      state = "???";
    800019ee:	864e                	mv	a2,s3
    800019f0:	b7c9                	j	800019b2 <procdump+0x5a>
  }
}
    800019f2:	60a6                	ld	ra,72(sp)
    800019f4:	6406                	ld	s0,64(sp)
    800019f6:	74e2                	ld	s1,56(sp)
    800019f8:	7942                	ld	s2,48(sp)
    800019fa:	79a2                	ld	s3,40(sp)
    800019fc:	7a02                	ld	s4,32(sp)
    800019fe:	6ae2                	ld	s5,24(sp)
    80001a00:	6b42                	ld	s6,16(sp)
    80001a02:	6ba2                	ld	s7,8(sp)
    80001a04:	6161                	addi	sp,sp,80
    80001a06:	8082                	ret

0000000080001a08 <swtch>:
    80001a08:	00153023          	sd	ra,0(a0)
    80001a0c:	00253423          	sd	sp,8(a0)
    80001a10:	e900                	sd	s0,16(a0)
    80001a12:	ed04                	sd	s1,24(a0)
    80001a14:	03253023          	sd	s2,32(a0)
    80001a18:	03353423          	sd	s3,40(a0)
    80001a1c:	03453823          	sd	s4,48(a0)
    80001a20:	03553c23          	sd	s5,56(a0)
    80001a24:	05653023          	sd	s6,64(a0)
    80001a28:	05753423          	sd	s7,72(a0)
    80001a2c:	05853823          	sd	s8,80(a0)
    80001a30:	05953c23          	sd	s9,88(a0)
    80001a34:	07a53023          	sd	s10,96(a0)
    80001a38:	07b53423          	sd	s11,104(a0)
    80001a3c:	0005b083          	ld	ra,0(a1)
    80001a40:	0085b103          	ld	sp,8(a1)
    80001a44:	6980                	ld	s0,16(a1)
    80001a46:	6d84                	ld	s1,24(a1)
    80001a48:	0205b903          	ld	s2,32(a1)
    80001a4c:	0285b983          	ld	s3,40(a1)
    80001a50:	0305ba03          	ld	s4,48(a1)
    80001a54:	0385ba83          	ld	s5,56(a1)
    80001a58:	0405bb03          	ld	s6,64(a1)
    80001a5c:	0485bb83          	ld	s7,72(a1)
    80001a60:	0505bc03          	ld	s8,80(a1)
    80001a64:	0585bc83          	ld	s9,88(a1)
    80001a68:	0605bd03          	ld	s10,96(a1)
    80001a6c:	0685bd83          	ld	s11,104(a1)
    80001a70:	8082                	ret

0000000080001a72 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a72:	1141                	addi	sp,sp,-16
    80001a74:	e406                	sd	ra,8(sp)
    80001a76:	e022                	sd	s0,0(sp)
    80001a78:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a7a:	00006597          	auipc	a1,0x6
    80001a7e:	7f658593          	addi	a1,a1,2038 # 80008270 <states.0+0x30>
    80001a82:	0000d517          	auipc	a0,0xd
    80001a86:	3fe50513          	addi	a0,a0,1022 # 8000ee80 <tickslock>
    80001a8a:	00004097          	auipc	ra,0x4
    80001a8e:	4fe080e7          	jalr	1278(ra) # 80005f88 <initlock>
}
    80001a92:	60a2                	ld	ra,8(sp)
    80001a94:	6402                	ld	s0,0(sp)
    80001a96:	0141                	addi	sp,sp,16
    80001a98:	8082                	ret

0000000080001a9a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a9a:	1141                	addi	sp,sp,-16
    80001a9c:	e422                	sd	s0,8(sp)
    80001a9e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aa0:	00003797          	auipc	a5,0x3
    80001aa4:	4a078793          	addi	a5,a5,1184 # 80004f40 <kernelvec>
    80001aa8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001aac:	6422                	ld	s0,8(sp)
    80001aae:	0141                	addi	sp,sp,16
    80001ab0:	8082                	ret

0000000080001ab2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001ab2:	1141                	addi	sp,sp,-16
    80001ab4:	e406                	sd	ra,8(sp)
    80001ab6:	e022                	sd	s0,0(sp)
    80001ab8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001aba:	fffff097          	auipc	ra,0xfffff
    80001abe:	38a080e7          	jalr	906(ra) # 80000e44 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ac2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ac6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001acc:	00005697          	auipc	a3,0x5
    80001ad0:	53468693          	addi	a3,a3,1332 # 80007000 <_trampoline>
    80001ad4:	00005717          	auipc	a4,0x5
    80001ad8:	52c70713          	addi	a4,a4,1324 # 80007000 <_trampoline>
    80001adc:	8f15                	sub	a4,a4,a3
    80001ade:	040007b7          	lui	a5,0x4000
    80001ae2:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001ae4:	07b2                	slli	a5,a5,0xc
    80001ae6:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ae8:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001aec:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001aee:	18002673          	csrr	a2,satp
    80001af2:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001af4:	6d30                	ld	a2,88(a0)
    80001af6:	6138                	ld	a4,64(a0)
    80001af8:	6585                	lui	a1,0x1
    80001afa:	972e                	add	a4,a4,a1
    80001afc:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001afe:	6d38                	ld	a4,88(a0)
    80001b00:	00000617          	auipc	a2,0x0
    80001b04:	13860613          	addi	a2,a2,312 # 80001c38 <usertrap>
    80001b08:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b0a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b0c:	8612                	mv	a2,tp
    80001b0e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b10:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b14:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b18:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b1c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b20:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b22:	6f18                	ld	a4,24(a4)
    80001b24:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b28:	692c                	ld	a1,80(a0)
    80001b2a:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b2c:	00005717          	auipc	a4,0x5
    80001b30:	56470713          	addi	a4,a4,1380 # 80007090 <userret>
    80001b34:	8f15                	sub	a4,a4,a3
    80001b36:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b38:	577d                	li	a4,-1
    80001b3a:	177e                	slli	a4,a4,0x3f
    80001b3c:	8dd9                	or	a1,a1,a4
    80001b3e:	02000537          	lui	a0,0x2000
    80001b42:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b44:	0536                	slli	a0,a0,0xd
    80001b46:	9782                	jalr	a5
}
    80001b48:	60a2                	ld	ra,8(sp)
    80001b4a:	6402                	ld	s0,0(sp)
    80001b4c:	0141                	addi	sp,sp,16
    80001b4e:	8082                	ret

0000000080001b50 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b50:	1101                	addi	sp,sp,-32
    80001b52:	ec06                	sd	ra,24(sp)
    80001b54:	e822                	sd	s0,16(sp)
    80001b56:	e426                	sd	s1,8(sp)
    80001b58:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b5a:	0000d497          	auipc	s1,0xd
    80001b5e:	32648493          	addi	s1,s1,806 # 8000ee80 <tickslock>
    80001b62:	8526                	mv	a0,s1
    80001b64:	00004097          	auipc	ra,0x4
    80001b68:	4b4080e7          	jalr	1204(ra) # 80006018 <acquire>
  ticks++;
    80001b6c:	00007517          	auipc	a0,0x7
    80001b70:	4ac50513          	addi	a0,a0,1196 # 80009018 <ticks>
    80001b74:	411c                	lw	a5,0(a0)
    80001b76:	2785                	addiw	a5,a5,1
    80001b78:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b7a:	00000097          	auipc	ra,0x0
    80001b7e:	b1a080e7          	jalr	-1254(ra) # 80001694 <wakeup>
  release(&tickslock);
    80001b82:	8526                	mv	a0,s1
    80001b84:	00004097          	auipc	ra,0x4
    80001b88:	548080e7          	jalr	1352(ra) # 800060cc <release>
}
    80001b8c:	60e2                	ld	ra,24(sp)
    80001b8e:	6442                	ld	s0,16(sp)
    80001b90:	64a2                	ld	s1,8(sp)
    80001b92:	6105                	addi	sp,sp,32
    80001b94:	8082                	ret

0000000080001b96 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b96:	1101                	addi	sp,sp,-32
    80001b98:	ec06                	sd	ra,24(sp)
    80001b9a:	e822                	sd	s0,16(sp)
    80001b9c:	e426                	sd	s1,8(sp)
    80001b9e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ba0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001ba4:	00074d63          	bltz	a4,80001bbe <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001ba8:	57fd                	li	a5,-1
    80001baa:	17fe                	slli	a5,a5,0x3f
    80001bac:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bae:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bb0:	06f70363          	beq	a4,a5,80001c16 <devintr+0x80>
  }
}
    80001bb4:	60e2                	ld	ra,24(sp)
    80001bb6:	6442                	ld	s0,16(sp)
    80001bb8:	64a2                	ld	s1,8(sp)
    80001bba:	6105                	addi	sp,sp,32
    80001bbc:	8082                	ret
     (scause & 0xff) == 9){
    80001bbe:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001bc2:	46a5                	li	a3,9
    80001bc4:	fed792e3          	bne	a5,a3,80001ba8 <devintr+0x12>
    int irq = plic_claim();
    80001bc8:	00003097          	auipc	ra,0x3
    80001bcc:	480080e7          	jalr	1152(ra) # 80005048 <plic_claim>
    80001bd0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bd2:	47a9                	li	a5,10
    80001bd4:	02f50763          	beq	a0,a5,80001c02 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001bd8:	4785                	li	a5,1
    80001bda:	02f50963          	beq	a0,a5,80001c0c <devintr+0x76>
    return 1;
    80001bde:	4505                	li	a0,1
    } else if(irq){
    80001be0:	d8f1                	beqz	s1,80001bb4 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001be2:	85a6                	mv	a1,s1
    80001be4:	00006517          	auipc	a0,0x6
    80001be8:	69450513          	addi	a0,a0,1684 # 80008278 <states.0+0x38>
    80001bec:	00004097          	auipc	ra,0x4
    80001bf0:	f3e080e7          	jalr	-194(ra) # 80005b2a <printf>
      plic_complete(irq);
    80001bf4:	8526                	mv	a0,s1
    80001bf6:	00003097          	auipc	ra,0x3
    80001bfa:	476080e7          	jalr	1142(ra) # 8000506c <plic_complete>
    return 1;
    80001bfe:	4505                	li	a0,1
    80001c00:	bf55                	j	80001bb4 <devintr+0x1e>
      uartintr();
    80001c02:	00004097          	auipc	ra,0x4
    80001c06:	336080e7          	jalr	822(ra) # 80005f38 <uartintr>
    80001c0a:	b7ed                	j	80001bf4 <devintr+0x5e>
      virtio_disk_intr();
    80001c0c:	00004097          	auipc	ra,0x4
    80001c10:	8ec080e7          	jalr	-1812(ra) # 800054f8 <virtio_disk_intr>
    80001c14:	b7c5                	j	80001bf4 <devintr+0x5e>
    if(cpuid() == 0){
    80001c16:	fffff097          	auipc	ra,0xfffff
    80001c1a:	202080e7          	jalr	514(ra) # 80000e18 <cpuid>
    80001c1e:	c901                	beqz	a0,80001c2e <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c20:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c24:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c26:	14479073          	csrw	sip,a5
    return 2;
    80001c2a:	4509                	li	a0,2
    80001c2c:	b761                	j	80001bb4 <devintr+0x1e>
      clockintr();
    80001c2e:	00000097          	auipc	ra,0x0
    80001c32:	f22080e7          	jalr	-222(ra) # 80001b50 <clockintr>
    80001c36:	b7ed                	j	80001c20 <devintr+0x8a>

0000000080001c38 <usertrap>:
{
    80001c38:	1101                	addi	sp,sp,-32
    80001c3a:	ec06                	sd	ra,24(sp)
    80001c3c:	e822                	sd	s0,16(sp)
    80001c3e:	e426                	sd	s1,8(sp)
    80001c40:	e04a                	sd	s2,0(sp)
    80001c42:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c44:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c48:	1007f793          	andi	a5,a5,256
    80001c4c:	e3ad                	bnez	a5,80001cae <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c4e:	00003797          	auipc	a5,0x3
    80001c52:	2f278793          	addi	a5,a5,754 # 80004f40 <kernelvec>
    80001c56:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c5a:	fffff097          	auipc	ra,0xfffff
    80001c5e:	1ea080e7          	jalr	490(ra) # 80000e44 <myproc>
    80001c62:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c64:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c66:	14102773          	csrr	a4,sepc
    80001c6a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c6c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c70:	47a1                	li	a5,8
    80001c72:	04f71c63          	bne	a4,a5,80001cca <usertrap+0x92>
    if(p->killed)
    80001c76:	551c                	lw	a5,40(a0)
    80001c78:	e3b9                	bnez	a5,80001cbe <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c7a:	6cb8                	ld	a4,88(s1)
    80001c7c:	6f1c                	ld	a5,24(a4)
    80001c7e:	0791                	addi	a5,a5,4
    80001c80:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c82:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c86:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c8a:	10079073          	csrw	sstatus,a5
    syscall();
    80001c8e:	00000097          	auipc	ra,0x0
    80001c92:	2e0080e7          	jalr	736(ra) # 80001f6e <syscall>
  if(p->killed)
    80001c96:	549c                	lw	a5,40(s1)
    80001c98:	ebc1                	bnez	a5,80001d28 <usertrap+0xf0>
  usertrapret();
    80001c9a:	00000097          	auipc	ra,0x0
    80001c9e:	e18080e7          	jalr	-488(ra) # 80001ab2 <usertrapret>
}
    80001ca2:	60e2                	ld	ra,24(sp)
    80001ca4:	6442                	ld	s0,16(sp)
    80001ca6:	64a2                	ld	s1,8(sp)
    80001ca8:	6902                	ld	s2,0(sp)
    80001caa:	6105                	addi	sp,sp,32
    80001cac:	8082                	ret
    panic("usertrap: not from user mode");
    80001cae:	00006517          	auipc	a0,0x6
    80001cb2:	5ea50513          	addi	a0,a0,1514 # 80008298 <states.0+0x58>
    80001cb6:	00004097          	auipc	ra,0x4
    80001cba:	e2a080e7          	jalr	-470(ra) # 80005ae0 <panic>
      exit(-1);
    80001cbe:	557d                	li	a0,-1
    80001cc0:	00000097          	auipc	ra,0x0
    80001cc4:	aa4080e7          	jalr	-1372(ra) # 80001764 <exit>
    80001cc8:	bf4d                	j	80001c7a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cca:	00000097          	auipc	ra,0x0
    80001cce:	ecc080e7          	jalr	-308(ra) # 80001b96 <devintr>
    80001cd2:	892a                	mv	s2,a0
    80001cd4:	c501                	beqz	a0,80001cdc <usertrap+0xa4>
  if(p->killed)
    80001cd6:	549c                	lw	a5,40(s1)
    80001cd8:	c3a1                	beqz	a5,80001d18 <usertrap+0xe0>
    80001cda:	a815                	j	80001d0e <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cdc:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ce0:	5890                	lw	a2,48(s1)
    80001ce2:	00006517          	auipc	a0,0x6
    80001ce6:	5d650513          	addi	a0,a0,1494 # 800082b8 <states.0+0x78>
    80001cea:	00004097          	auipc	ra,0x4
    80001cee:	e40080e7          	jalr	-448(ra) # 80005b2a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cf2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cf6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001cfa:	00006517          	auipc	a0,0x6
    80001cfe:	5ee50513          	addi	a0,a0,1518 # 800082e8 <states.0+0xa8>
    80001d02:	00004097          	auipc	ra,0x4
    80001d06:	e28080e7          	jalr	-472(ra) # 80005b2a <printf>
    p->killed = 1;
    80001d0a:	4785                	li	a5,1
    80001d0c:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d0e:	557d                	li	a0,-1
    80001d10:	00000097          	auipc	ra,0x0
    80001d14:	a54080e7          	jalr	-1452(ra) # 80001764 <exit>
  if(which_dev == 2)
    80001d18:	4789                	li	a5,2
    80001d1a:	f8f910e3          	bne	s2,a5,80001c9a <usertrap+0x62>
    yield();
    80001d1e:	fffff097          	auipc	ra,0xfffff
    80001d22:	7ae080e7          	jalr	1966(ra) # 800014cc <yield>
    80001d26:	bf95                	j	80001c9a <usertrap+0x62>
  int which_dev = 0;
    80001d28:	4901                	li	s2,0
    80001d2a:	b7d5                	j	80001d0e <usertrap+0xd6>

0000000080001d2c <kerneltrap>:
{
    80001d2c:	7179                	addi	sp,sp,-48
    80001d2e:	f406                	sd	ra,40(sp)
    80001d30:	f022                	sd	s0,32(sp)
    80001d32:	ec26                	sd	s1,24(sp)
    80001d34:	e84a                	sd	s2,16(sp)
    80001d36:	e44e                	sd	s3,8(sp)
    80001d38:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d3a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d3e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d42:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d46:	1004f793          	andi	a5,s1,256
    80001d4a:	cb85                	beqz	a5,80001d7a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d4c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d50:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d52:	ef85                	bnez	a5,80001d8a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d54:	00000097          	auipc	ra,0x0
    80001d58:	e42080e7          	jalr	-446(ra) # 80001b96 <devintr>
    80001d5c:	cd1d                	beqz	a0,80001d9a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d5e:	4789                	li	a5,2
    80001d60:	06f50a63          	beq	a0,a5,80001dd4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d64:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d68:	10049073          	csrw	sstatus,s1
}
    80001d6c:	70a2                	ld	ra,40(sp)
    80001d6e:	7402                	ld	s0,32(sp)
    80001d70:	64e2                	ld	s1,24(sp)
    80001d72:	6942                	ld	s2,16(sp)
    80001d74:	69a2                	ld	s3,8(sp)
    80001d76:	6145                	addi	sp,sp,48
    80001d78:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001d7a:	00006517          	auipc	a0,0x6
    80001d7e:	58e50513          	addi	a0,a0,1422 # 80008308 <states.0+0xc8>
    80001d82:	00004097          	auipc	ra,0x4
    80001d86:	d5e080e7          	jalr	-674(ra) # 80005ae0 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d8a:	00006517          	auipc	a0,0x6
    80001d8e:	5a650513          	addi	a0,a0,1446 # 80008330 <states.0+0xf0>
    80001d92:	00004097          	auipc	ra,0x4
    80001d96:	d4e080e7          	jalr	-690(ra) # 80005ae0 <panic>
    printf("scause %p\n", scause);
    80001d9a:	85ce                	mv	a1,s3
    80001d9c:	00006517          	auipc	a0,0x6
    80001da0:	5b450513          	addi	a0,a0,1460 # 80008350 <states.0+0x110>
    80001da4:	00004097          	auipc	ra,0x4
    80001da8:	d86080e7          	jalr	-634(ra) # 80005b2a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dac:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001db0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001db4:	00006517          	auipc	a0,0x6
    80001db8:	5ac50513          	addi	a0,a0,1452 # 80008360 <states.0+0x120>
    80001dbc:	00004097          	auipc	ra,0x4
    80001dc0:	d6e080e7          	jalr	-658(ra) # 80005b2a <printf>
    panic("kerneltrap");
    80001dc4:	00006517          	auipc	a0,0x6
    80001dc8:	5b450513          	addi	a0,a0,1460 # 80008378 <states.0+0x138>
    80001dcc:	00004097          	auipc	ra,0x4
    80001dd0:	d14080e7          	jalr	-748(ra) # 80005ae0 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dd4:	fffff097          	auipc	ra,0xfffff
    80001dd8:	070080e7          	jalr	112(ra) # 80000e44 <myproc>
    80001ddc:	d541                	beqz	a0,80001d64 <kerneltrap+0x38>
    80001dde:	fffff097          	auipc	ra,0xfffff
    80001de2:	066080e7          	jalr	102(ra) # 80000e44 <myproc>
    80001de6:	4d18                	lw	a4,24(a0)
    80001de8:	4791                	li	a5,4
    80001dea:	f6f71de3          	bne	a4,a5,80001d64 <kerneltrap+0x38>
    yield();
    80001dee:	fffff097          	auipc	ra,0xfffff
    80001df2:	6de080e7          	jalr	1758(ra) # 800014cc <yield>
    80001df6:	b7bd                	j	80001d64 <kerneltrap+0x38>

0000000080001df8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001df8:	1101                	addi	sp,sp,-32
    80001dfa:	ec06                	sd	ra,24(sp)
    80001dfc:	e822                	sd	s0,16(sp)
    80001dfe:	e426                	sd	s1,8(sp)
    80001e00:	1000                	addi	s0,sp,32
    80001e02:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e04:	fffff097          	auipc	ra,0xfffff
    80001e08:	040080e7          	jalr	64(ra) # 80000e44 <myproc>
  switch (n) {
    80001e0c:	4795                	li	a5,5
    80001e0e:	0497e163          	bltu	a5,s1,80001e50 <argraw+0x58>
    80001e12:	048a                	slli	s1,s1,0x2
    80001e14:	00006717          	auipc	a4,0x6
    80001e18:	59c70713          	addi	a4,a4,1436 # 800083b0 <states.0+0x170>
    80001e1c:	94ba                	add	s1,s1,a4
    80001e1e:	409c                	lw	a5,0(s1)
    80001e20:	97ba                	add	a5,a5,a4
    80001e22:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e24:	6d3c                	ld	a5,88(a0)
    80001e26:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e28:	60e2                	ld	ra,24(sp)
    80001e2a:	6442                	ld	s0,16(sp)
    80001e2c:	64a2                	ld	s1,8(sp)
    80001e2e:	6105                	addi	sp,sp,32
    80001e30:	8082                	ret
    return p->trapframe->a1;
    80001e32:	6d3c                	ld	a5,88(a0)
    80001e34:	7fa8                	ld	a0,120(a5)
    80001e36:	bfcd                	j	80001e28 <argraw+0x30>
    return p->trapframe->a2;
    80001e38:	6d3c                	ld	a5,88(a0)
    80001e3a:	63c8                	ld	a0,128(a5)
    80001e3c:	b7f5                	j	80001e28 <argraw+0x30>
    return p->trapframe->a3;
    80001e3e:	6d3c                	ld	a5,88(a0)
    80001e40:	67c8                	ld	a0,136(a5)
    80001e42:	b7dd                	j	80001e28 <argraw+0x30>
    return p->trapframe->a4;
    80001e44:	6d3c                	ld	a5,88(a0)
    80001e46:	6bc8                	ld	a0,144(a5)
    80001e48:	b7c5                	j	80001e28 <argraw+0x30>
    return p->trapframe->a5;
    80001e4a:	6d3c                	ld	a5,88(a0)
    80001e4c:	6fc8                	ld	a0,152(a5)
    80001e4e:	bfe9                	j	80001e28 <argraw+0x30>
  panic("argraw");
    80001e50:	00006517          	auipc	a0,0x6
    80001e54:	53850513          	addi	a0,a0,1336 # 80008388 <states.0+0x148>
    80001e58:	00004097          	auipc	ra,0x4
    80001e5c:	c88080e7          	jalr	-888(ra) # 80005ae0 <panic>

0000000080001e60 <fetchaddr>:
{
    80001e60:	1101                	addi	sp,sp,-32
    80001e62:	ec06                	sd	ra,24(sp)
    80001e64:	e822                	sd	s0,16(sp)
    80001e66:	e426                	sd	s1,8(sp)
    80001e68:	e04a                	sd	s2,0(sp)
    80001e6a:	1000                	addi	s0,sp,32
    80001e6c:	84aa                	mv	s1,a0
    80001e6e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e70:	fffff097          	auipc	ra,0xfffff
    80001e74:	fd4080e7          	jalr	-44(ra) # 80000e44 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001e78:	653c                	ld	a5,72(a0)
    80001e7a:	02f4f863          	bgeu	s1,a5,80001eaa <fetchaddr+0x4a>
    80001e7e:	00848713          	addi	a4,s1,8
    80001e82:	02e7e663          	bltu	a5,a4,80001eae <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e86:	46a1                	li	a3,8
    80001e88:	8626                	mv	a2,s1
    80001e8a:	85ca                	mv	a1,s2
    80001e8c:	6928                	ld	a0,80(a0)
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	d06080e7          	jalr	-762(ra) # 80000b94 <copyin>
    80001e96:	00a03533          	snez	a0,a0
    80001e9a:	40a00533          	neg	a0,a0
}
    80001e9e:	60e2                	ld	ra,24(sp)
    80001ea0:	6442                	ld	s0,16(sp)
    80001ea2:	64a2                	ld	s1,8(sp)
    80001ea4:	6902                	ld	s2,0(sp)
    80001ea6:	6105                	addi	sp,sp,32
    80001ea8:	8082                	ret
    return -1;
    80001eaa:	557d                	li	a0,-1
    80001eac:	bfcd                	j	80001e9e <fetchaddr+0x3e>
    80001eae:	557d                	li	a0,-1
    80001eb0:	b7fd                	j	80001e9e <fetchaddr+0x3e>

0000000080001eb2 <fetchstr>:
{
    80001eb2:	7179                	addi	sp,sp,-48
    80001eb4:	f406                	sd	ra,40(sp)
    80001eb6:	f022                	sd	s0,32(sp)
    80001eb8:	ec26                	sd	s1,24(sp)
    80001eba:	e84a                	sd	s2,16(sp)
    80001ebc:	e44e                	sd	s3,8(sp)
    80001ebe:	1800                	addi	s0,sp,48
    80001ec0:	892a                	mv	s2,a0
    80001ec2:	84ae                	mv	s1,a1
    80001ec4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	f7e080e7          	jalr	-130(ra) # 80000e44 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ece:	86ce                	mv	a3,s3
    80001ed0:	864a                	mv	a2,s2
    80001ed2:	85a6                	mv	a1,s1
    80001ed4:	6928                	ld	a0,80(a0)
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	d4c080e7          	jalr	-692(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001ede:	00054763          	bltz	a0,80001eec <fetchstr+0x3a>
  return strlen(buf);
    80001ee2:	8526                	mv	a0,s1
    80001ee4:	ffffe097          	auipc	ra,0xffffe
    80001ee8:	412080e7          	jalr	1042(ra) # 800002f6 <strlen>
}
    80001eec:	70a2                	ld	ra,40(sp)
    80001eee:	7402                	ld	s0,32(sp)
    80001ef0:	64e2                	ld	s1,24(sp)
    80001ef2:	6942                	ld	s2,16(sp)
    80001ef4:	69a2                	ld	s3,8(sp)
    80001ef6:	6145                	addi	sp,sp,48
    80001ef8:	8082                	ret

0000000080001efa <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001efa:	1101                	addi	sp,sp,-32
    80001efc:	ec06                	sd	ra,24(sp)
    80001efe:	e822                	sd	s0,16(sp)
    80001f00:	e426                	sd	s1,8(sp)
    80001f02:	1000                	addi	s0,sp,32
    80001f04:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f06:	00000097          	auipc	ra,0x0
    80001f0a:	ef2080e7          	jalr	-270(ra) # 80001df8 <argraw>
    80001f0e:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f10:	4501                	li	a0,0
    80001f12:	60e2                	ld	ra,24(sp)
    80001f14:	6442                	ld	s0,16(sp)
    80001f16:	64a2                	ld	s1,8(sp)
    80001f18:	6105                	addi	sp,sp,32
    80001f1a:	8082                	ret

0000000080001f1c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f1c:	1101                	addi	sp,sp,-32
    80001f1e:	ec06                	sd	ra,24(sp)
    80001f20:	e822                	sd	s0,16(sp)
    80001f22:	e426                	sd	s1,8(sp)
    80001f24:	1000                	addi	s0,sp,32
    80001f26:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f28:	00000097          	auipc	ra,0x0
    80001f2c:	ed0080e7          	jalr	-304(ra) # 80001df8 <argraw>
    80001f30:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f32:	4501                	li	a0,0
    80001f34:	60e2                	ld	ra,24(sp)
    80001f36:	6442                	ld	s0,16(sp)
    80001f38:	64a2                	ld	s1,8(sp)
    80001f3a:	6105                	addi	sp,sp,32
    80001f3c:	8082                	ret

0000000080001f3e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f3e:	1101                	addi	sp,sp,-32
    80001f40:	ec06                	sd	ra,24(sp)
    80001f42:	e822                	sd	s0,16(sp)
    80001f44:	e426                	sd	s1,8(sp)
    80001f46:	e04a                	sd	s2,0(sp)
    80001f48:	1000                	addi	s0,sp,32
    80001f4a:	84ae                	mv	s1,a1
    80001f4c:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f4e:	00000097          	auipc	ra,0x0
    80001f52:	eaa080e7          	jalr	-342(ra) # 80001df8 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f56:	864a                	mv	a2,s2
    80001f58:	85a6                	mv	a1,s1
    80001f5a:	00000097          	auipc	ra,0x0
    80001f5e:	f58080e7          	jalr	-168(ra) # 80001eb2 <fetchstr>
}
    80001f62:	60e2                	ld	ra,24(sp)
    80001f64:	6442                	ld	s0,16(sp)
    80001f66:	64a2                	ld	s1,8(sp)
    80001f68:	6902                	ld	s2,0(sp)
    80001f6a:	6105                	addi	sp,sp,32
    80001f6c:	8082                	ret

0000000080001f6e <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001f6e:	1101                	addi	sp,sp,-32
    80001f70:	ec06                	sd	ra,24(sp)
    80001f72:	e822                	sd	s0,16(sp)
    80001f74:	e426                	sd	s1,8(sp)
    80001f76:	e04a                	sd	s2,0(sp)
    80001f78:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001f7a:	fffff097          	auipc	ra,0xfffff
    80001f7e:	eca080e7          	jalr	-310(ra) # 80000e44 <myproc>
    80001f82:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001f84:	05853903          	ld	s2,88(a0)
    80001f88:	0a893783          	ld	a5,168(s2)
    80001f8c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001f90:	37fd                	addiw	a5,a5,-1
    80001f92:	4751                	li	a4,20
    80001f94:	00f76f63          	bltu	a4,a5,80001fb2 <syscall+0x44>
    80001f98:	00369713          	slli	a4,a3,0x3
    80001f9c:	00006797          	auipc	a5,0x6
    80001fa0:	42c78793          	addi	a5,a5,1068 # 800083c8 <syscalls>
    80001fa4:	97ba                	add	a5,a5,a4
    80001fa6:	639c                	ld	a5,0(a5)
    80001fa8:	c789                	beqz	a5,80001fb2 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001faa:	9782                	jalr	a5
    80001fac:	06a93823          	sd	a0,112(s2)
    80001fb0:	a839                	j	80001fce <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001fb2:	15848613          	addi	a2,s1,344
    80001fb6:	588c                	lw	a1,48(s1)
    80001fb8:	00006517          	auipc	a0,0x6
    80001fbc:	3d850513          	addi	a0,a0,984 # 80008390 <states.0+0x150>
    80001fc0:	00004097          	auipc	ra,0x4
    80001fc4:	b6a080e7          	jalr	-1174(ra) # 80005b2a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001fc8:	6cbc                	ld	a5,88(s1)
    80001fca:	577d                	li	a4,-1
    80001fcc:	fbb8                	sd	a4,112(a5)
  }
}
    80001fce:	60e2                	ld	ra,24(sp)
    80001fd0:	6442                	ld	s0,16(sp)
    80001fd2:	64a2                	ld	s1,8(sp)
    80001fd4:	6902                	ld	s2,0(sp)
    80001fd6:	6105                	addi	sp,sp,32
    80001fd8:	8082                	ret

0000000080001fda <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001fda:	1101                	addi	sp,sp,-32
    80001fdc:	ec06                	sd	ra,24(sp)
    80001fde:	e822                	sd	s0,16(sp)
    80001fe0:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80001fe2:	fec40593          	addi	a1,s0,-20
    80001fe6:	4501                	li	a0,0
    80001fe8:	00000097          	auipc	ra,0x0
    80001fec:	f12080e7          	jalr	-238(ra) # 80001efa <argint>
    return -1;
    80001ff0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80001ff2:	00054963          	bltz	a0,80002004 <sys_exit+0x2a>
  exit(n);
    80001ff6:	fec42503          	lw	a0,-20(s0)
    80001ffa:	fffff097          	auipc	ra,0xfffff
    80001ffe:	76a080e7          	jalr	1898(ra) # 80001764 <exit>
  return 0;  // not reached
    80002002:	4781                	li	a5,0
}
    80002004:	853e                	mv	a0,a5
    80002006:	60e2                	ld	ra,24(sp)
    80002008:	6442                	ld	s0,16(sp)
    8000200a:	6105                	addi	sp,sp,32
    8000200c:	8082                	ret

000000008000200e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000200e:	1141                	addi	sp,sp,-16
    80002010:	e406                	sd	ra,8(sp)
    80002012:	e022                	sd	s0,0(sp)
    80002014:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002016:	fffff097          	auipc	ra,0xfffff
    8000201a:	e2e080e7          	jalr	-466(ra) # 80000e44 <myproc>
}
    8000201e:	5908                	lw	a0,48(a0)
    80002020:	60a2                	ld	ra,8(sp)
    80002022:	6402                	ld	s0,0(sp)
    80002024:	0141                	addi	sp,sp,16
    80002026:	8082                	ret

0000000080002028 <sys_fork>:

uint64
sys_fork(void)
{
    80002028:	1141                	addi	sp,sp,-16
    8000202a:	e406                	sd	ra,8(sp)
    8000202c:	e022                	sd	s0,0(sp)
    8000202e:	0800                	addi	s0,sp,16
  return fork();
    80002030:	fffff097          	auipc	ra,0xfffff
    80002034:	1e6080e7          	jalr	486(ra) # 80001216 <fork>
}
    80002038:	60a2                	ld	ra,8(sp)
    8000203a:	6402                	ld	s0,0(sp)
    8000203c:	0141                	addi	sp,sp,16
    8000203e:	8082                	ret

0000000080002040 <sys_wait>:

uint64
sys_wait(void)
{
    80002040:	1101                	addi	sp,sp,-32
    80002042:	ec06                	sd	ra,24(sp)
    80002044:	e822                	sd	s0,16(sp)
    80002046:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002048:	fe840593          	addi	a1,s0,-24
    8000204c:	4501                	li	a0,0
    8000204e:	00000097          	auipc	ra,0x0
    80002052:	ece080e7          	jalr	-306(ra) # 80001f1c <argaddr>
    80002056:	87aa                	mv	a5,a0
    return -1;
    80002058:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000205a:	0007c863          	bltz	a5,8000206a <sys_wait+0x2a>
  return wait(p);
    8000205e:	fe843503          	ld	a0,-24(s0)
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	50a080e7          	jalr	1290(ra) # 8000156c <wait>
}
    8000206a:	60e2                	ld	ra,24(sp)
    8000206c:	6442                	ld	s0,16(sp)
    8000206e:	6105                	addi	sp,sp,32
    80002070:	8082                	ret

0000000080002072 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002072:	7179                	addi	sp,sp,-48
    80002074:	f406                	sd	ra,40(sp)
    80002076:	f022                	sd	s0,32(sp)
    80002078:	ec26                	sd	s1,24(sp)
    8000207a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000207c:	fdc40593          	addi	a1,s0,-36
    80002080:	4501                	li	a0,0
    80002082:	00000097          	auipc	ra,0x0
    80002086:	e78080e7          	jalr	-392(ra) # 80001efa <argint>
    8000208a:	87aa                	mv	a5,a0
    return -1;
    8000208c:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000208e:	0207c063          	bltz	a5,800020ae <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002092:	fffff097          	auipc	ra,0xfffff
    80002096:	db2080e7          	jalr	-590(ra) # 80000e44 <myproc>
    8000209a:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000209c:	fdc42503          	lw	a0,-36(s0)
    800020a0:	fffff097          	auipc	ra,0xfffff
    800020a4:	0fe080e7          	jalr	254(ra) # 8000119e <growproc>
    800020a8:	00054863          	bltz	a0,800020b8 <sys_sbrk+0x46>
    return -1;
  return addr;
    800020ac:	8526                	mv	a0,s1
}
    800020ae:	70a2                	ld	ra,40(sp)
    800020b0:	7402                	ld	s0,32(sp)
    800020b2:	64e2                	ld	s1,24(sp)
    800020b4:	6145                	addi	sp,sp,48
    800020b6:	8082                	ret
    return -1;
    800020b8:	557d                	li	a0,-1
    800020ba:	bfd5                	j	800020ae <sys_sbrk+0x3c>

00000000800020bc <sys_sleep>:

uint64
sys_sleep(void)
{
    800020bc:	7139                	addi	sp,sp,-64
    800020be:	fc06                	sd	ra,56(sp)
    800020c0:	f822                	sd	s0,48(sp)
    800020c2:	f426                	sd	s1,40(sp)
    800020c4:	f04a                	sd	s2,32(sp)
    800020c6:	ec4e                	sd	s3,24(sp)
    800020c8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800020ca:	fcc40593          	addi	a1,s0,-52
    800020ce:	4501                	li	a0,0
    800020d0:	00000097          	auipc	ra,0x0
    800020d4:	e2a080e7          	jalr	-470(ra) # 80001efa <argint>
    return -1;
    800020d8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020da:	06054563          	bltz	a0,80002144 <sys_sleep+0x88>
  acquire(&tickslock);
    800020de:	0000d517          	auipc	a0,0xd
    800020e2:	da250513          	addi	a0,a0,-606 # 8000ee80 <tickslock>
    800020e6:	00004097          	auipc	ra,0x4
    800020ea:	f32080e7          	jalr	-206(ra) # 80006018 <acquire>
  ticks0 = ticks;
    800020ee:	00007917          	auipc	s2,0x7
    800020f2:	f2a92903          	lw	s2,-214(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800020f6:	fcc42783          	lw	a5,-52(s0)
    800020fa:	cf85                	beqz	a5,80002132 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800020fc:	0000d997          	auipc	s3,0xd
    80002100:	d8498993          	addi	s3,s3,-636 # 8000ee80 <tickslock>
    80002104:	00007497          	auipc	s1,0x7
    80002108:	f1448493          	addi	s1,s1,-236 # 80009018 <ticks>
    if(myproc()->killed){
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	d38080e7          	jalr	-712(ra) # 80000e44 <myproc>
    80002114:	551c                	lw	a5,40(a0)
    80002116:	ef9d                	bnez	a5,80002154 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002118:	85ce                	mv	a1,s3
    8000211a:	8526                	mv	a0,s1
    8000211c:	fffff097          	auipc	ra,0xfffff
    80002120:	3ec080e7          	jalr	1004(ra) # 80001508 <sleep>
  while(ticks - ticks0 < n){
    80002124:	409c                	lw	a5,0(s1)
    80002126:	412787bb          	subw	a5,a5,s2
    8000212a:	fcc42703          	lw	a4,-52(s0)
    8000212e:	fce7efe3          	bltu	a5,a4,8000210c <sys_sleep+0x50>
  }
  release(&tickslock);
    80002132:	0000d517          	auipc	a0,0xd
    80002136:	d4e50513          	addi	a0,a0,-690 # 8000ee80 <tickslock>
    8000213a:	00004097          	auipc	ra,0x4
    8000213e:	f92080e7          	jalr	-110(ra) # 800060cc <release>
  return 0;
    80002142:	4781                	li	a5,0
}
    80002144:	853e                	mv	a0,a5
    80002146:	70e2                	ld	ra,56(sp)
    80002148:	7442                	ld	s0,48(sp)
    8000214a:	74a2                	ld	s1,40(sp)
    8000214c:	7902                	ld	s2,32(sp)
    8000214e:	69e2                	ld	s3,24(sp)
    80002150:	6121                	addi	sp,sp,64
    80002152:	8082                	ret
      release(&tickslock);
    80002154:	0000d517          	auipc	a0,0xd
    80002158:	d2c50513          	addi	a0,a0,-724 # 8000ee80 <tickslock>
    8000215c:	00004097          	auipc	ra,0x4
    80002160:	f70080e7          	jalr	-144(ra) # 800060cc <release>
      return -1;
    80002164:	57fd                	li	a5,-1
    80002166:	bff9                	j	80002144 <sys_sleep+0x88>

0000000080002168 <sys_kill>:

uint64
sys_kill(void)
{
    80002168:	1101                	addi	sp,sp,-32
    8000216a:	ec06                	sd	ra,24(sp)
    8000216c:	e822                	sd	s0,16(sp)
    8000216e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002170:	fec40593          	addi	a1,s0,-20
    80002174:	4501                	li	a0,0
    80002176:	00000097          	auipc	ra,0x0
    8000217a:	d84080e7          	jalr	-636(ra) # 80001efa <argint>
    8000217e:	87aa                	mv	a5,a0
    return -1;
    80002180:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002182:	0007c863          	bltz	a5,80002192 <sys_kill+0x2a>
  return kill(pid);
    80002186:	fec42503          	lw	a0,-20(s0)
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	6b0080e7          	jalr	1712(ra) # 8000183a <kill>
}
    80002192:	60e2                	ld	ra,24(sp)
    80002194:	6442                	ld	s0,16(sp)
    80002196:	6105                	addi	sp,sp,32
    80002198:	8082                	ret

000000008000219a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000219a:	1101                	addi	sp,sp,-32
    8000219c:	ec06                	sd	ra,24(sp)
    8000219e:	e822                	sd	s0,16(sp)
    800021a0:	e426                	sd	s1,8(sp)
    800021a2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021a4:	0000d517          	auipc	a0,0xd
    800021a8:	cdc50513          	addi	a0,a0,-804 # 8000ee80 <tickslock>
    800021ac:	00004097          	auipc	ra,0x4
    800021b0:	e6c080e7          	jalr	-404(ra) # 80006018 <acquire>
  xticks = ticks;
    800021b4:	00007497          	auipc	s1,0x7
    800021b8:	e644a483          	lw	s1,-412(s1) # 80009018 <ticks>
  release(&tickslock);
    800021bc:	0000d517          	auipc	a0,0xd
    800021c0:	cc450513          	addi	a0,a0,-828 # 8000ee80 <tickslock>
    800021c4:	00004097          	auipc	ra,0x4
    800021c8:	f08080e7          	jalr	-248(ra) # 800060cc <release>
  return xticks;
}
    800021cc:	02049513          	slli	a0,s1,0x20
    800021d0:	9101                	srli	a0,a0,0x20
    800021d2:	60e2                	ld	ra,24(sp)
    800021d4:	6442                	ld	s0,16(sp)
    800021d6:	64a2                	ld	s1,8(sp)
    800021d8:	6105                	addi	sp,sp,32
    800021da:	8082                	ret

00000000800021dc <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800021dc:	7179                	addi	sp,sp,-48
    800021de:	f406                	sd	ra,40(sp)
    800021e0:	f022                	sd	s0,32(sp)
    800021e2:	ec26                	sd	s1,24(sp)
    800021e4:	e84a                	sd	s2,16(sp)
    800021e6:	e44e                	sd	s3,8(sp)
    800021e8:	e052                	sd	s4,0(sp)
    800021ea:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800021ec:	00006597          	auipc	a1,0x6
    800021f0:	28c58593          	addi	a1,a1,652 # 80008478 <syscalls+0xb0>
    800021f4:	0000d517          	auipc	a0,0xd
    800021f8:	ca450513          	addi	a0,a0,-860 # 8000ee98 <bcache>
    800021fc:	00004097          	auipc	ra,0x4
    80002200:	d8c080e7          	jalr	-628(ra) # 80005f88 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002204:	00015797          	auipc	a5,0x15
    80002208:	c9478793          	addi	a5,a5,-876 # 80016e98 <bcache+0x8000>
    8000220c:	00015717          	auipc	a4,0x15
    80002210:	ef470713          	addi	a4,a4,-268 # 80017100 <bcache+0x8268>
    80002214:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002218:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000221c:	0000d497          	auipc	s1,0xd
    80002220:	c9448493          	addi	s1,s1,-876 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002224:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002226:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002228:	00006a17          	auipc	s4,0x6
    8000222c:	258a0a13          	addi	s4,s4,600 # 80008480 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002230:	2b893783          	ld	a5,696(s2)
    80002234:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002236:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000223a:	85d2                	mv	a1,s4
    8000223c:	01048513          	addi	a0,s1,16
    80002240:	00001097          	auipc	ra,0x1
    80002244:	4c2080e7          	jalr	1218(ra) # 80003702 <initsleeplock>
    bcache.head.next->prev = b;
    80002248:	2b893783          	ld	a5,696(s2)
    8000224c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000224e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002252:	45848493          	addi	s1,s1,1112
    80002256:	fd349de3          	bne	s1,s3,80002230 <binit+0x54>
  }
}
    8000225a:	70a2                	ld	ra,40(sp)
    8000225c:	7402                	ld	s0,32(sp)
    8000225e:	64e2                	ld	s1,24(sp)
    80002260:	6942                	ld	s2,16(sp)
    80002262:	69a2                	ld	s3,8(sp)
    80002264:	6a02                	ld	s4,0(sp)
    80002266:	6145                	addi	sp,sp,48
    80002268:	8082                	ret

000000008000226a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000226a:	7179                	addi	sp,sp,-48
    8000226c:	f406                	sd	ra,40(sp)
    8000226e:	f022                	sd	s0,32(sp)
    80002270:	ec26                	sd	s1,24(sp)
    80002272:	e84a                	sd	s2,16(sp)
    80002274:	e44e                	sd	s3,8(sp)
    80002276:	1800                	addi	s0,sp,48
    80002278:	892a                	mv	s2,a0
    8000227a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000227c:	0000d517          	auipc	a0,0xd
    80002280:	c1c50513          	addi	a0,a0,-996 # 8000ee98 <bcache>
    80002284:	00004097          	auipc	ra,0x4
    80002288:	d94080e7          	jalr	-620(ra) # 80006018 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000228c:	00015497          	auipc	s1,0x15
    80002290:	ec44b483          	ld	s1,-316(s1) # 80017150 <bcache+0x82b8>
    80002294:	00015797          	auipc	a5,0x15
    80002298:	e6c78793          	addi	a5,a5,-404 # 80017100 <bcache+0x8268>
    8000229c:	02f48f63          	beq	s1,a5,800022da <bread+0x70>
    800022a0:	873e                	mv	a4,a5
    800022a2:	a021                	j	800022aa <bread+0x40>
    800022a4:	68a4                	ld	s1,80(s1)
    800022a6:	02e48a63          	beq	s1,a4,800022da <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022aa:	449c                	lw	a5,8(s1)
    800022ac:	ff279ce3          	bne	a5,s2,800022a4 <bread+0x3a>
    800022b0:	44dc                	lw	a5,12(s1)
    800022b2:	ff3799e3          	bne	a5,s3,800022a4 <bread+0x3a>
      b->refcnt++;
    800022b6:	40bc                	lw	a5,64(s1)
    800022b8:	2785                	addiw	a5,a5,1
    800022ba:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022bc:	0000d517          	auipc	a0,0xd
    800022c0:	bdc50513          	addi	a0,a0,-1060 # 8000ee98 <bcache>
    800022c4:	00004097          	auipc	ra,0x4
    800022c8:	e08080e7          	jalr	-504(ra) # 800060cc <release>
      acquiresleep(&b->lock);
    800022cc:	01048513          	addi	a0,s1,16
    800022d0:	00001097          	auipc	ra,0x1
    800022d4:	46c080e7          	jalr	1132(ra) # 8000373c <acquiresleep>
      return b;
    800022d8:	a8b9                	j	80002336 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022da:	00015497          	auipc	s1,0x15
    800022de:	e6e4b483          	ld	s1,-402(s1) # 80017148 <bcache+0x82b0>
    800022e2:	00015797          	auipc	a5,0x15
    800022e6:	e1e78793          	addi	a5,a5,-482 # 80017100 <bcache+0x8268>
    800022ea:	00f48863          	beq	s1,a5,800022fa <bread+0x90>
    800022ee:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800022f0:	40bc                	lw	a5,64(s1)
    800022f2:	cf81                	beqz	a5,8000230a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022f4:	64a4                	ld	s1,72(s1)
    800022f6:	fee49de3          	bne	s1,a4,800022f0 <bread+0x86>
  panic("bget: no buffers");
    800022fa:	00006517          	auipc	a0,0x6
    800022fe:	18e50513          	addi	a0,a0,398 # 80008488 <syscalls+0xc0>
    80002302:	00003097          	auipc	ra,0x3
    80002306:	7de080e7          	jalr	2014(ra) # 80005ae0 <panic>
      b->dev = dev;
    8000230a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000230e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002312:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002316:	4785                	li	a5,1
    80002318:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000231a:	0000d517          	auipc	a0,0xd
    8000231e:	b7e50513          	addi	a0,a0,-1154 # 8000ee98 <bcache>
    80002322:	00004097          	auipc	ra,0x4
    80002326:	daa080e7          	jalr	-598(ra) # 800060cc <release>
      acquiresleep(&b->lock);
    8000232a:	01048513          	addi	a0,s1,16
    8000232e:	00001097          	auipc	ra,0x1
    80002332:	40e080e7          	jalr	1038(ra) # 8000373c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002336:	409c                	lw	a5,0(s1)
    80002338:	cb89                	beqz	a5,8000234a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000233a:	8526                	mv	a0,s1
    8000233c:	70a2                	ld	ra,40(sp)
    8000233e:	7402                	ld	s0,32(sp)
    80002340:	64e2                	ld	s1,24(sp)
    80002342:	6942                	ld	s2,16(sp)
    80002344:	69a2                	ld	s3,8(sp)
    80002346:	6145                	addi	sp,sp,48
    80002348:	8082                	ret
    virtio_disk_rw(b, 0);
    8000234a:	4581                	li	a1,0
    8000234c:	8526                	mv	a0,s1
    8000234e:	00003097          	auipc	ra,0x3
    80002352:	f24080e7          	jalr	-220(ra) # 80005272 <virtio_disk_rw>
    b->valid = 1;
    80002356:	4785                	li	a5,1
    80002358:	c09c                	sw	a5,0(s1)
  return b;
    8000235a:	b7c5                	j	8000233a <bread+0xd0>

000000008000235c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000235c:	1101                	addi	sp,sp,-32
    8000235e:	ec06                	sd	ra,24(sp)
    80002360:	e822                	sd	s0,16(sp)
    80002362:	e426                	sd	s1,8(sp)
    80002364:	1000                	addi	s0,sp,32
    80002366:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002368:	0541                	addi	a0,a0,16
    8000236a:	00001097          	auipc	ra,0x1
    8000236e:	46c080e7          	jalr	1132(ra) # 800037d6 <holdingsleep>
    80002372:	cd01                	beqz	a0,8000238a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002374:	4585                	li	a1,1
    80002376:	8526                	mv	a0,s1
    80002378:	00003097          	auipc	ra,0x3
    8000237c:	efa080e7          	jalr	-262(ra) # 80005272 <virtio_disk_rw>
}
    80002380:	60e2                	ld	ra,24(sp)
    80002382:	6442                	ld	s0,16(sp)
    80002384:	64a2                	ld	s1,8(sp)
    80002386:	6105                	addi	sp,sp,32
    80002388:	8082                	ret
    panic("bwrite");
    8000238a:	00006517          	auipc	a0,0x6
    8000238e:	11650513          	addi	a0,a0,278 # 800084a0 <syscalls+0xd8>
    80002392:	00003097          	auipc	ra,0x3
    80002396:	74e080e7          	jalr	1870(ra) # 80005ae0 <panic>

000000008000239a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000239a:	1101                	addi	sp,sp,-32
    8000239c:	ec06                	sd	ra,24(sp)
    8000239e:	e822                	sd	s0,16(sp)
    800023a0:	e426                	sd	s1,8(sp)
    800023a2:	e04a                	sd	s2,0(sp)
    800023a4:	1000                	addi	s0,sp,32
    800023a6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023a8:	01050913          	addi	s2,a0,16
    800023ac:	854a                	mv	a0,s2
    800023ae:	00001097          	auipc	ra,0x1
    800023b2:	428080e7          	jalr	1064(ra) # 800037d6 <holdingsleep>
    800023b6:	c92d                	beqz	a0,80002428 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800023b8:	854a                	mv	a0,s2
    800023ba:	00001097          	auipc	ra,0x1
    800023be:	3d8080e7          	jalr	984(ra) # 80003792 <releasesleep>

  acquire(&bcache.lock);
    800023c2:	0000d517          	auipc	a0,0xd
    800023c6:	ad650513          	addi	a0,a0,-1322 # 8000ee98 <bcache>
    800023ca:	00004097          	auipc	ra,0x4
    800023ce:	c4e080e7          	jalr	-946(ra) # 80006018 <acquire>
  b->refcnt--;
    800023d2:	40bc                	lw	a5,64(s1)
    800023d4:	37fd                	addiw	a5,a5,-1
    800023d6:	0007871b          	sext.w	a4,a5
    800023da:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800023dc:	eb05                	bnez	a4,8000240c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800023de:	68bc                	ld	a5,80(s1)
    800023e0:	64b8                	ld	a4,72(s1)
    800023e2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800023e4:	64bc                	ld	a5,72(s1)
    800023e6:	68b8                	ld	a4,80(s1)
    800023e8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800023ea:	00015797          	auipc	a5,0x15
    800023ee:	aae78793          	addi	a5,a5,-1362 # 80016e98 <bcache+0x8000>
    800023f2:	2b87b703          	ld	a4,696(a5)
    800023f6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800023f8:	00015717          	auipc	a4,0x15
    800023fc:	d0870713          	addi	a4,a4,-760 # 80017100 <bcache+0x8268>
    80002400:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002402:	2b87b703          	ld	a4,696(a5)
    80002406:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002408:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000240c:	0000d517          	auipc	a0,0xd
    80002410:	a8c50513          	addi	a0,a0,-1396 # 8000ee98 <bcache>
    80002414:	00004097          	auipc	ra,0x4
    80002418:	cb8080e7          	jalr	-840(ra) # 800060cc <release>
}
    8000241c:	60e2                	ld	ra,24(sp)
    8000241e:	6442                	ld	s0,16(sp)
    80002420:	64a2                	ld	s1,8(sp)
    80002422:	6902                	ld	s2,0(sp)
    80002424:	6105                	addi	sp,sp,32
    80002426:	8082                	ret
    panic("brelse");
    80002428:	00006517          	auipc	a0,0x6
    8000242c:	08050513          	addi	a0,a0,128 # 800084a8 <syscalls+0xe0>
    80002430:	00003097          	auipc	ra,0x3
    80002434:	6b0080e7          	jalr	1712(ra) # 80005ae0 <panic>

0000000080002438 <bpin>:

void
bpin(struct buf *b) {
    80002438:	1101                	addi	sp,sp,-32
    8000243a:	ec06                	sd	ra,24(sp)
    8000243c:	e822                	sd	s0,16(sp)
    8000243e:	e426                	sd	s1,8(sp)
    80002440:	1000                	addi	s0,sp,32
    80002442:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002444:	0000d517          	auipc	a0,0xd
    80002448:	a5450513          	addi	a0,a0,-1452 # 8000ee98 <bcache>
    8000244c:	00004097          	auipc	ra,0x4
    80002450:	bcc080e7          	jalr	-1076(ra) # 80006018 <acquire>
  b->refcnt++;
    80002454:	40bc                	lw	a5,64(s1)
    80002456:	2785                	addiw	a5,a5,1
    80002458:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000245a:	0000d517          	auipc	a0,0xd
    8000245e:	a3e50513          	addi	a0,a0,-1474 # 8000ee98 <bcache>
    80002462:	00004097          	auipc	ra,0x4
    80002466:	c6a080e7          	jalr	-918(ra) # 800060cc <release>
}
    8000246a:	60e2                	ld	ra,24(sp)
    8000246c:	6442                	ld	s0,16(sp)
    8000246e:	64a2                	ld	s1,8(sp)
    80002470:	6105                	addi	sp,sp,32
    80002472:	8082                	ret

0000000080002474 <bunpin>:

void
bunpin(struct buf *b) {
    80002474:	1101                	addi	sp,sp,-32
    80002476:	ec06                	sd	ra,24(sp)
    80002478:	e822                	sd	s0,16(sp)
    8000247a:	e426                	sd	s1,8(sp)
    8000247c:	1000                	addi	s0,sp,32
    8000247e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002480:	0000d517          	auipc	a0,0xd
    80002484:	a1850513          	addi	a0,a0,-1512 # 8000ee98 <bcache>
    80002488:	00004097          	auipc	ra,0x4
    8000248c:	b90080e7          	jalr	-1136(ra) # 80006018 <acquire>
  b->refcnt--;
    80002490:	40bc                	lw	a5,64(s1)
    80002492:	37fd                	addiw	a5,a5,-1
    80002494:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002496:	0000d517          	auipc	a0,0xd
    8000249a:	a0250513          	addi	a0,a0,-1534 # 8000ee98 <bcache>
    8000249e:	00004097          	auipc	ra,0x4
    800024a2:	c2e080e7          	jalr	-978(ra) # 800060cc <release>
}
    800024a6:	60e2                	ld	ra,24(sp)
    800024a8:	6442                	ld	s0,16(sp)
    800024aa:	64a2                	ld	s1,8(sp)
    800024ac:	6105                	addi	sp,sp,32
    800024ae:	8082                	ret

00000000800024b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024b0:	1101                	addi	sp,sp,-32
    800024b2:	ec06                	sd	ra,24(sp)
    800024b4:	e822                	sd	s0,16(sp)
    800024b6:	e426                	sd	s1,8(sp)
    800024b8:	e04a                	sd	s2,0(sp)
    800024ba:	1000                	addi	s0,sp,32
    800024bc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024be:	00d5d59b          	srliw	a1,a1,0xd
    800024c2:	00015797          	auipc	a5,0x15
    800024c6:	0b27a783          	lw	a5,178(a5) # 80017574 <sb+0x1c>
    800024ca:	9dbd                	addw	a1,a1,a5
    800024cc:	00000097          	auipc	ra,0x0
    800024d0:	d9e080e7          	jalr	-610(ra) # 8000226a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024d4:	0074f713          	andi	a4,s1,7
    800024d8:	4785                	li	a5,1
    800024da:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800024de:	14ce                	slli	s1,s1,0x33
    800024e0:	90d9                	srli	s1,s1,0x36
    800024e2:	00950733          	add	a4,a0,s1
    800024e6:	05874703          	lbu	a4,88(a4)
    800024ea:	00e7f6b3          	and	a3,a5,a4
    800024ee:	c69d                	beqz	a3,8000251c <bfree+0x6c>
    800024f0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800024f2:	94aa                	add	s1,s1,a0
    800024f4:	fff7c793          	not	a5,a5
    800024f8:	8f7d                	and	a4,a4,a5
    800024fa:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800024fe:	00001097          	auipc	ra,0x1
    80002502:	120080e7          	jalr	288(ra) # 8000361e <log_write>
  brelse(bp);
    80002506:	854a                	mv	a0,s2
    80002508:	00000097          	auipc	ra,0x0
    8000250c:	e92080e7          	jalr	-366(ra) # 8000239a <brelse>
}
    80002510:	60e2                	ld	ra,24(sp)
    80002512:	6442                	ld	s0,16(sp)
    80002514:	64a2                	ld	s1,8(sp)
    80002516:	6902                	ld	s2,0(sp)
    80002518:	6105                	addi	sp,sp,32
    8000251a:	8082                	ret
    panic("freeing free block");
    8000251c:	00006517          	auipc	a0,0x6
    80002520:	f9450513          	addi	a0,a0,-108 # 800084b0 <syscalls+0xe8>
    80002524:	00003097          	auipc	ra,0x3
    80002528:	5bc080e7          	jalr	1468(ra) # 80005ae0 <panic>

000000008000252c <balloc>:
{
    8000252c:	711d                	addi	sp,sp,-96
    8000252e:	ec86                	sd	ra,88(sp)
    80002530:	e8a2                	sd	s0,80(sp)
    80002532:	e4a6                	sd	s1,72(sp)
    80002534:	e0ca                	sd	s2,64(sp)
    80002536:	fc4e                	sd	s3,56(sp)
    80002538:	f852                	sd	s4,48(sp)
    8000253a:	f456                	sd	s5,40(sp)
    8000253c:	f05a                	sd	s6,32(sp)
    8000253e:	ec5e                	sd	s7,24(sp)
    80002540:	e862                	sd	s8,16(sp)
    80002542:	e466                	sd	s9,8(sp)
    80002544:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002546:	00015797          	auipc	a5,0x15
    8000254a:	0167a783          	lw	a5,22(a5) # 8001755c <sb+0x4>
    8000254e:	cbc1                	beqz	a5,800025de <balloc+0xb2>
    80002550:	8baa                	mv	s7,a0
    80002552:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002554:	00015b17          	auipc	s6,0x15
    80002558:	004b0b13          	addi	s6,s6,4 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000255c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000255e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002560:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002562:	6c89                	lui	s9,0x2
    80002564:	a831                	j	80002580 <balloc+0x54>
    brelse(bp);
    80002566:	854a                	mv	a0,s2
    80002568:	00000097          	auipc	ra,0x0
    8000256c:	e32080e7          	jalr	-462(ra) # 8000239a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002570:	015c87bb          	addw	a5,s9,s5
    80002574:	00078a9b          	sext.w	s5,a5
    80002578:	004b2703          	lw	a4,4(s6)
    8000257c:	06eaf163          	bgeu	s5,a4,800025de <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002580:	41fad79b          	sraiw	a5,s5,0x1f
    80002584:	0137d79b          	srliw	a5,a5,0x13
    80002588:	015787bb          	addw	a5,a5,s5
    8000258c:	40d7d79b          	sraiw	a5,a5,0xd
    80002590:	01cb2583          	lw	a1,28(s6)
    80002594:	9dbd                	addw	a1,a1,a5
    80002596:	855e                	mv	a0,s7
    80002598:	00000097          	auipc	ra,0x0
    8000259c:	cd2080e7          	jalr	-814(ra) # 8000226a <bread>
    800025a0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025a2:	004b2503          	lw	a0,4(s6)
    800025a6:	000a849b          	sext.w	s1,s5
    800025aa:	8762                	mv	a4,s8
    800025ac:	faa4fde3          	bgeu	s1,a0,80002566 <balloc+0x3a>
      m = 1 << (bi % 8);
    800025b0:	00777693          	andi	a3,a4,7
    800025b4:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800025b8:	41f7579b          	sraiw	a5,a4,0x1f
    800025bc:	01d7d79b          	srliw	a5,a5,0x1d
    800025c0:	9fb9                	addw	a5,a5,a4
    800025c2:	4037d79b          	sraiw	a5,a5,0x3
    800025c6:	00f90633          	add	a2,s2,a5
    800025ca:	05864603          	lbu	a2,88(a2)
    800025ce:	00c6f5b3          	and	a1,a3,a2
    800025d2:	cd91                	beqz	a1,800025ee <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025d4:	2705                	addiw	a4,a4,1
    800025d6:	2485                	addiw	s1,s1,1
    800025d8:	fd471ae3          	bne	a4,s4,800025ac <balloc+0x80>
    800025dc:	b769                	j	80002566 <balloc+0x3a>
  panic("balloc: out of blocks");
    800025de:	00006517          	auipc	a0,0x6
    800025e2:	eea50513          	addi	a0,a0,-278 # 800084c8 <syscalls+0x100>
    800025e6:	00003097          	auipc	ra,0x3
    800025ea:	4fa080e7          	jalr	1274(ra) # 80005ae0 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025ee:	97ca                	add	a5,a5,s2
    800025f0:	8e55                	or	a2,a2,a3
    800025f2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800025f6:	854a                	mv	a0,s2
    800025f8:	00001097          	auipc	ra,0x1
    800025fc:	026080e7          	jalr	38(ra) # 8000361e <log_write>
        brelse(bp);
    80002600:	854a                	mv	a0,s2
    80002602:	00000097          	auipc	ra,0x0
    80002606:	d98080e7          	jalr	-616(ra) # 8000239a <brelse>
  bp = bread(dev, bno);
    8000260a:	85a6                	mv	a1,s1
    8000260c:	855e                	mv	a0,s7
    8000260e:	00000097          	auipc	ra,0x0
    80002612:	c5c080e7          	jalr	-932(ra) # 8000226a <bread>
    80002616:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002618:	40000613          	li	a2,1024
    8000261c:	4581                	li	a1,0
    8000261e:	05850513          	addi	a0,a0,88
    80002622:	ffffe097          	auipc	ra,0xffffe
    80002626:	b58080e7          	jalr	-1192(ra) # 8000017a <memset>
  log_write(bp);
    8000262a:	854a                	mv	a0,s2
    8000262c:	00001097          	auipc	ra,0x1
    80002630:	ff2080e7          	jalr	-14(ra) # 8000361e <log_write>
  brelse(bp);
    80002634:	854a                	mv	a0,s2
    80002636:	00000097          	auipc	ra,0x0
    8000263a:	d64080e7          	jalr	-668(ra) # 8000239a <brelse>
}
    8000263e:	8526                	mv	a0,s1
    80002640:	60e6                	ld	ra,88(sp)
    80002642:	6446                	ld	s0,80(sp)
    80002644:	64a6                	ld	s1,72(sp)
    80002646:	6906                	ld	s2,64(sp)
    80002648:	79e2                	ld	s3,56(sp)
    8000264a:	7a42                	ld	s4,48(sp)
    8000264c:	7aa2                	ld	s5,40(sp)
    8000264e:	7b02                	ld	s6,32(sp)
    80002650:	6be2                	ld	s7,24(sp)
    80002652:	6c42                	ld	s8,16(sp)
    80002654:	6ca2                	ld	s9,8(sp)
    80002656:	6125                	addi	sp,sp,96
    80002658:	8082                	ret

000000008000265a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000265a:	7179                	addi	sp,sp,-48
    8000265c:	f406                	sd	ra,40(sp)
    8000265e:	f022                	sd	s0,32(sp)
    80002660:	ec26                	sd	s1,24(sp)
    80002662:	e84a                	sd	s2,16(sp)
    80002664:	e44e                	sd	s3,8(sp)
    80002666:	e052                	sd	s4,0(sp)
    80002668:	1800                	addi	s0,sp,48
    8000266a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000266c:	47ad                	li	a5,11
    8000266e:	04b7fe63          	bgeu	a5,a1,800026ca <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002672:	ff45849b          	addiw	s1,a1,-12
    80002676:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000267a:	0ff00793          	li	a5,255
    8000267e:	0ae7e463          	bltu	a5,a4,80002726 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002682:	08052583          	lw	a1,128(a0)
    80002686:	c5b5                	beqz	a1,800026f2 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002688:	00092503          	lw	a0,0(s2)
    8000268c:	00000097          	auipc	ra,0x0
    80002690:	bde080e7          	jalr	-1058(ra) # 8000226a <bread>
    80002694:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002696:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000269a:	02049713          	slli	a4,s1,0x20
    8000269e:	01e75593          	srli	a1,a4,0x1e
    800026a2:	00b784b3          	add	s1,a5,a1
    800026a6:	0004a983          	lw	s3,0(s1)
    800026aa:	04098e63          	beqz	s3,80002706 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026ae:	8552                	mv	a0,s4
    800026b0:	00000097          	auipc	ra,0x0
    800026b4:	cea080e7          	jalr	-790(ra) # 8000239a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800026b8:	854e                	mv	a0,s3
    800026ba:	70a2                	ld	ra,40(sp)
    800026bc:	7402                	ld	s0,32(sp)
    800026be:	64e2                	ld	s1,24(sp)
    800026c0:	6942                	ld	s2,16(sp)
    800026c2:	69a2                	ld	s3,8(sp)
    800026c4:	6a02                	ld	s4,0(sp)
    800026c6:	6145                	addi	sp,sp,48
    800026c8:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800026ca:	02059793          	slli	a5,a1,0x20
    800026ce:	01e7d593          	srli	a1,a5,0x1e
    800026d2:	00b504b3          	add	s1,a0,a1
    800026d6:	0504a983          	lw	s3,80(s1)
    800026da:	fc099fe3          	bnez	s3,800026b8 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800026de:	4108                	lw	a0,0(a0)
    800026e0:	00000097          	auipc	ra,0x0
    800026e4:	e4c080e7          	jalr	-436(ra) # 8000252c <balloc>
    800026e8:	0005099b          	sext.w	s3,a0
    800026ec:	0534a823          	sw	s3,80(s1)
    800026f0:	b7e1                	j	800026b8 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800026f2:	4108                	lw	a0,0(a0)
    800026f4:	00000097          	auipc	ra,0x0
    800026f8:	e38080e7          	jalr	-456(ra) # 8000252c <balloc>
    800026fc:	0005059b          	sext.w	a1,a0
    80002700:	08b92023          	sw	a1,128(s2)
    80002704:	b751                	j	80002688 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002706:	00092503          	lw	a0,0(s2)
    8000270a:	00000097          	auipc	ra,0x0
    8000270e:	e22080e7          	jalr	-478(ra) # 8000252c <balloc>
    80002712:	0005099b          	sext.w	s3,a0
    80002716:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000271a:	8552                	mv	a0,s4
    8000271c:	00001097          	auipc	ra,0x1
    80002720:	f02080e7          	jalr	-254(ra) # 8000361e <log_write>
    80002724:	b769                	j	800026ae <bmap+0x54>
  panic("bmap: out of range");
    80002726:	00006517          	auipc	a0,0x6
    8000272a:	dba50513          	addi	a0,a0,-582 # 800084e0 <syscalls+0x118>
    8000272e:	00003097          	auipc	ra,0x3
    80002732:	3b2080e7          	jalr	946(ra) # 80005ae0 <panic>

0000000080002736 <iget>:
{
    80002736:	7179                	addi	sp,sp,-48
    80002738:	f406                	sd	ra,40(sp)
    8000273a:	f022                	sd	s0,32(sp)
    8000273c:	ec26                	sd	s1,24(sp)
    8000273e:	e84a                	sd	s2,16(sp)
    80002740:	e44e                	sd	s3,8(sp)
    80002742:	e052                	sd	s4,0(sp)
    80002744:	1800                	addi	s0,sp,48
    80002746:	89aa                	mv	s3,a0
    80002748:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000274a:	00015517          	auipc	a0,0x15
    8000274e:	e2e50513          	addi	a0,a0,-466 # 80017578 <itable>
    80002752:	00004097          	auipc	ra,0x4
    80002756:	8c6080e7          	jalr	-1850(ra) # 80006018 <acquire>
  empty = 0;
    8000275a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000275c:	00015497          	auipc	s1,0x15
    80002760:	e3448493          	addi	s1,s1,-460 # 80017590 <itable+0x18>
    80002764:	00017697          	auipc	a3,0x17
    80002768:	8bc68693          	addi	a3,a3,-1860 # 80019020 <log>
    8000276c:	a039                	j	8000277a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000276e:	02090b63          	beqz	s2,800027a4 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002772:	08848493          	addi	s1,s1,136
    80002776:	02d48a63          	beq	s1,a3,800027aa <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000277a:	449c                	lw	a5,8(s1)
    8000277c:	fef059e3          	blez	a5,8000276e <iget+0x38>
    80002780:	4098                	lw	a4,0(s1)
    80002782:	ff3716e3          	bne	a4,s3,8000276e <iget+0x38>
    80002786:	40d8                	lw	a4,4(s1)
    80002788:	ff4713e3          	bne	a4,s4,8000276e <iget+0x38>
      ip->ref++;
    8000278c:	2785                	addiw	a5,a5,1
    8000278e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002790:	00015517          	auipc	a0,0x15
    80002794:	de850513          	addi	a0,a0,-536 # 80017578 <itable>
    80002798:	00004097          	auipc	ra,0x4
    8000279c:	934080e7          	jalr	-1740(ra) # 800060cc <release>
      return ip;
    800027a0:	8926                	mv	s2,s1
    800027a2:	a03d                	j	800027d0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027a4:	f7f9                	bnez	a5,80002772 <iget+0x3c>
    800027a6:	8926                	mv	s2,s1
    800027a8:	b7e9                	j	80002772 <iget+0x3c>
  if(empty == 0)
    800027aa:	02090c63          	beqz	s2,800027e2 <iget+0xac>
  ip->dev = dev;
    800027ae:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800027b2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800027b6:	4785                	li	a5,1
    800027b8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800027bc:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800027c0:	00015517          	auipc	a0,0x15
    800027c4:	db850513          	addi	a0,a0,-584 # 80017578 <itable>
    800027c8:	00004097          	auipc	ra,0x4
    800027cc:	904080e7          	jalr	-1788(ra) # 800060cc <release>
}
    800027d0:	854a                	mv	a0,s2
    800027d2:	70a2                	ld	ra,40(sp)
    800027d4:	7402                	ld	s0,32(sp)
    800027d6:	64e2                	ld	s1,24(sp)
    800027d8:	6942                	ld	s2,16(sp)
    800027da:	69a2                	ld	s3,8(sp)
    800027dc:	6a02                	ld	s4,0(sp)
    800027de:	6145                	addi	sp,sp,48
    800027e0:	8082                	ret
    panic("iget: no inodes");
    800027e2:	00006517          	auipc	a0,0x6
    800027e6:	d1650513          	addi	a0,a0,-746 # 800084f8 <syscalls+0x130>
    800027ea:	00003097          	auipc	ra,0x3
    800027ee:	2f6080e7          	jalr	758(ra) # 80005ae0 <panic>

00000000800027f2 <fsinit>:
fsinit(int dev) {
    800027f2:	7179                	addi	sp,sp,-48
    800027f4:	f406                	sd	ra,40(sp)
    800027f6:	f022                	sd	s0,32(sp)
    800027f8:	ec26                	sd	s1,24(sp)
    800027fa:	e84a                	sd	s2,16(sp)
    800027fc:	e44e                	sd	s3,8(sp)
    800027fe:	1800                	addi	s0,sp,48
    80002800:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002802:	4585                	li	a1,1
    80002804:	00000097          	auipc	ra,0x0
    80002808:	a66080e7          	jalr	-1434(ra) # 8000226a <bread>
    8000280c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000280e:	00015997          	auipc	s3,0x15
    80002812:	d4a98993          	addi	s3,s3,-694 # 80017558 <sb>
    80002816:	02000613          	li	a2,32
    8000281a:	05850593          	addi	a1,a0,88
    8000281e:	854e                	mv	a0,s3
    80002820:	ffffe097          	auipc	ra,0xffffe
    80002824:	9b6080e7          	jalr	-1610(ra) # 800001d6 <memmove>
  brelse(bp);
    80002828:	8526                	mv	a0,s1
    8000282a:	00000097          	auipc	ra,0x0
    8000282e:	b70080e7          	jalr	-1168(ra) # 8000239a <brelse>
  if(sb.magic != FSMAGIC)
    80002832:	0009a703          	lw	a4,0(s3)
    80002836:	102037b7          	lui	a5,0x10203
    8000283a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000283e:	02f71263          	bne	a4,a5,80002862 <fsinit+0x70>
  initlog(dev, &sb);
    80002842:	00015597          	auipc	a1,0x15
    80002846:	d1658593          	addi	a1,a1,-746 # 80017558 <sb>
    8000284a:	854a                	mv	a0,s2
    8000284c:	00001097          	auipc	ra,0x1
    80002850:	b56080e7          	jalr	-1194(ra) # 800033a2 <initlog>
}
    80002854:	70a2                	ld	ra,40(sp)
    80002856:	7402                	ld	s0,32(sp)
    80002858:	64e2                	ld	s1,24(sp)
    8000285a:	6942                	ld	s2,16(sp)
    8000285c:	69a2                	ld	s3,8(sp)
    8000285e:	6145                	addi	sp,sp,48
    80002860:	8082                	ret
    panic("invalid file system");
    80002862:	00006517          	auipc	a0,0x6
    80002866:	ca650513          	addi	a0,a0,-858 # 80008508 <syscalls+0x140>
    8000286a:	00003097          	auipc	ra,0x3
    8000286e:	276080e7          	jalr	630(ra) # 80005ae0 <panic>

0000000080002872 <iinit>:
{
    80002872:	7179                	addi	sp,sp,-48
    80002874:	f406                	sd	ra,40(sp)
    80002876:	f022                	sd	s0,32(sp)
    80002878:	ec26                	sd	s1,24(sp)
    8000287a:	e84a                	sd	s2,16(sp)
    8000287c:	e44e                	sd	s3,8(sp)
    8000287e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002880:	00006597          	auipc	a1,0x6
    80002884:	ca058593          	addi	a1,a1,-864 # 80008520 <syscalls+0x158>
    80002888:	00015517          	auipc	a0,0x15
    8000288c:	cf050513          	addi	a0,a0,-784 # 80017578 <itable>
    80002890:	00003097          	auipc	ra,0x3
    80002894:	6f8080e7          	jalr	1784(ra) # 80005f88 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002898:	00015497          	auipc	s1,0x15
    8000289c:	d0848493          	addi	s1,s1,-760 # 800175a0 <itable+0x28>
    800028a0:	00016997          	auipc	s3,0x16
    800028a4:	79098993          	addi	s3,s3,1936 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800028a8:	00006917          	auipc	s2,0x6
    800028ac:	c8090913          	addi	s2,s2,-896 # 80008528 <syscalls+0x160>
    800028b0:	85ca                	mv	a1,s2
    800028b2:	8526                	mv	a0,s1
    800028b4:	00001097          	auipc	ra,0x1
    800028b8:	e4e080e7          	jalr	-434(ra) # 80003702 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800028bc:	08848493          	addi	s1,s1,136
    800028c0:	ff3498e3          	bne	s1,s3,800028b0 <iinit+0x3e>
}
    800028c4:	70a2                	ld	ra,40(sp)
    800028c6:	7402                	ld	s0,32(sp)
    800028c8:	64e2                	ld	s1,24(sp)
    800028ca:	6942                	ld	s2,16(sp)
    800028cc:	69a2                	ld	s3,8(sp)
    800028ce:	6145                	addi	sp,sp,48
    800028d0:	8082                	ret

00000000800028d2 <ialloc>:
{
    800028d2:	715d                	addi	sp,sp,-80
    800028d4:	e486                	sd	ra,72(sp)
    800028d6:	e0a2                	sd	s0,64(sp)
    800028d8:	fc26                	sd	s1,56(sp)
    800028da:	f84a                	sd	s2,48(sp)
    800028dc:	f44e                	sd	s3,40(sp)
    800028de:	f052                	sd	s4,32(sp)
    800028e0:	ec56                	sd	s5,24(sp)
    800028e2:	e85a                	sd	s6,16(sp)
    800028e4:	e45e                	sd	s7,8(sp)
    800028e6:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800028e8:	00015717          	auipc	a4,0x15
    800028ec:	c7c72703          	lw	a4,-900(a4) # 80017564 <sb+0xc>
    800028f0:	4785                	li	a5,1
    800028f2:	04e7fa63          	bgeu	a5,a4,80002946 <ialloc+0x74>
    800028f6:	8aaa                	mv	s5,a0
    800028f8:	8bae                	mv	s7,a1
    800028fa:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800028fc:	00015a17          	auipc	s4,0x15
    80002900:	c5ca0a13          	addi	s4,s4,-932 # 80017558 <sb>
    80002904:	00048b1b          	sext.w	s6,s1
    80002908:	0044d593          	srli	a1,s1,0x4
    8000290c:	018a2783          	lw	a5,24(s4)
    80002910:	9dbd                	addw	a1,a1,a5
    80002912:	8556                	mv	a0,s5
    80002914:	00000097          	auipc	ra,0x0
    80002918:	956080e7          	jalr	-1706(ra) # 8000226a <bread>
    8000291c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000291e:	05850993          	addi	s3,a0,88
    80002922:	00f4f793          	andi	a5,s1,15
    80002926:	079a                	slli	a5,a5,0x6
    80002928:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000292a:	00099783          	lh	a5,0(s3)
    8000292e:	c785                	beqz	a5,80002956 <ialloc+0x84>
    brelse(bp);
    80002930:	00000097          	auipc	ra,0x0
    80002934:	a6a080e7          	jalr	-1430(ra) # 8000239a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002938:	0485                	addi	s1,s1,1
    8000293a:	00ca2703          	lw	a4,12(s4)
    8000293e:	0004879b          	sext.w	a5,s1
    80002942:	fce7e1e3          	bltu	a5,a4,80002904 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002946:	00006517          	auipc	a0,0x6
    8000294a:	bea50513          	addi	a0,a0,-1046 # 80008530 <syscalls+0x168>
    8000294e:	00003097          	auipc	ra,0x3
    80002952:	192080e7          	jalr	402(ra) # 80005ae0 <panic>
      memset(dip, 0, sizeof(*dip));
    80002956:	04000613          	li	a2,64
    8000295a:	4581                	li	a1,0
    8000295c:	854e                	mv	a0,s3
    8000295e:	ffffe097          	auipc	ra,0xffffe
    80002962:	81c080e7          	jalr	-2020(ra) # 8000017a <memset>
      dip->type = type;
    80002966:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000296a:	854a                	mv	a0,s2
    8000296c:	00001097          	auipc	ra,0x1
    80002970:	cb2080e7          	jalr	-846(ra) # 8000361e <log_write>
      brelse(bp);
    80002974:	854a                	mv	a0,s2
    80002976:	00000097          	auipc	ra,0x0
    8000297a:	a24080e7          	jalr	-1500(ra) # 8000239a <brelse>
      return iget(dev, inum);
    8000297e:	85da                	mv	a1,s6
    80002980:	8556                	mv	a0,s5
    80002982:	00000097          	auipc	ra,0x0
    80002986:	db4080e7          	jalr	-588(ra) # 80002736 <iget>
}
    8000298a:	60a6                	ld	ra,72(sp)
    8000298c:	6406                	ld	s0,64(sp)
    8000298e:	74e2                	ld	s1,56(sp)
    80002990:	7942                	ld	s2,48(sp)
    80002992:	79a2                	ld	s3,40(sp)
    80002994:	7a02                	ld	s4,32(sp)
    80002996:	6ae2                	ld	s5,24(sp)
    80002998:	6b42                	ld	s6,16(sp)
    8000299a:	6ba2                	ld	s7,8(sp)
    8000299c:	6161                	addi	sp,sp,80
    8000299e:	8082                	ret

00000000800029a0 <iupdate>:
{
    800029a0:	1101                	addi	sp,sp,-32
    800029a2:	ec06                	sd	ra,24(sp)
    800029a4:	e822                	sd	s0,16(sp)
    800029a6:	e426                	sd	s1,8(sp)
    800029a8:	e04a                	sd	s2,0(sp)
    800029aa:	1000                	addi	s0,sp,32
    800029ac:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800029ae:	415c                	lw	a5,4(a0)
    800029b0:	0047d79b          	srliw	a5,a5,0x4
    800029b4:	00015597          	auipc	a1,0x15
    800029b8:	bbc5a583          	lw	a1,-1092(a1) # 80017570 <sb+0x18>
    800029bc:	9dbd                	addw	a1,a1,a5
    800029be:	4108                	lw	a0,0(a0)
    800029c0:	00000097          	auipc	ra,0x0
    800029c4:	8aa080e7          	jalr	-1878(ra) # 8000226a <bread>
    800029c8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800029ca:	05850793          	addi	a5,a0,88
    800029ce:	40d8                	lw	a4,4(s1)
    800029d0:	8b3d                	andi	a4,a4,15
    800029d2:	071a                	slli	a4,a4,0x6
    800029d4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800029d6:	04449703          	lh	a4,68(s1)
    800029da:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800029de:	04649703          	lh	a4,70(s1)
    800029e2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800029e6:	04849703          	lh	a4,72(s1)
    800029ea:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800029ee:	04a49703          	lh	a4,74(s1)
    800029f2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800029f6:	44f8                	lw	a4,76(s1)
    800029f8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800029fa:	03400613          	li	a2,52
    800029fe:	05048593          	addi	a1,s1,80
    80002a02:	00c78513          	addi	a0,a5,12
    80002a06:	ffffd097          	auipc	ra,0xffffd
    80002a0a:	7d0080e7          	jalr	2000(ra) # 800001d6 <memmove>
  log_write(bp);
    80002a0e:	854a                	mv	a0,s2
    80002a10:	00001097          	auipc	ra,0x1
    80002a14:	c0e080e7          	jalr	-1010(ra) # 8000361e <log_write>
  brelse(bp);
    80002a18:	854a                	mv	a0,s2
    80002a1a:	00000097          	auipc	ra,0x0
    80002a1e:	980080e7          	jalr	-1664(ra) # 8000239a <brelse>
}
    80002a22:	60e2                	ld	ra,24(sp)
    80002a24:	6442                	ld	s0,16(sp)
    80002a26:	64a2                	ld	s1,8(sp)
    80002a28:	6902                	ld	s2,0(sp)
    80002a2a:	6105                	addi	sp,sp,32
    80002a2c:	8082                	ret

0000000080002a2e <idup>:
{
    80002a2e:	1101                	addi	sp,sp,-32
    80002a30:	ec06                	sd	ra,24(sp)
    80002a32:	e822                	sd	s0,16(sp)
    80002a34:	e426                	sd	s1,8(sp)
    80002a36:	1000                	addi	s0,sp,32
    80002a38:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a3a:	00015517          	auipc	a0,0x15
    80002a3e:	b3e50513          	addi	a0,a0,-1218 # 80017578 <itable>
    80002a42:	00003097          	auipc	ra,0x3
    80002a46:	5d6080e7          	jalr	1494(ra) # 80006018 <acquire>
  ip->ref++;
    80002a4a:	449c                	lw	a5,8(s1)
    80002a4c:	2785                	addiw	a5,a5,1
    80002a4e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a50:	00015517          	auipc	a0,0x15
    80002a54:	b2850513          	addi	a0,a0,-1240 # 80017578 <itable>
    80002a58:	00003097          	auipc	ra,0x3
    80002a5c:	674080e7          	jalr	1652(ra) # 800060cc <release>
}
    80002a60:	8526                	mv	a0,s1
    80002a62:	60e2                	ld	ra,24(sp)
    80002a64:	6442                	ld	s0,16(sp)
    80002a66:	64a2                	ld	s1,8(sp)
    80002a68:	6105                	addi	sp,sp,32
    80002a6a:	8082                	ret

0000000080002a6c <ilock>:
{
    80002a6c:	1101                	addi	sp,sp,-32
    80002a6e:	ec06                	sd	ra,24(sp)
    80002a70:	e822                	sd	s0,16(sp)
    80002a72:	e426                	sd	s1,8(sp)
    80002a74:	e04a                	sd	s2,0(sp)
    80002a76:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002a78:	c115                	beqz	a0,80002a9c <ilock+0x30>
    80002a7a:	84aa                	mv	s1,a0
    80002a7c:	451c                	lw	a5,8(a0)
    80002a7e:	00f05f63          	blez	a5,80002a9c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002a82:	0541                	addi	a0,a0,16
    80002a84:	00001097          	auipc	ra,0x1
    80002a88:	cb8080e7          	jalr	-840(ra) # 8000373c <acquiresleep>
  if(ip->valid == 0){
    80002a8c:	40bc                	lw	a5,64(s1)
    80002a8e:	cf99                	beqz	a5,80002aac <ilock+0x40>
}
    80002a90:	60e2                	ld	ra,24(sp)
    80002a92:	6442                	ld	s0,16(sp)
    80002a94:	64a2                	ld	s1,8(sp)
    80002a96:	6902                	ld	s2,0(sp)
    80002a98:	6105                	addi	sp,sp,32
    80002a9a:	8082                	ret
    panic("ilock");
    80002a9c:	00006517          	auipc	a0,0x6
    80002aa0:	aac50513          	addi	a0,a0,-1364 # 80008548 <syscalls+0x180>
    80002aa4:	00003097          	auipc	ra,0x3
    80002aa8:	03c080e7          	jalr	60(ra) # 80005ae0 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002aac:	40dc                	lw	a5,4(s1)
    80002aae:	0047d79b          	srliw	a5,a5,0x4
    80002ab2:	00015597          	auipc	a1,0x15
    80002ab6:	abe5a583          	lw	a1,-1346(a1) # 80017570 <sb+0x18>
    80002aba:	9dbd                	addw	a1,a1,a5
    80002abc:	4088                	lw	a0,0(s1)
    80002abe:	fffff097          	auipc	ra,0xfffff
    80002ac2:	7ac080e7          	jalr	1964(ra) # 8000226a <bread>
    80002ac6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ac8:	05850593          	addi	a1,a0,88
    80002acc:	40dc                	lw	a5,4(s1)
    80002ace:	8bbd                	andi	a5,a5,15
    80002ad0:	079a                	slli	a5,a5,0x6
    80002ad2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ad4:	00059783          	lh	a5,0(a1)
    80002ad8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002adc:	00259783          	lh	a5,2(a1)
    80002ae0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ae4:	00459783          	lh	a5,4(a1)
    80002ae8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002aec:	00659783          	lh	a5,6(a1)
    80002af0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002af4:	459c                	lw	a5,8(a1)
    80002af6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002af8:	03400613          	li	a2,52
    80002afc:	05b1                	addi	a1,a1,12
    80002afe:	05048513          	addi	a0,s1,80
    80002b02:	ffffd097          	auipc	ra,0xffffd
    80002b06:	6d4080e7          	jalr	1748(ra) # 800001d6 <memmove>
    brelse(bp);
    80002b0a:	854a                	mv	a0,s2
    80002b0c:	00000097          	auipc	ra,0x0
    80002b10:	88e080e7          	jalr	-1906(ra) # 8000239a <brelse>
    ip->valid = 1;
    80002b14:	4785                	li	a5,1
    80002b16:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b18:	04449783          	lh	a5,68(s1)
    80002b1c:	fbb5                	bnez	a5,80002a90 <ilock+0x24>
      panic("ilock: no type");
    80002b1e:	00006517          	auipc	a0,0x6
    80002b22:	a3250513          	addi	a0,a0,-1486 # 80008550 <syscalls+0x188>
    80002b26:	00003097          	auipc	ra,0x3
    80002b2a:	fba080e7          	jalr	-70(ra) # 80005ae0 <panic>

0000000080002b2e <iunlock>:
{
    80002b2e:	1101                	addi	sp,sp,-32
    80002b30:	ec06                	sd	ra,24(sp)
    80002b32:	e822                	sd	s0,16(sp)
    80002b34:	e426                	sd	s1,8(sp)
    80002b36:	e04a                	sd	s2,0(sp)
    80002b38:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002b3a:	c905                	beqz	a0,80002b6a <iunlock+0x3c>
    80002b3c:	84aa                	mv	s1,a0
    80002b3e:	01050913          	addi	s2,a0,16
    80002b42:	854a                	mv	a0,s2
    80002b44:	00001097          	auipc	ra,0x1
    80002b48:	c92080e7          	jalr	-878(ra) # 800037d6 <holdingsleep>
    80002b4c:	cd19                	beqz	a0,80002b6a <iunlock+0x3c>
    80002b4e:	449c                	lw	a5,8(s1)
    80002b50:	00f05d63          	blez	a5,80002b6a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002b54:	854a                	mv	a0,s2
    80002b56:	00001097          	auipc	ra,0x1
    80002b5a:	c3c080e7          	jalr	-964(ra) # 80003792 <releasesleep>
}
    80002b5e:	60e2                	ld	ra,24(sp)
    80002b60:	6442                	ld	s0,16(sp)
    80002b62:	64a2                	ld	s1,8(sp)
    80002b64:	6902                	ld	s2,0(sp)
    80002b66:	6105                	addi	sp,sp,32
    80002b68:	8082                	ret
    panic("iunlock");
    80002b6a:	00006517          	auipc	a0,0x6
    80002b6e:	9f650513          	addi	a0,a0,-1546 # 80008560 <syscalls+0x198>
    80002b72:	00003097          	auipc	ra,0x3
    80002b76:	f6e080e7          	jalr	-146(ra) # 80005ae0 <panic>

0000000080002b7a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002b7a:	7179                	addi	sp,sp,-48
    80002b7c:	f406                	sd	ra,40(sp)
    80002b7e:	f022                	sd	s0,32(sp)
    80002b80:	ec26                	sd	s1,24(sp)
    80002b82:	e84a                	sd	s2,16(sp)
    80002b84:	e44e                	sd	s3,8(sp)
    80002b86:	e052                	sd	s4,0(sp)
    80002b88:	1800                	addi	s0,sp,48
    80002b8a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002b8c:	05050493          	addi	s1,a0,80
    80002b90:	08050913          	addi	s2,a0,128
    80002b94:	a021                	j	80002b9c <itrunc+0x22>
    80002b96:	0491                	addi	s1,s1,4
    80002b98:	01248d63          	beq	s1,s2,80002bb2 <itrunc+0x38>
    if(ip->addrs[i]){
    80002b9c:	408c                	lw	a1,0(s1)
    80002b9e:	dde5                	beqz	a1,80002b96 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ba0:	0009a503          	lw	a0,0(s3)
    80002ba4:	00000097          	auipc	ra,0x0
    80002ba8:	90c080e7          	jalr	-1780(ra) # 800024b0 <bfree>
      ip->addrs[i] = 0;
    80002bac:	0004a023          	sw	zero,0(s1)
    80002bb0:	b7dd                	j	80002b96 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002bb2:	0809a583          	lw	a1,128(s3)
    80002bb6:	e185                	bnez	a1,80002bd6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002bb8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002bbc:	854e                	mv	a0,s3
    80002bbe:	00000097          	auipc	ra,0x0
    80002bc2:	de2080e7          	jalr	-542(ra) # 800029a0 <iupdate>
}
    80002bc6:	70a2                	ld	ra,40(sp)
    80002bc8:	7402                	ld	s0,32(sp)
    80002bca:	64e2                	ld	s1,24(sp)
    80002bcc:	6942                	ld	s2,16(sp)
    80002bce:	69a2                	ld	s3,8(sp)
    80002bd0:	6a02                	ld	s4,0(sp)
    80002bd2:	6145                	addi	sp,sp,48
    80002bd4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002bd6:	0009a503          	lw	a0,0(s3)
    80002bda:	fffff097          	auipc	ra,0xfffff
    80002bde:	690080e7          	jalr	1680(ra) # 8000226a <bread>
    80002be2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002be4:	05850493          	addi	s1,a0,88
    80002be8:	45850913          	addi	s2,a0,1112
    80002bec:	a021                	j	80002bf4 <itrunc+0x7a>
    80002bee:	0491                	addi	s1,s1,4
    80002bf0:	01248b63          	beq	s1,s2,80002c06 <itrunc+0x8c>
      if(a[j])
    80002bf4:	408c                	lw	a1,0(s1)
    80002bf6:	dde5                	beqz	a1,80002bee <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002bf8:	0009a503          	lw	a0,0(s3)
    80002bfc:	00000097          	auipc	ra,0x0
    80002c00:	8b4080e7          	jalr	-1868(ra) # 800024b0 <bfree>
    80002c04:	b7ed                	j	80002bee <itrunc+0x74>
    brelse(bp);
    80002c06:	8552                	mv	a0,s4
    80002c08:	fffff097          	auipc	ra,0xfffff
    80002c0c:	792080e7          	jalr	1938(ra) # 8000239a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c10:	0809a583          	lw	a1,128(s3)
    80002c14:	0009a503          	lw	a0,0(s3)
    80002c18:	00000097          	auipc	ra,0x0
    80002c1c:	898080e7          	jalr	-1896(ra) # 800024b0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c20:	0809a023          	sw	zero,128(s3)
    80002c24:	bf51                	j	80002bb8 <itrunc+0x3e>

0000000080002c26 <iput>:
{
    80002c26:	1101                	addi	sp,sp,-32
    80002c28:	ec06                	sd	ra,24(sp)
    80002c2a:	e822                	sd	s0,16(sp)
    80002c2c:	e426                	sd	s1,8(sp)
    80002c2e:	e04a                	sd	s2,0(sp)
    80002c30:	1000                	addi	s0,sp,32
    80002c32:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c34:	00015517          	auipc	a0,0x15
    80002c38:	94450513          	addi	a0,a0,-1724 # 80017578 <itable>
    80002c3c:	00003097          	auipc	ra,0x3
    80002c40:	3dc080e7          	jalr	988(ra) # 80006018 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c44:	4498                	lw	a4,8(s1)
    80002c46:	4785                	li	a5,1
    80002c48:	02f70363          	beq	a4,a5,80002c6e <iput+0x48>
  ip->ref--;
    80002c4c:	449c                	lw	a5,8(s1)
    80002c4e:	37fd                	addiw	a5,a5,-1
    80002c50:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c52:	00015517          	auipc	a0,0x15
    80002c56:	92650513          	addi	a0,a0,-1754 # 80017578 <itable>
    80002c5a:	00003097          	auipc	ra,0x3
    80002c5e:	472080e7          	jalr	1138(ra) # 800060cc <release>
}
    80002c62:	60e2                	ld	ra,24(sp)
    80002c64:	6442                	ld	s0,16(sp)
    80002c66:	64a2                	ld	s1,8(sp)
    80002c68:	6902                	ld	s2,0(sp)
    80002c6a:	6105                	addi	sp,sp,32
    80002c6c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c6e:	40bc                	lw	a5,64(s1)
    80002c70:	dff1                	beqz	a5,80002c4c <iput+0x26>
    80002c72:	04a49783          	lh	a5,74(s1)
    80002c76:	fbf9                	bnez	a5,80002c4c <iput+0x26>
    acquiresleep(&ip->lock);
    80002c78:	01048913          	addi	s2,s1,16
    80002c7c:	854a                	mv	a0,s2
    80002c7e:	00001097          	auipc	ra,0x1
    80002c82:	abe080e7          	jalr	-1346(ra) # 8000373c <acquiresleep>
    release(&itable.lock);
    80002c86:	00015517          	auipc	a0,0x15
    80002c8a:	8f250513          	addi	a0,a0,-1806 # 80017578 <itable>
    80002c8e:	00003097          	auipc	ra,0x3
    80002c92:	43e080e7          	jalr	1086(ra) # 800060cc <release>
    itrunc(ip);
    80002c96:	8526                	mv	a0,s1
    80002c98:	00000097          	auipc	ra,0x0
    80002c9c:	ee2080e7          	jalr	-286(ra) # 80002b7a <itrunc>
    ip->type = 0;
    80002ca0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ca4:	8526                	mv	a0,s1
    80002ca6:	00000097          	auipc	ra,0x0
    80002caa:	cfa080e7          	jalr	-774(ra) # 800029a0 <iupdate>
    ip->valid = 0;
    80002cae:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002cb2:	854a                	mv	a0,s2
    80002cb4:	00001097          	auipc	ra,0x1
    80002cb8:	ade080e7          	jalr	-1314(ra) # 80003792 <releasesleep>
    acquire(&itable.lock);
    80002cbc:	00015517          	auipc	a0,0x15
    80002cc0:	8bc50513          	addi	a0,a0,-1860 # 80017578 <itable>
    80002cc4:	00003097          	auipc	ra,0x3
    80002cc8:	354080e7          	jalr	852(ra) # 80006018 <acquire>
    80002ccc:	b741                	j	80002c4c <iput+0x26>

0000000080002cce <iunlockput>:
{
    80002cce:	1101                	addi	sp,sp,-32
    80002cd0:	ec06                	sd	ra,24(sp)
    80002cd2:	e822                	sd	s0,16(sp)
    80002cd4:	e426                	sd	s1,8(sp)
    80002cd6:	1000                	addi	s0,sp,32
    80002cd8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002cda:	00000097          	auipc	ra,0x0
    80002cde:	e54080e7          	jalr	-428(ra) # 80002b2e <iunlock>
  iput(ip);
    80002ce2:	8526                	mv	a0,s1
    80002ce4:	00000097          	auipc	ra,0x0
    80002ce8:	f42080e7          	jalr	-190(ra) # 80002c26 <iput>
}
    80002cec:	60e2                	ld	ra,24(sp)
    80002cee:	6442                	ld	s0,16(sp)
    80002cf0:	64a2                	ld	s1,8(sp)
    80002cf2:	6105                	addi	sp,sp,32
    80002cf4:	8082                	ret

0000000080002cf6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002cf6:	1141                	addi	sp,sp,-16
    80002cf8:	e422                	sd	s0,8(sp)
    80002cfa:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002cfc:	411c                	lw	a5,0(a0)
    80002cfe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d00:	415c                	lw	a5,4(a0)
    80002d02:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d04:	04451783          	lh	a5,68(a0)
    80002d08:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d0c:	04a51783          	lh	a5,74(a0)
    80002d10:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d14:	04c56783          	lwu	a5,76(a0)
    80002d18:	e99c                	sd	a5,16(a1)
}
    80002d1a:	6422                	ld	s0,8(sp)
    80002d1c:	0141                	addi	sp,sp,16
    80002d1e:	8082                	ret

0000000080002d20 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d20:	457c                	lw	a5,76(a0)
    80002d22:	0ed7e963          	bltu	a5,a3,80002e14 <readi+0xf4>
{
    80002d26:	7159                	addi	sp,sp,-112
    80002d28:	f486                	sd	ra,104(sp)
    80002d2a:	f0a2                	sd	s0,96(sp)
    80002d2c:	eca6                	sd	s1,88(sp)
    80002d2e:	e8ca                	sd	s2,80(sp)
    80002d30:	e4ce                	sd	s3,72(sp)
    80002d32:	e0d2                	sd	s4,64(sp)
    80002d34:	fc56                	sd	s5,56(sp)
    80002d36:	f85a                	sd	s6,48(sp)
    80002d38:	f45e                	sd	s7,40(sp)
    80002d3a:	f062                	sd	s8,32(sp)
    80002d3c:	ec66                	sd	s9,24(sp)
    80002d3e:	e86a                	sd	s10,16(sp)
    80002d40:	e46e                	sd	s11,8(sp)
    80002d42:	1880                	addi	s0,sp,112
    80002d44:	8baa                	mv	s7,a0
    80002d46:	8c2e                	mv	s8,a1
    80002d48:	8ab2                	mv	s5,a2
    80002d4a:	84b6                	mv	s1,a3
    80002d4c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002d4e:	9f35                	addw	a4,a4,a3
    return 0;
    80002d50:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002d52:	0ad76063          	bltu	a4,a3,80002df2 <readi+0xd2>
  if(off + n > ip->size)
    80002d56:	00e7f463          	bgeu	a5,a4,80002d5e <readi+0x3e>
    n = ip->size - off;
    80002d5a:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d5e:	0a0b0963          	beqz	s6,80002e10 <readi+0xf0>
    80002d62:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d64:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002d68:	5cfd                	li	s9,-1
    80002d6a:	a82d                	j	80002da4 <readi+0x84>
    80002d6c:	020a1d93          	slli	s11,s4,0x20
    80002d70:	020ddd93          	srli	s11,s11,0x20
    80002d74:	05890613          	addi	a2,s2,88
    80002d78:	86ee                	mv	a3,s11
    80002d7a:	963a                	add	a2,a2,a4
    80002d7c:	85d6                	mv	a1,s5
    80002d7e:	8562                	mv	a0,s8
    80002d80:	fffff097          	auipc	ra,0xfffff
    80002d84:	b2c080e7          	jalr	-1236(ra) # 800018ac <either_copyout>
    80002d88:	05950d63          	beq	a0,s9,80002de2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002d8c:	854a                	mv	a0,s2
    80002d8e:	fffff097          	auipc	ra,0xfffff
    80002d92:	60c080e7          	jalr	1548(ra) # 8000239a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d96:	013a09bb          	addw	s3,s4,s3
    80002d9a:	009a04bb          	addw	s1,s4,s1
    80002d9e:	9aee                	add	s5,s5,s11
    80002da0:	0569f763          	bgeu	s3,s6,80002dee <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002da4:	000ba903          	lw	s2,0(s7)
    80002da8:	00a4d59b          	srliw	a1,s1,0xa
    80002dac:	855e                	mv	a0,s7
    80002dae:	00000097          	auipc	ra,0x0
    80002db2:	8ac080e7          	jalr	-1876(ra) # 8000265a <bmap>
    80002db6:	0005059b          	sext.w	a1,a0
    80002dba:	854a                	mv	a0,s2
    80002dbc:	fffff097          	auipc	ra,0xfffff
    80002dc0:	4ae080e7          	jalr	1198(ra) # 8000226a <bread>
    80002dc4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dc6:	3ff4f713          	andi	a4,s1,1023
    80002dca:	40ed07bb          	subw	a5,s10,a4
    80002dce:	413b06bb          	subw	a3,s6,s3
    80002dd2:	8a3e                	mv	s4,a5
    80002dd4:	2781                	sext.w	a5,a5
    80002dd6:	0006861b          	sext.w	a2,a3
    80002dda:	f8f679e3          	bgeu	a2,a5,80002d6c <readi+0x4c>
    80002dde:	8a36                	mv	s4,a3
    80002de0:	b771                	j	80002d6c <readi+0x4c>
      brelse(bp);
    80002de2:	854a                	mv	a0,s2
    80002de4:	fffff097          	auipc	ra,0xfffff
    80002de8:	5b6080e7          	jalr	1462(ra) # 8000239a <brelse>
      tot = -1;
    80002dec:	59fd                	li	s3,-1
  }
  return tot;
    80002dee:	0009851b          	sext.w	a0,s3
}
    80002df2:	70a6                	ld	ra,104(sp)
    80002df4:	7406                	ld	s0,96(sp)
    80002df6:	64e6                	ld	s1,88(sp)
    80002df8:	6946                	ld	s2,80(sp)
    80002dfa:	69a6                	ld	s3,72(sp)
    80002dfc:	6a06                	ld	s4,64(sp)
    80002dfe:	7ae2                	ld	s5,56(sp)
    80002e00:	7b42                	ld	s6,48(sp)
    80002e02:	7ba2                	ld	s7,40(sp)
    80002e04:	7c02                	ld	s8,32(sp)
    80002e06:	6ce2                	ld	s9,24(sp)
    80002e08:	6d42                	ld	s10,16(sp)
    80002e0a:	6da2                	ld	s11,8(sp)
    80002e0c:	6165                	addi	sp,sp,112
    80002e0e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e10:	89da                	mv	s3,s6
    80002e12:	bff1                	j	80002dee <readi+0xce>
    return 0;
    80002e14:	4501                	li	a0,0
}
    80002e16:	8082                	ret

0000000080002e18 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e18:	457c                	lw	a5,76(a0)
    80002e1a:	10d7e863          	bltu	a5,a3,80002f2a <writei+0x112>
{
    80002e1e:	7159                	addi	sp,sp,-112
    80002e20:	f486                	sd	ra,104(sp)
    80002e22:	f0a2                	sd	s0,96(sp)
    80002e24:	eca6                	sd	s1,88(sp)
    80002e26:	e8ca                	sd	s2,80(sp)
    80002e28:	e4ce                	sd	s3,72(sp)
    80002e2a:	e0d2                	sd	s4,64(sp)
    80002e2c:	fc56                	sd	s5,56(sp)
    80002e2e:	f85a                	sd	s6,48(sp)
    80002e30:	f45e                	sd	s7,40(sp)
    80002e32:	f062                	sd	s8,32(sp)
    80002e34:	ec66                	sd	s9,24(sp)
    80002e36:	e86a                	sd	s10,16(sp)
    80002e38:	e46e                	sd	s11,8(sp)
    80002e3a:	1880                	addi	s0,sp,112
    80002e3c:	8b2a                	mv	s6,a0
    80002e3e:	8c2e                	mv	s8,a1
    80002e40:	8ab2                	mv	s5,a2
    80002e42:	8936                	mv	s2,a3
    80002e44:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002e46:	00e687bb          	addw	a5,a3,a4
    80002e4a:	0ed7e263          	bltu	a5,a3,80002f2e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002e4e:	00043737          	lui	a4,0x43
    80002e52:	0ef76063          	bltu	a4,a5,80002f32 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e56:	0c0b8863          	beqz	s7,80002f26 <writei+0x10e>
    80002e5a:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e5c:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002e60:	5cfd                	li	s9,-1
    80002e62:	a091                	j	80002ea6 <writei+0x8e>
    80002e64:	02099d93          	slli	s11,s3,0x20
    80002e68:	020ddd93          	srli	s11,s11,0x20
    80002e6c:	05848513          	addi	a0,s1,88
    80002e70:	86ee                	mv	a3,s11
    80002e72:	8656                	mv	a2,s5
    80002e74:	85e2                	mv	a1,s8
    80002e76:	953a                	add	a0,a0,a4
    80002e78:	fffff097          	auipc	ra,0xfffff
    80002e7c:	a8a080e7          	jalr	-1398(ra) # 80001902 <either_copyin>
    80002e80:	07950263          	beq	a0,s9,80002ee4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002e84:	8526                	mv	a0,s1
    80002e86:	00000097          	auipc	ra,0x0
    80002e8a:	798080e7          	jalr	1944(ra) # 8000361e <log_write>
    brelse(bp);
    80002e8e:	8526                	mv	a0,s1
    80002e90:	fffff097          	auipc	ra,0xfffff
    80002e94:	50a080e7          	jalr	1290(ra) # 8000239a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e98:	01498a3b          	addw	s4,s3,s4
    80002e9c:	0129893b          	addw	s2,s3,s2
    80002ea0:	9aee                	add	s5,s5,s11
    80002ea2:	057a7663          	bgeu	s4,s7,80002eee <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ea6:	000b2483          	lw	s1,0(s6)
    80002eaa:	00a9559b          	srliw	a1,s2,0xa
    80002eae:	855a                	mv	a0,s6
    80002eb0:	fffff097          	auipc	ra,0xfffff
    80002eb4:	7aa080e7          	jalr	1962(ra) # 8000265a <bmap>
    80002eb8:	0005059b          	sext.w	a1,a0
    80002ebc:	8526                	mv	a0,s1
    80002ebe:	fffff097          	auipc	ra,0xfffff
    80002ec2:	3ac080e7          	jalr	940(ra) # 8000226a <bread>
    80002ec6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ec8:	3ff97713          	andi	a4,s2,1023
    80002ecc:	40ed07bb          	subw	a5,s10,a4
    80002ed0:	414b86bb          	subw	a3,s7,s4
    80002ed4:	89be                	mv	s3,a5
    80002ed6:	2781                	sext.w	a5,a5
    80002ed8:	0006861b          	sext.w	a2,a3
    80002edc:	f8f674e3          	bgeu	a2,a5,80002e64 <writei+0x4c>
    80002ee0:	89b6                	mv	s3,a3
    80002ee2:	b749                	j	80002e64 <writei+0x4c>
      brelse(bp);
    80002ee4:	8526                	mv	a0,s1
    80002ee6:	fffff097          	auipc	ra,0xfffff
    80002eea:	4b4080e7          	jalr	1204(ra) # 8000239a <brelse>
  }

  if(off > ip->size)
    80002eee:	04cb2783          	lw	a5,76(s6)
    80002ef2:	0127f463          	bgeu	a5,s2,80002efa <writei+0xe2>
    ip->size = off;
    80002ef6:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002efa:	855a                	mv	a0,s6
    80002efc:	00000097          	auipc	ra,0x0
    80002f00:	aa4080e7          	jalr	-1372(ra) # 800029a0 <iupdate>

  return tot;
    80002f04:	000a051b          	sext.w	a0,s4
}
    80002f08:	70a6                	ld	ra,104(sp)
    80002f0a:	7406                	ld	s0,96(sp)
    80002f0c:	64e6                	ld	s1,88(sp)
    80002f0e:	6946                	ld	s2,80(sp)
    80002f10:	69a6                	ld	s3,72(sp)
    80002f12:	6a06                	ld	s4,64(sp)
    80002f14:	7ae2                	ld	s5,56(sp)
    80002f16:	7b42                	ld	s6,48(sp)
    80002f18:	7ba2                	ld	s7,40(sp)
    80002f1a:	7c02                	ld	s8,32(sp)
    80002f1c:	6ce2                	ld	s9,24(sp)
    80002f1e:	6d42                	ld	s10,16(sp)
    80002f20:	6da2                	ld	s11,8(sp)
    80002f22:	6165                	addi	sp,sp,112
    80002f24:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f26:	8a5e                	mv	s4,s7
    80002f28:	bfc9                	j	80002efa <writei+0xe2>
    return -1;
    80002f2a:	557d                	li	a0,-1
}
    80002f2c:	8082                	ret
    return -1;
    80002f2e:	557d                	li	a0,-1
    80002f30:	bfe1                	j	80002f08 <writei+0xf0>
    return -1;
    80002f32:	557d                	li	a0,-1
    80002f34:	bfd1                	j	80002f08 <writei+0xf0>

0000000080002f36 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002f36:	1141                	addi	sp,sp,-16
    80002f38:	e406                	sd	ra,8(sp)
    80002f3a:	e022                	sd	s0,0(sp)
    80002f3c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002f3e:	4639                	li	a2,14
    80002f40:	ffffd097          	auipc	ra,0xffffd
    80002f44:	30a080e7          	jalr	778(ra) # 8000024a <strncmp>
}
    80002f48:	60a2                	ld	ra,8(sp)
    80002f4a:	6402                	ld	s0,0(sp)
    80002f4c:	0141                	addi	sp,sp,16
    80002f4e:	8082                	ret

0000000080002f50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002f50:	7139                	addi	sp,sp,-64
    80002f52:	fc06                	sd	ra,56(sp)
    80002f54:	f822                	sd	s0,48(sp)
    80002f56:	f426                	sd	s1,40(sp)
    80002f58:	f04a                	sd	s2,32(sp)
    80002f5a:	ec4e                	sd	s3,24(sp)
    80002f5c:	e852                	sd	s4,16(sp)
    80002f5e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002f60:	04451703          	lh	a4,68(a0)
    80002f64:	4785                	li	a5,1
    80002f66:	00f71a63          	bne	a4,a5,80002f7a <dirlookup+0x2a>
    80002f6a:	892a                	mv	s2,a0
    80002f6c:	89ae                	mv	s3,a1
    80002f6e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f70:	457c                	lw	a5,76(a0)
    80002f72:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002f74:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f76:	e79d                	bnez	a5,80002fa4 <dirlookup+0x54>
    80002f78:	a8a5                	j	80002ff0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002f7a:	00005517          	auipc	a0,0x5
    80002f7e:	5ee50513          	addi	a0,a0,1518 # 80008568 <syscalls+0x1a0>
    80002f82:	00003097          	auipc	ra,0x3
    80002f86:	b5e080e7          	jalr	-1186(ra) # 80005ae0 <panic>
      panic("dirlookup read");
    80002f8a:	00005517          	auipc	a0,0x5
    80002f8e:	5f650513          	addi	a0,a0,1526 # 80008580 <syscalls+0x1b8>
    80002f92:	00003097          	auipc	ra,0x3
    80002f96:	b4e080e7          	jalr	-1202(ra) # 80005ae0 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f9a:	24c1                	addiw	s1,s1,16
    80002f9c:	04c92783          	lw	a5,76(s2)
    80002fa0:	04f4f763          	bgeu	s1,a5,80002fee <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002fa4:	4741                	li	a4,16
    80002fa6:	86a6                	mv	a3,s1
    80002fa8:	fc040613          	addi	a2,s0,-64
    80002fac:	4581                	li	a1,0
    80002fae:	854a                	mv	a0,s2
    80002fb0:	00000097          	auipc	ra,0x0
    80002fb4:	d70080e7          	jalr	-656(ra) # 80002d20 <readi>
    80002fb8:	47c1                	li	a5,16
    80002fba:	fcf518e3          	bne	a0,a5,80002f8a <dirlookup+0x3a>
    if(de.inum == 0)
    80002fbe:	fc045783          	lhu	a5,-64(s0)
    80002fc2:	dfe1                	beqz	a5,80002f9a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80002fc4:	fc240593          	addi	a1,s0,-62
    80002fc8:	854e                	mv	a0,s3
    80002fca:	00000097          	auipc	ra,0x0
    80002fce:	f6c080e7          	jalr	-148(ra) # 80002f36 <namecmp>
    80002fd2:	f561                	bnez	a0,80002f9a <dirlookup+0x4a>
      if(poff)
    80002fd4:	000a0463          	beqz	s4,80002fdc <dirlookup+0x8c>
        *poff = off;
    80002fd8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002fdc:	fc045583          	lhu	a1,-64(s0)
    80002fe0:	00092503          	lw	a0,0(s2)
    80002fe4:	fffff097          	auipc	ra,0xfffff
    80002fe8:	752080e7          	jalr	1874(ra) # 80002736 <iget>
    80002fec:	a011                	j	80002ff0 <dirlookup+0xa0>
  return 0;
    80002fee:	4501                	li	a0,0
}
    80002ff0:	70e2                	ld	ra,56(sp)
    80002ff2:	7442                	ld	s0,48(sp)
    80002ff4:	74a2                	ld	s1,40(sp)
    80002ff6:	7902                	ld	s2,32(sp)
    80002ff8:	69e2                	ld	s3,24(sp)
    80002ffa:	6a42                	ld	s4,16(sp)
    80002ffc:	6121                	addi	sp,sp,64
    80002ffe:	8082                	ret

0000000080003000 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003000:	711d                	addi	sp,sp,-96
    80003002:	ec86                	sd	ra,88(sp)
    80003004:	e8a2                	sd	s0,80(sp)
    80003006:	e4a6                	sd	s1,72(sp)
    80003008:	e0ca                	sd	s2,64(sp)
    8000300a:	fc4e                	sd	s3,56(sp)
    8000300c:	f852                	sd	s4,48(sp)
    8000300e:	f456                	sd	s5,40(sp)
    80003010:	f05a                	sd	s6,32(sp)
    80003012:	ec5e                	sd	s7,24(sp)
    80003014:	e862                	sd	s8,16(sp)
    80003016:	e466                	sd	s9,8(sp)
    80003018:	e06a                	sd	s10,0(sp)
    8000301a:	1080                	addi	s0,sp,96
    8000301c:	84aa                	mv	s1,a0
    8000301e:	8b2e                	mv	s6,a1
    80003020:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003022:	00054703          	lbu	a4,0(a0)
    80003026:	02f00793          	li	a5,47
    8000302a:	02f70363          	beq	a4,a5,80003050 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000302e:	ffffe097          	auipc	ra,0xffffe
    80003032:	e16080e7          	jalr	-490(ra) # 80000e44 <myproc>
    80003036:	15053503          	ld	a0,336(a0)
    8000303a:	00000097          	auipc	ra,0x0
    8000303e:	9f4080e7          	jalr	-1548(ra) # 80002a2e <idup>
    80003042:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003044:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003048:	4cb5                	li	s9,13
  len = path - s;
    8000304a:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000304c:	4c05                	li	s8,1
    8000304e:	a87d                	j	8000310c <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003050:	4585                	li	a1,1
    80003052:	4505                	li	a0,1
    80003054:	fffff097          	auipc	ra,0xfffff
    80003058:	6e2080e7          	jalr	1762(ra) # 80002736 <iget>
    8000305c:	8a2a                	mv	s4,a0
    8000305e:	b7dd                	j	80003044 <namex+0x44>
      iunlockput(ip);
    80003060:	8552                	mv	a0,s4
    80003062:	00000097          	auipc	ra,0x0
    80003066:	c6c080e7          	jalr	-916(ra) # 80002cce <iunlockput>
      return 0;
    8000306a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000306c:	8552                	mv	a0,s4
    8000306e:	60e6                	ld	ra,88(sp)
    80003070:	6446                	ld	s0,80(sp)
    80003072:	64a6                	ld	s1,72(sp)
    80003074:	6906                	ld	s2,64(sp)
    80003076:	79e2                	ld	s3,56(sp)
    80003078:	7a42                	ld	s4,48(sp)
    8000307a:	7aa2                	ld	s5,40(sp)
    8000307c:	7b02                	ld	s6,32(sp)
    8000307e:	6be2                	ld	s7,24(sp)
    80003080:	6c42                	ld	s8,16(sp)
    80003082:	6ca2                	ld	s9,8(sp)
    80003084:	6d02                	ld	s10,0(sp)
    80003086:	6125                	addi	sp,sp,96
    80003088:	8082                	ret
      iunlock(ip);
    8000308a:	8552                	mv	a0,s4
    8000308c:	00000097          	auipc	ra,0x0
    80003090:	aa2080e7          	jalr	-1374(ra) # 80002b2e <iunlock>
      return ip;
    80003094:	bfe1                	j	8000306c <namex+0x6c>
      iunlockput(ip);
    80003096:	8552                	mv	a0,s4
    80003098:	00000097          	auipc	ra,0x0
    8000309c:	c36080e7          	jalr	-970(ra) # 80002cce <iunlockput>
      return 0;
    800030a0:	8a4e                	mv	s4,s3
    800030a2:	b7e9                	j	8000306c <namex+0x6c>
  len = path - s;
    800030a4:	40998633          	sub	a2,s3,s1
    800030a8:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800030ac:	09acd863          	bge	s9,s10,8000313c <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800030b0:	4639                	li	a2,14
    800030b2:	85a6                	mv	a1,s1
    800030b4:	8556                	mv	a0,s5
    800030b6:	ffffd097          	auipc	ra,0xffffd
    800030ba:	120080e7          	jalr	288(ra) # 800001d6 <memmove>
    800030be:	84ce                	mv	s1,s3
  while(*path == '/')
    800030c0:	0004c783          	lbu	a5,0(s1)
    800030c4:	01279763          	bne	a5,s2,800030d2 <namex+0xd2>
    path++;
    800030c8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800030ca:	0004c783          	lbu	a5,0(s1)
    800030ce:	ff278de3          	beq	a5,s2,800030c8 <namex+0xc8>
    ilock(ip);
    800030d2:	8552                	mv	a0,s4
    800030d4:	00000097          	auipc	ra,0x0
    800030d8:	998080e7          	jalr	-1640(ra) # 80002a6c <ilock>
    if(ip->type != T_DIR){
    800030dc:	044a1783          	lh	a5,68(s4)
    800030e0:	f98790e3          	bne	a5,s8,80003060 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800030e4:	000b0563          	beqz	s6,800030ee <namex+0xee>
    800030e8:	0004c783          	lbu	a5,0(s1)
    800030ec:	dfd9                	beqz	a5,8000308a <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800030ee:	865e                	mv	a2,s7
    800030f0:	85d6                	mv	a1,s5
    800030f2:	8552                	mv	a0,s4
    800030f4:	00000097          	auipc	ra,0x0
    800030f8:	e5c080e7          	jalr	-420(ra) # 80002f50 <dirlookup>
    800030fc:	89aa                	mv	s3,a0
    800030fe:	dd41                	beqz	a0,80003096 <namex+0x96>
    iunlockput(ip);
    80003100:	8552                	mv	a0,s4
    80003102:	00000097          	auipc	ra,0x0
    80003106:	bcc080e7          	jalr	-1076(ra) # 80002cce <iunlockput>
    ip = next;
    8000310a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000310c:	0004c783          	lbu	a5,0(s1)
    80003110:	01279763          	bne	a5,s2,8000311e <namex+0x11e>
    path++;
    80003114:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003116:	0004c783          	lbu	a5,0(s1)
    8000311a:	ff278de3          	beq	a5,s2,80003114 <namex+0x114>
  if(*path == 0)
    8000311e:	cb9d                	beqz	a5,80003154 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003120:	0004c783          	lbu	a5,0(s1)
    80003124:	89a6                	mv	s3,s1
  len = path - s;
    80003126:	8d5e                	mv	s10,s7
    80003128:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000312a:	01278963          	beq	a5,s2,8000313c <namex+0x13c>
    8000312e:	dbbd                	beqz	a5,800030a4 <namex+0xa4>
    path++;
    80003130:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003132:	0009c783          	lbu	a5,0(s3)
    80003136:	ff279ce3          	bne	a5,s2,8000312e <namex+0x12e>
    8000313a:	b7ad                	j	800030a4 <namex+0xa4>
    memmove(name, s, len);
    8000313c:	2601                	sext.w	a2,a2
    8000313e:	85a6                	mv	a1,s1
    80003140:	8556                	mv	a0,s5
    80003142:	ffffd097          	auipc	ra,0xffffd
    80003146:	094080e7          	jalr	148(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000314a:	9d56                	add	s10,s10,s5
    8000314c:	000d0023          	sb	zero,0(s10)
    80003150:	84ce                	mv	s1,s3
    80003152:	b7bd                	j	800030c0 <namex+0xc0>
  if(nameiparent){
    80003154:	f00b0ce3          	beqz	s6,8000306c <namex+0x6c>
    iput(ip);
    80003158:	8552                	mv	a0,s4
    8000315a:	00000097          	auipc	ra,0x0
    8000315e:	acc080e7          	jalr	-1332(ra) # 80002c26 <iput>
    return 0;
    80003162:	4a01                	li	s4,0
    80003164:	b721                	j	8000306c <namex+0x6c>

0000000080003166 <dirlink>:
{
    80003166:	7139                	addi	sp,sp,-64
    80003168:	fc06                	sd	ra,56(sp)
    8000316a:	f822                	sd	s0,48(sp)
    8000316c:	f426                	sd	s1,40(sp)
    8000316e:	f04a                	sd	s2,32(sp)
    80003170:	ec4e                	sd	s3,24(sp)
    80003172:	e852                	sd	s4,16(sp)
    80003174:	0080                	addi	s0,sp,64
    80003176:	892a                	mv	s2,a0
    80003178:	8a2e                	mv	s4,a1
    8000317a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000317c:	4601                	li	a2,0
    8000317e:	00000097          	auipc	ra,0x0
    80003182:	dd2080e7          	jalr	-558(ra) # 80002f50 <dirlookup>
    80003186:	e93d                	bnez	a0,800031fc <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003188:	04c92483          	lw	s1,76(s2)
    8000318c:	c49d                	beqz	s1,800031ba <dirlink+0x54>
    8000318e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003190:	4741                	li	a4,16
    80003192:	86a6                	mv	a3,s1
    80003194:	fc040613          	addi	a2,s0,-64
    80003198:	4581                	li	a1,0
    8000319a:	854a                	mv	a0,s2
    8000319c:	00000097          	auipc	ra,0x0
    800031a0:	b84080e7          	jalr	-1148(ra) # 80002d20 <readi>
    800031a4:	47c1                	li	a5,16
    800031a6:	06f51163          	bne	a0,a5,80003208 <dirlink+0xa2>
    if(de.inum == 0)
    800031aa:	fc045783          	lhu	a5,-64(s0)
    800031ae:	c791                	beqz	a5,800031ba <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031b0:	24c1                	addiw	s1,s1,16
    800031b2:	04c92783          	lw	a5,76(s2)
    800031b6:	fcf4ede3          	bltu	s1,a5,80003190 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800031ba:	4639                	li	a2,14
    800031bc:	85d2                	mv	a1,s4
    800031be:	fc240513          	addi	a0,s0,-62
    800031c2:	ffffd097          	auipc	ra,0xffffd
    800031c6:	0c4080e7          	jalr	196(ra) # 80000286 <strncpy>
  de.inum = inum;
    800031ca:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031ce:	4741                	li	a4,16
    800031d0:	86a6                	mv	a3,s1
    800031d2:	fc040613          	addi	a2,s0,-64
    800031d6:	4581                	li	a1,0
    800031d8:	854a                	mv	a0,s2
    800031da:	00000097          	auipc	ra,0x0
    800031de:	c3e080e7          	jalr	-962(ra) # 80002e18 <writei>
    800031e2:	872a                	mv	a4,a0
    800031e4:	47c1                	li	a5,16
  return 0;
    800031e6:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031e8:	02f71863          	bne	a4,a5,80003218 <dirlink+0xb2>
}
    800031ec:	70e2                	ld	ra,56(sp)
    800031ee:	7442                	ld	s0,48(sp)
    800031f0:	74a2                	ld	s1,40(sp)
    800031f2:	7902                	ld	s2,32(sp)
    800031f4:	69e2                	ld	s3,24(sp)
    800031f6:	6a42                	ld	s4,16(sp)
    800031f8:	6121                	addi	sp,sp,64
    800031fa:	8082                	ret
    iput(ip);
    800031fc:	00000097          	auipc	ra,0x0
    80003200:	a2a080e7          	jalr	-1494(ra) # 80002c26 <iput>
    return -1;
    80003204:	557d                	li	a0,-1
    80003206:	b7dd                	j	800031ec <dirlink+0x86>
      panic("dirlink read");
    80003208:	00005517          	auipc	a0,0x5
    8000320c:	38850513          	addi	a0,a0,904 # 80008590 <syscalls+0x1c8>
    80003210:	00003097          	auipc	ra,0x3
    80003214:	8d0080e7          	jalr	-1840(ra) # 80005ae0 <panic>
    panic("dirlink");
    80003218:	00005517          	auipc	a0,0x5
    8000321c:	48850513          	addi	a0,a0,1160 # 800086a0 <syscalls+0x2d8>
    80003220:	00003097          	auipc	ra,0x3
    80003224:	8c0080e7          	jalr	-1856(ra) # 80005ae0 <panic>

0000000080003228 <namei>:

struct inode*
namei(char *path)
{
    80003228:	1101                	addi	sp,sp,-32
    8000322a:	ec06                	sd	ra,24(sp)
    8000322c:	e822                	sd	s0,16(sp)
    8000322e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003230:	fe040613          	addi	a2,s0,-32
    80003234:	4581                	li	a1,0
    80003236:	00000097          	auipc	ra,0x0
    8000323a:	dca080e7          	jalr	-566(ra) # 80003000 <namex>
}
    8000323e:	60e2                	ld	ra,24(sp)
    80003240:	6442                	ld	s0,16(sp)
    80003242:	6105                	addi	sp,sp,32
    80003244:	8082                	ret

0000000080003246 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003246:	1141                	addi	sp,sp,-16
    80003248:	e406                	sd	ra,8(sp)
    8000324a:	e022                	sd	s0,0(sp)
    8000324c:	0800                	addi	s0,sp,16
    8000324e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003250:	4585                	li	a1,1
    80003252:	00000097          	auipc	ra,0x0
    80003256:	dae080e7          	jalr	-594(ra) # 80003000 <namex>
}
    8000325a:	60a2                	ld	ra,8(sp)
    8000325c:	6402                	ld	s0,0(sp)
    8000325e:	0141                	addi	sp,sp,16
    80003260:	8082                	ret

0000000080003262 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003262:	1101                	addi	sp,sp,-32
    80003264:	ec06                	sd	ra,24(sp)
    80003266:	e822                	sd	s0,16(sp)
    80003268:	e426                	sd	s1,8(sp)
    8000326a:	e04a                	sd	s2,0(sp)
    8000326c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000326e:	00016917          	auipc	s2,0x16
    80003272:	db290913          	addi	s2,s2,-590 # 80019020 <log>
    80003276:	01892583          	lw	a1,24(s2)
    8000327a:	02892503          	lw	a0,40(s2)
    8000327e:	fffff097          	auipc	ra,0xfffff
    80003282:	fec080e7          	jalr	-20(ra) # 8000226a <bread>
    80003286:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003288:	02c92683          	lw	a3,44(s2)
    8000328c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000328e:	02d05863          	blez	a3,800032be <write_head+0x5c>
    80003292:	00016797          	auipc	a5,0x16
    80003296:	dbe78793          	addi	a5,a5,-578 # 80019050 <log+0x30>
    8000329a:	05c50713          	addi	a4,a0,92
    8000329e:	36fd                	addiw	a3,a3,-1
    800032a0:	02069613          	slli	a2,a3,0x20
    800032a4:	01e65693          	srli	a3,a2,0x1e
    800032a8:	00016617          	auipc	a2,0x16
    800032ac:	dac60613          	addi	a2,a2,-596 # 80019054 <log+0x34>
    800032b0:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800032b2:	4390                	lw	a2,0(a5)
    800032b4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800032b6:	0791                	addi	a5,a5,4
    800032b8:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800032ba:	fed79ce3          	bne	a5,a3,800032b2 <write_head+0x50>
  }
  bwrite(buf);
    800032be:	8526                	mv	a0,s1
    800032c0:	fffff097          	auipc	ra,0xfffff
    800032c4:	09c080e7          	jalr	156(ra) # 8000235c <bwrite>
  brelse(buf);
    800032c8:	8526                	mv	a0,s1
    800032ca:	fffff097          	auipc	ra,0xfffff
    800032ce:	0d0080e7          	jalr	208(ra) # 8000239a <brelse>
}
    800032d2:	60e2                	ld	ra,24(sp)
    800032d4:	6442                	ld	s0,16(sp)
    800032d6:	64a2                	ld	s1,8(sp)
    800032d8:	6902                	ld	s2,0(sp)
    800032da:	6105                	addi	sp,sp,32
    800032dc:	8082                	ret

00000000800032de <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800032de:	00016797          	auipc	a5,0x16
    800032e2:	d6e7a783          	lw	a5,-658(a5) # 8001904c <log+0x2c>
    800032e6:	0af05d63          	blez	a5,800033a0 <install_trans+0xc2>
{
    800032ea:	7139                	addi	sp,sp,-64
    800032ec:	fc06                	sd	ra,56(sp)
    800032ee:	f822                	sd	s0,48(sp)
    800032f0:	f426                	sd	s1,40(sp)
    800032f2:	f04a                	sd	s2,32(sp)
    800032f4:	ec4e                	sd	s3,24(sp)
    800032f6:	e852                	sd	s4,16(sp)
    800032f8:	e456                	sd	s5,8(sp)
    800032fa:	e05a                	sd	s6,0(sp)
    800032fc:	0080                	addi	s0,sp,64
    800032fe:	8b2a                	mv	s6,a0
    80003300:	00016a97          	auipc	s5,0x16
    80003304:	d50a8a93          	addi	s5,s5,-688 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003308:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000330a:	00016997          	auipc	s3,0x16
    8000330e:	d1698993          	addi	s3,s3,-746 # 80019020 <log>
    80003312:	a00d                	j	80003334 <install_trans+0x56>
    brelse(lbuf);
    80003314:	854a                	mv	a0,s2
    80003316:	fffff097          	auipc	ra,0xfffff
    8000331a:	084080e7          	jalr	132(ra) # 8000239a <brelse>
    brelse(dbuf);
    8000331e:	8526                	mv	a0,s1
    80003320:	fffff097          	auipc	ra,0xfffff
    80003324:	07a080e7          	jalr	122(ra) # 8000239a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003328:	2a05                	addiw	s4,s4,1
    8000332a:	0a91                	addi	s5,s5,4
    8000332c:	02c9a783          	lw	a5,44(s3)
    80003330:	04fa5e63          	bge	s4,a5,8000338c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003334:	0189a583          	lw	a1,24(s3)
    80003338:	014585bb          	addw	a1,a1,s4
    8000333c:	2585                	addiw	a1,a1,1
    8000333e:	0289a503          	lw	a0,40(s3)
    80003342:	fffff097          	auipc	ra,0xfffff
    80003346:	f28080e7          	jalr	-216(ra) # 8000226a <bread>
    8000334a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000334c:	000aa583          	lw	a1,0(s5)
    80003350:	0289a503          	lw	a0,40(s3)
    80003354:	fffff097          	auipc	ra,0xfffff
    80003358:	f16080e7          	jalr	-234(ra) # 8000226a <bread>
    8000335c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000335e:	40000613          	li	a2,1024
    80003362:	05890593          	addi	a1,s2,88
    80003366:	05850513          	addi	a0,a0,88
    8000336a:	ffffd097          	auipc	ra,0xffffd
    8000336e:	e6c080e7          	jalr	-404(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003372:	8526                	mv	a0,s1
    80003374:	fffff097          	auipc	ra,0xfffff
    80003378:	fe8080e7          	jalr	-24(ra) # 8000235c <bwrite>
    if(recovering == 0)
    8000337c:	f80b1ce3          	bnez	s6,80003314 <install_trans+0x36>
      bunpin(dbuf);
    80003380:	8526                	mv	a0,s1
    80003382:	fffff097          	auipc	ra,0xfffff
    80003386:	0f2080e7          	jalr	242(ra) # 80002474 <bunpin>
    8000338a:	b769                	j	80003314 <install_trans+0x36>
}
    8000338c:	70e2                	ld	ra,56(sp)
    8000338e:	7442                	ld	s0,48(sp)
    80003390:	74a2                	ld	s1,40(sp)
    80003392:	7902                	ld	s2,32(sp)
    80003394:	69e2                	ld	s3,24(sp)
    80003396:	6a42                	ld	s4,16(sp)
    80003398:	6aa2                	ld	s5,8(sp)
    8000339a:	6b02                	ld	s6,0(sp)
    8000339c:	6121                	addi	sp,sp,64
    8000339e:	8082                	ret
    800033a0:	8082                	ret

00000000800033a2 <initlog>:
{
    800033a2:	7179                	addi	sp,sp,-48
    800033a4:	f406                	sd	ra,40(sp)
    800033a6:	f022                	sd	s0,32(sp)
    800033a8:	ec26                	sd	s1,24(sp)
    800033aa:	e84a                	sd	s2,16(sp)
    800033ac:	e44e                	sd	s3,8(sp)
    800033ae:	1800                	addi	s0,sp,48
    800033b0:	892a                	mv	s2,a0
    800033b2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800033b4:	00016497          	auipc	s1,0x16
    800033b8:	c6c48493          	addi	s1,s1,-916 # 80019020 <log>
    800033bc:	00005597          	auipc	a1,0x5
    800033c0:	1e458593          	addi	a1,a1,484 # 800085a0 <syscalls+0x1d8>
    800033c4:	8526                	mv	a0,s1
    800033c6:	00003097          	auipc	ra,0x3
    800033ca:	bc2080e7          	jalr	-1086(ra) # 80005f88 <initlock>
  log.start = sb->logstart;
    800033ce:	0149a583          	lw	a1,20(s3)
    800033d2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800033d4:	0109a783          	lw	a5,16(s3)
    800033d8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800033da:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800033de:	854a                	mv	a0,s2
    800033e0:	fffff097          	auipc	ra,0xfffff
    800033e4:	e8a080e7          	jalr	-374(ra) # 8000226a <bread>
  log.lh.n = lh->n;
    800033e8:	4d34                	lw	a3,88(a0)
    800033ea:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800033ec:	02d05663          	blez	a3,80003418 <initlog+0x76>
    800033f0:	05c50793          	addi	a5,a0,92
    800033f4:	00016717          	auipc	a4,0x16
    800033f8:	c5c70713          	addi	a4,a4,-932 # 80019050 <log+0x30>
    800033fc:	36fd                	addiw	a3,a3,-1
    800033fe:	02069613          	slli	a2,a3,0x20
    80003402:	01e65693          	srli	a3,a2,0x1e
    80003406:	06050613          	addi	a2,a0,96
    8000340a:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000340c:	4390                	lw	a2,0(a5)
    8000340e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003410:	0791                	addi	a5,a5,4
    80003412:	0711                	addi	a4,a4,4
    80003414:	fed79ce3          	bne	a5,a3,8000340c <initlog+0x6a>
  brelse(buf);
    80003418:	fffff097          	auipc	ra,0xfffff
    8000341c:	f82080e7          	jalr	-126(ra) # 8000239a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003420:	4505                	li	a0,1
    80003422:	00000097          	auipc	ra,0x0
    80003426:	ebc080e7          	jalr	-324(ra) # 800032de <install_trans>
  log.lh.n = 0;
    8000342a:	00016797          	auipc	a5,0x16
    8000342e:	c207a123          	sw	zero,-990(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    80003432:	00000097          	auipc	ra,0x0
    80003436:	e30080e7          	jalr	-464(ra) # 80003262 <write_head>
}
    8000343a:	70a2                	ld	ra,40(sp)
    8000343c:	7402                	ld	s0,32(sp)
    8000343e:	64e2                	ld	s1,24(sp)
    80003440:	6942                	ld	s2,16(sp)
    80003442:	69a2                	ld	s3,8(sp)
    80003444:	6145                	addi	sp,sp,48
    80003446:	8082                	ret

0000000080003448 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003448:	1101                	addi	sp,sp,-32
    8000344a:	ec06                	sd	ra,24(sp)
    8000344c:	e822                	sd	s0,16(sp)
    8000344e:	e426                	sd	s1,8(sp)
    80003450:	e04a                	sd	s2,0(sp)
    80003452:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003454:	00016517          	auipc	a0,0x16
    80003458:	bcc50513          	addi	a0,a0,-1076 # 80019020 <log>
    8000345c:	00003097          	auipc	ra,0x3
    80003460:	bbc080e7          	jalr	-1092(ra) # 80006018 <acquire>
  while(1){
    if(log.committing){
    80003464:	00016497          	auipc	s1,0x16
    80003468:	bbc48493          	addi	s1,s1,-1092 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000346c:	4979                	li	s2,30
    8000346e:	a039                	j	8000347c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003470:	85a6                	mv	a1,s1
    80003472:	8526                	mv	a0,s1
    80003474:	ffffe097          	auipc	ra,0xffffe
    80003478:	094080e7          	jalr	148(ra) # 80001508 <sleep>
    if(log.committing){
    8000347c:	50dc                	lw	a5,36(s1)
    8000347e:	fbed                	bnez	a5,80003470 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003480:	5098                	lw	a4,32(s1)
    80003482:	2705                	addiw	a4,a4,1
    80003484:	0007069b          	sext.w	a3,a4
    80003488:	0027179b          	slliw	a5,a4,0x2
    8000348c:	9fb9                	addw	a5,a5,a4
    8000348e:	0017979b          	slliw	a5,a5,0x1
    80003492:	54d8                	lw	a4,44(s1)
    80003494:	9fb9                	addw	a5,a5,a4
    80003496:	00f95963          	bge	s2,a5,800034a8 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000349a:	85a6                	mv	a1,s1
    8000349c:	8526                	mv	a0,s1
    8000349e:	ffffe097          	auipc	ra,0xffffe
    800034a2:	06a080e7          	jalr	106(ra) # 80001508 <sleep>
    800034a6:	bfd9                	j	8000347c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800034a8:	00016517          	auipc	a0,0x16
    800034ac:	b7850513          	addi	a0,a0,-1160 # 80019020 <log>
    800034b0:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800034b2:	00003097          	auipc	ra,0x3
    800034b6:	c1a080e7          	jalr	-998(ra) # 800060cc <release>
      break;
    }
  }
}
    800034ba:	60e2                	ld	ra,24(sp)
    800034bc:	6442                	ld	s0,16(sp)
    800034be:	64a2                	ld	s1,8(sp)
    800034c0:	6902                	ld	s2,0(sp)
    800034c2:	6105                	addi	sp,sp,32
    800034c4:	8082                	ret

00000000800034c6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800034c6:	7139                	addi	sp,sp,-64
    800034c8:	fc06                	sd	ra,56(sp)
    800034ca:	f822                	sd	s0,48(sp)
    800034cc:	f426                	sd	s1,40(sp)
    800034ce:	f04a                	sd	s2,32(sp)
    800034d0:	ec4e                	sd	s3,24(sp)
    800034d2:	e852                	sd	s4,16(sp)
    800034d4:	e456                	sd	s5,8(sp)
    800034d6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800034d8:	00016497          	auipc	s1,0x16
    800034dc:	b4848493          	addi	s1,s1,-1208 # 80019020 <log>
    800034e0:	8526                	mv	a0,s1
    800034e2:	00003097          	auipc	ra,0x3
    800034e6:	b36080e7          	jalr	-1226(ra) # 80006018 <acquire>
  log.outstanding -= 1;
    800034ea:	509c                	lw	a5,32(s1)
    800034ec:	37fd                	addiw	a5,a5,-1
    800034ee:	0007891b          	sext.w	s2,a5
    800034f2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800034f4:	50dc                	lw	a5,36(s1)
    800034f6:	e7b9                	bnez	a5,80003544 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800034f8:	04091e63          	bnez	s2,80003554 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800034fc:	00016497          	auipc	s1,0x16
    80003500:	b2448493          	addi	s1,s1,-1244 # 80019020 <log>
    80003504:	4785                	li	a5,1
    80003506:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003508:	8526                	mv	a0,s1
    8000350a:	00003097          	auipc	ra,0x3
    8000350e:	bc2080e7          	jalr	-1086(ra) # 800060cc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003512:	54dc                	lw	a5,44(s1)
    80003514:	06f04763          	bgtz	a5,80003582 <end_op+0xbc>
    acquire(&log.lock);
    80003518:	00016497          	auipc	s1,0x16
    8000351c:	b0848493          	addi	s1,s1,-1272 # 80019020 <log>
    80003520:	8526                	mv	a0,s1
    80003522:	00003097          	auipc	ra,0x3
    80003526:	af6080e7          	jalr	-1290(ra) # 80006018 <acquire>
    log.committing = 0;
    8000352a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000352e:	8526                	mv	a0,s1
    80003530:	ffffe097          	auipc	ra,0xffffe
    80003534:	164080e7          	jalr	356(ra) # 80001694 <wakeup>
    release(&log.lock);
    80003538:	8526                	mv	a0,s1
    8000353a:	00003097          	auipc	ra,0x3
    8000353e:	b92080e7          	jalr	-1134(ra) # 800060cc <release>
}
    80003542:	a03d                	j	80003570 <end_op+0xaa>
    panic("log.committing");
    80003544:	00005517          	auipc	a0,0x5
    80003548:	06450513          	addi	a0,a0,100 # 800085a8 <syscalls+0x1e0>
    8000354c:	00002097          	auipc	ra,0x2
    80003550:	594080e7          	jalr	1428(ra) # 80005ae0 <panic>
    wakeup(&log);
    80003554:	00016497          	auipc	s1,0x16
    80003558:	acc48493          	addi	s1,s1,-1332 # 80019020 <log>
    8000355c:	8526                	mv	a0,s1
    8000355e:	ffffe097          	auipc	ra,0xffffe
    80003562:	136080e7          	jalr	310(ra) # 80001694 <wakeup>
  release(&log.lock);
    80003566:	8526                	mv	a0,s1
    80003568:	00003097          	auipc	ra,0x3
    8000356c:	b64080e7          	jalr	-1180(ra) # 800060cc <release>
}
    80003570:	70e2                	ld	ra,56(sp)
    80003572:	7442                	ld	s0,48(sp)
    80003574:	74a2                	ld	s1,40(sp)
    80003576:	7902                	ld	s2,32(sp)
    80003578:	69e2                	ld	s3,24(sp)
    8000357a:	6a42                	ld	s4,16(sp)
    8000357c:	6aa2                	ld	s5,8(sp)
    8000357e:	6121                	addi	sp,sp,64
    80003580:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003582:	00016a97          	auipc	s5,0x16
    80003586:	acea8a93          	addi	s5,s5,-1330 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000358a:	00016a17          	auipc	s4,0x16
    8000358e:	a96a0a13          	addi	s4,s4,-1386 # 80019020 <log>
    80003592:	018a2583          	lw	a1,24(s4)
    80003596:	012585bb          	addw	a1,a1,s2
    8000359a:	2585                	addiw	a1,a1,1
    8000359c:	028a2503          	lw	a0,40(s4)
    800035a0:	fffff097          	auipc	ra,0xfffff
    800035a4:	cca080e7          	jalr	-822(ra) # 8000226a <bread>
    800035a8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800035aa:	000aa583          	lw	a1,0(s5)
    800035ae:	028a2503          	lw	a0,40(s4)
    800035b2:	fffff097          	auipc	ra,0xfffff
    800035b6:	cb8080e7          	jalr	-840(ra) # 8000226a <bread>
    800035ba:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800035bc:	40000613          	li	a2,1024
    800035c0:	05850593          	addi	a1,a0,88
    800035c4:	05848513          	addi	a0,s1,88
    800035c8:	ffffd097          	auipc	ra,0xffffd
    800035cc:	c0e080e7          	jalr	-1010(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800035d0:	8526                	mv	a0,s1
    800035d2:	fffff097          	auipc	ra,0xfffff
    800035d6:	d8a080e7          	jalr	-630(ra) # 8000235c <bwrite>
    brelse(from);
    800035da:	854e                	mv	a0,s3
    800035dc:	fffff097          	auipc	ra,0xfffff
    800035e0:	dbe080e7          	jalr	-578(ra) # 8000239a <brelse>
    brelse(to);
    800035e4:	8526                	mv	a0,s1
    800035e6:	fffff097          	auipc	ra,0xfffff
    800035ea:	db4080e7          	jalr	-588(ra) # 8000239a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035ee:	2905                	addiw	s2,s2,1
    800035f0:	0a91                	addi	s5,s5,4
    800035f2:	02ca2783          	lw	a5,44(s4)
    800035f6:	f8f94ee3          	blt	s2,a5,80003592 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800035fa:	00000097          	auipc	ra,0x0
    800035fe:	c68080e7          	jalr	-920(ra) # 80003262 <write_head>
    install_trans(0); // Now install writes to home locations
    80003602:	4501                	li	a0,0
    80003604:	00000097          	auipc	ra,0x0
    80003608:	cda080e7          	jalr	-806(ra) # 800032de <install_trans>
    log.lh.n = 0;
    8000360c:	00016797          	auipc	a5,0x16
    80003610:	a407a023          	sw	zero,-1472(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003614:	00000097          	auipc	ra,0x0
    80003618:	c4e080e7          	jalr	-946(ra) # 80003262 <write_head>
    8000361c:	bdf5                	j	80003518 <end_op+0x52>

000000008000361e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000361e:	1101                	addi	sp,sp,-32
    80003620:	ec06                	sd	ra,24(sp)
    80003622:	e822                	sd	s0,16(sp)
    80003624:	e426                	sd	s1,8(sp)
    80003626:	e04a                	sd	s2,0(sp)
    80003628:	1000                	addi	s0,sp,32
    8000362a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000362c:	00016917          	auipc	s2,0x16
    80003630:	9f490913          	addi	s2,s2,-1548 # 80019020 <log>
    80003634:	854a                	mv	a0,s2
    80003636:	00003097          	auipc	ra,0x3
    8000363a:	9e2080e7          	jalr	-1566(ra) # 80006018 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000363e:	02c92603          	lw	a2,44(s2)
    80003642:	47f5                	li	a5,29
    80003644:	06c7c563          	blt	a5,a2,800036ae <log_write+0x90>
    80003648:	00016797          	auipc	a5,0x16
    8000364c:	9f47a783          	lw	a5,-1548(a5) # 8001903c <log+0x1c>
    80003650:	37fd                	addiw	a5,a5,-1
    80003652:	04f65e63          	bge	a2,a5,800036ae <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003656:	00016797          	auipc	a5,0x16
    8000365a:	9ea7a783          	lw	a5,-1558(a5) # 80019040 <log+0x20>
    8000365e:	06f05063          	blez	a5,800036be <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003662:	4781                	li	a5,0
    80003664:	06c05563          	blez	a2,800036ce <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003668:	44cc                	lw	a1,12(s1)
    8000366a:	00016717          	auipc	a4,0x16
    8000366e:	9e670713          	addi	a4,a4,-1562 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003672:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003674:	4314                	lw	a3,0(a4)
    80003676:	04b68c63          	beq	a3,a1,800036ce <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000367a:	2785                	addiw	a5,a5,1
    8000367c:	0711                	addi	a4,a4,4
    8000367e:	fef61be3          	bne	a2,a5,80003674 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003682:	0621                	addi	a2,a2,8
    80003684:	060a                	slli	a2,a2,0x2
    80003686:	00016797          	auipc	a5,0x16
    8000368a:	99a78793          	addi	a5,a5,-1638 # 80019020 <log>
    8000368e:	97b2                	add	a5,a5,a2
    80003690:	44d8                	lw	a4,12(s1)
    80003692:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003694:	8526                	mv	a0,s1
    80003696:	fffff097          	auipc	ra,0xfffff
    8000369a:	da2080e7          	jalr	-606(ra) # 80002438 <bpin>
    log.lh.n++;
    8000369e:	00016717          	auipc	a4,0x16
    800036a2:	98270713          	addi	a4,a4,-1662 # 80019020 <log>
    800036a6:	575c                	lw	a5,44(a4)
    800036a8:	2785                	addiw	a5,a5,1
    800036aa:	d75c                	sw	a5,44(a4)
    800036ac:	a82d                	j	800036e6 <log_write+0xc8>
    panic("too big a transaction");
    800036ae:	00005517          	auipc	a0,0x5
    800036b2:	f0a50513          	addi	a0,a0,-246 # 800085b8 <syscalls+0x1f0>
    800036b6:	00002097          	auipc	ra,0x2
    800036ba:	42a080e7          	jalr	1066(ra) # 80005ae0 <panic>
    panic("log_write outside of trans");
    800036be:	00005517          	auipc	a0,0x5
    800036c2:	f1250513          	addi	a0,a0,-238 # 800085d0 <syscalls+0x208>
    800036c6:	00002097          	auipc	ra,0x2
    800036ca:	41a080e7          	jalr	1050(ra) # 80005ae0 <panic>
  log.lh.block[i] = b->blockno;
    800036ce:	00878693          	addi	a3,a5,8
    800036d2:	068a                	slli	a3,a3,0x2
    800036d4:	00016717          	auipc	a4,0x16
    800036d8:	94c70713          	addi	a4,a4,-1716 # 80019020 <log>
    800036dc:	9736                	add	a4,a4,a3
    800036de:	44d4                	lw	a3,12(s1)
    800036e0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800036e2:	faf609e3          	beq	a2,a5,80003694 <log_write+0x76>
  }
  release(&log.lock);
    800036e6:	00016517          	auipc	a0,0x16
    800036ea:	93a50513          	addi	a0,a0,-1734 # 80019020 <log>
    800036ee:	00003097          	auipc	ra,0x3
    800036f2:	9de080e7          	jalr	-1570(ra) # 800060cc <release>
}
    800036f6:	60e2                	ld	ra,24(sp)
    800036f8:	6442                	ld	s0,16(sp)
    800036fa:	64a2                	ld	s1,8(sp)
    800036fc:	6902                	ld	s2,0(sp)
    800036fe:	6105                	addi	sp,sp,32
    80003700:	8082                	ret

0000000080003702 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003702:	1101                	addi	sp,sp,-32
    80003704:	ec06                	sd	ra,24(sp)
    80003706:	e822                	sd	s0,16(sp)
    80003708:	e426                	sd	s1,8(sp)
    8000370a:	e04a                	sd	s2,0(sp)
    8000370c:	1000                	addi	s0,sp,32
    8000370e:	84aa                	mv	s1,a0
    80003710:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003712:	00005597          	auipc	a1,0x5
    80003716:	ede58593          	addi	a1,a1,-290 # 800085f0 <syscalls+0x228>
    8000371a:	0521                	addi	a0,a0,8
    8000371c:	00003097          	auipc	ra,0x3
    80003720:	86c080e7          	jalr	-1940(ra) # 80005f88 <initlock>
  lk->name = name;
    80003724:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003728:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000372c:	0204a423          	sw	zero,40(s1)
}
    80003730:	60e2                	ld	ra,24(sp)
    80003732:	6442                	ld	s0,16(sp)
    80003734:	64a2                	ld	s1,8(sp)
    80003736:	6902                	ld	s2,0(sp)
    80003738:	6105                	addi	sp,sp,32
    8000373a:	8082                	ret

000000008000373c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000373c:	1101                	addi	sp,sp,-32
    8000373e:	ec06                	sd	ra,24(sp)
    80003740:	e822                	sd	s0,16(sp)
    80003742:	e426                	sd	s1,8(sp)
    80003744:	e04a                	sd	s2,0(sp)
    80003746:	1000                	addi	s0,sp,32
    80003748:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000374a:	00850913          	addi	s2,a0,8
    8000374e:	854a                	mv	a0,s2
    80003750:	00003097          	auipc	ra,0x3
    80003754:	8c8080e7          	jalr	-1848(ra) # 80006018 <acquire>
  while (lk->locked) {
    80003758:	409c                	lw	a5,0(s1)
    8000375a:	cb89                	beqz	a5,8000376c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000375c:	85ca                	mv	a1,s2
    8000375e:	8526                	mv	a0,s1
    80003760:	ffffe097          	auipc	ra,0xffffe
    80003764:	da8080e7          	jalr	-600(ra) # 80001508 <sleep>
  while (lk->locked) {
    80003768:	409c                	lw	a5,0(s1)
    8000376a:	fbed                	bnez	a5,8000375c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000376c:	4785                	li	a5,1
    8000376e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003770:	ffffd097          	auipc	ra,0xffffd
    80003774:	6d4080e7          	jalr	1748(ra) # 80000e44 <myproc>
    80003778:	591c                	lw	a5,48(a0)
    8000377a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000377c:	854a                	mv	a0,s2
    8000377e:	00003097          	auipc	ra,0x3
    80003782:	94e080e7          	jalr	-1714(ra) # 800060cc <release>
}
    80003786:	60e2                	ld	ra,24(sp)
    80003788:	6442                	ld	s0,16(sp)
    8000378a:	64a2                	ld	s1,8(sp)
    8000378c:	6902                	ld	s2,0(sp)
    8000378e:	6105                	addi	sp,sp,32
    80003790:	8082                	ret

0000000080003792 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003792:	1101                	addi	sp,sp,-32
    80003794:	ec06                	sd	ra,24(sp)
    80003796:	e822                	sd	s0,16(sp)
    80003798:	e426                	sd	s1,8(sp)
    8000379a:	e04a                	sd	s2,0(sp)
    8000379c:	1000                	addi	s0,sp,32
    8000379e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037a0:	00850913          	addi	s2,a0,8
    800037a4:	854a                	mv	a0,s2
    800037a6:	00003097          	auipc	ra,0x3
    800037aa:	872080e7          	jalr	-1934(ra) # 80006018 <acquire>
  lk->locked = 0;
    800037ae:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037b2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800037b6:	8526                	mv	a0,s1
    800037b8:	ffffe097          	auipc	ra,0xffffe
    800037bc:	edc080e7          	jalr	-292(ra) # 80001694 <wakeup>
  release(&lk->lk);
    800037c0:	854a                	mv	a0,s2
    800037c2:	00003097          	auipc	ra,0x3
    800037c6:	90a080e7          	jalr	-1782(ra) # 800060cc <release>
}
    800037ca:	60e2                	ld	ra,24(sp)
    800037cc:	6442                	ld	s0,16(sp)
    800037ce:	64a2                	ld	s1,8(sp)
    800037d0:	6902                	ld	s2,0(sp)
    800037d2:	6105                	addi	sp,sp,32
    800037d4:	8082                	ret

00000000800037d6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800037d6:	7179                	addi	sp,sp,-48
    800037d8:	f406                	sd	ra,40(sp)
    800037da:	f022                	sd	s0,32(sp)
    800037dc:	ec26                	sd	s1,24(sp)
    800037de:	e84a                	sd	s2,16(sp)
    800037e0:	e44e                	sd	s3,8(sp)
    800037e2:	1800                	addi	s0,sp,48
    800037e4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800037e6:	00850913          	addi	s2,a0,8
    800037ea:	854a                	mv	a0,s2
    800037ec:	00003097          	auipc	ra,0x3
    800037f0:	82c080e7          	jalr	-2004(ra) # 80006018 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800037f4:	409c                	lw	a5,0(s1)
    800037f6:	ef99                	bnez	a5,80003814 <holdingsleep+0x3e>
    800037f8:	4481                	li	s1,0
  release(&lk->lk);
    800037fa:	854a                	mv	a0,s2
    800037fc:	00003097          	auipc	ra,0x3
    80003800:	8d0080e7          	jalr	-1840(ra) # 800060cc <release>
  return r;
}
    80003804:	8526                	mv	a0,s1
    80003806:	70a2                	ld	ra,40(sp)
    80003808:	7402                	ld	s0,32(sp)
    8000380a:	64e2                	ld	s1,24(sp)
    8000380c:	6942                	ld	s2,16(sp)
    8000380e:	69a2                	ld	s3,8(sp)
    80003810:	6145                	addi	sp,sp,48
    80003812:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003814:	0284a983          	lw	s3,40(s1)
    80003818:	ffffd097          	auipc	ra,0xffffd
    8000381c:	62c080e7          	jalr	1580(ra) # 80000e44 <myproc>
    80003820:	5904                	lw	s1,48(a0)
    80003822:	413484b3          	sub	s1,s1,s3
    80003826:	0014b493          	seqz	s1,s1
    8000382a:	bfc1                	j	800037fa <holdingsleep+0x24>

000000008000382c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000382c:	1141                	addi	sp,sp,-16
    8000382e:	e406                	sd	ra,8(sp)
    80003830:	e022                	sd	s0,0(sp)
    80003832:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003834:	00005597          	auipc	a1,0x5
    80003838:	dcc58593          	addi	a1,a1,-564 # 80008600 <syscalls+0x238>
    8000383c:	00016517          	auipc	a0,0x16
    80003840:	92c50513          	addi	a0,a0,-1748 # 80019168 <ftable>
    80003844:	00002097          	auipc	ra,0x2
    80003848:	744080e7          	jalr	1860(ra) # 80005f88 <initlock>
}
    8000384c:	60a2                	ld	ra,8(sp)
    8000384e:	6402                	ld	s0,0(sp)
    80003850:	0141                	addi	sp,sp,16
    80003852:	8082                	ret

0000000080003854 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003854:	1101                	addi	sp,sp,-32
    80003856:	ec06                	sd	ra,24(sp)
    80003858:	e822                	sd	s0,16(sp)
    8000385a:	e426                	sd	s1,8(sp)
    8000385c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000385e:	00016517          	auipc	a0,0x16
    80003862:	90a50513          	addi	a0,a0,-1782 # 80019168 <ftable>
    80003866:	00002097          	auipc	ra,0x2
    8000386a:	7b2080e7          	jalr	1970(ra) # 80006018 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000386e:	00016497          	auipc	s1,0x16
    80003872:	91248493          	addi	s1,s1,-1774 # 80019180 <ftable+0x18>
    80003876:	00017717          	auipc	a4,0x17
    8000387a:	8aa70713          	addi	a4,a4,-1878 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    8000387e:	40dc                	lw	a5,4(s1)
    80003880:	cf99                	beqz	a5,8000389e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003882:	02848493          	addi	s1,s1,40
    80003886:	fee49ce3          	bne	s1,a4,8000387e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000388a:	00016517          	auipc	a0,0x16
    8000388e:	8de50513          	addi	a0,a0,-1826 # 80019168 <ftable>
    80003892:	00003097          	auipc	ra,0x3
    80003896:	83a080e7          	jalr	-1990(ra) # 800060cc <release>
  return 0;
    8000389a:	4481                	li	s1,0
    8000389c:	a819                	j	800038b2 <filealloc+0x5e>
      f->ref = 1;
    8000389e:	4785                	li	a5,1
    800038a0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800038a2:	00016517          	auipc	a0,0x16
    800038a6:	8c650513          	addi	a0,a0,-1850 # 80019168 <ftable>
    800038aa:	00003097          	auipc	ra,0x3
    800038ae:	822080e7          	jalr	-2014(ra) # 800060cc <release>
}
    800038b2:	8526                	mv	a0,s1
    800038b4:	60e2                	ld	ra,24(sp)
    800038b6:	6442                	ld	s0,16(sp)
    800038b8:	64a2                	ld	s1,8(sp)
    800038ba:	6105                	addi	sp,sp,32
    800038bc:	8082                	ret

00000000800038be <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800038be:	1101                	addi	sp,sp,-32
    800038c0:	ec06                	sd	ra,24(sp)
    800038c2:	e822                	sd	s0,16(sp)
    800038c4:	e426                	sd	s1,8(sp)
    800038c6:	1000                	addi	s0,sp,32
    800038c8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800038ca:	00016517          	auipc	a0,0x16
    800038ce:	89e50513          	addi	a0,a0,-1890 # 80019168 <ftable>
    800038d2:	00002097          	auipc	ra,0x2
    800038d6:	746080e7          	jalr	1862(ra) # 80006018 <acquire>
  if(f->ref < 1)
    800038da:	40dc                	lw	a5,4(s1)
    800038dc:	02f05263          	blez	a5,80003900 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800038e0:	2785                	addiw	a5,a5,1
    800038e2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800038e4:	00016517          	auipc	a0,0x16
    800038e8:	88450513          	addi	a0,a0,-1916 # 80019168 <ftable>
    800038ec:	00002097          	auipc	ra,0x2
    800038f0:	7e0080e7          	jalr	2016(ra) # 800060cc <release>
  return f;
}
    800038f4:	8526                	mv	a0,s1
    800038f6:	60e2                	ld	ra,24(sp)
    800038f8:	6442                	ld	s0,16(sp)
    800038fa:	64a2                	ld	s1,8(sp)
    800038fc:	6105                	addi	sp,sp,32
    800038fe:	8082                	ret
    panic("filedup");
    80003900:	00005517          	auipc	a0,0x5
    80003904:	d0850513          	addi	a0,a0,-760 # 80008608 <syscalls+0x240>
    80003908:	00002097          	auipc	ra,0x2
    8000390c:	1d8080e7          	jalr	472(ra) # 80005ae0 <panic>

0000000080003910 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003910:	7139                	addi	sp,sp,-64
    80003912:	fc06                	sd	ra,56(sp)
    80003914:	f822                	sd	s0,48(sp)
    80003916:	f426                	sd	s1,40(sp)
    80003918:	f04a                	sd	s2,32(sp)
    8000391a:	ec4e                	sd	s3,24(sp)
    8000391c:	e852                	sd	s4,16(sp)
    8000391e:	e456                	sd	s5,8(sp)
    80003920:	0080                	addi	s0,sp,64
    80003922:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003924:	00016517          	auipc	a0,0x16
    80003928:	84450513          	addi	a0,a0,-1980 # 80019168 <ftable>
    8000392c:	00002097          	auipc	ra,0x2
    80003930:	6ec080e7          	jalr	1772(ra) # 80006018 <acquire>
  if(f->ref < 1)
    80003934:	40dc                	lw	a5,4(s1)
    80003936:	06f05163          	blez	a5,80003998 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000393a:	37fd                	addiw	a5,a5,-1
    8000393c:	0007871b          	sext.w	a4,a5
    80003940:	c0dc                	sw	a5,4(s1)
    80003942:	06e04363          	bgtz	a4,800039a8 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003946:	0004a903          	lw	s2,0(s1)
    8000394a:	0094ca83          	lbu	s5,9(s1)
    8000394e:	0104ba03          	ld	s4,16(s1)
    80003952:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003956:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000395a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000395e:	00016517          	auipc	a0,0x16
    80003962:	80a50513          	addi	a0,a0,-2038 # 80019168 <ftable>
    80003966:	00002097          	auipc	ra,0x2
    8000396a:	766080e7          	jalr	1894(ra) # 800060cc <release>

  if(ff.type == FD_PIPE){
    8000396e:	4785                	li	a5,1
    80003970:	04f90d63          	beq	s2,a5,800039ca <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003974:	3979                	addiw	s2,s2,-2
    80003976:	4785                	li	a5,1
    80003978:	0527e063          	bltu	a5,s2,800039b8 <fileclose+0xa8>
    begin_op();
    8000397c:	00000097          	auipc	ra,0x0
    80003980:	acc080e7          	jalr	-1332(ra) # 80003448 <begin_op>
    iput(ff.ip);
    80003984:	854e                	mv	a0,s3
    80003986:	fffff097          	auipc	ra,0xfffff
    8000398a:	2a0080e7          	jalr	672(ra) # 80002c26 <iput>
    end_op();
    8000398e:	00000097          	auipc	ra,0x0
    80003992:	b38080e7          	jalr	-1224(ra) # 800034c6 <end_op>
    80003996:	a00d                	j	800039b8 <fileclose+0xa8>
    panic("fileclose");
    80003998:	00005517          	auipc	a0,0x5
    8000399c:	c7850513          	addi	a0,a0,-904 # 80008610 <syscalls+0x248>
    800039a0:	00002097          	auipc	ra,0x2
    800039a4:	140080e7          	jalr	320(ra) # 80005ae0 <panic>
    release(&ftable.lock);
    800039a8:	00015517          	auipc	a0,0x15
    800039ac:	7c050513          	addi	a0,a0,1984 # 80019168 <ftable>
    800039b0:	00002097          	auipc	ra,0x2
    800039b4:	71c080e7          	jalr	1820(ra) # 800060cc <release>
  }
}
    800039b8:	70e2                	ld	ra,56(sp)
    800039ba:	7442                	ld	s0,48(sp)
    800039bc:	74a2                	ld	s1,40(sp)
    800039be:	7902                	ld	s2,32(sp)
    800039c0:	69e2                	ld	s3,24(sp)
    800039c2:	6a42                	ld	s4,16(sp)
    800039c4:	6aa2                	ld	s5,8(sp)
    800039c6:	6121                	addi	sp,sp,64
    800039c8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800039ca:	85d6                	mv	a1,s5
    800039cc:	8552                	mv	a0,s4
    800039ce:	00000097          	auipc	ra,0x0
    800039d2:	34c080e7          	jalr	844(ra) # 80003d1a <pipeclose>
    800039d6:	b7cd                	j	800039b8 <fileclose+0xa8>

00000000800039d8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800039d8:	715d                	addi	sp,sp,-80
    800039da:	e486                	sd	ra,72(sp)
    800039dc:	e0a2                	sd	s0,64(sp)
    800039de:	fc26                	sd	s1,56(sp)
    800039e0:	f84a                	sd	s2,48(sp)
    800039e2:	f44e                	sd	s3,40(sp)
    800039e4:	0880                	addi	s0,sp,80
    800039e6:	84aa                	mv	s1,a0
    800039e8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800039ea:	ffffd097          	auipc	ra,0xffffd
    800039ee:	45a080e7          	jalr	1114(ra) # 80000e44 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800039f2:	409c                	lw	a5,0(s1)
    800039f4:	37f9                	addiw	a5,a5,-2
    800039f6:	4705                	li	a4,1
    800039f8:	04f76763          	bltu	a4,a5,80003a46 <filestat+0x6e>
    800039fc:	892a                	mv	s2,a0
    ilock(f->ip);
    800039fe:	6c88                	ld	a0,24(s1)
    80003a00:	fffff097          	auipc	ra,0xfffff
    80003a04:	06c080e7          	jalr	108(ra) # 80002a6c <ilock>
    stati(f->ip, &st);
    80003a08:	fb840593          	addi	a1,s0,-72
    80003a0c:	6c88                	ld	a0,24(s1)
    80003a0e:	fffff097          	auipc	ra,0xfffff
    80003a12:	2e8080e7          	jalr	744(ra) # 80002cf6 <stati>
    iunlock(f->ip);
    80003a16:	6c88                	ld	a0,24(s1)
    80003a18:	fffff097          	auipc	ra,0xfffff
    80003a1c:	116080e7          	jalr	278(ra) # 80002b2e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a20:	46e1                	li	a3,24
    80003a22:	fb840613          	addi	a2,s0,-72
    80003a26:	85ce                	mv	a1,s3
    80003a28:	05093503          	ld	a0,80(s2)
    80003a2c:	ffffd097          	auipc	ra,0xffffd
    80003a30:	0dc080e7          	jalr	220(ra) # 80000b08 <copyout>
    80003a34:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003a38:	60a6                	ld	ra,72(sp)
    80003a3a:	6406                	ld	s0,64(sp)
    80003a3c:	74e2                	ld	s1,56(sp)
    80003a3e:	7942                	ld	s2,48(sp)
    80003a40:	79a2                	ld	s3,40(sp)
    80003a42:	6161                	addi	sp,sp,80
    80003a44:	8082                	ret
  return -1;
    80003a46:	557d                	li	a0,-1
    80003a48:	bfc5                	j	80003a38 <filestat+0x60>

0000000080003a4a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003a4a:	7179                	addi	sp,sp,-48
    80003a4c:	f406                	sd	ra,40(sp)
    80003a4e:	f022                	sd	s0,32(sp)
    80003a50:	ec26                	sd	s1,24(sp)
    80003a52:	e84a                	sd	s2,16(sp)
    80003a54:	e44e                	sd	s3,8(sp)
    80003a56:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003a58:	00854783          	lbu	a5,8(a0)
    80003a5c:	c3d5                	beqz	a5,80003b00 <fileread+0xb6>
    80003a5e:	84aa                	mv	s1,a0
    80003a60:	89ae                	mv	s3,a1
    80003a62:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003a64:	411c                	lw	a5,0(a0)
    80003a66:	4705                	li	a4,1
    80003a68:	04e78963          	beq	a5,a4,80003aba <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003a6c:	470d                	li	a4,3
    80003a6e:	04e78d63          	beq	a5,a4,80003ac8 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003a72:	4709                	li	a4,2
    80003a74:	06e79e63          	bne	a5,a4,80003af0 <fileread+0xa6>
    ilock(f->ip);
    80003a78:	6d08                	ld	a0,24(a0)
    80003a7a:	fffff097          	auipc	ra,0xfffff
    80003a7e:	ff2080e7          	jalr	-14(ra) # 80002a6c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003a82:	874a                	mv	a4,s2
    80003a84:	5094                	lw	a3,32(s1)
    80003a86:	864e                	mv	a2,s3
    80003a88:	4585                	li	a1,1
    80003a8a:	6c88                	ld	a0,24(s1)
    80003a8c:	fffff097          	auipc	ra,0xfffff
    80003a90:	294080e7          	jalr	660(ra) # 80002d20 <readi>
    80003a94:	892a                	mv	s2,a0
    80003a96:	00a05563          	blez	a0,80003aa0 <fileread+0x56>
      f->off += r;
    80003a9a:	509c                	lw	a5,32(s1)
    80003a9c:	9fa9                	addw	a5,a5,a0
    80003a9e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003aa0:	6c88                	ld	a0,24(s1)
    80003aa2:	fffff097          	auipc	ra,0xfffff
    80003aa6:	08c080e7          	jalr	140(ra) # 80002b2e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003aaa:	854a                	mv	a0,s2
    80003aac:	70a2                	ld	ra,40(sp)
    80003aae:	7402                	ld	s0,32(sp)
    80003ab0:	64e2                	ld	s1,24(sp)
    80003ab2:	6942                	ld	s2,16(sp)
    80003ab4:	69a2                	ld	s3,8(sp)
    80003ab6:	6145                	addi	sp,sp,48
    80003ab8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003aba:	6908                	ld	a0,16(a0)
    80003abc:	00000097          	auipc	ra,0x0
    80003ac0:	3c0080e7          	jalr	960(ra) # 80003e7c <piperead>
    80003ac4:	892a                	mv	s2,a0
    80003ac6:	b7d5                	j	80003aaa <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ac8:	02451783          	lh	a5,36(a0)
    80003acc:	03079693          	slli	a3,a5,0x30
    80003ad0:	92c1                	srli	a3,a3,0x30
    80003ad2:	4725                	li	a4,9
    80003ad4:	02d76863          	bltu	a4,a3,80003b04 <fileread+0xba>
    80003ad8:	0792                	slli	a5,a5,0x4
    80003ada:	00015717          	auipc	a4,0x15
    80003ade:	5ee70713          	addi	a4,a4,1518 # 800190c8 <devsw>
    80003ae2:	97ba                	add	a5,a5,a4
    80003ae4:	639c                	ld	a5,0(a5)
    80003ae6:	c38d                	beqz	a5,80003b08 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ae8:	4505                	li	a0,1
    80003aea:	9782                	jalr	a5
    80003aec:	892a                	mv	s2,a0
    80003aee:	bf75                	j	80003aaa <fileread+0x60>
    panic("fileread");
    80003af0:	00005517          	auipc	a0,0x5
    80003af4:	b3050513          	addi	a0,a0,-1232 # 80008620 <syscalls+0x258>
    80003af8:	00002097          	auipc	ra,0x2
    80003afc:	fe8080e7          	jalr	-24(ra) # 80005ae0 <panic>
    return -1;
    80003b00:	597d                	li	s2,-1
    80003b02:	b765                	j	80003aaa <fileread+0x60>
      return -1;
    80003b04:	597d                	li	s2,-1
    80003b06:	b755                	j	80003aaa <fileread+0x60>
    80003b08:	597d                	li	s2,-1
    80003b0a:	b745                	j	80003aaa <fileread+0x60>

0000000080003b0c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003b0c:	715d                	addi	sp,sp,-80
    80003b0e:	e486                	sd	ra,72(sp)
    80003b10:	e0a2                	sd	s0,64(sp)
    80003b12:	fc26                	sd	s1,56(sp)
    80003b14:	f84a                	sd	s2,48(sp)
    80003b16:	f44e                	sd	s3,40(sp)
    80003b18:	f052                	sd	s4,32(sp)
    80003b1a:	ec56                	sd	s5,24(sp)
    80003b1c:	e85a                	sd	s6,16(sp)
    80003b1e:	e45e                	sd	s7,8(sp)
    80003b20:	e062                	sd	s8,0(sp)
    80003b22:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003b24:	00954783          	lbu	a5,9(a0)
    80003b28:	10078663          	beqz	a5,80003c34 <filewrite+0x128>
    80003b2c:	892a                	mv	s2,a0
    80003b2e:	8b2e                	mv	s6,a1
    80003b30:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b32:	411c                	lw	a5,0(a0)
    80003b34:	4705                	li	a4,1
    80003b36:	02e78263          	beq	a5,a4,80003b5a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b3a:	470d                	li	a4,3
    80003b3c:	02e78663          	beq	a5,a4,80003b68 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b40:	4709                	li	a4,2
    80003b42:	0ee79163          	bne	a5,a4,80003c24 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003b46:	0ac05d63          	blez	a2,80003c00 <filewrite+0xf4>
    int i = 0;
    80003b4a:	4981                	li	s3,0
    80003b4c:	6b85                	lui	s7,0x1
    80003b4e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003b52:	6c05                	lui	s8,0x1
    80003b54:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003b58:	a861                	j	80003bf0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003b5a:	6908                	ld	a0,16(a0)
    80003b5c:	00000097          	auipc	ra,0x0
    80003b60:	22e080e7          	jalr	558(ra) # 80003d8a <pipewrite>
    80003b64:	8a2a                	mv	s4,a0
    80003b66:	a045                	j	80003c06 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003b68:	02451783          	lh	a5,36(a0)
    80003b6c:	03079693          	slli	a3,a5,0x30
    80003b70:	92c1                	srli	a3,a3,0x30
    80003b72:	4725                	li	a4,9
    80003b74:	0cd76263          	bltu	a4,a3,80003c38 <filewrite+0x12c>
    80003b78:	0792                	slli	a5,a5,0x4
    80003b7a:	00015717          	auipc	a4,0x15
    80003b7e:	54e70713          	addi	a4,a4,1358 # 800190c8 <devsw>
    80003b82:	97ba                	add	a5,a5,a4
    80003b84:	679c                	ld	a5,8(a5)
    80003b86:	cbdd                	beqz	a5,80003c3c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003b88:	4505                	li	a0,1
    80003b8a:	9782                	jalr	a5
    80003b8c:	8a2a                	mv	s4,a0
    80003b8e:	a8a5                	j	80003c06 <filewrite+0xfa>
    80003b90:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003b94:	00000097          	auipc	ra,0x0
    80003b98:	8b4080e7          	jalr	-1868(ra) # 80003448 <begin_op>
      ilock(f->ip);
    80003b9c:	01893503          	ld	a0,24(s2)
    80003ba0:	fffff097          	auipc	ra,0xfffff
    80003ba4:	ecc080e7          	jalr	-308(ra) # 80002a6c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ba8:	8756                	mv	a4,s5
    80003baa:	02092683          	lw	a3,32(s2)
    80003bae:	01698633          	add	a2,s3,s6
    80003bb2:	4585                	li	a1,1
    80003bb4:	01893503          	ld	a0,24(s2)
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	260080e7          	jalr	608(ra) # 80002e18 <writei>
    80003bc0:	84aa                	mv	s1,a0
    80003bc2:	00a05763          	blez	a0,80003bd0 <filewrite+0xc4>
        f->off += r;
    80003bc6:	02092783          	lw	a5,32(s2)
    80003bca:	9fa9                	addw	a5,a5,a0
    80003bcc:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003bd0:	01893503          	ld	a0,24(s2)
    80003bd4:	fffff097          	auipc	ra,0xfffff
    80003bd8:	f5a080e7          	jalr	-166(ra) # 80002b2e <iunlock>
      end_op();
    80003bdc:	00000097          	auipc	ra,0x0
    80003be0:	8ea080e7          	jalr	-1814(ra) # 800034c6 <end_op>

      if(r != n1){
    80003be4:	009a9f63          	bne	s5,s1,80003c02 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003be8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003bec:	0149db63          	bge	s3,s4,80003c02 <filewrite+0xf6>
      int n1 = n - i;
    80003bf0:	413a04bb          	subw	s1,s4,s3
    80003bf4:	0004879b          	sext.w	a5,s1
    80003bf8:	f8fbdce3          	bge	s7,a5,80003b90 <filewrite+0x84>
    80003bfc:	84e2                	mv	s1,s8
    80003bfe:	bf49                	j	80003b90 <filewrite+0x84>
    int i = 0;
    80003c00:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c02:	013a1f63          	bne	s4,s3,80003c20 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c06:	8552                	mv	a0,s4
    80003c08:	60a6                	ld	ra,72(sp)
    80003c0a:	6406                	ld	s0,64(sp)
    80003c0c:	74e2                	ld	s1,56(sp)
    80003c0e:	7942                	ld	s2,48(sp)
    80003c10:	79a2                	ld	s3,40(sp)
    80003c12:	7a02                	ld	s4,32(sp)
    80003c14:	6ae2                	ld	s5,24(sp)
    80003c16:	6b42                	ld	s6,16(sp)
    80003c18:	6ba2                	ld	s7,8(sp)
    80003c1a:	6c02                	ld	s8,0(sp)
    80003c1c:	6161                	addi	sp,sp,80
    80003c1e:	8082                	ret
    ret = (i == n ? n : -1);
    80003c20:	5a7d                	li	s4,-1
    80003c22:	b7d5                	j	80003c06 <filewrite+0xfa>
    panic("filewrite");
    80003c24:	00005517          	auipc	a0,0x5
    80003c28:	a0c50513          	addi	a0,a0,-1524 # 80008630 <syscalls+0x268>
    80003c2c:	00002097          	auipc	ra,0x2
    80003c30:	eb4080e7          	jalr	-332(ra) # 80005ae0 <panic>
    return -1;
    80003c34:	5a7d                	li	s4,-1
    80003c36:	bfc1                	j	80003c06 <filewrite+0xfa>
      return -1;
    80003c38:	5a7d                	li	s4,-1
    80003c3a:	b7f1                	j	80003c06 <filewrite+0xfa>
    80003c3c:	5a7d                	li	s4,-1
    80003c3e:	b7e1                	j	80003c06 <filewrite+0xfa>

0000000080003c40 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003c40:	7179                	addi	sp,sp,-48
    80003c42:	f406                	sd	ra,40(sp)
    80003c44:	f022                	sd	s0,32(sp)
    80003c46:	ec26                	sd	s1,24(sp)
    80003c48:	e84a                	sd	s2,16(sp)
    80003c4a:	e44e                	sd	s3,8(sp)
    80003c4c:	e052                	sd	s4,0(sp)
    80003c4e:	1800                	addi	s0,sp,48
    80003c50:	84aa                	mv	s1,a0
    80003c52:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003c54:	0005b023          	sd	zero,0(a1)
    80003c58:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003c5c:	00000097          	auipc	ra,0x0
    80003c60:	bf8080e7          	jalr	-1032(ra) # 80003854 <filealloc>
    80003c64:	e088                	sd	a0,0(s1)
    80003c66:	c551                	beqz	a0,80003cf2 <pipealloc+0xb2>
    80003c68:	00000097          	auipc	ra,0x0
    80003c6c:	bec080e7          	jalr	-1044(ra) # 80003854 <filealloc>
    80003c70:	00aa3023          	sd	a0,0(s4)
    80003c74:	c92d                	beqz	a0,80003ce6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003c76:	ffffc097          	auipc	ra,0xffffc
    80003c7a:	4a4080e7          	jalr	1188(ra) # 8000011a <kalloc>
    80003c7e:	892a                	mv	s2,a0
    80003c80:	c125                	beqz	a0,80003ce0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003c82:	4985                	li	s3,1
    80003c84:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003c88:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003c8c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003c90:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003c94:	00005597          	auipc	a1,0x5
    80003c98:	9ac58593          	addi	a1,a1,-1620 # 80008640 <syscalls+0x278>
    80003c9c:	00002097          	auipc	ra,0x2
    80003ca0:	2ec080e7          	jalr	748(ra) # 80005f88 <initlock>
  (*f0)->type = FD_PIPE;
    80003ca4:	609c                	ld	a5,0(s1)
    80003ca6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003caa:	609c                	ld	a5,0(s1)
    80003cac:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003cb0:	609c                	ld	a5,0(s1)
    80003cb2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003cb6:	609c                	ld	a5,0(s1)
    80003cb8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003cbc:	000a3783          	ld	a5,0(s4)
    80003cc0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003cc4:	000a3783          	ld	a5,0(s4)
    80003cc8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ccc:	000a3783          	ld	a5,0(s4)
    80003cd0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003cd4:	000a3783          	ld	a5,0(s4)
    80003cd8:	0127b823          	sd	s2,16(a5)
  return 0;
    80003cdc:	4501                	li	a0,0
    80003cde:	a025                	j	80003d06 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ce0:	6088                	ld	a0,0(s1)
    80003ce2:	e501                	bnez	a0,80003cea <pipealloc+0xaa>
    80003ce4:	a039                	j	80003cf2 <pipealloc+0xb2>
    80003ce6:	6088                	ld	a0,0(s1)
    80003ce8:	c51d                	beqz	a0,80003d16 <pipealloc+0xd6>
    fileclose(*f0);
    80003cea:	00000097          	auipc	ra,0x0
    80003cee:	c26080e7          	jalr	-986(ra) # 80003910 <fileclose>
  if(*f1)
    80003cf2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003cf6:	557d                	li	a0,-1
  if(*f1)
    80003cf8:	c799                	beqz	a5,80003d06 <pipealloc+0xc6>
    fileclose(*f1);
    80003cfa:	853e                	mv	a0,a5
    80003cfc:	00000097          	auipc	ra,0x0
    80003d00:	c14080e7          	jalr	-1004(ra) # 80003910 <fileclose>
  return -1;
    80003d04:	557d                	li	a0,-1
}
    80003d06:	70a2                	ld	ra,40(sp)
    80003d08:	7402                	ld	s0,32(sp)
    80003d0a:	64e2                	ld	s1,24(sp)
    80003d0c:	6942                	ld	s2,16(sp)
    80003d0e:	69a2                	ld	s3,8(sp)
    80003d10:	6a02                	ld	s4,0(sp)
    80003d12:	6145                	addi	sp,sp,48
    80003d14:	8082                	ret
  return -1;
    80003d16:	557d                	li	a0,-1
    80003d18:	b7fd                	j	80003d06 <pipealloc+0xc6>

0000000080003d1a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d1a:	1101                	addi	sp,sp,-32
    80003d1c:	ec06                	sd	ra,24(sp)
    80003d1e:	e822                	sd	s0,16(sp)
    80003d20:	e426                	sd	s1,8(sp)
    80003d22:	e04a                	sd	s2,0(sp)
    80003d24:	1000                	addi	s0,sp,32
    80003d26:	84aa                	mv	s1,a0
    80003d28:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d2a:	00002097          	auipc	ra,0x2
    80003d2e:	2ee080e7          	jalr	750(ra) # 80006018 <acquire>
  if(writable){
    80003d32:	02090d63          	beqz	s2,80003d6c <pipeclose+0x52>
    pi->writeopen = 0;
    80003d36:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003d3a:	21848513          	addi	a0,s1,536
    80003d3e:	ffffe097          	auipc	ra,0xffffe
    80003d42:	956080e7          	jalr	-1706(ra) # 80001694 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003d46:	2204b783          	ld	a5,544(s1)
    80003d4a:	eb95                	bnez	a5,80003d7e <pipeclose+0x64>
    release(&pi->lock);
    80003d4c:	8526                	mv	a0,s1
    80003d4e:	00002097          	auipc	ra,0x2
    80003d52:	37e080e7          	jalr	894(ra) # 800060cc <release>
    kfree((char*)pi);
    80003d56:	8526                	mv	a0,s1
    80003d58:	ffffc097          	auipc	ra,0xffffc
    80003d5c:	2c4080e7          	jalr	708(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003d60:	60e2                	ld	ra,24(sp)
    80003d62:	6442                	ld	s0,16(sp)
    80003d64:	64a2                	ld	s1,8(sp)
    80003d66:	6902                	ld	s2,0(sp)
    80003d68:	6105                	addi	sp,sp,32
    80003d6a:	8082                	ret
    pi->readopen = 0;
    80003d6c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003d70:	21c48513          	addi	a0,s1,540
    80003d74:	ffffe097          	auipc	ra,0xffffe
    80003d78:	920080e7          	jalr	-1760(ra) # 80001694 <wakeup>
    80003d7c:	b7e9                	j	80003d46 <pipeclose+0x2c>
    release(&pi->lock);
    80003d7e:	8526                	mv	a0,s1
    80003d80:	00002097          	auipc	ra,0x2
    80003d84:	34c080e7          	jalr	844(ra) # 800060cc <release>
}
    80003d88:	bfe1                	j	80003d60 <pipeclose+0x46>

0000000080003d8a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003d8a:	711d                	addi	sp,sp,-96
    80003d8c:	ec86                	sd	ra,88(sp)
    80003d8e:	e8a2                	sd	s0,80(sp)
    80003d90:	e4a6                	sd	s1,72(sp)
    80003d92:	e0ca                	sd	s2,64(sp)
    80003d94:	fc4e                	sd	s3,56(sp)
    80003d96:	f852                	sd	s4,48(sp)
    80003d98:	f456                	sd	s5,40(sp)
    80003d9a:	f05a                	sd	s6,32(sp)
    80003d9c:	ec5e                	sd	s7,24(sp)
    80003d9e:	e862                	sd	s8,16(sp)
    80003da0:	1080                	addi	s0,sp,96
    80003da2:	84aa                	mv	s1,a0
    80003da4:	8aae                	mv	s5,a1
    80003da6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003da8:	ffffd097          	auipc	ra,0xffffd
    80003dac:	09c080e7          	jalr	156(ra) # 80000e44 <myproc>
    80003db0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003db2:	8526                	mv	a0,s1
    80003db4:	00002097          	auipc	ra,0x2
    80003db8:	264080e7          	jalr	612(ra) # 80006018 <acquire>
  while(i < n){
    80003dbc:	0b405363          	blez	s4,80003e62 <pipewrite+0xd8>
  int i = 0;
    80003dc0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003dc2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003dc4:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003dc8:	21c48b93          	addi	s7,s1,540
    80003dcc:	a089                	j	80003e0e <pipewrite+0x84>
      release(&pi->lock);
    80003dce:	8526                	mv	a0,s1
    80003dd0:	00002097          	auipc	ra,0x2
    80003dd4:	2fc080e7          	jalr	764(ra) # 800060cc <release>
      return -1;
    80003dd8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003dda:	854a                	mv	a0,s2
    80003ddc:	60e6                	ld	ra,88(sp)
    80003dde:	6446                	ld	s0,80(sp)
    80003de0:	64a6                	ld	s1,72(sp)
    80003de2:	6906                	ld	s2,64(sp)
    80003de4:	79e2                	ld	s3,56(sp)
    80003de6:	7a42                	ld	s4,48(sp)
    80003de8:	7aa2                	ld	s5,40(sp)
    80003dea:	7b02                	ld	s6,32(sp)
    80003dec:	6be2                	ld	s7,24(sp)
    80003dee:	6c42                	ld	s8,16(sp)
    80003df0:	6125                	addi	sp,sp,96
    80003df2:	8082                	ret
      wakeup(&pi->nread);
    80003df4:	8562                	mv	a0,s8
    80003df6:	ffffe097          	auipc	ra,0xffffe
    80003dfa:	89e080e7          	jalr	-1890(ra) # 80001694 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003dfe:	85a6                	mv	a1,s1
    80003e00:	855e                	mv	a0,s7
    80003e02:	ffffd097          	auipc	ra,0xffffd
    80003e06:	706080e7          	jalr	1798(ra) # 80001508 <sleep>
  while(i < n){
    80003e0a:	05495d63          	bge	s2,s4,80003e64 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003e0e:	2204a783          	lw	a5,544(s1)
    80003e12:	dfd5                	beqz	a5,80003dce <pipewrite+0x44>
    80003e14:	0289a783          	lw	a5,40(s3)
    80003e18:	fbdd                	bnez	a5,80003dce <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003e1a:	2184a783          	lw	a5,536(s1)
    80003e1e:	21c4a703          	lw	a4,540(s1)
    80003e22:	2007879b          	addiw	a5,a5,512
    80003e26:	fcf707e3          	beq	a4,a5,80003df4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e2a:	4685                	li	a3,1
    80003e2c:	01590633          	add	a2,s2,s5
    80003e30:	faf40593          	addi	a1,s0,-81
    80003e34:	0509b503          	ld	a0,80(s3)
    80003e38:	ffffd097          	auipc	ra,0xffffd
    80003e3c:	d5c080e7          	jalr	-676(ra) # 80000b94 <copyin>
    80003e40:	03650263          	beq	a0,s6,80003e64 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003e44:	21c4a783          	lw	a5,540(s1)
    80003e48:	0017871b          	addiw	a4,a5,1
    80003e4c:	20e4ae23          	sw	a4,540(s1)
    80003e50:	1ff7f793          	andi	a5,a5,511
    80003e54:	97a6                	add	a5,a5,s1
    80003e56:	faf44703          	lbu	a4,-81(s0)
    80003e5a:	00e78c23          	sb	a4,24(a5)
      i++;
    80003e5e:	2905                	addiw	s2,s2,1
    80003e60:	b76d                	j	80003e0a <pipewrite+0x80>
  int i = 0;
    80003e62:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003e64:	21848513          	addi	a0,s1,536
    80003e68:	ffffe097          	auipc	ra,0xffffe
    80003e6c:	82c080e7          	jalr	-2004(ra) # 80001694 <wakeup>
  release(&pi->lock);
    80003e70:	8526                	mv	a0,s1
    80003e72:	00002097          	auipc	ra,0x2
    80003e76:	25a080e7          	jalr	602(ra) # 800060cc <release>
  return i;
    80003e7a:	b785                	j	80003dda <pipewrite+0x50>

0000000080003e7c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003e7c:	715d                	addi	sp,sp,-80
    80003e7e:	e486                	sd	ra,72(sp)
    80003e80:	e0a2                	sd	s0,64(sp)
    80003e82:	fc26                	sd	s1,56(sp)
    80003e84:	f84a                	sd	s2,48(sp)
    80003e86:	f44e                	sd	s3,40(sp)
    80003e88:	f052                	sd	s4,32(sp)
    80003e8a:	ec56                	sd	s5,24(sp)
    80003e8c:	e85a                	sd	s6,16(sp)
    80003e8e:	0880                	addi	s0,sp,80
    80003e90:	84aa                	mv	s1,a0
    80003e92:	892e                	mv	s2,a1
    80003e94:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003e96:	ffffd097          	auipc	ra,0xffffd
    80003e9a:	fae080e7          	jalr	-82(ra) # 80000e44 <myproc>
    80003e9e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ea0:	8526                	mv	a0,s1
    80003ea2:	00002097          	auipc	ra,0x2
    80003ea6:	176080e7          	jalr	374(ra) # 80006018 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003eaa:	2184a703          	lw	a4,536(s1)
    80003eae:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003eb2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003eb6:	02f71463          	bne	a4,a5,80003ede <piperead+0x62>
    80003eba:	2244a783          	lw	a5,548(s1)
    80003ebe:	c385                	beqz	a5,80003ede <piperead+0x62>
    if(pr->killed){
    80003ec0:	028a2783          	lw	a5,40(s4)
    80003ec4:	ebc9                	bnez	a5,80003f56 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ec6:	85a6                	mv	a1,s1
    80003ec8:	854e                	mv	a0,s3
    80003eca:	ffffd097          	auipc	ra,0xffffd
    80003ece:	63e080e7          	jalr	1598(ra) # 80001508 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ed2:	2184a703          	lw	a4,536(s1)
    80003ed6:	21c4a783          	lw	a5,540(s1)
    80003eda:	fef700e3          	beq	a4,a5,80003eba <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ede:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ee0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ee2:	05505463          	blez	s5,80003f2a <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80003ee6:	2184a783          	lw	a5,536(s1)
    80003eea:	21c4a703          	lw	a4,540(s1)
    80003eee:	02f70e63          	beq	a4,a5,80003f2a <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003ef2:	0017871b          	addiw	a4,a5,1
    80003ef6:	20e4ac23          	sw	a4,536(s1)
    80003efa:	1ff7f793          	andi	a5,a5,511
    80003efe:	97a6                	add	a5,a5,s1
    80003f00:	0187c783          	lbu	a5,24(a5)
    80003f04:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f08:	4685                	li	a3,1
    80003f0a:	fbf40613          	addi	a2,s0,-65
    80003f0e:	85ca                	mv	a1,s2
    80003f10:	050a3503          	ld	a0,80(s4)
    80003f14:	ffffd097          	auipc	ra,0xffffd
    80003f18:	bf4080e7          	jalr	-1036(ra) # 80000b08 <copyout>
    80003f1c:	01650763          	beq	a0,s6,80003f2a <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f20:	2985                	addiw	s3,s3,1
    80003f22:	0905                	addi	s2,s2,1
    80003f24:	fd3a91e3          	bne	s5,s3,80003ee6 <piperead+0x6a>
    80003f28:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f2a:	21c48513          	addi	a0,s1,540
    80003f2e:	ffffd097          	auipc	ra,0xffffd
    80003f32:	766080e7          	jalr	1894(ra) # 80001694 <wakeup>
  release(&pi->lock);
    80003f36:	8526                	mv	a0,s1
    80003f38:	00002097          	auipc	ra,0x2
    80003f3c:	194080e7          	jalr	404(ra) # 800060cc <release>
  return i;
}
    80003f40:	854e                	mv	a0,s3
    80003f42:	60a6                	ld	ra,72(sp)
    80003f44:	6406                	ld	s0,64(sp)
    80003f46:	74e2                	ld	s1,56(sp)
    80003f48:	7942                	ld	s2,48(sp)
    80003f4a:	79a2                	ld	s3,40(sp)
    80003f4c:	7a02                	ld	s4,32(sp)
    80003f4e:	6ae2                	ld	s5,24(sp)
    80003f50:	6b42                	ld	s6,16(sp)
    80003f52:	6161                	addi	sp,sp,80
    80003f54:	8082                	ret
      release(&pi->lock);
    80003f56:	8526                	mv	a0,s1
    80003f58:	00002097          	auipc	ra,0x2
    80003f5c:	174080e7          	jalr	372(ra) # 800060cc <release>
      return -1;
    80003f60:	59fd                	li	s3,-1
    80003f62:	bff9                	j	80003f40 <piperead+0xc4>

0000000080003f64 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80003f64:	de010113          	addi	sp,sp,-544
    80003f68:	20113c23          	sd	ra,536(sp)
    80003f6c:	20813823          	sd	s0,528(sp)
    80003f70:	20913423          	sd	s1,520(sp)
    80003f74:	21213023          	sd	s2,512(sp)
    80003f78:	ffce                	sd	s3,504(sp)
    80003f7a:	fbd2                	sd	s4,496(sp)
    80003f7c:	f7d6                	sd	s5,488(sp)
    80003f7e:	f3da                	sd	s6,480(sp)
    80003f80:	efde                	sd	s7,472(sp)
    80003f82:	ebe2                	sd	s8,464(sp)
    80003f84:	e7e6                	sd	s9,456(sp)
    80003f86:	e3ea                	sd	s10,448(sp)
    80003f88:	ff6e                	sd	s11,440(sp)
    80003f8a:	1400                	addi	s0,sp,544
    80003f8c:	892a                	mv	s2,a0
    80003f8e:	dea43423          	sd	a0,-536(s0)
    80003f92:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003f96:	ffffd097          	auipc	ra,0xffffd
    80003f9a:	eae080e7          	jalr	-338(ra) # 80000e44 <myproc>
    80003f9e:	84aa                	mv	s1,a0

  begin_op();
    80003fa0:	fffff097          	auipc	ra,0xfffff
    80003fa4:	4a8080e7          	jalr	1192(ra) # 80003448 <begin_op>

  if((ip = namei(path)) == 0){
    80003fa8:	854a                	mv	a0,s2
    80003faa:	fffff097          	auipc	ra,0xfffff
    80003fae:	27e080e7          	jalr	638(ra) # 80003228 <namei>
    80003fb2:	c93d                	beqz	a0,80004028 <exec+0xc4>
    80003fb4:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003fb6:	fffff097          	auipc	ra,0xfffff
    80003fba:	ab6080e7          	jalr	-1354(ra) # 80002a6c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003fbe:	04000713          	li	a4,64
    80003fc2:	4681                	li	a3,0
    80003fc4:	e5040613          	addi	a2,s0,-432
    80003fc8:	4581                	li	a1,0
    80003fca:	8556                	mv	a0,s5
    80003fcc:	fffff097          	auipc	ra,0xfffff
    80003fd0:	d54080e7          	jalr	-684(ra) # 80002d20 <readi>
    80003fd4:	04000793          	li	a5,64
    80003fd8:	00f51a63          	bne	a0,a5,80003fec <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80003fdc:	e5042703          	lw	a4,-432(s0)
    80003fe0:	464c47b7          	lui	a5,0x464c4
    80003fe4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003fe8:	04f70663          	beq	a4,a5,80004034 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003fec:	8556                	mv	a0,s5
    80003fee:	fffff097          	auipc	ra,0xfffff
    80003ff2:	ce0080e7          	jalr	-800(ra) # 80002cce <iunlockput>
    end_op();
    80003ff6:	fffff097          	auipc	ra,0xfffff
    80003ffa:	4d0080e7          	jalr	1232(ra) # 800034c6 <end_op>
  }
  return -1;
    80003ffe:	557d                	li	a0,-1
}
    80004000:	21813083          	ld	ra,536(sp)
    80004004:	21013403          	ld	s0,528(sp)
    80004008:	20813483          	ld	s1,520(sp)
    8000400c:	20013903          	ld	s2,512(sp)
    80004010:	79fe                	ld	s3,504(sp)
    80004012:	7a5e                	ld	s4,496(sp)
    80004014:	7abe                	ld	s5,488(sp)
    80004016:	7b1e                	ld	s6,480(sp)
    80004018:	6bfe                	ld	s7,472(sp)
    8000401a:	6c5e                	ld	s8,464(sp)
    8000401c:	6cbe                	ld	s9,456(sp)
    8000401e:	6d1e                	ld	s10,448(sp)
    80004020:	7dfa                	ld	s11,440(sp)
    80004022:	22010113          	addi	sp,sp,544
    80004026:	8082                	ret
    end_op();
    80004028:	fffff097          	auipc	ra,0xfffff
    8000402c:	49e080e7          	jalr	1182(ra) # 800034c6 <end_op>
    return -1;
    80004030:	557d                	li	a0,-1
    80004032:	b7f9                	j	80004000 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004034:	8526                	mv	a0,s1
    80004036:	ffffd097          	auipc	ra,0xffffd
    8000403a:	ed2080e7          	jalr	-302(ra) # 80000f08 <proc_pagetable>
    8000403e:	8b2a                	mv	s6,a0
    80004040:	d555                	beqz	a0,80003fec <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004042:	e7042783          	lw	a5,-400(s0)
    80004046:	e8845703          	lhu	a4,-376(s0)
    8000404a:	c735                	beqz	a4,800040b6 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000404c:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000404e:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    80004052:	6a05                	lui	s4,0x1
    80004054:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004058:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000405c:	6d85                	lui	s11,0x1
    8000405e:	7d7d                	lui	s10,0xfffff
    80004060:	ac1d                	j	80004296 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004062:	00004517          	auipc	a0,0x4
    80004066:	5e650513          	addi	a0,a0,1510 # 80008648 <syscalls+0x280>
    8000406a:	00002097          	auipc	ra,0x2
    8000406e:	a76080e7          	jalr	-1418(ra) # 80005ae0 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004072:	874a                	mv	a4,s2
    80004074:	009c86bb          	addw	a3,s9,s1
    80004078:	4581                	li	a1,0
    8000407a:	8556                	mv	a0,s5
    8000407c:	fffff097          	auipc	ra,0xfffff
    80004080:	ca4080e7          	jalr	-860(ra) # 80002d20 <readi>
    80004084:	2501                	sext.w	a0,a0
    80004086:	1aa91863          	bne	s2,a0,80004236 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    8000408a:	009d84bb          	addw	s1,s11,s1
    8000408e:	013d09bb          	addw	s3,s10,s3
    80004092:	1f74f263          	bgeu	s1,s7,80004276 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004096:	02049593          	slli	a1,s1,0x20
    8000409a:	9181                	srli	a1,a1,0x20
    8000409c:	95e2                	add	a1,a1,s8
    8000409e:	855a                	mv	a0,s6
    800040a0:	ffffc097          	auipc	ra,0xffffc
    800040a4:	460080e7          	jalr	1120(ra) # 80000500 <walkaddr>
    800040a8:	862a                	mv	a2,a0
    if(pa == 0)
    800040aa:	dd45                	beqz	a0,80004062 <exec+0xfe>
      n = PGSIZE;
    800040ac:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800040ae:	fd49f2e3          	bgeu	s3,s4,80004072 <exec+0x10e>
      n = sz - i;
    800040b2:	894e                	mv	s2,s3
    800040b4:	bf7d                	j	80004072 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040b6:	4481                	li	s1,0
  iunlockput(ip);
    800040b8:	8556                	mv	a0,s5
    800040ba:	fffff097          	auipc	ra,0xfffff
    800040be:	c14080e7          	jalr	-1004(ra) # 80002cce <iunlockput>
  end_op();
    800040c2:	fffff097          	auipc	ra,0xfffff
    800040c6:	404080e7          	jalr	1028(ra) # 800034c6 <end_op>
  p = myproc();
    800040ca:	ffffd097          	auipc	ra,0xffffd
    800040ce:	d7a080e7          	jalr	-646(ra) # 80000e44 <myproc>
    800040d2:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800040d4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800040d8:	6785                	lui	a5,0x1
    800040da:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800040dc:	97a6                	add	a5,a5,s1
    800040de:	777d                	lui	a4,0xfffff
    800040e0:	8ff9                	and	a5,a5,a4
    800040e2:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800040e6:	6609                	lui	a2,0x2
    800040e8:	963e                	add	a2,a2,a5
    800040ea:	85be                	mv	a1,a5
    800040ec:	855a                	mv	a0,s6
    800040ee:	ffffc097          	auipc	ra,0xffffc
    800040f2:	7c6080e7          	jalr	1990(ra) # 800008b4 <uvmalloc>
    800040f6:	8c2a                	mv	s8,a0
  ip = 0;
    800040f8:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800040fa:	12050e63          	beqz	a0,80004236 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    800040fe:	75f9                	lui	a1,0xffffe
    80004100:	95aa                	add	a1,a1,a0
    80004102:	855a                	mv	a0,s6
    80004104:	ffffd097          	auipc	ra,0xffffd
    80004108:	9d2080e7          	jalr	-1582(ra) # 80000ad6 <uvmclear>
  stackbase = sp - PGSIZE;
    8000410c:	7afd                	lui	s5,0xfffff
    8000410e:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004110:	df043783          	ld	a5,-528(s0)
    80004114:	6388                	ld	a0,0(a5)
    80004116:	c925                	beqz	a0,80004186 <exec+0x222>
    80004118:	e9040993          	addi	s3,s0,-368
    8000411c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004120:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004122:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004124:	ffffc097          	auipc	ra,0xffffc
    80004128:	1d2080e7          	jalr	466(ra) # 800002f6 <strlen>
    8000412c:	0015079b          	addiw	a5,a0,1
    80004130:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004134:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004138:	13596363          	bltu	s2,s5,8000425e <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000413c:	df043d83          	ld	s11,-528(s0)
    80004140:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004144:	8552                	mv	a0,s4
    80004146:	ffffc097          	auipc	ra,0xffffc
    8000414a:	1b0080e7          	jalr	432(ra) # 800002f6 <strlen>
    8000414e:	0015069b          	addiw	a3,a0,1
    80004152:	8652                	mv	a2,s4
    80004154:	85ca                	mv	a1,s2
    80004156:	855a                	mv	a0,s6
    80004158:	ffffd097          	auipc	ra,0xffffd
    8000415c:	9b0080e7          	jalr	-1616(ra) # 80000b08 <copyout>
    80004160:	10054363          	bltz	a0,80004266 <exec+0x302>
    ustack[argc] = sp;
    80004164:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004168:	0485                	addi	s1,s1,1
    8000416a:	008d8793          	addi	a5,s11,8
    8000416e:	def43823          	sd	a5,-528(s0)
    80004172:	008db503          	ld	a0,8(s11)
    80004176:	c911                	beqz	a0,8000418a <exec+0x226>
    if(argc >= MAXARG)
    80004178:	09a1                	addi	s3,s3,8
    8000417a:	fb3c95e3          	bne	s9,s3,80004124 <exec+0x1c0>
  sz = sz1;
    8000417e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004182:	4a81                	li	s5,0
    80004184:	a84d                	j	80004236 <exec+0x2d2>
  sp = sz;
    80004186:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004188:	4481                	li	s1,0
  ustack[argc] = 0;
    8000418a:	00349793          	slli	a5,s1,0x3
    8000418e:	f9078793          	addi	a5,a5,-112
    80004192:	97a2                	add	a5,a5,s0
    80004194:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004198:	00148693          	addi	a3,s1,1
    8000419c:	068e                	slli	a3,a3,0x3
    8000419e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800041a2:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800041a6:	01597663          	bgeu	s2,s5,800041b2 <exec+0x24e>
  sz = sz1;
    800041aa:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800041ae:	4a81                	li	s5,0
    800041b0:	a059                	j	80004236 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800041b2:	e9040613          	addi	a2,s0,-368
    800041b6:	85ca                	mv	a1,s2
    800041b8:	855a                	mv	a0,s6
    800041ba:	ffffd097          	auipc	ra,0xffffd
    800041be:	94e080e7          	jalr	-1714(ra) # 80000b08 <copyout>
    800041c2:	0a054663          	bltz	a0,8000426e <exec+0x30a>
  p->trapframe->a1 = sp;
    800041c6:	058bb783          	ld	a5,88(s7)
    800041ca:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800041ce:	de843783          	ld	a5,-536(s0)
    800041d2:	0007c703          	lbu	a4,0(a5)
    800041d6:	cf11                	beqz	a4,800041f2 <exec+0x28e>
    800041d8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800041da:	02f00693          	li	a3,47
    800041de:	a039                	j	800041ec <exec+0x288>
      last = s+1;
    800041e0:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800041e4:	0785                	addi	a5,a5,1
    800041e6:	fff7c703          	lbu	a4,-1(a5)
    800041ea:	c701                	beqz	a4,800041f2 <exec+0x28e>
    if(*s == '/')
    800041ec:	fed71ce3          	bne	a4,a3,800041e4 <exec+0x280>
    800041f0:	bfc5                	j	800041e0 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800041f2:	4641                	li	a2,16
    800041f4:	de843583          	ld	a1,-536(s0)
    800041f8:	158b8513          	addi	a0,s7,344
    800041fc:	ffffc097          	auipc	ra,0xffffc
    80004200:	0c8080e7          	jalr	200(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004204:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004208:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000420c:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004210:	058bb783          	ld	a5,88(s7)
    80004214:	e6843703          	ld	a4,-408(s0)
    80004218:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000421a:	058bb783          	ld	a5,88(s7)
    8000421e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004222:	85ea                	mv	a1,s10
    80004224:	ffffd097          	auipc	ra,0xffffd
    80004228:	d80080e7          	jalr	-640(ra) # 80000fa4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000422c:	0004851b          	sext.w	a0,s1
    80004230:	bbc1                	j	80004000 <exec+0x9c>
    80004232:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004236:	df843583          	ld	a1,-520(s0)
    8000423a:	855a                	mv	a0,s6
    8000423c:	ffffd097          	auipc	ra,0xffffd
    80004240:	d68080e7          	jalr	-664(ra) # 80000fa4 <proc_freepagetable>
  if(ip){
    80004244:	da0a94e3          	bnez	s5,80003fec <exec+0x88>
  return -1;
    80004248:	557d                	li	a0,-1
    8000424a:	bb5d                	j	80004000 <exec+0x9c>
    8000424c:	de943c23          	sd	s1,-520(s0)
    80004250:	b7dd                	j	80004236 <exec+0x2d2>
    80004252:	de943c23          	sd	s1,-520(s0)
    80004256:	b7c5                	j	80004236 <exec+0x2d2>
    80004258:	de943c23          	sd	s1,-520(s0)
    8000425c:	bfe9                	j	80004236 <exec+0x2d2>
  sz = sz1;
    8000425e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004262:	4a81                	li	s5,0
    80004264:	bfc9                	j	80004236 <exec+0x2d2>
  sz = sz1;
    80004266:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000426a:	4a81                	li	s5,0
    8000426c:	b7e9                	j	80004236 <exec+0x2d2>
  sz = sz1;
    8000426e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004272:	4a81                	li	s5,0
    80004274:	b7c9                	j	80004236 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004276:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000427a:	e0843783          	ld	a5,-504(s0)
    8000427e:	0017869b          	addiw	a3,a5,1
    80004282:	e0d43423          	sd	a3,-504(s0)
    80004286:	e0043783          	ld	a5,-512(s0)
    8000428a:	0387879b          	addiw	a5,a5,56
    8000428e:	e8845703          	lhu	a4,-376(s0)
    80004292:	e2e6d3e3          	bge	a3,a4,800040b8 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004296:	2781                	sext.w	a5,a5
    80004298:	e0f43023          	sd	a5,-512(s0)
    8000429c:	03800713          	li	a4,56
    800042a0:	86be                	mv	a3,a5
    800042a2:	e1840613          	addi	a2,s0,-488
    800042a6:	4581                	li	a1,0
    800042a8:	8556                	mv	a0,s5
    800042aa:	fffff097          	auipc	ra,0xfffff
    800042ae:	a76080e7          	jalr	-1418(ra) # 80002d20 <readi>
    800042b2:	03800793          	li	a5,56
    800042b6:	f6f51ee3          	bne	a0,a5,80004232 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    800042ba:	e1842783          	lw	a5,-488(s0)
    800042be:	4705                	li	a4,1
    800042c0:	fae79de3          	bne	a5,a4,8000427a <exec+0x316>
    if(ph.memsz < ph.filesz)
    800042c4:	e4043603          	ld	a2,-448(s0)
    800042c8:	e3843783          	ld	a5,-456(s0)
    800042cc:	f8f660e3          	bltu	a2,a5,8000424c <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042d0:	e2843783          	ld	a5,-472(s0)
    800042d4:	963e                	add	a2,a2,a5
    800042d6:	f6f66ee3          	bltu	a2,a5,80004252 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800042da:	85a6                	mv	a1,s1
    800042dc:	855a                	mv	a0,s6
    800042de:	ffffc097          	auipc	ra,0xffffc
    800042e2:	5d6080e7          	jalr	1494(ra) # 800008b4 <uvmalloc>
    800042e6:	dea43c23          	sd	a0,-520(s0)
    800042ea:	d53d                	beqz	a0,80004258 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    800042ec:	e2843c03          	ld	s8,-472(s0)
    800042f0:	de043783          	ld	a5,-544(s0)
    800042f4:	00fc77b3          	and	a5,s8,a5
    800042f8:	ff9d                	bnez	a5,80004236 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042fa:	e2042c83          	lw	s9,-480(s0)
    800042fe:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004302:	f60b8ae3          	beqz	s7,80004276 <exec+0x312>
    80004306:	89de                	mv	s3,s7
    80004308:	4481                	li	s1,0
    8000430a:	b371                	j	80004096 <exec+0x132>

000000008000430c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000430c:	7179                	addi	sp,sp,-48
    8000430e:	f406                	sd	ra,40(sp)
    80004310:	f022                	sd	s0,32(sp)
    80004312:	ec26                	sd	s1,24(sp)
    80004314:	e84a                	sd	s2,16(sp)
    80004316:	1800                	addi	s0,sp,48
    80004318:	892e                	mv	s2,a1
    8000431a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000431c:	fdc40593          	addi	a1,s0,-36
    80004320:	ffffe097          	auipc	ra,0xffffe
    80004324:	bda080e7          	jalr	-1062(ra) # 80001efa <argint>
    80004328:	04054063          	bltz	a0,80004368 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000432c:	fdc42703          	lw	a4,-36(s0)
    80004330:	47bd                	li	a5,15
    80004332:	02e7ed63          	bltu	a5,a4,8000436c <argfd+0x60>
    80004336:	ffffd097          	auipc	ra,0xffffd
    8000433a:	b0e080e7          	jalr	-1266(ra) # 80000e44 <myproc>
    8000433e:	fdc42703          	lw	a4,-36(s0)
    80004342:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    80004346:	078e                	slli	a5,a5,0x3
    80004348:	953e                	add	a0,a0,a5
    8000434a:	611c                	ld	a5,0(a0)
    8000434c:	c395                	beqz	a5,80004370 <argfd+0x64>
    return -1;
  if(pfd)
    8000434e:	00090463          	beqz	s2,80004356 <argfd+0x4a>
    *pfd = fd;
    80004352:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004356:	4501                	li	a0,0
  if(pf)
    80004358:	c091                	beqz	s1,8000435c <argfd+0x50>
    *pf = f;
    8000435a:	e09c                	sd	a5,0(s1)
}
    8000435c:	70a2                	ld	ra,40(sp)
    8000435e:	7402                	ld	s0,32(sp)
    80004360:	64e2                	ld	s1,24(sp)
    80004362:	6942                	ld	s2,16(sp)
    80004364:	6145                	addi	sp,sp,48
    80004366:	8082                	ret
    return -1;
    80004368:	557d                	li	a0,-1
    8000436a:	bfcd                	j	8000435c <argfd+0x50>
    return -1;
    8000436c:	557d                	li	a0,-1
    8000436e:	b7fd                	j	8000435c <argfd+0x50>
    80004370:	557d                	li	a0,-1
    80004372:	b7ed                	j	8000435c <argfd+0x50>

0000000080004374 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004374:	1101                	addi	sp,sp,-32
    80004376:	ec06                	sd	ra,24(sp)
    80004378:	e822                	sd	s0,16(sp)
    8000437a:	e426                	sd	s1,8(sp)
    8000437c:	1000                	addi	s0,sp,32
    8000437e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004380:	ffffd097          	auipc	ra,0xffffd
    80004384:	ac4080e7          	jalr	-1340(ra) # 80000e44 <myproc>
    80004388:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000438a:	0d050793          	addi	a5,a0,208
    8000438e:	4501                	li	a0,0
    80004390:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004392:	6398                	ld	a4,0(a5)
    80004394:	cb19                	beqz	a4,800043aa <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004396:	2505                	addiw	a0,a0,1
    80004398:	07a1                	addi	a5,a5,8
    8000439a:	fed51ce3          	bne	a0,a3,80004392 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000439e:	557d                	li	a0,-1
}
    800043a0:	60e2                	ld	ra,24(sp)
    800043a2:	6442                	ld	s0,16(sp)
    800043a4:	64a2                	ld	s1,8(sp)
    800043a6:	6105                	addi	sp,sp,32
    800043a8:	8082                	ret
      p->ofile[fd] = f;
    800043aa:	01a50793          	addi	a5,a0,26
    800043ae:	078e                	slli	a5,a5,0x3
    800043b0:	963e                	add	a2,a2,a5
    800043b2:	e204                	sd	s1,0(a2)
      return fd;
    800043b4:	b7f5                	j	800043a0 <fdalloc+0x2c>

00000000800043b6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800043b6:	715d                	addi	sp,sp,-80
    800043b8:	e486                	sd	ra,72(sp)
    800043ba:	e0a2                	sd	s0,64(sp)
    800043bc:	fc26                	sd	s1,56(sp)
    800043be:	f84a                	sd	s2,48(sp)
    800043c0:	f44e                	sd	s3,40(sp)
    800043c2:	f052                	sd	s4,32(sp)
    800043c4:	ec56                	sd	s5,24(sp)
    800043c6:	0880                	addi	s0,sp,80
    800043c8:	89ae                	mv	s3,a1
    800043ca:	8ab2                	mv	s5,a2
    800043cc:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800043ce:	fb040593          	addi	a1,s0,-80
    800043d2:	fffff097          	auipc	ra,0xfffff
    800043d6:	e74080e7          	jalr	-396(ra) # 80003246 <nameiparent>
    800043da:	892a                	mv	s2,a0
    800043dc:	12050e63          	beqz	a0,80004518 <create+0x162>
    return 0;

  ilock(dp);
    800043e0:	ffffe097          	auipc	ra,0xffffe
    800043e4:	68c080e7          	jalr	1676(ra) # 80002a6c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800043e8:	4601                	li	a2,0
    800043ea:	fb040593          	addi	a1,s0,-80
    800043ee:	854a                	mv	a0,s2
    800043f0:	fffff097          	auipc	ra,0xfffff
    800043f4:	b60080e7          	jalr	-1184(ra) # 80002f50 <dirlookup>
    800043f8:	84aa                	mv	s1,a0
    800043fa:	c921                	beqz	a0,8000444a <create+0x94>
    iunlockput(dp);
    800043fc:	854a                	mv	a0,s2
    800043fe:	fffff097          	auipc	ra,0xfffff
    80004402:	8d0080e7          	jalr	-1840(ra) # 80002cce <iunlockput>
    ilock(ip);
    80004406:	8526                	mv	a0,s1
    80004408:	ffffe097          	auipc	ra,0xffffe
    8000440c:	664080e7          	jalr	1636(ra) # 80002a6c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004410:	2981                	sext.w	s3,s3
    80004412:	4789                	li	a5,2
    80004414:	02f99463          	bne	s3,a5,8000443c <create+0x86>
    80004418:	0444d783          	lhu	a5,68(s1)
    8000441c:	37f9                	addiw	a5,a5,-2
    8000441e:	17c2                	slli	a5,a5,0x30
    80004420:	93c1                	srli	a5,a5,0x30
    80004422:	4705                	li	a4,1
    80004424:	00f76c63          	bltu	a4,a5,8000443c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004428:	8526                	mv	a0,s1
    8000442a:	60a6                	ld	ra,72(sp)
    8000442c:	6406                	ld	s0,64(sp)
    8000442e:	74e2                	ld	s1,56(sp)
    80004430:	7942                	ld	s2,48(sp)
    80004432:	79a2                	ld	s3,40(sp)
    80004434:	7a02                	ld	s4,32(sp)
    80004436:	6ae2                	ld	s5,24(sp)
    80004438:	6161                	addi	sp,sp,80
    8000443a:	8082                	ret
    iunlockput(ip);
    8000443c:	8526                	mv	a0,s1
    8000443e:	fffff097          	auipc	ra,0xfffff
    80004442:	890080e7          	jalr	-1904(ra) # 80002cce <iunlockput>
    return 0;
    80004446:	4481                	li	s1,0
    80004448:	b7c5                	j	80004428 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000444a:	85ce                	mv	a1,s3
    8000444c:	00092503          	lw	a0,0(s2)
    80004450:	ffffe097          	auipc	ra,0xffffe
    80004454:	482080e7          	jalr	1154(ra) # 800028d2 <ialloc>
    80004458:	84aa                	mv	s1,a0
    8000445a:	c521                	beqz	a0,800044a2 <create+0xec>
  ilock(ip);
    8000445c:	ffffe097          	auipc	ra,0xffffe
    80004460:	610080e7          	jalr	1552(ra) # 80002a6c <ilock>
  ip->major = major;
    80004464:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004468:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000446c:	4a05                	li	s4,1
    8000446e:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80004472:	8526                	mv	a0,s1
    80004474:	ffffe097          	auipc	ra,0xffffe
    80004478:	52c080e7          	jalr	1324(ra) # 800029a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000447c:	2981                	sext.w	s3,s3
    8000447e:	03498a63          	beq	s3,s4,800044b2 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004482:	40d0                	lw	a2,4(s1)
    80004484:	fb040593          	addi	a1,s0,-80
    80004488:	854a                	mv	a0,s2
    8000448a:	fffff097          	auipc	ra,0xfffff
    8000448e:	cdc080e7          	jalr	-804(ra) # 80003166 <dirlink>
    80004492:	06054b63          	bltz	a0,80004508 <create+0x152>
  iunlockput(dp);
    80004496:	854a                	mv	a0,s2
    80004498:	fffff097          	auipc	ra,0xfffff
    8000449c:	836080e7          	jalr	-1994(ra) # 80002cce <iunlockput>
  return ip;
    800044a0:	b761                	j	80004428 <create+0x72>
    panic("create: ialloc");
    800044a2:	00004517          	auipc	a0,0x4
    800044a6:	1c650513          	addi	a0,a0,454 # 80008668 <syscalls+0x2a0>
    800044aa:	00001097          	auipc	ra,0x1
    800044ae:	636080e7          	jalr	1590(ra) # 80005ae0 <panic>
    dp->nlink++;  // for ".."
    800044b2:	04a95783          	lhu	a5,74(s2)
    800044b6:	2785                	addiw	a5,a5,1
    800044b8:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800044bc:	854a                	mv	a0,s2
    800044be:	ffffe097          	auipc	ra,0xffffe
    800044c2:	4e2080e7          	jalr	1250(ra) # 800029a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800044c6:	40d0                	lw	a2,4(s1)
    800044c8:	00004597          	auipc	a1,0x4
    800044cc:	1b058593          	addi	a1,a1,432 # 80008678 <syscalls+0x2b0>
    800044d0:	8526                	mv	a0,s1
    800044d2:	fffff097          	auipc	ra,0xfffff
    800044d6:	c94080e7          	jalr	-876(ra) # 80003166 <dirlink>
    800044da:	00054f63          	bltz	a0,800044f8 <create+0x142>
    800044de:	00492603          	lw	a2,4(s2)
    800044e2:	00004597          	auipc	a1,0x4
    800044e6:	19e58593          	addi	a1,a1,414 # 80008680 <syscalls+0x2b8>
    800044ea:	8526                	mv	a0,s1
    800044ec:	fffff097          	auipc	ra,0xfffff
    800044f0:	c7a080e7          	jalr	-902(ra) # 80003166 <dirlink>
    800044f4:	f80557e3          	bgez	a0,80004482 <create+0xcc>
      panic("create dots");
    800044f8:	00004517          	auipc	a0,0x4
    800044fc:	19050513          	addi	a0,a0,400 # 80008688 <syscalls+0x2c0>
    80004500:	00001097          	auipc	ra,0x1
    80004504:	5e0080e7          	jalr	1504(ra) # 80005ae0 <panic>
    panic("create: dirlink");
    80004508:	00004517          	auipc	a0,0x4
    8000450c:	19050513          	addi	a0,a0,400 # 80008698 <syscalls+0x2d0>
    80004510:	00001097          	auipc	ra,0x1
    80004514:	5d0080e7          	jalr	1488(ra) # 80005ae0 <panic>
    return 0;
    80004518:	84aa                	mv	s1,a0
    8000451a:	b739                	j	80004428 <create+0x72>

000000008000451c <sys_dup>:
{
    8000451c:	7179                	addi	sp,sp,-48
    8000451e:	f406                	sd	ra,40(sp)
    80004520:	f022                	sd	s0,32(sp)
    80004522:	ec26                	sd	s1,24(sp)
    80004524:	e84a                	sd	s2,16(sp)
    80004526:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004528:	fd840613          	addi	a2,s0,-40
    8000452c:	4581                	li	a1,0
    8000452e:	4501                	li	a0,0
    80004530:	00000097          	auipc	ra,0x0
    80004534:	ddc080e7          	jalr	-548(ra) # 8000430c <argfd>
    return -1;
    80004538:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000453a:	02054363          	bltz	a0,80004560 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000453e:	fd843903          	ld	s2,-40(s0)
    80004542:	854a                	mv	a0,s2
    80004544:	00000097          	auipc	ra,0x0
    80004548:	e30080e7          	jalr	-464(ra) # 80004374 <fdalloc>
    8000454c:	84aa                	mv	s1,a0
    return -1;
    8000454e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004550:	00054863          	bltz	a0,80004560 <sys_dup+0x44>
  filedup(f);
    80004554:	854a                	mv	a0,s2
    80004556:	fffff097          	auipc	ra,0xfffff
    8000455a:	368080e7          	jalr	872(ra) # 800038be <filedup>
  return fd;
    8000455e:	87a6                	mv	a5,s1
}
    80004560:	853e                	mv	a0,a5
    80004562:	70a2                	ld	ra,40(sp)
    80004564:	7402                	ld	s0,32(sp)
    80004566:	64e2                	ld	s1,24(sp)
    80004568:	6942                	ld	s2,16(sp)
    8000456a:	6145                	addi	sp,sp,48
    8000456c:	8082                	ret

000000008000456e <sys_read>:
{
    8000456e:	7179                	addi	sp,sp,-48
    80004570:	f406                	sd	ra,40(sp)
    80004572:	f022                	sd	s0,32(sp)
    80004574:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004576:	fe840613          	addi	a2,s0,-24
    8000457a:	4581                	li	a1,0
    8000457c:	4501                	li	a0,0
    8000457e:	00000097          	auipc	ra,0x0
    80004582:	d8e080e7          	jalr	-626(ra) # 8000430c <argfd>
    return -1;
    80004586:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004588:	04054163          	bltz	a0,800045ca <sys_read+0x5c>
    8000458c:	fe440593          	addi	a1,s0,-28
    80004590:	4509                	li	a0,2
    80004592:	ffffe097          	auipc	ra,0xffffe
    80004596:	968080e7          	jalr	-1688(ra) # 80001efa <argint>
    return -1;
    8000459a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000459c:	02054763          	bltz	a0,800045ca <sys_read+0x5c>
    800045a0:	fd840593          	addi	a1,s0,-40
    800045a4:	4505                	li	a0,1
    800045a6:	ffffe097          	auipc	ra,0xffffe
    800045aa:	976080e7          	jalr	-1674(ra) # 80001f1c <argaddr>
    return -1;
    800045ae:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045b0:	00054d63          	bltz	a0,800045ca <sys_read+0x5c>
  return fileread(f, p, n);
    800045b4:	fe442603          	lw	a2,-28(s0)
    800045b8:	fd843583          	ld	a1,-40(s0)
    800045bc:	fe843503          	ld	a0,-24(s0)
    800045c0:	fffff097          	auipc	ra,0xfffff
    800045c4:	48a080e7          	jalr	1162(ra) # 80003a4a <fileread>
    800045c8:	87aa                	mv	a5,a0
}
    800045ca:	853e                	mv	a0,a5
    800045cc:	70a2                	ld	ra,40(sp)
    800045ce:	7402                	ld	s0,32(sp)
    800045d0:	6145                	addi	sp,sp,48
    800045d2:	8082                	ret

00000000800045d4 <sys_write>:
{
    800045d4:	7179                	addi	sp,sp,-48
    800045d6:	f406                	sd	ra,40(sp)
    800045d8:	f022                	sd	s0,32(sp)
    800045da:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045dc:	fe840613          	addi	a2,s0,-24
    800045e0:	4581                	li	a1,0
    800045e2:	4501                	li	a0,0
    800045e4:	00000097          	auipc	ra,0x0
    800045e8:	d28080e7          	jalr	-728(ra) # 8000430c <argfd>
    return -1;
    800045ec:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045ee:	04054163          	bltz	a0,80004630 <sys_write+0x5c>
    800045f2:	fe440593          	addi	a1,s0,-28
    800045f6:	4509                	li	a0,2
    800045f8:	ffffe097          	auipc	ra,0xffffe
    800045fc:	902080e7          	jalr	-1790(ra) # 80001efa <argint>
    return -1;
    80004600:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004602:	02054763          	bltz	a0,80004630 <sys_write+0x5c>
    80004606:	fd840593          	addi	a1,s0,-40
    8000460a:	4505                	li	a0,1
    8000460c:	ffffe097          	auipc	ra,0xffffe
    80004610:	910080e7          	jalr	-1776(ra) # 80001f1c <argaddr>
    return -1;
    80004614:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004616:	00054d63          	bltz	a0,80004630 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000461a:	fe442603          	lw	a2,-28(s0)
    8000461e:	fd843583          	ld	a1,-40(s0)
    80004622:	fe843503          	ld	a0,-24(s0)
    80004626:	fffff097          	auipc	ra,0xfffff
    8000462a:	4e6080e7          	jalr	1254(ra) # 80003b0c <filewrite>
    8000462e:	87aa                	mv	a5,a0
}
    80004630:	853e                	mv	a0,a5
    80004632:	70a2                	ld	ra,40(sp)
    80004634:	7402                	ld	s0,32(sp)
    80004636:	6145                	addi	sp,sp,48
    80004638:	8082                	ret

000000008000463a <sys_close>:
{
    8000463a:	1101                	addi	sp,sp,-32
    8000463c:	ec06                	sd	ra,24(sp)
    8000463e:	e822                	sd	s0,16(sp)
    80004640:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004642:	fe040613          	addi	a2,s0,-32
    80004646:	fec40593          	addi	a1,s0,-20
    8000464a:	4501                	li	a0,0
    8000464c:	00000097          	auipc	ra,0x0
    80004650:	cc0080e7          	jalr	-832(ra) # 8000430c <argfd>
    return -1;
    80004654:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004656:	02054463          	bltz	a0,8000467e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000465a:	ffffc097          	auipc	ra,0xffffc
    8000465e:	7ea080e7          	jalr	2026(ra) # 80000e44 <myproc>
    80004662:	fec42783          	lw	a5,-20(s0)
    80004666:	07e9                	addi	a5,a5,26
    80004668:	078e                	slli	a5,a5,0x3
    8000466a:	953e                	add	a0,a0,a5
    8000466c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004670:	fe043503          	ld	a0,-32(s0)
    80004674:	fffff097          	auipc	ra,0xfffff
    80004678:	29c080e7          	jalr	668(ra) # 80003910 <fileclose>
  return 0;
    8000467c:	4781                	li	a5,0
}
    8000467e:	853e                	mv	a0,a5
    80004680:	60e2                	ld	ra,24(sp)
    80004682:	6442                	ld	s0,16(sp)
    80004684:	6105                	addi	sp,sp,32
    80004686:	8082                	ret

0000000080004688 <sys_fstat>:
{
    80004688:	1101                	addi	sp,sp,-32
    8000468a:	ec06                	sd	ra,24(sp)
    8000468c:	e822                	sd	s0,16(sp)
    8000468e:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004690:	fe840613          	addi	a2,s0,-24
    80004694:	4581                	li	a1,0
    80004696:	4501                	li	a0,0
    80004698:	00000097          	auipc	ra,0x0
    8000469c:	c74080e7          	jalr	-908(ra) # 8000430c <argfd>
    return -1;
    800046a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800046a2:	02054563          	bltz	a0,800046cc <sys_fstat+0x44>
    800046a6:	fe040593          	addi	a1,s0,-32
    800046aa:	4505                	li	a0,1
    800046ac:	ffffe097          	auipc	ra,0xffffe
    800046b0:	870080e7          	jalr	-1936(ra) # 80001f1c <argaddr>
    return -1;
    800046b4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800046b6:	00054b63          	bltz	a0,800046cc <sys_fstat+0x44>
  return filestat(f, st);
    800046ba:	fe043583          	ld	a1,-32(s0)
    800046be:	fe843503          	ld	a0,-24(s0)
    800046c2:	fffff097          	auipc	ra,0xfffff
    800046c6:	316080e7          	jalr	790(ra) # 800039d8 <filestat>
    800046ca:	87aa                	mv	a5,a0
}
    800046cc:	853e                	mv	a0,a5
    800046ce:	60e2                	ld	ra,24(sp)
    800046d0:	6442                	ld	s0,16(sp)
    800046d2:	6105                	addi	sp,sp,32
    800046d4:	8082                	ret

00000000800046d6 <sys_link>:
{
    800046d6:	7169                	addi	sp,sp,-304
    800046d8:	f606                	sd	ra,296(sp)
    800046da:	f222                	sd	s0,288(sp)
    800046dc:	ee26                	sd	s1,280(sp)
    800046de:	ea4a                	sd	s2,272(sp)
    800046e0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800046e2:	08000613          	li	a2,128
    800046e6:	ed040593          	addi	a1,s0,-304
    800046ea:	4501                	li	a0,0
    800046ec:	ffffe097          	auipc	ra,0xffffe
    800046f0:	852080e7          	jalr	-1966(ra) # 80001f3e <argstr>
    return -1;
    800046f4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800046f6:	10054e63          	bltz	a0,80004812 <sys_link+0x13c>
    800046fa:	08000613          	li	a2,128
    800046fe:	f5040593          	addi	a1,s0,-176
    80004702:	4505                	li	a0,1
    80004704:	ffffe097          	auipc	ra,0xffffe
    80004708:	83a080e7          	jalr	-1990(ra) # 80001f3e <argstr>
    return -1;
    8000470c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000470e:	10054263          	bltz	a0,80004812 <sys_link+0x13c>
  begin_op();
    80004712:	fffff097          	auipc	ra,0xfffff
    80004716:	d36080e7          	jalr	-714(ra) # 80003448 <begin_op>
  if((ip = namei(old)) == 0){
    8000471a:	ed040513          	addi	a0,s0,-304
    8000471e:	fffff097          	auipc	ra,0xfffff
    80004722:	b0a080e7          	jalr	-1270(ra) # 80003228 <namei>
    80004726:	84aa                	mv	s1,a0
    80004728:	c551                	beqz	a0,800047b4 <sys_link+0xde>
  ilock(ip);
    8000472a:	ffffe097          	auipc	ra,0xffffe
    8000472e:	342080e7          	jalr	834(ra) # 80002a6c <ilock>
  if(ip->type == T_DIR){
    80004732:	04449703          	lh	a4,68(s1)
    80004736:	4785                	li	a5,1
    80004738:	08f70463          	beq	a4,a5,800047c0 <sys_link+0xea>
  ip->nlink++;
    8000473c:	04a4d783          	lhu	a5,74(s1)
    80004740:	2785                	addiw	a5,a5,1
    80004742:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004746:	8526                	mv	a0,s1
    80004748:	ffffe097          	auipc	ra,0xffffe
    8000474c:	258080e7          	jalr	600(ra) # 800029a0 <iupdate>
  iunlock(ip);
    80004750:	8526                	mv	a0,s1
    80004752:	ffffe097          	auipc	ra,0xffffe
    80004756:	3dc080e7          	jalr	988(ra) # 80002b2e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000475a:	fd040593          	addi	a1,s0,-48
    8000475e:	f5040513          	addi	a0,s0,-176
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	ae4080e7          	jalr	-1308(ra) # 80003246 <nameiparent>
    8000476a:	892a                	mv	s2,a0
    8000476c:	c935                	beqz	a0,800047e0 <sys_link+0x10a>
  ilock(dp);
    8000476e:	ffffe097          	auipc	ra,0xffffe
    80004772:	2fe080e7          	jalr	766(ra) # 80002a6c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004776:	00092703          	lw	a4,0(s2)
    8000477a:	409c                	lw	a5,0(s1)
    8000477c:	04f71d63          	bne	a4,a5,800047d6 <sys_link+0x100>
    80004780:	40d0                	lw	a2,4(s1)
    80004782:	fd040593          	addi	a1,s0,-48
    80004786:	854a                	mv	a0,s2
    80004788:	fffff097          	auipc	ra,0xfffff
    8000478c:	9de080e7          	jalr	-1570(ra) # 80003166 <dirlink>
    80004790:	04054363          	bltz	a0,800047d6 <sys_link+0x100>
  iunlockput(dp);
    80004794:	854a                	mv	a0,s2
    80004796:	ffffe097          	auipc	ra,0xffffe
    8000479a:	538080e7          	jalr	1336(ra) # 80002cce <iunlockput>
  iput(ip);
    8000479e:	8526                	mv	a0,s1
    800047a0:	ffffe097          	auipc	ra,0xffffe
    800047a4:	486080e7          	jalr	1158(ra) # 80002c26 <iput>
  end_op();
    800047a8:	fffff097          	auipc	ra,0xfffff
    800047ac:	d1e080e7          	jalr	-738(ra) # 800034c6 <end_op>
  return 0;
    800047b0:	4781                	li	a5,0
    800047b2:	a085                	j	80004812 <sys_link+0x13c>
    end_op();
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	d12080e7          	jalr	-750(ra) # 800034c6 <end_op>
    return -1;
    800047bc:	57fd                	li	a5,-1
    800047be:	a891                	j	80004812 <sys_link+0x13c>
    iunlockput(ip);
    800047c0:	8526                	mv	a0,s1
    800047c2:	ffffe097          	auipc	ra,0xffffe
    800047c6:	50c080e7          	jalr	1292(ra) # 80002cce <iunlockput>
    end_op();
    800047ca:	fffff097          	auipc	ra,0xfffff
    800047ce:	cfc080e7          	jalr	-772(ra) # 800034c6 <end_op>
    return -1;
    800047d2:	57fd                	li	a5,-1
    800047d4:	a83d                	j	80004812 <sys_link+0x13c>
    iunlockput(dp);
    800047d6:	854a                	mv	a0,s2
    800047d8:	ffffe097          	auipc	ra,0xffffe
    800047dc:	4f6080e7          	jalr	1270(ra) # 80002cce <iunlockput>
  ilock(ip);
    800047e0:	8526                	mv	a0,s1
    800047e2:	ffffe097          	auipc	ra,0xffffe
    800047e6:	28a080e7          	jalr	650(ra) # 80002a6c <ilock>
  ip->nlink--;
    800047ea:	04a4d783          	lhu	a5,74(s1)
    800047ee:	37fd                	addiw	a5,a5,-1
    800047f0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047f4:	8526                	mv	a0,s1
    800047f6:	ffffe097          	auipc	ra,0xffffe
    800047fa:	1aa080e7          	jalr	426(ra) # 800029a0 <iupdate>
  iunlockput(ip);
    800047fe:	8526                	mv	a0,s1
    80004800:	ffffe097          	auipc	ra,0xffffe
    80004804:	4ce080e7          	jalr	1230(ra) # 80002cce <iunlockput>
  end_op();
    80004808:	fffff097          	auipc	ra,0xfffff
    8000480c:	cbe080e7          	jalr	-834(ra) # 800034c6 <end_op>
  return -1;
    80004810:	57fd                	li	a5,-1
}
    80004812:	853e                	mv	a0,a5
    80004814:	70b2                	ld	ra,296(sp)
    80004816:	7412                	ld	s0,288(sp)
    80004818:	64f2                	ld	s1,280(sp)
    8000481a:	6952                	ld	s2,272(sp)
    8000481c:	6155                	addi	sp,sp,304
    8000481e:	8082                	ret

0000000080004820 <sys_unlink>:
{
    80004820:	7151                	addi	sp,sp,-240
    80004822:	f586                	sd	ra,232(sp)
    80004824:	f1a2                	sd	s0,224(sp)
    80004826:	eda6                	sd	s1,216(sp)
    80004828:	e9ca                	sd	s2,208(sp)
    8000482a:	e5ce                	sd	s3,200(sp)
    8000482c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000482e:	08000613          	li	a2,128
    80004832:	f3040593          	addi	a1,s0,-208
    80004836:	4501                	li	a0,0
    80004838:	ffffd097          	auipc	ra,0xffffd
    8000483c:	706080e7          	jalr	1798(ra) # 80001f3e <argstr>
    80004840:	18054163          	bltz	a0,800049c2 <sys_unlink+0x1a2>
  begin_op();
    80004844:	fffff097          	auipc	ra,0xfffff
    80004848:	c04080e7          	jalr	-1020(ra) # 80003448 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000484c:	fb040593          	addi	a1,s0,-80
    80004850:	f3040513          	addi	a0,s0,-208
    80004854:	fffff097          	auipc	ra,0xfffff
    80004858:	9f2080e7          	jalr	-1550(ra) # 80003246 <nameiparent>
    8000485c:	84aa                	mv	s1,a0
    8000485e:	c979                	beqz	a0,80004934 <sys_unlink+0x114>
  ilock(dp);
    80004860:	ffffe097          	auipc	ra,0xffffe
    80004864:	20c080e7          	jalr	524(ra) # 80002a6c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004868:	00004597          	auipc	a1,0x4
    8000486c:	e1058593          	addi	a1,a1,-496 # 80008678 <syscalls+0x2b0>
    80004870:	fb040513          	addi	a0,s0,-80
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	6c2080e7          	jalr	1730(ra) # 80002f36 <namecmp>
    8000487c:	14050a63          	beqz	a0,800049d0 <sys_unlink+0x1b0>
    80004880:	00004597          	auipc	a1,0x4
    80004884:	e0058593          	addi	a1,a1,-512 # 80008680 <syscalls+0x2b8>
    80004888:	fb040513          	addi	a0,s0,-80
    8000488c:	ffffe097          	auipc	ra,0xffffe
    80004890:	6aa080e7          	jalr	1706(ra) # 80002f36 <namecmp>
    80004894:	12050e63          	beqz	a0,800049d0 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004898:	f2c40613          	addi	a2,s0,-212
    8000489c:	fb040593          	addi	a1,s0,-80
    800048a0:	8526                	mv	a0,s1
    800048a2:	ffffe097          	auipc	ra,0xffffe
    800048a6:	6ae080e7          	jalr	1710(ra) # 80002f50 <dirlookup>
    800048aa:	892a                	mv	s2,a0
    800048ac:	12050263          	beqz	a0,800049d0 <sys_unlink+0x1b0>
  ilock(ip);
    800048b0:	ffffe097          	auipc	ra,0xffffe
    800048b4:	1bc080e7          	jalr	444(ra) # 80002a6c <ilock>
  if(ip->nlink < 1)
    800048b8:	04a91783          	lh	a5,74(s2)
    800048bc:	08f05263          	blez	a5,80004940 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800048c0:	04491703          	lh	a4,68(s2)
    800048c4:	4785                	li	a5,1
    800048c6:	08f70563          	beq	a4,a5,80004950 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800048ca:	4641                	li	a2,16
    800048cc:	4581                	li	a1,0
    800048ce:	fc040513          	addi	a0,s0,-64
    800048d2:	ffffc097          	auipc	ra,0xffffc
    800048d6:	8a8080e7          	jalr	-1880(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800048da:	4741                	li	a4,16
    800048dc:	f2c42683          	lw	a3,-212(s0)
    800048e0:	fc040613          	addi	a2,s0,-64
    800048e4:	4581                	li	a1,0
    800048e6:	8526                	mv	a0,s1
    800048e8:	ffffe097          	auipc	ra,0xffffe
    800048ec:	530080e7          	jalr	1328(ra) # 80002e18 <writei>
    800048f0:	47c1                	li	a5,16
    800048f2:	0af51563          	bne	a0,a5,8000499c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800048f6:	04491703          	lh	a4,68(s2)
    800048fa:	4785                	li	a5,1
    800048fc:	0af70863          	beq	a4,a5,800049ac <sys_unlink+0x18c>
  iunlockput(dp);
    80004900:	8526                	mv	a0,s1
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	3cc080e7          	jalr	972(ra) # 80002cce <iunlockput>
  ip->nlink--;
    8000490a:	04a95783          	lhu	a5,74(s2)
    8000490e:	37fd                	addiw	a5,a5,-1
    80004910:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004914:	854a                	mv	a0,s2
    80004916:	ffffe097          	auipc	ra,0xffffe
    8000491a:	08a080e7          	jalr	138(ra) # 800029a0 <iupdate>
  iunlockput(ip);
    8000491e:	854a                	mv	a0,s2
    80004920:	ffffe097          	auipc	ra,0xffffe
    80004924:	3ae080e7          	jalr	942(ra) # 80002cce <iunlockput>
  end_op();
    80004928:	fffff097          	auipc	ra,0xfffff
    8000492c:	b9e080e7          	jalr	-1122(ra) # 800034c6 <end_op>
  return 0;
    80004930:	4501                	li	a0,0
    80004932:	a84d                	j	800049e4 <sys_unlink+0x1c4>
    end_op();
    80004934:	fffff097          	auipc	ra,0xfffff
    80004938:	b92080e7          	jalr	-1134(ra) # 800034c6 <end_op>
    return -1;
    8000493c:	557d                	li	a0,-1
    8000493e:	a05d                	j	800049e4 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004940:	00004517          	auipc	a0,0x4
    80004944:	d6850513          	addi	a0,a0,-664 # 800086a8 <syscalls+0x2e0>
    80004948:	00001097          	auipc	ra,0x1
    8000494c:	198080e7          	jalr	408(ra) # 80005ae0 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004950:	04c92703          	lw	a4,76(s2)
    80004954:	02000793          	li	a5,32
    80004958:	f6e7f9e3          	bgeu	a5,a4,800048ca <sys_unlink+0xaa>
    8000495c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004960:	4741                	li	a4,16
    80004962:	86ce                	mv	a3,s3
    80004964:	f1840613          	addi	a2,s0,-232
    80004968:	4581                	li	a1,0
    8000496a:	854a                	mv	a0,s2
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	3b4080e7          	jalr	948(ra) # 80002d20 <readi>
    80004974:	47c1                	li	a5,16
    80004976:	00f51b63          	bne	a0,a5,8000498c <sys_unlink+0x16c>
    if(de.inum != 0)
    8000497a:	f1845783          	lhu	a5,-232(s0)
    8000497e:	e7a1                	bnez	a5,800049c6 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004980:	29c1                	addiw	s3,s3,16
    80004982:	04c92783          	lw	a5,76(s2)
    80004986:	fcf9ede3          	bltu	s3,a5,80004960 <sys_unlink+0x140>
    8000498a:	b781                	j	800048ca <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000498c:	00004517          	auipc	a0,0x4
    80004990:	d3450513          	addi	a0,a0,-716 # 800086c0 <syscalls+0x2f8>
    80004994:	00001097          	auipc	ra,0x1
    80004998:	14c080e7          	jalr	332(ra) # 80005ae0 <panic>
    panic("unlink: writei");
    8000499c:	00004517          	auipc	a0,0x4
    800049a0:	d3c50513          	addi	a0,a0,-708 # 800086d8 <syscalls+0x310>
    800049a4:	00001097          	auipc	ra,0x1
    800049a8:	13c080e7          	jalr	316(ra) # 80005ae0 <panic>
    dp->nlink--;
    800049ac:	04a4d783          	lhu	a5,74(s1)
    800049b0:	37fd                	addiw	a5,a5,-1
    800049b2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800049b6:	8526                	mv	a0,s1
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	fe8080e7          	jalr	-24(ra) # 800029a0 <iupdate>
    800049c0:	b781                	j	80004900 <sys_unlink+0xe0>
    return -1;
    800049c2:	557d                	li	a0,-1
    800049c4:	a005                	j	800049e4 <sys_unlink+0x1c4>
    iunlockput(ip);
    800049c6:	854a                	mv	a0,s2
    800049c8:	ffffe097          	auipc	ra,0xffffe
    800049cc:	306080e7          	jalr	774(ra) # 80002cce <iunlockput>
  iunlockput(dp);
    800049d0:	8526                	mv	a0,s1
    800049d2:	ffffe097          	auipc	ra,0xffffe
    800049d6:	2fc080e7          	jalr	764(ra) # 80002cce <iunlockput>
  end_op();
    800049da:	fffff097          	auipc	ra,0xfffff
    800049de:	aec080e7          	jalr	-1300(ra) # 800034c6 <end_op>
  return -1;
    800049e2:	557d                	li	a0,-1
}
    800049e4:	70ae                	ld	ra,232(sp)
    800049e6:	740e                	ld	s0,224(sp)
    800049e8:	64ee                	ld	s1,216(sp)
    800049ea:	694e                	ld	s2,208(sp)
    800049ec:	69ae                	ld	s3,200(sp)
    800049ee:	616d                	addi	sp,sp,240
    800049f0:	8082                	ret

00000000800049f2 <sys_open>:

uint64
sys_open(void)
{
    800049f2:	7131                	addi	sp,sp,-192
    800049f4:	fd06                	sd	ra,184(sp)
    800049f6:	f922                	sd	s0,176(sp)
    800049f8:	f526                	sd	s1,168(sp)
    800049fa:	f14a                	sd	s2,160(sp)
    800049fc:	ed4e                	sd	s3,152(sp)
    800049fe:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004a00:	08000613          	li	a2,128
    80004a04:	f5040593          	addi	a1,s0,-176
    80004a08:	4501                	li	a0,0
    80004a0a:	ffffd097          	auipc	ra,0xffffd
    80004a0e:	534080e7          	jalr	1332(ra) # 80001f3e <argstr>
    return -1;
    80004a12:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004a14:	0c054163          	bltz	a0,80004ad6 <sys_open+0xe4>
    80004a18:	f4c40593          	addi	a1,s0,-180
    80004a1c:	4505                	li	a0,1
    80004a1e:	ffffd097          	auipc	ra,0xffffd
    80004a22:	4dc080e7          	jalr	1244(ra) # 80001efa <argint>
    80004a26:	0a054863          	bltz	a0,80004ad6 <sys_open+0xe4>

  begin_op();
    80004a2a:	fffff097          	auipc	ra,0xfffff
    80004a2e:	a1e080e7          	jalr	-1506(ra) # 80003448 <begin_op>

  if(omode & O_CREATE){
    80004a32:	f4c42783          	lw	a5,-180(s0)
    80004a36:	2007f793          	andi	a5,a5,512
    80004a3a:	cbdd                	beqz	a5,80004af0 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004a3c:	4681                	li	a3,0
    80004a3e:	4601                	li	a2,0
    80004a40:	4589                	li	a1,2
    80004a42:	f5040513          	addi	a0,s0,-176
    80004a46:	00000097          	auipc	ra,0x0
    80004a4a:	970080e7          	jalr	-1680(ra) # 800043b6 <create>
    80004a4e:	892a                	mv	s2,a0
    if(ip == 0){
    80004a50:	c959                	beqz	a0,80004ae6 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004a52:	04491703          	lh	a4,68(s2)
    80004a56:	478d                	li	a5,3
    80004a58:	00f71763          	bne	a4,a5,80004a66 <sys_open+0x74>
    80004a5c:	04695703          	lhu	a4,70(s2)
    80004a60:	47a5                	li	a5,9
    80004a62:	0ce7ec63          	bltu	a5,a4,80004b3a <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004a66:	fffff097          	auipc	ra,0xfffff
    80004a6a:	dee080e7          	jalr	-530(ra) # 80003854 <filealloc>
    80004a6e:	89aa                	mv	s3,a0
    80004a70:	10050263          	beqz	a0,80004b74 <sys_open+0x182>
    80004a74:	00000097          	auipc	ra,0x0
    80004a78:	900080e7          	jalr	-1792(ra) # 80004374 <fdalloc>
    80004a7c:	84aa                	mv	s1,a0
    80004a7e:	0e054663          	bltz	a0,80004b6a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004a82:	04491703          	lh	a4,68(s2)
    80004a86:	478d                	li	a5,3
    80004a88:	0cf70463          	beq	a4,a5,80004b50 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004a8c:	4789                	li	a5,2
    80004a8e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004a92:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004a96:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004a9a:	f4c42783          	lw	a5,-180(s0)
    80004a9e:	0017c713          	xori	a4,a5,1
    80004aa2:	8b05                	andi	a4,a4,1
    80004aa4:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004aa8:	0037f713          	andi	a4,a5,3
    80004aac:	00e03733          	snez	a4,a4
    80004ab0:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004ab4:	4007f793          	andi	a5,a5,1024
    80004ab8:	c791                	beqz	a5,80004ac4 <sys_open+0xd2>
    80004aba:	04491703          	lh	a4,68(s2)
    80004abe:	4789                	li	a5,2
    80004ac0:	08f70f63          	beq	a4,a5,80004b5e <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004ac4:	854a                	mv	a0,s2
    80004ac6:	ffffe097          	auipc	ra,0xffffe
    80004aca:	068080e7          	jalr	104(ra) # 80002b2e <iunlock>
  end_op();
    80004ace:	fffff097          	auipc	ra,0xfffff
    80004ad2:	9f8080e7          	jalr	-1544(ra) # 800034c6 <end_op>

  return fd;
}
    80004ad6:	8526                	mv	a0,s1
    80004ad8:	70ea                	ld	ra,184(sp)
    80004ada:	744a                	ld	s0,176(sp)
    80004adc:	74aa                	ld	s1,168(sp)
    80004ade:	790a                	ld	s2,160(sp)
    80004ae0:	69ea                	ld	s3,152(sp)
    80004ae2:	6129                	addi	sp,sp,192
    80004ae4:	8082                	ret
      end_op();
    80004ae6:	fffff097          	auipc	ra,0xfffff
    80004aea:	9e0080e7          	jalr	-1568(ra) # 800034c6 <end_op>
      return -1;
    80004aee:	b7e5                	j	80004ad6 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004af0:	f5040513          	addi	a0,s0,-176
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	734080e7          	jalr	1844(ra) # 80003228 <namei>
    80004afc:	892a                	mv	s2,a0
    80004afe:	c905                	beqz	a0,80004b2e <sys_open+0x13c>
    ilock(ip);
    80004b00:	ffffe097          	auipc	ra,0xffffe
    80004b04:	f6c080e7          	jalr	-148(ra) # 80002a6c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004b08:	04491703          	lh	a4,68(s2)
    80004b0c:	4785                	li	a5,1
    80004b0e:	f4f712e3          	bne	a4,a5,80004a52 <sys_open+0x60>
    80004b12:	f4c42783          	lw	a5,-180(s0)
    80004b16:	dba1                	beqz	a5,80004a66 <sys_open+0x74>
      iunlockput(ip);
    80004b18:	854a                	mv	a0,s2
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	1b4080e7          	jalr	436(ra) # 80002cce <iunlockput>
      end_op();
    80004b22:	fffff097          	auipc	ra,0xfffff
    80004b26:	9a4080e7          	jalr	-1628(ra) # 800034c6 <end_op>
      return -1;
    80004b2a:	54fd                	li	s1,-1
    80004b2c:	b76d                	j	80004ad6 <sys_open+0xe4>
      end_op();
    80004b2e:	fffff097          	auipc	ra,0xfffff
    80004b32:	998080e7          	jalr	-1640(ra) # 800034c6 <end_op>
      return -1;
    80004b36:	54fd                	li	s1,-1
    80004b38:	bf79                	j	80004ad6 <sys_open+0xe4>
    iunlockput(ip);
    80004b3a:	854a                	mv	a0,s2
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	192080e7          	jalr	402(ra) # 80002cce <iunlockput>
    end_op();
    80004b44:	fffff097          	auipc	ra,0xfffff
    80004b48:	982080e7          	jalr	-1662(ra) # 800034c6 <end_op>
    return -1;
    80004b4c:	54fd                	li	s1,-1
    80004b4e:	b761                	j	80004ad6 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004b50:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004b54:	04691783          	lh	a5,70(s2)
    80004b58:	02f99223          	sh	a5,36(s3)
    80004b5c:	bf2d                	j	80004a96 <sys_open+0xa4>
    itrunc(ip);
    80004b5e:	854a                	mv	a0,s2
    80004b60:	ffffe097          	auipc	ra,0xffffe
    80004b64:	01a080e7          	jalr	26(ra) # 80002b7a <itrunc>
    80004b68:	bfb1                	j	80004ac4 <sys_open+0xd2>
      fileclose(f);
    80004b6a:	854e                	mv	a0,s3
    80004b6c:	fffff097          	auipc	ra,0xfffff
    80004b70:	da4080e7          	jalr	-604(ra) # 80003910 <fileclose>
    iunlockput(ip);
    80004b74:	854a                	mv	a0,s2
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	158080e7          	jalr	344(ra) # 80002cce <iunlockput>
    end_op();
    80004b7e:	fffff097          	auipc	ra,0xfffff
    80004b82:	948080e7          	jalr	-1720(ra) # 800034c6 <end_op>
    return -1;
    80004b86:	54fd                	li	s1,-1
    80004b88:	b7b9                	j	80004ad6 <sys_open+0xe4>

0000000080004b8a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004b8a:	7175                	addi	sp,sp,-144
    80004b8c:	e506                	sd	ra,136(sp)
    80004b8e:	e122                	sd	s0,128(sp)
    80004b90:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004b92:	fffff097          	auipc	ra,0xfffff
    80004b96:	8b6080e7          	jalr	-1866(ra) # 80003448 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004b9a:	08000613          	li	a2,128
    80004b9e:	f7040593          	addi	a1,s0,-144
    80004ba2:	4501                	li	a0,0
    80004ba4:	ffffd097          	auipc	ra,0xffffd
    80004ba8:	39a080e7          	jalr	922(ra) # 80001f3e <argstr>
    80004bac:	02054963          	bltz	a0,80004bde <sys_mkdir+0x54>
    80004bb0:	4681                	li	a3,0
    80004bb2:	4601                	li	a2,0
    80004bb4:	4585                	li	a1,1
    80004bb6:	f7040513          	addi	a0,s0,-144
    80004bba:	fffff097          	auipc	ra,0xfffff
    80004bbe:	7fc080e7          	jalr	2044(ra) # 800043b6 <create>
    80004bc2:	cd11                	beqz	a0,80004bde <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004bc4:	ffffe097          	auipc	ra,0xffffe
    80004bc8:	10a080e7          	jalr	266(ra) # 80002cce <iunlockput>
  end_op();
    80004bcc:	fffff097          	auipc	ra,0xfffff
    80004bd0:	8fa080e7          	jalr	-1798(ra) # 800034c6 <end_op>
  return 0;
    80004bd4:	4501                	li	a0,0
}
    80004bd6:	60aa                	ld	ra,136(sp)
    80004bd8:	640a                	ld	s0,128(sp)
    80004bda:	6149                	addi	sp,sp,144
    80004bdc:	8082                	ret
    end_op();
    80004bde:	fffff097          	auipc	ra,0xfffff
    80004be2:	8e8080e7          	jalr	-1816(ra) # 800034c6 <end_op>
    return -1;
    80004be6:	557d                	li	a0,-1
    80004be8:	b7fd                	j	80004bd6 <sys_mkdir+0x4c>

0000000080004bea <sys_mknod>:

uint64
sys_mknod(void)
{
    80004bea:	7135                	addi	sp,sp,-160
    80004bec:	ed06                	sd	ra,152(sp)
    80004bee:	e922                	sd	s0,144(sp)
    80004bf0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004bf2:	fffff097          	auipc	ra,0xfffff
    80004bf6:	856080e7          	jalr	-1962(ra) # 80003448 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004bfa:	08000613          	li	a2,128
    80004bfe:	f7040593          	addi	a1,s0,-144
    80004c02:	4501                	li	a0,0
    80004c04:	ffffd097          	auipc	ra,0xffffd
    80004c08:	33a080e7          	jalr	826(ra) # 80001f3e <argstr>
    80004c0c:	04054a63          	bltz	a0,80004c60 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004c10:	f6c40593          	addi	a1,s0,-148
    80004c14:	4505                	li	a0,1
    80004c16:	ffffd097          	auipc	ra,0xffffd
    80004c1a:	2e4080e7          	jalr	740(ra) # 80001efa <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c1e:	04054163          	bltz	a0,80004c60 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004c22:	f6840593          	addi	a1,s0,-152
    80004c26:	4509                	li	a0,2
    80004c28:	ffffd097          	auipc	ra,0xffffd
    80004c2c:	2d2080e7          	jalr	722(ra) # 80001efa <argint>
     argint(1, &major) < 0 ||
    80004c30:	02054863          	bltz	a0,80004c60 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004c34:	f6841683          	lh	a3,-152(s0)
    80004c38:	f6c41603          	lh	a2,-148(s0)
    80004c3c:	458d                	li	a1,3
    80004c3e:	f7040513          	addi	a0,s0,-144
    80004c42:	fffff097          	auipc	ra,0xfffff
    80004c46:	774080e7          	jalr	1908(ra) # 800043b6 <create>
     argint(2, &minor) < 0 ||
    80004c4a:	c919                	beqz	a0,80004c60 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c4c:	ffffe097          	auipc	ra,0xffffe
    80004c50:	082080e7          	jalr	130(ra) # 80002cce <iunlockput>
  end_op();
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	872080e7          	jalr	-1934(ra) # 800034c6 <end_op>
  return 0;
    80004c5c:	4501                	li	a0,0
    80004c5e:	a031                	j	80004c6a <sys_mknod+0x80>
    end_op();
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	866080e7          	jalr	-1946(ra) # 800034c6 <end_op>
    return -1;
    80004c68:	557d                	li	a0,-1
}
    80004c6a:	60ea                	ld	ra,152(sp)
    80004c6c:	644a                	ld	s0,144(sp)
    80004c6e:	610d                	addi	sp,sp,160
    80004c70:	8082                	ret

0000000080004c72 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004c72:	7135                	addi	sp,sp,-160
    80004c74:	ed06                	sd	ra,152(sp)
    80004c76:	e922                	sd	s0,144(sp)
    80004c78:	e526                	sd	s1,136(sp)
    80004c7a:	e14a                	sd	s2,128(sp)
    80004c7c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004c7e:	ffffc097          	auipc	ra,0xffffc
    80004c82:	1c6080e7          	jalr	454(ra) # 80000e44 <myproc>
    80004c86:	892a                	mv	s2,a0
  
  begin_op();
    80004c88:	ffffe097          	auipc	ra,0xffffe
    80004c8c:	7c0080e7          	jalr	1984(ra) # 80003448 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004c90:	08000613          	li	a2,128
    80004c94:	f6040593          	addi	a1,s0,-160
    80004c98:	4501                	li	a0,0
    80004c9a:	ffffd097          	auipc	ra,0xffffd
    80004c9e:	2a4080e7          	jalr	676(ra) # 80001f3e <argstr>
    80004ca2:	04054b63          	bltz	a0,80004cf8 <sys_chdir+0x86>
    80004ca6:	f6040513          	addi	a0,s0,-160
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	57e080e7          	jalr	1406(ra) # 80003228 <namei>
    80004cb2:	84aa                	mv	s1,a0
    80004cb4:	c131                	beqz	a0,80004cf8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004cb6:	ffffe097          	auipc	ra,0xffffe
    80004cba:	db6080e7          	jalr	-586(ra) # 80002a6c <ilock>
  if(ip->type != T_DIR){
    80004cbe:	04449703          	lh	a4,68(s1)
    80004cc2:	4785                	li	a5,1
    80004cc4:	04f71063          	bne	a4,a5,80004d04 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004cc8:	8526                	mv	a0,s1
    80004cca:	ffffe097          	auipc	ra,0xffffe
    80004cce:	e64080e7          	jalr	-412(ra) # 80002b2e <iunlock>
  iput(p->cwd);
    80004cd2:	15093503          	ld	a0,336(s2)
    80004cd6:	ffffe097          	auipc	ra,0xffffe
    80004cda:	f50080e7          	jalr	-176(ra) # 80002c26 <iput>
  end_op();
    80004cde:	ffffe097          	auipc	ra,0xffffe
    80004ce2:	7e8080e7          	jalr	2024(ra) # 800034c6 <end_op>
  p->cwd = ip;
    80004ce6:	14993823          	sd	s1,336(s2)
  return 0;
    80004cea:	4501                	li	a0,0
}
    80004cec:	60ea                	ld	ra,152(sp)
    80004cee:	644a                	ld	s0,144(sp)
    80004cf0:	64aa                	ld	s1,136(sp)
    80004cf2:	690a                	ld	s2,128(sp)
    80004cf4:	610d                	addi	sp,sp,160
    80004cf6:	8082                	ret
    end_op();
    80004cf8:	ffffe097          	auipc	ra,0xffffe
    80004cfc:	7ce080e7          	jalr	1998(ra) # 800034c6 <end_op>
    return -1;
    80004d00:	557d                	li	a0,-1
    80004d02:	b7ed                	j	80004cec <sys_chdir+0x7a>
    iunlockput(ip);
    80004d04:	8526                	mv	a0,s1
    80004d06:	ffffe097          	auipc	ra,0xffffe
    80004d0a:	fc8080e7          	jalr	-56(ra) # 80002cce <iunlockput>
    end_op();
    80004d0e:	ffffe097          	auipc	ra,0xffffe
    80004d12:	7b8080e7          	jalr	1976(ra) # 800034c6 <end_op>
    return -1;
    80004d16:	557d                	li	a0,-1
    80004d18:	bfd1                	j	80004cec <sys_chdir+0x7a>

0000000080004d1a <sys_exec>:

uint64
sys_exec(void)
{
    80004d1a:	7145                	addi	sp,sp,-464
    80004d1c:	e786                	sd	ra,456(sp)
    80004d1e:	e3a2                	sd	s0,448(sp)
    80004d20:	ff26                	sd	s1,440(sp)
    80004d22:	fb4a                	sd	s2,432(sp)
    80004d24:	f74e                	sd	s3,424(sp)
    80004d26:	f352                	sd	s4,416(sp)
    80004d28:	ef56                	sd	s5,408(sp)
    80004d2a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004d2c:	08000613          	li	a2,128
    80004d30:	f4040593          	addi	a1,s0,-192
    80004d34:	4501                	li	a0,0
    80004d36:	ffffd097          	auipc	ra,0xffffd
    80004d3a:	208080e7          	jalr	520(ra) # 80001f3e <argstr>
    return -1;
    80004d3e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004d40:	0c054b63          	bltz	a0,80004e16 <sys_exec+0xfc>
    80004d44:	e3840593          	addi	a1,s0,-456
    80004d48:	4505                	li	a0,1
    80004d4a:	ffffd097          	auipc	ra,0xffffd
    80004d4e:	1d2080e7          	jalr	466(ra) # 80001f1c <argaddr>
    80004d52:	0c054263          	bltz	a0,80004e16 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004d56:	10000613          	li	a2,256
    80004d5a:	4581                	li	a1,0
    80004d5c:	e4040513          	addi	a0,s0,-448
    80004d60:	ffffb097          	auipc	ra,0xffffb
    80004d64:	41a080e7          	jalr	1050(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004d68:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004d6c:	89a6                	mv	s3,s1
    80004d6e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004d70:	02000a13          	li	s4,32
    80004d74:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004d78:	00391513          	slli	a0,s2,0x3
    80004d7c:	e3040593          	addi	a1,s0,-464
    80004d80:	e3843783          	ld	a5,-456(s0)
    80004d84:	953e                	add	a0,a0,a5
    80004d86:	ffffd097          	auipc	ra,0xffffd
    80004d8a:	0da080e7          	jalr	218(ra) # 80001e60 <fetchaddr>
    80004d8e:	02054a63          	bltz	a0,80004dc2 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004d92:	e3043783          	ld	a5,-464(s0)
    80004d96:	c3b9                	beqz	a5,80004ddc <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004d98:	ffffb097          	auipc	ra,0xffffb
    80004d9c:	382080e7          	jalr	898(ra) # 8000011a <kalloc>
    80004da0:	85aa                	mv	a1,a0
    80004da2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004da6:	cd11                	beqz	a0,80004dc2 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004da8:	6605                	lui	a2,0x1
    80004daa:	e3043503          	ld	a0,-464(s0)
    80004dae:	ffffd097          	auipc	ra,0xffffd
    80004db2:	104080e7          	jalr	260(ra) # 80001eb2 <fetchstr>
    80004db6:	00054663          	bltz	a0,80004dc2 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004dba:	0905                	addi	s2,s2,1
    80004dbc:	09a1                	addi	s3,s3,8
    80004dbe:	fb491be3          	bne	s2,s4,80004d74 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004dc2:	f4040913          	addi	s2,s0,-192
    80004dc6:	6088                	ld	a0,0(s1)
    80004dc8:	c531                	beqz	a0,80004e14 <sys_exec+0xfa>
    kfree(argv[i]);
    80004dca:	ffffb097          	auipc	ra,0xffffb
    80004dce:	252080e7          	jalr	594(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004dd2:	04a1                	addi	s1,s1,8
    80004dd4:	ff2499e3          	bne	s1,s2,80004dc6 <sys_exec+0xac>
  return -1;
    80004dd8:	597d                	li	s2,-1
    80004dda:	a835                	j	80004e16 <sys_exec+0xfc>
      argv[i] = 0;
    80004ddc:	0a8e                	slli	s5,s5,0x3
    80004dde:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    80004de2:	00878ab3          	add	s5,a5,s0
    80004de6:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004dea:	e4040593          	addi	a1,s0,-448
    80004dee:	f4040513          	addi	a0,s0,-192
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	172080e7          	jalr	370(ra) # 80003f64 <exec>
    80004dfa:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004dfc:	f4040993          	addi	s3,s0,-192
    80004e00:	6088                	ld	a0,0(s1)
    80004e02:	c911                	beqz	a0,80004e16 <sys_exec+0xfc>
    kfree(argv[i]);
    80004e04:	ffffb097          	auipc	ra,0xffffb
    80004e08:	218080e7          	jalr	536(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e0c:	04a1                	addi	s1,s1,8
    80004e0e:	ff3499e3          	bne	s1,s3,80004e00 <sys_exec+0xe6>
    80004e12:	a011                	j	80004e16 <sys_exec+0xfc>
  return -1;
    80004e14:	597d                	li	s2,-1
}
    80004e16:	854a                	mv	a0,s2
    80004e18:	60be                	ld	ra,456(sp)
    80004e1a:	641e                	ld	s0,448(sp)
    80004e1c:	74fa                	ld	s1,440(sp)
    80004e1e:	795a                	ld	s2,432(sp)
    80004e20:	79ba                	ld	s3,424(sp)
    80004e22:	7a1a                	ld	s4,416(sp)
    80004e24:	6afa                	ld	s5,408(sp)
    80004e26:	6179                	addi	sp,sp,464
    80004e28:	8082                	ret

0000000080004e2a <sys_pipe>:

uint64
sys_pipe(void)
{
    80004e2a:	7139                	addi	sp,sp,-64
    80004e2c:	fc06                	sd	ra,56(sp)
    80004e2e:	f822                	sd	s0,48(sp)
    80004e30:	f426                	sd	s1,40(sp)
    80004e32:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004e34:	ffffc097          	auipc	ra,0xffffc
    80004e38:	010080e7          	jalr	16(ra) # 80000e44 <myproc>
    80004e3c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004e3e:	fd840593          	addi	a1,s0,-40
    80004e42:	4501                	li	a0,0
    80004e44:	ffffd097          	auipc	ra,0xffffd
    80004e48:	0d8080e7          	jalr	216(ra) # 80001f1c <argaddr>
    return -1;
    80004e4c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004e4e:	0e054063          	bltz	a0,80004f2e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004e52:	fc840593          	addi	a1,s0,-56
    80004e56:	fd040513          	addi	a0,s0,-48
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	de6080e7          	jalr	-538(ra) # 80003c40 <pipealloc>
    return -1;
    80004e62:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004e64:	0c054563          	bltz	a0,80004f2e <sys_pipe+0x104>
  fd0 = -1;
    80004e68:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004e6c:	fd043503          	ld	a0,-48(s0)
    80004e70:	fffff097          	auipc	ra,0xfffff
    80004e74:	504080e7          	jalr	1284(ra) # 80004374 <fdalloc>
    80004e78:	fca42223          	sw	a0,-60(s0)
    80004e7c:	08054c63          	bltz	a0,80004f14 <sys_pipe+0xea>
    80004e80:	fc843503          	ld	a0,-56(s0)
    80004e84:	fffff097          	auipc	ra,0xfffff
    80004e88:	4f0080e7          	jalr	1264(ra) # 80004374 <fdalloc>
    80004e8c:	fca42023          	sw	a0,-64(s0)
    80004e90:	06054963          	bltz	a0,80004f02 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004e94:	4691                	li	a3,4
    80004e96:	fc440613          	addi	a2,s0,-60
    80004e9a:	fd843583          	ld	a1,-40(s0)
    80004e9e:	68a8                	ld	a0,80(s1)
    80004ea0:	ffffc097          	auipc	ra,0xffffc
    80004ea4:	c68080e7          	jalr	-920(ra) # 80000b08 <copyout>
    80004ea8:	02054063          	bltz	a0,80004ec8 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004eac:	4691                	li	a3,4
    80004eae:	fc040613          	addi	a2,s0,-64
    80004eb2:	fd843583          	ld	a1,-40(s0)
    80004eb6:	0591                	addi	a1,a1,4
    80004eb8:	68a8                	ld	a0,80(s1)
    80004eba:	ffffc097          	auipc	ra,0xffffc
    80004ebe:	c4e080e7          	jalr	-946(ra) # 80000b08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004ec2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ec4:	06055563          	bgez	a0,80004f2e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004ec8:	fc442783          	lw	a5,-60(s0)
    80004ecc:	07e9                	addi	a5,a5,26
    80004ece:	078e                	slli	a5,a5,0x3
    80004ed0:	97a6                	add	a5,a5,s1
    80004ed2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004ed6:	fc042783          	lw	a5,-64(s0)
    80004eda:	07e9                	addi	a5,a5,26
    80004edc:	078e                	slli	a5,a5,0x3
    80004ede:	00f48533          	add	a0,s1,a5
    80004ee2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004ee6:	fd043503          	ld	a0,-48(s0)
    80004eea:	fffff097          	auipc	ra,0xfffff
    80004eee:	a26080e7          	jalr	-1498(ra) # 80003910 <fileclose>
    fileclose(wf);
    80004ef2:	fc843503          	ld	a0,-56(s0)
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	a1a080e7          	jalr	-1510(ra) # 80003910 <fileclose>
    return -1;
    80004efe:	57fd                	li	a5,-1
    80004f00:	a03d                	j	80004f2e <sys_pipe+0x104>
    if(fd0 >= 0)
    80004f02:	fc442783          	lw	a5,-60(s0)
    80004f06:	0007c763          	bltz	a5,80004f14 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004f0a:	07e9                	addi	a5,a5,26
    80004f0c:	078e                	slli	a5,a5,0x3
    80004f0e:	97a6                	add	a5,a5,s1
    80004f10:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004f14:	fd043503          	ld	a0,-48(s0)
    80004f18:	fffff097          	auipc	ra,0xfffff
    80004f1c:	9f8080e7          	jalr	-1544(ra) # 80003910 <fileclose>
    fileclose(wf);
    80004f20:	fc843503          	ld	a0,-56(s0)
    80004f24:	fffff097          	auipc	ra,0xfffff
    80004f28:	9ec080e7          	jalr	-1556(ra) # 80003910 <fileclose>
    return -1;
    80004f2c:	57fd                	li	a5,-1
}
    80004f2e:	853e                	mv	a0,a5
    80004f30:	70e2                	ld	ra,56(sp)
    80004f32:	7442                	ld	s0,48(sp)
    80004f34:	74a2                	ld	s1,40(sp)
    80004f36:	6121                	addi	sp,sp,64
    80004f38:	8082                	ret
    80004f3a:	0000                	unimp
    80004f3c:	0000                	unimp
	...

0000000080004f40 <kernelvec>:
    80004f40:	7111                	addi	sp,sp,-256
    80004f42:	e006                	sd	ra,0(sp)
    80004f44:	e40a                	sd	sp,8(sp)
    80004f46:	e80e                	sd	gp,16(sp)
    80004f48:	ec12                	sd	tp,24(sp)
    80004f4a:	f016                	sd	t0,32(sp)
    80004f4c:	f41a                	sd	t1,40(sp)
    80004f4e:	f81e                	sd	t2,48(sp)
    80004f50:	fc22                	sd	s0,56(sp)
    80004f52:	e0a6                	sd	s1,64(sp)
    80004f54:	e4aa                	sd	a0,72(sp)
    80004f56:	e8ae                	sd	a1,80(sp)
    80004f58:	ecb2                	sd	a2,88(sp)
    80004f5a:	f0b6                	sd	a3,96(sp)
    80004f5c:	f4ba                	sd	a4,104(sp)
    80004f5e:	f8be                	sd	a5,112(sp)
    80004f60:	fcc2                	sd	a6,120(sp)
    80004f62:	e146                	sd	a7,128(sp)
    80004f64:	e54a                	sd	s2,136(sp)
    80004f66:	e94e                	sd	s3,144(sp)
    80004f68:	ed52                	sd	s4,152(sp)
    80004f6a:	f156                	sd	s5,160(sp)
    80004f6c:	f55a                	sd	s6,168(sp)
    80004f6e:	f95e                	sd	s7,176(sp)
    80004f70:	fd62                	sd	s8,184(sp)
    80004f72:	e1e6                	sd	s9,192(sp)
    80004f74:	e5ea                	sd	s10,200(sp)
    80004f76:	e9ee                	sd	s11,208(sp)
    80004f78:	edf2                	sd	t3,216(sp)
    80004f7a:	f1f6                	sd	t4,224(sp)
    80004f7c:	f5fa                	sd	t5,232(sp)
    80004f7e:	f9fe                	sd	t6,240(sp)
    80004f80:	dadfc0ef          	jal	ra,80001d2c <kerneltrap>
    80004f84:	6082                	ld	ra,0(sp)
    80004f86:	6122                	ld	sp,8(sp)
    80004f88:	61c2                	ld	gp,16(sp)
    80004f8a:	7282                	ld	t0,32(sp)
    80004f8c:	7322                	ld	t1,40(sp)
    80004f8e:	73c2                	ld	t2,48(sp)
    80004f90:	7462                	ld	s0,56(sp)
    80004f92:	6486                	ld	s1,64(sp)
    80004f94:	6526                	ld	a0,72(sp)
    80004f96:	65c6                	ld	a1,80(sp)
    80004f98:	6666                	ld	a2,88(sp)
    80004f9a:	7686                	ld	a3,96(sp)
    80004f9c:	7726                	ld	a4,104(sp)
    80004f9e:	77c6                	ld	a5,112(sp)
    80004fa0:	7866                	ld	a6,120(sp)
    80004fa2:	688a                	ld	a7,128(sp)
    80004fa4:	692a                	ld	s2,136(sp)
    80004fa6:	69ca                	ld	s3,144(sp)
    80004fa8:	6a6a                	ld	s4,152(sp)
    80004faa:	7a8a                	ld	s5,160(sp)
    80004fac:	7b2a                	ld	s6,168(sp)
    80004fae:	7bca                	ld	s7,176(sp)
    80004fb0:	7c6a                	ld	s8,184(sp)
    80004fb2:	6c8e                	ld	s9,192(sp)
    80004fb4:	6d2e                	ld	s10,200(sp)
    80004fb6:	6dce                	ld	s11,208(sp)
    80004fb8:	6e6e                	ld	t3,216(sp)
    80004fba:	7e8e                	ld	t4,224(sp)
    80004fbc:	7f2e                	ld	t5,232(sp)
    80004fbe:	7fce                	ld	t6,240(sp)
    80004fc0:	6111                	addi	sp,sp,256
    80004fc2:	10200073          	sret
    80004fc6:	00000013          	nop
    80004fca:	00000013          	nop
    80004fce:	0001                	nop

0000000080004fd0 <timervec>:
    80004fd0:	34051573          	csrrw	a0,mscratch,a0
    80004fd4:	e10c                	sd	a1,0(a0)
    80004fd6:	e510                	sd	a2,8(a0)
    80004fd8:	e914                	sd	a3,16(a0)
    80004fda:	6d0c                	ld	a1,24(a0)
    80004fdc:	7110                	ld	a2,32(a0)
    80004fde:	6194                	ld	a3,0(a1)
    80004fe0:	96b2                	add	a3,a3,a2
    80004fe2:	e194                	sd	a3,0(a1)
    80004fe4:	4589                	li	a1,2
    80004fe6:	14459073          	csrw	sip,a1
    80004fea:	6914                	ld	a3,16(a0)
    80004fec:	6510                	ld	a2,8(a0)
    80004fee:	610c                	ld	a1,0(a0)
    80004ff0:	34051573          	csrrw	a0,mscratch,a0
    80004ff4:	30200073          	mret
	...

0000000080004ffa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004ffa:	1141                	addi	sp,sp,-16
    80004ffc:	e422                	sd	s0,8(sp)
    80004ffe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005000:	0c0007b7          	lui	a5,0xc000
    80005004:	4705                	li	a4,1
    80005006:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005008:	c3d8                	sw	a4,4(a5)
}
    8000500a:	6422                	ld	s0,8(sp)
    8000500c:	0141                	addi	sp,sp,16
    8000500e:	8082                	ret

0000000080005010 <plicinithart>:

void
plicinithart(void)
{
    80005010:	1141                	addi	sp,sp,-16
    80005012:	e406                	sd	ra,8(sp)
    80005014:	e022                	sd	s0,0(sp)
    80005016:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005018:	ffffc097          	auipc	ra,0xffffc
    8000501c:	e00080e7          	jalr	-512(ra) # 80000e18 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005020:	0085171b          	slliw	a4,a0,0x8
    80005024:	0c0027b7          	lui	a5,0xc002
    80005028:	97ba                	add	a5,a5,a4
    8000502a:	40200713          	li	a4,1026
    8000502e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005032:	00d5151b          	slliw	a0,a0,0xd
    80005036:	0c2017b7          	lui	a5,0xc201
    8000503a:	97aa                	add	a5,a5,a0
    8000503c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005040:	60a2                	ld	ra,8(sp)
    80005042:	6402                	ld	s0,0(sp)
    80005044:	0141                	addi	sp,sp,16
    80005046:	8082                	ret

0000000080005048 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005048:	1141                	addi	sp,sp,-16
    8000504a:	e406                	sd	ra,8(sp)
    8000504c:	e022                	sd	s0,0(sp)
    8000504e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005050:	ffffc097          	auipc	ra,0xffffc
    80005054:	dc8080e7          	jalr	-568(ra) # 80000e18 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005058:	00d5151b          	slliw	a0,a0,0xd
    8000505c:	0c2017b7          	lui	a5,0xc201
    80005060:	97aa                	add	a5,a5,a0
  return irq;
}
    80005062:	43c8                	lw	a0,4(a5)
    80005064:	60a2                	ld	ra,8(sp)
    80005066:	6402                	ld	s0,0(sp)
    80005068:	0141                	addi	sp,sp,16
    8000506a:	8082                	ret

000000008000506c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000506c:	1101                	addi	sp,sp,-32
    8000506e:	ec06                	sd	ra,24(sp)
    80005070:	e822                	sd	s0,16(sp)
    80005072:	e426                	sd	s1,8(sp)
    80005074:	1000                	addi	s0,sp,32
    80005076:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005078:	ffffc097          	auipc	ra,0xffffc
    8000507c:	da0080e7          	jalr	-608(ra) # 80000e18 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005080:	00d5151b          	slliw	a0,a0,0xd
    80005084:	0c2017b7          	lui	a5,0xc201
    80005088:	97aa                	add	a5,a5,a0
    8000508a:	c3c4                	sw	s1,4(a5)
}
    8000508c:	60e2                	ld	ra,24(sp)
    8000508e:	6442                	ld	s0,16(sp)
    80005090:	64a2                	ld	s1,8(sp)
    80005092:	6105                	addi	sp,sp,32
    80005094:	8082                	ret

0000000080005096 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005096:	1141                	addi	sp,sp,-16
    80005098:	e406                	sd	ra,8(sp)
    8000509a:	e022                	sd	s0,0(sp)
    8000509c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000509e:	479d                	li	a5,7
    800050a0:	06a7c863          	blt	a5,a0,80005110 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800050a4:	00016717          	auipc	a4,0x16
    800050a8:	f5c70713          	addi	a4,a4,-164 # 8001b000 <disk>
    800050ac:	972a                	add	a4,a4,a0
    800050ae:	6789                	lui	a5,0x2
    800050b0:	97ba                	add	a5,a5,a4
    800050b2:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800050b6:	e7ad                	bnez	a5,80005120 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800050b8:	00451793          	slli	a5,a0,0x4
    800050bc:	00018717          	auipc	a4,0x18
    800050c0:	f4470713          	addi	a4,a4,-188 # 8001d000 <disk+0x2000>
    800050c4:	6314                	ld	a3,0(a4)
    800050c6:	96be                	add	a3,a3,a5
    800050c8:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800050cc:	6314                	ld	a3,0(a4)
    800050ce:	96be                	add	a3,a3,a5
    800050d0:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800050d4:	6314                	ld	a3,0(a4)
    800050d6:	96be                	add	a3,a3,a5
    800050d8:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800050dc:	6318                	ld	a4,0(a4)
    800050de:	97ba                	add	a5,a5,a4
    800050e0:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800050e4:	00016717          	auipc	a4,0x16
    800050e8:	f1c70713          	addi	a4,a4,-228 # 8001b000 <disk>
    800050ec:	972a                	add	a4,a4,a0
    800050ee:	6789                	lui	a5,0x2
    800050f0:	97ba                	add	a5,a5,a4
    800050f2:	4705                	li	a4,1
    800050f4:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800050f8:	00018517          	auipc	a0,0x18
    800050fc:	f2050513          	addi	a0,a0,-224 # 8001d018 <disk+0x2018>
    80005100:	ffffc097          	auipc	ra,0xffffc
    80005104:	594080e7          	jalr	1428(ra) # 80001694 <wakeup>
}
    80005108:	60a2                	ld	ra,8(sp)
    8000510a:	6402                	ld	s0,0(sp)
    8000510c:	0141                	addi	sp,sp,16
    8000510e:	8082                	ret
    panic("free_desc 1");
    80005110:	00003517          	auipc	a0,0x3
    80005114:	5d850513          	addi	a0,a0,1496 # 800086e8 <syscalls+0x320>
    80005118:	00001097          	auipc	ra,0x1
    8000511c:	9c8080e7          	jalr	-1592(ra) # 80005ae0 <panic>
    panic("free_desc 2");
    80005120:	00003517          	auipc	a0,0x3
    80005124:	5d850513          	addi	a0,a0,1496 # 800086f8 <syscalls+0x330>
    80005128:	00001097          	auipc	ra,0x1
    8000512c:	9b8080e7          	jalr	-1608(ra) # 80005ae0 <panic>

0000000080005130 <virtio_disk_init>:
{
    80005130:	1101                	addi	sp,sp,-32
    80005132:	ec06                	sd	ra,24(sp)
    80005134:	e822                	sd	s0,16(sp)
    80005136:	e426                	sd	s1,8(sp)
    80005138:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000513a:	00003597          	auipc	a1,0x3
    8000513e:	5ce58593          	addi	a1,a1,1486 # 80008708 <syscalls+0x340>
    80005142:	00018517          	auipc	a0,0x18
    80005146:	fe650513          	addi	a0,a0,-26 # 8001d128 <disk+0x2128>
    8000514a:	00001097          	auipc	ra,0x1
    8000514e:	e3e080e7          	jalr	-450(ra) # 80005f88 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005152:	100017b7          	lui	a5,0x10001
    80005156:	4398                	lw	a4,0(a5)
    80005158:	2701                	sext.w	a4,a4
    8000515a:	747277b7          	lui	a5,0x74727
    8000515e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005162:	0ef71063          	bne	a4,a5,80005242 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005166:	100017b7          	lui	a5,0x10001
    8000516a:	43dc                	lw	a5,4(a5)
    8000516c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000516e:	4705                	li	a4,1
    80005170:	0ce79963          	bne	a5,a4,80005242 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005174:	100017b7          	lui	a5,0x10001
    80005178:	479c                	lw	a5,8(a5)
    8000517a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000517c:	4709                	li	a4,2
    8000517e:	0ce79263          	bne	a5,a4,80005242 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005182:	100017b7          	lui	a5,0x10001
    80005186:	47d8                	lw	a4,12(a5)
    80005188:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000518a:	554d47b7          	lui	a5,0x554d4
    8000518e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005192:	0af71863          	bne	a4,a5,80005242 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005196:	100017b7          	lui	a5,0x10001
    8000519a:	4705                	li	a4,1
    8000519c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000519e:	470d                	li	a4,3
    800051a0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800051a2:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800051a4:	c7ffe6b7          	lui	a3,0xc7ffe
    800051a8:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800051ac:	8f75                	and	a4,a4,a3
    800051ae:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051b0:	472d                	li	a4,11
    800051b2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051b4:	473d                	li	a4,15
    800051b6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800051b8:	6705                	lui	a4,0x1
    800051ba:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800051bc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800051c0:	5bdc                	lw	a5,52(a5)
    800051c2:	2781                	sext.w	a5,a5
  if(max == 0)
    800051c4:	c7d9                	beqz	a5,80005252 <virtio_disk_init+0x122>
  if(max < NUM)
    800051c6:	471d                	li	a4,7
    800051c8:	08f77d63          	bgeu	a4,a5,80005262 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800051cc:	100014b7          	lui	s1,0x10001
    800051d0:	47a1                	li	a5,8
    800051d2:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800051d4:	6609                	lui	a2,0x2
    800051d6:	4581                	li	a1,0
    800051d8:	00016517          	auipc	a0,0x16
    800051dc:	e2850513          	addi	a0,a0,-472 # 8001b000 <disk>
    800051e0:	ffffb097          	auipc	ra,0xffffb
    800051e4:	f9a080e7          	jalr	-102(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800051e8:	00016717          	auipc	a4,0x16
    800051ec:	e1870713          	addi	a4,a4,-488 # 8001b000 <disk>
    800051f0:	00c75793          	srli	a5,a4,0xc
    800051f4:	2781                	sext.w	a5,a5
    800051f6:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800051f8:	00018797          	auipc	a5,0x18
    800051fc:	e0878793          	addi	a5,a5,-504 # 8001d000 <disk+0x2000>
    80005200:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005202:	00016717          	auipc	a4,0x16
    80005206:	e7e70713          	addi	a4,a4,-386 # 8001b080 <disk+0x80>
    8000520a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000520c:	00017717          	auipc	a4,0x17
    80005210:	df470713          	addi	a4,a4,-524 # 8001c000 <disk+0x1000>
    80005214:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005216:	4705                	li	a4,1
    80005218:	00e78c23          	sb	a4,24(a5)
    8000521c:	00e78ca3          	sb	a4,25(a5)
    80005220:	00e78d23          	sb	a4,26(a5)
    80005224:	00e78da3          	sb	a4,27(a5)
    80005228:	00e78e23          	sb	a4,28(a5)
    8000522c:	00e78ea3          	sb	a4,29(a5)
    80005230:	00e78f23          	sb	a4,30(a5)
    80005234:	00e78fa3          	sb	a4,31(a5)
}
    80005238:	60e2                	ld	ra,24(sp)
    8000523a:	6442                	ld	s0,16(sp)
    8000523c:	64a2                	ld	s1,8(sp)
    8000523e:	6105                	addi	sp,sp,32
    80005240:	8082                	ret
    panic("could not find virtio disk");
    80005242:	00003517          	auipc	a0,0x3
    80005246:	4d650513          	addi	a0,a0,1238 # 80008718 <syscalls+0x350>
    8000524a:	00001097          	auipc	ra,0x1
    8000524e:	896080e7          	jalr	-1898(ra) # 80005ae0 <panic>
    panic("virtio disk has no queue 0");
    80005252:	00003517          	auipc	a0,0x3
    80005256:	4e650513          	addi	a0,a0,1254 # 80008738 <syscalls+0x370>
    8000525a:	00001097          	auipc	ra,0x1
    8000525e:	886080e7          	jalr	-1914(ra) # 80005ae0 <panic>
    panic("virtio disk max queue too short");
    80005262:	00003517          	auipc	a0,0x3
    80005266:	4f650513          	addi	a0,a0,1270 # 80008758 <syscalls+0x390>
    8000526a:	00001097          	auipc	ra,0x1
    8000526e:	876080e7          	jalr	-1930(ra) # 80005ae0 <panic>

0000000080005272 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005272:	7119                	addi	sp,sp,-128
    80005274:	fc86                	sd	ra,120(sp)
    80005276:	f8a2                	sd	s0,112(sp)
    80005278:	f4a6                	sd	s1,104(sp)
    8000527a:	f0ca                	sd	s2,96(sp)
    8000527c:	ecce                	sd	s3,88(sp)
    8000527e:	e8d2                	sd	s4,80(sp)
    80005280:	e4d6                	sd	s5,72(sp)
    80005282:	e0da                	sd	s6,64(sp)
    80005284:	fc5e                	sd	s7,56(sp)
    80005286:	f862                	sd	s8,48(sp)
    80005288:	f466                	sd	s9,40(sp)
    8000528a:	f06a                	sd	s10,32(sp)
    8000528c:	ec6e                	sd	s11,24(sp)
    8000528e:	0100                	addi	s0,sp,128
    80005290:	8aaa                	mv	s5,a0
    80005292:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005294:	00c52c83          	lw	s9,12(a0)
    80005298:	001c9c9b          	slliw	s9,s9,0x1
    8000529c:	1c82                	slli	s9,s9,0x20
    8000529e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800052a2:	00018517          	auipc	a0,0x18
    800052a6:	e8650513          	addi	a0,a0,-378 # 8001d128 <disk+0x2128>
    800052aa:	00001097          	auipc	ra,0x1
    800052ae:	d6e080e7          	jalr	-658(ra) # 80006018 <acquire>
  for(int i = 0; i < 3; i++){
    800052b2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800052b4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800052b6:	00016c17          	auipc	s8,0x16
    800052ba:	d4ac0c13          	addi	s8,s8,-694 # 8001b000 <disk>
    800052be:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800052c0:	4b0d                	li	s6,3
    800052c2:	a0ad                	j	8000532c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800052c4:	00fc0733          	add	a4,s8,a5
    800052c8:	975e                	add	a4,a4,s7
    800052ca:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800052ce:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800052d0:	0207c563          	bltz	a5,800052fa <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800052d4:	2905                	addiw	s2,s2,1
    800052d6:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800052d8:	19690c63          	beq	s2,s6,80005470 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    800052dc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800052de:	00018717          	auipc	a4,0x18
    800052e2:	d3a70713          	addi	a4,a4,-710 # 8001d018 <disk+0x2018>
    800052e6:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800052e8:	00074683          	lbu	a3,0(a4)
    800052ec:	fee1                	bnez	a3,800052c4 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800052ee:	2785                	addiw	a5,a5,1
    800052f0:	0705                	addi	a4,a4,1
    800052f2:	fe979be3          	bne	a5,s1,800052e8 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800052f6:	57fd                	li	a5,-1
    800052f8:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800052fa:	01205d63          	blez	s2,80005314 <virtio_disk_rw+0xa2>
    800052fe:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005300:	000a2503          	lw	a0,0(s4)
    80005304:	00000097          	auipc	ra,0x0
    80005308:	d92080e7          	jalr	-622(ra) # 80005096 <free_desc>
      for(int j = 0; j < i; j++)
    8000530c:	2d85                	addiw	s11,s11,1
    8000530e:	0a11                	addi	s4,s4,4
    80005310:	ff2d98e3          	bne	s11,s2,80005300 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005314:	00018597          	auipc	a1,0x18
    80005318:	e1458593          	addi	a1,a1,-492 # 8001d128 <disk+0x2128>
    8000531c:	00018517          	auipc	a0,0x18
    80005320:	cfc50513          	addi	a0,a0,-772 # 8001d018 <disk+0x2018>
    80005324:	ffffc097          	auipc	ra,0xffffc
    80005328:	1e4080e7          	jalr	484(ra) # 80001508 <sleep>
  for(int i = 0; i < 3; i++){
    8000532c:	f8040a13          	addi	s4,s0,-128
{
    80005330:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005332:	894e                	mv	s2,s3
    80005334:	b765                	j	800052dc <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005336:	00018697          	auipc	a3,0x18
    8000533a:	cca6b683          	ld	a3,-822(a3) # 8001d000 <disk+0x2000>
    8000533e:	96ba                	add	a3,a3,a4
    80005340:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005344:	00016817          	auipc	a6,0x16
    80005348:	cbc80813          	addi	a6,a6,-836 # 8001b000 <disk>
    8000534c:	00018697          	auipc	a3,0x18
    80005350:	cb468693          	addi	a3,a3,-844 # 8001d000 <disk+0x2000>
    80005354:	6290                	ld	a2,0(a3)
    80005356:	963a                	add	a2,a2,a4
    80005358:	00c65583          	lhu	a1,12(a2)
    8000535c:	0015e593          	ori	a1,a1,1
    80005360:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005364:	f8842603          	lw	a2,-120(s0)
    80005368:	628c                	ld	a1,0(a3)
    8000536a:	972e                	add	a4,a4,a1
    8000536c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005370:	20050593          	addi	a1,a0,512
    80005374:	0592                	slli	a1,a1,0x4
    80005376:	95c2                	add	a1,a1,a6
    80005378:	577d                	li	a4,-1
    8000537a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000537e:	00461713          	slli	a4,a2,0x4
    80005382:	6290                	ld	a2,0(a3)
    80005384:	963a                	add	a2,a2,a4
    80005386:	03078793          	addi	a5,a5,48
    8000538a:	97c2                	add	a5,a5,a6
    8000538c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000538e:	629c                	ld	a5,0(a3)
    80005390:	97ba                	add	a5,a5,a4
    80005392:	4605                	li	a2,1
    80005394:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005396:	629c                	ld	a5,0(a3)
    80005398:	97ba                	add	a5,a5,a4
    8000539a:	4809                	li	a6,2
    8000539c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800053a0:	629c                	ld	a5,0(a3)
    800053a2:	97ba                	add	a5,a5,a4
    800053a4:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800053a8:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800053ac:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800053b0:	6698                	ld	a4,8(a3)
    800053b2:	00275783          	lhu	a5,2(a4)
    800053b6:	8b9d                	andi	a5,a5,7
    800053b8:	0786                	slli	a5,a5,0x1
    800053ba:	973e                	add	a4,a4,a5
    800053bc:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    800053c0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800053c4:	6698                	ld	a4,8(a3)
    800053c6:	00275783          	lhu	a5,2(a4)
    800053ca:	2785                	addiw	a5,a5,1
    800053cc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800053d0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800053d4:	100017b7          	lui	a5,0x10001
    800053d8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800053dc:	004aa783          	lw	a5,4(s5)
    800053e0:	02c79163          	bne	a5,a2,80005402 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800053e4:	00018917          	auipc	s2,0x18
    800053e8:	d4490913          	addi	s2,s2,-700 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800053ec:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800053ee:	85ca                	mv	a1,s2
    800053f0:	8556                	mv	a0,s5
    800053f2:	ffffc097          	auipc	ra,0xffffc
    800053f6:	116080e7          	jalr	278(ra) # 80001508 <sleep>
  while(b->disk == 1) {
    800053fa:	004aa783          	lw	a5,4(s5)
    800053fe:	fe9788e3          	beq	a5,s1,800053ee <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005402:	f8042903          	lw	s2,-128(s0)
    80005406:	20090713          	addi	a4,s2,512
    8000540a:	0712                	slli	a4,a4,0x4
    8000540c:	00016797          	auipc	a5,0x16
    80005410:	bf478793          	addi	a5,a5,-1036 # 8001b000 <disk>
    80005414:	97ba                	add	a5,a5,a4
    80005416:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000541a:	00018997          	auipc	s3,0x18
    8000541e:	be698993          	addi	s3,s3,-1050 # 8001d000 <disk+0x2000>
    80005422:	00491713          	slli	a4,s2,0x4
    80005426:	0009b783          	ld	a5,0(s3)
    8000542a:	97ba                	add	a5,a5,a4
    8000542c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005430:	854a                	mv	a0,s2
    80005432:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005436:	00000097          	auipc	ra,0x0
    8000543a:	c60080e7          	jalr	-928(ra) # 80005096 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000543e:	8885                	andi	s1,s1,1
    80005440:	f0ed                	bnez	s1,80005422 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005442:	00018517          	auipc	a0,0x18
    80005446:	ce650513          	addi	a0,a0,-794 # 8001d128 <disk+0x2128>
    8000544a:	00001097          	auipc	ra,0x1
    8000544e:	c82080e7          	jalr	-894(ra) # 800060cc <release>
}
    80005452:	70e6                	ld	ra,120(sp)
    80005454:	7446                	ld	s0,112(sp)
    80005456:	74a6                	ld	s1,104(sp)
    80005458:	7906                	ld	s2,96(sp)
    8000545a:	69e6                	ld	s3,88(sp)
    8000545c:	6a46                	ld	s4,80(sp)
    8000545e:	6aa6                	ld	s5,72(sp)
    80005460:	6b06                	ld	s6,64(sp)
    80005462:	7be2                	ld	s7,56(sp)
    80005464:	7c42                	ld	s8,48(sp)
    80005466:	7ca2                	ld	s9,40(sp)
    80005468:	7d02                	ld	s10,32(sp)
    8000546a:	6de2                	ld	s11,24(sp)
    8000546c:	6109                	addi	sp,sp,128
    8000546e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005470:	f8042503          	lw	a0,-128(s0)
    80005474:	20050793          	addi	a5,a0,512
    80005478:	0792                	slli	a5,a5,0x4
  if(write)
    8000547a:	00016817          	auipc	a6,0x16
    8000547e:	b8680813          	addi	a6,a6,-1146 # 8001b000 <disk>
    80005482:	00f80733          	add	a4,a6,a5
    80005486:	01a036b3          	snez	a3,s10
    8000548a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000548e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005492:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005496:	7679                	lui	a2,0xffffe
    80005498:	963e                	add	a2,a2,a5
    8000549a:	00018697          	auipc	a3,0x18
    8000549e:	b6668693          	addi	a3,a3,-1178 # 8001d000 <disk+0x2000>
    800054a2:	6298                	ld	a4,0(a3)
    800054a4:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054a6:	0a878593          	addi	a1,a5,168
    800054aa:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800054ac:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054ae:	6298                	ld	a4,0(a3)
    800054b0:	9732                	add	a4,a4,a2
    800054b2:	45c1                	li	a1,16
    800054b4:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054b6:	6298                	ld	a4,0(a3)
    800054b8:	9732                	add	a4,a4,a2
    800054ba:	4585                	li	a1,1
    800054bc:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800054c0:	f8442703          	lw	a4,-124(s0)
    800054c4:	628c                	ld	a1,0(a3)
    800054c6:	962e                	add	a2,a2,a1
    800054c8:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800054cc:	0712                	slli	a4,a4,0x4
    800054ce:	6290                	ld	a2,0(a3)
    800054d0:	963a                	add	a2,a2,a4
    800054d2:	058a8593          	addi	a1,s5,88
    800054d6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800054d8:	6294                	ld	a3,0(a3)
    800054da:	96ba                	add	a3,a3,a4
    800054dc:	40000613          	li	a2,1024
    800054e0:	c690                	sw	a2,8(a3)
  if(write)
    800054e2:	e40d1ae3          	bnez	s10,80005336 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800054e6:	00018697          	auipc	a3,0x18
    800054ea:	b1a6b683          	ld	a3,-1254(a3) # 8001d000 <disk+0x2000>
    800054ee:	96ba                	add	a3,a3,a4
    800054f0:	4609                	li	a2,2
    800054f2:	00c69623          	sh	a2,12(a3)
    800054f6:	b5b9                	j	80005344 <virtio_disk_rw+0xd2>

00000000800054f8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800054f8:	1101                	addi	sp,sp,-32
    800054fa:	ec06                	sd	ra,24(sp)
    800054fc:	e822                	sd	s0,16(sp)
    800054fe:	e426                	sd	s1,8(sp)
    80005500:	e04a                	sd	s2,0(sp)
    80005502:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005504:	00018517          	auipc	a0,0x18
    80005508:	c2450513          	addi	a0,a0,-988 # 8001d128 <disk+0x2128>
    8000550c:	00001097          	auipc	ra,0x1
    80005510:	b0c080e7          	jalr	-1268(ra) # 80006018 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005514:	10001737          	lui	a4,0x10001
    80005518:	533c                	lw	a5,96(a4)
    8000551a:	8b8d                	andi	a5,a5,3
    8000551c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000551e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005522:	00018797          	auipc	a5,0x18
    80005526:	ade78793          	addi	a5,a5,-1314 # 8001d000 <disk+0x2000>
    8000552a:	6b94                	ld	a3,16(a5)
    8000552c:	0207d703          	lhu	a4,32(a5)
    80005530:	0026d783          	lhu	a5,2(a3)
    80005534:	06f70163          	beq	a4,a5,80005596 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005538:	00016917          	auipc	s2,0x16
    8000553c:	ac890913          	addi	s2,s2,-1336 # 8001b000 <disk>
    80005540:	00018497          	auipc	s1,0x18
    80005544:	ac048493          	addi	s1,s1,-1344 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005548:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000554c:	6898                	ld	a4,16(s1)
    8000554e:	0204d783          	lhu	a5,32(s1)
    80005552:	8b9d                	andi	a5,a5,7
    80005554:	078e                	slli	a5,a5,0x3
    80005556:	97ba                	add	a5,a5,a4
    80005558:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000555a:	20078713          	addi	a4,a5,512
    8000555e:	0712                	slli	a4,a4,0x4
    80005560:	974a                	add	a4,a4,s2
    80005562:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005566:	e731                	bnez	a4,800055b2 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005568:	20078793          	addi	a5,a5,512
    8000556c:	0792                	slli	a5,a5,0x4
    8000556e:	97ca                	add	a5,a5,s2
    80005570:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005572:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005576:	ffffc097          	auipc	ra,0xffffc
    8000557a:	11e080e7          	jalr	286(ra) # 80001694 <wakeup>

    disk.used_idx += 1;
    8000557e:	0204d783          	lhu	a5,32(s1)
    80005582:	2785                	addiw	a5,a5,1
    80005584:	17c2                	slli	a5,a5,0x30
    80005586:	93c1                	srli	a5,a5,0x30
    80005588:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000558c:	6898                	ld	a4,16(s1)
    8000558e:	00275703          	lhu	a4,2(a4)
    80005592:	faf71be3          	bne	a4,a5,80005548 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005596:	00018517          	auipc	a0,0x18
    8000559a:	b9250513          	addi	a0,a0,-1134 # 8001d128 <disk+0x2128>
    8000559e:	00001097          	auipc	ra,0x1
    800055a2:	b2e080e7          	jalr	-1234(ra) # 800060cc <release>
}
    800055a6:	60e2                	ld	ra,24(sp)
    800055a8:	6442                	ld	s0,16(sp)
    800055aa:	64a2                	ld	s1,8(sp)
    800055ac:	6902                	ld	s2,0(sp)
    800055ae:	6105                	addi	sp,sp,32
    800055b0:	8082                	ret
      panic("virtio_disk_intr status");
    800055b2:	00003517          	auipc	a0,0x3
    800055b6:	1c650513          	addi	a0,a0,454 # 80008778 <syscalls+0x3b0>
    800055ba:	00000097          	auipc	ra,0x0
    800055be:	526080e7          	jalr	1318(ra) # 80005ae0 <panic>

00000000800055c2 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800055c2:	1141                	addi	sp,sp,-16
    800055c4:	e422                	sd	s0,8(sp)
    800055c6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800055c8:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800055cc:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800055d0:	0037979b          	slliw	a5,a5,0x3
    800055d4:	02004737          	lui	a4,0x2004
    800055d8:	97ba                	add	a5,a5,a4
    800055da:	0200c737          	lui	a4,0x200c
    800055de:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800055e2:	000f4637          	lui	a2,0xf4
    800055e6:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800055ea:	9732                	add	a4,a4,a2
    800055ec:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800055ee:	00259693          	slli	a3,a1,0x2
    800055f2:	96ae                	add	a3,a3,a1
    800055f4:	068e                	slli	a3,a3,0x3
    800055f6:	00019717          	auipc	a4,0x19
    800055fa:	a0a70713          	addi	a4,a4,-1526 # 8001e000 <timer_scratch>
    800055fe:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005600:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005602:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005604:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005608:	00000797          	auipc	a5,0x0
    8000560c:	9c878793          	addi	a5,a5,-1592 # 80004fd0 <timervec>
    80005610:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005614:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005618:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000561c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005620:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005624:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005628:	30479073          	csrw	mie,a5
}
    8000562c:	6422                	ld	s0,8(sp)
    8000562e:	0141                	addi	sp,sp,16
    80005630:	8082                	ret

0000000080005632 <start>:
{
    80005632:	1141                	addi	sp,sp,-16
    80005634:	e406                	sd	ra,8(sp)
    80005636:	e022                	sd	s0,0(sp)
    80005638:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000563a:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000563e:	7779                	lui	a4,0xffffe
    80005640:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005644:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005646:	6705                	lui	a4,0x1
    80005648:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000564c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000564e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005652:	ffffb797          	auipc	a5,0xffffb
    80005656:	cce78793          	addi	a5,a5,-818 # 80000320 <main>
    8000565a:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000565e:	4781                	li	a5,0
    80005660:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005664:	67c1                	lui	a5,0x10
    80005666:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005668:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000566c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005670:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005674:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005678:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000567c:	57fd                	li	a5,-1
    8000567e:	83a9                	srli	a5,a5,0xa
    80005680:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005684:	47bd                	li	a5,15
    80005686:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000568a:	00000097          	auipc	ra,0x0
    8000568e:	f38080e7          	jalr	-200(ra) # 800055c2 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005692:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005696:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005698:	823e                	mv	tp,a5
  asm volatile("mret");
    8000569a:	30200073          	mret
}
    8000569e:	60a2                	ld	ra,8(sp)
    800056a0:	6402                	ld	s0,0(sp)
    800056a2:	0141                	addi	sp,sp,16
    800056a4:	8082                	ret

00000000800056a6 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800056a6:	715d                	addi	sp,sp,-80
    800056a8:	e486                	sd	ra,72(sp)
    800056aa:	e0a2                	sd	s0,64(sp)
    800056ac:	fc26                	sd	s1,56(sp)
    800056ae:	f84a                	sd	s2,48(sp)
    800056b0:	f44e                	sd	s3,40(sp)
    800056b2:	f052                	sd	s4,32(sp)
    800056b4:	ec56                	sd	s5,24(sp)
    800056b6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800056b8:	04c05763          	blez	a2,80005706 <consolewrite+0x60>
    800056bc:	8a2a                	mv	s4,a0
    800056be:	84ae                	mv	s1,a1
    800056c0:	89b2                	mv	s3,a2
    800056c2:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800056c4:	5afd                	li	s5,-1
    800056c6:	4685                	li	a3,1
    800056c8:	8626                	mv	a2,s1
    800056ca:	85d2                	mv	a1,s4
    800056cc:	fbf40513          	addi	a0,s0,-65
    800056d0:	ffffc097          	auipc	ra,0xffffc
    800056d4:	232080e7          	jalr	562(ra) # 80001902 <either_copyin>
    800056d8:	01550d63          	beq	a0,s5,800056f2 <consolewrite+0x4c>
      break;
    uartputc(c);
    800056dc:	fbf44503          	lbu	a0,-65(s0)
    800056e0:	00000097          	auipc	ra,0x0
    800056e4:	77e080e7          	jalr	1918(ra) # 80005e5e <uartputc>
  for(i = 0; i < n; i++){
    800056e8:	2905                	addiw	s2,s2,1
    800056ea:	0485                	addi	s1,s1,1
    800056ec:	fd299de3          	bne	s3,s2,800056c6 <consolewrite+0x20>
    800056f0:	894e                	mv	s2,s3
  }

  return i;
}
    800056f2:	854a                	mv	a0,s2
    800056f4:	60a6                	ld	ra,72(sp)
    800056f6:	6406                	ld	s0,64(sp)
    800056f8:	74e2                	ld	s1,56(sp)
    800056fa:	7942                	ld	s2,48(sp)
    800056fc:	79a2                	ld	s3,40(sp)
    800056fe:	7a02                	ld	s4,32(sp)
    80005700:	6ae2                	ld	s5,24(sp)
    80005702:	6161                	addi	sp,sp,80
    80005704:	8082                	ret
  for(i = 0; i < n; i++){
    80005706:	4901                	li	s2,0
    80005708:	b7ed                	j	800056f2 <consolewrite+0x4c>

000000008000570a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000570a:	7159                	addi	sp,sp,-112
    8000570c:	f486                	sd	ra,104(sp)
    8000570e:	f0a2                	sd	s0,96(sp)
    80005710:	eca6                	sd	s1,88(sp)
    80005712:	e8ca                	sd	s2,80(sp)
    80005714:	e4ce                	sd	s3,72(sp)
    80005716:	e0d2                	sd	s4,64(sp)
    80005718:	fc56                	sd	s5,56(sp)
    8000571a:	f85a                	sd	s6,48(sp)
    8000571c:	f45e                	sd	s7,40(sp)
    8000571e:	f062                	sd	s8,32(sp)
    80005720:	ec66                	sd	s9,24(sp)
    80005722:	e86a                	sd	s10,16(sp)
    80005724:	1880                	addi	s0,sp,112
    80005726:	8aaa                	mv	s5,a0
    80005728:	8a2e                	mv	s4,a1
    8000572a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000572c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005730:	00021517          	auipc	a0,0x21
    80005734:	a1050513          	addi	a0,a0,-1520 # 80026140 <cons>
    80005738:	00001097          	auipc	ra,0x1
    8000573c:	8e0080e7          	jalr	-1824(ra) # 80006018 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005740:	00021497          	auipc	s1,0x21
    80005744:	a0048493          	addi	s1,s1,-1536 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005748:	00021917          	auipc	s2,0x21
    8000574c:	a9090913          	addi	s2,s2,-1392 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005750:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005752:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005754:	4ca9                	li	s9,10
  while(n > 0){
    80005756:	07305863          	blez	s3,800057c6 <consoleread+0xbc>
    while(cons.r == cons.w){
    8000575a:	0984a783          	lw	a5,152(s1)
    8000575e:	09c4a703          	lw	a4,156(s1)
    80005762:	02f71463          	bne	a4,a5,8000578a <consoleread+0x80>
      if(myproc()->killed){
    80005766:	ffffb097          	auipc	ra,0xffffb
    8000576a:	6de080e7          	jalr	1758(ra) # 80000e44 <myproc>
    8000576e:	551c                	lw	a5,40(a0)
    80005770:	e7b5                	bnez	a5,800057dc <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005772:	85a6                	mv	a1,s1
    80005774:	854a                	mv	a0,s2
    80005776:	ffffc097          	auipc	ra,0xffffc
    8000577a:	d92080e7          	jalr	-622(ra) # 80001508 <sleep>
    while(cons.r == cons.w){
    8000577e:	0984a783          	lw	a5,152(s1)
    80005782:	09c4a703          	lw	a4,156(s1)
    80005786:	fef700e3          	beq	a4,a5,80005766 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    8000578a:	0017871b          	addiw	a4,a5,1
    8000578e:	08e4ac23          	sw	a4,152(s1)
    80005792:	07f7f713          	andi	a4,a5,127
    80005796:	9726                	add	a4,a4,s1
    80005798:	01874703          	lbu	a4,24(a4)
    8000579c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800057a0:	077d0563          	beq	s10,s7,8000580a <consoleread+0x100>
    cbuf = c;
    800057a4:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800057a8:	4685                	li	a3,1
    800057aa:	f9f40613          	addi	a2,s0,-97
    800057ae:	85d2                	mv	a1,s4
    800057b0:	8556                	mv	a0,s5
    800057b2:	ffffc097          	auipc	ra,0xffffc
    800057b6:	0fa080e7          	jalr	250(ra) # 800018ac <either_copyout>
    800057ba:	01850663          	beq	a0,s8,800057c6 <consoleread+0xbc>
    dst++;
    800057be:	0a05                	addi	s4,s4,1
    --n;
    800057c0:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800057c2:	f99d1ae3          	bne	s10,s9,80005756 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800057c6:	00021517          	auipc	a0,0x21
    800057ca:	97a50513          	addi	a0,a0,-1670 # 80026140 <cons>
    800057ce:	00001097          	auipc	ra,0x1
    800057d2:	8fe080e7          	jalr	-1794(ra) # 800060cc <release>

  return target - n;
    800057d6:	413b053b          	subw	a0,s6,s3
    800057da:	a811                	j	800057ee <consoleread+0xe4>
        release(&cons.lock);
    800057dc:	00021517          	auipc	a0,0x21
    800057e0:	96450513          	addi	a0,a0,-1692 # 80026140 <cons>
    800057e4:	00001097          	auipc	ra,0x1
    800057e8:	8e8080e7          	jalr	-1816(ra) # 800060cc <release>
        return -1;
    800057ec:	557d                	li	a0,-1
}
    800057ee:	70a6                	ld	ra,104(sp)
    800057f0:	7406                	ld	s0,96(sp)
    800057f2:	64e6                	ld	s1,88(sp)
    800057f4:	6946                	ld	s2,80(sp)
    800057f6:	69a6                	ld	s3,72(sp)
    800057f8:	6a06                	ld	s4,64(sp)
    800057fa:	7ae2                	ld	s5,56(sp)
    800057fc:	7b42                	ld	s6,48(sp)
    800057fe:	7ba2                	ld	s7,40(sp)
    80005800:	7c02                	ld	s8,32(sp)
    80005802:	6ce2                	ld	s9,24(sp)
    80005804:	6d42                	ld	s10,16(sp)
    80005806:	6165                	addi	sp,sp,112
    80005808:	8082                	ret
      if(n < target){
    8000580a:	0009871b          	sext.w	a4,s3
    8000580e:	fb677ce3          	bgeu	a4,s6,800057c6 <consoleread+0xbc>
        cons.r--;
    80005812:	00021717          	auipc	a4,0x21
    80005816:	9cf72323          	sw	a5,-1594(a4) # 800261d8 <cons+0x98>
    8000581a:	b775                	j	800057c6 <consoleread+0xbc>

000000008000581c <consputc>:
{
    8000581c:	1141                	addi	sp,sp,-16
    8000581e:	e406                	sd	ra,8(sp)
    80005820:	e022                	sd	s0,0(sp)
    80005822:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005824:	10000793          	li	a5,256
    80005828:	00f50a63          	beq	a0,a5,8000583c <consputc+0x20>
    uartputc_sync(c);
    8000582c:	00000097          	auipc	ra,0x0
    80005830:	560080e7          	jalr	1376(ra) # 80005d8c <uartputc_sync>
}
    80005834:	60a2                	ld	ra,8(sp)
    80005836:	6402                	ld	s0,0(sp)
    80005838:	0141                	addi	sp,sp,16
    8000583a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000583c:	4521                	li	a0,8
    8000583e:	00000097          	auipc	ra,0x0
    80005842:	54e080e7          	jalr	1358(ra) # 80005d8c <uartputc_sync>
    80005846:	02000513          	li	a0,32
    8000584a:	00000097          	auipc	ra,0x0
    8000584e:	542080e7          	jalr	1346(ra) # 80005d8c <uartputc_sync>
    80005852:	4521                	li	a0,8
    80005854:	00000097          	auipc	ra,0x0
    80005858:	538080e7          	jalr	1336(ra) # 80005d8c <uartputc_sync>
    8000585c:	bfe1                	j	80005834 <consputc+0x18>

000000008000585e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000585e:	1101                	addi	sp,sp,-32
    80005860:	ec06                	sd	ra,24(sp)
    80005862:	e822                	sd	s0,16(sp)
    80005864:	e426                	sd	s1,8(sp)
    80005866:	e04a                	sd	s2,0(sp)
    80005868:	1000                	addi	s0,sp,32
    8000586a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000586c:	00021517          	auipc	a0,0x21
    80005870:	8d450513          	addi	a0,a0,-1836 # 80026140 <cons>
    80005874:	00000097          	auipc	ra,0x0
    80005878:	7a4080e7          	jalr	1956(ra) # 80006018 <acquire>

  switch(c){
    8000587c:	47d5                	li	a5,21
    8000587e:	0af48663          	beq	s1,a5,8000592a <consoleintr+0xcc>
    80005882:	0297ca63          	blt	a5,s1,800058b6 <consoleintr+0x58>
    80005886:	47a1                	li	a5,8
    80005888:	0ef48763          	beq	s1,a5,80005976 <consoleintr+0x118>
    8000588c:	47c1                	li	a5,16
    8000588e:	10f49a63          	bne	s1,a5,800059a2 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005892:	ffffc097          	auipc	ra,0xffffc
    80005896:	0c6080e7          	jalr	198(ra) # 80001958 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000589a:	00021517          	auipc	a0,0x21
    8000589e:	8a650513          	addi	a0,a0,-1882 # 80026140 <cons>
    800058a2:	00001097          	auipc	ra,0x1
    800058a6:	82a080e7          	jalr	-2006(ra) # 800060cc <release>
}
    800058aa:	60e2                	ld	ra,24(sp)
    800058ac:	6442                	ld	s0,16(sp)
    800058ae:	64a2                	ld	s1,8(sp)
    800058b0:	6902                	ld	s2,0(sp)
    800058b2:	6105                	addi	sp,sp,32
    800058b4:	8082                	ret
  switch(c){
    800058b6:	07f00793          	li	a5,127
    800058ba:	0af48e63          	beq	s1,a5,80005976 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800058be:	00021717          	auipc	a4,0x21
    800058c2:	88270713          	addi	a4,a4,-1918 # 80026140 <cons>
    800058c6:	0a072783          	lw	a5,160(a4)
    800058ca:	09872703          	lw	a4,152(a4)
    800058ce:	9f99                	subw	a5,a5,a4
    800058d0:	07f00713          	li	a4,127
    800058d4:	fcf763e3          	bltu	a4,a5,8000589a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800058d8:	47b5                	li	a5,13
    800058da:	0cf48763          	beq	s1,a5,800059a8 <consoleintr+0x14a>
      consputc(c);
    800058de:	8526                	mv	a0,s1
    800058e0:	00000097          	auipc	ra,0x0
    800058e4:	f3c080e7          	jalr	-196(ra) # 8000581c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800058e8:	00021797          	auipc	a5,0x21
    800058ec:	85878793          	addi	a5,a5,-1960 # 80026140 <cons>
    800058f0:	0a07a703          	lw	a4,160(a5)
    800058f4:	0017069b          	addiw	a3,a4,1
    800058f8:	0006861b          	sext.w	a2,a3
    800058fc:	0ad7a023          	sw	a3,160(a5)
    80005900:	07f77713          	andi	a4,a4,127
    80005904:	97ba                	add	a5,a5,a4
    80005906:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000590a:	47a9                	li	a5,10
    8000590c:	0cf48563          	beq	s1,a5,800059d6 <consoleintr+0x178>
    80005910:	4791                	li	a5,4
    80005912:	0cf48263          	beq	s1,a5,800059d6 <consoleintr+0x178>
    80005916:	00021797          	auipc	a5,0x21
    8000591a:	8c27a783          	lw	a5,-1854(a5) # 800261d8 <cons+0x98>
    8000591e:	0807879b          	addiw	a5,a5,128
    80005922:	f6f61ce3          	bne	a2,a5,8000589a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005926:	863e                	mv	a2,a5
    80005928:	a07d                	j	800059d6 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000592a:	00021717          	auipc	a4,0x21
    8000592e:	81670713          	addi	a4,a4,-2026 # 80026140 <cons>
    80005932:	0a072783          	lw	a5,160(a4)
    80005936:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    8000593a:	00021497          	auipc	s1,0x21
    8000593e:	80648493          	addi	s1,s1,-2042 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005942:	4929                	li	s2,10
    80005944:	f4f70be3          	beq	a4,a5,8000589a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005948:	37fd                	addiw	a5,a5,-1
    8000594a:	07f7f713          	andi	a4,a5,127
    8000594e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005950:	01874703          	lbu	a4,24(a4)
    80005954:	f52703e3          	beq	a4,s2,8000589a <consoleintr+0x3c>
      cons.e--;
    80005958:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000595c:	10000513          	li	a0,256
    80005960:	00000097          	auipc	ra,0x0
    80005964:	ebc080e7          	jalr	-324(ra) # 8000581c <consputc>
    while(cons.e != cons.w &&
    80005968:	0a04a783          	lw	a5,160(s1)
    8000596c:	09c4a703          	lw	a4,156(s1)
    80005970:	fcf71ce3          	bne	a4,a5,80005948 <consoleintr+0xea>
    80005974:	b71d                	j	8000589a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005976:	00020717          	auipc	a4,0x20
    8000597a:	7ca70713          	addi	a4,a4,1994 # 80026140 <cons>
    8000597e:	0a072783          	lw	a5,160(a4)
    80005982:	09c72703          	lw	a4,156(a4)
    80005986:	f0f70ae3          	beq	a4,a5,8000589a <consoleintr+0x3c>
      cons.e--;
    8000598a:	37fd                	addiw	a5,a5,-1
    8000598c:	00021717          	auipc	a4,0x21
    80005990:	84f72a23          	sw	a5,-1964(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005994:	10000513          	li	a0,256
    80005998:	00000097          	auipc	ra,0x0
    8000599c:	e84080e7          	jalr	-380(ra) # 8000581c <consputc>
    800059a0:	bded                	j	8000589a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800059a2:	ee048ce3          	beqz	s1,8000589a <consoleintr+0x3c>
    800059a6:	bf21                	j	800058be <consoleintr+0x60>
      consputc(c);
    800059a8:	4529                	li	a0,10
    800059aa:	00000097          	auipc	ra,0x0
    800059ae:	e72080e7          	jalr	-398(ra) # 8000581c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800059b2:	00020797          	auipc	a5,0x20
    800059b6:	78e78793          	addi	a5,a5,1934 # 80026140 <cons>
    800059ba:	0a07a703          	lw	a4,160(a5)
    800059be:	0017069b          	addiw	a3,a4,1
    800059c2:	0006861b          	sext.w	a2,a3
    800059c6:	0ad7a023          	sw	a3,160(a5)
    800059ca:	07f77713          	andi	a4,a4,127
    800059ce:	97ba                	add	a5,a5,a4
    800059d0:	4729                	li	a4,10
    800059d2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800059d6:	00021797          	auipc	a5,0x21
    800059da:	80c7a323          	sw	a2,-2042(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    800059de:	00020517          	auipc	a0,0x20
    800059e2:	7fa50513          	addi	a0,a0,2042 # 800261d8 <cons+0x98>
    800059e6:	ffffc097          	auipc	ra,0xffffc
    800059ea:	cae080e7          	jalr	-850(ra) # 80001694 <wakeup>
    800059ee:	b575                	j	8000589a <consoleintr+0x3c>

00000000800059f0 <consoleinit>:

void
consoleinit(void)
{
    800059f0:	1141                	addi	sp,sp,-16
    800059f2:	e406                	sd	ra,8(sp)
    800059f4:	e022                	sd	s0,0(sp)
    800059f6:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800059f8:	00003597          	auipc	a1,0x3
    800059fc:	d9858593          	addi	a1,a1,-616 # 80008790 <syscalls+0x3c8>
    80005a00:	00020517          	auipc	a0,0x20
    80005a04:	74050513          	addi	a0,a0,1856 # 80026140 <cons>
    80005a08:	00000097          	auipc	ra,0x0
    80005a0c:	580080e7          	jalr	1408(ra) # 80005f88 <initlock>

  uartinit();
    80005a10:	00000097          	auipc	ra,0x0
    80005a14:	32c080e7          	jalr	812(ra) # 80005d3c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005a18:	00013797          	auipc	a5,0x13
    80005a1c:	6b078793          	addi	a5,a5,1712 # 800190c8 <devsw>
    80005a20:	00000717          	auipc	a4,0x0
    80005a24:	cea70713          	addi	a4,a4,-790 # 8000570a <consoleread>
    80005a28:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005a2a:	00000717          	auipc	a4,0x0
    80005a2e:	c7c70713          	addi	a4,a4,-900 # 800056a6 <consolewrite>
    80005a32:	ef98                	sd	a4,24(a5)
}
    80005a34:	60a2                	ld	ra,8(sp)
    80005a36:	6402                	ld	s0,0(sp)
    80005a38:	0141                	addi	sp,sp,16
    80005a3a:	8082                	ret

0000000080005a3c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005a3c:	7179                	addi	sp,sp,-48
    80005a3e:	f406                	sd	ra,40(sp)
    80005a40:	f022                	sd	s0,32(sp)
    80005a42:	ec26                	sd	s1,24(sp)
    80005a44:	e84a                	sd	s2,16(sp)
    80005a46:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005a48:	c219                	beqz	a2,80005a4e <printint+0x12>
    80005a4a:	08054763          	bltz	a0,80005ad8 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005a4e:	2501                	sext.w	a0,a0
    80005a50:	4881                	li	a7,0
    80005a52:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005a56:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005a58:	2581                	sext.w	a1,a1
    80005a5a:	00003617          	auipc	a2,0x3
    80005a5e:	d6660613          	addi	a2,a2,-666 # 800087c0 <digits>
    80005a62:	883a                	mv	a6,a4
    80005a64:	2705                	addiw	a4,a4,1
    80005a66:	02b577bb          	remuw	a5,a0,a1
    80005a6a:	1782                	slli	a5,a5,0x20
    80005a6c:	9381                	srli	a5,a5,0x20
    80005a6e:	97b2                	add	a5,a5,a2
    80005a70:	0007c783          	lbu	a5,0(a5)
    80005a74:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005a78:	0005079b          	sext.w	a5,a0
    80005a7c:	02b5553b          	divuw	a0,a0,a1
    80005a80:	0685                	addi	a3,a3,1
    80005a82:	feb7f0e3          	bgeu	a5,a1,80005a62 <printint+0x26>

  if(sign)
    80005a86:	00088c63          	beqz	a7,80005a9e <printint+0x62>
    buf[i++] = '-';
    80005a8a:	fe070793          	addi	a5,a4,-32
    80005a8e:	00878733          	add	a4,a5,s0
    80005a92:	02d00793          	li	a5,45
    80005a96:	fef70823          	sb	a5,-16(a4)
    80005a9a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005a9e:	02e05763          	blez	a4,80005acc <printint+0x90>
    80005aa2:	fd040793          	addi	a5,s0,-48
    80005aa6:	00e784b3          	add	s1,a5,a4
    80005aaa:	fff78913          	addi	s2,a5,-1
    80005aae:	993a                	add	s2,s2,a4
    80005ab0:	377d                	addiw	a4,a4,-1
    80005ab2:	1702                	slli	a4,a4,0x20
    80005ab4:	9301                	srli	a4,a4,0x20
    80005ab6:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005aba:	fff4c503          	lbu	a0,-1(s1)
    80005abe:	00000097          	auipc	ra,0x0
    80005ac2:	d5e080e7          	jalr	-674(ra) # 8000581c <consputc>
  while(--i >= 0)
    80005ac6:	14fd                	addi	s1,s1,-1
    80005ac8:	ff2499e3          	bne	s1,s2,80005aba <printint+0x7e>
}
    80005acc:	70a2                	ld	ra,40(sp)
    80005ace:	7402                	ld	s0,32(sp)
    80005ad0:	64e2                	ld	s1,24(sp)
    80005ad2:	6942                	ld	s2,16(sp)
    80005ad4:	6145                	addi	sp,sp,48
    80005ad6:	8082                	ret
    x = -xx;
    80005ad8:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005adc:	4885                	li	a7,1
    x = -xx;
    80005ade:	bf95                	j	80005a52 <printint+0x16>

0000000080005ae0 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ae0:	1101                	addi	sp,sp,-32
    80005ae2:	ec06                	sd	ra,24(sp)
    80005ae4:	e822                	sd	s0,16(sp)
    80005ae6:	e426                	sd	s1,8(sp)
    80005ae8:	1000                	addi	s0,sp,32
    80005aea:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005aec:	00020797          	auipc	a5,0x20
    80005af0:	7007aa23          	sw	zero,1812(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005af4:	00003517          	auipc	a0,0x3
    80005af8:	ca450513          	addi	a0,a0,-860 # 80008798 <syscalls+0x3d0>
    80005afc:	00000097          	auipc	ra,0x0
    80005b00:	02e080e7          	jalr	46(ra) # 80005b2a <printf>
  printf(s);
    80005b04:	8526                	mv	a0,s1
    80005b06:	00000097          	auipc	ra,0x0
    80005b0a:	024080e7          	jalr	36(ra) # 80005b2a <printf>
  printf("\n");
    80005b0e:	00002517          	auipc	a0,0x2
    80005b12:	53a50513          	addi	a0,a0,1338 # 80008048 <etext+0x48>
    80005b16:	00000097          	auipc	ra,0x0
    80005b1a:	014080e7          	jalr	20(ra) # 80005b2a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005b1e:	4785                	li	a5,1
    80005b20:	00003717          	auipc	a4,0x3
    80005b24:	4ef72e23          	sw	a5,1276(a4) # 8000901c <panicked>
  for(;;)
    80005b28:	a001                	j	80005b28 <panic+0x48>

0000000080005b2a <printf>:
{
    80005b2a:	7131                	addi	sp,sp,-192
    80005b2c:	fc86                	sd	ra,120(sp)
    80005b2e:	f8a2                	sd	s0,112(sp)
    80005b30:	f4a6                	sd	s1,104(sp)
    80005b32:	f0ca                	sd	s2,96(sp)
    80005b34:	ecce                	sd	s3,88(sp)
    80005b36:	e8d2                	sd	s4,80(sp)
    80005b38:	e4d6                	sd	s5,72(sp)
    80005b3a:	e0da                	sd	s6,64(sp)
    80005b3c:	fc5e                	sd	s7,56(sp)
    80005b3e:	f862                	sd	s8,48(sp)
    80005b40:	f466                	sd	s9,40(sp)
    80005b42:	f06a                	sd	s10,32(sp)
    80005b44:	ec6e                	sd	s11,24(sp)
    80005b46:	0100                	addi	s0,sp,128
    80005b48:	8a2a                	mv	s4,a0
    80005b4a:	e40c                	sd	a1,8(s0)
    80005b4c:	e810                	sd	a2,16(s0)
    80005b4e:	ec14                	sd	a3,24(s0)
    80005b50:	f018                	sd	a4,32(s0)
    80005b52:	f41c                	sd	a5,40(s0)
    80005b54:	03043823          	sd	a6,48(s0)
    80005b58:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005b5c:	00020d97          	auipc	s11,0x20
    80005b60:	6a4dad83          	lw	s11,1700(s11) # 80026200 <pr+0x18>
  if(locking)
    80005b64:	020d9b63          	bnez	s11,80005b9a <printf+0x70>
  if (fmt == 0)
    80005b68:	040a0263          	beqz	s4,80005bac <printf+0x82>
  va_start(ap, fmt);
    80005b6c:	00840793          	addi	a5,s0,8
    80005b70:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005b74:	000a4503          	lbu	a0,0(s4)
    80005b78:	14050f63          	beqz	a0,80005cd6 <printf+0x1ac>
    80005b7c:	4981                	li	s3,0
    if(c != '%'){
    80005b7e:	02500a93          	li	s5,37
    switch(c){
    80005b82:	07000b93          	li	s7,112
  consputc('x');
    80005b86:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005b88:	00003b17          	auipc	s6,0x3
    80005b8c:	c38b0b13          	addi	s6,s6,-968 # 800087c0 <digits>
    switch(c){
    80005b90:	07300c93          	li	s9,115
    80005b94:	06400c13          	li	s8,100
    80005b98:	a82d                	j	80005bd2 <printf+0xa8>
    acquire(&pr.lock);
    80005b9a:	00020517          	auipc	a0,0x20
    80005b9e:	64e50513          	addi	a0,a0,1614 # 800261e8 <pr>
    80005ba2:	00000097          	auipc	ra,0x0
    80005ba6:	476080e7          	jalr	1142(ra) # 80006018 <acquire>
    80005baa:	bf7d                	j	80005b68 <printf+0x3e>
    panic("null fmt");
    80005bac:	00003517          	auipc	a0,0x3
    80005bb0:	bfc50513          	addi	a0,a0,-1028 # 800087a8 <syscalls+0x3e0>
    80005bb4:	00000097          	auipc	ra,0x0
    80005bb8:	f2c080e7          	jalr	-212(ra) # 80005ae0 <panic>
      consputc(c);
    80005bbc:	00000097          	auipc	ra,0x0
    80005bc0:	c60080e7          	jalr	-928(ra) # 8000581c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005bc4:	2985                	addiw	s3,s3,1
    80005bc6:	013a07b3          	add	a5,s4,s3
    80005bca:	0007c503          	lbu	a0,0(a5)
    80005bce:	10050463          	beqz	a0,80005cd6 <printf+0x1ac>
    if(c != '%'){
    80005bd2:	ff5515e3          	bne	a0,s5,80005bbc <printf+0x92>
    c = fmt[++i] & 0xff;
    80005bd6:	2985                	addiw	s3,s3,1
    80005bd8:	013a07b3          	add	a5,s4,s3
    80005bdc:	0007c783          	lbu	a5,0(a5)
    80005be0:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005be4:	cbed                	beqz	a5,80005cd6 <printf+0x1ac>
    switch(c){
    80005be6:	05778a63          	beq	a5,s7,80005c3a <printf+0x110>
    80005bea:	02fbf663          	bgeu	s7,a5,80005c16 <printf+0xec>
    80005bee:	09978863          	beq	a5,s9,80005c7e <printf+0x154>
    80005bf2:	07800713          	li	a4,120
    80005bf6:	0ce79563          	bne	a5,a4,80005cc0 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005bfa:	f8843783          	ld	a5,-120(s0)
    80005bfe:	00878713          	addi	a4,a5,8
    80005c02:	f8e43423          	sd	a4,-120(s0)
    80005c06:	4605                	li	a2,1
    80005c08:	85ea                	mv	a1,s10
    80005c0a:	4388                	lw	a0,0(a5)
    80005c0c:	00000097          	auipc	ra,0x0
    80005c10:	e30080e7          	jalr	-464(ra) # 80005a3c <printint>
      break;
    80005c14:	bf45                	j	80005bc4 <printf+0x9a>
    switch(c){
    80005c16:	09578f63          	beq	a5,s5,80005cb4 <printf+0x18a>
    80005c1a:	0b879363          	bne	a5,s8,80005cc0 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005c1e:	f8843783          	ld	a5,-120(s0)
    80005c22:	00878713          	addi	a4,a5,8
    80005c26:	f8e43423          	sd	a4,-120(s0)
    80005c2a:	4605                	li	a2,1
    80005c2c:	45a9                	li	a1,10
    80005c2e:	4388                	lw	a0,0(a5)
    80005c30:	00000097          	auipc	ra,0x0
    80005c34:	e0c080e7          	jalr	-500(ra) # 80005a3c <printint>
      break;
    80005c38:	b771                	j	80005bc4 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005c3a:	f8843783          	ld	a5,-120(s0)
    80005c3e:	00878713          	addi	a4,a5,8
    80005c42:	f8e43423          	sd	a4,-120(s0)
    80005c46:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005c4a:	03000513          	li	a0,48
    80005c4e:	00000097          	auipc	ra,0x0
    80005c52:	bce080e7          	jalr	-1074(ra) # 8000581c <consputc>
  consputc('x');
    80005c56:	07800513          	li	a0,120
    80005c5a:	00000097          	auipc	ra,0x0
    80005c5e:	bc2080e7          	jalr	-1086(ra) # 8000581c <consputc>
    80005c62:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c64:	03c95793          	srli	a5,s2,0x3c
    80005c68:	97da                	add	a5,a5,s6
    80005c6a:	0007c503          	lbu	a0,0(a5)
    80005c6e:	00000097          	auipc	ra,0x0
    80005c72:	bae080e7          	jalr	-1106(ra) # 8000581c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005c76:	0912                	slli	s2,s2,0x4
    80005c78:	34fd                	addiw	s1,s1,-1
    80005c7a:	f4ed                	bnez	s1,80005c64 <printf+0x13a>
    80005c7c:	b7a1                	j	80005bc4 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005c7e:	f8843783          	ld	a5,-120(s0)
    80005c82:	00878713          	addi	a4,a5,8
    80005c86:	f8e43423          	sd	a4,-120(s0)
    80005c8a:	6384                	ld	s1,0(a5)
    80005c8c:	cc89                	beqz	s1,80005ca6 <printf+0x17c>
      for(; *s; s++)
    80005c8e:	0004c503          	lbu	a0,0(s1)
    80005c92:	d90d                	beqz	a0,80005bc4 <printf+0x9a>
        consputc(*s);
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	b88080e7          	jalr	-1144(ra) # 8000581c <consputc>
      for(; *s; s++)
    80005c9c:	0485                	addi	s1,s1,1
    80005c9e:	0004c503          	lbu	a0,0(s1)
    80005ca2:	f96d                	bnez	a0,80005c94 <printf+0x16a>
    80005ca4:	b705                	j	80005bc4 <printf+0x9a>
        s = "(null)";
    80005ca6:	00003497          	auipc	s1,0x3
    80005caa:	afa48493          	addi	s1,s1,-1286 # 800087a0 <syscalls+0x3d8>
      for(; *s; s++)
    80005cae:	02800513          	li	a0,40
    80005cb2:	b7cd                	j	80005c94 <printf+0x16a>
      consputc('%');
    80005cb4:	8556                	mv	a0,s5
    80005cb6:	00000097          	auipc	ra,0x0
    80005cba:	b66080e7          	jalr	-1178(ra) # 8000581c <consputc>
      break;
    80005cbe:	b719                	j	80005bc4 <printf+0x9a>
      consputc('%');
    80005cc0:	8556                	mv	a0,s5
    80005cc2:	00000097          	auipc	ra,0x0
    80005cc6:	b5a080e7          	jalr	-1190(ra) # 8000581c <consputc>
      consputc(c);
    80005cca:	8526                	mv	a0,s1
    80005ccc:	00000097          	auipc	ra,0x0
    80005cd0:	b50080e7          	jalr	-1200(ra) # 8000581c <consputc>
      break;
    80005cd4:	bdc5                	j	80005bc4 <printf+0x9a>
  if(locking)
    80005cd6:	020d9163          	bnez	s11,80005cf8 <printf+0x1ce>
}
    80005cda:	70e6                	ld	ra,120(sp)
    80005cdc:	7446                	ld	s0,112(sp)
    80005cde:	74a6                	ld	s1,104(sp)
    80005ce0:	7906                	ld	s2,96(sp)
    80005ce2:	69e6                	ld	s3,88(sp)
    80005ce4:	6a46                	ld	s4,80(sp)
    80005ce6:	6aa6                	ld	s5,72(sp)
    80005ce8:	6b06                	ld	s6,64(sp)
    80005cea:	7be2                	ld	s7,56(sp)
    80005cec:	7c42                	ld	s8,48(sp)
    80005cee:	7ca2                	ld	s9,40(sp)
    80005cf0:	7d02                	ld	s10,32(sp)
    80005cf2:	6de2                	ld	s11,24(sp)
    80005cf4:	6129                	addi	sp,sp,192
    80005cf6:	8082                	ret
    release(&pr.lock);
    80005cf8:	00020517          	auipc	a0,0x20
    80005cfc:	4f050513          	addi	a0,a0,1264 # 800261e8 <pr>
    80005d00:	00000097          	auipc	ra,0x0
    80005d04:	3cc080e7          	jalr	972(ra) # 800060cc <release>
}
    80005d08:	bfc9                	j	80005cda <printf+0x1b0>

0000000080005d0a <printfinit>:
    ;
}

void
printfinit(void)
{
    80005d0a:	1101                	addi	sp,sp,-32
    80005d0c:	ec06                	sd	ra,24(sp)
    80005d0e:	e822                	sd	s0,16(sp)
    80005d10:	e426                	sd	s1,8(sp)
    80005d12:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005d14:	00020497          	auipc	s1,0x20
    80005d18:	4d448493          	addi	s1,s1,1236 # 800261e8 <pr>
    80005d1c:	00003597          	auipc	a1,0x3
    80005d20:	a9c58593          	addi	a1,a1,-1380 # 800087b8 <syscalls+0x3f0>
    80005d24:	8526                	mv	a0,s1
    80005d26:	00000097          	auipc	ra,0x0
    80005d2a:	262080e7          	jalr	610(ra) # 80005f88 <initlock>
  pr.locking = 1;
    80005d2e:	4785                	li	a5,1
    80005d30:	cc9c                	sw	a5,24(s1)
}
    80005d32:	60e2                	ld	ra,24(sp)
    80005d34:	6442                	ld	s0,16(sp)
    80005d36:	64a2                	ld	s1,8(sp)
    80005d38:	6105                	addi	sp,sp,32
    80005d3a:	8082                	ret

0000000080005d3c <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005d3c:	1141                	addi	sp,sp,-16
    80005d3e:	e406                	sd	ra,8(sp)
    80005d40:	e022                	sd	s0,0(sp)
    80005d42:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005d44:	100007b7          	lui	a5,0x10000
    80005d48:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005d4c:	f8000713          	li	a4,-128
    80005d50:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005d54:	470d                	li	a4,3
    80005d56:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005d5a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005d5e:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005d62:	469d                	li	a3,7
    80005d64:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005d68:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005d6c:	00003597          	auipc	a1,0x3
    80005d70:	a6c58593          	addi	a1,a1,-1428 # 800087d8 <digits+0x18>
    80005d74:	00020517          	auipc	a0,0x20
    80005d78:	49450513          	addi	a0,a0,1172 # 80026208 <uart_tx_lock>
    80005d7c:	00000097          	auipc	ra,0x0
    80005d80:	20c080e7          	jalr	524(ra) # 80005f88 <initlock>
}
    80005d84:	60a2                	ld	ra,8(sp)
    80005d86:	6402                	ld	s0,0(sp)
    80005d88:	0141                	addi	sp,sp,16
    80005d8a:	8082                	ret

0000000080005d8c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005d8c:	1101                	addi	sp,sp,-32
    80005d8e:	ec06                	sd	ra,24(sp)
    80005d90:	e822                	sd	s0,16(sp)
    80005d92:	e426                	sd	s1,8(sp)
    80005d94:	1000                	addi	s0,sp,32
    80005d96:	84aa                	mv	s1,a0
  push_off();
    80005d98:	00000097          	auipc	ra,0x0
    80005d9c:	234080e7          	jalr	564(ra) # 80005fcc <push_off>

  if(panicked){
    80005da0:	00003797          	auipc	a5,0x3
    80005da4:	27c7a783          	lw	a5,636(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005da8:	10000737          	lui	a4,0x10000
  if(panicked){
    80005dac:	c391                	beqz	a5,80005db0 <uartputc_sync+0x24>
    for(;;)
    80005dae:	a001                	j	80005dae <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005db0:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005db4:	0207f793          	andi	a5,a5,32
    80005db8:	dfe5                	beqz	a5,80005db0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005dba:	0ff4f513          	zext.b	a0,s1
    80005dbe:	100007b7          	lui	a5,0x10000
    80005dc2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005dc6:	00000097          	auipc	ra,0x0
    80005dca:	2a6080e7          	jalr	678(ra) # 8000606c <pop_off>
}
    80005dce:	60e2                	ld	ra,24(sp)
    80005dd0:	6442                	ld	s0,16(sp)
    80005dd2:	64a2                	ld	s1,8(sp)
    80005dd4:	6105                	addi	sp,sp,32
    80005dd6:	8082                	ret

0000000080005dd8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005dd8:	00003797          	auipc	a5,0x3
    80005ddc:	2487b783          	ld	a5,584(a5) # 80009020 <uart_tx_r>
    80005de0:	00003717          	auipc	a4,0x3
    80005de4:	24873703          	ld	a4,584(a4) # 80009028 <uart_tx_w>
    80005de8:	06f70a63          	beq	a4,a5,80005e5c <uartstart+0x84>
{
    80005dec:	7139                	addi	sp,sp,-64
    80005dee:	fc06                	sd	ra,56(sp)
    80005df0:	f822                	sd	s0,48(sp)
    80005df2:	f426                	sd	s1,40(sp)
    80005df4:	f04a                	sd	s2,32(sp)
    80005df6:	ec4e                	sd	s3,24(sp)
    80005df8:	e852                	sd	s4,16(sp)
    80005dfa:	e456                	sd	s5,8(sp)
    80005dfc:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005dfe:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e02:	00020a17          	auipc	s4,0x20
    80005e06:	406a0a13          	addi	s4,s4,1030 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005e0a:	00003497          	auipc	s1,0x3
    80005e0e:	21648493          	addi	s1,s1,534 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005e12:	00003997          	auipc	s3,0x3
    80005e16:	21698993          	addi	s3,s3,534 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e1a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005e1e:	02077713          	andi	a4,a4,32
    80005e22:	c705                	beqz	a4,80005e4a <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e24:	01f7f713          	andi	a4,a5,31
    80005e28:	9752                	add	a4,a4,s4
    80005e2a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005e2e:	0785                	addi	a5,a5,1
    80005e30:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005e32:	8526                	mv	a0,s1
    80005e34:	ffffc097          	auipc	ra,0xffffc
    80005e38:	860080e7          	jalr	-1952(ra) # 80001694 <wakeup>
    
    WriteReg(THR, c);
    80005e3c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005e40:	609c                	ld	a5,0(s1)
    80005e42:	0009b703          	ld	a4,0(s3)
    80005e46:	fcf71ae3          	bne	a4,a5,80005e1a <uartstart+0x42>
  }
}
    80005e4a:	70e2                	ld	ra,56(sp)
    80005e4c:	7442                	ld	s0,48(sp)
    80005e4e:	74a2                	ld	s1,40(sp)
    80005e50:	7902                	ld	s2,32(sp)
    80005e52:	69e2                	ld	s3,24(sp)
    80005e54:	6a42                	ld	s4,16(sp)
    80005e56:	6aa2                	ld	s5,8(sp)
    80005e58:	6121                	addi	sp,sp,64
    80005e5a:	8082                	ret
    80005e5c:	8082                	ret

0000000080005e5e <uartputc>:
{
    80005e5e:	7179                	addi	sp,sp,-48
    80005e60:	f406                	sd	ra,40(sp)
    80005e62:	f022                	sd	s0,32(sp)
    80005e64:	ec26                	sd	s1,24(sp)
    80005e66:	e84a                	sd	s2,16(sp)
    80005e68:	e44e                	sd	s3,8(sp)
    80005e6a:	e052                	sd	s4,0(sp)
    80005e6c:	1800                	addi	s0,sp,48
    80005e6e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005e70:	00020517          	auipc	a0,0x20
    80005e74:	39850513          	addi	a0,a0,920 # 80026208 <uart_tx_lock>
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	1a0080e7          	jalr	416(ra) # 80006018 <acquire>
  if(panicked){
    80005e80:	00003797          	auipc	a5,0x3
    80005e84:	19c7a783          	lw	a5,412(a5) # 8000901c <panicked>
    80005e88:	c391                	beqz	a5,80005e8c <uartputc+0x2e>
    for(;;)
    80005e8a:	a001                	j	80005e8a <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005e8c:	00003717          	auipc	a4,0x3
    80005e90:	19c73703          	ld	a4,412(a4) # 80009028 <uart_tx_w>
    80005e94:	00003797          	auipc	a5,0x3
    80005e98:	18c7b783          	ld	a5,396(a5) # 80009020 <uart_tx_r>
    80005e9c:	02078793          	addi	a5,a5,32
    80005ea0:	02e79b63          	bne	a5,a4,80005ed6 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005ea4:	00020997          	auipc	s3,0x20
    80005ea8:	36498993          	addi	s3,s3,868 # 80026208 <uart_tx_lock>
    80005eac:	00003497          	auipc	s1,0x3
    80005eb0:	17448493          	addi	s1,s1,372 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005eb4:	00003917          	auipc	s2,0x3
    80005eb8:	17490913          	addi	s2,s2,372 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005ebc:	85ce                	mv	a1,s3
    80005ebe:	8526                	mv	a0,s1
    80005ec0:	ffffb097          	auipc	ra,0xffffb
    80005ec4:	648080e7          	jalr	1608(ra) # 80001508 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005ec8:	00093703          	ld	a4,0(s2)
    80005ecc:	609c                	ld	a5,0(s1)
    80005ece:	02078793          	addi	a5,a5,32
    80005ed2:	fee785e3          	beq	a5,a4,80005ebc <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005ed6:	00020497          	auipc	s1,0x20
    80005eda:	33248493          	addi	s1,s1,818 # 80026208 <uart_tx_lock>
    80005ede:	01f77793          	andi	a5,a4,31
    80005ee2:	97a6                	add	a5,a5,s1
    80005ee4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80005ee8:	0705                	addi	a4,a4,1
    80005eea:	00003797          	auipc	a5,0x3
    80005eee:	12e7bf23          	sd	a4,318(a5) # 80009028 <uart_tx_w>
      uartstart();
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	ee6080e7          	jalr	-282(ra) # 80005dd8 <uartstart>
      release(&uart_tx_lock);
    80005efa:	8526                	mv	a0,s1
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	1d0080e7          	jalr	464(ra) # 800060cc <release>
}
    80005f04:	70a2                	ld	ra,40(sp)
    80005f06:	7402                	ld	s0,32(sp)
    80005f08:	64e2                	ld	s1,24(sp)
    80005f0a:	6942                	ld	s2,16(sp)
    80005f0c:	69a2                	ld	s3,8(sp)
    80005f0e:	6a02                	ld	s4,0(sp)
    80005f10:	6145                	addi	sp,sp,48
    80005f12:	8082                	ret

0000000080005f14 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005f14:	1141                	addi	sp,sp,-16
    80005f16:	e422                	sd	s0,8(sp)
    80005f18:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005f1a:	100007b7          	lui	a5,0x10000
    80005f1e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005f22:	8b85                	andi	a5,a5,1
    80005f24:	cb81                	beqz	a5,80005f34 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80005f26:	100007b7          	lui	a5,0x10000
    80005f2a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005f2e:	6422                	ld	s0,8(sp)
    80005f30:	0141                	addi	sp,sp,16
    80005f32:	8082                	ret
    return -1;
    80005f34:	557d                	li	a0,-1
    80005f36:	bfe5                	j	80005f2e <uartgetc+0x1a>

0000000080005f38 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80005f38:	1101                	addi	sp,sp,-32
    80005f3a:	ec06                	sd	ra,24(sp)
    80005f3c:	e822                	sd	s0,16(sp)
    80005f3e:	e426                	sd	s1,8(sp)
    80005f40:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005f42:	54fd                	li	s1,-1
    80005f44:	a029                	j	80005f4e <uartintr+0x16>
      break;
    consoleintr(c);
    80005f46:	00000097          	auipc	ra,0x0
    80005f4a:	918080e7          	jalr	-1768(ra) # 8000585e <consoleintr>
    int c = uartgetc();
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	fc6080e7          	jalr	-58(ra) # 80005f14 <uartgetc>
    if(c == -1)
    80005f56:	fe9518e3          	bne	a0,s1,80005f46 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005f5a:	00020497          	auipc	s1,0x20
    80005f5e:	2ae48493          	addi	s1,s1,686 # 80026208 <uart_tx_lock>
    80005f62:	8526                	mv	a0,s1
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	0b4080e7          	jalr	180(ra) # 80006018 <acquire>
  uartstart();
    80005f6c:	00000097          	auipc	ra,0x0
    80005f70:	e6c080e7          	jalr	-404(ra) # 80005dd8 <uartstart>
  release(&uart_tx_lock);
    80005f74:	8526                	mv	a0,s1
    80005f76:	00000097          	auipc	ra,0x0
    80005f7a:	156080e7          	jalr	342(ra) # 800060cc <release>
}
    80005f7e:	60e2                	ld	ra,24(sp)
    80005f80:	6442                	ld	s0,16(sp)
    80005f82:	64a2                	ld	s1,8(sp)
    80005f84:	6105                	addi	sp,sp,32
    80005f86:	8082                	ret

0000000080005f88 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005f88:	1141                	addi	sp,sp,-16
    80005f8a:	e422                	sd	s0,8(sp)
    80005f8c:	0800                	addi	s0,sp,16
  lk->name = name;
    80005f8e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005f90:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005f94:	00053823          	sd	zero,16(a0)
}
    80005f98:	6422                	ld	s0,8(sp)
    80005f9a:	0141                	addi	sp,sp,16
    80005f9c:	8082                	ret

0000000080005f9e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005f9e:	411c                	lw	a5,0(a0)
    80005fa0:	e399                	bnez	a5,80005fa6 <holding+0x8>
    80005fa2:	4501                	li	a0,0
  return r;
}
    80005fa4:	8082                	ret
{
    80005fa6:	1101                	addi	sp,sp,-32
    80005fa8:	ec06                	sd	ra,24(sp)
    80005faa:	e822                	sd	s0,16(sp)
    80005fac:	e426                	sd	s1,8(sp)
    80005fae:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005fb0:	6904                	ld	s1,16(a0)
    80005fb2:	ffffb097          	auipc	ra,0xffffb
    80005fb6:	e76080e7          	jalr	-394(ra) # 80000e28 <mycpu>
    80005fba:	40a48533          	sub	a0,s1,a0
    80005fbe:	00153513          	seqz	a0,a0
}
    80005fc2:	60e2                	ld	ra,24(sp)
    80005fc4:	6442                	ld	s0,16(sp)
    80005fc6:	64a2                	ld	s1,8(sp)
    80005fc8:	6105                	addi	sp,sp,32
    80005fca:	8082                	ret

0000000080005fcc <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005fcc:	1101                	addi	sp,sp,-32
    80005fce:	ec06                	sd	ra,24(sp)
    80005fd0:	e822                	sd	s0,16(sp)
    80005fd2:	e426                	sd	s1,8(sp)
    80005fd4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005fd6:	100024f3          	csrr	s1,sstatus
    80005fda:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005fde:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005fe0:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005fe4:	ffffb097          	auipc	ra,0xffffb
    80005fe8:	e44080e7          	jalr	-444(ra) # 80000e28 <mycpu>
    80005fec:	5d3c                	lw	a5,120(a0)
    80005fee:	cf89                	beqz	a5,80006008 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005ff0:	ffffb097          	auipc	ra,0xffffb
    80005ff4:	e38080e7          	jalr	-456(ra) # 80000e28 <mycpu>
    80005ff8:	5d3c                	lw	a5,120(a0)
    80005ffa:	2785                	addiw	a5,a5,1
    80005ffc:	dd3c                	sw	a5,120(a0)
}
    80005ffe:	60e2                	ld	ra,24(sp)
    80006000:	6442                	ld	s0,16(sp)
    80006002:	64a2                	ld	s1,8(sp)
    80006004:	6105                	addi	sp,sp,32
    80006006:	8082                	ret
    mycpu()->intena = old;
    80006008:	ffffb097          	auipc	ra,0xffffb
    8000600c:	e20080e7          	jalr	-480(ra) # 80000e28 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006010:	8085                	srli	s1,s1,0x1
    80006012:	8885                	andi	s1,s1,1
    80006014:	dd64                	sw	s1,124(a0)
    80006016:	bfe9                	j	80005ff0 <push_off+0x24>

0000000080006018 <acquire>:
{
    80006018:	1101                	addi	sp,sp,-32
    8000601a:	ec06                	sd	ra,24(sp)
    8000601c:	e822                	sd	s0,16(sp)
    8000601e:	e426                	sd	s1,8(sp)
    80006020:	1000                	addi	s0,sp,32
    80006022:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006024:	00000097          	auipc	ra,0x0
    80006028:	fa8080e7          	jalr	-88(ra) # 80005fcc <push_off>
  if(holding(lk))
    8000602c:	8526                	mv	a0,s1
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	f70080e7          	jalr	-144(ra) # 80005f9e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006036:	4705                	li	a4,1
  if(holding(lk))
    80006038:	e115                	bnez	a0,8000605c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000603a:	87ba                	mv	a5,a4
    8000603c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006040:	2781                	sext.w	a5,a5
    80006042:	ffe5                	bnez	a5,8000603a <acquire+0x22>
  __sync_synchronize();
    80006044:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006048:	ffffb097          	auipc	ra,0xffffb
    8000604c:	de0080e7          	jalr	-544(ra) # 80000e28 <mycpu>
    80006050:	e888                	sd	a0,16(s1)
}
    80006052:	60e2                	ld	ra,24(sp)
    80006054:	6442                	ld	s0,16(sp)
    80006056:	64a2                	ld	s1,8(sp)
    80006058:	6105                	addi	sp,sp,32
    8000605a:	8082                	ret
    panic("acquire");
    8000605c:	00002517          	auipc	a0,0x2
    80006060:	78450513          	addi	a0,a0,1924 # 800087e0 <digits+0x20>
    80006064:	00000097          	auipc	ra,0x0
    80006068:	a7c080e7          	jalr	-1412(ra) # 80005ae0 <panic>

000000008000606c <pop_off>:

void
pop_off(void)
{
    8000606c:	1141                	addi	sp,sp,-16
    8000606e:	e406                	sd	ra,8(sp)
    80006070:	e022                	sd	s0,0(sp)
    80006072:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006074:	ffffb097          	auipc	ra,0xffffb
    80006078:	db4080e7          	jalr	-588(ra) # 80000e28 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000607c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006080:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006082:	e78d                	bnez	a5,800060ac <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006084:	5d3c                	lw	a5,120(a0)
    80006086:	02f05b63          	blez	a5,800060bc <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000608a:	37fd                	addiw	a5,a5,-1
    8000608c:	0007871b          	sext.w	a4,a5
    80006090:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006092:	eb09                	bnez	a4,800060a4 <pop_off+0x38>
    80006094:	5d7c                	lw	a5,124(a0)
    80006096:	c799                	beqz	a5,800060a4 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006098:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000609c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800060a0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800060a4:	60a2                	ld	ra,8(sp)
    800060a6:	6402                	ld	s0,0(sp)
    800060a8:	0141                	addi	sp,sp,16
    800060aa:	8082                	ret
    panic("pop_off - interruptible");
    800060ac:	00002517          	auipc	a0,0x2
    800060b0:	73c50513          	addi	a0,a0,1852 # 800087e8 <digits+0x28>
    800060b4:	00000097          	auipc	ra,0x0
    800060b8:	a2c080e7          	jalr	-1492(ra) # 80005ae0 <panic>
    panic("pop_off");
    800060bc:	00002517          	auipc	a0,0x2
    800060c0:	74450513          	addi	a0,a0,1860 # 80008800 <digits+0x40>
    800060c4:	00000097          	auipc	ra,0x0
    800060c8:	a1c080e7          	jalr	-1508(ra) # 80005ae0 <panic>

00000000800060cc <release>:
{
    800060cc:	1101                	addi	sp,sp,-32
    800060ce:	ec06                	sd	ra,24(sp)
    800060d0:	e822                	sd	s0,16(sp)
    800060d2:	e426                	sd	s1,8(sp)
    800060d4:	1000                	addi	s0,sp,32
    800060d6:	84aa                	mv	s1,a0
  if(!holding(lk))
    800060d8:	00000097          	auipc	ra,0x0
    800060dc:	ec6080e7          	jalr	-314(ra) # 80005f9e <holding>
    800060e0:	c115                	beqz	a0,80006104 <release+0x38>
  lk->cpu = 0;
    800060e2:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800060e6:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800060ea:	0f50000f          	fence	iorw,ow
    800060ee:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800060f2:	00000097          	auipc	ra,0x0
    800060f6:	f7a080e7          	jalr	-134(ra) # 8000606c <pop_off>
}
    800060fa:	60e2                	ld	ra,24(sp)
    800060fc:	6442                	ld	s0,16(sp)
    800060fe:	64a2                	ld	s1,8(sp)
    80006100:	6105                	addi	sp,sp,32
    80006102:	8082                	ret
    panic("release");
    80006104:	00002517          	auipc	a0,0x2
    80006108:	70450513          	addi	a0,a0,1796 # 80008808 <digits+0x48>
    8000610c:	00000097          	auipc	ra,0x0
    80006110:	9d4080e7          	jalr	-1580(ra) # 80005ae0 <panic>
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
