
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8f013103          	ld	sp,-1808(sp) # 800088f0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	08d050ef          	jal	ra,800058a2 <start>

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
    8000005e:	22e080e7          	jalr	558(ra) # 80006288 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2ce080e7          	jalr	718(ra) # 8000633c <release>
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
    8000008e:	cc6080e7          	jalr	-826(ra) # 80005d50 <panic>

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
    800000fa:	102080e7          	jalr	258(ra) # 800061f8 <initlock>
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
    80000132:	15a080e7          	jalr	346(ra) # 80006288 <acquire>
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
    8000014a:	1f6080e7          	jalr	502(ra) # 8000633c <release>

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
    80000174:	1cc080e7          	jalr	460(ra) # 8000633c <release>
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
    8000032c:	c22080e7          	jalr	-990(ra) # 80000f4a <cpuid>
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
    80000348:	c06080e7          	jalr	-1018(ra) # 80000f4a <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	a44080e7          	jalr	-1468(ra) # 80005d9a <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	8f0080e7          	jalr	-1808(ra) # 80001c56 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	f12080e7          	jalr	-238(ra) # 80005280 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	19c080e7          	jalr	412(ra) # 80001512 <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	8e2080e7          	jalr	-1822(ra) # 80005c60 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	bf4080e7          	jalr	-1036(ra) # 80005f7a <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	a04080e7          	jalr	-1532(ra) # 80005d9a <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	9f4080e7          	jalr	-1548(ra) # 80005d9a <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	9e4080e7          	jalr	-1564(ra) # 80005d9a <printf>
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
    800003da:	ac6080e7          	jalr	-1338(ra) # 80000e9c <procinit>
    trapinit();      // trap vectors
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	850080e7          	jalr	-1968(ra) # 80001c2e <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00002097          	auipc	ra,0x2
    800003ea:	870080e7          	jalr	-1936(ra) # 80001c56 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	e7c080e7          	jalr	-388(ra) # 8000526a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	e8a080e7          	jalr	-374(ra) # 80005280 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	024080e7          	jalr	36(ra) # 80002422 <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	6b2080e7          	jalr	1714(ra) # 80002ab8 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	664080e7          	jalr	1636(ra) # 80003a72 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	f8a080e7          	jalr	-118(ra) # 800053a0 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	eba080e7          	jalr	-326(ra) # 800012d8 <userinit>
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
    8000048c:	8c8080e7          	jalr	-1848(ra) # 80005d50 <panic>
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
    800005b2:	7a2080e7          	jalr	1954(ra) # 80005d50 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00005097          	auipc	ra,0x5
    800005c2:	792080e7          	jalr	1938(ra) # 80005d50 <panic>
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
    8000060e:	746080e7          	jalr	1862(ra) # 80005d50 <panic>

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
    800006d6:	736080e7          	jalr	1846(ra) # 80000e08 <proc_mapstacks>
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
    8000075a:	5fa080e7          	jalr	1530(ra) # 80005d50 <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00005097          	auipc	ra,0x5
    8000076a:	5ea080e7          	jalr	1514(ra) # 80005d50 <panic>
      panic("uvmunmap: not mapped");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00005097          	auipc	ra,0x5
    8000077a:	5da080e7          	jalr	1498(ra) # 80005d50 <panic>
      panic("uvmunmap: not a leaf");
    8000077e:	00008517          	auipc	a0,0x8
    80000782:	94250513          	addi	a0,a0,-1726 # 800080c0 <etext+0xc0>
    80000786:	00005097          	auipc	ra,0x5
    8000078a:	5ca080e7          	jalr	1482(ra) # 80005d50 <panic>
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
    80000868:	4ec080e7          	jalr	1260(ra) # 80005d50 <panic>

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
    800009ac:	3a8080e7          	jalr	936(ra) # 80005d50 <panic>
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
    80000a8a:	2ca080e7          	jalr	714(ra) # 80005d50 <panic>
      panic("uvmcopy: page not present");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	69a50513          	addi	a0,a0,1690 # 80008128 <etext+0x128>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	2ba080e7          	jalr	698(ra) # 80005d50 <panic>
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
    80000b04:	250080e7          	jalr	592(ra) # 80005d50 <panic>

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

0000000080000cd2 <vmprint>:


void vmprint(pagetable_t pagetable, int level)
{
    80000cd2:	711d                	addi	sp,sp,-96
    80000cd4:	ec86                	sd	ra,88(sp)
    80000cd6:	e8a2                	sd	s0,80(sp)
    80000cd8:	e4a6                	sd	s1,72(sp)
    80000cda:	e0ca                	sd	s2,64(sp)
    80000cdc:	fc4e                	sd	s3,56(sp)
    80000cde:	f852                	sd	s4,48(sp)
    80000ce0:	f456                	sd	s5,40(sp)
    80000ce2:	f05a                	sd	s6,32(sp)
    80000ce4:	ec5e                	sd	s7,24(sp)
    80000ce6:	e862                	sd	s8,16(sp)
    80000ce8:	e466                	sd	s9,8(sp)
    80000cea:	1080                	addi	s0,sp,96
    80000cec:	84aa                	mv	s1,a0
    80000cee:	8a2e                	mv	s4,a1
	static char* level1 = "..";
	static char* level2 = ".. ..";
	static char* level3 = ".. .. ..";
	char* buf = 0;
	if (1 == level)
    80000cf0:	4785                	li	a5,1
		buf = level1;
    80000cf2:	00007b97          	auipc	s7,0x7
    80000cf6:	466b8b93          	addi	s7,s7,1126 # 80008158 <etext+0x158>
	if (1 == level)
    80000cfa:	00f58d63          	beq	a1,a5,80000d14 <vmprint+0x42>
	else if (2 == level)
    80000cfe:	4789                	li	a5,2
		buf =  level2;
    80000d00:	00007b97          	auipc	s7,0x7
    80000d04:	460b8b93          	addi	s7,s7,1120 # 80008160 <etext+0x160>
	else if (2 == level)
    80000d08:	00f58663          	beq	a1,a5,80000d14 <vmprint+0x42>
	else if (3 == level)
    80000d0c:	478d                	li	a5,3
	char* buf = 0;
    80000d0e:	4b81                	li	s7,0
	else if (3 == level)
    80000d10:	00f58d63          	beq	a1,a5,80000d2a <vmprint+0x58>
		buf = level3;
	for (int i = 0;i < 512;i++)
    80000d14:	4901                	li	s2,0
	{
		pte_t pte = pagetable[i];
		if ((pte & PTE_V) && level <= 3)
    80000d16:	4a8d                	li	s5,3
		{
			uint64 child = PTE2PA(pte);
			printf("%s%d: pte %p pa %p\n",buf,i,pte,child);
    80000d18:	00007c97          	auipc	s9,0x7
    80000d1c:	460c8c93          	addi	s9,s9,1120 # 80008178 <etext+0x178>
			vmprint((pagetable_t)child,level + 1);
    80000d20:	001a0c1b          	addiw	s8,s4,1
	for (int i = 0;i < 512;i++)
    80000d24:	20000993          	li	s3,512
    80000d28:	a811                	j	80000d3c <vmprint+0x6a>
		buf = level3;
    80000d2a:	00007b97          	auipc	s7,0x7
    80000d2e:	43eb8b93          	addi	s7,s7,1086 # 80008168 <etext+0x168>
    80000d32:	b7cd                	j	80000d14 <vmprint+0x42>
	for (int i = 0;i < 512;i++)
    80000d34:	2905                	addiw	s2,s2,1 # 1001 <_entry-0x7fffefff>
    80000d36:	04a1                	addi	s1,s1,8
    80000d38:	03390a63          	beq	s2,s3,80000d6c <vmprint+0x9a>
		pte_t pte = pagetable[i];
    80000d3c:	6094                	ld	a3,0(s1)
		if ((pte & PTE_V) && level <= 3)
    80000d3e:	0016f793          	andi	a5,a3,1
    80000d42:	dbed                	beqz	a5,80000d34 <vmprint+0x62>
    80000d44:	ff4ac8e3          	blt	s5,s4,80000d34 <vmprint+0x62>
			uint64 child = PTE2PA(pte);
    80000d48:	00a6db13          	srli	s6,a3,0xa
    80000d4c:	0b32                	slli	s6,s6,0xc
			printf("%s%d: pte %p pa %p\n",buf,i,pte,child);
    80000d4e:	875a                	mv	a4,s6
    80000d50:	864a                	mv	a2,s2
    80000d52:	85de                	mv	a1,s7
    80000d54:	8566                	mv	a0,s9
    80000d56:	00005097          	auipc	ra,0x5
    80000d5a:	044080e7          	jalr	68(ra) # 80005d9a <printf>
			vmprint((pagetable_t)child,level + 1);
    80000d5e:	85e2                	mv	a1,s8
    80000d60:	855a                	mv	a0,s6
    80000d62:	00000097          	auipc	ra,0x0
    80000d66:	f70080e7          	jalr	-144(ra) # 80000cd2 <vmprint>
    80000d6a:	b7e9                	j	80000d34 <vmprint+0x62>
		}
	}
}
    80000d6c:	60e6                	ld	ra,88(sp)
    80000d6e:	6446                	ld	s0,80(sp)
    80000d70:	64a6                	ld	s1,72(sp)
    80000d72:	6906                	ld	s2,64(sp)
    80000d74:	79e2                	ld	s3,56(sp)
    80000d76:	7a42                	ld	s4,48(sp)
    80000d78:	7aa2                	ld	s5,40(sp)
    80000d7a:	7b02                	ld	s6,32(sp)
    80000d7c:	6be2                	ld	s7,24(sp)
    80000d7e:	6c42                	ld	s8,16(sp)
    80000d80:	6ca2                	ld	s9,8(sp)
    80000d82:	6125                	addi	sp,sp,96
    80000d84:	8082                	ret

0000000080000d86 <access_check>:



uint64 access_check(pagetable_t pagetable, uint64 va)
{
	if (va >= MAXVA)
    80000d86:	57fd                	li	a5,-1
    80000d88:	83e9                	srli	a5,a5,0x1a
    80000d8a:	00b7ee63          	bltu	a5,a1,80000da6 <access_check+0x20>
    80000d8e:	8e2a                	mv	t3,a0
    80000d90:	4881                	li	a7,0
    80000d92:	4501                	li	a0,0
	uint64 mask = 0;
    // 实验中给到最大的页面是32页
	for (int pages = 0; pages < 32; pages++,va += PGSIZE)
	{
		pte_t* pte = 0;
		pagetable_t p = pagetable;
    80000d94:	42f9                	li	t0,30
        // 仿照walk函数写的，获取L0级的PTE
		for (int level = 2; level >= 0; level--)
    80000d96:	430d                	li	t1,3
		{
			pte = &p[PX(level,va)];
			if (*pte & PTE_V)
				p = (pagetable_t)PTE2PA(*pte);
		}
		if (*pte & PTE_V && *pte & PTE_A)
    80000d98:	04100f93          	li	t6,65
		{
			mask |= (1L << pages);
    80000d9c:	4385                	li	t2,1
	for (int pages = 0; pages < 32; pages++,va += PGSIZE)
    80000d9e:	6f05                	lui	t5,0x1
    80000da0:	02000e93          	li	t4,32
    80000da4:	a0b9                	j	80000df2 <access_check+0x6c>
{
    80000da6:	1141                	addi	sp,sp,-16
    80000da8:	e406                	sd	ra,8(sp)
    80000daa:	e022                	sd	s0,0(sp)
    80000dac:	0800                	addi	s0,sp,16
		panic("walk");
    80000dae:	00007517          	auipc	a0,0x7
    80000db2:	2a250513          	addi	a0,a0,674 # 80008050 <etext+0x50>
    80000db6:	00005097          	auipc	ra,0x5
    80000dba:	f9a080e7          	jalr	-102(ra) # 80005d50 <panic>
		for (int level = 2; level >= 0; level--)
    80000dbe:	375d                	addiw	a4,a4,-9
    80000dc0:	02670163          	beq	a4,t1,80000de2 <access_check+0x5c>
			pte = &p[PX(level,va)];
    80000dc4:	00e5d7b3          	srl	a5,a1,a4
    80000dc8:	1ff7f793          	andi	a5,a5,511
    80000dcc:	078e                	slli	a5,a5,0x3
    80000dce:	97b2                	add	a5,a5,a2
			if (*pte & PTE_V)
    80000dd0:	6394                	ld	a3,0(a5)
    80000dd2:	0016f813          	andi	a6,a3,1
    80000dd6:	fe0804e3          	beqz	a6,80000dbe <access_check+0x38>
				p = (pagetable_t)PTE2PA(*pte);
    80000dda:	00a6d613          	srli	a2,a3,0xa
    80000dde:	0632                	slli	a2,a2,0xc
    80000de0:	bff9                	j	80000dbe <access_check+0x38>
		if (*pte & PTE_V && *pte & PTE_A)
    80000de2:	0416f713          	andi	a4,a3,65
    80000de6:	01f70963          	beq	a4,t6,80000df8 <access_check+0x72>
	for (int pages = 0; pages < 32; pages++,va += PGSIZE)
    80000dea:	2885                	addiw	a7,a7,1
    80000dec:	95fa                	add	a1,a1,t5
    80000dee:	01d88c63          	beq	a7,t4,80000e06 <access_check+0x80>
		pagetable_t p = pagetable;
    80000df2:	8672                	mv	a2,t3
    80000df4:	8716                	mv	a4,t0
    80000df6:	b7f9                	j	80000dc4 <access_check+0x3e>
			mask |= (1L << pages);
    80000df8:	01139733          	sll	a4,t2,a7
    80000dfc:	8d59                	or	a0,a0,a4
			*pte &= ~(PTE_A);
    80000dfe:	fbf6f693          	andi	a3,a3,-65
    80000e02:	e394                	sd	a3,0(a5)
    80000e04:	b7dd                	j	80000dea <access_check+0x64>
		}
	}
	return mask;	
}
    80000e06:	8082                	ret

0000000080000e08 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e08:	7139                	addi	sp,sp,-64
    80000e0a:	fc06                	sd	ra,56(sp)
    80000e0c:	f822                	sd	s0,48(sp)
    80000e0e:	f426                	sd	s1,40(sp)
    80000e10:	f04a                	sd	s2,32(sp)
    80000e12:	ec4e                	sd	s3,24(sp)
    80000e14:	e852                	sd	s4,16(sp)
    80000e16:	e456                	sd	s5,8(sp)
    80000e18:	e05a                	sd	s6,0(sp)
    80000e1a:	0080                	addi	s0,sp,64
    80000e1c:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1e:	00008497          	auipc	s1,0x8
    80000e22:	66248493          	addi	s1,s1,1634 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e26:	8b26                	mv	s6,s1
    80000e28:	00007a97          	auipc	s5,0x7
    80000e2c:	1d8a8a93          	addi	s5,s5,472 # 80008000 <etext>
    80000e30:	01000937          	lui	s2,0x1000
    80000e34:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000e36:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e38:	0000ea17          	auipc	s4,0xe
    80000e3c:	248a0a13          	addi	s4,s4,584 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000e40:	fffff097          	auipc	ra,0xfffff
    80000e44:	2da080e7          	jalr	730(ra) # 8000011a <kalloc>
    80000e48:	862a                	mv	a2,a0
    if(pa == 0)
    80000e4a:	c129                	beqz	a0,80000e8c <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e4c:	416485b3          	sub	a1,s1,s6
    80000e50:	8591                	srai	a1,a1,0x4
    80000e52:	000ab783          	ld	a5,0(s5)
    80000e56:	02f585b3          	mul	a1,a1,a5
    80000e5a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e5e:	4719                	li	a4,6
    80000e60:	6685                	lui	a3,0x1
    80000e62:	40b905b3          	sub	a1,s2,a1
    80000e66:	854e                	mv	a0,s3
    80000e68:	fffff097          	auipc	ra,0xfffff
    80000e6c:	77a080e7          	jalr	1914(ra) # 800005e2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e70:	17048493          	addi	s1,s1,368
    80000e74:	fd4496e3          	bne	s1,s4,80000e40 <proc_mapstacks+0x38>
  }
}
    80000e78:	70e2                	ld	ra,56(sp)
    80000e7a:	7442                	ld	s0,48(sp)
    80000e7c:	74a2                	ld	s1,40(sp)
    80000e7e:	7902                	ld	s2,32(sp)
    80000e80:	69e2                	ld	s3,24(sp)
    80000e82:	6a42                	ld	s4,16(sp)
    80000e84:	6aa2                	ld	s5,8(sp)
    80000e86:	6b02                	ld	s6,0(sp)
    80000e88:	6121                	addi	sp,sp,64
    80000e8a:	8082                	ret
      panic("kalloc");
    80000e8c:	00007517          	auipc	a0,0x7
    80000e90:	30450513          	addi	a0,a0,772 # 80008190 <etext+0x190>
    80000e94:	00005097          	auipc	ra,0x5
    80000e98:	ebc080e7          	jalr	-324(ra) # 80005d50 <panic>

0000000080000e9c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e9c:	7139                	addi	sp,sp,-64
    80000e9e:	fc06                	sd	ra,56(sp)
    80000ea0:	f822                	sd	s0,48(sp)
    80000ea2:	f426                	sd	s1,40(sp)
    80000ea4:	f04a                	sd	s2,32(sp)
    80000ea6:	ec4e                	sd	s3,24(sp)
    80000ea8:	e852                	sd	s4,16(sp)
    80000eaa:	e456                	sd	s5,8(sp)
    80000eac:	e05a                	sd	s6,0(sp)
    80000eae:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000eb0:	00007597          	auipc	a1,0x7
    80000eb4:	2e858593          	addi	a1,a1,744 # 80008198 <etext+0x198>
    80000eb8:	00008517          	auipc	a0,0x8
    80000ebc:	19850513          	addi	a0,a0,408 # 80009050 <pid_lock>
    80000ec0:	00005097          	auipc	ra,0x5
    80000ec4:	338080e7          	jalr	824(ra) # 800061f8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ec8:	00007597          	auipc	a1,0x7
    80000ecc:	2d858593          	addi	a1,a1,728 # 800081a0 <etext+0x1a0>
    80000ed0:	00008517          	auipc	a0,0x8
    80000ed4:	19850513          	addi	a0,a0,408 # 80009068 <wait_lock>
    80000ed8:	00005097          	auipc	ra,0x5
    80000edc:	320080e7          	jalr	800(ra) # 800061f8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee0:	00008497          	auipc	s1,0x8
    80000ee4:	5a048493          	addi	s1,s1,1440 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000ee8:	00007b17          	auipc	s6,0x7
    80000eec:	2c8b0b13          	addi	s6,s6,712 # 800081b0 <etext+0x1b0>
      p->kstack = KSTACK((int) (p - proc));
    80000ef0:	8aa6                	mv	s5,s1
    80000ef2:	00007a17          	auipc	s4,0x7
    80000ef6:	10ea0a13          	addi	s4,s4,270 # 80008000 <etext>
    80000efa:	01000937          	lui	s2,0x1000
    80000efe:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000f00:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f02:	0000e997          	auipc	s3,0xe
    80000f06:	17e98993          	addi	s3,s3,382 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000f0a:	85da                	mv	a1,s6
    80000f0c:	8526                	mv	a0,s1
    80000f0e:	00005097          	auipc	ra,0x5
    80000f12:	2ea080e7          	jalr	746(ra) # 800061f8 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f16:	415487b3          	sub	a5,s1,s5
    80000f1a:	8791                	srai	a5,a5,0x4
    80000f1c:	000a3703          	ld	a4,0(s4)
    80000f20:	02e787b3          	mul	a5,a5,a4
    80000f24:	00d7979b          	slliw	a5,a5,0xd
    80000f28:	40f907b3          	sub	a5,s2,a5
    80000f2c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f2e:	17048493          	addi	s1,s1,368
    80000f32:	fd349ce3          	bne	s1,s3,80000f0a <procinit+0x6e>
  }
}
    80000f36:	70e2                	ld	ra,56(sp)
    80000f38:	7442                	ld	s0,48(sp)
    80000f3a:	74a2                	ld	s1,40(sp)
    80000f3c:	7902                	ld	s2,32(sp)
    80000f3e:	69e2                	ld	s3,24(sp)
    80000f40:	6a42                	ld	s4,16(sp)
    80000f42:	6aa2                	ld	s5,8(sp)
    80000f44:	6b02                	ld	s6,0(sp)
    80000f46:	6121                	addi	sp,sp,64
    80000f48:	8082                	ret

0000000080000f4a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f4a:	1141                	addi	sp,sp,-16
    80000f4c:	e422                	sd	s0,8(sp)
    80000f4e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f50:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f52:	2501                	sext.w	a0,a0
    80000f54:	6422                	ld	s0,8(sp)
    80000f56:	0141                	addi	sp,sp,16
    80000f58:	8082                	ret

0000000080000f5a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f5a:	1141                	addi	sp,sp,-16
    80000f5c:	e422                	sd	s0,8(sp)
    80000f5e:	0800                	addi	s0,sp,16
    80000f60:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f62:	2781                	sext.w	a5,a5
    80000f64:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f66:	00008517          	auipc	a0,0x8
    80000f6a:	11a50513          	addi	a0,a0,282 # 80009080 <cpus>
    80000f6e:	953e                	add	a0,a0,a5
    80000f70:	6422                	ld	s0,8(sp)
    80000f72:	0141                	addi	sp,sp,16
    80000f74:	8082                	ret

0000000080000f76 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f76:	1101                	addi	sp,sp,-32
    80000f78:	ec06                	sd	ra,24(sp)
    80000f7a:	e822                	sd	s0,16(sp)
    80000f7c:	e426                	sd	s1,8(sp)
    80000f7e:	1000                	addi	s0,sp,32
  push_off();
    80000f80:	00005097          	auipc	ra,0x5
    80000f84:	2bc080e7          	jalr	700(ra) # 8000623c <push_off>
    80000f88:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f8a:	2781                	sext.w	a5,a5
    80000f8c:	079e                	slli	a5,a5,0x7
    80000f8e:	00008717          	auipc	a4,0x8
    80000f92:	0c270713          	addi	a4,a4,194 # 80009050 <pid_lock>
    80000f96:	97ba                	add	a5,a5,a4
    80000f98:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f9a:	00005097          	auipc	ra,0x5
    80000f9e:	342080e7          	jalr	834(ra) # 800062dc <pop_off>
  return p;
}
    80000fa2:	8526                	mv	a0,s1
    80000fa4:	60e2                	ld	ra,24(sp)
    80000fa6:	6442                	ld	s0,16(sp)
    80000fa8:	64a2                	ld	s1,8(sp)
    80000faa:	6105                	addi	sp,sp,32
    80000fac:	8082                	ret

0000000080000fae <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fae:	1141                	addi	sp,sp,-16
    80000fb0:	e406                	sd	ra,8(sp)
    80000fb2:	e022                	sd	s0,0(sp)
    80000fb4:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fb6:	00000097          	auipc	ra,0x0
    80000fba:	fc0080e7          	jalr	-64(ra) # 80000f76 <myproc>
    80000fbe:	00005097          	auipc	ra,0x5
    80000fc2:	37e080e7          	jalr	894(ra) # 8000633c <release>

  if (first) {
    80000fc6:	00008797          	auipc	a5,0x8
    80000fca:	8da7a783          	lw	a5,-1830(a5) # 800088a0 <first.1>
    80000fce:	eb89                	bnez	a5,80000fe0 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fd0:	00001097          	auipc	ra,0x1
    80000fd4:	c9e080e7          	jalr	-866(ra) # 80001c6e <usertrapret>
}
    80000fd8:	60a2                	ld	ra,8(sp)
    80000fda:	6402                	ld	s0,0(sp)
    80000fdc:	0141                	addi	sp,sp,16
    80000fde:	8082                	ret
    first = 0;
    80000fe0:	00008797          	auipc	a5,0x8
    80000fe4:	8c07a023          	sw	zero,-1856(a5) # 800088a0 <first.1>
    fsinit(ROOTDEV);
    80000fe8:	4505                	li	a0,1
    80000fea:	00002097          	auipc	ra,0x2
    80000fee:	a4e080e7          	jalr	-1458(ra) # 80002a38 <fsinit>
    80000ff2:	bff9                	j	80000fd0 <forkret+0x22>

0000000080000ff4 <allocpid>:
allocpid() {
    80000ff4:	1101                	addi	sp,sp,-32
    80000ff6:	ec06                	sd	ra,24(sp)
    80000ff8:	e822                	sd	s0,16(sp)
    80000ffa:	e426                	sd	s1,8(sp)
    80000ffc:	e04a                	sd	s2,0(sp)
    80000ffe:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001000:	00008917          	auipc	s2,0x8
    80001004:	05090913          	addi	s2,s2,80 # 80009050 <pid_lock>
    80001008:	854a                	mv	a0,s2
    8000100a:	00005097          	auipc	ra,0x5
    8000100e:	27e080e7          	jalr	638(ra) # 80006288 <acquire>
  pid = nextpid;
    80001012:	00008797          	auipc	a5,0x8
    80001016:	89278793          	addi	a5,a5,-1902 # 800088a4 <nextpid>
    8000101a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000101c:	0014871b          	addiw	a4,s1,1
    80001020:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001022:	854a                	mv	a0,s2
    80001024:	00005097          	auipc	ra,0x5
    80001028:	318080e7          	jalr	792(ra) # 8000633c <release>
}
    8000102c:	8526                	mv	a0,s1
    8000102e:	60e2                	ld	ra,24(sp)
    80001030:	6442                	ld	s0,16(sp)
    80001032:	64a2                	ld	s1,8(sp)
    80001034:	6902                	ld	s2,0(sp)
    80001036:	6105                	addi	sp,sp,32
    80001038:	8082                	ret

000000008000103a <proc_pagetable>:
{
    8000103a:	1101                	addi	sp,sp,-32
    8000103c:	ec06                	sd	ra,24(sp)
    8000103e:	e822                	sd	s0,16(sp)
    80001040:	e426                	sd	s1,8(sp)
    80001042:	e04a                	sd	s2,0(sp)
    80001044:	1000                	addi	s0,sp,32
    80001046:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001048:	fffff097          	auipc	ra,0xfffff
    8000104c:	784080e7          	jalr	1924(ra) # 800007cc <uvmcreate>
    80001050:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001052:	cd39                	beqz	a0,800010b0 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001054:	4729                	li	a4,10
    80001056:	00006697          	auipc	a3,0x6
    8000105a:	faa68693          	addi	a3,a3,-86 # 80007000 <_trampoline>
    8000105e:	6605                	lui	a2,0x1
    80001060:	040005b7          	lui	a1,0x4000
    80001064:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001066:	05b2                	slli	a1,a1,0xc
    80001068:	fffff097          	auipc	ra,0xfffff
    8000106c:	4da080e7          	jalr	1242(ra) # 80000542 <mappages>
    80001070:	04054763          	bltz	a0,800010be <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001074:	4719                	li	a4,6
    80001076:	05893683          	ld	a3,88(s2)
    8000107a:	6605                	lui	a2,0x1
    8000107c:	020005b7          	lui	a1,0x2000
    80001080:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001082:	05b6                	slli	a1,a1,0xd
    80001084:	8526                	mv	a0,s1
    80001086:	fffff097          	auipc	ra,0xfffff
    8000108a:	4bc080e7          	jalr	1212(ra) # 80000542 <mappages>
    8000108e:	04054063          	bltz	a0,800010ce <proc_pagetable+0x94>
  if (mappages(pagetable,USYSCALL,PGSIZE,(uint64)(p->ucall),
    80001092:	4749                	li	a4,18
    80001094:	16893683          	ld	a3,360(s2)
    80001098:	6605                	lui	a2,0x1
    8000109a:	040005b7          	lui	a1,0x4000
    8000109e:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    800010a0:	05b2                	slli	a1,a1,0xc
    800010a2:	8526                	mv	a0,s1
    800010a4:	fffff097          	auipc	ra,0xfffff
    800010a8:	49e080e7          	jalr	1182(ra) # 80000542 <mappages>
    800010ac:	04054463          	bltz	a0,800010f4 <proc_pagetable+0xba>
}
    800010b0:	8526                	mv	a0,s1
    800010b2:	60e2                	ld	ra,24(sp)
    800010b4:	6442                	ld	s0,16(sp)
    800010b6:	64a2                	ld	s1,8(sp)
    800010b8:	6902                	ld	s2,0(sp)
    800010ba:	6105                	addi	sp,sp,32
    800010bc:	8082                	ret
    uvmfree(pagetable, 0);
    800010be:	4581                	li	a1,0
    800010c0:	8526                	mv	a0,s1
    800010c2:	00000097          	auipc	ra,0x0
    800010c6:	908080e7          	jalr	-1784(ra) # 800009ca <uvmfree>
    return 0;
    800010ca:	4481                	li	s1,0
    800010cc:	b7d5                	j	800010b0 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010ce:	4681                	li	a3,0
    800010d0:	4605                	li	a2,1
    800010d2:	040005b7          	lui	a1,0x4000
    800010d6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010d8:	05b2                	slli	a1,a1,0xc
    800010da:	8526                	mv	a0,s1
    800010dc:	fffff097          	auipc	ra,0xfffff
    800010e0:	62c080e7          	jalr	1580(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    800010e4:	4581                	li	a1,0
    800010e6:	8526                	mv	a0,s1
    800010e8:	00000097          	auipc	ra,0x0
    800010ec:	8e2080e7          	jalr	-1822(ra) # 800009ca <uvmfree>
    return 0;
    800010f0:	4481                	li	s1,0
    800010f2:	bf7d                	j	800010b0 <proc_pagetable+0x76>
	  uvmfree(pagetable,0);
    800010f4:	4581                	li	a1,0
    800010f6:	8526                	mv	a0,s1
    800010f8:	00000097          	auipc	ra,0x0
    800010fc:	8d2080e7          	jalr	-1838(ra) # 800009ca <uvmfree>
	  return 0;
    80001100:	4481                	li	s1,0
    80001102:	b77d                	j	800010b0 <proc_pagetable+0x76>

0000000080001104 <proc_freepagetable>:
{
    80001104:	7179                	addi	sp,sp,-48
    80001106:	f406                	sd	ra,40(sp)
    80001108:	f022                	sd	s0,32(sp)
    8000110a:	ec26                	sd	s1,24(sp)
    8000110c:	e84a                	sd	s2,16(sp)
    8000110e:	e44e                	sd	s3,8(sp)
    80001110:	1800                	addi	s0,sp,48
    80001112:	84aa                	mv	s1,a0
    80001114:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001116:	4681                	li	a3,0
    80001118:	4605                	li	a2,1
    8000111a:	04000937          	lui	s2,0x4000
    8000111e:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001122:	05b2                	slli	a1,a1,0xc
    80001124:	fffff097          	auipc	ra,0xfffff
    80001128:	5e4080e7          	jalr	1508(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000112c:	4681                	li	a3,0
    8000112e:	4605                	li	a2,1
    80001130:	020005b7          	lui	a1,0x2000
    80001134:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001136:	05b6                	slli	a1,a1,0xd
    80001138:	8526                	mv	a0,s1
    8000113a:	fffff097          	auipc	ra,0xfffff
    8000113e:	5ce080e7          	jalr	1486(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    80001142:	4681                	li	a3,0
    80001144:	4605                	li	a2,1
    80001146:	1975                	addi	s2,s2,-3
    80001148:	00c91593          	slli	a1,s2,0xc
    8000114c:	8526                	mv	a0,s1
    8000114e:	fffff097          	auipc	ra,0xfffff
    80001152:	5ba080e7          	jalr	1466(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    80001156:	85ce                	mv	a1,s3
    80001158:	8526                	mv	a0,s1
    8000115a:	00000097          	auipc	ra,0x0
    8000115e:	870080e7          	jalr	-1936(ra) # 800009ca <uvmfree>
}
    80001162:	70a2                	ld	ra,40(sp)
    80001164:	7402                	ld	s0,32(sp)
    80001166:	64e2                	ld	s1,24(sp)
    80001168:	6942                	ld	s2,16(sp)
    8000116a:	69a2                	ld	s3,8(sp)
    8000116c:	6145                	addi	sp,sp,48
    8000116e:	8082                	ret

0000000080001170 <freeproc>:
{
    80001170:	1101                	addi	sp,sp,-32
    80001172:	ec06                	sd	ra,24(sp)
    80001174:	e822                	sd	s0,16(sp)
    80001176:	e426                	sd	s1,8(sp)
    80001178:	1000                	addi	s0,sp,32
    8000117a:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000117c:	6d28                	ld	a0,88(a0)
    8000117e:	c509                	beqz	a0,80001188 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001180:	fffff097          	auipc	ra,0xfffff
    80001184:	e9c080e7          	jalr	-356(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001188:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000118c:	68a8                	ld	a0,80(s1)
    8000118e:	c511                	beqz	a0,8000119a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001190:	64ac                	ld	a1,72(s1)
    80001192:	00000097          	auipc	ra,0x0
    80001196:	f72080e7          	jalr	-142(ra) # 80001104 <proc_freepagetable>
  if (p->ucall)
    8000119a:	1684b503          	ld	a0,360(s1)
    8000119e:	c509                	beqz	a0,800011a8 <freeproc+0x38>
	  kfree((void*)p->ucall);
    800011a0:	fffff097          	auipc	ra,0xfffff
    800011a4:	e7c080e7          	jalr	-388(ra) # 8000001c <kfree>
  p->ucall = 0;
    800011a8:	1604b423          	sd	zero,360(s1)
  p->pagetable = 0;
    800011ac:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011b0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011b4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011b8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011bc:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800011c0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011c4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011c8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011cc:	0004ac23          	sw	zero,24(s1)
}
    800011d0:	60e2                	ld	ra,24(sp)
    800011d2:	6442                	ld	s0,16(sp)
    800011d4:	64a2                	ld	s1,8(sp)
    800011d6:	6105                	addi	sp,sp,32
    800011d8:	8082                	ret

00000000800011da <allocproc>:
{
    800011da:	1101                	addi	sp,sp,-32
    800011dc:	ec06                	sd	ra,24(sp)
    800011de:	e822                	sd	s0,16(sp)
    800011e0:	e426                	sd	s1,8(sp)
    800011e2:	e04a                	sd	s2,0(sp)
    800011e4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011e6:	00008497          	auipc	s1,0x8
    800011ea:	29a48493          	addi	s1,s1,666 # 80009480 <proc>
    800011ee:	0000e917          	auipc	s2,0xe
    800011f2:	e9290913          	addi	s2,s2,-366 # 8000f080 <tickslock>
    acquire(&p->lock);
    800011f6:	8526                	mv	a0,s1
    800011f8:	00005097          	auipc	ra,0x5
    800011fc:	090080e7          	jalr	144(ra) # 80006288 <acquire>
    if(p->state == UNUSED) {
    80001200:	4c9c                	lw	a5,24(s1)
    80001202:	cf81                	beqz	a5,8000121a <allocproc+0x40>
      release(&p->lock);
    80001204:	8526                	mv	a0,s1
    80001206:	00005097          	auipc	ra,0x5
    8000120a:	136080e7          	jalr	310(ra) # 8000633c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000120e:	17048493          	addi	s1,s1,368
    80001212:	ff2492e3          	bne	s1,s2,800011f6 <allocproc+0x1c>
  return 0;
    80001216:	4481                	li	s1,0
    80001218:	a0ad                	j	80001282 <allocproc+0xa8>
  p->pid = allocpid();
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	dda080e7          	jalr	-550(ra) # 80000ff4 <allocpid>
    80001222:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001224:	4785                	li	a5,1
    80001226:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001228:	fffff097          	auipc	ra,0xfffff
    8000122c:	ef2080e7          	jalr	-270(ra) # 8000011a <kalloc>
    80001230:	892a                	mv	s2,a0
    80001232:	eca8                	sd	a0,88(s1)
    80001234:	cd31                	beqz	a0,80001290 <allocproc+0xb6>
  if (0 == (p->ucall = (struct usyscall*)kalloc()))
    80001236:	fffff097          	auipc	ra,0xfffff
    8000123a:	ee4080e7          	jalr	-284(ra) # 8000011a <kalloc>
    8000123e:	892a                	mv	s2,a0
    80001240:	16a4b423          	sd	a0,360(s1)
    80001244:	c135                	beqz	a0,800012a8 <allocproc+0xce>
  p->pagetable = proc_pagetable(p);
    80001246:	8526                	mv	a0,s1
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	df2080e7          	jalr	-526(ra) # 8000103a <proc_pagetable>
    80001250:	892a                	mv	s2,a0
    80001252:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001254:	c535                	beqz	a0,800012c0 <allocproc+0xe6>
  memset(&p->context, 0, sizeof(p->context));
    80001256:	07000613          	li	a2,112
    8000125a:	4581                	li	a1,0
    8000125c:	06048513          	addi	a0,s1,96
    80001260:	fffff097          	auipc	ra,0xfffff
    80001264:	f1a080e7          	jalr	-230(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001268:	00000797          	auipc	a5,0x0
    8000126c:	d4678793          	addi	a5,a5,-698 # 80000fae <forkret>
    80001270:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001272:	60bc                	ld	a5,64(s1)
    80001274:	6705                	lui	a4,0x1
    80001276:	97ba                	add	a5,a5,a4
    80001278:	f4bc                	sd	a5,104(s1)
  p->ucall->pid = p->pid;
    8000127a:	1684b783          	ld	a5,360(s1)
    8000127e:	5898                	lw	a4,48(s1)
    80001280:	c398                	sw	a4,0(a5)
}
    80001282:	8526                	mv	a0,s1
    80001284:	60e2                	ld	ra,24(sp)
    80001286:	6442                	ld	s0,16(sp)
    80001288:	64a2                	ld	s1,8(sp)
    8000128a:	6902                	ld	s2,0(sp)
    8000128c:	6105                	addi	sp,sp,32
    8000128e:	8082                	ret
    freeproc(p);
    80001290:	8526                	mv	a0,s1
    80001292:	00000097          	auipc	ra,0x0
    80001296:	ede080e7          	jalr	-290(ra) # 80001170 <freeproc>
    release(&p->lock);
    8000129a:	8526                	mv	a0,s1
    8000129c:	00005097          	auipc	ra,0x5
    800012a0:	0a0080e7          	jalr	160(ra) # 8000633c <release>
    return 0;
    800012a4:	84ca                	mv	s1,s2
    800012a6:	bff1                	j	80001282 <allocproc+0xa8>
	  freeproc(p);
    800012a8:	8526                	mv	a0,s1
    800012aa:	00000097          	auipc	ra,0x0
    800012ae:	ec6080e7          	jalr	-314(ra) # 80001170 <freeproc>
	  release(&p->lock);
    800012b2:	8526                	mv	a0,s1
    800012b4:	00005097          	auipc	ra,0x5
    800012b8:	088080e7          	jalr	136(ra) # 8000633c <release>
	  return 0;
    800012bc:	84ca                	mv	s1,s2
    800012be:	b7d1                	j	80001282 <allocproc+0xa8>
    freeproc(p);
    800012c0:	8526                	mv	a0,s1
    800012c2:	00000097          	auipc	ra,0x0
    800012c6:	eae080e7          	jalr	-338(ra) # 80001170 <freeproc>
    release(&p->lock);
    800012ca:	8526                	mv	a0,s1
    800012cc:	00005097          	auipc	ra,0x5
    800012d0:	070080e7          	jalr	112(ra) # 8000633c <release>
    return 0;
    800012d4:	84ca                	mv	s1,s2
    800012d6:	b775                	j	80001282 <allocproc+0xa8>

00000000800012d8 <userinit>:
{
    800012d8:	1101                	addi	sp,sp,-32
    800012da:	ec06                	sd	ra,24(sp)
    800012dc:	e822                	sd	s0,16(sp)
    800012de:	e426                	sd	s1,8(sp)
    800012e0:	1000                	addi	s0,sp,32
  p = allocproc();
    800012e2:	00000097          	auipc	ra,0x0
    800012e6:	ef8080e7          	jalr	-264(ra) # 800011da <allocproc>
    800012ea:	84aa                	mv	s1,a0
  initproc = p;
    800012ec:	00008797          	auipc	a5,0x8
    800012f0:	d2a7b223          	sd	a0,-732(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012f4:	03400613          	li	a2,52
    800012f8:	00007597          	auipc	a1,0x7
    800012fc:	5b858593          	addi	a1,a1,1464 # 800088b0 <initcode>
    80001300:	6928                	ld	a0,80(a0)
    80001302:	fffff097          	auipc	ra,0xfffff
    80001306:	4f8080e7          	jalr	1272(ra) # 800007fa <uvminit>
  p->sz = PGSIZE;
    8000130a:	6785                	lui	a5,0x1
    8000130c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000130e:	6cb8                	ld	a4,88(s1)
    80001310:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001314:	6cb8                	ld	a4,88(s1)
    80001316:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001318:	4641                	li	a2,16
    8000131a:	00007597          	auipc	a1,0x7
    8000131e:	e9e58593          	addi	a1,a1,-354 # 800081b8 <etext+0x1b8>
    80001322:	15848513          	addi	a0,s1,344
    80001326:	fffff097          	auipc	ra,0xfffff
    8000132a:	f9e080e7          	jalr	-98(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    8000132e:	00007517          	auipc	a0,0x7
    80001332:	e9a50513          	addi	a0,a0,-358 # 800081c8 <etext+0x1c8>
    80001336:	00002097          	auipc	ra,0x2
    8000133a:	138080e7          	jalr	312(ra) # 8000346e <namei>
    8000133e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001342:	478d                	li	a5,3
    80001344:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001346:	8526                	mv	a0,s1
    80001348:	00005097          	auipc	ra,0x5
    8000134c:	ff4080e7          	jalr	-12(ra) # 8000633c <release>
}
    80001350:	60e2                	ld	ra,24(sp)
    80001352:	6442                	ld	s0,16(sp)
    80001354:	64a2                	ld	s1,8(sp)
    80001356:	6105                	addi	sp,sp,32
    80001358:	8082                	ret

000000008000135a <growproc>:
{
    8000135a:	1101                	addi	sp,sp,-32
    8000135c:	ec06                	sd	ra,24(sp)
    8000135e:	e822                	sd	s0,16(sp)
    80001360:	e426                	sd	s1,8(sp)
    80001362:	e04a                	sd	s2,0(sp)
    80001364:	1000                	addi	s0,sp,32
    80001366:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001368:	00000097          	auipc	ra,0x0
    8000136c:	c0e080e7          	jalr	-1010(ra) # 80000f76 <myproc>
    80001370:	892a                	mv	s2,a0
  sz = p->sz;
    80001372:	652c                	ld	a1,72(a0)
    80001374:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001378:	00904f63          	bgtz	s1,80001396 <growproc+0x3c>
  } else if(n < 0){
    8000137c:	0204cd63          	bltz	s1,800013b6 <growproc+0x5c>
  p->sz = sz;
    80001380:	1782                	slli	a5,a5,0x20
    80001382:	9381                	srli	a5,a5,0x20
    80001384:	04f93423          	sd	a5,72(s2)
  return 0;
    80001388:	4501                	li	a0,0
}
    8000138a:	60e2                	ld	ra,24(sp)
    8000138c:	6442                	ld	s0,16(sp)
    8000138e:	64a2                	ld	s1,8(sp)
    80001390:	6902                	ld	s2,0(sp)
    80001392:	6105                	addi	sp,sp,32
    80001394:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001396:	00f4863b          	addw	a2,s1,a5
    8000139a:	1602                	slli	a2,a2,0x20
    8000139c:	9201                	srli	a2,a2,0x20
    8000139e:	1582                	slli	a1,a1,0x20
    800013a0:	9181                	srli	a1,a1,0x20
    800013a2:	6928                	ld	a0,80(a0)
    800013a4:	fffff097          	auipc	ra,0xfffff
    800013a8:	510080e7          	jalr	1296(ra) # 800008b4 <uvmalloc>
    800013ac:	0005079b          	sext.w	a5,a0
    800013b0:	fbe1                	bnez	a5,80001380 <growproc+0x26>
      return -1;
    800013b2:	557d                	li	a0,-1
    800013b4:	bfd9                	j	8000138a <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013b6:	00f4863b          	addw	a2,s1,a5
    800013ba:	1602                	slli	a2,a2,0x20
    800013bc:	9201                	srli	a2,a2,0x20
    800013be:	1582                	slli	a1,a1,0x20
    800013c0:	9181                	srli	a1,a1,0x20
    800013c2:	6928                	ld	a0,80(a0)
    800013c4:	fffff097          	auipc	ra,0xfffff
    800013c8:	4a8080e7          	jalr	1192(ra) # 8000086c <uvmdealloc>
    800013cc:	0005079b          	sext.w	a5,a0
    800013d0:	bf45                	j	80001380 <growproc+0x26>

00000000800013d2 <fork>:
{
    800013d2:	7139                	addi	sp,sp,-64
    800013d4:	fc06                	sd	ra,56(sp)
    800013d6:	f822                	sd	s0,48(sp)
    800013d8:	f426                	sd	s1,40(sp)
    800013da:	f04a                	sd	s2,32(sp)
    800013dc:	ec4e                	sd	s3,24(sp)
    800013de:	e852                	sd	s4,16(sp)
    800013e0:	e456                	sd	s5,8(sp)
    800013e2:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800013e4:	00000097          	auipc	ra,0x0
    800013e8:	b92080e7          	jalr	-1134(ra) # 80000f76 <myproc>
    800013ec:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800013ee:	00000097          	auipc	ra,0x0
    800013f2:	dec080e7          	jalr	-532(ra) # 800011da <allocproc>
    800013f6:	10050c63          	beqz	a0,8000150e <fork+0x13c>
    800013fa:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013fc:	048ab603          	ld	a2,72(s5)
    80001400:	692c                	ld	a1,80(a0)
    80001402:	050ab503          	ld	a0,80(s5)
    80001406:	fffff097          	auipc	ra,0xfffff
    8000140a:	5fe080e7          	jalr	1534(ra) # 80000a04 <uvmcopy>
    8000140e:	04054863          	bltz	a0,8000145e <fork+0x8c>
  np->sz = p->sz;
    80001412:	048ab783          	ld	a5,72(s5)
    80001416:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000141a:	058ab683          	ld	a3,88(s5)
    8000141e:	87b6                	mv	a5,a3
    80001420:	058a3703          	ld	a4,88(s4)
    80001424:	12068693          	addi	a3,a3,288
    80001428:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000142c:	6788                	ld	a0,8(a5)
    8000142e:	6b8c                	ld	a1,16(a5)
    80001430:	6f90                	ld	a2,24(a5)
    80001432:	01073023          	sd	a6,0(a4)
    80001436:	e708                	sd	a0,8(a4)
    80001438:	eb0c                	sd	a1,16(a4)
    8000143a:	ef10                	sd	a2,24(a4)
    8000143c:	02078793          	addi	a5,a5,32
    80001440:	02070713          	addi	a4,a4,32
    80001444:	fed792e3          	bne	a5,a3,80001428 <fork+0x56>
  np->trapframe->a0 = 0;
    80001448:	058a3783          	ld	a5,88(s4)
    8000144c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001450:	0d0a8493          	addi	s1,s5,208
    80001454:	0d0a0913          	addi	s2,s4,208
    80001458:	150a8993          	addi	s3,s5,336
    8000145c:	a00d                	j	8000147e <fork+0xac>
    freeproc(np);
    8000145e:	8552                	mv	a0,s4
    80001460:	00000097          	auipc	ra,0x0
    80001464:	d10080e7          	jalr	-752(ra) # 80001170 <freeproc>
    release(&np->lock);
    80001468:	8552                	mv	a0,s4
    8000146a:	00005097          	auipc	ra,0x5
    8000146e:	ed2080e7          	jalr	-302(ra) # 8000633c <release>
    return -1;
    80001472:	597d                	li	s2,-1
    80001474:	a059                	j	800014fa <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001476:	04a1                	addi	s1,s1,8
    80001478:	0921                	addi	s2,s2,8
    8000147a:	01348b63          	beq	s1,s3,80001490 <fork+0xbe>
    if(p->ofile[i])
    8000147e:	6088                	ld	a0,0(s1)
    80001480:	d97d                	beqz	a0,80001476 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001482:	00002097          	auipc	ra,0x2
    80001486:	682080e7          	jalr	1666(ra) # 80003b04 <filedup>
    8000148a:	00a93023          	sd	a0,0(s2)
    8000148e:	b7e5                	j	80001476 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001490:	150ab503          	ld	a0,336(s5)
    80001494:	00001097          	auipc	ra,0x1
    80001498:	7e0080e7          	jalr	2016(ra) # 80002c74 <idup>
    8000149c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014a0:	4641                	li	a2,16
    800014a2:	158a8593          	addi	a1,s5,344
    800014a6:	158a0513          	addi	a0,s4,344
    800014aa:	fffff097          	auipc	ra,0xfffff
    800014ae:	e1a080e7          	jalr	-486(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    800014b2:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800014b6:	8552                	mv	a0,s4
    800014b8:	00005097          	auipc	ra,0x5
    800014bc:	e84080e7          	jalr	-380(ra) # 8000633c <release>
  acquire(&wait_lock);
    800014c0:	00008497          	auipc	s1,0x8
    800014c4:	ba848493          	addi	s1,s1,-1112 # 80009068 <wait_lock>
    800014c8:	8526                	mv	a0,s1
    800014ca:	00005097          	auipc	ra,0x5
    800014ce:	dbe080e7          	jalr	-578(ra) # 80006288 <acquire>
  np->parent = p;
    800014d2:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800014d6:	8526                	mv	a0,s1
    800014d8:	00005097          	auipc	ra,0x5
    800014dc:	e64080e7          	jalr	-412(ra) # 8000633c <release>
  acquire(&np->lock);
    800014e0:	8552                	mv	a0,s4
    800014e2:	00005097          	auipc	ra,0x5
    800014e6:	da6080e7          	jalr	-602(ra) # 80006288 <acquire>
  np->state = RUNNABLE;
    800014ea:	478d                	li	a5,3
    800014ec:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800014f0:	8552                	mv	a0,s4
    800014f2:	00005097          	auipc	ra,0x5
    800014f6:	e4a080e7          	jalr	-438(ra) # 8000633c <release>
}
    800014fa:	854a                	mv	a0,s2
    800014fc:	70e2                	ld	ra,56(sp)
    800014fe:	7442                	ld	s0,48(sp)
    80001500:	74a2                	ld	s1,40(sp)
    80001502:	7902                	ld	s2,32(sp)
    80001504:	69e2                	ld	s3,24(sp)
    80001506:	6a42                	ld	s4,16(sp)
    80001508:	6aa2                	ld	s5,8(sp)
    8000150a:	6121                	addi	sp,sp,64
    8000150c:	8082                	ret
    return -1;
    8000150e:	597d                	li	s2,-1
    80001510:	b7ed                	j	800014fa <fork+0x128>

0000000080001512 <scheduler>:
{
    80001512:	7139                	addi	sp,sp,-64
    80001514:	fc06                	sd	ra,56(sp)
    80001516:	f822                	sd	s0,48(sp)
    80001518:	f426                	sd	s1,40(sp)
    8000151a:	f04a                	sd	s2,32(sp)
    8000151c:	ec4e                	sd	s3,24(sp)
    8000151e:	e852                	sd	s4,16(sp)
    80001520:	e456                	sd	s5,8(sp)
    80001522:	e05a                	sd	s6,0(sp)
    80001524:	0080                	addi	s0,sp,64
    80001526:	8792                	mv	a5,tp
  int id = r_tp();
    80001528:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000152a:	00779a93          	slli	s5,a5,0x7
    8000152e:	00008717          	auipc	a4,0x8
    80001532:	b2270713          	addi	a4,a4,-1246 # 80009050 <pid_lock>
    80001536:	9756                	add	a4,a4,s5
    80001538:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000153c:	00008717          	auipc	a4,0x8
    80001540:	b4c70713          	addi	a4,a4,-1204 # 80009088 <cpus+0x8>
    80001544:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001546:	498d                	li	s3,3
        p->state = RUNNING;
    80001548:	4b11                	li	s6,4
        c->proc = p;
    8000154a:	079e                	slli	a5,a5,0x7
    8000154c:	00008a17          	auipc	s4,0x8
    80001550:	b04a0a13          	addi	s4,s4,-1276 # 80009050 <pid_lock>
    80001554:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001556:	0000e917          	auipc	s2,0xe
    8000155a:	b2a90913          	addi	s2,s2,-1238 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000155e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001562:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001566:	10079073          	csrw	sstatus,a5
    8000156a:	00008497          	auipc	s1,0x8
    8000156e:	f1648493          	addi	s1,s1,-234 # 80009480 <proc>
    80001572:	a811                	j	80001586 <scheduler+0x74>
      release(&p->lock);
    80001574:	8526                	mv	a0,s1
    80001576:	00005097          	auipc	ra,0x5
    8000157a:	dc6080e7          	jalr	-570(ra) # 8000633c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000157e:	17048493          	addi	s1,s1,368
    80001582:	fd248ee3          	beq	s1,s2,8000155e <scheduler+0x4c>
      acquire(&p->lock);
    80001586:	8526                	mv	a0,s1
    80001588:	00005097          	auipc	ra,0x5
    8000158c:	d00080e7          	jalr	-768(ra) # 80006288 <acquire>
      if(p->state == RUNNABLE) {
    80001590:	4c9c                	lw	a5,24(s1)
    80001592:	ff3791e3          	bne	a5,s3,80001574 <scheduler+0x62>
        p->state = RUNNING;
    80001596:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000159a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000159e:	06048593          	addi	a1,s1,96
    800015a2:	8556                	mv	a0,s5
    800015a4:	00000097          	auipc	ra,0x0
    800015a8:	620080e7          	jalr	1568(ra) # 80001bc4 <swtch>
        c->proc = 0;
    800015ac:	020a3823          	sd	zero,48(s4)
    800015b0:	b7d1                	j	80001574 <scheduler+0x62>

00000000800015b2 <sched>:
{
    800015b2:	7179                	addi	sp,sp,-48
    800015b4:	f406                	sd	ra,40(sp)
    800015b6:	f022                	sd	s0,32(sp)
    800015b8:	ec26                	sd	s1,24(sp)
    800015ba:	e84a                	sd	s2,16(sp)
    800015bc:	e44e                	sd	s3,8(sp)
    800015be:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015c0:	00000097          	auipc	ra,0x0
    800015c4:	9b6080e7          	jalr	-1610(ra) # 80000f76 <myproc>
    800015c8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015ca:	00005097          	auipc	ra,0x5
    800015ce:	c44080e7          	jalr	-956(ra) # 8000620e <holding>
    800015d2:	c93d                	beqz	a0,80001648 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015d4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015d6:	2781                	sext.w	a5,a5
    800015d8:	079e                	slli	a5,a5,0x7
    800015da:	00008717          	auipc	a4,0x8
    800015de:	a7670713          	addi	a4,a4,-1418 # 80009050 <pid_lock>
    800015e2:	97ba                	add	a5,a5,a4
    800015e4:	0a87a703          	lw	a4,168(a5)
    800015e8:	4785                	li	a5,1
    800015ea:	06f71763          	bne	a4,a5,80001658 <sched+0xa6>
  if(p->state == RUNNING)
    800015ee:	4c98                	lw	a4,24(s1)
    800015f0:	4791                	li	a5,4
    800015f2:	06f70b63          	beq	a4,a5,80001668 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015f6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015fa:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015fc:	efb5                	bnez	a5,80001678 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015fe:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001600:	00008917          	auipc	s2,0x8
    80001604:	a5090913          	addi	s2,s2,-1456 # 80009050 <pid_lock>
    80001608:	2781                	sext.w	a5,a5
    8000160a:	079e                	slli	a5,a5,0x7
    8000160c:	97ca                	add	a5,a5,s2
    8000160e:	0ac7a983          	lw	s3,172(a5)
    80001612:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001614:	2781                	sext.w	a5,a5
    80001616:	079e                	slli	a5,a5,0x7
    80001618:	00008597          	auipc	a1,0x8
    8000161c:	a7058593          	addi	a1,a1,-1424 # 80009088 <cpus+0x8>
    80001620:	95be                	add	a1,a1,a5
    80001622:	06048513          	addi	a0,s1,96
    80001626:	00000097          	auipc	ra,0x0
    8000162a:	59e080e7          	jalr	1438(ra) # 80001bc4 <swtch>
    8000162e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001630:	2781                	sext.w	a5,a5
    80001632:	079e                	slli	a5,a5,0x7
    80001634:	993e                	add	s2,s2,a5
    80001636:	0b392623          	sw	s3,172(s2)
}
    8000163a:	70a2                	ld	ra,40(sp)
    8000163c:	7402                	ld	s0,32(sp)
    8000163e:	64e2                	ld	s1,24(sp)
    80001640:	6942                	ld	s2,16(sp)
    80001642:	69a2                	ld	s3,8(sp)
    80001644:	6145                	addi	sp,sp,48
    80001646:	8082                	ret
    panic("sched p->lock");
    80001648:	00007517          	auipc	a0,0x7
    8000164c:	b8850513          	addi	a0,a0,-1144 # 800081d0 <etext+0x1d0>
    80001650:	00004097          	auipc	ra,0x4
    80001654:	700080e7          	jalr	1792(ra) # 80005d50 <panic>
    panic("sched locks");
    80001658:	00007517          	auipc	a0,0x7
    8000165c:	b8850513          	addi	a0,a0,-1144 # 800081e0 <etext+0x1e0>
    80001660:	00004097          	auipc	ra,0x4
    80001664:	6f0080e7          	jalr	1776(ra) # 80005d50 <panic>
    panic("sched running");
    80001668:	00007517          	auipc	a0,0x7
    8000166c:	b8850513          	addi	a0,a0,-1144 # 800081f0 <etext+0x1f0>
    80001670:	00004097          	auipc	ra,0x4
    80001674:	6e0080e7          	jalr	1760(ra) # 80005d50 <panic>
    panic("sched interruptible");
    80001678:	00007517          	auipc	a0,0x7
    8000167c:	b8850513          	addi	a0,a0,-1144 # 80008200 <etext+0x200>
    80001680:	00004097          	auipc	ra,0x4
    80001684:	6d0080e7          	jalr	1744(ra) # 80005d50 <panic>

0000000080001688 <yield>:
{
    80001688:	1101                	addi	sp,sp,-32
    8000168a:	ec06                	sd	ra,24(sp)
    8000168c:	e822                	sd	s0,16(sp)
    8000168e:	e426                	sd	s1,8(sp)
    80001690:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001692:	00000097          	auipc	ra,0x0
    80001696:	8e4080e7          	jalr	-1820(ra) # 80000f76 <myproc>
    8000169a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000169c:	00005097          	auipc	ra,0x5
    800016a0:	bec080e7          	jalr	-1044(ra) # 80006288 <acquire>
  p->state = RUNNABLE;
    800016a4:	478d                	li	a5,3
    800016a6:	cc9c                	sw	a5,24(s1)
  sched();
    800016a8:	00000097          	auipc	ra,0x0
    800016ac:	f0a080e7          	jalr	-246(ra) # 800015b2 <sched>
  release(&p->lock);
    800016b0:	8526                	mv	a0,s1
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	c8a080e7          	jalr	-886(ra) # 8000633c <release>
}
    800016ba:	60e2                	ld	ra,24(sp)
    800016bc:	6442                	ld	s0,16(sp)
    800016be:	64a2                	ld	s1,8(sp)
    800016c0:	6105                	addi	sp,sp,32
    800016c2:	8082                	ret

00000000800016c4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016c4:	7179                	addi	sp,sp,-48
    800016c6:	f406                	sd	ra,40(sp)
    800016c8:	f022                	sd	s0,32(sp)
    800016ca:	ec26                	sd	s1,24(sp)
    800016cc:	e84a                	sd	s2,16(sp)
    800016ce:	e44e                	sd	s3,8(sp)
    800016d0:	1800                	addi	s0,sp,48
    800016d2:	89aa                	mv	s3,a0
    800016d4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016d6:	00000097          	auipc	ra,0x0
    800016da:	8a0080e7          	jalr	-1888(ra) # 80000f76 <myproc>
    800016de:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016e0:	00005097          	auipc	ra,0x5
    800016e4:	ba8080e7          	jalr	-1112(ra) # 80006288 <acquire>
  release(lk);
    800016e8:	854a                	mv	a0,s2
    800016ea:	00005097          	auipc	ra,0x5
    800016ee:	c52080e7          	jalr	-942(ra) # 8000633c <release>

  // Go to sleep.
  p->chan = chan;
    800016f2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016f6:	4789                	li	a5,2
    800016f8:	cc9c                	sw	a5,24(s1)

  sched();
    800016fa:	00000097          	auipc	ra,0x0
    800016fe:	eb8080e7          	jalr	-328(ra) # 800015b2 <sched>

  // Tidy up.
  p->chan = 0;
    80001702:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001706:	8526                	mv	a0,s1
    80001708:	00005097          	auipc	ra,0x5
    8000170c:	c34080e7          	jalr	-972(ra) # 8000633c <release>
  acquire(lk);
    80001710:	854a                	mv	a0,s2
    80001712:	00005097          	auipc	ra,0x5
    80001716:	b76080e7          	jalr	-1162(ra) # 80006288 <acquire>
}
    8000171a:	70a2                	ld	ra,40(sp)
    8000171c:	7402                	ld	s0,32(sp)
    8000171e:	64e2                	ld	s1,24(sp)
    80001720:	6942                	ld	s2,16(sp)
    80001722:	69a2                	ld	s3,8(sp)
    80001724:	6145                	addi	sp,sp,48
    80001726:	8082                	ret

0000000080001728 <wait>:
{
    80001728:	715d                	addi	sp,sp,-80
    8000172a:	e486                	sd	ra,72(sp)
    8000172c:	e0a2                	sd	s0,64(sp)
    8000172e:	fc26                	sd	s1,56(sp)
    80001730:	f84a                	sd	s2,48(sp)
    80001732:	f44e                	sd	s3,40(sp)
    80001734:	f052                	sd	s4,32(sp)
    80001736:	ec56                	sd	s5,24(sp)
    80001738:	e85a                	sd	s6,16(sp)
    8000173a:	e45e                	sd	s7,8(sp)
    8000173c:	e062                	sd	s8,0(sp)
    8000173e:	0880                	addi	s0,sp,80
    80001740:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001742:	00000097          	auipc	ra,0x0
    80001746:	834080e7          	jalr	-1996(ra) # 80000f76 <myproc>
    8000174a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000174c:	00008517          	auipc	a0,0x8
    80001750:	91c50513          	addi	a0,a0,-1764 # 80009068 <wait_lock>
    80001754:	00005097          	auipc	ra,0x5
    80001758:	b34080e7          	jalr	-1228(ra) # 80006288 <acquire>
    havekids = 0;
    8000175c:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000175e:	4a15                	li	s4,5
        havekids = 1;
    80001760:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001762:	0000e997          	auipc	s3,0xe
    80001766:	91e98993          	addi	s3,s3,-1762 # 8000f080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000176a:	00008c17          	auipc	s8,0x8
    8000176e:	8fec0c13          	addi	s8,s8,-1794 # 80009068 <wait_lock>
    havekids = 0;
    80001772:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001774:	00008497          	auipc	s1,0x8
    80001778:	d0c48493          	addi	s1,s1,-756 # 80009480 <proc>
    8000177c:	a0bd                	j	800017ea <wait+0xc2>
          pid = np->pid;
    8000177e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001782:	000b0e63          	beqz	s6,8000179e <wait+0x76>
    80001786:	4691                	li	a3,4
    80001788:	02c48613          	addi	a2,s1,44
    8000178c:	85da                	mv	a1,s6
    8000178e:	05093503          	ld	a0,80(s2)
    80001792:	fffff097          	auipc	ra,0xfffff
    80001796:	376080e7          	jalr	886(ra) # 80000b08 <copyout>
    8000179a:	02054563          	bltz	a0,800017c4 <wait+0x9c>
          freeproc(np);
    8000179e:	8526                	mv	a0,s1
    800017a0:	00000097          	auipc	ra,0x0
    800017a4:	9d0080e7          	jalr	-1584(ra) # 80001170 <freeproc>
          release(&np->lock);
    800017a8:	8526                	mv	a0,s1
    800017aa:	00005097          	auipc	ra,0x5
    800017ae:	b92080e7          	jalr	-1134(ra) # 8000633c <release>
          release(&wait_lock);
    800017b2:	00008517          	auipc	a0,0x8
    800017b6:	8b650513          	addi	a0,a0,-1866 # 80009068 <wait_lock>
    800017ba:	00005097          	auipc	ra,0x5
    800017be:	b82080e7          	jalr	-1150(ra) # 8000633c <release>
          return pid;
    800017c2:	a09d                	j	80001828 <wait+0x100>
            release(&np->lock);
    800017c4:	8526                	mv	a0,s1
    800017c6:	00005097          	auipc	ra,0x5
    800017ca:	b76080e7          	jalr	-1162(ra) # 8000633c <release>
            release(&wait_lock);
    800017ce:	00008517          	auipc	a0,0x8
    800017d2:	89a50513          	addi	a0,a0,-1894 # 80009068 <wait_lock>
    800017d6:	00005097          	auipc	ra,0x5
    800017da:	b66080e7          	jalr	-1178(ra) # 8000633c <release>
            return -1;
    800017de:	59fd                	li	s3,-1
    800017e0:	a0a1                	j	80001828 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017e2:	17048493          	addi	s1,s1,368
    800017e6:	03348463          	beq	s1,s3,8000180e <wait+0xe6>
      if(np->parent == p){
    800017ea:	7c9c                	ld	a5,56(s1)
    800017ec:	ff279be3          	bne	a5,s2,800017e2 <wait+0xba>
        acquire(&np->lock);
    800017f0:	8526                	mv	a0,s1
    800017f2:	00005097          	auipc	ra,0x5
    800017f6:	a96080e7          	jalr	-1386(ra) # 80006288 <acquire>
        if(np->state == ZOMBIE){
    800017fa:	4c9c                	lw	a5,24(s1)
    800017fc:	f94781e3          	beq	a5,s4,8000177e <wait+0x56>
        release(&np->lock);
    80001800:	8526                	mv	a0,s1
    80001802:	00005097          	auipc	ra,0x5
    80001806:	b3a080e7          	jalr	-1222(ra) # 8000633c <release>
        havekids = 1;
    8000180a:	8756                	mv	a4,s5
    8000180c:	bfd9                	j	800017e2 <wait+0xba>
    if(!havekids || p->killed){
    8000180e:	c701                	beqz	a4,80001816 <wait+0xee>
    80001810:	02892783          	lw	a5,40(s2)
    80001814:	c79d                	beqz	a5,80001842 <wait+0x11a>
      release(&wait_lock);
    80001816:	00008517          	auipc	a0,0x8
    8000181a:	85250513          	addi	a0,a0,-1966 # 80009068 <wait_lock>
    8000181e:	00005097          	auipc	ra,0x5
    80001822:	b1e080e7          	jalr	-1250(ra) # 8000633c <release>
      return -1;
    80001826:	59fd                	li	s3,-1
}
    80001828:	854e                	mv	a0,s3
    8000182a:	60a6                	ld	ra,72(sp)
    8000182c:	6406                	ld	s0,64(sp)
    8000182e:	74e2                	ld	s1,56(sp)
    80001830:	7942                	ld	s2,48(sp)
    80001832:	79a2                	ld	s3,40(sp)
    80001834:	7a02                	ld	s4,32(sp)
    80001836:	6ae2                	ld	s5,24(sp)
    80001838:	6b42                	ld	s6,16(sp)
    8000183a:	6ba2                	ld	s7,8(sp)
    8000183c:	6c02                	ld	s8,0(sp)
    8000183e:	6161                	addi	sp,sp,80
    80001840:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001842:	85e2                	mv	a1,s8
    80001844:	854a                	mv	a0,s2
    80001846:	00000097          	auipc	ra,0x0
    8000184a:	e7e080e7          	jalr	-386(ra) # 800016c4 <sleep>
    havekids = 0;
    8000184e:	b715                	j	80001772 <wait+0x4a>

0000000080001850 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001850:	7139                	addi	sp,sp,-64
    80001852:	fc06                	sd	ra,56(sp)
    80001854:	f822                	sd	s0,48(sp)
    80001856:	f426                	sd	s1,40(sp)
    80001858:	f04a                	sd	s2,32(sp)
    8000185a:	ec4e                	sd	s3,24(sp)
    8000185c:	e852                	sd	s4,16(sp)
    8000185e:	e456                	sd	s5,8(sp)
    80001860:	0080                	addi	s0,sp,64
    80001862:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001864:	00008497          	auipc	s1,0x8
    80001868:	c1c48493          	addi	s1,s1,-996 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000186c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000186e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001870:	0000e917          	auipc	s2,0xe
    80001874:	81090913          	addi	s2,s2,-2032 # 8000f080 <tickslock>
    80001878:	a811                	j	8000188c <wakeup+0x3c>
      }
      release(&p->lock);
    8000187a:	8526                	mv	a0,s1
    8000187c:	00005097          	auipc	ra,0x5
    80001880:	ac0080e7          	jalr	-1344(ra) # 8000633c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001884:	17048493          	addi	s1,s1,368
    80001888:	03248663          	beq	s1,s2,800018b4 <wakeup+0x64>
    if(p != myproc()){
    8000188c:	fffff097          	auipc	ra,0xfffff
    80001890:	6ea080e7          	jalr	1770(ra) # 80000f76 <myproc>
    80001894:	fea488e3          	beq	s1,a0,80001884 <wakeup+0x34>
      acquire(&p->lock);
    80001898:	8526                	mv	a0,s1
    8000189a:	00005097          	auipc	ra,0x5
    8000189e:	9ee080e7          	jalr	-1554(ra) # 80006288 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800018a2:	4c9c                	lw	a5,24(s1)
    800018a4:	fd379be3          	bne	a5,s3,8000187a <wakeup+0x2a>
    800018a8:	709c                	ld	a5,32(s1)
    800018aa:	fd4798e3          	bne	a5,s4,8000187a <wakeup+0x2a>
        p->state = RUNNABLE;
    800018ae:	0154ac23          	sw	s5,24(s1)
    800018b2:	b7e1                	j	8000187a <wakeup+0x2a>
    }
  }
}
    800018b4:	70e2                	ld	ra,56(sp)
    800018b6:	7442                	ld	s0,48(sp)
    800018b8:	74a2                	ld	s1,40(sp)
    800018ba:	7902                	ld	s2,32(sp)
    800018bc:	69e2                	ld	s3,24(sp)
    800018be:	6a42                	ld	s4,16(sp)
    800018c0:	6aa2                	ld	s5,8(sp)
    800018c2:	6121                	addi	sp,sp,64
    800018c4:	8082                	ret

00000000800018c6 <reparent>:
{
    800018c6:	7179                	addi	sp,sp,-48
    800018c8:	f406                	sd	ra,40(sp)
    800018ca:	f022                	sd	s0,32(sp)
    800018cc:	ec26                	sd	s1,24(sp)
    800018ce:	e84a                	sd	s2,16(sp)
    800018d0:	e44e                	sd	s3,8(sp)
    800018d2:	e052                	sd	s4,0(sp)
    800018d4:	1800                	addi	s0,sp,48
    800018d6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018d8:	00008497          	auipc	s1,0x8
    800018dc:	ba848493          	addi	s1,s1,-1112 # 80009480 <proc>
      pp->parent = initproc;
    800018e0:	00007a17          	auipc	s4,0x7
    800018e4:	730a0a13          	addi	s4,s4,1840 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018e8:	0000d997          	auipc	s3,0xd
    800018ec:	79898993          	addi	s3,s3,1944 # 8000f080 <tickslock>
    800018f0:	a029                	j	800018fa <reparent+0x34>
    800018f2:	17048493          	addi	s1,s1,368
    800018f6:	01348d63          	beq	s1,s3,80001910 <reparent+0x4a>
    if(pp->parent == p){
    800018fa:	7c9c                	ld	a5,56(s1)
    800018fc:	ff279be3          	bne	a5,s2,800018f2 <reparent+0x2c>
      pp->parent = initproc;
    80001900:	000a3503          	ld	a0,0(s4)
    80001904:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001906:	00000097          	auipc	ra,0x0
    8000190a:	f4a080e7          	jalr	-182(ra) # 80001850 <wakeup>
    8000190e:	b7d5                	j	800018f2 <reparent+0x2c>
}
    80001910:	70a2                	ld	ra,40(sp)
    80001912:	7402                	ld	s0,32(sp)
    80001914:	64e2                	ld	s1,24(sp)
    80001916:	6942                	ld	s2,16(sp)
    80001918:	69a2                	ld	s3,8(sp)
    8000191a:	6a02                	ld	s4,0(sp)
    8000191c:	6145                	addi	sp,sp,48
    8000191e:	8082                	ret

0000000080001920 <exit>:
{
    80001920:	7179                	addi	sp,sp,-48
    80001922:	f406                	sd	ra,40(sp)
    80001924:	f022                	sd	s0,32(sp)
    80001926:	ec26                	sd	s1,24(sp)
    80001928:	e84a                	sd	s2,16(sp)
    8000192a:	e44e                	sd	s3,8(sp)
    8000192c:	e052                	sd	s4,0(sp)
    8000192e:	1800                	addi	s0,sp,48
    80001930:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001932:	fffff097          	auipc	ra,0xfffff
    80001936:	644080e7          	jalr	1604(ra) # 80000f76 <myproc>
    8000193a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000193c:	00007797          	auipc	a5,0x7
    80001940:	6d47b783          	ld	a5,1748(a5) # 80009010 <initproc>
    80001944:	0d050493          	addi	s1,a0,208
    80001948:	15050913          	addi	s2,a0,336
    8000194c:	02a79363          	bne	a5,a0,80001972 <exit+0x52>
    panic("init exiting");
    80001950:	00007517          	auipc	a0,0x7
    80001954:	8c850513          	addi	a0,a0,-1848 # 80008218 <etext+0x218>
    80001958:	00004097          	auipc	ra,0x4
    8000195c:	3f8080e7          	jalr	1016(ra) # 80005d50 <panic>
      fileclose(f);
    80001960:	00002097          	auipc	ra,0x2
    80001964:	1f6080e7          	jalr	502(ra) # 80003b56 <fileclose>
      p->ofile[fd] = 0;
    80001968:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000196c:	04a1                	addi	s1,s1,8
    8000196e:	01248563          	beq	s1,s2,80001978 <exit+0x58>
    if(p->ofile[fd]){
    80001972:	6088                	ld	a0,0(s1)
    80001974:	f575                	bnez	a0,80001960 <exit+0x40>
    80001976:	bfdd                	j	8000196c <exit+0x4c>
  begin_op();
    80001978:	00002097          	auipc	ra,0x2
    8000197c:	d16080e7          	jalr	-746(ra) # 8000368e <begin_op>
  iput(p->cwd);
    80001980:	1509b503          	ld	a0,336(s3)
    80001984:	00001097          	auipc	ra,0x1
    80001988:	4e8080e7          	jalr	1256(ra) # 80002e6c <iput>
  end_op();
    8000198c:	00002097          	auipc	ra,0x2
    80001990:	d80080e7          	jalr	-640(ra) # 8000370c <end_op>
  p->cwd = 0;
    80001994:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001998:	00007497          	auipc	s1,0x7
    8000199c:	6d048493          	addi	s1,s1,1744 # 80009068 <wait_lock>
    800019a0:	8526                	mv	a0,s1
    800019a2:	00005097          	auipc	ra,0x5
    800019a6:	8e6080e7          	jalr	-1818(ra) # 80006288 <acquire>
  reparent(p);
    800019aa:	854e                	mv	a0,s3
    800019ac:	00000097          	auipc	ra,0x0
    800019b0:	f1a080e7          	jalr	-230(ra) # 800018c6 <reparent>
  wakeup(p->parent);
    800019b4:	0389b503          	ld	a0,56(s3)
    800019b8:	00000097          	auipc	ra,0x0
    800019bc:	e98080e7          	jalr	-360(ra) # 80001850 <wakeup>
  acquire(&p->lock);
    800019c0:	854e                	mv	a0,s3
    800019c2:	00005097          	auipc	ra,0x5
    800019c6:	8c6080e7          	jalr	-1850(ra) # 80006288 <acquire>
  p->xstate = status;
    800019ca:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019ce:	4795                	li	a5,5
    800019d0:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019d4:	8526                	mv	a0,s1
    800019d6:	00005097          	auipc	ra,0x5
    800019da:	966080e7          	jalr	-1690(ra) # 8000633c <release>
  sched();
    800019de:	00000097          	auipc	ra,0x0
    800019e2:	bd4080e7          	jalr	-1068(ra) # 800015b2 <sched>
  panic("zombie exit");
    800019e6:	00007517          	auipc	a0,0x7
    800019ea:	84250513          	addi	a0,a0,-1982 # 80008228 <etext+0x228>
    800019ee:	00004097          	auipc	ra,0x4
    800019f2:	362080e7          	jalr	866(ra) # 80005d50 <panic>

00000000800019f6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019f6:	7179                	addi	sp,sp,-48
    800019f8:	f406                	sd	ra,40(sp)
    800019fa:	f022                	sd	s0,32(sp)
    800019fc:	ec26                	sd	s1,24(sp)
    800019fe:	e84a                	sd	s2,16(sp)
    80001a00:	e44e                	sd	s3,8(sp)
    80001a02:	1800                	addi	s0,sp,48
    80001a04:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a06:	00008497          	auipc	s1,0x8
    80001a0a:	a7a48493          	addi	s1,s1,-1414 # 80009480 <proc>
    80001a0e:	0000d997          	auipc	s3,0xd
    80001a12:	67298993          	addi	s3,s3,1650 # 8000f080 <tickslock>
    acquire(&p->lock);
    80001a16:	8526                	mv	a0,s1
    80001a18:	00005097          	auipc	ra,0x5
    80001a1c:	870080e7          	jalr	-1936(ra) # 80006288 <acquire>
    if(p->pid == pid){
    80001a20:	589c                	lw	a5,48(s1)
    80001a22:	01278d63          	beq	a5,s2,80001a3c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a26:	8526                	mv	a0,s1
    80001a28:	00005097          	auipc	ra,0x5
    80001a2c:	914080e7          	jalr	-1772(ra) # 8000633c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a30:	17048493          	addi	s1,s1,368
    80001a34:	ff3491e3          	bne	s1,s3,80001a16 <kill+0x20>
  }
  return -1;
    80001a38:	557d                	li	a0,-1
    80001a3a:	a829                	j	80001a54 <kill+0x5e>
      p->killed = 1;
    80001a3c:	4785                	li	a5,1
    80001a3e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a40:	4c98                	lw	a4,24(s1)
    80001a42:	4789                	li	a5,2
    80001a44:	00f70f63          	beq	a4,a5,80001a62 <kill+0x6c>
      release(&p->lock);
    80001a48:	8526                	mv	a0,s1
    80001a4a:	00005097          	auipc	ra,0x5
    80001a4e:	8f2080e7          	jalr	-1806(ra) # 8000633c <release>
      return 0;
    80001a52:	4501                	li	a0,0
}
    80001a54:	70a2                	ld	ra,40(sp)
    80001a56:	7402                	ld	s0,32(sp)
    80001a58:	64e2                	ld	s1,24(sp)
    80001a5a:	6942                	ld	s2,16(sp)
    80001a5c:	69a2                	ld	s3,8(sp)
    80001a5e:	6145                	addi	sp,sp,48
    80001a60:	8082                	ret
        p->state = RUNNABLE;
    80001a62:	478d                	li	a5,3
    80001a64:	cc9c                	sw	a5,24(s1)
    80001a66:	b7cd                	j	80001a48 <kill+0x52>

0000000080001a68 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a68:	7179                	addi	sp,sp,-48
    80001a6a:	f406                	sd	ra,40(sp)
    80001a6c:	f022                	sd	s0,32(sp)
    80001a6e:	ec26                	sd	s1,24(sp)
    80001a70:	e84a                	sd	s2,16(sp)
    80001a72:	e44e                	sd	s3,8(sp)
    80001a74:	e052                	sd	s4,0(sp)
    80001a76:	1800                	addi	s0,sp,48
    80001a78:	84aa                	mv	s1,a0
    80001a7a:	892e                	mv	s2,a1
    80001a7c:	89b2                	mv	s3,a2
    80001a7e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a80:	fffff097          	auipc	ra,0xfffff
    80001a84:	4f6080e7          	jalr	1270(ra) # 80000f76 <myproc>
  if(user_dst){
    80001a88:	c08d                	beqz	s1,80001aaa <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a8a:	86d2                	mv	a3,s4
    80001a8c:	864e                	mv	a2,s3
    80001a8e:	85ca                	mv	a1,s2
    80001a90:	6928                	ld	a0,80(a0)
    80001a92:	fffff097          	auipc	ra,0xfffff
    80001a96:	076080e7          	jalr	118(ra) # 80000b08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a9a:	70a2                	ld	ra,40(sp)
    80001a9c:	7402                	ld	s0,32(sp)
    80001a9e:	64e2                	ld	s1,24(sp)
    80001aa0:	6942                	ld	s2,16(sp)
    80001aa2:	69a2                	ld	s3,8(sp)
    80001aa4:	6a02                	ld	s4,0(sp)
    80001aa6:	6145                	addi	sp,sp,48
    80001aa8:	8082                	ret
    memmove((char *)dst, src, len);
    80001aaa:	000a061b          	sext.w	a2,s4
    80001aae:	85ce                	mv	a1,s3
    80001ab0:	854a                	mv	a0,s2
    80001ab2:	ffffe097          	auipc	ra,0xffffe
    80001ab6:	724080e7          	jalr	1828(ra) # 800001d6 <memmove>
    return 0;
    80001aba:	8526                	mv	a0,s1
    80001abc:	bff9                	j	80001a9a <either_copyout+0x32>

0000000080001abe <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001abe:	7179                	addi	sp,sp,-48
    80001ac0:	f406                	sd	ra,40(sp)
    80001ac2:	f022                	sd	s0,32(sp)
    80001ac4:	ec26                	sd	s1,24(sp)
    80001ac6:	e84a                	sd	s2,16(sp)
    80001ac8:	e44e                	sd	s3,8(sp)
    80001aca:	e052                	sd	s4,0(sp)
    80001acc:	1800                	addi	s0,sp,48
    80001ace:	892a                	mv	s2,a0
    80001ad0:	84ae                	mv	s1,a1
    80001ad2:	89b2                	mv	s3,a2
    80001ad4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ad6:	fffff097          	auipc	ra,0xfffff
    80001ada:	4a0080e7          	jalr	1184(ra) # 80000f76 <myproc>
  if(user_src){
    80001ade:	c08d                	beqz	s1,80001b00 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001ae0:	86d2                	mv	a3,s4
    80001ae2:	864e                	mv	a2,s3
    80001ae4:	85ca                	mv	a1,s2
    80001ae6:	6928                	ld	a0,80(a0)
    80001ae8:	fffff097          	auipc	ra,0xfffff
    80001aec:	0ac080e7          	jalr	172(ra) # 80000b94 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001af0:	70a2                	ld	ra,40(sp)
    80001af2:	7402                	ld	s0,32(sp)
    80001af4:	64e2                	ld	s1,24(sp)
    80001af6:	6942                	ld	s2,16(sp)
    80001af8:	69a2                	ld	s3,8(sp)
    80001afa:	6a02                	ld	s4,0(sp)
    80001afc:	6145                	addi	sp,sp,48
    80001afe:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b00:	000a061b          	sext.w	a2,s4
    80001b04:	85ce                	mv	a1,s3
    80001b06:	854a                	mv	a0,s2
    80001b08:	ffffe097          	auipc	ra,0xffffe
    80001b0c:	6ce080e7          	jalr	1742(ra) # 800001d6 <memmove>
    return 0;
    80001b10:	8526                	mv	a0,s1
    80001b12:	bff9                	j	80001af0 <either_copyin+0x32>

0000000080001b14 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b14:	715d                	addi	sp,sp,-80
    80001b16:	e486                	sd	ra,72(sp)
    80001b18:	e0a2                	sd	s0,64(sp)
    80001b1a:	fc26                	sd	s1,56(sp)
    80001b1c:	f84a                	sd	s2,48(sp)
    80001b1e:	f44e                	sd	s3,40(sp)
    80001b20:	f052                	sd	s4,32(sp)
    80001b22:	ec56                	sd	s5,24(sp)
    80001b24:	e85a                	sd	s6,16(sp)
    80001b26:	e45e                	sd	s7,8(sp)
    80001b28:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b2a:	00006517          	auipc	a0,0x6
    80001b2e:	51e50513          	addi	a0,a0,1310 # 80008048 <etext+0x48>
    80001b32:	00004097          	auipc	ra,0x4
    80001b36:	268080e7          	jalr	616(ra) # 80005d9a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b3a:	00008497          	auipc	s1,0x8
    80001b3e:	a9e48493          	addi	s1,s1,-1378 # 800095d8 <proc+0x158>
    80001b42:	0000d917          	auipc	s2,0xd
    80001b46:	69690913          	addi	s2,s2,1686 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b4a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b4c:	00006997          	auipc	s3,0x6
    80001b50:	6ec98993          	addi	s3,s3,1772 # 80008238 <etext+0x238>
    printf("%d %s %s", p->pid, state, p->name);
    80001b54:	00006a97          	auipc	s5,0x6
    80001b58:	6eca8a93          	addi	s5,s5,1772 # 80008240 <etext+0x240>
    printf("\n");
    80001b5c:	00006a17          	auipc	s4,0x6
    80001b60:	4eca0a13          	addi	s4,s4,1260 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b64:	00006b97          	auipc	s7,0x6
    80001b68:	714b8b93          	addi	s7,s7,1812 # 80008278 <states.0>
    80001b6c:	a00d                	j	80001b8e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b6e:	ed86a583          	lw	a1,-296(a3)
    80001b72:	8556                	mv	a0,s5
    80001b74:	00004097          	auipc	ra,0x4
    80001b78:	226080e7          	jalr	550(ra) # 80005d9a <printf>
    printf("\n");
    80001b7c:	8552                	mv	a0,s4
    80001b7e:	00004097          	auipc	ra,0x4
    80001b82:	21c080e7          	jalr	540(ra) # 80005d9a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b86:	17048493          	addi	s1,s1,368
    80001b8a:	03248263          	beq	s1,s2,80001bae <procdump+0x9a>
    if(p->state == UNUSED)
    80001b8e:	86a6                	mv	a3,s1
    80001b90:	ec04a783          	lw	a5,-320(s1)
    80001b94:	dbed                	beqz	a5,80001b86 <procdump+0x72>
      state = "???";
    80001b96:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b98:	fcfb6be3          	bltu	s6,a5,80001b6e <procdump+0x5a>
    80001b9c:	02079713          	slli	a4,a5,0x20
    80001ba0:	01d75793          	srli	a5,a4,0x1d
    80001ba4:	97de                	add	a5,a5,s7
    80001ba6:	6390                	ld	a2,0(a5)
    80001ba8:	f279                	bnez	a2,80001b6e <procdump+0x5a>
      state = "???";
    80001baa:	864e                	mv	a2,s3
    80001bac:	b7c9                	j	80001b6e <procdump+0x5a>
  }
}
    80001bae:	60a6                	ld	ra,72(sp)
    80001bb0:	6406                	ld	s0,64(sp)
    80001bb2:	74e2                	ld	s1,56(sp)
    80001bb4:	7942                	ld	s2,48(sp)
    80001bb6:	79a2                	ld	s3,40(sp)
    80001bb8:	7a02                	ld	s4,32(sp)
    80001bba:	6ae2                	ld	s5,24(sp)
    80001bbc:	6b42                	ld	s6,16(sp)
    80001bbe:	6ba2                	ld	s7,8(sp)
    80001bc0:	6161                	addi	sp,sp,80
    80001bc2:	8082                	ret

0000000080001bc4 <swtch>:
    80001bc4:	00153023          	sd	ra,0(a0)
    80001bc8:	00253423          	sd	sp,8(a0)
    80001bcc:	e900                	sd	s0,16(a0)
    80001bce:	ed04                	sd	s1,24(a0)
    80001bd0:	03253023          	sd	s2,32(a0)
    80001bd4:	03353423          	sd	s3,40(a0)
    80001bd8:	03453823          	sd	s4,48(a0)
    80001bdc:	03553c23          	sd	s5,56(a0)
    80001be0:	05653023          	sd	s6,64(a0)
    80001be4:	05753423          	sd	s7,72(a0)
    80001be8:	05853823          	sd	s8,80(a0)
    80001bec:	05953c23          	sd	s9,88(a0)
    80001bf0:	07a53023          	sd	s10,96(a0)
    80001bf4:	07b53423          	sd	s11,104(a0)
    80001bf8:	0005b083          	ld	ra,0(a1)
    80001bfc:	0085b103          	ld	sp,8(a1)
    80001c00:	6980                	ld	s0,16(a1)
    80001c02:	6d84                	ld	s1,24(a1)
    80001c04:	0205b903          	ld	s2,32(a1)
    80001c08:	0285b983          	ld	s3,40(a1)
    80001c0c:	0305ba03          	ld	s4,48(a1)
    80001c10:	0385ba83          	ld	s5,56(a1)
    80001c14:	0405bb03          	ld	s6,64(a1)
    80001c18:	0485bb83          	ld	s7,72(a1)
    80001c1c:	0505bc03          	ld	s8,80(a1)
    80001c20:	0585bc83          	ld	s9,88(a1)
    80001c24:	0605bd03          	ld	s10,96(a1)
    80001c28:	0685bd83          	ld	s11,104(a1)
    80001c2c:	8082                	ret

0000000080001c2e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c2e:	1141                	addi	sp,sp,-16
    80001c30:	e406                	sd	ra,8(sp)
    80001c32:	e022                	sd	s0,0(sp)
    80001c34:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c36:	00006597          	auipc	a1,0x6
    80001c3a:	67258593          	addi	a1,a1,1650 # 800082a8 <states.0+0x30>
    80001c3e:	0000d517          	auipc	a0,0xd
    80001c42:	44250513          	addi	a0,a0,1090 # 8000f080 <tickslock>
    80001c46:	00004097          	auipc	ra,0x4
    80001c4a:	5b2080e7          	jalr	1458(ra) # 800061f8 <initlock>
}
    80001c4e:	60a2                	ld	ra,8(sp)
    80001c50:	6402                	ld	s0,0(sp)
    80001c52:	0141                	addi	sp,sp,16
    80001c54:	8082                	ret

0000000080001c56 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c56:	1141                	addi	sp,sp,-16
    80001c58:	e422                	sd	s0,8(sp)
    80001c5a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c5c:	00003797          	auipc	a5,0x3
    80001c60:	55478793          	addi	a5,a5,1364 # 800051b0 <kernelvec>
    80001c64:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c68:	6422                	ld	s0,8(sp)
    80001c6a:	0141                	addi	sp,sp,16
    80001c6c:	8082                	ret

0000000080001c6e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c6e:	1141                	addi	sp,sp,-16
    80001c70:	e406                	sd	ra,8(sp)
    80001c72:	e022                	sd	s0,0(sp)
    80001c74:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c76:	fffff097          	auipc	ra,0xfffff
    80001c7a:	300080e7          	jalr	768(ra) # 80000f76 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c7e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c82:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c84:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c88:	00005697          	auipc	a3,0x5
    80001c8c:	37868693          	addi	a3,a3,888 # 80007000 <_trampoline>
    80001c90:	00005717          	auipc	a4,0x5
    80001c94:	37070713          	addi	a4,a4,880 # 80007000 <_trampoline>
    80001c98:	8f15                	sub	a4,a4,a3
    80001c9a:	040007b7          	lui	a5,0x4000
    80001c9e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001ca0:	07b2                	slli	a5,a5,0xc
    80001ca2:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca4:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ca8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001caa:	18002673          	csrr	a2,satp
    80001cae:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cb0:	6d30                	ld	a2,88(a0)
    80001cb2:	6138                	ld	a4,64(a0)
    80001cb4:	6585                	lui	a1,0x1
    80001cb6:	972e                	add	a4,a4,a1
    80001cb8:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cba:	6d38                	ld	a4,88(a0)
    80001cbc:	00000617          	auipc	a2,0x0
    80001cc0:	13860613          	addi	a2,a2,312 # 80001df4 <usertrap>
    80001cc4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cc6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cc8:	8612                	mv	a2,tp
    80001cca:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ccc:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cd0:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cd4:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cd8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cdc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cde:	6f18                	ld	a4,24(a4)
    80001ce0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ce4:	692c                	ld	a1,80(a0)
    80001ce6:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001ce8:	00005717          	auipc	a4,0x5
    80001cec:	3a870713          	addi	a4,a4,936 # 80007090 <userret>
    80001cf0:	8f15                	sub	a4,a4,a3
    80001cf2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cf4:	577d                	li	a4,-1
    80001cf6:	177e                	slli	a4,a4,0x3f
    80001cf8:	8dd9                	or	a1,a1,a4
    80001cfa:	02000537          	lui	a0,0x2000
    80001cfe:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001d00:	0536                	slli	a0,a0,0xd
    80001d02:	9782                	jalr	a5
}
    80001d04:	60a2                	ld	ra,8(sp)
    80001d06:	6402                	ld	s0,0(sp)
    80001d08:	0141                	addi	sp,sp,16
    80001d0a:	8082                	ret

0000000080001d0c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d0c:	1101                	addi	sp,sp,-32
    80001d0e:	ec06                	sd	ra,24(sp)
    80001d10:	e822                	sd	s0,16(sp)
    80001d12:	e426                	sd	s1,8(sp)
    80001d14:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d16:	0000d497          	auipc	s1,0xd
    80001d1a:	36a48493          	addi	s1,s1,874 # 8000f080 <tickslock>
    80001d1e:	8526                	mv	a0,s1
    80001d20:	00004097          	auipc	ra,0x4
    80001d24:	568080e7          	jalr	1384(ra) # 80006288 <acquire>
  ticks++;
    80001d28:	00007517          	auipc	a0,0x7
    80001d2c:	2f050513          	addi	a0,a0,752 # 80009018 <ticks>
    80001d30:	411c                	lw	a5,0(a0)
    80001d32:	2785                	addiw	a5,a5,1
    80001d34:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d36:	00000097          	auipc	ra,0x0
    80001d3a:	b1a080e7          	jalr	-1254(ra) # 80001850 <wakeup>
  release(&tickslock);
    80001d3e:	8526                	mv	a0,s1
    80001d40:	00004097          	auipc	ra,0x4
    80001d44:	5fc080e7          	jalr	1532(ra) # 8000633c <release>
}
    80001d48:	60e2                	ld	ra,24(sp)
    80001d4a:	6442                	ld	s0,16(sp)
    80001d4c:	64a2                	ld	s1,8(sp)
    80001d4e:	6105                	addi	sp,sp,32
    80001d50:	8082                	ret

0000000080001d52 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d52:	1101                	addi	sp,sp,-32
    80001d54:	ec06                	sd	ra,24(sp)
    80001d56:	e822                	sd	s0,16(sp)
    80001d58:	e426                	sd	s1,8(sp)
    80001d5a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d5c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d60:	00074d63          	bltz	a4,80001d7a <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d64:	57fd                	li	a5,-1
    80001d66:	17fe                	slli	a5,a5,0x3f
    80001d68:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d6a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d6c:	06f70363          	beq	a4,a5,80001dd2 <devintr+0x80>
  }
}
    80001d70:	60e2                	ld	ra,24(sp)
    80001d72:	6442                	ld	s0,16(sp)
    80001d74:	64a2                	ld	s1,8(sp)
    80001d76:	6105                	addi	sp,sp,32
    80001d78:	8082                	ret
     (scause & 0xff) == 9){
    80001d7a:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001d7e:	46a5                	li	a3,9
    80001d80:	fed792e3          	bne	a5,a3,80001d64 <devintr+0x12>
    int irq = plic_claim();
    80001d84:	00003097          	auipc	ra,0x3
    80001d88:	534080e7          	jalr	1332(ra) # 800052b8 <plic_claim>
    80001d8c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d8e:	47a9                	li	a5,10
    80001d90:	02f50763          	beq	a0,a5,80001dbe <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d94:	4785                	li	a5,1
    80001d96:	02f50963          	beq	a0,a5,80001dc8 <devintr+0x76>
    return 1;
    80001d9a:	4505                	li	a0,1
    } else if(irq){
    80001d9c:	d8f1                	beqz	s1,80001d70 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d9e:	85a6                	mv	a1,s1
    80001da0:	00006517          	auipc	a0,0x6
    80001da4:	51050513          	addi	a0,a0,1296 # 800082b0 <states.0+0x38>
    80001da8:	00004097          	auipc	ra,0x4
    80001dac:	ff2080e7          	jalr	-14(ra) # 80005d9a <printf>
      plic_complete(irq);
    80001db0:	8526                	mv	a0,s1
    80001db2:	00003097          	auipc	ra,0x3
    80001db6:	52a080e7          	jalr	1322(ra) # 800052dc <plic_complete>
    return 1;
    80001dba:	4505                	li	a0,1
    80001dbc:	bf55                	j	80001d70 <devintr+0x1e>
      uartintr();
    80001dbe:	00004097          	auipc	ra,0x4
    80001dc2:	3ea080e7          	jalr	1002(ra) # 800061a8 <uartintr>
    80001dc6:	b7ed                	j	80001db0 <devintr+0x5e>
      virtio_disk_intr();
    80001dc8:	00004097          	auipc	ra,0x4
    80001dcc:	9a0080e7          	jalr	-1632(ra) # 80005768 <virtio_disk_intr>
    80001dd0:	b7c5                	j	80001db0 <devintr+0x5e>
    if(cpuid() == 0){
    80001dd2:	fffff097          	auipc	ra,0xfffff
    80001dd6:	178080e7          	jalr	376(ra) # 80000f4a <cpuid>
    80001dda:	c901                	beqz	a0,80001dea <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ddc:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001de0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001de2:	14479073          	csrw	sip,a5
    return 2;
    80001de6:	4509                	li	a0,2
    80001de8:	b761                	j	80001d70 <devintr+0x1e>
      clockintr();
    80001dea:	00000097          	auipc	ra,0x0
    80001dee:	f22080e7          	jalr	-222(ra) # 80001d0c <clockintr>
    80001df2:	b7ed                	j	80001ddc <devintr+0x8a>

0000000080001df4 <usertrap>:
{
    80001df4:	1101                	addi	sp,sp,-32
    80001df6:	ec06                	sd	ra,24(sp)
    80001df8:	e822                	sd	s0,16(sp)
    80001dfa:	e426                	sd	s1,8(sp)
    80001dfc:	e04a                	sd	s2,0(sp)
    80001dfe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e00:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e04:	1007f793          	andi	a5,a5,256
    80001e08:	e3ad                	bnez	a5,80001e6a <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e0a:	00003797          	auipc	a5,0x3
    80001e0e:	3a678793          	addi	a5,a5,934 # 800051b0 <kernelvec>
    80001e12:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e16:	fffff097          	auipc	ra,0xfffff
    80001e1a:	160080e7          	jalr	352(ra) # 80000f76 <myproc>
    80001e1e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e20:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e22:	14102773          	csrr	a4,sepc
    80001e26:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e28:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e2c:	47a1                	li	a5,8
    80001e2e:	04f71c63          	bne	a4,a5,80001e86 <usertrap+0x92>
    if(p->killed)
    80001e32:	551c                	lw	a5,40(a0)
    80001e34:	e3b9                	bnez	a5,80001e7a <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e36:	6cb8                	ld	a4,88(s1)
    80001e38:	6f1c                	ld	a5,24(a4)
    80001e3a:	0791                	addi	a5,a5,4
    80001e3c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e3e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e42:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e46:	10079073          	csrw	sstatus,a5
    syscall();
    80001e4a:	00000097          	auipc	ra,0x0
    80001e4e:	2e0080e7          	jalr	736(ra) # 8000212a <syscall>
  if(p->killed)
    80001e52:	549c                	lw	a5,40(s1)
    80001e54:	ebc1                	bnez	a5,80001ee4 <usertrap+0xf0>
  usertrapret();
    80001e56:	00000097          	auipc	ra,0x0
    80001e5a:	e18080e7          	jalr	-488(ra) # 80001c6e <usertrapret>
}
    80001e5e:	60e2                	ld	ra,24(sp)
    80001e60:	6442                	ld	s0,16(sp)
    80001e62:	64a2                	ld	s1,8(sp)
    80001e64:	6902                	ld	s2,0(sp)
    80001e66:	6105                	addi	sp,sp,32
    80001e68:	8082                	ret
    panic("usertrap: not from user mode");
    80001e6a:	00006517          	auipc	a0,0x6
    80001e6e:	46650513          	addi	a0,a0,1126 # 800082d0 <states.0+0x58>
    80001e72:	00004097          	auipc	ra,0x4
    80001e76:	ede080e7          	jalr	-290(ra) # 80005d50 <panic>
      exit(-1);
    80001e7a:	557d                	li	a0,-1
    80001e7c:	00000097          	auipc	ra,0x0
    80001e80:	aa4080e7          	jalr	-1372(ra) # 80001920 <exit>
    80001e84:	bf4d                	j	80001e36 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e86:	00000097          	auipc	ra,0x0
    80001e8a:	ecc080e7          	jalr	-308(ra) # 80001d52 <devintr>
    80001e8e:	892a                	mv	s2,a0
    80001e90:	c501                	beqz	a0,80001e98 <usertrap+0xa4>
  if(p->killed)
    80001e92:	549c                	lw	a5,40(s1)
    80001e94:	c3a1                	beqz	a5,80001ed4 <usertrap+0xe0>
    80001e96:	a815                	j	80001eca <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e98:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e9c:	5890                	lw	a2,48(s1)
    80001e9e:	00006517          	auipc	a0,0x6
    80001ea2:	45250513          	addi	a0,a0,1106 # 800082f0 <states.0+0x78>
    80001ea6:	00004097          	auipc	ra,0x4
    80001eaa:	ef4080e7          	jalr	-268(ra) # 80005d9a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eae:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001eb2:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001eb6:	00006517          	auipc	a0,0x6
    80001eba:	46a50513          	addi	a0,a0,1130 # 80008320 <states.0+0xa8>
    80001ebe:	00004097          	auipc	ra,0x4
    80001ec2:	edc080e7          	jalr	-292(ra) # 80005d9a <printf>
    p->killed = 1;
    80001ec6:	4785                	li	a5,1
    80001ec8:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001eca:	557d                	li	a0,-1
    80001ecc:	00000097          	auipc	ra,0x0
    80001ed0:	a54080e7          	jalr	-1452(ra) # 80001920 <exit>
  if(which_dev == 2)
    80001ed4:	4789                	li	a5,2
    80001ed6:	f8f910e3          	bne	s2,a5,80001e56 <usertrap+0x62>
    yield();
    80001eda:	fffff097          	auipc	ra,0xfffff
    80001ede:	7ae080e7          	jalr	1966(ra) # 80001688 <yield>
    80001ee2:	bf95                	j	80001e56 <usertrap+0x62>
  int which_dev = 0;
    80001ee4:	4901                	li	s2,0
    80001ee6:	b7d5                	j	80001eca <usertrap+0xd6>

0000000080001ee8 <kerneltrap>:
{
    80001ee8:	7179                	addi	sp,sp,-48
    80001eea:	f406                	sd	ra,40(sp)
    80001eec:	f022                	sd	s0,32(sp)
    80001eee:	ec26                	sd	s1,24(sp)
    80001ef0:	e84a                	sd	s2,16(sp)
    80001ef2:	e44e                	sd	s3,8(sp)
    80001ef4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001efa:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001efe:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f02:	1004f793          	andi	a5,s1,256
    80001f06:	cb85                	beqz	a5,80001f36 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f08:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f0c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f0e:	ef85                	bnez	a5,80001f46 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f10:	00000097          	auipc	ra,0x0
    80001f14:	e42080e7          	jalr	-446(ra) # 80001d52 <devintr>
    80001f18:	cd1d                	beqz	a0,80001f56 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f1a:	4789                	li	a5,2
    80001f1c:	06f50a63          	beq	a0,a5,80001f90 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f20:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f24:	10049073          	csrw	sstatus,s1
}
    80001f28:	70a2                	ld	ra,40(sp)
    80001f2a:	7402                	ld	s0,32(sp)
    80001f2c:	64e2                	ld	s1,24(sp)
    80001f2e:	6942                	ld	s2,16(sp)
    80001f30:	69a2                	ld	s3,8(sp)
    80001f32:	6145                	addi	sp,sp,48
    80001f34:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f36:	00006517          	auipc	a0,0x6
    80001f3a:	40a50513          	addi	a0,a0,1034 # 80008340 <states.0+0xc8>
    80001f3e:	00004097          	auipc	ra,0x4
    80001f42:	e12080e7          	jalr	-494(ra) # 80005d50 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f46:	00006517          	auipc	a0,0x6
    80001f4a:	42250513          	addi	a0,a0,1058 # 80008368 <states.0+0xf0>
    80001f4e:	00004097          	auipc	ra,0x4
    80001f52:	e02080e7          	jalr	-510(ra) # 80005d50 <panic>
    printf("scause %p\n", scause);
    80001f56:	85ce                	mv	a1,s3
    80001f58:	00006517          	auipc	a0,0x6
    80001f5c:	43050513          	addi	a0,a0,1072 # 80008388 <states.0+0x110>
    80001f60:	00004097          	auipc	ra,0x4
    80001f64:	e3a080e7          	jalr	-454(ra) # 80005d9a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f68:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f6c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f70:	00006517          	auipc	a0,0x6
    80001f74:	42850513          	addi	a0,a0,1064 # 80008398 <states.0+0x120>
    80001f78:	00004097          	auipc	ra,0x4
    80001f7c:	e22080e7          	jalr	-478(ra) # 80005d9a <printf>
    panic("kerneltrap");
    80001f80:	00006517          	auipc	a0,0x6
    80001f84:	43050513          	addi	a0,a0,1072 # 800083b0 <states.0+0x138>
    80001f88:	00004097          	auipc	ra,0x4
    80001f8c:	dc8080e7          	jalr	-568(ra) # 80005d50 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f90:	fffff097          	auipc	ra,0xfffff
    80001f94:	fe6080e7          	jalr	-26(ra) # 80000f76 <myproc>
    80001f98:	d541                	beqz	a0,80001f20 <kerneltrap+0x38>
    80001f9a:	fffff097          	auipc	ra,0xfffff
    80001f9e:	fdc080e7          	jalr	-36(ra) # 80000f76 <myproc>
    80001fa2:	4d18                	lw	a4,24(a0)
    80001fa4:	4791                	li	a5,4
    80001fa6:	f6f71de3          	bne	a4,a5,80001f20 <kerneltrap+0x38>
    yield();
    80001faa:	fffff097          	auipc	ra,0xfffff
    80001fae:	6de080e7          	jalr	1758(ra) # 80001688 <yield>
    80001fb2:	b7bd                	j	80001f20 <kerneltrap+0x38>

0000000080001fb4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fb4:	1101                	addi	sp,sp,-32
    80001fb6:	ec06                	sd	ra,24(sp)
    80001fb8:	e822                	sd	s0,16(sp)
    80001fba:	e426                	sd	s1,8(sp)
    80001fbc:	1000                	addi	s0,sp,32
    80001fbe:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fc0:	fffff097          	auipc	ra,0xfffff
    80001fc4:	fb6080e7          	jalr	-74(ra) # 80000f76 <myproc>
  switch (n) {
    80001fc8:	4795                	li	a5,5
    80001fca:	0497e163          	bltu	a5,s1,8000200c <argraw+0x58>
    80001fce:	048a                	slli	s1,s1,0x2
    80001fd0:	00006717          	auipc	a4,0x6
    80001fd4:	41870713          	addi	a4,a4,1048 # 800083e8 <states.0+0x170>
    80001fd8:	94ba                	add	s1,s1,a4
    80001fda:	409c                	lw	a5,0(s1)
    80001fdc:	97ba                	add	a5,a5,a4
    80001fde:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fe0:	6d3c                	ld	a5,88(a0)
    80001fe2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fe4:	60e2                	ld	ra,24(sp)
    80001fe6:	6442                	ld	s0,16(sp)
    80001fe8:	64a2                	ld	s1,8(sp)
    80001fea:	6105                	addi	sp,sp,32
    80001fec:	8082                	ret
    return p->trapframe->a1;
    80001fee:	6d3c                	ld	a5,88(a0)
    80001ff0:	7fa8                	ld	a0,120(a5)
    80001ff2:	bfcd                	j	80001fe4 <argraw+0x30>
    return p->trapframe->a2;
    80001ff4:	6d3c                	ld	a5,88(a0)
    80001ff6:	63c8                	ld	a0,128(a5)
    80001ff8:	b7f5                	j	80001fe4 <argraw+0x30>
    return p->trapframe->a3;
    80001ffa:	6d3c                	ld	a5,88(a0)
    80001ffc:	67c8                	ld	a0,136(a5)
    80001ffe:	b7dd                	j	80001fe4 <argraw+0x30>
    return p->trapframe->a4;
    80002000:	6d3c                	ld	a5,88(a0)
    80002002:	6bc8                	ld	a0,144(a5)
    80002004:	b7c5                	j	80001fe4 <argraw+0x30>
    return p->trapframe->a5;
    80002006:	6d3c                	ld	a5,88(a0)
    80002008:	6fc8                	ld	a0,152(a5)
    8000200a:	bfe9                	j	80001fe4 <argraw+0x30>
  panic("argraw");
    8000200c:	00006517          	auipc	a0,0x6
    80002010:	3b450513          	addi	a0,a0,948 # 800083c0 <states.0+0x148>
    80002014:	00004097          	auipc	ra,0x4
    80002018:	d3c080e7          	jalr	-708(ra) # 80005d50 <panic>

000000008000201c <fetchaddr>:
{
    8000201c:	1101                	addi	sp,sp,-32
    8000201e:	ec06                	sd	ra,24(sp)
    80002020:	e822                	sd	s0,16(sp)
    80002022:	e426                	sd	s1,8(sp)
    80002024:	e04a                	sd	s2,0(sp)
    80002026:	1000                	addi	s0,sp,32
    80002028:	84aa                	mv	s1,a0
    8000202a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000202c:	fffff097          	auipc	ra,0xfffff
    80002030:	f4a080e7          	jalr	-182(ra) # 80000f76 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002034:	653c                	ld	a5,72(a0)
    80002036:	02f4f863          	bgeu	s1,a5,80002066 <fetchaddr+0x4a>
    8000203a:	00848713          	addi	a4,s1,8
    8000203e:	02e7e663          	bltu	a5,a4,8000206a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002042:	46a1                	li	a3,8
    80002044:	8626                	mv	a2,s1
    80002046:	85ca                	mv	a1,s2
    80002048:	6928                	ld	a0,80(a0)
    8000204a:	fffff097          	auipc	ra,0xfffff
    8000204e:	b4a080e7          	jalr	-1206(ra) # 80000b94 <copyin>
    80002052:	00a03533          	snez	a0,a0
    80002056:	40a00533          	neg	a0,a0
}
    8000205a:	60e2                	ld	ra,24(sp)
    8000205c:	6442                	ld	s0,16(sp)
    8000205e:	64a2                	ld	s1,8(sp)
    80002060:	6902                	ld	s2,0(sp)
    80002062:	6105                	addi	sp,sp,32
    80002064:	8082                	ret
    return -1;
    80002066:	557d                	li	a0,-1
    80002068:	bfcd                	j	8000205a <fetchaddr+0x3e>
    8000206a:	557d                	li	a0,-1
    8000206c:	b7fd                	j	8000205a <fetchaddr+0x3e>

000000008000206e <fetchstr>:
{
    8000206e:	7179                	addi	sp,sp,-48
    80002070:	f406                	sd	ra,40(sp)
    80002072:	f022                	sd	s0,32(sp)
    80002074:	ec26                	sd	s1,24(sp)
    80002076:	e84a                	sd	s2,16(sp)
    80002078:	e44e                	sd	s3,8(sp)
    8000207a:	1800                	addi	s0,sp,48
    8000207c:	892a                	mv	s2,a0
    8000207e:	84ae                	mv	s1,a1
    80002080:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	ef4080e7          	jalr	-268(ra) # 80000f76 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000208a:	86ce                	mv	a3,s3
    8000208c:	864a                	mv	a2,s2
    8000208e:	85a6                	mv	a1,s1
    80002090:	6928                	ld	a0,80(a0)
    80002092:	fffff097          	auipc	ra,0xfffff
    80002096:	b90080e7          	jalr	-1136(ra) # 80000c22 <copyinstr>
  if(err < 0)
    8000209a:	00054763          	bltz	a0,800020a8 <fetchstr+0x3a>
  return strlen(buf);
    8000209e:	8526                	mv	a0,s1
    800020a0:	ffffe097          	auipc	ra,0xffffe
    800020a4:	256080e7          	jalr	598(ra) # 800002f6 <strlen>
}
    800020a8:	70a2                	ld	ra,40(sp)
    800020aa:	7402                	ld	s0,32(sp)
    800020ac:	64e2                	ld	s1,24(sp)
    800020ae:	6942                	ld	s2,16(sp)
    800020b0:	69a2                	ld	s3,8(sp)
    800020b2:	6145                	addi	sp,sp,48
    800020b4:	8082                	ret

00000000800020b6 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800020b6:	1101                	addi	sp,sp,-32
    800020b8:	ec06                	sd	ra,24(sp)
    800020ba:	e822                	sd	s0,16(sp)
    800020bc:	e426                	sd	s1,8(sp)
    800020be:	1000                	addi	s0,sp,32
    800020c0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020c2:	00000097          	auipc	ra,0x0
    800020c6:	ef2080e7          	jalr	-270(ra) # 80001fb4 <argraw>
    800020ca:	c088                	sw	a0,0(s1)
  return 0;
}
    800020cc:	4501                	li	a0,0
    800020ce:	60e2                	ld	ra,24(sp)
    800020d0:	6442                	ld	s0,16(sp)
    800020d2:	64a2                	ld	s1,8(sp)
    800020d4:	6105                	addi	sp,sp,32
    800020d6:	8082                	ret

00000000800020d8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020d8:	1101                	addi	sp,sp,-32
    800020da:	ec06                	sd	ra,24(sp)
    800020dc:	e822                	sd	s0,16(sp)
    800020de:	e426                	sd	s1,8(sp)
    800020e0:	1000                	addi	s0,sp,32
    800020e2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020e4:	00000097          	auipc	ra,0x0
    800020e8:	ed0080e7          	jalr	-304(ra) # 80001fb4 <argraw>
    800020ec:	e088                	sd	a0,0(s1)
  return 0;
}
    800020ee:	4501                	li	a0,0
    800020f0:	60e2                	ld	ra,24(sp)
    800020f2:	6442                	ld	s0,16(sp)
    800020f4:	64a2                	ld	s1,8(sp)
    800020f6:	6105                	addi	sp,sp,32
    800020f8:	8082                	ret

00000000800020fa <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020fa:	1101                	addi	sp,sp,-32
    800020fc:	ec06                	sd	ra,24(sp)
    800020fe:	e822                	sd	s0,16(sp)
    80002100:	e426                	sd	s1,8(sp)
    80002102:	e04a                	sd	s2,0(sp)
    80002104:	1000                	addi	s0,sp,32
    80002106:	84ae                	mv	s1,a1
    80002108:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000210a:	00000097          	auipc	ra,0x0
    8000210e:	eaa080e7          	jalr	-342(ra) # 80001fb4 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002112:	864a                	mv	a2,s2
    80002114:	85a6                	mv	a1,s1
    80002116:	00000097          	auipc	ra,0x0
    8000211a:	f58080e7          	jalr	-168(ra) # 8000206e <fetchstr>
}
    8000211e:	60e2                	ld	ra,24(sp)
    80002120:	6442                	ld	s0,16(sp)
    80002122:	64a2                	ld	s1,8(sp)
    80002124:	6902                	ld	s2,0(sp)
    80002126:	6105                	addi	sp,sp,32
    80002128:	8082                	ret

000000008000212a <syscall>:



void
syscall(void)
{
    8000212a:	1101                	addi	sp,sp,-32
    8000212c:	ec06                	sd	ra,24(sp)
    8000212e:	e822                	sd	s0,16(sp)
    80002130:	e426                	sd	s1,8(sp)
    80002132:	e04a                	sd	s2,0(sp)
    80002134:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002136:	fffff097          	auipc	ra,0xfffff
    8000213a:	e40080e7          	jalr	-448(ra) # 80000f76 <myproc>
    8000213e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002140:	05853903          	ld	s2,88(a0)
    80002144:	0a893783          	ld	a5,168(s2)
    80002148:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000214c:	37fd                	addiw	a5,a5,-1
    8000214e:	4775                	li	a4,29
    80002150:	00f76f63          	bltu	a4,a5,8000216e <syscall+0x44>
    80002154:	00369713          	slli	a4,a3,0x3
    80002158:	00006797          	auipc	a5,0x6
    8000215c:	2a878793          	addi	a5,a5,680 # 80008400 <syscalls>
    80002160:	97ba                	add	a5,a5,a4
    80002162:	639c                	ld	a5,0(a5)
    80002164:	c789                	beqz	a5,8000216e <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002166:	9782                	jalr	a5
    80002168:	06a93823          	sd	a0,112(s2)
    8000216c:	a839                	j	8000218a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000216e:	15848613          	addi	a2,s1,344
    80002172:	588c                	lw	a1,48(s1)
    80002174:	00006517          	auipc	a0,0x6
    80002178:	25450513          	addi	a0,a0,596 # 800083c8 <states.0+0x150>
    8000217c:	00004097          	auipc	ra,0x4
    80002180:	c1e080e7          	jalr	-994(ra) # 80005d9a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002184:	6cbc                	ld	a5,88(s1)
    80002186:	577d                	li	a4,-1
    80002188:	fbb8                	sd	a4,112(a5)
  }
}
    8000218a:	60e2                	ld	ra,24(sp)
    8000218c:	6442                	ld	s0,16(sp)
    8000218e:	64a2                	ld	s1,8(sp)
    80002190:	6902                	ld	s2,0(sp)
    80002192:	6105                	addi	sp,sp,32
    80002194:	8082                	ret

0000000080002196 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002196:	1101                	addi	sp,sp,-32
    80002198:	ec06                	sd	ra,24(sp)
    8000219a:	e822                	sd	s0,16(sp)
    8000219c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000219e:	fec40593          	addi	a1,s0,-20
    800021a2:	4501                	li	a0,0
    800021a4:	00000097          	auipc	ra,0x0
    800021a8:	f12080e7          	jalr	-238(ra) # 800020b6 <argint>
    return -1;
    800021ac:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021ae:	00054963          	bltz	a0,800021c0 <sys_exit+0x2a>
  exit(n);
    800021b2:	fec42503          	lw	a0,-20(s0)
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	76a080e7          	jalr	1898(ra) # 80001920 <exit>
  return 0;  // not reached
    800021be:	4781                	li	a5,0
}
    800021c0:	853e                	mv	a0,a5
    800021c2:	60e2                	ld	ra,24(sp)
    800021c4:	6442                	ld	s0,16(sp)
    800021c6:	6105                	addi	sp,sp,32
    800021c8:	8082                	ret

00000000800021ca <sys_getpid>:

uint64
sys_getpid(void)
{
    800021ca:	1141                	addi	sp,sp,-16
    800021cc:	e406                	sd	ra,8(sp)
    800021ce:	e022                	sd	s0,0(sp)
    800021d0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021d2:	fffff097          	auipc	ra,0xfffff
    800021d6:	da4080e7          	jalr	-604(ra) # 80000f76 <myproc>
}
    800021da:	5908                	lw	a0,48(a0)
    800021dc:	60a2                	ld	ra,8(sp)
    800021de:	6402                	ld	s0,0(sp)
    800021e0:	0141                	addi	sp,sp,16
    800021e2:	8082                	ret

00000000800021e4 <sys_fork>:

uint64
sys_fork(void)
{
    800021e4:	1141                	addi	sp,sp,-16
    800021e6:	e406                	sd	ra,8(sp)
    800021e8:	e022                	sd	s0,0(sp)
    800021ea:	0800                	addi	s0,sp,16
  return fork();
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	1e6080e7          	jalr	486(ra) # 800013d2 <fork>
}
    800021f4:	60a2                	ld	ra,8(sp)
    800021f6:	6402                	ld	s0,0(sp)
    800021f8:	0141                	addi	sp,sp,16
    800021fa:	8082                	ret

00000000800021fc <sys_wait>:

uint64
sys_wait(void)
{
    800021fc:	1101                	addi	sp,sp,-32
    800021fe:	ec06                	sd	ra,24(sp)
    80002200:	e822                	sd	s0,16(sp)
    80002202:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002204:	fe840593          	addi	a1,s0,-24
    80002208:	4501                	li	a0,0
    8000220a:	00000097          	auipc	ra,0x0
    8000220e:	ece080e7          	jalr	-306(ra) # 800020d8 <argaddr>
    80002212:	87aa                	mv	a5,a0
    return -1;
    80002214:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002216:	0007c863          	bltz	a5,80002226 <sys_wait+0x2a>
  return wait(p);
    8000221a:	fe843503          	ld	a0,-24(s0)
    8000221e:	fffff097          	auipc	ra,0xfffff
    80002222:	50a080e7          	jalr	1290(ra) # 80001728 <wait>
}
    80002226:	60e2                	ld	ra,24(sp)
    80002228:	6442                	ld	s0,16(sp)
    8000222a:	6105                	addi	sp,sp,32
    8000222c:	8082                	ret

000000008000222e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000222e:	7179                	addi	sp,sp,-48
    80002230:	f406                	sd	ra,40(sp)
    80002232:	f022                	sd	s0,32(sp)
    80002234:	ec26                	sd	s1,24(sp)
    80002236:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002238:	fdc40593          	addi	a1,s0,-36
    8000223c:	4501                	li	a0,0
    8000223e:	00000097          	auipc	ra,0x0
    80002242:	e78080e7          	jalr	-392(ra) # 800020b6 <argint>
    80002246:	87aa                	mv	a5,a0
    return -1;
    80002248:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000224a:	0207c063          	bltz	a5,8000226a <sys_sbrk+0x3c>
  
  addr = myproc()->sz;
    8000224e:	fffff097          	auipc	ra,0xfffff
    80002252:	d28080e7          	jalr	-728(ra) # 80000f76 <myproc>
    80002256:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002258:	fdc42503          	lw	a0,-36(s0)
    8000225c:	fffff097          	auipc	ra,0xfffff
    80002260:	0fe080e7          	jalr	254(ra) # 8000135a <growproc>
    80002264:	00054863          	bltz	a0,80002274 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002268:	8526                	mv	a0,s1
}
    8000226a:	70a2                	ld	ra,40(sp)
    8000226c:	7402                	ld	s0,32(sp)
    8000226e:	64e2                	ld	s1,24(sp)
    80002270:	6145                	addi	sp,sp,48
    80002272:	8082                	ret
    return -1;
    80002274:	557d                	li	a0,-1
    80002276:	bfd5                	j	8000226a <sys_sbrk+0x3c>

0000000080002278 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002278:	7139                	addi	sp,sp,-64
    8000227a:	fc06                	sd	ra,56(sp)
    8000227c:	f822                	sd	s0,48(sp)
    8000227e:	f426                	sd	s1,40(sp)
    80002280:	f04a                	sd	s2,32(sp)
    80002282:	ec4e                	sd	s3,24(sp)
    80002284:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    80002286:	fcc40593          	addi	a1,s0,-52
    8000228a:	4501                	li	a0,0
    8000228c:	00000097          	auipc	ra,0x0
    80002290:	e2a080e7          	jalr	-470(ra) # 800020b6 <argint>
    return -1;
    80002294:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002296:	06054563          	bltz	a0,80002300 <sys_sleep+0x88>
  acquire(&tickslock);
    8000229a:	0000d517          	auipc	a0,0xd
    8000229e:	de650513          	addi	a0,a0,-538 # 8000f080 <tickslock>
    800022a2:	00004097          	auipc	ra,0x4
    800022a6:	fe6080e7          	jalr	-26(ra) # 80006288 <acquire>
  ticks0 = ticks;
    800022aa:	00007917          	auipc	s2,0x7
    800022ae:	d6e92903          	lw	s2,-658(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800022b2:	fcc42783          	lw	a5,-52(s0)
    800022b6:	cf85                	beqz	a5,800022ee <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022b8:	0000d997          	auipc	s3,0xd
    800022bc:	dc898993          	addi	s3,s3,-568 # 8000f080 <tickslock>
    800022c0:	00007497          	auipc	s1,0x7
    800022c4:	d5848493          	addi	s1,s1,-680 # 80009018 <ticks>
    if(myproc()->killed){
    800022c8:	fffff097          	auipc	ra,0xfffff
    800022cc:	cae080e7          	jalr	-850(ra) # 80000f76 <myproc>
    800022d0:	551c                	lw	a5,40(a0)
    800022d2:	ef9d                	bnez	a5,80002310 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022d4:	85ce                	mv	a1,s3
    800022d6:	8526                	mv	a0,s1
    800022d8:	fffff097          	auipc	ra,0xfffff
    800022dc:	3ec080e7          	jalr	1004(ra) # 800016c4 <sleep>
  while(ticks - ticks0 < n){
    800022e0:	409c                	lw	a5,0(s1)
    800022e2:	412787bb          	subw	a5,a5,s2
    800022e6:	fcc42703          	lw	a4,-52(s0)
    800022ea:	fce7efe3          	bltu	a5,a4,800022c8 <sys_sleep+0x50>
  }
  release(&tickslock);
    800022ee:	0000d517          	auipc	a0,0xd
    800022f2:	d9250513          	addi	a0,a0,-622 # 8000f080 <tickslock>
    800022f6:	00004097          	auipc	ra,0x4
    800022fa:	046080e7          	jalr	70(ra) # 8000633c <release>
  return 0;
    800022fe:	4781                	li	a5,0
}
    80002300:	853e                	mv	a0,a5
    80002302:	70e2                	ld	ra,56(sp)
    80002304:	7442                	ld	s0,48(sp)
    80002306:	74a2                	ld	s1,40(sp)
    80002308:	7902                	ld	s2,32(sp)
    8000230a:	69e2                	ld	s3,24(sp)
    8000230c:	6121                	addi	sp,sp,64
    8000230e:	8082                	ret
      release(&tickslock);
    80002310:	0000d517          	auipc	a0,0xd
    80002314:	d7050513          	addi	a0,a0,-656 # 8000f080 <tickslock>
    80002318:	00004097          	auipc	ra,0x4
    8000231c:	024080e7          	jalr	36(ra) # 8000633c <release>
      return -1;
    80002320:	57fd                	li	a5,-1
    80002322:	bff9                	j	80002300 <sys_sleep+0x88>

0000000080002324 <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002324:	7139                	addi	sp,sp,-64
    80002326:	fc06                	sd	ra,56(sp)
    80002328:	f822                	sd	s0,48(sp)
    8000232a:	f426                	sd	s1,40(sp)
    8000232c:	0080                	addi	s0,sp,64
	uint64 start_addr;	// 测试程序中buf的地址
	int amount;			// ........32
	uint64 buffer;		// ........abits的地址
	if (argaddr(0,&start_addr) < 0 || argint(1,&amount) < 0 || 
    8000232e:	fd840593          	addi	a1,s0,-40
    80002332:	4501                	li	a0,0
    80002334:	00000097          	auipc	ra,0x0
    80002338:	da4080e7          	jalr	-604(ra) # 800020d8 <argaddr>
    8000233c:	06054363          	bltz	a0,800023a2 <sys_pgaccess+0x7e>
    80002340:	fd440593          	addi	a1,s0,-44
    80002344:	4505                	li	a0,1
    80002346:	00000097          	auipc	ra,0x0
    8000234a:	d70080e7          	jalr	-656(ra) # 800020b6 <argint>
    8000234e:	04054c63          	bltz	a0,800023a6 <sys_pgaccess+0x82>
			argaddr(2,&buffer) < 0) //获取三个参数
    80002352:	fc840593          	addi	a1,s0,-56
    80002356:	4509                	li	a0,2
    80002358:	00000097          	auipc	ra,0x0
    8000235c:	d80080e7          	jalr	-640(ra) # 800020d8 <argaddr>
	if (argaddr(0,&start_addr) < 0 || argint(1,&amount) < 0 || 
    80002360:	04054563          	bltz	a0,800023aa <sys_pgaccess+0x86>
		return -1;
	struct proc* p = myproc();
    80002364:	fffff097          	auipc	ra,0xfffff
    80002368:	c12080e7          	jalr	-1006(ra) # 80000f76 <myproc>
    8000236c:	84aa                	mv	s1,a0
	uint64 mask = access_check(p->pagetable,start_addr); // 页表是当前进程的页表
    8000236e:	fd843583          	ld	a1,-40(s0)
    80002372:	6928                	ld	a0,80(a0)
    80002374:	fffff097          	auipc	ra,0xfffff
    80002378:	a12080e7          	jalr	-1518(ra) # 80000d86 <access_check>
    8000237c:	fca43023          	sd	a0,-64(s0)
	if (copyout(p->pagetable,buffer,(char*)&mask,sizeof(uint64)) < 0)
    80002380:	46a1                	li	a3,8
    80002382:	fc040613          	addi	a2,s0,-64
    80002386:	fc843583          	ld	a1,-56(s0)
    8000238a:	68a8                	ld	a0,80(s1)
    8000238c:	ffffe097          	auipc	ra,0xffffe
    80002390:	77c080e7          	jalr	1916(ra) # 80000b08 <copyout>
    80002394:	41f5551b          	sraiw	a0,a0,0x1f
		return -1;
	return 0;
}
    80002398:	70e2                	ld	ra,56(sp)
    8000239a:	7442                	ld	s0,48(sp)
    8000239c:	74a2                	ld	s1,40(sp)
    8000239e:	6121                	addi	sp,sp,64
    800023a0:	8082                	ret
		return -1;
    800023a2:	557d                	li	a0,-1
    800023a4:	bfd5                	j	80002398 <sys_pgaccess+0x74>
    800023a6:	557d                	li	a0,-1
    800023a8:	bfc5                	j	80002398 <sys_pgaccess+0x74>
    800023aa:	557d                	li	a0,-1
    800023ac:	b7f5                	j	80002398 <sys_pgaccess+0x74>

00000000800023ae <sys_kill>:
#endif

uint64
sys_kill(void)
{
    800023ae:	1101                	addi	sp,sp,-32
    800023b0:	ec06                	sd	ra,24(sp)
    800023b2:	e822                	sd	s0,16(sp)
    800023b4:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800023b6:	fec40593          	addi	a1,s0,-20
    800023ba:	4501                	li	a0,0
    800023bc:	00000097          	auipc	ra,0x0
    800023c0:	cfa080e7          	jalr	-774(ra) # 800020b6 <argint>
    800023c4:	87aa                	mv	a5,a0
    return -1;
    800023c6:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800023c8:	0007c863          	bltz	a5,800023d8 <sys_kill+0x2a>
  return kill(pid);
    800023cc:	fec42503          	lw	a0,-20(s0)
    800023d0:	fffff097          	auipc	ra,0xfffff
    800023d4:	626080e7          	jalr	1574(ra) # 800019f6 <kill>
}
    800023d8:	60e2                	ld	ra,24(sp)
    800023da:	6442                	ld	s0,16(sp)
    800023dc:	6105                	addi	sp,sp,32
    800023de:	8082                	ret

00000000800023e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800023e0:	1101                	addi	sp,sp,-32
    800023e2:	ec06                	sd	ra,24(sp)
    800023e4:	e822                	sd	s0,16(sp)
    800023e6:	e426                	sd	s1,8(sp)
    800023e8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023ea:	0000d517          	auipc	a0,0xd
    800023ee:	c9650513          	addi	a0,a0,-874 # 8000f080 <tickslock>
    800023f2:	00004097          	auipc	ra,0x4
    800023f6:	e96080e7          	jalr	-362(ra) # 80006288 <acquire>
  xticks = ticks;
    800023fa:	00007497          	auipc	s1,0x7
    800023fe:	c1e4a483          	lw	s1,-994(s1) # 80009018 <ticks>
  release(&tickslock);
    80002402:	0000d517          	auipc	a0,0xd
    80002406:	c7e50513          	addi	a0,a0,-898 # 8000f080 <tickslock>
    8000240a:	00004097          	auipc	ra,0x4
    8000240e:	f32080e7          	jalr	-206(ra) # 8000633c <release>
  return xticks;
}
    80002412:	02049513          	slli	a0,s1,0x20
    80002416:	9101                	srli	a0,a0,0x20
    80002418:	60e2                	ld	ra,24(sp)
    8000241a:	6442                	ld	s0,16(sp)
    8000241c:	64a2                	ld	s1,8(sp)
    8000241e:	6105                	addi	sp,sp,32
    80002420:	8082                	ret

0000000080002422 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002422:	7179                	addi	sp,sp,-48
    80002424:	f406                	sd	ra,40(sp)
    80002426:	f022                	sd	s0,32(sp)
    80002428:	ec26                	sd	s1,24(sp)
    8000242a:	e84a                	sd	s2,16(sp)
    8000242c:	e44e                	sd	s3,8(sp)
    8000242e:	e052                	sd	s4,0(sp)
    80002430:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002432:	00006597          	auipc	a1,0x6
    80002436:	0c658593          	addi	a1,a1,198 # 800084f8 <syscalls+0xf8>
    8000243a:	0000d517          	auipc	a0,0xd
    8000243e:	c5e50513          	addi	a0,a0,-930 # 8000f098 <bcache>
    80002442:	00004097          	auipc	ra,0x4
    80002446:	db6080e7          	jalr	-586(ra) # 800061f8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000244a:	00015797          	auipc	a5,0x15
    8000244e:	c4e78793          	addi	a5,a5,-946 # 80017098 <bcache+0x8000>
    80002452:	00015717          	auipc	a4,0x15
    80002456:	eae70713          	addi	a4,a4,-338 # 80017300 <bcache+0x8268>
    8000245a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000245e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002462:	0000d497          	auipc	s1,0xd
    80002466:	c4e48493          	addi	s1,s1,-946 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    8000246a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000246c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000246e:	00006a17          	auipc	s4,0x6
    80002472:	092a0a13          	addi	s4,s4,146 # 80008500 <syscalls+0x100>
    b->next = bcache.head.next;
    80002476:	2b893783          	ld	a5,696(s2)
    8000247a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000247c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002480:	85d2                	mv	a1,s4
    80002482:	01048513          	addi	a0,s1,16
    80002486:	00001097          	auipc	ra,0x1
    8000248a:	4c2080e7          	jalr	1218(ra) # 80003948 <initsleeplock>
    bcache.head.next->prev = b;
    8000248e:	2b893783          	ld	a5,696(s2)
    80002492:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002494:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002498:	45848493          	addi	s1,s1,1112
    8000249c:	fd349de3          	bne	s1,s3,80002476 <binit+0x54>
  }
}
    800024a0:	70a2                	ld	ra,40(sp)
    800024a2:	7402                	ld	s0,32(sp)
    800024a4:	64e2                	ld	s1,24(sp)
    800024a6:	6942                	ld	s2,16(sp)
    800024a8:	69a2                	ld	s3,8(sp)
    800024aa:	6a02                	ld	s4,0(sp)
    800024ac:	6145                	addi	sp,sp,48
    800024ae:	8082                	ret

00000000800024b0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024b0:	7179                	addi	sp,sp,-48
    800024b2:	f406                	sd	ra,40(sp)
    800024b4:	f022                	sd	s0,32(sp)
    800024b6:	ec26                	sd	s1,24(sp)
    800024b8:	e84a                	sd	s2,16(sp)
    800024ba:	e44e                	sd	s3,8(sp)
    800024bc:	1800                	addi	s0,sp,48
    800024be:	892a                	mv	s2,a0
    800024c0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800024c2:	0000d517          	auipc	a0,0xd
    800024c6:	bd650513          	addi	a0,a0,-1066 # 8000f098 <bcache>
    800024ca:	00004097          	auipc	ra,0x4
    800024ce:	dbe080e7          	jalr	-578(ra) # 80006288 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024d2:	00015497          	auipc	s1,0x15
    800024d6:	e7e4b483          	ld	s1,-386(s1) # 80017350 <bcache+0x82b8>
    800024da:	00015797          	auipc	a5,0x15
    800024de:	e2678793          	addi	a5,a5,-474 # 80017300 <bcache+0x8268>
    800024e2:	02f48f63          	beq	s1,a5,80002520 <bread+0x70>
    800024e6:	873e                	mv	a4,a5
    800024e8:	a021                	j	800024f0 <bread+0x40>
    800024ea:	68a4                	ld	s1,80(s1)
    800024ec:	02e48a63          	beq	s1,a4,80002520 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024f0:	449c                	lw	a5,8(s1)
    800024f2:	ff279ce3          	bne	a5,s2,800024ea <bread+0x3a>
    800024f6:	44dc                	lw	a5,12(s1)
    800024f8:	ff3799e3          	bne	a5,s3,800024ea <bread+0x3a>
      b->refcnt++;
    800024fc:	40bc                	lw	a5,64(s1)
    800024fe:	2785                	addiw	a5,a5,1
    80002500:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002502:	0000d517          	auipc	a0,0xd
    80002506:	b9650513          	addi	a0,a0,-1130 # 8000f098 <bcache>
    8000250a:	00004097          	auipc	ra,0x4
    8000250e:	e32080e7          	jalr	-462(ra) # 8000633c <release>
      acquiresleep(&b->lock);
    80002512:	01048513          	addi	a0,s1,16
    80002516:	00001097          	auipc	ra,0x1
    8000251a:	46c080e7          	jalr	1132(ra) # 80003982 <acquiresleep>
      return b;
    8000251e:	a8b9                	j	8000257c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002520:	00015497          	auipc	s1,0x15
    80002524:	e284b483          	ld	s1,-472(s1) # 80017348 <bcache+0x82b0>
    80002528:	00015797          	auipc	a5,0x15
    8000252c:	dd878793          	addi	a5,a5,-552 # 80017300 <bcache+0x8268>
    80002530:	00f48863          	beq	s1,a5,80002540 <bread+0x90>
    80002534:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002536:	40bc                	lw	a5,64(s1)
    80002538:	cf81                	beqz	a5,80002550 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000253a:	64a4                	ld	s1,72(s1)
    8000253c:	fee49de3          	bne	s1,a4,80002536 <bread+0x86>
  panic("bget: no buffers");
    80002540:	00006517          	auipc	a0,0x6
    80002544:	fc850513          	addi	a0,a0,-56 # 80008508 <syscalls+0x108>
    80002548:	00004097          	auipc	ra,0x4
    8000254c:	808080e7          	jalr	-2040(ra) # 80005d50 <panic>
      b->dev = dev;
    80002550:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002554:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002558:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000255c:	4785                	li	a5,1
    8000255e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002560:	0000d517          	auipc	a0,0xd
    80002564:	b3850513          	addi	a0,a0,-1224 # 8000f098 <bcache>
    80002568:	00004097          	auipc	ra,0x4
    8000256c:	dd4080e7          	jalr	-556(ra) # 8000633c <release>
      acquiresleep(&b->lock);
    80002570:	01048513          	addi	a0,s1,16
    80002574:	00001097          	auipc	ra,0x1
    80002578:	40e080e7          	jalr	1038(ra) # 80003982 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000257c:	409c                	lw	a5,0(s1)
    8000257e:	cb89                	beqz	a5,80002590 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002580:	8526                	mv	a0,s1
    80002582:	70a2                	ld	ra,40(sp)
    80002584:	7402                	ld	s0,32(sp)
    80002586:	64e2                	ld	s1,24(sp)
    80002588:	6942                	ld	s2,16(sp)
    8000258a:	69a2                	ld	s3,8(sp)
    8000258c:	6145                	addi	sp,sp,48
    8000258e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002590:	4581                	li	a1,0
    80002592:	8526                	mv	a0,s1
    80002594:	00003097          	auipc	ra,0x3
    80002598:	f4e080e7          	jalr	-178(ra) # 800054e2 <virtio_disk_rw>
    b->valid = 1;
    8000259c:	4785                	li	a5,1
    8000259e:	c09c                	sw	a5,0(s1)
  return b;
    800025a0:	b7c5                	j	80002580 <bread+0xd0>

00000000800025a2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025a2:	1101                	addi	sp,sp,-32
    800025a4:	ec06                	sd	ra,24(sp)
    800025a6:	e822                	sd	s0,16(sp)
    800025a8:	e426                	sd	s1,8(sp)
    800025aa:	1000                	addi	s0,sp,32
    800025ac:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025ae:	0541                	addi	a0,a0,16
    800025b0:	00001097          	auipc	ra,0x1
    800025b4:	46c080e7          	jalr	1132(ra) # 80003a1c <holdingsleep>
    800025b8:	cd01                	beqz	a0,800025d0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025ba:	4585                	li	a1,1
    800025bc:	8526                	mv	a0,s1
    800025be:	00003097          	auipc	ra,0x3
    800025c2:	f24080e7          	jalr	-220(ra) # 800054e2 <virtio_disk_rw>
}
    800025c6:	60e2                	ld	ra,24(sp)
    800025c8:	6442                	ld	s0,16(sp)
    800025ca:	64a2                	ld	s1,8(sp)
    800025cc:	6105                	addi	sp,sp,32
    800025ce:	8082                	ret
    panic("bwrite");
    800025d0:	00006517          	auipc	a0,0x6
    800025d4:	f5050513          	addi	a0,a0,-176 # 80008520 <syscalls+0x120>
    800025d8:	00003097          	auipc	ra,0x3
    800025dc:	778080e7          	jalr	1912(ra) # 80005d50 <panic>

00000000800025e0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025e0:	1101                	addi	sp,sp,-32
    800025e2:	ec06                	sd	ra,24(sp)
    800025e4:	e822                	sd	s0,16(sp)
    800025e6:	e426                	sd	s1,8(sp)
    800025e8:	e04a                	sd	s2,0(sp)
    800025ea:	1000                	addi	s0,sp,32
    800025ec:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025ee:	01050913          	addi	s2,a0,16
    800025f2:	854a                	mv	a0,s2
    800025f4:	00001097          	auipc	ra,0x1
    800025f8:	428080e7          	jalr	1064(ra) # 80003a1c <holdingsleep>
    800025fc:	c92d                	beqz	a0,8000266e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025fe:	854a                	mv	a0,s2
    80002600:	00001097          	auipc	ra,0x1
    80002604:	3d8080e7          	jalr	984(ra) # 800039d8 <releasesleep>

  acquire(&bcache.lock);
    80002608:	0000d517          	auipc	a0,0xd
    8000260c:	a9050513          	addi	a0,a0,-1392 # 8000f098 <bcache>
    80002610:	00004097          	auipc	ra,0x4
    80002614:	c78080e7          	jalr	-904(ra) # 80006288 <acquire>
  b->refcnt--;
    80002618:	40bc                	lw	a5,64(s1)
    8000261a:	37fd                	addiw	a5,a5,-1
    8000261c:	0007871b          	sext.w	a4,a5
    80002620:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002622:	eb05                	bnez	a4,80002652 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002624:	68bc                	ld	a5,80(s1)
    80002626:	64b8                	ld	a4,72(s1)
    80002628:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000262a:	64bc                	ld	a5,72(s1)
    8000262c:	68b8                	ld	a4,80(s1)
    8000262e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002630:	00015797          	auipc	a5,0x15
    80002634:	a6878793          	addi	a5,a5,-1432 # 80017098 <bcache+0x8000>
    80002638:	2b87b703          	ld	a4,696(a5)
    8000263c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000263e:	00015717          	auipc	a4,0x15
    80002642:	cc270713          	addi	a4,a4,-830 # 80017300 <bcache+0x8268>
    80002646:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002648:	2b87b703          	ld	a4,696(a5)
    8000264c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000264e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002652:	0000d517          	auipc	a0,0xd
    80002656:	a4650513          	addi	a0,a0,-1466 # 8000f098 <bcache>
    8000265a:	00004097          	auipc	ra,0x4
    8000265e:	ce2080e7          	jalr	-798(ra) # 8000633c <release>
}
    80002662:	60e2                	ld	ra,24(sp)
    80002664:	6442                	ld	s0,16(sp)
    80002666:	64a2                	ld	s1,8(sp)
    80002668:	6902                	ld	s2,0(sp)
    8000266a:	6105                	addi	sp,sp,32
    8000266c:	8082                	ret
    panic("brelse");
    8000266e:	00006517          	auipc	a0,0x6
    80002672:	eba50513          	addi	a0,a0,-326 # 80008528 <syscalls+0x128>
    80002676:	00003097          	auipc	ra,0x3
    8000267a:	6da080e7          	jalr	1754(ra) # 80005d50 <panic>

000000008000267e <bpin>:

void
bpin(struct buf *b) {
    8000267e:	1101                	addi	sp,sp,-32
    80002680:	ec06                	sd	ra,24(sp)
    80002682:	e822                	sd	s0,16(sp)
    80002684:	e426                	sd	s1,8(sp)
    80002686:	1000                	addi	s0,sp,32
    80002688:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000268a:	0000d517          	auipc	a0,0xd
    8000268e:	a0e50513          	addi	a0,a0,-1522 # 8000f098 <bcache>
    80002692:	00004097          	auipc	ra,0x4
    80002696:	bf6080e7          	jalr	-1034(ra) # 80006288 <acquire>
  b->refcnt++;
    8000269a:	40bc                	lw	a5,64(s1)
    8000269c:	2785                	addiw	a5,a5,1
    8000269e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026a0:	0000d517          	auipc	a0,0xd
    800026a4:	9f850513          	addi	a0,a0,-1544 # 8000f098 <bcache>
    800026a8:	00004097          	auipc	ra,0x4
    800026ac:	c94080e7          	jalr	-876(ra) # 8000633c <release>
}
    800026b0:	60e2                	ld	ra,24(sp)
    800026b2:	6442                	ld	s0,16(sp)
    800026b4:	64a2                	ld	s1,8(sp)
    800026b6:	6105                	addi	sp,sp,32
    800026b8:	8082                	ret

00000000800026ba <bunpin>:

void
bunpin(struct buf *b) {
    800026ba:	1101                	addi	sp,sp,-32
    800026bc:	ec06                	sd	ra,24(sp)
    800026be:	e822                	sd	s0,16(sp)
    800026c0:	e426                	sd	s1,8(sp)
    800026c2:	1000                	addi	s0,sp,32
    800026c4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026c6:	0000d517          	auipc	a0,0xd
    800026ca:	9d250513          	addi	a0,a0,-1582 # 8000f098 <bcache>
    800026ce:	00004097          	auipc	ra,0x4
    800026d2:	bba080e7          	jalr	-1094(ra) # 80006288 <acquire>
  b->refcnt--;
    800026d6:	40bc                	lw	a5,64(s1)
    800026d8:	37fd                	addiw	a5,a5,-1
    800026da:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026dc:	0000d517          	auipc	a0,0xd
    800026e0:	9bc50513          	addi	a0,a0,-1604 # 8000f098 <bcache>
    800026e4:	00004097          	auipc	ra,0x4
    800026e8:	c58080e7          	jalr	-936(ra) # 8000633c <release>
}
    800026ec:	60e2                	ld	ra,24(sp)
    800026ee:	6442                	ld	s0,16(sp)
    800026f0:	64a2                	ld	s1,8(sp)
    800026f2:	6105                	addi	sp,sp,32
    800026f4:	8082                	ret

00000000800026f6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026f6:	1101                	addi	sp,sp,-32
    800026f8:	ec06                	sd	ra,24(sp)
    800026fa:	e822                	sd	s0,16(sp)
    800026fc:	e426                	sd	s1,8(sp)
    800026fe:	e04a                	sd	s2,0(sp)
    80002700:	1000                	addi	s0,sp,32
    80002702:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002704:	00d5d59b          	srliw	a1,a1,0xd
    80002708:	00015797          	auipc	a5,0x15
    8000270c:	06c7a783          	lw	a5,108(a5) # 80017774 <sb+0x1c>
    80002710:	9dbd                	addw	a1,a1,a5
    80002712:	00000097          	auipc	ra,0x0
    80002716:	d9e080e7          	jalr	-610(ra) # 800024b0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000271a:	0074f713          	andi	a4,s1,7
    8000271e:	4785                	li	a5,1
    80002720:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002724:	14ce                	slli	s1,s1,0x33
    80002726:	90d9                	srli	s1,s1,0x36
    80002728:	00950733          	add	a4,a0,s1
    8000272c:	05874703          	lbu	a4,88(a4)
    80002730:	00e7f6b3          	and	a3,a5,a4
    80002734:	c69d                	beqz	a3,80002762 <bfree+0x6c>
    80002736:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002738:	94aa                	add	s1,s1,a0
    8000273a:	fff7c793          	not	a5,a5
    8000273e:	8f7d                	and	a4,a4,a5
    80002740:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002744:	00001097          	auipc	ra,0x1
    80002748:	120080e7          	jalr	288(ra) # 80003864 <log_write>
  brelse(bp);
    8000274c:	854a                	mv	a0,s2
    8000274e:	00000097          	auipc	ra,0x0
    80002752:	e92080e7          	jalr	-366(ra) # 800025e0 <brelse>
}
    80002756:	60e2                	ld	ra,24(sp)
    80002758:	6442                	ld	s0,16(sp)
    8000275a:	64a2                	ld	s1,8(sp)
    8000275c:	6902                	ld	s2,0(sp)
    8000275e:	6105                	addi	sp,sp,32
    80002760:	8082                	ret
    panic("freeing free block");
    80002762:	00006517          	auipc	a0,0x6
    80002766:	dce50513          	addi	a0,a0,-562 # 80008530 <syscalls+0x130>
    8000276a:	00003097          	auipc	ra,0x3
    8000276e:	5e6080e7          	jalr	1510(ra) # 80005d50 <panic>

0000000080002772 <balloc>:
{
    80002772:	711d                	addi	sp,sp,-96
    80002774:	ec86                	sd	ra,88(sp)
    80002776:	e8a2                	sd	s0,80(sp)
    80002778:	e4a6                	sd	s1,72(sp)
    8000277a:	e0ca                	sd	s2,64(sp)
    8000277c:	fc4e                	sd	s3,56(sp)
    8000277e:	f852                	sd	s4,48(sp)
    80002780:	f456                	sd	s5,40(sp)
    80002782:	f05a                	sd	s6,32(sp)
    80002784:	ec5e                	sd	s7,24(sp)
    80002786:	e862                	sd	s8,16(sp)
    80002788:	e466                	sd	s9,8(sp)
    8000278a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000278c:	00015797          	auipc	a5,0x15
    80002790:	fd07a783          	lw	a5,-48(a5) # 8001775c <sb+0x4>
    80002794:	cbc1                	beqz	a5,80002824 <balloc+0xb2>
    80002796:	8baa                	mv	s7,a0
    80002798:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000279a:	00015b17          	auipc	s6,0x15
    8000279e:	fbeb0b13          	addi	s6,s6,-66 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027a2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027a4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027a6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027a8:	6c89                	lui	s9,0x2
    800027aa:	a831                	j	800027c6 <balloc+0x54>
    brelse(bp);
    800027ac:	854a                	mv	a0,s2
    800027ae:	00000097          	auipc	ra,0x0
    800027b2:	e32080e7          	jalr	-462(ra) # 800025e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027b6:	015c87bb          	addw	a5,s9,s5
    800027ba:	00078a9b          	sext.w	s5,a5
    800027be:	004b2703          	lw	a4,4(s6)
    800027c2:	06eaf163          	bgeu	s5,a4,80002824 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800027c6:	41fad79b          	sraiw	a5,s5,0x1f
    800027ca:	0137d79b          	srliw	a5,a5,0x13
    800027ce:	015787bb          	addw	a5,a5,s5
    800027d2:	40d7d79b          	sraiw	a5,a5,0xd
    800027d6:	01cb2583          	lw	a1,28(s6)
    800027da:	9dbd                	addw	a1,a1,a5
    800027dc:	855e                	mv	a0,s7
    800027de:	00000097          	auipc	ra,0x0
    800027e2:	cd2080e7          	jalr	-814(ra) # 800024b0 <bread>
    800027e6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027e8:	004b2503          	lw	a0,4(s6)
    800027ec:	000a849b          	sext.w	s1,s5
    800027f0:	8762                	mv	a4,s8
    800027f2:	faa4fde3          	bgeu	s1,a0,800027ac <balloc+0x3a>
      m = 1 << (bi % 8);
    800027f6:	00777693          	andi	a3,a4,7
    800027fa:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027fe:	41f7579b          	sraiw	a5,a4,0x1f
    80002802:	01d7d79b          	srliw	a5,a5,0x1d
    80002806:	9fb9                	addw	a5,a5,a4
    80002808:	4037d79b          	sraiw	a5,a5,0x3
    8000280c:	00f90633          	add	a2,s2,a5
    80002810:	05864603          	lbu	a2,88(a2)
    80002814:	00c6f5b3          	and	a1,a3,a2
    80002818:	cd91                	beqz	a1,80002834 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000281a:	2705                	addiw	a4,a4,1
    8000281c:	2485                	addiw	s1,s1,1
    8000281e:	fd471ae3          	bne	a4,s4,800027f2 <balloc+0x80>
    80002822:	b769                	j	800027ac <balloc+0x3a>
  panic("balloc: out of blocks");
    80002824:	00006517          	auipc	a0,0x6
    80002828:	d2450513          	addi	a0,a0,-732 # 80008548 <syscalls+0x148>
    8000282c:	00003097          	auipc	ra,0x3
    80002830:	524080e7          	jalr	1316(ra) # 80005d50 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002834:	97ca                	add	a5,a5,s2
    80002836:	8e55                	or	a2,a2,a3
    80002838:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000283c:	854a                	mv	a0,s2
    8000283e:	00001097          	auipc	ra,0x1
    80002842:	026080e7          	jalr	38(ra) # 80003864 <log_write>
        brelse(bp);
    80002846:	854a                	mv	a0,s2
    80002848:	00000097          	auipc	ra,0x0
    8000284c:	d98080e7          	jalr	-616(ra) # 800025e0 <brelse>
  bp = bread(dev, bno);
    80002850:	85a6                	mv	a1,s1
    80002852:	855e                	mv	a0,s7
    80002854:	00000097          	auipc	ra,0x0
    80002858:	c5c080e7          	jalr	-932(ra) # 800024b0 <bread>
    8000285c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000285e:	40000613          	li	a2,1024
    80002862:	4581                	li	a1,0
    80002864:	05850513          	addi	a0,a0,88
    80002868:	ffffe097          	auipc	ra,0xffffe
    8000286c:	912080e7          	jalr	-1774(ra) # 8000017a <memset>
  log_write(bp);
    80002870:	854a                	mv	a0,s2
    80002872:	00001097          	auipc	ra,0x1
    80002876:	ff2080e7          	jalr	-14(ra) # 80003864 <log_write>
  brelse(bp);
    8000287a:	854a                	mv	a0,s2
    8000287c:	00000097          	auipc	ra,0x0
    80002880:	d64080e7          	jalr	-668(ra) # 800025e0 <brelse>
}
    80002884:	8526                	mv	a0,s1
    80002886:	60e6                	ld	ra,88(sp)
    80002888:	6446                	ld	s0,80(sp)
    8000288a:	64a6                	ld	s1,72(sp)
    8000288c:	6906                	ld	s2,64(sp)
    8000288e:	79e2                	ld	s3,56(sp)
    80002890:	7a42                	ld	s4,48(sp)
    80002892:	7aa2                	ld	s5,40(sp)
    80002894:	7b02                	ld	s6,32(sp)
    80002896:	6be2                	ld	s7,24(sp)
    80002898:	6c42                	ld	s8,16(sp)
    8000289a:	6ca2                	ld	s9,8(sp)
    8000289c:	6125                	addi	sp,sp,96
    8000289e:	8082                	ret

00000000800028a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028a0:	7179                	addi	sp,sp,-48
    800028a2:	f406                	sd	ra,40(sp)
    800028a4:	f022                	sd	s0,32(sp)
    800028a6:	ec26                	sd	s1,24(sp)
    800028a8:	e84a                	sd	s2,16(sp)
    800028aa:	e44e                	sd	s3,8(sp)
    800028ac:	e052                	sd	s4,0(sp)
    800028ae:	1800                	addi	s0,sp,48
    800028b0:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028b2:	47ad                	li	a5,11
    800028b4:	04b7fe63          	bgeu	a5,a1,80002910 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028b8:	ff45849b          	addiw	s1,a1,-12
    800028bc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028c0:	0ff00793          	li	a5,255
    800028c4:	0ae7e463          	bltu	a5,a4,8000296c <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800028c8:	08052583          	lw	a1,128(a0)
    800028cc:	c5b5                	beqz	a1,80002938 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028ce:	00092503          	lw	a0,0(s2)
    800028d2:	00000097          	auipc	ra,0x0
    800028d6:	bde080e7          	jalr	-1058(ra) # 800024b0 <bread>
    800028da:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028dc:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028e0:	02049713          	slli	a4,s1,0x20
    800028e4:	01e75593          	srli	a1,a4,0x1e
    800028e8:	00b784b3          	add	s1,a5,a1
    800028ec:	0004a983          	lw	s3,0(s1)
    800028f0:	04098e63          	beqz	s3,8000294c <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800028f4:	8552                	mv	a0,s4
    800028f6:	00000097          	auipc	ra,0x0
    800028fa:	cea080e7          	jalr	-790(ra) # 800025e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028fe:	854e                	mv	a0,s3
    80002900:	70a2                	ld	ra,40(sp)
    80002902:	7402                	ld	s0,32(sp)
    80002904:	64e2                	ld	s1,24(sp)
    80002906:	6942                	ld	s2,16(sp)
    80002908:	69a2                	ld	s3,8(sp)
    8000290a:	6a02                	ld	s4,0(sp)
    8000290c:	6145                	addi	sp,sp,48
    8000290e:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002910:	02059793          	slli	a5,a1,0x20
    80002914:	01e7d593          	srli	a1,a5,0x1e
    80002918:	00b504b3          	add	s1,a0,a1
    8000291c:	0504a983          	lw	s3,80(s1)
    80002920:	fc099fe3          	bnez	s3,800028fe <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002924:	4108                	lw	a0,0(a0)
    80002926:	00000097          	auipc	ra,0x0
    8000292a:	e4c080e7          	jalr	-436(ra) # 80002772 <balloc>
    8000292e:	0005099b          	sext.w	s3,a0
    80002932:	0534a823          	sw	s3,80(s1)
    80002936:	b7e1                	j	800028fe <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002938:	4108                	lw	a0,0(a0)
    8000293a:	00000097          	auipc	ra,0x0
    8000293e:	e38080e7          	jalr	-456(ra) # 80002772 <balloc>
    80002942:	0005059b          	sext.w	a1,a0
    80002946:	08b92023          	sw	a1,128(s2)
    8000294a:	b751                	j	800028ce <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000294c:	00092503          	lw	a0,0(s2)
    80002950:	00000097          	auipc	ra,0x0
    80002954:	e22080e7          	jalr	-478(ra) # 80002772 <balloc>
    80002958:	0005099b          	sext.w	s3,a0
    8000295c:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002960:	8552                	mv	a0,s4
    80002962:	00001097          	auipc	ra,0x1
    80002966:	f02080e7          	jalr	-254(ra) # 80003864 <log_write>
    8000296a:	b769                	j	800028f4 <bmap+0x54>
  panic("bmap: out of range");
    8000296c:	00006517          	auipc	a0,0x6
    80002970:	bf450513          	addi	a0,a0,-1036 # 80008560 <syscalls+0x160>
    80002974:	00003097          	auipc	ra,0x3
    80002978:	3dc080e7          	jalr	988(ra) # 80005d50 <panic>

000000008000297c <iget>:
{
    8000297c:	7179                	addi	sp,sp,-48
    8000297e:	f406                	sd	ra,40(sp)
    80002980:	f022                	sd	s0,32(sp)
    80002982:	ec26                	sd	s1,24(sp)
    80002984:	e84a                	sd	s2,16(sp)
    80002986:	e44e                	sd	s3,8(sp)
    80002988:	e052                	sd	s4,0(sp)
    8000298a:	1800                	addi	s0,sp,48
    8000298c:	89aa                	mv	s3,a0
    8000298e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002990:	00015517          	auipc	a0,0x15
    80002994:	de850513          	addi	a0,a0,-536 # 80017778 <itable>
    80002998:	00004097          	auipc	ra,0x4
    8000299c:	8f0080e7          	jalr	-1808(ra) # 80006288 <acquire>
  empty = 0;
    800029a0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029a2:	00015497          	auipc	s1,0x15
    800029a6:	dee48493          	addi	s1,s1,-530 # 80017790 <itable+0x18>
    800029aa:	00017697          	auipc	a3,0x17
    800029ae:	87668693          	addi	a3,a3,-1930 # 80019220 <log>
    800029b2:	a039                	j	800029c0 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029b4:	02090b63          	beqz	s2,800029ea <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029b8:	08848493          	addi	s1,s1,136
    800029bc:	02d48a63          	beq	s1,a3,800029f0 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029c0:	449c                	lw	a5,8(s1)
    800029c2:	fef059e3          	blez	a5,800029b4 <iget+0x38>
    800029c6:	4098                	lw	a4,0(s1)
    800029c8:	ff3716e3          	bne	a4,s3,800029b4 <iget+0x38>
    800029cc:	40d8                	lw	a4,4(s1)
    800029ce:	ff4713e3          	bne	a4,s4,800029b4 <iget+0x38>
      ip->ref++;
    800029d2:	2785                	addiw	a5,a5,1
    800029d4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029d6:	00015517          	auipc	a0,0x15
    800029da:	da250513          	addi	a0,a0,-606 # 80017778 <itable>
    800029de:	00004097          	auipc	ra,0x4
    800029e2:	95e080e7          	jalr	-1698(ra) # 8000633c <release>
      return ip;
    800029e6:	8926                	mv	s2,s1
    800029e8:	a03d                	j	80002a16 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029ea:	f7f9                	bnez	a5,800029b8 <iget+0x3c>
    800029ec:	8926                	mv	s2,s1
    800029ee:	b7e9                	j	800029b8 <iget+0x3c>
  if(empty == 0)
    800029f0:	02090c63          	beqz	s2,80002a28 <iget+0xac>
  ip->dev = dev;
    800029f4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029f8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029fc:	4785                	li	a5,1
    800029fe:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a02:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a06:	00015517          	auipc	a0,0x15
    80002a0a:	d7250513          	addi	a0,a0,-654 # 80017778 <itable>
    80002a0e:	00004097          	auipc	ra,0x4
    80002a12:	92e080e7          	jalr	-1746(ra) # 8000633c <release>
}
    80002a16:	854a                	mv	a0,s2
    80002a18:	70a2                	ld	ra,40(sp)
    80002a1a:	7402                	ld	s0,32(sp)
    80002a1c:	64e2                	ld	s1,24(sp)
    80002a1e:	6942                	ld	s2,16(sp)
    80002a20:	69a2                	ld	s3,8(sp)
    80002a22:	6a02                	ld	s4,0(sp)
    80002a24:	6145                	addi	sp,sp,48
    80002a26:	8082                	ret
    panic("iget: no inodes");
    80002a28:	00006517          	auipc	a0,0x6
    80002a2c:	b5050513          	addi	a0,a0,-1200 # 80008578 <syscalls+0x178>
    80002a30:	00003097          	auipc	ra,0x3
    80002a34:	320080e7          	jalr	800(ra) # 80005d50 <panic>

0000000080002a38 <fsinit>:
fsinit(int dev) {
    80002a38:	7179                	addi	sp,sp,-48
    80002a3a:	f406                	sd	ra,40(sp)
    80002a3c:	f022                	sd	s0,32(sp)
    80002a3e:	ec26                	sd	s1,24(sp)
    80002a40:	e84a                	sd	s2,16(sp)
    80002a42:	e44e                	sd	s3,8(sp)
    80002a44:	1800                	addi	s0,sp,48
    80002a46:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a48:	4585                	li	a1,1
    80002a4a:	00000097          	auipc	ra,0x0
    80002a4e:	a66080e7          	jalr	-1434(ra) # 800024b0 <bread>
    80002a52:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a54:	00015997          	auipc	s3,0x15
    80002a58:	d0498993          	addi	s3,s3,-764 # 80017758 <sb>
    80002a5c:	02000613          	li	a2,32
    80002a60:	05850593          	addi	a1,a0,88
    80002a64:	854e                	mv	a0,s3
    80002a66:	ffffd097          	auipc	ra,0xffffd
    80002a6a:	770080e7          	jalr	1904(ra) # 800001d6 <memmove>
  brelse(bp);
    80002a6e:	8526                	mv	a0,s1
    80002a70:	00000097          	auipc	ra,0x0
    80002a74:	b70080e7          	jalr	-1168(ra) # 800025e0 <brelse>
  if(sb.magic != FSMAGIC)
    80002a78:	0009a703          	lw	a4,0(s3)
    80002a7c:	102037b7          	lui	a5,0x10203
    80002a80:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a84:	02f71263          	bne	a4,a5,80002aa8 <fsinit+0x70>
  initlog(dev, &sb);
    80002a88:	00015597          	auipc	a1,0x15
    80002a8c:	cd058593          	addi	a1,a1,-816 # 80017758 <sb>
    80002a90:	854a                	mv	a0,s2
    80002a92:	00001097          	auipc	ra,0x1
    80002a96:	b56080e7          	jalr	-1194(ra) # 800035e8 <initlog>
}
    80002a9a:	70a2                	ld	ra,40(sp)
    80002a9c:	7402                	ld	s0,32(sp)
    80002a9e:	64e2                	ld	s1,24(sp)
    80002aa0:	6942                	ld	s2,16(sp)
    80002aa2:	69a2                	ld	s3,8(sp)
    80002aa4:	6145                	addi	sp,sp,48
    80002aa6:	8082                	ret
    panic("invalid file system");
    80002aa8:	00006517          	auipc	a0,0x6
    80002aac:	ae050513          	addi	a0,a0,-1312 # 80008588 <syscalls+0x188>
    80002ab0:	00003097          	auipc	ra,0x3
    80002ab4:	2a0080e7          	jalr	672(ra) # 80005d50 <panic>

0000000080002ab8 <iinit>:
{
    80002ab8:	7179                	addi	sp,sp,-48
    80002aba:	f406                	sd	ra,40(sp)
    80002abc:	f022                	sd	s0,32(sp)
    80002abe:	ec26                	sd	s1,24(sp)
    80002ac0:	e84a                	sd	s2,16(sp)
    80002ac2:	e44e                	sd	s3,8(sp)
    80002ac4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002ac6:	00006597          	auipc	a1,0x6
    80002aca:	ada58593          	addi	a1,a1,-1318 # 800085a0 <syscalls+0x1a0>
    80002ace:	00015517          	auipc	a0,0x15
    80002ad2:	caa50513          	addi	a0,a0,-854 # 80017778 <itable>
    80002ad6:	00003097          	auipc	ra,0x3
    80002ada:	722080e7          	jalr	1826(ra) # 800061f8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ade:	00015497          	auipc	s1,0x15
    80002ae2:	cc248493          	addi	s1,s1,-830 # 800177a0 <itable+0x28>
    80002ae6:	00016997          	auipc	s3,0x16
    80002aea:	74a98993          	addi	s3,s3,1866 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002aee:	00006917          	auipc	s2,0x6
    80002af2:	aba90913          	addi	s2,s2,-1350 # 800085a8 <syscalls+0x1a8>
    80002af6:	85ca                	mv	a1,s2
    80002af8:	8526                	mv	a0,s1
    80002afa:	00001097          	auipc	ra,0x1
    80002afe:	e4e080e7          	jalr	-434(ra) # 80003948 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b02:	08848493          	addi	s1,s1,136
    80002b06:	ff3498e3          	bne	s1,s3,80002af6 <iinit+0x3e>
}
    80002b0a:	70a2                	ld	ra,40(sp)
    80002b0c:	7402                	ld	s0,32(sp)
    80002b0e:	64e2                	ld	s1,24(sp)
    80002b10:	6942                	ld	s2,16(sp)
    80002b12:	69a2                	ld	s3,8(sp)
    80002b14:	6145                	addi	sp,sp,48
    80002b16:	8082                	ret

0000000080002b18 <ialloc>:
{
    80002b18:	715d                	addi	sp,sp,-80
    80002b1a:	e486                	sd	ra,72(sp)
    80002b1c:	e0a2                	sd	s0,64(sp)
    80002b1e:	fc26                	sd	s1,56(sp)
    80002b20:	f84a                	sd	s2,48(sp)
    80002b22:	f44e                	sd	s3,40(sp)
    80002b24:	f052                	sd	s4,32(sp)
    80002b26:	ec56                	sd	s5,24(sp)
    80002b28:	e85a                	sd	s6,16(sp)
    80002b2a:	e45e                	sd	s7,8(sp)
    80002b2c:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b2e:	00015717          	auipc	a4,0x15
    80002b32:	c3672703          	lw	a4,-970(a4) # 80017764 <sb+0xc>
    80002b36:	4785                	li	a5,1
    80002b38:	04e7fa63          	bgeu	a5,a4,80002b8c <ialloc+0x74>
    80002b3c:	8aaa                	mv	s5,a0
    80002b3e:	8bae                	mv	s7,a1
    80002b40:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b42:	00015a17          	auipc	s4,0x15
    80002b46:	c16a0a13          	addi	s4,s4,-1002 # 80017758 <sb>
    80002b4a:	00048b1b          	sext.w	s6,s1
    80002b4e:	0044d593          	srli	a1,s1,0x4
    80002b52:	018a2783          	lw	a5,24(s4)
    80002b56:	9dbd                	addw	a1,a1,a5
    80002b58:	8556                	mv	a0,s5
    80002b5a:	00000097          	auipc	ra,0x0
    80002b5e:	956080e7          	jalr	-1706(ra) # 800024b0 <bread>
    80002b62:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b64:	05850993          	addi	s3,a0,88
    80002b68:	00f4f793          	andi	a5,s1,15
    80002b6c:	079a                	slli	a5,a5,0x6
    80002b6e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b70:	00099783          	lh	a5,0(s3)
    80002b74:	c785                	beqz	a5,80002b9c <ialloc+0x84>
    brelse(bp);
    80002b76:	00000097          	auipc	ra,0x0
    80002b7a:	a6a080e7          	jalr	-1430(ra) # 800025e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b7e:	0485                	addi	s1,s1,1
    80002b80:	00ca2703          	lw	a4,12(s4)
    80002b84:	0004879b          	sext.w	a5,s1
    80002b88:	fce7e1e3          	bltu	a5,a4,80002b4a <ialloc+0x32>
  panic("ialloc: no inodes");
    80002b8c:	00006517          	auipc	a0,0x6
    80002b90:	a2450513          	addi	a0,a0,-1500 # 800085b0 <syscalls+0x1b0>
    80002b94:	00003097          	auipc	ra,0x3
    80002b98:	1bc080e7          	jalr	444(ra) # 80005d50 <panic>
      memset(dip, 0, sizeof(*dip));
    80002b9c:	04000613          	li	a2,64
    80002ba0:	4581                	li	a1,0
    80002ba2:	854e                	mv	a0,s3
    80002ba4:	ffffd097          	auipc	ra,0xffffd
    80002ba8:	5d6080e7          	jalr	1494(ra) # 8000017a <memset>
      dip->type = type;
    80002bac:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bb0:	854a                	mv	a0,s2
    80002bb2:	00001097          	auipc	ra,0x1
    80002bb6:	cb2080e7          	jalr	-846(ra) # 80003864 <log_write>
      brelse(bp);
    80002bba:	854a                	mv	a0,s2
    80002bbc:	00000097          	auipc	ra,0x0
    80002bc0:	a24080e7          	jalr	-1500(ra) # 800025e0 <brelse>
      return iget(dev, inum);
    80002bc4:	85da                	mv	a1,s6
    80002bc6:	8556                	mv	a0,s5
    80002bc8:	00000097          	auipc	ra,0x0
    80002bcc:	db4080e7          	jalr	-588(ra) # 8000297c <iget>
}
    80002bd0:	60a6                	ld	ra,72(sp)
    80002bd2:	6406                	ld	s0,64(sp)
    80002bd4:	74e2                	ld	s1,56(sp)
    80002bd6:	7942                	ld	s2,48(sp)
    80002bd8:	79a2                	ld	s3,40(sp)
    80002bda:	7a02                	ld	s4,32(sp)
    80002bdc:	6ae2                	ld	s5,24(sp)
    80002bde:	6b42                	ld	s6,16(sp)
    80002be0:	6ba2                	ld	s7,8(sp)
    80002be2:	6161                	addi	sp,sp,80
    80002be4:	8082                	ret

0000000080002be6 <iupdate>:
{
    80002be6:	1101                	addi	sp,sp,-32
    80002be8:	ec06                	sd	ra,24(sp)
    80002bea:	e822                	sd	s0,16(sp)
    80002bec:	e426                	sd	s1,8(sp)
    80002bee:	e04a                	sd	s2,0(sp)
    80002bf0:	1000                	addi	s0,sp,32
    80002bf2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bf4:	415c                	lw	a5,4(a0)
    80002bf6:	0047d79b          	srliw	a5,a5,0x4
    80002bfa:	00015597          	auipc	a1,0x15
    80002bfe:	b765a583          	lw	a1,-1162(a1) # 80017770 <sb+0x18>
    80002c02:	9dbd                	addw	a1,a1,a5
    80002c04:	4108                	lw	a0,0(a0)
    80002c06:	00000097          	auipc	ra,0x0
    80002c0a:	8aa080e7          	jalr	-1878(ra) # 800024b0 <bread>
    80002c0e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c10:	05850793          	addi	a5,a0,88
    80002c14:	40d8                	lw	a4,4(s1)
    80002c16:	8b3d                	andi	a4,a4,15
    80002c18:	071a                	slli	a4,a4,0x6
    80002c1a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c1c:	04449703          	lh	a4,68(s1)
    80002c20:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c24:	04649703          	lh	a4,70(s1)
    80002c28:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c2c:	04849703          	lh	a4,72(s1)
    80002c30:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c34:	04a49703          	lh	a4,74(s1)
    80002c38:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c3c:	44f8                	lw	a4,76(s1)
    80002c3e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c40:	03400613          	li	a2,52
    80002c44:	05048593          	addi	a1,s1,80
    80002c48:	00c78513          	addi	a0,a5,12
    80002c4c:	ffffd097          	auipc	ra,0xffffd
    80002c50:	58a080e7          	jalr	1418(ra) # 800001d6 <memmove>
  log_write(bp);
    80002c54:	854a                	mv	a0,s2
    80002c56:	00001097          	auipc	ra,0x1
    80002c5a:	c0e080e7          	jalr	-1010(ra) # 80003864 <log_write>
  brelse(bp);
    80002c5e:	854a                	mv	a0,s2
    80002c60:	00000097          	auipc	ra,0x0
    80002c64:	980080e7          	jalr	-1664(ra) # 800025e0 <brelse>
}
    80002c68:	60e2                	ld	ra,24(sp)
    80002c6a:	6442                	ld	s0,16(sp)
    80002c6c:	64a2                	ld	s1,8(sp)
    80002c6e:	6902                	ld	s2,0(sp)
    80002c70:	6105                	addi	sp,sp,32
    80002c72:	8082                	ret

0000000080002c74 <idup>:
{
    80002c74:	1101                	addi	sp,sp,-32
    80002c76:	ec06                	sd	ra,24(sp)
    80002c78:	e822                	sd	s0,16(sp)
    80002c7a:	e426                	sd	s1,8(sp)
    80002c7c:	1000                	addi	s0,sp,32
    80002c7e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c80:	00015517          	auipc	a0,0x15
    80002c84:	af850513          	addi	a0,a0,-1288 # 80017778 <itable>
    80002c88:	00003097          	auipc	ra,0x3
    80002c8c:	600080e7          	jalr	1536(ra) # 80006288 <acquire>
  ip->ref++;
    80002c90:	449c                	lw	a5,8(s1)
    80002c92:	2785                	addiw	a5,a5,1
    80002c94:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c96:	00015517          	auipc	a0,0x15
    80002c9a:	ae250513          	addi	a0,a0,-1310 # 80017778 <itable>
    80002c9e:	00003097          	auipc	ra,0x3
    80002ca2:	69e080e7          	jalr	1694(ra) # 8000633c <release>
}
    80002ca6:	8526                	mv	a0,s1
    80002ca8:	60e2                	ld	ra,24(sp)
    80002caa:	6442                	ld	s0,16(sp)
    80002cac:	64a2                	ld	s1,8(sp)
    80002cae:	6105                	addi	sp,sp,32
    80002cb0:	8082                	ret

0000000080002cb2 <ilock>:
{
    80002cb2:	1101                	addi	sp,sp,-32
    80002cb4:	ec06                	sd	ra,24(sp)
    80002cb6:	e822                	sd	s0,16(sp)
    80002cb8:	e426                	sd	s1,8(sp)
    80002cba:	e04a                	sd	s2,0(sp)
    80002cbc:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002cbe:	c115                	beqz	a0,80002ce2 <ilock+0x30>
    80002cc0:	84aa                	mv	s1,a0
    80002cc2:	451c                	lw	a5,8(a0)
    80002cc4:	00f05f63          	blez	a5,80002ce2 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002cc8:	0541                	addi	a0,a0,16
    80002cca:	00001097          	auipc	ra,0x1
    80002cce:	cb8080e7          	jalr	-840(ra) # 80003982 <acquiresleep>
  if(ip->valid == 0){
    80002cd2:	40bc                	lw	a5,64(s1)
    80002cd4:	cf99                	beqz	a5,80002cf2 <ilock+0x40>
}
    80002cd6:	60e2                	ld	ra,24(sp)
    80002cd8:	6442                	ld	s0,16(sp)
    80002cda:	64a2                	ld	s1,8(sp)
    80002cdc:	6902                	ld	s2,0(sp)
    80002cde:	6105                	addi	sp,sp,32
    80002ce0:	8082                	ret
    panic("ilock");
    80002ce2:	00006517          	auipc	a0,0x6
    80002ce6:	8e650513          	addi	a0,a0,-1818 # 800085c8 <syscalls+0x1c8>
    80002cea:	00003097          	auipc	ra,0x3
    80002cee:	066080e7          	jalr	102(ra) # 80005d50 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cf2:	40dc                	lw	a5,4(s1)
    80002cf4:	0047d79b          	srliw	a5,a5,0x4
    80002cf8:	00015597          	auipc	a1,0x15
    80002cfc:	a785a583          	lw	a1,-1416(a1) # 80017770 <sb+0x18>
    80002d00:	9dbd                	addw	a1,a1,a5
    80002d02:	4088                	lw	a0,0(s1)
    80002d04:	fffff097          	auipc	ra,0xfffff
    80002d08:	7ac080e7          	jalr	1964(ra) # 800024b0 <bread>
    80002d0c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d0e:	05850593          	addi	a1,a0,88
    80002d12:	40dc                	lw	a5,4(s1)
    80002d14:	8bbd                	andi	a5,a5,15
    80002d16:	079a                	slli	a5,a5,0x6
    80002d18:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d1a:	00059783          	lh	a5,0(a1)
    80002d1e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d22:	00259783          	lh	a5,2(a1)
    80002d26:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d2a:	00459783          	lh	a5,4(a1)
    80002d2e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d32:	00659783          	lh	a5,6(a1)
    80002d36:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d3a:	459c                	lw	a5,8(a1)
    80002d3c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d3e:	03400613          	li	a2,52
    80002d42:	05b1                	addi	a1,a1,12
    80002d44:	05048513          	addi	a0,s1,80
    80002d48:	ffffd097          	auipc	ra,0xffffd
    80002d4c:	48e080e7          	jalr	1166(ra) # 800001d6 <memmove>
    brelse(bp);
    80002d50:	854a                	mv	a0,s2
    80002d52:	00000097          	auipc	ra,0x0
    80002d56:	88e080e7          	jalr	-1906(ra) # 800025e0 <brelse>
    ip->valid = 1;
    80002d5a:	4785                	li	a5,1
    80002d5c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d5e:	04449783          	lh	a5,68(s1)
    80002d62:	fbb5                	bnez	a5,80002cd6 <ilock+0x24>
      panic("ilock: no type");
    80002d64:	00006517          	auipc	a0,0x6
    80002d68:	86c50513          	addi	a0,a0,-1940 # 800085d0 <syscalls+0x1d0>
    80002d6c:	00003097          	auipc	ra,0x3
    80002d70:	fe4080e7          	jalr	-28(ra) # 80005d50 <panic>

0000000080002d74 <iunlock>:
{
    80002d74:	1101                	addi	sp,sp,-32
    80002d76:	ec06                	sd	ra,24(sp)
    80002d78:	e822                	sd	s0,16(sp)
    80002d7a:	e426                	sd	s1,8(sp)
    80002d7c:	e04a                	sd	s2,0(sp)
    80002d7e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d80:	c905                	beqz	a0,80002db0 <iunlock+0x3c>
    80002d82:	84aa                	mv	s1,a0
    80002d84:	01050913          	addi	s2,a0,16
    80002d88:	854a                	mv	a0,s2
    80002d8a:	00001097          	auipc	ra,0x1
    80002d8e:	c92080e7          	jalr	-878(ra) # 80003a1c <holdingsleep>
    80002d92:	cd19                	beqz	a0,80002db0 <iunlock+0x3c>
    80002d94:	449c                	lw	a5,8(s1)
    80002d96:	00f05d63          	blez	a5,80002db0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d9a:	854a                	mv	a0,s2
    80002d9c:	00001097          	auipc	ra,0x1
    80002da0:	c3c080e7          	jalr	-964(ra) # 800039d8 <releasesleep>
}
    80002da4:	60e2                	ld	ra,24(sp)
    80002da6:	6442                	ld	s0,16(sp)
    80002da8:	64a2                	ld	s1,8(sp)
    80002daa:	6902                	ld	s2,0(sp)
    80002dac:	6105                	addi	sp,sp,32
    80002dae:	8082                	ret
    panic("iunlock");
    80002db0:	00006517          	auipc	a0,0x6
    80002db4:	83050513          	addi	a0,a0,-2000 # 800085e0 <syscalls+0x1e0>
    80002db8:	00003097          	auipc	ra,0x3
    80002dbc:	f98080e7          	jalr	-104(ra) # 80005d50 <panic>

0000000080002dc0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002dc0:	7179                	addi	sp,sp,-48
    80002dc2:	f406                	sd	ra,40(sp)
    80002dc4:	f022                	sd	s0,32(sp)
    80002dc6:	ec26                	sd	s1,24(sp)
    80002dc8:	e84a                	sd	s2,16(sp)
    80002dca:	e44e                	sd	s3,8(sp)
    80002dcc:	e052                	sd	s4,0(sp)
    80002dce:	1800                	addi	s0,sp,48
    80002dd0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002dd2:	05050493          	addi	s1,a0,80
    80002dd6:	08050913          	addi	s2,a0,128
    80002dda:	a021                	j	80002de2 <itrunc+0x22>
    80002ddc:	0491                	addi	s1,s1,4
    80002dde:	01248d63          	beq	s1,s2,80002df8 <itrunc+0x38>
    if(ip->addrs[i]){
    80002de2:	408c                	lw	a1,0(s1)
    80002de4:	dde5                	beqz	a1,80002ddc <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002de6:	0009a503          	lw	a0,0(s3)
    80002dea:	00000097          	auipc	ra,0x0
    80002dee:	90c080e7          	jalr	-1780(ra) # 800026f6 <bfree>
      ip->addrs[i] = 0;
    80002df2:	0004a023          	sw	zero,0(s1)
    80002df6:	b7dd                	j	80002ddc <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002df8:	0809a583          	lw	a1,128(s3)
    80002dfc:	e185                	bnez	a1,80002e1c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002dfe:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e02:	854e                	mv	a0,s3
    80002e04:	00000097          	auipc	ra,0x0
    80002e08:	de2080e7          	jalr	-542(ra) # 80002be6 <iupdate>
}
    80002e0c:	70a2                	ld	ra,40(sp)
    80002e0e:	7402                	ld	s0,32(sp)
    80002e10:	64e2                	ld	s1,24(sp)
    80002e12:	6942                	ld	s2,16(sp)
    80002e14:	69a2                	ld	s3,8(sp)
    80002e16:	6a02                	ld	s4,0(sp)
    80002e18:	6145                	addi	sp,sp,48
    80002e1a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e1c:	0009a503          	lw	a0,0(s3)
    80002e20:	fffff097          	auipc	ra,0xfffff
    80002e24:	690080e7          	jalr	1680(ra) # 800024b0 <bread>
    80002e28:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e2a:	05850493          	addi	s1,a0,88
    80002e2e:	45850913          	addi	s2,a0,1112
    80002e32:	a021                	j	80002e3a <itrunc+0x7a>
    80002e34:	0491                	addi	s1,s1,4
    80002e36:	01248b63          	beq	s1,s2,80002e4c <itrunc+0x8c>
      if(a[j])
    80002e3a:	408c                	lw	a1,0(s1)
    80002e3c:	dde5                	beqz	a1,80002e34 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002e3e:	0009a503          	lw	a0,0(s3)
    80002e42:	00000097          	auipc	ra,0x0
    80002e46:	8b4080e7          	jalr	-1868(ra) # 800026f6 <bfree>
    80002e4a:	b7ed                	j	80002e34 <itrunc+0x74>
    brelse(bp);
    80002e4c:	8552                	mv	a0,s4
    80002e4e:	fffff097          	auipc	ra,0xfffff
    80002e52:	792080e7          	jalr	1938(ra) # 800025e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e56:	0809a583          	lw	a1,128(s3)
    80002e5a:	0009a503          	lw	a0,0(s3)
    80002e5e:	00000097          	auipc	ra,0x0
    80002e62:	898080e7          	jalr	-1896(ra) # 800026f6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e66:	0809a023          	sw	zero,128(s3)
    80002e6a:	bf51                	j	80002dfe <itrunc+0x3e>

0000000080002e6c <iput>:
{
    80002e6c:	1101                	addi	sp,sp,-32
    80002e6e:	ec06                	sd	ra,24(sp)
    80002e70:	e822                	sd	s0,16(sp)
    80002e72:	e426                	sd	s1,8(sp)
    80002e74:	e04a                	sd	s2,0(sp)
    80002e76:	1000                	addi	s0,sp,32
    80002e78:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e7a:	00015517          	auipc	a0,0x15
    80002e7e:	8fe50513          	addi	a0,a0,-1794 # 80017778 <itable>
    80002e82:	00003097          	auipc	ra,0x3
    80002e86:	406080e7          	jalr	1030(ra) # 80006288 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e8a:	4498                	lw	a4,8(s1)
    80002e8c:	4785                	li	a5,1
    80002e8e:	02f70363          	beq	a4,a5,80002eb4 <iput+0x48>
  ip->ref--;
    80002e92:	449c                	lw	a5,8(s1)
    80002e94:	37fd                	addiw	a5,a5,-1
    80002e96:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e98:	00015517          	auipc	a0,0x15
    80002e9c:	8e050513          	addi	a0,a0,-1824 # 80017778 <itable>
    80002ea0:	00003097          	auipc	ra,0x3
    80002ea4:	49c080e7          	jalr	1180(ra) # 8000633c <release>
}
    80002ea8:	60e2                	ld	ra,24(sp)
    80002eaa:	6442                	ld	s0,16(sp)
    80002eac:	64a2                	ld	s1,8(sp)
    80002eae:	6902                	ld	s2,0(sp)
    80002eb0:	6105                	addi	sp,sp,32
    80002eb2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002eb4:	40bc                	lw	a5,64(s1)
    80002eb6:	dff1                	beqz	a5,80002e92 <iput+0x26>
    80002eb8:	04a49783          	lh	a5,74(s1)
    80002ebc:	fbf9                	bnez	a5,80002e92 <iput+0x26>
    acquiresleep(&ip->lock);
    80002ebe:	01048913          	addi	s2,s1,16
    80002ec2:	854a                	mv	a0,s2
    80002ec4:	00001097          	auipc	ra,0x1
    80002ec8:	abe080e7          	jalr	-1346(ra) # 80003982 <acquiresleep>
    release(&itable.lock);
    80002ecc:	00015517          	auipc	a0,0x15
    80002ed0:	8ac50513          	addi	a0,a0,-1876 # 80017778 <itable>
    80002ed4:	00003097          	auipc	ra,0x3
    80002ed8:	468080e7          	jalr	1128(ra) # 8000633c <release>
    itrunc(ip);
    80002edc:	8526                	mv	a0,s1
    80002ede:	00000097          	auipc	ra,0x0
    80002ee2:	ee2080e7          	jalr	-286(ra) # 80002dc0 <itrunc>
    ip->type = 0;
    80002ee6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002eea:	8526                	mv	a0,s1
    80002eec:	00000097          	auipc	ra,0x0
    80002ef0:	cfa080e7          	jalr	-774(ra) # 80002be6 <iupdate>
    ip->valid = 0;
    80002ef4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ef8:	854a                	mv	a0,s2
    80002efa:	00001097          	auipc	ra,0x1
    80002efe:	ade080e7          	jalr	-1314(ra) # 800039d8 <releasesleep>
    acquire(&itable.lock);
    80002f02:	00015517          	auipc	a0,0x15
    80002f06:	87650513          	addi	a0,a0,-1930 # 80017778 <itable>
    80002f0a:	00003097          	auipc	ra,0x3
    80002f0e:	37e080e7          	jalr	894(ra) # 80006288 <acquire>
    80002f12:	b741                	j	80002e92 <iput+0x26>

0000000080002f14 <iunlockput>:
{
    80002f14:	1101                	addi	sp,sp,-32
    80002f16:	ec06                	sd	ra,24(sp)
    80002f18:	e822                	sd	s0,16(sp)
    80002f1a:	e426                	sd	s1,8(sp)
    80002f1c:	1000                	addi	s0,sp,32
    80002f1e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f20:	00000097          	auipc	ra,0x0
    80002f24:	e54080e7          	jalr	-428(ra) # 80002d74 <iunlock>
  iput(ip);
    80002f28:	8526                	mv	a0,s1
    80002f2a:	00000097          	auipc	ra,0x0
    80002f2e:	f42080e7          	jalr	-190(ra) # 80002e6c <iput>
}
    80002f32:	60e2                	ld	ra,24(sp)
    80002f34:	6442                	ld	s0,16(sp)
    80002f36:	64a2                	ld	s1,8(sp)
    80002f38:	6105                	addi	sp,sp,32
    80002f3a:	8082                	ret

0000000080002f3c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f3c:	1141                	addi	sp,sp,-16
    80002f3e:	e422                	sd	s0,8(sp)
    80002f40:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f42:	411c                	lw	a5,0(a0)
    80002f44:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f46:	415c                	lw	a5,4(a0)
    80002f48:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f4a:	04451783          	lh	a5,68(a0)
    80002f4e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f52:	04a51783          	lh	a5,74(a0)
    80002f56:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f5a:	04c56783          	lwu	a5,76(a0)
    80002f5e:	e99c                	sd	a5,16(a1)
}
    80002f60:	6422                	ld	s0,8(sp)
    80002f62:	0141                	addi	sp,sp,16
    80002f64:	8082                	ret

0000000080002f66 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f66:	457c                	lw	a5,76(a0)
    80002f68:	0ed7e963          	bltu	a5,a3,8000305a <readi+0xf4>
{
    80002f6c:	7159                	addi	sp,sp,-112
    80002f6e:	f486                	sd	ra,104(sp)
    80002f70:	f0a2                	sd	s0,96(sp)
    80002f72:	eca6                	sd	s1,88(sp)
    80002f74:	e8ca                	sd	s2,80(sp)
    80002f76:	e4ce                	sd	s3,72(sp)
    80002f78:	e0d2                	sd	s4,64(sp)
    80002f7a:	fc56                	sd	s5,56(sp)
    80002f7c:	f85a                	sd	s6,48(sp)
    80002f7e:	f45e                	sd	s7,40(sp)
    80002f80:	f062                	sd	s8,32(sp)
    80002f82:	ec66                	sd	s9,24(sp)
    80002f84:	e86a                	sd	s10,16(sp)
    80002f86:	e46e                	sd	s11,8(sp)
    80002f88:	1880                	addi	s0,sp,112
    80002f8a:	8baa                	mv	s7,a0
    80002f8c:	8c2e                	mv	s8,a1
    80002f8e:	8ab2                	mv	s5,a2
    80002f90:	84b6                	mv	s1,a3
    80002f92:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f94:	9f35                	addw	a4,a4,a3
    return 0;
    80002f96:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f98:	0ad76063          	bltu	a4,a3,80003038 <readi+0xd2>
  if(off + n > ip->size)
    80002f9c:	00e7f463          	bgeu	a5,a4,80002fa4 <readi+0x3e>
    n = ip->size - off;
    80002fa0:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fa4:	0a0b0963          	beqz	s6,80003056 <readi+0xf0>
    80002fa8:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002faa:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fae:	5cfd                	li	s9,-1
    80002fb0:	a82d                	j	80002fea <readi+0x84>
    80002fb2:	020a1d93          	slli	s11,s4,0x20
    80002fb6:	020ddd93          	srli	s11,s11,0x20
    80002fba:	05890613          	addi	a2,s2,88
    80002fbe:	86ee                	mv	a3,s11
    80002fc0:	963a                	add	a2,a2,a4
    80002fc2:	85d6                	mv	a1,s5
    80002fc4:	8562                	mv	a0,s8
    80002fc6:	fffff097          	auipc	ra,0xfffff
    80002fca:	aa2080e7          	jalr	-1374(ra) # 80001a68 <either_copyout>
    80002fce:	05950d63          	beq	a0,s9,80003028 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fd2:	854a                	mv	a0,s2
    80002fd4:	fffff097          	auipc	ra,0xfffff
    80002fd8:	60c080e7          	jalr	1548(ra) # 800025e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fdc:	013a09bb          	addw	s3,s4,s3
    80002fe0:	009a04bb          	addw	s1,s4,s1
    80002fe4:	9aee                	add	s5,s5,s11
    80002fe6:	0569f763          	bgeu	s3,s6,80003034 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fea:	000ba903          	lw	s2,0(s7)
    80002fee:	00a4d59b          	srliw	a1,s1,0xa
    80002ff2:	855e                	mv	a0,s7
    80002ff4:	00000097          	auipc	ra,0x0
    80002ff8:	8ac080e7          	jalr	-1876(ra) # 800028a0 <bmap>
    80002ffc:	0005059b          	sext.w	a1,a0
    80003000:	854a                	mv	a0,s2
    80003002:	fffff097          	auipc	ra,0xfffff
    80003006:	4ae080e7          	jalr	1198(ra) # 800024b0 <bread>
    8000300a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000300c:	3ff4f713          	andi	a4,s1,1023
    80003010:	40ed07bb          	subw	a5,s10,a4
    80003014:	413b06bb          	subw	a3,s6,s3
    80003018:	8a3e                	mv	s4,a5
    8000301a:	2781                	sext.w	a5,a5
    8000301c:	0006861b          	sext.w	a2,a3
    80003020:	f8f679e3          	bgeu	a2,a5,80002fb2 <readi+0x4c>
    80003024:	8a36                	mv	s4,a3
    80003026:	b771                	j	80002fb2 <readi+0x4c>
      brelse(bp);
    80003028:	854a                	mv	a0,s2
    8000302a:	fffff097          	auipc	ra,0xfffff
    8000302e:	5b6080e7          	jalr	1462(ra) # 800025e0 <brelse>
      tot = -1;
    80003032:	59fd                	li	s3,-1
  }
  return tot;
    80003034:	0009851b          	sext.w	a0,s3
}
    80003038:	70a6                	ld	ra,104(sp)
    8000303a:	7406                	ld	s0,96(sp)
    8000303c:	64e6                	ld	s1,88(sp)
    8000303e:	6946                	ld	s2,80(sp)
    80003040:	69a6                	ld	s3,72(sp)
    80003042:	6a06                	ld	s4,64(sp)
    80003044:	7ae2                	ld	s5,56(sp)
    80003046:	7b42                	ld	s6,48(sp)
    80003048:	7ba2                	ld	s7,40(sp)
    8000304a:	7c02                	ld	s8,32(sp)
    8000304c:	6ce2                	ld	s9,24(sp)
    8000304e:	6d42                	ld	s10,16(sp)
    80003050:	6da2                	ld	s11,8(sp)
    80003052:	6165                	addi	sp,sp,112
    80003054:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003056:	89da                	mv	s3,s6
    80003058:	bff1                	j	80003034 <readi+0xce>
    return 0;
    8000305a:	4501                	li	a0,0
}
    8000305c:	8082                	ret

000000008000305e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000305e:	457c                	lw	a5,76(a0)
    80003060:	10d7e863          	bltu	a5,a3,80003170 <writei+0x112>
{
    80003064:	7159                	addi	sp,sp,-112
    80003066:	f486                	sd	ra,104(sp)
    80003068:	f0a2                	sd	s0,96(sp)
    8000306a:	eca6                	sd	s1,88(sp)
    8000306c:	e8ca                	sd	s2,80(sp)
    8000306e:	e4ce                	sd	s3,72(sp)
    80003070:	e0d2                	sd	s4,64(sp)
    80003072:	fc56                	sd	s5,56(sp)
    80003074:	f85a                	sd	s6,48(sp)
    80003076:	f45e                	sd	s7,40(sp)
    80003078:	f062                	sd	s8,32(sp)
    8000307a:	ec66                	sd	s9,24(sp)
    8000307c:	e86a                	sd	s10,16(sp)
    8000307e:	e46e                	sd	s11,8(sp)
    80003080:	1880                	addi	s0,sp,112
    80003082:	8b2a                	mv	s6,a0
    80003084:	8c2e                	mv	s8,a1
    80003086:	8ab2                	mv	s5,a2
    80003088:	8936                	mv	s2,a3
    8000308a:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000308c:	00e687bb          	addw	a5,a3,a4
    80003090:	0ed7e263          	bltu	a5,a3,80003174 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003094:	00043737          	lui	a4,0x43
    80003098:	0ef76063          	bltu	a4,a5,80003178 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000309c:	0c0b8863          	beqz	s7,8000316c <writei+0x10e>
    800030a0:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030a2:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030a6:	5cfd                	li	s9,-1
    800030a8:	a091                	j	800030ec <writei+0x8e>
    800030aa:	02099d93          	slli	s11,s3,0x20
    800030ae:	020ddd93          	srli	s11,s11,0x20
    800030b2:	05848513          	addi	a0,s1,88
    800030b6:	86ee                	mv	a3,s11
    800030b8:	8656                	mv	a2,s5
    800030ba:	85e2                	mv	a1,s8
    800030bc:	953a                	add	a0,a0,a4
    800030be:	fffff097          	auipc	ra,0xfffff
    800030c2:	a00080e7          	jalr	-1536(ra) # 80001abe <either_copyin>
    800030c6:	07950263          	beq	a0,s9,8000312a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030ca:	8526                	mv	a0,s1
    800030cc:	00000097          	auipc	ra,0x0
    800030d0:	798080e7          	jalr	1944(ra) # 80003864 <log_write>
    brelse(bp);
    800030d4:	8526                	mv	a0,s1
    800030d6:	fffff097          	auipc	ra,0xfffff
    800030da:	50a080e7          	jalr	1290(ra) # 800025e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030de:	01498a3b          	addw	s4,s3,s4
    800030e2:	0129893b          	addw	s2,s3,s2
    800030e6:	9aee                	add	s5,s5,s11
    800030e8:	057a7663          	bgeu	s4,s7,80003134 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030ec:	000b2483          	lw	s1,0(s6)
    800030f0:	00a9559b          	srliw	a1,s2,0xa
    800030f4:	855a                	mv	a0,s6
    800030f6:	fffff097          	auipc	ra,0xfffff
    800030fa:	7aa080e7          	jalr	1962(ra) # 800028a0 <bmap>
    800030fe:	0005059b          	sext.w	a1,a0
    80003102:	8526                	mv	a0,s1
    80003104:	fffff097          	auipc	ra,0xfffff
    80003108:	3ac080e7          	jalr	940(ra) # 800024b0 <bread>
    8000310c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000310e:	3ff97713          	andi	a4,s2,1023
    80003112:	40ed07bb          	subw	a5,s10,a4
    80003116:	414b86bb          	subw	a3,s7,s4
    8000311a:	89be                	mv	s3,a5
    8000311c:	2781                	sext.w	a5,a5
    8000311e:	0006861b          	sext.w	a2,a3
    80003122:	f8f674e3          	bgeu	a2,a5,800030aa <writei+0x4c>
    80003126:	89b6                	mv	s3,a3
    80003128:	b749                	j	800030aa <writei+0x4c>
      brelse(bp);
    8000312a:	8526                	mv	a0,s1
    8000312c:	fffff097          	auipc	ra,0xfffff
    80003130:	4b4080e7          	jalr	1204(ra) # 800025e0 <brelse>
  }

  if(off > ip->size)
    80003134:	04cb2783          	lw	a5,76(s6)
    80003138:	0127f463          	bgeu	a5,s2,80003140 <writei+0xe2>
    ip->size = off;
    8000313c:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003140:	855a                	mv	a0,s6
    80003142:	00000097          	auipc	ra,0x0
    80003146:	aa4080e7          	jalr	-1372(ra) # 80002be6 <iupdate>

  return tot;
    8000314a:	000a051b          	sext.w	a0,s4
}
    8000314e:	70a6                	ld	ra,104(sp)
    80003150:	7406                	ld	s0,96(sp)
    80003152:	64e6                	ld	s1,88(sp)
    80003154:	6946                	ld	s2,80(sp)
    80003156:	69a6                	ld	s3,72(sp)
    80003158:	6a06                	ld	s4,64(sp)
    8000315a:	7ae2                	ld	s5,56(sp)
    8000315c:	7b42                	ld	s6,48(sp)
    8000315e:	7ba2                	ld	s7,40(sp)
    80003160:	7c02                	ld	s8,32(sp)
    80003162:	6ce2                	ld	s9,24(sp)
    80003164:	6d42                	ld	s10,16(sp)
    80003166:	6da2                	ld	s11,8(sp)
    80003168:	6165                	addi	sp,sp,112
    8000316a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000316c:	8a5e                	mv	s4,s7
    8000316e:	bfc9                	j	80003140 <writei+0xe2>
    return -1;
    80003170:	557d                	li	a0,-1
}
    80003172:	8082                	ret
    return -1;
    80003174:	557d                	li	a0,-1
    80003176:	bfe1                	j	8000314e <writei+0xf0>
    return -1;
    80003178:	557d                	li	a0,-1
    8000317a:	bfd1                	j	8000314e <writei+0xf0>

000000008000317c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000317c:	1141                	addi	sp,sp,-16
    8000317e:	e406                	sd	ra,8(sp)
    80003180:	e022                	sd	s0,0(sp)
    80003182:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003184:	4639                	li	a2,14
    80003186:	ffffd097          	auipc	ra,0xffffd
    8000318a:	0c4080e7          	jalr	196(ra) # 8000024a <strncmp>
}
    8000318e:	60a2                	ld	ra,8(sp)
    80003190:	6402                	ld	s0,0(sp)
    80003192:	0141                	addi	sp,sp,16
    80003194:	8082                	ret

0000000080003196 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003196:	7139                	addi	sp,sp,-64
    80003198:	fc06                	sd	ra,56(sp)
    8000319a:	f822                	sd	s0,48(sp)
    8000319c:	f426                	sd	s1,40(sp)
    8000319e:	f04a                	sd	s2,32(sp)
    800031a0:	ec4e                	sd	s3,24(sp)
    800031a2:	e852                	sd	s4,16(sp)
    800031a4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031a6:	04451703          	lh	a4,68(a0)
    800031aa:	4785                	li	a5,1
    800031ac:	00f71a63          	bne	a4,a5,800031c0 <dirlookup+0x2a>
    800031b0:	892a                	mv	s2,a0
    800031b2:	89ae                	mv	s3,a1
    800031b4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031b6:	457c                	lw	a5,76(a0)
    800031b8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031ba:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031bc:	e79d                	bnez	a5,800031ea <dirlookup+0x54>
    800031be:	a8a5                	j	80003236 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031c0:	00005517          	auipc	a0,0x5
    800031c4:	42850513          	addi	a0,a0,1064 # 800085e8 <syscalls+0x1e8>
    800031c8:	00003097          	auipc	ra,0x3
    800031cc:	b88080e7          	jalr	-1144(ra) # 80005d50 <panic>
      panic("dirlookup read");
    800031d0:	00005517          	auipc	a0,0x5
    800031d4:	43050513          	addi	a0,a0,1072 # 80008600 <syscalls+0x200>
    800031d8:	00003097          	auipc	ra,0x3
    800031dc:	b78080e7          	jalr	-1160(ra) # 80005d50 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031e0:	24c1                	addiw	s1,s1,16
    800031e2:	04c92783          	lw	a5,76(s2)
    800031e6:	04f4f763          	bgeu	s1,a5,80003234 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031ea:	4741                	li	a4,16
    800031ec:	86a6                	mv	a3,s1
    800031ee:	fc040613          	addi	a2,s0,-64
    800031f2:	4581                	li	a1,0
    800031f4:	854a                	mv	a0,s2
    800031f6:	00000097          	auipc	ra,0x0
    800031fa:	d70080e7          	jalr	-656(ra) # 80002f66 <readi>
    800031fe:	47c1                	li	a5,16
    80003200:	fcf518e3          	bne	a0,a5,800031d0 <dirlookup+0x3a>
    if(de.inum == 0)
    80003204:	fc045783          	lhu	a5,-64(s0)
    80003208:	dfe1                	beqz	a5,800031e0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000320a:	fc240593          	addi	a1,s0,-62
    8000320e:	854e                	mv	a0,s3
    80003210:	00000097          	auipc	ra,0x0
    80003214:	f6c080e7          	jalr	-148(ra) # 8000317c <namecmp>
    80003218:	f561                	bnez	a0,800031e0 <dirlookup+0x4a>
      if(poff)
    8000321a:	000a0463          	beqz	s4,80003222 <dirlookup+0x8c>
        *poff = off;
    8000321e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003222:	fc045583          	lhu	a1,-64(s0)
    80003226:	00092503          	lw	a0,0(s2)
    8000322a:	fffff097          	auipc	ra,0xfffff
    8000322e:	752080e7          	jalr	1874(ra) # 8000297c <iget>
    80003232:	a011                	j	80003236 <dirlookup+0xa0>
  return 0;
    80003234:	4501                	li	a0,0
}
    80003236:	70e2                	ld	ra,56(sp)
    80003238:	7442                	ld	s0,48(sp)
    8000323a:	74a2                	ld	s1,40(sp)
    8000323c:	7902                	ld	s2,32(sp)
    8000323e:	69e2                	ld	s3,24(sp)
    80003240:	6a42                	ld	s4,16(sp)
    80003242:	6121                	addi	sp,sp,64
    80003244:	8082                	ret

0000000080003246 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003246:	711d                	addi	sp,sp,-96
    80003248:	ec86                	sd	ra,88(sp)
    8000324a:	e8a2                	sd	s0,80(sp)
    8000324c:	e4a6                	sd	s1,72(sp)
    8000324e:	e0ca                	sd	s2,64(sp)
    80003250:	fc4e                	sd	s3,56(sp)
    80003252:	f852                	sd	s4,48(sp)
    80003254:	f456                	sd	s5,40(sp)
    80003256:	f05a                	sd	s6,32(sp)
    80003258:	ec5e                	sd	s7,24(sp)
    8000325a:	e862                	sd	s8,16(sp)
    8000325c:	e466                	sd	s9,8(sp)
    8000325e:	e06a                	sd	s10,0(sp)
    80003260:	1080                	addi	s0,sp,96
    80003262:	84aa                	mv	s1,a0
    80003264:	8b2e                	mv	s6,a1
    80003266:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003268:	00054703          	lbu	a4,0(a0)
    8000326c:	02f00793          	li	a5,47
    80003270:	02f70363          	beq	a4,a5,80003296 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003274:	ffffe097          	auipc	ra,0xffffe
    80003278:	d02080e7          	jalr	-766(ra) # 80000f76 <myproc>
    8000327c:	15053503          	ld	a0,336(a0)
    80003280:	00000097          	auipc	ra,0x0
    80003284:	9f4080e7          	jalr	-1548(ra) # 80002c74 <idup>
    80003288:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000328a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000328e:	4cb5                	li	s9,13
  len = path - s;
    80003290:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003292:	4c05                	li	s8,1
    80003294:	a87d                	j	80003352 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003296:	4585                	li	a1,1
    80003298:	4505                	li	a0,1
    8000329a:	fffff097          	auipc	ra,0xfffff
    8000329e:	6e2080e7          	jalr	1762(ra) # 8000297c <iget>
    800032a2:	8a2a                	mv	s4,a0
    800032a4:	b7dd                	j	8000328a <namex+0x44>
      iunlockput(ip);
    800032a6:	8552                	mv	a0,s4
    800032a8:	00000097          	auipc	ra,0x0
    800032ac:	c6c080e7          	jalr	-916(ra) # 80002f14 <iunlockput>
      return 0;
    800032b0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032b2:	8552                	mv	a0,s4
    800032b4:	60e6                	ld	ra,88(sp)
    800032b6:	6446                	ld	s0,80(sp)
    800032b8:	64a6                	ld	s1,72(sp)
    800032ba:	6906                	ld	s2,64(sp)
    800032bc:	79e2                	ld	s3,56(sp)
    800032be:	7a42                	ld	s4,48(sp)
    800032c0:	7aa2                	ld	s5,40(sp)
    800032c2:	7b02                	ld	s6,32(sp)
    800032c4:	6be2                	ld	s7,24(sp)
    800032c6:	6c42                	ld	s8,16(sp)
    800032c8:	6ca2                	ld	s9,8(sp)
    800032ca:	6d02                	ld	s10,0(sp)
    800032cc:	6125                	addi	sp,sp,96
    800032ce:	8082                	ret
      iunlock(ip);
    800032d0:	8552                	mv	a0,s4
    800032d2:	00000097          	auipc	ra,0x0
    800032d6:	aa2080e7          	jalr	-1374(ra) # 80002d74 <iunlock>
      return ip;
    800032da:	bfe1                	j	800032b2 <namex+0x6c>
      iunlockput(ip);
    800032dc:	8552                	mv	a0,s4
    800032de:	00000097          	auipc	ra,0x0
    800032e2:	c36080e7          	jalr	-970(ra) # 80002f14 <iunlockput>
      return 0;
    800032e6:	8a4e                	mv	s4,s3
    800032e8:	b7e9                	j	800032b2 <namex+0x6c>
  len = path - s;
    800032ea:	40998633          	sub	a2,s3,s1
    800032ee:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800032f2:	09acd863          	bge	s9,s10,80003382 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800032f6:	4639                	li	a2,14
    800032f8:	85a6                	mv	a1,s1
    800032fa:	8556                	mv	a0,s5
    800032fc:	ffffd097          	auipc	ra,0xffffd
    80003300:	eda080e7          	jalr	-294(ra) # 800001d6 <memmove>
    80003304:	84ce                	mv	s1,s3
  while(*path == '/')
    80003306:	0004c783          	lbu	a5,0(s1)
    8000330a:	01279763          	bne	a5,s2,80003318 <namex+0xd2>
    path++;
    8000330e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003310:	0004c783          	lbu	a5,0(s1)
    80003314:	ff278de3          	beq	a5,s2,8000330e <namex+0xc8>
    ilock(ip);
    80003318:	8552                	mv	a0,s4
    8000331a:	00000097          	auipc	ra,0x0
    8000331e:	998080e7          	jalr	-1640(ra) # 80002cb2 <ilock>
    if(ip->type != T_DIR){
    80003322:	044a1783          	lh	a5,68(s4)
    80003326:	f98790e3          	bne	a5,s8,800032a6 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000332a:	000b0563          	beqz	s6,80003334 <namex+0xee>
    8000332e:	0004c783          	lbu	a5,0(s1)
    80003332:	dfd9                	beqz	a5,800032d0 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003334:	865e                	mv	a2,s7
    80003336:	85d6                	mv	a1,s5
    80003338:	8552                	mv	a0,s4
    8000333a:	00000097          	auipc	ra,0x0
    8000333e:	e5c080e7          	jalr	-420(ra) # 80003196 <dirlookup>
    80003342:	89aa                	mv	s3,a0
    80003344:	dd41                	beqz	a0,800032dc <namex+0x96>
    iunlockput(ip);
    80003346:	8552                	mv	a0,s4
    80003348:	00000097          	auipc	ra,0x0
    8000334c:	bcc080e7          	jalr	-1076(ra) # 80002f14 <iunlockput>
    ip = next;
    80003350:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003352:	0004c783          	lbu	a5,0(s1)
    80003356:	01279763          	bne	a5,s2,80003364 <namex+0x11e>
    path++;
    8000335a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000335c:	0004c783          	lbu	a5,0(s1)
    80003360:	ff278de3          	beq	a5,s2,8000335a <namex+0x114>
  if(*path == 0)
    80003364:	cb9d                	beqz	a5,8000339a <namex+0x154>
  while(*path != '/' && *path != 0)
    80003366:	0004c783          	lbu	a5,0(s1)
    8000336a:	89a6                	mv	s3,s1
  len = path - s;
    8000336c:	8d5e                	mv	s10,s7
    8000336e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003370:	01278963          	beq	a5,s2,80003382 <namex+0x13c>
    80003374:	dbbd                	beqz	a5,800032ea <namex+0xa4>
    path++;
    80003376:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003378:	0009c783          	lbu	a5,0(s3)
    8000337c:	ff279ce3          	bne	a5,s2,80003374 <namex+0x12e>
    80003380:	b7ad                	j	800032ea <namex+0xa4>
    memmove(name, s, len);
    80003382:	2601                	sext.w	a2,a2
    80003384:	85a6                	mv	a1,s1
    80003386:	8556                	mv	a0,s5
    80003388:	ffffd097          	auipc	ra,0xffffd
    8000338c:	e4e080e7          	jalr	-434(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003390:	9d56                	add	s10,s10,s5
    80003392:	000d0023          	sb	zero,0(s10)
    80003396:	84ce                	mv	s1,s3
    80003398:	b7bd                	j	80003306 <namex+0xc0>
  if(nameiparent){
    8000339a:	f00b0ce3          	beqz	s6,800032b2 <namex+0x6c>
    iput(ip);
    8000339e:	8552                	mv	a0,s4
    800033a0:	00000097          	auipc	ra,0x0
    800033a4:	acc080e7          	jalr	-1332(ra) # 80002e6c <iput>
    return 0;
    800033a8:	4a01                	li	s4,0
    800033aa:	b721                	j	800032b2 <namex+0x6c>

00000000800033ac <dirlink>:
{
    800033ac:	7139                	addi	sp,sp,-64
    800033ae:	fc06                	sd	ra,56(sp)
    800033b0:	f822                	sd	s0,48(sp)
    800033b2:	f426                	sd	s1,40(sp)
    800033b4:	f04a                	sd	s2,32(sp)
    800033b6:	ec4e                	sd	s3,24(sp)
    800033b8:	e852                	sd	s4,16(sp)
    800033ba:	0080                	addi	s0,sp,64
    800033bc:	892a                	mv	s2,a0
    800033be:	8a2e                	mv	s4,a1
    800033c0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033c2:	4601                	li	a2,0
    800033c4:	00000097          	auipc	ra,0x0
    800033c8:	dd2080e7          	jalr	-558(ra) # 80003196 <dirlookup>
    800033cc:	e93d                	bnez	a0,80003442 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033ce:	04c92483          	lw	s1,76(s2)
    800033d2:	c49d                	beqz	s1,80003400 <dirlink+0x54>
    800033d4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033d6:	4741                	li	a4,16
    800033d8:	86a6                	mv	a3,s1
    800033da:	fc040613          	addi	a2,s0,-64
    800033de:	4581                	li	a1,0
    800033e0:	854a                	mv	a0,s2
    800033e2:	00000097          	auipc	ra,0x0
    800033e6:	b84080e7          	jalr	-1148(ra) # 80002f66 <readi>
    800033ea:	47c1                	li	a5,16
    800033ec:	06f51163          	bne	a0,a5,8000344e <dirlink+0xa2>
    if(de.inum == 0)
    800033f0:	fc045783          	lhu	a5,-64(s0)
    800033f4:	c791                	beqz	a5,80003400 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033f6:	24c1                	addiw	s1,s1,16
    800033f8:	04c92783          	lw	a5,76(s2)
    800033fc:	fcf4ede3          	bltu	s1,a5,800033d6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003400:	4639                	li	a2,14
    80003402:	85d2                	mv	a1,s4
    80003404:	fc240513          	addi	a0,s0,-62
    80003408:	ffffd097          	auipc	ra,0xffffd
    8000340c:	e7e080e7          	jalr	-386(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003410:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003414:	4741                	li	a4,16
    80003416:	86a6                	mv	a3,s1
    80003418:	fc040613          	addi	a2,s0,-64
    8000341c:	4581                	li	a1,0
    8000341e:	854a                	mv	a0,s2
    80003420:	00000097          	auipc	ra,0x0
    80003424:	c3e080e7          	jalr	-962(ra) # 8000305e <writei>
    80003428:	872a                	mv	a4,a0
    8000342a:	47c1                	li	a5,16
  return 0;
    8000342c:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000342e:	02f71863          	bne	a4,a5,8000345e <dirlink+0xb2>
}
    80003432:	70e2                	ld	ra,56(sp)
    80003434:	7442                	ld	s0,48(sp)
    80003436:	74a2                	ld	s1,40(sp)
    80003438:	7902                	ld	s2,32(sp)
    8000343a:	69e2                	ld	s3,24(sp)
    8000343c:	6a42                	ld	s4,16(sp)
    8000343e:	6121                	addi	sp,sp,64
    80003440:	8082                	ret
    iput(ip);
    80003442:	00000097          	auipc	ra,0x0
    80003446:	a2a080e7          	jalr	-1494(ra) # 80002e6c <iput>
    return -1;
    8000344a:	557d                	li	a0,-1
    8000344c:	b7dd                	j	80003432 <dirlink+0x86>
      panic("dirlink read");
    8000344e:	00005517          	auipc	a0,0x5
    80003452:	1c250513          	addi	a0,a0,450 # 80008610 <syscalls+0x210>
    80003456:	00003097          	auipc	ra,0x3
    8000345a:	8fa080e7          	jalr	-1798(ra) # 80005d50 <panic>
    panic("dirlink");
    8000345e:	00005517          	auipc	a0,0x5
    80003462:	2ca50513          	addi	a0,a0,714 # 80008728 <syscalls+0x328>
    80003466:	00003097          	auipc	ra,0x3
    8000346a:	8ea080e7          	jalr	-1814(ra) # 80005d50 <panic>

000000008000346e <namei>:

struct inode*
namei(char *path)
{
    8000346e:	1101                	addi	sp,sp,-32
    80003470:	ec06                	sd	ra,24(sp)
    80003472:	e822                	sd	s0,16(sp)
    80003474:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003476:	fe040613          	addi	a2,s0,-32
    8000347a:	4581                	li	a1,0
    8000347c:	00000097          	auipc	ra,0x0
    80003480:	dca080e7          	jalr	-566(ra) # 80003246 <namex>
}
    80003484:	60e2                	ld	ra,24(sp)
    80003486:	6442                	ld	s0,16(sp)
    80003488:	6105                	addi	sp,sp,32
    8000348a:	8082                	ret

000000008000348c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000348c:	1141                	addi	sp,sp,-16
    8000348e:	e406                	sd	ra,8(sp)
    80003490:	e022                	sd	s0,0(sp)
    80003492:	0800                	addi	s0,sp,16
    80003494:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003496:	4585                	li	a1,1
    80003498:	00000097          	auipc	ra,0x0
    8000349c:	dae080e7          	jalr	-594(ra) # 80003246 <namex>
}
    800034a0:	60a2                	ld	ra,8(sp)
    800034a2:	6402                	ld	s0,0(sp)
    800034a4:	0141                	addi	sp,sp,16
    800034a6:	8082                	ret

00000000800034a8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034a8:	1101                	addi	sp,sp,-32
    800034aa:	ec06                	sd	ra,24(sp)
    800034ac:	e822                	sd	s0,16(sp)
    800034ae:	e426                	sd	s1,8(sp)
    800034b0:	e04a                	sd	s2,0(sp)
    800034b2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034b4:	00016917          	auipc	s2,0x16
    800034b8:	d6c90913          	addi	s2,s2,-660 # 80019220 <log>
    800034bc:	01892583          	lw	a1,24(s2)
    800034c0:	02892503          	lw	a0,40(s2)
    800034c4:	fffff097          	auipc	ra,0xfffff
    800034c8:	fec080e7          	jalr	-20(ra) # 800024b0 <bread>
    800034cc:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034ce:	02c92683          	lw	a3,44(s2)
    800034d2:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034d4:	02d05863          	blez	a3,80003504 <write_head+0x5c>
    800034d8:	00016797          	auipc	a5,0x16
    800034dc:	d7878793          	addi	a5,a5,-648 # 80019250 <log+0x30>
    800034e0:	05c50713          	addi	a4,a0,92
    800034e4:	36fd                	addiw	a3,a3,-1
    800034e6:	02069613          	slli	a2,a3,0x20
    800034ea:	01e65693          	srli	a3,a2,0x1e
    800034ee:	00016617          	auipc	a2,0x16
    800034f2:	d6660613          	addi	a2,a2,-666 # 80019254 <log+0x34>
    800034f6:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034f8:	4390                	lw	a2,0(a5)
    800034fa:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034fc:	0791                	addi	a5,a5,4
    800034fe:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003500:	fed79ce3          	bne	a5,a3,800034f8 <write_head+0x50>
  }
  bwrite(buf);
    80003504:	8526                	mv	a0,s1
    80003506:	fffff097          	auipc	ra,0xfffff
    8000350a:	09c080e7          	jalr	156(ra) # 800025a2 <bwrite>
  brelse(buf);
    8000350e:	8526                	mv	a0,s1
    80003510:	fffff097          	auipc	ra,0xfffff
    80003514:	0d0080e7          	jalr	208(ra) # 800025e0 <brelse>
}
    80003518:	60e2                	ld	ra,24(sp)
    8000351a:	6442                	ld	s0,16(sp)
    8000351c:	64a2                	ld	s1,8(sp)
    8000351e:	6902                	ld	s2,0(sp)
    80003520:	6105                	addi	sp,sp,32
    80003522:	8082                	ret

0000000080003524 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003524:	00016797          	auipc	a5,0x16
    80003528:	d287a783          	lw	a5,-728(a5) # 8001924c <log+0x2c>
    8000352c:	0af05d63          	blez	a5,800035e6 <install_trans+0xc2>
{
    80003530:	7139                	addi	sp,sp,-64
    80003532:	fc06                	sd	ra,56(sp)
    80003534:	f822                	sd	s0,48(sp)
    80003536:	f426                	sd	s1,40(sp)
    80003538:	f04a                	sd	s2,32(sp)
    8000353a:	ec4e                	sd	s3,24(sp)
    8000353c:	e852                	sd	s4,16(sp)
    8000353e:	e456                	sd	s5,8(sp)
    80003540:	e05a                	sd	s6,0(sp)
    80003542:	0080                	addi	s0,sp,64
    80003544:	8b2a                	mv	s6,a0
    80003546:	00016a97          	auipc	s5,0x16
    8000354a:	d0aa8a93          	addi	s5,s5,-758 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000354e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003550:	00016997          	auipc	s3,0x16
    80003554:	cd098993          	addi	s3,s3,-816 # 80019220 <log>
    80003558:	a00d                	j	8000357a <install_trans+0x56>
    brelse(lbuf);
    8000355a:	854a                	mv	a0,s2
    8000355c:	fffff097          	auipc	ra,0xfffff
    80003560:	084080e7          	jalr	132(ra) # 800025e0 <brelse>
    brelse(dbuf);
    80003564:	8526                	mv	a0,s1
    80003566:	fffff097          	auipc	ra,0xfffff
    8000356a:	07a080e7          	jalr	122(ra) # 800025e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000356e:	2a05                	addiw	s4,s4,1
    80003570:	0a91                	addi	s5,s5,4
    80003572:	02c9a783          	lw	a5,44(s3)
    80003576:	04fa5e63          	bge	s4,a5,800035d2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000357a:	0189a583          	lw	a1,24(s3)
    8000357e:	014585bb          	addw	a1,a1,s4
    80003582:	2585                	addiw	a1,a1,1
    80003584:	0289a503          	lw	a0,40(s3)
    80003588:	fffff097          	auipc	ra,0xfffff
    8000358c:	f28080e7          	jalr	-216(ra) # 800024b0 <bread>
    80003590:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003592:	000aa583          	lw	a1,0(s5)
    80003596:	0289a503          	lw	a0,40(s3)
    8000359a:	fffff097          	auipc	ra,0xfffff
    8000359e:	f16080e7          	jalr	-234(ra) # 800024b0 <bread>
    800035a2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035a4:	40000613          	li	a2,1024
    800035a8:	05890593          	addi	a1,s2,88
    800035ac:	05850513          	addi	a0,a0,88
    800035b0:	ffffd097          	auipc	ra,0xffffd
    800035b4:	c26080e7          	jalr	-986(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035b8:	8526                	mv	a0,s1
    800035ba:	fffff097          	auipc	ra,0xfffff
    800035be:	fe8080e7          	jalr	-24(ra) # 800025a2 <bwrite>
    if(recovering == 0)
    800035c2:	f80b1ce3          	bnez	s6,8000355a <install_trans+0x36>
      bunpin(dbuf);
    800035c6:	8526                	mv	a0,s1
    800035c8:	fffff097          	auipc	ra,0xfffff
    800035cc:	0f2080e7          	jalr	242(ra) # 800026ba <bunpin>
    800035d0:	b769                	j	8000355a <install_trans+0x36>
}
    800035d2:	70e2                	ld	ra,56(sp)
    800035d4:	7442                	ld	s0,48(sp)
    800035d6:	74a2                	ld	s1,40(sp)
    800035d8:	7902                	ld	s2,32(sp)
    800035da:	69e2                	ld	s3,24(sp)
    800035dc:	6a42                	ld	s4,16(sp)
    800035de:	6aa2                	ld	s5,8(sp)
    800035e0:	6b02                	ld	s6,0(sp)
    800035e2:	6121                	addi	sp,sp,64
    800035e4:	8082                	ret
    800035e6:	8082                	ret

00000000800035e8 <initlog>:
{
    800035e8:	7179                	addi	sp,sp,-48
    800035ea:	f406                	sd	ra,40(sp)
    800035ec:	f022                	sd	s0,32(sp)
    800035ee:	ec26                	sd	s1,24(sp)
    800035f0:	e84a                	sd	s2,16(sp)
    800035f2:	e44e                	sd	s3,8(sp)
    800035f4:	1800                	addi	s0,sp,48
    800035f6:	892a                	mv	s2,a0
    800035f8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035fa:	00016497          	auipc	s1,0x16
    800035fe:	c2648493          	addi	s1,s1,-986 # 80019220 <log>
    80003602:	00005597          	auipc	a1,0x5
    80003606:	01e58593          	addi	a1,a1,30 # 80008620 <syscalls+0x220>
    8000360a:	8526                	mv	a0,s1
    8000360c:	00003097          	auipc	ra,0x3
    80003610:	bec080e7          	jalr	-1044(ra) # 800061f8 <initlock>
  log.start = sb->logstart;
    80003614:	0149a583          	lw	a1,20(s3)
    80003618:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000361a:	0109a783          	lw	a5,16(s3)
    8000361e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003620:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003624:	854a                	mv	a0,s2
    80003626:	fffff097          	auipc	ra,0xfffff
    8000362a:	e8a080e7          	jalr	-374(ra) # 800024b0 <bread>
  log.lh.n = lh->n;
    8000362e:	4d34                	lw	a3,88(a0)
    80003630:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003632:	02d05663          	blez	a3,8000365e <initlog+0x76>
    80003636:	05c50793          	addi	a5,a0,92
    8000363a:	00016717          	auipc	a4,0x16
    8000363e:	c1670713          	addi	a4,a4,-1002 # 80019250 <log+0x30>
    80003642:	36fd                	addiw	a3,a3,-1
    80003644:	02069613          	slli	a2,a3,0x20
    80003648:	01e65693          	srli	a3,a2,0x1e
    8000364c:	06050613          	addi	a2,a0,96
    80003650:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003652:	4390                	lw	a2,0(a5)
    80003654:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003656:	0791                	addi	a5,a5,4
    80003658:	0711                	addi	a4,a4,4
    8000365a:	fed79ce3          	bne	a5,a3,80003652 <initlog+0x6a>
  brelse(buf);
    8000365e:	fffff097          	auipc	ra,0xfffff
    80003662:	f82080e7          	jalr	-126(ra) # 800025e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003666:	4505                	li	a0,1
    80003668:	00000097          	auipc	ra,0x0
    8000366c:	ebc080e7          	jalr	-324(ra) # 80003524 <install_trans>
  log.lh.n = 0;
    80003670:	00016797          	auipc	a5,0x16
    80003674:	bc07ae23          	sw	zero,-1060(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    80003678:	00000097          	auipc	ra,0x0
    8000367c:	e30080e7          	jalr	-464(ra) # 800034a8 <write_head>
}
    80003680:	70a2                	ld	ra,40(sp)
    80003682:	7402                	ld	s0,32(sp)
    80003684:	64e2                	ld	s1,24(sp)
    80003686:	6942                	ld	s2,16(sp)
    80003688:	69a2                	ld	s3,8(sp)
    8000368a:	6145                	addi	sp,sp,48
    8000368c:	8082                	ret

000000008000368e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000368e:	1101                	addi	sp,sp,-32
    80003690:	ec06                	sd	ra,24(sp)
    80003692:	e822                	sd	s0,16(sp)
    80003694:	e426                	sd	s1,8(sp)
    80003696:	e04a                	sd	s2,0(sp)
    80003698:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000369a:	00016517          	auipc	a0,0x16
    8000369e:	b8650513          	addi	a0,a0,-1146 # 80019220 <log>
    800036a2:	00003097          	auipc	ra,0x3
    800036a6:	be6080e7          	jalr	-1050(ra) # 80006288 <acquire>
  while(1){
    if(log.committing){
    800036aa:	00016497          	auipc	s1,0x16
    800036ae:	b7648493          	addi	s1,s1,-1162 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036b2:	4979                	li	s2,30
    800036b4:	a039                	j	800036c2 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036b6:	85a6                	mv	a1,s1
    800036b8:	8526                	mv	a0,s1
    800036ba:	ffffe097          	auipc	ra,0xffffe
    800036be:	00a080e7          	jalr	10(ra) # 800016c4 <sleep>
    if(log.committing){
    800036c2:	50dc                	lw	a5,36(s1)
    800036c4:	fbed                	bnez	a5,800036b6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036c6:	5098                	lw	a4,32(s1)
    800036c8:	2705                	addiw	a4,a4,1
    800036ca:	0007069b          	sext.w	a3,a4
    800036ce:	0027179b          	slliw	a5,a4,0x2
    800036d2:	9fb9                	addw	a5,a5,a4
    800036d4:	0017979b          	slliw	a5,a5,0x1
    800036d8:	54d8                	lw	a4,44(s1)
    800036da:	9fb9                	addw	a5,a5,a4
    800036dc:	00f95963          	bge	s2,a5,800036ee <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036e0:	85a6                	mv	a1,s1
    800036e2:	8526                	mv	a0,s1
    800036e4:	ffffe097          	auipc	ra,0xffffe
    800036e8:	fe0080e7          	jalr	-32(ra) # 800016c4 <sleep>
    800036ec:	bfd9                	j	800036c2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036ee:	00016517          	auipc	a0,0x16
    800036f2:	b3250513          	addi	a0,a0,-1230 # 80019220 <log>
    800036f6:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036f8:	00003097          	auipc	ra,0x3
    800036fc:	c44080e7          	jalr	-956(ra) # 8000633c <release>
      break;
    }
  }
}
    80003700:	60e2                	ld	ra,24(sp)
    80003702:	6442                	ld	s0,16(sp)
    80003704:	64a2                	ld	s1,8(sp)
    80003706:	6902                	ld	s2,0(sp)
    80003708:	6105                	addi	sp,sp,32
    8000370a:	8082                	ret

000000008000370c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000370c:	7139                	addi	sp,sp,-64
    8000370e:	fc06                	sd	ra,56(sp)
    80003710:	f822                	sd	s0,48(sp)
    80003712:	f426                	sd	s1,40(sp)
    80003714:	f04a                	sd	s2,32(sp)
    80003716:	ec4e                	sd	s3,24(sp)
    80003718:	e852                	sd	s4,16(sp)
    8000371a:	e456                	sd	s5,8(sp)
    8000371c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000371e:	00016497          	auipc	s1,0x16
    80003722:	b0248493          	addi	s1,s1,-1278 # 80019220 <log>
    80003726:	8526                	mv	a0,s1
    80003728:	00003097          	auipc	ra,0x3
    8000372c:	b60080e7          	jalr	-1184(ra) # 80006288 <acquire>
  log.outstanding -= 1;
    80003730:	509c                	lw	a5,32(s1)
    80003732:	37fd                	addiw	a5,a5,-1
    80003734:	0007891b          	sext.w	s2,a5
    80003738:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000373a:	50dc                	lw	a5,36(s1)
    8000373c:	e7b9                	bnez	a5,8000378a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000373e:	04091e63          	bnez	s2,8000379a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003742:	00016497          	auipc	s1,0x16
    80003746:	ade48493          	addi	s1,s1,-1314 # 80019220 <log>
    8000374a:	4785                	li	a5,1
    8000374c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000374e:	8526                	mv	a0,s1
    80003750:	00003097          	auipc	ra,0x3
    80003754:	bec080e7          	jalr	-1044(ra) # 8000633c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003758:	54dc                	lw	a5,44(s1)
    8000375a:	06f04763          	bgtz	a5,800037c8 <end_op+0xbc>
    acquire(&log.lock);
    8000375e:	00016497          	auipc	s1,0x16
    80003762:	ac248493          	addi	s1,s1,-1342 # 80019220 <log>
    80003766:	8526                	mv	a0,s1
    80003768:	00003097          	auipc	ra,0x3
    8000376c:	b20080e7          	jalr	-1248(ra) # 80006288 <acquire>
    log.committing = 0;
    80003770:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003774:	8526                	mv	a0,s1
    80003776:	ffffe097          	auipc	ra,0xffffe
    8000377a:	0da080e7          	jalr	218(ra) # 80001850 <wakeup>
    release(&log.lock);
    8000377e:	8526                	mv	a0,s1
    80003780:	00003097          	auipc	ra,0x3
    80003784:	bbc080e7          	jalr	-1092(ra) # 8000633c <release>
}
    80003788:	a03d                	j	800037b6 <end_op+0xaa>
    panic("log.committing");
    8000378a:	00005517          	auipc	a0,0x5
    8000378e:	e9e50513          	addi	a0,a0,-354 # 80008628 <syscalls+0x228>
    80003792:	00002097          	auipc	ra,0x2
    80003796:	5be080e7          	jalr	1470(ra) # 80005d50 <panic>
    wakeup(&log);
    8000379a:	00016497          	auipc	s1,0x16
    8000379e:	a8648493          	addi	s1,s1,-1402 # 80019220 <log>
    800037a2:	8526                	mv	a0,s1
    800037a4:	ffffe097          	auipc	ra,0xffffe
    800037a8:	0ac080e7          	jalr	172(ra) # 80001850 <wakeup>
  release(&log.lock);
    800037ac:	8526                	mv	a0,s1
    800037ae:	00003097          	auipc	ra,0x3
    800037b2:	b8e080e7          	jalr	-1138(ra) # 8000633c <release>
}
    800037b6:	70e2                	ld	ra,56(sp)
    800037b8:	7442                	ld	s0,48(sp)
    800037ba:	74a2                	ld	s1,40(sp)
    800037bc:	7902                	ld	s2,32(sp)
    800037be:	69e2                	ld	s3,24(sp)
    800037c0:	6a42                	ld	s4,16(sp)
    800037c2:	6aa2                	ld	s5,8(sp)
    800037c4:	6121                	addi	sp,sp,64
    800037c6:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800037c8:	00016a97          	auipc	s5,0x16
    800037cc:	a88a8a93          	addi	s5,s5,-1400 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037d0:	00016a17          	auipc	s4,0x16
    800037d4:	a50a0a13          	addi	s4,s4,-1456 # 80019220 <log>
    800037d8:	018a2583          	lw	a1,24(s4)
    800037dc:	012585bb          	addw	a1,a1,s2
    800037e0:	2585                	addiw	a1,a1,1
    800037e2:	028a2503          	lw	a0,40(s4)
    800037e6:	fffff097          	auipc	ra,0xfffff
    800037ea:	cca080e7          	jalr	-822(ra) # 800024b0 <bread>
    800037ee:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037f0:	000aa583          	lw	a1,0(s5)
    800037f4:	028a2503          	lw	a0,40(s4)
    800037f8:	fffff097          	auipc	ra,0xfffff
    800037fc:	cb8080e7          	jalr	-840(ra) # 800024b0 <bread>
    80003800:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003802:	40000613          	li	a2,1024
    80003806:	05850593          	addi	a1,a0,88
    8000380a:	05848513          	addi	a0,s1,88
    8000380e:	ffffd097          	auipc	ra,0xffffd
    80003812:	9c8080e7          	jalr	-1592(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003816:	8526                	mv	a0,s1
    80003818:	fffff097          	auipc	ra,0xfffff
    8000381c:	d8a080e7          	jalr	-630(ra) # 800025a2 <bwrite>
    brelse(from);
    80003820:	854e                	mv	a0,s3
    80003822:	fffff097          	auipc	ra,0xfffff
    80003826:	dbe080e7          	jalr	-578(ra) # 800025e0 <brelse>
    brelse(to);
    8000382a:	8526                	mv	a0,s1
    8000382c:	fffff097          	auipc	ra,0xfffff
    80003830:	db4080e7          	jalr	-588(ra) # 800025e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003834:	2905                	addiw	s2,s2,1
    80003836:	0a91                	addi	s5,s5,4
    80003838:	02ca2783          	lw	a5,44(s4)
    8000383c:	f8f94ee3          	blt	s2,a5,800037d8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003840:	00000097          	auipc	ra,0x0
    80003844:	c68080e7          	jalr	-920(ra) # 800034a8 <write_head>
    install_trans(0); // Now install writes to home locations
    80003848:	4501                	li	a0,0
    8000384a:	00000097          	auipc	ra,0x0
    8000384e:	cda080e7          	jalr	-806(ra) # 80003524 <install_trans>
    log.lh.n = 0;
    80003852:	00016797          	auipc	a5,0x16
    80003856:	9e07ad23          	sw	zero,-1542(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000385a:	00000097          	auipc	ra,0x0
    8000385e:	c4e080e7          	jalr	-946(ra) # 800034a8 <write_head>
    80003862:	bdf5                	j	8000375e <end_op+0x52>

0000000080003864 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003864:	1101                	addi	sp,sp,-32
    80003866:	ec06                	sd	ra,24(sp)
    80003868:	e822                	sd	s0,16(sp)
    8000386a:	e426                	sd	s1,8(sp)
    8000386c:	e04a                	sd	s2,0(sp)
    8000386e:	1000                	addi	s0,sp,32
    80003870:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003872:	00016917          	auipc	s2,0x16
    80003876:	9ae90913          	addi	s2,s2,-1618 # 80019220 <log>
    8000387a:	854a                	mv	a0,s2
    8000387c:	00003097          	auipc	ra,0x3
    80003880:	a0c080e7          	jalr	-1524(ra) # 80006288 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003884:	02c92603          	lw	a2,44(s2)
    80003888:	47f5                	li	a5,29
    8000388a:	06c7c563          	blt	a5,a2,800038f4 <log_write+0x90>
    8000388e:	00016797          	auipc	a5,0x16
    80003892:	9ae7a783          	lw	a5,-1618(a5) # 8001923c <log+0x1c>
    80003896:	37fd                	addiw	a5,a5,-1
    80003898:	04f65e63          	bge	a2,a5,800038f4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000389c:	00016797          	auipc	a5,0x16
    800038a0:	9a47a783          	lw	a5,-1628(a5) # 80019240 <log+0x20>
    800038a4:	06f05063          	blez	a5,80003904 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038a8:	4781                	li	a5,0
    800038aa:	06c05563          	blez	a2,80003914 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038ae:	44cc                	lw	a1,12(s1)
    800038b0:	00016717          	auipc	a4,0x16
    800038b4:	9a070713          	addi	a4,a4,-1632 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038b8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038ba:	4314                	lw	a3,0(a4)
    800038bc:	04b68c63          	beq	a3,a1,80003914 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038c0:	2785                	addiw	a5,a5,1
    800038c2:	0711                	addi	a4,a4,4
    800038c4:	fef61be3          	bne	a2,a5,800038ba <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038c8:	0621                	addi	a2,a2,8
    800038ca:	060a                	slli	a2,a2,0x2
    800038cc:	00016797          	auipc	a5,0x16
    800038d0:	95478793          	addi	a5,a5,-1708 # 80019220 <log>
    800038d4:	97b2                	add	a5,a5,a2
    800038d6:	44d8                	lw	a4,12(s1)
    800038d8:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038da:	8526                	mv	a0,s1
    800038dc:	fffff097          	auipc	ra,0xfffff
    800038e0:	da2080e7          	jalr	-606(ra) # 8000267e <bpin>
    log.lh.n++;
    800038e4:	00016717          	auipc	a4,0x16
    800038e8:	93c70713          	addi	a4,a4,-1732 # 80019220 <log>
    800038ec:	575c                	lw	a5,44(a4)
    800038ee:	2785                	addiw	a5,a5,1
    800038f0:	d75c                	sw	a5,44(a4)
    800038f2:	a82d                	j	8000392c <log_write+0xc8>
    panic("too big a transaction");
    800038f4:	00005517          	auipc	a0,0x5
    800038f8:	d4450513          	addi	a0,a0,-700 # 80008638 <syscalls+0x238>
    800038fc:	00002097          	auipc	ra,0x2
    80003900:	454080e7          	jalr	1108(ra) # 80005d50 <panic>
    panic("log_write outside of trans");
    80003904:	00005517          	auipc	a0,0x5
    80003908:	d4c50513          	addi	a0,a0,-692 # 80008650 <syscalls+0x250>
    8000390c:	00002097          	auipc	ra,0x2
    80003910:	444080e7          	jalr	1092(ra) # 80005d50 <panic>
  log.lh.block[i] = b->blockno;
    80003914:	00878693          	addi	a3,a5,8
    80003918:	068a                	slli	a3,a3,0x2
    8000391a:	00016717          	auipc	a4,0x16
    8000391e:	90670713          	addi	a4,a4,-1786 # 80019220 <log>
    80003922:	9736                	add	a4,a4,a3
    80003924:	44d4                	lw	a3,12(s1)
    80003926:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003928:	faf609e3          	beq	a2,a5,800038da <log_write+0x76>
  }
  release(&log.lock);
    8000392c:	00016517          	auipc	a0,0x16
    80003930:	8f450513          	addi	a0,a0,-1804 # 80019220 <log>
    80003934:	00003097          	auipc	ra,0x3
    80003938:	a08080e7          	jalr	-1528(ra) # 8000633c <release>
}
    8000393c:	60e2                	ld	ra,24(sp)
    8000393e:	6442                	ld	s0,16(sp)
    80003940:	64a2                	ld	s1,8(sp)
    80003942:	6902                	ld	s2,0(sp)
    80003944:	6105                	addi	sp,sp,32
    80003946:	8082                	ret

0000000080003948 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003948:	1101                	addi	sp,sp,-32
    8000394a:	ec06                	sd	ra,24(sp)
    8000394c:	e822                	sd	s0,16(sp)
    8000394e:	e426                	sd	s1,8(sp)
    80003950:	e04a                	sd	s2,0(sp)
    80003952:	1000                	addi	s0,sp,32
    80003954:	84aa                	mv	s1,a0
    80003956:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003958:	00005597          	auipc	a1,0x5
    8000395c:	d1858593          	addi	a1,a1,-744 # 80008670 <syscalls+0x270>
    80003960:	0521                	addi	a0,a0,8
    80003962:	00003097          	auipc	ra,0x3
    80003966:	896080e7          	jalr	-1898(ra) # 800061f8 <initlock>
  lk->name = name;
    8000396a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000396e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003972:	0204a423          	sw	zero,40(s1)
}
    80003976:	60e2                	ld	ra,24(sp)
    80003978:	6442                	ld	s0,16(sp)
    8000397a:	64a2                	ld	s1,8(sp)
    8000397c:	6902                	ld	s2,0(sp)
    8000397e:	6105                	addi	sp,sp,32
    80003980:	8082                	ret

0000000080003982 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003982:	1101                	addi	sp,sp,-32
    80003984:	ec06                	sd	ra,24(sp)
    80003986:	e822                	sd	s0,16(sp)
    80003988:	e426                	sd	s1,8(sp)
    8000398a:	e04a                	sd	s2,0(sp)
    8000398c:	1000                	addi	s0,sp,32
    8000398e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003990:	00850913          	addi	s2,a0,8
    80003994:	854a                	mv	a0,s2
    80003996:	00003097          	auipc	ra,0x3
    8000399a:	8f2080e7          	jalr	-1806(ra) # 80006288 <acquire>
  while (lk->locked) {
    8000399e:	409c                	lw	a5,0(s1)
    800039a0:	cb89                	beqz	a5,800039b2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039a2:	85ca                	mv	a1,s2
    800039a4:	8526                	mv	a0,s1
    800039a6:	ffffe097          	auipc	ra,0xffffe
    800039aa:	d1e080e7          	jalr	-738(ra) # 800016c4 <sleep>
  while (lk->locked) {
    800039ae:	409c                	lw	a5,0(s1)
    800039b0:	fbed                	bnez	a5,800039a2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039b2:	4785                	li	a5,1
    800039b4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039b6:	ffffd097          	auipc	ra,0xffffd
    800039ba:	5c0080e7          	jalr	1472(ra) # 80000f76 <myproc>
    800039be:	591c                	lw	a5,48(a0)
    800039c0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039c2:	854a                	mv	a0,s2
    800039c4:	00003097          	auipc	ra,0x3
    800039c8:	978080e7          	jalr	-1672(ra) # 8000633c <release>
}
    800039cc:	60e2                	ld	ra,24(sp)
    800039ce:	6442                	ld	s0,16(sp)
    800039d0:	64a2                	ld	s1,8(sp)
    800039d2:	6902                	ld	s2,0(sp)
    800039d4:	6105                	addi	sp,sp,32
    800039d6:	8082                	ret

00000000800039d8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039d8:	1101                	addi	sp,sp,-32
    800039da:	ec06                	sd	ra,24(sp)
    800039dc:	e822                	sd	s0,16(sp)
    800039de:	e426                	sd	s1,8(sp)
    800039e0:	e04a                	sd	s2,0(sp)
    800039e2:	1000                	addi	s0,sp,32
    800039e4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039e6:	00850913          	addi	s2,a0,8
    800039ea:	854a                	mv	a0,s2
    800039ec:	00003097          	auipc	ra,0x3
    800039f0:	89c080e7          	jalr	-1892(ra) # 80006288 <acquire>
  lk->locked = 0;
    800039f4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039f8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039fc:	8526                	mv	a0,s1
    800039fe:	ffffe097          	auipc	ra,0xffffe
    80003a02:	e52080e7          	jalr	-430(ra) # 80001850 <wakeup>
  release(&lk->lk);
    80003a06:	854a                	mv	a0,s2
    80003a08:	00003097          	auipc	ra,0x3
    80003a0c:	934080e7          	jalr	-1740(ra) # 8000633c <release>
}
    80003a10:	60e2                	ld	ra,24(sp)
    80003a12:	6442                	ld	s0,16(sp)
    80003a14:	64a2                	ld	s1,8(sp)
    80003a16:	6902                	ld	s2,0(sp)
    80003a18:	6105                	addi	sp,sp,32
    80003a1a:	8082                	ret

0000000080003a1c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a1c:	7179                	addi	sp,sp,-48
    80003a1e:	f406                	sd	ra,40(sp)
    80003a20:	f022                	sd	s0,32(sp)
    80003a22:	ec26                	sd	s1,24(sp)
    80003a24:	e84a                	sd	s2,16(sp)
    80003a26:	e44e                	sd	s3,8(sp)
    80003a28:	1800                	addi	s0,sp,48
    80003a2a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a2c:	00850913          	addi	s2,a0,8
    80003a30:	854a                	mv	a0,s2
    80003a32:	00003097          	auipc	ra,0x3
    80003a36:	856080e7          	jalr	-1962(ra) # 80006288 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a3a:	409c                	lw	a5,0(s1)
    80003a3c:	ef99                	bnez	a5,80003a5a <holdingsleep+0x3e>
    80003a3e:	4481                	li	s1,0
  release(&lk->lk);
    80003a40:	854a                	mv	a0,s2
    80003a42:	00003097          	auipc	ra,0x3
    80003a46:	8fa080e7          	jalr	-1798(ra) # 8000633c <release>
  return r;
}
    80003a4a:	8526                	mv	a0,s1
    80003a4c:	70a2                	ld	ra,40(sp)
    80003a4e:	7402                	ld	s0,32(sp)
    80003a50:	64e2                	ld	s1,24(sp)
    80003a52:	6942                	ld	s2,16(sp)
    80003a54:	69a2                	ld	s3,8(sp)
    80003a56:	6145                	addi	sp,sp,48
    80003a58:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a5a:	0284a983          	lw	s3,40(s1)
    80003a5e:	ffffd097          	auipc	ra,0xffffd
    80003a62:	518080e7          	jalr	1304(ra) # 80000f76 <myproc>
    80003a66:	5904                	lw	s1,48(a0)
    80003a68:	413484b3          	sub	s1,s1,s3
    80003a6c:	0014b493          	seqz	s1,s1
    80003a70:	bfc1                	j	80003a40 <holdingsleep+0x24>

0000000080003a72 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a72:	1141                	addi	sp,sp,-16
    80003a74:	e406                	sd	ra,8(sp)
    80003a76:	e022                	sd	s0,0(sp)
    80003a78:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a7a:	00005597          	auipc	a1,0x5
    80003a7e:	c0658593          	addi	a1,a1,-1018 # 80008680 <syscalls+0x280>
    80003a82:	00016517          	auipc	a0,0x16
    80003a86:	8e650513          	addi	a0,a0,-1818 # 80019368 <ftable>
    80003a8a:	00002097          	auipc	ra,0x2
    80003a8e:	76e080e7          	jalr	1902(ra) # 800061f8 <initlock>
}
    80003a92:	60a2                	ld	ra,8(sp)
    80003a94:	6402                	ld	s0,0(sp)
    80003a96:	0141                	addi	sp,sp,16
    80003a98:	8082                	ret

0000000080003a9a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a9a:	1101                	addi	sp,sp,-32
    80003a9c:	ec06                	sd	ra,24(sp)
    80003a9e:	e822                	sd	s0,16(sp)
    80003aa0:	e426                	sd	s1,8(sp)
    80003aa2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003aa4:	00016517          	auipc	a0,0x16
    80003aa8:	8c450513          	addi	a0,a0,-1852 # 80019368 <ftable>
    80003aac:	00002097          	auipc	ra,0x2
    80003ab0:	7dc080e7          	jalr	2012(ra) # 80006288 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ab4:	00016497          	auipc	s1,0x16
    80003ab8:	8cc48493          	addi	s1,s1,-1844 # 80019380 <ftable+0x18>
    80003abc:	00017717          	auipc	a4,0x17
    80003ac0:	86470713          	addi	a4,a4,-1948 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003ac4:	40dc                	lw	a5,4(s1)
    80003ac6:	cf99                	beqz	a5,80003ae4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ac8:	02848493          	addi	s1,s1,40
    80003acc:	fee49ce3          	bne	s1,a4,80003ac4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003ad0:	00016517          	auipc	a0,0x16
    80003ad4:	89850513          	addi	a0,a0,-1896 # 80019368 <ftable>
    80003ad8:	00003097          	auipc	ra,0x3
    80003adc:	864080e7          	jalr	-1948(ra) # 8000633c <release>
  return 0;
    80003ae0:	4481                	li	s1,0
    80003ae2:	a819                	j	80003af8 <filealloc+0x5e>
      f->ref = 1;
    80003ae4:	4785                	li	a5,1
    80003ae6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ae8:	00016517          	auipc	a0,0x16
    80003aec:	88050513          	addi	a0,a0,-1920 # 80019368 <ftable>
    80003af0:	00003097          	auipc	ra,0x3
    80003af4:	84c080e7          	jalr	-1972(ra) # 8000633c <release>
}
    80003af8:	8526                	mv	a0,s1
    80003afa:	60e2                	ld	ra,24(sp)
    80003afc:	6442                	ld	s0,16(sp)
    80003afe:	64a2                	ld	s1,8(sp)
    80003b00:	6105                	addi	sp,sp,32
    80003b02:	8082                	ret

0000000080003b04 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b04:	1101                	addi	sp,sp,-32
    80003b06:	ec06                	sd	ra,24(sp)
    80003b08:	e822                	sd	s0,16(sp)
    80003b0a:	e426                	sd	s1,8(sp)
    80003b0c:	1000                	addi	s0,sp,32
    80003b0e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b10:	00016517          	auipc	a0,0x16
    80003b14:	85850513          	addi	a0,a0,-1960 # 80019368 <ftable>
    80003b18:	00002097          	auipc	ra,0x2
    80003b1c:	770080e7          	jalr	1904(ra) # 80006288 <acquire>
  if(f->ref < 1)
    80003b20:	40dc                	lw	a5,4(s1)
    80003b22:	02f05263          	blez	a5,80003b46 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b26:	2785                	addiw	a5,a5,1
    80003b28:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b2a:	00016517          	auipc	a0,0x16
    80003b2e:	83e50513          	addi	a0,a0,-1986 # 80019368 <ftable>
    80003b32:	00003097          	auipc	ra,0x3
    80003b36:	80a080e7          	jalr	-2038(ra) # 8000633c <release>
  return f;
}
    80003b3a:	8526                	mv	a0,s1
    80003b3c:	60e2                	ld	ra,24(sp)
    80003b3e:	6442                	ld	s0,16(sp)
    80003b40:	64a2                	ld	s1,8(sp)
    80003b42:	6105                	addi	sp,sp,32
    80003b44:	8082                	ret
    panic("filedup");
    80003b46:	00005517          	auipc	a0,0x5
    80003b4a:	b4250513          	addi	a0,a0,-1214 # 80008688 <syscalls+0x288>
    80003b4e:	00002097          	auipc	ra,0x2
    80003b52:	202080e7          	jalr	514(ra) # 80005d50 <panic>

0000000080003b56 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b56:	7139                	addi	sp,sp,-64
    80003b58:	fc06                	sd	ra,56(sp)
    80003b5a:	f822                	sd	s0,48(sp)
    80003b5c:	f426                	sd	s1,40(sp)
    80003b5e:	f04a                	sd	s2,32(sp)
    80003b60:	ec4e                	sd	s3,24(sp)
    80003b62:	e852                	sd	s4,16(sp)
    80003b64:	e456                	sd	s5,8(sp)
    80003b66:	0080                	addi	s0,sp,64
    80003b68:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b6a:	00015517          	auipc	a0,0x15
    80003b6e:	7fe50513          	addi	a0,a0,2046 # 80019368 <ftable>
    80003b72:	00002097          	auipc	ra,0x2
    80003b76:	716080e7          	jalr	1814(ra) # 80006288 <acquire>
  if(f->ref < 1)
    80003b7a:	40dc                	lw	a5,4(s1)
    80003b7c:	06f05163          	blez	a5,80003bde <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b80:	37fd                	addiw	a5,a5,-1
    80003b82:	0007871b          	sext.w	a4,a5
    80003b86:	c0dc                	sw	a5,4(s1)
    80003b88:	06e04363          	bgtz	a4,80003bee <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b8c:	0004a903          	lw	s2,0(s1)
    80003b90:	0094ca83          	lbu	s5,9(s1)
    80003b94:	0104ba03          	ld	s4,16(s1)
    80003b98:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b9c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ba0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ba4:	00015517          	auipc	a0,0x15
    80003ba8:	7c450513          	addi	a0,a0,1988 # 80019368 <ftable>
    80003bac:	00002097          	auipc	ra,0x2
    80003bb0:	790080e7          	jalr	1936(ra) # 8000633c <release>

  if(ff.type == FD_PIPE){
    80003bb4:	4785                	li	a5,1
    80003bb6:	04f90d63          	beq	s2,a5,80003c10 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bba:	3979                	addiw	s2,s2,-2
    80003bbc:	4785                	li	a5,1
    80003bbe:	0527e063          	bltu	a5,s2,80003bfe <fileclose+0xa8>
    begin_op();
    80003bc2:	00000097          	auipc	ra,0x0
    80003bc6:	acc080e7          	jalr	-1332(ra) # 8000368e <begin_op>
    iput(ff.ip);
    80003bca:	854e                	mv	a0,s3
    80003bcc:	fffff097          	auipc	ra,0xfffff
    80003bd0:	2a0080e7          	jalr	672(ra) # 80002e6c <iput>
    end_op();
    80003bd4:	00000097          	auipc	ra,0x0
    80003bd8:	b38080e7          	jalr	-1224(ra) # 8000370c <end_op>
    80003bdc:	a00d                	j	80003bfe <fileclose+0xa8>
    panic("fileclose");
    80003bde:	00005517          	auipc	a0,0x5
    80003be2:	ab250513          	addi	a0,a0,-1358 # 80008690 <syscalls+0x290>
    80003be6:	00002097          	auipc	ra,0x2
    80003bea:	16a080e7          	jalr	362(ra) # 80005d50 <panic>
    release(&ftable.lock);
    80003bee:	00015517          	auipc	a0,0x15
    80003bf2:	77a50513          	addi	a0,a0,1914 # 80019368 <ftable>
    80003bf6:	00002097          	auipc	ra,0x2
    80003bfa:	746080e7          	jalr	1862(ra) # 8000633c <release>
  }
}
    80003bfe:	70e2                	ld	ra,56(sp)
    80003c00:	7442                	ld	s0,48(sp)
    80003c02:	74a2                	ld	s1,40(sp)
    80003c04:	7902                	ld	s2,32(sp)
    80003c06:	69e2                	ld	s3,24(sp)
    80003c08:	6a42                	ld	s4,16(sp)
    80003c0a:	6aa2                	ld	s5,8(sp)
    80003c0c:	6121                	addi	sp,sp,64
    80003c0e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c10:	85d6                	mv	a1,s5
    80003c12:	8552                	mv	a0,s4
    80003c14:	00000097          	auipc	ra,0x0
    80003c18:	34c080e7          	jalr	844(ra) # 80003f60 <pipeclose>
    80003c1c:	b7cd                	j	80003bfe <fileclose+0xa8>

0000000080003c1e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c1e:	715d                	addi	sp,sp,-80
    80003c20:	e486                	sd	ra,72(sp)
    80003c22:	e0a2                	sd	s0,64(sp)
    80003c24:	fc26                	sd	s1,56(sp)
    80003c26:	f84a                	sd	s2,48(sp)
    80003c28:	f44e                	sd	s3,40(sp)
    80003c2a:	0880                	addi	s0,sp,80
    80003c2c:	84aa                	mv	s1,a0
    80003c2e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c30:	ffffd097          	auipc	ra,0xffffd
    80003c34:	346080e7          	jalr	838(ra) # 80000f76 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c38:	409c                	lw	a5,0(s1)
    80003c3a:	37f9                	addiw	a5,a5,-2
    80003c3c:	4705                	li	a4,1
    80003c3e:	04f76763          	bltu	a4,a5,80003c8c <filestat+0x6e>
    80003c42:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c44:	6c88                	ld	a0,24(s1)
    80003c46:	fffff097          	auipc	ra,0xfffff
    80003c4a:	06c080e7          	jalr	108(ra) # 80002cb2 <ilock>
    stati(f->ip, &st);
    80003c4e:	fb840593          	addi	a1,s0,-72
    80003c52:	6c88                	ld	a0,24(s1)
    80003c54:	fffff097          	auipc	ra,0xfffff
    80003c58:	2e8080e7          	jalr	744(ra) # 80002f3c <stati>
    iunlock(f->ip);
    80003c5c:	6c88                	ld	a0,24(s1)
    80003c5e:	fffff097          	auipc	ra,0xfffff
    80003c62:	116080e7          	jalr	278(ra) # 80002d74 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c66:	46e1                	li	a3,24
    80003c68:	fb840613          	addi	a2,s0,-72
    80003c6c:	85ce                	mv	a1,s3
    80003c6e:	05093503          	ld	a0,80(s2)
    80003c72:	ffffd097          	auipc	ra,0xffffd
    80003c76:	e96080e7          	jalr	-362(ra) # 80000b08 <copyout>
    80003c7a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c7e:	60a6                	ld	ra,72(sp)
    80003c80:	6406                	ld	s0,64(sp)
    80003c82:	74e2                	ld	s1,56(sp)
    80003c84:	7942                	ld	s2,48(sp)
    80003c86:	79a2                	ld	s3,40(sp)
    80003c88:	6161                	addi	sp,sp,80
    80003c8a:	8082                	ret
  return -1;
    80003c8c:	557d                	li	a0,-1
    80003c8e:	bfc5                	j	80003c7e <filestat+0x60>

0000000080003c90 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c90:	7179                	addi	sp,sp,-48
    80003c92:	f406                	sd	ra,40(sp)
    80003c94:	f022                	sd	s0,32(sp)
    80003c96:	ec26                	sd	s1,24(sp)
    80003c98:	e84a                	sd	s2,16(sp)
    80003c9a:	e44e                	sd	s3,8(sp)
    80003c9c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c9e:	00854783          	lbu	a5,8(a0)
    80003ca2:	c3d5                	beqz	a5,80003d46 <fileread+0xb6>
    80003ca4:	84aa                	mv	s1,a0
    80003ca6:	89ae                	mv	s3,a1
    80003ca8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003caa:	411c                	lw	a5,0(a0)
    80003cac:	4705                	li	a4,1
    80003cae:	04e78963          	beq	a5,a4,80003d00 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cb2:	470d                	li	a4,3
    80003cb4:	04e78d63          	beq	a5,a4,80003d0e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cb8:	4709                	li	a4,2
    80003cba:	06e79e63          	bne	a5,a4,80003d36 <fileread+0xa6>
    ilock(f->ip);
    80003cbe:	6d08                	ld	a0,24(a0)
    80003cc0:	fffff097          	auipc	ra,0xfffff
    80003cc4:	ff2080e7          	jalr	-14(ra) # 80002cb2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003cc8:	874a                	mv	a4,s2
    80003cca:	5094                	lw	a3,32(s1)
    80003ccc:	864e                	mv	a2,s3
    80003cce:	4585                	li	a1,1
    80003cd0:	6c88                	ld	a0,24(s1)
    80003cd2:	fffff097          	auipc	ra,0xfffff
    80003cd6:	294080e7          	jalr	660(ra) # 80002f66 <readi>
    80003cda:	892a                	mv	s2,a0
    80003cdc:	00a05563          	blez	a0,80003ce6 <fileread+0x56>
      f->off += r;
    80003ce0:	509c                	lw	a5,32(s1)
    80003ce2:	9fa9                	addw	a5,a5,a0
    80003ce4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003ce6:	6c88                	ld	a0,24(s1)
    80003ce8:	fffff097          	auipc	ra,0xfffff
    80003cec:	08c080e7          	jalr	140(ra) # 80002d74 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003cf0:	854a                	mv	a0,s2
    80003cf2:	70a2                	ld	ra,40(sp)
    80003cf4:	7402                	ld	s0,32(sp)
    80003cf6:	64e2                	ld	s1,24(sp)
    80003cf8:	6942                	ld	s2,16(sp)
    80003cfa:	69a2                	ld	s3,8(sp)
    80003cfc:	6145                	addi	sp,sp,48
    80003cfe:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d00:	6908                	ld	a0,16(a0)
    80003d02:	00000097          	auipc	ra,0x0
    80003d06:	3c0080e7          	jalr	960(ra) # 800040c2 <piperead>
    80003d0a:	892a                	mv	s2,a0
    80003d0c:	b7d5                	j	80003cf0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d0e:	02451783          	lh	a5,36(a0)
    80003d12:	03079693          	slli	a3,a5,0x30
    80003d16:	92c1                	srli	a3,a3,0x30
    80003d18:	4725                	li	a4,9
    80003d1a:	02d76863          	bltu	a4,a3,80003d4a <fileread+0xba>
    80003d1e:	0792                	slli	a5,a5,0x4
    80003d20:	00015717          	auipc	a4,0x15
    80003d24:	5a870713          	addi	a4,a4,1448 # 800192c8 <devsw>
    80003d28:	97ba                	add	a5,a5,a4
    80003d2a:	639c                	ld	a5,0(a5)
    80003d2c:	c38d                	beqz	a5,80003d4e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d2e:	4505                	li	a0,1
    80003d30:	9782                	jalr	a5
    80003d32:	892a                	mv	s2,a0
    80003d34:	bf75                	j	80003cf0 <fileread+0x60>
    panic("fileread");
    80003d36:	00005517          	auipc	a0,0x5
    80003d3a:	96a50513          	addi	a0,a0,-1686 # 800086a0 <syscalls+0x2a0>
    80003d3e:	00002097          	auipc	ra,0x2
    80003d42:	012080e7          	jalr	18(ra) # 80005d50 <panic>
    return -1;
    80003d46:	597d                	li	s2,-1
    80003d48:	b765                	j	80003cf0 <fileread+0x60>
      return -1;
    80003d4a:	597d                	li	s2,-1
    80003d4c:	b755                	j	80003cf0 <fileread+0x60>
    80003d4e:	597d                	li	s2,-1
    80003d50:	b745                	j	80003cf0 <fileread+0x60>

0000000080003d52 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d52:	715d                	addi	sp,sp,-80
    80003d54:	e486                	sd	ra,72(sp)
    80003d56:	e0a2                	sd	s0,64(sp)
    80003d58:	fc26                	sd	s1,56(sp)
    80003d5a:	f84a                	sd	s2,48(sp)
    80003d5c:	f44e                	sd	s3,40(sp)
    80003d5e:	f052                	sd	s4,32(sp)
    80003d60:	ec56                	sd	s5,24(sp)
    80003d62:	e85a                	sd	s6,16(sp)
    80003d64:	e45e                	sd	s7,8(sp)
    80003d66:	e062                	sd	s8,0(sp)
    80003d68:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d6a:	00954783          	lbu	a5,9(a0)
    80003d6e:	10078663          	beqz	a5,80003e7a <filewrite+0x128>
    80003d72:	892a                	mv	s2,a0
    80003d74:	8b2e                	mv	s6,a1
    80003d76:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d78:	411c                	lw	a5,0(a0)
    80003d7a:	4705                	li	a4,1
    80003d7c:	02e78263          	beq	a5,a4,80003da0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d80:	470d                	li	a4,3
    80003d82:	02e78663          	beq	a5,a4,80003dae <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d86:	4709                	li	a4,2
    80003d88:	0ee79163          	bne	a5,a4,80003e6a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d8c:	0ac05d63          	blez	a2,80003e46 <filewrite+0xf4>
    int i = 0;
    80003d90:	4981                	li	s3,0
    80003d92:	6b85                	lui	s7,0x1
    80003d94:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d98:	6c05                	lui	s8,0x1
    80003d9a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d9e:	a861                	j	80003e36 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003da0:	6908                	ld	a0,16(a0)
    80003da2:	00000097          	auipc	ra,0x0
    80003da6:	22e080e7          	jalr	558(ra) # 80003fd0 <pipewrite>
    80003daa:	8a2a                	mv	s4,a0
    80003dac:	a045                	j	80003e4c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003dae:	02451783          	lh	a5,36(a0)
    80003db2:	03079693          	slli	a3,a5,0x30
    80003db6:	92c1                	srli	a3,a3,0x30
    80003db8:	4725                	li	a4,9
    80003dba:	0cd76263          	bltu	a4,a3,80003e7e <filewrite+0x12c>
    80003dbe:	0792                	slli	a5,a5,0x4
    80003dc0:	00015717          	auipc	a4,0x15
    80003dc4:	50870713          	addi	a4,a4,1288 # 800192c8 <devsw>
    80003dc8:	97ba                	add	a5,a5,a4
    80003dca:	679c                	ld	a5,8(a5)
    80003dcc:	cbdd                	beqz	a5,80003e82 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003dce:	4505                	li	a0,1
    80003dd0:	9782                	jalr	a5
    80003dd2:	8a2a                	mv	s4,a0
    80003dd4:	a8a5                	j	80003e4c <filewrite+0xfa>
    80003dd6:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003dda:	00000097          	auipc	ra,0x0
    80003dde:	8b4080e7          	jalr	-1868(ra) # 8000368e <begin_op>
      ilock(f->ip);
    80003de2:	01893503          	ld	a0,24(s2)
    80003de6:	fffff097          	auipc	ra,0xfffff
    80003dea:	ecc080e7          	jalr	-308(ra) # 80002cb2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003dee:	8756                	mv	a4,s5
    80003df0:	02092683          	lw	a3,32(s2)
    80003df4:	01698633          	add	a2,s3,s6
    80003df8:	4585                	li	a1,1
    80003dfa:	01893503          	ld	a0,24(s2)
    80003dfe:	fffff097          	auipc	ra,0xfffff
    80003e02:	260080e7          	jalr	608(ra) # 8000305e <writei>
    80003e06:	84aa                	mv	s1,a0
    80003e08:	00a05763          	blez	a0,80003e16 <filewrite+0xc4>
        f->off += r;
    80003e0c:	02092783          	lw	a5,32(s2)
    80003e10:	9fa9                	addw	a5,a5,a0
    80003e12:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e16:	01893503          	ld	a0,24(s2)
    80003e1a:	fffff097          	auipc	ra,0xfffff
    80003e1e:	f5a080e7          	jalr	-166(ra) # 80002d74 <iunlock>
      end_op();
    80003e22:	00000097          	auipc	ra,0x0
    80003e26:	8ea080e7          	jalr	-1814(ra) # 8000370c <end_op>

      if(r != n1){
    80003e2a:	009a9f63          	bne	s5,s1,80003e48 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e2e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e32:	0149db63          	bge	s3,s4,80003e48 <filewrite+0xf6>
      int n1 = n - i;
    80003e36:	413a04bb          	subw	s1,s4,s3
    80003e3a:	0004879b          	sext.w	a5,s1
    80003e3e:	f8fbdce3          	bge	s7,a5,80003dd6 <filewrite+0x84>
    80003e42:	84e2                	mv	s1,s8
    80003e44:	bf49                	j	80003dd6 <filewrite+0x84>
    int i = 0;
    80003e46:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e48:	013a1f63          	bne	s4,s3,80003e66 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e4c:	8552                	mv	a0,s4
    80003e4e:	60a6                	ld	ra,72(sp)
    80003e50:	6406                	ld	s0,64(sp)
    80003e52:	74e2                	ld	s1,56(sp)
    80003e54:	7942                	ld	s2,48(sp)
    80003e56:	79a2                	ld	s3,40(sp)
    80003e58:	7a02                	ld	s4,32(sp)
    80003e5a:	6ae2                	ld	s5,24(sp)
    80003e5c:	6b42                	ld	s6,16(sp)
    80003e5e:	6ba2                	ld	s7,8(sp)
    80003e60:	6c02                	ld	s8,0(sp)
    80003e62:	6161                	addi	sp,sp,80
    80003e64:	8082                	ret
    ret = (i == n ? n : -1);
    80003e66:	5a7d                	li	s4,-1
    80003e68:	b7d5                	j	80003e4c <filewrite+0xfa>
    panic("filewrite");
    80003e6a:	00005517          	auipc	a0,0x5
    80003e6e:	84650513          	addi	a0,a0,-1978 # 800086b0 <syscalls+0x2b0>
    80003e72:	00002097          	auipc	ra,0x2
    80003e76:	ede080e7          	jalr	-290(ra) # 80005d50 <panic>
    return -1;
    80003e7a:	5a7d                	li	s4,-1
    80003e7c:	bfc1                	j	80003e4c <filewrite+0xfa>
      return -1;
    80003e7e:	5a7d                	li	s4,-1
    80003e80:	b7f1                	j	80003e4c <filewrite+0xfa>
    80003e82:	5a7d                	li	s4,-1
    80003e84:	b7e1                	j	80003e4c <filewrite+0xfa>

0000000080003e86 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e86:	7179                	addi	sp,sp,-48
    80003e88:	f406                	sd	ra,40(sp)
    80003e8a:	f022                	sd	s0,32(sp)
    80003e8c:	ec26                	sd	s1,24(sp)
    80003e8e:	e84a                	sd	s2,16(sp)
    80003e90:	e44e                	sd	s3,8(sp)
    80003e92:	e052                	sd	s4,0(sp)
    80003e94:	1800                	addi	s0,sp,48
    80003e96:	84aa                	mv	s1,a0
    80003e98:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e9a:	0005b023          	sd	zero,0(a1)
    80003e9e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ea2:	00000097          	auipc	ra,0x0
    80003ea6:	bf8080e7          	jalr	-1032(ra) # 80003a9a <filealloc>
    80003eaa:	e088                	sd	a0,0(s1)
    80003eac:	c551                	beqz	a0,80003f38 <pipealloc+0xb2>
    80003eae:	00000097          	auipc	ra,0x0
    80003eb2:	bec080e7          	jalr	-1044(ra) # 80003a9a <filealloc>
    80003eb6:	00aa3023          	sd	a0,0(s4)
    80003eba:	c92d                	beqz	a0,80003f2c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ebc:	ffffc097          	auipc	ra,0xffffc
    80003ec0:	25e080e7          	jalr	606(ra) # 8000011a <kalloc>
    80003ec4:	892a                	mv	s2,a0
    80003ec6:	c125                	beqz	a0,80003f26 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ec8:	4985                	li	s3,1
    80003eca:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ece:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ed2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ed6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003eda:	00004597          	auipc	a1,0x4
    80003ede:	7e658593          	addi	a1,a1,2022 # 800086c0 <syscalls+0x2c0>
    80003ee2:	00002097          	auipc	ra,0x2
    80003ee6:	316080e7          	jalr	790(ra) # 800061f8 <initlock>
  (*f0)->type = FD_PIPE;
    80003eea:	609c                	ld	a5,0(s1)
    80003eec:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ef0:	609c                	ld	a5,0(s1)
    80003ef2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ef6:	609c                	ld	a5,0(s1)
    80003ef8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003efc:	609c                	ld	a5,0(s1)
    80003efe:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f02:	000a3783          	ld	a5,0(s4)
    80003f06:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f0a:	000a3783          	ld	a5,0(s4)
    80003f0e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f12:	000a3783          	ld	a5,0(s4)
    80003f16:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f1a:	000a3783          	ld	a5,0(s4)
    80003f1e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f22:	4501                	li	a0,0
    80003f24:	a025                	j	80003f4c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f26:	6088                	ld	a0,0(s1)
    80003f28:	e501                	bnez	a0,80003f30 <pipealloc+0xaa>
    80003f2a:	a039                	j	80003f38 <pipealloc+0xb2>
    80003f2c:	6088                	ld	a0,0(s1)
    80003f2e:	c51d                	beqz	a0,80003f5c <pipealloc+0xd6>
    fileclose(*f0);
    80003f30:	00000097          	auipc	ra,0x0
    80003f34:	c26080e7          	jalr	-986(ra) # 80003b56 <fileclose>
  if(*f1)
    80003f38:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f3c:	557d                	li	a0,-1
  if(*f1)
    80003f3e:	c799                	beqz	a5,80003f4c <pipealloc+0xc6>
    fileclose(*f1);
    80003f40:	853e                	mv	a0,a5
    80003f42:	00000097          	auipc	ra,0x0
    80003f46:	c14080e7          	jalr	-1004(ra) # 80003b56 <fileclose>
  return -1;
    80003f4a:	557d                	li	a0,-1
}
    80003f4c:	70a2                	ld	ra,40(sp)
    80003f4e:	7402                	ld	s0,32(sp)
    80003f50:	64e2                	ld	s1,24(sp)
    80003f52:	6942                	ld	s2,16(sp)
    80003f54:	69a2                	ld	s3,8(sp)
    80003f56:	6a02                	ld	s4,0(sp)
    80003f58:	6145                	addi	sp,sp,48
    80003f5a:	8082                	ret
  return -1;
    80003f5c:	557d                	li	a0,-1
    80003f5e:	b7fd                	j	80003f4c <pipealloc+0xc6>

0000000080003f60 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f60:	1101                	addi	sp,sp,-32
    80003f62:	ec06                	sd	ra,24(sp)
    80003f64:	e822                	sd	s0,16(sp)
    80003f66:	e426                	sd	s1,8(sp)
    80003f68:	e04a                	sd	s2,0(sp)
    80003f6a:	1000                	addi	s0,sp,32
    80003f6c:	84aa                	mv	s1,a0
    80003f6e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f70:	00002097          	auipc	ra,0x2
    80003f74:	318080e7          	jalr	792(ra) # 80006288 <acquire>
  if(writable){
    80003f78:	02090d63          	beqz	s2,80003fb2 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f7c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f80:	21848513          	addi	a0,s1,536
    80003f84:	ffffe097          	auipc	ra,0xffffe
    80003f88:	8cc080e7          	jalr	-1844(ra) # 80001850 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f8c:	2204b783          	ld	a5,544(s1)
    80003f90:	eb95                	bnez	a5,80003fc4 <pipeclose+0x64>
    release(&pi->lock);
    80003f92:	8526                	mv	a0,s1
    80003f94:	00002097          	auipc	ra,0x2
    80003f98:	3a8080e7          	jalr	936(ra) # 8000633c <release>
    kfree((char*)pi);
    80003f9c:	8526                	mv	a0,s1
    80003f9e:	ffffc097          	auipc	ra,0xffffc
    80003fa2:	07e080e7          	jalr	126(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fa6:	60e2                	ld	ra,24(sp)
    80003fa8:	6442                	ld	s0,16(sp)
    80003faa:	64a2                	ld	s1,8(sp)
    80003fac:	6902                	ld	s2,0(sp)
    80003fae:	6105                	addi	sp,sp,32
    80003fb0:	8082                	ret
    pi->readopen = 0;
    80003fb2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fb6:	21c48513          	addi	a0,s1,540
    80003fba:	ffffe097          	auipc	ra,0xffffe
    80003fbe:	896080e7          	jalr	-1898(ra) # 80001850 <wakeup>
    80003fc2:	b7e9                	j	80003f8c <pipeclose+0x2c>
    release(&pi->lock);
    80003fc4:	8526                	mv	a0,s1
    80003fc6:	00002097          	auipc	ra,0x2
    80003fca:	376080e7          	jalr	886(ra) # 8000633c <release>
}
    80003fce:	bfe1                	j	80003fa6 <pipeclose+0x46>

0000000080003fd0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fd0:	711d                	addi	sp,sp,-96
    80003fd2:	ec86                	sd	ra,88(sp)
    80003fd4:	e8a2                	sd	s0,80(sp)
    80003fd6:	e4a6                	sd	s1,72(sp)
    80003fd8:	e0ca                	sd	s2,64(sp)
    80003fda:	fc4e                	sd	s3,56(sp)
    80003fdc:	f852                	sd	s4,48(sp)
    80003fde:	f456                	sd	s5,40(sp)
    80003fe0:	f05a                	sd	s6,32(sp)
    80003fe2:	ec5e                	sd	s7,24(sp)
    80003fe4:	e862                	sd	s8,16(sp)
    80003fe6:	1080                	addi	s0,sp,96
    80003fe8:	84aa                	mv	s1,a0
    80003fea:	8aae                	mv	s5,a1
    80003fec:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fee:	ffffd097          	auipc	ra,0xffffd
    80003ff2:	f88080e7          	jalr	-120(ra) # 80000f76 <myproc>
    80003ff6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ff8:	8526                	mv	a0,s1
    80003ffa:	00002097          	auipc	ra,0x2
    80003ffe:	28e080e7          	jalr	654(ra) # 80006288 <acquire>
  while(i < n){
    80004002:	0b405363          	blez	s4,800040a8 <pipewrite+0xd8>
  int i = 0;
    80004006:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004008:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000400a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000400e:	21c48b93          	addi	s7,s1,540
    80004012:	a089                	j	80004054 <pipewrite+0x84>
      release(&pi->lock);
    80004014:	8526                	mv	a0,s1
    80004016:	00002097          	auipc	ra,0x2
    8000401a:	326080e7          	jalr	806(ra) # 8000633c <release>
      return -1;
    8000401e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004020:	854a                	mv	a0,s2
    80004022:	60e6                	ld	ra,88(sp)
    80004024:	6446                	ld	s0,80(sp)
    80004026:	64a6                	ld	s1,72(sp)
    80004028:	6906                	ld	s2,64(sp)
    8000402a:	79e2                	ld	s3,56(sp)
    8000402c:	7a42                	ld	s4,48(sp)
    8000402e:	7aa2                	ld	s5,40(sp)
    80004030:	7b02                	ld	s6,32(sp)
    80004032:	6be2                	ld	s7,24(sp)
    80004034:	6c42                	ld	s8,16(sp)
    80004036:	6125                	addi	sp,sp,96
    80004038:	8082                	ret
      wakeup(&pi->nread);
    8000403a:	8562                	mv	a0,s8
    8000403c:	ffffe097          	auipc	ra,0xffffe
    80004040:	814080e7          	jalr	-2028(ra) # 80001850 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004044:	85a6                	mv	a1,s1
    80004046:	855e                	mv	a0,s7
    80004048:	ffffd097          	auipc	ra,0xffffd
    8000404c:	67c080e7          	jalr	1660(ra) # 800016c4 <sleep>
  while(i < n){
    80004050:	05495d63          	bge	s2,s4,800040aa <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004054:	2204a783          	lw	a5,544(s1)
    80004058:	dfd5                	beqz	a5,80004014 <pipewrite+0x44>
    8000405a:	0289a783          	lw	a5,40(s3)
    8000405e:	fbdd                	bnez	a5,80004014 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004060:	2184a783          	lw	a5,536(s1)
    80004064:	21c4a703          	lw	a4,540(s1)
    80004068:	2007879b          	addiw	a5,a5,512
    8000406c:	fcf707e3          	beq	a4,a5,8000403a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004070:	4685                	li	a3,1
    80004072:	01590633          	add	a2,s2,s5
    80004076:	faf40593          	addi	a1,s0,-81
    8000407a:	0509b503          	ld	a0,80(s3)
    8000407e:	ffffd097          	auipc	ra,0xffffd
    80004082:	b16080e7          	jalr	-1258(ra) # 80000b94 <copyin>
    80004086:	03650263          	beq	a0,s6,800040aa <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000408a:	21c4a783          	lw	a5,540(s1)
    8000408e:	0017871b          	addiw	a4,a5,1
    80004092:	20e4ae23          	sw	a4,540(s1)
    80004096:	1ff7f793          	andi	a5,a5,511
    8000409a:	97a6                	add	a5,a5,s1
    8000409c:	faf44703          	lbu	a4,-81(s0)
    800040a0:	00e78c23          	sb	a4,24(a5)
      i++;
    800040a4:	2905                	addiw	s2,s2,1
    800040a6:	b76d                	j	80004050 <pipewrite+0x80>
  int i = 0;
    800040a8:	4901                	li	s2,0
  wakeup(&pi->nread);
    800040aa:	21848513          	addi	a0,s1,536
    800040ae:	ffffd097          	auipc	ra,0xffffd
    800040b2:	7a2080e7          	jalr	1954(ra) # 80001850 <wakeup>
  release(&pi->lock);
    800040b6:	8526                	mv	a0,s1
    800040b8:	00002097          	auipc	ra,0x2
    800040bc:	284080e7          	jalr	644(ra) # 8000633c <release>
  return i;
    800040c0:	b785                	j	80004020 <pipewrite+0x50>

00000000800040c2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040c2:	715d                	addi	sp,sp,-80
    800040c4:	e486                	sd	ra,72(sp)
    800040c6:	e0a2                	sd	s0,64(sp)
    800040c8:	fc26                	sd	s1,56(sp)
    800040ca:	f84a                	sd	s2,48(sp)
    800040cc:	f44e                	sd	s3,40(sp)
    800040ce:	f052                	sd	s4,32(sp)
    800040d0:	ec56                	sd	s5,24(sp)
    800040d2:	e85a                	sd	s6,16(sp)
    800040d4:	0880                	addi	s0,sp,80
    800040d6:	84aa                	mv	s1,a0
    800040d8:	892e                	mv	s2,a1
    800040da:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040dc:	ffffd097          	auipc	ra,0xffffd
    800040e0:	e9a080e7          	jalr	-358(ra) # 80000f76 <myproc>
    800040e4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040e6:	8526                	mv	a0,s1
    800040e8:	00002097          	auipc	ra,0x2
    800040ec:	1a0080e7          	jalr	416(ra) # 80006288 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040f0:	2184a703          	lw	a4,536(s1)
    800040f4:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040f8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040fc:	02f71463          	bne	a4,a5,80004124 <piperead+0x62>
    80004100:	2244a783          	lw	a5,548(s1)
    80004104:	c385                	beqz	a5,80004124 <piperead+0x62>
    if(pr->killed){
    80004106:	028a2783          	lw	a5,40(s4)
    8000410a:	ebc9                	bnez	a5,8000419c <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000410c:	85a6                	mv	a1,s1
    8000410e:	854e                	mv	a0,s3
    80004110:	ffffd097          	auipc	ra,0xffffd
    80004114:	5b4080e7          	jalr	1460(ra) # 800016c4 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004118:	2184a703          	lw	a4,536(s1)
    8000411c:	21c4a783          	lw	a5,540(s1)
    80004120:	fef700e3          	beq	a4,a5,80004100 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004124:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004126:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004128:	05505463          	blez	s5,80004170 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    8000412c:	2184a783          	lw	a5,536(s1)
    80004130:	21c4a703          	lw	a4,540(s1)
    80004134:	02f70e63          	beq	a4,a5,80004170 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004138:	0017871b          	addiw	a4,a5,1
    8000413c:	20e4ac23          	sw	a4,536(s1)
    80004140:	1ff7f793          	andi	a5,a5,511
    80004144:	97a6                	add	a5,a5,s1
    80004146:	0187c783          	lbu	a5,24(a5)
    8000414a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000414e:	4685                	li	a3,1
    80004150:	fbf40613          	addi	a2,s0,-65
    80004154:	85ca                	mv	a1,s2
    80004156:	050a3503          	ld	a0,80(s4)
    8000415a:	ffffd097          	auipc	ra,0xffffd
    8000415e:	9ae080e7          	jalr	-1618(ra) # 80000b08 <copyout>
    80004162:	01650763          	beq	a0,s6,80004170 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004166:	2985                	addiw	s3,s3,1
    80004168:	0905                	addi	s2,s2,1
    8000416a:	fd3a91e3          	bne	s5,s3,8000412c <piperead+0x6a>
    8000416e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004170:	21c48513          	addi	a0,s1,540
    80004174:	ffffd097          	auipc	ra,0xffffd
    80004178:	6dc080e7          	jalr	1756(ra) # 80001850 <wakeup>
  release(&pi->lock);
    8000417c:	8526                	mv	a0,s1
    8000417e:	00002097          	auipc	ra,0x2
    80004182:	1be080e7          	jalr	446(ra) # 8000633c <release>
  return i;
}
    80004186:	854e                	mv	a0,s3
    80004188:	60a6                	ld	ra,72(sp)
    8000418a:	6406                	ld	s0,64(sp)
    8000418c:	74e2                	ld	s1,56(sp)
    8000418e:	7942                	ld	s2,48(sp)
    80004190:	79a2                	ld	s3,40(sp)
    80004192:	7a02                	ld	s4,32(sp)
    80004194:	6ae2                	ld	s5,24(sp)
    80004196:	6b42                	ld	s6,16(sp)
    80004198:	6161                	addi	sp,sp,80
    8000419a:	8082                	ret
      release(&pi->lock);
    8000419c:	8526                	mv	a0,s1
    8000419e:	00002097          	auipc	ra,0x2
    800041a2:	19e080e7          	jalr	414(ra) # 8000633c <release>
      return -1;
    800041a6:	59fd                	li	s3,-1
    800041a8:	bff9                	j	80004186 <piperead+0xc4>

00000000800041aa <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800041aa:	de010113          	addi	sp,sp,-544
    800041ae:	20113c23          	sd	ra,536(sp)
    800041b2:	20813823          	sd	s0,528(sp)
    800041b6:	20913423          	sd	s1,520(sp)
    800041ba:	21213023          	sd	s2,512(sp)
    800041be:	ffce                	sd	s3,504(sp)
    800041c0:	fbd2                	sd	s4,496(sp)
    800041c2:	f7d6                	sd	s5,488(sp)
    800041c4:	f3da                	sd	s6,480(sp)
    800041c6:	efde                	sd	s7,472(sp)
    800041c8:	ebe2                	sd	s8,464(sp)
    800041ca:	e7e6                	sd	s9,456(sp)
    800041cc:	e3ea                	sd	s10,448(sp)
    800041ce:	ff6e                	sd	s11,440(sp)
    800041d0:	1400                	addi	s0,sp,544
    800041d2:	892a                	mv	s2,a0
    800041d4:	dea43423          	sd	a0,-536(s0)
    800041d8:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041dc:	ffffd097          	auipc	ra,0xffffd
    800041e0:	d9a080e7          	jalr	-614(ra) # 80000f76 <myproc>
    800041e4:	84aa                	mv	s1,a0

  begin_op();
    800041e6:	fffff097          	auipc	ra,0xfffff
    800041ea:	4a8080e7          	jalr	1192(ra) # 8000368e <begin_op>

  if((ip = namei(path)) == 0){
    800041ee:	854a                	mv	a0,s2
    800041f0:	fffff097          	auipc	ra,0xfffff
    800041f4:	27e080e7          	jalr	638(ra) # 8000346e <namei>
    800041f8:	c93d                	beqz	a0,8000426e <exec+0xc4>
    800041fa:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041fc:	fffff097          	auipc	ra,0xfffff
    80004200:	ab6080e7          	jalr	-1354(ra) # 80002cb2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004204:	04000713          	li	a4,64
    80004208:	4681                	li	a3,0
    8000420a:	e5040613          	addi	a2,s0,-432
    8000420e:	4581                	li	a1,0
    80004210:	8556                	mv	a0,s5
    80004212:	fffff097          	auipc	ra,0xfffff
    80004216:	d54080e7          	jalr	-684(ra) # 80002f66 <readi>
    8000421a:	04000793          	li	a5,64
    8000421e:	00f51a63          	bne	a0,a5,80004232 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004222:	e5042703          	lw	a4,-432(s0)
    80004226:	464c47b7          	lui	a5,0x464c4
    8000422a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000422e:	04f70663          	beq	a4,a5,8000427a <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004232:	8556                	mv	a0,s5
    80004234:	fffff097          	auipc	ra,0xfffff
    80004238:	ce0080e7          	jalr	-800(ra) # 80002f14 <iunlockput>
    end_op();
    8000423c:	fffff097          	auipc	ra,0xfffff
    80004240:	4d0080e7          	jalr	1232(ra) # 8000370c <end_op>
  }
  return -1;
    80004244:	557d                	li	a0,-1
}
    80004246:	21813083          	ld	ra,536(sp)
    8000424a:	21013403          	ld	s0,528(sp)
    8000424e:	20813483          	ld	s1,520(sp)
    80004252:	20013903          	ld	s2,512(sp)
    80004256:	79fe                	ld	s3,504(sp)
    80004258:	7a5e                	ld	s4,496(sp)
    8000425a:	7abe                	ld	s5,488(sp)
    8000425c:	7b1e                	ld	s6,480(sp)
    8000425e:	6bfe                	ld	s7,472(sp)
    80004260:	6c5e                	ld	s8,464(sp)
    80004262:	6cbe                	ld	s9,456(sp)
    80004264:	6d1e                	ld	s10,448(sp)
    80004266:	7dfa                	ld	s11,440(sp)
    80004268:	22010113          	addi	sp,sp,544
    8000426c:	8082                	ret
    end_op();
    8000426e:	fffff097          	auipc	ra,0xfffff
    80004272:	49e080e7          	jalr	1182(ra) # 8000370c <end_op>
    return -1;
    80004276:	557d                	li	a0,-1
    80004278:	b7f9                	j	80004246 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000427a:	8526                	mv	a0,s1
    8000427c:	ffffd097          	auipc	ra,0xffffd
    80004280:	dbe080e7          	jalr	-578(ra) # 8000103a <proc_pagetable>
    80004284:	8b2a                	mv	s6,a0
    80004286:	d555                	beqz	a0,80004232 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004288:	e7042783          	lw	a5,-400(s0)
    8000428c:	e8845703          	lhu	a4,-376(s0)
    80004290:	c735                	beqz	a4,800042fc <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004292:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004294:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    80004298:	6a05                	lui	s4,0x1
    8000429a:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000429e:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800042a2:	6d85                	lui	s11,0x1
    800042a4:	7d7d                	lui	s10,0xfffff
    800042a6:	a495                	j	8000450a <exec+0x360>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042a8:	00004517          	auipc	a0,0x4
    800042ac:	42050513          	addi	a0,a0,1056 # 800086c8 <syscalls+0x2c8>
    800042b0:	00002097          	auipc	ra,0x2
    800042b4:	aa0080e7          	jalr	-1376(ra) # 80005d50 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042b8:	874a                	mv	a4,s2
    800042ba:	009c86bb          	addw	a3,s9,s1
    800042be:	4581                	li	a1,0
    800042c0:	8556                	mv	a0,s5
    800042c2:	fffff097          	auipc	ra,0xfffff
    800042c6:	ca4080e7          	jalr	-860(ra) # 80002f66 <readi>
    800042ca:	2501                	sext.w	a0,a0
    800042cc:	1ca91f63          	bne	s2,a0,800044aa <exec+0x300>
  for(i = 0; i < sz; i += PGSIZE){
    800042d0:	009d84bb          	addw	s1,s11,s1
    800042d4:	013d09bb          	addw	s3,s10,s3
    800042d8:	2174f963          	bgeu	s1,s7,800044ea <exec+0x340>
    pa = walkaddr(pagetable, va + i);
    800042dc:	02049593          	slli	a1,s1,0x20
    800042e0:	9181                	srli	a1,a1,0x20
    800042e2:	95e2                	add	a1,a1,s8
    800042e4:	855a                	mv	a0,s6
    800042e6:	ffffc097          	auipc	ra,0xffffc
    800042ea:	21a080e7          	jalr	538(ra) # 80000500 <walkaddr>
    800042ee:	862a                	mv	a2,a0
    if(pa == 0)
    800042f0:	dd45                	beqz	a0,800042a8 <exec+0xfe>
      n = PGSIZE;
    800042f2:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800042f4:	fd49f2e3          	bgeu	s3,s4,800042b8 <exec+0x10e>
      n = sz - i;
    800042f8:	894e                	mv	s2,s3
    800042fa:	bf7d                	j	800042b8 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042fc:	4481                	li	s1,0
  iunlockput(ip);
    800042fe:	8556                	mv	a0,s5
    80004300:	fffff097          	auipc	ra,0xfffff
    80004304:	c14080e7          	jalr	-1004(ra) # 80002f14 <iunlockput>
  end_op();
    80004308:	fffff097          	auipc	ra,0xfffff
    8000430c:	404080e7          	jalr	1028(ra) # 8000370c <end_op>
  p = myproc();
    80004310:	ffffd097          	auipc	ra,0xffffd
    80004314:	c66080e7          	jalr	-922(ra) # 80000f76 <myproc>
    80004318:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000431a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000431e:	6785                	lui	a5,0x1
    80004320:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004322:	97a6                	add	a5,a5,s1
    80004324:	777d                	lui	a4,0xfffff
    80004326:	8ff9                	and	a5,a5,a4
    80004328:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000432c:	6609                	lui	a2,0x2
    8000432e:	963e                	add	a2,a2,a5
    80004330:	85be                	mv	a1,a5
    80004332:	855a                	mv	a0,s6
    80004334:	ffffc097          	auipc	ra,0xffffc
    80004338:	580080e7          	jalr	1408(ra) # 800008b4 <uvmalloc>
    8000433c:	8c2a                	mv	s8,a0
  ip = 0;
    8000433e:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004340:	16050563          	beqz	a0,800044aa <exec+0x300>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004344:	75f9                	lui	a1,0xffffe
    80004346:	95aa                	add	a1,a1,a0
    80004348:	855a                	mv	a0,s6
    8000434a:	ffffc097          	auipc	ra,0xffffc
    8000434e:	78c080e7          	jalr	1932(ra) # 80000ad6 <uvmclear>
  stackbase = sp - PGSIZE;
    80004352:	7afd                	lui	s5,0xfffff
    80004354:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004356:	df043783          	ld	a5,-528(s0)
    8000435a:	6388                	ld	a0,0(a5)
    8000435c:	c925                	beqz	a0,800043cc <exec+0x222>
    8000435e:	e9040993          	addi	s3,s0,-368
    80004362:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004366:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004368:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000436a:	ffffc097          	auipc	ra,0xffffc
    8000436e:	f8c080e7          	jalr	-116(ra) # 800002f6 <strlen>
    80004372:	0015079b          	addiw	a5,a0,1
    80004376:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000437a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000437e:	15596a63          	bltu	s2,s5,800044d2 <exec+0x328>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004382:	df043d83          	ld	s11,-528(s0)
    80004386:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000438a:	8552                	mv	a0,s4
    8000438c:	ffffc097          	auipc	ra,0xffffc
    80004390:	f6a080e7          	jalr	-150(ra) # 800002f6 <strlen>
    80004394:	0015069b          	addiw	a3,a0,1
    80004398:	8652                	mv	a2,s4
    8000439a:	85ca                	mv	a1,s2
    8000439c:	855a                	mv	a0,s6
    8000439e:	ffffc097          	auipc	ra,0xffffc
    800043a2:	76a080e7          	jalr	1898(ra) # 80000b08 <copyout>
    800043a6:	12054a63          	bltz	a0,800044da <exec+0x330>
    ustack[argc] = sp;
    800043aa:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043ae:	0485                	addi	s1,s1,1
    800043b0:	008d8793          	addi	a5,s11,8
    800043b4:	def43823          	sd	a5,-528(s0)
    800043b8:	008db503          	ld	a0,8(s11)
    800043bc:	c911                	beqz	a0,800043d0 <exec+0x226>
    if(argc >= MAXARG)
    800043be:	09a1                	addi	s3,s3,8
    800043c0:	fb3c95e3          	bne	s9,s3,8000436a <exec+0x1c0>
  sz = sz1;
    800043c4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043c8:	4a81                	li	s5,0
    800043ca:	a0c5                	j	800044aa <exec+0x300>
  sp = sz;
    800043cc:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043ce:	4481                	li	s1,0
  ustack[argc] = 0;
    800043d0:	00349793          	slli	a5,s1,0x3
    800043d4:	f9078793          	addi	a5,a5,-112
    800043d8:	97a2                	add	a5,a5,s0
    800043da:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043de:	00148693          	addi	a3,s1,1
    800043e2:	068e                	slli	a3,a3,0x3
    800043e4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043e8:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043ec:	01597663          	bgeu	s2,s5,800043f8 <exec+0x24e>
  sz = sz1;
    800043f0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043f4:	4a81                	li	s5,0
    800043f6:	a855                	j	800044aa <exec+0x300>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043f8:	e9040613          	addi	a2,s0,-368
    800043fc:	85ca                	mv	a1,s2
    800043fe:	855a                	mv	a0,s6
    80004400:	ffffc097          	auipc	ra,0xffffc
    80004404:	708080e7          	jalr	1800(ra) # 80000b08 <copyout>
    80004408:	0c054d63          	bltz	a0,800044e2 <exec+0x338>
  p->trapframe->a1 = sp;
    8000440c:	058bb783          	ld	a5,88(s7)
    80004410:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004414:	de843783          	ld	a5,-536(s0)
    80004418:	0007c703          	lbu	a4,0(a5)
    8000441c:	cf11                	beqz	a4,80004438 <exec+0x28e>
    8000441e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004420:	02f00693          	li	a3,47
    80004424:	a039                	j	80004432 <exec+0x288>
      last = s+1;
    80004426:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000442a:	0785                	addi	a5,a5,1
    8000442c:	fff7c703          	lbu	a4,-1(a5)
    80004430:	c701                	beqz	a4,80004438 <exec+0x28e>
    if(*s == '/')
    80004432:	fed71ce3          	bne	a4,a3,8000442a <exec+0x280>
    80004436:	bfc5                	j	80004426 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004438:	4641                	li	a2,16
    8000443a:	de843583          	ld	a1,-536(s0)
    8000443e:	158b8513          	addi	a0,s7,344
    80004442:	ffffc097          	auipc	ra,0xffffc
    80004446:	e82080e7          	jalr	-382(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    8000444a:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000444e:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004452:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004456:	058bb783          	ld	a5,88(s7)
    8000445a:	e6843703          	ld	a4,-408(s0)
    8000445e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004460:	058bb783          	ld	a5,88(s7)
    80004464:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004468:	85ea                	mv	a1,s10
    8000446a:	ffffd097          	auipc	ra,0xffffd
    8000446e:	c9a080e7          	jalr	-870(ra) # 80001104 <proc_freepagetable>
  if(p->pid==1) 
    80004472:	030ba703          	lw	a4,48(s7)
    80004476:	4785                	li	a5,1
    80004478:	00f70563          	beq	a4,a5,80004482 <exec+0x2d8>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000447c:	0004851b          	sext.w	a0,s1
    80004480:	b3d9                	j	80004246 <exec+0x9c>
  	printf("page table %p\n",p->pagetable);
    80004482:	050bb583          	ld	a1,80(s7)
    80004486:	00004517          	auipc	a0,0x4
    8000448a:	26250513          	addi	a0,a0,610 # 800086e8 <syscalls+0x2e8>
    8000448e:	00002097          	auipc	ra,0x2
    80004492:	90c080e7          	jalr	-1780(ra) # 80005d9a <printf>
  	vmprint(p->pagetable,1);
    80004496:	4585                	li	a1,1
    80004498:	050bb503          	ld	a0,80(s7)
    8000449c:	ffffd097          	auipc	ra,0xffffd
    800044a0:	836080e7          	jalr	-1994(ra) # 80000cd2 <vmprint>
    800044a4:	bfe1                	j	8000447c <exec+0x2d2>
    800044a6:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800044aa:	df843583          	ld	a1,-520(s0)
    800044ae:	855a                	mv	a0,s6
    800044b0:	ffffd097          	auipc	ra,0xffffd
    800044b4:	c54080e7          	jalr	-940(ra) # 80001104 <proc_freepagetable>
  if(ip){
    800044b8:	d60a9de3          	bnez	s5,80004232 <exec+0x88>
  return -1;
    800044bc:	557d                	li	a0,-1
    800044be:	b361                	j	80004246 <exec+0x9c>
    800044c0:	de943c23          	sd	s1,-520(s0)
    800044c4:	b7dd                	j	800044aa <exec+0x300>
    800044c6:	de943c23          	sd	s1,-520(s0)
    800044ca:	b7c5                	j	800044aa <exec+0x300>
    800044cc:	de943c23          	sd	s1,-520(s0)
    800044d0:	bfe9                	j	800044aa <exec+0x300>
  sz = sz1;
    800044d2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044d6:	4a81                	li	s5,0
    800044d8:	bfc9                	j	800044aa <exec+0x300>
  sz = sz1;
    800044da:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044de:	4a81                	li	s5,0
    800044e0:	b7e9                	j	800044aa <exec+0x300>
  sz = sz1;
    800044e2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044e6:	4a81                	li	s5,0
    800044e8:	b7c9                	j	800044aa <exec+0x300>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044ea:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044ee:	e0843783          	ld	a5,-504(s0)
    800044f2:	0017869b          	addiw	a3,a5,1
    800044f6:	e0d43423          	sd	a3,-504(s0)
    800044fa:	e0043783          	ld	a5,-512(s0)
    800044fe:	0387879b          	addiw	a5,a5,56
    80004502:	e8845703          	lhu	a4,-376(s0)
    80004506:	dee6dce3          	bge	a3,a4,800042fe <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000450a:	2781                	sext.w	a5,a5
    8000450c:	e0f43023          	sd	a5,-512(s0)
    80004510:	03800713          	li	a4,56
    80004514:	86be                	mv	a3,a5
    80004516:	e1840613          	addi	a2,s0,-488
    8000451a:	4581                	li	a1,0
    8000451c:	8556                	mv	a0,s5
    8000451e:	fffff097          	auipc	ra,0xfffff
    80004522:	a48080e7          	jalr	-1464(ra) # 80002f66 <readi>
    80004526:	03800793          	li	a5,56
    8000452a:	f6f51ee3          	bne	a0,a5,800044a6 <exec+0x2fc>
    if(ph.type != ELF_PROG_LOAD)
    8000452e:	e1842783          	lw	a5,-488(s0)
    80004532:	4705                	li	a4,1
    80004534:	fae79de3          	bne	a5,a4,800044ee <exec+0x344>
    if(ph.memsz < ph.filesz)
    80004538:	e4043603          	ld	a2,-448(s0)
    8000453c:	e3843783          	ld	a5,-456(s0)
    80004540:	f8f660e3          	bltu	a2,a5,800044c0 <exec+0x316>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004544:	e2843783          	ld	a5,-472(s0)
    80004548:	963e                	add	a2,a2,a5
    8000454a:	f6f66ee3          	bltu	a2,a5,800044c6 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000454e:	85a6                	mv	a1,s1
    80004550:	855a                	mv	a0,s6
    80004552:	ffffc097          	auipc	ra,0xffffc
    80004556:	362080e7          	jalr	866(ra) # 800008b4 <uvmalloc>
    8000455a:	dea43c23          	sd	a0,-520(s0)
    8000455e:	d53d                	beqz	a0,800044cc <exec+0x322>
    if((ph.vaddr % PGSIZE) != 0)
    80004560:	e2843c03          	ld	s8,-472(s0)
    80004564:	de043783          	ld	a5,-544(s0)
    80004568:	00fc77b3          	and	a5,s8,a5
    8000456c:	ff9d                	bnez	a5,800044aa <exec+0x300>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000456e:	e2042c83          	lw	s9,-480(s0)
    80004572:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004576:	f60b8ae3          	beqz	s7,800044ea <exec+0x340>
    8000457a:	89de                	mv	s3,s7
    8000457c:	4481                	li	s1,0
    8000457e:	bbb9                	j	800042dc <exec+0x132>

0000000080004580 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004580:	7179                	addi	sp,sp,-48
    80004582:	f406                	sd	ra,40(sp)
    80004584:	f022                	sd	s0,32(sp)
    80004586:	ec26                	sd	s1,24(sp)
    80004588:	e84a                	sd	s2,16(sp)
    8000458a:	1800                	addi	s0,sp,48
    8000458c:	892e                	mv	s2,a1
    8000458e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004590:	fdc40593          	addi	a1,s0,-36
    80004594:	ffffe097          	auipc	ra,0xffffe
    80004598:	b22080e7          	jalr	-1246(ra) # 800020b6 <argint>
    8000459c:	04054063          	bltz	a0,800045dc <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045a0:	fdc42703          	lw	a4,-36(s0)
    800045a4:	47bd                	li	a5,15
    800045a6:	02e7ed63          	bltu	a5,a4,800045e0 <argfd+0x60>
    800045aa:	ffffd097          	auipc	ra,0xffffd
    800045ae:	9cc080e7          	jalr	-1588(ra) # 80000f76 <myproc>
    800045b2:	fdc42703          	lw	a4,-36(s0)
    800045b6:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    800045ba:	078e                	slli	a5,a5,0x3
    800045bc:	953e                	add	a0,a0,a5
    800045be:	611c                	ld	a5,0(a0)
    800045c0:	c395                	beqz	a5,800045e4 <argfd+0x64>
    return -1;
  if(pfd)
    800045c2:	00090463          	beqz	s2,800045ca <argfd+0x4a>
    *pfd = fd;
    800045c6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045ca:	4501                	li	a0,0
  if(pf)
    800045cc:	c091                	beqz	s1,800045d0 <argfd+0x50>
    *pf = f;
    800045ce:	e09c                	sd	a5,0(s1)
}
    800045d0:	70a2                	ld	ra,40(sp)
    800045d2:	7402                	ld	s0,32(sp)
    800045d4:	64e2                	ld	s1,24(sp)
    800045d6:	6942                	ld	s2,16(sp)
    800045d8:	6145                	addi	sp,sp,48
    800045da:	8082                	ret
    return -1;
    800045dc:	557d                	li	a0,-1
    800045de:	bfcd                	j	800045d0 <argfd+0x50>
    return -1;
    800045e0:	557d                	li	a0,-1
    800045e2:	b7fd                	j	800045d0 <argfd+0x50>
    800045e4:	557d                	li	a0,-1
    800045e6:	b7ed                	j	800045d0 <argfd+0x50>

00000000800045e8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045e8:	1101                	addi	sp,sp,-32
    800045ea:	ec06                	sd	ra,24(sp)
    800045ec:	e822                	sd	s0,16(sp)
    800045ee:	e426                	sd	s1,8(sp)
    800045f0:	1000                	addi	s0,sp,32
    800045f2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045f4:	ffffd097          	auipc	ra,0xffffd
    800045f8:	982080e7          	jalr	-1662(ra) # 80000f76 <myproc>
    800045fc:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045fe:	0d050793          	addi	a5,a0,208
    80004602:	4501                	li	a0,0
    80004604:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004606:	6398                	ld	a4,0(a5)
    80004608:	cb19                	beqz	a4,8000461e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000460a:	2505                	addiw	a0,a0,1
    8000460c:	07a1                	addi	a5,a5,8
    8000460e:	fed51ce3          	bne	a0,a3,80004606 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004612:	557d                	li	a0,-1
}
    80004614:	60e2                	ld	ra,24(sp)
    80004616:	6442                	ld	s0,16(sp)
    80004618:	64a2                	ld	s1,8(sp)
    8000461a:	6105                	addi	sp,sp,32
    8000461c:	8082                	ret
      p->ofile[fd] = f;
    8000461e:	01a50793          	addi	a5,a0,26
    80004622:	078e                	slli	a5,a5,0x3
    80004624:	963e                	add	a2,a2,a5
    80004626:	e204                	sd	s1,0(a2)
      return fd;
    80004628:	b7f5                	j	80004614 <fdalloc+0x2c>

000000008000462a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000462a:	715d                	addi	sp,sp,-80
    8000462c:	e486                	sd	ra,72(sp)
    8000462e:	e0a2                	sd	s0,64(sp)
    80004630:	fc26                	sd	s1,56(sp)
    80004632:	f84a                	sd	s2,48(sp)
    80004634:	f44e                	sd	s3,40(sp)
    80004636:	f052                	sd	s4,32(sp)
    80004638:	ec56                	sd	s5,24(sp)
    8000463a:	0880                	addi	s0,sp,80
    8000463c:	89ae                	mv	s3,a1
    8000463e:	8ab2                	mv	s5,a2
    80004640:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004642:	fb040593          	addi	a1,s0,-80
    80004646:	fffff097          	auipc	ra,0xfffff
    8000464a:	e46080e7          	jalr	-442(ra) # 8000348c <nameiparent>
    8000464e:	892a                	mv	s2,a0
    80004650:	12050e63          	beqz	a0,8000478c <create+0x162>
    return 0;

  ilock(dp);
    80004654:	ffffe097          	auipc	ra,0xffffe
    80004658:	65e080e7          	jalr	1630(ra) # 80002cb2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000465c:	4601                	li	a2,0
    8000465e:	fb040593          	addi	a1,s0,-80
    80004662:	854a                	mv	a0,s2
    80004664:	fffff097          	auipc	ra,0xfffff
    80004668:	b32080e7          	jalr	-1230(ra) # 80003196 <dirlookup>
    8000466c:	84aa                	mv	s1,a0
    8000466e:	c921                	beqz	a0,800046be <create+0x94>
    iunlockput(dp);
    80004670:	854a                	mv	a0,s2
    80004672:	fffff097          	auipc	ra,0xfffff
    80004676:	8a2080e7          	jalr	-1886(ra) # 80002f14 <iunlockput>
    ilock(ip);
    8000467a:	8526                	mv	a0,s1
    8000467c:	ffffe097          	auipc	ra,0xffffe
    80004680:	636080e7          	jalr	1590(ra) # 80002cb2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004684:	2981                	sext.w	s3,s3
    80004686:	4789                	li	a5,2
    80004688:	02f99463          	bne	s3,a5,800046b0 <create+0x86>
    8000468c:	0444d783          	lhu	a5,68(s1)
    80004690:	37f9                	addiw	a5,a5,-2
    80004692:	17c2                	slli	a5,a5,0x30
    80004694:	93c1                	srli	a5,a5,0x30
    80004696:	4705                	li	a4,1
    80004698:	00f76c63          	bltu	a4,a5,800046b0 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000469c:	8526                	mv	a0,s1
    8000469e:	60a6                	ld	ra,72(sp)
    800046a0:	6406                	ld	s0,64(sp)
    800046a2:	74e2                	ld	s1,56(sp)
    800046a4:	7942                	ld	s2,48(sp)
    800046a6:	79a2                	ld	s3,40(sp)
    800046a8:	7a02                	ld	s4,32(sp)
    800046aa:	6ae2                	ld	s5,24(sp)
    800046ac:	6161                	addi	sp,sp,80
    800046ae:	8082                	ret
    iunlockput(ip);
    800046b0:	8526                	mv	a0,s1
    800046b2:	fffff097          	auipc	ra,0xfffff
    800046b6:	862080e7          	jalr	-1950(ra) # 80002f14 <iunlockput>
    return 0;
    800046ba:	4481                	li	s1,0
    800046bc:	b7c5                	j	8000469c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046be:	85ce                	mv	a1,s3
    800046c0:	00092503          	lw	a0,0(s2)
    800046c4:	ffffe097          	auipc	ra,0xffffe
    800046c8:	454080e7          	jalr	1108(ra) # 80002b18 <ialloc>
    800046cc:	84aa                	mv	s1,a0
    800046ce:	c521                	beqz	a0,80004716 <create+0xec>
  ilock(ip);
    800046d0:	ffffe097          	auipc	ra,0xffffe
    800046d4:	5e2080e7          	jalr	1506(ra) # 80002cb2 <ilock>
  ip->major = major;
    800046d8:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800046dc:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800046e0:	4a05                	li	s4,1
    800046e2:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800046e6:	8526                	mv	a0,s1
    800046e8:	ffffe097          	auipc	ra,0xffffe
    800046ec:	4fe080e7          	jalr	1278(ra) # 80002be6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046f0:	2981                	sext.w	s3,s3
    800046f2:	03498a63          	beq	s3,s4,80004726 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800046f6:	40d0                	lw	a2,4(s1)
    800046f8:	fb040593          	addi	a1,s0,-80
    800046fc:	854a                	mv	a0,s2
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	cae080e7          	jalr	-850(ra) # 800033ac <dirlink>
    80004706:	06054b63          	bltz	a0,8000477c <create+0x152>
  iunlockput(dp);
    8000470a:	854a                	mv	a0,s2
    8000470c:	fffff097          	auipc	ra,0xfffff
    80004710:	808080e7          	jalr	-2040(ra) # 80002f14 <iunlockput>
  return ip;
    80004714:	b761                	j	8000469c <create+0x72>
    panic("create: ialloc");
    80004716:	00004517          	auipc	a0,0x4
    8000471a:	fe250513          	addi	a0,a0,-30 # 800086f8 <syscalls+0x2f8>
    8000471e:	00001097          	auipc	ra,0x1
    80004722:	632080e7          	jalr	1586(ra) # 80005d50 <panic>
    dp->nlink++;  // for ".."
    80004726:	04a95783          	lhu	a5,74(s2)
    8000472a:	2785                	addiw	a5,a5,1
    8000472c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004730:	854a                	mv	a0,s2
    80004732:	ffffe097          	auipc	ra,0xffffe
    80004736:	4b4080e7          	jalr	1204(ra) # 80002be6 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000473a:	40d0                	lw	a2,4(s1)
    8000473c:	00004597          	auipc	a1,0x4
    80004740:	fcc58593          	addi	a1,a1,-52 # 80008708 <syscalls+0x308>
    80004744:	8526                	mv	a0,s1
    80004746:	fffff097          	auipc	ra,0xfffff
    8000474a:	c66080e7          	jalr	-922(ra) # 800033ac <dirlink>
    8000474e:	00054f63          	bltz	a0,8000476c <create+0x142>
    80004752:	00492603          	lw	a2,4(s2)
    80004756:	00004597          	auipc	a1,0x4
    8000475a:	a0258593          	addi	a1,a1,-1534 # 80008158 <etext+0x158>
    8000475e:	8526                	mv	a0,s1
    80004760:	fffff097          	auipc	ra,0xfffff
    80004764:	c4c080e7          	jalr	-948(ra) # 800033ac <dirlink>
    80004768:	f80557e3          	bgez	a0,800046f6 <create+0xcc>
      panic("create dots");
    8000476c:	00004517          	auipc	a0,0x4
    80004770:	fa450513          	addi	a0,a0,-92 # 80008710 <syscalls+0x310>
    80004774:	00001097          	auipc	ra,0x1
    80004778:	5dc080e7          	jalr	1500(ra) # 80005d50 <panic>
    panic("create: dirlink");
    8000477c:	00004517          	auipc	a0,0x4
    80004780:	fa450513          	addi	a0,a0,-92 # 80008720 <syscalls+0x320>
    80004784:	00001097          	auipc	ra,0x1
    80004788:	5cc080e7          	jalr	1484(ra) # 80005d50 <panic>
    return 0;
    8000478c:	84aa                	mv	s1,a0
    8000478e:	b739                	j	8000469c <create+0x72>

0000000080004790 <sys_dup>:
{
    80004790:	7179                	addi	sp,sp,-48
    80004792:	f406                	sd	ra,40(sp)
    80004794:	f022                	sd	s0,32(sp)
    80004796:	ec26                	sd	s1,24(sp)
    80004798:	e84a                	sd	s2,16(sp)
    8000479a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000479c:	fd840613          	addi	a2,s0,-40
    800047a0:	4581                	li	a1,0
    800047a2:	4501                	li	a0,0
    800047a4:	00000097          	auipc	ra,0x0
    800047a8:	ddc080e7          	jalr	-548(ra) # 80004580 <argfd>
    return -1;
    800047ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047ae:	02054363          	bltz	a0,800047d4 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800047b2:	fd843903          	ld	s2,-40(s0)
    800047b6:	854a                	mv	a0,s2
    800047b8:	00000097          	auipc	ra,0x0
    800047bc:	e30080e7          	jalr	-464(ra) # 800045e8 <fdalloc>
    800047c0:	84aa                	mv	s1,a0
    return -1;
    800047c2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047c4:	00054863          	bltz	a0,800047d4 <sys_dup+0x44>
  filedup(f);
    800047c8:	854a                	mv	a0,s2
    800047ca:	fffff097          	auipc	ra,0xfffff
    800047ce:	33a080e7          	jalr	826(ra) # 80003b04 <filedup>
  return fd;
    800047d2:	87a6                	mv	a5,s1
}
    800047d4:	853e                	mv	a0,a5
    800047d6:	70a2                	ld	ra,40(sp)
    800047d8:	7402                	ld	s0,32(sp)
    800047da:	64e2                	ld	s1,24(sp)
    800047dc:	6942                	ld	s2,16(sp)
    800047de:	6145                	addi	sp,sp,48
    800047e0:	8082                	ret

00000000800047e2 <sys_read>:
{
    800047e2:	7179                	addi	sp,sp,-48
    800047e4:	f406                	sd	ra,40(sp)
    800047e6:	f022                	sd	s0,32(sp)
    800047e8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ea:	fe840613          	addi	a2,s0,-24
    800047ee:	4581                	li	a1,0
    800047f0:	4501                	li	a0,0
    800047f2:	00000097          	auipc	ra,0x0
    800047f6:	d8e080e7          	jalr	-626(ra) # 80004580 <argfd>
    return -1;
    800047fa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047fc:	04054163          	bltz	a0,8000483e <sys_read+0x5c>
    80004800:	fe440593          	addi	a1,s0,-28
    80004804:	4509                	li	a0,2
    80004806:	ffffe097          	auipc	ra,0xffffe
    8000480a:	8b0080e7          	jalr	-1872(ra) # 800020b6 <argint>
    return -1;
    8000480e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004810:	02054763          	bltz	a0,8000483e <sys_read+0x5c>
    80004814:	fd840593          	addi	a1,s0,-40
    80004818:	4505                	li	a0,1
    8000481a:	ffffe097          	auipc	ra,0xffffe
    8000481e:	8be080e7          	jalr	-1858(ra) # 800020d8 <argaddr>
    return -1;
    80004822:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004824:	00054d63          	bltz	a0,8000483e <sys_read+0x5c>
  return fileread(f, p, n);
    80004828:	fe442603          	lw	a2,-28(s0)
    8000482c:	fd843583          	ld	a1,-40(s0)
    80004830:	fe843503          	ld	a0,-24(s0)
    80004834:	fffff097          	auipc	ra,0xfffff
    80004838:	45c080e7          	jalr	1116(ra) # 80003c90 <fileread>
    8000483c:	87aa                	mv	a5,a0
}
    8000483e:	853e                	mv	a0,a5
    80004840:	70a2                	ld	ra,40(sp)
    80004842:	7402                	ld	s0,32(sp)
    80004844:	6145                	addi	sp,sp,48
    80004846:	8082                	ret

0000000080004848 <sys_write>:
{
    80004848:	7179                	addi	sp,sp,-48
    8000484a:	f406                	sd	ra,40(sp)
    8000484c:	f022                	sd	s0,32(sp)
    8000484e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004850:	fe840613          	addi	a2,s0,-24
    80004854:	4581                	li	a1,0
    80004856:	4501                	li	a0,0
    80004858:	00000097          	auipc	ra,0x0
    8000485c:	d28080e7          	jalr	-728(ra) # 80004580 <argfd>
    return -1;
    80004860:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004862:	04054163          	bltz	a0,800048a4 <sys_write+0x5c>
    80004866:	fe440593          	addi	a1,s0,-28
    8000486a:	4509                	li	a0,2
    8000486c:	ffffe097          	auipc	ra,0xffffe
    80004870:	84a080e7          	jalr	-1974(ra) # 800020b6 <argint>
    return -1;
    80004874:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004876:	02054763          	bltz	a0,800048a4 <sys_write+0x5c>
    8000487a:	fd840593          	addi	a1,s0,-40
    8000487e:	4505                	li	a0,1
    80004880:	ffffe097          	auipc	ra,0xffffe
    80004884:	858080e7          	jalr	-1960(ra) # 800020d8 <argaddr>
    return -1;
    80004888:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000488a:	00054d63          	bltz	a0,800048a4 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000488e:	fe442603          	lw	a2,-28(s0)
    80004892:	fd843583          	ld	a1,-40(s0)
    80004896:	fe843503          	ld	a0,-24(s0)
    8000489a:	fffff097          	auipc	ra,0xfffff
    8000489e:	4b8080e7          	jalr	1208(ra) # 80003d52 <filewrite>
    800048a2:	87aa                	mv	a5,a0
}
    800048a4:	853e                	mv	a0,a5
    800048a6:	70a2                	ld	ra,40(sp)
    800048a8:	7402                	ld	s0,32(sp)
    800048aa:	6145                	addi	sp,sp,48
    800048ac:	8082                	ret

00000000800048ae <sys_close>:
{
    800048ae:	1101                	addi	sp,sp,-32
    800048b0:	ec06                	sd	ra,24(sp)
    800048b2:	e822                	sd	s0,16(sp)
    800048b4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048b6:	fe040613          	addi	a2,s0,-32
    800048ba:	fec40593          	addi	a1,s0,-20
    800048be:	4501                	li	a0,0
    800048c0:	00000097          	auipc	ra,0x0
    800048c4:	cc0080e7          	jalr	-832(ra) # 80004580 <argfd>
    return -1;
    800048c8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048ca:	02054463          	bltz	a0,800048f2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048ce:	ffffc097          	auipc	ra,0xffffc
    800048d2:	6a8080e7          	jalr	1704(ra) # 80000f76 <myproc>
    800048d6:	fec42783          	lw	a5,-20(s0)
    800048da:	07e9                	addi	a5,a5,26
    800048dc:	078e                	slli	a5,a5,0x3
    800048de:	953e                	add	a0,a0,a5
    800048e0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800048e4:	fe043503          	ld	a0,-32(s0)
    800048e8:	fffff097          	auipc	ra,0xfffff
    800048ec:	26e080e7          	jalr	622(ra) # 80003b56 <fileclose>
  return 0;
    800048f0:	4781                	li	a5,0
}
    800048f2:	853e                	mv	a0,a5
    800048f4:	60e2                	ld	ra,24(sp)
    800048f6:	6442                	ld	s0,16(sp)
    800048f8:	6105                	addi	sp,sp,32
    800048fa:	8082                	ret

00000000800048fc <sys_fstat>:
{
    800048fc:	1101                	addi	sp,sp,-32
    800048fe:	ec06                	sd	ra,24(sp)
    80004900:	e822                	sd	s0,16(sp)
    80004902:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004904:	fe840613          	addi	a2,s0,-24
    80004908:	4581                	li	a1,0
    8000490a:	4501                	li	a0,0
    8000490c:	00000097          	auipc	ra,0x0
    80004910:	c74080e7          	jalr	-908(ra) # 80004580 <argfd>
    return -1;
    80004914:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004916:	02054563          	bltz	a0,80004940 <sys_fstat+0x44>
    8000491a:	fe040593          	addi	a1,s0,-32
    8000491e:	4505                	li	a0,1
    80004920:	ffffd097          	auipc	ra,0xffffd
    80004924:	7b8080e7          	jalr	1976(ra) # 800020d8 <argaddr>
    return -1;
    80004928:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000492a:	00054b63          	bltz	a0,80004940 <sys_fstat+0x44>
  return filestat(f, st);
    8000492e:	fe043583          	ld	a1,-32(s0)
    80004932:	fe843503          	ld	a0,-24(s0)
    80004936:	fffff097          	auipc	ra,0xfffff
    8000493a:	2e8080e7          	jalr	744(ra) # 80003c1e <filestat>
    8000493e:	87aa                	mv	a5,a0
}
    80004940:	853e                	mv	a0,a5
    80004942:	60e2                	ld	ra,24(sp)
    80004944:	6442                	ld	s0,16(sp)
    80004946:	6105                	addi	sp,sp,32
    80004948:	8082                	ret

000000008000494a <sys_link>:
{
    8000494a:	7169                	addi	sp,sp,-304
    8000494c:	f606                	sd	ra,296(sp)
    8000494e:	f222                	sd	s0,288(sp)
    80004950:	ee26                	sd	s1,280(sp)
    80004952:	ea4a                	sd	s2,272(sp)
    80004954:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004956:	08000613          	li	a2,128
    8000495a:	ed040593          	addi	a1,s0,-304
    8000495e:	4501                	li	a0,0
    80004960:	ffffd097          	auipc	ra,0xffffd
    80004964:	79a080e7          	jalr	1946(ra) # 800020fa <argstr>
    return -1;
    80004968:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000496a:	10054e63          	bltz	a0,80004a86 <sys_link+0x13c>
    8000496e:	08000613          	li	a2,128
    80004972:	f5040593          	addi	a1,s0,-176
    80004976:	4505                	li	a0,1
    80004978:	ffffd097          	auipc	ra,0xffffd
    8000497c:	782080e7          	jalr	1922(ra) # 800020fa <argstr>
    return -1;
    80004980:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004982:	10054263          	bltz	a0,80004a86 <sys_link+0x13c>
  begin_op();
    80004986:	fffff097          	auipc	ra,0xfffff
    8000498a:	d08080e7          	jalr	-760(ra) # 8000368e <begin_op>
  if((ip = namei(old)) == 0){
    8000498e:	ed040513          	addi	a0,s0,-304
    80004992:	fffff097          	auipc	ra,0xfffff
    80004996:	adc080e7          	jalr	-1316(ra) # 8000346e <namei>
    8000499a:	84aa                	mv	s1,a0
    8000499c:	c551                	beqz	a0,80004a28 <sys_link+0xde>
  ilock(ip);
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	314080e7          	jalr	788(ra) # 80002cb2 <ilock>
  if(ip->type == T_DIR){
    800049a6:	04449703          	lh	a4,68(s1)
    800049aa:	4785                	li	a5,1
    800049ac:	08f70463          	beq	a4,a5,80004a34 <sys_link+0xea>
  ip->nlink++;
    800049b0:	04a4d783          	lhu	a5,74(s1)
    800049b4:	2785                	addiw	a5,a5,1
    800049b6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049ba:	8526                	mv	a0,s1
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	22a080e7          	jalr	554(ra) # 80002be6 <iupdate>
  iunlock(ip);
    800049c4:	8526                	mv	a0,s1
    800049c6:	ffffe097          	auipc	ra,0xffffe
    800049ca:	3ae080e7          	jalr	942(ra) # 80002d74 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049ce:	fd040593          	addi	a1,s0,-48
    800049d2:	f5040513          	addi	a0,s0,-176
    800049d6:	fffff097          	auipc	ra,0xfffff
    800049da:	ab6080e7          	jalr	-1354(ra) # 8000348c <nameiparent>
    800049de:	892a                	mv	s2,a0
    800049e0:	c935                	beqz	a0,80004a54 <sys_link+0x10a>
  ilock(dp);
    800049e2:	ffffe097          	auipc	ra,0xffffe
    800049e6:	2d0080e7          	jalr	720(ra) # 80002cb2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049ea:	00092703          	lw	a4,0(s2)
    800049ee:	409c                	lw	a5,0(s1)
    800049f0:	04f71d63          	bne	a4,a5,80004a4a <sys_link+0x100>
    800049f4:	40d0                	lw	a2,4(s1)
    800049f6:	fd040593          	addi	a1,s0,-48
    800049fa:	854a                	mv	a0,s2
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	9b0080e7          	jalr	-1616(ra) # 800033ac <dirlink>
    80004a04:	04054363          	bltz	a0,80004a4a <sys_link+0x100>
  iunlockput(dp);
    80004a08:	854a                	mv	a0,s2
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	50a080e7          	jalr	1290(ra) # 80002f14 <iunlockput>
  iput(ip);
    80004a12:	8526                	mv	a0,s1
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	458080e7          	jalr	1112(ra) # 80002e6c <iput>
  end_op();
    80004a1c:	fffff097          	auipc	ra,0xfffff
    80004a20:	cf0080e7          	jalr	-784(ra) # 8000370c <end_op>
  return 0;
    80004a24:	4781                	li	a5,0
    80004a26:	a085                	j	80004a86 <sys_link+0x13c>
    end_op();
    80004a28:	fffff097          	auipc	ra,0xfffff
    80004a2c:	ce4080e7          	jalr	-796(ra) # 8000370c <end_op>
    return -1;
    80004a30:	57fd                	li	a5,-1
    80004a32:	a891                	j	80004a86 <sys_link+0x13c>
    iunlockput(ip);
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	4de080e7          	jalr	1246(ra) # 80002f14 <iunlockput>
    end_op();
    80004a3e:	fffff097          	auipc	ra,0xfffff
    80004a42:	cce080e7          	jalr	-818(ra) # 8000370c <end_op>
    return -1;
    80004a46:	57fd                	li	a5,-1
    80004a48:	a83d                	j	80004a86 <sys_link+0x13c>
    iunlockput(dp);
    80004a4a:	854a                	mv	a0,s2
    80004a4c:	ffffe097          	auipc	ra,0xffffe
    80004a50:	4c8080e7          	jalr	1224(ra) # 80002f14 <iunlockput>
  ilock(ip);
    80004a54:	8526                	mv	a0,s1
    80004a56:	ffffe097          	auipc	ra,0xffffe
    80004a5a:	25c080e7          	jalr	604(ra) # 80002cb2 <ilock>
  ip->nlink--;
    80004a5e:	04a4d783          	lhu	a5,74(s1)
    80004a62:	37fd                	addiw	a5,a5,-1
    80004a64:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a68:	8526                	mv	a0,s1
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	17c080e7          	jalr	380(ra) # 80002be6 <iupdate>
  iunlockput(ip);
    80004a72:	8526                	mv	a0,s1
    80004a74:	ffffe097          	auipc	ra,0xffffe
    80004a78:	4a0080e7          	jalr	1184(ra) # 80002f14 <iunlockput>
  end_op();
    80004a7c:	fffff097          	auipc	ra,0xfffff
    80004a80:	c90080e7          	jalr	-880(ra) # 8000370c <end_op>
  return -1;
    80004a84:	57fd                	li	a5,-1
}
    80004a86:	853e                	mv	a0,a5
    80004a88:	70b2                	ld	ra,296(sp)
    80004a8a:	7412                	ld	s0,288(sp)
    80004a8c:	64f2                	ld	s1,280(sp)
    80004a8e:	6952                	ld	s2,272(sp)
    80004a90:	6155                	addi	sp,sp,304
    80004a92:	8082                	ret

0000000080004a94 <sys_unlink>:
{
    80004a94:	7151                	addi	sp,sp,-240
    80004a96:	f586                	sd	ra,232(sp)
    80004a98:	f1a2                	sd	s0,224(sp)
    80004a9a:	eda6                	sd	s1,216(sp)
    80004a9c:	e9ca                	sd	s2,208(sp)
    80004a9e:	e5ce                	sd	s3,200(sp)
    80004aa0:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004aa2:	08000613          	li	a2,128
    80004aa6:	f3040593          	addi	a1,s0,-208
    80004aaa:	4501                	li	a0,0
    80004aac:	ffffd097          	auipc	ra,0xffffd
    80004ab0:	64e080e7          	jalr	1614(ra) # 800020fa <argstr>
    80004ab4:	18054163          	bltz	a0,80004c36 <sys_unlink+0x1a2>
  begin_op();
    80004ab8:	fffff097          	auipc	ra,0xfffff
    80004abc:	bd6080e7          	jalr	-1066(ra) # 8000368e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ac0:	fb040593          	addi	a1,s0,-80
    80004ac4:	f3040513          	addi	a0,s0,-208
    80004ac8:	fffff097          	auipc	ra,0xfffff
    80004acc:	9c4080e7          	jalr	-1596(ra) # 8000348c <nameiparent>
    80004ad0:	84aa                	mv	s1,a0
    80004ad2:	c979                	beqz	a0,80004ba8 <sys_unlink+0x114>
  ilock(dp);
    80004ad4:	ffffe097          	auipc	ra,0xffffe
    80004ad8:	1de080e7          	jalr	478(ra) # 80002cb2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004adc:	00004597          	auipc	a1,0x4
    80004ae0:	c2c58593          	addi	a1,a1,-980 # 80008708 <syscalls+0x308>
    80004ae4:	fb040513          	addi	a0,s0,-80
    80004ae8:	ffffe097          	auipc	ra,0xffffe
    80004aec:	694080e7          	jalr	1684(ra) # 8000317c <namecmp>
    80004af0:	14050a63          	beqz	a0,80004c44 <sys_unlink+0x1b0>
    80004af4:	00003597          	auipc	a1,0x3
    80004af8:	66458593          	addi	a1,a1,1636 # 80008158 <etext+0x158>
    80004afc:	fb040513          	addi	a0,s0,-80
    80004b00:	ffffe097          	auipc	ra,0xffffe
    80004b04:	67c080e7          	jalr	1660(ra) # 8000317c <namecmp>
    80004b08:	12050e63          	beqz	a0,80004c44 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b0c:	f2c40613          	addi	a2,s0,-212
    80004b10:	fb040593          	addi	a1,s0,-80
    80004b14:	8526                	mv	a0,s1
    80004b16:	ffffe097          	auipc	ra,0xffffe
    80004b1a:	680080e7          	jalr	1664(ra) # 80003196 <dirlookup>
    80004b1e:	892a                	mv	s2,a0
    80004b20:	12050263          	beqz	a0,80004c44 <sys_unlink+0x1b0>
  ilock(ip);
    80004b24:	ffffe097          	auipc	ra,0xffffe
    80004b28:	18e080e7          	jalr	398(ra) # 80002cb2 <ilock>
  if(ip->nlink < 1)
    80004b2c:	04a91783          	lh	a5,74(s2)
    80004b30:	08f05263          	blez	a5,80004bb4 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b34:	04491703          	lh	a4,68(s2)
    80004b38:	4785                	li	a5,1
    80004b3a:	08f70563          	beq	a4,a5,80004bc4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b3e:	4641                	li	a2,16
    80004b40:	4581                	li	a1,0
    80004b42:	fc040513          	addi	a0,s0,-64
    80004b46:	ffffb097          	auipc	ra,0xffffb
    80004b4a:	634080e7          	jalr	1588(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b4e:	4741                	li	a4,16
    80004b50:	f2c42683          	lw	a3,-212(s0)
    80004b54:	fc040613          	addi	a2,s0,-64
    80004b58:	4581                	li	a1,0
    80004b5a:	8526                	mv	a0,s1
    80004b5c:	ffffe097          	auipc	ra,0xffffe
    80004b60:	502080e7          	jalr	1282(ra) # 8000305e <writei>
    80004b64:	47c1                	li	a5,16
    80004b66:	0af51563          	bne	a0,a5,80004c10 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b6a:	04491703          	lh	a4,68(s2)
    80004b6e:	4785                	li	a5,1
    80004b70:	0af70863          	beq	a4,a5,80004c20 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b74:	8526                	mv	a0,s1
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	39e080e7          	jalr	926(ra) # 80002f14 <iunlockput>
  ip->nlink--;
    80004b7e:	04a95783          	lhu	a5,74(s2)
    80004b82:	37fd                	addiw	a5,a5,-1
    80004b84:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b88:	854a                	mv	a0,s2
    80004b8a:	ffffe097          	auipc	ra,0xffffe
    80004b8e:	05c080e7          	jalr	92(ra) # 80002be6 <iupdate>
  iunlockput(ip);
    80004b92:	854a                	mv	a0,s2
    80004b94:	ffffe097          	auipc	ra,0xffffe
    80004b98:	380080e7          	jalr	896(ra) # 80002f14 <iunlockput>
  end_op();
    80004b9c:	fffff097          	auipc	ra,0xfffff
    80004ba0:	b70080e7          	jalr	-1168(ra) # 8000370c <end_op>
  return 0;
    80004ba4:	4501                	li	a0,0
    80004ba6:	a84d                	j	80004c58 <sys_unlink+0x1c4>
    end_op();
    80004ba8:	fffff097          	auipc	ra,0xfffff
    80004bac:	b64080e7          	jalr	-1180(ra) # 8000370c <end_op>
    return -1;
    80004bb0:	557d                	li	a0,-1
    80004bb2:	a05d                	j	80004c58 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004bb4:	00004517          	auipc	a0,0x4
    80004bb8:	b7c50513          	addi	a0,a0,-1156 # 80008730 <syscalls+0x330>
    80004bbc:	00001097          	auipc	ra,0x1
    80004bc0:	194080e7          	jalr	404(ra) # 80005d50 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bc4:	04c92703          	lw	a4,76(s2)
    80004bc8:	02000793          	li	a5,32
    80004bcc:	f6e7f9e3          	bgeu	a5,a4,80004b3e <sys_unlink+0xaa>
    80004bd0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bd4:	4741                	li	a4,16
    80004bd6:	86ce                	mv	a3,s3
    80004bd8:	f1840613          	addi	a2,s0,-232
    80004bdc:	4581                	li	a1,0
    80004bde:	854a                	mv	a0,s2
    80004be0:	ffffe097          	auipc	ra,0xffffe
    80004be4:	386080e7          	jalr	902(ra) # 80002f66 <readi>
    80004be8:	47c1                	li	a5,16
    80004bea:	00f51b63          	bne	a0,a5,80004c00 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004bee:	f1845783          	lhu	a5,-232(s0)
    80004bf2:	e7a1                	bnez	a5,80004c3a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bf4:	29c1                	addiw	s3,s3,16
    80004bf6:	04c92783          	lw	a5,76(s2)
    80004bfa:	fcf9ede3          	bltu	s3,a5,80004bd4 <sys_unlink+0x140>
    80004bfe:	b781                	j	80004b3e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c00:	00004517          	auipc	a0,0x4
    80004c04:	b4850513          	addi	a0,a0,-1208 # 80008748 <syscalls+0x348>
    80004c08:	00001097          	auipc	ra,0x1
    80004c0c:	148080e7          	jalr	328(ra) # 80005d50 <panic>
    panic("unlink: writei");
    80004c10:	00004517          	auipc	a0,0x4
    80004c14:	b5050513          	addi	a0,a0,-1200 # 80008760 <syscalls+0x360>
    80004c18:	00001097          	auipc	ra,0x1
    80004c1c:	138080e7          	jalr	312(ra) # 80005d50 <panic>
    dp->nlink--;
    80004c20:	04a4d783          	lhu	a5,74(s1)
    80004c24:	37fd                	addiw	a5,a5,-1
    80004c26:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c2a:	8526                	mv	a0,s1
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	fba080e7          	jalr	-70(ra) # 80002be6 <iupdate>
    80004c34:	b781                	j	80004b74 <sys_unlink+0xe0>
    return -1;
    80004c36:	557d                	li	a0,-1
    80004c38:	a005                	j	80004c58 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c3a:	854a                	mv	a0,s2
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	2d8080e7          	jalr	728(ra) # 80002f14 <iunlockput>
  iunlockput(dp);
    80004c44:	8526                	mv	a0,s1
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	2ce080e7          	jalr	718(ra) # 80002f14 <iunlockput>
  end_op();
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	abe080e7          	jalr	-1346(ra) # 8000370c <end_op>
  return -1;
    80004c56:	557d                	li	a0,-1
}
    80004c58:	70ae                	ld	ra,232(sp)
    80004c5a:	740e                	ld	s0,224(sp)
    80004c5c:	64ee                	ld	s1,216(sp)
    80004c5e:	694e                	ld	s2,208(sp)
    80004c60:	69ae                	ld	s3,200(sp)
    80004c62:	616d                	addi	sp,sp,240
    80004c64:	8082                	ret

0000000080004c66 <sys_open>:

uint64
sys_open(void)
{
    80004c66:	7131                	addi	sp,sp,-192
    80004c68:	fd06                	sd	ra,184(sp)
    80004c6a:	f922                	sd	s0,176(sp)
    80004c6c:	f526                	sd	s1,168(sp)
    80004c6e:	f14a                	sd	s2,160(sp)
    80004c70:	ed4e                	sd	s3,152(sp)
    80004c72:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c74:	08000613          	li	a2,128
    80004c78:	f5040593          	addi	a1,s0,-176
    80004c7c:	4501                	li	a0,0
    80004c7e:	ffffd097          	auipc	ra,0xffffd
    80004c82:	47c080e7          	jalr	1148(ra) # 800020fa <argstr>
    return -1;
    80004c86:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c88:	0c054163          	bltz	a0,80004d4a <sys_open+0xe4>
    80004c8c:	f4c40593          	addi	a1,s0,-180
    80004c90:	4505                	li	a0,1
    80004c92:	ffffd097          	auipc	ra,0xffffd
    80004c96:	424080e7          	jalr	1060(ra) # 800020b6 <argint>
    80004c9a:	0a054863          	bltz	a0,80004d4a <sys_open+0xe4>

  begin_op();
    80004c9e:	fffff097          	auipc	ra,0xfffff
    80004ca2:	9f0080e7          	jalr	-1552(ra) # 8000368e <begin_op>

  if(omode & O_CREATE){
    80004ca6:	f4c42783          	lw	a5,-180(s0)
    80004caa:	2007f793          	andi	a5,a5,512
    80004cae:	cbdd                	beqz	a5,80004d64 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cb0:	4681                	li	a3,0
    80004cb2:	4601                	li	a2,0
    80004cb4:	4589                	li	a1,2
    80004cb6:	f5040513          	addi	a0,s0,-176
    80004cba:	00000097          	auipc	ra,0x0
    80004cbe:	970080e7          	jalr	-1680(ra) # 8000462a <create>
    80004cc2:	892a                	mv	s2,a0
    if(ip == 0){
    80004cc4:	c959                	beqz	a0,80004d5a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cc6:	04491703          	lh	a4,68(s2)
    80004cca:	478d                	li	a5,3
    80004ccc:	00f71763          	bne	a4,a5,80004cda <sys_open+0x74>
    80004cd0:	04695703          	lhu	a4,70(s2)
    80004cd4:	47a5                	li	a5,9
    80004cd6:	0ce7ec63          	bltu	a5,a4,80004dae <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cda:	fffff097          	auipc	ra,0xfffff
    80004cde:	dc0080e7          	jalr	-576(ra) # 80003a9a <filealloc>
    80004ce2:	89aa                	mv	s3,a0
    80004ce4:	10050263          	beqz	a0,80004de8 <sys_open+0x182>
    80004ce8:	00000097          	auipc	ra,0x0
    80004cec:	900080e7          	jalr	-1792(ra) # 800045e8 <fdalloc>
    80004cf0:	84aa                	mv	s1,a0
    80004cf2:	0e054663          	bltz	a0,80004dde <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cf6:	04491703          	lh	a4,68(s2)
    80004cfa:	478d                	li	a5,3
    80004cfc:	0cf70463          	beq	a4,a5,80004dc4 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d00:	4789                	li	a5,2
    80004d02:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d06:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d0a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d0e:	f4c42783          	lw	a5,-180(s0)
    80004d12:	0017c713          	xori	a4,a5,1
    80004d16:	8b05                	andi	a4,a4,1
    80004d18:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d1c:	0037f713          	andi	a4,a5,3
    80004d20:	00e03733          	snez	a4,a4
    80004d24:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d28:	4007f793          	andi	a5,a5,1024
    80004d2c:	c791                	beqz	a5,80004d38 <sys_open+0xd2>
    80004d2e:	04491703          	lh	a4,68(s2)
    80004d32:	4789                	li	a5,2
    80004d34:	08f70f63          	beq	a4,a5,80004dd2 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d38:	854a                	mv	a0,s2
    80004d3a:	ffffe097          	auipc	ra,0xffffe
    80004d3e:	03a080e7          	jalr	58(ra) # 80002d74 <iunlock>
  end_op();
    80004d42:	fffff097          	auipc	ra,0xfffff
    80004d46:	9ca080e7          	jalr	-1590(ra) # 8000370c <end_op>

  return fd;
}
    80004d4a:	8526                	mv	a0,s1
    80004d4c:	70ea                	ld	ra,184(sp)
    80004d4e:	744a                	ld	s0,176(sp)
    80004d50:	74aa                	ld	s1,168(sp)
    80004d52:	790a                	ld	s2,160(sp)
    80004d54:	69ea                	ld	s3,152(sp)
    80004d56:	6129                	addi	sp,sp,192
    80004d58:	8082                	ret
      end_op();
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	9b2080e7          	jalr	-1614(ra) # 8000370c <end_op>
      return -1;
    80004d62:	b7e5                	j	80004d4a <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d64:	f5040513          	addi	a0,s0,-176
    80004d68:	ffffe097          	auipc	ra,0xffffe
    80004d6c:	706080e7          	jalr	1798(ra) # 8000346e <namei>
    80004d70:	892a                	mv	s2,a0
    80004d72:	c905                	beqz	a0,80004da2 <sys_open+0x13c>
    ilock(ip);
    80004d74:	ffffe097          	auipc	ra,0xffffe
    80004d78:	f3e080e7          	jalr	-194(ra) # 80002cb2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d7c:	04491703          	lh	a4,68(s2)
    80004d80:	4785                	li	a5,1
    80004d82:	f4f712e3          	bne	a4,a5,80004cc6 <sys_open+0x60>
    80004d86:	f4c42783          	lw	a5,-180(s0)
    80004d8a:	dba1                	beqz	a5,80004cda <sys_open+0x74>
      iunlockput(ip);
    80004d8c:	854a                	mv	a0,s2
    80004d8e:	ffffe097          	auipc	ra,0xffffe
    80004d92:	186080e7          	jalr	390(ra) # 80002f14 <iunlockput>
      end_op();
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	976080e7          	jalr	-1674(ra) # 8000370c <end_op>
      return -1;
    80004d9e:	54fd                	li	s1,-1
    80004da0:	b76d                	j	80004d4a <sys_open+0xe4>
      end_op();
    80004da2:	fffff097          	auipc	ra,0xfffff
    80004da6:	96a080e7          	jalr	-1686(ra) # 8000370c <end_op>
      return -1;
    80004daa:	54fd                	li	s1,-1
    80004dac:	bf79                	j	80004d4a <sys_open+0xe4>
    iunlockput(ip);
    80004dae:	854a                	mv	a0,s2
    80004db0:	ffffe097          	auipc	ra,0xffffe
    80004db4:	164080e7          	jalr	356(ra) # 80002f14 <iunlockput>
    end_op();
    80004db8:	fffff097          	auipc	ra,0xfffff
    80004dbc:	954080e7          	jalr	-1708(ra) # 8000370c <end_op>
    return -1;
    80004dc0:	54fd                	li	s1,-1
    80004dc2:	b761                	j	80004d4a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004dc4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004dc8:	04691783          	lh	a5,70(s2)
    80004dcc:	02f99223          	sh	a5,36(s3)
    80004dd0:	bf2d                	j	80004d0a <sys_open+0xa4>
    itrunc(ip);
    80004dd2:	854a                	mv	a0,s2
    80004dd4:	ffffe097          	auipc	ra,0xffffe
    80004dd8:	fec080e7          	jalr	-20(ra) # 80002dc0 <itrunc>
    80004ddc:	bfb1                	j	80004d38 <sys_open+0xd2>
      fileclose(f);
    80004dde:	854e                	mv	a0,s3
    80004de0:	fffff097          	auipc	ra,0xfffff
    80004de4:	d76080e7          	jalr	-650(ra) # 80003b56 <fileclose>
    iunlockput(ip);
    80004de8:	854a                	mv	a0,s2
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	12a080e7          	jalr	298(ra) # 80002f14 <iunlockput>
    end_op();
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	91a080e7          	jalr	-1766(ra) # 8000370c <end_op>
    return -1;
    80004dfa:	54fd                	li	s1,-1
    80004dfc:	b7b9                	j	80004d4a <sys_open+0xe4>

0000000080004dfe <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004dfe:	7175                	addi	sp,sp,-144
    80004e00:	e506                	sd	ra,136(sp)
    80004e02:	e122                	sd	s0,128(sp)
    80004e04:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e06:	fffff097          	auipc	ra,0xfffff
    80004e0a:	888080e7          	jalr	-1912(ra) # 8000368e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e0e:	08000613          	li	a2,128
    80004e12:	f7040593          	addi	a1,s0,-144
    80004e16:	4501                	li	a0,0
    80004e18:	ffffd097          	auipc	ra,0xffffd
    80004e1c:	2e2080e7          	jalr	738(ra) # 800020fa <argstr>
    80004e20:	02054963          	bltz	a0,80004e52 <sys_mkdir+0x54>
    80004e24:	4681                	li	a3,0
    80004e26:	4601                	li	a2,0
    80004e28:	4585                	li	a1,1
    80004e2a:	f7040513          	addi	a0,s0,-144
    80004e2e:	fffff097          	auipc	ra,0xfffff
    80004e32:	7fc080e7          	jalr	2044(ra) # 8000462a <create>
    80004e36:	cd11                	beqz	a0,80004e52 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	0dc080e7          	jalr	220(ra) # 80002f14 <iunlockput>
  end_op();
    80004e40:	fffff097          	auipc	ra,0xfffff
    80004e44:	8cc080e7          	jalr	-1844(ra) # 8000370c <end_op>
  return 0;
    80004e48:	4501                	li	a0,0
}
    80004e4a:	60aa                	ld	ra,136(sp)
    80004e4c:	640a                	ld	s0,128(sp)
    80004e4e:	6149                	addi	sp,sp,144
    80004e50:	8082                	ret
    end_op();
    80004e52:	fffff097          	auipc	ra,0xfffff
    80004e56:	8ba080e7          	jalr	-1862(ra) # 8000370c <end_op>
    return -1;
    80004e5a:	557d                	li	a0,-1
    80004e5c:	b7fd                	j	80004e4a <sys_mkdir+0x4c>

0000000080004e5e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e5e:	7135                	addi	sp,sp,-160
    80004e60:	ed06                	sd	ra,152(sp)
    80004e62:	e922                	sd	s0,144(sp)
    80004e64:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e66:	fffff097          	auipc	ra,0xfffff
    80004e6a:	828080e7          	jalr	-2008(ra) # 8000368e <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e6e:	08000613          	li	a2,128
    80004e72:	f7040593          	addi	a1,s0,-144
    80004e76:	4501                	li	a0,0
    80004e78:	ffffd097          	auipc	ra,0xffffd
    80004e7c:	282080e7          	jalr	642(ra) # 800020fa <argstr>
    80004e80:	04054a63          	bltz	a0,80004ed4 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e84:	f6c40593          	addi	a1,s0,-148
    80004e88:	4505                	li	a0,1
    80004e8a:	ffffd097          	auipc	ra,0xffffd
    80004e8e:	22c080e7          	jalr	556(ra) # 800020b6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e92:	04054163          	bltz	a0,80004ed4 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e96:	f6840593          	addi	a1,s0,-152
    80004e9a:	4509                	li	a0,2
    80004e9c:	ffffd097          	auipc	ra,0xffffd
    80004ea0:	21a080e7          	jalr	538(ra) # 800020b6 <argint>
     argint(1, &major) < 0 ||
    80004ea4:	02054863          	bltz	a0,80004ed4 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ea8:	f6841683          	lh	a3,-152(s0)
    80004eac:	f6c41603          	lh	a2,-148(s0)
    80004eb0:	458d                	li	a1,3
    80004eb2:	f7040513          	addi	a0,s0,-144
    80004eb6:	fffff097          	auipc	ra,0xfffff
    80004eba:	774080e7          	jalr	1908(ra) # 8000462a <create>
     argint(2, &minor) < 0 ||
    80004ebe:	c919                	beqz	a0,80004ed4 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ec0:	ffffe097          	auipc	ra,0xffffe
    80004ec4:	054080e7          	jalr	84(ra) # 80002f14 <iunlockput>
  end_op();
    80004ec8:	fffff097          	auipc	ra,0xfffff
    80004ecc:	844080e7          	jalr	-1980(ra) # 8000370c <end_op>
  return 0;
    80004ed0:	4501                	li	a0,0
    80004ed2:	a031                	j	80004ede <sys_mknod+0x80>
    end_op();
    80004ed4:	fffff097          	auipc	ra,0xfffff
    80004ed8:	838080e7          	jalr	-1992(ra) # 8000370c <end_op>
    return -1;
    80004edc:	557d                	li	a0,-1
}
    80004ede:	60ea                	ld	ra,152(sp)
    80004ee0:	644a                	ld	s0,144(sp)
    80004ee2:	610d                	addi	sp,sp,160
    80004ee4:	8082                	ret

0000000080004ee6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ee6:	7135                	addi	sp,sp,-160
    80004ee8:	ed06                	sd	ra,152(sp)
    80004eea:	e922                	sd	s0,144(sp)
    80004eec:	e526                	sd	s1,136(sp)
    80004eee:	e14a                	sd	s2,128(sp)
    80004ef0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ef2:	ffffc097          	auipc	ra,0xffffc
    80004ef6:	084080e7          	jalr	132(ra) # 80000f76 <myproc>
    80004efa:	892a                	mv	s2,a0
  
  begin_op();
    80004efc:	ffffe097          	auipc	ra,0xffffe
    80004f00:	792080e7          	jalr	1938(ra) # 8000368e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f04:	08000613          	li	a2,128
    80004f08:	f6040593          	addi	a1,s0,-160
    80004f0c:	4501                	li	a0,0
    80004f0e:	ffffd097          	auipc	ra,0xffffd
    80004f12:	1ec080e7          	jalr	492(ra) # 800020fa <argstr>
    80004f16:	04054b63          	bltz	a0,80004f6c <sys_chdir+0x86>
    80004f1a:	f6040513          	addi	a0,s0,-160
    80004f1e:	ffffe097          	auipc	ra,0xffffe
    80004f22:	550080e7          	jalr	1360(ra) # 8000346e <namei>
    80004f26:	84aa                	mv	s1,a0
    80004f28:	c131                	beqz	a0,80004f6c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f2a:	ffffe097          	auipc	ra,0xffffe
    80004f2e:	d88080e7          	jalr	-632(ra) # 80002cb2 <ilock>
  if(ip->type != T_DIR){
    80004f32:	04449703          	lh	a4,68(s1)
    80004f36:	4785                	li	a5,1
    80004f38:	04f71063          	bne	a4,a5,80004f78 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f3c:	8526                	mv	a0,s1
    80004f3e:	ffffe097          	auipc	ra,0xffffe
    80004f42:	e36080e7          	jalr	-458(ra) # 80002d74 <iunlock>
  iput(p->cwd);
    80004f46:	15093503          	ld	a0,336(s2)
    80004f4a:	ffffe097          	auipc	ra,0xffffe
    80004f4e:	f22080e7          	jalr	-222(ra) # 80002e6c <iput>
  end_op();
    80004f52:	ffffe097          	auipc	ra,0xffffe
    80004f56:	7ba080e7          	jalr	1978(ra) # 8000370c <end_op>
  p->cwd = ip;
    80004f5a:	14993823          	sd	s1,336(s2)
  return 0;
    80004f5e:	4501                	li	a0,0
}
    80004f60:	60ea                	ld	ra,152(sp)
    80004f62:	644a                	ld	s0,144(sp)
    80004f64:	64aa                	ld	s1,136(sp)
    80004f66:	690a                	ld	s2,128(sp)
    80004f68:	610d                	addi	sp,sp,160
    80004f6a:	8082                	ret
    end_op();
    80004f6c:	ffffe097          	auipc	ra,0xffffe
    80004f70:	7a0080e7          	jalr	1952(ra) # 8000370c <end_op>
    return -1;
    80004f74:	557d                	li	a0,-1
    80004f76:	b7ed                	j	80004f60 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f78:	8526                	mv	a0,s1
    80004f7a:	ffffe097          	auipc	ra,0xffffe
    80004f7e:	f9a080e7          	jalr	-102(ra) # 80002f14 <iunlockput>
    end_op();
    80004f82:	ffffe097          	auipc	ra,0xffffe
    80004f86:	78a080e7          	jalr	1930(ra) # 8000370c <end_op>
    return -1;
    80004f8a:	557d                	li	a0,-1
    80004f8c:	bfd1                	j	80004f60 <sys_chdir+0x7a>

0000000080004f8e <sys_exec>:

uint64
sys_exec(void)
{
    80004f8e:	7145                	addi	sp,sp,-464
    80004f90:	e786                	sd	ra,456(sp)
    80004f92:	e3a2                	sd	s0,448(sp)
    80004f94:	ff26                	sd	s1,440(sp)
    80004f96:	fb4a                	sd	s2,432(sp)
    80004f98:	f74e                	sd	s3,424(sp)
    80004f9a:	f352                	sd	s4,416(sp)
    80004f9c:	ef56                	sd	s5,408(sp)
    80004f9e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fa0:	08000613          	li	a2,128
    80004fa4:	f4040593          	addi	a1,s0,-192
    80004fa8:	4501                	li	a0,0
    80004faa:	ffffd097          	auipc	ra,0xffffd
    80004fae:	150080e7          	jalr	336(ra) # 800020fa <argstr>
    return -1;
    80004fb2:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fb4:	0c054b63          	bltz	a0,8000508a <sys_exec+0xfc>
    80004fb8:	e3840593          	addi	a1,s0,-456
    80004fbc:	4505                	li	a0,1
    80004fbe:	ffffd097          	auipc	ra,0xffffd
    80004fc2:	11a080e7          	jalr	282(ra) # 800020d8 <argaddr>
    80004fc6:	0c054263          	bltz	a0,8000508a <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004fca:	10000613          	li	a2,256
    80004fce:	4581                	li	a1,0
    80004fd0:	e4040513          	addi	a0,s0,-448
    80004fd4:	ffffb097          	auipc	ra,0xffffb
    80004fd8:	1a6080e7          	jalr	422(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fdc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004fe0:	89a6                	mv	s3,s1
    80004fe2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fe4:	02000a13          	li	s4,32
    80004fe8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fec:	00391513          	slli	a0,s2,0x3
    80004ff0:	e3040593          	addi	a1,s0,-464
    80004ff4:	e3843783          	ld	a5,-456(s0)
    80004ff8:	953e                	add	a0,a0,a5
    80004ffa:	ffffd097          	auipc	ra,0xffffd
    80004ffe:	022080e7          	jalr	34(ra) # 8000201c <fetchaddr>
    80005002:	02054a63          	bltz	a0,80005036 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005006:	e3043783          	ld	a5,-464(s0)
    8000500a:	c3b9                	beqz	a5,80005050 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000500c:	ffffb097          	auipc	ra,0xffffb
    80005010:	10e080e7          	jalr	270(ra) # 8000011a <kalloc>
    80005014:	85aa                	mv	a1,a0
    80005016:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000501a:	cd11                	beqz	a0,80005036 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000501c:	6605                	lui	a2,0x1
    8000501e:	e3043503          	ld	a0,-464(s0)
    80005022:	ffffd097          	auipc	ra,0xffffd
    80005026:	04c080e7          	jalr	76(ra) # 8000206e <fetchstr>
    8000502a:	00054663          	bltz	a0,80005036 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000502e:	0905                	addi	s2,s2,1
    80005030:	09a1                	addi	s3,s3,8
    80005032:	fb491be3          	bne	s2,s4,80004fe8 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005036:	f4040913          	addi	s2,s0,-192
    8000503a:	6088                	ld	a0,0(s1)
    8000503c:	c531                	beqz	a0,80005088 <sys_exec+0xfa>
    kfree(argv[i]);
    8000503e:	ffffb097          	auipc	ra,0xffffb
    80005042:	fde080e7          	jalr	-34(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005046:	04a1                	addi	s1,s1,8
    80005048:	ff2499e3          	bne	s1,s2,8000503a <sys_exec+0xac>
  return -1;
    8000504c:	597d                	li	s2,-1
    8000504e:	a835                	j	8000508a <sys_exec+0xfc>
      argv[i] = 0;
    80005050:	0a8e                	slli	s5,s5,0x3
    80005052:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    80005056:	00878ab3          	add	s5,a5,s0
    8000505a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000505e:	e4040593          	addi	a1,s0,-448
    80005062:	f4040513          	addi	a0,s0,-192
    80005066:	fffff097          	auipc	ra,0xfffff
    8000506a:	144080e7          	jalr	324(ra) # 800041aa <exec>
    8000506e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005070:	f4040993          	addi	s3,s0,-192
    80005074:	6088                	ld	a0,0(s1)
    80005076:	c911                	beqz	a0,8000508a <sys_exec+0xfc>
    kfree(argv[i]);
    80005078:	ffffb097          	auipc	ra,0xffffb
    8000507c:	fa4080e7          	jalr	-92(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005080:	04a1                	addi	s1,s1,8
    80005082:	ff3499e3          	bne	s1,s3,80005074 <sys_exec+0xe6>
    80005086:	a011                	j	8000508a <sys_exec+0xfc>
  return -1;
    80005088:	597d                	li	s2,-1
}
    8000508a:	854a                	mv	a0,s2
    8000508c:	60be                	ld	ra,456(sp)
    8000508e:	641e                	ld	s0,448(sp)
    80005090:	74fa                	ld	s1,440(sp)
    80005092:	795a                	ld	s2,432(sp)
    80005094:	79ba                	ld	s3,424(sp)
    80005096:	7a1a                	ld	s4,416(sp)
    80005098:	6afa                	ld	s5,408(sp)
    8000509a:	6179                	addi	sp,sp,464
    8000509c:	8082                	ret

000000008000509e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000509e:	7139                	addi	sp,sp,-64
    800050a0:	fc06                	sd	ra,56(sp)
    800050a2:	f822                	sd	s0,48(sp)
    800050a4:	f426                	sd	s1,40(sp)
    800050a6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050a8:	ffffc097          	auipc	ra,0xffffc
    800050ac:	ece080e7          	jalr	-306(ra) # 80000f76 <myproc>
    800050b0:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050b2:	fd840593          	addi	a1,s0,-40
    800050b6:	4501                	li	a0,0
    800050b8:	ffffd097          	auipc	ra,0xffffd
    800050bc:	020080e7          	jalr	32(ra) # 800020d8 <argaddr>
    return -1;
    800050c0:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050c2:	0e054063          	bltz	a0,800051a2 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050c6:	fc840593          	addi	a1,s0,-56
    800050ca:	fd040513          	addi	a0,s0,-48
    800050ce:	fffff097          	auipc	ra,0xfffff
    800050d2:	db8080e7          	jalr	-584(ra) # 80003e86 <pipealloc>
    return -1;
    800050d6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050d8:	0c054563          	bltz	a0,800051a2 <sys_pipe+0x104>
  fd0 = -1;
    800050dc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050e0:	fd043503          	ld	a0,-48(s0)
    800050e4:	fffff097          	auipc	ra,0xfffff
    800050e8:	504080e7          	jalr	1284(ra) # 800045e8 <fdalloc>
    800050ec:	fca42223          	sw	a0,-60(s0)
    800050f0:	08054c63          	bltz	a0,80005188 <sys_pipe+0xea>
    800050f4:	fc843503          	ld	a0,-56(s0)
    800050f8:	fffff097          	auipc	ra,0xfffff
    800050fc:	4f0080e7          	jalr	1264(ra) # 800045e8 <fdalloc>
    80005100:	fca42023          	sw	a0,-64(s0)
    80005104:	06054963          	bltz	a0,80005176 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005108:	4691                	li	a3,4
    8000510a:	fc440613          	addi	a2,s0,-60
    8000510e:	fd843583          	ld	a1,-40(s0)
    80005112:	68a8                	ld	a0,80(s1)
    80005114:	ffffc097          	auipc	ra,0xffffc
    80005118:	9f4080e7          	jalr	-1548(ra) # 80000b08 <copyout>
    8000511c:	02054063          	bltz	a0,8000513c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005120:	4691                	li	a3,4
    80005122:	fc040613          	addi	a2,s0,-64
    80005126:	fd843583          	ld	a1,-40(s0)
    8000512a:	0591                	addi	a1,a1,4
    8000512c:	68a8                	ld	a0,80(s1)
    8000512e:	ffffc097          	auipc	ra,0xffffc
    80005132:	9da080e7          	jalr	-1574(ra) # 80000b08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005136:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005138:	06055563          	bgez	a0,800051a2 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000513c:	fc442783          	lw	a5,-60(s0)
    80005140:	07e9                	addi	a5,a5,26
    80005142:	078e                	slli	a5,a5,0x3
    80005144:	97a6                	add	a5,a5,s1
    80005146:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000514a:	fc042783          	lw	a5,-64(s0)
    8000514e:	07e9                	addi	a5,a5,26
    80005150:	078e                	slli	a5,a5,0x3
    80005152:	00f48533          	add	a0,s1,a5
    80005156:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000515a:	fd043503          	ld	a0,-48(s0)
    8000515e:	fffff097          	auipc	ra,0xfffff
    80005162:	9f8080e7          	jalr	-1544(ra) # 80003b56 <fileclose>
    fileclose(wf);
    80005166:	fc843503          	ld	a0,-56(s0)
    8000516a:	fffff097          	auipc	ra,0xfffff
    8000516e:	9ec080e7          	jalr	-1556(ra) # 80003b56 <fileclose>
    return -1;
    80005172:	57fd                	li	a5,-1
    80005174:	a03d                	j	800051a2 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005176:	fc442783          	lw	a5,-60(s0)
    8000517a:	0007c763          	bltz	a5,80005188 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000517e:	07e9                	addi	a5,a5,26
    80005180:	078e                	slli	a5,a5,0x3
    80005182:	97a6                	add	a5,a5,s1
    80005184:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005188:	fd043503          	ld	a0,-48(s0)
    8000518c:	fffff097          	auipc	ra,0xfffff
    80005190:	9ca080e7          	jalr	-1590(ra) # 80003b56 <fileclose>
    fileclose(wf);
    80005194:	fc843503          	ld	a0,-56(s0)
    80005198:	fffff097          	auipc	ra,0xfffff
    8000519c:	9be080e7          	jalr	-1602(ra) # 80003b56 <fileclose>
    return -1;
    800051a0:	57fd                	li	a5,-1
}
    800051a2:	853e                	mv	a0,a5
    800051a4:	70e2                	ld	ra,56(sp)
    800051a6:	7442                	ld	s0,48(sp)
    800051a8:	74a2                	ld	s1,40(sp)
    800051aa:	6121                	addi	sp,sp,64
    800051ac:	8082                	ret
	...

00000000800051b0 <kernelvec>:
    800051b0:	7111                	addi	sp,sp,-256
    800051b2:	e006                	sd	ra,0(sp)
    800051b4:	e40a                	sd	sp,8(sp)
    800051b6:	e80e                	sd	gp,16(sp)
    800051b8:	ec12                	sd	tp,24(sp)
    800051ba:	f016                	sd	t0,32(sp)
    800051bc:	f41a                	sd	t1,40(sp)
    800051be:	f81e                	sd	t2,48(sp)
    800051c0:	fc22                	sd	s0,56(sp)
    800051c2:	e0a6                	sd	s1,64(sp)
    800051c4:	e4aa                	sd	a0,72(sp)
    800051c6:	e8ae                	sd	a1,80(sp)
    800051c8:	ecb2                	sd	a2,88(sp)
    800051ca:	f0b6                	sd	a3,96(sp)
    800051cc:	f4ba                	sd	a4,104(sp)
    800051ce:	f8be                	sd	a5,112(sp)
    800051d0:	fcc2                	sd	a6,120(sp)
    800051d2:	e146                	sd	a7,128(sp)
    800051d4:	e54a                	sd	s2,136(sp)
    800051d6:	e94e                	sd	s3,144(sp)
    800051d8:	ed52                	sd	s4,152(sp)
    800051da:	f156                	sd	s5,160(sp)
    800051dc:	f55a                	sd	s6,168(sp)
    800051de:	f95e                	sd	s7,176(sp)
    800051e0:	fd62                	sd	s8,184(sp)
    800051e2:	e1e6                	sd	s9,192(sp)
    800051e4:	e5ea                	sd	s10,200(sp)
    800051e6:	e9ee                	sd	s11,208(sp)
    800051e8:	edf2                	sd	t3,216(sp)
    800051ea:	f1f6                	sd	t4,224(sp)
    800051ec:	f5fa                	sd	t5,232(sp)
    800051ee:	f9fe                	sd	t6,240(sp)
    800051f0:	cf9fc0ef          	jal	ra,80001ee8 <kerneltrap>
    800051f4:	6082                	ld	ra,0(sp)
    800051f6:	6122                	ld	sp,8(sp)
    800051f8:	61c2                	ld	gp,16(sp)
    800051fa:	7282                	ld	t0,32(sp)
    800051fc:	7322                	ld	t1,40(sp)
    800051fe:	73c2                	ld	t2,48(sp)
    80005200:	7462                	ld	s0,56(sp)
    80005202:	6486                	ld	s1,64(sp)
    80005204:	6526                	ld	a0,72(sp)
    80005206:	65c6                	ld	a1,80(sp)
    80005208:	6666                	ld	a2,88(sp)
    8000520a:	7686                	ld	a3,96(sp)
    8000520c:	7726                	ld	a4,104(sp)
    8000520e:	77c6                	ld	a5,112(sp)
    80005210:	7866                	ld	a6,120(sp)
    80005212:	688a                	ld	a7,128(sp)
    80005214:	692a                	ld	s2,136(sp)
    80005216:	69ca                	ld	s3,144(sp)
    80005218:	6a6a                	ld	s4,152(sp)
    8000521a:	7a8a                	ld	s5,160(sp)
    8000521c:	7b2a                	ld	s6,168(sp)
    8000521e:	7bca                	ld	s7,176(sp)
    80005220:	7c6a                	ld	s8,184(sp)
    80005222:	6c8e                	ld	s9,192(sp)
    80005224:	6d2e                	ld	s10,200(sp)
    80005226:	6dce                	ld	s11,208(sp)
    80005228:	6e6e                	ld	t3,216(sp)
    8000522a:	7e8e                	ld	t4,224(sp)
    8000522c:	7f2e                	ld	t5,232(sp)
    8000522e:	7fce                	ld	t6,240(sp)
    80005230:	6111                	addi	sp,sp,256
    80005232:	10200073          	sret
    80005236:	00000013          	nop
    8000523a:	00000013          	nop
    8000523e:	0001                	nop

0000000080005240 <timervec>:
    80005240:	34051573          	csrrw	a0,mscratch,a0
    80005244:	e10c                	sd	a1,0(a0)
    80005246:	e510                	sd	a2,8(a0)
    80005248:	e914                	sd	a3,16(a0)
    8000524a:	6d0c                	ld	a1,24(a0)
    8000524c:	7110                	ld	a2,32(a0)
    8000524e:	6194                	ld	a3,0(a1)
    80005250:	96b2                	add	a3,a3,a2
    80005252:	e194                	sd	a3,0(a1)
    80005254:	4589                	li	a1,2
    80005256:	14459073          	csrw	sip,a1
    8000525a:	6914                	ld	a3,16(a0)
    8000525c:	6510                	ld	a2,8(a0)
    8000525e:	610c                	ld	a1,0(a0)
    80005260:	34051573          	csrrw	a0,mscratch,a0
    80005264:	30200073          	mret
	...

000000008000526a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000526a:	1141                	addi	sp,sp,-16
    8000526c:	e422                	sd	s0,8(sp)
    8000526e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005270:	0c0007b7          	lui	a5,0xc000
    80005274:	4705                	li	a4,1
    80005276:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005278:	c3d8                	sw	a4,4(a5)
}
    8000527a:	6422                	ld	s0,8(sp)
    8000527c:	0141                	addi	sp,sp,16
    8000527e:	8082                	ret

0000000080005280 <plicinithart>:

void
plicinithart(void)
{
    80005280:	1141                	addi	sp,sp,-16
    80005282:	e406                	sd	ra,8(sp)
    80005284:	e022                	sd	s0,0(sp)
    80005286:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	cc2080e7          	jalr	-830(ra) # 80000f4a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005290:	0085171b          	slliw	a4,a0,0x8
    80005294:	0c0027b7          	lui	a5,0xc002
    80005298:	97ba                	add	a5,a5,a4
    8000529a:	40200713          	li	a4,1026
    8000529e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052a2:	00d5151b          	slliw	a0,a0,0xd
    800052a6:	0c2017b7          	lui	a5,0xc201
    800052aa:	97aa                	add	a5,a5,a0
    800052ac:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052b0:	60a2                	ld	ra,8(sp)
    800052b2:	6402                	ld	s0,0(sp)
    800052b4:	0141                	addi	sp,sp,16
    800052b6:	8082                	ret

00000000800052b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052b8:	1141                	addi	sp,sp,-16
    800052ba:	e406                	sd	ra,8(sp)
    800052bc:	e022                	sd	s0,0(sp)
    800052be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052c0:	ffffc097          	auipc	ra,0xffffc
    800052c4:	c8a080e7          	jalr	-886(ra) # 80000f4a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052c8:	00d5151b          	slliw	a0,a0,0xd
    800052cc:	0c2017b7          	lui	a5,0xc201
    800052d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800052d2:	43c8                	lw	a0,4(a5)
    800052d4:	60a2                	ld	ra,8(sp)
    800052d6:	6402                	ld	s0,0(sp)
    800052d8:	0141                	addi	sp,sp,16
    800052da:	8082                	ret

00000000800052dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052dc:	1101                	addi	sp,sp,-32
    800052de:	ec06                	sd	ra,24(sp)
    800052e0:	e822                	sd	s0,16(sp)
    800052e2:	e426                	sd	s1,8(sp)
    800052e4:	1000                	addi	s0,sp,32
    800052e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052e8:	ffffc097          	auipc	ra,0xffffc
    800052ec:	c62080e7          	jalr	-926(ra) # 80000f4a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052f0:	00d5151b          	slliw	a0,a0,0xd
    800052f4:	0c2017b7          	lui	a5,0xc201
    800052f8:	97aa                	add	a5,a5,a0
    800052fa:	c3c4                	sw	s1,4(a5)
}
    800052fc:	60e2                	ld	ra,24(sp)
    800052fe:	6442                	ld	s0,16(sp)
    80005300:	64a2                	ld	s1,8(sp)
    80005302:	6105                	addi	sp,sp,32
    80005304:	8082                	ret

0000000080005306 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005306:	1141                	addi	sp,sp,-16
    80005308:	e406                	sd	ra,8(sp)
    8000530a:	e022                	sd	s0,0(sp)
    8000530c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000530e:	479d                	li	a5,7
    80005310:	06a7c863          	blt	a5,a0,80005380 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005314:	00016717          	auipc	a4,0x16
    80005318:	cec70713          	addi	a4,a4,-788 # 8001b000 <disk>
    8000531c:	972a                	add	a4,a4,a0
    8000531e:	6789                	lui	a5,0x2
    80005320:	97ba                	add	a5,a5,a4
    80005322:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005326:	e7ad                	bnez	a5,80005390 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005328:	00451793          	slli	a5,a0,0x4
    8000532c:	00018717          	auipc	a4,0x18
    80005330:	cd470713          	addi	a4,a4,-812 # 8001d000 <disk+0x2000>
    80005334:	6314                	ld	a3,0(a4)
    80005336:	96be                	add	a3,a3,a5
    80005338:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000533c:	6314                	ld	a3,0(a4)
    8000533e:	96be                	add	a3,a3,a5
    80005340:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005344:	6314                	ld	a3,0(a4)
    80005346:	96be                	add	a3,a3,a5
    80005348:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000534c:	6318                	ld	a4,0(a4)
    8000534e:	97ba                	add	a5,a5,a4
    80005350:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005354:	00016717          	auipc	a4,0x16
    80005358:	cac70713          	addi	a4,a4,-852 # 8001b000 <disk>
    8000535c:	972a                	add	a4,a4,a0
    8000535e:	6789                	lui	a5,0x2
    80005360:	97ba                	add	a5,a5,a4
    80005362:	4705                	li	a4,1
    80005364:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005368:	00018517          	auipc	a0,0x18
    8000536c:	cb050513          	addi	a0,a0,-848 # 8001d018 <disk+0x2018>
    80005370:	ffffc097          	auipc	ra,0xffffc
    80005374:	4e0080e7          	jalr	1248(ra) # 80001850 <wakeup>
}
    80005378:	60a2                	ld	ra,8(sp)
    8000537a:	6402                	ld	s0,0(sp)
    8000537c:	0141                	addi	sp,sp,16
    8000537e:	8082                	ret
    panic("free_desc 1");
    80005380:	00003517          	auipc	a0,0x3
    80005384:	3f050513          	addi	a0,a0,1008 # 80008770 <syscalls+0x370>
    80005388:	00001097          	auipc	ra,0x1
    8000538c:	9c8080e7          	jalr	-1592(ra) # 80005d50 <panic>
    panic("free_desc 2");
    80005390:	00003517          	auipc	a0,0x3
    80005394:	3f050513          	addi	a0,a0,1008 # 80008780 <syscalls+0x380>
    80005398:	00001097          	auipc	ra,0x1
    8000539c:	9b8080e7          	jalr	-1608(ra) # 80005d50 <panic>

00000000800053a0 <virtio_disk_init>:
{
    800053a0:	1101                	addi	sp,sp,-32
    800053a2:	ec06                	sd	ra,24(sp)
    800053a4:	e822                	sd	s0,16(sp)
    800053a6:	e426                	sd	s1,8(sp)
    800053a8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053aa:	00003597          	auipc	a1,0x3
    800053ae:	3e658593          	addi	a1,a1,998 # 80008790 <syscalls+0x390>
    800053b2:	00018517          	auipc	a0,0x18
    800053b6:	d7650513          	addi	a0,a0,-650 # 8001d128 <disk+0x2128>
    800053ba:	00001097          	auipc	ra,0x1
    800053be:	e3e080e7          	jalr	-450(ra) # 800061f8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053c2:	100017b7          	lui	a5,0x10001
    800053c6:	4398                	lw	a4,0(a5)
    800053c8:	2701                	sext.w	a4,a4
    800053ca:	747277b7          	lui	a5,0x74727
    800053ce:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053d2:	0ef71063          	bne	a4,a5,800054b2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053d6:	100017b7          	lui	a5,0x10001
    800053da:	43dc                	lw	a5,4(a5)
    800053dc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053de:	4705                	li	a4,1
    800053e0:	0ce79963          	bne	a5,a4,800054b2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053e4:	100017b7          	lui	a5,0x10001
    800053e8:	479c                	lw	a5,8(a5)
    800053ea:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053ec:	4709                	li	a4,2
    800053ee:	0ce79263          	bne	a5,a4,800054b2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053f2:	100017b7          	lui	a5,0x10001
    800053f6:	47d8                	lw	a4,12(a5)
    800053f8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053fa:	554d47b7          	lui	a5,0x554d4
    800053fe:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005402:	0af71863          	bne	a4,a5,800054b2 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005406:	100017b7          	lui	a5,0x10001
    8000540a:	4705                	li	a4,1
    8000540c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000540e:	470d                	li	a4,3
    80005410:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005412:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005414:	c7ffe6b7          	lui	a3,0xc7ffe
    80005418:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000541c:	8f75                	and	a4,a4,a3
    8000541e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005420:	472d                	li	a4,11
    80005422:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005424:	473d                	li	a4,15
    80005426:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005428:	6705                	lui	a4,0x1
    8000542a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000542c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005430:	5bdc                	lw	a5,52(a5)
    80005432:	2781                	sext.w	a5,a5
  if(max == 0)
    80005434:	c7d9                	beqz	a5,800054c2 <virtio_disk_init+0x122>
  if(max < NUM)
    80005436:	471d                	li	a4,7
    80005438:	08f77d63          	bgeu	a4,a5,800054d2 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000543c:	100014b7          	lui	s1,0x10001
    80005440:	47a1                	li	a5,8
    80005442:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005444:	6609                	lui	a2,0x2
    80005446:	4581                	li	a1,0
    80005448:	00016517          	auipc	a0,0x16
    8000544c:	bb850513          	addi	a0,a0,-1096 # 8001b000 <disk>
    80005450:	ffffb097          	auipc	ra,0xffffb
    80005454:	d2a080e7          	jalr	-726(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005458:	00016717          	auipc	a4,0x16
    8000545c:	ba870713          	addi	a4,a4,-1112 # 8001b000 <disk>
    80005460:	00c75793          	srli	a5,a4,0xc
    80005464:	2781                	sext.w	a5,a5
    80005466:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005468:	00018797          	auipc	a5,0x18
    8000546c:	b9878793          	addi	a5,a5,-1128 # 8001d000 <disk+0x2000>
    80005470:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005472:	00016717          	auipc	a4,0x16
    80005476:	c0e70713          	addi	a4,a4,-1010 # 8001b080 <disk+0x80>
    8000547a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000547c:	00017717          	auipc	a4,0x17
    80005480:	b8470713          	addi	a4,a4,-1148 # 8001c000 <disk+0x1000>
    80005484:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005486:	4705                	li	a4,1
    80005488:	00e78c23          	sb	a4,24(a5)
    8000548c:	00e78ca3          	sb	a4,25(a5)
    80005490:	00e78d23          	sb	a4,26(a5)
    80005494:	00e78da3          	sb	a4,27(a5)
    80005498:	00e78e23          	sb	a4,28(a5)
    8000549c:	00e78ea3          	sb	a4,29(a5)
    800054a0:	00e78f23          	sb	a4,30(a5)
    800054a4:	00e78fa3          	sb	a4,31(a5)
}
    800054a8:	60e2                	ld	ra,24(sp)
    800054aa:	6442                	ld	s0,16(sp)
    800054ac:	64a2                	ld	s1,8(sp)
    800054ae:	6105                	addi	sp,sp,32
    800054b0:	8082                	ret
    panic("could not find virtio disk");
    800054b2:	00003517          	auipc	a0,0x3
    800054b6:	2ee50513          	addi	a0,a0,750 # 800087a0 <syscalls+0x3a0>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	896080e7          	jalr	-1898(ra) # 80005d50 <panic>
    panic("virtio disk has no queue 0");
    800054c2:	00003517          	auipc	a0,0x3
    800054c6:	2fe50513          	addi	a0,a0,766 # 800087c0 <syscalls+0x3c0>
    800054ca:	00001097          	auipc	ra,0x1
    800054ce:	886080e7          	jalr	-1914(ra) # 80005d50 <panic>
    panic("virtio disk max queue too short");
    800054d2:	00003517          	auipc	a0,0x3
    800054d6:	30e50513          	addi	a0,a0,782 # 800087e0 <syscalls+0x3e0>
    800054da:	00001097          	auipc	ra,0x1
    800054de:	876080e7          	jalr	-1930(ra) # 80005d50 <panic>

00000000800054e2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054e2:	7119                	addi	sp,sp,-128
    800054e4:	fc86                	sd	ra,120(sp)
    800054e6:	f8a2                	sd	s0,112(sp)
    800054e8:	f4a6                	sd	s1,104(sp)
    800054ea:	f0ca                	sd	s2,96(sp)
    800054ec:	ecce                	sd	s3,88(sp)
    800054ee:	e8d2                	sd	s4,80(sp)
    800054f0:	e4d6                	sd	s5,72(sp)
    800054f2:	e0da                	sd	s6,64(sp)
    800054f4:	fc5e                	sd	s7,56(sp)
    800054f6:	f862                	sd	s8,48(sp)
    800054f8:	f466                	sd	s9,40(sp)
    800054fa:	f06a                	sd	s10,32(sp)
    800054fc:	ec6e                	sd	s11,24(sp)
    800054fe:	0100                	addi	s0,sp,128
    80005500:	8aaa                	mv	s5,a0
    80005502:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005504:	00c52c83          	lw	s9,12(a0)
    80005508:	001c9c9b          	slliw	s9,s9,0x1
    8000550c:	1c82                	slli	s9,s9,0x20
    8000550e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005512:	00018517          	auipc	a0,0x18
    80005516:	c1650513          	addi	a0,a0,-1002 # 8001d128 <disk+0x2128>
    8000551a:	00001097          	auipc	ra,0x1
    8000551e:	d6e080e7          	jalr	-658(ra) # 80006288 <acquire>
  for(int i = 0; i < 3; i++){
    80005522:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005524:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005526:	00016c17          	auipc	s8,0x16
    8000552a:	adac0c13          	addi	s8,s8,-1318 # 8001b000 <disk>
    8000552e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005530:	4b0d                	li	s6,3
    80005532:	a0ad                	j	8000559c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005534:	00fc0733          	add	a4,s8,a5
    80005538:	975e                	add	a4,a4,s7
    8000553a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000553e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005540:	0207c563          	bltz	a5,8000556a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005544:	2905                	addiw	s2,s2,1
    80005546:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005548:	19690c63          	beq	s2,s6,800056e0 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000554c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000554e:	00018717          	auipc	a4,0x18
    80005552:	aca70713          	addi	a4,a4,-1334 # 8001d018 <disk+0x2018>
    80005556:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005558:	00074683          	lbu	a3,0(a4)
    8000555c:	fee1                	bnez	a3,80005534 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000555e:	2785                	addiw	a5,a5,1
    80005560:	0705                	addi	a4,a4,1
    80005562:	fe979be3          	bne	a5,s1,80005558 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005566:	57fd                	li	a5,-1
    80005568:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000556a:	01205d63          	blez	s2,80005584 <virtio_disk_rw+0xa2>
    8000556e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005570:	000a2503          	lw	a0,0(s4)
    80005574:	00000097          	auipc	ra,0x0
    80005578:	d92080e7          	jalr	-622(ra) # 80005306 <free_desc>
      for(int j = 0; j < i; j++)
    8000557c:	2d85                	addiw	s11,s11,1
    8000557e:	0a11                	addi	s4,s4,4
    80005580:	ff2d98e3          	bne	s11,s2,80005570 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005584:	00018597          	auipc	a1,0x18
    80005588:	ba458593          	addi	a1,a1,-1116 # 8001d128 <disk+0x2128>
    8000558c:	00018517          	auipc	a0,0x18
    80005590:	a8c50513          	addi	a0,a0,-1396 # 8001d018 <disk+0x2018>
    80005594:	ffffc097          	auipc	ra,0xffffc
    80005598:	130080e7          	jalr	304(ra) # 800016c4 <sleep>
  for(int i = 0; i < 3; i++){
    8000559c:	f8040a13          	addi	s4,s0,-128
{
    800055a0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800055a2:	894e                	mv	s2,s3
    800055a4:	b765                	j	8000554c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055a6:	00018697          	auipc	a3,0x18
    800055aa:	a5a6b683          	ld	a3,-1446(a3) # 8001d000 <disk+0x2000>
    800055ae:	96ba                	add	a3,a3,a4
    800055b0:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055b4:	00016817          	auipc	a6,0x16
    800055b8:	a4c80813          	addi	a6,a6,-1460 # 8001b000 <disk>
    800055bc:	00018697          	auipc	a3,0x18
    800055c0:	a4468693          	addi	a3,a3,-1468 # 8001d000 <disk+0x2000>
    800055c4:	6290                	ld	a2,0(a3)
    800055c6:	963a                	add	a2,a2,a4
    800055c8:	00c65583          	lhu	a1,12(a2)
    800055cc:	0015e593          	ori	a1,a1,1
    800055d0:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800055d4:	f8842603          	lw	a2,-120(s0)
    800055d8:	628c                	ld	a1,0(a3)
    800055da:	972e                	add	a4,a4,a1
    800055dc:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055e0:	20050593          	addi	a1,a0,512
    800055e4:	0592                	slli	a1,a1,0x4
    800055e6:	95c2                	add	a1,a1,a6
    800055e8:	577d                	li	a4,-1
    800055ea:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055ee:	00461713          	slli	a4,a2,0x4
    800055f2:	6290                	ld	a2,0(a3)
    800055f4:	963a                	add	a2,a2,a4
    800055f6:	03078793          	addi	a5,a5,48
    800055fa:	97c2                	add	a5,a5,a6
    800055fc:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800055fe:	629c                	ld	a5,0(a3)
    80005600:	97ba                	add	a5,a5,a4
    80005602:	4605                	li	a2,1
    80005604:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005606:	629c                	ld	a5,0(a3)
    80005608:	97ba                	add	a5,a5,a4
    8000560a:	4809                	li	a6,2
    8000560c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005610:	629c                	ld	a5,0(a3)
    80005612:	97ba                	add	a5,a5,a4
    80005614:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005618:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000561c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005620:	6698                	ld	a4,8(a3)
    80005622:	00275783          	lhu	a5,2(a4)
    80005626:	8b9d                	andi	a5,a5,7
    80005628:	0786                	slli	a5,a5,0x1
    8000562a:	973e                	add	a4,a4,a5
    8000562c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005630:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005634:	6698                	ld	a4,8(a3)
    80005636:	00275783          	lhu	a5,2(a4)
    8000563a:	2785                	addiw	a5,a5,1
    8000563c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005640:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005644:	100017b7          	lui	a5,0x10001
    80005648:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000564c:	004aa783          	lw	a5,4(s5)
    80005650:	02c79163          	bne	a5,a2,80005672 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005654:	00018917          	auipc	s2,0x18
    80005658:	ad490913          	addi	s2,s2,-1324 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    8000565c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000565e:	85ca                	mv	a1,s2
    80005660:	8556                	mv	a0,s5
    80005662:	ffffc097          	auipc	ra,0xffffc
    80005666:	062080e7          	jalr	98(ra) # 800016c4 <sleep>
  while(b->disk == 1) {
    8000566a:	004aa783          	lw	a5,4(s5)
    8000566e:	fe9788e3          	beq	a5,s1,8000565e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005672:	f8042903          	lw	s2,-128(s0)
    80005676:	20090713          	addi	a4,s2,512
    8000567a:	0712                	slli	a4,a4,0x4
    8000567c:	00016797          	auipc	a5,0x16
    80005680:	98478793          	addi	a5,a5,-1660 # 8001b000 <disk>
    80005684:	97ba                	add	a5,a5,a4
    80005686:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000568a:	00018997          	auipc	s3,0x18
    8000568e:	97698993          	addi	s3,s3,-1674 # 8001d000 <disk+0x2000>
    80005692:	00491713          	slli	a4,s2,0x4
    80005696:	0009b783          	ld	a5,0(s3)
    8000569a:	97ba                	add	a5,a5,a4
    8000569c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056a0:	854a                	mv	a0,s2
    800056a2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056a6:	00000097          	auipc	ra,0x0
    800056aa:	c60080e7          	jalr	-928(ra) # 80005306 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056ae:	8885                	andi	s1,s1,1
    800056b0:	f0ed                	bnez	s1,80005692 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056b2:	00018517          	auipc	a0,0x18
    800056b6:	a7650513          	addi	a0,a0,-1418 # 8001d128 <disk+0x2128>
    800056ba:	00001097          	auipc	ra,0x1
    800056be:	c82080e7          	jalr	-894(ra) # 8000633c <release>
}
    800056c2:	70e6                	ld	ra,120(sp)
    800056c4:	7446                	ld	s0,112(sp)
    800056c6:	74a6                	ld	s1,104(sp)
    800056c8:	7906                	ld	s2,96(sp)
    800056ca:	69e6                	ld	s3,88(sp)
    800056cc:	6a46                	ld	s4,80(sp)
    800056ce:	6aa6                	ld	s5,72(sp)
    800056d0:	6b06                	ld	s6,64(sp)
    800056d2:	7be2                	ld	s7,56(sp)
    800056d4:	7c42                	ld	s8,48(sp)
    800056d6:	7ca2                	ld	s9,40(sp)
    800056d8:	7d02                	ld	s10,32(sp)
    800056da:	6de2                	ld	s11,24(sp)
    800056dc:	6109                	addi	sp,sp,128
    800056de:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056e0:	f8042503          	lw	a0,-128(s0)
    800056e4:	20050793          	addi	a5,a0,512
    800056e8:	0792                	slli	a5,a5,0x4
  if(write)
    800056ea:	00016817          	auipc	a6,0x16
    800056ee:	91680813          	addi	a6,a6,-1770 # 8001b000 <disk>
    800056f2:	00f80733          	add	a4,a6,a5
    800056f6:	01a036b3          	snez	a3,s10
    800056fa:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800056fe:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005702:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005706:	7679                	lui	a2,0xffffe
    80005708:	963e                	add	a2,a2,a5
    8000570a:	00018697          	auipc	a3,0x18
    8000570e:	8f668693          	addi	a3,a3,-1802 # 8001d000 <disk+0x2000>
    80005712:	6298                	ld	a4,0(a3)
    80005714:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005716:	0a878593          	addi	a1,a5,168
    8000571a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000571c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000571e:	6298                	ld	a4,0(a3)
    80005720:	9732                	add	a4,a4,a2
    80005722:	45c1                	li	a1,16
    80005724:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005726:	6298                	ld	a4,0(a3)
    80005728:	9732                	add	a4,a4,a2
    8000572a:	4585                	li	a1,1
    8000572c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005730:	f8442703          	lw	a4,-124(s0)
    80005734:	628c                	ld	a1,0(a3)
    80005736:	962e                	add	a2,a2,a1
    80005738:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000573c:	0712                	slli	a4,a4,0x4
    8000573e:	6290                	ld	a2,0(a3)
    80005740:	963a                	add	a2,a2,a4
    80005742:	058a8593          	addi	a1,s5,88
    80005746:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005748:	6294                	ld	a3,0(a3)
    8000574a:	96ba                	add	a3,a3,a4
    8000574c:	40000613          	li	a2,1024
    80005750:	c690                	sw	a2,8(a3)
  if(write)
    80005752:	e40d1ae3          	bnez	s10,800055a6 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005756:	00018697          	auipc	a3,0x18
    8000575a:	8aa6b683          	ld	a3,-1878(a3) # 8001d000 <disk+0x2000>
    8000575e:	96ba                	add	a3,a3,a4
    80005760:	4609                	li	a2,2
    80005762:	00c69623          	sh	a2,12(a3)
    80005766:	b5b9                	j	800055b4 <virtio_disk_rw+0xd2>

0000000080005768 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005768:	1101                	addi	sp,sp,-32
    8000576a:	ec06                	sd	ra,24(sp)
    8000576c:	e822                	sd	s0,16(sp)
    8000576e:	e426                	sd	s1,8(sp)
    80005770:	e04a                	sd	s2,0(sp)
    80005772:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005774:	00018517          	auipc	a0,0x18
    80005778:	9b450513          	addi	a0,a0,-1612 # 8001d128 <disk+0x2128>
    8000577c:	00001097          	auipc	ra,0x1
    80005780:	b0c080e7          	jalr	-1268(ra) # 80006288 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005784:	10001737          	lui	a4,0x10001
    80005788:	533c                	lw	a5,96(a4)
    8000578a:	8b8d                	andi	a5,a5,3
    8000578c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000578e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005792:	00018797          	auipc	a5,0x18
    80005796:	86e78793          	addi	a5,a5,-1938 # 8001d000 <disk+0x2000>
    8000579a:	6b94                	ld	a3,16(a5)
    8000579c:	0207d703          	lhu	a4,32(a5)
    800057a0:	0026d783          	lhu	a5,2(a3)
    800057a4:	06f70163          	beq	a4,a5,80005806 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057a8:	00016917          	auipc	s2,0x16
    800057ac:	85890913          	addi	s2,s2,-1960 # 8001b000 <disk>
    800057b0:	00018497          	auipc	s1,0x18
    800057b4:	85048493          	addi	s1,s1,-1968 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800057b8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057bc:	6898                	ld	a4,16(s1)
    800057be:	0204d783          	lhu	a5,32(s1)
    800057c2:	8b9d                	andi	a5,a5,7
    800057c4:	078e                	slli	a5,a5,0x3
    800057c6:	97ba                	add	a5,a5,a4
    800057c8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057ca:	20078713          	addi	a4,a5,512
    800057ce:	0712                	slli	a4,a4,0x4
    800057d0:	974a                	add	a4,a4,s2
    800057d2:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800057d6:	e731                	bnez	a4,80005822 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057d8:	20078793          	addi	a5,a5,512
    800057dc:	0792                	slli	a5,a5,0x4
    800057de:	97ca                	add	a5,a5,s2
    800057e0:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057e2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057e6:	ffffc097          	auipc	ra,0xffffc
    800057ea:	06a080e7          	jalr	106(ra) # 80001850 <wakeup>

    disk.used_idx += 1;
    800057ee:	0204d783          	lhu	a5,32(s1)
    800057f2:	2785                	addiw	a5,a5,1
    800057f4:	17c2                	slli	a5,a5,0x30
    800057f6:	93c1                	srli	a5,a5,0x30
    800057f8:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057fc:	6898                	ld	a4,16(s1)
    800057fe:	00275703          	lhu	a4,2(a4)
    80005802:	faf71be3          	bne	a4,a5,800057b8 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005806:	00018517          	auipc	a0,0x18
    8000580a:	92250513          	addi	a0,a0,-1758 # 8001d128 <disk+0x2128>
    8000580e:	00001097          	auipc	ra,0x1
    80005812:	b2e080e7          	jalr	-1234(ra) # 8000633c <release>
}
    80005816:	60e2                	ld	ra,24(sp)
    80005818:	6442                	ld	s0,16(sp)
    8000581a:	64a2                	ld	s1,8(sp)
    8000581c:	6902                	ld	s2,0(sp)
    8000581e:	6105                	addi	sp,sp,32
    80005820:	8082                	ret
      panic("virtio_disk_intr status");
    80005822:	00003517          	auipc	a0,0x3
    80005826:	fde50513          	addi	a0,a0,-34 # 80008800 <syscalls+0x400>
    8000582a:	00000097          	auipc	ra,0x0
    8000582e:	526080e7          	jalr	1318(ra) # 80005d50 <panic>

0000000080005832 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005832:	1141                	addi	sp,sp,-16
    80005834:	e422                	sd	s0,8(sp)
    80005836:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005838:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000583c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005840:	0037979b          	slliw	a5,a5,0x3
    80005844:	02004737          	lui	a4,0x2004
    80005848:	97ba                	add	a5,a5,a4
    8000584a:	0200c737          	lui	a4,0x200c
    8000584e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005852:	000f4637          	lui	a2,0xf4
    80005856:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000585a:	9732                	add	a4,a4,a2
    8000585c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000585e:	00259693          	slli	a3,a1,0x2
    80005862:	96ae                	add	a3,a3,a1
    80005864:	068e                	slli	a3,a3,0x3
    80005866:	00018717          	auipc	a4,0x18
    8000586a:	79a70713          	addi	a4,a4,1946 # 8001e000 <timer_scratch>
    8000586e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005870:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005872:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005874:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005878:	00000797          	auipc	a5,0x0
    8000587c:	9c878793          	addi	a5,a5,-1592 # 80005240 <timervec>
    80005880:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005884:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005888:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000588c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005890:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005894:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005898:	30479073          	csrw	mie,a5
}
    8000589c:	6422                	ld	s0,8(sp)
    8000589e:	0141                	addi	sp,sp,16
    800058a0:	8082                	ret

00000000800058a2 <start>:
{
    800058a2:	1141                	addi	sp,sp,-16
    800058a4:	e406                	sd	ra,8(sp)
    800058a6:	e022                	sd	s0,0(sp)
    800058a8:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058aa:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058ae:	7779                	lui	a4,0xffffe
    800058b0:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800058b4:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058b6:	6705                	lui	a4,0x1
    800058b8:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058bc:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058be:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058c2:	ffffb797          	auipc	a5,0xffffb
    800058c6:	a5e78793          	addi	a5,a5,-1442 # 80000320 <main>
    800058ca:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058ce:	4781                	li	a5,0
    800058d0:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058d4:	67c1                	lui	a5,0x10
    800058d6:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800058d8:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058dc:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058e0:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058e4:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058e8:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058ec:	57fd                	li	a5,-1
    800058ee:	83a9                	srli	a5,a5,0xa
    800058f0:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058f4:	47bd                	li	a5,15
    800058f6:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058fa:	00000097          	auipc	ra,0x0
    800058fe:	f38080e7          	jalr	-200(ra) # 80005832 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005902:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005906:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005908:	823e                	mv	tp,a5
  asm volatile("mret");
    8000590a:	30200073          	mret
}
    8000590e:	60a2                	ld	ra,8(sp)
    80005910:	6402                	ld	s0,0(sp)
    80005912:	0141                	addi	sp,sp,16
    80005914:	8082                	ret

0000000080005916 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005916:	715d                	addi	sp,sp,-80
    80005918:	e486                	sd	ra,72(sp)
    8000591a:	e0a2                	sd	s0,64(sp)
    8000591c:	fc26                	sd	s1,56(sp)
    8000591e:	f84a                	sd	s2,48(sp)
    80005920:	f44e                	sd	s3,40(sp)
    80005922:	f052                	sd	s4,32(sp)
    80005924:	ec56                	sd	s5,24(sp)
    80005926:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005928:	04c05763          	blez	a2,80005976 <consolewrite+0x60>
    8000592c:	8a2a                	mv	s4,a0
    8000592e:	84ae                	mv	s1,a1
    80005930:	89b2                	mv	s3,a2
    80005932:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005934:	5afd                	li	s5,-1
    80005936:	4685                	li	a3,1
    80005938:	8626                	mv	a2,s1
    8000593a:	85d2                	mv	a1,s4
    8000593c:	fbf40513          	addi	a0,s0,-65
    80005940:	ffffc097          	auipc	ra,0xffffc
    80005944:	17e080e7          	jalr	382(ra) # 80001abe <either_copyin>
    80005948:	01550d63          	beq	a0,s5,80005962 <consolewrite+0x4c>
      break;
    uartputc(c);
    8000594c:	fbf44503          	lbu	a0,-65(s0)
    80005950:	00000097          	auipc	ra,0x0
    80005954:	77e080e7          	jalr	1918(ra) # 800060ce <uartputc>
  for(i = 0; i < n; i++){
    80005958:	2905                	addiw	s2,s2,1
    8000595a:	0485                	addi	s1,s1,1
    8000595c:	fd299de3          	bne	s3,s2,80005936 <consolewrite+0x20>
    80005960:	894e                	mv	s2,s3
  }

  return i;
}
    80005962:	854a                	mv	a0,s2
    80005964:	60a6                	ld	ra,72(sp)
    80005966:	6406                	ld	s0,64(sp)
    80005968:	74e2                	ld	s1,56(sp)
    8000596a:	7942                	ld	s2,48(sp)
    8000596c:	79a2                	ld	s3,40(sp)
    8000596e:	7a02                	ld	s4,32(sp)
    80005970:	6ae2                	ld	s5,24(sp)
    80005972:	6161                	addi	sp,sp,80
    80005974:	8082                	ret
  for(i = 0; i < n; i++){
    80005976:	4901                	li	s2,0
    80005978:	b7ed                	j	80005962 <consolewrite+0x4c>

000000008000597a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000597a:	7159                	addi	sp,sp,-112
    8000597c:	f486                	sd	ra,104(sp)
    8000597e:	f0a2                	sd	s0,96(sp)
    80005980:	eca6                	sd	s1,88(sp)
    80005982:	e8ca                	sd	s2,80(sp)
    80005984:	e4ce                	sd	s3,72(sp)
    80005986:	e0d2                	sd	s4,64(sp)
    80005988:	fc56                	sd	s5,56(sp)
    8000598a:	f85a                	sd	s6,48(sp)
    8000598c:	f45e                	sd	s7,40(sp)
    8000598e:	f062                	sd	s8,32(sp)
    80005990:	ec66                	sd	s9,24(sp)
    80005992:	e86a                	sd	s10,16(sp)
    80005994:	1880                	addi	s0,sp,112
    80005996:	8aaa                	mv	s5,a0
    80005998:	8a2e                	mv	s4,a1
    8000599a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000599c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059a0:	00020517          	auipc	a0,0x20
    800059a4:	7a050513          	addi	a0,a0,1952 # 80026140 <cons>
    800059a8:	00001097          	auipc	ra,0x1
    800059ac:	8e0080e7          	jalr	-1824(ra) # 80006288 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059b0:	00020497          	auipc	s1,0x20
    800059b4:	79048493          	addi	s1,s1,1936 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059b8:	00021917          	auipc	s2,0x21
    800059bc:	82090913          	addi	s2,s2,-2016 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800059c0:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059c2:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059c4:	4ca9                	li	s9,10
  while(n > 0){
    800059c6:	07305863          	blez	s3,80005a36 <consoleread+0xbc>
    while(cons.r == cons.w){
    800059ca:	0984a783          	lw	a5,152(s1)
    800059ce:	09c4a703          	lw	a4,156(s1)
    800059d2:	02f71463          	bne	a4,a5,800059fa <consoleread+0x80>
      if(myproc()->killed){
    800059d6:	ffffb097          	auipc	ra,0xffffb
    800059da:	5a0080e7          	jalr	1440(ra) # 80000f76 <myproc>
    800059de:	551c                	lw	a5,40(a0)
    800059e0:	e7b5                	bnez	a5,80005a4c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800059e2:	85a6                	mv	a1,s1
    800059e4:	854a                	mv	a0,s2
    800059e6:	ffffc097          	auipc	ra,0xffffc
    800059ea:	cde080e7          	jalr	-802(ra) # 800016c4 <sleep>
    while(cons.r == cons.w){
    800059ee:	0984a783          	lw	a5,152(s1)
    800059f2:	09c4a703          	lw	a4,156(s1)
    800059f6:	fef700e3          	beq	a4,a5,800059d6 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800059fa:	0017871b          	addiw	a4,a5,1
    800059fe:	08e4ac23          	sw	a4,152(s1)
    80005a02:	07f7f713          	andi	a4,a5,127
    80005a06:	9726                	add	a4,a4,s1
    80005a08:	01874703          	lbu	a4,24(a4)
    80005a0c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005a10:	077d0563          	beq	s10,s7,80005a7a <consoleread+0x100>
    cbuf = c;
    80005a14:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a18:	4685                	li	a3,1
    80005a1a:	f9f40613          	addi	a2,s0,-97
    80005a1e:	85d2                	mv	a1,s4
    80005a20:	8556                	mv	a0,s5
    80005a22:	ffffc097          	auipc	ra,0xffffc
    80005a26:	046080e7          	jalr	70(ra) # 80001a68 <either_copyout>
    80005a2a:	01850663          	beq	a0,s8,80005a36 <consoleread+0xbc>
    dst++;
    80005a2e:	0a05                	addi	s4,s4,1
    --n;
    80005a30:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005a32:	f99d1ae3          	bne	s10,s9,800059c6 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a36:	00020517          	auipc	a0,0x20
    80005a3a:	70a50513          	addi	a0,a0,1802 # 80026140 <cons>
    80005a3e:	00001097          	auipc	ra,0x1
    80005a42:	8fe080e7          	jalr	-1794(ra) # 8000633c <release>

  return target - n;
    80005a46:	413b053b          	subw	a0,s6,s3
    80005a4a:	a811                	j	80005a5e <consoleread+0xe4>
        release(&cons.lock);
    80005a4c:	00020517          	auipc	a0,0x20
    80005a50:	6f450513          	addi	a0,a0,1780 # 80026140 <cons>
    80005a54:	00001097          	auipc	ra,0x1
    80005a58:	8e8080e7          	jalr	-1816(ra) # 8000633c <release>
        return -1;
    80005a5c:	557d                	li	a0,-1
}
    80005a5e:	70a6                	ld	ra,104(sp)
    80005a60:	7406                	ld	s0,96(sp)
    80005a62:	64e6                	ld	s1,88(sp)
    80005a64:	6946                	ld	s2,80(sp)
    80005a66:	69a6                	ld	s3,72(sp)
    80005a68:	6a06                	ld	s4,64(sp)
    80005a6a:	7ae2                	ld	s5,56(sp)
    80005a6c:	7b42                	ld	s6,48(sp)
    80005a6e:	7ba2                	ld	s7,40(sp)
    80005a70:	7c02                	ld	s8,32(sp)
    80005a72:	6ce2                	ld	s9,24(sp)
    80005a74:	6d42                	ld	s10,16(sp)
    80005a76:	6165                	addi	sp,sp,112
    80005a78:	8082                	ret
      if(n < target){
    80005a7a:	0009871b          	sext.w	a4,s3
    80005a7e:	fb677ce3          	bgeu	a4,s6,80005a36 <consoleread+0xbc>
        cons.r--;
    80005a82:	00020717          	auipc	a4,0x20
    80005a86:	74f72b23          	sw	a5,1878(a4) # 800261d8 <cons+0x98>
    80005a8a:	b775                	j	80005a36 <consoleread+0xbc>

0000000080005a8c <consputc>:
{
    80005a8c:	1141                	addi	sp,sp,-16
    80005a8e:	e406                	sd	ra,8(sp)
    80005a90:	e022                	sd	s0,0(sp)
    80005a92:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a94:	10000793          	li	a5,256
    80005a98:	00f50a63          	beq	a0,a5,80005aac <consputc+0x20>
    uartputc_sync(c);
    80005a9c:	00000097          	auipc	ra,0x0
    80005aa0:	560080e7          	jalr	1376(ra) # 80005ffc <uartputc_sync>
}
    80005aa4:	60a2                	ld	ra,8(sp)
    80005aa6:	6402                	ld	s0,0(sp)
    80005aa8:	0141                	addi	sp,sp,16
    80005aaa:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005aac:	4521                	li	a0,8
    80005aae:	00000097          	auipc	ra,0x0
    80005ab2:	54e080e7          	jalr	1358(ra) # 80005ffc <uartputc_sync>
    80005ab6:	02000513          	li	a0,32
    80005aba:	00000097          	auipc	ra,0x0
    80005abe:	542080e7          	jalr	1346(ra) # 80005ffc <uartputc_sync>
    80005ac2:	4521                	li	a0,8
    80005ac4:	00000097          	auipc	ra,0x0
    80005ac8:	538080e7          	jalr	1336(ra) # 80005ffc <uartputc_sync>
    80005acc:	bfe1                	j	80005aa4 <consputc+0x18>

0000000080005ace <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ace:	1101                	addi	sp,sp,-32
    80005ad0:	ec06                	sd	ra,24(sp)
    80005ad2:	e822                	sd	s0,16(sp)
    80005ad4:	e426                	sd	s1,8(sp)
    80005ad6:	e04a                	sd	s2,0(sp)
    80005ad8:	1000                	addi	s0,sp,32
    80005ada:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005adc:	00020517          	auipc	a0,0x20
    80005ae0:	66450513          	addi	a0,a0,1636 # 80026140 <cons>
    80005ae4:	00000097          	auipc	ra,0x0
    80005ae8:	7a4080e7          	jalr	1956(ra) # 80006288 <acquire>

  switch(c){
    80005aec:	47d5                	li	a5,21
    80005aee:	0af48663          	beq	s1,a5,80005b9a <consoleintr+0xcc>
    80005af2:	0297ca63          	blt	a5,s1,80005b26 <consoleintr+0x58>
    80005af6:	47a1                	li	a5,8
    80005af8:	0ef48763          	beq	s1,a5,80005be6 <consoleintr+0x118>
    80005afc:	47c1                	li	a5,16
    80005afe:	10f49a63          	bne	s1,a5,80005c12 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b02:	ffffc097          	auipc	ra,0xffffc
    80005b06:	012080e7          	jalr	18(ra) # 80001b14 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b0a:	00020517          	auipc	a0,0x20
    80005b0e:	63650513          	addi	a0,a0,1590 # 80026140 <cons>
    80005b12:	00001097          	auipc	ra,0x1
    80005b16:	82a080e7          	jalr	-2006(ra) # 8000633c <release>
}
    80005b1a:	60e2                	ld	ra,24(sp)
    80005b1c:	6442                	ld	s0,16(sp)
    80005b1e:	64a2                	ld	s1,8(sp)
    80005b20:	6902                	ld	s2,0(sp)
    80005b22:	6105                	addi	sp,sp,32
    80005b24:	8082                	ret
  switch(c){
    80005b26:	07f00793          	li	a5,127
    80005b2a:	0af48e63          	beq	s1,a5,80005be6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b2e:	00020717          	auipc	a4,0x20
    80005b32:	61270713          	addi	a4,a4,1554 # 80026140 <cons>
    80005b36:	0a072783          	lw	a5,160(a4)
    80005b3a:	09872703          	lw	a4,152(a4)
    80005b3e:	9f99                	subw	a5,a5,a4
    80005b40:	07f00713          	li	a4,127
    80005b44:	fcf763e3          	bltu	a4,a5,80005b0a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b48:	47b5                	li	a5,13
    80005b4a:	0cf48763          	beq	s1,a5,80005c18 <consoleintr+0x14a>
      consputc(c);
    80005b4e:	8526                	mv	a0,s1
    80005b50:	00000097          	auipc	ra,0x0
    80005b54:	f3c080e7          	jalr	-196(ra) # 80005a8c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b58:	00020797          	auipc	a5,0x20
    80005b5c:	5e878793          	addi	a5,a5,1512 # 80026140 <cons>
    80005b60:	0a07a703          	lw	a4,160(a5)
    80005b64:	0017069b          	addiw	a3,a4,1
    80005b68:	0006861b          	sext.w	a2,a3
    80005b6c:	0ad7a023          	sw	a3,160(a5)
    80005b70:	07f77713          	andi	a4,a4,127
    80005b74:	97ba                	add	a5,a5,a4
    80005b76:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b7a:	47a9                	li	a5,10
    80005b7c:	0cf48563          	beq	s1,a5,80005c46 <consoleintr+0x178>
    80005b80:	4791                	li	a5,4
    80005b82:	0cf48263          	beq	s1,a5,80005c46 <consoleintr+0x178>
    80005b86:	00020797          	auipc	a5,0x20
    80005b8a:	6527a783          	lw	a5,1618(a5) # 800261d8 <cons+0x98>
    80005b8e:	0807879b          	addiw	a5,a5,128
    80005b92:	f6f61ce3          	bne	a2,a5,80005b0a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b96:	863e                	mv	a2,a5
    80005b98:	a07d                	j	80005c46 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b9a:	00020717          	auipc	a4,0x20
    80005b9e:	5a670713          	addi	a4,a4,1446 # 80026140 <cons>
    80005ba2:	0a072783          	lw	a5,160(a4)
    80005ba6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005baa:	00020497          	auipc	s1,0x20
    80005bae:	59648493          	addi	s1,s1,1430 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005bb2:	4929                	li	s2,10
    80005bb4:	f4f70be3          	beq	a4,a5,80005b0a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bb8:	37fd                	addiw	a5,a5,-1
    80005bba:	07f7f713          	andi	a4,a5,127
    80005bbe:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bc0:	01874703          	lbu	a4,24(a4)
    80005bc4:	f52703e3          	beq	a4,s2,80005b0a <consoleintr+0x3c>
      cons.e--;
    80005bc8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bcc:	10000513          	li	a0,256
    80005bd0:	00000097          	auipc	ra,0x0
    80005bd4:	ebc080e7          	jalr	-324(ra) # 80005a8c <consputc>
    while(cons.e != cons.w &&
    80005bd8:	0a04a783          	lw	a5,160(s1)
    80005bdc:	09c4a703          	lw	a4,156(s1)
    80005be0:	fcf71ce3          	bne	a4,a5,80005bb8 <consoleintr+0xea>
    80005be4:	b71d                	j	80005b0a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005be6:	00020717          	auipc	a4,0x20
    80005bea:	55a70713          	addi	a4,a4,1370 # 80026140 <cons>
    80005bee:	0a072783          	lw	a5,160(a4)
    80005bf2:	09c72703          	lw	a4,156(a4)
    80005bf6:	f0f70ae3          	beq	a4,a5,80005b0a <consoleintr+0x3c>
      cons.e--;
    80005bfa:	37fd                	addiw	a5,a5,-1
    80005bfc:	00020717          	auipc	a4,0x20
    80005c00:	5ef72223          	sw	a5,1508(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c04:	10000513          	li	a0,256
    80005c08:	00000097          	auipc	ra,0x0
    80005c0c:	e84080e7          	jalr	-380(ra) # 80005a8c <consputc>
    80005c10:	bded                	j	80005b0a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c12:	ee048ce3          	beqz	s1,80005b0a <consoleintr+0x3c>
    80005c16:	bf21                	j	80005b2e <consoleintr+0x60>
      consputc(c);
    80005c18:	4529                	li	a0,10
    80005c1a:	00000097          	auipc	ra,0x0
    80005c1e:	e72080e7          	jalr	-398(ra) # 80005a8c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c22:	00020797          	auipc	a5,0x20
    80005c26:	51e78793          	addi	a5,a5,1310 # 80026140 <cons>
    80005c2a:	0a07a703          	lw	a4,160(a5)
    80005c2e:	0017069b          	addiw	a3,a4,1
    80005c32:	0006861b          	sext.w	a2,a3
    80005c36:	0ad7a023          	sw	a3,160(a5)
    80005c3a:	07f77713          	andi	a4,a4,127
    80005c3e:	97ba                	add	a5,a5,a4
    80005c40:	4729                	li	a4,10
    80005c42:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c46:	00020797          	auipc	a5,0x20
    80005c4a:	58c7ab23          	sw	a2,1430(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005c4e:	00020517          	auipc	a0,0x20
    80005c52:	58a50513          	addi	a0,a0,1418 # 800261d8 <cons+0x98>
    80005c56:	ffffc097          	auipc	ra,0xffffc
    80005c5a:	bfa080e7          	jalr	-1030(ra) # 80001850 <wakeup>
    80005c5e:	b575                	j	80005b0a <consoleintr+0x3c>

0000000080005c60 <consoleinit>:

void
consoleinit(void)
{
    80005c60:	1141                	addi	sp,sp,-16
    80005c62:	e406                	sd	ra,8(sp)
    80005c64:	e022                	sd	s0,0(sp)
    80005c66:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c68:	00003597          	auipc	a1,0x3
    80005c6c:	bb058593          	addi	a1,a1,-1104 # 80008818 <syscalls+0x418>
    80005c70:	00020517          	auipc	a0,0x20
    80005c74:	4d050513          	addi	a0,a0,1232 # 80026140 <cons>
    80005c78:	00000097          	auipc	ra,0x0
    80005c7c:	580080e7          	jalr	1408(ra) # 800061f8 <initlock>

  uartinit();
    80005c80:	00000097          	auipc	ra,0x0
    80005c84:	32c080e7          	jalr	812(ra) # 80005fac <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c88:	00013797          	auipc	a5,0x13
    80005c8c:	64078793          	addi	a5,a5,1600 # 800192c8 <devsw>
    80005c90:	00000717          	auipc	a4,0x0
    80005c94:	cea70713          	addi	a4,a4,-790 # 8000597a <consoleread>
    80005c98:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c9a:	00000717          	auipc	a4,0x0
    80005c9e:	c7c70713          	addi	a4,a4,-900 # 80005916 <consolewrite>
    80005ca2:	ef98                	sd	a4,24(a5)
}
    80005ca4:	60a2                	ld	ra,8(sp)
    80005ca6:	6402                	ld	s0,0(sp)
    80005ca8:	0141                	addi	sp,sp,16
    80005caa:	8082                	ret

0000000080005cac <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cac:	7179                	addi	sp,sp,-48
    80005cae:	f406                	sd	ra,40(sp)
    80005cb0:	f022                	sd	s0,32(sp)
    80005cb2:	ec26                	sd	s1,24(sp)
    80005cb4:	e84a                	sd	s2,16(sp)
    80005cb6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cb8:	c219                	beqz	a2,80005cbe <printint+0x12>
    80005cba:	08054763          	bltz	a0,80005d48 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005cbe:	2501                	sext.w	a0,a0
    80005cc0:	4881                	li	a7,0
    80005cc2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cc6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cc8:	2581                	sext.w	a1,a1
    80005cca:	00003617          	auipc	a2,0x3
    80005cce:	b7e60613          	addi	a2,a2,-1154 # 80008848 <digits>
    80005cd2:	883a                	mv	a6,a4
    80005cd4:	2705                	addiw	a4,a4,1
    80005cd6:	02b577bb          	remuw	a5,a0,a1
    80005cda:	1782                	slli	a5,a5,0x20
    80005cdc:	9381                	srli	a5,a5,0x20
    80005cde:	97b2                	add	a5,a5,a2
    80005ce0:	0007c783          	lbu	a5,0(a5)
    80005ce4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ce8:	0005079b          	sext.w	a5,a0
    80005cec:	02b5553b          	divuw	a0,a0,a1
    80005cf0:	0685                	addi	a3,a3,1
    80005cf2:	feb7f0e3          	bgeu	a5,a1,80005cd2 <printint+0x26>

  if(sign)
    80005cf6:	00088c63          	beqz	a7,80005d0e <printint+0x62>
    buf[i++] = '-';
    80005cfa:	fe070793          	addi	a5,a4,-32
    80005cfe:	00878733          	add	a4,a5,s0
    80005d02:	02d00793          	li	a5,45
    80005d06:	fef70823          	sb	a5,-16(a4)
    80005d0a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d0e:	02e05763          	blez	a4,80005d3c <printint+0x90>
    80005d12:	fd040793          	addi	a5,s0,-48
    80005d16:	00e784b3          	add	s1,a5,a4
    80005d1a:	fff78913          	addi	s2,a5,-1
    80005d1e:	993a                	add	s2,s2,a4
    80005d20:	377d                	addiw	a4,a4,-1
    80005d22:	1702                	slli	a4,a4,0x20
    80005d24:	9301                	srli	a4,a4,0x20
    80005d26:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d2a:	fff4c503          	lbu	a0,-1(s1)
    80005d2e:	00000097          	auipc	ra,0x0
    80005d32:	d5e080e7          	jalr	-674(ra) # 80005a8c <consputc>
  while(--i >= 0)
    80005d36:	14fd                	addi	s1,s1,-1
    80005d38:	ff2499e3          	bne	s1,s2,80005d2a <printint+0x7e>
}
    80005d3c:	70a2                	ld	ra,40(sp)
    80005d3e:	7402                	ld	s0,32(sp)
    80005d40:	64e2                	ld	s1,24(sp)
    80005d42:	6942                	ld	s2,16(sp)
    80005d44:	6145                	addi	sp,sp,48
    80005d46:	8082                	ret
    x = -xx;
    80005d48:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d4c:	4885                	li	a7,1
    x = -xx;
    80005d4e:	bf95                	j	80005cc2 <printint+0x16>

0000000080005d50 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d50:	1101                	addi	sp,sp,-32
    80005d52:	ec06                	sd	ra,24(sp)
    80005d54:	e822                	sd	s0,16(sp)
    80005d56:	e426                	sd	s1,8(sp)
    80005d58:	1000                	addi	s0,sp,32
    80005d5a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d5c:	00020797          	auipc	a5,0x20
    80005d60:	4a07a223          	sw	zero,1188(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005d64:	00003517          	auipc	a0,0x3
    80005d68:	abc50513          	addi	a0,a0,-1348 # 80008820 <syscalls+0x420>
    80005d6c:	00000097          	auipc	ra,0x0
    80005d70:	02e080e7          	jalr	46(ra) # 80005d9a <printf>
  printf(s);
    80005d74:	8526                	mv	a0,s1
    80005d76:	00000097          	auipc	ra,0x0
    80005d7a:	024080e7          	jalr	36(ra) # 80005d9a <printf>
  printf("\n");
    80005d7e:	00002517          	auipc	a0,0x2
    80005d82:	2ca50513          	addi	a0,a0,714 # 80008048 <etext+0x48>
    80005d86:	00000097          	auipc	ra,0x0
    80005d8a:	014080e7          	jalr	20(ra) # 80005d9a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d8e:	4785                	li	a5,1
    80005d90:	00003717          	auipc	a4,0x3
    80005d94:	28f72623          	sw	a5,652(a4) # 8000901c <panicked>
  for(;;)
    80005d98:	a001                	j	80005d98 <panic+0x48>

0000000080005d9a <printf>:
{
    80005d9a:	7131                	addi	sp,sp,-192
    80005d9c:	fc86                	sd	ra,120(sp)
    80005d9e:	f8a2                	sd	s0,112(sp)
    80005da0:	f4a6                	sd	s1,104(sp)
    80005da2:	f0ca                	sd	s2,96(sp)
    80005da4:	ecce                	sd	s3,88(sp)
    80005da6:	e8d2                	sd	s4,80(sp)
    80005da8:	e4d6                	sd	s5,72(sp)
    80005daa:	e0da                	sd	s6,64(sp)
    80005dac:	fc5e                	sd	s7,56(sp)
    80005dae:	f862                	sd	s8,48(sp)
    80005db0:	f466                	sd	s9,40(sp)
    80005db2:	f06a                	sd	s10,32(sp)
    80005db4:	ec6e                	sd	s11,24(sp)
    80005db6:	0100                	addi	s0,sp,128
    80005db8:	8a2a                	mv	s4,a0
    80005dba:	e40c                	sd	a1,8(s0)
    80005dbc:	e810                	sd	a2,16(s0)
    80005dbe:	ec14                	sd	a3,24(s0)
    80005dc0:	f018                	sd	a4,32(s0)
    80005dc2:	f41c                	sd	a5,40(s0)
    80005dc4:	03043823          	sd	a6,48(s0)
    80005dc8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dcc:	00020d97          	auipc	s11,0x20
    80005dd0:	434dad83          	lw	s11,1076(s11) # 80026200 <pr+0x18>
  if(locking)
    80005dd4:	020d9b63          	bnez	s11,80005e0a <printf+0x70>
  if (fmt == 0)
    80005dd8:	040a0263          	beqz	s4,80005e1c <printf+0x82>
  va_start(ap, fmt);
    80005ddc:	00840793          	addi	a5,s0,8
    80005de0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005de4:	000a4503          	lbu	a0,0(s4)
    80005de8:	14050f63          	beqz	a0,80005f46 <printf+0x1ac>
    80005dec:	4981                	li	s3,0
    if(c != '%'){
    80005dee:	02500a93          	li	s5,37
    switch(c){
    80005df2:	07000b93          	li	s7,112
  consputc('x');
    80005df6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005df8:	00003b17          	auipc	s6,0x3
    80005dfc:	a50b0b13          	addi	s6,s6,-1456 # 80008848 <digits>
    switch(c){
    80005e00:	07300c93          	li	s9,115
    80005e04:	06400c13          	li	s8,100
    80005e08:	a82d                	j	80005e42 <printf+0xa8>
    acquire(&pr.lock);
    80005e0a:	00020517          	auipc	a0,0x20
    80005e0e:	3de50513          	addi	a0,a0,990 # 800261e8 <pr>
    80005e12:	00000097          	auipc	ra,0x0
    80005e16:	476080e7          	jalr	1142(ra) # 80006288 <acquire>
    80005e1a:	bf7d                	j	80005dd8 <printf+0x3e>
    panic("null fmt");
    80005e1c:	00003517          	auipc	a0,0x3
    80005e20:	a1450513          	addi	a0,a0,-1516 # 80008830 <syscalls+0x430>
    80005e24:	00000097          	auipc	ra,0x0
    80005e28:	f2c080e7          	jalr	-212(ra) # 80005d50 <panic>
      consputc(c);
    80005e2c:	00000097          	auipc	ra,0x0
    80005e30:	c60080e7          	jalr	-928(ra) # 80005a8c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e34:	2985                	addiw	s3,s3,1
    80005e36:	013a07b3          	add	a5,s4,s3
    80005e3a:	0007c503          	lbu	a0,0(a5)
    80005e3e:	10050463          	beqz	a0,80005f46 <printf+0x1ac>
    if(c != '%'){
    80005e42:	ff5515e3          	bne	a0,s5,80005e2c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e46:	2985                	addiw	s3,s3,1
    80005e48:	013a07b3          	add	a5,s4,s3
    80005e4c:	0007c783          	lbu	a5,0(a5)
    80005e50:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e54:	cbed                	beqz	a5,80005f46 <printf+0x1ac>
    switch(c){
    80005e56:	05778a63          	beq	a5,s7,80005eaa <printf+0x110>
    80005e5a:	02fbf663          	bgeu	s7,a5,80005e86 <printf+0xec>
    80005e5e:	09978863          	beq	a5,s9,80005eee <printf+0x154>
    80005e62:	07800713          	li	a4,120
    80005e66:	0ce79563          	bne	a5,a4,80005f30 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005e6a:	f8843783          	ld	a5,-120(s0)
    80005e6e:	00878713          	addi	a4,a5,8
    80005e72:	f8e43423          	sd	a4,-120(s0)
    80005e76:	4605                	li	a2,1
    80005e78:	85ea                	mv	a1,s10
    80005e7a:	4388                	lw	a0,0(a5)
    80005e7c:	00000097          	auipc	ra,0x0
    80005e80:	e30080e7          	jalr	-464(ra) # 80005cac <printint>
      break;
    80005e84:	bf45                	j	80005e34 <printf+0x9a>
    switch(c){
    80005e86:	09578f63          	beq	a5,s5,80005f24 <printf+0x18a>
    80005e8a:	0b879363          	bne	a5,s8,80005f30 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005e8e:	f8843783          	ld	a5,-120(s0)
    80005e92:	00878713          	addi	a4,a5,8
    80005e96:	f8e43423          	sd	a4,-120(s0)
    80005e9a:	4605                	li	a2,1
    80005e9c:	45a9                	li	a1,10
    80005e9e:	4388                	lw	a0,0(a5)
    80005ea0:	00000097          	auipc	ra,0x0
    80005ea4:	e0c080e7          	jalr	-500(ra) # 80005cac <printint>
      break;
    80005ea8:	b771                	j	80005e34 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005eaa:	f8843783          	ld	a5,-120(s0)
    80005eae:	00878713          	addi	a4,a5,8
    80005eb2:	f8e43423          	sd	a4,-120(s0)
    80005eb6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005eba:	03000513          	li	a0,48
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	bce080e7          	jalr	-1074(ra) # 80005a8c <consputc>
  consputc('x');
    80005ec6:	07800513          	li	a0,120
    80005eca:	00000097          	auipc	ra,0x0
    80005ece:	bc2080e7          	jalr	-1086(ra) # 80005a8c <consputc>
    80005ed2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ed4:	03c95793          	srli	a5,s2,0x3c
    80005ed8:	97da                	add	a5,a5,s6
    80005eda:	0007c503          	lbu	a0,0(a5)
    80005ede:	00000097          	auipc	ra,0x0
    80005ee2:	bae080e7          	jalr	-1106(ra) # 80005a8c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ee6:	0912                	slli	s2,s2,0x4
    80005ee8:	34fd                	addiw	s1,s1,-1
    80005eea:	f4ed                	bnez	s1,80005ed4 <printf+0x13a>
    80005eec:	b7a1                	j	80005e34 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005eee:	f8843783          	ld	a5,-120(s0)
    80005ef2:	00878713          	addi	a4,a5,8
    80005ef6:	f8e43423          	sd	a4,-120(s0)
    80005efa:	6384                	ld	s1,0(a5)
    80005efc:	cc89                	beqz	s1,80005f16 <printf+0x17c>
      for(; *s; s++)
    80005efe:	0004c503          	lbu	a0,0(s1)
    80005f02:	d90d                	beqz	a0,80005e34 <printf+0x9a>
        consputc(*s);
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	b88080e7          	jalr	-1144(ra) # 80005a8c <consputc>
      for(; *s; s++)
    80005f0c:	0485                	addi	s1,s1,1
    80005f0e:	0004c503          	lbu	a0,0(s1)
    80005f12:	f96d                	bnez	a0,80005f04 <printf+0x16a>
    80005f14:	b705                	j	80005e34 <printf+0x9a>
        s = "(null)";
    80005f16:	00003497          	auipc	s1,0x3
    80005f1a:	91248493          	addi	s1,s1,-1774 # 80008828 <syscalls+0x428>
      for(; *s; s++)
    80005f1e:	02800513          	li	a0,40
    80005f22:	b7cd                	j	80005f04 <printf+0x16a>
      consputc('%');
    80005f24:	8556                	mv	a0,s5
    80005f26:	00000097          	auipc	ra,0x0
    80005f2a:	b66080e7          	jalr	-1178(ra) # 80005a8c <consputc>
      break;
    80005f2e:	b719                	j	80005e34 <printf+0x9a>
      consputc('%');
    80005f30:	8556                	mv	a0,s5
    80005f32:	00000097          	auipc	ra,0x0
    80005f36:	b5a080e7          	jalr	-1190(ra) # 80005a8c <consputc>
      consputc(c);
    80005f3a:	8526                	mv	a0,s1
    80005f3c:	00000097          	auipc	ra,0x0
    80005f40:	b50080e7          	jalr	-1200(ra) # 80005a8c <consputc>
      break;
    80005f44:	bdc5                	j	80005e34 <printf+0x9a>
  if(locking)
    80005f46:	020d9163          	bnez	s11,80005f68 <printf+0x1ce>
}
    80005f4a:	70e6                	ld	ra,120(sp)
    80005f4c:	7446                	ld	s0,112(sp)
    80005f4e:	74a6                	ld	s1,104(sp)
    80005f50:	7906                	ld	s2,96(sp)
    80005f52:	69e6                	ld	s3,88(sp)
    80005f54:	6a46                	ld	s4,80(sp)
    80005f56:	6aa6                	ld	s5,72(sp)
    80005f58:	6b06                	ld	s6,64(sp)
    80005f5a:	7be2                	ld	s7,56(sp)
    80005f5c:	7c42                	ld	s8,48(sp)
    80005f5e:	7ca2                	ld	s9,40(sp)
    80005f60:	7d02                	ld	s10,32(sp)
    80005f62:	6de2                	ld	s11,24(sp)
    80005f64:	6129                	addi	sp,sp,192
    80005f66:	8082                	ret
    release(&pr.lock);
    80005f68:	00020517          	auipc	a0,0x20
    80005f6c:	28050513          	addi	a0,a0,640 # 800261e8 <pr>
    80005f70:	00000097          	auipc	ra,0x0
    80005f74:	3cc080e7          	jalr	972(ra) # 8000633c <release>
}
    80005f78:	bfc9                	j	80005f4a <printf+0x1b0>

0000000080005f7a <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f7a:	1101                	addi	sp,sp,-32
    80005f7c:	ec06                	sd	ra,24(sp)
    80005f7e:	e822                	sd	s0,16(sp)
    80005f80:	e426                	sd	s1,8(sp)
    80005f82:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f84:	00020497          	auipc	s1,0x20
    80005f88:	26448493          	addi	s1,s1,612 # 800261e8 <pr>
    80005f8c:	00003597          	auipc	a1,0x3
    80005f90:	8b458593          	addi	a1,a1,-1868 # 80008840 <syscalls+0x440>
    80005f94:	8526                	mv	a0,s1
    80005f96:	00000097          	auipc	ra,0x0
    80005f9a:	262080e7          	jalr	610(ra) # 800061f8 <initlock>
  pr.locking = 1;
    80005f9e:	4785                	li	a5,1
    80005fa0:	cc9c                	sw	a5,24(s1)
}
    80005fa2:	60e2                	ld	ra,24(sp)
    80005fa4:	6442                	ld	s0,16(sp)
    80005fa6:	64a2                	ld	s1,8(sp)
    80005fa8:	6105                	addi	sp,sp,32
    80005faa:	8082                	ret

0000000080005fac <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fac:	1141                	addi	sp,sp,-16
    80005fae:	e406                	sd	ra,8(sp)
    80005fb0:	e022                	sd	s0,0(sp)
    80005fb2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fb4:	100007b7          	lui	a5,0x10000
    80005fb8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fbc:	f8000713          	li	a4,-128
    80005fc0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fc4:	470d                	li	a4,3
    80005fc6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fca:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fce:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fd2:	469d                	li	a3,7
    80005fd4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fd8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fdc:	00003597          	auipc	a1,0x3
    80005fe0:	88458593          	addi	a1,a1,-1916 # 80008860 <digits+0x18>
    80005fe4:	00020517          	auipc	a0,0x20
    80005fe8:	22450513          	addi	a0,a0,548 # 80026208 <uart_tx_lock>
    80005fec:	00000097          	auipc	ra,0x0
    80005ff0:	20c080e7          	jalr	524(ra) # 800061f8 <initlock>
}
    80005ff4:	60a2                	ld	ra,8(sp)
    80005ff6:	6402                	ld	s0,0(sp)
    80005ff8:	0141                	addi	sp,sp,16
    80005ffa:	8082                	ret

0000000080005ffc <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005ffc:	1101                	addi	sp,sp,-32
    80005ffe:	ec06                	sd	ra,24(sp)
    80006000:	e822                	sd	s0,16(sp)
    80006002:	e426                	sd	s1,8(sp)
    80006004:	1000                	addi	s0,sp,32
    80006006:	84aa                	mv	s1,a0
  push_off();
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	234080e7          	jalr	564(ra) # 8000623c <push_off>

  if(panicked){
    80006010:	00003797          	auipc	a5,0x3
    80006014:	00c7a783          	lw	a5,12(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006018:	10000737          	lui	a4,0x10000
  if(panicked){
    8000601c:	c391                	beqz	a5,80006020 <uartputc_sync+0x24>
    for(;;)
    8000601e:	a001                	j	8000601e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006020:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006024:	0207f793          	andi	a5,a5,32
    80006028:	dfe5                	beqz	a5,80006020 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000602a:	0ff4f513          	zext.b	a0,s1
    8000602e:	100007b7          	lui	a5,0x10000
    80006032:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006036:	00000097          	auipc	ra,0x0
    8000603a:	2a6080e7          	jalr	678(ra) # 800062dc <pop_off>
}
    8000603e:	60e2                	ld	ra,24(sp)
    80006040:	6442                	ld	s0,16(sp)
    80006042:	64a2                	ld	s1,8(sp)
    80006044:	6105                	addi	sp,sp,32
    80006046:	8082                	ret

0000000080006048 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006048:	00003797          	auipc	a5,0x3
    8000604c:	fd87b783          	ld	a5,-40(a5) # 80009020 <uart_tx_r>
    80006050:	00003717          	auipc	a4,0x3
    80006054:	fd873703          	ld	a4,-40(a4) # 80009028 <uart_tx_w>
    80006058:	06f70a63          	beq	a4,a5,800060cc <uartstart+0x84>
{
    8000605c:	7139                	addi	sp,sp,-64
    8000605e:	fc06                	sd	ra,56(sp)
    80006060:	f822                	sd	s0,48(sp)
    80006062:	f426                	sd	s1,40(sp)
    80006064:	f04a                	sd	s2,32(sp)
    80006066:	ec4e                	sd	s3,24(sp)
    80006068:	e852                	sd	s4,16(sp)
    8000606a:	e456                	sd	s5,8(sp)
    8000606c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000606e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006072:	00020a17          	auipc	s4,0x20
    80006076:	196a0a13          	addi	s4,s4,406 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    8000607a:	00003497          	auipc	s1,0x3
    8000607e:	fa648493          	addi	s1,s1,-90 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006082:	00003997          	auipc	s3,0x3
    80006086:	fa698993          	addi	s3,s3,-90 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000608a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000608e:	02077713          	andi	a4,a4,32
    80006092:	c705                	beqz	a4,800060ba <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006094:	01f7f713          	andi	a4,a5,31
    80006098:	9752                	add	a4,a4,s4
    8000609a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000609e:	0785                	addi	a5,a5,1
    800060a0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060a2:	8526                	mv	a0,s1
    800060a4:	ffffb097          	auipc	ra,0xffffb
    800060a8:	7ac080e7          	jalr	1964(ra) # 80001850 <wakeup>
    
    WriteReg(THR, c);
    800060ac:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060b0:	609c                	ld	a5,0(s1)
    800060b2:	0009b703          	ld	a4,0(s3)
    800060b6:	fcf71ae3          	bne	a4,a5,8000608a <uartstart+0x42>
  }
}
    800060ba:	70e2                	ld	ra,56(sp)
    800060bc:	7442                	ld	s0,48(sp)
    800060be:	74a2                	ld	s1,40(sp)
    800060c0:	7902                	ld	s2,32(sp)
    800060c2:	69e2                	ld	s3,24(sp)
    800060c4:	6a42                	ld	s4,16(sp)
    800060c6:	6aa2                	ld	s5,8(sp)
    800060c8:	6121                	addi	sp,sp,64
    800060ca:	8082                	ret
    800060cc:	8082                	ret

00000000800060ce <uartputc>:
{
    800060ce:	7179                	addi	sp,sp,-48
    800060d0:	f406                	sd	ra,40(sp)
    800060d2:	f022                	sd	s0,32(sp)
    800060d4:	ec26                	sd	s1,24(sp)
    800060d6:	e84a                	sd	s2,16(sp)
    800060d8:	e44e                	sd	s3,8(sp)
    800060da:	e052                	sd	s4,0(sp)
    800060dc:	1800                	addi	s0,sp,48
    800060de:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800060e0:	00020517          	auipc	a0,0x20
    800060e4:	12850513          	addi	a0,a0,296 # 80026208 <uart_tx_lock>
    800060e8:	00000097          	auipc	ra,0x0
    800060ec:	1a0080e7          	jalr	416(ra) # 80006288 <acquire>
  if(panicked){
    800060f0:	00003797          	auipc	a5,0x3
    800060f4:	f2c7a783          	lw	a5,-212(a5) # 8000901c <panicked>
    800060f8:	c391                	beqz	a5,800060fc <uartputc+0x2e>
    for(;;)
    800060fa:	a001                	j	800060fa <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060fc:	00003717          	auipc	a4,0x3
    80006100:	f2c73703          	ld	a4,-212(a4) # 80009028 <uart_tx_w>
    80006104:	00003797          	auipc	a5,0x3
    80006108:	f1c7b783          	ld	a5,-228(a5) # 80009020 <uart_tx_r>
    8000610c:	02078793          	addi	a5,a5,32
    80006110:	02e79b63          	bne	a5,a4,80006146 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006114:	00020997          	auipc	s3,0x20
    80006118:	0f498993          	addi	s3,s3,244 # 80026208 <uart_tx_lock>
    8000611c:	00003497          	auipc	s1,0x3
    80006120:	f0448493          	addi	s1,s1,-252 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006124:	00003917          	auipc	s2,0x3
    80006128:	f0490913          	addi	s2,s2,-252 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000612c:	85ce                	mv	a1,s3
    8000612e:	8526                	mv	a0,s1
    80006130:	ffffb097          	auipc	ra,0xffffb
    80006134:	594080e7          	jalr	1428(ra) # 800016c4 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006138:	00093703          	ld	a4,0(s2)
    8000613c:	609c                	ld	a5,0(s1)
    8000613e:	02078793          	addi	a5,a5,32
    80006142:	fee785e3          	beq	a5,a4,8000612c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006146:	00020497          	auipc	s1,0x20
    8000614a:	0c248493          	addi	s1,s1,194 # 80026208 <uart_tx_lock>
    8000614e:	01f77793          	andi	a5,a4,31
    80006152:	97a6                	add	a5,a5,s1
    80006154:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006158:	0705                	addi	a4,a4,1
    8000615a:	00003797          	auipc	a5,0x3
    8000615e:	ece7b723          	sd	a4,-306(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006162:	00000097          	auipc	ra,0x0
    80006166:	ee6080e7          	jalr	-282(ra) # 80006048 <uartstart>
      release(&uart_tx_lock);
    8000616a:	8526                	mv	a0,s1
    8000616c:	00000097          	auipc	ra,0x0
    80006170:	1d0080e7          	jalr	464(ra) # 8000633c <release>
}
    80006174:	70a2                	ld	ra,40(sp)
    80006176:	7402                	ld	s0,32(sp)
    80006178:	64e2                	ld	s1,24(sp)
    8000617a:	6942                	ld	s2,16(sp)
    8000617c:	69a2                	ld	s3,8(sp)
    8000617e:	6a02                	ld	s4,0(sp)
    80006180:	6145                	addi	sp,sp,48
    80006182:	8082                	ret

0000000080006184 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006184:	1141                	addi	sp,sp,-16
    80006186:	e422                	sd	s0,8(sp)
    80006188:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000618a:	100007b7          	lui	a5,0x10000
    8000618e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006192:	8b85                	andi	a5,a5,1
    80006194:	cb81                	beqz	a5,800061a4 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006196:	100007b7          	lui	a5,0x10000
    8000619a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000619e:	6422                	ld	s0,8(sp)
    800061a0:	0141                	addi	sp,sp,16
    800061a2:	8082                	ret
    return -1;
    800061a4:	557d                	li	a0,-1
    800061a6:	bfe5                	j	8000619e <uartgetc+0x1a>

00000000800061a8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800061a8:	1101                	addi	sp,sp,-32
    800061aa:	ec06                	sd	ra,24(sp)
    800061ac:	e822                	sd	s0,16(sp)
    800061ae:	e426                	sd	s1,8(sp)
    800061b0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061b2:	54fd                	li	s1,-1
    800061b4:	a029                	j	800061be <uartintr+0x16>
      break;
    consoleintr(c);
    800061b6:	00000097          	auipc	ra,0x0
    800061ba:	918080e7          	jalr	-1768(ra) # 80005ace <consoleintr>
    int c = uartgetc();
    800061be:	00000097          	auipc	ra,0x0
    800061c2:	fc6080e7          	jalr	-58(ra) # 80006184 <uartgetc>
    if(c == -1)
    800061c6:	fe9518e3          	bne	a0,s1,800061b6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061ca:	00020497          	auipc	s1,0x20
    800061ce:	03e48493          	addi	s1,s1,62 # 80026208 <uart_tx_lock>
    800061d2:	8526                	mv	a0,s1
    800061d4:	00000097          	auipc	ra,0x0
    800061d8:	0b4080e7          	jalr	180(ra) # 80006288 <acquire>
  uartstart();
    800061dc:	00000097          	auipc	ra,0x0
    800061e0:	e6c080e7          	jalr	-404(ra) # 80006048 <uartstart>
  release(&uart_tx_lock);
    800061e4:	8526                	mv	a0,s1
    800061e6:	00000097          	auipc	ra,0x0
    800061ea:	156080e7          	jalr	342(ra) # 8000633c <release>
}
    800061ee:	60e2                	ld	ra,24(sp)
    800061f0:	6442                	ld	s0,16(sp)
    800061f2:	64a2                	ld	s1,8(sp)
    800061f4:	6105                	addi	sp,sp,32
    800061f6:	8082                	ret

00000000800061f8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061f8:	1141                	addi	sp,sp,-16
    800061fa:	e422                	sd	s0,8(sp)
    800061fc:	0800                	addi	s0,sp,16
  lk->name = name;
    800061fe:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006200:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006204:	00053823          	sd	zero,16(a0)
}
    80006208:	6422                	ld	s0,8(sp)
    8000620a:	0141                	addi	sp,sp,16
    8000620c:	8082                	ret

000000008000620e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000620e:	411c                	lw	a5,0(a0)
    80006210:	e399                	bnez	a5,80006216 <holding+0x8>
    80006212:	4501                	li	a0,0
  return r;
}
    80006214:	8082                	ret
{
    80006216:	1101                	addi	sp,sp,-32
    80006218:	ec06                	sd	ra,24(sp)
    8000621a:	e822                	sd	s0,16(sp)
    8000621c:	e426                	sd	s1,8(sp)
    8000621e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006220:	6904                	ld	s1,16(a0)
    80006222:	ffffb097          	auipc	ra,0xffffb
    80006226:	d38080e7          	jalr	-712(ra) # 80000f5a <mycpu>
    8000622a:	40a48533          	sub	a0,s1,a0
    8000622e:	00153513          	seqz	a0,a0
}
    80006232:	60e2                	ld	ra,24(sp)
    80006234:	6442                	ld	s0,16(sp)
    80006236:	64a2                	ld	s1,8(sp)
    80006238:	6105                	addi	sp,sp,32
    8000623a:	8082                	ret

000000008000623c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000623c:	1101                	addi	sp,sp,-32
    8000623e:	ec06                	sd	ra,24(sp)
    80006240:	e822                	sd	s0,16(sp)
    80006242:	e426                	sd	s1,8(sp)
    80006244:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006246:	100024f3          	csrr	s1,sstatus
    8000624a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000624e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006250:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006254:	ffffb097          	auipc	ra,0xffffb
    80006258:	d06080e7          	jalr	-762(ra) # 80000f5a <mycpu>
    8000625c:	5d3c                	lw	a5,120(a0)
    8000625e:	cf89                	beqz	a5,80006278 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006260:	ffffb097          	auipc	ra,0xffffb
    80006264:	cfa080e7          	jalr	-774(ra) # 80000f5a <mycpu>
    80006268:	5d3c                	lw	a5,120(a0)
    8000626a:	2785                	addiw	a5,a5,1
    8000626c:	dd3c                	sw	a5,120(a0)
}
    8000626e:	60e2                	ld	ra,24(sp)
    80006270:	6442                	ld	s0,16(sp)
    80006272:	64a2                	ld	s1,8(sp)
    80006274:	6105                	addi	sp,sp,32
    80006276:	8082                	ret
    mycpu()->intena = old;
    80006278:	ffffb097          	auipc	ra,0xffffb
    8000627c:	ce2080e7          	jalr	-798(ra) # 80000f5a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006280:	8085                	srli	s1,s1,0x1
    80006282:	8885                	andi	s1,s1,1
    80006284:	dd64                	sw	s1,124(a0)
    80006286:	bfe9                	j	80006260 <push_off+0x24>

0000000080006288 <acquire>:
{
    80006288:	1101                	addi	sp,sp,-32
    8000628a:	ec06                	sd	ra,24(sp)
    8000628c:	e822                	sd	s0,16(sp)
    8000628e:	e426                	sd	s1,8(sp)
    80006290:	1000                	addi	s0,sp,32
    80006292:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006294:	00000097          	auipc	ra,0x0
    80006298:	fa8080e7          	jalr	-88(ra) # 8000623c <push_off>
  if(holding(lk))
    8000629c:	8526                	mv	a0,s1
    8000629e:	00000097          	auipc	ra,0x0
    800062a2:	f70080e7          	jalr	-144(ra) # 8000620e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062a6:	4705                	li	a4,1
  if(holding(lk))
    800062a8:	e115                	bnez	a0,800062cc <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062aa:	87ba                	mv	a5,a4
    800062ac:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062b0:	2781                	sext.w	a5,a5
    800062b2:	ffe5                	bnez	a5,800062aa <acquire+0x22>
  __sync_synchronize();
    800062b4:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062b8:	ffffb097          	auipc	ra,0xffffb
    800062bc:	ca2080e7          	jalr	-862(ra) # 80000f5a <mycpu>
    800062c0:	e888                	sd	a0,16(s1)
}
    800062c2:	60e2                	ld	ra,24(sp)
    800062c4:	6442                	ld	s0,16(sp)
    800062c6:	64a2                	ld	s1,8(sp)
    800062c8:	6105                	addi	sp,sp,32
    800062ca:	8082                	ret
    panic("acquire");
    800062cc:	00002517          	auipc	a0,0x2
    800062d0:	59c50513          	addi	a0,a0,1436 # 80008868 <digits+0x20>
    800062d4:	00000097          	auipc	ra,0x0
    800062d8:	a7c080e7          	jalr	-1412(ra) # 80005d50 <panic>

00000000800062dc <pop_off>:

void
pop_off(void)
{
    800062dc:	1141                	addi	sp,sp,-16
    800062de:	e406                	sd	ra,8(sp)
    800062e0:	e022                	sd	s0,0(sp)
    800062e2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062e4:	ffffb097          	auipc	ra,0xffffb
    800062e8:	c76080e7          	jalr	-906(ra) # 80000f5a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062ec:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062f0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062f2:	e78d                	bnez	a5,8000631c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062f4:	5d3c                	lw	a5,120(a0)
    800062f6:	02f05b63          	blez	a5,8000632c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062fa:	37fd                	addiw	a5,a5,-1
    800062fc:	0007871b          	sext.w	a4,a5
    80006300:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006302:	eb09                	bnez	a4,80006314 <pop_off+0x38>
    80006304:	5d7c                	lw	a5,124(a0)
    80006306:	c799                	beqz	a5,80006314 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006308:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000630c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006310:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006314:	60a2                	ld	ra,8(sp)
    80006316:	6402                	ld	s0,0(sp)
    80006318:	0141                	addi	sp,sp,16
    8000631a:	8082                	ret
    panic("pop_off - interruptible");
    8000631c:	00002517          	auipc	a0,0x2
    80006320:	55450513          	addi	a0,a0,1364 # 80008870 <digits+0x28>
    80006324:	00000097          	auipc	ra,0x0
    80006328:	a2c080e7          	jalr	-1492(ra) # 80005d50 <panic>
    panic("pop_off");
    8000632c:	00002517          	auipc	a0,0x2
    80006330:	55c50513          	addi	a0,a0,1372 # 80008888 <digits+0x40>
    80006334:	00000097          	auipc	ra,0x0
    80006338:	a1c080e7          	jalr	-1508(ra) # 80005d50 <panic>

000000008000633c <release>:
{
    8000633c:	1101                	addi	sp,sp,-32
    8000633e:	ec06                	sd	ra,24(sp)
    80006340:	e822                	sd	s0,16(sp)
    80006342:	e426                	sd	s1,8(sp)
    80006344:	1000                	addi	s0,sp,32
    80006346:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006348:	00000097          	auipc	ra,0x0
    8000634c:	ec6080e7          	jalr	-314(ra) # 8000620e <holding>
    80006350:	c115                	beqz	a0,80006374 <release+0x38>
  lk->cpu = 0;
    80006352:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006356:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000635a:	0f50000f          	fence	iorw,ow
    8000635e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006362:	00000097          	auipc	ra,0x0
    80006366:	f7a080e7          	jalr	-134(ra) # 800062dc <pop_off>
}
    8000636a:	60e2                	ld	ra,24(sp)
    8000636c:	6442                	ld	s0,16(sp)
    8000636e:	64a2                	ld	s1,8(sp)
    80006370:	6105                	addi	sp,sp,32
    80006372:	8082                	ret
    panic("release");
    80006374:	00002517          	auipc	a0,0x2
    80006378:	51c50513          	addi	a0,a0,1308 # 80008890 <digits+0x48>
    8000637c:	00000097          	auipc	ra,0x0
    80006380:	9d4080e7          	jalr	-1580(ra) # 80005d50 <panic>
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
