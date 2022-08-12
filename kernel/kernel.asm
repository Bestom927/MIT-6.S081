
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	89013103          	ld	sp,-1904(sp) # 80008890 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	18c080e7          	jalr	396(ra) # 800061e6 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	22c080e7          	jalr	556(ra) # 8000629a <release>
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
    800000fa:	060080e7          	jalr	96(ra) # 80006156 <initlock>
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
    80000132:	0b8080e7          	jalr	184(ra) # 800061e6 <acquire>
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
    8000014a:	154080e7          	jalr	340(ra) # 8000629a <release>

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
    80000174:	12a080e7          	jalr	298(ra) # 8000629a <release>
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
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	924080e7          	jalr	-1756(ra) # 80005c7a <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	778080e7          	jalr	1912(ra) # 80001ade <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	df2080e7          	jalr	-526(ra) # 80005160 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	024080e7          	jalr	36(ra) # 8000139a <scheduler>
    consoleinit();
    8000037e:	00005097          	auipc	ra,0x5
    80000382:	7c2080e7          	jalr	1986(ra) # 80005b40 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	ad4080e7          	jalr	-1324(ra) # 80005e5a <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	8e4080e7          	jalr	-1820(ra) # 80005c7a <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	8d4080e7          	jalr	-1836(ra) # 80005c7a <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	8c4080e7          	jalr	-1852(ra) # 80005c7a <printf>
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
    800003e2:	6d8080e7          	jalr	1752(ra) # 80001ab6 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	6f8080e7          	jalr	1784(ra) # 80001ade <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	d5c080e7          	jalr	-676(ra) # 8000514a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	d6a080e7          	jalr	-662(ra) # 80005160 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	f26080e7          	jalr	-218(ra) # 80002324 <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	5b4080e7          	jalr	1460(ra) # 800029ba <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	566080e7          	jalr	1382(ra) # 80003974 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	e6a080e7          	jalr	-406(ra) # 80005280 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	d42080e7          	jalr	-702(ra) # 80001160 <userinit>
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
    8000048c:	7a8080e7          	jalr	1960(ra) # 80005c30 <panic>
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
    800005b2:	682080e7          	jalr	1666(ra) # 80005c30 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00005097          	auipc	ra,0x5
    800005c2:	672080e7          	jalr	1650(ra) # 80005c30 <panic>
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
    8000060e:	626080e7          	jalr	1574(ra) # 80005c30 <panic>

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
    8000075a:	4da080e7          	jalr	1242(ra) # 80005c30 <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00005097          	auipc	ra,0x5
    8000076a:	4ca080e7          	jalr	1226(ra) # 80005c30 <panic>
      panic("uvmunmap: not mapped");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00005097          	auipc	ra,0x5
    8000077a:	4ba080e7          	jalr	1210(ra) # 80005c30 <panic>
      panic("uvmunmap: not a leaf");
    8000077e:	00008517          	auipc	a0,0x8
    80000782:	94250513          	addi	a0,a0,-1726 # 800080c0 <etext+0xc0>
    80000786:	00005097          	auipc	ra,0x5
    8000078a:	4aa080e7          	jalr	1194(ra) # 80005c30 <panic>
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
    80000868:	3cc080e7          	jalr	972(ra) # 80005c30 <panic>

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
    800009ac:	288080e7          	jalr	648(ra) # 80005c30 <panic>
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
    80000a8a:	1aa080e7          	jalr	426(ra) # 80005c30 <panic>
      panic("uvmcopy: page not present");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	69a50513          	addi	a0,a0,1690 # 80008128 <etext+0x128>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	19a080e7          	jalr	410(ra) # 80005c30 <panic>
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
    80000b04:	130080e7          	jalr	304(ra) # 80005c30 <panic>

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
    80000d02:	0000fa17          	auipc	s4,0xf
    80000d06:	97ea0a13          	addi	s4,s4,-1666 # 8000f680 <tickslock>
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
    80000d3c:	18848493          	addi	s1,s1,392
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
    80000d64:	ed0080e7          	jalr	-304(ra) # 80005c30 <panic>

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
    80000d90:	3ca080e7          	jalr	970(ra) # 80006156 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d94:	00007597          	auipc	a1,0x7
    80000d98:	3d458593          	addi	a1,a1,980 # 80008168 <etext+0x168>
    80000d9c:	00008517          	auipc	a0,0x8
    80000da0:	2cc50513          	addi	a0,a0,716 # 80009068 <wait_lock>
    80000da4:	00005097          	auipc	ra,0x5
    80000da8:	3b2080e7          	jalr	946(ra) # 80006156 <initlock>
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
    80000dce:	0000f997          	auipc	s3,0xf
    80000dd2:	8b298993          	addi	s3,s3,-1870 # 8000f680 <tickslock>
      initlock(&p->lock, "proc");
    80000dd6:	85da                	mv	a1,s6
    80000dd8:	8526                	mv	a0,s1
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	37c080e7          	jalr	892(ra) # 80006156 <initlock>
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
    80000dfc:	18848493          	addi	s1,s1,392
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
    80000e52:	34c080e7          	jalr	844(ra) # 8000619a <push_off>
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
    80000e6c:	3d2080e7          	jalr	978(ra) # 8000623a <pop_off>
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
    80000e90:	40e080e7          	jalr	1038(ra) # 8000629a <release>

  if (first) {
    80000e94:	00008797          	auipc	a5,0x8
    80000e98:	9ac7a783          	lw	a5,-1620(a5) # 80008840 <first.1>
    80000e9c:	eb89                	bnez	a5,80000eae <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e9e:	00001097          	auipc	ra,0x1
    80000ea2:	c58080e7          	jalr	-936(ra) # 80001af6 <usertrapret>
}
    80000ea6:	60a2                	ld	ra,8(sp)
    80000ea8:	6402                	ld	s0,0(sp)
    80000eaa:	0141                	addi	sp,sp,16
    80000eac:	8082                	ret
    first = 0;
    80000eae:	00008797          	auipc	a5,0x8
    80000eb2:	9807a923          	sw	zero,-1646(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80000eb6:	4505                	li	a0,1
    80000eb8:	00002097          	auipc	ra,0x2
    80000ebc:	a82080e7          	jalr	-1406(ra) # 8000293a <fsinit>
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
    80000edc:	30e080e7          	jalr	782(ra) # 800061e6 <acquire>
  pid = nextpid;
    80000ee0:	00008797          	auipc	a5,0x8
    80000ee4:	96478793          	addi	a5,a5,-1692 # 80008844 <nextpid>
    80000ee8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eea:	0014871b          	addiw	a4,s1,1
    80000eee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef0:	854a                	mv	a0,s2
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	3a8080e7          	jalr	936(ra) # 8000629a <release>
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
  p->interval = 0;
    80001040:	1604a423          	sw	zero,360(s1)
  p->handler = 0;
    80001044:	1604b823          	sd	zero,368(s1)
  p->ticks = 0;
    80001048:	1604ac23          	sw	zero,376(s1)
  if(p->pretrapframe)
    8000104c:	1804b503          	ld	a0,384(s1)
    80001050:	c509                	beqz	a0,8000105a <freeproc+0x64>
    kfree((void*)p->pretrapframe);
    80001052:	fffff097          	auipc	ra,0xfffff
    80001056:	fca080e7          	jalr	-54(ra) # 8000001c <kfree>
  p->state = UNUSED;
    8000105a:	0004ac23          	sw	zero,24(s1)
}
    8000105e:	60e2                	ld	ra,24(sp)
    80001060:	6442                	ld	s0,16(sp)
    80001062:	64a2                	ld	s1,8(sp)
    80001064:	6105                	addi	sp,sp,32
    80001066:	8082                	ret

0000000080001068 <allocproc>:
{
    80001068:	1101                	addi	sp,sp,-32
    8000106a:	ec06                	sd	ra,24(sp)
    8000106c:	e822                	sd	s0,16(sp)
    8000106e:	e426                	sd	s1,8(sp)
    80001070:	e04a                	sd	s2,0(sp)
    80001072:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001074:	00008497          	auipc	s1,0x8
    80001078:	40c48493          	addi	s1,s1,1036 # 80009480 <proc>
    8000107c:	0000e917          	auipc	s2,0xe
    80001080:	60490913          	addi	s2,s2,1540 # 8000f680 <tickslock>
    acquire(&p->lock);
    80001084:	8526                	mv	a0,s1
    80001086:	00005097          	auipc	ra,0x5
    8000108a:	160080e7          	jalr	352(ra) # 800061e6 <acquire>
    if(p->state == UNUSED) {
    8000108e:	4c9c                	lw	a5,24(s1)
    80001090:	cf81                	beqz	a5,800010a8 <allocproc+0x40>
      release(&p->lock);
    80001092:	8526                	mv	a0,s1
    80001094:	00005097          	auipc	ra,0x5
    80001098:	206080e7          	jalr	518(ra) # 8000629a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000109c:	18848493          	addi	s1,s1,392
    800010a0:	ff2492e3          	bne	s1,s2,80001084 <allocproc+0x1c>
  return 0;
    800010a4:	4481                	li	s1,0
    800010a6:	a0bd                	j	80001114 <allocproc+0xac>
  p->pid = allocpid();
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	e1a080e7          	jalr	-486(ra) # 80000ec2 <allocpid>
    800010b0:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010b2:	4785                	li	a5,1
    800010b4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010b6:	fffff097          	auipc	ra,0xfffff
    800010ba:	064080e7          	jalr	100(ra) # 8000011a <kalloc>
    800010be:	892a                	mv	s2,a0
    800010c0:	eca8                	sd	a0,88(s1)
    800010c2:	c125                	beqz	a0,80001122 <allocproc+0xba>
  p->pagetable = proc_pagetable(p);
    800010c4:	8526                	mv	a0,s1
    800010c6:	00000097          	auipc	ra,0x0
    800010ca:	e42080e7          	jalr	-446(ra) # 80000f08 <proc_pagetable>
    800010ce:	892a                	mv	s2,a0
    800010d0:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010d2:	c525                	beqz	a0,8000113a <allocproc+0xd2>
  memset(&p->context, 0, sizeof(p->context));
    800010d4:	07000613          	li	a2,112
    800010d8:	4581                	li	a1,0
    800010da:	06048513          	addi	a0,s1,96
    800010de:	fffff097          	auipc	ra,0xfffff
    800010e2:	09c080e7          	jalr	156(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010e6:	00000797          	auipc	a5,0x0
    800010ea:	d9678793          	addi	a5,a5,-618 # 80000e7c <forkret>
    800010ee:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010f0:	60bc                	ld	a5,64(s1)
    800010f2:	6705                	lui	a4,0x1
    800010f4:	97ba                	add	a5,a5,a4
    800010f6:	f4bc                	sd	a5,104(s1)
  p->interval = 0;
    800010f8:	1604a423          	sw	zero,360(s1)
  p->handler = 0;
    800010fc:	1604b823          	sd	zero,368(s1)
  p->ticks = 0;
    80001100:	1604ac23          	sw	zero,376(s1)
  if((p->pretrapframe = (struct trapframe *)kalloc()) == 0){
    80001104:	fffff097          	auipc	ra,0xfffff
    80001108:	016080e7          	jalr	22(ra) # 8000011a <kalloc>
    8000110c:	892a                	mv	s2,a0
    8000110e:	18a4b023          	sd	a0,384(s1)
    80001112:	c121                	beqz	a0,80001152 <allocproc+0xea>
}
    80001114:	8526                	mv	a0,s1
    80001116:	60e2                	ld	ra,24(sp)
    80001118:	6442                	ld	s0,16(sp)
    8000111a:	64a2                	ld	s1,8(sp)
    8000111c:	6902                	ld	s2,0(sp)
    8000111e:	6105                	addi	sp,sp,32
    80001120:	8082                	ret
    freeproc(p);
    80001122:	8526                	mv	a0,s1
    80001124:	00000097          	auipc	ra,0x0
    80001128:	ed2080e7          	jalr	-302(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    8000112c:	8526                	mv	a0,s1
    8000112e:	00005097          	auipc	ra,0x5
    80001132:	16c080e7          	jalr	364(ra) # 8000629a <release>
    return 0;
    80001136:	84ca                	mv	s1,s2
    80001138:	bff1                	j	80001114 <allocproc+0xac>
    freeproc(p);
    8000113a:	8526                	mv	a0,s1
    8000113c:	00000097          	auipc	ra,0x0
    80001140:	eba080e7          	jalr	-326(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    80001144:	8526                	mv	a0,s1
    80001146:	00005097          	auipc	ra,0x5
    8000114a:	154080e7          	jalr	340(ra) # 8000629a <release>
    return 0;
    8000114e:	84ca                	mv	s1,s2
    80001150:	b7d1                	j	80001114 <allocproc+0xac>
    release(&p->lock);
    80001152:	8526                	mv	a0,s1
    80001154:	00005097          	auipc	ra,0x5
    80001158:	146080e7          	jalr	326(ra) # 8000629a <release>
	return 0;
    8000115c:	84ca                	mv	s1,s2
    8000115e:	bf5d                	j	80001114 <allocproc+0xac>

0000000080001160 <userinit>:
{
    80001160:	1101                	addi	sp,sp,-32
    80001162:	ec06                	sd	ra,24(sp)
    80001164:	e822                	sd	s0,16(sp)
    80001166:	e426                	sd	s1,8(sp)
    80001168:	1000                	addi	s0,sp,32
  p = allocproc();
    8000116a:	00000097          	auipc	ra,0x0
    8000116e:	efe080e7          	jalr	-258(ra) # 80001068 <allocproc>
    80001172:	84aa                	mv	s1,a0
  initproc = p;
    80001174:	00008797          	auipc	a5,0x8
    80001178:	e8a7be23          	sd	a0,-356(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000117c:	03400613          	li	a2,52
    80001180:	00007597          	auipc	a1,0x7
    80001184:	6d058593          	addi	a1,a1,1744 # 80008850 <initcode>
    80001188:	6928                	ld	a0,80(a0)
    8000118a:	fffff097          	auipc	ra,0xfffff
    8000118e:	670080e7          	jalr	1648(ra) # 800007fa <uvminit>
  p->sz = PGSIZE;
    80001192:	6785                	lui	a5,0x1
    80001194:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001196:	6cb8                	ld	a4,88(s1)
    80001198:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000119c:	6cb8                	ld	a4,88(s1)
    8000119e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011a0:	4641                	li	a2,16
    800011a2:	00007597          	auipc	a1,0x7
    800011a6:	fde58593          	addi	a1,a1,-34 # 80008180 <etext+0x180>
    800011aa:	15848513          	addi	a0,s1,344
    800011ae:	fffff097          	auipc	ra,0xfffff
    800011b2:	116080e7          	jalr	278(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    800011b6:	00007517          	auipc	a0,0x7
    800011ba:	fda50513          	addi	a0,a0,-38 # 80008190 <etext+0x190>
    800011be:	00002097          	auipc	ra,0x2
    800011c2:	1b2080e7          	jalr	434(ra) # 80003370 <namei>
    800011c6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011ca:	478d                	li	a5,3
    800011cc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011ce:	8526                	mv	a0,s1
    800011d0:	00005097          	auipc	ra,0x5
    800011d4:	0ca080e7          	jalr	202(ra) # 8000629a <release>
}
    800011d8:	60e2                	ld	ra,24(sp)
    800011da:	6442                	ld	s0,16(sp)
    800011dc:	64a2                	ld	s1,8(sp)
    800011de:	6105                	addi	sp,sp,32
    800011e0:	8082                	ret

00000000800011e2 <growproc>:
{
    800011e2:	1101                	addi	sp,sp,-32
    800011e4:	ec06                	sd	ra,24(sp)
    800011e6:	e822                	sd	s0,16(sp)
    800011e8:	e426                	sd	s1,8(sp)
    800011ea:	e04a                	sd	s2,0(sp)
    800011ec:	1000                	addi	s0,sp,32
    800011ee:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011f0:	00000097          	auipc	ra,0x0
    800011f4:	c54080e7          	jalr	-940(ra) # 80000e44 <myproc>
    800011f8:	892a                	mv	s2,a0
  sz = p->sz;
    800011fa:	652c                	ld	a1,72(a0)
    800011fc:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001200:	00904f63          	bgtz	s1,8000121e <growproc+0x3c>
  } else if(n < 0){
    80001204:	0204cd63          	bltz	s1,8000123e <growproc+0x5c>
  p->sz = sz;
    80001208:	1782                	slli	a5,a5,0x20
    8000120a:	9381                	srli	a5,a5,0x20
    8000120c:	04f93423          	sd	a5,72(s2)
  return 0;
    80001210:	4501                	li	a0,0
}
    80001212:	60e2                	ld	ra,24(sp)
    80001214:	6442                	ld	s0,16(sp)
    80001216:	64a2                	ld	s1,8(sp)
    80001218:	6902                	ld	s2,0(sp)
    8000121a:	6105                	addi	sp,sp,32
    8000121c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000121e:	00f4863b          	addw	a2,s1,a5
    80001222:	1602                	slli	a2,a2,0x20
    80001224:	9201                	srli	a2,a2,0x20
    80001226:	1582                	slli	a1,a1,0x20
    80001228:	9181                	srli	a1,a1,0x20
    8000122a:	6928                	ld	a0,80(a0)
    8000122c:	fffff097          	auipc	ra,0xfffff
    80001230:	688080e7          	jalr	1672(ra) # 800008b4 <uvmalloc>
    80001234:	0005079b          	sext.w	a5,a0
    80001238:	fbe1                	bnez	a5,80001208 <growproc+0x26>
      return -1;
    8000123a:	557d                	li	a0,-1
    8000123c:	bfd9                	j	80001212 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000123e:	00f4863b          	addw	a2,s1,a5
    80001242:	1602                	slli	a2,a2,0x20
    80001244:	9201                	srli	a2,a2,0x20
    80001246:	1582                	slli	a1,a1,0x20
    80001248:	9181                	srli	a1,a1,0x20
    8000124a:	6928                	ld	a0,80(a0)
    8000124c:	fffff097          	auipc	ra,0xfffff
    80001250:	620080e7          	jalr	1568(ra) # 8000086c <uvmdealloc>
    80001254:	0005079b          	sext.w	a5,a0
    80001258:	bf45                	j	80001208 <growproc+0x26>

000000008000125a <fork>:
{
    8000125a:	7139                	addi	sp,sp,-64
    8000125c:	fc06                	sd	ra,56(sp)
    8000125e:	f822                	sd	s0,48(sp)
    80001260:	f426                	sd	s1,40(sp)
    80001262:	f04a                	sd	s2,32(sp)
    80001264:	ec4e                	sd	s3,24(sp)
    80001266:	e852                	sd	s4,16(sp)
    80001268:	e456                	sd	s5,8(sp)
    8000126a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000126c:	00000097          	auipc	ra,0x0
    80001270:	bd8080e7          	jalr	-1064(ra) # 80000e44 <myproc>
    80001274:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	df2080e7          	jalr	-526(ra) # 80001068 <allocproc>
    8000127e:	10050c63          	beqz	a0,80001396 <fork+0x13c>
    80001282:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001284:	048ab603          	ld	a2,72(s5)
    80001288:	692c                	ld	a1,80(a0)
    8000128a:	050ab503          	ld	a0,80(s5)
    8000128e:	fffff097          	auipc	ra,0xfffff
    80001292:	776080e7          	jalr	1910(ra) # 80000a04 <uvmcopy>
    80001296:	04054863          	bltz	a0,800012e6 <fork+0x8c>
  np->sz = p->sz;
    8000129a:	048ab783          	ld	a5,72(s5)
    8000129e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012a2:	058ab683          	ld	a3,88(s5)
    800012a6:	87b6                	mv	a5,a3
    800012a8:	058a3703          	ld	a4,88(s4)
    800012ac:	12068693          	addi	a3,a3,288
    800012b0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012b4:	6788                	ld	a0,8(a5)
    800012b6:	6b8c                	ld	a1,16(a5)
    800012b8:	6f90                	ld	a2,24(a5)
    800012ba:	01073023          	sd	a6,0(a4)
    800012be:	e708                	sd	a0,8(a4)
    800012c0:	eb0c                	sd	a1,16(a4)
    800012c2:	ef10                	sd	a2,24(a4)
    800012c4:	02078793          	addi	a5,a5,32
    800012c8:	02070713          	addi	a4,a4,32
    800012cc:	fed792e3          	bne	a5,a3,800012b0 <fork+0x56>
  np->trapframe->a0 = 0;
    800012d0:	058a3783          	ld	a5,88(s4)
    800012d4:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012d8:	0d0a8493          	addi	s1,s5,208
    800012dc:	0d0a0913          	addi	s2,s4,208
    800012e0:	150a8993          	addi	s3,s5,336
    800012e4:	a00d                	j	80001306 <fork+0xac>
    freeproc(np);
    800012e6:	8552                	mv	a0,s4
    800012e8:	00000097          	auipc	ra,0x0
    800012ec:	d0e080e7          	jalr	-754(ra) # 80000ff6 <freeproc>
    release(&np->lock);
    800012f0:	8552                	mv	a0,s4
    800012f2:	00005097          	auipc	ra,0x5
    800012f6:	fa8080e7          	jalr	-88(ra) # 8000629a <release>
    return -1;
    800012fa:	597d                	li	s2,-1
    800012fc:	a059                	j	80001382 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012fe:	04a1                	addi	s1,s1,8
    80001300:	0921                	addi	s2,s2,8
    80001302:	01348b63          	beq	s1,s3,80001318 <fork+0xbe>
    if(p->ofile[i])
    80001306:	6088                	ld	a0,0(s1)
    80001308:	d97d                	beqz	a0,800012fe <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    8000130a:	00002097          	auipc	ra,0x2
    8000130e:	6fc080e7          	jalr	1788(ra) # 80003a06 <filedup>
    80001312:	00a93023          	sd	a0,0(s2)
    80001316:	b7e5                	j	800012fe <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001318:	150ab503          	ld	a0,336(s5)
    8000131c:	00002097          	auipc	ra,0x2
    80001320:	85a080e7          	jalr	-1958(ra) # 80002b76 <idup>
    80001324:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001328:	4641                	li	a2,16
    8000132a:	158a8593          	addi	a1,s5,344
    8000132e:	158a0513          	addi	a0,s4,344
    80001332:	fffff097          	auipc	ra,0xfffff
    80001336:	f92080e7          	jalr	-110(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    8000133a:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000133e:	8552                	mv	a0,s4
    80001340:	00005097          	auipc	ra,0x5
    80001344:	f5a080e7          	jalr	-166(ra) # 8000629a <release>
  acquire(&wait_lock);
    80001348:	00008497          	auipc	s1,0x8
    8000134c:	d2048493          	addi	s1,s1,-736 # 80009068 <wait_lock>
    80001350:	8526                	mv	a0,s1
    80001352:	00005097          	auipc	ra,0x5
    80001356:	e94080e7          	jalr	-364(ra) # 800061e6 <acquire>
  np->parent = p;
    8000135a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000135e:	8526                	mv	a0,s1
    80001360:	00005097          	auipc	ra,0x5
    80001364:	f3a080e7          	jalr	-198(ra) # 8000629a <release>
  acquire(&np->lock);
    80001368:	8552                	mv	a0,s4
    8000136a:	00005097          	auipc	ra,0x5
    8000136e:	e7c080e7          	jalr	-388(ra) # 800061e6 <acquire>
  np->state = RUNNABLE;
    80001372:	478d                	li	a5,3
    80001374:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001378:	8552                	mv	a0,s4
    8000137a:	00005097          	auipc	ra,0x5
    8000137e:	f20080e7          	jalr	-224(ra) # 8000629a <release>
}
    80001382:	854a                	mv	a0,s2
    80001384:	70e2                	ld	ra,56(sp)
    80001386:	7442                	ld	s0,48(sp)
    80001388:	74a2                	ld	s1,40(sp)
    8000138a:	7902                	ld	s2,32(sp)
    8000138c:	69e2                	ld	s3,24(sp)
    8000138e:	6a42                	ld	s4,16(sp)
    80001390:	6aa2                	ld	s5,8(sp)
    80001392:	6121                	addi	sp,sp,64
    80001394:	8082                	ret
    return -1;
    80001396:	597d                	li	s2,-1
    80001398:	b7ed                	j	80001382 <fork+0x128>

000000008000139a <scheduler>:
{
    8000139a:	7139                	addi	sp,sp,-64
    8000139c:	fc06                	sd	ra,56(sp)
    8000139e:	f822                	sd	s0,48(sp)
    800013a0:	f426                	sd	s1,40(sp)
    800013a2:	f04a                	sd	s2,32(sp)
    800013a4:	ec4e                	sd	s3,24(sp)
    800013a6:	e852                	sd	s4,16(sp)
    800013a8:	e456                	sd	s5,8(sp)
    800013aa:	e05a                	sd	s6,0(sp)
    800013ac:	0080                	addi	s0,sp,64
    800013ae:	8792                	mv	a5,tp
  int id = r_tp();
    800013b0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013b2:	00779a93          	slli	s5,a5,0x7
    800013b6:	00008717          	auipc	a4,0x8
    800013ba:	c9a70713          	addi	a4,a4,-870 # 80009050 <pid_lock>
    800013be:	9756                	add	a4,a4,s5
    800013c0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013c4:	00008717          	auipc	a4,0x8
    800013c8:	cc470713          	addi	a4,a4,-828 # 80009088 <cpus+0x8>
    800013cc:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013ce:	498d                	li	s3,3
        p->state = RUNNING;
    800013d0:	4b11                	li	s6,4
        c->proc = p;
    800013d2:	079e                	slli	a5,a5,0x7
    800013d4:	00008a17          	auipc	s4,0x8
    800013d8:	c7ca0a13          	addi	s4,s4,-900 # 80009050 <pid_lock>
    800013dc:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013de:	0000e917          	auipc	s2,0xe
    800013e2:	2a290913          	addi	s2,s2,674 # 8000f680 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013e6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013ea:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013ee:	10079073          	csrw	sstatus,a5
    800013f2:	00008497          	auipc	s1,0x8
    800013f6:	08e48493          	addi	s1,s1,142 # 80009480 <proc>
    800013fa:	a811                	j	8000140e <scheduler+0x74>
      release(&p->lock);
    800013fc:	8526                	mv	a0,s1
    800013fe:	00005097          	auipc	ra,0x5
    80001402:	e9c080e7          	jalr	-356(ra) # 8000629a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001406:	18848493          	addi	s1,s1,392
    8000140a:	fd248ee3          	beq	s1,s2,800013e6 <scheduler+0x4c>
      acquire(&p->lock);
    8000140e:	8526                	mv	a0,s1
    80001410:	00005097          	auipc	ra,0x5
    80001414:	dd6080e7          	jalr	-554(ra) # 800061e6 <acquire>
      if(p->state == RUNNABLE) {
    80001418:	4c9c                	lw	a5,24(s1)
    8000141a:	ff3791e3          	bne	a5,s3,800013fc <scheduler+0x62>
        p->state = RUNNING;
    8000141e:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001422:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001426:	06048593          	addi	a1,s1,96
    8000142a:	8556                	mv	a0,s5
    8000142c:	00000097          	auipc	ra,0x0
    80001430:	620080e7          	jalr	1568(ra) # 80001a4c <swtch>
        c->proc = 0;
    80001434:	020a3823          	sd	zero,48(s4)
    80001438:	b7d1                	j	800013fc <scheduler+0x62>

000000008000143a <sched>:
{
    8000143a:	7179                	addi	sp,sp,-48
    8000143c:	f406                	sd	ra,40(sp)
    8000143e:	f022                	sd	s0,32(sp)
    80001440:	ec26                	sd	s1,24(sp)
    80001442:	e84a                	sd	s2,16(sp)
    80001444:	e44e                	sd	s3,8(sp)
    80001446:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001448:	00000097          	auipc	ra,0x0
    8000144c:	9fc080e7          	jalr	-1540(ra) # 80000e44 <myproc>
    80001450:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001452:	00005097          	auipc	ra,0x5
    80001456:	d1a080e7          	jalr	-742(ra) # 8000616c <holding>
    8000145a:	c93d                	beqz	a0,800014d0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000145c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000145e:	2781                	sext.w	a5,a5
    80001460:	079e                	slli	a5,a5,0x7
    80001462:	00008717          	auipc	a4,0x8
    80001466:	bee70713          	addi	a4,a4,-1042 # 80009050 <pid_lock>
    8000146a:	97ba                	add	a5,a5,a4
    8000146c:	0a87a703          	lw	a4,168(a5)
    80001470:	4785                	li	a5,1
    80001472:	06f71763          	bne	a4,a5,800014e0 <sched+0xa6>
  if(p->state == RUNNING)
    80001476:	4c98                	lw	a4,24(s1)
    80001478:	4791                	li	a5,4
    8000147a:	06f70b63          	beq	a4,a5,800014f0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000147e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001482:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001484:	efb5                	bnez	a5,80001500 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001486:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001488:	00008917          	auipc	s2,0x8
    8000148c:	bc890913          	addi	s2,s2,-1080 # 80009050 <pid_lock>
    80001490:	2781                	sext.w	a5,a5
    80001492:	079e                	slli	a5,a5,0x7
    80001494:	97ca                	add	a5,a5,s2
    80001496:	0ac7a983          	lw	s3,172(a5)
    8000149a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000149c:	2781                	sext.w	a5,a5
    8000149e:	079e                	slli	a5,a5,0x7
    800014a0:	00008597          	auipc	a1,0x8
    800014a4:	be858593          	addi	a1,a1,-1048 # 80009088 <cpus+0x8>
    800014a8:	95be                	add	a1,a1,a5
    800014aa:	06048513          	addi	a0,s1,96
    800014ae:	00000097          	auipc	ra,0x0
    800014b2:	59e080e7          	jalr	1438(ra) # 80001a4c <swtch>
    800014b6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014b8:	2781                	sext.w	a5,a5
    800014ba:	079e                	slli	a5,a5,0x7
    800014bc:	993e                	add	s2,s2,a5
    800014be:	0b392623          	sw	s3,172(s2)
}
    800014c2:	70a2                	ld	ra,40(sp)
    800014c4:	7402                	ld	s0,32(sp)
    800014c6:	64e2                	ld	s1,24(sp)
    800014c8:	6942                	ld	s2,16(sp)
    800014ca:	69a2                	ld	s3,8(sp)
    800014cc:	6145                	addi	sp,sp,48
    800014ce:	8082                	ret
    panic("sched p->lock");
    800014d0:	00007517          	auipc	a0,0x7
    800014d4:	cc850513          	addi	a0,a0,-824 # 80008198 <etext+0x198>
    800014d8:	00004097          	auipc	ra,0x4
    800014dc:	758080e7          	jalr	1880(ra) # 80005c30 <panic>
    panic("sched locks");
    800014e0:	00007517          	auipc	a0,0x7
    800014e4:	cc850513          	addi	a0,a0,-824 # 800081a8 <etext+0x1a8>
    800014e8:	00004097          	auipc	ra,0x4
    800014ec:	748080e7          	jalr	1864(ra) # 80005c30 <panic>
    panic("sched running");
    800014f0:	00007517          	auipc	a0,0x7
    800014f4:	cc850513          	addi	a0,a0,-824 # 800081b8 <etext+0x1b8>
    800014f8:	00004097          	auipc	ra,0x4
    800014fc:	738080e7          	jalr	1848(ra) # 80005c30 <panic>
    panic("sched interruptible");
    80001500:	00007517          	auipc	a0,0x7
    80001504:	cc850513          	addi	a0,a0,-824 # 800081c8 <etext+0x1c8>
    80001508:	00004097          	auipc	ra,0x4
    8000150c:	728080e7          	jalr	1832(ra) # 80005c30 <panic>

0000000080001510 <yield>:
{
    80001510:	1101                	addi	sp,sp,-32
    80001512:	ec06                	sd	ra,24(sp)
    80001514:	e822                	sd	s0,16(sp)
    80001516:	e426                	sd	s1,8(sp)
    80001518:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000151a:	00000097          	auipc	ra,0x0
    8000151e:	92a080e7          	jalr	-1750(ra) # 80000e44 <myproc>
    80001522:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001524:	00005097          	auipc	ra,0x5
    80001528:	cc2080e7          	jalr	-830(ra) # 800061e6 <acquire>
  p->state = RUNNABLE;
    8000152c:	478d                	li	a5,3
    8000152e:	cc9c                	sw	a5,24(s1)
  sched();
    80001530:	00000097          	auipc	ra,0x0
    80001534:	f0a080e7          	jalr	-246(ra) # 8000143a <sched>
  release(&p->lock);
    80001538:	8526                	mv	a0,s1
    8000153a:	00005097          	auipc	ra,0x5
    8000153e:	d60080e7          	jalr	-672(ra) # 8000629a <release>
}
    80001542:	60e2                	ld	ra,24(sp)
    80001544:	6442                	ld	s0,16(sp)
    80001546:	64a2                	ld	s1,8(sp)
    80001548:	6105                	addi	sp,sp,32
    8000154a:	8082                	ret

000000008000154c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000154c:	7179                	addi	sp,sp,-48
    8000154e:	f406                	sd	ra,40(sp)
    80001550:	f022                	sd	s0,32(sp)
    80001552:	ec26                	sd	s1,24(sp)
    80001554:	e84a                	sd	s2,16(sp)
    80001556:	e44e                	sd	s3,8(sp)
    80001558:	1800                	addi	s0,sp,48
    8000155a:	89aa                	mv	s3,a0
    8000155c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000155e:	00000097          	auipc	ra,0x0
    80001562:	8e6080e7          	jalr	-1818(ra) # 80000e44 <myproc>
    80001566:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001568:	00005097          	auipc	ra,0x5
    8000156c:	c7e080e7          	jalr	-898(ra) # 800061e6 <acquire>
  release(lk);
    80001570:	854a                	mv	a0,s2
    80001572:	00005097          	auipc	ra,0x5
    80001576:	d28080e7          	jalr	-728(ra) # 8000629a <release>

  // Go to sleep.
  p->chan = chan;
    8000157a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000157e:	4789                	li	a5,2
    80001580:	cc9c                	sw	a5,24(s1)

  sched();
    80001582:	00000097          	auipc	ra,0x0
    80001586:	eb8080e7          	jalr	-328(ra) # 8000143a <sched>

  // Tidy up.
  p->chan = 0;
    8000158a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000158e:	8526                	mv	a0,s1
    80001590:	00005097          	auipc	ra,0x5
    80001594:	d0a080e7          	jalr	-758(ra) # 8000629a <release>
  acquire(lk);
    80001598:	854a                	mv	a0,s2
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	c4c080e7          	jalr	-948(ra) # 800061e6 <acquire>
}
    800015a2:	70a2                	ld	ra,40(sp)
    800015a4:	7402                	ld	s0,32(sp)
    800015a6:	64e2                	ld	s1,24(sp)
    800015a8:	6942                	ld	s2,16(sp)
    800015aa:	69a2                	ld	s3,8(sp)
    800015ac:	6145                	addi	sp,sp,48
    800015ae:	8082                	ret

00000000800015b0 <wait>:
{
    800015b0:	715d                	addi	sp,sp,-80
    800015b2:	e486                	sd	ra,72(sp)
    800015b4:	e0a2                	sd	s0,64(sp)
    800015b6:	fc26                	sd	s1,56(sp)
    800015b8:	f84a                	sd	s2,48(sp)
    800015ba:	f44e                	sd	s3,40(sp)
    800015bc:	f052                	sd	s4,32(sp)
    800015be:	ec56                	sd	s5,24(sp)
    800015c0:	e85a                	sd	s6,16(sp)
    800015c2:	e45e                	sd	s7,8(sp)
    800015c4:	e062                	sd	s8,0(sp)
    800015c6:	0880                	addi	s0,sp,80
    800015c8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015ca:	00000097          	auipc	ra,0x0
    800015ce:	87a080e7          	jalr	-1926(ra) # 80000e44 <myproc>
    800015d2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015d4:	00008517          	auipc	a0,0x8
    800015d8:	a9450513          	addi	a0,a0,-1388 # 80009068 <wait_lock>
    800015dc:	00005097          	auipc	ra,0x5
    800015e0:	c0a080e7          	jalr	-1014(ra) # 800061e6 <acquire>
    havekids = 0;
    800015e4:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015e6:	4a15                	li	s4,5
        havekids = 1;
    800015e8:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015ea:	0000e997          	auipc	s3,0xe
    800015ee:	09698993          	addi	s3,s3,150 # 8000f680 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015f2:	00008c17          	auipc	s8,0x8
    800015f6:	a76c0c13          	addi	s8,s8,-1418 # 80009068 <wait_lock>
    havekids = 0;
    800015fa:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015fc:	00008497          	auipc	s1,0x8
    80001600:	e8448493          	addi	s1,s1,-380 # 80009480 <proc>
    80001604:	a0bd                	j	80001672 <wait+0xc2>
          pid = np->pid;
    80001606:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000160a:	000b0e63          	beqz	s6,80001626 <wait+0x76>
    8000160e:	4691                	li	a3,4
    80001610:	02c48613          	addi	a2,s1,44
    80001614:	85da                	mv	a1,s6
    80001616:	05093503          	ld	a0,80(s2)
    8000161a:	fffff097          	auipc	ra,0xfffff
    8000161e:	4ee080e7          	jalr	1262(ra) # 80000b08 <copyout>
    80001622:	02054563          	bltz	a0,8000164c <wait+0x9c>
          freeproc(np);
    80001626:	8526                	mv	a0,s1
    80001628:	00000097          	auipc	ra,0x0
    8000162c:	9ce080e7          	jalr	-1586(ra) # 80000ff6 <freeproc>
          release(&np->lock);
    80001630:	8526                	mv	a0,s1
    80001632:	00005097          	auipc	ra,0x5
    80001636:	c68080e7          	jalr	-920(ra) # 8000629a <release>
          release(&wait_lock);
    8000163a:	00008517          	auipc	a0,0x8
    8000163e:	a2e50513          	addi	a0,a0,-1490 # 80009068 <wait_lock>
    80001642:	00005097          	auipc	ra,0x5
    80001646:	c58080e7          	jalr	-936(ra) # 8000629a <release>
          return pid;
    8000164a:	a09d                	j	800016b0 <wait+0x100>
            release(&np->lock);
    8000164c:	8526                	mv	a0,s1
    8000164e:	00005097          	auipc	ra,0x5
    80001652:	c4c080e7          	jalr	-948(ra) # 8000629a <release>
            release(&wait_lock);
    80001656:	00008517          	auipc	a0,0x8
    8000165a:	a1250513          	addi	a0,a0,-1518 # 80009068 <wait_lock>
    8000165e:	00005097          	auipc	ra,0x5
    80001662:	c3c080e7          	jalr	-964(ra) # 8000629a <release>
            return -1;
    80001666:	59fd                	li	s3,-1
    80001668:	a0a1                	j	800016b0 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000166a:	18848493          	addi	s1,s1,392
    8000166e:	03348463          	beq	s1,s3,80001696 <wait+0xe6>
      if(np->parent == p){
    80001672:	7c9c                	ld	a5,56(s1)
    80001674:	ff279be3          	bne	a5,s2,8000166a <wait+0xba>
        acquire(&np->lock);
    80001678:	8526                	mv	a0,s1
    8000167a:	00005097          	auipc	ra,0x5
    8000167e:	b6c080e7          	jalr	-1172(ra) # 800061e6 <acquire>
        if(np->state == ZOMBIE){
    80001682:	4c9c                	lw	a5,24(s1)
    80001684:	f94781e3          	beq	a5,s4,80001606 <wait+0x56>
        release(&np->lock);
    80001688:	8526                	mv	a0,s1
    8000168a:	00005097          	auipc	ra,0x5
    8000168e:	c10080e7          	jalr	-1008(ra) # 8000629a <release>
        havekids = 1;
    80001692:	8756                	mv	a4,s5
    80001694:	bfd9                	j	8000166a <wait+0xba>
    if(!havekids || p->killed){
    80001696:	c701                	beqz	a4,8000169e <wait+0xee>
    80001698:	02892783          	lw	a5,40(s2)
    8000169c:	c79d                	beqz	a5,800016ca <wait+0x11a>
      release(&wait_lock);
    8000169e:	00008517          	auipc	a0,0x8
    800016a2:	9ca50513          	addi	a0,a0,-1590 # 80009068 <wait_lock>
    800016a6:	00005097          	auipc	ra,0x5
    800016aa:	bf4080e7          	jalr	-1036(ra) # 8000629a <release>
      return -1;
    800016ae:	59fd                	li	s3,-1
}
    800016b0:	854e                	mv	a0,s3
    800016b2:	60a6                	ld	ra,72(sp)
    800016b4:	6406                	ld	s0,64(sp)
    800016b6:	74e2                	ld	s1,56(sp)
    800016b8:	7942                	ld	s2,48(sp)
    800016ba:	79a2                	ld	s3,40(sp)
    800016bc:	7a02                	ld	s4,32(sp)
    800016be:	6ae2                	ld	s5,24(sp)
    800016c0:	6b42                	ld	s6,16(sp)
    800016c2:	6ba2                	ld	s7,8(sp)
    800016c4:	6c02                	ld	s8,0(sp)
    800016c6:	6161                	addi	sp,sp,80
    800016c8:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016ca:	85e2                	mv	a1,s8
    800016cc:	854a                	mv	a0,s2
    800016ce:	00000097          	auipc	ra,0x0
    800016d2:	e7e080e7          	jalr	-386(ra) # 8000154c <sleep>
    havekids = 0;
    800016d6:	b715                	j	800015fa <wait+0x4a>

00000000800016d8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016d8:	7139                	addi	sp,sp,-64
    800016da:	fc06                	sd	ra,56(sp)
    800016dc:	f822                	sd	s0,48(sp)
    800016de:	f426                	sd	s1,40(sp)
    800016e0:	f04a                	sd	s2,32(sp)
    800016e2:	ec4e                	sd	s3,24(sp)
    800016e4:	e852                	sd	s4,16(sp)
    800016e6:	e456                	sd	s5,8(sp)
    800016e8:	0080                	addi	s0,sp,64
    800016ea:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016ec:	00008497          	auipc	s1,0x8
    800016f0:	d9448493          	addi	s1,s1,-620 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016f4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016f6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016f8:	0000e917          	auipc	s2,0xe
    800016fc:	f8890913          	addi	s2,s2,-120 # 8000f680 <tickslock>
    80001700:	a811                	j	80001714 <wakeup+0x3c>
      }
      release(&p->lock);
    80001702:	8526                	mv	a0,s1
    80001704:	00005097          	auipc	ra,0x5
    80001708:	b96080e7          	jalr	-1130(ra) # 8000629a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000170c:	18848493          	addi	s1,s1,392
    80001710:	03248663          	beq	s1,s2,8000173c <wakeup+0x64>
    if(p != myproc()){
    80001714:	fffff097          	auipc	ra,0xfffff
    80001718:	730080e7          	jalr	1840(ra) # 80000e44 <myproc>
    8000171c:	fea488e3          	beq	s1,a0,8000170c <wakeup+0x34>
      acquire(&p->lock);
    80001720:	8526                	mv	a0,s1
    80001722:	00005097          	auipc	ra,0x5
    80001726:	ac4080e7          	jalr	-1340(ra) # 800061e6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000172a:	4c9c                	lw	a5,24(s1)
    8000172c:	fd379be3          	bne	a5,s3,80001702 <wakeup+0x2a>
    80001730:	709c                	ld	a5,32(s1)
    80001732:	fd4798e3          	bne	a5,s4,80001702 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001736:	0154ac23          	sw	s5,24(s1)
    8000173a:	b7e1                	j	80001702 <wakeup+0x2a>
    }
  }
}
    8000173c:	70e2                	ld	ra,56(sp)
    8000173e:	7442                	ld	s0,48(sp)
    80001740:	74a2                	ld	s1,40(sp)
    80001742:	7902                	ld	s2,32(sp)
    80001744:	69e2                	ld	s3,24(sp)
    80001746:	6a42                	ld	s4,16(sp)
    80001748:	6aa2                	ld	s5,8(sp)
    8000174a:	6121                	addi	sp,sp,64
    8000174c:	8082                	ret

000000008000174e <reparent>:
{
    8000174e:	7179                	addi	sp,sp,-48
    80001750:	f406                	sd	ra,40(sp)
    80001752:	f022                	sd	s0,32(sp)
    80001754:	ec26                	sd	s1,24(sp)
    80001756:	e84a                	sd	s2,16(sp)
    80001758:	e44e                	sd	s3,8(sp)
    8000175a:	e052                	sd	s4,0(sp)
    8000175c:	1800                	addi	s0,sp,48
    8000175e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001760:	00008497          	auipc	s1,0x8
    80001764:	d2048493          	addi	s1,s1,-736 # 80009480 <proc>
      pp->parent = initproc;
    80001768:	00008a17          	auipc	s4,0x8
    8000176c:	8a8a0a13          	addi	s4,s4,-1880 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001770:	0000e997          	auipc	s3,0xe
    80001774:	f1098993          	addi	s3,s3,-240 # 8000f680 <tickslock>
    80001778:	a029                	j	80001782 <reparent+0x34>
    8000177a:	18848493          	addi	s1,s1,392
    8000177e:	01348d63          	beq	s1,s3,80001798 <reparent+0x4a>
    if(pp->parent == p){
    80001782:	7c9c                	ld	a5,56(s1)
    80001784:	ff279be3          	bne	a5,s2,8000177a <reparent+0x2c>
      pp->parent = initproc;
    80001788:	000a3503          	ld	a0,0(s4)
    8000178c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000178e:	00000097          	auipc	ra,0x0
    80001792:	f4a080e7          	jalr	-182(ra) # 800016d8 <wakeup>
    80001796:	b7d5                	j	8000177a <reparent+0x2c>
}
    80001798:	70a2                	ld	ra,40(sp)
    8000179a:	7402                	ld	s0,32(sp)
    8000179c:	64e2                	ld	s1,24(sp)
    8000179e:	6942                	ld	s2,16(sp)
    800017a0:	69a2                	ld	s3,8(sp)
    800017a2:	6a02                	ld	s4,0(sp)
    800017a4:	6145                	addi	sp,sp,48
    800017a6:	8082                	ret

00000000800017a8 <exit>:
{
    800017a8:	7179                	addi	sp,sp,-48
    800017aa:	f406                	sd	ra,40(sp)
    800017ac:	f022                	sd	s0,32(sp)
    800017ae:	ec26                	sd	s1,24(sp)
    800017b0:	e84a                	sd	s2,16(sp)
    800017b2:	e44e                	sd	s3,8(sp)
    800017b4:	e052                	sd	s4,0(sp)
    800017b6:	1800                	addi	s0,sp,48
    800017b8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017ba:	fffff097          	auipc	ra,0xfffff
    800017be:	68a080e7          	jalr	1674(ra) # 80000e44 <myproc>
    800017c2:	89aa                	mv	s3,a0
  if(p == initproc)
    800017c4:	00008797          	auipc	a5,0x8
    800017c8:	84c7b783          	ld	a5,-1972(a5) # 80009010 <initproc>
    800017cc:	0d050493          	addi	s1,a0,208
    800017d0:	15050913          	addi	s2,a0,336
    800017d4:	02a79363          	bne	a5,a0,800017fa <exit+0x52>
    panic("init exiting");
    800017d8:	00007517          	auipc	a0,0x7
    800017dc:	a0850513          	addi	a0,a0,-1528 # 800081e0 <etext+0x1e0>
    800017e0:	00004097          	auipc	ra,0x4
    800017e4:	450080e7          	jalr	1104(ra) # 80005c30 <panic>
      fileclose(f);
    800017e8:	00002097          	auipc	ra,0x2
    800017ec:	270080e7          	jalr	624(ra) # 80003a58 <fileclose>
      p->ofile[fd] = 0;
    800017f0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017f4:	04a1                	addi	s1,s1,8
    800017f6:	01248563          	beq	s1,s2,80001800 <exit+0x58>
    if(p->ofile[fd]){
    800017fa:	6088                	ld	a0,0(s1)
    800017fc:	f575                	bnez	a0,800017e8 <exit+0x40>
    800017fe:	bfdd                	j	800017f4 <exit+0x4c>
  begin_op();
    80001800:	00002097          	auipc	ra,0x2
    80001804:	d90080e7          	jalr	-624(ra) # 80003590 <begin_op>
  iput(p->cwd);
    80001808:	1509b503          	ld	a0,336(s3)
    8000180c:	00001097          	auipc	ra,0x1
    80001810:	562080e7          	jalr	1378(ra) # 80002d6e <iput>
  end_op();
    80001814:	00002097          	auipc	ra,0x2
    80001818:	dfa080e7          	jalr	-518(ra) # 8000360e <end_op>
  p->cwd = 0;
    8000181c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001820:	00008497          	auipc	s1,0x8
    80001824:	84848493          	addi	s1,s1,-1976 # 80009068 <wait_lock>
    80001828:	8526                	mv	a0,s1
    8000182a:	00005097          	auipc	ra,0x5
    8000182e:	9bc080e7          	jalr	-1604(ra) # 800061e6 <acquire>
  reparent(p);
    80001832:	854e                	mv	a0,s3
    80001834:	00000097          	auipc	ra,0x0
    80001838:	f1a080e7          	jalr	-230(ra) # 8000174e <reparent>
  wakeup(p->parent);
    8000183c:	0389b503          	ld	a0,56(s3)
    80001840:	00000097          	auipc	ra,0x0
    80001844:	e98080e7          	jalr	-360(ra) # 800016d8 <wakeup>
  acquire(&p->lock);
    80001848:	854e                	mv	a0,s3
    8000184a:	00005097          	auipc	ra,0x5
    8000184e:	99c080e7          	jalr	-1636(ra) # 800061e6 <acquire>
  p->xstate = status;
    80001852:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001856:	4795                	li	a5,5
    80001858:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000185c:	8526                	mv	a0,s1
    8000185e:	00005097          	auipc	ra,0x5
    80001862:	a3c080e7          	jalr	-1476(ra) # 8000629a <release>
  sched();
    80001866:	00000097          	auipc	ra,0x0
    8000186a:	bd4080e7          	jalr	-1068(ra) # 8000143a <sched>
  panic("zombie exit");
    8000186e:	00007517          	auipc	a0,0x7
    80001872:	98250513          	addi	a0,a0,-1662 # 800081f0 <etext+0x1f0>
    80001876:	00004097          	auipc	ra,0x4
    8000187a:	3ba080e7          	jalr	954(ra) # 80005c30 <panic>

000000008000187e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000187e:	7179                	addi	sp,sp,-48
    80001880:	f406                	sd	ra,40(sp)
    80001882:	f022                	sd	s0,32(sp)
    80001884:	ec26                	sd	s1,24(sp)
    80001886:	e84a                	sd	s2,16(sp)
    80001888:	e44e                	sd	s3,8(sp)
    8000188a:	1800                	addi	s0,sp,48
    8000188c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000188e:	00008497          	auipc	s1,0x8
    80001892:	bf248493          	addi	s1,s1,-1038 # 80009480 <proc>
    80001896:	0000e997          	auipc	s3,0xe
    8000189a:	dea98993          	addi	s3,s3,-534 # 8000f680 <tickslock>
    acquire(&p->lock);
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	946080e7          	jalr	-1722(ra) # 800061e6 <acquire>
    if(p->pid == pid){
    800018a8:	589c                	lw	a5,48(s1)
    800018aa:	01278d63          	beq	a5,s2,800018c4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018ae:	8526                	mv	a0,s1
    800018b0:	00005097          	auipc	ra,0x5
    800018b4:	9ea080e7          	jalr	-1558(ra) # 8000629a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018b8:	18848493          	addi	s1,s1,392
    800018bc:	ff3491e3          	bne	s1,s3,8000189e <kill+0x20>
  }
  return -1;
    800018c0:	557d                	li	a0,-1
    800018c2:	a829                	j	800018dc <kill+0x5e>
      p->killed = 1;
    800018c4:	4785                	li	a5,1
    800018c6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018c8:	4c98                	lw	a4,24(s1)
    800018ca:	4789                	li	a5,2
    800018cc:	00f70f63          	beq	a4,a5,800018ea <kill+0x6c>
      release(&p->lock);
    800018d0:	8526                	mv	a0,s1
    800018d2:	00005097          	auipc	ra,0x5
    800018d6:	9c8080e7          	jalr	-1592(ra) # 8000629a <release>
      return 0;
    800018da:	4501                	li	a0,0
}
    800018dc:	70a2                	ld	ra,40(sp)
    800018de:	7402                	ld	s0,32(sp)
    800018e0:	64e2                	ld	s1,24(sp)
    800018e2:	6942                	ld	s2,16(sp)
    800018e4:	69a2                	ld	s3,8(sp)
    800018e6:	6145                	addi	sp,sp,48
    800018e8:	8082                	ret
        p->state = RUNNABLE;
    800018ea:	478d                	li	a5,3
    800018ec:	cc9c                	sw	a5,24(s1)
    800018ee:	b7cd                	j	800018d0 <kill+0x52>

00000000800018f0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018f0:	7179                	addi	sp,sp,-48
    800018f2:	f406                	sd	ra,40(sp)
    800018f4:	f022                	sd	s0,32(sp)
    800018f6:	ec26                	sd	s1,24(sp)
    800018f8:	e84a                	sd	s2,16(sp)
    800018fa:	e44e                	sd	s3,8(sp)
    800018fc:	e052                	sd	s4,0(sp)
    800018fe:	1800                	addi	s0,sp,48
    80001900:	84aa                	mv	s1,a0
    80001902:	892e                	mv	s2,a1
    80001904:	89b2                	mv	s3,a2
    80001906:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	53c080e7          	jalr	1340(ra) # 80000e44 <myproc>
  if(user_dst){
    80001910:	c08d                	beqz	s1,80001932 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001912:	86d2                	mv	a3,s4
    80001914:	864e                	mv	a2,s3
    80001916:	85ca                	mv	a1,s2
    80001918:	6928                	ld	a0,80(a0)
    8000191a:	fffff097          	auipc	ra,0xfffff
    8000191e:	1ee080e7          	jalr	494(ra) # 80000b08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001922:	70a2                	ld	ra,40(sp)
    80001924:	7402                	ld	s0,32(sp)
    80001926:	64e2                	ld	s1,24(sp)
    80001928:	6942                	ld	s2,16(sp)
    8000192a:	69a2                	ld	s3,8(sp)
    8000192c:	6a02                	ld	s4,0(sp)
    8000192e:	6145                	addi	sp,sp,48
    80001930:	8082                	ret
    memmove((char *)dst, src, len);
    80001932:	000a061b          	sext.w	a2,s4
    80001936:	85ce                	mv	a1,s3
    80001938:	854a                	mv	a0,s2
    8000193a:	fffff097          	auipc	ra,0xfffff
    8000193e:	89c080e7          	jalr	-1892(ra) # 800001d6 <memmove>
    return 0;
    80001942:	8526                	mv	a0,s1
    80001944:	bff9                	j	80001922 <either_copyout+0x32>

0000000080001946 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001946:	7179                	addi	sp,sp,-48
    80001948:	f406                	sd	ra,40(sp)
    8000194a:	f022                	sd	s0,32(sp)
    8000194c:	ec26                	sd	s1,24(sp)
    8000194e:	e84a                	sd	s2,16(sp)
    80001950:	e44e                	sd	s3,8(sp)
    80001952:	e052                	sd	s4,0(sp)
    80001954:	1800                	addi	s0,sp,48
    80001956:	892a                	mv	s2,a0
    80001958:	84ae                	mv	s1,a1
    8000195a:	89b2                	mv	s3,a2
    8000195c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000195e:	fffff097          	auipc	ra,0xfffff
    80001962:	4e6080e7          	jalr	1254(ra) # 80000e44 <myproc>
  if(user_src){
    80001966:	c08d                	beqz	s1,80001988 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001968:	86d2                	mv	a3,s4
    8000196a:	864e                	mv	a2,s3
    8000196c:	85ca                	mv	a1,s2
    8000196e:	6928                	ld	a0,80(a0)
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	224080e7          	jalr	548(ra) # 80000b94 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001978:	70a2                	ld	ra,40(sp)
    8000197a:	7402                	ld	s0,32(sp)
    8000197c:	64e2                	ld	s1,24(sp)
    8000197e:	6942                	ld	s2,16(sp)
    80001980:	69a2                	ld	s3,8(sp)
    80001982:	6a02                	ld	s4,0(sp)
    80001984:	6145                	addi	sp,sp,48
    80001986:	8082                	ret
    memmove(dst, (char*)src, len);
    80001988:	000a061b          	sext.w	a2,s4
    8000198c:	85ce                	mv	a1,s3
    8000198e:	854a                	mv	a0,s2
    80001990:	fffff097          	auipc	ra,0xfffff
    80001994:	846080e7          	jalr	-1978(ra) # 800001d6 <memmove>
    return 0;
    80001998:	8526                	mv	a0,s1
    8000199a:	bff9                	j	80001978 <either_copyin+0x32>

000000008000199c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000199c:	715d                	addi	sp,sp,-80
    8000199e:	e486                	sd	ra,72(sp)
    800019a0:	e0a2                	sd	s0,64(sp)
    800019a2:	fc26                	sd	s1,56(sp)
    800019a4:	f84a                	sd	s2,48(sp)
    800019a6:	f44e                	sd	s3,40(sp)
    800019a8:	f052                	sd	s4,32(sp)
    800019aa:	ec56                	sd	s5,24(sp)
    800019ac:	e85a                	sd	s6,16(sp)
    800019ae:	e45e                	sd	s7,8(sp)
    800019b0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019b2:	00006517          	auipc	a0,0x6
    800019b6:	69650513          	addi	a0,a0,1686 # 80008048 <etext+0x48>
    800019ba:	00004097          	auipc	ra,0x4
    800019be:	2c0080e7          	jalr	704(ra) # 80005c7a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019c2:	00008497          	auipc	s1,0x8
    800019c6:	c1648493          	addi	s1,s1,-1002 # 800095d8 <proc+0x158>
    800019ca:	0000e917          	auipc	s2,0xe
    800019ce:	e0e90913          	addi	s2,s2,-498 # 8000f7d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019d2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019d4:	00007997          	auipc	s3,0x7
    800019d8:	82c98993          	addi	s3,s3,-2004 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019dc:	00007a97          	auipc	s5,0x7
    800019e0:	82ca8a93          	addi	s5,s5,-2004 # 80008208 <etext+0x208>
    printf("\n");
    800019e4:	00006a17          	auipc	s4,0x6
    800019e8:	664a0a13          	addi	s4,s4,1636 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ec:	00007b97          	auipc	s7,0x7
    800019f0:	854b8b93          	addi	s7,s7,-1964 # 80008240 <states.0>
    800019f4:	a00d                	j	80001a16 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019f6:	ed86a583          	lw	a1,-296(a3)
    800019fa:	8556                	mv	a0,s5
    800019fc:	00004097          	auipc	ra,0x4
    80001a00:	27e080e7          	jalr	638(ra) # 80005c7a <printf>
    printf("\n");
    80001a04:	8552                	mv	a0,s4
    80001a06:	00004097          	auipc	ra,0x4
    80001a0a:	274080e7          	jalr	628(ra) # 80005c7a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a0e:	18848493          	addi	s1,s1,392
    80001a12:	03248263          	beq	s1,s2,80001a36 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a16:	86a6                	mv	a3,s1
    80001a18:	ec04a783          	lw	a5,-320(s1)
    80001a1c:	dbed                	beqz	a5,80001a0e <procdump+0x72>
      state = "???";
    80001a1e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a20:	fcfb6be3          	bltu	s6,a5,800019f6 <procdump+0x5a>
    80001a24:	02079713          	slli	a4,a5,0x20
    80001a28:	01d75793          	srli	a5,a4,0x1d
    80001a2c:	97de                	add	a5,a5,s7
    80001a2e:	6390                	ld	a2,0(a5)
    80001a30:	f279                	bnez	a2,800019f6 <procdump+0x5a>
      state = "???";
    80001a32:	864e                	mv	a2,s3
    80001a34:	b7c9                	j	800019f6 <procdump+0x5a>
  }
}
    80001a36:	60a6                	ld	ra,72(sp)
    80001a38:	6406                	ld	s0,64(sp)
    80001a3a:	74e2                	ld	s1,56(sp)
    80001a3c:	7942                	ld	s2,48(sp)
    80001a3e:	79a2                	ld	s3,40(sp)
    80001a40:	7a02                	ld	s4,32(sp)
    80001a42:	6ae2                	ld	s5,24(sp)
    80001a44:	6b42                	ld	s6,16(sp)
    80001a46:	6ba2                	ld	s7,8(sp)
    80001a48:	6161                	addi	sp,sp,80
    80001a4a:	8082                	ret

0000000080001a4c <swtch>:
    80001a4c:	00153023          	sd	ra,0(a0)
    80001a50:	00253423          	sd	sp,8(a0)
    80001a54:	e900                	sd	s0,16(a0)
    80001a56:	ed04                	sd	s1,24(a0)
    80001a58:	03253023          	sd	s2,32(a0)
    80001a5c:	03353423          	sd	s3,40(a0)
    80001a60:	03453823          	sd	s4,48(a0)
    80001a64:	03553c23          	sd	s5,56(a0)
    80001a68:	05653023          	sd	s6,64(a0)
    80001a6c:	05753423          	sd	s7,72(a0)
    80001a70:	05853823          	sd	s8,80(a0)
    80001a74:	05953c23          	sd	s9,88(a0)
    80001a78:	07a53023          	sd	s10,96(a0)
    80001a7c:	07b53423          	sd	s11,104(a0)
    80001a80:	0005b083          	ld	ra,0(a1)
    80001a84:	0085b103          	ld	sp,8(a1)
    80001a88:	6980                	ld	s0,16(a1)
    80001a8a:	6d84                	ld	s1,24(a1)
    80001a8c:	0205b903          	ld	s2,32(a1)
    80001a90:	0285b983          	ld	s3,40(a1)
    80001a94:	0305ba03          	ld	s4,48(a1)
    80001a98:	0385ba83          	ld	s5,56(a1)
    80001a9c:	0405bb03          	ld	s6,64(a1)
    80001aa0:	0485bb83          	ld	s7,72(a1)
    80001aa4:	0505bc03          	ld	s8,80(a1)
    80001aa8:	0585bc83          	ld	s9,88(a1)
    80001aac:	0605bd03          	ld	s10,96(a1)
    80001ab0:	0685bd83          	ld	s11,104(a1)
    80001ab4:	8082                	ret

0000000080001ab6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ab6:	1141                	addi	sp,sp,-16
    80001ab8:	e406                	sd	ra,8(sp)
    80001aba:	e022                	sd	s0,0(sp)
    80001abc:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001abe:	00006597          	auipc	a1,0x6
    80001ac2:	7b258593          	addi	a1,a1,1970 # 80008270 <states.0+0x30>
    80001ac6:	0000e517          	auipc	a0,0xe
    80001aca:	bba50513          	addi	a0,a0,-1094 # 8000f680 <tickslock>
    80001ace:	00004097          	auipc	ra,0x4
    80001ad2:	688080e7          	jalr	1672(ra) # 80006156 <initlock>
}
    80001ad6:	60a2                	ld	ra,8(sp)
    80001ad8:	6402                	ld	s0,0(sp)
    80001ada:	0141                	addi	sp,sp,16
    80001adc:	8082                	ret

0000000080001ade <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ade:	1141                	addi	sp,sp,-16
    80001ae0:	e422                	sd	s0,8(sp)
    80001ae2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ae4:	00003797          	auipc	a5,0x3
    80001ae8:	5ac78793          	addi	a5,a5,1452 # 80005090 <kernelvec>
    80001aec:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001af0:	6422                	ld	s0,8(sp)
    80001af2:	0141                	addi	sp,sp,16
    80001af4:	8082                	ret

0000000080001af6 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001af6:	1141                	addi	sp,sp,-16
    80001af8:	e406                	sd	ra,8(sp)
    80001afa:	e022                	sd	s0,0(sp)
    80001afc:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001afe:	fffff097          	auipc	ra,0xfffff
    80001b02:	346080e7          	jalr	838(ra) # 80000e44 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b06:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b0a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b0c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b10:	00005697          	auipc	a3,0x5
    80001b14:	4f068693          	addi	a3,a3,1264 # 80007000 <_trampoline>
    80001b18:	00005717          	auipc	a4,0x5
    80001b1c:	4e870713          	addi	a4,a4,1256 # 80007000 <_trampoline>
    80001b20:	8f15                	sub	a4,a4,a3
    80001b22:	040007b7          	lui	a5,0x4000
    80001b26:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b28:	07b2                	slli	a5,a5,0xc
    80001b2a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b2c:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b30:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b32:	18002673          	csrr	a2,satp
    80001b36:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b38:	6d30                	ld	a2,88(a0)
    80001b3a:	6138                	ld	a4,64(a0)
    80001b3c:	6585                	lui	a1,0x1
    80001b3e:	972e                	add	a4,a4,a1
    80001b40:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b42:	6d38                	ld	a4,88(a0)
    80001b44:	00000617          	auipc	a2,0x0
    80001b48:	13860613          	addi	a2,a2,312 # 80001c7c <usertrap>
    80001b4c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b4e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b50:	8612                	mv	a2,tp
    80001b52:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b54:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b58:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b5c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b60:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b64:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b66:	6f18                	ld	a4,24(a4)
    80001b68:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b6c:	692c                	ld	a1,80(a0)
    80001b6e:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b70:	00005717          	auipc	a4,0x5
    80001b74:	52070713          	addi	a4,a4,1312 # 80007090 <userret>
    80001b78:	8f15                	sub	a4,a4,a3
    80001b7a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b7c:	577d                	li	a4,-1
    80001b7e:	177e                	slli	a4,a4,0x3f
    80001b80:	8dd9                	or	a1,a1,a4
    80001b82:	02000537          	lui	a0,0x2000
    80001b86:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b88:	0536                	slli	a0,a0,0xd
    80001b8a:	9782                	jalr	a5
}
    80001b8c:	60a2                	ld	ra,8(sp)
    80001b8e:	6402                	ld	s0,0(sp)
    80001b90:	0141                	addi	sp,sp,16
    80001b92:	8082                	ret

0000000080001b94 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b94:	1101                	addi	sp,sp,-32
    80001b96:	ec06                	sd	ra,24(sp)
    80001b98:	e822                	sd	s0,16(sp)
    80001b9a:	e426                	sd	s1,8(sp)
    80001b9c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b9e:	0000e497          	auipc	s1,0xe
    80001ba2:	ae248493          	addi	s1,s1,-1310 # 8000f680 <tickslock>
    80001ba6:	8526                	mv	a0,s1
    80001ba8:	00004097          	auipc	ra,0x4
    80001bac:	63e080e7          	jalr	1598(ra) # 800061e6 <acquire>
  ticks++;
    80001bb0:	00007517          	auipc	a0,0x7
    80001bb4:	46850513          	addi	a0,a0,1128 # 80009018 <ticks>
    80001bb8:	411c                	lw	a5,0(a0)
    80001bba:	2785                	addiw	a5,a5,1
    80001bbc:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bbe:	00000097          	auipc	ra,0x0
    80001bc2:	b1a080e7          	jalr	-1254(ra) # 800016d8 <wakeup>
  release(&tickslock);
    80001bc6:	8526                	mv	a0,s1
    80001bc8:	00004097          	auipc	ra,0x4
    80001bcc:	6d2080e7          	jalr	1746(ra) # 8000629a <release>
}
    80001bd0:	60e2                	ld	ra,24(sp)
    80001bd2:	6442                	ld	s0,16(sp)
    80001bd4:	64a2                	ld	s1,8(sp)
    80001bd6:	6105                	addi	sp,sp,32
    80001bd8:	8082                	ret

0000000080001bda <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001bda:	1101                	addi	sp,sp,-32
    80001bdc:	ec06                	sd	ra,24(sp)
    80001bde:	e822                	sd	s0,16(sp)
    80001be0:	e426                	sd	s1,8(sp)
    80001be2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001be4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001be8:	00074d63          	bltz	a4,80001c02 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bec:	57fd                	li	a5,-1
    80001bee:	17fe                	slli	a5,a5,0x3f
    80001bf0:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bf2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bf4:	06f70363          	beq	a4,a5,80001c5a <devintr+0x80>
  }
}
    80001bf8:	60e2                	ld	ra,24(sp)
    80001bfa:	6442                	ld	s0,16(sp)
    80001bfc:	64a2                	ld	s1,8(sp)
    80001bfe:	6105                	addi	sp,sp,32
    80001c00:	8082                	ret
     (scause & 0xff) == 9){
    80001c02:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001c06:	46a5                	li	a3,9
    80001c08:	fed792e3          	bne	a5,a3,80001bec <devintr+0x12>
    int irq = plic_claim();
    80001c0c:	00003097          	auipc	ra,0x3
    80001c10:	58c080e7          	jalr	1420(ra) # 80005198 <plic_claim>
    80001c14:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c16:	47a9                	li	a5,10
    80001c18:	02f50763          	beq	a0,a5,80001c46 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c1c:	4785                	li	a5,1
    80001c1e:	02f50963          	beq	a0,a5,80001c50 <devintr+0x76>
    return 1;
    80001c22:	4505                	li	a0,1
    } else if(irq){
    80001c24:	d8f1                	beqz	s1,80001bf8 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c26:	85a6                	mv	a1,s1
    80001c28:	00006517          	auipc	a0,0x6
    80001c2c:	65050513          	addi	a0,a0,1616 # 80008278 <states.0+0x38>
    80001c30:	00004097          	auipc	ra,0x4
    80001c34:	04a080e7          	jalr	74(ra) # 80005c7a <printf>
      plic_complete(irq);
    80001c38:	8526                	mv	a0,s1
    80001c3a:	00003097          	auipc	ra,0x3
    80001c3e:	582080e7          	jalr	1410(ra) # 800051bc <plic_complete>
    return 1;
    80001c42:	4505                	li	a0,1
    80001c44:	bf55                	j	80001bf8 <devintr+0x1e>
      uartintr();
    80001c46:	00004097          	auipc	ra,0x4
    80001c4a:	4c0080e7          	jalr	1216(ra) # 80006106 <uartintr>
    80001c4e:	b7ed                	j	80001c38 <devintr+0x5e>
      virtio_disk_intr();
    80001c50:	00004097          	auipc	ra,0x4
    80001c54:	9f8080e7          	jalr	-1544(ra) # 80005648 <virtio_disk_intr>
    80001c58:	b7c5                	j	80001c38 <devintr+0x5e>
    if(cpuid() == 0){
    80001c5a:	fffff097          	auipc	ra,0xfffff
    80001c5e:	1be080e7          	jalr	446(ra) # 80000e18 <cpuid>
    80001c62:	c901                	beqz	a0,80001c72 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c64:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c68:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c6a:	14479073          	csrw	sip,a5
    return 2;
    80001c6e:	4509                	li	a0,2
    80001c70:	b761                	j	80001bf8 <devintr+0x1e>
      clockintr();
    80001c72:	00000097          	auipc	ra,0x0
    80001c76:	f22080e7          	jalr	-222(ra) # 80001b94 <clockintr>
    80001c7a:	b7ed                	j	80001c64 <devintr+0x8a>

0000000080001c7c <usertrap>:
{
    80001c7c:	1101                	addi	sp,sp,-32
    80001c7e:	ec06                	sd	ra,24(sp)
    80001c80:	e822                	sd	s0,16(sp)
    80001c82:	e426                	sd	s1,8(sp)
    80001c84:	e04a                	sd	s2,0(sp)
    80001c86:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c88:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c8c:	1007f793          	andi	a5,a5,256
    80001c90:	e3ad                	bnez	a5,80001cf2 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c92:	00003797          	auipc	a5,0x3
    80001c96:	3fe78793          	addi	a5,a5,1022 # 80005090 <kernelvec>
    80001c9a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	1a6080e7          	jalr	422(ra) # 80000e44 <myproc>
    80001ca6:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ca8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001caa:	14102773          	csrr	a4,sepc
    80001cae:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cb0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cb4:	47a1                	li	a5,8
    80001cb6:	04f71c63          	bne	a4,a5,80001d0e <usertrap+0x92>
    if(p->killed)
    80001cba:	551c                	lw	a5,40(a0)
    80001cbc:	e3b9                	bnez	a5,80001d02 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cbe:	6cb8                	ld	a4,88(s1)
    80001cc0:	6f1c                	ld	a5,24(a4)
    80001cc2:	0791                	addi	a5,a5,4
    80001cc4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cc6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cca:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cce:	10079073          	csrw	sstatus,a5
    syscall();
    80001cd2:	00000097          	auipc	ra,0x0
    80001cd6:	32e080e7          	jalr	814(ra) # 80002000 <syscall>
  if(p->killed)
    80001cda:	549c                	lw	a5,40(s1)
    80001cdc:	e7c5                	bnez	a5,80001d84 <usertrap+0x108>
  usertrapret();
    80001cde:	00000097          	auipc	ra,0x0
    80001ce2:	e18080e7          	jalr	-488(ra) # 80001af6 <usertrapret>
}
    80001ce6:	60e2                	ld	ra,24(sp)
    80001ce8:	6442                	ld	s0,16(sp)
    80001cea:	64a2                	ld	s1,8(sp)
    80001cec:	6902                	ld	s2,0(sp)
    80001cee:	6105                	addi	sp,sp,32
    80001cf0:	8082                	ret
    panic("usertrap: not from user mode");
    80001cf2:	00006517          	auipc	a0,0x6
    80001cf6:	5a650513          	addi	a0,a0,1446 # 80008298 <states.0+0x58>
    80001cfa:	00004097          	auipc	ra,0x4
    80001cfe:	f36080e7          	jalr	-202(ra) # 80005c30 <panic>
      exit(-1);
    80001d02:	557d                	li	a0,-1
    80001d04:	00000097          	auipc	ra,0x0
    80001d08:	aa4080e7          	jalr	-1372(ra) # 800017a8 <exit>
    80001d0c:	bf4d                	j	80001cbe <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d0e:	00000097          	auipc	ra,0x0
    80001d12:	ecc080e7          	jalr	-308(ra) # 80001bda <devintr>
    80001d16:	892a                	mv	s2,a0
    80001d18:	c501                	beqz	a0,80001d20 <usertrap+0xa4>
  if(p->killed)
    80001d1a:	549c                	lw	a5,40(s1)
    80001d1c:	c3a1                	beqz	a5,80001d5c <usertrap+0xe0>
    80001d1e:	a815                	j	80001d52 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d20:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d24:	5890                	lw	a2,48(s1)
    80001d26:	00006517          	auipc	a0,0x6
    80001d2a:	59250513          	addi	a0,a0,1426 # 800082b8 <states.0+0x78>
    80001d2e:	00004097          	auipc	ra,0x4
    80001d32:	f4c080e7          	jalr	-180(ra) # 80005c7a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d36:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d3a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d3e:	00006517          	auipc	a0,0x6
    80001d42:	5aa50513          	addi	a0,a0,1450 # 800082e8 <states.0+0xa8>
    80001d46:	00004097          	auipc	ra,0x4
    80001d4a:	f34080e7          	jalr	-204(ra) # 80005c7a <printf>
    p->killed = 1;
    80001d4e:	4785                	li	a5,1
    80001d50:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d52:	557d                	li	a0,-1
    80001d54:	00000097          	auipc	ra,0x0
    80001d58:	a54080e7          	jalr	-1452(ra) # 800017a8 <exit>
  if(which_dev == 2) {
    80001d5c:	4789                	li	a5,2
    80001d5e:	f8f910e3          	bne	s2,a5,80001cde <usertrap+0x62>
    if(p->interval) {
    80001d62:	1684a783          	lw	a5,360(s1)
    80001d66:	cb91                	beqz	a5,80001d7a <usertrap+0xfe>
	  if(p->ticks == p->interval) {
    80001d68:	1784a703          	lw	a4,376(s1)
    80001d6c:	00f70e63          	beq	a4,a5,80001d88 <usertrap+0x10c>
	    p->ticks++;
    80001d70:	1784a783          	lw	a5,376(s1)
    80001d74:	2785                	addiw	a5,a5,1
    80001d76:	16f4ac23          	sw	a5,376(s1)
    yield();
    80001d7a:	fffff097          	auipc	ra,0xfffff
    80001d7e:	796080e7          	jalr	1942(ra) # 80001510 <yield>
    80001d82:	bfb1                	j	80001cde <usertrap+0x62>
  int which_dev = 0;
    80001d84:	4901                	li	s2,0
    80001d86:	b7f1                	j	80001d52 <usertrap+0xd6>
	    *p->pretrapframe = *p->trapframe;
    80001d88:	6cb4                	ld	a3,88(s1)
    80001d8a:	87b6                	mv	a5,a3
    80001d8c:	1804b703          	ld	a4,384(s1)
    80001d90:	12068693          	addi	a3,a3,288
    80001d94:	0007b803          	ld	a6,0(a5)
    80001d98:	6788                	ld	a0,8(a5)
    80001d9a:	6b8c                	ld	a1,16(a5)
    80001d9c:	6f90                	ld	a2,24(a5)
    80001d9e:	01073023          	sd	a6,0(a4)
    80001da2:	e708                	sd	a0,8(a4)
    80001da4:	eb0c                	sd	a1,16(a4)
    80001da6:	ef10                	sd	a2,24(a4)
    80001da8:	02078793          	addi	a5,a5,32
    80001dac:	02070713          	addi	a4,a4,32
    80001db0:	fed792e3          	bne	a5,a3,80001d94 <usertrap+0x118>
		p->trapframe->epc = p->handler;
    80001db4:	6cbc                	ld	a5,88(s1)
    80001db6:	1704b703          	ld	a4,368(s1)
    80001dba:	ef98                	sd	a4,24(a5)
    80001dbc:	bf55                	j	80001d70 <usertrap+0xf4>

0000000080001dbe <kerneltrap>:
{
    80001dbe:	7179                	addi	sp,sp,-48
    80001dc0:	f406                	sd	ra,40(sp)
    80001dc2:	f022                	sd	s0,32(sp)
    80001dc4:	ec26                	sd	s1,24(sp)
    80001dc6:	e84a                	sd	s2,16(sp)
    80001dc8:	e44e                	sd	s3,8(sp)
    80001dca:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dcc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dd4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dd8:	1004f793          	andi	a5,s1,256
    80001ddc:	cb85                	beqz	a5,80001e0c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dde:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001de2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001de4:	ef85                	bnez	a5,80001e1c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001de6:	00000097          	auipc	ra,0x0
    80001dea:	df4080e7          	jalr	-524(ra) # 80001bda <devintr>
    80001dee:	cd1d                	beqz	a0,80001e2c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001df0:	4789                	li	a5,2
    80001df2:	06f50a63          	beq	a0,a5,80001e66 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001df6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dfa:	10049073          	csrw	sstatus,s1
}
    80001dfe:	70a2                	ld	ra,40(sp)
    80001e00:	7402                	ld	s0,32(sp)
    80001e02:	64e2                	ld	s1,24(sp)
    80001e04:	6942                	ld	s2,16(sp)
    80001e06:	69a2                	ld	s3,8(sp)
    80001e08:	6145                	addi	sp,sp,48
    80001e0a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e0c:	00006517          	auipc	a0,0x6
    80001e10:	4fc50513          	addi	a0,a0,1276 # 80008308 <states.0+0xc8>
    80001e14:	00004097          	auipc	ra,0x4
    80001e18:	e1c080e7          	jalr	-484(ra) # 80005c30 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e1c:	00006517          	auipc	a0,0x6
    80001e20:	51450513          	addi	a0,a0,1300 # 80008330 <states.0+0xf0>
    80001e24:	00004097          	auipc	ra,0x4
    80001e28:	e0c080e7          	jalr	-500(ra) # 80005c30 <panic>
    printf("scause %p\n", scause);
    80001e2c:	85ce                	mv	a1,s3
    80001e2e:	00006517          	auipc	a0,0x6
    80001e32:	52250513          	addi	a0,a0,1314 # 80008350 <states.0+0x110>
    80001e36:	00004097          	auipc	ra,0x4
    80001e3a:	e44080e7          	jalr	-444(ra) # 80005c7a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e3e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e42:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e46:	00006517          	auipc	a0,0x6
    80001e4a:	51a50513          	addi	a0,a0,1306 # 80008360 <states.0+0x120>
    80001e4e:	00004097          	auipc	ra,0x4
    80001e52:	e2c080e7          	jalr	-468(ra) # 80005c7a <printf>
    panic("kerneltrap");
    80001e56:	00006517          	auipc	a0,0x6
    80001e5a:	52250513          	addi	a0,a0,1314 # 80008378 <states.0+0x138>
    80001e5e:	00004097          	auipc	ra,0x4
    80001e62:	dd2080e7          	jalr	-558(ra) # 80005c30 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	fde080e7          	jalr	-34(ra) # 80000e44 <myproc>
    80001e6e:	d541                	beqz	a0,80001df6 <kerneltrap+0x38>
    80001e70:	fffff097          	auipc	ra,0xfffff
    80001e74:	fd4080e7          	jalr	-44(ra) # 80000e44 <myproc>
    80001e78:	4d18                	lw	a4,24(a0)
    80001e7a:	4791                	li	a5,4
    80001e7c:	f6f71de3          	bne	a4,a5,80001df6 <kerneltrap+0x38>
    yield();
    80001e80:	fffff097          	auipc	ra,0xfffff
    80001e84:	690080e7          	jalr	1680(ra) # 80001510 <yield>
    80001e88:	b7bd                	j	80001df6 <kerneltrap+0x38>

0000000080001e8a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e8a:	1101                	addi	sp,sp,-32
    80001e8c:	ec06                	sd	ra,24(sp)
    80001e8e:	e822                	sd	s0,16(sp)
    80001e90:	e426                	sd	s1,8(sp)
    80001e92:	1000                	addi	s0,sp,32
    80001e94:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e96:	fffff097          	auipc	ra,0xfffff
    80001e9a:	fae080e7          	jalr	-82(ra) # 80000e44 <myproc>
  switch (n) {
    80001e9e:	4795                	li	a5,5
    80001ea0:	0497e163          	bltu	a5,s1,80001ee2 <argraw+0x58>
    80001ea4:	048a                	slli	s1,s1,0x2
    80001ea6:	00006717          	auipc	a4,0x6
    80001eaa:	50a70713          	addi	a4,a4,1290 # 800083b0 <states.0+0x170>
    80001eae:	94ba                	add	s1,s1,a4
    80001eb0:	409c                	lw	a5,0(s1)
    80001eb2:	97ba                	add	a5,a5,a4
    80001eb4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001eb6:	6d3c                	ld	a5,88(a0)
    80001eb8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eba:	60e2                	ld	ra,24(sp)
    80001ebc:	6442                	ld	s0,16(sp)
    80001ebe:	64a2                	ld	s1,8(sp)
    80001ec0:	6105                	addi	sp,sp,32
    80001ec2:	8082                	ret
    return p->trapframe->a1;
    80001ec4:	6d3c                	ld	a5,88(a0)
    80001ec6:	7fa8                	ld	a0,120(a5)
    80001ec8:	bfcd                	j	80001eba <argraw+0x30>
    return p->trapframe->a2;
    80001eca:	6d3c                	ld	a5,88(a0)
    80001ecc:	63c8                	ld	a0,128(a5)
    80001ece:	b7f5                	j	80001eba <argraw+0x30>
    return p->trapframe->a3;
    80001ed0:	6d3c                	ld	a5,88(a0)
    80001ed2:	67c8                	ld	a0,136(a5)
    80001ed4:	b7dd                	j	80001eba <argraw+0x30>
    return p->trapframe->a4;
    80001ed6:	6d3c                	ld	a5,88(a0)
    80001ed8:	6bc8                	ld	a0,144(a5)
    80001eda:	b7c5                	j	80001eba <argraw+0x30>
    return p->trapframe->a5;
    80001edc:	6d3c                	ld	a5,88(a0)
    80001ede:	6fc8                	ld	a0,152(a5)
    80001ee0:	bfe9                	j	80001eba <argraw+0x30>
  panic("argraw");
    80001ee2:	00006517          	auipc	a0,0x6
    80001ee6:	4a650513          	addi	a0,a0,1190 # 80008388 <states.0+0x148>
    80001eea:	00004097          	auipc	ra,0x4
    80001eee:	d46080e7          	jalr	-698(ra) # 80005c30 <panic>

0000000080001ef2 <fetchaddr>:
{
    80001ef2:	1101                	addi	sp,sp,-32
    80001ef4:	ec06                	sd	ra,24(sp)
    80001ef6:	e822                	sd	s0,16(sp)
    80001ef8:	e426                	sd	s1,8(sp)
    80001efa:	e04a                	sd	s2,0(sp)
    80001efc:	1000                	addi	s0,sp,32
    80001efe:	84aa                	mv	s1,a0
    80001f00:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	f42080e7          	jalr	-190(ra) # 80000e44 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f0a:	653c                	ld	a5,72(a0)
    80001f0c:	02f4f863          	bgeu	s1,a5,80001f3c <fetchaddr+0x4a>
    80001f10:	00848713          	addi	a4,s1,8
    80001f14:	02e7e663          	bltu	a5,a4,80001f40 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f18:	46a1                	li	a3,8
    80001f1a:	8626                	mv	a2,s1
    80001f1c:	85ca                	mv	a1,s2
    80001f1e:	6928                	ld	a0,80(a0)
    80001f20:	fffff097          	auipc	ra,0xfffff
    80001f24:	c74080e7          	jalr	-908(ra) # 80000b94 <copyin>
    80001f28:	00a03533          	snez	a0,a0
    80001f2c:	40a00533          	neg	a0,a0
}
    80001f30:	60e2                	ld	ra,24(sp)
    80001f32:	6442                	ld	s0,16(sp)
    80001f34:	64a2                	ld	s1,8(sp)
    80001f36:	6902                	ld	s2,0(sp)
    80001f38:	6105                	addi	sp,sp,32
    80001f3a:	8082                	ret
    return -1;
    80001f3c:	557d                	li	a0,-1
    80001f3e:	bfcd                	j	80001f30 <fetchaddr+0x3e>
    80001f40:	557d                	li	a0,-1
    80001f42:	b7fd                	j	80001f30 <fetchaddr+0x3e>

0000000080001f44 <fetchstr>:
{
    80001f44:	7179                	addi	sp,sp,-48
    80001f46:	f406                	sd	ra,40(sp)
    80001f48:	f022                	sd	s0,32(sp)
    80001f4a:	ec26                	sd	s1,24(sp)
    80001f4c:	e84a                	sd	s2,16(sp)
    80001f4e:	e44e                	sd	s3,8(sp)
    80001f50:	1800                	addi	s0,sp,48
    80001f52:	892a                	mv	s2,a0
    80001f54:	84ae                	mv	s1,a1
    80001f56:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	eec080e7          	jalr	-276(ra) # 80000e44 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f60:	86ce                	mv	a3,s3
    80001f62:	864a                	mv	a2,s2
    80001f64:	85a6                	mv	a1,s1
    80001f66:	6928                	ld	a0,80(a0)
    80001f68:	fffff097          	auipc	ra,0xfffff
    80001f6c:	cba080e7          	jalr	-838(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001f70:	00054763          	bltz	a0,80001f7e <fetchstr+0x3a>
  return strlen(buf);
    80001f74:	8526                	mv	a0,s1
    80001f76:	ffffe097          	auipc	ra,0xffffe
    80001f7a:	380080e7          	jalr	896(ra) # 800002f6 <strlen>
}
    80001f7e:	70a2                	ld	ra,40(sp)
    80001f80:	7402                	ld	s0,32(sp)
    80001f82:	64e2                	ld	s1,24(sp)
    80001f84:	6942                	ld	s2,16(sp)
    80001f86:	69a2                	ld	s3,8(sp)
    80001f88:	6145                	addi	sp,sp,48
    80001f8a:	8082                	ret

0000000080001f8c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f8c:	1101                	addi	sp,sp,-32
    80001f8e:	ec06                	sd	ra,24(sp)
    80001f90:	e822                	sd	s0,16(sp)
    80001f92:	e426                	sd	s1,8(sp)
    80001f94:	1000                	addi	s0,sp,32
    80001f96:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f98:	00000097          	auipc	ra,0x0
    80001f9c:	ef2080e7          	jalr	-270(ra) # 80001e8a <argraw>
    80001fa0:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fa2:	4501                	li	a0,0
    80001fa4:	60e2                	ld	ra,24(sp)
    80001fa6:	6442                	ld	s0,16(sp)
    80001fa8:	64a2                	ld	s1,8(sp)
    80001faa:	6105                	addi	sp,sp,32
    80001fac:	8082                	ret

0000000080001fae <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fae:	1101                	addi	sp,sp,-32
    80001fb0:	ec06                	sd	ra,24(sp)
    80001fb2:	e822                	sd	s0,16(sp)
    80001fb4:	e426                	sd	s1,8(sp)
    80001fb6:	1000                	addi	s0,sp,32
    80001fb8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fba:	00000097          	auipc	ra,0x0
    80001fbe:	ed0080e7          	jalr	-304(ra) # 80001e8a <argraw>
    80001fc2:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fc4:	4501                	li	a0,0
    80001fc6:	60e2                	ld	ra,24(sp)
    80001fc8:	6442                	ld	s0,16(sp)
    80001fca:	64a2                	ld	s1,8(sp)
    80001fcc:	6105                	addi	sp,sp,32
    80001fce:	8082                	ret

0000000080001fd0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fd0:	1101                	addi	sp,sp,-32
    80001fd2:	ec06                	sd	ra,24(sp)
    80001fd4:	e822                	sd	s0,16(sp)
    80001fd6:	e426                	sd	s1,8(sp)
    80001fd8:	e04a                	sd	s2,0(sp)
    80001fda:	1000                	addi	s0,sp,32
    80001fdc:	84ae                	mv	s1,a1
    80001fde:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fe0:	00000097          	auipc	ra,0x0
    80001fe4:	eaa080e7          	jalr	-342(ra) # 80001e8a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fe8:	864a                	mv	a2,s2
    80001fea:	85a6                	mv	a1,s1
    80001fec:	00000097          	auipc	ra,0x0
    80001ff0:	f58080e7          	jalr	-168(ra) # 80001f44 <fetchstr>
}
    80001ff4:	60e2                	ld	ra,24(sp)
    80001ff6:	6442                	ld	s0,16(sp)
    80001ff8:	64a2                	ld	s1,8(sp)
    80001ffa:	6902                	ld	s2,0(sp)
    80001ffc:	6105                	addi	sp,sp,32
    80001ffe:	8082                	ret

0000000080002000 <syscall>:

};

void
syscall(void)
{
    80002000:	1101                	addi	sp,sp,-32
    80002002:	ec06                	sd	ra,24(sp)
    80002004:	e822                	sd	s0,16(sp)
    80002006:	e426                	sd	s1,8(sp)
    80002008:	e04a                	sd	s2,0(sp)
    8000200a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000200c:	fffff097          	auipc	ra,0xfffff
    80002010:	e38080e7          	jalr	-456(ra) # 80000e44 <myproc>
    80002014:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002016:	05853903          	ld	s2,88(a0)
    8000201a:	0a893783          	ld	a5,168(s2)
    8000201e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002022:	37fd                	addiw	a5,a5,-1
    80002024:	4759                	li	a4,22
    80002026:	00f76f63          	bltu	a4,a5,80002044 <syscall+0x44>
    8000202a:	00369713          	slli	a4,a3,0x3
    8000202e:	00006797          	auipc	a5,0x6
    80002032:	39a78793          	addi	a5,a5,922 # 800083c8 <syscalls>
    80002036:	97ba                	add	a5,a5,a4
    80002038:	639c                	ld	a5,0(a5)
    8000203a:	c789                	beqz	a5,80002044 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000203c:	9782                	jalr	a5
    8000203e:	06a93823          	sd	a0,112(s2)
    80002042:	a839                	j	80002060 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002044:	15848613          	addi	a2,s1,344
    80002048:	588c                	lw	a1,48(s1)
    8000204a:	00006517          	auipc	a0,0x6
    8000204e:	34650513          	addi	a0,a0,838 # 80008390 <states.0+0x150>
    80002052:	00004097          	auipc	ra,0x4
    80002056:	c28080e7          	jalr	-984(ra) # 80005c7a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000205a:	6cbc                	ld	a5,88(s1)
    8000205c:	577d                	li	a4,-1
    8000205e:	fbb8                	sd	a4,112(a5)
  }
}
    80002060:	60e2                	ld	ra,24(sp)
    80002062:	6442                	ld	s0,16(sp)
    80002064:	64a2                	ld	s1,8(sp)
    80002066:	6902                	ld	s2,0(sp)
    80002068:	6105                	addi	sp,sp,32
    8000206a:	8082                	ret

000000008000206c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000206c:	1101                	addi	sp,sp,-32
    8000206e:	ec06                	sd	ra,24(sp)
    80002070:	e822                	sd	s0,16(sp)
    80002072:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002074:	fec40593          	addi	a1,s0,-20
    80002078:	4501                	li	a0,0
    8000207a:	00000097          	auipc	ra,0x0
    8000207e:	f12080e7          	jalr	-238(ra) # 80001f8c <argint>
    return -1;
    80002082:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002084:	00054963          	bltz	a0,80002096 <sys_exit+0x2a>
  exit(n);
    80002088:	fec42503          	lw	a0,-20(s0)
    8000208c:	fffff097          	auipc	ra,0xfffff
    80002090:	71c080e7          	jalr	1820(ra) # 800017a8 <exit>
  return 0;  // not reached
    80002094:	4781                	li	a5,0
}
    80002096:	853e                	mv	a0,a5
    80002098:	60e2                	ld	ra,24(sp)
    8000209a:	6442                	ld	s0,16(sp)
    8000209c:	6105                	addi	sp,sp,32
    8000209e:	8082                	ret

00000000800020a0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020a0:	1141                	addi	sp,sp,-16
    800020a2:	e406                	sd	ra,8(sp)
    800020a4:	e022                	sd	s0,0(sp)
    800020a6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020a8:	fffff097          	auipc	ra,0xfffff
    800020ac:	d9c080e7          	jalr	-612(ra) # 80000e44 <myproc>
}
    800020b0:	5908                	lw	a0,48(a0)
    800020b2:	60a2                	ld	ra,8(sp)
    800020b4:	6402                	ld	s0,0(sp)
    800020b6:	0141                	addi	sp,sp,16
    800020b8:	8082                	ret

00000000800020ba <sys_fork>:

uint64
sys_fork(void)
{
    800020ba:	1141                	addi	sp,sp,-16
    800020bc:	e406                	sd	ra,8(sp)
    800020be:	e022                	sd	s0,0(sp)
    800020c0:	0800                	addi	s0,sp,16
  return fork();
    800020c2:	fffff097          	auipc	ra,0xfffff
    800020c6:	198080e7          	jalr	408(ra) # 8000125a <fork>
}
    800020ca:	60a2                	ld	ra,8(sp)
    800020cc:	6402                	ld	s0,0(sp)
    800020ce:	0141                	addi	sp,sp,16
    800020d0:	8082                	ret

00000000800020d2 <sys_wait>:

uint64
sys_wait(void)
{
    800020d2:	1101                	addi	sp,sp,-32
    800020d4:	ec06                	sd	ra,24(sp)
    800020d6:	e822                	sd	s0,16(sp)
    800020d8:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020da:	fe840593          	addi	a1,s0,-24
    800020de:	4501                	li	a0,0
    800020e0:	00000097          	auipc	ra,0x0
    800020e4:	ece080e7          	jalr	-306(ra) # 80001fae <argaddr>
    800020e8:	87aa                	mv	a5,a0
    return -1;
    800020ea:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800020ec:	0007c863          	bltz	a5,800020fc <sys_wait+0x2a>
  return wait(p);
    800020f0:	fe843503          	ld	a0,-24(s0)
    800020f4:	fffff097          	auipc	ra,0xfffff
    800020f8:	4bc080e7          	jalr	1212(ra) # 800015b0 <wait>
}
    800020fc:	60e2                	ld	ra,24(sp)
    800020fe:	6442                	ld	s0,16(sp)
    80002100:	6105                	addi	sp,sp,32
    80002102:	8082                	ret

0000000080002104 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002104:	7179                	addi	sp,sp,-48
    80002106:	f406                	sd	ra,40(sp)
    80002108:	f022                	sd	s0,32(sp)
    8000210a:	ec26                	sd	s1,24(sp)
    8000210c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000210e:	fdc40593          	addi	a1,s0,-36
    80002112:	4501                	li	a0,0
    80002114:	00000097          	auipc	ra,0x0
    80002118:	e78080e7          	jalr	-392(ra) # 80001f8c <argint>
    8000211c:	87aa                	mv	a5,a0
    return -1;
    8000211e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002120:	0207c063          	bltz	a5,80002140 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	d20080e7          	jalr	-736(ra) # 80000e44 <myproc>
    8000212c:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000212e:	fdc42503          	lw	a0,-36(s0)
    80002132:	fffff097          	auipc	ra,0xfffff
    80002136:	0b0080e7          	jalr	176(ra) # 800011e2 <growproc>
    8000213a:	00054863          	bltz	a0,8000214a <sys_sbrk+0x46>
    return -1;
  return addr;
    8000213e:	8526                	mv	a0,s1
}
    80002140:	70a2                	ld	ra,40(sp)
    80002142:	7402                	ld	s0,32(sp)
    80002144:	64e2                	ld	s1,24(sp)
    80002146:	6145                	addi	sp,sp,48
    80002148:	8082                	ret
    return -1;
    8000214a:	557d                	li	a0,-1
    8000214c:	bfd5                	j	80002140 <sys_sbrk+0x3c>

000000008000214e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000214e:	7139                	addi	sp,sp,-64
    80002150:	fc06                	sd	ra,56(sp)
    80002152:	f822                	sd	s0,48(sp)
    80002154:	f426                	sd	s1,40(sp)
    80002156:	f04a                	sd	s2,32(sp)
    80002158:	ec4e                	sd	s3,24(sp)
    8000215a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000215c:	fcc40593          	addi	a1,s0,-52
    80002160:	4501                	li	a0,0
    80002162:	00000097          	auipc	ra,0x0
    80002166:	e2a080e7          	jalr	-470(ra) # 80001f8c <argint>
    return -1;
    8000216a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000216c:	06054963          	bltz	a0,800021de <sys_sleep+0x90>
  acquire(&tickslock);
    80002170:	0000d517          	auipc	a0,0xd
    80002174:	51050513          	addi	a0,a0,1296 # 8000f680 <tickslock>
    80002178:	00004097          	auipc	ra,0x4
    8000217c:	06e080e7          	jalr	110(ra) # 800061e6 <acquire>
  ticks0 = ticks;
    80002180:	00007917          	auipc	s2,0x7
    80002184:	e9892903          	lw	s2,-360(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002188:	fcc42783          	lw	a5,-52(s0)
    8000218c:	c3a1                	beqz	a5,800021cc <sys_sleep+0x7e>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    backtrace();
    sleep(&ticks, &tickslock);
    8000218e:	0000d997          	auipc	s3,0xd
    80002192:	4f298993          	addi	s3,s3,1266 # 8000f680 <tickslock>
    80002196:	00007497          	auipc	s1,0x7
    8000219a:	e8248493          	addi	s1,s1,-382 # 80009018 <ticks>
    if(myproc()->killed){
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	ca6080e7          	jalr	-858(ra) # 80000e44 <myproc>
    800021a6:	551c                	lw	a5,40(a0)
    800021a8:	e3b9                	bnez	a5,800021ee <sys_sleep+0xa0>
    backtrace();
    800021aa:	00004097          	auipc	ra,0x4
    800021ae:	ce2080e7          	jalr	-798(ra) # 80005e8c <backtrace>
    sleep(&ticks, &tickslock);
    800021b2:	85ce                	mv	a1,s3
    800021b4:	8526                	mv	a0,s1
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	396080e7          	jalr	918(ra) # 8000154c <sleep>
  while(ticks - ticks0 < n){
    800021be:	409c                	lw	a5,0(s1)
    800021c0:	412787bb          	subw	a5,a5,s2
    800021c4:	fcc42703          	lw	a4,-52(s0)
    800021c8:	fce7ebe3          	bltu	a5,a4,8000219e <sys_sleep+0x50>
  }
  release(&tickslock);
    800021cc:	0000d517          	auipc	a0,0xd
    800021d0:	4b450513          	addi	a0,a0,1204 # 8000f680 <tickslock>
    800021d4:	00004097          	auipc	ra,0x4
    800021d8:	0c6080e7          	jalr	198(ra) # 8000629a <release>
  return 0;
    800021dc:	4781                	li	a5,0
}
    800021de:	853e                	mv	a0,a5
    800021e0:	70e2                	ld	ra,56(sp)
    800021e2:	7442                	ld	s0,48(sp)
    800021e4:	74a2                	ld	s1,40(sp)
    800021e6:	7902                	ld	s2,32(sp)
    800021e8:	69e2                	ld	s3,24(sp)
    800021ea:	6121                	addi	sp,sp,64
    800021ec:	8082                	ret
      release(&tickslock);
    800021ee:	0000d517          	auipc	a0,0xd
    800021f2:	49250513          	addi	a0,a0,1170 # 8000f680 <tickslock>
    800021f6:	00004097          	auipc	ra,0x4
    800021fa:	0a4080e7          	jalr	164(ra) # 8000629a <release>
      return -1;
    800021fe:	57fd                	li	a5,-1
    80002200:	bff9                	j	800021de <sys_sleep+0x90>

0000000080002202 <sys_kill>:

uint64
sys_kill(void)
{
    80002202:	1101                	addi	sp,sp,-32
    80002204:	ec06                	sd	ra,24(sp)
    80002206:	e822                	sd	s0,16(sp)
    80002208:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000220a:	fec40593          	addi	a1,s0,-20
    8000220e:	4501                	li	a0,0
    80002210:	00000097          	auipc	ra,0x0
    80002214:	d7c080e7          	jalr	-644(ra) # 80001f8c <argint>
    80002218:	87aa                	mv	a5,a0
    return -1;
    8000221a:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000221c:	0007c863          	bltz	a5,8000222c <sys_kill+0x2a>
  return kill(pid);
    80002220:	fec42503          	lw	a0,-20(s0)
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	65a080e7          	jalr	1626(ra) # 8000187e <kill>
}
    8000222c:	60e2                	ld	ra,24(sp)
    8000222e:	6442                	ld	s0,16(sp)
    80002230:	6105                	addi	sp,sp,32
    80002232:	8082                	ret

0000000080002234 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002234:	1101                	addi	sp,sp,-32
    80002236:	ec06                	sd	ra,24(sp)
    80002238:	e822                	sd	s0,16(sp)
    8000223a:	e426                	sd	s1,8(sp)
    8000223c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000223e:	0000d517          	auipc	a0,0xd
    80002242:	44250513          	addi	a0,a0,1090 # 8000f680 <tickslock>
    80002246:	00004097          	auipc	ra,0x4
    8000224a:	fa0080e7          	jalr	-96(ra) # 800061e6 <acquire>
  xticks = ticks;
    8000224e:	00007497          	auipc	s1,0x7
    80002252:	dca4a483          	lw	s1,-566(s1) # 80009018 <ticks>
  release(&tickslock);
    80002256:	0000d517          	auipc	a0,0xd
    8000225a:	42a50513          	addi	a0,a0,1066 # 8000f680 <tickslock>
    8000225e:	00004097          	auipc	ra,0x4
    80002262:	03c080e7          	jalr	60(ra) # 8000629a <release>
  return xticks;
}
    80002266:	02049513          	slli	a0,s1,0x20
    8000226a:	9101                	srli	a0,a0,0x20
    8000226c:	60e2                	ld	ra,24(sp)
    8000226e:	6442                	ld	s0,16(sp)
    80002270:	64a2                	ld	s1,8(sp)
    80002272:	6105                	addi	sp,sp,32
    80002274:	8082                	ret

0000000080002276 <sys_sigreturn>:

uint64
sys_sigreturn(void)
{
    80002276:	1141                	addi	sp,sp,-16
    80002278:	e406                	sd	ra,8(sp)
    8000227a:	e022                	sd	s0,0(sp)
    8000227c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000227e:	fffff097          	auipc	ra,0xfffff
    80002282:	bc6080e7          	jalr	-1082(ra) # 80000e44 <myproc>
  *p->trapframe = *p->pretrapframe;
    80002286:	18053683          	ld	a3,384(a0)
    8000228a:	87b6                	mv	a5,a3
    8000228c:	6d38                	ld	a4,88(a0)
    8000228e:	12068693          	addi	a3,a3,288
    80002292:	0007b883          	ld	a7,0(a5)
    80002296:	0087b803          	ld	a6,8(a5)
    8000229a:	6b8c                	ld	a1,16(a5)
    8000229c:	6f90                	ld	a2,24(a5)
    8000229e:	01173023          	sd	a7,0(a4)
    800022a2:	01073423          	sd	a6,8(a4)
    800022a6:	eb0c                	sd	a1,16(a4)
    800022a8:	ef10                	sd	a2,24(a4)
    800022aa:	02078793          	addi	a5,a5,32
    800022ae:	02070713          	addi	a4,a4,32
    800022b2:	fed790e3          	bne	a5,a3,80002292 <sys_sigreturn+0x1c>
  //memmove(p->trapframe, p->pretrapframe, sizeof(struct trapframe));
  p->ticks = 0;
    800022b6:	16052c23          	sw	zero,376(a0)
  return 0;
}
    800022ba:	4501                	li	a0,0
    800022bc:	60a2                	ld	ra,8(sp)
    800022be:	6402                	ld	s0,0(sp)
    800022c0:	0141                	addi	sp,sp,16
    800022c2:	8082                	ret

00000000800022c4 <sys_sigalarm>:

uint64
sys_sigalarm(void)
{
    800022c4:	1101                	addi	sp,sp,-32
    800022c6:	ec06                	sd	ra,24(sp)
    800022c8:	e822                	sd	s0,16(sp)
    800022ca:	1000                	addi	s0,sp,32
  int interval;
  uint64 handler;
  struct proc * p;
  if(argint(0, &interval) < 0 || argaddr(1, &handler) < 0 || interval < 0) {
    800022cc:	fec40593          	addi	a1,s0,-20
    800022d0:	4501                	li	a0,0
    800022d2:	00000097          	auipc	ra,0x0
    800022d6:	cba080e7          	jalr	-838(ra) # 80001f8c <argint>
    return -1;
    800022da:	577d                	li	a4,-1
  if(argint(0, &interval) < 0 || argaddr(1, &handler) < 0 || interval < 0) {
    800022dc:	02054f63          	bltz	a0,8000231a <sys_sigalarm+0x56>
    800022e0:	fe040593          	addi	a1,s0,-32
    800022e4:	4505                	li	a0,1
    800022e6:	00000097          	auipc	ra,0x0
    800022ea:	cc8080e7          	jalr	-824(ra) # 80001fae <argaddr>
    800022ee:	fec42783          	lw	a5,-20(s0)
    800022f2:	8fc9                	or	a5,a5,a0
    800022f4:	2781                	sext.w	a5,a5
    return -1;
    800022f6:	577d                	li	a4,-1
  if(argint(0, &interval) < 0 || argaddr(1, &handler) < 0 || interval < 0) {
    800022f8:	0207c163          	bltz	a5,8000231a <sys_sigalarm+0x56>
  }
  p = myproc();
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	b48080e7          	jalr	-1208(ra) # 80000e44 <myproc>
  p->interval = interval;
    80002304:	fec42783          	lw	a5,-20(s0)
    80002308:	16f52423          	sw	a5,360(a0)
  p->handler = handler;
    8000230c:	fe043783          	ld	a5,-32(s0)
    80002310:	16f53823          	sd	a5,368(a0)
  p->ticks = 0;
    80002314:	16052c23          	sw	zero,376(a0)
  return 0;
    80002318:	4701                	li	a4,0
}
    8000231a:	853a                	mv	a0,a4
    8000231c:	60e2                	ld	ra,24(sp)
    8000231e:	6442                	ld	s0,16(sp)
    80002320:	6105                	addi	sp,sp,32
    80002322:	8082                	ret

0000000080002324 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002324:	7179                	addi	sp,sp,-48
    80002326:	f406                	sd	ra,40(sp)
    80002328:	f022                	sd	s0,32(sp)
    8000232a:	ec26                	sd	s1,24(sp)
    8000232c:	e84a                	sd	s2,16(sp)
    8000232e:	e44e                	sd	s3,8(sp)
    80002330:	e052                	sd	s4,0(sp)
    80002332:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002334:	00006597          	auipc	a1,0x6
    80002338:	15458593          	addi	a1,a1,340 # 80008488 <syscalls+0xc0>
    8000233c:	0000d517          	auipc	a0,0xd
    80002340:	35c50513          	addi	a0,a0,860 # 8000f698 <bcache>
    80002344:	00004097          	auipc	ra,0x4
    80002348:	e12080e7          	jalr	-494(ra) # 80006156 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000234c:	00015797          	auipc	a5,0x15
    80002350:	34c78793          	addi	a5,a5,844 # 80017698 <bcache+0x8000>
    80002354:	00015717          	auipc	a4,0x15
    80002358:	5ac70713          	addi	a4,a4,1452 # 80017900 <bcache+0x8268>
    8000235c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002360:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002364:	0000d497          	auipc	s1,0xd
    80002368:	34c48493          	addi	s1,s1,844 # 8000f6b0 <bcache+0x18>
    b->next = bcache.head.next;
    8000236c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000236e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002370:	00006a17          	auipc	s4,0x6
    80002374:	120a0a13          	addi	s4,s4,288 # 80008490 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002378:	2b893783          	ld	a5,696(s2)
    8000237c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000237e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002382:	85d2                	mv	a1,s4
    80002384:	01048513          	addi	a0,s1,16
    80002388:	00001097          	auipc	ra,0x1
    8000238c:	4c2080e7          	jalr	1218(ra) # 8000384a <initsleeplock>
    bcache.head.next->prev = b;
    80002390:	2b893783          	ld	a5,696(s2)
    80002394:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002396:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000239a:	45848493          	addi	s1,s1,1112
    8000239e:	fd349de3          	bne	s1,s3,80002378 <binit+0x54>
  }
}
    800023a2:	70a2                	ld	ra,40(sp)
    800023a4:	7402                	ld	s0,32(sp)
    800023a6:	64e2                	ld	s1,24(sp)
    800023a8:	6942                	ld	s2,16(sp)
    800023aa:	69a2                	ld	s3,8(sp)
    800023ac:	6a02                	ld	s4,0(sp)
    800023ae:	6145                	addi	sp,sp,48
    800023b0:	8082                	ret

00000000800023b2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023b2:	7179                	addi	sp,sp,-48
    800023b4:	f406                	sd	ra,40(sp)
    800023b6:	f022                	sd	s0,32(sp)
    800023b8:	ec26                	sd	s1,24(sp)
    800023ba:	e84a                	sd	s2,16(sp)
    800023bc:	e44e                	sd	s3,8(sp)
    800023be:	1800                	addi	s0,sp,48
    800023c0:	892a                	mv	s2,a0
    800023c2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023c4:	0000d517          	auipc	a0,0xd
    800023c8:	2d450513          	addi	a0,a0,724 # 8000f698 <bcache>
    800023cc:	00004097          	auipc	ra,0x4
    800023d0:	e1a080e7          	jalr	-486(ra) # 800061e6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023d4:	00015497          	auipc	s1,0x15
    800023d8:	57c4b483          	ld	s1,1404(s1) # 80017950 <bcache+0x82b8>
    800023dc:	00015797          	auipc	a5,0x15
    800023e0:	52478793          	addi	a5,a5,1316 # 80017900 <bcache+0x8268>
    800023e4:	02f48f63          	beq	s1,a5,80002422 <bread+0x70>
    800023e8:	873e                	mv	a4,a5
    800023ea:	a021                	j	800023f2 <bread+0x40>
    800023ec:	68a4                	ld	s1,80(s1)
    800023ee:	02e48a63          	beq	s1,a4,80002422 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023f2:	449c                	lw	a5,8(s1)
    800023f4:	ff279ce3          	bne	a5,s2,800023ec <bread+0x3a>
    800023f8:	44dc                	lw	a5,12(s1)
    800023fa:	ff3799e3          	bne	a5,s3,800023ec <bread+0x3a>
      b->refcnt++;
    800023fe:	40bc                	lw	a5,64(s1)
    80002400:	2785                	addiw	a5,a5,1
    80002402:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002404:	0000d517          	auipc	a0,0xd
    80002408:	29450513          	addi	a0,a0,660 # 8000f698 <bcache>
    8000240c:	00004097          	auipc	ra,0x4
    80002410:	e8e080e7          	jalr	-370(ra) # 8000629a <release>
      acquiresleep(&b->lock);
    80002414:	01048513          	addi	a0,s1,16
    80002418:	00001097          	auipc	ra,0x1
    8000241c:	46c080e7          	jalr	1132(ra) # 80003884 <acquiresleep>
      return b;
    80002420:	a8b9                	j	8000247e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002422:	00015497          	auipc	s1,0x15
    80002426:	5264b483          	ld	s1,1318(s1) # 80017948 <bcache+0x82b0>
    8000242a:	00015797          	auipc	a5,0x15
    8000242e:	4d678793          	addi	a5,a5,1238 # 80017900 <bcache+0x8268>
    80002432:	00f48863          	beq	s1,a5,80002442 <bread+0x90>
    80002436:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002438:	40bc                	lw	a5,64(s1)
    8000243a:	cf81                	beqz	a5,80002452 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000243c:	64a4                	ld	s1,72(s1)
    8000243e:	fee49de3          	bne	s1,a4,80002438 <bread+0x86>
  panic("bget: no buffers");
    80002442:	00006517          	auipc	a0,0x6
    80002446:	05650513          	addi	a0,a0,86 # 80008498 <syscalls+0xd0>
    8000244a:	00003097          	auipc	ra,0x3
    8000244e:	7e6080e7          	jalr	2022(ra) # 80005c30 <panic>
      b->dev = dev;
    80002452:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002456:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000245a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000245e:	4785                	li	a5,1
    80002460:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002462:	0000d517          	auipc	a0,0xd
    80002466:	23650513          	addi	a0,a0,566 # 8000f698 <bcache>
    8000246a:	00004097          	auipc	ra,0x4
    8000246e:	e30080e7          	jalr	-464(ra) # 8000629a <release>
      acquiresleep(&b->lock);
    80002472:	01048513          	addi	a0,s1,16
    80002476:	00001097          	auipc	ra,0x1
    8000247a:	40e080e7          	jalr	1038(ra) # 80003884 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000247e:	409c                	lw	a5,0(s1)
    80002480:	cb89                	beqz	a5,80002492 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002482:	8526                	mv	a0,s1
    80002484:	70a2                	ld	ra,40(sp)
    80002486:	7402                	ld	s0,32(sp)
    80002488:	64e2                	ld	s1,24(sp)
    8000248a:	6942                	ld	s2,16(sp)
    8000248c:	69a2                	ld	s3,8(sp)
    8000248e:	6145                	addi	sp,sp,48
    80002490:	8082                	ret
    virtio_disk_rw(b, 0);
    80002492:	4581                	li	a1,0
    80002494:	8526                	mv	a0,s1
    80002496:	00003097          	auipc	ra,0x3
    8000249a:	f2c080e7          	jalr	-212(ra) # 800053c2 <virtio_disk_rw>
    b->valid = 1;
    8000249e:	4785                	li	a5,1
    800024a0:	c09c                	sw	a5,0(s1)
  return b;
    800024a2:	b7c5                	j	80002482 <bread+0xd0>

00000000800024a4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024a4:	1101                	addi	sp,sp,-32
    800024a6:	ec06                	sd	ra,24(sp)
    800024a8:	e822                	sd	s0,16(sp)
    800024aa:	e426                	sd	s1,8(sp)
    800024ac:	1000                	addi	s0,sp,32
    800024ae:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024b0:	0541                	addi	a0,a0,16
    800024b2:	00001097          	auipc	ra,0x1
    800024b6:	46c080e7          	jalr	1132(ra) # 8000391e <holdingsleep>
    800024ba:	cd01                	beqz	a0,800024d2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024bc:	4585                	li	a1,1
    800024be:	8526                	mv	a0,s1
    800024c0:	00003097          	auipc	ra,0x3
    800024c4:	f02080e7          	jalr	-254(ra) # 800053c2 <virtio_disk_rw>
}
    800024c8:	60e2                	ld	ra,24(sp)
    800024ca:	6442                	ld	s0,16(sp)
    800024cc:	64a2                	ld	s1,8(sp)
    800024ce:	6105                	addi	sp,sp,32
    800024d0:	8082                	ret
    panic("bwrite");
    800024d2:	00006517          	auipc	a0,0x6
    800024d6:	fde50513          	addi	a0,a0,-34 # 800084b0 <syscalls+0xe8>
    800024da:	00003097          	auipc	ra,0x3
    800024de:	756080e7          	jalr	1878(ra) # 80005c30 <panic>

00000000800024e2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024e2:	1101                	addi	sp,sp,-32
    800024e4:	ec06                	sd	ra,24(sp)
    800024e6:	e822                	sd	s0,16(sp)
    800024e8:	e426                	sd	s1,8(sp)
    800024ea:	e04a                	sd	s2,0(sp)
    800024ec:	1000                	addi	s0,sp,32
    800024ee:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024f0:	01050913          	addi	s2,a0,16
    800024f4:	854a                	mv	a0,s2
    800024f6:	00001097          	auipc	ra,0x1
    800024fa:	428080e7          	jalr	1064(ra) # 8000391e <holdingsleep>
    800024fe:	c92d                	beqz	a0,80002570 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002500:	854a                	mv	a0,s2
    80002502:	00001097          	auipc	ra,0x1
    80002506:	3d8080e7          	jalr	984(ra) # 800038da <releasesleep>

  acquire(&bcache.lock);
    8000250a:	0000d517          	auipc	a0,0xd
    8000250e:	18e50513          	addi	a0,a0,398 # 8000f698 <bcache>
    80002512:	00004097          	auipc	ra,0x4
    80002516:	cd4080e7          	jalr	-812(ra) # 800061e6 <acquire>
  b->refcnt--;
    8000251a:	40bc                	lw	a5,64(s1)
    8000251c:	37fd                	addiw	a5,a5,-1
    8000251e:	0007871b          	sext.w	a4,a5
    80002522:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002524:	eb05                	bnez	a4,80002554 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002526:	68bc                	ld	a5,80(s1)
    80002528:	64b8                	ld	a4,72(s1)
    8000252a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000252c:	64bc                	ld	a5,72(s1)
    8000252e:	68b8                	ld	a4,80(s1)
    80002530:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002532:	00015797          	auipc	a5,0x15
    80002536:	16678793          	addi	a5,a5,358 # 80017698 <bcache+0x8000>
    8000253a:	2b87b703          	ld	a4,696(a5)
    8000253e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002540:	00015717          	auipc	a4,0x15
    80002544:	3c070713          	addi	a4,a4,960 # 80017900 <bcache+0x8268>
    80002548:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000254a:	2b87b703          	ld	a4,696(a5)
    8000254e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002550:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002554:	0000d517          	auipc	a0,0xd
    80002558:	14450513          	addi	a0,a0,324 # 8000f698 <bcache>
    8000255c:	00004097          	auipc	ra,0x4
    80002560:	d3e080e7          	jalr	-706(ra) # 8000629a <release>
}
    80002564:	60e2                	ld	ra,24(sp)
    80002566:	6442                	ld	s0,16(sp)
    80002568:	64a2                	ld	s1,8(sp)
    8000256a:	6902                	ld	s2,0(sp)
    8000256c:	6105                	addi	sp,sp,32
    8000256e:	8082                	ret
    panic("brelse");
    80002570:	00006517          	auipc	a0,0x6
    80002574:	f4850513          	addi	a0,a0,-184 # 800084b8 <syscalls+0xf0>
    80002578:	00003097          	auipc	ra,0x3
    8000257c:	6b8080e7          	jalr	1720(ra) # 80005c30 <panic>

0000000080002580 <bpin>:

void
bpin(struct buf *b) {
    80002580:	1101                	addi	sp,sp,-32
    80002582:	ec06                	sd	ra,24(sp)
    80002584:	e822                	sd	s0,16(sp)
    80002586:	e426                	sd	s1,8(sp)
    80002588:	1000                	addi	s0,sp,32
    8000258a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000258c:	0000d517          	auipc	a0,0xd
    80002590:	10c50513          	addi	a0,a0,268 # 8000f698 <bcache>
    80002594:	00004097          	auipc	ra,0x4
    80002598:	c52080e7          	jalr	-942(ra) # 800061e6 <acquire>
  b->refcnt++;
    8000259c:	40bc                	lw	a5,64(s1)
    8000259e:	2785                	addiw	a5,a5,1
    800025a0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025a2:	0000d517          	auipc	a0,0xd
    800025a6:	0f650513          	addi	a0,a0,246 # 8000f698 <bcache>
    800025aa:	00004097          	auipc	ra,0x4
    800025ae:	cf0080e7          	jalr	-784(ra) # 8000629a <release>
}
    800025b2:	60e2                	ld	ra,24(sp)
    800025b4:	6442                	ld	s0,16(sp)
    800025b6:	64a2                	ld	s1,8(sp)
    800025b8:	6105                	addi	sp,sp,32
    800025ba:	8082                	ret

00000000800025bc <bunpin>:

void
bunpin(struct buf *b) {
    800025bc:	1101                	addi	sp,sp,-32
    800025be:	ec06                	sd	ra,24(sp)
    800025c0:	e822                	sd	s0,16(sp)
    800025c2:	e426                	sd	s1,8(sp)
    800025c4:	1000                	addi	s0,sp,32
    800025c6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025c8:	0000d517          	auipc	a0,0xd
    800025cc:	0d050513          	addi	a0,a0,208 # 8000f698 <bcache>
    800025d0:	00004097          	auipc	ra,0x4
    800025d4:	c16080e7          	jalr	-1002(ra) # 800061e6 <acquire>
  b->refcnt--;
    800025d8:	40bc                	lw	a5,64(s1)
    800025da:	37fd                	addiw	a5,a5,-1
    800025dc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025de:	0000d517          	auipc	a0,0xd
    800025e2:	0ba50513          	addi	a0,a0,186 # 8000f698 <bcache>
    800025e6:	00004097          	auipc	ra,0x4
    800025ea:	cb4080e7          	jalr	-844(ra) # 8000629a <release>
}
    800025ee:	60e2                	ld	ra,24(sp)
    800025f0:	6442                	ld	s0,16(sp)
    800025f2:	64a2                	ld	s1,8(sp)
    800025f4:	6105                	addi	sp,sp,32
    800025f6:	8082                	ret

00000000800025f8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025f8:	1101                	addi	sp,sp,-32
    800025fa:	ec06                	sd	ra,24(sp)
    800025fc:	e822                	sd	s0,16(sp)
    800025fe:	e426                	sd	s1,8(sp)
    80002600:	e04a                	sd	s2,0(sp)
    80002602:	1000                	addi	s0,sp,32
    80002604:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002606:	00d5d59b          	srliw	a1,a1,0xd
    8000260a:	00015797          	auipc	a5,0x15
    8000260e:	76a7a783          	lw	a5,1898(a5) # 80017d74 <sb+0x1c>
    80002612:	9dbd                	addw	a1,a1,a5
    80002614:	00000097          	auipc	ra,0x0
    80002618:	d9e080e7          	jalr	-610(ra) # 800023b2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000261c:	0074f713          	andi	a4,s1,7
    80002620:	4785                	li	a5,1
    80002622:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002626:	14ce                	slli	s1,s1,0x33
    80002628:	90d9                	srli	s1,s1,0x36
    8000262a:	00950733          	add	a4,a0,s1
    8000262e:	05874703          	lbu	a4,88(a4)
    80002632:	00e7f6b3          	and	a3,a5,a4
    80002636:	c69d                	beqz	a3,80002664 <bfree+0x6c>
    80002638:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000263a:	94aa                	add	s1,s1,a0
    8000263c:	fff7c793          	not	a5,a5
    80002640:	8f7d                	and	a4,a4,a5
    80002642:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002646:	00001097          	auipc	ra,0x1
    8000264a:	120080e7          	jalr	288(ra) # 80003766 <log_write>
  brelse(bp);
    8000264e:	854a                	mv	a0,s2
    80002650:	00000097          	auipc	ra,0x0
    80002654:	e92080e7          	jalr	-366(ra) # 800024e2 <brelse>
}
    80002658:	60e2                	ld	ra,24(sp)
    8000265a:	6442                	ld	s0,16(sp)
    8000265c:	64a2                	ld	s1,8(sp)
    8000265e:	6902                	ld	s2,0(sp)
    80002660:	6105                	addi	sp,sp,32
    80002662:	8082                	ret
    panic("freeing free block");
    80002664:	00006517          	auipc	a0,0x6
    80002668:	e5c50513          	addi	a0,a0,-420 # 800084c0 <syscalls+0xf8>
    8000266c:	00003097          	auipc	ra,0x3
    80002670:	5c4080e7          	jalr	1476(ra) # 80005c30 <panic>

0000000080002674 <balloc>:
{
    80002674:	711d                	addi	sp,sp,-96
    80002676:	ec86                	sd	ra,88(sp)
    80002678:	e8a2                	sd	s0,80(sp)
    8000267a:	e4a6                	sd	s1,72(sp)
    8000267c:	e0ca                	sd	s2,64(sp)
    8000267e:	fc4e                	sd	s3,56(sp)
    80002680:	f852                	sd	s4,48(sp)
    80002682:	f456                	sd	s5,40(sp)
    80002684:	f05a                	sd	s6,32(sp)
    80002686:	ec5e                	sd	s7,24(sp)
    80002688:	e862                	sd	s8,16(sp)
    8000268a:	e466                	sd	s9,8(sp)
    8000268c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000268e:	00015797          	auipc	a5,0x15
    80002692:	6ce7a783          	lw	a5,1742(a5) # 80017d5c <sb+0x4>
    80002696:	cbc1                	beqz	a5,80002726 <balloc+0xb2>
    80002698:	8baa                	mv	s7,a0
    8000269a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000269c:	00015b17          	auipc	s6,0x15
    800026a0:	6bcb0b13          	addi	s6,s6,1724 # 80017d58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026a6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026aa:	6c89                	lui	s9,0x2
    800026ac:	a831                	j	800026c8 <balloc+0x54>
    brelse(bp);
    800026ae:	854a                	mv	a0,s2
    800026b0:	00000097          	auipc	ra,0x0
    800026b4:	e32080e7          	jalr	-462(ra) # 800024e2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026b8:	015c87bb          	addw	a5,s9,s5
    800026bc:	00078a9b          	sext.w	s5,a5
    800026c0:	004b2703          	lw	a4,4(s6)
    800026c4:	06eaf163          	bgeu	s5,a4,80002726 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800026c8:	41fad79b          	sraiw	a5,s5,0x1f
    800026cc:	0137d79b          	srliw	a5,a5,0x13
    800026d0:	015787bb          	addw	a5,a5,s5
    800026d4:	40d7d79b          	sraiw	a5,a5,0xd
    800026d8:	01cb2583          	lw	a1,28(s6)
    800026dc:	9dbd                	addw	a1,a1,a5
    800026de:	855e                	mv	a0,s7
    800026e0:	00000097          	auipc	ra,0x0
    800026e4:	cd2080e7          	jalr	-814(ra) # 800023b2 <bread>
    800026e8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ea:	004b2503          	lw	a0,4(s6)
    800026ee:	000a849b          	sext.w	s1,s5
    800026f2:	8762                	mv	a4,s8
    800026f4:	faa4fde3          	bgeu	s1,a0,800026ae <balloc+0x3a>
      m = 1 << (bi % 8);
    800026f8:	00777693          	andi	a3,a4,7
    800026fc:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002700:	41f7579b          	sraiw	a5,a4,0x1f
    80002704:	01d7d79b          	srliw	a5,a5,0x1d
    80002708:	9fb9                	addw	a5,a5,a4
    8000270a:	4037d79b          	sraiw	a5,a5,0x3
    8000270e:	00f90633          	add	a2,s2,a5
    80002712:	05864603          	lbu	a2,88(a2)
    80002716:	00c6f5b3          	and	a1,a3,a2
    8000271a:	cd91                	beqz	a1,80002736 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000271c:	2705                	addiw	a4,a4,1
    8000271e:	2485                	addiw	s1,s1,1
    80002720:	fd471ae3          	bne	a4,s4,800026f4 <balloc+0x80>
    80002724:	b769                	j	800026ae <balloc+0x3a>
  panic("balloc: out of blocks");
    80002726:	00006517          	auipc	a0,0x6
    8000272a:	db250513          	addi	a0,a0,-590 # 800084d8 <syscalls+0x110>
    8000272e:	00003097          	auipc	ra,0x3
    80002732:	502080e7          	jalr	1282(ra) # 80005c30 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002736:	97ca                	add	a5,a5,s2
    80002738:	8e55                	or	a2,a2,a3
    8000273a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000273e:	854a                	mv	a0,s2
    80002740:	00001097          	auipc	ra,0x1
    80002744:	026080e7          	jalr	38(ra) # 80003766 <log_write>
        brelse(bp);
    80002748:	854a                	mv	a0,s2
    8000274a:	00000097          	auipc	ra,0x0
    8000274e:	d98080e7          	jalr	-616(ra) # 800024e2 <brelse>
  bp = bread(dev, bno);
    80002752:	85a6                	mv	a1,s1
    80002754:	855e                	mv	a0,s7
    80002756:	00000097          	auipc	ra,0x0
    8000275a:	c5c080e7          	jalr	-932(ra) # 800023b2 <bread>
    8000275e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002760:	40000613          	li	a2,1024
    80002764:	4581                	li	a1,0
    80002766:	05850513          	addi	a0,a0,88
    8000276a:	ffffe097          	auipc	ra,0xffffe
    8000276e:	a10080e7          	jalr	-1520(ra) # 8000017a <memset>
  log_write(bp);
    80002772:	854a                	mv	a0,s2
    80002774:	00001097          	auipc	ra,0x1
    80002778:	ff2080e7          	jalr	-14(ra) # 80003766 <log_write>
  brelse(bp);
    8000277c:	854a                	mv	a0,s2
    8000277e:	00000097          	auipc	ra,0x0
    80002782:	d64080e7          	jalr	-668(ra) # 800024e2 <brelse>
}
    80002786:	8526                	mv	a0,s1
    80002788:	60e6                	ld	ra,88(sp)
    8000278a:	6446                	ld	s0,80(sp)
    8000278c:	64a6                	ld	s1,72(sp)
    8000278e:	6906                	ld	s2,64(sp)
    80002790:	79e2                	ld	s3,56(sp)
    80002792:	7a42                	ld	s4,48(sp)
    80002794:	7aa2                	ld	s5,40(sp)
    80002796:	7b02                	ld	s6,32(sp)
    80002798:	6be2                	ld	s7,24(sp)
    8000279a:	6c42                	ld	s8,16(sp)
    8000279c:	6ca2                	ld	s9,8(sp)
    8000279e:	6125                	addi	sp,sp,96
    800027a0:	8082                	ret

00000000800027a2 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027a2:	7179                	addi	sp,sp,-48
    800027a4:	f406                	sd	ra,40(sp)
    800027a6:	f022                	sd	s0,32(sp)
    800027a8:	ec26                	sd	s1,24(sp)
    800027aa:	e84a                	sd	s2,16(sp)
    800027ac:	e44e                	sd	s3,8(sp)
    800027ae:	e052                	sd	s4,0(sp)
    800027b0:	1800                	addi	s0,sp,48
    800027b2:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027b4:	47ad                	li	a5,11
    800027b6:	04b7fe63          	bgeu	a5,a1,80002812 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027ba:	ff45849b          	addiw	s1,a1,-12
    800027be:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027c2:	0ff00793          	li	a5,255
    800027c6:	0ae7e463          	bltu	a5,a4,8000286e <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027ca:	08052583          	lw	a1,128(a0)
    800027ce:	c5b5                	beqz	a1,8000283a <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027d0:	00092503          	lw	a0,0(s2)
    800027d4:	00000097          	auipc	ra,0x0
    800027d8:	bde080e7          	jalr	-1058(ra) # 800023b2 <bread>
    800027dc:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027de:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027e2:	02049713          	slli	a4,s1,0x20
    800027e6:	01e75593          	srli	a1,a4,0x1e
    800027ea:	00b784b3          	add	s1,a5,a1
    800027ee:	0004a983          	lw	s3,0(s1)
    800027f2:	04098e63          	beqz	s3,8000284e <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800027f6:	8552                	mv	a0,s4
    800027f8:	00000097          	auipc	ra,0x0
    800027fc:	cea080e7          	jalr	-790(ra) # 800024e2 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002800:	854e                	mv	a0,s3
    80002802:	70a2                	ld	ra,40(sp)
    80002804:	7402                	ld	s0,32(sp)
    80002806:	64e2                	ld	s1,24(sp)
    80002808:	6942                	ld	s2,16(sp)
    8000280a:	69a2                	ld	s3,8(sp)
    8000280c:	6a02                	ld	s4,0(sp)
    8000280e:	6145                	addi	sp,sp,48
    80002810:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002812:	02059793          	slli	a5,a1,0x20
    80002816:	01e7d593          	srli	a1,a5,0x1e
    8000281a:	00b504b3          	add	s1,a0,a1
    8000281e:	0504a983          	lw	s3,80(s1)
    80002822:	fc099fe3          	bnez	s3,80002800 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002826:	4108                	lw	a0,0(a0)
    80002828:	00000097          	auipc	ra,0x0
    8000282c:	e4c080e7          	jalr	-436(ra) # 80002674 <balloc>
    80002830:	0005099b          	sext.w	s3,a0
    80002834:	0534a823          	sw	s3,80(s1)
    80002838:	b7e1                	j	80002800 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000283a:	4108                	lw	a0,0(a0)
    8000283c:	00000097          	auipc	ra,0x0
    80002840:	e38080e7          	jalr	-456(ra) # 80002674 <balloc>
    80002844:	0005059b          	sext.w	a1,a0
    80002848:	08b92023          	sw	a1,128(s2)
    8000284c:	b751                	j	800027d0 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000284e:	00092503          	lw	a0,0(s2)
    80002852:	00000097          	auipc	ra,0x0
    80002856:	e22080e7          	jalr	-478(ra) # 80002674 <balloc>
    8000285a:	0005099b          	sext.w	s3,a0
    8000285e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002862:	8552                	mv	a0,s4
    80002864:	00001097          	auipc	ra,0x1
    80002868:	f02080e7          	jalr	-254(ra) # 80003766 <log_write>
    8000286c:	b769                	j	800027f6 <bmap+0x54>
  panic("bmap: out of range");
    8000286e:	00006517          	auipc	a0,0x6
    80002872:	c8250513          	addi	a0,a0,-894 # 800084f0 <syscalls+0x128>
    80002876:	00003097          	auipc	ra,0x3
    8000287a:	3ba080e7          	jalr	954(ra) # 80005c30 <panic>

000000008000287e <iget>:
{
    8000287e:	7179                	addi	sp,sp,-48
    80002880:	f406                	sd	ra,40(sp)
    80002882:	f022                	sd	s0,32(sp)
    80002884:	ec26                	sd	s1,24(sp)
    80002886:	e84a                	sd	s2,16(sp)
    80002888:	e44e                	sd	s3,8(sp)
    8000288a:	e052                	sd	s4,0(sp)
    8000288c:	1800                	addi	s0,sp,48
    8000288e:	89aa                	mv	s3,a0
    80002890:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002892:	00015517          	auipc	a0,0x15
    80002896:	4e650513          	addi	a0,a0,1254 # 80017d78 <itable>
    8000289a:	00004097          	auipc	ra,0x4
    8000289e:	94c080e7          	jalr	-1716(ra) # 800061e6 <acquire>
  empty = 0;
    800028a2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028a4:	00015497          	auipc	s1,0x15
    800028a8:	4ec48493          	addi	s1,s1,1260 # 80017d90 <itable+0x18>
    800028ac:	00017697          	auipc	a3,0x17
    800028b0:	f7468693          	addi	a3,a3,-140 # 80019820 <log>
    800028b4:	a039                	j	800028c2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028b6:	02090b63          	beqz	s2,800028ec <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ba:	08848493          	addi	s1,s1,136
    800028be:	02d48a63          	beq	s1,a3,800028f2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028c2:	449c                	lw	a5,8(s1)
    800028c4:	fef059e3          	blez	a5,800028b6 <iget+0x38>
    800028c8:	4098                	lw	a4,0(s1)
    800028ca:	ff3716e3          	bne	a4,s3,800028b6 <iget+0x38>
    800028ce:	40d8                	lw	a4,4(s1)
    800028d0:	ff4713e3          	bne	a4,s4,800028b6 <iget+0x38>
      ip->ref++;
    800028d4:	2785                	addiw	a5,a5,1
    800028d6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028d8:	00015517          	auipc	a0,0x15
    800028dc:	4a050513          	addi	a0,a0,1184 # 80017d78 <itable>
    800028e0:	00004097          	auipc	ra,0x4
    800028e4:	9ba080e7          	jalr	-1606(ra) # 8000629a <release>
      return ip;
    800028e8:	8926                	mv	s2,s1
    800028ea:	a03d                	j	80002918 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028ec:	f7f9                	bnez	a5,800028ba <iget+0x3c>
    800028ee:	8926                	mv	s2,s1
    800028f0:	b7e9                	j	800028ba <iget+0x3c>
  if(empty == 0)
    800028f2:	02090c63          	beqz	s2,8000292a <iget+0xac>
  ip->dev = dev;
    800028f6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028fa:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028fe:	4785                	li	a5,1
    80002900:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002904:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002908:	00015517          	auipc	a0,0x15
    8000290c:	47050513          	addi	a0,a0,1136 # 80017d78 <itable>
    80002910:	00004097          	auipc	ra,0x4
    80002914:	98a080e7          	jalr	-1654(ra) # 8000629a <release>
}
    80002918:	854a                	mv	a0,s2
    8000291a:	70a2                	ld	ra,40(sp)
    8000291c:	7402                	ld	s0,32(sp)
    8000291e:	64e2                	ld	s1,24(sp)
    80002920:	6942                	ld	s2,16(sp)
    80002922:	69a2                	ld	s3,8(sp)
    80002924:	6a02                	ld	s4,0(sp)
    80002926:	6145                	addi	sp,sp,48
    80002928:	8082                	ret
    panic("iget: no inodes");
    8000292a:	00006517          	auipc	a0,0x6
    8000292e:	bde50513          	addi	a0,a0,-1058 # 80008508 <syscalls+0x140>
    80002932:	00003097          	auipc	ra,0x3
    80002936:	2fe080e7          	jalr	766(ra) # 80005c30 <panic>

000000008000293a <fsinit>:
fsinit(int dev) {
    8000293a:	7179                	addi	sp,sp,-48
    8000293c:	f406                	sd	ra,40(sp)
    8000293e:	f022                	sd	s0,32(sp)
    80002940:	ec26                	sd	s1,24(sp)
    80002942:	e84a                	sd	s2,16(sp)
    80002944:	e44e                	sd	s3,8(sp)
    80002946:	1800                	addi	s0,sp,48
    80002948:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000294a:	4585                	li	a1,1
    8000294c:	00000097          	auipc	ra,0x0
    80002950:	a66080e7          	jalr	-1434(ra) # 800023b2 <bread>
    80002954:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002956:	00015997          	auipc	s3,0x15
    8000295a:	40298993          	addi	s3,s3,1026 # 80017d58 <sb>
    8000295e:	02000613          	li	a2,32
    80002962:	05850593          	addi	a1,a0,88
    80002966:	854e                	mv	a0,s3
    80002968:	ffffe097          	auipc	ra,0xffffe
    8000296c:	86e080e7          	jalr	-1938(ra) # 800001d6 <memmove>
  brelse(bp);
    80002970:	8526                	mv	a0,s1
    80002972:	00000097          	auipc	ra,0x0
    80002976:	b70080e7          	jalr	-1168(ra) # 800024e2 <brelse>
  if(sb.magic != FSMAGIC)
    8000297a:	0009a703          	lw	a4,0(s3)
    8000297e:	102037b7          	lui	a5,0x10203
    80002982:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002986:	02f71263          	bne	a4,a5,800029aa <fsinit+0x70>
  initlog(dev, &sb);
    8000298a:	00015597          	auipc	a1,0x15
    8000298e:	3ce58593          	addi	a1,a1,974 # 80017d58 <sb>
    80002992:	854a                	mv	a0,s2
    80002994:	00001097          	auipc	ra,0x1
    80002998:	b56080e7          	jalr	-1194(ra) # 800034ea <initlog>
}
    8000299c:	70a2                	ld	ra,40(sp)
    8000299e:	7402                	ld	s0,32(sp)
    800029a0:	64e2                	ld	s1,24(sp)
    800029a2:	6942                	ld	s2,16(sp)
    800029a4:	69a2                	ld	s3,8(sp)
    800029a6:	6145                	addi	sp,sp,48
    800029a8:	8082                	ret
    panic("invalid file system");
    800029aa:	00006517          	auipc	a0,0x6
    800029ae:	b6e50513          	addi	a0,a0,-1170 # 80008518 <syscalls+0x150>
    800029b2:	00003097          	auipc	ra,0x3
    800029b6:	27e080e7          	jalr	638(ra) # 80005c30 <panic>

00000000800029ba <iinit>:
{
    800029ba:	7179                	addi	sp,sp,-48
    800029bc:	f406                	sd	ra,40(sp)
    800029be:	f022                	sd	s0,32(sp)
    800029c0:	ec26                	sd	s1,24(sp)
    800029c2:	e84a                	sd	s2,16(sp)
    800029c4:	e44e                	sd	s3,8(sp)
    800029c6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029c8:	00006597          	auipc	a1,0x6
    800029cc:	b6858593          	addi	a1,a1,-1176 # 80008530 <syscalls+0x168>
    800029d0:	00015517          	auipc	a0,0x15
    800029d4:	3a850513          	addi	a0,a0,936 # 80017d78 <itable>
    800029d8:	00003097          	auipc	ra,0x3
    800029dc:	77e080e7          	jalr	1918(ra) # 80006156 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029e0:	00015497          	auipc	s1,0x15
    800029e4:	3c048493          	addi	s1,s1,960 # 80017da0 <itable+0x28>
    800029e8:	00017997          	auipc	s3,0x17
    800029ec:	e4898993          	addi	s3,s3,-440 # 80019830 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029f0:	00006917          	auipc	s2,0x6
    800029f4:	b4890913          	addi	s2,s2,-1208 # 80008538 <syscalls+0x170>
    800029f8:	85ca                	mv	a1,s2
    800029fa:	8526                	mv	a0,s1
    800029fc:	00001097          	auipc	ra,0x1
    80002a00:	e4e080e7          	jalr	-434(ra) # 8000384a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a04:	08848493          	addi	s1,s1,136
    80002a08:	ff3498e3          	bne	s1,s3,800029f8 <iinit+0x3e>
}
    80002a0c:	70a2                	ld	ra,40(sp)
    80002a0e:	7402                	ld	s0,32(sp)
    80002a10:	64e2                	ld	s1,24(sp)
    80002a12:	6942                	ld	s2,16(sp)
    80002a14:	69a2                	ld	s3,8(sp)
    80002a16:	6145                	addi	sp,sp,48
    80002a18:	8082                	ret

0000000080002a1a <ialloc>:
{
    80002a1a:	715d                	addi	sp,sp,-80
    80002a1c:	e486                	sd	ra,72(sp)
    80002a1e:	e0a2                	sd	s0,64(sp)
    80002a20:	fc26                	sd	s1,56(sp)
    80002a22:	f84a                	sd	s2,48(sp)
    80002a24:	f44e                	sd	s3,40(sp)
    80002a26:	f052                	sd	s4,32(sp)
    80002a28:	ec56                	sd	s5,24(sp)
    80002a2a:	e85a                	sd	s6,16(sp)
    80002a2c:	e45e                	sd	s7,8(sp)
    80002a2e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a30:	00015717          	auipc	a4,0x15
    80002a34:	33472703          	lw	a4,820(a4) # 80017d64 <sb+0xc>
    80002a38:	4785                	li	a5,1
    80002a3a:	04e7fa63          	bgeu	a5,a4,80002a8e <ialloc+0x74>
    80002a3e:	8aaa                	mv	s5,a0
    80002a40:	8bae                	mv	s7,a1
    80002a42:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a44:	00015a17          	auipc	s4,0x15
    80002a48:	314a0a13          	addi	s4,s4,788 # 80017d58 <sb>
    80002a4c:	00048b1b          	sext.w	s6,s1
    80002a50:	0044d593          	srli	a1,s1,0x4
    80002a54:	018a2783          	lw	a5,24(s4)
    80002a58:	9dbd                	addw	a1,a1,a5
    80002a5a:	8556                	mv	a0,s5
    80002a5c:	00000097          	auipc	ra,0x0
    80002a60:	956080e7          	jalr	-1706(ra) # 800023b2 <bread>
    80002a64:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a66:	05850993          	addi	s3,a0,88
    80002a6a:	00f4f793          	andi	a5,s1,15
    80002a6e:	079a                	slli	a5,a5,0x6
    80002a70:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a72:	00099783          	lh	a5,0(s3)
    80002a76:	c785                	beqz	a5,80002a9e <ialloc+0x84>
    brelse(bp);
    80002a78:	00000097          	auipc	ra,0x0
    80002a7c:	a6a080e7          	jalr	-1430(ra) # 800024e2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a80:	0485                	addi	s1,s1,1
    80002a82:	00ca2703          	lw	a4,12(s4)
    80002a86:	0004879b          	sext.w	a5,s1
    80002a8a:	fce7e1e3          	bltu	a5,a4,80002a4c <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a8e:	00006517          	auipc	a0,0x6
    80002a92:	ab250513          	addi	a0,a0,-1358 # 80008540 <syscalls+0x178>
    80002a96:	00003097          	auipc	ra,0x3
    80002a9a:	19a080e7          	jalr	410(ra) # 80005c30 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a9e:	04000613          	li	a2,64
    80002aa2:	4581                	li	a1,0
    80002aa4:	854e                	mv	a0,s3
    80002aa6:	ffffd097          	auipc	ra,0xffffd
    80002aaa:	6d4080e7          	jalr	1748(ra) # 8000017a <memset>
      dip->type = type;
    80002aae:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ab2:	854a                	mv	a0,s2
    80002ab4:	00001097          	auipc	ra,0x1
    80002ab8:	cb2080e7          	jalr	-846(ra) # 80003766 <log_write>
      brelse(bp);
    80002abc:	854a                	mv	a0,s2
    80002abe:	00000097          	auipc	ra,0x0
    80002ac2:	a24080e7          	jalr	-1500(ra) # 800024e2 <brelse>
      return iget(dev, inum);
    80002ac6:	85da                	mv	a1,s6
    80002ac8:	8556                	mv	a0,s5
    80002aca:	00000097          	auipc	ra,0x0
    80002ace:	db4080e7          	jalr	-588(ra) # 8000287e <iget>
}
    80002ad2:	60a6                	ld	ra,72(sp)
    80002ad4:	6406                	ld	s0,64(sp)
    80002ad6:	74e2                	ld	s1,56(sp)
    80002ad8:	7942                	ld	s2,48(sp)
    80002ada:	79a2                	ld	s3,40(sp)
    80002adc:	7a02                	ld	s4,32(sp)
    80002ade:	6ae2                	ld	s5,24(sp)
    80002ae0:	6b42                	ld	s6,16(sp)
    80002ae2:	6ba2                	ld	s7,8(sp)
    80002ae4:	6161                	addi	sp,sp,80
    80002ae6:	8082                	ret

0000000080002ae8 <iupdate>:
{
    80002ae8:	1101                	addi	sp,sp,-32
    80002aea:	ec06                	sd	ra,24(sp)
    80002aec:	e822                	sd	s0,16(sp)
    80002aee:	e426                	sd	s1,8(sp)
    80002af0:	e04a                	sd	s2,0(sp)
    80002af2:	1000                	addi	s0,sp,32
    80002af4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002af6:	415c                	lw	a5,4(a0)
    80002af8:	0047d79b          	srliw	a5,a5,0x4
    80002afc:	00015597          	auipc	a1,0x15
    80002b00:	2745a583          	lw	a1,628(a1) # 80017d70 <sb+0x18>
    80002b04:	9dbd                	addw	a1,a1,a5
    80002b06:	4108                	lw	a0,0(a0)
    80002b08:	00000097          	auipc	ra,0x0
    80002b0c:	8aa080e7          	jalr	-1878(ra) # 800023b2 <bread>
    80002b10:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b12:	05850793          	addi	a5,a0,88
    80002b16:	40d8                	lw	a4,4(s1)
    80002b18:	8b3d                	andi	a4,a4,15
    80002b1a:	071a                	slli	a4,a4,0x6
    80002b1c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b1e:	04449703          	lh	a4,68(s1)
    80002b22:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b26:	04649703          	lh	a4,70(s1)
    80002b2a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b2e:	04849703          	lh	a4,72(s1)
    80002b32:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b36:	04a49703          	lh	a4,74(s1)
    80002b3a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b3e:	44f8                	lw	a4,76(s1)
    80002b40:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b42:	03400613          	li	a2,52
    80002b46:	05048593          	addi	a1,s1,80
    80002b4a:	00c78513          	addi	a0,a5,12
    80002b4e:	ffffd097          	auipc	ra,0xffffd
    80002b52:	688080e7          	jalr	1672(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b56:	854a                	mv	a0,s2
    80002b58:	00001097          	auipc	ra,0x1
    80002b5c:	c0e080e7          	jalr	-1010(ra) # 80003766 <log_write>
  brelse(bp);
    80002b60:	854a                	mv	a0,s2
    80002b62:	00000097          	auipc	ra,0x0
    80002b66:	980080e7          	jalr	-1664(ra) # 800024e2 <brelse>
}
    80002b6a:	60e2                	ld	ra,24(sp)
    80002b6c:	6442                	ld	s0,16(sp)
    80002b6e:	64a2                	ld	s1,8(sp)
    80002b70:	6902                	ld	s2,0(sp)
    80002b72:	6105                	addi	sp,sp,32
    80002b74:	8082                	ret

0000000080002b76 <idup>:
{
    80002b76:	1101                	addi	sp,sp,-32
    80002b78:	ec06                	sd	ra,24(sp)
    80002b7a:	e822                	sd	s0,16(sp)
    80002b7c:	e426                	sd	s1,8(sp)
    80002b7e:	1000                	addi	s0,sp,32
    80002b80:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b82:	00015517          	auipc	a0,0x15
    80002b86:	1f650513          	addi	a0,a0,502 # 80017d78 <itable>
    80002b8a:	00003097          	auipc	ra,0x3
    80002b8e:	65c080e7          	jalr	1628(ra) # 800061e6 <acquire>
  ip->ref++;
    80002b92:	449c                	lw	a5,8(s1)
    80002b94:	2785                	addiw	a5,a5,1
    80002b96:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b98:	00015517          	auipc	a0,0x15
    80002b9c:	1e050513          	addi	a0,a0,480 # 80017d78 <itable>
    80002ba0:	00003097          	auipc	ra,0x3
    80002ba4:	6fa080e7          	jalr	1786(ra) # 8000629a <release>
}
    80002ba8:	8526                	mv	a0,s1
    80002baa:	60e2                	ld	ra,24(sp)
    80002bac:	6442                	ld	s0,16(sp)
    80002bae:	64a2                	ld	s1,8(sp)
    80002bb0:	6105                	addi	sp,sp,32
    80002bb2:	8082                	ret

0000000080002bb4 <ilock>:
{
    80002bb4:	1101                	addi	sp,sp,-32
    80002bb6:	ec06                	sd	ra,24(sp)
    80002bb8:	e822                	sd	s0,16(sp)
    80002bba:	e426                	sd	s1,8(sp)
    80002bbc:	e04a                	sd	s2,0(sp)
    80002bbe:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bc0:	c115                	beqz	a0,80002be4 <ilock+0x30>
    80002bc2:	84aa                	mv	s1,a0
    80002bc4:	451c                	lw	a5,8(a0)
    80002bc6:	00f05f63          	blez	a5,80002be4 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bca:	0541                	addi	a0,a0,16
    80002bcc:	00001097          	auipc	ra,0x1
    80002bd0:	cb8080e7          	jalr	-840(ra) # 80003884 <acquiresleep>
  if(ip->valid == 0){
    80002bd4:	40bc                	lw	a5,64(s1)
    80002bd6:	cf99                	beqz	a5,80002bf4 <ilock+0x40>
}
    80002bd8:	60e2                	ld	ra,24(sp)
    80002bda:	6442                	ld	s0,16(sp)
    80002bdc:	64a2                	ld	s1,8(sp)
    80002bde:	6902                	ld	s2,0(sp)
    80002be0:	6105                	addi	sp,sp,32
    80002be2:	8082                	ret
    panic("ilock");
    80002be4:	00006517          	auipc	a0,0x6
    80002be8:	97450513          	addi	a0,a0,-1676 # 80008558 <syscalls+0x190>
    80002bec:	00003097          	auipc	ra,0x3
    80002bf0:	044080e7          	jalr	68(ra) # 80005c30 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bf4:	40dc                	lw	a5,4(s1)
    80002bf6:	0047d79b          	srliw	a5,a5,0x4
    80002bfa:	00015597          	auipc	a1,0x15
    80002bfe:	1765a583          	lw	a1,374(a1) # 80017d70 <sb+0x18>
    80002c02:	9dbd                	addw	a1,a1,a5
    80002c04:	4088                	lw	a0,0(s1)
    80002c06:	fffff097          	auipc	ra,0xfffff
    80002c0a:	7ac080e7          	jalr	1964(ra) # 800023b2 <bread>
    80002c0e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c10:	05850593          	addi	a1,a0,88
    80002c14:	40dc                	lw	a5,4(s1)
    80002c16:	8bbd                	andi	a5,a5,15
    80002c18:	079a                	slli	a5,a5,0x6
    80002c1a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c1c:	00059783          	lh	a5,0(a1)
    80002c20:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c24:	00259783          	lh	a5,2(a1)
    80002c28:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c2c:	00459783          	lh	a5,4(a1)
    80002c30:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c34:	00659783          	lh	a5,6(a1)
    80002c38:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c3c:	459c                	lw	a5,8(a1)
    80002c3e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c40:	03400613          	li	a2,52
    80002c44:	05b1                	addi	a1,a1,12
    80002c46:	05048513          	addi	a0,s1,80
    80002c4a:	ffffd097          	auipc	ra,0xffffd
    80002c4e:	58c080e7          	jalr	1420(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c52:	854a                	mv	a0,s2
    80002c54:	00000097          	auipc	ra,0x0
    80002c58:	88e080e7          	jalr	-1906(ra) # 800024e2 <brelse>
    ip->valid = 1;
    80002c5c:	4785                	li	a5,1
    80002c5e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c60:	04449783          	lh	a5,68(s1)
    80002c64:	fbb5                	bnez	a5,80002bd8 <ilock+0x24>
      panic("ilock: no type");
    80002c66:	00006517          	auipc	a0,0x6
    80002c6a:	8fa50513          	addi	a0,a0,-1798 # 80008560 <syscalls+0x198>
    80002c6e:	00003097          	auipc	ra,0x3
    80002c72:	fc2080e7          	jalr	-62(ra) # 80005c30 <panic>

0000000080002c76 <iunlock>:
{
    80002c76:	1101                	addi	sp,sp,-32
    80002c78:	ec06                	sd	ra,24(sp)
    80002c7a:	e822                	sd	s0,16(sp)
    80002c7c:	e426                	sd	s1,8(sp)
    80002c7e:	e04a                	sd	s2,0(sp)
    80002c80:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c82:	c905                	beqz	a0,80002cb2 <iunlock+0x3c>
    80002c84:	84aa                	mv	s1,a0
    80002c86:	01050913          	addi	s2,a0,16
    80002c8a:	854a                	mv	a0,s2
    80002c8c:	00001097          	auipc	ra,0x1
    80002c90:	c92080e7          	jalr	-878(ra) # 8000391e <holdingsleep>
    80002c94:	cd19                	beqz	a0,80002cb2 <iunlock+0x3c>
    80002c96:	449c                	lw	a5,8(s1)
    80002c98:	00f05d63          	blez	a5,80002cb2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c9c:	854a                	mv	a0,s2
    80002c9e:	00001097          	auipc	ra,0x1
    80002ca2:	c3c080e7          	jalr	-964(ra) # 800038da <releasesleep>
}
    80002ca6:	60e2                	ld	ra,24(sp)
    80002ca8:	6442                	ld	s0,16(sp)
    80002caa:	64a2                	ld	s1,8(sp)
    80002cac:	6902                	ld	s2,0(sp)
    80002cae:	6105                	addi	sp,sp,32
    80002cb0:	8082                	ret
    panic("iunlock");
    80002cb2:	00006517          	auipc	a0,0x6
    80002cb6:	8be50513          	addi	a0,a0,-1858 # 80008570 <syscalls+0x1a8>
    80002cba:	00003097          	auipc	ra,0x3
    80002cbe:	f76080e7          	jalr	-138(ra) # 80005c30 <panic>

0000000080002cc2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cc2:	7179                	addi	sp,sp,-48
    80002cc4:	f406                	sd	ra,40(sp)
    80002cc6:	f022                	sd	s0,32(sp)
    80002cc8:	ec26                	sd	s1,24(sp)
    80002cca:	e84a                	sd	s2,16(sp)
    80002ccc:	e44e                	sd	s3,8(sp)
    80002cce:	e052                	sd	s4,0(sp)
    80002cd0:	1800                	addi	s0,sp,48
    80002cd2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cd4:	05050493          	addi	s1,a0,80
    80002cd8:	08050913          	addi	s2,a0,128
    80002cdc:	a021                	j	80002ce4 <itrunc+0x22>
    80002cde:	0491                	addi	s1,s1,4
    80002ce0:	01248d63          	beq	s1,s2,80002cfa <itrunc+0x38>
    if(ip->addrs[i]){
    80002ce4:	408c                	lw	a1,0(s1)
    80002ce6:	dde5                	beqz	a1,80002cde <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ce8:	0009a503          	lw	a0,0(s3)
    80002cec:	00000097          	auipc	ra,0x0
    80002cf0:	90c080e7          	jalr	-1780(ra) # 800025f8 <bfree>
      ip->addrs[i] = 0;
    80002cf4:	0004a023          	sw	zero,0(s1)
    80002cf8:	b7dd                	j	80002cde <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cfa:	0809a583          	lw	a1,128(s3)
    80002cfe:	e185                	bnez	a1,80002d1e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d00:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d04:	854e                	mv	a0,s3
    80002d06:	00000097          	auipc	ra,0x0
    80002d0a:	de2080e7          	jalr	-542(ra) # 80002ae8 <iupdate>
}
    80002d0e:	70a2                	ld	ra,40(sp)
    80002d10:	7402                	ld	s0,32(sp)
    80002d12:	64e2                	ld	s1,24(sp)
    80002d14:	6942                	ld	s2,16(sp)
    80002d16:	69a2                	ld	s3,8(sp)
    80002d18:	6a02                	ld	s4,0(sp)
    80002d1a:	6145                	addi	sp,sp,48
    80002d1c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d1e:	0009a503          	lw	a0,0(s3)
    80002d22:	fffff097          	auipc	ra,0xfffff
    80002d26:	690080e7          	jalr	1680(ra) # 800023b2 <bread>
    80002d2a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d2c:	05850493          	addi	s1,a0,88
    80002d30:	45850913          	addi	s2,a0,1112
    80002d34:	a021                	j	80002d3c <itrunc+0x7a>
    80002d36:	0491                	addi	s1,s1,4
    80002d38:	01248b63          	beq	s1,s2,80002d4e <itrunc+0x8c>
      if(a[j])
    80002d3c:	408c                	lw	a1,0(s1)
    80002d3e:	dde5                	beqz	a1,80002d36 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d40:	0009a503          	lw	a0,0(s3)
    80002d44:	00000097          	auipc	ra,0x0
    80002d48:	8b4080e7          	jalr	-1868(ra) # 800025f8 <bfree>
    80002d4c:	b7ed                	j	80002d36 <itrunc+0x74>
    brelse(bp);
    80002d4e:	8552                	mv	a0,s4
    80002d50:	fffff097          	auipc	ra,0xfffff
    80002d54:	792080e7          	jalr	1938(ra) # 800024e2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d58:	0809a583          	lw	a1,128(s3)
    80002d5c:	0009a503          	lw	a0,0(s3)
    80002d60:	00000097          	auipc	ra,0x0
    80002d64:	898080e7          	jalr	-1896(ra) # 800025f8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d68:	0809a023          	sw	zero,128(s3)
    80002d6c:	bf51                	j	80002d00 <itrunc+0x3e>

0000000080002d6e <iput>:
{
    80002d6e:	1101                	addi	sp,sp,-32
    80002d70:	ec06                	sd	ra,24(sp)
    80002d72:	e822                	sd	s0,16(sp)
    80002d74:	e426                	sd	s1,8(sp)
    80002d76:	e04a                	sd	s2,0(sp)
    80002d78:	1000                	addi	s0,sp,32
    80002d7a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d7c:	00015517          	auipc	a0,0x15
    80002d80:	ffc50513          	addi	a0,a0,-4 # 80017d78 <itable>
    80002d84:	00003097          	auipc	ra,0x3
    80002d88:	462080e7          	jalr	1122(ra) # 800061e6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d8c:	4498                	lw	a4,8(s1)
    80002d8e:	4785                	li	a5,1
    80002d90:	02f70363          	beq	a4,a5,80002db6 <iput+0x48>
  ip->ref--;
    80002d94:	449c                	lw	a5,8(s1)
    80002d96:	37fd                	addiw	a5,a5,-1
    80002d98:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d9a:	00015517          	auipc	a0,0x15
    80002d9e:	fde50513          	addi	a0,a0,-34 # 80017d78 <itable>
    80002da2:	00003097          	auipc	ra,0x3
    80002da6:	4f8080e7          	jalr	1272(ra) # 8000629a <release>
}
    80002daa:	60e2                	ld	ra,24(sp)
    80002dac:	6442                	ld	s0,16(sp)
    80002dae:	64a2                	ld	s1,8(sp)
    80002db0:	6902                	ld	s2,0(sp)
    80002db2:	6105                	addi	sp,sp,32
    80002db4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002db6:	40bc                	lw	a5,64(s1)
    80002db8:	dff1                	beqz	a5,80002d94 <iput+0x26>
    80002dba:	04a49783          	lh	a5,74(s1)
    80002dbe:	fbf9                	bnez	a5,80002d94 <iput+0x26>
    acquiresleep(&ip->lock);
    80002dc0:	01048913          	addi	s2,s1,16
    80002dc4:	854a                	mv	a0,s2
    80002dc6:	00001097          	auipc	ra,0x1
    80002dca:	abe080e7          	jalr	-1346(ra) # 80003884 <acquiresleep>
    release(&itable.lock);
    80002dce:	00015517          	auipc	a0,0x15
    80002dd2:	faa50513          	addi	a0,a0,-86 # 80017d78 <itable>
    80002dd6:	00003097          	auipc	ra,0x3
    80002dda:	4c4080e7          	jalr	1220(ra) # 8000629a <release>
    itrunc(ip);
    80002dde:	8526                	mv	a0,s1
    80002de0:	00000097          	auipc	ra,0x0
    80002de4:	ee2080e7          	jalr	-286(ra) # 80002cc2 <itrunc>
    ip->type = 0;
    80002de8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dec:	8526                	mv	a0,s1
    80002dee:	00000097          	auipc	ra,0x0
    80002df2:	cfa080e7          	jalr	-774(ra) # 80002ae8 <iupdate>
    ip->valid = 0;
    80002df6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002dfa:	854a                	mv	a0,s2
    80002dfc:	00001097          	auipc	ra,0x1
    80002e00:	ade080e7          	jalr	-1314(ra) # 800038da <releasesleep>
    acquire(&itable.lock);
    80002e04:	00015517          	auipc	a0,0x15
    80002e08:	f7450513          	addi	a0,a0,-140 # 80017d78 <itable>
    80002e0c:	00003097          	auipc	ra,0x3
    80002e10:	3da080e7          	jalr	986(ra) # 800061e6 <acquire>
    80002e14:	b741                	j	80002d94 <iput+0x26>

0000000080002e16 <iunlockput>:
{
    80002e16:	1101                	addi	sp,sp,-32
    80002e18:	ec06                	sd	ra,24(sp)
    80002e1a:	e822                	sd	s0,16(sp)
    80002e1c:	e426                	sd	s1,8(sp)
    80002e1e:	1000                	addi	s0,sp,32
    80002e20:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e22:	00000097          	auipc	ra,0x0
    80002e26:	e54080e7          	jalr	-428(ra) # 80002c76 <iunlock>
  iput(ip);
    80002e2a:	8526                	mv	a0,s1
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	f42080e7          	jalr	-190(ra) # 80002d6e <iput>
}
    80002e34:	60e2                	ld	ra,24(sp)
    80002e36:	6442                	ld	s0,16(sp)
    80002e38:	64a2                	ld	s1,8(sp)
    80002e3a:	6105                	addi	sp,sp,32
    80002e3c:	8082                	ret

0000000080002e3e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e3e:	1141                	addi	sp,sp,-16
    80002e40:	e422                	sd	s0,8(sp)
    80002e42:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e44:	411c                	lw	a5,0(a0)
    80002e46:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e48:	415c                	lw	a5,4(a0)
    80002e4a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e4c:	04451783          	lh	a5,68(a0)
    80002e50:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e54:	04a51783          	lh	a5,74(a0)
    80002e58:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e5c:	04c56783          	lwu	a5,76(a0)
    80002e60:	e99c                	sd	a5,16(a1)
}
    80002e62:	6422                	ld	s0,8(sp)
    80002e64:	0141                	addi	sp,sp,16
    80002e66:	8082                	ret

0000000080002e68 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e68:	457c                	lw	a5,76(a0)
    80002e6a:	0ed7e963          	bltu	a5,a3,80002f5c <readi+0xf4>
{
    80002e6e:	7159                	addi	sp,sp,-112
    80002e70:	f486                	sd	ra,104(sp)
    80002e72:	f0a2                	sd	s0,96(sp)
    80002e74:	eca6                	sd	s1,88(sp)
    80002e76:	e8ca                	sd	s2,80(sp)
    80002e78:	e4ce                	sd	s3,72(sp)
    80002e7a:	e0d2                	sd	s4,64(sp)
    80002e7c:	fc56                	sd	s5,56(sp)
    80002e7e:	f85a                	sd	s6,48(sp)
    80002e80:	f45e                	sd	s7,40(sp)
    80002e82:	f062                	sd	s8,32(sp)
    80002e84:	ec66                	sd	s9,24(sp)
    80002e86:	e86a                	sd	s10,16(sp)
    80002e88:	e46e                	sd	s11,8(sp)
    80002e8a:	1880                	addi	s0,sp,112
    80002e8c:	8baa                	mv	s7,a0
    80002e8e:	8c2e                	mv	s8,a1
    80002e90:	8ab2                	mv	s5,a2
    80002e92:	84b6                	mv	s1,a3
    80002e94:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e96:	9f35                	addw	a4,a4,a3
    return 0;
    80002e98:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e9a:	0ad76063          	bltu	a4,a3,80002f3a <readi+0xd2>
  if(off + n > ip->size)
    80002e9e:	00e7f463          	bgeu	a5,a4,80002ea6 <readi+0x3e>
    n = ip->size - off;
    80002ea2:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ea6:	0a0b0963          	beqz	s6,80002f58 <readi+0xf0>
    80002eaa:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eac:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002eb0:	5cfd                	li	s9,-1
    80002eb2:	a82d                	j	80002eec <readi+0x84>
    80002eb4:	020a1d93          	slli	s11,s4,0x20
    80002eb8:	020ddd93          	srli	s11,s11,0x20
    80002ebc:	05890613          	addi	a2,s2,88
    80002ec0:	86ee                	mv	a3,s11
    80002ec2:	963a                	add	a2,a2,a4
    80002ec4:	85d6                	mv	a1,s5
    80002ec6:	8562                	mv	a0,s8
    80002ec8:	fffff097          	auipc	ra,0xfffff
    80002ecc:	a28080e7          	jalr	-1496(ra) # 800018f0 <either_copyout>
    80002ed0:	05950d63          	beq	a0,s9,80002f2a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ed4:	854a                	mv	a0,s2
    80002ed6:	fffff097          	auipc	ra,0xfffff
    80002eda:	60c080e7          	jalr	1548(ra) # 800024e2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ede:	013a09bb          	addw	s3,s4,s3
    80002ee2:	009a04bb          	addw	s1,s4,s1
    80002ee6:	9aee                	add	s5,s5,s11
    80002ee8:	0569f763          	bgeu	s3,s6,80002f36 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002eec:	000ba903          	lw	s2,0(s7)
    80002ef0:	00a4d59b          	srliw	a1,s1,0xa
    80002ef4:	855e                	mv	a0,s7
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	8ac080e7          	jalr	-1876(ra) # 800027a2 <bmap>
    80002efe:	0005059b          	sext.w	a1,a0
    80002f02:	854a                	mv	a0,s2
    80002f04:	fffff097          	auipc	ra,0xfffff
    80002f08:	4ae080e7          	jalr	1198(ra) # 800023b2 <bread>
    80002f0c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f0e:	3ff4f713          	andi	a4,s1,1023
    80002f12:	40ed07bb          	subw	a5,s10,a4
    80002f16:	413b06bb          	subw	a3,s6,s3
    80002f1a:	8a3e                	mv	s4,a5
    80002f1c:	2781                	sext.w	a5,a5
    80002f1e:	0006861b          	sext.w	a2,a3
    80002f22:	f8f679e3          	bgeu	a2,a5,80002eb4 <readi+0x4c>
    80002f26:	8a36                	mv	s4,a3
    80002f28:	b771                	j	80002eb4 <readi+0x4c>
      brelse(bp);
    80002f2a:	854a                	mv	a0,s2
    80002f2c:	fffff097          	auipc	ra,0xfffff
    80002f30:	5b6080e7          	jalr	1462(ra) # 800024e2 <brelse>
      tot = -1;
    80002f34:	59fd                	li	s3,-1
  }
  return tot;
    80002f36:	0009851b          	sext.w	a0,s3
}
    80002f3a:	70a6                	ld	ra,104(sp)
    80002f3c:	7406                	ld	s0,96(sp)
    80002f3e:	64e6                	ld	s1,88(sp)
    80002f40:	6946                	ld	s2,80(sp)
    80002f42:	69a6                	ld	s3,72(sp)
    80002f44:	6a06                	ld	s4,64(sp)
    80002f46:	7ae2                	ld	s5,56(sp)
    80002f48:	7b42                	ld	s6,48(sp)
    80002f4a:	7ba2                	ld	s7,40(sp)
    80002f4c:	7c02                	ld	s8,32(sp)
    80002f4e:	6ce2                	ld	s9,24(sp)
    80002f50:	6d42                	ld	s10,16(sp)
    80002f52:	6da2                	ld	s11,8(sp)
    80002f54:	6165                	addi	sp,sp,112
    80002f56:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f58:	89da                	mv	s3,s6
    80002f5a:	bff1                	j	80002f36 <readi+0xce>
    return 0;
    80002f5c:	4501                	li	a0,0
}
    80002f5e:	8082                	ret

0000000080002f60 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f60:	457c                	lw	a5,76(a0)
    80002f62:	10d7e863          	bltu	a5,a3,80003072 <writei+0x112>
{
    80002f66:	7159                	addi	sp,sp,-112
    80002f68:	f486                	sd	ra,104(sp)
    80002f6a:	f0a2                	sd	s0,96(sp)
    80002f6c:	eca6                	sd	s1,88(sp)
    80002f6e:	e8ca                	sd	s2,80(sp)
    80002f70:	e4ce                	sd	s3,72(sp)
    80002f72:	e0d2                	sd	s4,64(sp)
    80002f74:	fc56                	sd	s5,56(sp)
    80002f76:	f85a                	sd	s6,48(sp)
    80002f78:	f45e                	sd	s7,40(sp)
    80002f7a:	f062                	sd	s8,32(sp)
    80002f7c:	ec66                	sd	s9,24(sp)
    80002f7e:	e86a                	sd	s10,16(sp)
    80002f80:	e46e                	sd	s11,8(sp)
    80002f82:	1880                	addi	s0,sp,112
    80002f84:	8b2a                	mv	s6,a0
    80002f86:	8c2e                	mv	s8,a1
    80002f88:	8ab2                	mv	s5,a2
    80002f8a:	8936                	mv	s2,a3
    80002f8c:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f8e:	00e687bb          	addw	a5,a3,a4
    80002f92:	0ed7e263          	bltu	a5,a3,80003076 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f96:	00043737          	lui	a4,0x43
    80002f9a:	0ef76063          	bltu	a4,a5,8000307a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f9e:	0c0b8863          	beqz	s7,8000306e <writei+0x10e>
    80002fa2:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fa4:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fa8:	5cfd                	li	s9,-1
    80002faa:	a091                	j	80002fee <writei+0x8e>
    80002fac:	02099d93          	slli	s11,s3,0x20
    80002fb0:	020ddd93          	srli	s11,s11,0x20
    80002fb4:	05848513          	addi	a0,s1,88
    80002fb8:	86ee                	mv	a3,s11
    80002fba:	8656                	mv	a2,s5
    80002fbc:	85e2                	mv	a1,s8
    80002fbe:	953a                	add	a0,a0,a4
    80002fc0:	fffff097          	auipc	ra,0xfffff
    80002fc4:	986080e7          	jalr	-1658(ra) # 80001946 <either_copyin>
    80002fc8:	07950263          	beq	a0,s9,8000302c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fcc:	8526                	mv	a0,s1
    80002fce:	00000097          	auipc	ra,0x0
    80002fd2:	798080e7          	jalr	1944(ra) # 80003766 <log_write>
    brelse(bp);
    80002fd6:	8526                	mv	a0,s1
    80002fd8:	fffff097          	auipc	ra,0xfffff
    80002fdc:	50a080e7          	jalr	1290(ra) # 800024e2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fe0:	01498a3b          	addw	s4,s3,s4
    80002fe4:	0129893b          	addw	s2,s3,s2
    80002fe8:	9aee                	add	s5,s5,s11
    80002fea:	057a7663          	bgeu	s4,s7,80003036 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fee:	000b2483          	lw	s1,0(s6)
    80002ff2:	00a9559b          	srliw	a1,s2,0xa
    80002ff6:	855a                	mv	a0,s6
    80002ff8:	fffff097          	auipc	ra,0xfffff
    80002ffc:	7aa080e7          	jalr	1962(ra) # 800027a2 <bmap>
    80003000:	0005059b          	sext.w	a1,a0
    80003004:	8526                	mv	a0,s1
    80003006:	fffff097          	auipc	ra,0xfffff
    8000300a:	3ac080e7          	jalr	940(ra) # 800023b2 <bread>
    8000300e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003010:	3ff97713          	andi	a4,s2,1023
    80003014:	40ed07bb          	subw	a5,s10,a4
    80003018:	414b86bb          	subw	a3,s7,s4
    8000301c:	89be                	mv	s3,a5
    8000301e:	2781                	sext.w	a5,a5
    80003020:	0006861b          	sext.w	a2,a3
    80003024:	f8f674e3          	bgeu	a2,a5,80002fac <writei+0x4c>
    80003028:	89b6                	mv	s3,a3
    8000302a:	b749                	j	80002fac <writei+0x4c>
      brelse(bp);
    8000302c:	8526                	mv	a0,s1
    8000302e:	fffff097          	auipc	ra,0xfffff
    80003032:	4b4080e7          	jalr	1204(ra) # 800024e2 <brelse>
  }

  if(off > ip->size)
    80003036:	04cb2783          	lw	a5,76(s6)
    8000303a:	0127f463          	bgeu	a5,s2,80003042 <writei+0xe2>
    ip->size = off;
    8000303e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003042:	855a                	mv	a0,s6
    80003044:	00000097          	auipc	ra,0x0
    80003048:	aa4080e7          	jalr	-1372(ra) # 80002ae8 <iupdate>

  return tot;
    8000304c:	000a051b          	sext.w	a0,s4
}
    80003050:	70a6                	ld	ra,104(sp)
    80003052:	7406                	ld	s0,96(sp)
    80003054:	64e6                	ld	s1,88(sp)
    80003056:	6946                	ld	s2,80(sp)
    80003058:	69a6                	ld	s3,72(sp)
    8000305a:	6a06                	ld	s4,64(sp)
    8000305c:	7ae2                	ld	s5,56(sp)
    8000305e:	7b42                	ld	s6,48(sp)
    80003060:	7ba2                	ld	s7,40(sp)
    80003062:	7c02                	ld	s8,32(sp)
    80003064:	6ce2                	ld	s9,24(sp)
    80003066:	6d42                	ld	s10,16(sp)
    80003068:	6da2                	ld	s11,8(sp)
    8000306a:	6165                	addi	sp,sp,112
    8000306c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000306e:	8a5e                	mv	s4,s7
    80003070:	bfc9                	j	80003042 <writei+0xe2>
    return -1;
    80003072:	557d                	li	a0,-1
}
    80003074:	8082                	ret
    return -1;
    80003076:	557d                	li	a0,-1
    80003078:	bfe1                	j	80003050 <writei+0xf0>
    return -1;
    8000307a:	557d                	li	a0,-1
    8000307c:	bfd1                	j	80003050 <writei+0xf0>

000000008000307e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000307e:	1141                	addi	sp,sp,-16
    80003080:	e406                	sd	ra,8(sp)
    80003082:	e022                	sd	s0,0(sp)
    80003084:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003086:	4639                	li	a2,14
    80003088:	ffffd097          	auipc	ra,0xffffd
    8000308c:	1c2080e7          	jalr	450(ra) # 8000024a <strncmp>
}
    80003090:	60a2                	ld	ra,8(sp)
    80003092:	6402                	ld	s0,0(sp)
    80003094:	0141                	addi	sp,sp,16
    80003096:	8082                	ret

0000000080003098 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003098:	7139                	addi	sp,sp,-64
    8000309a:	fc06                	sd	ra,56(sp)
    8000309c:	f822                	sd	s0,48(sp)
    8000309e:	f426                	sd	s1,40(sp)
    800030a0:	f04a                	sd	s2,32(sp)
    800030a2:	ec4e                	sd	s3,24(sp)
    800030a4:	e852                	sd	s4,16(sp)
    800030a6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030a8:	04451703          	lh	a4,68(a0)
    800030ac:	4785                	li	a5,1
    800030ae:	00f71a63          	bne	a4,a5,800030c2 <dirlookup+0x2a>
    800030b2:	892a                	mv	s2,a0
    800030b4:	89ae                	mv	s3,a1
    800030b6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030b8:	457c                	lw	a5,76(a0)
    800030ba:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030bc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030be:	e79d                	bnez	a5,800030ec <dirlookup+0x54>
    800030c0:	a8a5                	j	80003138 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030c2:	00005517          	auipc	a0,0x5
    800030c6:	4b650513          	addi	a0,a0,1206 # 80008578 <syscalls+0x1b0>
    800030ca:	00003097          	auipc	ra,0x3
    800030ce:	b66080e7          	jalr	-1178(ra) # 80005c30 <panic>
      panic("dirlookup read");
    800030d2:	00005517          	auipc	a0,0x5
    800030d6:	4be50513          	addi	a0,a0,1214 # 80008590 <syscalls+0x1c8>
    800030da:	00003097          	auipc	ra,0x3
    800030de:	b56080e7          	jalr	-1194(ra) # 80005c30 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030e2:	24c1                	addiw	s1,s1,16
    800030e4:	04c92783          	lw	a5,76(s2)
    800030e8:	04f4f763          	bgeu	s1,a5,80003136 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030ec:	4741                	li	a4,16
    800030ee:	86a6                	mv	a3,s1
    800030f0:	fc040613          	addi	a2,s0,-64
    800030f4:	4581                	li	a1,0
    800030f6:	854a                	mv	a0,s2
    800030f8:	00000097          	auipc	ra,0x0
    800030fc:	d70080e7          	jalr	-656(ra) # 80002e68 <readi>
    80003100:	47c1                	li	a5,16
    80003102:	fcf518e3          	bne	a0,a5,800030d2 <dirlookup+0x3a>
    if(de.inum == 0)
    80003106:	fc045783          	lhu	a5,-64(s0)
    8000310a:	dfe1                	beqz	a5,800030e2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000310c:	fc240593          	addi	a1,s0,-62
    80003110:	854e                	mv	a0,s3
    80003112:	00000097          	auipc	ra,0x0
    80003116:	f6c080e7          	jalr	-148(ra) # 8000307e <namecmp>
    8000311a:	f561                	bnez	a0,800030e2 <dirlookup+0x4a>
      if(poff)
    8000311c:	000a0463          	beqz	s4,80003124 <dirlookup+0x8c>
        *poff = off;
    80003120:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003124:	fc045583          	lhu	a1,-64(s0)
    80003128:	00092503          	lw	a0,0(s2)
    8000312c:	fffff097          	auipc	ra,0xfffff
    80003130:	752080e7          	jalr	1874(ra) # 8000287e <iget>
    80003134:	a011                	j	80003138 <dirlookup+0xa0>
  return 0;
    80003136:	4501                	li	a0,0
}
    80003138:	70e2                	ld	ra,56(sp)
    8000313a:	7442                	ld	s0,48(sp)
    8000313c:	74a2                	ld	s1,40(sp)
    8000313e:	7902                	ld	s2,32(sp)
    80003140:	69e2                	ld	s3,24(sp)
    80003142:	6a42                	ld	s4,16(sp)
    80003144:	6121                	addi	sp,sp,64
    80003146:	8082                	ret

0000000080003148 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003148:	711d                	addi	sp,sp,-96
    8000314a:	ec86                	sd	ra,88(sp)
    8000314c:	e8a2                	sd	s0,80(sp)
    8000314e:	e4a6                	sd	s1,72(sp)
    80003150:	e0ca                	sd	s2,64(sp)
    80003152:	fc4e                	sd	s3,56(sp)
    80003154:	f852                	sd	s4,48(sp)
    80003156:	f456                	sd	s5,40(sp)
    80003158:	f05a                	sd	s6,32(sp)
    8000315a:	ec5e                	sd	s7,24(sp)
    8000315c:	e862                	sd	s8,16(sp)
    8000315e:	e466                	sd	s9,8(sp)
    80003160:	e06a                	sd	s10,0(sp)
    80003162:	1080                	addi	s0,sp,96
    80003164:	84aa                	mv	s1,a0
    80003166:	8b2e                	mv	s6,a1
    80003168:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000316a:	00054703          	lbu	a4,0(a0)
    8000316e:	02f00793          	li	a5,47
    80003172:	02f70363          	beq	a4,a5,80003198 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003176:	ffffe097          	auipc	ra,0xffffe
    8000317a:	cce080e7          	jalr	-818(ra) # 80000e44 <myproc>
    8000317e:	15053503          	ld	a0,336(a0)
    80003182:	00000097          	auipc	ra,0x0
    80003186:	9f4080e7          	jalr	-1548(ra) # 80002b76 <idup>
    8000318a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000318c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003190:	4cb5                	li	s9,13
  len = path - s;
    80003192:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003194:	4c05                	li	s8,1
    80003196:	a87d                	j	80003254 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003198:	4585                	li	a1,1
    8000319a:	4505                	li	a0,1
    8000319c:	fffff097          	auipc	ra,0xfffff
    800031a0:	6e2080e7          	jalr	1762(ra) # 8000287e <iget>
    800031a4:	8a2a                	mv	s4,a0
    800031a6:	b7dd                	j	8000318c <namex+0x44>
      iunlockput(ip);
    800031a8:	8552                	mv	a0,s4
    800031aa:	00000097          	auipc	ra,0x0
    800031ae:	c6c080e7          	jalr	-916(ra) # 80002e16 <iunlockput>
      return 0;
    800031b2:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031b4:	8552                	mv	a0,s4
    800031b6:	60e6                	ld	ra,88(sp)
    800031b8:	6446                	ld	s0,80(sp)
    800031ba:	64a6                	ld	s1,72(sp)
    800031bc:	6906                	ld	s2,64(sp)
    800031be:	79e2                	ld	s3,56(sp)
    800031c0:	7a42                	ld	s4,48(sp)
    800031c2:	7aa2                	ld	s5,40(sp)
    800031c4:	7b02                	ld	s6,32(sp)
    800031c6:	6be2                	ld	s7,24(sp)
    800031c8:	6c42                	ld	s8,16(sp)
    800031ca:	6ca2                	ld	s9,8(sp)
    800031cc:	6d02                	ld	s10,0(sp)
    800031ce:	6125                	addi	sp,sp,96
    800031d0:	8082                	ret
      iunlock(ip);
    800031d2:	8552                	mv	a0,s4
    800031d4:	00000097          	auipc	ra,0x0
    800031d8:	aa2080e7          	jalr	-1374(ra) # 80002c76 <iunlock>
      return ip;
    800031dc:	bfe1                	j	800031b4 <namex+0x6c>
      iunlockput(ip);
    800031de:	8552                	mv	a0,s4
    800031e0:	00000097          	auipc	ra,0x0
    800031e4:	c36080e7          	jalr	-970(ra) # 80002e16 <iunlockput>
      return 0;
    800031e8:	8a4e                	mv	s4,s3
    800031ea:	b7e9                	j	800031b4 <namex+0x6c>
  len = path - s;
    800031ec:	40998633          	sub	a2,s3,s1
    800031f0:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800031f4:	09acd863          	bge	s9,s10,80003284 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800031f8:	4639                	li	a2,14
    800031fa:	85a6                	mv	a1,s1
    800031fc:	8556                	mv	a0,s5
    800031fe:	ffffd097          	auipc	ra,0xffffd
    80003202:	fd8080e7          	jalr	-40(ra) # 800001d6 <memmove>
    80003206:	84ce                	mv	s1,s3
  while(*path == '/')
    80003208:	0004c783          	lbu	a5,0(s1)
    8000320c:	01279763          	bne	a5,s2,8000321a <namex+0xd2>
    path++;
    80003210:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003212:	0004c783          	lbu	a5,0(s1)
    80003216:	ff278de3          	beq	a5,s2,80003210 <namex+0xc8>
    ilock(ip);
    8000321a:	8552                	mv	a0,s4
    8000321c:	00000097          	auipc	ra,0x0
    80003220:	998080e7          	jalr	-1640(ra) # 80002bb4 <ilock>
    if(ip->type != T_DIR){
    80003224:	044a1783          	lh	a5,68(s4)
    80003228:	f98790e3          	bne	a5,s8,800031a8 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000322c:	000b0563          	beqz	s6,80003236 <namex+0xee>
    80003230:	0004c783          	lbu	a5,0(s1)
    80003234:	dfd9                	beqz	a5,800031d2 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003236:	865e                	mv	a2,s7
    80003238:	85d6                	mv	a1,s5
    8000323a:	8552                	mv	a0,s4
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	e5c080e7          	jalr	-420(ra) # 80003098 <dirlookup>
    80003244:	89aa                	mv	s3,a0
    80003246:	dd41                	beqz	a0,800031de <namex+0x96>
    iunlockput(ip);
    80003248:	8552                	mv	a0,s4
    8000324a:	00000097          	auipc	ra,0x0
    8000324e:	bcc080e7          	jalr	-1076(ra) # 80002e16 <iunlockput>
    ip = next;
    80003252:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003254:	0004c783          	lbu	a5,0(s1)
    80003258:	01279763          	bne	a5,s2,80003266 <namex+0x11e>
    path++;
    8000325c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000325e:	0004c783          	lbu	a5,0(s1)
    80003262:	ff278de3          	beq	a5,s2,8000325c <namex+0x114>
  if(*path == 0)
    80003266:	cb9d                	beqz	a5,8000329c <namex+0x154>
  while(*path != '/' && *path != 0)
    80003268:	0004c783          	lbu	a5,0(s1)
    8000326c:	89a6                	mv	s3,s1
  len = path - s;
    8000326e:	8d5e                	mv	s10,s7
    80003270:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003272:	01278963          	beq	a5,s2,80003284 <namex+0x13c>
    80003276:	dbbd                	beqz	a5,800031ec <namex+0xa4>
    path++;
    80003278:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000327a:	0009c783          	lbu	a5,0(s3)
    8000327e:	ff279ce3          	bne	a5,s2,80003276 <namex+0x12e>
    80003282:	b7ad                	j	800031ec <namex+0xa4>
    memmove(name, s, len);
    80003284:	2601                	sext.w	a2,a2
    80003286:	85a6                	mv	a1,s1
    80003288:	8556                	mv	a0,s5
    8000328a:	ffffd097          	auipc	ra,0xffffd
    8000328e:	f4c080e7          	jalr	-180(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003292:	9d56                	add	s10,s10,s5
    80003294:	000d0023          	sb	zero,0(s10)
    80003298:	84ce                	mv	s1,s3
    8000329a:	b7bd                	j	80003208 <namex+0xc0>
  if(nameiparent){
    8000329c:	f00b0ce3          	beqz	s6,800031b4 <namex+0x6c>
    iput(ip);
    800032a0:	8552                	mv	a0,s4
    800032a2:	00000097          	auipc	ra,0x0
    800032a6:	acc080e7          	jalr	-1332(ra) # 80002d6e <iput>
    return 0;
    800032aa:	4a01                	li	s4,0
    800032ac:	b721                	j	800031b4 <namex+0x6c>

00000000800032ae <dirlink>:
{
    800032ae:	7139                	addi	sp,sp,-64
    800032b0:	fc06                	sd	ra,56(sp)
    800032b2:	f822                	sd	s0,48(sp)
    800032b4:	f426                	sd	s1,40(sp)
    800032b6:	f04a                	sd	s2,32(sp)
    800032b8:	ec4e                	sd	s3,24(sp)
    800032ba:	e852                	sd	s4,16(sp)
    800032bc:	0080                	addi	s0,sp,64
    800032be:	892a                	mv	s2,a0
    800032c0:	8a2e                	mv	s4,a1
    800032c2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032c4:	4601                	li	a2,0
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	dd2080e7          	jalr	-558(ra) # 80003098 <dirlookup>
    800032ce:	e93d                	bnez	a0,80003344 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032d0:	04c92483          	lw	s1,76(s2)
    800032d4:	c49d                	beqz	s1,80003302 <dirlink+0x54>
    800032d6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032d8:	4741                	li	a4,16
    800032da:	86a6                	mv	a3,s1
    800032dc:	fc040613          	addi	a2,s0,-64
    800032e0:	4581                	li	a1,0
    800032e2:	854a                	mv	a0,s2
    800032e4:	00000097          	auipc	ra,0x0
    800032e8:	b84080e7          	jalr	-1148(ra) # 80002e68 <readi>
    800032ec:	47c1                	li	a5,16
    800032ee:	06f51163          	bne	a0,a5,80003350 <dirlink+0xa2>
    if(de.inum == 0)
    800032f2:	fc045783          	lhu	a5,-64(s0)
    800032f6:	c791                	beqz	a5,80003302 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032f8:	24c1                	addiw	s1,s1,16
    800032fa:	04c92783          	lw	a5,76(s2)
    800032fe:	fcf4ede3          	bltu	s1,a5,800032d8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003302:	4639                	li	a2,14
    80003304:	85d2                	mv	a1,s4
    80003306:	fc240513          	addi	a0,s0,-62
    8000330a:	ffffd097          	auipc	ra,0xffffd
    8000330e:	f7c080e7          	jalr	-132(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003312:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003316:	4741                	li	a4,16
    80003318:	86a6                	mv	a3,s1
    8000331a:	fc040613          	addi	a2,s0,-64
    8000331e:	4581                	li	a1,0
    80003320:	854a                	mv	a0,s2
    80003322:	00000097          	auipc	ra,0x0
    80003326:	c3e080e7          	jalr	-962(ra) # 80002f60 <writei>
    8000332a:	872a                	mv	a4,a0
    8000332c:	47c1                	li	a5,16
  return 0;
    8000332e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003330:	02f71863          	bne	a4,a5,80003360 <dirlink+0xb2>
}
    80003334:	70e2                	ld	ra,56(sp)
    80003336:	7442                	ld	s0,48(sp)
    80003338:	74a2                	ld	s1,40(sp)
    8000333a:	7902                	ld	s2,32(sp)
    8000333c:	69e2                	ld	s3,24(sp)
    8000333e:	6a42                	ld	s4,16(sp)
    80003340:	6121                	addi	sp,sp,64
    80003342:	8082                	ret
    iput(ip);
    80003344:	00000097          	auipc	ra,0x0
    80003348:	a2a080e7          	jalr	-1494(ra) # 80002d6e <iput>
    return -1;
    8000334c:	557d                	li	a0,-1
    8000334e:	b7dd                	j	80003334 <dirlink+0x86>
      panic("dirlink read");
    80003350:	00005517          	auipc	a0,0x5
    80003354:	25050513          	addi	a0,a0,592 # 800085a0 <syscalls+0x1d8>
    80003358:	00003097          	auipc	ra,0x3
    8000335c:	8d8080e7          	jalr	-1832(ra) # 80005c30 <panic>
    panic("dirlink");
    80003360:	00005517          	auipc	a0,0x5
    80003364:	35050513          	addi	a0,a0,848 # 800086b0 <syscalls+0x2e8>
    80003368:	00003097          	auipc	ra,0x3
    8000336c:	8c8080e7          	jalr	-1848(ra) # 80005c30 <panic>

0000000080003370 <namei>:

struct inode*
namei(char *path)
{
    80003370:	1101                	addi	sp,sp,-32
    80003372:	ec06                	sd	ra,24(sp)
    80003374:	e822                	sd	s0,16(sp)
    80003376:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003378:	fe040613          	addi	a2,s0,-32
    8000337c:	4581                	li	a1,0
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	dca080e7          	jalr	-566(ra) # 80003148 <namex>
}
    80003386:	60e2                	ld	ra,24(sp)
    80003388:	6442                	ld	s0,16(sp)
    8000338a:	6105                	addi	sp,sp,32
    8000338c:	8082                	ret

000000008000338e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000338e:	1141                	addi	sp,sp,-16
    80003390:	e406                	sd	ra,8(sp)
    80003392:	e022                	sd	s0,0(sp)
    80003394:	0800                	addi	s0,sp,16
    80003396:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003398:	4585                	li	a1,1
    8000339a:	00000097          	auipc	ra,0x0
    8000339e:	dae080e7          	jalr	-594(ra) # 80003148 <namex>
}
    800033a2:	60a2                	ld	ra,8(sp)
    800033a4:	6402                	ld	s0,0(sp)
    800033a6:	0141                	addi	sp,sp,16
    800033a8:	8082                	ret

00000000800033aa <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033aa:	1101                	addi	sp,sp,-32
    800033ac:	ec06                	sd	ra,24(sp)
    800033ae:	e822                	sd	s0,16(sp)
    800033b0:	e426                	sd	s1,8(sp)
    800033b2:	e04a                	sd	s2,0(sp)
    800033b4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033b6:	00016917          	auipc	s2,0x16
    800033ba:	46a90913          	addi	s2,s2,1130 # 80019820 <log>
    800033be:	01892583          	lw	a1,24(s2)
    800033c2:	02892503          	lw	a0,40(s2)
    800033c6:	fffff097          	auipc	ra,0xfffff
    800033ca:	fec080e7          	jalr	-20(ra) # 800023b2 <bread>
    800033ce:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033d0:	02c92683          	lw	a3,44(s2)
    800033d4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033d6:	02d05863          	blez	a3,80003406 <write_head+0x5c>
    800033da:	00016797          	auipc	a5,0x16
    800033de:	47678793          	addi	a5,a5,1142 # 80019850 <log+0x30>
    800033e2:	05c50713          	addi	a4,a0,92
    800033e6:	36fd                	addiw	a3,a3,-1
    800033e8:	02069613          	slli	a2,a3,0x20
    800033ec:	01e65693          	srli	a3,a2,0x1e
    800033f0:	00016617          	auipc	a2,0x16
    800033f4:	46460613          	addi	a2,a2,1124 # 80019854 <log+0x34>
    800033f8:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033fa:	4390                	lw	a2,0(a5)
    800033fc:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033fe:	0791                	addi	a5,a5,4
    80003400:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003402:	fed79ce3          	bne	a5,a3,800033fa <write_head+0x50>
  }
  bwrite(buf);
    80003406:	8526                	mv	a0,s1
    80003408:	fffff097          	auipc	ra,0xfffff
    8000340c:	09c080e7          	jalr	156(ra) # 800024a4 <bwrite>
  brelse(buf);
    80003410:	8526                	mv	a0,s1
    80003412:	fffff097          	auipc	ra,0xfffff
    80003416:	0d0080e7          	jalr	208(ra) # 800024e2 <brelse>
}
    8000341a:	60e2                	ld	ra,24(sp)
    8000341c:	6442                	ld	s0,16(sp)
    8000341e:	64a2                	ld	s1,8(sp)
    80003420:	6902                	ld	s2,0(sp)
    80003422:	6105                	addi	sp,sp,32
    80003424:	8082                	ret

0000000080003426 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003426:	00016797          	auipc	a5,0x16
    8000342a:	4267a783          	lw	a5,1062(a5) # 8001984c <log+0x2c>
    8000342e:	0af05d63          	blez	a5,800034e8 <install_trans+0xc2>
{
    80003432:	7139                	addi	sp,sp,-64
    80003434:	fc06                	sd	ra,56(sp)
    80003436:	f822                	sd	s0,48(sp)
    80003438:	f426                	sd	s1,40(sp)
    8000343a:	f04a                	sd	s2,32(sp)
    8000343c:	ec4e                	sd	s3,24(sp)
    8000343e:	e852                	sd	s4,16(sp)
    80003440:	e456                	sd	s5,8(sp)
    80003442:	e05a                	sd	s6,0(sp)
    80003444:	0080                	addi	s0,sp,64
    80003446:	8b2a                	mv	s6,a0
    80003448:	00016a97          	auipc	s5,0x16
    8000344c:	408a8a93          	addi	s5,s5,1032 # 80019850 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003450:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003452:	00016997          	auipc	s3,0x16
    80003456:	3ce98993          	addi	s3,s3,974 # 80019820 <log>
    8000345a:	a00d                	j	8000347c <install_trans+0x56>
    brelse(lbuf);
    8000345c:	854a                	mv	a0,s2
    8000345e:	fffff097          	auipc	ra,0xfffff
    80003462:	084080e7          	jalr	132(ra) # 800024e2 <brelse>
    brelse(dbuf);
    80003466:	8526                	mv	a0,s1
    80003468:	fffff097          	auipc	ra,0xfffff
    8000346c:	07a080e7          	jalr	122(ra) # 800024e2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003470:	2a05                	addiw	s4,s4,1
    80003472:	0a91                	addi	s5,s5,4
    80003474:	02c9a783          	lw	a5,44(s3)
    80003478:	04fa5e63          	bge	s4,a5,800034d4 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000347c:	0189a583          	lw	a1,24(s3)
    80003480:	014585bb          	addw	a1,a1,s4
    80003484:	2585                	addiw	a1,a1,1
    80003486:	0289a503          	lw	a0,40(s3)
    8000348a:	fffff097          	auipc	ra,0xfffff
    8000348e:	f28080e7          	jalr	-216(ra) # 800023b2 <bread>
    80003492:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003494:	000aa583          	lw	a1,0(s5)
    80003498:	0289a503          	lw	a0,40(s3)
    8000349c:	fffff097          	auipc	ra,0xfffff
    800034a0:	f16080e7          	jalr	-234(ra) # 800023b2 <bread>
    800034a4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034a6:	40000613          	li	a2,1024
    800034aa:	05890593          	addi	a1,s2,88
    800034ae:	05850513          	addi	a0,a0,88
    800034b2:	ffffd097          	auipc	ra,0xffffd
    800034b6:	d24080e7          	jalr	-732(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034ba:	8526                	mv	a0,s1
    800034bc:	fffff097          	auipc	ra,0xfffff
    800034c0:	fe8080e7          	jalr	-24(ra) # 800024a4 <bwrite>
    if(recovering == 0)
    800034c4:	f80b1ce3          	bnez	s6,8000345c <install_trans+0x36>
      bunpin(dbuf);
    800034c8:	8526                	mv	a0,s1
    800034ca:	fffff097          	auipc	ra,0xfffff
    800034ce:	0f2080e7          	jalr	242(ra) # 800025bc <bunpin>
    800034d2:	b769                	j	8000345c <install_trans+0x36>
}
    800034d4:	70e2                	ld	ra,56(sp)
    800034d6:	7442                	ld	s0,48(sp)
    800034d8:	74a2                	ld	s1,40(sp)
    800034da:	7902                	ld	s2,32(sp)
    800034dc:	69e2                	ld	s3,24(sp)
    800034de:	6a42                	ld	s4,16(sp)
    800034e0:	6aa2                	ld	s5,8(sp)
    800034e2:	6b02                	ld	s6,0(sp)
    800034e4:	6121                	addi	sp,sp,64
    800034e6:	8082                	ret
    800034e8:	8082                	ret

00000000800034ea <initlog>:
{
    800034ea:	7179                	addi	sp,sp,-48
    800034ec:	f406                	sd	ra,40(sp)
    800034ee:	f022                	sd	s0,32(sp)
    800034f0:	ec26                	sd	s1,24(sp)
    800034f2:	e84a                	sd	s2,16(sp)
    800034f4:	e44e                	sd	s3,8(sp)
    800034f6:	1800                	addi	s0,sp,48
    800034f8:	892a                	mv	s2,a0
    800034fa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034fc:	00016497          	auipc	s1,0x16
    80003500:	32448493          	addi	s1,s1,804 # 80019820 <log>
    80003504:	00005597          	auipc	a1,0x5
    80003508:	0ac58593          	addi	a1,a1,172 # 800085b0 <syscalls+0x1e8>
    8000350c:	8526                	mv	a0,s1
    8000350e:	00003097          	auipc	ra,0x3
    80003512:	c48080e7          	jalr	-952(ra) # 80006156 <initlock>
  log.start = sb->logstart;
    80003516:	0149a583          	lw	a1,20(s3)
    8000351a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000351c:	0109a783          	lw	a5,16(s3)
    80003520:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003522:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003526:	854a                	mv	a0,s2
    80003528:	fffff097          	auipc	ra,0xfffff
    8000352c:	e8a080e7          	jalr	-374(ra) # 800023b2 <bread>
  log.lh.n = lh->n;
    80003530:	4d34                	lw	a3,88(a0)
    80003532:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003534:	02d05663          	blez	a3,80003560 <initlog+0x76>
    80003538:	05c50793          	addi	a5,a0,92
    8000353c:	00016717          	auipc	a4,0x16
    80003540:	31470713          	addi	a4,a4,788 # 80019850 <log+0x30>
    80003544:	36fd                	addiw	a3,a3,-1
    80003546:	02069613          	slli	a2,a3,0x20
    8000354a:	01e65693          	srli	a3,a2,0x1e
    8000354e:	06050613          	addi	a2,a0,96
    80003552:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003554:	4390                	lw	a2,0(a5)
    80003556:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003558:	0791                	addi	a5,a5,4
    8000355a:	0711                	addi	a4,a4,4
    8000355c:	fed79ce3          	bne	a5,a3,80003554 <initlog+0x6a>
  brelse(buf);
    80003560:	fffff097          	auipc	ra,0xfffff
    80003564:	f82080e7          	jalr	-126(ra) # 800024e2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003568:	4505                	li	a0,1
    8000356a:	00000097          	auipc	ra,0x0
    8000356e:	ebc080e7          	jalr	-324(ra) # 80003426 <install_trans>
  log.lh.n = 0;
    80003572:	00016797          	auipc	a5,0x16
    80003576:	2c07ad23          	sw	zero,730(a5) # 8001984c <log+0x2c>
  write_head(); // clear the log
    8000357a:	00000097          	auipc	ra,0x0
    8000357e:	e30080e7          	jalr	-464(ra) # 800033aa <write_head>
}
    80003582:	70a2                	ld	ra,40(sp)
    80003584:	7402                	ld	s0,32(sp)
    80003586:	64e2                	ld	s1,24(sp)
    80003588:	6942                	ld	s2,16(sp)
    8000358a:	69a2                	ld	s3,8(sp)
    8000358c:	6145                	addi	sp,sp,48
    8000358e:	8082                	ret

0000000080003590 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003590:	1101                	addi	sp,sp,-32
    80003592:	ec06                	sd	ra,24(sp)
    80003594:	e822                	sd	s0,16(sp)
    80003596:	e426                	sd	s1,8(sp)
    80003598:	e04a                	sd	s2,0(sp)
    8000359a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000359c:	00016517          	auipc	a0,0x16
    800035a0:	28450513          	addi	a0,a0,644 # 80019820 <log>
    800035a4:	00003097          	auipc	ra,0x3
    800035a8:	c42080e7          	jalr	-958(ra) # 800061e6 <acquire>
  while(1){
    if(log.committing){
    800035ac:	00016497          	auipc	s1,0x16
    800035b0:	27448493          	addi	s1,s1,628 # 80019820 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035b4:	4979                	li	s2,30
    800035b6:	a039                	j	800035c4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035b8:	85a6                	mv	a1,s1
    800035ba:	8526                	mv	a0,s1
    800035bc:	ffffe097          	auipc	ra,0xffffe
    800035c0:	f90080e7          	jalr	-112(ra) # 8000154c <sleep>
    if(log.committing){
    800035c4:	50dc                	lw	a5,36(s1)
    800035c6:	fbed                	bnez	a5,800035b8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035c8:	5098                	lw	a4,32(s1)
    800035ca:	2705                	addiw	a4,a4,1
    800035cc:	0007069b          	sext.w	a3,a4
    800035d0:	0027179b          	slliw	a5,a4,0x2
    800035d4:	9fb9                	addw	a5,a5,a4
    800035d6:	0017979b          	slliw	a5,a5,0x1
    800035da:	54d8                	lw	a4,44(s1)
    800035dc:	9fb9                	addw	a5,a5,a4
    800035de:	00f95963          	bge	s2,a5,800035f0 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035e2:	85a6                	mv	a1,s1
    800035e4:	8526                	mv	a0,s1
    800035e6:	ffffe097          	auipc	ra,0xffffe
    800035ea:	f66080e7          	jalr	-154(ra) # 8000154c <sleep>
    800035ee:	bfd9                	j	800035c4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035f0:	00016517          	auipc	a0,0x16
    800035f4:	23050513          	addi	a0,a0,560 # 80019820 <log>
    800035f8:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035fa:	00003097          	auipc	ra,0x3
    800035fe:	ca0080e7          	jalr	-864(ra) # 8000629a <release>
      break;
    }
  }
}
    80003602:	60e2                	ld	ra,24(sp)
    80003604:	6442                	ld	s0,16(sp)
    80003606:	64a2                	ld	s1,8(sp)
    80003608:	6902                	ld	s2,0(sp)
    8000360a:	6105                	addi	sp,sp,32
    8000360c:	8082                	ret

000000008000360e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000360e:	7139                	addi	sp,sp,-64
    80003610:	fc06                	sd	ra,56(sp)
    80003612:	f822                	sd	s0,48(sp)
    80003614:	f426                	sd	s1,40(sp)
    80003616:	f04a                	sd	s2,32(sp)
    80003618:	ec4e                	sd	s3,24(sp)
    8000361a:	e852                	sd	s4,16(sp)
    8000361c:	e456                	sd	s5,8(sp)
    8000361e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003620:	00016497          	auipc	s1,0x16
    80003624:	20048493          	addi	s1,s1,512 # 80019820 <log>
    80003628:	8526                	mv	a0,s1
    8000362a:	00003097          	auipc	ra,0x3
    8000362e:	bbc080e7          	jalr	-1092(ra) # 800061e6 <acquire>
  log.outstanding -= 1;
    80003632:	509c                	lw	a5,32(s1)
    80003634:	37fd                	addiw	a5,a5,-1
    80003636:	0007891b          	sext.w	s2,a5
    8000363a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000363c:	50dc                	lw	a5,36(s1)
    8000363e:	e7b9                	bnez	a5,8000368c <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003640:	04091e63          	bnez	s2,8000369c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003644:	00016497          	auipc	s1,0x16
    80003648:	1dc48493          	addi	s1,s1,476 # 80019820 <log>
    8000364c:	4785                	li	a5,1
    8000364e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003650:	8526                	mv	a0,s1
    80003652:	00003097          	auipc	ra,0x3
    80003656:	c48080e7          	jalr	-952(ra) # 8000629a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000365a:	54dc                	lw	a5,44(s1)
    8000365c:	06f04763          	bgtz	a5,800036ca <end_op+0xbc>
    acquire(&log.lock);
    80003660:	00016497          	auipc	s1,0x16
    80003664:	1c048493          	addi	s1,s1,448 # 80019820 <log>
    80003668:	8526                	mv	a0,s1
    8000366a:	00003097          	auipc	ra,0x3
    8000366e:	b7c080e7          	jalr	-1156(ra) # 800061e6 <acquire>
    log.committing = 0;
    80003672:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003676:	8526                	mv	a0,s1
    80003678:	ffffe097          	auipc	ra,0xffffe
    8000367c:	060080e7          	jalr	96(ra) # 800016d8 <wakeup>
    release(&log.lock);
    80003680:	8526                	mv	a0,s1
    80003682:	00003097          	auipc	ra,0x3
    80003686:	c18080e7          	jalr	-1000(ra) # 8000629a <release>
}
    8000368a:	a03d                	j	800036b8 <end_op+0xaa>
    panic("log.committing");
    8000368c:	00005517          	auipc	a0,0x5
    80003690:	f2c50513          	addi	a0,a0,-212 # 800085b8 <syscalls+0x1f0>
    80003694:	00002097          	auipc	ra,0x2
    80003698:	59c080e7          	jalr	1436(ra) # 80005c30 <panic>
    wakeup(&log);
    8000369c:	00016497          	auipc	s1,0x16
    800036a0:	18448493          	addi	s1,s1,388 # 80019820 <log>
    800036a4:	8526                	mv	a0,s1
    800036a6:	ffffe097          	auipc	ra,0xffffe
    800036aa:	032080e7          	jalr	50(ra) # 800016d8 <wakeup>
  release(&log.lock);
    800036ae:	8526                	mv	a0,s1
    800036b0:	00003097          	auipc	ra,0x3
    800036b4:	bea080e7          	jalr	-1046(ra) # 8000629a <release>
}
    800036b8:	70e2                	ld	ra,56(sp)
    800036ba:	7442                	ld	s0,48(sp)
    800036bc:	74a2                	ld	s1,40(sp)
    800036be:	7902                	ld	s2,32(sp)
    800036c0:	69e2                	ld	s3,24(sp)
    800036c2:	6a42                	ld	s4,16(sp)
    800036c4:	6aa2                	ld	s5,8(sp)
    800036c6:	6121                	addi	sp,sp,64
    800036c8:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036ca:	00016a97          	auipc	s5,0x16
    800036ce:	186a8a93          	addi	s5,s5,390 # 80019850 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036d2:	00016a17          	auipc	s4,0x16
    800036d6:	14ea0a13          	addi	s4,s4,334 # 80019820 <log>
    800036da:	018a2583          	lw	a1,24(s4)
    800036de:	012585bb          	addw	a1,a1,s2
    800036e2:	2585                	addiw	a1,a1,1
    800036e4:	028a2503          	lw	a0,40(s4)
    800036e8:	fffff097          	auipc	ra,0xfffff
    800036ec:	cca080e7          	jalr	-822(ra) # 800023b2 <bread>
    800036f0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036f2:	000aa583          	lw	a1,0(s5)
    800036f6:	028a2503          	lw	a0,40(s4)
    800036fa:	fffff097          	auipc	ra,0xfffff
    800036fe:	cb8080e7          	jalr	-840(ra) # 800023b2 <bread>
    80003702:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003704:	40000613          	li	a2,1024
    80003708:	05850593          	addi	a1,a0,88
    8000370c:	05848513          	addi	a0,s1,88
    80003710:	ffffd097          	auipc	ra,0xffffd
    80003714:	ac6080e7          	jalr	-1338(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003718:	8526                	mv	a0,s1
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	d8a080e7          	jalr	-630(ra) # 800024a4 <bwrite>
    brelse(from);
    80003722:	854e                	mv	a0,s3
    80003724:	fffff097          	auipc	ra,0xfffff
    80003728:	dbe080e7          	jalr	-578(ra) # 800024e2 <brelse>
    brelse(to);
    8000372c:	8526                	mv	a0,s1
    8000372e:	fffff097          	auipc	ra,0xfffff
    80003732:	db4080e7          	jalr	-588(ra) # 800024e2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003736:	2905                	addiw	s2,s2,1
    80003738:	0a91                	addi	s5,s5,4
    8000373a:	02ca2783          	lw	a5,44(s4)
    8000373e:	f8f94ee3          	blt	s2,a5,800036da <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003742:	00000097          	auipc	ra,0x0
    80003746:	c68080e7          	jalr	-920(ra) # 800033aa <write_head>
    install_trans(0); // Now install writes to home locations
    8000374a:	4501                	li	a0,0
    8000374c:	00000097          	auipc	ra,0x0
    80003750:	cda080e7          	jalr	-806(ra) # 80003426 <install_trans>
    log.lh.n = 0;
    80003754:	00016797          	auipc	a5,0x16
    80003758:	0e07ac23          	sw	zero,248(a5) # 8001984c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000375c:	00000097          	auipc	ra,0x0
    80003760:	c4e080e7          	jalr	-946(ra) # 800033aa <write_head>
    80003764:	bdf5                	j	80003660 <end_op+0x52>

0000000080003766 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003766:	1101                	addi	sp,sp,-32
    80003768:	ec06                	sd	ra,24(sp)
    8000376a:	e822                	sd	s0,16(sp)
    8000376c:	e426                	sd	s1,8(sp)
    8000376e:	e04a                	sd	s2,0(sp)
    80003770:	1000                	addi	s0,sp,32
    80003772:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003774:	00016917          	auipc	s2,0x16
    80003778:	0ac90913          	addi	s2,s2,172 # 80019820 <log>
    8000377c:	854a                	mv	a0,s2
    8000377e:	00003097          	auipc	ra,0x3
    80003782:	a68080e7          	jalr	-1432(ra) # 800061e6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003786:	02c92603          	lw	a2,44(s2)
    8000378a:	47f5                	li	a5,29
    8000378c:	06c7c563          	blt	a5,a2,800037f6 <log_write+0x90>
    80003790:	00016797          	auipc	a5,0x16
    80003794:	0ac7a783          	lw	a5,172(a5) # 8001983c <log+0x1c>
    80003798:	37fd                	addiw	a5,a5,-1
    8000379a:	04f65e63          	bge	a2,a5,800037f6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000379e:	00016797          	auipc	a5,0x16
    800037a2:	0a27a783          	lw	a5,162(a5) # 80019840 <log+0x20>
    800037a6:	06f05063          	blez	a5,80003806 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037aa:	4781                	li	a5,0
    800037ac:	06c05563          	blez	a2,80003816 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037b0:	44cc                	lw	a1,12(s1)
    800037b2:	00016717          	auipc	a4,0x16
    800037b6:	09e70713          	addi	a4,a4,158 # 80019850 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037ba:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037bc:	4314                	lw	a3,0(a4)
    800037be:	04b68c63          	beq	a3,a1,80003816 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037c2:	2785                	addiw	a5,a5,1
    800037c4:	0711                	addi	a4,a4,4
    800037c6:	fef61be3          	bne	a2,a5,800037bc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037ca:	0621                	addi	a2,a2,8
    800037cc:	060a                	slli	a2,a2,0x2
    800037ce:	00016797          	auipc	a5,0x16
    800037d2:	05278793          	addi	a5,a5,82 # 80019820 <log>
    800037d6:	97b2                	add	a5,a5,a2
    800037d8:	44d8                	lw	a4,12(s1)
    800037da:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037dc:	8526                	mv	a0,s1
    800037de:	fffff097          	auipc	ra,0xfffff
    800037e2:	da2080e7          	jalr	-606(ra) # 80002580 <bpin>
    log.lh.n++;
    800037e6:	00016717          	auipc	a4,0x16
    800037ea:	03a70713          	addi	a4,a4,58 # 80019820 <log>
    800037ee:	575c                	lw	a5,44(a4)
    800037f0:	2785                	addiw	a5,a5,1
    800037f2:	d75c                	sw	a5,44(a4)
    800037f4:	a82d                	j	8000382e <log_write+0xc8>
    panic("too big a transaction");
    800037f6:	00005517          	auipc	a0,0x5
    800037fa:	dd250513          	addi	a0,a0,-558 # 800085c8 <syscalls+0x200>
    800037fe:	00002097          	auipc	ra,0x2
    80003802:	432080e7          	jalr	1074(ra) # 80005c30 <panic>
    panic("log_write outside of trans");
    80003806:	00005517          	auipc	a0,0x5
    8000380a:	dda50513          	addi	a0,a0,-550 # 800085e0 <syscalls+0x218>
    8000380e:	00002097          	auipc	ra,0x2
    80003812:	422080e7          	jalr	1058(ra) # 80005c30 <panic>
  log.lh.block[i] = b->blockno;
    80003816:	00878693          	addi	a3,a5,8
    8000381a:	068a                	slli	a3,a3,0x2
    8000381c:	00016717          	auipc	a4,0x16
    80003820:	00470713          	addi	a4,a4,4 # 80019820 <log>
    80003824:	9736                	add	a4,a4,a3
    80003826:	44d4                	lw	a3,12(s1)
    80003828:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000382a:	faf609e3          	beq	a2,a5,800037dc <log_write+0x76>
  }
  release(&log.lock);
    8000382e:	00016517          	auipc	a0,0x16
    80003832:	ff250513          	addi	a0,a0,-14 # 80019820 <log>
    80003836:	00003097          	auipc	ra,0x3
    8000383a:	a64080e7          	jalr	-1436(ra) # 8000629a <release>
}
    8000383e:	60e2                	ld	ra,24(sp)
    80003840:	6442                	ld	s0,16(sp)
    80003842:	64a2                	ld	s1,8(sp)
    80003844:	6902                	ld	s2,0(sp)
    80003846:	6105                	addi	sp,sp,32
    80003848:	8082                	ret

000000008000384a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000384a:	1101                	addi	sp,sp,-32
    8000384c:	ec06                	sd	ra,24(sp)
    8000384e:	e822                	sd	s0,16(sp)
    80003850:	e426                	sd	s1,8(sp)
    80003852:	e04a                	sd	s2,0(sp)
    80003854:	1000                	addi	s0,sp,32
    80003856:	84aa                	mv	s1,a0
    80003858:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000385a:	00005597          	auipc	a1,0x5
    8000385e:	da658593          	addi	a1,a1,-602 # 80008600 <syscalls+0x238>
    80003862:	0521                	addi	a0,a0,8
    80003864:	00003097          	auipc	ra,0x3
    80003868:	8f2080e7          	jalr	-1806(ra) # 80006156 <initlock>
  lk->name = name;
    8000386c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003870:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003874:	0204a423          	sw	zero,40(s1)
}
    80003878:	60e2                	ld	ra,24(sp)
    8000387a:	6442                	ld	s0,16(sp)
    8000387c:	64a2                	ld	s1,8(sp)
    8000387e:	6902                	ld	s2,0(sp)
    80003880:	6105                	addi	sp,sp,32
    80003882:	8082                	ret

0000000080003884 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003884:	1101                	addi	sp,sp,-32
    80003886:	ec06                	sd	ra,24(sp)
    80003888:	e822                	sd	s0,16(sp)
    8000388a:	e426                	sd	s1,8(sp)
    8000388c:	e04a                	sd	s2,0(sp)
    8000388e:	1000                	addi	s0,sp,32
    80003890:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003892:	00850913          	addi	s2,a0,8
    80003896:	854a                	mv	a0,s2
    80003898:	00003097          	auipc	ra,0x3
    8000389c:	94e080e7          	jalr	-1714(ra) # 800061e6 <acquire>
  while (lk->locked) {
    800038a0:	409c                	lw	a5,0(s1)
    800038a2:	cb89                	beqz	a5,800038b4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038a4:	85ca                	mv	a1,s2
    800038a6:	8526                	mv	a0,s1
    800038a8:	ffffe097          	auipc	ra,0xffffe
    800038ac:	ca4080e7          	jalr	-860(ra) # 8000154c <sleep>
  while (lk->locked) {
    800038b0:	409c                	lw	a5,0(s1)
    800038b2:	fbed                	bnez	a5,800038a4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038b4:	4785                	li	a5,1
    800038b6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038b8:	ffffd097          	auipc	ra,0xffffd
    800038bc:	58c080e7          	jalr	1420(ra) # 80000e44 <myproc>
    800038c0:	591c                	lw	a5,48(a0)
    800038c2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038c4:	854a                	mv	a0,s2
    800038c6:	00003097          	auipc	ra,0x3
    800038ca:	9d4080e7          	jalr	-1580(ra) # 8000629a <release>
}
    800038ce:	60e2                	ld	ra,24(sp)
    800038d0:	6442                	ld	s0,16(sp)
    800038d2:	64a2                	ld	s1,8(sp)
    800038d4:	6902                	ld	s2,0(sp)
    800038d6:	6105                	addi	sp,sp,32
    800038d8:	8082                	ret

00000000800038da <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038da:	1101                	addi	sp,sp,-32
    800038dc:	ec06                	sd	ra,24(sp)
    800038de:	e822                	sd	s0,16(sp)
    800038e0:	e426                	sd	s1,8(sp)
    800038e2:	e04a                	sd	s2,0(sp)
    800038e4:	1000                	addi	s0,sp,32
    800038e6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038e8:	00850913          	addi	s2,a0,8
    800038ec:	854a                	mv	a0,s2
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	8f8080e7          	jalr	-1800(ra) # 800061e6 <acquire>
  lk->locked = 0;
    800038f6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038fa:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038fe:	8526                	mv	a0,s1
    80003900:	ffffe097          	auipc	ra,0xffffe
    80003904:	dd8080e7          	jalr	-552(ra) # 800016d8 <wakeup>
  release(&lk->lk);
    80003908:	854a                	mv	a0,s2
    8000390a:	00003097          	auipc	ra,0x3
    8000390e:	990080e7          	jalr	-1648(ra) # 8000629a <release>
}
    80003912:	60e2                	ld	ra,24(sp)
    80003914:	6442                	ld	s0,16(sp)
    80003916:	64a2                	ld	s1,8(sp)
    80003918:	6902                	ld	s2,0(sp)
    8000391a:	6105                	addi	sp,sp,32
    8000391c:	8082                	ret

000000008000391e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000391e:	7179                	addi	sp,sp,-48
    80003920:	f406                	sd	ra,40(sp)
    80003922:	f022                	sd	s0,32(sp)
    80003924:	ec26                	sd	s1,24(sp)
    80003926:	e84a                	sd	s2,16(sp)
    80003928:	e44e                	sd	s3,8(sp)
    8000392a:	1800                	addi	s0,sp,48
    8000392c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000392e:	00850913          	addi	s2,a0,8
    80003932:	854a                	mv	a0,s2
    80003934:	00003097          	auipc	ra,0x3
    80003938:	8b2080e7          	jalr	-1870(ra) # 800061e6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000393c:	409c                	lw	a5,0(s1)
    8000393e:	ef99                	bnez	a5,8000395c <holdingsleep+0x3e>
    80003940:	4481                	li	s1,0
  release(&lk->lk);
    80003942:	854a                	mv	a0,s2
    80003944:	00003097          	auipc	ra,0x3
    80003948:	956080e7          	jalr	-1706(ra) # 8000629a <release>
  return r;
}
    8000394c:	8526                	mv	a0,s1
    8000394e:	70a2                	ld	ra,40(sp)
    80003950:	7402                	ld	s0,32(sp)
    80003952:	64e2                	ld	s1,24(sp)
    80003954:	6942                	ld	s2,16(sp)
    80003956:	69a2                	ld	s3,8(sp)
    80003958:	6145                	addi	sp,sp,48
    8000395a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000395c:	0284a983          	lw	s3,40(s1)
    80003960:	ffffd097          	auipc	ra,0xffffd
    80003964:	4e4080e7          	jalr	1252(ra) # 80000e44 <myproc>
    80003968:	5904                	lw	s1,48(a0)
    8000396a:	413484b3          	sub	s1,s1,s3
    8000396e:	0014b493          	seqz	s1,s1
    80003972:	bfc1                	j	80003942 <holdingsleep+0x24>

0000000080003974 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003974:	1141                	addi	sp,sp,-16
    80003976:	e406                	sd	ra,8(sp)
    80003978:	e022                	sd	s0,0(sp)
    8000397a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000397c:	00005597          	auipc	a1,0x5
    80003980:	c9458593          	addi	a1,a1,-876 # 80008610 <syscalls+0x248>
    80003984:	00016517          	auipc	a0,0x16
    80003988:	fe450513          	addi	a0,a0,-28 # 80019968 <ftable>
    8000398c:	00002097          	auipc	ra,0x2
    80003990:	7ca080e7          	jalr	1994(ra) # 80006156 <initlock>
}
    80003994:	60a2                	ld	ra,8(sp)
    80003996:	6402                	ld	s0,0(sp)
    80003998:	0141                	addi	sp,sp,16
    8000399a:	8082                	ret

000000008000399c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000399c:	1101                	addi	sp,sp,-32
    8000399e:	ec06                	sd	ra,24(sp)
    800039a0:	e822                	sd	s0,16(sp)
    800039a2:	e426                	sd	s1,8(sp)
    800039a4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039a6:	00016517          	auipc	a0,0x16
    800039aa:	fc250513          	addi	a0,a0,-62 # 80019968 <ftable>
    800039ae:	00003097          	auipc	ra,0x3
    800039b2:	838080e7          	jalr	-1992(ra) # 800061e6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039b6:	00016497          	auipc	s1,0x16
    800039ba:	fca48493          	addi	s1,s1,-54 # 80019980 <ftable+0x18>
    800039be:	00017717          	auipc	a4,0x17
    800039c2:	f6270713          	addi	a4,a4,-158 # 8001a920 <ftable+0xfb8>
    if(f->ref == 0){
    800039c6:	40dc                	lw	a5,4(s1)
    800039c8:	cf99                	beqz	a5,800039e6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039ca:	02848493          	addi	s1,s1,40
    800039ce:	fee49ce3          	bne	s1,a4,800039c6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039d2:	00016517          	auipc	a0,0x16
    800039d6:	f9650513          	addi	a0,a0,-106 # 80019968 <ftable>
    800039da:	00003097          	auipc	ra,0x3
    800039de:	8c0080e7          	jalr	-1856(ra) # 8000629a <release>
  return 0;
    800039e2:	4481                	li	s1,0
    800039e4:	a819                	j	800039fa <filealloc+0x5e>
      f->ref = 1;
    800039e6:	4785                	li	a5,1
    800039e8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039ea:	00016517          	auipc	a0,0x16
    800039ee:	f7e50513          	addi	a0,a0,-130 # 80019968 <ftable>
    800039f2:	00003097          	auipc	ra,0x3
    800039f6:	8a8080e7          	jalr	-1880(ra) # 8000629a <release>
}
    800039fa:	8526                	mv	a0,s1
    800039fc:	60e2                	ld	ra,24(sp)
    800039fe:	6442                	ld	s0,16(sp)
    80003a00:	64a2                	ld	s1,8(sp)
    80003a02:	6105                	addi	sp,sp,32
    80003a04:	8082                	ret

0000000080003a06 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a06:	1101                	addi	sp,sp,-32
    80003a08:	ec06                	sd	ra,24(sp)
    80003a0a:	e822                	sd	s0,16(sp)
    80003a0c:	e426                	sd	s1,8(sp)
    80003a0e:	1000                	addi	s0,sp,32
    80003a10:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a12:	00016517          	auipc	a0,0x16
    80003a16:	f5650513          	addi	a0,a0,-170 # 80019968 <ftable>
    80003a1a:	00002097          	auipc	ra,0x2
    80003a1e:	7cc080e7          	jalr	1996(ra) # 800061e6 <acquire>
  if(f->ref < 1)
    80003a22:	40dc                	lw	a5,4(s1)
    80003a24:	02f05263          	blez	a5,80003a48 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a28:	2785                	addiw	a5,a5,1
    80003a2a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a2c:	00016517          	auipc	a0,0x16
    80003a30:	f3c50513          	addi	a0,a0,-196 # 80019968 <ftable>
    80003a34:	00003097          	auipc	ra,0x3
    80003a38:	866080e7          	jalr	-1946(ra) # 8000629a <release>
  return f;
}
    80003a3c:	8526                	mv	a0,s1
    80003a3e:	60e2                	ld	ra,24(sp)
    80003a40:	6442                	ld	s0,16(sp)
    80003a42:	64a2                	ld	s1,8(sp)
    80003a44:	6105                	addi	sp,sp,32
    80003a46:	8082                	ret
    panic("filedup");
    80003a48:	00005517          	auipc	a0,0x5
    80003a4c:	bd050513          	addi	a0,a0,-1072 # 80008618 <syscalls+0x250>
    80003a50:	00002097          	auipc	ra,0x2
    80003a54:	1e0080e7          	jalr	480(ra) # 80005c30 <panic>

0000000080003a58 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a58:	7139                	addi	sp,sp,-64
    80003a5a:	fc06                	sd	ra,56(sp)
    80003a5c:	f822                	sd	s0,48(sp)
    80003a5e:	f426                	sd	s1,40(sp)
    80003a60:	f04a                	sd	s2,32(sp)
    80003a62:	ec4e                	sd	s3,24(sp)
    80003a64:	e852                	sd	s4,16(sp)
    80003a66:	e456                	sd	s5,8(sp)
    80003a68:	0080                	addi	s0,sp,64
    80003a6a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a6c:	00016517          	auipc	a0,0x16
    80003a70:	efc50513          	addi	a0,a0,-260 # 80019968 <ftable>
    80003a74:	00002097          	auipc	ra,0x2
    80003a78:	772080e7          	jalr	1906(ra) # 800061e6 <acquire>
  if(f->ref < 1)
    80003a7c:	40dc                	lw	a5,4(s1)
    80003a7e:	06f05163          	blez	a5,80003ae0 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a82:	37fd                	addiw	a5,a5,-1
    80003a84:	0007871b          	sext.w	a4,a5
    80003a88:	c0dc                	sw	a5,4(s1)
    80003a8a:	06e04363          	bgtz	a4,80003af0 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a8e:	0004a903          	lw	s2,0(s1)
    80003a92:	0094ca83          	lbu	s5,9(s1)
    80003a96:	0104ba03          	ld	s4,16(s1)
    80003a9a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a9e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003aa2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003aa6:	00016517          	auipc	a0,0x16
    80003aaa:	ec250513          	addi	a0,a0,-318 # 80019968 <ftable>
    80003aae:	00002097          	auipc	ra,0x2
    80003ab2:	7ec080e7          	jalr	2028(ra) # 8000629a <release>

  if(ff.type == FD_PIPE){
    80003ab6:	4785                	li	a5,1
    80003ab8:	04f90d63          	beq	s2,a5,80003b12 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003abc:	3979                	addiw	s2,s2,-2
    80003abe:	4785                	li	a5,1
    80003ac0:	0527e063          	bltu	a5,s2,80003b00 <fileclose+0xa8>
    begin_op();
    80003ac4:	00000097          	auipc	ra,0x0
    80003ac8:	acc080e7          	jalr	-1332(ra) # 80003590 <begin_op>
    iput(ff.ip);
    80003acc:	854e                	mv	a0,s3
    80003ace:	fffff097          	auipc	ra,0xfffff
    80003ad2:	2a0080e7          	jalr	672(ra) # 80002d6e <iput>
    end_op();
    80003ad6:	00000097          	auipc	ra,0x0
    80003ada:	b38080e7          	jalr	-1224(ra) # 8000360e <end_op>
    80003ade:	a00d                	j	80003b00 <fileclose+0xa8>
    panic("fileclose");
    80003ae0:	00005517          	auipc	a0,0x5
    80003ae4:	b4050513          	addi	a0,a0,-1216 # 80008620 <syscalls+0x258>
    80003ae8:	00002097          	auipc	ra,0x2
    80003aec:	148080e7          	jalr	328(ra) # 80005c30 <panic>
    release(&ftable.lock);
    80003af0:	00016517          	auipc	a0,0x16
    80003af4:	e7850513          	addi	a0,a0,-392 # 80019968 <ftable>
    80003af8:	00002097          	auipc	ra,0x2
    80003afc:	7a2080e7          	jalr	1954(ra) # 8000629a <release>
  }
}
    80003b00:	70e2                	ld	ra,56(sp)
    80003b02:	7442                	ld	s0,48(sp)
    80003b04:	74a2                	ld	s1,40(sp)
    80003b06:	7902                	ld	s2,32(sp)
    80003b08:	69e2                	ld	s3,24(sp)
    80003b0a:	6a42                	ld	s4,16(sp)
    80003b0c:	6aa2                	ld	s5,8(sp)
    80003b0e:	6121                	addi	sp,sp,64
    80003b10:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b12:	85d6                	mv	a1,s5
    80003b14:	8552                	mv	a0,s4
    80003b16:	00000097          	auipc	ra,0x0
    80003b1a:	34c080e7          	jalr	844(ra) # 80003e62 <pipeclose>
    80003b1e:	b7cd                	j	80003b00 <fileclose+0xa8>

0000000080003b20 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b20:	715d                	addi	sp,sp,-80
    80003b22:	e486                	sd	ra,72(sp)
    80003b24:	e0a2                	sd	s0,64(sp)
    80003b26:	fc26                	sd	s1,56(sp)
    80003b28:	f84a                	sd	s2,48(sp)
    80003b2a:	f44e                	sd	s3,40(sp)
    80003b2c:	0880                	addi	s0,sp,80
    80003b2e:	84aa                	mv	s1,a0
    80003b30:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b32:	ffffd097          	auipc	ra,0xffffd
    80003b36:	312080e7          	jalr	786(ra) # 80000e44 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b3a:	409c                	lw	a5,0(s1)
    80003b3c:	37f9                	addiw	a5,a5,-2
    80003b3e:	4705                	li	a4,1
    80003b40:	04f76763          	bltu	a4,a5,80003b8e <filestat+0x6e>
    80003b44:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b46:	6c88                	ld	a0,24(s1)
    80003b48:	fffff097          	auipc	ra,0xfffff
    80003b4c:	06c080e7          	jalr	108(ra) # 80002bb4 <ilock>
    stati(f->ip, &st);
    80003b50:	fb840593          	addi	a1,s0,-72
    80003b54:	6c88                	ld	a0,24(s1)
    80003b56:	fffff097          	auipc	ra,0xfffff
    80003b5a:	2e8080e7          	jalr	744(ra) # 80002e3e <stati>
    iunlock(f->ip);
    80003b5e:	6c88                	ld	a0,24(s1)
    80003b60:	fffff097          	auipc	ra,0xfffff
    80003b64:	116080e7          	jalr	278(ra) # 80002c76 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b68:	46e1                	li	a3,24
    80003b6a:	fb840613          	addi	a2,s0,-72
    80003b6e:	85ce                	mv	a1,s3
    80003b70:	05093503          	ld	a0,80(s2)
    80003b74:	ffffd097          	auipc	ra,0xffffd
    80003b78:	f94080e7          	jalr	-108(ra) # 80000b08 <copyout>
    80003b7c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b80:	60a6                	ld	ra,72(sp)
    80003b82:	6406                	ld	s0,64(sp)
    80003b84:	74e2                	ld	s1,56(sp)
    80003b86:	7942                	ld	s2,48(sp)
    80003b88:	79a2                	ld	s3,40(sp)
    80003b8a:	6161                	addi	sp,sp,80
    80003b8c:	8082                	ret
  return -1;
    80003b8e:	557d                	li	a0,-1
    80003b90:	bfc5                	j	80003b80 <filestat+0x60>

0000000080003b92 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b92:	7179                	addi	sp,sp,-48
    80003b94:	f406                	sd	ra,40(sp)
    80003b96:	f022                	sd	s0,32(sp)
    80003b98:	ec26                	sd	s1,24(sp)
    80003b9a:	e84a                	sd	s2,16(sp)
    80003b9c:	e44e                	sd	s3,8(sp)
    80003b9e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ba0:	00854783          	lbu	a5,8(a0)
    80003ba4:	c3d5                	beqz	a5,80003c48 <fileread+0xb6>
    80003ba6:	84aa                	mv	s1,a0
    80003ba8:	89ae                	mv	s3,a1
    80003baa:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bac:	411c                	lw	a5,0(a0)
    80003bae:	4705                	li	a4,1
    80003bb0:	04e78963          	beq	a5,a4,80003c02 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bb4:	470d                	li	a4,3
    80003bb6:	04e78d63          	beq	a5,a4,80003c10 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bba:	4709                	li	a4,2
    80003bbc:	06e79e63          	bne	a5,a4,80003c38 <fileread+0xa6>
    ilock(f->ip);
    80003bc0:	6d08                	ld	a0,24(a0)
    80003bc2:	fffff097          	auipc	ra,0xfffff
    80003bc6:	ff2080e7          	jalr	-14(ra) # 80002bb4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bca:	874a                	mv	a4,s2
    80003bcc:	5094                	lw	a3,32(s1)
    80003bce:	864e                	mv	a2,s3
    80003bd0:	4585                	li	a1,1
    80003bd2:	6c88                	ld	a0,24(s1)
    80003bd4:	fffff097          	auipc	ra,0xfffff
    80003bd8:	294080e7          	jalr	660(ra) # 80002e68 <readi>
    80003bdc:	892a                	mv	s2,a0
    80003bde:	00a05563          	blez	a0,80003be8 <fileread+0x56>
      f->off += r;
    80003be2:	509c                	lw	a5,32(s1)
    80003be4:	9fa9                	addw	a5,a5,a0
    80003be6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003be8:	6c88                	ld	a0,24(s1)
    80003bea:	fffff097          	auipc	ra,0xfffff
    80003bee:	08c080e7          	jalr	140(ra) # 80002c76 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bf2:	854a                	mv	a0,s2
    80003bf4:	70a2                	ld	ra,40(sp)
    80003bf6:	7402                	ld	s0,32(sp)
    80003bf8:	64e2                	ld	s1,24(sp)
    80003bfa:	6942                	ld	s2,16(sp)
    80003bfc:	69a2                	ld	s3,8(sp)
    80003bfe:	6145                	addi	sp,sp,48
    80003c00:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c02:	6908                	ld	a0,16(a0)
    80003c04:	00000097          	auipc	ra,0x0
    80003c08:	3c0080e7          	jalr	960(ra) # 80003fc4 <piperead>
    80003c0c:	892a                	mv	s2,a0
    80003c0e:	b7d5                	j	80003bf2 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c10:	02451783          	lh	a5,36(a0)
    80003c14:	03079693          	slli	a3,a5,0x30
    80003c18:	92c1                	srli	a3,a3,0x30
    80003c1a:	4725                	li	a4,9
    80003c1c:	02d76863          	bltu	a4,a3,80003c4c <fileread+0xba>
    80003c20:	0792                	slli	a5,a5,0x4
    80003c22:	00016717          	auipc	a4,0x16
    80003c26:	ca670713          	addi	a4,a4,-858 # 800198c8 <devsw>
    80003c2a:	97ba                	add	a5,a5,a4
    80003c2c:	639c                	ld	a5,0(a5)
    80003c2e:	c38d                	beqz	a5,80003c50 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c30:	4505                	li	a0,1
    80003c32:	9782                	jalr	a5
    80003c34:	892a                	mv	s2,a0
    80003c36:	bf75                	j	80003bf2 <fileread+0x60>
    panic("fileread");
    80003c38:	00005517          	auipc	a0,0x5
    80003c3c:	9f850513          	addi	a0,a0,-1544 # 80008630 <syscalls+0x268>
    80003c40:	00002097          	auipc	ra,0x2
    80003c44:	ff0080e7          	jalr	-16(ra) # 80005c30 <panic>
    return -1;
    80003c48:	597d                	li	s2,-1
    80003c4a:	b765                	j	80003bf2 <fileread+0x60>
      return -1;
    80003c4c:	597d                	li	s2,-1
    80003c4e:	b755                	j	80003bf2 <fileread+0x60>
    80003c50:	597d                	li	s2,-1
    80003c52:	b745                	j	80003bf2 <fileread+0x60>

0000000080003c54 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c54:	715d                	addi	sp,sp,-80
    80003c56:	e486                	sd	ra,72(sp)
    80003c58:	e0a2                	sd	s0,64(sp)
    80003c5a:	fc26                	sd	s1,56(sp)
    80003c5c:	f84a                	sd	s2,48(sp)
    80003c5e:	f44e                	sd	s3,40(sp)
    80003c60:	f052                	sd	s4,32(sp)
    80003c62:	ec56                	sd	s5,24(sp)
    80003c64:	e85a                	sd	s6,16(sp)
    80003c66:	e45e                	sd	s7,8(sp)
    80003c68:	e062                	sd	s8,0(sp)
    80003c6a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c6c:	00954783          	lbu	a5,9(a0)
    80003c70:	10078663          	beqz	a5,80003d7c <filewrite+0x128>
    80003c74:	892a                	mv	s2,a0
    80003c76:	8b2e                	mv	s6,a1
    80003c78:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c7a:	411c                	lw	a5,0(a0)
    80003c7c:	4705                	li	a4,1
    80003c7e:	02e78263          	beq	a5,a4,80003ca2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c82:	470d                	li	a4,3
    80003c84:	02e78663          	beq	a5,a4,80003cb0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c88:	4709                	li	a4,2
    80003c8a:	0ee79163          	bne	a5,a4,80003d6c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c8e:	0ac05d63          	blez	a2,80003d48 <filewrite+0xf4>
    int i = 0;
    80003c92:	4981                	li	s3,0
    80003c94:	6b85                	lui	s7,0x1
    80003c96:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c9a:	6c05                	lui	s8,0x1
    80003c9c:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003ca0:	a861                	j	80003d38 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ca2:	6908                	ld	a0,16(a0)
    80003ca4:	00000097          	auipc	ra,0x0
    80003ca8:	22e080e7          	jalr	558(ra) # 80003ed2 <pipewrite>
    80003cac:	8a2a                	mv	s4,a0
    80003cae:	a045                	j	80003d4e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cb0:	02451783          	lh	a5,36(a0)
    80003cb4:	03079693          	slli	a3,a5,0x30
    80003cb8:	92c1                	srli	a3,a3,0x30
    80003cba:	4725                	li	a4,9
    80003cbc:	0cd76263          	bltu	a4,a3,80003d80 <filewrite+0x12c>
    80003cc0:	0792                	slli	a5,a5,0x4
    80003cc2:	00016717          	auipc	a4,0x16
    80003cc6:	c0670713          	addi	a4,a4,-1018 # 800198c8 <devsw>
    80003cca:	97ba                	add	a5,a5,a4
    80003ccc:	679c                	ld	a5,8(a5)
    80003cce:	cbdd                	beqz	a5,80003d84 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cd0:	4505                	li	a0,1
    80003cd2:	9782                	jalr	a5
    80003cd4:	8a2a                	mv	s4,a0
    80003cd6:	a8a5                	j	80003d4e <filewrite+0xfa>
    80003cd8:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cdc:	00000097          	auipc	ra,0x0
    80003ce0:	8b4080e7          	jalr	-1868(ra) # 80003590 <begin_op>
      ilock(f->ip);
    80003ce4:	01893503          	ld	a0,24(s2)
    80003ce8:	fffff097          	auipc	ra,0xfffff
    80003cec:	ecc080e7          	jalr	-308(ra) # 80002bb4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cf0:	8756                	mv	a4,s5
    80003cf2:	02092683          	lw	a3,32(s2)
    80003cf6:	01698633          	add	a2,s3,s6
    80003cfa:	4585                	li	a1,1
    80003cfc:	01893503          	ld	a0,24(s2)
    80003d00:	fffff097          	auipc	ra,0xfffff
    80003d04:	260080e7          	jalr	608(ra) # 80002f60 <writei>
    80003d08:	84aa                	mv	s1,a0
    80003d0a:	00a05763          	blez	a0,80003d18 <filewrite+0xc4>
        f->off += r;
    80003d0e:	02092783          	lw	a5,32(s2)
    80003d12:	9fa9                	addw	a5,a5,a0
    80003d14:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d18:	01893503          	ld	a0,24(s2)
    80003d1c:	fffff097          	auipc	ra,0xfffff
    80003d20:	f5a080e7          	jalr	-166(ra) # 80002c76 <iunlock>
      end_op();
    80003d24:	00000097          	auipc	ra,0x0
    80003d28:	8ea080e7          	jalr	-1814(ra) # 8000360e <end_op>

      if(r != n1){
    80003d2c:	009a9f63          	bne	s5,s1,80003d4a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d30:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d34:	0149db63          	bge	s3,s4,80003d4a <filewrite+0xf6>
      int n1 = n - i;
    80003d38:	413a04bb          	subw	s1,s4,s3
    80003d3c:	0004879b          	sext.w	a5,s1
    80003d40:	f8fbdce3          	bge	s7,a5,80003cd8 <filewrite+0x84>
    80003d44:	84e2                	mv	s1,s8
    80003d46:	bf49                	j	80003cd8 <filewrite+0x84>
    int i = 0;
    80003d48:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d4a:	013a1f63          	bne	s4,s3,80003d68 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d4e:	8552                	mv	a0,s4
    80003d50:	60a6                	ld	ra,72(sp)
    80003d52:	6406                	ld	s0,64(sp)
    80003d54:	74e2                	ld	s1,56(sp)
    80003d56:	7942                	ld	s2,48(sp)
    80003d58:	79a2                	ld	s3,40(sp)
    80003d5a:	7a02                	ld	s4,32(sp)
    80003d5c:	6ae2                	ld	s5,24(sp)
    80003d5e:	6b42                	ld	s6,16(sp)
    80003d60:	6ba2                	ld	s7,8(sp)
    80003d62:	6c02                	ld	s8,0(sp)
    80003d64:	6161                	addi	sp,sp,80
    80003d66:	8082                	ret
    ret = (i == n ? n : -1);
    80003d68:	5a7d                	li	s4,-1
    80003d6a:	b7d5                	j	80003d4e <filewrite+0xfa>
    panic("filewrite");
    80003d6c:	00005517          	auipc	a0,0x5
    80003d70:	8d450513          	addi	a0,a0,-1836 # 80008640 <syscalls+0x278>
    80003d74:	00002097          	auipc	ra,0x2
    80003d78:	ebc080e7          	jalr	-324(ra) # 80005c30 <panic>
    return -1;
    80003d7c:	5a7d                	li	s4,-1
    80003d7e:	bfc1                	j	80003d4e <filewrite+0xfa>
      return -1;
    80003d80:	5a7d                	li	s4,-1
    80003d82:	b7f1                	j	80003d4e <filewrite+0xfa>
    80003d84:	5a7d                	li	s4,-1
    80003d86:	b7e1                	j	80003d4e <filewrite+0xfa>

0000000080003d88 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d88:	7179                	addi	sp,sp,-48
    80003d8a:	f406                	sd	ra,40(sp)
    80003d8c:	f022                	sd	s0,32(sp)
    80003d8e:	ec26                	sd	s1,24(sp)
    80003d90:	e84a                	sd	s2,16(sp)
    80003d92:	e44e                	sd	s3,8(sp)
    80003d94:	e052                	sd	s4,0(sp)
    80003d96:	1800                	addi	s0,sp,48
    80003d98:	84aa                	mv	s1,a0
    80003d9a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d9c:	0005b023          	sd	zero,0(a1)
    80003da0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003da4:	00000097          	auipc	ra,0x0
    80003da8:	bf8080e7          	jalr	-1032(ra) # 8000399c <filealloc>
    80003dac:	e088                	sd	a0,0(s1)
    80003dae:	c551                	beqz	a0,80003e3a <pipealloc+0xb2>
    80003db0:	00000097          	auipc	ra,0x0
    80003db4:	bec080e7          	jalr	-1044(ra) # 8000399c <filealloc>
    80003db8:	00aa3023          	sd	a0,0(s4)
    80003dbc:	c92d                	beqz	a0,80003e2e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dbe:	ffffc097          	auipc	ra,0xffffc
    80003dc2:	35c080e7          	jalr	860(ra) # 8000011a <kalloc>
    80003dc6:	892a                	mv	s2,a0
    80003dc8:	c125                	beqz	a0,80003e28 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dca:	4985                	li	s3,1
    80003dcc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dd0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dd4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dd8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ddc:	00005597          	auipc	a1,0x5
    80003de0:	87458593          	addi	a1,a1,-1932 # 80008650 <syscalls+0x288>
    80003de4:	00002097          	auipc	ra,0x2
    80003de8:	372080e7          	jalr	882(ra) # 80006156 <initlock>
  (*f0)->type = FD_PIPE;
    80003dec:	609c                	ld	a5,0(s1)
    80003dee:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003df2:	609c                	ld	a5,0(s1)
    80003df4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003df8:	609c                	ld	a5,0(s1)
    80003dfa:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003dfe:	609c                	ld	a5,0(s1)
    80003e00:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e04:	000a3783          	ld	a5,0(s4)
    80003e08:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e0c:	000a3783          	ld	a5,0(s4)
    80003e10:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e14:	000a3783          	ld	a5,0(s4)
    80003e18:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e1c:	000a3783          	ld	a5,0(s4)
    80003e20:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e24:	4501                	li	a0,0
    80003e26:	a025                	j	80003e4e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e28:	6088                	ld	a0,0(s1)
    80003e2a:	e501                	bnez	a0,80003e32 <pipealloc+0xaa>
    80003e2c:	a039                	j	80003e3a <pipealloc+0xb2>
    80003e2e:	6088                	ld	a0,0(s1)
    80003e30:	c51d                	beqz	a0,80003e5e <pipealloc+0xd6>
    fileclose(*f0);
    80003e32:	00000097          	auipc	ra,0x0
    80003e36:	c26080e7          	jalr	-986(ra) # 80003a58 <fileclose>
  if(*f1)
    80003e3a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e3e:	557d                	li	a0,-1
  if(*f1)
    80003e40:	c799                	beqz	a5,80003e4e <pipealloc+0xc6>
    fileclose(*f1);
    80003e42:	853e                	mv	a0,a5
    80003e44:	00000097          	auipc	ra,0x0
    80003e48:	c14080e7          	jalr	-1004(ra) # 80003a58 <fileclose>
  return -1;
    80003e4c:	557d                	li	a0,-1
}
    80003e4e:	70a2                	ld	ra,40(sp)
    80003e50:	7402                	ld	s0,32(sp)
    80003e52:	64e2                	ld	s1,24(sp)
    80003e54:	6942                	ld	s2,16(sp)
    80003e56:	69a2                	ld	s3,8(sp)
    80003e58:	6a02                	ld	s4,0(sp)
    80003e5a:	6145                	addi	sp,sp,48
    80003e5c:	8082                	ret
  return -1;
    80003e5e:	557d                	li	a0,-1
    80003e60:	b7fd                	j	80003e4e <pipealloc+0xc6>

0000000080003e62 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e62:	1101                	addi	sp,sp,-32
    80003e64:	ec06                	sd	ra,24(sp)
    80003e66:	e822                	sd	s0,16(sp)
    80003e68:	e426                	sd	s1,8(sp)
    80003e6a:	e04a                	sd	s2,0(sp)
    80003e6c:	1000                	addi	s0,sp,32
    80003e6e:	84aa                	mv	s1,a0
    80003e70:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e72:	00002097          	auipc	ra,0x2
    80003e76:	374080e7          	jalr	884(ra) # 800061e6 <acquire>
  if(writable){
    80003e7a:	02090d63          	beqz	s2,80003eb4 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e7e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e82:	21848513          	addi	a0,s1,536
    80003e86:	ffffe097          	auipc	ra,0xffffe
    80003e8a:	852080e7          	jalr	-1966(ra) # 800016d8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e8e:	2204b783          	ld	a5,544(s1)
    80003e92:	eb95                	bnez	a5,80003ec6 <pipeclose+0x64>
    release(&pi->lock);
    80003e94:	8526                	mv	a0,s1
    80003e96:	00002097          	auipc	ra,0x2
    80003e9a:	404080e7          	jalr	1028(ra) # 8000629a <release>
    kfree((char*)pi);
    80003e9e:	8526                	mv	a0,s1
    80003ea0:	ffffc097          	auipc	ra,0xffffc
    80003ea4:	17c080e7          	jalr	380(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ea8:	60e2                	ld	ra,24(sp)
    80003eaa:	6442                	ld	s0,16(sp)
    80003eac:	64a2                	ld	s1,8(sp)
    80003eae:	6902                	ld	s2,0(sp)
    80003eb0:	6105                	addi	sp,sp,32
    80003eb2:	8082                	ret
    pi->readopen = 0;
    80003eb4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003eb8:	21c48513          	addi	a0,s1,540
    80003ebc:	ffffe097          	auipc	ra,0xffffe
    80003ec0:	81c080e7          	jalr	-2020(ra) # 800016d8 <wakeup>
    80003ec4:	b7e9                	j	80003e8e <pipeclose+0x2c>
    release(&pi->lock);
    80003ec6:	8526                	mv	a0,s1
    80003ec8:	00002097          	auipc	ra,0x2
    80003ecc:	3d2080e7          	jalr	978(ra) # 8000629a <release>
}
    80003ed0:	bfe1                	j	80003ea8 <pipeclose+0x46>

0000000080003ed2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ed2:	711d                	addi	sp,sp,-96
    80003ed4:	ec86                	sd	ra,88(sp)
    80003ed6:	e8a2                	sd	s0,80(sp)
    80003ed8:	e4a6                	sd	s1,72(sp)
    80003eda:	e0ca                	sd	s2,64(sp)
    80003edc:	fc4e                	sd	s3,56(sp)
    80003ede:	f852                	sd	s4,48(sp)
    80003ee0:	f456                	sd	s5,40(sp)
    80003ee2:	f05a                	sd	s6,32(sp)
    80003ee4:	ec5e                	sd	s7,24(sp)
    80003ee6:	e862                	sd	s8,16(sp)
    80003ee8:	1080                	addi	s0,sp,96
    80003eea:	84aa                	mv	s1,a0
    80003eec:	8aae                	mv	s5,a1
    80003eee:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ef0:	ffffd097          	auipc	ra,0xffffd
    80003ef4:	f54080e7          	jalr	-172(ra) # 80000e44 <myproc>
    80003ef8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003efa:	8526                	mv	a0,s1
    80003efc:	00002097          	auipc	ra,0x2
    80003f00:	2ea080e7          	jalr	746(ra) # 800061e6 <acquire>
  while(i < n){
    80003f04:	0b405363          	blez	s4,80003faa <pipewrite+0xd8>
  int i = 0;
    80003f08:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f0a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f0c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f10:	21c48b93          	addi	s7,s1,540
    80003f14:	a089                	j	80003f56 <pipewrite+0x84>
      release(&pi->lock);
    80003f16:	8526                	mv	a0,s1
    80003f18:	00002097          	auipc	ra,0x2
    80003f1c:	382080e7          	jalr	898(ra) # 8000629a <release>
      return -1;
    80003f20:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f22:	854a                	mv	a0,s2
    80003f24:	60e6                	ld	ra,88(sp)
    80003f26:	6446                	ld	s0,80(sp)
    80003f28:	64a6                	ld	s1,72(sp)
    80003f2a:	6906                	ld	s2,64(sp)
    80003f2c:	79e2                	ld	s3,56(sp)
    80003f2e:	7a42                	ld	s4,48(sp)
    80003f30:	7aa2                	ld	s5,40(sp)
    80003f32:	7b02                	ld	s6,32(sp)
    80003f34:	6be2                	ld	s7,24(sp)
    80003f36:	6c42                	ld	s8,16(sp)
    80003f38:	6125                	addi	sp,sp,96
    80003f3a:	8082                	ret
      wakeup(&pi->nread);
    80003f3c:	8562                	mv	a0,s8
    80003f3e:	ffffd097          	auipc	ra,0xffffd
    80003f42:	79a080e7          	jalr	1946(ra) # 800016d8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f46:	85a6                	mv	a1,s1
    80003f48:	855e                	mv	a0,s7
    80003f4a:	ffffd097          	auipc	ra,0xffffd
    80003f4e:	602080e7          	jalr	1538(ra) # 8000154c <sleep>
  while(i < n){
    80003f52:	05495d63          	bge	s2,s4,80003fac <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f56:	2204a783          	lw	a5,544(s1)
    80003f5a:	dfd5                	beqz	a5,80003f16 <pipewrite+0x44>
    80003f5c:	0289a783          	lw	a5,40(s3)
    80003f60:	fbdd                	bnez	a5,80003f16 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f62:	2184a783          	lw	a5,536(s1)
    80003f66:	21c4a703          	lw	a4,540(s1)
    80003f6a:	2007879b          	addiw	a5,a5,512
    80003f6e:	fcf707e3          	beq	a4,a5,80003f3c <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f72:	4685                	li	a3,1
    80003f74:	01590633          	add	a2,s2,s5
    80003f78:	faf40593          	addi	a1,s0,-81
    80003f7c:	0509b503          	ld	a0,80(s3)
    80003f80:	ffffd097          	auipc	ra,0xffffd
    80003f84:	c14080e7          	jalr	-1004(ra) # 80000b94 <copyin>
    80003f88:	03650263          	beq	a0,s6,80003fac <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f8c:	21c4a783          	lw	a5,540(s1)
    80003f90:	0017871b          	addiw	a4,a5,1
    80003f94:	20e4ae23          	sw	a4,540(s1)
    80003f98:	1ff7f793          	andi	a5,a5,511
    80003f9c:	97a6                	add	a5,a5,s1
    80003f9e:	faf44703          	lbu	a4,-81(s0)
    80003fa2:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fa6:	2905                	addiw	s2,s2,1
    80003fa8:	b76d                	j	80003f52 <pipewrite+0x80>
  int i = 0;
    80003faa:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fac:	21848513          	addi	a0,s1,536
    80003fb0:	ffffd097          	auipc	ra,0xffffd
    80003fb4:	728080e7          	jalr	1832(ra) # 800016d8 <wakeup>
  release(&pi->lock);
    80003fb8:	8526                	mv	a0,s1
    80003fba:	00002097          	auipc	ra,0x2
    80003fbe:	2e0080e7          	jalr	736(ra) # 8000629a <release>
  return i;
    80003fc2:	b785                	j	80003f22 <pipewrite+0x50>

0000000080003fc4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fc4:	715d                	addi	sp,sp,-80
    80003fc6:	e486                	sd	ra,72(sp)
    80003fc8:	e0a2                	sd	s0,64(sp)
    80003fca:	fc26                	sd	s1,56(sp)
    80003fcc:	f84a                	sd	s2,48(sp)
    80003fce:	f44e                	sd	s3,40(sp)
    80003fd0:	f052                	sd	s4,32(sp)
    80003fd2:	ec56                	sd	s5,24(sp)
    80003fd4:	e85a                	sd	s6,16(sp)
    80003fd6:	0880                	addi	s0,sp,80
    80003fd8:	84aa                	mv	s1,a0
    80003fda:	892e                	mv	s2,a1
    80003fdc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fde:	ffffd097          	auipc	ra,0xffffd
    80003fe2:	e66080e7          	jalr	-410(ra) # 80000e44 <myproc>
    80003fe6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fe8:	8526                	mv	a0,s1
    80003fea:	00002097          	auipc	ra,0x2
    80003fee:	1fc080e7          	jalr	508(ra) # 800061e6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ff2:	2184a703          	lw	a4,536(s1)
    80003ff6:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ffa:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ffe:	02f71463          	bne	a4,a5,80004026 <piperead+0x62>
    80004002:	2244a783          	lw	a5,548(s1)
    80004006:	c385                	beqz	a5,80004026 <piperead+0x62>
    if(pr->killed){
    80004008:	028a2783          	lw	a5,40(s4)
    8000400c:	ebc9                	bnez	a5,8000409e <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000400e:	85a6                	mv	a1,s1
    80004010:	854e                	mv	a0,s3
    80004012:	ffffd097          	auipc	ra,0xffffd
    80004016:	53a080e7          	jalr	1338(ra) # 8000154c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000401a:	2184a703          	lw	a4,536(s1)
    8000401e:	21c4a783          	lw	a5,540(s1)
    80004022:	fef700e3          	beq	a4,a5,80004002 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004026:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004028:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000402a:	05505463          	blez	s5,80004072 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    8000402e:	2184a783          	lw	a5,536(s1)
    80004032:	21c4a703          	lw	a4,540(s1)
    80004036:	02f70e63          	beq	a4,a5,80004072 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000403a:	0017871b          	addiw	a4,a5,1
    8000403e:	20e4ac23          	sw	a4,536(s1)
    80004042:	1ff7f793          	andi	a5,a5,511
    80004046:	97a6                	add	a5,a5,s1
    80004048:	0187c783          	lbu	a5,24(a5)
    8000404c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004050:	4685                	li	a3,1
    80004052:	fbf40613          	addi	a2,s0,-65
    80004056:	85ca                	mv	a1,s2
    80004058:	050a3503          	ld	a0,80(s4)
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	aac080e7          	jalr	-1364(ra) # 80000b08 <copyout>
    80004064:	01650763          	beq	a0,s6,80004072 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004068:	2985                	addiw	s3,s3,1
    8000406a:	0905                	addi	s2,s2,1
    8000406c:	fd3a91e3          	bne	s5,s3,8000402e <piperead+0x6a>
    80004070:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004072:	21c48513          	addi	a0,s1,540
    80004076:	ffffd097          	auipc	ra,0xffffd
    8000407a:	662080e7          	jalr	1634(ra) # 800016d8 <wakeup>
  release(&pi->lock);
    8000407e:	8526                	mv	a0,s1
    80004080:	00002097          	auipc	ra,0x2
    80004084:	21a080e7          	jalr	538(ra) # 8000629a <release>
  return i;
}
    80004088:	854e                	mv	a0,s3
    8000408a:	60a6                	ld	ra,72(sp)
    8000408c:	6406                	ld	s0,64(sp)
    8000408e:	74e2                	ld	s1,56(sp)
    80004090:	7942                	ld	s2,48(sp)
    80004092:	79a2                	ld	s3,40(sp)
    80004094:	7a02                	ld	s4,32(sp)
    80004096:	6ae2                	ld	s5,24(sp)
    80004098:	6b42                	ld	s6,16(sp)
    8000409a:	6161                	addi	sp,sp,80
    8000409c:	8082                	ret
      release(&pi->lock);
    8000409e:	8526                	mv	a0,s1
    800040a0:	00002097          	auipc	ra,0x2
    800040a4:	1fa080e7          	jalr	506(ra) # 8000629a <release>
      return -1;
    800040a8:	59fd                	li	s3,-1
    800040aa:	bff9                	j	80004088 <piperead+0xc4>

00000000800040ac <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040ac:	de010113          	addi	sp,sp,-544
    800040b0:	20113c23          	sd	ra,536(sp)
    800040b4:	20813823          	sd	s0,528(sp)
    800040b8:	20913423          	sd	s1,520(sp)
    800040bc:	21213023          	sd	s2,512(sp)
    800040c0:	ffce                	sd	s3,504(sp)
    800040c2:	fbd2                	sd	s4,496(sp)
    800040c4:	f7d6                	sd	s5,488(sp)
    800040c6:	f3da                	sd	s6,480(sp)
    800040c8:	efde                	sd	s7,472(sp)
    800040ca:	ebe2                	sd	s8,464(sp)
    800040cc:	e7e6                	sd	s9,456(sp)
    800040ce:	e3ea                	sd	s10,448(sp)
    800040d0:	ff6e                	sd	s11,440(sp)
    800040d2:	1400                	addi	s0,sp,544
    800040d4:	892a                	mv	s2,a0
    800040d6:	dea43423          	sd	a0,-536(s0)
    800040da:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040de:	ffffd097          	auipc	ra,0xffffd
    800040e2:	d66080e7          	jalr	-666(ra) # 80000e44 <myproc>
    800040e6:	84aa                	mv	s1,a0

  begin_op();
    800040e8:	fffff097          	auipc	ra,0xfffff
    800040ec:	4a8080e7          	jalr	1192(ra) # 80003590 <begin_op>

  if((ip = namei(path)) == 0){
    800040f0:	854a                	mv	a0,s2
    800040f2:	fffff097          	auipc	ra,0xfffff
    800040f6:	27e080e7          	jalr	638(ra) # 80003370 <namei>
    800040fa:	c93d                	beqz	a0,80004170 <exec+0xc4>
    800040fc:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040fe:	fffff097          	auipc	ra,0xfffff
    80004102:	ab6080e7          	jalr	-1354(ra) # 80002bb4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004106:	04000713          	li	a4,64
    8000410a:	4681                	li	a3,0
    8000410c:	e5040613          	addi	a2,s0,-432
    80004110:	4581                	li	a1,0
    80004112:	8556                	mv	a0,s5
    80004114:	fffff097          	auipc	ra,0xfffff
    80004118:	d54080e7          	jalr	-684(ra) # 80002e68 <readi>
    8000411c:	04000793          	li	a5,64
    80004120:	00f51a63          	bne	a0,a5,80004134 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004124:	e5042703          	lw	a4,-432(s0)
    80004128:	464c47b7          	lui	a5,0x464c4
    8000412c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004130:	04f70663          	beq	a4,a5,8000417c <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004134:	8556                	mv	a0,s5
    80004136:	fffff097          	auipc	ra,0xfffff
    8000413a:	ce0080e7          	jalr	-800(ra) # 80002e16 <iunlockput>
    end_op();
    8000413e:	fffff097          	auipc	ra,0xfffff
    80004142:	4d0080e7          	jalr	1232(ra) # 8000360e <end_op>
  }
  return -1;
    80004146:	557d                	li	a0,-1
}
    80004148:	21813083          	ld	ra,536(sp)
    8000414c:	21013403          	ld	s0,528(sp)
    80004150:	20813483          	ld	s1,520(sp)
    80004154:	20013903          	ld	s2,512(sp)
    80004158:	79fe                	ld	s3,504(sp)
    8000415a:	7a5e                	ld	s4,496(sp)
    8000415c:	7abe                	ld	s5,488(sp)
    8000415e:	7b1e                	ld	s6,480(sp)
    80004160:	6bfe                	ld	s7,472(sp)
    80004162:	6c5e                	ld	s8,464(sp)
    80004164:	6cbe                	ld	s9,456(sp)
    80004166:	6d1e                	ld	s10,448(sp)
    80004168:	7dfa                	ld	s11,440(sp)
    8000416a:	22010113          	addi	sp,sp,544
    8000416e:	8082                	ret
    end_op();
    80004170:	fffff097          	auipc	ra,0xfffff
    80004174:	49e080e7          	jalr	1182(ra) # 8000360e <end_op>
    return -1;
    80004178:	557d                	li	a0,-1
    8000417a:	b7f9                	j	80004148 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000417c:	8526                	mv	a0,s1
    8000417e:	ffffd097          	auipc	ra,0xffffd
    80004182:	d8a080e7          	jalr	-630(ra) # 80000f08 <proc_pagetable>
    80004186:	8b2a                	mv	s6,a0
    80004188:	d555                	beqz	a0,80004134 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000418a:	e7042783          	lw	a5,-400(s0)
    8000418e:	e8845703          	lhu	a4,-376(s0)
    80004192:	c735                	beqz	a4,800041fe <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004194:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004196:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    8000419a:	6a05                	lui	s4,0x1
    8000419c:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041a0:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041a4:	6d85                	lui	s11,0x1
    800041a6:	7d7d                	lui	s10,0xfffff
    800041a8:	ac1d                	j	800043de <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041aa:	00004517          	auipc	a0,0x4
    800041ae:	4ae50513          	addi	a0,a0,1198 # 80008658 <syscalls+0x290>
    800041b2:	00002097          	auipc	ra,0x2
    800041b6:	a7e080e7          	jalr	-1410(ra) # 80005c30 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041ba:	874a                	mv	a4,s2
    800041bc:	009c86bb          	addw	a3,s9,s1
    800041c0:	4581                	li	a1,0
    800041c2:	8556                	mv	a0,s5
    800041c4:	fffff097          	auipc	ra,0xfffff
    800041c8:	ca4080e7          	jalr	-860(ra) # 80002e68 <readi>
    800041cc:	2501                	sext.w	a0,a0
    800041ce:	1aa91863          	bne	s2,a0,8000437e <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800041d2:	009d84bb          	addw	s1,s11,s1
    800041d6:	013d09bb          	addw	s3,s10,s3
    800041da:	1f74f263          	bgeu	s1,s7,800043be <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    800041de:	02049593          	slli	a1,s1,0x20
    800041e2:	9181                	srli	a1,a1,0x20
    800041e4:	95e2                	add	a1,a1,s8
    800041e6:	855a                	mv	a0,s6
    800041e8:	ffffc097          	auipc	ra,0xffffc
    800041ec:	318080e7          	jalr	792(ra) # 80000500 <walkaddr>
    800041f0:	862a                	mv	a2,a0
    if(pa == 0)
    800041f2:	dd45                	beqz	a0,800041aa <exec+0xfe>
      n = PGSIZE;
    800041f4:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800041f6:	fd49f2e3          	bgeu	s3,s4,800041ba <exec+0x10e>
      n = sz - i;
    800041fa:	894e                	mv	s2,s3
    800041fc:	bf7d                	j	800041ba <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041fe:	4481                	li	s1,0
  iunlockput(ip);
    80004200:	8556                	mv	a0,s5
    80004202:	fffff097          	auipc	ra,0xfffff
    80004206:	c14080e7          	jalr	-1004(ra) # 80002e16 <iunlockput>
  end_op();
    8000420a:	fffff097          	auipc	ra,0xfffff
    8000420e:	404080e7          	jalr	1028(ra) # 8000360e <end_op>
  p = myproc();
    80004212:	ffffd097          	auipc	ra,0xffffd
    80004216:	c32080e7          	jalr	-974(ra) # 80000e44 <myproc>
    8000421a:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000421c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004220:	6785                	lui	a5,0x1
    80004222:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004224:	97a6                	add	a5,a5,s1
    80004226:	777d                	lui	a4,0xfffff
    80004228:	8ff9                	and	a5,a5,a4
    8000422a:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000422e:	6609                	lui	a2,0x2
    80004230:	963e                	add	a2,a2,a5
    80004232:	85be                	mv	a1,a5
    80004234:	855a                	mv	a0,s6
    80004236:	ffffc097          	auipc	ra,0xffffc
    8000423a:	67e080e7          	jalr	1662(ra) # 800008b4 <uvmalloc>
    8000423e:	8c2a                	mv	s8,a0
  ip = 0;
    80004240:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004242:	12050e63          	beqz	a0,8000437e <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004246:	75f9                	lui	a1,0xffffe
    80004248:	95aa                	add	a1,a1,a0
    8000424a:	855a                	mv	a0,s6
    8000424c:	ffffd097          	auipc	ra,0xffffd
    80004250:	88a080e7          	jalr	-1910(ra) # 80000ad6 <uvmclear>
  stackbase = sp - PGSIZE;
    80004254:	7afd                	lui	s5,0xfffff
    80004256:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004258:	df043783          	ld	a5,-528(s0)
    8000425c:	6388                	ld	a0,0(a5)
    8000425e:	c925                	beqz	a0,800042ce <exec+0x222>
    80004260:	e9040993          	addi	s3,s0,-368
    80004264:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004268:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000426a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000426c:	ffffc097          	auipc	ra,0xffffc
    80004270:	08a080e7          	jalr	138(ra) # 800002f6 <strlen>
    80004274:	0015079b          	addiw	a5,a0,1
    80004278:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000427c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004280:	13596363          	bltu	s2,s5,800043a6 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004284:	df043d83          	ld	s11,-528(s0)
    80004288:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000428c:	8552                	mv	a0,s4
    8000428e:	ffffc097          	auipc	ra,0xffffc
    80004292:	068080e7          	jalr	104(ra) # 800002f6 <strlen>
    80004296:	0015069b          	addiw	a3,a0,1
    8000429a:	8652                	mv	a2,s4
    8000429c:	85ca                	mv	a1,s2
    8000429e:	855a                	mv	a0,s6
    800042a0:	ffffd097          	auipc	ra,0xffffd
    800042a4:	868080e7          	jalr	-1944(ra) # 80000b08 <copyout>
    800042a8:	10054363          	bltz	a0,800043ae <exec+0x302>
    ustack[argc] = sp;
    800042ac:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042b0:	0485                	addi	s1,s1,1
    800042b2:	008d8793          	addi	a5,s11,8
    800042b6:	def43823          	sd	a5,-528(s0)
    800042ba:	008db503          	ld	a0,8(s11)
    800042be:	c911                	beqz	a0,800042d2 <exec+0x226>
    if(argc >= MAXARG)
    800042c0:	09a1                	addi	s3,s3,8
    800042c2:	fb3c95e3          	bne	s9,s3,8000426c <exec+0x1c0>
  sz = sz1;
    800042c6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042ca:	4a81                	li	s5,0
    800042cc:	a84d                	j	8000437e <exec+0x2d2>
  sp = sz;
    800042ce:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042d0:	4481                	li	s1,0
  ustack[argc] = 0;
    800042d2:	00349793          	slli	a5,s1,0x3
    800042d6:	f9078793          	addi	a5,a5,-112
    800042da:	97a2                	add	a5,a5,s0
    800042dc:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800042e0:	00148693          	addi	a3,s1,1
    800042e4:	068e                	slli	a3,a3,0x3
    800042e6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042ea:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042ee:	01597663          	bgeu	s2,s5,800042fa <exec+0x24e>
  sz = sz1;
    800042f2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042f6:	4a81                	li	s5,0
    800042f8:	a059                	j	8000437e <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042fa:	e9040613          	addi	a2,s0,-368
    800042fe:	85ca                	mv	a1,s2
    80004300:	855a                	mv	a0,s6
    80004302:	ffffd097          	auipc	ra,0xffffd
    80004306:	806080e7          	jalr	-2042(ra) # 80000b08 <copyout>
    8000430a:	0a054663          	bltz	a0,800043b6 <exec+0x30a>
  p->trapframe->a1 = sp;
    8000430e:	058bb783          	ld	a5,88(s7)
    80004312:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004316:	de843783          	ld	a5,-536(s0)
    8000431a:	0007c703          	lbu	a4,0(a5)
    8000431e:	cf11                	beqz	a4,8000433a <exec+0x28e>
    80004320:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004322:	02f00693          	li	a3,47
    80004326:	a039                	j	80004334 <exec+0x288>
      last = s+1;
    80004328:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000432c:	0785                	addi	a5,a5,1
    8000432e:	fff7c703          	lbu	a4,-1(a5)
    80004332:	c701                	beqz	a4,8000433a <exec+0x28e>
    if(*s == '/')
    80004334:	fed71ce3          	bne	a4,a3,8000432c <exec+0x280>
    80004338:	bfc5                	j	80004328 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000433a:	4641                	li	a2,16
    8000433c:	de843583          	ld	a1,-536(s0)
    80004340:	158b8513          	addi	a0,s7,344
    80004344:	ffffc097          	auipc	ra,0xffffc
    80004348:	f80080e7          	jalr	-128(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    8000434c:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004350:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004354:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004358:	058bb783          	ld	a5,88(s7)
    8000435c:	e6843703          	ld	a4,-408(s0)
    80004360:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004362:	058bb783          	ld	a5,88(s7)
    80004366:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000436a:	85ea                	mv	a1,s10
    8000436c:	ffffd097          	auipc	ra,0xffffd
    80004370:	c38080e7          	jalr	-968(ra) # 80000fa4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004374:	0004851b          	sext.w	a0,s1
    80004378:	bbc1                	j	80004148 <exec+0x9c>
    8000437a:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000437e:	df843583          	ld	a1,-520(s0)
    80004382:	855a                	mv	a0,s6
    80004384:	ffffd097          	auipc	ra,0xffffd
    80004388:	c20080e7          	jalr	-992(ra) # 80000fa4 <proc_freepagetable>
  if(ip){
    8000438c:	da0a94e3          	bnez	s5,80004134 <exec+0x88>
  return -1;
    80004390:	557d                	li	a0,-1
    80004392:	bb5d                	j	80004148 <exec+0x9c>
    80004394:	de943c23          	sd	s1,-520(s0)
    80004398:	b7dd                	j	8000437e <exec+0x2d2>
    8000439a:	de943c23          	sd	s1,-520(s0)
    8000439e:	b7c5                	j	8000437e <exec+0x2d2>
    800043a0:	de943c23          	sd	s1,-520(s0)
    800043a4:	bfe9                	j	8000437e <exec+0x2d2>
  sz = sz1;
    800043a6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043aa:	4a81                	li	s5,0
    800043ac:	bfc9                	j	8000437e <exec+0x2d2>
  sz = sz1;
    800043ae:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043b2:	4a81                	li	s5,0
    800043b4:	b7e9                	j	8000437e <exec+0x2d2>
  sz = sz1;
    800043b6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043ba:	4a81                	li	s5,0
    800043bc:	b7c9                	j	8000437e <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043be:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043c2:	e0843783          	ld	a5,-504(s0)
    800043c6:	0017869b          	addiw	a3,a5,1
    800043ca:	e0d43423          	sd	a3,-504(s0)
    800043ce:	e0043783          	ld	a5,-512(s0)
    800043d2:	0387879b          	addiw	a5,a5,56
    800043d6:	e8845703          	lhu	a4,-376(s0)
    800043da:	e2e6d3e3          	bge	a3,a4,80004200 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043de:	2781                	sext.w	a5,a5
    800043e0:	e0f43023          	sd	a5,-512(s0)
    800043e4:	03800713          	li	a4,56
    800043e8:	86be                	mv	a3,a5
    800043ea:	e1840613          	addi	a2,s0,-488
    800043ee:	4581                	li	a1,0
    800043f0:	8556                	mv	a0,s5
    800043f2:	fffff097          	auipc	ra,0xfffff
    800043f6:	a76080e7          	jalr	-1418(ra) # 80002e68 <readi>
    800043fa:	03800793          	li	a5,56
    800043fe:	f6f51ee3          	bne	a0,a5,8000437a <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004402:	e1842783          	lw	a5,-488(s0)
    80004406:	4705                	li	a4,1
    80004408:	fae79de3          	bne	a5,a4,800043c2 <exec+0x316>
    if(ph.memsz < ph.filesz)
    8000440c:	e4043603          	ld	a2,-448(s0)
    80004410:	e3843783          	ld	a5,-456(s0)
    80004414:	f8f660e3          	bltu	a2,a5,80004394 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004418:	e2843783          	ld	a5,-472(s0)
    8000441c:	963e                	add	a2,a2,a5
    8000441e:	f6f66ee3          	bltu	a2,a5,8000439a <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004422:	85a6                	mv	a1,s1
    80004424:	855a                	mv	a0,s6
    80004426:	ffffc097          	auipc	ra,0xffffc
    8000442a:	48e080e7          	jalr	1166(ra) # 800008b4 <uvmalloc>
    8000442e:	dea43c23          	sd	a0,-520(s0)
    80004432:	d53d                	beqz	a0,800043a0 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    80004434:	e2843c03          	ld	s8,-472(s0)
    80004438:	de043783          	ld	a5,-544(s0)
    8000443c:	00fc77b3          	and	a5,s8,a5
    80004440:	ff9d                	bnez	a5,8000437e <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004442:	e2042c83          	lw	s9,-480(s0)
    80004446:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000444a:	f60b8ae3          	beqz	s7,800043be <exec+0x312>
    8000444e:	89de                	mv	s3,s7
    80004450:	4481                	li	s1,0
    80004452:	b371                	j	800041de <exec+0x132>

0000000080004454 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004454:	7179                	addi	sp,sp,-48
    80004456:	f406                	sd	ra,40(sp)
    80004458:	f022                	sd	s0,32(sp)
    8000445a:	ec26                	sd	s1,24(sp)
    8000445c:	e84a                	sd	s2,16(sp)
    8000445e:	1800                	addi	s0,sp,48
    80004460:	892e                	mv	s2,a1
    80004462:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004464:	fdc40593          	addi	a1,s0,-36
    80004468:	ffffe097          	auipc	ra,0xffffe
    8000446c:	b24080e7          	jalr	-1244(ra) # 80001f8c <argint>
    80004470:	04054063          	bltz	a0,800044b0 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004474:	fdc42703          	lw	a4,-36(s0)
    80004478:	47bd                	li	a5,15
    8000447a:	02e7ed63          	bltu	a5,a4,800044b4 <argfd+0x60>
    8000447e:	ffffd097          	auipc	ra,0xffffd
    80004482:	9c6080e7          	jalr	-1594(ra) # 80000e44 <myproc>
    80004486:	fdc42703          	lw	a4,-36(s0)
    8000448a:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    8000448e:	078e                	slli	a5,a5,0x3
    80004490:	953e                	add	a0,a0,a5
    80004492:	611c                	ld	a5,0(a0)
    80004494:	c395                	beqz	a5,800044b8 <argfd+0x64>
    return -1;
  if(pfd)
    80004496:	00090463          	beqz	s2,8000449e <argfd+0x4a>
    *pfd = fd;
    8000449a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000449e:	4501                	li	a0,0
  if(pf)
    800044a0:	c091                	beqz	s1,800044a4 <argfd+0x50>
    *pf = f;
    800044a2:	e09c                	sd	a5,0(s1)
}
    800044a4:	70a2                	ld	ra,40(sp)
    800044a6:	7402                	ld	s0,32(sp)
    800044a8:	64e2                	ld	s1,24(sp)
    800044aa:	6942                	ld	s2,16(sp)
    800044ac:	6145                	addi	sp,sp,48
    800044ae:	8082                	ret
    return -1;
    800044b0:	557d                	li	a0,-1
    800044b2:	bfcd                	j	800044a4 <argfd+0x50>
    return -1;
    800044b4:	557d                	li	a0,-1
    800044b6:	b7fd                	j	800044a4 <argfd+0x50>
    800044b8:	557d                	li	a0,-1
    800044ba:	b7ed                	j	800044a4 <argfd+0x50>

00000000800044bc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044bc:	1101                	addi	sp,sp,-32
    800044be:	ec06                	sd	ra,24(sp)
    800044c0:	e822                	sd	s0,16(sp)
    800044c2:	e426                	sd	s1,8(sp)
    800044c4:	1000                	addi	s0,sp,32
    800044c6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044c8:	ffffd097          	auipc	ra,0xffffd
    800044cc:	97c080e7          	jalr	-1668(ra) # 80000e44 <myproc>
    800044d0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044d2:	0d050793          	addi	a5,a0,208
    800044d6:	4501                	li	a0,0
    800044d8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044da:	6398                	ld	a4,0(a5)
    800044dc:	cb19                	beqz	a4,800044f2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044de:	2505                	addiw	a0,a0,1
    800044e0:	07a1                	addi	a5,a5,8
    800044e2:	fed51ce3          	bne	a0,a3,800044da <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044e6:	557d                	li	a0,-1
}
    800044e8:	60e2                	ld	ra,24(sp)
    800044ea:	6442                	ld	s0,16(sp)
    800044ec:	64a2                	ld	s1,8(sp)
    800044ee:	6105                	addi	sp,sp,32
    800044f0:	8082                	ret
      p->ofile[fd] = f;
    800044f2:	01a50793          	addi	a5,a0,26
    800044f6:	078e                	slli	a5,a5,0x3
    800044f8:	963e                	add	a2,a2,a5
    800044fa:	e204                	sd	s1,0(a2)
      return fd;
    800044fc:	b7f5                	j	800044e8 <fdalloc+0x2c>

00000000800044fe <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044fe:	715d                	addi	sp,sp,-80
    80004500:	e486                	sd	ra,72(sp)
    80004502:	e0a2                	sd	s0,64(sp)
    80004504:	fc26                	sd	s1,56(sp)
    80004506:	f84a                	sd	s2,48(sp)
    80004508:	f44e                	sd	s3,40(sp)
    8000450a:	f052                	sd	s4,32(sp)
    8000450c:	ec56                	sd	s5,24(sp)
    8000450e:	0880                	addi	s0,sp,80
    80004510:	89ae                	mv	s3,a1
    80004512:	8ab2                	mv	s5,a2
    80004514:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004516:	fb040593          	addi	a1,s0,-80
    8000451a:	fffff097          	auipc	ra,0xfffff
    8000451e:	e74080e7          	jalr	-396(ra) # 8000338e <nameiparent>
    80004522:	892a                	mv	s2,a0
    80004524:	12050e63          	beqz	a0,80004660 <create+0x162>
    return 0;

  ilock(dp);
    80004528:	ffffe097          	auipc	ra,0xffffe
    8000452c:	68c080e7          	jalr	1676(ra) # 80002bb4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004530:	4601                	li	a2,0
    80004532:	fb040593          	addi	a1,s0,-80
    80004536:	854a                	mv	a0,s2
    80004538:	fffff097          	auipc	ra,0xfffff
    8000453c:	b60080e7          	jalr	-1184(ra) # 80003098 <dirlookup>
    80004540:	84aa                	mv	s1,a0
    80004542:	c921                	beqz	a0,80004592 <create+0x94>
    iunlockput(dp);
    80004544:	854a                	mv	a0,s2
    80004546:	fffff097          	auipc	ra,0xfffff
    8000454a:	8d0080e7          	jalr	-1840(ra) # 80002e16 <iunlockput>
    ilock(ip);
    8000454e:	8526                	mv	a0,s1
    80004550:	ffffe097          	auipc	ra,0xffffe
    80004554:	664080e7          	jalr	1636(ra) # 80002bb4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004558:	2981                	sext.w	s3,s3
    8000455a:	4789                	li	a5,2
    8000455c:	02f99463          	bne	s3,a5,80004584 <create+0x86>
    80004560:	0444d783          	lhu	a5,68(s1)
    80004564:	37f9                	addiw	a5,a5,-2
    80004566:	17c2                	slli	a5,a5,0x30
    80004568:	93c1                	srli	a5,a5,0x30
    8000456a:	4705                	li	a4,1
    8000456c:	00f76c63          	bltu	a4,a5,80004584 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004570:	8526                	mv	a0,s1
    80004572:	60a6                	ld	ra,72(sp)
    80004574:	6406                	ld	s0,64(sp)
    80004576:	74e2                	ld	s1,56(sp)
    80004578:	7942                	ld	s2,48(sp)
    8000457a:	79a2                	ld	s3,40(sp)
    8000457c:	7a02                	ld	s4,32(sp)
    8000457e:	6ae2                	ld	s5,24(sp)
    80004580:	6161                	addi	sp,sp,80
    80004582:	8082                	ret
    iunlockput(ip);
    80004584:	8526                	mv	a0,s1
    80004586:	fffff097          	auipc	ra,0xfffff
    8000458a:	890080e7          	jalr	-1904(ra) # 80002e16 <iunlockput>
    return 0;
    8000458e:	4481                	li	s1,0
    80004590:	b7c5                	j	80004570 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004592:	85ce                	mv	a1,s3
    80004594:	00092503          	lw	a0,0(s2)
    80004598:	ffffe097          	auipc	ra,0xffffe
    8000459c:	482080e7          	jalr	1154(ra) # 80002a1a <ialloc>
    800045a0:	84aa                	mv	s1,a0
    800045a2:	c521                	beqz	a0,800045ea <create+0xec>
  ilock(ip);
    800045a4:	ffffe097          	auipc	ra,0xffffe
    800045a8:	610080e7          	jalr	1552(ra) # 80002bb4 <ilock>
  ip->major = major;
    800045ac:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045b0:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045b4:	4a05                	li	s4,1
    800045b6:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800045ba:	8526                	mv	a0,s1
    800045bc:	ffffe097          	auipc	ra,0xffffe
    800045c0:	52c080e7          	jalr	1324(ra) # 80002ae8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045c4:	2981                	sext.w	s3,s3
    800045c6:	03498a63          	beq	s3,s4,800045fa <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800045ca:	40d0                	lw	a2,4(s1)
    800045cc:	fb040593          	addi	a1,s0,-80
    800045d0:	854a                	mv	a0,s2
    800045d2:	fffff097          	auipc	ra,0xfffff
    800045d6:	cdc080e7          	jalr	-804(ra) # 800032ae <dirlink>
    800045da:	06054b63          	bltz	a0,80004650 <create+0x152>
  iunlockput(dp);
    800045de:	854a                	mv	a0,s2
    800045e0:	fffff097          	auipc	ra,0xfffff
    800045e4:	836080e7          	jalr	-1994(ra) # 80002e16 <iunlockput>
  return ip;
    800045e8:	b761                	j	80004570 <create+0x72>
    panic("create: ialloc");
    800045ea:	00004517          	auipc	a0,0x4
    800045ee:	08e50513          	addi	a0,a0,142 # 80008678 <syscalls+0x2b0>
    800045f2:	00001097          	auipc	ra,0x1
    800045f6:	63e080e7          	jalr	1598(ra) # 80005c30 <panic>
    dp->nlink++;  // for ".."
    800045fa:	04a95783          	lhu	a5,74(s2)
    800045fe:	2785                	addiw	a5,a5,1
    80004600:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004604:	854a                	mv	a0,s2
    80004606:	ffffe097          	auipc	ra,0xffffe
    8000460a:	4e2080e7          	jalr	1250(ra) # 80002ae8 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000460e:	40d0                	lw	a2,4(s1)
    80004610:	00004597          	auipc	a1,0x4
    80004614:	07858593          	addi	a1,a1,120 # 80008688 <syscalls+0x2c0>
    80004618:	8526                	mv	a0,s1
    8000461a:	fffff097          	auipc	ra,0xfffff
    8000461e:	c94080e7          	jalr	-876(ra) # 800032ae <dirlink>
    80004622:	00054f63          	bltz	a0,80004640 <create+0x142>
    80004626:	00492603          	lw	a2,4(s2)
    8000462a:	00004597          	auipc	a1,0x4
    8000462e:	06658593          	addi	a1,a1,102 # 80008690 <syscalls+0x2c8>
    80004632:	8526                	mv	a0,s1
    80004634:	fffff097          	auipc	ra,0xfffff
    80004638:	c7a080e7          	jalr	-902(ra) # 800032ae <dirlink>
    8000463c:	f80557e3          	bgez	a0,800045ca <create+0xcc>
      panic("create dots");
    80004640:	00004517          	auipc	a0,0x4
    80004644:	05850513          	addi	a0,a0,88 # 80008698 <syscalls+0x2d0>
    80004648:	00001097          	auipc	ra,0x1
    8000464c:	5e8080e7          	jalr	1512(ra) # 80005c30 <panic>
    panic("create: dirlink");
    80004650:	00004517          	auipc	a0,0x4
    80004654:	05850513          	addi	a0,a0,88 # 800086a8 <syscalls+0x2e0>
    80004658:	00001097          	auipc	ra,0x1
    8000465c:	5d8080e7          	jalr	1496(ra) # 80005c30 <panic>
    return 0;
    80004660:	84aa                	mv	s1,a0
    80004662:	b739                	j	80004570 <create+0x72>

0000000080004664 <sys_dup>:
{
    80004664:	7179                	addi	sp,sp,-48
    80004666:	f406                	sd	ra,40(sp)
    80004668:	f022                	sd	s0,32(sp)
    8000466a:	ec26                	sd	s1,24(sp)
    8000466c:	e84a                	sd	s2,16(sp)
    8000466e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004670:	fd840613          	addi	a2,s0,-40
    80004674:	4581                	li	a1,0
    80004676:	4501                	li	a0,0
    80004678:	00000097          	auipc	ra,0x0
    8000467c:	ddc080e7          	jalr	-548(ra) # 80004454 <argfd>
    return -1;
    80004680:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004682:	02054363          	bltz	a0,800046a8 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004686:	fd843903          	ld	s2,-40(s0)
    8000468a:	854a                	mv	a0,s2
    8000468c:	00000097          	auipc	ra,0x0
    80004690:	e30080e7          	jalr	-464(ra) # 800044bc <fdalloc>
    80004694:	84aa                	mv	s1,a0
    return -1;
    80004696:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004698:	00054863          	bltz	a0,800046a8 <sys_dup+0x44>
  filedup(f);
    8000469c:	854a                	mv	a0,s2
    8000469e:	fffff097          	auipc	ra,0xfffff
    800046a2:	368080e7          	jalr	872(ra) # 80003a06 <filedup>
  return fd;
    800046a6:	87a6                	mv	a5,s1
}
    800046a8:	853e                	mv	a0,a5
    800046aa:	70a2                	ld	ra,40(sp)
    800046ac:	7402                	ld	s0,32(sp)
    800046ae:	64e2                	ld	s1,24(sp)
    800046b0:	6942                	ld	s2,16(sp)
    800046b2:	6145                	addi	sp,sp,48
    800046b4:	8082                	ret

00000000800046b6 <sys_read>:
{
    800046b6:	7179                	addi	sp,sp,-48
    800046b8:	f406                	sd	ra,40(sp)
    800046ba:	f022                	sd	s0,32(sp)
    800046bc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046be:	fe840613          	addi	a2,s0,-24
    800046c2:	4581                	li	a1,0
    800046c4:	4501                	li	a0,0
    800046c6:	00000097          	auipc	ra,0x0
    800046ca:	d8e080e7          	jalr	-626(ra) # 80004454 <argfd>
    return -1;
    800046ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d0:	04054163          	bltz	a0,80004712 <sys_read+0x5c>
    800046d4:	fe440593          	addi	a1,s0,-28
    800046d8:	4509                	li	a0,2
    800046da:	ffffe097          	auipc	ra,0xffffe
    800046de:	8b2080e7          	jalr	-1870(ra) # 80001f8c <argint>
    return -1;
    800046e2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e4:	02054763          	bltz	a0,80004712 <sys_read+0x5c>
    800046e8:	fd840593          	addi	a1,s0,-40
    800046ec:	4505                	li	a0,1
    800046ee:	ffffe097          	auipc	ra,0xffffe
    800046f2:	8c0080e7          	jalr	-1856(ra) # 80001fae <argaddr>
    return -1;
    800046f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f8:	00054d63          	bltz	a0,80004712 <sys_read+0x5c>
  return fileread(f, p, n);
    800046fc:	fe442603          	lw	a2,-28(s0)
    80004700:	fd843583          	ld	a1,-40(s0)
    80004704:	fe843503          	ld	a0,-24(s0)
    80004708:	fffff097          	auipc	ra,0xfffff
    8000470c:	48a080e7          	jalr	1162(ra) # 80003b92 <fileread>
    80004710:	87aa                	mv	a5,a0
}
    80004712:	853e                	mv	a0,a5
    80004714:	70a2                	ld	ra,40(sp)
    80004716:	7402                	ld	s0,32(sp)
    80004718:	6145                	addi	sp,sp,48
    8000471a:	8082                	ret

000000008000471c <sys_write>:
{
    8000471c:	7179                	addi	sp,sp,-48
    8000471e:	f406                	sd	ra,40(sp)
    80004720:	f022                	sd	s0,32(sp)
    80004722:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004724:	fe840613          	addi	a2,s0,-24
    80004728:	4581                	li	a1,0
    8000472a:	4501                	li	a0,0
    8000472c:	00000097          	auipc	ra,0x0
    80004730:	d28080e7          	jalr	-728(ra) # 80004454 <argfd>
    return -1;
    80004734:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004736:	04054163          	bltz	a0,80004778 <sys_write+0x5c>
    8000473a:	fe440593          	addi	a1,s0,-28
    8000473e:	4509                	li	a0,2
    80004740:	ffffe097          	auipc	ra,0xffffe
    80004744:	84c080e7          	jalr	-1972(ra) # 80001f8c <argint>
    return -1;
    80004748:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000474a:	02054763          	bltz	a0,80004778 <sys_write+0x5c>
    8000474e:	fd840593          	addi	a1,s0,-40
    80004752:	4505                	li	a0,1
    80004754:	ffffe097          	auipc	ra,0xffffe
    80004758:	85a080e7          	jalr	-1958(ra) # 80001fae <argaddr>
    return -1;
    8000475c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000475e:	00054d63          	bltz	a0,80004778 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004762:	fe442603          	lw	a2,-28(s0)
    80004766:	fd843583          	ld	a1,-40(s0)
    8000476a:	fe843503          	ld	a0,-24(s0)
    8000476e:	fffff097          	auipc	ra,0xfffff
    80004772:	4e6080e7          	jalr	1254(ra) # 80003c54 <filewrite>
    80004776:	87aa                	mv	a5,a0
}
    80004778:	853e                	mv	a0,a5
    8000477a:	70a2                	ld	ra,40(sp)
    8000477c:	7402                	ld	s0,32(sp)
    8000477e:	6145                	addi	sp,sp,48
    80004780:	8082                	ret

0000000080004782 <sys_close>:
{
    80004782:	1101                	addi	sp,sp,-32
    80004784:	ec06                	sd	ra,24(sp)
    80004786:	e822                	sd	s0,16(sp)
    80004788:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000478a:	fe040613          	addi	a2,s0,-32
    8000478e:	fec40593          	addi	a1,s0,-20
    80004792:	4501                	li	a0,0
    80004794:	00000097          	auipc	ra,0x0
    80004798:	cc0080e7          	jalr	-832(ra) # 80004454 <argfd>
    return -1;
    8000479c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000479e:	02054463          	bltz	a0,800047c6 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047a2:	ffffc097          	auipc	ra,0xffffc
    800047a6:	6a2080e7          	jalr	1698(ra) # 80000e44 <myproc>
    800047aa:	fec42783          	lw	a5,-20(s0)
    800047ae:	07e9                	addi	a5,a5,26
    800047b0:	078e                	slli	a5,a5,0x3
    800047b2:	953e                	add	a0,a0,a5
    800047b4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800047b8:	fe043503          	ld	a0,-32(s0)
    800047bc:	fffff097          	auipc	ra,0xfffff
    800047c0:	29c080e7          	jalr	668(ra) # 80003a58 <fileclose>
  return 0;
    800047c4:	4781                	li	a5,0
}
    800047c6:	853e                	mv	a0,a5
    800047c8:	60e2                	ld	ra,24(sp)
    800047ca:	6442                	ld	s0,16(sp)
    800047cc:	6105                	addi	sp,sp,32
    800047ce:	8082                	ret

00000000800047d0 <sys_fstat>:
{
    800047d0:	1101                	addi	sp,sp,-32
    800047d2:	ec06                	sd	ra,24(sp)
    800047d4:	e822                	sd	s0,16(sp)
    800047d6:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047d8:	fe840613          	addi	a2,s0,-24
    800047dc:	4581                	li	a1,0
    800047de:	4501                	li	a0,0
    800047e0:	00000097          	auipc	ra,0x0
    800047e4:	c74080e7          	jalr	-908(ra) # 80004454 <argfd>
    return -1;
    800047e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047ea:	02054563          	bltz	a0,80004814 <sys_fstat+0x44>
    800047ee:	fe040593          	addi	a1,s0,-32
    800047f2:	4505                	li	a0,1
    800047f4:	ffffd097          	auipc	ra,0xffffd
    800047f8:	7ba080e7          	jalr	1978(ra) # 80001fae <argaddr>
    return -1;
    800047fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047fe:	00054b63          	bltz	a0,80004814 <sys_fstat+0x44>
  return filestat(f, st);
    80004802:	fe043583          	ld	a1,-32(s0)
    80004806:	fe843503          	ld	a0,-24(s0)
    8000480a:	fffff097          	auipc	ra,0xfffff
    8000480e:	316080e7          	jalr	790(ra) # 80003b20 <filestat>
    80004812:	87aa                	mv	a5,a0
}
    80004814:	853e                	mv	a0,a5
    80004816:	60e2                	ld	ra,24(sp)
    80004818:	6442                	ld	s0,16(sp)
    8000481a:	6105                	addi	sp,sp,32
    8000481c:	8082                	ret

000000008000481e <sys_link>:
{
    8000481e:	7169                	addi	sp,sp,-304
    80004820:	f606                	sd	ra,296(sp)
    80004822:	f222                	sd	s0,288(sp)
    80004824:	ee26                	sd	s1,280(sp)
    80004826:	ea4a                	sd	s2,272(sp)
    80004828:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000482a:	08000613          	li	a2,128
    8000482e:	ed040593          	addi	a1,s0,-304
    80004832:	4501                	li	a0,0
    80004834:	ffffd097          	auipc	ra,0xffffd
    80004838:	79c080e7          	jalr	1948(ra) # 80001fd0 <argstr>
    return -1;
    8000483c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000483e:	10054e63          	bltz	a0,8000495a <sys_link+0x13c>
    80004842:	08000613          	li	a2,128
    80004846:	f5040593          	addi	a1,s0,-176
    8000484a:	4505                	li	a0,1
    8000484c:	ffffd097          	auipc	ra,0xffffd
    80004850:	784080e7          	jalr	1924(ra) # 80001fd0 <argstr>
    return -1;
    80004854:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004856:	10054263          	bltz	a0,8000495a <sys_link+0x13c>
  begin_op();
    8000485a:	fffff097          	auipc	ra,0xfffff
    8000485e:	d36080e7          	jalr	-714(ra) # 80003590 <begin_op>
  if((ip = namei(old)) == 0){
    80004862:	ed040513          	addi	a0,s0,-304
    80004866:	fffff097          	auipc	ra,0xfffff
    8000486a:	b0a080e7          	jalr	-1270(ra) # 80003370 <namei>
    8000486e:	84aa                	mv	s1,a0
    80004870:	c551                	beqz	a0,800048fc <sys_link+0xde>
  ilock(ip);
    80004872:	ffffe097          	auipc	ra,0xffffe
    80004876:	342080e7          	jalr	834(ra) # 80002bb4 <ilock>
  if(ip->type == T_DIR){
    8000487a:	04449703          	lh	a4,68(s1)
    8000487e:	4785                	li	a5,1
    80004880:	08f70463          	beq	a4,a5,80004908 <sys_link+0xea>
  ip->nlink++;
    80004884:	04a4d783          	lhu	a5,74(s1)
    80004888:	2785                	addiw	a5,a5,1
    8000488a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000488e:	8526                	mv	a0,s1
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	258080e7          	jalr	600(ra) # 80002ae8 <iupdate>
  iunlock(ip);
    80004898:	8526                	mv	a0,s1
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	3dc080e7          	jalr	988(ra) # 80002c76 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048a2:	fd040593          	addi	a1,s0,-48
    800048a6:	f5040513          	addi	a0,s0,-176
    800048aa:	fffff097          	auipc	ra,0xfffff
    800048ae:	ae4080e7          	jalr	-1308(ra) # 8000338e <nameiparent>
    800048b2:	892a                	mv	s2,a0
    800048b4:	c935                	beqz	a0,80004928 <sys_link+0x10a>
  ilock(dp);
    800048b6:	ffffe097          	auipc	ra,0xffffe
    800048ba:	2fe080e7          	jalr	766(ra) # 80002bb4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048be:	00092703          	lw	a4,0(s2)
    800048c2:	409c                	lw	a5,0(s1)
    800048c4:	04f71d63          	bne	a4,a5,8000491e <sys_link+0x100>
    800048c8:	40d0                	lw	a2,4(s1)
    800048ca:	fd040593          	addi	a1,s0,-48
    800048ce:	854a                	mv	a0,s2
    800048d0:	fffff097          	auipc	ra,0xfffff
    800048d4:	9de080e7          	jalr	-1570(ra) # 800032ae <dirlink>
    800048d8:	04054363          	bltz	a0,8000491e <sys_link+0x100>
  iunlockput(dp);
    800048dc:	854a                	mv	a0,s2
    800048de:	ffffe097          	auipc	ra,0xffffe
    800048e2:	538080e7          	jalr	1336(ra) # 80002e16 <iunlockput>
  iput(ip);
    800048e6:	8526                	mv	a0,s1
    800048e8:	ffffe097          	auipc	ra,0xffffe
    800048ec:	486080e7          	jalr	1158(ra) # 80002d6e <iput>
  end_op();
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	d1e080e7          	jalr	-738(ra) # 8000360e <end_op>
  return 0;
    800048f8:	4781                	li	a5,0
    800048fa:	a085                	j	8000495a <sys_link+0x13c>
    end_op();
    800048fc:	fffff097          	auipc	ra,0xfffff
    80004900:	d12080e7          	jalr	-750(ra) # 8000360e <end_op>
    return -1;
    80004904:	57fd                	li	a5,-1
    80004906:	a891                	j	8000495a <sys_link+0x13c>
    iunlockput(ip);
    80004908:	8526                	mv	a0,s1
    8000490a:	ffffe097          	auipc	ra,0xffffe
    8000490e:	50c080e7          	jalr	1292(ra) # 80002e16 <iunlockput>
    end_op();
    80004912:	fffff097          	auipc	ra,0xfffff
    80004916:	cfc080e7          	jalr	-772(ra) # 8000360e <end_op>
    return -1;
    8000491a:	57fd                	li	a5,-1
    8000491c:	a83d                	j	8000495a <sys_link+0x13c>
    iunlockput(dp);
    8000491e:	854a                	mv	a0,s2
    80004920:	ffffe097          	auipc	ra,0xffffe
    80004924:	4f6080e7          	jalr	1270(ra) # 80002e16 <iunlockput>
  ilock(ip);
    80004928:	8526                	mv	a0,s1
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	28a080e7          	jalr	650(ra) # 80002bb4 <ilock>
  ip->nlink--;
    80004932:	04a4d783          	lhu	a5,74(s1)
    80004936:	37fd                	addiw	a5,a5,-1
    80004938:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000493c:	8526                	mv	a0,s1
    8000493e:	ffffe097          	auipc	ra,0xffffe
    80004942:	1aa080e7          	jalr	426(ra) # 80002ae8 <iupdate>
  iunlockput(ip);
    80004946:	8526                	mv	a0,s1
    80004948:	ffffe097          	auipc	ra,0xffffe
    8000494c:	4ce080e7          	jalr	1230(ra) # 80002e16 <iunlockput>
  end_op();
    80004950:	fffff097          	auipc	ra,0xfffff
    80004954:	cbe080e7          	jalr	-834(ra) # 8000360e <end_op>
  return -1;
    80004958:	57fd                	li	a5,-1
}
    8000495a:	853e                	mv	a0,a5
    8000495c:	70b2                	ld	ra,296(sp)
    8000495e:	7412                	ld	s0,288(sp)
    80004960:	64f2                	ld	s1,280(sp)
    80004962:	6952                	ld	s2,272(sp)
    80004964:	6155                	addi	sp,sp,304
    80004966:	8082                	ret

0000000080004968 <sys_unlink>:
{
    80004968:	7151                	addi	sp,sp,-240
    8000496a:	f586                	sd	ra,232(sp)
    8000496c:	f1a2                	sd	s0,224(sp)
    8000496e:	eda6                	sd	s1,216(sp)
    80004970:	e9ca                	sd	s2,208(sp)
    80004972:	e5ce                	sd	s3,200(sp)
    80004974:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004976:	08000613          	li	a2,128
    8000497a:	f3040593          	addi	a1,s0,-208
    8000497e:	4501                	li	a0,0
    80004980:	ffffd097          	auipc	ra,0xffffd
    80004984:	650080e7          	jalr	1616(ra) # 80001fd0 <argstr>
    80004988:	18054163          	bltz	a0,80004b0a <sys_unlink+0x1a2>
  begin_op();
    8000498c:	fffff097          	auipc	ra,0xfffff
    80004990:	c04080e7          	jalr	-1020(ra) # 80003590 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004994:	fb040593          	addi	a1,s0,-80
    80004998:	f3040513          	addi	a0,s0,-208
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	9f2080e7          	jalr	-1550(ra) # 8000338e <nameiparent>
    800049a4:	84aa                	mv	s1,a0
    800049a6:	c979                	beqz	a0,80004a7c <sys_unlink+0x114>
  ilock(dp);
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	20c080e7          	jalr	524(ra) # 80002bb4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049b0:	00004597          	auipc	a1,0x4
    800049b4:	cd858593          	addi	a1,a1,-808 # 80008688 <syscalls+0x2c0>
    800049b8:	fb040513          	addi	a0,s0,-80
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	6c2080e7          	jalr	1730(ra) # 8000307e <namecmp>
    800049c4:	14050a63          	beqz	a0,80004b18 <sys_unlink+0x1b0>
    800049c8:	00004597          	auipc	a1,0x4
    800049cc:	cc858593          	addi	a1,a1,-824 # 80008690 <syscalls+0x2c8>
    800049d0:	fb040513          	addi	a0,s0,-80
    800049d4:	ffffe097          	auipc	ra,0xffffe
    800049d8:	6aa080e7          	jalr	1706(ra) # 8000307e <namecmp>
    800049dc:	12050e63          	beqz	a0,80004b18 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049e0:	f2c40613          	addi	a2,s0,-212
    800049e4:	fb040593          	addi	a1,s0,-80
    800049e8:	8526                	mv	a0,s1
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	6ae080e7          	jalr	1710(ra) # 80003098 <dirlookup>
    800049f2:	892a                	mv	s2,a0
    800049f4:	12050263          	beqz	a0,80004b18 <sys_unlink+0x1b0>
  ilock(ip);
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	1bc080e7          	jalr	444(ra) # 80002bb4 <ilock>
  if(ip->nlink < 1)
    80004a00:	04a91783          	lh	a5,74(s2)
    80004a04:	08f05263          	blez	a5,80004a88 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a08:	04491703          	lh	a4,68(s2)
    80004a0c:	4785                	li	a5,1
    80004a0e:	08f70563          	beq	a4,a5,80004a98 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a12:	4641                	li	a2,16
    80004a14:	4581                	li	a1,0
    80004a16:	fc040513          	addi	a0,s0,-64
    80004a1a:	ffffb097          	auipc	ra,0xffffb
    80004a1e:	760080e7          	jalr	1888(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a22:	4741                	li	a4,16
    80004a24:	f2c42683          	lw	a3,-212(s0)
    80004a28:	fc040613          	addi	a2,s0,-64
    80004a2c:	4581                	li	a1,0
    80004a2e:	8526                	mv	a0,s1
    80004a30:	ffffe097          	auipc	ra,0xffffe
    80004a34:	530080e7          	jalr	1328(ra) # 80002f60 <writei>
    80004a38:	47c1                	li	a5,16
    80004a3a:	0af51563          	bne	a0,a5,80004ae4 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a3e:	04491703          	lh	a4,68(s2)
    80004a42:	4785                	li	a5,1
    80004a44:	0af70863          	beq	a4,a5,80004af4 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a48:	8526                	mv	a0,s1
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	3cc080e7          	jalr	972(ra) # 80002e16 <iunlockput>
  ip->nlink--;
    80004a52:	04a95783          	lhu	a5,74(s2)
    80004a56:	37fd                	addiw	a5,a5,-1
    80004a58:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a5c:	854a                	mv	a0,s2
    80004a5e:	ffffe097          	auipc	ra,0xffffe
    80004a62:	08a080e7          	jalr	138(ra) # 80002ae8 <iupdate>
  iunlockput(ip);
    80004a66:	854a                	mv	a0,s2
    80004a68:	ffffe097          	auipc	ra,0xffffe
    80004a6c:	3ae080e7          	jalr	942(ra) # 80002e16 <iunlockput>
  end_op();
    80004a70:	fffff097          	auipc	ra,0xfffff
    80004a74:	b9e080e7          	jalr	-1122(ra) # 8000360e <end_op>
  return 0;
    80004a78:	4501                	li	a0,0
    80004a7a:	a84d                	j	80004b2c <sys_unlink+0x1c4>
    end_op();
    80004a7c:	fffff097          	auipc	ra,0xfffff
    80004a80:	b92080e7          	jalr	-1134(ra) # 8000360e <end_op>
    return -1;
    80004a84:	557d                	li	a0,-1
    80004a86:	a05d                	j	80004b2c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a88:	00004517          	auipc	a0,0x4
    80004a8c:	c3050513          	addi	a0,a0,-976 # 800086b8 <syscalls+0x2f0>
    80004a90:	00001097          	auipc	ra,0x1
    80004a94:	1a0080e7          	jalr	416(ra) # 80005c30 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a98:	04c92703          	lw	a4,76(s2)
    80004a9c:	02000793          	li	a5,32
    80004aa0:	f6e7f9e3          	bgeu	a5,a4,80004a12 <sys_unlink+0xaa>
    80004aa4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aa8:	4741                	li	a4,16
    80004aaa:	86ce                	mv	a3,s3
    80004aac:	f1840613          	addi	a2,s0,-232
    80004ab0:	4581                	li	a1,0
    80004ab2:	854a                	mv	a0,s2
    80004ab4:	ffffe097          	auipc	ra,0xffffe
    80004ab8:	3b4080e7          	jalr	948(ra) # 80002e68 <readi>
    80004abc:	47c1                	li	a5,16
    80004abe:	00f51b63          	bne	a0,a5,80004ad4 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ac2:	f1845783          	lhu	a5,-232(s0)
    80004ac6:	e7a1                	bnez	a5,80004b0e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ac8:	29c1                	addiw	s3,s3,16
    80004aca:	04c92783          	lw	a5,76(s2)
    80004ace:	fcf9ede3          	bltu	s3,a5,80004aa8 <sys_unlink+0x140>
    80004ad2:	b781                	j	80004a12 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ad4:	00004517          	auipc	a0,0x4
    80004ad8:	bfc50513          	addi	a0,a0,-1028 # 800086d0 <syscalls+0x308>
    80004adc:	00001097          	auipc	ra,0x1
    80004ae0:	154080e7          	jalr	340(ra) # 80005c30 <panic>
    panic("unlink: writei");
    80004ae4:	00004517          	auipc	a0,0x4
    80004ae8:	c0450513          	addi	a0,a0,-1020 # 800086e8 <syscalls+0x320>
    80004aec:	00001097          	auipc	ra,0x1
    80004af0:	144080e7          	jalr	324(ra) # 80005c30 <panic>
    dp->nlink--;
    80004af4:	04a4d783          	lhu	a5,74(s1)
    80004af8:	37fd                	addiw	a5,a5,-1
    80004afa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004afe:	8526                	mv	a0,s1
    80004b00:	ffffe097          	auipc	ra,0xffffe
    80004b04:	fe8080e7          	jalr	-24(ra) # 80002ae8 <iupdate>
    80004b08:	b781                	j	80004a48 <sys_unlink+0xe0>
    return -1;
    80004b0a:	557d                	li	a0,-1
    80004b0c:	a005                	j	80004b2c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b0e:	854a                	mv	a0,s2
    80004b10:	ffffe097          	auipc	ra,0xffffe
    80004b14:	306080e7          	jalr	774(ra) # 80002e16 <iunlockput>
  iunlockput(dp);
    80004b18:	8526                	mv	a0,s1
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	2fc080e7          	jalr	764(ra) # 80002e16 <iunlockput>
  end_op();
    80004b22:	fffff097          	auipc	ra,0xfffff
    80004b26:	aec080e7          	jalr	-1300(ra) # 8000360e <end_op>
  return -1;
    80004b2a:	557d                	li	a0,-1
}
    80004b2c:	70ae                	ld	ra,232(sp)
    80004b2e:	740e                	ld	s0,224(sp)
    80004b30:	64ee                	ld	s1,216(sp)
    80004b32:	694e                	ld	s2,208(sp)
    80004b34:	69ae                	ld	s3,200(sp)
    80004b36:	616d                	addi	sp,sp,240
    80004b38:	8082                	ret

0000000080004b3a <sys_open>:

uint64
sys_open(void)
{
    80004b3a:	7131                	addi	sp,sp,-192
    80004b3c:	fd06                	sd	ra,184(sp)
    80004b3e:	f922                	sd	s0,176(sp)
    80004b40:	f526                	sd	s1,168(sp)
    80004b42:	f14a                	sd	s2,160(sp)
    80004b44:	ed4e                	sd	s3,152(sp)
    80004b46:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b48:	08000613          	li	a2,128
    80004b4c:	f5040593          	addi	a1,s0,-176
    80004b50:	4501                	li	a0,0
    80004b52:	ffffd097          	auipc	ra,0xffffd
    80004b56:	47e080e7          	jalr	1150(ra) # 80001fd0 <argstr>
    return -1;
    80004b5a:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b5c:	0c054163          	bltz	a0,80004c1e <sys_open+0xe4>
    80004b60:	f4c40593          	addi	a1,s0,-180
    80004b64:	4505                	li	a0,1
    80004b66:	ffffd097          	auipc	ra,0xffffd
    80004b6a:	426080e7          	jalr	1062(ra) # 80001f8c <argint>
    80004b6e:	0a054863          	bltz	a0,80004c1e <sys_open+0xe4>

  begin_op();
    80004b72:	fffff097          	auipc	ra,0xfffff
    80004b76:	a1e080e7          	jalr	-1506(ra) # 80003590 <begin_op>

  if(omode & O_CREATE){
    80004b7a:	f4c42783          	lw	a5,-180(s0)
    80004b7e:	2007f793          	andi	a5,a5,512
    80004b82:	cbdd                	beqz	a5,80004c38 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b84:	4681                	li	a3,0
    80004b86:	4601                	li	a2,0
    80004b88:	4589                	li	a1,2
    80004b8a:	f5040513          	addi	a0,s0,-176
    80004b8e:	00000097          	auipc	ra,0x0
    80004b92:	970080e7          	jalr	-1680(ra) # 800044fe <create>
    80004b96:	892a                	mv	s2,a0
    if(ip == 0){
    80004b98:	c959                	beqz	a0,80004c2e <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b9a:	04491703          	lh	a4,68(s2)
    80004b9e:	478d                	li	a5,3
    80004ba0:	00f71763          	bne	a4,a5,80004bae <sys_open+0x74>
    80004ba4:	04695703          	lhu	a4,70(s2)
    80004ba8:	47a5                	li	a5,9
    80004baa:	0ce7ec63          	bltu	a5,a4,80004c82 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bae:	fffff097          	auipc	ra,0xfffff
    80004bb2:	dee080e7          	jalr	-530(ra) # 8000399c <filealloc>
    80004bb6:	89aa                	mv	s3,a0
    80004bb8:	10050263          	beqz	a0,80004cbc <sys_open+0x182>
    80004bbc:	00000097          	auipc	ra,0x0
    80004bc0:	900080e7          	jalr	-1792(ra) # 800044bc <fdalloc>
    80004bc4:	84aa                	mv	s1,a0
    80004bc6:	0e054663          	bltz	a0,80004cb2 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bca:	04491703          	lh	a4,68(s2)
    80004bce:	478d                	li	a5,3
    80004bd0:	0cf70463          	beq	a4,a5,80004c98 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bd4:	4789                	li	a5,2
    80004bd6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bda:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bde:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004be2:	f4c42783          	lw	a5,-180(s0)
    80004be6:	0017c713          	xori	a4,a5,1
    80004bea:	8b05                	andi	a4,a4,1
    80004bec:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bf0:	0037f713          	andi	a4,a5,3
    80004bf4:	00e03733          	snez	a4,a4
    80004bf8:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bfc:	4007f793          	andi	a5,a5,1024
    80004c00:	c791                	beqz	a5,80004c0c <sys_open+0xd2>
    80004c02:	04491703          	lh	a4,68(s2)
    80004c06:	4789                	li	a5,2
    80004c08:	08f70f63          	beq	a4,a5,80004ca6 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c0c:	854a                	mv	a0,s2
    80004c0e:	ffffe097          	auipc	ra,0xffffe
    80004c12:	068080e7          	jalr	104(ra) # 80002c76 <iunlock>
  end_op();
    80004c16:	fffff097          	auipc	ra,0xfffff
    80004c1a:	9f8080e7          	jalr	-1544(ra) # 8000360e <end_op>

  return fd;
}
    80004c1e:	8526                	mv	a0,s1
    80004c20:	70ea                	ld	ra,184(sp)
    80004c22:	744a                	ld	s0,176(sp)
    80004c24:	74aa                	ld	s1,168(sp)
    80004c26:	790a                	ld	s2,160(sp)
    80004c28:	69ea                	ld	s3,152(sp)
    80004c2a:	6129                	addi	sp,sp,192
    80004c2c:	8082                	ret
      end_op();
    80004c2e:	fffff097          	auipc	ra,0xfffff
    80004c32:	9e0080e7          	jalr	-1568(ra) # 8000360e <end_op>
      return -1;
    80004c36:	b7e5                	j	80004c1e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c38:	f5040513          	addi	a0,s0,-176
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	734080e7          	jalr	1844(ra) # 80003370 <namei>
    80004c44:	892a                	mv	s2,a0
    80004c46:	c905                	beqz	a0,80004c76 <sys_open+0x13c>
    ilock(ip);
    80004c48:	ffffe097          	auipc	ra,0xffffe
    80004c4c:	f6c080e7          	jalr	-148(ra) # 80002bb4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c50:	04491703          	lh	a4,68(s2)
    80004c54:	4785                	li	a5,1
    80004c56:	f4f712e3          	bne	a4,a5,80004b9a <sys_open+0x60>
    80004c5a:	f4c42783          	lw	a5,-180(s0)
    80004c5e:	dba1                	beqz	a5,80004bae <sys_open+0x74>
      iunlockput(ip);
    80004c60:	854a                	mv	a0,s2
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	1b4080e7          	jalr	436(ra) # 80002e16 <iunlockput>
      end_op();
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	9a4080e7          	jalr	-1628(ra) # 8000360e <end_op>
      return -1;
    80004c72:	54fd                	li	s1,-1
    80004c74:	b76d                	j	80004c1e <sys_open+0xe4>
      end_op();
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	998080e7          	jalr	-1640(ra) # 8000360e <end_op>
      return -1;
    80004c7e:	54fd                	li	s1,-1
    80004c80:	bf79                	j	80004c1e <sys_open+0xe4>
    iunlockput(ip);
    80004c82:	854a                	mv	a0,s2
    80004c84:	ffffe097          	auipc	ra,0xffffe
    80004c88:	192080e7          	jalr	402(ra) # 80002e16 <iunlockput>
    end_op();
    80004c8c:	fffff097          	auipc	ra,0xfffff
    80004c90:	982080e7          	jalr	-1662(ra) # 8000360e <end_op>
    return -1;
    80004c94:	54fd                	li	s1,-1
    80004c96:	b761                	j	80004c1e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c98:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c9c:	04691783          	lh	a5,70(s2)
    80004ca0:	02f99223          	sh	a5,36(s3)
    80004ca4:	bf2d                	j	80004bde <sys_open+0xa4>
    itrunc(ip);
    80004ca6:	854a                	mv	a0,s2
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	01a080e7          	jalr	26(ra) # 80002cc2 <itrunc>
    80004cb0:	bfb1                	j	80004c0c <sys_open+0xd2>
      fileclose(f);
    80004cb2:	854e                	mv	a0,s3
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	da4080e7          	jalr	-604(ra) # 80003a58 <fileclose>
    iunlockput(ip);
    80004cbc:	854a                	mv	a0,s2
    80004cbe:	ffffe097          	auipc	ra,0xffffe
    80004cc2:	158080e7          	jalr	344(ra) # 80002e16 <iunlockput>
    end_op();
    80004cc6:	fffff097          	auipc	ra,0xfffff
    80004cca:	948080e7          	jalr	-1720(ra) # 8000360e <end_op>
    return -1;
    80004cce:	54fd                	li	s1,-1
    80004cd0:	b7b9                	j	80004c1e <sys_open+0xe4>

0000000080004cd2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cd2:	7175                	addi	sp,sp,-144
    80004cd4:	e506                	sd	ra,136(sp)
    80004cd6:	e122                	sd	s0,128(sp)
    80004cd8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cda:	fffff097          	auipc	ra,0xfffff
    80004cde:	8b6080e7          	jalr	-1866(ra) # 80003590 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ce2:	08000613          	li	a2,128
    80004ce6:	f7040593          	addi	a1,s0,-144
    80004cea:	4501                	li	a0,0
    80004cec:	ffffd097          	auipc	ra,0xffffd
    80004cf0:	2e4080e7          	jalr	740(ra) # 80001fd0 <argstr>
    80004cf4:	02054963          	bltz	a0,80004d26 <sys_mkdir+0x54>
    80004cf8:	4681                	li	a3,0
    80004cfa:	4601                	li	a2,0
    80004cfc:	4585                	li	a1,1
    80004cfe:	f7040513          	addi	a0,s0,-144
    80004d02:	fffff097          	auipc	ra,0xfffff
    80004d06:	7fc080e7          	jalr	2044(ra) # 800044fe <create>
    80004d0a:	cd11                	beqz	a0,80004d26 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d0c:	ffffe097          	auipc	ra,0xffffe
    80004d10:	10a080e7          	jalr	266(ra) # 80002e16 <iunlockput>
  end_op();
    80004d14:	fffff097          	auipc	ra,0xfffff
    80004d18:	8fa080e7          	jalr	-1798(ra) # 8000360e <end_op>
  return 0;
    80004d1c:	4501                	li	a0,0
}
    80004d1e:	60aa                	ld	ra,136(sp)
    80004d20:	640a                	ld	s0,128(sp)
    80004d22:	6149                	addi	sp,sp,144
    80004d24:	8082                	ret
    end_op();
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	8e8080e7          	jalr	-1816(ra) # 8000360e <end_op>
    return -1;
    80004d2e:	557d                	li	a0,-1
    80004d30:	b7fd                	j	80004d1e <sys_mkdir+0x4c>

0000000080004d32 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d32:	7135                	addi	sp,sp,-160
    80004d34:	ed06                	sd	ra,152(sp)
    80004d36:	e922                	sd	s0,144(sp)
    80004d38:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d3a:	fffff097          	auipc	ra,0xfffff
    80004d3e:	856080e7          	jalr	-1962(ra) # 80003590 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d42:	08000613          	li	a2,128
    80004d46:	f7040593          	addi	a1,s0,-144
    80004d4a:	4501                	li	a0,0
    80004d4c:	ffffd097          	auipc	ra,0xffffd
    80004d50:	284080e7          	jalr	644(ra) # 80001fd0 <argstr>
    80004d54:	04054a63          	bltz	a0,80004da8 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d58:	f6c40593          	addi	a1,s0,-148
    80004d5c:	4505                	li	a0,1
    80004d5e:	ffffd097          	auipc	ra,0xffffd
    80004d62:	22e080e7          	jalr	558(ra) # 80001f8c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d66:	04054163          	bltz	a0,80004da8 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d6a:	f6840593          	addi	a1,s0,-152
    80004d6e:	4509                	li	a0,2
    80004d70:	ffffd097          	auipc	ra,0xffffd
    80004d74:	21c080e7          	jalr	540(ra) # 80001f8c <argint>
     argint(1, &major) < 0 ||
    80004d78:	02054863          	bltz	a0,80004da8 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d7c:	f6841683          	lh	a3,-152(s0)
    80004d80:	f6c41603          	lh	a2,-148(s0)
    80004d84:	458d                	li	a1,3
    80004d86:	f7040513          	addi	a0,s0,-144
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	774080e7          	jalr	1908(ra) # 800044fe <create>
     argint(2, &minor) < 0 ||
    80004d92:	c919                	beqz	a0,80004da8 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d94:	ffffe097          	auipc	ra,0xffffe
    80004d98:	082080e7          	jalr	130(ra) # 80002e16 <iunlockput>
  end_op();
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	872080e7          	jalr	-1934(ra) # 8000360e <end_op>
  return 0;
    80004da4:	4501                	li	a0,0
    80004da6:	a031                	j	80004db2 <sys_mknod+0x80>
    end_op();
    80004da8:	fffff097          	auipc	ra,0xfffff
    80004dac:	866080e7          	jalr	-1946(ra) # 8000360e <end_op>
    return -1;
    80004db0:	557d                	li	a0,-1
}
    80004db2:	60ea                	ld	ra,152(sp)
    80004db4:	644a                	ld	s0,144(sp)
    80004db6:	610d                	addi	sp,sp,160
    80004db8:	8082                	ret

0000000080004dba <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dba:	7135                	addi	sp,sp,-160
    80004dbc:	ed06                	sd	ra,152(sp)
    80004dbe:	e922                	sd	s0,144(sp)
    80004dc0:	e526                	sd	s1,136(sp)
    80004dc2:	e14a                	sd	s2,128(sp)
    80004dc4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dc6:	ffffc097          	auipc	ra,0xffffc
    80004dca:	07e080e7          	jalr	126(ra) # 80000e44 <myproc>
    80004dce:	892a                	mv	s2,a0
  
  begin_op();
    80004dd0:	ffffe097          	auipc	ra,0xffffe
    80004dd4:	7c0080e7          	jalr	1984(ra) # 80003590 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dd8:	08000613          	li	a2,128
    80004ddc:	f6040593          	addi	a1,s0,-160
    80004de0:	4501                	li	a0,0
    80004de2:	ffffd097          	auipc	ra,0xffffd
    80004de6:	1ee080e7          	jalr	494(ra) # 80001fd0 <argstr>
    80004dea:	04054b63          	bltz	a0,80004e40 <sys_chdir+0x86>
    80004dee:	f6040513          	addi	a0,s0,-160
    80004df2:	ffffe097          	auipc	ra,0xffffe
    80004df6:	57e080e7          	jalr	1406(ra) # 80003370 <namei>
    80004dfa:	84aa                	mv	s1,a0
    80004dfc:	c131                	beqz	a0,80004e40 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004dfe:	ffffe097          	auipc	ra,0xffffe
    80004e02:	db6080e7          	jalr	-586(ra) # 80002bb4 <ilock>
  if(ip->type != T_DIR){
    80004e06:	04449703          	lh	a4,68(s1)
    80004e0a:	4785                	li	a5,1
    80004e0c:	04f71063          	bne	a4,a5,80004e4c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e10:	8526                	mv	a0,s1
    80004e12:	ffffe097          	auipc	ra,0xffffe
    80004e16:	e64080e7          	jalr	-412(ra) # 80002c76 <iunlock>
  iput(p->cwd);
    80004e1a:	15093503          	ld	a0,336(s2)
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	f50080e7          	jalr	-176(ra) # 80002d6e <iput>
  end_op();
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	7e8080e7          	jalr	2024(ra) # 8000360e <end_op>
  p->cwd = ip;
    80004e2e:	14993823          	sd	s1,336(s2)
  return 0;
    80004e32:	4501                	li	a0,0
}
    80004e34:	60ea                	ld	ra,152(sp)
    80004e36:	644a                	ld	s0,144(sp)
    80004e38:	64aa                	ld	s1,136(sp)
    80004e3a:	690a                	ld	s2,128(sp)
    80004e3c:	610d                	addi	sp,sp,160
    80004e3e:	8082                	ret
    end_op();
    80004e40:	ffffe097          	auipc	ra,0xffffe
    80004e44:	7ce080e7          	jalr	1998(ra) # 8000360e <end_op>
    return -1;
    80004e48:	557d                	li	a0,-1
    80004e4a:	b7ed                	j	80004e34 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e4c:	8526                	mv	a0,s1
    80004e4e:	ffffe097          	auipc	ra,0xffffe
    80004e52:	fc8080e7          	jalr	-56(ra) # 80002e16 <iunlockput>
    end_op();
    80004e56:	ffffe097          	auipc	ra,0xffffe
    80004e5a:	7b8080e7          	jalr	1976(ra) # 8000360e <end_op>
    return -1;
    80004e5e:	557d                	li	a0,-1
    80004e60:	bfd1                	j	80004e34 <sys_chdir+0x7a>

0000000080004e62 <sys_exec>:

uint64
sys_exec(void)
{
    80004e62:	7145                	addi	sp,sp,-464
    80004e64:	e786                	sd	ra,456(sp)
    80004e66:	e3a2                	sd	s0,448(sp)
    80004e68:	ff26                	sd	s1,440(sp)
    80004e6a:	fb4a                	sd	s2,432(sp)
    80004e6c:	f74e                	sd	s3,424(sp)
    80004e6e:	f352                	sd	s4,416(sp)
    80004e70:	ef56                	sd	s5,408(sp)
    80004e72:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e74:	08000613          	li	a2,128
    80004e78:	f4040593          	addi	a1,s0,-192
    80004e7c:	4501                	li	a0,0
    80004e7e:	ffffd097          	auipc	ra,0xffffd
    80004e82:	152080e7          	jalr	338(ra) # 80001fd0 <argstr>
    return -1;
    80004e86:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e88:	0c054b63          	bltz	a0,80004f5e <sys_exec+0xfc>
    80004e8c:	e3840593          	addi	a1,s0,-456
    80004e90:	4505                	li	a0,1
    80004e92:	ffffd097          	auipc	ra,0xffffd
    80004e96:	11c080e7          	jalr	284(ra) # 80001fae <argaddr>
    80004e9a:	0c054263          	bltz	a0,80004f5e <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004e9e:	10000613          	li	a2,256
    80004ea2:	4581                	li	a1,0
    80004ea4:	e4040513          	addi	a0,s0,-448
    80004ea8:	ffffb097          	auipc	ra,0xffffb
    80004eac:	2d2080e7          	jalr	722(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004eb0:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004eb4:	89a6                	mv	s3,s1
    80004eb6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004eb8:	02000a13          	li	s4,32
    80004ebc:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ec0:	00391513          	slli	a0,s2,0x3
    80004ec4:	e3040593          	addi	a1,s0,-464
    80004ec8:	e3843783          	ld	a5,-456(s0)
    80004ecc:	953e                	add	a0,a0,a5
    80004ece:	ffffd097          	auipc	ra,0xffffd
    80004ed2:	024080e7          	jalr	36(ra) # 80001ef2 <fetchaddr>
    80004ed6:	02054a63          	bltz	a0,80004f0a <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004eda:	e3043783          	ld	a5,-464(s0)
    80004ede:	c3b9                	beqz	a5,80004f24 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ee0:	ffffb097          	auipc	ra,0xffffb
    80004ee4:	23a080e7          	jalr	570(ra) # 8000011a <kalloc>
    80004ee8:	85aa                	mv	a1,a0
    80004eea:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004eee:	cd11                	beqz	a0,80004f0a <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ef0:	6605                	lui	a2,0x1
    80004ef2:	e3043503          	ld	a0,-464(s0)
    80004ef6:	ffffd097          	auipc	ra,0xffffd
    80004efa:	04e080e7          	jalr	78(ra) # 80001f44 <fetchstr>
    80004efe:	00054663          	bltz	a0,80004f0a <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f02:	0905                	addi	s2,s2,1
    80004f04:	09a1                	addi	s3,s3,8
    80004f06:	fb491be3          	bne	s2,s4,80004ebc <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f0a:	f4040913          	addi	s2,s0,-192
    80004f0e:	6088                	ld	a0,0(s1)
    80004f10:	c531                	beqz	a0,80004f5c <sys_exec+0xfa>
    kfree(argv[i]);
    80004f12:	ffffb097          	auipc	ra,0xffffb
    80004f16:	10a080e7          	jalr	266(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f1a:	04a1                	addi	s1,s1,8
    80004f1c:	ff2499e3          	bne	s1,s2,80004f0e <sys_exec+0xac>
  return -1;
    80004f20:	597d                	li	s2,-1
    80004f22:	a835                	j	80004f5e <sys_exec+0xfc>
      argv[i] = 0;
    80004f24:	0a8e                	slli	s5,s5,0x3
    80004f26:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    80004f2a:	00878ab3          	add	s5,a5,s0
    80004f2e:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f32:	e4040593          	addi	a1,s0,-448
    80004f36:	f4040513          	addi	a0,s0,-192
    80004f3a:	fffff097          	auipc	ra,0xfffff
    80004f3e:	172080e7          	jalr	370(ra) # 800040ac <exec>
    80004f42:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f44:	f4040993          	addi	s3,s0,-192
    80004f48:	6088                	ld	a0,0(s1)
    80004f4a:	c911                	beqz	a0,80004f5e <sys_exec+0xfc>
    kfree(argv[i]);
    80004f4c:	ffffb097          	auipc	ra,0xffffb
    80004f50:	0d0080e7          	jalr	208(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f54:	04a1                	addi	s1,s1,8
    80004f56:	ff3499e3          	bne	s1,s3,80004f48 <sys_exec+0xe6>
    80004f5a:	a011                	j	80004f5e <sys_exec+0xfc>
  return -1;
    80004f5c:	597d                	li	s2,-1
}
    80004f5e:	854a                	mv	a0,s2
    80004f60:	60be                	ld	ra,456(sp)
    80004f62:	641e                	ld	s0,448(sp)
    80004f64:	74fa                	ld	s1,440(sp)
    80004f66:	795a                	ld	s2,432(sp)
    80004f68:	79ba                	ld	s3,424(sp)
    80004f6a:	7a1a                	ld	s4,416(sp)
    80004f6c:	6afa                	ld	s5,408(sp)
    80004f6e:	6179                	addi	sp,sp,464
    80004f70:	8082                	ret

0000000080004f72 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f72:	7139                	addi	sp,sp,-64
    80004f74:	fc06                	sd	ra,56(sp)
    80004f76:	f822                	sd	s0,48(sp)
    80004f78:	f426                	sd	s1,40(sp)
    80004f7a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f7c:	ffffc097          	auipc	ra,0xffffc
    80004f80:	ec8080e7          	jalr	-312(ra) # 80000e44 <myproc>
    80004f84:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f86:	fd840593          	addi	a1,s0,-40
    80004f8a:	4501                	li	a0,0
    80004f8c:	ffffd097          	auipc	ra,0xffffd
    80004f90:	022080e7          	jalr	34(ra) # 80001fae <argaddr>
    return -1;
    80004f94:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f96:	0e054063          	bltz	a0,80005076 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f9a:	fc840593          	addi	a1,s0,-56
    80004f9e:	fd040513          	addi	a0,s0,-48
    80004fa2:	fffff097          	auipc	ra,0xfffff
    80004fa6:	de6080e7          	jalr	-538(ra) # 80003d88 <pipealloc>
    return -1;
    80004faa:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fac:	0c054563          	bltz	a0,80005076 <sys_pipe+0x104>
  fd0 = -1;
    80004fb0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fb4:	fd043503          	ld	a0,-48(s0)
    80004fb8:	fffff097          	auipc	ra,0xfffff
    80004fbc:	504080e7          	jalr	1284(ra) # 800044bc <fdalloc>
    80004fc0:	fca42223          	sw	a0,-60(s0)
    80004fc4:	08054c63          	bltz	a0,8000505c <sys_pipe+0xea>
    80004fc8:	fc843503          	ld	a0,-56(s0)
    80004fcc:	fffff097          	auipc	ra,0xfffff
    80004fd0:	4f0080e7          	jalr	1264(ra) # 800044bc <fdalloc>
    80004fd4:	fca42023          	sw	a0,-64(s0)
    80004fd8:	06054963          	bltz	a0,8000504a <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fdc:	4691                	li	a3,4
    80004fde:	fc440613          	addi	a2,s0,-60
    80004fe2:	fd843583          	ld	a1,-40(s0)
    80004fe6:	68a8                	ld	a0,80(s1)
    80004fe8:	ffffc097          	auipc	ra,0xffffc
    80004fec:	b20080e7          	jalr	-1248(ra) # 80000b08 <copyout>
    80004ff0:	02054063          	bltz	a0,80005010 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004ff4:	4691                	li	a3,4
    80004ff6:	fc040613          	addi	a2,s0,-64
    80004ffa:	fd843583          	ld	a1,-40(s0)
    80004ffe:	0591                	addi	a1,a1,4
    80005000:	68a8                	ld	a0,80(s1)
    80005002:	ffffc097          	auipc	ra,0xffffc
    80005006:	b06080e7          	jalr	-1274(ra) # 80000b08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000500a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000500c:	06055563          	bgez	a0,80005076 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005010:	fc442783          	lw	a5,-60(s0)
    80005014:	07e9                	addi	a5,a5,26
    80005016:	078e                	slli	a5,a5,0x3
    80005018:	97a6                	add	a5,a5,s1
    8000501a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000501e:	fc042783          	lw	a5,-64(s0)
    80005022:	07e9                	addi	a5,a5,26
    80005024:	078e                	slli	a5,a5,0x3
    80005026:	00f48533          	add	a0,s1,a5
    8000502a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000502e:	fd043503          	ld	a0,-48(s0)
    80005032:	fffff097          	auipc	ra,0xfffff
    80005036:	a26080e7          	jalr	-1498(ra) # 80003a58 <fileclose>
    fileclose(wf);
    8000503a:	fc843503          	ld	a0,-56(s0)
    8000503e:	fffff097          	auipc	ra,0xfffff
    80005042:	a1a080e7          	jalr	-1510(ra) # 80003a58 <fileclose>
    return -1;
    80005046:	57fd                	li	a5,-1
    80005048:	a03d                	j	80005076 <sys_pipe+0x104>
    if(fd0 >= 0)
    8000504a:	fc442783          	lw	a5,-60(s0)
    8000504e:	0007c763          	bltz	a5,8000505c <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005052:	07e9                	addi	a5,a5,26
    80005054:	078e                	slli	a5,a5,0x3
    80005056:	97a6                	add	a5,a5,s1
    80005058:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000505c:	fd043503          	ld	a0,-48(s0)
    80005060:	fffff097          	auipc	ra,0xfffff
    80005064:	9f8080e7          	jalr	-1544(ra) # 80003a58 <fileclose>
    fileclose(wf);
    80005068:	fc843503          	ld	a0,-56(s0)
    8000506c:	fffff097          	auipc	ra,0xfffff
    80005070:	9ec080e7          	jalr	-1556(ra) # 80003a58 <fileclose>
    return -1;
    80005074:	57fd                	li	a5,-1
}
    80005076:	853e                	mv	a0,a5
    80005078:	70e2                	ld	ra,56(sp)
    8000507a:	7442                	ld	s0,48(sp)
    8000507c:	74a2                	ld	s1,40(sp)
    8000507e:	6121                	addi	sp,sp,64
    80005080:	8082                	ret
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
    800050d0:	ceffc0ef          	jal	ra,80001dbe <kerneltrap>
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
    8000516c:	cb0080e7          	jalr	-848(ra) # 80000e18 <cpuid>
  
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
    800051a4:	c78080e7          	jalr	-904(ra) # 80000e18 <cpuid>
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
    800051cc:	c50080e7          	jalr	-944(ra) # 80000e18 <cpuid>
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
    80005254:	488080e7          	jalr	1160(ra) # 800016d8 <wakeup>
}
    80005258:	60a2                	ld	ra,8(sp)
    8000525a:	6402                	ld	s0,0(sp)
    8000525c:	0141                	addi	sp,sp,16
    8000525e:	8082                	ret
    panic("free_desc 1");
    80005260:	00003517          	auipc	a0,0x3
    80005264:	49850513          	addi	a0,a0,1176 # 800086f8 <syscalls+0x330>
    80005268:	00001097          	auipc	ra,0x1
    8000526c:	9c8080e7          	jalr	-1592(ra) # 80005c30 <panic>
    panic("free_desc 2");
    80005270:	00003517          	auipc	a0,0x3
    80005274:	49850513          	addi	a0,a0,1176 # 80008708 <syscalls+0x340>
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
    8000528e:	48e58593          	addi	a1,a1,1166 # 80008718 <syscalls+0x350>
    80005292:	00018517          	auipc	a0,0x18
    80005296:	e9650513          	addi	a0,a0,-362 # 8001d128 <disk+0x2128>
    8000529a:	00001097          	auipc	ra,0x1
    8000529e:	ebc080e7          	jalr	-324(ra) # 80006156 <initlock>
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
    80005334:	e4a080e7          	jalr	-438(ra) # 8000017a <memset>
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
    80005396:	39650513          	addi	a0,a0,918 # 80008728 <syscalls+0x360>
    8000539a:	00001097          	auipc	ra,0x1
    8000539e:	896080e7          	jalr	-1898(ra) # 80005c30 <panic>
    panic("virtio disk has no queue 0");
    800053a2:	00003517          	auipc	a0,0x3
    800053a6:	3a650513          	addi	a0,a0,934 # 80008748 <syscalls+0x380>
    800053aa:	00001097          	auipc	ra,0x1
    800053ae:	886080e7          	jalr	-1914(ra) # 80005c30 <panic>
    panic("virtio disk max queue too short");
    800053b2:	00003517          	auipc	a0,0x3
    800053b6:	3b650513          	addi	a0,a0,950 # 80008768 <syscalls+0x3a0>
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
    800053fe:	dec080e7          	jalr	-532(ra) # 800061e6 <acquire>
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
    80005478:	0d8080e7          	jalr	216(ra) # 8000154c <sleep>
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
    80005546:	00a080e7          	jalr	10(ra) # 8000154c <sleep>
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
    8000559e:	d00080e7          	jalr	-768(ra) # 8000629a <release>
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
    80005660:	b8a080e7          	jalr	-1142(ra) # 800061e6 <acquire>
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
    800056ca:	012080e7          	jalr	18(ra) # 800016d8 <wakeup>

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
    800056f2:	bac080e7          	jalr	-1108(ra) # 8000629a <release>
}
    800056f6:	60e2                	ld	ra,24(sp)
    800056f8:	6442                	ld	s0,16(sp)
    800056fa:	64a2                	ld	s1,8(sp)
    800056fc:	6902                	ld	s2,0(sp)
    800056fe:	6105                	addi	sp,sp,32
    80005700:	8082                	ret
      panic("virtio_disk_intr status");
    80005702:	00003517          	auipc	a0,0x3
    80005706:	08650513          	addi	a0,a0,134 # 80008788 <syscalls+0x3c0>
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
    800057a6:	b7e78793          	addi	a5,a5,-1154 # 80000320 <main>
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
    80005824:	126080e7          	jalr	294(ra) # 80001946 <either_copyin>
    80005828:	01550d63          	beq	a0,s5,80005842 <consolewrite+0x4c>
      break;
    uartputc(c);
    8000582c:	fbf44503          	lbu	a0,-65(s0)
    80005830:	00000097          	auipc	ra,0x0
    80005834:	7fc080e7          	jalr	2044(ra) # 8000602c <uartputc>
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
    8000588c:	95e080e7          	jalr	-1698(ra) # 800061e6 <acquire>
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
    800058ba:	58e080e7          	jalr	1422(ra) # 80000e44 <myproc>
    800058be:	551c                	lw	a5,40(a0)
    800058c0:	e7b5                	bnez	a5,8000592c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800058c2:	85a6                	mv	a1,s1
    800058c4:	854a                	mv	a0,s2
    800058c6:	ffffc097          	auipc	ra,0xffffc
    800058ca:	c86080e7          	jalr	-890(ra) # 8000154c <sleep>
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
    80005906:	fee080e7          	jalr	-18(ra) # 800018f0 <either_copyout>
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
    80005922:	97c080e7          	jalr	-1668(ra) # 8000629a <release>

  return target - n;
    80005926:	413b053b          	subw	a0,s6,s3
    8000592a:	a811                	j	8000593e <consoleread+0xe4>
        release(&cons.lock);
    8000592c:	00021517          	auipc	a0,0x21
    80005930:	81450513          	addi	a0,a0,-2028 # 80026140 <cons>
    80005934:	00001097          	auipc	ra,0x1
    80005938:	966080e7          	jalr	-1690(ra) # 8000629a <release>
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
    80005980:	5de080e7          	jalr	1502(ra) # 80005f5a <uartputc_sync>
}
    80005984:	60a2                	ld	ra,8(sp)
    80005986:	6402                	ld	s0,0(sp)
    80005988:	0141                	addi	sp,sp,16
    8000598a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000598c:	4521                	li	a0,8
    8000598e:	00000097          	auipc	ra,0x0
    80005992:	5cc080e7          	jalr	1484(ra) # 80005f5a <uartputc_sync>
    80005996:	02000513          	li	a0,32
    8000599a:	00000097          	auipc	ra,0x0
    8000599e:	5c0080e7          	jalr	1472(ra) # 80005f5a <uartputc_sync>
    800059a2:	4521                	li	a0,8
    800059a4:	00000097          	auipc	ra,0x0
    800059a8:	5b6080e7          	jalr	1462(ra) # 80005f5a <uartputc_sync>
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
    800059c4:	00001097          	auipc	ra,0x1
    800059c8:	822080e7          	jalr	-2014(ra) # 800061e6 <acquire>

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
    800059e6:	fba080e7          	jalr	-70(ra) # 8000199c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059ea:	00020517          	auipc	a0,0x20
    800059ee:	75650513          	addi	a0,a0,1878 # 80026140 <cons>
    800059f2:	00001097          	auipc	ra,0x1
    800059f6:	8a8080e7          	jalr	-1880(ra) # 8000629a <release>
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
    80005b3a:	ba2080e7          	jalr	-1118(ra) # 800016d8 <wakeup>
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
    80005b4c:	c5858593          	addi	a1,a1,-936 # 800087a0 <syscalls+0x3d8>
    80005b50:	00020517          	auipc	a0,0x20
    80005b54:	5f050513          	addi	a0,a0,1520 # 80026140 <cons>
    80005b58:	00000097          	auipc	ra,0x0
    80005b5c:	5fe080e7          	jalr	1534(ra) # 80006156 <initlock>

  uartinit();
    80005b60:	00000097          	auipc	ra,0x0
    80005b64:	3aa080e7          	jalr	938(ra) # 80005f0a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b68:	00014797          	auipc	a5,0x14
    80005b6c:	d6078793          	addi	a5,a5,-672 # 800198c8 <devsw>
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
    80005bae:	c3e60613          	addi	a2,a2,-962 # 800087e8 <digits>
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
    80005c48:	b6450513          	addi	a0,a0,-1180 # 800087a8 <syscalls+0x3e0>
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
    80005cdc:	b10b0b13          	addi	s6,s6,-1264 # 800087e8 <digits>
    switch(c){
    80005ce0:	07300c93          	li	s9,115
    80005ce4:	06400c13          	li	s8,100
    80005ce8:	a82d                	j	80005d22 <printf+0xa8>
    acquire(&pr.lock);
    80005cea:	00020517          	auipc	a0,0x20
    80005cee:	4fe50513          	addi	a0,a0,1278 # 800261e8 <pr>
    80005cf2:	00000097          	auipc	ra,0x0
    80005cf6:	4f4080e7          	jalr	1268(ra) # 800061e6 <acquire>
    80005cfa:	bf7d                	j	80005cb8 <printf+0x3e>
    panic("null fmt");
    80005cfc:	00003517          	auipc	a0,0x3
    80005d00:	abc50513          	addi	a0,a0,-1348 # 800087b8 <syscalls+0x3f0>
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
    80005dfa:	9ba48493          	addi	s1,s1,-1606 # 800087b0 <syscalls+0x3e8>
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
    80005e54:	44a080e7          	jalr	1098(ra) # 8000629a <release>
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
    80005e70:	95c58593          	addi	a1,a1,-1700 # 800087c8 <syscalls+0x400>
    80005e74:	8526                	mv	a0,s1
    80005e76:	00000097          	auipc	ra,0x0
    80005e7a:	2e0080e7          	jalr	736(ra) # 80006156 <initlock>
  pr.locking = 1;
    80005e7e:	4785                	li	a5,1
    80005e80:	cc9c                	sw	a5,24(s1)
}
    80005e82:	60e2                	ld	ra,24(sp)
    80005e84:	6442                	ld	s0,16(sp)
    80005e86:	64a2                	ld	s1,8(sp)
    80005e88:	6105                	addi	sp,sp,32
    80005e8a:	8082                	ret

0000000080005e8c <backtrace>:

void backtrace(void)
{
    80005e8c:	7139                	addi	sp,sp,-64
    80005e8e:	fc06                	sd	ra,56(sp)
    80005e90:	f822                	sd	s0,48(sp)
    80005e92:	f426                	sd	s1,40(sp)
    80005e94:	f04a                	sd	s2,32(sp)
    80005e96:	ec4e                	sd	s3,24(sp)
    80005e98:	e852                	sd	s4,16(sp)
    80005e9a:	e456                	sd	s5,8(sp)
    80005e9c:	0080                	addi	s0,sp,64
	printf("backtrace:\n");
    80005e9e:	00003517          	auipc	a0,0x3
    80005ea2:	93250513          	addi	a0,a0,-1742 # 800087d0 <syscalls+0x408>
    80005ea6:	00000097          	auipc	ra,0x0
    80005eaa:	dd4080e7          	jalr	-556(ra) # 80005c7a <printf>
	struct proc* p = myproc();
    80005eae:	ffffb097          	auipc	ra,0xffffb
    80005eb2:	f96080e7          	jalr	-106(ra) # 80000e44 <myproc>

static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
    80005eb6:	84a2                	mv	s1,s0
	uint64 fp = r_fp();
	while (fp > PGROUNDUP(p->kstack))
    80005eb8:	613c                	ld	a5,64(a0)
    80005eba:	6705                	lui	a4,0x1
    80005ebc:	177d                	addi	a4,a4,-1 # fff <_entry-0x7ffff001>
    80005ebe:	97ba                	add	a5,a5,a4
    80005ec0:	777d                	lui	a4,0xfffff
    80005ec2:	8ff9                	and	a5,a5,a4
    80005ec4:	0297fa63          	bgeu	a5,s1,80005ef8 <backtrace+0x6c>
    80005ec8:	892a                	mv	s2,a0
	{
		printf("%p\n", *(uint64*)(fp - 8));
    80005eca:	00003a97          	auipc	s5,0x3
    80005ece:	916a8a93          	addi	s5,s5,-1770 # 800087e0 <syscalls+0x418>
	while (fp > PGROUNDUP(p->kstack))
    80005ed2:	6985                	lui	s3,0x1
    80005ed4:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005ed6:	7a7d                	lui	s4,0xfffff
		printf("%p\n", *(uint64*)(fp - 8));
    80005ed8:	ff84b583          	ld	a1,-8(s1)
    80005edc:	8556                	mv	a0,s5
    80005ede:	00000097          	auipc	ra,0x0
    80005ee2:	d9c080e7          	jalr	-612(ra) # 80005c7a <printf>
		fp = *(uint64*)(fp - 16);
    80005ee6:	ff04b483          	ld	s1,-16(s1)
	while (fp > PGROUNDUP(p->kstack))
    80005eea:	04093783          	ld	a5,64(s2)
    80005eee:	97ce                	add	a5,a5,s3
    80005ef0:	0147f7b3          	and	a5,a5,s4
    80005ef4:	fe97e2e3          	bltu	a5,s1,80005ed8 <backtrace+0x4c>
	}
}
    80005ef8:	70e2                	ld	ra,56(sp)
    80005efa:	7442                	ld	s0,48(sp)
    80005efc:	74a2                	ld	s1,40(sp)
    80005efe:	7902                	ld	s2,32(sp)
    80005f00:	69e2                	ld	s3,24(sp)
    80005f02:	6a42                	ld	s4,16(sp)
    80005f04:	6aa2                	ld	s5,8(sp)
    80005f06:	6121                	addi	sp,sp,64
    80005f08:	8082                	ret

0000000080005f0a <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f0a:	1141                	addi	sp,sp,-16
    80005f0c:	e406                	sd	ra,8(sp)
    80005f0e:	e022                	sd	s0,0(sp)
    80005f10:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f12:	100007b7          	lui	a5,0x10000
    80005f16:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f1a:	f8000713          	li	a4,-128
    80005f1e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f22:	470d                	li	a4,3
    80005f24:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f28:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f2c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f30:	469d                	li	a3,7
    80005f32:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f36:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f3a:	00003597          	auipc	a1,0x3
    80005f3e:	8c658593          	addi	a1,a1,-1850 # 80008800 <digits+0x18>
    80005f42:	00020517          	auipc	a0,0x20
    80005f46:	2c650513          	addi	a0,a0,710 # 80026208 <uart_tx_lock>
    80005f4a:	00000097          	auipc	ra,0x0
    80005f4e:	20c080e7          	jalr	524(ra) # 80006156 <initlock>
}
    80005f52:	60a2                	ld	ra,8(sp)
    80005f54:	6402                	ld	s0,0(sp)
    80005f56:	0141                	addi	sp,sp,16
    80005f58:	8082                	ret

0000000080005f5a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f5a:	1101                	addi	sp,sp,-32
    80005f5c:	ec06                	sd	ra,24(sp)
    80005f5e:	e822                	sd	s0,16(sp)
    80005f60:	e426                	sd	s1,8(sp)
    80005f62:	1000                	addi	s0,sp,32
    80005f64:	84aa                	mv	s1,a0
  push_off();
    80005f66:	00000097          	auipc	ra,0x0
    80005f6a:	234080e7          	jalr	564(ra) # 8000619a <push_off>

  if(panicked){
    80005f6e:	00003797          	auipc	a5,0x3
    80005f72:	0ae7a783          	lw	a5,174(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f76:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f7a:	c391                	beqz	a5,80005f7e <uartputc_sync+0x24>
    for(;;)
    80005f7c:	a001                	j	80005f7c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f7e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f82:	0207f793          	andi	a5,a5,32
    80005f86:	dfe5                	beqz	a5,80005f7e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f88:	0ff4f513          	zext.b	a0,s1
    80005f8c:	100007b7          	lui	a5,0x10000
    80005f90:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f94:	00000097          	auipc	ra,0x0
    80005f98:	2a6080e7          	jalr	678(ra) # 8000623a <pop_off>
}
    80005f9c:	60e2                	ld	ra,24(sp)
    80005f9e:	6442                	ld	s0,16(sp)
    80005fa0:	64a2                	ld	s1,8(sp)
    80005fa2:	6105                	addi	sp,sp,32
    80005fa4:	8082                	ret

0000000080005fa6 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005fa6:	00003797          	auipc	a5,0x3
    80005faa:	07a7b783          	ld	a5,122(a5) # 80009020 <uart_tx_r>
    80005fae:	00003717          	auipc	a4,0x3
    80005fb2:	07a73703          	ld	a4,122(a4) # 80009028 <uart_tx_w>
    80005fb6:	06f70a63          	beq	a4,a5,8000602a <uartstart+0x84>
{
    80005fba:	7139                	addi	sp,sp,-64
    80005fbc:	fc06                	sd	ra,56(sp)
    80005fbe:	f822                	sd	s0,48(sp)
    80005fc0:	f426                	sd	s1,40(sp)
    80005fc2:	f04a                	sd	s2,32(sp)
    80005fc4:	ec4e                	sd	s3,24(sp)
    80005fc6:	e852                	sd	s4,16(sp)
    80005fc8:	e456                	sd	s5,8(sp)
    80005fca:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fcc:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fd0:	00020a17          	auipc	s4,0x20
    80005fd4:	238a0a13          	addi	s4,s4,568 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fd8:	00003497          	auipc	s1,0x3
    80005fdc:	04848493          	addi	s1,s1,72 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fe0:	00003997          	auipc	s3,0x3
    80005fe4:	04898993          	addi	s3,s3,72 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fe8:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fec:	02077713          	andi	a4,a4,32
    80005ff0:	c705                	beqz	a4,80006018 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ff2:	01f7f713          	andi	a4,a5,31
    80005ff6:	9752                	add	a4,a4,s4
    80005ff8:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005ffc:	0785                	addi	a5,a5,1
    80005ffe:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006000:	8526                	mv	a0,s1
    80006002:	ffffb097          	auipc	ra,0xffffb
    80006006:	6d6080e7          	jalr	1750(ra) # 800016d8 <wakeup>
    
    WriteReg(THR, c);
    8000600a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000600e:	609c                	ld	a5,0(s1)
    80006010:	0009b703          	ld	a4,0(s3)
    80006014:	fcf71ae3          	bne	a4,a5,80005fe8 <uartstart+0x42>
  }
}
    80006018:	70e2                	ld	ra,56(sp)
    8000601a:	7442                	ld	s0,48(sp)
    8000601c:	74a2                	ld	s1,40(sp)
    8000601e:	7902                	ld	s2,32(sp)
    80006020:	69e2                	ld	s3,24(sp)
    80006022:	6a42                	ld	s4,16(sp)
    80006024:	6aa2                	ld	s5,8(sp)
    80006026:	6121                	addi	sp,sp,64
    80006028:	8082                	ret
    8000602a:	8082                	ret

000000008000602c <uartputc>:
{
    8000602c:	7179                	addi	sp,sp,-48
    8000602e:	f406                	sd	ra,40(sp)
    80006030:	f022                	sd	s0,32(sp)
    80006032:	ec26                	sd	s1,24(sp)
    80006034:	e84a                	sd	s2,16(sp)
    80006036:	e44e                	sd	s3,8(sp)
    80006038:	e052                	sd	s4,0(sp)
    8000603a:	1800                	addi	s0,sp,48
    8000603c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000603e:	00020517          	auipc	a0,0x20
    80006042:	1ca50513          	addi	a0,a0,458 # 80026208 <uart_tx_lock>
    80006046:	00000097          	auipc	ra,0x0
    8000604a:	1a0080e7          	jalr	416(ra) # 800061e6 <acquire>
  if(panicked){
    8000604e:	00003797          	auipc	a5,0x3
    80006052:	fce7a783          	lw	a5,-50(a5) # 8000901c <panicked>
    80006056:	c391                	beqz	a5,8000605a <uartputc+0x2e>
    for(;;)
    80006058:	a001                	j	80006058 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000605a:	00003717          	auipc	a4,0x3
    8000605e:	fce73703          	ld	a4,-50(a4) # 80009028 <uart_tx_w>
    80006062:	00003797          	auipc	a5,0x3
    80006066:	fbe7b783          	ld	a5,-66(a5) # 80009020 <uart_tx_r>
    8000606a:	02078793          	addi	a5,a5,32
    8000606e:	02e79b63          	bne	a5,a4,800060a4 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006072:	00020997          	auipc	s3,0x20
    80006076:	19698993          	addi	s3,s3,406 # 80026208 <uart_tx_lock>
    8000607a:	00003497          	auipc	s1,0x3
    8000607e:	fa648493          	addi	s1,s1,-90 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006082:	00003917          	auipc	s2,0x3
    80006086:	fa690913          	addi	s2,s2,-90 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000608a:	85ce                	mv	a1,s3
    8000608c:	8526                	mv	a0,s1
    8000608e:	ffffb097          	auipc	ra,0xffffb
    80006092:	4be080e7          	jalr	1214(ra) # 8000154c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006096:	00093703          	ld	a4,0(s2)
    8000609a:	609c                	ld	a5,0(s1)
    8000609c:	02078793          	addi	a5,a5,32
    800060a0:	fee785e3          	beq	a5,a4,8000608a <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060a4:	00020497          	auipc	s1,0x20
    800060a8:	16448493          	addi	s1,s1,356 # 80026208 <uart_tx_lock>
    800060ac:	01f77793          	andi	a5,a4,31
    800060b0:	97a6                	add	a5,a5,s1
    800060b2:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800060b6:	0705                	addi	a4,a4,1
    800060b8:	00003797          	auipc	a5,0x3
    800060bc:	f6e7b823          	sd	a4,-144(a5) # 80009028 <uart_tx_w>
      uartstart();
    800060c0:	00000097          	auipc	ra,0x0
    800060c4:	ee6080e7          	jalr	-282(ra) # 80005fa6 <uartstart>
      release(&uart_tx_lock);
    800060c8:	8526                	mv	a0,s1
    800060ca:	00000097          	auipc	ra,0x0
    800060ce:	1d0080e7          	jalr	464(ra) # 8000629a <release>
}
    800060d2:	70a2                	ld	ra,40(sp)
    800060d4:	7402                	ld	s0,32(sp)
    800060d6:	64e2                	ld	s1,24(sp)
    800060d8:	6942                	ld	s2,16(sp)
    800060da:	69a2                	ld	s3,8(sp)
    800060dc:	6a02                	ld	s4,0(sp)
    800060de:	6145                	addi	sp,sp,48
    800060e0:	8082                	ret

00000000800060e2 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060e2:	1141                	addi	sp,sp,-16
    800060e4:	e422                	sd	s0,8(sp)
    800060e6:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060e8:	100007b7          	lui	a5,0x10000
    800060ec:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060f0:	8b85                	andi	a5,a5,1
    800060f2:	cb81                	beqz	a5,80006102 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800060f4:	100007b7          	lui	a5,0x10000
    800060f8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800060fc:	6422                	ld	s0,8(sp)
    800060fe:	0141                	addi	sp,sp,16
    80006100:	8082                	ret
    return -1;
    80006102:	557d                	li	a0,-1
    80006104:	bfe5                	j	800060fc <uartgetc+0x1a>

0000000080006106 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006106:	1101                	addi	sp,sp,-32
    80006108:	ec06                	sd	ra,24(sp)
    8000610a:	e822                	sd	s0,16(sp)
    8000610c:	e426                	sd	s1,8(sp)
    8000610e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006110:	54fd                	li	s1,-1
    80006112:	a029                	j	8000611c <uartintr+0x16>
      break;
    consoleintr(c);
    80006114:	00000097          	auipc	ra,0x0
    80006118:	89a080e7          	jalr	-1894(ra) # 800059ae <consoleintr>
    int c = uartgetc();
    8000611c:	00000097          	auipc	ra,0x0
    80006120:	fc6080e7          	jalr	-58(ra) # 800060e2 <uartgetc>
    if(c == -1)
    80006124:	fe9518e3          	bne	a0,s1,80006114 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006128:	00020497          	auipc	s1,0x20
    8000612c:	0e048493          	addi	s1,s1,224 # 80026208 <uart_tx_lock>
    80006130:	8526                	mv	a0,s1
    80006132:	00000097          	auipc	ra,0x0
    80006136:	0b4080e7          	jalr	180(ra) # 800061e6 <acquire>
  uartstart();
    8000613a:	00000097          	auipc	ra,0x0
    8000613e:	e6c080e7          	jalr	-404(ra) # 80005fa6 <uartstart>
  release(&uart_tx_lock);
    80006142:	8526                	mv	a0,s1
    80006144:	00000097          	auipc	ra,0x0
    80006148:	156080e7          	jalr	342(ra) # 8000629a <release>
}
    8000614c:	60e2                	ld	ra,24(sp)
    8000614e:	6442                	ld	s0,16(sp)
    80006150:	64a2                	ld	s1,8(sp)
    80006152:	6105                	addi	sp,sp,32
    80006154:	8082                	ret

0000000080006156 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006156:	1141                	addi	sp,sp,-16
    80006158:	e422                	sd	s0,8(sp)
    8000615a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000615c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000615e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006162:	00053823          	sd	zero,16(a0)
}
    80006166:	6422                	ld	s0,8(sp)
    80006168:	0141                	addi	sp,sp,16
    8000616a:	8082                	ret

000000008000616c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000616c:	411c                	lw	a5,0(a0)
    8000616e:	e399                	bnez	a5,80006174 <holding+0x8>
    80006170:	4501                	li	a0,0
  return r;
}
    80006172:	8082                	ret
{
    80006174:	1101                	addi	sp,sp,-32
    80006176:	ec06                	sd	ra,24(sp)
    80006178:	e822                	sd	s0,16(sp)
    8000617a:	e426                	sd	s1,8(sp)
    8000617c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000617e:	6904                	ld	s1,16(a0)
    80006180:	ffffb097          	auipc	ra,0xffffb
    80006184:	ca8080e7          	jalr	-856(ra) # 80000e28 <mycpu>
    80006188:	40a48533          	sub	a0,s1,a0
    8000618c:	00153513          	seqz	a0,a0
}
    80006190:	60e2                	ld	ra,24(sp)
    80006192:	6442                	ld	s0,16(sp)
    80006194:	64a2                	ld	s1,8(sp)
    80006196:	6105                	addi	sp,sp,32
    80006198:	8082                	ret

000000008000619a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000619a:	1101                	addi	sp,sp,-32
    8000619c:	ec06                	sd	ra,24(sp)
    8000619e:	e822                	sd	s0,16(sp)
    800061a0:	e426                	sd	s1,8(sp)
    800061a2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061a4:	100024f3          	csrr	s1,sstatus
    800061a8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061ac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061ae:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061b2:	ffffb097          	auipc	ra,0xffffb
    800061b6:	c76080e7          	jalr	-906(ra) # 80000e28 <mycpu>
    800061ba:	5d3c                	lw	a5,120(a0)
    800061bc:	cf89                	beqz	a5,800061d6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061be:	ffffb097          	auipc	ra,0xffffb
    800061c2:	c6a080e7          	jalr	-918(ra) # 80000e28 <mycpu>
    800061c6:	5d3c                	lw	a5,120(a0)
    800061c8:	2785                	addiw	a5,a5,1
    800061ca:	dd3c                	sw	a5,120(a0)
}
    800061cc:	60e2                	ld	ra,24(sp)
    800061ce:	6442                	ld	s0,16(sp)
    800061d0:	64a2                	ld	s1,8(sp)
    800061d2:	6105                	addi	sp,sp,32
    800061d4:	8082                	ret
    mycpu()->intena = old;
    800061d6:	ffffb097          	auipc	ra,0xffffb
    800061da:	c52080e7          	jalr	-942(ra) # 80000e28 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061de:	8085                	srli	s1,s1,0x1
    800061e0:	8885                	andi	s1,s1,1
    800061e2:	dd64                	sw	s1,124(a0)
    800061e4:	bfe9                	j	800061be <push_off+0x24>

00000000800061e6 <acquire>:
{
    800061e6:	1101                	addi	sp,sp,-32
    800061e8:	ec06                	sd	ra,24(sp)
    800061ea:	e822                	sd	s0,16(sp)
    800061ec:	e426                	sd	s1,8(sp)
    800061ee:	1000                	addi	s0,sp,32
    800061f0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061f2:	00000097          	auipc	ra,0x0
    800061f6:	fa8080e7          	jalr	-88(ra) # 8000619a <push_off>
  if(holding(lk))
    800061fa:	8526                	mv	a0,s1
    800061fc:	00000097          	auipc	ra,0x0
    80006200:	f70080e7          	jalr	-144(ra) # 8000616c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006204:	4705                	li	a4,1
  if(holding(lk))
    80006206:	e115                	bnez	a0,8000622a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006208:	87ba                	mv	a5,a4
    8000620a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000620e:	2781                	sext.w	a5,a5
    80006210:	ffe5                	bnez	a5,80006208 <acquire+0x22>
  __sync_synchronize();
    80006212:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006216:	ffffb097          	auipc	ra,0xffffb
    8000621a:	c12080e7          	jalr	-1006(ra) # 80000e28 <mycpu>
    8000621e:	e888                	sd	a0,16(s1)
}
    80006220:	60e2                	ld	ra,24(sp)
    80006222:	6442                	ld	s0,16(sp)
    80006224:	64a2                	ld	s1,8(sp)
    80006226:	6105                	addi	sp,sp,32
    80006228:	8082                	ret
    panic("acquire");
    8000622a:	00002517          	auipc	a0,0x2
    8000622e:	5de50513          	addi	a0,a0,1502 # 80008808 <digits+0x20>
    80006232:	00000097          	auipc	ra,0x0
    80006236:	9fe080e7          	jalr	-1538(ra) # 80005c30 <panic>

000000008000623a <pop_off>:

void
pop_off(void)
{
    8000623a:	1141                	addi	sp,sp,-16
    8000623c:	e406                	sd	ra,8(sp)
    8000623e:	e022                	sd	s0,0(sp)
    80006240:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006242:	ffffb097          	auipc	ra,0xffffb
    80006246:	be6080e7          	jalr	-1050(ra) # 80000e28 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000624a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000624e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006250:	e78d                	bnez	a5,8000627a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006252:	5d3c                	lw	a5,120(a0)
    80006254:	02f05b63          	blez	a5,8000628a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006258:	37fd                	addiw	a5,a5,-1
    8000625a:	0007871b          	sext.w	a4,a5
    8000625e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006260:	eb09                	bnez	a4,80006272 <pop_off+0x38>
    80006262:	5d7c                	lw	a5,124(a0)
    80006264:	c799                	beqz	a5,80006272 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006266:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000626a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000626e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006272:	60a2                	ld	ra,8(sp)
    80006274:	6402                	ld	s0,0(sp)
    80006276:	0141                	addi	sp,sp,16
    80006278:	8082                	ret
    panic("pop_off - interruptible");
    8000627a:	00002517          	auipc	a0,0x2
    8000627e:	59650513          	addi	a0,a0,1430 # 80008810 <digits+0x28>
    80006282:	00000097          	auipc	ra,0x0
    80006286:	9ae080e7          	jalr	-1618(ra) # 80005c30 <panic>
    panic("pop_off");
    8000628a:	00002517          	auipc	a0,0x2
    8000628e:	59e50513          	addi	a0,a0,1438 # 80008828 <digits+0x40>
    80006292:	00000097          	auipc	ra,0x0
    80006296:	99e080e7          	jalr	-1634(ra) # 80005c30 <panic>

000000008000629a <release>:
{
    8000629a:	1101                	addi	sp,sp,-32
    8000629c:	ec06                	sd	ra,24(sp)
    8000629e:	e822                	sd	s0,16(sp)
    800062a0:	e426                	sd	s1,8(sp)
    800062a2:	1000                	addi	s0,sp,32
    800062a4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062a6:	00000097          	auipc	ra,0x0
    800062aa:	ec6080e7          	jalr	-314(ra) # 8000616c <holding>
    800062ae:	c115                	beqz	a0,800062d2 <release+0x38>
  lk->cpu = 0;
    800062b0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062b4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062b8:	0f50000f          	fence	iorw,ow
    800062bc:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062c0:	00000097          	auipc	ra,0x0
    800062c4:	f7a080e7          	jalr	-134(ra) # 8000623a <pop_off>
}
    800062c8:	60e2                	ld	ra,24(sp)
    800062ca:	6442                	ld	s0,16(sp)
    800062cc:	64a2                	ld	s1,8(sp)
    800062ce:	6105                	addi	sp,sp,32
    800062d0:	8082                	ret
    panic("release");
    800062d2:	00002517          	auipc	a0,0x2
    800062d6:	55e50513          	addi	a0,a0,1374 # 80008830 <digits+0x48>
    800062da:	00000097          	auipc	ra,0x0
    800062de:	956080e7          	jalr	-1706(ra) # 80005c30 <panic>
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
